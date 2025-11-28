Asset_Effect = class("Asset_Effect", ReusableObject)
if not Asset_Effect.Asset_Effect_Inited then
  Asset_Effect.Asset_Effect_Inited = true
  Asset_Effect.PoolSize = 100
end
local tempArgs = {
  nil,
  LuaVector3.Zero(),
  LuaVector3.Zero(),
  LuaVector3.One(),
  nil,
  nil,
  nil,
  false
}
local DeActiveOpt = {
  Origin = 1,
  Filter = 2,
  CreatureHide = 4,
  Buff = 8
}
Asset_Effect.DeActiveOpt = {
  Origin = DeActiveOpt.Origin,
  Filter = DeActiveOpt.Filter,
  CreatureHide = DeActiveOpt.CreatureHide,
  Buff = DeActiveOpt.Buff
}
Asset_Effect.EffectTypes = {
  Map = 1,
  Hit = 2,
  Other = 3
}

function Asset_Effect._Create(args)
  local effect = ReusableObject.Create(Asset_Effect, true, args)
  args[5] = nil
  args[6] = nil
  args[7] = nil
  return effect
end

function Asset_Effect._CreateAutoDestroy(args)
  local effect = ReusableObject.Create(Asset_Effect, true, args)
  args[5] = nil
  args[6] = nil
  args[7] = nil
  args[23] = nil
  Game.AssetManager_Effect:AddAutoDestroyEffect(effect)
  return effect
end

