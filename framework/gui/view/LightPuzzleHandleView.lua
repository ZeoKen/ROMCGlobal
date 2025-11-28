LightPuzzleHandleView = class("LightPuzzleHandleView", ContainerView)
LightPuzzleHandleView.ViewType = UIViewType.NormalLayer
local translateSpeed = 0.05
local rotateSpeed = 0.05
local handleNodeMinY = 0.6
local maxAngleX = 20
local minAngleX = -20
local maxAngleY = 30
local minAngleY = -30
local handlerBgName = "fb_bg_Joystick"
local handlerCenterName = "fb_bg_Joystick2"
local lightEffectMap = {
  [1] = "Eff_Morningstar_star",
  [2] = "Eff_Morningstar_sun",
  [3] = "Eff_Morningstar_moon",
  [4] = "Eff_Morningstar_tree"
}
local centerV3 = LuaVector3.Zero()
local tempV3 = LuaVector3()

function LightPuzzleHandleView:Init()
  self.callback = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.callback
  self.handleNode = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.handleNode
  self.handleNodeTrans = self.handleNode.transform
  local npcId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npcId
  self.handleId = GameConfig.LightPuzzle and GameConfig.LightPuzzle[npcId] and GameConfig.LightPuzzle[npcId].lightId
  if not self.handleId or not self.handleNode then
    self:CloseSelf()
    return
  end
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
  self.isRunOnWindows = ApplicationInfo.IsRunOnWindowns()
  self.touchSupported = Input.touchSupported
  local layer = LayerMask.NameToLayer("UI")
  self.camera = NGUITools.FindCameraForLayer(layer)
  self.handleNodeMaxY = self.handleNodeTrans.localPosition.y
  self:AddListenEvt(LightPuzzleEvent.PuzzleSolved, self.OnPuzzleSolved)
  self:InitView()
  if GameConfig.LightPuzzle[npcId].angleXRange then
    self.minAngleX = GameConfig.LightPuzzle[npcId].angleXRange[1]
    self.maxAngleX = GameConfig.LightPuzzle[npcId].angleXRange[2]
  else
    self.minAngleX = minAngleX
    self.maxAngleX = maxAngleX
  end
  if GameConfig.LightPuzzle[npcId].angleYRange then
    self.minAngleY = GameConfig.LightPuzzle[npcId].angleYRange[1]
    self.maxAngleY = GameConfig.LightPuzzle[npcId].angleYRange[2]
  else
    self.minAngleY = minAngleY
    self.maxAngleY = maxAngleY
  end
end

function LightPuzzleHandleView:InitView()
  local handler = self:FindGO("handler")
  self.handlerTex = handler:GetComponent(UITexture)
  self.center = self:FindGO("center")
  self.centerTex = self.center:GetComponent(UITexture)
  self.effectContainer = self:FindGO("effectContainer")
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  local x, y, z = LuaGameObject.GetLocalPosition(self.center.transform)
  LuaVector3.Better_Set(centerV3, x, y, z)
  self.maxDis = self.handlerTex.width * 0.5
end

function LightPuzzleHandleView:OnEnter()
  self:OnCameraEnter()
  PictureManager.Instance:SetLightPuzzleHandlerTexture(handlerBgName, self.handlerTex)
  PictureManager.Instance:SetLightPuzzleHandlerTexture(handlerCenterName, self.centerTex)
  self:PlayUIEffect(EffectMap.UI[lightEffectMap[self.handleId]], self.effectContainer)
  self:AddMonoUpdateFunction(self.Update)
end

function LightPuzzleHandleView:OnExit()
  self:OnCameraExit()
  PictureManager.Instance:UnloadLightPuzzleHandlerTexture(handlerBgName, self.handlerTex)
  PictureManager.Instance:UnloadLightPuzzleHandlerTexture(handlerCenterName, self.centerTex)
  if self.callback then
    self.callback()
  end
end

function LightPuzzleHandleView:OnCameraEnter()
  if not self.cameraEntered then
    local pos = CameraConfig.LightPuzzle_Focus_Pos
    local viewPort = CameraConfig.LightPuzzle_ViewPort
    local rotation = CameraConfig.LightPuzzle_Rotation
    if not self.cameraFocus then
      self.cameraFocus = GameObject("cameraFocus")
    end
    self.cameraFocus.transform.position = pos
    self:CameraFocusAndRotateTo(self.cameraFocus.transform, viewPort, rotation)
    self.cameraEntered = true
  end
