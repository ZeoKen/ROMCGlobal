autoImport("LuaVector2")
autoImport("LuaVector3")
autoImport("LuaColor")
autoImport("LuaQuaternion")
LuaGeometry = {}
LuaGeometry.Const_V2_zero = LuaVector2.Zero()
LuaGeometry.Const_V2_one = LuaVector2.One()
LuaGeometry.Const_V3_zero = LuaVector3.Zero()
LuaGeometry.Const_V3_one = LuaVector3.One()
LuaGeometry.Const_Qua_identity = LuaQuaternion.Identity()
LuaGeometry.Const_Col_black = LuaColor.Black()
LuaGeometry.Const_Col_white = LuaColor.White()
LuaGeometry.Const_Col_whiteClear = LuaColor.WhiteClear()
LuaGeometry.Const_Col_blue = LuaColor.Blue()
LuaGeometry.Const_Col_red = LuaColor.Red()
LuaGeometry.VolumeTypes = {Cube = 0, Sphere = 1}
LuaGeometry.tmpV2 = LuaVector2(0, 0)

function LuaGeometry.GetTempVector2(x, y, tarVector)
  tarVector = tarVector or LuaGeometry.tmpV2
  if tarVector:Alive() then
    LuaVector2.Better_Set(tarVector, x or 0, y or 0)
  else
    tarVector = LuaVector2(x or 0, y or 0)
  end
  return tarVector
end

LuaGeometry.tmpV3 = LuaVector3(0, 0, 0)

function LuaGeometry.GetTempVector3(x, y, z, tarVector)
  tarVector = tarVector or LuaGeometry.tmpV3
  if tarVector:Alive() then
    LuaVector3.Better_Set(tarVector, x or 0, y or 0, z or 0)
  else
    tarVector = LuaVector3(x or 0, y or 0, z or 0)
  end
  return tarVector
end

LuaGeometry.tmpV4 = Vector4(0, 0, 0, 0)

function LuaGeometry.GetTempVector4(x, y, z, w, tarVector)
  tarVector = tarVector or LuaGeometry.tmpV4
  tarVector.x = x or 0
  tarVector.y = y or 0
  tarVector.z = z or 0
  tarVector.w = w or 0
  return tarVector
end

LuaGeometry.tmpQuaternion = LuaQuaternion(0, 0, 0, 1)

function LuaGeometry.GetTempQuaternion(x, y, z, w, tarQuaternion)
  tarQuaternion = tarQuaternion or LuaGeometry.tmpQuaternion
  if tarQuaternion:Alive() then
    LuaQuaternion.Better_Set(tarQuaternion, x or 0, y or 0, z or 0, w or 1)
  else
    tarQuaternion = LuaQuaternion(x or 0, y or 0, z or 0, w or 1)
  end
  return tarQuaternion
end

LuaGeometry.tmpColor = LuaColor(0, 0, 0, 0)

function LuaGeometry.GetTempColor(r, g, b, a, tarColor)
  tarColor = tarColor or LuaGeometry.tmpColor
  if tarColor:Alive() then
    LuaColor.Better_Set(tarColor, r or 1, g or 1, b or 1, a or 1)
  else
    tarColor = LuaColor(r or 1, g or 1, b or 1, a or 1)
  end
  return tarColor
end

function LuaGeometry.GetTempColorByHtml(str, defaultR, defaultG, defaultB, defaultA, tarColor)
  local suc, r, g, b, a = LuaColor.TryParseHtmlString(str)
  if not suc then
    redlog("Failed to parse html: " .. str)
    r, g, b, a = defaultR, defaultG, defaultB, defaultA
  end
  return LuaGeometry.GetTempColor(r, g, b, a, tarColor)
end

function LuaGeometry.TempGetPosition(transform, tarVector)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempVector3(0, 0, 0, tarVector)
  end
  local x, y, z = LuaGameObject.GetPosition(transform)
  return LuaGeometry.GetTempVector3(x, y, z, tarVector)
end

function LuaGeometry.TempGetLocalPosition(transform, tarVector)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempVector3(0, 0, 0, tarVector)
  end
  local x, y, z = LuaGameObject.GetLocalPosition(transform)
  return LuaGeometry.GetTempVector3(x, y, z, tarVector)
end

function LuaGeometry.TempGetLocalPosition(transform, tarVector)
  if not transform then
    return
  end
  local x, y, z = LuaGameObject.GetLocalPosition(transform)
  return LuaGeometry.GetTempVector3(x, y, z, tarVector)
end

function LuaGeometry.TempGetRotation(transform, tarQuaternion)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempQuaternion(0, 0, 0, 1, tarQuaternion)
  end
  local x, y, z, w = LuaGameObject.GetRotation(transform)
  return LuaGeometry.GetTempQuaternion(x, y, z, w, tarQuaternion)
