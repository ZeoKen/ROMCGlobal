autoImport("BattlePassRankShowData")
BattlePassProxy = class("BattlePassProxy", pm.Proxy)
BattlePassProxy.Instance = nil
BattlePassProxy.NAME = "BattlePassProxy"
local HasRewardItems = function(rewards)
  return rewards and 0 < #rewards
end
local BuildOverflowRewardItems = function(rewards, rounds)
  if not HasRewardItems(rewards) then
    return nil
  end
  rounds = rounds or 1
  local result = {}
  for i = 1, #rewards do
    local reward = rewards[i]
    if reward and reward.itemid then
      TableUtility.ArrayPushBack(result, {
        itemid = reward.itemid,
        num = (reward.num or 1) * rounds
      })
    end
  end
  return 0 < #result and result or nil
end

function BattlePassProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BattlePassProxy.NAME
  if BattlePassProxy.Instance == nil then
    BattlePassProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function BattlePassProxy:Init()
  if GameConfig.SystemForbid.BattlePass then
    return
  end
end

function BattlePassProxy:ResetStaticData()
  if self.CurServerBattlePassVersion then
    self.CurServerBattlePassVersion = nil
  end
  local server = FunctionLogin.Me():getCurServerData()
  local serverID = server ~= nil and server.linegroup or 1
  if GameConfig.BattlePassServerVersion and GameConfig.BattlePassServerVersion[serverID] then
    self.CurServerBattlePassVersion = GameConfig[GameConfig.BattlePassServerVersion[serverID]]
  end
  if not self.CurServerBattlePassVersion then
    redlog("battle pass version: invalid server id!", serverID)
  end
  self.battlePassTaskMap = {}
  self.battlePassTaskIds = {}
end

function BattlePassProxy:ResetAllData(serverSyncVersion)
  self.inited = false
  RedTipProxy.Instance:RemoveWholeTip(self.WholeRedTipID)
  local versionChanged = false
  if serverSyncVersion then
    if self.currentVersion ~= serverSyncVersion then
      self.currentVersion = serverSyncVersion
      versionChanged = true
    end
  else
    versionChanged = self:CheckSetCurrentVersion()
  end
  if not self.currentVersion then
    redlog("BattlePass 无法找到符合时间范围的战令版本!")
    return false
  end
  Game.Process_Table_BattlePassLevel()
  if versionChanged then
    EventManager.Me():DispatchEvent(BattlePassEvent.VersionChange)
    if not self:InitStaticData() then
      self.currentVersion = nil
      return false
    end
    self.lastUpdateAllRankTime = nil
    self:MarkFriendRankDataDirty()
  end
  self.inited = true
  return true
end

function BattlePassProxy:CheckSetCurrentVersion()
  local version
  for k, v in pairs(self.CurServerBattlePassVersion) do
    version = v
    local startTime, endTime
    if EnvChannel.IsTFBranch() then
      startTime = version.TFVersionStartTime or version.VersionStartTime
      endTime = version.TFVersionEndTime or version.VersionEndTime
    else
      startTime = version.ReleaseVersionStartTime or version.VersionStartTime
      endTime = version.ReleaseVersionEndTime or version.VersionEndTime
    end
    if startTime and endTime and KFCARCameraProxy.Instance:CheckDateValid(startTime, endTime) and self.currentVersion ~= k then
      self.currentVersion = k
      return true
    end
  end
end

