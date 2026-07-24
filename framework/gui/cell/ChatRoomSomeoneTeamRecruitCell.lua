autoImport("ChatRoomMyselfTeamRecruitCell")
ChatRoomSomeoneTeamRecruitCell = reusableClass("ChatRoomSomeoneTeamRecruitCell", ChatRoomMyselfTeamRecruitCell)
ChatRoomSomeoneTeamRecruitCell.rid = ResourcePathHelper.UICell("ChatRoomSomeoneTeamRecruitCell")

function ChatRoomSomeoneTeamRecruitCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomSomeoneTeamRecruitCell.rid, parent)
  end
end

function ChatRoomSomeoneTeamRecruitCell:SetApplyData(data)
  TimeTickManager.Me():ClearTick(self, 1)
  self.gotoBtn:SetActive(true)
  self.countdownLabel.text = ""
end
