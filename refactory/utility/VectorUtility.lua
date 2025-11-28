VectorUtility = class("VectorUtility")
local tempQuaternion = LuaQuaternion.Identity()
local tempQuaternion_1 = LuaQuaternion.Identity()
local tempQuaternion_2 = LuaQuaternion.Identity()
local tempVector3 = LuaVector3.Zero()
local tempVector2 = LuaVector2.Zero()
local tempVector2_1 = LuaVector2.Zero()

function VectorUtility.Destroy(v)
  if nil ~= v then
    v:Destroy()
  end
  return nil
end

function VectorUtility.AlmostEqual_2(v1, v2)
  local diff1 = v1[1] - v2[1]
  local diff2 = v1[2] - v2[2]
  return -0.01 <= diff1 and diff1 <= 0.01 and -0.01 <= diff2 and diff2 <= 0.01
end

function VectorUtility.AlmostEqual_3(v1, v2)
  local diff1 = v1[1] - v2[1]
  local diff2 = v1[2] - v2[2]
  local diff3 = v1[3] - v2[3]
  return -0.01 <= diff1 and diff1 <= 0.01 and -0.01 <= diff2 and diff2 <= 0.01 and -0.01 <= diff3 and diff3 <= 0.01
end

function VectorUtility.AlmostEqual_3_XZ(v1, v2)
  local diff1 = v1[1] - v2[1]
  local diff2 = v1[3] - v2[3]
  return -0.01 <= diff1 and diff1 <= 0.01 and -0.01 <= diff2 and diff2 <= 0.01
end

function VectorUtility.Asign_2(to, from)
  if nil ~= to then
    LuaVector2.Better_Set(to, from[1], from[2])
  else
    to = LuaVector2.Better_Clone(from)
  end
  return to
end

function VectorUtility.TryAsign_2(to, from)
  if nil == from then
    return to
  end
  return VectorUtility.Asign_2(to, from)
end

function VectorUtility.Asign_3(to, from)
  if nil ~= to then
    LuaVector3.Better_Set(to, from[1], from[2], from[3])
  else
    to = LuaVector3.Better_Clone(from)
  end
  return to
end

function VectorUtility.TryAsign_3(to, from)
  if nil == from then
    return to
  end
  return VectorUtility.Asign_3(to, from)
end

function VectorUtility.Asign_4(to, from)
  if nil ~= to then
    to[1] = from[1]
    to[2] = from[2]
    to[3] = from[3]
    to[4] = from[4]
  else
    to = Vector4(from[1], from[2], from[3], from[4])
  end
  return to
end

function VectorUtility.TryAsign_4(to, from)
  if nil == from then
    return to
  end
  return VectorUtility.Asign_4(to, from)
end

function VectorUtility.SetXZ_2(v, v2)
  v2[1] = v[1]
  v2[2] = v[3]
end

function VectorUtility.SetXZ_3(v, v3)
  v3[1] = v[1]
  v3[3] = v[2]
end

function VectorUtility.SubXZ_2(a, b, v2)
  v2[1] = a[1] - b[1]
  v2[2] = a[3] - b[3]
end

function VectorUtility.SubXY_2(a, b, v2)
  v2[1] = a[1] - b[1]
  v2[2] = a[2] - b[2]
end

function VectorUtility.DistanceXZ(a, b)
  local x = a[1] - b[1]
  local z = a[3] - b[3]
  return math.sqrt(x * x + z * z)
end

function VectorUtility.DistanceXZ_Square(a, b)
  local x = a[1] - b[1]
  local z = a[3] - b[3]
  return x * x + z * z
end

function VectorUtility.DistanceXYZ_Square(a, b)
  local x = a[1] - b[1]
  local y = a[2] - b[2]
  local z = a[3] - b[3]
  return x * x + y * y + z * z
end

function VectorUtility.DistanceXY(a, b)
  local x = a[1] - b[1]
  local y = a[2] - b[2]
  return math.sqrt(x * x + y * y)
end

