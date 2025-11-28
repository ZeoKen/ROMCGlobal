autoImport("ServiceUserShowAutoProxy")
ServiceUserShowProxy = class("ServiceUserShowProxy", ServiceUserShowAutoProxy)
ServiceUserShowProxy.Instance = nil
ServiceUserShowProxy.NAME = "ServiceUserShowProxy"

function ServiceUserShowProxy:ctor(proxyName)
  if ServiceUserShowProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserShowProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserShowProxy.Instance = self
  end
end

function ServiceUserShowProxy:RecvSyncAllPhotoFrame(data)
  ChangeHeadProxy.Instance:RecvSyncAllPhotoFrame(data)
  self:Notify(ServiceEvent.UserShowSyncAllPhotoFrame, data)
end

function ServiceUserShowProxy:RecvSyncAllBackgroundFrame(data)
  ChangeHeadProxy.Instance:RecvSyncAllBackgroundFrame(data)
  self:Notify(ServiceEvent.UserShowSyncAllBackgroundFrame, data)
end

function ServiceUserShowProxy:RecvUnlockPhotoFrame(data)
  ChangeHeadProxy.Instance:RecvUnlockPhotoFrame(data)
  self:Notify(ServiceEvent.UserShowUnlockPhotoFrame, data)
end

function ServiceUserShowProxy:RecvUnlockBackgroundFrame(data)
  ChangeHeadProxy.Instance:RecvUnlockBackgroundFrame(data)
  self:Notify(ServiceEvent.UserShowUnlockBackgroundFrame, data)
end

function ServiceUserShowProxy:RecvSyncUnlockChatFrame(data)
  ChangeHeadProxy.Instance:RecvSyncUnlockChatFrame(data)
  self:Notify(ServiceEvent.UserShowSyncUnlockChatFrame, data)
end
