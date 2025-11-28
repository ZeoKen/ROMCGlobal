local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _PartIndexEx = Asset_Role.PartIndexEx
local _outlineLayer = Game.ELayer.Outline
local _PrefabPath = ResourcePathHelper.UIView("LotteryModel")
local _ScenePath = ResourcePathHelper.UIModel("LotteryPreviewScene")
local _LotteryProxy, _FunctionLottery, _MyGender, _MyRace, _MyClass, _OriginalHairColor, _RotateViewPort
local _getClassBody = function()
  local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  if gender == ProtoCommon_pb.EGENDER_MALE then
    return Table_Class[class].MaleBody
  else
    return Table_Class[class].FemaleBody
  end
end
local _getClassEye = function()
  local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  if gender == ProtoCommon_pb.EGENDER_MALE then
    return Table_Class[class].MaleEye
  else
    return Table_Class[class].FemaleEye
  end
end
local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
end
local _GenderField = {
  [1] = "male",
  [2] = "female"
}
local _RaceField = {
  [1] = "Human",
  [2] = "Cat"
}
LotteryModel = class("LotteryModel", SubView)

function LotteryModel:Init(type)
  self.root = self:FindGO("DressRoot")
  local obj = self:LoadPreferb_ByFullPath(_PrefabPath, self.root, true)
  obj.name = "LotteryModel"
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyClass = MyselfProxy.Instance:GetMyProfession()
  _MyRace = ProfessionProxy.GetRaceByProfession(_MyClass)
  _LotteryProxy = LotteryProxy.Instance
  _FunctionLottery = FunctionLottery.Me()
  _OriginalHairColor = Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
  _RotateViewPort = BagProxy.Instance.roleEquip:GetMount() and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort
  self.RetrySetCameraCount = 0
  self:FindObjs()
  self:ResetType(type)
end

function LotteryModel:ShowModel()
  if not self.needShowModel then
    return
  end
  self:LoadModel()
end

function LotteryModel:ResetType(t)
  if t == self.type then
    return
  end
  self.type = t
  self.needShowModel = not LotteryProxy.IsCardLottery(t)
  if self.needShowModel then
    self:InitScene()
    self:Show(self.root)
  else
    self:Hide(self.root)
  end
end

function LotteryModel:SetRootActive(show)
  if show and self.needShowModel then
    self:Show(self.root)
  else
    self:Hide(self.root)
  end
end

function LotteryModel:NeedShowModel()
  return self.needShowModel == true
end

function LotteryModel:OnExit()
  self:DeInitDress()
  LotteryModel.super.OnExit(self)
end

function LotteryModel:DeInitDress()
  self:_unloadModel()
  self:_deInitScene()
  self:_resetCamera()
  self:_clearDelayHideTick()
  _FunctionLottery:ClearDressMap()
end

function LotteryModel:CheckHideSelf()
  return self.hideSelfDress == true
end

function LotteryModel:UpdateHideSelfBtnState()
  self.hideSelfDressBtn.spriteName = self.hideSelfDress and "mall_twistedegg_bg_04" or "mall_twistedegg_bg_10"
  self.hideSelfDressSprite.gameObject:SetActive(not self.hideSelfDress)
  self.hideSelfDressGradientSp.gameObject:SetActive(self.hideSelfDress)
end

function LotteryModel:FindObjs()
  self.hideSelfDressBtn = self:FindComponent("HideSelfDressBtn", UISprite)
  self.hideSelfDressGradientSp = self:FindGO("GradientSp", self.hideSelfDressBtn.gameObject)
  self.hideSelfDressSprite = self:FindGO("Sprite", self.hideSelfDressBtn.gameObject)
  self.hideSelfDressLab = self:FindComponent("Label", UILabel, self.hideSelfDressBtn.gameObject)
  self.hideSelfDress = false
  self:UpdateHideSelfBtnState()
  self:AddClickEvent(self.hideSelfDressBtn.gameObject, function()
    if not self.needShowModel then
      return
    end
    self.hideSelfDress = not self.hideSelfDress
    self:_playHideSelfEquipAnimation()
    self:LoadModel()
    self:UpdateHideSelfBtnState()
  end)
  self.roleCollider = self:FindGO("RotateRoleCollider", self.root)
  self.arrows = self:FindGO("RotateRoleArrows", self.root)
  self:Hide(self.arrows)
  self:AddDragEvent(self.roleCollider, function(go, delta)
    self:OnRotateSceneRoleEvt(go, delta)
  end)
  self:AddPressEvent(self.roleCollider, function(go, isPress)
    self:OnPressSceneRoleEvt(go, isPress)
  end)
end

function LotteryModel:_clearDelayHideTick()
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
  if self.delayHideTick then
    TimeTickManager.Me():ClearTick(self, 2)
    self.delayHideTick = nil
  end
end

function LotteryModel:_playHideSelfEquipAnimation()
  self:_clearDelayHideTick()
  self.hideSelfDressLab.alpha = 1
  self.hideSelfDressLab.text = self:CheckHideSelf() and ZhString.Lottery_HideSelfEquip or ZhString.Lottery_ShowSelfEquip
  self.delayHideTick = TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self.lt = LeanTween.alphaNGUI(self.hideSelfDressLab, 1, 0, 1.5)
  end, self, 2)
