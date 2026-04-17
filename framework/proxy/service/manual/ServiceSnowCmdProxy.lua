autoImport("ServiceSnowCmdAutoProxy")
ServiceSnowCmdProxy = class("ServiceSnowCmdProxy", ServiceSnowCmdAutoProxy)
ServiceSnowCmdProxy.Instance = nil
ServiceSnowCmdProxy.NAME = "ServiceSnowCmdProxy"

function ServiceSnowCmdProxy:ctor(proxyName)
  if ServiceSnowCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSnowCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSnowCmdProxy.Instance = self
  end
end

function ServiceSnowCmdProxy:RecvSnowHeadQuerySnowCmd(data)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RecvSnowHeadQuerySnowCmd(data)
  end
  self:Notify(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowHeadLvupSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadLvupSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowHeadActiveSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadActiveSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowHeadModeChangeSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadModeChangeSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowHeadFashionSelectSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadFashionSelectSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowCrownActiveSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowCrownActiveSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvQuerySnowManualSnowCmd(data)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RecvQuerySnowManualSnowCmd(data)
  end
  self:Notify(ServiceEvent.SnowCmdQuerySnowManualSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowManualUpdateSnowCmd(data)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RecvSnowManualUpdateSnowCmd(data)
  end
  self:Notify(ServiceEvent.SnowCmdSnowManualUpdateSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowManualEquipUpdateSnowCmd(data)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RecvSnowManualEquipUpdateSnowCmd(data)
  end
  self:Notify(ServiceEvent.SnowCmdSnowManualEquipUpdateSnowCmd, data)
end

function ServiceSnowCmdProxy:RecvSnowManualStoneUpdateSnowCmd(data)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RecvSnowManualStoneUpdateSnowCmd(data)
  end
  self:Notify(ServiceEvent.SnowCmdSnowManualStoneUpdateSnowCmd, data)
end
