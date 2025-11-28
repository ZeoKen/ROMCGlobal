autoImport("ServiceTeamGroupRaidAutoProxy")
ServiceTeamGroupRaidProxy = class("ServiceTeamGroupRaidProxy", ServiceTeamGroupRaidAutoProxy)
ServiceTeamGroupRaidProxy.Instance = nil
ServiceTeamGroupRaidProxy.NAME = "ServiceTeamGroupRaidProxy"
autoImport("GroupRaidKillData")

function ServiceTeamGroupRaidProxy:ctor(proxyName)
  if ServiceTeamGroupRaidProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTeamGroupRaidProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTeamGroupRaidProxy.Instance = self
  end
end

function ServiceTeamGroupRaidProxy:RecvInviteGroupJoinRaidTeamCmd(data)
  FunctionPve.Me():HandleServerInvite(data.iscancel, data.entranceid, data.difficulty, data.lefttime)
  self:Notify(ServiceEvent.TeamGroupRaidInviteGroupJoinRaidTeamCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvReplyGroupJoinRaidTeamCmd(data)
  FunctionPve.Me():HandleReplay(data.charid, data.reply, PveRaidType.Thanatos)
  self:Notify(ServiceEvent.TeamGroupRaidReplyGroupJoinRaidTeamCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvOpenGroupRaidTeamCmd(data)
  helplog("RecvOpenGroupRaidTeamCmd")
  self:Notify(ServiceEvent.TeamGroupRaidOpenGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvJoinGroupRaidTeamCmd(data)
  helplog("RecvJoinGroupRaidTeamCmd")
  self:Notify(ServiceEvent.TeamGroupRaidJoinGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvQueryGroupRaidStatusCmd(data)
  FunctionPve.Me():HandleGroupRaidStatus(data)
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidStatusCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvCreateGroupRaidTeamCmd(data)
  helplog("RecvCreateGroupRaidTeamCmd")
  self:Notify(ServiceEvent.TeamGroupRaidCreateGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvGoToGroupRaidTeamCmd(data)
  helplog("RecvGoToGroupRaidTeamCmd")
  self:Notify(ServiceEvent.TeamGroupRaidGoToGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvInviteConfirmRaidTeamGroupCmd(data)
  helplog("RecvInviteConfirmRaidTeamGroupCmd")
  GroupRaidProxy.Instance:RecvGroupOnMarkStatus(data, ServerTime.CurServerTime())
  if not data.cancel then
    GroupRaidProxy.Instance:ClearOnMarkReply()
    if not SceneProxy.Instance:IsLoading() then
      FunctionNpcFunc.JumpPanel(PanelConfig.GroupOnMarkView)
    else
      GroupRaidProxy.Instance.delayOnMarkJump = true
    end
  end
  self:Notify(ServiceEvent.TeamGroupRaidInviteConfirmRaidTeamGroupCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvReplyConfirmRaidTeamGroupCmd(data)
  helplog("RecvReplyConfirmRaidTeamGroupCmd")
  GroupRaidProxy.Instance:SetOnMarkReply(data.charid, data.reply)
  self:Notify(ServiceEvent.TeamGroupRaidReplyConfirmRaidTeamGroupCmd, data)
end

function ServiceTeamGroupRaidProxy:RecvQueryGroupRaidKillUserInfo(data)
  local playerTable = ReusableTable.CreateTable()
  if data and data.infos then
    for i = 1, #data.infos do
      local single = data.infos[i]
      local entry = GroupRaidKillData.new(single)
      playerTable[single.raid] = entry
    end
  end
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserInfo, {playerTable})
  ReusableTable.DestroyTable(playerTable)
end

function ServiceTeamGroupRaidProxy:RecvQueryGroupRaidKillGuildInfo(data)
  local guildTable = ReusableTable.CreateTable()
  if data and data.infos then
    for i = 1, #data.infos do
      local single = data.infos[i]
      local entry = GroupRaidKillData.new(single)
      guildTable[single.raid] = entry
    end
  end
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidKillGuildInfo, {guildTable})
  ReusableTable.DestroyTable(guildTable)
end

function ServiceTeamGroupRaidProxy:RecvQueryGroupRaidKillUserShowData(data)
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserShowData, data)
end