function Asset_Effect.PlayOneShotAtXYZ(path, x, y, z, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
  tempArgs[1] = path
  LuaVector3.Better_Set(tempArgs[2], x, y, z)
  LuaVector3.Better_Set(tempArgs[3], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[4], scale or 1, scale or 1, scale or 1)
  tempArgs[5] = nil
  tempArgs[6] = callback
  tempArgs[7] = callbackArg
  tempArgs[8] = true
  tempArgs[18] = true
  tempArgs[19] = lodLevel
  tempArgs[20] = priority
  tempArgs[21] = effectType
  tempArgs[24] = syncAction
  tempArgs[25] = delay
  return Asset_Effect._CreateAutoDestroy(tempArgs)
end

function Asset_Effect.PlayOneShotAt(path, p, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
  return Asset_Effect.PlayOneShotAtXYZ(path, p[1], p[2], p[3], callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
end

function Asset_Effect.PlayOneShotOn(path, parent, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
  tempArgs[1] = path
  LuaVector3.Better_Set(tempArgs[2], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[3], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[4], scale or 1, scale or 1, scale or 1)
  tempArgs[5] = parent
  tempArgs[6] = callback
  tempArgs[7] = callbackArg
  tempArgs[8] = true
  tempArgs[18] = true
  tempArgs[19] = lodLevel
  tempArgs[20] = priority
  tempArgs[21] = effectType
  tempArgs[24] = syncAction
  tempArgs[25] = delay
  return Asset_Effect._CreateAutoDestroy(tempArgs)
end

function Asset_Effect.PlayOneShotOnUI(path, parent, callback, callbackArg)
  tempArgs[1] = path
  LuaVector3.Better_Set(tempArgs[2], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[3], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[4], 1, 1, 1)
  tempArgs[5] = parent
  tempArgs[6] = callback
  tempArgs[7] = callbackArg
  tempArgs[8] = true
  return Asset_Effect._CreateAutoDestroy(tempArgs)
end

function Asset_Effect.PreloadToPool(path)
  redlog("Asset_Effect.PreloadToPool", path)
  tempArgs[1] = path
  tempArgs[23] = true
  return Asset_Effect._CreateAutoDestroy(tempArgs)
end

function Asset_Effect.PlayAtXYZ(path, x, y, z, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
  tempArgs[1] = path
  LuaVector3.Better_Set(tempArgs[2], x, y, z)
  LuaVector3.Better_Set(tempArgs[3], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[4], scale or 1, scale or 1, scale or 1)
  tempArgs[5] = nil
  tempArgs[6] = callback
  tempArgs[7] = callbackArg
  tempArgs[8] = false
  tempArgs[18] = true
  tempArgs[19] = lodLevel
  tempArgs[20] = priority
  tempArgs[21] = effectType
  tempArgs[24] = syncAction
  tempArgs[25] = delay
  return Asset_Effect._Create(tempArgs)
end

function Asset_Effect.PlayAt(path, p, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
  return Asset_Effect.PlayAtXYZ(path, p[1], p[2], p[3], callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
end

function Asset_Effect.PlayOn(path, parent, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction, delay)
  tempArgs[1] = path
  LuaVector3.Better_Set(tempArgs[2], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[3], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[4], scale or 1, scale or 1, scale or 1)
  tempArgs[5] = parent
  tempArgs[6] = callback
  tempArgs[7] = callbackArg
  tempArgs[8] = false
  tempArgs[18] = true
  tempArgs[19] = lodLevel
  tempArgs[20] = priority
  tempArgs[21] = effectType
  tempArgs[24] = syncAction
  tempArgs[25] = delay
  return Asset_Effect._Create(tempArgs)
end

function Asset_Effect.PlayOnUI(path, parent, callback, callbackArg)
  tempArgs[1] = path
  LuaVector3.Better_Set(tempArgs[2], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[3], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[4], 1, 1, 1)
  tempArgs[5] = parent
  tempArgs[6] = callback
  tempArgs[7] = callbackArg
  tempArgs[8] = false
  return Asset_Effect._Create(tempArgs)
end

function Asset_Effect.CreateWarnRingOn(parent, size, callback, callbackArg)
  local effect = Asset_Effect.PlayOn("Common/WarnRing", parent, callback, callbackArg)
  effect:ResetLocalScaleXYZ(size.x, 1, size.y)
  return effect
end

local isLodDisable = 0

function Asset_Effect.IsEffectLodDisable()
  return 0 < isLodDisable
end

function Asset_Effect.SetEffectLODDisable(disable)
  local lastIsDisable = Asset_Effect.IsEffectLodDisable()
  isLodDisable = isLodDisable + (disable and 1 or -1)
  local curIsDisable = Asset_Effect.IsEffectLodDisable()
  if lastIsDisable ~= curIsDisable and Game.EffectHandleManager then
    Game.EffectHandleManager.isPlotMode = curIsDisable
  end
end

local Asset_Effect_ID = 1

function Asset_Effect:ctor()
  self.id = Asset_Effect_ID
  Asset_Effect_ID = Asset_Effect_ID + 1
  self.args = {}
  Asset_Effect.super.ctor(self)
end

function Asset_Effect:ObserveRole(role, epID, cpID)
  epID = epID or 0
  cpID = cpID or 0
  local args = self.args
  args[8] = epID
  args[17] = cpID
  if nil ~= args[6] then
    args[6].epID = epID
    args[6].cpID = cpID
  end
  self:CreateWeakData()
  self:PushBackWeakData(role)
  if 0 == epID then
  end
end

function Asset_Effect:GetEffectHandle()
  return self.args[6]
end

function Asset_Effect:GetLodLevel()
  return self.args[19]
end

function Asset_Effect:GetPriority()
  return self.args[20]
end

function Asset_Effect:GetEffectType()
  return self.args[21]
end

function Asset_Effect:IsMapEffect()
  return self.args[21] == Asset_Effect.EffectTypes.Map
end

function Asset_Effect:IsActive()
  return self.args[14]
end

function Asset_Effect:SetActive(active, opt)
  if opt == nil then
    opt = DeActiveOpt.Origin
  end
  if active then
    if self.deActiveFlag & opt > 0 then
      self.deActiveFlag = self.deActiveFlag - opt
    end
    if self.deActiveFlag ~= 0 then
      return
    end
  elseif self.deActiveFlag & opt == 0 then
    self.deActiveFlag = self.deActiveFlag + opt
  end
  if self.args[14] == active then
    return
  end
  self.args[14] = active
  if nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.args[6]) then
    self.effectObj:SetActive(active)
  end
end

function Asset_Effect:SetPlaybackSpeed(speed)
  self.args[11] = speed
  if nil ~= self.args[6] then
    self.args[6]:SetPlaybackSpeed(speed)
  end
end

function Asset_Effect:GetPath()
  return self.args[1]
end

function Asset_Effect:GetLocalPosition()
  return self.args[2]
end

function Asset_Effect:GetLocalEulerAngles()
  return self.args[3]
end

function Asset_Effect:GetLocalScale()
  return self.args[4]
end

function Asset_Effect:GetComponent(ComponentClass)
  return self.args[6] and self.args[6]:GetComponent(ComponentClass) or nil
end

function Asset_Effect:GetComponentInChildren(ComponentClass, includeInActive)
  return self.args[6] and self.args[6]:GetComponentInChildren(ComponentClass, includeInActive) or nil
end

function Asset_Effect:GetComponentsInChildren(ComponentClass, includeInActive)
  return self.args[6] and self.args[6]:GetComponentsInChildren(ComponentClass, includeInActive) or nil
end

function Asset_Effect:GetInstanceID()
  return self.instanceID
end

function Asset_Effect:GetGOInstanceID()
  return self.effectObj:GetInstanceID()
end

function Asset_Effect:ResetParent(parent)
  if LuaGameObject.ObjectIsNull(parent) or LuaGameObject.ObjectIsNull(self.effectObj) then
    return
  end
  self.args[5] = parent
  if nil ~= self.args[6] then
    self.effectTrans:SetParent(parent, false)
  end
end

function Asset_Effect:ResetLayer(layer)
  helplog("ResetLayer 1")
  if nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.effectObj) then
    helplog("ResetLayer 2")
    Game.GameObjectUtil:ChangeLayersRecursively(self.effectObj, layer)
  end
end

function Asset_Effect:ResetLocalPositionXYZ(x, y, z)
  local arg = self.args[2]
  if not arg then
    return
  end
  if arg[1] == x and arg[2] == y and arg[3] == z then
    return
  end
  LuaVector3.Better_Set(arg, x, y, z)
  if nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.effectObj) then
    self.effectTrans.localPosition = arg
  end
end

function Asset_Effect:ResetLocalPosition(p)
  self:ResetLocalPositionXYZ(p[1], p[2], p[3])
end

function Asset_Effect:ResetLocalEulerAnglesXYZ(x, y, z)
  local arg = self.args[3]
  if not arg then
    return
  end
  if arg[1] == x and arg[2] == y and arg[3] == z then
    return
  end
  LuaVector3.Better_Set(arg, x, y, z)
  if nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.effectObj) then
    self.effectTrans.localEulerAngles = arg
  end
end

function Asset_Effect:ResetLocalEulerAngles(p)
  self:ResetLocalEulerAnglesXYZ(p[1], p[2], p[3])
end

function Asset_Effect:ResetLocalScaleXYZ(x, y, z)
  local arg = self.args[4]
  if not arg then
    return
  end
  if arg[1] == x and arg[2] == y and arg[3] == z then
    return
  end
  LuaVector3.Better_Set(arg, x, y, z)
  if nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.effectObj) then
    self.effectTrans.localScale = arg
  end
end

function Asset_Effect:ResetLocalScale(p)
  self:ResetLocalScaleXYZ(p[1], p[2], p[3])
end

function Asset_Effect:ResetAction(action, normalizedTime, isForce)
  isForce = isForce or false
  local oldAction = self.args[15]
  if not isForce and oldAction == action then
    return
  end
  self.args[15] = action
  self.args[16] = normalizedTime
  self:_ResetAction()
end

function Asset_Effect:ResetLifeTime(lifeTime)
  self.args[12] = lifeTime
end

function Asset_Effect:UpdateLifeTime(time, deltaTime)
  self.args[12] = self.args[12] + deltaTime
  return self.args[12]
end

function Asset_Effect:Stop()
  self.args[13] = true
  self:_CancelLoading()
  self:_Destroy()
end

function Asset_Effect:IsRunning()
  return not self.args[13]
end

function Asset_Effect:_ResetAction()
  if nil ~= self.args[15] and nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.effectObj) then
    local action = self.args[15]
    local normalizedTime = self.args[16]
    self.args[16] = nil
    local animators = self.args[6].animators
    for i = 1, #animators do
      animators[i]:Play(action, -1, normalizedTime)
    end
  end
end

function Asset_Effect:_ResetEffectHandle()
  local args = self.args
  local effectHandle = args[6]
  if nil == effectHandle or LuaGameObject.ObjectIsNull(self.effectObj) then
    return
  end
  effectHandle.epID = args[8]
  effectHandle.cpID = args[17]
  local role = self:PopBackWeakData()
  if role and role.GetRoleComplete and args[5] == role:GetRoleComplete().tempOwner then
    local parent = role:_GetEffectParent(effectHandle.epID, effectHandle.cpID)
    if parent ~= nil then
      args[5] = parent
    end
  end
  if not LuaGameObject.ObjectIsNull(args[5]) then
    self.effectTrans:SetParent(args[5])
  end
  self.effectTrans.localPosition = args[2]
  self.effectTrans.localEulerAngles = args[3]
  self.effectTrans.localScale = args[4]
  effectHandle.luaInstanceID = self:GetInstanceID()
  if nil ~= args[11] then
    effectHandle:SetPlaybackSpeed(args[11])
  else
    effectHandle:SetPlaybackSpeed(1)
  end
end

function Asset_Effect:IsDestroyToPool()
  return self.args[18]
end

function Asset_Effect:SetIsDestroyToPool(isDestroyToPool)
  self.args[18] = isDestroyToPool
end

function Asset_Effect:Hide()
  if nil ~= self.args[6] and not self.canvasGroup then
    self.canvasGroup = self.effectObj:GetComponent(CanvasGroup)
    if self.canvasGroup then
      self.canvasGroup.alpha = 0
      self:ResetLifeTime(0)
    end
  end
end

function Asset_Effect:_Destroy()
  if not self.isDestroyFromCSharp and nil ~= self.args[6] and not LuaGameObject.ObjectIsNull(self.effectObj) then
    if not self:IsActive() then
      self.effectObj:SetActive(true)
    end
    self.assetManager:DestroyEffect(self.args[1], self.args[6])
    self.args[6] = nil
  end
end

function Asset_Effect:_CancelLoading()
  if nil ~= self.args[7] then
    self.assetManager:CancelCreateEffect(self.args[1], self.args[7])
    self.args[7] = nil
  end
end

function Asset_Effect:OnEffectCreated(tag, obj, path)
  if self.args[23] then
    self.args[23] = nil
    self.args[7] = nil
    self.assetManager:DestroyEffect(path, obj)
    return
  end
  if self.args[7] ~= tag then
    self.assetManager:DestroyEffect(path, obj)
    return
  end
  self.args[7] = nil
  if nil == obj and nil ~= path then
    LogUtility.WarningFormat("Load Effect Failed: path={0}", path)
    return
  end
  if nil == obj or LuaGameObject.ObjectIsNull(obj) then
    return
  end
  self.args[6] = obj
  self.effectObj = self.args[6].gameObject
  self.effectTrans = self.args[6].transform
  self:_ResetEffectHandle()
  if nil ~= obj then
    if self.args[14] then
      self:_ResetAction()
    else
      self.effectObj:SetActive(false)
    end
  end
  if nil ~= self.args[9] then
    self.args[9](obj, self.args[10], self)
    self:RemoveCreatedCallBack()
  end
  if self.args[24] then
    local animator = obj.animators and obj.animators[1]
    if animator then
      local currentState = animator:GetCurrentAnimatorStateInfo(0)
      if currentState then
        self:ResetAction(currentState.shortNameHash, (UnityTime - self.createTime) / currentState.length, true)
      end
    end
  end
end

function Asset_Effect:RemoveCreatedCallBack()
  self.args[9] = nil
  self.args[10] = nil
end

function Asset_Effect:SetUVSpeed(speed, meshname)
  if self.args[6] then
    local mesh = GameObjectUtil.Instance:DeepFindChild(self.effectObj, meshname)
    if mesh then
      local meshrender = mesh:GetComponent(MeshRenderer)
      if meshrender and meshrender.materials then
        local tmpPos = Vector4(0, speed, 0, 1)
        for k, v in pairs(meshrender.materials) do
          v:SetVector("_MainTexUVSpeed", tmpPos)
        end
      end
    end
  end
end

function Asset_Effect:SetIsDestroyFromCSharp(isDestroyFromCSharp)
  self.isDestroyFromCSharp = isDestroyFromCSharp
end

function Asset_Effect:SetParticleTween(duration)
  if nil ~= self.args[6] then
    if not self.tweenMat then
      self.tweenMat = self.effectObj:GetComponent(TweenParitcleMat)
    end
    if self.tweenMat then
      self.tweenMat.duration = duration
    end
  end
end

function Asset_Effect:SetLookAtTrans(trans)
  if nil ~= self.args[6] then
    if not self.lookAtTrans then
      self.lookAtTrans = self.effectObj:GetComponent(LookAtTransform)
    end
    if self.lookAtTrans then
      self.lookAtTrans.lookTarget = trans
    end
  end
end

function Asset_Effect:ClearTrailRenderer(nameMap)
  if self.args[6] and self.effectObj and nameMap then
    for _, cName in pairs(nameMap) do
      local trailGO = GameObjectUtil.Instance:DeepFindChild(self.effectObj, cName)
      if trailGO then
        local trail = trailGO:GetComponent(TrailRenderer)
        if trail then
          trail:Clear()
        end
      end
    end
  end
end

function Asset_Effect:SetTweenScale(duration, scale)
  if nil ~= self.args[6] then
    if not self.tweenScale then
      self.tweenScale = self.effectObj:GetComponent(TweenScale)
    end
    if self.tweenScale then
      self.tweenScale.duration = duration
      self.tweenScale.scale = scale
      self.tweenScale:PlayForward()
    end
  end
end

function Asset_Effect:DoConstruct(asArray, args)
  self.assetManager = Game.AssetManager_Effect
  self.effectManager = Game.EffectManager
  self.deActiveFlag = 0
  self.guid_ts = ServerTime.CurClientTime()
  self.args[1] = args[1]
  self.args[2] = LuaVector3.Better_Clone(args[2])
  self.args[3] = LuaVector3.Better_Clone(args[3])
  self.args[4] = LuaVector3.Better_Clone(args[4])
  self.args[5] = args[5]
  self.args[6] = nil
  self.args[8] = 0
  self.args[9] = args[6]
  self.args[10] = args[7]
  self.args[11] = nil
  self.args[12] = 0
  self.args[13] = false
  self.args[14] = true
  self.args[15] = nil
  self.args[17] = 0
  self.args[18] = true
  self.args[19] = args[19]
  self.args[20] = args[20]
  self.args[21] = args[21]
  self.args[23] = args[23]
  self.args[24] = args[24]
  self.effectTrans = nil
  self.effectObj = nil
  self.isDestroyFromCSharp = nil
  self.createTime = UnityTime
  self.args[7] = nil
  if args[1] ~= nil and (not args[8] or not self.effectManager:IsFiltered()) then
    if self.effectManager:IsFiltered() then
      self.args[14] = false
    end
    self.effectManager:RegisterEffect(self, args[8])
    local loadTag = self.assetManager:CreateEffect(args[1], args[5], self.OnEffectCreated, self, nil, args[25])
    self.args[7] = loadTag
  end
end

function Asset_Effect:DoDeconstruct(asArray)
  self.effectManager:UnRegisterEffect(self)
  self:_CancelLoading()
  self:_Destroy()
  if self.args[2] then
    LuaVector3.Destroy(self.args[2])
    self.args[2] = nil
  end
  if self.args[3] then
    LuaVector3.Destroy(self.args[3])
    self.args[3] = nil
  end
  if self.args[4] then
    LuaVector3.Destroy(self.args[4])
    self.args[4] = nil
  end
  self.args[5] = nil
  self.args[6] = nil
  self.args[15] = nil
  self.args[18] = true
  self.args[19] = nil
  self.args[24] = nil
  self.args[25] = nil
  self:RemoveCreatedCallBack()
  self.createTime = nil
  self.effectTrans = nil
  self.effectObj = nil
  self.isDestroyFromCSharp = nil
  if self.tweenMat then
    self.tweenMat = nil
  end
  if self.lookAtTrans then
    self.lookAtTrans = nil
  end
end

function Asset_Effect:OnObserverDestroyed(k, obj)
  self:Destroy()
end

function Asset_Effect:ObserverEvent(obj, args)
  if args.event == Asset_Role.NotifyEvent.Invisible then
    self:SetActive(not args.value)
  end
end
