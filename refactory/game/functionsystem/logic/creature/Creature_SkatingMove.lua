Creature_SkatingMove = class("Creature_SkatingMove")
local SkatingBuffType = "IceSlide"
local SkatingDefaultMinSpeed = 0.5
local SkatingDirEpsilon = 1.0E-4
local SkatingDefaultFriction = 1
local SkatingDefaultBrakeFrictionFactor = 3
local SkatingArriveThreshold = 0.3
local SkatingRemoteStartArriveDistSq = 1
local SkatingBrakeMinSpeed = 1.0
local SkatingBrakeCosThreshold = -0.77
local SkatingBrakeFriction = 5
local IsSkatingDirValid = function(dir)
  return dir ~= nil and (math.abs(dir[1]) > SkatingDirEpsilon or math.abs(dir[3]) > SkatingDirEpsilon)
end
local IsOwnerInSkillAction = function(owner)
  local skill = owner and owner.skill
  return skill ~= nil and skill:IsCastingSkill()
end
local _GetOwnerMoveSpd = function(owner)
  local prop = owner.data.props:GetPropByName("MoveSpd")
  return prop and prop:GetValue() or nil
end
local _GetAngleYByDir = function(x, z)
  return GeometryUtils.UniformAngle(math.deg(math.atan2(x, z)))
end
local _GetBrakeFrictionFactor = function()
  local config = GameConfig.IceSlide
  local factor = config and config.BrakeFrictionFactor or SkatingDefaultBrakeFrictionFactor
  return factor
end

function Creature_SkatingMove:GetMinSpeed()
  local normalSpeed = _GetOwnerMoveSpd(self.owner) or 0
  local configMinSpeed = GameConfig.IceSlide and GameConfig.IceSlide.MinSpeed or SkatingDefaultMinSpeed
  return math.max(normalSpeed * 0.3, configMinSpeed)
end

function Creature_SkatingMove:ctor(owner)
  self.owner = owner
  self.dir = LuaVector3.Zero()
  self.moveDir = LuaVector3.Zero()
  self.tempDir = LuaVector3.Zero()
  self.stepTarget = LuaVector3.Zero()
  self.rotateDir = LuaVector3.Zero()
  self.buffMap = {}
  self.userInputDir = LuaVector3.Zero()
  self.moveToTarget = nil
  self.moveToForwardDir = LuaVector3.Zero()
  self.inputActive = false
  self.brakingForTarget = false
  self.maxSpeedFactor = 1
  self.velocity = LuaVector3.Zero()
  self.controlledGlide = false
  self:Reset()
  SkatingBrakeFriction = GameConfig and GameConfig.IceSlide and GameConfig.IceSlide.BrakeFriction or 5
end

function Creature_SkatingMove:Reset()
  if self.iceSlideStopSynced == false then
    self:_NotifyIceSlideStop(true)
  end
  self.iceSlideStopSynced = true
  self.active = false
  self.gliding = false
  self.speed = 0
  self.friction = 0
  self.braking = false
  self.buffID = nil
  LuaVector3.Better_Set(self.dir, 0, 0, 0)
  LuaVector3.Better_Set(self.moveDir, 0, 0, 0)
  for k in pairs(self.buffMap) do
    self.buffMap[k] = nil
  end
  LuaVector3.Better_Set(self.userInputDir, 0, 0, 0)
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.inputActive = false
  self.brakingForTarget = false
  LuaVector3.Better_Set(self.velocity, 0, 0, 0)
  self.pendingStart = nil
  self.glidingCmdPushed = false
end

function Creature_SkatingMove:InterruptGlide()
  LuaVector3.Better_Set(self.velocity, 0, 0, 0)
  LuaVector3.Better_Set(self.dir, 0, 0, 0)
  LuaVector3.Better_Set(self.moveDir, 0, 0, 0)
  LuaVector3.Better_Set(self.userInputDir, 0, 0, 0)
  self.inputActive = false
  self.brakingForTarget = false
  self.braking = false
  self.speed = 0
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.pendingStart = nil
  self.glidingCmdPushed = false
  if self.gliding then
    self:StopGlide(self:IsMyself(), true)
  end
end

function Creature_SkatingMove:IsGliding()
  return self.gliding == true
end

function Creature_SkatingMove:IsChasing()
  return self.active and self.moveToTarget ~= nil
end

