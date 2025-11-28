autoImport("ServiceComodoCmdAutoProxy")
ServiceComodoCmdProxy = class("ServiceComodoCmdProxy", ServiceComodoCmdAutoProxy)
ServiceComodoCmdProxy.Instance = nil
ServiceComodoCmdProxy.NAME = "ServiceComodoCmdProxy"

function ServiceComodoCmdProxy:ctor(proxyName)
  if ServiceComodoCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceComodoCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceComodoCmdProxy.Instance = self
  end
end