function BattlePassProxy:InitStaticData()
  if self.bpInfo then
    TableUtility.TableClear(self.bpInfo)
  else
    self.bpInfo = {}
    self.bpInfo.advLevel = 0
    self.bpInfo.suLevel = 0
    self.bpInfo.normalGet = {}
    self.bpInfo.advGet = {}
    self.bpInfo.suGet = {}
  end
  if not self.currentVersion then
    redlog("BattlePass 未找到重要配置信息: 当前战令版本!")
    return
  end
  redlog("self.currentVersion = ", self.currentVersion)
  self.CurrentBPConfig = self.CurServerBattlePassVersion and self.CurServerBattlePassVersion[self.currentVersion]
  if not self.CurrentBPConfig then
    redlog("BattlePass 未找到重要配置信息: self.CurServerBattlePassVersion")
    return
  end
  self.maxBpLevel = self.CurrentBPConfig.MaxLevel or 0
  self.IdOffset = self.CurrentBPConfig.IdOffset or 0
  self.BattlePassCoin = self.CurrentBPConfig.BattlePassCoin or GameConfig.MoneyId.BattlePassCoin
  self.UpgradeDepositItem = self.CurrentBPConfig.UpgradeDepositItem
  self.overflowRewardLevel = nil
  self.overflowRewardConfig = nil
  if self.UpgradeDepositIds then
    TableUtility.ArrayClear(self.UpgradeDepositIds)
  else
    self.UpgradeDepositIds = {}
  end
  for i = 1, #self.UpgradeDepositItem do
    local depositId = self.UpgradeDepositItem[i].DepositeId
    if depositId then
      TableUtility.ArrayPushBack(self.UpgradeDepositIds, depositId)
    end
  end
  if self.importantLvs then
    TableUtility.ArrayClear(self.importantLvs)
  else
    self.importantLvs = {}
  end
  for i = 1, self.maxBpLevel do
    if self:LevelConfig(i).Important == 1 then
      TableUtility.ArrayPushBack(self.importantLvs, i)
    end
  end
  self:InitOverflowRewardConfig()
  if self.overflowRewardConfig then
    TableUtility.ArrayPushBack(self.importantLvs, self.overflowRewardLevel)
  end
  return true
end

function BattlePassProxy.BPLevel()
  return Game.Myself.data.userdata:Get(UDEnum.BATTLEPASS_LV) or 0
end

function BattlePassProxy:AdvLevel()
  return self.bpInfo and self.bpInfo.advLevel
end

function BattlePassProxy:SuLevel()
  return self.bpInfo and self.bpInfo.suLevel
end

function BattlePassProxy:IsNormalRewardGet(level)
  return self.bpInfo and self.bpInfo.normalGet and 0 ~= TableUtility.ArrayFindIndex(self.bpInfo.normalGet, level) or false
end

function BattlePassProxy:IsAdvRewardGet(level)
  return self.bpInfo and self.bpInfo.advGet and 0 ~= TableUtility.ArrayFindIndex(self.bpInfo.advGet, level) or false
end

function BattlePassProxy:IsSuRewardGet(level)
  return self.bpInfo and self.bpInfo.suGet and 0 ~= TableUtility.ArrayFindIndex(self.bpInfo.suGet, level) or false
end

