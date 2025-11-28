SubView = class("SubView", CoreView)

function SubView:ctor(container, initParama, subViewData)
  self.container = container
  if self.container then
    self.viewdata = self.container.viewdata
  end
  self.subViewData = subViewData
  SubView.super.ctor(self, container.gameObject)
  self:Init(initParama)
end

function SubView:ReLoadPerferb(path, keepDepth)
  local preferb = self:LoadPreferb(path)
  preferb.transform:SetParent(self.container.trans, false)
  self.trans = preferb.transform
  self.gameObject = preferb
  if keepDepth then
    return
  end
  local panel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
end

function SubView:OpenHelpView(data)
  if data == nil then
    local id = self.viewdata.view.id
    if self.subViewData then
      id = self.subViewData.id
    end
    data = Table_Help[id]
  end
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  else
  end
end

function SubView:Init()
end

function SubView:AddListenEvt(evt, func)
  self.container:AddPageListenEvt(self, evt, func)
end

function SubView:AddSubView(key, view, initParama)
  self.viewMap = self.viewMap or {}
  if key ~= nil and view ~= nil then
    self.viewMap[key] = view.new(self.container, initParama)
    if self.onEnterCalled then
      self.viewMap[key]:OnEnter()
    end
  end
  return self.viewMap[key]
end

function SubView:RemoveSubView(key)
  if nil ~= key then
    local subView = self.viewMap[key]
    if subView then
      self.viewMap[key] = nil
      subView:OnExit()
      if self.ListenerEvtMap then
        for evtname, pageEvts in pairs(self.ListenerEvtMap) do
          if type(pageEvts) == "table" then
            pageEvts[subView] = nil
          end
        end
      end
      if not self:ObjIsNil(subView.gameObject) then
        GameObject.Destroy(subView.gameObject)
      end
    end
  end
end

function SubView:GetSubView(key)
  return self.viewMap and self.viewMap[key] or nil
end

function SubView:AddButtonEvent(name, evt)
  self.container:AddButtonEvent(name, evt)
end

function SubView:AddDispatcherEvt(evtname, func)
  self.disPatherEvt = self.disPatherEvt or {}
  self.disPatherEvt[evtname] = func
end

function SubView:sendNotification(notificationName, body, type)
  self.container:sendNotification(notificationName, body, type)
end

function SubView:RegisterRedTipCheck(id, uiwidget, depth, offset, side, subtipid)
  self.container:RegisterRedTipCheck(id, uiwidget, depth, offset, side, subtipid)
end

function SubView:RegisterRedTipCheckByIds(ids, uiwidget, depth, offset, side)
  self.container:RegisterRedTipCheckByIds(ids, uiwidget, depth, offset, side)
end

function SubView:UnRegisterSingleRedTipCheck(id, uiwidget)
  self.container:UnRegisterSingleRedTipCheck(id, uiwidget)
end

function SubView:UnRegisterRedTipChecksByWidget(uiwidget)
  self.container:UnRegisterRedTipChecksByWidget(uiwidget)
end

function SubView:DelayCall(callback, delayTime, param1, param2)
  self.container:DelayCall(callback, delayTime, param1, param2)
end

function SubView:OnEnter()
  if self.container then
    self.viewdata = self.container.viewdata
  end
  if self.disPatherEvt ~= nil then
    for evt, func in pairs(self.disPatherEvt) do
      EventManager.Me():AddEventListener(evt, func, self)
    end
  end
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnEnter()
    end
  end
  self.onEnterCalled = true
end

function SubView:OnExit()
  if self.disPatherEvt ~= nil then
    for evt, func in pairs(self.disPatherEvt) do
      EventManager.Me():RemoveEventListener(evt, func, self)
    end
    self.disPatherEvt = nil
  end
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnExit()
    end
  end
  self:DestroyUIEffects()
end

function SubView:OnDestroy()
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnDestroy()
    end
  end
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
  if self.coreTabMap then
    for k, v in pairs(self.coreTabMap) do
      ReusableTable.DestroyAndClearTable(v)
    end
    ReusableTable.DestroyAndClearTable(self.coreTabMap)
  end
end

function SubView:AddTabChangeEvent(tabGO, targetGO, script)
  if not self.coreTabMap then
    self.coreTabMap = ReusableTable.CreateTable()
  end
  local key = tabGO.name
  if not self.coreTabMap[key] then
    local tb = ReusableTable.CreateTable()
    tb.obj = targetGO
    tb.script = script
    tb.tabGO = tabGO
    self.coreTabMap[key] = tb
    self:AddClickEvent(tabGO, function(go)
      self:TabChangeHandler(go.name)
    end)
  end
end

function SubView:TabChangeHandler(key)
  if self.coreTabMap and self.currentKey ~= key then
    self.currentKey = key
    for k, v in pairs(self.coreTabMap) do
      if k == key then
        v.obj:SetActive(true)
        v.script:OnTabEnabled()
      else
        v.obj:SetActive(false)
        v.script:OnTabDisabled()
      end
    end
  end
end

function SubView:UpdateCurrentTabView()
  if self.currentKey then
    local view = self.coreTabMap[self.currentKey]
    if view then
      view.script:UpdateView()
    end
  end
end

function SubView:OnHide()
end

function SubView:OnShow()
end
