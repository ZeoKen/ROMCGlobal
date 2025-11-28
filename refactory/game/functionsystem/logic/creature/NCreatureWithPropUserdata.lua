NCreatureWithPropUserdata = class("NCreatureWithPropUserdata", NCreature)
autoImport("NCreatureWithPropUserdata_Client")
local _Table_Buffer
local GetTable_Buffer = function(ID)
  if not _Table_Buffer then
    _Table_Buffer = Table_Buffer
  end
  return _Table_Buffer[ID]
end

function NCreatureWithPropUserdata:ctor(aiClass)
  NCreatureWithPropUserdata.super.ctor(self, aiClass)
  self.userDataManager = nil
  self.propmanager = nil
end

function NCreatureWithPropUserdata:IsPhotoStatus()
  return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_PHOTO
end

function NCreatureWithPropUserdata:IsDead()
  local status = self.data.userdata:Get(UDEnum.STATUS)
  return status == ProtoCommon_pb.ECREATURESTATUS_DEAD or status == ProtoCommon_pb.ECREATURESTATUS_INRELIVE
end

function NCreatureWithPropUserdata:IsInRevive()
  return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_INRELIVE
end

function NCreatureWithPropUserdata:IsFakeDead()
  return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD
end

function NCreatureWithPropUserdata:Server_SetUserDatas(serverUserdatas, init, changeJob)
  local userdata = self.data.userdata
  local sdata
  local manager = self.userDataManager
  local oldValue
  if serverUserdatas then
    for i = 1, #serverUserdatas do
      sdata = serverUserdatas[i]
      if sdata ~= nil then
        manager:SetUserData(init, self, userdata, sdata.type, sdata.value, sdata.data, changeJob)
      end
    end
  end
end

function NCreatureWithPropUserdata:Server_SetAttrs(serverAttrs)
  local props = self.data.props
  local sdata
  local manager = self.propmanager
  if serverAttrs then
    for i = 1, #serverAttrs do
      sdata = serverAttrs[i]
      if sdata ~= nil then
        manager:SetProp(self, props, sdata.type, sdata.value)
      end
    end
  end
end

function NCreatureWithPropUserdata:SetVisible(v, reason)
  local assetRoleInVisible = self.assetRole:GetInvisible()
  NCreatureWithPropUserdata.super.SetVisible(self, v, reason)
  local hideBodyOnly = reason == LayerChangeReason.HideBodyOnly
  local nowAssetRoleInVisible = self.assetRole:GetInvisible()
  if nowAssetRoleInVisible ~= assetRoleInVisible then
    if self.buffs ~= nil then
      for k, buff in pairs(self.buffs) do
        if buff and buff:GetType() == Buff.Type.State then
          buff:SetEffectVisible(not nowAssetRoleInVisible)
        end
      end
    end
    if self.buffMultiEffect then
      for _, buffeffects in pairs(self.buffMultiEffect) do
        for _, buff in pairs(buffeffects) do
          if buff and buff:GetType() == Buff.Type.State then
            buff:SetEffectVisible(not nowAssetRoleInVisible)
          end
        end
      end
    end
    if self.buffGroups ~= nil then
      for k, v in pairs(self.buffGroups) do
        v:SetEffectVisible(not nowAssetRoleInVisible)
      end
    end
    if not hideBodyOnly or not nowAssetRoleInVisible then
      if self.skill ~= nil then
        self.skill:SetEffectVisible(not nowAssetRoleInVisible)
      end
      if self.skillFreeCast ~= nil then
        self.skillFreeCast:SetEffectVisible(not nowAssetRoleInVisible)
      end
    elseif hideBodyOnly then
      if self.skill ~= nil then
        self.skill:SetEffectVisible(hideBodyOnly)
      end
      if self.skillFreeCast ~= nil then
        self.skillFreeCast:SetEffectVisible(hideBodyOnly)
      end
    end
  end
end

function NCreatureWithPropUserdata:OnBodyCreated()
  NCreatureWithPropUserdata.super.OnBodyCreated(self)
  if self.buffs ~= nil then
    for k, buff in pairs(self.buffs) do
      if buff and buff:GetType() == Buff.Type.State then
        buff:OnBodyCreated(self)
      end
    end
  end
end

function NCreatureWithPropUserdata:InitBuffs(serverData, needhit)
  local buffDatas = serverData.buffs
  if buffDatas then
    local buffData
    for i = 1, #buffDatas do
      buffData = buffDatas[i]
      self:AddBuff(buffData.id, true, needhit, buffData.fromid, buffData.layer, buffData.level, buffData.active, buffData.stateid, buffData.maxlayer, buffData.layers, buffData.params)
    end
  end
end

local superUpdate = NCreatureWithPropUserdata.super.Update

function NCreatureWithPropUserdata:Update(time, deltaTime)
  superUpdate(self, time, deltaTime)
  if self.data.campChanged then
    self:HandleCampChange()
  end
end

function NCreatureWithPropUserdata:HandleCampChange()
  self.data.campChanged = false
  self:ResetClickPriority()
  if self.sceneui then
    self.sceneui.roleBottomUI:HandleCampChange(self)
  end
  local selfPippi = self.data:GetPet_Pippi()
  if selfPippi then
    if selfPippi.sceneui and selfPippi.sceneui.roleBottomUI then
      selfPippi.sceneui.roleBottomUI:HandleCampChange(selfPippi)
    end
  else
    redlog("selfpippi nil")
  end
  EventManager.Me():PassEvent(CreatureEvent.Player_CampChange, self)
