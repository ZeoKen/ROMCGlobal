autoImport("Table_AnimationEventInfo")
ClientSkill = class("ClientSkill", SkillBase)
local FindCreature = SceneCreatureProxy.FindCreature

function ClientSkill:ctor()
  ClientSkill.super.ctor(self)
  self.targetCreatureGUID = 0
  self.targetPosition = LuaVector3.Zero()
  self.allowInterrupted = false
  self.castTime = 0
  self.castTimeElapsed = 0
  self.originCastTime = 0
  self.random = 0
  self:_ResetAttackInfo()
end

function ClientSkill:IsClientSkill()
  return true
end

function ClientSkill:GetCastTime(creature)
  return self.originCastTime
end

function ClientSkill:GetAttackAction(creature)
  return self.attackAction
end

function ClientSkill:Launch(targetCreature, targetPosition, creature, ignoreCast, invalid, isAttackSkill, autoInterrupt, isTrigger, manual)
  if nil == creature.data.randomFunc then
    return false
  end
  self.isAttackSkill = isAttackSkill
  self.autoInterrupt = autoInterrupt
  if nil ~= targetCreature then
    self.targetCreatureGUID = targetCreature.data.id
  else
    self.targetCreatureGUID = 0
  end
  local p
  if nil ~= targetPosition then
    p = targetPosition
    self.phaseData:SetPosition(targetPosition)
    local angleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), targetPosition)
    self.phaseData:SetAngleY(angleY)
  else
    if nil ~= targetCreature and self.info:PlaceTarget(creature) then
      p = targetCreature:GetPosition()
    else
      p = creature:GetPosition()
    end
    self.phaseData:SetPosition(p)
    self.phaseData:SetAngleY(nil)
  end
  LuaVector3.Better_Set(self.targetPosition, p[1], p[2], p[3])
  if self.info:NeedMarkPoint() then
    SkillProxy.Instance:SetMarkPoint(sortID, p[1], p[2], p[3])
  end
  if invalid then
    self:_SwitchToInvalid(creature, manual)
  elseif ignoreCast or self.info:CheckInstantAttack() and creature:Client_IsMoving() then
    self:_SwitchToAttack(creature, ignoreCast, nil, manual)
  else
    self.castTime, self.allowInterrupted = self:GetCastInfo(creature)
    if self.castTime > 0.01 then
      if not ignoreCast and not self.info:IsIgnoreFreeCast() and creature.data:FreeCast() then
        self:_SwitchToFreeCast(creature, manual)
      else
        self:_SwitchToCast(creature, manual)
      end
    else
      self:_SwitchToAttack(creature, nil, nil, manual)
    end
  end
  if self.info:AllowAttackInterrupted() then
    self.allowInterrupted = true
  end
  if self.running then
    Game.SkillComboManager:OnLaunch(self:GetSkillID())
    Game.SkillClickUseManager:SetWaitForCombo(self:GetSkillID())
  end
  return self.running, self.allowInterrupted
end

function ClientSkill:Interrupt(creature)
  if not self.running then
    return
  end
  if not self.info:CheckCanBeInterrupted() then
    return
  end
  ClientSkill.super.Interrupt(self, creature)
  Game.SkillComboManager:OnInterrupt(self:GetSkillID())
  if self.autoInterrupt and self.info:NoAttackSpeed() then
    self:End(creature)
  end
end

function ClientSkill:InterruptCast(creature)
  if self.running and self.phaseData:GetSkillPhase() == SkillPhase.Cast then
    self:End(creature)
  end
end

function ClientSkill:CheckTargetCreature(creature)
  local targetCreature = FindCreature(self.targetCreatureGUID)
  if nil == targetCreature then
    return false
  end
  if not self:CheckTargetPosition(creature, targetCreature:GetPosition()) then
    return false
  end
  return self.info:CheckTarget(creature, targetCreature)
end

function ClientSkill:CheckTargetPosition(creature, targetPosition)
  local launchRange = self.info:GetLaunchRange(creature)
  local checkDis = self.info:GetCheckDis() or 0
  if 0 < launchRange then
    local testRange = (launchRange + checkDis) * 1.5
    local currentPosition = creature:GetPosition()
    if VectorUtility.DistanceXZ_Square(currentPosition, targetPosition) > testRange * testRange then
      return false
    end
  end
  return true
