NSceneEffect = reusableClass("NSceneEffect")
NSceneEffect.PoolSize = 20
NSceneEffect.AssetEffect = "AssetEffect"
NSceneEffect.WarnRingEffect = "WarnRingEffect"
local EffectLT_NowCount = 0
local EffectLT_MaxCount = 200

function NSceneEffect.GetEffectGuid(data)
  if data.id ~= nil and data.id ~= 0 then
    return data.id
  end
  return tostring(data.charid) .. "_" .. tostring(data.index)
end

function NSceneEffect.IsEffectOneShot(args)
  return 0 ~= args.times
end

function NSceneEffect:ctor(data)
  NSceneEffect.super.ctor(self)
  self:CreateWeakData()
end

function NSceneEffect:Start(endCallback, context)
  if self.running then
    return
  end
  self.running = true
  self.endCallback = endCallback
  self.context = context
  local args = self.args
  if nil ~= args.delay and args.delay > 0 then
    if EffectLT_NowCount >= EffectLT_MaxCount then
      self:DoStart()
      redlog("TOO MUCH DELAY EFFECT!!!!!!")
      return
    end
    EffectLT_NowCount = EffectLT_NowCount + 1
    self.delayLT = TimeTickManager.Me():CreateOnceDelayTick(args.delay, function(owner, deltaTime)
      self:DoStart()
    end, self)
  else
    self:DoStart()
  end
  if args.duration ~= nil and 0 < args.duration and args.times == 0 then
    self.delayLT = TimeTickManager.Me():CreateOnceDelayTick(args.duration, function(owner, deltaTime)
      self:Destroy()
    end, self)
  end
end

function NSceneEffect.PlayEffect(args, creature, callBack)
  if NSceneEffect.IsEffectOneShot(args) then
    local go
    if args.posbind then
      if creature then
        return creature.assetRole:PlayEffectOneShotAt(args.effect, args.effectpos, nil, callBack, nil, args.scale, nil, args.lodLevel, args.priority, args.effectType)
      else
        if not args.ignorenavmesh then
          NavMeshUtility.SelfSample(args.pos)
        end
        return Asset_Effect.PlayOneShotAt(args.effect, args.pos, callBack, nil, args.scale, args.lodLevel, args.priority, args.effectType)
      end
    elseif creature then
      return creature.assetRole:PlayEffectOneShotOn(args.effect, args.effectpos, nil, callBack, nil, args.scale, nil, args.lodLevel, args.priority, args.effectType)
    end
  elseif args.posbind then
    if creature then
      return creature.assetRole:PlayEffectAt(args.effect, args.effectpos, nil, callBack, nil, args.scale, nil, args.lodLevel, args.priority, args.effectType)
    else
      if not args.ignorenavmesh then
        NavMeshUtility.SelfSample(args.pos)
      end
      return Asset_Effect.PlayAt(args.effect, args.pos, callBack, nil, args.scale, args.lodLevel, args.priority, args.effectType)
    end
  elseif creature then
    return creature.assetRole:PlayEffectOn(args.effect, args.effectpos, nil, callBack, nil, args.scale, nil, args.lodLevel, args.priority, args.effectType)
  end
end

function NSceneEffect:DoStart()
  if not self.running then
    return
  end
  local args = self.args
  self:CancelDelay()
  local assetEffect
  local creature = SceneCreatureProxy.FindCreature(args.charid)
  if args.epbind then
    if nil ~= creature then
      assetEffect = NSceneEffect.PlayEffect(args, creature)
    end
  else
    assetEffect = NSceneEffect.PlayEffect(args)
    assetEffect:ResetLocalEulerAnglesXYZ(args.dir[1], args.dir[2], args.dir[3])
    if nil ~= creature then
      assetEffect:ObserveRole(creature)
    end
  end
  if assetEffect then
    self.oneshotInstanceID = assetEffect:GetInstanceID()
  end
  if assetEffect and not NSceneEffect.IsEffectOneShot(args) then
    self:CreateWeakData()
    self:SetWeakData(NSceneEffect.AssetEffect, assetEffect)
  elseif not self:FireCallBack() then
    self:Destroy()
  end
  if assetEffect then
    return assetEffect
  end
end

function NSceneEffect:CancelDelay()
  if nil ~= self.delayLT then
    self.delayLT:Destroy()
    self.delayLT = nil
    EffectLT_NowCount = EffectLT_NowCount - 1
  end
end

function NSceneEffect:FireCallBack()
  if nil ~= self.endCallback then
    local call, context = self.endCallback, self.context
    self.endCallback = nil
    self.context = nil
    call(context, self)
    return true
  end
  return false
end

function NSceneEffect:DoConstruct(asArray, data)
  NSceneEffect.super.DoConstruct(self)
  local args = ReusableTable.CreateTable()
  self.args = args
  args.charid = data.charid
  args.index = data.index
  args.epbind = data.epbind
  args.effectpos = data.effectpos
  args.times = data.times
  args.posbind = data.posbind
  args.effect = data.effect
  args.pos = ProtolUtility.S2C_Vector3(data.pos)
  args.delay = data.delay
  args.id = data.id
  args.dir = ProtolUtility.S2C_Vector3(data.dir3d)
  args.skillid = data.skillid
  args.ignorenavmesh = data.ignorenavmesh
  args.scale = data.scale or 1
  args.duration = data.msec
  args.lodLevel = data.lodLevel
  args.priority = data.priority
  args.effectType = data.effectType
  self.guid = NSceneEffect.GetEffectGuid(data)
end

function NSceneEffect:Destroy()
  NSceneEffect.super.Destroy(self)
end

function NSceneEffect:DoDeconstruct(asArray)
  if not self.running then
    return
  end
  self.running = false
  self.endCallback = nil
  self.context = nil
  self:CancelDelay()
  local effect, warnRingEffect
  if self._weakData then
    effect = self:GetWeakData(NSceneEffect.AssetEffect)
    warnRingEffect = self:GetWeakData(NSceneEffect.WarnRingEffect)
  end
  NSceneEffect.super.DoDeconstruct(self)
  if effect then
    effect:Destroy()
  end
  if warnRingEffect then
    warnRingEffect:Destroy()
  end
  if self.args then
    if self.args.pos then
      LuaVector3.Destroy(self.args.pos)
      self.args.pos = nil
    end
    if self.args.dir then
      LuaVector3.Destroy(self.args.dir)
      self.args.dir = nil
    end
    ReusableTable.DestroyAndClearTable(self.args)
    self.args = nil
  end
end

function NSceneEffect:SetPlaybackSpeed(speed)
  local effect = self:GetWeakData(NSceneEffect.AssetEffect)
  if effect then
    effect:SetPlaybackSpeed(speed)
  end
end

function NSceneEffect:SetUVSpeed(uvspeed, meshname)
  local effect = self:GetWeakData(NSceneEffect.AssetEffect)
  if effect then
    effect:SetUVSpeed(uvspeed, meshname)
  end
end

function NSceneEffect:GetInstanceID()
  return self.oneshotInstanceID
end
