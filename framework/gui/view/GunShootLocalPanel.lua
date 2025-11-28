autoImport("GunShootLocalConditionCell")
autoImport("PhotographPanel")
autoImport("SgAIManager")
GunShootLocalPanel = class("GunShootLocalPanel", ContainerView)
GunShootLocalPanel.ViewType = UIViewType.FocusLayer
local shoot_effect = "Skill/Eff_Shooting_atk"
local tempVector3 = LuaVector3.Zero()
local PHOTOGRAPHER_StickArea = Rect(0, 0, 0, 0)
local qws_tex = "activity_bg_title"
local _pointColor = {
  Color(0.5647058823529412, 1.0, 0.4117647058823529, 1),
  Color(1.0, 0.4196078431372549, 0.4196078431372549, 1)
}
local lastPointLocalPos_X, lastPointLocalPos_Y
local lastPointObjTweenPosOffset = 40
local mid, sceneUI, point

function GunShootLocalPanel:calFOVValue(zoom)
  local value = 2 * math.atan(21.635 / zoom) * 180 / math.pi
  return value
end

function GunShootLocalPanel:calZoom(del)
  local value = 21.635 / math.tan(del / 2 / 180 * math.pi)
  return value
end

function GunShootLocalPanel:GetComposition(index)
  index = index or self.compositionIndex
  if nil == self.cameraData or nil == self.cameraData.Composition then
    return nil
  end
  return self.cameraData.Composition[index]
end

function GunShootLocalPanel:SetCompositionIndex(index)
  self.compositionIndex = index
end

function GunShootLocalPanel:setForceRotation()
  self:calFOVByPos()
  if nil ~= self.forceRotation then
    Game.InputManager.photograph.useForceRotation = true
    Game.InputManager.photograph.forceRotation = self.forceRotation
  else
    Game.InputManager.photograph.useForceRotation = false
  end
end

function GunShootLocalPanel:calFOVByPos()
  local position
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      local topFocusUI = creatureObj:GetSceneUI().roleTopUI.topFocusUI
      position = topFocusUI:getPosition()
    end
  elseif self.symbol then
    position = self.symbol:getTarPosition()
  end
  if position then
    LuaVector3.Better_Set(tempVector3, Game.Myself.assetRole:GetCPOrRootPosition(RoleDefines_CP.Hair))
    LuaVector3.Better_Sub(position, tempVector3, tempVector3)
    if not self.forceRotation then
      self.forceRotation = LuaVector3.zero
    end
    self.forceRotation = LuaVector3.Better_Clone(tempVector3)
  end
end

function GunShootLocalPanel:resetCameraData()
  Game.InputManager.model = InputManager.Model.DEFAULT
  if nil ~= self.cameraController then
    if self.originNearClipPlane then
      self.cameraController.activeCamera.nearClipPlane = self.originNearClipPlane
      self.cameraController.activeCamera.farClipPlane = self.originFarClipPlane
    end
    if self.originFocusViewPort then
      self.cameraController.photographInfo.focusViewPort = self.originFocusViewPort
    end
    if self.originFieldOfView then
      self.cameraController.photographInfo.fieldOfView = self.originFieldOfView
    end
  end
  if self.originStickArea then
    Game.InputManager.forceJoystickArea = self.originStickArea
  end
  if self.originFovMax then
    Game.InputManager.cameraFieldOfViewMin = self.originFovMin
    Game.InputManager.cameraFieldOfViewMax = self.originFovMax
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end

function GunShootLocalPanel:Init()
  self:InitView()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
end

