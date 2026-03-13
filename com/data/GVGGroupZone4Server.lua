local _ArrayPushBack = TableUtility.ArrayPushBack
GVGGroupZone4Server = class("GVGGroupZone4Server")

function GVGGroupZone4Server:ctor(server_group_id, server_zoneids)
  self.server_group_id = server_group_id
  self.server_zoneids = {}
  for i = 1, #server_zoneids do
    _ArrayPushBack(self.server_zoneids, server_zoneids[i])
  end
  table.sort(self.server_zoneids)
end
