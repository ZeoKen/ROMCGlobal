ServiceNUserAutoProxy = class("ServiceNUserAutoProxy", ServiceProxy)
ServiceNUserAutoProxy.Instance = nil
ServiceNUserAutoProxy.NAME = "ServiceNUserAutoProxy"

function ServiceNUserAutoProxy:ctor(proxyName)
  if ServiceNUserAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNUserAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNUserAutoProxy.Instance = self
  end
end

function ServiceNUserAutoProxy:Init()
end

function ServiceNUserAutoProxy:onRegister()
  self:Listen(9, 1, function(data)
    self:RecvGoCity(data)
  end)
  self:Listen(9, 2, function(data)
    self:RecvSysMsg(data)
  end)
  self:Listen(9, 3, function(data)
    self:RecvNpcDataSync(data)
  end)
  self:Listen(9, 4, function(data)
    self:RecvUserNineSyncCmd(data)
  end)
  self:Listen(9, 5, function(data)
    self:RecvUserActionNtf(data)
  end)
  self:Listen(9, 6, function(data)
    self:RecvUserBuffNineSyncCmd(data)
  end)
  self:Listen(9, 7, function(data)
    self:RecvExitPosUserCmd(data)
  end)
  self:Listen(9, 8, function(data)
    self:RecvRelive(data)
  end)
  self:Listen(9, 9, function(data)
    self:RecvVarUpdate(data)
  end)
  self:Listen(9, 10, function(data)
    self:RecvTalkInfo(data)
  end)
  self:Listen(9, 11, function(data)
    self:RecvServerTime(data)
  end)
  self:Listen(9, 14, function(data)
    self:RecvEffectUserCmd(data)
  end)
  self:Listen(9, 15, function(data)
    self:RecvMenuList(data)
  end)
  self:Listen(9, 16, function(data)
    self:RecvNewMenu(data)
  end)
  self:Listen(9, 232, function(data)
    self:RecvEvaluationReward(data)
  end)
  self:Listen(9, 17, function(data)
    self:RecvTeamInfoNine(data)
  end)
  self:Listen(9, 18, function(data)
    self:RecvUsePortrait(data)
  end)
  self:Listen(9, 19, function(data)
    self:RecvUseFrame(data)
  end)
  self:Listen(9, 20, function(data)
    self:RecvUpdatePortraitFrame(data)
  end)
  self:Listen(9, 24, function(data)
    self:RecvQueryPortraitListUserCmd(data)
  end)
  self:Listen(9, 25, function(data)
    self:RecvUseDressing(data)
  end)
  self:Listen(9, 26, function(data)
    self:RecvNewDressing(data)
  end)
  self:Listen(9, 27, function(data)
    self:RecvDressingListUserCmd(data)
  end)
  self:Listen(9, 21, function(data)
    self:RecvAddAttrPoint(data)
  end)
  self:Listen(9, 22, function(data)
    self:RecvQueryShopGotItem(data)
  end)
  self:Listen(9, 23, function(data)
    self:RecvUpdateShopGotItem(data)
  end)
  self:Listen(9, 29, function(data)
    self:RecvOpenUI(data)
  end)
  self:Listen(9, 30, function(data)
    self:RecvDbgSysMsg(data)
  end)
  self:Listen(9, 32, function(data)
    self:RecvFollowTransferCmd(data)
  end)
  self:Listen(9, 33, function(data)
    self:RecvCallNpcFuncCmd(data)
  end)
  self:Listen(9, 34, function(data)
    self:RecvModelShow(data)
  end)
  self:Listen(9, 35, function(data)
    self:RecvSoundEffectCmd(data)
  end)
  self:Listen(9, 36, function(data)
    self:RecvPresetMsgCmd(data)
  end)
  self:Listen(9, 37, function(data)
    self:RecvChangeBgmCmd(data)
  end)
  self:Listen(9, 38, function(data)
    self:RecvQueryFighterInfo(data)
  end)
  self:Listen(9, 40, function(data)
    self:RecvGameTimeCmd(data)
  end)
  self:Listen(9, 41, function(data)
    self:RecvCDTimeUserCmd(data)
  end)
  self:Listen(9, 42, function(data)
    self:RecvStateChange(data)
  end)
  self:Listen(9, 44, function(data)
    self:RecvPhoto(data)
  end)
  self:Listen(9, 45, function(data)
    self:RecvShakeScreen(data)
  end)
  self:Listen(9, 47, function(data)
    self:RecvQueryShortcut(data)
  end)
  self:Listen(9, 48, function(data)
    self:RecvPutShortcut(data)
  end)
  self:Listen(9, 180, function(data)
    self:RecvTempPutShortCut(data)
  end)
  self:Listen(9, 49, function(data)
    self:RecvNpcChangeAngle(data)
  end)
  self:Listen(9, 50, function(data)
    self:RecvCameraFocus(data)
  end)
  self:Listen(9, 51, function(data)
    self:RecvGoToListUserCmd(data)
  end)
  self:Listen(9, 52, function(data)
    self:RecvGoToGearUserCmd(data)
  end)
  self:Listen(9, 12, function(data)
    self:RecvNewTransMapCmd(data)
  end)
  self:Listen(9, 151, function(data)
    self:RecvDeathTransferListCmd(data)
  end)
  self:Listen(9, 152, function(data)
    self:RecvNewDeathTransferCmd(data)
  end)
  self:Listen(9, 153, function(data)
    self:RecvUseDeathTransferCmd(data)
  end)
  self:Listen(9, 53, function(data)
    self:RecvFollowerUser(data)
  end)
  self:Listen(9, 96, function(data)
    self:RecvBeFollowUserCmd(data)
  end)
  self:Listen(9, 54, function(data)
    self:RecvLaboratoryUserCmd(data)
  end)
  self:Listen(9, 57, function(data)
    self:RecvGotoLaboratoryUserCmd(data)
  end)
  self:Listen(9, 56, function(data)
    self:RecvExchangeProfession(data)
  end)
  self:Listen(9, 58, function(data)
    self:RecvSceneryUserCmd(data)
  end)
  self:Listen(9, 59, function(data)
    self:RecvGoMapQuestUserCmd(data)
  end)
  self:Listen(9, 60, function(data)
    self:RecvGoMapFollowUserCmd(data)
  end)
  self:Listen(9, 61, function(data)
    self:RecvUserAutoHitCmd(data)
  end)
  self:Listen(9, 62, function(data)
    self:RecvUploadSceneryPhotoUserCmd(data)
  end)
  self:Listen(9, 80, function(data)
    self:RecvDownloadSceneryPhotoUserCmd(data)
  end)
  self:Listen(9, 63, function(data)
    self:RecvQueryMapArea(data)
  end)
  self:Listen(9, 64, function(data)
    self:RecvNewMapAreaNtf(data)
  end)
  self:Listen(9, 66, function(data)
    self:RecvBuffForeverCmd(data)
  end)
  self:Listen(9, 67, function(data)
    self:RecvInviteJoinHandsUserCmd(data)
  end)
  self:Listen(9, 68, function(data)
    self:RecvBreakUpHandsUserCmd(data)
  end)
  self:Listen(9, 95, function(data)
    self:RecvHandStatusUserCmd(data)
  end)
  self:Listen(9, 69, function(data)
    self:RecvQueryShow(data)
  end)
  self:Listen(9, 70, function(data)
    self:RecvQueryMusicList(data)
  end)
  self:Listen(9, 71, function(data)
    self:RecvDemandMusic(data)
  end)
  self:Listen(9, 72, function(data)
    self:RecvCloseMusicFrame(data)
  end)
  self:Listen(9, 73, function(data)
    self:RecvUploadOkSceneryUserCmd(data)
  end)
  self:Listen(9, 74, function(data)
    self:RecvJoinHandsUserCmd(data)
  end)
  self:Listen(9, 75, function(data)
    self:RecvQueryTraceList(data)
  end)
  self:Listen(9, 76, function(data)
    self:RecvUpdateTraceList(data)
  end)
  self:Listen(9, 77, function(data)
    self:RecvSetDirection(data)
  end)
  self:Listen(9, 82, function(data)
    self:RecvBattleTimelenUserCmd(data)
  end)
  self:Listen(9, 83, function(data)
    self:RecvSetOptionUserCmd(data)
  end)
  self:Listen(9, 84, function(data)
    self:RecvQueryUserInfoUserCmd(data)
  end)
  self:Listen(9, 85, function(data)
    self:RecvCountDownTickUserCmd(data)
  end)
  self:Listen(9, 86, function(data)
    self:RecvItemMusicNtfUserCmd(data)
  end)
  self:Listen(9, 87, function(data)
    self:RecvShakeTreeUserCmd(data)
  end)
  self:Listen(9, 88, function(data)
    self:RecvTreeListUserCmd(data)
  end)
  self:Listen(9, 89, function(data)
    self:RecvActivityNtfUserCmd(data)
  end)
  self:Listen(9, 91, function(data)
    self:RecvQueryZoneStatusUserCmd(data)
  end)
  self:Listen(9, 92, function(data)
    self:RecvJumpZoneUserCmd(data)
  end)
  self:Listen(9, 93, function(data)
    self:RecvItemImageUserNtfUserCmd(data)
  end)
  self:Listen(9, 97, function(data)
    self:RecvInviteFollowUserCmd(data)
  end)
  self:Listen(9, 98, function(data)
    self:RecvChangeNameUserCmd(data)
  end)
  self:Listen(9, 99, function(data)
    self:RecvChargePlayUserCmd(data)
  end)
  self:Listen(9, 100, function(data)
    self:RecvRequireNpcFuncUserCmd(data)
  end)
  self:Listen(9, 101, function(data)
    self:RecvCheckSeatUserCmd(data)
  end)
  self:Listen(9, 102, function(data)
    self:RecvNtfSeatUserCmd(data)
  end)
  self:Listen(9, 114, function(data)
    self:RecvYoyoSeatUserCmd(data)
  end)
  self:Listen(9, 115, function(data)
    self:RecvShowSeatUserCmd(data)
  end)
  self:Listen(9, 103, function(data)
    self:RecvSetNormalSkillOptionUserCmd(data)
  end)
  self:Listen(9, 106, function(data)
    self:RecvNewSetOptionUserCmd(data)
  end)
  self:Listen(9, 104, function(data)
    self:RecvUnsolvedSceneryNtfUserCmd(data)
  end)
  self:Listen(9, 105, function(data)
    self:RecvNtfVisibleNpcUserCmd(data)
  end)
  self:Listen(9, 108, function(data)
    self:RecvTransformPreDataCmd(data)
  end)
  self:Listen(9, 109, function(data)
    self:RecvUserRenameCmd(data)
  end)
  self:Listen(9, 111, function(data)
    self:RecvBuyZenyCmd(data)
  end)
  self:Listen(9, 112, function(data)
    self:RecvCallTeamerUserCmd(data)
  end)
  self:Listen(9, 113, function(data)
    self:RecvCallTeamerReplyUserCmd(data)
  end)
  self:Listen(9, 116, function(data)
    self:RecvSpecialEffectCmd(data)
  end)
  self:Listen(9, 117, function(data)
    self:RecvMarriageProposalCmd(data)
  end)
  self:Listen(9, 118, function(data)
    self:RecvMarriageProposalReplyCmd(data)
  end)
  self:Listen(9, 119, function(data)
    self:RecvUploadWeddingPhotoUserCmd(data)
  end)
  self:Listen(9, 120, function(data)
    self:RecvMarriageProposalSuccessCmd(data)
  end)
  self:Listen(9, 121, function(data)
    self:RecvInviteeWeddingStartNtfUserCmd(data)
  end)
  self:Listen(9, 128, function(data)
    self:RecvKFCShareUserCmd(data)
  end)
  self:Listen(9, 162, function(data)
    self:RecvKFCEnrollUserCmd(data)
  end)
  self:Listen(9, 168, function(data)
    self:RecvKFCEnrollCodeUserCmd(data)
  end)
  self:Listen(9, 163, function(data)
    self:RecvKFCEnrollReplyUserCmd(data)
  end)
  self:Listen(9, 167, function(data)
    self:RecvKFCEnrollQueryUserCmd(data)
  end)
  self:Listen(9, 166, function(data)
    self:RecvKFCHasEnrolledUserCmd(data)
  end)
  self:Listen(9, 130, function(data)
    self:RecvCheckRelationUserCmd(data)
  end)
  self:Listen(9, 129, function(data)
    self:RecvTwinsActionUserCmd(data)
  end)
  self:Listen(9, 122, function(data)
    self:RecvShowServantUserCmd(data)
  end)
  self:Listen(9, 123, function(data)
    self:RecvReplaceServantUserCmd(data)
  end)
  self:Listen(9, 255, function(data)
    self:RecvHireServantUserCmd(data)
  end)
  self:Listen(9, 124, function(data)
    self:RecvServantService(data)
  end)
  self:Listen(9, 125, function(data)
    self:RecvRecommendServantUserCmd(data)
  end)
  self:Listen(9, 126, function(data)
    self:RecvReceiveServantUserCmd(data)
  end)
  self:Listen(9, 127, function(data)
    self:RecvServantRewardStatusUserCmd(data)
  end)
  self:Listen(9, 131, function(data)
    self:RecvProfessionQueryUserCmd(data)
  end)
  self:Listen(9, 132, function(data)
    self:RecvProfessionBuyUserCmd(data)
  end)
  self:Listen(9, 133, function(data)
    self:RecvProfessionChangeUserCmd(data)
  end)
  self:Listen(9, 134, function(data)
    self:RecvUpdateRecordInfoUserCmd(data)
  end)
  self:Listen(9, 135, function(data)
    self:RecvSaveRecordUserCmd(data)
  end)
  self:Listen(9, 136, function(data)
    self:RecvLoadRecordUserCmd(data)
  end)
  self:Listen(9, 137, function(data)
    self:RecvChangeRecordNameUserCmd(data)
  end)
  self:Listen(9, 138, function(data)
    self:RecvBuyRecordSlotUserCmd(data)
  end)
  self:Listen(9, 139, function(data)
    self:RecvDeleteRecordUserCmd(data)
  end)
  self:Listen(9, 140, function(data)
    self:RecvUpdateBranchInfoUserCmd(data)
  end)
  self:Listen(9, 110, function(data)
    self:RecvEnterCapraActivityCmd(data)
  end)
  self:Listen(9, 142, function(data)
    self:RecvInviteWithMeUserCmd(data)
  end)
  self:Listen(9, 143, function(data)
    self:RecvQueryAltmanKillUserCmd(data)
  end)
  self:Listen(9, 144, function(data)
    self:RecvBoothReqUserCmd(data)
  end)
  self:Listen(9, 145, function(data)
    self:RecvBoothInfoSyncUserCmd(data)
  end)
  self:Listen(9, 146, function(data)
    self:RecvDressUpModelUserCmd(data)
  end)
  self:Listen(9, 147, function(data)
    self:RecvDressUpHeadUserCmd(data)
  end)
  self:Listen(9, 148, function(data)
    self:RecvQueryStageUserCmd(data)
  end)
  self:Listen(9, 149, function(data)
    self:RecvDressUpLineUpUserCmd(data)
  end)
  self:Listen(9, 150, function(data)
    self:RecvDressUpStageUserCmd(data)
  end)
  self:Listen(9, 141, function(data)
    self:RecvGoToFunctionMapUserCmd(data)
  end)
  self:Listen(9, 154, function(data)
    self:RecvGrowthServantUserCmd(data)
  end)
  self:Listen(9, 155, function(data)
    self:RecvReceiveGrowthServantUserCmd(data)
  end)
  self:Listen(9, 156, function(data)
    self:RecvGrowthOpenServantUserCmd(data)
  end)
  self:Listen(9, 157, function(data)
    self:RecvCheatTagUserCmd(data)
  end)
  self:Listen(9, 158, function(data)
    self:RecvCheatTagStatUserCmd(data)
  end)
  self:Listen(9, 159, function(data)
    self:RecvClickPosList(data)
  end)
  self:Listen(9, 169, function(data)
    self:RecvServerInfoNtf(data)
  end)
  self:Listen(9, 174, function(data)
    self:RecvReadyToMapUserCmd(data)
  end)
  self:Listen(9, 164, function(data)
    self:RecvSignInUserCmd(data)
  end)
  self:Listen(9, 165, function(data)
    self:RecvSignInNtfUserCmd(data)
  end)
  self:Listen(9, 160, function(data)
    self:RecvBeatPoriUserCmd(data)
  end)
  self:Listen(9, 161, function(data)
    self:RecvUnlockFrameUserCmd(data)
  end)
  self:Listen(9, 170, function(data)
    self:RecvAltmanRewardUserCmd(data)
  end)
  self:Listen(9, 171, function(data)
    self:RecvServantReqReservationUserCmd(data)
  end)
  self:Listen(9, 172, function(data)
    self:RecvServantReservationUserCmd(data)
  end)
  self:Listen(9, 173, function(data)
    self:RecvServantRecEquipUserCmd(data)
  end)
  self:Listen(9, 175, function(data)
    self:RecvPrestigeNtfUserCmd(data)
  end)
  self:Listen(9, 176, function(data)
    self:RecvPrestigeGiveUserCmd(data)
  end)
  self:Listen(9, 178, function(data)
    self:RecvUpdateGameHealthLevelUserCmd(data)
  end)
  self:Listen(9, 179, function(data)
    self:RecvGameHealthEventStatUserCmd(data)
  end)
  self:Listen(9, 181, function(data)
    self:RecvFishway2KillBossInformUserCmd(data)
  end)
  self:Listen(9, 177, function(data)
    self:RecvActPointUserCmd(data)
  end)
  self:Listen(9, 182, function(data)
    self:RecvHighRefineAttrUserCmd(data)
  end)
  self:Listen(9, 183, function(data)
    self:RecvHeadwearNpcUserCmd(data)
  end)
  self:Listen(9, 184, function(data)
    self:RecvHeadwearRoundUserCmd(data)
  end)
  self:Listen(9, 185, function(data)
    self:RecvHeadwearTowerUserCmd(data)
  end)
  self:Listen(9, 186, function(data)
    self:RecvHeadwearEndUserCmd(data)
  end)
  self:Listen(9, 187, function(data)
    self:RecvHeadwearRangeUserCmd(data)
  end)
  self:Listen(9, 191, function(data)
    self:RecvServantStatisticsUserCmd(data)
  end)
  self:Listen(9, 192, function(data)
    self:RecvServantStatisticsMailUserCmd(data)
  end)
  self:Listen(9, 201, function(data)
    self:RecvHeadwearOpenUserCmd(data)
  end)
  self:Listen(9, 198, function(data)
    self:RecvFastTransClassUserCmd(data)
  end)
  self:Listen(9, 199, function(data)
    self:RecvFastTransGemQueryUserCmd(data)
  end)
  self:Listen(9, 200, function(data)
    self:RecvFastTransGemGetUserCmd(data)
  end)
  self:Listen(9, 205, function(data)
    self:RecvFourthSkillCostGetUserCmd(data)
  end)
  self:Listen(9, 202, function(data)
    self:RecvBuildDataQueryUserCmd(data)
  end)
  self:Listen(9, 203, function(data)
    self:RecvBuildContributeUserCmd(data)
  end)
  self:Listen(9, 204, function(data)
    self:RecvBuildOperateUserCmd(data)
  end)
  self:Listen(9, 211, function(data)
    self:RecvNightmareAttrQueryUserCmd(data)
  end)
  self:Listen(9, 212, function(data)
    self:RecvNightmareAttrGetUserCmd(data)
  end)
  self:Listen(9, 197, function(data)
    self:RecvMapAnimeUserCmd(data)
  end)
  self:Listen(9, 216, function(data)
    self:RecvShootNpcUserCmd(data)
  end)
  self:Listen(9, 217, function(data)
    self:RecvPaySignNtfUserCmd(data)
  end)
  self:Listen(9, 218, function(data)
    self:RecvPaySignBuyUserCmd(data)
  end)
  self:Listen(9, 219, function(data)
    self:RecvPaySignRewardUserCmd(data)
  end)
  self:Listen(9, 206, function(data)
    self:RecvExtractionQueryUserCmd(data)
  end)
  self:Listen(9, 207, function(data)
    self:RecvExtractionOperateUserCmd(data)
  end)
  self:Listen(9, 208, function(data)
    self:RecvExtractionActiveUserCmd(data)
  end)
  self:Listen(9, 209, function(data)
    self:RecvExtractionRemoveUserCmd(data)
  end)
  self:Listen(9, 210, function(data)
    self:RecvExtractionGridBuyUserCmd(data)
  end)
  self:Listen(9, 214, function(data)
    self:RecvExtractionRefreshUserCmd(data)
  end)
  self:Listen(9, 220, function(data)
    self:RecvTeamExpRewardTypeCmd(data)
  end)
  self:Listen(9, 221, function(data)
    self:RecvSetMyselfOptionCmd(data)
  end)
  self:Listen(9, 231, function(data)
    self:RecvUseSkillEffectItemUserCmd(data)
  end)
  self:Listen(9, 193, function(data)
    self:RecvRideMultiMountUserCmd(data)
  end)
  self:Listen(9, 194, function(data)
    self:RecvKickOffPassengerUserCmd(data)
  end)
  self:Listen(9, 195, function(data)
    self:RecvSetMultiMountOptUserCmd(data)
  end)
  self:Listen(9, 196, function(data)
    self:RecvMultiMountChangePosUserCmd(data)
  end)
  self:Listen(9, 222, function(data)
    self:RecvGrouponQueryUserCmd(data)
  end)
  self:Listen(9, 223, function(data)
    self:RecvGrouponBuyUserCmd(data)
  end)
  self:Listen(9, 224, function(data)
    self:RecvGrouponRewardUserCmd(data)
  end)
  self:Listen(9, 228, function(data)
    self:RecvNtfPlayActUserCmd(data)
  end)
  self:Listen(9, 225, function(data)
    self:RecvNoviceTargetUpdateUserCmd(data)
  end)
  self:Listen(9, 229, function(data)
    self:RecvNoviceTargetRewardUserCmd(data)
  end)
  self:Listen(9, 234, function(data)
    self:RecvSetBoKiStateUserCmd(data)
  end)
  self:Listen(9, 239, function(data)
    self:RecvCloseDialogMaskUserCmd(data)
  end)
  self:Listen(9, 240, function(data)
    self:RecvCloseDialogCameraUserCmd(data)
  end)
  self:Listen(9, 241, function(data)
    self:RecvHideUIUserCmd(data)
  end)
  self:Listen(9, 233, function(data)
    self:RecvQueryMapMonsterRefreshInfo(data)
  end)
  self:Listen(9, 242, function(data)
    self:RecvSetCameraUserCmd(data)
  end)
  self:Listen(9, 215, function(data)
    self:RecvQueryProfessionDataDetailUserCmd(data)
  end)
  self:Listen(9, 246, function(data)
    self:RecvClearProfessionDataDetailUserCmd(data)
  end)
  self:Listen(9, 243, function(data)
    self:RecvChainExchangeUserCmd(data)
  end)
  self:Listen(9, 244, function(data)
    self:RecvChainOptUserCmd(data)
  end)
  self:Listen(9, 247, function(data)
    self:RecvActivityDonateQueryUserCmd(data)
  end)
  self:Listen(9, 248, function(data)
    self:RecvActivityDonateRewardUserCmd(data)
  end)
  self:Listen(9, 249, function(data)
    self:RecvChangeHairUserCmd(data)
  end)
  self:Listen(9, 250, function(data)
    self:RecvChangeEyeUserCmd(data)
  end)
  self:Listen(9, 245, function(data)
    self:RecvHappyValueUserCmd(data)
  end)
  self:Listen(9, 251, function(data)
    self:RecvSendTargetPosUserCmd(data)
  end)
  self:Listen(9, 252, function(data)
    self:RecvCookGameFinishUserCmd(data)
  end)
  self:Listen(9, 253, function(data)
    self:RecvRaceGameStartUserCmd(data)
  end)
  self:Listen(9, 254, function(data)
    self:RecvRaceGameFinishUserCmd(data)
  end)
  self:Listen(9, 226, function(data)
    self:RecvSendMarksInfoUserCmd(data)
  end)
  self:Listen(9, 227, function(data)
    self:RecvUserSyncBuffFromUserCmd(data)
  end)
end

