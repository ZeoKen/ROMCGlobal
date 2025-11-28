autoImport("ServicePveCardAutoProxy")
ServicePveCardProxy = class("ServicePveCardProxy", ServicePveCardAutoProxy)
ServicePveCardProxy.Instance = nil
ServicePveCardProxy.NAME = "ServicePveCardProxy"

function ServicePveCardProxy:ctor(proxyName)
  if ServicePveCardProxy.Instance == nil then
    self.proxyName = proxyName or ServicePveCardProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePveCardProxy.Instance = self
  end
end

function ServicePveCardProxy:CallQueryCardInfoCmd(cards)
  helplog("Call-->QueryCardInfoCmd")
  ServicePveCardProxy.super.CallQueryCardInfoCmd(self)
end

function ServicePveCardProxy:RecvQueryCardInfoCmd(data)
  helplog("Recv-->QueryCardInfoCmd")
  DungeonProxy.Instance:ReSetCardDatas(data.cards)
  self:Notify(ServiceEvent.PveCardQueryCardInfoCmd, data)
end

function ServicePveCardProxy:RecvSyncProcessPveCardCmd(data)
  helplog("Recv-->SyncProcessPveCardCmd index| cards_count | process |totalprocessï¼š ", data.card.index, #data.card.cardids, data.process, data.totalprocess)
  DungeonProxy.Instance:SyncProcessPveCard(data.card.index, data.card.cardids, data.process, data.totalprocess)
  self:Notify(ServiceEvent.PveCardSyncProcessPveCardCmd, data)
end

function ServicePveCardProxy:RecvUpdateProcessPveCardCmd(data)
  helplog("Recv-->UpdateProcessPveCardCmd process|totalprocess ", data.process, data.totalprocess)
  DungeonProxy.Instance:UpdateProcessPveCard(data.process, data.totalprocess)
  self:Notify(ServiceEvent.PveCardUpdateProcessPveCardCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.PveCardUpdateProcessPveCardCmd)
end

function ServicePveCardProxy:CallSelectPveCardCmd(index)
  helplog("Call->SelectPveCardCmd", index)
  ServicePveCardProxy.super.CallSelectPveCardCmd(self, index)
end

function ServicePveCardProxy:CallEnterPveCardCmd(configid)
  helplog("Call->EnterPveCardCmd", configid)
  ServicePveCardProxy.super.CallEnterPveCardCmd(self, configid)
end

function ServicePveCardProxy:RecvFinishPlayCardCmd(data)
  helplog("Recv-->FinishPlayCardCmd")
  DungeonProxy.Instance:UpdateProcessPveCard(0, 0)
  self:Notify(ServiceEvent.PveCardFinishPlayCardCmd, data)
end

function ServicePveCardProxy:RecvInvitePveCardCmd(data)
  FunctionPve.Me():HandleServerInvite(data.iscancel, data.entranceid, data.configid, data.lefttime)
  self:Notify(ServiceEvent.PveCardInvitePveCardCmd, data)
end

function ServicePveCardProxy:RecvReplyPveCardCmd(data)
  FunctionPve.Me():HandleReplay(data.charid, data.agree, PveRaidType.PveCard)
  self:Notify(ServiceEvent.PveCardReplyPveCardCmd, data)
end