end

function LuaGeometry.TempGetLocalRotation(transform, tarQuaternion)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempQuaternion(0, 0, 0, 1, tarQuaternion)
  end
  local x, y, z, w = LuaGameObject.GetLocalRotation(transform)
  return LuaGeometry.GetTempQuaternion(x, y, z, w, tarQuaternion)
end

function LuaGeometry.TempGetEulerAngles(transform, tarVector)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempVector3(0, 0, 0, tarVector)
  end
  local x, y, z = LuaGameObject.GetEulerAngles(transform)
  return LuaGeometry.GetTempVector3(x, y, z, tarVector)
end

function LuaGeometry.TempGetLocalEulerAngles(transform, tarVector)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempVector3(0, 0, 0, tarVector)
  end
  local x, y, z = LuaGameObject.GetLocalEulerAngles(transform)
  return LuaGeometry.GetTempVector3(x, y, z, tarVector)
end

function LuaGeometry.TempGetLocalScale(transform, tarVector)
  if not transform then
    LogUtility.Error("transform is nil!")
    return LuaGeometry.GetTempVector3(0, 0, 0, tarVector)
  end
  local x, y, z = LuaGameObject.GetLocalScale(transform)
  return LuaGeometry.GetTempVector3(x, y, z, tarVector)
end

function LuaGeometry.BoundContainsPoint(localPos, center, extents)
  local cx = center[1] or 0
  local cy = center[2] or 0
  local cz = center[3] or 0
  local ex = extents[1] or 0
  local ey = extents[2] or 0
  local ez = extents[3] or 0
  local x = localPos[1] or 0
  local y = localPos[2] or 0
  local z = localPos[3] or 0
  x = math.abs(x - cx) - ex
  y = math.abs(y - cy) - ey
  z = math.abs(z - cz) - ez
  return x <= 0 and y <= 0 and z <= 0
end

function LuaGeometry.SphereContainsPoint(localPos, center, radius)
  local cx = center[1] or 0
  local cy = center[2] or 0
  local cz = center[3] or 0
  local x = (localPos[1] or 0) - cx
  local y = (localPos[2] or 0) - cy
  local z = (localPos[3] or 0) - cz
  return x * x + y * y + z * z <= radius * radius
end

function LuaGeometry.GetCubeBlendFactor(localPos, center, extents, blendDistance)
  local cx = center[1] or 0
  local cy = center[2] or 0
  local cz = center[3] or 0
  local ex = extents[1] or 0
  local ey = extents[2] or 0
  local ez = extents[3] or 0
  local x = localPos[1] or 0
  local y = localPos[2] or 0
  local z = localPos[3] or 0
  x = math.abs(x - cx) - ex
  y = math.abs(y - cy) - ey
  z = math.abs(z - cz) - ez
  if x <= 0 and y <= 0 and z <= 0 then
    return 1.0
  end
  local maxd = math.max(x, math.max(y, z))
  if blendDistance < maxd then
    return 0
  end
  return (blendDistance - maxd) / blendDistance
end

function LuaGeometry.GetSphereBlendFactor(localPos, center, radius, blendDistance)
  local cx = center[1] or 0
  local cy = center[2] or 0
  local cz = center[3] or 0
  local x = (localPos[1] or 0) - cx
  local y = (localPos[2] or 0) - cy
  local z = (localPos[3] or 0) - cz
  local d = math.sqrt(x * x + y * y + z * z)
  d = d - radius
  if d <= 0 then
    return 1.0
  elseif blendDistance < d then
    return 0
  else
    return (blendDistance - d) / blendDistance
  end
end

function LuaGeometry.CloneMatrix4x4(srcMat)
  return {
    {
      srcMat[1][1],
      srcMat[1][2],
      srcMat[1][3],
      srcMat[1][4]
    },
    {
      srcMat[2][1],
      srcMat[2][2],
      srcMat[2][3],
      srcMat[2][4]
    },
    {
      srcMat[3][1],
      srcMat[3][2],
      srcMat[3][3],
      srcMat[3][4]
    },
    {
      srcMat[4][1],
      srcMat[4][2],
      srcMat[4][3],
      srcMat[4][4]
    }
  }
end

local cross = function(p, a, b)
  return (b[1] - a[1]) * (p[3] - a[3]) - (b[3] - a[3]) * (p[1] - a[1])
end

function LuaGeometry.IsPointInRect_XZ(p, ra, rb, rc, rd)
  return 0 < cross(p, ra, rb) * cross(p, rb, rc) * cross(p, rc, rd) * cross(p, rd, ra)
end
