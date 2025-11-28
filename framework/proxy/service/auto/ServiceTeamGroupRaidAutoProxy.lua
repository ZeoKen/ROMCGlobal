ServiceTeamGroupRaidAutoProxy = class("ServiceTeamGroupRaidAutoProxy", ServiceProxy)
ServiceTeamGroupRaidAutoProxy.Instance = nil
ServiceTeamGroupRaidAutoProxy.NAME = "ServiceTeamGroupRaidAutoProxy"

function ServiceTeamGroupRaidAutoProxy:ctor(proxyName)
  if ServiceTeamGroupRaidAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTeamGroupRaidAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTeamGroupRaidAutoProxy.Instance = self
  end
end

function ServiceTeamGroupRaidAutoProxy:Init()
end

function ServiceTeamGroupRaidAutoProxy:onRegister()
  self:Listen(69, 1, function(data)
    self:RecvInviteGroupJoinRaidTeamCmd(data)
  end)
  self:Listen(69, 2, function(data)
    self:RecvReplyGroupJoinRaidTeamCmd(data)
  end)
  self:Listen(69, 3, function(data)
    self:RecvOpenGroupRaidTeamCmd(data)
  end)
  self:Listen(69, 4, function(data)
    self:RecvJoinGroupRaidTeamCmd(data)
  end)
  self:Listen(69, 5, function(data)
    self:RecvQueryGroupRaidStatusCmd(data)
  end)
  self:Listen(69, 20, function(data)
    self:RecvCreateGroupRaidTeamCmd(data)
  end)
  self:Listen(69, 21, function(data)
    self:RecvGoToGroupRaidTeamCmd(data)
  end)
  self:Listen(69, 6, function(data)
    self:RecvEnterNextRaidGroupCmd(data)
  end)
  self:Listen(69, 7, function(data)
    self:RecvInviteConfirmRaidTeamGroupCmd(data)
  end)
  self:Listen(69, 8, function(data)
    self:RecvReplyConfirmRaidTeamGroupCmd(data)
  end)
  self:Listen(69, 9, function(data)
    self:RecvQueryGroupRaidKillUserInfo(data)
  end)
  self:Listen(69, 10, function(data)
    self:RecvQueryGroupRaidKillGuildInfo(data)
  end)
  self:Listen(69, 11, function(data)
    self:RecvQueryGroupRaidKillUserShowData(data)
  end)
end

