autoImport("SnakeCoasterManager")
autoImport("AreaTrigger_Common")
autoImport("SceneTriggerProxy")
Creature_SnakeCoaster = class("Creature_SnakeCoaster")
local SnakeCoasterDirEpsilon = 1.0E-4
local SnakeCoasterCameraLockTargetName = "SnakeCoasterCameraLockTarget"
local SnakeCoasterCameraBackTraceFocusName = "SnakeCoasterCameraBackTraceFocus"
local LayerChangeReasonInteractNpc = LayerChangeReason.InteractNpc
local PUIVisibleReasonInteractNpc = PUIVisibleReason.InteractNpc
local SnakeCoasterCameraFov = 55
local SnakeCoasterTwoPI = math.pi * 2
local SnakeCoasterNormalizeAnglePositive = function(angle)
  angle = angle % SnakeCoasterTwoPI
  if angle < 0 then
    angle = angle + SnakeCoasterTwoPI
  end
  return angle
end
local SnakeCoasterDeltaAngleCCW = function(fromAngle, toAngle)
  return SnakeCoasterNormalizeAnglePositive(toAngle - fromAngle)
end

function Creature_SnakeCoaster:ctor(owner)
  self.owner = owner
  self.tempPos = LuaVector3.Zero()
  self.tempDir = LuaVector3.Zero()
  self.rotateDir = LuaVector3.Zero()
  self.roadPoints = nil
  self.roadPointDefs = nil
  self.pathSegments = nil
  self.segmentForwardDir = LuaVector3.Zero()
  self.segmentLateralDir = LuaVector3.Zero()
  self.segmentLength = 0
  self.currentSegment = -1
  self.segmentProgress = 0
  self.lateralOffset = 0
  self.dirMoveStarted = false
  self.userInputX = 0
  self.cameraLockTarget = nil
  self.cameraBackTraceFocus = nil
  self.cameraLockTargetBound = false
  self.coasterNpc = nil
  self.coasterNpcBound = false
  self.coasterID = nil
  self.coasterCheckPointStates = nil
  self.coasterCheckPointTriggerIDs = nil
  self.pendingCheckPointActionType = nil
  self.pendingCheckPointInfo = nil
  self.score = 0
  self.currentActionId = 0
  self.getOffFlag = false
  self.laneHalfWidth = 3
  self.lateralSpeed = 3
  self.startDelayRemain = 0
  self.cameraBackTraceDistance = 8
  self.cameraBackTracePitch = 30
  self.cameraBackTraceFollowLerpTime = 0.08
  self.cameraBackTraceSwitchDuration = 0.08
  self.cameraBackTraceFocusDistance = 8
  self.cameraBackTraceFocusHeight = 1
  self.cameraLookUpHeight = 0
  self.cameraLockTargetViewport = LuaVector3.New(0.5, 0.7, 0)
  self.moveSpeed = 0
  self.defaultNormalScore = 1
  self.defaultPerfectScore = 1
  self.active = false
  self.speed = 0
  self.finishTriggered = false
  self.isShutdown = false
  self.tempCubeList = {}
end

function Creature_SnakeCoaster:Reset()
  self.active = false
  self.speed = 0
  self.finishTriggered = false
  self.isShutdown = false
  self.startDelayRemain = 0
  self:_StopDirMove()
  if self.owner ~= nil and self.owner.Logic_StopMove ~= nil then
    self.owner:Logic_StopMove()
  end
  self:_ClearRoadPoints()
  LuaVector3.Better_Set(self.segmentForwardDir, 0, 0, 0)
  LuaVector3.Better_Set(self.segmentLateralDir, 0, 0, 0)
  self.segmentLength = 0
  self.currentSegment = -1
  self.segmentProgress = 0
  self.lateralOffset = 0
  self.userInputX = 0
  self.cameraBackTraceFocus = nil
  self.coasterID = nil
  self.score = 0
  self.currentActionId = 0
  self.getOffFlag = false
  self.moveSpeed = 0
  self:_ClearCheckPoints()
  self:_UnbindOwnerFromCoasterNpc()
  self:_DestroyLocalCoasterNpc()
  self:_ClearCameraLockTarget()
end

function Creature_SnakeCoaster:_ClearRoadPoints()
  if self.roadPoints ~= nil then
    for i = 1, #self.roadPoints do
      self.roadPoints[i] = LuaVector3.Destroy(self.roadPoints[i])
    end
    self.roadPoints = nil
  end
  self.roadPointDefs = nil
  self.pathSegments = nil
end

function Creature_SnakeCoaster:_GetMoveHost()
  if self.coasterNpc ~= nil then
    return self.coasterNpc
  end
  return self.owner
end

function Creature_SnakeCoaster:_GetMoveHostPosition()
  if self.coasterNpc ~= nil and self.coasterNpc.logicTransform ~= nil then
    return self.coasterNpc.logicTransform.currentPosition
  end
  local cp = self:_GetCoasterNpcAttachPoint()
  return cp and cp.position or nil
end

function Creature_SnakeCoaster:_BuildLineSegment(startIndex, endIndex)
  local pA = self.roadPoints and self.roadPoints[startIndex]
  local pB = self.roadPoints and self.roadPoints[endIndex]
  if pA == nil or pB == nil then
    return nil
  end
  local dx = pB[1] - pA[1]
  local dz = pB[3] - pA[3]
  local len = math.sqrt(dx * dx + dz * dz)
  return {
    kind = "line",
    startIndex = startIndex,
    endIndex = endIndex,
    length = len
  }
end

