autoImport("UILayer")
autoImport("UINode")
UIManagerProxy = class("UIManagerProxy", pm.Proxy)
UIManagerProxy.Instance = nil
UIFitType = {Width = 1, Height = 2}

function UIManagerProxy:ctor()
  self.proxyName = "UIManagerProxy"
  self.myModelName = SystemInfo.deviceModel
  self:InitMyMobileScreenAdaption()
  self.UIRoot = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("UIRoot"))
  self.uiCamera = self.UIRoot.transform:Find("Camera"):GetComponent(Camera)
  if not BackwardCompatibilityUtil.CompatibilityMode_V35 then
    local layers = UICamera.UILAYERS
    if not layers:Contains("UI") then
      layers:Add("UI")
    end
    if not layers:Contains("SceneUI") then
      layers:Add("SceneUI")
    end
    if not layers:Contains("SceneUIBackground") then
      layers:Add("SceneUIBackground")
    end
  end
  local uiroot = self.UIRoot:GetComponent(UIRoot)
  if uiroot then
    local screen = NGUITools.screenSize
    local aspect = screen.x / screen.y
    local initialAspect = uiroot.manualWidth / uiroot.manualHeight
    if aspect > initialAspect + 0.1 then
      uiroot.fitWidth = false
      uiroot.fitHeight = true
      self.uiFitType = UIFitType.Height
    else
      self.uiFitType = UIFitType.Width
    end
    self.rootSize = {
      math.floor(uiroot.activeHeight * aspect),
      uiroot.activeHeight
    }
    self.UIRootComp = uiroot
  end
  GameObject.DontDestroyOnLoad(self.UIRoot)
  local speechGO = GameObject("SpeechRecognizer")
  speechGO.transform.parent = self.UIRoot.transform
  speechGO:AddComponent(AudioSource)
  self.speechRecognizer = speechGO:AddComponent(SpeechRecognizer)
  self.layers = {}
  self.forbidview_map = {}
  UIManagerProxy.Instance = self
  self:InitLayers()
  self:InitRollBack()
  self:InitViewPop()
  self:DoMobileScreenAdaptionAnchors()
  self.isLockAndroidKey = false
end

function UIManagerProxy:GetUIRootSize()
  return self.rootSize
end