end

function NCreatureWithPropUserdata:NoAttackedByTarget(targetCreature)
  if self.attackBuffCheckMap then
    for buffID, v in pairs(self.attackBuffCheckMap) do
      if targetCreature:HasBuff(buffID) then
        return false
      end
    end
    return true
  end
  return false
end

function NCreatureWithPropUserdata:AddBuff(buffID, init, needhit, fromID, layer, level, active, stateid, maxLayer, layers, params)
  if nil == buffID then
    return
  end
  local buffInfo = GetTable_Buffer(buffID)
  if nil == buffInfo then
    return
  end
  if needhit == nil then
    needhit = true
  end
  local buff
  local buffeffect = buffInfo.BuffEffect
  local layerStateID = buffeffect.LayerState_Same or nil
  local buffStateID = self:GetBuffStateID(buffInfo, stateid, layer, fromID, active)
  if layerStateID then
    if not self.buffMultiEffect then
      self.buffMultiEffect = {}
    end
    if not self.buffMultiEffect[buffID] then
      self.buffMultiEffect[buffID] = {}
    end
    local buffeffects = self.buffMultiEffect[buffID]
    if layer == 1 then
      buff = self.buffs and self.buffs[buffID] or nil
    else
      buff = self.buffMultiEffect[buffID][layer or 2]
    end
    for blayer, bs in pairs(buffeffects) do
      if layer < blayer then
        self:_RemoveBuff(buffID, blayer)
      end
    end
  else
    buff = self.buffs and self.buffs[buffID] or nil
  end
  if buff ~= nil and buffStateID ~= nil and buff.staticData ~= nil and buffStateID ~= buff.staticData.id then
    self:_RemoveBuff(buffID)
    buff = nil
  end
  if buff == nil then
    self.data:AddBuff(buffID, fromID, layer, level, active, true, layers, buffeffect, maxLayer)
    if self.buffs == nil then
      self.buffs = {}
    end
    if nil ~= buffStateID and 0 < buffStateID and self.data:IsBuffStateValid(buffInfo) then
      buff = BuffState.Create(layer or 1, level or 0, active, buffStateID, buffID, fromID)
      if init then
        buff:Refresh(self)
      else
        buff:Start(self)
      end
      if buffeffect.isStageEffect then
        if not self.stageEffects then
          self.stageEffects = {}
        end
        self.stageEffects[buffID] = true
      end
      buff:SetEffectVisible(not self.assetRole:GetInvisible())
    else
      buff = Buff.Create(layer or 1, level or 0, active, fromID)
    end
    if buff then
      buff:SetFromID(fromID)
    end
    if layerStateID and 1 < layer then
      self.buffMultiEffect[buffID][layer or 2] = buff
    else
      self.buffs[buffID] = buff
    end
    self:TryHandleAddSpecialBuff(buffInfo, fromID, params, layer, level)
    self:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer, level)
    local stateEffect = buffeffect.StateEffect or nil
    if nil ~= stateEffect then
      local buffStateCount = self.buffStateCount
      if buffStateCount == nil then
        buffStateCount = {}
        self.buffStateCount = buffStateCount
      end
      local count = buffStateCount[stateEffect]
      if count == nil then
        count = 1
      else
        count = count + 1
      end
      buffStateCount[stateEffect] = count
    end
  else
    self.data:AddBuff(buffID, fromID, layer, level, active, nil, layers, buffeffect, maxLayer)
    self:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer, level)
    if needhit and buff:GetType() == Buff.Type.State and layer >= buff:GetLayer() then
      buff:Hit(self)
    end
    buff:SetLayer(layer or 1)
    buff:SetActive(active, self)
  end
  return buff
end

function NCreatureWithPropUserdata:GetBuffStateID(staticData, stateid, layer, fromID, active)
  local dynamic = Game.SkillDynamicManager:GetDynamicBuff(fromID ~= 0 and fromID or self.data.id, staticData.id)
  if dynamic ~= nil then
    return dynamic
  end
  if stateid ~= nil and stateid ~= 0 then
    return stateid
  end
  local buffeffect = staticData.BuffEffect
  if buffeffect ~= nil then
    local layerState = buffeffect.LayerState
    if layerState ~= nil then
      local maxLayer = 0
      layer = layer or 1
      for k, v in pairs(layerState) do
        if k > maxLayer and k <= layer then
          maxLayer = k
        end
      end
      return layerState[maxLayer]
    end
    local layerStateSelf = buffeffect.LayerState_self
    if layerStateSelf ~= nil then
      local maxLayer = 0
      layer = layer or 1
      for k, v in pairs(layerStateSelf) do
        if k > maxLayer and k <= layer then
          maxLayer = k
        end
      end
      return layerStateSelf[maxLayer]
    end
    local conditonBuffState = buffeffect.condition_buffstate
    if conditonBuffState then
      if active then
        return conditonBuffState[1]
      else
        return conditonBuffState[2]
      end
    end
  end
  return staticData.BuffStateID
end