function GunShootLocalPanel:InitView()
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if not self.cameraController then
    printRed("cameraController is nil")
    self:CloseSelf()
    return
  end
  self.vecScreenCenter = LuaVector3(Screen.width / 2, Screen.height / 2, 0)
  self.lastScreenCenterX = -1
  self.lastScreenCenterY = -1
  self.uiCm = NGUIUtil:GetCameraByLayername("UI")
  self.sceneUiCm = NGUIUtil:GetCameraByLayername("Default")
  self.quitBtn = self:FindChild("quitBtn")
  self.takePicBtn = self:FindChild("takePicBtn")
  self:AddButtonEvent("quitBtn", function(go)
    self:CloseSelf()
  end)
  self.refreshBtn = self:FindChild("refreshBtn")
  self:AddButtonEvent("refreshBtn", function(go)
    self:ResetArrow()
  end)
  self.arrowRoot = self:FindChild("arrowRoot")
  self:AddClickEvent(self.takePicBtn, function(go)
    if self.shotTime > 0 then
      self:gunshoot()
      AudioUtility.PlayOneShot2D_Path(AudioMap.UI.Picture)
    else
      MsgManager.ShowMsgByID(42074)
    end
  end)
  self.shotFrame = self:FindGO("shotFrame")
  self.traceinfo = self:FindGO("countdown"):GetComponent(UILabel)
  self.sizeWidget = self:FindComponent("Size", UIWidget)
  self.shootTimeContainer = self:FindGO("ShootTimeContainer")
  self.shootBg = self:FindGO("shootBg")
end

function GunShootLocalPanel:OnEnter()
  if not GameConfig.ShootParams then
    self:CloseSelf()
  end
  self.shootParams = GameConfig.ShootParams
  self.shotTime = self.shootParams.BulletNum
  self.curShotPoint = 0
  self.totalShotPoint = 0
  self.shotMonsterMap = {}
  self.shootBg:SetActive(true)
  self.shootTimeContainer:SetActive(true)
  self.traceinfo.text = self.shootParams.TraceInfo or ""
  self.condition = self:FindComponent("ConditionContainer", UIGrid)
  self.conditionList = UIGridListCtrl.new(self.condition, GunShootLocalConditionCell, "GunShootLocalConditionCell")
  self:UpdateConditionList()
  self:initCameraCfgData()
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  manager:ShowAll()
  FloatingPanel.Instance:SetMidMsgVisible(false)
  FunctionPet.Me():PetGiftActiveSelf(false)
  TimeTickManager.Me():CreateTick(0, 100, self.UpdateGunShootTargetSymbol, self, 1)
end

function GunShootLocalPanel:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:ClearGunShootTargetSymbol()
  FloatingPanel.Instance:SetMidMsgVisible(true)
  if self.shootParams.Filter then
    FunctionSceneFilter.Me():EndFilter(self.shootParams.Filter)
  end
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter)
  FunctionSceneFilter.Me():EndFilter(FunctionSceneFilter.AllEffectFilter)
  if self.defaultHide then
    for i = 1, #self.defaultHide do
      local fileterItem = self.defaultHide[i]
      FunctionSceneFilter.Me():EndFilter(fileterItem)
    end
  end
  if self.cameraAxisY then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY)
  end
  Game.AreaTriggerManager:SetIgnore(false)
  FunctionCameraEffect.Me():Resume()
  self:resetCameraData()
  if self.uiCemera then
    self.uiCemera.touchDragThreshold = self.originUiCmTouchDragThreshold
  end
  if self.originInputTouchSenseInch then
    Game.InputManager.touchSenseInch = self.originInputTouchSenseInch
    Game.InputManager:ResetParams()
  end
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:ResetLODEffect()
  _PerformanceManager:ResetLOD()
  _PerformanceManager:SkinWeightHigh(false)
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  manager:HideAll()
  ReusableTable.DestroyAndClearTable(self.vpRange)
  if self.isQWS_BirdType then
    PictureManager.Instance:UnLoadUI(qws_tex, self.qwsTex)
  end
  FunctionPet.Me():PetGiftActiveSelf(true)
  self.super.OnExit(self)
end

