SkillBase = class("SkillBase")
local FindCreature = SceneCreatureProxy.FindCreature
local CreatureHideOpt = Asset_Effect.DeActiveOpt.CreatureHide
local AttackDurationLimit = 3
local AttackDurationLimit_NoAction = 1
local AttackDurationLimit_Temp = 0.8
local AttackWorker = {
  [1] = nil,
  [2] = autoImport("SkillAttackWorker_Dive"),
  [3] = autoImport("SkillAttackWorker_MissileFrom"),
  [4] = autoImport("SkillAttackWorker_Dash"),
  [5] = autoImport("SkillAttackWorker_Jump"),
  [6] = autoImport("SkillAttackWorker_JumpDown")
}
local CastWorker = {
  [1] = autoImport("SkillCastWorker_IntervalEffect"),
  [2] = autoImport("SkillCastWorker_JumpUp")
}
local tempEffectArray = {}
SkillBase.AttackWorker = AttackWorker

function SkillBase:ctor()
  self.info = nil
  self.visible = true
  self.phaseData = SkillPhaseData.Create(0)
  self.oldPhase = SkillPhase.None
  self.fireIndex = 1
  self.fireCount = 1
  self.instanceID = 1
  self.effects = {}
  self.ses = {}
  self.comboDamageLabels = {}
  self.attackWorker = nil
  self.attackTimeElapsed = -1
  self.attackTimeDuration = -1
  self.running = false
  self.interrupt = nil
  self.lockRotation = false
  self.noMoveAction = false
  self.castWorker = nil
  self.castEndTime = 0
end

function SkillBase:IsClientSkill()
  return false
end

function SkillBase:IsServerSkill()
  return false
end

function SkillBase:OnDelayHit(creature, phaseData)
end

function SkillBase:SetEffectVisible(visible)
  if self.visible ~= visible then
    self.visible = visible
    local effect
    for i = 1, #self.effects do
      effect = self.effects[i]
      if effect ~= nil then
        effect:SetActive(self.visible, CreatureHideOpt)
      end
    end
  end
end

function SkillBase:Speak(creature)
  if self:IsAttackSkill(creature) and not self:IsTriggerKickSkill(self.info:GetSkillID(), creature) then
    return
  end
  local skillName = self.info:GetSpeakName(creature)
  if nil == skillName then
    return
  end
  if self.info:NoSpeak(creature) then
    return
  end
  local sceneUI = creature:GetSceneUI()
  if nil ~= sceneUI then
    sceneUI.roleTopUI:SpeakSkill(skillName)
  end
end

function SkillBase:_PreLaunch(creature)
  local preLaunchParams = self.info:GetPreLaunchParams(creature)
  if preLaunchParams ~= nil then
    local type = preLaunchParams.type
    if type == 1 then
      local parts = creature:GetDressParts()
      for k, v in pairs(preLaunchParams) do
        local index = Asset_Role.PartIndex[k]
        if index ~= nil then
          parts[index] = v
        end
      end
      creature.assetRole:Redress(parts, true)
    end
  end
end

function SkillBase:_ResetPreLaunch(creature)
  local preLaunchParams = self.info:GetPreLaunchParams(creature)
  if preLaunchParams ~= nil then
    local type = preLaunchParams.type
    if type == 1 then
      creature:ReDress()
    end
  end
end

function SkillBase:GetSkillID()
  return self.info and self.info:GetSkillID()
end

function SkillBase:SetSkillID(skillID)
  if 0 ~= skillID then
    self.info = Game.LogicManager_Skill:GetSkillInfo(skillID)
    Debug_AssertFormat(nil ~= self.info and nil ~= self.info.LogicClass, "Skill or LogicClass is nil: {0}", skillID)
  else
    self.info = nil
  end
end

function SkillBase:GetCastTime(creature)
  local castTime, _ = self.info:GetCastInfo(creature)
  return castTime
end

function SkillBase:IsAttackSkill(creature)
  return creature.data ~= nil and creature.data:IsAttackSkill(self.info:GetSkillID())
end

function SkillBase:IsCastSkill(phase)
  if phase == SkillPhase.Cast then
    return true
  end
  if phase == SkillPhase.FreeCast then
    return true
  end
  return false
end

