BWMapZoneData = class("BWMapZoneData")
autoImport("BWEventData")

function BWMapZoneData:ctor(zoneData)
  self.id = zoneData.id
  self.staticData = zoneData
  self.events = {}
  local events = self.staticData.Event
  if events then
    if events.Quest then
      for i = 1, #events.Quest do
        self:AddEvent(BWEventData.Type.Quest, events.Quest[i])
      end
    end
    if events.MapStep then
      for i = 1, #events.MapStep do
        self:AddEvent(BWEventData.Type.MapStep, events.MapStep[i])
      end
    end
  end
end

function BWMapZoneData:AddEvent(type, id)
  table.insert(self.events, BWEventData.new(type, id))
end

function BWMapZoneData:GetName()
  return self.staticData.NameZh
end

function BWMapZoneData:GetProgress()
  local max = #self.events
  local count = 0
  for i = 1, max do
    if self.events[i]:IsCompleted() then
      count = count + 1
    end
  end
  return count, max
end

function BWMapZoneData:GetProgressPct()
  local c, d = self:GetProgress()
  local pct = 0
  if 0 < d then
    pct = c / d
  end
  pct = math.clamp01(pct)
  return math.floor(pct * 100)
end

function BWMapZoneData:GetEvents()
  return self.events
end

function BWMapZoneData:GetCenter()
  if self.staticData and self.staticData.Center then
    return self.staticData.Center
  end
end

function BWMapZoneData:GetGroupId()
  if self.staticData and self.staticData.GroupId then
    return self.staticData.GroupId
  end
end

function BWMapZoneData:GetBlockCenter()
  if self.staticData and self.staticData.BlockCenter then
    return self.staticData.BlockCenter
  end
end

function BWMapZoneData:RefreshData()
  for i = 1, #self.events do
    self.events[i]:RefreshData()
  end
end

function BWMapZoneData:DebugPrintProgressInfo()
  local max = #self.events
  local info = "区域:" .. self:GetName() .. " " .. self:GetGroupId() .. "\n"
  for i = 1, max do
    info = info .. self.events[i]:GetDebugPrintProgressInfo() .. "\n"
  end
  redlog(info)
end
