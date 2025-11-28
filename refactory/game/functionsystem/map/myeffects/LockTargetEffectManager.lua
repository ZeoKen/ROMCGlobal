LockTargetEffectManager = class("LockTargetEffectManager")
local _effectPath, _effectPathBW

function LockTargetEffectManager:ctor()
  self.friendColor = LuaColor(0.6313725490196078, 1, 0.5450980392156862, 1)
  self.enemyColor = LuaColor(0.9803921568627451, 0.2980392156862745, 0.24705882352941178, 1)
  self._lockTargetGO = nil
  self._lockTargetEffect = nil
  self._lockTargetEffectProjector = nil
  _effectPath = EffectMap.Maps.LockedTargetNew
  if BackwardCompatibilityUtil.CompatibilityMode(80) then
    _effectPathBW = EffectMap.Maps.LockedTargetBW_RO_247579
  else
    _effectPathBW = EffectMap.Maps.LockedTargetBW
  end
end

function LockTargetEffectManager:_CreateLockedTargetEffect()
  if self._lockTargetEffect == nil and Slua.IsNull(self._lockTargetEffectProjector) then
    if Game.MapManager:IsCurBigWorld() then
      self._lockTargetEffect = Asset_Effect.PlayAtXYZ(_effectPathBW, 0, 0, 0, self.OnEffectCreated, self)
    else
      self._lockTargetEffect = Asset_Effect.PlayAtXYZ(_effectPath, 0, 0, 0, self.OnEffectCreated, self)
    end
  end
end

function LockTargetEffectManager:_SetProjector(projector)
  self._lockTargetEffectProjector = projector
end

function LockTargetEffectManager:_EffectPrepared()
  return not Slua.IsNull(self._lockTargetGO) and Slua.IsNull(self._lockTargetEffectProjector) == false
end

function LockTargetEffectManager:_GetLockedTarget()
  if self._lockedTargetID then
    return SceneCreatureProxy.FindOtherCreature(self._lockedTargetID)
  end
  return nil
end

function LockTargetEffectManager:_SetLockTarget(creature)
  if self:_EffectPrepared() and Slua.IsNull(self._lockTargetGO) == false and self._lockedTargetID then
    local preCreature = self:_GetLockedTarget()
    if preCreature then
      preCreature:Client_UnregisterFollow(self._lockTargetGO.transform)
    else
      Game.RoleFollowManager:UnregisterFollow(self._lockTargetGO.transform)
    end
  end
  if creature then
    self._lockedTargetID = creature.data.id
  else
    self._lockedTargetID = nil
  end
end

function LockTargetEffectManager.OnEffectCreated(eObj, instance, assetEffect)
  if not instance then
    return
  end
  instance._lockTargetEffect = assetEffect
  instance._lockTargetGO = eObj.gameObject
  if assetEffect and assetEffect:GetPath() == _effectPathBW then
    instance:_SetProjector(eObj:GetComponentInChildren(BWROProjector))
  else
    instance:_SetProjector(eObj:GetComponentInChildren(ROProjector))
  end
  if instance._lockedTargetID then
    local ncreature = instance:_GetLockedTarget()
    if ncreature then
      instance:_DoLockTarget(ncreature)
    else
      instance:ClearLockedTarget()
    end
  else
    instance:ClearLockedTarget()
  end
end

function LockTargetEffectManager:SwitchLockedTarget(ncreature)
  if ncreature and ncreature.assetRole then
    self:_SetLockTarget(ncreature)
    if self:_EffectPrepared() then
      self:_DoLockTarget(ncreature)
    else
      self:_CreateLockedTargetEffect()
    end
  end
end

function LockTargetEffectManager:_DoLockTarget(ncreature)
  local projector = self._lockTargetEffectProjector
  local y = 1
  local sx = ncreature.assetRole:GetScaleXYZ()
  ncreature:Client_RegisterFollow(self._lockTargetGO.transform, nil, nil, self.OnLockedTargetLost, self)
  self._lockTargetEffectProjector:RefreshTargets()
  self._lockTargetEffectProjector:RefreshSize()
  self:RefreshEffect()
  self:ClearTick()
  self.scaleTick = TimeTickManager.Me():CreateTickFromTo(0, sx * AutoBattle.SelectScale, sx, AutoBattle.SelectAnimTime, function(owner, deltaTime, curValue)
    if ncreature.assetRole then
      ncreature.assetRole.complete:AdjustProjector(projector, y, curValue)
    end
  end, self, 1000)
end

function LockTargetEffectManager:ClearTick()
  if self.scaleTick ~= nil then
    self.scaleTick:Destroy()
    self.scaleTick = nil
  end
end

function LockTargetEffectManager:ClearLockedTarget()
  self:_SetLockTarget(nil)
  if self._lockTargetEffect then
    self._lockTargetEffect:Destroy()
  end
  self._lockTargetGO = nil
  self._lockTargetEffect = nil
  self._lockTargetEffectProjector = nil
end

function LockTargetEffectManager.OnLockedTargetLost(transform, instance)
  instance:ClearLockedTarget()
end

function LockTargetEffectManager:GetLockedTargetID()
  return self._lockedTargetID
end

function LockTargetEffectManager:RefreshEffect()
  if self:_EffectPrepared() then
    local lockedTarget = self:_GetLockedTarget()
    if lockedTarget then
      if lockedTarget.data:GetCamp() == RoleDefines_Camp.ENEMY then
        self._lockTargetEffectProjector:SetColor(self.enemyColor)
      else
        self._lockTargetEffectProjector:SetColor(self.friendColor)
      end
    end
  end
end
