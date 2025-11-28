local _PveMatchSelfBg = "team_position_me"
local _PveMatchOtherBg = "team_position_00"
local _CellHeight = 35
autoImport("SelectRoleCell")
PveMatchTeammateCell = class("PveMatchTeammateCell", BaseCell)

function PveMatchTeammateCell:Init()
  self.switchOpen = false
  self.curRoleId = MyselfProxy.Instance:GetMyDefaultTeamRole()
  self.roles = MyselfProxy.Instance:GetMyTeamRoles()
  self:FindObj()
end

function PveMatchTeammateCell:FindObj()
  self.emptyRoot = self:FindGO("EmptyRoot")
  self.root = self:FindGO("Root")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self:FindGO("headContainer"))
  self.headIcon:SetScale(1)
  self.headIcon:SetMinDepth(30)
  self.defaultHeadRoot = self:FindGO("DefaultHead")
  self.headData = HeadImageData.new()
  self.objProfession = self:FindGO("ProfessionFunction")
  self.sprProfession = self:FindComponent("Icon", UIMultiSprite, self.objProfession)
  self.sprProfessionBG = self:FindComponent("Color", UIMultiSprite, self.objProfession)
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.selfLab = self:FindComponent("SelfLab", UILabel)
  self.switchBtn = self:FindGO("SwitchBtn")
  self.bgSprite = self:FindComponent("Bg", UISprite)
  self.leader = self:FindGO("Leader")
  self.switchRoot = self:FindGO("SwitchRoot")
  self:Hide(self.switchRoot)
  self.switchBg = self:FindComponent("SwitchBg", UISprite)
  self.switchGrid = self:FindGO("SwitchGrid"):GetComponent(UIGrid)
  self.switchCtrl = UIGridListCtrl.new(self.switchGrid, SelectRoleCell, "PveMatchSelectRoleCell")
  self.switchCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSwitchRole, self)
  self:AddClickEvent(self.switchBtn, function()
    self.switchOpen = not self.switchOpen
    self:ShowSwitch()
  end)
end

function PveMatchTeammateCell:ShowSwitch()
  if not self.switchOpen then
    self:Hide(self.switchRoot)
    return
  end
  self:Show(self.switchRoot)
  self.switchCtrl:ResetDatas(self.roles)
  self.switchBg.height = _CellHeight * #self.roles
end

function PveMatchTeammateCell:OnClickSwitchRole(cell)
  if not cell or not cell.data then
    return
  end
  if self.curRoleId ~= cell.data then
    self.curRoleId = cell.data
    self:SetProfession(self.curRoleId)
    if TeamProxy.Instance:IHaveTeam() then
      ServiceSessionTeamProxy.Instance:CallTeamMemberApply(TeamProxy.Instance.myTeam.id, self.curRoleId)
    end
  end
  self.switchOpen = not self.switchOpen
  self:ShowSwitch()
end

function PveMatchTeammateCell:SetData(data)
  self.data = data
  local isEmpty = not data or data == MyselfTeamData.EMPTY_STATE
  if isEmpty then
    self:Show(self.emptyRoot)
    self:Hide(self.root)
    self.bgSprite.spriteName = _PveMatchOtherBg
    return
  end
  self:Show(self.root)
  self:Hide(self.emptyRoot)
  self.id = data.id
  local isSelf = self.id == Game.Myself.data.id
  self.selfLab.text = isSelf and ZhString.PveMatchPopup_Self or ""
  self.bgSprite.spriteName = isSelf and _PveMatchSelfBg or _PveMatchOtherBg
  self.switchBtn:SetActive(isSelf and TeamProxy.Instance:IHaveTeam())
  self.leader:SetActive(TeamProxy.Instance:GetTeamLeaderId() == self.id)
  local roleFunctionId
  if isSelf then
    roleFunctionId = data.role and data.role ~= 0 and data.role or MyselfProxy.Instance:GetMyDefaultTeamRole()
  else
    roleFunctionId = data.role and data.role ~= 0 and data.role or ProfessionProxy.Instance:GetDefaultTeamRoleByPro(data.profession)
  end
  self.sprProfession.CurrentState = roleFunctionId
  self.sprProfessionBG.CurrentState = roleFunctionId
  self:SetPlayerHead()
end

function PveMatchTeammateCell:SetProfession(roleFunctionId)
  self.sprProfession.CurrentState = roleFunctionId
  self.sprProfessionBG.CurrentState = roleFunctionId
end

function PveMatchTeammateCell:SetPlayerHead()
  self.headData:Reset()
  if self.data.__cname == "TeamMemberData" then
    self.headData:TransByTeamMemberData(self.data)
  else
    self.headData:TransByMyself()
  end
  if self.headData.iconData then
    self:Hide(self.defaultHeadRoot)
    self:Show(self.headIcon.gameObject)
    if self.headData.iconData.type == HeadImageIconType.Avatar then
      self.headIcon:SetData(self.headData.iconData)
    elseif self.headData.iconData.type == HeadImageIconType.Simple then
      self.headIcon:SetSimpleIcon(self.headData.iconData.icon, self.headData.iconData.frameType)
      self.headIcon:SetPortraitFrame(self.headData.iconData.portraitframe)
    end
  else
    self:Hide(self.headIcon.gameObject)
    self:Show(self.defaultHeadRoot)
  end
  self.nameLab.text = self.headData.name
end
