TransSexPreView = class("TransSexPreView", SubMediatorView)
local tempVector3 = LuaVector3.Zero()
local pinkTop = LuaColor.New(1, 0.4823529411764706, 0.6431372549019608, 1)
local pinkBottom = LuaColor.New(1, 0.7137254901960784, 0.807843137254902, 1)
local blueTop = LuaColor.New(0.3686274509803922, 0.5725490196078431, 0.9254901960784314, 1)
local blueBottom = LuaColor.New(0.6235294117647059, 0.7450980392156863, 0.9333333333333333, 1)

function TransSexPreView:Init()
  TransSexPreView.super.Init(self)
  self:InitView()
  self:SetModel()
end

function TransSexPreView:InitView()
  self.ctObj = self:FindGO("TransSexPreView")
  local obj = self:LoadPreferb("view/TransSexPreView", self.ctObj)
  self.gameObject = obj
  local panel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  obj.transform.localPosition = tempVector3
  local playerModel = self:FindGO("PlayerModel")
  self.renderQByUI = playerModel:GetComponent(RenderQByUI)
  local playerModelContainer = self:FindGO("PlayerModelContainer")
  self.PlayerModel = self:FindGO("PlayerModel"):GetComponent(UITexture)
  self:AddDragEvent(playerModelContainer, function(obj, delta)
    self:RotateRoleEvt(obj, delta)
  end)
  self.cancelBtn = self:FindGO("CancelBtn")
  self.confirmBtn = self:FindGO("ConfirmBtn")
  local GenderSymbol = self:FindGO("GenderSymbol")
  self.maleSymbol = self:FindGO("male", GenderSymbol.gameObject):GetComponent(GradientUISprite)
  self.femaleSymbol = self:FindGO("female", GenderSymbol.gameObject):GetComponent(GradientUISprite)
end

function TransSexPreView:RotateRoleEvt(go, delta)
  if self.model then
    self.model:RotateDelta(-delta.x)
  end
end

function TransSexPreView:SetModel()
  local userData = Game.Myself.data.userdata
  local sex = userData:Get(UDEnum.SEX)
  local profession = userData:Get(UDEnum.PROFESSION)
  local body = 0
  sex = 3 - sex
  local _GameConfigRace = GameConfig.Profession and GameConfig.Profession.race_info[MyselfProxy.Instance:GetMyRace()]
  if not _GameConfigRace then
    redlog("Cannot Find GameConfig.Profession.race_info")
  end
  local hair = 0
  local eye = 0
  if sex == 1 then
    hair = _GameConfigRace.male_hair
    eye = _GameConfigRace.male_eye
    body = Table_Class[profession].MaleBody
  elseif sex == 2 then
    hair = _GameConfigRace.female_hair
    eye = _GameConfigRace.female_eye
    body = Table_Class[profession].FemaleBody
  end
  local head = userData:Get(UDEnum.HEAD)
  local headData = Table_Equip[head]
  if nil ~= headData then
    local invalidHairIDs = headData.HairID
    if nil ~= invalidHairIDs and 0 < #invalidHairIDs and 0 < TableUtility.ArrayFindIndex(invalidHairIDs, hair) then
      head = 0
    end
    local sexEquip = headData.SexEquip or 0
    if sexEquip ~= 0 and sexEquip ~= sex then
      head = 0
    end
  end
  local parts = Asset_Role.CreatePartArray()
  local _partIndex = Asset_Role.PartIndex
  local _partIndexEX = Asset_Role.PartIndexEx
  parts[_partIndex.Body] = body
  parts[_partIndex.Hair] = hair
  parts[_partIndex.Eye] = eye
  parts[_partIndex.LeftWeapon] = 0
  parts[_partIndex.RightWeapon] = 0
  parts[_partIndex.Head] = head or 0
  parts[_partIndex.Wing] = userData:Get(UDEnum.BACK) or 0
  parts[_partIndex.Face] = userData:Get(UDEnum.FACE) or 0
  parts[_partIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
  parts[_partIndex.Mount] = 0
  parts[_partIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
  parts[_partIndexEX.Gender] = sex or 0
  parts[_partIndexEX.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR)
  parts[_partIndexEX.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.PlayerModel, parts)
  self.model:RegisterWeakObserver(self)
  if self.model then
    LuaVector3.Better_Set(tempVector3, 0, -0.15, 0)
    self.model:SetPosition(tempVector3)
    LuaVector3.Better_Set(tempVector3, -0.67, 13.62, 0)
    self.model:SetEulerAngleY(tempVector3)
  end
  Asset_Role.DestroyPartArray(parts)
  self:SetSymbols(sex)
end

function TransSexPreView:SetSymbols(newSex)
  if newSex == 1 then
    self.maleSymbol.gradientTop = blueTop
    self.maleSymbol.gradientBottom = blueBottom
    self.femaleSymbol.gradientTop = LuaColor.White()
    self.femaleSymbol.gradientBottom = LuaColor.White()
  else
    self.maleSymbol.gradientTop = LuaColor.White()
    self.maleSymbol.gradientBottom = LuaColor.White()
    self.femaleSymbol.gradientTop = pinkTop
    self.femaleSymbol.gradientBottom = pinkBottom
  end
end

function TransSexPreView:OnEnter(subId, dialogView)
  TransSexPreView.super.OnEnter(self)
  if not dialogView or not subId then
    return
  end
  local nowDialogData = dialogView.nowDialogData
  local optionStr = nowDialogData.Option
  local optionConfig = StringUtil.AnalyzeDialogOptionConfig(optionStr)
  for _, v in pairs(optionConfig) do
    if v.id == 7 then
      dialogView:RegisterMenuEvent(self.confirmBtn.gameObject, v.id, true)
    elseif v.id == 6 then
      dialogView:RegisterMenuEvent(self.cancelBtn.gameObject, v.id, true)
    end
  end
end

function TransSexPreView:ObserverDestroyed(obj)
  if obj == self.model then
    self.model = nil
  end
end
