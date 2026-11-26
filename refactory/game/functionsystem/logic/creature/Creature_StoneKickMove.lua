autoImport("KickAreaUtil")
Creature_StoneKickMove = class("Creature_StoneKickMove")
local BeStoneBuffType = "BeStone"
local WallMaxField = "WallBounceCount"
local EntityMaxField = "EntityBounceCount"
local KickAction = {
  Start = 1,
  Collision = 2,
  Stop = 3
}
local StoneKickState = {
  Idle = 0,
  Stoned = 1,
  Moving = 2
}
local DirEpsilon = 1.0E-4
local FaceMoveDir = true
local _GetAngleYByDir = function(x, z)
  return GeometryUtils.UniformAngle(math.deg(math.atan2(x, z)))
end
local _GetBuffByType = function(data, buffType)
  if data == nil or buffType == nil or data.GetBuffTypes == nil then
    return nil
  end
  local map = data:GetBuffTypes(buffType)
  if map == nil then
    return nil
  end
  local id = next(map)
  if id == nil then
    return nil
  end
  return Table_Buffer and Table_Buffer[id] or nil
end
local _GetBuffEffectByType = function(data, buffType)
  local buff = _GetBuffByType(data, buffType)
  return buff and buff.BuffEffect or nil
end
local KickEffectField = "KickEffect"
local _PlayOneShotEffect = function(path, x, y, z, dirX, dirZ)
  if path == nil or path == "" then
    return
  end
  local effect = Asset_Effect.PlayOneShotAtXYZ(path, x, y, z)
  if effect ~= nil and dirX ~= nil and dirZ ~= nil then
    local mag = math.sqrt(dirX * dirX + dirZ * dirZ)
    if mag > DirEpsilon then
      effect:ResetLocalEulerAnglesXYZ(0, math.deg(math.atan2(dirX, dirZ)), 0)
    end
  end
end
local _DecodeScenePos = function(pos)
  if pos == nil then
    return nil
  end
  return pos.x or 0, pos.y or 0, pos.z or 0
end
local _DecodeKickState = function(bytes)
  if bytes == nil or bytes == "" then
    return nil
  end
  local parts = string.split(bytes, ",")
  if parts == nil or #parts < 5 then
    return nil
  end
  local data = {
    moving = tonumber(parts[1]) == 1,
    mapId = tonumber(parts[2]) or 0,
    areaId = tonumber(parts[3]) or 0,
    dirX = tonumber(parts[4]) or 0,
    dirZ = tonumber(parts[5]) or 0
  }
  if 7 <= #parts then
    data.wallCount = tonumber(parts[6])
    data.entityCount = tonumber(parts[7])
  end
  return data
end

function Creature_StoneKickMove:ctor(owner)
  self.owner = owner
  self.moveDir = LuaVector3.Zero()
  self.stepTarget = LuaVector3.Zero()
  self.tempPos = LuaVector3.Zero()
  self:Reset()
end

function Creature_StoneKickMove:Reset()
  if self.kickable then
    self:_NotifyKickable(false)
  end
  self.kickable = false
  self.state = StoneKickState.Idle
  self.hasLiveNotify = false
  self.mapId = nil
  self.areaId = nil
  self.wallCount = nil
  self.entityCount = nil
  self.kickEffect = nil
  LuaVector3.Better_Set(self.moveDir, 0, 0, 0)
  self._lastUpdateCallTime = nil
end

function Creature_StoneKickMove:_GetCharid()
  local owner = self.owner
  return owner and owner.data and owner.data.id or nil
end

function Creature_StoneKickMove:IsMoving()
  return self.state == StoneKickState.Moving
end

function Creature_StoneKickMove:_GetSpeed()
  local mapId = self.mapId
  local areaId = self.areaId
  if mapId == nil or areaId == nil then
    return 0
  end
  return KickAreaUtil.GetMoveSpeed(mapId, areaId) or 0
end

function Creature_StoneKickMove:_GetKickEffect()
  if self.kickEffect == nil then
    local effect = _GetBuffEffectByType(self.owner and self.owner.data, BeStoneBuffType)
    if effect == nil then
      return nil
    end
    self.kickEffect = effect[KickEffectField] or false
  end
  if type(self.kickEffect) ~= "string" or self.kickEffect == "" then
    return nil
  end
  return self.kickEffect
