autoImport("PveDropItemData")
ServantRecommendItemData = class("ServantRecommendItemData")
local status2Sort = {
  [SceneUser2_pb.ERECOMMEND_STATUS_RECEIVE] = 1,
  [SceneUser2_pb.ERECOMMEND_STATUS_GO] = 2,
  [SceneUser2_pb.ERECOMMEND_STATUS_FINISH] = 3
}
local _ServantID = function()
  return MyselfProxy.Instance:GetMyServantID()
end

function ServantRecommendItemData:ctor(data)
  self.id = data.dwid
  self.staticData = Table_Recommend[data.dwid]
  self.groupID = self.staticData and self.staticData.GroupID
  self.finish_time = data.finishtimes
  self.status = data.status
  if self:IsGroup() then
    self.simpleSortID = status2Sort[self.status]
  end
  self.real_open = data.realopen
  self.card_extra_rewarded = data.card_extra_rewarded
  self:SetSelfRewardData(data.special_rewards)
  self.double = false
end

function ServantRecommendItemData:IsActive()
  if self.staticData then
    local typeCfg = self.staticData.PageType
    for i = 1, #typeCfg do
      if 1 == typeCfg[i] then
        return true
      end
    end
  end
  return false
end

function ServantRecommendItemData:SetSelfRewardData(server_rewards)
  self.rewardList = {}
  local cfg = self.staticData
  if not cfg then
    return
  end
  self:_SetStaticReward(self.rewardList, server_rewards)
  self:_SetStaticReward(self.rewardList, cfg.Reward)
  self:_SetFavorabilityReward(self.rewardList, cfg.Favorability)
  self:_SetBattlePassExpReward(self.rewardList, cfg.BattlePassExp)
  self:_SetCardExtraReward(self.rewardList, cfg.CardExtraReward)
end

function ServantRecommendItemData:SetMultiTaskRewardData(configList)
  self.groupReward = {}
  if not configList or not next(configList) then
    return
  end
  local favorability, battlePassExp = 0, 0
  for i = 1, #configList do
    if configList[i].Favorability and 0 < configList[i].Favorability then
      favorability = favorability + configList[i].Favorability
    end
    if configList[i].BattlePassExp and 0 < configList[i].BattlePassExp then
      battlePassExp = battlePassExp + configList[i].BattlePassExp
    end
    self:_SetStaticReward(self.groupReward, configList[i].Reward)
  end
  self:_SetFavorabilityReward(self.groupReward, favorability)
  self:_SetBattlePassExpReward(self.groupReward, battlePassExp)
  for i = 1, #configList do
    self:_SetCardExtraReward(self.groupReward, configList[i].CardExtraReward)
  end
end

function ServantRecommendItemData:_SetStaticReward(cache_array, reward)
  if not reward then
    return
  end
  if type(reward) == "table" then
    for i = 1, #reward do
      self:_InsertRewardData(reward[i], cache_array, true)
    end
  elseif type(reward) == "number" then
    self:_InsertRewardData(reward, cache_array, true)
  end
end

function ServantRecommendItemData:_SetFavorabilityReward(cache_array, favorability)
  if favorability and 0 < favorability then
    local servantID = MyselfProxy.Instance:GetMyServantID()
    local favorCFG = HappyShopProxy.Instance:GetServantShopMap()
    local itemId = favorCFG and favorCFG[servantID] and favorCFG[servantID].npcFavoriteItemid or 5828
    local itemData = PveDropItemData.new("Reward", itemId)
    if itemData then
      itemData:SetItemNum(favorability)
      if self:CheckReceiveRewardExceptVip() then
        itemData.get = true
      end
    end
    table.insert(cache_array, itemData)
  end
end

function ServantRecommendItemData:_SetBattlePassExpReward(cache_array, battlePassExp)
  if battlePassExp and 0 < battlePassExp then
    local itemId = 184
    local itemData = PveDropItemData.new("Reward", itemId)
    if itemData then
      itemData:SetItemNum(battlePassExp)
      if self:CheckReceiveRewardExceptVip() then
        itemData.get = true
      end
    end
    table.insert(cache_array, itemData)
  end
end

function ServantRecommendItemData:_SetCardExtraReward(cache_array, cardExtraReward)
  if cardExtraReward and 0 < cardExtraReward then
    self:_InsertRewardData(cardExtraReward, cache_array, false)
  end
end

function ServantRecommendItemData:_InsertRewardData(rewardid, array, combine)
  local list = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
  if not list then
    return
  end
  for i = 1, #list do
    local single = list[i]
    if combine then
      local hasAdd = false
      for j = 1, #array do
        local temp = array[j]
        if temp.staticData and temp.staticData.id == single.id then
          temp.num = temp.num + single.num
          hasAdd = true
          break
        end
      end
      if not hasAdd then
        local itemData = PveDropItemData.new("Reward", single.id)
        if itemData then
          local rate, type
          if BranchMgr.IsJapan() then
            rate = single.jp_rate
          else
            rate = single.rate
          end
          if rate then
            itemData:SetRate(rate)
          end
          itemData:SetItemNum(single.num)
          if single.minnum and single.maxnum or rate ~= 10000 then
            type = PveDropItemData.Type.E_Probability
          else
            type = PveDropItemData.Type.E_Normal
          end
          itemData:SetType(type)
          itemData:SetRange(single.minnum, single.maxnum)
          if self:CheckReceiveRewardExceptVip() then
            itemData.get = true
          end
          table.insert(array, itemData)
        end
      end
    else
      local itemData = PveDropItemData.new("Reward", single.id)
      if itemData then
        itemData:SetItemNum(single.num)
        itemData.isVipReward = true
        table.insert(array, itemData)
      end
    end
  end
end

function ServantRecommendItemData:GetRewards()
  return self.rewardList
end

function ServantRecommendItemData:GetGroupRewards()
  if self.groupReward then
  end
  return self.groupReward or {}
end

function ServantRecommendItemData:IsGroup()
  return self.groupID and self.groupID > 0
end

function ServantRecommendItemData:IsDailyKillType()
  return self:IsGroup() and self.groupID == ServantRecommendProxy.GroupTaskID.DailyKillCount
end

function ServantRecommendItemData:IsCurRound()
  if self.groupID == ServantRecommendProxy.GroupTaskID.DailyKillCount then
    return math.round(self.finish_time / 500) == BattleTimeDataProxy.Instance:GetCurRewardRound()
  end
  return false
end

function ServantRecommendItemData:isActiveOpen()
  return self:IsActive() and self.real_open == true
end

function ServantRecommendItemData:SetDouble(bool)
  self.double = bool
end

function ServantRecommendItemData:CheckReceiveRewardExceptVip()
  return self.card_extra_rewarded == false and self.status == ServantRecommendProxy.STATUS.FINISHED
end
