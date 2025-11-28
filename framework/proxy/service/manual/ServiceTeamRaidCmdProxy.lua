autoImport("ServiceTeamRaidCmdAutoProxy")
ServiceTeamRaidCmdProxy = class("ServiceTeamRaidCmdProxy", ServiceTeamRaidCmdAutoProxy)
ServiceTeamRaidCmdProxy.Instance = nil
ServiceTeamRaidCmdProxy.NAME = "ServiceTeamRaidCmdProxy"

function ServiceTeamRaidCmdProxy:ctor(proxyName)
  if ServiceTeamRaidCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTeamRaidCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTeamRaidCmdProxy.Instance = self
  end
end

function ServiceTeamRaidCmdProxy:RecvTeamRaidReplyCmd(data)
  helplog("Recv-->TeamRaidReplyCmd")
  FunctionPve.Me():HandleReplay(data.charid, data.reply, data.raid_type)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, data)
end

function ServiceTeamRaidCmdProxy:RecvTeamRaidAltmanShowCmd(data)
  helplog("Recv-->TeamRaidAltmanShowCmd", data.lefttime, data.killcount, data.selfkill)
  DungeonProxy.Instance:UpdateAltManRaidInfo(data.lefttime, data.killcount, data.selfkill)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd, data)
end

function ServiceTeamRaidCmdProxy:RecvTeamPvpInviteMatchCmd(data)
  redlog("RecvTeamPvpInviteMatchCmd : ", data.pvptype, data.iscancel, data.charid)
  PvpProxy.Instance:RecvTeamInviteMatch(data)
  if data.iscancel then
    PvpProxy.Instance:ClearTeamPwsPreInfo()
  end
  self:Notify(ServiceEvent.TeamRaidCmdTeamPvpInviteMatchCmd, data)
end

function ServiceTeamRaidCmdProxy:RecvTeamPvpReplyMatchCmd(data)
  redlog("RecvTeamPvpReplyMatchCmd : ", data.pvptype, data.agree, data.charid)
  PvpProxy.Instance:RecvTeamPvpReplyMatch(data)
  if not data.agree then
    PvpProxy.Instance:ClearInviteMap()
    PvpProxy.Instance:ClearTeamPwsPreInfo()
  else
    PvpProxy.Instance:HandleInviteMatchAllReady(data.pvptype)
  end
  self:Notify(ServiceEvent.TeamRaidCmdTeamPvpReplyMatchCmd, data)
end
