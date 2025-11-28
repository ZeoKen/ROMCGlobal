autoImport("ServiceMatchCCmdAutoProxy")
ServiceMatchCCmdProxy = class("ServiceMatchCCmdProxy", ServiceMatchCCmdAutoProxy)
ServiceMatchCCmdProxy.Instance = nil
ServiceMatchCCmdProxy.NAME = "ServiceMatchCCmdProxy"

function ServiceMatchCCmdProxy:ctor(proxyName)
  if ServiceMatchCCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMatchCCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMatchCCmdProxy.Instance = self
  end
end

function ServiceMatchCCmdProxy:RecvReqRoomListCCmd(data)
  helplog("MatchCCmd Recv ReqRoomListCCmd", data.type, #data.room_lists)
  for i = 1, #data.room_lists do
    local whole = data.room_lists[i].name
    local prefix = string.match(whole, "[^-]+") or ""
    local suffix = string.match(whole, "-.+") or ""
    data.room_lists[i].name = OverSea.LangManager.Instance():GetLangByKey(prefix) .. suffix
  end
  PvpProxy.Instance:SetRoomList(data.type, data.room_lists)
  if data.type == PvpProxy.Type.Yoyo then
    PvpProxy.Instance:SetYoyoRoomList(data.type, data.room_lists)
  end
  self:Notify(ServiceEvent.MatchCCmdReqRoomListCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReqRoomDetailCCmd(data)
  helplog("MatchCCmd Recv ReqRoomDetailCCmd", data.type, data.roomid)
  PvpProxy.Instance:SetRoomDetailInfo(data.type, data.roomid, data.datail_info)
  self:Notify(ServiceEvent.MatchCCmdReqRoomDetailCCmd, data)
end

function ServiceMatchCCmdProxy:CallReqMyRoomMatchCCmd(type, brief_info)
  helplog("Call --> ReqMyRoomMatchCCmd", type)
  ServiceMatchCCmdProxy.super.CallReqMyRoomMatchCCmd(self, type)
end

function ServiceMatchCCmdProxy:CallRevChallengeCCmd(type, roomid, challenger, challenger_zoneid, members, reply)
  helplog("reply: ", reply)
  helplog("MatchCCmd Call CallRevChallengeCCmd", type, reply, roomid, members, challenger, challenger_zoneid)
  ServiceMatchCCmdProxy.super.CallRevChallengeCCmd(self, type, roomid, challenger, challenger_zoneid, members, reply)
end

function ServiceMatchCCmdProxy:RecvRevChallengeCCmd(data)
  helplog("Recv-->ChallengeCCmd", tostring(data.challenger), data.challenger_zoneid, data.roomid, data.type)
  self:Notify(ServiceEvent.MatchCCmdRevChallengeCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReqMyRoomMatchCCmd(data)
  helplog("Recv --> MatchCCmd Recv ReqMyRoomMatchCCmd")
  PvpProxy.Instance:SetMyRoomBriefInfo(data.type, data.brief_info)
  self:Notify(ServiceEvent.MatchCCmdReqMyRoomMatchCCmd, data)
end

function ServiceMatchCCmdProxy:CallFightConfirmCCmd(type, roomid, teamid, reply)
  helplog("MatchCCmd CallFightConfirmCCmd", type, roomid, teamid, reply)
  ServiceMatchCCmdProxy.super.CallFightConfirmCCmd(self, type, roomid, teamid, reply)
end

function ServiceMatchCCmdProxy:CallJoinRoomCCmd(type, roomid, name, isquick, teamid, teammember, ret, guildid, users, matcher, charid, zoneid, serverid, teamexptype, onlymyserver, entranceid, need_robot_npc, need_heal_profession, abyss_option)
  local logStr = string.format("type:%s, roomid:%s, teamid:%s", tostring(type), tostring(roomid), tostring(teamid))
  helplog("MatchCCmd Call JoinRoomCCmd", logStr)
  if nil == need_robot_npc then
    local var_ai = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_NEED_ROBOT_NPC) or 0
    need_robot_npc = var_ai == 1
  end
  if nil == need_heal_profession then
    local var_healProfession = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_NEED_HEAL_PROFESSION) or 0
    need_heal_profession = var_healProfession == 1
  end
  ServiceMatchCCmdProxy.super.CallJoinRoomCCmd(self, type, roomid, name, isquick, teamid, teammember, ret, guildid, users, matcher, charid, zoneid, serverid, teamexptype, onlymyserver, entranceid, need_robot_npc, need_heal_profession, abyss_option)
end

function ServiceMatchCCmdProxy:CallLeaveRoomCCmd(type, guid)
  helplog("MatchCCmd Call LeaveRoomCCmd", type, guid)
  ServiceMatchCCmdProxy.super.CallLeaveRoomCCmd(self, type, guid)
end

function ServiceMatchCCmdProxy:CallReqRoomDetailCCmd(type, guid, datail_info)
  helplog("MatchCCmd Call ReqRoomDetailCCmd", type, guid)
  ServiceMatchCCmdProxy.super.CallReqRoomDetailCCmd(self, type, guid)
end

function ServiceMatchCCmdProxy:RecvNtfFightStatCCmd(data)
  PvpProxy.Instance:NtfFightStatCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfFightStatCCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdNtfFightStatCCmd, data)
