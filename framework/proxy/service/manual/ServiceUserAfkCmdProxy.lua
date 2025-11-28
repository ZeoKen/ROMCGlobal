autoImport("ServiceUserAfkCmdAutoProxy")
ServiceUserAfkCmdProxy = class("ServiceUserAfkCmdProxy", ServiceUserAfkCmdAutoProxy)
ServiceUserAfkCmdProxy.Instance = nil
ServiceUserAfkCmdProxy.NAME = "ServiceUserAfkCmdProxy"

function ServiceUserAfkCmdProxy:ctor(proxyName)
  if ServiceUserAfkCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserAfkCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserAfkCmdProxy.Instance = self
  end
end

function ServiceUserAfkCmdProxy:RecvSyncStatInfoAfkCmd(data)
  AfkProxy.Instance:ShowAfkMsgInSystemChat(data)
  self.super:RecvSyncStatInfoAfkCmd(data)
end