function BattlePassProxy:IsNormalRewardNotEmpty(level)
  local config = Table_BattlePassLevel[level + self.IdOffset]
  return config and (config.ReplaceRewardItems or config.RewardItems and #config.RewardItems > 0)
end

function BattlePassProxy:IsAdvRewardNotEmpty(level)
  local config = Table_BattlePassLevel[level + self.IdOffset]
  return config and (config.ReplaceProRewardItems or config.ProRewardItems and #config.ProRewardItems > 0)
end

function BattlePassProxy:IsSuRewardNotEmpty(level)
  local config = Table_BattlePassLevel[level + self.IdOffset]
  return config and (config.ReplaceSuperRewardItems or config.SuperRewardItems and #config.SuperRewardItems > 0)
end

function BattlePassProxy:GetNextImportantLv(lv)
  if #self.importantLvs == 0 then
    return 1
  end
  for i = 1, #self.importantLvs do
    if lv < self.importantLvs[i] then
      return self.importantLvs[i]
    end
  end
  return self.importantLvs[#self.importantLvs]
end

function BattlePassProxy:InitOverflowRewardConfig()
  local overflowReward = self.CurrentBPConfig and self.CurrentBPConfig.OverflowReward
  if not (overflowReward and overflowReward.Exp) or overflowReward.Exp <= 0 or 0 >= self.maxBpLevel then
    return
  end
  if not HasRewardItems(overflowReward.RewardItems) and not HasRewardItems(overflowReward.ProRewardItems) and not HasRewardItems(overflowReward.SuperRewardItems) then
    return
  end
  self.overflowRewardLevel = self.maxBpLevel + 1
  self.overflowRewardConfig = {
    Level = self.overflowRewardLevel,
    IsOverflowReward = true,
    Important = 1
  }
  self:RefreshOverflowRewardConfig()
end

function BattlePassProxy:GetOverflowTotalRounds()
  local overflowReward = self.CurrentBPConfig and self.CurrentBPConfig.OverflowReward
  if not (overflowReward and overflowReward.Exp) or overflowReward.Exp <= 0 then
    return 0
  end
  local maxLevelConfig = Table_BattlePassLevel[(self.maxBpLevel or 0) + (self.IdOffset or 0)]
  local maxNeedExp = maxLevelConfig and maxLevelConfig.NeedExp or 0
  local bpExp = Game and Game.Myself and Game.Myself.data and Game.Myself.data.userdata and Game.Myself.data.userdata:Get(UDEnum.BATTLEPASS_EXP) or 0
  return math.floor(math.max(0, bpExp - maxNeedExp) / overflowReward.Exp)
end

function BattlePassProxy:GetOverflowNormalAvailableRounds()
  local getRounds = self.bpInfo and self.bpInfo.overflowRewardLevel or 0
  return math.max(0, self:GetOverflowTotalRounds() - getRounds)
end

function BattlePassProxy:GetOverflowProAvailableRounds()
  local getRounds = self.bpInfo and self.bpInfo.proOverflowRewardLevel or 0
  return math.max(0, self:GetOverflowTotalRounds() - getRounds)
end

function BattlePassProxy:GetOverflowSuperAvailableRounds()
  local getRounds = self.bpInfo and self.bpInfo.superOverflowRewardLevel or 0
  return math.max(0, self:GetOverflowTotalRounds() - getRounds)
end

function BattlePassProxy:RefreshOverflowRewardConfig()
  if not self.overflowRewardConfig then
    return
  end
  local overflowReward = self.CurrentBPConfig and self.CurrentBPConfig.OverflowReward
  if not overflowReward then
    return
  end
  local normalRounds = self:GetOverflowNormalAvailableRounds()
  local proRounds = self:GetOverflowProAvailableRounds()
  local superRounds = self:GetOverflowSuperAvailableRounds()
  self.overflowRewardConfig.RewardItems = BuildOverflowRewardItems(overflowReward.RewardItems, math.max(normalRounds, 1))
  self.overflowRewardConfig.ProRewardItems = BuildOverflowRewardItems(overflowReward.ProRewardItems, math.max(proRounds, 1))
  self.overflowRewardConfig.SuperRewardItems = BuildOverflowRewardItems(overflowReward.SuperRewardItems, math.max(superRounds, 1))
  self.overflowRewardConfig.NormalOverflowAvailable = 0 < normalRounds and HasRewardItems(overflowReward.RewardItems) or false
  self.overflowRewardConfig.ProOverflowAvailable = 0 < proRounds and HasRewardItems(overflowReward.ProRewardItems) or false
  self.overflowRewardConfig.SuperOverflowAvailable = 0 < superRounds and HasRewardItems(overflowReward.SuperRewardItems) or false
end

function BattlePassProxy:GetOverflowRewardConfig()
  self:RefreshOverflowRewardConfig()
  return self.overflowRewardConfig
end

function BattlePassProxy:IsBattlePassUpgradeItem(depositId)
  if not self.inited then
    return false
  end
  return TableUtility.ArrayFindIndex(self.UpgradeDepositIds, depositId) > 0
end

function BattlePassProxy:CheckBattlePassUpgradeDepositForbidShow(depositId)
  if not self.inited then
    local version
    for _, v in pairs(self.CurServerBattlePassVersion) do
      version = v
      version = version.UpgradeDepositItem
      if version then
        for j = 1, #version do
          if version[j].DepositeId == depositId then
            return true
          end
        end
      end
    end
    return false
  end
  if self:IsBattlePassUpgradeItem(depositId) then
    local nextToBuyItems = self:GetUpgradeDepositToBuy(true)
    if nextToBuyItems then
      for i = 1, #nextToBuyItems do
        if nextToBuyItems[i].DepositeId == depositId then
          return false
        end
      end
    end
    return true
  else
    return false
  end
end

function BattlePassProxy:IsUpgradeDepositBought(info)
  if not info then
    return false
  end
  local advReach = info.AdvLevel and self:AdvLevel() >= info.AdvLevel
  local suReach = info.SuLevel and self:SuLevel() >= info.SuLevel
  local hasLevel = info.AdvLevel ~= nil or info.SuLevel ~= nil
  if hasLevel and advReach ~= false and suReach ~= false then
    return true
  end
  if info.DepositeId then
    local buyTimes = NewRechargeProxy.Ins:Deposit_GetLuckyBagPurchaseTimes(info.DepositeId)
    return buyTimes and 0 < buyTimes or false
  elseif info.ShopType and info.ShopId and info.ShopItemId then
    local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(info.ShopType, info.ShopId, info.ShopItemId)
    if shopItemData then
      local buyCount = shopItemData.sum_count or shopItemData.accAreadyBuyCount or 0
      return 0 < buyCount
    end
  end
  return false
end

function BattlePassProxy:IsUpgradeDepositReachCondition(info)
  if not info then
    return false
  end
  if not info.Condition then
    return true
  end
  if info.Condition.AdvLevel and self:AdvLevel() < info.Condition.AdvLevel then
    return false
  end
  if info.Condition.SuLevel and self:SuLevel() < info.Condition.SuLevel then
    return false
  end
  if info.Condition.Index then
    local condDepositInfo = self.UpgradeDepositItem[info.Condition.Index]
    if not self:IsUpgradeDepositBought(condDepositInfo) then
      return false
    end
  end
  return true
end

function BattlePassProxy:GetUpgradeDepositByShow(show)
  if not self.UpgradeDepositItem then
    return
  end
  for i = 1, #self.UpgradeDepositItem do
    local item = self.UpgradeDepositItem[i]
    if item and item.Show == show then
      return item
    end
  end
end

function BattlePassProxy:IsUpgradeDepositInSale(info)
  if not info then
    return false
  end
  if info.DepositeId then
    return ShopProxy.Instance:IsThisItemCanBuyNow(info.DepositeId)
  elseif info.ShopType and info.ShopId and info.ShopItemId then
    return true
  end
  return false
end

function BattlePassProxy:GetUpgradeDepositToBuy(checkCondition, checkInSale)
  local items, item, reason_notInSale
  if not self.UpgradeDepositItem then
    return
  end
  for i = 1, #self.UpgradeDepositItem do
    item = self.UpgradeDepositItem[i]
    local bought = self:IsUpgradeDepositBought(item)
    if not bought then
      local nextToBuy, inSale = true, true
      if checkCondition then
        nextToBuy = self:IsUpgradeDepositReachCondition(item)
      end
      if checkInSale then
        inSale = self:IsUpgradeDepositInSale(item)
      end
      reason_notInSale = not inSale
      if nextToBuy and inSale then
        items = items or {}
        items[#items + 1] = item
      end
    end
  end
  return items, reason_notInSale
end

function BattlePassProxy:RecvSyncInfoBattlePassCmd(data)
  if GameConfig.SystemForbid.BattlePass then
    return
  end
  if data.version and not self:ResetAllData(data.version) then
    return
  end
  if self.bpInfo then
    TableUtility.TableClear(self.bpInfo)
  else
    self.bpInfo = {}
  end
  self.bpInfo.advLevel = data.pro_level or 0
  self.bpInfo.suLevel = data.su_level or 0
  self.bpInfo.overflowRewardLevel = data.overflow_reward_level or 0
  self.bpInfo.proOverflowRewardLevel = data.pro_overflow_reward_level or 0
  self.bpInfo.superOverflowRewardLevel = data.super_overflow_reward_level or 0
  self.bpInfo.normalGet = {}
  self.bpInfo.advGet = {}
  self.bpInfo.suGet = {}
  if data.rewardlvs then
    for i = 1, #data.rewardlvs do
      TableUtility.ArrayPushBack(self.bpInfo.normalGet, data.rewardlvs[i])
    end
  end
  if data.reward_prolvs then
    for i = 1, #data.reward_prolvs do
      TableUtility.ArrayPushBack(self.bpInfo.advGet, data.reward_prolvs[i])
    end
  end
  if data.reward_sulvs then
    for i = 1, #data.reward_sulvs do
      TableUtility.ArrayPushBack(self.bpInfo.suGet, data.reward_sulvs[i])
    end
  end
  self:RefreshOverflowRewardConfig()
  self:UpdateWholeRedTip()
end

function BattlePassProxy:RecvUpdateRewardBattlePassCmd(data)
  if not self.inited then
    return
  end
  local lv
  if data.levels then
    for i = 1, #data.levels do
      lv = data.levels[i]
      if 0 == TableUtility.ArrayFindIndex(self.bpInfo.normalGet, lv) then
        TableUtility.ArrayPushBack(self.bpInfo.normalGet, lv)
      end
    end
  end
  if data.prolevels then
    for i = 1, #data.prolevels do
      lv = data.prolevels[i]
      if 0 == TableUtility.ArrayFindIndex(self.bpInfo.advGet, lv) then
        TableUtility.ArrayPushBack(self.bpInfo.advGet, lv)
      end
    end
  end
  if data.sulevels then
    for i = 1, #data.sulevels do
      lv = data.sulevels[i]
      if 0 == TableUtility.ArrayFindIndex(self.bpInfo.suGet, lv) then
        TableUtility.ArrayPushBack(self.bpInfo.suGet, lv)
      end
    end
  end
  if data.overflow_reward_level ~= nil then
    self.bpInfo.overflowRewardLevel = math.max(self.bpInfo.overflowRewardLevel or 0, data.overflow_reward_level)
  end
  if data.pro_overflow_reward_level ~= nil then
    self.bpInfo.proOverflowRewardLevel = math.max(self.bpInfo.proOverflowRewardLevel or 0, data.pro_overflow_reward_level)
  end
  if data.super_overflow_reward_level ~= nil then
    self.bpInfo.superOverflowRewardLevel = math.max(self.bpInfo.superOverflowRewardLevel or 0, data.super_overflow_reward_level)
  end
  self:RefreshOverflowRewardConfig()
  self:UpdateWholeRedTip()
end

function BattlePassProxy:UpdateBattlePassLv(oldV, newV)
  if not self.inited then
    return
  end
  if oldV ~= newV then
    self:MarkFriendRankDataDirty()
    self:RefreshOverflowRewardConfig()
    self:UpdateWholeRedTip()
  end
end

function BattlePassProxy:UpdateBattlePassExp(oldV, newV)
  if not self.inited then
    return
  end
  if oldV ~= newV then
    self:MarkFriendRankDataDirty()
    self:RefreshOverflowRewardConfig()
    self:UpdateWholeRedTip()
  end
end

function BattlePassProxy:RecvAdvanceBattlePassCmd(data)
  if not self.inited then
    return
  end
  if data.super then
    self.bpInfo.suLevel = data.level
    MsgManager.ShowMsgByID(40957)
  else
    self.bpInfo.advLevel = data.level
    MsgManager.ShowMsgByID(40956)
  end
  self:UpdateWholeRedTip()
end

function BattlePassProxy:IsAllBattlePassRankValid()
  return self.lastUpdateAllRankTime and ServerTime.CurServerTime() - self.lastUpdateAllRankTime <= 60000
end

function BattlePassProxy:RecvQueryBattlePassRankMatchCCmd(data)
  if not self.inited then
    return
  end
  self.lastUpdateAllRankTime = ServerTime.CurServerTime()
  self.rankinAll = nil
  if self.allrankinfo then
    TableUtility.ArrayClear(self.allrankinfo)
  else
    self.allrankinfo = {}
  end
  for i = 1, #data.datas do
    TableUtility.ArrayPushBack(self.allrankinfo, BattlePassRankShowData.new(0, data.datas[i], i))
    if data.datas[i].charid == Game.Myself.data.id then
      self.rankinAll = i
    end
  end
end

function BattlePassProxy:MarkFriendRankDataDirty()
  self.friendRankDataDirty = true
end

function BattlePassProxy:GenerateFriendRankData()
  if self.friendRankDataDirty or #self.friendrankinfo == 0 then
    self.friendRankDataDirty = false
    self.rankinFriend = nil
    if self.friendrankinfo then
      TableUtility.ArrayClear(self.friendrankinfo)
    else
      self.friendrankinfo = {}
    end
    self:AddFriendRankData(BattlePassRankShowData.new(1))
    local friendData = FriendProxy.Instance:GetFriendData()
    local friendAcc = {}
    local fdd, accid, offtime
    for i = 1, #friendData do
      fdd = friendData[i]
      accid = fdd.accid
      if accid and accid ~= 0 and accid ~= FunctionLogin.Me():getLoginData().accid then
        offtime = fdd.offlinetime and fdd.offlinetime ~= 0 and ServerTime.CurServerTime() / 1000 - fdd.offlinetime or 0
        if not (friendAcc[accid] and friendAcc[accid].ot) or offtime < friendAcc[accid].ot then
          if not friendAcc[accid] then
            friendAcc[accid] = {}
          end
          friendAcc[accid].ot = offtime
          friendAcc[accid].data = fdd
        end
      end
    end
    for _, v in pairs(friendAcc) do
      self:AddFriendRankData(BattlePassRankShowData.new(2, v.data))
    end
    for i = 1, #self.friendrankinfo do
      self.friendrankinfo[i].rank = i
      if self.friendrankinfo[i].guid == Game.Myself.data.id then
        self.rankinFriend = i
      end
    end
  end
  return self.friendrankinfo
end

function BattlePassProxy:AddFriendRankData(item)
  TableUtility.InsertSort(self.friendrankinfo, item, function(a, b)
    if a.bplvel == b.bplevel then
      return (a.bpexp or 0) < (b.bpexp or 0)
    end
    return a.bplevel < b.bplevel
  end)
end

function BattlePassProxy:LevelConfig(lv)
  if self.overflowRewardLevel and lv == self.overflowRewardLevel then
    return self:GetOverflowRewardConfig()
  end
  return Table_BattlePassLevel[lv + self.IdOffset]
end

function BattlePassProxy:GetRewardInfoByLevelRange(type, startLevel, endLevel, upgradedLevelLimit, tableOnly)
  local resultTable = {}
  startLevel = startLevel or 0
  endLevel = endLevel or 0
  if startLevel <= endLevel then
    local reward, item, important
    if 0 < BitUtil.band(type, 1) then
      for i = startLevel, endLevel do
        reward = Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].RewardItems
        important = Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].Important == 1
        if reward then
          for j = 1, #reward do
            item = reward[j]
            if resultTable[item.itemid] then
              resultTable[item.itemid] = resultTable[item.itemid] + item.num
            else
              resultTable[item.itemid] = important and i / 1000 + item.num or item.num
            end
          end
        end
      end
    end
    if 0 < BitUtil.band(type, 2) then
      local uplv = self:AdvLevel()
      for i = startLevel, endLevel do
        if not upgradedLevelLimit or not (i > uplv) then
          reward = Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].ProRewardItems
          important = Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].Important == 1
          if reward then
            for j = 1, #reward do
              item = reward[j]
              if resultTable[item.itemid] then
                resultTable[item.itemid] = resultTable[item.itemid] + item.num
              else
                resultTable[item.itemid] = important and i / 1000 + item.num or item.num
              end
            end
          end
        end
      end
    end
    if 0 < BitUtil.band(type, 3) then
      local uplv = self:SuLevel()
      for i = startLevel, endLevel do
        if not upgradedLevelLimit or not (i > uplv) then
          reward = Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].SuperRewardItems
          important = Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].Important == 1
          if reward then
            for j = 1, #reward do
              item = reward[j]
              if resultTable[item.itemid] then
                resultTable[item.itemid] = resultTable[item.itemid] + item.num
              else
                resultTable[item.itemid] = important and i / 1000 + item.num or item.num
              end
            end
          end
        end
      end
    end
  end
  if tableOnly then
  end
  return BattlePassProxy.GetSortedItemListByRewardInfoTable(resultTable), resultTable