function NCreatureWithPropUserdata:TryHandleAddSpecialBuff(buffInfo, fromID, params, layer, level)
  if buffInfo then
    local buffeffect = buffInfo.BuffEffect
    if buffeffect.weak_freeze ~= nil and buffeffect.weak_freeze == 1 then
      self.data:_AddWeakFreezeSkillBuff(buffInfo, buffeffect.id)
      if self.data:WeakFreeze() then
        self:Logic_Freeze(true)
      end
    end
    local buffType = buffeffect.type
    if buffType == BuffType.RideWolf then
      self:Logic_RideAction(true, RideActionReason.RideWolf)
    elseif buffType == BuffType.NoRelive then
      self:Client_NoRelive(1)
    elseif buffType == BuffType.ClientHide then
      self:SetClientStealth(true, buffeffect.stealthColor)
    elseif buffType == BuffType.CanMoveUseSkill then
      local cType = NCreature.ConcurrentType.Normal
      if buffeffect.rotateonly then
        cType = NCreature.ConcurrentType.RotateOnly
      end
      self:SetAllowConcurrent(cType, buffeffect.skillids, buffInfo.id)
      if buffeffect.anglespeed then
        self.logicTransform:SetRotateSpeed(buffeffect.anglespeed)
      end
    elseif buffType == BuffType.CanAttackedBy then
      if not self.attackBuffCheckMap then
        self.attackBuffCheckMap = {}
      end
      for k, v in pairs(buffeffect.buffIds) do
        self.attackBuffCheckMap[v] = 1
      end
    elseif buffType == BuffType.BeTaunt then
      self:Logic_BeTaunt(true, fromID)
    elseif buffType == BuffType.HandStatus then
      self:Client_AddHugRole(buffeffect.npcId or params[1])
    elseif buffType == BuffType.Clearautolock then
      self.data:SetNoAutoLock(buffeffect.value == 1)
      EventManager.Me():DispatchEvent(SkillEvent.ClearLockTarget, self)
    elseif buffType == BuffType.UpElementAttrLv then
      self.data:AddElementAttrBuff(buffInfo)
      EventManager.Me():PassEvent(CreatureEvent.NatureChange, self)
    elseif buffType == BuffType.SetShader then
      if self.shaderConfigID ~= buffeffect.ShaderConfigID then
        self:ResetMaterials()
        self.shaderConfigID = buffeffect.ShaderConfigID
        local shaderConfig = self.shaderConfigID and GameConfig.ShaderConfig[self.shaderConfigID]
        if shaderConfig then
          self:SetMaterialInfo(shaderConfig)
          self.assetRole:SetMaterials(true)
        end
      end
    elseif buffType == BuffType.UpgradeRefineLv then
      if self == Game.Myself then
        GameFacade.Instance:sendNotification(MyselfEvent.UpdateRefineBuff, self.data)
      end
    elseif buffType == BuffType.SetShieldHp then
      self.data.shieldLen = buffeffect.sliderlen or 0.2
    elseif buffType == BuffType.ShowDefAttr then
      GameFacade.Instance:sendNotification(MyselfEvent.ShowDefAttr, self.data.id)
    elseif buffType == BuffType.NoBreakSkill then
      self:SetNoBreakSkills(buffeffect.skillIDs)
    elseif buffType == BuffType.WithoutTeammate then
      self.data.excludeTeammate = true
      if self == Game.Myself then
        local data = {}
        data.effect = EffectMap.Maps.ufx_sarah_fz_buff_01_prf
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.FullScreenEffectView,
          viewdata = data
        })
      elseif TeamProxy.Instance:IsInMyTeam(self.data.id) then
        self:SetClientIsolate(true)
      end
    elseif buffType == BuffType.ShrinkTo then
      self:AddShrinkRange(buffInfo.id, buffeffect.Launch_Range)
    elseif buffType == BuffType.NoAttackedCanPveBuff then
      self.data:SetHasNoAttackedBuff(true)
      self:SetClickable(false)
    elseif buffType == BuffType.WalkEffect then
      if self == Game.Myself then
        self.playWalkEffect = true
        self.playWalkEffect_path = buffeffect.effect_path
      end
    elseif buffType == BuffType.MultiShieldHp then
      self.data.multiShieldLevel = (layer or 1) * buffeffect.sliderlen
    elseif buffType == BuffType.DropItem then
      EventManager.Me():PassEvent(PlayerEvent.AddBuffDropItem, {
        self.data.id,
        buffInfo.id
      })
    elseif buffType == BuffType.HideHP then
      if self ~= Game.Myself then
        self:SetHideHp(true)
      end
    elseif buffType == BuffType.InWarehouse then
      self.isInWarehouse = true
      if self == Game.Myself then
        GameFacade.Instance:sendNotification(SkillEvent.EnterWarehouse)
      end
    elseif buffType == BuffType.PerfectService then
      self.skillRange = buffeffect.Layer2Range[level or 0]
      self:SetStageEffectScale()
    elseif buffType == BuffType.PerfectServiceTemporary then
      self.tempRange = buffeffect.TemporaryRange
      self:SetStageEffectScale()
    end
    if buffeffect.isStageEffect ~= nil and buffeffect.isStageEffect == 1 then
      self:SetStageEffectScale()
    end
  end
end

