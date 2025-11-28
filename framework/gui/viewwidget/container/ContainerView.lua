ContainerView = class("ContainerView", BaseView)
ContainerView.ViewType = UIViewType.NormalLayer

function ContainerView:AddSubView(key, view, initParama, subViewData)
  self.viewMap = self.viewMap or {}
  if key ~= nil and view ~= nil then
    self.viewMap[key] = view.new(self, initParama, subViewData)
    if self.onEnterCalled then
      self.viewMap[key]:OnEnter()
    end
  end
  return self.viewMap[key]
end

function ContainerView:RemoveSubView(key)
  if nil ~= key then
    local subView = self.viewMap[key]
    if subView then
      self.viewMap[key] = nil
      if subView.OnExit then
        subView:OnExit()
      end
      if self.ListenerEvtMap then
        for evtname, pageEvts in pairs(self.ListenerEvtMap) do
          if type(pageEvts) == "table" then
            pageEvts[subView] = nil
          end
        end
      end
      if not self:ObjIsNil(subView.gameObject) and subView.gameObject ~= self.gameObject then
        GameObject.Destroy(subView.gameObject)
      end
    end
  end
end

function ContainerView:OnShow()
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      if o.OnShow ~= nil then
        o:OnShow()
      end
    end
  end
end

function ContainerView:OnHide()
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      if o.OnHide ~= nil then
        o:OnHide()
      end
    end
  end
end

function ContainerView:OnEnter()
  ContainerView.super.OnEnter(self)
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnEnter()
    end
  end
  self.onEnterCalled = true
end

function ContainerView:OnExit()
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnExit()
    end
  end
  ContainerView.super.OnExit(self)
end

function ContainerView:OnDestroy()
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnDestroy()
    end
  end
  ContainerView.super.OnDestroy(self)
end

function ContainerView:AddListenEvt(evtname, func)
  self:AddPageListenEvt(self, evtname, func)
end

function ContainerView:AddPageListenEvt(page, evtname, func)
  self.ListenerEvtMap = self.ListenerEvtMap or {}
  self.interests = self.interests or {}
  if evtname then
    if self.ListenerEvtMap[evtname] == nil then
      self.ListenerEvtMap[evtname] = {}
      table.insert(self.interests, evtname)
    end
    self.ListenerEvtMap[evtname][page] = func
  else
    printRed("Event name is nil")
  end
end

function ContainerView:handleNotification(note)
  if self.ListenerEvtMap ~= nil then
    local evts = self.ListenerEvtMap[note.name]
    if evts ~= nil then
      for page, func in pairs(evts) do
        if page ~= nil and func ~= nil then
          func(page, note)
        end
      end
    end
  end
end
