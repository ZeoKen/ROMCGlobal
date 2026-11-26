InteractPlayerHug = class("InteractPlayerHug")
local SqrDistanceXZ = VectorUtility.DistanceXZ_Square

function InteractPlayerHug.Create(targetCharid, buffEffect)
  local self = InteractPlayerHug.new()
  self.targetCharid = targetCharid
  self.buffEffect = buffEffect
  return self
end

function InteractPlayerHug:Destroy()
  self.targetCharid = nil
  self.buffEffect = nil
end

local defaultRange = 2

function InteractPlayerHug:Update(time, deltaTime)
  if not self.targetCharid or not self.buffEffect then
    return false
  end
  if Game.Myself:IsDead() then
    return false
  end
  local target = SceneCreatureProxy.FindCreature(self.targetCharid)
  if not target or target:IsDead() then
    return false
  end
  if self:IsCarryingThisTarget() then
    return true
  end
  if Game.Myself.data:IsControlled() then
    return false
  end
  if self:IsCarryingSomeone() then
    return false
  end
  local range = self.buffEffect.range or defaultRange
  return SqrDistanceXZ(Game.Myself:GetPosition(), target:GetPosition()) <= range * range
end

function InteractPlayerHug:GetInteractPrompt()
  if self:IsCarryingThisTarget() then
    return ZhString.InteractLocal_PlayerHugOff
  else
    return ZhString.InteractLocal_PlayerHugOn
  end
end

function InteractPlayerHug:GetInteractIcon()
  return nil
end

function InteractPlayerHug:StartInteract()
  if Game.Myself:IsDead() then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local target = SceneCreatureProxy.FindCreature(self.targetCharid)
  if not self:IsCarryingThisTarget() and (not target or target:IsDead()) then
    InteractLocalManager.Me():EndInteract()
    return
  end
  if not self:IsCarryingThisTarget() and Game.Myself.data:IsControlled() then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local newCharid = self:IsCarryingThisTarget() and 0 or self.targetCharid
  ServiceMessCCmdProxy.Instance:CallCarryUserMessCCmd(newCharid)
  InteractLocalManager.Me():EndInteract()
end

function InteractPlayerHug:GetTargetCharid()
  return self.targetCharid
end

function InteractPlayerHug:_GetMyCarryUpCharid()
  local myselfData = Game.Myself and Game.Myself.data
  local ud = myselfData and myselfData.userdata
  if not ud then
    return 0
  end
  return ud:Get(UDEnum.CARRY_UP_CHARID) or 0
end

function InteractPlayerHug:IsCarryingSomeone()
  return self:_GetMyCarryUpCharid() ~= 0
end

function InteractPlayerHug:IsCarryingThisTarget()
  return self:_GetMyCarryUpCharid() == self.targetCharid
end
