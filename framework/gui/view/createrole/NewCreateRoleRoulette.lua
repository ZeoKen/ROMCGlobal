autoImport("EventDispatcher")
NewCreateRoleRoulette = class("NewCreateRoleRoulette", EventDispatcher)
NewCreateRoleRouletteEvent = {
  FirstInput = "NewCreateRoleRouletteEvent_FirstInput",
  StartSelect = "NewCreateRoleRouletteEvent_StartSelect",
  StopSelect = "NewCreateRoleRouletteEvent_StopSelect",
  Rotate = "NewCreateRoleRouletteEvent_Rotate"
}
local isRunOnEditor = ApplicationInfo.IsRunOnEditor()
local isRunOnStandalone = Application.platform == RuntimePlatform.WindowsPlayer or Application.platform == RuntimePlatform.OSXPlayer
local mouseKey = 0
local cycleQueue = {}
cycleQueue.maxRecordCnt = 5
cycleQueue.inputRecord = {}
cycleQueue.cycleLastIdx = 0

function cycleQueue:Enqueue(value)
  self.cycleLastIdx = self.cycleLastIdx % self.maxRecordCnt + 1
  self.inputRecord[self.cycleLastIdx] = value
end

function cycleQueue:ElementFromEnd(index)
  local idx = (self.cycleLastIdx + 1 - index) % self.maxRecordCnt
  if idx <= 0 then
    idx = idx + self.maxRecordCnt
  end
  return self.inputRecord[idx]
end

function cycleQueue:Clear()
  TableUtility.ArrayClear(self.inputRecord)
  self.cycleLastIdx = 0
end

function cycleQueue:Count()
  return #self.inputRecord
end

function cycleQueue:Init(count)
  self.Clear(self)
  self.maxRecordCnt = count
end

local no0sign = function(num)
  return 0 <= num and 1 or -1
end
local getFormalAngle = function(angle)
  angle = angle % 360
  if angle < 0 then
    angle = angle + 360
  end
  return angle
end
local getRightDeltaAngle = function(from, to, method)
  method = method or AngleCalculateMethod.Nearest
  from = getFormalAngle(from)
  to = getFormalAngle(to)
  if method == AngleCalculateMethod.Counterclockwise then
    return from > to and to + 360 - from or to - from
  elseif method == AngleCalculateMethod.Clockwise then
    return from > to and to - from or to - from - 360
  end
  local delta = to - from
  local abs_delta = math.abs(delta)
  if 180 < abs_delta then
    return -1 * no0sign(delta) * (360 - abs_delta)
  end
  return delta
end
local tempV2 = LuaVector2()
local tempV3 = LuaVector3()
local SetRotateAngle = function(trans, angle)
  LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalEulerAngles(trans))
  tempV3[3] = angle
  trans.localEulerAngles = tempV3
end
local MotionEnum = {
  None = 0,
  Drag = 1,
  Spin = 2,
  Force = 3
}
AngleCalculateMethod = {
  Nearest = 0,
  Clockwise = 1,
  Counterclockwise = 2
}

function NewCreateRoleRoulette:ctor(segments, rotateTrans, centerTrans, screenInputArea, keepMemberAngleUnchanged)
  self.segments = segments
  self.rotateTrans = rotateTrans
  self.centerTrans = centerTrans
  self.screenInputArea = screenInputArea
  self.keepMemberAngleUnchanged = keepMemberAngleUnchanged
  self.radius = 10
  self.followSpeedFactor = 1
  self.f5MotionDeltaFactor = 0.02
  self.f2MotionDeltaFactor = 0.1
  self.f1MotionDeltaFactor = 0.2
  self.spinBaseStartSpeed = 1
  self.spinMinAcceptSpeed = 0.001
  self.ceaseAccle = 0.5
  self.animCurves = self.rotateTrans:GetComponent(AnimationCurveHelper)
  self.forceMotionCurve = self.animCurves.curves[1]
  self.forceMotionBaseSpeed = 1
  self.segmentAngle = 360 / self.segments
  self.spinStopSpeed = math.sqrt(2 * math.abs(self.ceaseAccle) * self.segmentAngle)
  cycleQueue:Init(5)
end

NewCreateRoleRoulette.center = LuaVector2()
NewCreateRoleRoulette.screenInputAreaLB = LuaVector2()
NewCreateRoleRoulette.screenInputAreaRT = LuaVector2()

