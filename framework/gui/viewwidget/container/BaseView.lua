autoImport("TabView")
BaseView = class("BaseView", TabView)
BaseView.ViewType = UIViewType.NormalBg

function BaseView:ctor(viewObj, viewdata, uiMediator)
  BaseView.super.ctor(self, viewObj)
  self.viewdata = viewdata
  self.filtersWhenViewOpen = self.viewdata.view and GameConfig.FilterType.UIFilter[self.viewdata.view.id] or nil
  self.uiMediator = uiMediator
  self.viewName = viewdata.viewname
  self.disPatherEvt = {}
  self:AddCloseButtonEvent()
  self:Init()
end

function BaseView:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end

function BaseView:MediatorReActive()
  return true
end

function BaseView:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if type(viewdata) == "table" then
    self.tabIndex = viewdata.tabIndex
    self.tabId = viewdata.tabId
  end
end

function BaseView:OnShow()
end

function BaseView:OnHide()
  self:HandleGuide()
end

function BaseView:OnEnter()
  if self.filtersWhenViewOpen ~= nil then
    FunctionSceneFilter.Me():StartFilter(self.filtersWhenViewOpen)
  end
  if self.disPatherEvt ~= nil then
    for evt, func in pairs(self.disPatherEvt) do
      EventManager.Me():AddEventListener(evt, func, self)
    end
  end
  local viewdata = self.viewdata and self.viewdata.viewdata
  if type(viewdata) == "table" then
    if viewdata.isNpcFuncView then
      FunctionVisitNpc.Me():AddVisitRef()
    end
    local endCallback = viewdata.callbackList
    if endCallback then
      self.callbackList = endCallback
    end
  end
end

function BaseView:OnExit()
  self:UnRegisterAllGuideTarget()
  self:UnRegisterRedTipChecks()
  if self.filtersWhenViewOpen ~= nil then
    FunctionSceneFilter.Me():EndFilter(self.filtersWhenViewOpen)
  end
  if self.disPatherEvt ~= nil then
    for evt, func in pairs(self.disPatherEvt) do
      EventManager.Me():RemoveEventListener(evt, func, self)
    end
    self.disPatherEvt = nil
  end
  self:HandleGuide()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if type(viewdata) == "table" and viewdata.isNpcFuncView then
    FunctionVisitNpc.Me():RemoveVisitRef()
  end
  if self.callbackList then
    for i = 1, #self.callbackList do
      local endfunc = self.callbackList[i]
      local func = endfunc.func
      local param = endfunc.param
      local npc = endfunc.npc
      func(npc, param)
    end
    self.callbackList = nil
  end
  self:UnRegisterChildPopObj()
  self:RemoveMonoUpdateFunction()
  self:RemoveMonoLateUpdateFunction()
  self:RemoveAllDelayCall()
  self:UnRegisterChildPopObj()
  self:DestroyUIEffects()
end

function BaseView:OnDestroy()
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
  self.__destroyed = true
end

function BaseView:RegisterRedTipCheck(id, uiwidget, depth, offset, side, subtipid)
  if id == nil then
    id = 0
    Debug.LogError(string.format("注册红点失败(id不能为空).\n %s", debug.traceback()))
  end
  self.RedTipChecks = self.RedTipChecks or {}
  local checks = self.RedTipChecks[id]
  if not checks then
    checks = {}
    self.RedTipChecks[id] = checks
  end
  if checks[uiwidget] == nil then
    checks[uiwidget] = uiwidget
    RedTipProxy.Instance:RegisterUI(id, uiwidget, depth, offset, side, subtipid)
  end
end

function BaseView:RegisterRedTipCheckByIds(ids, uiwidget, depth, offset, side)
  if ids then
    for i = 1, #ids do
      self:RegisterRedTipCheck(ids[i], uiwidget, depth, offset, side)
    end
  end
end

function BaseView:UnRegisterRedTipChecks()
  if self.RedTipChecks then
    for k, v in pairs(self.RedTipChecks) do
      for kui, vui in pairs(v) do
        RedTipProxy.Instance:UnRegisterUI(k, vui)
      end
    end
    self.RedTipChecks = nil
  end
