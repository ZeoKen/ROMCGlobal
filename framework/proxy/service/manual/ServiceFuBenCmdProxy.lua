autoImport("ServiceFuBenCmdAutoProxy")
ServiceFuBenCmdProxy = class("ServiceFuBenCmdProxy", ServiceFuBenCmdAutoProxy)
ServiceFuBenCmdProxy.Instance = nil
ServiceFuBenCmdProxy.NAME = "ServiceFuBenCmdProxy"
local _isObserveMode = function()
  local _observeProxy = PvpObserveProxy.Instance
  return _observeProxy:IsRunning()
end
local _observeDebug = function(...)
  local _observeProxy = PvpObserveProxy.Instance
  _observeProxy:Debug(...)
end

function ServiceFuBenCmdProxy:ctor(proxyName)
  if ServiceFuBenCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceFuBenCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceFuBenCmdProxy.Instance = self
  end
end

function ServiceFuBenCmdProxy:CallStartStageUserCmd(subStageData)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.StartStageUserCmd.id
    local msgParam = {}
    if subStageData ~= nil then
      msgParam.stageid = subStageData.mainStage.id
      msgParam.stepid = subStageData.staticData.Step
      msgParam.type = subStageData.type
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = FuBenCmd_pb.StartStageUserCmd()
    if subStageData ~= nil then
      msg.stageid = subStageData.mainStage.id
      msg.stepid = subStageData.staticData.Step
      msg.type = subStageData.type
    end
    self:SendProto(msg)
  end
end

