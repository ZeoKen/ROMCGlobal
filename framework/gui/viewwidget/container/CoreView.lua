autoImport("EventDispatcher")
CoreView = class("CoreView", EventDispatcher)
CoreView.OpenLog = true
CoreView.RotateCamera = true
autoImport("UIPlayerSceneInfo")
local lastClickEventTime = 0

function CoreView:ctor(go)
  self.gameObject = go
  if go ~= nil then
    self.trans = go.transform
  end
  self.effectCache = {}
  self:AddHelpButtonEvent()
end

function CoreView:AddGameObjectComp()
  if self.gameObject then
    local comp = Game.GameObjectUtil:GetOrAddComponent(self.gameObject, GameObjectForLua)
    
    function comp.onEnable(go)
      self:OnEnable()
    end
    
    function comp.onDisable(go)
      self:OnDisable()
    end
    
    function comp.onDestroy(go)
      self:OnDestroy()
    end
    
    self.gameObjectComp = comp
  end
end

function CoreView:AddHelpButtonEvent()
  local go = self:FindGO("HelpButton")
  if go then
    self:AddClickEvent(go, function(g)
      self:OpenHelpView()
    end)
  end
end

function CoreView:RegistShowGeneralHelpByHelpID(id, obj, active)
  local staticData = self:Preprocess_HelpColiderObj(id, obj, active)
  if staticData then
    self:AddClickEvent(obj, function()
      TipsView.Me():ShowGeneralHelp(staticData.Desc, staticData.Title)
    end)
  end
end

function CoreView:FillTextByHelpId(id, label)
  if not label then
    return
  end
  local staticData = self:Preprocess_HelpColiderObj(id, label.gameObject)
  if staticData then
    label.text = staticData.Desc
  end
end

function CoreView:Preprocess_HelpColiderObj(id, obj, active)
  if not obj then
    return
  end
  local staticData = id and Table_Help[id]
  if not staticData or StringUtil.IsEmpty(staticData.Desc) then
    obj:SetActive(false)
    redlog("------------------------------帮助按钮隐藏，未配置HelpID： ", id)
    return
  end
  if active == false then
    obj:SetActive(false)
    return
  end
  obj:SetActive(true)
  return staticData
end

function CoreView:TryOpenHelpViewById(id, depth_delta, obj, active)
  if type(obj) ~= "userdata" and type(depth_delta) == "userdata" then
    obj = depth_delta
    depth_delta = nil
  end
  local staticData = self:Preprocess_HelpColiderObj(id, obj, active)
  if staticData then
    self:AddClickEvent(obj, function()
      self:OpenHelpView(staticData, depth_delta)
    end)
  end
end

function CoreView:OpenHelpView(data, depth_delta)
  if data == nil then
    data = Table_Help[self.viewdata.view.id]
  end
  if self.m_helpId then
    data = Table_Help[self.m_helpId]
    if not data then
      LogUtility.Error(string.format("[%s] OpenHelpView() Error : self.m_helpId == %s is not exist in Table_Help!", self.__cname, self.m_helpId))
    end
  end
  if data then
    if depth_delta then
      local panel = self.gameObject:GetComponent(UIPanel)
      if panel then
        TipsView.Me():ShowGeneralHelp(data.Desc, data.Title, panel.depth + depth_delta)
        return
      end
    end
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  else
    LogUtility.Error(string.format("[%s] OpenHelpView() Error : self.viewdata.view.id == %s is not exist in Table_Help!", self.__cname, self.viewdata.view.id))
  end
end

