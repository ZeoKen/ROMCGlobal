autoImport("Stopwatch")
StopwatchManager = class("StopwatchManager")
StopwatchManager.MaxStopwatchCount = 100

function StopwatchManager.Me()
  if StopwatchManager.me == nil then
    StopwatchManager.me = StopwatchManager.new()
  end
  return StopwatchManager.me
end

function StopwatchManager:ctor()
  self.stopwatchMap = {}
end

function StopwatchManager:CreateStopwatch(pauseFunc, owner)
  self.stopwatchMap[owner] = self.stopwatchMap[owner] or {}
  local id = 0
  for i = 1, StopwatchManager.MaxStopwatchCount do
    if self.stopwatchMap[owner][i] == nil then
      id = i
      break
    end
  end
  if id == 0 then
    LogUtility.Warning("Stopwatch已满")
    return
  end
  local stopwatch = self.stopwatchMap[owner][id]
  if stopwatch then
    stopwatch:ResetData(pauseFunc, owner, id)
  else
    stopwatch = Stopwatch.new(pauseFunc, owner, id)
    self.stopwatchMap[owner][id] = stopwatch
  end
  return stopwatch
end

function StopwatchManager:HasStopwatch(owner, id)
  local stopwatches = self.stopwatchMap[owner]
  return stopwatches ~= nil and stopwatches[id] ~= nil
end

function StopwatchManager:ClearStopwatch(owner, id)
  if not self.stopwatchMap[owner] then
    return
  end
  if id then
    self.stopwatchMap[owner][id] = nil
    if not next(self.stopwatchMap[owner]) then
      self.stopwatchMap[owner] = nil
    end
  else
    self.stopwatchMap[owner] = nil
  end
end

function StopwatchManager:ClearAll()
  TableUtility.TableClear(self.stopwatchMap)
end
