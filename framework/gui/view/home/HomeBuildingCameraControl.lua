HomeBuildingCameraControl = class("HomeBuildingCameraControl", SubView)
local m_vec2CameraRotateDelta = LuaVector2(0, 0)

function HomeBuildingCameraControl:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeBuildingCameraControl:FindObjs()
  self.objRotateArrows = self:FindGO("RotateArrows", self.container.objFrontPanel)
  local l_objWorldRoot = self:FindGO("WorldRoot")
  self.tsfWorldRoot = l_objWorldRoot.transform
  self.tsfWorldRoot.parent = nil
  self.tsfWorldRoot.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.tsfWorldRoot.parent = self.trans
end

function HomeBuildingCameraControl:AddEvts()
  self:AddPressEvent(self:FindGO("btnRotateLeft", self.objRotateArrows), function(go, isPress)
    self.isRotateLeft = isPress
  end)
  self:AddPressEvent(self:FindGO("btnRotateRight", self.objRotateArrows), function(go, isPress)
    self.isRotateRight = isPress
  end)
  self:AddPressEvent(self:FindGO("btnRotateUp", self.objRotateArrows), function(go, isPress)
    self.isRotateUp = isPress
  end)
  self:AddPressEvent(self:FindGO("btnRotateDown", self.objRotateArrows), function(go, isPress)
    self.isRotateDown = isPress
  end)
end

function HomeBuildingCameraControl:AddViewEvts()
end

function HomeBuildingCameraControl:InitView()
  if self.ltInitCamera then
    return
  end
  local l_cameraController = CameraController.Instance
  if not l_cameraController then
    if not self.errorOccured then
      self.gameObject:SetActive(false)
      if self.container.filtersWhenViewOpen ~= nil then
        FunctionSceneFilter.Me():EndFilter(self.container.filtersWhenViewOpen)
      end
      self.errorOccured = true
    end
    self.initRetryCount = self.initRetryCount + 1
    if self.initRetryCount > 9 then
      LogUtility.Error("无法找到CameraController，重试10次失败，建造模式退出！")
      self.container:CloseSelf()
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
    if self.container.filtersWhenViewOpen ~= nil then
      FunctionSceneFilter.Me():StartFilter(self.container.filtersWhenViewOpen)
    end
    self.errorOccured = false
  end
  local curMapSData = HomeManager.Me():GetCurMapSData()
  local curMapID = curMapSData and curMapSData.id or 3007
  self.dragCameraSpeed = GameConfig.Home.DragCameraSpeed
  self.dragCameraWaitNum = GameConfig.Home.DragCameraWaitNum
  self.rotateCameraHoriSpeed = GameConfig.Home.RotateCameraHoriSpeed
  self.rotateCameraVertSpeed = GameConfig.Home.RotateCameraVertSpeed
  self.rotateCameraMouseSpeed = GameConfig.Home.RotateCameraMouseSpeed
  self.rotateCameraAutoHoriSpeed = GameConfig.Home.RotateCameraAutoHoriSpeed
  self.rotateCameraAutoVertSpeed = GameConfig.Home.RotateCameraAutoVertSpeed
  self.cameraMinVertAngle = GameConfig.Home.CameraMinVertAngle
  self.cameraMaxVertAngle = GameConfig.Home.CameraMaxVertAngle
  self.cameraZoomOnePixels = GameConfig.Home.CameraZoomOnePixels
  self.cameraMinFov = GameConfig.Home.CameraMinFov
  self.cameraMaxFov = GameConfig.Home.CameraMaxFov
  self.cameraMinPos = GameConfig.Home.CameraMinPos[curMapID]
  self.cameraMaxPos = GameConfig.Home.CameraMaxPos[curMapID]
  if not self.cameraMaxPos or not self.cameraMaxPos then
    LogUtility.Error(string.format("没有找到地图: %s的摄像机范围配置！", curMapID))
    self.container:CloseSelf()
    return
  end
  local l_cameraWorld = l_cameraController.activeCamera
  local l_objCameraMoveRoot = self:FindGO("CameraMoveRoot", self.tsfWorldRoot.gameObject)
  local l_objCameraRotateRoot = self:FindGO("CameraRotateRoot", l_objCameraMoveRoot)
  self.tabCameraWorld = {
    contoller = l_cameraController,
    camera = l_cameraWorld,
    allCameras = l_cameraWorld:GetComponentsInChildren(Camera),
    gameObject = l_cameraController.gameObject,
    transform = l_cameraController.transform,
    tsfMoveRoot = l_objCameraMoveRoot.transform,
    tsfRotateRoot = l_objCameraRotateRoot.transform,
    cameraCopy = l_objCameraRotateRoot:GetComponent(Camera)
  }
  self.isRunOnWindows = ApplicationInfo.IsRunOnWindowns()
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  self.vecScreenCenter = LuaVector3(self.screenWidth / 2, self.screenHeight / 2, 0)
  self.dragWaitCounter = 0
  self.tabCameraWorld.contoller.applyCurrentInfoPause = true
  self.tabCameraWorld.contoller.enabled = false
  self.tabCameraWorld.cameraCopy:CopyFrom(self.tabCameraWorld.camera)
  local l_fieldOfView = self.tabCameraWorld.contoller.cameraFieldOfView
  self.tabCameraWorld.fovRecord = l_fieldOfView
  self.tabCameraWorld.curFov = l_fieldOfView
  self.isForbidOperate = true
  self:ResetCameraToEditStartPos(function()
    self.isViewInited = true
    self.isForbidOperate = false
  end)
  HomeFurniturOutLine.Me():StartRender(self.tabCameraWorld.camera)
  Game.AreaTriggerManager:SetIgnore(true)
  self:ProcessWallsAndPillarsShow()
  self:InitPhotoData()
