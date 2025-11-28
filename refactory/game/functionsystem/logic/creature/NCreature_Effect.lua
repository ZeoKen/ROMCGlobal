local tempVector3 = LuaVector3.Zero()
local selfVector3 = LuaVector3.Zero()
local LastPosition = LuaVector3.Zero()
local OnLookAtEffectCreated = function(effectHandle, lookAtTrans, assetEffect)
  if assetEffect and lookAtTrans then
    assetEffect:SetLookAtTrans(lookAtTrans)
  end
end
local SetTweenParticel = function(effectHandle, duration, assetEffect)
  if assetEffect and duration then
    assetEffect:SetParticleTween(duration)
  end
end

function NCreature:PlayEffect(key, path, epID, offset, loop, stick, callback, callbackArg)
  if loop then
    local effect = self:GetWeakData(key)
    if effect == nil and self.assetRole then
      if loop then
        if stick then
          effect = self.assetRole:PlayEffectOn(path, epID, offset, callback, callbackArg, nil, nil)
        else
          effect = self.assetRole:PlayEffectAt(path, epID, offset, callback, callbackArg, nil, nil)
        end
        self:SetWeakData(key, effect)
      end
      return effect
    end
    return nil
  elseif stick then
    return self.assetRole:PlayEffectOneShotOn(path, epID, offset, callback, callbackArg, nil, nil)
  else
    return self.assetRole:PlayEffectOneShotAt(path, epID, offset, callback, callbackArg, nil, nil)
  end
end

function NCreature:RemoveEffect(key)
  local effect = self:GetWeakData(key)
  if effect then
    effect:Destroy()
  end
end

function NCreature:GetEffect(key)
  return self:GetWeakData(key)
end

function NCreature:PlayAudio(path, audioSourceType, loop)
  if loop then
    self.assetRole:PlaySEOn(path, audioSourceType, loop)
  else
    self.assetRole:PlaySEOneShotOn(path, audioSourceType)
  end
end

function NCreature:OnObserverEffectDestroyed(key, effect)
end

local damagePos = LuaVector3()

function NCreature:PlayDamage_Effect(damage, damageType, fromid)
  local posx, posy, posz = self.assetRole:GetEPOrRootPosition(RoleDefines_EP.Chest)
  LuaVector3.Better_Set(damagePos, posx, posy + math.random(0, 20) / 100, posz)
  local fromCreature = SceneCreatureProxy.FindCreature(fromid)
  if 0 < damage then
    local color = HurtNumColorType.Player
    if CommonFun.DamageType.Normal_Sp == damageType or CommonFun.DamageType.Treatment_Sp == damageType then
      color = HurtNumColorType.Normal_Sp
    end
    SkillLogic_Base.ShowDamage_Single(damageType, damage, damagePos, HurtNumType.DamageNum_R, color, self, nil, fromCreature)
  elseif damage < 0 then
    if CommonFun.DamageType.Normal_Sp == damageType or CommonFun.DamageType.Treatment_Sp == damageType then
      SkillLogic_Base.ShowDamage_Single(CommonFun.DamageType.Treatment_Sp, -damage, damagePos, nil, nil, self, nil, fromCreature)
    else
      SkillLogic_Base.ShowDamage_Single(CommonFun.DamageType.Treatment, -damage, damagePos, nil, nil, self, nil, fromCreature)
    end
  end
end

