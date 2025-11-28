autoImport("ItemData")
autoImport("AfricanPoringRewardData")
autoImport("AfricanPoringRewardPoolData")
AfricanPoringData = class("AfricanPoringData")

function AfricanPoringData:ctor(activityData)
  self:SetData(activityData)
end

function AfricanPoringData:SetData(activityData)
  if not GameConfig.AfricanPoring or not activityData then
    return
  end
  if GameConfig.AfricanPoring.ActivityType ~= activityData.type then
    return
  end
  self.id = activityData.id
  self.type = activityData.type
  self.startTime = activityData.starttime
  self.startDate = self.startTime and os.date("*t", self.startTime)
  self.endTime = activityData.endtime
  self.endDate = self.endTime and os.date("*t", self.endTime)
end

function AfricanPoringData:GetTimePeriodStr()
  if self.startDate and self.endDate then
    return string.format(ZhString.TimePeriodFormat3, self.startDate.month, self.startDate.day, self.startDate.hour, self.startDate.min, self.endDate.month, self.endDate.day, self.endDate.hour, self.endDate.min)
  end
  return ""
end

function AfricanPoringData:IsActive()
  if not self:GetConfig() then
    return false
  end
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if not (self.startTime and self.endTime) or serverTime < self.startTime or serverTime > self.endTime then
    return false
  end
  return true
end

function AfricanPoringData:GetGroupId()
  return self.id
end

function AfricanPoringData:GetConfig()
  return self.id and GameConfig.AfricanPoring and GameConfig.AfricanPoring.GroupInfo and GameConfig.AfricanPoring.GroupInfo[self.id]
end

function AfricanPoringData:GetGlobalConfig()
  return GameConfig.AfricanPoring
end

function AfricanPoringData:SetShopItems(serverData)
  if not serverData then
    return
  end
  if not self.shopItems then
    self.shopItems = {}
  end
  TableUtility.ArrayClear(self.shopItems)
  local config = self:GetConfig()
  if not config then
    return
  end
  local shopType = config.ShopType
  local shopId = config.ShopId
  if serverData.type ~= config.ShopType or serverData.shopid ~= config.ShopId then
    return
  end
  local shopItems = ShopProxy.Instance:GetConfigByTypeId(shopType, shopId)
  if not shopItems then
    return
  end
  for _, item in pairs(shopItems) do
    table.insert(self.shopItems, item)
  end
  self:SortShopItems()
end

function AfricanPoringData:SortShopItems()
  if not self.shopItems then
    return
  end
  table.sort(self.shopItems, function(a, b)
    local canBuyNumA, _ = HappyShopProxy.Instance:GetCanBuyCount(a)
    local canBuyNumB, _ = HappyShopProxy.Instance:GetCanBuyCount(b)
    local canBuyA = canBuyNumA == nil or 0 < canBuyNumA
    local canBuyB = canBuyNumB == nil or 0 < canBuyNumB
    if canBuyA and canBuyB then
      return a.id < b.id
    elseif canBuyA and not canBuyB then
      return true
    elseif canBuyB and not canBuyA then
      return false
    else
      return a.id < b.id
    end
  end)
end

function AfricanPoringData:GetShopItems()
  return self.shopItems
end

function AfricanPoringData:GetRewardItems()
  return self.rewardItemArray
end

function AfricanPoringData:GetRewardItemById(id)
  if self.rewardItemArray then
    for _, reward in ipairs(self.rewardItemArray) do
      if reward.id == id then
        return reward
      end
    end
  end
end

function AfricanPoringData:GetPoolDatas()
  return self.rewardPoolArray
end

function AfricanPoringData:GetPoolDataByPos(pos)
  return self.rewardPools and self.rewardPools[pos]
end

function AfricanPoringData:CalculateRewardProbability()
  if not self.rewardPoolArray then
    return
  end
  local sum = 0
  for _, pool in ipairs(self.rewardPoolArray) do
    sum = sum + pool:GetWeight()
  end
  for _, pool in ipairs(self.rewardPoolArray) do
    if sum == 0 then
      pool:SetProbability(0)
    else
      pool:SetProbability(pool:GetWeight() / sum)
    end
  end
end

function AfricanPoringData:SetRewardItems(serverData)
  self.rewardItemArray = {}
  self.rewardPools = {}
  self.rewardPoolArray = {}
  self.status = serverData.status
  self.lastStatus = self.status
  self.freeNormalBids = serverData.freenormalcount or 0
  self.nextFreeNormalBidTime = serverData.nextfreenormaltime
  self.nextHit = serverData.lotterycount
  local groupId = self:GetGroupId()
  for _, sData in ipairs(serverData.items) do
    if sData.groupid == groupId then
      local pool = self.rewardPools[sData.pos]
      if not pool then
        pool = AfricanPoringRewardPoolData.new(sData)
        self.rewardPools[pool.pos] = pool
        table.insert(self.rewardPoolArray, pool)
      end
      for _, sItemData in ipairs(sData.items) do
        local rewardItem = self:GetRewardItemById(sItemData.id)
        if not rewardItem then
          local staticData = Table_AfricanPoringReward[sItemData.id]
          rewardItem = AfricanPoringRewardData.new(staticData, sItemData)
          table.insert(self.rewardItemArray, rewardItem)
        end
        pool:AddRewardItem(rewardItem)
      end
      pool:RevealSelectedReward(self.status ~= SceneItem_pb.EAFRICANPORINGSTATUS_UNINIT)
    end
  end
  self:CalculateRewardProbability()
  table.sort(self.rewardPoolArray, function(a, b)
    return a.pos and b.pos and a.pos < b.pos
  end)
  self:SortRewardItems()
