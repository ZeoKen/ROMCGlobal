autoImport("ServiceBattlePassAutoProxy")
ServiceBattlePassProxy = class("ServiceBattlePassProxy", ServiceBattlePassAutoProxy)
ServiceBattlePassProxy.Instance = nil
ServiceBattlePassProxy.NAME = "ServiceBattlePassProxy"

function ServiceBattlePassProxy:ctor(proxyName)
  if ServiceBattlePassProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBattlePassProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBattlePassProxy.Instance = self
  end
end

function ServiceBattlePassProxy:RecvUpdateRewardBattlePassCmd(data)
  BattlePassProxy.Instance:RecvUpdateRewardBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassUpdateRewardBattlePassCmd, data)
end

function ServiceBattlePassProxy:RecvAdvanceBattlePassCmd(data)
  BattlePassProxy.Instance:RecvAdvanceBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassAdvanceBattlePassCmd, data)
end

function ServiceBattlePassProxy:RecvSyncInfoBattlePassCmd(data)
  BattlePassProxy.Instance:RecvSyncInfoBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassSyncInfoBattlePassCmd, data)
end

function ServiceBattlePassProxy:RecvBattlePassQuestInfoCmd(data)
  redlog("ServiceBattlePassProxy:RecvBattlePassQuestInfoCmd")
  BattlePassProxy.Instance:UpdateBattlePassTask(data.quests)
  self:Notify(ServiceEvent.BattlePassBattlePassQuestInfoCmd, data)
end
