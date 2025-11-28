SniperView = class("SniperView", BaseView)
SniperView.ViewType = UIViewType.SniperLayer
local _Game = Game

function SniperView:Init()
  self:InitViewData()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function SniperView:FindObjs()
  local l_objWorldRoot = self:FindGO("WorldRoot")
  self.tsfWorldRoot = l_objWorldRoot.transform
  self.tsfWorldRoot.parent = nil
  self.tsfWorldRoot.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.tsfWorldRoot.parent = self.trans
  self.objUIEffectRoot = self:FindGO("UIEffectRoot")
  local l_objDistanceSignRoot = self:FindGO("UIEffectDistanceSign")
  self.rqManager_DistanceSign = l_objDistanceSignRoot:GetComponent(ChangeRqByTex)
  self.objDistanceSignColorRoot = self:FindGO("DistanceSignColorRoot", l_objDistanceSignRoot)
  self.tweenAlpha_distanceSign = self.objDistanceSignColorRoot:GetComponent(TweenAlpha)
  self.effectDistanceEyeColor = self.objDistanceSignColorRoot:GetComponent(ParticleSystemColor)
  self.rotateJoystick = self:FindComponent("RotateJoystick", Joystick_NGUI)
end

function SniperView:AddEvts()
  local l_objInputAccepter = self:FindGO("InputAccepter")
  self:AddPressEvent(l_objInputAccepter, function(go, isPress)
    self:OnPress(go, isPress)
  end)
  self:AddDragEvent(l_objInputAccepter, function(go, delta)
    self:OnDrag(go, delta)
  end)
  self:AddClickEvent(l_objInputAccepter, function(go)
    self:OnClickScreen(go)
  end)
  
  function self.rotateJoystick.OnValueChanged(deltaX, deltaY)
    self:OnRotateJoystickValueChanged(deltaX, deltaY)
  end
end

function SniperView:AddViewEvts()
end

function SniperView:InitViewData()
  self.curDistance = 0
  self.rotateJoystickValue = 0
  self.lastMaxAttackRange = 0
  self.vecCurCameraPos = LuaVector3(0, 0, 0)
  self.vec2CameraRotateDelta = LuaVector2(0, 0)
  self.vecTempCameraVector = LuaVector3(0, 0, 0)
  self.vecCameraLookPoint = LuaVector3(0, 0, 0)
  self.vecLastMyselfPos = VectorUtility.Asign_3(self.vecLastMyselfPos, _Game.Myself:GetPosition())
end

