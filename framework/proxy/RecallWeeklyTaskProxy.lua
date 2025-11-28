RecallWeeklyTaskProxy = class("RecallWeeklyTaskProxy", pm.Proxy)
RecallWeeklyTaskProxy.Instance = nil
RecallWeeklyTaskProxy.NAME = "RecallWeeklyTaskProxy"

function RecallWeeklyTaskProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallWeeklyTaskProxy.NAME
  if RecallWeeklyTaskProxy.Instance == nil then
    RecallWeeklyTaskProxy.Instance = self
    xdlog("RecallWeeklyTaskProxy:ctor 首次创建实例，执行完整初始化")
    self:Init()
  else
    xdlog("RecallWeeklyTaskProxy:ctor 实例已存在，仅重新加载静态数据")
    self:InitStaticData()
  end
  if data ~= nil then
    self:setData(data)
  end
end

function RecallWeeklyTaskProxy:Init()
  self.staticTaskData = {}
  self.serverTaskData = nil
  self:InitStaticData()
end

function RecallWeeklyTaskProxy:InitStaticData()
  if not Table_UserRecall_WeeklyTask then
    redlog("RecallWeeklyTaskProxy:InitStaticData 表格不存在 Table_UserRecall_WeeklyTask，可能是服务器类型不匹配")
    return
  end
  self.staticTaskData = {}
  for taskId, taskConfig in pairs(Table_UserRecall_WeeklyTask) do
    local index = taskConfig.Index
    if not self.staticTaskData[index] then
      self.staticTaskData[index] = {}
    end
    self.staticTaskData[index][taskId] = taskConfig
  end
end

function RecallWeeklyTaskProxy:UpdateTaskData(index, serverData)
  if not serverData then
    redlog("RecallWeeklyTaskProxy:UpdateTaskData 参数无效", serverData)
    return
  end
  local actualIndex
  if RecallInfoProxy.Instance then
    actualIndex = RecallInfoProxy.Instance:GetIndex(serverData.index + 1)
  end
  if not actualIndex then
    redlog("RecallWeeklyTaskProxy:UpdateTaskData 无法获取实际配置索引", "serverIndex:", serverData.index)
    actualIndex = serverData.index
  end
  local endTime = serverData.end_time
  if serverData.start_time and RecallInfoProxy.Instance then
    local continueDay = RecallInfoProxy.Instance:GetContinueDay("WeeklyTask", actualIndex)
    if continueDay then
      endTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(serverData.start_time + continueDay * 86400)
    end
  end
  self.serverTaskData = {
    index = serverData.index,
    start_time = serverData.start_time,
    end_time = endTime,
    tasks = {}
  }
  if serverData.tasks then
    for _, task in pairs(serverData.tasks) do
      local taskData = {
        id = task.id,
        complete_count = task.complete_count or 0,
        complete = task.complete or false,
        reward_geted = task.reward_geted or false
      }
      table.insert(self.serverTaskData.tasks, taskData)
    end
  end
  self:UpdateRedTipStatus()
end

function RecallWeeklyTaskProxy:GetTaskData()
  return self.serverTaskData
end

function RecallWeeklyTaskProxy:GetStaticTaskData()
  return self.staticTaskData
end

function RecallWeeklyTaskProxy:GetStaticTaskDataByIndex(index)
  if not self.staticTaskData then
    redlog("RecallWeeklyTaskProxy:GetStaticTaskDataByIndex staticTaskData为nil!")
    return nil
  end
  if not self.staticTaskData[index] then
    redlog("RecallWeeklyTaskProxy:GetStaticTaskDataByIndex 静态数据不存在", "Index:", index)
    return nil
  end
  return self.staticTaskData[index]
end

function RecallWeeklyTaskProxy:GetTaskIdsByIndex(index)
  local staticTasks = self:GetStaticTaskDataByIndex(index)
  if not staticTasks then
    return {}
  end
  local taskIds = {}
  for taskId, _ in pairs(staticTasks) do
    table.insert(taskIds, taskId)
  end
  table.sort(taskIds)
  return taskIds
end

