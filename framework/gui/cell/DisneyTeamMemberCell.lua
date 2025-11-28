local BaseCell = autoImport("BaseCell")
DisneyTeamMemberCell = class("DisneyTeamMemberCell", BaseCell)
local _BGTexs = {
  "Disney_stage_bg_02",
  "Disney_stage_bg_02-1"
}
local _prepareStateColor = {
  "96f9a0",
  "f9c796",
  "96e8f9"
}

function DisneyTeamMemberCell:Init()
  if DisneyTeamMemberCell.ShowStaticPicture == nil then
    DisneyTeamMemberCell.ShowStaticPicture = not BackwardCompatibilityUtil.CompatibilityMode_V54 or ApplicationInfo.IsIphone7P_or_Worse() or ApplicationInfo.IsIpad6_or_Worse()
  end
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.roleTex = self:FindComponent("RoleTex", UITexture)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.bgTex1 = self:FindComponent("BgTex1", UITexture, self.bgTex.gameObject)
  self.selectStateLab = self:FindComponent("SelectStateLab", UILabel)
  self.stateLab = self:FindComponent("StateLab", UILabel)
  self.modelCameraConfig = UIModelCameraTrans.Team
  PictureManager.Instance:SetUI(_BGTexs[1], self.bgTex)
  PictureManager.Instance:SetUI(_BGTexs[2], self.bgTex1)
end

function DisneyTeamMemberCell:SetData(data)
  self.data = data
  if self:IsEmpty() then
    self:Show(self.selectStateLab)
    self:Hide(self.nameLab)
    self.selectStateLab.text = ZhString.DisneyTeam_EmptySeat
    self.stateLab.text = ZhString.DisneyTeam_Invite
    self:Hide(self.roleTex)
    local success, color = ColorUtil.TryParseHexString(_prepareStateColor[3])
    if success then
      self.stateLab.color = color
    end
  elseif nil ~= data then
    self:Show(self.nameLab)
    self.nameLab.text = data.name
    local isPrepared = DisneyStageProxy.Instance:IsPrepared(self.data.id)
    if isPrepared then
      self:Hide(self.selectStateLab)
      self.stateLab.text = ZhString.DisneyTeam_Prepared
    else
      self:Show(self.selectStateLab)
      self.stateLab.text = ZhString.DisneyTeam_Preparing
      self.selectStateLab.text = data:IsOffline() and ZhString.DisneyTeam_Offline or ZhString.DisneyTeam_SelectingRole
    end
    local prepareStatus = isPrepared and DisneyStageProxy.ETeamPrepareStatus.EPrepared or DisneyStageProxy.ETeamPrepareStatus.EPreparing
    local success, color = ColorUtil.TryParseHexString(_prepareStateColor[prepareStatus])
    if success then
      self.stateLab.color = color
    end
    self:Show(self.roleTex)
    self:UpdateRole()
  end
end

function DisneyTeamMemberCell:UpdateRole()
  local heroid = DisneyStageProxy.Instance:GetHeroId(self.data.id)
  if heroid == 0 then
    return
  end
  self.parts = Asset_RoleUtility.CreateNpcRoleParts(heroid)
  UIModelUtil.Instance:ResetTexture(self.roleTex)
  UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, self.parts, self.modelCameraConfig, nil, nil, DisneyTeamMemberCell.ShowStaticPicture, nil, function(obj)
    self.modelAssetRole = obj
    self:RTCallBack()
  end)
  UIModelUtil.Instance:SetCellTransparent(self.roleTex)
end

function DisneyTeamMemberCell:RTCallBack()
  local roleComplete = self.modelAssetRole.complete
  if not roleComplete or not roleComplete.body then
    return
  end
  local ps = roleComplete.gameObject:GetComponentsInChildren(ParticleSystem)
  for i = 1, #ps do
    self:Hide(ps[i])
  end
end

function DisneyTeamMemberCell:IsEmpty()
  return self.data == nil or self.data == MyselfTeamData.EMPTY_STATE or self.data == MyselfTeamData.EMPTY_STATE_GROUP
end

function DisneyTeamMemberCell:OnRemove()
  if nil ~= self.parts then
    Asset_Role.DestroyPartArray(self.parts)
    self.parts = nil
  end
end

function DisneyTeamMemberCell:UnloadModel()
  if self.roleTex then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.roleTex)
    UIModelUtil.Instance:ResetTexture(self.roleTex)
    self.modelAssetRole = nil
  end
end

function DisneyTeamMemberCell:OnDestroy()
  self:UnloadModel()
  PictureManager.Instance:UnLoadUI(_BGTexs[1], self.bgTex)
  PictureManager.Instance:UnLoadUI(_BGTexs[2], self.bgTex1)
end
