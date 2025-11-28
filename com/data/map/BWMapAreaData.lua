BWMapAreaData = class("BWMapAreaData")
autoImport("BWMapZoneData")

function BWMapAreaData:ctor(zoneMap)
  self.zoneDatas = {}
  self.id = nil
  self.staticData = nil
  for id, zoneData in pairs(zoneMap) do
    if zoneData.AreaId == zoneData.id then
      self.id = id
      self.staticData = zoneData
    else
      table.insert(self.zoneDatas, BWMapZoneData.new(zoneData))
    end
  end
  if not self.staticData then
    local default = self.zoneDatas[1]
    self.id = default.id
    self.staticData = default
    roerr("BWMapZone表中未找到配置 id", default.AreaId)
  end
  table.sort(self.zoneDatas, function(a, b)
    return a.id < b.id
  end)
end

function BWMapAreaData:GetName()
  return self.staticData.NameZh
end

function BWMapAreaData:GetProgress()
  local f, g = 0, 0
  for i = 1, #self.zoneDatas do
    local zf, zg = self.zoneDatas[i]:GetProgress()
    f = f + zf
    g = g + zg
  end
  return f, g
end

function BWMapAreaData:GetCenter()
  if self.staticData and self.staticData.Center then
    return self.staticData.Center
  end
end

function BWMapAreaData:GetZoneDatas()
  return self.zoneDatas
end
