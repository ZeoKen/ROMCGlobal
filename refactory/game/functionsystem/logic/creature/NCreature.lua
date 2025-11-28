autoImport("CreatureVisibleHandler")
autoImport("ClientProps")
NCreature = class("NCreature", ReusableObject)
autoImport("NCreature_Effect")
autoImport("NCreature_Client")
autoImport("NCreature_Logic")
autoImport("NCreature_Debug")
local table_ActionAnime = Table_ActionAnime
local config_Action
local skillComboEndAct = "over"
local selfUpdateArroundMyself, selfUpdateSpEffect
local logicTransformUpdate = Logic_Transform.Update
local fixHeightScale = {0.9, 1.1}
local fixWeightScale = {0.9, 1.1}
local checkUIInterval = 0.3
local S2C_Number = ProtolUtility.S2C_Number
local tempVector3 = LuaVector3.Zero()
HandInActionType = {
  Clear = 0,
  HandIn = 1,
  InHand = 2,
  Hold = 3,
  BeHolded = 4,
  DoubleAction = 5
}
CreatureUpdateFrequency = {
  Every1Frame = 1,
  Every2Frame1 = 2,
  Every2Frame2 = 3,
  Every3Frame1 = 4,
  Every3Frame2 = 5,
  Every3Frame3 = 6,
  Every3Frame4 = 7
}
NCreature.ConcurrentType = {Normal = 1, RotateOnly = 2}
local ConcurrentType = NCreature.ConcurrentType

function NCreature.SetForceVisible(forceVisible)
  NCreature.isForceVisible = forceVisible
end

function NCreature.IsForceVisible()
  return NCreature.isForceVisible
end

function NCreature:ctor(aiClass)
  NCreature.super.ctor(self)
  config_Action = Game.Config_Action
  self.data = nil
  self.assetRole = nil
  self.logicTransform = Logic_Transform.new()
  aiClass = aiClass or AI_Creature
  self.ai = aiClass.new()
  self.originalScale = nil
  self.isCullingRegisted = false
  self.updateDeltaTime = 0
  self.updateFrequency = CreatureUpdateFrequency.Every1Frame
end

function NCreature:GetDressPriority()
  return LogicManager_RoleDress.Priority.Normal
end

function NCreature:IsMoving()
  return nil ~= self.logicTransform.targetPosition
end

function NCreature:IsExtraMoving()
  return 0 < #self.logicTransform.extraLogics
end

function NCreature:LookAt(p)
  self.logicTransform:LookAt(p)
end

function NCreature:SetDressEnable(v)
  if self.data and v ~= self.data.dressEnable then
    self.data:SetDressEnable(v)
    self:ReDress()
    if self.partner then
      self.partner:SetDressEnable(v)
    end
    if self.handNpc then
      local npc = self:GetHandNpc()
      if npc then
        npc:SetDressEnable(v)
      end
    end
    if self.expressNpcMap then
      for key, value in pairs(self.expressNpcMap) do
        local npc = self:GetExpressNpc(key)
        if npc then
          npc:SetDressEnable(v)
        end
      end
    end
    if self.stageNpc then
      local npc = self:GetStageNpc()
      if npc then
        npc:SetDressEnable(v)
      end
    end
    if self.customSeat then
      self.customSeat:SetVisible(self, v)
    end
    NScenePetProxy.Instance:SetOwnerDressEnable(self, v)
    NSceneNpcProxy.Instance:SetOwnerDressEnable(self, v)
  end
end

function NCreature:SetDressed(dressed)
  self.dressed = dressed
end

function NCreature:IsDressEnable()
  if self.data then
    return self.data:IsDressEnable()
  end
  return true
end

function NCreature:IsDressed()
  return self.dressed
end

function NCreature:IsBodyCreated()
  local assetRole = self.assetRole
  return assetRole and assetRole:GetPartObject(1) ~= nil
end

function NCreature:IsPhotoStatus()
  return false
end

function NCreature:IsOnSceneSeat()
  return nil ~= Game.SceneSeatManager:GetCreatureSeat(self)
end

function NCreature:IsOnMultiMount()
  return Game.InteractNpcManager:IsMyselfOnInteractMount()
end

function NCreature:GetCreatureType()
  return nil
end

function NCreature:IsRobotNpc()
  return false
end

function NCreature:IsHandInHand()
  return false, nil
end

function NCreature:IsUIMask(uiType, reason)
  if Game.MapManager:IsIgnoreSceneUIMapCellLod() then
    return false
  end
  if self.maskMap and self.maskMap[uiType] then
    if reason then
      return self.maskMap[uiType][reason] ~= nil
    else
      return next(self.maskMap[uiType]) ~= nil
    end
  end
  return false
end

function NCreature:MaskUI(reason, uiType)
  if not self.maskMap then
    self.maskMap = {}
  end
  if not self.maskMap[uiType] then
    self.maskMap[uiType] = {
      [reason] = 1
    }
  else
    self.maskMap[uiType][reason] = 1
  end
  if self.sceneui then
    self.sceneui:MaskUI(reason, uiType, self)
  end
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:MaskUI(reason, uiType)
    end
  end
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(k)
      if npc then
        npc:MaskUI(reason, uiType)
      end
    end
  end
end

function NCreature:UnMaskUI(reason, uiType)
  if self.maskMap and self.maskMap[uiType] then
    self.maskMap[uiType][reason] = nil
    if not next(self.maskMap[uiType]) then
      self.maskMap[uiType] = nil
    end
  end
  if self.sceneui then
    self.sceneui:UnMaskUI(reason, uiType, self)
  end
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:UnMaskUI(reason, uiType)
    end
  end
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(k)
      if npc then
        npc:UnMaskUI(reason, uiType)
      end
    end
  end
end

function NCreature:HandleSettingMask()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:HandleSettingMask(self)
  end
  if self.data.petIDs and #self.data.petIDs > 0 then
    for i = 1, #self.data.petIDs do
      local guid = self.data.petIDs[i]
      local creature = NScenePetProxy.Instance:Find(guid)
      if creature and creature.sceneui and creature.sceneui.roleBottomUI then
        creature.sceneui.roleBottomUI:HandleSettingMask(creature)
      end
    end
  end
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:HandleSettingMask()
    end
  end
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(k)
      if npc then
        npc:HandleSettingMask()
      end
    end
  end
end

function NCreature:HandIn()
  if self:IsPlayingDoubleAction() then
    return
  end
  self:_SetHandInHandAction(HandInActionType.HandIn)
end

function NCreature:InHand()
  self:_SetHandInHandAction(HandInActionType.InHand)
end

function NCreature:ClearHandInHand()
  self:_SetHandInHandAction(HandInActionType.Clear)
end

function NCreature:IsPlayingHandInIdleAction()
  if HandInActionType.HandIn ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.IdleHandIn) and true or false
end

function NCreature:IsPlayingHandInMoveAction()
  if HandInActionType.HandIn ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.MoveHandIn) and true or false
end

function NCreature:IsPlayingHandInAction()
  return self:IsPlayingHandInIdleAction() or self:IsPlayingHandInMoveAction()
end

function NCreature:IsPlayingInHandIdleAction()
  if HandInActionType.InHand ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.IdleInHand) and true or false
end

