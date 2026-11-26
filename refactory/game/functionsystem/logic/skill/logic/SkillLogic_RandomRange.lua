local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetPoint
})
local SuperClass = SkillLogic_TargetPoint

function SelfClass.GetPointEffectSize(skillInfo, creature)
  local size = skillInfo:GetBaseTargetRange() * 2
  local scale = skillInfo:GetTrapEffectScale(creature)
  if scale ~= 1 then
    size = size * scale
  end
  return size
end

function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount)
end

function SelfClass.GetIndicatorRange(skillInfo, creature)
  return skillInfo:GetLaunchRange(creature) * 2
end

function SelfClass.GetShowLength(skillInfo, creature)
  return skillInfo:GetLaunchRange(creature) / 2
end

return SelfClass
