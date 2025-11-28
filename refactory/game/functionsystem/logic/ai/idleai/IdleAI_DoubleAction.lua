IdleAI_DoubleAction = class("IdleAI_DoubleAction")
local Phase_Idle = 0
local Phase_Follow = 1
local Phase_Connecting = 2
local Phase_Connected = 3
local TriggerRange = 1
local FindCreature = SceneCreatureProxy.FindCreature

function IdleAI_DoubleAction:ctor()
  self.phase = Phase_Idle
  self.targetPosition = nil
  self.masterGUID = 0
  self.requestMasterGUID = nil
  self.priority = 5
end

function IdleAI_DoubleAction:Request_Set(guid)
  self.requestMasterGUID = guid
end

function IdleAI_DoubleAction:Clear(idleElapsed, time, deltaTime, creature)
  self:End(idleElapsed, time, deltaTime, creature)
end

function IdleAI_DoubleAction:Prepare(idleElapsed, time, deltaTime, creature)
  if nil ~= self.requestMasterGUID then
    self:_SwitchMaster(self.requestMasterGUID, creature)
    self.requestMasterGUID = nil
  end
  if 0 == self.masterGUID then
    return false
  end
  local masterCreature = FindCreature(self.masterGUID)
  return nil ~= masterCreature
end

function IdleAI_DoubleAction:Start(idleElapsed, time, deltaTime, creature)
  self.connected_CheckTarget = 0
  if creature == Game.Myself then
    self.connected_CheckTarget = 1
  else
    local masterCreature = FindCreature(self.masterGUID)
    if masterCreature == Game.Myself then
      self.connected_CheckTarget = 2
    end
  end
end

function IdleAI_DoubleAction:End(idleElapsed, time, deltaTime, creature, fromSubClass)
  if not fromSubClass and idleElapsed < 0.1 then
    return
  end
  local masterCreature
  if 0 ~= self.masterGUID then
    masterCreature = FindCreature(self.masterGUID)
  end
  self:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature)
  self:_SwitchMaster(0, creature)
end

function IdleAI_DoubleAction:Update(idleElapsed, time, deltaTime, creature)
  local masterCreature = FindCreature(self.masterGUID)
  if Phase_Idle == self.phase then
    self:_UpdateIdle(idleElapsed, time, deltaTime, creature, masterCreature)
  elseif Phase_Follow == self.phase then
    self:_UpdateFollow(idleElapsed, time, deltaTime, creature, masterCreature)
  elseif Phase_Connecting == self.phase then
    self:_UpdateConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
  elseif Phase_Connected == self.phase then
    self:_UpdateConnected(idleElapsed, time, deltaTime, creature, masterCreature)
  end
  return true
end

function IdleAI_DoubleAction:_SwitchMaster(masterGUID, creature)
  local oldMasterGUID = self.masterGUID
  if oldMasterGUID == masterGUID then
    return
  end
  helplog("DoubleAction SwitchMaster", masterGUID, creature.data:GetName())
  self.masterGUID = masterGUID
  if 0 ~= oldMasterGUID then
    local masterCreature = FindCreature(oldMasterGUID)
    if nil ~= masterCreature then
      masterCreature:ClearDoubleAction()
    end
    Game.LogicManager_HandInHand:UnRegisterDoubleAction(masterCreature, creature)
  end
  if 0 ~= masterGUID and Phase_Connected == self.phase then
    local masterCreature = FindCreature(masterGUID)
    if masterCreature ~= nil then
      Game.LogicManager_HandInHand:RegisterDoubleAction(masterCreature, creature)
    end
  end
end

function IdleAI_DoubleAction:_SwitchToIdle(idleElapsed, time, deltaTime, creature, masterCreature, forceStop)
  if Phase_Idle == self.phase then
    return
  end
  local oldPhase = self.phase
  self.phase = Phase_Idle
  if nil ~= masterCreature then
    local needIdle = masterCreature:IsPlayingDoubleAction()
    masterCreature:ClearDoubleAction()
    if needIdle then
      masterCreature:Logic_PlayAction_Idle()
    end
  end
  local needIdle = creature:IsPlayingDoubleAction()
  creature:ClearDoubleAction()
  self:_StopMove(creature, masterCreature, forceStop)
  if Phase_Connecting == oldPhase then
    creature:Logic_SamplePosition(0)
    if needIdle then
      masterCreature:Logic_PlayAction_Idle()
    end
  elseif Phase_Connected == oldPhase then
    creature:Logic_SamplePosition(0)
    Game.LogicManager_HandInHand:UnRegisterDoubleAction(masterCreature, creature)
    if needIdle then
      creature:Logic_PlayAction_Idle()
    end
  end
