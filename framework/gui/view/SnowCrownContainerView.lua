SnowCrownContainerView = class("SnowCrownContainerView", ContainerView)
SnowCrownContainerView.ViewType = UIViewType.NormalLayer
SnowCrownContainerView.TogglePageNameMap = {
  CrownCustomTab = "CrownCustomPage",
  AreaAttrTab = "SnowCrownAreaAttrPage",
  CrownAccessoriesTab = "CrownAccessoriesPage"
}
SnowCrownContainerView.ModelPosition = {
  FashionCustom = -190,
  NodeDetail = -80,
  Default = 0
}
local _TabNamePrefix = "SnowCrownContainer_TabName_"
local _Single_Tab_Width = 160
local rotVec = LuaVector3.Zero()
local rotationQuatY = LuaQuaternion.Identity()
local rotationQuatZ = LuaQuaternion.Identity()
local vec_right = LuaVector3.New(1, 0, 0)
local vec_up = LuaVector3.Up()

function SnowCrownContainerView:Init()
  self.pageContainer = self:FindGO("PageContainer")
  if not self.pageContainer then
    LogUtility.Error("Cannot find PageContainer!")
    return
  end
  self.tabLineBg = self:FindComponent("TabLineBg", UISprite)
  self.tabGrid = self:FindComponent("Tabs", UIGrid)
  self.crown_tab_count = 0
  for tabName, pageName in pairs(self.TogglePageNameMap) do
    self[tabName] = self:FindGO(tabName, self.tabGrid.gameObject)
    if self[tabName] then
      self:Hide(self[tabName])
    end
  end
  for toggleName, pageName in pairs(self.TogglePageNameMap) do
    self:FindAndAddToggle(toggleName, pageName)
  end
  self.tabGrid:Reposition()
  if self.tabLineBg then
    self.tabLineBg.width = self.crown_tab_count * _Single_Tab_Width
  end
  self:InitModelTexture()
  self:AddEvents()
  self:AddOrRemoveGuideId("CloseButton", 560)
end

function SnowCrownContainerView:FindAndAddToggle(toggleName, pageName)
  local toggleGO = self:FindGO(toggleName)
  self:Show(toggleGO)
  self.crown_tab_count = self.crown_tab_count + 1
  self:SetTogName("Label1", toggleGO, toggleName)
  self:SetTogName("Label2", toggleGO, toggleName)
  self:AddClickEvent(toggleGO, function(go)
    self:SwitchToPage(self.TogglePageNameMap[go.name])
  end)
  self.toggleMap = self.toggleMap or {}
  local toggle = toggleGO:GetComponent(UIToggle)
  if toggle then
    self.toggleMap[pageName] = toggle
  end
  if toggleName == "AreaAttrTab" then
    self:AddOrRemoveGuideId(toggleGO, 558)
  end
  return toggle
end

function SnowCrownContainerView:SetTogName(compName, toggleGO, toggleName)
  local togName1 = self:FindComponent(compName, UILabel, toggleGO)
  if togName1 and ZhString[_TabNamePrefix .. toggleName] then
    togName1.text = ZhString[_TabNamePrefix .. toggleName]
  end
end

function SnowCrownContainerView:TryLoadSubview(page_name)
  if not self.viewMap or not self.viewMap[page_name] then
    autoImport(page_name)
    self:AddSubView(page_name, _G[page_name])
  end
end

function SnowCrownContainerView:SwitchToPage(page_name)
  local toggle = self.toggleMap[page_name]
  if toggle then
    toggle.value = true
  end
  self:TryLoadSubview(page_name)
  local isActive
  for pageName, pageClass in pairs(self.viewMap) do
    isActive = pageName == page_name
    pageClass.gameObject:SetActive(isActive)
    if isActive then
      self.activePageName = pageName
      if pageClass.OnActivate then
        pageClass:OnActivate()
      end
    end
    if not isActive and pageClass.OnDeactivate then
      pageClass:OnDeactivate()
    end
  end
  self:UpdateModelTextureByPage(page_name)
end

function SnowCrownContainerView:UpdateModelTextureByPage(page_name)
  if not self.modelTexture then
    return
  end
  if page_name == "CrownAccessoriesPage" then
    self:HideModelTexture()
    self:UpdateBGEffectVisibility()
  elseif page_name == "SnowCrownAreaAttrPage" then
    self:ShowModelTexture()
    self:TweenModelTexturePosition(SnowCrownContainerView.ModelPosition.Default)
  elseif page_name == "CrownCustomPage" then
    self:ShowModelTexture()
    self:TweenModelTexturePosition(SnowCrownContainerView.ModelPosition.Default)
  end
end

function SnowCrownContainerView:HideModelTexture()
  if self.modelTexture then
    self.modelTexture.gameObject:SetActive(false)
  end
end