function NCreature:IsPlayingInHandMoveAction()
  if HandInActionType.InHand ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.MoveInHand) and true or false
end

function NCreature:IsPlayingInHandAction()
  return self:IsPlayingInHandIdleAction() or self:IsPlayingInHandMoveAction()
end

function NCreature:IsReadyToHandIn(handInCP)
  if self:IsDoubleActionBuild() then
    return
  end
  if self.assetRole:IsPlayingAction(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction()) then
    return nil ~= self.assetRole:GetCP(handInCP)
  end
  return false
end

function NCreature:_SetHandInHandAction(action, checkMoving, isDoubleActionMaster)
  if action == self.handInHandAction then
    return
  end
  local oldIdleActionName = self:GetIdleAction()
  local oldMoveActionName = self:GetMoveAction()
  self.handInHandAction = action
  self.isDoubleActionMaster = isDoubleActionMaster
  if self.assetRole:IsPlayingAction(oldIdleActionName) then
    local action = self:GetIdleAction()
    self.assetRole:PlayAction_Simple(action)
    self.assetRole:PlayAction_Simple(self:GetIdleAction())
  elseif self.assetRole:IsPlayingAction(oldMoveActionName) then
    local action = self:GetMoveAction()
    self.assetRole:PlayAction_Simple(action)
    if checkMoving then
      if self:IsMoving() then
        self.assetRole:PlayAction_Simple(self:GetMoveAction())
      else
        self.assetRole:PlayAction_Simple(self:GetIdleAction())
      end
    else
      self.assetRole:PlayAction_Simple(self:GetMoveAction())
    end
  end
end

function NCreature:Hold()
  if self:IsPlayingDoubleAction() then
    return
  end
  self:_SetHandInHandAction(HandInActionType.Hold)
end

function NCreature:BeHolded()
  self:_SetHandInHandAction(HandInActionType.BeHolded)
end

function NCreature:ClearHold()
  self:_SetHandInHandAction(HandInActionType.Clear)
end

function NCreature:ClearBeHolded()
  self:_SetHandInHandAction(HandInActionType.Clear)
end

function NCreature:IsPlayingHoldIdleAction()
  if HandInActionType.Hold ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.IdleHold) and true or false
end

function NCreature:IsPlayingHoldMoveAction()
  if HandInActionType.Hold ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.MoveHold) and true or false
end

function NCreature:IsPlayingHoldAction()
  return self:IsPlayingHoldIdleAction() or self:IsPlayingHoldMoveAction()
end

function NCreature:IsPlayingBeHoldedIdleAction()
  if HandInActionType.BeHolded ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.IdleBeHolded) and true or false
end

function NCreature:IsPlayingBeHoldedMoveAction()
  if HandInActionType.BeHolded ~= self.handInHandAction then
    return false
  end
  return string.find(self.assetRole.actionRaw or "", Asset_Role.ActionName.MoveBeHolded) and true or false
end

function NCreature:IsPlayingBeHoldedAction()
  return self:IsPlayingBeHoldedIdleAction() or self:IsPlayingBeHoldedMoveAction()
end

function NCreature:IsReadyToHold(holdCP)
  if self:IsDoubleActionBuild() then
    return false
  end
  if self.assetRole.action == nil or self.assetRole:IsPlayingAction(self:GetIdleAction()) or self.assetRole:IsPlayingAction(self:GetMoveAction()) then
    return nil ~= self.assetRole:GetCP(holdCP)
  end
  return false
end

function NCreature:IsDoubleActionBuild()
  return self.doubleaction_build == true
end

function NCreature:IsPlayingDoubleAction()
  if self.assetRole == nil then
    return false
  end
  local actionRaw = self.assetRole.actionRaw
  local d_a = config_Action[actionRaw] and config_Action[actionRaw].DoubleAction
  if d_a == nil or d_a <= 0 then
    return false
  end
  return true
end

function NCreature:PlayDoubleAction(isMaster)
  if isMaster then
    self.ai:BreakAll(UnityTime, UnityDeltaTime, self)
  end
  self:_SetHandInHandAction(HandInActionType.DoubleAction, nil, isMaster)
  local handNpc = self:GetHandNpc()
  if handNpc then
    handNpc:SetVisible(false, LayerChangeReason.DoubleAction)
  end
end

function NCreature:ClearDoubleAction()
  self:_SetHandInHandAction(HandInActionType.Clear, true)
  local handNpc = self:GetHandNpc()
  if handNpc then
    handNpc:SetVisible(true, LayerChangeReason.DoubleAction)
  end
end

local HandActionTypeMap = {
  [HandInActionType.HandIn] = Asset_Role.ActionName.IdleHandIn,
  [HandInActionType.InHand] = Asset_Role.ActionName.IdleInHand,
  [HandInActionType.Hold] = Asset_Role.ActionName.IdleHold,
  [HandInActionType.BeHolded] = Asset_Role.ActionName.IdleBeHolded
}

function NCreature:GetIdleAction()
  local handAction = self:GetHandActionFrom(HandActionTypeMap)
  if handAction then
    return handAction
  end
  if HandInActionType.DoubleAction == self.handInHandAction then
    local dactionid = self:GetDoubleActionId(self.new_TwinsActionId)
    if dactionid ~= 0 then
      return table_ActionAnime[dactionid].Name
    else
      local dactionid = self:GetDoubleActionId(self.old_TwinsActionId)
      if dactionid ~= 0 then
        return table_ActionAnime[dactionid].Name
      end
    end
  end
  if self.skillSolo ~= nil then
    local soloAction = self.skillSolo:GetSoloAction()
    if soloAction ~= nil then
      return soloAction
    end
  end
  if self.data:GetDownID() ~= 0 then
    return Asset_Role.ActionName.Idle
  end
  return self.data and self.data.idleAction or Asset_Role.ActionName.Idle
end

local MoveActionTypeMap = {
  [HandInActionType.HandIn] = Asset_Role.ActionName.MoveHandIn,
  [HandInActionType.InHand] = Asset_Role.ActionName.MoveInHand,
  [HandInActionType.Hold] = Asset_Role.ActionName.MoveHold,
  [HandInActionType.BeHolded] = Asset_Role.ActionName.MoveBeHolded
}

function NCreature:GetMoveAction()
  local replaceAction = self.replaceWalkAction
  local assetRole = self.assetRole
  if replaceAction and not assetRole:HasActionRaw(replaceAction) then
    replaceAction = self.rollbackWalkAction
  end
  if replaceAction then
    return replaceAction
  end
  local handMoveAction = self:GetHandActionFrom(MoveActionTypeMap)
  if handMoveAction then
    return handMoveAction
  end
  return self.data and self.data.moveAction or Asset_Role.ActionName.Move
end

function NCreature:GetPosition()
  return self.logicTransform.currentPosition
end

function NCreature:GetAngleY()
  return self.logicTransform.currentAngleY
end

function NCreature:GetScale()
  return self.data.bodyScale
end

function NCreature:GetOriginalScale()
  return self.originalScale
end

function NCreature:GetDefaultScale()
  return self.data and self.data:GetDefaultScale() or 1
end

function NCreature:GetScaleVector()
  return self.logicTransform.currentScale
end

