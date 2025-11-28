local BaseCell = autoImport("BaseCell")
TeamMemberPreviewCell = class("TeamMemberPreviewCell", BaseCell)
local tempVector3 = LuaVector3.Zero()

function TeamMemberPreviewCell:Init()
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.mapname = self:FindComponent("MapName", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.zoneId = self:FindComponent("ZoneId", UILabel)
  self.roleTexture = self:FindComponent("RoleTexture", UITexture)
  self.modelCameraConfig = UIModelCameraTrans.Team
  self.portraitFrame = self:FindGO("PortraitFrame"):GetComponent(UITexture)
  self.effectContainer = self:FindGO("effectContainer")
  self.effectParent = self.effectContainer:GetComponent(ChangeRqByTex)
end

function TeamMemberPreviewCell:SetData(bgID)
  local userData = Game.Myself.data.userdata
  local level = userData:Get(UDEnum.ROLELEVEL) or 1
  self.lv.text = "Lv." .. level
  self.name.text = Game.Myself.data.name
  local mapid = SceneProxy.Instance:GetCurMapID()
  local data = mapid and Table_Map[mapid]
  self.mapname.text = data and data.NameZh or ""
  local parts = Asset_Role.CreatePartArray()
  local _partIndex = Asset_Role.PartIndex
  local _partIndexEX = Asset_Role.PartIndexEx
  parts[_partIndex.Body] = userData:Get(UDEnum.BODY) or 0
  parts[_partIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
  parts[_partIndex.Eye] = userData:Get(UDEnum.EYE) or 0
  parts[_partIndex.LeftWeapon] = 0
  parts[_partIndex.RightWeapon] = 0
  parts[_partIndex.Head] = userData:Get(UDEnum.HEAD) or 0
  parts[_partIndex.Wing] = userData:Get(UDEnum.BACK) or 0
  parts[_partIndex.Face] = userData:Get(UDEnum.FACE) or 0
  parts[_partIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
  parts[_partIndex.Mount] = 0
  parts[_partIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
  parts[_partIndexEX.Gender] = userData:Get(UDEnum.SEX) or 0
  parts[_partIndexEX.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR)
  parts[_partIndexEX.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
  UIModelUtil.Instance:ResetTexture(self.roleTexture)
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, parts, nil, nil, nil, nil, nil, function(obj)
    self.model = obj
    self:SetPortraitFrame(bgID)
  end)
  self.model:RegisterWeakObserver(self)
  if self.model then
    LuaVector3.Better_Set(tempVector3, 0, -0.15, 0)
    self.model:SetPosition(tempVector3)
    LuaVector3.Better_Set(tempVector3, -0.67, 13.62, 0)
    self.model:SetEulerAngleY(tempVector3)
  end
  Asset_Role.DestroyPartArray(parts)
end

function TeamMemberPreviewCell:ObserverDestroyed(obj)
  if obj == self.model then
    self.model = nil
  end
end

function TeamMemberPreviewCell:SetPortraitFrame(id)
  if not self.portraitFrame then
    return
  end
  self:SetBackground(id)
  if id then
    local data = Table_UserBackground[id]
    if data then
      PictureManager.Instance:SetPVP(data.Icon, self.portraitFrame)
      self.portraitFrame.gameObject:SetActive(true)
      if not self.loaded then
        self:PlayEffectByFullPath("UI/" .. data.Effect, self.effectContainer, false, function()
          self.effectParent.excute = false
        end)
        self.loaded = true
      end
      self.effectContainer:SetActive(true)
      return
    end
  end
  self.portraitFrame.gameObject:SetActive(false)
  self.effectContainer:SetActive(false)
  IconManager:SetUIIcon("", self.portraitFrame)
end

function TeamMemberPreviewCell:DestroyChildren(obj)
  local objNil = Game.GameObjectUtil:ObjectIsNULL(obj)
  if not objNil then
    local childCount = obj.transform.childCount
    if 0 < childCount then
      for i = 0, childCount - 1 do
        GameObject.DestroyImmediate(obj.transform:GetChild(i).gameObject)
      end
    end
  end
  return not objNil
end

function TeamMemberPreviewCell:SetBackground(id)
  local frameBG = Table_UserBackground[id] and Table_UserBackground[id].Background
  if frameBG then
    UIModelUtil.Instance:ChangeBGMeshRenderer(frameBG, self.roleTexture)
  else
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.roleTexture)
  end
end

function TeamMemberPreviewCell:ResetPortraitFrame()
  if self.effectContainer then
    self:DestroyChildren(self.effectContainer)
    self.loaded = false
  end
end

function TeamMemberPreviewCell:OnDestroy()
  if self.roleTexture then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.roleTexture)
  end
end