function RecallWeeklyTaskProxy:GetTaskDataListByIndex(index)
  local actualIndex = 1
  if RecallInfoProxy.Instance then
    actualIndex = RecallInfoProxy.Instance:GetIndex(index + 1)
  end
  local staticTasks = self:GetStaticTaskDataByIndex(actualIndex)
  if not staticTasks then
    return {}
  end
  local taskDataList = {}
  for taskId, staticData in pairs(staticTasks) do
    local taskData = {
      id = taskId,
      staticData = staticData,
      status = 1,
      complete_count = 0,
      complete_times = 0,
      complete = false,
      reward_geted = false
    }
    if self.serverTaskData and self.serverTaskData.tasks then
      for _, serverTask in pairs(self.serverTaskData.tasks) do
        if serverTask.id == taskId then
          taskData.complete_count = serverTask.complete_count or 0
          taskData.complete_times = serverTask.complete_times or 0
          taskData.complete = serverTask.complete or false
          taskData.reward_geted = serverTask.reward_geted or false
          if taskData.reward_geted then
            taskData.status = 3
            break
          end
          if taskData.complete then
            taskData.status = 2
            break
          end
          taskData.status = 1
          break
        end
      end
    end
    table.insert(taskDataList, taskData)
  end
  table.sort(taskDataList, function(a, b)
    local maxTimesA = a.staticData.CompleteCount or 1
    local completedCountA = a.complete_count or 0
    local isCompletedA = maxTimesA <= completedCountA
    local maxTimesB = b.staticData.CompleteCount or 1
    local completedCountB = b.complete_count or 0
    local isCompletedB = maxTimesB <= completedCountB
    if isCompletedA ~= isCompletedB then
      return not isCompletedA
    end
    return a.id < b.id
  end)
  return taskDataList
end

function RecallWeeklyTaskProxy:GetTaskStaticConfig(taskId)
  for index, tasks in pairs(self.staticTaskData) do
    if tasks[taskId] then
      return tasks[taskId]
    end
  end
  return nil
end

function RecallWeeklyTaskProxy:GetTaskServerData(taskId)
  local taskData = self:GetTaskData()
  if not taskData or not taskData.tasks then
    return nil
  end
  for _, task in pairs(taskData.tasks) do
    if task.id == taskId then
      return task
    end
  end
  return nil
end

function RecallWeeklyTaskProxy:CanGetTaskReward(taskId)
  local serverTask = self:GetTaskServerData(taskId)
  if not serverTask then
    return false
  end
  return serverTask.complete and not serverTask.reward_geted
end

function RecallWeeklyTaskProxy:IsTaskCompleted(taskId)
  local serverTask = self:GetTaskServerData(taskId)
  if not serverTask then
    return false
  end
  return serverTask.complete
end

function RecallWeeklyTaskProxy:IsTaskRewardGeted(taskId)
  local serverTask = self:GetTaskServerData(taskId)
  if not serverTask then
    return false
  end
  return serverTask.reward_geted
end

function RecallWeeklyTaskProxy:GetTaskProgress(taskId)
  local serverTask = self:GetTaskServerData(taskId)
  if not serverTask then
    return 0
  end
  return serverTask.complete_count or 0
end

function RecallWeeklyTaskProxy:GetTaskStatus(taskId)
  local serverTask = self:GetTaskServerData(taskId)
  if not serverTask then
    return 1
  end
  if serverTask.reward_geted then
    return 3
  elseif serverTask.complete then
    return 2
  else
    return 1
  end
end

function RecallWeeklyTaskProxy:GetValidTaskIds()
  local taskIds = {}
  for index, tasks in pairs(self.staticTaskData) do
    for taskId, _ in pairs(tasks) do
      table.insert(taskIds, taskId)
    end
  end
  table.sort(taskIds)
  return taskIds
end

function RecallWeeklyTaskProxy:GetValidTaskIdsByIndex(index)
  return self:GetTaskIdsByIndex(index)
end

