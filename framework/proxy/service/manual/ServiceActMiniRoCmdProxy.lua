autoImport("ServiceActMiniRoCmdAutoProxy")
ServiceActMiniRoCmdProxy = class("ServiceActMiniRoCmdProxy", ServiceActMiniRoCmdAutoProxy)
ServiceActMiniRoCmdProxy.Instance = nil
ServiceActMiniRoCmdProxy.NAME = "ServiceActMiniRoCmdProxy"
ServiceActMiniRoCmdProxy.CreateDiceModelEvent = "CreateDiceModel"

function ServiceActMiniRoCmdProxy:ctor(proxyName)
  if ServiceActMiniRoCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActMiniRoCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActMiniRoCmdProxy.Instance = self
  end
end

function ServiceActMiniRoCmdProxy:CallActMiniRoCastDice(type, step)
  MiniROProxy.Instance:SetIsMoving(true)
  if MiniROProxy.Instance:IsShowAnim() then
    self:Notify(ServiceActMiniRoCmdProxy.CreateDiceModelEvent, type)
  end
  ServiceActMiniRoCmdProxy.super.CallActMiniRoCastDice(self, type, step)
end

function ServiceActMiniRoCmdProxy:CallActMiniRoEventFAQS(questionid, answer, result)
  MiniROProxy.Instance:SetIsMoving(false)
  ServiceActMiniRoCmdProxy.super.CallActMiniRoEventFAQS(self, questionid, answer, result)
end

function ServiceActMiniRoCmdProxy:RecvActMiniRoOpenPage(data)
  MiniROProxy.Instance:RecvActMiniRoOpenPage(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoOpenPage, data)
end

function ServiceActMiniRoCmdProxy:RecvActMiniRoDiceSync(data)
  MiniROProxy.Instance:SetFreeDiceData(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoDiceSync, data)
end

function ServiceActMiniRoCmdProxy:RecvActMiniRoEventFAQS(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoEventFAQS, data)
end
