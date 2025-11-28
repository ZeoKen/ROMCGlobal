autoImport("TeamPwsCustomRoomMemberCell")
PvpCustomRoomMemberCell = class("PvpCustomRoomMemberCell", TeamPwsCustomRoomMemberCell)

function PvpCustomRoomMemberCell:SetEmpty()
  if self.emptyGO then
    self.emptyGO:SetActive(false)
  end
  if self.bgGO then
    self.bgGO:SetActive(not self:IsEmpty())
  end
end
