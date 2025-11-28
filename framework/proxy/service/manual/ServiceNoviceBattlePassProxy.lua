autoImport("ServiceNoviceBattlePassAutoProxy")
ServiceNoviceBattlePassProxy = class("ServiceNoviceBattlePassProxy", ServiceNoviceBattlePassAutoProxy)
ServiceNoviceBattlePassProxy.Instance = nil
ServiceNoviceBattlePassProxy.NAME = "ServiceNoviceBattlePassProxy"

function ServiceNoviceBattlePassProxy:ctor(proxyName)
  if ServiceNoviceBattlePassProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNoviceBattlePassProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNoviceBattlePassProxy.Instance = self
  end
end

function ServiceNoviceBattlePassProxy:RecvNoviceBPTargetUpdateCmd(data)
  redlog("ServiceNoviceBattlePassProxy:RecvNoviceBPTargetUpdateCmd", tostring(data.end_time))
  NoviceBattlePassProxy.Instance:UpdateNoviceBPTarget(data)
  self:Notify(ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd, data)
end

function ServiceNoviceBattlePassProxy:RecvReturnBpTargetUpdateCmd(data)
  NoviceBattlePassProxy.Instance:UpdateReturnBPTarget(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd, data)
end

function ServiceNoviceBattlePassProxy:RecvNoviceBPRewardUpdateCmd(data)
  redlog("ServiceNoviceBattlePassProxy:RecvNoviceBPRewardUpdateCmd")
  NoviceBattlePassProxy.Instance:UpdateNoviceBPLevelRewardData(data)
  self:Notify(ServiceEvent.NoviceBattlePassNoviceBPRewardUpdateCmd, data)
end

function ServiceNoviceBattlePassProxy:RecvReturnBPRewardUpdateCmd(data)
  NoviceBattlePassProxy.Instance:UpdateReturnBPLevelRewardData(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBPRewardUpdateCmd, data)
end

function ServiceNoviceBattlePassProxy:RecvChallengeTargetUpdateCmd(data)
  helplog("RecvChallengeTargetUpdateCmd data count: ", #data.datas)
  TopicProxy.Instance:HandleServantTarget(data.datas)
  self:Notify(ServiceEvent.NoviceBattlePassChallengeTargetUpdateCmd, data)
end