function SkillBase:AddEffect(effect)
  if false == self.visible and effect ~= nil then
    effect:SetActive(self.visible, CreatureHideOpt)
  end
  TableUtility.ArrayPushBack(self.effects, effect)
  effect:RegisterWeakObserver(self)
end

function SkillBase:ObserverDestroyed(effect)
  TableUtility.ArrayRemove(self.effects, effect)
end

function SkillBase:AddSE(se)
  TableUtility.ArrayPushBack(self.ses, se)
end

function SkillBase:CreateComboDamageLabel(i)
  local comboDamageLabel = self.comboDamageLabels[i]
  if nil == comboDamageLabel then
    comboDamageLabel = SceneUIManager.Instance:GetStaticHurtLabelWorker()
    comboDamageLabel:AddRef()
    self.comboDamageLabels[i] = comboDamageLabel
  end
  return comboDamageLabel
end

function SkillBase:GetComboDamageLabel(i)
  return self.comboDamageLabels[i]
end

function SkillBase:Fire(creature)
  if not self.running then
    return
  end
  if self.fireIndex > self.fireCount and not self.info:NoLimitFire(creature) then
    return
  end
  local LogicClass = self.info.LogicClass
  LogicClass.Fire(self, creature)
  self:AddFireIndex()
  if self.fireIndex > self.fireCount then
    self:_BeNotDieBlocker()
    if self.attackAction ~= nil then
      local info = self:GetAnimationEventInfo(creature.assetRole, self.attackAction)
      if info ~= nil and info.interrupt == nil then
        self:Interrupt(creature)
      end
    end
  end
end

function SkillBase:Interrupt(creature)
  if not self.running then
    return
  end
  self.interrupt = true
end

function SkillBase:End(creature)
  self:SetConcurrent(creature, false, true)
  if not self.running then
    return
  end
  self:_End(creature)
end

function SkillBase:AddFireIndex()
  self.fireIndex = self.fireIndex + 1
end

function SkillBase:_OnPhaseChanged(creature)
  local newPhase = self.phaseData:GetSkillPhase()
  if self.oldPhase == newPhase then
    return
  end
  if SkillPhase.Cast == newPhase then
    self:_OnLaunch(creature)
    creature:Logic_CastBegin()
    self:LaunchCastWarningEffect(creature)
  else
    self:TryCastEnd(creature)
    if SkillPhase.Attack == newPhase or SkillPhase.Invalid == newPhase then
      if not self:IsCastSkill(self.oldPhase) then
        self:_OnLaunch(creature)
      end
      self:_OnAttack(creature)
    end
  end
  self.oldPhase = newPhase
end

function SkillBase:_OnLaunch(creature)
  self:_PreLaunch(creature)
  self:Speak(creature)
end

function SkillBase:LaunchCastWarningEffect(creature)
  if self.info:ShowWarningEffect() then
    if not self.info:HasCustomWarningEffect() then
      self:ShowWarningEffect(creature)
    else
      self:ShowCustomWarningEffect(creature)
    end
  end
end

function SkillBase:ShowCustomWarningEffect(creature)
  local key = self.info:GetSkillID()
  local castTime = self:GetCastTime(creature)
  local customPath, customSize = self.info:GetCustomWarningEffectPath(creature)
  self:PlayCastWarningEffectAtPos(creature, key, customPath, customSize, castTime)
end

function SkillBase:ShutdownCustomWarningEffect(creature)
  local key = self.info:GetSkillID()
  creature:ClearCastWarningEffect(key)
end

function SkillBase:ShutdownCastWarningEffect(creature)
  local key = self.info:GetSkillID()
  creature:ClearCastWarningEffect(key)
end

function SkillBase:_OnAttack(creature)
end

function SkillBase:_BeDieBlocker(creature)
  local phaseData = self.phaseData
  local targetCount = phaseData:GetTargetCount()
  if 0 < targetCount then
    for i = 1, targetCount do
      local guid, _, __ = phaseData:GetTarget(i)
      local creature = FindCreature(guid)
      if nil ~= creature and not creature:IsDead() then
        creature.ai:SetDieBlocker(self)
      end
    end
  end
end

