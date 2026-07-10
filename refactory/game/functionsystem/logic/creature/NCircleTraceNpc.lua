NCircleTraceNpc = reusableClass("NCircleTraceNpc", NNpc)
local EAI_MOVEAROUND_TYPE = {
  None = 0,
  AroundCreature = 1,
  AroundPosition = 2
}

function NCircleTraceNpc:ctor()
  NCircleTraceNpc.super.ctor(self, AI_CreatureMoveAround)
end

function NCircleTraceNpc:GetCreatureType()
  return Creature_Type.Npc
end

function NCircleTraceNpc:Init(serverData, reinit)
  NCircleTraceNpc.super.Init(self, serverData, reinit)
  self.isCircleTraceNpc = true
  self.centerCreature = nil
  self.centerPos = nil
  self.currentMoveData = nil
  self:InitAI()
end

function NCircleTraceNpc:InitAssetRole()
  NCircleTraceNpc.super.InitAssetRole(self)
  self.assetRole:SetColliderEnable(false)
end

function NCircleTraceNpc:InitAI()
  self:SetPauseAI(false)
  self.ai:AttachMoveAround()
end

function NCircleTraceNpc:SetPauseAI(isTrue)
  if isTrue then
    if not self.ai.idleAIManager:IsPausing() then
      self.ai.idleAIManager:Pause()
    end
  elseif self.ai.idleAIManager:IsPausing() then
    self.ai.idleAIManager:Resume()
  end
end

function NCircleTraceNpc:GetMoveAroundStatus(moveData)
  if not moveData then
    return EAI_MOVEAROUND_TYPE.None
  end
  if moveData.center then
    return EAI_MOVEAROUND_TYPE.AroundPosition, moveData.center
  elseif moveData.center_guid and moveData.center_guid ~= 0 then
    return EAI_MOVEAROUND_TYPE.AroundCreature, moveData.center_guid
  else
    return EAI_MOVEAROUND_TYPE.None
  end
end

function NCircleTraceNpc:CheckNeedChangeCircle(moveData)
  local lastType, lastData = self:GetMoveAroundStatus(self.currentMoveData)
  local newType, newData = self:GetMoveAroundStatus(moveData)
  if lastType ~= newType then
    return true
  end
  if lastType == EAI_MOVEAROUND_TYPE.None then
    return false
  elseif lastType == EAI_MOVEAROUND_TYPE.AroundPosition then
    return LuaVector3.Magnitude(lastData - newData) > 0.001
  elseif lastType == EAI_MOVEAROUND_TYPE.AroundCreature then
    return lastData ~= newData
  end
  return false
end

function NCircleTraceNpc:UpdateNpcMovement(moveData)
  if not moveData or not self.ai then
    return
  end
  local cfg = moveData
  self.centerPos = cfg.center
  if cfg.center_guid and cfg.center_guid ~= 0 then
    self.centerCreature = SceneCreatureProxy.FindCreature(cfg.center_guid)
  else
    self.centerCreature = nil
  end
  local targetCreature = self.centerCreature
  if self.centerPos or targetCreature then
    local radius = cfg.radius
    local angularSpeed = cfg.angle_speed
    local angle = cfg.angle
    local orbitSpeed = 10
    self.ai:Request_Set(targetCreature, radius, angularSpeed, self.centerPos, orbitSpeed, nil, angle)
  end
  self.currentMoveData = moveData
end

function NCircleTraceNpc:GetCircleTraceCenterPosition()
  if self.centerCreature ~= nil then
    return self.centerCreature:GetPosition()
  end
  return self.centerPos
end

function NCircleTraceNpc:DoDeconstruct(asArray)
  self.isCircleTraceNpc = nil
  self.centerCreature = nil
  self.centerPos = nil
  self.currentMoveData = nil
  NCircleTraceNpc.super.DoDeconstruct(self, asArray)
end
