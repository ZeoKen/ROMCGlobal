local SelfClass = class("SkillCastWorker_IntervalEffect", ReusableObject)
SelfClass.PoolSize = 100
local tempVector3 = LuaVector3.Zero()

function SelfClass.Create(args)
  return ReusableObject.Create(SelfClass, true, args)
end

function SelfClass:ctor()
  self.args = {}
end

function SelfClass:Start(skill, creature)
  local skillInfo = skill.info
  self.nextPlayEffectTime = 0
  self.effectInterval = skillInfo:GetEffectInterval()
  return true
end

function SelfClass:End(skill, creature)
end

function SelfClass:Update(skill, time, deltaTime, creature)
  local args = self.args
  local skillInfo = skill.info
  if time > self.nextPlayEffectTime then
    local currentPos = creature:GetPosition()
    local effectPath = skillInfo:GetIntervalEffect(creature)
    local effect = Asset_Effect.PlayOneShotAt(effectPath, currentPos)
    local y = creature:GetAngleY()
    effect:ResetLocalEulerAnglesXYZ(0, y, 0)
    self.nextPlayEffectTime = time + self.effectInterval
  end
  return true
end

function SelfClass:DoConstruct(asArray, args)
  self.args[1] = args
end

function SelfClass:DoDeconstruct(asArray)
end

return SelfClass