end

function IdleAI_DoubleAction:_UpdateIdle(idleElapsed, time, deltaTime, creature, masterCreature)
  local masterPosition = masterCreature:GetPosition()
  local distance = VectorUtility.DistanceXZ_Square(masterPosition, creature:GetPosition())
  if distance > TriggerRange then
    self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
    return
  end
  self:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
end

function IdleAI_DoubleAction:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
  if Phase_Follow == self.phase then
    return
  end
  self.phase = Phase_Follow
  creature:Logic_PlayAction_Move()
end

function IdleAI_DoubleAction:_UpdateFollow(idleElapsed, time, deltaTime, creature, masterCreature)
  local masterPosition = masterCreature:GetPosition()
  if VectorUtility.DistanceXZ_Square(masterPosition, creature:GetPosition()) > TriggerRange then
    local logicTransform = creature.logicTransform
    local prevTargetPosition = logicTransform.targetPosition
    if nil == prevTargetPosition then
      self:_MoveTo(masterPosition, creature, masterCreature)
    elseif VectorUtility.DistanceXZ_Square(masterPosition, prevTargetPosition) > 0.01 then
      self:_MoveTo(masterPosition, creature, masterCreature)
    end
    creature:Logic_SamplePosition(time)
    return
  end
  self:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
end

function IdleAI_DoubleAction:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
  if Phase_Connecting == self.phase then
    return false
  end
  self.phase = Phase_Connecting
  local masterPosition = masterCreature:GetPosition()
  local distance = VectorUtility.DistanceXZ_Square(masterPosition, creature:GetPosition())
  if distance > TriggerRange then
    self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
    return false
  end
  self:_StopMove(creature, masterCreature)
  if creature:IsDoubleActionBuild() then
    self:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
  end
  return true
end

function IdleAI_DoubleAction:_UpdateConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
  local masterPosition = masterCreature:GetPosition()
  if VectorUtility.DistanceXZ_Square(masterPosition, creature:GetPosition()) > TriggerRange then
    self:_SwitchToFollow(idleElapsed, time, deltaTime, creature, masterCreature)
    return false
  end
  if not creature:IsDoubleActionBuild() then
    return false
  end
  self:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
  return true
end

function IdleAI_DoubleAction:_SwitchToConnected(idleElapsed, time, deltaTime, creature, masterCreature)
  if Phase_Connected == self.phase then
    return
  end
  self.phase = Phase_Connected
  self.actionConnected = nil
  self:_StopMove(creature, masterCreature)
  masterCreature:PlayDoubleAction(true)
  creature:PlayDoubleAction(false)
  Game.LogicManager_HandInHand:RegisterDoubleAction(masterCreature, creature)
end

function IdleAI_DoubleAction:_UpdateConnected(idleElapsed, time, deltaTime, creature, masterCreature)
  if self.connected_CheckTarget == 1 then
    if not creature:IsPlayingDoubleAction() then
      self:End(idleElapsed, time, deltaTime, creature, masterCreature)
    end
  elseif self.connected_CheckTarget == 2 then
    if not masterCreature:IsPlayingDoubleAction() then
      self:End(idleElapsed, time, deltaTime, creature, masterCreature)
    end
  elseif not self.actionConnected then
    self.actionConnected = true
    if not masterCreature:IsPlayingDoubleAction() then
      self:_StopMove(creature, masterCreature)
      masterCreature:PlayDoubleAction()
      self.actionConnected = false
    end
    if not creature:IsPlayingDoubleAction() then
      if self.actionConnected then
        self:_StopMove(creature, masterCreature)
      end
      creature:PlayDoubleAction()
      self.actionConnected = false
    end
  end
end

function IdleAI_DoubleAction:_MoveTo(p, creature, masterCreature)
  if not creature.logicTransform:NavMeshMoveTo(p) then
    creature.logicTransform:MoveTo(p)
  end
  self.targetPosition = VectorUtility.Asign_3(self.targetPosition, p)
end

function IdleAI_DoubleAction:_StopMove(creature, masterCreature, forceStop)
  if forceStop or nil ~= self.targetPosition and nil ~= creature.logicTransform.targetPosition and LuaVector3.Equal(self.targetPosition, creature.logicTransform.targetPosition) then
    creature.logicTransform:StopMove()
    creature:Logic_PlayAction_Idle()
  end
  if nil ~= self.targetPosition then
    LuaVector3.Destroy(self.targetPosition)
    self.targetPosition = nil
  end
end