end

function BattlePassProxy.GetSortedItemListByRewardInfoTable(resultTable)
  local resultItemList = {}
  local itemData
  for k, v in pairs(resultTable) do
    itemData = ItemData.new("", k)
    itemData:SetItemNum(math.floor(v))
    itemData.importantLv = (v - math.floor(v)) * 1000
    TableUtility.InsertSort(resultItemList, itemData, function(a, b)
      if a.importantLv ~= b.importantLv then
        return a.importantLv < b.importantLv
      end
      return a.staticData.id < b.staticData.id
    end)
  end
  return resultItemList
end

function BattlePassProxy.MergeRewardInfoTable(tab1, tab2)
  for k, v in pairs(tab1) do
    if tab2[k] then
      tab2[k] = tab2[k] + v
    else
      tab2[k] = v
    end
  end
  return tab2
end

function BattlePassProxy:GetBuyPriceByLevelRange(startLevel, endLevel)
  if startLevel <= endLevel then
    local price = 0
    for i = startLevel, endLevel do
      price = price + (Table_BattlePassLevel[i + self.IdOffset] and Table_BattlePassLevel[i + self.IdOffset].NeedCoin or 0)
    end
    return price
  end
end

function BattlePassProxy:HasAvailLevelReward()
  local bplv = BattlePassProxy.BPLevel()
  for i = 1, bplv do
    if self:IsNormalRewardNotEmpty(i) and not self:IsNormalRewardGet(i) then
      return true
    end
  end
  local check_advlv = math.min(BattlePassProxy.Instance:AdvLevel(), bplv)
  for i = 1, check_advlv do
    if self:IsAdvRewardNotEmpty(i) and not self:IsAdvRewardGet(i) then
      return true
    end
  end
  local check_sulv = math.min(BattlePassProxy.Instance:SuLevel(), bplv)
  for i = 1, check_sulv do
    if self:IsSuRewardNotEmpty(i) and not self:IsSuRewardGet(i) then
      return true
    end
  end
  return false
