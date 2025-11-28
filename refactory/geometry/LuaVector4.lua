LuaVector4 = class("LuaVector4")

function LuaVector4.CreateZero()
  return LuaVector.Create(0, 0, 0, 0)
end

function LuaVector4.CreateOne()
  return LuaVector.Create(1, 1, 1, 1)
end

function LuaVector4.Equal(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

function LuaVector4.TransformPoint(mat, vec3, outVec3)
  if mat == nil or vec3 == nil then
    return
  end
  if outVec3 == nil then
    outVec3 = {}
  end
  local row1 = mat[1]
  local row2 = mat[2]
  local row3 = mat[3]
  local row4 = mat[4]
  outVec3[1] = row1[1] * vec3[1] + row1[2] * vec3[2] + row1[3] * vec3[3] + row1[4]
  outVec3[2] = row2[1] * vec3[1] + row2[2] * vec3[2] + row2[3] * vec3[3] + row2[4]
  outVec3[3] = row3[1] * vec3[1] + row3[2] * vec3[2] + row3[3] * vec3[3] + row3[4]
  return outVec3
end