end

function HomeBuildingCameraControl:InitPhotoData()
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  local currentMap = SceneProxy.Instance.currentScene
  self.cameraData = Table_Camera[currentMap and Table_Map[currentMap.mapID].Camera or 1]
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function HomeBuildingCameraControl:TakePhoto()
  if not self:IsInited() or not self.tabCameraWorld then
    return
  end
  local gmCm = self.tabCameraWorld.camera
  local _, _, anglez = LuaGameObject.GetEulerAngles(self.tabCameraWorld.transform)
  anglez = GeometryUtils.UniformAngle(anglez)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    local viewdata = {
      viewname = "PhotographResultPanel",
      forbiddenClose = true,
      anglez = anglez,
      cameraData = self.cameraData,
      texture = texture,
      mapID = Game.MapManager:GetMapID()
    }
    self:sendNotification(UIEvent.ShowUI, viewdata)
  end, gmCm, PpLua.m_PpCamera)
  self:PlayUISound(AudioMap.UI.Picture)
end

function HomeBuildingCameraControl:OnPress(go, isPress)
  self.dragWaitCounter = 0
end

function HomeBuildingCameraControl:OnDrag(go, delta)
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

local vecTempCameraVector = LuaVector3(0, 0, 0)

function HomeBuildingCameraControl:CameraRotate(delta)
  delta = delta or m_vec2CameraRotateDelta
  if delta.x == 0 and delta.y == 0 then
    return
  end
  if not self.vecCameraLookPoint then
    self.vecCameraLookPoint = LuaVector3(0, 0, 0)
  end
  LuaVector3.Better_Set(self.vecCameraLookPoint, LuaGameObject.GetPosition(self.tabCameraWorld.tsfMoveRoot))
  if math.abs(delta.y) > math.abs(delta.x) then
    if self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraRotateVert) then
      return
    end
    self:StopCameraMove()
    LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetPosition(self.tabCameraWorld.tsfRotateRoot))
    LuaVector3.Sub(vecTempCameraVector, self.vecCameraLookPoint)
    local vecCameraForward = LuaGeometry.GetTempVector3(vecTempCameraVector[1], 0, vecTempCameraVector[3])
    local curAngle = LuaVector3.Angle(LuaVector3.Normalize(vecTempCameraVector), LuaVector3.Normalize(vecCameraForward))
    local angle = -delta.y
    angle = 0 < delta.y and math.clamp(angle, math.min(self.cameraMinVertAngle - curAngle, 0), 0) or math.clamp(angle, 0, math.max(self.cameraMaxVertAngle - curAngle, 0))
    if math.abs(angle) > 0.1 then
      self.container.guideView:StartGuideStep(HomeBuildingGuideView.Step.CameraRotateVert)
      self.tabCameraWorld.tsfRotateRoot:RotateAround(self.vecCameraLookPoint, self.tabCameraWorld.tsfRotateRoot.right, angle)
    end
  else
    if self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraRotateHori) then
      return
    end
    self:StopCameraMove()
    self.container.guideView:StartGuideStep(HomeBuildingGuideView.Step.CameraRotateHori)
    self.tabCameraWorld.tsfRotateRoot:RotateAround(self.vecCameraLookPoint, LuaGeometry.GetTempVector3(0, 1, 0), delta.x)
  end
  self.tabCameraWorld.tsfRotateRoot.parent = self.tsfWorldRoot
  self.tabCameraWorld.tsfRotateRoot:LookAt(self.vecCameraLookPoint)
  local eulerAngles = LuaGeometry.TempGetEulerAngles(self.tabCameraWorld.tsfRotateRoot)
  self.tabCameraWorld.tsfMoveRoot.eulerAngles = LuaGeometry.GetTempVector3(0, eulerAngles.y, 0)
  self.tabCameraWorld.tsfRotateRoot.parent = self.tabCameraWorld.tsfMoveRoot
  self.isCameraRotating = true
  self.isForbidOperate = true
  local targetPos = LuaGeometry.TempGetPosition(self.tabCameraWorld.tsfRotateRoot)
  TweenPosition.Begin(self.tabCameraWorld.gameObject, 0.05, targetPos, true):SetOnFinished(function()
    if self.vecCameraLookPoint then
      self.tabCameraWorld.transform:LookAt(self.vecCameraLookPoint)
      self:ProcessAdjustArrowsRotate()
    end
    self.isCameraRotating = false
    self.isForbidOperate = false
  end)
  self:ProcessWallsAndPillarsShow()