function Creature_SkatingMove:ExitGlideHandoff()
  self.gliding = false
  self.braking = false
  self.glidingCmdPushed = false
end

function Creature_SkatingMove:_PushGlidingCommand()
  if self.glidingCmdPushed then
    return
  end
  local owner = self.owner
  if owner == nil or owner.ai == nil then
    return
  end
  self.glidingCmdPushed = true
  owner.ai:PushCommand(FactoryAICMD.GetGlidingCmd(), owner)
end

function Creature_SkatingMove:SetMaxSpeedFactor(factor)
  self.maxSpeedFactor = factor or 1
end

function Creature_SkatingMove:_SetDesiredDir(x, z)
  LuaVector3.Better_Set(self.userInputDir, x, 0, z)
  LuaVector3.Better_Set(self.dir, x, 0, z)
end

function Creature_SkatingMove:_GetFaceDir(moveDir)
  if self.inputActive and IsSkatingDirValid(self.userInputDir) then
    return self.userInputDir
  end
  if IsSkatingDirValid(self.dir) then
    return self.dir
  end
  return moveDir
end

function Creature_SkatingMove:_RefreshMoveAction(owner)
  if self.controlledGlide then
    return
  end
  if self.inputActive then
    if not owner.assetRole:IsPlayingAction(owner:GetMoveAction()) then
      owner:Logic_PlayAction_Move(nil, true)
    end
  elseif owner.assetRole:IsPlayingAction(owner:GetMoveAction()) then
    owner:Logic_PlayAction_Idle()
  end
end

function Creature_SkatingMove:_NeedBrakeForDesiredDir(x, z)
  local vx, vz = self.velocity[1] or 0, self.velocity[3] or 0
  local vmag = math.sqrt(vx * vx + vz * vz)
  if vmag <= SkatingBrakeMinSpeed then
    return false
  end
  local dmag = math.sqrt(x * x + z * z)
  if dmag <= SkatingDirEpsilon then
    return false
  end
  local cosAngle = (vx * x + vz * z) / (vmag * dmag)
  return cosAngle < SkatingBrakeCosThreshold
end

function Creature_SkatingMove:GetMaxSpeed()
  local owner = self.owner
  if owner == nil or owner.data == nil then
    return 0
  end
  local baseSpeed = owner.data:ReturnMoveSpeedWithFactor(_GetOwnerMoveSpd(owner))
  return baseSpeed * (self.maxSpeedFactor or 1)
end

function Creature_SkatingMove:IsMyself()
  return self.owner ~= nil and self.owner == Game.Myself
end

function Creature_SkatingMove:_NotifyIceSlideStop(stop)
  if not self:IsMyself() then
    return
  end
  stop = stop == true
  if self.iceSlideStopSynced == stop then
    return
  end
  local pos, dir, speed = self:_GetIceSlideSyncSnapshot(stop)
  if not stop and (pos == nil or dir == nil or speed <= self:GetMinSpeed()) then
    return
  end
  self.iceSlideStopSynced = stop
  ServiceSceneUser3Proxy.Instance:CallUserIceSlideStopUserCmd(pos, dir, speed, stop)
end

function Creature_SkatingMove:_GetIceSlideSyncSnapshot(stop)
  local owner = self.owner
  if owner == nil then
    return nil, nil, 0
  end
  local pos = owner:GetPosition()
  local vx = self.velocity[1] or 0
  local vz = self.velocity[3] or 0
  local speed = math.sqrt(vx * vx + vz * vz)
  local dir
  if speed > SkatingDirEpsilon then
    dir = _GetAngleYByDir(vx, vz)
  elseif IsSkatingDirValid(self.dir) then
    dir = _GetAngleYByDir(self.dir[1], self.dir[3])
  elseif owner.GetAngleY ~= nil then
    dir = owner:GetAngleY()
  elseif owner.logicTransform ~= nil then
    dir = owner.logicTransform.currentAngleY
  end
  return pos, dir, speed
end

