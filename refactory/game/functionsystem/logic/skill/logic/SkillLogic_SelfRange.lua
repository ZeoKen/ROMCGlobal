local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetNone
})
local SuperClass = SkillLogic_TargetNone

function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  local range = skillInfo:GetTargetRange(creature)
  if 0 < range then
    local p = creature:GetPosition()
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature, nil, sortFunc)
  end
end

function SelfClass.GetShowLength(skillinfo, creature)
  return skillinfo:GetTargetRange(creature)
end

return SelfClass
