autoImport("ServiceQueueEnterCmdAutoProxy")
ServiceQueueEnterCmdProxy = class("ServiceQueueEnterCmdProxy", ServiceQueueEnterCmdAutoProxy)
ServiceQueueEnterCmdProxy.Instance = nil
ServiceQueueEnterCmdProxy.NAME = "ServiceQueueEnterCmdProxy"

function ServiceQueueEnterCmdProxy:ctor(proxyName)
  if ServiceQueueEnterCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceQueueEnterCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceQueueEnterCmdProxy.Instance = self
  end
end

function ServiceQueueEnterCmdProxy:RecvQueueEnterRetCmd(data)
  GvgProxy.Instance:RecvQueueEnterRetCmd(data)
  self:Notify(ServiceEvent.QueueEnterCmdQueueEnterRetCmd, data)
end

function ServiceQueueEnterCmdProxy:RecvQueueUpdateCountCmd(data)
  GvgProxy.Instance:RecvQueueUpdateCountCmd(data)
  self:Notify(ServiceEvent.QueueEnterCmdQueueUpdateCountCmd, data)
end