function NCreature:GetScaleWithFixHW()
  local scaleX, scaleY, scaleZ = self.data.bodyScale, self.data.bodyScale, self.data.bodyScale
  local fixHScale = 1 + self.data.props:GetPropByName("SlimHeight"):GetValue() / 50
  if fixHScale < fixHeightScale[1] then
    fixHScale = fixHeightScale[1]
  elseif fixHScale > fixHeightScale[2] then
    fixHScale = fixHeightScale[2]
  end
  scaleY = fixHScale * scaleY
  local fixWScale = 1 + self.data.props:GetPropByName("SlimWeight"):GetValue() / 50
  if fixWScale < fixWeightScale[1] then
    fixWScale = fixWeightScale[1]
  elseif fixWScale > fixWeightScale[2] then
    fixWScale = fixWeightScale[2]
  end
  scaleX = fixWScale * scaleX
  scaleZ = fixWScale * scaleZ
  return scaleX, scaleY, scaleZ
end

function NCreature:GetSceneUI()
  return nil
end

function NCreature:SetVisible(v, reason)
  if self.visibleHandler == nil then
    self.visibleHandler = CreatureVisibleHandler.CreateAsTable()
  end
  self.visibleHandler:Visible(self, v, reason)
  self:SetPartnerVisible(v, reason)
  self:SetHandNpcVisible(v, reason)
  self:SetExpressNpcVisible(v, reason)
end

function NCreature:SetPartnerVisible(v, reason)
  if self.partner then
    self.partner:SetVisible(v, reason)
  end
end

function NCreature:SetHandNpcVisible(v, reason)
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:SetVisible(v, reason)
    end
  end
end

function NCreature:SetExpressNpcVisible(v, reason)
  if self.expressNpcMap then
    for key, value in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(key)
      if npc then
        npc:SetVisible(v, reason)
      end
    end
  end
end

function NCreature:SetOnCarrier(val)
  self.onCarrier = val
  if val then
    if self.partner ~= nil and not self.partner.data:CanGetOnCarrier() then
      local partnerID = self.partnerID
      self:RemovePartner()
      self.partnerID = partnerID
    end
  elseif self.partner == nil and self.partnerID ~= nil and self.partnerID ~= 0 then
    self:SetPartner(self.partnerID)
  end
end

function NCreature:SetPartner(id)
  self.partnerID = id
  if id == 0 then
    self:RemovePartner()
  else
    self:AddPartner(id)
  end
end

function NCreature:AddPartner(id)
  local partner = self.partner
  if partner ~= nil then
    partner:ResetID(id)
  else
    partner = NPartner.CreateAsTable(id)
    self.partner = partner
  end
  partner:SetMaster(self)
end

function NCreature:RemovePartner()
  if self.partner then
    self.partner:Destroy()
    self.partner = nil
  end
  self.partnerID = 0
end

function NCreature:GetPartnerID()
  return self.partnerID
end

function NCreature:SetPartnerState(state)
  local partner = self.partner
  if partner == nil then
    return
  end
  partner:SetState(state)
end

function NCreature:AddHandNpc(guid)
  self.handNpc = guid
end

function NCreature:RemoveHandNpc()
  self.handNpc = nil
end

function NCreature:GetHandNpc()
  if self.handNpc == nil then
    return
  end
  local npc = SceneAINpcProxy.Instance:Find(self.handNpc)
  if npc == nil then
    self:RemoveHandNpc()
  end
  return npc
end

function NCreature:AddExpressNpc(guid)
  if self.expressNpcMap == nil then
    self.expressNpcMap = {}
  end
  if self.expressNpcMap[guid] == nil then
    self.expressNpcMap[guid] = guid
  end
end

function NCreature:ClearExpressNpc()
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      SceneAINpcProxy.Instance:Remove(k)
    end
    TableUtility.TableClear(self.expressNpcMap)
  end
end

function NCreature:IsExpressNpc(guid)
  if self.expressNpcMap then
    return self.expressNpcMap[guid]
  else
    return nil
  end
end

function NCreature:GetExpressNpc(guid)
  local npc = SceneAINpcProxy.Instance:Find(guid)
  if npc == nil then
    self.expressNpcMap[guid] = nil
  end
  return npc
end

function NCreature:SetStealth(v)
  if self.assetRole then
    if v then
      self.assetRole:AlphaTo(0.5, 1)
    else
      self.assetRole:AlphaTo(1, 1)
    end
  end
end

function NCreature:SetHiding(v)
  if self.assetRole then
    self:SetVisible(false, LayerChangeReason.OnStageWaitting)
  end
end

function NCreature:SetClientStealth(add, stealthColor)
  if self.assetRole then
    if add then
      if stealthColor then
        local success, color = ColorUtil.TryParseHexString(stealthColor)
        if success then
          self.assetRole:ChangeColorTo(color, 1)
        end
      end
      self.assetRole:AlphaTo(0.5, 1)
    else
      self.assetRole:ChangeColorTo(LuaGeometry.Const_Col_whiteClear, 1)
      self.assetRole:AlphaTo(1, 1)
    end
  end
end

function NCreature:AddStageNpc(guid)
  self.stageNpc = guid
end

function NCreature:RemoveStageNpc()
  self.stageNpc = nil
end

function NCreature:GetStageNpc()
  local npc = SceneAINpcProxy.Instance:Find(self.stageNpc)
  if npc == nil then
    self:RemoveStageNpc()
  end
  return npc
end

function NCreature:SetParent(parentTransform, noResetLocal)
  self.ai:SetParent(parentTransform, self, noResetLocal)
end

function NCreature:Show()
  FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):ShowPlayer(self)
end

function NCreature:Hide()
  FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):HidePlayer(self)
end

function NCreature:OnStageHide()
  self:SetVisible(false, LayerChangeReason.OnStageWaitting)
  FunctionPlayerUI.Me():MaskAllUI(self, LayerChangeReason.OnStageWaitting)
end

function NCreature:OnStageShow()
  self:SetVisible(true, LayerChangeReason.OnStageWaitting)
  FunctionPlayerUI.Me():UnMaskAllUI(self, LayerChangeReason.OnStageWaitting)
end

function NCreature:SetClickable(v)
  if self.data then
    self.data.noAccessable = v and 0 or 1
  end
  if self.assetRole then
    local creatureType = self:GetCreatureType()
    if creatureType == Creature_Type.Npc or creatureType == Creature_Type.Player then
      local noAccessable = self.data:NoAccessable()
      self.assetRole:SetColliderEnable(self.data.forceSelect or not noAccessable)
      if not v and Game.Myself:GetLockTarget() == self then
        Game.Myself:Client_LockTarget(nil)
      end
    end
  end
end

function NCreature:GetClickable()
  if self.data.forceSelect then
    return true
  end
  return not self.data:NoAccessable()
end

function NCreature:ShowWarnRingEffect()
  self.assetRole:SetShowWarnRingEffect()
end

function NCreature:InitAssetRole()
  self:ReDress()
end

function NCreature:GetRoleComplete()
  return self.assetRole:GetRoleComplete()
end

function NCreature:GetRoleCompleteGUID()
  return self.assetRole:GetGUID()
end

function NCreature:ResetClickPriority()
  if self.assetRole and self.data then
    self.assetRole:SetClickPriority(self.data:GetClickPriority())
  end