function SniperView:InitView()
  if self.ltInitCamera then
    return
  end
  local l_cameraController = CameraController.singletonInstance
  if not l_cameraController then
    if not self.errorOccured then
      self.gameObject:SetActive(false)
      if self.filtersWhenViewOpen ~= nil then
        FunctionSceneFilter.Me():EndFilter(self.filtersWhenViewOpen)
      end
      self.errorOccured = true
    end
    self.initRetryCount = self.initRetryCount + 1
    if self.initRetryCount > 9 then
      LogUtility.Error("无法找到CameraController，重试10次失败，狙击模式退出！")
      self:CloseSelf()
      return
    end
    self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
      self.ltInitCamera = nil
      self:InitView()
    end, self)
    return
  end
  if self.errorOccured then
    self.gameObject:SetActive(true)
    if self.filtersWhenViewOpen ~= nil then
      FunctionSceneFilter.Me():StartFilter(self.filtersWhenViewOpen)
    end
    self.errorOccured = false
  end
  local config = GameConfig.Sniper
  self.dragCameraSpeed = config.DragCameraSpeed or 22
  self.dragCameraWaitNum = config.DragCameraWaitNum or 1
  self.springTight = config.SpringTight or 0.5
  self.maxDistance = config.MaxDistance or 10
  self.springDistance = config.SpringDistance or 1.5
  self.extendMaxDistance = self.maxDistance + self.springDistance
  self.dragScreenMoveEdge = config.DragScreenMoveEdge or 100
  self.dragScreenMoveSpeed = (config.DragScreenMoveSpeed or 11) / 1000
  self.rotateCameraHoriSpeed = config.RotateCameraHoriSpeed or 1
  self.rotateCameraAutoHoriSpeed = config.RotateCameraAutoHoriSpeed or 100
  self.rotateCameraMouseSpeed = config.RotateCameraMouseSpeed or 0.2
  local l_cameraWorld = l_cameraController.activeCamera
  local l_objCameraMoveRoot = self:FindGO("CameraMoveRoot", self.tsfWorldRoot.gameObject)
  local l_objCameraRotateRoot = self:FindGO("CameraRotateRoot", l_objCameraMoveRoot)
  self.tabCameraWorld = {
    contoller = l_cameraController,
    camera = l_cameraWorld,
    gameObject = l_cameraController.gameObject,
    transform = l_cameraController.transform,
    tsfMoveRoot = l_objCameraMoveRoot.transform,
    tsfRotateRoot = l_objCameraRotateRoot.transform,
    cameraCopy = l_objCameraRotateRoot:GetComponent(Camera)
  }
  self.csClickProcesser = _Game.InputManager.clickProcesser
  self.isRunOnWindows = ApplicationInfo.IsRunOnWindowns()
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  self.dragWaitCounter = 0
  self.tabCameraWorld.contoller.applyCurrentInfoPause = true
  self.tabCameraWorld.contoller.enabled = false
  self.tabCameraWorld.cameraCopy:CopyFrom(self.tabCameraWorld.camera)
  self.isForbidOperate = true
  self:ResetCameraToStartPos(function()
    self.isViewInited = true
    self.isForbidOperate = false
  end)
  if not self.effEye then
    self.effEye = self:PlayUIEffect(EffectMap.UI.SniperView_eye, self.objDistanceSignColorRoot, false, function()
      if not self.rqManager_DistanceSign then
        return
      end
      self.rqManager_DistanceSign.excute = false
      self:ResetCurDistance(self.curDistance, true)
    end)
  end
  _Game.MapCellManager:ResetCenterTransform(self.tabCameraWorld.tsfMoveRoot)
  self.originIgnoreCameraDir = _Game.LogicManager_MapCell:IsIgnoreCameraDir()
  _Game.LogicManager_MapCell:SetIgnoreCameraDir(true)
  _Game.AreaTriggerManager:SetIgnore(true)
  self:AddMonoUpdateFunction(self.MonoUpdate)
  local sniperBuff = FunctionBuff.Me():GetBuffByID(8002)
  if sniperBuff and sniperBuff.endtime and sniperBuff.endtime ~= 0 then
    self.buffEndTime = sniperBuff.endtime
    local delayTime = math.max(self.buffEndTime - 5001 - ServerTime.CurServerTime(), 0)
    TimeTickManager.Me():CreateTick(delayTime, 1000, self.DistanceSignBlingBling, self, 2)
  end
  self.lastMaxAttackRange = FunctionSniperMode.Me():GetCurMaxAttackRange()
  self.effectSniperRing = Asset_Effect.PlayAt(EffectMap.Maps.SniperMode_Ring, _Game.Myself:GetPosition(), function(effectHandle)
    self:OnEffectSniperRingCreate(effectHandle)
  end, self, 0, nil, nil, nil, true)
end

function SniperView:OnPress(go, isPress)
  self.dragWaitCounter = 0
  self.isMousePressing = isPress
  if not isPress then
    self:LimitCameraPos()
  end
end

function SniperView:LimitCameraPos()
  if self.curDistance > self.maxDistance then
    local pos = VectorUtility.Asign_3(LuaGeometry.GetTempVector3(), self.vecCurCameraPos)
    local myselfPos = _Game.Myself:GetPosition()
    pos:Sub(myselfPos)
    pos:Normalize()
    pos:Mul(self.maxDistance)
    pos:Add(myselfPos)
    self:CameraMoveTo(pos, self.maxDistance, math.min(self.springTight / 10, self.springDistance / 15))
  end
end