function UIManagerProxy:InitLayers()
  local layers = {}
  for k, v in pairs(UIViewType) do
    layers[#layers + 1] = v
  end
  table.sort(layers, function(l, r)
    return l.depth < r.depth
  end)
  for i = 1, #layers do
    self.layers[layers[i].name] = self:SpawnLayer(layers[i])
  end
  self.childPopMap = {}
  self.childPopCount = 0
end

function UIManagerProxy:InitRollBack()
  self.rollBackMap = {}
  local panelData, viewClass
  for i = 1, #UIRollBackID do
    panelData = PanelProxy.Instance:GetData(UIRollBackID[i])
    if panelData then
      viewClass = self:GetImport(panelData.class)
      if viewClass then
        self.rollBackMap[viewClass] = 1
      end
    end
  end
end

function UIManagerProxy:SpawnLayer(data)
  local layer = UILayer.new(data, self.UIRoot)
  layer:AddEventListener(UILayer.AddChildEvent, self.LayerAddChildHandler, self)
  layer:AddEventListener(UILayer.EmptyChildEvent, self.LayerEmptyHandler, self)
  return layer
end

function UIManagerProxy:ShowUI(data, prefab, class)
  local viewid = data.view and data.view.id
  local forbid_msg = viewid and self.forbidview_map[viewid]
  if forbid_msg then
    if forbid_msg ~= -1 then
      MsgManager.ShowMsgByIDTable(forbid_msg)
    end
    return
  end
  local viewClass = self:GetImport(class or data.viewname)
  if viewClass then
    local viewType = viewClass.ViewType
    local layer = self:GetLayerByType(viewType)
    if layer then
      self:TrySetupViewMaskAdaption(viewClass, layer)
      return layer:CreateChild(data, prefab, class, self.rollBackMap[viewClass] ~= nil)
    end
  end
end

function UIManagerProxy:ActiveLayer(layerType, b)
  local layer = self:GetLayerByType(layerType)
  if layer == nil then
    return
  end
  if b then
    layer:Show()
  else
    layer:Hide()
  end
end

function UIManagerProxy:IsLayerActive(layerType)
  local layer = self:GetLayerByType(layerType)
  if layer == nil then
    return
  end
  return layer:IsOnShow()
end

function UIManagerProxy:ShowUIByConfig(data)
  return self:ShowUI(data, data.view.prefab, data.view.class)
end

function UIManagerProxy:CloseUI(viewCtrl)
  if viewCtrl then
    local viewType = viewCtrl.ViewType
    local layer = self:GetLayerByType(viewType)
    if layer then
      self:TryHideViewMaskAdaptionByCtrl(viewCtrl)
      layer:DestoryChildByCtrl(viewCtrl)
      layer:TryRollBackPrevious()
    end
  end
end

function UIManagerProxy:CloseUIByClassName(className, needRollBack)
  if not className then
    return
  end
  local class = self:GetImport(className)
  if class and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      local node = layer:FindNodeByClassName(className)
      if node then
        self:TryHideViewMaskAdaptionByCtrl(node.viewCtrl)
        layer:DestoryChild(node)
        if needRollBack == true or needRollBack == nil then
          layer:TryRollBackPrevious()
        end
      end
    end
  end
end

function UIManagerProxy:CloseLayerAllChildren(viewType)
  if viewType then
    local layer = self:GetLayerByType(viewType)
    if layer then
      self:TryHideViewMaskAdaptionByType(viewType)
      layer:DestoryAllChildren()
      layer:TryRollBackPrevious()
    end
  end
end

function UIManagerProxy:ReturnToMainView()
  for i = 1, #self.modalLayer do
    self:CloseLayerAllChildren(self.modalLayer[i])
  end
end

function UIManagerProxy:LayerAddChildHandler(evt)
  self:AddHideOtherLayers(evt.target)
  self:CloseOtherLayers(evt.target)
end

function UIManagerProxy:LayerEmptyHandler(evt)
  self:RemoveHideOtherLayers(evt.target)
end

function UIManagerProxy:CloseOtherLayers(layer)
  local closeOthers = layer.data.closeOtherLayer
  if closeOthers then
    for k, v in pairs(closeOthers) do
      self:CloseLayerAllChildren(UIViewType[k])
    end
  end
end

function UIManagerProxy:AddHideOtherLayers(layer)
  if layer.data.hideOtherLayer then
    local hideOther = layer.data.hideOtherLayer
    local otherLayer, name
    for k, v in pairs(hideOther) do
      name = UIViewType[k].name
      otherLayer = self.layers[name]
      otherLayer:AddHideMasterLayer(layer)
    end
  end
end

function UIManagerProxy:RemoveHideOtherLayers(layer)
  if layer.data.hideOtherLayer then
    local hideOther = layer.data.hideOtherLayer
    local otherLayer, name
    for k, v in pairs(hideOther) do
      name = UIViewType[k].name
      otherLayer = self.layers[name]
      otherLayer:RemoveHideMasterLayer(layer)
    end
  end
end

function UIManagerProxy:GetLayerByType(viewType)
  local layers = self.layers
  return layers and layers[viewType.name]
end

function UIManagerProxy:GetNodeByViewName(viewName)
  local panelConfig = PanelConfig[viewName]
  return self:GetNodeByPanelConfig(panelConfig)
end

function UIManagerProxy:GetNodeByPanelConfig(panelConfig)
  if not panelConfig then
    return
  end
  local class = self:GetImport(panelConfig.class)
  if class ~= nil and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      return layer:FindNodeByClassName(panelConfig.class)
    end
  end
end

function UIManagerProxy:GetNodeByClassName(className)
  if not className then
    return
  end
  local class = self:GetImport(className)
  if class ~= nil and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      return layer:FindNodeByName(className)
    end
  end
end

function UIManagerProxy:HasUINode(panelConfig)
  return self:GetNodeByPanelConfig(panelConfig) ~= nil
end

function UIManagerProxy:HasUINodeByClassName(className)
  return self:GetNodeByClassName(className) ~= nil
end

function UIManagerProxy:HasOtherUINode(panelConfig)
  if not panelConfig then
    return
  end
  local class = self:GetImport(panelConfig.class)
  if class ~= nil and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      return layer:HasOtherNodeByClassName(panelConfig.class)
    end
  end
end

function UIManagerProxy:LayerHasAnyNodeShow(layerType)
  if not layerType then
    return false
  end
  local layer = self:GetLayerByType(layerType)
  if layer then
    return layer:IsOnShow() and layer:HasAnyNode()
  end
  return false
end

function UIManagerProxy:HasAnyLayerMaskOn()
  for k, v in pairs(self.layers) do
    if v:IsMaskOn() then
      return true
    end
  end
  return false
end

function UIManagerProxy:GetImport(viewname)
  local viewCtrl = _G[viewname]
  if not viewCtrl then
    viewCtrl = autoImport(viewname)
    if type(viewCtrl) ~= "table" then
      viewCtrl = _G[viewname]
    end
  end
  return viewCtrl
end

function UIManagerProxy:InitViewPop()
  self.modalLayer = {
    UIViewType.ChatroomLayer,
    UIViewType.ChitchatLayer,
    UIViewType.TeamLayer,
    UIViewType.ChatLayer,
    UIViewType.FocusLayer,
    UIViewType.NormalLayer,
    UIViewType.PopUpLayer,
    UIViewType.ConfirmLayer,
    UIViewType.SystemOpenLayer,
    UIViewType.Show3D2DLayer,
    UIViewType.ShareLayer,
    UIViewType.Popup10Layer,
    UIViewType.TipLayer,
    UIViewType.DialogLayer,
    UIViewType.Lv4PopUpLayer,
    UIViewType.InterstitialLayer,
    UIViewType.ToolsLayer,
    UIViewType.BuildingLayer
  }
  for i = #self.modalLayer, 1, -1 do
    if self.modalLayer[i] == nil then
      table.remove(self.modalLayer, i)
    end
  end
  table.sort(self.modalLayer, function(l, r)
    return l.depth < r.depth
  end)
end

function UIManagerProxy:GetModalPopCount()
  local count = 0
  local uilayer
  for i = 1, #self.modalLayer do
    uilayer = self.layers[self.modalLayer[i].name]
    if uilayer.data ~= UIViewType.TipLayer and 0 < #uilayer.nodes then
      count = count + #uilayer.nodes
    end
  end
  if TipsView.me and TipsView.me.currentTip ~= nil then
    count = count + 1
  end
  for layerConfig, childObjs in pairs(self.childPopMap) do
    for k, childObj in pairs(childObjs) do
      if not Slua.IsNull(childObj) and childObj.activeInHierarchy then
        count = count + 1
      end
    end
  end
  return count
end

local FORBIDDEN_ANDROIDKEY_VIEW = "RoleChangeNamePopUp"

function UIManagerProxy:CheckForbiddenAndroidKeyView()
  local layer
  for i = 1, #self.modalLayer do
    layer = self.layers[self.modalLayer[i].name]
    if UIViewType.TipLayer.name == layer.name and UIViewType.TipLayer.depth == layer.depth then
      if self.modalLayer[i] == UIViewType.DialogLayer then
        return true
      end
    else
      for j = 1, #layer.nodes do
        if layer.nodes[j].viewname == FORBIDDEN_ANDROIDKEY_VIEW and MyselfProxy.Instance:IsCurRoleNameInValid() then
          return true
        end
      end
      if #layer.nodes > 0 and self.modalLayer[i] == UIViewType.DialogLayer then
        return true
      end
    end
  end
  return false
end

function UIManagerProxy:PopView()
  local executed, layerConf, uiLayer, childPop
  for i = #self.modalLayer, 1, -1 do
    layerConf = self.modalLayer[i]
    uiLayer = self.layers[layerConf.name]
    if UIViewType.TipLayer == layerConf then
      if TipsView.me and TipsView.me.currentTip ~= nil then
        TipsView.me:HideCurrent()
        executed = true
        break
      end
    else
      childPop = self.childPopMap[layerConf]
      if childPop and 0 < #childPop then
        for j = #childPop, 1, -1 do
          if not Slua.IsNull(childPop[j]) and childPop[j].activeInHierarchy then
            childPop[j]:SetActive(false)
            executed = true
            break
          end
        end
      end
      local nodeCount = uiLayer:GetEscNodeCount()
      if 0 < nodeCount then
        uiLayer:TryPopNode()
        executed = true
        break
      end
    end
  end
  if not executed then
    local mainChildPop = self.childPopMap[UIViewType.MainLayer]
    if mainChildPop then
      for j = #mainChildPop, 1, -1 do
        if not Slua.IsNull(mainChildPop[j]) and mainChildPop[j].activeInHierarchy then
          mainChildPop[j]:SetActive(false)
          executed = true
          break
        end
      end
    end
  end
  return self:GetModalPopCount()
end

function UIManagerProxy:SetForbidView(viewid, forbidMsgid, forceClose)
  self.forbidview_map[viewid] = forbidMsgid or -1
  if forceClose then
    local viewdata = PanelProxy.Instance:GetData(viewid)
    if viewdata then
      self:CloseLayerAllChildren(self:GetImport(viewdata.class).ViewType)
    end
  end
end

function UIManagerProxy:UnSetForbidView(viewid)
  self.forbidview_map[viewid] = nil
end

function UIManagerProxy:RegisterChildPopObj(layer, obj)
  if not self.childPopMap[layer] then
    self.childPopMap[layer] = {}
  end
  table.insert(self.childPopMap[layer], obj)
  self.childPopCount = self.childPopCount + 1
end

function UIManagerProxy:UnRegisterChildPopObj(layer)
  if not self.childPopMap[layer] then
    return
  end
  local cCount = #self.childPopMap[layer]
  self.childPopCount = self.childPopCount - cCount
  for i = cCount, 1, -1 do
    self.childPopMap[layer][i] = nil
  end
end

function UIManagerProxy:NeedEnableAndroidKey(needEnable, callBack)
  if not BackwardCompatibilityUtil.CompatibilityMode_V28 then
    if ApplicationInfo.IsRunOnWindowns() then
      needEnable = false
      callBack = nil
    end
    AndroidKey.Instance:NeedEnableAndroidKey(needEnable, function()
      if UIManagerProxy.Instance:CheckForbiddenAndroidKeyView() then
        MsgManager.ShowMsgByID(27001)
      elseif callBack then
        callBack()
      end
    end)
  end
end

local defaultNeedEnableAndroidKeyCallback = function()
  if UIManagerProxy.Instance:GetModalPopCount() > 0 then
    UIManagerProxy.CSPopView()
  else
    MsgManager.ConfirmMsgByID(27000, function()
      ApplicationInfo.Quit()
    end, function()
    end)
  end
end

function UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback()
  return defaultNeedEnableAndroidKeyCallback
end

function UIManagerProxy:InitMyMobileScreenAdaption()
  self.isLandscapeLeft = true
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  if not ApplicationInfo.IsRunOnWindowns() then
    for _, v in pairs(Table_MobileScreenAdaption) do
      if v.IsValid == 1 then
        if v.DeviceInfo == self.myModelName then
          self:UpdateLocalMobileScreenAdaptionMap(v, true)
          break
        elseif string.sub(v.DeviceInfo, 1, 1) == "@" and string.find(string.lower(self.myModelName), string.lower(string.sub(v.DeviceInfo, 2))) then
          self:UpdateLocalMobileScreenAdaptionMap(v, false)
        end
      end
    end
  end
  Table_MobileScreenAdaption = nil
  ClearTableFromG("Table_MobileScreenAdaption")
end

local updateAdaptionMap = function(target, source)
  target.SpecialView = source.SpecialView
  local r = source.RotationType
  target[r] = target[r] or {}
  if not next(target[r]) then
    target[r].l = source.offset_left
    target[r].t = source.offset_top
    target[r].r = source.offset_right
    target[r].b = source.offset_bottom
  end
end

function UIManagerProxy:UpdateLocalMobileScreenAdaptionMap(staticData, isDirectAdaption)
  self.mobileScreenAdaptionMap = self.mobileScreenAdaptionMap or {}
  updateAdaptionMap(self.mobileScreenAdaptionMap, staticData)
  self.isDirectMobileScreenAdaption = isDirectAdaption
end

function UIManagerProxy:DoMobileScreenAdaptionAnchors()
  if not self.mobileScreenAdaptionMap then
    return false
  end
  if GameConfig.SystemForbid.MobileScreenAdaption then
    return false
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    return false
  end
  local l, t, r, b = self:GetMyMobileScreenAdaptionOffsets(self.isLandscapeLeft)
  if l then
    ApplicationInfo.TrySetSafeAreaSides(l, t, r, b, self.isDirectMobileScreenAdaption)
    if not self.UIRootComp then
      self.UIRootComp = self.UIRoot:GetComponent(UIRoot)
    end
    if self.UIRootComp then
      self.UIRootComp:ResetAnchorsAndUpdateAllChildren()
      return true
    end
  end
  return false
end

function UIManagerProxy:HandleOrientationChange(note)
  if note.data == nil then
    LogUtility.Warning("UIManagerProxy: received AppStateEvent.OrientationChange with isLandscapeLeft = nil")
    return
  end
  self.isLandscapeLeft = note.data
  self:DoMobileScreenAdaptionAnchors()
  for _, layer in pairs(self.layers) do
    layer:DisposeCachedNodeByShowHideMode(PanelShowHideMode.MoveOutAndMoveIn)
  end
end

function UIManagerProxy:GetMyMobileScreenAdaptionOffsets(isLandscapeLeft)
  local rotationType = isLandscapeLeft ~= false and 1 or 2
  local rotMap = self:GetMyMobileScreenAdaptionValue(rotationType)
  if not rotMap then
    if 1 < rotationType then
      rotMap = self:GetMyMobileScreenAdaptionValue(1)
      if rotMap then
        return rotMap.r, rotMap.b, rotMap.l, rotMap.t
      end
    end
    return nil
  end
  return rotMap.l, rotMap.t, rotMap.r, rotMap.b
end

function UIManagerProxy:GetMyMobileScreenAdaptionOfViewCtl(ctlName)
  local specialViewMap = self:GetMyMobileScreenAdaptionValue("SpecialView")
  if not specialViewMap or not ctlName then
    return nil
  end
  for name, data in pairs(specialViewMap) do
    if name == ctlName then
      return data
    end
  end
  return nil
end

function UIManagerProxy:GetMyMobileScreenAdaptionValue(key)
  if not self.mobileScreenAdaptionMap then
    return nil
  end
  return self.mobileScreenAdaptionMap[key]
end

function UIManagerProxy:GetMyMobileScreenSize(exVal)
  exVal = exVal or 0
  local screen = NGUITools.screenSize
  local aspect = screen.x / screen.y
  if self.uiFitType == UIFitType.Width then
    return 1280 + exVal, 1280 / aspect + exVal
  else
    return 720 * aspect + exVal, 720 + exVal
  end
end

function UIManagerProxy:TrySetupViewMaskAdaption(viewClass, layer)
  if not viewClass or not layer then
    return
  end
  local viewType, viewMaskAdaption = viewClass.ViewType, viewClass.ViewMaskAdaption
  if not viewType then
    return
  end
  if viewMaskAdaption and not self.viewMaskObj then
    self.viewMaskObj = Game.AssetManager_UI:CreateAsset("GUI/v1/part/ViewMaskAdaptionStrips")
    if not self.viewMaskObj then
      LogUtility.Error("Cannot create ViewMaskAdaptionStrips")
      return
    end
    self.viewMaskTrans = self.viewMaskObj.transform
    self.viewMaskTrans:SetParent(self.UIRoot.transform, false)
    self.viewMaskPanel = self.viewMaskObj:GetComponent(UIPanel)
  end
  if self.viewMaskWorkingViewClass and self.viewMaskWorkingViewClass.ViewType.name ~= viewType.name then
    return
  end
  if self.viewMaskObj then
    self.viewMaskObj:SetActive(viewMaskAdaption ~= nil)
    self.viewMaskPanel.depth = layer:UINodeStartDepth() + layer.depthGap
    self.viewMaskWorkingViewClass = viewMaskAdaption and viewClass
    if viewMaskAdaption then
      local child, allActive
      if viewMaskAdaption.all then
        allActive = true
      else
        allActive = false
      end
      for i = 1, self.viewMaskTrans.childCount do
        child = self.viewMaskTrans:GetChild(i - 1)
        child.gameObject:SetActive(allActive)
      end
      for goName, value in pairs(viewMaskAdaption) do
        child = Game.GameObjectUtil:DeepFind(self.viewMaskObj, goName)
        if child and value then
          child:SetActive(true)
        end
      end
    end
  end
end

local getCName = function(cls)
  return cls and cls.__cname
end

function UIManagerProxy:TryHideViewMaskAdaptionByCtrl(viewCtrl)
  local viewName = getCName(viewCtrl)
  if getCName(self.viewMaskWorkingViewClass) ~= viewName then
    return
  end
  self:_HideViewMaskAdaption()
end

function UIManagerProxy:TryHideViewMaskAdaptionByType(viewType)
  local viewTypeName = viewType and viewType.name
  if not viewTypeName then
    return
  end
  local workingViewTypeName = self.viewMaskWorkingViewClass and self.viewMaskWorkingViewClass.ViewType.name
  if viewTypeName ~= workingViewTypeName then
    return
  end
  self:_HideViewMaskAdaption()
end

function UIManagerProxy:_HideViewMaskAdaption()
  self.viewMaskWorkingViewClass = nil
  if self.viewMaskObj then
    self.viewMaskObj:SetActive(false)
  end
end

XDEUIEvent = {
  RoleBack = "XDERoleBack",
  CreateBack = "XDECreateBack",
  SignInMapViewBack = "SignInMapViewBack",
  ChargeLimitPanelBack = "ChargeLimitPanelBack",
  CreditNodeBack = "CreditNodeBack",
  ChatEmpty = "ChatEmpty",
  CloseCharTitle = "CloseCharTitle",
  LotteryAnimationEnd = "LotteryAnimationEnd",
  CloseCreateRoleTip = "CloseCreateRoleTip",
  CloseWebView = "XDECloseWebView",
  CloseHappyShopView = "CloseHappyShopView",
  CloseGuidePanel = "CloseGuidePanel"
}

function UIManagerProxy:HasUINodeByName(panelConfig)
  local class = panelConfig and self:GetImport(panelConfig.class)
  if class ~= nil and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      return layer:FindNodeByName(panelConfig.class) ~= nil
    end
  end
  return false
end

function UIManagerProxy.CSPopView(noExitGame)
  if UIManagerProxy.Instance:HasUINodeByName(PanelConfig.WebViewPanel) then
    LogUtility.Info("WebViewPanel")
    GameFacade.Instance:sendNotification(XDEUIEvent.CloseWebView)
    return
  end
  local count = UIManagerProxy.Instance:GetModalPopCount()
  local uIViewAchievementPopupTip = UIViewAchievementPopupTip.Instance
  if count == 0 then
    local viewClass = UIManagerProxy.Instance:GetImport("DialogView")
    if viewClass then
      local viewType = viewClass.ViewType
      local layer = UIManagerProxy.Instance:GetLayerByType(viewType)
      if layer then
        local tmp = layer:FindNodeByName("DialogView")
        if tmp ~= nil then
          MsgManager.FloatMsg("", ZhString.Oversea_Msg_1)
          return
        else
          helplog("没找到 DialogView")
        end
      end
    end
    if uIViewAchievementPopupTip ~= nil and uIViewAchievementPopupTip.isShowing == true then
      uIViewAchievementPopupTip:StopShowAchievementPopupTip()
    elseif UIManagerProxy.Instance:HasUINode(PanelConfig.RolesSelect) then
      GameFacade.Instance:sendNotification(XDEUIEvent.RoleBack)
    elseif UnityEngine.GameObject.Find("CreateRoleViewV2") then
      GameFacade.Instance:sendNotification(XDEUIEvent.CreateBack)
    elseif UIManagerProxy.Instance:HasUINode(PanelConfig.NewServerSignInMapView) then
      GameFacade.Instance:sendNotification(XDEUIEvent.SignInMapViewBack)
    elseif UIManagerProxy.Instance:HasUINodeByName(PanelConfig.NewCreateRoleView) then
      GameFacade.Instance:sendNotification(XDEUIEvent.CreateBack)
    elseif UIManagerProxy.Instance:HasUINodeByName(PanelConfig.GuidePanel) then
      GameFacade.Instance:sendNotification(XDEUIEvent.CloseGuidePanel)
    elseif not noExitGame then
      UIUtil.PopUpConfirmYesNoView(ZhString.NoticeTitle, ZhString.STR_CONFIRM_EXIT_GAME, function()
        OverSeas_TW.OverSeasManager.GetInstance():TryKillSelf()
      end, function()
      end, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
    end
  elseif uIViewAchievementPopupTip ~= nil and uIViewAchievementPopupTip.isShowing == true then
    uIViewAchievementPopupTip:StopShowAchievementPopupTip()
  elseif UIManagerProxy.Instance:HasUINodeByName(PanelConfig.ChargeLimitPanel) then
    GameFacade.Instance:sendNotification(XDEUIEvent.ChargeLimitPanelBack)
    GameFacade.Instance:sendNotification(XDEUIEvent.CreditNodeBack)
  elseif UIManagerProxy.Instance:HasUINodeByName(PanelConfig.HappyShop) then
    GameFacade.Instance:sendNotification(XDEUIEvent.CloseHappyShopView)
  else
    local bubbleTipsCount = TableUtility.Count(TipManager.Instance.bubbleTips)
    if 0 < bubbleTipsCount then
      TipManager.Instance:CloseBubbleTip()
      return
    end
    UIManagerProxy.Instance:PopView()
  end
end

function UIManagerProxy:LockAndroidKey(lock)
  self.isLockAndroidKey = lock
end

function UIManagerProxy:IsLockAndroidKey()
  return self.isLockAndroidKey
end

function UIManagerProxy:Clear()
  for k, v in pairs(self.layers) do
    v:Dispose()
  end
  self.layers = nil
  if not Slua.IsNull(self.UIRoot) then
    GameObject.Destroy(self.UIRoot)
  end
  self.UIRoot = nil
  self.isLockAndroidKey = false
  self.childPopMap = {}
  self.childPopCount = 0
  self:NeedEnableAndroidKey(false)
end

function UIManagerProxy:RefitSceneModel(cameraTrans, modelBgTrans)
  local rootSize = self:GetUIRootSize()
  local perfectRatio = 1.7777777777777777
  local lowerRatio = 1.3333333333333333
  local curRatio = rootSize[1] / rootSize[2]
  local ratioPercent = math.clamp((curRatio - lowerRatio) / (perfectRatio - lowerRatio), 0, 1)
  local vecCameraPos = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(cameraTrans))
  vecCameraPos.z = -414 + 2 * ratioPercent
  cameraTrans.localPosition = vecCameraPos
  if modelBgTrans then
    modelBgTrans.localPosition = LuaGeometry.GetTempVector3(0.2 - 0.2 * ratioPercent, 43.2, -387 - 4 * ratioPercent)
  end
end

function UIManagerProxy:ReturenToMainView()
  for i = 1, #self.modalLayer do
    self:CloseLayerAllChildren(self.modalLayer[i])
  end
end