function NewCreateRoleRoulette:SetRotateAngle(angle)
  SetRotateAngle(self.rotateTrans, angle)
  if self.keepMemberAngleUnchanged then
    for i = 1, #self.members do
      SetRotateAngle(self.members[i].trans, -angle)
    end
  end
  local fAngle, member = getFormalAngle(angle)
  for i = 1, #self.members do
    member = self.members[i]
    if member.updateCb then
      member.updateCb(member, fAngle, member.angle, member.radius)
    end
  end
  self:PassEvent(NewCreateRoleRouletteEvent.Rotate, fAngle)
end

function NewCreateRoleRoulette:ChangeRotateAngle(angleDelta)
  local angle = self.rotateTrans.localEulerAngles.z + angleDelta
  SetRotateAngle(self.rotateTrans, angle)
  if self.keepMemberAngleUnchanged then
    for i = 1, #self.members do
      SetRotateAngle(self.members[i].trans, -angle)
    end
  end
  local fAngle, member = getFormalAngle(angle)
  for i = 1, #self.members do
    member = self.members[i]
    if member.updateCb then
      member.updateCb(member, fAngle, member.angle, member.radius)
    end
  end
  self:PassEvent(NewCreateRoleRouletteEvent.Rotate, fAngle)
  return angle
end

function NewCreateRoleRoulette:GetRotateAngle()
  return self.rotateTrans.localEulerAngles.z
end

function NewCreateRoleRoulette:SetToSegment(seg)
  self:SetRotateAngle(seg % self.segments * self.segmentAngle)
end

function NewCreateRoleRoulette:Enable()
  self:GenerateScreenPos()
  Game.GUISystemManager:AddMonoUpdateFunction(self.Update, self)
  self.firstInput = false
end

function NewCreateRoleRoulette:Disable()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
  self.firstInput = false
end

function NewCreateRoleRoulette:Destroy()
  TableUtility.ArrayClear(self.members)
end

function NewCreateRoleRoulette:Update()
  if FunctionNewCreateRole.Me().isFadeAnim then
    return
  end
  self:UpdateInput()
  self:UpdateMotion()
end

NewCreateRoleRoulette.members = {}

function NewCreateRoleRoulette:AddMember(memberObj, memberTrans, angle, radius, rotateCb)
  radius = radius or self.radius or 0
  memberTrans.gameObject.name = angle / self.segmentAngle
  memberTrans.parent = self.rotateTrans
  memberTrans.localScale = LuaVector3.One()
  memberTrans.localPosition = LuaGeometry.GetTempVector3(radius * math.cos(math.rad(angle)), radius * math.sin(math.rad(angle)), 0)
  memberTrans.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, -self:GetRotateAngle())
  table.insert(self.members, {
    obj = memberObj,
    trans = memberTrans,
    updateCb = rotateCb,
    angle = angle,
    radius = radius
  })
end

local currentInput = 0
local lastInput = 0
local hasInput, lastHasInput = false, false
local pressDownDeltaAngle = 0
local flag_DragMoved = false

function NewCreateRoleRoulette:UpdateInput()
  if self.curMotion == MotionEnum.Force then
    return
  end
  if self:CheckOverOtherUI() then
    return
  end
  if isRunOnStandalone or isRunOnEditor then
    self:UpdateMouseInput()
  else
    self:UpdateTouchInput()
  end
end

function NewCreateRoleRoulette:CheckOverOtherUI()
  if UICamera.isOverUI then
    if UICamera.currentTouch and UICamera.currentTouch.current and UICamera.currentTouch.current.name == "ReturnBtn" then
      return true
    end
    if UICamera.hoveredObject and UICamera.hoveredObject.name == "ReturnBtn" then
      return true
    end
  end
end

function NewCreateRoleRoulette:UpdateMouseInput()
  local x, y = LuaGameObject.GetMousePosition()
  if self:InInputArea(x, y) then
    if Input.GetMouseButtonDown(mouseKey) then
      self:ProcessInput(x, y)
    elseif Input.GetMouseButton(mouseKey) then
      self:ProcessInput(x, y)
    elseif Input.GetMouseButtonUp(mouseKey) then
      self:ProcessInput(x, y)
    else
      self:ProcessInput()
    end
  else
    self:ProcessInput()
  end
end

