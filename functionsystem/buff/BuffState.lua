autoImport("Asset_Effect")
BuffState = class("BuffState", Buff)
local CreatureHideOpt = Asset_Effect.DeActiveOpt.CreatureHide
local BuffOpt = Asset_Effect.DeActiveOpt.Buff
if not BuffState.Buff_Inited then
  BuffState.Buff_Inited = true
  BuffState.PoolSize = 200
end
local AroundRotateSpeed = 100
local AroundRadius = 1
local AroundMaxCount = 5
local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()
local tempQuaternion = LuaQuaternion.Identity()
local tempArgs = {
  [1] = nil,
  [2] = nil,
  [3] = nil,
  [4] = nil,
  [5] = nil
}
local Priority = {
  S = 0,
  A = 1,
  B = 2
}
local GetEffectPriority = function(creature)
  if creature == Game.Myself then
    return Priority.S
  end
  if creature and creature:IsOrOwnedByMonster() then
    return Priority.S
  end
  return Priority.B
end
local GetEffectPath = function(paths, creature, priority)
  if paths == nil then
    return nil
  end
  local priority = priority or GetEffectPriority(creature)
  local path, lodLevel = Game.EffectManager:GetEffectPath(paths, priority)
  return path, lodLevel, priority
end
BuffState.GetEffectPath = GetEffectPath
local OnEffectCreated = function(effectHandle, self, assetEffect)
  if not self then
    if assetEffect then
      assetEffect:Destroy()
    end
    return
  end
  self.effect = assetEffect
  self:_OnEffectCreated(effectHandle)
end
local GetArgs = function(layer, level, active, buffStateID, buffID)
  tempArgs[1] = layer
  tempArgs[2] = level
  tempArgs[3] = active
  tempArgs[4] = buffStateID
  tempArgs[5] = buffID
  return tempArgs
end

function BuffState.Create(layer, level, active, buffStateID, buffID)
  local args = GetArgs(layer, level, active, buffStateID, buffID)
  return ReusableObject.Create(BuffState, false, args)
end

function BuffState:Start(creature)
  self:_PlayStartEffect(creature, function(result)
    if not result then
      self:_PlayEffect(creature)
    end
  end)
  if Game.Myself == creature and nil == self.shakeToken then
    local myselfEffect = self.staticData.Myself
    if nil ~= myselfEffect then
      local shake = myselfEffect.shake
      if nil ~= shake then
        self.shakeToken = CameraAdditiveEffectManager.Me():StartShake(shake.range, shake.time, shake.curve)
      end
    end
  end
  creature:RegisterBuffGroup(self)
end

function BuffState:Hit(creature)
  self:_PlayHitEffect(creature)
end

function BuffState:Refresh(creature)
  self:_PlayEffect(creature)
  creature:RegisterBuffGroup(self)
end

function BuffState:End(creature)
  self:_PlayEndEffect(creature)
  creature:UnRegisterBuffGroup(self)
end

function BuffState:SetEffectVisible(visible, deActiveOpt)
  if self.visible ~= visible then
    self.visible = visible
    if self.effect ~= nil then
      self.effect:SetActive(self.visible, deActiveOpt or CreatureHideOpt)
    end
  end
end

function BuffState:OnBodyCreated(creature)
  self:_PlayEffect(creature)
end

function BuffState:_PlayOneShotEffectOn(creature, effectPath, sePath, scale, callBack, callBackArgs, lodLevel, priority, audioSourceType, isDeactiveEffect)
  if effectPath == nil then
    return nil
  end
  if not creature:IsDressed() then
    return nil
  end
  if false == self.visible then
    return nil
  end
  if not self.active and not isDeactiveEffect then
    return nil
  end
  if not creature:IsBodyCreated() then
    return nil
  end
  if nil ~= sePath and "" ~= sePath then
    creature.assetRole:PlaySEOneShotOn(sePath, audioSourceType)
  end
  local ep = self.staticData.EP
  if ep == nil then
    helplog("BuffState _PlayOneShotEffectOn : Unsupport Play Effect With CP")
    return nil
  end
  return creature.assetRole:PlayEffectOneShotOn(effectPath, ep, nil, callBack, callBackArgs, scale, nil, lodLevel, priority)
end

