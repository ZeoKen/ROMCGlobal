autoImport("BaseCombineCell")
autoImport("PvpCustomRoomMemberCell")
PvpCustomRoomMemberCombineCell = class("PvpCustomRoomMemberCombineCell", BaseCombineCell)

function PvpCustomRoomMemberCombineCell:Init()
  self:InitCells(2, "PvpCustomRoomMemberCell", PvpCustomRoomMemberCell)
end
