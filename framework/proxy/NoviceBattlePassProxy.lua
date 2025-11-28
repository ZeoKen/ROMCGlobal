NoviceBattlePassProxy = class("NoviceBattlePassProxy", pm.Proxy)
NoviceBattlePassProxy.Instance = nil
NoviceBattlePassProxy.NAME = "NoviceBattlePassProxy"
local RewardState = {
  LOCKED = 0,
  AVAILABLE = 1,
  RECEIVED = 2
}

function NoviceBattlePassProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NoviceBattlePassProxy.NAME
  if NoviceBattlePassProxy.Instance == nil then
    NoviceBattlePassProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function NoviceBattlePassProxy:Init()
  self.noviceBPTaskIds = {}
  self.noviceBPTaskMap = {}
  self.rewarded_normal_lvs = {}
  self.rewarded_pro_lvs = {}
  self:InitNoviceBPLevelData()
end

function NoviceBattlePassProxy:InitNoviceBPLevelData()
  local config = GameConfig.NoviceBattlePass
  if not config then
    return
  end
  self.noviceBPLevelData = {}
  local version = config.Version and config.Version or 1
  for i, data in ipairs(Table_NoviceBattlePassLevel) do
    if data.Version == version then
      self.noviceBPLevelData[#self.noviceBPLevelData + 1] = data
    end
  end
  self.maxBPLevel = config.MaxLevel or #self.noviceBPLevelData
end

function NoviceBattlePassProxy:UpdateNoviceBPTarget(data)
  if data.datas then
    for i = 1, #data.datas do
      local ntd = data.datas[i]
      local taskData = self.noviceBPTaskMap[ntd.id]
      if not taskData then
        taskData = {}
        taskData.id = ntd.id
        self.noviceBPTaskMap[ntd.id] = taskData
        self.noviceBPTaskIds[#self.noviceBPTaskIds + 1] = ntd.id
      end
      taskData.progress = ntd.progress or 0
      taskData.state = ntd.state or SceneUser2_pb.ENOVICE_TARGET_GO
    end
  end
  self.endTime = data.end_time or 0
  self.isPro = data.is_pro
  xdlog("战令结束时间", self.endTime)
  self:UpdateRedTip()
end

function NoviceBattlePassProxy:UpdateNoviceBPLevelRewardData(data)
  if data.rewarded_normal_lvs then
    TableUtility.ArrayClear(self.rewarded_normal_lvs)
    for i = 1, #data.rewarded_normal_lvs do
      local level = data.rewarded_normal_lvs[i]
      self.rewarded_normal_lvs[#self.rewarded_normal_lvs + 1] = level
    end
  end
  if data.rewarded_pro_lvs then
    TableUtility.ArrayClear(self.rewarded_pro_lvs)
    for i = 1, #data.rewarded_pro_lvs do
      local level = data.rewarded_pro_lvs[i]
      self.rewarded_pro_lvs[#self.rewarded_pro_lvs + 1] = level
    end
  end
end

function NoviceBattlePassProxy:GetNoviceBPTaskList()
  return self.noviceBPTaskIds
end

function NoviceBattlePassProxy:GetNoviceBPTaskData(id)
  if not self.noviceBPTaskMap[id] then
    error(string.format("no find taskdata id:%s", id))
  end
  return self.noviceBPTaskMap[id]
end

function NoviceBattlePassProxy:LevelConfig(level)
  return self.noviceBPLevelData[level]
end

function NoviceBattlePassProxy:GetNextImportantLv(level)
  for i = level, #self.noviceBPLevelData do
    local data = self.noviceBPLevelData[i]
    if data.Important == 1 then
      return i
    end
  end
end

function NoviceBattlePassProxy:GetCurBPLevel()
  local exp = Game.Myself.data.userdata:Get(UDEnum.NOVICE_BP_EXP) or 0
  local maxLv = math.min(self.maxBPLevel, #self.noviceBPLevelData)
  for i = 1, maxLv do
    local data = self.noviceBPLevelData[i]
    if exp < data.NeedExp then
      return i - 1
    end
  end
  return maxLv
end

function NoviceBattlePassProxy:IsHaveAvailableTask()
  for i = 1, #self.noviceBPTaskIds do
    local id = self.noviceBPTaskIds[i]
    local taskData = self.noviceBPTaskMap[id]
    if taskData.state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      return true
    end
  end
  return false
end

function NoviceBattlePassProxy:IsNormalRewardReceived(level)
  return TableUtility.ArrayFindIndex(self.rewarded_normal_lvs, level) > 0
end

function NoviceBattlePassProxy:IsProRewardReceived(level)
  return TableUtility.ArrayFindIndex(self.rewarded_pro_lvs, level) > 0
end

function NoviceBattlePassProxy:IsNormalRewardLocked(level)
  local curLevel = self:GetCurBPLevel()
  return level > curLevel
end

function NoviceBattlePassProxy:IsProRewardLocked(level)
  local curLevel = self:GetCurBPLevel()
  return not self.isPro or level > curLevel
end

function NoviceBattlePassProxy:IsHaveAvailableReward()
  local curLevel = self:GetCurBPLevel()
  for i = 1, curLevel do
    local isNormalAvailable = not self:IsNormalRewardReceived(i)
    if isNormalAvailable then
      return true
    end
    if self.isPro then
      local isProAvailable = not self:IsProRewardReceived(i)
      if isProAvailable then
        return true
      end
    end
  end
  return false
end

function NoviceBattlePassProxy:GetProReward(list)
  local temp = ReusableTable.CreateTable()
  for i = 1, #self.noviceBPLevelData do
    local data = self.noviceBPLevelData[i]
    for j = 1, #data.ProRewardItems do
      local item = data.ProRewardItems[j]
      local itemData = temp[item.itemid]
      local num = item.num
      if not itemData then
        itemData = ItemData.new(item.itemid, item.itemid)
        temp[item.itemid] = itemData
      else
        num = num + itemData.num
      end
      itemData:SetItemNum(num)
    end
  end
  for _, itemData in pairs(temp) do
    list[#list + 1] = itemData
  end
  ReusableTable.DestroyAndClearTable(temp)
  return list
end

function NoviceBattlePassProxy:IsNoviceBPAvailable()
  if self.endTime and self.endTime > 0 then
    return self.endTime > ServerTime.CurServerTime() / 1000
  end
  return false
end

function NoviceBattlePassProxy:IsUpgradeCanShow()
  return self:IsNoviceBPAvailable() and not self.isPro
end

function NoviceBattlePassProxy:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
  if startLevel <= endLevel then
    local rewardTable = ReusableTable.CreateTable()
    local setRewardNum = function(data, rewardTable)
      local itemId = data.itemid
      local num = data.num
      rewardTable[itemId] = rewardTable[itemId] or 0
      rewardTable[itemId] = rewardTable[itemId] + num
    end
    for i = startLevel, endLevel do
      local levelConfig = self:LevelConfig(i)
      if levelConfig then
        for j = 1, #levelConfig.RewardItems do
          setRewardNum(levelConfig.RewardItems[j], rewardTable)
        end
        if self.isPro then
          for j = 1, #levelConfig.ProRewardItems do
            setRewardNum(levelConfig.ProRewardItems[j], rewardTable)
          end
        end
      end
    end
    for itemId, num in pairs(rewardTable) do
      local data = ItemData.new(itemId, itemId)
      data:SetItemNum(num)
      TableUtility.InsertSort(rewardList, data, function(a, b)
        return a.staticData.id < b.staticData.id
      end)
    end
    ReusableTable.DestroyAndClearTable(rewardTable)
  end
  return rewardList
end

function NoviceBattlePassProxy:GetBuyPriceByLevelRange(startLevel, endLevel)
  local price = 0
  if startLevel <= endLevel then
    for i = startLevel, endLevel do
      local levelConfig = self:LevelConfig(i)
      local needCoin = levelConfig and levelConfig.NeedCoin
      needCoin = needCoin or 0
      price = price + needCoin
    end
  end
  return price
end

function NoviceBattlePassProxy:UpdateReturnBPTarget(serverData)
  if not serverData then
    return
  end
  if serverData.end_time == 0 then
    self.returnEndtime = 0
    self.returnBPTaskMap = nil
    self.returnBPTaskIds = nil
    self.returnRewardItems = nil
    self.returnBPVersion = nil
    self.returnBPClass = nil
    self.returnDepositID = nil
    self.returnMaxBPLevel = nil
    GameFacade.Instance:sendNotification(NoviceBattlePassEvent.ReturnBPEnd)
    return
  end
  self.returnEndtime = serverData.end_time
  self.returnIsPro = serverData.is_pro
  if serverData.datas then
    if not self.returnBPTaskMap then
      self.returnBPTaskMap = {}
    end
    if not self.returnBPTaskIds then
      self.returnBPTaskIds = {}
    end
    for i = 1, #serverData.datas do
      local ntd = serverData.datas[i]
      local taskData = self.returnBPTaskMap[ntd.id]
      if not taskData then
        taskData = {}
        taskData.id = ntd.id
        self.returnBPTaskMap[ntd.id] = taskData
        self.returnBPTaskIds[#self.returnBPTaskIds + 1] = ntd.id
      end
      taskData.progress = ntd.progress or 0
      taskData.state = ntd.state or SceneUser2_pb.ENOVICE_TARGET_GO
    end
  end
  local version = serverData.version
  local cLass = serverData.bp_class
  if version and cLass then
    local needUpdateRewardItems = false
    if serverData.return_reward_got then
      self.returnRewardItems = nil
    else
      needUpdateRewardItems = true
    end
    if self.returnBPVersion ~= version or self.returnBPClass ~= cLass then
      self.returnBPVersion = version
      self.returnBPClass = cLass
      local returnVersionConfig = GameConfig.ReturnBattlePass.VersionConfig[version]
      self.returnDepositID = returnVersionConfig.DepositID[cLass]
      self.returnBPLevelData = {}
      for id, sData in pairs(Table_ReturnBattlePassLevel) do
        if sData.Version == version and sData.Class == cLass then
          table.insert(self.returnBPLevelData, sData)
        end
      end
      table.sort(self.returnBPLevelData, function(a, b)
        return a.Level < b.Level
      end)
      self.returnMaxBPLevel = self.returnBPLevelData[#self.returnBPLevelData].Level
      if needUpdateRewardItems and returnVersionConfig.ReturnReward then
        self.returnRewardItems = {}
        for i = 1, #returnVersionConfig.ReturnReward do
          self.returnRewardItems[i] = ItemData.new("ReturnReward" .. i, returnVersionConfig.ReturnReward[i][1])
          self.returnRewardItems[i].num = returnVersionConfig.ReturnReward[i][2]
        end
      end
    end
  end
  self:UpdateRedTip()
end

function NoviceBattlePassProxy:UpdateReturnBPLevelRewardData(serverData)
  self.returnRewardedNormalLvs = nil
  self.returnRewardedProLvs = nil
  if not serverData then
    return
  end
  if serverData.rewarded_normal_lvs then
    self.returnRewardedNormalLvs = {}
    for i = 1, #serverData.rewarded_normal_lvs do
      self.returnRewardedNormalLvs[#self.returnRewardedNormalLvs + 1] = serverData.rewarded_normal_lvs[i]
    end
  end
  if serverData.rewarded_pro_lvs then
    self.returnRewardedProLvs = {}
    for i = 1, #serverData.rewarded_pro_lvs do
      self.returnRewardedProLvs[#self.returnRewardedProLvs + 1] = serverData.rewarded_pro_lvs[i]
    end
  end
end

function NoviceBattlePassProxy:GetReturnRewardItems()
  return self.returnRewardItems
end

function NoviceBattlePassProxy:IsHaveAvailableReturnTask()
  if not self.returnBPTaskIds then
    return false
  end
  for i = 1, #self.returnBPTaskIds do
    local id = self.returnBPTaskIds[i]
    local taskData = self.returnBPTaskMap[id]
    if taskData.state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      return true
    end
  end
  return false
end

function NoviceBattlePassProxy:GetCurReturnBPLevel()
  if not self.returnBPLevelData then
    return 0
  end
  local exp = Game.Myself.data.userdata:Get(UDEnum.RETURN_BP_EXP) or 0
  for i = 1, #self.returnBPLevelData do
    if exp < self.returnBPLevelData[i].NeedExp then
      return i - 1
    end
  end
  return self.returnMaxBPLevel
end

function NoviceBattlePassProxy:IsNormalReturnRewardReceived(level)
  return self.returnRewardedNormalLvs and TableUtility.ArrayFindIndex(self.returnRewardedNormalLvs, level) > 0 or false
end

function NoviceBattlePassProxy:IsProReturnRewardReceived(level)
  return self.returnRewardedProLvs and TableUtility.ArrayFindIndex(self.returnRewardedProLvs, level) > 0 or false
end

function NoviceBattlePassProxy:IsNormalReturnRewardLocked(level)
  local curLevel = self:GetCurReturnBPLevel()
  return level > curLevel
end

function NoviceBattlePassProxy:IsProReturnRewardLocked(level)
  local curLevel = self:GetCurReturnBPLevel()
  return not self.returnIsPro or level > curLevel
end

function NoviceBattlePassProxy:IsHaveAvailableReturnReward()
  local curLevel = self:GetCurReturnBPLevel()
  for i = 1, curLevel do
    local isNormalAvailable = not self:IsNormalReturnRewardReceived(i)
    if isNormalAvailable then
      return true
    end
    if self.returnIsPro then
      local isProAvailable = not self:IsProReturnRewardReceived(i)
      if isProAvailable then
        return true
      end
    end
  end
  return false
end

function NoviceBattlePassProxy:GetProReturnReward(list)
  local temp = ReusableTable.CreateTable()
  for i = 1, #self.returnBPLevelData do
    local data = self.returnBPLevelData[i]
    for j = 1, #data.ProRewardItems do
      local item = data.ProRewardItems[j]
      local itemData = temp[item.itemid]
      local num = item.num
      if not itemData then
        itemData = ItemData.new(item.itemid, item.itemid)
        temp[item.itemid] = itemData
      else
        num = num + itemData.num
      end
      itemData:SetItemNum(num)
    end
  end
  for _, itemData in pairs(temp) do
    list[#list + 1] = itemData
  end
  ReusableTable.DestroyAndClearTable(temp)
  return list
end

function NoviceBattlePassProxy:GetNextReturnImportantLv(level)
  for i = level, #self.returnBPLevelData do
    local data = self.returnBPLevelData[i]
    if data.Important == 1 then
      return i
    end
  end
  return self.returnMaxBPLevel
end

function NoviceBattlePassProxy:GetReturnRewardItemByLevelRange(startLevel, endLevel, rewardList)
  if startLevel <= endLevel then
    local rewardTable = ReusableTable.CreateTable()
    local setRewardNum = function(data, rewardTable)
      local itemId = data.itemid
      local num = data.num
      rewardTable[itemId] = rewardTable[itemId] or 0
      rewardTable[itemId] = rewardTable[itemId] + num
    end
    for i = startLevel, endLevel do
      local levelConfig = self.returnBPLevelData[i]
      if levelConfig then
        for j = 1, #levelConfig.RewardItems do
          setRewardNum(levelConfig.RewardItems[j], rewardTable)
        end
        if self.returnIsPro then
          for j = 1, #levelConfig.ProRewardItems do
            setRewardNum(levelConfig.ProRewardItems[j], rewardTable)
          end
        end
      end
    end
    for itemId, num in pairs(rewardTable) do
      local data = ItemData.new(itemId, itemId)
      data:SetItemNum(num)
      TableUtility.InsertSort(rewardList, data, function(a, b)
        return a.staticData.id < b.staticData.id
      end)
    end
    ReusableTable.DestroyAndClearTable(rewardTable)
  end
  return rewardList
end

function NoviceBattlePassProxy:GetReturnBuyPriceByLevelRange(startLevel, endLevel)
  if not self.returnBPLevelData then
    return 0
  end
  local price = 0
  if startLevel <= endLevel then
    for i = startLevel, endLevel do
      local levelConfig = self.returnBPLevelData[i]
      local needCoin = levelConfig and levelConfig.NeedCoin
      needCoin = needCoin or 0
      price = price + needCoin
    end
  end
  return price
end

function NoviceBattlePassProxy:IsReturnBPAvailable()
  if self.returnEndtime and self.returnEndtime > 0 then
    return self.returnEndtime > ServerTime.CurServerTime() / 1000
  end
  return false
end

function NoviceBattlePassProxy:IsReturnUpgradeCanShow()
  return self:IsReturnBPAvailable() and not self.returnIsPro
end

function NoviceBattlePassProxy:GetReturnBPTaskList()
  return self.returnBPTaskIds
end

function NoviceBattlePassProxy:GetReturnBPTaskData(id)
  return self.returnBPTaskMap and self.returnBPTaskMap[id]
end

function NoviceBattlePassProxy:UpdateRedTip()
  if not self:IsHaveAvailableTask() and not self:IsHaveAvailableReturnTask() then
    RedTipProxy.Instance:RemoveWholeTip(10729)
  else
    RedTipProxy.Instance:UpdateRedTip(10729)
  end
end
