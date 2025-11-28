SkillLogic_TargetNone = {
  TargetType = SkillTargetType.None
}
setmetatable(SkillLogic_TargetNone, {
  __index = SkillLogic_Base
})
local SuperClass = SkillLogic_Base

function SkillLogic_TargetNone:Cast(creature)
  if SuperClass.Cast(self, creature) then
    local angleY = self.phaseData:GetAngleY()
    if angleY ~= nil and creature:GetCreatureType() == Creature_Type.Npc then
      creature.logicTransform:SetAngleY(angleY)
    end
    return true
  end
  return false
end

function SkillLogic_TargetNone:Attack(creature, isAttackSkill, isTriggerSkill, noAttackCallback)
  local angleY = self.phaseData:GetAngleY()
  if angleY ~= nil and creature:GetCreatureType() == Creature_Type.Npc then
    creature.logicTransform:SetAngleY(angleY)
  end
  return SuperClass.Attack(self, creature, isAttackSkill, isTriggerSkill, noAttackCallback)
end

function SkillLogic_TargetNone:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  local skillInfo = self.info
  if not skillInfo:SelectLockedTarget(creature) then
    return
  end
  local lockedCreature = creature:GetLockTarget()
  if nil == lockedCreature or not skillInfo:CheckTarget(creature, lockedCreature) then
    return
  end
  local range = skillInfo:GetLaunchRange(creature)
  if 0 < range then
    local distance = VectorUtility.DistanceXZ_Square(creature:GetPosition(), lockedCreature:GetPosition())
    if distance > range * range then
      return
    end
  end
  if 1 == maxCount then
    TableUtility.ArrayPushFront(creatureArray, lockedCreature)
  else
    TableUtility.ArrayPushBack(creatureArray, lockedCreature)
  end
end
