local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetNone
})
local SuperClass = SkillLogic_TargetNone
local tempVector2 = LuaVector2.Zero()
local tempVector2_1 = LuaVector2.Zero()
local vecMyForward = LuaVector3(0, 0, 0)
local vecNpcToMe = LuaVector3(0, 0, 0)

function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  local p = creature:GetPosition()
  local angleY = creature:GetAngleY()
  if not skillInfo:IsArc() then
    skillInfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
    local filterFunc = skillInfo:SearchSignAssassinate() and function(targetCreature, args)
      local signAssassinate = targetCreature.data:GetBuffByTypeAndFromID(BuffType.SignAssassinate, creature.data.id)
      return signAssassinate
    end or nil
    SkillLogic_Base.SearchTargetInRect(creatureArray, p, tempVector2, tempVector2_1, angleY, skillInfo, creature, filterFunc, sortFunc)
  else
    local range = skillInfo.logicParam.distance
    if 0 < range then
      LuaVector3.Better_Set(vecMyForward, creature:GetForward())
      SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature, function(targetCreature, args)
        local halfAngle = (skillInfo.logicParam.angle or 0) / 2
        VectorUtility.Asign_3(vecNpcToMe, targetCreature:GetPosition())
        local myselfPos = creature:GetPosition()
        LuaVector3.Sub(vecNpcToMe, myselfPos)
        return halfAngle > LuaVector3.Angle(vecNpcToMe, vecMyForward)
      end, sortFunc)
    end
  end
end

function SelfClass.GetShowLength(skillinfo, creature)
  skillinfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
  return tempVector2_1[1], tempVector2_1[2]
end

return SelfClass
