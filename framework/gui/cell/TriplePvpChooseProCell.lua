local _TextureName_Suffix = {
  [1] = "red",
  [2] = "yellow",
  [3] = "blue",
  [4] = "green"
}
local _CampLabColor = {
  [1] = "e66677",
  [2] = "e28500",
  [3] = "7e7ced",
  [4] = "29a75c"
}
local _ProfessionEffectColor = {
  [1] = "d4003c",
  [2] = "d47900",
  [3] = "6367d9",
  [4] = "26a75d"
}
local _CampTexture_Prefix = "3v3_card_"
local _CampRoleFrameTexture_Prefix = "3v3_cardlight_"
local _NoneTexture_Prefix = "3v3_role_"
local _ChoosenSp_Prefix = "3v3v3_bg_yes_"
local _ProfessionTexture_Prefix = "3v3_bottom_"
local _Bottem_TextureName = "3v3_bottem_01"
local _Choosen_TextureName = "3v3_bottom_04"
local _Proxy, _PicMgr
local _tweenDuration = 1
local _beginTweenScale = TweenScale.Begin
local _beginTweenAlpha = TweenAlpha.Begin
local _beginTweenPosition = TweenPosition.Begin
local _setLocalPositionGO = LuaGameObject.SetLocalPositionGO
local _setLocalScaleGO = LuaGameObject.SetLocalScaleGO
local _initialVecScale = 1.1
local _choosing_Scale = 1
local _choosing_SmallScale = 0.76
local _CampCellDelayTime = {
  [1] = {
    [1] = 400,
    [2] = 700,
    [3] = 1000
  },
  [2] = {
    [1] = 1000,
    [2] = 700,
    [3] = 400
  },
  [3] = {
    [1] = 400,
    [2] = 1000,
    [3] = 400
  }
}
local _containIndexPos = {
  [1] = {516, 765},
  [2] = {258, 786},
  [3] = {258, 516}
}
local _myCampCellPos = {
  0,
  400,
  800
}
local baseCell = autoImport("BaseCell")
TriplePvpChooseProCell = class("TriplePvpChooseProCell", baseCell)
local move_duration = 0.3

function TriplePvpChooseProCell:TryPlayAnimation()
  if self.animationPlay then
    return
  end
  if not self:HasData() then
    return
  end
  local index = self.data and self.data:GetIndex()
  if not index then
    return
  end
  local root = self.campTexture and self.campTexture.gameObject
  if not root then
    return
  end
  local camp = self.data.camp
  if not camp then
    return
  end
  local _Proxy = TriplePlayerPvpProxy.Instance
  local delayTimeConfig
  for i = 1, 3 do
    if camp == _Proxy:GetCamp(i) then
      delayTimeConfig = _CampCellDelayTime[i]
      break
    end
  end
  if not delayTimeConfig then
    return
  end
  local delayTime = delayTimeConfig[index]
  if not delayTime then
    return
  end
  local isMyCamp = camp == _Proxy:GetCamp(3)
  local inOB = PvpObserveProxy.Instance:IsRunning()
  if isMyCamp then
    local x = _myCampCellPos[index]
    _setLocalPositionGO(self.gameObject, x, 0, 0)
  end
  if inOB then
    return
  end
  local choosing_scale = isMyCamp and _choosing_SmallScale or _choosing_Scale
  _setLocalScaleGO(self.choosingLab.gameObject, choosing_scale, choosing_scale, choosing_scale)
  _setLocalScaleGO(root, _initialVecScale, _initialVecScale, _initialVecScale)
  _beginTweenAlpha(root, 0, 0)
  TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
    _beginTweenAlpha(root, _tweenDuration, 1)
    _beginTweenScale(root, _tweenDuration, LuaGeometry.Const_V3_one)
    if isMyCamp then
      TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
        local i = _Proxy.myselfIndex
        if 1 < index then
          local pos_config = _containIndexPos[i]
          local pos = LuaGeometry.GetTempVector3(pos_config[index - 1], 0, 0)
          _beginTweenPosition(self.gameObject, move_duration, pos)
        else
          _beginTweenPosition(self.gameObject, move_duration, LuaGeometry.Const_V3_zero)
        end
      end, self, 2)
    end
    TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
      _beginTweenAlpha(self.choosingLab.gameObject, _tweenDuration, 1)
    end, self, 3)
    self.animationPlay = true
  end, self, 1)
