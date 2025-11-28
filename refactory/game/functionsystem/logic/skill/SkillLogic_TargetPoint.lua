SkillLogic_TargetPoint = {
  TargetType = SkillTargetType.Point
}
setmetatable(SkillLogic_TargetPoint, {
  __index = SkillLogic_Base
})
local SuperClass = SkillLogic_Base
local AdjustPointEffectSize = function(effectHandle, size, assetEffect)
  ModelUtils.AdjustSize(effectHandle.gameObject, size)
end
local EmitPoint = function(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
  local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(self, creature, phaseData, assetRole, skillInfo)
  hitWorker:AddRef()
  SkillLogic_Base.EmitFire(creature, nil, phaseData:GetPosition(), fireEP, emitParams, hitWorker, false, 1, 1, nil, skillInfo)
  hitWorker:SubRef()
end

function SkillLogic_TargetPoint:Cast(creature)
  if SuperClass.Cast(self, creature) then
    local p = self.phaseData:GetPosition()
    local skillInfo = self.info
    if skillInfo:GetRotateOnly() then
    else
      creature.logicTransform:LookAt(p)
    end
    local effectPath, lodLevel, priority, effectType, isMagicCircle
    if creature:IsDressed() then
      effectPath, lodLevel, priority, effectType, isMagicCircle = skillInfo:GetCastPointEffectPath(creature)
    end
    if nil ~= effectPath then
      local effect
      if isMagicCircle then
        local effectSize = skillInfo:GetPointEffectSize(creature)
        effect = Asset_Effect.PlayAt(effectPath, p, AdjustPointEffectSize, effectSize, nil, lodLevel, priority, effectType)
      else
        effect = Asset_Effect.PlayAt(effectPath, p, nil, nil, nil, lodLevel, priority, effectType)
      end
      effect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
      self:AddEffect(effect)
    end
    if creature.data:GetCamp() == RoleDefines_Camp.ENEMY and skillInfo:IsTrap() and not skillInfo:NoReadingEffect() then
      effectPath, lodLevel, priority, effectType = skillInfo:GetWarnRingEffectPath(creature)
      if effectPath ~= nil then
        local warnRingEffect = Asset_Effect.PlayAt(effectPath, p, nil, nil, nil, lodLevel, priority, effectType)
        local size = ReusableTable.CreateTable()
        skillInfo:GetWarnRingSize(creature, size)
        warnRingEffect:ResetLocalScaleXYZ(size.x, 1, size.y)
        ReusableTable.DestroyAndClearTable(size)
        warnRingEffect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
        self:AddEffect(warnRingEffect)
      end
    end
    return true
  end
  return false
end

function SkillLogic_TargetPoint:FreeCast(creature)
  return SkillLogic_TargetPoint.Cast(self, creature)
end

function SkillLogic_TargetPoint:Attack(creature, isAttackSkill, isTriggerSkill, noAttackCallback)
  local p = self.phaseData:GetPosition()
  creature.logicTransform:LookAt(p)
  return SuperClass.Attack(self, creature, isAttackSkill, isTriggerSkill, noAttackCallback)
end

function SkillLogic_TargetPoint:Fire(creature)
  local skillInfo = self.info
  local emitParams = skillInfo:GetEmitParams(creature)
  if nil ~= emitParams then
    local assetRole = creature.assetRole
    local fireIndex = self.fireIndex
    local fireCount = self.fireCount
    local skillInfo = self.info
    local fireEP = skillInfo:GetFireEP(creature)
    local fireEPWeapon = skillInfo:GetFireEPWeapon()
    local effectPath, lodLevel, priority, effectType = skillInfo:GetFireEffectPath(creature)
    if nil ~= effectPath then
      local effect
      if fireEPWeapon then
        local lefteffect, righeffect = assetRole:FireEffectOnWeaponEP(effectPath, fireEPWeapon, nil, lodLevel, priority, effectType)
        if lefteffect then
          lefteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
        if righeffect then
          righeffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
      else
        effect = assetRole:PlayEffectOneShotAt(effectPath, fireEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
        effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
      end
    end
    local sePath = skillInfo:GetFireSEPath(creature)
    if nil ~= sePath then
      assetRole:PlaySEOneShotOn(sePath)
    end
    EmitPoint(self, creature, self.phaseData, assetRole, skillInfo, fireEP, emitParams)
    return
  end
  local effectPath, lodLevel, priority, effectType, scale = self.info:GetFirePointEffectPath(creature)
  if nil ~= effectPath then
    local p = self.phaseData:GetPosition()
    local effect = Asset_Effect.PlayOneShotAt(effectPath, p, nil, nil, nil, lodLevel, priority, effectType)
    effect:ResetLocalEulerAnglesXYZ(0, self.phaseData:GetAngleY(), 0)
    if scale and scale ~= 1 then
      effect:ResetLocalScaleXYZ(scale, scale, scale)
    end
  end
  return SuperClass.Fire(self, creature)
end

function SkillLogic_TargetPoint:Client_PreUpdate_FreeCast(time, deltaTime, creature)
  local p = self.phaseData:GetPosition()
  return self:CheckTargetPosition(creature, p)
end
