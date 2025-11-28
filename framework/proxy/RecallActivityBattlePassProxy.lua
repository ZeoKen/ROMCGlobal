RecallActivityBattlePassProxy = class("RecallActivityBattlePassProxy", pm.Proxy)
RecallActivityBattlePassProxy.Instance = nil
RecallActivityBattlePassProxy.NAME = "RecallActivityBattlePassProxy"
local RecallActivityType = 2

function RecallActivityBattlePassProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallActivityBattlePassProxy.NAME
  if RecallActivityBattlePassProxy.Instance == nil then
    RecallActivityBattlePassProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RecallActivityBattlePassProxy:Init()
  self.tasks = {}
  self.taskMap = {}
  self.maxBPLevel = {}
  self.levelData = {}
end

function RecallActivityBattlePassProxy:InitLevelData()
  for _, data in pairs(Table_UserRecall_BattlePassLevel) do
    local datas = self.levelData[data.Index]
    if not datas then
      datas = {}
      self.levelData[data.Index] = datas
      self.maxBPLevel[data.Index] = data.Level
    end
    datas[data.Level] = data
    self.maxBPLevel[data.Index] = math.max(self.maxBPLevel[data.Index], data.Level)
  end
end

function RecallActivityBattlePassProxy:LevelConfig(configIndex, level)
  if self.levelData[configIndex] then
    return self.levelData[configIndex][level]
  end
end

local taskSortFunc = function(a, b)
  if a.state == b.state then
    if a.staticData.Type == b.staticData.Type then
      return a.staticData.id < b.staticData.id
    end
    return a.staticData.Type > b.staticData.Type
  end
  return a.state < b.state
end