function NCreatureWithPropUserdata:RemoveBuff(buffID)
  if nil == buffID then
    return
  end
  local buffInfo = GetTable_Buffer(buffID)
  if not buffInfo then
    return
  end
  local buffeffect = buffInfo.BuffEffect
  local layerEffects = buffeffect.LayerState_Same or nil
  if self.buffs ~= nil then
    local buff = self.buffs[buffID]
    if buff then
      self:_RemoveBuff(buffID)
      if nil == buffInfo then
        return
      end
      self.data:RemoveBuff(buffID, buffeffect)
      self:TryHandleRemoveSpecialBuff(buffInfo)
      self:TryUpdateSpecialBuff(buffInfo, false)
      local stateEffect = buffeffect.StateEffect or nil
      if nil ~= stateEffect then
        local buffStateCount = self.buffStateCount
        if buffStateCount ~= nil then
          local count = buffStateCount[stateEffect]
          if count then
            count = count - 1
            buffStateCount[stateEffect] = count
          end
        end
      end
    end
  end
  if layerEffects then
    self:ClearBuffMultiEffect(buffID)
  end
  if buffeffect.isStageEffect then
    self.stageEffects[buffID] = nil
  end
end

function NCreatureWithPropUserdata:SetStageEffectScale(scale)
  if self.stageEffects then
    local scale = scale or ((self.tempRange or 0) + (self.skillRange or 0) + 4) / 4
    for buffID, _ in pairs(self.stageEffects) do
      if self.buffs[buffID] then
        self.buffs[buffID]:SetEffectScale(scale)
      end
    end
  end
end

function NCreatureWithPropUserdata:ClearStageEffect()
  if self.stageEffects then
    for buffID, _ in pairs(self.stageEffects) do
      self.stageEffects[buffID] = nil
    end
  end
end

function NCreatureWithPropUserdata:_RemoveBuff(buffID, layer)
  local buff
  if layer and 1 < layer then
    buff = self.buffMultiEffect[buffID][layer]
  else
    buff = self.buffs[buffID]
  end
  if buff == nil then
    return
  end
  if buff:GetType() == Buff.Type.State then
    buff:End(self)
  end
  buff:Destroy()
  if layer and 1 < layer then
    self.buffMultiEffect[buffID][layer] = nil
  else
    self.buffs[buffID] = nil
  end
end

function NCreatureWithPropUserdata:ClearBuffMultiEffect(buffID)
  local buffeffects = self.buffMultiEffect and self.buffMultiEffect[buffID]
  if not buffeffects then
    return
  end
  for layer, buff in pairs(buffeffects) do
    if buff:GetType() == Buff.Type.State then
      buff:End(self)
    end
    buff:Destroy()
    self.buffMultiEffect[buffID][layer] = nil
  end
end

function NCreatureWithPropUserdata:TryHandleRemoveSpecialBuff(buffInfo)
  if nil == buffInfo then
    return
  end
  local buffeffect = buffInfo.BuffEffect
  if buffeffect.weak_freeze ~= nil and buffeffect.weak_freeze == 1 then
    self.data:_RemoveWeakFreezeSkillBuff(buffInfo, buffeffect.id)
    if not self.data:WeakFreeze() then
      self:Logic_Freeze(0 < self.data.props:GetPropByName("Freeze"):GetValue())
    end
  end
  local buffType = buffeffect.type
  if buffType == BuffType.RideWolf then
    self:Logic_RideAction(false, RideActionReason.RideWolf)
  elseif buffType == BuffType.NoRelive then
    self:Client_NoRelive(-1)
    if not self.data:NoRelive() then
      GameFacade.Instance:sendNotification(PlayerEvent.BuffChange, self.data.id)
    end
  elseif buffType == BuffType.ClientHide then
    self:SetClientStealth(false, buffeffect.stealthColor)
  elseif buffType == BuffType.CanMoveUseSkill then
    if buffeffect.anglespeed then
      self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor())
    end
    if buffeffect.rotateonly then
      self.logicTransform:StopRotation()
      self:Client_StopNotifyServerAngleY()
    end
    self:SetAllowConcurrent(false, nil, buffInfo.id)
  elseif buffType == BuffType.BeTaunt then
    self:Logic_BeTaunt(false)
  elseif buffType == BuffType.HandStatus then
    self:Client_RemoveHugRole()
  elseif buffType == BuffType.CanAttackedBy then
    if self.attackBuffCheckMap then
      for k, v in pairs(buffeffect.buffIds) do
        self.attackBuffCheckMap[k] = nil
      end
    end
  elseif buffType == BuffType.Dirlndicator then
    if self == Game.Myself then
      self:ClearContractEffects()
    end
  elseif buffType == BuffType.Clearautolock then
    self.data:SetNoAutoLock(nil)
  elseif buffType == BuffType.UpElementAttrLv then
    self.data:RemoveElementAttrBuff(buffInfo)
    EventManager.Me():PassEvent(CreatureEvent.NatureChange, self)
  elseif buffType == BuffType.SetShader then
    if self.shaderConfigID == buffeffect.ShaderConfigID then
      self:ResetMaterials()
    end
  elseif buffType == BuffType.UpgradeRefineLv then
    if self == Game.Myself then
      GameFacade.Instance:sendNotification(MyselfEvent.UpdateRefineBuff, self.data)
    end
  elseif buffType == BuffType.SetShieldHp then
    self.data.shieldLen = nil
  elseif buffType == BuffType.ChangeWalkAction then
    self:ChangeWalkAction()
  elseif buffType == BuffType.ShowDefAttr then
    GameFacade.Instance:sendNotification(MyselfEvent.HideDefAttr, self.data.id)
  elseif buffType == BuffType.NoBreakSkill then
    self:SetNoBreakSkills()
  elseif buffType == BuffType.WithoutTeammate then
    self.data.excludeTeammate = false
    if self == Game.Myself then
      GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
    else
      self:SetClientIsolate(false)
    end
  elseif buffType == BuffType.ShrinkTo then
    self:RemoveShrinkRange(buffInfo.id)
  elseif buffType == BuffType.NoAttackedCanPveBuff then
    self.data:SetHasNoAttackedBuff(false)
    self:SetClickable(true)
  elseif buffType == BuffType.WalkEffect then
    if self == Game.Myself then
      self.playWalkEffect = false
      self.playWalkEffect_path = nil
    end
  elseif buffType == BuffType.MultiShieldHp then
    self.data.multiShieldLevel = nil
  elseif buffType == BuffType.DropItem then
    EventManager.Me():PassEvent(PlayerEvent.RemoveBuffDropItem, {
      self.data.id,
      buffInfo.id
    })
  elseif buffType == BuffType.HideHP then
    if self ~= Game.Myself then
      self:SetHideHp(false)
    end
  elseif buffType == BuffType.InWarehouse then
    if self == Game.Myself then
      self.isInWarehouse = false
      GameFacade.Instance:sendNotification(SkillEvent.LeaveWarehouse)
    end
  elseif buffType == BuffType.PerfectService then
    self.skillRange = 0
    self:SetStageEffectScale()
  elseif buffType == BuffType.PerfectServiceTemporary then
    self.tempRange = 0
    self:SetStageEffectScale()
  end