end

function TriplePvpChooseProCell:Init()
  _PicMgr = PictureManager.Instance
  TriplePvpChooseProCell.super.Init(self)
  self:FindObj()
end

function TriplePvpChooseProCell:FindObj()
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.lvLab = self:FindComponent("LvLab", UILabel)
  self.campTexture = self:FindComponent("CampTexture", UITexture)
  self.noneTexture = self:FindComponent("NoneTexture", UITexture)
  self.choosingLab = self:FindComponent("ChoosingLab", UILabel)
  self.choosingLab.text = ZhString.TriplePlayerPvp_Choosing
  self.choosingLab.alpha = 0
  self.bottomTexture = self:FindComponent("BottomTexture", UITexture)
  self.roleTexture = self:FindComponent("RoleTexture", UITexture)
  self.choosenSp = self:FindComponent("ChoosenSprite", UISprite)
  self.professionSp = self:FindComponent("Pro", UISprite)
  self.professionLab = self:FindComponent("ProLab", UILabel, self.professionSp.gameObject)
  self.professionTexture = self:FindComponent("ProfessionTexture", UITexture, self.professionSp.gameObject)
  self.emptyLab = self:FindComponent("EmptyLab", UILabel)
  self.emptyLab.text = ZhString.TriplePlayerPvp_EmptyPlayer
  self.roleFrameTexture = self:FindComponent("RoleFrameTexture", UITexture)
  _PicMgr:SetTriplePvpTexture(_Bottem_TextureName, self.bottomTexture)
  self.choosenEffectContainer = self:FindGO("ChoosenEffectContainer")
  self.choosenEffect = self:PlayUIEffect(EffectMap.UI.TriplePvp_Frame, self.choosenEffectContainer, false)
  self.choosenEffectContainer:SetActive(false)
end

function TriplePvpChooseProCell:DestroyChoosenEffect()
  if self.choosenEffect then
    self.choosenEffect:Destroy()
    self.choosenEffect = nil
  end
end

function TriplePvpChooseProCell:HasData()
  if not self.data or self.data == TriplePlayerPvpData.EmptyMember then
    return false
  end
  return true
end

function TriplePvpChooseProCell:SetData(data)
  self.data = data
  self:TryPlayAnimation()
  self:SetCampInfo()
  self:SetBaseData()
  self:SetModel()
end

function TriplePvpChooseProCell:SetBaseData()
  if not self:HasData() then
    return
  end
  self.nameLab.text = self.data:GetName()
  self.lvLab.text = string.format(ZhString.Pve_Lv, self.data:GetLv())
  self:_setProfession()
end

function TriplePvpChooseProCell:_setProfession()
  local pro
  if self:HasData() then
    pro = self.data:GetChoosenPro() or self.data:GetPro()
  end
  local config = pro and Table_Class[pro]
  self.professionSp.gameObject:SetActive(nil ~= config)
  self.professionLab.gameObject:SetActive(nil ~= config)
  if config then
    self.profession = pro
    IconManager:SetProfessionIcon(config.icon, self.professionSp)
    self.professionLab.text = config.NameZh
    UIUtil.FitLableMaxWidth_UseLeftPivot(self.professionLab, 107)
    local camp = self.data.camp
    local _, c = ColorUtil.TryParseHexString(_ProfessionEffectColor[camp])
    if _ then
      self.professionLab.effectColor = c
    end
  end
end

