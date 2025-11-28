BTCubeCollider = class("BTCubeCollider")
local tempLocalPos

function BTCubeCollider:ctor(localCenter, localExtents, worldToLocalMatrix)
  self.center = LuaVector3.New(localCenter[1], localCenter[2], localCenter[3])
  self.extents = LuaVector3.New(localExtents[1], localExtents[2], localExtents[3])
  self.worldToLocalMatrix = LuaGeometry.CloneMatrix4x4(worldToLocalMatrix)
end

function BTCubeCollider:ContainsPoint(worldPos)
  tempLocalPos = tempLocalPos or LuaVector3.Zero()
  LuaVector3.TransformPoint(self.worldToLocalMatrix, worldPos, tempLocalPos)
  return LuaGeometry.BoundContainsPoint(tempLocalPos, self.center, self.extents)
end