function BuffState:_PlayOneShotEffectAt(creature, effectPath, scale, callBack, lodLevel, priority)
  if effectPath == nil then
    return nil
  end
  if not creature:IsDressed() then
    return nil
  end
  if false == self.visible then
    return nil
  end
  if not self.active then
    return nil
  end
  if not creature:IsBodyCreated() then
    return nil
  end
  local ep = self.staticData.EP
  if ep == nil then
    helplog("BuffState _PlayOneShotEffectAt : Unsupport Play Effect With CP")
    return nil
  end
  return creature.assetRole:PlayEffectOneShotAt(effectPath, ep, nil, callBack, nil, scale, nil, lodLevel, priority)
end

function BuffState:_PlayStartEffect(creature, callBack)
  if not creature:IsOrOwnedByMonster() and Game.HandUpManager:IsInHandingUp() then
    if callBack then
      callBack(false)
    end
    return
  end
  if not creature:IsCullingVisible() or 1 < creature:GetCullingDistanceLevel() then
    if callBack then
      callBack(false)
    end
    return
  end
  local path, lodLevel, priority = GetEffectPath(self.config.Effect_startAt, creature)
  self:_PlayOneShotEffectAt(creature, path, self.staticData.Effect_startScale, nil, lodLevel, priority)
  self:CreateWeakData()
  if nil == self:GetWeakData(1) then
    self:SetWeakData(1, creature)
  end
  if nil ~= self:GetWeakData(2) then
    if callBack then
      callBack(true)
    end
  elseif self.config.Effect_start == nil then
    if callBack then
      callBack(false)
    end
  else
    path, lodLevel, priority = GetEffectPath(self.config.Effect_start, creature)
    local effect = self:_PlayOneShotEffectOn(creature, path, self.staticData.SE_start, self.staticData.Effect_startScale, function(obj, owner, assetEffect)
      if callBack then
        callBack(nil ~= assetEffect)
      end
    end, self, lodLevel, priority, AudioSourceType.BUFF_start)
    if nil ~= effect then
      self:SetWeakData(2, effect)
    end
  end
  if self.staticData.SE_start_Loop ~= "" and not self.audioSource then
    local clip = AudioUtility.GetAudioClip(self.staticData.SE_start_Loop)
    if clip then
      self.audioSource = AudioHelper.PlayLoop_At(clip, 0, 0, 0, 0, AudioSourceType.BUFF_start)
    end
  end
end