end

local nowInfo, nowPhaseData

function NCreature:Server_SyncSkill(phaseData)
  nowInfo, nowPhaseData = self.skill.info, self.skill.phaseData
  if nowInfo and nowInfo:CanUseOtherSkill(phaseData:GetSkillID(), self) and nowPhaseData and nowPhaseData:GetSkillPhase() == SkillPhase.Cast then
    self:Client_PlayUseSkill(phaseData)
    return
  end
  self.ai:PushCommand(FactoryAICMD.GetSkillCmd(phaseData, self), self)
  self.use_stiffaction = phaseData.use_stiffaction
  if SkillPhase.None == phaseData:GetSkillPhase() then
    self:Server_BreakSkill(phaseData:GetSkillID(), phaseData)
  end
end

function NCreature:Server_BreakSkill(skillID, phaseData)
  if self.skillFreeCast ~= nil and self.skillFreeCast:GetSkillID() == skillID then
    self.disableSkillBroadcast = true
    self.skillFreeCast:InterruptCast(self)
    self.disableSkillBroadcast = false
  end
  if self.use_stiffaction then
    self:PlayStiffAction()
    local value, speed = self.data:GetBalanceValue()
    if not value then
      return
    end
    local BalanceConfig = self.data:GetBalanceConfig()
    if BalanceConfig and value < BalanceConfig.MaxValue * 1000 / 2 then
      self:Client_PlayAction(BalanceConfig.StiffAction, nil, false)
    end
  end
end

function NCreature:PlayStiffAction()
  local BalanceConfig = self.data:GetBalanceConfig()
  if not BalanceConfig or not self.assetRole then
    return
  end
  if BalanceConfig.StiffEffect then
    for _, config in pairs(BalanceConfig.StiffEffect) do
      self:PlayStiffEffect(config[1], config[2])
    end
  end
  local ShakeScreenConfig = BalanceConfig.shakeScreen_stiff
  local range = ShakeScreenConfig.amplitude / 100
  local duration = ShakeScreenConfig.msec / 1000
  local curve = ShakeScreenConfig.shaketype
  CameraAdditiveEffectManager.Me():StartShake(range, duration, curve)
  if BalanceConfig.StiffAudioEffect then
    self.assetRole:PlaySEOneShotOn(BalanceConfig.StiffAudioEffect)
  end
end

function NCreature:PlayStiffEffect(effectpath, ep, loop)
  local effectEPID = ep or 0
  local effectPaths = Game.PreprocessEffectPaths(StringUtil.Split(effectpath, ","))
  if nil ~= effectPaths then
    local effectPath = effectPaths[1]
    if nil ~= effectPath then
      if loop then
        return self.assetRole:PlayEffectOn(effectPath, effectEPID, nil, nil, nil, nil, nil, 0, 0, Asset_Effect.EffectTypes.Hit)
      else
        self.assetRole:PlayEffectOneShotOn(effectPath, effectEPID, nil, nil, nil, nil, nil, 0, 0, Asset_Effect.EffectTypes.Hit)
      end
    end
  end
end

function NCreature:Server_GetOnSeat(seatID, fromCreature, furn_guid)
  self.ai:PushCommand(FactoryAICMD.GetGetOnSeatCmd(seatID, fromCreature, furn_guid), self)
end

function NCreature:Server_GetOffSeat(seatID, fromCreature, furn_guid)
  self.ai:PushCommand(FactoryAICMD.GetGetOffSeatCmd(seatID, fromCreature, furn_guid), self)
end

function NCreature:InitLogicTransform(serverX, serverY, serverZ, dir, scale, moveSpeed, rotateSpeed, scaleSpeed, moveTo)
  self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
  self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor(rotateSpeed))
  self.logicTransform:SetScaleSpeed(self.data:ReturnScaleSpeedWithFactor(scaleSpeed))
  if scale then
    self:Server_SetScaleCmd(scale, true)
  end
  if dir then
    self:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir / 1000)
  end
  self:InitLogicPos(serverX / 1000, serverY / 1000, serverZ / 1000, moveTo)
end

function NCreature:InitLogicPos(x, y, z, moveTo)
  self:Logic_NavMeshPlaceXYZTo(x, y, z)
end

function NCreature:GetDressParts()
  if not self:IsDressEnable() then
    return Asset_Role.CreatePartArray()
  end
  return self.data:GetDressParts()
end

function NCreature:DestroyDressParts(parts, partsNoDestroy)
  if partsNoDestroy then
    return
  end
  Asset_Role.DestroyPartArray(parts)
end

function NCreature:AllowDress()
  return not self:IsDressEnable() or not not self.dressed
end

function NCreature:ReDress()
  if self.dressLocked then
    redlog("ReDress dressLocked", self.data.id)
    return
  end
  local isMySelf = self:IsMySelf()
  if nil ~= self.assetRole then
    if not self:AllowDress() then
      return
    end
    self:_ReDress()
  else
    local parts
    local partsNoDestroy = false
    local dressEnable = false
    if self:AllowDress() then
      parts, partsNoDestroy = self:GetDressParts()
      dressEnable = true
    else
      parts = Asset_Role.CreatePartArray()
      dressEnable = false
    end
    parts[Asset_Role.PartIndexEx.SmoothDisplay] = 0.3
    parts[Asset_Role.PartIndexEx.Layer] = nil
    parts[Asset_Role.PartIndexEx.MySelf] = isMySelf
    self:SetDressed(dressEnable)
    self.assetRole = Asset_Role.Create(parts, self.assetManager, nil, nil, self.data:GetMountForm())
    self:ObservePartCreated()
    self:DestroyDressParts(parts, partsNoDestroy)
  end
  self:UpdateMountNpc()
  self:ResetUpPos()
end

function NCreature:_ReDress(isLoadFirst)
  local parts, partsNoDestroy = self:GetDressParts()
  if parts then
    self:SetDressed(self:IsDressEnable())
    self.assetRole:Redress(parts, isLoadFirst)
    self:CheckBodyPlayShow(parts[Asset_Role.PartIndex.Body])
    self:DestroyDressParts(parts, partsNoDestroy)
  end
end

function NCreature:CheckBodyPlayShow(bodyID)
  if bodyID ~= nil and 0 < bodyID then
    local bodyData = Table_Body[bodyID]
    if bodyData ~= nil then
      local feature = bodyData.Feature
      if feature ~= nil and 0 < feature & FeatureDefines_Body.PlayShow and TableUtility.ArrayFindIndex(GameConfig.Setting.PlayshowForbiddenMapRaidType, Game.DungeonManager:GetRaidType()) == 0 then
        self.ai:AddPlayShow()
        return
      end
    end
  end
  self.ai:RemovePlayShow()
end

function NCreature:ReDressImmediate()
  if self.dressed or not self:IsDressEnable() then
    return
  end
  local parts, partsNoDestroy = self:GetDressParts()
  if parts then
    self:SetDressed(self.assetRole:RedressWithCache(parts))
    self:DestroyDressParts(parts, partsNoDestroy)
  end
  if not self.dressed then
    self:_ReDress()
  end
end

local tmpVector3 = LuaVector3.Zero()