end

function NCreatureWithPropUserdata:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer, level)
  local buffeffect = buffInfo.BuffEffect
  local buffType = buffeffect.type
  if buffType == BuffType.AttrChange then
    local attrEffect = buffeffect.AttrEffect
    if attrEffect ~= nil then
      local isUpdate = false
      for i = 1, #attrEffect do
        if attrEffect[i] == 11 then
          isUpdate = true
          break
        end
      end
      if isUpdate then
        self:Logic_RideAction(active, RideActionReason.BattleInRiding)
      end
    end
  elseif buffType == BuffType.DynamicSkillConfig then
    if active then
      self.currentDynamicID = buffInfo.id
      self.data:_DynamicSkillConfigAdd(buffeffect)
    else
      self.data:_DynamicSkillConfigRemove(buffeffect)
    end
  elseif buffType == BuffType.Dirlndicator then
    if self == Game.Myself then
      if active then
        local lastContract = self:GetDragonContract()
        if lastContract then
          self:RemoveContractEffect(lastContract)
        end
        self:SetDragonContractEffect(fromID)
        Game.Myself:SetDragonContract(fromID)
      else
        self:RemoveContractEffect(fromID)
        Game.Myself:SetDragonContract()
      end
    end
  elseif buffType == BuffType.Clearautolock then
    self.data:SetNoAutoLock(active)
  elseif buffType == BuffType.Remould then
    if active then
      self.data:UpdateBuffHpVals(layer, maxLayer or 1)
    else
      self.data:UpdateBuffHpVals(nil, nil)
    end
    local ui = self:GetSceneUI()
    if ui then
      ui.roleBottomUI:SetHp(self)
      if ui.roleBottomUI.hpSpCell then
        ui.roleBottomUI.hpSpCell:UpdateBuffHpGrid(maxLayer)
        ui.roleBottomUI.hpSpCell:SetBuffHpBg(active)
      end
    end
    EventManager.Me():PassEvent(CreatureEvent.BuffHpChange, self)
  elseif buffType == BuffType.RotateSelf then
    if active then
      self:Logic_Spin(buffeffect.duration, buffeffect.speed)
    else
      self:Logic_SpinEnd()
    end
  elseif buffType == BuffType.UpgradeRefineLv then
    if self == Game.Myself then
      GameFacade.Instance:sendNotification(MyselfEvent.UpdateRefineBuff, self.data)
    end
  elseif buffType == BuffType.ChangeWalkAction then
    if active then
      self:ChangeWalkAction(buffeffect.action)
    else
      self:ChangeWalkAction()
    end
  elseif buffType == BuffType.ShowDefAttr then
    if active then
      GameFacade.Instance:sendNotification(MyselfEvent.ShowDefAttr, self.data.id)
    else
      GameFacade.Instance:sendNotification(MyselfEvent.HideDefAttr, self.data.id)
    end
  elseif buffType == BuffType.NoEnemyLocked then
    self.data:SetNoEnemyLocked(active)
  elseif buffType == BuffType.NoBreakSkill then
    if active then
      self:SetNoBreakSkills(buffeffect.skillIDs)
    else
      self:SetNoBreakSkills()
    end
  elseif buffType == BuffType.ShrinkTo then
    if active then
      self:AddShrinkRange(buffInfo.id, buffeffect.Launch_Range)
    else
      self:RemoveShrinkRange(buffInfo.id)
    end
  elseif buffType == BuffType.NoAttackedCanPveBuff then
    self.data:SetHasNoAttackedBuff(active)
    self:SetClickable(not active)
  elseif buffType == BuffType.WalkEffect then
    if self == Game.Myself then
      self.playWalkEffect = active
      self.playWalkEffect_path = active and buffeffect.effect_path
    end
  elseif buffType == BuffType.MultiShieldHp then
    self.data.multiShieldLevel = (layer or 1) * buffeffect.sliderlen
  elseif buffType == BuffType.DropItem then
    if active then
      EventManager.Me():PassEvent(PlayerEvent.UpdateBuffDropItem, {
        self.data.id,
        buffInfo.id,
        layer
      })
    end
  elseif buffType == BuffType.IgnoreNoEnemyLocked then
    self.data:SetIgnoreNoEnemyLocked(active)
  elseif buffType == BuffType.Transform then
    self.forbidUseItem = active and buffeffect.forbidUseItem and buffeffect.forbidUseItem == 1
  elseif buffType == BuffType.ShadowViel then
    self.data:SetShadowViel(active)
  elseif buffType == BuffType.RegardAsEquip then
    if not self.asEquipMap then
      self.asEquipMap = {}
    end
    if not self.asEquipSite then
      self.asEquipSite = {}
    end
    self.asEquipMap[buffeffect.typeID] = active and buffeffect.site
    self.asEquipSite[buffeffect.site] = active and buffeffect.typeID
    EventManager.Me():PassEvent(MyselfEvent.AsEquipChange)
  elseif buffType == BuffType.HideHP then
    if self ~= Game.Myself then
      self:SetHideHp(active)
    end
  elseif buffType == BuffType.InWarehouse then
    if self == Game.Myself then
      self.isInWarehouse = active
      if active then
        GameFacade.Instance:sendNotification(SkillEvent.EnterWarehouse)
      else
        GameFacade.Instance:sendNotification(SkillEvent.LeaveWarehouse)
      end
    end
  elseif buffType == BuffType.PerfectService then
    self.skillRange = active and buffeffect.Layer2Range[level or 0] or 0
    self:SetStageEffectScale()
  elseif buffType == BuffType.PerfectServiceTemporary then
    self.tempRange = active and buffeffect.TemporaryRange or 0
    self:SetStageEffectScale()
  end
