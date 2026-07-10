local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _PartIndexEx = Asset_Role.PartIndexEx
local _outlineLayer = Game.ELayer.Outline
local _PrefabPath = ResourcePathHelper.UIView("FashionStarModel")
local _ScenePath = ResourcePathHelper.UIModel("FashionStarScene")
FashionStarModel = class("FashionStarModel", SubView)

function FashionStarModel:Init()
  local _proxy = FashionStarProxy.Instance
  local fashionId, headId = _proxy:GetDefaultFashionId(), _proxy:GetDefaultHeadId()
  self:ResetFashion(fashionId, headId)
  self.root = self:FindGO("ModelRoot")
  local obj = self:LoadPreferb_ByFullPath(_PrefabPath, self.root, true)
  obj.name = "FashionStarModel"
  _RotateViewPort = BagProxy.Instance.roleEquip:GetMount() and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort
  self:FindObjs()
  self:InitScene()
  self:LoadModel()
end

function FashionStarModel:OnExit()
  self:DeInitDress()
  FashionStarModel.super.OnExit(self)
end

function FashionStarModel:DeInitDress()
  self:_unloadModel()
  self:_deInitScene()
  self:_resetCamera()
end

function FashionStarModel:_destroySetCameraTick()
  if not self.cameraDelayTick then
    return
  end
  self.cameraDelayTick:Destroy()
  self.cameraDelayTick = nil
end

function FashionStarModel:_resetCamera()
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

function FashionStarModel:FindObjs()
  local HideSelfDressBtn = self:FindGO("HideSelfDressBtn", self.root)
  if HideSelfDressBtn then
    self:Hide(HideSelfDressBtn)
  end
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

function FashionStarModel:InitScene()
  if nil ~= self.previewScene then
    return
  end
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.previewScene = Game.AssetManager_UI:CreateAsset(_ScenePath)
  self.previewScene.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.rolePosGo = self:FindGO("RolePos", self.previewScene)
  self.cameraPos = self:FindGO("CameraPos", self.previewScene).transform
  self.modelBgTrans = self:FindGO("Reloading_BG", self.previewScene).transform
  UIManagerProxy.Instance:RefitSceneModel(self.cameraPos, self.modelBgTrans)
  self:_setCamera()
end

function FashionStarModel:OnPressSceneRoleEvt(go, isPress)
  if not self.assetRole then
    return
  end
  if not self.arrows then
    return
  end
  self.arrows:SetActive(nil ~= self.assetRole and isPress)
end

function FashionStarModel:OnRotateSceneRoleEvt(go, delta)
  if not self.assetRole then
    return
  end
  self.assetRole:RotateDelta(-delta.x * 360 / 400)
end

function FashionStarModel:ShowModel(visible)
  if self.visible == visible then
    return
  end
  self.visible = visible
  if visible then
    self:Show(self.rolePosGo)
    self:Show(self.root)
  else
    self:Hide(self.rolePosGo)
    self:Hide(self.root)
  end
end

function FashionStarModel:_deInitScene()
  if not self.previewScene then
    return
  end
  if not Slua.IsNull(self.previewScene) then
    GameObject.DestroyImmediate(self.previewScene)
  end
  self.previewScene = nil
  self.cameraPos = nil
  self.modelBgTrans = nil
  self.vecCameraPosRecord:Destroy()
  self.quaCameraRotRecord:Destroy()
end

function FashionStarModel:_setCamera()
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
    redlog("没有在主摄像机上找到CameraController！")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, _GetPosition(self.cameraWorldTransform))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, _GetRotation(self.cameraWorldTransform))
  self.cameraWorldTransform.position = LuaGeometry.GetTempVector3(_GetPosition(self.cameraPos))
  self.cameraWorldTransform.rotation = LuaGeometry.GetTempQuaternion(_GetRotation(self.cameraPos))
  self.worldCamera.fieldOfView = 20
  self.cameraOn = true
end

function FashionStarModel:ResetFashion(equip_id, equip_head_id)
  if self.fashionId == equip_id and nil ~= equip_head_id and self.headId == equip_head_id then
    return false
  end
  self.fashionId = equip_id
  self.bodyId = EquipInfo.GetDisplayBody(self.fashionId)
  self.headId = equip_head_id
  return true
end

function FashionStarModel:LoadModel()
  if nil == self.roleParts then
    self.roleParts = Asset_Role.CreatePartArray()
  end
  local sex = MyselfProxy.Instance:GetMySex()
  local userdata = Game.Myself.data.userdata
  self.roleParts[_PartIndex.Body] = self.bodyId or userdata:Get(UDEnum.BODY) or 0
  self.roleParts[_PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  self.roleParts[_PartIndex.LeftWeapon] = 0
  self.roleParts[_PartIndex.RightWeapon] = 0
  self.roleParts[_PartIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
  self.roleParts[_PartIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
  Asset_RoleUtility.ReviseEyeByBody(self.roleParts)
  self.roleParts[_PartIndex.Mount] = 0
  self.roleParts[_PartIndex.Head] = self.headId or userdata:Get(UDEnum.HEAD) or 0
  self.roleParts[_PartIndex.Face] = userdata:Get(UDEnum.FACE) or 0
  self.roleParts[_PartIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
  self.roleParts[_PartIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
  self.roleParts[_PartIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
  self.roleParts[_PartIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
  self.roleParts[_PartIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  self.roleParts[_PartIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  self.roleParts[_PartIndexEx.Gender] = sex
  if not self.assetRole then
    self.assetRole = Asset_Role_UI.Create(self.roleParts)
    self.assetRole:SetParent(self.rolePosGo.transform, false)
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
end

function FashionStarModel:ChangeBodyPart(equip_id, head_id)
  if not self.assetRole then
    return
  end
  if self:ResetFashion(equip_id, head_id) then
    local userdata = Game.Myself.data.userdata
    self.roleParts[_PartIndex.Body] = self.bodyId or userdata:Get(UDEnum.BODY) or 0
    self.roleParts[_PartIndex.Head] = self.headId or userdata:Get(UDEnum.HEAD) or 0
    self.assetRole:Redress(self.roleParts, true)
  end
end

function FashionStarModel:PlayAction(action_id)
  if not self.assetRole then
    return
  end
  local actionData = Table_ActionAnime[action_id]
  if actionData then
    self.assetRole:PlayAction_Simple(actionData.Name)
  end
end

function FashionStarModel:ObserverDestroyed(obj)
  if self.assetRole == obj then
    self.assetRole:UnregisterWeakObserver(self)
    self.assetRole = nil
  end
end

function FashionStarModel:_unloadModel()
  if Slua.IsNull(self.previewScene) then
    return
  end
  self:_destroyPart()
  self:_destroyRole()
end

function FashionStarModel:_destroyRole()
  if self.assetRole and self.assetRole:Alive() then
    self.assetRole:SetEpNodesDisplay(false)
    self.assetRole:Destroy()
  end
  self.assetRole = nil
end

function FashionStarModel:_destroyPart()
  if self.roleParts then
    Asset_Role.DestroyPartArray(self.roleParts)
    self.roleParts = nil
  end
end

function FashionStarModel:PlayShow()
  if not self.assetRole then
    return
  end
  self.assetRole:PlayAction_PlayShow()
end
