autoImport("EventDispatcher")
UINode = class("UINode", EventDispatcher)

function UINode:ctor(data, prefab, class, layer, needRollBack)
  self.data = data
  self.viewname = prefab or class or data.viewname
  self.layer = layer
  self.class = class
  self.needRollBack = needRollBack
  self.viewClass = UINode.GetImport(self.class or data.viewname)
  self.created = false
end

function UINode:ResetViewData(viewData)
  self.data = viewData
  if self.viewCtrl then
    self.viewCtrl.viewdata = self.data
  end
end

function UINode:Clone()
  local node = UINode.new(self.data, self.viewname, self.class, self.layer, self.needRollBack)
  return node
end

function UINode:Create()
  if not self.created then
    self.created = true
    self.gameObject = self:CreatViewPfb(self.viewname)
    self.mediator = UIMediator.new(self.data.mediatorName or self.viewname)
    if self.layer and not Game.GameObjectUtil:ObjectIsNULL(self.gameObject) and self.layer ~= nil then
      self.gameObject.transform:SetParent(self.layer.gameObject.transform, false)
    end
    self.viewCtrl = self.viewClass.new(self.gameObject, self.data, self.mediator)
    self.mediator:SetView(self.viewCtrl)
    self:RegisterMediator()
    self._panelUpdate = true
  end
end

function UINode.GetImport(viewname)
  local viewCtrl = _G[viewname]
  if not viewCtrl then
    viewCtrl = autoImport(viewname)
    if type(viewCtrl) ~= "table" then
      viewCtrl = _G[viewname]
    end
  end
  return viewCtrl
end

function UINode:CreatViewPfb(viewName)
  local viewBord = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView(viewName))
  return viewBord
end

function UINode:CanCoExist(node)
  if self.viewClass.BrotherView and self.viewClass.BrotherView == node.viewClass then
    return true
  elseif node.viewClass.BrotherView and node.viewClass.BrotherView == self.viewClass then
    return true
  elseif node.viewClass.ForceCoExist or self.viewClass.ForceCoExist then
    return true
  end
  return false
end

function UINode:GetUIPanels()
  if self.uipanels then
    return self.uipanels
  end
  self.uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  return self.uipanels
end

function UINode:SetDepth(depth)
  if not self.settedDepth then
    self.settedDepth = true
    local uipanels = self:GetUIPanels()
    table.sort(uipanels, function(l, r)
      return l.depth < r.depth
    end)
    local currentBaseDepth = uipanels[1].depth
    for i = 1, #uipanels do
      uipanels[i].depth = uipanels[i].depth + depth
    end
  end
  return depth + 1
end

function UINode:SetLayer(layer)
  self.layer = layer
end

function UINode:MediatorReActive()
  local val = self.viewCtrl:MediatorReActive()
  if val == nil then
    val = true
  end
  return val
end

function UINode:GetShowHideMode()
  local mode = self.viewCtrl and self.viewCtrl:GetShowHideMode()
  return mode or PanelShowHideMode.CreateAndDestroy
end

function UINode:IsShow()
  if not Game.GameObjectUtil:ObjectIsNULL(self.gameObject) then
    return self.gameObject.activeSelf
  end
end

function UINode:Show()
  if not Game.GameObjectUtil:ObjectIsNULL(self.gameObject) then
    self.gameObject:SetActive(true)
    self:OnShow()
  end
end

function UINode:OnShow()
  if self.viewCtrl and self.viewCtrl.OnShow ~= nil then
    self.viewCtrl:OnShow()
  end
end

function UINode:Hide()
  if not Game.GameObjectUtil:ObjectIsNULL(self.gameObject) then
    self.gameObject:SetActive(false)
    self:OnHide()
  end
end

function UINode:OnHide()
  if self.viewCtrl and self.viewCtrl.OnHide ~= nil then
    self.viewCtrl:OnHide()
  end
end

function UINode:OnEnter()
  self.viewCtrl:OnEnter()
  GameFacade.Instance:sendNotification(UIEvent.EnterView, self.viewCtrl)
  EventManager.Me():DispatchEvent(UIEvent.EnterView, self.viewCtrl)
end

function UINode:OnExit()
  GameFacade.Instance:sendNotification(UIEvent.ExitView, self.viewCtrl)
  EventManager.Me():DispatchEvent(UIEvent.ExitView, self.viewCtrl)
  self.viewCtrl:OnExit()
  self.uipanels = nil
end

function UINode:GetPanelNum()
  if not self.panelNum then
    local uipanels = self:GetUIPanels()
    self.panelNum = #uipanels
  end
  return self.panelNum
end

function UINode:RegisterMediator()
  if self.mediator then
    GameFacade.Instance:registerMediator(self.mediator)
  end
end

function UINode:UnRegisterMediator()
  if self.mediator then
    self.mediator:Dispose()
  end
end

function UINode:Dispose()
  self:UnRegisterMediator()
  self.mediator = nil
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
  end
  if self.viewCtrl then
    self.viewCtrl:OnDestroy()
  end
end

function UINode:ActivePanelUpdate(b)
  if BackwardCompatibilityUtil.CompatibilityMode_V35 then
    return
  end
  if self._panelUpdate == b then
    return
  end
  self._panelUpdate = b
  local uipanels = self:GetUIPanels()
  if uipanels == nil then
    return
  end
  for i = 1, #uipanels do
    if b then
      uipanels[i]:SetNFUpdate()
    else
      uipanels[i]:SetNFNotUpdate()
    end
  end
end

function UINode:NeedRollBack()
  return self.needRollBack
end

function UINode:NeedPushToStack()
  if self:IsForbidPushToStack() then
    return false
  end
  if self.viewCtrl and self.viewCtrl.NeedPushToStack then
    return self.viewCtrl:NeedPushToStack()
  end
  return false
end

function UINode:IsForbidPushToStack()
  if type(self.data.viewdata) == "table" and self.data.viewdata.isPreload then
    return true
  end
  return false
end

function UINode:CustomExit()
  if self.viewCtrl and self.viewCtrl.CustomExit then
    self.viewCtrl:CustomExit()
    return true
  end
  return false
end