function SkillBase:_BeNotDieBlocker(creature)
  local phaseData = self.phaseData
  local targetCount = phaseData:GetTargetCount()
  if 0 < targetCount then
    for i = 1, targetCount do
      local guid, _, __ = phaseData:GetTarget(i)
      local creature = FindCreature(guid)
      if nil ~= creature then
        creature.ai:ClearDieBlocker(self)
      end
    end
  end
end

function SkillBase:_DestroyEffects(creature)
  TableUtility.ArrayShallowCopy(tempEffectArray, self.effects)
  TableUtility.ArrayClear(self.effects)
  for i = #tempEffectArray, 1, -1 do
    tempEffectArray[i]:Destroy()
    tempEffectArray[i] = nil
  end
end

function SkillBase:_DestroySEs(creature)
  for i = #self.ses, 1, -1 do
    self.ses[i]:Stop()
    self.ses[i] = nil
  end
end

function SkillBase:_CreateComboDamageLabels(creature)
  if 0 < #self.comboDamageLabels then
    return
  end
  local targetCount = self.phaseData:GetTargetCount()
  if 0 < targetCount then
    local labels = self.comboDamageLabels
    for i = 1, targetCount do
      labels[i] = SceneUIManager.Instance:GetStaticHurtLabelWorker()
      labels[i]:AddRef()
    end
  end
end

function SkillBase:_DestroyComboDamageLabels(creature)
  if 0 < #self.comboDamageLabels then
    local labels = self.comboDamageLabels
    for i = #labels, 1, -1 do
      labels[i]:SubRef()
      labels[i] = nil
    end
  end
end

function SkillBase:_Clear(creature)
  if creature then
    creature:Logic_OnMountTransformActionFinished()
  end
  self:_BeNotDieBlocker(creature)
  self:_DestroyEffects(creature)
  self:_DestroySEs(creature)
  self:_DestroyComboDamageLabels(creature)
  if nil ~= self.attackWorker then
    self.attackWorker:End(self, creature)
    self.attackWorker:Destroy()
    self.attackWorker = nil
  end
  self.fireIndex = 1
  self.fireCount = 1
  self.attackTimeElapsed = -1
  self.attackTimeDuration = -1
  self.interrupt = nil
  if self.castWorker then
    self.castWorker:End(self, creature)
    self.castWorker:Destroy()
    self.castWorker = nil
  end
end

function SkillBase:_SwitchToCast(creature)
  self.castEndTime = self:GetCastTime(creature) + UnityTime
  local LogicClass = self.info.LogicClass
  self.instanceID = self.instanceID + 1
  local castParams = self.info:GetCastParams(creature)
  if LogicClass.Cast(self, creature) then
    if self.info:GetEffectInterval() then
      local castWorkerClass = CastWorker[1]
      local worker = castWorkerClass.Create(self.info)
      self.castWorker = worker
      worker:Start(self, creature)
    elseif castParams and castParams.type then
      local castWorkerClass = CastWorker[castParams.type]
      local worker = castWorkerClass.Create(self.info)
      self.castWorker = worker
      worker:Start(self, creature)
    end
    self.running = true
    self:_OnPhaseChanged(creature)
  else
    self:_End(creature)
  end
  self:SetConcurrent(creature, true)
end

function SkillBase:_SwitchToFreeCast(creature)
  creature:Logic_AddSkillFreeCast(self.info)
end

function SkillBase:_SwitchToAttack(creature, ignoreCast)
  local preAttackParams = self.info:GetPreAttackParams(creature)
  if nil ~= preAttackParams then
    local attackWorkerClass = AttackWorker[preAttackParams.type]
    local worker = attackWorkerClass.Create(preAttackParams)
    if worker:Start(self, creature) then
      self.attackWorker = worker
      self.running = true
      self:_BeDieBlocker(creature)
      self:_OnPhaseChanged(creature)
    else
      worker:Destroy()
      self:_End(creature, ignoreCast)
    end
    self:SetConcurrent(creature, true)
    return
  end
  local LogicClass = self.info.LogicClass
  self.instanceID = self.instanceID + 1
  local ret, actionPlayed, attackSpeed = LogicClass.Attack(self, creature, self:IsAttackSkill(creature), self:IsTriggerKickSkill(self:GetSkillID(), creature))
  local getAdjustAttackDuration = self.info:GetAdjustAttackDuration(creature)
  if self:_CheckAttackResult(ret, actionPlayed, attackSpeed, getAdjustAttackDuration) then
    self.running = true
    if not actionPlayed and self.info:NoAction(creature) then
      self:Fire(creature)
      self.attackTimeDuration = 0
    end
    self:_BeDieBlocker(creature)
    self:_OnPhaseChanged(creature)
  else
    self:_End(creature, ignoreCast)
  end
  self:SetConcurrent(creature, true)
