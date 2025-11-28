autoImport("Asset_Effect")
AssetManager_Effect = class("AssetManager_Effect")
local EffectLifeLimit = 20
local GameFromPool = GOLuaPoolManager.GetFromEffectPool
local AddToPool = GOLuaPoolManager.AddToEffectPool
local DestroyObserver = function(observer)
  observer[1] = nil
  observer[2] = nil
  observer[3] = nil
  observer[4] = nil
  ReusableTable.DestroyArray(observer)
end

function AssetManager_Effect.RemoveObserverPredicate(observer, tag)
  if observer[1] == tag then
    DestroyObserver(observer)
    return true
  end
  return false
end

function AssetManager_Effect:ctor(assetManager)
  self.nextLoadTag = 1
  self.loadingInfos = {}
  self.delayInfos = {}
  self.autoDestroyEffects = {}
  self.assetManager = assetManager
  self.dictEffectCount = {}
end

function AssetManager_Effect:AddAutoDestroyEffect(effect)
  if effect == nil then
    return
  end
  Game.EffectManager:RegisterEffect(effect, true)
  self.autoDestroyEffects[effect:GetInstanceID()] = effect
end

function AssetManager_Effect:NewTag()
  local tag = self.nextLoadTag
  self.nextLoadTag = self.nextLoadTag + 1
  return tag
end

function AssetManager_Effect:_AddObserver(path, tag, callback, owner, custom)
  local loadingInfo = self.loadingInfos[path]
  if nil == loadingInfo then
    loadingInfo = {
      observers = {},
      loading = false
    }
    self.loadingInfos[path] = loadingInfo
  end
  local observer = ReusableTable.CreateArray()
  observer[1] = tag
  observer[2] = callback
  observer[3] = owner
  observer[4] = custom
  TableUtility.ArrayPushBack(loadingInfo.observers, observer)
end

function AssetManager_Effect:_RemoveObserver(path, tag)
  local loadingInfo = self.loadingInfos[path]
  if nil == loadingInfo then
    return
  end
  TableUtility.ArrayRemoveByPredicate(loadingInfo.observers, AssetManager_Effect.RemoveObserverPredicate, tag)
end

function AssetManager_Effect:_NotifyObservers(path, asset)
  local loadingInfo = self.loadingInfos[path]
  if nil == loadingInfo then
    return
  end
  local observers = loadingInfo.observers
  for i = 1, #observers do
    local observer = observers[i]
    local obj
    if nil ~= asset then
      obj = EffectHandle.Instantiate(asset)
    end
    observer[2](observer[3], observer[1], obj, path, observer[4])
  end
end

function AssetManager_Effect:_EndLoading(path)
  local loadingInfo = self.loadingInfos[path]
  if nil == loadingInfo then
    return
  end
  TableUtility.ArrayClearByDeleter(loadingInfo.observers, DestroyObserver)
  loadingInfo.loading = false
end

function AssetManager_Effect:_AddDelay(tag, path, parent, callback, owner, custom, delay)
  local delayInfo = ReusableTable.CreateArray()
  delayInfo[1] = path
  delayInfo[2] = parent
  delayInfo[3] = callback
  delayInfo[4] = owner
  delayInfo[5] = custom
  delayInfo[6] = delay
  self.delayInfos[tag] = delayInfo
end

function AssetManager_Effect:_RemoveDelay(tag)
  local delayInfo = self.delayInfos[tag]
  if delayInfo ~= nil then
    ReusableTable.DestroyAndClearArray(delayInfo)
    self.delayInfos[tag] = nil
  end
end

function AssetManager_Effect:OnAssetLoaded(asset, resPath, path)
  self:_NotifyObservers(path, asset)
  self:_EndLoading(path)
end