end

function ClientSkill:_SetPhase(phase, creature)
  self:_Clear(creature)
  self.phaseData:SetSkillPhase(phase)
end

function ClientSkill:_NotifyServer(creature, manual)
  local phaseData = self.phaseData
  if SkillPhase.Attack == phaseData:GetSkillPhase() then
    local targetCount = phaseData:GetTargetCount()
    for i = 1, targetCount do
      local guid, _, _ = phaseData:GetTarget(i)
      local targetCreature = SceneCreatureProxy.FindCreature(guid)
      if nil ~= targetCreature and nil ~= targetCreature.data then
        local targetCamp = targetCreature.data:GetCamp()
        if RoleDefines_Camp.ENEMY == targetCamp then
          creature:Logic_SetSkillState(guid)
          break
        end
      end
    end
  end
  local isTrigger = self:IsTriggerKickSkill()
  creature:Client_UseSkillHandler(self.random, phaseData, self.targetCreatureGUID, isTrigger, manual)
end

function ClientSkill:_OnLaunch(creature)
  ClientSkill.super._OnLaunch(self, creature)
  creature:Logic_OnSkillLaunch(self.info:GetSkillID())
end

function ClientSkill:_OnAttack(creature)
  ClientSkill.super._OnAttack(self, creature)
  creature:Logic_OnSkillAttack(self.info:GetSkillID())
end

function ClientSkill:SetSkillID(skillID)
  self.phaseData:Reset(skillID)
  ClientSkill.super.SetSkillID(self, skillID)
end

function ClientSkill:IsAttackSkill(creature)
  return self.isAttackSkill
end

function ClientSkill:_SwitchToCast(creature, manual)
  self.castTimeElapsed = 0
  self:_SetPhase(SkillPhase.Cast, creature)
  ClientSkill.super._SwitchToCast(self, creature)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.Cast == phase then
    self:_NotifyServer(creature, manual)
  end
end

function ClientSkill:_SwitchToFreeCast(creature, manual)
  self:_SetPhase(SkillPhase.FreeCast, creature)
  ClientSkill.super._SwitchToFreeCast(self, creature)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.FreeCast == phase then
    self:_NotifyServer(creature, manual)
  end
end

function ClientSkill:_SwitchToLeadComplete(creature)
  self.info.LogicClass.Client_DeterminTargets(self, creature)
  self.info.LogicClass.CalSpeicalAttackMove(self, creature)
  self.info.LogicClass.CalSpeicalHitedMove(self, creature)
  self.info.LogicClass.CheckCombo(self, creature)
  self.allowInterrupted = true
  self:_SetPhase(SkillPhase.LeadComplete, creature)
  self:_OnPhaseChanged(creature)
  self:_NotifyServer(creature)
end

local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()

function ClientSkill:_SwitchToAttack(creature, ignoreCast, serverAttack, manual)
  self.random = creature.data.randomFunc.index
  if self.info:CanShiftPoint() and self.info:AllowConcurrent(creature) then
    local angleY = creature:GetAngleY()
    LuaVector3.Better_Set(tempVector3, 0, 0, 1)
    VectorUtility.SelfAngleYToVector3(tempVector3, angleY)
    local position = creature:GetPosition()
    local distance = self.info:GetLaunchRange(creature)
    local ret = NavMeshUtility.Better_RaycastDirection(position, tempVector3_1, tempVector3, distance / 2)
    if not ret then
      LuaVector3.Mul(tempVector3, distance / 2 - 0.001)
      LuaVector3.Better_Add(position, tempVector3, tempVector3_1)
      NavMeshUtility.SelfSample(tempVector3_1)
    end
    self.phaseData:SetAngleY(angleY)
    self.phaseData:SetPosition(tempVector3_1)
  end
  self.info.LogicClass.Client_DeterminTargets(self, creature)
  self.info.LogicClass.CalSpeicalAttackMove(self, creature)
  self.info.LogicClass.CalSpeicalHitedMove(self, creature)
  self.info.LogicClass.CheckCombo(self, creature)
  self.allowInterrupted = false
  self:_SetPhase(SkillPhase.Attack, creature)
  ClientSkill.super._SwitchToAttack(self, creature, ignoreCast)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.Attack == phase then
    local count = self:_GetFixAttackCount(creature)
    count = count and count + 1 or 1
    for i = 1, count do
      self:_NotifyServer(creature, manual)
    end
  end
