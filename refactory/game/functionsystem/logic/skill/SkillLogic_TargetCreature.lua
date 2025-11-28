SkillLogic_TargetCreature = {
  TargetType = SkillTargetType.Creature
}
setmetatable(SkillLogic_TargetCreature, {
  __index = SkillLogic_Base
})
local SuperClass = SkillLogic_Base
local FindCreature = SceneCreatureProxy.FindCreature

function SkillLogic_TargetCreature:Cast(creature)
  local targetCreatureGUID = 0
  if nil ~= self.targetCreatureGUID and 0 ~= self.targetCreatureGUID then
    targetCreatureGUID = self.targetCreatureGUID
  else
    targetCreatureGUID = self.phaseData:GetTarget(1)
  end
  local targetCreature = FindCreature(targetCreatureGUID)
  if nil == targetCreature then
    return false
  end
  local skillInfo = self.info
  if not creature.data:IsMonster() and not skillInfo:CheckTarget(creature, targetCreature) then
    return false
  end
  if SuperClass.Cast(self, creature) then
    local myValue = creature.data:GetDownID()
    if not myValue or myValue == 0 then
      creature.logicTransform:LookAt(targetCreature:GetPosition())
    end
    local skillType = self.info:GetSkillType(creature)
    if SkillType.Collect ~= skillType and SkillType.Eat ~= skillType and SkillType.TouchPet ~= skillType then
      local effectPath, lodLevel, priority, effectType = self.info:GetCastLockEffectPath(creature)
      if nil ~= effectPath then
        local effect = targetCreature.assetRole:PlayEffectOn(effectPath, 0, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
        if effect ~= nil then
          self:AddEffect(effect)
        end
      end
      effectPath, lodLevel, priority, effectType = self.info:GetCastLockConfigEffectPath(creature)
      if effectPath ~= nil then
        local lockEP = self.info:GetCastLockEP()
        local effect = targetCreature.assetRole:PlayEffectOn(effectPath, lockEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
        if effect ~= nil then
          self:AddEffect(effect)
        end
      end
      if creature.data:GetCamp() == RoleDefines_Camp.ENEMY and skillInfo:IsTrap() and not skillInfo:NoReadingEffect() then
        effectPath, lodLevel, priority, effectType = skillInfo:GetWarnRingEffectPath(creature)
        if effectPath ~= nil then
          local p = self.phaseData:GetPosition()
          local warnRingEffect = Asset_Effect.PlayAt(effectPath, p, nil, nil, nil, lodLevel, priority, effectType)
          local size = ReusableTable.CreateTable()
          skillInfo:GetWarnRingSize(creature, size)
          warnRingEffect:ResetLocalScaleXYZ(size.x, 1, size.y)
          ReusableTable.DestroyAndClearTable(size)
          warnRingEffect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
          self:AddEffect(warnRingEffect)
        end
      end
    end
    return true
  end
  return false
end

function SkillLogic_TargetCreature:FreeCast(creature)
  return SkillLogic_TargetCreature.Cast(self, creature)
end

function SkillLogic_TargetCreature:Attack(creature, isAttackSkill, isTriggerSkill, noAttackCallback)
  if 0 >= self.phaseData:GetTargetCount() then
    return false, false
  end
  local targetCreatureGUID = 0
  if nil ~= self.targetCreatureGUID and 0 ~= self.targetCreatureGUID then
    targetCreatureGUID = self.targetCreatureGUID
  else
    targetCreatureGUID = self.phaseData:GetTarget(1)
  end
  local targetCreature = FindCreature(targetCreatureGUID)
  if nil ~= targetCreature then
    local myValue = creature.data:GetDownID()
    if not myValue or myValue == 0 then
      creature:LookAt(targetCreature:GetPosition())
    end
  end
  return SuperClass.Attack(self, creature, isAttackSkill, isTriggerSkill, noAttackCallback)
end

function SkillLogic_TargetCreature:Client_PreUpdate_Cast(time, deltaTime, creature)
  return self:CheckTargetCreature(creature)
end

function SkillLogic_TargetCreature:Client_PreUpdate_FreeCast(time, deltaTime, creature)
  return SkillLogic_TargetCreature.Client_PreUpdate_Cast(self, time, deltaTime, creature)
end

function SkillLogic_TargetCreature:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  local targetCreature = FindCreature(self.targetCreatureGUID)
  if nil == targetCreature then
    return
  end
  local skillInfo = self.info
  if not skillInfo:CheckTarget(creature, targetCreature) then
    return
  end
  TableUtility.ArrayPushBack(creatureArray, targetCreature)
  local range = skillInfo:GetTargetRange(creature)
  if 0 < range then
    local p = targetCreature:GetPosition()
    SkillLogic_Base.SearchTargetInRange(creatureArray, p, range, skillInfo, creature, nil, sortFunc)
  end
end