end

function NCreatureWithPropUserdata:AddPostModelLoadHandleBuffs(buffID, params)
  if not self.postModelLoadHandleBuffs then
    self.postModelLoadHandleBuffs = {}
  end
  self.postModelLoadHandleBuffs[buffID] = table.deepcopy(params)
end

function NCreatureWithPropUserdata:OnAllPartLoaded_TryHandleAddSpecialBuff()
  if not self.postModelLoadHandleBuffs then
    return
  end
  for buffID, params in pairs(self.postModelLoadHandleBuffs) do
    local buff = self.buffs[buffID]
    local buffInfo = GetTable_Buffer(buffID)
    local fromID = buff:GetFromID()
    self:TryHandleAddSpecialBuff(buffInfo, fromID, params)
  end
  self.postModelLoadHandleBuffs = nil
end

function NCreatureWithPropUserdata:RegisterBuffGroup(buff)
  local groupID = buff.staticData.GroupID
  if groupID ~= nil then
    if self.buffGroups == nil then
      self.buffGroups = {}
    end
    local group = self.buffGroups[groupID]
    if group == nil then
      group = BuffGroup.Create()
      group:SetEffectVisible(not self.assetRole:GetInvisible())
      self.buffGroups[groupID] = group
    end
    group:RegisterBuff(self, buff)
  end
end

function NCreatureWithPropUserdata:UnRegisterBuffGroup(buff)
  local groupID = buff.staticData.GroupID
  if groupID ~= nil and self.buffGroups ~= nil then
    local group = self.buffGroups[groupID]
    if group ~= nil then
      group:UnRegisterBuff(self, buff)
      if group:GetBuffCount() == 0 then
        group:Destroy()
        self.buffGroups[groupID] = nil
      end
    end
  end
end

function NCreatureWithPropUserdata:GetBuffLayer(buffID)
  if self.buffs ~= nil and buffID ~= nil then
    local buff = self.buffs[buffID]
    if buff ~= nil then
      return buff:GetLayer()
    end
  end
  return 0
end

function NCreatureWithPropUserdata:HasBuff(buffID)
  if self.buffs ~= nil and buffID ~= nil then
    return self.buffs[buffID] ~= nil
  end
  return false
end

function NCreatureWithPropUserdata:HasBuffs(buffIDs)
  local buffs = self.buffs
  if buffs ~= nil and buffIDs ~= nil then
    for i = 1, #buffIDs do
      if buffs[buffIDs[i]] ~= nil then
        return true
      end
    end
  end
  return false
end

function NCreatureWithPropUserdata:HasBuffStates(buffStateIDs)
  local buffStateCount = self.buffStateCount
  if buffStateCount ~= nil and buffStateIDs ~= nil then
    local count
    for i = 1, #buffStateIDs do
      count = buffStateCount[buffStateIDs[i]]
      if count ~= nil and 0 < count then
        return true
      end
    end
  end
  return false
end

function NCreatureWithPropUserdata:GetBuffActive(buffID)
  if buffID ~= nil and self.buffs ~= nil then
    local buff = self.buffs[buffID]
    if buff ~= nil then
      return buff:GetActive()
    end
  end
  return false
end

function NCreatureWithPropUserdata:GetBuffLevel(buffID)
  if buffID ~= nil and self.buffs ~= nil then
    local buff = self.buffs[buffID]
    if buff ~= nil then
      return buff:GetLevel()
    end
  end
  return 0