function NCreature:Server_SetPosXYZCmd(x, y, z, div, ignoreNavMesh)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Server_SetPosCmd(tmpVector3, ignoreNavMesh)
  self.serverPos_x = x / 1000
  self.serverPos_y = y / 1000
  self.serverPos_z = z / 1000
end

function NCreature:GetServerPos()
  return self.serverPos_x or 0, self.serverPos_y or 0, self.serverPos_z or 0
end

local tempPos = LuaVector3()

function NCreature:Server_SetPosCmd(p, ignoreNavMesh)
  if p then
    tempPos:Set(p.x, p.y, p.z)
    if VectorUtility.AlmostEqual_3_XZ(self:GetPosition(), tempPos) then
      return true
    end
  end
  self.ai:PushCommand(FactoryAICMD.GetPlaceToCmd(p, ignoreNavMesh), self)
end

function NCreature:Server_SetDirCmd(mode, dir, noSmooth)
  self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode, dir, noSmooth), self)
end

function NCreature:Server_MoveToXYZCmd(x, y, z, div, ignoreNavMesh, endCallback, customMoveActionName)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Server_MoveToCmd(tmpVector3, ignoreNavMesh, endCallback, customMoveActionName)
end

function NCreature:Server_MoveToCmd(p, ignoreNavMesh, endCallback, customMoveActionName)
  self.ai:PushCommand(FactoryAICMD.GetMoveToCmd(p, ignoreNavMesh, endCallback, customMoveActionName), self)
end

function NCreature:Server_SetScaleCmd(scale, noSmooth)
  self.originalScale = scale
  self.data.bodyScale = scale
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end

function NCreature:Server_SetFixHeightCmd(height, noSmooth)
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end

function NCreature:Server_SetFixWeightCmd(weight, noSmooth)
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end

function NCreature:Server_PlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon), self)
end

function NCreature:Server_DieCmd(noaction)
  self.ai:PushCommand(FactoryAICMD.GetDieCmd(noaction), self)
end

function NCreature:Server_ReviveCmd()
  self.ai:PushCommand(FactoryAICMD.GetReviveCmd(), self)
end

function NCreature:Server_SetMoveSpeed(moveSpeed)
  self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
  if self:Client_IsMoving() then
    self:Logic_PlayAction_Move(self:Client_GetMoveToCustomActionName(), true)
  end
end

function NCreature:Server_SetScaleSpeed(scaleSpeed)
  self.logicTransform:SetScaleSpeed(self.data:ReturnScaleSpeedWithFactor(scaleSpeed))
end

function NCreature:Server_SetAtkSpeed(atkSpeed)
  self.data:SetAttackSpeed(atkSpeed)
end

function NCreature:Server_CameraFlash()
  self.ai:CameraFlash(0, 0, self)
end

function NCreature:Server_SetHandInHand(masterID, running, forceBehold)
  self.handInMasterID = masterID
  local func = self.ai.HandInHand
  if forceBehold or self.data and self.data:GetFeature_BeHold() then
    func = self.ai.BeHolded
  end
  if running then
    func(self.ai, masterID, self)
  else
    func(self.ai, 0, self)
  end
end

function NCreature:ResetHandInHand()
  if self.handInMasterID and self.handInMasterID ~= 0 then
    self:Server_SetHandInHand(0, false)
  end
end

function NCreature:Server_SetTwinsActionId(newValue, oldValue)
  self.new_TwinsActionId = newValue
  self.old_TwinsActionId = oldValue
end

function NCreature:Server_SetDoubleAction(masterID, running)
  self.doubleaction_build = running
  if running then
    self.ai:DoDoubleAction(masterID, self)
  else
    self.ai:DoDoubleAction(0, self)
  end
end

local DoubleActionPair = GameConfig.TwinsAction.pair

function NCreature:GetDoubleActionId(handInActionID)
  if handInActionID == nil or handInActionID == 0 then
    return 0
  end
  if self.isDoubleActionMaster == false then
    local passive = DoubleActionPair and DoubleActionPair[handInActionID]
    if passive then
      return passive
    end
  end
  return handInActionID
end

function NCreature:Server_SetAlpha(alpha)
  if self.assetRole then
    self.assetRole:AlphaTo(alpha, 0)
  end
end

function NCreature:Server_SetSolo(value)
  if 0 < value then
    if self.skillSolo == nil then
      self.skillSolo = SkillSolo.Create()
    end
    self.skillSolo:StartSolo(self, value)
    NSceneUserProxy.Instance:AddLoopSfxUser(self.data.id)
  elseif self.skillSolo ~= nil then
    self.skillSolo:EndSolo(self)
    self:ClearSkillSolo()
    NSceneUserProxy.Instance:RemoveLoopSfxUser(self.data.id)
  end
end

function NCreature:ClearSkillSolo()
  if self.skillSolo ~= nil then
    self.skillSolo:Destroy()
    self.skillSolo = nil
  end
end

function NCreature:UpdateVolume(volume)
  if self.skillSolo then
    self.skillSolo:UpdateVolume(volume)
  end
  if self.assetRole then
    self.assetRole:UpdateVolume(volume)
  end
end

function NCreature:SetAuto_SkillOverAction()
  if self.skillOverAction then
    self.ai:SetAuto_SkillOverAction(skillComboEndAct)
  end
end

function NCreature:Server_SetSkillMove(x, y, z)
  return false
end

function NCreature:Update(time, deltaTime)
  local canLogic = not self:CanForbidLogic()
  if canLogic then
    logicTransformUpdate(self.logicTransform, time, deltaTime)
  end
  self.ai:Update(time, deltaTime, self)
  if self.assetRole then
    self.assetRole:Update(time, deltaTime)
  end
  if self.partner then
    self.partner:Update(time, deltaTime)
  end
  if canLogic then
    if self.handNpc then
      local npc = self:GetHandNpc()
      if npc then
        npc:Update(time, deltaTime)
      end
    end
    if self.expressNpcMap then
      for k, v in pairs(self.expressNpcMap) do
        local npc = self:GetExpressNpc(k)
        if npc then
          npc:Update(time, deltaTime)
        end
      end
    end
    selfUpdateArroundMyself(self, time, deltaTime)
    selfUpdateSpEffect(self, time, deltaTime)
    if self.skillFreeCast ~= nil then
      self.skillFreeCast:Update(time, deltaTime, self)
      if not self.skillFreeCast.running then
        self:Logic_RemoveSkillFreeCast()
      end
    end
  end
  self:_UpdateProjectileEffect(time, deltaTime)
  if self.buffHugRole then
    self.buffHugRole:Update(time, deltaTime)
  end
end

function NCreature:PushDeltaTime(deltaTime)
  self.updateDeltaTime = self.updateDeltaTime + deltaTime
end

function NCreature:PopDeltaTime()
  local deltaTime = self.updateDeltaTime
  self.updateDeltaTime = 0
  return deltaTime
end

function NCreature:ForceUpdateTransform(time, deltaTime)
  if not self:CanForbidLogic() then
    logicTransformUpdate(self.logicTransform, time, deltaTime)
  end
  AI_Base._DoUpdate(self.ai, time, deltaTime, self)
end

function NCreature:GetDressDisableDistanceLevel()
  return 999
end