function NCreature:_AddTrackEffect(trackEffect)
  if self.trackEffects == nil then
    self.trackEffects = {}
  end
  self.trackEffects[#self.trackEffects + 1] = trackEffect
end

local Better_MoveTowards = LuaVector3.Better_MoveTowards
local tableRemove = table.remove

function NCreature:_UpdateTrackEffect(time, deltaTime)
  local effects = self.trackEffects
  if effects then
    for i = #effects, 1, -1 do
      if not effects[i].ingoreChest then
        tempVector3:Set(self.assetRole:GetEPOrRootPosition(RoleDefines_EP.Chest))
        effects[i]:SetEndPostion(tempVector3)
      end
      if not effects[i]:Update(time, deltaTime) then
        effects[i]:Destroy()
        tableRemove(effects, i)
      end
    end
  end
end

function NCreature:_ClearTrackEffects()
  local effects = self.trackEffects
  if effects then
    for i = 1, #effects do
      effects[i]:Destroy()
    end
    TableUtility.TableClear(effects)
  end
end

function NCreature:PlayPickUpTrackEffect(path, pos, speed, audioPath, bezierRadius, limitUp)
  local effect = TrackEffect.CreateAsArray()
  effect:SetSpeed(speed)
  effect:Spawn(path, pos)
  if bezierRadius then
    effect:SetBezierRadius(bezierRadius, limitUp)
  end
  effect:SetHitCall(NCreature.PickUpEffectArrivedHandler, self, audioPath)
  self:_AddTrackEffect(effect)
end

function NCreature.PickUpEffectArrivedHandler(trackEffect, player, audioPath)
  player:PlayPickedUpItem(audioPath)
end

function NCreature:PlayPickedUpItem(audioPath)
  self:PlayEffect(nil, GameConfig.SceneDropItem.itemPickedEffect, RoleDefines_EP.Chest, nil, false, true)
  self:PlayAudio(audioPath, RoleDefines_EP.Chest, false)
end

function NCreature:SetSimplifyRolePart(on)
  self.assetRole:SetSimplifyRolePart(on)
end

function NCreature:_AddProjectileEffect(trackEffect)
  if self.projectileEffects == nil then
    self.projectileEffects = {}
  end
  self.projectileEffects[#self.projectileEffects + 1] = trackEffect
end

function NCreature:_UpdateProjectileEffect(time, deltaTime)
  local effects = self.projectileEffects
  if effects then
    for i = #effects, 1, -1 do
      if not effects[i]:Update(time, deltaTime) then
        effects[i]:Destroy()
        tableRemove(effects, i)
      end
    end
  end
end

function NCreature:_ClearProjectileEffects()
  local effects = self.projectileEffects
  if effects then
    for i = 1, #effects do
      effects[i]:Destroy()
    end
    TableUtility.TableClear(effects)
  end
end

function NCreature:PlayProjectileEffect(key, path, beginPos, speed, targetPostion)
  local effect = TrackEffect.CreateAsArray()
  effect:SetSpeed(speed)
  effect:Spawn(path, beginPos)
  effect:SetEndPostion(targetPostion)
  self:_AddProjectileEffect(effect)
  self:SetWeakData(key, effect)
end

function NCreature:_AddCastWarningEffect(key)
  if self.castWarningEffects == nil then
    self.castWarningEffects = {}
  end
  self.castWarningEffects[#self.castWarningEffects + 1] = key
end

function NCreature:_ClearCastWarningEffects()
  local effects = self.castWarningEffects
  if effects then
    for i = 1, #effects do
      local effect = self:GetWeakData(effects[i])
      if effect then
        effect:Destroy()
        effect = nil
      end
    end
    TableUtility.TableClear(self.castWarningEffects)
  end
end

function NCreature:ClearCastWarningEffect(key)
  local effect = self:GetWeakData(key)
  if effect then
    effect:Destroy()
    effect = nil
  end
end

function NCreature:PlayCastWarningEffect(key, path, targetSize, targetSize2, casttime)
  local effect = self:GetWeakData(key)
  if effect then
    return
  end
  local assetRole = self.assetRole
  local completeTransform = assetRole.completeTransform
  effect = Asset_Effect.PlayOn(path, completeTransform, SetTweenParticel, casttime)
  effect:ResetLocalScaleXYZ(targetSize or 1, 1, targetSize2 or targetSize or 1)
  self:_AddCastWarningEffect(key)
  self:SetWeakData(key, effect)
end

function NCreature:PlayLookAtEffect(key, path, epID, offset, loop, stick, lookAtTrans, callback, callbackArg)
  if not key or not lookAtTrans then
    return
  end
  if loop then
    local effect = self:GetWeakData(key)
    if effect == nil and self.assetRole then
      if stick then
        effect = self.assetRole:PlayEffectOn(path, epID, offset, OnLookAtEffectCreated, lookAtTrans, nil, nil)
      else
        effect = self.assetRole:PlayEffectAt(path, epID, offset, OnLookAtEffectCreated, lookAtTrans, nil, nil)
      end
      self:SetWeakData(key, effect)
      return effect
    end
    return nil
  elseif stick then
    return self.assetRole:PlayEffectOneShotOn(path, epID, offset, OnLookAtEffectCreated, lookAtTrans, nil, nil)
  else
    return self.assetRole:PlayEffectOneShotAt(path, epID, offset, OnLookAtEffectCreated, lookAtTrans, nil, nil)
  end
end

function NCreature:RemoveLookAtEffect(key)
  local effect = self:GetWeakData(key)
  if effect then
    effect:Destroy()
  end
end

local OnTimeDiskEffectCreated = function(effectHandle, pos, assetEffect)
  if assetEffect and pos then
    assetEffect:ResetLocalEulerAngles(pos)
  end
end

function NCreature:PlayTimeDiskEffect(path, epID, offset, stick)
  if not self.assetRole then
    return
  end
  local effect = self:GetWeakData(path)
  offset = {
    0,
    0,
    0
  }
  if not effect then
    if stick then
      effect = self.assetRole:PlayEffectOn(path, epID, offset, OnTimeDiskEffectCreated, pos)
      self:SetWeakData(path, effect)
    else
      effect = self.assetRole:PlayEffectOneShotAt(path, epID, offset, OnTimeDiskEffectCreated, pos)
    end
  end
end

function NCreature:RemoveTimeDiskEffect(path)
  local effect = self:GetWeakData(path)
  if effect then
    effect:Destroy()
  end
end

local OnContractEffectCreated = function(effectHandle, dir, assetEffect)
  if assetEffect and dir then
    assetEffect:ResetLocalEulerAnglesXYZ(0, dir, 0)
  end
end

function NCreature:PlayContractEffect(sourceid, path, epID, offset, stick, dir)
  if not sourceid or not self.assetRole then
    return
  end
  local effect = self:GetContractData(sourceid)
  if not effect then
    if stick then
      effect = self.assetRole:PlayEffectOn(path, epID, offset, OnContractEffectCreated, dir)
    else
      effect = self.assetRole:PlayEffectAt(path, epID, offset, OnContractEffectCreated, dir)
    end
    self:AddContractEffect(sourceid, effect)
  else
    effect:ResetLocalEulerAnglesXYZ(0, dir, 0)
  end
end

function NCreature:RemoveContractEffect(sourceid)
  local effect = self:GetContractData(sourceid)
  if effect then
    effect:Destroy()
    self.contractEffects[sourceid] = nil
  end
end

function NCreature:UpdateContractEffect(time, deltaTime)
  if not self.contractEffects then
    return
  end
  local effects = self.contractEffects
  for sourceid, effect in pairs(effects) do
    local lookatPlayer = NSceneUserProxy.Instance:Find(sourceid)
    local endPosition
    if lookatPlayer then
      endPosition = lookatPlayer.logicTransform.currentPosition
    else
    end
    if endPosition then
      local currentPosition = self.logicTransform.currentPosition
      local angleY = VectorHelper.GetAngleByAxisY(currentPosition, endPosition)
      LuaVector3.Better_Set(LastPosition, endPosition.x, endPosition.y, endPosition.z)
      if effect.effectTrans then
        effect.effectTrans:LookAt(endPosition)
      end
    elseif LastPosition then
      effect.effectTrans:LookAt(LastPosition)
    end
  end
end

function NCreature:GetContractData(sourceid)
  if not self.contractEffects or not sourceid then
    return nil
  end
  return self.contractEffects[sourceid]
end

function NCreature:AddContractEffect(sourceid, cEffect)
  if not sourceid then
    return
  end
  if not self.contractEffects then
    self.contractEffects = {}
  end
  self.contractEffects[sourceid] = cEffect
end

function NCreature:ClearContractEffects()
  local effects = self.contractEffects
  if effects then
    for _, effect in pairs(effects) do
      effect:Destroy()
    end
    TableUtility.TableClear(effects)
  end
end

function NCreature:PlayDropItemTrackEffect(path, spawnPos, speed, endPos)
  local effect = TrackEffect.CreateAsArray()
  effect:SetSpeed(speed)
  effect:Spawn(path, spawnPos)
  effect:SetEndPostion(endPos)
  effect:SetBezierRadius(5, limitUp)
  effect.ingoreChest = true
  self:_AddTrackEffect(effect)
end

function NCreature:PlayWalkEffect(epID)
  if not self.assetRole then
    return
  end
  self.walk_path = self.playWalkEffect_path
  if not self.playWalkEffect or not self.walk_path then
    return
  end
  local effect = self:GetWeakData(self.walk_path)
  if not effect then
    effect = self.assetRole:PlayEffectOn(self.walk_path, epID)
    self:SetWeakData(self.walk_path, effect)
  end
end

function NCreature:RemoveWalkEffect()
  if not self.assetRole or not self.walk_path then
    return
  end
  local effect = self:GetWeakData(self.walk_path)
  if effect then
    effect:Destroy()
  end
  self.walk_path = nil
end

local StageEffectWeakKey = "StageEffectWeakKey"

function NCreature:PlayStageEffect(path, scale)
  if not self.assetRole then
    return
  end
  local effect = self:GetEffect(StageEffectWeakKey)
  effect = effect or self:PlayEffect(StageEffectWeakKey, path, RoleDefines_EP.Bottom, nil, true)
  if effect then
    effect:ResetLocalScaleXYZ(scale or 1, 1, scale or 1)
  end
end

function NCreature:RemoveStageEffect()
  if not self.assetRole then
    return
  end
  local effect = self:GetEffect(StageEffectWeakKey)
  if effect then
    effect:Destroy()
  end
end