function TriplePvpChooseProCell:SetModel()
  if not self.profession then
    self.noneTexture.gameObject:SetActive(true)
    self.roleTexture.gameObject:SetActive(false)
    self.roleFrameTexture.gameObject:SetActive(false)
  else
    self.noneTexture.gameObject:SetActive(false)
    self.roleTexture.gameObject:SetActive(true)
    self.roleFrameTexture.gameObject:SetActive(true)
    self:UpdateRole()
  end
  local hasData = self:HasData()
  self.emptyLab.gameObject:SetActive(not hasData)
  self.nameLab.gameObject:SetActive(hasData)
  self.lvLab.gameObject:SetActive(hasData)
  local choosen = hasData and self.data:IsChoosen()
  self.choosenEffectContainer:SetActive(choosen)
  self.choosenSp.gameObject:SetActive(choosen)
  self.choosingLab.gameObject:SetActive(not choosen)
end

function TriplePvpChooseProCell:UpdateRole()
  if not self:HasData() then
    return
  end
  local userdata = self.data:GetUserData()
  if not userdata then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  local anonymous = userdata:Get(UDEnum.ANONYMOUS) or 0
  if anonymous ~= 0 then
    local classId = userdata:Get(UDEnum.PROFESSION)
    local gender = userdata:Get(UDEnum.SEX)
    FunctionAnonymous.Me():GetAnonymousModelParts(classId, gender, parts)
  else
    parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
    parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
    parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
    parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
    parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
    parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
    parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
    parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
    parts[partIndex.Mount] = 0
    parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
    parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
    parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  end
  UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, parts, UIModelCameraTrans.TriplePvp, nil, nil, nil, nil, function(obj)
    self.model = obj
    if self.data:IsChoosen() then
      self.model:PlayAction_SimpleLoop("playshow")
    end
  end)
  UIModelUtil.Instance:ChangeBGMeshRenderer(self.campTextureName, self.roleTexture)
  Asset_Role.DestroyPartArray(parts)
end

function TriplePvpChooseProCell:SetCampInfo()
  local camp = self.data.camp
  local suffix = _TextureName_Suffix[camp]
  self.campTextureName = _CampTexture_Prefix .. suffix
  self.roleFrameTextureName = _CampRoleFrameTexture_Prefix .. suffix
  self.noneTextureName = _NoneTexture_Prefix .. suffix
  self.proTextureName = _ProfessionTexture_Prefix .. suffix
  local choosenSpriteName = _ChoosenSp_Prefix .. suffix
  self.choosenSp.spriteName = choosenSpriteName
  _PicMgr:SetTriplePvpTexture(self.campTextureName, self.campTexture)
  _PicMgr:SetTriplePvpTexture(self.noneTextureName, self.noneTexture)
  _PicMgr:SetTriplePvpTexture(self.roleFrameTextureName, self.roleFrameTexture)
  _PicMgr:SetTriplePvpTexture(self.proTextureName, self.professionTexture)
  local _, c = ColorUtil.TryParseHexString(_CampLabColor[camp])
  if _ then
    self.nameLab.color = c
  end
end

function TriplePvpChooseProCell:OnCellDestroy()
  TimeTickManager.Me():ClearTick(self)
  self:UnloadTexture()
  self:DestroyChoosenEffect()
  self:ClearModel()
end

function TriplePvpChooseProCell:ClearModel()
  if self.model and self.model:Alive() then
    self.model:Destroy()
    self.model = nil
  end
end

function TriplePvpChooseProCell:UnloadTexture()
  _PicMgr:UnloadTriplePvpTexture(self.campTextureName, self.campTexture)
  _PicMgr:UnloadTriplePvpTexture(self.noneTextureName, self.noneTexture)
  _PicMgr:UnloadTriplePvpTexture(_Bottem_TextureName, self.bottomTexture)
  _PicMgr:UnloadTriplePvpTexture(self.roleFrameTextureName, self.roleFrameTexture)
  _PicMgr:UnloadTriplePvpTexture(self.proTextureName, self.professionTexture)
  UIModelUtil.Instance:ResetTexture(self.roleTexture)
end