function NewCreateRoleRoulette:UpdateTouchInput()
  if Input.touchCount == 0 then
    self:ProcessInput()
    return
  end
  local x, y = LuaGameObject.GetTouchPosition(0, false)
  local touchPhase = Input.GetTouch(0).phase
  if self:InInputArea(x, y) then
    if touchPhase == TouchPhase.Began or touchPhase == TouchPhase.Moved or touchPhase == TouchPhase.Stationary or touchPhase == TouchPhase.Ended then
      self:ProcessInput(x, y)
    elseif touchPhase == TouchPhase.Canceled then
      self:ProcessInput()
    else
      self:ProcessInput()
    end
  else
    self:ProcessInput()
  end
end

function NewCreateRoleRoulette:ProcessInput(x, y)
  hasInput = x ~= nil
  if hasInput then
    if not self.firstInput then
      self.firstInput = true
      self:NotifyFirstInput()
    end
    lastInput = currentInput
    currentInput = self:GetAngleFromPos(x, y)
    cycleQueue:Enqueue(currentInput)
  end
  if hasInput and lastHasInput then
    self:Input_OnHold()
  elseif hasInput and not lastHasInput then
    self:Input_OnPressDown()
  elseif not hasInput and lastHasInput then
    self:Input_OnLetGo()
  end
  lastHasInput = hasInput
  if not hasInput then
    cycleQueue:Clear()
  end
end

function NewCreateRoleRoulette:ClearInput()
  flag_DragMoved = false
  currentInput = 0
  lastInput = 0
  hasInput = false
  lastHasInput = false
  cycleQueue:Clear()
end

function NewCreateRoleRoulette:NotifyFirstInput()
  self:PassEvent(NewCreateRoleRouletteEvent.FirstInput)
end

function NewCreateRoleRoulette:Input_OnHold()
  local targetAngle = pressDownDeltaAngle + currentInput
  if self:GetRotateAngle() ~= targetAngle then
    self:SetRotateAngle(targetAngle)
    flag_DragMoved = true
  end
end

function NewCreateRoleRoulette:Input_OnPressDown()
  self.spinSpeed = 0
  pressDownDeltaAngle = self:GetRotateAngle() - currentInput
  self.curMotion = MotionEnum.Drag
end

function NewCreateRoleRoulette:Input_OnLetGo()
  if self.curMotion == MotionEnum.Force then
    return
  end
  self.spinSpeed = self:CalculateSpinStartSpeed()
  if self.spinSpeed == 0 and not flag_DragMoved then
    return
  end
  flag_DragMoved = false
  self.ceaseAccle = -no0sign(self.spinSpeed) * math.abs(self.ceaseAccle)
  self.curMotion = MotionEnum.Spin
  self:PassEvent(NewCreateRoleRouletteEvent.StartSelect)
end

NewCreateRoleRoulette.curMotion = MotionEnum.None

function NewCreateRoleRoulette:UpdateMotion()
  if self.curMotion == MotionEnum.Force then
    self:UpdateForceMotion()
  elseif self.curMotion == MotionEnum.Spin then
    self:UpdateSpinMotion()
  end
end

NewCreateRoleRoulette.spinSpeed = 0

function NewCreateRoleRoulette:UpdateSpinMotion()
  local curAngle = self:ChangeRotateAngle(self.spinSpeed)
  self.spinSpeed = self.spinSpeed + self.ceaseAccle
  if math.abs(self.spinSpeed) < self.spinStopSpeed / 2 then
    local partAngle = math.abs(curAngle % self.segmentAngle)
    local targetAngle = no0sign(curAngle) * (curAngle - partAngle)
    if partAngle > self.segmentAngle / 2 then
      targetAngle = targetAngle + no0sign(curAngle) * self.segmentAngle
    end
    self:ForceMotionToAngle(targetAngle, AngleCalculateMethod.Nearest, 90)
  end
end

NewCreateRoleRoulette.forceMotionCurve = nil
NewCreateRoleRoulette.forceMotionBaseSpeed = 1
NewCreateRoleRoulette.forceMotionStartAngle = 0
NewCreateRoleRoulette.forceMotionDeltaAngle = 0
NewCreateRoleRoulette.forceMotionTime = 0
NewCreateRoleRoulette.curForceMotionTime = 0

function NewCreateRoleRoulette:ForceMotionToSegment(seg, rotateMethod, baseSpeed)
  self:ForceMotionToAngle((seg - 1) % self.segments * self.segmentAngle, rotateMethod, baseSpeed)
end

