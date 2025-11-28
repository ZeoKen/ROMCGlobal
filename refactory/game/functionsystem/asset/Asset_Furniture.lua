Asset_Furniture = class("Asset_Furniture")
autoImport("HomeRewardCell")
local m_clickTime = 0.15
local m_furnitureBaseHeight = 0.05
local tmpVector3 = LuaVector3(0, 0, 0)
local GetTempVector3 = function(x, y, z, tarVector)
  tarVector = tarVector or tmpVector3
  LuaVector3.Better_Set(tarVector, x, y, z)
  return tarVector
end
local tmpColor = LuaColor(1, 1, 1, 1)
local GetTempColor = function(r, g, b, a, tarColor)
  tarColor = tarColor or tmpColor
  LuaColor.Better_Set(tarColor, r, g, b, a)
  return tarColor
end

function Asset_Furniture:ctor(staticId, parent, callback)
  self.staticId = staticId
  self.staticData = Table_HomeFurniture[self.staticId]
  local actionData = self.staticData and self.staticData.IdleAction and Table_ActionAnime[self.staticData.IdleAction]
  self.animName_Idle = actionData and actionData.Name
  self.baseHeight = m_furnitureBaseHeight
  self.tabRenderers = {}
  self.defaultEffectMap = {}
  self.tabTsfPoints = {}
  self.alive = true
  self:ReloadAsset(parent, callback)
end