function ServiceFuBenCmdProxy:RecvWorldStageUserCmd(data)
  DungeonProxy.Instance:InitMainStageInfo(data.list)
  local info
  for i = 1, #data.curinfo do
    info = data.curinfo[i]
    if info.type == SubStageData.NormalType then
      DungeonProxy.Instance:SetNormalStageProgress(info.stageid, info.stepid)
    end
  end
  self:Notify(ServiceEvent.FuBenCmdWorldStageUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvStageStepUserCmd(data)
  DungeonProxy.Instance:UpdateMainStageSubs(data)
  self:Notify(ServiceEvent.FuBenCmdStageStepUserCmd, DungeonProxy.Instance:GetMainStage(data.stageid))
end

function ServiceFuBenCmdProxy:RecvStageStepStarUserCmd(data)
  DungeonProxy.Instance:UpdateMainStageInfo(data)
  self:Notify(ServiceEvent.FuBenCmdStageStepStarUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvGetRewardStageUserCmd(data)
  DungeonProxy.Instance:GetReward(data.stageid, data.starid)
  self:Notify(ServiceEvent.FuBenCmdGetRewardStageUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvMonsterCountUserCmd(data)
  EndlessTowerProxy.Instance:RecvMonsterCountUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdMonsterCountUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvSuccessFuBenUserCmd(data)
  helplog("Recv-->SuccessFuBenUserCmd", data.param1, data.param2, data.param3, data.param4)
  FunctionDungen.Me():DungenBattleSuccess(data)
  self:Notify(ServiceEvent.FuBenCmdSuccessFuBenUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncPvePassInfoFubenCmd(data)
  PveEntranceProxy.Instance:RecvSyncPvePassInfoFubenCmd(data.passinfos, data.battletime, data.lastinfo, data.quick_boss, data.endlessrewardlayer, data.all_crack_non_first)
  BattleTimeDataProxy.Instance:HandleRecvSyncPvePassInfoFubenCmd(data)
  AstralProxy.Instance:RecvSyncAstralInfo(data.astral_season, data.astral_gotten_reward, data.astral_pass_num)
  self:Notify(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd)
end

function ServiceFuBenCmdProxy:RecvSyncPveCardOpenStateFubenCmd(data)
  PveEntranceProxy.Instance:HandleTeamLeaderPveCardOpenState(data.passinfos)
  self:Notify(ServiceEvent.FuBenCmdSyncPveCardOpenStateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvCountdownUserCmd(data)
  DojoProxy.Instance:RecvCountdownUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdCountdownUserCmd, data)
end

function ServiceFuBenCmdProxy:RecvFubenStepSyncCmd(data)
  QuestProxy.Instance:updateFubenQuestData(data.id, data.del, data.config, data.uniqueid)
  self:Notify(ServiceEvent.FuBenCmdFubenStepSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvFuBenClearInfoCmd(data)
  QuestProxy.Instance:clearFubenQuestData()
  self:Notify(ServiceEvent.RecvFuBenClearInfoCmd, data)
end

function ServiceFuBenCmdProxy:RecvFuBenProgressSyncCmd(data)
  QuestProxy.Instance:UpdateFubenProgress(data)
  self:Notify(ServiceEvent.FuBenCmdFuBenProgressSyncCmd, data)
end

function ServiceFuBenCmdProxy:CallGuildGateOptCmd(gatenpcid, opt, uplocklevel)
  helplog("ServiceFuBenCmdProxy Call-->GuildGateOptCmd", gatenpcid, opt, uplocklevel)
  ServiceFuBenCmdProxy.super.CallGuildGateOptCmd(self, gatenpcid, opt, uplocklevel)
end

function ServiceFuBenCmdProxy:RecvUserGuildRaidFubenCmd(data)
  helplog("ServiceFuBenCmdProxy Recv-->UserGuildRaidFubenCmd")
  GuildProxy.Instance:SetGuildGateInfo(data.gatedata)
  self:Notify(ServiceEvent.FuBenCmdUserGuildRaidFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireInfoFubenCmd(data)
  GvgProxy.Instance:RecvGuildFireInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvRoadblocksChangeFubenCmd(data)
  GvgProxy.Instance:HandleRoadBlockChange(data)
  self:Notify(ServiceEvent.FuBenCmdRoadblocksChangeFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireMetalHpFubenCmd(data)
  GvgProxy.Instance:RecvGuildFireMetalHpFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireNewDefFubenCmd(data)
  GvgProxy.Instance:RecvGuildFireNewDefFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGuildFireStatusFubenCmd(data)
  GvgProxy.Instance:SetGvgOpenTime(data.open, data.starttime)
  self:Notify(ServiceEvent.FuBenCmdGuildFireStatusFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgDataSyncCmd(data)
  GvgProxy.Instance:RecvGvgDataSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDataSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgDataUpdateCmd(data)
  GvgProxy.Instance:RecvGvgDataUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDataUpdateCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgDefNameChangeFubenCmd(data)
  GvgProxy.Instance:RecvGvgDefNameChangeFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDefNameChangeFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgRaidStateUpdateFubenCmd(data)
  GvgProxy.Instance:RecvGvgRaidStateUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgRaidStateUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryElementRaidStat(data)
  GroupRaidProxy.Instance:RecvQueryElementRaidStat(data)
  self:Notify(ServiceEvent.FuBenCmdQueryElementRaidStat, data)
end

function ServiceFuBenCmdProxy:RecvGvgPointUpdateFubenCmd(data)
  GvgProxy.Instance:RecvGvgPointUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgPointUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvBossDieFubenCmd(data)
  PvpProxy.Instance:RecvBossDieFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdBossDieFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvUpdateUserNumFubenCmd(data)
  PvpProxy.Instance:RecvUpdateUserNumFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdUpdateUserNumFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncMvpInfoFubenCmd(data)
  PvpProxy.Instance:RecvSyncMvpInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSuperGvgSyncFubenCmd(data)
  SuperGvgProxy.Instance:HandleRecvSuperGvgSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgTowerUpdateFubenCmd(data)
  SuperGvgProxy.Instance:HandleRecvGvgTowerUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgMetalDieFubenCmd(data)
  SuperGvgProxy.Instance:HandleRecvGvgMetalDieFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgMetalDieFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgCrystalUpdateFubenCmd(data)
  SuperGvgProxy.Instance:HandleRecvGvgCrystalUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryGvgTowerInfoFubenCmd(data)
  SuperGvgProxy.Instance:HandleRecvQueryGvgTowerInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryGvgTowerInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgRewardInfoFubenCmd(data)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "GVGResultView",
    rewardInfo = data.rewardinfo
  })
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgQueryUserDataFubenCmd(data)
  SuperGvgProxy.Instance:HandleRecvGvgUserDetailFubenCmd(data)
  local isEnd = data.is_end
  if isEnd then
    self:Notify(ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd, data)
  end
end

function ServiceFuBenCmdProxy:RecvMvpBattleReportFubenCmd(data)
  PvpProxy.Instance:RecvMvpBattleReportFubenCmd(data)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MVPResultView
  })
  self:Notify(ServiceEvent.FuBenCmdMvpBattleReportFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryTeamPwsUserInfoFubenCmd(data)
  PvpProxy.Instance:RecvQueryTeamPwsUserInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryTeamPwsUserInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTeamPwsReportFubenCmd(data)
  PvpProxy.Instance:RecvTeamPwsReportFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamPwsReportFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTeamPwsInfoSyncFubenCmd(data)
  helplog("Recv-->TeamPwsInfoSyncFubenCmd", data.endtime)
  PvpProxy.Instance:UpdateTeamPwsInfos(data.teaminfo, data.endtime, data.fullfire)
  self:Notify(ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvUpdateTeamPwsInfoFubenCmd(data)
  PvpProxy.Instance:UpdateTeamPwsInfos(data.teaminfo)
  self:Notify(ServiceEvent.FuBenCmdUpdateTeamPwsInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvReplySummonBossFubenCmd(data)
  if data.charid ~= Game.Myself.data.id then
    self:Notify(ServiceEvent.FuBenCmdReplySummonBossFubenCmd, data)
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local memberList = myTeam:GetPlayerMemberList(false, true)
  local onlineMemberCount = 0
  local nowRaid = Game.MapManager:GetRaidID()
  for i = 1, #memberList do
    local m = memberList[i]
    if m.raid == nowRaid and not memberList[i]:IsOffline() then
      onlineMemberCount = onlineMemberCount + 1
    end
  end
  if onlineMemberCount == 0 then
    return
  end
  RaidEnterWaitView.PreActiveButton_Start(false)
  RaidEnterWaitView.SetListenEvent(ServiceEvent.FuBenCmdReplySummonBossFubenCmd, function(view, note)
    local charid, isfull, agree = note.body.charid, note.body.isfull, note.body.agree
    view:UpdateMemberEnterState(charid, agree)
    if isfull ~= false then
      view:ActiveSummonedInfo(charid)
    end
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.SetAllApplyCall(function(view)
    view:CloseSelf()
  end)
  FunctionNpcFunc.JumpPanel(PanelConfig.RaidEnterWaitView)
end

function ServiceFuBenCmdProxy:RecvTeamExpReportFubenCmd(data)
  ExpRaidProxy.Instance:RecvExpRaidResult(data)
  self:Notify(ServiceEvent.FuBenCmdTeamExpReportFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTeamExpQueryInfoFubenCmd(data)
  ExpRaidProxy.Instance:RecvExpRaidTimesLeft(data)
  self:Notify(ServiceEvent.FuBenCmdTeamExpQueryInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGroupRaidStateSyncFuBenCmd(data)
  PvpProxy.Instance:SetGroupRaidState(data.state)
  self:Notify(ServiceEvent.FuBenCmdGroupRaidStateSyncFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryTeamGroupRaidUserInfo(data)
  GroupRaidProxy.Instance:RecvQueryTeamGroupRaidUserInfo(data)
  self:Notify(ServiceEvent.FuBenCmdQueryTeamGroupRaidUserInfo, data)
end

function ServiceFuBenCmdProxy:RecvUpdateGroupRaidFourthShowData(data)
  helplog("RecvUpdateGroupRaidFourthShowData")
  self:Notify(ServiceEvent.FuBenCmdUpdateGroupRaidFourthShowData, data)
end

function ServiceFuBenCmdProxy:RecvOthelloInfoSyncFubenCmd(data)
  PvpProxy.Instance:RecvOthelloInfoSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryOthelloUserInfoFubenCmd(data)
  PvpProxy.Instance:RecvQueryOthelloUserInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryOthelloUserInfoFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvOthelloReportFubenCmd(data)
  PvpProxy.Instance:RecvOthelloReportFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOthelloReportFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvOthelloPointOccupyPowerFubenCmd(data)
  PvpProxy.Instance:RecvOthelloPointOccupyPowerFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTransferFightRankFubenCmd(data)
  PvpProxy.Instance:RecvNtfTransferFightRankFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTransferFightRankFubenCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdTransferFightRankFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTransferFightEndFubenCmd(data)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdTransferFightEndFubenCmd, data)
  PvpProxy.Instance:TransferFightResult(data)
end

function ServiceFuBenCmdProxy:RecvTransferFightChooseFubenCmd(data)
  PvpProxy.Instance:SetTransferFightMonsterChooseCountDown(data)
  self:Notify(ServiceEvent.FuBenCmdTransferFightChooseFubenCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdTransferFightChooseFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvInviteRollRewardFubenCmd(data)
  DungeonProxy.Instance:RecvInviteRollReward(data.etype, data.param1, data.costcoin, data.count)
  ServiceFuBenCmdProxy.super.RecvInviteRollRewardFubenCmd(self, data)
end

function ServiceFuBenCmdProxy:RecvTeamRollStatusFuBenCmd(data)
  DungeonProxy.Instance:RecvTeamRollStatus(data.delid > 0 and data.delid or data.addids)
  self:Notify(ServiceEvent.FuBenCmdTeamRollStatusFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvPreReplyRollRewardFubenCmd(data)
  DungeonProxy.Instance:RecvPreReplyRollReward(data.charid, data.etype, data.param1)
  ServiceFuBenCmdProxy.super.RecvPreReplyRollRewardFubenCmd(self, data)
end

function ServiceFuBenCmdProxy:RecvTwelvePvpSyncCmd(data)
  TwelvePvPProxy.Instance:HandlePvpData(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncFullFireStateFubenCmd(data)
  helplog("SyncFullFireStateFubenCmd PVP火力全开,开关：", data.fullfire)
  PvpProxy.Instance:UpdateFreeFire(data.fullfire)
end

function ServiceFuBenCmdProxy:RecvRaidItemSyncCmd(data)
  TwelvePvPProxy.Instance:HandleItemSync(data.items, data.charid)
  self:Notify(ServiceEvent.FuBenCmdRaidItemSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvRaidItemUpdateCmd(data)
  TwelvePvPProxy.Instance:HandleItemUpdate(data.itemid, data.count, data.charid)
  self:Notify(ServiceEvent.FuBenCmdRaidItemUpdateCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncTriplePlayerModelFuBenCmd(data)
  TriplePlayerPvpProxy.Instance:HandleSyncTriplePlayerModel(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTriplePlayerModelFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncTripleEnterCountFuBenCmd(data)
  TriplePlayerPvpProxy.Instance:HandleSyncTripleEnterCount(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleEnterCountFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncTripleProfessionTimeFuBenCmd(data)
  TriplePlayerPvpProxy.Instance:HandleSyncTime(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleProfessionTimeFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTwelvePvpQuestQueryCmd(data)
  TwelvePvPProxy.Instance:HandleQueryQuest(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TwelvePVPWeeklyTaskPopUp
  })
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpQuestQueryCmd, data)
end

function ServiceFuBenCmdProxy:RecvTwelvePvpQueryGroupInfoCmd(data)
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    redlog("RecvTwelvePvpQueryGroupInfoCmd 当前不在12v12地图,不处理")
    return
  end
  TwelvePvPProxy.Instance:SetGroups(data.groupinfo)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TwelvePVP_PersonalInfoPopUp
  })
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpQueryGroupInfoCmd, data)
end

function ServiceFuBenCmdProxy:RecvTwelvePvpResultCmd(data)
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    redlog("RecvTwelvePvpResultCmd 当前不在12v12地图,不处理")
    return
  end
  local _twelveProxy = TwelvePvPProxy.Instance
  _twelveProxy:HandleResult(data.winteam)
  if data.groupinfo_cmd then
    _twelveProxy:SetGroups(data.groupinfo_cmd.groupinfo)
  end
  if data.camp_result_data then
    _twelveProxy:SetCampResult(data.camp_result_data)
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TwelvePVPResultPanel
  })
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpResultCmd, data)
end

function ServiceFuBenCmdProxy:RecvReliveCdFubenCmd(data)
  MyselfProxy.Instance:HandleRelieveFubenCd(data)
  self:Notify(ServiceEvent.FuBenCmdReliveCdFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTwelvePvpBuildingHpUpdateCmd(data)
  TwelvePvPProxy.Instance:HandleBuildingHpUpdate(data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, data)
end

function ServiceFuBenCmdProxy:RecvObserverAttachFubenCmd(data)
  PvpObserveProxy.Instance:HandleAttach(data)
  self:Notify(ServiceEvent.FuBenCmdObserverAttachFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvObserverSelectFubenCmd(data)
  PvpObserveProxy.Instance:HandleRecvSelectedId(data)
  self:Notify(ServiceEvent.FuBenCmdObserverSelectFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvObserverFlashFubenCmd(data)
  PvpObserveProxy.Instance:HandleFlashMove(data.x, data.y, data.z)
  self:Notify(ServiceEvent.FuBenCmdObserverFlashFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvObHpspUpdateFubenCmd(data)
  PvpObserveProxy.Instance:HandleObserverPlayerHpSpUpdate(data.updates)
end

function ServiceFuBenCmdProxy:RecvObPlayerOfflineFubenCmd(data)
  local charid = data.offline_char
  FunctionPvpObserver.Me():ObserverdPlayerOffline(charid)
  PvpObserveProxy.Instance:HandleObPlayerOffline(charid)
end

function ServiceFuBenCmdProxy:RecvObMoveCameraPrepareCmd(data)
  helplog("-----------运镜------服务器通知播放OB运镜")
  Game.MapManager:LaunchObSceneAnimation()
  self:Notify(ServiceEvent.FuBenCmdObMoveCameraPrepareCmd, data)
end

function ServiceFuBenCmdProxy:RecvRaidKillNumSyncCmd(data)
  PvpObserveProxy.Instance:HandleRaidKillSync(data)
  self:Notify(ServiceEvent.FuBenCmdRaidKillNumSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvTowerPrivateLayerInfo(data)
  redlog("Recv-->TowerPrivateLayerInfo")
  EndlessTowerProxy.Instance:RecvTowerPrivateLayerInfo(data)
  self:Notify(ServiceEvent.FuBenCmdTowerPrivateLayerInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvFubenResultNtf(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.FailView
  })
  self:Notify(ServiceEvent.FuBenCmdFubenResultNtf, data)
end

function ServiceFuBenCmdProxy:RecvResultSyncFubenCmd(data)
  redlog("RecvResultSyncFubenCmd一月副本结算")
  DungeonProxy.Instance:RecvResultSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdResultSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvEndTimeSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdEndTimeSyncFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTeamPwsStateSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvComodoPhaseFubenCmd(data)
  GroupRaidProxy.Instance:SetComodoRaidPhase(data and data.phase)
  self:Notify(ServiceEvent.FuBenCmdComodoPhaseFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryComodoTeamRaidStat(data)
  GroupRaidProxy.Instance:RecvQueryComodoTeamRaidStat(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ComodoRaidStatisticsView
  })
  self:Notify(ServiceEvent.FuBenCmdQueryComodoTeamRaidStat, data)
end

function ServiceFuBenCmdProxy:RecvMultiBossPhaseFubenCmd(data)
  GroupRaidProxy.Instance:SetMultiBossRaidPhase(data and data.boss_index)
  self:Notify(ServiceEvent.FuBenCmdMultiBossPhaseFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvQueryMultiBossRaidStat(data)
  GroupRaidProxy.Instance:RecvQueryMultiBossRaidStat(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MultiBossRaidStatView
  })
  self:Notify(ServiceEvent.FuBenCmdQueryMultiBossRaidStat, data)
end

function ServiceFuBenCmdProxy:RecvSyncPveRaidAchieveFubenCmd(data)
  PveEntranceProxy.Instance:HandleSyncPveRaidAchieveFubenCmd(data.achieveinfos)
  self:Notify(ServiceEvent.FuBenCmdSyncPveRaidAchieveFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvAddPveCardTimesFubenCmd(data)
  PveEntranceProxy.Instance:HandlePveCardTimes(data)
  self:Notify(ServiceEvent.FuBenCmdAddPveCardTimesFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncPveCardRewardTimesFubenCmd(data)
  PveEntranceProxy.Instance:HandlePveCardRewardTime(data.items)
  self:Notify(ServiceEvent.FuBenCmdSyncPveCardRewardTimesFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgPerfectStateUpdateFubenCmd(data)
  GvgProxy.Instance:RecvPerfectStateUpdate(data)
  self:Notify(ServiceEvent.FuBenCmdGvgPerfectStateUpdateFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncBossSceneInfo(data)
  DungeonProxy.Instance:SyncBossSceneInfo(data)
  self:Notify(ServiceEvent.FuBenCmdSyncBossSceneInfo, data)
end

function ServiceFuBenCmdProxy:RecvSyncEmotionFactorsFuBenCmd(data)
  DungeonProxy.Instance:RecvSyncEmotionFactorsFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncEmotionFactorsFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvTeamReliveCountFubenCmd(data)
  DungeonProxy.Instance:SetReviveCount(data.count, data.maxcount)
  self:Notify(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncUnlockRoomIDsFuBenCmd(data)
  DungeonProxy.Instance:SetUnlockRoomIDs(data.roomids)
  self:Notify(ServiceEvent.FuBenCmdSyncUnlockRoomIDsFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncVisitNpcInfo(data)
  QuestProxy.Instance:SyncVisitNpcInfo(data)
  self:Notify(ServiceEvent.FuBenCmdSyncVisitNpcInfo, data)
end

function ServiceFuBenCmdProxy:RecvSyncMonsterCountFuBenCmd(data)
  DungeonProxy.Instance:SetLeftMonsterCount(data.count)
  self:Notify(ServiceEvent.FuBenCmdSyncMonsterCountFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSkipAnimationFuBenCmd(data)
  Game.PlotStoryManager:DoSkip()
end

function ServiceFuBenCmdProxy:RecvEBFEventDataUpdateCmd(data)
  EndlessBattleDebug("[无尽战场] RecvEBFEventDataUpdateCmd")
  EndlessBattleDebugAll(data.datas)
  EndlessBattleFieldProxy.Instance:SyncEBFEventData(data.datas, data.all_sync)
  EndlessBattleGameProxy.Instance:HandleEventDataUpdate()
  self:Notify(ServiceEvent.FuBenCmdEBFEventDataUpdateCmd, data)
end

function ServiceFuBenCmdProxy:RecvEBFMiscDataUpdate(data)
  EndlessBattleDebug("[无尽战场] RecvEBFMiscDataUpdate")
  EndlessBattleDebugAll(data)
  EndlessBattleFieldProxy.Instance:SyncEBFState(data)
  EndlessBattleGameProxy.Instance:HandleMiscDataUpdate(data)
  self:Notify(ServiceEvent.FuBenCmdEBFMiscDataUpdate, data)
end

function ServiceFuBenCmdProxy:RecvOccupyPointDataUpdate(data)
  EndlessBattleDebug("[无尽战场] RecvOccupyPointDataUpdate")
  EndlessBattleDebugAll(data)
  EndlessBattleGameProxy.Instance:SyncOccupyPointData(data)
  self:Notify(ServiceEvent.FuBenCmdOccupyPointDataUpdate, data)
end

function ServiceFuBenCmdProxy:RecvQueryPvpStatCmd(data)
  EndlessBattleDebug("[无尽战场] RecvQueryPvpStatCmd")
  EndlessBattleFieldProxy.Instance:SyncEBFStatData(data.stats)
  self:Notify(ServiceEvent.FuBenCmdQueryPvpStatCmd, data)
end

function ServiceFuBenCmdProxy:RecvEBFKickTimeCmd(data)
  EndlessBattleDebug("[无尽战场] RecvEBFKickTimeCmd")
  EndlessBattleFieldProxy.Instance:SyncEBFKickTime(data.kick_time)
  self:Notify(ServiceEvent.FuBenCmdEBFKickTimeCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncStarArkInfoFuBenCmd(data)
  DungeonProxy.Instance:RecvSyncStarArkInfoFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncStarArkInfoFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncStarArkStatisticsFuBenCmd(data)
  DungeonProxy.Instance:RecvSyncStarArkStatisticsFuBenCmd(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.StarArkVictoryView,
    viewdata = data
  })
  self:Notify(ServiceEvent.FuBenCmdSyncStarArkStatisticsFuBenCmd, data)
end

local byteArray = {}

function ServiceFuBenCmdProxy:RecvSyncPassUserInfo(data)
  if data.data.data then
    if data.data.first then
      byteArray[data.branch] = ByteArray()
    end
    byteArray[data.branch]:AddMergeByte(Slua.ToBytes(data.data.data))
    if data.data.over then
      local info = {}
      PbMgr.DecodeMsgByName("Cmd.PassInfo", Slua.ToString(byteArray[data.branch]:MergeByte()), info)
      byteArray[data.branch] = nil
      DungeonProxy.Instance:UpdatePassUserEquipInfo(data.branch, info)
    end
  else
    DungeonProxy.Instance:UpdatePassUserEquipInfo(data.branch)
  end
  self:Notify(ServiceEvent.FuBenCmdSyncPassUserInfo, data)
end

function ServiceFuBenCmdProxy:RecvSyncTripleFireInfoFuBenCmd(data)
  redlog("RecvSyncTripleFireInfoFuBenCmd")
  PvpProxy.Instance:UpdateTripleCampInfo(data.camps)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleFireInfoFuBenCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdSyncTripleFireInfoFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncTripleComboKillFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleComboKillFuBenCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdSyncTripleComboKillFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncTripleCampInfoFuBenCmd(data)
  PvpProxy.Instance:InitTripleCampInfo(data)
  TriplePlayerPvpProxy:InitializeRelaxFlag(data.isrelax)
  if data.endtime and data.endtime > 0 then
    self:Notify(ServiceEvent.FuBenCmdSyncTripleCampInfoFuBenCmd, data)
  end
end

function ServiceFuBenCmdProxy:RecvSyncTripleFightingInfoFuBenCmd(data)
  redlog("RecvSyncTripleFightingInfoFuBenCmd")
  PvpProxy.Instance:UpdateTripleCampInfo(data.camps)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleFightingInfoFuBenCmd, data)
end

function ServiceFuBenCmdProxy:RecvAstralInfoSyncCmd(data)
  AstralProxy.Instance:SyncAstralRoundInfo(data)
  self:Notify(ServiceEvent.FuBenCmdAstralInfoSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvSyncStartFightStateCmd(data)
  FunctionPve.Me():SyncStartFightState(data.barstate)
  self:Notify(ServiceEvent.FuBenCmdSyncStartFightStateCmd, data)
end

function ServiceFuBenCmdProxy:RecvGvgMvpInfoUpdateCmd(data)
  GvgProxy.Instance:HandleMvpUpdate(data.hp_per, data.state)
  self:Notify(ServiceEvent.FuBenCmdGvgMvpInfoUpdateCmd, data)
end

function ServiceFuBenCmdProxy:RecvAstralPrayBranchSyncCmd(data)
  AstralProxy.Instance:SyncAstralPrayBranchInfo(data.groups)
  self:Notify(ServiceEvent.FuBenCmdAstralPrayBranchSyncCmd, data)
end

function ServiceFuBenCmdProxy:RecvSTISyncSkillCmd(data)
  redlog("ServiceFuBenCmdProxy:RecvSTISyncSkillCmd", data.current_skills and #data.current_skills or "nil")
  RoguelikeSkillProxy.Instance:UpdateCurrentSkills(data.current_skills)
  self:Notify(ServiceEvent.FuBenCmdSTISyncSkillCmd, data)
end

function ServiceFuBenCmdProxy:RecvSTISyncAvailableUpgradeNumberCmd(data)
  RoguelikeSkillProxy.Instance:UpdateRandomSkillPoint(data.available_upgrade_number)
  self:Notify(ServiceEvent.FuBenCmdSTISyncAvailableUpgradeNumberCmd, data)
end

function ServiceFuBenCmdProxy:RecvSTIRetUpgradeOptionsCmd(data)
  redlog("ServiceFuBenCmdProxy:RecvSTIRetUpgradeOptionsCmd", data.skill_options and #data.skill_options or "nil", data.available_refresh_all_skill_number)
  RoguelikeSkillProxy.Instance:UpdateAlternativeSkillList(data.skill_options, data.available_refresh_all_skill_number)
  self:Notify(ServiceEvent.FuBenCmdSTIRetUpgradeOptionsCmd, data)
end