function GunShootLocalPanel:initCameraCfgData()
  FunctionCameraEffect.Me():Pause()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local id = viewdata.cameraId
    if id then
      printRed("PhotographPanel:from carrier cameraId:", id)
      self.cameraId = id
    end
  end
  Game.AreaTriggerManager:SetIgnore(true)
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:HighLODEffect()
  _PerformanceManager:LODHigh()
  _PerformanceManager:SkinWeightHigh(true)
  self.originFovMin = nil
  self.originFovMax = nil
  self.originAllowLowerThanFocus = nil
  if not self.cameraId then
    local currentMap = SceneProxy.Instance.currentScene
    if currentMap then
      self.cameraId = Table_Map[currentMap.mapID].Camera
    end
  end
  if not self.cameraId then
    self.cameraId = 1
  end
  self.cameraData = Table_Camera[self.cameraId]
  if not self.cameraData or not self.cameraController then
    return
  end
  local layer = LayerMask.NameToLayer("UI")
  if layer then
    self.uiCemera = UICamera.FindCameraForLayer(layer)
    if self.uiCemera then
      self.originUiCmTouchDragThreshold = self.uiCemera.touchDragThreshold
      self.uiCemera.touchDragThreshold = 1
    end
  end
  self.originInputTouchSenseInch = Game.InputManager.touchSenseInch
  Game.InputManager.touchSenseInch = 0
  Game.InputManager:ResetParams()
  Game.InputManager.model = InputManager.Model.PHOTOGRAPH
  self.originNearClipPlane = self.cameraController.activeCamera.nearClipPlane
  self.originFarClipPlane = self.cameraController.activeCamera.farClipPlane
  self.cameraController.activeCamera.nearClipPlane = self.cameraData.ClippingPlanes[1]
  self.cameraController.activeCamera.farClipPlane = self.cameraData.ClippingPlanes[2]
  self.originFovMin = Game.InputManager.cameraFieldOfViewMin
  self.originFovMax = Game.InputManager.cameraFieldOfViewMax
  self.fovMin = self.cameraData.Zoom[1]
  self.fovMax = self.cameraData.Zoom[2]
  self.fovMinValue = self:calFOVValue(self.fovMax)
  self.fovMaxValue = self:calFOVValue(self.fovMin)
  Game.InputManager.cameraFieldOfViewMin = self.fovMinValue
  Game.InputManager.cameraFieldOfViewMax = self.fovMaxValue
  self:SetCompositionIndex(1)
  local pgInfo = self.cameraController.photographInfo
  if pgInfo then
    self.originFocusViewPort = pgInfo.focusViewPort
    local composition = self:GetComposition()
    if nil ~= composition then
      LuaVector3.Better_Set(tempVector3, composition[1], composition[2], self.cameraData.Radius)
    else
      LuaVector3.Better_Set(tempVector3, self.originFocusViewPort[1], self.originFocusViewPort[2], self.cameraData.Radius)
    end
    pgInfo.focusViewPort = tempVector3
    local defaultZoom = self.cameraData.DefaultZoom
    if defaultZoom then
      self.originFieldOfView = pgInfo.fieldOfView
      local fieldOfView = self:calFOVValue(defaultZoom)
      pgInfo.fieldOfView = fieldOfView
    end
  end
  local defaultDir = self.cameraData.DefaultDir
  if self.shootParams.FaceDir then
    self.forceRotation = LuaVector3(self.shootParams.FaceDir[1], self.shootParams.FaceDir[2], self.shootParams.FaceDir[3])
  end
  local defaultRoleDir = self.cameraData.DefaultRoleDir
  if defaultRoleDir and #defaultRoleDir ~= 0 then
    local x, y, z = Game.Myself.assetRole:GetEulerAnglesXYZ()
    local cx = defaultRoleDir[1] or 0
    local cy = defaultRoleDir[2] or 0
    local cz = defaultRoleDir[3] or 0
    x = x + cx
    y = y + cy
    z = z + cz
    self.forceRotation = LuaVector3(0, y, z)
  end
  if self.shootParams.Filter then
    FunctionSceneFilter.Me():StartFilter(self.shootParams.Filter)
  end
  self.originStickArea = Game.InputManager.forceJoystickArea
  self:changeToPHOTOGRAPHER()
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end

function GunShootLocalPanel:ResetArrow()
  self.shotTime = self.shootParams.BulletNum
  self.curShotPoint = 0
  self.totalShotPoint = 0
  self:UpdateArrow()
  self:UpdateConditionList()
  self:SetTextureWhite(self.takePicBtn)
end

function GunShootLocalPanel:UpdateArrow()
  if self.arrowRoot then
    for i = 1, self.arrowRoot.transform.childCount do
      if i < self.shotTime + 1 then
        self.arrowRoot.transform:GetChild(i - 1).gameObject:SetActive(true)
      else
        self.arrowRoot.transform:GetChild(i - 1).gameObject:SetActive(false)
      end
    end
  end