end

function ClientSkill:_SwitchToInvalid(creature, manual)
  self.allowInterrupted = false
  self:_SetPhase(SkillPhase.Invalid, creature)
  ClientSkill.super._SwitchToInvalid(self, creature)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.Invalid == phase then
    self:_NotifyServer(creature, manual)
  end
end

function ClientSkill:_End(creature, ignoreCast)
  local phase = self.phaseData:GetSkillPhase()
  self.phaseData:SetSkillPhase(SkillPhase.None)
  if SkillPhase.Cast == phase or ignoreCast then
    self:_NotifyServer(creature)
  end
  if self.info:GetAttackUIEffectPath() then
    GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
  end
  Game.SkillComboManager:OnEnd(self:GetSkillID(), self.autoInterrupt)
  ClientSkill.super._End(self, creature)
end

function ClientSkill:_ResetAttackInfo()
  self.attackTime = 0
  self.attackEndTime = -1
  self.attackFrameCount = -1
end

function ClientSkill:UpdateAttackInfo(time)
  if not self.isAttackSkill then
    return
  end
  self.attackEndTime = time
  self.attackFrameCount = UnityFrameCount
end

function ClientSkill:_GetFixAttackCount(creature)
  local frameCount = self.attackFrameCount
  if frameCount == -1 then
    return
  end
  if not self.isAttackSkill then
    self:_ResetAttackInfo()
    return
  end
  if UnityFrameCount - frameCount > 1 then
    self:_ResetAttackInfo()
    return
  end
  local attackTime = self.attackTime
  attackTime = attackTime + (UnityTime - self.attackEndTime)
  local attackInterval = creature.data:GetAttackInterval()
  if attackTime >= attackInterval then
    self:_ResetAttackInfo()
    return 1
  end
  self.attackTime = attackTime
  return
end

function ClientSkill:SetAttackWorkerDir(dir)
  local attackWorker = self.attackWorker
  if attackWorker ~= nil and attackWorker.SetWorkerDir ~= nil then
    attackWorker:SetWorkerDir(dir)
  end
end

function ClientSkill:Update_Cast(time, deltaTime, creature)
  if not self.info.LogicClass.Client_PreUpdate_Cast(self, time, deltaTime, creature) then
    self:_End(creature)
    return false
  end
  if ClientSkill.super.Update_Cast(self, time, deltaTime, creature) then
    self.castTimeElapsed = self.castTimeElapsed + deltaTime
    if self.castTime > self.castTimeElapsed then
      return true
    elseif self:IsLeadSkill(creature) then
      self:_SwitchToLeadComplete(creature)
      return true
    end
  end
  return false
end

function ClientSkill:Update_LeadComplete(time, deltaTime, creature)
  if self.info:IsGuideCast(creature) then
    return false
  end
  if not self.info.LogicClass.Client_PreUpdate_Cast(self, time, deltaTime, creature) then
    return false
  end
  return true
end

function ClientSkill:Update_Attack(time, deltaTime, creature)
  if not self.info.LogicClass.Client_PreUpdate_Attack(self, time, deltaTime, creature) then
    return false
  end
  return ClientSkill.super.Update_Attack(self, time, deltaTime, creature)
end

function ClientSkill:Update(time, deltaTime, creature)
  if not self.running then
    return
  end
  local skillPhase = self.phaseData:GetSkillPhase()
  if SkillPhase.LeadComplete == skillPhase then
    if not self:Update_LeadComplete(time, deltaTime, creature) then
      self:_End(creature)
    end
  else
    ClientSkill.super.Update(self, time, deltaTime, creature)
  end
end

function ClientSkill:GetCurChantTime()
  return self.castTimeElapsed * 1000
end

