autoImport("LuaGeometryRay")
KickAreaUtil = {}
local BaseFieldMapId = "MapId"
local BaseFieldAreaId = "AreaId"
local _byMap
local _BuildIndex = function()
  _byMap = {}
  local table_ = Table_KickArea
  if table_ == nil then
    return
  end
  for _, row in pairs(table_) do
    local mapid = tonumber(row and row[BaseFieldMapId])
    if mapid ~= nil then
      local list = _byMap[mapid]
      if list == nil then
        list = {}
        _byMap[mapid] = list
      end
      list[#list + 1] = row
    end
  end
end
local _EnsureIndex = function()
  if _byMap == nil then
    _BuildIndex()
  end
end
local _RowMapId = function(row)
  return tonumber(row and row[BaseFieldMapId])
end
local _RowAreaId = function(row)
  return tonumber(row and row[BaseFieldAreaId])
end
local _PointXZ = function(p)
  if p == nil then
    return nil, nil
  end
  local x = p[1]
  local z = p[3]
  if x == nil then
    x = p.x
  end
  if z == nil then
    z = p.z
  end
  return tonumber(x), tonumber(z)
end
local _IsInsideRect = function(vertices, x, z)
  local n = vertices and #vertices or 0
  if n < 3 then
    return false
  end
  local sign
  for i = 1, n do
    local ax, az = _PointXZ(vertices[i])
    local bx, bz = _PointXZ(vertices[i % n + 1])
    if ax ~= nil and az ~= nil and bx ~= nil and bz ~= nil then
      local cross = (bx - ax) * (z - az) - (bz - az) * (x - ax)
      if cross ~= 0 then
        local positive = 0 < cross
        if sign == nil then
          sign = positive
        elseif sign ~= positive then
          return false
        end
      end
    end
  end
  return true
end
local _IsInsideCircle = function(center, radius, x, z)
  local cx, cz = _PointXZ(center)
  local r = tonumber(radius)
  if cx == nil or cz == nil or r == nil or r <= 0 then
    return false
  end
  local dx, dz = x - cx, z - cz
  return dx * dx + dz * dz <= r * r
end
local _IsInside = function(row, x, z)
  local shape = row and row.Shape
  if shape == "rect" then
    return _IsInsideRect(row.Vertices, x, z)
  elseif shape == "circle" then
    return _IsInsideCircle(row.Center, row.Radius, x, z)
  end
  return false
end

function KickAreaUtil.FindRow(mapid, x, z)
  if mapid == nil or x == nil or z == nil then
    return nil
  end
  _EnsureIndex()
  local list = _byMap[tonumber(mapid)]
  if list == nil then
    return nil
  end
  for i = 1, #list do
    if _IsInside(list[i], x, z) then
      return list[i]
    end
  end
  return nil
end

function KickAreaUtil.FindAreaId(mapid, x, z)
  local row = KickAreaUtil.FindRow(mapid, x, z)
  return row ~= nil and _RowAreaId(row) or nil
end

function KickAreaUtil.GetRule(mapid, areaid)
  if mapid == nil or areaid == nil then
    return nil
  end
  _EnsureIndex()
  local list = _byMap[tonumber(mapid)]
  if list == nil then
    return nil
  end
  local want = tonumber(areaid)
  for i = 1, #list do
    if _RowAreaId(list[i]) == want then
      return list[i]
    end
  end
  return nil
end

function KickAreaUtil.GetCheckDistance(mapid, areaid)
  local row = KickAreaUtil.GetRule(mapid, areaid)
  return row and tonumber(row.StoneKickCheckDistance) or nil
end

function KickAreaUtil.GetMoveSpeed(mapid, areaid)
  local row = KickAreaUtil.GetRule(mapid, areaid)
  local percent = row and tonumber(row.StoneMoveSpeed)
  if percent == nil then
    return nil
  end
  return (CreatureData.MoveSpeedFactor or 1) * percent / 100
end

function KickAreaUtil.RayHitBoundary(row, startX, startZ, dirX, dirZ, limit)
  if row == nil then
    return nil
  end
  local shape = row.Shape
  if shape == "rect" then
    local vertices = row.Vertices
    local n = vertices and #vertices or 0
    if n < 3 then
      return nil
    end
    local nearest, nearestNX, nearestNZ
    for i = 1, n do
      local ax, az = _PointXZ(vertices[i])
      local bx, bz = _PointXZ(vertices[i % n + 1])
      if ax ~= nil and az ~= nil and bx ~= nil and bz ~= nil then
        local t, nx, nz = LuaGeometryRay.RayHitSegment(startX, startZ, dirX, dirZ, ax, az, bx, bz, limit)
        if t ~= nil and (nearest == nil or nearest > t) then
          nearest, nearestNX, nearestNZ = t, nx, nz
        end
      end
    end
    return nearest, nearestNX, nearestNZ
  elseif shape == "circle" then
    local cx, cz = _PointXZ(row.Center)
    local r = tonumber(row.Radius)
    if cx ~= nil and cz ~= nil and r ~= nil and 0 < r then
      return LuaGeometryRay.RayHitCircle(startX, startZ, dirX, dirZ, cx, cz, r, limit)
    end
  end
  return nil
end