function CoreView:OpenMultiHelp(helpIds)
  if not helpIds or "table" ~= type(helpIds) or #helpIds <= 0 then
    return
  end
  local tip_data = {}
  for i = 1, #helpIds do
    local staticData = Table_Help[helpIds[i]]
    if staticData then
      tip_data[#tip_data + 1] = staticData
    else
      redlog("Help表未配置ID： ", helpIds[i])
    end
  end
  if nil ~= next(tip_data) then
    TipsView.Me():ShowMultiGeneralHelp(tip_data)
  end
end

function CoreView:OnEnable()
end

function CoreView:OnDisable()
end

function CoreView:OnDestroy()
end

function CoreView:FindChild(name, parent)
  parent = parent or self.gameObject
  if parent == nil then
    return nil
  else
    return Game.GameObjectUtil:DeepFindChild(parent, name)
  end
end

function CoreView:FindGO(name, parent)
  parent = parent or self.gameObject
  return parent ~= nil and Game.GameObjectUtil:DeepFind(parent, name) or nil
end

function CoreView:FindComponent(name, comp, parent)
  parent = parent or self.gameObject
  return parent ~= nil and Game.GameObjectUtil:DeepFindComponent(parent, comp, name) or nil
end

function CoreView:FindComponents(compType, parent, containSelf)
  parent = parent or self.gameObject
  containSelf = containSelf == nil or true
  if not self:ObjIsNil(parent) then
    return Game.GameObjectUtil:GetAllComponentsInChildren(parent, compType, containSelf) or {}
  end
  return {}
end

function CoreView:AddButtonEvent(name, event, hideType)
  local buttonobj = self:FindGO(name)
  if buttonobj then
    self:AddClickEvent(buttonobj, event, hideType)
  end
end

function CoreView:AddClickEvent(obj, event, hideType, ignoreClickEventInterval)
  if event == nil then
    UIEventListener.Get(obj).onClick = nil
    return
  end
  UIEventListener.Get(obj).onClick = function(go)
    if go and not Game.GameObjectUtil:ObjectIsNULL(go) then
      local cmt = go:GetComponent(GuideTagCollection)
      if cmt and cmt.id ~= -1 then
        FunctionGuide.Me():triggerWithTag(cmt.id)
      end
      local positionX, positionY = LuaGameObject.GetMousePosition()
      AAAManager.Me():ClickEvent(go.name, positionX, positionY)
    end
    if not hideType or hideType and not hideType.hideClickSound then
      self:PlayUISound(AudioMap.UI.Click)
    end
    self:CheckHandleClickEvent(ignoreClickEventInterval, event, go)
  end
end

function CoreView:AddDoubleClickEvent(obj, event)
  local myDClick = obj:GetComponent(MyCheckDoublcClick)
  myDClick = myDClick or obj:AddComponent(MyCheckDoublcClick)
  
  function myDClick.onDoubleClick(go)
    event()
  end
end

function CoreView:AddPressEvent(obj, event, hideType)
  UIEventListener.Get(obj).onPress = function(obj, isPress)
    if event then
      event(obj, isPress)
    end
    local hideRet = not hideType or hideType and not hideType.hideClickEffect
    local start = hideRet and isPress
    if not self.effectCache then
      return
    end
    if start then
      local count = self.effectCache[obj] or 0
      self.effectCache[obj] = count + 1
      local delay = GameConfig.ClickEffectDelay or 0.6
      TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function(owner, deltaTime)
        self:reduceEffectCacheCount(obj)
      end, self)
    else
      local endR = hideRet and not isPress
      if endR and self.effectCache[obj] and self.effectCache[obj] > 0 then
        ClickEffectView.ShowClickEffect()
        self:reduceEffectCacheCount(obj)
      end
    end
  end
end

function CoreView:reduceEffectCacheCount(obj)
  if not self.effectCache then
    return
  end
  local count = self.effectCache[obj] or 0
  count = count - 1
  if count < 1 then
    self.effectCache[obj] = nil
  else
    self.effectCache[obj] = count
  end
end

function CoreView:AddDragEvent(obj, event)
  UIEventListener.Get(obj).onDrag = event
end

function CoreView:AddTabEvent(obj, event, hideSound)
  if obj then
    local togs = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIToggle, true)
    local tog = togs and togs[1]
    self:AddClickEvent(obj, function(go)
      local value = false
      if tog then
        value = tog.value
      end
      if event then
        event(go, value)
      end
      if not hideSound then
        self:PlayUISound(AudioMap.UI.Tab)
      end
    end, {hideClickSound = true}, true)
  end
end

function CoreView:PlayAnim(go, animName)
  local animator = go:GetComponent(Animator)
  if animator then
    animator:Play(animName, -1, 0)
  end
end

function CoreView:ObjIsNil(obj)
  return LuaGameObject.ObjectIsNull(obj)
end

function CoreView:LoadPreferb(viewName, parent, initPanel)
  return self:LoadPreferb_ByFullPath(ResourcePathHelper.UIV1(viewName), parent, initPanel)
end

function CoreView:LoadPreferb_ByFullPath(path, parent, initPanel)
  parent = parent or self.gameObject
  local obj = Game.AssetManager_UI:CreateAsset(path, parent.gameObject)
  if obj == nil then
    errorLog(path)
    return
  end
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
  if obj and initPanel then
    local upPanel = UIUtil.GetComponentInParents(obj, UIPanel)
    if upPanel then
      local panels = UIUtil.GetAllComponentsInChildren(obj, UIPanel, true)
      for i = 1, #panels do
        panels[i].depth = panels[i].depth + upPanel.depth
      end
    end
  end
  return obj, path