end

function GunShootLocalPanel:changeToPHOTOGRAPHER()
  self:setForceRotation()
  if self.selfieStickArea then
    Game.InputManager.forceJoystickArea = self.selfieStickArea
  else
    Game.InputManager.forceJoystickArea = PHOTOGRAPHER_StickArea
  end
  self.curPhotoMode = FunctionCameraEffect.PhotographMode.PHOTOGRAPHER
  self.needCheckReady = true
end

function GunShootLocalPanel:UpdateGunShootTargetSymbol()
  if self.lastScreenCenterX ~= Input.mousePosition[1] or self.lastScreenCenterY ~= Input.mousePosition[2] then
    local newTarget, point = self:checkShootTarget()
    self.curShotPoint = point
    if self.shootTarget ~= newTarget then
      self:ClearGunShootTargetSymbol()
      self.shootTarget = newTarget
      self:SetGunShootTargetSymbol()
    end
  end
end

function GunShootLocalPanel:SetGunShootTargetSymbol()
  if self.shootTarget then
    NSceneEffectProxy.Instance:Client_AddSceneEffect("GunShootLocal_Effect", self.shootTarget.transform.position, self.shootParams.AimEffect)
  end
end

function GunShootLocalPanel:ClearGunShootTargetSymbol()
  if self.shootTarget then
    NSceneEffectProxy.Instance:Client_RemoveSceneEffect("GunShootLocal_Effect")
  end
  self.shootTarget = nil
end

function GunShootLocalPanel:gunshoot()
  self.shotTime = self.shotTime - 1
  self.totalShotPoint = self.totalShotPoint + self.curShotPoint
  if self.shotTime == 0 then
    self:SetTextureGrey(self.takePicBtn)
  end
  if not self.resultEffect then
    self.resultEffect = self:PlayEffectByFullPath(self.shootParams.ShootEffect or shoot_effect, self.gameObject, false, function(go)
      go.transform.localPosition = LuaGeometry.Const_V3_zero
    end)
  else
    self.resultEffect:SetActive(false)
    self.resultEffect:SetActive(true)
  end
  CameraAdditiveEffectManager.Me():StartShake(0.1, 0.2)
  SgAIManager.Me():shootingCompleted(self.totalShotPoint)
  self:UpdateConditionList()
  self:UpdateArrow()
end

function GunShootLocalPanel:checkShootTarget()
  local rayLength = 20
  local ray = self.sceneUiCm:ScreenPointToRay(self.vecScreenCenter)
  self.lastScreenCenterX = Input.mousePosition[1]
  self.lastScreenCenterY = Input.mousePosition[2]
  local isHit, hitInfo = Physics.Raycast(ray, LuaOut, rayLength, 1 << Game.ELayer.Default)
  if isHit and hitInfo.collider.gameObject.name == self.shootParams.TargetObj then
    local tempV21 = LuaVector2.Zero()
    tempV21[1] = hitInfo.collider.gameObject.transform.position[1]
    tempV21[2] = hitInfo.collider.gameObject.transform.position[2]
    local tempV22 = LuaVector2.Zero()
    tempV22[1] = hitInfo.point[1]
    tempV22[2] = hitInfo.point[2]
    local len = math.clamp(LuaVector2.Magnitude(tempV21 - tempV22), 0, self.shootParams.TargetRadius)
    local score = math.clamp(self.shootParams.MaxScore - math.floor(len / self.shootParams.TargetRadius * self.shootParams.TargetCircleNum) * self.shootParams.DecreasePerCircle, 0, self.shootParams.MaxScore)
    return hitInfo.collider.gameObject, score
  end
  return nil, 0
end

function GunShootLocalPanel:UpdateConditionList()
  local tmpList = ReusableTable.CreateArray()
  TableUtility.ArrayPushBack(tmpList, {
    point = self.totalShotPoint
  })
  self.conditionList:ResetDatas(tmpList)
  ReusableTable.DestroyAndClearArray(tmpList)
end

function GunShootLocalPanel:CloseSelf()
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    GunShootLocalPanel.super.CloseSelf(self)
  end, self)
end