end

function ServiceMatchCCmdProxy:RecvGodEndTimeCCmd(data)
  PvpProxy.Instance:RecvGodEndTime(data.endtime)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdGodEndTimeCCmd, data)
end

function ServiceMatchCCmdProxy:CallReqRoomListCCmd(type, roomids, room_lists)
  helplog("MatchCCmd Call CallReqRoomListCCmd", type)
  ServiceMatchCCmdProxy.super.CallReqRoomListCCmd(self, type, roomids, room_lists)
end

function ServiceMatchCCmdProxy:RecvComboNotifyCCmd(data)
  helplog("MatchCCmd Recv RecvComboNotifyCCmd", data)
  self:Notify(ServiceEvent.MatchCCmdComboNotifyCCmd, data)
  ComboCtl.Instance:ShowCombo(data.comboNum)
end

function ServiceMatchCCmdProxy:RecvPvpResultCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdPvpResultCCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdPvpResultCCmd, data)
  local dataType = data.type
  if dataType == PvpProxy.Type.DesertWolf or dataType == PvpProxy.Type.GorgeousMetal then
    helplog("RecvPvpResultCCmd ", data.result)
    if data.result == 3 then
      MsgManager.ShowMsgByID(972)
    elseif data.result == 1 or data.result == 2 then
      PvpProxy.Instance:HandlePvpResult(data.result)
    end
  elseif dataType == PvpProxy.Type.PoringFight then
    PvpProxy.Instance:PoringFightResult(data.rank, data.reward, data.apple)
  end
end

function ServiceMatchCCmdProxy:RecvPvpMemberDataUpdateCCmd(data)
  helplog("Recv-->PvpMemberDataUpdateCCmd")
  PvpProxy.Instance:PvpMemberDataUpdate(data.data)
  self:Notify(ServiceEvent.MatchCCmdPvpMemberDataUpdateCCmd, data)
end

function ServiceMatchCCmdProxy:RecvPvpTeamMemberUpdateCCmd(data)
  helplog("Recv-->PvpTeamMemberUpdateCCmd")
  PvpProxy.Instance:PvpTeamMemberUpdateCCmd(data.data)
  self:Notify(ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd, data)
end

function ServiceMatchCCmdProxy:RecvKickTeamCCmd(data)
  helplog("Recv-->DoKickTeamCCmd", data.type, data.roomid, data.zoneid, data.teamid)
  PvpProxy.Instance:DoKickTeamCCmd(data.type, data.roomid, data.zoneid, data.teamid)
  self:Notify(ServiceEvent.MatchCCmdKickTeamCCmd, data)
end

function ServiceMatchCCmdProxy:RecvNtfRoomStateCCmd(data)
  helplog("Recv-->NtfRoomStateCCmd", data.pvp_type, data.roomid, data.state, data.endtime)
  PvpProxy.Instance:UpdateMyRoomStatus(data.pvp_type, data.roomid, data.state, data.endtime)
  self:Notify(ServiceEvent.MatchCCmdNtfRoomStateCCmd, data)
end

