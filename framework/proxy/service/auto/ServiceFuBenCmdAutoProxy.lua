ServiceFuBenCmdAutoProxy = class("ServiceFuBenCmdAutoProxy", ServiceProxy)
ServiceFuBenCmdAutoProxy.Instance = nil
ServiceFuBenCmdAutoProxy.NAME = "ServiceFuBenCmdAutoProxy"

function ServiceFuBenCmdAutoProxy:ctor(proxyName)
  if ServiceFuBenCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceFuBenCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceFuBenCmdAutoProxy.Instance = self
  end
end

function ServiceFuBenCmdAutoProxy:Init()
end

function ServiceFuBenCmdAutoProxy:onRegister()
  self:Listen(11, 1, function(data)
    self:RecvTrackFuBenUserCmd(data)
  end)
  self:Listen(11, 2, function(data)
    self:RecvFailFuBenUserCmd(data)
  end)
  self:Listen(11, 3, function(data)
    self:RecvLeaveFuBenUserCmd(data)
  end)
  self:Listen(11, 4, function(data)
    self:RecvSuccessFuBenUserCmd(data)
  end)
  self:Listen(11, 5, function(data)
    self:RecvWorldStageUserCmd(data)
  end)
  self:Listen(11, 6, function(data)
    self:RecvStageStepUserCmd(data)
  end)
  self:Listen(11, 7, function(data)
    self:RecvStartStageUserCmd(data)
  end)
  self:Listen(11, 8, function(data)
    self:RecvGetRewardStageUserCmd(data)
  end)
  self:Listen(11, 9, function(data)
    self:RecvStageStepStarUserCmd(data)
  end)
  self:Listen(11, 11, function(data)
    self:RecvMonsterCountUserCmd(data)
  end)
  self:Listen(11, 12, function(data)
    self:RecvFubenStepSyncCmd(data)
  end)
  self:Listen(11, 13, function(data)
    self:RecvFuBenProgressSyncCmd(data)
  end)
  self:Listen(11, 15, function(data)
    self:RecvFuBenClearInfoCmd(data)
  end)
  self:Listen(11, 16, function(data)
    self:RecvUserGuildRaidFubenCmd(data)
  end)
  self:Listen(11, 17, function(data)
    self:RecvGuildGateOptCmd(data)
  end)
  self:Listen(11, 18, function(data)
    self:RecvGuildFireInfoFubenCmd(data)
  end)
  self:Listen(11, 19, function(data)
    self:RecvGuildFireStopFubenCmd(data)
  end)
  self:Listen(11, 20, function(data)
    self:RecvGuildFireDangerFubenCmd(data)
  end)
  self:Listen(11, 21, function(data)
    self:RecvGuildFireMetalHpFubenCmd(data)
  end)
  self:Listen(11, 22, function(data)
    self:RecvGuildFireCalmFubenCmd(data)
  end)
  self:Listen(11, 23, function(data)
    self:RecvGuildFireNewDefFubenCmd(data)
  end)
  self:Listen(11, 24, function(data)
    self:RecvGuildFireRestartFubenCmd(data)
  end)
  self:Listen(11, 25, function(data)
    self:RecvGuildFireStatusFubenCmd(data)
  end)
  self:Listen(11, 26, function(data)
    self:RecvGvgDataSyncCmd(data)
  end)
  self:Listen(11, 27, function(data)
    self:RecvGvgDataUpdateCmd(data)
  end)
  self:Listen(11, 28, function(data)
    self:RecvGvgDefNameChangeFubenCmd(data)
  end)
  self:Listen(11, 29, function(data)
    self:RecvSyncMvpInfoFubenCmd(data)
  end)
  self:Listen(11, 30, function(data)
    self:RecvBossDieFubenCmd(data)
  end)
  self:Listen(11, 31, function(data)
    self:RecvUpdateUserNumFubenCmd(data)
  end)
  self:Listen(11, 32, function(data)
    self:RecvSuperGvgSyncFubenCmd(data)
  end)
  self:Listen(11, 33, function(data)
    self:RecvGvgTowerUpdateFubenCmd(data)
  end)
  self:Listen(11, 39, function(data)
    self:RecvGvgMetalDieFubenCmd(data)
  end)
  self:Listen(11, 34, function(data)
    self:RecvGvgCrystalUpdateFubenCmd(data)
  end)
  self:Listen(11, 35, function(data)
    self:RecvQueryGvgTowerInfoFubenCmd(data)
  end)
  self:Listen(11, 36, function(data)
    self:RecvSuperGvgRewardInfoFubenCmd(data)
  end)
  self:Listen(11, 37, function(data)
    self:RecvSuperGvgQueryUserDataFubenCmd(data)
  end)
  self:Listen(11, 38, function(data)
    self:RecvMvpBattleReportFubenCmd(data)
  end)
  self:Listen(11, 40, function(data)
    self:RecvInviteSummonBossFubenCmd(data)
  end)
  self:Listen(11, 41, function(data)
    self:RecvReplySummonBossFubenCmd(data)
  end)
  self:Listen(11, 42, function(data)
    self:RecvQueryTeamPwsUserInfoFubenCmd(data)
  end)
  self:Listen(11, 43, function(data)
    self:RecvTeamPwsReportFubenCmd(data)
  end)
  self:Listen(11, 44, function(data)
    self:RecvTeamPwsInfoSyncFubenCmd(data)
  end)
  self:Listen(11, 47, function(data)
    self:RecvUpdateTeamPwsInfoFubenCmd(data)
  end)
  self:Listen(11, 45, function(data)
    self:RecvSelectTeamPwsMagicFubenCmd(data)
  end)
  self:Listen(11, 48, function(data)
    self:RecvExitMapFubenCmd(data)
  end)
  self:Listen(11, 49, function(data)
    self:RecvBeginFireFubenCmd(data)
  end)
  self:Listen(11, 50, function(data)
    self:RecvTeamExpReportFubenCmd(data)
  end)
  self:Listen(11, 51, function(data)
    self:RecvBuyExpRaidItemFubenCmd(data)
  end)
  self:Listen(11, 52, function(data)
    self:RecvTeamExpSyncFubenCmd(data)
  end)
  self:Listen(11, 53, function(data)
    self:RecvTeamReliveCountFubenCmd(data)
  end)
  self:Listen(11, 54, function(data)
    self:RecvTeamGroupRaidUpdateChipNum(data)
  end)
  self:Listen(11, 55, function(data)
    self:RecvQueryTeamGroupRaidUserInfo(data)
  end)
  self:Listen(11, 57, function(data)
    self:RecvGroupRaidStateSyncFuBenCmd(data)
  end)
  self:Listen(11, 56, function(data)
    self:RecvTeamExpQueryInfoFubenCmd(data)
  end)
  self:Listen(11, 60, function(data)
    self:RecvUpdateGroupRaidFourthShowData(data)
  end)
  self:Listen(11, 59, function(data)
    self:RecvQueryGroupRaidFourthShowData(data)
  end)
  self:Listen(11, 61, function(data)
    self:RecvGroupRaidFourthGoOuterCmd(data)
  end)
  self:Listen(11, 62, function(data)
    self:RecvRaidStageSyncFubenCmd(data)
  end)
  self:Listen(11, 63, function(data)
    self:RecvThanksGivingMonsterFuBenCmd(data)
  end)
  self:Listen(11, 58, function(data)
    self:RecvKumamotoOperFubenCmd(data)
  end)
  self:Listen(11, 64, function(data)
    self:RecvOthelloPointOccupyPowerFubenCmd(data)
  end)
  self:Listen(11, 65, function(data)
    self:RecvOthelloInfoSyncFubenCmd(data)
  end)
  self:Listen(11, 66, function(data)
    self:RecvQueryOthelloUserInfoFubenCmd(data)
  end)
  self:Listen(11, 67, function(data)
    self:RecvOthelloReportFubenCmd(data)
  end)
  self:Listen(11, 68, function(data)
    self:RecvRoguelikeUnlockSceneSync(data)
  end)
  self:Listen(11, 69, function(data)
    self:RecvTransferFightChooseFubenCmd(data)
  end)
  self:Listen(11, 70, function(data)
    self:RecvTransferFightRankFubenCmd(data)
  end)
  self:Listen(11, 71, function(data)
    self:RecvTransferFightEndFubenCmd(data)
  end)
  self:Listen(11, 82, function(data)
    self:RecvInviteRollRewardFubenCmd(data)
  end)
  self:Listen(11, 83, function(data)
    self:RecvReplyRollRewardFubenCmd(data)
  end)
  self:Listen(11, 84, function(data)
    self:RecvTeamRollStatusFuBenCmd(data)
  end)
  self:Listen(11, 85, function(data)
    self:RecvPreReplyRollRewardFubenCmd(data)
  end)
  self:Listen(11, 72, function(data)
    self:RecvTwelvePvpSyncCmd(data)
  end)
  self:Listen(11, 73, function(data)
    self:RecvRaidItemSyncCmd(data)
  end)
  self:Listen(11, 74, function(data)
    self:RecvRaidItemUpdateCmd(data)
  end)
  self:Listen(11, 81, function(data)
    self:RecvTwelvePvpUseItemCmd(data)
  end)
  self:Listen(11, 75, function(data)
    self:RecvRaidShopUpdateCmd(data)
  end)
  self:Listen(11, 76, function(data)
    self:RecvTwelvePvpQuestQueryCmd(data)
  end)
  self:Listen(11, 77, function(data)
    self:RecvTwelvePvpQueryGroupInfoCmd(data)
  end)
  self:Listen(11, 78, function(data)
    self:RecvTwelvePvpResultCmd(data)
  end)
  self:Listen(11, 79, function(data)
    self:RecvTwelvePvpBuildingHpUpdateCmd(data)
  end)
  self:Listen(11, 80, function(data)
    self:RecvTwelvePvpUIOperCmd(data)
  end)
  self:Listen(11, 86, function(data)
    self:RecvReliveCdFubenCmd(data)
  end)
  self:Listen(11, 87, function(data)
    self:RecvPosSyncFubenCmd(data)
  end)
  self:Listen(11, 88, function(data)
    self:RecvReqEnterTowerPrivate(data)
  end)
  self:Listen(11, 89, function(data)
    self:RecvTowerPrivateLayerInfo(data)
  end)
  self:Listen(11, 90, function(data)
    self:RecvTowerPrivateLayerCountdownNtf(data)
  end)
  self:Listen(11, 91, function(data)
    self:RecvFubenResultNtf(data)
  end)
  self:Listen(11, 92, function(data)
    self:RecvEndTimeSyncFubenCmd(data)
  end)
  self:Listen(11, 93, function(data)
    self:RecvResultSyncFubenCmd(data)
  end)
  self:Listen(11, 97, function(data)
    self:RecvComodoPhaseFubenCmd(data)
  end)
  self:Listen(11, 98, function(data)
    self:RecvQueryComodoTeamRaidStat(data)
  end)
  self:Listen(11, 99, function(data)
    self:RecvTeamPwsStateSyncFubenCmd(data)
  end)
  self:Listen(11, 100, function(data)
    self:RecvObserverFlashFubenCmd(data)
  end)
  self:Listen(11, 101, function(data)
    self:RecvObserverAttachFubenCmd(data)
  end)
  self:Listen(11, 102, function(data)
    self:RecvObserverSelectFubenCmd(data)
  end)
  self:Listen(11, 104, function(data)
    self:RecvObHpspUpdateFubenCmd(data)
  end)
  self:Listen(11, 105, function(data)
    self:RecvObPlayerOfflineFubenCmd(data)
  end)
  self:Listen(11, 106, function(data)
    self:RecvMultiBossPhaseFubenCmd(data)
  end)
  self:Listen(11, 107, function(data)
    self:RecvQueryMultiBossRaidStat(data)
  end)
  self:Listen(11, 108, function(data)
    self:RecvObMoveCameraPrepareCmd(data)
  end)
  self:Listen(11, 109, function(data)
    self:RecvObCameraMoveEndCmd(data)
  end)
  self:Listen(11, 110, function(data)
    self:RecvRaidKillNumSyncCmd(data)
  end)
  self:Listen(11, 118, function(data)
    self:RecvSyncPvePassInfoFubenCmd(data)
  end)
  self:Listen(11, 126, function(data)
    self:RecvSyncPveRaidAchieveFubenCmd(data)
  end)
  self:Listen(11, 127, function(data)
    self:RecvQuickFinishCrackRaidFubenCmd(data)
  end)
  self:Listen(11, 128, function(data)
    self:RecvPickupPveRaidAchieveFubenCmd(data)
  end)
  self:Listen(11, 119, function(data)
    self:RecvGvgPointUpdateFubenCmd(data)
  end)
  self:Listen(11, 122, function(data)
    self:RecvGvgRaidStateUpdateFubenCmd(data)
  end)
  self:Listen(11, 129, function(data)
    self:RecvAddPveCardTimesFubenCmd(data)
  end)
  self:Listen(11, 130, function(data)
    self:RecvSyncPveCardOpenStateFubenCmd(data)
  end)
  self:Listen(11, 131, function(data)
    self:RecvQuickFinishPveRaidFubenCmd(data)
  end)
  self:Listen(11, 132, function(data)
    self:RecvSyncPveCardRewardTimesFubenCmd(data)
  end)
  self:Listen(11, 133, function(data)
    self:RecvGvgPerfectStateUpdateFubenCmd(data)
  end)
  self:Listen(11, 136, function(data)
    self:RecvQueryElementRaidStat(data)
  end)
  self:Listen(11, 137, function(data)
    self:RecvSyncEmotionFactorsFuBenCmd(data)
  end)
  self:Listen(11, 134, function(data)
    self:RecvSyncBossSceneInfo(data)
  end)
  self:Listen(11, 139, function(data)
    self:RecvSyncUnlockRoomIDsFuBenCmd(data)
  end)
  self:Listen(11, 138, function(data)
    self:RecvSyncVisitNpcInfo(data)
  end)
  self:Listen(11, 140, function(data)
    self:RecvSyncMonsterCountFuBenCmd(data)
  end)
  self:Listen(11, 141, function(data)
    self:RecvSkipAnimationFuBenCmd(data)
  end)
  self:Listen(11, 135, function(data)
    self:RecvResetRaidFubenCmd(data)
  end)
  self:Listen(11, 142, function(data)
    self:RecvSyncStarArkInfoFuBenCmd(data)
  end)
  self:Listen(11, 143, function(data)
    self:RecvSyncStarArkStatisticsFuBenCmd(data)
  end)
  self:Listen(11, 144, function(data)
    self:RecvOpenNtfFuBenCmd(data)
  end)
  self:Listen(11, 145, function(data)
    self:RecvRoadblocksChangeFubenCmd(data)
  end)
  self:Listen(11, 152, function(data)
    self:RecvSyncPassUserInfo(data)
  end)
  self:Listen(11, 146, function(data)
    self:RecvSyncTripleFireInfoFuBenCmd(data)
  end)
  self:Listen(11, 147, function(data)
    self:RecvSyncTripleComboKillFuBenCmd(data)
  end)
  self:Listen(11, 148, function(data)
    self:RecvSyncTriplePlayerModelFuBenCmd(data)
  end)
  self:Listen(11, 149, function(data)
    self:RecvSyncTripleProfessionTimeFuBenCmd(data)
  end)
  self:Listen(11, 150, function(data)
    self:RecvSyncTripleCampInfoFuBenCmd(data)
  end)
  self:Listen(11, 151, function(data)
    self:RecvSyncTripleEnterCountFuBenCmd(data)
  end)
  self:Listen(11, 153, function(data)
    self:RecvChooseCurProfessionFuBenCmd(data)
  end)
  self:Listen(11, 154, function(data)
    self:RecvSyncTripleFightingInfoFuBenCmd(data)
  end)
  self:Listen(11, 155, function(data)
    self:RecvSyncFullFireStateFubenCmd(data)
  end)
  self:Listen(11, 156, function(data)
    self:RecvEBFEventDataUpdateCmd(data)
  end)
  self:Listen(11, 157, function(data)
    self:RecvEBFMiscDataUpdate(data)
  end)
  self:Listen(11, 158, function(data)
    self:RecvOccupyPointDataUpdate(data)
  end)
  self:Listen(11, 159, function(data)
    self:RecvQueryPvpStatCmd(data)
  end)
  self:Listen(11, 160, function(data)
    self:RecvEBFKickTimeCmd(data)
  end)
  self:Listen(11, 161, function(data)
    self:RecvEBFContinueCmd(data)
  end)
  self:Listen(11, 162, function(data)
    self:RecvEBFEventAreaUpdateCmd(data)
  end)
  self:Listen(11, 163, function(data)
    self:RecvAstralInfoSyncCmd(data)
  end)
  self:Listen(11, 164, function(data)
    self:RecvGvgMvpInfoUpdateCmd(data)
  end)
  self:Listen(11, 165, function(data)
    self:RecvAstralPrayBranchSyncCmd(data)
  end)
  self:Listen(11, 166, function(data)
    self:RecvSyncStartFightStateCmd(data)
  end)
  self:Listen(11, 167, function(data)
    self:RecvSyncGvgFightPointCmd(data)
  end)
  self:Listen(11, 168, function(data)
    self:RecvSyncGvgLeaderPosCmd(data)
  end)
  self:Listen(11, 169, function(data)
    self:RecvSTISyncScoreCmd(data)
  end)
  self:Listen(11, 170, function(data)
    self:RecvSTISyncSkillCmd(data)
  end)
  self:Listen(11, 171, function(data)
    self:RecvSTISyncAvailableUpgradeNumberCmd(data)
  end)
  self:Listen(11, 172, function(data)
    self:RecvSTIGetUpgradeOptionsCmd(data)
  end)
  self:Listen(11, 173, function(data)
    self:RecvSTIRetUpgradeOptionsCmd(data)
  end)
  self:Listen(11, 174, function(data)
    self:RecvSTIExecSkillUpgradeCmd(data)
  end)
  self:Listen(11, 175, function(data)
    self:RecvSyncSpaceTimeIllusionInfoFuBenCmd(data)
  end)
  self:Listen(11, 176, function(data)
    self:RecvSyncSpaceTimeIllusionExpLevelFuBenCmd(data)
  end)
  self:Listen(11, 177, function(data)
    self:RecvSTIRefreshUpgradeOptionsCmd(data)
  end)
  self:Listen(11, 178, function(data)
    self:RecvSTIDropSkillCmd(data)
  end)
  self:Listen(11, 179, function(data)
    self:RecvFairyTaleRaidSyncCmd(data)
  end)
  self:Listen(11, 180, function(data)
    self:RecvRaidStartFightCmd(data)
  end)
  self:Listen(11, 182, function(data)
    self:RecvFairyTaleRaidRewardSyncCmd(data)
  end)
  self:Listen(11, 183, function(data)
    self:RecvFairyTaleRaidGetRewardCmd(data)
  end)
  self:Listen(11, 184, function(data)
    self:RecvSyncMemoryEquipRewardInfo(data)
  end)
  self:Listen(11, 185, function(data)
    self:RecvChooseMemoryEquipRewardInfo(data)
  end)
  self:Listen(11, 181, function(data)
    self:RecvGvgDateBattleInfoSyncCmd(data)
  end)
end