end

function SkillBase:_SwitchToInvalid(creature)
  self.running = true
  self:_OnPhaseChanged(creature)
end

function SkillBase:_CheckAttackResult(ret, actionPlayed, attackSpeed, useAdjustAttackDuration)
  if ret then
    self.attackTimeElapsed = 0
    if actionPlayed then
      self.attackTimeDuration = useAdjustAttackDuration and AttackDurationLimit_Temp or AttackDurationLimit
    else
      self.attackTimeDuration = AttackDurationLimit_NoAction
    end
  end
  return ret
end

function SkillBase:_End(creature, ignoreCast)
  self.attackAction = nil
  self:_Clear(creature)
  self:_ResetPreLaunch(creature)
  self:CastEnd(creature)
  self.running = false
  self:_OnPhaseChanged(creature)
end

function SkillBase:SetAttackWorkerMove(creature, x, y, z)
  local attackWorker = self.attackWorker
  if attackWorker ~= nil and attackWorker.SetWorkerMove ~= nil then
    return attackWorker:SetWorkerMove(self, creature, x, y, z)
  end
  return false
end

function SkillBase:SetConcurrent(creature, value, ignoreAI)
  if not self.info or not self.info:AllowConcurrent(creature) then
    return false
  end
  if not ignoreAI then
    creature.ai:SetConcurrent(value)
  end
  if self.info:IsSkillDirectionRect(creature) and (not value or not creature:IsConcurrentRotateOnly()) then
    self:SetLockRotation(creature, value)
  end
  if self.info:NoMoveAction(creature) then
    self:SetNoMoveAction(creature, value)
  end
  return true
end

function SkillBase:SetLockRotation(creature, value)
  if self.lockRotation == value then
    return
  end
  self.lockRotation = value
  creature:Logic_LockRotation(value)
end

function SkillBase:SetNoMoveAction(creature, value)
  if self.noMoveAction == value then
    return
  end
  self.noMoveAction = value
  creature:Client_NoMoveAction(value)
end

function SkillBase:Update_Cast(time, deltaTime, creature)
  if self.castWorker then
    self.castWorker:Update(self, time, deltaTime, creature)
  end
  return self.info.LogicClass.Update_Cast(self, time, deltaTime, creature)
end

function SkillBase:Update_Attack(time, deltaTime, creature)
  local ret = false
  if nil ~= self.attackWorker then
    ret = self.attackWorker:Update(self, time, deltaTime, creature)
  else
    ret = self.info.LogicClass.Update_Attack(self, time, deltaTime, creature)
  end
  if ret then
    if 0 <= self.attackTimeElapsed then
      self.attackTimeElapsed = self.attackTimeElapsed + deltaTime
      if self.attackTimeDuration <= self.attackTimeElapsed then
        self.attackTimeElapsed = -1
        return false
      end
    elseif self.info:NoActionNeedFire() then
      self.attackTimeElapsed = 0.5
    end
  end
  return ret
end

function SkillBase:Update(time, deltaTime, creature)
  if not self.running then
    return
  end
  self:TryCastEnd(creature)
  local skillPhase = self.phaseData:GetSkillPhase()
  if SkillPhase.Cast == skillPhase then
    if not self:Update_Cast(time, deltaTime, creature) and self.running then
      self:_SwitchToAttack(creature)
    end
  elseif SkillPhase.Attack == skillPhase then
    if not self:Update_Attack(time, deltaTime, creature) then
      self:_End(creature)
    end
  elseif SkillPhase.Invalid == skillPhase then
    self:_End(creature)
  end
end

function SkillBase:CheckChant(creature)
  return self.info:NoChant(creature)
end

function SkillBase:IsCastingMoveRunSkill()
  return false
end

function SkillBase:IsGuideCast()
  return self.info:IsGuideCast()
end