function Creature_SkatingMove:ApplyRemoteIceSlideSync(pos, dir, speed, stop)
  if self:IsMyself() then
    return
  end
  local owner = self.owner
  if owner == nil then
    return
  end
  stop = stop == true
  speed = speed or 0
  if stop then
    if self.pendingStart ~= nil then
      self.pendingStart = nil
      return
    end
    self.inputActive = false
    self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
    LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
    self.brakingForTarget = false
    LuaVector3.Better_Set(self.velocity, 0, 0, 0)
    self.gliding = false
    self.speed = 0
    self.iceSlideStopSynced = true
    self:_ResetMoveSpeedByData()
    if owner.Logic_StopMove ~= nil then
      owner:Logic_StopMove()
    end
    if owner.Logic_PlayAction_Idle ~= nil then
      owner:Logic_PlayAction_Idle()
    end
    return
  end
  if dir == nil or speed <= self:GetMinSpeed() then
    return
  end
  self:_SetPendingStart(pos, dir, speed)
end

function Creature_SkatingMove:_SetPendingStart(pos, dir, speed)
  local ps = self.pendingStart
  if ps == nil then
    ps = {}
    self.pendingStart = ps
  end
  if pos ~= nil then
    ps.pos = ps.pos or LuaVector3.Zero()
    LuaVector3.Better_Set(ps.pos, pos[1] or pos.x or 0, pos[2] or pos.y or 0, pos[3] or pos.z or 0)
  else
    ps.pos = nil
  end
  ps.dir = dir
  ps.speed = speed
end

function Creature_SkatingMove:_TryStartPending()
  local ps = self.pendingStart
  local owner = self.owner
  if ps == nil or owner == nil then
    return
  end
  if ps.pos ~= nil then
    local p = owner:GetPosition()
    if p ~= nil then
      local dx = ps.pos[1] - (p[1] or 0)
      local dz = ps.pos[3] - (p[3] or 0)
      if dx * dx + dz * dz > SkatingRemoteStartArriveDistSq then
        return
      end
    end
  end
  self.pendingStart = nil
  self:_StartGlideNow(ps.dir, ps.speed)
end

function Creature_SkatingMove:_StartGlideNow(dir, speed)
  local owner = self.owner
  if owner == nil then
    return
  end
  local wasActive = self.active
  self.active = true
  if self.friction <= 0 then
    self.friction = SkatingDefaultFriction
  end
  self.inputActive = false
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.brakingForTarget = false
  local rad = dir * math.pi / 180
  self.velocity[1] = speed * math.sin(rad)
  self.velocity[2] = 0
  self.velocity[3] = speed * math.cos(rad)
  LuaVector3.Better_Set(self.dir, math.sin(rad), 0, math.cos(rad))
  self.gliding = true
  self.speed = speed
  self.iceSlideStopSynced = false
  owner:Logic_StopMove()
  if not wasActive then
    owner:Logic_SetAngleY(dir, true)
  end
end

function Creature_SkatingMove:_ResetMoveSpeedByData()
  local owner = self.owner
  owner.logicTransform:SetMoveSpeed(owner.data:ReturnMoveSpeedWithFactor(_GetOwnerMoveSpd(owner)))
end

function Creature_SkatingMove:_GetFriction(buffeffect, level)
  local owner = self.owner
  local friction = buffeffect and buffeffect.friction
  if friction == nil then
    return SkatingDefaultFriction
  end
  if type(friction) == "number" then
    return friction
  end
  if owner ~= nil and owner.data ~= nil and type(friction) == "table" and friction.type ~= nil then
    return CommonFun.calcBuffValue(owner.data, owner.data, friction.type, friction.a, friction.b, friction.c, friction.d, level, 0) or SkatingDefaultFriction
  end
  return SkatingDefaultFriction
end

function Creature_SkatingMove:_UseBuff(buffID, buffeffect, level)
  local wasActive = self.active
  self.active = true
  self.buffID = buffID
  self.friction = math.max(0, self:_GetFriction(buffeffect, level))
  if not wasActive then
    local owner = self.owner
    if owner ~= nil and owner.logicTransform ~= nil then
      local curSpeed = owner.logicTransform:GetMoveSpeed() or 0
      if owner:Client_IsMoveToWorking() then
        local angleY = owner.logicTransform.currentAngleY or 0
        local rad = angleY * math.pi / 180
        self.velocity[1] = curSpeed * math.sin(rad)
        self.velocity[3] = curSpeed * math.cos(rad)
        self:PrepareMoveTo(self.owner.logicTransform.targetPosition)
      elseif owner:Client_IsDirMoving() then
        local angleY = owner.logicTransform.currentAngleY or 0
        local rad = angleY * math.pi / 180
        self.velocity[1] = curSpeed * math.sin(rad)
        self.velocity[3] = curSpeed * math.cos(rad)
        self.inputActive = true
      end
    end
  end