end

function CoreView:SetPanelDepthByParent(obj, offsetDepth)
  local panel = obj:GetComponent(UIPanel)
  if not panel then
    return
  end
  local parentPanel = UIUtil.GetComponentInParents(obj, UIPanel, true)
  if not parentPanel then
    return
  end
  panel.depth = parentPanel.depth + offsetDepth
end

function CoreView:PlayUIEffect(id, container, once, callback, callArgs, scale)
  return self:PlayEffectByFullPath(ResourcePathHelper.UIEffect(id), container, once, callback, callArgs, scale)
end

function CoreView:PlayEffectByFullPath(path, container, once, callback, callArgs, scale)
  if once then
    return Asset_Effect.PlayOneShotOn(path, container and container.transform, function(go, args, assetEffect)
      if not args.owner then
        return
      end
      args.owner:PlayUIEffectAsyncCallBack(container, assetEffect, go, callback, args.params, path)
    end, {owner = self, params = callArgs}, scale)
  else
    local effect = Asset_Effect.PlayOn(path, container and container.transform, function(go, args, assetEffect)
      if not args.owner then
        return
      end
      args.owner:PlayUIEffectAsyncCallBack(container, assetEffect, go, callback, args.params, path)
    end, {owner = self, params = callArgs}, scale)
    if self.uieffects == nil then
      self.uieffects = {}
    end
    TableUtility.ArrayPushBack(self.uieffects, effect)
    return effect
  end
end

function CoreView:DestroyUIEffects()
  if self.uieffects == nil then
    return
  end
  local effect
  for i = #self.uieffects, 1, -1 do
    effect = self.uieffects[i]
    if effect:Alive() then
      effect:Destroy()
    end
    self.uieffects[i] = nil
  end
end

function CoreView:PlayUIEffectAsyncCallBack(container, assetEffect, go, callback, callArgs, path)
  if self:ObjIsNil(container) then
    if assetEffect then
      redlog("CoreView:PlayUIEffectAsyncCallBack obj is nil, Destroy AssetEffect ")
      assetEffect:Destroy()
    end
    return
  end
  local changeRqByTex = container:GetComponent(ChangeRqByTex)
  if changeRqByTex then
    changeRqByTex.excute = false
  end
  if callback then
    callback(go, callArgs, assetEffect)
  end
end

function CoreView:PlayUITrailEffect(id, container)
  container = container or self.gameObject
  local path = ResourcePathHelper.UIEffect(id)
  return Asset_Effect.PlayOn(path, container)
end

function CoreView:CopyGameObject(obj, parent, initTransformIndex)
  if self:ObjIsNil(obj) then
    return
  end
  local result = GameObject.Instantiate(obj)
  if parent == nil then
    parent = obj.transform.parent
  else
    parent = parent.transform
  end
  if parent ~= nil then
    result.transform:SetParent(parent, false)
    if initTransformIndex then
      local oriIndex = obj.transform:GetSiblingIndex()
      result.transform:SetSiblingIndex(oriIndex)
    end
  end
  return result
end

function CoreView:SetGOActive(gmeobj, b)
  if gmeobj.activeSelf ~= b then
    gmeobj:SetActive(b)
  end
end

function CoreView:SetActive(obj, state)
  if obj and obj.gameObject then
    obj.gameObject:SetActive(state)
  end
end

function CoreView:Show(target)
  target = target and target.gameObject or self.gameObject
  if target and target.activeSelf == false then
    target:SetActive(true)
  end
end

function CoreView:Hide(target)
  target = target and target.gameObject or self.gameObject
  if target and target.activeSelf == true then
    target:SetActive(false)
  end
end

function CoreView:PlayUISound(source)
  return AudioUtility.PlayOneShot2D_Path(source, AudioSourceType.UI)
end

function CoreView:sendNotification(notificationName, body, type)
  GameFacade.Instance:sendNotification(notificationName, body, type)
end

