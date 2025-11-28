autoImport("ChatRoomRecruitCell")
ChatRoomSomeoneRecruitCell = reusableClass("ChatRoomSomeoneRecruitCell", ChatRoomRecruitCell)
ChatRoomSomeoneRecruitCell.rid = ResourcePathHelper.UICell("ChatRoomSomeoneRecruitCell")

function ChatRoomSomeoneRecruitCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomSomeoneRecruitCell.rid, parent)
  end
end
