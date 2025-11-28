autoImport("SceneObjectProxy")
NSceneEffectProxy = class("NSceneEffectProxy", SceneObjectProxy)
NSceneEffectProxy.Instance = nil
NSceneEffectProxy.NAME = "NSceneEffectProxy"
NSceneEffectProxy.MaxCount = 300
autoImport("NSceneEffect")
autoImport("ClientSceneEffect")
local Better_MoveTowards = LuaVector3.Better_MoveTowards
local tempVector3 = LuaVector3.Zero()
local selfVector3 = LuaVector3.Zero()
local LimitedEffect = "Common/immunity"

function NSceneEffectProxy:ctor(proxyName, data)
  self.userMap = {}
  self.sceneEffectMap = {}
  if NSceneEffectProxy.Instance == nil then
    NSceneEffectProxy.Instance = self
  end
  self.proxyName = proxyName or NSceneEffectProxy.NAME
  self.effectCount = 0
  self.audioMap = {}
  self.limitedCountMap = {}
end

function NSceneEffectProxy:Add(data)
  if 0 == data.charid then
    return
  end
  local effectPath = data.effect
  local effectPaths = Game.PreprocessEffectPaths(StringUtil.Split(data.effect, ","))
  local creature = SceneCreatureProxy.FindCreature(data.charid)
  if creature ~= nil and not creature:IsDressEnable() then
    return
  end
  data.effectType = Asset_Effect.EffectTypes.Other
  if data.ownerid == Game.Myself.data.id then
    data.priority = SkillInfo.GetEffectPriority(Game.Myself, data.effectType)
  else
    data.priority = SkillInfo.GetEffectPriority(creature, data.effectType)
  end
  effectPath, data.lodLevel = Game.EffectManager:GetEffectPath(effectPaths, data.priority, data.effectType)
  if effectPath == nil then
    return
  end
  data.effect = effectPath
  if not self:CheckLimitedEffectCount(data.charid, effectPath) then
    return
  end
  local effect = NSceneEffect.CreateAsTable(data)
  local guid = effect.guid
  local effects = self:Find(guid)
  if effects == nil then
    effects = ReusableTable.CreateArray()
    self.userMap[guid] = effects
  end
  effects[#effects + 1] = effect
  effect:Start(self.EffectEnd, self)
  self:AddLimitedEffectCount(data.charid, effect:GetInstanceID(), effectPath)
  return effect
end

function NSceneEffectProxy:AddSkillEffect(data)
  if 0 == data.charid or data.skillid == nil or 0 >= data.skillid then
    return
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(data.skillid)
  if skillInfo == nil then
    return
  end
  local creature = SceneCreatureProxy.FindCreature(data.charid)
  local effectPath, lodLevel, priority, effectType = skillInfo:GetEffectInfoByPhase(creature, data.effect)
  if not effectPath then
    return
  end
  data.priority = priority
  data.effectType = effectType
  data.lodLevel = lodLevel
  data.effect = effectPath
  local effect = NSceneEffect.CreateAsTable(data)
  local guid = effect.guid
  local effects = self:Find(guid)
  if effects == nil then
    effects = ReusableTable.CreateArray()
    self.userMap[guid] = effects
  end
  effects[#effects + 1] = effect
  effect:Start(self.EffectEnd, self)
  return effect
end

function NSceneEffectProxy:Client_AddSceneEffect(id, pos, effectPath, oneShot, dir, scale, speed, createCallBack)
  if not oneShot then
    local effect = self.sceneEffectMap[id]
    if effect == nil then
      effect = ReusableObject.Create(ClientSceneEffect, false, nil)
      self.sceneEffectMap[id] = effect
      effect:Start(pos, effectPath, oneShot, nil, nil, dir, scale, createCallBack)
    end
    if speed then
      effect:SetPlaybackSpeed(speed)
    end
  else
    local assetEffect = ClientSceneEffect.PlayEffect(pos, effectPath, oneShot, createCallBack)
    if dir and assetEffect then
      assetEffect:ResetLocalEulerAngles(dir)
    end
    if scale and assetEffect then
      assetEffect:ResetLocalScaleXYZ(scale, scale, scale)
    end
    if speed then
      assetEffect:SetPlaybackSpeed(speed)
    end
    return assetEffect
  end
end

function NSceneEffectProxy:Client_RemoveSceneEffect(id)
  local effect = self.sceneEffectMap[id]
  if effect then
    self.sceneEffectMap[id] = nil
    effect:Destroy()
  end
end

function NSceneEffectProxy:Client_SetSceneEffectSpeed(id, speed)
  local effect = self.sceneEffectMap[id]
  if effect and speed then
    effect:SetPlaybackSpeed(speed)
  end
end

function NSceneEffectProxy:SceneHasEffect(id)
  return self.sceneEffectMap and self.sceneEffectMap[id]
end

function NSceneEffectProxy:Server_AddSceneEffect(data)
  if data.id == nil or data.id == 0 then
    return
  end
  local guid = data.id
  local effect = self.sceneEffectMap[guid]
  if effect == nil then
    if data.effect == nil then
      return
    end
    helplog("Server_AddSceneEffect", guid, data.effect)
    effect = NSceneEffect.CreateAsTable(data)
    self.sceneEffectMap[guid] = effect
    effect:Start(self.EffectEnd, self)
    return effect
  end
end

function NSceneEffectProxy:Server_RemoveSceneEffect(id)
  self:Client_RemoveSceneEffect(id)
end

function NSceneEffectProxy:EffectEnd(effect)
  self:Remove(effect.args, effect)
end

function NSceneEffectProxy:Destroy(effect)
  if nil == effect or type(effect) ~= "table" then
    return
  end
  if effect.__cname and effect.__cname ~= "NSceneEffect" and effect.__cname ~= "ClientSceneEffect" then
    return
  end
  if effect:Alive() then
    effect:Destroy()
  end
end

function NSceneEffectProxy:Client_SetSceneEffectUVSpeed(id, meshname, uvspeed)
  local effect = self.sceneEffectMap[id]
  if effect and uvspeed and meshname then
    effect:SetUVSpeed(uvspeed, meshname)
  end
end

function NSceneEffectProxy:Remove(data, effect)
  if data.id and data.id > 0 then
    self:Server_RemoveSceneEffect(data.id)
  else
    local guid = NSceneEffect.GetEffectGuid(data)
    local effects = self:Find(guid)
    if nil ~= effects then
      if nil ~= effect then
        local index = TableUtil.Remove(effects, effect)
        self:Destroy(effect)
      else
        for k, v in pairs(effects) do
          self:Destroy(v)
        end
        ReusableTable.DestroyAndClearArray(effects)
        self.userMap[guid] = nil
      end
    end
  end
  return effect
end

function NSceneEffectProxy:Clear()
  for _, effects in pairs(self.userMap) do
    for k, v in pairs(effects) do
      self:Destroy(v)
    end
    ReusableTable.DestroyAndClearArray(effects)
    self.userMap[_] = nil
  end
  for k, effect in pairs(self.sceneEffectMap) do
    self.sceneEffectMap[k] = nil
    self:Destroy(effect)
  end
  for id, audioSource in pairs(self.audioMap) do
    audioSource:Stop()
    self.audioMap[id] = nil
  end
end

function NSceneEffectProxy:PlayProjectileEffect(id, path, beginPos, speed, targetPostion)
  local effect = self.sceneEffectMap[id]
  if not effect then
    effect = TrackEffect.CreateAsArray()
    effect:SetSpeed(speed)
    effect:Spawn(path, beginPos)
    effect:SetEndPostion(targetPostion)
    self:_AddProjectileEffect(effect, id)
    self.sceneEffectMap[id] = effect
  end
end

function NSceneEffectProxy:_AddProjectileEffect(trackEffect, id)
  if self.projectileEffects == nil then
    self.projectileEffects = {}
  end
  if id then
    self.projectileEffects[id] = trackEffect
  end
end

function NSceneEffectProxy:_UpdateProjectileEffect(time, deltaTime)
  local effects = self.projectileEffects
  if effects then
    local projectileEffects, currentPosition, deltaDistance
    for id, projectileEffects in pairs(effects) do
      selfVector3 = projectileEffects:GetEndPostion()
      currentPosition = projectileEffects:GetLocalPosition()
      if currentPosition then
        deltaDistance = projectileEffects:GetSpeed() * deltaTime
        Better_MoveTowards(currentPosition, selfVector3, tempVector3, deltaDistance)
        if VectorUtility.AlmostEqual_3(tempVector3, selfVector3) then
          projectileEffects:Hit()
          projectileEffects:Destroy()
          self.sceneEffectMap[id] = nil
          self.projectileEffects[id] = nil
        else
          projectileEffects:ResetLocalPosition(tempVector3)
        end
      else
        self.sceneEffectMap[id] = nil
        self.projectileEffects[id] = nil
      end
    end
  end
end

function NSceneEffectProxy:_ClearProjectileEffects()
  local effects = self.projectileEffects
  if effects then
    for i = 1, #effects do
      effects[i]:Destroy()
    end
    TableUtility.TableClear(effects)
  end
end

function NSceneEffectProxy:AddAudio(id, clip)
  self.audioMap[id] = clip
end

function NSceneEffectProxy:CheckAudio(id)
  return self.audioMap[id] ~= nil
end

function NSceneEffectProxy:RemoveAudio(id)
  if self.audioMap[id] then
    self.audioMap[id]:Stop()
    GameObject.Destroy(self.audioMap[id])
    self.audioMap[id] = nil
    return true
  end
end

function NSceneEffectProxy:AddLimitedEffectCount(charID, effectInstanceID, effectPath)
  if effectPath ~= LimitedEffect or not charID then
    return
  end
  self.limitedCountMap[charID] = effectInstanceID
end

function NSceneEffectProxy:CheckLimitedEffectCount(charID, effectPath)
  if effectPath ~= LimitedEffect then
    return true
  end
  local instanceID = self.limitedCountMap[charID]
  return Game.AssetManager_Effect:CheckAutoDestroyEffect(instanceID)
end
