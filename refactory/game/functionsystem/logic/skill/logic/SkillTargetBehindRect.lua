local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetCreature
})
local SuperClass = SkillLogic_TargetCreature
local tempVector2 = LuaVector2.Zero()
local tempVector2_1 = LuaVector2.Zero()
local tempVector3 = LuaVector3.Zero()
local tempPos = LuaVector3.Zero()

function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  if creatureArray then
    local targetMain = creatureArray[1]
    if targetMain then
      local skillInfo = self.info
      local endPosition = targetMain:GetPosition()
      local p = creature:GetPosition()
      local backDistance = skillInfo:GetBackDistance()
      VectorUtility.Better_LookAt(p, tempVector3, endPosition)
      skillInfo:GetTargetBehindRect(creature, tempVector2, tempVector2_1)
      local dist = VectorUtility.DistanceXZ(endPosition, p)
      tempVector2_1[2] = tempVector2_1[2] + dist
      tempVector2[2] = tempVector2_1[2] / 2 - (backDistance or 0)
      SkillLogic_Base.SearchTargetInRect(creatureArray, p, tempVector2, tempVector2_1, tempVector3[2], skillInfo, creature, nil, sortFunc)
    end
  end
end

function SelfClass.GetShowLength(skillinfo, creature)
  skillinfo:GetTargetBehindRect(creature, tempVector2, tempVector2_1)
  return tempVector2_1[1], tempVector2_1[2]
end

return SelfClass
