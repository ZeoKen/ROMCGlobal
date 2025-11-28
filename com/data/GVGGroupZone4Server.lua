local _ArrayPushBack = TableUtility.ArrayPushBack
GVGGroupZone4Server = class("GVGGroupZone4Server")

function GVGGroupZone4Server:ctor(groupid, zoneids)
  self.groupid = groupid
  self.zoneids = {}
  for i = 1, #zoneids do
    _ArrayPushBack(self.zoneids, zoneids[i])
  end
  table.sort(self.zoneids)
end