function CoreView:AddOrRemoveGuideId(objOrName, id)
  local argType = type(objOrName)
  local obj = objOrName
  if argType == "string" then
    obj = self:FindGO(objOrName)
    if obj == nil then
      printRed("can't find the gameObject" .. objOrName)
      return
    end
  end
  if obj == nil then
    printRed("the gameObject is nil")
  else
    local cmt = obj:GetComponent(GuideTagCollection)
    local collider = obj:GetComponent(BoxCollider)
    if id and id ~= -1 then
      cmt = cmt or obj:AddComponent(GuideTagCollection)
      if not collider then
        obj:AddComponent(BoxCollider)
      end
      cmt.id = id
      FunctionGuide.Me():setGuideUIActive(id, true)
    elseif cmt then
      FunctionGuide.Me():setGuideUIActive(cmt.id, false)
      cmt.id = -1
    end
  end
end

function CoreView:RegisterGuideTarget(targetType, obj)
  if not self.guideTargetTypes then
    self.guideTargetTypes = {}
  end
  self.guideTargetTypes[targetType] = 1
  FunctionClientGuide.Me():RegisterTarget(targetType, obj)
end

function CoreView:UnRegisterGuideTarget(targetType)
  FunctionClientGuide.Me():UnRegisterTarget(targetType)
end

function CoreView:UnRegisterAllGuideTarget()
  if not self.guideTargetTypes then
    return
  end
  for t, _ in pairs(self.guideTargetTypes) do
    if t then
      FunctionClientGuide.Me():UnRegisterTarget(t)
    end
  end
end

function CoreView:removeChildren(go)
  if not self:ObjIsNil(go) then
    local count = go.transform.childCount
    self:Log(count)
    for i = 0, count - 1 do
      local obj = go.transform:GetChild(0)
      if obj then
        GameObject.DestroyImmediate(obj.gameObject)
      end
    end
  end
end

function CoreView:SetTextureGrey(go, effectColor, labelColor)
  self:SetTextureColor(go, Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941))
  local labels = Game.GameObjectUtil:GetAllComponentsInChildren(go.gameObject, UILabel, true)
  for i = 1, #labels do
    labels[i].effectColor = effectColor or Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
    labels[i].gradientTop = Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
    if labelColor then
      labels[i].color = labelColor
    end
  end
end

function CoreView:SetTextureWhite(go, effectColor, labelColor)
  self:SetTextureColor(go)
  local labels = Game.GameObjectUtil:GetAllComponentsInChildren(go.gameObject, UILabel, true)
  for i = 1, #labels do
    labels[i].effectColor = effectColor or Color(1, 1, 1)
    labels[i].gradientTop = Color(1, 1, 1)
    if labelColor then
      labels[i].color = labelColor
    end
  end
end

function CoreView:SetTextureColor(go, color, includeChild)
  if color == nil then
    color = Color(1, 1, 1)
  end
  if includeChild == nil then
    includeChild = true
  end
  if includeChild then
    local sprites = Game.GameObjectUtil:GetAllComponentsInChildren(go.gameObject, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = color
    end
  else
    local sprite = go:GetComponent(UISprite)
    sprite.color = color
  end
end

function CoreView:SetButtonEnable(button, enabled, enabledLabelEffectColor, disabledLabelEffectColor)
  local colliders = Game.GameObjectUtil:GetAllComponentsInChildren(button.gameObject, BoxCollider, true)
  if colliders then
    for i = 1, #colliders do
      local collider = colliders[i]
      collider.enabled = enabled
    end
  end
  if enabled then
    self:SetTextureWhite(button, enabledLabelEffectColor)
  else
    self:SetTextureGrey(button, disabledLabelEffectColor)
  end
end

function CoreView:AdjustViewPort(oriViewPort, angleX)
  local vp_x, vp_y, vp_z = oriViewPort[1], oriViewPort[2], oriViewPort[3]
  local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1]
  vp_x = 0.5 - (0.5 - vp_x) * 1280 / viewWidth
  if not self.temp_ViewPort then
    self.temp_ViewPort = LuaVector3()
  end
  LuaVector3.Better_Set(self.temp_ViewPort, vp_x, vp_y, vp_z)
  return FunctionCameraEffect.Me():AdjustCameraViewportAndFocusoffset(CameraController.singletonInstance, self.temp_ViewPort, nil, angleX)
end

