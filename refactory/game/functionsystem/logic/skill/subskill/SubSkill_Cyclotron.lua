local SelfClass = {}
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
  if nil ~= args[14] then
    LuaVector3.Destroy(args[14])
    args[14] = nil
  end
end

function SelfClass:Start(endPosition)
  local args = self.args
  local effect = args[8]
  local currentPosition = effect:GetLocalPosition()
  local distance = LuaVector3.Distance(currentPosition, endPosition)
  local radius = distance * 0.5
  VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
  effect:ResetLocalEulerAngles(tempVector3)
  local dirEulerAngles = tempVector3
  LuaVector3.Better_Sub(endPosition, currentPosition, dirEulerAngles)
  LuaVector3.Normalized(dirEulerAngles)
  local bezPos0 = LuaVector3.Better_Clone(currentPosition)
  args[12] = bezPos0
  local bezPos1 = LuaVector3.Better_Clone(currentPosition)
  args[13] = bezPos1
  LuaVector3.Better_Mul(dirEulerAngles, radius, tempVector3_1)
  tempVector3_1[2] = tempVector3_1[2] + distance
  LuaVector3.Add(bezPos1, tempVector3_1)
  local bezPos2 = LuaVector3.Better_Clone(bezPos1)
  args[14] = bezPos2
  LuaQuaternion.Better_AngleAxis(tempQuaternion, 90, dirEulerAngles)
  LuaVector3.Better_Sub(bezPos1, bezPos0, tempVector3_1)
  LuaQuaternion.Better_MulVector3(tempQuaternion, tempVector3_1, bezPos1)
  LuaVector3.Add(bezPos1, bezPos0)
  LuaQuaternion.Better_AngleAxis(tempQuaternion, -90, dirEulerAngles)
  LuaVector3.Better_Sub(bezPos2, bezPos0, tempVector3_1)
  LuaQuaternion.Better_MulVector3(tempQuaternion, tempVector3_1, bezPos2)
  LuaVector3.Add(bezPos2, bezPos0)
  effect:ResetLocalPosition(bezPos0)
  args[15] = 0
  args[16] = false
  return true
end

function SelfClass:End()
end

function SelfClass:Update(endPosition, refreshed, time, deltaTime)
  local args = self.args
  args[15] = args[15] + deltaTime
  local effect = args[8]
  local currentPosition = effect:GetLocalPosition()
  if refreshed then
    VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
    effect:ResetLocalEulerAngles(tempVector3)
  end
  local nextPosition = tempVector3
  local emitParams = args[2]
  local t = args[15] / emitParams.duration
  if 1 < t then
    t = 1
  end
  if t < 0.5 then
    VectorUtility.Better_Bezier(args[12], args[13], endPosition, nextPosition, t * 2)
  else
    if not args[16] then
      args[16] = true
      self:Hit(endPosition)
    end
    VectorUtility.Better_Bezier(endPosition, args[14], args[12], nextPosition, t * 2 - 1)
  end
  if 1 <= t then
    return false
  else
    effect:ResetLocalPosition(nextPosition)
    return true
  end
end

return SelfClass
