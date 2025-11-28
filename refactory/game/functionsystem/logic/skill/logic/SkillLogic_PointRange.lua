local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetPoint
})
local SuperClass = SkillLogic_TargetPoint

function SelfClass.GetPointEffectSize(skillInfo, creature)
  return skillInfo:GetTargetRange(creature) * 2
end

function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  local range = skillInfo:GetTargetRange(creature)
  if 0 < range then
    local p = self.phaseData:GetPosition()
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature, nil, sortFunc)
  end
end

function SelfClass.GetIndicatorRange(skillInfo, creature)
  return skillInfo:GetLaunchRange(creature) * 2
end

function SelfClass.GetShowLength(skillinfo, creature)
  return skillinfo:GetLaunchRange(creature) / 2
end

return SelfClass