function CoreView:CameraRotateToMe(replaceMySceneInfo, viewPort, rotation, rotateOffset, duration)
  if not CoreView.RotateCamera then
    return
  end
  if self.cft ~= nil then
    self:CameraReset()
  end
  if nil == CameraController.singletonInstance then
    return
  end
  local myTrans = Game.Myself.assetRole.completeTransform
  viewPort = viewPort or CameraConfig.UI_ViewPort
  local cameraController = CameraController.singletonInstance
  if rotation == nil then
    rotation = cameraController.targetRotationEuler
    rotation = Vector3(CameraConfig.UI_ViewRotationX, rotation.y, rotation.z)
  end
  local vp, offset = self:AdjustViewPort(viewPort, rotation.x)
  duration = duration or CameraConfig.UI_Duration
  self.cft = CameraEffectFocusAndRotateTo.new(myTrans, offset, vp, rotation, duration)
  FunctionCameraEffect.Me():Start(self.cft)
  if replaceMySceneInfo then
    self.uiPlayerSceneInfo = UIPlayerSceneInfo.new(self.gameObject, self.viewdata.view.id)
    self.uiPlayerSceneInfo:OnEnter()
  end
  Game.Myself:UpdateEpNodeDisplay(true)
end

function CoreView:CameraFaceTo(transform, viewPort, rotation, duration, rotateOffset, listener, focusOffset, noAdjust)
  if not CoreView.RotateCamera then
    return
  end
  if nil == CameraController.singletonInstance then
    return
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  duration = duration or CameraConfig.UI_Duration
  local vp, offset
  if noAdjust then
    vp = viewPort
    offset = LuaVector3.New()
  else
    vp, offset = self:AdjustViewPort(viewPort, rotation.x)
  end
  if focusOffset then
    offset:Add(focusOffset)
  end
  self.cft = CameraEffectFaceTo.new(transform, offset, vp, rotation, duration, listener)
  if rotateOffset then
    self.cft:SetRotationOffset(rotateOffset)
  end
  FunctionCameraEffect.Me():Start(self.cft)
end

function CoreView:CameraFocusAndRotateTo(transform, viewPort, rotation, duration, listener, focusOffset, noAdjust)
  if not CoreView.RotateCamera then
    return
  end
  if nil == CameraController.singletonInstance then
    return
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  duration = duration or CameraConfig.UI_Duration
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  local vp, offset
  if noAdjust then
    vp = viewPort
    offset = LuaVector3.New()
  else
    vp, offset = self:AdjustViewPort(viewPort, rotation.x)
  end
  if focusOffset then
    offset:Add(focusOffset)
  end
  self.cft = CameraEffectFocusAndRotateTo.new(transform, offset, vp, rotation, duration, listener)
  FunctionCameraEffect.Me():Start(self.cft)
  return self.cft
end

function CoreView:CameraFocusOnNpc(npcTrans, viewPort, duration, endCall, focusOffset)
  if not CoreView.RotateCamera then
    return
  end
  viewPort = viewPort or CameraConfig.NPC_FuncPanel_ViewPort
  duration = duration or CameraConfig.NPC_Dialog_DURATION
  local cameraController = CameraController.singletonInstance
  if cameraController then
    local rotation = cameraController.cameraRotationEuler
    if not FunctionCameraEffect:IsFreeCameraLocked() then
      rotation.x = CameraConfig.NPC_Dialog_RotationX or 30
      cameraController.FreeDefaultInfo.rotation = rotation
    end
    return self:CameraFocusAndRotateTo(npcTrans, viewPort, rotation, duration, endCall, focusOffset)
  end
  local vp, offset = self:AdjustViewPort(viewPort)
  self.cft = CameraEffectFocusTo.new(npcTrans, vp, duration, endCall)
  self.cft:SetFocusOffset(offset)
  FunctionCameraEffect.Me():Start(self.cft)
  return self.cft
end

function CoreView:CameraFocusToMe(duration)
  local mount = BagProxy.Instance:GetRoleEquipBag():GetMount()
  self:CameraRotateToMe(false, mount and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort, nil, nil, duration)
end

function CoreView:CameraReset(duration)
  if self.cft ~= nil then
    if duration then
      self.cft.duration = duration
    end
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
  if self.uiPlayerSceneInfo then
    self.uiPlayerSceneInfo:OnExit()
    self.uiPlayerSceneInfo = nil
  end
  Game.Myself:UpdateEpNodeDisplay(false)
end

function CoreView:ShowItemTip(data, stick, side, offset, isShowFavorite)
  if data then
    local view = self.viewdata and self.viewdata.view
    if data.hideGetPath == nil then
      local hideGetPath = false
      if view and view.id then
        local hideViews = GameConfig.ItemTipGetPathShow and GameConfig.ItemTipGetPathShow.HideViews
        if hideViews then
          hideGetPath = TableUtil.HasValue(hideViews, view.id)
        end
      end
      data.hideGetPath = hideGetPath
    end
    return TipManager.Instance:ShowItemFloatTip(data, stick, side, offset, isShowFavorite)
  else
    TipManager.Instance:CloseItemTip()
  end