function ServiceTeamGroupRaidAutoProxy:CallInviteGroupJoinRaidTeamCmd(iscancel, difficulty, entranceid, lefttime)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.InviteGroupJoinRaidTeamCmd()
    if iscancel ~= nil then
      msg.iscancel = iscancel
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteGroupJoinRaidTeamCmd.id
    local msgParam = {}
    if iscancel ~= nil then
      msgParam.iscancel = iscancel
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallReplyGroupJoinRaidTeamCmd(reply, charid)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.ReplyGroupJoinRaidTeamCmd()
    if reply ~= nil then
      msg.reply = reply
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyGroupJoinRaidTeamCmd.id
    local msgParam = {}
    if reply ~= nil then
      msgParam.reply = reply
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallOpenGroupRaidTeamCmd()
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.OpenGroupRaidTeamCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenGroupRaidTeamCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallJoinGroupRaidTeamCmd(difficulty)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.JoinGroupRaidTeamCmd()
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinGroupRaidTeamCmd.id
    local msgParam = {}
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallQueryGroupRaidStatusCmd(open, canjoin)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.QueryGroupRaidStatusCmd()
    if open ~= nil then
      msg.open = open
    end
    if canjoin ~= nil then
      msg.canjoin = canjoin
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGroupRaidStatusCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    if canjoin ~= nil then
      msgParam.canjoin = canjoin
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallCreateGroupRaidTeamCmd(difficulty, zoneid, raidid)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.CreateGroupRaidTeamCmd()
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CreateGroupRaidTeamCmd.id
    local msgParam = {}
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallGoToGroupRaidTeamCmd(zoneid, raidid)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.GoToGroupRaidTeamCmd()
    if msg == nil then
      msg = {}
    end
    msg.zoneid = zoneid
    if msg == nil then
      msg = {}
    end
    msg.raidid = raidid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoToGroupRaidTeamCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.zoneid = zoneid
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.raidid = raidid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallEnterNextRaidGroupCmd()
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.EnterNextRaidGroupCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterNextRaidGroupCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallInviteConfirmRaidTeamGroupCmd(cancel)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.InviteConfirmRaidTeamGroupCmd()
    if cancel ~= nil then
      msg.cancel = cancel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteConfirmRaidTeamGroupCmd.id
    local msgParam = {}
    if cancel ~= nil then
      msgParam.cancel = cancel
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallReplyConfirmRaidTeamGroupCmd(reply, charid)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.ReplyConfirmRaidTeamGroupCmd()
    if reply ~= nil then
      msg.reply = reply
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyConfirmRaidTeamGroupCmd.id
    local msgParam = {}
    if reply ~= nil then
      msgParam.reply = reply
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallQueryGroupRaidKillUserInfo(raid_keys, infos)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.QueryGroupRaidKillUserInfo()
    if raid_keys ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.raid_keys == nil then
        msg.raid_keys = {}
      end
      for i = 1, #raid_keys do
        table.insert(msg.raid_keys, raid_keys[i])
      end
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGroupRaidKillUserInfo.id
    local msgParam = {}
    if raid_keys ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.raid_keys == nil then
        msgParam.raid_keys = {}
      end
      for i = 1, #raid_keys do
        table.insert(msgParam.raid_keys, raid_keys[i])
      end
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallQueryGroupRaidKillGuildInfo(raid_keys, infos)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.QueryGroupRaidKillGuildInfo()
    if raid_keys ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.raid_keys == nil then
        msg.raid_keys = {}
      end
      for i = 1, #raid_keys do
        table.insert(msg.raid_keys, raid_keys[i])
      end
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGroupRaidKillGuildInfo.id
    local msgParam = {}
    if raid_keys ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.raid_keys == nil then
        msgParam.raid_keys = {}
      end
      for i = 1, #raid_keys do
        table.insert(msgParam.raid_keys, raid_keys[i])
      end
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:CallQueryGroupRaidKillUserShowData(charid, showdata)
  if not NetConfig.PBC then
    local msg = TeamGroupRaid_pb.QueryGroupRaidKillUserShowData()
    if msg == nil then
      msg = {}
    end
    msg.charid = charid
    if showdata ~= nil and showdata.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.showdata == nil then
        msg.showdata = {}
      end
      msg.showdata.charid = showdata.charid
    end
    if showdata ~= nil and showdata.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.showdata == nil then
        msg.showdata = {}
      end
      msg.showdata.name = showdata.name
    end
    if showdata ~= nil and showdata.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.showdata == nil then
        msg.showdata = {}
      end
      msg.showdata.level = showdata.level
    end
    if showdata ~= nil and showdata.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.showdata == nil then
        msg.showdata = {}
      end
      msg.showdata.profession = showdata.profession
    end
    if showdata ~= nil and showdata.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.showdata == nil then
        msg.showdata = {}
      end
      msg.showdata.guildname = showdata.guildname
    end
    if showdata.portrait ~= nil and showdata.portrait.portrait ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.portrait = showdata.portrait.portrait
    end
    if showdata.portrait ~= nil and showdata.portrait.body ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.body = showdata.portrait.body
    end
    if showdata.portrait ~= nil and showdata.portrait.hair ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.hair = showdata.portrait.hair
    end
    if showdata.portrait ~= nil and showdata.portrait.haircolor ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.haircolor = showdata.portrait.haircolor
    end
    if showdata.portrait ~= nil and showdata.portrait.gender ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.gender = showdata.portrait.gender
    end
    if showdata.portrait ~= nil and showdata.portrait.head ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.head = showdata.portrait.head
    end
    if showdata.portrait ~= nil and showdata.portrait.face ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.face = showdata.portrait.face
    end
    if showdata.portrait ~= nil and showdata.portrait.mouth ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.mouth = showdata.portrait.mouth
    end
    if showdata.portrait ~= nil and showdata.portrait.eye ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.eye = showdata.portrait.eye
    end
    if showdata.portrait ~= nil and showdata.portrait.portrait_frame ~= nil then
      if msg.showdata == nil then
        msg.showdata = {}
      end
      if msg.showdata.portrait == nil then
        msg.showdata.portrait = {}
      end
      msg.showdata.portrait.portrait_frame = showdata.portrait.portrait_frame
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGroupRaidKillUserShowData.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.charid = charid
    if showdata ~= nil and showdata.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      msgParam.showdata.charid = showdata.charid
    end
    if showdata ~= nil and showdata.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      msgParam.showdata.name = showdata.name
    end
    if showdata ~= nil and showdata.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      msgParam.showdata.level = showdata.level
    end
    if showdata ~= nil and showdata.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      msgParam.showdata.profession = showdata.profession
    end
    if showdata ~= nil and showdata.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      msgParam.showdata.guildname = showdata.guildname
    end
    if showdata.portrait ~= nil and showdata.portrait.portrait ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.portrait = showdata.portrait.portrait
    end
    if showdata.portrait ~= nil and showdata.portrait.body ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.body = showdata.portrait.body
    end
    if showdata.portrait ~= nil and showdata.portrait.hair ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.hair = showdata.portrait.hair
    end
    if showdata.portrait ~= nil and showdata.portrait.haircolor ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.haircolor = showdata.portrait.haircolor
    end
    if showdata.portrait ~= nil and showdata.portrait.gender ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.gender = showdata.portrait.gender
    end
    if showdata.portrait ~= nil and showdata.portrait.head ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.head = showdata.portrait.head
    end
    if showdata.portrait ~= nil and showdata.portrait.face ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.face = showdata.portrait.face
    end
    if showdata.portrait ~= nil and showdata.portrait.mouth ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.mouth = showdata.portrait.mouth
    end
    if showdata.portrait ~= nil and showdata.portrait.eye ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.eye = showdata.portrait.eye
    end
    if showdata.portrait ~= nil and showdata.portrait.portrait_frame ~= nil then
      if msgParam.showdata == nil then
        msgParam.showdata = {}
      end
      if msgParam.showdata.portrait == nil then
        msgParam.showdata.portrait = {}
      end
      msgParam.showdata.portrait.portrait_frame = showdata.portrait.portrait_frame
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTeamGroupRaidAutoProxy:RecvInviteGroupJoinRaidTeamCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidInviteGroupJoinRaidTeamCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvReplyGroupJoinRaidTeamCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidReplyGroupJoinRaidTeamCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvOpenGroupRaidTeamCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidOpenGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvJoinGroupRaidTeamCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidJoinGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvQueryGroupRaidStatusCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidStatusCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvCreateGroupRaidTeamCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidCreateGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvGoToGroupRaidTeamCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidGoToGroupRaidTeamCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvEnterNextRaidGroupCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidEnterNextRaidGroupCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvInviteConfirmRaidTeamGroupCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidInviteConfirmRaidTeamGroupCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvReplyConfirmRaidTeamGroupCmd(data)
  self:Notify(ServiceEvent.TeamGroupRaidReplyConfirmRaidTeamGroupCmd, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvQueryGroupRaidKillUserInfo(data)
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserInfo, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvQueryGroupRaidKillGuildInfo(data)
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidKillGuildInfo, data)
end

