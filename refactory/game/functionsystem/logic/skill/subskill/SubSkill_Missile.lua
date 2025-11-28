local SelfClass = {}
local AngleRange = 150
local StartFactor = {0, 0}
local ControlFactor = {8.5, 5.0}
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()
local tempQuaternion = LuaQuaternion.Identity()

function SelfClass:Deconstruct()
  local args = self.args
  if nil ~= args[12] then
    LuaVector3.Destroy(args[12])
    args[12] = nil
  end
  if nil ~= args[13] then
    LuaVector3.Destroy(args[13])
    args[13] = nil
  end
  args[14] = nil
  args[15] = nil
end

function SelfClass:Start(endPosition)
  local args = self.args
  local emitParams = args[2]
  local effect = args[8]
  local currentPosition = effect:GetLocalPosition()
  VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
  effect:ResetLocalEulerAngles(tempVector3)
  local dirEulerAngles = tempVector3
  LuaVector3.Better_Sub(endPosition, currentPosition, dirEulerAngles)
  LuaVector3.Normalized(dirEulerAngles)
  LuaVector3.Mul(dirEulerAngles, -1)
  local bezPos0 = LuaVector3.Better_Clone(currentPosition)
  args[12] = bezPos0
  local bezPos1 = LuaVector3.Better_Clone(currentPosition)
  args[13] = bezPos1
  LuaVector3.Better_Mul(dirEulerAngles, StartFactor[1], tempVector3_1)
  tempVector3_1[2] = tempVector3_1[2] + StartFactor[2]
  LuaVector3.Add(bezPos0, tempVector3_1)
  local custom_controlfactor = emitParams.controlfactor
  local distanceper = emitParams.distanceper
  if custom_controlfactor then
    LuaVector3.Better_Mul(dirEulerAngles, math.min(custom_controlfactor[1], tempVector3.magnitude * 0.75), tempVector3_1)
    tempVector3_1[2] = tempVector3_1[2] + custom_controlfactor[2]
  elseif distanceper then
    local distance = VectorUtility.DistanceXZ(currentPosition, endPosition)
    LuaVector3.Better_Mul(dirEulerAngles, distance * distanceper[1], tempVector3_1)
    tempVector3_1[2] = tempVector3_1[2] + distance * distanceper[2]
  else
    LuaVector3.Better_Mul(dirEulerAngles, ControlFactor[1], tempVector3_1)
    tempVector3_1[2] = tempVector3_1[2] + ControlFactor[2]
  end
  LuaVector3.Add(bezPos1, tempVector3_1)
  if emitParams.nooffset ~= 1 then
    local emitIndex = args[6]
    local emitCount = args[7]
    local anglePiece = AngleRange / emitCount
    local angleOffset = math.random(0, anglePiece)
    local angle = anglePiece * math.floor(emitIndex / 2) - anglePiece / 2 + angleOffset
    if 0 ~= emitIndex % 2 then
      angle = -angle
    end
    if 0 ~= angle then
      LuaQuaternion.Better_AngleAxis(tempQuaternion, angle, dirEulerAngles)
      LuaVector3.Better_Sub(bezPos1, bezPos0, tempVector3_1)
      LuaQuaternion.Better_MulVector3(tempQuaternion, tempVector3_1, bezPos1)
      LuaVector3.Add(bezPos1, bezPos0)
    end
  end
  effect:ResetLocalPosition(bezPos0)
  args[14] = 0
  args[15] = emitParams.duration or VectorUtility.DistanceXZ(currentPosition, endPosition) / emitParams.speed
  return true
end

function SelfClass:End()
  local emitParams = self.args[2]
  local effect = self.args[8]
  if effect and emitParams.ClearTrailMap then
    effect:ClearTrailRenderer(emitParams.ClearTrailMap)
  end
end

function SelfClass:Update(endPosition, refreshed, time, deltaTime)
  local args = self.args
  args[14] = args[14] + deltaTime
  local effect = args[8]
  local currentPosition = effect:GetLocalPosition()
  if refreshed then
    VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
    effect:ResetLocalEulerAngles(tempVector3)
  end
  local nextPosition = tempVector3
  local t = args[14] / args[15]
  if 1 < t then
    t = 1
  end
  VectorUtility.Better_Bezier(args[12], args[13], endPosition, nextPosition, t)
  if 1 <= t then
    self:Hit(endPosition)
    return false
  else
    effect:ResetLocalPosition(nextPosition)
    return true
  end
end

return SelfClass
