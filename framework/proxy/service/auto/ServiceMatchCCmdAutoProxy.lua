ServiceMatchCCmdAutoProxy = class("ServiceMatchCCmdAutoProxy", ServiceProxy)
ServiceMatchCCmdAutoProxy.Instance = nil
ServiceMatchCCmdAutoProxy.NAME = "ServiceMatchCCmdAutoProxy"

function ServiceMatchCCmdAutoProxy:ctor(proxyName)
  if ServiceMatchCCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMatchCCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMatchCCmdAutoProxy.Instance = self
  end
end

function ServiceMatchCCmdAutoProxy:Init()
end

function ServiceMatchCCmdAutoProxy:onRegister()
  self:Listen(61, 1, function(data)
    self:RecvReqMyRoomMatchCCmd(data)
  end)
  self:Listen(61, 2, function(data)
    self:RecvReqRoomListCCmd(data)
  end)
  self:Listen(61, 3, function(data)
    self:RecvReqRoomDetailCCmd(data)
  end)
  self:Listen(61, 4, function(data)
    self:RecvJoinRoomCCmd(data)
  end)
  self:Listen(61, 5, function(data)
    self:RecvLeaveRoomCCmd(data)
  end)
  self:Listen(61, 7, function(data)
    self:RecvNtfRoomStateCCmd(data)
  end)
  self:Listen(61, 8, function(data)
    self:RecvNtfFightStatCCmd(data)
  end)
  self:Listen(61, 9, function(data)
    self:RecvJoinFightingCCmd(data)
  end)
  self:Listen(61, 10, function(data)
    self:RecvComboNotifyCCmd(data)
  end)
  self:Listen(61, 11, function(data)
    self:RecvRevChallengeCCmd(data)
  end)
  self:Listen(61, 12, function(data)
    self:RecvKickTeamCCmd(data)
  end)
  self:Listen(61, 13, function(data)
    self:RecvFightConfirmCCmd(data)
  end)
  self:Listen(61, 14, function(data)
    self:RecvPvpResultCCmd(data)
  end)
  self:Listen(61, 15, function(data)
    self:RecvPvpTeamMemberUpdateCCmd(data)
  end)
  self:Listen(61, 16, function(data)
    self:RecvPvpMemberDataUpdateCCmd(data)
  end)
  self:Listen(61, 17, function(data)
    self:RecvNtfMatchInfoCCmd(data)
  end)
  self:Listen(61, 18, function(data)
    self:RecvGodEndTimeCCmd(data)
  end)
  self:Listen(61, 19, function(data)
    self:RecvNtfRankChangeCCmd(data)
  end)
  self:Listen(61, 20, function(data)
    self:RecvOpenGlobalShopPanelCCmd(data)
  end)
  self:Listen(61, 21, function(data)
    self:RecvTutorMatchResultNtfMatchCCmd(data)
  end)
  self:Listen(61, 22, function(data)
    self:RecvTutorMatchResponseMatchCCmd(data)
  end)
  self:Listen(61, 23, function(data)
    self:RecvTeamPwsPreInfoMatchCCmd(data)
  end)
  self:Listen(61, 24, function(data)
    self:RecvUpdatePreInfoMatchCCmd(data)
  end)
  self:Listen(61, 25, function(data)
    self:RecvQueryTeamPwsRankMatchCCmd(data)
  end)
  self:Listen(61, 26, function(data)
    self:RecvQueryTeamPwsTeamInfoMatchCCmd(data)
  end)
  self:Listen(61, 27, function(data)
    self:RecvQueryMenrocoRankMatchCCmd(data)
  end)
  self:Listen(61, 28, function(data)
    self:RecvMidMatchPrepareMatchCCmd(data)
  end)
  self:Listen(61, 29, function(data)
    self:RecvQueryBattlePassRankMatchCCmd(data)
  end)
  self:Listen(61, 30, function(data)
    self:RecvTwelvePvpPreInfoMatchCCmd(data)
  end)
  self:Listen(61, 31, function(data)
    self:RecvTwelvePvpUpdatePreInfoMatchCCmd(data)
  end)
  self:Listen(61, 43, function(data)
    self:RecvTwelveWarbandQueryMatchCCmd(data)
  end)
  self:Listen(61, 32, function(data)
    self:RecvTwelveWarbandSortMatchCCmd(data)
  end)
  self:Listen(61, 33, function(data)
    self:RecvTwelveWarbandTreeMatchCCmd(data)
  end)
  self:Listen(61, 34, function(data)
    self:RecvTwelveWarbandInfoMatchCCmd(data)
  end)
  self:Listen(61, 35, function(data)
    self:RecvTwelveWarbandInviterMatchCCmd(data)
  end)
  self:Listen(61, 36, function(data)
    self:RecvTwelveWarbandInviteeMatchCCmd(data)
  end)
  self:Listen(61, 37, function(data)
    self:RecvTwelveWarbandPrepareMatchCCmd(data)
  end)
  self:Listen(61, 38, function(data)
    self:RecvTwelveWarbandLeaveMatchCCmd(data)
  end)
  self:Listen(61, 39, function(data)
    self:RecvTwelveWarbandDeleteMatchCCmd(data)
  end)
  self:Listen(61, 40, function(data)
    self:RecvTwelveWarbandNameMatchCCmd(data)
  end)
  self:Listen(61, 41, function(data)
    self:RecvTwelveWarbandSignUpMatchCCmd(data)
  end)
  self:Listen(61, 42, function(data)
    self:RecvTwelveWarbandMatchMatchCCmd(data)
  end)
  self:Listen(61, 44, function(data)
    self:RecvTwelveWarbandTeamListMatchCCmd(data)
  end)
  self:Listen(61, 45, function(data)
    self:RecvTwelveWarbandCreateMatchCCmd(data)
  end)
  self:Listen(61, 46, function(data)
    self:RecvSyncMatchInfoCCmd(data)
  end)
  self:Listen(61, 47, function(data)
    self:RecvQueryTwelveSeasonInfoMatchCCmd(data)
  end)
  self:Listen(61, 48, function(data)
    self:RecvQueryTwelveSeasonFinishMatchCCmd(data)
  end)
  self:Listen(61, 49, function(data)
    self:RecvSyncMatchBoardOpenStateMatchCCmd(data)
  end)
  self:Listen(61, 50, function(data)
    self:RecvTwelveSeasonTimeInfoMatchCCmd(data)
  end)
  self:Listen(61, 51, function(data)
    self:RecvEnterObservationMatchCCmd(data)
  end)
  self:Listen(61, 52, function(data)
    self:RecvObInitInfoFubenCmd(data)
  end)
  self:Listen(61, 53, function(data)
    self:RecvReserveRoomBuildMatchCCmd(data)
  end)
  self:Listen(61, 54, function(data)
    self:RecvReserveRoomInviterMatchCCmd(data)
  end)
  self:Listen(61, 55, function(data)
    self:RecvReserveRoomInviteeMatchCCmd(data)
  end)
  self:Listen(61, 56, function(data)
    self:RecvReserveRoomKickMatchCCmd(data)
  end)
  self:Listen(61, 57, function(data)
    self:RecvReserveRoomLeaveMatchCCmd(data)
  end)
  self:Listen(61, 58, function(data)
    self:RecvReserveRoomApplyMatchCCmd(data)
  end)
  self:Listen(61, 59, function(data)
    self:RecvReserveRoomInfoMatchCCmd(data)
  end)
  self:Listen(61, 60, function(data)
    self:RecvReserveRoomListMatchCCmd(data)
  end)
  self:Listen(61, 61, function(data)
    self:RecvReserveRoomStartMatchCCmd(data)
  end)
  self:Listen(61, 62, function(data)
    self:RecvReserveRoomChangeMatchCCmd(data)
  end)
  self:Listen(61, 63, function(data)
    self:RecvReserveRoomPrepareMatchCCmd(data)
  end)
  self:Listen(61, 64, function(data)
    self:RecvJoinRaidWithRobotMatchCCmd(data)
  end)
  self:Listen(61, 65, function(data)
    self:RecvDesertWolfStatQueryCmd(data)
  end)
  self:Listen(61, 66, function(data)
    self:RecvDesertWolfRuleSyncCmd(data)
  end)
  self:Listen(61, 67, function(data)
    self:RecvQueryTriplePwsRankMatchCCmd(data)
  end)
  self:Listen(61, 68, function(data)
    self:RecvQueryTriplePwsTeamInfoMatchCCmd(data)
  end)
  self:Listen(61, 69, function(data)
    self:RecvTriplePvpQuestQueryCmd(data)
  end)
  self:Listen(61, 70, function(data)
    self:RecvSyncMatchHeadInfoMatchCCmd(data)
  end)
  self:Listen(61, 71, function(data)
    self:RecvTriplePvpPickRewardCmd(data)
  end)
  self:Listen(61, 72, function(data)
    self:RecvTriplePvpRewardStatusCmd(data)
  end)
  self:Listen(61, 73, function(data)
    self:RecvChampionPvpPickRewardCmd(data)
  end)
  self:Listen(61, 74, function(data)
    self:RecvChampionPvpRewardStatusCmd(data)
  end)
end

