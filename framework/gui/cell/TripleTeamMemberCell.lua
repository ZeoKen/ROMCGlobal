autoImport("TeamPwsMemberCell")
autoImport("TripleTeamSeasonLevelCell")
TripleTeamMemberCell = class("TripleTeamMemberCell", TeamPwsMemberCell)

function TripleTeamMemberCell:FindObjs()
  TripleTeamMemberCell.super.FindObjs(self)
  self.levelContainer = self:FindGO("LevelCellContainer")
  self.emptyLevel = self:FindGO("EmptyLevel")
  self.seasonLevelCell = TripleTeamSeasonLevelCell.new(self.levelContainer)
end

function TripleTeamMemberCell:SetData(data)
  self.data = data
  if data then
    local isEmpty = data == MyselfTeamData.EMPTY_STATE
    self.objDefault:SetActive(isEmpty)
    self.objContents:SetActive(not isEmpty)
    if not isEmpty then
      self.charID = data.id
      local proData = Table_Class[data.profession]
      self.objProfession:SetActive(proData and IconManager:SetNewProfessionIcon(proData.icon, self.sprProfession) or false)
      if proData then
        self.sprProfessionBG.color = ColorUtil[string.format("CareerIconBg%s", proData.Type)] or ColorUtil.CareerIconBg0
      end
      self.headData:Reset()
      self.headData:TransByTeamMemberData(data)
      if self.headData.iconData then
        self.headIcon.gameObject:SetActive(true)
        self.objDefaultHead:SetActive(false)
        if self.headData.iconData.type == HeadImageIconType.Avatar then
          self.headIcon:SetData(self.headData.iconData)
        elseif self.headData.iconData.type == HeadImageIconType.Simple then
          self.headIcon:SetSimpleIcon(self.headData.iconData.icon, self.headData.iconData.frameType)
          self.headIcon:SetPortraitFrame(self.headData.iconData.portraitframe)
        end
      else
        self.headIcon.gameObject:SetActive(false)
        self.objDefaultHead:SetActive(true)
      end
      self.labName.text = data:GetName()
      local userInfo = PvpProxy.Instance:GetTriplePwsTeamUserInfo(data.id)
      self.seasonLevelCell:SetData(userInfo)
    end
  end
end