function SkillBase:ShowWarningEffect(creature)
  if creature then
    local path = self:GetCastWarningEffectPath(creature)
    if not path then
      return
    end
    local key = self.info:GetSkillID()
    local castTime = self:GetCastTime(creature)
    local endSize, endSize2 = self.info:GetShowLength(creature)
    local scale = creature:GetScale() or 1
    if scale ~= 0 and endSize then
      creature:PlayCastWarningEffect(key, path, endSize / scale, (endSize2 or endSize) / scale, castTime)
    end
  end
end

function SkillBase:GetCastWarningEffectPath(creature)
  if self.info.logicParam.angle then
    return EffectMap.SkillEffectMap.Eff_sector_buff
  elseif self.info.logicParam.range then
    return EffectMap.SkillEffectMap.Eff_circular_buff
  elseif self.info.logicParam.distance then
    return EffectMap.SkillEffectMap.Eff_square_buff
  end
  return nil
end

function SkillBase:PlayCastWarningEffectAtPos(creature, key, path, targetSize, casttime)
  local effect = creature:GetWeakData(key)
  if effect then
    return
  end
  local targetPos = self.phaseData:GetPosition()
  effect = Asset_Effect.PlayAt(path, targetPos, nil, nil, targetSize)
  creature:SetWeakData(key, effect)
end

function SkillBase:IsCastingShiftPointSkill()
  return false
end

function SkillBase:IsTriggerKickSkill(skillid, creature)
  return false
end

function SkillBase:IsLastHitOnly()
  return self.info:IsLastHitOnly()
end

function SkillBase:GetAttackUIEffectPath()
  return self.info:GetAttackUIEffectPath()
end

function SkillBase:TryCastEnd(creature)
  if UnityTime >= self.castEndTime then
    self:CastEnd(creature)
  end
end

function SkillBase:CastEnd(creature)
  if self.castEndTime > 0 then
    self.castEndTime = 0
    creature:Logic_CastEnd()
    creature:ClearChantSkill(self:GetSkillID())
    self:ShutdownCastWarningEffect(creature)
    self:ShutdownCustomWarningEffect(creature)
    self:_DestroyEffects(creature)
  end
end

function SkillBase:IsLeadSkill(creature)
  return self.info:IsGuideCast(creature) or self.info:InfiniteCast(creature)
end

function SkillBase:NoBetterFight(creature)
  if GameConfig.SystemForbid.BetterFight then
    return true
  end
  if creature.assetRole:GetPartObject(Asset_Role.PartIndex.Body) == nil then
    return true
  end
  if self:IsLeadSkill() then
    return true
  end
  if self:IsAttackSkill(creature) then
    return true
  end
  return false
end

function SkillBase:GetAnimationEventInfo(assetRole, name)
  local bodyID = assetRole:GetPartID(Asset_Role.PartIndex.Body)
  if bodyID == nil or bodyID <= 0 then
    return
  end
  local bodyData = Table_Body[bodyID]
  if bodyData == nil then
    return
  end
  local branch = bodyData.AvatarBranch or 0
  local config = Table_AnimationEventInfo[branch]
  if config == nil then
    return
  end
  return config[name]
end

function SkillBase:GetCastInfo(creature)
  local castTime, allowInterrupted = self.info:GetCastInfo(creature)
  self.originCastTime = castTime
  if self:NoBetterFight(creature) then
    return castTime, allowInterrupted
  end
  local name = SkillLogic_Base.GetAttackAction(self, creature)
  if name ~= nil then
    local assetRole = creature.assetRole
    name = assetRole:ConvertActionName(name, nil, true)
    if not self.info:NoBetterFight() then
      local info = self:GetAnimationEventInfo(assetRole, name)
      if info ~= nil then
        local fire = info.fire
        if fire ~= nil then
          castTime = castTime - fire
        end
      end
    end
  end
  self.attackAction = name
  self.phaseData:SetActionName(name)
  return castTime, allowInterrupted
end

function SkillBase:NeedDelayAttack()
  return false
end

function SkillBase:IsCastingSkill()
  local skillPhase = self.phaseData:GetSkillPhase()
  return SkillPhase.Cast == skillPhase or SkillPhase.Attack == skillPhase
end

function SkillBase:IsCastingMoveBreakSkill()
  return false
end
