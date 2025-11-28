autoImport("NPartner")
SkillHitWorker = class("SkillHitWorker", ReusableObject)
if not SkillHitWorker.SkillHitWorker_Inited then
  SkillHitWorker.SkillHitWorker_Inited = true
  SkillHitWorker.PoolSize = 200
end
local DamageType = CommonFun.DamageType
local _TableShallowCopy = TableUtility.TableShallowCopy
local _FindCreature = SceneCreatureProxy.FindCreature
local FindCreature = function(guid)
  local c = _FindCreature(guid)
  if c then
    return c
  end
  if NPartnerMap[guid] then
    return NPartnerMap[guid]
  end
end
local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()
local tempList = {}
local arrayCount = 6
local SpecialHitEffectTypes = {HitEffectMove = 1, MultiTargetConnect = 2}
local CreateShareDamageInfos = function(origin, infos)
  if nil ~= origin and 0 < #origin then
    if nil == infos then
      infos = ReusableTable.CreateArray()
    end
    TableUtility.ArrayShallowCopyWithCount(infos, origin, origin[1] * 3 + 1)
  elseif nil ~= infos then
    DestroyShareDamageInfos(infos)
    infos = nil
  end
  return infos
end
local DestroyShareDamageInfos = function(infos)
  if nil ~= infos then
    ReusableTable.DestroyArray(infos)
  end
end

function SkillHitWorker.Create(args)
  return ReusableObject.Create(SkillHitWorker, true, args)
end

function SkillHitWorker:ctor()
  self.args = {
    [1] = nil,
    [2] = LuaVector3.Zero(),
    [3] = 0,
    [4] = 0,
    [5] = nil,
    [6] = nil,
    [7] = 0
  }
end

function SkillHitWorker:AddRef()
  self.ref = self.ref + 1
end

function SkillHitWorker:SubRef()
  self.ref = self.ref - 1
  if self.ref <= 0 then
    self:Destroy()
  end
end

function SkillHitWorker:Init(skillInfo, fromPosition, fromGUID, fromWeaponID, noHitEffect)
  local args = self.args
  if 0 ~= args[7] then
    return
  end
  args[1] = skillInfo
  LuaVector3.Better_Set(args[2], fromPosition[1], fromPosition[2], fromPosition[3])
  args[3] = fromGUID
  args[4] = fromWeaponID
  args[5] = nil
  args[6] = nil
  args[7] = 0
  self.noHitEffect = noHitEffect
end

function SkillHitWorker:GetSkillInfo()
  return self.args[1]
end

function SkillHitWorker:GetFromGUID()
  return self.args[3]
end

function SkillHitWorker:SetFromPosition(p)
  if not p then
    return
  end
  LuaVector3.Better_Set(self.args[2], p[1], p[2], p[3])
end

function SkillHitWorker:SetForceEffectPath(effectPath)
  self.args[5] = effectPath
end

function SkillHitWorker:AddTarget(targetGUID, damageType, damage, shareDamageInfos, comboDamageLabel, damageCount)
  local args = self.args
  local targetCount = args[7]
  local index = 7 + targetCount * arrayCount
  args[7] = targetCount + 1
  args[index + 1] = targetGUID
  args[index + 2] = damageType
  args[index + 3] = damage
  args[index + 4] = CreateShareDamageInfos(shareDamageInfos, args[index + 4])
  args[index + 5] = comboDamageLabel
  args[index + 6] = damageCount
end

function SkillHitWorker:SetTargetComboDamageLabel(index, comboDamageLabel)
  local args = self.args
  index = 7 + (index - 1) * arrayCount
  local oldLabel = args[index + 5]
  if oldLabel == comboDamageLabel then
    return
  end
  args[index + 5] = comboDamageLabel
  if self.delayed then
    if nil ~= oldLabel then
      oldLabel:SubRef()
    end
    if nil ~= comboDamageLabel then
      comboDamageLabel:AddRef()
    end
  end
end

function SkillHitWorker:GetTargetCount()
  return self.args[7]
end

function SkillHitWorker:GetTarget(index)
  local args = self.args
  index = 7 + (index - 1) * arrayCount
  return args[index + 1], args[index + 2], args[index + 3], args[index + 4], args[index + 5], args[index + 6]
end

