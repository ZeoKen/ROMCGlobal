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
  self.registeredToOwner = false
  self.centerCreatureID = nil
  self.centerPos = nil
  self.currentMoveData = nil
  self:InitAI()
  self:SetDressEnable(false)
  self:SetPauseAI(true)
  self:TryRegisterOwner()
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

function NCircleTraceNpc:TryRegisterOwner()
  if self.registeredToOwner then
    return true
  end
  if not (self.data and self.data.ownerID) or self.data.ownerID == 0 then
    return false
  end
  local owner = SceneCreatureProxy.FindCreature(self.data.ownerID)
  if not owner or not owner.data then
    return false
  end
  owner.data:AddRotateID(self.data.id)
  self.registeredToOwner = true
  self:SetDressEnable(owner:IsDressEnable())
  self:SetPauseAI(false)
  return true
end

function NCircleTraceNpc:UnregisterOwner()
  if not self.registeredToOwner then
    return
  end
  local owner = self.data and SceneCreatureProxy.FindCreature(self.data.ownerID)
  if owner and owner.data then
    owner.data:RemoveRotateID()
  end
  self.registeredToOwner = false
end

function NCircleTraceNpc:HandleOwnerRemoved()
  self.registeredToOwner = false
  self:SetDressEnable(false)
  self:SetPauseAI(true)
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
  if not self:TryRegisterOwner() then
    return
  end
  local cfg = moveData
  self.centerPos = cfg.center
  self.centerCreatureID = cfg.center_guid or 0
  if self.centerPos or self.centerCreatureID > 0 then
    local radius = cfg.radius
    local angularSpeed = cfg.angle_speed
    local angle = cfg.angle
    local orbitSpeed = 10
    self.ai:Request_Set(self.centerCreatureID, radius, angularSpeed, self.centerPos, orbitSpeed, nil, angle)
  end
  self.currentMoveData = moveData
end

function NCircleTraceNpc:GetCircleTraceCenterPosition()
  local centerCreature = SceneCreatureProxy.FindCreature(self.centerCreatureID or 0)
  if centerCreature ~= nil then
    return centerCreature:GetPosition()
  end
  return self.centerPos
end

function NCircleTraceNpc:DoDeconstruct(asArray)
  self:UnregisterOwner()
  self.isCircleTraceNpc = nil
  self.registeredToOwner = false
  self.centerCreatureID = nil
  self.centerPos = nil
  self.currentMoveData = nil
  NCircleTraceNpc.super.DoDeconstruct(self, asArray)
end
