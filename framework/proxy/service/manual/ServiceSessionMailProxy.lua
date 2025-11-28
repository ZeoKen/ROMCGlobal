autoImport("ServiceSessionMailAutoProxy")
ServiceSessionMailProxy = class("ServiceSessionMailProxy", ServiceSessionMailAutoProxy)
ServiceSessionMailProxy.Instance = nil
ServiceSessionMailProxy.NAME = "ServiceSessionMailProxy"

function ServiceSessionMailProxy:ctor(proxyName)
  if ServiceSessionMailProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionMailProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionMailProxy.Instance = self
  end
end

function ServiceSessionMailProxy:RecvQueryAllMail(data)
  PostProxy.Instance:AddUpdatePostDatas(data.datas)
  self:Notify(ServiceEvent.SessionMailQueryAllMail, data)
end

function ServiceSessionMailProxy:RecvMailUpdate(data)
  PostProxy.Instance:HandlePostUpdate(data.updates, data.dels)
end