end

function LotteryModel:InitScene()
  if nil ~= self.previewScene then
    return
  end
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.previewScene = Game.AssetManager_UI:CreateAsset(_ScenePath)
  self.previewScene.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.rolePos = self:FindGO("RolePos", self.previewScene).transform
  self.cameraPos = self:FindGO("CameraPos", self.previewScene).transform
  self.modelBgTrans = self:FindGO("Reloading_BG", self.previewScene).transform
  UIManagerProxy.Instance:RefitSceneModel(self.cameraPos, self.modelBgTrans)
  self:_setCamera()
end

function LotteryModel:OnPressSceneRoleEvt(go, isPress)
  if not self.assetRole then
    return
  end
  if not self.arrows then
    return
  end
  self.arrows:SetActive(nil ~= self.assetRole and isPress)
end

function LotteryModel:OnRotateSceneRoleEvt(go, delta)
  if not self.assetRole then
    return
  end
  self.assetRole:RotateDelta(-delta.x * 360 / 400)
end

function LotteryModel:_deInitScene()
  if not self.previewScene then
    return
  end
  if not Slua.IsNull(self.previewScene) then
    GameObject.DestroyImmediate(self.previewScene)
  end
  self.previewScene = nil
  self.rolePos = nil
  self.cameraPos = nil
  self.modelBgTrans = nil
  self.vecCameraPosRecord:Destroy()
  self.quaCameraRotRecord:Destroy()
end

function LotteryModel:_setCamera()
  if self.cameraOn then
    return
  end
  if self.cameraDelayTick then
    return
  end
  self.worldCameraLayer = self.worldCameraLayer or Game.ELayer.Default
  if not self.worldCamera or _ObjectIsNull(self.worldCamera) then
    self.worldCamera = NGUITools.FindCameraForLayer(self.worldCameraLayer)
    if not self.worldCamera then
      self.RetrySetCameraCount = self.RetrySetCameraCount + 1
      if self.RetrySetCameraCount > 9 then
        return
      end
      self.cameraDelayTick = TimeTickManager.Me():CreateOnceDelayTick(self.RetrySetCameraCount * 100, function(owner, deltaTime)
        self.cameraDelayTick = nil
        self:_setCamera()
      end, self, 3)
      return
    end
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.worldCamera.gameObject:GetComponent(CameraController)
  self.cameraWorldTransform = self.worldCamera.transform
  self.fovRecord = self.worldCamera.fieldOfView
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = true
    self.cameraController.enabled = false
  else
    LogUtility.Error("没有在主摄像机上找到CameraController！")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, _GetPosition(self.cameraWorldTransform))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, _GetRotation(self.cameraWorldTransform))
  self.cameraWorldTransform.position = LuaGeometry.GetTempVector3(_GetPosition(self.cameraPos))
  self.cameraWorldTransform.rotation = LuaGeometry.GetTempQuaternion(_GetRotation(self.cameraPos))
  self.worldCamera.fieldOfView = 20
  self.cameraOn = true
end

function LotteryModel:_destroySetCameraTick()
  if not self.cameraDelayTick then
    return
  end
  self.cameraDelayTick:Destroy()
  self.cameraDelayTick = nil
end

function LotteryModel:_resetCamera()
  if not self.cameraOn then
    return
  end
  self:_destroySetCameraTick()
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.worldCamera and not _ObjectIsNull(self.worldCamera) then
    self.cameraWorldTransform.position = self.vecCameraPosRecord
    self.cameraWorldTransform.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.worldCamera.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      self:CameraRotateToMe(false, _RotateViewPort, nil, nil, 0)
    end
  end
  self.fovRecord = nil
  self.RetrySetCameraCount = 0
  self.cameraOn = false
  self:CameraReset()
end

local _DefaultDoramTail = 400214

function LotteryModel:GetRolePart(part)
  if Game.Myself.data:IsTransformState() then
    local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
    if part == UDEnum.BODY then
      return _getClassBody()
    elseif part == UDEnum.HAIR then
      if ProfessionProxy.IsHumanRace(Game.Myself.data.userdata:Get(UDEnum.PROFESSION)) then
        return gender == ProtoCommon_pb.EGENDER_MALE and 1 or 11
      else
        return gender == ProtoCommon_pb.EGENDER_MALE and 93 or 83
      end
    elseif part == UDEnum.EYE then
      return _getClassEye()
    end
    return 0
  end
  local userdata = Game.Myself.data.userdata
  if self:CheckHideSelf() then
    if part == UDEnum.TAIL and userdata:Get(UDEnum.TAIL) == _DefaultDoramTail then
      return _DefaultDoramTail
    elseif part == UDEnum.BODY then
      return _getClassBody()
    elseif part == UDEnum.EYE then
      return userdata:Get(part)
    elseif part == UDEnum.HAIR then
      return userdata:Get(part)
    else
      return 0
    end
  end
  return userdata:Get(part) or 0