end

function HomeBuildingCameraControl:CameraMove(delta)
  if self.isCameraRotating then
    return
  end
  if self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraMove) then
    return
  end
  local pos = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetTransformRight(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Mul(vecTempCameraVector, -delta.x * self.dragCameraSpeed)
  LuaVector3.Add(pos, vecTempCameraVector)
  LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetTransformForward(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Mul(vecTempCameraVector, -delta.y * self.dragCameraSpeed)
  LuaVector3.Add(pos, vecTempCameraVector)
  self.container.guideView:StartGuideStep(HomeBuildingGuideView.Step.CameraMove)
  self:CameraMoveTo(pos)
end

function HomeBuildingCameraControl:CameraMoveTo(pos)
  if self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraMove) then
    return
  end
  pos[1] = math.clamp(pos[1], self.cameraMinPos[1], self.cameraMaxPos[1])
  pos[3] = math.clamp(pos[3], self.cameraMinPos[2], self.cameraMaxPos[2])
  self.tabCameraWorld.tsfMoveRoot.position = pos
  self.isCameraMoving = true
  local targetPos = LuaGeometry.TempGetPosition(self.tabCameraWorld.tsfRotateRoot)
  TweenPosition.Begin(self.tabCameraWorld.gameObject, 0.05, targetPos, true):SetOnFinished(function()
    self.isCameraMoving = false
  end)
  self:ProcessWallsAndPillarsShow()
end

function HomeBuildingCameraControl:StopCameraMove()
  if not self.isCameraMoving or not self.tabCameraWorld then
    return
  end
  self.isCameraMoving = false
  local tweener = self.tabCameraWorld.gameObject:GetComponent(TweenPosition)
  if not tweener or not tweener.enabled then
    return
  end
  tweener.enabled = false
  self.tabCameraWorld.tsfRotateRoot.parent = self.tsfWorldRoot
  self.tabCameraWorld.tsfRotateRoot.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.tabCameraWorld.transform))
  local ray = self.tabCameraWorld.cameraCopy:ScreenPointToRay(self.vecScreenCenter)
  local isHit, hitInfo = Physics.Raycast(ray, LuaOut, 10000, 1 << Game.ELayer.HomeDefaultGround)
  if not isHit then
    LogUtility.Error("重置摄像机位置失败，建造模式退出！")
    self.container:CloseSelf()
    return
  end
  self.tabCameraWorld.tsfMoveRoot.position = hitInfo.point
  self.tabCameraWorld.tsfRotateRoot.parent = self.tabCameraWorld.tsfMoveRoot
  self:ProcessWallsAndPillarsShow()
end

