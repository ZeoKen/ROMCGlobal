autoImport("KickAreaUtil")
autoImport("LuaGeometryRay")
InteractPlayerKick = class("InteractPlayerKick")
local SqrDistanceXZ = VectorUtility.DistanceXZ_Square
local ArrowEffectPath = "Common/sfx_common_jiantou_01_prf"
local ArrowOffsetY = 0.05
local KickSendInterval = 0.2
local ArrowBaseLength = 7
local ArrowMaxDistance = 50
local ArrowReflectMaxDistance = 10
local ArrowFallbackSelfRadius = 0.5
local ArrowFallbackTargetRadius = 1
local ArrowHitPadding = 0.2
local ArrowMinLength = 1

function InteractPlayerKick.Create(targetCharid)
  local self = InteractPlayerKick.new()
  self.targetCharid = targetCharid
  return self
end

function InteractPlayerKick:GetTargetArea(target, pos)
  pos = pos or target and target:GetPosition()
  if not pos then
    return nil, nil
  end
  local mapId = SceneProxy.Instance:GetCurMapID()
  if mapId == nil then
    return nil, nil
  end
  local areaId = KickAreaUtil.FindAreaId(mapId, pos[1], pos[3])
  return mapId, areaId
end

function InteractPlayerKick:GetRange(target, pos)
  local mapId, areaId = self:GetTargetArea(target, pos)
  if mapId == nil or areaId == nil then
    return nil
  end
  return KickAreaUtil.GetCheckDistance(mapId, areaId)
end

function InteractPlayerKick:DestroyArrow()
  if self.arrowEffect then
    self.arrowEffect:Destroy()
    self.arrowEffect = nil
  end
  if self.arrowEffect2 then
    self.arrowEffect2:Destroy()
    self.arrowEffect2 = nil
  end
end

function InteractPlayerKick:Destroy()
  self:DestroyArrow()
  self.targetCharid = nil
  self.lastSendTime = nil
end

local _GetCreatureRadius = function(creature)
  local scale = creature.GetDefaultScale and creature:GetDefaultScale() or nil
  if scale ~= nil and tonumber(scale) ~= nil and 0 < scale then
    return scale
  end
  return ArrowFallbackTargetRadius
end
local _IsCollisionAllowed = function(row, c)
  if row == nil then
    return true
  end
  local data = c.data
  if data == nil then
    return true
  end
  if data.IsPlayer ~= nil and data:IsPlayer() then
    if TeamProxy.Instance ~= nil and TeamProxy.Instance:IsInMyTeam(data.id) then
      return row.CollisionTeamPlayer == 1
    end
    if c.IsInMyGroup ~= nil and c:IsInMyGroup() then
      return row.CollisionOtherFriendlyPlayer == 1
    end
    return row.CollisionOtherHostilePlayer == 1
  end
  if data.IsBoss ~= nil and data:IsBoss() or data.IsBossType_Mvp ~= nil and data:IsBossType_Mvp() then
    return row.CollisionMvp == 1
  end
  if data.IsMini ~= nil and data:IsMini() or data.IsBossType_Mini ~= nil and data:IsBossType_Mini() then
    return row.CollisionMini == 1
  end
  if data.IsMonster_Detail ~= nil and data:IsMonster_Detail() then
    return row.CollisionMonster == 1
  end
  return false
end
local _ConsiderCreature = function(c, target, row, selfRadius, startX, startZ, dirX, dirZ, limit)
  if c == nil or c == target or c == Game.Myself then
    return nil
  end
  if c.IsDead ~= nil and c:IsDead() then
    return nil
  end
  if not _IsCollisionAllowed(row, c) then
    return nil
  end
  local p = c:GetPosition()
  if p == nil then
    return nil
  end
  local radius = selfRadius + _GetCreatureRadius(c)
  local ox, oz = startX - p[1], startZ - p[3]
  if ox * ox + oz * oz < radius * radius then
    if -ox * dirX + -oz * dirZ <= 0 then
      return nil
    end
    return 0, -dirX, -dirZ
  end
  return LuaGeometryRay.SegmentHitCircle(startX, startZ, dirX, dirZ, p[1], p[3], radius, limit)
end

function InteractPlayerKick:_CalcHitCreature(target, row, selfRadius, startX, startZ, dirX, dirZ, limit)
  local nearest, nearestNX, nearestNZ = limit
  local searchRange = limit + ArrowFallbackTargetRadius
  local origin = target:GetPosition()
  if origin == nil then
    return nearest, nil, nil
  end
  local users = NSceneUserProxy.Instance:FindNearUsers(origin, searchRange)
  if users ~= nil then
    for i = 1, #users do
      local t, nx, nz = _ConsiderCreature(users[i], target, row, selfRadius, startX, startZ, dirX, dirZ, nearest)
      if t ~= nil then
        nearest, nearestNX, nearestNZ = t, nx, nz
      end
    end
  end
  local npcs = NSceneNpcProxy.Instance:FindNearNpcs(origin, searchRange)
  if npcs ~= nil then
    for i = 1, #npcs do
      local t, nx, nz = _ConsiderCreature(npcs[i], target, row, selfRadius, startX, startZ, dirX, dirZ, nearest)
      if t ~= nil then
        nearest, nearestNX, nearestNZ = t, nx, nz
      end
    end
  end
  return nearest, nearestNX, nearestNZ
end