end

function NCreatureWithPropUserdata:ClearBuff()
  if self.buffs ~= nil then
    for k, v in pairs(self.buffs) do
      v:Destroy()
      self.buffs[k] = nil
    end
  end
  if self.buffStateCount ~= nil then
    for k, v in pairs(self.buffStateCount) do
      self.buffStateCount[k] = nil
    end
  end
  if self.buffGroups ~= nil then
    for k, v in pairs(self.buffGroups) do
      v:Destroy()
      self.buffGroups[k] = nil
    end
  end
  self.attackBuffCheckMap = nil
end

function NCreatureWithPropUserdata:UpdateMultiMountStatus()
  Game.InteractNpcManager:UpdateMultiMountStatus(self)
end

function NCreatureWithPropUserdata:HandlerAssetRoleSuffixMap()
  local userdata = self.data.userdata
  if userdata == nil then
    return
  end
  local buffEffect = self.data:GetBuffEffectByType(BuffType.ProfessionTransform)
  local profess = buffEffect ~= nil and buffEffect.classid or userdata:Get(UDEnum.PROFESSION)
  if profess == nil or profess == 0 then
    return
  end
  if self.assetRole then
    local suffixMapToSet = Asset_RoleUtility.GetSuffixReplaceMap(profess, userdata:Get(UDEnum.BODY), userdata:Get(UDEnum.SEX))
    self.assetRole:SetSuffixReplaceMap(suffixMapToSet)
  end
end

function NCreatureWithPropUserdata:IsMonster()
  return self.data.IsMonster and self.data:IsMonster()
end

function NCreatureWithPropUserdata:IsOrOwnedByMonster()
  return self.data.IsOrOwnedByMonster and self.data:IsOrOwnedByMonster()
end

function NCreatureWithPropUserdata:DoDeconstruct(asArray)
  if self.data then
    self.data:ClearClientForceDressParts()
  end
  Game.SkillDynamicManager:Clear(self.data.id)
  NCreatureWithPropUserdata.super.DoDeconstruct(self, asArray)
  self:ClearBuff()
  self.playWalkEffect = false
  self.playWalkEffect_path = nil
  self.forbidUseItem = nil
  if self.asEquipMap then
    for k, _ in pairs(self.asEquipMap) do
      self.asEquipMap[k] = nil
    end
  end
  self.shaderConfigID = nil
  self.isInWarehouse = false
  self.stageEffects = nil
  self.tempRange = 0
  self.skillRange = 0
end

function NCreatureWithPropUserdata:Client_StopNotifyServerAngleY()
end

function NCreatureWithPropUserdata:ChangeWalkAction(ActionConfig)
  self.replaceWalkAction = ActionConfig and ActionConfig[1]
  self.rollbackWalkAction = ActionConfig and ActionConfig[2]
end

function NCreatureWithPropUserdata:ChangeShaser(configID)
  if not configID or not GameConfig.ShaderConfig[configID] then
    return
  end
  local shaderConfig = GameConfig.ShaderConfig[configID]
  self:SetMaterialInfo(shaderConfig)
  self.assetRole:SetMaterials(true)
end

function NCreatureWithPropUserdata:CanSelectByTeammate(targetCreature)
end

function NCreatureWithPropUserdata:CanSelectTeammate(sourceCreature)
  if self.attackBuffCheckMap then
    for buffID, v in pairs(self.attackBuffCheckMap) do
      if targetCreature:HasBuff(buffID) then
        return false
      end
    end
    return true
  end
  return false
end

function NCreatureWithPropUserdata:AddShrinkRange(buffID, launchRange)
  local range = 0
  if type(launchRange) == "table" then
    local distanceParams = specialEffect.distance
    range = CommonFun.calcBuffValue(self.data, self .. data, launchRange.type, launchRange.a, launchRange.b, launchRange.c, launchRange.d, 0, 0)
  else
    range = launchRange
  end
  if not self.shrinkMap then
    self.shrinkMap = {}
  end
  self.shrinkMap[buffID] = range
end

function NCreatureWithPropUserdata:RemoveShrinkRange(buffID)
  if self.shrinkMap and buffID then
    self.shrinkMap[buffID] = 0
  end
end

function NCreatureWithPropUserdata:GetMinShrinkRange()
  local min = 9999
  if self.shrinkMap then
    for buffID, range in pairs(self.shrinkMap) do
      if range < min then
        min = range
      end
    end
  end
  return min
end

local idleAction = Asset_Role.ActionName.Idle

function NCreatureWithPropUserdata:UpdatePlayerRider_Up()
  local upID = self.data:GetUpID()
  local up_role = SceneCreatureProxy.FindCreature(upID)
  if upID == 0 then
    self.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
    self.assetRole:SetRideShoulderPrefix()
    if self == Game.Myself then
      GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
    end
    if self.data:IsPippi() then
      self.assetRole:ResetMountRole()
      self:Logic_PlayAction_Idle()
    end
    return
  end
  if self == Game.Myself and (not (up_role and up_role.data) or self.data:IsEnemy(up_role.data)) then
    local data = {}
    data.effect = EffectMap.Maps.ufx_alinia_miao_prf or ""
    data.tip = ZhString.RideEnemyTip
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FullScreenEffectView,
      viewdata = data
    })
  end
  if not up_role then
    return
  end
  if up_role.assetRole then
    if not self.data:IsPippi() then
      up_role.assetRole:SetRideShoulderPrefix(Asset_Role.ActionPrefix_RideShoulder)
      self.assetRole:PutInCreatureToCP(RoleDefines_CP.Wing, up_role)
      up_role.assetRole:PlayAction_Idle()
      up_role:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, 0)
    else
      up_role.assetRole:PutInCreatureToCP(-1, self)
      up_role.assetRole:SetMountRole(self.assetRole.complete)
      up_role:Logic_NavMeshPlaceTo(self:GetRealPosition())
    end
  end