function BuffState:_PlayHitEffect(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return
  end
  if not creature:IsCullingVisible() or 1 < creature:GetCullingDistanceLevel() then
    return
  end
  local path, lodLevel, priority = GetEffectPath(self.config.Effect_hit, creature)
  self:_PlayOneShotEffectOn(creature, path, self.staticData.SE_hit, self.staticData.Effect_hitScale, nil, nil, lodLevel, priority, AudioSourceType.BUFF_hit)
end

function BuffState:_PlayEffect(creature)
  if nil ~= self.effect then
    return
  end
  if not self.active then
    return
  end
  if not creature:IsOrOwnedByMonster() and Game.HandUpManager:IsInHandingUp() then
    return
  end
  if not creature:IsBodyCreated() then
    return
  end
  self:CreateWeakData()
  if nil == self:GetWeakData(1) then
    self:SetWeakData(1, creature)
  end
  if nil ~= self:GetWeakData(3) then
    return
  end
  local effectPath, lodLevel, priority = GetEffectPath(self.config.Effect, creature)
  self.priority = priority
  if nil == effectPath then
    return
  end
  local ep = self.staticData.EP
  if ep ~= nil then
    local offset
    local cOffset = self.staticData.Offset
    if cOffset ~= nil and 0 < #cOffset then
      tempVector3:Set(cOffset[1], cOffset[2], cOffset[3])
      offset = tempVector3
    end
    if self:IsEffectFollow() then
      self.effect = creature.assetRole:PlayEffectAt(effectPath, ep, offset, OnEffectCreated, self, self.staticData.EffectScale, nil, lodLevel, priority)
    else
      self.effect = creature.assetRole:PlayEffectOn(effectPath, ep, offset, OnEffectCreated, self, self.staticData.EffectScale, nil, lodLevel, priority)
    end
  else
    local cp = self.staticData.CP
    if cp ~= nil then
      self.effect = creature.assetRole:PlayEffectOn(effectPath, nil, nil, OnEffectCreated, self, self.staticData.EffectScale, cp, lodLevel, priority)
    end
  end
  if nil ~= self.effect then
    self:SetWeakData(3, self.effect)
    if false == self.visible then
      self.effect:SetActive(self.visible, CreatureHideOpt)
    end
  end
end

function BuffState:_PlayEndEffect(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return
  end
  if not creature:IsCullingVisible() or 1 < creature:GetCullingDistanceLevel() then
    return
  end
  local path, lodLevel, priority = GetEffectPath(self.config.Effect_end, creature)
  self:_PlayOneShotEffectOn(creature, path, self.staticData.SE_end, self.staticData.Effect_endScale, nil, nil, lodLevel, priority, AudioSourceType.BUFF_end)
  if self.staticData.SE_start_Loop ~= "" and self.audioSource then
    self.audioSource:Stop()
    self.audioSource = nil
  end
end

function BuffState:_DestroyEffect()
  self:_DestroyAroundEffects()
  if nil ~= self.effect then
    self:_EffectUnregisterFollow()
    self.effect:Destroy()
    self.effect = nil
  end
end

function BuffState:_ApplyLayerEffects()
  self:_OnChangeHandleSpecialBuff()
  if 0 >= self:GetLayer() then
    self:_DestroyLayerEffects()
    return
  end
  self:_ApplyAroundEffects()
end

function BuffState:_DestroyLayerEffects()
  if nil == self.layerEffects then
    return
  end
  TableUtility.ArrayClearByDeleter(self.layerEffects, ReusableObject.Destroy)
  ReusableTable.DestroyArray(self.layerEffects)
  self.layerEffects = nil
end

function BuffState:_ApplyAroundEffects()
  if 0 >= self:GetLayer() or nil == self.effect or nil == self.effect:GetEffectHandle() then
    self:_DestroyLayerEffects()
    return
  end
  if nil ~= self.config.Effect_around then
    local effectPath = GetEffectPath(self.config.Effect_around, nil, self.priority)
    if nil ~= effectPath then
      local transform = self.effect:GetEffectHandle().transform
      if transform.childCount == 0 then
        return
      end
      local parent = transform:GetChild(0)
      self:_AdjustAroundEffects(effectPath, parent, self:GetLayer())
    else
      self:_DestroyLayerEffects()
    end
  else
    self:_DestroyLayerEffects()
  end
end

function BuffState:_AdjustAroundEffects(effectPath, parent, count)
  if nil == self.layerEffects then
    self.layerEffects = ReusableTable.CreateArray()
  end
  local layerEffects = self.layerEffects
  local limitPath, lastLimitPath = self:_GetLimitAroundEffectPath(self.staticData.Logic.effectaround, count)
  if limitPath == nil and lastLimitPath == nil then
    for i = 1, count do
      self:_PlayValidLayerEffect(i, effectPath, parent)
    end
  else
    local limitCount = count % AroundMaxCount
    if lastLimitPath ~= nil then
      lastLimitPath = GetEffectPath(lastLimitPath, nil, self.priority)
    else
      lastLimitPath = effectPath
    end
    count = AroundMaxCount
    local path
    for i = 1, count do
      if i <= limitCount then
        path = GetEffectPath(limitPath, nil, self.priority)
      else
        path = lastLimitPath
      end
      self:_PlayValidLayerEffect(i, path, parent)
    end
  end
  local effectCount = #layerEffects
  if count < effectCount then
    for i = effectCount, count + 1, -1 do
      layerEffects[i]:Destroy()
      layerEffects[i] = nil
    end
  end
  local pieceAngle = 360 / count
  local radius = AroundRadius
  local effect = layerEffects[1]
  local p0 = tempVector3
  p0[3] = radius
  effect:ResetLocalPosition(p0)
  if 1 < count then
    local r = tempQuaternion
    for i = 2, count do
      effect = layerEffects[i]
      tempVector3_1[2] = pieceAngle * (i - 1)
      LuaQuaternion.Better_SetEulerAngles(r, tempVector3_1)
      local p = tempVector3_1
      LuaQuaternion.Better_MulVector3(r, p0, p)
      effect:ResetLocalPosition(p)
    end
  end
end

function BuffState:_AdjustAroundEffectsCallBack(layerEffects, count)
  local effectCount = #layerEffects
  if count < effectCount then
    for i = effectCount, count + 1, -1 do
      layerEffects[i]:Destroy()
      layerEffects[i] = nil
    end
  end
  local effect = layerEffects[1]
  if effect == nil then
    return
  end
  local pieceAngle = 360 / count
  local radius = AroundRadius
  local p0 = tempVector3
  p0[3] = radius
  effect:ResetLocalPosition(p0)
  if 1 < count then
    local r = tempQuaternion
    for i = 2, count do
      effect = layerEffects[i]
      tempVector3_1[2] = pieceAngle * (i - 1)
      LuaQuaternion.Better_SetEulerAngles(r, tempVector3_1)
      local p = tempVector3_1
      LuaQuaternion.Better_MulVector3(r, p0, p)
      effect:ResetLocalPosition(p)
    end
  end
end

function BuffState:_DestroyAroundEffects()
  self:_DestroyLayerEffects()
end

function BuffState:_OnEffectCreated(effectHandle)
  if self.config == nil or nil == self.effect or self.effect:GetEffectHandle() ~= effectHandle then
    return
  end
  self:_EffectRegisterFollow(effectHandle)
  if nil ~= self.config.Effect_around then
    effectHandle.transform.rotation = LuaGeometry.Const_Qua_identity
  end
  self:_ApplyAroundEffects()
  self:_OnChangeHandleSpecialBuff()
  if self.scale then
    self:SetEffectScale(self.scale)
  end
end

local _PatrolWarnRange_MaskLen = 120
local _PatrolWarnRange_TexLen = 128
local _PatrolWarnRange_Tilling = 1 - _PatrolWarnRange_MaskLen / _PatrolWarnRange_TexLen
local _PatrolWarnRange_Offset = function(ANGLE)
  return _PatrolWarnRange_Tilling * (1 - ANGLE / 360) * -1
end
local _PatrolWarnRange_Rotate_Offset = function(ANGLE)
  return (360 - ANGLE) / 2
end

function BuffState:_OnChangeHandleSpecialBuff()
  if self.buffStaticData and self.buffStaticData.BuffEffect.type == BuffType.PatrolWarnRange then
    local patrolEffectRadius = self:GetLayer() / 100000
    local patrolEffectAngle = self:GetLayer() % 100000
    local scalexy = patrolEffectRadius * 0.02
    if self.effect then
      self.effect:ResetLocalScaleXYZ(scalexy, scalexy, 0)
      self.effect:ResetLocalEulerAnglesXYZ(-90, _PatrolWarnRange_Rotate_Offset(patrolEffectAngle), 0)
      local effectMeshRenderer = self.effect:GetComponent(MeshRenderer)
      if effectMeshRenderer then
        local mat = effectMeshRenderer.material
        if mat and mat:HasProperty("_MaskTex") then
          mat:SetTextureScale("_MaskTex", LuaVector2.New(_PatrolWarnRange_Tilling, 1))
          mat:SetTextureOffset("_MaskTex", LuaVector2.New(_PatrolWarnRange_Offset(patrolEffectAngle), -0.25))
        end
      end
    end
  end
end

function BuffState:_ProcessLimitAroundEffectPaths(config)
  if self.aroundEffectPaths == nil then
    self.aroundEffectPaths = ReusableTable.CreateArray()
    local PreprocessEffectPaths = Game.PreprocessEffectPaths
    for i = 1, #config do
      local path = PreprocessEffectPaths(StringUtil.Split(config[i], ","))
      self.aroundEffectPaths[#self.aroundEffectPaths + 1] = path
    end
  end
end

function BuffState:_GetLimitAroundEffectPath(config, count)
  if config == nil then
    return nil
  end
  local index = math.floor(count / AroundMaxCount)
  if index < 1 then
    return nil
  end
  self:_ProcessLimitAroundEffectPaths(config)
  return self.aroundEffectPaths[index], self.aroundEffectPaths[index - 1]
end

function BuffState:_PlayValidLayerEffect(index, path, parent, callBack)
  if index == nil then
    return
  end
  if path == nil then
    return
  end
  local effect = self.layerEffects[index]
  if effect == nil then
    effect = Asset_Effect.PlayOn(path, parent)
    self.layerEffects[index] = effect
  elseif effect:GetPath() ~= path then
    effect:Destroy()
    effect = Asset_Effect.PlayOn(path, parent)
    self.layerEffects[index] = effect
  end
end

function BuffState:_EffectRegisterFollow(effectHandle)
  if not self:IsEffectFollow() then
    return
  end
  if effectHandle == nil then
    return
  end
  local creature = self:GetWeakData(1)
  if creature == nil then
    return
  end
  creature:Client_RegisterFollow(effectHandle.transform, nil, self.staticData.EP)
end

function BuffState:_EffectUnregisterFollow()
  if not self:IsEffectFollow() then
    return
  end
  if self.effect == nil then
    return
  end
  local effectHandle = self.effect:GetEffectHandle()
  if effectHandle == nil or Slua.IsNull(effectHandle) then
    return
  end
  Game.RoleFollowManager:UnregisterFollow(effectHandle.transform)
end

function BuffState:SetLayer(layer)
  if self.layer == layer then
    return
  end
  BuffState.super.SetLayer(self, layer)
  self:_ApplyLayerEffects()
end

function BuffState:SetActive(active, creature)
  if self.active == active then
    return
  end
  BuffState.super.SetActive(self, active)
  if self.effect == nil then
    self:_PlayEffect(creature)
  elseif self.showDeActiveEffect then
    self:_PlayDeActiveEffect(creature)
  else
    self.effect:SetActive(active, BuffOpt)
  end
end

function BuffState:GetType()
  return Buff.Type.State
end

function BuffState:IsEffectFollow()
  return self.staticData ~= nil and self.staticData.Follow == 1
end

function BuffState:_PlayDeActiveEffect(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return
  end
  if not creature:IsCullingVisible() or 1 < creature:GetCullingDistanceLevel() then
    return
  end
  local path, lodLevel, priority = GetEffectPath(self.config.Effect, creature)
  self:_PlayOneShotEffectAt(creature, path, self.staticData.SE_end, self.staticData.Effect_endScale, nil, nil, lodLevel, priority, AudioSourceType.BUFF_end, true)
  if self.staticData.SE_start_Loop ~= "" and self.audioSource then
    self.audioSource:Stop()
    self.audioSource = nil
  end
end

function BuffState:SetEffectScale(scale)
  self.scale = scale
  if self.effect then
    self.effect:ResetLocalScaleXYZ(scale, 1, scale)
  end
end

function BuffState:DoConstruct(asArray, args)
  BuffState.super.DoConstruct(self, asArray, args)
  self.visible = true
  self.shakeToken = nil
  local buffStateID = args[4]
  self.staticData = Table_BuffState[buffStateID]
  self.config = Game.Config_BuffState[buffStateID]
  if self.staticData == nil or self.config == nil then
    error(buffStateID .. " is nil")
  end
  self.buffStaticData = Table_Buffer[args[5]]
  self.showDeActiveEffect = self.buffStaticData.BuffEffect and self.buffStaticData.BuffEffect.condition_buffstate
end

function BuffState:DoDeconstruct(asArray)
  BuffState.super.DoDeconstruct(self, asArray)
  self.visible = nil
  if nil ~= self.shakeToken then
    CameraAdditiveEffectManager.Me():EndShake(self.shakeToken)
    self.shakeToken = nil
  end
  if self.audioSource then
    self.audioSource:Stop()
    self.audioSource = nil
  end
  self:_DestroyEffect()
  self:_DestroyLayerEffects()
  if self.aroundEffectPaths ~= nil then
    ReusableTable.DestroyAndClearArray(self.aroundEffectPaths)
    self.aroundEffectPaths = nil
  end
  self.staticData = nil
  self.config = nil
  self.buffStaticData = nil
  self.priority = nil
  self.showDeActiveEffect = nil
  self.scale = nil
end

function BuffState:OnObserverDestroyed(k, obj)
  if 2 == k then
    local creature = self:GetWeakData(1)
    if nil ~= creature then
      self:_PlayEffect(creature)
    end
  elseif 3 == k and self.effect == obj then
    self.effect = nil
    self:_DestroyAroundEffects()
  end
end
