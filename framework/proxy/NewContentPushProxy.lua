NewContentPushProxy = class("NewContentPushProxy", pm.Proxy)
NewContentPushProxy.Instance = nil
NewContentPushProxy.NAME = "NewContentPushProxy"

function NewContentPushProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NewContentPushProxy.NAME
  if not NewContentPushProxy.Instance then
    NewContentPushProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self.contentIds = {}
end

function NewContentPushProxy:InitPushContentData(data)
  if not data.isclose then
    local versionId = data.serverid * 100 + data.version
    self.version = data.version
    local contentIds = GameConfig.VersionContent and GameConfig.VersionContent[versionId]
    if contentIds then
      self.contentIds = contentIds
      self.isfirst = data.isfirst
    end
    GameFacade.Instance:sendNotification(NewContentPushEvent.Push)
  end
end

function NewContentPushProxy:GetPushContentIds()
  return self.contentIds
end