function ServiceNUserAutoProxy:CallGoCity(mapid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GoCity()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoCity.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSysMsg(id, type, params, act, delay, user)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SysMsg()
    if id ~= nil then
      msg.id = id
    end
    if type ~= nil then
      msg.type = type
    end
    if params ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.params == nil then
        msg.params = {}
      end
      for i = 1, #params do
        table.insert(msg.params, params[i])
      end
    end
    if act ~= nil then
      msg.act = act
    end
    if delay ~= nil then
      msg.delay = delay
    end
    if user ~= nil and user.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.charid = user.charid
    end
    if user ~= nil and user.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.name = user.name
    end
    if user ~= nil and user.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.guildid = user.guildid
    end
    if user ~= nil and user.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.guildname = user.guildname
    end
    if user ~= nil and user.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.gender = user.gender
    end
    if user ~= nil and user.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.profession = user.profession
    end
    if user ~= nil and user.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.level = user.level
    end
    if user ~= nil and user.hair ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.hair = user.hair
    end
    if user ~= nil and user.haircolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.haircolor = user.haircolor
    end
    if user ~= nil and user.body ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.body = user.body
    end
    if user ~= nil and user.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.eye = user.eye
    end
    if user ~= nil and user.clothcolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.clothcolor = user.clothcolor
    end
    if user ~= nil and user.head ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.head = user.head
    end
    if user ~= nil and user.back ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.back = user.back
    end
    if user ~= nil and user.face ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.face = user.face
    end
    if user ~= nil and user.tail ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.tail = user.tail
    end
    if user ~= nil and user.mount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.mount = user.mount
    end
    if user ~= nil and user.mouth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.mouth = user.mouth
    end
    if user ~= nil and user.lefthand ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.lefthand = user.lefthand
    end
    if user ~= nil and user.righthand ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.righthand = user.righthand
    end
    if user ~= nil and user.portrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.portrait = user.portrait
    end
    if user ~= nil and user.homeid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.homeid = user.homeid
    end
    if user ~= nil and user.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.accid = user.accid
    end
    if user ~= nil and user.portrait_frame ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.portrait_frame = user.portrait_frame
    end
    if user ~= nil and user.blink ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.blink = user.blink
    end
    if user ~= nil and user.appellation ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.appellation = user.appellation
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SysMsg.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if type ~= nil then
      msgParam.type = type
    end
    if params ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.params == nil then
        msgParam.params = {}
      end
      for i = 1, #params do
        table.insert(msgParam.params, params[i])
      end
    end
    if act ~= nil then
      msgParam.act = act
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    if user ~= nil and user.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.charid = user.charid
    end
    if user ~= nil and user.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.name = user.name
    end
    if user ~= nil and user.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.guildid = user.guildid
    end
    if user ~= nil and user.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.guildname = user.guildname
    end
    if user ~= nil and user.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.gender = user.gender
    end
    if user ~= nil and user.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.profession = user.profession
    end
    if user ~= nil and user.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.level = user.level
    end
    if user ~= nil and user.hair ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.hair = user.hair
    end
    if user ~= nil and user.haircolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.haircolor = user.haircolor
    end
    if user ~= nil and user.body ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.body = user.body
    end
    if user ~= nil and user.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.eye = user.eye
    end
    if user ~= nil and user.clothcolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.clothcolor = user.clothcolor
    end
    if user ~= nil and user.head ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.head = user.head
    end
    if user ~= nil and user.back ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.back = user.back
    end
    if user ~= nil and user.face ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.face = user.face
    end
    if user ~= nil and user.tail ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.tail = user.tail
    end
    if user ~= nil and user.mount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.mount = user.mount
    end
    if user ~= nil and user.mouth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.mouth = user.mouth
    end
    if user ~= nil and user.lefthand ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.lefthand = user.lefthand
    end
    if user ~= nil and user.righthand ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.righthand = user.righthand
    end
    if user ~= nil and user.portrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.portrait = user.portrait
    end
    if user ~= nil and user.homeid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.homeid = user.homeid
    end
    if user ~= nil and user.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.accid = user.accid
    end
    if user ~= nil and user.portrait_frame ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.portrait_frame = user.portrait_frame
    end
    if user ~= nil and user.blink ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.blink = user.blink
    end
    if user ~= nil and user.appellation ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.appellation = user.appellation
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNpcDataSync(guid, attrs, datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NpcDataSync()
    if guid ~= nil then
      msg.guid = guid
    end
    if attrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.attrs == nil then
        msg.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msg.attrs, attrs[i])
      end
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
    local msgId = ProtoReqInfoList.NpcDataSync.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if attrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.attrs == nil then
        msgParam.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msgParam.attrs, attrs[i])
      end
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