end

function BaseView:UnRegisterSingleRedTipCheck(id, uiwidget)
  if not self.RedTipChecks then
    return
  end
  local checks = self.RedTipChecks[id]
  if not checks then
    return
  end
  if checks[uiwidget] then
    RedTipProxy.Instance:UnRegisterUI(id, uiwidget)
    checks[uiwidget] = nil
  end
end

function BaseView:UnRegisterRedTipChecksByWidget(uiwidget)
  if not self.RedTipChecks then
    return
  end
  local ids = {}
  for id, checks in pairs(self.RedTipChecks) do
    for _widget, _swidget in pairs(checks) do
      if _widget == uiwidget then
        ids[id] = 1
        checks[_widget] = nil
      end
    end
  end
  for id, _ in pairs(ids) do
    RedTipProxy.Instance:UnRegisterUI(id, uiwidget)
  end
end

function BaseView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
end

function BaseView:CloseSelf()
  if self.__destroyed then
    return
  end
  if self.uiMediator == nil then
    return
  end
  self:sendNotification(UIEvent.CloseUI, self)
end

function BaseView:AddListenEvt(interest, func)
  if interest then
    self.interests = self.interests or {}
    table.insert(self.interests, interest)
    self.ListenerEvtMap = self.ListenerEvtMap or {}
    self.ListenerEvtMap[interest] = func
  else
    printRed("Event name is nil")
  end
end

function BaseView:AddDispatcherEvt(evtname, func)
  self.disPatherEvt = self.disPatherEvt or {}
  self.disPatherEvt[evtname] = func
end

function BaseView:sendNotification(notificationName, body, type)
  self.uiMediator:sendNotification(notificationName, body, type)
end

function BaseView:GotoView(data)
  self:sendNotification(UIEvent.JumpPanel, data)
end

function BaseView:CheckViewCanOpen(id)
  return FunctionUnLockFunc.Me():CheckCanOpenByPanelId(id)
end

function BaseView:RegisterChildPopObj(obj)
  UIManagerProxy.Instance:RegisterChildPopObj(self.ViewType, obj)
end

function BaseView:UnRegisterChildPopObj(obj)
  UIManagerProxy.Instance:UnRegisterChildPopObj(self.ViewType)
end

function BaseView:listNotificationInterests()
  return self.interests or {}
end

function BaseView:handleNotification(note)
  if self.ListenerEvtMap ~= nil then
    local evt = self.ListenerEvtMap[note.name]
    if evt ~= nil then
      evt(self, note)
    end
  end
end

function BaseView:AddMonoLateUpdateFunction(func)
  if self.haveMonoLateUpdateFunc then
    return
  end
  Game.GUISystemManager:AddMonoLateUpdateFunction(func, self)
  self.haveMonoLateUpdateFunc = true
end

function BaseView:RemoveMonoLateUpdateFunction()
  if not self.haveMonoLateUpdateFunc then
    return
  end
  Game.GUISystemManager:ClearMonoLateUpdateFunction(self)
  self.haveMonoLateUpdateFunc = nil
end

function BaseView:DelayCall(callback, delayTime, param1, param2)
  FunctionUtility.Me():DelayCall(callback, delayTime, self, param1, param2)
  self.haveDelayCall = true
end

function BaseView:RemoveAllDelayCall()
  if not self.haveDelayCall then
    return
  end
  FunctionUtility.Me():CancelDelayCallByMark(self)
  self.haveDelayCall = nil
end

function BaseView:HandleGuide()
  if not GuideProxy then
    return
  end
  if self.ViewType then
    local list = GuideProxy.Instance:getGuideListByViewName(self.__cname)
    if list then
      FunctionGuide.Me():checkGuideStateWhenExit(list)
    end
  end
end

function BaseView:NeedPushToStack()
  return self.pushToStack == true
end

function BaseView:SetPushToStack(b)
  self.pushToStack = b
end