function InteractPlayerKick:_CalcArrowHit(target, startX, startY, startZ, dirX, dirZ, limit)
  local mapId = SceneProxy.Instance:GetCurMapID()
  local row
  if mapId ~= nil then
    row = KickAreaUtil.GetRule(mapId, KickAreaUtil.FindAreaId(mapId, startX, startZ))
  end
  local wallLen, wallNX, wallNZ = KickAreaUtil.RayHitBoundary(row, startX, startZ, dirX, dirZ, limit)
  if wallLen == nil then
    wallLen = limit
  end
  local selfRadius = row and tonumber(row.CollisionRadius) or ArrowFallbackSelfRadius
  local charLen, charNX, charNZ = self:_CalcHitCreature(target, row, selfRadius, startX, startZ, dirX, dirZ, limit)
  local len, nX, nZ
  if wallLen <= charLen then
    len, nX, nZ = wallLen, wallNX, wallNZ
  else
    len, nX, nZ = charLen, charNX, charNZ
  end
  if len <= 0 then
    local minLen = math.min(ArrowMinLength, limit)
    return minLen, startX + dirX * minLen, startZ + dirZ * minLen, nil, nil
  end
  len = math.max(len - ArrowHitPadding, ArrowMinLength)
  return len, startX + dirX * len, startZ + dirZ * len, nX, nZ
end

local _PlaceArrowSegment = function(effect, startX, startY, startZ, dirX, dirZ, len)
  if effect == nil then
    return
  end
  effect:ResetLocalEulerAnglesXYZ(0, math.deg(math.atan2(dirX, dirZ)), 0)
  effect:ResetLocalPositionXYZ(startX, startY, startZ)
  effect:ResetLocalScaleXYZ(1, 1, len / ArrowBaseLength)
end

function InteractPlayerKick:_UpdateArrow(target)
  local targetPos = target:GetPosition()
  local myselfPos = Game.Myself:GetPosition()
  if not targetPos or not myselfPos then
    self:DestroyArrow()
    return
  end
  local dx = targetPos[1] - myselfPos[1]
  local dz = targetPos[3] - myselfPos[3]
  local mag = math.sqrt(dx * dx + dz * dz)
  if mag <= 0 then
    self:DestroyArrow()
    return
  end
  local dirX, dirZ = dx / mag, dz / mag
  local startX = targetPos[1]
  local startY = targetPos[2] + ArrowOffsetY
  local startZ = targetPos[3]
  local limit = ArrowMaxDistance
  local len1, hitX, hitZ, nX1, nZ1 = self:_CalcArrowHit(target, startX, startY, startZ, dirX, dirZ, limit)
  if not self.arrowEffect then
    self.arrowEffect = Asset_Effect.PlayAt(ArrowEffectPath, LuaGeometry.GetTempVector3(startX, startY, startZ))
  end
  _PlaceArrowSegment(self.arrowEffect, startX, startY, startZ, dirX, dirZ, len1)
  local refX, refZ
  if nX1 ~= nil and nZ1 ~= nil and limit > len1 then
    local dot = dirX * nX1 + dirZ * nZ1
    local rx = dirX - 2 * dot * nX1
    local rz = dirZ - 2 * dot * nZ1
    local rmag = math.sqrt(rx * rx + rz * rz)
    if 1.0E-4 < rmag then
      refX, refZ = rx / rmag, rz / rmag
    end
  end
  if refX ~= nil then
    local len2 = self:_CalcArrowHit(target, hitX, startY, hitZ, refX, refZ, ArrowReflectMaxDistance)
    if not self.arrowEffect2 then
      self.arrowEffect2 = Asset_Effect.PlayAt(ArrowEffectPath, LuaGeometry.GetTempVector3(hitX, startY, hitZ))
    end
    _PlaceArrowSegment(self.arrowEffect2, hitX, startY, hitZ, refX, refZ, len2)
  elseif self.arrowEffect2 ~= nil then
    self.arrowEffect2:Destroy()
    self.arrowEffect2 = nil
  end
end

function InteractPlayerKick:Update(time, deltaTime)
  local target = SceneCreatureProxy.FindCreature(self.targetCharid)
  local targetPos = target and target:GetPosition()
  if not (target and targetPos) or target:IsDead() then
    self:DestroyArrow()
    return false
  end
  if target.IsStoneKickMoving ~= nil and target:IsStoneKickMoving() then
    self:DestroyArrow()
    return false
  end
  if Game.Myself:IsDead() or Game.Myself.data:IsControlled() then
    self:DestroyArrow()
    return false
  end
  local range = self:GetRange(target, targetPos)
  if range == nil then
    self:DestroyArrow()
    return false
  end
  local distSq = SqrDistanceXZ(Game.Myself:GetPosition(), targetPos)
  local inRange = distSq <= range * range
  if inRange then
    self:_UpdateArrow(target)
  else
    self:DestroyArrow()
  end
  return inRange
end

function InteractPlayerKick:GetInteractPrompt()
  return ZhString.InteractLocal_IceBlockKick
end

function InteractPlayerKick:GetInteractIcon()
  return nil
end

function InteractPlayerKick:StartInteract()
  local target = SceneCreatureProxy.FindCreature(self.targetCharid)
  if not target or target:IsDead() then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local now = UnityTime
  if self.lastSendTime and now - self.lastSendTime < KickSendInterval then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local myselfPos = Game.Myself:GetPosition()
  local targetPos = target:GetPosition()
  if not myselfPos or not targetPos then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local mapId, areaId = self:GetTargetArea(target, targetPos)
  if mapId == nil or areaId == nil then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local dx = targetPos[1] - myselfPos[1]
  local dz = targetPos[3] - myselfPos[3]
  local mag = math.sqrt(dx * dx + dz * dz)
  if mag <= 0 then
    InteractLocalManager.Me():EndInteract()
    return
  end
  self.lastSendTime = now
  ServiceSceneUser3Proxy.Instance:CallKickRequestUserCmd(self.targetCharid, mapId, areaId, dx / mag, dz / mag)
  InteractLocalManager.Me():EndInteract()
end