function NCreature:_UpdateArroundMyself(time, deltaTime)
  if not self.dressed then
    local distanceLevelChanged = false
    if self.arroundMyselfLevel ~= self.culling_distanceLevel then
      self.arroundMyselfLevel = self.culling_distanceLevel
      distanceLevelChanged = true
    end
    if not self:IsDressEnable() then
      return
    end
    local dressDisableDistanceLevel = self:GetDressDisableDistanceLevel()
    if self:IsCullingVisible() and dressDisableDistanceLevel <= self.culling_distanceLevel then
      return
    end
    local myself = Game.Myself
    local lockTarget = myself:GetLockTarget()
    if self == lockTarget then
      self:_ReDress()
      return
    end
    if distanceLevelChanged and self.culling_distanceLevel <= 0 then
      local parts, partsNoDestroy = self:GetDressParts()
      if parts then
        self:SetDressed(self.assetRole:RedressWithCache(parts))
        self:DestroyDressParts(parts, partsNoDestroy)
      end
      if self.dressed then
        return
      end
    end
    self:_ReDress()
  end
end

selfUpdateArroundMyself = NCreature._UpdateArroundMyself
autoImport("EffectWorker_Connect")
autoImport("EffectWorker_OnFloor")
autoImport("EffectWorker_WalkDust")
SpEffectWorkerClass = {
  [1] = EffectWorker_Connect,
  [2] = EffectWorker_OnFloor,
  [3] = EffectWorker_WalkDust
}

function NCreature:AllowSpEffect_OnFloor()
  return false
end