function ServiceMatchCCmdAutoProxy:CallReqMyRoomMatchCCmd(type, brief_info)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReqMyRoomMatchCCmd()
    if type ~= nil then
      msg.type = type
    end
    if brief_info ~= nil and brief_info.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.type = brief_info.type
    end
    if brief_info ~= nil and brief_info.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.state = brief_info.state
    end
    if brief_info ~= nil and brief_info.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.roomid = brief_info.roomid
    end
    if brief_info ~= nil and brief_info.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.name = brief_info.name
    end
    if brief_info ~= nil and brief_info.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.raidid = brief_info.raidid
    end
    if brief_info ~= nil and brief_info.player_num ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.player_num = brief_info.player_num
    end
    if brief_info ~= nil and brief_info.num1 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.num1 = brief_info.num1
    end
    if brief_info ~= nil and brief_info.num2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.num2 = brief_info.num2
    end
    if brief_info ~= nil and brief_info.num3 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.num3 = brief_info.num3
    end
    if brief_info ~= nil and brief_info.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.brief_info == nil then
        msg.brief_info = {}
      end
      msg.brief_info.zoneid = brief_info.zoneid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqMyRoomMatchCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if brief_info ~= nil and brief_info.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.type = brief_info.type
    end
    if brief_info ~= nil and brief_info.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.state = brief_info.state
    end
    if brief_info ~= nil and brief_info.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.roomid = brief_info.roomid
    end
    if brief_info ~= nil and brief_info.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.name = brief_info.name
    end
    if brief_info ~= nil and brief_info.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.raidid = brief_info.raidid
    end
    if brief_info ~= nil and brief_info.player_num ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.player_num = brief_info.player_num
    end
    if brief_info ~= nil and brief_info.num1 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.num1 = brief_info.num1
    end
    if brief_info ~= nil and brief_info.num2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.num2 = brief_info.num2
    end
    if brief_info ~= nil and brief_info.num3 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.num3 = brief_info.num3
    end
    if brief_info ~= nil and brief_info.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.brief_info == nil then
        msgParam.brief_info = {}
      end
      msgParam.brief_info.zoneid = brief_info.zoneid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReqRoomListCCmd(type, roomids, room_lists)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReqRoomListCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.roomids == nil then
        msg.roomids = {}
      end
      for i = 1, #roomids do
        table.insert(msg.roomids, roomids[i])
      end
    end
    if room_lists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.room_lists == nil then
        msg.room_lists = {}
      end
      for i = 1, #room_lists do
        table.insert(msg.room_lists, room_lists[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqRoomListCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.roomids == nil then
        msgParam.roomids = {}
      end
      for i = 1, #roomids do
        table.insert(msgParam.roomids, roomids[i])
      end
    end
    if room_lists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.room_lists == nil then
        msgParam.room_lists = {}
      end
      for i = 1, #room_lists do
        table.insert(msgParam.room_lists, room_lists[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReqRoomDetailCCmd(type, roomid, datail_info)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReqRoomDetailCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if datail_info ~= nil and datail_info.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datail_info == nil then
        msg.datail_info = {}
      end
      msg.datail_info.type = datail_info.type
    end
    if datail_info ~= nil and datail_info.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datail_info == nil then
        msg.datail_info = {}
      end
      msg.datail_info.state = datail_info.state
    end
    if datail_info ~= nil and datail_info.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datail_info == nil then
        msg.datail_info = {}
      end
      msg.datail_info.roomid = datail_info.roomid
    end
    if datail_info ~= nil and datail_info.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datail_info == nil then
        msg.datail_info = {}
      end
      msg.datail_info.name = datail_info.name
    end
    if datail_info ~= nil and datail_info.team_datas ~= nil then
      if msg.datail_info == nil then
        msg.datail_info = {}
      end
      if msg.datail_info.team_datas == nil then
        msg.datail_info.team_datas = {}
      end
      for i = 1, #datail_info.team_datas do
        table.insert(msg.datail_info.team_datas, datail_info.team_datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqRoomDetailCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if datail_info ~= nil and datail_info.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datail_info == nil then
        msgParam.datail_info = {}
      end
      msgParam.datail_info.type = datail_info.type
    end
    if datail_info ~= nil and datail_info.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datail_info == nil then
        msgParam.datail_info = {}
      end
      msgParam.datail_info.state = datail_info.state
    end
    if datail_info ~= nil and datail_info.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datail_info == nil then
        msgParam.datail_info = {}
      end
      msgParam.datail_info.roomid = datail_info.roomid
    end
    if datail_info ~= nil and datail_info.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datail_info == nil then
        msgParam.datail_info = {}
      end
      msgParam.datail_info.name = datail_info.name
    end
    if datail_info ~= nil and datail_info.team_datas ~= nil then
      if msgParam.datail_info == nil then
        msgParam.datail_info = {}
      end
      if msgParam.datail_info.team_datas == nil then
        msgParam.datail_info.team_datas = {}
      end
      for i = 1, #datail_info.team_datas do
        table.insert(msgParam.datail_info.team_datas, datail_info.team_datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallJoinRoomCCmd(type, roomid, name, isquick, teamid, teammember, ret, guildid, users, matcher, charid, zoneid, serverid, teamexptype, only_myserver, entranceid, need_robot_npc, need_heal_profession)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.JoinRoomCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if name ~= nil then
      msg.name = name
    end
    if isquick ~= nil then
      msg.isquick = isquick
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    if teammember ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teammember == nil then
        msg.teammember = {}
      end
      for i = 1, #teammember do
        table.insert(msg.teammember, teammember[i])
      end
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if users ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.users == nil then
        msg.users = {}
      end
      for i = 1, #users do
        table.insert(msg.users, users[i])
      end
    end
    if matcher ~= nil and matcher.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.matcher == nil then
        msg.matcher = {}
      end
      msg.matcher.charid = matcher.charid
    end
    if matcher ~= nil and matcher.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.matcher == nil then
        msg.matcher = {}
      end
      msg.matcher.zoneid = matcher.zoneid
    end
    if matcher ~= nil and matcher.findtutor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.matcher == nil then
        msg.matcher = {}
      end
      msg.matcher.findtutor = matcher.findtutor
    end
    if matcher ~= nil and matcher.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.matcher == nil then
        msg.matcher = {}
      end
      msg.matcher.gender = matcher.gender
    end
    if matcher ~= nil and matcher.selfgender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.matcher == nil then
        msg.matcher = {}
      end
      msg.matcher.selfgender = matcher.selfgender
    end
    if matcher ~= nil and matcher.datas ~= nil then
      if msg.matcher == nil then
        msg.matcher = {}
      end
      if msg.matcher.datas == nil then
        msg.matcher.datas = {}
      end
      for i = 1, #matcher.datas do
        table.insert(msg.matcher.datas, matcher.datas[i])
      end
    end
    if matcher ~= nil and matcher.blackids ~= nil then
      if msg.matcher == nil then
        msg.matcher = {}
      end
      if msg.matcher.blackids == nil then
        msg.matcher.blackids = {}
      end
      for i = 1, #matcher.blackids do
        table.insert(msg.matcher.blackids, matcher.blackids[i])
      end
    end
    if matcher ~= nil and matcher.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.matcher == nil then
        msg.matcher = {}
      end
      msg.matcher.serverid = matcher.serverid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if teamexptype ~= nil then
      msg.teamexptype = teamexptype
    end
    if only_myserver ~= nil then
      msg.only_myserver = only_myserver
    end
    if entranceid ~= nil then
      msg.entranceid = entranceid
    end
    if need_robot_npc ~= nil then
      msg.need_robot_npc = need_robot_npc
    end
    if need_heal_profession ~= nil then
      msg.need_heal_profession = need_heal_profession
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinRoomCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if name ~= nil then
      msgParam.name = name
    end
    if isquick ~= nil then
      msgParam.isquick = isquick
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    if teammember ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teammember == nil then
        msgParam.teammember = {}
      end
      for i = 1, #teammember do
        table.insert(msgParam.teammember, teammember[i])
      end
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if users ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.users == nil then
        msgParam.users = {}
      end
      for i = 1, #users do
        table.insert(msgParam.users, users[i])
      end
    end
    if matcher ~= nil and matcher.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      msgParam.matcher.charid = matcher.charid
    end
    if matcher ~= nil and matcher.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      msgParam.matcher.zoneid = matcher.zoneid
    end
    if matcher ~= nil and matcher.findtutor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      msgParam.matcher.findtutor = matcher.findtutor
    end
    if matcher ~= nil and matcher.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      msgParam.matcher.gender = matcher.gender
    end
    if matcher ~= nil and matcher.selfgender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      msgParam.matcher.selfgender = matcher.selfgender
    end
    if matcher ~= nil and matcher.datas ~= nil then
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      if msgParam.matcher.datas == nil then
        msgParam.matcher.datas = {}
      end
      for i = 1, #matcher.datas do
        table.insert(msgParam.matcher.datas, matcher.datas[i])
      end
    end
    if matcher ~= nil and matcher.blackids ~= nil then
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      if msgParam.matcher.blackids == nil then
        msgParam.matcher.blackids = {}
      end
      for i = 1, #matcher.blackids do
        table.insert(msgParam.matcher.blackids, matcher.blackids[i])
      end
    end
    if matcher ~= nil and matcher.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.matcher == nil then
        msgParam.matcher = {}
      end
      msgParam.matcher.serverid = matcher.serverid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if teamexptype ~= nil then
      msgParam.teamexptype = teamexptype
    end
    if only_myserver ~= nil then
      msgParam.only_myserver = only_myserver
    end
    if entranceid ~= nil then
      msgParam.entranceid = entranceid
    end
    if need_robot_npc ~= nil then
      msgParam.need_robot_npc = need_robot_npc
    end
    if need_heal_profession ~= nil then
      msgParam.need_heal_profession = need_heal_profession
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallLeaveRoomCCmd(type, roomid, teamid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.LeaveRoomCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LeaveRoomCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallNtfRoomStateCCmd(pvp_type, roomid, state, endtime)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.NtfRoomStateCCmd()
    if pvp_type ~= nil then
      msg.pvp_type = pvp_type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if state ~= nil then
      msg.state = state
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfRoomStateCCmd.id
    local msgParam = {}
    if pvp_type ~= nil then
      msgParam.pvp_type = pvp_type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if state ~= nil then
      msgParam.state = state
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallNtfFightStatCCmd(pvp_type, starttime, player_num, score, my_teamscore, enemy_teamscore, red_score, blue_score, remain_hp, myrank)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.NtfFightStatCCmd()
    if pvp_type ~= nil then
      msg.pvp_type = pvp_type
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if player_num ~= nil then
      msg.player_num = player_num
    end
    if score ~= nil then
      msg.score = score
    end
    if my_teamscore ~= nil then
      msg.my_teamscore = my_teamscore
    end
    if enemy_teamscore ~= nil then
      msg.enemy_teamscore = enemy_teamscore
    end
    if red_score ~= nil then
      msg.red_score = red_score
    end
    if blue_score ~= nil then
      msg.blue_score = blue_score
    end
    if remain_hp ~= nil then
      msg.remain_hp = remain_hp
    end
    if myrank ~= nil then
      msg.myrank = myrank
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfFightStatCCmd.id
    local msgParam = {}
    if pvp_type ~= nil then
      msgParam.pvp_type = pvp_type
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if player_num ~= nil then
      msgParam.player_num = player_num
    end
    if score ~= nil then
      msgParam.score = score
    end
    if my_teamscore ~= nil then
      msgParam.my_teamscore = my_teamscore
    end
    if enemy_teamscore ~= nil then
      msgParam.enemy_teamscore = enemy_teamscore
    end
    if red_score ~= nil then
      msgParam.red_score = red_score
    end
    if blue_score ~= nil then
      msgParam.blue_score = blue_score
    end
    if remain_hp ~= nil then
      msgParam.remain_hp = remain_hp
    end
    if myrank ~= nil then
      msgParam.myrank = myrank
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallJoinFightingCCmd(type, roomid, ret)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.JoinFightingCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinFightingCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallComboNotifyCCmd(comboNum)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ComboNotifyCCmd()
    if comboNum ~= nil then
      msg.comboNum = comboNum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ComboNotifyCCmd.id
    local msgParam = {}
    if comboNum ~= nil then
      msgParam.comboNum = comboNum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallRevChallengeCCmd(type, roomid, challenger, challenger_zoneid, members, reply)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.RevChallengeCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if challenger ~= nil then
      msg.challenger = challenger
    end
    if challenger_zoneid ~= nil then
      msg.challenger_zoneid = challenger_zoneid
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
    if reply ~= nil then
      msg.reply = reply
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RevChallengeCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if challenger ~= nil then
      msgParam.challenger = challenger
    end
    if challenger_zoneid ~= nil then
      msgParam.challenger_zoneid = challenger_zoneid
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
    if reply ~= nil then
      msgParam.reply = reply
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallKickTeamCCmd(type, roomid, zoneid, teamid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.KickTeamCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickTeamCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallFightConfirmCCmd(type, roomid, teamid, reply, challenger)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.FightConfirmCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    if reply ~= nil then
      msg.reply = reply
    end
    if challenger ~= nil then
      msg.challenger = challenger
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FightConfirmCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    if reply ~= nil then
      msgParam.reply = reply
    end
    if challenger ~= nil then
      msgParam.challenger = challenger
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallPvpResultCCmd(type, result, rank, reward, apple)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.PvpResultCCmd()
    if msg == nil then
      msg = {}
    end
    msg.type = type
    if msg == nil then
      msg = {}
    end
    msg.result = result
    if rank ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rank == nil then
        msg.rank = {}
      end
      for i = 1, #rank do
        table.insert(msg.rank, rank[i])
      end
    end
    if reward ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reward == nil then
        msg.reward = {}
      end
      for i = 1, #reward do
        table.insert(msg.reward, reward[i])
      end
    end
    if apple ~= nil then
      msg.apple = apple
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PvpResultCCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.type = type
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.result = result
    if rank ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rank == nil then
        msgParam.rank = {}
      end
      for i = 1, #rank do
        table.insert(msgParam.rank, rank[i])
      end
    end
    if reward ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reward == nil then
        msgParam.reward = {}
      end
      for i = 1, #reward do
        table.insert(msgParam.reward, reward[i])
      end
    end
    if apple ~= nil then
      msgParam.apple = apple
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallPvpTeamMemberUpdateCCmd(data)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.PvpTeamMemberUpdateCCmd()
    if data ~= nil and data.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.zoneid = data.zoneid
    end
    if data ~= nil and data.teamid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.teamid = data.teamid
    end
    if data ~= nil and data.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomid = data.roomid
    end
    if data ~= nil and data.isfirst ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.isfirst = data.isfirst
    end
    if data ~= nil and data.updates ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.updates == nil then
        msg.data.updates = {}
      end
      for i = 1, #data.updates do
        table.insert(msg.data.updates, data.updates[i])
      end
    end
    if data ~= nil and data.deletes ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.deletes == nil then
        msg.data.deletes = {}
      end
      for i = 1, #data.deletes do
        table.insert(msg.data.deletes, data.deletes[i])
      end
    end
    if data ~= nil and data.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.index = data.index
    end
    if data ~= nil and data.teamname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.teamname = data.teamname
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PvpTeamMemberUpdateCCmd.id
    local msgParam = {}
    if data ~= nil and data.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.zoneid = data.zoneid
    end
    if data ~= nil and data.teamid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.teamid = data.teamid
    end
    if data ~= nil and data.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomid = data.roomid
    end
    if data ~= nil and data.isfirst ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.isfirst = data.isfirst
    end
    if data ~= nil and data.updates ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.updates == nil then
        msgParam.data.updates = {}
      end
      for i = 1, #data.updates do
        table.insert(msgParam.data.updates, data.updates[i])
      end
    end
    if data ~= nil and data.deletes ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.deletes == nil then
        msgParam.data.deletes = {}
      end
      for i = 1, #data.deletes do
        table.insert(msgParam.data.deletes, data.deletes[i])
      end
    end
    if data ~= nil and data.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.index = data.index
    end
    if data ~= nil and data.teamname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.teamname = data.teamname
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallPvpMemberDataUpdateCCmd(data)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.PvpMemberDataUpdateCCmd()
    if data ~= nil and data.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.zoneid = data.zoneid
    end
    if data ~= nil and data.teamid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.teamid = data.teamid
    end
    if data ~= nil and data.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.charid = data.charid
    end
    if data ~= nil and data.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomid = data.roomid
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PvpMemberDataUpdateCCmd.id
    local msgParam = {}
    if data ~= nil and data.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.zoneid = data.zoneid
    end
    if data ~= nil and data.teamid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.teamid = data.teamid
    end
    if data ~= nil and data.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.charid = data.charid
    end
    if data ~= nil and data.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomid = data.roomid
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallNtfMatchInfoCCmd(etype, ismatch, isfight, robot_rest_time, robot_match_time, configid, begintime)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.NtfMatchInfoCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if ismatch ~= nil then
      msg.ismatch = ismatch
    end
    if isfight ~= nil then
      msg.isfight = isfight
    end
    if robot_rest_time ~= nil then
      msg.robot_rest_time = robot_rest_time
    end
    if robot_match_time ~= nil then
      msg.robot_match_time = robot_match_time
    end
    if configid ~= nil then
      msg.configid = configid
    end
    if begintime ~= nil then
      msg.begintime = begintime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfMatchInfoCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if ismatch ~= nil then
      msgParam.ismatch = ismatch
    end
    if isfight ~= nil then
      msgParam.isfight = isfight
    end
    if robot_rest_time ~= nil then
      msgParam.robot_rest_time = robot_rest_time
    end
    if robot_match_time ~= nil then
      msgParam.robot_match_time = robot_match_time
    end
    if configid ~= nil then
      msgParam.configid = configid
    end
    if begintime ~= nil then
      msgParam.begintime = begintime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallGodEndTimeCCmd(endtime)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.GodEndTimeCCmd()
    if endtime ~= nil then
      msg.endtime = endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GodEndTimeCCmd.id
    local msgParam = {}
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallNtfRankChangeCCmd(ranks)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.NtfRankChangeCCmd()
    if ranks ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ranks == nil then
        msg.ranks = {}
      end
      for i = 1, #ranks do
        table.insert(msg.ranks, ranks[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfRankChangeCCmd.id
    local msgParam = {}
    if ranks ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ranks == nil then
        msgParam.ranks = {}
      end
      for i = 1, #ranks do
        table.insert(msgParam.ranks, ranks[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallOpenGlobalShopPanelCCmd(open)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.OpenGlobalShopPanelCCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenGlobalShopPanelCCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTutorMatchResultNtfMatchCCmd(target, status)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TutorMatchResultNtfMatchCCmd()
    if target ~= nil and target.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.target == nil then
        msg.target = {}
      end
      msg.target.charid = target.charid
    end
    if target ~= nil and target.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.target == nil then
        msg.target = {}
      end
      msg.target.zoneid = target.zoneid
    end
    if target ~= nil and target.findtutor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.target == nil then
        msg.target = {}
      end
      msg.target.findtutor = target.findtutor
    end
    if target ~= nil and target.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.target == nil then
        msg.target = {}
      end
      msg.target.gender = target.gender
    end
    if target ~= nil and target.selfgender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.target == nil then
        msg.target = {}
      end
      msg.target.selfgender = target.selfgender
    end
    if target ~= nil and target.datas ~= nil then
      if msg.target == nil then
        msg.target = {}
      end
      if msg.target.datas == nil then
        msg.target.datas = {}
      end
      for i = 1, #target.datas do
        table.insert(msg.target.datas, target.datas[i])
      end
    end
    if target ~= nil and target.blackids ~= nil then
      if msg.target == nil then
        msg.target = {}
      end
      if msg.target.blackids == nil then
        msg.target.blackids = {}
      end
      for i = 1, #target.blackids do
        table.insert(msg.target.blackids, target.blackids[i])
      end
    end
    if target ~= nil and target.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.target == nil then
        msg.target = {}
      end
      msg.target.serverid = target.serverid
    end
    if status ~= nil then
      msg.status = status
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorMatchResultNtfMatchCCmd.id
    local msgParam = {}
    if target ~= nil and target.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.target == nil then
        msgParam.target = {}
      end
      msgParam.target.charid = target.charid
    end
    if target ~= nil and target.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.target == nil then
        msgParam.target = {}
      end
      msgParam.target.zoneid = target.zoneid
    end
    if target ~= nil and target.findtutor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.target == nil then
        msgParam.target = {}
      end
      msgParam.target.findtutor = target.findtutor
    end
    if target ~= nil and target.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.target == nil then
        msgParam.target = {}
      end
      msgParam.target.gender = target.gender
    end
    if target ~= nil and target.selfgender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.target == nil then
        msgParam.target = {}
      end
      msgParam.target.selfgender = target.selfgender
    end
    if target ~= nil and target.datas ~= nil then
      if msgParam.target == nil then
        msgParam.target = {}
      end
      if msgParam.target.datas == nil then
        msgParam.target.datas = {}
      end
      for i = 1, #target.datas do
        table.insert(msgParam.target.datas, target.datas[i])
      end
    end
    if target ~= nil and target.blackids ~= nil then
      if msgParam.target == nil then
        msgParam.target = {}
      end
      if msgParam.target.blackids == nil then
        msgParam.target.blackids = {}
      end
      for i = 1, #target.blackids do
        table.insert(msgParam.target.blackids, target.blackids[i])
      end
    end
    if target ~= nil and target.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.target == nil then
        msgParam.target = {}
      end
      msgParam.target.serverid = target.serverid
    end
    if status ~= nil then
      msgParam.status = status
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTutorMatchResponseMatchCCmd(status)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TutorMatchResponseMatchCCmd()
    if status ~= nil then
      msg.status = status
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorMatchResponseMatchCCmd.id
    local msgParam = {}
    if status ~= nil then
      msgParam.status = status
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTeamPwsPreInfoMatchCCmd(teaminfos, etype, goodmatch)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TeamPwsPreInfoMatchCCmd()
    if teaminfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teaminfos == nil then
        msg.teaminfos = {}
      end
      for i = 1, #teaminfos do
        table.insert(msg.teaminfos, teaminfos[i])
      end
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if goodmatch ~= nil then
      msg.goodmatch = goodmatch
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamPwsPreInfoMatchCCmd.id
    local msgParam = {}
    if teaminfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teaminfos == nil then
        msgParam.teaminfos = {}
      end
      for i = 1, #teaminfos do
        table.insert(msgParam.teaminfos, teaminfos[i])
      end
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if goodmatch ~= nil then
      msgParam.goodmatch = goodmatch
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallUpdatePreInfoMatchCCmd(charid, etype, raidid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.UpdatePreInfoMatchCCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdatePreInfoMatchCCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryTeamPwsRankMatchCCmd(rankinfo, lastrankinfo)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryTeamPwsRankMatchCCmd()
    if rankinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rankinfo == nil then
        msg.rankinfo = {}
      end
      for i = 1, #rankinfo do
        table.insert(msg.rankinfo, rankinfo[i])
      end
    end
    if lastrankinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lastrankinfo == nil then
        msg.lastrankinfo = {}
      end
      for i = 1, #lastrankinfo do
        table.insert(msg.lastrankinfo, lastrankinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTeamPwsRankMatchCCmd.id
    local msgParam = {}
    if rankinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rankinfo == nil then
        msgParam.rankinfo = {}
      end
      for i = 1, #rankinfo do
        table.insert(msgParam.rankinfo, rankinfo[i])
      end
    end
    if lastrankinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lastrankinfo == nil then
        msgParam.lastrankinfo = {}
      end
      for i = 1, #lastrankinfo do
        table.insert(msgParam.lastrankinfo, lastrankinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryTeamPwsTeamInfoMatchCCmd(userinfos, myrank, season, count, opentime, season_begin, season_breakbegin, season_breakend, forbid_profession, config_time)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryTeamPwsTeamInfoMatchCCmd()
    if userinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userinfos == nil then
        msg.userinfos = {}
      end
      for i = 1, #userinfos do
        table.insert(msg.userinfos, userinfos[i])
      end
    end
    if myrank ~= nil then
      msg.myrank = myrank
    end
    if season ~= nil then
      msg.season = season
    end
    if count ~= nil then
      msg.count = count
    end
    if opentime ~= nil then
      msg.opentime = opentime
    end
    if season_begin ~= nil then
      msg.season_begin = season_begin
    end
    if season_breakbegin ~= nil then
      msg.season_breakbegin = season_breakbegin
    end
    if season_breakend ~= nil then
      msg.season_breakend = season_breakend
    end
    if forbid_profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.forbid_profession == nil then
        msg.forbid_profession = {}
      end
      for i = 1, #forbid_profession do
        table.insert(msg.forbid_profession, forbid_profession[i])
      end
    end
    if config_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config_time == nil then
        msg.config_time = {}
      end
      for i = 1, #config_time do
        table.insert(msg.config_time, config_time[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTeamPwsTeamInfoMatchCCmd.id
    local msgParam = {}
    if userinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userinfos == nil then
        msgParam.userinfos = {}
      end
      for i = 1, #userinfos do
        table.insert(msgParam.userinfos, userinfos[i])
      end
    end
    if myrank ~= nil then
      msgParam.myrank = myrank
    end
    if season ~= nil then
      msgParam.season = season
    end
    if count ~= nil then
      msgParam.count = count
    end
    if opentime ~= nil then
      msgParam.opentime = opentime
    end
    if season_begin ~= nil then
      msgParam.season_begin = season_begin
    end
    if season_breakbegin ~= nil then
      msgParam.season_breakbegin = season_breakbegin
    end
    if season_breakend ~= nil then
      msgParam.season_breakend = season_breakend
    end
    if forbid_profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.forbid_profession == nil then
        msgParam.forbid_profession = {}
      end
      for i = 1, #forbid_profession do
        table.insert(msgParam.forbid_profession, forbid_profession[i])
      end
    end
    if config_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config_time == nil then
        msgParam.config_time = {}
      end
      for i = 1, #config_time do
        table.insert(msgParam.config_time, config_time[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryMenrocoRankMatchCCmd(myrank, datas)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryMenrocoRankMatchCCmd()
    if myrank ~= nil then
      msg.myrank = myrank
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
    local msgId = ProtoReqInfoList.QueryMenrocoRankMatchCCmd.id
    local msgParam = {}
    if myrank ~= nil then
      msgParam.myrank = myrank
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

function ServiceMatchCCmdAutoProxy:CallMidMatchPrepareMatchCCmd(finish)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.MidMatchPrepareMatchCCmd()
    if finish ~= nil then
      msg.finish = finish
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MidMatchPrepareMatchCCmd.id
    local msgParam = {}
    if finish ~= nil then
      msgParam.finish = finish
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryBattlePassRankMatchCCmd(datas)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryBattlePassRankMatchCCmd()
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
    local msgId = ProtoReqInfoList.QueryBattlePassRankMatchCCmd.id
    local msgParam = {}
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

function ServiceMatchCCmdAutoProxy:CallTwelvePvpPreInfoMatchCCmd(camp, etype)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelvePvpPreInfoMatchCCmd()
    if camp ~= nil then
      msg.camp = camp
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpPreInfoMatchCCmd.id
    local msgParam = {}
    if camp ~= nil then
      msgParam.camp = camp
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelvePvpUpdatePreInfoMatchCCmd(camp, charid, etype, raidid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelvePvpUpdatePreInfoMatchCCmd()
    if camp ~= nil then
      msg.camp = camp
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpUpdatePreInfoMatchCCmd.id
    local msgParam = {}
    if camp ~= nil then
      msgParam.camp = camp
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandQueryMatchCCmd(season, guid, memberinfo, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandQueryMatchCCmd()
    if season ~= nil then
      msg.season = season
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if memberinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.memberinfo == nil then
        msg.memberinfo = {}
      end
      for i = 1, #memberinfo do
        table.insert(msg.memberinfo, memberinfo[i])
      end
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandQueryMatchCCmd.id
    local msgParam = {}
    if season ~= nil then
      msgParam.season = season
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if memberinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.memberinfo == nil then
        msgParam.memberinfo = {}
      end
      for i = 1, #memberinfo do
        table.insert(msgParam.memberinfo, memberinfo[i])
      end
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandSortMatchCCmd(sortinfo, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandSortMatchCCmd()
    if sortinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sortinfo == nil then
        msg.sortinfo = {}
      end
      for i = 1, #sortinfo do
        table.insert(msg.sortinfo, sortinfo[i])
      end
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandSortMatchCCmd.id
    local msgParam = {}
    if sortinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sortinfo == nil then
        msgParam.sortinfo = {}
      end
      for i = 1, #sortinfo do
        table.insert(msgParam.sortinfo, sortinfo[i])
      end
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandTreeMatchCCmd(teaminfo, championteaminfo, etype, preteaminfo, stage, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandTreeMatchCCmd()
    if teaminfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      for i = 1, #teaminfo do
        table.insert(msg.teaminfo, teaminfo[i])
      end
    end
    if championteaminfo ~= nil and championteaminfo.groupteaminfo ~= nil then
      if msg.championteaminfo == nil then
        msg.championteaminfo = {}
      end
      if msg.championteaminfo.groupteaminfo == nil then
        msg.championteaminfo.groupteaminfo = {}
      end
      for i = 1, #championteaminfo.groupteaminfo do
        table.insert(msg.championteaminfo.groupteaminfo, championteaminfo.groupteaminfo[i])
      end
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if preteaminfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.preteaminfo == nil then
        msg.preteaminfo = {}
      end
      for i = 1, #preteaminfo do
        table.insert(msg.preteaminfo, preteaminfo[i])
      end
    end
    if stage ~= nil then
      msg.stage = stage
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandTreeMatchCCmd.id
    local msgParam = {}
    if teaminfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      for i = 1, #teaminfo do
        table.insert(msgParam.teaminfo, teaminfo[i])
      end
    end
    if championteaminfo ~= nil and championteaminfo.groupteaminfo ~= nil then
      if msgParam.championteaminfo == nil then
        msgParam.championteaminfo = {}
      end
      if msgParam.championteaminfo.groupteaminfo == nil then
        msgParam.championteaminfo.groupteaminfo = {}
      end
      for i = 1, #championteaminfo.groupteaminfo do
        table.insert(msgParam.championteaminfo.groupteaminfo, championteaminfo.groupteaminfo[i])
      end
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if preteaminfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.preteaminfo == nil then
        msgParam.preteaminfo = {}
      end
      for i = 1, #preteaminfo do
        table.insert(msgParam.preteaminfo, preteaminfo[i])
      end
    end
    if stage ~= nil then
      msgParam.stage = stage
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandInfoMatchCCmd(guid, warbandname, signup, score, memberinfo, delmembers, etype)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandInfoMatchCCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if warbandname ~= nil then
      msg.warbandname = warbandname
    end
    if signup ~= nil then
      msg.signup = signup
    end
    if score ~= nil then
      msg.score = score
    end
    if memberinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.memberinfo == nil then
        msg.memberinfo = {}
      end
      for i = 1, #memberinfo do
        table.insert(msg.memberinfo, memberinfo[i])
      end
    end
    if delmembers ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delmembers == nil then
        msg.delmembers = {}
      end
      for i = 1, #delmembers do
        table.insert(msg.delmembers, delmembers[i])
      end
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandInfoMatchCCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if warbandname ~= nil then
      msgParam.warbandname = warbandname
    end
    if signup ~= nil then
      msgParam.signup = signup
    end
    if score ~= nil then
      msgParam.score = score
    end
    if memberinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.memberinfo == nil then
        msgParam.memberinfo = {}
      end
      for i = 1, #memberinfo do
        table.insert(msgParam.memberinfo, memberinfo[i])
      end
    end
    if delmembers ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delmembers == nil then
        msgParam.delmembers = {}
      end
      for i = 1, #delmembers do
        table.insert(msgParam.delmembers, delmembers[i])
      end
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandInviterMatchCCmd(charid, warbandname, capitalname, zoneid, level, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandInviterMatchCCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if warbandname ~= nil then
      msg.warbandname = warbandname
    end
    if capitalname ~= nil then
      msg.capitalname = capitalname
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if level ~= nil then
      msg.level = level
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandInviterMatchCCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if warbandname ~= nil then
      msgParam.warbandname = warbandname
    end
    if capitalname ~= nil then
      msgParam.capitalname = capitalname
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if level ~= nil then
      msgParam.level = level
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandInviteeMatchCCmd(accept, name, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandInviteeMatchCCmd()
    if accept ~= nil then
      msg.accept = accept
    end
    if name ~= nil then
      msg.name = name
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandInviteeMatchCCmd.id
    local msgParam = {}
    if accept ~= nil then
      msgParam.accept = accept
    end
    if name ~= nil then
      msgParam.name = name
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandPrepareMatchCCmd(prepare, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandPrepareMatchCCmd()
    if prepare ~= nil then
      msg.prepare = prepare
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandPrepareMatchCCmd.id
    local msgParam = {}
    if prepare ~= nil then
      msgParam.prepare = prepare
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandLeaveMatchCCmd(etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandLeaveMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandLeaveMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandDeleteMatchCCmd(charid, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandDeleteMatchCCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandDeleteMatchCCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandNameMatchCCmd(name, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandNameMatchCCmd()
    if name ~= nil then
      msg.name = name
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandNameMatchCCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandSignUpMatchCCmd(etype, cancel, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandSignUpMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if cancel ~= nil then
      msg.cancel = cancel
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandSignUpMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cancel ~= nil then
      msgParam.cancel = cancel
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandMatchMatchCCmd(type, roomid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandMatchMatchCCmd()
    if type ~= nil then
      msg.type = type
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandMatchMatchCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandTeamListMatchCCmd(teaminfo, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandTeamListMatchCCmd()
    if teaminfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teaminfo == nil then
        msg.teaminfo = {}
      end
      for i = 1, #teaminfo do
        table.insert(msg.teaminfo, teaminfo[i])
      end
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandTeamListMatchCCmd.id
    local msgParam = {}
    if teaminfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teaminfo == nil then
        msgParam.teaminfo = {}
      end
      for i = 1, #teaminfo do
        table.insert(msgParam.teaminfo, teaminfo[i])
      end
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveWarbandCreateMatchCCmd(warbandname, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveWarbandCreateMatchCCmd()
    if warbandname ~= nil then
      msg.warbandname = warbandname
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveWarbandCreateMatchCCmd.id
    local msgParam = {}
    if warbandname ~= nil then
      msgParam.warbandname = warbandname
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallSyncMatchInfoCCmd(etype, ismatch, coldtime, raidid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.SyncMatchInfoCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if ismatch ~= nil then
      msg.ismatch = ismatch
    end
    if coldtime ~= nil then
      msg.coldtime = coldtime
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncMatchInfoCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if ismatch ~= nil then
      msgParam.ismatch = ismatch
    end
    if coldtime ~= nil then
      msgParam.coldtime = coldtime
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryTwelveSeasonInfoMatchCCmd(etype, season, season_begin, season_end, season_breakbegin, season_breakend, warband_createbegin, warband_createend, warband_signupbegin, season_initfighttime, season_nextfighttime, season_matchtime, season_fighttime, forbid_profession, cross_server_champion, season_initprefighttime, season_nextprefighttime)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryTwelveSeasonInfoMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if season ~= nil then
      msg.season = season
    end
    if season_begin ~= nil then
      msg.season_begin = season_begin
    end
    if season_end ~= nil then
      msg.season_end = season_end
    end
    if season_breakbegin ~= nil then
      msg.season_breakbegin = season_breakbegin
    end
    if season_breakend ~= nil then
      msg.season_breakend = season_breakend
    end
    if warband_createbegin ~= nil then
      msg.warband_createbegin = warband_createbegin
    end
    if warband_createend ~= nil then
      msg.warband_createend = warband_createend
    end
    if warband_signupbegin ~= nil then
      msg.warband_signupbegin = warband_signupbegin
    end
    if season_initfighttime ~= nil then
      msg.season_initfighttime = season_initfighttime
    end
    if season_nextfighttime ~= nil then
      msg.season_nextfighttime = season_nextfighttime
    end
    if season_matchtime ~= nil then
      msg.season_matchtime = season_matchtime
    end
    if season_fighttime ~= nil then
      msg.season_fighttime = season_fighttime
    end
    if forbid_profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.forbid_profession == nil then
        msg.forbid_profession = {}
      end
      for i = 1, #forbid_profession do
        table.insert(msg.forbid_profession, forbid_profession[i])
      end
    end
    if cross_server_champion ~= nil then
      msg.cross_server_champion = cross_server_champion
    end
    if season_initprefighttime ~= nil then
      msg.season_initprefighttime = season_initprefighttime
    end
    if season_nextprefighttime ~= nil then
      msg.season_nextprefighttime = season_nextprefighttime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTwelveSeasonInfoMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if season ~= nil then
      msgParam.season = season
    end
    if season_begin ~= nil then
      msgParam.season_begin = season_begin
    end
    if season_end ~= nil then
      msgParam.season_end = season_end
    end
    if season_breakbegin ~= nil then
      msgParam.season_breakbegin = season_breakbegin
    end
    if season_breakend ~= nil then
      msgParam.season_breakend = season_breakend
    end
    if warband_createbegin ~= nil then
      msgParam.warband_createbegin = warband_createbegin
    end
    if warband_createend ~= nil then
      msgParam.warband_createend = warband_createend
    end
    if warband_signupbegin ~= nil then
      msgParam.warband_signupbegin = warband_signupbegin
    end
    if season_initfighttime ~= nil then
      msgParam.season_initfighttime = season_initfighttime
    end
    if season_nextfighttime ~= nil then
      msgParam.season_nextfighttime = season_nextfighttime
    end
    if season_matchtime ~= nil then
      msgParam.season_matchtime = season_matchtime
    end
    if season_fighttime ~= nil then
      msgParam.season_fighttime = season_fighttime
    end
    if forbid_profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.forbid_profession == nil then
        msgParam.forbid_profession = {}
      end
      for i = 1, #forbid_profession do
        table.insert(msgParam.forbid_profession, forbid_profession[i])
      end
    end
    if cross_server_champion ~= nil then
      msgParam.cross_server_champion = cross_server_champion
    end
    if season_initprefighttime ~= nil then
      msgParam.season_initprefighttime = season_initprefighttime
    end
    if season_nextprefighttime ~= nil then
      msgParam.season_nextprefighttime = season_nextprefighttime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryTwelveSeasonFinishMatchCCmd(etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryTwelveSeasonFinishMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTwelveSeasonFinishMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallSyncMatchBoardOpenStateMatchCCmd(open, etype, cross_server)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.SyncMatchBoardOpenStateMatchCCmd()
    if open ~= nil then
      msg.open = open
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if cross_server ~= nil then
      msg.cross_server = cross_server
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncMatchBoardOpenStateMatchCCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if cross_server ~= nil then
      msgParam.cross_server = cross_server
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTwelveSeasonTimeInfoMatchCCmd(time_infos, no_use)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TwelveSeasonTimeInfoMatchCCmd()
    if time_infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.time_infos == nil then
        msg.time_infos = {}
      end
      for i = 1, #time_infos do
        table.insert(msg.time_infos, time_infos[i])
      end
    end
    if no_use ~= nil then
      msg.no_use = no_use
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelveSeasonTimeInfoMatchCCmd.id
    local msgParam = {}
    if time_infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.time_infos == nil then
        msgParam.time_infos = {}
      end
      for i = 1, #time_infos do
        table.insert(msgParam.time_infos, time_infos[i])
      end
    end
    if no_use ~= nil then
      msgParam.no_use = no_use
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallEnterObservationMatchCCmd(etype, charid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.EnterObservationMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterObservationMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallObInitInfoFubenCmd(infos)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ObInitInfoFubenCmd()
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
    local msgId = ProtoReqInfoList.ObInitInfoFubenCmd.id
    local msgParam = {}
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

function ServiceMatchCCmdAutoProxy:CallReserveRoomBuildMatchCCmd(etype, raidid, isfire, password, limitpro, personalartifact, food, guidartifact, forbidcards, isforbidcard)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomBuildMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if isfire ~= nil then
      msg.isfire = isfire
    end
    if password ~= nil then
      msg.password = password
    end
    if limitpro ~= nil then
      msg.limitpro = limitpro
    end
    if personalartifact ~= nil then
      msg.personalartifact = personalartifact
    end
    if food ~= nil then
      msg.food = food
    end
    if guidartifact ~= nil then
      msg.guidartifact = guidartifact
    end
    if forbidcards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.forbidcards == nil then
        msg.forbidcards = {}
      end
      for i = 1, #forbidcards do
        table.insert(msg.forbidcards, forbidcards[i])
      end
    end
    if isforbidcard ~= nil then
      msg.isforbidcard = isforbidcard
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomBuildMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if isfire ~= nil then
      msgParam.isfire = isfire
    end
    if password ~= nil then
      msgParam.password = password
    end
    if limitpro ~= nil then
      msgParam.limitpro = limitpro
    end
    if personalartifact ~= nil then
      msgParam.personalartifact = personalartifact
    end
    if food ~= nil then
      msgParam.food = food
    end
    if guidartifact ~= nil then
      msgParam.guidartifact = guidartifact
    end
    if forbidcards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.forbidcards == nil then
        msgParam.forbidcards = {}
      end
      for i = 1, #forbidcards do
        table.insert(msgParam.forbidcards, forbidcards[i])
      end
    end
    if isforbidcard ~= nil then
      msgParam.isforbidcard = isforbidcard
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomInviterMatchCCmd(charid, capitalname, teamtype)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomInviterMatchCCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if capitalname ~= nil then
      msg.capitalname = capitalname
    end
    if teamtype ~= nil then
      msg.teamtype = teamtype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomInviterMatchCCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if capitalname ~= nil then
      msgParam.capitalname = capitalname
    end
    if teamtype ~= nil then
      msgParam.teamtype = teamtype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomInviteeMatchCCmd(isaccept, playername)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomInviteeMatchCCmd()
    if isaccept ~= nil then
      msg.isaccept = isaccept
    end
    if playername ~= nil then
      msg.playername = playername
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomInviteeMatchCCmd.id
    local msgParam = {}
    if isaccept ~= nil then
      msgParam.isaccept = isaccept
    end
    if playername ~= nil then
      msgParam.playername = playername
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomKickMatchCCmd(charid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomKickMatchCCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomKickMatchCCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomLeaveMatchCCmd()
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomLeaveMatchCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomLeaveMatchCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomApplyMatchCCmd(roomid, password)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomApplyMatchCCmd()
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if password ~= nil then
      msg.password = password
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomApplyMatchCCmd.id
    local msgParam = {}
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if password ~= nil then
      msgParam.password = password
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomInfoMatchCCmd(etype, myroom, teamone, teamtwo, teamob, delmembers)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomInfoMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if myroom ~= nil and myroom.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.roomid = myroom.roomid
    end
    if myroom ~= nil and myroom.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.raidid = myroom.raidid
    end
    if myroom ~= nil and myroom.roomname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.roomname = myroom.roomname
    end
    if myroom ~= nil and myroom.leaderid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.leaderid = myroom.leaderid
    end
    if myroom.portrait ~= nil and myroom.portrait.portrait ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.portrait = myroom.portrait.portrait
    end
    if myroom.portrait ~= nil and myroom.portrait.body ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.body = myroom.portrait.body
    end
    if myroom.portrait ~= nil and myroom.portrait.hair ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.hair = myroom.portrait.hair
    end
    if myroom.portrait ~= nil and myroom.portrait.haircolor ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.haircolor = myroom.portrait.haircolor
    end
    if myroom.portrait ~= nil and myroom.portrait.gender ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.gender = myroom.portrait.gender
    end
    if myroom.portrait ~= nil and myroom.portrait.head ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.head = myroom.portrait.head
    end
    if myroom.portrait ~= nil and myroom.portrait.face ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.face = myroom.portrait.face
    end
    if myroom.portrait ~= nil and myroom.portrait.mouth ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.mouth = myroom.portrait.mouth
    end
    if myroom.portrait ~= nil and myroom.portrait.eye ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.eye = myroom.portrait.eye
    end
    if myroom.portrait ~= nil and myroom.portrait.portrait_frame ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.portrait == nil then
        msg.myroom.portrait = {}
      end
      msg.myroom.portrait.portrait_frame = myroom.portrait.portrait_frame
    end
    if myroom ~= nil and myroom.iscode ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.iscode = myroom.iscode
    end
    if myroom ~= nil and myroom.isfull ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.isfull = myroom.isfull
    end
    if myroom ~= nil and myroom.isfire ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.isfire = myroom.isfire
    end
    if myroom ~= nil and myroom.teamonenum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.teamonenum = myroom.teamonenum
    end
    if myroom ~= nil and myroom.teamtwonum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.teamtwonum = myroom.teamtwonum
    end
    if myroom ~= nil and myroom.teamobnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.teamobnum = myroom.teamobnum
    end
    if myroom ~= nil and myroom.etype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.etype = myroom.etype
    end
    if myroom ~= nil and myroom.limitpro ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.limitpro = myroom.limitpro
    end
    if myroom ~= nil and myroom.personalartifact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.personalartifact = myroom.personalartifact
    end
    if myroom ~= nil and myroom.food ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.food = myroom.food
    end
    if myroom ~= nil and myroom.guidartifact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.guidartifact = myroom.guidartifact
    end
    if myroom ~= nil and myroom.isbattle ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.isbattle = myroom.isbattle
    end
    if myroom ~= nil and myroom.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.serverid = myroom.serverid
    end
    if myroom ~= nil and myroom.password ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.password = myroom.password
    end
    if myroom ~= nil and myroom.forbidcards ~= nil then
      if msg.myroom == nil then
        msg.myroom = {}
      end
      if msg.myroom.forbidcards == nil then
        msg.myroom.forbidcards = {}
      end
      for i = 1, #myroom.forbidcards do
        table.insert(msg.myroom.forbidcards, myroom.forbidcards[i])
      end
    end
    if myroom ~= nil and myroom.isforbidcard ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myroom == nil then
        msg.myroom = {}
      end
      msg.myroom.isforbidcard = myroom.isforbidcard
    end
    if teamone ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teamone == nil then
        msg.teamone = {}
      end
      for i = 1, #teamone do
        table.insert(msg.teamone, teamone[i])
      end
    end
    if teamtwo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teamtwo == nil then
        msg.teamtwo = {}
      end
      for i = 1, #teamtwo do
        table.insert(msg.teamtwo, teamtwo[i])
      end
    end
    if teamob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teamob == nil then
        msg.teamob = {}
      end
      for i = 1, #teamob do
        table.insert(msg.teamob, teamob[i])
      end
    end
    if delmembers ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delmembers == nil then
        msg.delmembers = {}
      end
      for i = 1, #delmembers do
        table.insert(msg.delmembers, delmembers[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomInfoMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if myroom ~= nil and myroom.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.roomid = myroom.roomid
    end
    if myroom ~= nil and myroom.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.raidid = myroom.raidid
    end
    if myroom ~= nil and myroom.roomname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.roomname = myroom.roomname
    end
    if myroom ~= nil and myroom.leaderid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.leaderid = myroom.leaderid
    end
    if myroom.portrait ~= nil and myroom.portrait.portrait ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.portrait = myroom.portrait.portrait
    end
    if myroom.portrait ~= nil and myroom.portrait.body ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.body = myroom.portrait.body
    end
    if myroom.portrait ~= nil and myroom.portrait.hair ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.hair = myroom.portrait.hair
    end
    if myroom.portrait ~= nil and myroom.portrait.haircolor ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.haircolor = myroom.portrait.haircolor
    end
    if myroom.portrait ~= nil and myroom.portrait.gender ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.gender = myroom.portrait.gender
    end
    if myroom.portrait ~= nil and myroom.portrait.head ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.head = myroom.portrait.head
    end
    if myroom.portrait ~= nil and myroom.portrait.face ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.face = myroom.portrait.face
    end
    if myroom.portrait ~= nil and myroom.portrait.mouth ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.mouth = myroom.portrait.mouth
    end
    if myroom.portrait ~= nil and myroom.portrait.eye ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.eye = myroom.portrait.eye
    end
    if myroom.portrait ~= nil and myroom.portrait.portrait_frame ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.portrait == nil then
        msgParam.myroom.portrait = {}
      end
      msgParam.myroom.portrait.portrait_frame = myroom.portrait.portrait_frame
    end
    if myroom ~= nil and myroom.iscode ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.iscode = myroom.iscode
    end
    if myroom ~= nil and myroom.isfull ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.isfull = myroom.isfull
    end
    if myroom ~= nil and myroom.isfire ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.isfire = myroom.isfire
    end
    if myroom ~= nil and myroom.teamonenum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.teamonenum = myroom.teamonenum
    end
    if myroom ~= nil and myroom.teamtwonum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.teamtwonum = myroom.teamtwonum
    end
    if myroom ~= nil and myroom.teamobnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.teamobnum = myroom.teamobnum
    end
    if myroom ~= nil and myroom.etype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.etype = myroom.etype
    end
    if myroom ~= nil and myroom.limitpro ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.limitpro = myroom.limitpro
    end
    if myroom ~= nil and myroom.personalartifact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.personalartifact = myroom.personalartifact
    end
    if myroom ~= nil and myroom.food ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.food = myroom.food
    end
    if myroom ~= nil and myroom.guidartifact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.guidartifact = myroom.guidartifact
    end
    if myroom ~= nil and myroom.isbattle ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.isbattle = myroom.isbattle
    end
    if myroom ~= nil and myroom.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.serverid = myroom.serverid
    end
    if myroom ~= nil and myroom.password ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.password = myroom.password
    end
    if myroom ~= nil and myroom.forbidcards ~= nil then
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      if msgParam.myroom.forbidcards == nil then
        msgParam.myroom.forbidcards = {}
      end
      for i = 1, #myroom.forbidcards do
        table.insert(msgParam.myroom.forbidcards, myroom.forbidcards[i])
      end
    end
    if myroom ~= nil and myroom.isforbidcard ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myroom == nil then
        msgParam.myroom = {}
      end
      msgParam.myroom.isforbidcard = myroom.isforbidcard
    end
    if teamone ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teamone == nil then
        msgParam.teamone = {}
      end
      for i = 1, #teamone do
        table.insert(msgParam.teamone, teamone[i])
      end
    end
    if teamtwo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teamtwo == nil then
        msgParam.teamtwo = {}
      end
      for i = 1, #teamtwo do
        table.insert(msgParam.teamtwo, teamtwo[i])
      end
    end
    if teamob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teamob == nil then
        msgParam.teamob = {}
      end
      for i = 1, #teamob do
        table.insert(msgParam.teamob, teamob[i])
      end
    end
    if delmembers ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delmembers == nil then
        msgParam.delmembers = {}
      end
      for i = 1, #delmembers do
        table.insert(msgParam.delmembers, delmembers[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomListMatchCCmd(etype, raidid, page, roominfo)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomListMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if page ~= nil then
      msg.page = page
    end
    if roominfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.roominfo == nil then
        msg.roominfo = {}
      end
      for i = 1, #roominfo do
        table.insert(msg.roominfo, roominfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomListMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if page ~= nil then
      msgParam.page = page
    end
    if roominfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.roominfo == nil then
        msgParam.roominfo = {}
      end
      for i = 1, #roominfo do
        table.insert(msgParam.roominfo, roominfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomStartMatchCCmd()
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomStartMatchCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomStartMatchCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomChangeMatchCCmd(teamtype)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomChangeMatchCCmd()
    if teamtype ~= nil then
      msg.teamtype = teamtype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomChangeMatchCCmd.id
    local msgParam = {}
    if teamtype ~= nil then
      msgParam.teamtype = teamtype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallReserveRoomPrepareMatchCCmd(isask, prepare)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ReserveRoomPrepareMatchCCmd()
    if isask ~= nil then
      msg.isask = isask
    end
    if prepare ~= nil then
      msg.prepare = prepare
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveRoomPrepareMatchCCmd.id
    local msgParam = {}
    if isask ~= nil then
      msgParam.isask = isask
    end
    if prepare ~= nil then
      msgParam.prepare = prepare
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallJoinRaidWithRobotMatchCCmd(etype, teamid)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.JoinRaidWithRobotMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinRaidWithRobotMatchCCmd.id
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

function ServiceMatchCCmdAutoProxy:CallDesertWolfStatQueryCmd(stats, is_end, win_team, mvp_info)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.DesertWolfStatQueryCmd()
    if stats ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stats == nil then
        msg.stats = {}
      end
      for i = 1, #stats do
        table.insert(msg.stats, stats[i])
      end
    end
    if is_end ~= nil then
      msg.is_end = is_end
    end
    if win_team ~= nil then
      msg.win_team = win_team
    end
    if mvp_info ~= nil and mvp_info.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.charid = mvp_info.charid
    end
    if mvp_info ~= nil and mvp_info.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.guildid = mvp_info.guildid
    end
    if mvp_info ~= nil and mvp_info.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.accid = mvp_info.accid
    end
    if mvp_info ~= nil and mvp_info.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.name = mvp_info.name
    end
    if mvp_info ~= nil and mvp_info.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.guildname = mvp_info.guildname
    end
    if mvp_info ~= nil and mvp_info.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.guildportrait = mvp_info.guildportrait
    end
    if mvp_info ~= nil and mvp_info.guildjob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.guildjob = mvp_info.guildjob
    end
    if mvp_info ~= nil and mvp_info.datas ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.datas == nil then
        msg.mvp_info.datas = {}
      end
      for i = 1, #mvp_info.datas do
        table.insert(msg.mvp_info.datas, mvp_info.datas[i])
      end
    end
    if mvp_info ~= nil and mvp_info.attrs ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.attrs == nil then
        msg.mvp_info.attrs = {}
      end
      for i = 1, #mvp_info.attrs do
        table.insert(msg.mvp_info.attrs, mvp_info.attrs[i])
      end
    end
    if mvp_info ~= nil and mvp_info.equip ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.equip == nil then
        msg.mvp_info.equip = {}
      end
      for i = 1, #mvp_info.equip do
        table.insert(msg.mvp_info.equip, mvp_info.equip[i])
      end
    end
    if mvp_info ~= nil and mvp_info.fashion ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.fashion == nil then
        msg.mvp_info.fashion = {}
      end
      for i = 1, #mvp_info.fashion do
        table.insert(msg.mvp_info.fashion, mvp_info.fashion[i])
      end
    end
    if mvp_info ~= nil and mvp_info.shadow ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.shadow == nil then
        msg.mvp_info.shadow = {}
      end
      for i = 1, #mvp_info.shadow do
        table.insert(msg.mvp_info.shadow, mvp_info.shadow[i])
      end
    end
    if mvp_info ~= nil and mvp_info.extraction ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.extraction == nil then
        msg.mvp_info.extraction = {}
      end
      for i = 1, #mvp_info.extraction do
        table.insert(msg.mvp_info.extraction, mvp_info.extraction[i])
      end
    end
    if mvp_info ~= nil and mvp_info.highrefine ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.highrefine == nil then
        msg.mvp_info.highrefine = {}
      end
      for i = 1, #mvp_info.highrefine do
        table.insert(msg.mvp_info.highrefine, mvp_info.highrefine[i])
      end
    end
    if mvp_info ~= nil and mvp_info.partner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      msg.mvp_info.partner = mvp_info.partner
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.id ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.mercenary == nil then
        msg.mvp_info.mercenary = {}
      end
      msg.mvp_info.mercenary.id = mvp_info.mercenary.id
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.name ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.mercenary == nil then
        msg.mvp_info.mercenary = {}
      end
      msg.mvp_info.mercenary.name = mvp_info.mercenary.name
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.icon ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.mercenary == nil then
        msg.mvp_info.mercenary = {}
      end
      msg.mvp_info.mercenary.icon = mvp_info.mercenary.icon
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.job ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.mercenary == nil then
        msg.mvp_info.mercenary = {}
      end
      msg.mvp_info.mercenary.job = mvp_info.mercenary.job
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.mercenary_name ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.mercenary == nil then
        msg.mvp_info.mercenary = {}
      end
      msg.mvp_info.mercenary.mercenary_name = mvp_info.mercenary.mercenary_name
    end
    if mvp_info ~= nil and mvp_info.memory_pos ~= nil then
      if msg.mvp_info == nil then
        msg.mvp_info = {}
      end
      if msg.mvp_info.memory_pos == nil then
        msg.mvp_info.memory_pos = {}
      end
      for i = 1, #mvp_info.memory_pos do
        table.insert(msg.mvp_info.memory_pos, mvp_info.memory_pos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DesertWolfStatQueryCmd.id
    local msgParam = {}
    if stats ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stats == nil then
        msgParam.stats = {}
      end
      for i = 1, #stats do
        table.insert(msgParam.stats, stats[i])
      end
    end
    if is_end ~= nil then
      msgParam.is_end = is_end
    end
    if win_team ~= nil then
      msgParam.win_team = win_team
    end
    if mvp_info ~= nil and mvp_info.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.charid = mvp_info.charid
    end
    if mvp_info ~= nil and mvp_info.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.guildid = mvp_info.guildid
    end
    if mvp_info ~= nil and mvp_info.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.accid = mvp_info.accid
    end
    if mvp_info ~= nil and mvp_info.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.name = mvp_info.name
    end
    if mvp_info ~= nil and mvp_info.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.guildname = mvp_info.guildname
    end
    if mvp_info ~= nil and mvp_info.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.guildportrait = mvp_info.guildportrait
    end
    if mvp_info ~= nil and mvp_info.guildjob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.guildjob = mvp_info.guildjob
    end
    if mvp_info ~= nil and mvp_info.datas ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.datas == nil then
        msgParam.mvp_info.datas = {}
      end
      for i = 1, #mvp_info.datas do
        table.insert(msgParam.mvp_info.datas, mvp_info.datas[i])
      end
    end
    if mvp_info ~= nil and mvp_info.attrs ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.attrs == nil then
        msgParam.mvp_info.attrs = {}
      end
      for i = 1, #mvp_info.attrs do
        table.insert(msgParam.mvp_info.attrs, mvp_info.attrs[i])
      end
    end
    if mvp_info ~= nil and mvp_info.equip ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.equip == nil then
        msgParam.mvp_info.equip = {}
      end
      for i = 1, #mvp_info.equip do
        table.insert(msgParam.mvp_info.equip, mvp_info.equip[i])
      end
    end
    if mvp_info ~= nil and mvp_info.fashion ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.fashion == nil then
        msgParam.mvp_info.fashion = {}
      end
      for i = 1, #mvp_info.fashion do
        table.insert(msgParam.mvp_info.fashion, mvp_info.fashion[i])
      end
    end
    if mvp_info ~= nil and mvp_info.shadow ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.shadow == nil then
        msgParam.mvp_info.shadow = {}
      end
      for i = 1, #mvp_info.shadow do
        table.insert(msgParam.mvp_info.shadow, mvp_info.shadow[i])
      end
    end
    if mvp_info ~= nil and mvp_info.extraction ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.extraction == nil then
        msgParam.mvp_info.extraction = {}
      end
      for i = 1, #mvp_info.extraction do
        table.insert(msgParam.mvp_info.extraction, mvp_info.extraction[i])
      end
    end
    if mvp_info ~= nil and mvp_info.highrefine ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.highrefine == nil then
        msgParam.mvp_info.highrefine = {}
      end
      for i = 1, #mvp_info.highrefine do
        table.insert(msgParam.mvp_info.highrefine, mvp_info.highrefine[i])
      end
    end
    if mvp_info ~= nil and mvp_info.partner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      msgParam.mvp_info.partner = mvp_info.partner
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.id ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.mercenary == nil then
        msgParam.mvp_info.mercenary = {}
      end
      msgParam.mvp_info.mercenary.id = mvp_info.mercenary.id
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.name ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.mercenary == nil then
        msgParam.mvp_info.mercenary = {}
      end
      msgParam.mvp_info.mercenary.name = mvp_info.mercenary.name
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.icon ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.mercenary == nil then
        msgParam.mvp_info.mercenary = {}
      end
      msgParam.mvp_info.mercenary.icon = mvp_info.mercenary.icon
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.job ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.mercenary == nil then
        msgParam.mvp_info.mercenary = {}
      end
      msgParam.mvp_info.mercenary.job = mvp_info.mercenary.job
    end
    if mvp_info.mercenary ~= nil and mvp_info.mercenary.mercenary_name ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.mercenary == nil then
        msgParam.mvp_info.mercenary = {}
      end
      msgParam.mvp_info.mercenary.mercenary_name = mvp_info.mercenary.mercenary_name
    end
    if mvp_info ~= nil and mvp_info.memory_pos ~= nil then
      if msgParam.mvp_info == nil then
        msgParam.mvp_info = {}
      end
      if msgParam.mvp_info.memory_pos == nil then
        msgParam.mvp_info.memory_pos = {}
      end
      for i = 1, #mvp_info.memory_pos do
        table.insert(msgParam.mvp_info.memory_pos, mvp_info.memory_pos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallDesertWolfRuleSyncCmd(full_fire, ban_personal_art, ban_artifact, ban_pvp_potion)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.DesertWolfRuleSyncCmd()
    if full_fire ~= nil then
      msg.full_fire = full_fire
    end
    if ban_personal_art ~= nil then
      msg.ban_personal_art = ban_personal_art
    end
    if ban_artifact ~= nil then
      msg.ban_artifact = ban_artifact
    end
    if ban_pvp_potion ~= nil then
      msg.ban_pvp_potion = ban_pvp_potion
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DesertWolfRuleSyncCmd.id
    local msgParam = {}
    if full_fire ~= nil then
      msgParam.full_fire = full_fire
    end
    if ban_personal_art ~= nil then
      msgParam.ban_personal_art = ban_personal_art
    end
    if ban_artifact ~= nil then
      msgParam.ban_artifact = ban_artifact
    end
    if ban_pvp_potion ~= nil then
      msgParam.ban_pvp_potion = ban_pvp_potion
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryTriplePwsRankMatchCCmd(rankinfo, limitscore, bestrank, isfinish, lastrankinfo)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryTriplePwsRankMatchCCmd()
    if rankinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rankinfo == nil then
        msg.rankinfo = {}
      end
      for i = 1, #rankinfo do
        table.insert(msg.rankinfo, rankinfo[i])
      end
    end
    if limitscore ~= nil then
      msg.limitscore = limitscore
    end
    if bestrank ~= nil then
      msg.bestrank = bestrank
    end
    if isfinish ~= nil then
      msg.isfinish = isfinish
    end
    if lastrankinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lastrankinfo == nil then
        msg.lastrankinfo = {}
      end
      for i = 1, #lastrankinfo do
        table.insert(msg.lastrankinfo, lastrankinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTriplePwsRankMatchCCmd.id
    local msgParam = {}
    if rankinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rankinfo == nil then
        msgParam.rankinfo = {}
      end
      for i = 1, #rankinfo do
        table.insert(msgParam.rankinfo, rankinfo[i])
      end
    end
    if limitscore ~= nil then
      msgParam.limitscore = limitscore
    end
    if bestrank ~= nil then
      msgParam.bestrank = bestrank
    end
    if isfinish ~= nil then
      msgParam.isfinish = isfinish
    end
    if lastrankinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lastrankinfo == nil then
        msgParam.lastrankinfo = {}
      end
      for i = 1, #lastrankinfo do
        table.insert(msgParam.lastrankinfo, lastrankinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallQueryTriplePwsTeamInfoMatchCCmd(userinfos, forbid_profession, open, season, count, opentime, season_begin, season_breakbegin, season_breakend)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.QueryTriplePwsTeamInfoMatchCCmd()
    if userinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userinfos == nil then
        msg.userinfos = {}
      end
      for i = 1, #userinfos do
        table.insert(msg.userinfos, userinfos[i])
      end
    end
    if forbid_profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.forbid_profession == nil then
        msg.forbid_profession = {}
      end
      for i = 1, #forbid_profession do
        table.insert(msg.forbid_profession, forbid_profession[i])
      end
    end
    if open ~= nil then
      msg.open = open
    end
    if season ~= nil then
      msg.season = season
    end
    if count ~= nil then
      msg.count = count
    end
    if opentime ~= nil then
      msg.opentime = opentime
    end
    if season_begin ~= nil then
      msg.season_begin = season_begin
    end
    if season_breakbegin ~= nil then
      msg.season_breakbegin = season_breakbegin
    end
    if season_breakend ~= nil then
      msg.season_breakend = season_breakend
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTriplePwsTeamInfoMatchCCmd.id
    local msgParam = {}
    if userinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userinfos == nil then
        msgParam.userinfos = {}
      end
      for i = 1, #userinfos do
        table.insert(msgParam.userinfos, userinfos[i])
      end
    end
    if forbid_profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.forbid_profession == nil then
        msgParam.forbid_profession = {}
      end
      for i = 1, #forbid_profession do
        table.insert(msgParam.forbid_profession, forbid_profession[i])
      end
    end
    if open ~= nil then
      msgParam.open = open
    end
    if season ~= nil then
      msgParam.season = season
    end
    if count ~= nil then
      msgParam.count = count
    end
    if opentime ~= nil then
      msgParam.opentime = opentime
    end
    if season_begin ~= nil then
      msgParam.season_begin = season_begin
    end
    if season_breakbegin ~= nil then
      msgParam.season_breakbegin = season_breakbegin
    end
    if season_breakend ~= nil then
      msgParam.season_breakend = season_breakend
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTriplePvpQuestQueryCmd(datas)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TriplePvpQuestQueryCmd()
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
    local msgId = ProtoReqInfoList.TriplePvpQuestQueryCmd.id
    local msgParam = {}
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

function ServiceMatchCCmdAutoProxy:CallSyncMatchHeadInfoMatchCCmd(etype, nowcount, needcount)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.SyncMatchHeadInfoMatchCCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if nowcount ~= nil then
      msg.nowcount = nowcount
    end
    if needcount ~= nil then
      msg.needcount = needcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncMatchHeadInfoMatchCCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if nowcount ~= nil then
      msgParam.nowcount = nowcount
    end
    if needcount ~= nil then
      msgParam.needcount = needcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTriplePvpPickRewardCmd(etype)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TriplePvpPickRewardCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TriplePvpPickRewardCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallTriplePvpRewardStatusCmd(goal_reward_status, rank_reward_status)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.TriplePvpRewardStatusCmd()
    if goal_reward_status ~= nil then
      msg.goal_reward_status = goal_reward_status
    end
    if rank_reward_status ~= nil then
      msg.rank_reward_status = rank_reward_status
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TriplePvpRewardStatusCmd.id
    local msgParam = {}
    if goal_reward_status ~= nil then
      msgParam.goal_reward_status = goal_reward_status
    end
    if rank_reward_status ~= nil then
      msgParam.rank_reward_status = rank_reward_status
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallChampionPvpPickRewardCmd(etype)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ChampionPvpPickRewardCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChampionPvpPickRewardCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:CallChampionPvpRewardStatusCmd(rewards)
  if not NetConfig.PBC then
    local msg = MatchCCmd_pb.ChampionPvpRewardStatusCmd()
    if rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewards == nil then
        msg.rewards = {}
      end
      for i = 1, #rewards do
        table.insert(msg.rewards, rewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChampionPvpRewardStatusCmd.id
    local msgParam = {}
    if rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewards == nil then
        msgParam.rewards = {}
      end
      for i = 1, #rewards do
        table.insert(msgParam.rewards, rewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMatchCCmdAutoProxy:RecvReqMyRoomMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReqMyRoomMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReqRoomListCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReqRoomListCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReqRoomDetailCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReqRoomDetailCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvJoinRoomCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdJoinRoomCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvLeaveRoomCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdLeaveRoomCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfRoomStateCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfRoomStateCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfFightStatCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfFightStatCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvJoinFightingCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdJoinFightingCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvComboNotifyCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdComboNotifyCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvRevChallengeCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdRevChallengeCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvKickTeamCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdKickTeamCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvFightConfirmCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdFightConfirmCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvPvpResultCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdPvpResultCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvPvpTeamMemberUpdateCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvPvpMemberDataUpdateCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfMatchInfoCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvGodEndTimeCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdGodEndTimeCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvNtfRankChangeCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfRankChangeCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvOpenGlobalShopPanelCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdOpenGlobalShopPanelCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTutorMatchResultNtfMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTutorMatchResponseMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTutorMatchResponseMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTeamPwsPreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvUpdatePreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdUpdatePreInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryTeamPwsRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTeamPwsRankMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryTeamPwsTeamInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryMenrocoRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryMenrocoRankMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvMidMatchPrepareMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdMidMatchPrepareMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryBattlePassRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryBattlePassRankMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelvePvpPreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelvePvpPreInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelvePvpUpdatePreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelvePvpUpdatePreInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandQueryMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandQueryMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandSortMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandSortMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandTreeMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandTreeMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandInviterMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandInviterMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandInviteeMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandInviteeMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandPrepareMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandPrepareMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandLeaveMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandLeaveMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandDeleteMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandDeleteMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandNameMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandNameMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandSignUpMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandSignUpMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandMatchMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandMatchMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandTeamListMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandTeamListMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveWarbandCreateMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandCreateMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvSyncMatchInfoCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdSyncMatchInfoCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryTwelveSeasonInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTwelveSeasonInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryTwelveSeasonFinishMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTwelveSeasonFinishMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvSyncMatchBoardOpenStateMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdSyncMatchBoardOpenStateMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTwelveSeasonTimeInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveSeasonTimeInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvEnterObservationMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdEnterObservationMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvObInitInfoFubenCmd(data)
  self:Notify(ServiceEvent.MatchCCmdObInitInfoFubenCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomBuildMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomBuildMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomInviterMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomInviterMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomInviteeMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomInviteeMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomKickMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomKickMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomLeaveMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomLeaveMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomApplyMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomApplyMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomListMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomListMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomStartMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomStartMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomChangeMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomChangeMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvReserveRoomPrepareMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomPrepareMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvJoinRaidWithRobotMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdJoinRaidWithRobotMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvDesertWolfStatQueryCmd(data)
  self:Notify(ServiceEvent.MatchCCmdDesertWolfStatQueryCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvDesertWolfRuleSyncCmd(data)
  self:Notify(ServiceEvent.MatchCCmdDesertWolfRuleSyncCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryTriplePwsRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTriplePwsRankMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvQueryTriplePwsTeamInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTriplePwsTeamInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTriplePvpQuestQueryCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTriplePvpQuestQueryCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvSyncMatchHeadInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdSyncMatchHeadInfoMatchCCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTriplePvpPickRewardCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTriplePvpPickRewardCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvTriplePvpRewardStatusCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTriplePvpRewardStatusCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvChampionPvpPickRewardCmd(data)
  self:Notify(ServiceEvent.MatchCCmdChampionPvpPickRewardCmd, data)
end

function ServiceMatchCCmdAutoProxy:RecvChampionPvpRewardStatusCmd(data)
  self:Notify(ServiceEvent.MatchCCmdChampionPvpRewardStatusCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.MatchCCmdReqMyRoomMatchCCmd = "ServiceEvent_MatchCCmdReqMyRoomMatchCCmd"
ServiceEvent.MatchCCmdReqRoomListCCmd = "ServiceEvent_MatchCCmdReqRoomListCCmd"
ServiceEvent.MatchCCmdReqRoomDetailCCmd = "ServiceEvent_MatchCCmdReqRoomDetailCCmd"
ServiceEvent.MatchCCmdJoinRoomCCmd = "ServiceEvent_MatchCCmdJoinRoomCCmd"
ServiceEvent.MatchCCmdLeaveRoomCCmd = "ServiceEvent_MatchCCmdLeaveRoomCCmd"
ServiceEvent.MatchCCmdNtfRoomStateCCmd = "ServiceEvent_MatchCCmdNtfRoomStateCCmd"
ServiceEvent.MatchCCmdNtfFightStatCCmd = "ServiceEvent_MatchCCmdNtfFightStatCCmd"
ServiceEvent.MatchCCmdJoinFightingCCmd = "ServiceEvent_MatchCCmdJoinFightingCCmd"
ServiceEvent.MatchCCmdComboNotifyCCmd = "ServiceEvent_MatchCCmdComboNotifyCCmd"
ServiceEvent.MatchCCmdRevChallengeCCmd = "ServiceEvent_MatchCCmdRevChallengeCCmd"
ServiceEvent.MatchCCmdKickTeamCCmd = "ServiceEvent_MatchCCmdKickTeamCCmd"
ServiceEvent.MatchCCmdFightConfirmCCmd = "ServiceEvent_MatchCCmdFightConfirmCCmd"
ServiceEvent.MatchCCmdPvpResultCCmd = "ServiceEvent_MatchCCmdPvpResultCCmd"
ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd = "ServiceEvent_MatchCCmdPvpTeamMemberUpdateCCmd"
ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd = "ServiceEvent_MatchCCmdPvpMemberDataUpdateCCmd"
ServiceEvent.MatchCCmdNtfMatchInfoCCmd = "ServiceEvent_MatchCCmdNtfMatchInfoCCmd"
ServiceEvent.MatchCCmdGodEndTimeCCmd = "ServiceEvent_MatchCCmdGodEndTimeCCmd"
ServiceEvent.MatchCCmdNtfRankChangeCCmd = "ServiceEvent_MatchCCmdNtfRankChangeCCmd"
ServiceEvent.MatchCCmdOpenGlobalShopPanelCCmd = "ServiceEvent_MatchCCmdOpenGlobalShopPanelCCmd"
ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd = "ServiceEvent_MatchCCmdTutorMatchResultNtfMatchCCmd"
ServiceEvent.MatchCCmdTutorMatchResponseMatchCCmd = "ServiceEvent_MatchCCmdTutorMatchResponseMatchCCmd"
ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd = "ServiceEvent_MatchCCmdTeamPwsPreInfoMatchCCmd"
ServiceEvent.MatchCCmdUpdatePreInfoMatchCCmd = "ServiceEvent_MatchCCmdUpdatePreInfoMatchCCmd"
ServiceEvent.MatchCCmdQueryTeamPwsRankMatchCCmd = "ServiceEvent_MatchCCmdQueryTeamPwsRankMatchCCmd"
ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd = "ServiceEvent_MatchCCmdQueryTeamPwsTeamInfoMatchCCmd"
ServiceEvent.MatchCCmdQueryMenrocoRankMatchCCmd = "ServiceEvent_MatchCCmdQueryMenrocoRankMatchCCmd"
ServiceEvent.MatchCCmdMidMatchPrepareMatchCCmd = "ServiceEvent_MatchCCmdMidMatchPrepareMatchCCmd"
ServiceEvent.MatchCCmdQueryBattlePassRankMatchCCmd = "ServiceEvent_MatchCCmdQueryBattlePassRankMatchCCmd"
ServiceEvent.MatchCCmdTwelvePvpPreInfoMatchCCmd = "ServiceEvent_MatchCCmdTwelvePvpPreInfoMatchCCmd"
ServiceEvent.MatchCCmdTwelvePvpUpdatePreInfoMatchCCmd = "ServiceEvent_MatchCCmdTwelvePvpUpdatePreInfoMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandQueryMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandQueryMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandSortMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandSortMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandTreeMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandTreeMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandInfoMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandInfoMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandInviterMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandInviterMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandInviteeMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandInviteeMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandPrepareMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandPrepareMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandLeaveMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandLeaveMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandDeleteMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandDeleteMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandNameMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandNameMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandSignUpMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandSignUpMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandMatchMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandMatchMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandTeamListMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandTeamListMatchCCmd"
ServiceEvent.MatchCCmdTwelveWarbandCreateMatchCCmd = "ServiceEvent_MatchCCmdTwelveWarbandCreateMatchCCmd"
ServiceEvent.MatchCCmdSyncMatchInfoCCmd = "ServiceEvent_MatchCCmdSyncMatchInfoCCmd"
ServiceEvent.MatchCCmdQueryTwelveSeasonInfoMatchCCmd = "ServiceEvent_MatchCCmdQueryTwelveSeasonInfoMatchCCmd"
ServiceEvent.MatchCCmdQueryTwelveSeasonFinishMatchCCmd = "ServiceEvent_MatchCCmdQueryTwelveSeasonFinishMatchCCmd"
ServiceEvent.MatchCCmdSyncMatchBoardOpenStateMatchCCmd = "ServiceEvent_MatchCCmdSyncMatchBoardOpenStateMatchCCmd"
ServiceEvent.MatchCCmdTwelveSeasonTimeInfoMatchCCmd = "ServiceEvent_MatchCCmdTwelveSeasonTimeInfoMatchCCmd"
ServiceEvent.MatchCCmdEnterObservationMatchCCmd = "ServiceEvent_MatchCCmdEnterObservationMatchCCmd"
ServiceEvent.MatchCCmdObInitInfoFubenCmd = "ServiceEvent_MatchCCmdObInitInfoFubenCmd"
ServiceEvent.MatchCCmdReserveRoomBuildMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomBuildMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomInviterMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomInviterMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomInviteeMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomInviteeMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomKickMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomKickMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomLeaveMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomLeaveMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomApplyMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomApplyMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomInfoMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomInfoMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomListMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomListMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomStartMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomStartMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomChangeMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomChangeMatchCCmd"
ServiceEvent.MatchCCmdReserveRoomPrepareMatchCCmd = "ServiceEvent_MatchCCmdReserveRoomPrepareMatchCCmd"
ServiceEvent.MatchCCmdJoinRaidWithRobotMatchCCmd = "ServiceEvent_MatchCCmdJoinRaidWithRobotMatchCCmd"
ServiceEvent.MatchCCmdDesertWolfStatQueryCmd = "ServiceEvent_MatchCCmdDesertWolfStatQueryCmd"
ServiceEvent.MatchCCmdDesertWolfRuleSyncCmd = "ServiceEvent_MatchCCmdDesertWolfRuleSyncCmd"
ServiceEvent.MatchCCmdQueryTriplePwsRankMatchCCmd = "ServiceEvent_MatchCCmdQueryTriplePwsRankMatchCCmd"
ServiceEvent.MatchCCmdQueryTriplePwsTeamInfoMatchCCmd = "ServiceEvent_MatchCCmdQueryTriplePwsTeamInfoMatchCCmd"
ServiceEvent.MatchCCmdTriplePvpQuestQueryCmd = "ServiceEvent_MatchCCmdTriplePvpQuestQueryCmd"
ServiceEvent.MatchCCmdSyncMatchHeadInfoMatchCCmd = "ServiceEvent_MatchCCmdSyncMatchHeadInfoMatchCCmd"
ServiceEvent.MatchCCmdTriplePvpPickRewardCmd = "ServiceEvent_MatchCCmdTriplePvpPickRewardCmd"
ServiceEvent.MatchCCmdTriplePvpRewardStatusCmd = "ServiceEvent_MatchCCmdTriplePvpRewardStatusCmd"
ServiceEvent.MatchCCmdChampionPvpPickRewardCmd = "ServiceEvent_MatchCCmdChampionPvpPickRewardCmd"
ServiceEvent.MatchCCmdChampionPvpRewardStatusCmd = "ServiceEvent_MatchCCmdChampionPvpRewardStatusCmd"