function VectorUtility.DistanceBy2Value_Square(aValue1, aValue2, bValue1, bValue2)
  local offset1 = aValue1 - bValue1
  local offset2 = aValue2 - bValue2
  return offset1 * offset1 + offset2 * offset2
end

function VectorUtility.Better_MoveTowardsXZ_2(p1, p2, v2, delta)
  VectorUtility.SetXZ_2(p1, tempVector2)
  VectorUtility.SetXZ_2(p2, tempVector2_1)
  LuaVector2.Better_MoveTowards(tempVector2, tempVector2_1, v2, delta)
end

function VectorUtility.AngleYToVector3(angleY)
  local v = LuaVector3.Forward()
  return VectorUtility.SelfAngleYToVector3(v, angleY)
end

function VectorUtility.SelfAngleYToVector3(v, angleY)
  LuaVector3.Better_Set(tempVector3, 0, angleY, 0)
  LuaQuaternion.Better_SetEulerAngles(tempQuaternion, tempVector3)
  LuaQuaternion.Better_MulVector3(tempQuaternion, v, v)
  return v
end

function VectorUtility.SelfLookAt(v, p)
  return VectorUtility.Better_LookAt(v, v, p)
end

function VectorUtility.Better_LookAt(v, t, p)
  LuaVector3.Better_Sub(p, v, tempVector3)
  LuaQuaternion.Better_Set(tempQuaternion, 0, 0, 0, 1)
  LuaQuaternion.Better_LookRotation(tempQuaternion, tempVector3)
  LuaQuaternion.Better_GetEulerAngles(tempQuaternion, t)
  return t
end

function VectorUtility.TryLerpAngleUnclamped_3(cur, from, to, progress)
  if nil ~= from and nil ~= to then
    LuaQuaternion.Better_SetEulerAngles(tempQuaternion, from)
    LuaQuaternion.Better_SetEulerAngles(tempQuaternion_1, to)
    LuaQuaternion.Better_LerpUnclamped(tempQuaternion, tempQuaternion_1, tempQuaternion_2, progress)
    LuaQuaternion.Better_GetEulerAngles(tempQuaternion_2, tempVector3)
    return VectorUtility.Asign_3(cur, tempVector3)
  end
  return VectorUtility.TryAsign_3(cur, to)
end

function VectorUtility.TryLerpUnclamped_3(cur, from, to, progress)
  if nil ~= from and nil ~= to then
    LuaVector3.Better_LerpUnclamped(from, to, tempVector3, progress)
    return VectorUtility.Asign_3(cur, tempVector3)
  end
  return VectorUtility.TryAsign_3(cur, to)
end

function VectorUtility.Better_Bezier(p1, p2, p3, p, t)
  local u = 1 - t
  local tt = t * t
  local tu = 2 * t * u
  local uu = u * u
  p[1] = uu * p1[1] + tu * p2[1] + tt * p3[1]
  p[2] = uu * p1[2] + tu * p2[2] + tt * p3[2]
  p[3] = uu * p1[3] + tu * p2[3] + tt * p3[3]
  return p
end

function VectorUtility.Better_CubicBezier(p1, p2, p3, p4, p, t)
  local ttt = t * t * t
  local u = 1 - t
  local uuu = u * u * u
  local tuu = 3 * t * u * u
  local ttu = 3 * t * t * u
  p[1] = uuu * p1[1] + tuu * p2[1] + ttu * p3[1] + ttt * p4[1]
  p[2] = uuu * p1[2] + tuu * p2[2] + ttu * p3[2] + ttt * p4[2]
  p[3] = uuu * p1[3] + tuu * p2[3] + ttu * p3[3] + ttt * p4[3]
  return p
end

function VectorUtility.Better_Mul_XYZ(a, x, y, z, t)
  t[1] = a[1] * x
  t[2] = a[2] * y
  t[3] = a[3] * z
end

function VectorUtility.Better_Add_XYZ(a, x, y, z, t)
  t[1] = a[1] + x
  t[2] = a[2] + y
  t[3] = a[3] + z
end