function Creature_SnakeCoaster:_BuildArcSegment(startIndex, midIndex, endIndex)
  local pA = self.roadPoints and self.roadPoints[startIndex]
  local pM = self.roadPoints and self.roadPoints[midIndex]
  local pB = self.roadPoints and self.roadPoints[endIndex]
  if pA == nil or pM == nil or pB == nil then
    return nil
  end
  local ax, az = pA[1], pA[3]
  local mx, mz = pM[1], pM[3]
  local bx, bz = pB[1], pB[3]
  local determinant = 2 * (ax * (mz - bz) + mx * (bz - az) + bx * (az - mz))
  if math.abs(determinant) <= SnakeCoasterDirEpsilon then
    return nil
  end
  local aSq = ax * ax + az * az
  local mSq = mx * mx + mz * mz
  local bSq = bx * bx + bz * bz
  local centerX = (aSq * (mz - bz) + mSq * (bz - az) + bSq * (az - mz)) / determinant
  local centerZ = (aSq * (bx - mx) + mSq * (ax - bx) + bSq * (mx - ax)) / determinant
  local radiusX = ax - centerX
  local radiusZ = az - centerZ
  local radius = math.sqrt(radiusX * radiusX + radiusZ * radiusZ)
  if radius <= SnakeCoasterDirEpsilon then
    return nil
  end
  local startAngle = math.atan2(az - centerZ, ax - centerX)
  local midAngle = math.atan2(mz - centerZ, mx - centerX)
  local endAngle = math.atan2(bz - centerZ, bx - centerX)
  local sweepCCW = SnakeCoasterDeltaAngleCCW(startAngle, endAngle)
  local midCCW = SnakeCoasterDeltaAngleCCW(startAngle, midAngle)
  local sweepAngle, progressMid
  if sweepCCW > SnakeCoasterDirEpsilon and midCCW > SnakeCoasterDirEpsilon and midCCW < sweepCCW - SnakeCoasterDirEpsilon then
    sweepAngle = sweepCCW
    progressMid = midCCW / sweepCCW
  else
    local sweepCW = SnakeCoasterDeltaAngleCCW(endAngle, startAngle)
    local midCW = SnakeCoasterDeltaAngleCCW(midAngle, startAngle)
    if sweepCW <= SnakeCoasterDirEpsilon or midCW <= SnakeCoasterDirEpsilon or midCW >= sweepCW - SnakeCoasterDirEpsilon then
      return nil
    end
    sweepAngle = -sweepCW
    progressMid = midCW / sweepCW
  end
  local length = radius * math.abs(sweepAngle)
  return {
    kind = "arc",
    startIndex = startIndex,
    midIndex = midIndex,
    endIndex = endIndex,
    centerX = centerX,
    centerZ = centerZ,
    radius = radius,
    startAngle = startAngle,
    sweepAngle = sweepAngle,
    progressMid = progressMid,
    length = length
  }
end

