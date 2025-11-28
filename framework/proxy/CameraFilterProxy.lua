CameraFilterProxy = class("CameraFilterProxy", pm.Proxy)
CameraFilterProxy.Instance = nil
CameraFilterProxy.NAME = "CameraFilterProxy"
autoImport("PpLua")

function CameraFilterProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CameraFilterProxy.NAME
  if CameraFilterProxy.Instance == nil then
    CameraFilterProxy.Instance = self
    self:Init()
  end
  if data ~= nil then
    self:setData(data)
  end
  self.HasInitCamera = false
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(LoadEvent.StartLoadScene, self.StartLoadScene, self)
  eventManager:AddEventListener(ServiceEvent.PlayerMapChange, self.PlayerMapChange, self)
  self.pausing = 0
end

function CameraFilterProxy:StartLoadScene()
  self:CFQuit(true)
end

function CameraFilterProxy:PlayerMapChange()
  self:CFQuit(true)
end

function CameraFilterProxy:CFSetEffectAndSpEffect(nameOfEffect, nameOfSpEffect, highPriority, updateDepthOfField_duration, effect_duration, toneMappingTexture)
  if self.highPriority and not highPriority then
    return
  end
  self.nameOfEffect = nameOfEffect
  self.nameOfSpEffect = nameOfSpEffect
  self.highPriority = highPriority
  self.updateDepthOfField_duration = updateDepthOfField_duration
  self.effect_duration = effect_duration
  self.toneMappingTexture = toneMappingTexture
  if self.pausing > 0 then
    return
  end
  self:_CFSetEffectAndSpEffect(nameOfEffect, nameOfSpEffect, updateDepthOfField_duration, effect_duration, toneMappingTexture)
end

function CameraFilterProxy:_CFSetEffectAndSpEffect(nameOfEffect, nameOfSpEffect, updateDepthOfField_duration, effect_duration, ToneMappingTexture)
  self.gmCm = NGUIUtil:GetCameraByLayername("Default")
  local rootTrans = UIManagerProxy.Instance.UIRoot.transform
  if self.HasInitCamera ~= true then
    self.HasInitCamera = true
    PpLua:Init({
      self.gmCm
    })
    PpLua:SetEffect(nameOfEffect)
    if ToneMappingTexture ~= nil and ToneMappingTexture ~= "" then
      Game.EnviromentManager:UpdateBloom()
      self.lutTextureFullPath = "Enviroment/CustomLut/" .. ToneMappingTexture
      Game.AssetManager:LoadAssetAsync(self.lutTextureFullPath, Texture, self.OnAssetLoaded_lutTexture, self, self.lutTextureFullPath)
    else
      RenderingManager.Instance:SetCustomLutTexture(nil)
    end
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    if nameOfSpEffect ~= "" then
      self.effect = Asset_Effect.PlayOn("CameraEfc/" .. nameOfSpEffect, rootTrans, self._HandleMidEffectShow, self)
      self.effect:SetActive(true)
    end
    if effect_duration and 0 < effect_duration then
      self.timeCallDelete = TimeTickManager.Me():CreateOnceDelayTick(effect_duration, function(owner, deltaTime)
        self:CFQuit(true)
      end, self)
    end
  else
    PpLua:Destory()
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    PpLua:Init({
      self.gmCm
    })
    PpLua:SetEffect(nameOfEffect)
    if ToneMappingTexture ~= nil and ToneMappingTexture ~= "" then
      Game.EnviromentManager:UpdateBloom()
      self.lutTextureFullPath = "Enviroment/CustomLut/" .. ToneMappingTexture
      Game.AssetManager:LoadAssetAsync(self.lutTextureFullPath, Texture, self.OnAssetLoaded_lutTexture, self, self.lutTextureFullPath)
    else
      RenderingManager.Instance:SetCustomLutTexture(nil)
    end
    if nameOfSpEffect ~= "" then
      self.effect = Asset_Effect.PlayOn("CameraEfc/" .. nameOfSpEffect, rootTrans, self._HandleMidEffectShow, self)
      self.effect:SetActive(true)
    end
  end
  if updateDepthOfField_duration and 0 < updateDepthOfField_duration then
    if self.updateDepthOfField_ltId then
      LeanTween.cancel(LeanTween.tweenEmpty, self.updateDepthOfField_ltId)
    end
    self.updateDepthOfField_ltId = nil
  end
end

function CameraFilterProxy:OnAssetLoaded_lutTexture(asset, resID, path)
  LogUtility.InfoFormat("<color=yellow>OnAssetLoaded_lutTexture: </color>{0}, {1}", nil ~= asset and asset or "nil", path)
  if self.lutTextureFullPath == path then
    RenderingManager.Instance:SetCustomLutTexture(asset)
  else
    RenderingManager.Instance:SetCustomLutTexture(nil)
    Game.AssetManager:UnloadAsset(resID)
  end
end

function CameraFilterProxy._HandleMidEffectShow(effectHandle, owner)
  if effectHandle == nil then
    helplog("if effectHandle == nil then")
    return
  end
end

function CameraFilterProxy:CFQuit(highPriority)
  if self.highPriority and not highPriority then
    return
  end
  self.nameOfEffect = nil
  self.nameOfSpEffect = nil
  self.highPriority = false
  self.updateDepthOfField_duration = nil
  self.effect_duration = nil
  self.toneMappingTexture = nil
  self:_CFQuit()
end

function CameraFilterProxy:_CFQuit()
  if self.updateDepthOfField_ltId then
    LeanTween.cancel(LeanTween.tweenEmpty, self.updateDepthOfField_ltId)
  end
  self.updateDepthOfField_ltId = nil
  if self.HasInitCamera == true then
    PpLua:Destory()
    FunctionPerformanceSetting.Me():ApplyAntiRateSetting()
  end
  self.HasInitCamera = false
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  if self.timeCallDelete then
    self.timeCallDelete:Destroy()
    self.timeCallDelete = nil
  end
  RenderingManager.Instance:SetCustomLutTexture(nil)
end

function CameraFilterProxy:SetForbidPlayerOperation(reason, isForbid)
  if not reason then
    LogUtility.Error("CameraFilterProxy.SetForbidPlayerOperation param: reason cannot be nil!")
    return
  end
  self.forbidPlayerOperationReasons[reason] = isForbid and true or nil
end

function CameraFilterProxy:IsForbidPlayerOperation()
  local reason = next(self.forbidPlayerOperationReasons)
  return reason ~= nil
end

function CameraFilterProxy:Init()
  self.forbidPlayerOperationReasons = {}
end

function CameraFilterProxy:Pause()
  self.pausing = self.pausing + 1
  self:_CFQuit()
end

function CameraFilterProxy:Resume()
  self.pausing = self.pausing - 1
  if self.nameOfEffect ~= nil then
    self:_CFSetEffectAndSpEffect(self.nameOfEffect, self.nameOfSpEffect, self.updateDepthOfField_duration, self.effect_duration, self.toneMappingTexture)
  end
end

return CameraFilterProxy