end

function CoreView:AddSelectEvent(obj, event)
  if not self:ObjIsNil(obj) then
    obj = obj.gameObject
    local func = function(go, state)
      if event then
        event(go, state)
      end
    end
    UIEventListener.Get(obj).onSelect = {"+=", func}
  end
end

function CoreView:CheckHandleClickEvent(ignoreClickEventInterval, event, ...)
  if not event then
    LogUtility.Warning("The click event function is nil!")
    return
  end
  if ignoreClickEventInterval == nil then
    ignoreClickEventInterval = self.isIgnoreClickEventInterval
  end
  if ignoreClickEventInterval or not GameConfig.System.click_event_interval then
    event(...)
    return
  end
  local nowTime = ServerTime.CurClientTime()
  if nowTime - lastClickEventTime >= GameConfig.System.click_event_interval then
    event(...)
    lastClickEventTime = nowTime
  end
end

function CoreView:SetIgnoreClickEventInterval(isIgnore)
  self.isIgnoreClickEventInterval = isIgnore and true or false
end

function CoreView:TryInitFilterPopOfView(filterPopObjName, onChangeCallback, options, optionDatas)
  if not options or not next(options) then
    LogUtility.Warning("There's no option while initializing FilterPop")
    return
  end
  local filterPop = self:FindComponent(filterPopObjName, UIPopupList)
  if not filterPop then
    filterPop = self:FindComponent(filterPopObjName, UIScrollablePopupList)
    if not filterPop then
      LogUtility.WarningFormat("Cannot find filterPop of {0} with name {1}", self.__cname, filterPopObjName)
      return
    end
  end
  filterPop:Clear()
  for i = 1, #options do
    filterPop:AddItem(options[i], not (optionDatas and optionDatas[i]) and i - 1 or optionDatas[i])
  end
  filterPop.value = options[1]
  self[filterPopObjName] = filterPop
  EventDelegate.Add(filterPop.onChange, function()
    if self[filterPopObjName].data == nil then
      LogUtility.WarningFormat("The data of the FilterPopUpList named {0} is nil.", filterPopObjName)
      return
    end
    local field = string.format("cur%sData", filterPopObjName)
    if self[field] ~= self[filterPopObjName].data then
      self[field] = self[filterPopObjName].data
      onChangeCallback(self[filterPopObjName].data)
    end
  end)
end

function CoreView:RefitFullScreenWidgetSize(widget, selfScale)
  if not widget then
    return
  end
  local panel = self.gameObject:GetComponent(UIPanel)
  if not panel then
    return
  end
  local size = panel:GetWindowSize()
  local width = math.ceil(size.x)
  if selfScale then
    local hwScale = widget.height / widget.width
    widget.width = width
    widget.height = math.ceil(width * hwScale)
  else
    local height = math.ceil(size.y)
    widget.height = height
    widget.width = width
  end
end

function CoreView:OnCellDestroy()
  self:DestroyUIEffects()
end

local safe_OnComponentDestroy = function(self)
  for _, v in pairs(self) do
    if type(v) == "table" and rawget(v, "class") then
      if v.gameObjectComp ~= nil then
        v:OnDestroy()
      elseif v.__OnViewDestroy then
        v:__OnViewDestroy()
      end
    end
  end
end
local success, errorMsg

function CoreView:OnComponentDestroy()
  success, errorMsg = xpcall(safe_OnComponentDestroy, debug.traceback, self)
  if not success then
    Debug.LogError(errorMsg)
  end
end

function CoreView:AddMonoUpdateFunction(func)
  if self.haveMonoUpdateFunc then
    return
  end
  Game.GUISystemManager:AddMonoUpdateFunction(func, self)
  self.haveMonoUpdateFunc = true
end

function CoreView:RemoveMonoUpdateFunction()
  if not self.haveMonoUpdateFunc then
    return
  end
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
  self.haveMonoUpdateFunc = nil
end

function CoreView:Log(...)
  if self.OpenLog then
    helplog(...)
  end
end

function CoreView:LogError(prefix, data)
  if self.OpenLog then
    helpPrint(prefix, "red")
    if data ~= nil then
      printData(data)
    end
  end
end