function SkillHitWorker:Work(damageIndex, damageCount, forceSingleDamage)
  local args = self.args
  local targetCount = args[7]
  if targetCount <= 0 then
    return
  end
  mylog("SkillHitWorker:Work ", damageIndex, damageCount, targetCount)
  local creature = FindCreature(args[3])
  self:_Work(creature, args[8], args[9], SkillLogic_Base.GetSplitDamage(args[10], damageIndex, damageCount), args[11], args[12], forceSingleDamage, 1, targetCount, args[13])
  tempList[#tempList + 1] = args[8]
  local subCount = targetCount - 1
  if 0 < subCount then
    local effectPath = args[5]
    args[5] = nil
    for i = 1, subCount do
      local index = 7 + i * arrayCount
      self:_Work(creature, args[index + 1], args[index + 2], SkillLogic_Base.GetSplitDamage(args[index + 3], damageIndex, damageCount), args[index + 4], args[index + 5], forceSingleDamage, i + 1, targetCount, args[index + 6])
      tempList[#tempList + 1] = args[index + 1]
    end
    args[5] = effectPath
  end
  self:_MultiSpecialHit(tempList)
  TableUtility.ArrayClear(tempList)
end

local hitCheckFrame = 4
local hitCheckDistance = 8

function SkillHitWorker:_Work(creature, targetGUID, damageType, damage, shareDamageInfos, comboDamageLabel, forceSingleDamage, targetIndex, targetCount, damageCount)
  local args = self.args
  local targetCreature = FindCreature(targetGUID)
  if nil == targetCreature then
    return
  end
  local hitDistance = hitCheckDistance
  if FunctionSniperMode.Me():IsWorking() then
    local cfgSniper = GameConfig.Sniper
    hitDistance = cfgSniper and cfgSniper.DamageShowDistance or 12
  end
  self:_SpecialHit(creature, targetCreature)
  local isMySelf = creature ~= nil and Game.Myself.data.id == creature.data.id or Game.Myself.data.id == targetGUID
  if not isMySelf then
    local priority = Game.LogicManager_MapCell:GetPriority(targetCreature.mapCellIndex)
    if priority >= Game.LogicManager_MapCell.invisiblePriority or targetCreature.updateFrequency ~= nil and targetCreature.updateFrequency >= hitCheckFrame then
      return
    elseif VectorUtility.DistanceXZ_Square(targetCreature:GetPosition(), Game.Myself:GetCenterPosition()) > hitDistance * hitDistance then
      return
    end
  end
  if DamageType.None ~= damageType then
    local skillInfo = args[1]
    local hitEP = args[6]
    if nil == hitEP then
      hitEP = skillInfo:GetHitEP(creature)
    end
    local allowEffect = SkillLogic_Base.AllowTargetEffect(creature, targetCreature)
    if skillInfo:NoHitEffect() then
      allowEffect = false
    end
    local allowHurtNum = SkillLogic_Base.AllowTargetHurtNum(creature, targetCreature)
    local effectPath, targetPosition, lodLevel, priority, effectType, dirAngleY = self:_PlayEffect(creature, targetCreature, damageType, damage, hitEP, allowEffect)
    mylog("before hit", damageCount)
    self:_Hit(creature, targetCreature, damageType, damage, comboDamageLabel, forceSingleDamage, hitEP, targetPosition, allowEffect, allowHurtNum, damageCount, effectPath, lodLevel, priority, effectType, dirAngleY)
  end
  if nil ~= shareDamageInfos then
    local shareDamageHitEP = RoleDefines_EP.Middle
    local index = 1
    for i = 1, shareDamageInfos[1] do
      self:_DoShareDamage(creature, shareDamageInfos[index + 1], shareDamageInfos[index + 2], shareDamageInfos[index + 3], shareDamageHitEP, damageType, forceSingleDamage)
      index = index + 3
    end
  end
end

function SkillHitWorker:_DoShareDamage(creature, targetGUID, shareDamageType, damage, hitEP, damageType, forceSingleDamage)
  local targetCreature = FindCreature(targetGUID)
  if nil == targetCreature then
    return
  end
  local targetPosition = tempVector3
  LuaVector3.Better_Set(targetPosition, targetCreature.assetRole:GetEPOrRootPosition(hitEP))
  local allowEffect = SkillLogic_Base.AllowTargetEffect(creature, targetCreature)
  local allowHurtNum = SkillLogic_Base.AllowTargetHurtNum(creature, targetCreature)
  self:_Hit(creature, targetCreature, shareDamageType, damage, nil, forceSingleDamage, hitEP, targetPosition, allowEffect, allowHurtNum)
end

function SkillHitWorker:_PlayEffect(creature, targetCreature, damageType, damage, hitEP, allowEffect)
  if not allowEffect then
    return nil, nil
  end
  local args = self.args
  local skillInfo = args[1]
  local fromPosition = args[2]
  local effectPath = args[5]
  local playDefaultEffect = true
  local lodLevel, priority, effectType, tempEffectPath, tempHitEP
  if DamageType.Block == damageType then
    playDefaultEffect = false
    if nil == effectPath then
      tempEffectPath, lodLevel, priority, effectType, tempHitEP = skillInfo:GetBlockHitEffectInfo(creature, targetCreature)
      if nil ~= tempEffectPath then
        effectPath = tempEffectPath
      end
      if nil ~= tempHitEP then
        hitEP = tempHitEP
      end
    end
  elseif DamageType.AutoBlock == damageType or DamageType.WeaponBlock == damageType or DamageType.Miss == damageType then
    playDefaultEffect = false
    effectPath = nil
  elseif DamageType.Treatment == damageType then
    playDefaultEffect = false
    if nil == effectPath then
      effectPath, lodLevel, priority, effectType = skillInfo:GetTreatmentHitEffectPath(creature, targetCreature)
      if nil == effectPath then
        effectPath, lodLevel, priority, effectType = skillInfo:GetHitEffectPath(creature, targetCreature)
      end
    end
  elseif nil == effectPath and damage ~= 0 and DamageType.Miss ~= damageType and DamageType.Barrier ~= damageType and DamageType.None ~= damageType then
    effectPath, lodLevel, priority, effectType = skillInfo:GetHitEffectPath(creature, targetCreature)
    if effectPath ~= nil then
      playDefaultEffect = false
    end
  end
  local targetPosition = tempVector3
  LuaVector3.Better_Set(targetPosition, targetCreature.assetRole:GetEPOrRootPosition(hitEP))
  local dirAngleY = VectorHelper.GetAngleByAxisY(fromPosition, targetPosition)
  if nil ~= effectPath then
    local effect = Asset_Effect.PlayOneShotAt(effectPath, targetPosition, nil, nil, nil, lodLevel, priority, effectType)
    effect:ResetLocalEulerAnglesXYZ(0, dirAngleY, 0)
  end
  if playDefaultEffect then
    effectPath, lodLevel, priority, effectType = skillInfo:GetDefaultHitEffectPath(creature, damageType, targetCreature)
    if effectPath ~= nil then
      local effect = Asset_Effect.PlayOneShotAt(effectPath, targetPosition, nil, nil, nil, lodLevel, priority, effectType)
      effect:ResetLocalEulerAnglesXYZ(0, dirAngleY, 0)
    end
  end
  return effectPath, targetPosition, lodLevel, priority, effectType, dirAngleY
end

function SkillHitWorker:_Hit(creature, targetCreature, damageType, damage, comboDamageLabel, forceSingleDamage, hitEP, targetPosition, allowEffect, allowHurtNum, damageCount, effectPath, lodLevel, priority, effectType, dirAngleY)
  local args = self.args
  local skillInfo = args[1]
  mylog("_Hit", UnityFrameCount)
  local buffType
  if DamageType.AutoBlock == damageType then
    buffType = "AutoBlock"
  elseif DamageType.WeaponBlock == damageType then
    buffType = "WeaponBlock"
  end
  if buffType ~= nil then
    local buffEffect = targetCreature.data:GetBuffEffectByType(buffType)
    if nil ~= buffEffect then
      if buffEffect.action ~= nil then
        targetCreature:Logic_Hit(buffEffect.action, buffEffect.stiff)
      end
      local effectEPID = buffEffect.ep or 0
      if nil ~= buffEffect.effect then
        local effectPaths = Game.PreprocessEffectPaths(StringUtil.Split(buffEffect.effect, ","))
        if nil ~= effectPaths then
          local effectPath, lodLevel, priority, effectType = skillInfo:GetEffectPath(creature, effectPaths, Asset_Effect.EffectTypes.Hit, targetCreature)
          if nil ~= effectPath then
            targetCreature.assetRole:PlayEffectOneShotAt(effectPath, effectEPID, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
          end
        end
      end
      if nil ~= buffEffect.se then
        targetCreature.assetRole:PlaySEOneShotOn(buffEffect.se)
      end
    end
    return
  end
  local noHit = skillInfo:NoHit(creature, damageType)
  damageCount = forceSingleDamage and 1 or damageCount or skillInfo:GetDamageCount(creature, targetCreature, damageType, damage)
  if not allowEffect then
    if 1 < damageCount then
      local comboArgs = SkillComboHitWorker.GetArgs()
      comboArgs[1] = targetCreature
      comboArgs[2] = damageType
      comboArgs[3] = damage
      comboArgs[4] = damageCount
      comboArgs[5] = hitEP
      comboArgs[6] = noHit
      comboArgs[7] = nil
      comboArgs[8] = nil
      comboArgs[9] = nil
      comboArgs[10] = nil
      comboArgs[11] = creature
      comboArgs[12] = allowEffect
      comboArgs[13] = skillInfo
      comboArgs[14] = allowHurtNum
      comboArgs[15] = nil
      comboArgs[16] = effectPath
      comboArgs[17] = targetPosition
      comboArgs[18] = lodLevel
      comboArgs[19] = priority
      comboArgs[20] = effectType
      comboArgs[21] = dirAngleY
      Game.SkillWorkerManager:CreateWorker_ComboHit(comboArgs)
      SkillComboHitWorker.ClearArgs(comboArgs)
    end
    return
  end
  if nil == targetPosition then
    return
  end
  local fromPosition = args[2]
  local fromWeaponID = args[4]
  local sePath, element = skillInfo:GetHitSEPath(creature, fromWeaponID, damageType)
  mylog("CalcDamageLabelParams", damageCount, UnityFrameCount)
  local labelType, labelColorType = SkillLogic_Base.CalcDamageLabelParams(fromPosition, targetPosition, damageType, targetCreature)
  local labelPosition = targetPosition
  if (DamageType.Miss == damageType or DamageType.Barrier == damageType) and nil ~= creature then
    labelPosition = tempVector3_1
    LuaVector3.Better_Set(labelPosition, creature.assetRole:GetEPOrRootPosition(RoleDefines_EP.Middle))
  end
  if 1 < damageCount then
    local comboArgs = SkillComboHitWorker.GetArgs()
    comboArgs[1] = targetCreature
    comboArgs[2] = damageType
    comboArgs[3] = damage
    comboArgs[4] = damageCount
    comboArgs[5] = hitEP
    comboArgs[6] = noHit
    comboArgs[7] = sePath
    comboArgs[8] = labelType
    comboArgs[9] = labelColorType
    comboArgs[10] = comboDamageLabel
    comboArgs[11] = creature
    comboArgs[12] = allowEffect
    comboArgs[13] = skillInfo
    comboArgs[14] = allowHurtNum
    comboArgs[15] = element
    comboArgs[16] = effectPath
    comboArgs[17] = targetPosition
    comboArgs[18] = lodLevel
    comboArgs[19] = priority
    comboArgs[20] = effectType
    comboArgs[21] = dirAngleY
    Game.SkillWorkerManager:CreateWorker_ComboHit(comboArgs)
    SkillComboHitWorker.ClearArgs(comboArgs)
  else
    if not noHit and not self.noHitEffect then
      targetCreature:Logic_Hit()
    end
    if allowHurtNum then
      if comboDamageLabel == nil then
        SkillLogic_Base.ShowDamage_Single(damageType, damage, labelPosition, labelType, labelColorType, targetCreature, skillInfo, creature)
      else
        LuaVector3.Better_Set(labelPosition, targetCreature.assetRole:GetEPOrRootPosition(RoleDefines_EP.Top))
        local crit
        if damageType == CommonFun.DamageType.Crit then
          if skillInfo and skillInfo:ShowMagicCrit(targetCreature) then
            crit = HurtNum_CritType.MAtk
          else
            crit = HurtNum_CritType.PAtk
          end
        end
        comboDamageLabel:Show(damage, labelPosition, creature == Game.Myself, crit, targetCreature == Game.Myself)
      end
    end
    if nil ~= sePath then
      local delay = skillInfo:GetHitSEDelay(creature)
      targetCreature.assetRole:PlaySEOneShotOn(sePath, AudioSourceType.SKILL_Hit, nil, delay)
    end
  end
end

function SkillHitWorker:SetHitedTargetGoPos(hitedTarget_gopos)
  self.hitedTarget_gopos = hitedTarget_gopos
end

function SkillHitWorker:SetEmitTarget(emit_targets)
  if emit_targets then
    self.emit_targets = {}
    _TableShallowCopy(self.emit_targets, emit_targets)
  end
end

function SkillHitWorker:_SpecialHit(creature, targetCreature)
  if self.noHitEffect then
    return
  end
  local args = self.args
  local skillInfo = args[1]
  local specialEffects = skillInfo:GetSpecialHitEffects(creature)
  if nil == specialEffects or #specialEffects <= 0 then
    return
  end
  local fromPosition = args[2]
  local targetCreatureLogicTransform = targetCreature.logicTransform
  local pvpMap = Game.MapManager:IsPVPMode()
  local isGVG = Game.MapManager:IsPVPMode_GVGDetailed()
  local hitedMovePos = self.hitedTarget_gopos and self.hitedTarget_gopos[targetCreature.data.id]
  if not hitedMovePos then
    return
  end
  local x, y, z, speed, direction = hitedMovePos[1], hitedMovePos[2], hitedMovePos[3], hitedMovePos[4], hitedMovePos[5]
  local dirPoint = LuaVector3.New(x, y, z)
  local dirMoveDistance = LuaVector3.Distance(targetCreatureLogicTransform.currentPosition, dirPoint)
  if 0.01 < dirMoveDistance then
    local dirAngleY = VectorHelper.GetAngleByAxisY(targetCreatureLogicTransform.currentPosition, dirPoint)
    if "forward" == direction then
      dirAngleY = NumberUtility.Repeat(dirAngleY + 180, 360)
    end
    targetCreatureLogicTransform:ExtraDirMove(dirAngleY, dirMoveDistance, speed, function(logicTransform, arg)
      dirPoint:Destroy()
    end, nil, dirPoint, skillInfo:IsIgnoreTerrain())
  end
end

function SkillHitWorker:_MultiSpecialHit(targets)
  if self.noHitEffect then
    return
  end
  local skillInfo = self.args[1]
  local specialEffects = skillInfo:GetSpecialHitEffects(creature)
  if specialEffects == nil or #specialEffects <= 0 then
    return
  end
  local effectLow = FunctionPerformanceSetting.Me():IsEffectLow()
  for i = 1, #specialEffects do
    local specialEffect = specialEffects[i]
    if specialEffect.type == SpecialHitEffectTypes.MultiTargetConnect then
      if effectLow then
        return
      end
      for j = 1, #targets do
        local creature = FindCreature(targets[j])
        if creature ~= nil then
          local nextTarget = targets[j + 1]
          if nextTarget == nil then
            nextTarget = targets[1]
          end
          creature:Client_AddSpEffect(nextTarget, specialEffect.speffect, specialEffect.duration)
        end
      end
    end
  end
end

function SkillHitWorker:Delay()
  if self.delayed then
    return
  end
  self.delayed = true
  local args = self.args
  local targetCount = args[7]
  if 0 < targetCount then
    for i = 1, targetCount do
      local index = 7 + (i - 1) * arrayCount
      local targetCreature = FindCreature(args[index + 1])
      if nil ~= targetCreature then
        targetCreature.ai:SetDieBlocker(self)
      end
      local comboDamageLabel = args[index + 5]
      if nil ~= comboDamageLabel then
        comboDamageLabel:AddRef()
      end
    end
  end
end

function SkillHitWorker:DoConstruct(asArray, args)
  self.ref = 0
  self.delayed = false
end

function SkillHitWorker:DoDeconstruct(asArray)
  local args = self.args
  local targetCount = args[7]
  if 0 < targetCount then
    if self.delayed then
      for i = 1, targetCount do
        local index = 7 + (i - 1) * arrayCount
        local targetCreature = FindCreature(args[index + 1])
        if nil ~= targetCreature then
          targetCreature.ai:ClearDieBlocker(self)
        end
        DestroyShareDamageInfos(args[index + 4])
        args[index + 4] = nil
        local comboDamageLabel = args[index + 5]
        if nil ~= comboDamageLabel then
          comboDamageLabel:SubRef()
          args[index + 5] = nil
        end
      end
    else
      for i = 1, targetCount do
        local index = 7 + (i - 1) * arrayCount
        DestroyShareDamageInfos(args[index + 4])
        args[index + 4] = nil
        local comboDamageLabel = args[index + 5]
        if nil ~= comboDamageLabel then
          args[index + 5] = nil
        end
      end
    end
  end
  args[7] = 0
  self.hitedTarget_gopos = nil
  self.noHitEffect = false
  self.emit_targets = nil
end