end

function BattlePassProxy:HasAvailOverflowReward()
  local overflowReward = self:GetOverflowRewardConfig()
  if not overflowReward then
    return false
  end
  if BattlePassProxy.BPLevel() < (self.maxBpLevel or 0) then
    return false
  end
  if overflowReward.NormalOverflowAvailable then
    return true
  end
  if 0 < (self:AdvLevel() or 0) and overflowReward.ProOverflowAvailable then
    return true
  end
  if self:HasColPass() and 0 < (self:SuLevel() or 0) and overflowReward.SuperOverflowAvailable then
    return true
  end
  return false
end

function BattlePassProxy:HasAvailReward()
  return self:HasAvailLevelReward() or self:HasAvailOverflowReward()
end

BattlePassProxy.WholeRedTipID = 10413

function BattlePassProxy:UpdateWholeRedTip()
  local needShow = self:HasAvailReward()
  if needShow then
    RedTipProxy.Instance:UpdateRedTip(self.WholeRedTipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(self.WholeRedTipID)
  end
end

function BattlePassProxy:HasColPass()
  if self.CurrentBPConfig and not self.CurrentBPConfig.HideColl then
    return true
  else
    return false
  end
end

function BattlePassProxy:HasExchangeShop()
  if self.CurrentBPConfig and self.CurrentBPConfig.ExchangeShopType then
    return true
  else
    return false
  end
end

function BattlePassProxy:UpdateBattlePassTask(tasks)
  if tasks then
    for i = 1, #tasks do
      local task = tasks[i]
      local id = task.id
      local config = Table_BattlePassTask[id]
      local taskData = self.battlePassTaskMap[id]
      if not taskData then
        taskData = {}
        taskData.id = id
        self.battlePassTaskMap[id] = taskData
        local ids = self.battlePassTaskIds[config.Tab]
        if not ids then
          ids = {}
          self.battlePassTaskIds[config.Tab] = ids
        end
        ids[#ids + 1] = id
      end
      local progress = task.process or 0
      taskData.progress = progress
      taskData.state = progress < config.TargetNum and 0 or 1
    end
  end
end

local sortFunc = function(a, b)
  local aData = BattlePassProxy.Instance.battlePassTaskMap[a]
  local bData = BattlePassProxy.Instance.battlePassTaskMap[b]
  local aSData = Table_BattlePassTask[a]
  local bSData = Table_BattlePassTask[b]
  if aData.state == bData.state then
    return aSData.Index < bSData.Index
  else
    return aData.state == 0
  end
end

function BattlePassProxy:GetBattlePassTasksByType(type)
  table.sort(self.battlePassTaskIds[type], sortFunc)
  return self.battlePassTaskIds[type]
end

function BattlePassProxy:GetBattlePassTask(id)
  return self.battlePassTaskMap[id]
end

function BattlePassProxy:GetCurVersionBPEndTime()
  if EnvChannel.IsTFBranch() then
    return self.CurrentBPConfig.TFVersionEndTime or self.CurrentBPConfig.VersionEndTime
  end
  return self.CurrentBPConfig.ReleaseVersionEndTime or self.CurrentBPConfig.VersionEndTime
end