function RecallWeeklyTaskProxy:GetCanRewardTaskCountByIndex(index)
  local count = 0
  local taskIds = self:GetTaskIdsByIndex(index)
  for _, taskId in pairs(taskIds) do
    if self:CanGetTaskReward(taskId) then
      count = count + 1
    end
  end
  return count
end

function RecallWeeklyTaskProxy:GetCanRewardTaskCount()
  local count = 0
  local taskIds = self:GetValidTaskIds()
  for _, taskId in pairs(taskIds) do
    if self:CanGetTaskReward(taskId) then
      count = count + 1
    end
  end
  return count
end

function RecallWeeklyTaskProxy:HasRewardToGet()
  return self:GetCanRewardTaskCount() > 0
end

function RecallWeeklyTaskProxy:RequestTaskData()
  local queryData = {
    index = 1,
    start_time = 0,
    tasks = {}
  }
  ServiceRecallCCmdProxy.Instance:CallWeeklyTaskQueryInfoRecallCmd(queryData)
end

function RecallWeeklyTaskProxy:RequestTaskReward(taskId)
  local serverTask = self:GetTaskServerData(taskId)
  if not serverTask then
    redlog("RecallWeeklyTaskProxy:RequestTaskReward 任务数据不存在", taskId)
    return
  end
  if not self:CanGetTaskReward(taskId) then
    redlog("RecallWeeklyTaskProxy:RequestTaskReward 任务不可领取", taskId)
    return
  end
  ServiceRecallCCmdProxy.Instance:CallWeeklyTaskGetRewardRecallCmd(serverTask)
end

function RecallWeeklyTaskProxy:IsActivityValid(index)
  local staticTasks = self:GetStaticTaskDataByIndex(index)
  if not staticTasks or next(staticTasks) == nil then
    redlog("RecallWeeklyTaskProxy:IsActivityValid Index无静态数据", index)
    return false
  end
  local serverData = self:GetTaskData()
  if serverData and serverData.index == index then
    return true
  end
  redlog("RecallWeeklyTaskProxy:IsActivityValid 有静态配置但无服务器数据", index)
  return true
end

function RecallWeeklyTaskProxy:GetActivityTime(index)
  local serverData = self:GetTaskData()
  if serverData and serverData.index == index then
    local startTime = serverData.start_time
    local endTime = startTime and startTime + 604800 or nil
    return startTime, endTime
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  local defaultStartTime = currentTime - 86400
  local defaultEndTime = currentTime + 518400
  return defaultStartTime, defaultEndTime
end

function RecallWeeklyTaskProxy:HasServerData()
  return self.serverTaskData ~= nil
end

function RecallWeeklyTaskProxy:GetDisplayInfo()
  if self.serverTaskData and self.serverTaskData.start_time then
    local startTime = self.serverTaskData.start_time
    local endTime = self.serverTaskData.end_time or startTime + 604800
    return {startTime = startTime, endTime = endTime}
  end
  return {startTime = 0, endTime = 0}
end

function RecallWeeklyTaskProxy:UpdateTaskRewardStatus(taskData)
  if not taskData or not taskData.id then
    redlog("RecallWeeklyTaskProxy:UpdateTaskRewardStatus 参数无效", taskData)
    return
  end
  if not self.serverTaskData or not self.serverTaskData.tasks then
    redlog("RecallWeeklyTaskProxy:UpdateTaskRewardStatus 服务器数据不存在")
    return
  end
  local taskId = taskData.id
  for _, serverTask in pairs(self.serverTaskData.tasks) do
    if serverTask.id == taskId then
      serverTask.complete_count = taskData.complete_count
      serverTask.complete = taskData.complete
      serverTask.reward_geted = taskData.reward_geted
      self:UpdateRedTipStatus()
      return
    end
  end
end

function RecallWeeklyTaskProxy:UpdateRedTipStatus()
  if not RedTipProxy or not RedTipProxy.Instance then
    return
  end
  local redTipId = 10778
  local subTipId = 1002
  if self:HasRewardToGet() then
    RedTipProxy.Instance:AddRedTipParam(redTipId, subTipId)
  else
    RedTipProxy.Instance:RemoveRedTipParam(redTipId, subTipId)
  end
end