function HomeBuildingCameraControl:ResetCameraToEditStartPos(callbackOnFinished)
  local tweeners = self.tabCameraWorld.gameObject:GetComponents(UITweener)
  if tweeners then
    for i = 1, #tweeners do
      GameObject.DestroyImmediate(tweeners[i])
    end
  end
  local curMapSData = HomeManager.Me():GetCurMapSData()
  local curMapID = curMapSData and curMapSData.id or 3007
  self.tabCameraWorld.tsfRotateRoot.parent = self.tsfWorldRoot
  self.tabCameraWorld.tsfRotateRoot.position = LuaGeometry.GetTempVector3(unpack(GameConfig.Home.CameraStartPos[curMapID]))
  local x, y, z = unpack(GameConfig.Home.CameraStartRotate[curMapID])
  self.tabCameraWorld.tsfMoveRoot.eulerAngles = LuaGeometry.GetTempVector3(0, y, 0)
  self.tabCameraWorld.tsfRotateRoot.eulerAngles = LuaGeometry.GetTempVector3(x, y, z)
  local ray = self.tabCameraWorld.cameraCopy:ScreenPointToRay(self.vecScreenCenter)
  local isHit, hitInfo = Physics.Raycast(ray, LuaOut, 10000, 1 << Game.ELayer.HomeDefaultGround)
  if not isHit then
    LogUtility.Error("重置摄像机位置失败，建造模式退出！")
    self.container:CloseSelf()
    return
  end
  self.tabCameraWorld.tsfMoveRoot.position = hitInfo.point
  self.tabCameraWorld.tsfRotateRoot.parent = self.tabCameraWorld.tsfMoveRoot
  local startFov = GameConfig.Home.CameraStartFov[curMapID]
  self.tabCameraWorld.cameraCopy.fieldOfView = startFov
  for i = 1, #self.tabCameraWorld.allCameras do
    TweenFOV.Begin(self.tabCameraWorld.allCameras[i].gameObject, 0.5, startFov)
  end
  TweenTransform.Begin(self.tabCameraWorld.gameObject, 0.5, self.tabCameraWorld.tsfRotateRoot):SetOnFinished(function()
    self.tabCameraWorld.curFov = startFov
    self:ProcessWallsAndPillarsShow()
    self:ProcessAdjustArrowsRotate()
    self.updateFov = false
    if callbackOnFinished then
      callbackOnFinished()
    end
  end)
  self.updateFov = true
end

function HomeBuildingCameraControl:ProcessWallsAndPillarsShow()
  HomeManager.Me():ProcessWallsAndPillarsShow(LuaGameObject.GetPosition(self.tabCameraWorld.tsfRotateRoot))
end

function HomeBuildingCameraControl:ProcessAdjustArrowsRotate()
  local eulerAngles = LuaGeometry.TempGetEulerAngles(self.tabCameraWorld.transform)
  self.container.tsfAdjustFurnitureBtns.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, eulerAngles.y)
end

function HomeBuildingCameraControl:IsInited()
  return self.isViewInited
end

function HomeBuildingCameraControl:CanOperate()
  return self:IsInited() and not self.isForbidOperate
end

function HomeBuildingCameraControl:ShowRotateArrows(isShow)
  self.objRotateArrows:SetActive(isShow)
end

function HomeBuildingCameraControl:WorldToScreenPoint(pos)
  if not self:IsInited() then
    redlog("Not Inited")
    return pos
  end
  return self.tabCameraWorld.cameraCopy:WorldToScreenPoint(pos)
end

function HomeBuildingCameraControl:ScreenToWorldPoint(pos)
  if not self:IsInited() then
    redlog("Not Inited")
    return pos
  end
  return self.tabCameraWorld.cameraCopy:ScreenToWorldPoint(pos)
end

function HomeBuildingCameraControl:GetGroundPosAtScreenPos(screenPosition)
  local ray = self.tabCameraWorld.cameraCopy:ScreenPointToRay(screenPosition)
  local isHit, hitInfo = Physics.Raycast(ray, LuaOut, 10000, 1 << Game.ELayer.HomeGround)
  if isHit then
    return hitInfo.point, tonumber(hitInfo.collider.name)
  end
  isHit, hitInfo = Physics.Raycast(ray, LuaOut, 10000, 1 << Game.ELayer.HomeDefaultGround)
  if isHit then
    return hitInfo.point, 1
  end
end

function HomeBuildingCameraControl:TryGetClickObjByLayers(layers, rayLength)
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

