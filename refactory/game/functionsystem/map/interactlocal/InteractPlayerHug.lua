InteractPlayerHug = class("InteractPlayerHug")
local SqrDistanceXZ = VectorUtility.DistanceXZ_Square
local _IsCreatureDead = function(creature)
  return creature ~= nil and creature.IsDead ~= nil and creature:IsDead() or false
end
local _IsMyselfControlled = function()
  local myselfData = Game.Myself and Game.Myself.data
  if not myselfData then
    return false
  end
  if myselfData.Freeze ~= nil and myselfData:Freeze() then
    return true
  end
  if myselfData.NoAct ~= nil and myselfData:NoAct() then
    return true
  end
  if myselfData.NoMove ~= nil and myselfData:NoMove() then
    return true
  end
  if myselfData.FearRun ~= nil and myselfData:FearRun() then
    return true
  end
  return false
end

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
  if _IsCreatureDead(Game.Myself) then
    return false
  end
  local target = SceneCreatureProxy.FindCreature(self.targetCharid)
  if not target or _IsCreatureDead(target) then
    return false
  end
  if self:IsCarryingThisTarget() then
    return true
  end
  if _IsMyselfControlled() then
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
  if _IsCreatureDead(Game.Myself) then
    InteractLocalManager.Me():EndInteract()
    return
  end
  local target = SceneCreatureProxy.FindCreature(self.targetCharid)
  if not self:IsCarryingThisTarget() and (not target or _IsCreatureDead(target)) then
    InteractLocalManager.Me():EndInteract()
    return
  end
  if not self:IsCarryingThisTarget() and _IsMyselfControlled() then
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