function ServiceTeamGroupRaidAutoProxy:RecvQueryGroupRaidKillUserShowData(data)
  self:Notify(ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserShowData, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.TeamGroupRaidInviteGroupJoinRaidTeamCmd = "ServiceEvent_TeamGroupRaidInviteGroupJoinRaidTeamCmd"
ServiceEvent.TeamGroupRaidReplyGroupJoinRaidTeamCmd = "ServiceEvent_TeamGroupRaidReplyGroupJoinRaidTeamCmd"
ServiceEvent.TeamGroupRaidOpenGroupRaidTeamCmd = "ServiceEvent_TeamGroupRaidOpenGroupRaidTeamCmd"
ServiceEvent.TeamGroupRaidJoinGroupRaidTeamCmd = "ServiceEvent_TeamGroupRaidJoinGroupRaidTeamCmd"
ServiceEvent.TeamGroupRaidQueryGroupRaidStatusCmd = "ServiceEvent_TeamGroupRaidQueryGroupRaidStatusCmd"
ServiceEvent.TeamGroupRaidCreateGroupRaidTeamCmd = "ServiceEvent_TeamGroupRaidCreateGroupRaidTeamCmd"
ServiceEvent.TeamGroupRaidGoToGroupRaidTeamCmd = "ServiceEvent_TeamGroupRaidGoToGroupRaidTeamCmd"
ServiceEvent.TeamGroupRaidEnterNextRaidGroupCmd = "ServiceEvent_TeamGroupRaidEnterNextRaidGroupCmd"
ServiceEvent.TeamGroupRaidInviteConfirmRaidTeamGroupCmd = "ServiceEvent_TeamGroupRaidInviteConfirmRaidTeamGroupCmd"
ServiceEvent.TeamGroupRaidReplyConfirmRaidTeamGroupCmd = "ServiceEvent_TeamGroupRaidReplyConfirmRaidTeamGroupCmd"
ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserInfo = "ServiceEvent_TeamGroupRaidQueryGroupRaidKillUserInfo"
ServiceEvent.TeamGroupRaidQueryGroupRaidKillGuildInfo = "ServiceEvent_TeamGroupRaidQueryGroupRaidKillGuildInfo"
ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserShowData = "ServiceEvent_TeamGroupRaidQueryGroupRaidKillUserShowData"