function Creature_SnakeCoaster:_BuildPathSegments()
  local segments = {}
  if self.roadPoints == nil or self.roadPointDefs == nil then
    return segments
  end
  local i = 1
  local count = #self.roadPoints
  while i < count do
    local nextDef = self.roadPointDefs[i + 1]
    if count >= i + 2 and nextDef ~= nil and nextDef.CirclePoint == 1 then
      local arcSegment = self:_BuildArcSegment(i, i + 1, i + 2)
      if arcSegment ~= nil and arcSegment.length > SnakeCoasterDirEpsilon then
        segments[#segments + 1] = arcSegment
        i = i + 2
      else
        local lineSegment = self:_BuildLineSegment(i, i + 1)
        if lineSegment ~= nil then
          segments[#segments + 1] = lineSegment
        end
        i = i + 1
      end
    else
      local lineSegment = self:_BuildLineSegment(i, i + 1)
      if lineSegment ~= nil then
        segments[#segments + 1] = lineSegment
      end
      i = i + 1
    end
  end
  return segments
end

function Creature_SnakeCoaster:_GetCurrentSegmentData()
  if self.pathSegments == nil then
    return nil
  end
  return self.pathSegments[self.currentSegment]
end

function Creature_SnakeCoaster:_GetArcProgressByAngle(segment, angle)
  if segment == nil or segment.kind ~= "arc" then
    return nil
  end
  if segment.sweepAngle > 0 then
    return SnakeCoasterDeltaAngleCCW(segment.startAngle, angle) / segment.sweepAngle
  end
  return SnakeCoasterDeltaAngleCCW(angle, segment.startAngle) / -segment.sweepAngle
end

function Creature_SnakeCoaster:_GetArcY(segment, t)
  local pA = self.roadPoints and self.roadPoints[segment.startIndex]
  local pM = self.roadPoints and self.roadPoints[segment.midIndex]
  local pB = self.roadPoints and self.roadPoints[segment.endIndex]
  if pA == nil or pM == nil or pB == nil then
    return 0
  end
  local midT = segment.progressMid or 0.5
  if midT <= SnakeCoasterDirEpsilon or midT >= 1 - SnakeCoasterDirEpsilon then
    return pA[2] + (pB[2] - pA[2]) * t
  end
  local yA, yM, yB = pA[2], pM[2], pB[2]
  local wA = (t - midT) * (t - 1) / ((0 - midT) * -1)
  local wM = (t - 0) * (t - 1) / ((midT - 0) * (midT - 1))
  local wB = (t - 0) * (t - midT) / (1 * (1 - midT))
  return yA * wA + yM * wM + yB * wB
end

function Creature_SnakeCoaster:_GetSegmentPointBySegment(segment, t)
  if segment == nil then
    return nil
  end
  if t == nil then
    t = self.segmentProgress
  end
  if t < 0 then
    t = 0
  elseif 1 < t then
    t = 1
  end
  if segment.kind == "arc" then
    local angle = segment.startAngle + segment.sweepAngle * t
    local posX = segment.centerX + math.cos(angle) * segment.radius
    local posY = self:_GetArcY(segment, t)
    local posZ = segment.centerZ + math.sin(angle) * segment.radius
    return posX, posY, posZ
  end
  local pA = self.roadPoints and self.roadPoints[segment.startIndex]
  local pB = self.roadPoints and self.roadPoints[segment.endIndex]
  if pA == nil or pB == nil then
    return nil
  end
  local posX = pA[1] + (pB[1] - pA[1]) * t
  local posY = pA[2] + (pB[2] - pA[2]) * t
  local posZ = pA[3] + (pB[3] - pA[3]) * t
  return posX, posY, posZ
end

function Creature_SnakeCoaster:_GetSegmentForwardBySegment(segment, t)
  if segment == nil then
    return nil
  end
  if t == nil then
    t = self.segmentProgress
  end
  if t < 0 then
    t = 0
  elseif 1 < t then
    t = 1
  end
  if segment.kind == "arc" then
    local angle = segment.startAngle + segment.sweepAngle * t
    local sinValue = math.sin(angle)
    local cosValue = math.cos(angle)
    if 0 < segment.sweepAngle then
      return -sinValue, cosValue
    end
    return sinValue, -cosValue
  end
  local pA = self.roadPoints and self.roadPoints[segment.startIndex]
  local pB = self.roadPoints and self.roadPoints[segment.endIndex]
  if pA == nil or pB == nil then
    return nil
  end
  local dx = pB[1] - pA[1]
  local dz = pB[3] - pA[3]
  local len = math.sqrt(dx * dx + dz * dz)
  if len <= SnakeCoasterDirEpsilon then
    return nil
  end
  return dx / len, dz / len
end

function Creature_SnakeCoaster:_EnsureCurrentSegment()
  if self.pathSegments == nil then
    return false
  end
  while self.currentSegment <= #self.pathSegments do
    self:_UpdateSegmentVectors()
    if self.segmentLength > SnakeCoasterDirEpsilon then
      return true
    end
    if self.currentSegment >= #self.pathSegments then
      break
    end
    self.currentSegment = self.currentSegment + 1
    self.segmentProgress = 0
  end
  return false
end

function Creature_SnakeCoaster:_GetCurrentMoveDir()
  if not self.active then
    return nil
  end
  if not SnakeCoasterManager.Me():IsServerGameRunning() or SnakeCoasterManager.Me().finishSubmitted then
    return nil
  end
  if not self:_EnsureCurrentSegment() then
    return nil
  end
  local projectedT = self:_ProjectCurrentPositionOnSegment()
  if projectedT ~= nil then
    self.segmentProgress = projectedT
  end
  self:_UpdateSegmentVectors(self.segmentProgress)
  return self.segmentForwardDir
end

function Creature_SnakeCoaster:GetCurrentMoveDir()
  return self:_GetCurrentMoveDir()
end

function Creature_SnakeCoaster:_StartDirMove(customMoveActionName)
  if self.dirMoveStarted then
    return true
  end
  local coasterNpc = self.coasterNpc
  if coasterNpc == nil or coasterNpc.Client_CoasterMove == nil or not self.active then
    return false
  end
  coasterNpc:Client_CoasterMove(self, false, customMoveActionName)
  self.dirMoveStarted = true
  if SnakeCoasterManager.Me():IsServerGameRunning() and self.currentSegment < 1 then
    self.currentSegment = 1
  end
  return true
end

function Creature_SnakeCoaster:_StopDirMove()
  if not self.dirMoveStarted then
    return
  end
  self.dirMoveStarted = false
  local coasterNpc = self.coasterNpc
  if coasterNpc ~= nil and coasterNpc.Client_CoasterMoveEnd ~= nil then
    coasterNpc:Client_CoasterMoveEnd()
  end
end

function Creature_SnakeCoaster:_ProjectCurrentPositionOnSegment()
  local segment = self:_GetCurrentSegmentData()
  if segment == nil then
    return nil
  end
  local moveHostPos = self:_GetMoveHostPosition()
  if moveHostPos == nil then
    return nil
  end
  if segment.kind == "arc" then
    local dx = (moveHostPos[1] or 0) - segment.centerX
    local dz = (moveHostPos[3] or 0) - segment.centerZ
    local angle
    if dx * dx + dz * dz <= SnakeCoasterDirEpsilon then
      angle = segment.startAngle + segment.sweepAngle * (self.segmentProgress or 0)
    else
      angle = math.atan2(dz, dx)
    end
    local t = self:_GetArcProgressByAngle(segment, angle)
    if t == nil then
      return nil
    end
    if t < 0 then
      t = 0
    elseif 1 < t then
      t = 1
    end
    local posX, posY, posZ = self:_GetSegmentPointBySegment(segment, t)
    return t, posX, posY, posZ, moveHostPos
  end
  local pA = self.roadPoints and self.roadPoints[segment.startIndex]
  local pB = self.roadPoints and self.roadPoints[segment.endIndex]
  if pA == nil or pB == nil then
    return nil
  end
  local segX = pB[1] - pA[1]
  local segZ = pB[3] - pA[3]
  local segLenSq = segX * segX + segZ * segZ
  if segLenSq <= SnakeCoasterDirEpsilon then
    return nil
  end
  local moveHostX = moveHostPos[1] or 0
  local moveHostZ = moveHostPos[3] or 0
  local t = ((moveHostX - pA[1]) * segX + (moveHostZ - pA[3]) * segZ) / segLenSq
  if t < 0 then
    t = 0
  elseif 1 < t then
    t = 1
  end
  local posX = pA[1] + segX * t
  local posY = pA[2] + (pB[2] - pA[2]) * t
  local posZ = pA[3] + segZ * t
  return t, posX, posY, posZ, moveHostPos
end

function Creature_SnakeCoaster:_GetCurrentSegmentPoint(t)
  return self:_GetSegmentPointBySegment(self:_GetCurrentSegmentData(), t)
end

function Creature_SnakeCoaster:_ApplyLateralOffsetToMoveHost(posX, posY, posZ)
  local moveHost = self:_GetMoveHost()
  if moveHost == nil or moveHost.logicTransform == nil then
    return false
  end
  local logicTransform = moveHost.logicTransform
  local currentPosition = logicTransform.currentPosition
  if currentPosition == nil then
    return false
  end
  local offsetX = posX + self.segmentLateralDir[1] * self.lateralOffset
  local offsetZ = posZ + self.segmentLateralDir[3] * self.lateralOffset
  local deltaX = offsetX - currentPosition[1]
  local deltaY = posY - currentPosition[2]
  local deltaZ = offsetZ - currentPosition[3]
  if math.abs(deltaX) <= SnakeCoasterDirEpsilon and math.abs(deltaY) <= SnakeCoasterDirEpsilon and math.abs(deltaZ) <= SnakeCoasterDirEpsilon then
    return true
  end
  LuaVector3.Better_Set(currentPosition, offsetX, posY, offsetZ)
  if logicTransform.position ~= nil and logicTransform.position ~= currentPosition then
    logicTransform.position[1] = logicTransform.position[1] + deltaX
    logicTransform.position[2] = logicTransform.position[2] + deltaY
    logicTransform.position[3] = logicTransform.position[3] + deltaZ
  end
  if logicTransform.targetPosition ~= nil then
    logicTransform.targetPosition[1] = logicTransform.targetPosition[1] + deltaX
    logicTransform.targetPosition[2] = logicTransform.targetPosition[2] + deltaY
    logicTransform.targetPosition[3] = logicTransform.targetPosition[3] + deltaZ
  end
  return true
end

function Creature_SnakeCoaster:Launch(levelData)
  if levelData == nil or levelData.roadPoints == nil then
    self:_ClearCheckPoints()
    return false
  end
  self.coasterID = levelData.coasterID
  local sortedPoints = {}
  for i = 1, #levelData.roadPoints do
    sortedPoints[#sortedPoints + 1] = levelData.roadPoints[i]
  end
  table.sort(sortedPoints, function(a, b)
    return (a.ID or 0) < (b.ID or 0)
  end)
  if #sortedPoints < 2 then
    self:_ClearCheckPoints()
    return false
  end
  self:_ClearRoadPoints()
  self.roadPointDefs = sortedPoints
  self.roadPoints = {}
  for i = 1, #sortedPoints do
    local p = sortedPoints[i].position
    self.roadPoints[i] = LuaVector3.New(p[1] or 0, p[2] or 0, p[3] or 0)
  end
  self.pathSegments = self:_BuildPathSegments()
  if self.pathSegments == nil or 0 >= #self.pathSegments then
    self:_ClearRoadPoints()
    return false
  end
  self.laneHalfWidth = levelData.laneHalfWidth or 3
  self.lateralSpeed = levelData.lateralSpeed or 3
  self.startDelayRemain = levelData.startDelay or 0
  self.moveSpeed = levelData.moveSpeed or 3
  self.defaultNormalScore = levelData.normalScore or 0
  self.defaultPerfectScore = levelData.perfectScore or 0
  self.cameraBackTraceDistance = levelData.cameraBackTraceDistance or 8
  self.cameraBackTracePitch = levelData.cameraBackTracePitch or 30
  self.cameraBackTraceFollowLerpTime = levelData.cameraBackTraceFollowLerpTime or 0.08
  self.cameraBackTraceSwitchDuration = levelData.cameraBackTraceSwitchDuration or 0.08
  self.cameraBackTraceFocusDistance = levelData.cameraBackTraceFocusDistance or 5
  self.cameraBackTraceFocusHeight = levelData.cameraBackTraceFocusHeight or 1
  self.cameraLookUpHeight = levelData.cameraLookUpHeight or 0
  if levelData.cameraViewportX ~= nil or levelData.cameraViewportY ~= nil then
    self.cameraLockTargetViewport = LuaVector3.New(levelData.cameraViewportX or 0.5, levelData.cameraViewportY or 0.7, 0)
  end
  self.currentSegment = 1
  self.segmentProgress = 0
  self.lateralOffset = 0
  self.userInputX = 0
  self.dirMoveStarted = false
  self.speed = 0
  self.score = 0
  self.currentActionId = 0
  self:_ClearCameraLockTarget()
  self:_ClearCheckPoints()
  self:_UnbindOwnerFromCoasterNpc()
  self:_DestroyLocalCoasterNpc()
  if not self:_EnsureCurrentSegment() then
    return false
  end
  if self:_CreateLocalCoasterNpc(levelData.coasterNpcID) == nil then
    self:Reset()
    return false
  end
  self:_BuildCheckPoints()
  local owner = self.owner
  local coasterNpc = self.coasterNpc
  if coasterNpc ~= nil and coasterNpc.logicTransform ~= nil then
    LuaVector3.Better_Set(self.tempPos, self.roadPoints[1][1], self.roadPoints[1][2], self.roadPoints[1][3])
    if coasterNpc.Logic_StopMove ~= nil then
      coasterNpc:Logic_StopMove()
    end
    if coasterNpc.logicTransform.PlaceTo ~= nil then
      coasterNpc.logicTransform:PlaceTo(self.tempPos)
    end
    if coasterNpc.logicTransform.RotateTo ~= nil and self.segmentLength > SnakeCoasterDirEpsilon then
      LuaVector3.Better_Add(self.tempPos, self.segmentForwardDir, self.rotateDir)
      coasterNpc.logicTransform:RotateTo(self.rotateDir)
    end
  end
  if owner ~= nil and owner.logicTransform ~= nil then
    if owner.Logic_StopMove ~= nil then
      owner:Logic_StopMove()
    end
    if owner.logicTransform.StopRotation ~= nil then
      owner.logicTransform:StopRotation()
    end
  end
  self:_SyncCoasterNpcMoveSpeed()
  self.getOffFlag = false
  self:_TryGetOffMount()
  self:_TryBindOwnerToCoasterNpc()
  if Game.InputManager ~= nil then
    Game.InputManager.disableFreeCamera = true
  end
  if Game.CameraPointManager ~= nil then
    Game.CameraPointManager.PlotValid = true
  end
  self.active = true
  self.isShutdown = false
  EventManager.Me():RemoveEventListener(MyselfEvent.OnFreeCameraRestoreDefault, self.OnFreeCameraRestoreDefault, self)
  EventManager.Me():AddEventListener(MyselfEvent.OnFreeCameraRestoreDefault, self.OnFreeCameraRestoreDefault, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.PlayerMapChange, self.OnLeaveScene, self)
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.OnLeaveScene, self)
  self:_SyncCameraState(true)
  GameFacade.Instance:sendNotification(SnakeCoasterEvent.StartCoaster, {
    coasterID = self.coasterID
  })
  if 0 >= self.startDelayRemain and self.coasterNpcBound then
    self:_StartDirMove()
  end
  return true
end

function Creature_SnakeCoaster:Shutdown()
  if self.isShutdown then
    return
  end
  self.isShutdown = true
  self:_StopDirMove()
  self.active = false
  EventManager.Me():RemoveEventListener(MyselfEvent.OnFreeCameraRestoreDefault, self.OnFreeCameraRestoreDefault, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.PlayerMapChange, self.OnLeaveScene, self)
  if Game.InputManager ~= nil then
    Game.InputManager.disableFreeCamera = false
  end
  if Game.CameraPointManager ~= nil then
    Game.CameraPointManager.PlotValid = false
  end
  local cameraController = CameraController.singletonInstance
  if cameraController ~= nil then
    cameraController:ForceResetLockTargetStatus()
    cameraController:SetResumeLockTarget()
    cameraController.lockTargetViewport = LuaGeometry.GetTempVector2(0.5, 0.7)
  end
  local mapManager = Game.MapManager
  if mapManager ~= nil then
    mapManager:UpdateCameraInstance(cameraController)
  end
  self:_UnbindOwnerFromCoasterNpc()
  self:_DestroyLocalCoasterNpc()
  self:_ClearCameraLockTarget()
  self:_ClearRoadPoints()
  self:_ClearCheckPoints()
  self.speed = 0
  self.startDelayRemain = 0
  self.userInputX = 0
  self.lateralOffset = 0
  self.dirMoveStarted = false
  self.currentSegment = 1
  self.segmentProgress = 0
  self.score = 0
  self.currentActionId = 0
  self.getOffFlag = false
  self.moveSpeed = 0
  GameFacade.Instance:sendNotification(SnakeCoasterEvent.EndCoaster, {
    coasterID = self.coasterID
  })
  self.coasterID = nil
end

function Creature_SnakeCoaster:IsRunning()
  return self.active
end

function Creature_SnakeCoaster:HandleReconnect()
  if self.active then
    self:Shutdown()
  end
end

function Creature_SnakeCoaster:OnLeaveScene()
  if self.active then
    self:Shutdown()
  end
end

function Creature_SnakeCoaster:IsMyself()
  return self.owner ~= nil and self.owner == Game.Myself
end

function Creature_SnakeCoaster:GetScore()
  return self.score
end

function Creature_SnakeCoaster:GetCurrentActionId()
  return self.currentActionId or 0
end

function Creature_SnakeCoaster:SetCurrentActionId(actionId, animationId)
  self.currentActionId = math.max(0, actionId or 0)
  ServiceSceneUser3Proxy.Instance:CallSnakeCoasterActionNtf(animationId or 0)
  return self.currentActionId
end

function Creature_SnakeCoaster:_AddScore(scoreDelta, isPerfect, checkPointState)
  self.score = self.score + scoreDelta
  GameFacade.Instance:sendNotification(SnakeCoasterEvent.ScoreUpdate, {
    coasterID = self.coasterID,
    score = self.score,
    delta = scoreDelta,
    isPerfect = isPerfect and true or false,
    actionId = self.currentActionId or 0,
    actionType = checkPointState and checkPointState.actionType or nil
  })
end

function Creature_SnakeCoaster:_ClearCameraLockTarget()
  if self.cameraLockTarget ~= nil then
    LuaGameObject.DestroyGameObject(self.cameraLockTarget)
    self.cameraLockTarget = nil
  end
  if self.cameraBackTraceFocus ~= nil then
    LuaGameObject.DestroyGameObject(self.cameraBackTraceFocus)
    self.cameraBackTraceFocus = nil
  end
  self.cameraLockTargetBound = false
end

function Creature_SnakeCoaster:_CreateLocalCoasterNpc(coasterNpcID)
  local snakeCoasterManager = SnakeCoasterManager.Me()
  if snakeCoasterManager == nil or self.roadPoints == nil then
    return nil
  end
  local angleY
  local segment = self:_GetCurrentSegmentData()
  local forwardX, forwardZ = self:_GetSegmentForwardBySegment(segment, 0)
  if forwardX ~= nil and forwardZ ~= nil then
    LuaVector3.Better_Set(self.tempDir, self.roadPoints[1][1] + forwardX, self.roadPoints[1][2], self.roadPoints[1][3] + forwardZ)
    angleY = VectorHelper.GetAngleByAxisY(self.roadPoints[1], self.tempDir)
  end
  self.coasterNpc = snakeCoasterManager:CreateLocalCoasterNpc(self.coasterID, coasterNpcID, self.roadPoints[1], angleY)
  return self.coasterNpc
end

function Creature_SnakeCoaster:_DestroyLocalCoasterNpc()
  local snakeCoasterManager = SnakeCoasterManager.Me()
  if self.coasterNpc ~= nil or snakeCoasterManager ~= nil and snakeCoasterManager:GetLocalCoasterNpc() ~= nil then
    snakeCoasterManager:DestroyLocalCoasterNpc()
  end
  self.coasterNpc = nil
  self.coasterNpcBound = false
end

function Creature_SnakeCoaster:_GetCoasterNpcAttachPoint()
  if self.coasterNpc == nil then
    return nil
  end
  return self.coasterNpc.assetRole:GetCP(0)
end

function Creature_SnakeCoaster:_TryGetOffMount()
  local roleEquip = BagProxy.Instance and BagProxy.Instance.roleEquip or nil
  local mount = roleEquip and roleEquip:GetMount() or nil
  if mount ~= nil then
    FunctionItemFunc.OffEquip_Equip(mount)
    self.getOffFlag = true
  end
end

function Creature_SnakeCoaster:_CheckGetOffFlag()
  if self.getOffFlag then
    local roleEquip = BagProxy.Instance and BagProxy.Instance.roleEquip or nil
    local mount = roleEquip and roleEquip:GetMount() or nil
    if mount ~= nil then
      return self.getOffFlag
    end
    local owner = self.owner
    local assetRole = owner and owner.assetRole or nil
    if assetRole == nil or assetRole.rideAction then
      return self.getOffFlag
    end
    self.getOffFlag = false
  end
  return self.getOffFlag
end

function Creature_SnakeCoaster:_TryBindOwnerToCoasterNpc()
  if self.coasterNpcBound then
    return true
  end
  if self:_CheckGetOffFlag() then
    return false
  end
  local owner = self.owner
  if owner == nil then
    return false
  end
  local cpTransform = self:_GetCoasterNpcAttachPoint()
  if cpTransform == nil then
    return false
  end
  owner:Logic_StopMove()
  owner:SetParent(cpTransform)
  owner:Logic_SetAngleY(0, true)
  owner:Logic_LockRotation(true)
  owner:Logic_PlayAction_Simple("ride_wait", "wait")
  owner.logicTransform:SetScaleXYZ(1, 1, 1)
  local assetRole = owner.assetRole
  if assetRole ~= nil then
    if assetRole.SetShadowEnable ~= nil then
      assetRole:SetShadowEnable(false)
    end
    if assetRole.SetMountDisplay ~= nil then
      assetRole:SetMountDisplay(false)
    end
    if assetRole.SetWingDisplay ~= nil then
      assetRole:SetWingDisplay(false)
    end
    if assetRole.SetTailDisplay ~= nil then
      assetRole:SetTailDisplay(false)
    end
  end
  owner:SetPeakEffectVisible(false, LayerChangeReasonInteractNpc)
  local functionPlayerUI = FunctionPlayerUI.Me()
  if functionPlayerUI ~= nil then
    functionPlayerUI:MaskBloodBar(owner, PUIVisibleReasonInteractNpc)
    functionPlayerUI:MaskNameHonorFactionType(owner, PUIVisibleReasonInteractNpc)
  end
  local partner = owner.partner
  if partner ~= nil then
    partner:SetVisible(false, LayerChangeReasonInteractNpc)
  end
  self.coasterNpcBound = true
  return true
end

function Creature_SnakeCoaster:_UnbindOwnerFromCoasterNpc()
  if not self.coasterNpcBound then
    return
  end
  local owner = self.owner
  self.coasterNpcBound = false
  if owner == nil then
    return
  end
  local ownerPos = owner:GetPosition()
  if ownerPos ~= nil then
    LuaVector3.Better_Set(self.tempPos, ownerPos[1] or 0, ownerPos[2] or 0, ownerPos[3] or 0)
  end
  owner:Logic_LockRotation(false)
  if owner.Client_NoMove ~= nil then
    owner:Client_NoMove(false)
  end
  owner:SetParent(nil, true)
  if owner.logicTransform ~= nil and owner.logicTransform.SetScaleXYZ ~= nil then
    owner.logicTransform:SetScaleXYZ(owner:GetScaleWithFixHW())
  end
  local assetRole = owner.assetRole
  if assetRole ~= nil then
    if assetRole.SetShadowEnable ~= nil then
      assetRole:SetShadowEnable(true)
    end
    if assetRole.SetMountDisplay ~= nil then
      assetRole:SetMountDisplay(true)
    end
    if assetRole.SetWingDisplay ~= nil then
      assetRole:SetWingDisplay(true)
    end
    if assetRole.SetTailDisplay ~= nil then
      assetRole:SetTailDisplay(true)
    end
  end
  owner:SetPeakEffectVisible(true, LayerChangeReasonInteractNpc)
  local functionPlayerUI = FunctionPlayerUI.Me()
  if functionPlayerUI ~= nil then
    functionPlayerUI:UnMaskBloodBar(owner, PUIVisibleReasonInteractNpc)
    functionPlayerUI:UnMaskNameHonorFactionType(owner, PUIVisibleReasonInteractNpc)
  end
  local partner = owner.partner
  if partner ~= nil then
    partner:SetVisible(true, LayerChangeReasonInteractNpc)
  end
  if owner.Logic_NavMeshPlaceTo ~= nil and ownerPos ~= nil then
    owner:Logic_NavMeshPlaceTo(self.tempPos)
  end
  if owner.Client_IsMoving ~= nil and owner:Client_IsMoving() then
    owner:Logic_PlayAction_Move(owner:Client_GetMoveToCustomActionName(), true)
  elseif owner.Logic_PlayAction_Idle ~= nil then
    owner:Logic_PlayAction_Idle()
  end
end

function Creature_SnakeCoaster:_SyncCoasterNpcMoveSpeed()
  local coasterNpc = self.coasterNpc
  if coasterNpc == nil or coasterNpc.logicTransform == nil then
    return
  end
  local owner = self.owner
  local speed = owner and owner.logicTransform and owner.logicTransform:GetMoveSpeed() or self.moveSpeed
  coasterNpc.logicTransform:SetMoveSpeed(speed)
  self.speed = speed
end

function Creature_SnakeCoaster:_SyncNpcPositionToServer(targetPos)
  if not targetPos then
    return
  end
  local owner = self.owner
  if owner == nil or owner ~= Game.Myself then
    return
  end
  owner:SyncServer_MoveTo(targetPos)
end

function Creature_SnakeCoaster:IsNpcDriveMode()
  if not self.active or self.coasterNpc == nil then
    return false
  end
  local snakeCoasterManager = SnakeCoasterManager.Me()
  if snakeCoasterManager == nil or snakeCoasterManager.finishSubmitted then
    return false
  end
  local gameState = snakeCoasterManager:GetGameState()
  local snakeCoasterState = ESNAKECOASTERSTATE
  if snakeCoasterState ~= nil and (gameState == snakeCoasterState.ESNAKECOASTER_STATE_FINISH or gameState == snakeCoasterState.ESNAKECOASTER_STATE_FAIL or gameState == snakeCoasterState.ESNAKECOASTER_STATE_EXIT) then
    return false
  end
  return true
end

function Creature_SnakeCoaster:_GetCoasterActionName(actionId)
  local mappedActionId = actionId
  local actionConfig = Table_ActionAnime and Table_ActionAnime[mappedActionId]
  if actionConfig == nil then
    return nil, mappedActionId
  end
  return actionConfig.Name, mappedActionId
end

function Creature_SnakeCoaster:PlayCoasterAction(actionId)
  local owner = self.owner
  if owner == nil then
    return false
  end
  local actionName, mappedActionId = self:_GetCoasterActionName(actionId)
  if actionName == nil then
    return false
  end
  owner:Client_PlayAction(actionName, nil, true)
  return true
end

function Creature_SnakeCoaster:_ClearCheckPoints()
  if self.coasterCheckPointStates ~= nil then
    for i = 1, #self.coasterCheckPointStates do
      local checkPointState = self.coasterCheckPointStates[i]
      if checkPointState ~= nil and checkPointState.effect ~= nil then
        checkPointState.effect:Destroy()
        checkPointState.effect = nil
      end
    end
  end
  self.coasterCheckPointStates = nil
  self.pendingCheckPointActionType = nil
  self.pendingCheckPointInfo = nil
  if self.tempCubeList ~= nil then
    for i = 1, #self.tempCubeList do
      GameObject.Destroy(self.tempCubeList[i])
    end
    self.tempCubeList = {}
  end
  if self.coasterCheckPointTriggerIDs ~= nil then
    local sceneTriggerProxy = SceneTriggerProxy.Instance
    if sceneTriggerProxy ~= nil then
      for i = 1, #self.coasterCheckPointTriggerIDs do
        sceneTriggerProxy:RemoveCoaster(self.coasterCheckPointTriggerIDs[i])
      end
    end
    self.coasterCheckPointTriggerIDs = nil
  end
end

function Creature_SnakeCoaster:_BuildCheckPointGroups(checkPoints)
  local groups = {}
  if checkPoints == nil then
    return groups
  end
  for i = 1, #checkPoints do
    local checkPoint = checkPoints[i]
    if checkPoint ~= nil then
      local groupID = checkPoint.ID or 0
      local group = groups[groupID]
      if group == nil then
        group = {}
        groups[groupID] = group
      end
      group[#group + 1] = checkPoint
    end
  end
  return groups
end

function Creature_SnakeCoaster:_GetCheckPointEffectPath(checkPointState)
  if checkPointState == nil then
    return nil
  end
  local snakeCoasterConfig = GameConfig.SnakeCoaster
  if snakeCoasterConfig == nil then
    return nil
  end
  local pointKey = MyselfProxy.Instance:GetMySex() == 2 and "FemalePoints" or "MalePoints"
  local actionType = checkPointState.actionType or 0
  local pointConfig = pointKey == "FemalePoints" and (snakeCoasterConfig.FemalePoints or snakeCoasterConfig.femalePoints) or snakeCoasterConfig.MalePoints or snakeCoasterConfig.malePoints
  if pointConfig == nil then
    return nil
  end
  local effectConfig = pointConfig[actionType]
  if effectConfig == nil then
    return nil
  end
  return effectConfig.EffectPath or effectConfig.effectPath
end

function Creature_SnakeCoaster:_BuildCheckPoints()
  self:_ClearCheckPoints()
  local snakeCoasterManager = SnakeCoasterManager.Me()
  local groups = snakeCoasterManager:GetCoasterCheckPointGroups(self.coasterID)
  if groups == nil then
    groups = self:_BuildCheckPointGroups(snakeCoasterManager:GetCoasterCheckPoints(self.coasterID))
  end
  local groupIDs = {}
  for groupID, group in pairs(groups) do
    if group ~= nil and 0 < #group then
      groupIDs[#groupIDs + 1] = groupID
    end
  end
  table.sort(groupIDs, function(a, b)
    return a < b
  end)
  self.coasterCheckPointStates = {}
  self.coasterCheckPointTriggerIDs = {}
  local sceneTriggerProxy = SceneTriggerProxy.Instance
  for i = 1, #groupIDs do
    local groupID = groupIDs[i]
    local group = groups[groupID]
    if group == nil then
      group = groups[tostring(groupID)]
    end
    if group ~= nil and 0 < #group then
      local pickIndex = math.random(1, #group)
      local checkPoint = group[pickIndex]
      if checkPoint ~= nil then
        local position = checkPoint.position or LuaVector3.Zero()
        local checkPointState = {
          groupID = groupID,
          coasterID = self.coasterID,
          actionType = checkPoint.actionType or 0,
          type = checkPoint.type or 0,
          range = checkPoint.range or 0,
          normalScore = checkPoint.normalScore or self.defaultNormalScore,
          perfectScore = checkPoint.perfectScore or self.defaultPerfectScore,
          position = position,
          sourceIndex = pickIndex,
          sourceCount = #group,
          checkPoint = checkPoint,
          hit = false
        }
        self.coasterCheckPointStates[#self.coasterCheckPointStates + 1] = checkPointState
        local triggerID = string.format("SnakeCoaster_%s_%s_%s", tostring(self.coasterID), tostring(groupID), tostring(pickIndex))
        local triggerData = ReusableTable.CreateTable()
        triggerData.id = triggerID
        triggerData.pos = {
          x = position[1] or 0,
          y = position[2],
          z = position[3] or 0
        }
        triggerData.range = checkPoint.range or 0.75
        triggerData.type = AreaTrigger_Coaster_ClientType.SnakeCoaster
        triggerData.customData = checkPointState
        if sceneTriggerProxy ~= nil then
          sceneTriggerProxy:AddCoaster(triggerData)
        end
        ReusableTable.DestroyTable(triggerData)
        self.coasterCheckPointTriggerIDs[#self.coasterCheckPointTriggerIDs + 1] = triggerID
        local effectPath = self:_GetCheckPointEffectPath(checkPointState)
        if effectPath ~= nil and effectPath ~= "" then
          LuaVector3.Better_Set(self.tempPos, position[1] or 0, position[2] + 0.5, position[3] or 0)
          checkPointState.effect = Asset_Effect.PlayAt(effectPath, self.tempPos, function(obj, callbackArg, effect)
            self:_RestoreCheckPointDefaultAnim(effect)
          end)
        end
      end
    end
  end
  return 0 < #self.coasterCheckPointStates
end

function Creature_SnakeCoaster:_RestoreCheckPointDefaultAnim(effect)
  if effect == nil then
    return
  end
  local snakeCoasterConfig = GameConfig.SnakeCoaster
  local defaultAnim = snakeCoasterConfig and snakeCoasterConfig.CheckPointDefaultAnim
  if defaultAnim == nil or defaultAnim == "" then
    return
  end
  local animator = effect:GetComponent(Animator)
  if animator ~= nil then
    animator:Play(defaultAnim)
  end
end

function Creature_SnakeCoaster:_OnCheckPointHit(checkPointState)
  if checkPointState == nil then
    return nil
  end
  local currentActionId = self:GetCurrentActionId()
  local expectedActionId = checkPointState.actionType or 0
  local isPerfect = currentActionId ~= 0 and expectedActionId ~= 0 and currentActionId == expectedActionId
  local scoreDelta = isPerfect and (checkPointState.perfectScore or SnakeCoasterPerfectScore) or checkPointState.normalScore or SnakeCoasterNormalScore
  checkPointState.hitActionId = currentActionId
  checkPointState.isPerfect = isPerfect
  checkPointState.scoreDelta = scoreDelta
  self:_AddScore(scoreDelta, isPerfect, checkPointState)
  checkPointState.hit = true
  local snakeCoasterConfig = GameConfig.SnakeCoaster
  if snakeCoasterConfig ~= nil then
    local triggerAnim = snakeCoasterConfig.CheckPointTriggerAnim
    if triggerAnim ~= nil and triggerAnim ~= "" then
      local triggerEffect = checkPointState.effect
      if triggerEffect ~= nil then
        local animator = triggerEffect:GetComponent(Animator)
        if animator ~= nil then
          animator:Play(triggerAnim)
        end
      end
    end
    local sfxPath = isPerfect and snakeCoasterConfig.CheckPointPerfectEffect or snakeCoasterConfig.CheckPointEffect
    if sfxPath ~= nil and sfxPath ~= "" then
      local assetRole = self.owner and self.owner.assetRole
      local trans = assetRole and assetRole.completeTransform
      if trans ~= nil then
        local effect = Asset_Effect.PlayOneShotOn(sfxPath, trans)
        if effect ~= nil then
          effect:ResetLocalEulerAnglesXYZ(0, 180, 0)
        end
      end
    end
  end
end

function Creature_SnakeCoaster:OnCheckPointTrigger(checkPointState)
  if not self.active or checkPointState == nil or checkPointState.hit then
    return nil
  end
  return self:_OnCheckPointHit(checkPointState)
end

function Creature_SnakeCoaster:_UpdateCameraLockTargetPosition()
  local moveHost = self:_GetMoveHost()
  if moveHost == nil then
    return false
  end
  if self.pathSegments == nil then
    return false
  end
  local t, posX, posY, posZ = self:_ProjectCurrentPositionOnSegment()
  if t == nil then
    t = self.segmentProgress
    posX, posY, posZ = self:_GetCurrentSegmentPoint(t)
    if posX == nil then
      return false
    end
  end
  self.segmentProgress = t
  self:_UpdateSegmentVectors(t)
  local hostPos = self:_GetMoveHostPosition()
  local lookY = hostPos and hostPos[2] or posY
  LuaVector3.Better_Set(self.tempPos, posX, lookY + self.cameraLookUpHeight, posZ or 0)
  if self.cameraLockTarget ~= nil then
    self.cameraLockTarget.position = self.tempPos
  end
  if self.cameraBackTraceFocus ~= nil then
    LuaVector3.Better_Set(self.tempDir, self.tempPos[1] - self.segmentForwardDir[1] * self.cameraBackTraceFocusDistance, self.tempPos[2] + self.cameraBackTraceFocusHeight, self.tempPos[3] - self.segmentForwardDir[3] * self.cameraBackTraceFocusDistance)
    self.cameraBackTraceFocus.position = self.tempDir
  end
  return true
end

function Creature_SnakeCoaster:OnFreeCameraRestoreDefault()
  if self.active then
    self:_SyncCameraState(true)
  end
end

function Creature_SnakeCoaster:_SyncCameraState(force)
  if not self.active then
    return
  end
  local cameraController = CameraController.singletonInstance
  if cameraController == nil then
    return
  end
  if self.cameraLockTarget == nil then
    local targetObj = GameObject()
    targetObj.name = SnakeCoasterCameraLockTargetName
    self.cameraLockTarget = targetObj.transform
    self.cameraLockTargetBound = false
  end
  if self.cameraBackTraceFocus == nil then
    local focusObj = GameObject()
    focusObj.name = SnakeCoasterCameraBackTraceFocusName
    self.cameraBackTraceFocus = focusObj.transform
  end
  if not self:_UpdateCameraLockTargetPosition() then
    return
  end
  if not force and self.cameraLockTargetBound then
    return
  end
  cameraController:InterruptSmoothTo()
  cameraController:ForceResetLockTargetStatus()
  cameraController:SetResumeLockTarget()
  local focusOffset = LuaGeometry.GetTempVector3(0, 0, 0)
  local focusRotation = cameraController.currentInfo and cameraController.currentInfo.rotation or focusOffset
  local targetViewport = self.cameraLockTargetViewport
  cameraController:FocusTo(self.cameraBackTraceFocus, focusOffset, targetViewport, focusRotation, 1, nil, false)
  local backDistance = self.cameraBackTraceDistance
  local focusDistance = self.cameraBackTraceFocusDistance
  if backDistance <= focusDistance then
    focusDistance = math.max(backDistance * 0.02, 0.01)
  end
  cameraController:ResetLockTargetParams(self.cameraBackTraceDistance, 0, self.cameraBackTraceFollowLerpTime, -1, 0, 0, self.cameraBackTracePitch, SnakeCoasterCameraFov)
  cameraController:SetLockTarget(self.cameraLockTarget, focusOffset, targetViewport, self.cameraBackTraceSwitchDuration)
  self.cameraLockTargetBound = true
end

function Creature_SnakeCoaster:_UpdateSegmentVectors(t)
  local segment = self:_GetCurrentSegmentData()
  if segment == nil then
    self.segmentLength = 0
    return
  end
  self.segmentLength = segment.length or 0
  local forwardX, forwardZ = self:_GetSegmentForwardBySegment(segment, t)
  if forwardX ~= nil and forwardZ ~= nil then
    self.segmentForwardDir[1] = forwardX
    self.segmentForwardDir[3] = forwardZ
    self.segmentLateralDir[1] = self.segmentForwardDir[3]
    self.segmentLateralDir[3] = -self.segmentForwardDir[1]
  end
end

function Creature_SnakeCoaster:PrepareDirInput(dir, keepCurrentMove)
  if not self.active then
    return dir
  end
  local nx, nz = 0, 0
  if dir ~= nil then
    nx = dir[1] or 0
    nz = dir[3] or 0
  end
  local mag = math.sqrt(nx * nx + nz * nz)
  if mag <= SnakeCoasterDirEpsilon then
    self.userInputX = 0
  else
    nx = nx / mag
    nz = nz / mag
    local lateralInput = nx * self.segmentLateralDir[1] + nz * self.segmentLateralDir[3]
    if 1 < lateralInput then
      lateralInput = 1
    elseif lateralInput < -1 then
      lateralInput = -1
    end
    self.userInputX = lateralInput
  end
  LuaVector3.Better_Set(self.tempDir, 0, 0, 0)
  return self.tempDir
end

function Creature_SnakeCoaster:_UpdateLateralOffset(deltaTime)
  local laneHalfWidth = self.laneHalfWidth or 0
  if laneHalfWidth <= SnakeCoasterDirEpsilon then
    self.lateralOffset = 0
    return
  end
  local lateralSpeed = self.lateralSpeed or 0
  if lateralSpeed <= SnakeCoasterDirEpsilon then
    if laneHalfWidth < self.lateralOffset then
      self.lateralOffset = laneHalfWidth
    elseif self.lateralOffset < -laneHalfWidth then
      self.lateralOffset = -laneHalfWidth
    end
    return
  end
  local offset = self.lateralOffset + self.userInputX * lateralSpeed * deltaTime
  if laneHalfWidth < offset then
    offset = laneHalfWidth
  elseif offset < -laneHalfWidth then
    offset = -laneHalfWidth
  end
  self.lateralOffset = offset
end

function Creature_SnakeCoaster:OnDirInputEnd()
  if not self.active then
    return false
  end
  self.userInputX = 0
  return true
end

function Creature_SnakeCoaster:StepDirMove(time, deltaTime, dir, stepTarget, rotateDir)
  return false
end

function Creature_SnakeCoaster:Update(time, deltaTime)
  if not self.active or self.roadPoints == nil then
    return
  end
  local owner = self.owner
  local coasterNpc = self.coasterNpc
  if owner == nil or coasterNpc == nil or coasterNpc.logicTransform == nil then
    return
  end
  if not self.coasterNpcBound and not self:_TryBindOwnerToCoasterNpc() then
    self:_SyncCameraState(false)
    return
  end
  self:_SyncCoasterNpcMoveSpeed()
  if self.startDelayRemain > 0 then
    self.startDelayRemain = self.startDelayRemain - deltaTime
    if self.startDelayRemain > 0 then
      self.speed = 0
      self:_SyncCameraState(false)
      return
    end
    self.startDelayRemain = 0
  end
  if self.dirMoveStarted and coasterNpc.Client_IsDirMoving ~= nil and not coasterNpc:Client_IsDirMoving() then
    self.dirMoveStarted = false
  end
  if not self.dirMoveStarted then
    self:_StartDirMove()
  end
  if self.currentSegment < 1 then
    self:_SyncCameraState(false)
    return
  end
  if not self:_EnsureCurrentSegment() then
    self.segmentProgress = 1
    self:_OnFinish()
    return
  end
  local t = self.segmentProgress
  local projectedT
  local currentPos = self:_GetMoveHostPosition()
  if currentPos ~= nil then
    projectedT = self:_ProjectCurrentPositionOnSegment()
    if projectedT ~= nil then
      t = projectedT
      self.segmentProgress = t
    end
  end
  self:_UpdateSegmentVectors(self.segmentProgress)
  if t >= 1 - SnakeCoasterDirEpsilon then
    if self.pathSegments == nil or self.currentSegment >= #self.pathSegments then
      self.segmentProgress = 1
      self:_SyncCameraState(false)
      self:_OnFinish()
      return
    end
    self.currentSegment = self.currentSegment + 1
    self.segmentProgress = 0
    if not self:_EnsureCurrentSegment() then
      self.segmentProgress = 1
      self:_SyncCameraState(false)
      self:_OnFinish()
      return
    end
  end
  self:_UpdateLateralOffset(deltaTime)
  local posX, posY, posZ = self:_GetCurrentSegmentPoint(self.segmentProgress)
  if posX ~= nil then
    self:_ApplyLateralOffsetToMoveHost(posX, posY, posZ)
    local lateralOffset = self.lateralOffset
    local segmentChanged = self._lastSyncSegment ~= self.currentSegment
    local lateralChanged = self.userInputX ~= 0 and lateralOffset ~= self._lastSyncLateralOffset
    if segmentChanged or lateralChanged then
      if segmentChanged then
        self._lastSyncSegment = self.currentSegment
      end
      self._lastSyncLateralOffset = lateralOffset
      LuaVector3.Better_Set(self.tempPos, posX + self.segmentLateralDir[1] * lateralOffset, posY, posZ + self.segmentLateralDir[3] * lateralOffset)
      self:_SyncNpcPositionToServer(self.tempPos)
    end
  end
  self:_SyncCameraState(false)
end

function Creature_SnakeCoaster:_OnFinish()
  if self.finishTriggered then
    return
  end
  self.finishTriggered = true
  self.active = false
  self:_StopDirMove()
  SnakeCoasterManager.Me():OnLocalCoasterFinish(self:GetScore())
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = {
      result = 1,
      simply = true,
      closeCallback = function()
        SnakeCoasterManager.Me():QuitCoasterGame()
      end
    }
  })
end

function Creature_SnakeCoaster:GetCurrentSegment()
  return self.currentSegment
end

function Creature_SnakeCoaster:GetSegmentProgress()
  return self.segmentProgress
end

function Creature_SnakeCoaster:GetLateralOffset()
  return self.lateralOffset
end

function Creature_SnakeCoaster:HasPendingCheckPointAction()
  return self.pendingCheckPointInfo ~= nil
end

function Creature_SnakeCoaster:GetPendingCheckPointActionType()
  return self.pendingCheckPointActionType
end

function Creature_SnakeCoaster:GetPendingCheckPointInfo()
  return self.pendingCheckPointInfo
end

function Creature_SnakeCoaster:ClearPendingCheckPointAction()
  self.pendingCheckPointActionType = nil
  self.pendingCheckPointInfo = nil
end