function Asset_Furniture:ReloadAsset(parent, callback)
  if not self.staticId then
    return
  end
  Game.AssetManager_Furniture:CreateFurniture(self.staticId, parent, function(obj)
    if not self.alive then
      return
    end
    if not obj then
      LogUtility.Error(string.format("加载家具ID：%s 失败！", tostring(self.staticId)))
      return
    end
    local objFurniture = obj
    self.gameObject = objFurniture
    self.instanceID = self.gameObject:GetInstanceID()
    self.trans = objFurniture.transform
    self.collider = self.gameObject:GetComponentInChildren(BoxCollider)
    self.objCollider = self.collider and self.collider.gameObject
    self.animator = self.objCollider:GetComponent(Animator)
    self:ClearDefaultEffects()
    TableUtility.TableClear(self.tabRenderers)
    TableUtility.TableClear(self.tabTsfPoints)
    local l_renderers = self.gameObject:GetComponentsInChildren(Renderer)
    local singleRenderer, mrMatetial, isTransparent
    for i = 1, #l_renderers do
      singleRenderer = l_renderers[i]
      if singleRenderer.name == "shadow" then
        self.objShadow = singleRenderer.gameObject
      elseif singleRenderer.name == "shadow_side" then
        self.objSideShadow = singleRenderer.gameObject
      elseif AssetManager_Furniture.IsFurnitureBody(singleRenderer) then
        mrMatetial = singleRenderer.material
        isTransparent = mrMatetial.shader.name == AssetManager_Furniture.TransparentShaderName
        if isTransparent then
          mrMatetial:SetInt("_SrcBlend", 5)
          mrMatetial:SetInt("_DstBlend", 10)
        end
        self.tabRenderers[#self.tabRenderers + 1] = {
          gameObject = singleRenderer.gameObject,
          renderer = singleRenderer,
          material = mrMatetial,
          isTransparent = isTransparent,
          defaultAlpha = isTransparent and mrMatetial.color.a or 1,
          defaultRenderQueue = isTransparent and AssetManager_Furniture.RenderQueueTransparent or AssetManager_Furniture.RenderQueueOpaque
        }
      end
    end
    self.curAlpha = 1
    self.isTransparent = false
    self.isShadowHide = false
    local defaultEffects = self.staticData and self.staticData.FurnitureEffect
    if defaultEffects then
      local effect, effectPath
      for rootName, effectName in pairs(defaultEffects) do
        effectPath = "Common/" .. effectName
        effect = self:PlayEffectOnRoot(effectPath, rootName ~= "root" and self:FindChild(rootName) or nil)
        if effect then
          self.defaultEffectMap[#self.defaultEffectMap + 1] = effect
        else
          redlog(string.format("%s: 在%s下创建特效%s失败"), tostring(self.staticData and self.staticData.NameZh), tostring(rootName), tostring(effectPath))
        end
      end
    end
    if callback then
      callback(self)
    end
  end)
end

function Asset_Furniture:SetBaseHeightLv(lv)
  self.baseHeight = m_furnitureBaseHeight + 1.0E-5 * (lv % 1000)
end

function Asset_Furniture:GetInstanceID()
  return self.instanceID
end

function Asset_Furniture:SetName(name)
  self.gameObject.name = name
end

function Asset_Furniture:SetActive(isActive)
  if self.isActive ~= isActive then
    self.gameObject:SetActive(isActive == true)
    self.isActive = isActive
  end
end

function Asset_Furniture:SetLayer(layer)
  NGUITools.SetLayer(self.gameObject, layer)
end

function Asset_Furniture:SetColliderName(name)
  self.objCollider.name = name
end

function Asset_Furniture:SetColliderLayer(layer)
  self.objCollider.layer = layer
end

function Asset_Furniture:SetColliderTag(tag)
  self.objCollider.tag = tag
end

function Asset_Furniture:SetColliderEnable(enable)
  self.collider.enabled = enable
end

function Asset_Furniture:SetParent(p, worldPositionStays)
  self.trans:SetParent(p, worldPositionStays or false)
  if not worldPositionStays then
    self:_AdjustPosition()
  end
end

function Asset_Furniture:SetPosition(p)
  p.y = p.y + self.baseHeight
  self.trans.position = p
end

function Asset_Furniture:SetPositionXYZ(x, y, z)
  y = y + self.baseHeight
  self.trans.position = GetTempVector3(x, y, z)
end

function Asset_Furniture:SetLocalPosition(p)
  self.trans.localPosition = p
  self:_AdjustPosition()
end

function Asset_Furniture:SetLocalPositionXYZ(x, y, z)
  self.trans.localPosition = GetTempVector3(x, y, z)
  self:_AdjustPosition()
end

function Asset_Furniture:_AdjustPosition()
  local x, y, z = self:GetPositionXYZ()
  y = y + self.baseHeight
  self.trans.position = GetTempVector3(x, y, z)
end

function Asset_Furniture:SetLocalRotation(quaternion)
  self.trans.localRotation = quaternion
end

function Asset_Furniture:SetLocalEulerAngles(p)
  self.trans.localEulerAngles = p
end

function Asset_Furniture:SetLocalEulerAnglesXYZ(x, y, z)
  self.trans.localEulerAngles = GetTempVector3(x, y, z)
end

function Asset_Furniture:SetLocalEulerAngleY(y)
  self.trans.localEulerAngles = GetTempVector3(0, y, 0)
end

function Asset_Furniture:SetEulerAngles(p)
  self.trans.eulerAngles = p
end

function Asset_Furniture:SetEulerAngleY(y)
  self.trans.eulerAngles = GetTempVector3(0, y, 0)
end

function Asset_Furniture:SetScale(scale)
  self.trans.localScale = GetTempVector3(scale, scale, scale)
end

function Asset_Furniture:SetScaleXYZ(x, y, z)
  self.trans.localScale = GetTempVector3(x, y, z)
end

function Asset_Furniture:RotateTo(p)
  LuaGameObject.LocalRotateToByAxisY(self.trans, p)
end

function Asset_Furniture:RotateDelta(delta)
  LuaGameObject.LocalRotateDeltaByAxisY(self.trans, delta)
end

function Asset_Furniture:IsColliderEnable()
  return self.objCollider.enabled
end

function Asset_Furniture:IsMyColliderObj(gameObject)
  return gameObject ~= nil and self.objCollider == gameObject
end

function Asset_Furniture:GetPositionXYZ()
  return LuaGameObject.GetPosition(self.trans)
end

function Asset_Furniture:GetEulerAnglesXYZ()
  return LuaGameObject.GetEulerAngles(self.trans)
end

function Asset_Furniture:GetEulerAnglesY()
  local x, y, z = self:GetEulerAnglesXYZ()
  return y
end

function Asset_Furniture:GetLocalEulerAnglesXYZ()
  return LuaGameObject.GetLocalEulerAngles(self.trans)
end

function Asset_Furniture:GetLocalEulerAngleY()
  local x, y, z = self:GetLocalEulerAnglesXYZ()
  return y
end

function Asset_Furniture:GetScaleXYZ()
  return LuaGameObject.GetScale(self.trans)
end

function Asset_Furniture:TransformPoint(p, ret)
  ret:Set(LuaGameObject.TransformPoint(self.trans, p))
end

function Asset_Furniture:InverseTransformPoint(p, ret)
  ret:Set(LuaGameObject.InverseTransformPointByVector3(self.trans, p))
end

local tempPlayActionParams = {
  [1] = nil,
  [2] = nil,
  [3] = 1,
  [4] = 0,
  [5] = 0,
  [6] = false,
  [7] = 0
}

function Asset_Furniture.GetPlayActionParams(name, defaultName, speed, crossFadeNormalizedDuration, force)
  tempPlayActionParams[1] = name
  tempPlayActionParams[2] = defaultName or name
  tempPlayActionParams[3] = speed or 1
  tempPlayActionParams[4] = 0
  tempPlayActionParams[5] = crossFadeNormalizedDuration or 0
  tempPlayActionParams[6] = force == true
  return tempPlayActionParams
end

function Asset_Furniture:IsPlayingActionRaw(name)
  return self.actionRaw == name
end

function Asset_Furniture:HasActionRaw(name)
  return self:HasActionRawByHash(ActionUtility.GetNameHash(name))
end

function Asset_Furniture:HasActionRawByHash(hash)
  return self.animator:HasState(0, hash)
end

function Asset_Furniture:PlayActionRaw(params)
  if not params[6] and self.actionRaw == params[1] then
    return
  end
  local name = params[1]
  if nil == name or "" == name then
    name = self.animName_Idle
    redlog("家具：%s尝试播放动画名为空，改为播放idle动画", self.staticId)
  end
  local defaultName = params[2]
  if nil == defaultName or "" == defaultName then
    defaultName = self.animName_Idle
  end
  if nil ~= params[3] then
    self.actionSpeed = params[3]
  elseif nil == self.actionSpeed then
    self.actionSpeed = 1
  end
  local nameHash = ActionUtility.GetNameHash(name)
  local defaultNameHash = ActionUtility.GetNameHash(defaultName)
  local animHash
  if self:HasActionRawByHash(nameHash) then
    animHash = nameHash
    self.actionRaw = name
  elseif self:HasActionRawByHash(defaultNameHash) then
    animHash = defaultNameHash
    self.actionRaw = defaultName
  else
    LogUtility.Error(string.format("Do Not Have Action: %s and %s", tostring(name), tostring(defaultName)))
    return
  end
  if params[5] > 0 then
    self.animator:CrossFade(animHash, params[5], 0, params[4] or 0)
  else
    self.animator:Play(animHash, 0, params[4] or 0)
  end
  self.animator.speed = self.actionSpeed
  self:PlayActionEffect(self.actionRaw)
end

function Asset_Furniture:PlayAction(params)
  if not self.animator then
    return
  end
  self:PlayActionRaw(params)
end

function Asset_Furniture:PlayAction_Simple(name, defaultName, speed, crossFadeNormalizedDuration, force)
  self:PlayAction(Asset_Furniture.GetPlayActionParams(name, defaultName, speed, crossFadeNormalizedDuration, force))
end

function Asset_Furniture:PlayActionEffect(action)
  if self.curAnimEffect and self.curAnimEffect:Alive() then
    self.curAnimEffect:Destroy()
  end
  self.curAnimEffect = nil
  local bodyID = 0
  if 0 < bodyID then
    local configs = Game.Config_ActionEffect[bodyID]
    if configs == nil then
      return
    end
    for i = 1, #configs do
      local config = Table_ActionEffect[configs[i]]
      if config ~= nil and config.NameAction == action then
        local effectConfig = Table_ActionEffectSetUp[config.EffectID]
        if effectConfig ~= nil then
          if effectConfig.Loop == 1 then
            if effectConfig.EPFollow == 1 then
              self.curAnimEffect = self:PlayEffectOn(effectConfig.Path, effectConfig.EPID)
            else
              self.curAnimEffect = self:PlayEffectAt(effectConfig.Path, effectConfig.EPID)
            end
          elseif effectConfig.EPFollow == 1 then
            self:PlayEffectOneShotOn(effectConfig.Path, effectConfig.EPID)
          else
            self:PlayEffectOneShotAt(effectConfig.Path, effectConfig.EPID)
          end
        end
      end
    end
  end
end

function Asset_Furniture:PlayEffectOneShotAt(path, epID, offset, callback, callbackArg)
  local playPos = GetTempVector3(LuaGameObject.GetPosition(self:GetCP(epID) or self.trans))
  if nil ~= offset then
    playPos:Add(offset)
  end
  return Asset_Effect.PlayOneShotAt(path, playPos, callback, callbackArg)
end

function Asset_Furniture:PlayEffectOneShotOn(path, epID, offset, callback, callbackArg)
  local effect = Asset_Effect.PlayOneShotOn(path, self:GetCP(epID) or self.trans, callback, callbackArg)
  if nil ~= offset then
    effect:ResetLocalPosition(offset)
  end
  return effect
end

function Asset_Furniture:PlayEffectAt(path, epID, offset, callback, callbackArg)
  local epTransform = self:GetCP(epID)
  if nil ~= epTransform then
    local x, y, z = LuaGameObject.GetPosition(epTransform)
    return Asset_Effect.PlayAtXYZ(path, x, y, z, callback, callbackArg)
  else
    return Asset_Effect.PlayAtXYZ(path, LuaGameObject.GetPosition(self.trans))
  end
end

function Asset_Furniture:PlayEffectOn(path, epID, offset, callback, callbackArg)
  return self:PlayEffectOnRoot(path, self:GetCP(epID), callback, callbackArg)
end

function Asset_Furniture:PlayEffectOnRoot(path, tsfRoot, offset, callback, callbackArg)
  local effect = Asset_Effect.PlayOn(path, tsfRoot or self.trans, callback, callbackArg)
  if nil ~= offset then
    effect:ResetLocalPosition(offset)
  end
  return effect
end

function Asset_Furniture:PlaySEOneShotOn(path, atype)
  local clip = AudioUtility.GetAudioClip(path)
  AudioHelper.PlayOneShotAt(clip, LuaGameObject.GetPosition(self.trans), atype or AudioSourceType.ONESHOTSE)
end

function Asset_Furniture:PlaySEOn(path, atype)
  local clip = AudioUtility.GetAudioClip(path)
  AudioHelper.Play_At(clip, LuaGameObject.GetPosition(self.completeTransform), 0, atype or AudioSourceType.ONESHOTSE)
end

function Asset_Furniture:GetCP(cpID)
  return self:FindChild("CP_" .. cpID)
end

function Asset_Furniture:FindChild(name)
  if self.tabTsfPoints[name] then
    return self.tabTsfPoints[name]
  end
  local obj = Game.GameObjectUtil:DeepFind(self.gameObject, name)
  if not obj then
    LogUtility.Error(string.format("在家具ID: %s(%s)下没有找到子节点: %s", tostring(self.staticId), tostring(self.staticData and self.staticData.NameZh), tostring(name)))
  end
  local tsf = obj and obj.transform or self.trans
  self.tabTsfPoints[name] = tsf
  return tsf
end

function Asset_Furniture:PlayClickEffect()
  self:CancelLtClick()
  for i = 1, #self.tabRenderers do
    self.tabRenderers[i].material:SetColor("_BrightColor", GetTempColor(0.3137254901960784, 0.3137254901960784, 0.3137254901960784, 1))
  end
  self.ltClick = TimeTickManager.Me():CreateOnceDelayTick(m_clickTime * 1000, function(owner, deltaTime)
    self:CancelClick()
    self.ltClick = nil
  end, self)
end

function Asset_Furniture:CancelClick()
  for i = 1, #self.tabRenderers do
    self.tabRenderers[i].material:SetColor("_BrightColor", GetTempColor(0, 0, 0, 1))
  end
end

function Asset_Furniture:CancelLtClick()
  if not self.ltClick then
    return
  end
  self.ltClick:Destroy()
  self.ltClick = nil
end

function Asset_Furniture:ShowShadow(isShowShadow)
  if self.objShadow and self.isShadowShow ~= isShowShadow then
    self.isShadowShow = isShowShadow
    self.objShadow:SetActive(self.isShadowShow == true)
  end
  self:RefreshSideShadowStatus()
end

function Asset_Furniture:ShowSideShadow(isShadowShow)
  self.isShadowSideActive = isShadowShow
  self:RefreshSideShadowStatus()
end

function Asset_Furniture:RefreshSideShadowStatus()
  local isActive = not self.isTransparent and self.isShadowSideActive
  if self.objSideShadow and self.isShadowSideShow ~= isActive then
    self.isShadowSideShow = isActive
    self.objSideShadow:SetActive(self.isShadowSideShow == true)
  end
end

function Asset_Furniture:SetAlpha(alpha)
  if self.curAlpha == alpha then
    return
  end
  local containsAlpha = alpha < 1
  for i = 1, #self.tabRenderers do
    local singleMR = self.tabRenderers[i]
    local tweeen = singleMR.gameObject:GetComponent(TweenAlpha)
    if tweeen and tweeen.enabled then
      GameObject.DestroyImmediate(tweeen)
    end
    if not singleMR.isTransparent and self.isTransparent ~= containsAlpha then
      singleMR.gameObject.layer = containsAlpha and Game.ELayer.Default or Game.ELayer.Outline
      local singleMRCallBack = self.tabRenderers[i]
      if singleMRCallBack.isTransparent or containsAlpha then
        singleMRCallBack.material.color = GetTempColor(1, 1, 1, alpha * singleMRCallBack.defaultAlpha)
        singleMRCallBack.material.renderQueue = singleMRCallBack.defaultRenderQueue
      end
    elseif singleMR.isTransparent or containsAlpha then
      singleMR.material.color = GetTempColor(1, 1, 1, alpha * singleMR.defaultAlpha)
      singleMR.material.renderQueue = singleMR.defaultRenderQueue
    end
  end
  self.isTransparent = containsAlpha
  self.curAlpha = alpha
  self:ShowShadow(not containsAlpha)
end

function Asset_Furniture:AlphaTo(alpha, duration)
  if self.curAlpha == alpha or #self.tabRenderers < 1 then
    return
  end
  self.isTransparent = true
  self:ShowShadow(false)
  for i = 1, #self.tabRenderers do
    local singleMR = self.tabRenderers[i]
    if not singleMR.isTransparent then
      singleMR.gameObject.layer = Game.ELayer.Default
      local singleMRCallBack = self.tabRenderers[i]
      self:AlphaToTween(alpha, duration, singleMRCallBack)
    else
      self:AlphaToTween(alpha, duration, singleMR)
    end
  end
end

function Asset_Furniture:AlphaToTween(alpha, duration, singleMR)
  TweenAlpha.Begin(singleMR.gameObject, duration, alpha * singleMR.defaultAlpha):SetOnFinished(function()
    if alpha < 1 then
      return
    end
    if not singleMR.isTransparent then
      singleMR.gameObject.layer = Game.ELayer.Outline
      self.isTransparent = false
      self.curAlpha = alpha
      self:ShowShadow(true)
    else
      self.isTransparent = false
      self.curAlpha = alpha
      self:ShowShadow(true)
    end
  end)
end

function Asset_Furniture:ClearDefaultEffects()
  for index, effect in pairs(self.defaultEffectMap) do
    if effect and effect:Alive() then
      effect:Destroy()
    end
  end
  TableUtility.TableClear(self.defaultEffectMap)
end

function Asset_Furniture:CreateReward(parent)
  self:ClearReward()
  local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.RoleTopInfo)
  local objRewarcCell = Game.AssetManager_UI:CreateSceneUIAsset(HomeRewardCell.ResID, container)
  if objRewarcCell == nil then
    LogUtility.Error("can not find cellpfb: " .. tostring(HomeRewardCell.ResID))
  else
    objRewarcCell.name = "HomeRewardCell_" .. self.gameObject.name
    objRewarcCell.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.rewardCell = HomeRewardCell.new(objRewarcCell)
    self.rewardCell:SetParent(self)
  end
  return self.rewardCell
end

function Asset_Furniture:ClearReward()
  if self.rewardCell and self.rewardCell.gameObject then
    LuaGameObject.DestroyObject(self.rewardCell.gameObject)
  end
  self.rewardCell = nil
end

function Asset_Furniture:Destroy(delayDestroy)
  self.alive = false
  self:CancelLtClick()
  self:ClearDefaultEffects()
  self:ClearReward()
  self.instanceID = nil
  if self.gameObject then
    self:CancelClick()
    if delayDestroy then
      HomeManager.Me():_AddObjToDestroyList(self.gameObject)
    else
      Game.AssetManager_Furniture:DestroyFurniture(self.gameObject)
    end
    return true
  end
end

function Asset_Furniture:DoConstruct(asArray, parts)
end

function Asset_Furniture:DoDeconstruct(asArray)
end

function Asset_Furniture:RegisterWeakObserver(obj)
end

function Asset_Furniture:UnregisterWeakObserver(obj)
end