function ServiceMatchCCmdProxy:RecvNtfMatchInfoCCmd(data)
  helplog("Recv-->NtfMatchInfoCCmd", data.etype, data.ismatch, data.isfight)
  PvpProxy.Instance:NtfMatchInfo(data.etype, data.ismatch, data.isfight, data.robot_rest_time, data.robot_match_time, data.configid, data.begintime)
  self:Notify(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, data)
  if not data.ismatch then
    ServiceMatchCCmdProxy.Instance:CallNtfMatchInfoCCmd(data.etype, false, data.isfight, data.robot_rest_time, data.robot_match_time, data.configid, data.begintime)
  end
end

function ServiceMatchCCmdProxy:RecvNtfRankChangeCCmd(data)
  PvpProxy.Instance:RecvNtfRankChangeCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdNtfRankChangeCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTutorMatchResultNtfMatchCCmd(data)
  helplog("Recv-->RecvTutorMatchResultNtfMatchCCmd")
  TutorProxy.Instance:UpdateTutorMatchInfo(data)
  self:Notify(ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTutorMatchResponseMatchCCmd(data)
  helplog("Recv-->RecvTutorMatchResponseMatchCCmd")
  TutorProxy.Instance:UpdateTutorMatchInfo(data)
  self:Notify(ServiceEvent.MatchCCmdTutorMatchResponseMatchCCmd, data)
end

function ServiceMatchCCmdProxy:CallTutorMatchResponseMatchCCmd(response)
  helplog("Call-->CallTutorMatchResponseMatchCCmd")
  self.super.CallTutorMatchResponseMatchCCmd(self, response)
end

function ServiceMatchCCmdProxy:RecvTeamPwsPreInfoMatchCCmd(data)
  if TwelvePvPProxy.Instance:Is12pvp(data.etype) then
    redlog("【线上反馈】12V12匹配后的确认环节取消掉【D2】,屏蔽后端消息 TeamPwsPreInfoMatchCCmd")
    return
  end
  PvpProxy.Instance:RecvTeamPwsPreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvUpdatePreInfoMatchCCmd(data)
  PvpProxy.Instance:RecvUpdatePreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdUpdatePreInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelvePvpPreInfoMatchCCmd(data)
  PvpProxy.Instance:RecvTeamPwsPreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelvePvpPreInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelvePvpUpdatePreInfoMatchCCmd(data)
  if TwelvePvPProxy.Instance:Is12pvp(data.etype) then
    redlog("【线上反馈】12V12匹配后的确认环节取消掉【D2】,屏蔽后端消息 TwelvePvpUpdatePreInfoMatchCCmd")
    return
  end
  PvpProxy.Instance:HandleTwelvePvpUpdatePreInfoMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdTwelvePvpUpdatePreInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvMidMatchPrepareMatchCCmd(data)
  PvpProxy.Instance:SetPrepareFinishFlag(data.finish)
  self:Notify(ServiceEvent.MatchCCmdMidMatchPrepareMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvQueryTeamPwsRankMatchCCmd(data)
  PvpProxy.Instance:RecvQueryTeamPwsRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTeamPwsRankMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvQueryBattlePassRankMatchCCmd(data)
  BattlePassProxy.Instance:RecvQueryBattlePassRankMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdQueryBattlePassRankMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvQueryTeamPwsTeamInfoMatchCCmd(data)
  PvpProxy.Instance:HandleQueryTeamPwsTeamInfo(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandTreeMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    if data.cross_server then
      CupMode6v6Proxy_MultiServer.Instance:HandleTreeBandData(data)
    else
      CupMode6v6Proxy.Instance:HandleTreeBandData(data)
    end
    self:Notify(CupModeEvent.Tree_6v6, data)
    return
  end
  if data.cross_server then
    WarbandProxy_MultiServer.Instance:HandleTreeBandData(data)
  else
    WarbandProxy.Instance:HandleTreeBandData(data)
  end
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandTreeMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandLeaveMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    CupMode6v6Proxy_MultiServer.Instance:ExitMyband()
    CupMode6v6Proxy.Instance:ExitMyband()
    self:Notify(CupModeEvent.Leave_6v6, data)
    return
  end
  WarbandProxy_MultiServer.Instance:ExitMyband()
  WarbandProxy.Instance:ExitMyband()
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandLeaveMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandInviterMatchCCmd(data)
  redlog("RecvTwelveWarbandInviterMatchCCmd 邀请的战队guid 被邀请玩家charid： ", data.charid)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    self:Notify(CupModeEvent.Inviter_6v6, data)
    return
  end
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandInviterMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandQueryMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    if data.season and data.season > 10000 then
      CupMode6v6Proxy_MultiServer.Instance:HandleQueryMember(data)
    else
      CupMode6v6Proxy.Instance:HandleQueryMember(data)
    end
    self:Notify(CupModeEvent.QueryBand_6v6, data)
    return
  end
  if data.season and data.season > 10000 then
    WarbandProxy_MultiServer.Instance:HandleQueryMember(data)
  else
    WarbandProxy.Instance:HandleQueryMember(data)
  end
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandQueryMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandInfoMatchCCmd(data)
  redlog("[cup] RecvTwelveWarbandInfoMatchCCmd", data.guid, data.warbandname, data.etype, #data.memberinfo)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    CupMode6v6Proxy.Instance:HandleUpdateMyWarband(data)
    CupMode6v6Proxy_MultiServer.Instance:HandleUpdateMyWarband(data)
    self:Notify(CupModeEvent.BandInfo_6v6, data)
    return
  end
  WarbandProxy.Instance:HandleUpdateMyWarband(data)
  WarbandProxy_MultiServer.Instance:HandleUpdateMyWarband(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandTeamListMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    if data.cross_server then
      CupMode6v6Proxy_MultiServer.Instance:HandleQueryList(data.teaminfo)
    else
      CupMode6v6Proxy.Instance:HandleQueryList(data.teaminfo)
    end
    self:Notify(CupModeEvent.TeamList_6v6, data)
    return
  end
  if data.cross_server then
    WarbandProxy_MultiServer.Instance:HandleQueryList(data.teaminfo)
  else
    WarbandProxy.Instance:HandleQueryList(data.teaminfo)
  end
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandTeamListMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveWarbandSortMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    if data.cross_server then
      CupMode6v6Proxy_MultiServer.Instance:HandleSessionSort(data.sortinfo)
    else
      CupMode6v6Proxy.Instance:HandleSessionSort(data.sortinfo)
    end
    self:Notify(CupModeEvent.Sort_6v6, data)
    return
  end
  if data.cross_server then
    WarbandProxy_MultiServer.Instance:HandleSessionSort(data.sortinfo)
  else
    WarbandProxy.Instance:HandleSessionSort(data.sortinfo)
  end
  self:Notify(ServiceEvent.MatchCCmdTwelveWarbandSortMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvObInitInfoFubenCmd(data)
  PvpObserveProxy.Instance:HandleObserverPlayerInfoInit(data.infos)
  self:Notify(ServiceEvent.MatchCCmdObInitInfoFubenCmd, data)
end

function ServiceMatchCCmdProxy:RecvSyncMatchInfoCCmd(data)
  PvpProxy.Instance:HandleSyncMatchInfo(data)
  self:Notify(ServiceEvent.MatchCCmdSyncMatchInfoCCmd, data)
  if not data.ismatch then
    ServiceMatchCCmdProxy.Instance:CallSyncMatchInfoCCmd(data.etype, false, data.coldtime, data.raidid)
  end
end

function ServiceMatchCCmdProxy:RecvQueryTwelveSeasonInfoMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    if data.cross_server_champion then
      CupMode6v6Proxy_MultiServer.Instance:HandleWarbandTime(data)
    else
      CupMode6v6Proxy.Instance:HandleWarbandTime(data)
    end
    self:Notify(CupModeEvent.SeasonInfo_6v6, data)
    return
  end
  if data.cross_server_champion then
    WarbandProxy_MultiServer.Instance:HandleWarbandTime(data)
  else
    WarbandProxy.Instance:HandleWarbandTime(data)
  end
  self:Notify(ServiceEvent.MatchCCmdQueryTwelveSeasonInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvQueryTwelveSeasonFinishMatchCCmd(data)
  if data and data.etype == EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION then
    if data.cross_server then
      CupMode6v6Proxy_MultiServer.Instance:ShutDown()
    else
      CupMode6v6Proxy.Instance:ShutDown()
    end
    self:Notify(CupModeEvent.SeasonFinish_6v6, data)
    return
  end
  if data.cross_server then
    WarbandProxy_MultiServer.Instance:ShutDown()
  else
    WarbandProxy.Instance:ShutDown()
  end
  self:Notify(ServiceEvent.MatchCCmdQueryTwelveSeasonFinishMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTwelveSeasonTimeInfoMatchCCmd(data)
  WarbandProxy.Instance:HandleTwelveSeasonTime4Calendar(data)
  self:Notify(ServiceEvent.MatchCCmdTwelveSeasonTimeInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReserveRoomInfoMatchCCmd(data)
  PvpCustomRoomProxy.Instance:HandleCurrentRoomInfoResp(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReserveRoomLeaveMatchCCmd(data)
  PvpCustomRoomProxy.Instance:HandleLeaveRoomResp(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomLeaveMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReserveRoomListMatchCCmd(data)
  PvpCustomRoomProxy.Instance:HandleRoomListResp(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomListMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReserveRoomInviterMatchCCmd(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomInviterMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvReserveRoomPrepareMatchCCmd(data)
  PvpCustomRoomProxy.Instance:HandleReadyResp(data)
  self:Notify(ServiceEvent.MatchCCmdReserveRoomPrepareMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvDesertWolfStatQueryCmd(data)
  DesertWolfProxy.Instance:RecvDesertWolfStatQuery(data)
  self:Notify(ServiceEvent.MatchCCmdDesertWolfStatQueryCmd, data)
end

function ServiceMatchCCmdProxy:RecvDesertWolfRuleSyncCmd(data)
  PvpProxy.Instance:RecvDesertWolfRuleSync(data)
  self:Notify(ServiceEvent.MatchCCmdDesertWolfRuleSyncCmd, data)
end

function ServiceMatchCCmdProxy:RecvQueryTriplePwsRankMatchCCmd(data)
  redlog("ServiceMatchCCmdProxy:RecvQueryTriplePwsRankMatchCCmd")
  PvpProxy.Instance:UpdateTriplePwsRankData(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTriplePwsRankMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvQueryTriplePwsTeamInfoMatchCCmd(data)
  redlog("ServiceMatchCCmdProxy:RecvQueryTriplePwsTeamInfoMatchCCmd")
  PvpProxy.Instance:UpdateTriplePwsTeamInfo(data)
  self:Notify(ServiceEvent.MatchCCmdQueryTriplePwsTeamInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTriplePvpQuestQueryCmd(data)
  redlog("ServiceMatchCCmdProxy:RecvTriplePvpQuestQueryCmd")
  PvpProxy.Instance:UpdateTripleTeamPwsTargetProgress(data.datas)
  self:Notify(ServiceEvent.MatchCCmdTriplePvpQuestQueryCmd, data)
end

function ServiceMatchCCmdProxy:RecvSyncMatchHeadInfoMatchCCmd(data)
  redlog("ServiceMatchCCmdProxy:RecvSyncMatchHeadInfoMatchCCmd", tostring(data.etype))
  PvpProxy.Instance:UpdatePvpMatchHeadCountInfo(data)
  self:Notify(ServiceEvent.MatchCCmdSyncMatchHeadInfoMatchCCmd, data)
end

function ServiceMatchCCmdProxy:RecvTriplePvpRewardStatusCmd(data)
  PvpProxy.Instance:UpdateTriplePwsRewardStatus(data)
  self:Notify(ServiceEvent.MatchCCmdTriplePvpRewardStatusCmd, data)
end

function ServiceMatchCCmdProxy:RecvChampionPvpRewardStatusCmd(data)
  PvpProxy.Instance:UpdateChampionPvpRewardStatusCmd(data)
  self:Notify(ServiceEvent.MatchCCmdChampionPvpRewardStatusCmd, data)
end

function ServiceMatchCCmdProxy:RecvAbyssRoomStateNtfMatchCCmd(data)
  FunctionAbyssDragon.Me():HandleAbyssRoomState(data.state)
  self:Notify(ServiceEvent.MatchCCmdAbyssRoomStateNtfMatchCCmd, data)
end