end

function LotteryModel:UpdateModel(partIndex, id)
  _FunctionLottery:UpdateDressMap(partIndex, id)
  self:LoadModel()
end

local _ride_Animation = "ride_wait"
local _ride_Size = 0.6
local _role_Size = 0.8

function LotteryModel:LoadModel()
  if nil == self.roleParts then
    self.roleParts = Asset_Role.CreatePartArray()
  end
  local userdata = Game.Myself.data.userdata
  local originalBody = self.roleParts[_PartIndex.Body]
  self.roleParts[_PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  self.roleParts[_PartIndex.LeftWeapon] = 0
  self.roleParts[_PartIndex.RightWeapon] = 0
  self.roleParts[_PartIndex.Hair] = self:GetRolePart(UDEnum.HAIR)
  self.roleParts[_PartIndex.Body] = _FunctionLottery:GetDressID(_PartIndex.Body) or self:GetRolePart(UDEnum.BODY)
  self.roleParts[_PartIndex.Eye] = self:GetRolePart(UDEnum.EYE)
  Asset_RoleUtility.ReviseEyeByBody(self.roleParts)
  self.roleParts[_PartIndex.Mount] = _FunctionLottery:GetDressID(_PartIndex.Mount) or 0
  self.roleParts[_PartIndex.Head] = _FunctionLottery:GetDressID(_PartIndex.Head) or self:GetRolePart(UDEnum.HEAD)
  self.roleParts[_PartIndex.Face] = _FunctionLottery:GetDressID(_PartIndex.Face) or self:GetRolePart(UDEnum.FACE)
  self.roleParts[_PartIndex.Tail] = _FunctionLottery:GetDressID(_PartIndex.Tail) or self:GetRolePart(UDEnum.TAIL)
  self.roleParts[_PartIndex.Wing] = _FunctionLottery:GetDressID(_PartIndex.Wing) or self:GetRolePart(UDEnum.BACK)
  self.roleParts[_PartIndex.Mouth] = _FunctionLottery:GetDressID(_PartIndex.Mouth) or self:GetRolePart(UDEnum.MOUTH)
  self.roleParts[_PartIndexEx.HairColorIndex] = _FunctionLottery:GetDressID(_PartIndexEx.HairColorIndex) or _OriginalHairColor
  self.roleParts[_PartIndexEx.EyeColorIndex] = _FunctionLottery:GetDressID(_PartIndexEx.EyeColorIndex) or self:GetRolePart(UDEnum.EYECOLOR)
  self.roleParts[_PartIndexEx.BodyColorIndex] = _FunctionLottery:GetDressID(_PartIndexEx.BodyColorIndex) or self:GetRolePart(UDEnum.CLOTHCOLOR)
  self.roleParts[_PartIndexEx.Gender] = _MyGender
  local hasMount = self.roleParts[_PartIndex.Mount] ~= 0
  if not self.assetRole then
    self.assetRole = Asset_Role_UI.Create(self.roleParts)
    self.assetRole:SetParent(self.rolePos, false)
    self.assetRole:SetLayer(_outlineLayer)
    self.assetRole:SetPosition(_Const_V3_zero)
    self.assetRole:SetEulerAngleY(180)
    self.assetRole:SetScale(1)
    self.assetRole:SetShadowEnable(false)
    self.assetRole:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.assetRole:RegisterWeakObserver(self)
    self.assetRole:SetEpNodesDisplay(true)
    self.assetRole:SetForceShowMount(true)
  else
    self.assetRole:Redress(self.roleParts, true)
  end
  if hasMount then
    self.assetRole:PlayAction_Simple(_ride_Animation)
  elseif self.assetRole:IsPlayingAction(_ride_Animation) then
    self.assetRole:PlayAction_PlayShow()
  else
    local nowBody = self.roleParts[_PartIndexEx.Body]
    if originalBody ~= nowBody and nowBody ~= _getClassBody() then
      self.assetRole:PlayAction_PlayShow()
    end
  end
  local size = hasMount and _ride_Size or _role_Size
  if self.roleSize == size then
    return
  end
  self.roleSize = size
  LuaGameObject.SetLocalScaleGO(self.rolePos.gameObject, size, size, size)
end

function LotteryModel:SetRoleInvisible(var)
  if self.assetRole and self.assetRole:Alive() then
    self.assetRole:SetInvisible(var)
  end
end

function LotteryModel:ObserverDestroyed(obj)
  if self.assetRole == obj then
    self.assetRole:UnregisterWeakObserver(self)
    self.assetRole = nil
  end
end

function LotteryModel:_unloadModel()
  if Slua.IsNull(self.previewScene) then
    return
  end
  self:_destroyPart()
  self:_destroyRole()
end

function LotteryModel:_destroyRole()
  if self.assetRole and self.assetRole:Alive() then
    self.assetRole:SetEpNodesDisplay(false)
    self.assetRole:Destroy()
  end
  self.assetRole = nil
end

function LotteryModel:_destroyPart()
  if self.roleParts then
    Asset_Role.DestroyPartArray(self.roleParts)
    self.roleParts = nil
  end
end