end

function Creature_StoneKickMove:_IsKickable()
  return _GetBuffEffectByType(self.owner and self.owner.data, BeStoneBuffType) ~= nil
end

function Creature_StoneKickMove:_RefreshKickable()
  local want = self:_IsKickable()
  if want == self.kickable then
    return
  end
  self.kickable = want
  self:_NotifyKickable(want)
end

function Creature_StoneKickMove:_NotifyKickable(enable)
  local charid = self:_GetCharid()
  if charid == nil then
    return
  end
  if enable then
    EventManager.Me():PassEvent(SkillEvent.IceBlockKickableAdd, {charid = charid})
  else
    EventManager.Me():PassEvent(SkillEvent.IceBlockKickableRemove, {charid = charid})
  end
end

function Creature_StoneKickMove:_GetBounceMax()
  local effect = _GetBuffEffectByType(self.owner and self.owner.data, BeStoneBuffType)
  if effect == nil then
    return nil, nil
  end
  return tonumber(effect[WallMaxField]) or 0, tonumber(effect[EntityMaxField]) or 0
end

function Creature_StoneKickMove:_RefreshCountUI()
  local owner = self.owner
  if owner == nil or owner.UpdateIceBlockCount == nil then
    return
  end
  local wallMax, entityMax = self:_GetBounceMax()
  if wallMax == nil then
    self:_ClearCountUI()
    return
  end
  local wall = self.wallCount
  local entity = self.entityCount
  if wall == nil then
    wall = wallMax
  end
  if entity == nil then
    entity = entityMax
  end
  owner:UpdateIceBlockCount(wall, entity, wallMax, entityMax)
end

function Creature_StoneKickMove:_ClearCountUI()
  local owner = self.owner
  if owner == nil or owner.ClearIceBlockCountUI == nil then
    return
  end
  owner:ClearIceBlockCountUI()
end

function Creature_StoneKickMove:_PlaySealIdle()
  local owner = self.owner
  if owner == nil or owner.Logic_PlayIdleForce == nil then
    return
  end
  owner:Logic_PlayIdleForce()
end

function Creature_StoneKickMove:OnBuffChanged(buffType)
  if buffType ~= BeStoneBuffType then
    return
  end
  local hasBeStone = _GetBuffEffectByType(self.owner and self.owner.data, BeStoneBuffType) ~= nil
  if hasBeStone then
    self:_PlaySealIdle()
  end
  if not hasBeStone then
    self.hasLiveNotify = false
  end
  self:_RefreshKickable()
  self:_RefreshCountUI()
end

function Creature_StoneKickMove:_PlaceTo(x, y, z)
  local owner = self.owner
  if owner == nil then
    return
  end
  LuaVector3.Better_Set(self.tempPos, x, y, z)
  owner:Logic_NavMeshPlaceTo(self.tempPos)
end

function Creature_StoneKickMove:_ApplyDir(dirX, dirZ)
  local dx, dz = tonumber(dirX), tonumber(dirZ)
  if dx == nil or dz == nil then
    return
  end
  local mag = math.sqrt(dx * dx + dz * dz)
  if mag <= DirEpsilon then
    return
  end
  LuaVector3.Better_Set(self.moveDir, dx / mag, 0, dz / mag)
  local owner = self.owner
  if FaceMoveDir and owner ~= nil and owner.Logic_SetAngleY ~= nil then
    owner:Logic_SetAngleY(_GetAngleYByDir(self.moveDir[1], self.moveDir[3]), true)
  end
end

function Creature_StoneKickMove:_SetState(newState)
  if self.state == newState then
    return
  end
  self.state = newState
  if newState == StoneKickState.Moving then
    local lt = self.owner and self.owner.logicTransform
    if lt ~= nil then
      lt:StopMove()
    end
    self._lastUpdateCallTime = nil
  end
  self:_RefreshKickable()
end

function Creature_StoneKickMove:_StopMoving()
  self:_SetState(StoneKickState.Stoned)
  LuaVector3.Better_Set(self.moveDir, 0, 0, 0)
end

