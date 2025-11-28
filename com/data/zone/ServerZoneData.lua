ServerZoneData = class("ServerZoneData")

function ServerZoneData:ctor(data)
  self.map = {}
  self:SetData(data)
end

function ServerZoneData:SetData(data)
  self.serverid = data.serverid
  self.groupid = data.groupid
  self.tradegroupid = data.tradegroupid
  self.pretradegroupid = data.pretradegroupid
  local info, num
  for i = 1, #data.zoneinfos do
    info = data.zoneinfos[i]
    num = math.fmod(info.zoneid, 10000)
    self.map[num] = info.name
  end
end

function ServerZoneData:GetDisplayZoneName(id)
  return self.map[id]
end

function ServerZoneData:GetZoneId(name)
  for k, v in pairs(self.map) do
    if v == name then
      return k
    end
  end
  return nil
end
