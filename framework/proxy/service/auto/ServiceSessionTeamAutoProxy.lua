ServiceSessionTeamAutoProxy = class("ServiceSessionTeamAutoProxy", ServiceProxy)
ServiceSessionTeamAutoProxy.Instance = nil
ServiceSessionTeamAutoProxy.NAME = "ServiceSessionTeamAutoProxy"

function ServiceSessionTeamAutoProxy:ctor(proxyName)
  if ServiceSessionTeamAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionTeamAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionTeamAutoProxy.Instance = self
  end
end

function ServiceSessionTeamAutoProxy:Init()
end

function ServiceSessionTeamAutoProxy:onRegister()
  self:Listen(51, 1, function(data)
    self:RecvTeamList(data)
  end)
  self:Listen(51, 2, function(data)
    self:RecvTeamDataUpdate(data)
  end)
  self:Listen(51, 3, function(data)
    self:RecvTeamMemberUpdate(data)
  end)
  self:Listen(51, 4, function(data)
    self:RecvTeamApplyUpdate(data)
  end)
  self:Listen(51, 5, function(data)
    self:RecvCreateTeam(data)
  end)
  self:Listen(51, 6, function(data)
    self:RecvInviteMember(data)
  end)
  self:Listen(51, 7, function(data)
    self:RecvProcessTeamInvite(data)
  end)
  self:Listen(51, 8, function(data)
    self:RecvTeamMemberApply(data)
  end)
  self:Listen(51, 9, function(data)
    self:RecvProcessTeamApply(data)
  end)
  self:Listen(51, 10, function(data)
    self:RecvKickMember(data)
  end)
  self:Listen(51, 11, function(data)
    self:RecvExchangeLeader(data)
  end)
  self:Listen(51, 12, function(data)
    self:RecvExitTeam(data)
  end)
  self:Listen(51, 13, function(data)
    self:RecvEnterTeam(data)
  end)
  self:Listen(51, 14, function(data)
    self:RecvMemberPosUpdate(data)
  end)
  self:Listen(51, 15, function(data)
    self:RecvMemberDataUpdate(data)
  end)
  self:Listen(51, 16, function(data)
    self:RecvLockTarget(data)
  end)
  self:Listen(51, 17, function(data)
    self:RecvTeamSummon(data)
  end)
  self:Listen(51, 18, function(data)
    self:RecvClearApplyList(data)
  end)
  self:Listen(51, 19, function(data)
    self:RecvQuickEnter(data)
  end)
  self:Listen(51, 20, function(data)
    self:RecvSetTeamOption(data)
  end)
  self:Listen(51, 21, function(data)
    self:RecvQueryUserTeamInfoTeamCmd(data)
  end)
  self:Listen(51, 22, function(data)
    self:RecvSetMemberOptionTeamCmd(data)
  end)
  self:Listen(51, 23, function(data)
    self:RecvQuestWantedQuestTeamCmd(data)
  end)
  self:Listen(51, 24, function(data)
    self:RecvUpdateWantedQuestTeamCmd(data)
  end)
  self:Listen(51, 25, function(data)
    self:RecvAcceptHelpWantedTeamCmd(data)
  end)
  self:Listen(51, 26, function(data)
    self:RecvUpdateHelpWantedTeamCmd(data)
  end)
  self:Listen(51, 27, function(data)
    self:RecvQueryHelpWantedTeamCmd(data)
  end)
  self:Listen(51, 28, function(data)
    self:RecvQueryMemberCatTeamCmd(data)
  end)
  self:Listen(51, 29, function(data)
    self:RecvMemberCatUpdateTeam(data)
  end)
  self:Listen(51, 31, function(data)
    self:RecvCancelApplyTeamCmd(data)
  end)
  self:Listen(51, 32, function(data)
    self:RecvQueryMemberTeamCmd(data)
  end)
  self:Listen(51, 33, function(data)
    self:RecvUserApplyUpdateTeamCmd(data)
  end)
  self:Listen(51, 34, function(data)
    self:RecvInviteGroupTeamCmd(data)
  end)
  self:Listen(51, 35, function(data)
    self:RecvProcessInviteGroupTeamCmd(data)
  end)
  self:Listen(51, 36, function(data)
    self:RecvDissolveGroupTeamCmd(data)
  end)
  self:Listen(51, 37, function(data)
    self:RecvChangeGroupLeaderTeamCmd(data)
  end)
  self:Listen(51, 38, function(data)
    self:RecvGroupUpdateNtfTeamCmd(data)
  end)
  self:Listen(51, 39, function(data)
    self:RecvQueryGroupTeamApplyListTeamCmd(data)
  end)
  self:Listen(51, 40, function(data)
    self:RecvTeamGroupApplyUpdate(data)
  end)
  self:Listen(51, 41, function(data)
    self:RecvTeamGroupApplyTeamCmd(data)
  end)
  self:Listen(51, 42, function(data)
    self:RecvProcessGroupApplyTeamCmd(data)
  end)
  self:Listen(51, 43, function(data)
    self:RecvMyGroupApplyUpdateTeamCmd(data)
  end)
  self:Listen(51, 44, function(data)
    self:RecvLaunckKickTeamCmd(data)
  end)
  self:Listen(51, 45, function(data)
    self:RecvReplyKickTeamCmd(data)
  end)
  self:Listen(51, 51, function(data)
    self:RecvGMEMuteTeamCmd(data)
  end)
  self:Listen(51, 46, function(data)
    self:RecvReqRecruitPublishTeamCmd(data)
  end)
  self:Listen(51, 47, function(data)
    self:RecvNewRecruitPublishTeamCmd(data)
  end)
  self:Listen(51, 48, function(data)
    self:RecvReqRecruitTeamInfoTeamCmd(data)
  end)
  self:Listen(51, 49, function(data)
    self:RecvUpdateRecruitTeamInfoTeamCmd(data)
  end)
  self:Listen(51, 50, function(data)
    self:RecvChangeGroupMemberTeamCmd(data)
  end)
  self:Listen(51, 52, function(data)
    self:RecvPublishReqHelpTeamCmd(data)
  end)
  self:Listen(51, 53, function(data)
    self:RecvAskForTeamInfoTeamCmd(data)
  end)
end