function NCreature:Server_AddSpEffect(spEffectData)
  local effectID = spEffectData.id
  if nil == Table_SpEffect[effectID] then
    return
  end
  local effectType = Table_SpEffect[effectID].Type
  local EffectClass = SpEffectWorkerClass[effectType]
  if nil == EffectClass then
    return
  end
  if nil == self.spEffects then
    self.spEffects = {}
  end
  local key = spEffectData.guid
  local effect = self.spEffects[key]
  if nil ~= effect then
    for k, v in ipairs(effect) do
      v:Destroy()
      effect[k] = nil
    end
    self.spEffects[key] = nil
  else
    effect = {}
  end
  if spEffectData.entity then
    for _, v in pairs(spEffectData.entity) do
      local tmp = EffectClass.Create(effectID)
      local args = ReusableTable.CreateArray()
      args[1] = v
      args[2] = nil
      tmp:SetArgs(args, self)
      ReusableTable.DestroyArray(args)
      effect[#effect + 1] = tmp
    end
  else
    local tmp = EffectClass.Create(effectID)
    local args = ReusableTable.CreateArray()
    tmp:SetArgs(args, self)
    ReusableTable.DestroyArray(args)
    effect[#effect + 1] = tmp
  end
  if 0 < #effect then
    self.spEffects[key] = effect
  end
end

function NCreature:Server_RemoveSpEffect(spEffectData)
  if nil == self.spEffects then
    return
  end
  local key = spEffectData.guid
  local effect = self.spEffects[key]
  if nil ~= effect then
    for _, v in ipairs(effect) do
      v:Destroy()
    end
    self.spEffects[key] = nil
  end
end

function NCreature:ClearSpEffect()
  if nil ~= self.spEffects then
    for k, v in pairs(self.spEffects) do
      for k2, v2 in pairs(v) do
        v2:Destroy()
        v[k2] = nil
      end
      self.spEffects[k] = nil
    end
  end
end

function NCreature:_UpdateSpEffect(time, deltaTime)
  if nil ~= self.spEffects then
    for k, v in pairs(self.spEffects) do
      for k2, v2 in pairs(v) do
        if v2:Update(time, deltaTime, self) == false then
          v2:Destroy()
          v[k2] = nil
        end
      end
    end
  end
end

selfUpdateSpEffect = NCreature._UpdateSpEffect

function NCreature:IsInMyTeam()
  if self.data and self.data:IsPippi() then
    return self.data.ownerID == Game.Myself.data.id
  end
  return nil ~= self.data and TeamProxy.Instance:IsInMyTeam(self.data.id)
end

function NCreature:IsInMyGroup()
  if self.data and self.data:IsPippi() then
    return self.data.ownerID == Game.Myself.data.id
  end
  return nil ~= self.data and TeamProxy.Instance:IsInMyGroup(self.data.id)
end

function NCreature:IsHatred()
  return self.beHatred
end

function NCreature:BeHatred(on, time)
  local oldBeHatred = self.beHatred
  self.beHatred = on
  if self.beHatred then
    Game.LogicManager_Hatred:Refresh(self, time)
  elseif oldBeHatred then
    Game.LogicManager_Hatred:Remove(self)
  end
end

function NCreature:HatredTimeout()
  self.beHatred = false
end

function NCreature:IsCullingRegisted()
  return self.isCullingRegisted
end

function NCreature:RegistCulling()
  Game.LogicManager_MapCell:RegisterCreature(self)
  self.isCullingRegisted = true
end

function NCreature:UnRegistCulling()
  Game.LogicManager_MapCell:UnRegisterCreature(self)
  self.isCullingRegisted = false
end

function NCreature:IsCullingVisible()
  return self.culling_visible or NCreature.IsForceVisible()
end

function NCreature:GetCullingDistanceLevel()
  return self.culling_distanceLevel
end

function NCreature:UpdateMaskUI()
  local maskReason = 0
  if self.forceMaskUI then
    maskReason = 1
  elseif self.culling_visible == false then
    maskReason = 2
  elseif self.maskUIBecauseCellCreatureCount then
    maskReason = 3
  elseif self.cellPriority > Game.MapManager:GetCreatureMaskRange() then
    maskReason = 4
  end
  local needMask = 0 < maskReason
  if self.isMaskUI == needMask then
    return
  end
  self.isMaskUI = needMask
  if needMask then
    local reason = PUIVisibleReason.OutOfMyRange
    FunctionPlayerUI.Me():MaskHurtNum(self, reason, false)
    FunctionPlayerUI.Me():MaskChatSkill(self, reason, false)
    FunctionPlayerUI.Me():MaskEmoji(self, reason, false)
    FunctionPlayerUI.Me():MaskHPSP(self, reason, false)
    FunctionPlayerUI.Me():MaskNameFaction(self, reason, false)
    FunctionPlayerUI.Me():MaskTopFrame(self, reason, false)
  else
    local reason = PUIVisibleReason.OutOfMyRange
    FunctionPlayerUI.Me():UnMaskHurtNum(self, reason, false)
    FunctionPlayerUI.Me():UnMaskChatSkill(self, reason, false)
    FunctionPlayerUI.Me():UnMaskEmoji(self, reason, false)
    FunctionPlayerUI.Me():UnMaskHPSP(self, reason, false)
    FunctionPlayerUI.Me():UnMaskNameFaction(self, reason, false)
    FunctionPlayerUI.Me():UnMaskTopFrame(self, reason, false)
  end
end

function NCreature:CullingStateChange(visible, distanceLevel)
  if visible then
    self.culling_visible = visible ~= 0
  end
  if distanceLevel then
    self.culling_distanceLevel = distanceLevel
  end
  self:UpdateMaskUI()
end

function NCreature:GetCellPriority()
  return self.cellPriority or LogicManager_MapCell.LODPriority.Mid
end

function NCreature:OnPriorityChange(priority)
  self.cellPriority = priority
  self:UpdateMaskUI()
end

function NCreature:SetCellCreatureIndex(cellCreatureIndex)
  self.maskUIBecauseCellCreatureCount = cellCreatureIndex > LogicManager_MapCell.RoleUGUIVisibleCount
  self:UpdateMaskUI()
end

local SqrDistanceXZ = VectorUtility.DistanceXZ_Square

function NCreature:CheckMaskUI(time, deltaTime)
  if time > self.checkUINextTime then
    self.checkUINextTime = time + checkUIInterval
    if self.maskDistance then
      self.forceMaskUI = SqrDistanceXZ(Game.Myself:GetPosition(), self:GetPosition()) > self.maskDistance
    end
    self:UpdateMaskUI()
  end
end

function NCreature:IsInBooth()
  return false
end

function NCreature:CanForbidLogic()
  if not self:IsInBooth() then
    return false
  end
  return not self:IsDressEnable() or self.dressed
end

function NCreature:SetPeakEffectVisible(v, reason)
  return false
end

function NCreature:HasPetPartner()
  return self.partner ~= nil
end

function NCreature:GetPetPartner()
  return self.partner
end

function NCreature:GetBossType()
  return nil
end

function NCreature:SetMapCellIndex(index)
  self.mapCellIndex = index
end

function NCreature:GetMapCellIndex()
  return self.mapCellIndex
end

function NCreature:GetPlayShowAction()
  if self.data == nil or self.data.staticData == nil then
    return Asset_Role.ActionName.PlayShow
  end
  local playShowActions = self.data.staticData.PlayShowActions
  if playShowActions == nil or #playShowActions == 0 then
    return Asset_Role.ActionName.PlayShow
  end
  local count = #playShowActions, actionId
  if count == 1 then
    actionId = playShowActions[1]
  else
    actionId = playShowActions[math.random(count)]
  end
  return Table_ActionAnime[actionId].Name
end

function NCreature:IsMySelf()
  return false
end

function NCreature:UpdateMountNpc()
  if self.mountUpdated then
    return
  end
  self.mountUpdated = true
  local data = self.data
  if data == nil then
    return
  end
  if data.staticData == nil then
    return
  end
  if not data.staticData.IsMountNpc then
    return
  end
  if self.assetRole then
    self.assetRole:SetForceShowMount(true)
  end
end

function NCreature:GetHandActionFrom(actionTypeMap)
  return actionTypeMap[self.handInHandAction]
end

function NCreature:SetUpdateFrequency(frequency)
  if not frequency then
    LogUtility.Error("frequency is nil")
    return
  end
  self.updateFrequency = frequency
end

function NCreature:IsPlayShowForbidden()
  if self.assetRole then
    return self.assetRole:IsPlayShowForbidden()
  end
  return false
end

function NCreature:SetDefaultWalkAnime(animeName)
  self.data.moveAction = animeName
end

function NCreature:ObservePartCreated()
  self:CreateWeakData()
  local event = Asset_Role.NotifyEvent.PartCreated
  local weakData = self:GetWeakData(event)
  if weakData == nil then
    self:SetWeakData(event, self.assetRole)
  end
end

function NCreature:OnPartCreated(part)
  if part == 1 then
    self:OnBodyCreated()
  end
  if self:HasAllPartLoaded() then
    EventDispatcherRobust.Me():PassEvent(CreatureEvent.OnAllPartLoaded, self)
  end
  if self:HasAllPartLoadedStrictCheck() and self.OnAllPartLoaded_TryHandleAddSpecialBuff then
    self:OnAllPartLoaded_TryHandleAddSpecialBuff()
  end
end

function NCreature:OnBodyCreated()
end

function NCreature:HasAllPartLoaded()
  return not (not self.assetRole or self.assetRole:_IsLoading()) and true or false
end

function NCreature:HasAllPartLoadedStrictCheck()
  if self:HasAllPartLoaded() and next(self.assetRole.partObjs) then
    for k, v in pairs(self.assetRole.partIDs) do
      if v ~= 0 and self.assetRole.partObjs[k] == nil then
        return false
      end
    end
    return true
  end
  return false
end

function NCreature:SetChantSkill(data)
  if data and data.chanttime and data.chanttime > 0 then
    self.chantInfo = {}
    local chantInfo = self.chantInfo
    chantInfo.skillid = data.skillid
    chantInfo.chanttime = S2C_Number(data.chanttime)
    chantInfo.starttime = S2C_Number(data.starttime)
    self:Server_SyncSpCastInfo()
    self:Server_SyncSpCastSkill(chantInfo.skillid, chantInfo.chanttime, data.data)
  end
end

function NCreature:ClearChantSkill(skillid)
  if self.chantInfo and skillID == self.chantInfo.skilid then
    self.chantInfo = nil
  end
end

function NCreature:GetChantSkill()
  return self.chantInfo
end

function NCreature:GetChantSkillTime()
  if self.chantInfo then
    return self.chantInfo.chanttime or 0
  end
  return 0
end

function NCreature:Server_SyncSpCastInfo()
  EventManager.Me():DispatchEvent(SkillEvent.SyncCastBegin, self)
end

function NCreature:Server_TryStopSyncChant(skillid)
  self.stopChantID = skillid
  EventManager.Me():DispatchEvent(SkillEvent.StopSyncCast, self)
end

function NCreature:Server_SyncSpCastSkill(skillid, chanttime, serverphasedata)
  local phaseData = SkillPhaseData.Create(skillid)
  phaseData:ParseFromServer(serverphasedata, true)
  phaseData:SetSkillPhase(SkillPhase.Cast)
  phaseData:SetCastTime(chanttime)
  self.ai:PushCommand(FactoryAICMD.GetSkillCmd(phaseData), self)
  phaseData:Destroy()
  phaseData = nil
end

function NCreature:SetAllowConcurrent(value, skillids, buffID)
  self.allowConcurrent = value
  if not self.allowConcurrentMap then
    self.allowConcurrentMap = {}
  end
  self.allowConcurrentMap[buffID] = value
  if not self.buffConcurrentMap then
    self.buffConcurrentMap = {}
  end
  if self.buffConcurrentMap[buffID] then
    TableUtility.TableClear(self.buffConcurrentMap[buffID])
  elseif skillids then
    self.buffConcurrentMap[buffID] = {}
  end
  if skillids then
    for i = 1, #skillids do
      self.buffConcurrentMap[buffID][skillids[i]] = true
    end
  end
  if self.skill and self.skill.running then
    if type(value) == "number" then
      self.skill:SetConcurrent(self, value ~= 0)
    else
      self.skill:SetConcurrent(self, value)
    end
  end
end

function NCreature:GetAllowConcurrent(skillid)
  if not self.buffConcurrentMap then
    return self.allowConcurrent
  else
    for buffID, concurrentMap in pairs(self.buffConcurrentMap) do
      if self.allowConcurrentMap[buffID] and concurrentMap[skillid // 1000] == true then
        return true
      end
    end
  end
  return false
end

function NCreature:IsConcurrentRotateOnly()
  return self.allowConcurrent == ConcurrentType.RotateOnly
end

function NCreature:CheckIsVeer()
  return self.data.userdata:Get(UDEnum.ISVEER) or 0
end

function NCreature:GetShowName()
  return self.data.userdata:Get(UDEnum.SHOWNAME) or 0
end

function NCreature:SetNoSkillDelay(value)
  self.noSkillDelay = value
end

function NCreature:IsNoSkillDelay()
  return self.noSkillDelay
end

function NCreature:SetDisapper(v)
  if self.assetRole then
    if v then
      self:SetVisible(false, LayerChangeReason.OnStageWaitting)
    else
      self:SetVisible(true, LayerChangeReason.OnStageWaitting)
    end
  end
end

function NCreature:HideMyself(val)
  if self.assetRole then
    if 1 == val then
      self:SetVisible(false, LayerChangeReason.HideBodyOnly)
    else
      self:SetVisible(true, LayerChangeReason.HideBodyOnly)
    end
  end
end

function NCreature:SetDragonContractEffect(fromID)
  if not fromID then
    redlog("SetDragonContractEffect fromID nil")
    return
  end
  local lookatPlayer = NSceneUserProxy.Instance:Find(fromID)
  if not lookatPlayer then
    redlog("lookatPlayer nil", fromID)
    return
  end
  local currentPosition = self.logicTransform.currentPosition
  local endPosition = lookatPlayer.logicTransform.currentPosition
  local angleY = VectorHelper.GetAngleByAxisY(currentPosition, endPosition)
  self:PlayContractEffect(fromID, EffectMap.Maps.DragonContract, RoleDefines_EP.Bottom, nil, true, angleY)
end

function NCreature:OpenStormBossLucky()
  return false
end

function NCreature:UpdateTopUIBySetting()
end

function NCreature:SetMaterialInfo(materialParams)
  if materialParams == nil then
    return
  end
  local assetRole = self.assetRole
  if assetRole == nil then
    return
  end
  assetRole:SetMaterialInfo("_SPMatcap", ResourcePathHelper.ModelMainTexture(materialParams.textName), "_SPMatcapMap", materialParams)
end

function NCreature:ResetMaterials()
  local assetRole = self.assetRole
  if assetRole == nil then
    return
  end
  assetRole:ResetMaterials()
end

function NCreature:IsMonster()
end

function NCreature:IsOrOwnedByMonster()
end

function NCreature:SetNoBreakSkills(skillids)
  if self.noBreakSkillsMap then
    TableUtility.TableClear(self.noBreakSkillsMap)
  else
    self.noBreakSkillsMap = {}
  end
  if skillids then
    for i = 1, #skillids do
      self.noBreakSkillsMap[skillids[i]] = true
    end
  end
end

function NCreature:GetNoBreakSkills(skillid)
  return self.noBreakSkillsMap and self.noBreakSkillsMap[skillid // 1000] == true
end

function NCreature:GetForward()
  if self.assetRole then
    return LuaGameObject.GetTransformForward(self.assetRole.completeTransform)
  end
end

function NCreature:HasReasonInvisible()
  if not self.visibleHandler then
    return false
  end
  return self.visibleHandler:HasReason()
end

local isolateColor = "FF5DB1"

function NCreature:SetClientIsolate(add)
  self:SetClientStealth(add, isolateColor)
end

function NCreature:SetHideHp(val)
  if self ~= Game.Myself then
    local sceneUi = self:GetSceneUI()
    if sceneUi then
      sceneUi.roleBottomUI:SetHideHp(val, self)
    end
  end
  self.isHideHp = val
end

function NCreature:IsHideHp()
  return self.isHideHp == true
end

function NCreature:SetStageEffect(bufflayer)
  bufflayer = bufflayer or 1
  self:PlayContractEffect(fromID, EffectMap.Maps.DragonContract, RoleDefines_EP.Bottom, nil, true, angleY)
end

function NCreature:DoConstruct(asArray, data)
  self.culling_visible = true
  self.culling_distanceLevel = 0
  self.dressed = false
  self.arroundMyselfLevel = -1
  self.data = data
  self.maskDistance = self.data.staticData and self.data.staticData.Distance or 30
  self.maskDistance = self.maskDistance * self.maskDistance
  self.handInHandAction = HandInActionType.Clear
  self.originalScale = 1
  self.noSkillDelay = false
  self.ai:Construct(self)
  self.logicTransform:Construct()
  self.updateDeltaTime = 0
  self.updateFrequency = CreatureUpdateFrequency.Every1Frame
  self.mapCellIndex = -1
  self.isMaskUI = nil
  self.cellPriority = 0
  self.maskUIBecauseCellCreatureCount = false
  self.checkUINextTime = 0
  self.chantInfo = nil
  self.stopChantID = 0
  self.allowConcurrent = false
  self.isHideHp = false
  self.hideBodyOnly = false
end

function NCreature:GetUpIDReset()
  local upID = self.data:GetUpID()
  if not upID or upID == 0 then
    return
  end
  local upRole = SceneCreatureProxy.FindCreature(upID)
  if upRole and upRole.assetRole then
    upRole.assetRole:ResetMountRole()
    upRole.assetRole:TakeOutCreatureInCP(-1)
    upRole.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
  end
end

function NCreature:ResetUpPos()
  local downID = self.data:GetDownID()
  if not downID or downID == 0 then
    return
  end
  local down = SceneCreatureProxy.FindCreature(downID)
  if self.assetRole and down and down.data and down.data:IsPippi() and down.assetRole then
    self.assetRole:SetMountRole(down.assetRole.complete)
  end
end

function NCreature:DoDeconstruct(asArray)
  self.updateDeltaTime = 0
  self.updateFrequency = CreatureUpdateFrequency.Every1Frame
  self.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
  self.assetRole:TakeOutCreatureInCP(-1)
  self:GetUpIDReset()
  self.onCarrier = false
  self:BeHatred(false)
  self:ClearSpEffect()
  self:Client_GetOffSeat()
  self:Client_RemoveHugRole()
  self.ai:Deconstruct(self)
  if self.data then
    self.data:Destroy()
    self.data = nil
  end
  if self.visibleHandler ~= nil then
    self.visibleHandler:Destroy()
    self.visibleHandler = nil
  end
  self.logicTransform:Deconstruct()
  self:RemovePartner()
  self:RemoveHandNpc()
  self:ClearExpressNpc()
  self:ClearSkillSolo()
  if self.skillFreeCast then
    self.skillFreeCast:Destroy()
    self.skillFreeCast = nil
  end
  self.noSkillDelay = false
  self.mountUpdated = false
  self.isMaskUI = nil
  self.forceMaskUI = nil
  self.checkUINextTime = 0
  self:_ClearTrackEffects()
  self.chantInfo = nil
  self.stopChantID = 0
  self.allowConcurrent = false
  self:_ClearCastWarningEffects()
  self:ClearContractEffects()
  self.freezeHold = false
  self.maskMap = nil
  self.isHideHp = false
  self.hideBodyOnly = false
end

function NCreature:OnObserverDestroyed(k, obj)
  self:OnObserverEffectDestroyed(k, obj)
end

function NCreature:ObserverEvent(obj, args)
  if args.event == Asset_Role.NotifyEvent.PartCreated then
    self:OnPartCreated(args.value)
  end
end