function RecallActivityBattlePassProxy:UpdateBPInfo(data)
  redlog("UpdateBPInfo", data.index, data.normal_level, data.exp)
  if not next(self.levelData) then
    self:InitLevelData()
  end
  self.index = data.index + 1
  self.configIndex = RecallInfoProxy.Instance:GetIndex(self.index)
  redlog("configIndex", self.configIndex)
  self.startTime = data.start_time
  self.isEnd = data.end_time and data.end_time > 0 or false
  self.exp = data.exp
  self.level = data.normal_level
  self.isPro = data.adv_lock or false
  self.rewarded_normal_lv = data.nor_reward_geted or 0
  self.rewarded_pro_lv = data.adv_reward_geted or 0
  redlog("rewarded_normal_lv", self.rewarded_normal_lv)
  TableUtility.ArrayClear(self.tasks)
  if data.quests then
    for i = 1, #data.quests do
      local quest = data.quests[i]
      local task = RecallActivityBattlePassTaskData.new(quest.id)
      task:SetData(quest.process, quest.finish)
      self.tasks[#self.tasks + 1] = task
    end
    table.sort(self.tasks, taskSortFunc)
  end
  self:UpdateRedTipStatus()
end

function RecallActivityBattlePassProxy:GetCurIndex()
  return self.index
end

function RecallActivityBattlePassProxy:GetCurConfigIndex()
  return self.configIndex
end

function RecallActivityBattlePassProxy:GetCurBPLevel()
  return self.level
end

function RecallActivityBattlePassProxy:GetMaxBPLevel()
  return self.maxBPLevel[self.configIndex]
end

function RecallActivityBattlePassProxy:GetCurExp()
  return self.exp
end

function RecallActivityBattlePassProxy:GetStartTime()
  return self.startTime
end

function RecallActivityBattlePassProxy:GetEndTime()
  local config = Table_UserRecall[RecallActivityType * 1000 + self.configIndex]
  if config and self.startTime then
    local curDailyRefreshTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(self.startTime)
    local endTime = curDailyRefreshTime + config.ContinueDay * 24 * 60 * 60
    return endTime
  end
end

function RecallActivityBattlePassProxy:IsActivityValid(index)
  if self.configIndex and self.configIndex == index and self.startTime then
    return true
  end
  return false
end

function RecallActivityBattlePassProxy:GetActivityTime(index)
  if self.configIndex and self.configIndex == index and self.startTime then
    local endTime = self:GetEndTime()
    return self.startTime, endTime
  end
  return nil, nil
end

function RecallActivityBattlePassProxy:GetIsPro()
  return self.isPro
end

function RecallActivityBattlePassProxy:IsHaveAvailableReward()
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

function RecallActivityBattlePassProxy:IsNormalRewardReceived(level)
  return self.rewarded_normal_lv and level <= self.rewarded_normal_lv
end

function RecallActivityBattlePassProxy:IsProRewardReceived(level)
  return self.rewarded_pro_lv and level <= self.rewarded_pro_lv
end

function RecallActivityBattlePassProxy:IsNormalRewardLocked(level)
  local curLevel = self:GetCurBPLevel()
  return level > curLevel
end

function RecallActivityBattlePassProxy:IsProRewardLocked(level)
  local curLevel = self:GetCurBPLevel()
  return not self.isPro or level > curLevel
end

function RecallActivityBattlePassProxy:GetNextImportantLv(level)
  local datas = self.levelData[self.configIndex]
  if datas then
    for i = level, #datas do
      local data = datas[i]
      if data.Important == 1 then
        return i
      end
    end
  end
end

function RecallActivityBattlePassProxy:GetTaskList()
  return self.tasks
end

function RecallActivityBattlePassProxy:GetBuyPriceByLevelRange(startLevel, endLevel)
  local costItem
  local price = 0
  if startLevel <= endLevel then
    for i = startLevel, endLevel do
      local levelConfig = self:LevelConfig(self.configIndex, i)
      local quickCost = levelConfig and levelConfig.QuickCost
      if quickCost and quickCost[1] then
        costItem = costItem or quickCost[1][1]
        price = price + quickCost[1][2]
      end
    end
  end
  return costItem, price
end

local setRewardNum = function(data, rewardTable)
  local itemId = data[1]
  local num = data[2]
  rewardTable[itemId] = rewardTable[itemId] or 0
  rewardTable[itemId] = rewardTable[itemId] + num
end
local insertSortFunc = function(a, b)
  return a.staticData.id < b.staticData.id
end

function RecallActivityBattlePassProxy:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
  if startLevel <= endLevel then
    local rewardTable = ReusableTable.CreateTable()
    for i = startLevel, endLevel do
      local levelConfig = self:LevelConfig(self.configIndex, i)
      if levelConfig then
        for j = 1, #levelConfig.NormalReward do
          setRewardNum(levelConfig.NormalReward[j], rewardTable)
        end
        if self.isPro then
          for j = 1, #levelConfig.AdvanceReward do
            setRewardNum(levelConfig.AdvanceReward[j], rewardTable)
          end
        end
      end
    end
    for itemId, num in pairs(rewardTable) do
      local data = ItemData.new(itemId, itemId)
      data:SetItemNum(num)
      TableUtility.InsertSort(rewardList, data, insertSortFunc)
    end
    ReusableTable.DestroyAndClearTable(rewardTable)
  end
  return rewardList
end

RecallActivityBattlePassTaskData = class("RecallActivityBattlePassTaskData")
RecallActivityBattlePassTaskData.TaskState = {PROCESS = 0, FINISH = 1}

function RecallActivityBattlePassTaskData:ctor(id)
  self.id = id
  self.staticData = Table_UserRecall_BattlePassTask[id]
end

function RecallActivityBattlePassTaskData:SetData(process, finish)
  self.process = process
  self.state = finish and RecallActivityBattlePassTaskData.TaskState.FINISH or RecallActivityBattlePassTaskData.TaskState.PROCESS
end

function RecallActivityBattlePassProxy:UpdateRedTipStatus()
  if not RedTipProxy or not RedTipProxy.Instance then
    return
  end
  local redTipId = 10778
  local subTipId = 1004
  if self:IsHaveAvailableReward() then
    RedTipProxy.Instance:AddRedTipParam(redTipId, subTipId)
  else
    RedTipProxy.Instance:RemoveRedTipParam(redTipId, subTipId)
  end
end

function RecallActivityBattlePassProxy:HasRewardToGet()
  return self:IsHaveAvailableReward()
end
