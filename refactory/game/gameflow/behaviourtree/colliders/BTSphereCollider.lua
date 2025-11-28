BTSphereCollider = class("BTSphereCollider")
local tempLocalPos

function BTSphereCollider:ctor(localCenter, localRadius, worldToLocalMatrix)
  self.center = LuaVector3.New(localCenter[1], localCenter[2], localCenter[3])
  self.radius = localRadius or 0
  self.worldToLocalMatrix = LuaGeometry.CloneMatrix4x4(worldToLocalMatrix)
end

function BTSphereCollider:ContainsPoint(worldPos)
  tempLocalPos = tempLocalPos or LuaVector3.Zero()
  LuaVector3.TransformPoint(self.worldToLocalMatrix, worldPos, tempLocalPos)
  return LuaGeometry.SphereContainsPoint(tempLocalPos, self.center, self.radius)
end