function ServiceFuBenCmdAutoProxy:CallTrackFuBenUserCmd(data, dmapid, endtime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TrackFuBenUserCmd()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    if dmapid ~= nil then
      msg.dmapid = dmapid
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TrackFuBenUserCmd.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    if dmapid ~= nil then
      msgParam.dmapid = dmapid
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFailFuBenUserCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FailFuBenUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FailFuBenUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallLeaveFuBenUserCmd(mapid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.LeaveFuBenUserCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LeaveFuBenUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSuccessFuBenUserCmd(type, param1, param2, param3, param4)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SuccessFuBenUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    if param2 ~= nil then
      msg.param2 = param2
    end
    if param3 ~= nil then
      msg.param3 = param3
    end
    if param4 ~= nil then
      msg.param4 = param4
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SuccessFuBenUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    if param2 ~= nil then
      msgParam.param2 = param2
    end
    if param3 ~= nil then
      msgParam.param3 = param3
    end
    if param4 ~= nil then
      msgParam.param4 = param4
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallWorldStageUserCmd(list, curinfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.WorldStageUserCmd()
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
    if curinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.curinfo == nil then
        msg.curinfo = {}
      end
      for i = 1, #curinfo do
        table.insert(msg.curinfo, curinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WorldStageUserCmd.id
    local msgParam = {}
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
    if curinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.curinfo == nil then
        msgParam.curinfo = {}
      end
      for i = 1, #curinfo do
        table.insert(msgParam.curinfo, curinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallStageStepUserCmd(stageid, normalist, hardlist)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.StageStepUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
    if normalist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.normalist == nil then
        msg.normalist = {}
      end
      for i = 1, #normalist do
        table.insert(msg.normalist, normalist[i])
      end
    end
    if hardlist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.hardlist == nil then
        msg.hardlist = {}
      end
      for i = 1, #hardlist do
        table.insert(msg.hardlist, hardlist[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StageStepUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
    if normalist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.normalist == nil then
        msgParam.normalist = {}
      end
      for i = 1, #normalist do
        table.insert(msgParam.normalist, normalist[i])
      end
    end
    if hardlist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.hardlist == nil then
        msgParam.hardlist = {}
      end
      for i = 1, #hardlist do
        table.insert(msgParam.hardlist, hardlist[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallStartStageUserCmd(stageid, stepid, type)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.StartStageUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
    if stepid ~= nil then
      msg.stepid = stepid
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartStageUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
    if stepid ~= nil then
      msgParam.stepid = stepid
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGetRewardStageUserCmd(stageid, starid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GetRewardStageUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
    if starid ~= nil then
      msg.starid = starid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetRewardStageUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
    if starid ~= nil then
      msgParam.starid = starid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallStageStepStarUserCmd(stageid, stepid, star, type)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.StageStepStarUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
    if stepid ~= nil then
      msg.stepid = stepid
    end
    if star ~= nil then
      msg.star = star
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StageStepStarUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
    if stepid ~= nil then
      msgParam.stepid = stepid
    end
    if star ~= nil then
      msgParam.star = star
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallMonsterCountUserCmd(num)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.MonsterCountUserCmd()
    if num ~= nil then
      msg.num = num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MonsterCountUserCmd.id
    local msgParam = {}
    if num ~= nil then
      msgParam.num = num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFubenStepSyncCmd(id, del, groupid, config, uniqueid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FubenStepSyncCmd()
    if id ~= nil then
      msg.id = id
    end
    if del ~= nil then
      msg.del = del
    end
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if config ~= nil and config.RaidID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.RaidID = config.RaidID
    end
    if config ~= nil and config.starID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.starID = config.starID
    end
    if config ~= nil and config.Auto ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.Auto = config.Auto
    end
    if config ~= nil and config.WhetherTrace ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.WhetherTrace = config.WhetherTrace
    end
    if config ~= nil and config.FinishJump ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.FinishJump = config.FinishJump
    end
    if config ~= nil and config.FailJump ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.FailJump = config.FailJump
    end
    if config ~= nil and config.SubStep ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.SubStep = config.SubStep
    end
    if config ~= nil and config.DescInfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.DescInfo = config.DescInfo
    end
    if config ~= nil and config.Content ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.Content = config.Content
    end
    if config ~= nil and config.TraceInfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.TraceInfo = config.TraceInfo
    end
    if config ~= nil and config.params.params ~= nil then
      if msg.config.params == nil then
        msg.config.params = {}
      end
      if msg.config.params.params == nil then
        msg.config.params.params = {}
      end
      for i = 1, #config.params.params do
        table.insert(msg.config.params.params, config.params.params[i])
      end
    end
    if config ~= nil and config.ExtraJump.params ~= nil then
      if msg.config.ExtraJump == nil then
        msg.config.ExtraJump = {}
      end
      if msg.config.ExtraJump.params == nil then
        msg.config.ExtraJump.params = {}
      end
      for i = 1, #config.ExtraJump.params do
        table.insert(msg.config.ExtraJump.params, config.ExtraJump.params[i])
      end
    end
    if uniqueid ~= nil then
      msg.uniqueid = uniqueid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FubenStepSyncCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if del ~= nil then
      msgParam.del = del
    end
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if config ~= nil and config.RaidID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.RaidID = config.RaidID
    end
    if config ~= nil and config.starID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.starID = config.starID
    end
    if config ~= nil and config.Auto ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.Auto = config.Auto
    end
    if config ~= nil and config.WhetherTrace ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.WhetherTrace = config.WhetherTrace
    end
    if config ~= nil and config.FinishJump ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.FinishJump = config.FinishJump
    end
    if config ~= nil and config.FailJump ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.FailJump = config.FailJump
    end
    if config ~= nil and config.SubStep ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.SubStep = config.SubStep
    end
    if config ~= nil and config.DescInfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.DescInfo = config.DescInfo
    end
    if config ~= nil and config.Content ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.Content = config.Content
    end
    if config ~= nil and config.TraceInfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.TraceInfo = config.TraceInfo
    end
    if config ~= nil and config.params.params ~= nil then
      if msgParam.config.params == nil then
        msgParam.config.params = {}
      end
      if msgParam.config.params.params == nil then
        msgParam.config.params.params = {}
      end
      for i = 1, #config.params.params do
        table.insert(msgParam.config.params.params, config.params.params[i])
      end
    end
    if config ~= nil and config.ExtraJump.params ~= nil then
      if msgParam.config.ExtraJump == nil then
        msgParam.config.ExtraJump = {}
      end
      if msgParam.config.ExtraJump.params == nil then
        msgParam.config.ExtraJump.params = {}
      end
      for i = 1, #config.ExtraJump.params do
        table.insert(msgParam.config.ExtraJump.params, config.ExtraJump.params[i])
      end
    end
    if uniqueid ~= nil then
      msgParam.uniqueid = uniqueid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFuBenProgressSyncCmd(id, progress, starid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FuBenProgressSyncCmd()
    if id ~= nil then
      msg.id = id
    end
    if progress ~= nil then
      msg.progress = progress
    end
    if starid ~= nil then
      msg.starid = starid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FuBenProgressSyncCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if progress ~= nil then
      msgParam.progress = progress
    end
    if starid ~= nil then
      msgParam.starid = starid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFuBenClearInfoCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FuBenClearInfoCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FuBenClearInfoCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallUserGuildRaidFubenCmd(gatedata)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.UserGuildRaidFubenCmd()
    if gatedata ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gatedata == nil then
        msg.gatedata = {}
      end
      for i = 1, #gatedata do
        table.insert(msg.gatedata, gatedata[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserGuildRaidFubenCmd.id
    local msgParam = {}
    if gatedata ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gatedata == nil then
        msgParam.gatedata = {}
      end
      for i = 1, #gatedata do
        table.insert(msgParam.gatedata, gatedata[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildGateOptCmd(gatenpcid, opt, uplocklevel)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildGateOptCmd()
    if gatenpcid ~= nil then
      msg.gatenpcid = gatenpcid
    end
    if opt ~= nil then
      msg.opt = opt
    end
    if uplocklevel ~= nil then
      msg.uplocklevel = uplocklevel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildGateOptCmd.id
    local msgParam = {}
    if gatenpcid ~= nil then
      msgParam.gatenpcid = gatenpcid
    end
    if opt ~= nil then
      msgParam.opt = opt
    end
    if uplocklevel ~= nil then
      msgParam.uplocklevel = uplocklevel
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireInfoFubenCmd(raidstate, def_guildid, endfire_time, metal_hpper, calm_time, def_guildname, points, my_smallmetal_cnt, perfect_time, metal_god, perfect, roadblock, gvg_group, mvp_hp_per, mvp_state)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireInfoFubenCmd()
    if raidstate ~= nil then
      msg.raidstate = raidstate
    end
    if def_guildid ~= nil then
      msg.def_guildid = def_guildid
    end
    if endfire_time ~= nil then
      msg.endfire_time = endfire_time
    end
    if metal_hpper ~= nil then
      msg.metal_hpper = metal_hpper
    end
    if calm_time ~= nil then
      msg.calm_time = calm_time
    end
    if def_guildname ~= nil then
      msg.def_guildname = def_guildname
    end
    if points ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.points == nil then
        msg.points = {}
      end
      for i = 1, #points do
        table.insert(msg.points, points[i])
      end
    end
    if my_smallmetal_cnt ~= nil then
      msg.my_smallmetal_cnt = my_smallmetal_cnt
    end
    if perfect_time ~= nil and perfect_time.pause ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.perfect_time == nil then
        msg.perfect_time = {}
      end
      msg.perfect_time.pause = perfect_time.pause
    end
    if perfect_time ~= nil and perfect_time.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.perfect_time == nil then
        msg.perfect_time = {}
      end
      msg.perfect_time.time = perfect_time.time
    end
    if metal_god ~= nil then
      msg.metal_god = metal_god
    end
    if perfect ~= nil then
      msg.perfect = perfect
    end
    if roadblock ~= nil then
      msg.roadblock = roadblock
    end
    if gvg_group ~= nil then
      msg.gvg_group = gvg_group
    end
    if mvp_hp_per ~= nil then
      msg.mvp_hp_per = mvp_hp_per
    end
    if mvp_state ~= nil then
      msg.mvp_state = mvp_state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireInfoFubenCmd.id
    local msgParam = {}
    if raidstate ~= nil then
      msgParam.raidstate = raidstate
    end
    if def_guildid ~= nil then
      msgParam.def_guildid = def_guildid
    end
    if endfire_time ~= nil then
      msgParam.endfire_time = endfire_time
    end
    if metal_hpper ~= nil then
      msgParam.metal_hpper = metal_hpper
    end
    if calm_time ~= nil then
      msgParam.calm_time = calm_time
    end
    if def_guildname ~= nil then
      msgParam.def_guildname = def_guildname
    end
    if points ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.points == nil then
        msgParam.points = {}
      end
      for i = 1, #points do
        table.insert(msgParam.points, points[i])
      end
    end
    if my_smallmetal_cnt ~= nil then
      msgParam.my_smallmetal_cnt = my_smallmetal_cnt
    end
    if perfect_time ~= nil and perfect_time.pause ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.perfect_time == nil then
        msgParam.perfect_time = {}
      end
      msgParam.perfect_time.pause = perfect_time.pause
    end
    if perfect_time ~= nil and perfect_time.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.perfect_time == nil then
        msgParam.perfect_time = {}
      end
      msgParam.perfect_time.time = perfect_time.time
    end
    if metal_god ~= nil then
      msgParam.metal_god = metal_god
    end
    if perfect ~= nil then
      msgParam.perfect = perfect
    end
    if roadblock ~= nil then
      msgParam.roadblock = roadblock
    end
    if gvg_group ~= nil then
      msgParam.gvg_group = gvg_group
    end
    if mvp_hp_per ~= nil then
      msgParam.mvp_hp_per = mvp_hp_per
    end
    if mvp_state ~= nil then
      msgParam.mvp_state = mvp_state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireStopFubenCmd(result)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireStopFubenCmd()
    if msg == nil then
      msg = {}
    end
    msg.result = result
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireStopFubenCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.result = result
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireDangerFubenCmd(danger, danger_time)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireDangerFubenCmd()
    if danger ~= nil then
      msg.danger = danger
    end
    if danger_time ~= nil then
      msg.danger_time = danger_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireDangerFubenCmd.id
    local msgParam = {}
    if danger ~= nil then
      msgParam.danger = danger
    end
    if danger_time ~= nil then
      msgParam.danger_time = danger_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireMetalHpFubenCmd(hpper, god)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireMetalHpFubenCmd()
    if hpper ~= nil then
      msg.hpper = hpper
    end
    if god ~= nil then
      msg.god = god
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireMetalHpFubenCmd.id
    local msgParam = {}
    if hpper ~= nil then
      msgParam.hpper = hpper
    end
    if god ~= nil then
      msgParam.god = god
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireCalmFubenCmd(calm)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireCalmFubenCmd()
    if calm ~= nil then
      msg.calm = calm
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireCalmFubenCmd.id
    local msgParam = {}
    if calm ~= nil then
      msgParam.calm = calm
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireNewDefFubenCmd(guildid, guildname)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireNewDefFubenCmd()
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if guildname ~= nil then
      msg.guildname = guildname
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireNewDefFubenCmd.id
    local msgParam = {}
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if guildname ~= nil then
      msgParam.guildname = guildname
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireRestartFubenCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireRestartFubenCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireRestartFubenCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGuildFireStatusFubenCmd(open, starttime, cityid, cityopen)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GuildFireStatusFubenCmd()
    if open ~= nil then
      msg.open = open
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if msg == nil then
      msg = {}
    end
    msg.cityid = cityid
    if cityopen ~= nil then
      msg.cityopen = cityopen
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildFireStatusFubenCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.cityid = cityid
    if cityopen ~= nil then
      msgParam.cityopen = cityopen
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgDataSyncCmd(datas, citytype)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgDataSyncCmd()
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
    if citytype ~= nil then
      msg.citytype = citytype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgDataSyncCmd.id
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
    if citytype ~= nil then
      msgParam.citytype = citytype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgDataUpdateCmd(data)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgDataUpdateCmd()
    if data ~= nil and data.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.type = data.type
    end
    if data ~= nil and data.value ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.value = data.value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgDataUpdateCmd.id
    local msgParam = {}
    if data ~= nil and data.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.type = data.type
    end
    if data ~= nil and data.value ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.value = data.value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgDefNameChangeFubenCmd(newname)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgDefNameChangeFubenCmd()
    if msg == nil then
      msg = {}
    end
    msg.newname = newname
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgDefNameChangeFubenCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.newname = newname
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncMvpInfoFubenCmd(usernum, liveboss, dieboss)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncMvpInfoFubenCmd()
    if usernum ~= nil then
      msg.usernum = usernum
    end
    if liveboss ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.liveboss == nil then
        msg.liveboss = {}
      end
      for i = 1, #liveboss do
        table.insert(msg.liveboss, liveboss[i])
      end
    end
    if dieboss ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dieboss == nil then
        msg.dieboss = {}
      end
      for i = 1, #dieboss do
        table.insert(msg.dieboss, dieboss[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncMvpInfoFubenCmd.id
    local msgParam = {}
    if usernum ~= nil then
      msgParam.usernum = usernum
    end
    if liveboss ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.liveboss == nil then
        msgParam.liveboss = {}
      end
      for i = 1, #liveboss do
        table.insert(msgParam.liveboss, liveboss[i])
      end
    end
    if dieboss ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dieboss == nil then
        msgParam.dieboss = {}
      end
      for i = 1, #dieboss do
        table.insert(msgParam.dieboss, dieboss[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallBossDieFubenCmd(npcid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.BossDieFubenCmd()
    if msg == nil then
      msg = {}
    end
    msg.npcid = npcid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BossDieFubenCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcid = npcid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallUpdateUserNumFubenCmd(usernum)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.UpdateUserNumFubenCmd()
    if usernum ~= nil then
      msg.usernum = usernum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateUserNumFubenCmd.id
    local msgParam = {}
    if usernum ~= nil then
      msgParam.usernum = usernum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSuperGvgSyncFubenCmd(towers, guildinfo, firebegintime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SuperGvgSyncFubenCmd()
    if towers ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.towers == nil then
        msg.towers = {}
      end
      for i = 1, #towers do
        table.insert(msg.towers, towers[i])
      end
    end
    if guildinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      for i = 1, #guildinfo do
        table.insert(msg.guildinfo, guildinfo[i])
      end
    end
    if firebegintime ~= nil then
      msg.firebegintime = firebegintime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SuperGvgSyncFubenCmd.id
    local msgParam = {}
    if towers ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.towers == nil then
        msgParam.towers = {}
      end
      for i = 1, #towers do
        table.insert(msgParam.towers, towers[i])
      end
    end
    if guildinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      for i = 1, #guildinfo do
        table.insert(msgParam.guildinfo, guildinfo[i])
      end
    end
    if firebegintime ~= nil then
      msgParam.firebegintime = firebegintime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgTowerUpdateFubenCmd(towers)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgTowerUpdateFubenCmd()
    if towers ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.towers == nil then
        msg.towers = {}
      end
      for i = 1, #towers do
        table.insert(msg.towers, towers[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgTowerUpdateFubenCmd.id
    local msgParam = {}
    if towers ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.towers == nil then
        msgParam.towers = {}
      end
      for i = 1, #towers do
        table.insert(msgParam.towers, towers[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgMetalDieFubenCmd(index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgMetalDieFubenCmd()
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgMetalDieFubenCmd.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgCrystalUpdateFubenCmd(crystals)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgCrystalUpdateFubenCmd()
    if crystals ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.crystals == nil then
        msg.crystals = {}
      end
      for i = 1, #crystals do
        table.insert(msg.crystals, crystals[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgCrystalUpdateFubenCmd.id
    local msgParam = {}
    if crystals ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.crystals == nil then
        msgParam.crystals = {}
      end
      for i = 1, #crystals do
        table.insert(msgParam.crystals, crystals[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryGvgTowerInfoFubenCmd(etype, open)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryGvgTowerInfoFubenCmd()
    if msg == nil then
      msg = {}
    end
    msg.etype = etype
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGvgTowerInfoFubenCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.etype = etype
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSuperGvgRewardInfoFubenCmd(rewardinfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SuperGvgRewardInfoFubenCmd()
    if rewardinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewardinfo == nil then
        msg.rewardinfo = {}
      end
      for i = 1, #rewardinfo do
        table.insert(msg.rewardinfo, rewardinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SuperGvgRewardInfoFubenCmd.id
    local msgParam = {}
    if rewardinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewardinfo == nil then
        msgParam.rewardinfo = {}
      end
      for i = 1, #rewardinfo do
        table.insert(msgParam.rewardinfo, rewardinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSuperGvgQueryUserDataFubenCmd(guilduserdata, is_end)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SuperGvgQueryUserDataFubenCmd()
    if guilduserdata ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guilduserdata == nil then
        msg.guilduserdata = {}
      end
      for i = 1, #guilduserdata do
        table.insert(msg.guilduserdata, guilduserdata[i])
      end
    end
    if is_end ~= nil then
      msg.is_end = is_end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SuperGvgQueryUserDataFubenCmd.id
    local msgParam = {}
    if guilduserdata ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guilduserdata == nil then
        msgParam.guilduserdata = {}
      end
      for i = 1, #guilduserdata do
        table.insert(msgParam.guilduserdata, guilduserdata[i])
      end
    end
    if is_end ~= nil then
      msgParam.is_end = is_end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallMvpBattleReportFubenCmd(datas)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.MvpBattleReportFubenCmd()
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
    local msgId = ProtoReqInfoList.MvpBattleReportFubenCmd.id
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

function ServiceFuBenCmdAutoProxy:CallInviteSummonBossFubenCmd(difficulty, deadboss_raid_index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.InviteSummonBossFubenCmd()
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    if deadboss_raid_index ~= nil then
      msg.deadboss_raid_index = deadboss_raid_index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteSummonBossFubenCmd.id
    local msgParam = {}
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    if deadboss_raid_index ~= nil then
      msgParam.deadboss_raid_index = deadboss_raid_index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallReplySummonBossFubenCmd(isfull, agree, charid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ReplySummonBossFubenCmd()
    if isfull ~= nil then
      msg.isfull = isfull
    end
    if agree ~= nil then
      msg.agree = agree
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplySummonBossFubenCmd.id
    local msgParam = {}
    if isfull ~= nil then
      msgParam.isfull = isfull
    end
    if agree ~= nil then
      msgParam.agree = agree
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryTeamPwsUserInfoFubenCmd(teaminfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryTeamPwsUserInfoFubenCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTeamPwsUserInfoFubenCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamPwsReportFubenCmd(teaminfo, mvpuserinfo, winteam)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamPwsReportFubenCmd()
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
    if mvpuserinfo ~= nil and mvpuserinfo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.charid = mvpuserinfo.charid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildid = mvpuserinfo.guildid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.accid = mvpuserinfo.accid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.name = mvpuserinfo.name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildname = mvpuserinfo.guildname
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildportrait = mvpuserinfo.guildportrait
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildjob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildjob = mvpuserinfo.guildjob
    end
    if mvpuserinfo ~= nil and mvpuserinfo.datas ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.datas == nil then
        msg.mvpuserinfo.datas = {}
      end
      for i = 1, #mvpuserinfo.datas do
        table.insert(msg.mvpuserinfo.datas, mvpuserinfo.datas[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.attrs ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.attrs == nil then
        msg.mvpuserinfo.attrs = {}
      end
      for i = 1, #mvpuserinfo.attrs do
        table.insert(msg.mvpuserinfo.attrs, mvpuserinfo.attrs[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.equip ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.equip == nil then
        msg.mvpuserinfo.equip = {}
      end
      for i = 1, #mvpuserinfo.equip do
        table.insert(msg.mvpuserinfo.equip, mvpuserinfo.equip[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.fashion ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.fashion == nil then
        msg.mvpuserinfo.fashion = {}
      end
      for i = 1, #mvpuserinfo.fashion do
        table.insert(msg.mvpuserinfo.fashion, mvpuserinfo.fashion[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.shadow ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.shadow == nil then
        msg.mvpuserinfo.shadow = {}
      end
      for i = 1, #mvpuserinfo.shadow do
        table.insert(msg.mvpuserinfo.shadow, mvpuserinfo.shadow[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.extraction ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.extraction == nil then
        msg.mvpuserinfo.extraction = {}
      end
      for i = 1, #mvpuserinfo.extraction do
        table.insert(msg.mvpuserinfo.extraction, mvpuserinfo.extraction[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.highrefine ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.highrefine == nil then
        msg.mvpuserinfo.highrefine = {}
      end
      for i = 1, #mvpuserinfo.highrefine do
        table.insert(msg.mvpuserinfo.highrefine, mvpuserinfo.highrefine[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.partner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.partner = mvpuserinfo.partner
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.id ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.id = mvpuserinfo.mercenary.id
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.name ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.name = mvpuserinfo.mercenary.name
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.icon ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.icon = mvpuserinfo.mercenary.icon
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.job ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.job = mvpuserinfo.mercenary.job
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.mercenary_name = mvpuserinfo.mercenary.mercenary_name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.memory_pos ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.memory_pos == nil then
        msg.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #mvpuserinfo.memory_pos do
        table.insert(msg.mvpuserinfo.memory_pos, mvpuserinfo.memory_pos[i])
      end
    end
    if msg == nil then
      msg = {}
    end
    msg.winteam = winteam
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamPwsReportFubenCmd.id
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
    if mvpuserinfo ~= nil and mvpuserinfo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.charid = mvpuserinfo.charid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildid = mvpuserinfo.guildid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.accid = mvpuserinfo.accid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.name = mvpuserinfo.name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildname = mvpuserinfo.guildname
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildportrait = mvpuserinfo.guildportrait
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildjob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildjob = mvpuserinfo.guildjob
    end
    if mvpuserinfo ~= nil and mvpuserinfo.datas ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.datas == nil then
        msgParam.mvpuserinfo.datas = {}
      end
      for i = 1, #mvpuserinfo.datas do
        table.insert(msgParam.mvpuserinfo.datas, mvpuserinfo.datas[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.attrs ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.attrs == nil then
        msgParam.mvpuserinfo.attrs = {}
      end
      for i = 1, #mvpuserinfo.attrs do
        table.insert(msgParam.mvpuserinfo.attrs, mvpuserinfo.attrs[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.equip ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.equip == nil then
        msgParam.mvpuserinfo.equip = {}
      end
      for i = 1, #mvpuserinfo.equip do
        table.insert(msgParam.mvpuserinfo.equip, mvpuserinfo.equip[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.fashion ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.fashion == nil then
        msgParam.mvpuserinfo.fashion = {}
      end
      for i = 1, #mvpuserinfo.fashion do
        table.insert(msgParam.mvpuserinfo.fashion, mvpuserinfo.fashion[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.shadow ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.shadow == nil then
        msgParam.mvpuserinfo.shadow = {}
      end
      for i = 1, #mvpuserinfo.shadow do
        table.insert(msgParam.mvpuserinfo.shadow, mvpuserinfo.shadow[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.extraction ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.extraction == nil then
        msgParam.mvpuserinfo.extraction = {}
      end
      for i = 1, #mvpuserinfo.extraction do
        table.insert(msgParam.mvpuserinfo.extraction, mvpuserinfo.extraction[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.highrefine ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.highrefine == nil then
        msgParam.mvpuserinfo.highrefine = {}
      end
      for i = 1, #mvpuserinfo.highrefine do
        table.insert(msgParam.mvpuserinfo.highrefine, mvpuserinfo.highrefine[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.partner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.partner = mvpuserinfo.partner
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.id ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.id = mvpuserinfo.mercenary.id
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.name ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.name = mvpuserinfo.mercenary.name
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.icon ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.icon = mvpuserinfo.mercenary.icon
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.job ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.job = mvpuserinfo.mercenary.job
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.mercenary_name = mvpuserinfo.mercenary.mercenary_name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.memory_pos ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.memory_pos == nil then
        msgParam.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #mvpuserinfo.memory_pos do
        table.insert(msgParam.mvpuserinfo.memory_pos, mvpuserinfo.memory_pos[i])
      end
    end
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.winteam = winteam
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamPwsInfoSyncFubenCmd(teaminfo, endtime, fullfire)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamPwsInfoSyncFubenCmd()
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
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if fullfire ~= nil then
      msg.fullfire = fullfire
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamPwsInfoSyncFubenCmd.id
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
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if fullfire ~= nil then
      msgParam.fullfire = fullfire
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallUpdateTeamPwsInfoFubenCmd(teaminfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.UpdateTeamPwsInfoFubenCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateTeamPwsInfoFubenCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSelectTeamPwsMagicFubenCmd(magicid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SelectTeamPwsMagicFubenCmd()
    if msg == nil then
      msg = {}
    end
    msg.magicid = magicid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectTeamPwsMagicFubenCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.magicid = magicid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallExitMapFubenCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ExitMapFubenCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitMapFubenCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallBeginFireFubenCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.BeginFireFubenCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeginFireFubenCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamExpReportFubenCmd(baseexp, jobexp, items, closetime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamExpReportFubenCmd()
    if baseexp ~= nil then
      msg.baseexp = baseexp
    end
    if jobexp ~= nil then
      msg.jobexp = jobexp
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
    if closetime ~= nil then
      msg.closetime = closetime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamExpReportFubenCmd.id
    local msgParam = {}
    if baseexp ~= nil then
      msgParam.baseexp = baseexp
    end
    if jobexp ~= nil then
      msgParam.jobexp = jobexp
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
    if closetime ~= nil then
      msgParam.closetime = closetime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallBuyExpRaidItemFubenCmd(itemid, num)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.BuyExpRaidItemFubenCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if num ~= nil then
      msg.num = num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyExpRaidItemFubenCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if num ~= nil then
      msgParam.num = num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamExpSyncFubenCmd(endtime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamExpSyncFubenCmd()
    if endtime ~= nil then
      msg.endtime = endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamExpSyncFubenCmd.id
    local msgParam = {}
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamReliveCountFubenCmd(count, maxcount)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamReliveCountFubenCmd()
    if count ~= nil then
      msg.count = count
    end
    if maxcount ~= nil then
      msg.maxcount = maxcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamReliveCountFubenCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    if maxcount ~= nil then
      msgParam.maxcount = maxcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamGroupRaidUpdateChipNum(chipnum)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamGroupRaidUpdateChipNum()
    if chipnum ~= nil then
      msg.chipnum = chipnum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamGroupRaidUpdateChipNum.id
    local msgParam = {}
    if chipnum ~= nil then
      msgParam.chipnum = chipnum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryTeamGroupRaidUserInfo(current, history)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryTeamGroupRaidUserInfo()
    if current ~= nil and current.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msg.current == nil then
        msg.current = {}
      end
      if msg.current.datas == nil then
        msg.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msg.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.boss_index = current.boss_index
    end
    if history ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.history == nil then
        msg.history = {}
      end
      for i = 1, #history do
        table.insert(msg.history, history[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTeamGroupRaidUserInfo.id
    local msgParam = {}
    if current ~= nil and current.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msgParam.current == nil then
        msgParam.current = {}
      end
      if msgParam.current.datas == nil then
        msgParam.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msgParam.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.boss_index = current.boss_index
    end
    if history ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.history == nil then
        msgParam.history = {}
      end
      for i = 1, #history do
        table.insert(msgParam.history, history[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGroupRaidStateSyncFuBenCmd(state)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GroupRaidStateSyncFuBenCmd()
    if state ~= nil then
      msg.state = state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GroupRaidStateSyncFuBenCmd.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamExpQueryInfoFubenCmd(rewardtimes, totaltimes)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamExpQueryInfoFubenCmd()
    if rewardtimes ~= nil then
      msg.rewardtimes = rewardtimes
    end
    if totaltimes ~= nil then
      msg.totaltimes = totaltimes
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamExpQueryInfoFubenCmd.id
    local msgParam = {}
    if rewardtimes ~= nil then
      msgParam.rewardtimes = rewardtimes
    end
    if totaltimes ~= nil then
      msgParam.totaltimes = totaltimes
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallUpdateGroupRaidFourthShowData(inner, outer)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.UpdateGroupRaidFourthShowData()
    if inner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inner == nil then
        msg.inner = {}
      end
      for i = 1, #inner do
        table.insert(msg.inner, inner[i])
      end
    end
    if outer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.outer == nil then
        msg.outer = {}
      end
      for i = 1, #outer do
        table.insert(msg.outer, outer[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateGroupRaidFourthShowData.id
    local msgParam = {}
    if inner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inner == nil then
        msgParam.inner = {}
      end
      for i = 1, #inner do
        table.insert(msgParam.inner, inner[i])
      end
    end
    if outer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.outer == nil then
        msgParam.outer = {}
      end
      for i = 1, #outer do
        table.insert(msgParam.outer, outer[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryGroupRaidFourthShowData(open)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryGroupRaidFourthShowData()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGroupRaidFourthShowData.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGroupRaidFourthGoOuterCmd(npcguid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GroupRaidFourthGoOuterCmd()
    if msg == nil then
      msg = {}
    end
    msg.npcguid = npcguid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GroupRaidFourthGoOuterCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcguid = npcguid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRaidStageSyncFubenCmd(stage)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RaidStageSyncFubenCmd()
    if stage ~= nil then
      msg.stage = stage
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidStageSyncFubenCmd.id
    local msgParam = {}
    if stage ~= nil then
      msgParam.stage = stage
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallThanksGivingMonsterFuBenCmd(elitenum, mininum, mvpnum)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ThanksGivingMonsterFuBenCmd()
    if elitenum ~= nil then
      msg.elitenum = elitenum
    end
    if mininum ~= nil then
      msg.mininum = mininum
    end
    if mvpnum ~= nil then
      msg.mvpnum = mvpnum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ThanksGivingMonsterFuBenCmd.id
    local msgParam = {}
    if elitenum ~= nil then
      msgParam.elitenum = elitenum
    end
    if mininum ~= nil then
      msgParam.mininum = mininum
    end
    if mvpnum ~= nil then
      msgParam.mvpnum = mvpnum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallKumamotoOperFubenCmd(type, value)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.KumamotoOperFubenCmd()
    if type ~= nil then
      msg.type = type
    end
    if value ~= nil then
      msg.value = value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KumamotoOperFubenCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if value ~= nil then
      msgParam.value = value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallOthelloPointOccupyPowerFubenCmd(occupy)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.OthelloPointOccupyPowerFubenCmd()
    if occupy ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.occupy == nil then
        msg.occupy = {}
      end
      for i = 1, #occupy do
        table.insert(msg.occupy, occupy[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OthelloPointOccupyPowerFubenCmd.id
    local msgParam = {}
    if occupy ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.occupy == nil then
        msgParam.occupy = {}
      end
      for i = 1, #occupy do
        table.insert(msgParam.occupy, occupy[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallOthelloInfoSyncFubenCmd(teaminfo, endtime, fullfire)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.OthelloInfoSyncFubenCmd()
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
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if fullfire ~= nil then
      msg.fullfire = fullfire
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OthelloInfoSyncFubenCmd.id
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
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if fullfire ~= nil then
      msgParam.fullfire = fullfire
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryOthelloUserInfoFubenCmd(teaminfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryOthelloUserInfoFubenCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryOthelloUserInfoFubenCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallOthelloReportFubenCmd(winteam, teaminfo, mvpuserinfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.OthelloReportFubenCmd()
    if msg == nil then
      msg = {}
    end
    msg.winteam = winteam
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
    if mvpuserinfo ~= nil and mvpuserinfo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.charid = mvpuserinfo.charid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildid = mvpuserinfo.guildid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.accid = mvpuserinfo.accid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.name = mvpuserinfo.name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildname = mvpuserinfo.guildname
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildportrait = mvpuserinfo.guildportrait
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildjob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildjob = mvpuserinfo.guildjob
    end
    if mvpuserinfo ~= nil and mvpuserinfo.datas ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.datas == nil then
        msg.mvpuserinfo.datas = {}
      end
      for i = 1, #mvpuserinfo.datas do
        table.insert(msg.mvpuserinfo.datas, mvpuserinfo.datas[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.attrs ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.attrs == nil then
        msg.mvpuserinfo.attrs = {}
      end
      for i = 1, #mvpuserinfo.attrs do
        table.insert(msg.mvpuserinfo.attrs, mvpuserinfo.attrs[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.equip ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.equip == nil then
        msg.mvpuserinfo.equip = {}
      end
      for i = 1, #mvpuserinfo.equip do
        table.insert(msg.mvpuserinfo.equip, mvpuserinfo.equip[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.fashion ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.fashion == nil then
        msg.mvpuserinfo.fashion = {}
      end
      for i = 1, #mvpuserinfo.fashion do
        table.insert(msg.mvpuserinfo.fashion, mvpuserinfo.fashion[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.shadow ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.shadow == nil then
        msg.mvpuserinfo.shadow = {}
      end
      for i = 1, #mvpuserinfo.shadow do
        table.insert(msg.mvpuserinfo.shadow, mvpuserinfo.shadow[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.extraction ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.extraction == nil then
        msg.mvpuserinfo.extraction = {}
      end
      for i = 1, #mvpuserinfo.extraction do
        table.insert(msg.mvpuserinfo.extraction, mvpuserinfo.extraction[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.highrefine ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.highrefine == nil then
        msg.mvpuserinfo.highrefine = {}
      end
      for i = 1, #mvpuserinfo.highrefine do
        table.insert(msg.mvpuserinfo.highrefine, mvpuserinfo.highrefine[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.partner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.partner = mvpuserinfo.partner
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.id ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.id = mvpuserinfo.mercenary.id
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.name ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.name = mvpuserinfo.mercenary.name
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.icon ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.icon = mvpuserinfo.mercenary.icon
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.job ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.job = mvpuserinfo.mercenary.job
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.mercenary_name = mvpuserinfo.mercenary.mercenary_name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.memory_pos ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.memory_pos == nil then
        msg.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #mvpuserinfo.memory_pos do
        table.insert(msg.mvpuserinfo.memory_pos, mvpuserinfo.memory_pos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OthelloReportFubenCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.winteam = winteam
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
    if mvpuserinfo ~= nil and mvpuserinfo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.charid = mvpuserinfo.charid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildid = mvpuserinfo.guildid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.accid = mvpuserinfo.accid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.name = mvpuserinfo.name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildname = mvpuserinfo.guildname
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildportrait = mvpuserinfo.guildportrait
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildjob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildjob = mvpuserinfo.guildjob
    end
    if mvpuserinfo ~= nil and mvpuserinfo.datas ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.datas == nil then
        msgParam.mvpuserinfo.datas = {}
      end
      for i = 1, #mvpuserinfo.datas do
        table.insert(msgParam.mvpuserinfo.datas, mvpuserinfo.datas[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.attrs ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.attrs == nil then
        msgParam.mvpuserinfo.attrs = {}
      end
      for i = 1, #mvpuserinfo.attrs do
        table.insert(msgParam.mvpuserinfo.attrs, mvpuserinfo.attrs[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.equip ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.equip == nil then
        msgParam.mvpuserinfo.equip = {}
      end
      for i = 1, #mvpuserinfo.equip do
        table.insert(msgParam.mvpuserinfo.equip, mvpuserinfo.equip[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.fashion ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.fashion == nil then
        msgParam.mvpuserinfo.fashion = {}
      end
      for i = 1, #mvpuserinfo.fashion do
        table.insert(msgParam.mvpuserinfo.fashion, mvpuserinfo.fashion[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.shadow ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.shadow == nil then
        msgParam.mvpuserinfo.shadow = {}
      end
      for i = 1, #mvpuserinfo.shadow do
        table.insert(msgParam.mvpuserinfo.shadow, mvpuserinfo.shadow[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.extraction ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.extraction == nil then
        msgParam.mvpuserinfo.extraction = {}
      end
      for i = 1, #mvpuserinfo.extraction do
        table.insert(msgParam.mvpuserinfo.extraction, mvpuserinfo.extraction[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.highrefine ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.highrefine == nil then
        msgParam.mvpuserinfo.highrefine = {}
      end
      for i = 1, #mvpuserinfo.highrefine do
        table.insert(msgParam.mvpuserinfo.highrefine, mvpuserinfo.highrefine[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.partner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.partner = mvpuserinfo.partner
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.id ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.id = mvpuserinfo.mercenary.id
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.name ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.name = mvpuserinfo.mercenary.name
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.icon ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.icon = mvpuserinfo.mercenary.icon
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.job ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.job = mvpuserinfo.mercenary.job
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.mercenary_name = mvpuserinfo.mercenary.mercenary_name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.memory_pos ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.memory_pos == nil then
        msgParam.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #mvpuserinfo.memory_pos do
        table.insert(msgParam.mvpuserinfo.memory_pos, mvpuserinfo.memory_pos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRoguelikeUnlockSceneSync(unlockids)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RoguelikeUnlockSceneSync()
    if unlockids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unlockids == nil then
        msg.unlockids = {}
      end
      for i = 1, #unlockids do
        table.insert(msg.unlockids, unlockids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeUnlockSceneSync.id
    local msgParam = {}
    if unlockids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unlockids == nil then
        msgParam.unlockids = {}
      end
      for i = 1, #unlockids do
        table.insert(msgParam.unlockids, unlockids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTransferFightChooseFubenCmd(coldtime, index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TransferFightChooseFubenCmd()
    if coldtime ~= nil then
      msg.coldtime = coldtime
    end
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TransferFightChooseFubenCmd.id
    local msgParam = {}
    if coldtime ~= nil then
      msgParam.coldtime = coldtime
    end
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTransferFightRankFubenCmd(coldtime, myscore, rank)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TransferFightRankFubenCmd()
    if coldtime ~= nil then
      msg.coldtime = coldtime
    end
    if myscore ~= nil then
      msg.myscore = myscore
    end
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TransferFightRankFubenCmd.id
    local msgParam = {}
    if coldtime ~= nil then
      msgParam.coldtime = coldtime
    end
    if myscore ~= nil then
      msgParam.myscore = myscore
    end
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTransferFightEndFubenCmd(rank, myrank)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TransferFightEndFubenCmd()
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
    if myrank ~= nil and myrank.rank ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myrank == nil then
        msg.myrank = {}
      end
      msg.myrank.rank = myrank.rank
    end
    if myrank ~= nil and myrank.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myrank == nil then
        msg.myrank = {}
      end
      msg.myrank.score = myrank.score
    end
    if myrank ~= nil and myrank.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myrank == nil then
        msg.myrank = {}
      end
      msg.myrank.name = myrank.name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TransferFightEndFubenCmd.id
    local msgParam = {}
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
    if myrank ~= nil and myrank.rank ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myrank == nil then
        msgParam.myrank = {}
      end
      msgParam.myrank.rank = myrank.rank
    end
    if myrank ~= nil and myrank.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myrank == nil then
        msgParam.myrank = {}
      end
      msgParam.myrank.score = myrank.score
    end
    if myrank ~= nil and myrank.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myrank == nil then
        msgParam.myrank = {}
      end
      msgParam.myrank.name = myrank.name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallInviteRollRewardFubenCmd(etype, param1, costcoin, count)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.InviteRollRewardFubenCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    if costcoin ~= nil then
      msg.costcoin = costcoin
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteRollRewardFubenCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    if costcoin ~= nil then
      msgParam.costcoin = costcoin
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallReplyRollRewardFubenCmd(agree, etype, param1, gold_buy_price)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ReplyRollRewardFubenCmd()
    if agree ~= nil then
      msg.agree = agree
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    if gold_buy_price ~= nil then
      msg.gold_buy_price = gold_buy_price
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyRollRewardFubenCmd.id
    local msgParam = {}
    if agree ~= nil then
      msgParam.agree = agree
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    if gold_buy_price ~= nil then
      msgParam.gold_buy_price = gold_buy_price
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamRollStatusFuBenCmd(addids, delid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamRollStatusFuBenCmd()
    if addids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addids == nil then
        msg.addids = {}
      end
      for i = 1, #addids do
        table.insert(msg.addids, addids[i])
      end
    end
    if delid ~= nil then
      msg.delid = delid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamRollStatusFuBenCmd.id
    local msgParam = {}
    if addids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addids == nil then
        msgParam.addids = {}
      end
      for i = 1, #addids do
        table.insert(msgParam.addids, addids[i])
      end
    end
    if delid ~= nil then
      msgParam.delid = delid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallPreReplyRollRewardFubenCmd(charid, etype, param1)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.PreReplyRollRewardFubenCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PreReplyRollRewardFubenCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTwelvePvpSyncCmd(datas, camp, charid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpSyncCmd()
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
    if camp ~= nil then
      msg.camp = camp
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpSyncCmd.id
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
    if camp ~= nil then
      msgParam.camp = camp
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRaidItemSyncCmd(items, charid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RaidItemSyncCmd()
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
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidItemSyncCmd.id
    local msgParam = {}
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
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRaidItemUpdateCmd(itemid, count, charid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RaidItemUpdateCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidItemUpdateCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTwelvePvpUseItemCmd(itemid, count)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpUseItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpUseItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRaidShopUpdateCmd(shopitem_id, next_available_time)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RaidShopUpdateCmd()
    if shopitem_id ~= nil then
      msg.shopitem_id = shopitem_id
    end
    if next_available_time ~= nil then
      msg.next_available_time = next_available_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidShopUpdateCmd.id
    local msgParam = {}
    if shopitem_id ~= nil then
      msgParam.shopitem_id = shopitem_id
    end
    if next_available_time ~= nil then
      msgParam.next_available_time = next_available_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTwelvePvpQuestQueryCmd(datas)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpQuestQueryCmd()
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
    local msgId = ProtoReqInfoList.TwelvePvpQuestQueryCmd.id
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

function ServiceFuBenCmdAutoProxy:CallTwelvePvpQueryGroupInfoCmd(groupinfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpQueryGroupInfoCmd()
    if groupinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groupinfo == nil then
        msg.groupinfo = {}
      end
      for i = 1, #groupinfo do
        table.insert(msg.groupinfo, groupinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpQueryGroupInfoCmd.id
    local msgParam = {}
    if groupinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groupinfo == nil then
        msgParam.groupinfo = {}
      end
      for i = 1, #groupinfo do
        table.insert(msgParam.groupinfo, groupinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTwelvePvpResultCmd(groupinfo_cmd, winteam, camp_result_data)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpResultCmd()
    if groupinfo_cmd ~= nil and groupinfo_cmd.cmd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groupinfo_cmd == nil then
        msg.groupinfo_cmd = {}
      end
      msg.groupinfo_cmd.cmd = groupinfo_cmd.cmd
    end
    if groupinfo_cmd ~= nil and groupinfo_cmd.param ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groupinfo_cmd == nil then
        msg.groupinfo_cmd = {}
      end
      msg.groupinfo_cmd.param = groupinfo_cmd.param
    end
    if groupinfo_cmd ~= nil and groupinfo_cmd.groupinfo ~= nil then
      if msg.groupinfo_cmd == nil then
        msg.groupinfo_cmd = {}
      end
      if msg.groupinfo_cmd.groupinfo == nil then
        msg.groupinfo_cmd.groupinfo = {}
      end
      for i = 1, #groupinfo_cmd.groupinfo do
        table.insert(msg.groupinfo_cmd.groupinfo, groupinfo_cmd.groupinfo[i])
      end
    end
    if winteam ~= nil then
      msg.winteam = winteam
    end
    if camp_result_data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camp_result_data == nil then
        msg.camp_result_data = {}
      end
      for i = 1, #camp_result_data do
        table.insert(msg.camp_result_data, camp_result_data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpResultCmd.id
    local msgParam = {}
    if groupinfo_cmd ~= nil and groupinfo_cmd.cmd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groupinfo_cmd == nil then
        msgParam.groupinfo_cmd = {}
      end
      msgParam.groupinfo_cmd.cmd = groupinfo_cmd.cmd
    end
    if groupinfo_cmd ~= nil and groupinfo_cmd.param ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groupinfo_cmd == nil then
        msgParam.groupinfo_cmd = {}
      end
      msgParam.groupinfo_cmd.param = groupinfo_cmd.param
    end
    if groupinfo_cmd ~= nil and groupinfo_cmd.groupinfo ~= nil then
      if msgParam.groupinfo_cmd == nil then
        msgParam.groupinfo_cmd = {}
      end
      if msgParam.groupinfo_cmd.groupinfo == nil then
        msgParam.groupinfo_cmd.groupinfo = {}
      end
      for i = 1, #groupinfo_cmd.groupinfo do
        table.insert(msgParam.groupinfo_cmd.groupinfo, groupinfo_cmd.groupinfo[i])
      end
    end
    if winteam ~= nil then
      msgParam.winteam = winteam
    end
    if camp_result_data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camp_result_data == nil then
        msgParam.camp_result_data = {}
      end
      for i = 1, #camp_result_data do
        table.insert(msgParam.camp_result_data, camp_result_data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTwelvePvpBuildingHpUpdateCmd(data)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpBuildingHpUpdateCmd()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpBuildingHpUpdateCmd.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTwelvePvpUIOperCmd(ui, open)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TwelvePvpUIOperCmd()
    if ui ~= nil then
      msg.ui = ui
    end
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwelvePvpUIOperCmd.id
    local msgParam = {}
    if ui ~= nil then
      msgParam.ui = ui
    end
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallReliveCdFubenCmd(next_relive_time)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ReliveCdFubenCmd()
    if next_relive_time ~= nil then
      msg.next_relive_time = next_relive_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReliveCdFubenCmd.id
    local msgParam = {}
    if next_relive_time ~= nil then
      msgParam.next_relive_time = next_relive_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallPosSyncFubenCmd(datas, out_scope_ids)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.PosSyncFubenCmd()
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
    if out_scope_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.out_scope_ids == nil then
        msg.out_scope_ids = {}
      end
      for i = 1, #out_scope_ids do
        table.insert(msg.out_scope_ids, out_scope_ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PosSyncFubenCmd.id
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
    if out_scope_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.out_scope_ids == nil then
        msgParam.out_scope_ids = {}
      end
      for i = 1, #out_scope_ids do
        table.insert(msgParam.out_scope_ids, out_scope_ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallReqEnterTowerPrivate(raidid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ReqEnterTowerPrivate()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqEnterTowerPrivate.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTowerPrivateLayerInfo(raidid, layer, monsters, rewards)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TowerPrivateLayerInfo()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if layer ~= nil then
      msg.layer = layer
    end
    if monsters ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.monsters == nil then
        msg.monsters = {}
      end
      for i = 1, #monsters do
        table.insert(msg.monsters, monsters[i])
      end
    end
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
    local msgId = ProtoReqInfoList.TowerPrivateLayerInfo.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if layer ~= nil then
      msgParam.layer = layer
    end
    if monsters ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.monsters == nil then
        msgParam.monsters = {}
      end
      for i = 1, #monsters do
        table.insert(msgParam.monsters, monsters[i])
      end
    end
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

function ServiceFuBenCmdAutoProxy:CallTowerPrivateLayerCountdownNtf(overat)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TowerPrivateLayerCountdownNtf()
    if overat ~= nil then
      msg.overat = overat
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TowerPrivateLayerCountdownNtf.id
    local msgParam = {}
    if overat ~= nil then
      msgParam.overat = overat
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFubenResultNtf(raidtype, iswin)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FubenResultNtf()
    if raidtype ~= nil then
      msg.raidtype = raidtype
    end
    if iswin ~= nil then
      msg.iswin = iswin
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FubenResultNtf.id
    local msgParam = {}
    if raidtype ~= nil then
      msgParam.raidtype = raidtype
    end
    if iswin ~= nil then
      msgParam.iswin = iswin
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallEndTimeSyncFubenCmd(endtime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.EndTimeSyncFubenCmd()
    if endtime ~= nil then
      msg.endtime = endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EndTimeSyncFubenCmd.id
    local msgParam = {}
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallResultSyncFubenCmd(score)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ResultSyncFubenCmd()
    if score ~= nil then
      msg.score = score
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResultSyncFubenCmd.id
    local msgParam = {}
    if score ~= nil then
      msgParam.score = score
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallComodoPhaseFubenCmd(phase)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ComodoPhaseFubenCmd()
    if phase ~= nil then
      msg.phase = phase
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ComodoPhaseFubenCmd.id
    local msgParam = {}
    if phase ~= nil then
      msgParam.phase = phase
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryComodoTeamRaidStat(current, total, history)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryComodoTeamRaidStat()
    if current ~= nil and current.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msg.current == nil then
        msg.current = {}
      end
      if msg.current.datas == nil then
        msg.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msg.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.boss_index = current.boss_index
    end
    if total ~= nil and total.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total == nil then
        msg.total = {}
      end
      msg.total.raidid = total.raidid
    end
    if total ~= nil and total.datas ~= nil then
      if msg.total == nil then
        msg.total = {}
      end
      if msg.total.datas == nil then
        msg.total.datas = {}
      end
      for i = 1, #total.datas do
        table.insert(msg.total.datas, total.datas[i])
      end
    end
    if total ~= nil and total.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total == nil then
        msg.total = {}
      end
      msg.total.boss_index = total.boss_index
    end
    if history ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.history == nil then
        msg.history = {}
      end
      for i = 1, #history do
        table.insert(msg.history, history[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryComodoTeamRaidStat.id
    local msgParam = {}
    if current ~= nil and current.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msgParam.current == nil then
        msgParam.current = {}
      end
      if msgParam.current.datas == nil then
        msgParam.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msgParam.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.boss_index = current.boss_index
    end
    if total ~= nil and total.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total == nil then
        msgParam.total = {}
      end
      msgParam.total.raidid = total.raidid
    end
    if total ~= nil and total.datas ~= nil then
      if msgParam.total == nil then
        msgParam.total = {}
      end
      if msgParam.total.datas == nil then
        msgParam.total.datas = {}
      end
      for i = 1, #total.datas do
        table.insert(msgParam.total.datas, total.datas[i])
      end
    end
    if total ~= nil and total.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total == nil then
        msgParam.total = {}
      end
      msgParam.total.boss_index = total.boss_index
    end
    if history ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.history == nil then
        msgParam.history = {}
      end
      for i = 1, #history do
        table.insert(msgParam.history, history[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallTeamPwsStateSyncFubenCmd(fire)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.TeamPwsStateSyncFubenCmd()
    if fire ~= nil then
      msg.fire = fire
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamPwsStateSyncFubenCmd.id
    local msgParam = {}
    if fire ~= nil then
      msgParam.fire = fire
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObserverFlashFubenCmd(x, y, z)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObserverFlashFubenCmd()
    if x ~= nil then
      msg.x = x
    end
    if y ~= nil then
      msg.y = y
    end
    if z ~= nil then
      msg.z = z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObserverFlashFubenCmd.id
    local msgParam = {}
    if x ~= nil then
      msgParam.x = x
    end
    if y ~= nil then
      msgParam.y = y
    end
    if z ~= nil then
      msgParam.z = z
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObserverAttachFubenCmd(attach_player)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObserverAttachFubenCmd()
    if attach_player ~= nil then
      msg.attach_player = attach_player
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObserverAttachFubenCmd.id
    local msgParam = {}
    if attach_player ~= nil then
      msgParam.attach_player = attach_player
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObserverSelectFubenCmd(select_player)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObserverSelectFubenCmd()
    if select_player ~= nil then
      msg.select_player = select_player
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObserverSelectFubenCmd.id
    local msgParam = {}
    if select_player ~= nil then
      msgParam.select_player = select_player
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObHpspUpdateFubenCmd(updates)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObHpspUpdateFubenCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObHpspUpdateFubenCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObPlayerOfflineFubenCmd(offline_char)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObPlayerOfflineFubenCmd()
    if offline_char ~= nil then
      msg.offline_char = offline_char
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObPlayerOfflineFubenCmd.id
    local msgParam = {}
    if offline_char ~= nil then
      msgParam.offline_char = offline_char
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallMultiBossPhaseFubenCmd(boss_index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.MultiBossPhaseFubenCmd()
    if boss_index ~= nil then
      msg.boss_index = boss_index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MultiBossPhaseFubenCmd.id
    local msgParam = {}
    if boss_index ~= nil then
      msgParam.boss_index = boss_index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryMultiBossRaidStat(current, total, history)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryMultiBossRaidStat()
    if current ~= nil and current.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msg.current == nil then
        msg.current = {}
      end
      if msg.current.datas == nil then
        msg.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msg.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.boss_index = current.boss_index
    end
    if total ~= nil and total.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total == nil then
        msg.total = {}
      end
      msg.total.raidid = total.raidid
    end
    if total ~= nil and total.datas ~= nil then
      if msg.total == nil then
        msg.total = {}
      end
      if msg.total.datas == nil then
        msg.total.datas = {}
      end
      for i = 1, #total.datas do
        table.insert(msg.total.datas, total.datas[i])
      end
    end
    if total ~= nil and total.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total == nil then
        msg.total = {}
      end
      msg.total.boss_index = total.boss_index
    end
    if history ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.history == nil then
        msg.history = {}
      end
      for i = 1, #history do
        table.insert(msg.history, history[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMultiBossRaidStat.id
    local msgParam = {}
    if current ~= nil and current.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msgParam.current == nil then
        msgParam.current = {}
      end
      if msgParam.current.datas == nil then
        msgParam.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msgParam.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.boss_index = current.boss_index
    end
    if total ~= nil and total.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total == nil then
        msgParam.total = {}
      end
      msgParam.total.raidid = total.raidid
    end
    if total ~= nil and total.datas ~= nil then
      if msgParam.total == nil then
        msgParam.total = {}
      end
      if msgParam.total.datas == nil then
        msgParam.total.datas = {}
      end
      for i = 1, #total.datas do
        table.insert(msgParam.total.datas, total.datas[i])
      end
    end
    if total ~= nil and total.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total == nil then
        msgParam.total = {}
      end
      msgParam.total.boss_index = total.boss_index
    end
    if history ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.history == nil then
        msgParam.history = {}
      end
      for i = 1, #history do
        table.insert(msgParam.history, history[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObMoveCameraPrepareCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObMoveCameraPrepareCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObMoveCameraPrepareCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallObCameraMoveEndCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ObCameraMoveEndCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObCameraMoveEndCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRaidKillNumSyncCmd(kill_nums)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RaidKillNumSyncCmd()
    if kill_nums ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.kill_nums == nil then
        msg.kill_nums = {}
      end
      for i = 1, #kill_nums do
        table.insert(msg.kill_nums, kill_nums[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidKillNumSyncCmd.id
    local msgParam = {}
    if kill_nums ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.kill_nums == nil then
        msgParam.kill_nums = {}
      end
      for i = 1, #kill_nums do
        table.insert(msgParam.kill_nums, kill_nums[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncPvePassInfoFubenCmd(passinfos, battletime, totalbattletime, playtime, totalplaytime, lastinfo, quick_boss, endlessrewardlayer, all_crack_non_first, astral_season, astral_gotten_reward, astral_pass_num)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncPvePassInfoFubenCmd()
    if passinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.passinfos == nil then
        msg.passinfos = {}
      end
      for i = 1, #passinfos do
        table.insert(msg.passinfos, passinfos[i])
      end
    end
    if battletime ~= nil then
      msg.battletime = battletime
    end
    if totalbattletime ~= nil then
      msg.totalbattletime = totalbattletime
    end
    if playtime ~= nil then
      msg.playtime = playtime
    end
    if totalplaytime ~= nil then
      msg.totalplaytime = totalplaytime
    end
    if lastinfo ~= nil and lastinfo.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lastinfo == nil then
        msg.lastinfo = {}
      end
      msg.lastinfo.id = lastinfo.id
    end
    if lastinfo ~= nil and lastinfo.bossid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lastinfo == nil then
        msg.lastinfo = {}
      end
      msg.lastinfo.bossid = lastinfo.bossid
    end
    if quick_boss ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quick_boss == nil then
        msg.quick_boss = {}
      end
      for i = 1, #quick_boss do
        table.insert(msg.quick_boss, quick_boss[i])
      end
    end
    if endlessrewardlayer ~= nil then
      msg.endlessrewardlayer = endlessrewardlayer
    end
    if all_crack_non_first ~= nil then
      msg.all_crack_non_first = all_crack_non_first
    end
    if astral_season ~= nil then
      msg.astral_season = astral_season
    end
    if astral_gotten_reward ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.astral_gotten_reward == nil then
        msg.astral_gotten_reward = {}
      end
      for i = 1, #astral_gotten_reward do
        table.insert(msg.astral_gotten_reward, astral_gotten_reward[i])
      end
    end
    if astral_pass_num ~= nil then
      msg.astral_pass_num = astral_pass_num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncPvePassInfoFubenCmd.id
    local msgParam = {}
    if passinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.passinfos == nil then
        msgParam.passinfos = {}
      end
      for i = 1, #passinfos do
        table.insert(msgParam.passinfos, passinfos[i])
      end
    end
    if battletime ~= nil then
      msgParam.battletime = battletime
    end
    if totalbattletime ~= nil then
      msgParam.totalbattletime = totalbattletime
    end
    if playtime ~= nil then
      msgParam.playtime = playtime
    end
    if totalplaytime ~= nil then
      msgParam.totalplaytime = totalplaytime
    end
    if lastinfo ~= nil and lastinfo.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lastinfo == nil then
        msgParam.lastinfo = {}
      end
      msgParam.lastinfo.id = lastinfo.id
    end
    if lastinfo ~= nil and lastinfo.bossid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lastinfo == nil then
        msgParam.lastinfo = {}
      end
      msgParam.lastinfo.bossid = lastinfo.bossid
    end
    if quick_boss ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quick_boss == nil then
        msgParam.quick_boss = {}
      end
      for i = 1, #quick_boss do
        table.insert(msgParam.quick_boss, quick_boss[i])
      end
    end
    if endlessrewardlayer ~= nil then
      msgParam.endlessrewardlayer = endlessrewardlayer
    end
    if all_crack_non_first ~= nil then
      msgParam.all_crack_non_first = all_crack_non_first
    end
    if astral_season ~= nil then
      msgParam.astral_season = astral_season
    end
    if astral_gotten_reward ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.astral_gotten_reward == nil then
        msgParam.astral_gotten_reward = {}
      end
      for i = 1, #astral_gotten_reward do
        table.insert(msgParam.astral_gotten_reward, astral_gotten_reward[i])
      end
    end
    if astral_pass_num ~= nil then
      msgParam.astral_pass_num = astral_pass_num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncPveRaidAchieveFubenCmd(achieveinfos)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncPveRaidAchieveFubenCmd()
    if achieveinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.achieveinfos == nil then
        msg.achieveinfos = {}
      end
      for i = 1, #achieveinfos do
        table.insert(msg.achieveinfos, achieveinfos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncPveRaidAchieveFubenCmd.id
    local msgParam = {}
    if achieveinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.achieveinfos == nil then
        msgParam.achieveinfos = {}
      end
      for i = 1, #achieveinfos do
        table.insert(msgParam.achieveinfos, achieveinfos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQuickFinishCrackRaidFubenCmd(raidid, use_sweep_ticket)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QuickFinishCrackRaidFubenCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if use_sweep_ticket ~= nil then
      msg.use_sweep_ticket = use_sweep_ticket
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuickFinishCrackRaidFubenCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if use_sweep_ticket ~= nil then
      msgParam.use_sweep_ticket = use_sweep_ticket
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallPickupPveRaidAchieveFubenCmd(groupid, achieveid)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.PickupPveRaidAchieveFubenCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if achieveid ~= nil then
      msg.achieveid = achieveid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PickupPveRaidAchieveFubenCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if achieveid ~= nil then
      msgParam.achieveid = achieveid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgPointUpdateFubenCmd(info)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgPointUpdateFubenCmd()
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgPointUpdateFubenCmd.id
    local msgParam = {}
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgRaidStateUpdateFubenCmd(raidstate, perfect)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgRaidStateUpdateFubenCmd()
    if raidstate ~= nil then
      msg.raidstate = raidstate
    end
    if perfect ~= nil then
      msg.perfect = perfect
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRaidStateUpdateFubenCmd.id
    local msgParam = {}
    if raidstate ~= nil then
      msgParam.raidstate = raidstate
    end
    if perfect ~= nil then
      msgParam.perfect = perfect
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallAddPveCardTimesFubenCmd(addtimes, battletime, totalbattletime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.AddPveCardTimesFubenCmd()
    if addtimes ~= nil then
      msg.addtimes = addtimes
    end
    if battletime ~= nil then
      msg.battletime = battletime
    end
    if totalbattletime ~= nil then
      msg.totalbattletime = totalbattletime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddPveCardTimesFubenCmd.id
    local msgParam = {}
    if addtimes ~= nil then
      msgParam.addtimes = addtimes
    end
    if battletime ~= nil then
      msgParam.battletime = battletime
    end
    if totalbattletime ~= nil then
      msgParam.totalbattletime = totalbattletime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncPveCardOpenStateFubenCmd(passinfos)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncPveCardOpenStateFubenCmd()
    if passinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.passinfos == nil then
        msg.passinfos = {}
      end
      for i = 1, #passinfos do
        table.insert(msg.passinfos, passinfos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncPveCardOpenStateFubenCmd.id
    local msgParam = {}
    if passinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.passinfos == nil then
        msgParam.passinfos = {}
      end
      for i = 1, #passinfos do
        table.insert(msgParam.passinfos, passinfos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQuickFinishPveRaidFubenCmd(raidid, etype, bossid, use_sweep_ticket)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QuickFinishPveRaidFubenCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if bossid ~= nil then
      msg.bossid = bossid
    end
    if use_sweep_ticket ~= nil then
      msg.use_sweep_ticket = use_sweep_ticket
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuickFinishPveRaidFubenCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if bossid ~= nil then
      msgParam.bossid = bossid
    end
    if use_sweep_ticket ~= nil then
      msgParam.use_sweep_ticket = use_sweep_ticket
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncPveCardRewardTimesFubenCmd(items)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncPveCardRewardTimesFubenCmd()
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
    local msgId = ProtoReqInfoList.SyncPveCardRewardTimesFubenCmd.id
    local msgParam = {}
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

function ServiceFuBenCmdAutoProxy:CallGvgPerfectStateUpdateFubenCmd(perfect_time, perfect)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgPerfectStateUpdateFubenCmd()
    if perfect_time ~= nil and perfect_time.pause ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.perfect_time == nil then
        msg.perfect_time = {}
      end
      msg.perfect_time.pause = perfect_time.pause
    end
    if perfect_time ~= nil and perfect_time.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.perfect_time == nil then
        msg.perfect_time = {}
      end
      msg.perfect_time.time = perfect_time.time
    end
    if perfect ~= nil then
      msg.perfect = perfect
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgPerfectStateUpdateFubenCmd.id
    local msgParam = {}
    if perfect_time ~= nil and perfect_time.pause ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.perfect_time == nil then
        msgParam.perfect_time = {}
      end
      msgParam.perfect_time.pause = perfect_time.pause
    end
    if perfect_time ~= nil and perfect_time.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.perfect_time == nil then
        msgParam.perfect_time = {}
      end
      msgParam.perfect_time.time = perfect_time.time
    end
    if perfect ~= nil then
      msgParam.perfect = perfect
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryElementRaidStat(current, total, history, raidtype)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryElementRaidStat()
    if current ~= nil and current.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msg.current == nil then
        msg.current = {}
      end
      if msg.current.datas == nil then
        msg.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msg.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current == nil then
        msg.current = {}
      end
      msg.current.boss_index = current.boss_index
    end
    if total ~= nil and total.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total == nil then
        msg.total = {}
      end
      msg.total.raidid = total.raidid
    end
    if total ~= nil and total.datas ~= nil then
      if msg.total == nil then
        msg.total = {}
      end
      if msg.total.datas == nil then
        msg.total.datas = {}
      end
      for i = 1, #total.datas do
        table.insert(msg.total.datas, total.datas[i])
      end
    end
    if total ~= nil and total.boss_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total == nil then
        msg.total = {}
      end
      msg.total.boss_index = total.boss_index
    end
    if history ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.history == nil then
        msg.history = {}
      end
      for i = 1, #history do
        table.insert(msg.history, history[i])
      end
    end
    if raidtype ~= nil then
      msg.raidtype = raidtype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryElementRaidStat.id
    local msgParam = {}
    if current ~= nil and current.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.raidid = current.raidid
    end
    if current ~= nil and current.datas ~= nil then
      if msgParam.current == nil then
        msgParam.current = {}
      end
      if msgParam.current.datas == nil then
        msgParam.current.datas = {}
      end
      for i = 1, #current.datas do
        table.insert(msgParam.current.datas, current.datas[i])
      end
    end
    if current ~= nil and current.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current == nil then
        msgParam.current = {}
      end
      msgParam.current.boss_index = current.boss_index
    end
    if total ~= nil and total.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total == nil then
        msgParam.total = {}
      end
      msgParam.total.raidid = total.raidid
    end
    if total ~= nil and total.datas ~= nil then
      if msgParam.total == nil then
        msgParam.total = {}
      end
      if msgParam.total.datas == nil then
        msgParam.total.datas = {}
      end
      for i = 1, #total.datas do
        table.insert(msgParam.total.datas, total.datas[i])
      end
    end
    if total ~= nil and total.boss_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total == nil then
        msgParam.total = {}
      end
      msgParam.total.boss_index = total.boss_index
    end
    if history ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.history == nil then
        msgParam.history = {}
      end
      for i = 1, #history do
        table.insert(msgParam.history, history[i])
      end
    end
    if raidtype ~= nil then
      msgParam.raidtype = raidtype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncEmotionFactorsFuBenCmd(factors)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncEmotionFactorsFuBenCmd()
    if factors ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.factors == nil then
        msg.factors = {}
      end
      for i = 1, #factors do
        table.insert(msg.factors, factors[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncEmotionFactorsFuBenCmd.id
    local msgParam = {}
    if factors ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.factors == nil then
        msgParam.factors = {}
      end
      for i = 1, #factors do
        table.insert(msgParam.factors, factors[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncBossSceneInfo(infos)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncBossSceneInfo()
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
    local msgId = ProtoReqInfoList.SyncBossSceneInfo.id
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

function ServiceFuBenCmdAutoProxy:CallSyncUnlockRoomIDsFuBenCmd(roomids)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncUnlockRoomIDsFuBenCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncUnlockRoomIDsFuBenCmd.id
    local msgParam = {}
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncVisitNpcInfo(npctempid, charid, visit)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncVisitNpcInfo()
    if npctempid ~= nil then
      msg.npctempid = npctempid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if visit ~= nil then
      msg.visit = visit
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncVisitNpcInfo.id
    local msgParam = {}
    if npctempid ~= nil then
      msgParam.npctempid = npctempid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if visit ~= nil then
      msgParam.visit = visit
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncMonsterCountFuBenCmd(count)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncMonsterCountFuBenCmd()
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncMonsterCountFuBenCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSkipAnimationFuBenCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SkipAnimationFuBenCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkipAnimationFuBenCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallResetRaidFubenCmd(entrance_id)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ResetRaidFubenCmd()
    if entrance_id ~= nil then
      msg.entrance_id = entrance_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResetRaidFubenCmd.id
    local msgParam = {}
    if entrance_id ~= nil then
      msgParam.entrance_id = entrance_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncStarArkInfoFuBenCmd(speed, npcnum, boxnum, relivecount, begintime, length, boxtotalnum, maxspeed, fullspeed, difficulty)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncStarArkInfoFuBenCmd()
    if speed ~= nil then
      msg.speed = speed
    end
    if npcnum ~= nil then
      msg.npcnum = npcnum
    end
    if boxnum ~= nil then
      msg.boxnum = boxnum
    end
    if relivecount ~= nil then
      msg.relivecount = relivecount
    end
    if begintime ~= nil then
      msg.begintime = begintime
    end
    if length ~= nil then
      msg.length = length
    end
    if boxtotalnum ~= nil then
      msg.boxtotalnum = boxtotalnum
    end
    if maxspeed ~= nil then
      msg.maxspeed = maxspeed
    end
    if fullspeed ~= nil then
      msg.fullspeed = fullspeed
    end
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncStarArkInfoFuBenCmd.id
    local msgParam = {}
    if speed ~= nil then
      msgParam.speed = speed
    end
    if npcnum ~= nil then
      msgParam.npcnum = npcnum
    end
    if boxnum ~= nil then
      msgParam.boxnum = boxnum
    end
    if relivecount ~= nil then
      msgParam.relivecount = relivecount
    end
    if begintime ~= nil then
      msgParam.begintime = begintime
    end
    if length ~= nil then
      msgParam.length = length
    end
    if boxtotalnum ~= nil then
      msgParam.boxtotalnum = boxtotalnum
    end
    if maxspeed ~= nil then
      msgParam.maxspeed = maxspeed
    end
    if fullspeed ~= nil then
      msgParam.fullspeed = fullspeed
    end
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncStarArkStatisticsFuBenCmd(sailingtime, sailingaddscore, boxleftnum, boxtotalnum, boxdecscore, relivecount, relivedecscore, grade, fightinfo, difficulty)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncStarArkStatisticsFuBenCmd()
    if sailingtime ~= nil then
      msg.sailingtime = sailingtime
    end
    if sailingaddscore ~= nil then
      msg.sailingaddscore = sailingaddscore
    end
    if boxleftnum ~= nil then
      msg.boxleftnum = boxleftnum
    end
    if boxtotalnum ~= nil then
      msg.boxtotalnum = boxtotalnum
    end
    if boxdecscore ~= nil then
      msg.boxdecscore = boxdecscore
    end
    if relivecount ~= nil then
      msg.relivecount = relivecount
    end
    if relivedecscore ~= nil then
      msg.relivedecscore = relivedecscore
    end
    if grade ~= nil then
      msg.grade = grade
    end
    if fightinfo ~= nil and fightinfo.damage ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      msg.fightinfo.damage = fightinfo.damage
    end
    if fightinfo ~= nil and fightinfo.heal ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      msg.fightinfo.heal = fightinfo.heal
    end
    if fightinfo ~= nil and fightinfo.suffer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      msg.fightinfo.suffer = fightinfo.suffer
    end
    if fightinfo ~= nil and fightinfo.damgename ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      msg.fightinfo.damgename = fightinfo.damgename
    end
    if fightinfo ~= nil and fightinfo.healname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      msg.fightinfo.healname = fightinfo.healname
    end
    if fightinfo ~= nil and fightinfo.suffername ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      msg.fightinfo.suffername = fightinfo.suffername
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.charid ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.charid = fightinfo.mvpuserinfo.charid
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildid ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.guildid = fightinfo.mvpuserinfo.guildid
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.accid ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.accid = fightinfo.mvpuserinfo.accid
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.name ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.name = fightinfo.mvpuserinfo.name
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildname ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.guildname = fightinfo.mvpuserinfo.guildname
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildportrait ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.guildportrait = fightinfo.mvpuserinfo.guildportrait
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildjob ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.guildjob = fightinfo.mvpuserinfo.guildjob
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.datas ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.datas == nil then
        msg.fightinfo.mvpuserinfo.datas = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.datas do
        table.insert(msg.fightinfo.mvpuserinfo.datas, fightinfo.mvpuserinfo.datas[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.attrs ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.attrs == nil then
        msg.fightinfo.mvpuserinfo.attrs = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.attrs do
        table.insert(msg.fightinfo.mvpuserinfo.attrs, fightinfo.mvpuserinfo.attrs[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.equip ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.equip == nil then
        msg.fightinfo.mvpuserinfo.equip = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.equip do
        table.insert(msg.fightinfo.mvpuserinfo.equip, fightinfo.mvpuserinfo.equip[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.fashion ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.fashion == nil then
        msg.fightinfo.mvpuserinfo.fashion = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.fashion do
        table.insert(msg.fightinfo.mvpuserinfo.fashion, fightinfo.mvpuserinfo.fashion[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.shadow ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.shadow == nil then
        msg.fightinfo.mvpuserinfo.shadow = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.shadow do
        table.insert(msg.fightinfo.mvpuserinfo.shadow, fightinfo.mvpuserinfo.shadow[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.extraction ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.extraction == nil then
        msg.fightinfo.mvpuserinfo.extraction = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.extraction do
        table.insert(msg.fightinfo.mvpuserinfo.extraction, fightinfo.mvpuserinfo.extraction[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.highrefine ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.highrefine == nil then
        msg.fightinfo.mvpuserinfo.highrefine = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.highrefine do
        table.insert(msg.fightinfo.mvpuserinfo.highrefine, fightinfo.mvpuserinfo.highrefine[i])
      end
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.partner ~= nil then
      if msg.fightinfo == nil then
        msg.fightinfo = {}
      end
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      msg.fightinfo.mvpuserinfo.partner = fightinfo.mvpuserinfo.partner
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.id ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.mercenary == nil then
        msg.fightinfo.mvpuserinfo.mercenary = {}
      end
      msg.fightinfo.mvpuserinfo.mercenary.id = fightinfo.mvpuserinfo.mercenary.id
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.name ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.mercenary == nil then
        msg.fightinfo.mvpuserinfo.mercenary = {}
      end
      msg.fightinfo.mvpuserinfo.mercenary.name = fightinfo.mvpuserinfo.mercenary.name
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.icon ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.mercenary == nil then
        msg.fightinfo.mvpuserinfo.mercenary = {}
      end
      msg.fightinfo.mvpuserinfo.mercenary.icon = fightinfo.mvpuserinfo.mercenary.icon
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.job ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.mercenary == nil then
        msg.fightinfo.mvpuserinfo.mercenary = {}
      end
      msg.fightinfo.mvpuserinfo.mercenary.job = fightinfo.mvpuserinfo.mercenary.job
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.mercenary == nil then
        msg.fightinfo.mvpuserinfo.mercenary = {}
      end
      msg.fightinfo.mvpuserinfo.mercenary.mercenary_name = fightinfo.mvpuserinfo.mercenary.mercenary_name
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.memory_pos ~= nil then
      if msg.fightinfo.mvpuserinfo == nil then
        msg.fightinfo.mvpuserinfo = {}
      end
      if msg.fightinfo.mvpuserinfo.memory_pos == nil then
        msg.fightinfo.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.memory_pos do
        table.insert(msg.fightinfo.mvpuserinfo.memory_pos, fightinfo.mvpuserinfo.memory_pos[i])
      end
    end
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncStarArkStatisticsFuBenCmd.id
    local msgParam = {}
    if sailingtime ~= nil then
      msgParam.sailingtime = sailingtime
    end
    if sailingaddscore ~= nil then
      msgParam.sailingaddscore = sailingaddscore
    end
    if boxleftnum ~= nil then
      msgParam.boxleftnum = boxleftnum
    end
    if boxtotalnum ~= nil then
      msgParam.boxtotalnum = boxtotalnum
    end
    if boxdecscore ~= nil then
      msgParam.boxdecscore = boxdecscore
    end
    if relivecount ~= nil then
      msgParam.relivecount = relivecount
    end
    if relivedecscore ~= nil then
      msgParam.relivedecscore = relivedecscore
    end
    if grade ~= nil then
      msgParam.grade = grade
    end
    if fightinfo ~= nil and fightinfo.damage ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      msgParam.fightinfo.damage = fightinfo.damage
    end
    if fightinfo ~= nil and fightinfo.heal ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      msgParam.fightinfo.heal = fightinfo.heal
    end
    if fightinfo ~= nil and fightinfo.suffer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      msgParam.fightinfo.suffer = fightinfo.suffer
    end
    if fightinfo ~= nil and fightinfo.damgename ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      msgParam.fightinfo.damgename = fightinfo.damgename
    end
    if fightinfo ~= nil and fightinfo.healname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      msgParam.fightinfo.healname = fightinfo.healname
    end
    if fightinfo ~= nil and fightinfo.suffername ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      msgParam.fightinfo.suffername = fightinfo.suffername
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.charid ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.charid = fightinfo.mvpuserinfo.charid
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildid ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.guildid = fightinfo.mvpuserinfo.guildid
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.accid ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.accid = fightinfo.mvpuserinfo.accid
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.name ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.name = fightinfo.mvpuserinfo.name
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildname ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.guildname = fightinfo.mvpuserinfo.guildname
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildportrait ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.guildportrait = fightinfo.mvpuserinfo.guildportrait
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.guildjob ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.guildjob = fightinfo.mvpuserinfo.guildjob
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.datas ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.datas == nil then
        msgParam.fightinfo.mvpuserinfo.datas = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.datas do
        table.insert(msgParam.fightinfo.mvpuserinfo.datas, fightinfo.mvpuserinfo.datas[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.attrs ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.attrs == nil then
        msgParam.fightinfo.mvpuserinfo.attrs = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.attrs do
        table.insert(msgParam.fightinfo.mvpuserinfo.attrs, fightinfo.mvpuserinfo.attrs[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.equip ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.equip == nil then
        msgParam.fightinfo.mvpuserinfo.equip = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.equip do
        table.insert(msgParam.fightinfo.mvpuserinfo.equip, fightinfo.mvpuserinfo.equip[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.fashion ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.fashion == nil then
        msgParam.fightinfo.mvpuserinfo.fashion = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.fashion do
        table.insert(msgParam.fightinfo.mvpuserinfo.fashion, fightinfo.mvpuserinfo.fashion[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.shadow ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.shadow == nil then
        msgParam.fightinfo.mvpuserinfo.shadow = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.shadow do
        table.insert(msgParam.fightinfo.mvpuserinfo.shadow, fightinfo.mvpuserinfo.shadow[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.extraction ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.extraction == nil then
        msgParam.fightinfo.mvpuserinfo.extraction = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.extraction do
        table.insert(msgParam.fightinfo.mvpuserinfo.extraction, fightinfo.mvpuserinfo.extraction[i])
      end
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.highrefine ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.highrefine == nil then
        msgParam.fightinfo.mvpuserinfo.highrefine = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.highrefine do
        table.insert(msgParam.fightinfo.mvpuserinfo.highrefine, fightinfo.mvpuserinfo.highrefine[i])
      end
    end
    if fightinfo.mvpuserinfo ~= nil and fightinfo.mvpuserinfo.partner ~= nil then
      if msgParam.fightinfo == nil then
        msgParam.fightinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      msgParam.fightinfo.mvpuserinfo.partner = fightinfo.mvpuserinfo.partner
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.id ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.mercenary == nil then
        msgParam.fightinfo.mvpuserinfo.mercenary = {}
      end
      msgParam.fightinfo.mvpuserinfo.mercenary.id = fightinfo.mvpuserinfo.mercenary.id
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.name ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.mercenary == nil then
        msgParam.fightinfo.mvpuserinfo.mercenary = {}
      end
      msgParam.fightinfo.mvpuserinfo.mercenary.name = fightinfo.mvpuserinfo.mercenary.name
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.icon ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.mercenary == nil then
        msgParam.fightinfo.mvpuserinfo.mercenary = {}
      end
      msgParam.fightinfo.mvpuserinfo.mercenary.icon = fightinfo.mvpuserinfo.mercenary.icon
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.job ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.mercenary == nil then
        msgParam.fightinfo.mvpuserinfo.mercenary = {}
      end
      msgParam.fightinfo.mvpuserinfo.mercenary.job = fightinfo.mvpuserinfo.mercenary.job
    end
    if fightinfo.mvpuserinfo.mercenary ~= nil and fightinfo.mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.mercenary == nil then
        msgParam.fightinfo.mvpuserinfo.mercenary = {}
      end
      msgParam.fightinfo.mvpuserinfo.mercenary.mercenary_name = fightinfo.mvpuserinfo.mercenary.mercenary_name
    end
    if fightinfo ~= nil and fightinfo.mvpuserinfo.memory_pos ~= nil then
      if msgParam.fightinfo.mvpuserinfo == nil then
        msgParam.fightinfo.mvpuserinfo = {}
      end
      if msgParam.fightinfo.mvpuserinfo.memory_pos == nil then
        msgParam.fightinfo.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #fightinfo.mvpuserinfo.memory_pos do
        table.insert(msgParam.fightinfo.mvpuserinfo.memory_pos, fightinfo.mvpuserinfo.memory_pos[i])
      end
    end
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallOpenNtfFuBenCmd(raidtype)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.OpenNtfFuBenCmd()
    if raidtype ~= nil then
      msg.raidtype = raidtype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenNtfFuBenCmd.id
    local msgParam = {}
    if raidtype ~= nil then
      msgParam.raidtype = raidtype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRoadblocksChangeFubenCmd(roadblock)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RoadblocksChangeFubenCmd()
    if roadblock ~= nil then
      msg.roadblock = roadblock
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoadblocksChangeFubenCmd.id
    local msgParam = {}
    if roadblock ~= nil then
      msgParam.roadblock = roadblock
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncPassUserInfo(branch, data)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncPassUserInfo()
    if branch ~= nil then
      msg.branch = branch
    end
    if data ~= nil and data.data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.data = data.data
    end
    if data ~= nil and data.first ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.first = data.first
    end
    if data ~= nil and data.over ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.over = data.over
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
    if data ~= nil and data.processid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.processid = data.processid
    end
    if data ~= nil and data.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.time = data.time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncPassUserInfo.id
    local msgParam = {}
    if branch ~= nil then
      msgParam.branch = branch
    end
    if data ~= nil and data.data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.data = data.data
    end
    if data ~= nil and data.first ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.first = data.first
    end
    if data ~= nil and data.over ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.over = data.over
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
    if data ~= nil and data.processid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.processid = data.processid
    end
    if data ~= nil and data.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.time = data.time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTripleFireInfoFuBenCmd(camps, mvpuserinfo, isfinish, wincamp, isrelax)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTripleFireInfoFuBenCmd()
    if camps ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camps == nil then
        msg.camps = {}
      end
      for i = 1, #camps do
        table.insert(msg.camps, camps[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.charid = mvpuserinfo.charid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildid = mvpuserinfo.guildid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.accid = mvpuserinfo.accid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.name = mvpuserinfo.name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildname = mvpuserinfo.guildname
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildportrait = mvpuserinfo.guildportrait
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildjob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.guildjob = mvpuserinfo.guildjob
    end
    if mvpuserinfo ~= nil and mvpuserinfo.datas ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.datas == nil then
        msg.mvpuserinfo.datas = {}
      end
      for i = 1, #mvpuserinfo.datas do
        table.insert(msg.mvpuserinfo.datas, mvpuserinfo.datas[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.attrs ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.attrs == nil then
        msg.mvpuserinfo.attrs = {}
      end
      for i = 1, #mvpuserinfo.attrs do
        table.insert(msg.mvpuserinfo.attrs, mvpuserinfo.attrs[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.equip ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.equip == nil then
        msg.mvpuserinfo.equip = {}
      end
      for i = 1, #mvpuserinfo.equip do
        table.insert(msg.mvpuserinfo.equip, mvpuserinfo.equip[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.fashion ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.fashion == nil then
        msg.mvpuserinfo.fashion = {}
      end
      for i = 1, #mvpuserinfo.fashion do
        table.insert(msg.mvpuserinfo.fashion, mvpuserinfo.fashion[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.shadow ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.shadow == nil then
        msg.mvpuserinfo.shadow = {}
      end
      for i = 1, #mvpuserinfo.shadow do
        table.insert(msg.mvpuserinfo.shadow, mvpuserinfo.shadow[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.extraction ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.extraction == nil then
        msg.mvpuserinfo.extraction = {}
      end
      for i = 1, #mvpuserinfo.extraction do
        table.insert(msg.mvpuserinfo.extraction, mvpuserinfo.extraction[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.highrefine ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.highrefine == nil then
        msg.mvpuserinfo.highrefine = {}
      end
      for i = 1, #mvpuserinfo.highrefine do
        table.insert(msg.mvpuserinfo.highrefine, mvpuserinfo.highrefine[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.partner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      msg.mvpuserinfo.partner = mvpuserinfo.partner
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.id ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.id = mvpuserinfo.mercenary.id
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.name ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.name = mvpuserinfo.mercenary.name
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.icon ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.icon = mvpuserinfo.mercenary.icon
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.job ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.job = mvpuserinfo.mercenary.job
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.mercenary == nil then
        msg.mvpuserinfo.mercenary = {}
      end
      msg.mvpuserinfo.mercenary.mercenary_name = mvpuserinfo.mercenary.mercenary_name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.memory_pos ~= nil then
      if msg.mvpuserinfo == nil then
        msg.mvpuserinfo = {}
      end
      if msg.mvpuserinfo.memory_pos == nil then
        msg.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #mvpuserinfo.memory_pos do
        table.insert(msg.mvpuserinfo.memory_pos, mvpuserinfo.memory_pos[i])
      end
    end
    if isfinish ~= nil then
      msg.isfinish = isfinish
    end
    if wincamp ~= nil then
      msg.wincamp = wincamp
    end
    if isrelax ~= nil then
      msg.isrelax = isrelax
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTripleFireInfoFuBenCmd.id
    local msgParam = {}
    if camps ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camps == nil then
        msgParam.camps = {}
      end
      for i = 1, #camps do
        table.insert(msgParam.camps, camps[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.charid = mvpuserinfo.charid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildid = mvpuserinfo.guildid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.accid = mvpuserinfo.accid
    end
    if mvpuserinfo ~= nil and mvpuserinfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.name = mvpuserinfo.name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildname = mvpuserinfo.guildname
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildportrait = mvpuserinfo.guildportrait
    end
    if mvpuserinfo ~= nil and mvpuserinfo.guildjob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.guildjob = mvpuserinfo.guildjob
    end
    if mvpuserinfo ~= nil and mvpuserinfo.datas ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.datas == nil then
        msgParam.mvpuserinfo.datas = {}
      end
      for i = 1, #mvpuserinfo.datas do
        table.insert(msgParam.mvpuserinfo.datas, mvpuserinfo.datas[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.attrs ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.attrs == nil then
        msgParam.mvpuserinfo.attrs = {}
      end
      for i = 1, #mvpuserinfo.attrs do
        table.insert(msgParam.mvpuserinfo.attrs, mvpuserinfo.attrs[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.equip ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.equip == nil then
        msgParam.mvpuserinfo.equip = {}
      end
      for i = 1, #mvpuserinfo.equip do
        table.insert(msgParam.mvpuserinfo.equip, mvpuserinfo.equip[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.fashion ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.fashion == nil then
        msgParam.mvpuserinfo.fashion = {}
      end
      for i = 1, #mvpuserinfo.fashion do
        table.insert(msgParam.mvpuserinfo.fashion, mvpuserinfo.fashion[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.shadow ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.shadow == nil then
        msgParam.mvpuserinfo.shadow = {}
      end
      for i = 1, #mvpuserinfo.shadow do
        table.insert(msgParam.mvpuserinfo.shadow, mvpuserinfo.shadow[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.extraction ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.extraction == nil then
        msgParam.mvpuserinfo.extraction = {}
      end
      for i = 1, #mvpuserinfo.extraction do
        table.insert(msgParam.mvpuserinfo.extraction, mvpuserinfo.extraction[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.highrefine ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.highrefine == nil then
        msgParam.mvpuserinfo.highrefine = {}
      end
      for i = 1, #mvpuserinfo.highrefine do
        table.insert(msgParam.mvpuserinfo.highrefine, mvpuserinfo.highrefine[i])
      end
    end
    if mvpuserinfo ~= nil and mvpuserinfo.partner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      msgParam.mvpuserinfo.partner = mvpuserinfo.partner
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.id ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.id = mvpuserinfo.mercenary.id
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.name ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.name = mvpuserinfo.mercenary.name
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.icon ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.icon = mvpuserinfo.mercenary.icon
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.job ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.job = mvpuserinfo.mercenary.job
    end
    if mvpuserinfo.mercenary ~= nil and mvpuserinfo.mercenary.mercenary_name ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.mercenary == nil then
        msgParam.mvpuserinfo.mercenary = {}
      end
      msgParam.mvpuserinfo.mercenary.mercenary_name = mvpuserinfo.mercenary.mercenary_name
    end
    if mvpuserinfo ~= nil and mvpuserinfo.memory_pos ~= nil then
      if msgParam.mvpuserinfo == nil then
        msgParam.mvpuserinfo = {}
      end
      if msgParam.mvpuserinfo.memory_pos == nil then
        msgParam.mvpuserinfo.memory_pos = {}
      end
      for i = 1, #mvpuserinfo.memory_pos do
        table.insert(msgParam.mvpuserinfo.memory_pos, mvpuserinfo.memory_pos[i])
      end
    end
    if isfinish ~= nil then
      msgParam.isfinish = isfinish
    end
    if wincamp ~= nil then
      msgParam.wincamp = wincamp
    end
    if isrelax ~= nil then
      msgParam.isrelax = isrelax
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTripleComboKillFuBenCmd(killerinfo, sufferinfo)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTripleComboKillFuBenCmd()
    if killerinfo ~= nil and killerinfo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.killerinfo == nil then
        msg.killerinfo = {}
      end
      msg.killerinfo.charid = killerinfo.charid
    end
    if killerinfo ~= nil and killerinfo.combo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.killerinfo == nil then
        msg.killerinfo = {}
      end
      msg.killerinfo.combo = killerinfo.combo
    end
    if killerinfo ~= nil and killerinfo.lifekillnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.killerinfo == nil then
        msg.killerinfo = {}
      end
      msg.killerinfo.lifekillnum = killerinfo.lifekillnum
    end
    if sufferinfo ~= nil and sufferinfo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sufferinfo == nil then
        msg.sufferinfo = {}
      end
      msg.sufferinfo.charid = sufferinfo.charid
    end
    if sufferinfo ~= nil and sufferinfo.combo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sufferinfo == nil then
        msg.sufferinfo = {}
      end
      msg.sufferinfo.combo = sufferinfo.combo
    end
    if sufferinfo ~= nil and sufferinfo.lifekillnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sufferinfo == nil then
        msg.sufferinfo = {}
      end
      msg.sufferinfo.lifekillnum = sufferinfo.lifekillnum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTripleComboKillFuBenCmd.id
    local msgParam = {}
    if killerinfo ~= nil and killerinfo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.killerinfo == nil then
        msgParam.killerinfo = {}
      end
      msgParam.killerinfo.charid = killerinfo.charid
    end
    if killerinfo ~= nil and killerinfo.combo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.killerinfo == nil then
        msgParam.killerinfo = {}
      end
      msgParam.killerinfo.combo = killerinfo.combo
    end
    if killerinfo ~= nil and killerinfo.lifekillnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.killerinfo == nil then
        msgParam.killerinfo = {}
      end
      msgParam.killerinfo.lifekillnum = killerinfo.lifekillnum
    end
    if sufferinfo ~= nil and sufferinfo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sufferinfo == nil then
        msgParam.sufferinfo = {}
      end
      msgParam.sufferinfo.charid = sufferinfo.charid
    end
    if sufferinfo ~= nil and sufferinfo.combo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sufferinfo == nil then
        msgParam.sufferinfo = {}
      end
      msgParam.sufferinfo.combo = sufferinfo.combo
    end
    if sufferinfo ~= nil and sufferinfo.lifekillnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sufferinfo == nil then
        msgParam.sufferinfo = {}
      end
      msgParam.sufferinfo.lifekillnum = sufferinfo.lifekillnum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTriplePlayerModelFuBenCmd(myteam, otherteams)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTriplePlayerModelFuBenCmd()
    if myteam ~= nil and myteam.ecamp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.myteam == nil then
        msg.myteam = {}
      end
      msg.myteam.ecamp = myteam.ecamp
    end
    if myteam ~= nil and myteam.userinfos ~= nil then
      if msg.myteam == nil then
        msg.myteam = {}
      end
      if msg.myteam.userinfos == nil then
        msg.myteam.userinfos = {}
      end
      for i = 1, #myteam.userinfos do
        table.insert(msg.myteam.userinfos, myteam.userinfos[i])
      end
    end
    if otherteams ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.otherteams == nil then
        msg.otherteams = {}
      end
      for i = 1, #otherteams do
        table.insert(msg.otherteams, otherteams[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTriplePlayerModelFuBenCmd.id
    local msgParam = {}
    if myteam ~= nil and myteam.ecamp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.myteam == nil then
        msgParam.myteam = {}
      end
      msgParam.myteam.ecamp = myteam.ecamp
    end
    if myteam ~= nil and myteam.userinfos ~= nil then
      if msgParam.myteam == nil then
        msgParam.myteam = {}
      end
      if msgParam.myteam.userinfos == nil then
        msgParam.myteam.userinfos = {}
      end
      for i = 1, #myteam.userinfos do
        table.insert(msgParam.myteam.userinfos, myteam.userinfos[i])
      end
    end
    if otherteams ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.otherteams == nil then
        msgParam.otherteams = {}
      end
      for i = 1, #otherteams do
        table.insert(msgParam.otherteams, otherteams[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTripleProfessionTimeFuBenCmd(phase_end_time, close, profession_begin_time, fire_begin_time)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTripleProfessionTimeFuBenCmd()
    if phase_end_time ~= nil then
      msg.phase_end_time = phase_end_time
    end
    if close ~= nil then
      msg.close = close
    end
    if profession_begin_time ~= nil then
      msg.profession_begin_time = profession_begin_time
    end
    if fire_begin_time ~= nil then
      msg.fire_begin_time = fire_begin_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTripleProfessionTimeFuBenCmd.id
    local msgParam = {}
    if phase_end_time ~= nil then
      msgParam.phase_end_time = phase_end_time
    end
    if close ~= nil then
      msgParam.close = close
    end
    if profession_begin_time ~= nil then
      msgParam.profession_begin_time = profession_begin_time
    end
    if fire_begin_time ~= nil then
      msgParam.fire_begin_time = fire_begin_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTripleCampInfoFuBenCmd(camps, endtime, isrelax)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTripleCampInfoFuBenCmd()
    if camps ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camps == nil then
        msg.camps = {}
      end
      for i = 1, #camps do
        table.insert(msg.camps, camps[i])
      end
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if isrelax ~= nil then
      msg.isrelax = isrelax
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTripleCampInfoFuBenCmd.id
    local msgParam = {}
    if camps ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camps == nil then
        msgParam.camps = {}
      end
      for i = 1, #camps do
        table.insert(msgParam.camps, camps[i])
      end
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if isrelax ~= nil then
      msgParam.isrelax = isrelax
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTripleEnterCountFuBenCmd(datas)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTripleEnterCountFuBenCmd()
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
    local msgId = ProtoReqInfoList.SyncTripleEnterCountFuBenCmd.id
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

function ServiceFuBenCmdAutoProxy:CallChooseCurProfessionFuBenCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ChooseCurProfessionFuBenCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChooseCurProfessionFuBenCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncTripleFightingInfoFuBenCmd(camps)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncTripleFightingInfoFuBenCmd()
    if camps ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camps == nil then
        msg.camps = {}
      end
      for i = 1, #camps do
        table.insert(msg.camps, camps[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTripleFightingInfoFuBenCmd.id
    local msgParam = {}
    if camps ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camps == nil then
        msgParam.camps = {}
      end
      for i = 1, #camps do
        table.insert(msgParam.camps, camps[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncFullFireStateFubenCmd(fullfire)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncFullFireStateFubenCmd()
    if fullfire ~= nil then
      msg.fullfire = fullfire
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncFullFireStateFubenCmd.id
    local msgParam = {}
    if fullfire ~= nil then
      msgParam.fullfire = fullfire
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallEBFEventDataUpdateCmd(datas, all_sync)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.EBFEventDataUpdateCmd()
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
    if all_sync ~= nil then
      msg.all_sync = all_sync
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EBFEventDataUpdateCmd.id
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
    if all_sync ~= nil then
      msgParam.all_sync = all_sync
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallEBFMiscDataUpdate(state, next_event_time, next_event_id, score_human, score_vampire)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.EBFMiscDataUpdate()
    if state ~= nil then
      msg.state = state
    end
    if next_event_time ~= nil then
      msg.next_event_time = next_event_time
    end
    if next_event_id ~= nil then
      msg.next_event_id = next_event_id
    end
    if score_human ~= nil then
      msg.score_human = score_human
    end
    if score_vampire ~= nil then
      msg.score_vampire = score_vampire
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EBFMiscDataUpdate.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    if next_event_time ~= nil then
      msgParam.next_event_time = next_event_time
    end
    if next_event_id ~= nil then
      msgParam.next_event_id = next_event_id
    end
    if score_human ~= nil then
      msgParam.score_human = score_human
    end
    if score_vampire ~= nil then
      msgParam.score_vampire = score_vampire
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallOccupyPointDataUpdate(update_datas, del_points)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.OccupyPointDataUpdate()
    if update_datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update_datas == nil then
        msg.update_datas = {}
      end
      for i = 1, #update_datas do
        table.insert(msg.update_datas, update_datas[i])
      end
    end
    if del_points ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_points == nil then
        msg.del_points = {}
      end
      for i = 1, #del_points do
        table.insert(msg.del_points, del_points[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OccupyPointDataUpdate.id
    local msgParam = {}
    if update_datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update_datas == nil then
        msgParam.update_datas = {}
      end
      for i = 1, #update_datas do
        table.insert(msgParam.update_datas, update_datas[i])
      end
    end
    if del_points ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_points == nil then
        msgParam.del_points = {}
      end
      for i = 1, #del_points do
        table.insert(msgParam.del_points, del_points[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallQueryPvpStatCmd(stats)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.QueryPvpStatCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPvpStatCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallEBFKickTimeCmd(kick_time)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.EBFKickTimeCmd()
    if kick_time ~= nil then
      msg.kick_time = kick_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EBFKickTimeCmd.id
    local msgParam = {}
    if kick_time ~= nil then
      msgParam.kick_time = kick_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallEBFContinueCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.EBFContinueCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EBFContinueCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallEBFEventAreaUpdateCmd(is_enter, event_id)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.EBFEventAreaUpdateCmd()
    if is_enter ~= nil then
      msg.is_enter = is_enter
    end
    if event_id ~= nil then
      msg.event_id = event_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EBFEventAreaUpdateCmd.id
    local msgParam = {}
    if is_enter ~= nil then
      msgParam.is_enter = is_enter
    end
    if event_id ~= nil then
      msgParam.event_id = event_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallAstralInfoSyncCmd(kill_limit_time, round, total_monster, left_monster, pray_profession_num, pray_profession_group, pray_id, boss_ids)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.AstralInfoSyncCmd()
    if kill_limit_time ~= nil then
      msg.kill_limit_time = kill_limit_time
    end
    if round ~= nil then
      msg.round = round
    end
    if total_monster ~= nil then
      msg.total_monster = total_monster
    end
    if left_monster ~= nil then
      msg.left_monster = left_monster
    end
    if pray_profession_num ~= nil then
      msg.pray_profession_num = pray_profession_num
    end
    if pray_profession_group ~= nil then
      msg.pray_profession_group = pray_profession_group
    end
    if pray_id ~= nil then
      msg.pray_id = pray_id
    end
    if boss_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.boss_ids == nil then
        msg.boss_ids = {}
      end
      for i = 1, #boss_ids do
        table.insert(msg.boss_ids, boss_ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstralInfoSyncCmd.id
    local msgParam = {}
    if kill_limit_time ~= nil then
      msgParam.kill_limit_time = kill_limit_time
    end
    if round ~= nil then
      msgParam.round = round
    end
    if total_monster ~= nil then
      msgParam.total_monster = total_monster
    end
    if left_monster ~= nil then
      msgParam.left_monster = left_monster
    end
    if pray_profession_num ~= nil then
      msgParam.pray_profession_num = pray_profession_num
    end
    if pray_profession_group ~= nil then
      msgParam.pray_profession_group = pray_profession_group
    end
    if pray_id ~= nil then
      msgParam.pray_id = pray_id
    end
    if boss_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.boss_ids == nil then
        msgParam.boss_ids = {}
      end
      for i = 1, #boss_ids do
        table.insert(msgParam.boss_ids, boss_ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgMvpInfoUpdateCmd(hp_per, state)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgMvpInfoUpdateCmd()
    if hp_per ~= nil then
      msg.hp_per = hp_per
    end
    if state ~= nil then
      msg.state = state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgMvpInfoUpdateCmd.id
    local msgParam = {}
    if hp_per ~= nil then
      msgParam.hp_per = hp_per
    end
    if state ~= nil then
      msgParam.state = state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallAstralPrayBranchSyncCmd(groups)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.AstralPrayBranchSyncCmd()
    if groups ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groups == nil then
        msg.groups = {}
      end
      for i = 1, #groups do
        table.insert(msg.groups, groups[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstralPrayBranchSyncCmd.id
    local msgParam = {}
    if groups ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groups == nil then
        msgParam.groups = {}
      end
      for i = 1, #groups do
        table.insert(msgParam.groups, groups[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncStartFightStateCmd(barstate)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncStartFightStateCmd()
    if barstate ~= nil then
      msg.barstate = barstate
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncStartFightStateCmd.id
    local msgParam = {}
    if barstate ~= nil then
      msgParam.barstate = barstate
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncGvgFightPointCmd(fight_points)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncGvgFightPointCmd()
    if fight_points ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fight_points == nil then
        msg.fight_points = {}
      end
      for i = 1, #fight_points do
        table.insert(msg.fight_points, fight_points[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncGvgFightPointCmd.id
    local msgParam = {}
    if fight_points ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fight_points == nil then
        msgParam.fight_points = {}
      end
      for i = 1, #fight_points do
        table.insert(msgParam.fight_points, fight_points[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncGvgLeaderPosCmd(guild_leader_pos)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncGvgLeaderPosCmd()
    if guild_leader_pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guild_leader_pos == nil then
        msg.guild_leader_pos = {}
      end
      for i = 1, #guild_leader_pos do
        table.insert(msg.guild_leader_pos, guild_leader_pos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncGvgLeaderPosCmd.id
    local msgParam = {}
    if guild_leader_pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guild_leader_pos == nil then
        msgParam.guild_leader_pos = {}
      end
      for i = 1, #guild_leader_pos do
        table.insert(msgParam.guild_leader_pos, guild_leader_pos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTISyncScoreCmd(score)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STISyncScoreCmd()
    if score ~= nil then
      msg.score = score
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STISyncScoreCmd.id
    local msgParam = {}
    if score ~= nil then
      msgParam.score = score
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTISyncSkillCmd(current_skills)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STISyncSkillCmd()
    if current_skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.current_skills == nil then
        msg.current_skills = {}
      end
      for i = 1, #current_skills do
        table.insert(msg.current_skills, current_skills[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STISyncSkillCmd.id
    local msgParam = {}
    if current_skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.current_skills == nil then
        msgParam.current_skills = {}
      end
      for i = 1, #current_skills do
        table.insert(msgParam.current_skills, current_skills[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTISyncAvailableUpgradeNumberCmd(available_upgrade_number)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STISyncAvailableUpgradeNumberCmd()
    if available_upgrade_number ~= nil then
      msg.available_upgrade_number = available_upgrade_number
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STISyncAvailableUpgradeNumberCmd.id
    local msgParam = {}
    if available_upgrade_number ~= nil then
      msgParam.available_upgrade_number = available_upgrade_number
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTIGetUpgradeOptionsCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STIGetUpgradeOptionsCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STIGetUpgradeOptionsCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTIRetUpgradeOptionsCmd(skill_options, available_refresh_all_skill_number)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STIRetUpgradeOptionsCmd()
    if skill_options ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skill_options == nil then
        msg.skill_options = {}
      end
      for i = 1, #skill_options do
        table.insert(msg.skill_options, skill_options[i])
      end
    end
    if available_refresh_all_skill_number ~= nil then
      msg.available_refresh_all_skill_number = available_refresh_all_skill_number
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STIRetUpgradeOptionsCmd.id
    local msgParam = {}
    if skill_options ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skill_options == nil then
        msgParam.skill_options = {}
      end
      for i = 1, #skill_options do
        table.insert(msgParam.skill_options, skill_options[i])
      end
    end
    if available_refresh_all_skill_number ~= nil then
      msgParam.available_refresh_all_skill_number = available_refresh_all_skill_number
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTIExecSkillUpgradeCmd(slot_index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STIExecSkillUpgradeCmd()
    if slot_index ~= nil then
      msg.slot_index = slot_index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STIExecSkillUpgradeCmd.id
    local msgParam = {}
    if slot_index ~= nil then
      msgParam.slot_index = slot_index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncSpaceTimeIllusionInfoFuBenCmd(turn, count, endtime, affixids)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncSpaceTimeIllusionInfoFuBenCmd()
    if turn ~= nil then
      msg.turn = turn
    end
    if count ~= nil then
      msg.count = count
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if affixids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.affixids == nil then
        msg.affixids = {}
      end
      for i = 1, #affixids do
        table.insert(msg.affixids, affixids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncSpaceTimeIllusionInfoFuBenCmd.id
    local msgParam = {}
    if turn ~= nil then
      msgParam.turn = turn
    end
    if count ~= nil then
      msgParam.count = count
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if affixids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.affixids == nil then
        msgParam.affixids = {}
      end
      for i = 1, #affixids do
        table.insert(msgParam.affixids, affixids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncSpaceTimeIllusionExpLevelFuBenCmd(curlevel, curexp, needexp)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncSpaceTimeIllusionExpLevelFuBenCmd()
    if curlevel ~= nil then
      msg.curlevel = curlevel
    end
    if curexp ~= nil then
      msg.curexp = curexp
    end
    if needexp ~= nil then
      msg.needexp = needexp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncSpaceTimeIllusionExpLevelFuBenCmd.id
    local msgParam = {}
    if curlevel ~= nil then
      msgParam.curlevel = curlevel
    end
    if curexp ~= nil then
      msgParam.curexp = curexp
    end
    if needexp ~= nil then
      msgParam.needexp = needexp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTIRefreshUpgradeOptionsCmd(slot_index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STIRefreshUpgradeOptionsCmd()
    if slot_index ~= nil then
      msg.slot_index = slot_index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STIRefreshUpgradeOptionsCmd.id
    local msgParam = {}
    if slot_index ~= nil then
      msgParam.slot_index = slot_index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSTIDropSkillCmd(skill_id)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.STIDropSkillCmd()
    if skill_id ~= nil then
      msg.skill_id = skill_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.STIDropSkillCmd.id
    local msgParam = {}
    if skill_id ~= nil then
      msgParam.skill_id = skill_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFairyTaleRaidSyncCmd(train_arrival_count, train_damaged_count, next_wave_type, next_wave_time)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FairyTaleRaidSyncCmd()
    if train_arrival_count ~= nil then
      msg.train_arrival_count = train_arrival_count
    end
    if train_damaged_count ~= nil then
      msg.train_damaged_count = train_damaged_count
    end
    if next_wave_type ~= nil then
      msg.next_wave_type = next_wave_type
    end
    if next_wave_time ~= nil then
      msg.next_wave_time = next_wave_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FairyTaleRaidSyncCmd.id
    local msgParam = {}
    if train_arrival_count ~= nil then
      msgParam.train_arrival_count = train_arrival_count
    end
    if train_damaged_count ~= nil then
      msgParam.train_damaged_count = train_damaged_count
    end
    if next_wave_type ~= nil then
      msgParam.next_wave_type = next_wave_type
    end
    if next_wave_time ~= nil then
      msgParam.next_wave_time = next_wave_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallRaidStartFightCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.RaidStartFightCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidStartFightCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFairyTaleRaidRewardSyncCmd(reward_count)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FairyTaleRaidRewardSyncCmd()
    if reward_count ~= nil then
      msg.reward_count = reward_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FairyTaleRaidRewardSyncCmd.id
    local msgParam = {}
    if reward_count ~= nil then
      msgParam.reward_count = reward_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallFairyTaleRaidGetRewardCmd()
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.FairyTaleRaidGetRewardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FairyTaleRaidGetRewardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallSyncMemoryEquipRewardInfo(infos, endtime)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.SyncMemoryEquipRewardInfo()
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
    if endtime ~= nil then
      msg.endtime = endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncMemoryEquipRewardInfo.id
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
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallChooseMemoryEquipRewardInfo(index)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.ChooseMemoryEquipRewardInfo()
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChooseMemoryEquipRewardInfo.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:CallGvgDateBattleInfoSyncCmd(battle_type, death_info, blood_info)
  if not NetConfig.PBC then
    local msg = FuBenCmd_pb.GvgDateBattleInfoSyncCmd()
    if battle_type ~= nil then
      msg.battle_type = battle_type
    end
    if death_info ~= nil and death_info.death_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.death_info == nil then
        msg.death_info = {}
      end
      msg.death_info.death_count = death_info.death_count
    end
    if death_info ~= nil and death_info.death_limit ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.death_info == nil then
        msg.death_info = {}
      end
      msg.death_info.death_limit = death_info.death_limit
    end
    if blood_info ~= nil and blood_info.atk_kill_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.blood_info == nil then
        msg.blood_info = {}
      end
      msg.blood_info.atk_kill_count = blood_info.atk_kill_count
    end
    if blood_info ~= nil and blood_info.def_kill_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.blood_info == nil then
        msg.blood_info = {}
      end
      msg.blood_info.def_kill_count = blood_info.def_kill_count
    end
    if blood_info ~= nil and blood_info.kill_target ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.blood_info == nil then
        msg.blood_info = {}
      end
      msg.blood_info.kill_target = blood_info.kill_target
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgDateBattleInfoSyncCmd.id
    local msgParam = {}
    if battle_type ~= nil then
      msgParam.battle_type = battle_type
    end
    if death_info ~= nil and death_info.death_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.death_info == nil then
        msgParam.death_info = {}
      end
      msgParam.death_info.death_count = death_info.death_count
    end
    if death_info ~= nil and death_info.death_limit ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.death_info == nil then
        msgParam.death_info = {}
      end
      msgParam.death_info.death_limit = death_info.death_limit
    end
    if blood_info ~= nil and blood_info.atk_kill_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.blood_info == nil then
        msgParam.blood_info = {}
      end
      msgParam.blood_info.atk_kill_count = blood_info.atk_kill_count
    end
    if blood_info ~= nil and blood_info.def_kill_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.blood_info == nil then
        msgParam.blood_info = {}
      end
      msgParam.blood_info.def_kill_count = blood_info.def_kill_count
    end
    if blood_info ~= nil and blood_info.kill_target ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.blood_info == nil then
        msgParam.blood_info = {}
      end
      msgParam.blood_info.kill_target = blood_info.kill_target
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFuBenCmdAutoProxy:RecvTrackFuBenUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTrackFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFailFuBenUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFailFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvLeaveFuBenUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdLeaveFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuccessFuBenUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSuccessFuBenUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvWorldStageUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdWorldStageUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvStageStepUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdStageStepUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvStartStageUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdStartStageUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGetRewardStageUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGetRewardStageUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvStageStepStarUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdStageStepStarUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvMonsterCountUserCmd(data)
  self:Notify(ServiceEvent.FuBenCmdMonsterCountUserCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFubenStepSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFubenStepSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFuBenProgressSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFuBenProgressSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFuBenClearInfoCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFuBenClearInfoCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvUserGuildRaidFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdUserGuildRaidFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildGateOptCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildGateOptCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireStopFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireStopFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireDangerFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireDangerFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireMetalHpFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireCalmFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireCalmFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireNewDefFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireRestartFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireRestartFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGuildFireStatusFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGuildFireStatusFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDataSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDataSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDataUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDataUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDefNameChangeFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDefNameChangeFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncMvpInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvBossDieFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdBossDieFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvUpdateUserNumFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdUpdateUserNumFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgTowerUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgMetalDieFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgMetalDieFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgCrystalUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryGvgTowerInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryGvgTowerInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgRewardInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSuperGvgRewardInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSuperGvgQueryUserDataFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvMvpBattleReportFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdMvpBattleReportFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvInviteSummonBossFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdInviteSummonBossFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvReplySummonBossFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdReplySummonBossFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryTeamPwsUserInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryTeamPwsUserInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamPwsReportFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamPwsReportFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamPwsInfoSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvUpdateTeamPwsInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdUpdateTeamPwsInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSelectTeamPwsMagicFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSelectTeamPwsMagicFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvExitMapFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdExitMapFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvBeginFireFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdBeginFireFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamExpReportFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamExpReportFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvBuyExpRaidItemFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdBuyExpRaidItemFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamExpSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamExpSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamReliveCountFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamGroupRaidUpdateChipNum(data)
  self:Notify(ServiceEvent.FuBenCmdTeamGroupRaidUpdateChipNum, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryTeamGroupRaidUserInfo(data)
  self:Notify(ServiceEvent.FuBenCmdQueryTeamGroupRaidUserInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvGroupRaidStateSyncFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGroupRaidStateSyncFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamExpQueryInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamExpQueryInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvUpdateGroupRaidFourthShowData(data)
  self:Notify(ServiceEvent.FuBenCmdUpdateGroupRaidFourthShowData, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryGroupRaidFourthShowData(data)
  self:Notify(ServiceEvent.FuBenCmdQueryGroupRaidFourthShowData, data)
end

function ServiceFuBenCmdAutoProxy:RecvGroupRaidFourthGoOuterCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGroupRaidFourthGoOuterCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRaidStageSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRaidStageSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvThanksGivingMonsterFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdThanksGivingMonsterFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvKumamotoOperFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdKumamotoOperFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvOthelloPointOccupyPowerFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvOthelloInfoSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryOthelloUserInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryOthelloUserInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvOthelloReportFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOthelloReportFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRoguelikeUnlockSceneSync(data)
  self:Notify(ServiceEvent.FuBenCmdRoguelikeUnlockSceneSync, data)
end

function ServiceFuBenCmdAutoProxy:RecvTransferFightChooseFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTransferFightChooseFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTransferFightRankFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTransferFightRankFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTransferFightEndFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTransferFightEndFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvInviteRollRewardFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdInviteRollRewardFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvReplyRollRewardFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdReplyRollRewardFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamRollStatusFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamRollStatusFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvPreReplyRollRewardFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdPreReplyRollRewardFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRaidItemSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRaidItemSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRaidItemUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRaidItemUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpUseItemCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpUseItemCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRaidShopUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRaidShopUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpQuestQueryCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpQuestQueryCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpQueryGroupInfoCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpQueryGroupInfoCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpResultCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpResultCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpBuildingHpUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvTwelvePvpUIOperCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTwelvePvpUIOperCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvReliveCdFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdReliveCdFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvPosSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdPosSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvReqEnterTowerPrivate(data)
  self:Notify(ServiceEvent.FuBenCmdReqEnterTowerPrivate, data)
end

function ServiceFuBenCmdAutoProxy:RecvTowerPrivateLayerInfo(data)
  self:Notify(ServiceEvent.FuBenCmdTowerPrivateLayerInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvTowerPrivateLayerCountdownNtf(data)
  self:Notify(ServiceEvent.FuBenCmdTowerPrivateLayerCountdownNtf, data)
end

function ServiceFuBenCmdAutoProxy:RecvFubenResultNtf(data)
  self:Notify(ServiceEvent.FuBenCmdFubenResultNtf, data)
end

function ServiceFuBenCmdAutoProxy:RecvEndTimeSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdEndTimeSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvResultSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdResultSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvComodoPhaseFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdComodoPhaseFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryComodoTeamRaidStat(data)
  self:Notify(ServiceEvent.FuBenCmdQueryComodoTeamRaidStat, data)
end

function ServiceFuBenCmdAutoProxy:RecvTeamPwsStateSyncFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvObserverFlashFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObserverFlashFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvObserverAttachFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObserverAttachFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvObserverSelectFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObserverSelectFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvObHpspUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObHpspUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvObPlayerOfflineFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObPlayerOfflineFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvMultiBossPhaseFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdMultiBossPhaseFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryMultiBossRaidStat(data)
  self:Notify(ServiceEvent.FuBenCmdQueryMultiBossRaidStat, data)
end

function ServiceFuBenCmdAutoProxy:RecvObMoveCameraPrepareCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObMoveCameraPrepareCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvObCameraMoveEndCmd(data)
  self:Notify(ServiceEvent.FuBenCmdObCameraMoveEndCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRaidKillNumSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRaidKillNumSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncPvePassInfoFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncPveRaidAchieveFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncPveRaidAchieveFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQuickFinishCrackRaidFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQuickFinishCrackRaidFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvPickupPveRaidAchieveFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdPickupPveRaidAchieveFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgPointUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgPointUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgRaidStateUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgRaidStateUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvAddPveCardTimesFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdAddPveCardTimesFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncPveCardOpenStateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncPveCardOpenStateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQuickFinishPveRaidFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQuickFinishPveRaidFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncPveCardRewardTimesFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncPveCardRewardTimesFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgPerfectStateUpdateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgPerfectStateUpdateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryElementRaidStat(data)
  self:Notify(ServiceEvent.FuBenCmdQueryElementRaidStat, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncEmotionFactorsFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncEmotionFactorsFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncBossSceneInfo(data)
  self:Notify(ServiceEvent.FuBenCmdSyncBossSceneInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncUnlockRoomIDsFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncUnlockRoomIDsFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncVisitNpcInfo(data)
  self:Notify(ServiceEvent.FuBenCmdSyncVisitNpcInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncMonsterCountFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncMonsterCountFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSkipAnimationFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSkipAnimationFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvResetRaidFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdResetRaidFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncStarArkInfoFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncStarArkInfoFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncStarArkStatisticsFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncStarArkStatisticsFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvOpenNtfFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdOpenNtfFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRoadblocksChangeFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRoadblocksChangeFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncPassUserInfo(data)
  self:Notify(ServiceEvent.FuBenCmdSyncPassUserInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTripleFireInfoFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleFireInfoFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTripleComboKillFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleComboKillFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTriplePlayerModelFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTriplePlayerModelFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTripleProfessionTimeFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleProfessionTimeFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTripleCampInfoFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleCampInfoFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTripleEnterCountFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleEnterCountFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvChooseCurProfessionFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdChooseCurProfessionFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncTripleFightingInfoFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncTripleFightingInfoFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncFullFireStateFubenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncFullFireStateFubenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvEBFEventDataUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdEBFEventDataUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvEBFMiscDataUpdate(data)
  self:Notify(ServiceEvent.FuBenCmdEBFMiscDataUpdate, data)
end

function ServiceFuBenCmdAutoProxy:RecvOccupyPointDataUpdate(data)
  self:Notify(ServiceEvent.FuBenCmdOccupyPointDataUpdate, data)
end

function ServiceFuBenCmdAutoProxy:RecvQueryPvpStatCmd(data)
  self:Notify(ServiceEvent.FuBenCmdQueryPvpStatCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvEBFKickTimeCmd(data)
  self:Notify(ServiceEvent.FuBenCmdEBFKickTimeCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvEBFContinueCmd(data)
  self:Notify(ServiceEvent.FuBenCmdEBFContinueCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvEBFEventAreaUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdEBFEventAreaUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvAstralInfoSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdAstralInfoSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgMvpInfoUpdateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgMvpInfoUpdateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvAstralPrayBranchSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdAstralPrayBranchSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncStartFightStateCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncStartFightStateCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncGvgFightPointCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncGvgFightPointCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncGvgLeaderPosCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncGvgLeaderPosCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTISyncScoreCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTISyncScoreCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTISyncSkillCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTISyncSkillCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTISyncAvailableUpgradeNumberCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTISyncAvailableUpgradeNumberCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTIGetUpgradeOptionsCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTIGetUpgradeOptionsCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTIRetUpgradeOptionsCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTIRetUpgradeOptionsCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTIExecSkillUpgradeCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTIExecSkillUpgradeCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncSpaceTimeIllusionInfoFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncSpaceTimeIllusionInfoFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncSpaceTimeIllusionExpLevelFuBenCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSyncSpaceTimeIllusionExpLevelFuBenCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTIRefreshUpgradeOptionsCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTIRefreshUpgradeOptionsCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSTIDropSkillCmd(data)
  self:Notify(ServiceEvent.FuBenCmdSTIDropSkillCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFairyTaleRaidSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFairyTaleRaidSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvRaidStartFightCmd(data)
  self:Notify(ServiceEvent.FuBenCmdRaidStartFightCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFairyTaleRaidRewardSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFairyTaleRaidRewardSyncCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvFairyTaleRaidGetRewardCmd(data)
  self:Notify(ServiceEvent.FuBenCmdFairyTaleRaidGetRewardCmd, data)
end

function ServiceFuBenCmdAutoProxy:RecvSyncMemoryEquipRewardInfo(data)
  self:Notify(ServiceEvent.FuBenCmdSyncMemoryEquipRewardInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvChooseMemoryEquipRewardInfo(data)
  self:Notify(ServiceEvent.FuBenCmdChooseMemoryEquipRewardInfo, data)
end

function ServiceFuBenCmdAutoProxy:RecvGvgDateBattleInfoSyncCmd(data)
  self:Notify(ServiceEvent.FuBenCmdGvgDateBattleInfoSyncCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.FuBenCmdTrackFuBenUserCmd = "ServiceEvent_FuBenCmdTrackFuBenUserCmd"
ServiceEvent.FuBenCmdFailFuBenUserCmd = "ServiceEvent_FuBenCmdFailFuBenUserCmd"
ServiceEvent.FuBenCmdLeaveFuBenUserCmd = "ServiceEvent_FuBenCmdLeaveFuBenUserCmd"
ServiceEvent.FuBenCmdSuccessFuBenUserCmd = "ServiceEvent_FuBenCmdSuccessFuBenUserCmd"
ServiceEvent.FuBenCmdWorldStageUserCmd = "ServiceEvent_FuBenCmdWorldStageUserCmd"
ServiceEvent.FuBenCmdStageStepUserCmd = "ServiceEvent_FuBenCmdStageStepUserCmd"
ServiceEvent.FuBenCmdStartStageUserCmd = "ServiceEvent_FuBenCmdStartStageUserCmd"
ServiceEvent.FuBenCmdGetRewardStageUserCmd = "ServiceEvent_FuBenCmdGetRewardStageUserCmd"
ServiceEvent.FuBenCmdStageStepStarUserCmd = "ServiceEvent_FuBenCmdStageStepStarUserCmd"
ServiceEvent.FuBenCmdMonsterCountUserCmd = "ServiceEvent_FuBenCmdMonsterCountUserCmd"
ServiceEvent.FuBenCmdFubenStepSyncCmd = "ServiceEvent_FuBenCmdFubenStepSyncCmd"
ServiceEvent.FuBenCmdFuBenProgressSyncCmd = "ServiceEvent_FuBenCmdFuBenProgressSyncCmd"
ServiceEvent.FuBenCmdFuBenClearInfoCmd = "ServiceEvent_FuBenCmdFuBenClearInfoCmd"
ServiceEvent.FuBenCmdUserGuildRaidFubenCmd = "ServiceEvent_FuBenCmdUserGuildRaidFubenCmd"
ServiceEvent.FuBenCmdGuildGateOptCmd = "ServiceEvent_FuBenCmdGuildGateOptCmd"
ServiceEvent.FuBenCmdGuildFireInfoFubenCmd = "ServiceEvent_FuBenCmdGuildFireInfoFubenCmd"
ServiceEvent.FuBenCmdGuildFireStopFubenCmd = "ServiceEvent_FuBenCmdGuildFireStopFubenCmd"
ServiceEvent.FuBenCmdGuildFireDangerFubenCmd = "ServiceEvent_FuBenCmdGuildFireDangerFubenCmd"
ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd = "ServiceEvent_FuBenCmdGuildFireMetalHpFubenCmd"
ServiceEvent.FuBenCmdGuildFireCalmFubenCmd = "ServiceEvent_FuBenCmdGuildFireCalmFubenCmd"
ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd = "ServiceEvent_FuBenCmdGuildFireNewDefFubenCmd"
ServiceEvent.FuBenCmdGuildFireRestartFubenCmd = "ServiceEvent_FuBenCmdGuildFireRestartFubenCmd"
ServiceEvent.FuBenCmdGuildFireStatusFubenCmd = "ServiceEvent_FuBenCmdGuildFireStatusFubenCmd"
ServiceEvent.FuBenCmdGvgDataSyncCmd = "ServiceEvent_FuBenCmdGvgDataSyncCmd"
ServiceEvent.FuBenCmdGvgDataUpdateCmd = "ServiceEvent_FuBenCmdGvgDataUpdateCmd"
ServiceEvent.FuBenCmdGvgDefNameChangeFubenCmd = "ServiceEvent_FuBenCmdGvgDefNameChangeFubenCmd"
ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd = "ServiceEvent_FuBenCmdSyncMvpInfoFubenCmd"
ServiceEvent.FuBenCmdBossDieFubenCmd = "ServiceEvent_FuBenCmdBossDieFubenCmd"
ServiceEvent.FuBenCmdUpdateUserNumFubenCmd = "ServiceEvent_FuBenCmdUpdateUserNumFubenCmd"
ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd = "ServiceEvent_FuBenCmdSuperGvgSyncFubenCmd"
ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgTowerUpdateFubenCmd"
ServiceEvent.FuBenCmdGvgMetalDieFubenCmd = "ServiceEvent_FuBenCmdGvgMetalDieFubenCmd"
ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgCrystalUpdateFubenCmd"
ServiceEvent.FuBenCmdQueryGvgTowerInfoFubenCmd = "ServiceEvent_FuBenCmdQueryGvgTowerInfoFubenCmd"
ServiceEvent.FuBenCmdSuperGvgRewardInfoFubenCmd = "ServiceEvent_FuBenCmdSuperGvgRewardInfoFubenCmd"
ServiceEvent.FuBenCmdSuperGvgQueryUserDataFubenCmd = "ServiceEvent_FuBenCmdSuperGvgQueryUserDataFubenCmd"
ServiceEvent.FuBenCmdMvpBattleReportFubenCmd = "ServiceEvent_FuBenCmdMvpBattleReportFubenCmd"
ServiceEvent.FuBenCmdInviteSummonBossFubenCmd = "ServiceEvent_FuBenCmdInviteSummonBossFubenCmd"
ServiceEvent.FuBenCmdReplySummonBossFubenCmd = "ServiceEvent_FuBenCmdReplySummonBossFubenCmd"
ServiceEvent.FuBenCmdQueryTeamPwsUserInfoFubenCmd = "ServiceEvent_FuBenCmdQueryTeamPwsUserInfoFubenCmd"
ServiceEvent.FuBenCmdTeamPwsReportFubenCmd = "ServiceEvent_FuBenCmdTeamPwsReportFubenCmd"
ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd = "ServiceEvent_FuBenCmdTeamPwsInfoSyncFubenCmd"
ServiceEvent.FuBenCmdUpdateTeamPwsInfoFubenCmd = "ServiceEvent_FuBenCmdUpdateTeamPwsInfoFubenCmd"
ServiceEvent.FuBenCmdSelectTeamPwsMagicFubenCmd = "ServiceEvent_FuBenCmdSelectTeamPwsMagicFubenCmd"
ServiceEvent.FuBenCmdExitMapFubenCmd = "ServiceEvent_FuBenCmdExitMapFubenCmd"
ServiceEvent.FuBenCmdBeginFireFubenCmd = "ServiceEvent_FuBenCmdBeginFireFubenCmd"
ServiceEvent.FuBenCmdTeamExpReportFubenCmd = "ServiceEvent_FuBenCmdTeamExpReportFubenCmd"
ServiceEvent.FuBenCmdBuyExpRaidItemFubenCmd = "ServiceEvent_FuBenCmdBuyExpRaidItemFubenCmd"
ServiceEvent.FuBenCmdTeamExpSyncFubenCmd = "ServiceEvent_FuBenCmdTeamExpSyncFubenCmd"
ServiceEvent.FuBenCmdTeamReliveCountFubenCmd = "ServiceEvent_FuBenCmdTeamReliveCountFubenCmd"
ServiceEvent.FuBenCmdTeamGroupRaidUpdateChipNum = "ServiceEvent_FuBenCmdTeamGroupRaidUpdateChipNum"
ServiceEvent.FuBenCmdQueryTeamGroupRaidUserInfo = "ServiceEvent_FuBenCmdQueryTeamGroupRaidUserInfo"
ServiceEvent.FuBenCmdGroupRaidStateSyncFuBenCmd = "ServiceEvent_FuBenCmdGroupRaidStateSyncFuBenCmd"
ServiceEvent.FuBenCmdTeamExpQueryInfoFubenCmd = "ServiceEvent_FuBenCmdTeamExpQueryInfoFubenCmd"
ServiceEvent.FuBenCmdUpdateGroupRaidFourthShowData = "ServiceEvent_FuBenCmdUpdateGroupRaidFourthShowData"
ServiceEvent.FuBenCmdQueryGroupRaidFourthShowData = "ServiceEvent_FuBenCmdQueryGroupRaidFourthShowData"
ServiceEvent.FuBenCmdGroupRaidFourthGoOuterCmd = "ServiceEvent_FuBenCmdGroupRaidFourthGoOuterCmd"
ServiceEvent.FuBenCmdRaidStageSyncFubenCmd = "ServiceEvent_FuBenCmdRaidStageSyncFubenCmd"
ServiceEvent.FuBenCmdThanksGivingMonsterFuBenCmd = "ServiceEvent_FuBenCmdThanksGivingMonsterFuBenCmd"
ServiceEvent.FuBenCmdKumamotoOperFubenCmd = "ServiceEvent_FuBenCmdKumamotoOperFubenCmd"
ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd = "ServiceEvent_FuBenCmdOthelloPointOccupyPowerFubenCmd"
ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd = "ServiceEvent_FuBenCmdOthelloInfoSyncFubenCmd"
ServiceEvent.FuBenCmdQueryOthelloUserInfoFubenCmd = "ServiceEvent_FuBenCmdQueryOthelloUserInfoFubenCmd"
ServiceEvent.FuBenCmdOthelloReportFubenCmd = "ServiceEvent_FuBenCmdOthelloReportFubenCmd"
ServiceEvent.FuBenCmdRoguelikeUnlockSceneSync = "ServiceEvent_FuBenCmdRoguelikeUnlockSceneSync"
ServiceEvent.FuBenCmdTransferFightChooseFubenCmd = "ServiceEvent_FuBenCmdTransferFightChooseFubenCmd"
ServiceEvent.FuBenCmdTransferFightRankFubenCmd = "ServiceEvent_FuBenCmdTransferFightRankFubenCmd"
ServiceEvent.FuBenCmdTransferFightEndFubenCmd = "ServiceEvent_FuBenCmdTransferFightEndFubenCmd"
ServiceEvent.FuBenCmdInviteRollRewardFubenCmd = "ServiceEvent_FuBenCmdInviteRollRewardFubenCmd"
ServiceEvent.FuBenCmdReplyRollRewardFubenCmd = "ServiceEvent_FuBenCmdReplyRollRewardFubenCmd"
ServiceEvent.FuBenCmdTeamRollStatusFuBenCmd = "ServiceEvent_FuBenCmdTeamRollStatusFuBenCmd"
ServiceEvent.FuBenCmdPreReplyRollRewardFubenCmd = "ServiceEvent_FuBenCmdPreReplyRollRewardFubenCmd"
ServiceEvent.FuBenCmdTwelvePvpSyncCmd = "ServiceEvent_FuBenCmdTwelvePvpSyncCmd"
ServiceEvent.FuBenCmdRaidItemSyncCmd = "ServiceEvent_FuBenCmdRaidItemSyncCmd"
ServiceEvent.FuBenCmdRaidItemUpdateCmd = "ServiceEvent_FuBenCmdRaidItemUpdateCmd"
ServiceEvent.FuBenCmdTwelvePvpUseItemCmd = "ServiceEvent_FuBenCmdTwelvePvpUseItemCmd"
ServiceEvent.FuBenCmdRaidShopUpdateCmd = "ServiceEvent_FuBenCmdRaidShopUpdateCmd"
ServiceEvent.FuBenCmdTwelvePvpQuestQueryCmd = "ServiceEvent_FuBenCmdTwelvePvpQuestQueryCmd"
ServiceEvent.FuBenCmdTwelvePvpQueryGroupInfoCmd = "ServiceEvent_FuBenCmdTwelvePvpQueryGroupInfoCmd"
ServiceEvent.FuBenCmdTwelvePvpResultCmd = "ServiceEvent_FuBenCmdTwelvePvpResultCmd"
ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd = "ServiceEvent_FuBenCmdTwelvePvpBuildingHpUpdateCmd"
ServiceEvent.FuBenCmdTwelvePvpUIOperCmd = "ServiceEvent_FuBenCmdTwelvePvpUIOperCmd"
ServiceEvent.FuBenCmdReliveCdFubenCmd = "ServiceEvent_FuBenCmdReliveCdFubenCmd"
ServiceEvent.FuBenCmdPosSyncFubenCmd = "ServiceEvent_FuBenCmdPosSyncFubenCmd"
ServiceEvent.FuBenCmdReqEnterTowerPrivate = "ServiceEvent_FuBenCmdReqEnterTowerPrivate"
ServiceEvent.FuBenCmdTowerPrivateLayerInfo = "ServiceEvent_FuBenCmdTowerPrivateLayerInfo"
ServiceEvent.FuBenCmdTowerPrivateLayerCountdownNtf = "ServiceEvent_FuBenCmdTowerPrivateLayerCountdownNtf"
ServiceEvent.FuBenCmdFubenResultNtf = "ServiceEvent_FuBenCmdFubenResultNtf"
ServiceEvent.FuBenCmdEndTimeSyncFubenCmd = "ServiceEvent_FuBenCmdEndTimeSyncFubenCmd"
ServiceEvent.FuBenCmdResultSyncFubenCmd = "ServiceEvent_FuBenCmdResultSyncFubenCmd"
ServiceEvent.FuBenCmdComodoPhaseFubenCmd = "ServiceEvent_FuBenCmdComodoPhaseFubenCmd"
ServiceEvent.FuBenCmdQueryComodoTeamRaidStat = "ServiceEvent_FuBenCmdQueryComodoTeamRaidStat"
ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd = "ServiceEvent_FuBenCmdTeamPwsStateSyncFubenCmd"
ServiceEvent.FuBenCmdObserverFlashFubenCmd = "ServiceEvent_FuBenCmdObserverFlashFubenCmd"
ServiceEvent.FuBenCmdObserverAttachFubenCmd = "ServiceEvent_FuBenCmdObserverAttachFubenCmd"
ServiceEvent.FuBenCmdObserverSelectFubenCmd = "ServiceEvent_FuBenCmdObserverSelectFubenCmd"
ServiceEvent.FuBenCmdObHpspUpdateFubenCmd = "ServiceEvent_FuBenCmdObHpspUpdateFubenCmd"
ServiceEvent.FuBenCmdObPlayerOfflineFubenCmd = "ServiceEvent_FuBenCmdObPlayerOfflineFubenCmd"
ServiceEvent.FuBenCmdMultiBossPhaseFubenCmd = "ServiceEvent_FuBenCmdMultiBossPhaseFubenCmd"
ServiceEvent.FuBenCmdQueryMultiBossRaidStat = "ServiceEvent_FuBenCmdQueryMultiBossRaidStat"
ServiceEvent.FuBenCmdObMoveCameraPrepareCmd = "ServiceEvent_FuBenCmdObMoveCameraPrepareCmd"
ServiceEvent.FuBenCmdObCameraMoveEndCmd = "ServiceEvent_FuBenCmdObCameraMoveEndCmd"
ServiceEvent.FuBenCmdRaidKillNumSyncCmd = "ServiceEvent_FuBenCmdRaidKillNumSyncCmd"
ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd = "ServiceEvent_FuBenCmdSyncPvePassInfoFubenCmd"
ServiceEvent.FuBenCmdSyncPveRaidAchieveFubenCmd = "ServiceEvent_FuBenCmdSyncPveRaidAchieveFubenCmd"
ServiceEvent.FuBenCmdQuickFinishCrackRaidFubenCmd = "ServiceEvent_FuBenCmdQuickFinishCrackRaidFubenCmd"
ServiceEvent.FuBenCmdPickupPveRaidAchieveFubenCmd = "ServiceEvent_FuBenCmdPickupPveRaidAchieveFubenCmd"
ServiceEvent.FuBenCmdGvgPointUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgPointUpdateFubenCmd"
ServiceEvent.FuBenCmdGvgRaidStateUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgRaidStateUpdateFubenCmd"
ServiceEvent.FuBenCmdAddPveCardTimesFubenCmd = "ServiceEvent_FuBenCmdAddPveCardTimesFubenCmd"
ServiceEvent.FuBenCmdSyncPveCardOpenStateFubenCmd = "ServiceEvent_FuBenCmdSyncPveCardOpenStateFubenCmd"
ServiceEvent.FuBenCmdQuickFinishPveRaidFubenCmd = "ServiceEvent_FuBenCmdQuickFinishPveRaidFubenCmd"
ServiceEvent.FuBenCmdSyncPveCardRewardTimesFubenCmd = "ServiceEvent_FuBenCmdSyncPveCardRewardTimesFubenCmd"
ServiceEvent.FuBenCmdGvgPerfectStateUpdateFubenCmd = "ServiceEvent_FuBenCmdGvgPerfectStateUpdateFubenCmd"
ServiceEvent.FuBenCmdQueryElementRaidStat = "ServiceEvent_FuBenCmdQueryElementRaidStat"
ServiceEvent.FuBenCmdSyncEmotionFactorsFuBenCmd = "ServiceEvent_FuBenCmdSyncEmotionFactorsFuBenCmd"
ServiceEvent.FuBenCmdSyncBossSceneInfo = "ServiceEvent_FuBenCmdSyncBossSceneInfo"
ServiceEvent.FuBenCmdSyncUnlockRoomIDsFuBenCmd = "ServiceEvent_FuBenCmdSyncUnlockRoomIDsFuBenCmd"
ServiceEvent.FuBenCmdSyncVisitNpcInfo = "ServiceEvent_FuBenCmdSyncVisitNpcInfo"
ServiceEvent.FuBenCmdSyncMonsterCountFuBenCmd = "ServiceEvent_FuBenCmdSyncMonsterCountFuBenCmd"
ServiceEvent.FuBenCmdSkipAnimationFuBenCmd = "ServiceEvent_FuBenCmdSkipAnimationFuBenCmd"
ServiceEvent.FuBenCmdResetRaidFubenCmd = "ServiceEvent_FuBenCmdResetRaidFubenCmd"
ServiceEvent.FuBenCmdSyncStarArkInfoFuBenCmd = "ServiceEvent_FuBenCmdSyncStarArkInfoFuBenCmd"
ServiceEvent.FuBenCmdSyncStarArkStatisticsFuBenCmd = "ServiceEvent_FuBenCmdSyncStarArkStatisticsFuBenCmd"
ServiceEvent.FuBenCmdOpenNtfFuBenCmd = "ServiceEvent_FuBenCmdOpenNtfFuBenCmd"
ServiceEvent.FuBenCmdRoadblocksChangeFubenCmd = "ServiceEvent_FuBenCmdRoadblocksChangeFubenCmd"
ServiceEvent.FuBenCmdSyncPassUserInfo = "ServiceEvent_FuBenCmdSyncPassUserInfo"
ServiceEvent.FuBenCmdSyncTripleFireInfoFuBenCmd = "ServiceEvent_FuBenCmdSyncTripleFireInfoFuBenCmd"
ServiceEvent.FuBenCmdSyncTripleComboKillFuBenCmd = "ServiceEvent_FuBenCmdSyncTripleComboKillFuBenCmd"
ServiceEvent.FuBenCmdSyncTriplePlayerModelFuBenCmd = "ServiceEvent_FuBenCmdSyncTriplePlayerModelFuBenCmd"
ServiceEvent.FuBenCmdSyncTripleProfessionTimeFuBenCmd = "ServiceEvent_FuBenCmdSyncTripleProfessionTimeFuBenCmd"
ServiceEvent.FuBenCmdSyncTripleCampInfoFuBenCmd = "ServiceEvent_FuBenCmdSyncTripleCampInfoFuBenCmd"
ServiceEvent.FuBenCmdSyncTripleEnterCountFuBenCmd = "ServiceEvent_FuBenCmdSyncTripleEnterCountFuBenCmd"
ServiceEvent.FuBenCmdChooseCurProfessionFuBenCmd = "ServiceEvent_FuBenCmdChooseCurProfessionFuBenCmd"
ServiceEvent.FuBenCmdSyncTripleFightingInfoFuBenCmd = "ServiceEvent_FuBenCmdSyncTripleFightingInfoFuBenCmd"
ServiceEvent.FuBenCmdSyncFullFireStateFubenCmd = "ServiceEvent_FuBenCmdSyncFullFireStateFubenCmd"
ServiceEvent.FuBenCmdEBFEventDataUpdateCmd = "ServiceEvent_FuBenCmdEBFEventDataUpdateCmd"
ServiceEvent.FuBenCmdEBFMiscDataUpdate = "ServiceEvent_FuBenCmdEBFMiscDataUpdate"
ServiceEvent.FuBenCmdOccupyPointDataUpdate = "ServiceEvent_FuBenCmdOccupyPointDataUpdate"
ServiceEvent.FuBenCmdQueryPvpStatCmd = "ServiceEvent_FuBenCmdQueryPvpStatCmd"
ServiceEvent.FuBenCmdEBFKickTimeCmd = "ServiceEvent_FuBenCmdEBFKickTimeCmd"
ServiceEvent.FuBenCmdEBFContinueCmd = "ServiceEvent_FuBenCmdEBFContinueCmd"
ServiceEvent.FuBenCmdEBFEventAreaUpdateCmd = "ServiceEvent_FuBenCmdEBFEventAreaUpdateCmd"
ServiceEvent.FuBenCmdAstralInfoSyncCmd = "ServiceEvent_FuBenCmdAstralInfoSyncCmd"
ServiceEvent.FuBenCmdGvgMvpInfoUpdateCmd = "ServiceEvent_FuBenCmdGvgMvpInfoUpdateCmd"
ServiceEvent.FuBenCmdAstralPrayBranchSyncCmd = "ServiceEvent_FuBenCmdAstralPrayBranchSyncCmd"
ServiceEvent.FuBenCmdSyncStartFightStateCmd = "ServiceEvent_FuBenCmdSyncStartFightStateCmd"
ServiceEvent.FuBenCmdSyncGvgFightPointCmd = "ServiceEvent_FuBenCmdSyncGvgFightPointCmd"
ServiceEvent.FuBenCmdSyncGvgLeaderPosCmd = "ServiceEvent_FuBenCmdSyncGvgLeaderPosCmd"
ServiceEvent.FuBenCmdSTISyncScoreCmd = "ServiceEvent_FuBenCmdSTISyncScoreCmd"
ServiceEvent.FuBenCmdSTISyncSkillCmd = "ServiceEvent_FuBenCmdSTISyncSkillCmd"
ServiceEvent.FuBenCmdSTISyncAvailableUpgradeNumberCmd = "ServiceEvent_FuBenCmdSTISyncAvailableUpgradeNumberCmd"
ServiceEvent.FuBenCmdSTIGetUpgradeOptionsCmd = "ServiceEvent_FuBenCmdSTIGetUpgradeOptionsCmd"
ServiceEvent.FuBenCmdSTIRetUpgradeOptionsCmd = "ServiceEvent_FuBenCmdSTIRetUpgradeOptionsCmd"
ServiceEvent.FuBenCmdSTIExecSkillUpgradeCmd = "ServiceEvent_FuBenCmdSTIExecSkillUpgradeCmd"
ServiceEvent.FuBenCmdSyncSpaceTimeIllusionInfoFuBenCmd = "ServiceEvent_FuBenCmdSyncSpaceTimeIllusionInfoFuBenCmd"
ServiceEvent.FuBenCmdSyncSpaceTimeIllusionExpLevelFuBenCmd = "ServiceEvent_FuBenCmdSyncSpaceTimeIllusionExpLevelFuBenCmd"
ServiceEvent.FuBenCmdSTIRefreshUpgradeOptionsCmd = "ServiceEvent_FuBenCmdSTIRefreshUpgradeOptionsCmd"
ServiceEvent.FuBenCmdSTIDropSkillCmd = "ServiceEvent_FuBenCmdSTIDropSkillCmd"
ServiceEvent.FuBenCmdFairyTaleRaidSyncCmd = "ServiceEvent_FuBenCmdFairyTaleRaidSyncCmd"
ServiceEvent.FuBenCmdRaidStartFightCmd = "ServiceEvent_FuBenCmdRaidStartFightCmd"
ServiceEvent.FuBenCmdFairyTaleRaidRewardSyncCmd = "ServiceEvent_FuBenCmdFairyTaleRaidRewardSyncCmd"
ServiceEvent.FuBenCmdFairyTaleRaidGetRewardCmd = "ServiceEvent_FuBenCmdFairyTaleRaidGetRewardCmd"
ServiceEvent.FuBenCmdSyncMemoryEquipRewardInfo = "ServiceEvent_FuBenCmdSyncMemoryEquipRewardInfo"
ServiceEvent.FuBenCmdChooseMemoryEquipRewardInfo = "ServiceEvent_FuBenCmdChooseMemoryEquipRewardInfo"
ServiceEvent.FuBenCmdGvgDateBattleInfoSyncCmd = "ServiceEvent_FuBenCmdGvgDateBattleInfoSyncCmd"