function ServiceNUserAutoProxy:CallUserNineSyncCmd(guid, datas, attrs)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UserNineSyncCmd()
    if guid ~= nil then
      msg.guid = guid
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
    if attrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.attrs == nil then
        msg.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msg.attrs, attrs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserNineSyncCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
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
    if attrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.attrs == nil then
        msgParam.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msgParam.attrs, attrs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUserActionNtf(charid, value, type, delay, once, box_opened)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UserActionNtf()
    if charid ~= nil then
      msg.charid = charid
    end
    if value ~= nil then
      msg.value = value
    end
    if type ~= nil then
      msg.type = type
    end
    if delay ~= nil then
      msg.delay = delay
    end
    if once ~= nil then
      msg.once = once
    end
    if box_opened ~= nil then
      msg.box_opened = box_opened
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserActionNtf.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if value ~= nil then
      msgParam.value = value
    end
    if type ~= nil then
      msgParam.type = type
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    if once ~= nil then
      msgParam.once = once
    end
    if box_opened ~= nil then
      msgParam.box_opened = box_opened
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUserBuffNineSyncCmd(guid, updates, dels, all)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UserBuffNineSyncCmd()
    if guid ~= nil then
      msg.guid = guid
    end
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
    if all ~= nil then
      msg.all = all
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserBuffNineSyncCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
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
    if all ~= nil then
      msgParam.all = all
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallExitPosUserCmd(pos, exitid, mapid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExitPosUserCmd()
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
    if exitid ~= nil then
      msg.exitid = exitid
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitPosUserCmd.id
    local msgParam = {}
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
    if exitid ~= nil then
      msgParam.exitid = exitid
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallRelive(type, itemid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.Relive()
    if type ~= nil then
      msg.type = type
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Relive.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallVarUpdate(vars, accvars)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.VarUpdate()
    if vars ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.vars == nil then
        msg.vars = {}
      end
      for i = 1, #vars do
        table.insert(msg.vars, vars[i])
      end
    end
    if accvars ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.accvars == nil then
        msg.accvars = {}
      end
      for i = 1, #accvars do
        table.insert(msg.accvars, accvars[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.VarUpdate.id
    local msgParam = {}
    if vars ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.vars == nil then
        msgParam.vars = {}
      end
      for i = 1, #vars do
        table.insert(msgParam.vars, vars[i])
      end
    end
    if accvars ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.accvars == nil then
        msgParam.accvars = {}
      end
      for i = 1, #accvars do
        table.insert(msgParam.accvars, accvars[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTalkInfo(guid, talkid, talkmessage, params)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TalkInfo()
    if guid ~= nil then
      msg.guid = guid
    end
    if talkid ~= nil then
      msg.talkid = talkid
    end
    if talkmessage ~= nil then
      msg.talkmessage = talkmessage
    end
    if params ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.params == nil then
        msg.params = {}
      end
      for i = 1, #params do
        table.insert(msg.params, params[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TalkInfo.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if talkid ~= nil then
      msgParam.talkid = talkid
    end
    if talkmessage ~= nil then
      msgParam.talkmessage = talkmessage
    end
    if params ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.params == nil then
        msgParam.params = {}
      end
      for i = 1, #params do
        table.insert(msgParam.params, params[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServerTime(time)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServerTime()
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServerTime.id
    local msgParam = {}
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallEffectUserCmd(effecttype, charid, effectpos, pos, effect, msec, times, index, opt, posbind, epbind, delay, id, dir, skillid, ignorenavmesh, filterid, scale, dir3d, source, ownerid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.EffectUserCmd()
    if effecttype ~= nil then
      msg.effecttype = effecttype
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if effectpos ~= nil then
      msg.effectpos = effectpos
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
    if effect ~= nil then
      msg.effect = effect
    end
    if msec ~= nil then
      msg.msec = msec
    end
    if times ~= nil then
      msg.times = times
    end
    if index ~= nil then
      msg.index = index
    end
    if opt ~= nil then
      msg.opt = opt
    end
    if posbind ~= nil then
      msg.posbind = posbind
    end
    if epbind ~= nil then
      msg.epbind = epbind
    end
    if delay ~= nil then
      msg.delay = delay
    end
    if id ~= nil then
      msg.id = id
    end
    if dir ~= nil then
      msg.dir = dir
    end
    if skillid ~= nil then
      msg.skillid = skillid
    end
    if ignorenavmesh ~= nil then
      msg.ignorenavmesh = ignorenavmesh
    end
    if filterid ~= nil then
      msg.filterid = filterid
    end
    if scale ~= nil then
      msg.scale = scale
    end
    if dir3d ~= nil and dir3d.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dir3d == nil then
        msg.dir3d = {}
      end
      msg.dir3d.x = dir3d.x
    end
    if dir3d ~= nil and dir3d.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dir3d == nil then
        msg.dir3d = {}
      end
      msg.dir3d.y = dir3d.y
    end
    if dir3d ~= nil and dir3d.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dir3d == nil then
        msg.dir3d = {}
      end
      msg.dir3d.z = dir3d.z
    end
    if source ~= nil then
      msg.source = source
    end
    if ownerid ~= nil then
      msg.ownerid = ownerid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EffectUserCmd.id
    local msgParam = {}
    if effecttype ~= nil then
      msgParam.effecttype = effecttype
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if effectpos ~= nil then
      msgParam.effectpos = effectpos
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
    if effect ~= nil then
      msgParam.effect = effect
    end
    if msec ~= nil then
      msgParam.msec = msec
    end
    if times ~= nil then
      msgParam.times = times
    end
    if index ~= nil then
      msgParam.index = index
    end
    if opt ~= nil then
      msgParam.opt = opt
    end
    if posbind ~= nil then
      msgParam.posbind = posbind
    end
    if epbind ~= nil then
      msgParam.epbind = epbind
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    if id ~= nil then
      msgParam.id = id
    end
    if dir ~= nil then
      msgParam.dir = dir
    end
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    if ignorenavmesh ~= nil then
      msgParam.ignorenavmesh = ignorenavmesh
    end
    if filterid ~= nil then
      msgParam.filterid = filterid
    end
    if scale ~= nil then
      msgParam.scale = scale
    end
    if dir3d ~= nil and dir3d.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dir3d == nil then
        msgParam.dir3d = {}
      end
      msgParam.dir3d.x = dir3d.x
    end
    if dir3d ~= nil and dir3d.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dir3d == nil then
        msgParam.dir3d = {}
      end
      msgParam.dir3d.y = dir3d.y
    end
    if dir3d ~= nil and dir3d.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dir3d == nil then
        msgParam.dir3d = {}
      end
      msgParam.dir3d.z = dir3d.z
    end
    if source ~= nil then
      msgParam.source = source
    end
    if ownerid ~= nil then
      msgParam.ownerid = ownerid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallMenuList(list, dellist)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.MenuList()
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
    local msgId = ProtoReqInfoList.MenuList.id
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

function ServiceNUserAutoProxy:CallNewMenu(animplay, noshow, list)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NewMenu()
    if animplay ~= nil then
      msg.animplay = animplay
    end
    if noshow ~= nil then
      msg.noshow = noshow
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
    local msgId = ProtoReqInfoList.NewMenu.id
    local msgParam = {}
    if animplay ~= nil then
      msgParam.animplay = animplay
    end
    if noshow ~= nil then
      msgParam.noshow = noshow
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

function ServiceNUserAutoProxy:CallEvaluationReward(menuid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.EvaluationReward()
    if menuid ~= nil then
      msg.menuid = menuid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EvaluationReward.id
    local msgParam = {}
    if menuid ~= nil then
      msgParam.menuid = menuid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTeamInfoNine(userid, id, name)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TeamInfoNine()
    if userid ~= nil then
      msg.userid = userid
    end
    if id ~= nil then
      msg.id = id
    end
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamInfoNine.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    if id ~= nil then
      msgParam.id = id
    end
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUsePortrait(id)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UsePortrait()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UsePortrait.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUseFrame(id)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UseFrame()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseFrame.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUpdatePortraitFrame(portraits)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UpdatePortraitFrame()
    if portraits ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.portraits == nil then
        msg.portraits = {}
      end
      for i = 1, #portraits do
        table.insert(msg.portraits, portraits[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdatePortraitFrame.id
    local msgParam = {}
    if portraits ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.portraits == nil then
        msgParam.portraits = {}
      end
      for i = 1, #portraits do
        table.insert(msgParam.portraits, portraits[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryPortraitListUserCmd(portraits)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryPortraitListUserCmd()
    if portraits ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.portraits == nil then
        msg.portraits = {}
      end
      for i = 1, #portraits do
        table.insert(msg.portraits, portraits[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPortraitListUserCmd.id
    local msgParam = {}
    if portraits ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.portraits == nil then
        msgParam.portraits = {}
      end
      for i = 1, #portraits do
        table.insert(msgParam.portraits, portraits[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUseDressing(id, charid, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UseDressing()
    if id ~= nil then
      msg.id = id
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseDressing.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNewDressing(type, dressids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NewDressing()
    if type ~= nil then
      msg.type = type
    end
    if dressids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dressids == nil then
        msg.dressids = {}
      end
      for i = 1, #dressids do
        table.insert(msg.dressids, dressids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewDressing.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if dressids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dressids == nil then
        msgParam.dressids = {}
      end
      for i = 1, #dressids do
        table.insert(msgParam.dressids, dressids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDressingListUserCmd(type, dressids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DressingListUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if dressids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dressids == nil then
        msg.dressids = {}
      end
      for i = 1, #dressids do
        table.insert(msg.dressids, dressids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DressingListUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if dressids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dressids == nil then
        msgParam.dressids = {}
      end
      for i = 1, #dressids do
        table.insert(msgParam.dressids, dressids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallAddAttrPoint(type, strpoint, intpoint, agipoint, dexpoint, vitpoint, lukpoint)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.AddAttrPoint()
    if type ~= nil then
      msg.type = type
    end
    if strpoint ~= nil then
      msg.strpoint = strpoint
    end
    if intpoint ~= nil then
      msg.intpoint = intpoint
    end
    if agipoint ~= nil then
      msg.agipoint = agipoint
    end
    if dexpoint ~= nil then
      msg.dexpoint = dexpoint
    end
    if vitpoint ~= nil then
      msg.vitpoint = vitpoint
    end
    if lukpoint ~= nil then
      msg.lukpoint = lukpoint
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddAttrPoint.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if strpoint ~= nil then
      msgParam.strpoint = strpoint
    end
    if intpoint ~= nil then
      msgParam.intpoint = intpoint
    end
    if agipoint ~= nil then
      msgParam.agipoint = agipoint
    end
    if dexpoint ~= nil then
      msgParam.dexpoint = dexpoint
    end
    if vitpoint ~= nil then
      msgParam.vitpoint = vitpoint
    end
    if lukpoint ~= nil then
      msgParam.lukpoint = lukpoint
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryShopGotItem(items, discountitems, limititems, addlimits)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryShopGotItem()
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
    if discountitems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.discountitems == nil then
        msg.discountitems = {}
      end
      for i = 1, #discountitems do
        table.insert(msg.discountitems, discountitems[i])
      end
    end
    if limititems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.limititems == nil then
        msg.limititems = {}
      end
      for i = 1, #limititems do
        table.insert(msg.limititems, limititems[i])
      end
    end
    if addlimits ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addlimits == nil then
        msg.addlimits = {}
      end
      for i = 1, #addlimits do
        table.insert(msg.addlimits, addlimits[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryShopGotItem.id
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
    if discountitems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.discountitems == nil then
        msgParam.discountitems = {}
      end
      for i = 1, #discountitems do
        table.insert(msgParam.discountitems, discountitems[i])
      end
    end
    if limititems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.limititems == nil then
        msgParam.limititems = {}
      end
      for i = 1, #limititems do
        table.insert(msgParam.limititems, limititems[i])
      end
    end
    if addlimits ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addlimits == nil then
        msgParam.addlimits = {}
      end
      for i = 1, #addlimits do
        table.insert(msgParam.addlimits, addlimits[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUpdateShopGotItem(item, discountitem, limititem, addlimit)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UpdateShopGotItem()
    if item ~= nil and item.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.id = item.id
    end
    if item ~= nil and item.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.count = item.count
    end
    if discountitem ~= nil and discountitem.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.discountitem == nil then
        msg.discountitem = {}
      end
      msg.discountitem.id = discountitem.id
    end
    if discountitem ~= nil and discountitem.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.discountitem == nil then
        msg.discountitem = {}
      end
      msg.discountitem.count = discountitem.count
    end
    if limititem ~= nil and limititem.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.limititem == nil then
        msg.limititem = {}
      end
      msg.limititem.id = limititem.id
    end
    if limititem ~= nil and limititem.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.limititem == nil then
        msg.limititem = {}
      end
      msg.limititem.count = limititem.count
    end
    if addlimit ~= nil and addlimit.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addlimit == nil then
        msg.addlimit = {}
      end
      msg.addlimit.id = addlimit.id
    end
    if addlimit ~= nil and addlimit.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addlimit == nil then
        msg.addlimit = {}
      end
      msg.addlimit.count = addlimit.count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateShopGotItem.id
    local msgParam = {}
    if item ~= nil and item.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.id = item.id
    end
    if item ~= nil and item.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.count = item.count
    end
    if discountitem ~= nil and discountitem.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.discountitem == nil then
        msgParam.discountitem = {}
      end
      msgParam.discountitem.id = discountitem.id
    end
    if discountitem ~= nil and discountitem.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.discountitem == nil then
        msgParam.discountitem = {}
      end
      msgParam.discountitem.count = discountitem.count
    end
    if limititem ~= nil and limititem.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.limititem == nil then
        msgParam.limititem = {}
      end
      msgParam.limititem.id = limititem.id
    end
    if limititem ~= nil and limititem.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.limititem == nil then
        msgParam.limititem = {}
      end
      msgParam.limititem.count = limititem.count
    end
    if addlimit ~= nil and addlimit.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addlimit == nil then
        msgParam.addlimit = {}
      end
      msgParam.addlimit.id = addlimit.id
    end
    if addlimit ~= nil and addlimit.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addlimit == nil then
        msgParam.addlimit = {}
      end
      msgParam.addlimit.count = addlimit.count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallOpenUI(id, ui)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.OpenUI()
    if id ~= nil then
      msg.id = id
    end
    if ui ~= nil then
      msg.ui = ui
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenUI.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if ui ~= nil then
      msgParam.ui = ui
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDbgSysMsg(type, content)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DbgSysMsg()
    if msg == nil then
      msg = {}
    end
    msg.type = type
    if msg == nil then
      msg = {}
    end
    msg.content = content
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DbgSysMsg.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.type = type
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.content = content
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFollowTransferCmd(targetId)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.FollowTransferCmd()
    if targetId ~= nil then
      msg.targetId = targetId
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FollowTransferCmd.id
    local msgParam = {}
    if targetId ~= nil then
      msgParam.targetId = targetId
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCallNpcFuncCmd(type, funparam)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CallNpcFuncCmd()
    if type ~= nil then
      msg.type = type
    end
    if funparam ~= nil then
      msg.funparam = funparam
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CallNpcFuncCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if funparam ~= nil then
      msgParam.funparam = funparam
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallModelShow(type, data)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ModelShow()
    if type ~= nil then
      msg.type = type
    end
    if data ~= nil then
      msg.data = data
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ModelShow.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if data ~= nil then
      msgParam.data = data
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSoundEffectCmd(se, pos, msec, times, delay)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SoundEffectCmd()
    if se ~= nil then
      msg.se = se
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
    if msec ~= nil then
      msg.msec = msec
    end
    if times ~= nil then
      msg.times = times
    end
    if delay ~= nil then
      msg.delay = delay
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SoundEffectCmd.id
    local msgParam = {}
    if se ~= nil then
      msgParam.se = se
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
    if msec ~= nil then
      msgParam.msec = msec
    end
    if times ~= nil then
      msgParam.times = times
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallPresetMsgCmd(msgs)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PresetMsgCmd()
    if msgs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.msgs == nil then
        msg.msgs = {}
      end
      for i = 1, #msgs do
        table.insert(msg.msgs, msgs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PresetMsgCmd.id
    local msgParam = {}
    if msgs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.msgs == nil then
        msgParam.msgs = {}
      end
      for i = 1, #msgs do
        table.insert(msgParam.msgs, msgs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChangeBgmCmd(bgm, play, times, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChangeBgmCmd()
    if bgm ~= nil then
      msg.bgm = bgm
    end
    if play ~= nil then
      msg.play = play
    end
    if times ~= nil then
      msg.times = times
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeBgmCmd.id
    local msgParam = {}
    if bgm ~= nil then
      msgParam.bgm = bgm
    end
    if play ~= nil then
      msgParam.play = play
    end
    if times ~= nil then
      msgParam.times = times
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryFighterInfo(fighters)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryFighterInfo()
    if fighters ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fighters == nil then
        msg.fighters = {}
      end
      for i = 1, #fighters do
        table.insert(msg.fighters, fighters[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFighterInfo.id
    local msgParam = {}
    if fighters ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fighters == nil then
        msgParam.fighters = {}
      end
      for i = 1, #fighters do
        table.insert(msgParam.fighters, fighters[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGameTimeCmd(opt, sec, speed)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GameTimeCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    if sec ~= nil then
      msg.sec = sec
    end
    if speed ~= nil then
      msg.speed = speed
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GameTimeCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    if sec ~= nil then
      msgParam.sec = sec
    end
    if speed ~= nil then
      msgParam.speed = speed
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCDTimeUserCmd(list, isall)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CDTimeUserCmd()
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
    if isall ~= nil then
      msg.isall = isall
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CDTimeUserCmd.id
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
    if isall ~= nil then
      msgParam.isall = isall
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallStateChange(status)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.StateChange()
    if status ~= nil then
      msg.status = status
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StateChange.id
    local msgParam = {}
    if status ~= nil then
      msgParam.status = status
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallPhoto(guid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.Photo()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Photo.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallShakeScreen(maxamplitude, msec, shaketype)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ShakeScreen()
    if maxamplitude ~= nil then
      msg.maxamplitude = maxamplitude
    end
    if msec ~= nil then
      msg.msec = msec
    end
    if shaketype ~= nil then
      msg.shaketype = shaketype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShakeScreen.id
    local msgParam = {}
    if maxamplitude ~= nil then
      msgParam.maxamplitude = maxamplitude
    end
    if msec ~= nil then
      msgParam.msec = msec
    end
    if shaketype ~= nil then
      msgParam.shaketype = shaketype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryShortcut(list)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryShortcut()
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
    local msgId = ProtoReqInfoList.QueryShortcut.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallPutShortcut(item)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PutShortcut()
    if item ~= nil and item.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.guid = item.guid
    end
    if item ~= nil and item.preguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.preguid = item.preguid
    end
    if item ~= nil and item.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.type = item.type
    end
    if item ~= nil and item.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.pos = item.pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PutShortcut.id
    local msgParam = {}
    if item ~= nil and item.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.guid = item.guid
    end
    if item ~= nil and item.preguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.preguid = item.preguid
    end
    if item ~= nil and item.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.type = item.type
    end
    if item ~= nil and item.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.pos = item.pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTempPutShortCut(origin, changed)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TempPutShortCut()
    if origin ~= nil and origin.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.origin == nil then
        msg.origin = {}
      end
      msg.origin.guid = origin.guid
    end
    if origin ~= nil and origin.preguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.origin == nil then
        msg.origin = {}
      end
      msg.origin.preguid = origin.preguid
    end
    if origin ~= nil and origin.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.origin == nil then
        msg.origin = {}
      end
      msg.origin.type = origin.type
    end
    if origin ~= nil and origin.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.origin == nil then
        msg.origin = {}
      end
      msg.origin.pos = origin.pos
    end
    if changed ~= nil and changed.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.changed == nil then
        msg.changed = {}
      end
      msg.changed.guid = changed.guid
    end
    if changed ~= nil and changed.preguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.changed == nil then
        msg.changed = {}
      end
      msg.changed.preguid = changed.preguid
    end
    if changed ~= nil and changed.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.changed == nil then
        msg.changed = {}
      end
      msg.changed.type = changed.type
    end
    if changed ~= nil and changed.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.changed == nil then
        msg.changed = {}
      end
      msg.changed.pos = changed.pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TempPutShortCut.id
    local msgParam = {}
    if origin ~= nil and origin.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.origin == nil then
        msgParam.origin = {}
      end
      msgParam.origin.guid = origin.guid
    end
    if origin ~= nil and origin.preguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.origin == nil then
        msgParam.origin = {}
      end
      msgParam.origin.preguid = origin.preguid
    end
    if origin ~= nil and origin.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.origin == nil then
        msgParam.origin = {}
      end
      msgParam.origin.type = origin.type
    end
    if origin ~= nil and origin.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.origin == nil then
        msgParam.origin = {}
      end
      msgParam.origin.pos = origin.pos
    end
    if changed ~= nil and changed.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.changed == nil then
        msgParam.changed = {}
      end
      msgParam.changed.guid = changed.guid
    end
    if changed ~= nil and changed.preguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.changed == nil then
        msgParam.changed = {}
      end
      msgParam.changed.preguid = changed.preguid
    end
    if changed ~= nil and changed.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.changed == nil then
        msgParam.changed = {}
      end
      msgParam.changed.type = changed.type
    end
    if changed ~= nil and changed.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.changed == nil then
        msgParam.changed = {}
      end
      msgParam.changed.pos = changed.pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNpcChangeAngle(guid, targetid, angle)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NpcChangeAngle()
    if guid ~= nil then
      msg.guid = guid
    end
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if angle ~= nil then
      msg.angle = angle
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcChangeAngle.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if angle ~= nil then
      msgParam.angle = angle
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCameraFocus(targets)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CameraFocus()
    if targets ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.targets == nil then
        msg.targets = {}
      end
      for i = 1, #targets do
        table.insert(msg.targets, targets[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CameraFocus.id
    local msgParam = {}
    if targets ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.targets == nil then
        msgParam.targets = {}
      end
      for i = 1, #targets do
        table.insert(msgParam.targets, targets[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGoToListUserCmd(mapid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GoToListUserCmd()
    if mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mapid == nil then
        msg.mapid = {}
      end
      for i = 1, #mapid do
        table.insert(msg.mapid, mapid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoToListUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mapid == nil then
        msgParam.mapid = {}
      end
      for i = 1, #mapid do
        table.insert(msgParam.mapid, mapid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGoToGearUserCmd(mapid, type, otherids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GoToGearUserCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if type ~= nil then
      msg.type = type
    end
    if otherids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.otherids == nil then
        msg.otherids = {}
      end
      for i = 1, #otherids do
        table.insert(msg.otherids, otherids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoToGearUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if otherids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.otherids == nil then
        msgParam.otherids = {}
      end
      for i = 1, #otherids do
        table.insert(msgParam.otherids, otherids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNewTransMapCmd(mapid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NewTransMapCmd()
    if mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mapid == nil then
        msg.mapid = {}
      end
      for i = 1, #mapid do
        table.insert(msg.mapid, mapid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewTransMapCmd.id
    local msgParam = {}
    if mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mapid == nil then
        msgParam.mapid = {}
      end
      for i = 1, #mapid do
        table.insert(msgParam.mapid, mapid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDeathTransferListCmd(transferId)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DeathTransferListCmd()
    if transferId ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.transferId == nil then
        msg.transferId = {}
      end
      for i = 1, #transferId do
        table.insert(msg.transferId, transferId[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DeathTransferListCmd.id
    local msgParam = {}
    if transferId ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.transferId == nil then
        msgParam.transferId = {}
      end
      for i = 1, #transferId do
        table.insert(msgParam.transferId, transferId[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNewDeathTransferCmd(transferId, active)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NewDeathTransferCmd()
    if transferId ~= nil then
      msg.transferId = transferId
    end
    if active ~= nil then
      msg.active = active
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewDeathTransferCmd.id
    local msgParam = {}
    if transferId ~= nil then
      msgParam.transferId = transferId
    end
    if active ~= nil then
      msgParam.active = active
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUseDeathTransferCmd(fromTransferId, toTransferId, pointid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UseDeathTransferCmd()
    if fromTransferId ~= nil then
      msg.fromTransferId = fromTransferId
    end
    if toTransferId ~= nil then
      msg.toTransferId = toTransferId
    end
    if pointid ~= nil then
      msg.pointid = pointid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseDeathTransferCmd.id
    local msgParam = {}
    if fromTransferId ~= nil then
      msgParam.fromTransferId = fromTransferId
    end
    if toTransferId ~= nil then
      msgParam.toTransferId = toTransferId
    end
    if pointid ~= nil then
      msgParam.pointid = pointid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFollowerUser(userid, eType)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.FollowerUser()
    if userid ~= nil then
      msg.userid = userid
    end
    if eType ~= nil then
      msg.eType = eType
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FollowerUser.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    if eType ~= nil then
      msgParam.eType = eType
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBeFollowUserCmd(userid, eType)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BeFollowUserCmd()
    if userid ~= nil then
      msg.userid = userid
    end
    if eType ~= nil then
      msg.eType = eType
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeFollowUserCmd.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    if eType ~= nil then
      msgParam.eType = eType
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallLaboratoryUserCmd(round, curscore, maxscore)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.LaboratoryUserCmd()
    if round ~= nil then
      msg.round = round
    end
    if curscore ~= nil then
      msg.curscore = curscore
    end
    if maxscore ~= nil then
      msg.maxscore = maxscore
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LaboratoryUserCmd.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if curscore ~= nil then
      msgParam.curscore = curscore
    end
    if maxscore ~= nil then
      msgParam.maxscore = maxscore
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGotoLaboratoryUserCmd(funid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GotoLaboratoryUserCmd()
    if funid ~= nil then
      msg.funid = funid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GotoLaboratoryUserCmd.id
    local msgParam = {}
    if funid ~= nil then
      msgParam.funid = funid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallExchangeProfession(guid, datas, attrs, pointattrs, type, no_bgm)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExchangeProfession()
    if guid ~= nil then
      msg.guid = guid
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
    if attrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.attrs == nil then
        msg.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msg.attrs, attrs[i])
      end
    end
    if pointattrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pointattrs == nil then
        msg.pointattrs = {}
      end
      for i = 1, #pointattrs do
        table.insert(msg.pointattrs, pointattrs[i])
      end
    end
    if type ~= nil then
      msg.type = type
    end
    if no_bgm ~= nil then
      msg.no_bgm = no_bgm
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeProfession.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
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
    if attrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.attrs == nil then
        msgParam.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msgParam.attrs, attrs[i])
      end
    end
    if pointattrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pointattrs == nil then
        msgParam.pointattrs = {}
      end
      for i = 1, #pointattrs do
        table.insert(msgParam.pointattrs, pointattrs[i])
      end
    end
    if type ~= nil then
      msgParam.type = type
    end
    if no_bgm ~= nil then
      msgParam.no_bgm = no_bgm
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSceneryUserCmd(mapid, scenerys)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SceneryUserCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if scenerys ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.scenerys == nil then
        msg.scenerys = {}
      end
      for i = 1, #scenerys do
        table.insert(msg.scenerys, scenerys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SceneryUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if scenerys ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.scenerys == nil then
        msgParam.scenerys = {}
      end
      for i = 1, #scenerys do
        table.insert(msgParam.scenerys, scenerys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGoMapQuestUserCmd(questid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GoMapQuestUserCmd()
    if questid ~= nil then
      msg.questid = questid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoMapQuestUserCmd.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGoMapFollowUserCmd(mapid, charid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GoMapFollowUserCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoMapFollowUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUserAutoHitCmd(charid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UserAutoHitCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserAutoHitCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUploadSceneryPhotoUserCmd(type, sceneryid, policy, signature)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UploadSceneryPhotoUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if sceneryid ~= nil then
      msg.sceneryid = sceneryid
    end
    if policy ~= nil then
      msg.policy = policy
    end
    if signature ~= nil then
      msg.signature = signature
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UploadSceneryPhotoUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if sceneryid ~= nil then
      msgParam.sceneryid = sceneryid
    end
    if policy ~= nil then
      msgParam.policy = policy
    end
    if signature ~= nil then
      msgParam.signature = signature
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDownloadSceneryPhotoUserCmd(urls)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DownloadSceneryPhotoUserCmd()
    if urls ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.urls == nil then
        msg.urls = {}
      end
      for i = 1, #urls do
        table.insert(msg.urls, urls[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DownloadSceneryPhotoUserCmd.id
    local msgParam = {}
    if urls ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.urls == nil then
        msgParam.urls = {}
      end
      for i = 1, #urls do
        table.insert(msgParam.urls, urls[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryMapArea(areas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryMapArea()
    if areas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.areas == nil then
        msg.areas = {}
      end
      for i = 1, #areas do
        table.insert(msg.areas, areas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMapArea.id
    local msgParam = {}
    if areas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.areas == nil then
        msgParam.areas = {}
      end
      for i = 1, #areas do
        table.insert(msgParam.areas, areas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNewMapAreaNtf(area)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NewMapAreaNtf()
    if area ~= nil then
      msg.area = area
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewMapAreaNtf.id
    local msgParam = {}
    if area ~= nil then
      msgParam.area = area
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBuffForeverCmd(buff)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BuffForeverCmd()
    if buff ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.buff == nil then
        msg.buff = {}
      end
      for i = 1, #buff do
        table.insert(msg.buff, buff[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuffForeverCmd.id
    local msgParam = {}
    if buff ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.buff == nil then
        msgParam.buff = {}
      end
      for i = 1, #buff do
        table.insert(msgParam.buff, buff[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallInviteJoinHandsUserCmd(charid, masterid, time, mastername, sign)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.InviteJoinHandsUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if time ~= nil then
      msg.time = time
    end
    if mastername ~= nil then
      msg.mastername = mastername
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteJoinHandsUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if mastername ~= nil then
      msgParam.mastername = mastername
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBreakUpHandsUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BreakUpHandsUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BreakUpHandsUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHandStatusUserCmd(build, masterid, followid, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HandStatusUserCmd()
    if build ~= nil then
      msg.build = build
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if followid ~= nil then
      msg.followid = followid
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HandStatusUserCmd.id
    local msgParam = {}
    if build ~= nil then
      msgParam.build = build
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if followid ~= nil then
      msgParam.followid = followid
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryShow(actionid, expression)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryShow()
    if actionid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.actionid == nil then
        msg.actionid = {}
      end
      for i = 1, #actionid do
        table.insert(msg.actionid, actionid[i])
      end
    end
    if expression ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      for i = 1, #expression do
        table.insert(msg.expression, expression[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryShow.id
    local msgParam = {}
    if actionid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.actionid == nil then
        msgParam.actionid = {}
      end
      for i = 1, #actionid do
        table.insert(msgParam.actionid, actionid[i])
      end
    end
    if expression ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      for i = 1, #expression do
        table.insert(msgParam.expression, expression[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryMusicList(npcid, items)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryMusicList()
    if npcid ~= nil then
      msg.npcid = npcid
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
    local msgId = ProtoReqInfoList.QueryMusicList.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
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

function ServiceNUserAutoProxy:CallDemandMusic(npcid, musicid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DemandMusic()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if musicid ~= nil then
      msg.musicid = musicid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DemandMusic.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if musicid ~= nil then
      msgParam.musicid = musicid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCloseMusicFrame()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CloseMusicFrame()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CloseMusicFrame.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUploadOkSceneryUserCmd(sceneryid, status, anglez, time)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UploadOkSceneryUserCmd()
    if sceneryid ~= nil then
      msg.sceneryid = sceneryid
    end
    if status ~= nil then
      msg.status = status
    end
    if anglez ~= nil then
      msg.anglez = anglez
    end
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UploadOkSceneryUserCmd.id
    local msgParam = {}
    if sceneryid ~= nil then
      msgParam.sceneryid = sceneryid
    end
    if status ~= nil then
      msgParam.status = status
    end
    if anglez ~= nil then
      msgParam.anglez = anglez
    end
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallJoinHandsUserCmd(masterid, sign, time)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.JoinHandsUserCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinHandsUserCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryTraceList(items)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryTraceList()
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
    local msgId = ProtoReqInfoList.QueryTraceList.id
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

function ServiceNUserAutoProxy:CallUpdateTraceList(updates, dels)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UpdateTraceList()
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
    local msgId = ProtoReqInfoList.UpdateTraceList.id
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

function ServiceNUserAutoProxy:CallSetDirection(dir)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetDirection()
    if dir ~= nil then
      msg.dir = dir
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetDirection.id
    local msgParam = {}
    if dir ~= nil then
      msgParam.dir = dir
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBattleTimelenUserCmd(timelen, totaltime, musictime, tutortime, estatus, powertime, playtime, usedplaytime, extraplaytime, used_count, total_count, used_playtime_extra_daily, total_playtime_extra_daily, used_playtime_extra, total_playtime_extra, config)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BattleTimelenUserCmd()
    if timelen ~= nil then
      msg.timelen = timelen
    end
    if totaltime ~= nil then
      msg.totaltime = totaltime
    end
    if musictime ~= nil then
      msg.musictime = musictime
    end
    if tutortime ~= nil then
      msg.tutortime = tutortime
    end
    if estatus ~= nil then
      msg.estatus = estatus
    end
    if powertime ~= nil then
      msg.powertime = powertime
    end
    if playtime ~= nil then
      msg.playtime = playtime
    end
    if usedplaytime ~= nil then
      msg.usedplaytime = usedplaytime
    end
    if extraplaytime ~= nil then
      msg.extraplaytime = extraplaytime
    end
    if used_count ~= nil then
      msg.used_count = used_count
    end
    if total_count ~= nil then
      msg.total_count = total_count
    end
    if used_playtime_extra_daily ~= nil then
      msg.used_playtime_extra_daily = used_playtime_extra_daily
    end
    if total_playtime_extra_daily ~= nil then
      msg.total_playtime_extra_daily = total_playtime_extra_daily
    end
    if used_playtime_extra ~= nil then
      msg.used_playtime_extra = used_playtime_extra
    end
    if total_playtime_extra ~= nil then
      msg.total_playtime_extra = total_playtime_extra
    end
    if config ~= nil and config.weekly_base_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.weekly_base_time = config.weekly_base_time
    end
    if config ~= nil and config.daily_max_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.config == nil then
        msg.config = {}
      end
      msg.config.daily_max_time = config.daily_max_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattleTimelenUserCmd.id
    local msgParam = {}
    if timelen ~= nil then
      msgParam.timelen = timelen
    end
    if totaltime ~= nil then
      msgParam.totaltime = totaltime
    end
    if musictime ~= nil then
      msgParam.musictime = musictime
    end
    if tutortime ~= nil then
      msgParam.tutortime = tutortime
    end
    if estatus ~= nil then
      msgParam.estatus = estatus
    end
    if powertime ~= nil then
      msgParam.powertime = powertime
    end
    if playtime ~= nil then
      msgParam.playtime = playtime
    end
    if usedplaytime ~= nil then
      msgParam.usedplaytime = usedplaytime
    end
    if extraplaytime ~= nil then
      msgParam.extraplaytime = extraplaytime
    end
    if used_count ~= nil then
      msgParam.used_count = used_count
    end
    if total_count ~= nil then
      msgParam.total_count = total_count
    end
    if used_playtime_extra_daily ~= nil then
      msgParam.used_playtime_extra_daily = used_playtime_extra_daily
    end
    if total_playtime_extra_daily ~= nil then
      msgParam.total_playtime_extra_daily = total_playtime_extra_daily
    end
    if used_playtime_extra ~= nil then
      msgParam.used_playtime_extra = used_playtime_extra
    end
    if total_playtime_extra ~= nil then
      msgParam.total_playtime_extra = total_playtime_extra
    end
    if config ~= nil and config.weekly_base_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.weekly_base_time = config.weekly_base_time
    end
    if config ~= nil and config.daily_max_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.config == nil then
        msgParam.config = {}
      end
      msgParam.config.daily_max_time = config.daily_max_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSetOptionUserCmd(type, fashionhide, wedding_type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetOptionUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if fashionhide ~= nil then
      msg.fashionhide = fashionhide
    end
    if wedding_type ~= nil then
      msg.wedding_type = wedding_type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetOptionUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if fashionhide ~= nil then
      msgParam.fashionhide = fashionhide
    end
    if wedding_type ~= nil then
      msgParam.wedding_type = wedding_type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryUserInfoUserCmd(charid, teamid, blink)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryUserInfoUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if teamid ~= nil then
      msg.teamid = teamid
    end
    if blink ~= nil then
      msg.blink = blink
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserInfoUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    if blink ~= nil then
      msgParam.blink = blink
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCountDownTickUserCmd(type, tick, time, sign, extparam, gomaptype)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CountDownTickUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if tick ~= nil then
      msg.tick = tick
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if extparam ~= nil then
      msg.extparam = extparam
    end
    if gomaptype ~= nil then
      msg.gomaptype = gomaptype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CountDownTickUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if tick ~= nil then
      msgParam.tick = tick
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if extparam ~= nil then
      msgParam.extparam = extparam
    end
    if gomaptype ~= nil then
      msgParam.gomaptype = gomaptype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallItemMusicNtfUserCmd(add, uri, starttime)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ItemMusicNtfUserCmd()
    if add ~= nil then
      msg.add = add
    end
    if uri ~= nil then
      msg.uri = uri
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ItemMusicNtfUserCmd.id
    local msgParam = {}
    if add ~= nil then
      msgParam.add = add
    end
    if uri ~= nil then
      msgParam.uri = uri
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallShakeTreeUserCmd(npcid, result)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ShakeTreeUserCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if result ~= nil then
      msg.result = result
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShakeTreeUserCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if result ~= nil then
      msgParam.result = result
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTreeListUserCmd(updates, dels)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TreeListUserCmd()
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
    local msgId = ProtoReqInfoList.TreeListUserCmd.id
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

function ServiceNUserAutoProxy:CallActivityNtfUserCmd(id, mapid, endtime, progress)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ActivityNtfUserCmd()
    if id ~= nil then
      msg.id = id
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if progress ~= nil then
      msg.progress = progress
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityNtfUserCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if progress ~= nil then
      msgParam.progress = progress
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryZoneStatusUserCmd(infos, recents)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryZoneStatusUserCmd()
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
    if recents ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.recents == nil then
        msg.recents = {}
      end
      for i = 1, #recents do
        table.insert(msg.recents, recents[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryZoneStatusUserCmd.id
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
    if recents ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.recents == nil then
        msgParam.recents = {}
      end
      for i = 1, #recents do
        table.insert(msgParam.recents, recents[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallJumpZoneUserCmd(npcid, zoneid, isanywhere)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.JumpZoneUserCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if isanywhere ~= nil then
      msg.isanywhere = isanywhere
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JumpZoneUserCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if isanywhere ~= nil then
      msgParam.isanywhere = isanywhere
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallItemImageUserNtfUserCmd(userid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ItemImageUserNtfUserCmd()
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ItemImageUserNtfUserCmd.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallInviteFollowUserCmd(charid, follow)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.InviteFollowUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if follow ~= nil then
      msg.follow = follow
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteFollowUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if follow ~= nil then
      msgParam.follow = follow
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChangeNameUserCmd(name)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChangeNameUserCmd()
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeNameUserCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChargePlayUserCmd(chargeids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChargePlayUserCmd()
    if chargeids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chargeids == nil then
        msg.chargeids = {}
      end
      for i = 1, #chargeids do
        table.insert(msg.chargeids, chargeids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChargePlayUserCmd.id
    local msgParam = {}
    if chargeids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chargeids == nil then
        msgParam.chargeids = {}
      end
      for i = 1, #chargeids do
        table.insert(msgParam.chargeids, chargeids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallRequireNpcFuncUserCmd(npcid, functions)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.RequireNpcFuncUserCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if functions ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.functions == nil then
        msg.functions = {}
      end
      for i = 1, #functions do
        table.insert(msg.functions, functions[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RequireNpcFuncUserCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if functions ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.functions == nil then
        msgParam.functions = {}
      end
      for i = 1, #functions do
        table.insert(msgParam.functions, functions[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCheckSeatUserCmd(furn_guid, seatid, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CheckSeatUserCmd()
    if furn_guid ~= nil then
      msg.furn_guid = furn_guid
    end
    if seatid ~= nil then
      msg.seatid = seatid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CheckSeatUserCmd.id
    local msgParam = {}
    if furn_guid ~= nil then
      msgParam.furn_guid = furn_guid
    end
    if seatid ~= nil then
      msgParam.seatid = seatid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNtfSeatUserCmd(charid, seatid, isseatdown, furn_guid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NtfSeatUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if seatid ~= nil then
      msg.seatid = seatid
    end
    if isseatdown ~= nil then
      msg.isseatdown = isseatdown
    end
    if furn_guid ~= nil then
      msg.furn_guid = furn_guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfSeatUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if seatid ~= nil then
      msgParam.seatid = seatid
    end
    if isseatdown ~= nil then
      msgParam.isseatdown = isseatdown
    end
    if furn_guid ~= nil then
      msgParam.furn_guid = furn_guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallYoyoSeatUserCmd(guid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.YoyoSeatUserCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.YoyoSeatUserCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallShowSeatUserCmd(seatid, show)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ShowSeatUserCmd()
    if seatid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.seatid == nil then
        msg.seatid = {}
      end
      for i = 1, #seatid do
        table.insert(msg.seatid, seatid[i])
      end
    end
    if show ~= nil then
      msg.show = show
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShowSeatUserCmd.id
    local msgParam = {}
    if seatid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.seatid == nil then
        msgParam.seatid = {}
      end
      for i = 1, #seatid do
        table.insert(msgParam.seatid, seatid[i])
      end
    end
    if show ~= nil then
      msgParam.show = show
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSetNormalSkillOptionUserCmd(flag)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetNormalSkillOptionUserCmd()
    if flag ~= nil then
      msg.flag = flag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetNormalSkillOptionUserCmd.id
    local msgParam = {}
    if flag ~= nil then
      msgParam.flag = flag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNewSetOptionUserCmd(type, flag, success, lock_until_time)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NewSetOptionUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if flag ~= nil then
      msg.flag = flag
    end
    if success ~= nil then
      msg.success = success
    end
    if lock_until_time ~= nil then
      msg.lock_until_time = lock_until_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewSetOptionUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if flag ~= nil then
      msgParam.flag = flag
    end
    if success ~= nil then
      msgParam.success = success
    end
    if lock_until_time ~= nil then
      msgParam.lock_until_time = lock_until_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUnsolvedSceneryNtfUserCmd(ids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UnsolvedSceneryNtfUserCmd()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnsolvedSceneryNtfUserCmd.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNtfVisibleNpcUserCmd(npcs, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NtfVisibleNpcUserCmd()
    if npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcs == nil then
        msg.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msg.npcs, npcs[i])
      end
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfVisibleNpcUserCmd.id
    local msgParam = {}
    if npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcs == nil then
        msgParam.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msgParam.npcs, npcs[i])
      end
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTransformPreDataCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TransformPreDataCmd()
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
    local msgId = ProtoReqInfoList.TransformPreDataCmd.id
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

function ServiceNUserAutoProxy:CallUserRenameCmd(name, code, force)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UserRenameCmd()
    if name ~= nil then
      msg.name = name
    end
    if code ~= nil then
      msg.code = code
    end
    if force ~= nil then
      msg.force = force
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserRenameCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if code ~= nil then
      msgParam.code = code
    end
    if force ~= nil then
      msgParam.force = force
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBuyZenyCmd(bcoin, zeny, ret)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BuyZenyCmd()
    if bcoin ~= nil then
      msg.bcoin = bcoin
    end
    if zeny ~= nil then
      msg.zeny = zeny
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyZenyCmd.id
    local msgParam = {}
    if bcoin ~= nil then
      msgParam.bcoin = bcoin
    end
    if zeny ~= nil then
      msgParam.zeny = zeny
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCallTeamerUserCmd(masterid, sign, time, username, mapid, pos)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CallTeamerUserCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if time ~= nil then
      msg.time = time
    end
    if username ~= nil then
      msg.username = username
    end
    if mapid ~= nil then
      msg.mapid = mapid
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CallTeamerUserCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if time ~= nil then
      msgParam.time = time
    end
    if username ~= nil then
      msgParam.username = username
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCallTeamerReplyUserCmd(masterid, sign, time, mapid, pos)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CallTeamerReplyUserCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if time ~= nil then
      msg.time = time
    end
    if mapid ~= nil then
      msg.mapid = mapid
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CallTeamerReplyUserCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if time ~= nil then
      msgParam.time = time
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSpecialEffectCmd(dramaid, starttime, times)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SpecialEffectCmd()
    if dramaid ~= nil then
      msg.dramaid = dramaid
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if times ~= nil then
      msg.times = times
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SpecialEffectCmd.id
    local msgParam = {}
    if dramaid ~= nil then
      msgParam.dramaid = dramaid
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if times ~= nil then
      msgParam.times = times
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallMarriageProposalCmd(masterid, itemid, time, mastername, sign)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.MarriageProposalCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if time ~= nil then
      msg.time = time
    end
    if mastername ~= nil then
      msg.mastername = mastername
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MarriageProposalCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if mastername ~= nil then
      msgParam.mastername = mastername
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallMarriageProposalReplyCmd(masterid, reply, time, sign)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.MarriageProposalReplyCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if reply ~= nil then
      msg.reply = reply
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MarriageProposalReplyCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if reply ~= nil then
      msgParam.reply = reply
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUploadWeddingPhotoUserCmd(itemguid, index, time)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UploadWeddingPhotoUserCmd()
    if itemguid ~= nil then
      msg.itemguid = itemguid
    end
    if index ~= nil then
      msg.index = index
    end
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UploadWeddingPhotoUserCmd.id
    local msgParam = {}
    if itemguid ~= nil then
      msgParam.itemguid = itemguid
    end
    if index ~= nil then
      msgParam.index = index
    end
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallMarriageProposalSuccessCmd(charid, ismaster)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.MarriageProposalSuccessCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if ismaster ~= nil then
      msg.ismaster = ismaster
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MarriageProposalSuccessCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if ismaster ~= nil then
      msgParam.ismaster = ismaster
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallInviteeWeddingStartNtfUserCmd(itemguid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.InviteeWeddingStartNtfUserCmd()
    if itemguid ~= nil then
      msg.itemguid = itemguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteeWeddingStartNtfUserCmd.id
    local msgParam = {}
    if itemguid ~= nil then
      msgParam.itemguid = itemguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKFCShareUserCmd(sharetype)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KFCShareUserCmd()
    if sharetype ~= nil then
      msg.sharetype = sharetype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KFCShareUserCmd.id
    local msgParam = {}
    if sharetype ~= nil then
      msgParam.sharetype = sharetype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKFCEnrollUserCmd(phone)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KFCEnrollUserCmd()
    if phone ~= nil then
      msg.phone = phone
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KFCEnrollUserCmd.id
    local msgParam = {}
    if phone ~= nil then
      msgParam.phone = phone
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKFCEnrollCodeUserCmd(code, district)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KFCEnrollCodeUserCmd()
    if code ~= nil then
      msg.code = code
    end
    if district ~= nil then
      msg.district = district
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KFCEnrollCodeUserCmd.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    if district ~= nil then
      msgParam.district = district
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKFCEnrollReplyUserCmd(result, district, index)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KFCEnrollReplyUserCmd()
    if result ~= nil then
      msg.result = result
    end
    if district ~= nil then
      msg.district = district
    end
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KFCEnrollReplyUserCmd.id
    local msgParam = {}
    if result ~= nil then
      msgParam.result = result
    end
    if district ~= nil then
      msgParam.district = district
    end
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKFCEnrollQueryUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KFCEnrollQueryUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KFCEnrollQueryUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKFCHasEnrolledUserCmd(hasenrolled)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KFCHasEnrolledUserCmd()
    if hasenrolled ~= nil then
      msg.hasenrolled = hasenrolled
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KFCHasEnrolledUserCmd.id
    local msgParam = {}
    if hasenrolled ~= nil then
      msgParam.hasenrolled = hasenrolled
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCheckRelationUserCmd(charid, etype, ret)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CheckRelationUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CheckRelationUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTwinsActionUserCmd(userid, actionid, etype, sponsor)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TwinsActionUserCmd()
    if userid ~= nil then
      msg.userid = userid
    end
    if actionid ~= nil then
      msg.actionid = actionid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if sponsor ~= nil then
      msg.sponsor = sponsor
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TwinsActionUserCmd.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    if actionid ~= nil then
      msgParam.actionid = actionid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if sponsor ~= nil then
      msgParam.sponsor = sponsor
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallShowServantUserCmd(show)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ShowServantUserCmd()
    if show ~= nil then
      msg.show = show
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShowServantUserCmd.id
    local msgParam = {}
    if show ~= nil then
      msgParam.show = show
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallReplaceServantUserCmd(replace, servant)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ReplaceServantUserCmd()
    if replace ~= nil then
      msg.replace = replace
    end
    if servant ~= nil then
      msg.servant = servant
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplaceServantUserCmd.id
    local msgParam = {}
    if replace ~= nil then
      msgParam.replace = replace
    end
    if servant ~= nil then
      msgParam.servant = servant
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHireServantUserCmd(servant, change)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HireServantUserCmd()
    if servant ~= nil then
      msg.servant = servant
    end
    if change ~= nil then
      msg.change = change
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HireServantUserCmd.id
    local msgParam = {}
    if servant ~= nil then
      msgParam.servant = servant
    end
    if change ~= nil then
      msgParam.change = change
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServantService(type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantService()
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServantService.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallRecommendServantUserCmd(items, day_double_item, week_double_item)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.RecommendServantUserCmd()
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
    if day_double_item ~= nil then
      msg.day_double_item = day_double_item
    end
    if week_double_item ~= nil then
      msg.week_double_item = week_double_item
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RecommendServantUserCmd.id
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
    if day_double_item ~= nil then
      msgParam.day_double_item = day_double_item
    end
    if week_double_item ~= nil then
      msgParam.week_double_item = week_double_item
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallReceiveServantUserCmd(favorability, dwid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ReceiveServantUserCmd()
    if favorability ~= nil then
      msg.favorability = favorability
    end
    if dwid ~= nil then
      msg.dwid = dwid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReceiveServantUserCmd.id
    local msgParam = {}
    if favorability ~= nil then
      msgParam.favorability = favorability
    end
    if dwid ~= nil then
      msgParam.dwid = dwid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServantRewardStatusUserCmd(items, stayfavo)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantRewardStatusUserCmd()
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
    if stayfavo ~= nil then
      msg.stayfavo = stayfavo
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServantRewardStatusUserCmd.id
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
    if stayfavo ~= nil then
      msgParam.stayfavo = stayfavo
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallProfessionQueryUserCmd(items, datas, curbranch)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ProfessionQueryUserCmd()
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
    if curbranch ~= nil then
      msg.curbranch = curbranch
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProfessionQueryUserCmd.id
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
    if curbranch ~= nil then
      msgParam.curbranch = curbranch
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallProfessionBuyUserCmd(branch, success, onlymoney)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ProfessionBuyUserCmd()
    if branch ~= nil then
      msg.branch = branch
    end
    if success ~= nil then
      msg.success = success
    end
    if onlymoney ~= nil then
      msg.onlymoney = onlymoney
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProfessionBuyUserCmd.id
    local msgParam = {}
    if branch ~= nil then
      msgParam.branch = branch
    end
    if success ~= nil then
      msgParam.success = success
    end
    if onlymoney ~= nil then
      msgParam.onlymoney = onlymoney
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallProfessionChangeUserCmd(branch, success, change_card, zenycost)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ProfessionChangeUserCmd()
    if branch ~= nil then
      msg.branch = branch
    end
    if success ~= nil then
      msg.success = success
    end
    if change_card ~= nil then
      msg.change_card = change_card
    end
    if zenycost ~= nil then
      msg.zenycost = zenycost
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProfessionChangeUserCmd.id
    local msgParam = {}
    if branch ~= nil then
      msgParam.branch = branch
    end
    if success ~= nil then
      msgParam.success = success
    end
    if change_card ~= nil then
      msgParam.change_card = change_card
    end
    if zenycost ~= nil then
      msgParam.zenycost = zenycost
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUpdateRecordInfoUserCmd(slots, records, delete_ids, card_expiretime, astrol_data)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UpdateRecordInfoUserCmd()
    if slots ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.slots == nil then
        msg.slots = {}
      end
      for i = 1, #slots do
        table.insert(msg.slots, slots[i])
      end
    end
    if records ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.records == nil then
        msg.records = {}
      end
      for i = 1, #records do
        table.insert(msg.records, records[i])
      end
    end
    if delete_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delete_ids == nil then
        msg.delete_ids = {}
      end
      for i = 1, #delete_ids do
        table.insert(msg.delete_ids, delete_ids[i])
      end
    end
    if card_expiretime ~= nil then
      msg.card_expiretime = card_expiretime
    end
    if astrol_data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.astrol_data == nil then
        msg.astrol_data = {}
      end
      for i = 1, #astrol_data do
        table.insert(msg.astrol_data, astrol_data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateRecordInfoUserCmd.id
    local msgParam = {}
    if slots ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.slots == nil then
        msgParam.slots = {}
      end
      for i = 1, #slots do
        table.insert(msgParam.slots, slots[i])
      end
    end
    if records ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.records == nil then
        msgParam.records = {}
      end
      for i = 1, #records do
        table.insert(msgParam.records, records[i])
      end
    end
    if delete_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delete_ids == nil then
        msgParam.delete_ids = {}
      end
      for i = 1, #delete_ids do
        table.insert(msgParam.delete_ids, delete_ids[i])
      end
    end
    if card_expiretime ~= nil then
      msgParam.card_expiretime = card_expiretime
    end
    if astrol_data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.astrol_data == nil then
        msgParam.astrol_data = {}
      end
      for i = 1, #astrol_data do
        table.insert(msgParam.astrol_data, astrol_data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSaveRecordUserCmd(slotid, record_name)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SaveRecordUserCmd()
    if slotid ~= nil then
      msg.slotid = slotid
    end
    if record_name ~= nil then
      msg.record_name = record_name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SaveRecordUserCmd.id
    local msgParam = {}
    if slotid ~= nil then
      msgParam.slotid = slotid
    end
    if record_name ~= nil then
      msgParam.record_name = record_name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallLoadRecordUserCmd(slotid, only_equip, change_card, zenycost)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.LoadRecordUserCmd()
    if slotid ~= nil then
      msg.slotid = slotid
    end
    if only_equip ~= nil then
      msg.only_equip = only_equip
    end
    if change_card ~= nil then
      msg.change_card = change_card
    end
    if zenycost ~= nil then
      msg.zenycost = zenycost
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LoadRecordUserCmd.id
    local msgParam = {}
    if slotid ~= nil then
      msgParam.slotid = slotid
    end
    if only_equip ~= nil then
      msgParam.only_equip = only_equip
    end
    if change_card ~= nil then
      msgParam.change_card = change_card
    end
    if zenycost ~= nil then
      msgParam.zenycost = zenycost
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChangeRecordNameUserCmd(slotid, record_name)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChangeRecordNameUserCmd()
    if slotid ~= nil then
      msg.slotid = slotid
    end
    if record_name ~= nil then
      msg.record_name = record_name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeRecordNameUserCmd.id
    local msgParam = {}
    if slotid ~= nil then
      msgParam.slotid = slotid
    end
    if record_name ~= nil then
      msgParam.record_name = record_name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBuyRecordSlotUserCmd(slotid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BuyRecordSlotUserCmd()
    if slotid ~= nil then
      msg.slotid = slotid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyRecordSlotUserCmd.id
    local msgParam = {}
    if slotid ~= nil then
      msgParam.slotid = slotid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDeleteRecordUserCmd(slotid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DeleteRecordUserCmd()
    if slotid ~= nil then
      msg.slotid = slotid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DeleteRecordUserCmd.id
    local msgParam = {}
    if slotid ~= nil then
      msgParam.slotid = slotid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUpdateBranchInfoUserCmd(datas, sync_type, has_detail)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UpdateBranchInfoUserCmd()
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
    if sync_type ~= nil then
      msg.sync_type = sync_type
    end
    if has_detail ~= nil then
      msg.has_detail = has_detail
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateBranchInfoUserCmd.id
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
    if sync_type ~= nil then
      msgParam.sync_type = sync_type
    end
    if has_detail ~= nil then
      msgParam.has_detail = has_detail
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallEnterCapraActivityCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.EnterCapraActivityCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterCapraActivityCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallInviteWithMeUserCmd(sendid, time, reply, sign)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.InviteWithMeUserCmd()
    if sendid ~= nil then
      msg.sendid = sendid
    end
    if time ~= nil then
      msg.time = time
    end
    if reply ~= nil then
      msg.reply = reply
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteWithMeUserCmd.id
    local msgParam = {}
    if sendid ~= nil then
      msgParam.sendid = sendid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if reply ~= nil then
      msgParam.reply = reply
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryAltmanKillUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryAltmanKillUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryAltmanKillUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBoothReqUserCmd(name, oper, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BoothReqUserCmd()
    if name ~= nil then
      msg.name = name
    end
    if oper ~= nil then
      msg.oper = oper
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoothReqUserCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if oper ~= nil then
      msgParam.oper = oper
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBoothInfoSyncUserCmd(charid, oper, info)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BoothInfoSyncUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if oper ~= nil then
      msg.oper = oper
    end
    if info ~= nil and info.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.name = info.name
    end
    if info ~= nil and info.sign ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.sign = info.sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoothInfoSyncUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if oper ~= nil then
      msgParam.oper = oper
    end
    if info ~= nil and info.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.name = info.name
    end
    if info ~= nil and info.sign ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.sign = info.sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDressUpModelUserCmd(stageid, type, value)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DressUpModelUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
    if type ~= nil then
      msg.type = type
    end
    if value ~= nil then
      msg.value = value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DressUpModelUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if value ~= nil then
      msgParam.value = value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDressUpHeadUserCmd(type, value, puton)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DressUpHeadUserCmd()
    if type ~= nil then
      msg.type = type
    end
    if value ~= nil then
      msg.value = value
    end
    if puton ~= nil then
      msg.puton = puton
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DressUpHeadUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if value ~= nil then
      msgParam.value = value
    end
    if puton ~= nil then
      msgParam.puton = puton
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryStageUserCmd(stageid, info)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryStageUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
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
    local msgId = ProtoReqInfoList.QueryStageUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
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

function ServiceNUserAutoProxy:CallDressUpLineUpUserCmd(stageid, mode, enter)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DressUpLineUpUserCmd()
    if stageid ~= nil then
      msg.stageid = stageid
    end
    if mode ~= nil then
      msg.mode = mode
    end
    if enter ~= nil then
      msg.enter = enter
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DressUpLineUpUserCmd.id
    local msgParam = {}
    if stageid ~= nil then
      msgParam.stageid = stageid
    end
    if mode ~= nil then
      msgParam.mode = mode
    end
    if enter ~= nil then
      msgParam.enter = enter
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallDressUpStageUserCmd(userid, stageid, datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.DressUpStageUserCmd()
    if userid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userid == nil then
        msg.userid = {}
      end
      for i = 1, #userid do
        table.insert(msg.userid, userid[i])
      end
    end
    if stageid ~= nil then
      msg.stageid = stageid
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
    local msgId = ProtoReqInfoList.DressUpStageUserCmd.id
    local msgParam = {}
    if userid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userid == nil then
        msgParam.userid = {}
      end
      for i = 1, #userid do
        table.insert(msgParam.userid, userid[i])
      end
    end
    if stageid ~= nil then
      msgParam.stageid = stageid
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

function ServiceNUserAutoProxy:CallGoToFunctionMapUserCmd(etype)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GoToFunctionMapUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.etype = etype
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoToFunctionMapUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.etype = etype
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGrowthServantUserCmd(datas, unlockitems)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GrowthServantUserCmd()
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
    if unlockitems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unlockitems == nil then
        msg.unlockitems = {}
      end
      for i = 1, #unlockitems do
        table.insert(msg.unlockitems, unlockitems[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GrowthServantUserCmd.id
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
    if unlockitems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unlockitems == nil then
        msgParam.unlockitems = {}
      end
      for i = 1, #unlockitems do
        table.insert(msgParam.unlockitems, unlockitems[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallReceiveGrowthServantUserCmd(dwid, dwvalue)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ReceiveGrowthServantUserCmd()
    if dwid ~= nil then
      msg.dwid = dwid
    end
    if dwvalue ~= nil then
      msg.dwvalue = dwvalue
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReceiveGrowthServantUserCmd.id
    local msgParam = {}
    if dwid ~= nil then
      msgParam.dwid = dwid
    end
    if dwvalue ~= nil then
      msgParam.dwvalue = dwvalue
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGrowthOpenServantUserCmd(groupid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GrowthOpenServantUserCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GrowthOpenServantUserCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCheatTagUserCmd(count, interval, frame)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CheatTagUserCmd()
    if count ~= nil then
      msg.count = count
    end
    if interval ~= nil then
      msg.interval = interval
    end
    if frame ~= nil then
      msg.frame = frame
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CheatTagUserCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    if interval ~= nil then
      msgParam.interval = interval
    end
    if frame ~= nil then
      msgParam.frame = frame
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCheatTagStatUserCmd(cheated, clickmvpthreshold, buttonthreshold)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CheatTagStatUserCmd()
    if cheated ~= nil then
      msg.cheated = cheated
    end
    if clickmvpthreshold ~= nil then
      msg.clickmvpthreshold = clickmvpthreshold
    end
    if buttonthreshold ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.buttonthreshold == nil then
        msg.buttonthreshold = {}
      end
      for i = 1, #buttonthreshold do
        table.insert(msg.buttonthreshold, buttonthreshold[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CheatTagStatUserCmd.id
    local msgParam = {}
    if cheated ~= nil then
      msgParam.cheated = cheated
    end
    if clickmvpthreshold ~= nil then
      msgParam.clickmvpthreshold = clickmvpthreshold
    end
    if buttonthreshold ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.buttonthreshold == nil then
        msgParam.buttonthreshold = {}
      end
      for i = 1, #buttonthreshold do
        table.insert(msgParam.buttonthreshold, buttonthreshold[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallClickPosList(clickbuttonpos)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ClickPosList()
    if clickbuttonpos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.clickbuttonpos == nil then
        msg.clickbuttonpos = {}
      end
      for i = 1, #clickbuttonpos do
        table.insert(msg.clickbuttonpos, clickbuttonpos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClickPosList.id
    local msgParam = {}
    if clickbuttonpos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.clickbuttonpos == nil then
        msgParam.clickbuttonpos = {}
      end
      for i = 1, #clickbuttonpos do
        table.insert(msgParam.clickbuttonpos, clickbuttonpos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServerInfoNtf(serverinfo)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServerInfoNtf()
    if serverinfo ~= nil and serverinfo.serverinfos ~= nil then
      if msg.serverinfo == nil then
        msg.serverinfo = {}
      end
      if msg.serverinfo.serverinfos == nil then
        msg.serverinfo.serverinfos = {}
      end
      for i = 1, #serverinfo.serverinfos do
        table.insert(msg.serverinfo.serverinfos, serverinfo.serverinfos[i])
      end
    end
    if serverinfo ~= nil and serverinfo.pvpzoneids ~= nil then
      if msg.serverinfo == nil then
        msg.serverinfo = {}
      end
      if msg.serverinfo.pvpzoneids == nil then
        msg.serverinfo.pvpzoneids = {}
      end
      for i = 1, #serverinfo.pvpzoneids do
        table.insert(msg.serverinfo.pvpzoneids, serverinfo.pvpzoneids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServerInfoNtf.id
    local msgParam = {}
    if serverinfo ~= nil and serverinfo.serverinfos ~= nil then
      if msgParam.serverinfo == nil then
        msgParam.serverinfo = {}
      end
      if msgParam.serverinfo.serverinfos == nil then
        msgParam.serverinfo.serverinfos = {}
      end
      for i = 1, #serverinfo.serverinfos do
        table.insert(msgParam.serverinfo.serverinfos, serverinfo.serverinfos[i])
      end
    end
    if serverinfo ~= nil and serverinfo.pvpzoneids ~= nil then
      if msgParam.serverinfo == nil then
        msgParam.serverinfo = {}
      end
      if msgParam.serverinfo.pvpzoneids == nil then
        msgParam.serverinfo.pvpzoneids = {}
      end
      for i = 1, #serverinfo.pvpzoneids do
        table.insert(msgParam.serverinfo.pvpzoneids, serverinfo.pvpzoneids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallReadyToMapUserCmd(mapID, dmapID)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ReadyToMapUserCmd()
    if mapID ~= nil then
      msg.mapID = mapID
    end
    if dmapID ~= nil then
      msg.dmapID = dmapID
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReadyToMapUserCmd.id
    local msgParam = {}
    if mapID ~= nil then
      msgParam.mapID = mapID
    end
    if dmapID ~= nil then
      msgParam.dmapID = dmapID
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSignInUserCmd(success, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SignInUserCmd()
    if success ~= nil then
      msg.success = success
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SignInUserCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSignInNtfUserCmd(count, issign, isshowed, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SignInNtfUserCmd()
    if count ~= nil then
      msg.count = count
    end
    if issign ~= nil then
      msg.issign = issign
    end
    if isshowed ~= nil then
      msg.isshowed = isshowed
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SignInNtfUserCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    if issign ~= nil then
      msgParam.issign = issign
    end
    if isshowed ~= nil then
      msgParam.isshowed = isshowed
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBeatPoriUserCmd(start, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BeatPoriUserCmd()
    if start ~= nil then
      msg.start = start
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeatPoriUserCmd.id
    local msgParam = {}
    if start ~= nil then
      msgParam.start = start
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUnlockFrameUserCmd(frameid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UnlockFrameUserCmd()
    if frameid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.frameid == nil then
        msg.frameid = {}
      end
      for i = 1, #frameid do
        table.insert(msg.frameid, frameid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockFrameUserCmd.id
    local msgParam = {}
    if frameid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.frameid == nil then
        msgParam.frameid = {}
      end
      for i = 1, #frameid do
        table.insert(msgParam.frameid, frameid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallAltmanRewardUserCmd(passtime, items, getrewardid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.AltmanRewardUserCmd()
    if passtime ~= nil then
      msg.passtime = passtime
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
    if getrewardid ~= nil then
      msg.getrewardid = getrewardid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AltmanRewardUserCmd.id
    local msgParam = {}
    if passtime ~= nil then
      msgParam.passtime = passtime
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
    if getrewardid ~= nil then
      msgParam.getrewardid = getrewardid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServantReqReservationUserCmd(actid, time, reservation, ftype)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantReqReservationUserCmd()
    if actid ~= nil then
      msg.actid = actid
    end
    if time ~= nil then
      msg.time = time
    end
    if reservation ~= nil then
      msg.reservation = reservation
    end
    if ftype ~= nil then
      msg.ftype = ftype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServantReqReservationUserCmd.id
    local msgParam = {}
    if actid ~= nil then
      msgParam.actid = actid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if reservation ~= nil then
      msgParam.reservation = reservation
    end
    if ftype ~= nil then
      msgParam.ftype = ftype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServantReservationUserCmd(datas, opt)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantReservationUserCmd()
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
    if opt ~= nil then
      msg.opt = opt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServantReservationUserCmd.id
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
    if opt ~= nil then
      msgParam.opt = opt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServantRecEquipUserCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantRecEquipUserCmd()
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
    local msgId = ProtoReqInfoList.ServantRecEquipUserCmd.id
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

function ServiceNUserAutoProxy:CallPrestigeNtfUserCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PrestigeNtfUserCmd()
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
    local msgId = ProtoReqInfoList.PrestigeNtfUserCmd.id
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

function ServiceNUserAutoProxy:CallPrestigeGiveUserCmd(itemid, itemcount, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PrestigeGiveUserCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if itemcount ~= nil then
      msg.itemcount = itemcount
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrestigeGiveUserCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if itemcount ~= nil then
      msgParam.itemcount = itemcount
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUpdateGameHealthLevelUserCmd(level, fishWay)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UpdateGameHealthLevelUserCmd()
    if level ~= nil then
      msg.level = level
    end
    if fishWay ~= nil then
      msg.fishWay = fishWay
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateGameHealthLevelUserCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    if fishWay ~= nil then
      msgParam.fishWay = fishWay
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGameHealthEventStatUserCmd(events)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GameHealthEventStatUserCmd()
    if events ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.events == nil then
        msg.events = {}
      end
      for i = 1, #events do
        table.insert(msg.events, events[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GameHealthEventStatUserCmd.id
    local msgParam = {}
    if events ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.events == nil then
        msgParam.events = {}
      end
      for i = 1, #events do
        table.insert(msgParam.events, events[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFishway2KillBossInformUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.Fishway2KillBossInformUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Fishway2KillBossInformUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallActPointUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ActPointUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActPointUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHighRefineAttrUserCmd(epos, type, value)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HighRefineAttrUserCmd()
    if epos ~= nil then
      msg.epos = epos
    end
    if type ~= nil then
      msg.type = type
    end
    if value ~= nil then
      msg.value = value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HighRefineAttrUserCmd.id
    local msgParam = {}
    if epos ~= nil then
      msgParam.epos = epos
    end
    if type ~= nil then
      msgParam.type = type
    end
    if value ~= nil then
      msgParam.value = value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHeadwearNpcUserCmd(npcs)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HeadwearNpcUserCmd()
    if npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcs == nil then
        msg.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msg.npcs, npcs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearNpcUserCmd.id
    local msgParam = {}
    if npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcs == nil then
        msgParam.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msgParam.npcs, npcs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHeadwearRoundUserCmd(round, blood, skiptime, furytime, crystals, skills, next_round_time)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HeadwearRoundUserCmd()
    if round ~= nil then
      msg.round = round
    end
    if blood ~= nil then
      msg.blood = blood
    end
    if skiptime ~= nil then
      msg.skiptime = skiptime
    end
    if furytime ~= nil then
      msg.furytime = furytime
    end
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
    if skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skills == nil then
        msg.skills = {}
      end
      for i = 1, #skills do
        table.insert(msg.skills, skills[i])
      end
    end
    if next_round_time ~= nil then
      msg.next_round_time = next_round_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearRoundUserCmd.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if blood ~= nil then
      msgParam.blood = blood
    end
    if skiptime ~= nil then
      msgParam.skiptime = skiptime
    end
    if furytime ~= nil then
      msgParam.furytime = furytime
    end
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
    if skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skills == nil then
        msgParam.skills = {}
      end
      for i = 1, #skills do
        table.insert(msgParam.skills, skills[i])
      end
    end
    if next_round_time ~= nil then
      msgParam.next_round_time = next_round_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHeadwearTowerUserCmd(npcid, level, crystals)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HeadwearTowerUserCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if level ~= nil then
      msg.level = level
    end
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
    local msgId = ProtoReqInfoList.HeadwearTowerUserCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if level ~= nil then
      msgParam.level = level
    end
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

function ServiceNUserAutoProxy:CallHeadwearEndUserCmd(round, coldtime, weektimes, coinanum, coinbnum, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HeadwearEndUserCmd()
    if round ~= nil then
      msg.round = round
    end
    if coldtime ~= nil then
      msg.coldtime = coldtime
    end
    if weektimes ~= nil then
      msg.weektimes = weektimes
    end
    if coinanum ~= nil then
      msg.coinanum = coinanum
    end
    if coinbnum ~= nil then
      msg.coinbnum = coinbnum
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearEndUserCmd.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if coldtime ~= nil then
      msgParam.coldtime = coldtime
    end
    if weektimes ~= nil then
      msgParam.weektimes = weektimes
    end
    if coinanum ~= nil then
      msgParam.coinanum = coinanum
    end
    if coinbnum ~= nil then
      msgParam.coinbnum = coinbnum
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHeadwearRangeUserCmd(tower)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HeadwearRangeUserCmd()
    if tower ~= nil then
      msg.tower = tower
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearRangeUserCmd.id
    local msgParam = {}
    if tower ~= nil then
      msgParam.tower = tower
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallServantStatisticsUserCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantStatisticsUserCmd()
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
    local msgId = ProtoReqInfoList.ServantStatisticsUserCmd.id
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

function ServiceNUserAutoProxy:CallServantStatisticsMailUserCmd(mail)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ServantStatisticsMailUserCmd()
    if mail ~= nil and mail.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.time = mail.time
    end
    if mail ~= nil and mail.has_team ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.has_team = mail.has_team
    end
    if mail ~= nil and mail.enter_raid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.enter_raid = mail.enter_raid
    end
    if mail ~= nil and mail.battle_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.battle_time = mail.battle_time
    end
    if mail ~= nil and mail.cards ~= nil then
      if msg.mail == nil then
        msg.mail = {}
      end
      if msg.mail.cards == nil then
        msg.mail.cards = {}
      end
      for i = 1, #mail.cards do
        table.insert(msg.mail.cards, mail.cards[i])
      end
    end
    if mail ~= nil and mail.calcdata ~= nil then
      if msg.mail == nil then
        msg.mail = {}
      end
      if msg.mail.calcdata == nil then
        msg.mail.calcdata = {}
      end
      for i = 1, #mail.calcdata do
        table.insert(msg.mail.calcdata, mail.calcdata[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServantStatisticsMailUserCmd.id
    local msgParam = {}
    if mail ~= nil and mail.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.time = mail.time
    end
    if mail ~= nil and mail.has_team ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.has_team = mail.has_team
    end
    if mail ~= nil and mail.enter_raid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.enter_raid = mail.enter_raid
    end
    if mail ~= nil and mail.battle_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.battle_time = mail.battle_time
    end
    if mail ~= nil and mail.cards ~= nil then
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      if msgParam.mail.cards == nil then
        msgParam.mail.cards = {}
      end
      for i = 1, #mail.cards do
        table.insert(msgParam.mail.cards, mail.cards[i])
      end
    end
    if mail ~= nil and mail.calcdata ~= nil then
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      if msgParam.mail.calcdata == nil then
        msgParam.mail.calcdata = {}
      end
      for i = 1, #mail.calcdata do
        table.insert(msgParam.mail.calcdata, mail.calcdata[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHeadwearOpenUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HeadwearOpenUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearOpenUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFastTransClassUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.FastTransClassUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FastTransClassUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFastTransGemQueryUserCmd(ischoose)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.FastTransGemQueryUserCmd()
    if ischoose ~= nil then
      msg.ischoose = ischoose
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FastTransGemQueryUserCmd.id
    local msgParam = {}
    if ischoose ~= nil then
      msgParam.ischoose = ischoose
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFastTransGemGetUserCmd(gemid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.FastTransGemGetUserCmd()
    if gemid ~= nil then
      msg.gemid = gemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FastTransGemGetUserCmd.id
    local msgParam = {}
    if gemid ~= nil then
      msgParam.gemid = gemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallFourthSkillCostGetUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.FourthSkillCostGetUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FourthSkillCostGetUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBuildDataQueryUserCmd(data)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BuildDataQueryUserCmd()
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.npcid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.npcid = data.npcid
    end
    if data ~= nil and data.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mapid = data.mapid
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
    if data ~= nil and data.dir ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.dir = data.dir
    end
    if data.pos ~= nil and data.pos.x ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.x = data.pos.x
    end
    if data.pos ~= nil and data.pos.y ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.y = data.pos.y
    end
    if data.pos ~= nil and data.pos.z ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.z = data.pos.z
    end
    if data ~= nil and data.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.status = data.status
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
    if data ~= nil and data.elements ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.elements == nil then
        msg.data.elements = {}
      end
      for i = 1, #data.elements do
        table.insert(msg.data.elements, data.elements[i])
      end
    end
    if data.weather ~= nil and data.weather.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.weather == nil then
        msg.data.weather = {}
      end
      msg.data.weather.id = data.weather.id
    end
    if data.weather ~= nil and data.weather.time ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.weather == nil then
        msg.data.weather = {}
      end
      msg.data.weather.time = data.weather.time
    end
    if data.block ~= nil and data.block.hp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.block == nil then
        msg.data.block = {}
      end
      msg.data.block.hp = data.block.hp
    end
    if data.timer ~= nil and data.timer.times ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.timer == nil then
        msg.data.timer = {}
      end
      msg.data.timer.times = data.timer.times
    end
    if data ~= nil and data.timer.datas ~= nil then
      if msg.data.timer == nil then
        msg.data.timer = {}
      end
      if msg.data.timer.datas == nil then
        msg.data.timer.datas = {}
      end
      for i = 1, #data.timer.datas do
        table.insert(msg.data.timer.datas, data.timer.datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildDataQueryUserCmd.id
    local msgParam = {}
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.npcid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.npcid = data.npcid
    end
    if data ~= nil and data.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mapid = data.mapid
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
    if data ~= nil and data.dir ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.dir = data.dir
    end
    if data.pos ~= nil and data.pos.x ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.x = data.pos.x
    end
    if data.pos ~= nil and data.pos.y ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.y = data.pos.y
    end
    if data.pos ~= nil and data.pos.z ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.z = data.pos.z
    end
    if data ~= nil and data.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.status = data.status
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
    if data ~= nil and data.elements ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.elements == nil then
        msgParam.data.elements = {}
      end
      for i = 1, #data.elements do
        table.insert(msgParam.data.elements, data.elements[i])
      end
    end
    if data.weather ~= nil and data.weather.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.weather == nil then
        msgParam.data.weather = {}
      end
      msgParam.data.weather.id = data.weather.id
    end
    if data.weather ~= nil and data.weather.time ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.weather == nil then
        msgParam.data.weather = {}
      end
      msgParam.data.weather.time = data.weather.time
    end
    if data.block ~= nil and data.block.hp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.block == nil then
        msgParam.data.block = {}
      end
      msgParam.data.block.hp = data.block.hp
    end
    if data.timer ~= nil and data.timer.times ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.timer == nil then
        msgParam.data.timer = {}
      end
      msgParam.data.timer.times = data.timer.times
    end
    if data ~= nil and data.timer.datas ~= nil then
      if msgParam.data.timer == nil then
        msgParam.data.timer = {}
      end
      if msgParam.data.timer.datas == nil then
        msgParam.data.timer.datas = {}
      end
      for i = 1, #data.timer.datas do
        table.insert(msgParam.data.timer.datas, data.timer.datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBuildContributeUserCmd(item, data, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BuildContributeUserCmd()
    if item ~= nil and item.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.guid = item.guid
    end
    if item ~= nil and item.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.id = item.id
    end
    if item ~= nil and item.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.count = item.count
    end
    if item ~= nil and item.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.index = item.index
    end
    if item ~= nil and item.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.createtime = item.createtime
    end
    if item ~= nil and item.cd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.cd = item.cd
    end
    if item ~= nil and item.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.type = item.type
    end
    if item ~= nil and item.bind ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.bind = item.bind
    end
    if item ~= nil and item.expire ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.expire = item.expire
    end
    if item ~= nil and item.quality ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.quality = item.quality
    end
    if item ~= nil and item.equipType ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.equipType = item.equipType
    end
    if item ~= nil and item.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.source = item.source
    end
    if item ~= nil and item.isnew ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.isnew = item.isnew
    end
    if item ~= nil and item.maxcardslot ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.maxcardslot = item.maxcardslot
    end
    if item ~= nil and item.ishint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.ishint = item.ishint
    end
    if item ~= nil and item.isactive ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.isactive = item.isactive
    end
    if item ~= nil and item.source_npc ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.source_npc = item.source_npc
    end
    if item ~= nil and item.refinelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.refinelv = item.refinelv
    end
    if item ~= nil and item.chargemoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.chargemoney = item.chargemoney
    end
    if item ~= nil and item.overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.overtime = item.overtime
    end
    if item ~= nil and item.quota ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.quota = item.quota
    end
    if item ~= nil and item.usedtimes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.usedtimes = item.usedtimes
    end
    if item ~= nil and item.usedtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.usedtime = item.usedtime
    end
    if item ~= nil and item.isfavorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.isfavorite = item.isfavorite
    end
    if item ~= nil and item.mailhint ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.mailhint == nil then
        msg.item.mailhint = {}
      end
      for i = 1, #item.mailhint do
        table.insert(msg.item.mailhint, item.mailhint[i])
      end
    end
    if item ~= nil and item.subsource ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.subsource = item.subsource
    end
    if item ~= nil and item.randkey ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.randkey = item.randkey
    end
    if item ~= nil and item.sceneinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.sceneinfo = item.sceneinfo
    end
    if item ~= nil and item.local_charge ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.local_charge = item.local_charge
    end
    if item ~= nil and item.charge_deposit_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.charge_deposit_id = item.charge_deposit_id
    end
    if item ~= nil and item.issplit ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.issplit = item.issplit
    end
    if item.tmp ~= nil and item.tmp.none ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.tmp == nil then
        msg.item.tmp = {}
      end
      msg.item.tmp.none = item.tmp.none
    end
    if item.tmp ~= nil and item.tmp.num_param ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.tmp == nil then
        msg.item.tmp = {}
      end
      msg.item.tmp.num_param = item.tmp.num_param
    end
    if item.tmp ~= nil and item.tmp.from_reward ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.tmp == nil then
        msg.item.tmp = {}
      end
      msg.item.tmp.from_reward = item.tmp.from_reward
    end
    if item ~= nil and item.mount_fashion_activated ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.mount_fashion_activated = item.mount_fashion_activated
    end
    if item ~= nil and item.no_trade_reason ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.no_trade_reason = item.no_trade_reason
    end
    if item.card_info ~= nil and item.card_info.lv ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.card_info == nil then
        msg.item.card_info = {}
      end
      msg.item.card_info.lv = item.card_info.lv
    end
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.npcid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.npcid = data.npcid
    end
    if data ~= nil and data.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mapid = data.mapid
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
    if data ~= nil and data.dir ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.dir = data.dir
    end
    if data.pos ~= nil and data.pos.x ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.x = data.pos.x
    end
    if data.pos ~= nil and data.pos.y ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.y = data.pos.y
    end
    if data.pos ~= nil and data.pos.z ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.z = data.pos.z
    end
    if data ~= nil and data.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.status = data.status
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
    if data ~= nil and data.elements ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.elements == nil then
        msg.data.elements = {}
      end
      for i = 1, #data.elements do
        table.insert(msg.data.elements, data.elements[i])
      end
    end
    if data.weather ~= nil and data.weather.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.weather == nil then
        msg.data.weather = {}
      end
      msg.data.weather.id = data.weather.id
    end
    if data.weather ~= nil and data.weather.time ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.weather == nil then
        msg.data.weather = {}
      end
      msg.data.weather.time = data.weather.time
    end
    if data.block ~= nil and data.block.hp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.block == nil then
        msg.data.block = {}
      end
      msg.data.block.hp = data.block.hp
    end
    if data.timer ~= nil and data.timer.times ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.timer == nil then
        msg.data.timer = {}
      end
      msg.data.timer.times = data.timer.times
    end
    if data ~= nil and data.timer.datas ~= nil then
      if msg.data.timer == nil then
        msg.data.timer = {}
      end
      if msg.data.timer.datas == nil then
        msg.data.timer.datas = {}
      end
      for i = 1, #data.timer.datas do
        table.insert(msg.data.timer.datas, data.timer.datas[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildContributeUserCmd.id
    local msgParam = {}
    if item ~= nil and item.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.guid = item.guid
    end
    if item ~= nil and item.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.id = item.id
    end
    if item ~= nil and item.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.count = item.count
    end
    if item ~= nil and item.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.index = item.index
    end
    if item ~= nil and item.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.createtime = item.createtime
    end
    if item ~= nil and item.cd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.cd = item.cd
    end
    if item ~= nil and item.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.type = item.type
    end
    if item ~= nil and item.bind ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.bind = item.bind
    end
    if item ~= nil and item.expire ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.expire = item.expire
    end
    if item ~= nil and item.quality ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.quality = item.quality
    end
    if item ~= nil and item.equipType ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.equipType = item.equipType
    end
    if item ~= nil and item.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.source = item.source
    end
    if item ~= nil and item.isnew ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.isnew = item.isnew
    end
    if item ~= nil and item.maxcardslot ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.maxcardslot = item.maxcardslot
    end
    if item ~= nil and item.ishint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.ishint = item.ishint
    end
    if item ~= nil and item.isactive ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.isactive = item.isactive
    end
    if item ~= nil and item.source_npc ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.source_npc = item.source_npc
    end
    if item ~= nil and item.refinelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.refinelv = item.refinelv
    end
    if item ~= nil and item.chargemoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.chargemoney = item.chargemoney
    end
    if item ~= nil and item.overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.overtime = item.overtime
    end
    if item ~= nil and item.quota ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.quota = item.quota
    end
    if item ~= nil and item.usedtimes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.usedtimes = item.usedtimes
    end
    if item ~= nil and item.usedtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.usedtime = item.usedtime
    end
    if item ~= nil and item.isfavorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.isfavorite = item.isfavorite
    end
    if item ~= nil and item.mailhint ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.mailhint == nil then
        msgParam.item.mailhint = {}
      end
      for i = 1, #item.mailhint do
        table.insert(msgParam.item.mailhint, item.mailhint[i])
      end
    end
    if item ~= nil and item.subsource ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.subsource = item.subsource
    end
    if item ~= nil and item.randkey ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.randkey = item.randkey
    end
    if item ~= nil and item.sceneinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.sceneinfo = item.sceneinfo
    end
    if item ~= nil and item.local_charge ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.local_charge = item.local_charge
    end
    if item ~= nil and item.charge_deposit_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.charge_deposit_id = item.charge_deposit_id
    end
    if item ~= nil and item.issplit ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.issplit = item.issplit
    end
    if item.tmp ~= nil and item.tmp.none ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.tmp == nil then
        msgParam.item.tmp = {}
      end
      msgParam.item.tmp.none = item.tmp.none
    end
    if item.tmp ~= nil and item.tmp.num_param ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.tmp == nil then
        msgParam.item.tmp = {}
      end
      msgParam.item.tmp.num_param = item.tmp.num_param
    end
    if item.tmp ~= nil and item.tmp.from_reward ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.tmp == nil then
        msgParam.item.tmp = {}
      end
      msgParam.item.tmp.from_reward = item.tmp.from_reward
    end
    if item ~= nil and item.mount_fashion_activated ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.mount_fashion_activated = item.mount_fashion_activated
    end
    if item ~= nil and item.no_trade_reason ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.no_trade_reason = item.no_trade_reason
    end
    if item.card_info ~= nil and item.card_info.lv ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.card_info == nil then
        msgParam.item.card_info = {}
      end
      msgParam.item.card_info.lv = item.card_info.lv
    end
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.npcid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.npcid = data.npcid
    end
    if data ~= nil and data.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mapid = data.mapid
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
    if data ~= nil and data.dir ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.dir = data.dir
    end
    if data.pos ~= nil and data.pos.x ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.x = data.pos.x
    end
    if data.pos ~= nil and data.pos.y ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.y = data.pos.y
    end
    if data.pos ~= nil and data.pos.z ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.z = data.pos.z
    end
    if data ~= nil and data.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.status = data.status
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
    if data ~= nil and data.elements ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.elements == nil then
        msgParam.data.elements = {}
      end
      for i = 1, #data.elements do
        table.insert(msgParam.data.elements, data.elements[i])
      end
    end
    if data.weather ~= nil and data.weather.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.weather == nil then
        msgParam.data.weather = {}
      end
      msgParam.data.weather.id = data.weather.id
    end
    if data.weather ~= nil and data.weather.time ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.weather == nil then
        msgParam.data.weather = {}
      end
      msgParam.data.weather.time = data.weather.time
    end
    if data.block ~= nil and data.block.hp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.block == nil then
        msgParam.data.block = {}
      end
      msgParam.data.block.hp = data.block.hp
    end
    if data.timer ~= nil and data.timer.times ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.timer == nil then
        msgParam.data.timer = {}
      end
      msgParam.data.timer.times = data.timer.times
    end
    if data ~= nil and data.timer.datas ~= nil then
      if msgParam.data.timer == nil then
        msgParam.data.timer = {}
      end
      if msgParam.data.timer.datas == nil then
        msgParam.data.timer.datas = {}
      end
      for i = 1, #data.timer.datas do
        table.insert(msgParam.data.timer.datas, data.timer.datas[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallBuildOperateUserCmd(id, data, success, count)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.BuildOperateUserCmd()
    if id ~= nil then
      msg.id = id
    end
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.npcid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.npcid = data.npcid
    end
    if data ~= nil and data.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mapid = data.mapid
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
    if data ~= nil and data.dir ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.dir = data.dir
    end
    if data.pos ~= nil and data.pos.x ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.x = data.pos.x
    end
    if data.pos ~= nil and data.pos.y ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.y = data.pos.y
    end
    if data.pos ~= nil and data.pos.z ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.pos == nil then
        msg.data.pos = {}
      end
      msg.data.pos.z = data.pos.z
    end
    if data ~= nil and data.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.status = data.status
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
    if data ~= nil and data.elements ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.elements == nil then
        msg.data.elements = {}
      end
      for i = 1, #data.elements do
        table.insert(msg.data.elements, data.elements[i])
      end
    end
    if data.weather ~= nil and data.weather.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.weather == nil then
        msg.data.weather = {}
      end
      msg.data.weather.id = data.weather.id
    end
    if data.weather ~= nil and data.weather.time ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.weather == nil then
        msg.data.weather = {}
      end
      msg.data.weather.time = data.weather.time
    end
    if data.block ~= nil and data.block.hp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.block == nil then
        msg.data.block = {}
      end
      msg.data.block.hp = data.block.hp
    end
    if data.timer ~= nil and data.timer.times ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.timer == nil then
        msg.data.timer = {}
      end
      msg.data.timer.times = data.timer.times
    end
    if data ~= nil and data.timer.datas ~= nil then
      if msg.data.timer == nil then
        msg.data.timer = {}
      end
      if msg.data.timer.datas == nil then
        msg.data.timer.datas = {}
      end
      for i = 1, #data.timer.datas do
        table.insert(msg.data.timer.datas, data.timer.datas[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildOperateUserCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.npcid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.npcid = data.npcid
    end
    if data ~= nil and data.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mapid = data.mapid
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
    if data ~= nil and data.dir ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.dir = data.dir
    end
    if data.pos ~= nil and data.pos.x ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.x = data.pos.x
    end
    if data.pos ~= nil and data.pos.y ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.y = data.pos.y
    end
    if data.pos ~= nil and data.pos.z ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.pos == nil then
        msgParam.data.pos = {}
      end
      msgParam.data.pos.z = data.pos.z
    end
    if data ~= nil and data.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.status = data.status
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
    if data ~= nil and data.elements ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.elements == nil then
        msgParam.data.elements = {}
      end
      for i = 1, #data.elements do
        table.insert(msgParam.data.elements, data.elements[i])
      end
    end
    if data.weather ~= nil and data.weather.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.weather == nil then
        msgParam.data.weather = {}
      end
      msgParam.data.weather.id = data.weather.id
    end
    if data.weather ~= nil and data.weather.time ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.weather == nil then
        msgParam.data.weather = {}
      end
      msgParam.data.weather.time = data.weather.time
    end
    if data.block ~= nil and data.block.hp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.block == nil then
        msgParam.data.block = {}
      end
      msgParam.data.block.hp = data.block.hp
    end
    if data.timer ~= nil and data.timer.times ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.timer == nil then
        msgParam.data.timer = {}
      end
      msgParam.data.timer.times = data.timer.times
    end
    if data ~= nil and data.timer.datas ~= nil then
      if msgParam.data.timer == nil then
        msgParam.data.timer = {}
      end
      if msgParam.data.timer.datas == nil then
        msgParam.data.timer.datas = {}
      end
      for i = 1, #data.timer.datas do
        table.insert(msgParam.data.timer.datas, data.timer.datas[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNightmareAttrQueryUserCmd(count)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NightmareAttrQueryUserCmd()
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NightmareAttrQueryUserCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNightmareAttrGetUserCmd(count, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NightmareAttrGetUserCmd()
    if count ~= nil then
      msg.count = count
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NightmareAttrGetUserCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallMapAnimeUserCmd(mapid, animeid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.MapAnimeUserCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if animeid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.animeid == nil then
        msg.animeid = {}
      end
      for i = 1, #animeid do
        table.insert(msg.animeid, animeid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapAnimeUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if animeid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.animeid == nil then
        msgParam.animeid = {}
      end
      for i = 1, #animeid do
        table.insert(msgParam.animeid, animeid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallShootNpcUserCmd(npcguid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ShootNpcUserCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShootNpcUserCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallPaySignNtfUserCmd(infos)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PaySignNtfUserCmd()
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
    local msgId = ProtoReqInfoList.PaySignNtfUserCmd.id
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

function ServiceNUserAutoProxy:CallPaySignBuyUserCmd(activityid, info)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PaySignBuyUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.rewardday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.rewardday = info.rewardday
    end
    if info ~= nil and info.unrewardday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.unrewardday = info.unrewardday
    end
    if info ~= nil and info.starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.starttime = info.starttime
    end
    if info ~= nil and info.buytime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.buytime = info.buytime
    end
    if info ~= nil and info.freereward ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.freereward = info.freereward
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PaySignBuyUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.rewardday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.rewardday = info.rewardday
    end
    if info ~= nil and info.unrewardday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.unrewardday = info.unrewardday
    end
    if info ~= nil and info.starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.starttime = info.starttime
    end
    if info ~= nil and info.buytime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.buytime = info.buytime
    end
    if info ~= nil and info.freereward ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.freereward = info.freereward
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallPaySignRewardUserCmd(activityid, info, free)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.PaySignRewardUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.rewardday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.rewardday = info.rewardday
    end
    if info ~= nil and info.unrewardday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.unrewardday = info.unrewardday
    end
    if info ~= nil and info.starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.starttime = info.starttime
    end
    if info ~= nil and info.buytime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.buytime = info.buytime
    end
    if info ~= nil and info.freereward ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.freereward = info.freereward
    end
    if free ~= nil then
      msg.free = free
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PaySignRewardUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.rewardday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.rewardday = info.rewardday
    end
    if info ~= nil and info.unrewardday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.unrewardday = info.unrewardday
    end
    if info ~= nil and info.starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.starttime = info.starttime
    end
    if info ~= nil and info.buytime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.buytime = info.buytime
    end
    if info ~= nil and info.freereward ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.freereward = info.freereward
    end
    if free ~= nil then
      msgParam.free = free
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallExtractionQueryUserCmd(gridcount, activeids, datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExtractionQueryUserCmd()
    if gridcount ~= nil then
      msg.gridcount = gridcount
    end
    if activeids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.activeids == nil then
        msg.activeids = {}
      end
      for i = 1, #activeids do
        table.insert(msg.activeids, activeids[i])
      end
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
    local msgId = ProtoReqInfoList.ExtractionQueryUserCmd.id
    local msgParam = {}
    if gridcount ~= nil then
      msgParam.gridcount = gridcount
    end
    if activeids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.activeids == nil then
        msgParam.activeids = {}
      end
      for i = 1, #activeids do
        table.insert(msgParam.activeids, activeids[i])
      end
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

function ServiceNUserAutoProxy:CallExtractionOperateUserCmd(gridid, guid, data)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExtractionOperateUserCmd()
    if gridid ~= nil then
      msg.gridid = gridid
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if data ~= nil and data.gridid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.gridid = data.gridid
    end
    if data ~= nil and data.itemid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.itemid = data.itemid
    end
    if data ~= nil and data.refinelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.refinelv = data.refinelv
    end
    if data ~= nil and data.lv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.lv = data.lv
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
    local msgId = ProtoReqInfoList.ExtractionOperateUserCmd.id
    local msgParam = {}
    if gridid ~= nil then
      msgParam.gridid = gridid
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if data ~= nil and data.gridid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.gridid = data.gridid
    end
    if data ~= nil and data.itemid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.itemid = data.itemid
    end
    if data ~= nil and data.refinelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.refinelv = data.refinelv
    end
    if data ~= nil and data.lv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.lv = data.lv
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

function ServiceNUserAutoProxy:CallExtractionActiveUserCmd(gridid, activeids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExtractionActiveUserCmd()
    if gridid ~= nil then
      msg.gridid = gridid
    end
    if activeids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.activeids == nil then
        msg.activeids = {}
      end
      for i = 1, #activeids do
        table.insert(msg.activeids, activeids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExtractionActiveUserCmd.id
    local msgParam = {}
    if gridid ~= nil then
      msgParam.gridid = gridid
    end
    if activeids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.activeids == nil then
        msgParam.activeids = {}
      end
      for i = 1, #activeids do
        table.insert(msgParam.activeids, activeids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallExtractionRemoveUserCmd(gridid, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExtractionRemoveUserCmd()
    if gridid ~= nil then
      msg.gridid = gridid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExtractionRemoveUserCmd.id
    local msgParam = {}
    if gridid ~= nil then
      msgParam.gridid = gridid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallExtractionGridBuyUserCmd(gridcount)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExtractionGridBuyUserCmd()
    if gridcount ~= nil then
      msg.gridcount = gridcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExtractionGridBuyUserCmd.id
    local msgParam = {}
    if gridcount ~= nil then
      msgParam.gridcount = gridcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallExtractionRefreshUserCmd(gridid, use_gold, data, update_type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExtractionRefreshUserCmd()
    if gridid ~= nil then
      msg.gridid = gridid
    end
    if use_gold ~= nil then
      msg.use_gold = use_gold
    end
    if data ~= nil and data.gridid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.gridid = data.gridid
    end
    if data ~= nil and data.itemid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.itemid = data.itemid
    end
    if data ~= nil and data.refinelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.refinelv = data.refinelv
    end
    if data ~= nil and data.lv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.lv = data.lv
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
    if update_type ~= nil then
      msg.update_type = update_type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExtractionRefreshUserCmd.id
    local msgParam = {}
    if gridid ~= nil then
      msgParam.gridid = gridid
    end
    if use_gold ~= nil then
      msgParam.use_gold = use_gold
    end
    if data ~= nil and data.gridid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.gridid = data.gridid
    end
    if data ~= nil and data.itemid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.itemid = data.itemid
    end
    if data ~= nil and data.refinelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.refinelv = data.refinelv
    end
    if data ~= nil and data.lv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.lv = data.lv
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
    if update_type ~= nil then
      msgParam.update_type = update_type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallTeamExpRewardTypeCmd(raidid, type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.TeamExpRewardTypeCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamExpRewardTypeCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSetMyselfOptionCmd(fashionhide)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetMyselfOptionCmd()
    if fashionhide ~= nil then
      msg.fashionhide = fashionhide
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetMyselfOptionCmd.id
    local msgParam = {}
    if fashionhide ~= nil then
      msgParam.fashionhide = fashionhide
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUseSkillEffectItemUserCmd(itemid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UseSkillEffectItemUserCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseSkillEffectItemUserCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallRideMultiMountUserCmd(ride_owner_id, mount_pos)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.RideMultiMountUserCmd()
    if ride_owner_id ~= nil then
      msg.ride_owner_id = ride_owner_id
    end
    if mount_pos ~= nil then
      msg.mount_pos = mount_pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RideMultiMountUserCmd.id
    local msgParam = {}
    if ride_owner_id ~= nil then
      msgParam.ride_owner_id = ride_owner_id
    end
    if mount_pos ~= nil then
      msgParam.mount_pos = mount_pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallKickOffPassengerUserCmd(kick_charid, all, need_punish, kick_npc, forbid_npc)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.KickOffPassengerUserCmd()
    if kick_charid ~= nil then
      msg.kick_charid = kick_charid
    end
    if all ~= nil then
      msg.all = all
    end
    if need_punish ~= nil then
      msg.need_punish = need_punish
    end
    if kick_npc ~= nil then
      msg.kick_npc = kick_npc
    end
    if forbid_npc ~= nil then
      msg.forbid_npc = forbid_npc
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickOffPassengerUserCmd.id
    local msgParam = {}
    if kick_charid ~= nil then
      msgParam.kick_charid = kick_charid
    end
    if all ~= nil then
      msgParam.all = all
    end
    if need_punish ~= nil then
      msgParam.need_punish = need_punish
    end
    if kick_npc ~= nil then
      msgParam.kick_npc = kick_npc
    end
    if forbid_npc ~= nil then
      msgParam.forbid_npc = forbid_npc
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSetMultiMountOptUserCmd(mount_opt)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetMultiMountOptUserCmd()
    if mount_opt ~= nil then
      msg.mount_opt = mount_opt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetMultiMountOptUserCmd.id
    local msgParam = {}
    if mount_opt ~= nil then
      msgParam.mount_opt = mount_opt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallMultiMountChangePosUserCmd(result_pos)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.MultiMountChangePosUserCmd()
    if result_pos ~= nil then
      msg.result_pos = result_pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MultiMountChangePosUserCmd.id
    local msgParam = {}
    if result_pos ~= nil then
      msgParam.result_pos = result_pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGrouponQueryUserCmd(activityid, info)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GrouponQueryUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.total_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.total_count = info.total_count
    end
    if info ~= nil and info.progressid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.progressid == nil then
        msg.info.progressid = {}
      end
      for i = 1, #info.progressid do
        table.insert(msg.info.progressid, info.progressid[i])
      end
    end
    if info ~= nil and info.records ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.records == nil then
        msg.info.records = {}
      end
      for i = 1, #info.records do
        table.insert(msg.info.records, info.records[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GrouponQueryUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.total_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.total_count = info.total_count
    end
    if info ~= nil and info.progressid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.progressid == nil then
        msgParam.info.progressid = {}
      end
      for i = 1, #info.progressid do
        table.insert(msgParam.info.progressid, info.progressid[i])
      end
    end
    if info ~= nil and info.records ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.records == nil then
        msgParam.info.records = {}
      end
      for i = 1, #info.records do
        table.insert(msgParam.info.records, info.records[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGrouponBuyUserCmd(activityid, count, price, info)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GrouponBuyUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if count ~= nil then
      msg.count = count
    end
    if price ~= nil then
      msg.price = price
    end
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.total_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.total_count = info.total_count
    end
    if info ~= nil and info.progressid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.progressid == nil then
        msg.info.progressid = {}
      end
      for i = 1, #info.progressid do
        table.insert(msg.info.progressid, info.progressid[i])
      end
    end
    if info ~= nil and info.records ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.records == nil then
        msg.info.records = {}
      end
      for i = 1, #info.records do
        table.insert(msg.info.records, info.records[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GrouponBuyUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if price ~= nil then
      msgParam.price = price
    end
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.total_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.total_count = info.total_count
    end
    if info ~= nil and info.progressid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.progressid == nil then
        msgParam.info.progressid = {}
      end
      for i = 1, #info.progressid do
        table.insert(msgParam.info.progressid, info.progressid[i])
      end
    end
    if info ~= nil and info.records ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.records == nil then
        msgParam.info.records = {}
      end
      for i = 1, #info.records do
        table.insert(msgParam.info.records, info.records[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallGrouponRewardUserCmd(activityid, progressid, info)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.GrouponRewardUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if progressid ~= nil then
      msg.progressid = progressid
    end
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.total_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.total_count = info.total_count
    end
    if info ~= nil and info.progressid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.progressid == nil then
        msg.info.progressid = {}
      end
      for i = 1, #info.progressid do
        table.insert(msg.info.progressid, info.progressid[i])
      end
    end
    if info ~= nil and info.records ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.records == nil then
        msg.info.records = {}
      end
      for i = 1, #info.records do
        table.insert(msg.info.records, info.records[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GrouponRewardUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if progressid ~= nil then
      msgParam.progressid = progressid
    end
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.total_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.total_count = info.total_count
    end
    if info ~= nil and info.progressid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.progressid == nil then
        msgParam.info.progressid = {}
      end
      for i = 1, #info.progressid do
        table.insert(msgParam.info.progressid, info.progressid[i])
      end
    end
    if info ~= nil and info.records ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.records == nil then
        msgParam.info.records = {}
      end
      for i = 1, #info.records do
        table.insert(msgParam.info.records, info.records[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNtfPlayActUserCmd(isclose, isfirst, serverid, version)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NtfPlayActUserCmd()
    if isclose ~= nil then
      msg.isclose = isclose
    end
    if isfirst ~= nil then
      msg.isfirst = isfirst
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfPlayActUserCmd.id
    local msgParam = {}
    if isclose ~= nil then
      msgParam.isclose = isclose
    end
    if isfirst ~= nil then
      msgParam.isfirst = isfirst
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallNoviceTargetUpdateUserCmd(datas, day, dels)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NoviceTargetUpdateUserCmd()
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
    if day ~= nil then
      msg.day = day
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
    local msgId = ProtoReqInfoList.NoviceTargetUpdateUserCmd.id
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
    if day ~= nil then
      msgParam.day = day
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

function ServiceNUserAutoProxy:CallNoviceTargetRewardUserCmd(id, day, num, datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.NoviceTargetRewardUserCmd()
    if id ~= nil then
      msg.id = id
    end
    if day ~= nil then
      msg.day = day
    end
    if num ~= nil then
      msg.num = num
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
    local msgId = ProtoReqInfoList.NoviceTargetRewardUserCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if day ~= nil then
      msgParam.day = day
    end
    if num ~= nil then
      msgParam.num = num
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

function ServiceNUserAutoProxy:CallSetBoKiStateUserCmd(state)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetBoKiStateUserCmd()
    if state ~= nil then
      msg.state = state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetBoKiStateUserCmd.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCloseDialogMaskUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CloseDialogMaskUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CloseDialogMaskUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCloseDialogCameraUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CloseDialogCameraUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CloseDialogCameraUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHideUIUserCmd(id, open)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HideUIUserCmd()
    if id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.id == nil then
        msg.id = {}
      end
      for i = 1, #id do
        table.insert(msg.id, id[i])
      end
    end
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HideUIUserCmd.id
    local msgParam = {}
    if id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.id == nil then
        msgParam.id = {}
      end
      for i = 1, #id do
        table.insert(msgParam.id, id[i])
      end
    end
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryMapMonsterRefreshInfo(curmonsterids, nextmonsterids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryMapMonsterRefreshInfo()
    if curmonsterids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.curmonsterids == nil then
        msg.curmonsterids = {}
      end
      for i = 1, #curmonsterids do
        table.insert(msg.curmonsterids, curmonsterids[i])
      end
    end
    if nextmonsterids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.nextmonsterids == nil then
        msg.nextmonsterids = {}
      end
      for i = 1, #nextmonsterids do
        table.insert(msg.nextmonsterids, nextmonsterids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMapMonsterRefreshInfo.id
    local msgParam = {}
    if curmonsterids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.curmonsterids == nil then
        msgParam.curmonsterids = {}
      end
      for i = 1, #curmonsterids do
        table.insert(msgParam.curmonsterids, curmonsterids[i])
      end
    end
    if nextmonsterids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.nextmonsterids == nil then
        msgParam.nextmonsterids = {}
      end
      for i = 1, #nextmonsterids do
        table.insert(msgParam.nextmonsterids, nextmonsterids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSetCameraUserCmd(reset, camera_dir, role_dir, zoom, filter_effect, hide)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SetCameraUserCmd()
    if reset ~= nil then
      msg.reset = reset
    end
    if camera_dir ~= nil and camera_dir.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camera_dir == nil then
        msg.camera_dir = {}
      end
      msg.camera_dir.x = camera_dir.x
    end
    if camera_dir ~= nil and camera_dir.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camera_dir == nil then
        msg.camera_dir = {}
      end
      msg.camera_dir.y = camera_dir.y
    end
    if camera_dir ~= nil and camera_dir.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.camera_dir == nil then
        msg.camera_dir = {}
      end
      msg.camera_dir.z = camera_dir.z
    end
    if role_dir ~= nil then
      msg.role_dir = role_dir
    end
    if zoom ~= nil then
      msg.zoom = zoom
    end
    if filter_effect ~= nil then
      msg.filter_effect = filter_effect
    end
    if hide ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.hide == nil then
        msg.hide = {}
      end
      for i = 1, #hide do
        table.insert(msg.hide, hide[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetCameraUserCmd.id
    local msgParam = {}
    if reset ~= nil then
      msgParam.reset = reset
    end
    if camera_dir ~= nil and camera_dir.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camera_dir == nil then
        msgParam.camera_dir = {}
      end
      msgParam.camera_dir.x = camera_dir.x
    end
    if camera_dir ~= nil and camera_dir.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camera_dir == nil then
        msgParam.camera_dir = {}
      end
      msgParam.camera_dir.y = camera_dir.y
    end
    if camera_dir ~= nil and camera_dir.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.camera_dir == nil then
        msgParam.camera_dir = {}
      end
      msgParam.camera_dir.z = camera_dir.z
    end
    if role_dir ~= nil then
      msgParam.role_dir = role_dir
    end
    if zoom ~= nil then
      msgParam.zoom = zoom
    end
    if filter_effect ~= nil then
      msgParam.filter_effect = filter_effect
    end
    if hide ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.hide == nil then
        msgParam.hide = {}
      end
      for i = 1, #hide do
        table.insert(msgParam.hide, hide[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallQueryProfessionDataDetailUserCmd(type)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.QueryProfessionDataDetailUserCmd()
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryProfessionDataDetailUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallClearProfessionDataDetailUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ClearProfessionDataDetailUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClearProfessionDataDetailUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChainExchangeUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChainExchangeUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChainExchangeUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChainOptUserCmd(active)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChainOptUserCmd()
    if active ~= nil then
      msg.active = active
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChainOptUserCmd.id
    local msgParam = {}
    if active ~= nil then
      msgParam.active = active
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallActivityDonateQueryUserCmd(activityid, times)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ActivityDonateQueryUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if times ~= nil then
      msg.times = times
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityDonateQueryUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if times ~= nil then
      msgParam.times = times
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallActivityDonateRewardUserCmd(activityid, itemcost, times, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ActivityDonateRewardUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if itemcost ~= nil and itemcost.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.guid = itemcost.guid
    end
    if itemcost ~= nil and itemcost.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.id = itemcost.id
    end
    if itemcost ~= nil and itemcost.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.count = itemcost.count
    end
    if itemcost ~= nil and itemcost.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.index = itemcost.index
    end
    if itemcost ~= nil and itemcost.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.createtime = itemcost.createtime
    end
    if itemcost ~= nil and itemcost.cd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.cd = itemcost.cd
    end
    if itemcost ~= nil and itemcost.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.type = itemcost.type
    end
    if itemcost ~= nil and itemcost.bind ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.bind = itemcost.bind
    end
    if itemcost ~= nil and itemcost.expire ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.expire = itemcost.expire
    end
    if itemcost ~= nil and itemcost.quality ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.quality = itemcost.quality
    end
    if itemcost ~= nil and itemcost.equipType ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.equipType = itemcost.equipType
    end
    if itemcost ~= nil and itemcost.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.source = itemcost.source
    end
    if itemcost ~= nil and itemcost.isnew ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.isnew = itemcost.isnew
    end
    if itemcost ~= nil and itemcost.maxcardslot ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.maxcardslot = itemcost.maxcardslot
    end
    if itemcost ~= nil and itemcost.ishint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.ishint = itemcost.ishint
    end
    if itemcost ~= nil and itemcost.isactive ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.isactive = itemcost.isactive
    end
    if itemcost ~= nil and itemcost.source_npc ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.source_npc = itemcost.source_npc
    end
    if itemcost ~= nil and itemcost.refinelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.refinelv = itemcost.refinelv
    end
    if itemcost ~= nil and itemcost.chargemoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.chargemoney = itemcost.chargemoney
    end
    if itemcost ~= nil and itemcost.overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.overtime = itemcost.overtime
    end
    if itemcost ~= nil and itemcost.quota ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.quota = itemcost.quota
    end
    if itemcost ~= nil and itemcost.usedtimes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.usedtimes = itemcost.usedtimes
    end
    if itemcost ~= nil and itemcost.usedtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.usedtime = itemcost.usedtime
    end
    if itemcost ~= nil and itemcost.isfavorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.isfavorite = itemcost.isfavorite
    end
    if itemcost ~= nil and itemcost.mailhint ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.mailhint == nil then
        msg.itemcost.mailhint = {}
      end
      for i = 1, #itemcost.mailhint do
        table.insert(msg.itemcost.mailhint, itemcost.mailhint[i])
      end
    end
    if itemcost ~= nil and itemcost.subsource ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.subsource = itemcost.subsource
    end
    if itemcost ~= nil and itemcost.randkey ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.randkey = itemcost.randkey
    end
    if itemcost ~= nil and itemcost.sceneinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.sceneinfo = itemcost.sceneinfo
    end
    if itemcost ~= nil and itemcost.local_charge ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.local_charge = itemcost.local_charge
    end
    if itemcost ~= nil and itemcost.charge_deposit_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.charge_deposit_id = itemcost.charge_deposit_id
    end
    if itemcost ~= nil and itemcost.issplit ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.issplit = itemcost.issplit
    end
    if itemcost.tmp ~= nil and itemcost.tmp.none ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.tmp == nil then
        msg.itemcost.tmp = {}
      end
      msg.itemcost.tmp.none = itemcost.tmp.none
    end
    if itemcost.tmp ~= nil and itemcost.tmp.num_param ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.tmp == nil then
        msg.itemcost.tmp = {}
      end
      msg.itemcost.tmp.num_param = itemcost.tmp.num_param
    end
    if itemcost.tmp ~= nil and itemcost.tmp.from_reward ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.tmp == nil then
        msg.itemcost.tmp = {}
      end
      msg.itemcost.tmp.from_reward = itemcost.tmp.from_reward
    end
    if itemcost ~= nil and itemcost.mount_fashion_activated ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.mount_fashion_activated = itemcost.mount_fashion_activated
    end
    if itemcost ~= nil and itemcost.no_trade_reason ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.no_trade_reason = itemcost.no_trade_reason
    end
    if itemcost.card_info ~= nil and itemcost.card_info.lv ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.card_info == nil then
        msg.itemcost.card_info = {}
      end
      msg.itemcost.card_info.lv = itemcost.card_info.lv
    end
    if times ~= nil then
      msg.times = times
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityDonateRewardUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if itemcost ~= nil and itemcost.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.guid = itemcost.guid
    end
    if itemcost ~= nil and itemcost.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.id = itemcost.id
    end
    if itemcost ~= nil and itemcost.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.count = itemcost.count
    end
    if itemcost ~= nil and itemcost.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.index = itemcost.index
    end
    if itemcost ~= nil and itemcost.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.createtime = itemcost.createtime
    end
    if itemcost ~= nil and itemcost.cd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.cd = itemcost.cd
    end
    if itemcost ~= nil and itemcost.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.type = itemcost.type
    end
    if itemcost ~= nil and itemcost.bind ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.bind = itemcost.bind
    end
    if itemcost ~= nil and itemcost.expire ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.expire = itemcost.expire
    end
    if itemcost ~= nil and itemcost.quality ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.quality = itemcost.quality
    end
    if itemcost ~= nil and itemcost.equipType ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.equipType = itemcost.equipType
    end
    if itemcost ~= nil and itemcost.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.source = itemcost.source
    end
    if itemcost ~= nil and itemcost.isnew ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.isnew = itemcost.isnew
    end
    if itemcost ~= nil and itemcost.maxcardslot ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.maxcardslot = itemcost.maxcardslot
    end
    if itemcost ~= nil and itemcost.ishint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.ishint = itemcost.ishint
    end
    if itemcost ~= nil and itemcost.isactive ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.isactive = itemcost.isactive
    end
    if itemcost ~= nil and itemcost.source_npc ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.source_npc = itemcost.source_npc
    end
    if itemcost ~= nil and itemcost.refinelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.refinelv = itemcost.refinelv
    end
    if itemcost ~= nil and itemcost.chargemoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.chargemoney = itemcost.chargemoney
    end
    if itemcost ~= nil and itemcost.overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.overtime = itemcost.overtime
    end
    if itemcost ~= nil and itemcost.quota ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.quota = itemcost.quota
    end
    if itemcost ~= nil and itemcost.usedtimes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.usedtimes = itemcost.usedtimes
    end
    if itemcost ~= nil and itemcost.usedtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.usedtime = itemcost.usedtime
    end
    if itemcost ~= nil and itemcost.isfavorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.isfavorite = itemcost.isfavorite
    end
    if itemcost ~= nil and itemcost.mailhint ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.mailhint == nil then
        msgParam.itemcost.mailhint = {}
      end
      for i = 1, #itemcost.mailhint do
        table.insert(msgParam.itemcost.mailhint, itemcost.mailhint[i])
      end
    end
    if itemcost ~= nil and itemcost.subsource ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.subsource = itemcost.subsource
    end
    if itemcost ~= nil and itemcost.randkey ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.randkey = itemcost.randkey
    end
    if itemcost ~= nil and itemcost.sceneinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.sceneinfo = itemcost.sceneinfo
    end
    if itemcost ~= nil and itemcost.local_charge ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.local_charge = itemcost.local_charge
    end
    if itemcost ~= nil and itemcost.charge_deposit_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.charge_deposit_id = itemcost.charge_deposit_id
    end
    if itemcost ~= nil and itemcost.issplit ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.issplit = itemcost.issplit
    end
    if itemcost.tmp ~= nil and itemcost.tmp.none ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.tmp == nil then
        msgParam.itemcost.tmp = {}
      end
      msgParam.itemcost.tmp.none = itemcost.tmp.none
    end
    if itemcost.tmp ~= nil and itemcost.tmp.num_param ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.tmp == nil then
        msgParam.itemcost.tmp = {}
      end
      msgParam.itemcost.tmp.num_param = itemcost.tmp.num_param
    end
    if itemcost.tmp ~= nil and itemcost.tmp.from_reward ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.tmp == nil then
        msgParam.itemcost.tmp = {}
      end
      msgParam.itemcost.tmp.from_reward = itemcost.tmp.from_reward
    end
    if itemcost ~= nil and itemcost.mount_fashion_activated ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.mount_fashion_activated = itemcost.mount_fashion_activated
    end
    if itemcost ~= nil and itemcost.no_trade_reason ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.no_trade_reason = itemcost.no_trade_reason
    end
    if itemcost.card_info ~= nil and itemcost.card_info.lv ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.card_info == nil then
        msgParam.itemcost.card_info = {}
      end
      msgParam.itemcost.card_info.lv = itemcost.card_info.lv
    end
    if times ~= nil then
      msgParam.times = times
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChangeHairUserCmd(hairid, colorid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChangeHairUserCmd()
    if hairid ~= nil then
      msg.hairid = hairid
    end
    if colorid ~= nil then
      msg.colorid = colorid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeHairUserCmd.id
    local msgParam = {}
    if hairid ~= nil then
      msgParam.hairid = hairid
    end
    if colorid ~= nil then
      msgParam.colorid = colorid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallChangeEyeUserCmd(eyeid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ChangeEyeUserCmd()
    if eyeid ~= nil then
      msg.eyeid = eyeid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeEyeUserCmd.id
    local msgParam = {}
    if eyeid ~= nil then
      msgParam.eyeid = eyeid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallHappyValueUserCmd(value, indices)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.HappyValueUserCmd()
    if value ~= nil then
      msg.value = value
    end
    if indices ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.indices == nil then
        msg.indices = {}
      end
      for i = 1, #indices do
        table.insert(msg.indices, indices[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HappyValueUserCmd.id
    local msgParam = {}
    if value ~= nil then
      msgParam.value = value
    end
    if indices ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.indices == nil then
        msgParam.indices = {}
      end
      for i = 1, #indices do
        table.insert(msgParam.indices, indices[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSendTargetPosUserCmd(pos, sign, guid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SendTargetPosUserCmd()
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
    if sign ~= nil then
      msg.sign = sign
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SendTargetPosUserCmd.id
    local msgParam = {}
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
    if sign ~= nil then
      msgParam.sign = sign
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallCookGameFinishUserCmd(difficulty, daily, success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.CookGameFinishUserCmd()
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    if daily ~= nil then
      msg.daily = daily
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CookGameFinishUserCmd.id
    local msgParam = {}
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    if daily ~= nil then
      msgParam.daily = daily
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallRaceGameStartUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.RaceGameStartUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaceGameStartUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallRaceGameFinishUserCmd(success)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.RaceGameFinishUserCmd()
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaceGameFinishUserCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallSendMarksInfoUserCmd(buffid, guids)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.SendMarksInfoUserCmd()
    if buffid ~= nil then
      msg.buffid = buffid
    end
    if guids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guids == nil then
        msg.guids = {}
      end
      for i = 1, #guids do
        table.insert(msg.guids, guids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SendMarksInfoUserCmd.id
    local msgParam = {}
    if buffid ~= nil then
      msgParam.buffid = buffid
    end
    if guids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guids == nil then
        msgParam.guids = {}
      end
      for i = 1, #guids do
        table.insert(msgParam.guids, guids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserAutoProxy:CallUserSyncBuffFromUserCmd(guid, datas)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.UserSyncBuffFromUserCmd()
    if guid ~= nil then
      msg.guid = guid
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
    local msgId = ProtoReqInfoList.UserSyncBuffFromUserCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
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

function ServiceNUserAutoProxy:RecvGoCity(data)
  self:Notify(ServiceEvent.NUserGoCity, data)
end

function ServiceNUserAutoProxy:RecvSysMsg(data)
  self:Notify(ServiceEvent.NUserSysMsg, data)
end

function ServiceNUserAutoProxy:RecvNpcDataSync(data)
  self:Notify(ServiceEvent.NUserNpcDataSync, data)
end

function ServiceNUserAutoProxy:RecvUserNineSyncCmd(data)
  self:Notify(ServiceEvent.NUserUserNineSyncCmd, data)
end

function ServiceNUserAutoProxy:RecvUserActionNtf(data)
  self:Notify(ServiceEvent.NUserUserActionNtf, data)
end

function ServiceNUserAutoProxy:RecvUserBuffNineSyncCmd(data)
  self:Notify(ServiceEvent.NUserUserBuffNineSyncCmd, data)
end

function ServiceNUserAutoProxy:RecvExitPosUserCmd(data)
  self:Notify(ServiceEvent.NUserExitPosUserCmd, data)
end

function ServiceNUserAutoProxy:RecvRelive(data)
  self:Notify(ServiceEvent.NUserRelive, data)
end

function ServiceNUserAutoProxy:RecvVarUpdate(data)
  self:Notify(ServiceEvent.NUserVarUpdate, data)
end

function ServiceNUserAutoProxy:RecvTalkInfo(data)
  self:Notify(ServiceEvent.NUserTalkInfo, data)
end

function ServiceNUserAutoProxy:RecvServerTime(data)
  self:Notify(ServiceEvent.NUserServerTime, data)
end

function ServiceNUserAutoProxy:RecvEffectUserCmd(data)
  self:Notify(ServiceEvent.NUserEffectUserCmd, data)
end

function ServiceNUserAutoProxy:RecvMenuList(data)
  self:Notify(ServiceEvent.NUserMenuList, data)
end

function ServiceNUserAutoProxy:RecvNewMenu(data)
  self:Notify(ServiceEvent.NUserNewMenu, data)
end

function ServiceNUserAutoProxy:RecvEvaluationReward(data)
  self:Notify(ServiceEvent.NUserEvaluationReward, data)
end

function ServiceNUserAutoProxy:RecvTeamInfoNine(data)
  self:Notify(ServiceEvent.NUserTeamInfoNine, data)
end

function ServiceNUserAutoProxy:RecvUsePortrait(data)
  self:Notify(ServiceEvent.NUserUsePortrait, data)
end

function ServiceNUserAutoProxy:RecvUseFrame(data)
  self:Notify(ServiceEvent.NUserUseFrame, data)
end

function ServiceNUserAutoProxy:RecvUpdatePortraitFrame(data)
  self:Notify(ServiceEvent.NUserUpdatePortraitFrame, data)
end

function ServiceNUserAutoProxy:RecvQueryPortraitListUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryPortraitListUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUseDressing(data)
  self:Notify(ServiceEvent.NUserUseDressing, data)
end

function ServiceNUserAutoProxy:RecvNewDressing(data)
  self:Notify(ServiceEvent.NUserNewDressing, data)
end

function ServiceNUserAutoProxy:RecvDressingListUserCmd(data)
  self:Notify(ServiceEvent.NUserDressingListUserCmd, data)
end

function ServiceNUserAutoProxy:RecvAddAttrPoint(data)
  self:Notify(ServiceEvent.NUserAddAttrPoint, data)
end

function ServiceNUserAutoProxy:RecvQueryShopGotItem(data)
  self:Notify(ServiceEvent.NUserQueryShopGotItem, data)
end

function ServiceNUserAutoProxy:RecvUpdateShopGotItem(data)
  self:Notify(ServiceEvent.NUserUpdateShopGotItem, data)
end

function ServiceNUserAutoProxy:RecvOpenUI(data)
  self:Notify(ServiceEvent.NUserOpenUI, data)
end

function ServiceNUserAutoProxy:RecvDbgSysMsg(data)
  self:Notify(ServiceEvent.NUserDbgSysMsg, data)
end

function ServiceNUserAutoProxy:RecvFollowTransferCmd(data)
  self:Notify(ServiceEvent.NUserFollowTransferCmd, data)
end

function ServiceNUserAutoProxy:RecvCallNpcFuncCmd(data)
  self:Notify(ServiceEvent.NUserCallNpcFuncCmd, data)
end

function ServiceNUserAutoProxy:RecvModelShow(data)
  self:Notify(ServiceEvent.NUserModelShow, data)
end

function ServiceNUserAutoProxy:RecvSoundEffectCmd(data)
  self:Notify(ServiceEvent.NUserSoundEffectCmd, data)
end

function ServiceNUserAutoProxy:RecvPresetMsgCmd(data)
  self:Notify(ServiceEvent.NUserPresetMsgCmd, data)
end

function ServiceNUserAutoProxy:RecvChangeBgmCmd(data)
  self:Notify(ServiceEvent.NUserChangeBgmCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryFighterInfo(data)
  self:Notify(ServiceEvent.NUserQueryFighterInfo, data)
end

function ServiceNUserAutoProxy:RecvGameTimeCmd(data)
  self:Notify(ServiceEvent.NUserGameTimeCmd, data)
end

function ServiceNUserAutoProxy:RecvCDTimeUserCmd(data)
  self:Notify(ServiceEvent.NUserCDTimeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvStateChange(data)
  self:Notify(ServiceEvent.NUserStateChange, data)
end

function ServiceNUserAutoProxy:RecvPhoto(data)
  self:Notify(ServiceEvent.NUserPhoto, data)
end

function ServiceNUserAutoProxy:RecvShakeScreen(data)
  self:Notify(ServiceEvent.NUserShakeScreen, data)
end

function ServiceNUserAutoProxy:RecvQueryShortcut(data)
  self:Notify(ServiceEvent.NUserQueryShortcut, data)
end

function ServiceNUserAutoProxy:RecvPutShortcut(data)
  self:Notify(ServiceEvent.NUserPutShortcut, data)
end

function ServiceNUserAutoProxy:RecvTempPutShortCut(data)
  self:Notify(ServiceEvent.NUserTempPutShortCut, data)
end

function ServiceNUserAutoProxy:RecvNpcChangeAngle(data)
  self:Notify(ServiceEvent.NUserNpcChangeAngle, data)
end

function ServiceNUserAutoProxy:RecvCameraFocus(data)
  self:Notify(ServiceEvent.NUserCameraFocus, data)
end

function ServiceNUserAutoProxy:RecvGoToListUserCmd(data)
  self:Notify(ServiceEvent.NUserGoToListUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGoToGearUserCmd(data)
  self:Notify(ServiceEvent.NUserGoToGearUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNewTransMapCmd(data)
  self:Notify(ServiceEvent.NUserNewTransMapCmd, data)
end

function ServiceNUserAutoProxy:RecvDeathTransferListCmd(data)
  self:Notify(ServiceEvent.NUserDeathTransferListCmd, data)
end

function ServiceNUserAutoProxy:RecvNewDeathTransferCmd(data)
  self:Notify(ServiceEvent.NUserNewDeathTransferCmd, data)
end

function ServiceNUserAutoProxy:RecvUseDeathTransferCmd(data)
  self:Notify(ServiceEvent.NUserUseDeathTransferCmd, data)
end

function ServiceNUserAutoProxy:RecvFollowerUser(data)
  self:Notify(ServiceEvent.NUserFollowerUser, data)
end

function ServiceNUserAutoProxy:RecvBeFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserBeFollowUserCmd, data)
end

function ServiceNUserAutoProxy:RecvLaboratoryUserCmd(data)
  self:Notify(ServiceEvent.NUserLaboratoryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGotoLaboratoryUserCmd(data)
  self:Notify(ServiceEvent.NUserGotoLaboratoryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExchangeProfession(data)
  self:Notify(ServiceEvent.NUserExchangeProfession, data)
end

function ServiceNUserAutoProxy:RecvSceneryUserCmd(data)
  self:Notify(ServiceEvent.NUserSceneryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGoMapQuestUserCmd(data)
  self:Notify(ServiceEvent.NUserGoMapQuestUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGoMapFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserGoMapFollowUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUserAutoHitCmd(data)
  self:Notify(ServiceEvent.NUserUserAutoHitCmd, data)
end

function ServiceNUserAutoProxy:RecvUploadSceneryPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadSceneryPhotoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvDownloadSceneryPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserDownloadSceneryPhotoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryMapArea(data)
  self:Notify(ServiceEvent.NUserQueryMapArea, data)
end

function ServiceNUserAutoProxy:RecvNewMapAreaNtf(data)
  self:Notify(ServiceEvent.NUserNewMapAreaNtf, data)
end

function ServiceNUserAutoProxy:RecvBuffForeverCmd(data)
  self:Notify(ServiceEvent.NUserBuffForeverCmd, data)
end

function ServiceNUserAutoProxy:RecvInviteJoinHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteJoinHandsUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBreakUpHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserBreakUpHandsUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHandStatusUserCmd(data)
  self:Notify(ServiceEvent.NUserHandStatusUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryShow(data)
  self:Notify(ServiceEvent.NUserQueryShow, data)
end

function ServiceNUserAutoProxy:RecvQueryMusicList(data)
  self:Notify(ServiceEvent.NUserQueryMusicList, data)
end

function ServiceNUserAutoProxy:RecvDemandMusic(data)
  self:Notify(ServiceEvent.NUserDemandMusic, data)
end

function ServiceNUserAutoProxy:RecvCloseMusicFrame(data)
  self:Notify(ServiceEvent.NUserCloseMusicFrame, data)
end

function ServiceNUserAutoProxy:RecvUploadOkSceneryUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadOkSceneryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvJoinHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserJoinHandsUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryTraceList(data)
  self:Notify(ServiceEvent.NUserQueryTraceList, data)
end

function ServiceNUserAutoProxy:RecvUpdateTraceList(data)
  self:Notify(ServiceEvent.NUserUpdateTraceList, data)
end

function ServiceNUserAutoProxy:RecvSetDirection(data)
  self:Notify(ServiceEvent.NUserSetDirection, data)
end

function ServiceNUserAutoProxy:RecvBattleTimelenUserCmd(data)
  self:Notify(ServiceEvent.NUserBattleTimelenUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSetOptionUserCmd(data)
  self:Notify(ServiceEvent.NUserSetOptionUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryUserInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryUserInfoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCountDownTickUserCmd(data)
  self:Notify(ServiceEvent.NUserCountDownTickUserCmd, data)
end

function ServiceNUserAutoProxy:RecvItemMusicNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserItemMusicNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvShakeTreeUserCmd(data)
  self:Notify(ServiceEvent.NUserShakeTreeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvTreeListUserCmd(data)
  self:Notify(ServiceEvent.NUserTreeListUserCmd, data)
end

function ServiceNUserAutoProxy:RecvActivityNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserActivityNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryZoneStatusUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryZoneStatusUserCmd, data)
end

function ServiceNUserAutoProxy:RecvJumpZoneUserCmd(data)
  self:Notify(ServiceEvent.NUserJumpZoneUserCmd, data)
end

function ServiceNUserAutoProxy:RecvItemImageUserNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserItemImageUserNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvInviteFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteFollowUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChangeNameUserCmd(data)
  self:Notify(ServiceEvent.NUserChangeNameUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChargePlayUserCmd(data)
  self:Notify(ServiceEvent.NUserChargePlayUserCmd, data)
end

function ServiceNUserAutoProxy:RecvRequireNpcFuncUserCmd(data)
  self:Notify(ServiceEvent.NUserRequireNpcFuncUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCheckSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserCheckSeatUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNtfSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserNtfSeatUserCmd, data)
end

function ServiceNUserAutoProxy:RecvYoyoSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserYoyoSeatUserCmd, data)
end

function ServiceNUserAutoProxy:RecvShowSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserShowSeatUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSetNormalSkillOptionUserCmd(data)
  self:Notify(ServiceEvent.NUserSetNormalSkillOptionUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNewSetOptionUserCmd(data)
  self:Notify(ServiceEvent.NUserNewSetOptionUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUnsolvedSceneryNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserUnsolvedSceneryNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNtfVisibleNpcUserCmd(data)
  self:Notify(ServiceEvent.NUserNtfVisibleNpcUserCmd, data)
end

function ServiceNUserAutoProxy:RecvTransformPreDataCmd(data)
  self:Notify(ServiceEvent.NUserTransformPreDataCmd, data)
end

function ServiceNUserAutoProxy:RecvUserRenameCmd(data)
  self:Notify(ServiceEvent.NUserUserRenameCmd, data)
end

function ServiceNUserAutoProxy:RecvBuyZenyCmd(data)
  self:Notify(ServiceEvent.NUserBuyZenyCmd, data)
end

function ServiceNUserAutoProxy:RecvCallTeamerUserCmd(data)
  self:Notify(ServiceEvent.NUserCallTeamerUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCallTeamerReplyUserCmd(data)
  self:Notify(ServiceEvent.NUserCallTeamerReplyUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSpecialEffectCmd(data)
  self:Notify(ServiceEvent.NUserSpecialEffectCmd, data)
end

function ServiceNUserAutoProxy:RecvMarriageProposalCmd(data)
  self:Notify(ServiceEvent.NUserMarriageProposalCmd, data)
end

function ServiceNUserAutoProxy:RecvMarriageProposalReplyCmd(data)
  self:Notify(ServiceEvent.NUserMarriageProposalReplyCmd, data)
end

function ServiceNUserAutoProxy:RecvUploadWeddingPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadWeddingPhotoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvMarriageProposalSuccessCmd(data)
  self:Notify(ServiceEvent.NUserMarriageProposalSuccessCmd, data)
end

function ServiceNUserAutoProxy:RecvInviteeWeddingStartNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteeWeddingStartNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKFCShareUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCShareUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKFCEnrollUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKFCEnrollCodeUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollCodeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKFCEnrollReplyUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollReplyUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKFCEnrollQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKFCHasEnrolledUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCHasEnrolledUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCheckRelationUserCmd(data)
  self:Notify(ServiceEvent.NUserCheckRelationUserCmd, data)
end

function ServiceNUserAutoProxy:RecvTwinsActionUserCmd(data)
  self:Notify(ServiceEvent.NUserTwinsActionUserCmd, data)
end

function ServiceNUserAutoProxy:RecvShowServantUserCmd(data)
  self:Notify(ServiceEvent.NUserShowServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvReplaceServantUserCmd(data)
  self:Notify(ServiceEvent.NUserReplaceServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHireServantUserCmd(data)
  self:Notify(ServiceEvent.NUserHireServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantService(data)
  self:Notify(ServiceEvent.NUserServantService, data)
end

function ServiceNUserAutoProxy:RecvRecommendServantUserCmd(data)
  self:Notify(ServiceEvent.NUserRecommendServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvReceiveServantUserCmd(data)
  self:Notify(ServiceEvent.NUserReceiveServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantRewardStatusUserCmd(data)
  self:Notify(ServiceEvent.NUserServantRewardStatusUserCmd, data)
end

function ServiceNUserAutoProxy:RecvProfessionQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvProfessionBuyUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionBuyUserCmd, data)
end

function ServiceNUserAutoProxy:RecvProfessionChangeUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionChangeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUpdateRecordInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateRecordInfoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSaveRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserSaveRecordUserCmd, data)
end

function ServiceNUserAutoProxy:RecvLoadRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserLoadRecordUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChangeRecordNameUserCmd(data)
  self:Notify(ServiceEvent.NUserChangeRecordNameUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBuyRecordSlotUserCmd(data)
  self:Notify(ServiceEvent.NUserBuyRecordSlotUserCmd, data)
end

function ServiceNUserAutoProxy:RecvDeleteRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserDeleteRecordUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUpdateBranchInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateBranchInfoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvEnterCapraActivityCmd(data)
  self:Notify(ServiceEvent.NUserEnterCapraActivityCmd, data)
end

function ServiceNUserAutoProxy:RecvInviteWithMeUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteWithMeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryAltmanKillUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryAltmanKillUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBoothReqUserCmd(data)
  self:Notify(ServiceEvent.NUserBoothReqUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBoothInfoSyncUserCmd(data)
  self:Notify(ServiceEvent.NUserBoothInfoSyncUserCmd, data)
end

function ServiceNUserAutoProxy:RecvDressUpModelUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpModelUserCmd, data)
end

function ServiceNUserAutoProxy:RecvDressUpHeadUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpHeadUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryStageUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryStageUserCmd, data)
end

function ServiceNUserAutoProxy:RecvDressUpLineUpUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpLineUpUserCmd, data)
end

function ServiceNUserAutoProxy:RecvDressUpStageUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpStageUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGoToFunctionMapUserCmd(data)
  self:Notify(ServiceEvent.NUserGoToFunctionMapUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGrowthServantUserCmd(data)
  self:Notify(ServiceEvent.NUserGrowthServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvReceiveGrowthServantUserCmd(data)
  self:Notify(ServiceEvent.NUserReceiveGrowthServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGrowthOpenServantUserCmd(data)
  self:Notify(ServiceEvent.NUserGrowthOpenServantUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCheatTagUserCmd(data)
  self:Notify(ServiceEvent.NUserCheatTagUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCheatTagStatUserCmd(data)
  self:Notify(ServiceEvent.NUserCheatTagStatUserCmd, data)
end

function ServiceNUserAutoProxy:RecvClickPosList(data)
  self:Notify(ServiceEvent.NUserClickPosList, data)
end

function ServiceNUserAutoProxy:RecvServerInfoNtf(data)
  self:Notify(ServiceEvent.NUserServerInfoNtf, data)
end

function ServiceNUserAutoProxy:RecvReadyToMapUserCmd(data)
  self:Notify(ServiceEvent.NUserReadyToMapUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSignInUserCmd(data)
  self:Notify(ServiceEvent.NUserSignInUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSignInNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserSignInNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBeatPoriUserCmd(data)
  self:Notify(ServiceEvent.NUserBeatPoriUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUnlockFrameUserCmd(data)
  self:Notify(ServiceEvent.NUserUnlockFrameUserCmd, data)
end

function ServiceNUserAutoProxy:RecvAltmanRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserAltmanRewardUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantReqReservationUserCmd(data)
  self:Notify(ServiceEvent.NUserServantReqReservationUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantReservationUserCmd(data)
  self:Notify(ServiceEvent.NUserServantReservationUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantRecEquipUserCmd(data)
  self:Notify(ServiceEvent.NUserServantRecEquipUserCmd, data)
end

function ServiceNUserAutoProxy:RecvPrestigeNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserPrestigeNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvPrestigeGiveUserCmd(data)
  self:Notify(ServiceEvent.NUserPrestigeGiveUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUpdateGameHealthLevelUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateGameHealthLevelUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGameHealthEventStatUserCmd(data)
  self:Notify(ServiceEvent.NUserGameHealthEventStatUserCmd, data)
end

function ServiceNUserAutoProxy:RecvFishway2KillBossInformUserCmd(data)
  self:Notify(ServiceEvent.NUserFishway2KillBossInformUserCmd, data)
end

function ServiceNUserAutoProxy:RecvActPointUserCmd(data)
  self:Notify(ServiceEvent.NUserActPointUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHighRefineAttrUserCmd(data)
  self:Notify(ServiceEvent.NUserHighRefineAttrUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHeadwearNpcUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearNpcUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHeadwearRoundUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearRoundUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHeadwearTowerUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearTowerUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHeadwearEndUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearEndUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHeadwearRangeUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearRangeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantStatisticsUserCmd(data)
  self:Notify(ServiceEvent.NUserServantStatisticsUserCmd, data)
end

function ServiceNUserAutoProxy:RecvServantStatisticsMailUserCmd(data)
  self:Notify(ServiceEvent.NUserServantStatisticsMailUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHeadwearOpenUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearOpenUserCmd, data)
end

function ServiceNUserAutoProxy:RecvFastTransClassUserCmd(data)
  self:Notify(ServiceEvent.NUserFastTransClassUserCmd, data)
end

function ServiceNUserAutoProxy:RecvFastTransGemQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserFastTransGemQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvFastTransGemGetUserCmd(data)
  self:Notify(ServiceEvent.NUserFastTransGemGetUserCmd, data)
end

function ServiceNUserAutoProxy:RecvFourthSkillCostGetUserCmd(data)
  self:Notify(ServiceEvent.NUserFourthSkillCostGetUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBuildDataQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserBuildDataQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBuildContributeUserCmd(data)
  self:Notify(ServiceEvent.NUserBuildContributeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvBuildOperateUserCmd(data)
  self:Notify(ServiceEvent.NUserBuildOperateUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNightmareAttrQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserNightmareAttrQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNightmareAttrGetUserCmd(data)
  self:Notify(ServiceEvent.NUserNightmareAttrGetUserCmd, data)
end

function ServiceNUserAutoProxy:RecvMapAnimeUserCmd(data)
  self:Notify(ServiceEvent.NUserMapAnimeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvShootNpcUserCmd(data)
  self:Notify(ServiceEvent.NUserShootNpcUserCmd, data)
end

function ServiceNUserAutoProxy:RecvPaySignNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserPaySignNtfUserCmd, data)
end

function ServiceNUserAutoProxy:RecvPaySignBuyUserCmd(data)
  self:Notify(ServiceEvent.NUserPaySignBuyUserCmd, data)
end

function ServiceNUserAutoProxy:RecvPaySignRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserPaySignRewardUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExtractionQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExtractionOperateUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionOperateUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExtractionActiveUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionActiveUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExtractionRemoveUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionRemoveUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExtractionGridBuyUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionGridBuyUserCmd, data)
end

function ServiceNUserAutoProxy:RecvExtractionRefreshUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionRefreshUserCmd, data)
end

function ServiceNUserAutoProxy:RecvTeamExpRewardTypeCmd(data)
  self:Notify(ServiceEvent.NUserTeamExpRewardTypeCmd, data)
end

function ServiceNUserAutoProxy:RecvSetMyselfOptionCmd(data)
  self:Notify(ServiceEvent.NUserSetMyselfOptionCmd, data)
end

function ServiceNUserAutoProxy:RecvUseSkillEffectItemUserCmd(data)
  self:Notify(ServiceEvent.NUserUseSkillEffectItemUserCmd, data)
end

function ServiceNUserAutoProxy:RecvRideMultiMountUserCmd(data)
  self:Notify(ServiceEvent.NUserRideMultiMountUserCmd, data)
end

function ServiceNUserAutoProxy:RecvKickOffPassengerUserCmd(data)
  self:Notify(ServiceEvent.NUserKickOffPassengerUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSetMultiMountOptUserCmd(data)
  self:Notify(ServiceEvent.NUserSetMultiMountOptUserCmd, data)
end

function ServiceNUserAutoProxy:RecvMultiMountChangePosUserCmd(data)
  self:Notify(ServiceEvent.NUserMultiMountChangePosUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGrouponQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserGrouponQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGrouponBuyUserCmd(data)
  self:Notify(ServiceEvent.NUserGrouponBuyUserCmd, data)
end

function ServiceNUserAutoProxy:RecvGrouponRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserGrouponRewardUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNtfPlayActUserCmd(data)
  self:Notify(ServiceEvent.NUserNtfPlayActUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNoviceTargetUpdateUserCmd(data)
  self:Notify(ServiceEvent.NUserNoviceTargetUpdateUserCmd, data)
end

function ServiceNUserAutoProxy:RecvNoviceTargetRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserNoviceTargetRewardUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSetBoKiStateUserCmd(data)
  self:Notify(ServiceEvent.NUserSetBoKiStateUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCloseDialogMaskUserCmd(data)
  self:Notify(ServiceEvent.NUserCloseDialogMaskUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCloseDialogCameraUserCmd(data)
  self:Notify(ServiceEvent.NUserCloseDialogCameraUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHideUIUserCmd(data)
  self:Notify(ServiceEvent.NUserHideUIUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryMapMonsterRefreshInfo(data)
  self:Notify(ServiceEvent.NUserQueryMapMonsterRefreshInfo, data)
end

function ServiceNUserAutoProxy:RecvSetCameraUserCmd(data)
  self:Notify(ServiceEvent.NUserSetCameraUserCmd, data)
end

function ServiceNUserAutoProxy:RecvQueryProfessionDataDetailUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryProfessionDataDetailUserCmd, data)
end

function ServiceNUserAutoProxy:RecvClearProfessionDataDetailUserCmd(data)
  self:Notify(ServiceEvent.NUserClearProfessionDataDetailUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChainExchangeUserCmd(data)
  self:Notify(ServiceEvent.NUserChainExchangeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChainOptUserCmd(data)
  self:Notify(ServiceEvent.NUserChainOptUserCmd, data)
end

function ServiceNUserAutoProxy:RecvActivityDonateQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserActivityDonateQueryUserCmd, data)
end

function ServiceNUserAutoProxy:RecvActivityDonateRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserActivityDonateRewardUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChangeHairUserCmd(data)
  self:Notify(ServiceEvent.NUserChangeHairUserCmd, data)
end

function ServiceNUserAutoProxy:RecvChangeEyeUserCmd(data)
  self:Notify(ServiceEvent.NUserChangeEyeUserCmd, data)
end

function ServiceNUserAutoProxy:RecvHappyValueUserCmd(data)
  self:Notify(ServiceEvent.NUserHappyValueUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSendTargetPosUserCmd(data)
  self:Notify(ServiceEvent.NUserSendTargetPosUserCmd, data)
end

function ServiceNUserAutoProxy:RecvCookGameFinishUserCmd(data)
  self:Notify(ServiceEvent.NUserCookGameFinishUserCmd, data)
end

function ServiceNUserAutoProxy:RecvRaceGameStartUserCmd(data)
  self:Notify(ServiceEvent.NUserRaceGameStartUserCmd, data)
end

function ServiceNUserAutoProxy:RecvRaceGameFinishUserCmd(data)
  self:Notify(ServiceEvent.NUserRaceGameFinishUserCmd, data)
end

function ServiceNUserAutoProxy:RecvSendMarksInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserSendMarksInfoUserCmd, data)
end

function ServiceNUserAutoProxy:RecvUserSyncBuffFromUserCmd(data)
  self:Notify(ServiceEvent.NUserUserSyncBuffFromUserCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.NUserGoCity = "ServiceEvent_NUserGoCity"
ServiceEvent.NUserSysMsg = "ServiceEvent_NUserSysMsg"
ServiceEvent.NUserNpcDataSync = "ServiceEvent_NUserNpcDataSync"
ServiceEvent.NUserUserNineSyncCmd = "ServiceEvent_NUserUserNineSyncCmd"
ServiceEvent.NUserUserActionNtf = "ServiceEvent_NUserUserActionNtf"
ServiceEvent.NUserUserBuffNineSyncCmd = "ServiceEvent_NUserUserBuffNineSyncCmd"
ServiceEvent.NUserExitPosUserCmd = "ServiceEvent_NUserExitPosUserCmd"
ServiceEvent.NUserRelive = "ServiceEvent_NUserRelive"
ServiceEvent.NUserVarUpdate = "ServiceEvent_NUserVarUpdate"
ServiceEvent.NUserTalkInfo = "ServiceEvent_NUserTalkInfo"
ServiceEvent.NUserServerTime = "ServiceEvent_NUserServerTime"
ServiceEvent.NUserEffectUserCmd = "ServiceEvent_NUserEffectUserCmd"
ServiceEvent.NUserMenuList = "ServiceEvent_NUserMenuList"
ServiceEvent.NUserNewMenu = "ServiceEvent_NUserNewMenu"
ServiceEvent.NUserEvaluationReward = "ServiceEvent_NUserEvaluationReward"
ServiceEvent.NUserTeamInfoNine = "ServiceEvent_NUserTeamInfoNine"
ServiceEvent.NUserUsePortrait = "ServiceEvent_NUserUsePortrait"
ServiceEvent.NUserUseFrame = "ServiceEvent_NUserUseFrame"
ServiceEvent.NUserUpdatePortraitFrame = "ServiceEvent_NUserUpdatePortraitFrame"
ServiceEvent.NUserQueryPortraitListUserCmd = "ServiceEvent_NUserQueryPortraitListUserCmd"
ServiceEvent.NUserUseDressing = "ServiceEvent_NUserUseDressing"
ServiceEvent.NUserNewDressing = "ServiceEvent_NUserNewDressing"
ServiceEvent.NUserDressingListUserCmd = "ServiceEvent_NUserDressingListUserCmd"
ServiceEvent.NUserAddAttrPoint = "ServiceEvent_NUserAddAttrPoint"
ServiceEvent.NUserQueryShopGotItem = "ServiceEvent_NUserQueryShopGotItem"
ServiceEvent.NUserUpdateShopGotItem = "ServiceEvent_NUserUpdateShopGotItem"
ServiceEvent.NUserOpenUI = "ServiceEvent_NUserOpenUI"
ServiceEvent.NUserDbgSysMsg = "ServiceEvent_NUserDbgSysMsg"
ServiceEvent.NUserFollowTransferCmd = "ServiceEvent_NUserFollowTransferCmd"
ServiceEvent.NUserCallNpcFuncCmd = "ServiceEvent_NUserCallNpcFuncCmd"
ServiceEvent.NUserModelShow = "ServiceEvent_NUserModelShow"
ServiceEvent.NUserSoundEffectCmd = "ServiceEvent_NUserSoundEffectCmd"
ServiceEvent.NUserPresetMsgCmd = "ServiceEvent_NUserPresetMsgCmd"
ServiceEvent.NUserChangeBgmCmd = "ServiceEvent_NUserChangeBgmCmd"
ServiceEvent.NUserQueryFighterInfo = "ServiceEvent_NUserQueryFighterInfo"
ServiceEvent.NUserGameTimeCmd = "ServiceEvent_NUserGameTimeCmd"
ServiceEvent.NUserCDTimeUserCmd = "ServiceEvent_NUserCDTimeUserCmd"
ServiceEvent.NUserStateChange = "ServiceEvent_NUserStateChange"
ServiceEvent.NUserPhoto = "ServiceEvent_NUserPhoto"
ServiceEvent.NUserShakeScreen = "ServiceEvent_NUserShakeScreen"
ServiceEvent.NUserQueryShortcut = "ServiceEvent_NUserQueryShortcut"
ServiceEvent.NUserPutShortcut = "ServiceEvent_NUserPutShortcut"
ServiceEvent.NUserTempPutShortCut = "ServiceEvent_NUserTempPutShortCut"
ServiceEvent.NUserNpcChangeAngle = "ServiceEvent_NUserNpcChangeAngle"
ServiceEvent.NUserCameraFocus = "ServiceEvent_NUserCameraFocus"
ServiceEvent.NUserGoToListUserCmd = "ServiceEvent_NUserGoToListUserCmd"
ServiceEvent.NUserGoToGearUserCmd = "ServiceEvent_NUserGoToGearUserCmd"
ServiceEvent.NUserNewTransMapCmd = "ServiceEvent_NUserNewTransMapCmd"
ServiceEvent.NUserDeathTransferListCmd = "ServiceEvent_NUserDeathTransferListCmd"
ServiceEvent.NUserNewDeathTransferCmd = "ServiceEvent_NUserNewDeathTransferCmd"
ServiceEvent.NUserUseDeathTransferCmd = "ServiceEvent_NUserUseDeathTransferCmd"
ServiceEvent.NUserFollowerUser = "ServiceEvent_NUserFollowerUser"
ServiceEvent.NUserBeFollowUserCmd = "ServiceEvent_NUserBeFollowUserCmd"
ServiceEvent.NUserLaboratoryUserCmd = "ServiceEvent_NUserLaboratoryUserCmd"
ServiceEvent.NUserGotoLaboratoryUserCmd = "ServiceEvent_NUserGotoLaboratoryUserCmd"
ServiceEvent.NUserExchangeProfession = "ServiceEvent_NUserExchangeProfession"
ServiceEvent.NUserSceneryUserCmd = "ServiceEvent_NUserSceneryUserCmd"
ServiceEvent.NUserGoMapQuestUserCmd = "ServiceEvent_NUserGoMapQuestUserCmd"
ServiceEvent.NUserGoMapFollowUserCmd = "ServiceEvent_NUserGoMapFollowUserCmd"
ServiceEvent.NUserUserAutoHitCmd = "ServiceEvent_NUserUserAutoHitCmd"
ServiceEvent.NUserUploadSceneryPhotoUserCmd = "ServiceEvent_NUserUploadSceneryPhotoUserCmd"
ServiceEvent.NUserDownloadSceneryPhotoUserCmd = "ServiceEvent_NUserDownloadSceneryPhotoUserCmd"
ServiceEvent.NUserQueryMapArea = "ServiceEvent_NUserQueryMapArea"
ServiceEvent.NUserNewMapAreaNtf = "ServiceEvent_NUserNewMapAreaNtf"
ServiceEvent.NUserBuffForeverCmd = "ServiceEvent_NUserBuffForeverCmd"
ServiceEvent.NUserInviteJoinHandsUserCmd = "ServiceEvent_NUserInviteJoinHandsUserCmd"
ServiceEvent.NUserBreakUpHandsUserCmd = "ServiceEvent_NUserBreakUpHandsUserCmd"
ServiceEvent.NUserHandStatusUserCmd = "ServiceEvent_NUserHandStatusUserCmd"
ServiceEvent.NUserQueryShow = "ServiceEvent_NUserQueryShow"
ServiceEvent.NUserQueryMusicList = "ServiceEvent_NUserQueryMusicList"
ServiceEvent.NUserDemandMusic = "ServiceEvent_NUserDemandMusic"
ServiceEvent.NUserCloseMusicFrame = "ServiceEvent_NUserCloseMusicFrame"
ServiceEvent.NUserUploadOkSceneryUserCmd = "ServiceEvent_NUserUploadOkSceneryUserCmd"
ServiceEvent.NUserJoinHandsUserCmd = "ServiceEvent_NUserJoinHandsUserCmd"
ServiceEvent.NUserQueryTraceList = "ServiceEvent_NUserQueryTraceList"
ServiceEvent.NUserUpdateTraceList = "ServiceEvent_NUserUpdateTraceList"
ServiceEvent.NUserSetDirection = "ServiceEvent_NUserSetDirection"
ServiceEvent.NUserBattleTimelenUserCmd = "ServiceEvent_NUserBattleTimelenUserCmd"
ServiceEvent.NUserSetOptionUserCmd = "ServiceEvent_NUserSetOptionUserCmd"
ServiceEvent.NUserQueryUserInfoUserCmd = "ServiceEvent_NUserQueryUserInfoUserCmd"
ServiceEvent.NUserCountDownTickUserCmd = "ServiceEvent_NUserCountDownTickUserCmd"
ServiceEvent.NUserItemMusicNtfUserCmd = "ServiceEvent_NUserItemMusicNtfUserCmd"
ServiceEvent.NUserShakeTreeUserCmd = "ServiceEvent_NUserShakeTreeUserCmd"
ServiceEvent.NUserTreeListUserCmd = "ServiceEvent_NUserTreeListUserCmd"
ServiceEvent.NUserActivityNtfUserCmd = "ServiceEvent_NUserActivityNtfUserCmd"
ServiceEvent.NUserQueryZoneStatusUserCmd = "ServiceEvent_NUserQueryZoneStatusUserCmd"
ServiceEvent.NUserJumpZoneUserCmd = "ServiceEvent_NUserJumpZoneUserCmd"
ServiceEvent.NUserItemImageUserNtfUserCmd = "ServiceEvent_NUserItemImageUserNtfUserCmd"
ServiceEvent.NUserInviteFollowUserCmd = "ServiceEvent_NUserInviteFollowUserCmd"
ServiceEvent.NUserChangeNameUserCmd = "ServiceEvent_NUserChangeNameUserCmd"
ServiceEvent.NUserChargePlayUserCmd = "ServiceEvent_NUserChargePlayUserCmd"
ServiceEvent.NUserRequireNpcFuncUserCmd = "ServiceEvent_NUserRequireNpcFuncUserCmd"
ServiceEvent.NUserCheckSeatUserCmd = "ServiceEvent_NUserCheckSeatUserCmd"
ServiceEvent.NUserNtfSeatUserCmd = "ServiceEvent_NUserNtfSeatUserCmd"
ServiceEvent.NUserYoyoSeatUserCmd = "ServiceEvent_NUserYoyoSeatUserCmd"
ServiceEvent.NUserShowSeatUserCmd = "ServiceEvent_NUserShowSeatUserCmd"
ServiceEvent.NUserSetNormalSkillOptionUserCmd = "ServiceEvent_NUserSetNormalSkillOptionUserCmd"
ServiceEvent.NUserNewSetOptionUserCmd = "ServiceEvent_NUserNewSetOptionUserCmd"
ServiceEvent.NUserUnsolvedSceneryNtfUserCmd = "ServiceEvent_NUserUnsolvedSceneryNtfUserCmd"
ServiceEvent.NUserNtfVisibleNpcUserCmd = "ServiceEvent_NUserNtfVisibleNpcUserCmd"
ServiceEvent.NUserTransformPreDataCmd = "ServiceEvent_NUserTransformPreDataCmd"
ServiceEvent.NUserUserRenameCmd = "ServiceEvent_NUserUserRenameCmd"
ServiceEvent.NUserBuyZenyCmd = "ServiceEvent_NUserBuyZenyCmd"
ServiceEvent.NUserCallTeamerUserCmd = "ServiceEvent_NUserCallTeamerUserCmd"
ServiceEvent.NUserCallTeamerReplyUserCmd = "ServiceEvent_NUserCallTeamerReplyUserCmd"
ServiceEvent.NUserSpecialEffectCmd = "ServiceEvent_NUserSpecialEffectCmd"
ServiceEvent.NUserMarriageProposalCmd = "ServiceEvent_NUserMarriageProposalCmd"
ServiceEvent.NUserMarriageProposalReplyCmd = "ServiceEvent_NUserMarriageProposalReplyCmd"
ServiceEvent.NUserUploadWeddingPhotoUserCmd = "ServiceEvent_NUserUploadWeddingPhotoUserCmd"
ServiceEvent.NUserMarriageProposalSuccessCmd = "ServiceEvent_NUserMarriageProposalSuccessCmd"
ServiceEvent.NUserInviteeWeddingStartNtfUserCmd = "ServiceEvent_NUserInviteeWeddingStartNtfUserCmd"
ServiceEvent.NUserKFCShareUserCmd = "ServiceEvent_NUserKFCShareUserCmd"
ServiceEvent.NUserKFCEnrollUserCmd = "ServiceEvent_NUserKFCEnrollUserCmd"
ServiceEvent.NUserKFCEnrollCodeUserCmd = "ServiceEvent_NUserKFCEnrollCodeUserCmd"
ServiceEvent.NUserKFCEnrollReplyUserCmd = "ServiceEvent_NUserKFCEnrollReplyUserCmd"
ServiceEvent.NUserKFCEnrollQueryUserCmd = "ServiceEvent_NUserKFCEnrollQueryUserCmd"
ServiceEvent.NUserKFCHasEnrolledUserCmd = "ServiceEvent_NUserKFCHasEnrolledUserCmd"
ServiceEvent.NUserCheckRelationUserCmd = "ServiceEvent_NUserCheckRelationUserCmd"
ServiceEvent.NUserTwinsActionUserCmd = "ServiceEvent_NUserTwinsActionUserCmd"
ServiceEvent.NUserShowServantUserCmd = "ServiceEvent_NUserShowServantUserCmd"
ServiceEvent.NUserReplaceServantUserCmd = "ServiceEvent_NUserReplaceServantUserCmd"
ServiceEvent.NUserHireServantUserCmd = "ServiceEvent_NUserHireServantUserCmd"
ServiceEvent.NUserServantService = "ServiceEvent_NUserServantService"
ServiceEvent.NUserRecommendServantUserCmd = "ServiceEvent_NUserRecommendServantUserCmd"
ServiceEvent.NUserReceiveServantUserCmd = "ServiceEvent_NUserReceiveServantUserCmd"
ServiceEvent.NUserServantRewardStatusUserCmd = "ServiceEvent_NUserServantRewardStatusUserCmd"
ServiceEvent.NUserProfessionQueryUserCmd = "ServiceEvent_NUserProfessionQueryUserCmd"
ServiceEvent.NUserProfessionBuyUserCmd = "ServiceEvent_NUserProfessionBuyUserCmd"
ServiceEvent.NUserProfessionChangeUserCmd = "ServiceEvent_NUserProfessionChangeUserCmd"
ServiceEvent.NUserUpdateRecordInfoUserCmd = "ServiceEvent_NUserUpdateRecordInfoUserCmd"
ServiceEvent.NUserSaveRecordUserCmd = "ServiceEvent_NUserSaveRecordUserCmd"
ServiceEvent.NUserLoadRecordUserCmd = "ServiceEvent_NUserLoadRecordUserCmd"
ServiceEvent.NUserChangeRecordNameUserCmd = "ServiceEvent_NUserChangeRecordNameUserCmd"
ServiceEvent.NUserBuyRecordSlotUserCmd = "ServiceEvent_NUserBuyRecordSlotUserCmd"
ServiceEvent.NUserDeleteRecordUserCmd = "ServiceEvent_NUserDeleteRecordUserCmd"
ServiceEvent.NUserUpdateBranchInfoUserCmd = "ServiceEvent_NUserUpdateBranchInfoUserCmd"
ServiceEvent.NUserEnterCapraActivityCmd = "ServiceEvent_NUserEnterCapraActivityCmd"
ServiceEvent.NUserInviteWithMeUserCmd = "ServiceEvent_NUserInviteWithMeUserCmd"
ServiceEvent.NUserQueryAltmanKillUserCmd = "ServiceEvent_NUserQueryAltmanKillUserCmd"
ServiceEvent.NUserBoothReqUserCmd = "ServiceEvent_NUserBoothReqUserCmd"
ServiceEvent.NUserBoothInfoSyncUserCmd = "ServiceEvent_NUserBoothInfoSyncUserCmd"
ServiceEvent.NUserDressUpModelUserCmd = "ServiceEvent_NUserDressUpModelUserCmd"
ServiceEvent.NUserDressUpHeadUserCmd = "ServiceEvent_NUserDressUpHeadUserCmd"
ServiceEvent.NUserQueryStageUserCmd = "ServiceEvent_NUserQueryStageUserCmd"
ServiceEvent.NUserDressUpLineUpUserCmd = "ServiceEvent_NUserDressUpLineUpUserCmd"
ServiceEvent.NUserDressUpStageUserCmd = "ServiceEvent_NUserDressUpStageUserCmd"
ServiceEvent.NUserGoToFunctionMapUserCmd = "ServiceEvent_NUserGoToFunctionMapUserCmd"
ServiceEvent.NUserGrowthServantUserCmd = "ServiceEvent_NUserGrowthServantUserCmd"
ServiceEvent.NUserReceiveGrowthServantUserCmd = "ServiceEvent_NUserReceiveGrowthServantUserCmd"
ServiceEvent.NUserGrowthOpenServantUserCmd = "ServiceEvent_NUserGrowthOpenServantUserCmd"
ServiceEvent.NUserCheatTagUserCmd = "ServiceEvent_NUserCheatTagUserCmd"
ServiceEvent.NUserCheatTagStatUserCmd = "ServiceEvent_NUserCheatTagStatUserCmd"
ServiceEvent.NUserClickPosList = "ServiceEvent_NUserClickPosList"
ServiceEvent.NUserServerInfoNtf = "ServiceEvent_NUserServerInfoNtf"
ServiceEvent.NUserReadyToMapUserCmd = "ServiceEvent_NUserReadyToMapUserCmd"
ServiceEvent.NUserSignInUserCmd = "ServiceEvent_NUserSignInUserCmd"
ServiceEvent.NUserSignInNtfUserCmd = "ServiceEvent_NUserSignInNtfUserCmd"
ServiceEvent.NUserBeatPoriUserCmd = "ServiceEvent_NUserBeatPoriUserCmd"
ServiceEvent.NUserUnlockFrameUserCmd = "ServiceEvent_NUserUnlockFrameUserCmd"
ServiceEvent.NUserAltmanRewardUserCmd = "ServiceEvent_NUserAltmanRewardUserCmd"
ServiceEvent.NUserServantReqReservationUserCmd = "ServiceEvent_NUserServantReqReservationUserCmd"
ServiceEvent.NUserServantReservationUserCmd = "ServiceEvent_NUserServantReservationUserCmd"
ServiceEvent.NUserServantRecEquipUserCmd = "ServiceEvent_NUserServantRecEquipUserCmd"
ServiceEvent.NUserPrestigeNtfUserCmd = "ServiceEvent_NUserPrestigeNtfUserCmd"
ServiceEvent.NUserPrestigeGiveUserCmd = "ServiceEvent_NUserPrestigeGiveUserCmd"
ServiceEvent.NUserUpdateGameHealthLevelUserCmd = "ServiceEvent_NUserUpdateGameHealthLevelUserCmd"
ServiceEvent.NUserGameHealthEventStatUserCmd = "ServiceEvent_NUserGameHealthEventStatUserCmd"
ServiceEvent.NUserFishway2KillBossInformUserCmd = "ServiceEvent_NUserFishway2KillBossInformUserCmd"
ServiceEvent.NUserActPointUserCmd = "ServiceEvent_NUserActPointUserCmd"
ServiceEvent.NUserHighRefineAttrUserCmd = "ServiceEvent_NUserHighRefineAttrUserCmd"
ServiceEvent.NUserHeadwearNpcUserCmd = "ServiceEvent_NUserHeadwearNpcUserCmd"
ServiceEvent.NUserHeadwearRoundUserCmd = "ServiceEvent_NUserHeadwearRoundUserCmd"
ServiceEvent.NUserHeadwearTowerUserCmd = "ServiceEvent_NUserHeadwearTowerUserCmd"
ServiceEvent.NUserHeadwearEndUserCmd = "ServiceEvent_NUserHeadwearEndUserCmd"
ServiceEvent.NUserHeadwearRangeUserCmd = "ServiceEvent_NUserHeadwearRangeUserCmd"
ServiceEvent.NUserServantStatisticsUserCmd = "ServiceEvent_NUserServantStatisticsUserCmd"
ServiceEvent.NUserServantStatisticsMailUserCmd = "ServiceEvent_NUserServantStatisticsMailUserCmd"
ServiceEvent.NUserHeadwearOpenUserCmd = "ServiceEvent_NUserHeadwearOpenUserCmd"
ServiceEvent.NUserFastTransClassUserCmd = "ServiceEvent_NUserFastTransClassUserCmd"
ServiceEvent.NUserFastTransGemQueryUserCmd = "ServiceEvent_NUserFastTransGemQueryUserCmd"
ServiceEvent.NUserFastTransGemGetUserCmd = "ServiceEvent_NUserFastTransGemGetUserCmd"
ServiceEvent.NUserFourthSkillCostGetUserCmd = "ServiceEvent_NUserFourthSkillCostGetUserCmd"
ServiceEvent.NUserBuildDataQueryUserCmd = "ServiceEvent_NUserBuildDataQueryUserCmd"
ServiceEvent.NUserBuildContributeUserCmd = "ServiceEvent_NUserBuildContributeUserCmd"
ServiceEvent.NUserBuildOperateUserCmd = "ServiceEvent_NUserBuildOperateUserCmd"
ServiceEvent.NUserNightmareAttrQueryUserCmd = "ServiceEvent_NUserNightmareAttrQueryUserCmd"
ServiceEvent.NUserNightmareAttrGetUserCmd = "ServiceEvent_NUserNightmareAttrGetUserCmd"
ServiceEvent.NUserMapAnimeUserCmd = "ServiceEvent_NUserMapAnimeUserCmd"
ServiceEvent.NUserShootNpcUserCmd = "ServiceEvent_NUserShootNpcUserCmd"
ServiceEvent.NUserPaySignNtfUserCmd = "ServiceEvent_NUserPaySignNtfUserCmd"
ServiceEvent.NUserPaySignBuyUserCmd = "ServiceEvent_NUserPaySignBuyUserCmd"
ServiceEvent.NUserPaySignRewardUserCmd = "ServiceEvent_NUserPaySignRewardUserCmd"
ServiceEvent.NUserExtractionQueryUserCmd = "ServiceEvent_NUserExtractionQueryUserCmd"
ServiceEvent.NUserExtractionOperateUserCmd = "ServiceEvent_NUserExtractionOperateUserCmd"
ServiceEvent.NUserExtractionActiveUserCmd = "ServiceEvent_NUserExtractionActiveUserCmd"
ServiceEvent.NUserExtractionRemoveUserCmd = "ServiceEvent_NUserExtractionRemoveUserCmd"
ServiceEvent.NUserExtractionGridBuyUserCmd = "ServiceEvent_NUserExtractionGridBuyUserCmd"
ServiceEvent.NUserExtractionRefreshUserCmd = "ServiceEvent_NUserExtractionRefreshUserCmd"
ServiceEvent.NUserTeamExpRewardTypeCmd = "ServiceEvent_NUserTeamExpRewardTypeCmd"
ServiceEvent.NUserSetMyselfOptionCmd = "ServiceEvent_NUserSetMyselfOptionCmd"
ServiceEvent.NUserUseSkillEffectItemUserCmd = "ServiceEvent_NUserUseSkillEffectItemUserCmd"
ServiceEvent.NUserRideMultiMountUserCmd = "ServiceEvent_NUserRideMultiMountUserCmd"
ServiceEvent.NUserKickOffPassengerUserCmd = "ServiceEvent_NUserKickOffPassengerUserCmd"
ServiceEvent.NUserSetMultiMountOptUserCmd = "ServiceEvent_NUserSetMultiMountOptUserCmd"
ServiceEvent.NUserMultiMountChangePosUserCmd = "ServiceEvent_NUserMultiMountChangePosUserCmd"
ServiceEvent.NUserGrouponQueryUserCmd = "ServiceEvent_NUserGrouponQueryUserCmd"
ServiceEvent.NUserGrouponBuyUserCmd = "ServiceEvent_NUserGrouponBuyUserCmd"
ServiceEvent.NUserGrouponRewardUserCmd = "ServiceEvent_NUserGrouponRewardUserCmd"
ServiceEvent.NUserNtfPlayActUserCmd = "ServiceEvent_NUserNtfPlayActUserCmd"
ServiceEvent.NUserNoviceTargetUpdateUserCmd = "ServiceEvent_NUserNoviceTargetUpdateUserCmd"
ServiceEvent.NUserNoviceTargetRewardUserCmd = "ServiceEvent_NUserNoviceTargetRewardUserCmd"
ServiceEvent.NUserSetBoKiStateUserCmd = "ServiceEvent_NUserSetBoKiStateUserCmd"
ServiceEvent.NUserCloseDialogMaskUserCmd = "ServiceEvent_NUserCloseDialogMaskUserCmd"
ServiceEvent.NUserCloseDialogCameraUserCmd = "ServiceEvent_NUserCloseDialogCameraUserCmd"
ServiceEvent.NUserHideUIUserCmd = "ServiceEvent_NUserHideUIUserCmd"
ServiceEvent.NUserQueryMapMonsterRefreshInfo = "ServiceEvent_NUserQueryMapMonsterRefreshInfo"
ServiceEvent.NUserSetCameraUserCmd = "ServiceEvent_NUserSetCameraUserCmd"
ServiceEvent.NUserQueryProfessionDataDetailUserCmd = "ServiceEvent_NUserQueryProfessionDataDetailUserCmd"
ServiceEvent.NUserClearProfessionDataDetailUserCmd = "ServiceEvent_NUserClearProfessionDataDetailUserCmd"
ServiceEvent.NUserChainExchangeUserCmd = "ServiceEvent_NUserChainExchangeUserCmd"
ServiceEvent.NUserChainOptUserCmd = "ServiceEvent_NUserChainOptUserCmd"
ServiceEvent.NUserActivityDonateQueryUserCmd = "ServiceEvent_NUserActivityDonateQueryUserCmd"
ServiceEvent.NUserActivityDonateRewardUserCmd = "ServiceEvent_NUserActivityDonateRewardUserCmd"
ServiceEvent.NUserChangeHairUserCmd = "ServiceEvent_NUserChangeHairUserCmd"
ServiceEvent.NUserChangeEyeUserCmd = "ServiceEvent_NUserChangeEyeUserCmd"
ServiceEvent.NUserHappyValueUserCmd = "ServiceEvent_NUserHappyValueUserCmd"
ServiceEvent.NUserSendTargetPosUserCmd = "ServiceEvent_NUserSendTargetPosUserCmd"
ServiceEvent.NUserCookGameFinishUserCmd = "ServiceEvent_NUserCookGameFinishUserCmd"
ServiceEvent.NUserRaceGameStartUserCmd = "ServiceEvent_NUserRaceGameStartUserCmd"
ServiceEvent.NUserRaceGameFinishUserCmd = "ServiceEvent_NUserRaceGameFinishUserCmd"
ServiceEvent.NUserSendMarksInfoUserCmd = "ServiceEvent_NUserSendMarksInfoUserCmd"
ServiceEvent.NUserUserSyncBuffFromUserCmd = "ServiceEvent_NUserUserSyncBuffFromUserCmd"
