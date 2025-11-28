ActivityBattlePassProxy = class("ActivityBattlePassProxy", pm.Proxy)
ActivityBattlePassProxy.Instance = nil
ActivityBattlePassProxy.NAME = "ActivityBattlePassProxy"
local RewardState = {
  LOCKED = 0,
  AVAILABLE = 1,
  RECEIVED = 2
}

function ActivityBattlePassProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityBattlePassProxy.NAME
  if ActivityBattlePassProxy.Instance == nil then
    ActivityBattlePassProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityBattlePassProxy:Init()
  self.taskIds = {}
  self.taskMap = {}
  self.rewarded_normal_lvs = {}
  self.rewarded_pro_lvs = {}
  self.isPro = {}
  self.exp = {}
  self.maxBPLevel = {}
  self.startTime = {}
  self.endTime = {}
  self:InitLevelData()
end

function ActivityBattlePassProxy:InitLevelData()
  self.levelData = {}
  for i, data in pairs(Table_ActBpReward) do
    local datas = self.levelData[data.ActID]
    if not datas then
      datas = {}
      self.levelData[data.ActID] = datas
      self.maxBPLevel[data.ActID] = data.Level
    end
    datas[data.Level] = data
    self.maxBPLevel[data.ActID] = math.max(self.maxBPLevel[data.ActID], data.Level)
  end
end

function ActivityBattlePassProxy:UpdateActTime(act_id, starttime, endtime)
  self.startTime[act_id] = starttime
  self.endTime[act_id] = endtime
end