function SnowCrownContainerView:ShowModelTexture()
  if self.modelTexture then
    self.modelTexture.gameObject:SetActive(true)
  end
end

function SnowCrownContainerView:OnEnter()
  SnowCrownContainerView.super.OnEnter(self)
  local targetPageName = self.viewdata.viewdata and self.viewdata.viewdata.page
  targetPageName = targetPageName or self:GetDefaultPageName()
  self:SwitchToPage(targetPageName)
  if self.uiMediator then
    local mediatorName = self.uiMediator.mediatorName or self.__cname
    GameFacade.Instance:removeMediator(mediatorName)
    self.uiMediator:SetView(self)
    GameFacade.Instance:registerMediator(self.uiMediator)
  else
    self.uiMediator = UIMediator.new(self.__cname, self)
    GameFacade.Instance:registerMediator(self.uiMediator)
  end
  self:PlayBGEffect()
end

function SnowCrownContainerView:PlayBGEffect()
  if self.modelEffectContainer and not self.bgEffectAsset then
    self:PlayUIEffect(EffectMap.UI.SnowGem_BG, self.modelEffectContainer, false, function(obj, args, assetEffect)
      self.bgEffectAsset = assetEffect
      self:UpdateBGEffectVisibility()
    end)
  end
end

function SnowCrownContainerView:UpdateBGEffectVisibility()
  if not self.bgEffectAsset then
    return
  end
  local shouldShow = self.activePageName == "CrownCustomPage" and self.currentModelPosition == SnowCrownContainerView.ModelPosition.Default
  self.bgEffectAsset:SetActive(shouldShow)
end

function SnowCrownContainerView:OnExit()
  self:ClearModelEffect()
  if self.modelTexture then
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
    LeanTween.cancel(self.modelTexture.gameObject)
    if self.modelTextureTweener then
      self.modelTextureTweener.enabled = false
      self.modelTextureTweener = nil
    end
  end
  self.UIModel = nil
  self.currentEffectPath = nil
  self.bgEffectAsset = nil
  self.currentModelPosition = nil
  if self.uiMediator then
    GameFacade.Instance:removeMediator(self.uiMediator.mediatorName)
  end
  SnowCrownContainerView.super.OnExit(self)
end

function SnowCrownContainerView:GetDefaultPageName()
  return self.TogglePageNameMap.CrownCustomTab
end

function SnowCrownContainerView:AddEvents()
  self:AddListenEvt(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, self.OnSnowHeadQuerySnowCmd)
end

function SnowCrownContainerView:OnSnowHeadQuerySnowCmd()
end

function SnowCrownContainerView:InitModelTexture()
  self.modelTexture = self:FindComponent("ModelTexture", UITexture)
  self.modelEffectContainer = self:FindGO("BGEffectContainer", self.modelTexture.gameObject)
  if self.modelTexture then
    self.lastDeltaX = 0
    self.lastDeltaY = 0
    self.lastRotateTime = Time.time
    self.rotateSpeed = 0.5
    self.defaultBodyId = 45563
    self.UIModel = nil
    self.modelTextureTweenDuration = 0.3
    self:AddDragEvent(self.modelTexture.gameObject, function(obj, delta)
      self:TryRotate(delta.x, delta.y)
    end)
    self:AddPressEvent(self.modelTexture.gameObject, function(g, b)
      if b == false and Time.time - self.lastRotateTime < 0.15 and math.abs(self.lastDeltaX) > 10 then
        LeanTween.value(self.modelTexture.gameObject, function(v)
          local rsx = 0.5
          local smoothX = self.lastDeltaX * 0.5 * v
          if self.UIModel then
            local transform = self.UIModel:GetTransform()
            if transform then
              rotationQuatY = Quaternion.AngleAxis(-smoothX * self.rotateSpeed * rsx, vec_up)
              transform.localRotation = rotationQuatY * transform.localRotation
            end
          end
        end, 1, 0, 0.5)
      end
    end)
    self:InitModel()
  end
end

function SnowCrownContainerView:InitModel()
  if not self.modelTexture then
    return
  end
  self:SetModelByEquippedFashion()
end

function SnowCrownContainerView:SetModelByEquippedFashion()
  if not self.modelTexture then
    return
  end
  local equippedIndex1 = SnowCrownProxy.Instance:GetEquippedFashionIdByPos(1)
  local equippedIndex2 = SnowCrownProxy.Instance:GetEquippedFashionIdByPos(2)
  local equippedIndex3 = SnowCrownProxy.Instance:GetEquippedFashionIdByPos(3)
  local bodyId = self.defaultBodyId
  local effectPath
  if SnowCrownProxy.CheckFashionIndexesSameGroup(equippedIndex1, equippedIndex2, equippedIndex3) then
    bodyId = SnowCrownProxy.ResolveFashionBody(equippedIndex1, equippedIndex2) or bodyId
    effectPath = SnowCrownProxy.ResolveFashionEffect(equippedIndex3, true)
  end
  xdlog("SetModelByEquippedFashion", equippedIndex1, equippedIndex2, equippedIndex3, bodyId, effectPath)
  self:SetModelBody(bodyId, effectPath)
