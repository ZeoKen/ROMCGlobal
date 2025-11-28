local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetNone
})
local SuperClass = SkillLogic_TargetNone

function SelfClass:Attack(creature, isAttackSkill, isTriggerSkill)
  if not creature:Logic_PlayMountTransformAction(SelfClass.OnTransformCallback, {
    creatureGUID = creature.data.id,
    instanceID = self.instanceID
  }) then
    return false, false
  end
  local ret, actionPlayed, attackSpeed = SuperClass.Attack(self, creature, isAttackSkill, isTriggerSkill, true)
  return ret, true, attackSpeed
end

function SelfClass.OnTransformCallback(args)
  local creatureGUID = args and args.creatureGUID
  local skillInstanceID = args and args.instanceID
  local creature = SceneCreatureProxy.FindCreature(creatureGUID)
  if not creature then
    return
  end
  if creature.skill.instanceID ~= skillInstanceID then
    return
  end
  creature:Logic_OnMountTransformActionFinished()
  SkillLogic_Base.OnAttackFinished(creatureGUID, skillInstanceID)
end

return SelfClass