end

function NCreatureWithPropUserdata:UpdatePlayerRider_Down(syncPos)
  if self == Game.Myself then
    EventManager.Me():DispatchEvent(MyselfEvent.RidePlayerChange)
  end
  local downID = self.data:GetDownID()
  local last_down_role = SceneCreatureProxy.FindCreature(self.last_down_roleID)
  if downID == 0 then
    if self == Game.Myself then
      Game.DisableJoyStick = false
      self:ResetCamera(self)
      self.ai:SetForceUpdate(false)
    end
    self:Logic_NavMeshPlaceTo(self:GetPosition())
    self.assetRole:TakeOutCreatureInCP(-1)
    self.assetRole:SetRideShoulderPrefix()
    self.assetRole:ResetMountRole()
    if not (last_down_role and last_down_role.assetRole) or last_down_role.data:IsPippi() then
    else
      last_down_role.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
    end
    local sceneUI = self:GetSceneUI()
    if sceneUI then
      sceneUI.roleBottomUI:ResetRidePos(false)
    end
    return
  end
  if last_down_role and last_down_role.assetRole then
    self.assetRole:TakeOutCreatureInCP(-1)
    self.assetRole:ResetMountRole()
    last_down_role.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
  end
  local down_role = SceneCreatureProxy.FindCreature(downID)
  self.last_down_roleID = downID
  if not down_role then
    return
  end
  if down_role.assetRole then
    self.assetRole:SetRideShoulderPrefix(Asset_Role.ActionPrefix_RideShoulder)
    if down_role.data:IsPippi() then
      if self == Game.Myself then
        Game.DisableJoyStick = false
        self:SwitchCamera(self)
      end
      local realPos = syncPos and down_role:GetRealPosition() or self:GetPosition()
      if VectorUtility.AlmostEqual_3(LuaVector3.Zero(), realPos) then
        realPos = self:GetPosition()
      end
      self:Logic_NavMeshPlaceTo(realPos)
      self.assetRole:PutInCreatureToCP(-1, down_role)
      self.assetRole:SetMountRole(down_role.assetRole.complete)
      local sceneUI = self:GetSceneUI()
      if sceneUI then
        sceneUI.roleBottomUI:ResetRidePos(true)
      end
    else
      if self == Game.Myself then
        Game.DisableJoyStick = true
      end
      down_role.assetRole:PutInCreatureToCP(RoleDefines_CP.Wing, self)
      if self == Game.Myself then
        self.ai:SetForceUpdate(true)
        self:SwitchCamera(down_role)
        local sceneUI = self:GetSceneUI()
        if sceneUI then
          sceneUI.roleBottomUI:ResetRidePos(true)
        end
      end
    end
    self.assetRole:PlayAction_Idle()
    self:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, 0)
  end
end

function NCreatureWithPropUserdata:SwitchCamera(creature)
  if not creature then
    redlog("FunctionPvpObserver: Target Creature is nil")
    return true
  end
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    redlog("FunctionPvpObserver: Cannot Find CameraController When SwitchToTargetCreature: " .. creature.data.id)
    return false
  end
  redlog("SwitchCamera", creature.data.id)
  local focusTrans = creature:GetRoleComplete().transform
  local info = cameraController.defaultInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  info = cameraController.FreeDefaultInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  info = cameraController.photographInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  info = cameraController.currentInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  cameraController:ForceApplyCurrentInfo()
end

function NCreatureWithPropUserdata:ResetCamera(creature)
  if not creature then
    redlog("ResetCamera: Target Creature is nil")
    return true
  end
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    redlog("ResetCamera: Cannot Find CameraController When SwitchToTargetCreature: " .. creature.data.id)
    return false
  end
  local focusTrans = creature:GetRoleComplete().transform
  redlog("SwitchCamera", creature.data.id, focusTrans)
  local info = cameraController.defaultInfo
  info.focus = focusTrans
  info = cameraController.FreeDefaultInfo
  info.focus = focusTrans
  info = cameraController.photographInfo
  info.focus = focusTrans
  info = cameraController.currentInfo
  info.focus = focusTrans
  info = cameraController.currentDefaultInfo
  info.focus = focusTrans
  cameraController:ForceApplyCurrentInfo()
  local cInfo = Game.CameraPointManager.originalDefaultInfo
  if cInfo then
    cInfo.focus = focusTrans
  end
end

function NCreatureWithPropUserdata:GetAsEquipSite(itemtype)
  if not self.asEquipMap then
    return false
  end
  return self.asEquipMap[itemtype]
end

function NCreatureWithPropUserdata:GetAsEquip(site)
  if not self.asEquipSite then
    return false
  end
  return self.asEquipSite[site]
end

function NCreatureWithPropUserdata:IsInWarehouse()
  return self.isInWarehouse
end
