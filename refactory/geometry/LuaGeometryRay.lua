LuaGeometryRay = {}

function LuaGeometryRay.RayHitSegment(sx, sz, dx, dz, ax, az, bx, bz, limit)
  local ex, ez = bx - ax, bz - az
  local rx, rz = ax - sx, az - sz
  local det = ex * dz - dx * ez
  if det == 0 then
    return nil
  end
  local t = (ex * rz - rx * ez) / det
  local u = (dx * rz - dz * rx) / det
  if t < 0 or limit < t or u < 0 or 1 < u then
    return nil
  end
  local nlen = math.sqrt(ex * ex + ez * ez)
  if nlen <= 0 then
    return nil
  end
  local nx, nz = ez / nlen, -ex / nlen
  if 0 < nx * dx + nz * dz then
    nx, nz = -nx, -nz
  end
  return t, nx, nz
end

function LuaGeometryRay.RayHitCircle(sx, sz, dx, dz, cx, cz, r, limit)
  local ox, oz = sx - cx, sz - cz
  local b = ox * dx + oz * dz
  local c = ox * ox + oz * oz - r * r
  local disc = b * b - c
  if disc < 0 then
    return nil
  end
  local sq = math.sqrt(disc)
  local t = -b - sq
  if t < 0 then
    t = -b + sq
  end
  if t < 0 or limit < t then
    return nil
  end
  local hx, hz = sx + dx * t, sz + dz * t
  local nx, nz = hx - cx, hz - cz
  local nlen = math.sqrt(nx * nx + nz * nz)
  if nlen <= 0 then
    nx, nz = -dx, -dz
  else
    nx, nz = nx / nlen, nz / nlen
  end
  return t, nx, nz
end

function LuaGeometryRay.SegmentHitCircle(sx, sz, dx, dz, cx, cz, r, limit)
  local ox, oz = sx - cx, sz - cz
  local c = ox * ox + oz * oz - r * r
  if c < 0 then
    return 0, -dx, -dz
  end
  local b = ox * dx + oz * dz
  local disc = b * b - c
  if disc < 0 then
    return nil
  end
  local t = -b - math.sqrt(disc)
  if t < 0 or limit < t then
    return nil
  end
  local hx, hz = sx + dx * t, sz + dz * t
  local nx, nz = hx - cx, hz - cz
  local nlen = math.sqrt(nx * nx + nz * nz)
  if nlen <= 0 then
    nx, nz = -dx, -dz
  else
    nx, nz = nx / nlen, nz / nlen
  end
  return t, nx, nz
end

return LuaGeometryRay
