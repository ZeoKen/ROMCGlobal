autoImport("ChatRoomRecruitCell")
ChatRoomMyselfRecruitCell = reusableClass("ChatRoomMyselfRecruitCell", ChatRoomRecruitCell)
ChatRoomMyselfRecruitCell.rid = ResourcePathHelper.UICell("ChatRoomMyselfRecruitCell")

function ChatRoomMyselfRecruitCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomMyselfRecruitCell.rid, parent)
  end
end