end

function SnowCrownContainerView:SetModelBody(bodyId, effectPath)
  if not self.modelTexture then
    return
  end
  bodyId = bodyId or self.defaultBodyId
  if self.modelId and self.modelId == bodyId and self.currentEffectPath == effectPath then
    return
  end
  xdlog("SetModelBody", bodyId, effectPath)
  self:ClearModelEffect()
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  self.currentEffectPath = effectPath
  if bodyId then
    UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
    local partIndex = ItemUtil.getItemRolePartIndex(bodyId)
    if not partIndex or partIndex == 0 then
      partIndex = Asset_Role.PartIndex.Body
    end
    self.modelId = bodyId
    UIModelUtil.Instance:SetRolePartModelTexture(self.modelTexture, partIndex, bodyId, nil, function(rolePart, id, assetRolePart)
      if not assetRolePart then
        return
      end
      self.UIModel = assetRolePart
      if assetRolePart.ResetLocalPositionXYZ then
        assetRolePart:ResetLocalPositionXYZ(-0.32, 0.46, 1)
      elseif assetRolePart.ResetLocalPosition then
        assetRolePart:ResetLocalPosition(LuaGeometry.GetTempVector3(-0.32, 0.46, 1))
      end
      local size = 1
      if assetRolePart.ResetLocalScale then
        assetRolePart:ResetLocalScale(LuaGeometry.GetTempVector3(size, size, size))
      elseif assetRolePart.ResetLocalScaleXYZ then
        assetRolePart:ResetLocalScaleXYZ(size, size, size)
      end
      self:ResetModelRotation()
      if effectPath then
        self:LoadAndAttachEffect(effectPath, assetRolePart)
      end
    end, bodyId)
  end
end

function SnowCrownContainerView:LoadAndAttachEffect(effectPath, assetRolePart)
  if not effectPath or not assetRolePart then
    return
  end
  local modelTransform = assetRolePart:GetTransform()
  if not modelTransform then
    xdlog("LoadAndAttachEffect | modelTransform is nil")
    return
  end
  local modelGO = modelTransform.gameObject
  if not modelGO then
    xdlog("LoadAndAttachEffect | modelGO is nil")
    return
  end
  local fullEffectPath = "Public/Effect/" .. effectPath
  local effectGO = Game.AssetManager_UI:CreateAsset(fullEffectPath, modelGO)
  if effectGO then
    self.modelEffectGO = effectGO
    effectGO.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    effectGO.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    effectGO.transform.localRotation = Quaternion.identity
    xdlog("LoadAndAttachEffect | success", fullEffectPath)
  else
    xdlog("LoadAndAttachEffect | failed to load effect", fullEffectPath)
  end
end

function SnowCrownContainerView:ClearModelEffect()
  if self.modelEffectGO then
    GameObject.Destroy(self.modelEffectGO)
    self.modelEffectGO = nil
  end
end

function SnowCrownContainerView:ResetModelRotation()
  if self.UIModel then
    if self.UIModel.ResetLocalEulerAngles then
      self.UIModel:ResetLocalEulerAngles(LuaVector3.Zero())
    elseif self.UIModel.SetEulerAngles then
      self.UIModel:SetEulerAngles(LuaVector3.Zero())
    end
  end
end

function SnowCrownContainerView:TryRotate(x, y)
  if not self.UIModel then
    return
  end
  local rsx = 0.5
  self.lastDeltaX = x
  self.lastDeltaY = y
  self.lastRotateTime = Time.time
  local transform = self.UIModel:GetTransform()
  if transform then
    rotationQuatY = Quaternion.AngleAxis(-x * self.rotateSpeed * rsx, vec_up)
    transform.localRotation = rotationQuatY * transform.localRotation
  end
end

function SnowCrownContainerView:TweenModelTexturePosition(targetPosition, duration)
  if not self.modelTexture then
    return
  end
  if self.modelTextureTweener then
    self.modelTextureTweener.enabled = false
    self.modelTextureTweener = nil
  end
  local targetX = targetPosition or SnowCrownContainerView.ModelPosition.Center
  local tweenDuration = duration or self.modelTextureTweenDuration
  self.currentModelPosition = targetX
  local currentPos = self.modelTexture.gameObject.transform.localPosition
  local targetPos = LuaGeometry.GetTempVector3(targetX, currentPos.y, currentPos.z)
  self.modelTextureTweener = TweenPosition.Begin(self.modelTexture.gameObject, tweenDuration, targetPos)
  if self.modelTextureTweener then
    self.modelTextureTweener.method = 2
  end
  self:UpdateBGEffectVisibility()
end