function SniperView:OnDrag(go, delta)
  if FunctionSniperMode.Me():GetExtraInputPosition() then
    return
  end
  if self.isRotateMove then
    self:CameraRotate()
  else
    self.dragWaitCounter = self.dragWaitCounter + 1
    if self.dragWaitCounter > self.dragCameraWaitNum then
      delta.x = delta.x / self.screenWidth
      delta.y = delta.y / self.screenHeight
      self:CameraMove(delta)
    end
  end
end

function SniperView:OnClickScreen(go)
  local mouseX, mouseY = LuaGameObject.GetMousePosition()
  self.csClickProcesser:DoClickRoleOnScreen(LuaGeometry.GetTempVector2(mouseX, mouseY))
end

function SniperView:CameraRotate(delta)
  delta = delta or self.vec2CameraRotateDelta
  if delta[1] == 0 or self.isCameraMoving then
    return
  end
  VectorUtility.Asign_3(self.vecCameraLookPoint, self.vecCurCameraPos)
  self.tabCameraWorld.tsfRotateRoot:RotateAround(self.vecCameraLookPoint, LuaGeometry.GetTempVector3(0, 1, 0), delta[1])
  self.tabCameraWorld.tsfRotateRoot.parent = self.tsfWorldRoot
  self.tabCameraWorld.tsfRotateRoot:LookAt(self.vecCameraLookPoint)
  local eulerAngles = LuaGeometry.TempGetEulerAngles(self.tabCameraWorld.tsfRotateRoot)
  self.tabCameraWorld.tsfMoveRoot.eulerAngles = LuaGeometry.GetTempVector3(0, eulerAngles.y, 0)
  self.tabCameraWorld.tsfRotateRoot.parent = self.tabCameraWorld.tsfMoveRoot
  self.isCameraRotating = true
  self.isForbidOperate = true
  local targetPos = LuaGeometry.TempGetPosition(self.tabCameraWorld.tsfRotateRoot)
  TweenPosition.Begin(self.tabCameraWorld.gameObject, 0.05, targetPos, true):SetOnFinished(function()
    self.tabCameraWorld.transform:LookAt(self.vecCameraLookPoint)
    self.isCameraRotating = false
    self.isForbidOperate = false
  end)
end

