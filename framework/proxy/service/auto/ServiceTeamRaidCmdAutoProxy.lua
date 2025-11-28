ServiceTeamRaidCmdAutoProxy = class("ServiceTeamRaidCmdAutoProxy", ServiceProxy)
ServiceTeamRaidCmdAutoProxy.Instance = nil
ServiceTeamRaidCmdAutoProxy.NAME = "ServiceTeamRaidCmdAutoProxy"

function ServiceTeamRaidCmdAutoProxy:ctor(proxyName)
  if ServiceTeamRaidCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTeamRaidCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTeamRaidCmdAutoProxy.Instance = self
  end
end

function ServiceTeamRaidCmdAutoProxy:Init()
end

function ServiceTeamRaidCmdAutoProxy:onRegister()
  self:Listen(67, 1, function(data)
    self:RecvTeamRaidInviteCmd(data)
  end)
  self:Listen(67, 2, function(data)
    self:RecvTeamRaidReplyCmd(data)
  end)
  self:Listen(67, 3, function(data)
    self:RecvTeamRaidEnterCmd(data)
  end)
  self:Listen(67, 4, function(data)
    self:RecvTeamRaidAltmanShowCmd(data)
  end)
  self:Listen(67, 6, function(data)
    self:RecvTeamRaidImageCreateCmd(data)
  end)
  self:Listen(67, 7, function(data)
    self:RecvTeamPvpInviteMatchCmd(data)
  end)
  self:Listen(67, 8, function(data)
    self:RecvTeamPvpReplyMatchCmd(data)
  end)
  self:Listen(67, 9, function(data)
    self:RecvComodoTeamRaidCreateCmd(data)
  end)
  self:Listen(67, 11, function(data)
    self:RecvGuildTeamRaidCreateCmd(data)
  end)
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidInviteCmd(iscancel, raid_type, difficulty, entranceid, lefttime, out_raid)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamRaidInviteCmd()
    if iscancel ~= nil then
      msg.iscancel = iscancel
    end
    if raid_type ~= nil then
      msg.raid_type = raid_type
    end
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    if entranceid ~= nil then
      msg.entranceid = entranceid
    end
    if lefttime ~= nil then
      msg.lefttime = lefttime
    end
    if out_raid ~= nil then
      msg.out_raid = out_raid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamRaidInviteCmd.id
    local msgParam = {}
    if iscancel ~= nil then
      msgParam.iscancel = iscancel
    end
    if raid_type ~= nil then
      msgParam.raid_type = raid_type
    end
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    if entranceid ~= nil then
      msgParam.entranceid = entranceid
    end
    if lefttime ~= nil then
      msgParam.lefttime = lefttime
    end
    if out_raid ~= nil then
      msgParam.out_raid = out_raid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidReplyCmd(reply, charid, raid_type)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamRaidReplyCmd()
    if reply ~= nil then
      msg.reply = reply
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if raid_type ~= nil then
      msg.raid_type = raid_type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamRaidReplyCmd.id
    local msgParam = {}
    if reply ~= nil then
      msgParam.reply = reply
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if raid_type ~= nil then
      msgParam.raid_type = raid_type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidEnterCmd(raid_type, userid, zoneid, time, sign, difficulty, bossid)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamRaidEnterCmd()
    if raid_type ~= nil then
      msg.raid_type = raid_type
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    if bossid ~= nil then
      msg.bossid = bossid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamRaidEnterCmd.id
    local msgParam = {}
    if raid_type ~= nil then
      msgParam.raid_type = raid_type
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    if bossid ~= nil then
      msgParam.bossid = bossid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidAltmanShowCmd(lefttime, killcount, selfkill)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamRaidAltmanShowCmd()
    if lefttime ~= nil then
      msg.lefttime = lefttime
    end
    if killcount ~= nil then
      msg.killcount = killcount
    end
    if selfkill ~= nil then
      msg.selfkill = selfkill
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamRaidAltmanShowCmd.id
    local msgParam = {}
    if lefttime ~= nil then
      msgParam.lefttime = lefttime
    end
    if killcount ~= nil then
      msgParam.killcount = killcount
    end
    if selfkill ~= nil then
      msgParam.selfkill = selfkill
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallTeamRaidImageCreateCmd(activityid, raidid)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamRaidImageCreateCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamRaidImageCreateCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallTeamPvpInviteMatchCmd(pvptype, iscancel, charid)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamPvpInviteMatchCmd()
    if pvptype ~= nil then
      msg.pvptype = pvptype
    end
    if iscancel ~= nil then
      msg.iscancel = iscancel
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamPvpInviteMatchCmd.id
    local msgParam = {}
    if pvptype ~= nil then
      msgParam.pvptype = pvptype
    end
    if iscancel ~= nil then
      msgParam.iscancel = iscancel
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallTeamPvpReplyMatchCmd(pvptype, charid, agree)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.TeamPvpReplyMatchCmd()
    if pvptype ~= nil then
      msg.pvptype = pvptype
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if agree ~= nil then
      msg.agree = agree
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamPvpReplyMatchCmd.id
    local msgParam = {}
    if pvptype ~= nil then
      msgParam.pvptype = pvptype
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if agree ~= nil then
      msgParam.agree = agree
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallComodoTeamRaidCreateCmd(difficulty)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.ComodoTeamRaidCreateCmd()
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ComodoTeamRaidCreateCmd.id
    local msgParam = {}
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:CallGuildTeamRaidCreateCmd(difficulty)
  if not NetConfig.PBC then
    local msg = TeamRaidCmd_pb.GuildTeamRaidCreateCmd()
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildTeamRaidCreateCmd.id
    local msgParam = {}
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidInviteCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidInviteCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidReplyCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidEnterCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidEnterCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidAltmanShowCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamRaidImageCreateCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamRaidImageCreateCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamPvpInviteMatchCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamPvpInviteMatchCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvTeamPvpReplyMatchCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdTeamPvpReplyMatchCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvComodoTeamRaidCreateCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdComodoTeamRaidCreateCmd, data)
end

function ServiceTeamRaidCmdAutoProxy:RecvGuildTeamRaidCreateCmd(data)
  self:Notify(ServiceEvent.TeamRaidCmdGuildTeamRaidCreateCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.TeamRaidCmdTeamRaidInviteCmd = "ServiceEvent_TeamRaidCmdTeamRaidInviteCmd"
ServiceEvent.TeamRaidCmdTeamRaidReplyCmd = "ServiceEvent_TeamRaidCmdTeamRaidReplyCmd"
ServiceEvent.TeamRaidCmdTeamRaidEnterCmd = "ServiceEvent_TeamRaidCmdTeamRaidEnterCmd"
ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd = "ServiceEvent_TeamRaidCmdTeamRaidAltmanShowCmd"
ServiceEvent.TeamRaidCmdTeamRaidImageCreateCmd = "ServiceEvent_TeamRaidCmdTeamRaidImageCreateCmd"
ServiceEvent.TeamRaidCmdTeamPvpInviteMatchCmd = "ServiceEvent_TeamRaidCmdTeamPvpInviteMatchCmd"
ServiceEvent.TeamRaidCmdTeamPvpReplyMatchCmd = "ServiceEvent_TeamRaidCmdTeamPvpReplyMatchCmd"
ServiceEvent.TeamRaidCmdComodoTeamRaidCreateCmd = "ServiceEvent_TeamRaidCmdComodoTeamRaidCreateCmd"
ServiceEvent.TeamRaidCmdGuildTeamRaidCreateCmd = "ServiceEvent_TeamRaidCmdGuildTeamRaidCreateCmd"
