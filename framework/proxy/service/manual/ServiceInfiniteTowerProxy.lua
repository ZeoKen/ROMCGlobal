autoImport("ServiceInfiniteTowerAutoProxy")
ServiceInfiniteTowerProxy = class("ServiceInfiniteTowerProxy", ServiceInfiniteTowerAutoProxy)
ServiceInfiniteTowerProxy.Instance = nil
ServiceInfiniteTowerProxy.NAME = "ServiceInfiniteTowerProxy"

function ServiceInfiniteTowerProxy:ctor(proxyName)
  if ServiceInfiniteTowerProxy.Instance == nil then
    self.proxyName = proxyName or ServiceInfiniteTowerProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceInfiniteTowerProxy.Instance = self
  end
end

function ServiceInfiniteTowerProxy:RecvTeamTowerSummaryCmd(data)
  EndlessTowerProxy.Instance:RecvTeamTowerSummary(data)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerSummaryCmd, data)
end

function ServiceInfiniteTowerProxy:RecvUserTowerInfoCmd(data)
  EndlessTowerProxy.Instance:RecvUserTowerInfo(data)
  self:Notify(ServiceEvent.InfiniteTowerUserTowerInfoCmd, data)
end

function ServiceInfiniteTowerProxy:RecvTowerInfoCmd(data)
  EndlessTowerProxy.Instance:RecvTowerInfo(data)
  self:Notify(ServiceEvent.InfiniteTowerTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerLayerSyncTowerCmd(data)
  EndlessTowerProxy.Instance:RecvTowerLayerSyncTowerCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTowerLayerSyncTowerCmd, data)
end

function ServiceInfiniteTowerProxy:RecvNewEverLayerTowerCmd(data)
  EndlessTowerProxy.Instance:RecvNewEverLayerTowerCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerNewEverLayerTowerCmd, data)
end

function ServiceInfiniteTowerProxy:RecvTeamTowerInviteCmd(data)
  FunctionPve.Me():HandleServerInvite(data.iscancel, data.entranceid, data.layer, data.lefttime)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerInviteCmd, data)
end

local reply

function ServiceInfiniteTowerProxy:RecvTeamTowerReplyCmd(data)
  reply = data.eReply == InfiniteTower_pb.ETOWERREPLY_AGREE
  FunctionPve.Me():HandleReplay(data.userid, reply, PveRaidType.InfiniteTower)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerReplyCmd, data)
end