function ActivityBattlePassProxy:UpdateActBPTarget(targets)
  for i = 1, #targets do
    local actBp = targets[i]
    local taskData = self.taskMap[actBp.act_id]
    local taskList = self.taskIds[actBp.act_id]
    if not taskData then
      taskData = {}
      taskList = {}
      self.taskMap[actBp.act_id] = taskData
      self.taskIds[actBp.act_id] = taskList
    end
    for j = 1, #actBp.targets do
      local atd = actBp.targets[j]
      if not taskData[atd.id] then
        taskData[atd.id] = {}
        taskList[#taskList + 1] = atd.id
      end
      taskData[atd.id].progress = atd.process or 0
      taskData[atd.id].state = atd.state or EACTQUESTSTATE.EACT_QUEST_DOING
    end
    for k = 1, #actBp.del_quests do
      local id = actBp.del_quests[k]
      taskData[id] = nil
      TableUtility.ArrayRemove(taskList, id)
    end
  end
end

function ActivityBattlePassProxy:UpdateLevelRewardData(rewardInfos)
  for i = 1, #rewardInfos do
    local info = rewardInfos[i]
    self.rewarded_normal_lvs[info.act_id] = info.rewarded_normal_lv
    self.rewarded_pro_lvs[info.act_id] = info.rewarded_pro_lv
    self.isPro[info.act_id] = info.is_pro
    self.exp[info.act_id] = info.exp
  end
end

function ActivityBattlePassProxy:GetTaskList(activityId)
  local datas = {}
  if self.taskIds[activityId] then
    for i = 1, #self.taskIds[activityId] do
      local id = self.taskIds[activityId][i]
      if self:IsTaskAvailable(activityId, id) then
        datas[#datas + 1] = id
      end
    end
  end
  return datas
end

function ActivityBattlePassProxy:IsTaskAvailable(activityId, taskId)
  local config = Table_ActBpTarget[taskId]
  if config then
    local taskData = self.taskMap[activityId]
    if taskData then
      local starttime, endtime
      if EnvChannel.IsTFBranch() then
        if not StringUtil.IsEmpty(config.TFGoStartTime) then
          local y, m, d, h, min, s = StringUtil.GetDateData(config.TFGoStartTime)
          starttime = os.time({
            day = d,
            month = m,
            year = y,
            hour = h,
            min = min,
            sec = s
          })
        end
        if not StringUtil.IsEmpty(config.TFGoEndTime) then
          local y, m, d, h, min, s = StringUtil.GetDateData(config.TFGoEndTime)
          endtime = os.time({
            day = d,
            month = m,
            year = y,
            hour = h,
            min = min,
            sec = s
          })
        end
      else
        if not StringUtil.IsEmpty(config.GoStartTime) then
          local y, m, d, h, min, s = StringUtil.GetDateData(config.GoStartTime)
          starttime = os.time({
            day = d,
            month = m,
            year = y,
            hour = h,
            min = min,
            sec = s
          })
        end
        if not StringUtil.IsEmpty(config.GoEndTime) then
          local y, m, d, h, min, s = StringUtil.GetDateData(config.GoEndTime)
          endtime = os.time({
            day = d,
            month = m,
            year = y,
            hour = h,
            min = min,
            sec = s
          })
        end
      end
      local curtime = ServerTime.CurServerTime() / 1000
      local preTask = taskData[config.PreID]
      if (not preTask or preTask.state ~= EACTQUESTSTATE.EACT_QUEST_DOING) and starttime <= curtime and endtime >= curtime then
        return true
      end
    end
  end
  return false
end

function ActivityBattlePassProxy:GetTaskData(activityId, id)
  if self.taskMap[activityId] then
    return self.taskMap[activityId][id]
  end
end

function ActivityBattlePassProxy:LevelConfig(activityId, level)
  if self.levelData[activityId] then
    return self.levelData[activityId][level]
  end
end

function ActivityBattlePassProxy:GetNextImportantLv(activityId, level)
  local datas = self.levelData[activityId]
  if datas then
    for i = level, #datas do
      local data = datas[i]
      if data.Important == 1 then
        return i
      end
    end
  end
end

function ActivityBattlePassProxy:GetCurBPLevel(activityId)
  if self.levelData[activityId] then
    local exp = self.exp[activityId] or 0
    local maxLv = math.min(self.maxBPLevel[activityId], #self.levelData[activityId])
    for i = 1, maxLv do
      local data = self.levelData[activityId][i]
      if exp < data.NeedExp then
        return i - 1
      end
    end
    return maxLv
  end
end

function ActivityBattlePassProxy:GetCurExp(activityId)
  return self.exp[activityId]
end

function ActivityBattlePassProxy:GetStartTime(activityId)
  local startTime = self.startTime[activityId]
  if not startTime then
    local actInfo = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(activityId)
    startTime = actInfo and actInfo.starttime
  end
  return startTime
end

function ActivityBattlePassProxy:GetEndTime(activityId)
  local endTime = self.endTime[activityId]
  if not endTime then
    local actInfo = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(activityId)
    endTime = actInfo and actInfo.endtime
  end
  return endTime
end

function ActivityBattlePassProxy:IsNormalRewardReceived(activityId, level)
  return self.rewarded_normal_lvs[activityId] and level <= self.rewarded_normal_lvs[activityId] or false
end

function ActivityBattlePassProxy:IsProRewardReceived(activityId, level)
  return self.rewarded_pro_lvs[activityId] and level <= self.rewarded_pro_lvs[activityId] or false
end

function ActivityBattlePassProxy:IsNormalRewardLocked(activityId, level)
  local curLevel = self:GetCurBPLevel(activityId)
  return level > curLevel
end

function ActivityBattlePassProxy:IsProRewardLocked(activityId, level)
  local curLevel = self:GetCurBPLevel(activityId)
  return not self.isPro[activityId] or level > curLevel
end

function ActivityBattlePassProxy:IsHaveAvailableReward(activityId)
  local curLevel = self:GetCurBPLevel(activityId)
  for i = 1, curLevel do
    local isNormalAvailable = not self:IsNormalRewardReceived(activityId, i)
    if isNormalAvailable then
      return true
    end
    if self.isPro[activityId] then
      local isProAvailable = not self:IsProRewardReceived(activityId, i)
      if isProAvailable then
        return true
      end
    end
  end
  return false
end

function ActivityBattlePassProxy:GetProReward(activityId, list)
  if self.levelData[activityId] then
    local temp = ReusableTable.CreateTable()
    for i = 1, #self.levelData[activityId] do
      local data = self.levelData[activityId][i]
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
  end
  return list
end

function ActivityBattlePassProxy:IsBPAvailable(activityId)
  local starttime = self:GetStartTime(activityId)
  local endtime = self:GetEndTime(activityId)
  if starttime and endtime then
    local curTime = ServerTime.CurServerTime() / 1000
    return endtime >= curTime and starttime <= curTime
  end
  return false
end

function ActivityBattlePassProxy:IsUpgradeCanShow(activityId)
  return self:IsBPAvailable() and not self.isPro[activityId]
end

function ActivityBattlePassProxy:GetRewardItemByLevelRange(activityId, startLevel, endLevel, rewardList)
  if startLevel <= endLevel then
    local rewardTable = ReusableTable.CreateTable()
    local setRewardNum = function(data, rewardTable)
      local itemId = data.itemid
      local num = data.num
      rewardTable[itemId] = rewardTable[itemId] or 0
      rewardTable[itemId] = rewardTable[itemId] + num
    end
    for i = startLevel, endLevel do
      local levelConfig = self:LevelConfig(activityId, i)
      if levelConfig then
        for j = 1, #levelConfig.RewardItems do
          setRewardNum(levelConfig.RewardItems[j], rewardTable)
        end
        if self.isPro[activityId] then
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

function ActivityBattlePassProxy:GetBuyPriceByLevelRange(activityId, startLevel, endLevel)
  local price = 0
  if startLevel <= endLevel then
    for i = startLevel, endLevel do
      local levelConfig = self:LevelConfig(activityId, i)
      local needCoin = levelConfig and levelConfig.NeedCoin
      needCoin = needCoin or 0
      price = price + needCoin
    end
  end
  return price
end
