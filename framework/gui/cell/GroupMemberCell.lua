local BaseCell = autoImport("TeamMemberCell")
GroupMemberCell = class("GroupMemberCell", TeamMemberCell)

function GroupMemberCell:Init()
  GroupMemberCell.super.Init(self)
  self.objTeamId = self:FindGO("TeamId")
  self.labTeamId = self.objTeamId:GetComponent(UILabel)
  self.sprTeamIdBoard = self:FindComponent("Board", UISprite, self.objTeamId)
  self.selected = self:FindGO("Selected")
  self.cancelSelectBtn = self:FindGO("cancelBtn", self.selected)
  self:AddClickEvent(self.gameObject, function()
    self:OnCellClick()
  end)
  self:AddClickEvent(self.cancelSelectBtn, function()
    self:OnCancelSelectBtnClick()
  end)
  self.switchTarget = self:FindGO("SwitchTarget")
  self.modelCameraConfig = UIModelCameraTrans.Raid
end

function GroupMemberCell:InitRichLabel()
  self.lv = self:FindComponent("Lv", UIRichLabel)
  self.nameSL = SpriteLabel.new(self.lv, nil, 22, 22, true)
end

function GroupMemberCell:SetData(data)
  if self.roleTexture then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.roleTexture)
  end
  GroupMemberCell.super.SetData(self, data)
  if self:IsEmpty() or not data.groupTeamIndex then
    return
  end
  local showTeamID = not data:IsOffline() and (data.job == SessionTeam_pb.ETEAMJOB_LEADER or jobType == SessionTeam_pb.ETEAMJOB_TEMPLEADER)
  self.objTeamId:SetActive(showTeamID)
  if showTeamID then
    self.labTeamId.text = string.format(ZhString.TeamMemberCell_TeamIndex, data.groupTeamIndex)
    self.sprTeamIdBoard.spriteName = "team_bg_team" .. data.groupTeamIndex
  end
end

function GroupMemberCell:SetBackgroundFrame(id)
  if not self.portraitFrame then
    return
  end
  self:SetBackground(id)
  if id then
    local data = Table_UserBackground[id]
    if data then
      PictureManager.Instance:SetPVP(data.Icon, self.portraitFrame)
      if not self.portraitFrame.gameObject.activeInHierarchy then
        self.portraitFrame.gameObject:SetActive(true)
      end
      if not self.loaded then
        self:PlayEffectByFullPath("UI/" .. data.GroupEffect, self.effectContainer)
        self.loaded = true
      end
      if not self.effectContainer.activeInHierarchy then
        self.effectContainer:SetActive(true)
      end
      return
    end
  end
  self.portraitFrame.gameObject:SetActive(false)
  self.effectContainer:SetActive(false)
  IconManager:SetUIIcon("", self.portraitFrame)
end

function GroupMemberCell:OnCellClick()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function GroupMemberCell:SetSelectedState(state)
  self.selected:SetActive(state)
end

function GroupMemberCell:OnCancelSelectBtnClick()
  self:SetSelectedState(false)
  self:PassEvent(TeamEvent.CancelMemberSelect, self)
end

function GroupMemberCell:SetSwitchTargetState(state)
  self.switchTarget:SetActive(state)
end