function SniperView:CameraMove(delta, limitedDistance)
  if self.isCameraRotating then
    return
  end
  local pos = VectorUtility.Asign_3(LuaGeometry.GetTempVector3(), self.vecCurCameraPos)
  local vecTempCameraVector = self.vecTempCameraVector
  LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetTransformRight(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Mul(vecTempCameraVector, -delta.x * self.dragCameraSpeed)
  LuaVector3.Add(pos, vecTempCameraVector)
  LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetTransformForward(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Mul(vecTempCameraVector, -delta.y * self.dragCameraSpeed)
  LuaVector3.Add(pos, vecTempCameraVector)
  local myselfPos = _Game.Myself:GetPosition()
  local newDistance = VectorUtility.DistanceXZ(myselfPos, pos)
  if newDistance > self.curDistance and newDistance > self.maxDistance then
    local deltaDistance = newDistance - self.curDistance
    if limitedDistance then
      newDistance = self.maxDistance
    else
      local extendPer = NumberUtility.Clamp01((self.curDistance - self.maxDistance) / self.springDistance)
      newDistance = self.curDistance + deltaDistance * (1 - math.pow(extendPer, self.springTight))
      if newDistance > self.extendMaxDistance then
        newDistance = self.extendMaxDistance
      end
    end
    pos:Sub(myselfPos)
    pos:Normalize()
    pos:Mul(newDistance)
    pos:Add(myselfPos)
  end
  self:CameraMoveTo(pos, newDistance)
end

function SniperView:CameraMoveTo(pos, distance, time)
  if VectorUtility.AlmostEqual_3(pos, self.vecCurCameraPos) then
    return false
  end
  self.tabCameraWorld.tsfMoveRoot.position = VectorUtility.Asign_3(self.vecCurCameraPos, pos)
  self.isCameraMoving = true
  local targetPos = LuaGeometry.TempGetPosition(self.tabCameraWorld.tsfRotateRoot)
  TweenPosition.Begin(self.tabCameraWorld.gameObject, time or 0.05, targetPos, true):SetOnFinished(function()
    self.isCameraMoving = false
  end)
  self:ResetCurDistance(distance)
  return true
end

function SniperView:ResetCameraToStartPos(callbackOnFinished)
  local tweeners = self.tabCameraWorld.gameObject:GetComponents(UITweener)
  if tweeners then
    for i = 1, #tweeners do
      GameObject.DestroyImmediate(tweeners[i])
    end
  end
  self.vecLastMyselfPos = VectorUtility.Asign_3(self.vecLastMyselfPos, _Game.Myself:GetPosition())
  self.tabCameraWorld.tsfMoveRoot.position = VectorUtility.Asign_3(self.vecCurCameraPos, _Game.Myself:GetPosition())
  local eulerX, eulerY, eulerZ = LuaGameObject.GetEulerAngles(self.tabCameraWorld.transform)
  self.tabCameraWorld.tsfMoveRoot.eulerAngles = LuaGeometry.GetTempVector3(0, eulerY, 0)
  local configOffset = GameConfig.Sniper.CameraStartOffset
  local cameraPos = LuaGeometry.GetTempVector3(configOffset[1] or 0, configOffset[2] or 12, configOffset[3] or -6)
  cameraPos = LuaGeometry.GetTempVector3(VectorHelper.RotateVector(cameraPos, 0, eulerY, 0))
  LuaVector3.Add(cameraPos, self.vecCurCameraPos)
  self.tabCameraWorld.tsfRotateRoot.position = cameraPos
  self.tabCameraWorld.tsfRotateRoot:LookAt(self.vecCurCameraPos)
  eulerX = LuaGameObject.GetEulerAngles(self.tabCameraWorld.tsfRotateRoot)
  self.tabCameraWorld.tsfRotateRoot.eulerAngles = LuaGeometry.GetTempVector3(eulerX, eulerY, 0)
  self.tabCameraWorld.cameraCopy.fieldOfView = FunctionCameraEffect.FreeCameraFov
  local switchDuration = GameConfig.Sniper.SwitchDuration or 0.5
  TweenFOV.Begin(self.tabCameraWorld.gameObject, switchDuration, FunctionCameraEffect.FreeCameraFov).method = 1
  TweenTransform.Begin(self.tabCameraWorld.gameObject, switchDuration, self.tabCameraWorld.tsfRotateRoot):SetOnFinished(function()
    if callbackOnFinished then
      callbackOnFinished()
    end
  end)
  self:ResetCurDistance(0)
end

function SniperView:OnRotateJoystickValueChanged(deltaX, deltaY)
  self.rotateJoystickValue = deltaX * self.rotateCameraAutoHoriSpeed
end

function SniperView:IsInited()
  return self.isViewInited
end

function SniperView:CanOperate()
  return self:IsInited() and not self.isForbidOperate
end

function SniperView:WorldToScreenPoint(pos)
  if not self:IsInited() then
    redlog("Not Inited")
    return pos
  end
  return self.tabCameraWorld.cameraCopy:WorldToScreenPoint(pos)
end

function SniperView:ScreenToWorldPoint(pos)
  if not self:IsInited() then
    redlog("Not Inited")
    return pos
  end
  return self.tabCameraWorld.cameraCopy:ScreenToWorldPoint(pos)
end

function SniperView:TryGetClickObjByLayers(layers, rayLength)
  rayLength = rayLength or 10000
  local ray = self.tabCameraWorld.camera:ScreenPointToRay(Input.mousePosition)
  local isHit, hitInfo
  for i = 1, #layers do
    isHit, hitInfo = Physics.Raycast(ray, LuaOut, rayLength, 1 << layers[i])
    if isHit then
      return hitInfo.collider.gameObject
    end
  end
end

function SniperView:ResetCurDistance(distance, force)
  if not force and self.curDistance == distance then
    return
  end
  self.curDistance = distance
  local cfgEyeColors = GameConfig.Sniper.EyeUIColors
  if not cfgEyeColors then
    return
  end
  local found = false
  local config
  for i = 1, #cfgEyeColors do
    config = cfgEyeColors[i]
    if distance < config.distance then
      found = true
      if i < 2 then
        self:SetDistanceSignColor(config.r, config.g, config.b)
        break
      end
      do
        local lastCfg = cfgEyeColors[i - 1]
        local percent = NumberUtility.Clamp01((distance - lastCfg.distance) / (config.distance - lastCfg.distance))
        local lerp = NumberUtility.LerpUnclamped
        if 0 < percent then
          self:SetDistanceSignColor(lerp(lastCfg.r, config.r, percent), lerp(lastCfg.g, config.g, percent), lerp(lastCfg.b, config.b, percent))
          break
        end
        self:SetDistanceSignColor(lastCfg.r, lastCfg.g, lastCfg.b)
      end
      break
    end
  end
  if not found and config then
    self:SetDistanceSignColor(config.r, config.g, config.b)
  end
end

function SniperView:SetDistanceSignColor(r, g, b)
  self.effectDistanceEyeColor:SetColor(LuaGeometry.GetTempColor(r / 255, g / 255, b / 255, 1), true)
end

function SniperView:DistanceSignBlingBling()
  if self.buffEndTime - ServerTime.CurServerTime() > 5000 or not self.tweenAlpha_distanceSign then
    return
  end
  self.tweenAlpha_distanceSign:ResetToBeginning()
  self.tweenAlpha_distanceSign:PlayForward()
end

function SniperView:OnEffectSniperRingCreate(effectHandle)
  _Game.TransformFollowManager:RegisterFollowPos(effectHandle.transform, _Game.Myself.assetRole.completeTransform, LuaGeometry.GetTempVector3(0, 0.01, 0), nil, nil)
  local tick = TimeTickManager.Me():CreateTickFromTo(0, 0, 1, 1000, self.UpdateSnierRingScale, self, 3)
  tick:SetCompleteFunc(self.SniperRingScaleAnimFinish)
end

function SniperView:UpdateSnierRingScale(deltaTime, value)
  self:SetSniperRingScale(NumberUtility.Lerp(0, FunctionSniperMode.Me():GetCurMaxAttackRange(), value))
end

function SniperView:SniperRingScaleAnimFinish()
  self.sniperRingAnimOver = true
end

function SniperView:SetSniperRingScale(scale)
  if not self.effectSniperRing then
    return
  end
  self.effectSniperRing:ResetLocalScaleXYZ(scale, 1, scale)
end

function SniperView:MonoUpdate(time, deltaTime)
  if not self:IsInited() then
    return
  end
  if self.tabCameraWorld.contoller.enabled then
    self:CloseSelf()
    return
  end
  if self.sniperRingAnimOver then
    local maxAttackRange = FunctionSniperMode.Me():GetCurMaxAttackRange()
    if maxAttackRange ~= self.lastMaxAttackRange then
      self.lastMaxAttackRange = maxAttackRange
      self:SetSniperRingScale(maxAttackRange)
    end
  end
  self:CheckMyselfMoved()
  if self.isCameraRotating then
    self.tabCameraWorld.transform:LookAt(self.vecCameraLookPoint)
  end
  local exInputPosition = FunctionSniperMode.Me():GetExtraInputPosition()
  if self.isMousePressing and exInputPosition then
    local inputPos = LuaGeometry.GetTempVector3(exInputPosition.x, exInputPosition.y, exInputPosition.z)
    inputPos.x = math.clamp(inputPos.x, 0, self.screenWidth)
    inputPos.y = math.clamp(inputPos.y, 0, self.screenHeight)
    local moveX = self:CalculateCameraAutoMoveSpeed(inputPos.x, self.screenWidth)
    local moveY = self:CalculateCameraAutoMoveSpeed(inputPos.y, self.screenHeight)
    if moveX ~= 0 or moveY ~= 0 then
      local delta = LuaGeometry.GetTempVector2(moveX, moveY)
      self:CameraMove(delta, true)
    end
  end
  if self.rotateJoystickValue ~= 0 then
    self:CameraRotate(LuaGeometry.GetTempVector2(self.rotateJoystickValue * deltaTime, 0))
  end
end

function SniperView:CheckMyselfMoved()
  local myselfPos = _Game.Myself:GetPosition()
  local l_vectorUtility = VectorUtility
  if l_vectorUtility.AlmostEqual_3(self.vecLastMyselfPos, myselfPos) then
    return
  end
  local newDistance = l_vectorUtility.DistanceXZ(self.vecCurCameraPos, myselfPos)
  if newDistance > self.maxDistance then
    self.curDistance = newDistance
    self:LimitCameraPos()
  else
    local pos = VectorUtility.Asign_3(LuaGeometry.GetTempVector3(), self.vecCurCameraPos)
    pos[2] = pos[2] + (myselfPos[2] - self.vecLastMyselfPos[2])
    if not self:CameraMoveTo(pos, newDistance) then
      self:ResetCurDistance(newDistance)
    end
  end
  self.vecLastMyselfPos = l_vectorUtility.Asign_3(self.vecLastMyselfPos, myselfPos)
end

function SniperView:CalculateCameraAutoMoveSpeed(value, maxValue)
  if value < self.dragScreenMoveEdge then
    return (1 - value / self.dragScreenMoveEdge) * self.dragScreenMoveSpeed
  elseif value > maxValue - self.dragScreenMoveEdge then
    return ((maxValue - value) / self.dragScreenMoveEdge - 1) * self.dragScreenMoveSpeed
  end
  return 0
end

function SniperView:RefreshBuffEffect(buffEffect)
end

function SniperView:OnExInputStatusChange(haveExPos)
  self.rotateJoystick.Disable = haveExPos == true
end

function SniperView:OnEnter()
  SniperView.super.OnEnter(self)
  FunctionSniperMode.Me():SetSniperViewInstance(self)
  self.initRetryCount = 0
  self.errorOccured = false
  self.isViewInited = false
  self.sniperRingAnimOver = false
  self:RefreshBuffEffect(self.viewdata.viewdata)
  self:InitView()
end

function SniperView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.effectSniperRing then
    self.effectSniperRing:Destroy()
    self.effectSniperRing = nil
  end
  if self.effEye then
    self.effEye:Destroy()
    self.effEye = nil
  end
  if FunctionSniperMode.Me():IsWorking() then
    ServiceSkillProxy.Instance:CallStopSniperModeSkillCmd()
  end
  FunctionSniperMode.Me():SetSniperViewInstance(nil)
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
  if self.tabCameraWorld and not LuaGameObject.ObjectIsNull(self.tabCameraWorld.gameObject) then
    local tweeners = self.tabCameraWorld.gameObject:GetComponentsInChildren(UITweener, true)
    if tweeners then
      for i = 1, #tweeners do
        LuaGameObject.DestroyObject(tweeners[i])
      end
    end
    self.tabCameraWorld.contoller.applyCurrentInfoPause = false
    self.tabCameraWorld.contoller:InterruptSmoothTo()
    self.tabCameraWorld.contoller.enabled = true
    self.tabCameraWorld.contoller:RestoreDefault(0, nil)
    self.tabCameraWorld.contoller:FieldOfViewTo(self.tabCameraWorld.contoller.cameraFieldOfView, 0, nil)
    if Game.CameraPointManager then
      Game.CameraPointManager:SendMessage("LateUpdate", SendMessageOptions.DontRequireReceiver)
      self.tabCameraWorld.contoller:InterruptSmoothTo()
    end
    self.tabCameraWorld.contoller:ForceUpdateCamera(true, false)
  end
  _Game.MapCellManager:ResetCenterTransform(_Game.Myself.assetRole.completeTransform)
  _Game.LogicManager_MapCell:SetIgnoreCameraDir(self.originIgnoreCameraDir)
  _Game.AreaTriggerManager:SetIgnore(false)
  self.isViewInited = false
  SniperView.super.OnExit(self)
end

function SniperView:OnDestroy()
  if self.tabCameraWorld then
    TableUtility.TableClear(self.tabCameraWorld)
  end
  SniperView.super.OnDestroy(self)
end