function ClientSkill:IsCastingMoveRunSkill()
  if not self.info or not self.info:CheckInstantAttack() then
    return false
  else
    local skillPhase = self.phaseData:GetSkillPhase()
    return SkillPhase.Cast == skillPhase
  end
end

function ClientSkill:IsCastingShiftPointSkill()
  if not self.info or not self.info:CanShiftPoint() then
    return false
  else
    local skillPhase = self.phaseData:GetSkillPhase()
    return SkillPhase.Cast == skillPhase
  end
end

local helpDisFunc = function(x1, y1, z1, x2, y2, z2)
  local x = x1 - x2
  local y = y1 - y2
  local z = z1 - z2
  return math.sqrt(x * x + y * y + z * z)
end

function ClientSkill:SyncDirMoveFromServer(creature, phaseData)
  local clientPhaseData = self.phaseData
  local attackSpeed = 1
  local sGopos = phaseData.gopos[1]
  if sGopos then
    local cGopos = clientPhaseData.gopos[1] or creature:GetPosition()
    if VectorUtility.DistanceXYZ_Square(cGopos, sGopos) > 0.25 then
      redlog("修正玩家的attack位置", sGopos[1], sGopos[2], sGopos[3])
      local dirPoint = LuaVector3.New(sGopos[1], sGopos[2], sGopos[3])
      local dirMoveDistance = LuaVector3.Distance(creature:GetPosition(), dirPoint)
      if 0.01 < dirMoveDistance then
        do
          local direction = sGopos[5]
          local dirAngleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), dirPoint)
          if "forward" == direction then
            dirAngleY = NumberUtility.Repeat(dirAngleY + 180, 360)
          end
          creature.logicTransform:ExtraDirMove(dirAngleY, dirMoveDistance, (sGopos[4] or 10) * attackSpeed, function(logicTransform, arg)
            SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
            local effect = creature:GetWeakData("AttackEffectOnRole")
            if effect and self.info and self.info:ManulDestroy() then
              effect:Destroy()
              creature.skill.attackTimeDuration = 0
            end
            if self.info:GetAtkEffectHideBody() then
              creature:HideMyself(false)
            end
            dirPoint:Destroy()
          end, nil, dirPoint, true)
        end
      end
    end
  end
  local cHT_Goposes = clientPhaseData.hitedTarget_gopos
  local sHT_Goposes = phaseData.hitedTarget_gopos
  for targetID, sHT_Gopos in pairs(sHT_Goposes) do
    local cHT_Gopos = cHT_Goposes[targetID] or {
      0,
      0,
      0
    }
    if sHT_Gopos and 1 < helpDisFunc(cHT_Gopos[1], cHT_Gopos[2], cHT_Gopos[3], sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3]) then
      local targetCreature = FindCreature(targetID)
      local dirPoint = LuaVector3.New(sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3])
      local dirMoveDistance = LuaVector3.Distance(creature:GetPosition(), dirPoint)
      if targetCreature then
        redlog("修正玩家的hit位置", targetCreature.data.name, sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3])
        cHT_Gopos[1], cHT_Gopos[2], cHT_Gopos[3] = sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3]
        do
          local direction = sHT_Gopos[5]
          local dirAngleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), dirPoint)
          if "forward" == direction then
            dirAngleY = NumberUtility.Repeat(dirAngleY + 180, 360)
          end
          targetCreature.logicTransform:ExtraDirMove(dirAngleY, dirMoveDistance, sHT_Gopos[4] * attackSpeed, function(logicTransform, arg)
            SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
            dirPoint:Destroy()
          end, nil, dirPoint, true)
        end
      end
    end
  end
end

function ClientSkill:IsTriggerKickSkill()
  return self.isTrigger
end

function ClientSkill:SetIsTrigger(v)
  self.isTrigger = v
end

function ClientSkill:IsCastingMoveBreakSkill()
  if not self.info then
    return false
  end
  if self.info:IsGuideCast() and self.info:IsMoveBreakSkill() then
    local skillPhase = self.phaseData:GetSkillPhase()
    return SkillPhase.Cast == skillPhase or SkillPhase.Guide == skillPhase
  end
  return false
end

function ClientSkill:ChangeTargetPosition(p)
  self.phaseData:SetPosition(p)
end