end

function LightPuzzleHandleView:OnCameraExit()
  if self.cameraEntered then
    self:CameraReset()
    if self.cameraFocus then
      GameObject.Destroy(self.cameraFocus)
      self.cameraFocus = nil
    end
    self.cameraEntered = false
  end
end

function LightPuzzleHandleView:OnPuzzleSolved()
  self:CloseSelf()
end

function LightPuzzleHandleView:IsTouchOnHandler(localPos)
  local halfW = self.handlerTex.width * 0.5
  local halfH = self.handlerTex.height * 0.5
  if localPos[1] >= centerV3[1] - halfW and localPos[2] >= centerV3[2] - halfH and localPos[1] <= centerV3[1] + halfW and localPos[2] <= centerV3[2] + halfH then
    return true
  end
  return false
end

function LightPuzzleHandleView:GetTouchLocalPos(x, y, z)
  local touchPos = LuaGeometry.GetTempVector3(x, y, z)
  x, y, z = LuaGameObject.ScreenToWorldPointByVector3(self.camera, touchPos)
  local worldPos = LuaGeometry.GetTempVector3(x, y, z)
  x, y, z = LuaGameObject.InverseTransformPointByVector3(self.center.transform.parent, worldPos)
  local localPos = LuaGeometry.GetTempVector3(x, y, z)
  return localPos
end

function LightPuzzleHandleView:Update(time, deltaTime)
  local x, y, z, localPos
  if self.isRunOnEditor or self.isRunOnWindows then
    if Input.GetMouseButtonDown(0) then
      x, y, z = LuaGameObject.GetMousePosition()
      localPos = self:GetTouchLocalPos(x, y, z)
      if self:IsTouchOnHandler(localPos) then
        self.isTouching = true
      end
    elseif Input.GetMouseButtonUp(0) then
      self.isTouching = false
      self.center.transform.localPosition = centerV3
    elseif Input.GetMouseButton(0) and self.isTouching then
      x, y, z = LuaGameObject.GetMousePosition()
      localPos = self:GetTouchLocalPos(x, y, z)
    end
  elseif self.touchSupported and 0 < Input.touchCount then
    local touch = Input.GetTouch(0)
    if touch.phase == TouchPhase.Began then
      x, y = LuaGameObject.GetTouchPosition(0, false)
      localPos = self:GetTouchLocalPos(x, y, centerV3[3])
      if self:IsTouchOnHandler(localPos) then
        self.isTouching = true
      end
    elseif touch.phase == TouchPhase.Ended then
      self.isTouching = false
      self.center.transform.localPosition = centerV3
    elseif touch.phase == TouchPhase.Moved and self.isTouching then
      x, y = LuaGameObject.GetTouchPosition(0, false)
      localPos = self:GetTouchLocalPos(x, y, centerV3[3])
    end
  end
  if self.isTouching and localPos then
    LuaVector3.Better_Sub(localPos, centerV3, tempV3)
    if LuaVector3.Distance_Square(localPos, centerV3) > self.maxDis * self.maxDis then
      LuaVector3.Better_Mul(LuaVector3.Normalize(tempV3), self.maxDis, tempV3)
      LuaVector3.Better_Sub(tempV3, centerV3, localPos)
    end
    self.center.transform.localPosition = localPos
    local deltaAngleX = -tempV3[2] * rotateSpeed * deltaTime
    local deltaAngleY = tempV3[1] * rotateSpeed * deltaTime
    self.handleNodeTrans:Rotate(deltaAngleX, deltaAngleY, 0)
    local eulerAngles = LuaGeometry.TempGetLocalEulerAngles(self.handleNodeTrans)
    local angleX = self:_getAngle(eulerAngles.x)
    local angleY = self:_getAngle(eulerAngles.y)
    angleX = math.min(angleX, self.maxAngleX)
    angleY = math.min(angleY, self.maxAngleY)
    eulerAngles.x = math.max(angleX, self.minAngleX)
    eulerAngles.y = math.max(angleY, self.minAngleY)
    self.handleNodeTrans.localEulerAngles = eulerAngles
  end
end

function LightPuzzleHandleView:_getAngle(angle)
  if 180 < angle then
    angle = angle - 360
  end
  return angle
end