function AssetManager_Effect:CreateEffect(path, parent, callback, owner, custom, delay, tag)
  if nil == path then
    callback(owner, nil, nil, path, custom)
    return nil
  end
  if type(path) == "table" then
    callback(owner, nil, nil, path, custom)
    Debug.LogError("AssetManager_Effect:CreateEffect Error: path is table")
    return nil
  end
  local obj = GameFromPool(Game.GOLuaPoolManager, path, parent)
  if nil ~= obj then
    callback(owner, nil, obj, path, custom)
    return nil
  end
  if delay ~= nil then
    local tag = self:NewTag()
    self:_AddDelay(tag, path, parent, callback, owner, custom, delay + UnityFrameCount)
    return tag
  end
  tag = tag or self:NewTag()
  self:_AddObserver(path, tag, callback, owner, custom)
  return tag
end

function AssetManager_Effect:CancelCreateEffect(path, tag)
  self:_RemoveDelay(tag)
  self:_RemoveObserver(path, tag)
end

function AssetManager_Effect:DestroyEffect(path, obj)
  if nil == obj then
    return
  end
  if AddToPool(Game.GOLuaPoolManager, path, obj) then
    return
  end
  if not LuaGameObject.ObjectIsNull(obj) and not LuaGameObject.ObjectIsNull(obj.gameObject) then
    GameObject.Destroy(obj.gameObject)
  end
end

function AssetManager_Effect:Update(time, deltaTime)
  for k, v in pairs(self.delayInfos) do
    if v[6] >= UnityFrameCount then
      self:CreateEffect(v[1], v[2], v[3], v[4], v[5], nil, k)
      ReusableTable.DestroyAndClearArray(v)
      self.delayInfos[k] = nil
    end
  end
  for path, v in pairs(self.loadingInfos) do
    if not v.loading and 0 < #v.observers then
      v.loading = true
      self.assetManager:LoadAssetAsync(ResourcePathHelper.Effect(path), EffectHandle, self.OnAssetLoaded, self, path)
    end
  end
  local effects = self.autoDestroyEffects
  for id, effect in pairs(effects) do
    local lifeElapsed = effect:UpdateLifeTime(time, deltaTime)
    if effect:Alive() and id == effect:GetInstanceID() then
      if lifeElapsed > EffectLifeLimit or not effect:IsRunning() then
        effect:Destroy()
        effects[id] = nil
      end
    else
      effects[id] = nil
    end
  end
end

function AssetManager_Effect:RemoveAutoDestroyEffect(luaInstanceID, isDestroyFromCSharp)
  local effect = self.autoDestroyEffects[luaInstanceID]
  if effect ~= nil and luaInstanceID == effect:GetInstanceID() then
    if effect:Alive() then
      if isDestroyFromCSharp then
        effect:SetIsDestroyFromCSharp(true)
        effect:Destroy()
        self.autoDestroyEffects[luaInstanceID] = nil
      elseif effect:IsDestroyToPool() then
        effect:Destroy()
        self.autoDestroyEffects[luaInstanceID] = nil
      else
        effect:Hide()
      end
    else
      self.autoDestroyEffects[luaInstanceID] = nil
    end
  end
end

function AssetManager_Effect:RefreshEffectCount(effectPath, count)
  if not effectPath or string.find(effectPath, "UI/") then
    return
  end
  local countBefore = self.dictEffectCount[effectPath]
  if countBefore then
    self.dictEffectCount[effectPath] = countBefore + count
  else
    self.dictEffectCount[effectPath] = count
  end
end

function AssetManager_Effect:GetEffectCount(effectPath)
  return self.dictEffectCount[effectPath] or 0
end

function AssetManager_Effect:PrintEffectCount()
  for k, v in pairs(self.dictEffectCount) do
    redlog("[AssetManager_Effect EffectCount ]", k, v)
  end
end

function AssetManager_Effect:CheckAutoDestroyEffect(effectInstanceID)
  if effectInstanceID == nil then
    return true
  end
  return self.autoDestroyEffects[effectInstanceID] == nil
end