end

function Creature_SkatingMove:_RefreshActiveBuff()
  for buffID, data in pairs(self.buffMap) do
    self:_UseBuff(buffID, data.buffeffect, data.level)
    return true
  end
  local wasInputActive = self.inputActive
  self.active = false
  self.buffID = nil
  self.friction = 0
  LuaVector3.Better_Set(self.dir, 0, 0, 0)
  LuaVector3.Better_Set(self.moveDir, 0, 0, 0)
  LuaVector3.Better_Set(self.velocity, 0, 0, 0)
  LuaVector3.Better_Set(self.userInputDir, 0, 0, 0)
  self.inputActive = false
  local bMyself = self:IsMyself()
  if bMyself and self.moveToTarget ~= nil then
    self.owner:Client_MoveTo(self.moveToTarget)
  end
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.brakingForTarget = false
  self:StopGlide(bMyself, true)
  self:_ResetMoveSpeedByData()
  return false
end

function Creature_SkatingMove:UpdateBuff(buffInfo, active, level)
  if buffInfo == nil then
    return
  end
  local buffeffect = buffInfo.BuffEffect
  if buffeffect == nil or buffeffect.type ~= SkatingBuffType then
    return
  end
  local buffID = buffInfo.id
  if buffID == nil then
    return
  end
  if active ~= false then
    self.buffMap[buffID] = {buffeffect = buffeffect, level = level}
    self:_UseBuff(buffID, buffeffect, level)
  else
    self.buffMap[buffID] = nil
    if self.buffID == buffID then
      self:_RefreshActiveBuff()
    end
  end
end

function Creature_SkatingMove:StopGlide(syncStop, stopAction, keepCurrentMove, clearVelocity)
  local owner = self.owner
  local wasGliding = self.gliding
  self.gliding = false
  self.glidingCmdPushed = false
  self.braking = false
  self.speed = 0
  if wasGliding then
    self:_NotifyIceSlideStop(true)
    if clearVelocity then
      LuaVector3.Better_Set(self.velocity, 0, 0, 0)
    end
    self:_ResetMoveSpeedByData()
  end
  if owner == nil then
    return
  end
  if wasGliding and not keepCurrentMove then
    if self:IsMyself() and owner.logicTransform ~= nil then
      owner.logicTransform:StopMove()
    else
      owner:Logic_StopMove()
    end
  end
  if wasGliding then
    if syncStop and self:IsMyself() then
      owner:Client_MoveHandler(owner:GetPosition(), true)
    end
    if stopAction then
      owner:RemoveWalkEffect()
      if not IsOwnerInSkillAction(owner) then
        owner:Logic_PlayAction_Idle()
      end
    end
  end
end

function Creature_SkatingMove:PrepareDirInput(dir, keepCurrentMove)
  if not self.active then
    return dir
  end
  self:StopGlide(false, false, keepCurrentMove)
  local nx, nz = dir[1] or 0, dir[3] or 0
  local mag = math.sqrt(nx * nx + nz * nz)
  if mag <= SkatingDirEpsilon then
    return dir
  end
  nx, nz = nx / mag, nz / mag
  local needBrake = self:_NeedBrakeForDesiredDir(nx, nz)
  self:_SetDesiredDir(nx, nz)
  self.inputActive = true
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.brakingForTarget = needBrake
  return self.dir
end

function Creature_SkatingMove:PrepareMoveTo(targetPos)
  if not self.active then
    return
  end
  local owner = self.owner
  if owner == nil then
    return
  end
  self:StopGlide(false, false, true)
  LuaVector3.Better_Sub(targetPos, owner:GetPosition(), self.tempDir)
  self.tempDir[2] = 0
  if not IsSkatingDirValid(self.tempDir) then
    return
  end
  LuaVector3.Normalized(self.tempDir)
  self:_SetDesiredDir(self.tempDir[1], self.tempDir[3])
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  self.moveToTarget = LuaVector3.New(targetPos[1], targetPos[2], targetPos[3])
  LuaVector3.Better_Set(self.moveToForwardDir, self.tempDir[1], 0, self.tempDir[3])
  self.brakingForTarget = self:_NeedBrakeForDesiredDir(self.tempDir[1], self.tempDir[3])
  self.inputActive = true
end

function Creature_SkatingMove:MarkMoveToArrived()
end

