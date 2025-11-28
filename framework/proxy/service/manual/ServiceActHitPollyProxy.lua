autoImport("ServiceActHitPollyAutoProxy")
ServiceActHitPollyProxy = class("ServiceActHitPollyProxy", ServiceActHitPollyAutoProxy)
ServiceActHitPollyProxy.Instance = nil
ServiceActHitPollyProxy.NAME = "ServiceActHitPollyProxy"

function ServiceActHitPollyProxy:ctor(proxyName)
  if ServiceActHitPollyProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActHitPollyProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActHitPollyProxy.Instance = self
  end
end

function ServiceActHitPollyProxy:RecvActityQueryHitedList(data)
  ActivityHitPollyProxy.Instance:HandleQueryList(data)
  self:Notify(ServiceEvent.ActHitPollyActityQueryHitedList, data)
end

function ServiceActHitPollyProxy:RecvActivityHitPolly(data)
  ActivityHitPollyProxy.Instance:HandleHitPolly(data)
  self:Notify(ServiceEvent.ActHitPollyActivityHitPolly, data)
end

function ServiceActHitPollyProxy:RecvActityHitPollySync(data)
  ActivityHitPollyProxy.Instance:SetCurrentActivityID(data)
  self:Notify(ServiceEvent.ActHitPollyActityHitPollySync, data)
end

function ServiceActHitPollyProxy:RecvActityHitPollyNtfQuest(data)
  ActivityHitPollyProxy.Instance:HandleQuest(data.quests)
  self:Notify(ServiceEvent.ActHitPollyActityHitPollyNtfQuest, data)
end
