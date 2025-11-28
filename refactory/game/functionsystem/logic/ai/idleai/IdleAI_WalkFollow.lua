IdleAI_WalkFollow = class("IdleAI_WalkFollow")
local Phase_None = 0
local Phase_Follow = 1
local Phase_Idle = 2
local InnerRange = 0.5
local OutterRange = 3

function IdleAI_WalkFollow:ctor()
  self.phase = Phase_None
  self.prevTargetPosition = nil
end

function IdleAI_WalkFollow:Clear(idleElapsed, time, deltaTime, creature)
  self.phase = Phase_None
  if nil ~= self.prevTargetPosition then
    self.prevTargetPosition:Destroy()
    self.prevTargetPosition = nil
  end
end

function IdleAI_WalkFollow:Prepare(idleElapsed, time, deltaTime, creature)
  if nil ~= creature.ai.parent then
    return false
  end
  return true
end

function IdleAI_WalkFollow:Start(idleElapsed, time, deltaTime, creature)
  redlog("IdleAI_WalkFollow:Start", creature.data.id)
  self:_Follow(idleElapsed, time, deltaTime, creature)
end

function IdleAI_WalkFollow:End(idleElapsed, time, deltaTime, creature)
  self.phase = Phase_None
end

local tempV3 = LuaVector3()

function IdleAI_WalkFollow:Update(idleElapsed, time, deltaTime, creature)
  local currentPosition = creature:GetPosition()
  if nil == currentPosition then
    self:_Idle(idleElapsed, time, deltaTime, creature)
    return true
  end
  local targetCreature = creature:Logic_GetFollowTarget()
  if nil == targetCreature then
    self:_Idle(idleElapsed, time, deltaTime, creature)
    return true
  end
  local targetPosition = targetCreature:GetPosition()
  if nil == targetPosition then
    self:_Idle(idleElapsed, time, deltaTime, creature)
    return true
  end
  LuaVector3.Better_SetPos(tempV3, targetPosition)
  local creatureData = creature.data
  local targetOffset = creatureData.followTargetOffset
  if targetOffset then
    LuaVector3.Add(tempV3, targetOffset)
  end
  local innerRange = creatureData.GetInnerRange ~= nil and creatureData:GetInnerRange() or InnerRange
  if nil ~= self.prevTargetPosition then
    local targetChangedDistance = VectorUtility.DistanceXZ(self.prevTargetPosition, tempV3)
    if innerRange > targetChangedDistance then
      self:_Idle(idleElapsed, time, deltaTime, creature)
      return true
    end
  end
  local distance = VectorUtility.DistanceXZ(currentPosition, tempV3)
  if innerRange > distance then
    self:_Idle(idleElapsed, time, deltaTime, creature)
    return true
  end
  local outterRange = creatureData.GetOutterRange ~= nil and creatureData:GetOutterRange() or OutterRange
  if distance > outterRange then
    self:_Follow(idleElapsed, time, deltaTime, creature)
  end
  if Phase_Follow == self.phase then
    local logicTransform = creature.logicTransform
    local prevTargetPosition = logicTransform.targetPosition
    if nil == prevTargetPosition or innerRange < VectorUtility.DistanceXZ(prevTargetPosition, tempV3) then
      local lerpT = 1 - innerRange / distance
      LuaVector3.Better_LerpUnclamped(currentPosition, tempV3, tempV3, lerpT)
      if creature:Logic_NavMeshMoveTo(tempV3) then
        if nil ~= self.prevTargetPosition then
          self.prevTargetPosition:Destroy()
          self.prevTargetPosition = nil
        end
      else
        self.prevTargetPosition = VectorUtility.Asign_3(self.prevTargetPosition, tempV3)
        self:_Idle(idleElapsed, time, deltaTime, creature)
      end
    else
      creature:Logic_SamplePosition(time)
    end
  end
  return true
end

function IdleAI_WalkFollow:_Follow(idleElapsed, time, deltaTime, creature)
  if Phase_Follow == self.phase then
    return
  end
  self.phase = Phase_Follow
  creature:Logic_PlayAction_Move()
end

function IdleAI_WalkFollow:_Idle(idleElapsed, time, deltaTime, creature)
  if Phase_Idle == self.phase then
    return
  end
  self.phase = Phase_Idle
  creature:Logic_StopMove()
  creature:Logic_SamplePosition(time)
  creature:Logic_PlayAction_Idle()
end
