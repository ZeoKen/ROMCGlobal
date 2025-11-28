SubMediatorView = class("SubMediatorView", SubView)

function SubMediatorView:OnEnter()
  self:RegisterMediator()
  SubMediatorView.super.OnEnter(self)
end

function SubMediatorView:OnExit()
  self:DisposeMediator()
  SubMediatorView.super.OnExit(self)
end

function SubMediatorView:RegisterMediator()
  if not self.subMediator then
    self.subMediator = UIMediator.new(self.__cname, self)
  end
  GameFacade.Instance:registerMediator(self.subMediator)
end

function SubMediatorView:DisposeMediator()
  if self.subMediator then
    self.subMediator:Dispose()
    self.subMediator = nil
  end
end

function SubMediatorView:AddListenEvt(interest, func)
  if interest then
    self.interests = self.interests or {}
    table.insert(self.interests, interest)
    self.ListenerEvtMap = self.ListenerEvtMap or {}
    self.ListenerEvtMap[interest] = func
  else
    printRed("Event name is nil")
  end
end

function SubMediatorView:listNotificationInterests()
  return self.interests or {}
end

function SubMediatorView:handleNotification(note)
  if self.ListenerEvtMap ~= nil then
    local evt = self.ListenerEvtMap[note.name]
    if evt ~= nil then
      evt(self, note)
    end
  end
end