function NewCreateRoleRoulette:ForceMotionToAngle(angle, rotateMethod, baseSpeed)
  local curAngle = self:GetRotateAngle()
  self.forceMotionStartAngle = getFormalAngle(curAngle)
  self.forceMotionDeltaAngle = getRightDeltaAngle(curAngle, angle, rotateMethod)
  baseSpeed = 0 < baseSpeed and baseSpeed or self.forceMotionBaseSpeed
  self.forceMotionTime = math.abs(self.forceMotionDeltaAngle / baseSpeed)
  self.curForceMotionTime = 0
  self.curMotion = MotionEnum.Force
  self:ClearInput()
end

function NewCreateRoleRoulette:ForceMotionToMakeSegmentAngleZero(seg, rotateMethod, baseSpeed)
  if self.curMotion == MotionEnum.Force then
    return false
  end
  local toAngle = (seg - 1) % self.segments * self.segmentAngle * -1
  self:ForceMotionToAngle(toAngle, rotateMethod, baseSpeed)
  return true
end

function NewCreateRoleRoulette:UpdateForceMotion()
  self.curForceMotionTime = self.curForceMotionTime + Time.deltaTime
  local curEv = math.clamp(self.curForceMotionTime / self.forceMotionTime, 0, 1)
  local angle = self.forceMotionStartAngle + self.forceMotionDeltaAngle * self.forceMotionCurve:Evaluate(curEv)
  self:SetRotateAngle(angle)
  if 1 <= curEv then
    self.curMotion = MotionEnum.None
    self:PassEvent(NewCreateRoleRouletteEvent.StopSelect, math.floor(getFormalAngle(-angle + 0.5) / self.segmentAngle))
  end
end

function NewCreateRoleRoulette:InInputArea(x, y)
  return x > self.screenInputAreaLB.x and x < self.screenInputAreaRT.x and y > self.screenInputAreaLB.y and y < self.screenInputAreaRT.y
end

local luaVector2Right = LuaVector2.Right()
local math_deg = math.deg

function NewCreateRoleRoulette:GetAngleFromPos(x, y)
  LuaVector2.Better_Set(tempV2, x, y)
  LuaVector2.Better_Sub(tempV2, self.center, tempV2)
  local raw_angle = LuaVector2.Angle(tempV2, luaVector2Right)
  return tempV2[2] > 0 and raw_angle or 360 - raw_angle
end

function NewCreateRoleRoulette:GenerateScreenPos()
  local uiCam = NGUIUtil:GetCameraByLayername("UI")
  LuaVector2.Better_Set(self.center, LuaGameObject.WorldToScreenPointByTransform(uiCam, self.centerTrans, Space.World))
  LuaVector2.Better_Set(self.screenInputAreaLB, LuaGameObject.WorldToScreenPointByVector3(uiCam, self.screenInputArea.worldCorners[1]))
  LuaVector2.Better_Set(self.screenInputAreaRT, LuaGameObject.WorldToScreenPointByVector3(uiCam, self.screenInputArea.worldCorners[3]))
end

function NewCreateRoleRoulette:CalculateSpinStartSpeed()
  local recordLen = cycleQueue:Count()
  if recordLen <= 1 then
    return 0
  end
  local speedFactor = 0
  if 1 < recordLen then
    speedFactor = speedFactor + getRightDeltaAngle(cycleQueue:ElementFromEnd(2), cycleQueue:ElementFromEnd(1)) * self.f1MotionDeltaFactor
  end
  local extraFactor = 0
  if 2 < recordLen then
    extraFactor = extraFactor + getRightDeltaAngle(cycleQueue:ElementFromEnd(3), cycleQueue:ElementFromEnd(1)) * self.f2MotionDeltaFactor
  end
  if 4 < recordLen then
    extraFactor = extraFactor + getRightDeltaAngle(cycleQueue:ElementFromEnd(5), cycleQueue:ElementFromEnd(1)) * self.f5MotionDeltaFactor
  end
  if 0 <= extraFactor * speedFactor then
    speedFactor = speedFactor + extraFactor
  end
  local speed = speedFactor * self.spinBaseStartSpeed
  return math.abs(speed) > self.spinMinAcceptSpeed and speed or 0
end

function NewCreateRoleRoulette:CreateFakeCircleShow(showAngleMin, showAngleMax)
  if #self.members == self.segments then
    redlog("no need to create fake circle")
    return
  end
  if self.segments < 3 then
  end
end
