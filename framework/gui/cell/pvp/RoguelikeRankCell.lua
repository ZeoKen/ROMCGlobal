autoImport("TeamPwsRankCell")
RoguelikeRankCell = class("RoguelikeRankCell", TeamPwsRankCell)

function RoguelikeRankCell:UpdateHead()
  if not self.data then
    return
  end
  if type(self.data.user) ~= "table" then
    LogUtility.Error("Cannot find user when updating RoguelikeRankCell!")
    return
  end
  self:_UpdateHead(self.data.user, self.objProfession, self.headIcon, self.objDefaultHead)
end

function RoguelikeRankCell:UpdateName()
  if not self.data or not self.data.user then
    return
  end
  self.labName.text = self.data.user.name
end

function RoguelikeRankCell:UpdateGrade()
  if not self.labGrade or not self.data then
    return
  end
  self.labGrade.gameObject:SetActive(self.data.grade ~= nil)
  self.labGrade.text = self.data.grade
end

function RoguelikeRankCell:ResetHeadData(data)
  self.headData:Reset()
  self.headData:TransByRoguelikeUserData(data)
end

function RoguelikeRankCell:ClickHead()
  self:PassEvent(MouseEvent.MouseClick, {
    headCell = self.headIcon,
    userData = self.data.user
  })
end
