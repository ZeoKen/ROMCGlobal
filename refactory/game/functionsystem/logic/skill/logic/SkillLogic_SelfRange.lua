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
    p = skillInfo:UseCircleTraceCenter(creature) and creature:GetCircleTraceCenterPosition() or p
    local minRange = skillInfo:GetTargetMinRange()
    local minRangeSquare = minRange * minRange
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature, 0 < minRange and function(targetCreature, args)
      return VectorUtility.DistanceXZ_Square(p, targetCreature:GetPosition()) >= minRangeSquare
    end or nil, sortFunc)
  end
end

function SelfClass.GetShowLength(skillinfo, creature)
  return skillinfo:GetTargetRange(creature)
end

return SelfClass