function Creature_SkatingMove:OnDirInputEnd()
  self.inputActive = false
  if not (self.owner ~= nil and self.active) or not IsSkatingDirValid(self.dir) then
    return false
  end
  self.gliding = true
  self:_NotifyIceSlideStop(false)
  return true
end

function Creature_SkatingMove:OnMoveToEnd()
  return false
end

function Creature_SkatingMove:_StepOnWalkableArea(deltaTime, moveDir, faceDir, stepTarget, rotateDir)
  local owner = self.owner
  if owner == nil or owner.logicTransform == nil then
    return false
  end
  deltaTime = deltaTime or 0
  local moveDistance = owner.logicTransform:GetMoveSpeedWithFastForward() * deltaTime
  if moveDistance <= 0 then
    return true
  end
  local p = owner:GetPosition()
  LuaVector3.Better_Set(self.tempDir, moveDir[1], 0, moveDir[3])
  if not IsSkatingDirValid(self.tempDir) then
    return false
  end
  LuaVector3.Normalized(self.tempDir)
  local ret = NavMeshUtility.Better_RaycastDirection(p, stepTarget, self.tempDir, moveDistance)
  if ret then
    return false
  end
  LuaVector3.Better_Mul(self.tempDir, moveDistance, stepTarget)
  LuaVector3.Better_Add(p, stepTarget, stepTarget)
  ret = NavMeshUtility.Better_Sample(stepTarget, stepTarget, 0.5)
  if not ret then
    return false
  end
  local rotateX, rotateZ = self.tempDir[1], self.tempDir[3]
  if IsSkatingDirValid(faceDir) then
    rotateX, rotateZ = faceDir[1], faceDir[3]
  end
  LuaVector3.Better_Set(rotateDir, p[1] + rotateX, p[2], p[3] + rotateZ)
  owner.logicTransform:RotateTo(rotateDir)
  owner:Logic_NavMeshPlaceTo(stepTarget)
  return true
end

function Creature_SkatingMove:StepDirMove(time, deltaTime, dir, stepTarget, rotateDir)
  return self.active
end

function Creature_SkatingMove:_GetAcceleration(maxSpeed)
  if maxSpeed <= 0 then
    return 0
  end
  return maxSpeed / 0.8
end

function Creature_SkatingMove:_IntegrateVelocity(deltaTime)
  local maxSpeed = self:GetMaxSpeed()
  if maxSpeed <= 0 then
    LuaVector3.Better_Set(self.velocity, 0, 0, 0)
    return
  end
  local accelValue = self:_GetAcceleration(maxSpeed)
  if self.inputActive and not self.brakingForTarget then
    self.velocity[1] = self.velocity[1] + self.userInputDir[1] * accelValue * deltaTime
    self.velocity[3] = self.velocity[3] + self.userInputDir[3] * accelValue * deltaTime
  end
  local friction = self.friction
  if self.brakingForTarget then
    friction = friction * _GetBrakeFrictionFactor()
  end
  local frictionFactor = math.min(1, math.max(0, friction * deltaTime))
  if 0 < frictionFactor then
    local oneMinus = 1 - frictionFactor
    self.velocity[1] = self.velocity[1] * oneMinus
    self.velocity[3] = self.velocity[3] * oneMinus
  end
  local vx, vz = self.velocity[1], self.velocity[3]
  local vmag = math.sqrt(vx * vx + vz * vz)
  if maxSpeed < vmag then
    local scale = maxSpeed / vmag
    self.velocity[1] = vx * scale
    self.velocity[3] = vz * scale
  end
end

function Creature_SkatingMove:_HandleControlledInterrupt(owner)
  self.controlledGlide = false
  if not self:IsMyself() or owner.data == nil or owner.skill == nil then
    return false
  end
  if owner.skill:IsCastingSkill() then
    self:InterruptGlide()
    return true
  end
  if owner:IsDead() then
    self:InterruptGlide()
    return true
  end
  if not owner.data:NoMove() and not owner.data:Freeze() and not owner.data:NoAct() then
    return false
  end
  if not IsSkatingDirValid(self.velocity) then
    self:InterruptGlide()
    return true
  end
  self.inputActive = false
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.brakingForTarget = false
  self.controlledGlide = true
  if not self.gliding then
    self.gliding = true
    self:_NotifyIceSlideStop(false)
  end
  return false
end

