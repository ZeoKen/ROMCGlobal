MaxVoicesManager = class("MaxVoicesManager")

function MaxVoicesManager:ctor()
  self.clipCounts = {}
  self.clipTimeMap = {}
  self:Init()
end

function MaxVoicesManager:Init()
  for audioSourceType, limit in pairs(VoicesConfigMap) do
    self.clipCounts[audioSourceType] = {}
    self.clipCounts[audioSourceType].VoicesCount = limit
    self.clipTimeMap[audioSourceType] = {}
  end
end

function MaxVoicesManager:AddClipCount(sourcetype, path, length)
  if not (sourcetype and path) or not length then
    return false
  end
  local clipsMaps = self.clipCounts[sourcetype]
  if not clipsMaps then
    return false
  end
  local timeMap = self.clipTimeMap[sourcetype]
  local timeStack = timeMap[path]
  if not timeQueue then
    timeQueue = LuaQueue.new()
    timeMap[path] = timeQueue
  end
  local curTime = ServerTime.CurServerTime() / 1000
  local nextTime = curTime + length
  local oldestTime = timeQueue:Peek()
  if oldestTime and curTime > oldestTime then
    timeQueue:Pop()
    timeQueue:Push(nextTime)
  elseif not oldestTime then
    timeQueue:Push(nextTime)
  else
    local cCount = timeQueue:Count()
    if cCount and cCount >= clipsMaps.VoicesCount then
      return false
    end
    timeQueue:Push(nextTime)
    return true
  end
  return true
end

function MaxVoicesManager:RemoveClipCount(sourcetype, path)
  if not sourcetype or not path then
    return false
  end
  local clipsMaps = self.clipCounts[sourcetype]
  if not clipsMaps then
    return
  end
  local timeMap = self.clipTimeMap[sourcetype]
  local timeQueue = timeMap[path]
  if timeQueue then
    timeQueue:Pop()
  end
end

function MaxVoicesManager:Clear()
  for audioSourceType, clips in pairs(self.clipCounts) do
    for path, value in pairs(clips) do
      self.clipCounts[audioSourceType][path] = 0
    end
  end
end