function ServiceSessionTeamAutoProxy:CallTeamList(type, page, lv, querytype, groupgoal, list)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamList()
    if type ~= nil then
      msg.type = type
    end
    if page ~= nil then
      msg.page = page
    end
    if lv ~= nil then
      msg.lv = lv
    end
    if querytype ~= nil then
      msg.querytype = querytype
    end
    if groupgoal ~= nil then
      msg.groupgoal = groupgoal
    end
    if list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      for i = 1, #list do
        table.insert(msg.list, list[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamList.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if page ~= nil then
      msgParam.page = page
    end
    if lv ~= nil then
      msgParam.lv = lv
    end
    if querytype ~= nil then
      msgParam.querytype = querytype
    end
    if groupgoal ~= nil then
      msgParam.groupgoal = groupgoal
    end
    if list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      for i = 1, #list do
        table.insert(msgParam.list, list[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamDataUpdate(name, datas)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamDataUpdate()
    if name ~= nil then
      msg.name = name
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamDataUpdate.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamMemberUpdate(updates, deletes)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamMemberUpdate()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deletes == nil then
        msg.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msg.deletes, deletes[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamMemberUpdate.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deletes == nil then
        msgParam.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msgParam.deletes, deletes[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamApplyUpdate(updates, deletes, isgroup)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamApplyUpdate()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deletes == nil then
        msg.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msg.deletes, deletes[i])
      end
    end
    if isgroup ~= nil then
      msg.isgroup = isgroup
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamApplyUpdate.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deletes == nil then
        msgParam.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msgParam.deletes, deletes[i])
      end
    end
    if isgroup ~= nil then
      msgParam.isgroup = isgroup
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallCreateTeam(minlv, maxlv, type, autoaccept, name, state, desc, alljoingroup)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.CreateTeam()
    if minlv ~= nil then
      msg.minlv = minlv
    end
    if maxlv ~= nil then
      msg.maxlv = maxlv
    end
    if type ~= nil then
      msg.type = type
    end
    if autoaccept ~= nil then
      msg.autoaccept = autoaccept
    end
    if name ~= nil then
      msg.name = name
    end
    if state ~= nil then
      msg.state = state
    end
    if desc ~= nil then
      msg.desc = desc
    end
    if alljoingroup ~= nil then
      msg.alljoingroup = alljoingroup
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CreateTeam.id
    local msgParam = {}
    if minlv ~= nil then
      msgParam.minlv = minlv
    end
    if maxlv ~= nil then
      msgParam.maxlv = maxlv
    end
    if type ~= nil then
      msgParam.type = type
    end
    if autoaccept ~= nil then
      msgParam.autoaccept = autoaccept
    end
    if name ~= nil then
      msgParam.name = name
    end
    if state ~= nil then
      msgParam.state = state
    end
    if desc ~= nil then
      msgParam.desc = desc
    end
    if alljoingroup ~= nil then
      msgParam.alljoingroup = alljoingroup
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallInviteMember(userguid, catid, teamname, username, isgroup)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.InviteMember()
    if userguid ~= nil then
      msg.userguid = userguid
    end
    if catid ~= nil then
      msg.catid = catid
    end
    if teamname ~= nil then
      msg.teamname = teamname
    end
    if username ~= nil then
      msg.username = username
    end
    if isgroup ~= nil then
      msg.isgroup = isgroup
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteMember.id
    local msgParam = {}
    if userguid ~= nil then
      msgParam.userguid = userguid
    end
    if catid ~= nil then
      msgParam.catid = catid
    end
    if teamname ~= nil then
      msgParam.teamname = teamname
    end
    if username ~= nil then
      msgParam.username = username
    end
    if isgroup ~= nil then
      msgParam.isgroup = isgroup
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallProcessTeamInvite(type, userguid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ProcessTeamInvite()
    if type ~= nil then
      msg.type = type
    end
    if userguid ~= nil then
      msg.userguid = userguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessTeamInvite.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if userguid ~= nil then
      msgParam.userguid = userguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamMemberApply(guid, teamfunc)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamMemberApply()
    if guid ~= nil then
      msg.guid = guid
    end
    if teamfunc ~= nil then
      msg.teamfunc = teamfunc
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamMemberApply.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if teamfunc ~= nil then
      msgParam.teamfunc = teamfunc
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallProcessTeamApply(type, userguid, groupteamid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ProcessTeamApply()
    if type ~= nil then
      msg.type = type
    end
    if userguid ~= nil then
      msg.userguid = userguid
    end
    if groupteamid ~= nil then
      msg.groupteamid = groupteamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessTeamApply.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if userguid ~= nil then
      msgParam.userguid = userguid
    end
    if groupteamid ~= nil then
      msgParam.groupteamid = groupteamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallKickMember(userid, catid, isgroup, robotguid, teamid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.KickMember()
    if userid ~= nil then
      msg.userid = userid
    end
    if catid ~= nil then
      msg.catid = catid
    end
    if isgroup ~= nil then
      msg.isgroup = isgroup
    end
    if robotguid ~= nil then
      msg.robotguid = robotguid
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickMember.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    if catid ~= nil then
      msgParam.catid = catid
    end
    if isgroup ~= nil then
      msgParam.isgroup = isgroup
    end
    if robotguid ~= nil then
      msgParam.robotguid = robotguid
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallExchangeLeader(userid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ExchangeLeader()
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeLeader.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallExitTeam(teamid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ExitTeam()
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitTeam.id
    local msgParam = {}
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallEnterTeam(data)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.EnterTeam()
    if data ~= nil and data.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guid = data.guid
    end
    if data ~= nil and data.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.zoneid = data.zoneid
    end
    if data ~= nil and data.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.name = data.name
    end
    if data ~= nil and data.items ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.items == nil then
        msg.data.items = {}
      end
      for i = 1, #data.items do
        table.insert(msg.data.items, data.items[i])
      end
    end
    if data ~= nil and data.members ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.members == nil then
        msg.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msg.data.members, data.members[i])
      end
    end
    if data ~= nil and data.applys ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.applys == nil then
        msg.data.applys = {}
      end
      for i = 1, #data.applys do
        table.insert(msg.data.applys, data.applys[i])
      end
    end
    if data.seal ~= nil and data.seal.seal ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      msg.data.seal.seal = data.seal.seal
    end
    if data.seal ~= nil and data.seal.zoneid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      msg.data.seal.zoneid = data.seal.zoneid
    end
    if data.seal.pos ~= nil and data.seal.pos.x ~= nil then
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      if msg.data.seal.pos == nil then
        msg.data.seal.pos = {}
      end
      msg.data.seal.pos.x = data.seal.pos.x
    end
    if data.seal.pos ~= nil and data.seal.pos.y ~= nil then
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      if msg.data.seal.pos == nil then
        msg.data.seal.pos = {}
      end
      msg.data.seal.pos.y = data.seal.pos.y
    end
    if data.seal.pos ~= nil and data.seal.pos.z ~= nil then
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      if msg.data.seal.pos == nil then
        msg.data.seal.pos = {}
      end
      msg.data.seal.pos.z = data.seal.pos.z
    end
    if data.seal ~= nil and data.seal.teamid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      msg.data.seal.teamid = data.seal.teamid
    end
    if data.seal ~= nil and data.seal.lastonlinetime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      msg.data.seal.lastonlinetime = data.seal.lastonlinetime
    end
    if data.seal ~= nil and data.seal.dataversion ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.seal == nil then
        msg.data.seal = {}
      end
      msg.data.seal.dataversion = data.seal.dataversion
    end
    if data ~= nil and data.groupapplys ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.groupapplys == nil then
        msg.data.groupapplys = {}
      end
      for i = 1, #data.groupapplys do
        table.insert(msg.data.groupapplys, data.groupapplys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterTeam.id
    local msgParam = {}
    if data ~= nil and data.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guid = data.guid
    end
    if data ~= nil and data.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.zoneid = data.zoneid
    end
    if data ~= nil and data.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.name = data.name
    end
    if data ~= nil and data.items ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.items == nil then
        msgParam.data.items = {}
      end
      for i = 1, #data.items do
        table.insert(msgParam.data.items, data.items[i])
      end
    end
    if data ~= nil and data.members ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.members == nil then
        msgParam.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msgParam.data.members, data.members[i])
      end
    end
    if data ~= nil and data.applys ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.applys == nil then
        msgParam.data.applys = {}
      end
      for i = 1, #data.applys do
        table.insert(msgParam.data.applys, data.applys[i])
      end
    end
    if data.seal ~= nil and data.seal.seal ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      msgParam.data.seal.seal = data.seal.seal
    end
    if data.seal ~= nil and data.seal.zoneid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      msgParam.data.seal.zoneid = data.seal.zoneid
    end
    if data.seal.pos ~= nil and data.seal.pos.x ~= nil then
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      if msgParam.data.seal.pos == nil then
        msgParam.data.seal.pos = {}
      end
      msgParam.data.seal.pos.x = data.seal.pos.x
    end
    if data.seal.pos ~= nil and data.seal.pos.y ~= nil then
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      if msgParam.data.seal.pos == nil then
        msgParam.data.seal.pos = {}
      end
      msgParam.data.seal.pos.y = data.seal.pos.y
    end
    if data.seal.pos ~= nil and data.seal.pos.z ~= nil then
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      if msgParam.data.seal.pos == nil then
        msgParam.data.seal.pos = {}
      end
      msgParam.data.seal.pos.z = data.seal.pos.z
    end
    if data.seal ~= nil and data.seal.teamid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      msgParam.data.seal.teamid = data.seal.teamid
    end
    if data.seal ~= nil and data.seal.lastonlinetime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      msgParam.data.seal.lastonlinetime = data.seal.lastonlinetime
    end
    if data.seal ~= nil and data.seal.dataversion ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.seal == nil then
        msgParam.data.seal = {}
      end
      msgParam.data.seal.dataversion = data.seal.dataversion
    end
    if data ~= nil and data.groupapplys ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.groupapplys == nil then
        msgParam.data.groupapplys = {}
      end
      for i = 1, #data.groupapplys do
        table.insert(msgParam.data.groupapplys, data.groupapplys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallMemberPosUpdate(id, pos, dead)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.MemberPosUpdate()
    if id ~= nil then
      msg.id = id
    end
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    if dead ~= nil then
      msg.dead = dead
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemberPosUpdate.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    if dead ~= nil then
      msgParam.dead = dead
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallMemberDataUpdate(id, members)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.MemberDataUpdate()
    if id ~= nil then
      msg.id = id
    end
    if members ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.members == nil then
        msg.members = {}
      end
      for i = 1, #members do
        table.insert(msg.members, members[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemberDataUpdate.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if members ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.members == nil then
        msgParam.members = {}
      end
      for i = 1, #members do
        table.insert(msgParam.members, members[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallLockTarget(targetid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.LockTarget()
    if targetid ~= nil then
      msg.targetid = targetid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LockTarget.id
    local msgParam = {}
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamSummon(raidid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamSummon()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamSummon.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallClearApplyList()
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ClearApplyList()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClearApplyList.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQuickEnter(type, time, set)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QuickEnter()
    if type ~= nil then
      msg.type = type
    end
    if time ~= nil then
      msg.time = time
    end
    if set ~= nil then
      msg.set = set
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuickEnter.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if time ~= nil then
      msgParam.time = time
    end
    if set ~= nil then
      msgParam.set = set
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallSetTeamOption(name, items, groupteamid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.SetTeamOption()
    if name ~= nil then
      msg.name = name
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if groupteamid ~= nil then
      msg.groupteamid = groupteamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetTeamOption.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if groupteamid ~= nil then
      msgParam.groupteamid = groupteamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQueryUserTeamInfoTeamCmd(charid, teamid, groupteamid, teamcfgid, team_member_count)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QueryUserTeamInfoTeamCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    if groupteamid ~= nil then
      msg.groupteamid = groupteamid
    end
    if teamcfgid ~= nil then
      msg.teamcfgid = teamcfgid
    end
    if team_member_count ~= nil then
      msg.team_member_count = team_member_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserTeamInfoTeamCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    if groupteamid ~= nil then
      msgParam.groupteamid = groupteamid
    end
    if teamcfgid ~= nil then
      msgParam.teamcfgid = teamcfgid
    end
    if team_member_count ~= nil then
      msgParam.team_member_count = team_member_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallSetMemberOptionTeamCmd(autofollow, datas)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.SetMemberOptionTeamCmd()
    if autofollow ~= nil then
      msg.autofollow = autofollow
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetMemberOptionTeamCmd.id
    local msgParam = {}
    if autofollow ~= nil then
      msgParam.autofollow = autofollow
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQuestWantedQuestTeamCmd(quests)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QuestWantedQuestTeamCmd()
    if quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quests == nil then
        msg.quests = {}
      end
      for i = 1, #quests do
        table.insert(msg.quests, quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestWantedQuestTeamCmd.id
    local msgParam = {}
    if quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quests == nil then
        msgParam.quests = {}
      end
      for i = 1, #quests do
        table.insert(msgParam.quests, quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallUpdateWantedQuestTeamCmd(quest)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.UpdateWantedQuestTeamCmd()
    if quest ~= nil and quest.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.charid = quest.charid
    end
    if quest ~= nil and quest.questid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.questid = quest.questid
    end
    if quest ~= nil and quest.action ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.action = quest.action
    end
    if quest ~= nil and quest.step ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.step = quest.step
    end
    if quest.questdata ~= nil and quest.questdata.process ~= nil then
      if msg.quest == nil then
        msg.quest = {}
      end
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      msg.quest.questdata.process = quest.questdata.process
    end
    if quest ~= nil and quest.questdata.params ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.params == nil then
        msg.quest.questdata.params = {}
      end
      for i = 1, #quest.questdata.params do
        table.insert(msg.quest.questdata.params, quest.questdata.params[i])
      end
    end
    if quest ~= nil and quest.questdata.names ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.names == nil then
        msg.quest.questdata.names = {}
      end
      for i = 1, #quest.questdata.names do
        table.insert(msg.quest.questdata.names, quest.questdata.names[i])
      end
    end
    if quest.questdata.config ~= nil and quest.questdata.config.QuestID ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.QuestID = quest.questdata.config.QuestID
    end
    if quest.questdata.config ~= nil and quest.questdata.config.GroupID ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.GroupID = quest.questdata.config.GroupID
    end
    if quest.questdata.config ~= nil and quest.questdata.config.RewardGroup ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.RewardGroup = quest.questdata.config.RewardGroup
    end
    if quest.questdata.config ~= nil and quest.questdata.config.SubGroup ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.SubGroup = quest.questdata.config.SubGroup
    end
    if quest.questdata.config ~= nil and quest.questdata.config.FinishJump ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.FinishJump = quest.questdata.config.FinishJump
    end
    if quest.questdata.config ~= nil and quest.questdata.config.FailJump ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.FailJump = quest.questdata.config.FailJump
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Map ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Map = quest.questdata.config.Map
    end
    if quest.questdata.config ~= nil and quest.questdata.config.WhetherTrace ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.WhetherTrace = quest.questdata.config.WhetherTrace
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Auto ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Auto = quest.questdata.config.Auto
    end
    if quest.questdata.config ~= nil and quest.questdata.config.FirstClass ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.FirstClass = quest.questdata.config.FirstClass
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Class ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Class = quest.questdata.config.Class
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Level ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Level = quest.questdata.config.Level
    end
    if quest.questdata.config ~= nil and quest.questdata.config.PreNoShow ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.PreNoShow = quest.questdata.config.PreNoShow
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Risklevel ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Risklevel = quest.questdata.config.Risklevel
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Joblevel ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Joblevel = quest.questdata.config.Joblevel
    end
    if quest.questdata.config ~= nil and quest.questdata.config.CookerLv ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.CookerLv = quest.questdata.config.CookerLv
    end
    if quest.questdata.config ~= nil and quest.questdata.config.TasterLv ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.TasterLv = quest.questdata.config.TasterLv
    end
    if quest.questdata.config ~= nil and quest.questdata.config.StartTime ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.StartTime = quest.questdata.config.StartTime
    end
    if quest.questdata.config ~= nil and quest.questdata.config.EndTime ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.EndTime = quest.questdata.config.EndTime
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Icon ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Icon = quest.questdata.config.Icon
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Color ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Color = quest.questdata.config.Color
    end
    if quest.questdata.config ~= nil and quest.questdata.config.QuestName ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.QuestName = quest.questdata.config.QuestName
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Name ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Name = quest.questdata.config.Name
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Type ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Type = quest.questdata.config.Type
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Content ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Content = quest.questdata.config.Content
    end
    if quest.questdata.config ~= nil and quest.questdata.config.TraceInfo ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.TraceInfo = quest.questdata.config.TraceInfo
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Prefixion ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Prefixion = quest.questdata.config.Prefixion
    end
    if quest.questdata.config ~= nil and quest.questdata.config.version ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.version = quest.questdata.config.version
    end
    if quest ~= nil and quest.questdata.config.params.params ~= nil then
      if msg.quest.questdata.config.params == nil then
        msg.quest.questdata.config.params = {}
      end
      if msg.quest.questdata.config.params.params == nil then
        msg.quest.questdata.config.params.params = {}
      end
      for i = 1, #quest.questdata.config.params.params do
        table.insert(msg.quest.questdata.config.params.params, quest.questdata.config.params.params[i])
      end
    end
    if quest ~= nil and quest.questdata.config.ExtraJump.params ~= nil then
      if msg.quest.questdata.config.ExtraJump == nil then
        msg.quest.questdata.config.ExtraJump = {}
      end
      if msg.quest.questdata.config.ExtraJump.params == nil then
        msg.quest.questdata.config.ExtraJump.params = {}
      end
      for i = 1, #quest.questdata.config.ExtraJump.params do
        table.insert(msg.quest.questdata.config.ExtraJump.params, quest.questdata.config.ExtraJump.params[i])
      end
    end
    if quest ~= nil and quest.questdata.config.stepactions ~= nil then
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      if msg.quest.questdata.config.stepactions == nil then
        msg.quest.questdata.config.stepactions = {}
      end
      for i = 1, #quest.questdata.config.stepactions do
        table.insert(msg.quest.questdata.config.stepactions, quest.questdata.config.stepactions[i])
      end
    end
    if quest ~= nil and quest.questdata.config.allreward ~= nil then
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      if msg.quest.questdata.config.allreward == nil then
        msg.quest.questdata.config.allreward = {}
      end
      for i = 1, #quest.questdata.config.allreward do
        table.insert(msg.quest.questdata.config.allreward, quest.questdata.config.allreward[i])
      end
    end
    if quest ~= nil and quest.questdata.config.PreQuest ~= nil then
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      if msg.quest.questdata.config.PreQuest == nil then
        msg.quest.questdata.config.PreQuest = {}
      end
      for i = 1, #quest.questdata.config.PreQuest do
        table.insert(msg.quest.questdata.config.PreQuest, quest.questdata.config.PreQuest[i])
      end
    end
    if quest ~= nil and quest.questdata.config.MustPreQuest ~= nil then
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      if msg.quest.questdata.config.MustPreQuest == nil then
        msg.quest.questdata.config.MustPreQuest = {}
      end
      for i = 1, #quest.questdata.config.MustPreQuest do
        table.insert(msg.quest.questdata.config.MustPreQuest, quest.questdata.config.MustPreQuest[i])
      end
    end
    if quest ~= nil and quest.questdata.config.PreMenu ~= nil then
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      if msg.quest.questdata.config.PreMenu == nil then
        msg.quest.questdata.config.PreMenu = {}
      end
      for i = 1, #quest.questdata.config.PreMenu do
        table.insert(msg.quest.questdata.config.PreMenu, quest.questdata.config.PreMenu[i])
      end
    end
    if quest ~= nil and quest.questdata.config.MustPreMenu ~= nil then
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      if msg.quest.questdata.config.MustPreMenu == nil then
        msg.quest.questdata.config.MustPreMenu = {}
      end
      for i = 1, #quest.questdata.config.MustPreMenu do
        table.insert(msg.quest.questdata.config.MustPreMenu, quest.questdata.config.MustPreMenu[i])
      end
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Headicon ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Headicon = quest.questdata.config.Headicon
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Hide ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.Hide = quest.questdata.config.Hide
    end
    if quest.questdata.config ~= nil and quest.questdata.config.CreateTime ~= nil then
      if msg.quest.questdata == nil then
        msg.quest.questdata = {}
      end
      if msg.quest.questdata.config == nil then
        msg.quest.questdata.config = {}
      end
      msg.quest.questdata.config.CreateTime = quest.questdata.config.CreateTime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateWantedQuestTeamCmd.id
    local msgParam = {}
    if quest ~= nil and quest.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.charid = quest.charid
    end
    if quest ~= nil and quest.questid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.questid = quest.questid
    end
    if quest ~= nil and quest.action ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.action = quest.action
    end
    if quest ~= nil and quest.step ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.step = quest.step
    end
    if quest.questdata ~= nil and quest.questdata.process ~= nil then
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      msgParam.quest.questdata.process = quest.questdata.process
    end
    if quest ~= nil and quest.questdata.params ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.params == nil then
        msgParam.quest.questdata.params = {}
      end
      for i = 1, #quest.questdata.params do
        table.insert(msgParam.quest.questdata.params, quest.questdata.params[i])
      end
    end
    if quest ~= nil and quest.questdata.names ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.names == nil then
        msgParam.quest.questdata.names = {}
      end
      for i = 1, #quest.questdata.names do
        table.insert(msgParam.quest.questdata.names, quest.questdata.names[i])
      end
    end
    if quest.questdata.config ~= nil and quest.questdata.config.QuestID ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.QuestID = quest.questdata.config.QuestID
    end
    if quest.questdata.config ~= nil and quest.questdata.config.GroupID ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.GroupID = quest.questdata.config.GroupID
    end
    if quest.questdata.config ~= nil and quest.questdata.config.RewardGroup ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.RewardGroup = quest.questdata.config.RewardGroup
    end
    if quest.questdata.config ~= nil and quest.questdata.config.SubGroup ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.SubGroup = quest.questdata.config.SubGroup
    end
    if quest.questdata.config ~= nil and quest.questdata.config.FinishJump ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.FinishJump = quest.questdata.config.FinishJump
    end
    if quest.questdata.config ~= nil and quest.questdata.config.FailJump ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.FailJump = quest.questdata.config.FailJump
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Map ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Map = quest.questdata.config.Map
    end
    if quest.questdata.config ~= nil and quest.questdata.config.WhetherTrace ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.WhetherTrace = quest.questdata.config.WhetherTrace
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Auto ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Auto = quest.questdata.config.Auto
    end
    if quest.questdata.config ~= nil and quest.questdata.config.FirstClass ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.FirstClass = quest.questdata.config.FirstClass
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Class ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Class = quest.questdata.config.Class
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Level ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Level = quest.questdata.config.Level
    end
    if quest.questdata.config ~= nil and quest.questdata.config.PreNoShow ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.PreNoShow = quest.questdata.config.PreNoShow
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Risklevel ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Risklevel = quest.questdata.config.Risklevel
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Joblevel ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Joblevel = quest.questdata.config.Joblevel
    end
    if quest.questdata.config ~= nil and quest.questdata.config.CookerLv ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.CookerLv = quest.questdata.config.CookerLv
    end
    if quest.questdata.config ~= nil and quest.questdata.config.TasterLv ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.TasterLv = quest.questdata.config.TasterLv
    end
    if quest.questdata.config ~= nil and quest.questdata.config.StartTime ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.StartTime = quest.questdata.config.StartTime
    end
    if quest.questdata.config ~= nil and quest.questdata.config.EndTime ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.EndTime = quest.questdata.config.EndTime
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Icon ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Icon = quest.questdata.config.Icon
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Color ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Color = quest.questdata.config.Color
    end
    if quest.questdata.config ~= nil and quest.questdata.config.QuestName ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.QuestName = quest.questdata.config.QuestName
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Name ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Name = quest.questdata.config.Name
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Type ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Type = quest.questdata.config.Type
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Content ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Content = quest.questdata.config.Content
    end
    if quest.questdata.config ~= nil and quest.questdata.config.TraceInfo ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.TraceInfo = quest.questdata.config.TraceInfo
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Prefixion ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Prefixion = quest.questdata.config.Prefixion
    end
    if quest.questdata.config ~= nil and quest.questdata.config.version ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.version = quest.questdata.config.version
    end
    if quest ~= nil and quest.questdata.config.params.params ~= nil then
      if msgParam.quest.questdata.config.params == nil then
        msgParam.quest.questdata.config.params = {}
      end
      if msgParam.quest.questdata.config.params.params == nil then
        msgParam.quest.questdata.config.params.params = {}
      end
      for i = 1, #quest.questdata.config.params.params do
        table.insert(msgParam.quest.questdata.config.params.params, quest.questdata.config.params.params[i])
      end
    end
    if quest ~= nil and quest.questdata.config.ExtraJump.params ~= nil then
      if msgParam.quest.questdata.config.ExtraJump == nil then
        msgParam.quest.questdata.config.ExtraJump = {}
      end
      if msgParam.quest.questdata.config.ExtraJump.params == nil then
        msgParam.quest.questdata.config.ExtraJump.params = {}
      end
      for i = 1, #quest.questdata.config.ExtraJump.params do
        table.insert(msgParam.quest.questdata.config.ExtraJump.params, quest.questdata.config.ExtraJump.params[i])
      end
    end
    if quest ~= nil and quest.questdata.config.stepactions ~= nil then
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      if msgParam.quest.questdata.config.stepactions == nil then
        msgParam.quest.questdata.config.stepactions = {}
      end
      for i = 1, #quest.questdata.config.stepactions do
        table.insert(msgParam.quest.questdata.config.stepactions, quest.questdata.config.stepactions[i])
      end
    end
    if quest ~= nil and quest.questdata.config.allreward ~= nil then
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      if msgParam.quest.questdata.config.allreward == nil then
        msgParam.quest.questdata.config.allreward = {}
      end
      for i = 1, #quest.questdata.config.allreward do
        table.insert(msgParam.quest.questdata.config.allreward, quest.questdata.config.allreward[i])
      end
    end
    if quest ~= nil and quest.questdata.config.PreQuest ~= nil then
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      if msgParam.quest.questdata.config.PreQuest == nil then
        msgParam.quest.questdata.config.PreQuest = {}
      end
      for i = 1, #quest.questdata.config.PreQuest do
        table.insert(msgParam.quest.questdata.config.PreQuest, quest.questdata.config.PreQuest[i])
      end
    end
    if quest ~= nil and quest.questdata.config.MustPreQuest ~= nil then
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      if msgParam.quest.questdata.config.MustPreQuest == nil then
        msgParam.quest.questdata.config.MustPreQuest = {}
      end
      for i = 1, #quest.questdata.config.MustPreQuest do
        table.insert(msgParam.quest.questdata.config.MustPreQuest, quest.questdata.config.MustPreQuest[i])
      end
    end
    if quest ~= nil and quest.questdata.config.PreMenu ~= nil then
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      if msgParam.quest.questdata.config.PreMenu == nil then
        msgParam.quest.questdata.config.PreMenu = {}
      end
      for i = 1, #quest.questdata.config.PreMenu do
        table.insert(msgParam.quest.questdata.config.PreMenu, quest.questdata.config.PreMenu[i])
      end
    end
    if quest ~= nil and quest.questdata.config.MustPreMenu ~= nil then
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      if msgParam.quest.questdata.config.MustPreMenu == nil then
        msgParam.quest.questdata.config.MustPreMenu = {}
      end
      for i = 1, #quest.questdata.config.MustPreMenu do
        table.insert(msgParam.quest.questdata.config.MustPreMenu, quest.questdata.config.MustPreMenu[i])
      end
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Headicon ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Headicon = quest.questdata.config.Headicon
    end
    if quest.questdata.config ~= nil and quest.questdata.config.Hide ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.Hide = quest.questdata.config.Hide
    end
    if quest.questdata.config ~= nil and quest.questdata.config.CreateTime ~= nil then
      if msgParam.quest.questdata == nil then
        msgParam.quest.questdata = {}
      end
      if msgParam.quest.questdata.config == nil then
        msgParam.quest.questdata.config = {}
      end
      msgParam.quest.questdata.config.CreateTime = quest.questdata.config.CreateTime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallAcceptHelpWantedTeamCmd(questid, isabandon)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.AcceptHelpWantedTeamCmd()
    if questid ~= nil then
      msg.questid = questid
    end
    if isabandon ~= nil then
      msg.isabandon = isabandon
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AcceptHelpWantedTeamCmd.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    if isabandon ~= nil then
      msgParam.isabandon = isabandon
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallUpdateHelpWantedTeamCmd(addlist, dellist)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.UpdateHelpWantedTeamCmd()
    if addlist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addlist == nil then
        msg.addlist = {}
      end
      for i = 1, #addlist do
        table.insert(msg.addlist, addlist[i])
      end
    end
    if dellist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dellist == nil then
        msg.dellist = {}
      end
      for i = 1, #dellist do
        table.insert(msg.dellist, dellist[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateHelpWantedTeamCmd.id
    local msgParam = {}
    if addlist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addlist == nil then
        msgParam.addlist = {}
      end
      for i = 1, #addlist do
        table.insert(msgParam.addlist, addlist[i])
      end
    end
    if dellist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dellist == nil then
        msgParam.dellist = {}
      end
      for i = 1, #dellist do
        table.insert(msgParam.dellist, dellist[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQueryHelpWantedTeamCmd(questids)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QueryHelpWantedTeamCmd()
    if questids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.questids == nil then
        msg.questids = {}
      end
      for i = 1, #questids do
        table.insert(msg.questids, questids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryHelpWantedTeamCmd.id
    local msgParam = {}
    if questids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.questids == nil then
        msgParam.questids = {}
      end
      for i = 1, #questids do
        table.insert(msgParam.questids, questids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQueryMemberCatTeamCmd()
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QueryMemberCatTeamCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMemberCatTeamCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallMemberCatUpdateTeam(updates, dels)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.MemberCatUpdateTeam()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemberCatUpdateTeam.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallCancelApplyTeamCmd(teamid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.CancelApplyTeamCmd()
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CancelApplyTeamCmd.id
    local msgParam = {}
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQueryMemberTeamCmd(teamid, members, items)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QueryMemberTeamCmd()
    if teamid ~= nil then
      msg.teamid = teamid
    end
    if members ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.members == nil then
        msg.members = {}
      end
      for i = 1, #members do
        table.insert(msg.members, members[i])
      end
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMemberTeamCmd.id
    local msgParam = {}
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    if members ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.members == nil then
        msgParam.members = {}
      end
      for i = 1, #members do
        table.insert(msgParam.members, members[i])
      end
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallUserApplyUpdateTeamCmd(updates, deletes)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.UserApplyUpdateTeamCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deletes == nil then
        msg.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msg.deletes, deletes[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserApplyUpdateTeamCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deletes == nil then
        msgParam.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msgParam.deletes, deletes[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallInviteGroupTeamCmd(charid, leadername, mycharid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.InviteGroupTeamCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if leadername ~= nil then
      msg.leadername = leadername
    end
    if mycharid ~= nil then
      msg.mycharid = mycharid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteGroupTeamCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if leadername ~= nil then
      msgParam.leadername = leadername
    end
    if mycharid ~= nil then
      msgParam.mycharid = mycharid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallProcessInviteGroupTeamCmd(agree, charid, mycharid, fighting)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ProcessInviteGroupTeamCmd()
    if agree ~= nil then
      msg.agree = agree
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if mycharid ~= nil then
      msg.mycharid = mycharid
    end
    if fighting ~= nil then
      msg.fighting = fighting
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessInviteGroupTeamCmd.id
    local msgParam = {}
    if agree ~= nil then
      msgParam.agree = agree
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if mycharid ~= nil then
      msgParam.mycharid = mycharid
    end
    if fighting ~= nil then
      msgParam.fighting = fighting
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallDissolveGroupTeamCmd()
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.DissolveGroupTeamCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DissolveGroupTeamCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallChangeGroupLeaderTeamCmd(charid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ChangeGroupLeaderTeamCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeGroupLeaderTeamCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallGroupUpdateNtfTeamCmd()
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.GroupUpdateNtfTeamCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GroupUpdateNtfTeamCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallQueryGroupTeamApplyListTeamCmd(teamid, applys)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.QueryGroupTeamApplyListTeamCmd()
    if teamid ~= nil then
      msg.teamid = teamid
    end
    if applys ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applys == nil then
        msg.applys = {}
      end
      for i = 1, #applys do
        table.insert(msg.applys, applys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGroupTeamApplyListTeamCmd.id
    local msgParam = {}
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    if applys ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applys == nil then
        msgParam.applys = {}
      end
      for i = 1, #applys do
        table.insert(msgParam.applys, applys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamGroupApplyUpdate(updates, deletes)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamGroupApplyUpdate()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deletes == nil then
        msg.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msg.deletes, deletes[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamGroupApplyUpdate.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deletes == nil then
        msgParam.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msgParam.deletes, deletes[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallTeamGroupApplyTeamCmd(applyteamid, applyinfo, cancel)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.TeamGroupApplyTeamCmd()
    if applyteamid ~= nil then
      msg.applyteamid = applyteamid
    end
    if applyinfo ~= nil and applyinfo.teamid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applyinfo == nil then
        msg.applyinfo = {}
      end
      msg.applyinfo.teamid = applyinfo.teamid
    end
    if applyinfo ~= nil and applyinfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applyinfo == nil then
        msg.applyinfo = {}
      end
      msg.applyinfo.name = applyinfo.name
    end
    if applyinfo ~= nil and applyinfo.memnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applyinfo == nil then
        msg.applyinfo = {}
      end
      msg.applyinfo.memnum = applyinfo.memnum
    end
    if applyinfo ~= nil and applyinfo.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applyinfo == nil then
        msg.applyinfo = {}
      end
      msg.applyinfo.createtime = applyinfo.createtime
    end
    if applyinfo ~= nil and applyinfo.minlv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applyinfo == nil then
        msg.applyinfo = {}
      end
      msg.applyinfo.minlv = applyinfo.minlv
    end
    if applyinfo ~= nil and applyinfo.maxlv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.applyinfo == nil then
        msg.applyinfo = {}
      end
      msg.applyinfo.maxlv = applyinfo.maxlv
    end
    if cancel ~= nil then
      msg.cancel = cancel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamGroupApplyTeamCmd.id
    local msgParam = {}
    if applyteamid ~= nil then
      msgParam.applyteamid = applyteamid
    end
    if applyinfo ~= nil and applyinfo.teamid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applyinfo == nil then
        msgParam.applyinfo = {}
      end
      msgParam.applyinfo.teamid = applyinfo.teamid
    end
    if applyinfo ~= nil and applyinfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applyinfo == nil then
        msgParam.applyinfo = {}
      end
      msgParam.applyinfo.name = applyinfo.name
    end
    if applyinfo ~= nil and applyinfo.memnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applyinfo == nil then
        msgParam.applyinfo = {}
      end
      msgParam.applyinfo.memnum = applyinfo.memnum
    end
    if applyinfo ~= nil and applyinfo.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applyinfo == nil then
        msgParam.applyinfo = {}
      end
      msgParam.applyinfo.createtime = applyinfo.createtime
    end
    if applyinfo ~= nil and applyinfo.minlv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applyinfo == nil then
        msgParam.applyinfo = {}
      end
      msgParam.applyinfo.minlv = applyinfo.minlv
    end
    if applyinfo ~= nil and applyinfo.maxlv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.applyinfo == nil then
        msgParam.applyinfo = {}
      end
      msgParam.applyinfo.maxlv = applyinfo.maxlv
    end
    if cancel ~= nil then
      msgParam.cancel = cancel
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallProcessGroupApplyTeamCmd(etype, teamid)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ProcessGroupApplyTeamCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessGroupApplyTeamCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallMyGroupApplyUpdateTeamCmd(updates, deletes)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.MyGroupApplyUpdateTeamCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deletes == nil then
        msg.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msg.deletes, deletes[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MyGroupApplyUpdateTeamCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deletes == nil then
        msgParam.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msgParam.deletes, deletes[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallLaunckKickTeamCmd(sponsor, kickid, cancel)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.LaunckKickTeamCmd()
    if sponsor ~= nil then
      msg.sponsor = sponsor
    end
    if kickid ~= nil then
      msg.kickid = kickid
    end
    if cancel ~= nil then
      msg.cancel = cancel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LaunckKickTeamCmd.id
    local msgParam = {}
    if sponsor ~= nil then
      msgParam.sponsor = sponsor
    end
    if kickid ~= nil then
      msgParam.kickid = kickid
    end
    if cancel ~= nil then
      msgParam.cancel = cancel
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallReplyKickTeamCmd(agree)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ReplyKickTeamCmd()
    if agree ~= nil then
      msg.agree = agree
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyKickTeamCmd.id
    local msgParam = {}
    if agree ~= nil then
      msgParam.agree = agree
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallGMEMuteTeamCmd(charid, mute)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.GMEMuteTeamCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if mute ~= nil then
      msg.mute = mute
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GMEMuteTeamCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if mute ~= nil then
      msgParam.mute = mute
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallReqRecruitPublishTeamCmd()
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ReqRecruitPublishTeamCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqRecruitPublishTeamCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallNewRecruitPublishTeamCmd(team, chat)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.NewRecruitPublishTeamCmd()
    if team.data ~= nil and team.data.guid ~= nil then
      if msg.team == nil then
        msg.team = {}
      end
      if msg.team.data == nil then
        msg.team.data = {}
      end
      msg.team.data.guid = team.data.guid
    end
    if team.data ~= nil and team.data.zoneid ~= nil then
      if msg.team == nil then
        msg.team = {}
      end
      if msg.team.data == nil then
        msg.team.data = {}
      end
      msg.team.data.zoneid = team.data.zoneid
    end
    if team.data ~= nil and team.data.name ~= nil then
      if msg.team == nil then
        msg.team = {}
      end
      if msg.team.data == nil then
        msg.team.data = {}
      end
      msg.team.data.name = team.data.name
    end
    if team ~= nil and team.data.items ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.items == nil then
        msg.team.data.items = {}
      end
      for i = 1, #team.data.items do
        table.insert(msg.team.data.items, team.data.items[i])
      end
    end
    if team ~= nil and team.data.members ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.members == nil then
        msg.team.data.members = {}
      end
      for i = 1, #team.data.members do
        table.insert(msg.team.data.members, team.data.members[i])
      end
    end
    if team ~= nil and team.data.applys ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.applys == nil then
        msg.team.data.applys = {}
      end
      for i = 1, #team.data.applys do
        table.insert(msg.team.data.applys, team.data.applys[i])
      end
    end
    if team.data.seal ~= nil and team.data.seal.seal ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      msg.team.data.seal.seal = team.data.seal.seal
    end
    if team.data.seal ~= nil and team.data.seal.zoneid ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      msg.team.data.seal.zoneid = team.data.seal.zoneid
    end
    if team.data.seal.pos ~= nil and team.data.seal.pos.x ~= nil then
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      if msg.team.data.seal.pos == nil then
        msg.team.data.seal.pos = {}
      end
      msg.team.data.seal.pos.x = team.data.seal.pos.x
    end
    if team.data.seal.pos ~= nil and team.data.seal.pos.y ~= nil then
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      if msg.team.data.seal.pos == nil then
        msg.team.data.seal.pos = {}
      end
      msg.team.data.seal.pos.y = team.data.seal.pos.y
    end
    if team.data.seal.pos ~= nil and team.data.seal.pos.z ~= nil then
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      if msg.team.data.seal.pos == nil then
        msg.team.data.seal.pos = {}
      end
      msg.team.data.seal.pos.z = team.data.seal.pos.z
    end
    if team.data.seal ~= nil and team.data.seal.teamid ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      msg.team.data.seal.teamid = team.data.seal.teamid
    end
    if team.data.seal ~= nil and team.data.seal.lastonlinetime ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      msg.team.data.seal.lastonlinetime = team.data.seal.lastonlinetime
    end
    if team.data.seal ~= nil and team.data.seal.dataversion ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.seal == nil then
        msg.team.data.seal = {}
      end
      msg.team.data.seal.dataversion = team.data.seal.dataversion
    end
    if team ~= nil and team.data.groupapplys ~= nil then
      if msg.team.data == nil then
        msg.team.data = {}
      end
      if msg.team.data.groupapplys == nil then
        msg.team.data.groupapplys = {}
      end
      for i = 1, #team.data.groupapplys do
        table.insert(msg.team.data.groupapplys, team.data.groupapplys[i])
      end
    end
    if team ~= nil and team.version_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.team == nil then
        msg.team = {}
      end
      msg.team.version_time = team.version_time
    end
    if chat ~= nil and chat.cmd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.cmd = chat.cmd
    end
    if chat ~= nil and chat.param ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.param = chat.param
    end
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.accid = chat.accid
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.id = chat.id
    if chat ~= nil and chat.targetid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.targetid = chat.targetid
    end
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.portrait = chat.portrait
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.frame = chat.frame
    if chat ~= nil and chat.baselevel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.baselevel = chat.baselevel
    end
    if chat ~= nil and chat.voiceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.voiceid = chat.voiceid
    end
    if chat ~= nil and chat.voicetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.voicetime = chat.voicetime
    end
    if chat ~= nil and chat.hair ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.hair = chat.hair
    end
    if chat ~= nil and chat.haircolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.haircolor = chat.haircolor
    end
    if chat ~= nil and chat.body ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.body = chat.body
    end
    if chat ~= nil and chat.appellation ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.appellation = chat.appellation
    end
    if chat ~= nil and chat.msgid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.msgid = chat.msgid
    end
    if chat ~= nil and chat.head ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.head = chat.head
    end
    if chat ~= nil and chat.face ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.face = chat.face
    end
    if chat ~= nil and chat.mouth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.mouth = chat.mouth
    end
    if chat ~= nil and chat.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.eye = chat.eye
    end
    if chat ~= nil and chat.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.roomid = chat.roomid
    end
    if chat ~= nil and chat.portrait_frame ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.portrait_frame = chat.portrait_frame
    end
    if chat ~= nil and chat.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.serverid = chat.serverid
    end
    if chat ~= nil and chat.channel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.channel = chat.channel
    end
    if chat ~= nil and chat.rolejob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.rolejob = chat.rolejob
    end
    if chat ~= nil and chat.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.gender = chat.gender
    end
    if chat ~= nil and chat.blink ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.blink = chat.blink
    end
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.str = chat.str
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.name = chat.name
    if chat ~= nil and chat.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.guildname = chat.guildname
    end
    if chat ~= nil and chat.sysmsgid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.sysmsgid = chat.sysmsgid
    end
    if chat.photo ~= nil and chat.photo.accid_svr ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.accid_svr = chat.photo.accid_svr
    end
    if chat.photo ~= nil and chat.photo.accid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.accid = chat.photo.accid
    end
    if chat.photo ~= nil and chat.photo.charid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.charid = chat.photo.charid
    end
    if chat.photo ~= nil and chat.photo.anglez ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.anglez = chat.photo.anglez
    end
    if chat.photo ~= nil and chat.photo.time ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.time = chat.photo.time
    end
    if chat.photo ~= nil and chat.photo.mapid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.mapid = chat.photo.mapid
    end
    if chat.photo ~= nil and chat.photo.sourceid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.sourceid = chat.photo.sourceid
    end
    if chat.photo ~= nil and chat.photo.source ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.source = chat.photo.source
    end
    if chat.expression ~= nil and chat.expression.type ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.expression == nil then
        msg.chat.expression = {}
      end
      msg.chat.expression.type = chat.expression.type
    end
    if chat.expression ~= nil and chat.expression.id ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.expression == nil then
        msg.chat.expression = {}
      end
      msg.chat.expression.id = chat.expression.id
    end
    if chat.expression ~= nil and chat.expression.pos ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.expression == nil then
        msg.chat.expression = {}
      end
      msg.chat.expression.pos = chat.expression.pos
    end
    if chat.redpacketret ~= nil and chat.redpacketret.strRedPacketID ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      msg.chat.redpacketret.strRedPacketID = chat.redpacketret.strRedPacketID
    end
    if chat.redpacketret ~= nil and chat.redpacketret.itemID ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      msg.chat.redpacketret.itemID = chat.redpacketret.itemID
    end
    if chat.redpacketret ~= nil and chat.redpacketret.str ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      msg.chat.redpacketret.str = chat.redpacketret.str
    end
    if chat.redpacketret ~= nil and chat.redpacketret.guild_job ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      msg.chat.redpacketret.guild_job = chat.redpacketret.guild_job
    end
    if chat.redpacketret ~= nil and chat.redpacketret.guildid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      msg.chat.redpacketret.guildid = chat.redpacketret.guildid
    end
    if chat.redpacketret ~= nil and chat.redpacketret.targetid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      msg.chat.redpacketret.targetid = chat.redpacketret.targetid
    end
    if chat ~= nil and chat.redpacketret.gvg_charids ~= nil then
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      if msg.chat.redpacketret.gvg_charids == nil then
        msg.chat.redpacketret.gvg_charids = {}
      end
      for i = 1, #chat.redpacketret.gvg_charids do
        table.insert(msg.chat.redpacketret.gvg_charids, chat.redpacketret.gvg_charids[i])
      end
    end
    if chat ~= nil and chat.redpacketret.praise_charids ~= nil then
      if msg.chat.redpacketret == nil then
        msg.chat.redpacketret = {}
      end
      if msg.chat.redpacketret.praise_charids == nil then
        msg.chat.redpacketret.praise_charids = {}
      end
      for i = 1, #chat.redpacketret.praise_charids do
        table.insert(msg.chat.redpacketret.praise_charids, chat.redpacketret.praise_charids[i])
      end
    end
    if chat ~= nil and chat.isreturnuser ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.isreturnuser = chat.isreturnuser
    end
    if chat ~= nil and chat.chat_frame ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.chat_frame = chat.chat_frame
    end
    if chat ~= nil and chat.items ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.items == nil then
        msg.chat.items = {}
      end
      for i = 1, #chat.items do
        table.insert(msg.chat.items, chat.items[i])
      end
    end
    if chat.share_data ~= nil and chat.share_data.type ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.share_data == nil then
        msg.chat.share_data = {}
      end
      msg.chat.share_data.type = chat.share_data.type
    end
    if chat ~= nil and chat.share_data.share_items ~= nil then
      if msg.chat.share_data == nil then
        msg.chat.share_data = {}
      end
      if msg.chat.share_data.share_items == nil then
        msg.chat.share_data.share_items = {}
      end
      for i = 1, #chat.share_data.share_items do
        table.insert(msg.chat.share_data.share_items, chat.share_data.share_items[i])
      end
    end
    if chat ~= nil and chat.share_data.items ~= nil then
      if msg.chat.share_data == nil then
        msg.chat.share_data = {}
      end
      if msg.chat.share_data.items == nil then
        msg.chat.share_data.items = {}
      end
      for i = 1, #chat.share_data.items do
        table.insert(msg.chat.share_data.items, chat.share_data.items[i])
      end
    end
    if chat ~= nil and chat.love_confession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.love_confession = chat.love_confession
    end
    if chat.postcard ~= nil and chat.postcard.id ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.id = chat.postcard.id
    end
    if chat.postcard ~= nil and chat.postcard.url ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.url = chat.postcard.url
    end
    if chat.postcard ~= nil and chat.postcard.type ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.type = chat.postcard.type
    end
    if chat.postcard ~= nil and chat.postcard.source ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.source = chat.postcard.source
    end
    if chat.postcard ~= nil and chat.postcard.from_char ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.from_char = chat.postcard.from_char
    end
    if chat.postcard ~= nil and chat.postcard.from_name ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.from_name = chat.postcard.from_name
    end
    if chat.postcard ~= nil and chat.postcard.paper_style ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.paper_style = chat.postcard.paper_style
    end
    if chat.postcard ~= nil and chat.postcard.content ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.content = chat.postcard.content
    end
    if chat.postcard ~= nil and chat.postcard.save_time ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.save_time = chat.postcard.save_time
    end
    if chat.postcard ~= nil and chat.postcard.quest_postcard_id ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.postcard == nil then
        msg.chat.postcard = {}
      end
      msg.chat.postcard.quest_postcard_id = chat.postcard.quest_postcard_id
    end
    if chat ~= nil and chat.timestamp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.timestamp = chat.timestamp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewRecruitPublishTeamCmd.id
    local msgParam = {}
    if team.data ~= nil and team.data.guid ~= nil then
      if msgParam.team == nil then
        msgParam.team = {}
      end
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      msgParam.team.data.guid = team.data.guid
    end
    if team.data ~= nil and team.data.zoneid ~= nil then
      if msgParam.team == nil then
        msgParam.team = {}
      end
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      msgParam.team.data.zoneid = team.data.zoneid
    end
    if team.data ~= nil and team.data.name ~= nil then
      if msgParam.team == nil then
        msgParam.team = {}
      end
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      msgParam.team.data.name = team.data.name
    end
    if team ~= nil and team.data.items ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.items == nil then
        msgParam.team.data.items = {}
      end
      for i = 1, #team.data.items do
        table.insert(msgParam.team.data.items, team.data.items[i])
      end
    end
    if team ~= nil and team.data.members ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.members == nil then
        msgParam.team.data.members = {}
      end
      for i = 1, #team.data.members do
        table.insert(msgParam.team.data.members, team.data.members[i])
      end
    end
    if team ~= nil and team.data.applys ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.applys == nil then
        msgParam.team.data.applys = {}
      end
      for i = 1, #team.data.applys do
        table.insert(msgParam.team.data.applys, team.data.applys[i])
      end
    end
    if team.data.seal ~= nil and team.data.seal.seal ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      msgParam.team.data.seal.seal = team.data.seal.seal
    end
    if team.data.seal ~= nil and team.data.seal.zoneid ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      msgParam.team.data.seal.zoneid = team.data.seal.zoneid
    end
    if team.data.seal.pos ~= nil and team.data.seal.pos.x ~= nil then
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      if msgParam.team.data.seal.pos == nil then
        msgParam.team.data.seal.pos = {}
      end
      msgParam.team.data.seal.pos.x = team.data.seal.pos.x
    end
    if team.data.seal.pos ~= nil and team.data.seal.pos.y ~= nil then
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      if msgParam.team.data.seal.pos == nil then
        msgParam.team.data.seal.pos = {}
      end
      msgParam.team.data.seal.pos.y = team.data.seal.pos.y
    end
    if team.data.seal.pos ~= nil and team.data.seal.pos.z ~= nil then
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      if msgParam.team.data.seal.pos == nil then
        msgParam.team.data.seal.pos = {}
      end
      msgParam.team.data.seal.pos.z = team.data.seal.pos.z
    end
    if team.data.seal ~= nil and team.data.seal.teamid ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      msgParam.team.data.seal.teamid = team.data.seal.teamid
    end
    if team.data.seal ~= nil and team.data.seal.lastonlinetime ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      msgParam.team.data.seal.lastonlinetime = team.data.seal.lastonlinetime
    end
    if team.data.seal ~= nil and team.data.seal.dataversion ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.seal == nil then
        msgParam.team.data.seal = {}
      end
      msgParam.team.data.seal.dataversion = team.data.seal.dataversion
    end
    if team ~= nil and team.data.groupapplys ~= nil then
      if msgParam.team.data == nil then
        msgParam.team.data = {}
      end
      if msgParam.team.data.groupapplys == nil then
        msgParam.team.data.groupapplys = {}
      end
      for i = 1, #team.data.groupapplys do
        table.insert(msgParam.team.data.groupapplys, team.data.groupapplys[i])
      end
    end
    if team ~= nil and team.version_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.team == nil then
        msgParam.team = {}
      end
      msgParam.team.version_time = team.version_time
    end
    if chat ~= nil and chat.cmd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.cmd = chat.cmd
    end
    if chat ~= nil and chat.param ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.param = chat.param
    end
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.accid = chat.accid
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.id = chat.id
    if chat ~= nil and chat.targetid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.targetid = chat.targetid
    end
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.portrait = chat.portrait
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.frame = chat.frame
    if chat ~= nil and chat.baselevel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.baselevel = chat.baselevel
    end
    if chat ~= nil and chat.voiceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.voiceid = chat.voiceid
    end
    if chat ~= nil and chat.voicetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.voicetime = chat.voicetime
    end
    if chat ~= nil and chat.hair ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.hair = chat.hair
    end
    if chat ~= nil and chat.haircolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.haircolor = chat.haircolor
    end
    if chat ~= nil and chat.body ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.body = chat.body
    end
    if chat ~= nil and chat.appellation ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.appellation = chat.appellation
    end
    if chat ~= nil and chat.msgid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.msgid = chat.msgid
    end
    if chat ~= nil and chat.head ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.head = chat.head
    end
    if chat ~= nil and chat.face ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.face = chat.face
    end
    if chat ~= nil and chat.mouth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.mouth = chat.mouth
    end
    if chat ~= nil and chat.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.eye = chat.eye
    end
    if chat ~= nil and chat.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.roomid = chat.roomid
    end
    if chat ~= nil and chat.portrait_frame ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.portrait_frame = chat.portrait_frame
    end
    if chat ~= nil and chat.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.serverid = chat.serverid
    end
    if chat ~= nil and chat.channel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.channel = chat.channel
    end
    if chat ~= nil and chat.rolejob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.rolejob = chat.rolejob
    end
    if chat ~= nil and chat.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.gender = chat.gender
    end
    if chat ~= nil and chat.blink ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.blink = chat.blink
    end
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.str = chat.str
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.name = chat.name
    if chat ~= nil and chat.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.guildname = chat.guildname
    end
    if chat ~= nil and chat.sysmsgid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.sysmsgid = chat.sysmsgid
    end
    if chat.photo ~= nil and chat.photo.accid_svr ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.accid_svr = chat.photo.accid_svr
    end
    if chat.photo ~= nil and chat.photo.accid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.accid = chat.photo.accid
    end
    if chat.photo ~= nil and chat.photo.charid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.charid = chat.photo.charid
    end
    if chat.photo ~= nil and chat.photo.anglez ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.anglez = chat.photo.anglez
    end
    if chat.photo ~= nil and chat.photo.time ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.time = chat.photo.time
    end
    if chat.photo ~= nil and chat.photo.mapid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.mapid = chat.photo.mapid
    end
    if chat.photo ~= nil and chat.photo.sourceid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.sourceid = chat.photo.sourceid
    end
    if chat.photo ~= nil and chat.photo.source ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.source = chat.photo.source
    end
    if chat.expression ~= nil and chat.expression.type ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.expression == nil then
        msgParam.chat.expression = {}
      end
      msgParam.chat.expression.type = chat.expression.type
    end
    if chat.expression ~= nil and chat.expression.id ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.expression == nil then
        msgParam.chat.expression = {}
      end
      msgParam.chat.expression.id = chat.expression.id
    end
    if chat.expression ~= nil and chat.expression.pos ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.expression == nil then
        msgParam.chat.expression = {}
      end
      msgParam.chat.expression.pos = chat.expression.pos
    end
    if chat.redpacketret ~= nil and chat.redpacketret.strRedPacketID ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      msgParam.chat.redpacketret.strRedPacketID = chat.redpacketret.strRedPacketID
    end
    if chat.redpacketret ~= nil and chat.redpacketret.itemID ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      msgParam.chat.redpacketret.itemID = chat.redpacketret.itemID
    end
    if chat.redpacketret ~= nil and chat.redpacketret.str ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      msgParam.chat.redpacketret.str = chat.redpacketret.str
    end
    if chat.redpacketret ~= nil and chat.redpacketret.guild_job ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      msgParam.chat.redpacketret.guild_job = chat.redpacketret.guild_job
    end
    if chat.redpacketret ~= nil and chat.redpacketret.guildid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      msgParam.chat.redpacketret.guildid = chat.redpacketret.guildid
    end
    if chat.redpacketret ~= nil and chat.redpacketret.targetid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      msgParam.chat.redpacketret.targetid = chat.redpacketret.targetid
    end
    if chat ~= nil and chat.redpacketret.gvg_charids ~= nil then
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      if msgParam.chat.redpacketret.gvg_charids == nil then
        msgParam.chat.redpacketret.gvg_charids = {}
      end
      for i = 1, #chat.redpacketret.gvg_charids do
        table.insert(msgParam.chat.redpacketret.gvg_charids, chat.redpacketret.gvg_charids[i])
      end
    end
    if chat ~= nil and chat.redpacketret.praise_charids ~= nil then
      if msgParam.chat.redpacketret == nil then
        msgParam.chat.redpacketret = {}
      end
      if msgParam.chat.redpacketret.praise_charids == nil then
        msgParam.chat.redpacketret.praise_charids = {}
      end
      for i = 1, #chat.redpacketret.praise_charids do
        table.insert(msgParam.chat.redpacketret.praise_charids, chat.redpacketret.praise_charids[i])
      end
    end
    if chat ~= nil and chat.isreturnuser ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.isreturnuser = chat.isreturnuser
    end
    if chat ~= nil and chat.chat_frame ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.chat_frame = chat.chat_frame
    end
    if chat ~= nil and chat.items ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.items == nil then
        msgParam.chat.items = {}
      end
      for i = 1, #chat.items do
        table.insert(msgParam.chat.items, chat.items[i])
      end
    end
    if chat.share_data ~= nil and chat.share_data.type ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.share_data == nil then
        msgParam.chat.share_data = {}
      end
      msgParam.chat.share_data.type = chat.share_data.type
    end
    if chat ~= nil and chat.share_data.share_items ~= nil then
      if msgParam.chat.share_data == nil then
        msgParam.chat.share_data = {}
      end
      if msgParam.chat.share_data.share_items == nil then
        msgParam.chat.share_data.share_items = {}
      end
      for i = 1, #chat.share_data.share_items do
        table.insert(msgParam.chat.share_data.share_items, chat.share_data.share_items[i])
      end
    end
    if chat ~= nil and chat.share_data.items ~= nil then
      if msgParam.chat.share_data == nil then
        msgParam.chat.share_data = {}
      end
      if msgParam.chat.share_data.items == nil then
        msgParam.chat.share_data.items = {}
      end
      for i = 1, #chat.share_data.items do
        table.insert(msgParam.chat.share_data.items, chat.share_data.items[i])
      end
    end
    if chat ~= nil and chat.love_confession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.love_confession = chat.love_confession
    end
    if chat.postcard ~= nil and chat.postcard.id ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.id = chat.postcard.id
    end
    if chat.postcard ~= nil and chat.postcard.url ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.url = chat.postcard.url
    end
    if chat.postcard ~= nil and chat.postcard.type ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.type = chat.postcard.type
    end
    if chat.postcard ~= nil and chat.postcard.source ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.source = chat.postcard.source
    end
    if chat.postcard ~= nil and chat.postcard.from_char ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.from_char = chat.postcard.from_char
    end
    if chat.postcard ~= nil and chat.postcard.from_name ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.from_name = chat.postcard.from_name
    end
    if chat.postcard ~= nil and chat.postcard.paper_style ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.paper_style = chat.postcard.paper_style
    end
    if chat.postcard ~= nil and chat.postcard.content ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.content = chat.postcard.content
    end
    if chat.postcard ~= nil and chat.postcard.save_time ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.save_time = chat.postcard.save_time
    end
    if chat.postcard ~= nil and chat.postcard.quest_postcard_id ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.postcard == nil then
        msgParam.chat.postcard = {}
      end
      msgParam.chat.postcard.quest_postcard_id = chat.postcard.quest_postcard_id
    end
    if chat ~= nil and chat.timestamp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.timestamp = chat.timestamp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallReqRecruitTeamInfoTeamCmd(teams)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ReqRecruitTeamInfoTeamCmd()
    if teams ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teams == nil then
        msg.teams = {}
      end
      for i = 1, #teams do
        table.insert(msg.teams, teams[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqRecruitTeamInfoTeamCmd.id
    local msgParam = {}
    if teams ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teams == nil then
        msgParam.teams = {}
      end
      for i = 1, #teams do
        table.insert(msgParam.teams, teams[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallUpdateRecruitTeamInfoTeamCmd(delids, teams)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.UpdateRecruitTeamInfoTeamCmd()
    if delids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delids == nil then
        msg.delids = {}
      end
      for i = 1, #delids do
        table.insert(msg.delids, delids[i])
      end
    end
    if teams ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teams == nil then
        msg.teams = {}
      end
      for i = 1, #teams do
        table.insert(msg.teams, teams[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateRecruitTeamInfoTeamCmd.id
    local msgParam = {}
    if delids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delids == nil then
        msgParam.delids = {}
      end
      for i = 1, #delids do
        table.insert(msgParam.delids, delids[i])
      end
    end
    if teams ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teams == nil then
        msgParam.teams = {}
      end
      for i = 1, #teams do
        table.insert(msgParam.teams, teams[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallChangeGroupMemberTeamCmd(mainteam_mems, subteam_mems)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.ChangeGroupMemberTeamCmd()
    if mainteam_mems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mainteam_mems == nil then
        msg.mainteam_mems = {}
      end
      for i = 1, #mainteam_mems do
        table.insert(msg.mainteam_mems, mainteam_mems[i])
      end
    end
    if subteam_mems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.subteam_mems == nil then
        msg.subteam_mems = {}
      end
      for i = 1, #subteam_mems do
        table.insert(msg.subteam_mems, subteam_mems[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeGroupMemberTeamCmd.id
    local msgParam = {}
    if mainteam_mems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mainteam_mems == nil then
        msgParam.mainteam_mems = {}
      end
      for i = 1, #mainteam_mems do
        table.insert(msgParam.mainteam_mems, mainteam_mems[i])
      end
    end
    if subteam_mems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.subteam_mems == nil then
        msgParam.subteam_mems = {}
      end
      for i = 1, #subteam_mems do
        table.insert(msgParam.subteam_mems, subteam_mems[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallPublishReqHelpTeamCmd(teaminfo)
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.PublishReqHelpTeamCmd()
    if teaminfo ~= nil and teaminfo.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      msg.teaminfo.guid = teaminfo.guid
    end
    if teaminfo ~= nil and teaminfo.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      msg.teaminfo.zoneid = teaminfo.zoneid
    end
    if teaminfo ~= nil and teaminfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      msg.teaminfo.name = teaminfo.name
    end
    if teaminfo ~= nil and teaminfo.items ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.items == nil then
        msg.teaminfo.items = {}
      end
      for i = 1, #teaminfo.items do
        table.insert(msg.teaminfo.items, teaminfo.items[i])
      end
    end
    if teaminfo ~= nil and teaminfo.members ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.members == nil then
        msg.teaminfo.members = {}
      end
      for i = 1, #teaminfo.members do
        table.insert(msg.teaminfo.members, teaminfo.members[i])
      end
    end
    if teaminfo ~= nil and teaminfo.applys ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.applys == nil then
        msg.teaminfo.applys = {}
      end
      for i = 1, #teaminfo.applys do
        table.insert(msg.teaminfo.applys, teaminfo.applys[i])
      end
    end
    if teaminfo.seal ~= nil and teaminfo.seal.seal ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      msg.teaminfo.seal.seal = teaminfo.seal.seal
    end
    if teaminfo.seal ~= nil and teaminfo.seal.zoneid ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      msg.teaminfo.seal.zoneid = teaminfo.seal.zoneid
    end
    if teaminfo.seal.pos ~= nil and teaminfo.seal.pos.x ~= nil then
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      if msg.teaminfo.seal.pos == nil then
        msg.teaminfo.seal.pos = {}
      end
      msg.teaminfo.seal.pos.x = teaminfo.seal.pos.x
    end
    if teaminfo.seal.pos ~= nil and teaminfo.seal.pos.y ~= nil then
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      if msg.teaminfo.seal.pos == nil then
        msg.teaminfo.seal.pos = {}
      end
      msg.teaminfo.seal.pos.y = teaminfo.seal.pos.y
    end
    if teaminfo.seal.pos ~= nil and teaminfo.seal.pos.z ~= nil then
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      if msg.teaminfo.seal.pos == nil then
        msg.teaminfo.seal.pos = {}
      end
      msg.teaminfo.seal.pos.z = teaminfo.seal.pos.z
    end
    if teaminfo.seal ~= nil and teaminfo.seal.teamid ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      msg.teaminfo.seal.teamid = teaminfo.seal.teamid
    end
    if teaminfo.seal ~= nil and teaminfo.seal.lastonlinetime ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      msg.teaminfo.seal.lastonlinetime = teaminfo.seal.lastonlinetime
    end
    if teaminfo.seal ~= nil and teaminfo.seal.dataversion ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.seal == nil then
        msg.teaminfo.seal = {}
      end
      msg.teaminfo.seal.dataversion = teaminfo.seal.dataversion
    end
    if teaminfo ~= nil and teaminfo.groupapplys ~= nil then
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      if msg.teaminfo.groupapplys == nil then
        msg.teaminfo.groupapplys = {}
      end
      for i = 1, #teaminfo.groupapplys do
        table.insert(msg.teaminfo.groupapplys, teaminfo.groupapplys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PublishReqHelpTeamCmd.id
    local msgParam = {}
    if teaminfo ~= nil and teaminfo.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      msgParam.teaminfo.guid = teaminfo.guid
    end
    if teaminfo ~= nil and teaminfo.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      msgParam.teaminfo.zoneid = teaminfo.zoneid
    end
    if teaminfo ~= nil and teaminfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      msgParam.teaminfo.name = teaminfo.name
    end
    if teaminfo ~= nil and teaminfo.items ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.items == nil then
        msgParam.teaminfo.items = {}
      end
      for i = 1, #teaminfo.items do
        table.insert(msgParam.teaminfo.items, teaminfo.items[i])
      end
    end
    if teaminfo ~= nil and teaminfo.members ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.members == nil then
        msgParam.teaminfo.members = {}
      end
      for i = 1, #teaminfo.members do
        table.insert(msgParam.teaminfo.members, teaminfo.members[i])
      end
    end
    if teaminfo ~= nil and teaminfo.applys ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.applys == nil then
        msgParam.teaminfo.applys = {}
      end
      for i = 1, #teaminfo.applys do
        table.insert(msgParam.teaminfo.applys, teaminfo.applys[i])
      end
    end
    if teaminfo.seal ~= nil and teaminfo.seal.seal ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      msgParam.teaminfo.seal.seal = teaminfo.seal.seal
    end
    if teaminfo.seal ~= nil and teaminfo.seal.zoneid ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      msgParam.teaminfo.seal.zoneid = teaminfo.seal.zoneid
    end
    if teaminfo.seal.pos ~= nil and teaminfo.seal.pos.x ~= nil then
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      if msgParam.teaminfo.seal.pos == nil then
        msgParam.teaminfo.seal.pos = {}
      end
      msgParam.teaminfo.seal.pos.x = teaminfo.seal.pos.x
    end
    if teaminfo.seal.pos ~= nil and teaminfo.seal.pos.y ~= nil then
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      if msgParam.teaminfo.seal.pos == nil then
        msgParam.teaminfo.seal.pos = {}
      end
      msgParam.teaminfo.seal.pos.y = teaminfo.seal.pos.y
    end
    if teaminfo.seal.pos ~= nil and teaminfo.seal.pos.z ~= nil then
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      if msgParam.teaminfo.seal.pos == nil then
        msgParam.teaminfo.seal.pos = {}
      end
      msgParam.teaminfo.seal.pos.z = teaminfo.seal.pos.z
    end
    if teaminfo.seal ~= nil and teaminfo.seal.teamid ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      msgParam.teaminfo.seal.teamid = teaminfo.seal.teamid
    end
    if teaminfo.seal ~= nil and teaminfo.seal.lastonlinetime ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      msgParam.teaminfo.seal.lastonlinetime = teaminfo.seal.lastonlinetime
    end
    if teaminfo.seal ~= nil and teaminfo.seal.dataversion ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.seal == nil then
        msgParam.teaminfo.seal = {}
      end
      msgParam.teaminfo.seal.dataversion = teaminfo.seal.dataversion
    end
    if teaminfo ~= nil and teaminfo.groupapplys ~= nil then
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      if msgParam.teaminfo.groupapplys == nil then
        msgParam.teaminfo.groupapplys = {}
      end
      for i = 1, #teaminfo.groupapplys do
        table.insert(msgParam.teaminfo.groupapplys, teaminfo.groupapplys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:CallAskForTeamInfoTeamCmd()
  if not NetConfig.PBC then
    local msg = SessionTeam_pb.AskForTeamInfoTeamCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AskForTeamInfoTeamCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionTeamAutoProxy:RecvTeamList(data)
  self:Notify(ServiceEvent.SessionTeamTeamList, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamDataUpdate(data)
  self:Notify(ServiceEvent.SessionTeamTeamDataUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamMemberUpdate(data)
  self:Notify(ServiceEvent.SessionTeamTeamMemberUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamApplyUpdate(data)
  self:Notify(ServiceEvent.SessionTeamTeamApplyUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvCreateTeam(data)
  self:Notify(ServiceEvent.SessionTeamCreateTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvInviteMember(data)
  self:Notify(ServiceEvent.SessionTeamInviteMember, data)
end

function ServiceSessionTeamAutoProxy:RecvProcessTeamInvite(data)
  self:Notify(ServiceEvent.SessionTeamProcessTeamInvite, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamMemberApply(data)
  self:Notify(ServiceEvent.SessionTeamTeamMemberApply, data)
end

function ServiceSessionTeamAutoProxy:RecvProcessTeamApply(data)
  self:Notify(ServiceEvent.SessionTeamProcessTeamApply, data)
end

function ServiceSessionTeamAutoProxy:RecvKickMember(data)
  self:Notify(ServiceEvent.SessionTeamKickMember, data)
end

function ServiceSessionTeamAutoProxy:RecvExchangeLeader(data)
  self:Notify(ServiceEvent.SessionTeamExchangeLeader, data)
end

function ServiceSessionTeamAutoProxy:RecvExitTeam(data)
  self:Notify(ServiceEvent.SessionTeamExitTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvEnterTeam(data)
  self:Notify(ServiceEvent.SessionTeamEnterTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvMemberPosUpdate(data)
  self:Notify(ServiceEvent.SessionTeamMemberPosUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvMemberDataUpdate(data)
  self:Notify(ServiceEvent.SessionTeamMemberDataUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvLockTarget(data)
  self:Notify(ServiceEvent.SessionTeamLockTarget, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamSummon(data)
  self:Notify(ServiceEvent.SessionTeamTeamSummon, data)
end

function ServiceSessionTeamAutoProxy:RecvClearApplyList(data)
  self:Notify(ServiceEvent.SessionTeamClearApplyList, data)
end

function ServiceSessionTeamAutoProxy:RecvQuickEnter(data)
  self:Notify(ServiceEvent.SessionTeamQuickEnter, data)
end

function ServiceSessionTeamAutoProxy:RecvSetTeamOption(data)
  self:Notify(ServiceEvent.SessionTeamSetTeamOption, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryUserTeamInfoTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvSetMemberOptionTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamSetMemberOptionTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQuestWantedQuestTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvUpdateWantedQuestTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvAcceptHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamAcceptHelpWantedTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvUpdateHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateHelpWantedTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryHelpWantedTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryMemberCatTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryMemberCatTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvMemberCatUpdateTeam(data)
  self:Notify(ServiceEvent.SessionTeamMemberCatUpdateTeam, data)
end

function ServiceSessionTeamAutoProxy:RecvCancelApplyTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamCancelApplyTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryMemberTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryMemberTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvUserApplyUpdateTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUserApplyUpdateTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvInviteGroupTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamInviteGroupTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvProcessInviteGroupTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamProcessInviteGroupTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvDissolveGroupTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamDissolveGroupTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvChangeGroupLeaderTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamChangeGroupLeaderTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvGroupUpdateNtfTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamGroupUpdateNtfTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvQueryGroupTeamApplyListTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryGroupTeamApplyListTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamGroupApplyUpdate(data)
  self:Notify(ServiceEvent.SessionTeamTeamGroupApplyUpdate, data)
end

function ServiceSessionTeamAutoProxy:RecvTeamGroupApplyTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamTeamGroupApplyTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvProcessGroupApplyTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamProcessGroupApplyTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvMyGroupApplyUpdateTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamMyGroupApplyUpdateTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvLaunckKickTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamLaunckKickTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvReplyKickTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamReplyKickTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvGMEMuteTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamGMEMuteTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvReqRecruitPublishTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamReqRecruitPublishTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvNewRecruitPublishTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamNewRecruitPublishTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvReqRecruitTeamInfoTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamReqRecruitTeamInfoTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvUpdateRecruitTeamInfoTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateRecruitTeamInfoTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvChangeGroupMemberTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamChangeGroupMemberTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvPublishReqHelpTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamPublishReqHelpTeamCmd, data)
end

function ServiceSessionTeamAutoProxy:RecvAskForTeamInfoTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamAskForTeamInfoTeamCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SessionTeamTeamList = "ServiceEvent_SessionTeamTeamList"
ServiceEvent.SessionTeamTeamDataUpdate = "ServiceEvent_SessionTeamTeamDataUpdate"
ServiceEvent.SessionTeamTeamMemberUpdate = "ServiceEvent_SessionTeamTeamMemberUpdate"
ServiceEvent.SessionTeamTeamApplyUpdate = "ServiceEvent_SessionTeamTeamApplyUpdate"
ServiceEvent.SessionTeamCreateTeam = "ServiceEvent_SessionTeamCreateTeam"
ServiceEvent.SessionTeamInviteMember = "ServiceEvent_SessionTeamInviteMember"
ServiceEvent.SessionTeamProcessTeamInvite = "ServiceEvent_SessionTeamProcessTeamInvite"
ServiceEvent.SessionTeamTeamMemberApply = "ServiceEvent_SessionTeamTeamMemberApply"
ServiceEvent.SessionTeamProcessTeamApply = "ServiceEvent_SessionTeamProcessTeamApply"
ServiceEvent.SessionTeamKickMember = "ServiceEvent_SessionTeamKickMember"
ServiceEvent.SessionTeamExchangeLeader = "ServiceEvent_SessionTeamExchangeLeader"
ServiceEvent.SessionTeamExitTeam = "ServiceEvent_SessionTeamExitTeam"
ServiceEvent.SessionTeamEnterTeam = "ServiceEvent_SessionTeamEnterTeam"
ServiceEvent.SessionTeamMemberPosUpdate = "ServiceEvent_SessionTeamMemberPosUpdate"
ServiceEvent.SessionTeamMemberDataUpdate = "ServiceEvent_SessionTeamMemberDataUpdate"
ServiceEvent.SessionTeamLockTarget = "ServiceEvent_SessionTeamLockTarget"
ServiceEvent.SessionTeamTeamSummon = "ServiceEvent_SessionTeamTeamSummon"
ServiceEvent.SessionTeamClearApplyList = "ServiceEvent_SessionTeamClearApplyList"
ServiceEvent.SessionTeamQuickEnter = "ServiceEvent_SessionTeamQuickEnter"
ServiceEvent.SessionTeamSetTeamOption = "ServiceEvent_SessionTeamSetTeamOption"
ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd = "ServiceEvent_SessionTeamQueryUserTeamInfoTeamCmd"
ServiceEvent.SessionTeamSetMemberOptionTeamCmd = "ServiceEvent_SessionTeamSetMemberOptionTeamCmd"
ServiceEvent.SessionTeamQuestWantedQuestTeamCmd = "ServiceEvent_SessionTeamQuestWantedQuestTeamCmd"
ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd = "ServiceEvent_SessionTeamUpdateWantedQuestTeamCmd"
ServiceEvent.SessionTeamAcceptHelpWantedTeamCmd = "ServiceEvent_SessionTeamAcceptHelpWantedTeamCmd"
ServiceEvent.SessionTeamUpdateHelpWantedTeamCmd = "ServiceEvent_SessionTeamUpdateHelpWantedTeamCmd"
ServiceEvent.SessionTeamQueryHelpWantedTeamCmd = "ServiceEvent_SessionTeamQueryHelpWantedTeamCmd"
ServiceEvent.SessionTeamQueryMemberCatTeamCmd = "ServiceEvent_SessionTeamQueryMemberCatTeamCmd"
ServiceEvent.SessionTeamMemberCatUpdateTeam = "ServiceEvent_SessionTeamMemberCatUpdateTeam"
ServiceEvent.SessionTeamCancelApplyTeamCmd = "ServiceEvent_SessionTeamCancelApplyTeamCmd"
ServiceEvent.SessionTeamQueryMemberTeamCmd = "ServiceEvent_SessionTeamQueryMemberTeamCmd"
ServiceEvent.SessionTeamUserApplyUpdateTeamCmd = "ServiceEvent_SessionTeamUserApplyUpdateTeamCmd"
ServiceEvent.SessionTeamInviteGroupTeamCmd = "ServiceEvent_SessionTeamInviteGroupTeamCmd"
ServiceEvent.SessionTeamProcessInviteGroupTeamCmd = "ServiceEvent_SessionTeamProcessInviteGroupTeamCmd"
ServiceEvent.SessionTeamDissolveGroupTeamCmd = "ServiceEvent_SessionTeamDissolveGroupTeamCmd"
ServiceEvent.SessionTeamChangeGroupLeaderTeamCmd = "ServiceEvent_SessionTeamChangeGroupLeaderTeamCmd"
ServiceEvent.SessionTeamGroupUpdateNtfTeamCmd = "ServiceEvent_SessionTeamGroupUpdateNtfTeamCmd"
ServiceEvent.SessionTeamQueryGroupTeamApplyListTeamCmd = "ServiceEvent_SessionTeamQueryGroupTeamApplyListTeamCmd"
ServiceEvent.SessionTeamTeamGroupApplyUpdate = "ServiceEvent_SessionTeamTeamGroupApplyUpdate"
ServiceEvent.SessionTeamTeamGroupApplyTeamCmd = "ServiceEvent_SessionTeamTeamGroupApplyTeamCmd"
ServiceEvent.SessionTeamProcessGroupApplyTeamCmd = "ServiceEvent_SessionTeamProcessGroupApplyTeamCmd"
ServiceEvent.SessionTeamMyGroupApplyUpdateTeamCmd = "ServiceEvent_SessionTeamMyGroupApplyUpdateTeamCmd"
ServiceEvent.SessionTeamLaunckKickTeamCmd = "ServiceEvent_SessionTeamLaunckKickTeamCmd"
ServiceEvent.SessionTeamReplyKickTeamCmd = "ServiceEvent_SessionTeamReplyKickTeamCmd"
ServiceEvent.SessionTeamGMEMuteTeamCmd = "ServiceEvent_SessionTeamGMEMuteTeamCmd"
ServiceEvent.SessionTeamReqRecruitPublishTeamCmd = "ServiceEvent_SessionTeamReqRecruitPublishTeamCmd"
ServiceEvent.SessionTeamNewRecruitPublishTeamCmd = "ServiceEvent_SessionTeamNewRecruitPublishTeamCmd"
ServiceEvent.SessionTeamReqRecruitTeamInfoTeamCmd = "ServiceEvent_SessionTeamReqRecruitTeamInfoTeamCmd"
ServiceEvent.SessionTeamUpdateRecruitTeamInfoTeamCmd = "ServiceEvent_SessionTeamUpdateRecruitTeamInfoTeamCmd"
ServiceEvent.SessionTeamChangeGroupMemberTeamCmd = "ServiceEvent_SessionTeamChangeGroupMemberTeamCmd"
ServiceEvent.SessionTeamPublishReqHelpTeamCmd = "ServiceEvent_SessionTeamPublishReqHelpTeamCmd"
ServiceEvent.SessionTeamAskForTeamInfoTeamCmd = "ServiceEvent_SessionTeamAskForTeamInfoTeamCmd"
