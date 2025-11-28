autoImport("GuildTaskTraceData")
GuildTaskData = class("GuildTaskData")

function GuildTaskData.GetGroupId(id)
  return Table_GuildChallenge[id] and Table_GuildChallenge[id].GroupID
end

function GuildTaskData:ctor(groupId)
  self.groupId = groupId
  self.taskcount = 0
  self.tasks = {}
  self.trace_dirty = true
  self.traceTasks = {}
end

function GuildTaskData:UpdateTaskData(serverInfo)
  if Table_GuildChallenge[serverInfo.id] == nil then
    xdlog("serverInfo.id 有问题", serverInfo.id)
    return
  end
  self.trace_dirty = true
  local singleData = self.tasks[serverInfo.id]
  if singleData == nil then
    singleData = GuildTaskTraceData.new()
    self.tasks[serverInfo.id] = singleData
    self.taskcount = self.taskcount + 1
  end
  singleData:SetChallengeData(serverInfo)
end

function GuildTaskData:GetTaskDatas()
  return self.tasks
end

function GuildTaskData:CheckShowValid(id)
  local data = self.tasks[id]
  if not data then
    return
  end
  return data.isFinished == true
end

function GuildTaskData:GetTraceTaskDatas()
  if self.trace_dirty == false then
    return self.traceTasks
  end
  self.trace_dirty = false
  TableUtility.ArrayClear(self.traceTasks)
  for k, v in pairs(self.tasks) do
    if not v.unlockID or self:CheckShowValid(v.unlockID) then
      self.traceTasks[#self.traceTasks + 1] = v
    end
  end
  table.sort(self.traceTasks, GuildTaskData.SortTasks)
  return self.traceTasks
end

function GuildTaskData.SortTasks(a, b)
  return a.id < b.id
end

function GuildTaskData:RemoveTaskData(serverInfo)
  if serverInfo == nil then
    return
  end
  local id = serverInfo.id
  if self.tasks[id] ~= nil then
    self.tasks[id] = nil
    self.taskcount = self.taskcount - 1
  end
  self.trace_dirty = true
end
