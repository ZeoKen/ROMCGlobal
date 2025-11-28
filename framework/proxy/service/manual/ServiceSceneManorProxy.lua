autoImport("ServiceSceneManorAutoProxy")
ServiceSceneManorProxy = class("ServiceSceneManorProxy", ServiceSceneManorAutoProxy)
ServiceSceneManorProxy.Instance = nil
ServiceSceneManorProxy.NAME = "ServiceSceneManorProxy"

function ServiceSceneManorProxy:ctor(proxyName)
  if ServiceSceneManorProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneManorProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneManorProxy.Instance = self
  end
end

function ServiceSceneManorProxy:RecvBuildDataNtfManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingDatas(data.builds)
  ServiceSceneManorProxy.super.RecvBuildDataNtfManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvBuildLevelUpManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingData(data.build)
  ServiceSceneManorProxy.super.RecvBuildLevelUpManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvBuildDispatchManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingData(data.build)
  ServiceSceneManorProxy.super.RecvBuildDispatchManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvBuildLotteryManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingData(data.build)
  ServiceSceneManorProxy.super.RecvBuildLotteryManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvBuildCollectManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingData(data.build)
  ServiceSceneManorProxy.super.RecvBuildCollectManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvPartnerInfoManorCmd(data)
  ManorPartnerProxy.Instance:RecvPartnerInfoManorCmd(data.partnerinfos)
  ComodoBuildingProxy.Instance:RecvPartnerInfos(data.partnerinfos)
  ServiceSceneManorProxy.super.RecvPartnerInfoManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvPartnerIdleListManorCmd(data)
  RandomAIManager.Me():OnSceneManorPartnerIdleList(data)
  self:Notify(ServiceEvent.SceneManorPartnerIdleListManorCmd, data)
end

function ServiceSceneManorProxy:RecvPartnerIdleUpdateManorCmd(data)
  RandomAIManager.Me():OnSceneManorPartnerIdleUpdate(data)
  self:Notify(ServiceEvent.SceneManorPartnerIdleUpdateManorCmd, data)
end

function ServiceSceneManorProxy:RecvBuildQueryManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingData(data.build)
  ServiceSceneManorProxy.super.RecvBuildQueryManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvBuildForgeManorCmd(data)
  ComodoBuildingProxy.Instance:RecvBuildingData(data.build)
  ServiceSceneManorProxy.super.RecvBuildForgeManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvSmithInfoManorCmd(data)
  AierBlacksmithProxy.Instance:Recv_SmithInfoManorCmd(data)
  ServiceSceneManorProxy.super.RecvSmithInfoManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvSmithLevelUpManorCmd(data)
  AierBlacksmithProxy.Instance:Recv_SmithLevelUpManorCmd(data)
  ServiceSceneManorProxy.super.RecvSmithLevelUpManorCmd(self, data)
end

function ServiceSceneManorProxy:RecvSmithAcceptQuestManorCmd(data)
  AierBlacksmithProxy.Instance:Recv_SmithAcceptQuestManorCmd(data)
  ServiceSceneManorProxy.super.RecvSmithAcceptQuestManorCmd(self, data)
end