local lastTouchInfo = {
  touchPos1 = LuaVector3(0, 0, 0),
  touchPos2 = LuaVector3(0, 0, 0),
  touch2ToTouch1 = LuaVector3(0, 0, 0)
}
local curTouchInfo = {
  touchPos1 = LuaVector3(0, 0, 0),
  touchPos2 = LuaVector3(0, 0, 0),
  touch2ToTouch1 = LuaVector3(0, 0, 0)
}
local lastMousePos = LuaVector2(0, 0)
local vecCross = LuaVector3(0, 0, 0)

function HomeBuildingCameraControl:MonoUpdate(time, deltaTime)
  if not self:IsInited() then
    return
  end
  if self.isCameraRotating and self.vecCameraLookPoint then
    self.tabCameraWorld.transform:LookAt(self.vecCameraLookPoint)
    self:ProcessAdjustArrowsRotate()
  end
  local tarFov = self.tabCameraWorld.curFov
  if not self.container.isDragObj and Input.touchCount > 1 then
    local touch1 = Input.GetTouch(0)
    local touch2 = Input.GetTouch(1)
    local touchPhase1, touchPhase2 = touch1.phase, touch2.phase
    local touchPos1, touchPos2 = touch1.position, touch2.position
    LuaVector3.Better_Set(curTouchInfo.touchPos1, touchPos1.x, touchPos1.y, 0)
    LuaVector3.Better_Set(curTouchInfo.touchPos2, touchPos2.x, touchPos2.y, 0)
    curTouchInfo.touchDistance = VectorUtility.DistanceXY(curTouchInfo.touchPos1, curTouchInfo.touchPos2)
    LuaVector3.Better_Set(curTouchInfo.touch2ToTouch1, curTouchInfo.touchPos2[1], curTouchInfo.touchPos2[2], 0)
    LuaVector3.Sub(curTouchInfo.touch2ToTouch1, curTouchInfo.touchPos1)
    if touchPhase2 == TouchPhase.Began then
      LuaVector3.Better_Set(lastTouchInfo.touchPos1, curTouchInfo.touchPos1[1], curTouchInfo.touchPos1[2], 0)
      LuaVector3.Better_Set(lastTouchInfo.touchPos2, curTouchInfo.touchPos2[1], curTouchInfo.touchPos2[2], 0)
      LuaVector3.Better_Set(lastTouchInfo.touch2ToTouch1, curTouchInfo.touch2ToTouch1[1], curTouchInfo.touch2ToTouch1[2], 0)
      lastTouchInfo.touchDistance = curTouchInfo.touchDistance
      LuaVector2.Better_Set(m_vec2CameraRotateDelta, 0, 0)
      self.isRotateMove = true
      if not self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraRotateVert) and not self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraRotateHori) then
        self:StopCameraMove()
      end
    elseif touchPhase1 == TouchPhase.Moved or touchPhase2 == TouchPhase.Moved then
      if self.isRotateMove then
        local xOffset1, xOffset2 = curTouchInfo.touchPos1[1] - lastTouchInfo.touchPos1[1], curTouchInfo.touchPos2[1] - lastTouchInfo.touchPos2[1]
        local yOffset1, yOffset2 = curTouchInfo.touchPos1[2] - lastTouchInfo.touchPos1[2], curTouchInfo.touchPos2[2] - lastTouchInfo.touchPos2[2]
        if 0 < yOffset1 * yOffset2 and math.abs(yOffset1) > math.abs(xOffset1) and math.abs(yOffset2) > math.abs(xOffset2) then
          LuaVector2.Better_Set(m_vec2CameraRotateDelta, 0, (yOffset1 + yOffset2) / 2 * self.rotateCameraVertSpeed)
        else
          local angle = LuaVector3.Angle(lastTouchInfo.touch2ToTouch1, curTouchInfo.touch2ToTouch1)
          angle = angle * (0 < LuaVector3.Better_Cross(lastTouchInfo.touch2ToTouch1, curTouchInfo.touch2ToTouch1, vecCross)[3] and 1 or -1)
          LuaVector2.Better_Set(m_vec2CameraRotateDelta, angle * self.rotateCameraHoriSpeed, 0)
        end
      end
      tarFov = tarFov - (curTouchInfo.touchDistance - lastTouchInfo.touchDistance) / self.cameraZoomOnePixels
      LuaVector3.Better_Set(lastTouchInfo.touchPos1, curTouchInfo.touchPos1[1], curTouchInfo.touchPos1[2], 0)
      LuaVector3.Better_Set(lastTouchInfo.touchPos2, curTouchInfo.touchPos2[1], curTouchInfo.touchPos2[2], 0)
      LuaVector3.Better_Set(lastTouchInfo.touch2ToTouch1, curTouchInfo.touch2ToTouch1[1], curTouchInfo.touch2ToTouch1[2], 0)
      lastTouchInfo.touchDistance = curTouchInfo.touchDistance
    end
    if touchPhase1 == TouchPhase.Ended or touchPhase2 == TouchPhase.Ended then
      self.isRotateMove = false
      self.container.guideView:OnZoomOver()
    end
  end
  if self.isRunOnWindows or self.isRunOnEditor then
    local scrollDelta = Input.GetAxis("Mouse ScrollWheel")
    if scrollDelta ~= 0 then
      tarFov = tarFov + (0 < scrollDelta and -1 or 1)
    end
    if Input.GetMouseButtonDown(1) then
      LuaVector2.Better_Set(lastMousePos, LuaGameObject.GetMousePosition())
      LuaVector2.Better_Set(m_vec2CameraRotateDelta, 0, 0)
      self.isRotateMove = true
      if not self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraRotateVert) and not self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraRotateHori) then
        self:StopCameraMove()
      end
    elseif self.isRotateMove and Input.GetMouseButton(1) then
      local mouseX, mouseY, mouseZ = LuaGameObject.GetMousePosition()
      LuaVector2.Better_Set(m_vec2CameraRotateDelta, mouseX, mouseY)
      LuaVector2.Sub(m_vec2CameraRotateDelta, lastMousePos)
      LuaVector2.Mul(m_vec2CameraRotateDelta, self.rotateCameraMouseSpeed)
      LuaVector2.Better_Set(lastMousePos, mouseX, mouseY)
    end
    if Input.GetMouseButtonUp(1) then
      self.isRotateMove = false
    end
    if self.isRunOnEditor and Input.GetKeyDown(KeyCode.B) then
      self.container.guideView:CheckNeedShowGuide(true)
    end
  end
  local isUpdateFov = self.updateFov
  tarFov = math.clamp(tarFov, self.cameraMinFov, self.cameraMaxFov)
  if not self.container.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.CameraZoom) and tarFov ~= self.tabCameraWorld.curFov then
    self.container.guideView:StartGuideStep(HomeBuildingGuideView.Step.CameraZoom)
    for i = 1, #self.tabCameraWorld.allCameras do
      self.tabCameraWorld.allCameras[i].fieldOfView = tarFov
    end
    self.tabCameraWorld.cameraCopy.fieldOfView = tarFov
    self.tabCameraWorld.curFov = tarFov
    isUpdateFov = true
  end
  if isUpdateFov and not LuaGameObject.ObjectIsNull(PpLua.m_PpCamera) then
    PpLua.m_PpCamera.fieldOfView = self.tabCameraWorld.camera.fieldOfView
  end
  local autoRotateDelta = LuaGeometry.GetTempVector2(0, 0)
  if self.isRotateLeft then
    autoRotateDelta.x = autoRotateDelta.x + self.rotateCameraAutoHoriSpeed * deltaTime
  end
  if self.isRotateRight then
    autoRotateDelta.x = autoRotateDelta.x - self.rotateCameraAutoHoriSpeed * deltaTime
  end
  if self.isRotateUp then
    autoRotateDelta.y = autoRotateDelta.y - self.rotateCameraAutoVertSpeed * deltaTime
  end
  if self.isRotateDown then
    autoRotateDelta.y = autoRotateDelta.y + self.rotateCameraAutoVertSpeed * deltaTime
  end
  self:CameraRotate(autoRotateDelta)
end

function HomeBuildingCameraControl:OnEnter()
  HomeBuildingCameraControl.super.OnEnter(self)
  self.initRetryCount = 0
  self.errorOccured = false
  self.isViewInited = false
  self:InitView()
end

function HomeBuildingCameraControl:OnExit()
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
    if self.tabCameraWorld.fovRecord then
      self.tabCameraWorld.contoller:FieldOfViewTo(self.tabCameraWorld.fovRecord, 0, nil)
    end
  end
  Game.AreaTriggerManager:SetIgnore(false)
  self.isViewInited = false
  HomeBuildingCameraControl.super.OnExit(self)
end

function HomeBuildingCameraControl:OnDestroy()
  if self.tabCameraWorld then
    TableUtility.TableClear(self.tabCameraWorld)
  end
  HomeBuildingCameraControl.super.OnDestroy(self)
end
