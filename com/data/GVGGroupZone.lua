local zoneSeparator = ","
GVGGroupZone = class("GVGGroupZone")

function GVGGroupZone:ctor(groupid, zoneids, client_group_index)
  self.server_groupid = groupid
  self.server_id = GvgProxy.GetServerIdByGroupId(groupid)
  self.groupid = client_group_index
  self.uiGroupId = string.format(ZhString.NewGVG_GroupID, self.groupid)
  self.zoneMap = {}
  self.simplyZoneMap = {}
  self.uiZones = ""
  if not zoneids then
    return
  end
  local strZone, simplyZoneId
  for i = 1, #zoneids do
    self.zoneMap[zoneids[i]] = 1
    simplyZoneId = ChangeZoneProxy.Instance:GetSimpleZoneId(zoneids[i])
    self.simplyZoneMap[simplyZoneId] = 1
    strZone = ChangeZoneProxy.Instance:ZoneNumToString(zoneids[i])
    if i == 1 then
      self.uiZones = strZone
    else
      self.uiZones = self.uiZones .. zoneSeparator .. strZone
    end
  end
end

function GVGGroupZone:GetGroupIdStr()
  return self.uiGroupId
end

function GVGGroupZone:GetZoneStr()
  return self.uiZones
end

function GVGGroupZone:CheckZoneIndex(zoneid)
  return nil ~= self.zoneMap[zoneid]
end

function GVGGroupZone:CheckSimplyZoneIndex(zoneid)
  return nil ~= self.simplyZoneMap[zoneid]
end