function Creature_SkatingMove:_EndMoveToChase()
  self.inputActive = false
  self.moveToTarget = LuaVector3.Destroy(self.moveToTarget)
  LuaVector3.Better_Set(self.moveToForwardDir, 0, 0, 0)
  self.brakingForTarget = false
end

function Creature_SkatingMove:_StopByObstacle()
  LuaVector3.Better_Set(self.velocity, 0, 0, 0)
  LuaVector3.Better_Set(self.moveDir, 0, 0, 0)
  self.speed = 0
  self.brakingForTarget = false
  self.braking = false
  if self.moveToTarget ~= nil then
    self:_EndMoveToChase()
  end
  if self.gliding then
    self:StopGlide(self:IsMyself(), true, nil, true)
  else
    self:_ResetMoveSpeedByData()
  end
end

function Creature_SkatingMove:_UpdateBrakeRelease(owner)
  if not self.brakingForTarget then
    return
  end
  local vx, vz = self.velocity[1], self.velocity[3]
  if math.sqrt(vx * vx + vz * vz) > SkatingBrakeMinSpeed then
    return
  end
  self.brakingForTarget = false
  if self.moveToTarget == nil then
    return
  end
  local p = owner:GetPosition()
  local dx = self.moveToTarget[1] - p[1]
  local dz = self.moveToTarget[3] - p[3]
  local distSq = dx * dx + dz * dz
  if distSq > SkatingDirEpsilon * SkatingDirEpsilon then
    local d = math.sqrt(distSq)
    self:_SetDesiredDir(dx / d, dz / d)
  end
end

function Creature_SkatingMove:_UpdateMoveToChase(owner)
  if self.moveToTarget == nil or not self.inputActive then
    return
  end
  local p = owner:GetPosition()
  local dx = self.moveToTarget[1] - p[1]
  local dz = self.moveToTarget[3] - p[3]
  local dotForward = dx * self.moveToForwardDir[1] + dz * self.moveToForwardDir[3]
  if dotForward <= 0 or dx * dx + dz * dz < SkatingArriveThreshold * SkatingArriveThreshold then
    self:_EndMoveToChase()
  elseif not self.brakingForTarget then
    local d = math.sqrt(dx * dx + dz * dz)
    self:_SetDesiredDir(dx / d, dz / d)
  end
end

function Creature_SkatingMove:Update(time, deltaTime)
  local owner = self.owner
  if owner == nil then
    return
  end
  if self.pendingStart ~= nil then
    self:_TryStartPending()
  end
  if not self.active then
    return
  end
  if self.gliding then
    self:_PushGlidingCommand()
  end
  if self:_HandleControlledInterrupt(owner) then
    return
  end
  self:_UpdateBrakeRelease(owner)
  self:_UpdateMoveToChase(owner)
  local hasVelocity = IsSkatingDirValid(self.velocity)
  if not self.inputActive and not hasVelocity then
    if self.gliding then
      self:StopGlide(self:IsMyself(), true)
    end
    self.speed = 0
    return
  end
  self:_IntegrateVelocity(deltaTime)
  local vx, vz = self.velocity[1], self.velocity[3]
  local vmag = math.sqrt(vx * vx + vz * vz)
  if not self.inputActive and 0 < vmag and vmag <= self:GetMinSpeed() then
    if self.gliding then
      self:StopGlide(self:IsMyself(), true, nil, true)
    else
      LuaVector3.Better_Set(self.velocity, 0, 0, 0)
      self.speed = 0
    end
    return
  end
  self.speed = vmag
  self:_RefreshMoveAction(owner)
  if 0 < vmag then
    if owner.logicTransform ~= nil then
      owner.logicTransform:SetMoveSpeed(vmag)
    end
    LuaVector3.Better_Set(self.moveDir, vx / vmag, 0, vz / vmag)
    if not self:_StepOnWalkableArea(deltaTime, self.moveDir, self:_GetFaceDir(self.moveDir), self.stepTarget, self.rotateDir) then
      self:_StopByObstacle()
      return
    end
    if self:IsMyself() then
      AI_CMD_Myself_DirMoveHelper.NotifyServer(nil, time, deltaTime, owner)
    end
    if not self.inputActive and not self.gliding then
      self.gliding = true
      self:_NotifyIceSlideStop(false)
    end
  else
    if self.gliding then
      self:StopGlide(self:IsMyself(), true)
    end
    self.gliding = false
  end
end
