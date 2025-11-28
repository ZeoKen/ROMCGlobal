ActivitySelfChooseProxy = class("ActivitySelfChooseProxy", pm.Proxy)
ActivitySelfChooseProxy.Instance = nil
ActivitySelfChooseProxy.NAME = "ActivitySelfChooseProxy"
ActivitySelfChooseProxy.RedTipId = 10764
local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear

function ActivitySelfChooseProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivitySelfChooseProxy.NAME
  if ActivitySelfChooseProxy.Instance == nil then
    ActivitySelfChooseProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivitySelfChooseProxy:Init()
  self.selfChooseItems = {}
  self.selfChooseTasks = {}
end

function ActivitySelfChooseProxy:InitSelfChooseItems(data)
  local act_id = data.act_id
  local config = Table_ActPersonalTimer[act_id]
  if not config then
    return
  end
  local info = self.selfChooseItems[act_id]
  if not info then
    info = {}
    self.selfChooseItems[act_id] = info
  end
  if not config.OpenOnAccDay then
    local isTFBranch = EnvChannel.IsTFBranch()
    local phaseTime = StringUtil.FormatTime2TimeStamp2
    if isTFBranch then
      info.startTime = config.TfStartTime and phaseTime(config.TfStartTime)
    else
      info.startTime = config.StartTime and phaseTime(config.StartTime)
    end
  end
  info.endTime = data.end_time or 0
  info.drawCount = data.draw_count or 0
  if not info.items then
    info.items = {}
  end
  _TableClear(info.items)
  local items = data.item_datas
  for i = 1, #items do
    info.items[items[i].item_id] = items[i].draw_count or 0
  end
end

local _LeftDrawCountTaskId = 99999

function ActivitySelfChooseProxy:UpdateSelfChooseTasks(act_id, tasks, remainDrawCount)
  local info = self.selfChooseTasks[act_id]
  if not info then
    info = {}
    self.selfChooseTasks[act_id] = info
    info.tasks = {}
  end
  local leftCountTask = info.tasks[_LeftDrawCountTaskId]
  if not leftCountTask then
    leftCountTask = {}
    info.tasks[_LeftDrawCountTaskId] = leftCountTask
    leftCountTask.id = _LeftDrawCountTaskId
    leftCountTask.act_id = act_id
    leftCountTask.isLeftCountTask = true
  end
  remainDrawCount = remainDrawCount or 0
  leftCountTask.leftCount = remainDrawCount
  leftCountTask.state = 0 < remainDrawCount and EACTQUESTSTATE.EACT_QUEST_FINISH or nil
  for i = 1, #tasks do
    local id = tasks[i].id
    local task = info.tasks[id]
    if not task then
      task = {}
      info.tasks[id] = task
      task.id = id
      task.act_id = act_id
    end
    task.progress = tasks[i].process
    task.state = tasks[i].state
    task.leftCount = tasks[i].reward_count or 0
  end
  local isRed = false
  for _, task in pairs(info.tasks) do
    isRed = isRed or task.state == EACTQUESTSTATE.EACT_QUEST_FINISH and 0 < task.leftCount or false
  end
  if isRed then
    RedTipProxy.Instance:UpdateRedTip(ActivitySelfChooseProxy.RedTipId, {act_id})
  else
    RedTipProxy.Instance:RemoveWholeTip(ActivitySelfChooseProxy.RedTipId)
  end
end

function ActivitySelfChooseProxy:RecvSelfChooseDraw(data)
  local info = self.selfChooseItems[data.act_id]
  if info then
    info.drawCount = data.draw_count
    local count = info.items[data.result]
    count = count or 0
    count = count + 1
    info.items[data.result] = count
  end
end

function ActivitySelfChooseProxy:ClearSelfChooseItemsAndTasks(act_id)
  self.selfChooseItems[act_id] = nil
  self.selfChooseTasks[act_id] = nil
end

function ActivitySelfChooseProxy:GetSelfChooseItemNum(act_id, itemId)
  local info = self.selfChooseItems[act_id]
  if info and info.items then
    return info.items[itemId] or 0
  end
  return 0
end

function ActivitySelfChooseProxy:IsHaveLeftDrawCount(act_id)
  local info = self.selfChooseTasks[act_id]
  if info then
    local leftDrawCount = 0
    for _, task in pairs(info.tasks) do
      leftDrawCount = leftDrawCount + task.leftCount
    end
    return 0 < leftDrawCount
  end
  return false
end

function ActivitySelfChooseProxy:IsSelfChooseItemHasDrawed(act_id, itemId)
  local count = self:GetSelfChooseItemNum(act_id, itemId)
  return 0 < count
end

local _TaskSortFunc = function(l, r)
  if l.state == r.state then
    return l.id < r.id
  end
  if l.state == 1 or r.state == 1 then
    return l.state == 1
  end
  return l.state < r.state
end

function ActivitySelfChooseProxy:GetSelfChooseTasks(act_id)
  local tasks = {}
  local info = self.selfChooseTasks[act_id]
  if info and info.tasks then
    for id, task in pairs(info.tasks) do
      if id ~= _LeftDrawCountTaskId then
        tasks[#tasks + 1] = task
      end
    end
    table.sort(tasks, _TaskSortFunc)
    local leftCountTask = info.tasks[_LeftDrawCountTaskId]
    if leftCountTask.leftCount > 0 then
      table.insert(tasks, 1, leftCountTask)
    end
  end
  return tasks
end

function ActivitySelfChooseProxy:GetSelfChooseDrawedNum(act_id)
  local info = self.selfChooseItems[act_id]
  return info and info.drawCount or 0
end

function ActivitySelfChooseProxy:GetSelfChooseTargetDrawNum(act_id)
  local config = Table_ActPersonalTimer[act_id]
  if config and config.Misc then
    return config.Misc.RewardCount or 0
  end
  return 0
end

function ActivitySelfChooseProxy:IsActivityAvailable(act_id)
  local startTime = self:GetStartTime(act_id)
  local endTime = self:GetEndTime(act_id)
  local curTime = ServerTime.CurServerTime() / 1000
  if startTime then
    return startTime <= curTime and endTime > curTime
  end
  local info = self.selfChooseItems[act_id]
  return info ~= nil and endTime > curTime
end

function ActivitySelfChooseProxy:IsSelfChooseItemCanGet(act_id)
  local drawedNum = self:GetSelfChooseDrawedNum(act_id)
  local targetNum = self:GetSelfChooseTargetDrawNum(act_id)
  return drawedNum >= targetNum
end

function ActivitySelfChooseProxy:GetStartTime(act_id)
  local info = self.selfChooseItems[act_id]
  return info and info.startTime
end

function ActivitySelfChooseProxy:GetEndTime(act_id)
  local info = self.selfChooseItems[act_id]
  return info and info.endTime or 0
end

function ActivitySelfChooseProxy:GetRemainDay(act_id)
  local endTime = self:GetEndTime(act_id)
  local curTime = ServerTime.CurServerTime() / 1000
  local remainTime = endTime - curTime
  remainTime = math.max(remainTime, 0)
  local day = math.floor(remainTime / 86400)
  if day == 0 then
    local hour = math.floor(remainTime / 3600)
    return day, hour
  end
  return day
end