end

function AfricanPoringData:UpdateRewardItems(serverData)
  if not self.rewardItemArray or not self.rewardPools then
    return
  end
  local groupId = self:GetGroupId()
  self.lastStatus = self.status
  self.status = serverData.status
  self.freeNormalBids = serverData.freenormalcount or 0
  self.nextHit = serverData.lotterycount
  for _, sData in ipairs(serverData.items) do
    if sData.groupid == groupId then
      local pool = self.rewardPools[sData.pos]
      if pool then
        pool:UpdateServerData(sData)
      end
      for _, sItemData in ipairs(sData.items) do
        local rewardItem = self:GetRewardItemById(sItemData.id)
        if rewardItem then
          rewardItem:SetServerData(sItemData)
        end
      end
      if pool then
        pool:RevealSelectedReward(self.status ~= SceneItem_pb.EAFRICANPORINGSTATUS_UNINIT)
      end
    end
  end
  self:SortRewardItems()
end

function AfricanPoringData:OnReset()
  self.hitPos = nil
  self.lastHitPos = nil
end

function AfricanPoringData:GetOwnedPoolCount()
  local num = 0
  if self.rewardPools then
    for _, pool in pairs(self.rewardPools) do
      if pool:IsPoolHit() then
        num = num + 1
      end
    end
  end
  return num
end

function AfricanPoringData:SortRewardItems()
  if not self.rewardItemArray then
    return
  end
  table.sort(self.rewardItemArray, function(a, b)
    if not a.owned and b.owned then
      return true
    elseif a.owned and not b.owned then
      return false
    elseif a.probability == b.probability then
      return a.id < b.id
    else
      return a.probability < b.probability
    end
  end)
end

function AfricanPoringData:GetNextFreeBidCountdown()
  local h, m, s = 0, 0, 0
  if self.nextFreeNormalBidTime and 0 < self.nextFreeNormalBidTime then
    local timeLeft = self.nextFreeNormalBidTime - ServerTime.CurServerTime() / 1000
    h, m, s = ClientTimeUtil.GetHourMinSec(timeLeft)
  end
  return h, m, s
end

function AfricanPoringData:GetFreeNormalBidNum()
  return self.freeNormalBids or 0
end

function AfricanPoringData:HasFreeBids()
  if self.freeNormalBids and self.freeNormalBids > 0 then
    return true
  end
  return false
end

function AfricanPoringData:GetResetCost()
  local config = self:GetConfig()
  if config and config.ResetCost then
    return config.ResetCost.ItemID, config.ResetCost.ItemNum
  end
end

function AfricanPoringData:GetNormalBidCost()
  local config = self:GetConfig()
  if config and config.NormalCost then
    return config.NormalCost[1], config.NormalCost[2]
  end
end

function AfricanPoringData:GetSafeBidCost()
  local config = self:GetConfig()
  if config and config.LotteryCost then
    local owndCount = self:GetOwnedPoolCount()
    if owndCount and owndCount > #config.LotteryCost then
      owndCount = 0
    end
    local cost = config.LotteryCost[owndCount]
    if cost then
      return cost[1], cost[2]
    end
  end
end

function AfricanPoringData:GetBestRewardItemId()
  local config = self:GetConfig()
  if config then
    return config.BestRewardID
  end
end

function AfricanPoringData:GetBestRewardItemData()
  local bestRewardId = self:GetBestRewardItemId()
  if bestRewardId then
    if not self.bestRewardItemData then
      self.bestRewardItemData = ItemData.new("AfricanPoringRewardData", bestRewardId)
    elseif self.bestRewardItemData.staticData.id ~= bestRewardId then
      self.bestRewardItemData:ResetData("AfricanPoringRewardData", bestRewardId)
    end
  end
  return self.bestRewardItemData
end

function AfricanPoringData:RecvBidResult(serverData)
  if not serverData or not serverData.reward_items then
    return
  end
  local groupId = self:GetGroupId()
  if serverData.groupid ~= groupId then
    return
  end
  self.showRewardItemData = {}
  local rewardItems = {}
  for _, sData in ipairs(serverData.reward_items) do
    local itemData = ItemData.new(sData.guid, sData.id)
    itemData:SetItemNum(sData.count or 1)
    table.insert(rewardItems, itemData)
  end
  self.showRewardItemData.items = rewardItems
  self.showRewardItemData.rewardData = self:GetRewardItemById(serverData.rewardid)
  if serverData.action == SceneItem_pb.EAFRICANPORING_SECURITY and #rewardItems == 0 then
    self.duplicatedSafeBid = true
  else
    self.duplicatedSafeBid = nil
  end
  self.lastHitPos = self.hitPos
  self.hitPos = serverData.hitpos
end

function AfricanPoringData:ClearShowRewardItemQueue()
  self.showRewardItemData = nil
end
