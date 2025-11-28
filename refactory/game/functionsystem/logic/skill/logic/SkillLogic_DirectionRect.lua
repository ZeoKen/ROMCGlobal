local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetPoint
})
local SuperClass = SkillLogic_TargetPoint
local tempVector2 = LuaVector2.Zero()
local tempVector2_1 = LuaVector2.Zero()

function SelfClass.GetPointEffectSize(skillInfo, creature)
  return 0
end

function SelfClass.PointEffectTrack(skillInfo, creature, effect, point)
  local p = creature:GetPosition()
  local angleY = VectorHelper.GetAngleByAxisY(p, point)
  effect:ResetLocalEulerAnglesXYZ(0, angleY - creature:GetAngleY(), 0)
end

function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  skillInfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
  local p = creature:GetPosition()
  local angleY = VectorHelper.GetAngleByAxisY(p, self.phaseData:GetPosition())
  SkillLogic_Base.SearchTargetInRect(creatureArray, p, tempVector2, tempVector2_1, angleY, skillInfo, creature, nil, sortFunc)
end

function SelfClass.GetIndicatorRange(skillInfo, creature)
  return skillInfo:GetDistance() * 2 or 0
end

function SelfClass.GetShowLength(skillinfo, creature)
  skillinfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
  return tempVector2_1[1], tempVector2_1[2]
end

return SelfClass