function Creature_StoneKickMove:ApplyUserData(bytes)
  local owner = self.owner
  if owner == nil then
    return
  end
  local data = _DecodeKickState(bytes)
  if data == nil then
    self:_StopMoving()
    return
  end
  if self.hasLiveNotify then
    return
  end
  self.mapId = data.mapId
  self.areaId = data.areaId
  if data.wallCount ~= nil then
    self.wallCount = data.wallCount
  end
  if data.entityCount ~= nil then
    self.entityCount = data.entityCount
  end
  if not data.moving then
    self:_StopMoving()
    self:_RefreshCountUI()
    return
  end
  self:_ApplyDir(data.dirX, data.dirZ)
  self:_RefreshCountUI()
  self:_SetState(StoneKickState.Moving)
end

function Creature_StoneKickMove:ApplyNotify(msg)
  local owner = self.owner
  if owner == nil or msg == nil then
    return
  end
  local action = tonumber(msg.action)
  if action == nil then
    return
  end
  self.hasLiveNotify = true
  if msg.map_id ~= nil then
    self.mapId = tonumber(msg.map_id) or self.mapId
  end
  if msg.area_id ~= nil then
    self.areaId = tonumber(msg.area_id) or self.areaId
  end
  if msg.wall_bounce_count ~= nil then
    self.wallCount = tonumber(msg.wall_bounce_count)
  end
  if msg.entity_bounce_count ~= nil then
    self.entityCount = tonumber(msg.entity_bounce_count)
  end
  local posX, posY, posZ = _DecodeScenePos(msg.current_pos)
  if action == KickAction.Start then
    self:_OnStart(posX, posY, posZ, msg)
  elseif action == KickAction.Collision then
    self:_OnCollision(posX, posY, posZ, msg)
  elseif action == KickAction.Stop then
    self:_OnStop(posX, posY, posZ, msg)
  end
end

function Creature_StoneKickMove:_OnStart(posX, posY, posZ, msg)
  self:_RefreshCountUI()
  local dirX = msg.move_dir_x
  local dirZ = msg.move_dir_z
  if dirX == nil then
    dirX = msg.kick_start_dir_x
  end
  if dirZ == nil then
    dirZ = msg.kick_start_dir_z
  end
  self:_ApplyDir(dirX, dirZ)
  if posX ~= nil then
    self:_PlaceTo(posX, posY, posZ)
    _PlayOneShotEffect(self:_GetKickEffect(), posX, posY, posZ, self.moveDir[1], self.moveDir[3])
  end
  self:_SetState(StoneKickState.Moving)
end

function Creature_StoneKickMove:_OnCollision(posX, posY, posZ, msg)
  local inDirX, inDirZ = self.moveDir[1], self.moveDir[3]
  if posX ~= nil then
    self:_PlaceTo(posX, posY, posZ)
    _PlayOneShotEffect(self:_GetKickEffect(), posX, posY, posZ, inDirX, inDirZ)
  end
  self:_ApplyDir(msg.move_dir_x, msg.move_dir_z)
  self:_RefreshCountUI()
  self:_SetState(StoneKickState.Moving)
end

function Creature_StoneKickMove:_OnStop(posX, posY, posZ, msg)
  if posX ~= nil then
    self:_PlaceTo(posX, posY, posZ)
    _PlayOneShotEffect(self:_GetKickEffect(), posX, posY, posZ, self.moveDir[1], self.moveDir[3])
  end
  self:_RefreshCountUI()
  self:_StopMoving()
end

function Creature_StoneKickMove:Update(time, deltaTime)
  if self.state ~= StoneKickState.Moving then
    return
  end
  local owner = self.owner
  if owner == nil then
    return
  end
  deltaTime = deltaTime or 0
  local now = time
  if now ~= nil then
    if self._lastUpdateCallTime ~= nil then
      local realDt = now - self._lastUpdateCallTime
      if 0 < realDt then
        deltaTime = realDt
      end
    end
    self._lastUpdateCallTime = now
  end
  local p = owner:GetPosition()
  if p == nil then
    return
  end
  local speed = self:_GetSpeed()
  if speed <= 0 then
    return
  end
  local dx = self.moveDir[1] * speed * deltaTime
  local dz = self.moveDir[3] * speed * deltaTime
  if dx == 0 and dz == 0 then
    return
  end
  LuaVector3.Better_Set(self.stepTarget, (p[1] or 0) + dx, p[2] or 0, (p[3] or 0) + dz)
  owner:Logic_NavMeshPlaceTo(self.stepTarget)
end
