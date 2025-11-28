ProtoFileList = {
  "ProtoCommon",
  "descriptor",
  "ClientPrivateChatIO",
  "Var",
  "xCmd",
  "SceneFood",
  "SceneAugury",
  "InfiniteTower",
  "FamilyCmd",
  "Tutor",
  "SessionWeather",
  "PuzzleCmd",
  "PveCard",
  "QueueEnterCmd",
  "SceneTip",
  "NoviceNotebook",
  "BattlePass",
  "ActHitPolly",
  "ActMiniRoCmd",
  "AstrolabeCmd",
  "ErrorUserCmd",
  "UserShow",
  "AchieveCmd",
  "Authorize",
  "WeddingCCmd",
  "SceneInterlocution",
  "SceneChatRoom",
  "SceneSeal",
  "SceneManor",
  "CarrierCmd",
  "SessionSociality",
  "DisneyActivity",
  "TechTreeCmd",
  "TeamGroupRaid",
  "SessionShop",
  "BossCmd",
  "OverseasTaiwanCmd",
  "MiniGameCmd",
  "SceneUser",
  "SceneSkill",
  "SceneItem",
  "RecallCCmd",
  "Dojo",
  "AuctionCCmd",
  "SceneBeing",
  "SceneQuest",
  "RoguelikeCmd",
  "ScenePet",
  "RecordTrade",
  "SceneManual",
  "HomeCmd",
  "SceneUser2",
  "NoviceBattlePass",
  "UserAfkCmd",
  "SceneMap",
  "LoginUserCmd",
  "MessCCmd",
  "GuildCmd",
  "PhotoCmd",
  "SceneUser3",
  "ChatCmd",
  "InteractCmd",
  "SessionTeam",
  "ActivityCmd",
  "FuBenCmd",
  "RaidCmd",
  "ActivityEvent",
  "UserEvent",
  "SessionMail",
  "MatchCCmd",
  "TeamRaidCmd"
}
ProtoReqInfoList = {
  QueryUserResumeAchCmd = {
    id = 170001,
    req = "Cmd.QueryUserResumeAchCmd",
    ack = "Cmd.QueryUserResumeAchCmd",
    from = "AchieveCmd"
  },
  QueryAchieveDataAchCmd = {
    id = 170002,
    req = "Cmd.QueryAchieveDataAchCmd",
    ack = "Cmd.QueryAchieveDataAchCmd",
    from = "AchieveCmd"
  },
  NewAchieveNtfAchCmd = {
    id = 170003,
    req = "Cmd.NewAchieveNtfAchCmd",
    ack = "Cmd.NewAchieveNtfAchCmd",
    from = "AchieveCmd"
  },
  RewardGetAchCmd = {
    id = 170004,
    req = "Cmd.RewardGetAchCmd",
    ack = "Cmd.RewardGetAchCmd",
    from = "AchieveCmd"
  },
  RewardGetQuickAchCmd = {
    id = 170005,
    req = "Cmd.RewardGetQuickAchCmd",
    ack = "Cmd.RewardGetQuickAchCmd",
    from = "AchieveCmd"
  },
  NewNpcAchieveNtfAchCmd = {
    id = 170006,
    req = "Cmd.NewNpcAchieveNtfAchCmd",
    ack = "Cmd.NewNpcAchieveNtfAchCmd",
    from = "AchieveCmd"
  },
  QueryNpcAchieveAchCmd = {
    id = 170007,
    req = "Cmd.QueryNpcAchieveAchCmd",
    ack = "Cmd.QueryNpcAchieveAchCmd",
    from = "AchieveCmd"
  },
  UpdateNpcAchieveAchCmd = {
    id = 170008,
    req = "Cmd.UpdateNpcAchieveAchCmd",
    ack = "Cmd.UpdateNpcAchieveAchCmd",
    from = "AchieveCmd"
  },
  GetNpcAchieveRewardAchCmd = {
    id = 170009,
    req = "Cmd.GetNpcAchieveRewardAchCmd",
    ack = "Cmd.GetNpcAchieveRewardAchCmd",
    from = "AchieveCmd"
  },
  ActityQueryHitedList = {
    id = 2260001,
    req = "Cmd.ActityQueryHitedList",
    ack = "Cmd.ActityQueryHitedList",
    from = "ActHitPolly"
  },
  ActivityHitPolly = {
    id = 2260002,
    req = "Cmd.ActivityHitPolly",
    ack = "Cmd.ActivityHitPolly",
    from = "ActHitPolly"
  },
  ActityHitPollySync = {
    id = 2260003,
    req = "Cmd.ActityHitPollySync",
    ack = "Cmd.ActityHitPollySync",
    from = "ActHitPolly"
  },
  ActityHitPollySubmitQuest = {
    id = 2260004,
    req = "Cmd.ActityHitPollySubmitQuest",
    ack = "Cmd.ActityHitPollySubmitQuest",
    from = "ActHitPolly"
  },
  ActityHitPollyNtfQuest = {
    id = 2260005,
    req = "Cmd.ActityHitPollyNtfQuest",
    ack = "Cmd.ActityHitPollyNtfQuest",
    from = "ActHitPolly"
  },
  ActMiniRoOpenPage = {
    id = 2290001,
    req = "Cmd.ActMiniRoOpenPage",
    ack = "Cmd.ActMiniRoOpenPage",
    from = "ActMiniRoCmd"
  },
  ActMiniRoCastDice = {
    id = 2290002,
    req = "Cmd.ActMiniRoCastDice",
    ack = "Cmd.ActMiniRoCastDice",
    from = "ActMiniRoCmd"
  },
  ActMiniRoDiceSync = {
    id = 2290004,
    req = "Cmd.ActMiniRoDiceSync",
    ack = "Cmd.ActMiniRoDiceSync",
    from = "ActMiniRoCmd"
  },
  ActMiniRoGetOneKey = {
    id = 2290003,
    req = "Cmd.ActMiniRoGetOneKey",
    ack = "Cmd.ActMiniRoGetOneKey",
    from = "ActMiniRoCmd"
  },
  ActMiniRoEventFAQS = {
    id = 2290005,
    req = "Cmd.ActMiniRoEventFAQS",
    ack = "Cmd.ActMiniRoEventFAQS",
    from = "ActMiniRoCmd"
  },
  ActMiniRoCheckCircleReward = {
    id = 2290006,
    req = "Cmd.ActMiniRoCheckCircleReward",
    ack = "Cmd.ActMiniRoCheckCircleReward",
    from = "ActMiniRoCmd"
  },
  StartActCmd = {
    id = 600001,
    req = "Cmd.StartActCmd",
    ack = "Cmd.StartActCmd",
    from = "ActivityCmd"
  },
  StopActCmd = {
    id = 600004,
    req = "Cmd.StopActCmd",
    ack = "Cmd.StopActCmd",
    from = "ActivityCmd"
  },
  BCatUFOPosActCmd = {
    id = 600002,
    req = "Cmd.BCatUFOPosActCmd",
    ack = "Cmd.BCatUFOPosActCmd",
    from = "ActivityCmd"
  },
  ActProgressNtfCmd = {
    id = 600003,
    req = "Cmd.ActProgressNtfCmd",
    ack = "Cmd.ActProgressNtfCmd",
    from = "ActivityCmd"
  },
  StartGlobalActCmd = {
    id = 600005,
    req = "Cmd.StartGlobalActCmd",
    ack = "Cmd.StartGlobalActCmd",
    from = "ActivityCmd"
  },
  ActProgressExceptNtfCmd = {
    id = 600006,
    req = "Cmd.ActProgressExceptNtfCmd",
    ack = "Cmd.ActProgressExceptNtfCmd",
    from = "ActivityCmd"
  },
  TimeLimitShopPageCmd = {
    id = 600007,
    req = "Cmd.TimeLimitShopPageCmd",
    ack = "Cmd.TimeLimitShopPageCmd",
    from = "ActivityCmd"
  },
  AnimationLoginActCmd = {
    id = 600008,
    req = "Cmd.AnimationLoginActCmd",
    ack = "Cmd.AnimationLoginActCmd",
    from = "ActivityCmd"
  },
  GlobalDonationActivityInfoCmd = {
    id = 600009,
    req = "Cmd.GlobalDonationActivityInfoCmd",
    ack = "Cmd.GlobalDonationActivityInfoCmd",
    from = "ActivityCmd"
  },
  GlobalDonationActivityDonateCmd = {
    id = 600010,
    req = "Cmd.GlobalDonationActivityDonateCmd",
    ack = "Cmd.GlobalDonationActivityDonateCmd",
    from = "ActivityCmd"
  },
  GlobalDonationActivityAwardCmd = {
    id = 600011,
    req = "Cmd.GlobalDonationActivityAwardCmd",
    ack = "Cmd.GlobalDonationActivityAwardCmd",
    from = "ActivityCmd"
  },
  UserInviteInfoCmd = {
    id = 600012,
    req = "Cmd.UserInviteInfoCmd",
    ack = "Cmd.UserInviteInfoCmd",
    from = "ActivityCmd"
  },
  UserInviteBindUserCmd = {
    id = 600013,
    req = "Cmd.UserInviteBindUserCmd",
    ack = "Cmd.UserInviteBindUserCmd",
    from = "ActivityCmd"
  },
  UserInviteInviteAwardCmd = {
    id = 600014,
    req = "Cmd.UserInviteInviteAwardCmd",
    ack = "Cmd.UserInviteInviteAwardCmd",
    from = "ActivityCmd"
  },
  UserInviteShareAwardCmd = {
    id = 600015,
    req = "Cmd.UserInviteShareAwardCmd",
    ack = "Cmd.UserInviteShareAwardCmd",
    from = "ActivityCmd"
  },
  UserInviteInviteLoginAwardCmd = {
    id = 600016,
    req = "Cmd.UserInviteInviteLoginAwardCmd",
    ack = "Cmd.UserInviteInviteLoginAwardCmd",
    from = "ActivityCmd"
  },
  UserInviteRecallLoginAwardCmd = {
    id = 600017,
    req = "Cmd.UserInviteRecallLoginAwardCmd",
    ack = "Cmd.UserInviteRecallLoginAwardCmd",
    from = "ActivityCmd"
  },
  UserReturnInfoCmd = {
    id = 600018,
    req = "Cmd.UserReturnInfoCmd",
    ack = "Cmd.UserReturnInfoCmd",
    from = "ActivityCmd"
  },
  UserReturnQuestAwardCmd = {
    id = 600019,
    req = "Cmd.UserReturnQuestAwardCmd",
    ack = "Cmd.UserReturnQuestAwardCmd",
    from = "ActivityCmd"
  },
  UserReturnQuestAddCmd = {
    id = 600020,
    req = "Cmd.UserReturnQuestAddCmd",
    ack = "Cmd.UserReturnQuestAddCmd",
    from = "ActivityCmd"
  },
  UserReturnEnterChatRoomCmd = {
    id = 600021,
    req = "Cmd.UserReturnEnterChatRoomCmd",
    ack = "Cmd.UserReturnEnterChatRoomCmd",
    from = "ActivityCmd"
  },
  UserReturnLeaveChatRoomCmd = {
    id = 600022,
    req = "Cmd.UserReturnLeaveChatRoomCmd",
    ack = "Cmd.UserReturnLeaveChatRoomCmd",
    from = "ActivityCmd"
  },
  UserReturnLoginAwardCmd = {
    id = 600023,
    req = "Cmd.UserReturnLoginAwardCmd",
    ack = "Cmd.UserReturnLoginAwardCmd",
    from = "ActivityCmd"
  },
  UserReturnChatRoomRecordCmd = {
    id = 600024,
    req = "Cmd.UserReturnChatRoomRecordCmd",
    ack = "Cmd.UserReturnChatRoomRecordCmd",
    from = "ActivityCmd"
  },
  UserReturnRaidAwardCmd = {
    id = 600025,
    req = "Cmd.UserReturnRaidAwardCmd",
    ack = "Cmd.UserReturnRaidAwardCmd",
    from = "ActivityCmd"
  },
  WishActivityInfoCmd = {
    id = 600030,
    req = "Cmd.WishActivityInfoCmd",
    ack = "Cmd.WishActivityInfoCmd",
    from = "ActivityCmd"
  },
  WishActivityWishCmd = {
    id = 600031,
    req = "Cmd.WishActivityWishCmd",
    ack = "Cmd.WishActivityWishCmd",
    from = "ActivityCmd"
  },
  WishActivityLikeCmd = {
    id = 600032,
    req = "Cmd.WishActivityLikeCmd",
    ack = "Cmd.WishActivityLikeCmd",
    from = "ActivityCmd"
  },
  WishActivityLikeRecordCmd = {
    id = 600033,
    req = "Cmd.WishActivityLikeRecordCmd",
    ack = "Cmd.WishActivityLikeRecordCmd",
    from = "ActivityCmd"
  },
  UserReturnInviteCmd = {
    id = 600041,
    req = "Cmd.UserReturnInviteCmd",
    ack = "Cmd.UserReturnInviteCmd",
    from = "ActivityCmd"
  },
  UserReturnShareAwardCmd = {
    id = 600039,
    req = "Cmd.UserReturnShareAwardCmd",
    ack = "Cmd.UserReturnShareAwardCmd",
    from = "ActivityCmd"
  },
  UserReturnInviteAwardCmd = {
    id = 600040,
    req = "Cmd.UserReturnInviteAwardCmd",
    ack = "Cmd.UserReturnInviteAwardCmd",
    from = "ActivityCmd"
  },
  UserReturnBindCmd = {
    id = 600038,
    req = "Cmd.UserReturnBindCmd",
    ack = "Cmd.UserReturnBindCmd",
    from = "ActivityCmd"
  },
  UserReturnInviteRecordCmd = {
    id = 600042,
    req = "Cmd.UserReturnInviteRecordCmd",
    ack = "Cmd.UserReturnInviteRecordCmd",
    from = "ActivityCmd"
  },
  UserReturnInviteActivityNtfCmd = {
    id = 600043,
    req = "Cmd.UserReturnInviteActivityNtfCmd",
    ack = "Cmd.UserReturnInviteActivityNtfCmd",
    from = "ActivityCmd"
  },
  GuildAssembleSyncCmd = {
    id = 600034,
    req = "Cmd.GuildAssembleSyncCmd",
    ack = "Cmd.GuildAssembleSyncCmd",
    from = "ActivityCmd"
  },
  GuildAssembleAcceptCmd = {
    id = 600035,
    req = "Cmd.GuildAssembleAcceptCmd",
    ack = "Cmd.GuildAssembleAcceptCmd",
    from = "ActivityCmd"
  },
  GuildAssembleAwardCmd = {
    id = 600036,
    req = "Cmd.GuildAssembleAwardCmd",
    ack = "Cmd.GuildAssembleAwardCmd",
    from = "ActivityCmd"
  },
  DaySigninInfoCmd = {
    id = 600026,
    req = "Cmd.DaySigninInfoCmd",
    ack = "Cmd.DaySigninInfoCmd",
    from = "ActivityCmd"
  },
  DaySigninLoginAwardCmd = {
    id = 600027,
    req = "Cmd.DaySigninLoginAwardCmd",
    ack = "Cmd.DaySigninLoginAwardCmd",
    from = "ActivityCmd"
  },
  DaySigninActivityCmd = {
    id = 600028,
    req = "Cmd.DaySigninActivityCmd",
    ack = "Cmd.DaySigninActivityCmd",
    from = "ActivityCmd"
  },
  BattleFundNofityActCmd = {
    id = 600046,
    req = "Cmd.BattleFundNofityActCmd",
    ack = "Cmd.BattleFundNofityActCmd",
    from = "ActivityCmd"
  },
  BattleFundRewardActCmd = {
    id = 600047,
    req = "Cmd.BattleFundRewardActCmd",
    ack = "Cmd.BattleFundRewardActCmd",
    from = "ActivityCmd"
  },
  UserInviteCmd = {
    id = 600044,
    req = "Cmd.UserInviteCmd",
    ack = "Cmd.UserInviteCmd",
    from = "ActivityCmd"
  },
  UserInviteAwardCmd = {
    id = 600045,
    req = "Cmd.UserInviteAwardCmd",
    ack = "Cmd.UserInviteAwardCmd",
    from = "ActivityCmd"
  },
  NewPartnerCmd = {
    id = 600048,
    req = "Cmd.NewPartnerCmd",
    ack = "Cmd.NewPartnerCmd",
    from = "ActivityCmd"
  },
  NewPartnerBindCmd = {
    id = 600049,
    req = "Cmd.NewPartnerBindCmd",
    ack = "Cmd.NewPartnerBindCmd",
    from = "ActivityCmd"
  },
  AnniversaryInfoSync = {
    id = 600050,
    req = "Cmd.AnniversaryInfoSync",
    ack = "Cmd.AnniversaryInfoSync",
    from = "ActivityCmd"
  },
  AnniversarySignInReward = {
    id = 600051,
    req = "Cmd.AnniversarySignInReward",
    ack = "Cmd.AnniversarySignInReward",
    from = "ActivityCmd"
  },
  ActBpUpdateCmd = {
    id = 600053,
    req = "Cmd.ActBpUpdateCmd",
    ack = "Cmd.ActBpUpdateCmd",
    from = "ActivityCmd"
  },
  ActBpGetRewardCmd = {
    id = 600054,
    req = "Cmd.ActBpGetRewardCmd",
    ack = "Cmd.ActBpGetRewardCmd",
    from = "ActivityCmd"
  },
  ActBpBuyLevelCmd = {
    id = 600055,
    req = "Cmd.ActBpBuyLevelCmd",
    ack = "Cmd.ActBpBuyLevelCmd",
    from = "ActivityCmd"
  },
  FinishGlobalActivityCmd = {
    id = 600056,
    req = "Cmd.FinishGlobalActivityCmd",
    ack = "Cmd.FinishGlobalActivityCmd",
    from = "ActivityCmd"
  },
  RewardInfoGlobalActivityCmd = {
    id = 600057,
    req = "Cmd.RewardInfoGlobalActivityCmd",
    ack = "Cmd.RewardInfoGlobalActivityCmd",
    from = "ActivityCmd"
  },
  FlipCardInfoSyncCmd = {
    id = 600058,
    req = "Cmd.FlipCardInfoSyncCmd",
    ack = "Cmd.FlipCardInfoSyncCmd",
    from = "ActivityCmd"
  },
  FlipCardGetRewardCmd = {
    id = 600059,
    req = "Cmd.FlipCardGetRewardCmd",
    ack = "Cmd.FlipCardGetRewardCmd",
    from = "ActivityCmd"
  },
  FlipCardBuyChanceCmd = {
    id = 600060,
    req = "Cmd.FlipCardBuyChanceCmd",
    ack = "Cmd.FlipCardBuyChanceCmd",
    from = "ActivityCmd"
  },
  MissionRewardInfoSyncCmd = {
    id = 600082,
    req = "Cmd.MissionRewardInfoSyncCmd",
    ack = "Cmd.MissionRewardInfoSyncCmd",
    from = "ActivityCmd"
  },
  MissionRewardGetRewardCmd = {
    id = 600083,
    req = "Cmd.MissionRewardGetRewardCmd",
    ack = "Cmd.MissionRewardGetRewardCmd",
    from = "ActivityCmd"
  },
  ActPersonalTimeSyncCmd = {
    id = 600061,
    req = "Cmd.ActPersonalTimeSyncCmd",
    ack = "Cmd.ActPersonalTimeSyncCmd",
    from = "ActivityCmd"
  },
  NewServerChallengeSyncCmd = {
    id = 600064,
    req = "Cmd.NewServerChallengeSyncCmd",
    ack = "Cmd.NewServerChallengeSyncCmd",
    from = "ActivityCmd"
  },
  NewServerChallengeRewardCmd = {
    id = 600065,
    req = "Cmd.NewServerChallengeRewardCmd",
    ack = "Cmd.NewServerChallengeRewardCmd",
    from = "ActivityCmd"
  },
  RandHomeGiftBoxGridCmd = {
    id = 600062,
    req = "Cmd.RandHomeGiftBoxGridCmd",
    ack = "Cmd.RandHomeGiftBoxGridCmd",
    from = "ActivityCmd"
  },
  OpenHomeGiftBoxCmd = {
    id = 600063,
    req = "Cmd.OpenHomeGiftBoxCmd",
    ack = "Cmd.OpenHomeGiftBoxCmd",
    from = "ActivityCmd"
  },
  EscortActUpdateCmd = {
    id = 600066,
    req = "Cmd.EscortActUpdateCmd",
    ack = "Cmd.EscortActUpdateCmd",
    from = "ActivityCmd"
  },
  PutGoodsCmd = {
    id = 600067,
    req = "Cmd.PutGoodsCmd",
    ack = "Cmd.PutGoodsCmd",
    from = "ActivityCmd"
  },
  YearMemoryActInfoCmd = {
    id = 600068,
    req = "Cmd.YearMemoryActInfoCmd",
    ack = "Cmd.YearMemoryActInfoCmd",
    from = "ActivityCmd"
  },
  YearMemoryGetShareRewardCmd = {
    id = 600069,
    req = "Cmd.YearMemoryGetShareRewardCmd",
    ack = "Cmd.YearMemoryGetShareRewardCmd",
    from = "ActivityCmd"
  },
  FateSelectSyncInfoCmd = {
    id = 600074,
    req = "Cmd.FateSelectSyncInfoCmd",
    ack = "Cmd.FateSelectSyncInfoCmd",
    from = "ActivityCmd"
  },
  FateSelectDrawCmd = {
    id = 600075,
    req = "Cmd.FateSelectDrawCmd",
    ack = "Cmd.FateSelectDrawCmd",
    from = "ActivityCmd"
  },
  FateSelectRewardCmd = {
    id = 600076,
    req = "Cmd.FateSelectRewardCmd",
    ack = "Cmd.FateSelectRewardCmd",
    from = "ActivityCmd"
  },
  FateSelectTargetUpdateCmd = {
    id = 600077,
    req = "Cmd.FateSelectTargetUpdateCmd",
    ack = "Cmd.FateSelectTargetUpdateCmd",
    from = "ActivityCmd"
  },
  ActExchangeItemCmd = {
    id = 600078,
    req = "Cmd.ActExchangeItemCmd",
    ack = "Cmd.ActExchangeItemCmd",
    from = "ActivityCmd"
  },
  ActExchangeInfoCmd = {
    id = 600079,
    req = "Cmd.ActExchangeInfoCmd",
    ack = "Cmd.ActExchangeInfoCmd",
    from = "ActivityCmd"
  },
  EnterBigCatInvadeCmd = {
    id = 600080,
    req = "Cmd.EnterBigCatInvadeCmd",
    ack = "Cmd.EnterBigCatInvadeCmd",
    from = "ActivityCmd"
  },
  LeaveActStaticMapCmd = {
    id = 600081,
    req = "Cmd.LeaveActStaticMapCmd",
    ack = "Cmd.LeaveActStaticMapCmd",
    from = "ActivityCmd"
  },
  ActCardLevelUpInfoSyncCmd = {
    id = 600084,
    req = "Cmd.ActCardLevelUpInfoSyncCmd",
    ack = "Cmd.ActCardLevelUpInfoSyncCmd",
    from = "ActivityCmd"
  },
  ActivityEventNtf = {
    id = 640001,
    req = "Cmd.ActivityEventNtf",
    ack = "Cmd.ActivityEventNtf",
    from = "ActivityEvent"
  },
  ActivityEventUserDataNtf = {
    id = 640002,
    req = "Cmd.ActivityEventUserDataNtf",
    ack = "Cmd.ActivityEventUserDataNtf",
    from = "ActivityEvent"
  },
  ActivityEventNtfEventCntCmd = {
    id = 640003,
    req = "Cmd.ActivityEventNtfEventCntCmd",
    ack = "Cmd.ActivityEventNtfEventCntCmd",
    from = "ActivityEvent"
  },
  FinishActivityEventCmd = {
    id = 640004,
    req = "Cmd.FinishActivityEventCmd",
    ack = "Cmd.FinishActivityEventCmd",
    from = "ActivityEvent"
  },
  AstrolabeQueryCmd = {
    id = 280001,
    req = "Cmd.AstrolabeQueryCmd",
    ack = "Cmd.AstrolabeQueryCmd",
    from = "AstrolabeCmd"
  },
  AstrolabeActivateStarCmd = {
    id = 280002,
    req = "Cmd.AstrolabeActivateStarCmd",
    ack = "Cmd.AstrolabeActivateStarCmd",
    from = "AstrolabeCmd"
  },
  AstrolabeQueryResetCmd = {
    id = 280003,
    req = "Cmd.AstrolabeQueryResetCmd",
    ack = "Cmd.AstrolabeQueryResetCmd",
    from = "AstrolabeCmd"
  },
  AstrolabeResetCmd = {
    id = 280004,
    req = "Cmd.AstrolabeResetCmd",
    ack = "Cmd.AstrolabeResetCmd",
    from = "AstrolabeCmd"
  },
  AstrolabePlanSaveCmd = {
    id = 280005,
    req = "Cmd.AstrolabePlanSaveCmd",
    ack = "Cmd.AstrolabePlanSaveCmd",
    from = "AstrolabeCmd"
  },
  NtfAuctionStateCCmd = {
    id = 630001,
    req = "Cmd.NtfAuctionStateCCmd",
    ack = "Cmd.NtfAuctionStateCCmd",
    from = "AuctionCCmd"
  },
  OpenAuctionPanelCCmd = {
    id = 630002,
    req = "Cmd.OpenAuctionPanelCCmd",
    ack = "Cmd.OpenAuctionPanelCCmd",
    from = "AuctionCCmd"
  },
  NtfSignUpInfoCCmd = {
    id = 630003,
    req = "Cmd.NtfSignUpInfoCCmd",
    ack = "Cmd.NtfSignUpInfoCCmd",
    from = "AuctionCCmd"
  },
  NtfMySignUpInfoCCmd = {
    id = 630014,
    req = "Cmd.NtfMySignUpInfoCCmd",
    ack = "Cmd.NtfMySignUpInfoCCmd",
    from = "AuctionCCmd"
  },
  SignUpItemCCmd = {
    id = 630012,
    req = "Cmd.SignUpItemCCmd",
    ack = "Cmd.SignUpItemCCmd",
    from = "AuctionCCmd"
  },
  NtfAuctionInfoCCmd = {
    id = 630004,
    req = "Cmd.NtfAuctionInfoCCmd",
    ack = "Cmd.NtfAuctionInfoCCmd",
    from = "AuctionCCmd"
  },
  UpdateAuctionInfoCCmd = {
    id = 630005,
    req = "Cmd.UpdateAuctionInfoCCmd",
    ack = "Cmd.UpdateAuctionInfoCCmd",
    from = "AuctionCCmd"
  },
  ReqAuctionFlowingWaterCCmd = {
    id = 630006,
    req = "Cmd.ReqAuctionFlowingWaterCCmd",
    ack = "Cmd.ReqAuctionFlowingWaterCCmd",
    from = "AuctionCCmd"
  },
  UpdateAuctionFlowingWaterCCmd = {
    id = 630007,
    req = "Cmd.UpdateAuctionFlowingWaterCCmd",
    ack = "Cmd.UpdateAuctionFlowingWaterCCmd",
    from = "AuctionCCmd"
  },
  ReqLastAuctionInfoCCmd = {
    id = 630008,
    req = "Cmd.ReqLastAuctionInfoCCmd",
    ack = "Cmd.ReqLastAuctionInfoCCmd",
    from = "AuctionCCmd"
  },
  OfferPriceCCmd = {
    id = 630009,
    req = "Cmd.OfferPriceCCmd",
    ack = "Cmd.OfferPriceCCmd",
    from = "AuctionCCmd"
  },
  ReqAuctionRecordCCmd = {
    id = 630010,
    req = "Cmd.ReqAuctionRecordCCmd",
    ack = "Cmd.ReqAuctionRecordCCmd",
    from = "AuctionCCmd"
  },
  TakeAuctionRecordCCmd = {
    id = 630011,
    req = "Cmd.TakeAuctionRecordCCmd",
    ack = "Cmd.TakeAuctionRecordCCmd",
    from = "AuctionCCmd"
  },
  NtfCanTakeCntCCmd = {
    id = 630013,
    req = "Cmd.NtfCanTakeCntCCmd",
    ack = "Cmd.NtfCanTakeCntCCmd",
    from = "AuctionCCmd"
  },
  NtfMyOfferPriceCCmd = {
    id = 630015,
    req = "Cmd.NtfMyOfferPriceCCmd",
    ack = "Cmd.NtfMyOfferPriceCCmd",
    from = "AuctionCCmd"
  },
  NtfNextAuctionInfoCCmd = {
    id = 630016,
    req = "Cmd.NtfNextAuctionInfoCCmd",
    ack = "Cmd.NtfNextAuctionInfoCCmd",
    from = "AuctionCCmd"
  },
  ReqAuctionInfoCCmd = {
    id = 630017,
    req = "Cmd.ReqAuctionInfoCCmd",
    ack = "Cmd.ReqAuctionInfoCCmd",
    from = "AuctionCCmd"
  },
  NtfCurAuctionInfoCCmd = {
    id = 630018,
    req = "Cmd.NtfCurAuctionInfoCCmd",
    ack = "Cmd.NtfCurAuctionInfoCCmd",
    from = "AuctionCCmd"
  },
  NtfOverTakePriceCCmd = {
    id = 630019,
    req = "Cmd.NtfOverTakePriceCCmd",
    ack = "Cmd.NtfOverTakePriceCCmd",
    from = "AuctionCCmd"
  },
  ReqMyTradedPriceCCmd = {
    id = 630020,
    req = "Cmd.ReqMyTradedPriceCCmd",
    ack = "Cmd.ReqMyTradedPriceCCmd",
    from = "AuctionCCmd"
  },
  NtfMaskPriceCCmd = {
    id = 630021,
    req = "Cmd.NtfMaskPriceCCmd",
    ack = "Cmd.NtfMaskPriceCCmd",
    from = "AuctionCCmd"
  },
  AuctionDialogCCmd = {
    id = 630022,
    req = "Cmd.AuctionDialogCCmd",
    ack = "Cmd.AuctionDialogCCmd",
    from = "AuctionCCmd"
  },
  SetAuthorizeUserCmd = {
    id = 620001,
    req = "Cmd.SetAuthorizeUserCmd",
    ack = "Cmd.SetAuthorizeUserCmd",
    from = "Authorize"
  },
  ResetAuthorizeUserCmd = {
    id = 620002,
    req = "Cmd.ResetAuthorizeUserCmd",
    ack = "Cmd.ResetAuthorizeUserCmd",
    from = "Authorize"
  },
  SyncAuthorizeToSession = {
    id = 620003,
    req = "Cmd.SyncAuthorizeToSession",
    ack = "Cmd.SyncAuthorizeToSession",
    from = "Authorize"
  },
  NotifyAuthorizeUserCmd = {
    id = 620004,
    req = "Cmd.NotifyAuthorizeUserCmd",
    ack = "Cmd.NotifyAuthorizeUserCmd",
    from = "Authorize"
  },
  SyncRealAuthorizeToSession = {
    id = 620005,
    req = "Cmd.SyncRealAuthorizeToSession",
    ack = "Cmd.SyncRealAuthorizeToSession",
    from = "Authorize"
  },
  GetRewardBattlePassCmd = {
    id = 2220001,
    req = "Cmd.GetRewardBattlePassCmd",
    ack = "Cmd.GetRewardBattlePassCmd",
    from = "BattlePass"
  },
  UpdateRewardBattlePassCmd = {
    id = 2220002,
    req = "Cmd.UpdateRewardBattlePassCmd",
    ack = "Cmd.UpdateRewardBattlePassCmd",
    from = "BattlePass"
  },
  BuyLevelBattlePassCmd = {
    id = 2220003,
    req = "Cmd.BuyLevelBattlePassCmd",
    ack = "Cmd.BuyLevelBattlePassCmd",
    from = "BattlePass"
  },
  AdvanceBattlePassCmd = {
    id = 2220004,
    req = "Cmd.AdvanceBattlePassCmd",
    ack = "Cmd.AdvanceBattlePassCmd",
    from = "BattlePass"
  },
  SyncInfoBattlePassCmd = {
    id = 2220005,
    req = "Cmd.SyncInfoBattlePassCmd",
    ack = "Cmd.SyncInfoBattlePassCmd",
    from = "BattlePass"
  },
  BattlePassQuestInfoCmd = {
    id = 2220006,
    req = "Cmd.BattlePassQuestInfoCmd",
    ack = "Cmd.BattlePassQuestInfoCmd",
    from = "BattlePass"
  },
  BossListUserCmd = {
    id = 150001,
    req = "Cmd.BossListUserCmd",
    ack = "Cmd.BossListUserCmd",
    from = "BossCmd"
  },
  BossPosUserCmd = {
    id = 150002,
    req = "Cmd.BossPosUserCmd",
    ack = "Cmd.BossPosUserCmd",
    from = "BossCmd"
  },
  KillBossUserCmd = {
    id = 150003,
    req = "Cmd.KillBossUserCmd",
    ack = "Cmd.KillBossUserCmd",
    from = "BossCmd"
  },
  QueryKillerInfoBossCmd = {
    id = 150004,
    req = "Cmd.QueryKillerInfoBossCmd",
    ack = "Cmd.QueryKillerInfoBossCmd",
    from = "BossCmd"
  },
  WorldBossNtf = {
    id = 150005,
    req = "Cmd.WorldBossNtf",
    ack = "Cmd.WorldBossNtf",
    from = "BossCmd"
  },
  StepSyncBossCmd = {
    id = 150006,
    req = "Cmd.StepSyncBossCmd",
    ack = "Cmd.StepSyncBossCmd",
    from = "BossCmd"
  },
  QueryFavaouiteBossCmd = {
    id = 150007,
    req = "Cmd.QueryFavaouiteBossCmd",
    ack = "Cmd.QueryFavaouiteBossCmd",
    from = "BossCmd"
  },
  ModifyFavouriteBossCmd = {
    id = 150008,
    req = "Cmd.ModifyFavouriteBossCmd",
    ack = "Cmd.ModifyFavouriteBossCmd",
    from = "BossCmd"
  },
  QueryRareEliteCmd = {
    id = 150009,
    req = "Cmd.QueryRareEliteCmd",
    ack = "Cmd.QueryRareEliteCmd",
    from = "BossCmd"
  },
  QuerySpecMapRareEliteCmd = {
    id = 150010,
    req = "Cmd.QuerySpecMapRareEliteCmd",
    ack = "Cmd.QuerySpecMapRareEliteCmd",
    from = "BossCmd"
  },
  UpdateCurMapBossCmd = {
    id = 150011,
    req = "Cmd.UpdateCurMapBossCmd",
    ack = "Cmd.UpdateCurMapBossCmd",
    from = "BossCmd"
  },
  CarrierInfoUserCmd = {
    id = 160001,
    req = "Cmd.CarrierInfoUserCmd",
    ack = "Cmd.CarrierInfoUserCmd",
    from = "CarrierCmd"
  },
  CreateCarrierUserCmd = {
    id = 160006,
    req = "Cmd.CreateCarrierUserCmd",
    ack = "Cmd.CreateCarrierUserCmd",
    from = "CarrierCmd"
  },
  InviteCarrierUserCmd = {
    id = 160010,
    req = "Cmd.InviteCarrierUserCmd",
    ack = "Cmd.InviteCarrierUserCmd",
    from = "CarrierCmd"
  },
  JoinCarrierUserCmd = {
    id = 160002,
    req = "Cmd.JoinCarrierUserCmd",
    ack = "Cmd.JoinCarrierUserCmd",
    from = "CarrierCmd"
  },
  RetJoinCarrierUserCmd = {
    id = 160003,
    req = "Cmd.RetJoinCarrierUserCmd",
    ack = "Cmd.RetJoinCarrierUserCmd",
    from = "CarrierCmd"
  },
  LeaveCarrierUserCmd = {
    id = 160004,
    req = "Cmd.LeaveCarrierUserCmd",
    ack = "Cmd.LeaveCarrierUserCmd",
    from = "CarrierCmd"
  },
  ReachCarrierUserCmd = {
    id = 160009,
    req = "Cmd.ReachCarrierUserCmd",
    ack = "Cmd.ReachCarrierUserCmd",
    from = "CarrierCmd"
  },
  CarrierMoveUserCmd = {
    id = 160005,
    req = "Cmd.CarrierMoveUserCmd",
    ack = "Cmd.CarrierMoveUserCmd",
    from = "CarrierCmd"
  },
  CarrierStartUserCmd = {
    id = 160007,
    req = "Cmd.CarrierStartUserCmd",
    ack = "Cmd.CarrierStartUserCmd",
    from = "CarrierCmd"
  },
  CarrierWaitListUserCmd = {
    id = 160008,
    req = "Cmd.CarrierWaitListUserCmd",
    ack = "Cmd.CarrierWaitListUserCmd",
    from = "CarrierCmd"
  },
  ChangeCarrierUserCmd = {
    id = 160011,
    req = "Cmd.ChangeCarrierUserCmd",
    ack = "Cmd.ChangeCarrierUserCmd",
    from = "CarrierCmd"
  },
  FerrisWheelInviteCarrierCmd = {
    id = 160012,
    req = "Cmd.FerrisWheelInviteCarrierCmd",
    ack = "Cmd.FerrisWheelInviteCarrierCmd",
    from = "CarrierCmd"
  },
  FerrisWheelProcessInviteCarrierCmd = {
    id = 160013,
    req = "Cmd.FerrisWheelProcessInviteCarrierCmd",
    ack = "Cmd.FerrisWheelProcessInviteCarrierCmd",
    from = "CarrierCmd"
  },
  StartFerrisWheelUserCmd = {
    id = 160014,
    req = "Cmd.StartFerrisWheelUserCmd",
    ack = "Cmd.StartFerrisWheelUserCmd",
    from = "CarrierCmd"
  },
  CatchUserJoinCarrierUserCmd = {
    id = 160015,
    req = "Cmd.CatchUserJoinCarrierUserCmd",
    ack = "Cmd.CatchUserJoinCarrierUserCmd",
    from = "CarrierCmd"
  },
  QueryItemData = {
    id = 590001,
    req = "Cmd.QueryItemData",
    ack = "Cmd.QueryItemData",
    from = "ChatCmd"
  },
  PlayExpressionChatCmd = {
    id = 590002,
    req = "Cmd.PlayExpressionChatCmd",
    ack = "Cmd.PlayExpressionChatCmd",
    from = "ChatCmd"
  },
  QueryUserInfoChatCmd = {
    id = 590003,
    req = "Cmd.QueryUserInfoChatCmd",
    ack = "Cmd.QueryUserInfoChatCmd",
    from = "ChatCmd"
  },
  QueryUserGemChatCmd = {
    id = 590020,
    req = "Cmd.QueryUserGemChatCmd",
    ack = "Cmd.QueryUserGemChatCmd",
    from = "ChatCmd"
  },
  BarrageChatCmd = {
    id = 590004,
    req = "Cmd.BarrageChatCmd",
    ack = "Cmd.BarrageChatCmd",
    from = "ChatCmd"
  },
  BarrageMsgChatCmd = {
    id = 590005,
    req = "Cmd.BarrageMsgChatCmd",
    ack = "Cmd.BarrageMsgChatCmd",
    from = "ChatCmd"
  },
  ChatCmd = {
    id = 590006,
    req = "Cmd.ChatCmd",
    ack = "Cmd.ChatCmd",
    from = "ChatCmd"
  },
  ChatRetCmd = {
    id = 590007,
    req = "Cmd.ChatRetCmd",
    ack = "Cmd.ChatRetCmd",
    from = "ChatCmd"
  },
  QueryVoiceUserCmd = {
    id = 590008,
    req = "Cmd.QueryVoiceUserCmd",
    ack = "Cmd.QueryVoiceUserCmd",
    from = "ChatCmd"
  },
  GetVoiceIDChatCmd = {
    id = 590010,
    req = "Cmd.GetVoiceIDChatCmd",
    ack = "Cmd.GetVoiceIDChatCmd",
    from = "ChatCmd"
  },
  LoveLetterNtf = {
    id = 590011,
    req = "Cmd.LoveLetterNtf",
    ack = "Cmd.LoveLetterNtf",
    from = "ChatCmd"
  },
  ChatSelfNtf = {
    id = 590012,
    req = "Cmd.ChatSelfNtf",
    ack = "Cmd.ChatSelfNtf",
    from = "ChatCmd"
  },
  NpcChatNtf = {
    id = 590013,
    req = "Cmd.NpcChatNtf",
    ack = "Cmd.NpcChatNtf",
    from = "ChatCmd"
  },
  QueryUserShowInfoCmd = {
    id = 590016,
    req = "Cmd.QueryUserShowInfoCmd",
    ack = "Cmd.QueryUserShowInfoCmd",
    from = "ChatCmd"
  },
  SystemBarrageChatCmd = {
    id = 590015,
    req = "Cmd.SystemBarrageChatCmd",
    ack = "Cmd.SystemBarrageChatCmd",
    from = "ChatCmd"
  },
  QueryFavoriteExpressionChatCmd = {
    id = 590017,
    req = "Cmd.QueryFavoriteExpressionChatCmd",
    ack = "Cmd.QueryFavoriteExpressionChatCmd",
    from = "ChatCmd"
  },
  UpdateFavoriteExpressionChatCmd = {
    id = 590018,
    req = "Cmd.UpdateFavoriteExpressionChatCmd",
    ack = "Cmd.UpdateFavoriteExpressionChatCmd",
    from = "ChatCmd"
  },
  ExpressionChatCmd = {
    id = 590019,
    req = "Cmd.ExpressionChatCmd",
    ack = "Cmd.ExpressionChatCmd",
    from = "ChatCmd"
  },
  FaceShowChatCmd = {
    id = 590021,
    req = "Cmd.FaceShowChatCmd",
    ack = "Cmd.FaceShowChatCmd",
    from = "ChatCmd"
  },
  ClientLogChatCmd = {
    id = 590022,
    req = "Cmd.ClientLogChatCmd",
    ack = "Cmd.ClientLogChatCmd",
    from = "ChatCmd"
  },
  RedPacketContent = {
    id = 1,
    req = "Cmd.RedPacketContent",
    ack = "Cmd.RedPacketContent",
    from = "ChatCmd"
  },
  SendRedPacketCmd = {
    id = 590023,
    req = "Cmd.SendRedPacketCmd",
    ack = "Cmd.SendRedPacketCmd",
    from = "ChatCmd"
  },
  ReceiveRedPacketCmd = {
    id = 590024,
    req = "Cmd.ReceiveRedPacketCmd",
    ack = "Cmd.ReceiveRedPacketCmd",
    from = "ChatCmd"
  },
  InitUserRedPacketCmd = {
    id = 590025,
    req = "Cmd.InitUserRedPacketCmd",
    ack = "Cmd.InitUserRedPacketCmd",
    from = "ChatCmd"
  },
  ReceiveRedPacketRet = {
    id = 590027,
    req = "Cmd.ReceiveRedPacketRet",
    ack = "Cmd.ReceiveRedPacketRet",
    from = "ChatCmd"
  },
  ShareMsgCmd = {
    id = 590028,
    req = "Cmd.ShareMsgCmd",
    ack = "Cmd.ShareMsgCmd",
    from = "ChatCmd"
  },
  ShareSuccessNofityCmd = {
    id = 590029,
    req = "Cmd.ShareSuccessNofityCmd",
    ack = "Cmd.ShareSuccessNofityCmd",
    from = "ChatCmd"
  },
  QueryGuildRedPacketChatCmd = {
    id = 590030,
    req = "Cmd.QueryGuildRedPacketChatCmd",
    ack = "Cmd.QueryGuildRedPacketChatCmd",
    from = "ChatCmd"
  },
  CheckRecvRedPacketChatCmd = {
    id = 590031,
    req = "Cmd.CheckRecvRedPacketChatCmd",
    ack = "Cmd.CheckRecvRedPacketChatCmd",
    from = "ChatCmd"
  },
  QueryDisneyGuideInfoCmd = {
    id = 2320001,
    req = "Cmd.QueryDisneyGuideInfoCmd",
    ack = "Cmd.QueryDisneyGuideInfoCmd",
    from = "DisneyActivity"
  },
  ReceiveGuideRewardCmd = {
    id = 2320002,
    req = "Cmd.ReceiveGuideRewardCmd",
    ack = "Cmd.ReceiveGuideRewardCmd",
    from = "DisneyActivity"
  },
  ReceiveMickeyRewardCmd = {
    id = 2320003,
    req = "Cmd.ReceiveMickeyRewardCmd",
    ack = "Cmd.ReceiveMickeyRewardCmd",
    from = "DisneyActivity"
  },
  DisneyChallengeTaskRankCmd = {
    id = 2320004,
    req = "Cmd.DisneyChallengeTaskRankCmd",
    ack = "Cmd.DisneyChallengeTaskRankCmd",
    from = "DisneyActivity"
  },
  DisneyChallengeTaskTipCmd = {
    id = 2320005,
    req = "Cmd.DisneyChallengeTaskTipCmd",
    ack = "Cmd.DisneyChallengeTaskTipCmd",
    from = "DisneyActivity"
  },
  DisneyChallengeTaskPointCmd = {
    id = 2320006,
    req = "Cmd.DisneyChallengeTaskPointCmd",
    ack = "Cmd.DisneyChallengeTaskPointCmd",
    from = "DisneyActivity"
  },
  DisneyChallengeTaskNotifyFirstFinishCmd = {
    id = 2320007,
    req = "Cmd.DisneyChallengeTaskNotifyFirstFinishCmd",
    ack = "Cmd.DisneyChallengeTaskNotifyFirstFinishCmd",
    from = "DisneyActivity"
  },
  DisneyMusicOpenCmd = {
    id = 2320008,
    req = "Cmd.DisneyMusicOpenCmd",
    ack = "Cmd.DisneyMusicOpenCmd",
    from = "DisneyActivity"
  },
  DisneyMusicUpdateCmd = {
    id = 2320009,
    req = "Cmd.DisneyMusicUpdateCmd",
    ack = "Cmd.DisneyMusicUpdateCmd",
    from = "DisneyActivity"
  },
  DisneyMusicChooseHeroCmd = {
    id = 2320010,
    req = "Cmd.DisneyMusicChooseHeroCmd",
    ack = "Cmd.DisneyMusicChooseHeroCmd",
    from = "DisneyActivity"
  },
  DisneyMusicPrepareCmd = {
    id = 2320011,
    req = "Cmd.DisneyMusicPrepareCmd",
    ack = "Cmd.DisneyMusicPrepareCmd",
    from = "DisneyActivity"
  },
  DisneyMusicChooseMusicCmd = {
    id = 2320012,
    req = "Cmd.DisneyMusicChooseMusicCmd",
    ack = "Cmd.DisneyMusicChooseMusicCmd",
    from = "DisneyActivity"
  },
  DisneyMusicStartCmd = {
    id = 2320013,
    req = "Cmd.DisneyMusicStartCmd",
    ack = "Cmd.DisneyMusicStartCmd",
    from = "DisneyActivity"
  },
  DisneyMusicFinishCmd = {
    id = 2320014,
    req = "Cmd.DisneyMusicFinishCmd",
    ack = "Cmd.DisneyMusicFinishCmd",
    from = "DisneyActivity"
  },
  DisneyMusicResultCmd = {
    id = 2320015,
    req = "Cmd.DisneyMusicResultCmd",
    ack = "Cmd.DisneyMusicResultCmd",
    from = "DisneyActivity"
  },
  DisneyMusicRankCmd = {
    id = 2320016,
    req = "Cmd.DisneyMusicRankCmd",
    ack = "Cmd.DisneyMusicRankCmd",
    from = "DisneyActivity"
  },
  DisneyMusicClientPrepareCmd = {
    id = 2320017,
    req = "Cmd.DisneyMusicClientPrepareCmd",
    ack = "Cmd.DisneyMusicClientPrepareCmd",
    from = "DisneyActivity"
  },
  DojoPrivateInfoCmd = {
    id = 580001,
    req = "Cmd.DojoPrivateInfoCmd",
    ack = "Cmd.DojoPrivateInfoCmd",
    from = "Dojo"
  },
  DojoPublicInfoCmd = {
    id = 580002,
    req = "Cmd.DojoPublicInfoCmd",
    ack = "Cmd.DojoPublicInfoCmd",
    from = "Dojo"
  },
  DojoInviteCmd = {
    id = 580003,
    req = "Cmd.DojoInviteCmd",
    ack = "Cmd.DojoInviteCmd",
    from = "Dojo"
  },
  DojoReplyCmd = {
    id = 580004,
    req = "Cmd.DojoReplyCmd",
    ack = "Cmd.DojoReplyCmd",
    from = "Dojo"
  },
  EnterDojo = {
    id = 580005,
    req = "Cmd.EnterDojo",
    ack = "Cmd.EnterDojo",
    from = "Dojo"
  },
  DojoAddMsg = {
    id = 580006,
    req = "Cmd.DojoAddMsg",
    ack = "Cmd.DojoAddMsg",
    from = "Dojo"
  },
  DojoPanelOper = {
    id = 580007,
    req = "Cmd.DojoPanelOper",
    ack = "Cmd.DojoPanelOper",
    from = "Dojo"
  },
  DojoSponsorCmd = {
    id = 580009,
    req = "Cmd.DojoSponsorCmd",
    ack = "Cmd.DojoSponsorCmd",
    from = "Dojo"
  },
  DojoQueryStateCmd = {
    id = 580010,
    req = "Cmd.DojoQueryStateCmd",
    ack = "Cmd.DojoQueryStateCmd",
    from = "Dojo"
  },
  DojoRewardCmd = {
    id = 580011,
    req = "Cmd.DojoRewardCmd",
    ack = "Cmd.DojoRewardCmd",
    from = "Dojo"
  },
  RegErrUserCmd = {
    id = 20001,
    req = "Cmd.RegErrUserCmd",
    ack = "Cmd.RegErrUserCmd",
    from = "ErrorUserCmd"
  },
  KickUserErrorCmd = {
    id = 20002,
    req = "Cmd.KickUserErrorCmd",
    ack = "Cmd.KickUserErrorCmd",
    from = "ErrorUserCmd"
  },
  MaintainUserCmd = {
    id = 20003,
    req = "Cmd.MaintainUserCmd",
    ack = "Cmd.MaintainUserCmd",
    from = "ErrorUserCmd"
  },
  ClueDataNtfFamilyCmd = {
    id = 2340001,
    req = "Cmd.ClueDataNtfFamilyCmd",
    ack = "Cmd.ClueDataNtfFamilyCmd",
    from = "FamilyCmd"
  },
  ClueUnlockFamilyCmd = {
    id = 2340002,
    req = "Cmd.ClueUnlockFamilyCmd",
    ack = "Cmd.ClueUnlockFamilyCmd",
    from = "FamilyCmd"
  },
  ClueRewardFamilyCmd = {
    id = 2340003,
    req = "Cmd.ClueRewardFamilyCmd",
    ack = "Cmd.ClueRewardFamilyCmd",
    from = "FamilyCmd"
  },
  TrackFuBenUserCmd = {
    id = 110001,
    req = "Cmd.TrackFuBenUserCmd",
    ack = "Cmd.TrackFuBenUserCmd",
    from = "FuBenCmd"
  },
  FailFuBenUserCmd = {
    id = 110002,
    req = "Cmd.FailFuBenUserCmd",
    ack = "Cmd.FailFuBenUserCmd",
    from = "FuBenCmd"
  },
  LeaveFuBenUserCmd = {
    id = 110003,
    req = "Cmd.LeaveFuBenUserCmd",
    ack = "Cmd.LeaveFuBenUserCmd",
    from = "FuBenCmd"
  },
  SuccessFuBenUserCmd = {
    id = 110004,
    req = "Cmd.SuccessFuBenUserCmd",
    ack = "Cmd.SuccessFuBenUserCmd",
    from = "FuBenCmd"
  },
  WorldStageUserCmd = {
    id = 110005,
    req = "Cmd.WorldStageUserCmd",
    ack = "Cmd.WorldStageUserCmd",
    from = "FuBenCmd"
  },
  StageStepUserCmd = {
    id = 110006,
    req = "Cmd.StageStepUserCmd",
    ack = "Cmd.StageStepUserCmd",
    from = "FuBenCmd"
  },
  StartStageUserCmd = {
    id = 110007,
    req = "Cmd.StartStageUserCmd",
    ack = "Cmd.StartStageUserCmd",
    from = "FuBenCmd"
  },
  GetRewardStageUserCmd = {
    id = 110008,
    req = "Cmd.GetRewardStageUserCmd",
    ack = "Cmd.GetRewardStageUserCmd",
    from = "FuBenCmd"
  },
  StageStepStarUserCmd = {
    id = 110009,
    req = "Cmd.StageStepStarUserCmd",
    ack = "Cmd.StageStepStarUserCmd",
    from = "FuBenCmd"
  },
  MonsterCountUserCmd = {
    id = 110011,
    req = "Cmd.MonsterCountUserCmd",
    ack = "Cmd.MonsterCountUserCmd",
    from = "FuBenCmd"
  },
  FubenStepSyncCmd = {
    id = 110012,
    req = "Cmd.FubenStepSyncCmd",
    ack = "Cmd.FubenStepSyncCmd",
    from = "FuBenCmd"
  },
  FuBenProgressSyncCmd = {
    id = 110013,
    req = "Cmd.FuBenProgressSyncCmd",
    ack = "Cmd.FuBenProgressSyncCmd",
    from = "FuBenCmd"
  },
  FuBenClearInfoCmd = {
    id = 110015,
    req = "Cmd.FuBenClearInfoCmd",
    ack = "Cmd.FuBenClearInfoCmd",
    from = "FuBenCmd"
  },
  GuildGateData = {
    id = 1,
    req = "Cmd.GuildGateData",
    ack = "Cmd.GuildGateData",
    from = "FuBenCmd"
  },
  UserGuildRaidFubenCmd = {
    id = 110016,
    req = "Cmd.UserGuildRaidFubenCmd",
    ack = "Cmd.UserGuildRaidFubenCmd",
    from = "FuBenCmd"
  },
  GuildGateOptCmd = {
    id = 110017,
    req = "Cmd.GuildGateOptCmd",
    ack = "Cmd.GuildGateOptCmd",
    from = "FuBenCmd"
  },
  GuildFireInfoFubenCmd = {
    id = 110018,
    req = "Cmd.GuildFireInfoFubenCmd",
    ack = "Cmd.GuildFireInfoFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireStopFubenCmd = {
    id = 110019,
    req = "Cmd.GuildFireStopFubenCmd",
    ack = "Cmd.GuildFireStopFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireDangerFubenCmd = {
    id = 110020,
    req = "Cmd.GuildFireDangerFubenCmd",
    ack = "Cmd.GuildFireDangerFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireMetalHpFubenCmd = {
    id = 110021,
    req = "Cmd.GuildFireMetalHpFubenCmd",
    ack = "Cmd.GuildFireMetalHpFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireCalmFubenCmd = {
    id = 110022,
    req = "Cmd.GuildFireCalmFubenCmd",
    ack = "Cmd.GuildFireCalmFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireNewDefFubenCmd = {
    id = 110023,
    req = "Cmd.GuildFireNewDefFubenCmd",
    ack = "Cmd.GuildFireNewDefFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireRestartFubenCmd = {
    id = 110024,
    req = "Cmd.GuildFireRestartFubenCmd",
    ack = "Cmd.GuildFireRestartFubenCmd",
    from = "FuBenCmd"
  },
  GuildFireStatusFubenCmd = {
    id = 110025,
    req = "Cmd.GuildFireStatusFubenCmd",
    ack = "Cmd.GuildFireStatusFubenCmd",
    from = "FuBenCmd"
  },
  GvgDataSyncCmd = {
    id = 110026,
    req = "Cmd.GvgDataSyncCmd",
    ack = "Cmd.GvgDataSyncCmd",
    from = "FuBenCmd"
  },
  GvgDataUpdateCmd = {
    id = 110027,
    req = "Cmd.GvgDataUpdateCmd",
    ack = "Cmd.GvgDataUpdateCmd",
    from = "FuBenCmd"
  },
  GvgDefNameChangeFubenCmd = {
    id = 110028,
    req = "Cmd.GvgDefNameChangeFubenCmd",
    ack = "Cmd.GvgDefNameChangeFubenCmd",
    from = "FuBenCmd"
  },
  SyncMvpInfoFubenCmd = {
    id = 110029,
    req = "Cmd.SyncMvpInfoFubenCmd",
    ack = "Cmd.SyncMvpInfoFubenCmd",
    from = "FuBenCmd"
  },
  BossDieFubenCmd = {
    id = 110030,
    req = "Cmd.BossDieFubenCmd",
    ack = "Cmd.BossDieFubenCmd",
    from = "FuBenCmd"
  },
  UpdateUserNumFubenCmd = {
    id = 110031,
    req = "Cmd.UpdateUserNumFubenCmd",
    ack = "Cmd.UpdateUserNumFubenCmd",
    from = "FuBenCmd"
  },
  SuperGvgSyncFubenCmd = {
    id = 110032,
    req = "Cmd.SuperGvgSyncFubenCmd",
    ack = "Cmd.SuperGvgSyncFubenCmd",
    from = "FuBenCmd"
  },
  GvgTowerUpdateFubenCmd = {
    id = 110033,
    req = "Cmd.GvgTowerUpdateFubenCmd",
    ack = "Cmd.GvgTowerUpdateFubenCmd",
    from = "FuBenCmd"
  },
  GvgMetalDieFubenCmd = {
    id = 110039,
    req = "Cmd.GvgMetalDieFubenCmd",
    ack = "Cmd.GvgMetalDieFubenCmd",
    from = "FuBenCmd"
  },
  GvgCrystalUpdateFubenCmd = {
    id = 110034,
    req = "Cmd.GvgCrystalUpdateFubenCmd",
    ack = "Cmd.GvgCrystalUpdateFubenCmd",
    from = "FuBenCmd"
  },
  QueryGvgTowerInfoFubenCmd = {
    id = 110035,
    req = "Cmd.QueryGvgTowerInfoFubenCmd",
    ack = "Cmd.QueryGvgTowerInfoFubenCmd",
    from = "FuBenCmd"
  },
  SuperGvgRewardInfoFubenCmd = {
    id = 110036,
    req = "Cmd.SuperGvgRewardInfoFubenCmd",
    ack = "Cmd.SuperGvgRewardInfoFubenCmd",
    from = "FuBenCmd"
  },
  SuperGvgQueryUserDataFubenCmd = {
    id = 110037,
    req = "Cmd.SuperGvgQueryUserDataFubenCmd",
    ack = "Cmd.SuperGvgQueryUserDataFubenCmd",
    from = "FuBenCmd"
  },
  MvpBattleReportFubenCmd = {
    id = 110038,
    req = "Cmd.MvpBattleReportFubenCmd",
    ack = "Cmd.MvpBattleReportFubenCmd",
    from = "FuBenCmd"
  },
  InviteSummonBossFubenCmd = {
    id = 110040,
    req = "Cmd.InviteSummonBossFubenCmd",
    ack = "Cmd.InviteSummonBossFubenCmd",
    from = "FuBenCmd"
  },
  ReplySummonBossFubenCmd = {
    id = 110041,
    req = "Cmd.ReplySummonBossFubenCmd",
    ack = "Cmd.ReplySummonBossFubenCmd",
    from = "FuBenCmd"
  },
  QueryTeamPwsUserInfoFubenCmd = {
    id = 110042,
    req = "Cmd.QueryTeamPwsUserInfoFubenCmd",
    ack = "Cmd.QueryTeamPwsUserInfoFubenCmd",
    from = "FuBenCmd"
  },
  TeamPwsReportFubenCmd = {
    id = 110043,
    req = "Cmd.TeamPwsReportFubenCmd",
    ack = "Cmd.TeamPwsReportFubenCmd",
    from = "FuBenCmd"
  },
  TeamPwsInfoSyncFubenCmd = {
    id = 110044,
    req = "Cmd.TeamPwsInfoSyncFubenCmd",
    ack = "Cmd.TeamPwsInfoSyncFubenCmd",
    from = "FuBenCmd"
  },
  UpdateTeamPwsInfoFubenCmd = {
    id = 110047,
    req = "Cmd.UpdateTeamPwsInfoFubenCmd",
    ack = "Cmd.UpdateTeamPwsInfoFubenCmd",
    from = "FuBenCmd"
  },
  SelectTeamPwsMagicFubenCmd = {
    id = 110045,
    req = "Cmd.SelectTeamPwsMagicFubenCmd",
    ack = "Cmd.SelectTeamPwsMagicFubenCmd",
    from = "FuBenCmd"
  },
  ExitMapFubenCmd = {
    id = 110048,
    req = "Cmd.ExitMapFubenCmd",
    ack = "Cmd.ExitMapFubenCmd",
    from = "FuBenCmd"
  },
  BeginFireFubenCmd = {
    id = 110049,
    req = "Cmd.BeginFireFubenCmd",
    ack = "Cmd.BeginFireFubenCmd",
    from = "FuBenCmd"
  },
  TeamExpReportFubenCmd = {
    id = 110050,
    req = "Cmd.TeamExpReportFubenCmd",
    ack = "Cmd.TeamExpReportFubenCmd",
    from = "FuBenCmd"
  },
  BuyExpRaidItemFubenCmd = {
    id = 110051,
    req = "Cmd.BuyExpRaidItemFubenCmd",
    ack = "Cmd.BuyExpRaidItemFubenCmd",
    from = "FuBenCmd"
  },
  TeamExpSyncFubenCmd = {
    id = 110052,
    req = "Cmd.TeamExpSyncFubenCmd",
    ack = "Cmd.TeamExpSyncFubenCmd",
    from = "FuBenCmd"
  },
  TeamReliveCountFubenCmd = {
    id = 110053,
    req = "Cmd.TeamReliveCountFubenCmd",
    ack = "Cmd.TeamReliveCountFubenCmd",
    from = "FuBenCmd"
  },
  TeamGroupRaidUpdateChipNum = {
    id = 110054,
    req = "Cmd.TeamGroupRaidUpdateChipNum",
    ack = "Cmd.TeamGroupRaidUpdateChipNum",
    from = "FuBenCmd"
  },
  QueryTeamGroupRaidUserInfo = {
    id = 110055,
    req = "Cmd.QueryTeamGroupRaidUserInfo",
    ack = "Cmd.QueryTeamGroupRaidUserInfo",
    from = "FuBenCmd"
  },
  GroupRaidStateSyncFuBenCmd = {
    id = 110057,
    req = "Cmd.GroupRaidStateSyncFuBenCmd",
    ack = "Cmd.GroupRaidStateSyncFuBenCmd",
    from = "FuBenCmd"
  },
  TeamExpQueryInfoFubenCmd = {
    id = 110056,
    req = "Cmd.TeamExpQueryInfoFubenCmd",
    ack = "Cmd.TeamExpQueryInfoFubenCmd",
    from = "FuBenCmd"
  },
  UpdateGroupRaidFourthShowData = {
    id = 110060,
    req = "Cmd.UpdateGroupRaidFourthShowData",
    ack = "Cmd.UpdateGroupRaidFourthShowData",
    from = "FuBenCmd"
  },
  QueryGroupRaidFourthShowData = {
    id = 110059,
    req = "Cmd.QueryGroupRaidFourthShowData",
    ack = "Cmd.QueryGroupRaidFourthShowData",
    from = "FuBenCmd"
  },
  GroupRaidFourthGoOuterCmd = {
    id = 110061,
    req = "Cmd.GroupRaidFourthGoOuterCmd",
    ack = "Cmd.GroupRaidFourthGoOuterCmd",
    from = "FuBenCmd"
  },
  RaidStageSyncFubenCmd = {
    id = 110062,
    req = "Cmd.RaidStageSyncFubenCmd",
    ack = "Cmd.RaidStageSyncFubenCmd",
    from = "FuBenCmd"
  },
  ThanksGivingMonsterFuBenCmd = {
    id = 110063,
    req = "Cmd.ThanksGivingMonsterFuBenCmd",
    ack = "Cmd.ThanksGivingMonsterFuBenCmd",
    from = "FuBenCmd"
  },
  KumamotoOperFubenCmd = {
    id = 110058,
    req = "Cmd.KumamotoOperFubenCmd",
    ack = "Cmd.KumamotoOperFubenCmd",
    from = "FuBenCmd"
  },
  OthelloPointOccupyPowerFubenCmd = {
    id = 110064,
    req = "Cmd.OthelloPointOccupyPowerFubenCmd",
    ack = "Cmd.OthelloPointOccupyPowerFubenCmd",
    from = "FuBenCmd"
  },
  OthelloInfoSyncFubenCmd = {
    id = 110065,
    req = "Cmd.OthelloInfoSyncFubenCmd",
    ack = "Cmd.OthelloInfoSyncFubenCmd",
    from = "FuBenCmd"
  },
  QueryOthelloUserInfoFubenCmd = {
    id = 110066,
    req = "Cmd.QueryOthelloUserInfoFubenCmd",
    ack = "Cmd.QueryOthelloUserInfoFubenCmd",
    from = "FuBenCmd"
  },
  OthelloReportFubenCmd = {
    id = 110067,
    req = "Cmd.OthelloReportFubenCmd",
    ack = "Cmd.OthelloReportFubenCmd",
    from = "FuBenCmd"
  },
  RoguelikeUnlockSceneSync = {
    id = 110068,
    req = "Cmd.RoguelikeUnlockSceneSync",
    ack = "Cmd.RoguelikeUnlockSceneSync",
    from = "FuBenCmd"
  },
  TransferFightChooseFubenCmd = {
    id = 110069,
    req = "Cmd.TransferFightChooseFubenCmd",
    ack = "Cmd.TransferFightChooseFubenCmd",
    from = "FuBenCmd"
  },
  TransferFightRankFubenCmd = {
    id = 110070,
    req = "Cmd.TransferFightRankFubenCmd",
    ack = "Cmd.TransferFightRankFubenCmd",
    from = "FuBenCmd"
  },
  TransferFightEndFubenCmd = {
    id = 110071,
    req = "Cmd.TransferFightEndFubenCmd",
    ack = "Cmd.TransferFightEndFubenCmd",
    from = "FuBenCmd"
  },
  InviteRollRewardFubenCmd = {
    id = 110082,
    req = "Cmd.InviteRollRewardFubenCmd",
    ack = "Cmd.InviteRollRewardFubenCmd",
    from = "FuBenCmd"
  },
  ReplyRollRewardFubenCmd = {
    id = 110083,
    req = "Cmd.ReplyRollRewardFubenCmd",
    ack = "Cmd.ReplyRollRewardFubenCmd",
    from = "FuBenCmd"
  },
  TeamRollStatusFuBenCmd = {
    id = 110084,
    req = "Cmd.TeamRollStatusFuBenCmd",
    ack = "Cmd.TeamRollStatusFuBenCmd",
    from = "FuBenCmd"
  },
  PreReplyRollRewardFubenCmd = {
    id = 110085,
    req = "Cmd.PreReplyRollRewardFubenCmd",
    ack = "Cmd.PreReplyRollRewardFubenCmd",
    from = "FuBenCmd"
  },
  TwelvePvpSyncCmd = {
    id = 110072,
    req = "Cmd.TwelvePvpSyncCmd",
    ack = "Cmd.TwelvePvpSyncCmd",
    from = "FuBenCmd"
  },
  RaidItemSyncCmd = {
    id = 110073,
    req = "Cmd.RaidItemSyncCmd",
    ack = "Cmd.RaidItemSyncCmd",
    from = "FuBenCmd"
  },
  RaidItemUpdateCmd = {
    id = 110074,
    req = "Cmd.RaidItemUpdateCmd",
    ack = "Cmd.RaidItemUpdateCmd",
    from = "FuBenCmd"
  },
  TwelvePvpUseItemCmd = {
    id = 110081,
    req = "Cmd.TwelvePvpUseItemCmd",
    ack = "Cmd.TwelvePvpUseItemCmd",
    from = "FuBenCmd"
  },
  RaidShopUpdateCmd = {
    id = 110075,
    req = "Cmd.RaidShopUpdateCmd",
    ack = "Cmd.RaidShopUpdateCmd",
    from = "FuBenCmd"
  },
  TwelvePvpQuestQueryCmd = {
    id = 110076,
    req = "Cmd.TwelvePvpQuestQueryCmd",
    ack = "Cmd.TwelvePvpQuestQueryCmd",
    from = "FuBenCmd"
  },
  TwelvePvpQueryGroupInfoCmd = {
    id = 110077,
    req = "Cmd.TwelvePvpQueryGroupInfoCmd",
    ack = "Cmd.TwelvePvpQueryGroupInfoCmd",
    from = "FuBenCmd"
  },
  TwelvePvpResultCmd = {
    id = 110078,
    req = "Cmd.TwelvePvpResultCmd",
    ack = "Cmd.TwelvePvpResultCmd",
    from = "FuBenCmd"
  },
  TwelvePvpBuildingHpUpdateCmd = {
    id = 110079,
    req = "Cmd.TwelvePvpBuildingHpUpdateCmd",
    ack = "Cmd.TwelvePvpBuildingHpUpdateCmd",
    from = "FuBenCmd"
  },
  TwelvePvpUIOperCmd = {
    id = 110080,
    req = "Cmd.TwelvePvpUIOperCmd",
    ack = "Cmd.TwelvePvpUIOperCmd",
    from = "FuBenCmd"
  },
  ReliveCdFubenCmd = {
    id = 110086,
    req = "Cmd.ReliveCdFubenCmd",
    ack = "Cmd.ReliveCdFubenCmd",
    from = "FuBenCmd"
  },
  PosSyncFubenCmd = {
    id = 110087,
    req = "Cmd.PosSyncFubenCmd",
    ack = "Cmd.PosSyncFubenCmd",
    from = "FuBenCmd"
  },
  ReqEnterTowerPrivate = {
    id = 110088,
    req = "Cmd.ReqEnterTowerPrivate",
    ack = "Cmd.ReqEnterTowerPrivate",
    from = "FuBenCmd"
  },
  TowerPrivateLayerInfo = {
    id = 110089,
    req = "Cmd.TowerPrivateLayerInfo",
    ack = "Cmd.TowerPrivateLayerInfo",
    from = "FuBenCmd"
  },
  TowerPrivateLayerCountdownNtf = {
    id = 110090,
    req = "Cmd.TowerPrivateLayerCountdownNtf",
    ack = "Cmd.TowerPrivateLayerCountdownNtf",
    from = "FuBenCmd"
  },
  FubenResultNtf = {
    id = 110091,
    req = "Cmd.FubenResultNtf",
    ack = "Cmd.FubenResultNtf",
    from = "FuBenCmd"
  },
  EndTimeSyncFubenCmd = {
    id = 110092,
    req = "Cmd.EndTimeSyncFubenCmd",
    ack = "Cmd.EndTimeSyncFubenCmd",
    from = "FuBenCmd"
  },
  ResultSyncFubenCmd = {
    id = 110093,
    req = "Cmd.ResultSyncFubenCmd",
    ack = "Cmd.ResultSyncFubenCmd",
    from = "FuBenCmd"
  },
  ComodoPhaseFubenCmd = {
    id = 110097,
    req = "Cmd.ComodoPhaseFubenCmd",
    ack = "Cmd.ComodoPhaseFubenCmd",
    from = "FuBenCmd"
  },
  QueryComodoTeamRaidStat = {
    id = 110098,
    req = "Cmd.QueryComodoTeamRaidStat",
    ack = "Cmd.QueryComodoTeamRaidStat",
    from = "FuBenCmd"
  },
  TeamPwsStateSyncFubenCmd = {
    id = 110099,
    req = "Cmd.TeamPwsStateSyncFubenCmd",
    ack = "Cmd.TeamPwsStateSyncFubenCmd",
    from = "FuBenCmd"
  },
  ObserverFlashFubenCmd = {
    id = 110100,
    req = "Cmd.ObserverFlashFubenCmd",
    ack = "Cmd.ObserverFlashFubenCmd",
    from = "FuBenCmd"
  },
  ObserverAttachFubenCmd = {
    id = 110101,
    req = "Cmd.ObserverAttachFubenCmd",
    ack = "Cmd.ObserverAttachFubenCmd",
    from = "FuBenCmd"
  },
  ObserverSelectFubenCmd = {
    id = 110102,
    req = "Cmd.ObserverSelectFubenCmd",
    ack = "Cmd.ObserverSelectFubenCmd",
    from = "FuBenCmd"
  },
  ObHpspUpdateFubenCmd = {
    id = 110104,
    req = "Cmd.ObHpspUpdateFubenCmd",
    ack = "Cmd.ObHpspUpdateFubenCmd",
    from = "FuBenCmd"
  },
  ObPlayerOfflineFubenCmd = {
    id = 110105,
    req = "Cmd.ObPlayerOfflineFubenCmd",
    ack = "Cmd.ObPlayerOfflineFubenCmd",
    from = "FuBenCmd"
  },
  MultiBossPhaseFubenCmd = {
    id = 110106,
    req = "Cmd.MultiBossPhaseFubenCmd",
    ack = "Cmd.MultiBossPhaseFubenCmd",
    from = "FuBenCmd"
  },
  QueryMultiBossRaidStat = {
    id = 110107,
    req = "Cmd.QueryMultiBossRaidStat",
    ack = "Cmd.QueryMultiBossRaidStat",
    from = "FuBenCmd"
  },
  PvePassShowReward = {
    id = 1,
    req = "Cmd.PvePassShowReward",
    ack = "Cmd.PvePassShowReward",
    from = "FuBenCmd"
  },
  ObMoveCameraPrepareCmd = {
    id = 110108,
    req = "Cmd.ObMoveCameraPrepareCmd",
    ack = "Cmd.ObMoveCameraPrepareCmd",
    from = "FuBenCmd"
  },
  ObCameraMoveEndCmd = {
    id = 110109,
    req = "Cmd.ObCameraMoveEndCmd",
    ack = "Cmd.ObCameraMoveEndCmd",
    from = "FuBenCmd"
  },
  RaidKillNumSyncCmd = {
    id = 110110,
    req = "Cmd.RaidKillNumSyncCmd",
    ack = "Cmd.RaidKillNumSyncCmd",
    from = "FuBenCmd"
  },
  SyncPvePassInfoFubenCmd = {
    id = 110118,
    req = "Cmd.SyncPvePassInfoFubenCmd",
    ack = "Cmd.SyncPvePassInfoFubenCmd",
    from = "FuBenCmd"
  },
  SyncPveRaidAchieveFubenCmd = {
    id = 110126,
    req = "Cmd.SyncPveRaidAchieveFubenCmd",
    ack = "Cmd.SyncPveRaidAchieveFubenCmd",
    from = "FuBenCmd"
  },
  QuickFinishCrackRaidFubenCmd = {
    id = 110127,
    req = "Cmd.QuickFinishCrackRaidFubenCmd",
    ack = "Cmd.QuickFinishCrackRaidFubenCmd",
    from = "FuBenCmd"
  },
  PickupPveRaidAchieveFubenCmd = {
    id = 110128,
    req = "Cmd.PickupPveRaidAchieveFubenCmd",
    ack = "Cmd.PickupPveRaidAchieveFubenCmd",
    from = "FuBenCmd"
  },
  GvgPointUpdateFubenCmd = {
    id = 110119,
    req = "Cmd.GvgPointUpdateFubenCmd",
    ack = "Cmd.GvgPointUpdateFubenCmd",
    from = "FuBenCmd"
  },
  GvgRaidStateUpdateFubenCmd = {
    id = 110122,
    req = "Cmd.GvgRaidStateUpdateFubenCmd",
    ack = "Cmd.GvgRaidStateUpdateFubenCmd",
    from = "FuBenCmd"
  },
  AddPveCardTimesFubenCmd = {
    id = 110129,
    req = "Cmd.AddPveCardTimesFubenCmd",
    ack = "Cmd.AddPveCardTimesFubenCmd",
    from = "FuBenCmd"
  },
  SyncPveCardOpenStateFubenCmd = {
    id = 110130,
    req = "Cmd.SyncPveCardOpenStateFubenCmd",
    ack = "Cmd.SyncPveCardOpenStateFubenCmd",
    from = "FuBenCmd"
  },
  QuickFinishPveRaidFubenCmd = {
    id = 110131,
    req = "Cmd.QuickFinishPveRaidFubenCmd",
    ack = "Cmd.QuickFinishPveRaidFubenCmd",
    from = "FuBenCmd"
  },
  SyncPveCardRewardTimesFubenCmd = {
    id = 110132,
    req = "Cmd.SyncPveCardRewardTimesFubenCmd",
    ack = "Cmd.SyncPveCardRewardTimesFubenCmd",
    from = "FuBenCmd"
  },
  GvgPerfectStateUpdateFubenCmd = {
    id = 110133,
    req = "Cmd.GvgPerfectStateUpdateFubenCmd",
    ack = "Cmd.GvgPerfectStateUpdateFubenCmd",
    from = "FuBenCmd"
  },
  QueryElementRaidStat = {
    id = 110136,
    req = "Cmd.QueryElementRaidStat",
    ack = "Cmd.QueryElementRaidStat",
    from = "FuBenCmd"
  },
  SyncEmotionFactorsFuBenCmd = {
    id = 110137,
    req = "Cmd.SyncEmotionFactorsFuBenCmd",
    ack = "Cmd.SyncEmotionFactorsFuBenCmd",
    from = "FuBenCmd"
  },
  SyncBossSceneInfo = {
    id = 110134,
    req = "Cmd.SyncBossSceneInfo",
    ack = "Cmd.SyncBossSceneInfo",
    from = "FuBenCmd"
  },
  SyncUnlockRoomIDsFuBenCmd = {
    id = 110139,
    req = "Cmd.SyncUnlockRoomIDsFuBenCmd",
    ack = "Cmd.SyncUnlockRoomIDsFuBenCmd",
    from = "FuBenCmd"
  },
  SyncVisitNpcInfo = {
    id = 110138,
    req = "Cmd.SyncVisitNpcInfo",
    ack = "Cmd.SyncVisitNpcInfo",
    from = "FuBenCmd"
  },
  SyncMonsterCountFuBenCmd = {
    id = 110140,
    req = "Cmd.SyncMonsterCountFuBenCmd",
    ack = "Cmd.SyncMonsterCountFuBenCmd",
    from = "FuBenCmd"
  },
  SkipAnimationFuBenCmd = {
    id = 110141,
    req = "Cmd.SkipAnimationFuBenCmd",
    ack = "Cmd.SkipAnimationFuBenCmd",
    from = "FuBenCmd"
  },
  ResetRaidFubenCmd = {
    id = 110135,
    req = "Cmd.ResetRaidFubenCmd",
    ack = "Cmd.ResetRaidFubenCmd",
    from = "FuBenCmd"
  },
  SyncStarArkInfoFuBenCmd = {
    id = 110142,
    req = "Cmd.SyncStarArkInfoFuBenCmd",
    ack = "Cmd.SyncStarArkInfoFuBenCmd",
    from = "FuBenCmd"
  },
  SyncStarArkStatisticsFuBenCmd = {
    id = 110143,
    req = "Cmd.SyncStarArkStatisticsFuBenCmd",
    ack = "Cmd.SyncStarArkStatisticsFuBenCmd",
    from = "FuBenCmd"
  },
  OpenNtfFuBenCmd = {
    id = 110144,
    req = "Cmd.OpenNtfFuBenCmd",
    ack = "Cmd.OpenNtfFuBenCmd",
    from = "FuBenCmd"
  },
  RoadblocksChangeFubenCmd = {
    id = 110145,
    req = "Cmd.RoadblocksChangeFubenCmd",
    ack = "Cmd.RoadblocksChangeFubenCmd",
    from = "FuBenCmd"
  },
  SyncPassUserInfo = {
    id = 110152,
    req = "Cmd.SyncPassUserInfo",
    ack = "Cmd.SyncPassUserInfo",
    from = "FuBenCmd"
  },
  SyncTripleFireInfoFuBenCmd = {
    id = 110146,
    req = "Cmd.SyncTripleFireInfoFuBenCmd",
    ack = "Cmd.SyncTripleFireInfoFuBenCmd",
    from = "FuBenCmd"
  },
  SyncTripleComboKillFuBenCmd = {
    id = 110147,
    req = "Cmd.SyncTripleComboKillFuBenCmd",
    ack = "Cmd.SyncTripleComboKillFuBenCmd",
    from = "FuBenCmd"
  },
  SyncTriplePlayerModelFuBenCmd = {
    id = 110148,
    req = "Cmd.SyncTriplePlayerModelFuBenCmd",
    ack = "Cmd.SyncTriplePlayerModelFuBenCmd",
    from = "FuBenCmd"
  },
  SyncTripleProfessionTimeFuBenCmd = {
    id = 110149,
    req = "Cmd.SyncTripleProfessionTimeFuBenCmd",
    ack = "Cmd.SyncTripleProfessionTimeFuBenCmd",
    from = "FuBenCmd"
  },
  SyncTripleCampInfoFuBenCmd = {
    id = 110150,
    req = "Cmd.SyncTripleCampInfoFuBenCmd",
    ack = "Cmd.SyncTripleCampInfoFuBenCmd",
    from = "FuBenCmd"
  },
  SyncTripleEnterCountFuBenCmd = {
    id = 110151,
    req = "Cmd.SyncTripleEnterCountFuBenCmd",
    ack = "Cmd.SyncTripleEnterCountFuBenCmd",
    from = "FuBenCmd"
  },
  ChooseCurProfessionFuBenCmd = {
    id = 110153,
    req = "Cmd.ChooseCurProfessionFuBenCmd",
    ack = "Cmd.ChooseCurProfessionFuBenCmd",
    from = "FuBenCmd"
  },
  SyncTripleFightingInfoFuBenCmd = {
    id = 110154,
    req = "Cmd.SyncTripleFightingInfoFuBenCmd",
    ack = "Cmd.SyncTripleFightingInfoFuBenCmd",
    from = "FuBenCmd"
  },
  SyncFullFireStateFubenCmd = {
    id = 110155,
    req = "Cmd.SyncFullFireStateFubenCmd",
    ack = "Cmd.SyncFullFireStateFubenCmd",
    from = "FuBenCmd"
  },
  EBFEventDataUpdateCmd = {
    id = 110156,
    req = "Cmd.EBFEventDataUpdateCmd",
    ack = "Cmd.EBFEventDataUpdateCmd",
    from = "FuBenCmd"
  },
  EBFMiscDataUpdate = {
    id = 110157,
    req = "Cmd.EBFMiscDataUpdate",
    ack = "Cmd.EBFMiscDataUpdate",
    from = "FuBenCmd"
  },
  OccupyPointDataUpdate = {
    id = 110158,
    req = "Cmd.OccupyPointDataUpdate",
    ack = "Cmd.OccupyPointDataUpdate",
    from = "FuBenCmd"
  },
  QueryPvpStatCmd = {
    id = 110159,
    req = "Cmd.QueryPvpStatCmd",
    ack = "Cmd.QueryPvpStatCmd",
    from = "FuBenCmd"
  },
  EBFKickTimeCmd = {
    id = 110160,
    req = "Cmd.EBFKickTimeCmd",
    ack = "Cmd.EBFKickTimeCmd",
    from = "FuBenCmd"
  },
  EBFContinueCmd = {
    id = 110161,
    req = "Cmd.EBFContinueCmd",
    ack = "Cmd.EBFContinueCmd",
    from = "FuBenCmd"
  },
  EBFEventAreaUpdateCmd = {
    id = 110162,
    req = "Cmd.EBFEventAreaUpdateCmd",
    ack = "Cmd.EBFEventAreaUpdateCmd",
    from = "FuBenCmd"
  },
  AstralInfoSyncCmd = {
    id = 110163,
    req = "Cmd.AstralInfoSyncCmd",
    ack = "Cmd.AstralInfoSyncCmd",
    from = "FuBenCmd"
  },
  GvgMvpInfoUpdateCmd = {
    id = 110164,
    req = "Cmd.GvgMvpInfoUpdateCmd",
    ack = "Cmd.GvgMvpInfoUpdateCmd",
    from = "FuBenCmd"
  },
  AstralPrayBranchSyncCmd = {
    id = 110165,
    req = "Cmd.AstralPrayBranchSyncCmd",
    ack = "Cmd.AstralPrayBranchSyncCmd",
    from = "FuBenCmd"
  },
  SyncStartFightStateCmd = {
    id = 110166,
    req = "Cmd.SyncStartFightStateCmd",
    ack = "Cmd.SyncStartFightStateCmd",
    from = "FuBenCmd"
  },
  SyncGvgFightPointCmd = {
    id = 110167,
    req = "Cmd.SyncGvgFightPointCmd",
    ack = "Cmd.SyncGvgFightPointCmd",
    from = "FuBenCmd"
  },
  SyncGvgLeaderPosCmd = {
    id = 110168,
    req = "Cmd.SyncGvgLeaderPosCmd",
    ack = "Cmd.SyncGvgLeaderPosCmd",
    from = "FuBenCmd"
  },
  STISyncScoreCmd = {
    id = 110169,
    req = "Cmd.STISyncScoreCmd",
    ack = "Cmd.STISyncScoreCmd",
    from = "FuBenCmd"
  },
  STISyncSkillCmd = {
    id = 110170,
    req = "Cmd.STISyncSkillCmd",
    ack = "Cmd.STISyncSkillCmd",
    from = "FuBenCmd"
  },
  STISyncAvailableUpgradeNumberCmd = {
    id = 110171,
    req = "Cmd.STISyncAvailableUpgradeNumberCmd",
    ack = "Cmd.STISyncAvailableUpgradeNumberCmd",
    from = "FuBenCmd"
  },
  STIGetUpgradeOptionsCmd = {
    id = 110172,
    req = "Cmd.STIGetUpgradeOptionsCmd",
    ack = "Cmd.STIGetUpgradeOptionsCmd",
    from = "FuBenCmd"
  },
  STIRetUpgradeOptionsCmd = {
    id = 110173,
    req = "Cmd.STIRetUpgradeOptionsCmd",
    ack = "Cmd.STIRetUpgradeOptionsCmd",
    from = "FuBenCmd"
  },
  STIExecSkillUpgradeCmd = {
    id = 110174,
    req = "Cmd.STIExecSkillUpgradeCmd",
    ack = "Cmd.STIExecSkillUpgradeCmd",
    from = "FuBenCmd"
  },
  SyncSpaceTimeIllusionInfoFuBenCmd = {
    id = 110175,
    req = "Cmd.SyncSpaceTimeIllusionInfoFuBenCmd",
    ack = "Cmd.SyncSpaceTimeIllusionInfoFuBenCmd",
    from = "FuBenCmd"
  },
  SyncSpaceTimeIllusionExpLevelFuBenCmd = {
    id = 110176,
    req = "Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd",
    ack = "Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd",
    from = "FuBenCmd"
  },
  STIRefreshUpgradeOptionsCmd = {
    id = 110177,
    req = "Cmd.STIRefreshUpgradeOptionsCmd",
    ack = "Cmd.STIRefreshUpgradeOptionsCmd",
    from = "FuBenCmd"
  },
  STIDropSkillCmd = {
    id = 110178,
    req = "Cmd.STIDropSkillCmd",
    ack = "Cmd.STIDropSkillCmd",
    from = "FuBenCmd"
  },
  FairyTaleRaidSyncCmd = {
    id = 110179,
    req = "Cmd.FairyTaleRaidSyncCmd",
    ack = "Cmd.FairyTaleRaidSyncCmd",
    from = "FuBenCmd"
  },
  RaidStartFightCmd = {
    id = 110180,
    req = "Cmd.RaidStartFightCmd",
    ack = "Cmd.RaidStartFightCmd",
    from = "FuBenCmd"
  },
  FairyTaleRaidRewardSyncCmd = {
    id = 110182,
    req = "Cmd.FairyTaleRaidRewardSyncCmd",
    ack = "Cmd.FairyTaleRaidRewardSyncCmd",
    from = "FuBenCmd"
  },
  FairyTaleRaidGetRewardCmd = {
    id = 110183,
    req = "Cmd.FairyTaleRaidGetRewardCmd",
    ack = "Cmd.FairyTaleRaidGetRewardCmd",
    from = "FuBenCmd"
  },
  SyncMemoryEquipRewardInfo = {
    id = 110184,
    req = "Cmd.SyncMemoryEquipRewardInfo",
    ack = "Cmd.SyncMemoryEquipRewardInfo",
    from = "FuBenCmd"
  },
  ChooseMemoryEquipRewardInfo = {
    id = 110185,
    req = "Cmd.ChooseMemoryEquipRewardInfo",
    ack = "Cmd.ChooseMemoryEquipRewardInfo",
    from = "FuBenCmd"
  },
  GvgDateBattleInfoSyncCmd = {
    id = 110181,
    req = "Cmd.GvgDateBattleInfoSyncCmd",
    ack = "Cmd.GvgDateBattleInfoSyncCmd",
    from = "FuBenCmd"
  },
  QueryGuildListGuildCmd = {
    id = 500001,
    req = "Cmd.QueryGuildListGuildCmd",
    ack = "Cmd.QueryGuildListGuildCmd",
    from = "GuildCmd"
  },
  CreateGuildGuildCmd = {
    id = 500002,
    req = "Cmd.CreateGuildGuildCmd",
    ack = "Cmd.CreateGuildGuildCmd",
    from = "GuildCmd"
  },
  EnterGuildGuildCmd = {
    id = 500003,
    req = "Cmd.EnterGuildGuildCmd",
    ack = "Cmd.EnterGuildGuildCmd",
    from = "GuildCmd"
  },
  GuildMemberUpdateGuildCmd = {
    id = 500004,
    req = "Cmd.GuildMemberUpdateGuildCmd",
    ack = "Cmd.GuildMemberUpdateGuildCmd",
    from = "GuildCmd"
  },
  GuildApplyUpdateGuildCmd = {
    id = 500005,
    req = "Cmd.GuildApplyUpdateGuildCmd",
    ack = "Cmd.GuildApplyUpdateGuildCmd",
    from = "GuildCmd"
  },
  GuildDataUpdateGuildCmd = {
    id = 500006,
    req = "Cmd.GuildDataUpdateGuildCmd",
    ack = "Cmd.GuildDataUpdateGuildCmd",
    from = "GuildCmd"
  },
  GuildMemberDataUpdateGuildCmd = {
    id = 500007,
    req = "Cmd.GuildMemberDataUpdateGuildCmd",
    ack = "Cmd.GuildMemberDataUpdateGuildCmd",
    from = "GuildCmd"
  },
  ApplyGuildGuildCmd = {
    id = 500008,
    req = "Cmd.ApplyGuildGuildCmd",
    ack = "Cmd.ApplyGuildGuildCmd",
    from = "GuildCmd"
  },
  ProcessApplyGuildCmd = {
    id = 500009,
    req = "Cmd.ProcessApplyGuildCmd",
    ack = "Cmd.ProcessApplyGuildCmd",
    from = "GuildCmd"
  },
  InviteMemberGuildCmd = {
    id = 500010,
    req = "Cmd.InviteMemberGuildCmd",
    ack = "Cmd.InviteMemberGuildCmd",
    from = "GuildCmd"
  },
  ProcessInviteGuildCmd = {
    id = 500011,
    req = "Cmd.ProcessInviteGuildCmd",
    ack = "Cmd.ProcessInviteGuildCmd",
    from = "GuildCmd"
  },
  SetGuildOptionGuildCmd = {
    id = 500012,
    req = "Cmd.SetGuildOptionGuildCmd",
    ack = "Cmd.SetGuildOptionGuildCmd",
    from = "GuildCmd"
  },
  KickMemberGuildCmd = {
    id = 500013,
    req = "Cmd.KickMemberGuildCmd",
    ack = "Cmd.KickMemberGuildCmd",
    from = "GuildCmd"
  },
  ChangeJobGuildCmd = {
    id = 500014,
    req = "Cmd.ChangeJobGuildCmd",
    ack = "Cmd.ChangeJobGuildCmd",
    from = "GuildCmd"
  },
  ExitGuildGuildCmd = {
    id = 500015,
    req = "Cmd.ExitGuildGuildCmd",
    ack = "Cmd.ExitGuildGuildCmd",
    from = "GuildCmd"
  },
  ExchangeChairGuildCmd = {
    id = 500016,
    req = "Cmd.ExchangeChairGuildCmd",
    ack = "Cmd.ExchangeChairGuildCmd",
    from = "GuildCmd"
  },
  DismissGuildCmd = {
    id = 500017,
    req = "Cmd.DismissGuildCmd",
    ack = "Cmd.DismissGuildCmd",
    from = "GuildCmd"
  },
  LevelupGuildCmd = {
    id = 500018,
    req = "Cmd.LevelupGuildCmd",
    ack = "Cmd.LevelupGuildCmd",
    from = "GuildCmd"
  },
  DonateGuildCmd = {
    id = 500019,
    req = "Cmd.DonateGuildCmd",
    ack = "Cmd.DonateGuildCmd",
    from = "GuildCmd"
  },
  DonateListGuildCmd = {
    id = 500025,
    req = "Cmd.DonateListGuildCmd",
    ack = "Cmd.DonateListGuildCmd",
    from = "GuildCmd"
  },
  UpdateDonateItemGuildCmd = {
    id = 500026,
    req = "Cmd.UpdateDonateItemGuildCmd",
    ack = "Cmd.UpdateDonateItemGuildCmd",
    from = "GuildCmd"
  },
  DonateFrameGuildCmd = {
    id = 500027,
    req = "Cmd.DonateFrameGuildCmd",
    ack = "Cmd.DonateFrameGuildCmd",
    from = "GuildCmd"
  },
  EnterTerritoryGuildCmd = {
    id = 500020,
    req = "Cmd.EnterTerritoryGuildCmd",
    ack = "Cmd.EnterTerritoryGuildCmd",
    from = "GuildCmd"
  },
  PrayGuildCmd = {
    id = 500021,
    req = "Cmd.PrayGuildCmd",
    ack = "Cmd.PrayGuildCmd",
    from = "GuildCmd"
  },
  GuildInfoNtf = {
    id = 500022,
    req = "Cmd.GuildInfoNtf",
    ack = "Cmd.GuildInfoNtf",
    from = "GuildCmd"
  },
  GuildPrayNtfGuildCmd = {
    id = 500023,
    req = "Cmd.GuildPrayNtfGuildCmd",
    ack = "Cmd.GuildPrayNtfGuildCmd",
    from = "GuildCmd"
  },
  LevelupEffectGuildCmd = {
    id = 500024,
    req = "Cmd.LevelupEffectGuildCmd",
    ack = "Cmd.LevelupEffectGuildCmd",
    from = "GuildCmd"
  },
  QueryPackGuildCmd = {
    id = 500028,
    req = "Cmd.QueryPackGuildCmd",
    ack = "Cmd.QueryPackGuildCmd",
    from = "GuildCmd"
  },
  PackUpdateGuildCmd = {
    id = 500032,
    req = "Cmd.PackUpdateGuildCmd",
    ack = "Cmd.PackUpdateGuildCmd",
    from = "GuildCmd"
  },
  ExchangeZoneGuildCmd = {
    id = 500029,
    req = "Cmd.ExchangeZoneGuildCmd",
    ack = "Cmd.ExchangeZoneGuildCmd",
    from = "GuildCmd"
  },
  ExchangeZoneNtfGuildCmd = {
    id = 500030,
    req = "Cmd.ExchangeZoneNtfGuildCmd",
    ack = "Cmd.ExchangeZoneNtfGuildCmd",
    from = "GuildCmd"
  },
  ExchangeZoneAnswerGuildCmd = {
    id = 500031,
    req = "Cmd.ExchangeZoneAnswerGuildCmd",
    ack = "Cmd.ExchangeZoneAnswerGuildCmd",
    from = "GuildCmd"
  },
  QueryEventListGuildCmd = {
    id = 500033,
    req = "Cmd.QueryEventListGuildCmd",
    ack = "Cmd.QueryEventListGuildCmd",
    from = "GuildCmd"
  },
  NewEventGuildCmd = {
    id = 500034,
    req = "Cmd.NewEventGuildCmd",
    ack = "Cmd.NewEventGuildCmd",
    from = "GuildCmd"
  },
  FrameStatusGuildCmd = {
    id = 500037,
    req = "Cmd.FrameStatusGuildCmd",
    ack = "Cmd.FrameStatusGuildCmd",
    from = "GuildCmd"
  },
  ModifyAuthGuildCmd = {
    id = 500038,
    req = "Cmd.ModifyAuthGuildCmd",
    ack = "Cmd.ModifyAuthGuildCmd",
    from = "GuildCmd"
  },
  JobUpdateGuildCmd = {
    id = 500039,
    req = "Cmd.JobUpdateGuildCmd",
    ack = "Cmd.JobUpdateGuildCmd",
    from = "GuildCmd"
  },
  RenameQueryGuildCmd = {
    id = 500040,
    req = "Cmd.RenameQueryGuildCmd",
    ack = "Cmd.RenameQueryGuildCmd",
    from = "GuildCmd"
  },
  QueryGuildCityInfoGuildCmd = {
    id = 500041,
    req = "Cmd.QueryGuildCityInfoGuildCmd",
    ack = "Cmd.QueryGuildCityInfoGuildCmd",
    from = "GuildCmd"
  },
  CityActionGuildCmd = {
    id = 500042,
    req = "Cmd.CityActionGuildCmd",
    ack = "Cmd.CityActionGuildCmd",
    from = "GuildCmd"
  },
  GuildIconSyncGuildCmd = {
    id = 500043,
    req = "Cmd.GuildIconSyncGuildCmd",
    ack = "Cmd.GuildIconSyncGuildCmd",
    from = "GuildCmd"
  },
  GuildIconAddGuildCmd = {
    id = 500044,
    req = "Cmd.GuildIconAddGuildCmd",
    ack = "Cmd.GuildIconAddGuildCmd",
    from = "GuildCmd"
  },
  GuildIconUploadGuildCmd = {
    id = 500045,
    req = "Cmd.GuildIconUploadGuildCmd",
    ack = "Cmd.GuildIconUploadGuildCmd",
    from = "GuildCmd"
  },
  OpenFunctionGuildCmd = {
    id = 500047,
    req = "Cmd.OpenFunctionGuildCmd",
    ack = "Cmd.OpenFunctionGuildCmd",
    from = "GuildCmd"
  },
  BuildGuildCmd = {
    id = 500048,
    req = "Cmd.BuildGuildCmd",
    ack = "Cmd.BuildGuildCmd",
    from = "GuildCmd"
  },
  SubmitMaterialGuildCmd = {
    id = 500049,
    req = "Cmd.SubmitMaterialGuildCmd",
    ack = "Cmd.SubmitMaterialGuildCmd",
    from = "GuildCmd"
  },
  BuildingNtfGuildCmd = {
    id = 500050,
    req = "Cmd.BuildingNtfGuildCmd",
    ack = "Cmd.BuildingNtfGuildCmd",
    from = "GuildCmd"
  },
  BuildingSubmitCountGuildCmd = {
    id = 500051,
    req = "Cmd.BuildingSubmitCountGuildCmd",
    ack = "Cmd.BuildingSubmitCountGuildCmd",
    from = "GuildCmd"
  },
  ChallengeUpdateNtfGuildCmd = {
    id = 500052,
    req = "Cmd.ChallengeUpdateNtfGuildCmd",
    ack = "Cmd.ChallengeUpdateNtfGuildCmd",
    from = "GuildCmd"
  },
  WelfareNtfGuildCmd = {
    id = 500053,
    req = "Cmd.WelfareNtfGuildCmd",
    ack = "Cmd.WelfareNtfGuildCmd",
    from = "GuildCmd"
  },
  GetWelfareGuildCmd = {
    id = 500054,
    req = "Cmd.GetWelfareGuildCmd",
    ack = "Cmd.GetWelfareGuildCmd",
    from = "GuildCmd"
  },
  BuildingLvupEffGuildCmd = {
    id = 500055,
    req = "Cmd.BuildingLvupEffGuildCmd",
    ack = "Cmd.BuildingLvupEffGuildCmd",
    from = "GuildCmd"
  },
  ArtifactUpdateNtfGuildCmd = {
    id = 500056,
    req = "Cmd.ArtifactUpdateNtfGuildCmd",
    ack = "Cmd.ArtifactUpdateNtfGuildCmd",
    from = "GuildCmd"
  },
  ArtifactProduceGuildCmd = {
    id = 500057,
    req = "Cmd.ArtifactProduceGuildCmd",
    ack = "Cmd.ArtifactProduceGuildCmd",
    from = "GuildCmd"
  },
  ArtifactOptGuildCmd = {
    id = 500058,
    req = "Cmd.ArtifactOptGuildCmd",
    ack = "Cmd.ArtifactOptGuildCmd",
    from = "GuildCmd"
  },
  QueryGQuestGuildCmd = {
    id = 500059,
    req = "Cmd.QueryGQuestGuildCmd",
    ack = "Cmd.QueryGQuestGuildCmd",
    from = "GuildCmd"
  },
  TreasureActionGuildCmd = {
    id = 500060,
    req = "Cmd.TreasureActionGuildCmd",
    ack = "Cmd.TreasureActionGuildCmd",
    from = "GuildCmd"
  },
  QueryBuildingRankGuildCmd = {
    id = 500061,
    req = "Cmd.QueryBuildingRankGuildCmd",
    ack = "Cmd.QueryBuildingRankGuildCmd",
    from = "GuildCmd"
  },
  QueryTreasureResultGuildCmd = {
    id = 500062,
    req = "Cmd.QueryTreasureResultGuildCmd",
    ack = "Cmd.QueryTreasureResultGuildCmd",
    from = "GuildCmd"
  },
  QueryGCityShowInfoGuildCmd = {
    id = 500063,
    req = "Cmd.QueryGCityShowInfoGuildCmd",
    ack = "Cmd.QueryGCityShowInfoGuildCmd",
    from = "GuildCmd"
  },
  GvgOpenFireGuildCmd = {
    id = 500064,
    req = "Cmd.GvgOpenFireGuildCmd",
    ack = "Cmd.GvgOpenFireGuildCmd",
    from = "GuildCmd"
  },
  EnterPunishTimeNtfGuildCmd = {
    id = 500066,
    req = "Cmd.EnterPunishTimeNtfGuildCmd",
    ack = "Cmd.EnterPunishTimeNtfGuildCmd",
    from = "GuildCmd"
  },
  QuerySuperGvgDataGuildCmd = {
    id = 500067,
    req = "Cmd.QuerySuperGvgDataGuildCmd",
    ack = "Cmd.QuerySuperGvgDataGuildCmd",
    from = "GuildCmd"
  },
  QueryGvgGuildInfoGuildCmd = {
    id = 500068,
    req = "Cmd.QueryGvgGuildInfoGuildCmd",
    ack = "Cmd.QueryGvgGuildInfoGuildCmd",
    from = "GuildCmd"
  },
  GvgRewardNtfGuildCmd = {
    id = 500069,
    req = "Cmd.GvgRewardNtfGuildCmd",
    ack = "Cmd.GvgRewardNtfGuildCmd",
    from = "GuildCmd"
  },
  GetGvgRewardGuildCmd = {
    id = 500070,
    req = "Cmd.GetGvgRewardGuildCmd",
    ack = "Cmd.GetGvgRewardGuildCmd",
    from = "GuildCmd"
  },
  QueryCheckInfoGuildCmd = {
    id = 500071,
    req = "Cmd.QueryCheckInfoGuildCmd",
    ack = "Cmd.QueryCheckInfoGuildCmd",
    from = "GuildCmd"
  },
  QueryBifrostRankGuildCmd = {
    id = 500072,
    req = "Cmd.QueryBifrostRankGuildCmd",
    ack = "Cmd.QueryBifrostRankGuildCmd",
    from = "GuildCmd"
  },
  QueryMemberBifrostInfoGuildCmd = {
    id = 500073,
    req = "Cmd.QueryMemberBifrostInfoGuildCmd",
    ack = "Cmd.QueryMemberBifrostInfoGuildCmd",
    from = "GuildCmd"
  },
  QueryGuildInfoGuildCmd = {
    id = 500074,
    req = "Cmd.QueryGuildInfoGuildCmd",
    ack = "Cmd.QueryGuildInfoGuildCmd",
    from = "GuildCmd"
  },
  QueryGvgZoneGroupGuildCCmd = {
    id = 500075,
    req = "Cmd.QueryGvgZoneGroupGuildCCmd",
    ack = "Cmd.QueryGvgZoneGroupGuildCCmd",
    from = "GuildCmd"
  },
  UpdateMapCityGuildCmd = {
    id = 500076,
    req = "Cmd.UpdateMapCityGuildCmd",
    ack = "Cmd.UpdateMapCityGuildCmd",
    from = "GuildCmd"
  },
  GvgRankInfoQueryGuildCmd = {
    id = 500077,
    req = "Cmd.GvgRankInfoQueryGuildCmd",
    ack = "Cmd.GvgRankInfoQueryGuildCmd",
    from = "GuildCmd"
  },
  GvgRankInfoRetGuildCmd = {
    id = 500078,
    req = "Cmd.GvgRankInfoRetGuildCmd",
    ack = "Cmd.GvgRankInfoRetGuildCmd",
    from = "GuildCmd"
  },
  GvgRankHistroyQueryGuildCmd = {
    id = 500079,
    req = "Cmd.GvgRankHistroyQueryGuildCmd",
    ack = "Cmd.GvgRankHistroyQueryGuildCmd",
    from = "GuildCmd"
  },
  GvgRankHistroyRetGuildCmd = {
    id = 500080,
    req = "Cmd.GvgRankHistroyRetGuildCmd",
    ack = "Cmd.GvgRankHistroyRetGuildCmd",
    from = "GuildCmd"
  },
  GvgSmallMetalCntGuildCmd = {
    id = 500081,
    req = "Cmd.GvgSmallMetalCntGuildCmd",
    ack = "Cmd.GvgSmallMetalCntGuildCmd",
    from = "GuildCmd"
  },
  GvgTaskUpdateGuildCmd = {
    id = 500084,
    req = "Cmd.GvgTaskUpdateGuildCmd",
    ack = "Cmd.GvgTaskUpdateGuildCmd",
    from = "GuildCmd"
  },
  GvgStatueSyncGuildCmd = {
    id = 500088,
    req = "Cmd.GvgStatueSyncGuildCmd",
    ack = "Cmd.GvgStatueSyncGuildCmd",
    from = "GuildCmd"
  },
  GvgCookingCmd = {
    id = 500082,
    req = "Cmd.GvgCookingCmd",
    ack = "Cmd.GvgCookingCmd",
    from = "GuildCmd"
  },
  GvgCookingUpdateCmd = {
    id = 500083,
    req = "Cmd.GvgCookingUpdateCmd",
    ack = "Cmd.GvgCookingUpdateCmd",
    from = "GuildCmd"
  },
  GvgScoreInfoUpdateGuildCmd = {
    id = 500089,
    req = "Cmd.GvgScoreInfoUpdateGuildCmd",
    ack = "Cmd.GvgScoreInfoUpdateGuildCmd",
    from = "GuildCmd"
  },
  GvgSettleReqGuildCmd = {
    id = 500090,
    req = "Cmd.GvgSettleReqGuildCmd",
    ack = "Cmd.GvgSettleReqGuildCmd",
    from = "GuildCmd"
  },
  GvgSettleInfoGuildCmd = {
    id = 500091,
    req = "Cmd.GvgSettleInfoGuildCmd",
    ack = "Cmd.GvgSettleInfoGuildCmd",
    from = "GuildCmd"
  },
  GvgSettleSelectGuildCmd = {
    id = 500092,
    req = "Cmd.GvgSettleSelectGuildCmd",
    ack = "Cmd.GvgSettleSelectGuildCmd",
    from = "GuildCmd"
  },
  GvgReqEnterCityGuildCmd = {
    id = 500093,
    req = "Cmd.GvgReqEnterCityGuildCmd",
    ack = "Cmd.GvgReqEnterCityGuildCmd",
    from = "GuildCmd"
  },
  GvgFireReportGuildCmd = {
    id = 500094,
    req = "Cmd.GvgFireReportGuildCmd",
    ack = "Cmd.GvgFireReportGuildCmd",
    from = "GuildCmd"
  },
  BuildingUpdateNtfGuildCmd = {
    id = 500095,
    req = "Cmd.BuildingUpdateNtfGuildCmd",
    ack = "Cmd.BuildingUpdateNtfGuildCmd",
    from = "GuildCmd"
  },
  GvgRoadblockModifyGuildCmd = {
    id = 500096,
    req = "Cmd.GvgRoadblockModifyGuildCmd",
    ack = "Cmd.GvgRoadblockModifyGuildCmd",
    from = "GuildCmd"
  },
  GvgRoadblockQueryGuildCmd = {
    id = 500097,
    req = "Cmd.GvgRoadblockQueryGuildCmd",
    ack = "Cmd.GvgRoadblockQueryGuildCmd",
    from = "GuildCmd"
  },
  ExchangeGvgGroupGuildCmd = {
    id = 500098,
    req = "Cmd.ExchangeGvgGroupGuildCmd",
    ack = "Cmd.ExchangeGvgGroupGuildCmd",
    from = "GuildCmd"
  },
  GvgDataQueryGuildCmd = {
    id = 500112,
    req = "Cmd.GvgDataQueryGuildCmd",
    ack = "Cmd.GvgDataQueryGuildCmd",
    from = "GuildCmd"
  },
  DateBattleInfoGuildCmd = {
    id = 500099,
    req = "Cmd.DateBattleInfoGuildCmd",
    ack = "Cmd.DateBattleInfoGuildCmd",
    from = "GuildCmd"
  },
  DateBattleTargetGuildCmd = {
    id = 500100,
    req = "Cmd.DateBattleTargetGuildCmd",
    ack = "Cmd.DateBattleTargetGuildCmd",
    from = "GuildCmd"
  },
  DateBattleInviteGuildCmd = {
    id = 500101,
    req = "Cmd.DateBattleInviteGuildCmd",
    ack = "Cmd.DateBattleInviteGuildCmd",
    from = "GuildCmd"
  },
  DateBattleReplyGuildCmd = {
    id = 500102,
    req = "Cmd.DateBattleReplyGuildCmd",
    ack = "Cmd.DateBattleReplyGuildCmd",
    from = "GuildCmd"
  },
  DateBattleOpenGuildCmd = {
    id = 500103,
    req = "Cmd.DateBattleOpenGuildCmd",
    ack = "Cmd.DateBattleOpenGuildCmd",
    from = "GuildCmd"
  },
  DateBattleEnterGuildCmd = {
    id = 500104,
    req = "Cmd.DateBattleEnterGuildCmd",
    ack = "Cmd.DateBattleEnterGuildCmd",
    from = "GuildCmd"
  },
  DateBattleReportGuildCmd = {
    id = 500105,
    req = "Cmd.DateBattleReportGuildCmd",
    ack = "Cmd.DateBattleReportGuildCmd",
    from = "GuildCmd"
  },
  DateBattleDetailGuildCmd = {
    id = 500106,
    req = "Cmd.DateBattleDetailGuildCmd",
    ack = "Cmd.DateBattleDetailGuildCmd",
    from = "GuildCmd"
  },
  DateBattleListGuildCmd = {
    id = 500107,
    req = "Cmd.DateBattleListGuildCmd",
    ack = "Cmd.DateBattleListGuildCmd",
    from = "GuildCmd"
  },
  DateBattleRankGuildCmd = {
    id = 500108,
    req = "Cmd.DateBattleRankGuildCmd",
    ack = "Cmd.DateBattleRankGuildCmd",
    from = "GuildCmd"
  },
  RedtipOptGuildCmd = {
    id = 500109,
    req = "Cmd.RedtipOptGuildCmd",
    ack = "Cmd.RedtipOptGuildCmd",
    from = "GuildCmd"
  },
  RedtipBrowseGuildCmd = {
    id = 500110,
    req = "Cmd.RedtipBrowseGuildCmd",
    ack = "Cmd.RedtipBrowseGuildCmd",
    from = "GuildCmd"
  },
  DateBattleFlagGuildCmd = {
    id = 500111,
    req = "Cmd.DateBattleFlagGuildCmd",
    ack = "Cmd.DateBattleFlagGuildCmd",
    from = "GuildCmd"
  },
  DateBattleReportUIStateCmd = {
    id = 500113,
    req = "Cmd.DateBattleReportUIStateCmd",
    ack = "Cmd.DateBattleReportUIStateCmd",
    from = "GuildCmd"
  },
  GvgCityStatueQueryGuildCmd = {
    id = 500115,
    req = "Cmd.GvgCityStatueQueryGuildCmd",
    ack = "Cmd.GvgCityStatueQueryGuildCmd",
    from = "GuildCmd"
  },
  GvgCityStatueUpdateGuildCmd = {
    id = 500116,
    req = "Cmd.GvgCityStatueUpdateGuildCmd",
    ack = "Cmd.GvgCityStatueUpdateGuildCmd",
    from = "GuildCmd"
  },
  QuerySuperGvgStatCmd = {
    id = 500114,
    req = "Cmd.QuerySuperGvgStatCmd",
    ack = "Cmd.QuerySuperGvgStatCmd",
    from = "GuildCmd"
  },
  HouseOpt = {
    id = 1,
    req = "Cmd.HouseOpt",
    ack = "Cmd.HouseOpt",
    from = "HomeCmd"
  },
  QueryFurnitureDataHomeCmd = {
    id = 700001,
    req = "Cmd.QueryFurnitureDataHomeCmd",
    ack = "Cmd.QueryFurnitureDataHomeCmd",
    from = "HomeCmd"
  },
  FurnitureActionHomeCmd = {
    id = 700002,
    req = "Cmd.FurnitureActionHomeCmd",
    ack = "Cmd.FurnitureActionHomeCmd",
    from = "HomeCmd"
  },
  FurnitureOperHomeCmd = {
    id = 700003,
    req = "Cmd.FurnitureOperHomeCmd",
    ack = "Cmd.FurnitureOperHomeCmd",
    from = "HomeCmd"
  },
  FurnitureUpdateHomeCmd = {
    id = 700004,
    req = "Cmd.FurnitureUpdateHomeCmd",
    ack = "Cmd.FurnitureUpdateHomeCmd",
    from = "HomeCmd"
  },
  FurnitureDataUpdateHomeCmd = {
    id = 700005,
    req = "Cmd.FurnitureDataUpdateHomeCmd",
    ack = "Cmd.FurnitureDataUpdateHomeCmd",
    from = "HomeCmd"
  },
  HouseActionHomeCmd = {
    id = 700006,
    req = "Cmd.HouseActionHomeCmd",
    ack = "Cmd.HouseActionHomeCmd",
    from = "HomeCmd"
  },
  HouseDataUpdateHomeCmd = {
    id = 700007,
    req = "Cmd.HouseDataUpdateHomeCmd",
    ack = "Cmd.HouseDataUpdateHomeCmd",
    from = "HomeCmd"
  },
  PetFurnitureActionhomeCmd = {
    id = 700009,
    req = "Cmd.PetFurnitureActionhomeCmd",
    ack = "Cmd.PetFurnitureActionhomeCmd",
    from = "HomeCmd"
  },
  PrayHomeCmd = {
    id = 700010,
    req = "Cmd.PrayHomeCmd",
    ack = "Cmd.PrayHomeCmd",
    from = "HomeCmd"
  },
  EnterHomeCmd = {
    id = 700011,
    req = "Cmd.EnterHomeCmd",
    ack = "Cmd.EnterHomeCmd",
    from = "HomeCmd"
  },
  QueryHouseDataHomeCmd = {
    id = 700012,
    req = "Cmd.QueryHouseDataHomeCmd",
    ack = "Cmd.QueryHouseDataHomeCmd",
    from = "HomeCmd"
  },
  QueryHouseFurnitureHomeCmd = {
    id = 700021,
    req = "Cmd.QueryHouseFurnitureHomeCmd",
    ack = "Cmd.QueryHouseFurnitureHomeCmd",
    from = "HomeCmd"
  },
  OptUpdateHomeCmd = {
    id = 700013,
    req = "Cmd.OptUpdateHomeCmd",
    ack = "Cmd.OptUpdateHomeCmd",
    from = "HomeCmd"
  },
  PrintActionHomeCmd = {
    id = 700014,
    req = "Cmd.PrintActionHomeCmd",
    ack = "Cmd.PrintActionHomeCmd",
    from = "HomeCmd"
  },
  PrintUpdateHomeCmd = {
    id = 700015,
    req = "Cmd.PrintUpdateHomeCmd",
    ack = "Cmd.PrintUpdateHomeCmd",
    from = "HomeCmd"
  },
  BoardItemQueryHomeCmd = {
    id = 700016,
    req = "Cmd.BoardItemQueryHomeCmd",
    ack = "Cmd.BoardItemQueryHomeCmd",
    from = "HomeCmd"
  },
  BoardItemUpdateHomeCmd = {
    id = 700017,
    req = "Cmd.BoardItemUpdateHomeCmd",
    ack = "Cmd.BoardItemUpdateHomeCmd",
    from = "HomeCmd"
  },
  BoardMsgUpdateHomeCmd = {
    id = 700018,
    req = "Cmd.BoardMsgUpdateHomeCmd",
    ack = "Cmd.BoardMsgUpdateHomeCmd",
    from = "HomeCmd"
  },
  EventItemQueryHomeCmd = {
    id = 700019,
    req = "Cmd.EventItemQueryHomeCmd",
    ack = "Cmd.EventItemQueryHomeCmd",
    from = "HomeCmd"
  },
  QueryWoodRankHomeCmd = {
    id = 700020,
    req = "Cmd.QueryWoodRankHomeCmd",
    ack = "Cmd.QueryWoodRankHomeCmd",
    from = "HomeCmd"
  },
  TeamTowerInfoCmd = {
    id = 200001,
    req = "Cmd.TeamTowerInfoCmd",
    ack = "Cmd.TeamTowerInfoCmd",
    from = "InfiniteTower"
  },
  TeamTowerSummaryCmd = {
    id = 200002,
    req = "Cmd.TeamTowerSummaryCmd",
    ack = "Cmd.TeamTowerSummaryCmd",
    from = "InfiniteTower"
  },
  TeamTowerInviteCmd = {
    id = 200003,
    req = "Cmd.TeamTowerInviteCmd",
    ack = "Cmd.TeamTowerInviteCmd",
    from = "InfiniteTower"
  },
  TeamTowerReplyCmd = {
    id = 200004,
    req = "Cmd.TeamTowerReplyCmd",
    ack = "Cmd.TeamTowerReplyCmd",
    from = "InfiniteTower"
  },
  EnterTower = {
    id = 200005,
    req = "Cmd.EnterTower",
    ack = "Cmd.EnterTower",
    from = "InfiniteTower"
  },
  UserTowerInfoCmd = {
    id = 200007,
    req = "Cmd.UserTowerInfoCmd",
    ack = "Cmd.UserTowerInfoCmd",
    from = "InfiniteTower"
  },
  TowerLayerSyncTowerCmd = {
    id = 200008,
    req = "Cmd.TowerLayerSyncTowerCmd",
    ack = "Cmd.TowerLayerSyncTowerCmd",
    from = "InfiniteTower"
  },
  TowerInfoCmd = {
    id = 200010,
    req = "Cmd.TowerInfoCmd",
    ack = "Cmd.TowerInfoCmd",
    from = "InfiniteTower"
  },
  NewEverLayerTowerCmd = {
    id = 200009,
    req = "Cmd.NewEverLayerTowerCmd",
    ack = "Cmd.NewEverLayerTowerCmd",
    from = "InfiniteTower"
  },
  TowerLaunchCmd = {
    id = 200011,
    req = "Cmd.TowerLaunchCmd",
    ack = "Cmd.TowerLaunchCmd",
    from = "InfiniteTower"
  },
  AddMountInterCmd = {
    id = 2170001,
    req = "Cmd.AddMountInterCmd",
    ack = "Cmd.AddMountInterCmd",
    from = "InteractCmd"
  },
  DelMountInterCmd = {
    id = 2170002,
    req = "Cmd.DelMountInterCmd",
    ack = "Cmd.DelMountInterCmd",
    from = "InteractCmd"
  },
  ConfirmMountInterCmd = {
    id = 2170003,
    req = "Cmd.ConfirmMountInterCmd",
    ack = "Cmd.ConfirmMountInterCmd",
    from = "InteractCmd"
  },
  CancelMountInterCmd = {
    id = 2170004,
    req = "Cmd.CancelMountInterCmd",
    ack = "Cmd.CancelMountInterCmd",
    from = "InteractCmd"
  },
  AddMoveMountInterCmd = {
    id = 2170005,
    req = "Cmd.AddMoveMountInterCmd",
    ack = "Cmd.AddMoveMountInterCmd",
    from = "InteractCmd"
  },
  DelMoveMountInterCmd = {
    id = 2170006,
    req = "Cmd.DelMoveMountInterCmd",
    ack = "Cmd.DelMoveMountInterCmd",
    from = "InteractCmd"
  },
  ConfirmMoveMountInterCmd = {
    id = 2170007,
    req = "Cmd.ConfirmMoveMountInterCmd",
    ack = "Cmd.ConfirmMoveMountInterCmd",
    from = "InteractCmd"
  },
  CancelMoveMountInterCmd = {
    id = 2170008,
    req = "Cmd.CancelMoveMountInterCmd",
    ack = "Cmd.CancelMoveMountInterCmd",
    from = "InteractCmd"
  },
  UpdateTrainStateInterCmd = {
    id = 2170010,
    req = "Cmd.UpdateTrainStateInterCmd",
    ack = "Cmd.UpdateTrainStateInterCmd",
    from = "InteractCmd"
  },
  TrainUserSyncInterCmd = {
    id = 2170009,
    req = "Cmd.TrainUserSyncInterCmd",
    ack = "Cmd.TrainUserSyncInterCmd",
    from = "InteractCmd"
  },
  PosUpdateInterCmd = {
    id = 2170011,
    req = "Cmd.PosUpdateInterCmd",
    ack = "Cmd.PosUpdateInterCmd",
    from = "InteractCmd"
  },
  InteractNpcActionInterCmd = {
    id = 2170012,
    req = "Cmd.InteractNpcActionInterCmd",
    ack = "Cmd.InteractNpcActionInterCmd",
    from = "InteractCmd"
  },
  RegResultUserCmd = {
    id = 10004,
    req = "Cmd.RegResultUserCmd",
    ack = "Cmd.RegResultUserCmd",
    from = "LoginUserCmd"
  },
  CreateCharUserCmd = {
    id = 10005,
    req = "Cmd.CreateCharUserCmd",
    ack = "Cmd.CreateCharUserCmd",
    from = "LoginUserCmd"
  },
  SnapShotUserCmd = {
    id = 10006,
    req = "Cmd.SnapShotUserCmd",
    ack = "Cmd.SnapShotUserCmd",
    from = "LoginUserCmd"
  },
  SelectRoleUserCmd = {
    id = 10007,
    req = "Cmd.SelectRoleUserCmd",
    ack = "Cmd.SelectRoleUserCmd",
    from = "LoginUserCmd"
  },
  LoginResultUserCmd = {
    id = 10008,
    req = "Cmd.LoginResultUserCmd",
    ack = "Cmd.LoginResultUserCmd",
    from = "LoginUserCmd"
  },
  DeleteCharUserCmd = {
    id = 10009,
    req = "Cmd.DeleteCharUserCmd",
    ack = "Cmd.DeleteCharUserCmd",
    from = "LoginUserCmd"
  },
  HeartBeatUserCmd = {
    id = 10010,
    req = "Cmd.HeartBeatUserCmd",
    ack = "Cmd.HeartBeatUserCmd",
    from = "LoginUserCmd"
  },
  ServerTimeUserCmd = {
    id = 10011,
    req = "Cmd.ServerTimeUserCmd",
    ack = "Cmd.ServerTimeUserCmd",
    from = "LoginUserCmd"
  },
  GMDeleteCharUserCmd = {
    id = 10012,
    req = "Cmd.GMDeleteCharUserCmd",
    ack = "Cmd.GMDeleteCharUserCmd",
    from = "LoginUserCmd"
  },
  ClientInfoUserCmd = {
    id = 10013,
    req = "Cmd.ClientInfoUserCmd",
    ack = "Cmd.ClientInfoUserCmd",
    from = "LoginUserCmd"
  },
  ReqLoginUserCmd = {
    id = 10014,
    req = "Cmd.ReqLoginUserCmd",
    ack = "Cmd.ReqLoginUserCmd",
    from = "LoginUserCmd"
  },
  ReqLoginParamUserCmd = {
    id = 10015,
    req = "Cmd.ReqLoginParamUserCmd",
    ack = "Cmd.ReqLoginParamUserCmd",
    from = "LoginUserCmd"
  },
  KickParamUserCmd = {
    id = 10016,
    req = "Cmd.KickParamUserCmd",
    ack = "Cmd.KickParamUserCmd",
    from = "LoginUserCmd"
  },
  CancelDeleteCharUserCmd = {
    id = 10017,
    req = "Cmd.CancelDeleteCharUserCmd",
    ack = "Cmd.CancelDeleteCharUserCmd",
    from = "LoginUserCmd"
  },
  ClientFrameUserCmd = {
    id = 10018,
    req = "Cmd.ClientFrameUserCmd",
    ack = "Cmd.ClientFrameUserCmd",
    from = "LoginUserCmd"
  },
  SafeDeviceUserCmd = {
    id = 10019,
    req = "Cmd.SafeDeviceUserCmd",
    ack = "Cmd.SafeDeviceUserCmd",
    from = "LoginUserCmd"
  },
  ConfirmAuthorizeUserCmd = {
    id = 10020,
    req = "Cmd.ConfirmAuthorizeUserCmd",
    ack = "Cmd.ConfirmAuthorizeUserCmd",
    from = "LoginUserCmd"
  },
  SyncAuthorizeGateCmd = {
    id = 10021,
    req = "Cmd.SyncAuthorizeGateCmd",
    ack = "Cmd.SyncAuthorizeGateCmd",
    from = "LoginUserCmd"
  },
  RealAuthorizeUserCmd = {
    id = 10022,
    req = "Cmd.RealAuthorizeUserCmd",
    ack = "Cmd.RealAuthorizeUserCmd",
    from = "LoginUserCmd"
  },
  RealAuthorizeServerCmd = {
    id = 10023,
    req = "Cmd.RealAuthorizeServerCmd",
    ack = "Cmd.RealAuthorizeServerCmd",
    from = "LoginUserCmd"
  },
  RefreshZoneIDUserCmd = {
    id = 10024,
    req = "Cmd.RefreshZoneIDUserCmd",
    ack = "Cmd.RefreshZoneIDUserCmd",
    from = "LoginUserCmd"
  },
  QueryAfkStatUserCmd = {
    id = 10025,
    req = "Cmd.QueryAfkStatUserCmd",
    ack = "Cmd.QueryAfkStatUserCmd",
    from = "LoginUserCmd"
  },
  KickCharUserCmd = {
    id = 10026,
    req = "Cmd.KickCharUserCmd",
    ack = "Cmd.KickCharUserCmd",
    from = "LoginUserCmd"
  },
  OfflineDetectUserCmd = {
    id = 10027,
    req = "Cmd.OfflineDetectUserCmd",
    ack = "Cmd.OfflineDetectUserCmd",
    from = "LoginUserCmd"
  },
  DeviceInfoUserCmd = {
    id = 10028,
    req = "Cmd.DeviceInfoUserCmd",
    ack = "Cmd.DeviceInfoUserCmd",
    from = "LoginUserCmd"
  },
  AttachLoginUserCmd = {
    id = 10029,
    req = "Cmd.AttachLoginUserCmd",
    ack = "Cmd.AttachLoginUserCmd",
    from = "LoginUserCmd"
  },
  AttachSyncCmdUserCmd = {
    id = 10030,
    req = "Cmd.AttachSyncCmdUserCmd",
    ack = "Cmd.AttachSyncCmdUserCmd",
    from = "LoginUserCmd"
  },
  PingUserCmd = {
    id = 10031,
    req = "Cmd.PingUserCmd",
    ack = "Cmd.PingUserCmd",
    from = "LoginUserCmd"
  },
  SetMaxScopeUserCmd = {
    id = 10033,
    req = "Cmd.SetMaxScopeUserCmd",
    ack = "Cmd.SetMaxScopeUserCmd",
    from = "LoginUserCmd"
  },
  ReqMyRoomMatchCCmd = {
    id = 610001,
    req = "Cmd.ReqMyRoomMatchCCmd",
    ack = "Cmd.ReqMyRoomMatchCCmd",
    from = "MatchCCmd"
  },
  ReqRoomListCCmd = {
    id = 610002,
    req = "Cmd.ReqRoomListCCmd",
    ack = "Cmd.ReqRoomListCCmd",
    from = "MatchCCmd"
  },
  ReqRoomDetailCCmd = {
    id = 610003,
    req = "Cmd.ReqRoomDetailCCmd",
    ack = "Cmd.ReqRoomDetailCCmd",
    from = "MatchCCmd"
  },
  JoinRoomAbyssOption = {
    id = 1,
    req = "Cmd.JoinRoomAbyssOption",
    ack = "Cmd.JoinRoomAbyssOption",
    from = "MatchCCmd"
  },
  JoinRoomCCmd = {
    id = 610004,
    req = "Cmd.JoinRoomCCmd",
    ack = "Cmd.JoinRoomCCmd",
    from = "MatchCCmd"
  },
  LeaveRoomCCmd = {
    id = 610005,
    req = "Cmd.LeaveRoomCCmd",
    ack = "Cmd.LeaveRoomCCmd",
    from = "MatchCCmd"
  },
  NtfRoomStateCCmd = {
    id = 610007,
    req = "Cmd.NtfRoomStateCCmd",
    ack = "Cmd.NtfRoomStateCCmd",
    from = "MatchCCmd"
  },
  NtfFightStatCCmd = {
    id = 610008,
    req = "Cmd.NtfFightStatCCmd",
    ack = "Cmd.NtfFightStatCCmd",
    from = "MatchCCmd"
  },
  JoinFightingCCmd = {
    id = 610009,
    req = "Cmd.JoinFightingCCmd",
    ack = "Cmd.JoinFightingCCmd",
    from = "MatchCCmd"
  },
  ComboNotifyCCmd = {
    id = 610010,
    req = "Cmd.ComboNotifyCCmd",
    ack = "Cmd.ComboNotifyCCmd",
    from = "MatchCCmd"
  },
  RevChallengeCCmd = {
    id = 610011,
    req = "Cmd.RevChallengeCCmd",
    ack = "Cmd.RevChallengeCCmd",
    from = "MatchCCmd"
  },
  KickTeamCCmd = {
    id = 610012,
    req = "Cmd.KickTeamCCmd",
    ack = "Cmd.KickTeamCCmd",
    from = "MatchCCmd"
  },
  FightConfirmCCmd = {
    id = 610013,
    req = "Cmd.FightConfirmCCmd",
    ack = "Cmd.FightConfirmCCmd",
    from = "MatchCCmd"
  },
  PvpResultCCmd = {
    id = 610014,
    req = "Cmd.PvpResultCCmd",
    ack = "Cmd.PvpResultCCmd",
    from = "MatchCCmd"
  },
  PvpTeamMemberUpdateCCmd = {
    id = 610015,
    req = "Cmd.PvpTeamMemberUpdateCCmd",
    ack = "Cmd.PvpTeamMemberUpdateCCmd",
    from = "MatchCCmd"
  },
  PvpMemberDataUpdateCCmd = {
    id = 610016,
    req = "Cmd.PvpMemberDataUpdateCCmd",
    ack = "Cmd.PvpMemberDataUpdateCCmd",
    from = "MatchCCmd"
  },
  NtfMatchInfoCCmd = {
    id = 610017,
    req = "Cmd.NtfMatchInfoCCmd",
    ack = "Cmd.NtfMatchInfoCCmd",
    from = "MatchCCmd"
  },
  GodEndTimeCCmd = {
    id = 610018,
    req = "Cmd.GodEndTimeCCmd",
    ack = "Cmd.GodEndTimeCCmd",
    from = "MatchCCmd"
  },
  NtfRankChangeCCmd = {
    id = 610019,
    req = "Cmd.NtfRankChangeCCmd",
    ack = "Cmd.NtfRankChangeCCmd",
    from = "MatchCCmd"
  },
  OpenGlobalShopPanelCCmd = {
    id = 610020,
    req = "Cmd.OpenGlobalShopPanelCCmd",
    ack = "Cmd.OpenGlobalShopPanelCCmd",
    from = "MatchCCmd"
  },
  TutorMatchResultNtfMatchCCmd = {
    id = 610021,
    req = "Cmd.TutorMatchResultNtfMatchCCmd",
    ack = "Cmd.TutorMatchResultNtfMatchCCmd",
    from = "MatchCCmd"
  },
  TutorMatchResponseMatchCCmd = {
    id = 610022,
    req = "Cmd.TutorMatchResponseMatchCCmd",
    ack = "Cmd.TutorMatchResponseMatchCCmd",
    from = "MatchCCmd"
  },
  TeamPwsPreInfoMatchCCmd = {
    id = 610023,
    req = "Cmd.TeamPwsPreInfoMatchCCmd",
    ack = "Cmd.TeamPwsPreInfoMatchCCmd",
    from = "MatchCCmd"
  },
  UpdatePreInfoMatchCCmd = {
    id = 610024,
    req = "Cmd.UpdatePreInfoMatchCCmd",
    ack = "Cmd.UpdatePreInfoMatchCCmd",
    from = "MatchCCmd"
  },
  QueryTeamPwsRankMatchCCmd = {
    id = 610025,
    req = "Cmd.QueryTeamPwsRankMatchCCmd",
    ack = "Cmd.QueryTeamPwsRankMatchCCmd",
    from = "MatchCCmd"
  },
  TeamPwsUserInfo = {
    id = 5,
    req = "Cmd.TeamPwsUserInfo",
    ack = "Cmd.TeamPwsUserInfo",
    from = "MatchCCmd"
  },
  QueryTeamPwsTeamInfoMatchCCmd = {
    id = 610026,
    req = "Cmd.QueryTeamPwsTeamInfoMatchCCmd",
    ack = "Cmd.QueryTeamPwsTeamInfoMatchCCmd",
    from = "MatchCCmd"
  },
  QueryMenrocoRankMatchCCmd = {
    id = 610027,
    req = "Cmd.QueryMenrocoRankMatchCCmd",
    ack = "Cmd.QueryMenrocoRankMatchCCmd",
    from = "MatchCCmd"
  },
  MidMatchPrepareMatchCCmd = {
    id = 610028,
    req = "Cmd.MidMatchPrepareMatchCCmd",
    ack = "Cmd.MidMatchPrepareMatchCCmd",
    from = "MatchCCmd"
  },
  QueryBattlePassRankMatchCCmd = {
    id = 610029,
    req = "Cmd.QueryBattlePassRankMatchCCmd",
    ack = "Cmd.QueryBattlePassRankMatchCCmd",
    from = "MatchCCmd"
  },
  TwelvePvpPreInfoMatchCCmd = {
    id = 610030,
    req = "Cmd.TwelvePvpPreInfoMatchCCmd",
    ack = "Cmd.TwelvePvpPreInfoMatchCCmd",
    from = "MatchCCmd"
  },
  TwelvePvpUpdatePreInfoMatchCCmd = {
    id = 610031,
    req = "Cmd.TwelvePvpUpdatePreInfoMatchCCmd",
    ack = "Cmd.TwelvePvpUpdatePreInfoMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandQueryMatchCCmd = {
    id = 610043,
    req = "Cmd.TwelveWarbandQueryMatchCCmd",
    ack = "Cmd.TwelveWarbandQueryMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandSortMatchCCmd = {
    id = 610032,
    req = "Cmd.TwelveWarbandSortMatchCCmd",
    ack = "Cmd.TwelveWarbandSortMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandTreeMatchCCmd = {
    id = 610033,
    req = "Cmd.TwelveWarbandTreeMatchCCmd",
    ack = "Cmd.TwelveWarbandTreeMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandInfoMatchCCmd = {
    id = 610034,
    req = "Cmd.TwelveWarbandInfoMatchCCmd",
    ack = "Cmd.TwelveWarbandInfoMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandInviterMatchCCmd = {
    id = 610035,
    req = "Cmd.TwelveWarbandInviterMatchCCmd",
    ack = "Cmd.TwelveWarbandInviterMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandInviteeMatchCCmd = {
    id = 610036,
    req = "Cmd.TwelveWarbandInviteeMatchCCmd",
    ack = "Cmd.TwelveWarbandInviteeMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandPrepareMatchCCmd = {
    id = 610037,
    req = "Cmd.TwelveWarbandPrepareMatchCCmd",
    ack = "Cmd.TwelveWarbandPrepareMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandLeaveMatchCCmd = {
    id = 610038,
    req = "Cmd.TwelveWarbandLeaveMatchCCmd",
    ack = "Cmd.TwelveWarbandLeaveMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandDeleteMatchCCmd = {
    id = 610039,
    req = "Cmd.TwelveWarbandDeleteMatchCCmd",
    ack = "Cmd.TwelveWarbandDeleteMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandNameMatchCCmd = {
    id = 610040,
    req = "Cmd.TwelveWarbandNameMatchCCmd",
    ack = "Cmd.TwelveWarbandNameMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandSignUpMatchCCmd = {
    id = 610041,
    req = "Cmd.TwelveWarbandSignUpMatchCCmd",
    ack = "Cmd.TwelveWarbandSignUpMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandMatchMatchCCmd = {
    id = 610042,
    req = "Cmd.TwelveWarbandMatchMatchCCmd",
    ack = "Cmd.TwelveWarbandMatchMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandTeamListMatchCCmd = {
    id = 610044,
    req = "Cmd.TwelveWarbandTeamListMatchCCmd",
    ack = "Cmd.TwelveWarbandTeamListMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveWarbandCreateMatchCCmd = {
    id = 610045,
    req = "Cmd.TwelveWarbandCreateMatchCCmd",
    ack = "Cmd.TwelveWarbandCreateMatchCCmd",
    from = "MatchCCmd"
  },
  SyncMatchInfoCCmd = {
    id = 610046,
    req = "Cmd.SyncMatchInfoCCmd",
    ack = "Cmd.SyncMatchInfoCCmd",
    from = "MatchCCmd"
  },
  QueryTwelveSeasonInfoMatchCCmd = {
    id = 610047,
    req = "Cmd.QueryTwelveSeasonInfoMatchCCmd",
    ack = "Cmd.QueryTwelveSeasonInfoMatchCCmd",
    from = "MatchCCmd"
  },
  QueryTwelveSeasonFinishMatchCCmd = {
    id = 610048,
    req = "Cmd.QueryTwelveSeasonFinishMatchCCmd",
    ack = "Cmd.QueryTwelveSeasonFinishMatchCCmd",
    from = "MatchCCmd"
  },
  SyncMatchBoardOpenStateMatchCCmd = {
    id = 610049,
    req = "Cmd.SyncMatchBoardOpenStateMatchCCmd",
    ack = "Cmd.SyncMatchBoardOpenStateMatchCCmd",
    from = "MatchCCmd"
  },
  TwelveSeasonTimeInfoMatchCCmd = {
    id = 610050,
    req = "Cmd.TwelveSeasonTimeInfoMatchCCmd",
    ack = "Cmd.TwelveSeasonTimeInfoMatchCCmd",
    from = "MatchCCmd"
  },
  EnterObservationMatchCCmd = {
    id = 610051,
    req = "Cmd.EnterObservationMatchCCmd",
    ack = "Cmd.EnterObservationMatchCCmd",
    from = "MatchCCmd"
  },
  ObInitInfoFubenCmd = {
    id = 610052,
    req = "Cmd.ObInitInfoFubenCmd",
    ack = "Cmd.ObInitInfoFubenCmd",
    from = "MatchCCmd"
  },
  ReserveRoomBuildMatchCCmd = {
    id = 610053,
    req = "Cmd.ReserveRoomBuildMatchCCmd",
    ack = "Cmd.ReserveRoomBuildMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomInviterMatchCCmd = {
    id = 610054,
    req = "Cmd.ReserveRoomInviterMatchCCmd",
    ack = "Cmd.ReserveRoomInviterMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomInviteeMatchCCmd = {
    id = 610055,
    req = "Cmd.ReserveRoomInviteeMatchCCmd",
    ack = "Cmd.ReserveRoomInviteeMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomKickMatchCCmd = {
    id = 610056,
    req = "Cmd.ReserveRoomKickMatchCCmd",
    ack = "Cmd.ReserveRoomKickMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomLeaveMatchCCmd = {
    id = 610057,
    req = "Cmd.ReserveRoomLeaveMatchCCmd",
    ack = "Cmd.ReserveRoomLeaveMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomApplyMatchCCmd = {
    id = 610058,
    req = "Cmd.ReserveRoomApplyMatchCCmd",
    ack = "Cmd.ReserveRoomApplyMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomInfoMatchCCmd = {
    id = 610059,
    req = "Cmd.ReserveRoomInfoMatchCCmd",
    ack = "Cmd.ReserveRoomInfoMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomListMatchCCmd = {
    id = 610060,
    req = "Cmd.ReserveRoomListMatchCCmd",
    ack = "Cmd.ReserveRoomListMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomStartMatchCCmd = {
    id = 610061,
    req = "Cmd.ReserveRoomStartMatchCCmd",
    ack = "Cmd.ReserveRoomStartMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomChangeMatchCCmd = {
    id = 610062,
    req = "Cmd.ReserveRoomChangeMatchCCmd",
    ack = "Cmd.ReserveRoomChangeMatchCCmd",
    from = "MatchCCmd"
  },
  ReserveRoomPrepareMatchCCmd = {
    id = 610063,
    req = "Cmd.ReserveRoomPrepareMatchCCmd",
    ack = "Cmd.ReserveRoomPrepareMatchCCmd",
    from = "MatchCCmd"
  },
  JoinRaidWithRobotMatchCCmd = {
    id = 610064,
    req = "Cmd.JoinRaidWithRobotMatchCCmd",
    ack = "Cmd.JoinRaidWithRobotMatchCCmd",
    from = "MatchCCmd"
  },
  DesertWolfStatQueryCmd = {
    id = 610065,
    req = "Cmd.DesertWolfStatQueryCmd",
    ack = "Cmd.DesertWolfStatQueryCmd",
    from = "MatchCCmd"
  },
  DesertWolfRuleSyncCmd = {
    id = 610066,
    req = "Cmd.DesertWolfRuleSyncCmd",
    ack = "Cmd.DesertWolfRuleSyncCmd",
    from = "MatchCCmd"
  },
  QueryTriplePwsRankMatchCCmd = {
    id = 610067,
    req = "Cmd.QueryTriplePwsRankMatchCCmd",
    ack = "Cmd.QueryTriplePwsRankMatchCCmd",
    from = "MatchCCmd"
  },
  QueryTriplePwsTeamInfoMatchCCmd = {
    id = 610068,
    req = "Cmd.QueryTriplePwsTeamInfoMatchCCmd",
    ack = "Cmd.QueryTriplePwsTeamInfoMatchCCmd",
    from = "MatchCCmd"
  },
  TriplePvpQuestQueryCmd = {
    id = 610069,
    req = "Cmd.TriplePvpQuestQueryCmd",
    ack = "Cmd.TriplePvpQuestQueryCmd",
    from = "MatchCCmd"
  },
  SyncMatchHeadInfoMatchCCmd = {
    id = 610070,
    req = "Cmd.SyncMatchHeadInfoMatchCCmd",
    ack = "Cmd.SyncMatchHeadInfoMatchCCmd",
    from = "MatchCCmd"
  },
  TriplePvpPickRewardCmd = {
    id = 610071,
    req = "Cmd.TriplePvpPickRewardCmd",
    ack = "Cmd.TriplePvpPickRewardCmd",
    from = "MatchCCmd"
  },
  TriplePvpRewardStatusCmd = {
    id = 610072,
    req = "Cmd.TriplePvpRewardStatusCmd",
    ack = "Cmd.TriplePvpRewardStatusCmd",
    from = "MatchCCmd"
  },
  ChampionPvpPickRewardCmd = {
    id = 610073,
    req = "Cmd.ChampionPvpPickRewardCmd",
    ack = "Cmd.ChampionPvpPickRewardCmd",
    from = "MatchCCmd"
  },
  ChampionPvpRewardStatusCmd = {
    id = 610074,
    req = "Cmd.ChampionPvpRewardStatusCmd",
    ack = "Cmd.ChampionPvpRewardStatusCmd",
    from = "MatchCCmd"
  },
  AbyssRoomStateNtfMatchCCmd = {
    id = 610075,
    req = "Cmd.AbyssRoomStateNtfMatchCCmd",
    ack = "Cmd.AbyssRoomStateNtfMatchCCmd",
    from = "MatchCCmd"
  },
  ChooseNewProfessionMessCCmd = {
    id = 830001,
    req = "Cmd.ChooseNewProfessionMessCCmd",
    ack = "Cmd.ChooseNewProfessionMessCCmd",
    from = "MessCCmd"
  },
  InviterSendLoveConfessionMessCCmd = {
    id = 830002,
    req = "Cmd.InviterSendLoveConfessionMessCCmd",
    ack = "Cmd.InviterSendLoveConfessionMessCCmd",
    from = "MessCCmd"
  },
  InviteeReceiveLoveConfessionMessCCmd = {
    id = 830003,
    req = "Cmd.InviteeReceiveLoveConfessionMessCCmd",
    ack = "Cmd.InviteeReceiveLoveConfessionMessCCmd",
    from = "MessCCmd"
  },
  InviteeProcessLoveConfessionMessCCmd = {
    id = 830004,
    req = "Cmd.InviteeProcessLoveConfessionMessCCmd",
    ack = "Cmd.InviteeProcessLoveConfessionMessCCmd",
    from = "MessCCmd"
  },
  InviterReceiveConfessionMessCCmd = {
    id = 830005,
    req = "Cmd.InviterReceiveConfessionMessCCmd",
    ack = "Cmd.InviterReceiveConfessionMessCCmd",
    from = "MessCCmd"
  },
  FingerGuessLoveConfessionMessCCmd = {
    id = 830006,
    req = "Cmd.FingerGuessLoveConfessionMessCCmd",
    ack = "Cmd.FingerGuessLoveConfessionMessCCmd",
    from = "MessCCmd"
  },
  FingerLoseLoveConfessionMessCCmd = {
    id = 830007,
    req = "Cmd.FingerLoseLoveConfessionMessCCmd",
    ack = "Cmd.FingerLoseLoveConfessionMessCCmd",
    from = "MessCCmd"
  },
  InviterResultLoveConfessionMessCCmd = {
    id = 830008,
    req = "Cmd.InviterResultLoveConfessionMessCCmd",
    ack = "Cmd.InviterResultLoveConfessionMessCCmd",
    from = "MessCCmd"
  },
  SyncMapStepForeverRewardInfo = {
    id = 830009,
    req = "Cmd.SyncMapStepForeverRewardInfo",
    ack = "Cmd.SyncMapStepForeverRewardInfo",
    from = "MessCCmd"
  },
  BalanceModeChooseMessCCmd = {
    id = 830010,
    req = "Cmd.BalanceModeChooseMessCCmd",
    ack = "Cmd.BalanceModeChooseMessCCmd",
    from = "MessCCmd"
  },
  SetPippiStateMessCCmd = {
    id = 830011,
    req = "Cmd.SetPippiStateMessCCmd",
    ack = "Cmd.SetPippiStateMessCCmd",
    from = "MessCCmd"
  },
  SyncDestinyGraphMessCCmd = {
    id = 830012,
    req = "Cmd.SyncDestinyGraphMessCCmd",
    ack = "Cmd.SyncDestinyGraphMessCCmd",
    from = "MessCCmd"
  },
  LightenDestinyGraphMessCCmd = {
    id = 830013,
    req = "Cmd.LightenDestinyGraphMessCCmd",
    ack = "Cmd.LightenDestinyGraphMessCCmd",
    from = "MessCCmd"
  },
  AstralRewardMessCCmd = {
    id = 830014,
    req = "Cmd.AstralRewardMessCCmd",
    ack = "Cmd.AstralRewardMessCCmd",
    from = "MessCCmd"
  },
  PurifyProductsMaterialsMessCCmd = {
    id = 830015,
    req = "Cmd.PurifyProductsMaterialsMessCCmd",
    ack = "Cmd.PurifyProductsMaterialsMessCCmd",
    from = "MessCCmd"
  },
  PurifyProductsRefineMessCCmd = {
    id = 830016,
    req = "Cmd.PurifyProductsRefineMessCCmd",
    ack = "Cmd.PurifyProductsRefineMessCCmd",
    from = "MessCCmd"
  },
  AstralSyncSeasonInfoMessCCmd = {
    id = 830017,
    req = "Cmd.AstralSyncSeasonInfoMessCCmd",
    ack = "Cmd.AstralSyncSeasonInfoMessCCmd",
    from = "MessCCmd"
  },
  SetPvpChampionStatueMessCCmd = {
    id = 830018,
    req = "Cmd.SetPvpChampionStatueMessCCmd",
    ack = "Cmd.SetPvpChampionStatueMessCCmd",
    from = "MessCCmd"
  },
  SyncQuickPassItemInfoMessCCmd = {
    id = 830019,
    req = "Cmd.SyncQuickPassItemInfoMessCCmd",
    ack = "Cmd.SyncQuickPassItemInfoMessCCmd",
    from = "MessCCmd"
  },
  SyncPvpChampionStatueMessCCmd = {
    id = 830020,
    req = "Cmd.SyncPvpChampionStatueMessCCmd",
    ack = "Cmd.SyncPvpChampionStatueMessCCmd",
    from = "MessCCmd"
  },
  SyncForbidCardsMessCCmd = {
    id = 830021,
    req = "Cmd.SyncForbidCardsMessCCmd",
    ack = "Cmd.SyncForbidCardsMessCCmd",
    from = "MessCCmd"
  },
  MiniGameNtfMonsterShot = {
    id = 2230001,
    req = "Cmd.MiniGameNtfMonsterShot",
    ack = "Cmd.MiniGameNtfMonsterShot",
    from = "MiniGameCmd"
  },
  MiniGameMonsterShotAction = {
    id = 2230002,
    req = "Cmd.MiniGameMonsterShotAction",
    ack = "Cmd.MiniGameMonsterShotAction",
    from = "MiniGameCmd"
  },
  MiniGameNtfMonsterAnswer = {
    id = 2230009,
    req = "Cmd.MiniGameNtfMonsterAnswer",
    ack = "Cmd.MiniGameNtfMonsterAnswer",
    from = "MiniGameCmd"
  },
  MiniGameSubmitMonsterAnswer = {
    id = 2230010,
    req = "Cmd.MiniGameSubmitMonsterAnswer",
    ack = "Cmd.MiniGameSubmitMonsterAnswer",
    from = "MiniGameCmd"
  },
  MiniGameAction = {
    id = 2230013,
    req = "Cmd.MiniGameAction",
    ack = "Cmd.MiniGameAction",
    from = "MiniGameCmd"
  },
  MiniGameNextRound = {
    id = 2230014,
    req = "Cmd.MiniGameNextRound",
    ack = "Cmd.MiniGameNextRound",
    from = "MiniGameCmd"
  },
  MiniGameUnlockList = {
    id = 2230011,
    req = "Cmd.MiniGameUnlockList",
    ack = "Cmd.MiniGameUnlockList",
    from = "MiniGameCmd"
  },
  MiniGameNtfGameOverCmd = {
    id = 2230015,
    req = "Cmd.MiniGameNtfGameOverCmd",
    ack = "Cmd.MiniGameNtfGameOverCmd",
    from = "MiniGameCmd"
  },
  MiniGameReqOver = {
    id = 2230016,
    req = "Cmd.MiniGameReqOver",
    ack = "Cmd.MiniGameReqOver",
    from = "MiniGameCmd"
  },
  MiniGameUseAssist = {
    id = 2230017,
    req = "Cmd.MiniGameUseAssist",
    ack = "Cmd.MiniGameUseAssist",
    from = "MiniGameCmd"
  },
  MiniGameNtfRoundOver = {
    id = 2230018,
    req = "Cmd.MiniGameNtfRoundOver",
    ack = "Cmd.MiniGameNtfRoundOver",
    from = "MiniGameCmd"
  },
  MiniGameQueryRank = {
    id = 2230019,
    req = "Cmd.MiniGameQueryRank",
    ack = "Cmd.MiniGameQueryRank",
    from = "MiniGameCmd"
  },
  NoviceBPTargetUpdateCmd = {
    id = 770001,
    req = "Cmd.NoviceBPTargetUpdateCmd",
    ack = "Cmd.NoviceBPTargetUpdateCmd",
    from = "NoviceBattlePass"
  },
  NoviceBPRewardUpdateCmd = {
    id = 770002,
    req = "Cmd.NoviceBPRewardUpdateCmd",
    ack = "Cmd.NoviceBPRewardUpdateCmd",
    from = "NoviceBattlePass"
  },
  NoviceBPTargetRewardCmd = {
    id = 770003,
    req = "Cmd.NoviceBPTargetRewardCmd",
    ack = "Cmd.NoviceBPTargetRewardCmd",
    from = "NoviceBattlePass"
  },
  NoviceBpBuyLevelCmd = {
    id = 770004,
    req = "Cmd.NoviceBpBuyLevelCmd",
    ack = "Cmd.NoviceBpBuyLevelCmd",
    from = "NoviceBattlePass"
  },
  ChallengeTargetUpdateCmd = {
    id = 770005,
    req = "Cmd.ChallengeTargetUpdateCmd",
    ack = "Cmd.ChallengeTargetUpdateCmd",
    from = "NoviceBattlePass"
  },
  ReturnBpTargetUpdateCmd = {
    id = 770006,
    req = "Cmd.ReturnBpTargetUpdateCmd",
    ack = "Cmd.ReturnBpTargetUpdateCmd",
    from = "NoviceBattlePass"
  },
  ReturnBPRewardUpdateCmd = {
    id = 770007,
    req = "Cmd.ReturnBPRewardUpdateCmd",
    ack = "Cmd.ReturnBPRewardUpdateCmd",
    from = "NoviceBattlePass"
  },
  ReturnBPTargetRewardCmd = {
    id = 770008,
    req = "Cmd.ReturnBPTargetRewardCmd",
    ack = "Cmd.ReturnBPTargetRewardCmd",
    from = "NoviceBattlePass"
  },
  ReturnBPReturnRewardCmd = {
    id = 770009,
    req = "Cmd.ReturnBPReturnRewardCmd",
    ack = "Cmd.ReturnBPReturnRewardCmd",
    from = "NoviceBattlePass"
  },
  ReturnBpBuyLevelCmd = {
    id = 770010,
    req = "Cmd.ReturnBpBuyLevelCmd",
    ack = "Cmd.ReturnBpBuyLevelCmd",
    from = "NoviceBattlePass"
  },
  NoviceNotebookLastPosCmd = {
    id = 2310005,
    req = "Cmd.NoviceNotebookLastPosCmd",
    ack = "Cmd.NoviceNotebookLastPosCmd",
    from = "NoviceNotebook"
  },
  NoviceNotebookCmd = {
    id = 2310001,
    req = "Cmd.NoviceNotebookCmd",
    ack = "Cmd.NoviceNotebookCmd",
    from = "NoviceNotebook"
  },
  NoviceNotebookCoverOpenCmd = {
    id = 2310002,
    req = "Cmd.NoviceNotebookCoverOpenCmd",
    ack = "Cmd.NoviceNotebookCoverOpenCmd",
    from = "NoviceNotebook"
  },
  NoviceNotebookReadPageCmd = {
    id = 2310003,
    req = "Cmd.NoviceNotebookReadPageCmd",
    ack = "Cmd.NoviceNotebookReadPageCmd",
    from = "NoviceNotebook"
  },
  NoviceNotebookReceiveAwardCmd = {
    id = 2310004,
    req = "Cmd.NoviceNotebookReceiveAwardCmd",
    ack = "Cmd.NoviceNotebookReceiveAwardCmd",
    from = "NoviceNotebook"
  },
  TaiwanFbLikeProgressCmd = {
    id = 800001,
    req = "Cmd.TaiwanFbLikeProgressCmd",
    ack = "Cmd.TaiwanFbLikeProgressCmd",
    from = "OverseasTaiwanCmd"
  },
  TaiwanFbLikeUserRedeemCmd = {
    id = 800002,
    req = "Cmd.TaiwanFbLikeUserRedeemCmd",
    ack = "Cmd.TaiwanFbLikeUserRedeemCmd",
    from = "OverseasTaiwanCmd"
  },
  OverseasPhotoUploadCmd = {
    id = 810001,
    req = "Cmd.OverseasPhotoUploadCmd",
    ack = "Cmd.OverseasPhotoUploadCmd",
    from = "OverseasTaiwanCmd"
  },
  OverseasPhotoPathPrefixCmd = {
    id = 810002,
    req = "Cmd.OverseasPhotoPathPrefixCmd",
    ack = "Cmd.OverseasPhotoPathPrefixCmd",
    from = "OverseasTaiwanCmd"
  },
  TaiwanFbShareProgressCmd = {
    id = 800010,
    req = "Cmd.TaiwanFbShareProgressCmd",
    ack = "Cmd.TaiwanFbShareProgressCmd",
    from = "OverseasTaiwanCmd"
  },
  TaiwanFbShareRedeemCmd = {
    id = 800011,
    req = "Cmd.TaiwanFbShareRedeemCmd",
    ack = "Cmd.TaiwanFbShareRedeemCmd",
    from = "OverseasTaiwanCmd"
  },
  TaiwanMagicLiziCmd = {
    id = 800099,
    req = "Cmd.TaiwanMagicLiziCmd",
    ack = "Cmd.TaiwanMagicLiziCmd",
    from = "OverseasTaiwanCmd"
  },
  TaiwanRankLisaCmd = {
    id = 800021,
    req = "Cmd.TaiwanRankLisaCmd",
    ack = "Cmd.TaiwanRankLisaCmd",
    from = "OverseasTaiwanCmd"
  },
  OverseasChargeLimitGetChargeCmd = {
    id = 810011,
    req = "Cmd.OverseasChargeLimitGetChargeCmd",
    ack = "Cmd.OverseasChargeLimitGetChargeCmd",
    from = "OverseasTaiwanCmd"
  },
  OverseasGoeItemAddCmd = {
    id = 810021,
    req = "Cmd.OverseasGoeItemAddCmd",
    ack = "Cmd.OverseasGoeItemAddCmd",
    from = "OverseasTaiwanCmd"
  },
  OverseasGoeItemUseCmd = {
    id = 810022,
    req = "Cmd.OverseasGoeItemUseCmd",
    ack = "Cmd.OverseasGoeItemUseCmd",
    from = "OverseasTaiwanCmd"
  },
  OverseasGoePurchaseCmd = {
    id = 810023,
    req = "Cmd.OverseasGoePurchaseCmd",
    ack = "Cmd.OverseasGoePurchaseCmd",
    from = "OverseasTaiwanCmd"
  },
  FirebaseNotifyUpdateCmd = {
    id = 810024,
    req = "Cmd.FirebaseNotifyUpdateCmd",
    ack = "Cmd.FirebaseNotifyUpdateCmd",
    from = "OverseasTaiwanCmd"
  },
  PhotoQueryListCmd = {
    id = 300001,
    req = "Cmd.PhotoQueryListCmd",
    ack = "Cmd.PhotoQueryListCmd",
    from = "PhotoCmd"
  },
  PhotoOptCmd = {
    id = 300002,
    req = "Cmd.PhotoOptCmd",
    ack = "Cmd.PhotoOptCmd",
    from = "PhotoCmd"
  },
  PhotoUpdateNtf = {
    id = 300003,
    req = "Cmd.PhotoUpdateNtf",
    ack = "Cmd.PhotoUpdateNtf",
    from = "PhotoCmd"
  },
  FrameActionPhotoCmd = {
    id = 300004,
    req = "Cmd.FrameActionPhotoCmd",
    ack = "Cmd.FrameActionPhotoCmd",
    from = "PhotoCmd"
  },
  QueryFramePhotoListPhotoCmd = {
    id = 300005,
    req = "Cmd.QueryFramePhotoListPhotoCmd",
    ack = "Cmd.QueryFramePhotoListPhotoCmd",
    from = "PhotoCmd"
  },
  QueryUserPhotoListPhotoCmd = {
    id = 300006,
    req = "Cmd.QueryUserPhotoListPhotoCmd",
    ack = "Cmd.QueryUserPhotoListPhotoCmd",
    from = "PhotoCmd"
  },
  UpdateFrameShowPhotoCmd = {
    id = 300007,
    req = "Cmd.UpdateFrameShowPhotoCmd",
    ack = "Cmd.UpdateFrameShowPhotoCmd",
    from = "PhotoCmd"
  },
  FramePhotoUpdatePhotoCmd = {
    id = 300008,
    req = "Cmd.FramePhotoUpdatePhotoCmd",
    ack = "Cmd.FramePhotoUpdatePhotoCmd",
    from = "PhotoCmd"
  },
  QueryMd5ListPhotoCmd = {
    id = 300009,
    req = "Cmd.QueryMd5ListPhotoCmd",
    ack = "Cmd.QueryMd5ListPhotoCmd",
    from = "PhotoCmd"
  },
  AddMd5PhotoCmd = {
    id = 300010,
    req = "Cmd.AddMd5PhotoCmd",
    ack = "Cmd.AddMd5PhotoCmd",
    from = "PhotoCmd"
  },
  RemoveMd5PhotoCmd = {
    id = 300011,
    req = "Cmd.RemoveMd5PhotoCmd",
    ack = "Cmd.RemoveMd5PhotoCmd",
    from = "PhotoCmd"
  },
  QueryUrlPhotoCmd = {
    id = 300012,
    req = "Cmd.QueryUrlPhotoCmd",
    ack = "Cmd.QueryUrlPhotoCmd",
    from = "PhotoCmd"
  },
  QueryUploadInfoPhotoCmd = {
    id = 300013,
    req = "Cmd.QueryUploadInfoPhotoCmd",
    ack = "Cmd.QueryUploadInfoPhotoCmd",
    from = "PhotoCmd"
  },
  BoardBaseInfoPhotoCmd = {
    id = 300014,
    req = "Cmd.BoardBaseInfoPhotoCmd",
    ack = "Cmd.BoardBaseInfoPhotoCmd",
    from = "PhotoCmd"
  },
  BoardTopicPhotoCmd = {
    id = 300015,
    req = "Cmd.BoardTopicPhotoCmd",
    ack = "Cmd.BoardTopicPhotoCmd",
    from = "PhotoCmd"
  },
  BoardRotateListPhotoCmd = {
    id = 300016,
    req = "Cmd.BoardRotateListPhotoCmd",
    ack = "Cmd.BoardRotateListPhotoCmd",
    from = "PhotoCmd"
  },
  BoardListPhotoCmd = {
    id = 300017,
    req = "Cmd.BoardListPhotoCmd",
    ack = "Cmd.BoardListPhotoCmd",
    from = "PhotoCmd"
  },
  BoardMyListPhotoCmd = {
    id = 300018,
    req = "Cmd.BoardMyListPhotoCmd",
    ack = "Cmd.BoardMyListPhotoCmd",
    from = "PhotoCmd"
  },
  BoardQueryDetailPhotoCmd = {
    id = 300019,
    req = "Cmd.BoardQueryDetailPhotoCmd",
    ack = "Cmd.BoardQueryDetailPhotoCmd",
    from = "PhotoCmd"
  },
  BoardQueryDataPhotoCmd = {
    id = 300020,
    req = "Cmd.BoardQueryDataPhotoCmd",
    ack = "Cmd.BoardQueryDataPhotoCmd",
    from = "PhotoCmd"
  },
  BoardAwardListPhotoCmd = {
    id = 300021,
    req = "Cmd.BoardAwardListPhotoCmd",
    ack = "Cmd.BoardAwardListPhotoCmd",
    from = "PhotoCmd"
  },
  BoardLikePhotoCmd = {
    id = 300022,
    req = "Cmd.BoardLikePhotoCmd",
    ack = "Cmd.BoardLikePhotoCmd",
    from = "PhotoCmd"
  },
  BoardAwardPhotoCmd = {
    id = 300023,
    req = "Cmd.BoardAwardPhotoCmd",
    ack = "Cmd.BoardAwardPhotoCmd",
    from = "PhotoCmd"
  },
  BoardGetAwardPhotoCmd = {
    id = 300024,
    req = "Cmd.BoardGetAwardPhotoCmd",
    ack = "Cmd.BoardGetAwardPhotoCmd",
    from = "PhotoCmd"
  },
  BoardOpenPhotoCmd = {
    id = 300025,
    req = "Cmd.BoardOpenPhotoCmd",
    ack = "Cmd.BoardOpenPhotoCmd",
    from = "PhotoCmd"
  },
  SendPostcardCmd = {
    id = 300026,
    req = "Cmd.SendPostcardCmd",
    ack = "Cmd.SendPostcardCmd",
    from = "PhotoCmd"
  },
  PostcardListCmd = {
    id = 300027,
    req = "Cmd.PostcardListCmd",
    ack = "Cmd.PostcardListCmd",
    from = "PhotoCmd"
  },
  SavePostcardCmd = {
    id = 300028,
    req = "Cmd.SavePostcardCmd",
    ack = "Cmd.SavePostcardCmd",
    from = "PhotoCmd"
  },
  UpdatePostcardCmd = {
    id = 300029,
    req = "Cmd.UpdatePostcardCmd",
    ack = "Cmd.UpdatePostcardCmd",
    from = "PhotoCmd"
  },
  DelPostcardCmd = {
    id = 300030,
    req = "Cmd.DelPostcardCmd",
    ack = "Cmd.DelPostcardCmd",
    from = "PhotoCmd"
  },
  ViewPostcardCmd = {
    id = 300031,
    req = "Cmd.ViewPostcardCmd",
    ack = "Cmd.ViewPostcardCmd",
    from = "PhotoCmd"
  },
  BoardQueryAwardPhotoCmd = {
    id = 300032,
    req = "Cmd.BoardQueryAwardPhotoCmd",
    ack = "Cmd.BoardQueryAwardPhotoCmd",
    from = "PhotoCmd"
  },
  QueryActPuzzleCmd = {
    id = 680001,
    req = "Cmd.QueryActPuzzleCmd",
    ack = "Cmd.QueryActPuzzleCmd",
    from = "PuzzleCmd"
  },
  PuzzleItemNtf = {
    id = 680003,
    req = "Cmd.PuzzleItemNtf",
    ack = "Cmd.PuzzleItemNtf",
    from = "PuzzleCmd"
  },
  ActivePuzzleCmd = {
    id = 680004,
    req = "Cmd.ActivePuzzleCmd",
    ack = "Cmd.ActivePuzzleCmd",
    from = "PuzzleCmd"
  },
  InvitePveCardCmd = {
    id = 660001,
    req = "Cmd.InvitePveCardCmd",
    ack = "Cmd.InvitePveCardCmd",
    from = "PveCard"
  },
  ReplyPveCardCmd = {
    id = 660002,
    req = "Cmd.ReplyPveCardCmd",
    ack = "Cmd.ReplyPveCardCmd",
    from = "PveCard"
  },
  EnterPveCardCmd = {
    id = 660003,
    req = "Cmd.EnterPveCardCmd",
    ack = "Cmd.EnterPveCardCmd",
    from = "PveCard"
  },
  QueryCardInfoCmd = {
    id = 660004,
    req = "Cmd.QueryCardInfoCmd",
    ack = "Cmd.QueryCardInfoCmd",
    from = "PveCard"
  },
  SelectPveCardCmd = {
    id = 660005,
    req = "Cmd.SelectPveCardCmd",
    ack = "Cmd.SelectPveCardCmd",
    from = "PveCard"
  },
  SyncProcessPveCardCmd = {
    id = 660006,
    req = "Cmd.SyncProcessPveCardCmd",
    ack = "Cmd.SyncProcessPveCardCmd",
    from = "PveCard"
  },
  UpdateProcessPveCardCmd = {
    id = 660007,
    req = "Cmd.UpdateProcessPveCardCmd",
    ack = "Cmd.UpdateProcessPveCardCmd",
    from = "PveCard"
  },
  BeginFirePveCardCmd = {
    id = 660008,
    req = "Cmd.BeginFirePveCardCmd",
    ack = "Cmd.BeginFirePveCardCmd",
    from = "PveCard"
  },
  FinishPlayCardCmd = {
    id = 660009,
    req = "Cmd.FinishPlayCardCmd",
    ack = "Cmd.FinishPlayCardCmd",
    from = "PveCard"
  },
  PlayPveCardCmd = {
    id = 660010,
    req = "Cmd.PlayPveCardCmd",
    ack = "Cmd.PlayPveCardCmd",
    from = "PveCard"
  },
  GetPveCardRewardCmd = {
    id = 660011,
    req = "Cmd.GetPveCardRewardCmd",
    ack = "Cmd.GetPveCardRewardCmd",
    from = "PveCard"
  },
  QueueEnterRetCmd = {
    id = 780003,
    req = "Cmd.QueueEnterRetCmd",
    ack = "Cmd.QueueEnterRetCmd",
    from = "QueueEnterCmd"
  },
  QueueUpdateCountCmd = {
    id = 780004,
    req = "Cmd.QueueUpdateCountCmd",
    ack = "Cmd.QueueUpdateCountCmd",
    from = "QueueEnterCmd"
  },
  RequireQueueNotifyCmd = {
    id = 780001,
    req = "Cmd.RequireQueueNotifyCmd",
    ack = "Cmd.RequireQueueNotifyCmd",
    from = "QueueEnterCmd"
  },
  ReqQueueEnterCmd = {
    id = 780002,
    req = "Cmd.ReqQueueEnterCmd",
    ack = "Cmd.ReqQueueEnterCmd",
    from = "QueueEnterCmd"
  },
  QueryRaidPuzzleListRaidCmd = {
    id = 760001,
    req = "Cmd.QueryRaidPuzzleListRaidCmd",
    ack = "Cmd.QueryRaidPuzzleListRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzleActionRaidCmd = {
    id = 760002,
    req = "Cmd.RaidPuzzleActionRaidCmd",
    ack = "Cmd.RaidPuzzleActionRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzleDataUpdateRaidCmd = {
    id = 760003,
    req = "Cmd.RaidPuzzleDataUpdateRaidCmd",
    ack = "Cmd.RaidPuzzleDataUpdateRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzlePushObjRaidCmd = {
    id = 760004,
    req = "Cmd.RaidPuzzlePushObjRaidCmd",
    ack = "Cmd.RaidPuzzlePushObjRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzleRotateObjRaidCmd = {
    id = 760005,
    req = "Cmd.RaidPuzzleRotateObjRaidCmd",
    ack = "Cmd.RaidPuzzleRotateObjRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzleObjChangeNtfRaidCmd = {
    id = 760006,
    req = "Cmd.RaidPuzzleObjChangeNtfRaidCmd",
    ack = "Cmd.RaidPuzzleObjChangeNtfRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzleElevatorRaidCmd = {
    id = 760007,
    req = "Cmd.RaidPuzzleElevatorRaidCmd",
    ack = "Cmd.RaidPuzzleElevatorRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzlePosRaidCmd = {
    id = 760008,
    req = "Cmd.RaidPuzzlePosRaidCmd",
    ack = "Cmd.RaidPuzzlePosRaidCmd",
    from = "RaidCmd"
  },
  RaidPuzzleRoomIconRaidCmd = {
    id = 760009,
    req = "Cmd.RaidPuzzleRoomIconRaidCmd",
    ack = "Cmd.RaidPuzzleRoomIconRaidCmd",
    from = "RaidCmd"
  },
  ClientSummonCmd = {
    id = 760010,
    req = "Cmd.ClientSummonCmd",
    ack = "Cmd.ClientSummonCmd",
    from = "RaidCmd"
  },
  ClientNpcDieCmd = {
    id = 760010,
    req = "Cmd.ClientNpcDieCmd",
    ack = "Cmd.ClientNpcDieCmd",
    from = "RaidCmd"
  },
  ClientTreasureBoxCmd = {
    id = 760011,
    req = "Cmd.ClientTreasureBoxCmd",
    ack = "Cmd.ClientTreasureBoxCmd",
    from = "RaidCmd"
  },
  ClientSaveCmd = {
    id = 760012,
    req = "Cmd.ClientSaveCmd",
    ack = "Cmd.ClientSaveCmd",
    from = "RaidCmd"
  },
  ClientSaveResultCmd = {
    id = 760013,
    req = "Cmd.ClientSaveResultCmd",
    ack = "Cmd.ClientSaveResultCmd",
    from = "RaidCmd"
  },
  ClientQueryRaidCmd = {
    id = 760014,
    req = "Cmd.ClientQueryRaidCmd",
    ack = "Cmd.ClientQueryRaidCmd",
    from = "RaidCmd"
  },
  PersonalRaidEnterCmd = {
    id = 760015,
    req = "Cmd.PersonalRaidEnterCmd",
    ack = "Cmd.PersonalRaidEnterCmd",
    from = "RaidCmd"
  },
  ClientRaidAchRewardCmd = {
    id = 760016,
    req = "Cmd.ClientRaidAchRewardCmd",
    ack = "Cmd.ClientRaidAchRewardCmd",
    from = "RaidCmd"
  },
  HeadwearActivityNpcUserCmd = {
    id = 760017,
    req = "Cmd.HeadwearActivityNpcUserCmd",
    ack = "Cmd.HeadwearActivityNpcUserCmd",
    from = "RaidCmd"
  },
  HeadwearActivityRoundUserCmd = {
    id = 760018,
    req = "Cmd.HeadwearActivityRoundUserCmd",
    ack = "Cmd.HeadwearActivityRoundUserCmd",
    from = "RaidCmd"
  },
  HeadwearActivityTowerUserCmd = {
    id = 760019,
    req = "Cmd.HeadwearActivityTowerUserCmd",
    ack = "Cmd.HeadwearActivityTowerUserCmd",
    from = "RaidCmd"
  },
  QueryHeadwearActivityRewardRecordCmd = {
    id = 760024,
    req = "Cmd.QueryHeadwearActivityRewardRecordCmd",
    ack = "Cmd.QueryHeadwearActivityRewardRecordCmd",
    from = "RaidCmd"
  },
  HeadwearActivityEndUserCmd = {
    id = 760020,
    req = "Cmd.HeadwearActivityEndUserCmd",
    ack = "Cmd.HeadwearActivityEndUserCmd",
    from = "RaidCmd"
  },
  HeadwearActivityRangeUserCmd = {
    id = 760021,
    req = "Cmd.HeadwearActivityRangeUserCmd",
    ack = "Cmd.HeadwearActivityRangeUserCmd",
    from = "RaidCmd"
  },
  HeadwearActivityOpenUserCmd = {
    id = 760022,
    req = "Cmd.HeadwearActivityOpenUserCmd",
    ack = "Cmd.HeadwearActivityOpenUserCmd",
    from = "RaidCmd"
  },
  RaidOptionalCardCmd = {
    id = 760025,
    req = "Cmd.RaidOptionalCardCmd",
    ack = "Cmd.RaidOptionalCardCmd",
    from = "RaidCmd"
  },
  RaidSelectCardResultCmd = {
    id = 760026,
    req = "Cmd.RaidSelectCardResultCmd",
    ack = "Cmd.RaidSelectCardResultCmd",
    from = "RaidCmd"
  },
  RaidSelectCardResultRes = {
    id = 760027,
    req = "Cmd.RaidSelectCardResultRes",
    ack = "Cmd.RaidSelectCardResultRes",
    from = "RaidCmd"
  },
  RaidSelectCardHistoryResultCmd = {
    id = 760028,
    req = "Cmd.RaidSelectCardHistoryResultCmd",
    ack = "Cmd.RaidSelectCardHistoryResultCmd",
    from = "RaidCmd"
  },
  RaidSelectCardResetCmd = {
    id = 760029,
    req = "Cmd.RaidSelectCardResetCmd",
    ack = "Cmd.RaidSelectCardResetCmd",
    from = "RaidCmd"
  },
  RaidNewResetCmd = {
    id = 760030,
    req = "Cmd.RaidNewResetCmd",
    ack = "Cmd.RaidNewResetCmd",
    from = "RaidCmd"
  },
  AbyssDragonInfoNtfRaidCmd = {
    id = 760031,
    req = "Cmd.AbyssDragonInfoNtfRaidCmd",
    ack = "Cmd.AbyssDragonInfoNtfRaidCmd",
    from = "RaidCmd"
  },
  AbyssDragonHpUpdateRaidCmd = {
    id = 760032,
    req = "Cmd.AbyssDragonHpUpdateRaidCmd",
    ack = "Cmd.AbyssDragonHpUpdateRaidCmd",
    from = "RaidCmd"
  },
  AbyssDragonOnOffRaidCmd = {
    id = 760033,
    req = "Cmd.AbyssDragonOnOffRaidCmd",
    ack = "Cmd.AbyssDragonOnOffRaidCmd",
    from = "RaidCmd"
  },
  AbyssDragonDamageRankRaidCmd = {
    id = 760034,
    req = "Cmd.AbyssDragonDamageRankRaidCmd",
    ack = "Cmd.AbyssDragonDamageRankRaidCmd",
    from = "RaidCmd"
  },
  QueryRecallInfoRecallCmd = {
    id = 840001,
    req = "Cmd.QueryRecallInfoRecallCmd",
    ack = "Cmd.QueryRecallInfoRecallCmd",
    from = "RecallCCmd"
  },
  SignQueryInfoRecallCmd = {
    id = 840002,
    req = "Cmd.SignQueryInfoRecallCmd",
    ack = "Cmd.SignQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  SignInRecallCmd = {
    id = 840003,
    req = "Cmd.SignInRecallCmd",
    ack = "Cmd.SignInRecallCmd",
    from = "RecallCCmd"
  },
  BattlePassQueryInfoRecallCmd = {
    id = 840004,
    req = "Cmd.BattlePassQueryInfoRecallCmd",
    ack = "Cmd.BattlePassQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  BattlePassQuickLvUpRecallCmd = {
    id = 840005,
    req = "Cmd.BattlePassQuickLvUpRecallCmd",
    ack = "Cmd.BattlePassQuickLvUpRecallCmd",
    from = "RecallCCmd"
  },
  GetBattlePassRewardRecallCmd = {
    id = 840006,
    req = "Cmd.GetBattlePassRewardRecallCmd",
    ack = "Cmd.GetBattlePassRewardRecallCmd",
    from = "RecallCCmd"
  },
  GetAllBattlePassRewardRecallCmd = {
    id = 840012,
    req = "Cmd.GetAllBattlePassRewardRecallCmd",
    ack = "Cmd.GetAllBattlePassRewardRecallCmd",
    from = "RecallCCmd"
  },
  WeeklyTaskQueryInfoRecallCmd = {
    id = 840008,
    req = "Cmd.WeeklyTaskQueryInfoRecallCmd",
    ack = "Cmd.WeeklyTaskQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  WeeklyTaskGetRewardRecallCmd = {
    id = 840009,
    req = "Cmd.WeeklyTaskGetRewardRecallCmd",
    ack = "Cmd.WeeklyTaskGetRewardRecallCmd",
    from = "RecallCCmd"
  },
  FundQueryInfoRecallCmd = {
    id = 840010,
    req = "Cmd.FundQueryInfoRecallCmd",
    ack = "Cmd.FundQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  FundGetRewardRecallCmd = {
    id = 840011,
    req = "Cmd.FundGetRewardRecallCmd",
    ack = "Cmd.FundGetRewardRecallCmd",
    from = "RecallCCmd"
  },
  ShopQueryInfoRecallCmd = {
    id = 840013,
    req = "Cmd.ShopQueryInfoRecallCmd",
    ack = "Cmd.ShopQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  BuyShopGoodRecallCmd = {
    id = 840014,
    req = "Cmd.BuyShopGoodRecallCmd",
    ack = "Cmd.BuyShopGoodRecallCmd",
    from = "RecallCCmd"
  },
  CatchUpQueryInfoRecallCmd = {
    id = 840015,
    req = "Cmd.CatchUpQueryInfoRecallCmd",
    ack = "Cmd.CatchUpQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  MvpCardQueryInfoRecallCmd = {
    id = 840016,
    req = "Cmd.MvpCardQueryInfoRecallCmd",
    ack = "Cmd.MvpCardQueryInfoRecallCmd",
    from = "RecallCCmd"
  },
  MvpCardSetUpCardRecallCmd = {
    id = 840017,
    req = "Cmd.MvpCardSetUpCardRecallCmd",
    ack = "Cmd.MvpCardSetUpCardRecallCmd",
    from = "RecallCCmd"
  },
  MvpCardRandCardRecallCmd = {
    id = 840018,
    req = "Cmd.MvpCardRandCardRecallCmd",
    ack = "Cmd.MvpCardRandCardRecallCmd",
    from = "RecallCCmd"
  },
  SearchCond = {
    id = 1,
    req = "Cmd.SearchCond",
    ack = "Cmd.SearchCond",
    from = "RecordTrade"
  },
  BriefPendingListRecordTradeCmd = {
    id = 570001,
    req = "Cmd.BriefPendingListRecordTradeCmd",
    ack = "Cmd.BriefPendingListRecordTradeCmd",
    from = "RecordTrade"
  },
  DetailPendingListRecordTradeCmd = {
    id = 570003,
    req = "Cmd.DetailPendingListRecordTradeCmd",
    ack = "Cmd.DetailPendingListRecordTradeCmd",
    from = "RecordTrade"
  },
  ItemSellInfoRecordTradeCmd = {
    id = 570004,
    req = "Cmd.ItemSellInfoRecordTradeCmd",
    ack = "Cmd.ItemSellInfoRecordTradeCmd",
    from = "RecordTrade"
  },
  MyPendingListRecordTradeCmd = {
    id = 570007,
    req = "Cmd.MyPendingListRecordTradeCmd",
    ack = "Cmd.MyPendingListRecordTradeCmd",
    from = "RecordTrade"
  },
  MyTradeLogRecordTradeCmd = {
    id = 570009,
    req = "Cmd.MyTradeLogRecordTradeCmd",
    ack = "Cmd.MyTradeLogRecordTradeCmd",
    from = "RecordTrade"
  },
  TakeLogCmd = {
    id = 570027,
    req = "Cmd.TakeLogCmd",
    ack = "Cmd.TakeLogCmd",
    from = "RecordTrade"
  },
  AddNewLog = {
    id = 570028,
    req = "Cmd.AddNewLog",
    ack = "Cmd.AddNewLog",
    from = "RecordTrade"
  },
  FetchNameInfoCmd = {
    id = 570029,
    req = "Cmd.FetchNameInfoCmd",
    ack = "Cmd.FetchNameInfoCmd",
    from = "RecordTrade"
  },
  ReqServerPriceRecordTradeCmd = {
    id = 570014,
    req = "Cmd.ReqServerPriceRecordTradeCmd",
    ack = "Cmd.ReqServerPriceRecordTradeCmd",
    from = "RecordTrade"
  },
  BuyItemRecordTradeCmd = {
    id = 570015,
    req = "Cmd.BuyItemRecordTradeCmd",
    ack = "Cmd.BuyItemRecordTradeCmd",
    from = "RecordTrade"
  },
  SellItemRecordTradeCmd = {
    id = 570020,
    req = "Cmd.SellItemRecordTradeCmd",
    ack = "Cmd.SellItemRecordTradeCmd",
    from = "RecordTrade"
  },
  CancelItemRecordTrade = {
    id = 570022,
    req = "Cmd.CancelItemRecordTrade",
    ack = "Cmd.CancelItemRecordTrade",
    from = "RecordTrade"
  },
  ResellPendingRecordTrade = {
    id = 570023,
    req = "Cmd.ResellPendingRecordTrade",
    ack = "Cmd.ResellPendingRecordTrade",
    from = "RecordTrade"
  },
  PanelRecordTrade = {
    id = 570024,
    req = "Cmd.PanelRecordTrade",
    ack = "Cmd.PanelRecordTrade",
    from = "RecordTrade"
  },
  ListNtfRecordTrade = {
    id = 570025,
    req = "Cmd.ListNtfRecordTrade",
    ack = "Cmd.ListNtfRecordTrade",
    from = "RecordTrade"
  },
  HotItemidRecordTrade = {
    id = 570026,
    req = "Cmd.HotItemidRecordTrade",
    ack = "Cmd.HotItemidRecordTrade",
    from = "RecordTrade"
  },
  NtfCanTakeCountTradeCmd = {
    id = 570030,
    req = "Cmd.NtfCanTakeCountTradeCmd",
    ack = "Cmd.NtfCanTakeCountTradeCmd",
    from = "RecordTrade"
  },
  GiveTradeCmd = {
    id = 570031,
    req = "Cmd.GiveTradeCmd",
    ack = "Cmd.GiveTradeCmd",
    from = "RecordTrade"
  },
  AcceptTradeCmd = {
    id = 570033,
    req = "Cmd.AcceptTradeCmd",
    ack = "Cmd.AcceptTradeCmd",
    from = "RecordTrade"
  },
  RefuseTradeCmd = {
    id = 570034,
    req = "Cmd.RefuseTradeCmd",
    ack = "Cmd.RefuseTradeCmd",
    from = "RecordTrade"
  },
  ReqGiveItemInfoCmd = {
    id = 570032,
    req = "Cmd.ReqGiveItemInfoCmd",
    ack = "Cmd.ReqGiveItemInfoCmd",
    from = "RecordTrade"
  },
  CheckPackageSizeTradeCmd = {
    id = 570035,
    req = "Cmd.CheckPackageSizeTradeCmd",
    ack = "Cmd.CheckPackageSizeTradeCmd",
    from = "RecordTrade"
  },
  QucikTakeLogTradeCmd = {
    id = 570036,
    req = "Cmd.QucikTakeLogTradeCmd",
    ack = "Cmd.QucikTakeLogTradeCmd",
    from = "RecordTrade"
  },
  QueryItemCountTradeCmd = {
    id = 570037,
    req = "Cmd.QueryItemCountTradeCmd",
    ack = "Cmd.QueryItemCountTradeCmd",
    from = "RecordTrade"
  },
  LotteryGiveCmd = {
    id = 570038,
    req = "Cmd.LotteryGiveCmd",
    ack = "Cmd.LotteryGiveCmd",
    from = "RecordTrade"
  },
  TodayFinanceRank = {
    id = 570039,
    req = "Cmd.TodayFinanceRank",
    ack = "Cmd.TodayFinanceRank",
    from = "RecordTrade"
  },
  TodayFinanceDetail = {
    id = 570040,
    req = "Cmd.TodayFinanceDetail",
    ack = "Cmd.TodayFinanceDetail",
    from = "RecordTrade"
  },
  BoothPlayerPendingListCmd = {
    id = 570041,
    req = "Cmd.BoothPlayerPendingListCmd",
    ack = "Cmd.BoothPlayerPendingListCmd",
    from = "RecordTrade"
  },
  UpdateOrderTradeCmd = {
    id = 570042,
    req = "Cmd.UpdateOrderTradeCmd",
    ack = "Cmd.UpdateOrderTradeCmd",
    from = "RecordTrade"
  },
  TakeAllLogCmd = {
    id = 570043,
    req = "Cmd.TakeAllLogCmd",
    ack = "Cmd.TakeAllLogCmd",
    from = "RecordTrade"
  },
  QueryMergePriceRecordTradeCmd = {
    id = 570044,
    req = "Cmd.QueryMergePriceRecordTradeCmd",
    ack = "Cmd.QueryMergePriceRecordTradeCmd",
    from = "RecordTrade"
  },
  QueryItemPriceRecordTradeCmd = {
    id = 570045,
    req = "Cmd.QueryItemPriceRecordTradeCmd",
    ack = "Cmd.QueryItemPriceRecordTradeCmd",
    from = "RecordTrade"
  },
  PreorderQueryPriceRecordTradeCmd = {
    id = 570046,
    req = "Cmd.PreorderQueryPriceRecordTradeCmd",
    ack = "Cmd.PreorderQueryPriceRecordTradeCmd",
    from = "RecordTrade"
  },
  PreorderItemRecordTradeCmd = {
    id = 570047,
    req = "Cmd.PreorderItemRecordTradeCmd",
    ack = "Cmd.PreorderItemRecordTradeCmd",
    from = "RecordTrade"
  },
  PreorderCancelRecordTradeCmd = {
    id = 570048,
    req = "Cmd.PreorderCancelRecordTradeCmd",
    ack = "Cmd.PreorderCancelRecordTradeCmd",
    from = "RecordTrade"
  },
  PreorderListRecordTradeCmd = {
    id = 570049,
    req = "Cmd.PreorderListRecordTradeCmd",
    ack = "Cmd.PreorderListRecordTradeCmd",
    from = "RecordTrade"
  },
  QueryHoldedItemCountTradeCmd = {
    id = 570050,
    req = "Cmd.QueryHoldedItemCountTradeCmd",
    ack = "Cmd.QueryHoldedItemCountTradeCmd",
    from = "RecordTrade"
  },
  QuerySelledItemCountTradeCmd = {
    id = 570051,
    req = "Cmd.QuerySelledItemCountTradeCmd",
    ack = "Cmd.QuerySelledItemCountTradeCmd",
    from = "RecordTrade"
  },
  RecommendItemTradeCmd = {
    id = 570052,
    req = "Cmd.RecommendItemTradeCmd",
    ack = "Cmd.RecommendItemTradeCmd",
    from = "RecordTrade"
  },
  RoguelikeInfoCmd = {
    id = 710001,
    req = "Cmd.RoguelikeInfoCmd",
    ack = "Cmd.RoguelikeInfoCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeInviteCmd = {
    id = 710002,
    req = "Cmd.RoguelikeInviteCmd",
    ack = "Cmd.RoguelikeInviteCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeReplyCmd = {
    id = 710003,
    req = "Cmd.RoguelikeReplyCmd",
    ack = "Cmd.RoguelikeReplyCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeCreateCmd = {
    id = 710004,
    req = "Cmd.RoguelikeCreateCmd",
    ack = "Cmd.RoguelikeCreateCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeEnterCmd = {
    id = 710005,
    req = "Cmd.RoguelikeEnterCmd",
    ack = "Cmd.RoguelikeEnterCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeArchiveCmd = {
    id = 710006,
    req = "Cmd.RoguelikeArchiveCmd",
    ack = "Cmd.RoguelikeArchiveCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeQueryArchiveDataCmd = {
    id = 710007,
    req = "Cmd.RoguelikeQueryArchiveDataCmd",
    ack = "Cmd.RoguelikeQueryArchiveDataCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeRaidInfoCmd = {
    id = 710008,
    req = "Cmd.RoguelikeRaidInfoCmd",
    ack = "Cmd.RoguelikeRaidInfoCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeRankInfoCmd = {
    id = 710009,
    req = "Cmd.RoguelikeRankInfoCmd",
    ack = "Cmd.RoguelikeRankInfoCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeQueryBoardCmd = {
    id = 710010,
    req = "Cmd.RoguelikeQueryBoardCmd",
    ack = "Cmd.RoguelikeQueryBoardCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeSubSceneCmd = {
    id = 710011,
    req = "Cmd.RoguelikeSubSceneCmd",
    ack = "Cmd.RoguelikeSubSceneCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeScoreModelCmd = {
    id = 710012,
    req = "Cmd.RoguelikeScoreModelCmd",
    ack = "Cmd.RoguelikeScoreModelCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeEventNpcCmd = {
    id = 710013,
    req = "Cmd.RoguelikeEventNpcCmd",
    ack = "Cmd.RoguelikeEventNpcCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeShopCmd = {
    id = 710014,
    req = "Cmd.RoguelikeShopCmd",
    ack = "Cmd.RoguelikeShopCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeShopDataCmd = {
    id = 710015,
    req = "Cmd.RoguelikeShopDataCmd",
    ack = "Cmd.RoguelikeShopDataCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeUseItemCmd = {
    id = 710016,
    req = "Cmd.RoguelikeUseItemCmd",
    ack = "Cmd.RoguelikeUseItemCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeRobotCmd = {
    id = 710017,
    req = "Cmd.RoguelikeRobotCmd",
    ack = "Cmd.RoguelikeRobotCmd",
    from = "RoguelikeCmd"
  },
  RoguelikeFightInfo = {
    id = 710018,
    req = "Cmd.RoguelikeFightInfo",
    ack = "Cmd.RoguelikeFightInfo",
    from = "RoguelikeCmd"
  },
  RoguelikeWeekReward = {
    id = 710019,
    req = "Cmd.RoguelikeWeekReward",
    ack = "Cmd.RoguelikeWeekReward",
    from = "RoguelikeCmd"
  },
  RoguelikeSettlement = {
    id = 710020,
    req = "Cmd.RoguelikeSettlement",
    ack = "Cmd.RoguelikeSettlement",
    from = "RoguelikeCmd"
  },
  RoguelikeGoRoomCmd = {
    id = 710021,
    req = "Cmd.RoguelikeGoRoomCmd",
    ack = "Cmd.RoguelikeGoRoomCmd",
    from = "RoguelikeCmd"
  },
  RogueChargeMagicBottle = {
    id = 710022,
    req = "Cmd.RogueChargeMagicBottle",
    ack = "Cmd.RogueChargeMagicBottle",
    from = "RoguelikeCmd"
  },
  RogueTarotOperateCmd = {
    id = 710023,
    req = "Cmd.RogueTarotOperateCmd",
    ack = "Cmd.RogueTarotOperateCmd",
    from = "RoguelikeCmd"
  },
  RogueTarotInfoCmd = {
    id = 710024,
    req = "Cmd.RogueTarotInfoCmd",
    ack = "Cmd.RogueTarotInfoCmd",
    from = "RoguelikeCmd"
  },
  TeamQueryRogueArchiveSCmd = {
    id = 710025,
    req = "Cmd.TeamQueryRogueArchiveSCmd",
    ack = "Cmd.TeamQueryRogueArchiveSCmd",
    from = "RoguelikeCmd"
  },
  AuguryInvite = {
    id = 270001,
    req = "Cmd.AuguryInvite",
    ack = "Cmd.AuguryInvite",
    from = "SceneAugury"
  },
  AuguryInviteReply = {
    id = 270002,
    req = "Cmd.AuguryInviteReply",
    ack = "Cmd.AuguryInviteReply",
    from = "SceneAugury"
  },
  AuguryChat = {
    id = 270003,
    req = "Cmd.AuguryChat",
    ack = "Cmd.AuguryChat",
    from = "SceneAugury"
  },
  AuguryTitle = {
    id = 270004,
    req = "Cmd.AuguryTitle",
    ack = "Cmd.AuguryTitle",
    from = "SceneAugury"
  },
  AuguryAnswer = {
    id = 270005,
    req = "Cmd.AuguryAnswer",
    ack = "Cmd.AuguryAnswer",
    from = "SceneAugury"
  },
  AuguryQuit = {
    id = 270006,
    req = "Cmd.AuguryQuit",
    ack = "Cmd.AuguryQuit",
    from = "SceneAugury"
  },
  AuguryAstrologyDrawCard = {
    id = 270007,
    req = "Cmd.AuguryAstrologyDrawCard",
    ack = "Cmd.AuguryAstrologyDrawCard",
    from = "SceneAugury"
  },
  AuguryAstrologyInfo = {
    id = 270008,
    req = "Cmd.AuguryAstrologyInfo",
    ack = "Cmd.AuguryAstrologyInfo",
    from = "SceneAugury"
  },
  BeingSkillQuery = {
    id = 320001,
    req = "Cmd.BeingSkillQuery",
    ack = "Cmd.BeingSkillQuery",
    from = "SceneBeing"
  },
  BeingSkillUpdate = {
    id = 320002,
    req = "Cmd.BeingSkillUpdate",
    ack = "Cmd.BeingSkillUpdate",
    from = "SceneBeing"
  },
  BeingSkillLevelUp = {
    id = 320003,
    req = "Cmd.BeingSkillLevelUp",
    ack = "Cmd.BeingSkillLevelUp",
    from = "SceneBeing"
  },
  BeingInfoQuery = {
    id = 320004,
    req = "Cmd.BeingInfoQuery",
    ack = "Cmd.BeingInfoQuery",
    from = "SceneBeing"
  },
  BeingInfoUpdate = {
    id = 320005,
    req = "Cmd.BeingInfoUpdate",
    ack = "Cmd.BeingInfoUpdate",
    from = "SceneBeing"
  },
  BeingSwitchState = {
    id = 320007,
    req = "Cmd.BeingSwitchState",
    ack = "Cmd.BeingSwitchState",
    from = "SceneBeing"
  },
  BeingOffCmd = {
    id = 320006,
    req = "Cmd.BeingOffCmd",
    ack = "Cmd.BeingOffCmd",
    from = "SceneBeing"
  },
  ChangeBodyBeingCmd = {
    id = 320008,
    req = "Cmd.ChangeBodyBeingCmd",
    ack = "Cmd.ChangeBodyBeingCmd",
    from = "SceneBeing"
  },
  BeingQueryDataPartial = {
    id = 320009,
    req = "Cmd.BeingQueryDataPartial",
    ack = "Cmd.BeingQueryDataPartial",
    from = "SceneBeing"
  },
  ChatRoomMember = {
    id = 2,
    req = "Cmd.ChatRoomMember",
    ack = "Cmd.ChatRoomMember",
    from = "SceneChatRoom"
  },
  ChatRoomData = {
    id = 1,
    req = "Cmd.ChatRoomData",
    ack = "Cmd.ChatRoomData",
    from = "SceneChatRoom"
  },
  CreateChatRoom = {
    id = 190001,
    req = "Cmd.CreateChatRoom",
    ack = "Cmd.CreateChatRoom",
    from = "SceneChatRoom"
  },
  JoinChatRoom = {
    id = 190002,
    req = "Cmd.JoinChatRoom",
    ack = "Cmd.JoinChatRoom",
    from = "SceneChatRoom"
  },
  ExitChatRoom = {
    id = 190003,
    req = "Cmd.ExitChatRoom",
    ack = "Cmd.ExitChatRoom",
    from = "SceneChatRoom"
  },
  KickChatMember = {
    id = 190004,
    req = "Cmd.KickChatMember",
    ack = "Cmd.KickChatMember",
    from = "SceneChatRoom"
  },
  ExchangeRoomOwner = {
    id = 190005,
    req = "Cmd.ExchangeRoomOwner",
    ack = "Cmd.ExchangeRoomOwner",
    from = "SceneChatRoom"
  },
  RoomMemberUpdate = {
    id = 190007,
    req = "Cmd.RoomMemberUpdate",
    ack = "Cmd.RoomMemberUpdate",
    from = "SceneChatRoom"
  },
  EnterChatRoom = {
    id = 190006,
    req = "Cmd.EnterChatRoom",
    ack = "Cmd.EnterChatRoom",
    from = "SceneChatRoom"
  },
  ChatRoomSummary = {
    id = 1,
    req = "Cmd.ChatRoomSummary",
    ack = "Cmd.ChatRoomSummary",
    from = "SceneChatRoom"
  },
  ChatRoomDataSync = {
    id = 190008,
    req = "Cmd.ChatRoomDataSync",
    ack = "Cmd.ChatRoomDataSync",
    from = "SceneChatRoom"
  },
  ChatRoomTip = {
    id = 190009,
    req = "Cmd.ChatRoomTip",
    ack = "Cmd.ChatRoomTip",
    from = "SceneChatRoom"
  },
  CookStateNtf = {
    id = 290001,
    req = "Cmd.CookStateNtf",
    ack = "Cmd.CookStateNtf",
    from = "SceneFood"
  },
  PrepareCook = {
    id = 290002,
    req = "Cmd.PrepareCook",
    ack = "Cmd.PrepareCook",
    from = "SceneFood"
  },
  SelectCookType = {
    id = 290003,
    req = "Cmd.SelectCookType",
    ack = "Cmd.SelectCookType",
    from = "SceneFood"
  },
  StartCook = {
    id = 290004,
    req = "Cmd.StartCook",
    ack = "Cmd.StartCook",
    from = "SceneFood"
  },
  PutFood = {
    id = 290005,
    req = "Cmd.PutFood",
    ack = "Cmd.PutFood",
    from = "SceneFood"
  },
  EditFoodPower = {
    id = 290006,
    req = "Cmd.EditFoodPower",
    ack = "Cmd.EditFoodPower",
    from = "SceneFood"
  },
  QueryFoodNpcInfo = {
    id = 290008,
    req = "Cmd.QueryFoodNpcInfo",
    ack = "Cmd.QueryFoodNpcInfo",
    from = "SceneFood"
  },
  StartEat = {
    id = 290009,
    req = "Cmd.StartEat",
    ack = "Cmd.StartEat",
    from = "SceneFood"
  },
  StopEat = {
    id = 290010,
    req = "Cmd.StopEat",
    ack = "Cmd.StopEat",
    from = "SceneFood"
  },
  EatProgressNtf = {
    id = 290007,
    req = "Cmd.EatProgressNtf",
    ack = "Cmd.EatProgressNtf",
    from = "SceneFood"
  },
  FoodInfoNtf = {
    id = 290011,
    req = "Cmd.FoodInfoNtf",
    ack = "Cmd.FoodInfoNtf",
    from = "SceneFood"
  },
  UpdateFoodInfo = {
    id = 290016,
    req = "Cmd.UpdateFoodInfo",
    ack = "Cmd.UpdateFoodInfo",
    from = "SceneFood"
  },
  UnlockRecipeNtf = {
    id = 290012,
    req = "Cmd.UnlockRecipeNtf",
    ack = "Cmd.UnlockRecipeNtf",
    from = "SceneFood"
  },
  QueryFoodManualData = {
    id = 290013,
    req = "Cmd.QueryFoodManualData",
    ack = "Cmd.QueryFoodManualData",
    from = "SceneFood"
  },
  NewFoodDataNtf = {
    id = 290014,
    req = "Cmd.NewFoodDataNtf",
    ack = "Cmd.NewFoodDataNtf",
    from = "SceneFood"
  },
  ClickFoodManualData = {
    id = 290015,
    req = "Cmd.ClickFoodManualData",
    ack = "Cmd.ClickFoodManualData",
    from = "SceneFood"
  },
  NewInter = {
    id = 220001,
    req = "Cmd.NewInter",
    ack = "Cmd.NewInter",
    from = "SceneInterlocution"
  },
  Answer = {
    id = 220002,
    req = "Cmd.Answer",
    ack = "Cmd.Answer",
    from = "SceneInterlocution"
  },
  Query = {
    id = 220003,
    req = "Cmd.Query",
    ack = "Cmd.Query",
    from = "SceneInterlocution"
  },
  QueryPaperResultInterCmd = {
    id = 220004,
    req = "Cmd.QueryPaperResultInterCmd",
    ack = "Cmd.QueryPaperResultInterCmd",
    from = "SceneInterlocution"
  },
  PaperQuestionInterCmd = {
    id = 220005,
    req = "Cmd.PaperQuestionInterCmd",
    ack = "Cmd.PaperQuestionInterCmd",
    from = "SceneInterlocution"
  },
  PaperResultInterCmd = {
    id = 220006,
    req = "Cmd.PaperResultInterCmd",
    ack = "Cmd.PaperResultInterCmd",
    from = "SceneInterlocution"
  },
  ArtifactData = {
    id = 1,
    req = "Cmd.ArtifactData",
    ack = "Cmd.ArtifactData",
    from = "SceneItem"
  },
  PackageItem = {
    id = 60001,
    req = "Cmd.PackageItem",
    ack = "Cmd.PackageItem",
    from = "SceneItem"
  },
  PackageUpdate = {
    id = 60002,
    req = "Cmd.PackageUpdate",
    ack = "Cmd.PackageUpdate",
    from = "SceneItem"
  },
  ItemUse = {
    id = 60003,
    req = "Cmd.ItemUse",
    ack = "Cmd.ItemUse",
    from = "SceneItem"
  },
  PackageSort = {
    id = 60004,
    req = "Cmd.PackageSort",
    ack = "Cmd.PackageSort",
    from = "SceneItem"
  },
  Equip = {
    id = 60005,
    req = "Cmd.Equip",
    ack = "Cmd.Equip",
    from = "SceneItem"
  },
  SellItem = {
    id = 60006,
    req = "Cmd.SellItem",
    ack = "Cmd.SellItem",
    from = "SceneItem"
  },
  EquipStrength = {
    id = 60007,
    req = "Cmd.EquipStrength",
    ack = "Cmd.EquipStrength",
    from = "SceneItem"
  },
  Produce = {
    id = 60009,
    req = "Cmd.Produce",
    ack = "Cmd.Produce",
    from = "SceneItem"
  },
  ProduceDone = {
    id = 60010,
    req = "Cmd.ProduceDone",
    ack = "Cmd.ProduceDone",
    from = "SceneItem"
  },
  EquipRefine = {
    id = 60011,
    req = "Cmd.EquipRefine",
    ack = "Cmd.EquipRefine",
    from = "SceneItem"
  },
  EquipDecompose = {
    id = 60012,
    req = "Cmd.EquipDecompose",
    ack = "Cmd.EquipDecompose",
    from = "SceneItem"
  },
  QueryEquipData = {
    id = 60013,
    req = "Cmd.QueryEquipData",
    ack = "Cmd.QueryEquipData",
    from = "SceneItem"
  },
  BrowsePackage = {
    id = 60014,
    req = "Cmd.BrowsePackage",
    ack = "Cmd.BrowsePackage",
    from = "SceneItem"
  },
  EquipCard = {
    id = 60015,
    req = "Cmd.EquipCard",
    ack = "Cmd.EquipCard",
    from = "SceneItem"
  },
  ItemShow = {
    id = 60016,
    req = "Cmd.ItemShow",
    ack = "Cmd.ItemShow",
    from = "SceneItem"
  },
  ItemShow64 = {
    id = 60035,
    req = "Cmd.ItemShow64",
    ack = "Cmd.ItemShow64",
    from = "SceneItem"
  },
  EquipRepair = {
    id = 60017,
    req = "Cmd.EquipRepair",
    ack = "Cmd.EquipRepair",
    from = "SceneItem"
  },
  HintNtf = {
    id = 60018,
    req = "Cmd.HintNtf",
    ack = "Cmd.HintNtf",
    from = "SceneItem"
  },
  EnchantEquip = {
    id = 60019,
    req = "Cmd.EnchantEquip",
    ack = "Cmd.EnchantEquip",
    from = "SceneItem"
  },
  TradeItemBaseInfo = {
    id = 1,
    req = "Cmd.TradeItemBaseInfo",
    ack = "Cmd.TradeItemBaseInfo",
    from = "SceneItem"
  },
  EnchantRes = {
    id = 60122,
    req = "Cmd.EnchantRes",
    ack = "Cmd.EnchantRes",
    from = "SceneItem"
  },
  ProcessEnchantItemCmd = {
    id = 60020,
    req = "Cmd.ProcessEnchantItemCmd",
    ack = "Cmd.ProcessEnchantItemCmd",
    from = "SceneItem"
  },
  EquipExchangeItemCmd = {
    id = 60021,
    req = "Cmd.EquipExchangeItemCmd",
    ack = "Cmd.EquipExchangeItemCmd",
    from = "SceneItem"
  },
  OnOffStoreItemCmd = {
    id = 60022,
    req = "Cmd.OnOffStoreItemCmd",
    ack = "Cmd.OnOffStoreItemCmd",
    from = "SceneItem"
  },
  PackSlotNtfItemCmd = {
    id = 60023,
    req = "Cmd.PackSlotNtfItemCmd",
    ack = "Cmd.PackSlotNtfItemCmd",
    from = "SceneItem"
  },
  RestoreEquipItemCmd = {
    id = 60024,
    req = "Cmd.RestoreEquipItemCmd",
    ack = "Cmd.RestoreEquipItemCmd",
    from = "SceneItem"
  },
  UseCountItemCmd = {
    id = 60025,
    req = "Cmd.UseCountItemCmd",
    ack = "Cmd.UseCountItemCmd",
    from = "SceneItem"
  },
  ExchangeCardItemCmd = {
    id = 60028,
    req = "Cmd.ExchangeCardItemCmd",
    ack = "Cmd.ExchangeCardItemCmd",
    from = "SceneItem"
  },
  GetCountItemCmd = {
    id = 60029,
    req = "Cmd.GetCountItemCmd",
    ack = "Cmd.GetCountItemCmd",
    from = "SceneItem"
  },
  SaveLoveLetterCmd = {
    id = 60030,
    req = "Cmd.SaveLoveLetterCmd",
    ack = "Cmd.SaveLoveLetterCmd",
    from = "SceneItem"
  },
  ItemDataShow = {
    id = 60031,
    req = "Cmd.ItemDataShow",
    ack = "Cmd.ItemDataShow",
    from = "SceneItem"
  },
  LotteryCmd = {
    id = 60032,
    req = "Cmd.LotteryCmd",
    ack = "Cmd.LotteryCmd",
    from = "SceneItem"
  },
  LotteryRecoveryCmd = {
    id = 60033,
    req = "Cmd.LotteryRecoveryCmd",
    ack = "Cmd.LotteryRecoveryCmd",
    from = "SceneItem"
  },
  QueryLotteryInfo = {
    id = 60034,
    req = "Cmd.QueryLotteryInfo",
    ack = "Cmd.QueryLotteryInfo",
    from = "SceneItem"
  },
  ReqQuotaLogCmd = {
    id = 60040,
    req = "Cmd.ReqQuotaLogCmd",
    ack = "Cmd.ReqQuotaLogCmd",
    from = "SceneItem"
  },
  ReqQuotaDetailCmd = {
    id = 60041,
    req = "Cmd.ReqQuotaDetailCmd",
    ack = "Cmd.ReqQuotaDetailCmd",
    from = "SceneItem"
  },
  EquipPosDataUpdate = {
    id = 60042,
    req = "Cmd.EquipPosDataUpdate",
    ack = "Cmd.EquipPosDataUpdate",
    from = "SceneItem"
  },
  HighRefineMatComposeCmd = {
    id = 60036,
    req = "Cmd.HighRefineMatComposeCmd",
    ack = "Cmd.HighRefineMatComposeCmd",
    from = "SceneItem"
  },
  HighRefineCmd = {
    id = 60037,
    req = "Cmd.HighRefineCmd",
    ack = "Cmd.HighRefineCmd",
    from = "SceneItem"
  },
  NtfHighRefineDataCmd = {
    id = 60038,
    req = "Cmd.NtfHighRefineDataCmd",
    ack = "Cmd.NtfHighRefineDataCmd",
    from = "SceneItem"
  },
  UpdateHighRefineDataCmd = {
    id = 60039,
    req = "Cmd.UpdateHighRefineDataCmd",
    ack = "Cmd.UpdateHighRefineDataCmd",
    from = "SceneItem"
  },
  UseCodItemCmd = {
    id = 60043,
    req = "Cmd.UseCodItemCmd",
    ack = "Cmd.UseCodItemCmd",
    from = "SceneItem"
  },
  AddJobLevelItemCmd = {
    id = 60044,
    req = "Cmd.AddJobLevelItemCmd",
    ack = "Cmd.AddJobLevelItemCmd",
    from = "SceneItem"
  },
  LotterGivBuyCountCmd = {
    id = 60046,
    req = "Cmd.LotterGivBuyCountCmd",
    ack = "Cmd.LotterGivBuyCountCmd",
    from = "SceneItem"
  },
  GiveWeddingDressCmd = {
    id = 60047,
    req = "Cmd.GiveWeddingDressCmd",
    ack = "Cmd.GiveWeddingDressCmd",
    from = "SceneItem"
  },
  QuickStoreItemCmd = {
    id = 60048,
    req = "Cmd.QuickStoreItemCmd",
    ack = "Cmd.QuickStoreItemCmd",
    from = "SceneItem"
  },
  QuickSellItemCmd = {
    id = 60049,
    req = "Cmd.QuickSellItemCmd",
    ack = "Cmd.QuickSellItemCmd",
    from = "SceneItem"
  },
  EnchantTransItemCmd = {
    id = 60050,
    req = "Cmd.EnchantTransItemCmd",
    ack = "Cmd.EnchantTransItemCmd",
    from = "SceneItem"
  },
  QueryLotteryHeadItemCmd = {
    id = 60051,
    req = "Cmd.QueryLotteryHeadItemCmd",
    ack = "Cmd.QueryLotteryHeadItemCmd",
    from = "SceneItem"
  },
  LotteryRateQueryCmd = {
    id = 60052,
    req = "Cmd.LotteryRateQueryCmd",
    ack = "Cmd.LotteryRateQueryCmd",
    from = "SceneItem"
  },
  EquipComposeItemCmd = {
    id = 60053,
    req = "Cmd.EquipComposeItemCmd",
    ack = "Cmd.EquipComposeItemCmd",
    from = "SceneItem"
  },
  QueryDebtItemCmd = {
    id = 60054,
    req = "Cmd.QueryDebtItemCmd",
    ack = "Cmd.QueryDebtItemCmd",
    from = "SceneItem"
  },
  LotteryActivityNtfCmd = {
    id = 60057,
    req = "Cmd.LotteryActivityNtfCmd",
    ack = "Cmd.LotteryActivityNtfCmd",
    from = "SceneItem"
  },
  FavoriteItemActionItemCmd = {
    id = 60056,
    req = "Cmd.FavoriteItemActionItemCmd",
    ack = "Cmd.FavoriteItemActionItemCmd",
    from = "SceneItem"
  },
  QueryLotteryExtraBonusItemCmd = {
    id = 60059,
    req = "Cmd.QueryLotteryExtraBonusItemCmd",
    ack = "Cmd.QueryLotteryExtraBonusItemCmd",
    from = "SceneItem"
  },
  QueryLotteryExtraBonusCfgCmd = {
    id = 60120,
    req = "Cmd.QueryLotteryExtraBonusCfgCmd",
    ack = "Cmd.QueryLotteryExtraBonusCfgCmd",
    from = "SceneItem"
  },
  GetLotteryExtraBonusItemCmd = {
    id = 60060,
    req = "Cmd.GetLotteryExtraBonusItemCmd",
    ack = "Cmd.GetLotteryExtraBonusItemCmd",
    from = "SceneItem"
  },
  RollCatLitterBoxItemCmd = {
    id = 60058,
    req = "Cmd.RollCatLitterBoxItemCmd",
    ack = "Cmd.RollCatLitterBoxItemCmd",
    from = "SceneItem"
  },
  AlterFashionEquipBuffCmd = {
    id = 60063,
    req = "Cmd.AlterFashionEquipBuffCmd",
    ack = "Cmd.AlterFashionEquipBuffCmd",
    from = "SceneItem"
  },
  QueryRideLotteryInfo = {
    id = 60061,
    req = "Cmd.QueryRideLotteryInfo",
    ack = "Cmd.QueryRideLotteryInfo",
    from = "SceneItem"
  },
  ExecRideLotteryCmd = {
    id = 60062,
    req = "Cmd.ExecRideLotteryCmd",
    ack = "Cmd.ExecRideLotteryCmd",
    from = "SceneItem"
  },
  GemSkillAppraisalItemCmd = {
    id = 60064,
    req = "Cmd.GemSkillAppraisalItemCmd",
    ack = "Cmd.GemSkillAppraisalItemCmd",
    from = "SceneItem"
  },
  GemSkillComposeSameItemCmd = {
    id = 60065,
    req = "Cmd.GemSkillComposeSameItemCmd",
    ack = "Cmd.GemSkillComposeSameItemCmd",
    from = "SceneItem"
  },
  GemSkillComposeQualityItemCmd = {
    id = 60066,
    req = "Cmd.GemSkillComposeQualityItemCmd",
    ack = "Cmd.GemSkillComposeQualityItemCmd",
    from = "SceneItem"
  },
  GemAttrComposeItemCmd = {
    id = 60067,
    req = "Cmd.GemAttrComposeItemCmd",
    ack = "Cmd.GemAttrComposeItemCmd",
    from = "SceneItem"
  },
  GemAttrUpgradeItemCmd = {
    id = 60068,
    req = "Cmd.GemAttrUpgradeItemCmd",
    ack = "Cmd.GemAttrUpgradeItemCmd",
    from = "SceneItem"
  },
  GemMountItemCmd = {
    id = 60069,
    req = "Cmd.GemMountItemCmd",
    ack = "Cmd.GemMountItemCmd",
    from = "SceneItem"
  },
  GemUnmountItemCmd = {
    id = 60070,
    req = "Cmd.GemUnmountItemCmd",
    ack = "Cmd.GemUnmountItemCmd",
    from = "SceneItem"
  },
  GemCarveItemCmd = {
    id = 60071,
    req = "Cmd.GemCarveItemCmd",
    ack = "Cmd.GemCarveItemCmd",
    from = "SceneItem"
  },
  GemSmeltItemCmd = {
    id = 60074,
    req = "Cmd.GemSmeltItemCmd",
    ack = "Cmd.GemSmeltItemCmd",
    from = "SceneItem"
  },
  RideLotteyPickItemCmd = {
    id = 60072,
    req = "Cmd.RideLotteyPickItemCmd",
    ack = "Cmd.RideLotteyPickItemCmd",
    from = "SceneItem"
  },
  RideLotteyPickInfoCmd = {
    id = 60073,
    req = "Cmd.RideLotteyPickInfoCmd",
    ack = "Cmd.RideLotteyPickInfoCmd",
    from = "SceneItem"
  },
  SandExchangeItemCmd = {
    id = 60075,
    req = "Cmd.SandExchangeItemCmd",
    ack = "Cmd.SandExchangeItemCmd",
    from = "SceneItem"
  },
  GemDataUpdateItemCmd = {
    id = 60076,
    req = "Cmd.GemDataUpdateItemCmd",
    ack = "Cmd.GemDataUpdateItemCmd",
    from = "SceneItem"
  },
  LotteryDollQueryItemCmd = {
    id = 60081,
    req = "Cmd.LotteryDollQueryItemCmd",
    ack = "Cmd.LotteryDollQueryItemCmd",
    from = "SceneItem"
  },
  LotteryDollPayItemCmd = {
    id = 60082,
    req = "Cmd.LotteryDollPayItemCmd",
    ack = "Cmd.LotteryDollPayItemCmd",
    from = "SceneItem"
  },
  PersonalArtifactExchangeItemCmd = {
    id = 60083,
    req = "Cmd.PersonalArtifactExchangeItemCmd",
    ack = "Cmd.PersonalArtifactExchangeItemCmd",
    from = "SceneItem"
  },
  PersonalArtifactDecomposeItemCmd = {
    id = 60084,
    req = "Cmd.PersonalArtifactDecomposeItemCmd",
    ack = "Cmd.PersonalArtifactDecomposeItemCmd",
    from = "SceneItem"
  },
  PersonalArtifactComposeItemCmd = {
    id = 60085,
    req = "Cmd.PersonalArtifactComposeItemCmd",
    ack = "Cmd.PersonalArtifactComposeItemCmd",
    from = "SceneItem"
  },
  PersonalArtifactRemouldItemCmd = {
    id = 60086,
    req = "Cmd.PersonalArtifactRemouldItemCmd",
    ack = "Cmd.PersonalArtifactRemouldItemCmd",
    from = "SceneItem"
  },
  PersonalArtifactAttrSaveItemCmd = {
    id = 60087,
    req = "Cmd.PersonalArtifactAttrSaveItemCmd",
    ack = "Cmd.PersonalArtifactAttrSaveItemCmd",
    from = "SceneItem"
  },
  PersonalArtifactAppraisalItemCmd = {
    id = 60090,
    req = "Cmd.PersonalArtifactAppraisalItemCmd",
    ack = "Cmd.PersonalArtifactAppraisalItemCmd",
    from = "SceneItem"
  },
  EquipPosCDNtfItemCmd = {
    id = 60096,
    req = "Cmd.EquipPosCDNtfItemCmd",
    ack = "Cmd.EquipPosCDNtfItemCmd",
    from = "SceneItem"
  },
  BatchRefineItemCmd = {
    id = 60088,
    req = "Cmd.BatchRefineItemCmd",
    ack = "Cmd.BatchRefineItemCmd",
    from = "SceneItem"
  },
  MixLotteryArchiveCmd = {
    id = 60091,
    req = "Cmd.MixLotteryArchiveCmd",
    ack = "Cmd.MixLotteryArchiveCmd",
    from = "SceneItem"
  },
  QueryPackMailItemCmd = {
    id = 60107,
    req = "Cmd.QueryPackMailItemCmd",
    ack = "Cmd.QueryPackMailItemCmd",
    from = "SceneItem"
  },
  PackMailUpdateItemCmd = {
    id = 60108,
    req = "Cmd.PackMailUpdateItemCmd",
    ack = "Cmd.PackMailUpdateItemCmd",
    from = "SceneItem"
  },
  PackMailActionItemCmd = {
    id = 60109,
    req = "Cmd.PackMailActionItemCmd",
    ack = "Cmd.PackMailActionItemCmd",
    from = "SceneItem"
  },
  FavoriteQueryItemCmd = {
    id = 60110,
    req = "Cmd.FavoriteQueryItemCmd",
    ack = "Cmd.FavoriteQueryItemCmd",
    from = "SceneItem"
  },
  FavoriteGiveItemCmd = {
    id = 60111,
    req = "Cmd.FavoriteGiveItemCmd",
    ack = "Cmd.FavoriteGiveItemCmd",
    from = "SceneItem"
  },
  FavoriteRewardItemCmd = {
    id = 60112,
    req = "Cmd.FavoriteRewardItemCmd",
    ack = "Cmd.FavoriteRewardItemCmd",
    from = "SceneItem"
  },
  FavoriteInteractItemCmd = {
    id = 60113,
    req = "Cmd.FavoriteInteractItemCmd",
    ack = "Cmd.FavoriteInteractItemCmd",
    from = "SceneItem"
  },
  FavoriteDesireConditionItemCmd = {
    id = 60116,
    req = "Cmd.FavoriteDesireConditionItemCmd",
    ack = "Cmd.FavoriteDesireConditionItemCmd",
    from = "SceneItem"
  },
  EquipEnchantTransferItemCmd = {
    id = 60097,
    req = "Cmd.EquipEnchantTransferItemCmd",
    ack = "Cmd.EquipEnchantTransferItemCmd",
    from = "SceneItem"
  },
  EquipRefineTransferItemCmd = {
    id = 60098,
    req = "Cmd.EquipRefineTransferItemCmd",
    ack = "Cmd.EquipRefineTransferItemCmd",
    from = "SceneItem"
  },
  EquipPowerInputItemCmd = {
    id = 60099,
    req = "Cmd.EquipPowerInputItemCmd",
    ack = "Cmd.EquipPowerInputItemCmd",
    from = "SceneItem"
  },
  EquipPowerOutputItemCmd = {
    id = 60100,
    req = "Cmd.EquipPowerOutputItemCmd",
    ack = "Cmd.EquipPowerOutputItemCmd",
    from = "SceneItem"
  },
  ColoringQueryItemCmd = {
    id = 60101,
    req = "Cmd.ColoringQueryItemCmd",
    ack = "Cmd.ColoringQueryItemCmd",
    from = "SceneItem"
  },
  ColoringModifyItemCmd = {
    id = 60102,
    req = "Cmd.ColoringModifyItemCmd",
    ack = "Cmd.ColoringModifyItemCmd",
    from = "SceneItem"
  },
  ColoringShareItemCmd = {
    id = 60103,
    req = "Cmd.ColoringShareItemCmd",
    ack = "Cmd.ColoringShareItemCmd",
    from = "SceneItem"
  },
  PosStrengthItemCmd = {
    id = 60104,
    req = "Cmd.PosStrengthItemCmd",
    ack = "Cmd.PosStrengthItemCmd",
    from = "SceneItem"
  },
  LotteryHeadwearExchange = {
    id = 60115,
    req = "Cmd.LotteryHeadwearExchange",
    ack = "Cmd.LotteryHeadwearExchange",
    from = "SceneItem"
  },
  RandSelectRewardItemCmd = {
    id = 60106,
    req = "Cmd.RandSelectRewardItemCmd",
    ack = "Cmd.RandSelectRewardItemCmd",
    from = "SceneItem"
  },
  EquipRecoveryQueryItemCmd = {
    id = 60118,
    req = "Cmd.EquipRecoveryQueryItemCmd",
    ack = "Cmd.EquipRecoveryQueryItemCmd",
    from = "SceneItem"
  },
  EquipRecoveryItemCmd = {
    id = 60119,
    req = "Cmd.EquipRecoveryItemCmd",
    ack = "Cmd.EquipRecoveryItemCmd",
    from = "SceneItem"
  },
  OneClickPutTakeStoreCmd = {
    id = 60114,
    req = "Cmd.OneClickPutTakeStoreCmd",
    ack = "Cmd.OneClickPutTakeStoreCmd",
    from = "SceneItem"
  },
  QuestionResultItemCmd = {
    id = 60117,
    req = "Cmd.QuestionResultItemCmd",
    ack = "Cmd.QuestionResultItemCmd",
    from = "SceneItem"
  },
  PosStrengthSyncItemCmd = {
    id = 60105,
    req = "Cmd.PosStrengthSyncItemCmd",
    ack = "Cmd.PosStrengthSyncItemCmd",
    from = "SceneItem"
  },
  EquipPowerQuery = {
    id = 60121,
    req = "Cmd.EquipPowerQuery",
    ack = "Cmd.EquipPowerQuery",
    from = "SceneItem"
  },
  MagicSuitSave = {
    id = 60092,
    req = "Cmd.MagicSuitSave",
    ack = "Cmd.MagicSuitSave",
    from = "SceneItem"
  },
  MagicSuitNtf = {
    id = 60094,
    req = "Cmd.MagicSuitNtf",
    ack = "Cmd.MagicSuitNtf",
    from = "SceneItem"
  },
  MagicSuitApply = {
    id = 60093,
    req = "Cmd.MagicSuitApply",
    ack = "Cmd.MagicSuitApply",
    from = "SceneItem"
  },
  PotionStoreNtf = {
    id = 60095,
    req = "Cmd.PotionStoreNtf",
    ack = "Cmd.PotionStoreNtf",
    from = "SceneItem"
  },
  EnchantHighestBuffNotify = {
    id = 60123,
    req = "Cmd.EnchantHighestBuffNotify",
    ack = "Cmd.EnchantHighestBuffNotify",
    from = "SceneItem"
  },
  LotteryDataSyncItemCmd = {
    id = 60124,
    req = "Cmd.LotteryDataSyncItemCmd",
    ack = "Cmd.LotteryDataSyncItemCmd",
    from = "SceneItem"
  },
  ArtifactFlagmentAdd = {
    id = 60125,
    req = "Cmd.ArtifactFlagmentAdd",
    ack = "Cmd.ArtifactFlagmentAdd",
    from = "SceneItem"
  },
  LotteryDailyRewardSyncItemCmd = {
    id = 60127,
    req = "Cmd.LotteryDailyRewardSyncItemCmd",
    ack = "Cmd.LotteryDailyRewardSyncItemCmd",
    from = "SceneItem"
  },
  LotteryDailyRewardGetItemCmd = {
    id = 60128,
    req = "Cmd.LotteryDailyRewardGetItemCmd",
    ack = "Cmd.LotteryDailyRewardGetItemCmd",
    from = "SceneItem"
  },
  AutoSellItemCmd = {
    id = 60126,
    req = "Cmd.AutoSellItemCmd",
    ack = "Cmd.AutoSellItemCmd",
    from = "SceneItem"
  },
  QueryAfricanPoringItemCmd = {
    id = 60129,
    req = "Cmd.QueryAfricanPoringItemCmd",
    ack = "Cmd.QueryAfricanPoringItemCmd",
    from = "SceneItem"
  },
  AfricanPoringUpdateItemCmd = {
    id = 60130,
    req = "Cmd.AfricanPoringUpdateItemCmd",
    ack = "Cmd.AfricanPoringUpdateItemCmd",
    from = "SceneItem"
  },
  AfricanPoringLotteryItemCmd = {
    id = 60131,
    req = "Cmd.AfricanPoringLotteryItemCmd",
    ack = "Cmd.AfricanPoringLotteryItemCmd",
    from = "SceneItem"
  },
  ExtractLevelUpItemCmd = {
    id = 60135,
    req = "Cmd.ExtractLevelUpItemCmd",
    ack = "Cmd.ExtractLevelUpItemCmd",
    from = "SceneItem"
  },
  EnchantRefreshAttr = {
    id = 60132,
    req = "Cmd.EnchantRefreshAttr",
    ack = "Cmd.EnchantRefreshAttr",
    from = "SceneItem"
  },
  ProcessEnchantRefreshAttr = {
    id = 60133,
    req = "Cmd.ProcessEnchantRefreshAttr",
    ack = "Cmd.ProcessEnchantRefreshAttr",
    from = "SceneItem"
  },
  EnchantUpgradeAttr = {
    id = 60134,
    req = "Cmd.EnchantUpgradeAttr",
    ack = "Cmd.EnchantUpgradeAttr",
    from = "SceneItem"
  },
  RefreshEquipAttrCmd = {
    id = 60136,
    req = "Cmd.RefreshEquipAttrCmd",
    ack = "Cmd.RefreshEquipAttrCmd",
    from = "SceneItem"
  },
  QuenchEquipItemCmd = {
    id = 60139,
    req = "Cmd.QuenchEquipItemCmd",
    ack = "Cmd.QuenchEquipItemCmd",
    from = "SceneItem"
  },
  MountFashionSyncCmd = {
    id = 60140,
    req = "Cmd.MountFashionSyncCmd",
    ack = "Cmd.MountFashionSyncCmd",
    from = "SceneItem"
  },
  MountFashionChangeCmd = {
    id = 60141,
    req = "Cmd.MountFashionChangeCmd",
    ack = "Cmd.MountFashionChangeCmd",
    from = "SceneItem"
  },
  EquipPromote = {
    id = 60137,
    req = "Cmd.EquipPromote",
    ack = "Cmd.EquipPromote",
    from = "SceneItem"
  },
  SwitchFashionEquipRecordItemCmd = {
    id = 60142,
    req = "Cmd.SwitchFashionEquipRecordItemCmd",
    ack = "Cmd.SwitchFashionEquipRecordItemCmd",
    from = "SceneItem"
  },
  OldItemExchangeItemCmd = {
    id = 60138,
    req = "Cmd.OldItemExchangeItemCmd",
    ack = "Cmd.OldItemExchangeItemCmd",
    from = "SceneItem"
  },
  BuyMixLotteryItemCmd = {
    id = 60143,
    req = "Cmd.BuyMixLotteryItemCmd",
    ack = "Cmd.BuyMixLotteryItemCmd",
    from = "SceneItem"
  },
  CardLotteryPrayItemCmd = {
    id = 60144,
    req = "Cmd.CardLotteryPrayItemCmd",
    ack = "Cmd.CardLotteryPrayItemCmd",
    from = "SceneItem"
  },
  SyncCardLotteryPrayItemCmd = {
    id = 60145,
    req = "Cmd.SyncCardLotteryPrayItemCmd",
    ack = "Cmd.SyncCardLotteryPrayItemCmd",
    from = "SceneItem"
  },
  GemBagExpSyncItemCmd = {
    id = 60153,
    req = "Cmd.GemBagExpSyncItemCmd",
    ack = "Cmd.GemBagExpSyncItemCmd",
    from = "SceneItem"
  },
  SecretLandGemCmd = {
    id = 60151,
    req = "Cmd.SecretLandGemCmd",
    ack = "Cmd.SecretLandGemCmd",
    from = "SceneItem"
  },
  MountFashionQueryStateCmd = {
    id = 60146,
    req = "Cmd.MountFashionQueryStateCmd",
    ack = "Cmd.MountFashionQueryStateCmd",
    from = "SceneItem"
  },
  MountFashionActiveCmd = {
    id = 60147,
    req = "Cmd.MountFashionActiveCmd",
    ack = "Cmd.MountFashionActiveCmd",
    from = "SceneItem"
  },
  StorePutItemItemCmd = {
    id = 60148,
    req = "Cmd.StorePutItemItemCmd",
    ack = "Cmd.StorePutItemItemCmd",
    from = "SceneItem"
  },
  StoreOffItemItemCmd = {
    id = 60149,
    req = "Cmd.StoreOffItemItemCmd",
    ack = "Cmd.StoreOffItemItemCmd",
    from = "SceneItem"
  },
  FullGemSkill = {
    id = 60154,
    req = "Cmd.FullGemSkill",
    ack = "Cmd.FullGemSkill",
    from = "SceneItem"
  },
  QueryBossCardComposeRateCmd = {
    id = 60155,
    req = "Cmd.QueryBossCardComposeRateCmd",
    ack = "Cmd.QueryBossCardComposeRateCmd",
    from = "SceneItem"
  },
  MemoryEmbedItemCmd = {
    id = 60156,
    req = "Cmd.MemoryEmbedItemCmd",
    ack = "Cmd.MemoryEmbedItemCmd",
    from = "SceneItem"
  },
  MemoryUnEmbedItemCmd = {
    id = 60157,
    req = "Cmd.MemoryUnEmbedItemCmd",
    ack = "Cmd.MemoryUnEmbedItemCmd",
    from = "SceneItem"
  },
  MemoryLevelupItemCmd = {
    id = 60158,
    req = "Cmd.MemoryLevelupItemCmd",
    ack = "Cmd.MemoryLevelupItemCmd",
    from = "SceneItem"
  },
  MemoryDecomposeItemCmd = {
    id = 60159,
    req = "Cmd.MemoryDecomposeItemCmd",
    ack = "Cmd.MemoryDecomposeItemCmd",
    from = "SceneItem"
  },
  MemoryEffectOperItemCmd = {
    id = 60160,
    req = "Cmd.MemoryEffectOperItemCmd",
    ack = "Cmd.MemoryEffectOperItemCmd",
    from = "SceneItem"
  },
  MemoryAutoDecomposeOptionItemCmd = {
    id = 60161,
    req = "Cmd.MemoryAutoDecomposeOptionItemCmd",
    ack = "Cmd.MemoryAutoDecomposeOptionItemCmd",
    from = "SceneItem"
  },
  UpdateMemoryPosItemCmd = {
    id = 60162,
    req = "Cmd.UpdateMemoryPosItemCmd",
    ack = "Cmd.UpdateMemoryPosItemCmd",
    from = "SceneItem"
  },
  DecomposeGemItemCmd = {
    id = 60163,
    req = "Cmd.DecomposeGemItemCmd",
    ack = "Cmd.DecomposeGemItemCmd",
    from = "SceneItem"
  },
  UpgradeGemItemCmd = {
    id = 60164,
    req = "Cmd.UpgradeGemItemCmd",
    ack = "Cmd.UpgradeGemItemCmd",
    from = "SceneItem"
  },
  MemoryUpgradeItemCmd = {
    id = 60165,
    req = "Cmd.MemoryUpgradeItemCmd",
    ack = "Cmd.MemoryUpgradeItemCmd",
    from = "SceneItem"
  },
  CardLevelupItemCmd = {
    id = 60166,
    req = "Cmd.CardLevelupItemCmd",
    ack = "Cmd.CardLevelupItemCmd",
    from = "SceneItem"
  },
  BalanceModeMemorySetItemCmd = {
    id = 60167,
    req = "Cmd.BalanceModeMemorySetItemCmd",
    ack = "Cmd.BalanceModeMemorySetItemCmd",
    from = "SceneItem"
  },
  BalanceModeMemoryUpdateItemCmd = {
    id = 60168,
    req = "Cmd.BalanceModeMemoryUpdateItemCmd",
    ack = "Cmd.BalanceModeMemoryUpdateItemCmd",
    from = "SceneItem"
  },
  MemoryExcessItemCmd = {
    id = 60169,
    req = "Cmd.MemoryExcessItemCmd",
    ack = "Cmd.MemoryExcessItemCmd",
    from = "SceneItem"
  },
  BuildDataNtfManorCmd = {
    id = 2330001,
    req = "Cmd.BuildDataNtfManorCmd",
    ack = "Cmd.BuildDataNtfManorCmd",
    from = "SceneManor"
  },
  BuildQueryManorCmd = {
    id = 2330002,
    req = "Cmd.BuildQueryManorCmd",
    ack = "Cmd.BuildQueryManorCmd",
    from = "SceneManor"
  },
  BuildLevelUpManorCmd = {
    id = 2330003,
    req = "Cmd.BuildLevelUpManorCmd",
    ack = "Cmd.BuildLevelUpManorCmd",
    from = "SceneManor"
  },
  BuildDispatchManorCmd = {
    id = 2330004,
    req = "Cmd.BuildDispatchManorCmd",
    ack = "Cmd.BuildDispatchManorCmd",
    from = "SceneManor"
  },
  BuildLotteryManorCmd = {
    id = 2330005,
    req = "Cmd.BuildLotteryManorCmd",
    ack = "Cmd.BuildLotteryManorCmd",
    from = "SceneManor"
  },
  BuildCollectManorCmd = {
    id = 2330006,
    req = "Cmd.BuildCollectManorCmd",
    ack = "Cmd.BuildCollectManorCmd",
    from = "SceneManor"
  },
  ReqEnterRaidManorCmd = {
    id = 2330007,
    req = "Cmd.ReqEnterRaidManorCmd",
    ack = "Cmd.ReqEnterRaidManorCmd",
    from = "SceneManor"
  },
  PartnerInfoManorCmd = {
    id = 2330008,
    req = "Cmd.PartnerInfoManorCmd",
    ack = "Cmd.PartnerInfoManorCmd",
    from = "SceneManor"
  },
  PartnerStroyManorCmd = {
    id = 2330009,
    req = "Cmd.PartnerStroyManorCmd",
    ack = "Cmd.PartnerStroyManorCmd",
    from = "SceneManor"
  },
  PartnerIdleListManorCmd = {
    id = 2330010,
    req = "Cmd.PartnerIdleListManorCmd",
    ack = "Cmd.PartnerIdleListManorCmd",
    from = "SceneManor"
  },
  PartnerIdleUpdateManorCmd = {
    id = 2330011,
    req = "Cmd.PartnerIdleUpdateManorCmd",
    ack = "Cmd.PartnerIdleUpdateManorCmd",
    from = "SceneManor"
  },
  PartnerGiveManorCmd = {
    id = 2330012,
    req = "Cmd.PartnerGiveManorCmd",
    ack = "Cmd.PartnerGiveManorCmd",
    from = "SceneManor"
  },
  BuildForgeManorCmd = {
    id = 2330013,
    req = "Cmd.BuildForgeManorCmd",
    ack = "Cmd.BuildForgeManorCmd",
    from = "SceneManor"
  },
  SmithInfoManorCmd = {
    id = 2330014,
    req = "Cmd.SmithInfoManorCmd",
    ack = "Cmd.SmithInfoManorCmd",
    from = "SceneManor"
  },
  SmithLevelUpManorCmd = {
    id = 2330015,
    req = "Cmd.SmithLevelUpManorCmd",
    ack = "Cmd.SmithLevelUpManorCmd",
    from = "SceneManor"
  },
  SmithAcceptQuestManorCmd = {
    id = 2330016,
    req = "Cmd.SmithAcceptQuestManorCmd",
    ack = "Cmd.SmithAcceptQuestManorCmd",
    from = "SceneManor"
  },
  QueryVersion = {
    id = 230001,
    req = "Cmd.QueryVersion",
    ack = "Cmd.QueryVersion",
    from = "SceneManual"
  },
  QueryManualData = {
    id = 230002,
    req = "Cmd.QueryManualData",
    ack = "Cmd.QueryManualData",
    from = "SceneManual"
  },
  PointSync = {
    id = 230003,
    req = "Cmd.PointSync",
    ack = "Cmd.PointSync",
    from = "SceneManual"
  },
  ManualUpdate = {
    id = 230004,
    req = "Cmd.ManualUpdate",
    ack = "Cmd.ManualUpdate",
    from = "SceneManual"
  },
  GetAchieveReward = {
    id = 230005,
    req = "Cmd.GetAchieveReward",
    ack = "Cmd.GetAchieveReward",
    from = "SceneManual"
  },
  Unlock = {
    id = 230006,
    req = "Cmd.Unlock",
    ack = "Cmd.Unlock",
    from = "SceneManual"
  },
  SkillPointSync = {
    id = 230007,
    req = "Cmd.SkillPointSync",
    ack = "Cmd.SkillPointSync",
    from = "SceneManual"
  },
  LevelSync = {
    id = 230008,
    req = "Cmd.LevelSync",
    ack = "Cmd.LevelSync",
    from = "SceneManual"
  },
  GetQuestReward = {
    id = 230009,
    req = "Cmd.GetQuestReward",
    ack = "Cmd.GetQuestReward",
    from = "SceneManual"
  },
  StoreManualCmd = {
    id = 230010,
    req = "Cmd.StoreManualCmd",
    ack = "Cmd.StoreManualCmd",
    from = "SceneManual"
  },
  GetManualCmd = {
    id = 230011,
    req = "Cmd.GetManualCmd",
    ack = "Cmd.GetManualCmd",
    from = "SceneManual"
  },
  GroupActionManualCmd = {
    id = 230012,
    req = "Cmd.GroupActionManualCmd",
    ack = "Cmd.GroupActionManualCmd",
    from = "SceneManual"
  },
  QueryUnsolvedPhotoManualCmd = {
    id = 230013,
    req = "Cmd.QueryUnsolvedPhotoManualCmd",
    ack = "Cmd.QueryUnsolvedPhotoManualCmd",
    from = "SceneManual"
  },
  UpdateSolvedPhotoManualCmd = {
    id = 230014,
    req = "Cmd.UpdateSolvedPhotoManualCmd",
    ack = "Cmd.UpdateSolvedPhotoManualCmd",
    from = "SceneManual"
  },
  NpcZoneDataManualCmd = {
    id = 230015,
    req = "Cmd.NpcZoneDataManualCmd",
    ack = "Cmd.NpcZoneDataManualCmd",
    from = "SceneManual"
  },
  NpcZoneRewardManualCmd = {
    id = 230016,
    req = "Cmd.NpcZoneRewardManualCmd",
    ack = "Cmd.NpcZoneRewardManualCmd",
    from = "SceneManual"
  },
  CollectionRewardManualCmd = {
    id = 230017,
    req = "Cmd.CollectionRewardManualCmd",
    ack = "Cmd.CollectionRewardManualCmd",
    from = "SceneManual"
  },
  UnlockQuickManualCmd = {
    id = 230018,
    req = "Cmd.UnlockQuickManualCmd",
    ack = "Cmd.UnlockQuickManualCmd",
    from = "SceneManual"
  },
  GetQuestRewardQuickManualCmd = {
    id = 230019,
    req = "Cmd.GetQuestRewardQuickManualCmd",
    ack = "Cmd.GetQuestRewardQuickManualCmd",
    from = "SceneManual"
  },
  AddMapItem = {
    id = 120001,
    req = "Cmd.AddMapItem",
    ack = "Cmd.AddMapItem",
    from = "SceneMap"
  },
  PickupItem = {
    id = 120002,
    req = "Cmd.PickupItem",
    ack = "Cmd.PickupItem",
    from = "SceneMap"
  },
  SyncGemSecretLandNineData = {
    id = 120034,
    req = "Cmd.SyncGemSecretLandNineData",
    ack = "Cmd.SyncGemSecretLandNineData",
    from = "SceneMap"
  },
  AddMapUser = {
    id = 120003,
    req = "Cmd.AddMapUser",
    ack = "Cmd.AddMapUser",
    from = "SceneMap"
  },
  AddMapNpc = {
    id = 120004,
    req = "Cmd.AddMapNpc",
    ack = "Cmd.AddMapNpc",
    from = "SceneMap"
  },
  AddMapTrap = {
    id = 120005,
    req = "Cmd.AddMapTrap",
    ack = "Cmd.AddMapTrap",
    from = "SceneMap"
  },
  AddMapAct = {
    id = 120006,
    req = "Cmd.AddMapAct",
    ack = "Cmd.AddMapAct",
    from = "SceneMap"
  },
  ExitPointState = {
    id = 120007,
    req = "Cmd.ExitPointState",
    ack = "Cmd.ExitPointState",
    from = "SceneMap"
  },
  MapCmdEnd = {
    id = 120008,
    req = "Cmd.MapCmdEnd",
    ack = "Cmd.MapCmdEnd",
    from = "SceneMap"
  },
  NpcSearchRangeCmd = {
    id = 120009,
    req = "Cmd.NpcSearchRangeCmd",
    ack = "Cmd.NpcSearchRangeCmd",
    from = "SceneMap"
  },
  UserHandsCmd = {
    id = 120010,
    req = "Cmd.UserHandsCmd",
    ack = "Cmd.UserHandsCmd",
    from = "SceneMap"
  },
  SpEffectCmd = {
    id = 120011,
    req = "Cmd.SpEffectCmd",
    ack = "Cmd.SpEffectCmd",
    from = "SceneMap"
  },
  UserHandNpcCmd = {
    id = 120012,
    req = "Cmd.UserHandNpcCmd",
    ack = "Cmd.UserHandNpcCmd",
    from = "SceneMap"
  },
  GingerBreadNpcCmd = {
    id = 120013,
    req = "Cmd.GingerBreadNpcCmd",
    ack = "Cmd.GingerBreadNpcCmd",
    from = "SceneMap"
  },
  GoCityGateMapCmd = {
    id = 120014,
    req = "Cmd.GoCityGateMapCmd",
    ack = "Cmd.GoCityGateMapCmd",
    from = "SceneMap"
  },
  UserSecretQueryMapCmd = {
    id = 120016,
    req = "Cmd.UserSecretQueryMapCmd",
    ack = "Cmd.UserSecretQueryMapCmd",
    from = "SceneMap"
  },
  UserSecretGetMapCmd = {
    id = 120017,
    req = "Cmd.UserSecretGetMapCmd",
    ack = "Cmd.UserSecretGetMapCmd",
    from = "SceneMap"
  },
  EditNpcTextMapCmd = {
    id = 120015,
    req = "Cmd.EditNpcTextMapCmd",
    ack = "Cmd.EditNpcTextMapCmd",
    from = "SceneMap"
  },
  ObjStateSyncMapCmd = {
    id = 120018,
    req = "Cmd.ObjStateSyncMapCmd",
    ack = "Cmd.ObjStateSyncMapCmd",
    from = "SceneMap"
  },
  AddMapObjNpc = {
    id = 120019,
    req = "Cmd.AddMapObjNpc",
    ack = "Cmd.AddMapObjNpc",
    from = "SceneMap"
  },
  TeamFollowBanListCmd = {
    id = 2090020,
    req = "Cmd.TeamFollowBanListCmd",
    ack = "Cmd.TeamFollowBanListCmd",
    from = "SceneMap"
  },
  FuncBuildNpcSyncCmd = {
    id = 120022,
    req = "Cmd.FuncBuildNpcSyncCmd",
    ack = "Cmd.FuncBuildNpcSyncCmd",
    from = "SceneMap"
  },
  FuncBuildNpcUpdateCmd = {
    id = 120022,
    req = "Cmd.FuncBuildNpcUpdateCmd",
    ack = "Cmd.FuncBuildNpcUpdateCmd",
    from = "SceneMap"
  },
  QueryCloneMapStatusMapCmd = {
    id = 120023,
    req = "Cmd.QueryCloneMapStatusMapCmd",
    ack = "Cmd.QueryCloneMapStatusMapCmd",
    from = "SceneMap"
  },
  ChangeCloneMapCmd = {
    id = 120024,
    req = "Cmd.ChangeCloneMapCmd",
    ack = "Cmd.ChangeCloneMapCmd",
    from = "SceneMap"
  },
  StormBossAffixQueryCmd = {
    id = 120025,
    req = "Cmd.StormBossAffixQueryCmd",
    ack = "Cmd.StormBossAffixQueryCmd",
    from = "SceneMap"
  },
  BuffRewardQueryCmd = {
    id = 120026,
    req = "Cmd.BuffRewardQueryCmd",
    ack = "Cmd.BuffRewardQueryCmd",
    from = "SceneMap"
  },
  BuffRewardSelectCmd = {
    id = 120027,
    req = "Cmd.BuffRewardSelectCmd",
    ack = "Cmd.BuffRewardSelectCmd",
    from = "SceneMap"
  },
  MultiObjStateSyncMapCmd = {
    id = 120028,
    req = "Cmd.MultiObjStateSyncMapCmd",
    ack = "Cmd.MultiObjStateSyncMapCmd",
    from = "SceneMap"
  },
  UpdateZoneMapCmd = {
    id = 120029,
    req = "Cmd.UpdateZoneMapCmd",
    ack = "Cmd.UpdateZoneMapCmd",
    from = "SceneMap"
  },
  DropItem = {
    id = 120030,
    req = "Cmd.DropItem",
    ack = "Cmd.DropItem",
    from = "SceneMap"
  },
  MapNpcShowMapCmd = {
    id = 120032,
    req = "Cmd.MapNpcShowMapCmd",
    ack = "Cmd.MapNpcShowMapCmd",
    from = "SceneMap"
  },
  MapNpcDelMapCmd = {
    id = 120033,
    req = "Cmd.MapNpcDelMapCmd",
    ack = "Cmd.MapNpcDelMapCmd",
    from = "SceneMap"
  },
  NpcPreloadForbidMapCmd = {
    id = 120031,
    req = "Cmd.NpcPreloadForbidMapCmd",
    ack = "Cmd.NpcPreloadForbidMapCmd",
    from = "SceneMap"
  },
  CardRewardQueryCmd = {
    id = 120035,
    req = "Cmd.CardRewardQueryCmd",
    ack = "Cmd.CardRewardQueryCmd",
    from = "SceneMap"
  },
  SkillWeatherSyncCmd = {
    id = 120036,
    req = "Cmd.SkillWeatherSyncCmd",
    ack = "Cmd.SkillWeatherSyncCmd",
    from = "SceneMap"
  },
  AbyssAreaChangeNotifyCmd = {
    id = 120037,
    req = "Cmd.AbyssAreaChangeNotifyCmd",
    ack = "Cmd.AbyssAreaChangeNotifyCmd",
    from = "SceneMap"
  },
  AbyssBossUpdateCmd = {
    id = 120038,
    req = "Cmd.AbyssBossUpdateCmd",
    ack = "Cmd.AbyssBossUpdateCmd",
    from = "SceneMap"
  },
  ExtraRewardUpdateMapCmd = {
    id = 120039,
    req = "Cmd.ExtraRewardUpdateMapCmd",
    ack = "Cmd.ExtraRewardUpdateMapCmd",
    from = "SceneMap"
  },
  PetList = {
    id = 99999,
    req = "Cmd.PetList",
    ack = "Cmd.PetList",
    from = "ScenePet"
  },
  FireCatPetCmd = {
    id = 100002,
    req = "Cmd.FireCatPetCmd",
    ack = "Cmd.FireCatPetCmd",
    from = "ScenePet"
  },
  HireCatPetCmd = {
    id = 100003,
    req = "Cmd.HireCatPetCmd",
    ack = "Cmd.HireCatPetCmd",
    from = "ScenePet"
  },
  EggHatchPetCmd = {
    id = 100004,
    req = "Cmd.EggHatchPetCmd",
    ack = "Cmd.EggHatchPetCmd",
    from = "ScenePet"
  },
  EggRestorePetCmd = {
    id = 100005,
    req = "Cmd.EggRestorePetCmd",
    ack = "Cmd.EggRestorePetCmd",
    from = "ScenePet"
  },
  CatchValuePetCmd = {
    id = 100006,
    req = "Cmd.CatchValuePetCmd",
    ack = "Cmd.CatchValuePetCmd",
    from = "ScenePet"
  },
  CatchResultPetCmd = {
    id = 100007,
    req = "Cmd.CatchResultPetCmd",
    ack = "Cmd.CatchResultPetCmd",
    from = "ScenePet"
  },
  CatchPetPetCmd = {
    id = 100008,
    req = "Cmd.CatchPetPetCmd",
    ack = "Cmd.CatchPetPetCmd",
    from = "ScenePet"
  },
  CatchPetGiftPetCmd = {
    id = 100012,
    req = "Cmd.CatchPetGiftPetCmd",
    ack = "Cmd.CatchPetGiftPetCmd",
    from = "ScenePet"
  },
  PetInfoPetCmd = {
    id = 100009,
    req = "Cmd.PetInfoPetCmd",
    ack = "Cmd.PetInfoPetCmd",
    from = "ScenePet"
  },
  PetInfoUpdatePetCmd = {
    id = 100010,
    req = "Cmd.PetInfoUpdatePetCmd",
    ack = "Cmd.PetInfoUpdatePetCmd",
    from = "ScenePet"
  },
  PetOffPetCmd = {
    id = 100011,
    req = "Cmd.PetOffPetCmd",
    ack = "Cmd.PetOffPetCmd",
    from = "ScenePet"
  },
  GetGiftPetCmd = {
    id = 100013,
    req = "Cmd.GetGiftPetCmd",
    ack = "Cmd.GetGiftPetCmd",
    from = "ScenePet"
  },
  EquipOperPetCmd = {
    id = 100014,
    req = "Cmd.EquipOperPetCmd",
    ack = "Cmd.EquipOperPetCmd",
    from = "ScenePet"
  },
  EquipUpdatePetCmd = {
    id = 100015,
    req = "Cmd.EquipUpdatePetCmd",
    ack = "Cmd.EquipUpdatePetCmd",
    from = "ScenePet"
  },
  QueryPetAdventureListPetCmd = {
    id = 100016,
    req = "Cmd.QueryPetAdventureListPetCmd",
    ack = "Cmd.QueryPetAdventureListPetCmd",
    from = "ScenePet"
  },
  PetAdventureResultNtfPetCmd = {
    id = 100017,
    req = "Cmd.PetAdventureResultNtfPetCmd",
    ack = "Cmd.PetAdventureResultNtfPetCmd",
    from = "ScenePet"
  },
  StartAdventurePetCmd = {
    id = 100018,
    req = "Cmd.StartAdventurePetCmd",
    ack = "Cmd.StartAdventurePetCmd",
    from = "ScenePet"
  },
  GetAdventureRewardPetCmd = {
    id = 100019,
    req = "Cmd.GetAdventureRewardPetCmd",
    ack = "Cmd.GetAdventureRewardPetCmd",
    from = "ScenePet"
  },
  QueryBattlePetCmd = {
    id = 100020,
    req = "Cmd.QueryBattlePetCmd",
    ack = "Cmd.QueryBattlePetCmd",
    from = "ScenePet"
  },
  HandPetPetCmd = {
    id = 100021,
    req = "Cmd.HandPetPetCmd",
    ack = "Cmd.HandPetPetCmd",
    from = "ScenePet"
  },
  GiveGiftPetCmd = {
    id = 100022,
    req = "Cmd.GiveGiftPetCmd",
    ack = "Cmd.GiveGiftPetCmd",
    from = "ScenePet"
  },
  UnlockNtfPetCmd = {
    id = 100023,
    req = "Cmd.UnlockNtfPetCmd",
    ack = "Cmd.UnlockNtfPetCmd",
    from = "ScenePet"
  },
  ResetSkillPetCmd = {
    id = 100024,
    req = "Cmd.ResetSkillPetCmd",
    ack = "Cmd.ResetSkillPetCmd",
    from = "ScenePet"
  },
  ChangeNamePetCmd = {
    id = 100026,
    req = "Cmd.ChangeNamePetCmd",
    ack = "Cmd.ChangeNamePetCmd",
    from = "ScenePet"
  },
  SwitchSkillPetCmd = {
    id = 100027,
    req = "Cmd.SwitchSkillPetCmd",
    ack = "Cmd.SwitchSkillPetCmd",
    from = "ScenePet"
  },
  StartWorkPetCmd = {
    id = 100029,
    req = "Cmd.StartWorkPetCmd",
    ack = "Cmd.StartWorkPetCmd",
    from = "ScenePet"
  },
  StopWorkPetCmd = {
    id = 100030,
    req = "Cmd.StopWorkPetCmd",
    ack = "Cmd.StopWorkPetCmd",
    from = "ScenePet"
  },
  QueryPetWorkDataPetCmd = {
    id = 100032,
    req = "Cmd.QueryPetWorkDataPetCmd",
    ack = "Cmd.QueryPetWorkDataPetCmd",
    from = "ScenePet"
  },
  GetPetWorkRewardPetCmd = {
    id = 100033,
    req = "Cmd.GetPetWorkRewardPetCmd",
    ack = "Cmd.GetPetWorkRewardPetCmd",
    from = "ScenePet"
  },
  WorkSpaceUpdate = {
    id = 100034,
    req = "Cmd.WorkSpaceUpdate",
    ack = "Cmd.WorkSpaceUpdate",
    from = "ScenePet"
  },
  WorkSpaceDataUpdatePetCmd = {
    id = 100055,
    req = "Cmd.WorkSpaceDataUpdatePetCmd",
    ack = "Cmd.WorkSpaceDataUpdatePetCmd",
    from = "ScenePet"
  },
  PetExtraUpdatePetCmd = {
    id = 100035,
    req = "Cmd.PetExtraUpdatePetCmd",
    ack = "Cmd.PetExtraUpdatePetCmd",
    from = "ScenePet"
  },
  ComposePetCmd = {
    id = 100036,
    req = "Cmd.ComposePetCmd",
    ack = "Cmd.ComposePetCmd",
    from = "ScenePet"
  },
  PetEquipListCmd = {
    id = 100037,
    req = "Cmd.PetEquipListCmd",
    ack = "Cmd.PetEquipListCmd",
    from = "ScenePet"
  },
  UpdatePetEquipListCmd = {
    id = 100038,
    req = "Cmd.UpdatePetEquipListCmd",
    ack = "Cmd.UpdatePetEquipListCmd",
    from = "ScenePet"
  },
  PetWearInfo = {
    id = 1,
    req = "Cmd.PetWearInfo",
    ack = "Cmd.PetWearInfo",
    from = "ScenePet"
  },
  ChangeWearPetCmd = {
    id = 100039,
    req = "Cmd.ChangeWearPetCmd",
    ack = "Cmd.ChangeWearPetCmd",
    from = "ScenePet"
  },
  UpdateWearPetCmd = {
    id = 100040,
    req = "Cmd.UpdateWearPetCmd",
    ack = "Cmd.UpdateWearPetCmd",
    from = "ScenePet"
  },
  ReplaceCatPetCmd = {
    id = 100041,
    req = "Cmd.ReplaceCatPetCmd",
    ack = "Cmd.ReplaceCatPetCmd",
    from = "ScenePet"
  },
  WorkSpaceMaxCountUpdatePetCmd = {
    id = 100042,
    req = "Cmd.WorkSpaceMaxCountUpdatePetCmd",
    ack = "Cmd.WorkSpaceMaxCountUpdatePetCmd",
    from = "ScenePet"
  },
  CatEquipPetCmd = {
    id = 100043,
    req = "Cmd.CatEquipPetCmd",
    ack = "Cmd.CatEquipPetCmd",
    from = "ScenePet"
  },
  CatEquipInfoPetCmd = {
    id = 100044,
    req = "Cmd.CatEquipInfoPetCmd",
    ack = "Cmd.CatEquipInfoPetCmd",
    from = "ScenePet"
  },
  CatSkillOptionPetCmd = {
    id = 100045,
    req = "Cmd.CatSkillOptionPetCmd",
    ack = "Cmd.CatSkillOptionPetCmd",
    from = "ScenePet"
  },
  BoKiStateQueryPetCmd = {
    id = 100046,
    req = "Cmd.BoKiStateQueryPetCmd",
    ack = "Cmd.BoKiStateQueryPetCmd",
    from = "ScenePet"
  },
  BoKiDataUpdatePetCmd = {
    id = 100047,
    req = "Cmd.BoKiDataUpdatePetCmd",
    ack = "Cmd.BoKiDataUpdatePetCmd",
    from = "ScenePet"
  },
  BoKiEquipLevelUpPetCmd = {
    id = 100048,
    req = "Cmd.BoKiEquipLevelUpPetCmd",
    ack = "Cmd.BoKiEquipLevelUpPetCmd",
    from = "ScenePet"
  },
  BoKiEquipUpdatePetCmd = {
    id = 100049,
    req = "Cmd.BoKiEquipUpdatePetCmd",
    ack = "Cmd.BoKiEquipUpdatePetCmd",
    from = "ScenePet"
  },
  BoKiSkillLevelUpPetCmd = {
    id = 100050,
    req = "Cmd.BoKiSkillLevelUpPetCmd",
    ack = "Cmd.BoKiSkillLevelUpPetCmd",
    from = "ScenePet"
  },
  BoKiSkillUpdatePetCmd = {
    id = 100051,
    req = "Cmd.BoKiSkillUpdatePetCmd",
    ack = "Cmd.BoKiSkillUpdatePetCmd",
    from = "ScenePet"
  },
  BoKiSkillInUseUpdatePetCmd = {
    id = 100052,
    req = "Cmd.BoKiSkillInUseUpdatePetCmd",
    ack = "Cmd.BoKiSkillInUseUpdatePetCmd",
    from = "ScenePet"
  },
  BoKiSkillInUseSetPetCmd = {
    id = 100053,
    req = "Cmd.BoKiSkillInUseSetPetCmd",
    ack = "Cmd.BoKiSkillInUseSetPetCmd",
    from = "ScenePet"
  },
  SevenRoyalsFollowNpc = {
    id = 100054,
    req = "Cmd.SevenRoyalsFollowNpc",
    ack = "Cmd.SevenRoyalsFollowNpc",
    from = "ScenePet"
  },
  QuestList = {
    id = 80001,
    req = "Cmd.QuestList",
    ack = "Cmd.QuestList",
    from = "SceneQuest"
  },
  QuestUpdateItem = {
    id = 1,
    req = "Cmd.QuestUpdateItem",
    ack = "Cmd.QuestUpdateItem",
    from = "SceneQuest"
  },
  QuestUpdate = {
    id = 80002,
    req = "Cmd.QuestUpdate",
    ack = "Cmd.QuestUpdate",
    from = "SceneQuest"
  },
  QuestStepUpdate = {
    id = 80005,
    req = "Cmd.QuestStepUpdate",
    ack = "Cmd.QuestStepUpdate",
    from = "SceneQuest"
  },
  QuestAction = {
    id = 80003,
    req = "Cmd.QuestAction",
    ack = "Cmd.QuestAction",
    from = "SceneQuest"
  },
  RunQuestStep = {
    id = 80004,
    req = "Cmd.RunQuestStep",
    ack = "Cmd.RunQuestStep",
    from = "SceneQuest"
  },
  QuestTrace = {
    id = 80006,
    req = "Cmd.QuestTrace",
    ack = "Cmd.QuestTrace",
    from = "SceneQuest"
  },
  QuestDetailList = {
    id = 80007,
    req = "Cmd.QuestDetailList",
    ack = "Cmd.QuestDetailList",
    from = "SceneQuest"
  },
  QuestDetailUpdate = {
    id = 80008,
    req = "Cmd.QuestDetailUpdate",
    ack = "Cmd.QuestDetailUpdate",
    from = "SceneQuest"
  },
  QuestRaidCmd = {
    id = 80009,
    req = "Cmd.QuestRaidCmd",
    ack = "Cmd.QuestRaidCmd",
    from = "SceneQuest"
  },
  QuestCanAcceptListChange = {
    id = 80010,
    req = "Cmd.QuestCanAcceptListChange",
    ack = "Cmd.QuestCanAcceptListChange",
    from = "SceneQuest"
  },
  VisitNpcUserCmd = {
    id = 80011,
    req = "Cmd.VisitNpcUserCmd",
    ack = "Cmd.VisitNpcUserCmd",
    from = "SceneQuest"
  },
  QueryOtherData = {
    id = 80012,
    req = "Cmd.QueryOtherData",
    ack = "Cmd.QueryOtherData",
    from = "SceneQuest"
  },
  QueryWantedInfoQuestCmd = {
    id = 80013,
    req = "Cmd.QueryWantedInfoQuestCmd",
    ack = "Cmd.QueryWantedInfoQuestCmd",
    from = "SceneQuest"
  },
  InviteHelpAcceptQuestCmd = {
    id = 80014,
    req = "Cmd.InviteHelpAcceptQuestCmd",
    ack = "Cmd.InviteHelpAcceptQuestCmd",
    from = "SceneQuest"
  },
  InviteAcceptQuestCmd = {
    id = 80016,
    req = "Cmd.InviteAcceptQuestCmd",
    ack = "Cmd.InviteAcceptQuestCmd",
    from = "SceneQuest"
  },
  ReplyHelpAccelpQuestCmd = {
    id = 80015,
    req = "Cmd.ReplyHelpAccelpQuestCmd",
    ack = "Cmd.ReplyHelpAccelpQuestCmd",
    from = "SceneQuest"
  },
  QueryWorldQuestCmd = {
    id = 80017,
    req = "Cmd.QueryWorldQuestCmd",
    ack = "Cmd.QueryWorldQuestCmd",
    from = "SceneQuest"
  },
  QuestGroupTraceQuestCmd = {
    id = 80018,
    req = "Cmd.QuestGroupTraceQuestCmd",
    ack = "Cmd.QuestGroupTraceQuestCmd",
    from = "SceneQuest"
  },
  HelpQuickFinishBoardQuestCmd = {
    id = 80019,
    req = "Cmd.HelpQuickFinishBoardQuestCmd",
    ack = "Cmd.HelpQuickFinishBoardQuestCmd",
    from = "SceneQuest"
  },
  QueryQuestListQuestCmd = {
    id = 80024,
    req = "Cmd.QueryQuestListQuestCmd",
    ack = "Cmd.QueryQuestListQuestCmd",
    from = "SceneQuest"
  },
  MapStepSyncCmd = {
    id = 80025,
    req = "Cmd.MapStepSyncCmd",
    ack = "Cmd.MapStepSyncCmd",
    from = "SceneQuest"
  },
  MapStepUpdateCmd = {
    id = 80026,
    req = "Cmd.MapStepUpdateCmd",
    ack = "Cmd.MapStepUpdateCmd",
    from = "SceneQuest"
  },
  MapStepFinishCmd = {
    id = 80027,
    req = "Cmd.MapStepFinishCmd",
    ack = "Cmd.MapStepFinishCmd",
    from = "SceneQuest"
  },
  PlotStatusNtf = {
    id = 80029,
    req = "Cmd.PlotStatusNtf",
    ack = "Cmd.PlotStatusNtf",
    from = "SceneQuest"
  },
  QuestAreaAction = {
    id = 80028,
    req = "Cmd.QuestAreaAction",
    ack = "Cmd.QuestAreaAction",
    from = "SceneQuest"
  },
  QueryBottleInfoQuestCmd = {
    id = 80030,
    req = "Cmd.QueryBottleInfoQuestCmd",
    ack = "Cmd.QueryBottleInfoQuestCmd",
    from = "SceneQuest"
  },
  BottleActionQuestCmd = {
    id = 80031,
    req = "Cmd.BottleActionQuestCmd",
    ack = "Cmd.BottleActionQuestCmd",
    from = "SceneQuest"
  },
  BottleUpdateQuestCmd = {
    id = 80032,
    req = "Cmd.BottleUpdateQuestCmd",
    ack = "Cmd.BottleUpdateQuestCmd",
    from = "SceneQuest"
  },
  EvidenceQueryCmd = {
    id = 80033,
    req = "Cmd.EvidenceQueryCmd",
    ack = "Cmd.EvidenceQueryCmd",
    from = "SceneQuest"
  },
  UnlockEvidenceMessageCmd = {
    id = 80034,
    req = "Cmd.UnlockEvidenceMessageCmd",
    ack = "Cmd.UnlockEvidenceMessageCmd",
    from = "SceneQuest"
  },
  QueryCharacterInfoCmd = {
    id = 80035,
    req = "Cmd.QueryCharacterInfoCmd",
    ack = "Cmd.QueryCharacterInfoCmd",
    from = "SceneQuest"
  },
  EvidenceHintCmd = {
    id = 80037,
    req = "Cmd.EvidenceHintCmd",
    ack = "Cmd.EvidenceHintCmd",
    from = "SceneQuest"
  },
  EnlightSecretCmd = {
    id = 80038,
    req = "Cmd.EnlightSecretCmd",
    ack = "Cmd.EnlightSecretCmd",
    from = "SceneQuest"
  },
  CloseUICmd = {
    id = 80039,
    req = "Cmd.CloseUICmd",
    ack = "Cmd.CloseUICmd",
    from = "SceneQuest"
  },
  NewEvidenceUpdateCmd = {
    id = 80040,
    req = "Cmd.NewEvidenceUpdateCmd",
    ack = "Cmd.NewEvidenceUpdateCmd",
    from = "SceneQuest"
  },
  LeaveVisitNpcQuestCmd = {
    id = 80041,
    req = "Cmd.LeaveVisitNpcQuestCmd",
    ack = "Cmd.LeaveVisitNpcQuestCmd",
    from = "SceneQuest"
  },
  CompleteAvailableQueryQuestCmd = {
    id = 80042,
    req = "Cmd.CompleteAvailableQueryQuestCmd",
    ack = "Cmd.CompleteAvailableQueryQuestCmd",
    from = "SceneQuest"
  },
  WorldCountListQuestCmd = {
    id = 80043,
    req = "Cmd.WorldCountListQuestCmd",
    ack = "Cmd.WorldCountListQuestCmd",
    from = "SceneQuest"
  },
  QueryQuestHeroQuestCmd = {
    id = 80048,
    req = "Cmd.QueryQuestHeroQuestCmd",
    ack = "Cmd.QueryQuestHeroQuestCmd",
    from = "SceneQuest"
  },
  SetQuestStatusQuestCmd = {
    id = 80050,
    req = "Cmd.SetQuestStatusQuestCmd",
    ack = "Cmd.SetQuestStatusQuestCmd",
    from = "SceneQuest"
  },
  UpdateQuestHeroQuestCmd = {
    id = 80049,
    req = "Cmd.UpdateQuestHeroQuestCmd",
    ack = "Cmd.UpdateQuestHeroQuestCmd",
    from = "SceneQuest"
  },
  UpdateQuestStoryIndexQuestCmd = {
    id = 80051,
    req = "Cmd.UpdateQuestStoryIndexQuestCmd",
    ack = "Cmd.UpdateQuestStoryIndexQuestCmd",
    from = "SceneQuest"
  },
  UpdateOnceRewardQuestCmd = {
    id = 80052,
    req = "Cmd.UpdateOnceRewardQuestCmd",
    ack = "Cmd.UpdateOnceRewardQuestCmd",
    from = "SceneQuest"
  },
  SyncTreasureBoxNumCmd = {
    id = 80053,
    req = "Cmd.SyncTreasureBoxNumCmd",
    ack = "Cmd.SyncTreasureBoxNumCmd",
    from = "SceneQuest"
  },
  QueryAbyssQuestListQuestCmd = {
    id = 80054,
    req = "Cmd.QueryAbyssQuestListQuestCmd",
    ack = "Cmd.QueryAbyssQuestListQuestCmd",
    from = "SceneQuest"
  },
  UpdateAbyssHelpCountQuestCmd = {
    id = 80055,
    req = "Cmd.UpdateAbyssHelpCountQuestCmd",
    ack = "Cmd.UpdateAbyssHelpCountQuestCmd",
    from = "SceneQuest"
  },
  SealItem = {
    id = 1,
    req = "Cmd.SealItem",
    ack = "Cmd.SealItem",
    from = "SceneSeal"
  },
  QuerySeal = {
    id = 210001,
    req = "Cmd.QuerySeal",
    ack = "Cmd.QuerySeal",
    from = "SceneSeal"
  },
  UpdateSeal = {
    id = 210002,
    req = "Cmd.UpdateSeal",
    ack = "Cmd.UpdateSeal",
    from = "SceneSeal"
  },
  SealTimer = {
    id = 210003,
    req = "Cmd.SealTimer",
    ack = "Cmd.SealTimer",
    from = "SceneSeal"
  },
  BeginSeal = {
    id = 210004,
    req = "Cmd.BeginSeal",
    ack = "Cmd.BeginSeal",
    from = "SceneSeal"
  },
  EndSeal = {
    id = 210005,
    req = "Cmd.EndSeal",
    ack = "Cmd.EndSeal",
    from = "SceneSeal"
  },
  SealUserLeave = {
    id = 210006,
    req = "Cmd.SealUserLeave",
    ack = "Cmd.SealUserLeave",
    from = "SceneSeal"
  },
  SealQueryList = {
    id = 210007,
    req = "Cmd.SealQueryList",
    ack = "Cmd.SealQueryList",
    from = "SceneSeal"
  },
  SealAcceptCmd = {
    id = 210008,
    req = "Cmd.SealAcceptCmd",
    ack = "Cmd.SealAcceptCmd",
    from = "SceneSeal"
  },
  ReqSkillData = {
    id = 70001,
    req = "Cmd.ReqSkillData",
    ack = "Cmd.ReqSkillData",
    from = "SceneSkill"
  },
  SkillUpdate = {
    id = 70002,
    req = "Cmd.SkillUpdate",
    ack = "Cmd.SkillUpdate",
    from = "SceneSkill"
  },
  LevelupSkill = {
    id = 70003,
    req = "Cmd.LevelupSkill",
    ack = "Cmd.LevelupSkill",
    from = "SceneSkill"
  },
  EquipSkill = {
    id = 70004,
    req = "Cmd.EquipSkill",
    ack = "Cmd.EquipSkill",
    from = "SceneSkill"
  },
  ResetSkill = {
    id = 70005,
    req = "Cmd.ResetSkill",
    ack = "Cmd.ResetSkill",
    from = "SceneSkill"
  },
  SkillValidPos = {
    id = 70006,
    req = "Cmd.SkillValidPos",
    ack = "Cmd.SkillValidPos",
    from = "SceneSkill"
  },
  ChangeSkillCmd = {
    id = 70007,
    req = "Cmd.ChangeSkillCmd",
    ack = "Cmd.ChangeSkillCmd",
    from = "SceneSkill"
  },
  UpSkillInfoSkillCmd = {
    id = 70008,
    req = "Cmd.UpSkillInfoSkillCmd",
    ack = "Cmd.UpSkillInfoSkillCmd",
    from = "SceneSkill"
  },
  SelectRuneSkillCmd = {
    id = 70009,
    req = "Cmd.SelectRuneSkillCmd",
    ack = "Cmd.SelectRuneSkillCmd",
    from = "SceneSkill"
  },
  MarkSkillNpcSkillCmd = {
    id = 70010,
    req = "Cmd.MarkSkillNpcSkillCmd",
    ack = "Cmd.MarkSkillNpcSkillCmd",
    from = "SceneSkill"
  },
  TriggerSkillNpcSkillCmd = {
    id = 70011,
    req = "Cmd.TriggerSkillNpcSkillCmd",
    ack = "Cmd.TriggerSkillNpcSkillCmd",
    from = "SceneSkill"
  },
  SkillOptionSkillCmd = {
    id = 70012,
    req = "Cmd.SkillOptionSkillCmd",
    ack = "Cmd.SkillOptionSkillCmd",
    from = "SceneSkill"
  },
  DynamicSkillCmd = {
    id = 70013,
    req = "Cmd.DynamicSkillCmd",
    ack = "Cmd.DynamicSkillCmd",
    from = "SceneSkill"
  },
  UpdateDynamicSkillCmd = {
    id = 70014,
    req = "Cmd.UpdateDynamicSkillCmd",
    ack = "Cmd.UpdateDynamicSkillCmd",
    from = "SceneSkill"
  },
  SyncDestPosSkillCmd = {
    id = 70015,
    req = "Cmd.SyncDestPosSkillCmd",
    ack = "Cmd.SyncDestPosSkillCmd",
    from = "SceneSkill"
  },
  ResetTalentSkillCmd = {
    id = 70016,
    req = "Cmd.ResetTalentSkillCmd",
    ack = "Cmd.ResetTalentSkillCmd",
    from = "SceneSkill"
  },
  MultiSkillOptionUpdateSkillCmd = {
    id = 70017,
    req = "Cmd.MultiSkillOptionUpdateSkillCmd",
    ack = "Cmd.MultiSkillOptionUpdateSkillCmd",
    from = "SceneSkill"
  },
  MultiSkillOptionSyncSkillCmd = {
    id = 70018,
    req = "Cmd.MultiSkillOptionSyncSkillCmd",
    ack = "Cmd.MultiSkillOptionSyncSkillCmd",
    from = "SceneSkill"
  },
  SkillEffectSkillCmd = {
    id = 70020,
    req = "Cmd.SkillEffectSkillCmd",
    ack = "Cmd.SkillEffectSkillCmd",
    from = "SceneSkill"
  },
  SyncSkillEffectSkillCmd = {
    id = 70021,
    req = "Cmd.SyncSkillEffectSkillCmd",
    ack = "Cmd.SyncSkillEffectSkillCmd",
    from = "SceneSkill"
  },
  MaskSkillRandomOneSkillCmd = {
    id = 70019,
    req = "Cmd.MaskSkillRandomOneSkillCmd",
    ack = "Cmd.MaskSkillRandomOneSkillCmd",
    from = "SceneSkill"
  },
  StopBossSkillUsageSkillCmd = {
    id = 70022,
    req = "Cmd.StopBossSkillUsageSkillCmd",
    ack = "Cmd.StopBossSkillUsageSkillCmd",
    from = "SceneSkill"
  },
  ChangeAutoShortCutCmd = {
    id = 70023,
    req = "Cmd.ChangeAutoShortCutCmd",
    ack = "Cmd.ChangeAutoShortCutCmd",
    from = "SceneSkill"
  },
  ClearOptionSkillCmd = {
    id = 70024,
    req = "Cmd.ClearOptionSkillCmd",
    ack = "Cmd.ClearOptionSkillCmd",
    from = "SceneSkill"
  },
  SyncBulletNumSkillCmd = {
    id = 70025,
    req = "Cmd.SyncBulletNumSkillCmd",
    ack = "Cmd.SyncBulletNumSkillCmd",
    from = "SceneSkill"
  },
  StopSniperModeSkillCmd = {
    id = 70026,
    req = "Cmd.StopSniperModeSkillCmd",
    ack = "Cmd.StopSniperModeSkillCmd",
    from = "SceneSkill"
  },
  JudgeChantResultSkillCmd = {
    id = 70027,
    req = "Cmd.JudgeChantResultSkillCmd",
    ack = "Cmd.JudgeChantResultSkillCmd",
    from = "SceneSkill"
  },
  SkillPerceptAbilityLvUpCmd = {
    id = 70028,
    req = "Cmd.SkillPerceptAbilityLvUpCmd",
    ack = "Cmd.SkillPerceptAbilityLvUpCmd",
    from = "SceneSkill"
  },
  SkillPerceptAbilityNtf = {
    id = 70029,
    req = "Cmd.SkillPerceptAbilityNtf",
    ack = "Cmd.SkillPerceptAbilityNtf",
    from = "SceneSkill"
  },
  SetCastPosSkillCmd = {
    id = 70030,
    req = "Cmd.SetCastPosSkillCmd",
    ack = "Cmd.SetCastPosSkillCmd",
    from = "SceneSkill"
  },
  MarkSunMoonSkillCmd = {
    id = 70031,
    req = "Cmd.MarkSunMoonSkillCmd",
    ack = "Cmd.MarkSunMoonSkillCmd",
    from = "SceneSkill"
  },
  TriggerKickSkillSkillCmd = {
    id = 70032,
    req = "Cmd.TriggerKickSkillSkillCmd",
    ack = "Cmd.TriggerKickSkillSkillCmd",
    from = "SceneSkill"
  },
  TimeDiskSkillCmd = {
    id = 70033,
    req = "Cmd.TimeDiskSkillCmd",
    ack = "Cmd.TimeDiskSkillCmd",
    from = "SceneSkill"
  },
  UseSkillSuccessSync = {
    id = 70034,
    req = "Cmd.UseSkillSuccessSync",
    ack = "Cmd.UseSkillSuccessSync",
    from = "SceneSkill"
  },
  UpdateMasterSkill = {
    id = 70035,
    req = "Cmd.UpdateMasterSkill",
    ack = "Cmd.UpdateMasterSkill",
    from = "SceneSkill"
  },
  UpdateMasterSkillEquip = {
    id = 70036,
    req = "Cmd.UpdateMasterSkillEquip",
    ack = "Cmd.UpdateMasterSkillEquip",
    from = "SceneSkill"
  },
  SwitchMasterSkill = {
    id = 70037,
    req = "Cmd.SwitchMasterSkill",
    ack = "Cmd.SwitchMasterSkill",
    from = "SceneSkill"
  },
  UpdateInheritSkillCmd = {
    id = 70038,
    req = "Cmd.UpdateInheritSkillCmd",
    ack = "Cmd.UpdateInheritSkillCmd",
    from = "SceneSkill"
  },
  LoadInheritSkillCmd = {
    id = 70039,
    req = "Cmd.LoadInheritSkillCmd",
    ack = "Cmd.LoadInheritSkillCmd",
    from = "SceneSkill"
  },
  ExtendInheritSkillCmd = {
    id = 70040,
    req = "Cmd.ExtendInheritSkillCmd",
    ack = "Cmd.ExtendInheritSkillCmd",
    from = "SceneSkill"
  },
  SyncBlockMasterSkill = {
    id = 70041,
    req = "Cmd.SyncBlockMasterSkill",
    ack = "Cmd.SyncBlockMasterSkill",
    from = "SceneSkill"
  },
  GameTipCmd = {
    id = 180001,
    req = "Cmd.GameTipCmd",
    ack = "Cmd.GameTipCmd",
    from = "SceneTip"
  },
  BrowseRedTipCmd = {
    id = 180002,
    req = "Cmd.BrowseRedTipCmd",
    ack = "Cmd.BrowseRedTipCmd",
    from = "SceneTip"
  },
  AddRedTip = {
    id = 180003,
    req = "Cmd.AddRedTip",
    ack = "Cmd.AddRedTip",
    from = "SceneTip"
  },
  UserSyncCmd = {
    id = 50001,
    req = "Cmd.UserSyncCmd",
    ack = "Cmd.UserSyncCmd",
    from = "SceneUser"
  },
  UserMessageCmd = {
    id = 50000,
    req = "Cmd.UserMessageCmd",
    ack = "Cmd.UserMessageCmd",
    from = "SceneUser"
  },
  UserGMCommand = {
    id = 50003,
    req = "Cmd.UserGMCommand",
    ack = "Cmd.UserGMCommand",
    from = "SceneUser"
  },
  UserProfessionExchange = {
    id = 50000,
    req = "Cmd.UserProfessionExchange",
    ack = "Cmd.UserProfessionExchange",
    from = "SceneUser"
  },
  UserTest = {
    id = 49999,
    req = "Cmd.UserTest",
    ack = "Cmd.UserTest",
    from = "SceneUser"
  },
  UserFaceCmd = {
    id = 49999,
    req = "Cmd.UserFaceCmd",
    ack = "Cmd.UserFaceCmd",
    from = "SceneUser"
  },
  MainUserDataUserCmd = {
    id = 50011,
    req = "Cmd.MainUserDataUserCmd",
    ack = "Cmd.MainUserDataUserCmd",
    from = "SceneUser"
  },
  ReqMoveUserCmd = {
    id = 50015,
    req = "Cmd.ReqMoveUserCmd",
    ack = "Cmd.ReqMoveUserCmd",
    from = "SceneUser"
  },
  RetMoveUserCmd = {
    id = 50016,
    req = "Cmd.RetMoveUserCmd",
    ack = "Cmd.RetMoveUserCmd",
    from = "SceneUser"
  },
  SynTimeUserCmd = {
    id = 50017,
    req = "Cmd.SynTimeUserCmd",
    ack = "Cmd.SynTimeUserCmd",
    from = "SceneUser"
  },
  DeleteEntryUserCmd = {
    id = 50018,
    req = "Cmd.DeleteEntryUserCmd",
    ack = "Cmd.DeleteEntryUserCmd",
    from = "SceneUser"
  },
  ChangeBodyUserCmd = {
    id = 50022,
    req = "Cmd.ChangeBodyUserCmd",
    ack = "Cmd.ChangeBodyUserCmd",
    from = "SceneUser"
  },
  ChangeSceneUserCmd = {
    id = 50023,
    req = "Cmd.ChangeSceneUserCmd",
    ack = "Cmd.ChangeSceneUserCmd",
    from = "SceneUser"
  },
  FuntionNpcListUserCmd = {
    id = 50025,
    req = "Cmd.FuntionNpcListUserCmd",
    ack = "Cmd.FuntionNpcListUserCmd",
    from = "SceneUser"
  },
  DeleteStaticEntryUserCmd = {
    id = 50026,
    req = "Cmd.DeleteStaticEntryUserCmd",
    ack = "Cmd.DeleteStaticEntryUserCmd",
    from = "SceneUser"
  },
  SkillBroadcastUserCmd = {
    id = 50027,
    req = "Cmd.SkillBroadcastUserCmd",
    ack = "Cmd.SkillBroadcastUserCmd",
    from = "SceneUser"
  },
  TestSkillBroadcastUserCmd = {
    id = 50047,
    req = "Cmd.TestSkillBroadcastUserCmd",
    ack = "Cmd.TestSkillBroadcastUserCmd",
    from = "SceneUser"
  },
  UseSkillUserCmd = {
    id = 50028,
    req = "Cmd.UseSkillUserCmd",
    ack = "Cmd.UseSkillUserCmd",
    from = "SceneUser"
  },
  ChantSkillUserCmd = {
    id = 50029,
    req = "Cmd.ChantSkillUserCmd",
    ack = "Cmd.ChantSkillUserCmd",
    from = "SceneUser"
  },
  BreakChantSkillUserCmd = {
    id = 50030,
    req = "Cmd.BreakChantSkillUserCmd",
    ack = "Cmd.BreakChantSkillUserCmd",
    from = "SceneUser"
  },
  BroadcastSkillUserCmd = {
    id = 50031,
    req = "Cmd.BroadcastSkillUserCmd",
    ack = "Cmd.BroadcastSkillUserCmd",
    from = "SceneUser"
  },
  MapObjectData = {
    id = 50038,
    req = "Cmd.MapObjectData",
    ack = "Cmd.MapObjectData",
    from = "SceneUser"
  },
  ReliveUserCmd = {
    id = 50041,
    req = "Cmd.ReliveUserCmd",
    ack = "Cmd.ReliveUserCmd",
    from = "SceneUser"
  },
  GoToUserCmd = {
    id = 50042,
    req = "Cmd.GoToUserCmd",
    ack = "Cmd.GoToUserCmd",
    from = "SceneUser"
  },
  ReconnectionPosUserCmd = {
    id = 50043,
    req = "Cmd.ReconnectionPosUserCmd",
    ack = "Cmd.ReconnectionPosUserCmd",
    from = "SceneUser"
  },
  GoToExitPosUserCmd = {
    id = 50048,
    req = "Cmd.GoToExitPosUserCmd",
    ack = "Cmd.GoToExitPosUserCmd",
    from = "SceneUser"
  },
  GoToRandomPosUserCmd = {
    id = 50049,
    req = "Cmd.GoToRandomPosUserCmd",
    ack = "Cmd.GoToRandomPosUserCmd",
    from = "SceneUser"
  },
  UserRejectSettingNotifyServiceCmd = {
    id = 50050,
    req = "Cmd.UserRejectSettingNotifyServiceCmd",
    ack = "Cmd.UserRejectSettingNotifyServiceCmd",
    from = "SceneUser"
  },
  NpcWalkTraceInfo = {
    id = 50051,
    req = "Cmd.NpcWalkTraceInfo",
    ack = "Cmd.NpcWalkTraceInfo",
    from = "SceneUser"
  },
  ReqHideUserCmd = {
    id = 50052,
    req = "Cmd.ReqHideUserCmd",
    ack = "Cmd.ReqHideUserCmd",
    from = "SceneUser"
  },
  ObservationModeUserCmd = {
    id = 50053,
    req = "Cmd.ObservationModeUserCmd",
    ack = "Cmd.ObservationModeUserCmd",
    from = "SceneUser"
  },
  GoCity = {
    id = 90001,
    req = "Cmd.GoCity",
    ack = "Cmd.GoCity",
    from = "SceneUser2"
  },
  SysMsg = {
    id = 90002,
    req = "Cmd.SysMsg",
    ack = "Cmd.SysMsg",
    from = "SceneUser2"
  },
  NpcDataSync = {
    id = 90003,
    req = "Cmd.NpcDataSync",
    ack = "Cmd.NpcDataSync",
    from = "SceneUser2"
  },
  UserNineSyncCmd = {
    id = 90004,
    req = "Cmd.UserNineSyncCmd",
    ack = "Cmd.UserNineSyncCmd",
    from = "SceneUser2"
  },
  UserActionNtf = {
    id = 90005,
    req = "Cmd.UserActionNtf",
    ack = "Cmd.UserActionNtf",
    from = "SceneUser2"
  },
  UserBuffNineSyncCmd = {
    id = 90006,
    req = "Cmd.UserBuffNineSyncCmd",
    ack = "Cmd.UserBuffNineSyncCmd",
    from = "SceneUser2"
  },
  ExitPosUserCmd = {
    id = 90007,
    req = "Cmd.ExitPosUserCmd",
    ack = "Cmd.ExitPosUserCmd",
    from = "SceneUser2"
  },
  Relive = {
    id = 90008,
    req = "Cmd.Relive",
    ack = "Cmd.Relive",
    from = "SceneUser2"
  },
  VarUpdate = {
    id = 90009,
    req = "Cmd.VarUpdate",
    ack = "Cmd.VarUpdate",
    from = "SceneUser2"
  },
  TalkInfo = {
    id = 90010,
    req = "Cmd.TalkInfo",
    ack = "Cmd.TalkInfo",
    from = "SceneUser2"
  },
  ServerTime = {
    id = 90011,
    req = "Cmd.ServerTime",
    ack = "Cmd.ServerTime",
    from = "SceneUser2"
  },
  EffectUserCmd = {
    id = 90014,
    req = "Cmd.EffectUserCmd",
    ack = "Cmd.EffectUserCmd",
    from = "SceneUser2"
  },
  MenuList = {
    id = 90015,
    req = "Cmd.MenuList",
    ack = "Cmd.MenuList",
    from = "SceneUser2"
  },
  NewMenu = {
    id = 90016,
    req = "Cmd.NewMenu",
    ack = "Cmd.NewMenu",
    from = "SceneUser2"
  },
  EvaluationReward = {
    id = 90232,
    req = "Cmd.EvaluationReward",
    ack = "Cmd.EvaluationReward",
    from = "SceneUser2"
  },
  TeamInfoNine = {
    id = 90017,
    req = "Cmd.TeamInfoNine",
    ack = "Cmd.TeamInfoNine",
    from = "SceneUser2"
  },
  UsePortrait = {
    id = 90018,
    req = "Cmd.UsePortrait",
    ack = "Cmd.UsePortrait",
    from = "SceneUser2"
  },
  UseFrame = {
    id = 90019,
    req = "Cmd.UseFrame",
    ack = "Cmd.UseFrame",
    from = "SceneUser2"
  },
  UpdatePortraitFrame = {
    id = 90020,
    req = "Cmd.UpdatePortraitFrame",
    ack = "Cmd.UpdatePortraitFrame",
    from = "SceneUser2"
  },
  QueryPortraitListUserCmd = {
    id = 90024,
    req = "Cmd.QueryPortraitListUserCmd",
    ack = "Cmd.QueryPortraitListUserCmd",
    from = "SceneUser2"
  },
  UseDressing = {
    id = 90025,
    req = "Cmd.UseDressing",
    ack = "Cmd.UseDressing",
    from = "SceneUser2"
  },
  NewDressing = {
    id = 90026,
    req = "Cmd.NewDressing",
    ack = "Cmd.NewDressing",
    from = "SceneUser2"
  },
  DressingListUserCmd = {
    id = 90027,
    req = "Cmd.DressingListUserCmd",
    ack = "Cmd.DressingListUserCmd",
    from = "SceneUser2"
  },
  AddAttrPoint = {
    id = 90021,
    req = "Cmd.AddAttrPoint",
    ack = "Cmd.AddAttrPoint",
    from = "SceneUser2"
  },
  QueryShopGotItem = {
    id = 90022,
    req = "Cmd.QueryShopGotItem",
    ack = "Cmd.QueryShopGotItem",
    from = "SceneUser2"
  },
  UpdateShopGotItem = {
    id = 90023,
    req = "Cmd.UpdateShopGotItem",
    ack = "Cmd.UpdateShopGotItem",
    from = "SceneUser2"
  },
  OpenUI = {
    id = 90029,
    req = "Cmd.OpenUI",
    ack = "Cmd.OpenUI",
    from = "SceneUser2"
  },
  DbgSysMsg = {
    id = 90030,
    req = "Cmd.DbgSysMsg",
    ack = "Cmd.DbgSysMsg",
    from = "SceneUser2"
  },
  FollowTransferCmd = {
    id = 90032,
    req = "Cmd.FollowTransferCmd",
    ack = "Cmd.FollowTransferCmd",
    from = "SceneUser2"
  },
  CallNpcFuncCmd = {
    id = 90033,
    req = "Cmd.CallNpcFuncCmd",
    ack = "Cmd.CallNpcFuncCmd",
    from = "SceneUser2"
  },
  ModelShow = {
    id = 90034,
    req = "Cmd.ModelShow",
    ack = "Cmd.ModelShow",
    from = "SceneUser2"
  },
  SoundEffectCmd = {
    id = 90035,
    req = "Cmd.SoundEffectCmd",
    ack = "Cmd.SoundEffectCmd",
    from = "SceneUser2"
  },
  PresetMsgCmd = {
    id = 90036,
    req = "Cmd.PresetMsgCmd",
    ack = "Cmd.PresetMsgCmd",
    from = "SceneUser2"
  },
  ChangeBgmCmd = {
    id = 90037,
    req = "Cmd.ChangeBgmCmd",
    ack = "Cmd.ChangeBgmCmd",
    from = "SceneUser2"
  },
  QueryFighterInfo = {
    id = 90038,
    req = "Cmd.QueryFighterInfo",
    ack = "Cmd.QueryFighterInfo",
    from = "SceneUser2"
  },
  GameTimeCmd = {
    id = 90040,
    req = "Cmd.GameTimeCmd",
    ack = "Cmd.GameTimeCmd",
    from = "SceneUser2"
  },
  CDTimeUserCmd = {
    id = 90041,
    req = "Cmd.CDTimeUserCmd",
    ack = "Cmd.CDTimeUserCmd",
    from = "SceneUser2"
  },
  StateChange = {
    id = 90042,
    req = "Cmd.StateChange",
    ack = "Cmd.StateChange",
    from = "SceneUser2"
  },
  Photo = {
    id = 90044,
    req = "Cmd.Photo",
    ack = "Cmd.Photo",
    from = "SceneUser2"
  },
  ShakeScreen = {
    id = 90045,
    req = "Cmd.ShakeScreen",
    ack = "Cmd.ShakeScreen",
    from = "SceneUser2"
  },
  QueryShortcut = {
    id = 90047,
    req = "Cmd.QueryShortcut",
    ack = "Cmd.QueryShortcut",
    from = "SceneUser2"
  },
  PutShortcut = {
    id = 90048,
    req = "Cmd.PutShortcut",
    ack = "Cmd.PutShortcut",
    from = "SceneUser2"
  },
  TempPutShortCut = {
    id = 90180,
    req = "Cmd.TempPutShortCut",
    ack = "Cmd.TempPutShortCut",
    from = "SceneUser2"
  },
  NpcChangeAngle = {
    id = 90049,
    req = "Cmd.NpcChangeAngle",
    ack = "Cmd.NpcChangeAngle",
    from = "SceneUser2"
  },
  CameraFocus = {
    id = 90050,
    req = "Cmd.CameraFocus",
    ack = "Cmd.CameraFocus",
    from = "SceneUser2"
  },
  GoToListUserCmd = {
    id = 90051,
    req = "Cmd.GoToListUserCmd",
    ack = "Cmd.GoToListUserCmd",
    from = "SceneUser2"
  },
  GoToGearUserCmd = {
    id = 90052,
    req = "Cmd.GoToGearUserCmd",
    ack = "Cmd.GoToGearUserCmd",
    from = "SceneUser2"
  },
  NewTransMapCmd = {
    id = 90012,
    req = "Cmd.NewTransMapCmd",
    ack = "Cmd.NewTransMapCmd",
    from = "SceneUser2"
  },
  DeathTransferListCmd = {
    id = 90151,
    req = "Cmd.DeathTransferListCmd",
    ack = "Cmd.DeathTransferListCmd",
    from = "SceneUser2"
  },
  NewDeathTransferCmd = {
    id = 90152,
    req = "Cmd.NewDeathTransferCmd",
    ack = "Cmd.NewDeathTransferCmd",
    from = "SceneUser2"
  },
  UseDeathTransferCmd = {
    id = 90153,
    req = "Cmd.UseDeathTransferCmd",
    ack = "Cmd.UseDeathTransferCmd",
    from = "SceneUser2"
  },
  FollowerUser = {
    id = 90053,
    req = "Cmd.FollowerUser",
    ack = "Cmd.FollowerUser",
    from = "SceneUser2"
  },
  BeFollowUserCmd = {
    id = 90096,
    req = "Cmd.BeFollowUserCmd",
    ack = "Cmd.BeFollowUserCmd",
    from = "SceneUser2"
  },
  LaboratoryUserCmd = {
    id = 90054,
    req = "Cmd.LaboratoryUserCmd",
    ack = "Cmd.LaboratoryUserCmd",
    from = "SceneUser2"
  },
  GotoLaboratoryUserCmd = {
    id = 90057,
    req = "Cmd.GotoLaboratoryUserCmd",
    ack = "Cmd.GotoLaboratoryUserCmd",
    from = "SceneUser2"
  },
  ExchangeProfession = {
    id = 90056,
    req = "Cmd.ExchangeProfession",
    ack = "Cmd.ExchangeProfession",
    from = "SceneUser2"
  },
  SceneryUserCmd = {
    id = 90058,
    req = "Cmd.SceneryUserCmd",
    ack = "Cmd.SceneryUserCmd",
    from = "SceneUser2"
  },
  GoMapQuestUserCmd = {
    id = 90059,
    req = "Cmd.GoMapQuestUserCmd",
    ack = "Cmd.GoMapQuestUserCmd",
    from = "SceneUser2"
  },
  GoMapFollowUserCmd = {
    id = 90060,
    req = "Cmd.GoMapFollowUserCmd",
    ack = "Cmd.GoMapFollowUserCmd",
    from = "SceneUser2"
  },
  UserAutoHitCmd = {
    id = 90061,
    req = "Cmd.UserAutoHitCmd",
    ack = "Cmd.UserAutoHitCmd",
    from = "SceneUser2"
  },
  UploadSceneryPhotoUserCmd = {
    id = 90062,
    req = "Cmd.UploadSceneryPhotoUserCmd",
    ack = "Cmd.UploadSceneryPhotoUserCmd",
    from = "SceneUser2"
  },
  UpyunUrl = {
    id = 1,
    req = "Cmd.UpyunUrl",
    ack = "Cmd.UpyunUrl",
    from = "SceneUser2"
  },
  DownloadSceneryPhotoUserCmd = {
    id = 90080,
    req = "Cmd.DownloadSceneryPhotoUserCmd",
    ack = "Cmd.DownloadSceneryPhotoUserCmd",
    from = "SceneUser2"
  },
  QueryMapArea = {
    id = 90063,
    req = "Cmd.QueryMapArea",
    ack = "Cmd.QueryMapArea",
    from = "SceneUser2"
  },
  NewMapAreaNtf = {
    id = 90064,
    req = "Cmd.NewMapAreaNtf",
    ack = "Cmd.NewMapAreaNtf",
    from = "SceneUser2"
  },
  BuffForeverCmd = {
    id = 90066,
    req = "Cmd.BuffForeverCmd",
    ack = "Cmd.BuffForeverCmd",
    from = "SceneUser2"
  },
  InviteJoinHandsUserCmd = {
    id = 90067,
    req = "Cmd.InviteJoinHandsUserCmd",
    ack = "Cmd.InviteJoinHandsUserCmd",
    from = "SceneUser2"
  },
  BreakUpHandsUserCmd = {
    id = 90068,
    req = "Cmd.BreakUpHandsUserCmd",
    ack = "Cmd.BreakUpHandsUserCmd",
    from = "SceneUser2"
  },
  HandStatusUserCmd = {
    id = 90095,
    req = "Cmd.HandStatusUserCmd",
    ack = "Cmd.HandStatusUserCmd",
    from = "SceneUser2"
  },
  QueryShow = {
    id = 90069,
    req = "Cmd.QueryShow",
    ack = "Cmd.QueryShow",
    from = "SceneUser2"
  },
  QueryMusicList = {
    id = 90070,
    req = "Cmd.QueryMusicList",
    ack = "Cmd.QueryMusicList",
    from = "SceneUser2"
  },
  DemandMusic = {
    id = 90071,
    req = "Cmd.DemandMusic",
    ack = "Cmd.DemandMusic",
    from = "SceneUser2"
  },
  CloseMusicFrame = {
    id = 90072,
    req = "Cmd.CloseMusicFrame",
    ack = "Cmd.CloseMusicFrame",
    from = "SceneUser2"
  },
  UploadOkSceneryUserCmd = {
    id = 90073,
    req = "Cmd.UploadOkSceneryUserCmd",
    ack = "Cmd.UploadOkSceneryUserCmd",
    from = "SceneUser2"
  },
  JoinHandsUserCmd = {
    id = 90074,
    req = "Cmd.JoinHandsUserCmd",
    ack = "Cmd.JoinHandsUserCmd",
    from = "SceneUser2"
  },
  QueryTraceList = {
    id = 90075,
    req = "Cmd.QueryTraceList",
    ack = "Cmd.QueryTraceList",
    from = "SceneUser2"
  },
  UpdateTraceList = {
    id = 90076,
    req = "Cmd.UpdateTraceList",
    ack = "Cmd.UpdateTraceList",
    from = "SceneUser2"
  },
  SetDirection = {
    id = 90077,
    req = "Cmd.SetDirection",
    ack = "Cmd.SetDirection",
    from = "SceneUser2"
  },
  BattleTimelenUserCmd = {
    id = 90082,
    req = "Cmd.BattleTimelenUserCmd",
    ack = "Cmd.BattleTimelenUserCmd",
    from = "SceneUser2"
  },
  SetOptionUserCmd = {
    id = 90083,
    req = "Cmd.SetOptionUserCmd",
    ack = "Cmd.SetOptionUserCmd",
    from = "SceneUser2"
  },
  QueryUserInfoUserCmd = {
    id = 90084,
    req = "Cmd.QueryUserInfoUserCmd",
    ack = "Cmd.QueryUserInfoUserCmd",
    from = "SceneUser2"
  },
  CountDownTickUserCmd = {
    id = 90085,
    req = "Cmd.CountDownTickUserCmd",
    ack = "Cmd.CountDownTickUserCmd",
    from = "SceneUser2"
  },
  ItemMusicNtfUserCmd = {
    id = 90086,
    req = "Cmd.ItemMusicNtfUserCmd",
    ack = "Cmd.ItemMusicNtfUserCmd",
    from = "SceneUser2"
  },
  ShakeTreeUserCmd = {
    id = 90087,
    req = "Cmd.ShakeTreeUserCmd",
    ack = "Cmd.ShakeTreeUserCmd",
    from = "SceneUser2"
  },
  TreeListUserCmd = {
    id = 90088,
    req = "Cmd.TreeListUserCmd",
    ack = "Cmd.TreeListUserCmd",
    from = "SceneUser2"
  },
  ActivityNtfUserCmd = {
    id = 90089,
    req = "Cmd.ActivityNtfUserCmd",
    ack = "Cmd.ActivityNtfUserCmd",
    from = "SceneUser2"
  },
  QueryZoneStatusUserCmd = {
    id = 90091,
    req = "Cmd.QueryZoneStatusUserCmd",
    ack = "Cmd.QueryZoneStatusUserCmd",
    from = "SceneUser2"
  },
  JumpZoneUserCmd = {
    id = 90092,
    req = "Cmd.JumpZoneUserCmd",
    ack = "Cmd.JumpZoneUserCmd",
    from = "SceneUser2"
  },
  ItemImageUserNtfUserCmd = {
    id = 90093,
    req = "Cmd.ItemImageUserNtfUserCmd",
    ack = "Cmd.ItemImageUserNtfUserCmd",
    from = "SceneUser2"
  },
  InviteFollowUserCmd = {
    id = 90097,
    req = "Cmd.InviteFollowUserCmd",
    ack = "Cmd.InviteFollowUserCmd",
    from = "SceneUser2"
  },
  ChangeNameUserCmd = {
    id = 90098,
    req = "Cmd.ChangeNameUserCmd",
    ack = "Cmd.ChangeNameUserCmd",
    from = "SceneUser2"
  },
  ChargePlayUserCmd = {
    id = 90099,
    req = "Cmd.ChargePlayUserCmd",
    ack = "Cmd.ChargePlayUserCmd",
    from = "SceneUser2"
  },
  RequireNpcFuncUserCmd = {
    id = 90100,
    req = "Cmd.RequireNpcFuncUserCmd",
    ack = "Cmd.RequireNpcFuncUserCmd",
    from = "SceneUser2"
  },
  CheckSeatUserCmd = {
    id = 90101,
    req = "Cmd.CheckSeatUserCmd",
    ack = "Cmd.CheckSeatUserCmd",
    from = "SceneUser2"
  },
  NtfSeatUserCmd = {
    id = 90102,
    req = "Cmd.NtfSeatUserCmd",
    ack = "Cmd.NtfSeatUserCmd",
    from = "SceneUser2"
  },
  YoyoSeatUserCmd = {
    id = 90114,
    req = "Cmd.YoyoSeatUserCmd",
    ack = "Cmd.YoyoSeatUserCmd",
    from = "SceneUser2"
  },
  ShowSeatUserCmd = {
    id = 90115,
    req = "Cmd.ShowSeatUserCmd",
    ack = "Cmd.ShowSeatUserCmd",
    from = "SceneUser2"
  },
  SetNormalSkillOptionUserCmd = {
    id = 90103,
    req = "Cmd.SetNormalSkillOptionUserCmd",
    ack = "Cmd.SetNormalSkillOptionUserCmd",
    from = "SceneUser2"
  },
  NewSetOptionUserCmd = {
    id = 90106,
    req = "Cmd.NewSetOptionUserCmd",
    ack = "Cmd.NewSetOptionUserCmd",
    from = "SceneUser2"
  },
  UnsolvedSceneryNtfUserCmd = {
    id = 90104,
    req = "Cmd.UnsolvedSceneryNtfUserCmd",
    ack = "Cmd.UnsolvedSceneryNtfUserCmd",
    from = "SceneUser2"
  },
  NtfVisibleNpcUserCmd = {
    id = 90105,
    req = "Cmd.NtfVisibleNpcUserCmd",
    ack = "Cmd.NtfVisibleNpcUserCmd",
    from = "SceneUser2"
  },
  TransformPreDataCmd = {
    id = 90108,
    req = "Cmd.TransformPreDataCmd",
    ack = "Cmd.TransformPreDataCmd",
    from = "SceneUser2"
  },
  UserRenameCmd = {
    id = 90109,
    req = "Cmd.UserRenameCmd",
    ack = "Cmd.UserRenameCmd",
    from = "SceneUser2"
  },
  BuyZenyCmd = {
    id = 90111,
    req = "Cmd.BuyZenyCmd",
    ack = "Cmd.BuyZenyCmd",
    from = "SceneUser2"
  },
  CallTeamerUserCmd = {
    id = 90112,
    req = "Cmd.CallTeamerUserCmd",
    ack = "Cmd.CallTeamerUserCmd",
    from = "SceneUser2"
  },
  CallTeamerReplyUserCmd = {
    id = 90113,
    req = "Cmd.CallTeamerReplyUserCmd",
    ack = "Cmd.CallTeamerReplyUserCmd",
    from = "SceneUser2"
  },
  SpecialEffectCmd = {
    id = 90116,
    req = "Cmd.SpecialEffectCmd",
    ack = "Cmd.SpecialEffectCmd",
    from = "SceneUser2"
  },
  MarriageProposalCmd = {
    id = 90117,
    req = "Cmd.MarriageProposalCmd",
    ack = "Cmd.MarriageProposalCmd",
    from = "SceneUser2"
  },
  MarriageProposalReplyCmd = {
    id = 90118,
    req = "Cmd.MarriageProposalReplyCmd",
    ack = "Cmd.MarriageProposalReplyCmd",
    from = "SceneUser2"
  },
  UploadWeddingPhotoUserCmd = {
    id = 90119,
    req = "Cmd.UploadWeddingPhotoUserCmd",
    ack = "Cmd.UploadWeddingPhotoUserCmd",
    from = "SceneUser2"
  },
  MarriageProposalSuccessCmd = {
    id = 90120,
    req = "Cmd.MarriageProposalSuccessCmd",
    ack = "Cmd.MarriageProposalSuccessCmd",
    from = "SceneUser2"
  },
  InviteeWeddingStartNtfUserCmd = {
    id = 90121,
    req = "Cmd.InviteeWeddingStartNtfUserCmd",
    ack = "Cmd.InviteeWeddingStartNtfUserCmd",
    from = "SceneUser2"
  },
  KFCShareUserCmd = {
    id = 90128,
    req = "Cmd.KFCShareUserCmd",
    ack = "Cmd.KFCShareUserCmd",
    from = "SceneUser2"
  },
  KFCEnrollUserCmd = {
    id = 90162,
    req = "Cmd.KFCEnrollUserCmd",
    ack = "Cmd.KFCEnrollUserCmd",
    from = "SceneUser2"
  },
  KFCEnrollCodeUserCmd = {
    id = 90168,
    req = "Cmd.KFCEnrollCodeUserCmd",
    ack = "Cmd.KFCEnrollCodeUserCmd",
    from = "SceneUser2"
  },
  KFCEnrollReplyUserCmd = {
    id = 90163,
    req = "Cmd.KFCEnrollReplyUserCmd",
    ack = "Cmd.KFCEnrollReplyUserCmd",
    from = "SceneUser2"
  },
  KFCEnrollQueryUserCmd = {
    id = 90167,
    req = "Cmd.KFCEnrollQueryUserCmd",
    ack = "Cmd.KFCEnrollQueryUserCmd",
    from = "SceneUser2"
  },
  KFCHasEnrolledUserCmd = {
    id = 90166,
    req = "Cmd.KFCHasEnrolledUserCmd",
    ack = "Cmd.KFCHasEnrolledUserCmd",
    from = "SceneUser2"
  },
  CheckRelationUserCmd = {
    id = 90130,
    req = "Cmd.CheckRelationUserCmd",
    ack = "Cmd.CheckRelationUserCmd",
    from = "SceneUser2"
  },
  TwinsActionUserCmd = {
    id = 90129,
    req = "Cmd.TwinsActionUserCmd",
    ack = "Cmd.TwinsActionUserCmd",
    from = "SceneUser2"
  },
  ShowServantUserCmd = {
    id = 90122,
    req = "Cmd.ShowServantUserCmd",
    ack = "Cmd.ShowServantUserCmd",
    from = "SceneUser2"
  },
  ReplaceServantUserCmd = {
    id = 90123,
    req = "Cmd.ReplaceServantUserCmd",
    ack = "Cmd.ReplaceServantUserCmd",
    from = "SceneUser2"
  },
  HireServantUserCmd = {
    id = 90255,
    req = "Cmd.HireServantUserCmd",
    ack = "Cmd.HireServantUserCmd",
    from = "SceneUser2"
  },
  ServantService = {
    id = 90124,
    req = "Cmd.ServantService",
    ack = "Cmd.ServantService",
    from = "SceneUser2"
  },
  RecommendServantUserCmd = {
    id = 90125,
    req = "Cmd.RecommendServantUserCmd",
    ack = "Cmd.RecommendServantUserCmd",
    from = "SceneUser2"
  },
  ReceiveServantUserCmd = {
    id = 90126,
    req = "Cmd.ReceiveServantUserCmd",
    ack = "Cmd.ReceiveServantUserCmd",
    from = "SceneUser2"
  },
  ServantRewardStatusUserCmd = {
    id = 90127,
    req = "Cmd.ServantRewardStatusUserCmd",
    ack = "Cmd.ServantRewardStatusUserCmd",
    from = "SceneUser2"
  },
  ProfessionQueryUserCmd = {
    id = 90131,
    req = "Cmd.ProfessionQueryUserCmd",
    ack = "Cmd.ProfessionQueryUserCmd",
    from = "SceneUser2"
  },
  ProfessionBuyUserCmd = {
    id = 90132,
    req = "Cmd.ProfessionBuyUserCmd",
    ack = "Cmd.ProfessionBuyUserCmd",
    from = "SceneUser2"
  },
  ProfessionChangeUserCmd = {
    id = 90133,
    req = "Cmd.ProfessionChangeUserCmd",
    ack = "Cmd.ProfessionChangeUserCmd",
    from = "SceneUser2"
  },
  ProfessionUserInfo = {
    id = 1,
    req = "Cmd.ProfessionUserInfo",
    ack = "Cmd.ProfessionUserInfo",
    from = "SceneUser2"
  },
  SlotInfo = {
    id = 1,
    req = "Cmd.SlotInfo",
    ack = "Cmd.SlotInfo",
    from = "SceneUser2"
  },
  UpdateRecordInfoUserCmd = {
    id = 90134,
    req = "Cmd.UpdateRecordInfoUserCmd",
    ack = "Cmd.UpdateRecordInfoUserCmd",
    from = "SceneUser2"
  },
  SaveRecordUserCmd = {
    id = 90135,
    req = "Cmd.SaveRecordUserCmd",
    ack = "Cmd.SaveRecordUserCmd",
    from = "SceneUser2"
  },
  LoadRecordUserCmd = {
    id = 90136,
    req = "Cmd.LoadRecordUserCmd",
    ack = "Cmd.LoadRecordUserCmd",
    from = "SceneUser2"
  },
  ChangeRecordNameUserCmd = {
    id = 90137,
    req = "Cmd.ChangeRecordNameUserCmd",
    ack = "Cmd.ChangeRecordNameUserCmd",
    from = "SceneUser2"
  },
  BuyRecordSlotUserCmd = {
    id = 90138,
    req = "Cmd.BuyRecordSlotUserCmd",
    ack = "Cmd.BuyRecordSlotUserCmd",
    from = "SceneUser2"
  },
  DeleteRecordUserCmd = {
    id = 90139,
    req = "Cmd.DeleteRecordUserCmd",
    ack = "Cmd.DeleteRecordUserCmd",
    from = "SceneUser2"
  },
  UpdateBranchInfoUserCmd = {
    id = 90140,
    req = "Cmd.UpdateBranchInfoUserCmd",
    ack = "Cmd.UpdateBranchInfoUserCmd",
    from = "SceneUser2"
  },
  EnterCapraActivityCmd = {
    id = 90110,
    req = "Cmd.EnterCapraActivityCmd",
    ack = "Cmd.EnterCapraActivityCmd",
    from = "SceneUser2"
  },
  InviteWithMeUserCmd = {
    id = 90142,
    req = "Cmd.InviteWithMeUserCmd",
    ack = "Cmd.InviteWithMeUserCmd",
    from = "SceneUser2"
  },
  QueryAltmanKillUserCmd = {
    id = 90143,
    req = "Cmd.QueryAltmanKillUserCmd",
    ack = "Cmd.QueryAltmanKillUserCmd",
    from = "SceneUser2"
  },
  BoothReqUserCmd = {
    id = 90144,
    req = "Cmd.BoothReqUserCmd",
    ack = "Cmd.BoothReqUserCmd",
    from = "SceneUser2"
  },
  BoothInfoSyncUserCmd = {
    id = 90145,
    req = "Cmd.BoothInfoSyncUserCmd",
    ack = "Cmd.BoothInfoSyncUserCmd",
    from = "SceneUser2"
  },
  DressUpModelUserCmd = {
    id = 90146,
    req = "Cmd.DressUpModelUserCmd",
    ack = "Cmd.DressUpModelUserCmd",
    from = "SceneUser2"
  },
  DressUpHeadUserCmd = {
    id = 90147,
    req = "Cmd.DressUpHeadUserCmd",
    ack = "Cmd.DressUpHeadUserCmd",
    from = "SceneUser2"
  },
  QueryStageUserCmd = {
    id = 90148,
    req = "Cmd.QueryStageUserCmd",
    ack = "Cmd.QueryStageUserCmd",
    from = "SceneUser2"
  },
  DressUpLineUpUserCmd = {
    id = 90149,
    req = "Cmd.DressUpLineUpUserCmd",
    ack = "Cmd.DressUpLineUpUserCmd",
    from = "SceneUser2"
  },
  DressUpStageUserCmd = {
    id = 90150,
    req = "Cmd.DressUpStageUserCmd",
    ack = "Cmd.DressUpStageUserCmd",
    from = "SceneUser2"
  },
  GoToFunctionMapUserCmd = {
    id = 90141,
    req = "Cmd.GoToFunctionMapUserCmd",
    ack = "Cmd.GoToFunctionMapUserCmd",
    from = "SceneUser2"
  },
  GrowthCurInfo = {
    id = 1,
    req = "Cmd.GrowthCurInfo",
    ack = "Cmd.GrowthCurInfo",
    from = "SceneUser2"
  },
  GrowthServantUserCmd = {
    id = 90154,
    req = "Cmd.GrowthServantUserCmd",
    ack = "Cmd.GrowthServantUserCmd",
    from = "SceneUser2"
  },
  ReceiveGrowthServantUserCmd = {
    id = 90155,
    req = "Cmd.ReceiveGrowthServantUserCmd",
    ack = "Cmd.ReceiveGrowthServantUserCmd",
    from = "SceneUser2"
  },
  GrowthOpenServantUserCmd = {
    id = 90156,
    req = "Cmd.GrowthOpenServantUserCmd",
    ack = "Cmd.GrowthOpenServantUserCmd",
    from = "SceneUser2"
  },
  CheatTagUserCmd = {
    id = 90157,
    req = "Cmd.CheatTagUserCmd",
    ack = "Cmd.CheatTagUserCmd",
    from = "SceneUser2"
  },
  CheatTagStatUserCmd = {
    id = 90158,
    req = "Cmd.CheatTagStatUserCmd",
    ack = "Cmd.CheatTagStatUserCmd",
    from = "SceneUser2"
  },
  ClickPosList = {
    id = 90159,
    req = "Cmd.ClickPosList",
    ack = "Cmd.ClickPosList",
    from = "SceneUser2"
  },
  ServerInfoNtf = {
    id = 90169,
    req = "Cmd.ServerInfoNtf",
    ack = "Cmd.ServerInfoNtf",
    from = "SceneUser2"
  },
  ReadyToMapUserCmd = {
    id = 90174,
    req = "Cmd.ReadyToMapUserCmd",
    ack = "Cmd.ReadyToMapUserCmd",
    from = "SceneUser2"
  },
  SignInUserCmd = {
    id = 90164,
    req = "Cmd.SignInUserCmd",
    ack = "Cmd.SignInUserCmd",
    from = "SceneUser2"
  },
  SignInNtfUserCmd = {
    id = 90165,
    req = "Cmd.SignInNtfUserCmd",
    ack = "Cmd.SignInNtfUserCmd",
    from = "SceneUser2"
  },
  BeatPoriUserCmd = {
    id = 90160,
    req = "Cmd.BeatPoriUserCmd",
    ack = "Cmd.BeatPoriUserCmd",
    from = "SceneUser2"
  },
  UnlockFrameUserCmd = {
    id = 90161,
    req = "Cmd.UnlockFrameUserCmd",
    ack = "Cmd.UnlockFrameUserCmd",
    from = "SceneUser2"
  },
  AltmanRewardUserCmd = {
    id = 90170,
    req = "Cmd.AltmanRewardUserCmd",
    ack = "Cmd.AltmanRewardUserCmd",
    from = "SceneUser2"
  },
  ServantReservationItem = {
    id = 1,
    req = "Cmd.ServantReservationItem",
    ack = "Cmd.ServantReservationItem",
    from = "SceneUser2"
  },
  ServantReqReservationUserCmd = {
    id = 90171,
    req = "Cmd.ServantReqReservationUserCmd",
    ack = "Cmd.ServantReqReservationUserCmd",
    from = "SceneUser2"
  },
  ServantReservationUserCmd = {
    id = 90172,
    req = "Cmd.ServantReservationUserCmd",
    ack = "Cmd.ServantReservationUserCmd",
    from = "SceneUser2"
  },
  ServantRecEquipUserCmd = {
    id = 90173,
    req = "Cmd.ServantRecEquipUserCmd",
    ack = "Cmd.ServantRecEquipUserCmd",
    from = "SceneUser2"
  },
  PrestigeNtfUserCmd = {
    id = 90175,
    req = "Cmd.PrestigeNtfUserCmd",
    ack = "Cmd.PrestigeNtfUserCmd",
    from = "SceneUser2"
  },
  PrestigeGiveUserCmd = {
    id = 90176,
    req = "Cmd.PrestigeGiveUserCmd",
    ack = "Cmd.PrestigeGiveUserCmd",
    from = "SceneUser2"
  },
  UpdateGameHealthLevelUserCmd = {
    id = 90178,
    req = "Cmd.UpdateGameHealthLevelUserCmd",
    ack = "Cmd.UpdateGameHealthLevelUserCmd",
    from = "SceneUser2"
  },
  GameHealthEventStatUserCmd = {
    id = 90179,
    req = "Cmd.GameHealthEventStatUserCmd",
    ack = "Cmd.GameHealthEventStatUserCmd",
    from = "SceneUser2"
  },
  Fishway2KillBossInformUserCmd = {
    id = 90181,
    req = "Cmd.Fishway2KillBossInformUserCmd",
    ack = "Cmd.Fishway2KillBossInformUserCmd",
    from = "SceneUser2"
  },
  ActPointUserCmd = {
    id = 90177,
    req = "Cmd.ActPointUserCmd",
    ack = "Cmd.ActPointUserCmd",
    from = "SceneUser2"
  },
  HighRefineAttrUserCmd = {
    id = 90182,
    req = "Cmd.HighRefineAttrUserCmd",
    ack = "Cmd.HighRefineAttrUserCmd",
    from = "SceneUser2"
  },
  HeadwearNpcUserCmd = {
    id = 90183,
    req = "Cmd.HeadwearNpcUserCmd",
    ack = "Cmd.HeadwearNpcUserCmd",
    from = "SceneUser2"
  },
  HeadwearRoundUserCmd = {
    id = 90184,
    req = "Cmd.HeadwearRoundUserCmd",
    ack = "Cmd.HeadwearRoundUserCmd",
    from = "SceneUser2"
  },
  HeadwearTowerUserCmd = {
    id = 90185,
    req = "Cmd.HeadwearTowerUserCmd",
    ack = "Cmd.HeadwearTowerUserCmd",
    from = "SceneUser2"
  },
  HeadwearEndUserCmd = {
    id = 90186,
    req = "Cmd.HeadwearEndUserCmd",
    ack = "Cmd.HeadwearEndUserCmd",
    from = "SceneUser2"
  },
  HeadwearRangeUserCmd = {
    id = 90187,
    req = "Cmd.HeadwearRangeUserCmd",
    ack = "Cmd.HeadwearRangeUserCmd",
    from = "SceneUser2"
  },
  ServantStatisticsUserCmd = {
    id = 90191,
    req = "Cmd.ServantStatisticsUserCmd",
    ack = "Cmd.ServantStatisticsUserCmd",
    from = "SceneUser2"
  },
  ServantStatisticsMailUserCmd = {
    id = 90192,
    req = "Cmd.ServantStatisticsMailUserCmd",
    ack = "Cmd.ServantStatisticsMailUserCmd",
    from = "SceneUser2"
  },
  HeadwearOpenUserCmd = {
    id = 90201,
    req = "Cmd.HeadwearOpenUserCmd",
    ack = "Cmd.HeadwearOpenUserCmd",
    from = "SceneUser2"
  },
  FastTransClassUserCmd = {
    id = 90198,
    req = "Cmd.FastTransClassUserCmd",
    ack = "Cmd.FastTransClassUserCmd",
    from = "SceneUser2"
  },
  FastTransGemQueryUserCmd = {
    id = 90199,
    req = "Cmd.FastTransGemQueryUserCmd",
    ack = "Cmd.FastTransGemQueryUserCmd",
    from = "SceneUser2"
  },
  FastTransGemGetUserCmd = {
    id = 90200,
    req = "Cmd.FastTransGemGetUserCmd",
    ack = "Cmd.FastTransGemGetUserCmd",
    from = "SceneUser2"
  },
  FourthSkillCostGetUserCmd = {
    id = 90205,
    req = "Cmd.FourthSkillCostGetUserCmd",
    ack = "Cmd.FourthSkillCostGetUserCmd",
    from = "SceneUser2"
  },
  BuildDataQueryUserCmd = {
    id = 90202,
    req = "Cmd.BuildDataQueryUserCmd",
    ack = "Cmd.BuildDataQueryUserCmd",
    from = "SceneUser2"
  },
  BuildContributeUserCmd = {
    id = 90203,
    req = "Cmd.BuildContributeUserCmd",
    ack = "Cmd.BuildContributeUserCmd",
    from = "SceneUser2"
  },
  BuildOperateUserCmd = {
    id = 90204,
    req = "Cmd.BuildOperateUserCmd",
    ack = "Cmd.BuildOperateUserCmd",
    from = "SceneUser2"
  },
  NightmareAttrQueryUserCmd = {
    id = 90211,
    req = "Cmd.NightmareAttrQueryUserCmd",
    ack = "Cmd.NightmareAttrQueryUserCmd",
    from = "SceneUser2"
  },
  NightmareAttrGetUserCmd = {
    id = 90212,
    req = "Cmd.NightmareAttrGetUserCmd",
    ack = "Cmd.NightmareAttrGetUserCmd",
    from = "SceneUser2"
  },
  MapAnimeUserCmd = {
    id = 90197,
    req = "Cmd.MapAnimeUserCmd",
    ack = "Cmd.MapAnimeUserCmd",
    from = "SceneUser2"
  },
  ShootNpcUserCmd = {
    id = 90216,
    req = "Cmd.ShootNpcUserCmd",
    ack = "Cmd.ShootNpcUserCmd",
    from = "SceneUser2"
  },
  PaySignNtfUserCmd = {
    id = 90217,
    req = "Cmd.PaySignNtfUserCmd",
    ack = "Cmd.PaySignNtfUserCmd",
    from = "SceneUser2"
  },
  PaySignBuyUserCmd = {
    id = 90218,
    req = "Cmd.PaySignBuyUserCmd",
    ack = "Cmd.PaySignBuyUserCmd",
    from = "SceneUser2"
  },
  PaySignRewardUserCmd = {
    id = 90219,
    req = "Cmd.PaySignRewardUserCmd",
    ack = "Cmd.PaySignRewardUserCmd",
    from = "SceneUser2"
  },
  ExtractionQueryUserCmd = {
    id = 90206,
    req = "Cmd.ExtractionQueryUserCmd",
    ack = "Cmd.ExtractionQueryUserCmd",
    from = "SceneUser2"
  },
  ExtractionOperateUserCmd = {
    id = 90207,
    req = "Cmd.ExtractionOperateUserCmd",
    ack = "Cmd.ExtractionOperateUserCmd",
    from = "SceneUser2"
  },
  ExtractionActiveUserCmd = {
    id = 90208,
    req = "Cmd.ExtractionActiveUserCmd",
    ack = "Cmd.ExtractionActiveUserCmd",
    from = "SceneUser2"
  },
  ExtractionRemoveUserCmd = {
    id = 90209,
    req = "Cmd.ExtractionRemoveUserCmd",
    ack = "Cmd.ExtractionRemoveUserCmd",
    from = "SceneUser2"
  },
  ExtractionGridBuyUserCmd = {
    id = 90210,
    req = "Cmd.ExtractionGridBuyUserCmd",
    ack = "Cmd.ExtractionGridBuyUserCmd",
    from = "SceneUser2"
  },
  ExtractionRefreshUserCmd = {
    id = 90214,
    req = "Cmd.ExtractionRefreshUserCmd",
    ack = "Cmd.ExtractionRefreshUserCmd",
    from = "SceneUser2"
  },
  TeamExpRewardTypeCmd = {
    id = 90220,
    req = "Cmd.TeamExpRewardTypeCmd",
    ack = "Cmd.TeamExpRewardTypeCmd",
    from = "SceneUser2"
  },
  SetMyselfOptionCmd = {
    id = 90221,
    req = "Cmd.SetMyselfOptionCmd",
    ack = "Cmd.SetMyselfOptionCmd",
    from = "SceneUser2"
  },
  UseSkillEffectItemUserCmd = {
    id = 90231,
    req = "Cmd.UseSkillEffectItemUserCmd",
    ack = "Cmd.UseSkillEffectItemUserCmd",
    from = "SceneUser2"
  },
  RideMultiMountUserCmd = {
    id = 90193,
    req = "Cmd.RideMultiMountUserCmd",
    ack = "Cmd.RideMultiMountUserCmd",
    from = "SceneUser2"
  },
  KickOffPassengerUserCmd = {
    id = 90194,
    req = "Cmd.KickOffPassengerUserCmd",
    ack = "Cmd.KickOffPassengerUserCmd",
    from = "SceneUser2"
  },
  SetMultiMountOptUserCmd = {
    id = 90195,
    req = "Cmd.SetMultiMountOptUserCmd",
    ack = "Cmd.SetMultiMountOptUserCmd",
    from = "SceneUser2"
  },
  MultiMountChangePosUserCmd = {
    id = 90196,
    req = "Cmd.MultiMountChangePosUserCmd",
    ack = "Cmd.MultiMountChangePosUserCmd",
    from = "SceneUser2"
  },
  GrouponQueryUserCmd = {
    id = 90222,
    req = "Cmd.GrouponQueryUserCmd",
    ack = "Cmd.GrouponQueryUserCmd",
    from = "SceneUser2"
  },
  GrouponBuyUserCmd = {
    id = 90223,
    req = "Cmd.GrouponBuyUserCmd",
    ack = "Cmd.GrouponBuyUserCmd",
    from = "SceneUser2"
  },
  GrouponRewardUserCmd = {
    id = 90224,
    req = "Cmd.GrouponRewardUserCmd",
    ack = "Cmd.GrouponRewardUserCmd",
    from = "SceneUser2"
  },
  NtfPlayActUserCmd = {
    id = 90228,
    req = "Cmd.NtfPlayActUserCmd",
    ack = "Cmd.NtfPlayActUserCmd",
    from = "SceneUser2"
  },
  NoviceTargetUpdateUserCmd = {
    id = 90225,
    req = "Cmd.NoviceTargetUpdateUserCmd",
    ack = "Cmd.NoviceTargetUpdateUserCmd",
    from = "SceneUser2"
  },
  NoviceTargetRewardUserCmd = {
    id = 90229,
    req = "Cmd.NoviceTargetRewardUserCmd",
    ack = "Cmd.NoviceTargetRewardUserCmd",
    from = "SceneUser2"
  },
  SetBoKiStateUserCmd = {
    id = 90234,
    req = "Cmd.SetBoKiStateUserCmd",
    ack = "Cmd.SetBoKiStateUserCmd",
    from = "SceneUser2"
  },
  CloseDialogMaskUserCmd = {
    id = 90239,
    req = "Cmd.CloseDialogMaskUserCmd",
    ack = "Cmd.CloseDialogMaskUserCmd",
    from = "SceneUser2"
  },
  CloseDialogCameraUserCmd = {
    id = 90240,
    req = "Cmd.CloseDialogCameraUserCmd",
    ack = "Cmd.CloseDialogCameraUserCmd",
    from = "SceneUser2"
  },
  HideUIUserCmd = {
    id = 90241,
    req = "Cmd.HideUIUserCmd",
    ack = "Cmd.HideUIUserCmd",
    from = "SceneUser2"
  },
  QueryMapMonsterRefreshInfo = {
    id = 90233,
    req = "Cmd.QueryMapMonsterRefreshInfo",
    ack = "Cmd.QueryMapMonsterRefreshInfo",
    from = "SceneUser2"
  },
  SetCameraUserCmd = {
    id = 90242,
    req = "Cmd.SetCameraUserCmd",
    ack = "Cmd.SetCameraUserCmd",
    from = "SceneUser2"
  },
  QueryProfessionDataDetailUserCmd = {
    id = 90215,
    req = "Cmd.QueryProfessionDataDetailUserCmd",
    ack = "Cmd.QueryProfessionDataDetailUserCmd",
    from = "SceneUser2"
  },
  ClearProfessionDataDetailUserCmd = {
    id = 90246,
    req = "Cmd.ClearProfessionDataDetailUserCmd",
    ack = "Cmd.ClearProfessionDataDetailUserCmd",
    from = "SceneUser2"
  },
  ChainExchangeUserCmd = {
    id = 90243,
    req = "Cmd.ChainExchangeUserCmd",
    ack = "Cmd.ChainExchangeUserCmd",
    from = "SceneUser2"
  },
  ChainOptUserCmd = {
    id = 90244,
    req = "Cmd.ChainOptUserCmd",
    ack = "Cmd.ChainOptUserCmd",
    from = "SceneUser2"
  },
  ActivityDonateQueryUserCmd = {
    id = 90247,
    req = "Cmd.ActivityDonateQueryUserCmd",
    ack = "Cmd.ActivityDonateQueryUserCmd",
    from = "SceneUser2"
  },
  ActivityDonateRewardUserCmd = {
    id = 90248,
    req = "Cmd.ActivityDonateRewardUserCmd",
    ack = "Cmd.ActivityDonateRewardUserCmd",
    from = "SceneUser2"
  },
  ChangeHairUserCmd = {
    id = 90249,
    req = "Cmd.ChangeHairUserCmd",
    ack = "Cmd.ChangeHairUserCmd",
    from = "SceneUser2"
  },
  ChangeEyeUserCmd = {
    id = 90250,
    req = "Cmd.ChangeEyeUserCmd",
    ack = "Cmd.ChangeEyeUserCmd",
    from = "SceneUser2"
  },
  HappyValueUserCmd = {
    id = 90245,
    req = "Cmd.HappyValueUserCmd",
    ack = "Cmd.HappyValueUserCmd",
    from = "SceneUser2"
  },
  SendTargetPosUserCmd = {
    id = 90251,
    req = "Cmd.SendTargetPosUserCmd",
    ack = "Cmd.SendTargetPosUserCmd",
    from = "SceneUser2"
  },
  CookGameFinishUserCmd = {
    id = 90252,
    req = "Cmd.CookGameFinishUserCmd",
    ack = "Cmd.CookGameFinishUserCmd",
    from = "SceneUser2"
  },
  RaceGameStartUserCmd = {
    id = 90253,
    req = "Cmd.RaceGameStartUserCmd",
    ack = "Cmd.RaceGameStartUserCmd",
    from = "SceneUser2"
  },
  RaceGameFinishUserCmd = {
    id = 90254,
    req = "Cmd.RaceGameFinishUserCmd",
    ack = "Cmd.RaceGameFinishUserCmd",
    from = "SceneUser2"
  },
  SendMarksInfoUserCmd = {
    id = 90226,
    req = "Cmd.SendMarksInfoUserCmd",
    ack = "Cmd.SendMarksInfoUserCmd",
    from = "SceneUser2"
  },
  UserSyncBuffFromUserCmd = {
    id = 90227,
    req = "Cmd.UserSyncBuffFromUserCmd",
    ack = "Cmd.UserSyncBuffFromUserCmd",
    from = "SceneUser2"
  },
  FirstDepositInfo = {
    id = 820001,
    req = "Cmd.FirstDepositInfo",
    ack = "Cmd.FirstDepositInfo",
    from = "SceneUser3"
  },
  FirstDepositReward = {
    id = 820002,
    req = "Cmd.FirstDepositReward",
    ack = "Cmd.FirstDepositReward",
    from = "SceneUser3"
  },
  ClientPayLog = {
    id = 820003,
    req = "Cmd.ClientPayLog",
    ack = "Cmd.ClientPayLog",
    from = "SceneUser3"
  },
  DailyDepositInfo = {
    id = 820004,
    req = "Cmd.DailyDepositInfo",
    ack = "Cmd.DailyDepositInfo",
    from = "SceneUser3"
  },
  DailyDepositGetReward = {
    id = 820005,
    req = "Cmd.DailyDepositGetReward",
    ack = "Cmd.DailyDepositGetReward",
    from = "SceneUser3"
  },
  BattleTimeCostSelectCmd = {
    id = 820006,
    req = "Cmd.BattleTimeCostSelectCmd",
    ack = "Cmd.BattleTimeCostSelectCmd",
    from = "SceneUser3"
  },
  PlugInNotify = {
    id = 820009,
    req = "Cmd.PlugInNotify",
    ack = "Cmd.PlugInNotify",
    from = "SceneUser3"
  },
  PlugInUpload = {
    id = 820010,
    req = "Cmd.PlugInUpload",
    ack = "Cmd.PlugInUpload",
    from = "SceneUser3"
  },
  HeroStoryQuestInfo = {
    id = 820015,
    req = "Cmd.HeroStoryQuestInfo",
    ack = "Cmd.HeroStoryQuestInfo",
    from = "SceneUser3"
  },
  HeroStoryQuestAccept = {
    id = 820016,
    req = "Cmd.HeroStoryQuestAccept",
    ack = "Cmd.HeroStoryQuestAccept",
    from = "SceneUser3"
  },
  HeroQuestReward = {
    id = 820014,
    req = "Cmd.HeroQuestReward",
    ack = "Cmd.HeroQuestReward",
    from = "SceneUser3"
  },
  HeroGrowthQuestInfo = {
    id = 820013,
    req = "Cmd.HeroGrowthQuestInfo",
    ack = "Cmd.HeroGrowthQuestInfo",
    from = "SceneUser3"
  },
  QueryProfessionRecordSimpleData = {
    id = 820008,
    req = "Cmd.QueryProfessionRecordSimpleData",
    ack = "Cmd.QueryProfessionRecordSimpleData",
    from = "SceneUser3"
  },
  HeroBuyUserCmd = {
    id = 820011,
    req = "Cmd.HeroBuyUserCmd",
    ack = "Cmd.HeroBuyUserCmd",
    from = "SceneUser3"
  },
  HeroShowUserCmd = {
    id = 820012,
    req = "Cmd.HeroShowUserCmd",
    ack = "Cmd.HeroShowUserCmd",
    from = "SceneUser3"
  },
  AccumDepositInfo = {
    id = 820017,
    req = "Cmd.AccumDepositInfo",
    ack = "Cmd.AccumDepositInfo",
    from = "SceneUser3"
  },
  AccumDepositReward = {
    id = 820018,
    req = "Cmd.AccumDepositReward",
    ack = "Cmd.AccumDepositReward",
    from = "SceneUser3"
  },
  BoliGoldGetReward = {
    id = 820019,
    req = "Cmd.BoliGoldGetReward",
    ack = "Cmd.BoliGoldGetReward",
    from = "SceneUser3"
  },
  BoliGoldInfo = {
    id = 820020,
    req = "Cmd.BoliGoldInfo",
    ack = "Cmd.BoliGoldInfo",
    from = "SceneUser3"
  },
  BoliGoldGetFreeReward = {
    id = 820021,
    req = "Cmd.BoliGoldGetFreeReward",
    ack = "Cmd.BoliGoldGetFreeReward",
    from = "SceneUser3"
  },
  ResourceCheckUserCmd = {
    id = 820022,
    req = "Cmd.ResourceCheckUserCmd",
    ack = "Cmd.ResourceCheckUserCmd",
    from = "SceneUser3"
  },
  NoviceChargeSync = {
    id = 820024,
    req = "Cmd.NoviceChargeSync",
    ack = "Cmd.NoviceChargeSync",
    from = "SceneUser3"
  },
  NoviceChargeReward = {
    id = 820025,
    req = "Cmd.NoviceChargeReward",
    ack = "Cmd.NoviceChargeReward",
    from = "SceneUser3"
  },
  EquipPosEffectTime = {
    id = 820027,
    req = "Cmd.EquipPosEffectTime",
    ack = "Cmd.EquipPosEffectTime",
    from = "SceneUser3"
  },
  UpdateRecordSlotIndex = {
    id = 820023,
    req = "Cmd.UpdateRecordSlotIndex",
    ack = "Cmd.UpdateRecordSlotIndex",
    from = "SceneUser3"
  },
  SyncInterferenceData = {
    id = 820026,
    req = "Cmd.SyncInterferenceData",
    ack = "Cmd.SyncInterferenceData",
    from = "SceneUser3"
  },
  GetResourceRewardCmd = {
    id = 820028,
    req = "Cmd.GetResourceRewardCmd",
    ack = "Cmd.GetResourceRewardCmd",
    from = "SceneUser3"
  },
  AuthQueryUserCmd = {
    id = 820031,
    req = "Cmd.AuthQueryUserCmd",
    ack = "Cmd.AuthQueryUserCmd",
    from = "SceneUser3"
  },
  AuthUpdateUserCmd = {
    id = 820032,
    req = "Cmd.AuthUpdateUserCmd",
    ack = "Cmd.AuthUpdateUserCmd",
    from = "SceneUser3"
  },
  ActionStatUserCmd = {
    id = 820033,
    req = "Cmd.ActionStatUserCmd",
    ack = "Cmd.ActionStatUserCmd",
    from = "SceneUser3"
  },
  UnlockDress = {
    id = 820029,
    req = "Cmd.UnlockDress",
    ack = "Cmd.UnlockDress",
    from = "SceneUser3"
  },
  QueryPrestigeCmd = {
    id = 820034,
    req = "Cmd.QueryPrestigeCmd",
    ack = "Cmd.QueryPrestigeCmd",
    from = "SceneUser3"
  },
  PrestigeLevelUpNotifyCmd = {
    id = 820035,
    req = "Cmd.PrestigeLevelUpNotifyCmd",
    ack = "Cmd.PrestigeLevelUpNotifyCmd",
    from = "SceneUser3"
  },
  SuperSignInUserCmd = {
    id = 820036,
    req = "Cmd.SuperSignInUserCmd",
    ack = "Cmd.SuperSignInUserCmd",
    from = "SceneUser3"
  },
  SuperSignInNtfUserCmd = {
    id = 820037,
    req = "Cmd.SuperSignInNtfUserCmd",
    ack = "Cmd.SuperSignInNtfUserCmd",
    from = "SceneUser3"
  },
  PrestigeRewardCmd = {
    id = 820038,
    req = "Cmd.PrestigeRewardCmd",
    ack = "Cmd.PrestigeRewardCmd",
    from = "SceneUser3"
  },
  QueryQuestSignInfoUserCmd = {
    id = 820039,
    req = "Cmd.QueryQuestSignInfoUserCmd",
    ack = "Cmd.QueryQuestSignInfoUserCmd",
    from = "SceneUser3"
  },
  LightFireworkUserCmd = {
    id = 820040,
    req = "Cmd.LightFireworkUserCmd",
    ack = "Cmd.LightFireworkUserCmd",
    from = "SceneUser3"
  },
  RemoveFireworkUserCmd = {
    id = 820041,
    req = "Cmd.RemoveFireworkUserCmd",
    ack = "Cmd.RemoveFireworkUserCmd",
    from = "SceneUser3"
  },
  QueryYearMemoryUserCmd = {
    id = 820042,
    req = "Cmd.QueryYearMemoryUserCmd",
    ack = "Cmd.QueryYearMemoryUserCmd",
    from = "SceneUser3"
  },
  YearMemoryProcessUserCmd = {
    id = 820043,
    req = "Cmd.YearMemoryProcessUserCmd",
    ack = "Cmd.YearMemoryProcessUserCmd",
    from = "SceneUser3"
  },
  SetYearMemoryTitleUserCmd = {
    id = 820044,
    req = "Cmd.SetYearMemoryTitleUserCmd",
    ack = "Cmd.SetYearMemoryTitleUserCmd",
    from = "SceneUser3"
  },
  ActivityExchangeGiftsQueryUserCmd = {
    id = 820045,
    req = "Cmd.ActivityExchangeGiftsQueryUserCmd",
    ack = "Cmd.ActivityExchangeGiftsQueryUserCmd",
    from = "SceneUser3"
  },
  ActivityExchangeGiftsRewardUserCmd = {
    id = 820046,
    req = "Cmd.ActivityExchangeGiftsRewardUserCmd",
    ack = "Cmd.ActivityExchangeGiftsRewardUserCmd",
    from = "SceneUser3"
  },
  GvgExcellectQueryUserCmd = {
    id = 820047,
    req = "Cmd.GvgExcellectQueryUserCmd",
    ack = "Cmd.GvgExcellectQueryUserCmd",
    from = "SceneUser3"
  },
  EffectInfoSyncUserCmd = {
    id = 820049,
    req = "Cmd.EffectInfoSyncUserCmd",
    ack = "Cmd.EffectInfoSyncUserCmd",
    from = "SceneUser3"
  },
  EffectInfoUpdateUserCmd = {
    id = 820050,
    req = "Cmd.EffectInfoUpdateUserCmd",
    ack = "Cmd.EffectInfoUpdateUserCmd",
    from = "SceneUser3"
  },
  EffectInfoUseUserCmd = {
    id = 820051,
    req = "Cmd.EffectInfoUseUserCmd",
    ack = "Cmd.EffectInfoUseUserCmd",
    from = "SceneUser3"
  },
  GvgExcellectRewardUserCmd = {
    id = 820048,
    req = "Cmd.GvgExcellectRewardUserCmd",
    ack = "Cmd.GvgExcellectRewardUserCmd",
    from = "SceneUser3"
  },
  BattleTimeOffUserCmd = {
    id = 820052,
    req = "Cmd.BattleTimeOffUserCmd",
    ack = "Cmd.BattleTimeOffUserCmd",
    from = "SceneUser3"
  },
  PlayTimeOffUserCmd = {
    id = 820053,
    req = "Cmd.PlayTimeOffUserCmd",
    ack = "Cmd.PlayTimeOffUserCmd",
    from = "SceneUser3"
  },
  WareHouseOperationCmd = {
    id = 820054,
    req = "Cmd.WareHouseOperationCmd",
    ack = "Cmd.WareHouseOperationCmd",
    from = "SceneUser3"
  },
  FairyTaleRankQueryCmd = {
    id = 820055,
    req = "Cmd.FairyTaleRankQueryCmd",
    ack = "Cmd.FairyTaleRankQueryCmd",
    from = "SceneUser3"
  },
  QueryAllMail = {
    id = 550001,
    req = "Cmd.QueryAllMail",
    ack = "Cmd.QueryAllMail",
    from = "SessionMail"
  },
  MailUpdate = {
    id = 550002,
    req = "Cmd.MailUpdate",
    ack = "Cmd.MailUpdate",
    from = "SessionMail"
  },
  GetMailAttach = {
    id = 550003,
    req = "Cmd.GetMailAttach",
    ack = "Cmd.GetMailAttach",
    from = "SessionMail"
  },
  MailRead = {
    id = 550004,
    req = "Cmd.MailRead",
    ack = "Cmd.MailRead",
    from = "SessionMail"
  },
  MailRemove = {
    id = 550005,
    req = "Cmd.MailRemove",
    ack = "Cmd.MailRemove",
    from = "SessionMail"
  },
  BuyShopItem = {
    id = 520001,
    req = "Cmd.BuyShopItem",
    ack = "Cmd.BuyShopItem",
    from = "SessionShop"
  },
  QueryShopConfigCmd = {
    id = 520002,
    req = "Cmd.QueryShopConfigCmd",
    ack = "Cmd.QueryShopConfigCmd",
    from = "SessionShop"
  },
  QueryQuickBuyConfigCmd = {
    id = 520003,
    req = "Cmd.QueryQuickBuyConfigCmd",
    ack = "Cmd.QueryQuickBuyConfigCmd",
    from = "SessionShop"
  },
  QueryShopSoldCountCmd = {
    id = 520004,
    req = "Cmd.QueryShopSoldCountCmd",
    ack = "Cmd.QueryShopSoldCountCmd",
    from = "SessionShop"
  },
  ShopDataUpdateCmd = {
    id = 520005,
    req = "Cmd.ShopDataUpdateCmd",
    ack = "Cmd.ShopDataUpdateCmd",
    from = "SessionShop"
  },
  UpdateShopConfigCmd = {
    id = 520006,
    req = "Cmd.UpdateShopConfigCmd",
    ack = "Cmd.UpdateShopConfigCmd",
    from = "SessionShop"
  },
  ExchangeShopItem = {
    id = 1,
    req = "Cmd.ExchangeShopItem",
    ack = "Cmd.ExchangeShopItem",
    from = "SessionShop"
  },
  UpdateExchangeShopData = {
    id = 520007,
    req = "Cmd.UpdateExchangeShopData",
    ack = "Cmd.UpdateExchangeShopData",
    from = "SessionShop"
  },
  ExchangeShopItemCmd = {
    id = 520008,
    req = "Cmd.ExchangeShopItemCmd",
    ack = "Cmd.ExchangeShopItemCmd",
    from = "SessionShop"
  },
  ResetExchangeShopDataShopCmd = {
    id = 520009,
    req = "Cmd.ResetExchangeShopDataShopCmd",
    ack = "Cmd.ResetExchangeShopDataShopCmd",
    from = "SessionShop"
  },
  FreyExchangeShopCmd = {
    id = 520010,
    req = "Cmd.FreyExchangeShopCmd",
    ack = "Cmd.FreyExchangeShopCmd",
    from = "SessionShop"
  },
  OpenShopTypeShopCmd = {
    id = 520011,
    req = "Cmd.OpenShopTypeShopCmd",
    ack = "Cmd.OpenShopTypeShopCmd",
    from = "SessionShop"
  },
  BulkBuyShopItem = {
    id = 520012,
    req = "Cmd.BulkBuyShopItem",
    ack = "Cmd.BulkBuyShopItem",
    from = "SessionShop"
  },
  BuyPackageSaleShopCmd = {
    id = 520013,
    req = "Cmd.BuyPackageSaleShopCmd",
    ack = "Cmd.BuyPackageSaleShopCmd",
    from = "SessionShop"
  },
  BuyDepositProductShopCmd = {
    id = 520014,
    req = "Cmd.BuyDepositProductShopCmd",
    ack = "Cmd.BuyDepositProductShopCmd",
    from = "SessionShop"
  },
  RewardSafetyQueryShopCmd = {
    id = 520015,
    req = "Cmd.RewardSafetyQueryShopCmd",
    ack = "Cmd.RewardSafetyQueryShopCmd",
    from = "SessionShop"
  },
  ExtraBonusQueryShopCmd = {
    id = 520016,
    req = "Cmd.ExtraBonusQueryShopCmd",
    ack = "Cmd.ExtraBonusQueryShopCmd",
    from = "SessionShop"
  },
  ExtraBonusResetShopCmd = {
    id = 520017,
    req = "Cmd.ExtraBonusResetShopCmd",
    ack = "Cmd.ExtraBonusResetShopCmd",
    from = "SessionShop"
  },
  ExtraBonusRewardShopCmd = {
    id = 520018,
    req = "Cmd.ExtraBonusRewardShopCmd",
    ack = "Cmd.ExtraBonusRewardShopCmd",
    from = "SessionShop"
  },
  QuerySocialData = {
    id = 560001,
    req = "Cmd.QuerySocialData",
    ack = "Cmd.QuerySocialData",
    from = "SessionSociality"
  },
  FindUser = {
    id = 560002,
    req = "Cmd.FindUser",
    ack = "Cmd.FindUser",
    from = "SessionSociality"
  },
  SocialUpdate = {
    id = 560003,
    req = "Cmd.SocialUpdate",
    ack = "Cmd.SocialUpdate",
    from = "SessionSociality"
  },
  SocialDataItem = {
    id = 1,
    req = "Cmd.SocialDataItem",
    ack = "Cmd.SocialDataItem",
    from = "SessionSociality"
  },
  SocialDataUpdate = {
    id = 560004,
    req = "Cmd.SocialDataUpdate",
    ack = "Cmd.SocialDataUpdate",
    from = "SessionSociality"
  },
  FrameStatusSocialCmd = {
    id = 560005,
    req = "Cmd.FrameStatusSocialCmd",
    ack = "Cmd.FrameStatusSocialCmd",
    from = "SessionSociality"
  },
  UseGiftCodeSocialCmd = {
    id = 560006,
    req = "Cmd.UseGiftCodeSocialCmd",
    ack = "Cmd.UseGiftCodeSocialCmd",
    from = "SessionSociality"
  },
  OperateQuerySocialCmd = {
    id = 560007,
    req = "Cmd.OperateQuerySocialCmd",
    ack = "Cmd.OperateQuerySocialCmd",
    from = "SessionSociality"
  },
  OperateTakeSocialCmd = {
    id = 560008,
    req = "Cmd.OperateTakeSocialCmd",
    ack = "Cmd.OperateTakeSocialCmd",
    from = "SessionSociality"
  },
  QueryDataNtfSocialCmd = {
    id = 560009,
    req = "Cmd.QueryDataNtfSocialCmd",
    ack = "Cmd.QueryDataNtfSocialCmd",
    from = "SessionSociality"
  },
  OperActivityNtfSocialCmd = {
    id = 560010,
    req = "Cmd.OperActivityNtfSocialCmd",
    ack = "Cmd.OperActivityNtfSocialCmd",
    from = "SessionSociality"
  },
  AddRelation = {
    id = 560011,
    req = "Cmd.AddRelation",
    ack = "Cmd.AddRelation",
    from = "SessionSociality"
  },
  RemoveRelation = {
    id = 560012,
    req = "Cmd.RemoveRelation",
    ack = "Cmd.RemoveRelation",
    from = "SessionSociality"
  },
  QueryRecallListSocialCmd = {
    id = 560013,
    req = "Cmd.QueryRecallListSocialCmd",
    ack = "Cmd.QueryRecallListSocialCmd",
    from = "SessionSociality"
  },
  RecallFriendSocialCmd = {
    id = 560014,
    req = "Cmd.RecallFriendSocialCmd",
    ack = "Cmd.RecallFriendSocialCmd",
    from = "SessionSociality"
  },
  AddRelationResultSocialCmd = {
    id = 560015,
    req = "Cmd.AddRelationResultSocialCmd",
    ack = "Cmd.AddRelationResultSocialCmd",
    from = "SessionSociality"
  },
  QueryChargeVirginCmd = {
    id = 560016,
    req = "Cmd.QueryChargeVirginCmd",
    ack = "Cmd.QueryChargeVirginCmd",
    from = "SessionSociality"
  },
  QueryUserInfoCmd = {
    id = 560017,
    req = "Cmd.QueryUserInfoCmd",
    ack = "Cmd.QueryUserInfoCmd",
    from = "SessionSociality"
  },
  TutorFuncStateNtfSocialCmd = {
    id = 560018,
    req = "Cmd.TutorFuncStateNtfSocialCmd",
    ack = "Cmd.TutorFuncStateNtfSocialCmd",
    from = "SessionSociality"
  },
  TeamList = {
    id = 510001,
    req = "Cmd.TeamList",
    ack = "Cmd.TeamList",
    from = "SessionTeam"
  },
  TeamDataUpdate = {
    id = 510002,
    req = "Cmd.TeamDataUpdate",
    ack = "Cmd.TeamDataUpdate",
    from = "SessionTeam"
  },
  TeamMemberUpdate = {
    id = 510003,
    req = "Cmd.TeamMemberUpdate",
    ack = "Cmd.TeamMemberUpdate",
    from = "SessionTeam"
  },
  TeamApplyUpdate = {
    id = 510004,
    req = "Cmd.TeamApplyUpdate",
    ack = "Cmd.TeamApplyUpdate",
    from = "SessionTeam"
  },
  CreateTeam = {
    id = 510005,
    req = "Cmd.CreateTeam",
    ack = "Cmd.CreateTeam",
    from = "SessionTeam"
  },
  InviteMember = {
    id = 510006,
    req = "Cmd.InviteMember",
    ack = "Cmd.InviteMember",
    from = "SessionTeam"
  },
  ProcessTeamInvite = {
    id = 510007,
    req = "Cmd.ProcessTeamInvite",
    ack = "Cmd.ProcessTeamInvite",
    from = "SessionTeam"
  },
  TeamMemberApply = {
    id = 510008,
    req = "Cmd.TeamMemberApply",
    ack = "Cmd.TeamMemberApply",
    from = "SessionTeam"
  },
  ProcessTeamApply = {
    id = 510009,
    req = "Cmd.ProcessTeamApply",
    ack = "Cmd.ProcessTeamApply",
    from = "SessionTeam"
  },
  KickMember = {
    id = 510010,
    req = "Cmd.KickMember",
    ack = "Cmd.KickMember",
    from = "SessionTeam"
  },
  ExchangeLeader = {
    id = 510011,
    req = "Cmd.ExchangeLeader",
    ack = "Cmd.ExchangeLeader",
    from = "SessionTeam"
  },
  ExitTeam = {
    id = 510012,
    req = "Cmd.ExitTeam",
    ack = "Cmd.ExitTeam",
    from = "SessionTeam"
  },
  EnterTeam = {
    id = 510013,
    req = "Cmd.EnterTeam",
    ack = "Cmd.EnterTeam",
    from = "SessionTeam"
  },
  MemberPosUpdate = {
    id = 510014,
    req = "Cmd.MemberPosUpdate",
    ack = "Cmd.MemberPosUpdate",
    from = "SessionTeam"
  },
  MemberDataUpdate = {
    id = 510015,
    req = "Cmd.MemberDataUpdate",
    ack = "Cmd.MemberDataUpdate",
    from = "SessionTeam"
  },
  LockTarget = {
    id = 510016,
    req = "Cmd.LockTarget",
    ack = "Cmd.LockTarget",
    from = "SessionTeam"
  },
  TeamSummon = {
    id = 510017,
    req = "Cmd.TeamSummon",
    ack = "Cmd.TeamSummon",
    from = "SessionTeam"
  },
  ClearApplyList = {
    id = 510018,
    req = "Cmd.ClearApplyList",
    ack = "Cmd.ClearApplyList",
    from = "SessionTeam"
  },
  QuickEnter = {
    id = 510019,
    req = "Cmd.QuickEnter",
    ack = "Cmd.QuickEnter",
    from = "SessionTeam"
  },
  SetTeamOption = {
    id = 510020,
    req = "Cmd.SetTeamOption",
    ack = "Cmd.SetTeamOption",
    from = "SessionTeam"
  },
  QueryUserTeamInfoTeamCmd = {
    id = 510021,
    req = "Cmd.QueryUserTeamInfoTeamCmd",
    ack = "Cmd.QueryUserTeamInfoTeamCmd",
    from = "SessionTeam"
  },
  SetMemberOptionTeamCmd = {
    id = 510022,
    req = "Cmd.SetMemberOptionTeamCmd",
    ack = "Cmd.SetMemberOptionTeamCmd",
    from = "SessionTeam"
  },
  QuestWantedQuestTeamCmd = {
    id = 510023,
    req = "Cmd.QuestWantedQuestTeamCmd",
    ack = "Cmd.QuestWantedQuestTeamCmd",
    from = "SessionTeam"
  },
  UpdateWantedQuestTeamCmd = {
    id = 510024,
    req = "Cmd.UpdateWantedQuestTeamCmd",
    ack = "Cmd.UpdateWantedQuestTeamCmd",
    from = "SessionTeam"
  },
  AcceptHelpWantedTeamCmd = {
    id = 510025,
    req = "Cmd.AcceptHelpWantedTeamCmd",
    ack = "Cmd.AcceptHelpWantedTeamCmd",
    from = "SessionTeam"
  },
  UpdateHelpWantedTeamCmd = {
    id = 510026,
    req = "Cmd.UpdateHelpWantedTeamCmd",
    ack = "Cmd.UpdateHelpWantedTeamCmd",
    from = "SessionTeam"
  },
  QueryHelpWantedTeamCmd = {
    id = 510027,
    req = "Cmd.QueryHelpWantedTeamCmd",
    ack = "Cmd.QueryHelpWantedTeamCmd",
    from = "SessionTeam"
  },
  QueryMemberCatTeamCmd = {
    id = 510028,
    req = "Cmd.QueryMemberCatTeamCmd",
    ack = "Cmd.QueryMemberCatTeamCmd",
    from = "SessionTeam"
  },
  MemberCatUpdateTeam = {
    id = 510029,
    req = "Cmd.MemberCatUpdateTeam",
    ack = "Cmd.MemberCatUpdateTeam",
    from = "SessionTeam"
  },
  CancelApplyTeamCmd = {
    id = 510031,
    req = "Cmd.CancelApplyTeamCmd",
    ack = "Cmd.CancelApplyTeamCmd",
    from = "SessionTeam"
  },
  QueryMemberTeamCmd = {
    id = 510032,
    req = "Cmd.QueryMemberTeamCmd",
    ack = "Cmd.QueryMemberTeamCmd",
    from = "SessionTeam"
  },
  UserApplyUpdateTeamCmd = {
    id = 510033,
    req = "Cmd.UserApplyUpdateTeamCmd",
    ack = "Cmd.UserApplyUpdateTeamCmd",
    from = "SessionTeam"
  },
  InviteGroupTeamCmd = {
    id = 510034,
    req = "Cmd.InviteGroupTeamCmd",
    ack = "Cmd.InviteGroupTeamCmd",
    from = "SessionTeam"
  },
  ProcessInviteGroupTeamCmd = {
    id = 510035,
    req = "Cmd.ProcessInviteGroupTeamCmd",
    ack = "Cmd.ProcessInviteGroupTeamCmd",
    from = "SessionTeam"
  },
  DissolveGroupTeamCmd = {
    id = 510036,
    req = "Cmd.DissolveGroupTeamCmd",
    ack = "Cmd.DissolveGroupTeamCmd",
    from = "SessionTeam"
  },
  ChangeGroupLeaderTeamCmd = {
    id = 510037,
    req = "Cmd.ChangeGroupLeaderTeamCmd",
    ack = "Cmd.ChangeGroupLeaderTeamCmd",
    from = "SessionTeam"
  },
  GroupUpdateNtfTeamCmd = {
    id = 510038,
    req = "Cmd.GroupUpdateNtfTeamCmd",
    ack = "Cmd.GroupUpdateNtfTeamCmd",
    from = "SessionTeam"
  },
  QueryGroupTeamApplyListTeamCmd = {
    id = 510039,
    req = "Cmd.QueryGroupTeamApplyListTeamCmd",
    ack = "Cmd.QueryGroupTeamApplyListTeamCmd",
    from = "SessionTeam"
  },
  TeamGroupApplyUpdate = {
    id = 510040,
    req = "Cmd.TeamGroupApplyUpdate",
    ack = "Cmd.TeamGroupApplyUpdate",
    from = "SessionTeam"
  },
  TeamGroupApplyTeamCmd = {
    id = 510041,
    req = "Cmd.TeamGroupApplyTeamCmd",
    ack = "Cmd.TeamGroupApplyTeamCmd",
    from = "SessionTeam"
  },
  ProcessGroupApplyTeamCmd = {
    id = 510042,
    req = "Cmd.ProcessGroupApplyTeamCmd",
    ack = "Cmd.ProcessGroupApplyTeamCmd",
    from = "SessionTeam"
  },
  MyGroupApplyUpdateTeamCmd = {
    id = 510043,
    req = "Cmd.MyGroupApplyUpdateTeamCmd",
    ack = "Cmd.MyGroupApplyUpdateTeamCmd",
    from = "SessionTeam"
  },
  LaunckKickTeamCmd = {
    id = 510044,
    req = "Cmd.LaunckKickTeamCmd",
    ack = "Cmd.LaunckKickTeamCmd",
    from = "SessionTeam"
  },
  ReplyKickTeamCmd = {
    id = 510045,
    req = "Cmd.ReplyKickTeamCmd",
    ack = "Cmd.ReplyKickTeamCmd",
    from = "SessionTeam"
  },
  GMEMuteTeamCmd = {
    id = 510051,
    req = "Cmd.GMEMuteTeamCmd",
    ack = "Cmd.GMEMuteTeamCmd",
    from = "SessionTeam"
  },
  ReqRecruitPublishTeamCmd = {
    id = 510046,
    req = "Cmd.ReqRecruitPublishTeamCmd",
    ack = "Cmd.ReqRecruitPublishTeamCmd",
    from = "SessionTeam"
  },
  NewRecruitPublishTeamCmd = {
    id = 510047,
    req = "Cmd.NewRecruitPublishTeamCmd",
    ack = "Cmd.NewRecruitPublishTeamCmd",
    from = "SessionTeam"
  },
  ReqRecruitTeamInfoTeamCmd = {
    id = 510048,
    req = "Cmd.ReqRecruitTeamInfoTeamCmd",
    ack = "Cmd.ReqRecruitTeamInfoTeamCmd",
    from = "SessionTeam"
  },
  UpdateRecruitTeamInfoTeamCmd = {
    id = 510049,
    req = "Cmd.UpdateRecruitTeamInfoTeamCmd",
    ack = "Cmd.UpdateRecruitTeamInfoTeamCmd",
    from = "SessionTeam"
  },
  ChangeGroupMemberTeamCmd = {
    id = 510050,
    req = "Cmd.ChangeGroupMemberTeamCmd",
    ack = "Cmd.ChangeGroupMemberTeamCmd",
    from = "SessionTeam"
  },
  PublishReqHelpTeamCmd = {
    id = 510052,
    req = "Cmd.PublishReqHelpTeamCmd",
    ack = "Cmd.PublishReqHelpTeamCmd",
    from = "SessionTeam"
  },
  AskForTeamInfoTeamCmd = {
    id = 510053,
    req = "Cmd.AskForTeamInfoTeamCmd",
    ack = "Cmd.AskForTeamInfoTeamCmd",
    from = "SessionTeam"
  },
  WeatherChange = {
    id = 530001,
    req = "Cmd.WeatherChange",
    ack = "Cmd.WeatherChange",
    from = "SessionWeather"
  },
  SkyChange = {
    id = 530002,
    req = "Cmd.SkyChange",
    ack = "Cmd.SkyChange",
    from = "SessionWeather"
  },
  InviteGroupJoinRaidTeamCmd = {
    id = 690001,
    req = "Cmd.InviteGroupJoinRaidTeamCmd",
    ack = "Cmd.InviteGroupJoinRaidTeamCmd",
    from = "TeamGroupRaid"
  },
  ReplyGroupJoinRaidTeamCmd = {
    id = 690002,
    req = "Cmd.ReplyGroupJoinRaidTeamCmd",
    ack = "Cmd.ReplyGroupJoinRaidTeamCmd",
    from = "TeamGroupRaid"
  },
  OpenGroupRaidTeamCmd = {
    id = 690003,
    req = "Cmd.OpenGroupRaidTeamCmd",
    ack = "Cmd.OpenGroupRaidTeamCmd",
    from = "TeamGroupRaid"
  },
  JoinGroupRaidTeamCmd = {
    id = 690004,
    req = "Cmd.JoinGroupRaidTeamCmd",
    ack = "Cmd.JoinGroupRaidTeamCmd",
    from = "TeamGroupRaid"
  },
  QueryGroupRaidStatusCmd = {
    id = 690005,
    req = "Cmd.QueryGroupRaidStatusCmd",
    ack = "Cmd.QueryGroupRaidStatusCmd",
    from = "TeamGroupRaid"
  },
  CreateGroupRaidTeamCmd = {
    id = 690020,
    req = "Cmd.CreateGroupRaidTeamCmd",
    ack = "Cmd.CreateGroupRaidTeamCmd",
    from = "TeamGroupRaid"
  },
  GoToGroupRaidTeamCmd = {
    id = 690021,
    req = "Cmd.GoToGroupRaidTeamCmd",
    ack = "Cmd.GoToGroupRaidTeamCmd",
    from = "TeamGroupRaid"
  },
  EnterNextRaidGroupCmd = {
    id = 690006,
    req = "Cmd.EnterNextRaidGroupCmd",
    ack = "Cmd.EnterNextRaidGroupCmd",
    from = "TeamGroupRaid"
  },
  InviteConfirmRaidTeamGroupCmd = {
    id = 690007,
    req = "Cmd.InviteConfirmRaidTeamGroupCmd",
    ack = "Cmd.InviteConfirmRaidTeamGroupCmd",
    from = "TeamGroupRaid"
  },
  ReplyConfirmRaidTeamGroupCmd = {
    id = 690008,
    req = "Cmd.ReplyConfirmRaidTeamGroupCmd",
    ack = "Cmd.ReplyConfirmRaidTeamGroupCmd",
    from = "TeamGroupRaid"
  },
  QueryGroupRaidKillUserInfo = {
    id = 690009,
    req = "Cmd.QueryGroupRaidKillUserInfo",
    ack = "Cmd.QueryGroupRaidKillUserInfo",
    from = "TeamGroupRaid"
  },
  QueryGroupRaidKillGuildInfo = {
    id = 690010,
    req = "Cmd.QueryGroupRaidKillGuildInfo",
    ack = "Cmd.QueryGroupRaidKillGuildInfo",
    from = "TeamGroupRaid"
  },
  QueryGroupRaidKillUserShowData = {
    id = 690011,
    req = "Cmd.QueryGroupRaidKillUserShowData",
    ack = "Cmd.QueryGroupRaidKillUserShowData",
    from = "TeamGroupRaid"
  },
  TeamRaidInviteCmd = {
    id = 670001,
    req = "Cmd.TeamRaidInviteCmd",
    ack = "Cmd.TeamRaidInviteCmd",
    from = "TeamRaidCmd"
  },
  TeamRaidReplyCmd = {
    id = 670002,
    req = "Cmd.TeamRaidReplyCmd",
    ack = "Cmd.TeamRaidReplyCmd",
    from = "TeamRaidCmd"
  },
  TeamRaidEnterCmd = {
    id = 670003,
    req = "Cmd.TeamRaidEnterCmd",
    ack = "Cmd.TeamRaidEnterCmd",
    from = "TeamRaidCmd"
  },
  TeamRaidAltmanShowCmd = {
    id = 670004,
    req = "Cmd.TeamRaidAltmanShowCmd",
    ack = "Cmd.TeamRaidAltmanShowCmd",
    from = "TeamRaidCmd"
  },
  TeamRaidImageCreateCmd = {
    id = 670006,
    req = "Cmd.TeamRaidImageCreateCmd",
    ack = "Cmd.TeamRaidImageCreateCmd",
    from = "TeamRaidCmd"
  },
  TeamPvpInviteMatchCmd = {
    id = 670007,
    req = "Cmd.TeamPvpInviteMatchCmd",
    ack = "Cmd.TeamPvpInviteMatchCmd",
    from = "TeamRaidCmd"
  },
  TeamPvpReplyMatchCmd = {
    id = 670008,
    req = "Cmd.TeamPvpReplyMatchCmd",
    ack = "Cmd.TeamPvpReplyMatchCmd",
    from = "TeamRaidCmd"
  },
  ComodoTeamRaidCreateCmd = {
    id = 670009,
    req = "Cmd.ComodoTeamRaidCreateCmd",
    ack = "Cmd.ComodoTeamRaidCreateCmd",
    from = "TeamRaidCmd"
  },
  GuildTeamRaidCreateCmd = {
    id = 670011,
    req = "Cmd.GuildTeamRaidCreateCmd",
    ack = "Cmd.GuildTeamRaidCreateCmd",
    from = "TeamRaidCmd"
  },
  TechTreeUnlockLeafCmd = {
    id = 730001,
    req = "Cmd.TechTreeUnlockLeafCmd",
    ack = "Cmd.TechTreeUnlockLeafCmd",
    from = "TechTreeCmd"
  },
  TechTreeSyncLeafCmd = {
    id = 730002,
    req = "Cmd.TechTreeSyncLeafCmd",
    ack = "Cmd.TechTreeSyncLeafCmd",
    from = "TechTreeCmd"
  },
  AddToyDrawingCmd = {
    id = 730003,
    req = "Cmd.AddToyDrawingCmd",
    ack = "Cmd.AddToyDrawingCmd",
    from = "TechTreeCmd"
  },
  SyncToyDrawingCmd = {
    id = 730004,
    req = "Cmd.SyncToyDrawingCmd",
    ack = "Cmd.SyncToyDrawingCmd",
    from = "TechTreeCmd"
  },
  TechTreeMakeToyCmd = {
    id = 730005,
    req = "Cmd.TechTreeMakeToyCmd",
    ack = "Cmd.TechTreeMakeToyCmd",
    from = "TechTreeCmd"
  },
  ToyTransSetPosCmd = {
    id = 730006,
    req = "Cmd.ToyTransSetPosCmd",
    ack = "Cmd.ToyTransSetPosCmd",
    from = "TechTreeCmd"
  },
  TechTreeLevelAwardCmd = {
    id = 730007,
    req = "Cmd.TechTreeLevelAwardCmd",
    ack = "Cmd.TechTreeLevelAwardCmd",
    from = "TechTreeCmd"
  },
  TechTreeProduceCollectCmd = {
    id = 730008,
    req = "Cmd.TechTreeProduceCollectCmd",
    ack = "Cmd.TechTreeProduceCollectCmd",
    from = "TechTreeCmd"
  },
  TechTreeProdecInfoCmd = {
    id = 730009,
    req = "Cmd.TechTreeProdecInfoCmd",
    ack = "Cmd.TechTreeProdecInfoCmd",
    from = "TechTreeCmd"
  },
  TechTreeInjectCmd = {
    id = 730010,
    req = "Cmd.TechTreeInjectCmd",
    ack = "Cmd.TechTreeInjectCmd",
    from = "TechTreeCmd"
  },
  TechTreeInjectInfoCmd = {
    id = 730011,
    req = "Cmd.TechTreeInjectInfoCmd",
    ack = "Cmd.TechTreeInjectInfoCmd",
    from = "TechTreeCmd"
  },
  TutorTaskUpdateNtf = {
    id = 310001,
    req = "Cmd.TutorTaskUpdateNtf",
    ack = "Cmd.TutorTaskUpdateNtf",
    from = "Tutor"
  },
  TutorTaskQueryCmd = {
    id = 310002,
    req = "Cmd.TutorTaskQueryCmd",
    ack = "Cmd.TutorTaskQueryCmd",
    from = "Tutor"
  },
  TutorTaskTeacherRewardCmd = {
    id = 310003,
    req = "Cmd.TutorTaskTeacherRewardCmd",
    ack = "Cmd.TutorTaskTeacherRewardCmd",
    from = "Tutor"
  },
  TutorGrowRewardUpdateNtf = {
    id = 310004,
    req = "Cmd.TutorGrowRewardUpdateNtf",
    ack = "Cmd.TutorGrowRewardUpdateNtf",
    from = "Tutor"
  },
  TutorGetGrowRewardCmd = {
    id = 310005,
    req = "Cmd.TutorGetGrowRewardCmd",
    ack = "Cmd.TutorGetGrowRewardCmd",
    from = "Tutor"
  },
  TutorTaskUpdateBoxCmd = {
    id = 310006,
    req = "Cmd.TutorTaskUpdateBoxCmd",
    ack = "Cmd.TutorTaskUpdateBoxCmd",
    from = "Tutor"
  },
  ReqAfkUserAfkCmd = {
    id = 740001,
    req = "Cmd.ReqAfkUserAfkCmd",
    ack = "Cmd.ReqAfkUserAfkCmd",
    from = "UserAfkCmd"
  },
  RetAfkUserAfkCmd = {
    id = 740002,
    req = "Cmd.RetAfkUserAfkCmd",
    ack = "Cmd.RetAfkUserAfkCmd",
    from = "UserAfkCmd"
  },
  SyncStatInfoAfkCmd = {
    id = 740003,
    req = "Cmd.SyncStatInfoAfkCmd",
    ack = "Cmd.SyncStatInfoAfkCmd",
    from = "UserAfkCmd"
  },
  FirstActionUserEvent = {
    id = 250001,
    req = "Cmd.FirstActionUserEvent",
    ack = "Cmd.FirstActionUserEvent",
    from = "UserEvent"
  },
  DamageNpcUserEvent = {
    id = 250002,
    req = "Cmd.DamageNpcUserEvent",
    ack = "Cmd.DamageNpcUserEvent",
    from = "UserEvent"
  },
  NewTitle = {
    id = 250003,
    req = "Cmd.NewTitle",
    ack = "Cmd.NewTitle",
    from = "UserEvent"
  },
  AllTitle = {
    id = 250004,
    req = "Cmd.AllTitle",
    ack = "Cmd.AllTitle",
    from = "UserEvent"
  },
  UpdateRandomUserEvent = {
    id = 250005,
    req = "Cmd.UpdateRandomUserEvent",
    ack = "Cmd.UpdateRandomUserEvent",
    from = "UserEvent"
  },
  BuffDamageUserEvent = {
    id = 250006,
    req = "Cmd.BuffDamageUserEvent",
    ack = "Cmd.BuffDamageUserEvent",
    from = "UserEvent"
  },
  ChargeNtfUserEvent = {
    id = 250007,
    req = "Cmd.ChargeNtfUserEvent",
    ack = "Cmd.ChargeNtfUserEvent",
    from = "UserEvent"
  },
  ChargeQueryCmd = {
    id = 250008,
    req = "Cmd.ChargeQueryCmd",
    ack = "Cmd.ChargeQueryCmd",
    from = "UserEvent"
  },
  DepositCardInfo = {
    id = 250009,
    req = "Cmd.DepositCardInfo",
    ack = "Cmd.DepositCardInfo",
    from = "UserEvent"
  },
  DelTransformUserEvent = {
    id = 250010,
    req = "Cmd.DelTransformUserEvent",
    ack = "Cmd.DelTransformUserEvent",
    from = "UserEvent"
  },
  InviteCatFailUserEvent = {
    id = 250011,
    req = "Cmd.InviteCatFailUserEvent",
    ack = "Cmd.InviteCatFailUserEvent",
    from = "UserEvent"
  },
  TrigNpcFuncUserEvent = {
    id = 250012,
    req = "Cmd.TrigNpcFuncUserEvent",
    ack = "Cmd.TrigNpcFuncUserEvent",
    from = "UserEvent"
  },
  SystemStringUserEvent = {
    id = 250013,
    req = "Cmd.SystemStringUserEvent",
    ack = "Cmd.SystemStringUserEvent",
    from = "UserEvent"
  },
  HandCatUserEvent = {
    id = 250014,
    req = "Cmd.HandCatUserEvent",
    ack = "Cmd.HandCatUserEvent",
    from = "UserEvent"
  },
  ChangeTitle = {
    id = 250015,
    req = "Cmd.ChangeTitle",
    ack = "Cmd.ChangeTitle",
    from = "UserEvent"
  },
  QueryChargeCnt = {
    id = 250016,
    req = "Cmd.QueryChargeCnt",
    ack = "Cmd.QueryChargeCnt",
    from = "UserEvent"
  },
  NTFMonthCardEnd = {
    id = 250017,
    req = "Cmd.NTFMonthCardEnd",
    ack = "Cmd.NTFMonthCardEnd",
    from = "UserEvent"
  },
  LoveLetterUse = {
    id = 250018,
    req = "Cmd.LoveLetterUse",
    ack = "Cmd.LoveLetterUse",
    from = "UserEvent"
  },
  QueryActivityCnt = {
    id = 250019,
    req = "Cmd.QueryActivityCnt",
    ack = "Cmd.QueryActivityCnt",
    from = "UserEvent"
  },
  UpdateActivityCnt = {
    id = 250020,
    req = "Cmd.UpdateActivityCnt",
    ack = "Cmd.UpdateActivityCnt",
    from = "UserEvent"
  },
  NtfVersionCardInfo = {
    id = 250023,
    req = "Cmd.NtfVersionCardInfo",
    ack = "Cmd.NtfVersionCardInfo",
    from = "UserEvent"
  },
  DieTimeCountEventCmd = {
    id = 250024,
    req = "Cmd.DieTimeCountEventCmd",
    ack = "Cmd.DieTimeCountEventCmd",
    from = "UserEvent"
  },
  GetFirstShareRewardUserEvent = {
    id = 250022,
    req = "Cmd.GetFirstShareRewardUserEvent",
    ack = "Cmd.GetFirstShareRewardUserEvent",
    from = "UserEvent"
  },
  QueryResetTimeEventCmd = {
    id = 250025,
    req = "Cmd.QueryResetTimeEventCmd",
    ack = "Cmd.QueryResetTimeEventCmd",
    from = "UserEvent"
  },
  InOutActEventCmd = {
    id = 250026,
    req = "Cmd.InOutActEventCmd",
    ack = "Cmd.InOutActEventCmd",
    from = "UserEvent"
  },
  UserEventMailCmd = {
    id = 250027,
    req = "Cmd.UserEventMailCmd",
    ack = "Cmd.UserEventMailCmd",
    from = "UserEvent"
  },
  LevelupDeadUserEvent = {
    id = 250028,
    req = "Cmd.LevelupDeadUserEvent",
    ack = "Cmd.LevelupDeadUserEvent",
    from = "UserEvent"
  },
  SwitchAutoBattleUserEvent = {
    id = 250029,
    req = "Cmd.SwitchAutoBattleUserEvent",
    ack = "Cmd.SwitchAutoBattleUserEvent",
    from = "UserEvent"
  },
  GoActivityMapUserEvent = {
    id = 250030,
    req = "Cmd.GoActivityMapUserEvent",
    ack = "Cmd.GoActivityMapUserEvent",
    from = "UserEvent"
  },
  ActivityPointUserEvent = {
    id = 250031,
    req = "Cmd.ActivityPointUserEvent",
    ack = "Cmd.ActivityPointUserEvent",
    from = "UserEvent"
  },
  QueryFavoriteFriendUserEvent = {
    id = 250033,
    req = "Cmd.QueryFavoriteFriendUserEvent",
    ack = "Cmd.QueryFavoriteFriendUserEvent",
    from = "UserEvent"
  },
  UpdateFavoriteFriendUserEvent = {
    id = 250034,
    req = "Cmd.UpdateFavoriteFriendUserEvent",
    ack = "Cmd.UpdateFavoriteFriendUserEvent",
    from = "UserEvent"
  },
  ActionFavoriteFriendUserEvent = {
    id = 250035,
    req = "Cmd.ActionFavoriteFriendUserEvent",
    ack = "Cmd.ActionFavoriteFriendUserEvent",
    from = "UserEvent"
  },
  SoundStoryUserEvent = {
    id = 250036,
    req = "Cmd.SoundStoryUserEvent",
    ack = "Cmd.SoundStoryUserEvent",
    from = "UserEvent"
  },
  ThemeDetailsUserEvent = {
    id = 250032,
    req = "Cmd.ThemeDetailsUserEvent",
    ack = "Cmd.ThemeDetailsUserEvent",
    from = "UserEvent"
  },
  CameraActionUserEvent = {
    id = 250040,
    req = "Cmd.CameraActionUserEvent",
    ack = "Cmd.CameraActionUserEvent",
    from = "UserEvent"
  },
  BifrostContributeItemUserEvent = {
    id = 250039,
    req = "Cmd.BifrostContributeItemUserEvent",
    ack = "Cmd.BifrostContributeItemUserEvent",
    from = "UserEvent"
  },
  RobotOffBattleUserEvent = {
    id = 250041,
    req = "Cmd.RobotOffBattleUserEvent",
    ack = "Cmd.RobotOffBattleUserEvent",
    from = "UserEvent"
  },
  QueryAccChargeCntReward = {
    id = 250037,
    req = "Cmd.QueryAccChargeCntReward",
    ack = "Cmd.QueryAccChargeCntReward",
    from = "UserEvent"
  },
  ChargeSdkRequestUserEvent = {
    id = 250042,
    req = "Cmd.ChargeSdkRequestUserEvent",
    ack = "Cmd.ChargeSdkRequestUserEvent",
    from = "UserEvent"
  },
  ChargeSdkReplyUserEvent = {
    id = 250043,
    req = "Cmd.ChargeSdkReplyUserEvent",
    ack = "Cmd.ChargeSdkReplyUserEvent",
    from = "UserEvent"
  },
  ClientAISyncUserEvent = {
    id = 250044,
    req = "Cmd.ClientAISyncUserEvent",
    ack = "Cmd.ClientAISyncUserEvent",
    from = "UserEvent"
  },
  ClientAIUpdateUserEvent = {
    id = 250045,
    req = "Cmd.ClientAIUpdateUserEvent",
    ack = "Cmd.ClientAIUpdateUserEvent",
    from = "UserEvent"
  },
  GiftCodeExchangeEvent = {
    id = 250046,
    req = "Cmd.GiftCodeExchangeEvent",
    ack = "Cmd.GiftCodeExchangeEvent",
    from = "UserEvent"
  },
  SetHideOtherCmd = {
    id = 250047,
    req = "Cmd.SetHideOtherCmd",
    ack = "Cmd.SetHideOtherCmd",
    from = "UserEvent"
  },
  GiftTimeLimitNtfUserEvent = {
    id = 250048,
    req = "Cmd.GiftTimeLimitNtfUserEvent",
    ack = "Cmd.GiftTimeLimitNtfUserEvent",
    from = "UserEvent"
  },
  GiftTimeLimitBuyUserEvent = {
    id = 250049,
    req = "Cmd.GiftTimeLimitBuyUserEvent",
    ack = "Cmd.GiftTimeLimitBuyUserEvent",
    from = "UserEvent"
  },
  GiftTimeLimitActiveUserEvent = {
    id = 250050,
    req = "Cmd.GiftTimeLimitActiveUserEvent",
    ack = "Cmd.GiftTimeLimitActiveUserEvent",
    from = "UserEvent"
  },
  MultiCutSceneUpdateUserEvent = {
    id = 250055,
    req = "Cmd.MultiCutSceneUpdateUserEvent",
    ack = "Cmd.MultiCutSceneUpdateUserEvent",
    from = "UserEvent"
  },
  PolicyUpdateUserEvent = {
    id = 250056,
    req = "Cmd.PolicyUpdateUserEvent",
    ack = "Cmd.PolicyUpdateUserEvent",
    from = "UserEvent"
  },
  PolicyAgreeUserEvent = {
    id = 250057,
    req = "Cmd.PolicyAgreeUserEvent",
    ack = "Cmd.PolicyAgreeUserEvent",
    from = "UserEvent"
  },
  ShowSceneObject = {
    id = 250058,
    req = "Cmd.ShowSceneObject",
    ack = "Cmd.ShowSceneObject",
    from = "UserEvent"
  },
  DoubleAcionEvent = {
    id = 250059,
    req = "Cmd.DoubleAcionEvent",
    ack = "Cmd.DoubleAcionEvent",
    from = "UserEvent"
  },
  BeginMonitorUserEvent = {
    id = 250060,
    req = "Cmd.BeginMonitorUserEvent",
    ack = "Cmd.BeginMonitorUserEvent",
    from = "UserEvent"
  },
  StopMonitorUserEvent = {
    id = 250061,
    req = "Cmd.StopMonitorUserEvent",
    ack = "Cmd.StopMonitorUserEvent",
    from = "UserEvent"
  },
  StopMonitorRetUserEvent = {
    id = 250065,
    req = "Cmd.StopMonitorRetUserEvent",
    ack = "Cmd.StopMonitorRetUserEvent",
    from = "UserEvent"
  },
  MonitorGoToMapUserEvent = {
    id = 250062,
    req = "Cmd.MonitorGoToMapUserEvent",
    ack = "Cmd.MonitorGoToMapUserEvent",
    from = "UserEvent"
  },
  MonitorMapEndUserEvent = {
    id = 250063,
    req = "Cmd.MonitorMapEndUserEvent",
    ack = "Cmd.MonitorMapEndUserEvent",
    from = "UserEvent"
  },
  MonitorBuildUserEvent = {
    id = 250064,
    req = "Cmd.MonitorBuildUserEvent",
    ack = "Cmd.MonitorBuildUserEvent",
    from = "UserEvent"
  },
  GuideQuestEvent = {
    id = 250073,
    req = "Cmd.GuideQuestEvent",
    ack = "Cmd.GuideQuestEvent",
    from = "UserEvent"
  },
  ShowCardEvent = {
    id = 250075,
    req = "Cmd.ShowCardEvent",
    ack = "Cmd.ShowCardEvent",
    from = "UserEvent"
  },
  GvgOptStatueEvent = {
    id = 250071,
    req = "Cmd.GvgOptStatueEvent",
    ack = "Cmd.GvgOptStatueEvent",
    from = "UserEvent"
  },
  TimeLimitIconEvent = {
    id = 250072,
    req = "Cmd.TimeLimitIconEvent",
    ack = "Cmd.TimeLimitIconEvent",
    from = "UserEvent"
  },
  ShowRMBGiftEvent = {
    id = 250076,
    req = "Cmd.ShowRMBGiftEvent",
    ack = "Cmd.ShowRMBGiftEvent",
    from = "UserEvent"
  },
  ConfigActionUserEvent = {
    id = 250066,
    req = "Cmd.ConfigActionUserEvent",
    ack = "Cmd.ConfigActionUserEvent",
    from = "UserEvent"
  },
  NpcWalkStepNtfUserEvent = {
    id = 250067,
    req = "Cmd.NpcWalkStepNtfUserEvent",
    ack = "Cmd.NpcWalkStepNtfUserEvent",
    from = "UserEvent"
  },
  SetProfileUserEvent = {
    id = 250068,
    req = "Cmd.SetProfileUserEvent",
    ack = "Cmd.SetProfileUserEvent",
    from = "UserEvent"
  },
  QueryFateRelationEvent = {
    id = 250070,
    req = "Cmd.QueryFateRelationEvent",
    ack = "Cmd.QueryFateRelationEvent",
    from = "UserEvent"
  },
  SyncFateRelationEvent = {
    id = 250069,
    req = "Cmd.SyncFateRelationEvent",
    ack = "Cmd.SyncFateRelationEvent",
    from = "UserEvent"
  },
  QueryProfileUserEvent = {
    id = 250077,
    req = "Cmd.QueryProfileUserEvent",
    ack = "Cmd.QueryProfileUserEvent",
    from = "UserEvent"
  },
  GvgSandTableEvent = {
    id = 250078,
    req = "Cmd.GvgSandTableEvent",
    ack = "Cmd.GvgSandTableEvent",
    from = "UserEvent"
  },
  SetReliveMethodUserEvent = {
    id = 250079,
    req = "Cmd.SetReliveMethodUserEvent",
    ack = "Cmd.SetReliveMethodUserEvent",
    from = "UserEvent"
  },
  UIActionUserEvent = {
    id = 250080,
    req = "Cmd.UIActionUserEvent",
    ack = "Cmd.UIActionUserEvent",
    from = "UserEvent"
  },
  PlayCutSceneUserEvent = {
    id = 250082,
    req = "Cmd.PlayCutSceneUserEvent",
    ack = "Cmd.PlayCutSceneUserEvent",
    from = "UserEvent"
  },
  ReqPeriodicMonsterUserEvent = {
    id = 250084,
    req = "Cmd.ReqPeriodicMonsterUserEvent",
    ack = "Cmd.ReqPeriodicMonsterUserEvent",
    from = "UserEvent"
  },
  PlayHoldPetUserEvent = {
    id = 250085,
    req = "Cmd.PlayHoldPetUserEvent",
    ack = "Cmd.PlayHoldPetUserEvent",
    from = "UserEvent"
  },
  QuerySpeedUpUserEvent = {
    id = 250081,
    req = "Cmd.QuerySpeedUpUserEvent",
    ack = "Cmd.QuerySpeedUpUserEvent",
    from = "UserEvent"
  },
  ServerOpenTimeUserEvent = {
    id = 250083,
    req = "Cmd.ServerOpenTimeUserEvent",
    ack = "Cmd.ServerOpenTimeUserEvent",
    from = "UserEvent"
  },
  SkillDamageStatUserEvent = {
    id = 250086,
    req = "Cmd.SkillDamageStatUserEvent",
    ack = "Cmd.SkillDamageStatUserEvent",
    from = "UserEvent"
  },
  HeartBeatReqUserEvent = {
    id = 250087,
    req = "Cmd.HeartBeatReqUserEvent",
    ack = "Cmd.HeartBeatReqUserEvent",
    from = "UserEvent"
  },
  HeartBeatAckUserEvent = {
    id = 250088,
    req = "Cmd.HeartBeatAckUserEvent",
    ack = "Cmd.HeartBeatAckUserEvent",
    from = "UserEvent"
  },
  QueryUserReportListUserEvent = {
    id = 250089,
    req = "Cmd.QueryUserReportListUserEvent",
    ack = "Cmd.QueryUserReportListUserEvent",
    from = "UserEvent"
  },
  UserReportUserEvent = {
    id = 250090,
    req = "Cmd.UserReportUserEvent",
    ack = "Cmd.UserReportUserEvent",
    from = "UserEvent"
  },
  UnlockPhotoFrame = {
    id = 2250001,
    req = "Cmd.UnlockPhotoFrame",
    ack = "Cmd.UnlockPhotoFrame",
    from = "UserShow"
  },
  SyncAllPhotoFrame = {
    id = 2250002,
    req = "Cmd.SyncAllPhotoFrame",
    ack = "Cmd.SyncAllPhotoFrame",
    from = "UserShow"
  },
  SelectPhotoFrame = {
    id = 2250005,
    req = "Cmd.SelectPhotoFrame",
    ack = "Cmd.SelectPhotoFrame",
    from = "UserShow"
  },
  UnlockBackgroundFrame = {
    id = 2250003,
    req = "Cmd.UnlockBackgroundFrame",
    ack = "Cmd.UnlockBackgroundFrame",
    from = "UserShow"
  },
  SyncAllBackgroundFrame = {
    id = 2250004,
    req = "Cmd.SyncAllBackgroundFrame",
    ack = "Cmd.SyncAllBackgroundFrame",
    from = "UserShow"
  },
  SelectBackgroundFrame = {
    id = 2250006,
    req = "Cmd.SelectBackgroundFrame",
    ack = "Cmd.SelectBackgroundFrame",
    from = "UserShow"
  },
  SyncUnlockChatFrame = {
    id = 2250007,
    req = "Cmd.SyncUnlockChatFrame",
    ack = "Cmd.SyncUnlockChatFrame",
    from = "UserShow"
  },
  SelectChatFrame = {
    id = 2250008,
    req = "Cmd.SelectChatFrame",
    ack = "Cmd.SelectChatFrame",
    from = "UserShow"
  },
  ReqWeddingDateListCCmd = {
    id = 650001,
    req = "Cmd.ReqWeddingDateListCCmd",
    ack = "Cmd.ReqWeddingDateListCCmd",
    from = "WeddingCCmd"
  },
  ReqWeddingOneDayListCCmd = {
    id = 650003,
    req = "Cmd.ReqWeddingOneDayListCCmd",
    ack = "Cmd.ReqWeddingOneDayListCCmd",
    from = "WeddingCCmd"
  },
  ReqWeddingInfoCCmd = {
    id = 650004,
    req = "Cmd.ReqWeddingInfoCCmd",
    ack = "Cmd.ReqWeddingInfoCCmd",
    from = "WeddingCCmd"
  },
  ReserveWeddingDateCCmd = {
    id = 650005,
    req = "Cmd.ReserveWeddingDateCCmd",
    ack = "Cmd.ReserveWeddingDateCCmd",
    from = "WeddingCCmd"
  },
  NtfReserveWeddingDateCCmd = {
    id = 650006,
    req = "Cmd.NtfReserveWeddingDateCCmd",
    ack = "Cmd.NtfReserveWeddingDateCCmd",
    from = "WeddingCCmd"
  },
  ReplyReserveWeddingDateCCmd = {
    id = 650007,
    req = "Cmd.ReplyReserveWeddingDateCCmd",
    ack = "Cmd.ReplyReserveWeddingDateCCmd",
    from = "WeddingCCmd"
  },
  GiveUpReserveCCmd = {
    id = 650008,
    req = "Cmd.GiveUpReserveCCmd",
    ack = "Cmd.GiveUpReserveCCmd",
    from = "WeddingCCmd"
  },
  ReqDivorceCCmd = {
    id = 650009,
    req = "Cmd.ReqDivorceCCmd",
    ack = "Cmd.ReqDivorceCCmd",
    from = "WeddingCCmd"
  },
  UpdateWeddingManualCCmd = {
    id = 650010,
    req = "Cmd.UpdateWeddingManualCCmd",
    ack = "Cmd.UpdateWeddingManualCCmd",
    from = "WeddingCCmd"
  },
  BuyWeddingPackageCCmd = {
    id = 650011,
    req = "Cmd.BuyWeddingPackageCCmd",
    ack = "Cmd.BuyWeddingPackageCCmd",
    from = "WeddingCCmd"
  },
  BuyWeddingRingCCmd = {
    id = 650012,
    req = "Cmd.BuyWeddingRingCCmd",
    ack = "Cmd.BuyWeddingRingCCmd",
    from = "WeddingCCmd"
  },
  WeddingInviteCCmd = {
    id = 650013,
    req = "Cmd.WeddingInviteCCmd",
    ack = "Cmd.WeddingInviteCCmd",
    from = "WeddingCCmd"
  },
  UploadWeddingPhotoCCmd = {
    id = 650014,
    req = "Cmd.UploadWeddingPhotoCCmd",
    ack = "Cmd.UploadWeddingPhotoCCmd",
    from = "WeddingCCmd"
  },
  CheckCanReserveCCmd = {
    id = 650015,
    req = "Cmd.CheckCanReserveCCmd",
    ack = "Cmd.CheckCanReserveCCmd",
    from = "WeddingCCmd"
  },
  ReqPartnerInfoCCmd = {
    id = 650016,
    req = "Cmd.ReqPartnerInfoCCmd",
    ack = "Cmd.ReqPartnerInfoCCmd",
    from = "WeddingCCmd"
  },
  NtfWeddingInfoCCmd = {
    id = 650017,
    req = "Cmd.NtfWeddingInfoCCmd",
    ack = "Cmd.NtfWeddingInfoCCmd",
    from = "WeddingCCmd"
  },
  InviteBeginWeddingCCmd = {
    id = 650018,
    req = "Cmd.InviteBeginWeddingCCmd",
    ack = "Cmd.InviteBeginWeddingCCmd",
    from = "WeddingCCmd"
  },
  ReplyBeginWeddingCCmd = {
    id = 650019,
    req = "Cmd.ReplyBeginWeddingCCmd",
    ack = "Cmd.ReplyBeginWeddingCCmd",
    from = "WeddingCCmd"
  },
  GoToWeddingPosCCmd = {
    id = 650020,
    req = "Cmd.GoToWeddingPosCCmd",
    ack = "Cmd.GoToWeddingPosCCmd",
    from = "WeddingCCmd"
  },
  QuestionWeddingCCmd = {
    id = 650021,
    req = "Cmd.QuestionWeddingCCmd",
    ack = "Cmd.QuestionWeddingCCmd",
    from = "WeddingCCmd"
  },
  AnswerWeddingCCmd = {
    id = 650022,
    req = "Cmd.AnswerWeddingCCmd",
    ack = "Cmd.AnswerWeddingCCmd",
    from = "WeddingCCmd"
  },
  WeddingEventMsgCCmd = {
    id = 650023,
    req = "Cmd.WeddingEventMsgCCmd",
    ack = "Cmd.WeddingEventMsgCCmd",
    from = "WeddingCCmd"
  },
  WeddingOverCCmd = {
    id = 650024,
    req = "Cmd.WeddingOverCCmd",
    ack = "Cmd.WeddingOverCCmd",
    from = "WeddingCCmd"
  },
  WeddingSwitchQuestionCCmd = {
    id = 650025,
    req = "Cmd.WeddingSwitchQuestionCCmd",
    ack = "Cmd.WeddingSwitchQuestionCCmd",
    from = "WeddingCCmd"
  },
  EnterRollerCoasterCCmd = {
    id = 650026,
    req = "Cmd.EnterRollerCoasterCCmd",
    ack = "Cmd.EnterRollerCoasterCCmd",
    from = "WeddingCCmd"
  },
  DivorceRollerCoasterInviteCCmd = {
    id = 650027,
    req = "Cmd.DivorceRollerCoasterInviteCCmd",
    ack = "Cmd.DivorceRollerCoasterInviteCCmd",
    from = "WeddingCCmd"
  },
  DivorceRollerCoasterReplyCCmd = {
    id = 650028,
    req = "Cmd.DivorceRollerCoasterReplyCCmd",
    ack = "Cmd.DivorceRollerCoasterReplyCCmd",
    from = "WeddingCCmd"
  },
  EnterWeddingMapCCmd = {
    id = 650029,
    req = "Cmd.EnterWeddingMapCCmd",
    ack = "Cmd.EnterWeddingMapCCmd",
    from = "WeddingCCmd"
  },
  MissyouInviteWedCCmd = {
    id = 650030,
    req = "Cmd.MissyouInviteWedCCmd",
    ack = "Cmd.MissyouInviteWedCCmd",
    from = "WeddingCCmd"
  },
  MisccyouReplyWedCCmd = {
    id = 650031,
    req = "Cmd.MisccyouReplyWedCCmd",
    ack = "Cmd.MisccyouReplyWedCCmd",
    from = "WeddingCCmd"
  },
  WeddingCarrierCCmd = {
    id = 650032,
    req = "Cmd.WeddingCarrierCCmd",
    ack = "Cmd.WeddingCarrierCCmd",
    from = "WeddingCCmd"
  }
}
ProtoReqInfoList[170001] = ProtoReqInfoList.QueryUserResumeAchCmd
ProtoReqInfoList[170002] = ProtoReqInfoList.QueryAchieveDataAchCmd
ProtoReqInfoList[170003] = ProtoReqInfoList.NewAchieveNtfAchCmd
ProtoReqInfoList[170004] = ProtoReqInfoList.RewardGetAchCmd
ProtoReqInfoList[170005] = ProtoReqInfoList.RewardGetQuickAchCmd
ProtoReqInfoList[170006] = ProtoReqInfoList.NewNpcAchieveNtfAchCmd
ProtoReqInfoList[170007] = ProtoReqInfoList.QueryNpcAchieveAchCmd
ProtoReqInfoList[170008] = ProtoReqInfoList.UpdateNpcAchieveAchCmd
ProtoReqInfoList[170009] = ProtoReqInfoList.GetNpcAchieveRewardAchCmd
ProtoReqInfoList[2260001] = ProtoReqInfoList.ActityQueryHitedList
ProtoReqInfoList[2260002] = ProtoReqInfoList.ActivityHitPolly
ProtoReqInfoList[2260003] = ProtoReqInfoList.ActityHitPollySync
ProtoReqInfoList[2260004] = ProtoReqInfoList.ActityHitPollySubmitQuest
ProtoReqInfoList[2260005] = ProtoReqInfoList.ActityHitPollyNtfQuest
ProtoReqInfoList[2290001] = ProtoReqInfoList.ActMiniRoOpenPage
ProtoReqInfoList[2290002] = ProtoReqInfoList.ActMiniRoCastDice
ProtoReqInfoList[2290004] = ProtoReqInfoList.ActMiniRoDiceSync
ProtoReqInfoList[2290003] = ProtoReqInfoList.ActMiniRoGetOneKey
ProtoReqInfoList[2290005] = ProtoReqInfoList.ActMiniRoEventFAQS
ProtoReqInfoList[2290006] = ProtoReqInfoList.ActMiniRoCheckCircleReward
ProtoReqInfoList[600001] = ProtoReqInfoList.StartActCmd
ProtoReqInfoList[600004] = ProtoReqInfoList.StopActCmd
ProtoReqInfoList[600002] = ProtoReqInfoList.BCatUFOPosActCmd
ProtoReqInfoList[600003] = ProtoReqInfoList.ActProgressNtfCmd
ProtoReqInfoList[600005] = ProtoReqInfoList.StartGlobalActCmd
ProtoReqInfoList[600006] = ProtoReqInfoList.ActProgressExceptNtfCmd
ProtoReqInfoList[600007] = ProtoReqInfoList.TimeLimitShopPageCmd
ProtoReqInfoList[600008] = ProtoReqInfoList.AnimationLoginActCmd
ProtoReqInfoList[600009] = ProtoReqInfoList.GlobalDonationActivityInfoCmd
ProtoReqInfoList[600010] = ProtoReqInfoList.GlobalDonationActivityDonateCmd
ProtoReqInfoList[600011] = ProtoReqInfoList.GlobalDonationActivityAwardCmd
ProtoReqInfoList[600012] = ProtoReqInfoList.UserInviteInfoCmd
ProtoReqInfoList[600013] = ProtoReqInfoList.UserInviteBindUserCmd
ProtoReqInfoList[600014] = ProtoReqInfoList.UserInviteInviteAwardCmd
ProtoReqInfoList[600015] = ProtoReqInfoList.UserInviteShareAwardCmd
ProtoReqInfoList[600016] = ProtoReqInfoList.UserInviteInviteLoginAwardCmd
ProtoReqInfoList[600017] = ProtoReqInfoList.UserInviteRecallLoginAwardCmd
ProtoReqInfoList[600018] = ProtoReqInfoList.UserReturnInfoCmd
ProtoReqInfoList[600019] = ProtoReqInfoList.UserReturnQuestAwardCmd
ProtoReqInfoList[600020] = ProtoReqInfoList.UserReturnQuestAddCmd
ProtoReqInfoList[600021] = ProtoReqInfoList.UserReturnEnterChatRoomCmd
ProtoReqInfoList[600022] = ProtoReqInfoList.UserReturnLeaveChatRoomCmd
ProtoReqInfoList[600023] = ProtoReqInfoList.UserReturnLoginAwardCmd
ProtoReqInfoList[600024] = ProtoReqInfoList.UserReturnChatRoomRecordCmd
ProtoReqInfoList[600025] = ProtoReqInfoList.UserReturnRaidAwardCmd
ProtoReqInfoList[600030] = ProtoReqInfoList.WishActivityInfoCmd
ProtoReqInfoList[600031] = ProtoReqInfoList.WishActivityWishCmd
ProtoReqInfoList[600032] = ProtoReqInfoList.WishActivityLikeCmd
ProtoReqInfoList[600033] = ProtoReqInfoList.WishActivityLikeRecordCmd
ProtoReqInfoList[600041] = ProtoReqInfoList.UserReturnInviteCmd
ProtoReqInfoList[600039] = ProtoReqInfoList.UserReturnShareAwardCmd
ProtoReqInfoList[600040] = ProtoReqInfoList.UserReturnInviteAwardCmd
ProtoReqInfoList[600038] = ProtoReqInfoList.UserReturnBindCmd
ProtoReqInfoList[600042] = ProtoReqInfoList.UserReturnInviteRecordCmd
ProtoReqInfoList[600043] = ProtoReqInfoList.UserReturnInviteActivityNtfCmd
ProtoReqInfoList[600034] = ProtoReqInfoList.GuildAssembleSyncCmd
ProtoReqInfoList[600035] = ProtoReqInfoList.GuildAssembleAcceptCmd
ProtoReqInfoList[600036] = ProtoReqInfoList.GuildAssembleAwardCmd
ProtoReqInfoList[600026] = ProtoReqInfoList.DaySigninInfoCmd
ProtoReqInfoList[600027] = ProtoReqInfoList.DaySigninLoginAwardCmd
ProtoReqInfoList[600028] = ProtoReqInfoList.DaySigninActivityCmd
ProtoReqInfoList[600046] = ProtoReqInfoList.BattleFundNofityActCmd
ProtoReqInfoList[600047] = ProtoReqInfoList.BattleFundRewardActCmd
ProtoReqInfoList[600044] = ProtoReqInfoList.UserInviteCmd
ProtoReqInfoList[600045] = ProtoReqInfoList.UserInviteAwardCmd
ProtoReqInfoList[600048] = ProtoReqInfoList.NewPartnerCmd
ProtoReqInfoList[600049] = ProtoReqInfoList.NewPartnerBindCmd
ProtoReqInfoList[600050] = ProtoReqInfoList.AnniversaryInfoSync
ProtoReqInfoList[600051] = ProtoReqInfoList.AnniversarySignInReward
ProtoReqInfoList[600053] = ProtoReqInfoList.ActBpUpdateCmd
ProtoReqInfoList[600054] = ProtoReqInfoList.ActBpGetRewardCmd
ProtoReqInfoList[600055] = ProtoReqInfoList.ActBpBuyLevelCmd
ProtoReqInfoList[600056] = ProtoReqInfoList.FinishGlobalActivityCmd
ProtoReqInfoList[600057] = ProtoReqInfoList.RewardInfoGlobalActivityCmd
ProtoReqInfoList[600058] = ProtoReqInfoList.FlipCardInfoSyncCmd
ProtoReqInfoList[600059] = ProtoReqInfoList.FlipCardGetRewardCmd
ProtoReqInfoList[600060] = ProtoReqInfoList.FlipCardBuyChanceCmd
ProtoReqInfoList[600082] = ProtoReqInfoList.MissionRewardInfoSyncCmd
ProtoReqInfoList[600083] = ProtoReqInfoList.MissionRewardGetRewardCmd
ProtoReqInfoList[600061] = ProtoReqInfoList.ActPersonalTimeSyncCmd
ProtoReqInfoList[600064] = ProtoReqInfoList.NewServerChallengeSyncCmd
ProtoReqInfoList[600065] = ProtoReqInfoList.NewServerChallengeRewardCmd
ProtoReqInfoList[600062] = ProtoReqInfoList.RandHomeGiftBoxGridCmd
ProtoReqInfoList[600063] = ProtoReqInfoList.OpenHomeGiftBoxCmd
ProtoReqInfoList[600066] = ProtoReqInfoList.EscortActUpdateCmd
ProtoReqInfoList[600067] = ProtoReqInfoList.PutGoodsCmd
ProtoReqInfoList[600068] = ProtoReqInfoList.YearMemoryActInfoCmd
ProtoReqInfoList[600069] = ProtoReqInfoList.YearMemoryGetShareRewardCmd
ProtoReqInfoList[600074] = ProtoReqInfoList.FateSelectSyncInfoCmd
ProtoReqInfoList[600075] = ProtoReqInfoList.FateSelectDrawCmd
ProtoReqInfoList[600076] = ProtoReqInfoList.FateSelectRewardCmd
ProtoReqInfoList[600077] = ProtoReqInfoList.FateSelectTargetUpdateCmd
ProtoReqInfoList[600078] = ProtoReqInfoList.ActExchangeItemCmd
ProtoReqInfoList[600079] = ProtoReqInfoList.ActExchangeInfoCmd
ProtoReqInfoList[600080] = ProtoReqInfoList.EnterBigCatInvadeCmd
ProtoReqInfoList[600081] = ProtoReqInfoList.LeaveActStaticMapCmd
ProtoReqInfoList[600084] = ProtoReqInfoList.ActCardLevelUpInfoSyncCmd
ProtoReqInfoList[640001] = ProtoReqInfoList.ActivityEventNtf
ProtoReqInfoList[640002] = ProtoReqInfoList.ActivityEventUserDataNtf
ProtoReqInfoList[640003] = ProtoReqInfoList.ActivityEventNtfEventCntCmd
ProtoReqInfoList[640004] = ProtoReqInfoList.FinishActivityEventCmd
ProtoReqInfoList[280001] = ProtoReqInfoList.AstrolabeQueryCmd
ProtoReqInfoList[280002] = ProtoReqInfoList.AstrolabeActivateStarCmd
ProtoReqInfoList[280003] = ProtoReqInfoList.AstrolabeQueryResetCmd
ProtoReqInfoList[280004] = ProtoReqInfoList.AstrolabeResetCmd
ProtoReqInfoList[280005] = ProtoReqInfoList.AstrolabePlanSaveCmd
ProtoReqInfoList[630001] = ProtoReqInfoList.NtfAuctionStateCCmd
ProtoReqInfoList[630002] = ProtoReqInfoList.OpenAuctionPanelCCmd
ProtoReqInfoList[630003] = ProtoReqInfoList.NtfSignUpInfoCCmd
ProtoReqInfoList[630014] = ProtoReqInfoList.NtfMySignUpInfoCCmd
ProtoReqInfoList[630012] = ProtoReqInfoList.SignUpItemCCmd
ProtoReqInfoList[630004] = ProtoReqInfoList.NtfAuctionInfoCCmd
ProtoReqInfoList[630005] = ProtoReqInfoList.UpdateAuctionInfoCCmd
ProtoReqInfoList[630006] = ProtoReqInfoList.ReqAuctionFlowingWaterCCmd
ProtoReqInfoList[630007] = ProtoReqInfoList.UpdateAuctionFlowingWaterCCmd
ProtoReqInfoList[630008] = ProtoReqInfoList.ReqLastAuctionInfoCCmd
ProtoReqInfoList[630009] = ProtoReqInfoList.OfferPriceCCmd
ProtoReqInfoList[630010] = ProtoReqInfoList.ReqAuctionRecordCCmd
ProtoReqInfoList[630011] = ProtoReqInfoList.TakeAuctionRecordCCmd
ProtoReqInfoList[630013] = ProtoReqInfoList.NtfCanTakeCntCCmd
ProtoReqInfoList[630015] = ProtoReqInfoList.NtfMyOfferPriceCCmd
ProtoReqInfoList[630016] = ProtoReqInfoList.NtfNextAuctionInfoCCmd
ProtoReqInfoList[630017] = ProtoReqInfoList.ReqAuctionInfoCCmd
ProtoReqInfoList[630018] = ProtoReqInfoList.NtfCurAuctionInfoCCmd
ProtoReqInfoList[630019] = ProtoReqInfoList.NtfOverTakePriceCCmd
ProtoReqInfoList[630020] = ProtoReqInfoList.ReqMyTradedPriceCCmd
ProtoReqInfoList[630021] = ProtoReqInfoList.NtfMaskPriceCCmd
ProtoReqInfoList[630022] = ProtoReqInfoList.AuctionDialogCCmd
ProtoReqInfoList[620001] = ProtoReqInfoList.SetAuthorizeUserCmd
ProtoReqInfoList[620002] = ProtoReqInfoList.ResetAuthorizeUserCmd
ProtoReqInfoList[620003] = ProtoReqInfoList.SyncAuthorizeToSession
ProtoReqInfoList[620004] = ProtoReqInfoList.NotifyAuthorizeUserCmd
ProtoReqInfoList[620005] = ProtoReqInfoList.SyncRealAuthorizeToSession
ProtoReqInfoList[2220001] = ProtoReqInfoList.GetRewardBattlePassCmd
ProtoReqInfoList[2220002] = ProtoReqInfoList.UpdateRewardBattlePassCmd
ProtoReqInfoList[2220003] = ProtoReqInfoList.BuyLevelBattlePassCmd
ProtoReqInfoList[2220004] = ProtoReqInfoList.AdvanceBattlePassCmd
ProtoReqInfoList[2220005] = ProtoReqInfoList.SyncInfoBattlePassCmd
ProtoReqInfoList[2220006] = ProtoReqInfoList.BattlePassQuestInfoCmd
ProtoReqInfoList[150001] = ProtoReqInfoList.BossListUserCmd
ProtoReqInfoList[150002] = ProtoReqInfoList.BossPosUserCmd
ProtoReqInfoList[150003] = ProtoReqInfoList.KillBossUserCmd
ProtoReqInfoList[150004] = ProtoReqInfoList.QueryKillerInfoBossCmd
ProtoReqInfoList[150005] = ProtoReqInfoList.WorldBossNtf
ProtoReqInfoList[150006] = ProtoReqInfoList.StepSyncBossCmd
ProtoReqInfoList[150007] = ProtoReqInfoList.QueryFavaouiteBossCmd
ProtoReqInfoList[150008] = ProtoReqInfoList.ModifyFavouriteBossCmd
ProtoReqInfoList[150009] = ProtoReqInfoList.QueryRareEliteCmd
ProtoReqInfoList[150010] = ProtoReqInfoList.QuerySpecMapRareEliteCmd
ProtoReqInfoList[150011] = ProtoReqInfoList.UpdateCurMapBossCmd
ProtoReqInfoList[160001] = ProtoReqInfoList.CarrierInfoUserCmd
ProtoReqInfoList[160006] = ProtoReqInfoList.CreateCarrierUserCmd
ProtoReqInfoList[160010] = ProtoReqInfoList.InviteCarrierUserCmd
ProtoReqInfoList[160002] = ProtoReqInfoList.JoinCarrierUserCmd
ProtoReqInfoList[160003] = ProtoReqInfoList.RetJoinCarrierUserCmd
ProtoReqInfoList[160004] = ProtoReqInfoList.LeaveCarrierUserCmd
ProtoReqInfoList[160009] = ProtoReqInfoList.ReachCarrierUserCmd
ProtoReqInfoList[160005] = ProtoReqInfoList.CarrierMoveUserCmd
ProtoReqInfoList[160007] = ProtoReqInfoList.CarrierStartUserCmd
ProtoReqInfoList[160008] = ProtoReqInfoList.CarrierWaitListUserCmd
ProtoReqInfoList[160011] = ProtoReqInfoList.ChangeCarrierUserCmd
ProtoReqInfoList[160012] = ProtoReqInfoList.FerrisWheelInviteCarrierCmd
ProtoReqInfoList[160013] = ProtoReqInfoList.FerrisWheelProcessInviteCarrierCmd
ProtoReqInfoList[160014] = ProtoReqInfoList.StartFerrisWheelUserCmd
ProtoReqInfoList[160015] = ProtoReqInfoList.CatchUserJoinCarrierUserCmd
ProtoReqInfoList[590001] = ProtoReqInfoList.QueryItemData
ProtoReqInfoList[590002] = ProtoReqInfoList.PlayExpressionChatCmd
ProtoReqInfoList[590003] = ProtoReqInfoList.QueryUserInfoChatCmd
ProtoReqInfoList[590020] = ProtoReqInfoList.QueryUserGemChatCmd
ProtoReqInfoList[590004] = ProtoReqInfoList.BarrageChatCmd
ProtoReqInfoList[590005] = ProtoReqInfoList.BarrageMsgChatCmd
ProtoReqInfoList[590006] = ProtoReqInfoList.ChatCmd
ProtoReqInfoList[590007] = ProtoReqInfoList.ChatRetCmd
ProtoReqInfoList[590008] = ProtoReqInfoList.QueryVoiceUserCmd
ProtoReqInfoList[590010] = ProtoReqInfoList.GetVoiceIDChatCmd
ProtoReqInfoList[590011] = ProtoReqInfoList.LoveLetterNtf
ProtoReqInfoList[590012] = ProtoReqInfoList.ChatSelfNtf
ProtoReqInfoList[590013] = ProtoReqInfoList.NpcChatNtf
ProtoReqInfoList[590016] = ProtoReqInfoList.QueryUserShowInfoCmd
ProtoReqInfoList[590015] = ProtoReqInfoList.SystemBarrageChatCmd
ProtoReqInfoList[590017] = ProtoReqInfoList.QueryFavoriteExpressionChatCmd
ProtoReqInfoList[590018] = ProtoReqInfoList.UpdateFavoriteExpressionChatCmd
ProtoReqInfoList[590019] = ProtoReqInfoList.ExpressionChatCmd
ProtoReqInfoList[590021] = ProtoReqInfoList.FaceShowChatCmd
ProtoReqInfoList[590022] = ProtoReqInfoList.ClientLogChatCmd
ProtoReqInfoList[1] = ProtoReqInfoList.RedPacketContent
ProtoReqInfoList[590023] = ProtoReqInfoList.SendRedPacketCmd
ProtoReqInfoList[590024] = ProtoReqInfoList.ReceiveRedPacketCmd
ProtoReqInfoList[590025] = ProtoReqInfoList.InitUserRedPacketCmd
ProtoReqInfoList[590027] = ProtoReqInfoList.ReceiveRedPacketRet
ProtoReqInfoList[590028] = ProtoReqInfoList.ShareMsgCmd
ProtoReqInfoList[590029] = ProtoReqInfoList.ShareSuccessNofityCmd
ProtoReqInfoList[590030] = ProtoReqInfoList.QueryGuildRedPacketChatCmd
ProtoReqInfoList[590031] = ProtoReqInfoList.CheckRecvRedPacketChatCmd
ProtoReqInfoList[2320001] = ProtoReqInfoList.QueryDisneyGuideInfoCmd
ProtoReqInfoList[2320002] = ProtoReqInfoList.ReceiveGuideRewardCmd
ProtoReqInfoList[2320003] = ProtoReqInfoList.ReceiveMickeyRewardCmd
ProtoReqInfoList[2320004] = ProtoReqInfoList.DisneyChallengeTaskRankCmd
ProtoReqInfoList[2320005] = ProtoReqInfoList.DisneyChallengeTaskTipCmd
ProtoReqInfoList[2320006] = ProtoReqInfoList.DisneyChallengeTaskPointCmd
ProtoReqInfoList[2320007] = ProtoReqInfoList.DisneyChallengeTaskNotifyFirstFinishCmd
ProtoReqInfoList[2320008] = ProtoReqInfoList.DisneyMusicOpenCmd
ProtoReqInfoList[2320009] = ProtoReqInfoList.DisneyMusicUpdateCmd
ProtoReqInfoList[2320010] = ProtoReqInfoList.DisneyMusicChooseHeroCmd
ProtoReqInfoList[2320011] = ProtoReqInfoList.DisneyMusicPrepareCmd
ProtoReqInfoList[2320012] = ProtoReqInfoList.DisneyMusicChooseMusicCmd
ProtoReqInfoList[2320013] = ProtoReqInfoList.DisneyMusicStartCmd
ProtoReqInfoList[2320014] = ProtoReqInfoList.DisneyMusicFinishCmd
ProtoReqInfoList[2320015] = ProtoReqInfoList.DisneyMusicResultCmd
ProtoReqInfoList[2320016] = ProtoReqInfoList.DisneyMusicRankCmd
ProtoReqInfoList[2320017] = ProtoReqInfoList.DisneyMusicClientPrepareCmd
ProtoReqInfoList[580001] = ProtoReqInfoList.DojoPrivateInfoCmd
ProtoReqInfoList[580002] = ProtoReqInfoList.DojoPublicInfoCmd
ProtoReqInfoList[580003] = ProtoReqInfoList.DojoInviteCmd
ProtoReqInfoList[580004] = ProtoReqInfoList.DojoReplyCmd
ProtoReqInfoList[580005] = ProtoReqInfoList.EnterDojo
ProtoReqInfoList[580006] = ProtoReqInfoList.DojoAddMsg
ProtoReqInfoList[580007] = ProtoReqInfoList.DojoPanelOper
ProtoReqInfoList[580009] = ProtoReqInfoList.DojoSponsorCmd
ProtoReqInfoList[580010] = ProtoReqInfoList.DojoQueryStateCmd
ProtoReqInfoList[580011] = ProtoReqInfoList.DojoRewardCmd
ProtoReqInfoList[20001] = ProtoReqInfoList.RegErrUserCmd
ProtoReqInfoList[20002] = ProtoReqInfoList.KickUserErrorCmd
ProtoReqInfoList[20003] = ProtoReqInfoList.MaintainUserCmd
ProtoReqInfoList[2340001] = ProtoReqInfoList.ClueDataNtfFamilyCmd
ProtoReqInfoList[2340002] = ProtoReqInfoList.ClueUnlockFamilyCmd
ProtoReqInfoList[2340003] = ProtoReqInfoList.ClueRewardFamilyCmd
ProtoReqInfoList[110001] = ProtoReqInfoList.TrackFuBenUserCmd
ProtoReqInfoList[110002] = ProtoReqInfoList.FailFuBenUserCmd
ProtoReqInfoList[110003] = ProtoReqInfoList.LeaveFuBenUserCmd
ProtoReqInfoList[110004] = ProtoReqInfoList.SuccessFuBenUserCmd
ProtoReqInfoList[110005] = ProtoReqInfoList.WorldStageUserCmd
ProtoReqInfoList[110006] = ProtoReqInfoList.StageStepUserCmd
ProtoReqInfoList[110007] = ProtoReqInfoList.StartStageUserCmd
ProtoReqInfoList[110008] = ProtoReqInfoList.GetRewardStageUserCmd
ProtoReqInfoList[110009] = ProtoReqInfoList.StageStepStarUserCmd
ProtoReqInfoList[110011] = ProtoReqInfoList.MonsterCountUserCmd
ProtoReqInfoList[110012] = ProtoReqInfoList.FubenStepSyncCmd
ProtoReqInfoList[110013] = ProtoReqInfoList.FuBenProgressSyncCmd
ProtoReqInfoList[110015] = ProtoReqInfoList.FuBenClearInfoCmd
ProtoReqInfoList[1] = ProtoReqInfoList.GuildGateData
ProtoReqInfoList[110016] = ProtoReqInfoList.UserGuildRaidFubenCmd
ProtoReqInfoList[110017] = ProtoReqInfoList.GuildGateOptCmd
ProtoReqInfoList[110018] = ProtoReqInfoList.GuildFireInfoFubenCmd
ProtoReqInfoList[110019] = ProtoReqInfoList.GuildFireStopFubenCmd
ProtoReqInfoList[110020] = ProtoReqInfoList.GuildFireDangerFubenCmd
ProtoReqInfoList[110021] = ProtoReqInfoList.GuildFireMetalHpFubenCmd
ProtoReqInfoList[110022] = ProtoReqInfoList.GuildFireCalmFubenCmd
ProtoReqInfoList[110023] = ProtoReqInfoList.GuildFireNewDefFubenCmd
ProtoReqInfoList[110024] = ProtoReqInfoList.GuildFireRestartFubenCmd
ProtoReqInfoList[110025] = ProtoReqInfoList.GuildFireStatusFubenCmd
ProtoReqInfoList[110026] = ProtoReqInfoList.GvgDataSyncCmd
ProtoReqInfoList[110027] = ProtoReqInfoList.GvgDataUpdateCmd
ProtoReqInfoList[110028] = ProtoReqInfoList.GvgDefNameChangeFubenCmd
ProtoReqInfoList[110029] = ProtoReqInfoList.SyncMvpInfoFubenCmd
ProtoReqInfoList[110030] = ProtoReqInfoList.BossDieFubenCmd
ProtoReqInfoList[110031] = ProtoReqInfoList.UpdateUserNumFubenCmd
ProtoReqInfoList[110032] = ProtoReqInfoList.SuperGvgSyncFubenCmd
ProtoReqInfoList[110033] = ProtoReqInfoList.GvgTowerUpdateFubenCmd
ProtoReqInfoList[110039] = ProtoReqInfoList.GvgMetalDieFubenCmd
ProtoReqInfoList[110034] = ProtoReqInfoList.GvgCrystalUpdateFubenCmd
ProtoReqInfoList[110035] = ProtoReqInfoList.QueryGvgTowerInfoFubenCmd
ProtoReqInfoList[110036] = ProtoReqInfoList.SuperGvgRewardInfoFubenCmd
ProtoReqInfoList[110037] = ProtoReqInfoList.SuperGvgQueryUserDataFubenCmd
ProtoReqInfoList[110038] = ProtoReqInfoList.MvpBattleReportFubenCmd
ProtoReqInfoList[110040] = ProtoReqInfoList.InviteSummonBossFubenCmd
ProtoReqInfoList[110041] = ProtoReqInfoList.ReplySummonBossFubenCmd
ProtoReqInfoList[110042] = ProtoReqInfoList.QueryTeamPwsUserInfoFubenCmd
ProtoReqInfoList[110043] = ProtoReqInfoList.TeamPwsReportFubenCmd
ProtoReqInfoList[110044] = ProtoReqInfoList.TeamPwsInfoSyncFubenCmd
ProtoReqInfoList[110047] = ProtoReqInfoList.UpdateTeamPwsInfoFubenCmd
ProtoReqInfoList[110045] = ProtoReqInfoList.SelectTeamPwsMagicFubenCmd
ProtoReqInfoList[110048] = ProtoReqInfoList.ExitMapFubenCmd
ProtoReqInfoList[110049] = ProtoReqInfoList.BeginFireFubenCmd
ProtoReqInfoList[110050] = ProtoReqInfoList.TeamExpReportFubenCmd
ProtoReqInfoList[110051] = ProtoReqInfoList.BuyExpRaidItemFubenCmd
ProtoReqInfoList[110052] = ProtoReqInfoList.TeamExpSyncFubenCmd
ProtoReqInfoList[110053] = ProtoReqInfoList.TeamReliveCountFubenCmd
ProtoReqInfoList[110054] = ProtoReqInfoList.TeamGroupRaidUpdateChipNum
ProtoReqInfoList[110055] = ProtoReqInfoList.QueryTeamGroupRaidUserInfo
ProtoReqInfoList[110057] = ProtoReqInfoList.GroupRaidStateSyncFuBenCmd
ProtoReqInfoList[110056] = ProtoReqInfoList.TeamExpQueryInfoFubenCmd
ProtoReqInfoList[110060] = ProtoReqInfoList.UpdateGroupRaidFourthShowData
ProtoReqInfoList[110059] = ProtoReqInfoList.QueryGroupRaidFourthShowData
ProtoReqInfoList[110061] = ProtoReqInfoList.GroupRaidFourthGoOuterCmd
ProtoReqInfoList[110062] = ProtoReqInfoList.RaidStageSyncFubenCmd
ProtoReqInfoList[110063] = ProtoReqInfoList.ThanksGivingMonsterFuBenCmd
ProtoReqInfoList[110058] = ProtoReqInfoList.KumamotoOperFubenCmd
ProtoReqInfoList[110064] = ProtoReqInfoList.OthelloPointOccupyPowerFubenCmd
ProtoReqInfoList[110065] = ProtoReqInfoList.OthelloInfoSyncFubenCmd
ProtoReqInfoList[110066] = ProtoReqInfoList.QueryOthelloUserInfoFubenCmd
ProtoReqInfoList[110067] = ProtoReqInfoList.OthelloReportFubenCmd
ProtoReqInfoList[110068] = ProtoReqInfoList.RoguelikeUnlockSceneSync
ProtoReqInfoList[110069] = ProtoReqInfoList.TransferFightChooseFubenCmd
ProtoReqInfoList[110070] = ProtoReqInfoList.TransferFightRankFubenCmd
ProtoReqInfoList[110071] = ProtoReqInfoList.TransferFightEndFubenCmd
ProtoReqInfoList[110082] = ProtoReqInfoList.InviteRollRewardFubenCmd
ProtoReqInfoList[110083] = ProtoReqInfoList.ReplyRollRewardFubenCmd
ProtoReqInfoList[110084] = ProtoReqInfoList.TeamRollStatusFuBenCmd
ProtoReqInfoList[110085] = ProtoReqInfoList.PreReplyRollRewardFubenCmd
ProtoReqInfoList[110072] = ProtoReqInfoList.TwelvePvpSyncCmd
ProtoReqInfoList[110073] = ProtoReqInfoList.RaidItemSyncCmd
ProtoReqInfoList[110074] = ProtoReqInfoList.RaidItemUpdateCmd
ProtoReqInfoList[110081] = ProtoReqInfoList.TwelvePvpUseItemCmd
ProtoReqInfoList[110075] = ProtoReqInfoList.RaidShopUpdateCmd
ProtoReqInfoList[110076] = ProtoReqInfoList.TwelvePvpQuestQueryCmd
ProtoReqInfoList[110077] = ProtoReqInfoList.TwelvePvpQueryGroupInfoCmd
ProtoReqInfoList[110078] = ProtoReqInfoList.TwelvePvpResultCmd
ProtoReqInfoList[110079] = ProtoReqInfoList.TwelvePvpBuildingHpUpdateCmd
ProtoReqInfoList[110080] = ProtoReqInfoList.TwelvePvpUIOperCmd
ProtoReqInfoList[110086] = ProtoReqInfoList.ReliveCdFubenCmd
ProtoReqInfoList[110087] = ProtoReqInfoList.PosSyncFubenCmd
ProtoReqInfoList[110088] = ProtoReqInfoList.ReqEnterTowerPrivate
ProtoReqInfoList[110089] = ProtoReqInfoList.TowerPrivateLayerInfo
ProtoReqInfoList[110090] = ProtoReqInfoList.TowerPrivateLayerCountdownNtf
ProtoReqInfoList[110091] = ProtoReqInfoList.FubenResultNtf
ProtoReqInfoList[110092] = ProtoReqInfoList.EndTimeSyncFubenCmd
ProtoReqInfoList[110093] = ProtoReqInfoList.ResultSyncFubenCmd
ProtoReqInfoList[110097] = ProtoReqInfoList.ComodoPhaseFubenCmd
ProtoReqInfoList[110098] = ProtoReqInfoList.QueryComodoTeamRaidStat
ProtoReqInfoList[110099] = ProtoReqInfoList.TeamPwsStateSyncFubenCmd
ProtoReqInfoList[110100] = ProtoReqInfoList.ObserverFlashFubenCmd
ProtoReqInfoList[110101] = ProtoReqInfoList.ObserverAttachFubenCmd
ProtoReqInfoList[110102] = ProtoReqInfoList.ObserverSelectFubenCmd
ProtoReqInfoList[110104] = ProtoReqInfoList.ObHpspUpdateFubenCmd
ProtoReqInfoList[110105] = ProtoReqInfoList.ObPlayerOfflineFubenCmd
ProtoReqInfoList[110106] = ProtoReqInfoList.MultiBossPhaseFubenCmd
ProtoReqInfoList[110107] = ProtoReqInfoList.QueryMultiBossRaidStat
ProtoReqInfoList[1] = ProtoReqInfoList.PvePassShowReward
ProtoReqInfoList[110108] = ProtoReqInfoList.ObMoveCameraPrepareCmd
ProtoReqInfoList[110109] = ProtoReqInfoList.ObCameraMoveEndCmd
ProtoReqInfoList[110110] = ProtoReqInfoList.RaidKillNumSyncCmd
ProtoReqInfoList[110118] = ProtoReqInfoList.SyncPvePassInfoFubenCmd
ProtoReqInfoList[110126] = ProtoReqInfoList.SyncPveRaidAchieveFubenCmd
ProtoReqInfoList[110127] = ProtoReqInfoList.QuickFinishCrackRaidFubenCmd
ProtoReqInfoList[110128] = ProtoReqInfoList.PickupPveRaidAchieveFubenCmd
ProtoReqInfoList[110119] = ProtoReqInfoList.GvgPointUpdateFubenCmd
ProtoReqInfoList[110122] = ProtoReqInfoList.GvgRaidStateUpdateFubenCmd
ProtoReqInfoList[110129] = ProtoReqInfoList.AddPveCardTimesFubenCmd
ProtoReqInfoList[110130] = ProtoReqInfoList.SyncPveCardOpenStateFubenCmd
ProtoReqInfoList[110131] = ProtoReqInfoList.QuickFinishPveRaidFubenCmd
ProtoReqInfoList[110132] = ProtoReqInfoList.SyncPveCardRewardTimesFubenCmd
ProtoReqInfoList[110133] = ProtoReqInfoList.GvgPerfectStateUpdateFubenCmd
ProtoReqInfoList[110136] = ProtoReqInfoList.QueryElementRaidStat
ProtoReqInfoList[110137] = ProtoReqInfoList.SyncEmotionFactorsFuBenCmd
ProtoReqInfoList[110134] = ProtoReqInfoList.SyncBossSceneInfo
ProtoReqInfoList[110139] = ProtoReqInfoList.SyncUnlockRoomIDsFuBenCmd
ProtoReqInfoList[110138] = ProtoReqInfoList.SyncVisitNpcInfo
ProtoReqInfoList[110140] = ProtoReqInfoList.SyncMonsterCountFuBenCmd
ProtoReqInfoList[110141] = ProtoReqInfoList.SkipAnimationFuBenCmd
ProtoReqInfoList[110135] = ProtoReqInfoList.ResetRaidFubenCmd
ProtoReqInfoList[110142] = ProtoReqInfoList.SyncStarArkInfoFuBenCmd
ProtoReqInfoList[110143] = ProtoReqInfoList.SyncStarArkStatisticsFuBenCmd
ProtoReqInfoList[110144] = ProtoReqInfoList.OpenNtfFuBenCmd
ProtoReqInfoList[110145] = ProtoReqInfoList.RoadblocksChangeFubenCmd
ProtoReqInfoList[110152] = ProtoReqInfoList.SyncPassUserInfo
ProtoReqInfoList[110146] = ProtoReqInfoList.SyncTripleFireInfoFuBenCmd
ProtoReqInfoList[110147] = ProtoReqInfoList.SyncTripleComboKillFuBenCmd
ProtoReqInfoList[110148] = ProtoReqInfoList.SyncTriplePlayerModelFuBenCmd
ProtoReqInfoList[110149] = ProtoReqInfoList.SyncTripleProfessionTimeFuBenCmd
ProtoReqInfoList[110150] = ProtoReqInfoList.SyncTripleCampInfoFuBenCmd
ProtoReqInfoList[110151] = ProtoReqInfoList.SyncTripleEnterCountFuBenCmd
ProtoReqInfoList[110153] = ProtoReqInfoList.ChooseCurProfessionFuBenCmd
ProtoReqInfoList[110154] = ProtoReqInfoList.SyncTripleFightingInfoFuBenCmd
ProtoReqInfoList[110155] = ProtoReqInfoList.SyncFullFireStateFubenCmd
ProtoReqInfoList[110156] = ProtoReqInfoList.EBFEventDataUpdateCmd
ProtoReqInfoList[110157] = ProtoReqInfoList.EBFMiscDataUpdate
ProtoReqInfoList[110158] = ProtoReqInfoList.OccupyPointDataUpdate
ProtoReqInfoList[110159] = ProtoReqInfoList.QueryPvpStatCmd
ProtoReqInfoList[110160] = ProtoReqInfoList.EBFKickTimeCmd
ProtoReqInfoList[110161] = ProtoReqInfoList.EBFContinueCmd
ProtoReqInfoList[110162] = ProtoReqInfoList.EBFEventAreaUpdateCmd
ProtoReqInfoList[110163] = ProtoReqInfoList.AstralInfoSyncCmd
ProtoReqInfoList[110164] = ProtoReqInfoList.GvgMvpInfoUpdateCmd
ProtoReqInfoList[110165] = ProtoReqInfoList.AstralPrayBranchSyncCmd
ProtoReqInfoList[110166] = ProtoReqInfoList.SyncStartFightStateCmd
ProtoReqInfoList[110167] = ProtoReqInfoList.SyncGvgFightPointCmd
ProtoReqInfoList[110168] = ProtoReqInfoList.SyncGvgLeaderPosCmd
ProtoReqInfoList[110169] = ProtoReqInfoList.STISyncScoreCmd
ProtoReqInfoList[110170] = ProtoReqInfoList.STISyncSkillCmd
ProtoReqInfoList[110171] = ProtoReqInfoList.STISyncAvailableUpgradeNumberCmd
ProtoReqInfoList[110172] = ProtoReqInfoList.STIGetUpgradeOptionsCmd
ProtoReqInfoList[110173] = ProtoReqInfoList.STIRetUpgradeOptionsCmd
ProtoReqInfoList[110174] = ProtoReqInfoList.STIExecSkillUpgradeCmd
ProtoReqInfoList[110175] = ProtoReqInfoList.SyncSpaceTimeIllusionInfoFuBenCmd
ProtoReqInfoList[110176] = ProtoReqInfoList.SyncSpaceTimeIllusionExpLevelFuBenCmd
ProtoReqInfoList[110177] = ProtoReqInfoList.STIRefreshUpgradeOptionsCmd
ProtoReqInfoList[110178] = ProtoReqInfoList.STIDropSkillCmd
ProtoReqInfoList[110179] = ProtoReqInfoList.FairyTaleRaidSyncCmd
ProtoReqInfoList[110180] = ProtoReqInfoList.RaidStartFightCmd
ProtoReqInfoList[110182] = ProtoReqInfoList.FairyTaleRaidRewardSyncCmd
ProtoReqInfoList[110183] = ProtoReqInfoList.FairyTaleRaidGetRewardCmd
ProtoReqInfoList[110184] = ProtoReqInfoList.SyncMemoryEquipRewardInfo
ProtoReqInfoList[110185] = ProtoReqInfoList.ChooseMemoryEquipRewardInfo
ProtoReqInfoList[110181] = ProtoReqInfoList.GvgDateBattleInfoSyncCmd
ProtoReqInfoList[500001] = ProtoReqInfoList.QueryGuildListGuildCmd
ProtoReqInfoList[500002] = ProtoReqInfoList.CreateGuildGuildCmd
ProtoReqInfoList[500003] = ProtoReqInfoList.EnterGuildGuildCmd
ProtoReqInfoList[500004] = ProtoReqInfoList.GuildMemberUpdateGuildCmd
ProtoReqInfoList[500005] = ProtoReqInfoList.GuildApplyUpdateGuildCmd
ProtoReqInfoList[500006] = ProtoReqInfoList.GuildDataUpdateGuildCmd
ProtoReqInfoList[500007] = ProtoReqInfoList.GuildMemberDataUpdateGuildCmd
ProtoReqInfoList[500008] = ProtoReqInfoList.ApplyGuildGuildCmd
ProtoReqInfoList[500009] = ProtoReqInfoList.ProcessApplyGuildCmd
ProtoReqInfoList[500010] = ProtoReqInfoList.InviteMemberGuildCmd
ProtoReqInfoList[500011] = ProtoReqInfoList.ProcessInviteGuildCmd
ProtoReqInfoList[500012] = ProtoReqInfoList.SetGuildOptionGuildCmd
ProtoReqInfoList[500013] = ProtoReqInfoList.KickMemberGuildCmd
ProtoReqInfoList[500014] = ProtoReqInfoList.ChangeJobGuildCmd
ProtoReqInfoList[500015] = ProtoReqInfoList.ExitGuildGuildCmd
ProtoReqInfoList[500016] = ProtoReqInfoList.ExchangeChairGuildCmd
ProtoReqInfoList[500017] = ProtoReqInfoList.DismissGuildCmd
ProtoReqInfoList[500018] = ProtoReqInfoList.LevelupGuildCmd
ProtoReqInfoList[500019] = ProtoReqInfoList.DonateGuildCmd
ProtoReqInfoList[500025] = ProtoReqInfoList.DonateListGuildCmd
ProtoReqInfoList[500026] = ProtoReqInfoList.UpdateDonateItemGuildCmd
ProtoReqInfoList[500027] = ProtoReqInfoList.DonateFrameGuildCmd
ProtoReqInfoList[500020] = ProtoReqInfoList.EnterTerritoryGuildCmd
ProtoReqInfoList[500021] = ProtoReqInfoList.PrayGuildCmd
ProtoReqInfoList[500022] = ProtoReqInfoList.GuildInfoNtf
ProtoReqInfoList[500023] = ProtoReqInfoList.GuildPrayNtfGuildCmd
ProtoReqInfoList[500024] = ProtoReqInfoList.LevelupEffectGuildCmd
ProtoReqInfoList[500028] = ProtoReqInfoList.QueryPackGuildCmd
ProtoReqInfoList[500032] = ProtoReqInfoList.PackUpdateGuildCmd
ProtoReqInfoList[500029] = ProtoReqInfoList.ExchangeZoneGuildCmd
ProtoReqInfoList[500030] = ProtoReqInfoList.ExchangeZoneNtfGuildCmd
ProtoReqInfoList[500031] = ProtoReqInfoList.ExchangeZoneAnswerGuildCmd
ProtoReqInfoList[500033] = ProtoReqInfoList.QueryEventListGuildCmd
ProtoReqInfoList[500034] = ProtoReqInfoList.NewEventGuildCmd
ProtoReqInfoList[500037] = ProtoReqInfoList.FrameStatusGuildCmd
ProtoReqInfoList[500038] = ProtoReqInfoList.ModifyAuthGuildCmd
ProtoReqInfoList[500039] = ProtoReqInfoList.JobUpdateGuildCmd
ProtoReqInfoList[500040] = ProtoReqInfoList.RenameQueryGuildCmd
ProtoReqInfoList[500041] = ProtoReqInfoList.QueryGuildCityInfoGuildCmd
ProtoReqInfoList[500042] = ProtoReqInfoList.CityActionGuildCmd
ProtoReqInfoList[500043] = ProtoReqInfoList.GuildIconSyncGuildCmd
ProtoReqInfoList[500044] = ProtoReqInfoList.GuildIconAddGuildCmd
ProtoReqInfoList[500045] = ProtoReqInfoList.GuildIconUploadGuildCmd
ProtoReqInfoList[500047] = ProtoReqInfoList.OpenFunctionGuildCmd
ProtoReqInfoList[500048] = ProtoReqInfoList.BuildGuildCmd
ProtoReqInfoList[500049] = ProtoReqInfoList.SubmitMaterialGuildCmd
ProtoReqInfoList[500050] = ProtoReqInfoList.BuildingNtfGuildCmd
ProtoReqInfoList[500051] = ProtoReqInfoList.BuildingSubmitCountGuildCmd
ProtoReqInfoList[500052] = ProtoReqInfoList.ChallengeUpdateNtfGuildCmd
ProtoReqInfoList[500053] = ProtoReqInfoList.WelfareNtfGuildCmd
ProtoReqInfoList[500054] = ProtoReqInfoList.GetWelfareGuildCmd
ProtoReqInfoList[500055] = ProtoReqInfoList.BuildingLvupEffGuildCmd
ProtoReqInfoList[500056] = ProtoReqInfoList.ArtifactUpdateNtfGuildCmd
ProtoReqInfoList[500057] = ProtoReqInfoList.ArtifactProduceGuildCmd
ProtoReqInfoList[500058] = ProtoReqInfoList.ArtifactOptGuildCmd
ProtoReqInfoList[500059] = ProtoReqInfoList.QueryGQuestGuildCmd
ProtoReqInfoList[500060] = ProtoReqInfoList.TreasureActionGuildCmd
ProtoReqInfoList[500061] = ProtoReqInfoList.QueryBuildingRankGuildCmd
ProtoReqInfoList[500062] = ProtoReqInfoList.QueryTreasureResultGuildCmd
ProtoReqInfoList[500063] = ProtoReqInfoList.QueryGCityShowInfoGuildCmd
ProtoReqInfoList[500064] = ProtoReqInfoList.GvgOpenFireGuildCmd
ProtoReqInfoList[500066] = ProtoReqInfoList.EnterPunishTimeNtfGuildCmd
ProtoReqInfoList[500067] = ProtoReqInfoList.QuerySuperGvgDataGuildCmd
ProtoReqInfoList[500068] = ProtoReqInfoList.QueryGvgGuildInfoGuildCmd
ProtoReqInfoList[500069] = ProtoReqInfoList.GvgRewardNtfGuildCmd
ProtoReqInfoList[500070] = ProtoReqInfoList.GetGvgRewardGuildCmd
ProtoReqInfoList[500071] = ProtoReqInfoList.QueryCheckInfoGuildCmd
ProtoReqInfoList[500072] = ProtoReqInfoList.QueryBifrostRankGuildCmd
ProtoReqInfoList[500073] = ProtoReqInfoList.QueryMemberBifrostInfoGuildCmd
ProtoReqInfoList[500074] = ProtoReqInfoList.QueryGuildInfoGuildCmd
ProtoReqInfoList[500075] = ProtoReqInfoList.QueryGvgZoneGroupGuildCCmd
ProtoReqInfoList[500076] = ProtoReqInfoList.UpdateMapCityGuildCmd
ProtoReqInfoList[500077] = ProtoReqInfoList.GvgRankInfoQueryGuildCmd
ProtoReqInfoList[500078] = ProtoReqInfoList.GvgRankInfoRetGuildCmd
ProtoReqInfoList[500079] = ProtoReqInfoList.GvgRankHistroyQueryGuildCmd
ProtoReqInfoList[500080] = ProtoReqInfoList.GvgRankHistroyRetGuildCmd
ProtoReqInfoList[500081] = ProtoReqInfoList.GvgSmallMetalCntGuildCmd
ProtoReqInfoList[500084] = ProtoReqInfoList.GvgTaskUpdateGuildCmd
ProtoReqInfoList[500088] = ProtoReqInfoList.GvgStatueSyncGuildCmd
ProtoReqInfoList[500082] = ProtoReqInfoList.GvgCookingCmd
ProtoReqInfoList[500083] = ProtoReqInfoList.GvgCookingUpdateCmd
ProtoReqInfoList[500089] = ProtoReqInfoList.GvgScoreInfoUpdateGuildCmd
ProtoReqInfoList[500090] = ProtoReqInfoList.GvgSettleReqGuildCmd
ProtoReqInfoList[500091] = ProtoReqInfoList.GvgSettleInfoGuildCmd
ProtoReqInfoList[500092] = ProtoReqInfoList.GvgSettleSelectGuildCmd
ProtoReqInfoList[500093] = ProtoReqInfoList.GvgReqEnterCityGuildCmd
ProtoReqInfoList[500094] = ProtoReqInfoList.GvgFireReportGuildCmd
ProtoReqInfoList[500095] = ProtoReqInfoList.BuildingUpdateNtfGuildCmd
ProtoReqInfoList[500096] = ProtoReqInfoList.GvgRoadblockModifyGuildCmd
ProtoReqInfoList[500097] = ProtoReqInfoList.GvgRoadblockQueryGuildCmd
ProtoReqInfoList[500098] = ProtoReqInfoList.ExchangeGvgGroupGuildCmd
ProtoReqInfoList[500112] = ProtoReqInfoList.GvgDataQueryGuildCmd
ProtoReqInfoList[500099] = ProtoReqInfoList.DateBattleInfoGuildCmd
ProtoReqInfoList[500100] = ProtoReqInfoList.DateBattleTargetGuildCmd
ProtoReqInfoList[500101] = ProtoReqInfoList.DateBattleInviteGuildCmd
ProtoReqInfoList[500102] = ProtoReqInfoList.DateBattleReplyGuildCmd
ProtoReqInfoList[500103] = ProtoReqInfoList.DateBattleOpenGuildCmd
ProtoReqInfoList[500104] = ProtoReqInfoList.DateBattleEnterGuildCmd
ProtoReqInfoList[500105] = ProtoReqInfoList.DateBattleReportGuildCmd
ProtoReqInfoList[500106] = ProtoReqInfoList.DateBattleDetailGuildCmd
ProtoReqInfoList[500107] = ProtoReqInfoList.DateBattleListGuildCmd
ProtoReqInfoList[500108] = ProtoReqInfoList.DateBattleRankGuildCmd
ProtoReqInfoList[500109] = ProtoReqInfoList.RedtipOptGuildCmd
ProtoReqInfoList[500110] = ProtoReqInfoList.RedtipBrowseGuildCmd
ProtoReqInfoList[500111] = ProtoReqInfoList.DateBattleFlagGuildCmd
ProtoReqInfoList[500113] = ProtoReqInfoList.DateBattleReportUIStateCmd
ProtoReqInfoList[500115] = ProtoReqInfoList.GvgCityStatueQueryGuildCmd
ProtoReqInfoList[500116] = ProtoReqInfoList.GvgCityStatueUpdateGuildCmd
ProtoReqInfoList[500114] = ProtoReqInfoList.QuerySuperGvgStatCmd
ProtoReqInfoList[1] = ProtoReqInfoList.HouseOpt
ProtoReqInfoList[700001] = ProtoReqInfoList.QueryFurnitureDataHomeCmd
ProtoReqInfoList[700002] = ProtoReqInfoList.FurnitureActionHomeCmd
ProtoReqInfoList[700003] = ProtoReqInfoList.FurnitureOperHomeCmd
ProtoReqInfoList[700004] = ProtoReqInfoList.FurnitureUpdateHomeCmd
ProtoReqInfoList[700005] = ProtoReqInfoList.FurnitureDataUpdateHomeCmd
ProtoReqInfoList[700006] = ProtoReqInfoList.HouseActionHomeCmd
ProtoReqInfoList[700007] = ProtoReqInfoList.HouseDataUpdateHomeCmd
ProtoReqInfoList[700009] = ProtoReqInfoList.PetFurnitureActionhomeCmd
ProtoReqInfoList[700010] = ProtoReqInfoList.PrayHomeCmd
ProtoReqInfoList[700011] = ProtoReqInfoList.EnterHomeCmd
ProtoReqInfoList[700012] = ProtoReqInfoList.QueryHouseDataHomeCmd
ProtoReqInfoList[700021] = ProtoReqInfoList.QueryHouseFurnitureHomeCmd
ProtoReqInfoList[700013] = ProtoReqInfoList.OptUpdateHomeCmd
ProtoReqInfoList[700014] = ProtoReqInfoList.PrintActionHomeCmd
ProtoReqInfoList[700015] = ProtoReqInfoList.PrintUpdateHomeCmd
ProtoReqInfoList[700016] = ProtoReqInfoList.BoardItemQueryHomeCmd
ProtoReqInfoList[700017] = ProtoReqInfoList.BoardItemUpdateHomeCmd
ProtoReqInfoList[700018] = ProtoReqInfoList.BoardMsgUpdateHomeCmd
ProtoReqInfoList[700019] = ProtoReqInfoList.EventItemQueryHomeCmd
ProtoReqInfoList[700020] = ProtoReqInfoList.QueryWoodRankHomeCmd
ProtoReqInfoList[200001] = ProtoReqInfoList.TeamTowerInfoCmd
ProtoReqInfoList[200002] = ProtoReqInfoList.TeamTowerSummaryCmd
ProtoReqInfoList[200003] = ProtoReqInfoList.TeamTowerInviteCmd
ProtoReqInfoList[200004] = ProtoReqInfoList.TeamTowerReplyCmd
ProtoReqInfoList[200005] = ProtoReqInfoList.EnterTower
ProtoReqInfoList[200007] = ProtoReqInfoList.UserTowerInfoCmd
ProtoReqInfoList[200008] = ProtoReqInfoList.TowerLayerSyncTowerCmd
ProtoReqInfoList[200010] = ProtoReqInfoList.TowerInfoCmd
ProtoReqInfoList[200009] = ProtoReqInfoList.NewEverLayerTowerCmd
ProtoReqInfoList[200011] = ProtoReqInfoList.TowerLaunchCmd
ProtoReqInfoList[2170001] = ProtoReqInfoList.AddMountInterCmd
ProtoReqInfoList[2170002] = ProtoReqInfoList.DelMountInterCmd
ProtoReqInfoList[2170003] = ProtoReqInfoList.ConfirmMountInterCmd
ProtoReqInfoList[2170004] = ProtoReqInfoList.CancelMountInterCmd
ProtoReqInfoList[2170005] = ProtoReqInfoList.AddMoveMountInterCmd
ProtoReqInfoList[2170006] = ProtoReqInfoList.DelMoveMountInterCmd
ProtoReqInfoList[2170007] = ProtoReqInfoList.ConfirmMoveMountInterCmd
ProtoReqInfoList[2170008] = ProtoReqInfoList.CancelMoveMountInterCmd
ProtoReqInfoList[2170010] = ProtoReqInfoList.UpdateTrainStateInterCmd
ProtoReqInfoList[2170009] = ProtoReqInfoList.TrainUserSyncInterCmd
ProtoReqInfoList[2170011] = ProtoReqInfoList.PosUpdateInterCmd
ProtoReqInfoList[2170012] = ProtoReqInfoList.InteractNpcActionInterCmd
ProtoReqInfoList[10004] = ProtoReqInfoList.RegResultUserCmd
ProtoReqInfoList[10005] = ProtoReqInfoList.CreateCharUserCmd
ProtoReqInfoList[10006] = ProtoReqInfoList.SnapShotUserCmd
ProtoReqInfoList[10007] = ProtoReqInfoList.SelectRoleUserCmd
ProtoReqInfoList[10008] = ProtoReqInfoList.LoginResultUserCmd
ProtoReqInfoList[10009] = ProtoReqInfoList.DeleteCharUserCmd
ProtoReqInfoList[10010] = ProtoReqInfoList.HeartBeatUserCmd
ProtoReqInfoList[10011] = ProtoReqInfoList.ServerTimeUserCmd
ProtoReqInfoList[10012] = ProtoReqInfoList.GMDeleteCharUserCmd
ProtoReqInfoList[10013] = ProtoReqInfoList.ClientInfoUserCmd
ProtoReqInfoList[10014] = ProtoReqInfoList.ReqLoginUserCmd
ProtoReqInfoList[10015] = ProtoReqInfoList.ReqLoginParamUserCmd
ProtoReqInfoList[10016] = ProtoReqInfoList.KickParamUserCmd
ProtoReqInfoList[10017] = ProtoReqInfoList.CancelDeleteCharUserCmd
ProtoReqInfoList[10018] = ProtoReqInfoList.ClientFrameUserCmd
ProtoReqInfoList[10019] = ProtoReqInfoList.SafeDeviceUserCmd
ProtoReqInfoList[10020] = ProtoReqInfoList.ConfirmAuthorizeUserCmd
ProtoReqInfoList[10021] = ProtoReqInfoList.SyncAuthorizeGateCmd
ProtoReqInfoList[10022] = ProtoReqInfoList.RealAuthorizeUserCmd
ProtoReqInfoList[10023] = ProtoReqInfoList.RealAuthorizeServerCmd
ProtoReqInfoList[10024] = ProtoReqInfoList.RefreshZoneIDUserCmd
ProtoReqInfoList[10025] = ProtoReqInfoList.QueryAfkStatUserCmd
ProtoReqInfoList[10026] = ProtoReqInfoList.KickCharUserCmd
ProtoReqInfoList[10027] = ProtoReqInfoList.OfflineDetectUserCmd
ProtoReqInfoList[10028] = ProtoReqInfoList.DeviceInfoUserCmd
ProtoReqInfoList[10029] = ProtoReqInfoList.AttachLoginUserCmd
ProtoReqInfoList[10030] = ProtoReqInfoList.AttachSyncCmdUserCmd
ProtoReqInfoList[10031] = ProtoReqInfoList.PingUserCmd
ProtoReqInfoList[10033] = ProtoReqInfoList.SetMaxScopeUserCmd
ProtoReqInfoList[610001] = ProtoReqInfoList.ReqMyRoomMatchCCmd
ProtoReqInfoList[610002] = ProtoReqInfoList.ReqRoomListCCmd
ProtoReqInfoList[610003] = ProtoReqInfoList.ReqRoomDetailCCmd
ProtoReqInfoList[1] = ProtoReqInfoList.JoinRoomAbyssOption
ProtoReqInfoList[610004] = ProtoReqInfoList.JoinRoomCCmd
ProtoReqInfoList[610005] = ProtoReqInfoList.LeaveRoomCCmd
ProtoReqInfoList[610007] = ProtoReqInfoList.NtfRoomStateCCmd
ProtoReqInfoList[610008] = ProtoReqInfoList.NtfFightStatCCmd
ProtoReqInfoList[610009] = ProtoReqInfoList.JoinFightingCCmd
ProtoReqInfoList[610010] = ProtoReqInfoList.ComboNotifyCCmd
ProtoReqInfoList[610011] = ProtoReqInfoList.RevChallengeCCmd
ProtoReqInfoList[610012] = ProtoReqInfoList.KickTeamCCmd
ProtoReqInfoList[610013] = ProtoReqInfoList.FightConfirmCCmd
ProtoReqInfoList[610014] = ProtoReqInfoList.PvpResultCCmd
ProtoReqInfoList[610015] = ProtoReqInfoList.PvpTeamMemberUpdateCCmd
ProtoReqInfoList[610016] = ProtoReqInfoList.PvpMemberDataUpdateCCmd
ProtoReqInfoList[610017] = ProtoReqInfoList.NtfMatchInfoCCmd
ProtoReqInfoList[610018] = ProtoReqInfoList.GodEndTimeCCmd
ProtoReqInfoList[610019] = ProtoReqInfoList.NtfRankChangeCCmd
ProtoReqInfoList[610020] = ProtoReqInfoList.OpenGlobalShopPanelCCmd
ProtoReqInfoList[610021] = ProtoReqInfoList.TutorMatchResultNtfMatchCCmd
ProtoReqInfoList[610022] = ProtoReqInfoList.TutorMatchResponseMatchCCmd
ProtoReqInfoList[610023] = ProtoReqInfoList.TeamPwsPreInfoMatchCCmd
ProtoReqInfoList[610024] = ProtoReqInfoList.UpdatePreInfoMatchCCmd
ProtoReqInfoList[610025] = ProtoReqInfoList.QueryTeamPwsRankMatchCCmd
ProtoReqInfoList[5] = ProtoReqInfoList.TeamPwsUserInfo
ProtoReqInfoList[610026] = ProtoReqInfoList.QueryTeamPwsTeamInfoMatchCCmd
ProtoReqInfoList[610027] = ProtoReqInfoList.QueryMenrocoRankMatchCCmd
ProtoReqInfoList[610028] = ProtoReqInfoList.MidMatchPrepareMatchCCmd
ProtoReqInfoList[610029] = ProtoReqInfoList.QueryBattlePassRankMatchCCmd
ProtoReqInfoList[610030] = ProtoReqInfoList.TwelvePvpPreInfoMatchCCmd
ProtoReqInfoList[610031] = ProtoReqInfoList.TwelvePvpUpdatePreInfoMatchCCmd
ProtoReqInfoList[610043] = ProtoReqInfoList.TwelveWarbandQueryMatchCCmd
ProtoReqInfoList[610032] = ProtoReqInfoList.TwelveWarbandSortMatchCCmd
ProtoReqInfoList[610033] = ProtoReqInfoList.TwelveWarbandTreeMatchCCmd
ProtoReqInfoList[610034] = ProtoReqInfoList.TwelveWarbandInfoMatchCCmd
ProtoReqInfoList[610035] = ProtoReqInfoList.TwelveWarbandInviterMatchCCmd
ProtoReqInfoList[610036] = ProtoReqInfoList.TwelveWarbandInviteeMatchCCmd
ProtoReqInfoList[610037] = ProtoReqInfoList.TwelveWarbandPrepareMatchCCmd
ProtoReqInfoList[610038] = ProtoReqInfoList.TwelveWarbandLeaveMatchCCmd
ProtoReqInfoList[610039] = ProtoReqInfoList.TwelveWarbandDeleteMatchCCmd
ProtoReqInfoList[610040] = ProtoReqInfoList.TwelveWarbandNameMatchCCmd
ProtoReqInfoList[610041] = ProtoReqInfoList.TwelveWarbandSignUpMatchCCmd
ProtoReqInfoList[610042] = ProtoReqInfoList.TwelveWarbandMatchMatchCCmd
ProtoReqInfoList[610044] = ProtoReqInfoList.TwelveWarbandTeamListMatchCCmd
ProtoReqInfoList[610045] = ProtoReqInfoList.TwelveWarbandCreateMatchCCmd
ProtoReqInfoList[610046] = ProtoReqInfoList.SyncMatchInfoCCmd
ProtoReqInfoList[610047] = ProtoReqInfoList.QueryTwelveSeasonInfoMatchCCmd
ProtoReqInfoList[610048] = ProtoReqInfoList.QueryTwelveSeasonFinishMatchCCmd
ProtoReqInfoList[610049] = ProtoReqInfoList.SyncMatchBoardOpenStateMatchCCmd
ProtoReqInfoList[610050] = ProtoReqInfoList.TwelveSeasonTimeInfoMatchCCmd
ProtoReqInfoList[610051] = ProtoReqInfoList.EnterObservationMatchCCmd
ProtoReqInfoList[610052] = ProtoReqInfoList.ObInitInfoFubenCmd
ProtoReqInfoList[610053] = ProtoReqInfoList.ReserveRoomBuildMatchCCmd
ProtoReqInfoList[610054] = ProtoReqInfoList.ReserveRoomInviterMatchCCmd
ProtoReqInfoList[610055] = ProtoReqInfoList.ReserveRoomInviteeMatchCCmd
ProtoReqInfoList[610056] = ProtoReqInfoList.ReserveRoomKickMatchCCmd
ProtoReqInfoList[610057] = ProtoReqInfoList.ReserveRoomLeaveMatchCCmd
ProtoReqInfoList[610058] = ProtoReqInfoList.ReserveRoomApplyMatchCCmd
ProtoReqInfoList[610059] = ProtoReqInfoList.ReserveRoomInfoMatchCCmd
ProtoReqInfoList[610060] = ProtoReqInfoList.ReserveRoomListMatchCCmd
ProtoReqInfoList[610061] = ProtoReqInfoList.ReserveRoomStartMatchCCmd
ProtoReqInfoList[610062] = ProtoReqInfoList.ReserveRoomChangeMatchCCmd
ProtoReqInfoList[610063] = ProtoReqInfoList.ReserveRoomPrepareMatchCCmd
ProtoReqInfoList[610064] = ProtoReqInfoList.JoinRaidWithRobotMatchCCmd
ProtoReqInfoList[610065] = ProtoReqInfoList.DesertWolfStatQueryCmd
ProtoReqInfoList[610066] = ProtoReqInfoList.DesertWolfRuleSyncCmd
ProtoReqInfoList[610067] = ProtoReqInfoList.QueryTriplePwsRankMatchCCmd
ProtoReqInfoList[610068] = ProtoReqInfoList.QueryTriplePwsTeamInfoMatchCCmd
ProtoReqInfoList[610069] = ProtoReqInfoList.TriplePvpQuestQueryCmd
ProtoReqInfoList[610070] = ProtoReqInfoList.SyncMatchHeadInfoMatchCCmd
ProtoReqInfoList[610071] = ProtoReqInfoList.TriplePvpPickRewardCmd
ProtoReqInfoList[610072] = ProtoReqInfoList.TriplePvpRewardStatusCmd
ProtoReqInfoList[610073] = ProtoReqInfoList.ChampionPvpPickRewardCmd
ProtoReqInfoList[610074] = ProtoReqInfoList.ChampionPvpRewardStatusCmd
ProtoReqInfoList[610075] = ProtoReqInfoList.AbyssRoomStateNtfMatchCCmd
ProtoReqInfoList[830001] = ProtoReqInfoList.ChooseNewProfessionMessCCmd
ProtoReqInfoList[830002] = ProtoReqInfoList.InviterSendLoveConfessionMessCCmd
ProtoReqInfoList[830003] = ProtoReqInfoList.InviteeReceiveLoveConfessionMessCCmd
ProtoReqInfoList[830004] = ProtoReqInfoList.InviteeProcessLoveConfessionMessCCmd
ProtoReqInfoList[830005] = ProtoReqInfoList.InviterReceiveConfessionMessCCmd
ProtoReqInfoList[830006] = ProtoReqInfoList.FingerGuessLoveConfessionMessCCmd
ProtoReqInfoList[830007] = ProtoReqInfoList.FingerLoseLoveConfessionMessCCmd
ProtoReqInfoList[830008] = ProtoReqInfoList.InviterResultLoveConfessionMessCCmd
ProtoReqInfoList[830009] = ProtoReqInfoList.SyncMapStepForeverRewardInfo
ProtoReqInfoList[830010] = ProtoReqInfoList.BalanceModeChooseMessCCmd
ProtoReqInfoList[830011] = ProtoReqInfoList.SetPippiStateMessCCmd
ProtoReqInfoList[830012] = ProtoReqInfoList.SyncDestinyGraphMessCCmd
ProtoReqInfoList[830013] = ProtoReqInfoList.LightenDestinyGraphMessCCmd
ProtoReqInfoList[830014] = ProtoReqInfoList.AstralRewardMessCCmd
ProtoReqInfoList[830015] = ProtoReqInfoList.PurifyProductsMaterialsMessCCmd
ProtoReqInfoList[830016] = ProtoReqInfoList.PurifyProductsRefineMessCCmd
ProtoReqInfoList[830017] = ProtoReqInfoList.AstralSyncSeasonInfoMessCCmd
ProtoReqInfoList[830018] = ProtoReqInfoList.SetPvpChampionStatueMessCCmd
ProtoReqInfoList[830019] = ProtoReqInfoList.SyncQuickPassItemInfoMessCCmd
ProtoReqInfoList[830020] = ProtoReqInfoList.SyncPvpChampionStatueMessCCmd
ProtoReqInfoList[830021] = ProtoReqInfoList.SyncForbidCardsMessCCmd
ProtoReqInfoList[2230001] = ProtoReqInfoList.MiniGameNtfMonsterShot
ProtoReqInfoList[2230002] = ProtoReqInfoList.MiniGameMonsterShotAction
ProtoReqInfoList[2230009] = ProtoReqInfoList.MiniGameNtfMonsterAnswer
ProtoReqInfoList[2230010] = ProtoReqInfoList.MiniGameSubmitMonsterAnswer
ProtoReqInfoList[2230013] = ProtoReqInfoList.MiniGameAction
ProtoReqInfoList[2230014] = ProtoReqInfoList.MiniGameNextRound
ProtoReqInfoList[2230011] = ProtoReqInfoList.MiniGameUnlockList
ProtoReqInfoList[2230015] = ProtoReqInfoList.MiniGameNtfGameOverCmd
ProtoReqInfoList[2230016] = ProtoReqInfoList.MiniGameReqOver
ProtoReqInfoList[2230017] = ProtoReqInfoList.MiniGameUseAssist
ProtoReqInfoList[2230018] = ProtoReqInfoList.MiniGameNtfRoundOver
ProtoReqInfoList[2230019] = ProtoReqInfoList.MiniGameQueryRank
ProtoReqInfoList[770001] = ProtoReqInfoList.NoviceBPTargetUpdateCmd
ProtoReqInfoList[770002] = ProtoReqInfoList.NoviceBPRewardUpdateCmd
ProtoReqInfoList[770003] = ProtoReqInfoList.NoviceBPTargetRewardCmd
ProtoReqInfoList[770004] = ProtoReqInfoList.NoviceBpBuyLevelCmd
ProtoReqInfoList[770005] = ProtoReqInfoList.ChallengeTargetUpdateCmd
ProtoReqInfoList[770006] = ProtoReqInfoList.ReturnBpTargetUpdateCmd
ProtoReqInfoList[770007] = ProtoReqInfoList.ReturnBPRewardUpdateCmd
ProtoReqInfoList[770008] = ProtoReqInfoList.ReturnBPTargetRewardCmd
ProtoReqInfoList[770009] = ProtoReqInfoList.ReturnBPReturnRewardCmd
ProtoReqInfoList[770010] = ProtoReqInfoList.ReturnBpBuyLevelCmd
ProtoReqInfoList[2310005] = ProtoReqInfoList.NoviceNotebookLastPosCmd
ProtoReqInfoList[2310001] = ProtoReqInfoList.NoviceNotebookCmd
ProtoReqInfoList[2310002] = ProtoReqInfoList.NoviceNotebookCoverOpenCmd
ProtoReqInfoList[2310003] = ProtoReqInfoList.NoviceNotebookReadPageCmd
ProtoReqInfoList[2310004] = ProtoReqInfoList.NoviceNotebookReceiveAwardCmd
ProtoReqInfoList[800001] = ProtoReqInfoList.TaiwanFbLikeProgressCmd
ProtoReqInfoList[800002] = ProtoReqInfoList.TaiwanFbLikeUserRedeemCmd
ProtoReqInfoList[810001] = ProtoReqInfoList.OverseasPhotoUploadCmd
ProtoReqInfoList[810002] = ProtoReqInfoList.OverseasPhotoPathPrefixCmd
ProtoReqInfoList[800010] = ProtoReqInfoList.TaiwanFbShareProgressCmd
ProtoReqInfoList[800011] = ProtoReqInfoList.TaiwanFbShareRedeemCmd
ProtoReqInfoList[800099] = ProtoReqInfoList.TaiwanMagicLiziCmd
ProtoReqInfoList[800021] = ProtoReqInfoList.TaiwanRankLisaCmd
ProtoReqInfoList[810011] = ProtoReqInfoList.OverseasChargeLimitGetChargeCmd
ProtoReqInfoList[810021] = ProtoReqInfoList.OverseasGoeItemAddCmd
ProtoReqInfoList[810022] = ProtoReqInfoList.OverseasGoeItemUseCmd
ProtoReqInfoList[810023] = ProtoReqInfoList.OverseasGoePurchaseCmd
ProtoReqInfoList[810024] = ProtoReqInfoList.FirebaseNotifyUpdateCmd
ProtoReqInfoList[300001] = ProtoReqInfoList.PhotoQueryListCmd
ProtoReqInfoList[300002] = ProtoReqInfoList.PhotoOptCmd
ProtoReqInfoList[300003] = ProtoReqInfoList.PhotoUpdateNtf
ProtoReqInfoList[300004] = ProtoReqInfoList.FrameActionPhotoCmd
ProtoReqInfoList[300005] = ProtoReqInfoList.QueryFramePhotoListPhotoCmd
ProtoReqInfoList[300006] = ProtoReqInfoList.QueryUserPhotoListPhotoCmd
ProtoReqInfoList[300007] = ProtoReqInfoList.UpdateFrameShowPhotoCmd
ProtoReqInfoList[300008] = ProtoReqInfoList.FramePhotoUpdatePhotoCmd
ProtoReqInfoList[300009] = ProtoReqInfoList.QueryMd5ListPhotoCmd
ProtoReqInfoList[300010] = ProtoReqInfoList.AddMd5PhotoCmd
ProtoReqInfoList[300011] = ProtoReqInfoList.RemoveMd5PhotoCmd
ProtoReqInfoList[300012] = ProtoReqInfoList.QueryUrlPhotoCmd
ProtoReqInfoList[300013] = ProtoReqInfoList.QueryUploadInfoPhotoCmd
ProtoReqInfoList[300014] = ProtoReqInfoList.BoardBaseInfoPhotoCmd
ProtoReqInfoList[300015] = ProtoReqInfoList.BoardTopicPhotoCmd
ProtoReqInfoList[300016] = ProtoReqInfoList.BoardRotateListPhotoCmd
ProtoReqInfoList[300017] = ProtoReqInfoList.BoardListPhotoCmd
ProtoReqInfoList[300018] = ProtoReqInfoList.BoardMyListPhotoCmd
ProtoReqInfoList[300019] = ProtoReqInfoList.BoardQueryDetailPhotoCmd
ProtoReqInfoList[300020] = ProtoReqInfoList.BoardQueryDataPhotoCmd
ProtoReqInfoList[300021] = ProtoReqInfoList.BoardAwardListPhotoCmd
ProtoReqInfoList[300022] = ProtoReqInfoList.BoardLikePhotoCmd
ProtoReqInfoList[300023] = ProtoReqInfoList.BoardAwardPhotoCmd
ProtoReqInfoList[300024] = ProtoReqInfoList.BoardGetAwardPhotoCmd
ProtoReqInfoList[300025] = ProtoReqInfoList.BoardOpenPhotoCmd
ProtoReqInfoList[300026] = ProtoReqInfoList.SendPostcardCmd
ProtoReqInfoList[300027] = ProtoReqInfoList.PostcardListCmd
ProtoReqInfoList[300028] = ProtoReqInfoList.SavePostcardCmd
ProtoReqInfoList[300029] = ProtoReqInfoList.UpdatePostcardCmd
ProtoReqInfoList[300030] = ProtoReqInfoList.DelPostcardCmd
ProtoReqInfoList[300031] = ProtoReqInfoList.ViewPostcardCmd
ProtoReqInfoList[300032] = ProtoReqInfoList.BoardQueryAwardPhotoCmd
ProtoReqInfoList[680001] = ProtoReqInfoList.QueryActPuzzleCmd
ProtoReqInfoList[680003] = ProtoReqInfoList.PuzzleItemNtf
ProtoReqInfoList[680004] = ProtoReqInfoList.ActivePuzzleCmd
ProtoReqInfoList[660001] = ProtoReqInfoList.InvitePveCardCmd
ProtoReqInfoList[660002] = ProtoReqInfoList.ReplyPveCardCmd
ProtoReqInfoList[660003] = ProtoReqInfoList.EnterPveCardCmd
ProtoReqInfoList[660004] = ProtoReqInfoList.QueryCardInfoCmd
ProtoReqInfoList[660005] = ProtoReqInfoList.SelectPveCardCmd
ProtoReqInfoList[660006] = ProtoReqInfoList.SyncProcessPveCardCmd
ProtoReqInfoList[660007] = ProtoReqInfoList.UpdateProcessPveCardCmd
ProtoReqInfoList[660008] = ProtoReqInfoList.BeginFirePveCardCmd
ProtoReqInfoList[660009] = ProtoReqInfoList.FinishPlayCardCmd
ProtoReqInfoList[660010] = ProtoReqInfoList.PlayPveCardCmd
ProtoReqInfoList[660011] = ProtoReqInfoList.GetPveCardRewardCmd
ProtoReqInfoList[780003] = ProtoReqInfoList.QueueEnterRetCmd
ProtoReqInfoList[780004] = ProtoReqInfoList.QueueUpdateCountCmd
ProtoReqInfoList[780001] = ProtoReqInfoList.RequireQueueNotifyCmd
ProtoReqInfoList[780002] = ProtoReqInfoList.ReqQueueEnterCmd
ProtoReqInfoList[760001] = ProtoReqInfoList.QueryRaidPuzzleListRaidCmd
ProtoReqInfoList[760002] = ProtoReqInfoList.RaidPuzzleActionRaidCmd
ProtoReqInfoList[760003] = ProtoReqInfoList.RaidPuzzleDataUpdateRaidCmd
ProtoReqInfoList[760004] = ProtoReqInfoList.RaidPuzzlePushObjRaidCmd
ProtoReqInfoList[760005] = ProtoReqInfoList.RaidPuzzleRotateObjRaidCmd
ProtoReqInfoList[760006] = ProtoReqInfoList.RaidPuzzleObjChangeNtfRaidCmd
ProtoReqInfoList[760007] = ProtoReqInfoList.RaidPuzzleElevatorRaidCmd
ProtoReqInfoList[760008] = ProtoReqInfoList.RaidPuzzlePosRaidCmd
ProtoReqInfoList[760009] = ProtoReqInfoList.RaidPuzzleRoomIconRaidCmd
ProtoReqInfoList[760010] = ProtoReqInfoList.ClientSummonCmd
ProtoReqInfoList[760010] = ProtoReqInfoList.ClientNpcDieCmd
ProtoReqInfoList[760011] = ProtoReqInfoList.ClientTreasureBoxCmd
ProtoReqInfoList[760012] = ProtoReqInfoList.ClientSaveCmd
ProtoReqInfoList[760013] = ProtoReqInfoList.ClientSaveResultCmd
ProtoReqInfoList[760014] = ProtoReqInfoList.ClientQueryRaidCmd
ProtoReqInfoList[760015] = ProtoReqInfoList.PersonalRaidEnterCmd
ProtoReqInfoList[760016] = ProtoReqInfoList.ClientRaidAchRewardCmd
ProtoReqInfoList[760017] = ProtoReqInfoList.HeadwearActivityNpcUserCmd
ProtoReqInfoList[760018] = ProtoReqInfoList.HeadwearActivityRoundUserCmd
ProtoReqInfoList[760019] = ProtoReqInfoList.HeadwearActivityTowerUserCmd
ProtoReqInfoList[760024] = ProtoReqInfoList.QueryHeadwearActivityRewardRecordCmd
ProtoReqInfoList[760020] = ProtoReqInfoList.HeadwearActivityEndUserCmd
ProtoReqInfoList[760021] = ProtoReqInfoList.HeadwearActivityRangeUserCmd
ProtoReqInfoList[760022] = ProtoReqInfoList.HeadwearActivityOpenUserCmd
ProtoReqInfoList[760025] = ProtoReqInfoList.RaidOptionalCardCmd
ProtoReqInfoList[760026] = ProtoReqInfoList.RaidSelectCardResultCmd
ProtoReqInfoList[760027] = ProtoReqInfoList.RaidSelectCardResultRes
ProtoReqInfoList[760028] = ProtoReqInfoList.RaidSelectCardHistoryResultCmd
ProtoReqInfoList[760029] = ProtoReqInfoList.RaidSelectCardResetCmd
ProtoReqInfoList[760030] = ProtoReqInfoList.RaidNewResetCmd
ProtoReqInfoList[760031] = ProtoReqInfoList.AbyssDragonInfoNtfRaidCmd
ProtoReqInfoList[760032] = ProtoReqInfoList.AbyssDragonHpUpdateRaidCmd
ProtoReqInfoList[760033] = ProtoReqInfoList.AbyssDragonOnOffRaidCmd
ProtoReqInfoList[760034] = ProtoReqInfoList.AbyssDragonDamageRankRaidCmd
ProtoReqInfoList[840001] = ProtoReqInfoList.QueryRecallInfoRecallCmd
ProtoReqInfoList[840002] = ProtoReqInfoList.SignQueryInfoRecallCmd
ProtoReqInfoList[840003] = ProtoReqInfoList.SignInRecallCmd
ProtoReqInfoList[840004] = ProtoReqInfoList.BattlePassQueryInfoRecallCmd
ProtoReqInfoList[840005] = ProtoReqInfoList.BattlePassQuickLvUpRecallCmd
ProtoReqInfoList[840006] = ProtoReqInfoList.GetBattlePassRewardRecallCmd
ProtoReqInfoList[840012] = ProtoReqInfoList.GetAllBattlePassRewardRecallCmd
ProtoReqInfoList[840008] = ProtoReqInfoList.WeeklyTaskQueryInfoRecallCmd
ProtoReqInfoList[840009] = ProtoReqInfoList.WeeklyTaskGetRewardRecallCmd
ProtoReqInfoList[840010] = ProtoReqInfoList.FundQueryInfoRecallCmd
ProtoReqInfoList[840011] = ProtoReqInfoList.FundGetRewardRecallCmd
ProtoReqInfoList[840013] = ProtoReqInfoList.ShopQueryInfoRecallCmd
ProtoReqInfoList[840014] = ProtoReqInfoList.BuyShopGoodRecallCmd
ProtoReqInfoList[840015] = ProtoReqInfoList.CatchUpQueryInfoRecallCmd
ProtoReqInfoList[840016] = ProtoReqInfoList.MvpCardQueryInfoRecallCmd
ProtoReqInfoList[840017] = ProtoReqInfoList.MvpCardSetUpCardRecallCmd
ProtoReqInfoList[840018] = ProtoReqInfoList.MvpCardRandCardRecallCmd
ProtoReqInfoList[1] = ProtoReqInfoList.SearchCond
ProtoReqInfoList[570001] = ProtoReqInfoList.BriefPendingListRecordTradeCmd
ProtoReqInfoList[570003] = ProtoReqInfoList.DetailPendingListRecordTradeCmd
ProtoReqInfoList[570004] = ProtoReqInfoList.ItemSellInfoRecordTradeCmd
ProtoReqInfoList[570007] = ProtoReqInfoList.MyPendingListRecordTradeCmd
ProtoReqInfoList[570009] = ProtoReqInfoList.MyTradeLogRecordTradeCmd
ProtoReqInfoList[570027] = ProtoReqInfoList.TakeLogCmd
ProtoReqInfoList[570028] = ProtoReqInfoList.AddNewLog
ProtoReqInfoList[570029] = ProtoReqInfoList.FetchNameInfoCmd
ProtoReqInfoList[570014] = ProtoReqInfoList.ReqServerPriceRecordTradeCmd
ProtoReqInfoList[570015] = ProtoReqInfoList.BuyItemRecordTradeCmd
ProtoReqInfoList[570020] = ProtoReqInfoList.SellItemRecordTradeCmd
ProtoReqInfoList[570022] = ProtoReqInfoList.CancelItemRecordTrade
ProtoReqInfoList[570023] = ProtoReqInfoList.ResellPendingRecordTrade
ProtoReqInfoList[570024] = ProtoReqInfoList.PanelRecordTrade
ProtoReqInfoList[570025] = ProtoReqInfoList.ListNtfRecordTrade
ProtoReqInfoList[570026] = ProtoReqInfoList.HotItemidRecordTrade
ProtoReqInfoList[570030] = ProtoReqInfoList.NtfCanTakeCountTradeCmd
ProtoReqInfoList[570031] = ProtoReqInfoList.GiveTradeCmd
ProtoReqInfoList[570033] = ProtoReqInfoList.AcceptTradeCmd
ProtoReqInfoList[570034] = ProtoReqInfoList.RefuseTradeCmd
ProtoReqInfoList[570032] = ProtoReqInfoList.ReqGiveItemInfoCmd
ProtoReqInfoList[570035] = ProtoReqInfoList.CheckPackageSizeTradeCmd
ProtoReqInfoList[570036] = ProtoReqInfoList.QucikTakeLogTradeCmd
ProtoReqInfoList[570037] = ProtoReqInfoList.QueryItemCountTradeCmd
ProtoReqInfoList[570038] = ProtoReqInfoList.LotteryGiveCmd
ProtoReqInfoList[570039] = ProtoReqInfoList.TodayFinanceRank
ProtoReqInfoList[570040] = ProtoReqInfoList.TodayFinanceDetail
ProtoReqInfoList[570041] = ProtoReqInfoList.BoothPlayerPendingListCmd
ProtoReqInfoList[570042] = ProtoReqInfoList.UpdateOrderTradeCmd
ProtoReqInfoList[570043] = ProtoReqInfoList.TakeAllLogCmd
ProtoReqInfoList[570044] = ProtoReqInfoList.QueryMergePriceRecordTradeCmd
ProtoReqInfoList[570045] = ProtoReqInfoList.QueryItemPriceRecordTradeCmd
ProtoReqInfoList[570046] = ProtoReqInfoList.PreorderQueryPriceRecordTradeCmd
ProtoReqInfoList[570047] = ProtoReqInfoList.PreorderItemRecordTradeCmd
ProtoReqInfoList[570048] = ProtoReqInfoList.PreorderCancelRecordTradeCmd
ProtoReqInfoList[570049] = ProtoReqInfoList.PreorderListRecordTradeCmd
ProtoReqInfoList[570050] = ProtoReqInfoList.QueryHoldedItemCountTradeCmd
ProtoReqInfoList[570051] = ProtoReqInfoList.QuerySelledItemCountTradeCmd
ProtoReqInfoList[570052] = ProtoReqInfoList.RecommendItemTradeCmd
ProtoReqInfoList[710001] = ProtoReqInfoList.RoguelikeInfoCmd
ProtoReqInfoList[710002] = ProtoReqInfoList.RoguelikeInviteCmd
ProtoReqInfoList[710003] = ProtoReqInfoList.RoguelikeReplyCmd
ProtoReqInfoList[710004] = ProtoReqInfoList.RoguelikeCreateCmd
ProtoReqInfoList[710005] = ProtoReqInfoList.RoguelikeEnterCmd
ProtoReqInfoList[710006] = ProtoReqInfoList.RoguelikeArchiveCmd
ProtoReqInfoList[710007] = ProtoReqInfoList.RoguelikeQueryArchiveDataCmd
ProtoReqInfoList[710008] = ProtoReqInfoList.RoguelikeRaidInfoCmd
ProtoReqInfoList[710009] = ProtoReqInfoList.RoguelikeRankInfoCmd
ProtoReqInfoList[710010] = ProtoReqInfoList.RoguelikeQueryBoardCmd
ProtoReqInfoList[710011] = ProtoReqInfoList.RoguelikeSubSceneCmd
ProtoReqInfoList[710012] = ProtoReqInfoList.RoguelikeScoreModelCmd
ProtoReqInfoList[710013] = ProtoReqInfoList.RoguelikeEventNpcCmd
ProtoReqInfoList[710014] = ProtoReqInfoList.RoguelikeShopCmd
ProtoReqInfoList[710015] = ProtoReqInfoList.RoguelikeShopDataCmd
ProtoReqInfoList[710016] = ProtoReqInfoList.RoguelikeUseItemCmd
ProtoReqInfoList[710017] = ProtoReqInfoList.RoguelikeRobotCmd
ProtoReqInfoList[710018] = ProtoReqInfoList.RoguelikeFightInfo
ProtoReqInfoList[710019] = ProtoReqInfoList.RoguelikeWeekReward
ProtoReqInfoList[710020] = ProtoReqInfoList.RoguelikeSettlement
ProtoReqInfoList[710021] = ProtoReqInfoList.RoguelikeGoRoomCmd
ProtoReqInfoList[710022] = ProtoReqInfoList.RogueChargeMagicBottle
ProtoReqInfoList[710023] = ProtoReqInfoList.RogueTarotOperateCmd
ProtoReqInfoList[710024] = ProtoReqInfoList.RogueTarotInfoCmd
ProtoReqInfoList[710025] = ProtoReqInfoList.TeamQueryRogueArchiveSCmd
ProtoReqInfoList[270001] = ProtoReqInfoList.AuguryInvite
ProtoReqInfoList[270002] = ProtoReqInfoList.AuguryInviteReply
ProtoReqInfoList[270003] = ProtoReqInfoList.AuguryChat
ProtoReqInfoList[270004] = ProtoReqInfoList.AuguryTitle
ProtoReqInfoList[270005] = ProtoReqInfoList.AuguryAnswer
ProtoReqInfoList[270006] = ProtoReqInfoList.AuguryQuit
ProtoReqInfoList[270007] = ProtoReqInfoList.AuguryAstrologyDrawCard
ProtoReqInfoList[270008] = ProtoReqInfoList.AuguryAstrologyInfo
ProtoReqInfoList[320001] = ProtoReqInfoList.BeingSkillQuery
ProtoReqInfoList[320002] = ProtoReqInfoList.BeingSkillUpdate
ProtoReqInfoList[320003] = ProtoReqInfoList.BeingSkillLevelUp
ProtoReqInfoList[320004] = ProtoReqInfoList.BeingInfoQuery
ProtoReqInfoList[320005] = ProtoReqInfoList.BeingInfoUpdate
ProtoReqInfoList[320007] = ProtoReqInfoList.BeingSwitchState
ProtoReqInfoList[320006] = ProtoReqInfoList.BeingOffCmd
ProtoReqInfoList[320008] = ProtoReqInfoList.ChangeBodyBeingCmd
ProtoReqInfoList[320009] = ProtoReqInfoList.BeingQueryDataPartial
ProtoReqInfoList[2] = ProtoReqInfoList.ChatRoomMember
ProtoReqInfoList[1] = ProtoReqInfoList.ChatRoomData
ProtoReqInfoList[190001] = ProtoReqInfoList.CreateChatRoom
ProtoReqInfoList[190002] = ProtoReqInfoList.JoinChatRoom
ProtoReqInfoList[190003] = ProtoReqInfoList.ExitChatRoom
ProtoReqInfoList[190004] = ProtoReqInfoList.KickChatMember
ProtoReqInfoList[190005] = ProtoReqInfoList.ExchangeRoomOwner
ProtoReqInfoList[190007] = ProtoReqInfoList.RoomMemberUpdate
ProtoReqInfoList[190006] = ProtoReqInfoList.EnterChatRoom
ProtoReqInfoList[1] = ProtoReqInfoList.ChatRoomSummary
ProtoReqInfoList[190008] = ProtoReqInfoList.ChatRoomDataSync
ProtoReqInfoList[190009] = ProtoReqInfoList.ChatRoomTip
ProtoReqInfoList[290001] = ProtoReqInfoList.CookStateNtf
ProtoReqInfoList[290002] = ProtoReqInfoList.PrepareCook
ProtoReqInfoList[290003] = ProtoReqInfoList.SelectCookType
ProtoReqInfoList[290004] = ProtoReqInfoList.StartCook
ProtoReqInfoList[290005] = ProtoReqInfoList.PutFood
ProtoReqInfoList[290006] = ProtoReqInfoList.EditFoodPower
ProtoReqInfoList[290008] = ProtoReqInfoList.QueryFoodNpcInfo
ProtoReqInfoList[290009] = ProtoReqInfoList.StartEat
ProtoReqInfoList[290010] = ProtoReqInfoList.StopEat
ProtoReqInfoList[290007] = ProtoReqInfoList.EatProgressNtf
ProtoReqInfoList[290011] = ProtoReqInfoList.FoodInfoNtf
ProtoReqInfoList[290016] = ProtoReqInfoList.UpdateFoodInfo
ProtoReqInfoList[290012] = ProtoReqInfoList.UnlockRecipeNtf
ProtoReqInfoList[290013] = ProtoReqInfoList.QueryFoodManualData
ProtoReqInfoList[290014] = ProtoReqInfoList.NewFoodDataNtf
ProtoReqInfoList[290015] = ProtoReqInfoList.ClickFoodManualData
ProtoReqInfoList[220001] = ProtoReqInfoList.NewInter
ProtoReqInfoList[220002] = ProtoReqInfoList.Answer
ProtoReqInfoList[220003] = ProtoReqInfoList.Query
ProtoReqInfoList[220004] = ProtoReqInfoList.QueryPaperResultInterCmd
ProtoReqInfoList[220005] = ProtoReqInfoList.PaperQuestionInterCmd
ProtoReqInfoList[220006] = ProtoReqInfoList.PaperResultInterCmd
ProtoReqInfoList[1] = ProtoReqInfoList.ArtifactData
ProtoReqInfoList[60001] = ProtoReqInfoList.PackageItem
ProtoReqInfoList[60002] = ProtoReqInfoList.PackageUpdate
ProtoReqInfoList[60003] = ProtoReqInfoList.ItemUse
ProtoReqInfoList[60004] = ProtoReqInfoList.PackageSort
ProtoReqInfoList[60005] = ProtoReqInfoList.Equip
ProtoReqInfoList[60006] = ProtoReqInfoList.SellItem
ProtoReqInfoList[60007] = ProtoReqInfoList.EquipStrength
ProtoReqInfoList[60009] = ProtoReqInfoList.Produce
ProtoReqInfoList[60010] = ProtoReqInfoList.ProduceDone
ProtoReqInfoList[60011] = ProtoReqInfoList.EquipRefine
ProtoReqInfoList[60012] = ProtoReqInfoList.EquipDecompose
ProtoReqInfoList[60013] = ProtoReqInfoList.QueryEquipData
ProtoReqInfoList[60014] = ProtoReqInfoList.BrowsePackage
ProtoReqInfoList[60015] = ProtoReqInfoList.EquipCard
ProtoReqInfoList[60016] = ProtoReqInfoList.ItemShow
ProtoReqInfoList[60035] = ProtoReqInfoList.ItemShow64
ProtoReqInfoList[60017] = ProtoReqInfoList.EquipRepair
ProtoReqInfoList[60018] = ProtoReqInfoList.HintNtf
ProtoReqInfoList[60019] = ProtoReqInfoList.EnchantEquip
ProtoReqInfoList[1] = ProtoReqInfoList.TradeItemBaseInfo
ProtoReqInfoList[60122] = ProtoReqInfoList.EnchantRes
ProtoReqInfoList[60020] = ProtoReqInfoList.ProcessEnchantItemCmd
ProtoReqInfoList[60021] = ProtoReqInfoList.EquipExchangeItemCmd
ProtoReqInfoList[60022] = ProtoReqInfoList.OnOffStoreItemCmd
ProtoReqInfoList[60023] = ProtoReqInfoList.PackSlotNtfItemCmd
ProtoReqInfoList[60024] = ProtoReqInfoList.RestoreEquipItemCmd
ProtoReqInfoList[60025] = ProtoReqInfoList.UseCountItemCmd
ProtoReqInfoList[60028] = ProtoReqInfoList.ExchangeCardItemCmd
ProtoReqInfoList[60029] = ProtoReqInfoList.GetCountItemCmd
ProtoReqInfoList[60030] = ProtoReqInfoList.SaveLoveLetterCmd
ProtoReqInfoList[60031] = ProtoReqInfoList.ItemDataShow
ProtoReqInfoList[60032] = ProtoReqInfoList.LotteryCmd
ProtoReqInfoList[60033] = ProtoReqInfoList.LotteryRecoveryCmd
ProtoReqInfoList[60034] = ProtoReqInfoList.QueryLotteryInfo
ProtoReqInfoList[60040] = ProtoReqInfoList.ReqQuotaLogCmd
ProtoReqInfoList[60041] = ProtoReqInfoList.ReqQuotaDetailCmd
ProtoReqInfoList[60042] = ProtoReqInfoList.EquipPosDataUpdate
ProtoReqInfoList[60036] = ProtoReqInfoList.HighRefineMatComposeCmd
ProtoReqInfoList[60037] = ProtoReqInfoList.HighRefineCmd
ProtoReqInfoList[60038] = ProtoReqInfoList.NtfHighRefineDataCmd
ProtoReqInfoList[60039] = ProtoReqInfoList.UpdateHighRefineDataCmd
ProtoReqInfoList[60043] = ProtoReqInfoList.UseCodItemCmd
ProtoReqInfoList[60044] = ProtoReqInfoList.AddJobLevelItemCmd
ProtoReqInfoList[60046] = ProtoReqInfoList.LotterGivBuyCountCmd
ProtoReqInfoList[60047] = ProtoReqInfoList.GiveWeddingDressCmd
ProtoReqInfoList[60048] = ProtoReqInfoList.QuickStoreItemCmd
ProtoReqInfoList[60049] = ProtoReqInfoList.QuickSellItemCmd
ProtoReqInfoList[60050] = ProtoReqInfoList.EnchantTransItemCmd
ProtoReqInfoList[60051] = ProtoReqInfoList.QueryLotteryHeadItemCmd
ProtoReqInfoList[60052] = ProtoReqInfoList.LotteryRateQueryCmd
ProtoReqInfoList[60053] = ProtoReqInfoList.EquipComposeItemCmd
ProtoReqInfoList[60054] = ProtoReqInfoList.QueryDebtItemCmd
ProtoReqInfoList[60057] = ProtoReqInfoList.LotteryActivityNtfCmd
ProtoReqInfoList[60056] = ProtoReqInfoList.FavoriteItemActionItemCmd
ProtoReqInfoList[60059] = ProtoReqInfoList.QueryLotteryExtraBonusItemCmd
ProtoReqInfoList[60120] = ProtoReqInfoList.QueryLotteryExtraBonusCfgCmd
ProtoReqInfoList[60060] = ProtoReqInfoList.GetLotteryExtraBonusItemCmd
ProtoReqInfoList[60058] = ProtoReqInfoList.RollCatLitterBoxItemCmd
ProtoReqInfoList[60063] = ProtoReqInfoList.AlterFashionEquipBuffCmd
ProtoReqInfoList[60061] = ProtoReqInfoList.QueryRideLotteryInfo
ProtoReqInfoList[60062] = ProtoReqInfoList.ExecRideLotteryCmd
ProtoReqInfoList[60064] = ProtoReqInfoList.GemSkillAppraisalItemCmd
ProtoReqInfoList[60065] = ProtoReqInfoList.GemSkillComposeSameItemCmd
ProtoReqInfoList[60066] = ProtoReqInfoList.GemSkillComposeQualityItemCmd
ProtoReqInfoList[60067] = ProtoReqInfoList.GemAttrComposeItemCmd
ProtoReqInfoList[60068] = ProtoReqInfoList.GemAttrUpgradeItemCmd
ProtoReqInfoList[60069] = ProtoReqInfoList.GemMountItemCmd
ProtoReqInfoList[60070] = ProtoReqInfoList.GemUnmountItemCmd
ProtoReqInfoList[60071] = ProtoReqInfoList.GemCarveItemCmd
ProtoReqInfoList[60074] = ProtoReqInfoList.GemSmeltItemCmd
ProtoReqInfoList[60072] = ProtoReqInfoList.RideLotteyPickItemCmd
ProtoReqInfoList[60073] = ProtoReqInfoList.RideLotteyPickInfoCmd
ProtoReqInfoList[60075] = ProtoReqInfoList.SandExchangeItemCmd
ProtoReqInfoList[60076] = ProtoReqInfoList.GemDataUpdateItemCmd
ProtoReqInfoList[60081] = ProtoReqInfoList.LotteryDollQueryItemCmd
ProtoReqInfoList[60082] = ProtoReqInfoList.LotteryDollPayItemCmd
ProtoReqInfoList[60083] = ProtoReqInfoList.PersonalArtifactExchangeItemCmd
ProtoReqInfoList[60084] = ProtoReqInfoList.PersonalArtifactDecomposeItemCmd
ProtoReqInfoList[60085] = ProtoReqInfoList.PersonalArtifactComposeItemCmd
ProtoReqInfoList[60086] = ProtoReqInfoList.PersonalArtifactRemouldItemCmd
ProtoReqInfoList[60087] = ProtoReqInfoList.PersonalArtifactAttrSaveItemCmd
ProtoReqInfoList[60090] = ProtoReqInfoList.PersonalArtifactAppraisalItemCmd
ProtoReqInfoList[60096] = ProtoReqInfoList.EquipPosCDNtfItemCmd
ProtoReqInfoList[60088] = ProtoReqInfoList.BatchRefineItemCmd
ProtoReqInfoList[60091] = ProtoReqInfoList.MixLotteryArchiveCmd
ProtoReqInfoList[60107] = ProtoReqInfoList.QueryPackMailItemCmd
ProtoReqInfoList[60108] = ProtoReqInfoList.PackMailUpdateItemCmd
ProtoReqInfoList[60109] = ProtoReqInfoList.PackMailActionItemCmd
ProtoReqInfoList[60110] = ProtoReqInfoList.FavoriteQueryItemCmd
ProtoReqInfoList[60111] = ProtoReqInfoList.FavoriteGiveItemCmd
ProtoReqInfoList[60112] = ProtoReqInfoList.FavoriteRewardItemCmd
ProtoReqInfoList[60113] = ProtoReqInfoList.FavoriteInteractItemCmd
ProtoReqInfoList[60116] = ProtoReqInfoList.FavoriteDesireConditionItemCmd
ProtoReqInfoList[60097] = ProtoReqInfoList.EquipEnchantTransferItemCmd
ProtoReqInfoList[60098] = ProtoReqInfoList.EquipRefineTransferItemCmd
ProtoReqInfoList[60099] = ProtoReqInfoList.EquipPowerInputItemCmd
ProtoReqInfoList[60100] = ProtoReqInfoList.EquipPowerOutputItemCmd
ProtoReqInfoList[60101] = ProtoReqInfoList.ColoringQueryItemCmd
ProtoReqInfoList[60102] = ProtoReqInfoList.ColoringModifyItemCmd
ProtoReqInfoList[60103] = ProtoReqInfoList.ColoringShareItemCmd
ProtoReqInfoList[60104] = ProtoReqInfoList.PosStrengthItemCmd
ProtoReqInfoList[60115] = ProtoReqInfoList.LotteryHeadwearExchange
ProtoReqInfoList[60106] = ProtoReqInfoList.RandSelectRewardItemCmd
ProtoReqInfoList[60118] = ProtoReqInfoList.EquipRecoveryQueryItemCmd
ProtoReqInfoList[60119] = ProtoReqInfoList.EquipRecoveryItemCmd
ProtoReqInfoList[60114] = ProtoReqInfoList.OneClickPutTakeStoreCmd
ProtoReqInfoList[60117] = ProtoReqInfoList.QuestionResultItemCmd
ProtoReqInfoList[60105] = ProtoReqInfoList.PosStrengthSyncItemCmd
ProtoReqInfoList[60121] = ProtoReqInfoList.EquipPowerQuery
ProtoReqInfoList[60092] = ProtoReqInfoList.MagicSuitSave
ProtoReqInfoList[60094] = ProtoReqInfoList.MagicSuitNtf
ProtoReqInfoList[60093] = ProtoReqInfoList.MagicSuitApply
ProtoReqInfoList[60095] = ProtoReqInfoList.PotionStoreNtf
ProtoReqInfoList[60123] = ProtoReqInfoList.EnchantHighestBuffNotify
ProtoReqInfoList[60124] = ProtoReqInfoList.LotteryDataSyncItemCmd
ProtoReqInfoList[60125] = ProtoReqInfoList.ArtifactFlagmentAdd
ProtoReqInfoList[60127] = ProtoReqInfoList.LotteryDailyRewardSyncItemCmd
ProtoReqInfoList[60128] = ProtoReqInfoList.LotteryDailyRewardGetItemCmd
ProtoReqInfoList[60126] = ProtoReqInfoList.AutoSellItemCmd
ProtoReqInfoList[60129] = ProtoReqInfoList.QueryAfricanPoringItemCmd
ProtoReqInfoList[60130] = ProtoReqInfoList.AfricanPoringUpdateItemCmd
ProtoReqInfoList[60131] = ProtoReqInfoList.AfricanPoringLotteryItemCmd
ProtoReqInfoList[60135] = ProtoReqInfoList.ExtractLevelUpItemCmd
ProtoReqInfoList[60132] = ProtoReqInfoList.EnchantRefreshAttr
ProtoReqInfoList[60133] = ProtoReqInfoList.ProcessEnchantRefreshAttr
ProtoReqInfoList[60134] = ProtoReqInfoList.EnchantUpgradeAttr
ProtoReqInfoList[60136] = ProtoReqInfoList.RefreshEquipAttrCmd
ProtoReqInfoList[60139] = ProtoReqInfoList.QuenchEquipItemCmd
ProtoReqInfoList[60140] = ProtoReqInfoList.MountFashionSyncCmd
ProtoReqInfoList[60141] = ProtoReqInfoList.MountFashionChangeCmd
ProtoReqInfoList[60137] = ProtoReqInfoList.EquipPromote
ProtoReqInfoList[60142] = ProtoReqInfoList.SwitchFashionEquipRecordItemCmd
ProtoReqInfoList[60138] = ProtoReqInfoList.OldItemExchangeItemCmd
ProtoReqInfoList[60143] = ProtoReqInfoList.BuyMixLotteryItemCmd
ProtoReqInfoList[60144] = ProtoReqInfoList.CardLotteryPrayItemCmd
ProtoReqInfoList[60145] = ProtoReqInfoList.SyncCardLotteryPrayItemCmd
ProtoReqInfoList[60153] = ProtoReqInfoList.GemBagExpSyncItemCmd
ProtoReqInfoList[60151] = ProtoReqInfoList.SecretLandGemCmd
ProtoReqInfoList[60146] = ProtoReqInfoList.MountFashionQueryStateCmd
ProtoReqInfoList[60147] = ProtoReqInfoList.MountFashionActiveCmd
ProtoReqInfoList[60148] = ProtoReqInfoList.StorePutItemItemCmd
ProtoReqInfoList[60149] = ProtoReqInfoList.StoreOffItemItemCmd
ProtoReqInfoList[60154] = ProtoReqInfoList.FullGemSkill
ProtoReqInfoList[60155] = ProtoReqInfoList.QueryBossCardComposeRateCmd
ProtoReqInfoList[60156] = ProtoReqInfoList.MemoryEmbedItemCmd
ProtoReqInfoList[60157] = ProtoReqInfoList.MemoryUnEmbedItemCmd
ProtoReqInfoList[60158] = ProtoReqInfoList.MemoryLevelupItemCmd
ProtoReqInfoList[60159] = ProtoReqInfoList.MemoryDecomposeItemCmd
ProtoReqInfoList[60160] = ProtoReqInfoList.MemoryEffectOperItemCmd
ProtoReqInfoList[60161] = ProtoReqInfoList.MemoryAutoDecomposeOptionItemCmd
ProtoReqInfoList[60162] = ProtoReqInfoList.UpdateMemoryPosItemCmd
ProtoReqInfoList[60163] = ProtoReqInfoList.DecomposeGemItemCmd
ProtoReqInfoList[60164] = ProtoReqInfoList.UpgradeGemItemCmd
ProtoReqInfoList[60165] = ProtoReqInfoList.MemoryUpgradeItemCmd
ProtoReqInfoList[60166] = ProtoReqInfoList.CardLevelupItemCmd
ProtoReqInfoList[60167] = ProtoReqInfoList.BalanceModeMemorySetItemCmd
ProtoReqInfoList[60168] = ProtoReqInfoList.BalanceModeMemoryUpdateItemCmd
ProtoReqInfoList[60169] = ProtoReqInfoList.MemoryExcessItemCmd
ProtoReqInfoList[2330001] = ProtoReqInfoList.BuildDataNtfManorCmd
ProtoReqInfoList[2330002] = ProtoReqInfoList.BuildQueryManorCmd
ProtoReqInfoList[2330003] = ProtoReqInfoList.BuildLevelUpManorCmd
ProtoReqInfoList[2330004] = ProtoReqInfoList.BuildDispatchManorCmd
ProtoReqInfoList[2330005] = ProtoReqInfoList.BuildLotteryManorCmd
ProtoReqInfoList[2330006] = ProtoReqInfoList.BuildCollectManorCmd
ProtoReqInfoList[2330007] = ProtoReqInfoList.ReqEnterRaidManorCmd
ProtoReqInfoList[2330008] = ProtoReqInfoList.PartnerInfoManorCmd
ProtoReqInfoList[2330009] = ProtoReqInfoList.PartnerStroyManorCmd
ProtoReqInfoList[2330010] = ProtoReqInfoList.PartnerIdleListManorCmd
ProtoReqInfoList[2330011] = ProtoReqInfoList.PartnerIdleUpdateManorCmd
ProtoReqInfoList[2330012] = ProtoReqInfoList.PartnerGiveManorCmd
ProtoReqInfoList[2330013] = ProtoReqInfoList.BuildForgeManorCmd
ProtoReqInfoList[2330014] = ProtoReqInfoList.SmithInfoManorCmd
ProtoReqInfoList[2330015] = ProtoReqInfoList.SmithLevelUpManorCmd
ProtoReqInfoList[2330016] = ProtoReqInfoList.SmithAcceptQuestManorCmd
ProtoReqInfoList[230001] = ProtoReqInfoList.QueryVersion
ProtoReqInfoList[230002] = ProtoReqInfoList.QueryManualData
ProtoReqInfoList[230003] = ProtoReqInfoList.PointSync
ProtoReqInfoList[230004] = ProtoReqInfoList.ManualUpdate
ProtoReqInfoList[230005] = ProtoReqInfoList.GetAchieveReward
ProtoReqInfoList[230006] = ProtoReqInfoList.Unlock
ProtoReqInfoList[230007] = ProtoReqInfoList.SkillPointSync
ProtoReqInfoList[230008] = ProtoReqInfoList.LevelSync
ProtoReqInfoList[230009] = ProtoReqInfoList.GetQuestReward
ProtoReqInfoList[230010] = ProtoReqInfoList.StoreManualCmd
ProtoReqInfoList[230011] = ProtoReqInfoList.GetManualCmd
ProtoReqInfoList[230012] = ProtoReqInfoList.GroupActionManualCmd
ProtoReqInfoList[230013] = ProtoReqInfoList.QueryUnsolvedPhotoManualCmd
ProtoReqInfoList[230014] = ProtoReqInfoList.UpdateSolvedPhotoManualCmd
ProtoReqInfoList[230015] = ProtoReqInfoList.NpcZoneDataManualCmd
ProtoReqInfoList[230016] = ProtoReqInfoList.NpcZoneRewardManualCmd
ProtoReqInfoList[230017] = ProtoReqInfoList.CollectionRewardManualCmd
ProtoReqInfoList[230018] = ProtoReqInfoList.UnlockQuickManualCmd
ProtoReqInfoList[230019] = ProtoReqInfoList.GetQuestRewardQuickManualCmd
ProtoReqInfoList[120001] = ProtoReqInfoList.AddMapItem
ProtoReqInfoList[120002] = ProtoReqInfoList.PickupItem
ProtoReqInfoList[120034] = ProtoReqInfoList.SyncGemSecretLandNineData
ProtoReqInfoList[120003] = ProtoReqInfoList.AddMapUser
ProtoReqInfoList[120004] = ProtoReqInfoList.AddMapNpc
ProtoReqInfoList[120005] = ProtoReqInfoList.AddMapTrap
ProtoReqInfoList[120006] = ProtoReqInfoList.AddMapAct
ProtoReqInfoList[120007] = ProtoReqInfoList.ExitPointState
ProtoReqInfoList[120008] = ProtoReqInfoList.MapCmdEnd
ProtoReqInfoList[120009] = ProtoReqInfoList.NpcSearchRangeCmd
ProtoReqInfoList[120010] = ProtoReqInfoList.UserHandsCmd
ProtoReqInfoList[120011] = ProtoReqInfoList.SpEffectCmd
ProtoReqInfoList[120012] = ProtoReqInfoList.UserHandNpcCmd
ProtoReqInfoList[120013] = ProtoReqInfoList.GingerBreadNpcCmd
ProtoReqInfoList[120014] = ProtoReqInfoList.GoCityGateMapCmd
ProtoReqInfoList[120016] = ProtoReqInfoList.UserSecretQueryMapCmd
ProtoReqInfoList[120017] = ProtoReqInfoList.UserSecretGetMapCmd
ProtoReqInfoList[120015] = ProtoReqInfoList.EditNpcTextMapCmd
ProtoReqInfoList[120018] = ProtoReqInfoList.ObjStateSyncMapCmd
ProtoReqInfoList[120019] = ProtoReqInfoList.AddMapObjNpc
ProtoReqInfoList[2090020] = ProtoReqInfoList.TeamFollowBanListCmd
ProtoReqInfoList[120022] = ProtoReqInfoList.FuncBuildNpcSyncCmd
ProtoReqInfoList[120022] = ProtoReqInfoList.FuncBuildNpcUpdateCmd
ProtoReqInfoList[120023] = ProtoReqInfoList.QueryCloneMapStatusMapCmd
ProtoReqInfoList[120024] = ProtoReqInfoList.ChangeCloneMapCmd
ProtoReqInfoList[120025] = ProtoReqInfoList.StormBossAffixQueryCmd
ProtoReqInfoList[120026] = ProtoReqInfoList.BuffRewardQueryCmd
ProtoReqInfoList[120027] = ProtoReqInfoList.BuffRewardSelectCmd
ProtoReqInfoList[120028] = ProtoReqInfoList.MultiObjStateSyncMapCmd
ProtoReqInfoList[120029] = ProtoReqInfoList.UpdateZoneMapCmd
ProtoReqInfoList[120030] = ProtoReqInfoList.DropItem
ProtoReqInfoList[120032] = ProtoReqInfoList.MapNpcShowMapCmd
ProtoReqInfoList[120033] = ProtoReqInfoList.MapNpcDelMapCmd
ProtoReqInfoList[120031] = ProtoReqInfoList.NpcPreloadForbidMapCmd
ProtoReqInfoList[120035] = ProtoReqInfoList.CardRewardQueryCmd
ProtoReqInfoList[120036] = ProtoReqInfoList.SkillWeatherSyncCmd
ProtoReqInfoList[120037] = ProtoReqInfoList.AbyssAreaChangeNotifyCmd
ProtoReqInfoList[120038] = ProtoReqInfoList.AbyssBossUpdateCmd
ProtoReqInfoList[120039] = ProtoReqInfoList.ExtraRewardUpdateMapCmd
ProtoReqInfoList[99999] = ProtoReqInfoList.PetList
ProtoReqInfoList[100002] = ProtoReqInfoList.FireCatPetCmd
ProtoReqInfoList[100003] = ProtoReqInfoList.HireCatPetCmd
ProtoReqInfoList[100004] = ProtoReqInfoList.EggHatchPetCmd
ProtoReqInfoList[100005] = ProtoReqInfoList.EggRestorePetCmd
ProtoReqInfoList[100006] = ProtoReqInfoList.CatchValuePetCmd
ProtoReqInfoList[100007] = ProtoReqInfoList.CatchResultPetCmd
ProtoReqInfoList[100008] = ProtoReqInfoList.CatchPetPetCmd
ProtoReqInfoList[100012] = ProtoReqInfoList.CatchPetGiftPetCmd
ProtoReqInfoList[100009] = ProtoReqInfoList.PetInfoPetCmd
ProtoReqInfoList[100010] = ProtoReqInfoList.PetInfoUpdatePetCmd
ProtoReqInfoList[100011] = ProtoReqInfoList.PetOffPetCmd
ProtoReqInfoList[100013] = ProtoReqInfoList.GetGiftPetCmd
ProtoReqInfoList[100014] = ProtoReqInfoList.EquipOperPetCmd
ProtoReqInfoList[100015] = ProtoReqInfoList.EquipUpdatePetCmd
ProtoReqInfoList[100016] = ProtoReqInfoList.QueryPetAdventureListPetCmd
ProtoReqInfoList[100017] = ProtoReqInfoList.PetAdventureResultNtfPetCmd
ProtoReqInfoList[100018] = ProtoReqInfoList.StartAdventurePetCmd
ProtoReqInfoList[100019] = ProtoReqInfoList.GetAdventureRewardPetCmd
ProtoReqInfoList[100020] = ProtoReqInfoList.QueryBattlePetCmd
ProtoReqInfoList[100021] = ProtoReqInfoList.HandPetPetCmd
ProtoReqInfoList[100022] = ProtoReqInfoList.GiveGiftPetCmd
ProtoReqInfoList[100023] = ProtoReqInfoList.UnlockNtfPetCmd
ProtoReqInfoList[100024] = ProtoReqInfoList.ResetSkillPetCmd
ProtoReqInfoList[100026] = ProtoReqInfoList.ChangeNamePetCmd
ProtoReqInfoList[100027] = ProtoReqInfoList.SwitchSkillPetCmd
ProtoReqInfoList[100029] = ProtoReqInfoList.StartWorkPetCmd
ProtoReqInfoList[100030] = ProtoReqInfoList.StopWorkPetCmd
ProtoReqInfoList[100032] = ProtoReqInfoList.QueryPetWorkDataPetCmd
ProtoReqInfoList[100033] = ProtoReqInfoList.GetPetWorkRewardPetCmd
ProtoReqInfoList[100034] = ProtoReqInfoList.WorkSpaceUpdate
ProtoReqInfoList[100055] = ProtoReqInfoList.WorkSpaceDataUpdatePetCmd
ProtoReqInfoList[100035] = ProtoReqInfoList.PetExtraUpdatePetCmd
ProtoReqInfoList[100036] = ProtoReqInfoList.ComposePetCmd
ProtoReqInfoList[100037] = ProtoReqInfoList.PetEquipListCmd
ProtoReqInfoList[100038] = ProtoReqInfoList.UpdatePetEquipListCmd
ProtoReqInfoList[1] = ProtoReqInfoList.PetWearInfo
ProtoReqInfoList[100039] = ProtoReqInfoList.ChangeWearPetCmd
ProtoReqInfoList[100040] = ProtoReqInfoList.UpdateWearPetCmd
ProtoReqInfoList[100041] = ProtoReqInfoList.ReplaceCatPetCmd
ProtoReqInfoList[100042] = ProtoReqInfoList.WorkSpaceMaxCountUpdatePetCmd
ProtoReqInfoList[100043] = ProtoReqInfoList.CatEquipPetCmd
ProtoReqInfoList[100044] = ProtoReqInfoList.CatEquipInfoPetCmd
ProtoReqInfoList[100045] = ProtoReqInfoList.CatSkillOptionPetCmd
ProtoReqInfoList[100046] = ProtoReqInfoList.BoKiStateQueryPetCmd
ProtoReqInfoList[100047] = ProtoReqInfoList.BoKiDataUpdatePetCmd
ProtoReqInfoList[100048] = ProtoReqInfoList.BoKiEquipLevelUpPetCmd
ProtoReqInfoList[100049] = ProtoReqInfoList.BoKiEquipUpdatePetCmd
ProtoReqInfoList[100050] = ProtoReqInfoList.BoKiSkillLevelUpPetCmd
ProtoReqInfoList[100051] = ProtoReqInfoList.BoKiSkillUpdatePetCmd
ProtoReqInfoList[100052] = ProtoReqInfoList.BoKiSkillInUseUpdatePetCmd
ProtoReqInfoList[100053] = ProtoReqInfoList.BoKiSkillInUseSetPetCmd
ProtoReqInfoList[100054] = ProtoReqInfoList.SevenRoyalsFollowNpc
ProtoReqInfoList[80001] = ProtoReqInfoList.QuestList
ProtoReqInfoList[1] = ProtoReqInfoList.QuestUpdateItem
ProtoReqInfoList[80002] = ProtoReqInfoList.QuestUpdate
ProtoReqInfoList[80005] = ProtoReqInfoList.QuestStepUpdate
ProtoReqInfoList[80003] = ProtoReqInfoList.QuestAction
ProtoReqInfoList[80004] = ProtoReqInfoList.RunQuestStep
ProtoReqInfoList[80006] = ProtoReqInfoList.QuestTrace
ProtoReqInfoList[80007] = ProtoReqInfoList.QuestDetailList
ProtoReqInfoList[80008] = ProtoReqInfoList.QuestDetailUpdate
ProtoReqInfoList[80009] = ProtoReqInfoList.QuestRaidCmd
ProtoReqInfoList[80010] = ProtoReqInfoList.QuestCanAcceptListChange
ProtoReqInfoList[80011] = ProtoReqInfoList.VisitNpcUserCmd
ProtoReqInfoList[80012] = ProtoReqInfoList.QueryOtherData
ProtoReqInfoList[80013] = ProtoReqInfoList.QueryWantedInfoQuestCmd
ProtoReqInfoList[80014] = ProtoReqInfoList.InviteHelpAcceptQuestCmd
ProtoReqInfoList[80016] = ProtoReqInfoList.InviteAcceptQuestCmd
ProtoReqInfoList[80015] = ProtoReqInfoList.ReplyHelpAccelpQuestCmd
ProtoReqInfoList[80017] = ProtoReqInfoList.QueryWorldQuestCmd
ProtoReqInfoList[80018] = ProtoReqInfoList.QuestGroupTraceQuestCmd
ProtoReqInfoList[80019] = ProtoReqInfoList.HelpQuickFinishBoardQuestCmd
ProtoReqInfoList[80024] = ProtoReqInfoList.QueryQuestListQuestCmd
ProtoReqInfoList[80025] = ProtoReqInfoList.MapStepSyncCmd
ProtoReqInfoList[80026] = ProtoReqInfoList.MapStepUpdateCmd
ProtoReqInfoList[80027] = ProtoReqInfoList.MapStepFinishCmd
ProtoReqInfoList[80029] = ProtoReqInfoList.PlotStatusNtf
ProtoReqInfoList[80028] = ProtoReqInfoList.QuestAreaAction
ProtoReqInfoList[80030] = ProtoReqInfoList.QueryBottleInfoQuestCmd
ProtoReqInfoList[80031] = ProtoReqInfoList.BottleActionQuestCmd
ProtoReqInfoList[80032] = ProtoReqInfoList.BottleUpdateQuestCmd
ProtoReqInfoList[80033] = ProtoReqInfoList.EvidenceQueryCmd
ProtoReqInfoList[80034] = ProtoReqInfoList.UnlockEvidenceMessageCmd
ProtoReqInfoList[80035] = ProtoReqInfoList.QueryCharacterInfoCmd
ProtoReqInfoList[80037] = ProtoReqInfoList.EvidenceHintCmd
ProtoReqInfoList[80038] = ProtoReqInfoList.EnlightSecretCmd
ProtoReqInfoList[80039] = ProtoReqInfoList.CloseUICmd
ProtoReqInfoList[80040] = ProtoReqInfoList.NewEvidenceUpdateCmd
ProtoReqInfoList[80041] = ProtoReqInfoList.LeaveVisitNpcQuestCmd
ProtoReqInfoList[80042] = ProtoReqInfoList.CompleteAvailableQueryQuestCmd
ProtoReqInfoList[80043] = ProtoReqInfoList.WorldCountListQuestCmd
ProtoReqInfoList[80048] = ProtoReqInfoList.QueryQuestHeroQuestCmd
ProtoReqInfoList[80050] = ProtoReqInfoList.SetQuestStatusQuestCmd
ProtoReqInfoList[80049] = ProtoReqInfoList.UpdateQuestHeroQuestCmd
ProtoReqInfoList[80051] = ProtoReqInfoList.UpdateQuestStoryIndexQuestCmd
ProtoReqInfoList[80052] = ProtoReqInfoList.UpdateOnceRewardQuestCmd
ProtoReqInfoList[80053] = ProtoReqInfoList.SyncTreasureBoxNumCmd
ProtoReqInfoList[80054] = ProtoReqInfoList.QueryAbyssQuestListQuestCmd
ProtoReqInfoList[80055] = ProtoReqInfoList.UpdateAbyssHelpCountQuestCmd
ProtoReqInfoList[1] = ProtoReqInfoList.SealItem
ProtoReqInfoList[210001] = ProtoReqInfoList.QuerySeal
ProtoReqInfoList[210002] = ProtoReqInfoList.UpdateSeal
ProtoReqInfoList[210003] = ProtoReqInfoList.SealTimer
ProtoReqInfoList[210004] = ProtoReqInfoList.BeginSeal
ProtoReqInfoList[210005] = ProtoReqInfoList.EndSeal
ProtoReqInfoList[210006] = ProtoReqInfoList.SealUserLeave
ProtoReqInfoList[210007] = ProtoReqInfoList.SealQueryList
ProtoReqInfoList[210008] = ProtoReqInfoList.SealAcceptCmd
ProtoReqInfoList[70001] = ProtoReqInfoList.ReqSkillData
ProtoReqInfoList[70002] = ProtoReqInfoList.SkillUpdate
ProtoReqInfoList[70003] = ProtoReqInfoList.LevelupSkill
ProtoReqInfoList[70004] = ProtoReqInfoList.EquipSkill
ProtoReqInfoList[70005] = ProtoReqInfoList.ResetSkill
ProtoReqInfoList[70006] = ProtoReqInfoList.SkillValidPos
ProtoReqInfoList[70007] = ProtoReqInfoList.ChangeSkillCmd
ProtoReqInfoList[70008] = ProtoReqInfoList.UpSkillInfoSkillCmd
ProtoReqInfoList[70009] = ProtoReqInfoList.SelectRuneSkillCmd
ProtoReqInfoList[70010] = ProtoReqInfoList.MarkSkillNpcSkillCmd
ProtoReqInfoList[70011] = ProtoReqInfoList.TriggerSkillNpcSkillCmd
ProtoReqInfoList[70012] = ProtoReqInfoList.SkillOptionSkillCmd
ProtoReqInfoList[70013] = ProtoReqInfoList.DynamicSkillCmd
ProtoReqInfoList[70014] = ProtoReqInfoList.UpdateDynamicSkillCmd
ProtoReqInfoList[70015] = ProtoReqInfoList.SyncDestPosSkillCmd
ProtoReqInfoList[70016] = ProtoReqInfoList.ResetTalentSkillCmd
ProtoReqInfoList[70017] = ProtoReqInfoList.MultiSkillOptionUpdateSkillCmd
ProtoReqInfoList[70018] = ProtoReqInfoList.MultiSkillOptionSyncSkillCmd
ProtoReqInfoList[70020] = ProtoReqInfoList.SkillEffectSkillCmd
ProtoReqInfoList[70021] = ProtoReqInfoList.SyncSkillEffectSkillCmd
ProtoReqInfoList[70019] = ProtoReqInfoList.MaskSkillRandomOneSkillCmd
ProtoReqInfoList[70022] = ProtoReqInfoList.StopBossSkillUsageSkillCmd
ProtoReqInfoList[70023] = ProtoReqInfoList.ChangeAutoShortCutCmd
ProtoReqInfoList[70024] = ProtoReqInfoList.ClearOptionSkillCmd
ProtoReqInfoList[70025] = ProtoReqInfoList.SyncBulletNumSkillCmd
ProtoReqInfoList[70026] = ProtoReqInfoList.StopSniperModeSkillCmd
ProtoReqInfoList[70027] = ProtoReqInfoList.JudgeChantResultSkillCmd
ProtoReqInfoList[70028] = ProtoReqInfoList.SkillPerceptAbilityLvUpCmd
ProtoReqInfoList[70029] = ProtoReqInfoList.SkillPerceptAbilityNtf
ProtoReqInfoList[70030] = ProtoReqInfoList.SetCastPosSkillCmd
ProtoReqInfoList[70031] = ProtoReqInfoList.MarkSunMoonSkillCmd
ProtoReqInfoList[70032] = ProtoReqInfoList.TriggerKickSkillSkillCmd
ProtoReqInfoList[70033] = ProtoReqInfoList.TimeDiskSkillCmd
ProtoReqInfoList[70034] = ProtoReqInfoList.UseSkillSuccessSync
ProtoReqInfoList[70035] = ProtoReqInfoList.UpdateMasterSkill
ProtoReqInfoList[70036] = ProtoReqInfoList.UpdateMasterSkillEquip
ProtoReqInfoList[70037] = ProtoReqInfoList.SwitchMasterSkill
ProtoReqInfoList[70038] = ProtoReqInfoList.UpdateInheritSkillCmd
ProtoReqInfoList[70039] = ProtoReqInfoList.LoadInheritSkillCmd
ProtoReqInfoList[70040] = ProtoReqInfoList.ExtendInheritSkillCmd
ProtoReqInfoList[70041] = ProtoReqInfoList.SyncBlockMasterSkill
ProtoReqInfoList[180001] = ProtoReqInfoList.GameTipCmd
ProtoReqInfoList[180002] = ProtoReqInfoList.BrowseRedTipCmd
ProtoReqInfoList[180003] = ProtoReqInfoList.AddRedTip
ProtoReqInfoList[50001] = ProtoReqInfoList.UserSyncCmd
ProtoReqInfoList[50000] = ProtoReqInfoList.UserMessageCmd
ProtoReqInfoList[50003] = ProtoReqInfoList.UserGMCommand
ProtoReqInfoList[50000] = ProtoReqInfoList.UserProfessionExchange
ProtoReqInfoList[49999] = ProtoReqInfoList.UserTest
ProtoReqInfoList[49999] = ProtoReqInfoList.UserFaceCmd
ProtoReqInfoList[50011] = ProtoReqInfoList.MainUserDataUserCmd
ProtoReqInfoList[50015] = ProtoReqInfoList.ReqMoveUserCmd
ProtoReqInfoList[50016] = ProtoReqInfoList.RetMoveUserCmd
ProtoReqInfoList[50017] = ProtoReqInfoList.SynTimeUserCmd
ProtoReqInfoList[50018] = ProtoReqInfoList.DeleteEntryUserCmd
ProtoReqInfoList[50022] = ProtoReqInfoList.ChangeBodyUserCmd
ProtoReqInfoList[50023] = ProtoReqInfoList.ChangeSceneUserCmd
ProtoReqInfoList[50025] = ProtoReqInfoList.FuntionNpcListUserCmd
ProtoReqInfoList[50026] = ProtoReqInfoList.DeleteStaticEntryUserCmd
ProtoReqInfoList[50027] = ProtoReqInfoList.SkillBroadcastUserCmd
ProtoReqInfoList[50047] = ProtoReqInfoList.TestSkillBroadcastUserCmd
ProtoReqInfoList[50028] = ProtoReqInfoList.UseSkillUserCmd
ProtoReqInfoList[50029] = ProtoReqInfoList.ChantSkillUserCmd
ProtoReqInfoList[50030] = ProtoReqInfoList.BreakChantSkillUserCmd
ProtoReqInfoList[50031] = ProtoReqInfoList.BroadcastSkillUserCmd
ProtoReqInfoList[50038] = ProtoReqInfoList.MapObjectData
ProtoReqInfoList[50041] = ProtoReqInfoList.ReliveUserCmd
ProtoReqInfoList[50042] = ProtoReqInfoList.GoToUserCmd
ProtoReqInfoList[50043] = ProtoReqInfoList.ReconnectionPosUserCmd
ProtoReqInfoList[50048] = ProtoReqInfoList.GoToExitPosUserCmd
ProtoReqInfoList[50049] = ProtoReqInfoList.GoToRandomPosUserCmd
ProtoReqInfoList[50050] = ProtoReqInfoList.UserRejectSettingNotifyServiceCmd
ProtoReqInfoList[50051] = ProtoReqInfoList.NpcWalkTraceInfo
ProtoReqInfoList[50052] = ProtoReqInfoList.ReqHideUserCmd
ProtoReqInfoList[50053] = ProtoReqInfoList.ObservationModeUserCmd
ProtoReqInfoList[90001] = ProtoReqInfoList.GoCity
ProtoReqInfoList[90002] = ProtoReqInfoList.SysMsg
ProtoReqInfoList[90003] = ProtoReqInfoList.NpcDataSync
ProtoReqInfoList[90004] = ProtoReqInfoList.UserNineSyncCmd
ProtoReqInfoList[90005] = ProtoReqInfoList.UserActionNtf
ProtoReqInfoList[90006] = ProtoReqInfoList.UserBuffNineSyncCmd
ProtoReqInfoList[90007] = ProtoReqInfoList.ExitPosUserCmd
ProtoReqInfoList[90008] = ProtoReqInfoList.Relive
ProtoReqInfoList[90009] = ProtoReqInfoList.VarUpdate
ProtoReqInfoList[90010] = ProtoReqInfoList.TalkInfo
ProtoReqInfoList[90011] = ProtoReqInfoList.ServerTime
ProtoReqInfoList[90014] = ProtoReqInfoList.EffectUserCmd
ProtoReqInfoList[90015] = ProtoReqInfoList.MenuList
ProtoReqInfoList[90016] = ProtoReqInfoList.NewMenu
ProtoReqInfoList[90232] = ProtoReqInfoList.EvaluationReward
ProtoReqInfoList[90017] = ProtoReqInfoList.TeamInfoNine
ProtoReqInfoList[90018] = ProtoReqInfoList.UsePortrait
ProtoReqInfoList[90019] = ProtoReqInfoList.UseFrame
ProtoReqInfoList[90020] = ProtoReqInfoList.UpdatePortraitFrame
ProtoReqInfoList[90024] = ProtoReqInfoList.QueryPortraitListUserCmd
ProtoReqInfoList[90025] = ProtoReqInfoList.UseDressing
ProtoReqInfoList[90026] = ProtoReqInfoList.NewDressing
ProtoReqInfoList[90027] = ProtoReqInfoList.DressingListUserCmd
ProtoReqInfoList[90021] = ProtoReqInfoList.AddAttrPoint
ProtoReqInfoList[90022] = ProtoReqInfoList.QueryShopGotItem
ProtoReqInfoList[90023] = ProtoReqInfoList.UpdateShopGotItem
ProtoReqInfoList[90029] = ProtoReqInfoList.OpenUI
ProtoReqInfoList[90030] = ProtoReqInfoList.DbgSysMsg
ProtoReqInfoList[90032] = ProtoReqInfoList.FollowTransferCmd
ProtoReqInfoList[90033] = ProtoReqInfoList.CallNpcFuncCmd
ProtoReqInfoList[90034] = ProtoReqInfoList.ModelShow
ProtoReqInfoList[90035] = ProtoReqInfoList.SoundEffectCmd
ProtoReqInfoList[90036] = ProtoReqInfoList.PresetMsgCmd
ProtoReqInfoList[90037] = ProtoReqInfoList.ChangeBgmCmd
ProtoReqInfoList[90038] = ProtoReqInfoList.QueryFighterInfo
ProtoReqInfoList[90040] = ProtoReqInfoList.GameTimeCmd
ProtoReqInfoList[90041] = ProtoReqInfoList.CDTimeUserCmd
ProtoReqInfoList[90042] = ProtoReqInfoList.StateChange
ProtoReqInfoList[90044] = ProtoReqInfoList.Photo
ProtoReqInfoList[90045] = ProtoReqInfoList.ShakeScreen
ProtoReqInfoList[90047] = ProtoReqInfoList.QueryShortcut
ProtoReqInfoList[90048] = ProtoReqInfoList.PutShortcut
ProtoReqInfoList[90180] = ProtoReqInfoList.TempPutShortCut
ProtoReqInfoList[90049] = ProtoReqInfoList.NpcChangeAngle
ProtoReqInfoList[90050] = ProtoReqInfoList.CameraFocus
ProtoReqInfoList[90051] = ProtoReqInfoList.GoToListUserCmd
ProtoReqInfoList[90052] = ProtoReqInfoList.GoToGearUserCmd
ProtoReqInfoList[90012] = ProtoReqInfoList.NewTransMapCmd
ProtoReqInfoList[90151] = ProtoReqInfoList.DeathTransferListCmd
ProtoReqInfoList[90152] = ProtoReqInfoList.NewDeathTransferCmd
ProtoReqInfoList[90153] = ProtoReqInfoList.UseDeathTransferCmd
ProtoReqInfoList[90053] = ProtoReqInfoList.FollowerUser
ProtoReqInfoList[90096] = ProtoReqInfoList.BeFollowUserCmd
ProtoReqInfoList[90054] = ProtoReqInfoList.LaboratoryUserCmd
ProtoReqInfoList[90057] = ProtoReqInfoList.GotoLaboratoryUserCmd
ProtoReqInfoList[90056] = ProtoReqInfoList.ExchangeProfession
ProtoReqInfoList[90058] = ProtoReqInfoList.SceneryUserCmd
ProtoReqInfoList[90059] = ProtoReqInfoList.GoMapQuestUserCmd
ProtoReqInfoList[90060] = ProtoReqInfoList.GoMapFollowUserCmd
ProtoReqInfoList[90061] = ProtoReqInfoList.UserAutoHitCmd
ProtoReqInfoList[90062] = ProtoReqInfoList.UploadSceneryPhotoUserCmd
ProtoReqInfoList[1] = ProtoReqInfoList.UpyunUrl
ProtoReqInfoList[90080] = ProtoReqInfoList.DownloadSceneryPhotoUserCmd
ProtoReqInfoList[90063] = ProtoReqInfoList.QueryMapArea
ProtoReqInfoList[90064] = ProtoReqInfoList.NewMapAreaNtf
ProtoReqInfoList[90066] = ProtoReqInfoList.BuffForeverCmd
ProtoReqInfoList[90067] = ProtoReqInfoList.InviteJoinHandsUserCmd
ProtoReqInfoList[90068] = ProtoReqInfoList.BreakUpHandsUserCmd
ProtoReqInfoList[90095] = ProtoReqInfoList.HandStatusUserCmd
ProtoReqInfoList[90069] = ProtoReqInfoList.QueryShow
ProtoReqInfoList[90070] = ProtoReqInfoList.QueryMusicList
ProtoReqInfoList[90071] = ProtoReqInfoList.DemandMusic
ProtoReqInfoList[90072] = ProtoReqInfoList.CloseMusicFrame
ProtoReqInfoList[90073] = ProtoReqInfoList.UploadOkSceneryUserCmd
ProtoReqInfoList[90074] = ProtoReqInfoList.JoinHandsUserCmd
ProtoReqInfoList[90075] = ProtoReqInfoList.QueryTraceList
ProtoReqInfoList[90076] = ProtoReqInfoList.UpdateTraceList
ProtoReqInfoList[90077] = ProtoReqInfoList.SetDirection
ProtoReqInfoList[90082] = ProtoReqInfoList.BattleTimelenUserCmd
ProtoReqInfoList[90083] = ProtoReqInfoList.SetOptionUserCmd
ProtoReqInfoList[90084] = ProtoReqInfoList.QueryUserInfoUserCmd
ProtoReqInfoList[90085] = ProtoReqInfoList.CountDownTickUserCmd
ProtoReqInfoList[90086] = ProtoReqInfoList.ItemMusicNtfUserCmd
ProtoReqInfoList[90087] = ProtoReqInfoList.ShakeTreeUserCmd
ProtoReqInfoList[90088] = ProtoReqInfoList.TreeListUserCmd
ProtoReqInfoList[90089] = ProtoReqInfoList.ActivityNtfUserCmd
ProtoReqInfoList[90091] = ProtoReqInfoList.QueryZoneStatusUserCmd
ProtoReqInfoList[90092] = ProtoReqInfoList.JumpZoneUserCmd
ProtoReqInfoList[90093] = ProtoReqInfoList.ItemImageUserNtfUserCmd
ProtoReqInfoList[90097] = ProtoReqInfoList.InviteFollowUserCmd
ProtoReqInfoList[90098] = ProtoReqInfoList.ChangeNameUserCmd
ProtoReqInfoList[90099] = ProtoReqInfoList.ChargePlayUserCmd
ProtoReqInfoList[90100] = ProtoReqInfoList.RequireNpcFuncUserCmd
ProtoReqInfoList[90101] = ProtoReqInfoList.CheckSeatUserCmd
ProtoReqInfoList[90102] = ProtoReqInfoList.NtfSeatUserCmd
ProtoReqInfoList[90114] = ProtoReqInfoList.YoyoSeatUserCmd
ProtoReqInfoList[90115] = ProtoReqInfoList.ShowSeatUserCmd
ProtoReqInfoList[90103] = ProtoReqInfoList.SetNormalSkillOptionUserCmd
ProtoReqInfoList[90106] = ProtoReqInfoList.NewSetOptionUserCmd
ProtoReqInfoList[90104] = ProtoReqInfoList.UnsolvedSceneryNtfUserCmd
ProtoReqInfoList[90105] = ProtoReqInfoList.NtfVisibleNpcUserCmd
ProtoReqInfoList[90108] = ProtoReqInfoList.TransformPreDataCmd
ProtoReqInfoList[90109] = ProtoReqInfoList.UserRenameCmd
ProtoReqInfoList[90111] = ProtoReqInfoList.BuyZenyCmd
ProtoReqInfoList[90112] = ProtoReqInfoList.CallTeamerUserCmd
ProtoReqInfoList[90113] = ProtoReqInfoList.CallTeamerReplyUserCmd
ProtoReqInfoList[90116] = ProtoReqInfoList.SpecialEffectCmd
ProtoReqInfoList[90117] = ProtoReqInfoList.MarriageProposalCmd
ProtoReqInfoList[90118] = ProtoReqInfoList.MarriageProposalReplyCmd
ProtoReqInfoList[90119] = ProtoReqInfoList.UploadWeddingPhotoUserCmd
ProtoReqInfoList[90120] = ProtoReqInfoList.MarriageProposalSuccessCmd
ProtoReqInfoList[90121] = ProtoReqInfoList.InviteeWeddingStartNtfUserCmd
ProtoReqInfoList[90128] = ProtoReqInfoList.KFCShareUserCmd
ProtoReqInfoList[90162] = ProtoReqInfoList.KFCEnrollUserCmd
ProtoReqInfoList[90168] = ProtoReqInfoList.KFCEnrollCodeUserCmd
ProtoReqInfoList[90163] = ProtoReqInfoList.KFCEnrollReplyUserCmd
ProtoReqInfoList[90167] = ProtoReqInfoList.KFCEnrollQueryUserCmd
ProtoReqInfoList[90166] = ProtoReqInfoList.KFCHasEnrolledUserCmd
ProtoReqInfoList[90130] = ProtoReqInfoList.CheckRelationUserCmd
ProtoReqInfoList[90129] = ProtoReqInfoList.TwinsActionUserCmd
ProtoReqInfoList[90122] = ProtoReqInfoList.ShowServantUserCmd
ProtoReqInfoList[90123] = ProtoReqInfoList.ReplaceServantUserCmd
ProtoReqInfoList[90255] = ProtoReqInfoList.HireServantUserCmd
ProtoReqInfoList[90124] = ProtoReqInfoList.ServantService
ProtoReqInfoList[90125] = ProtoReqInfoList.RecommendServantUserCmd
ProtoReqInfoList[90126] = ProtoReqInfoList.ReceiveServantUserCmd
ProtoReqInfoList[90127] = ProtoReqInfoList.ServantRewardStatusUserCmd
ProtoReqInfoList[90131] = ProtoReqInfoList.ProfessionQueryUserCmd
ProtoReqInfoList[90132] = ProtoReqInfoList.ProfessionBuyUserCmd
ProtoReqInfoList[90133] = ProtoReqInfoList.ProfessionChangeUserCmd
ProtoReqInfoList[1] = ProtoReqInfoList.ProfessionUserInfo
ProtoReqInfoList[1] = ProtoReqInfoList.SlotInfo
ProtoReqInfoList[90134] = ProtoReqInfoList.UpdateRecordInfoUserCmd
ProtoReqInfoList[90135] = ProtoReqInfoList.SaveRecordUserCmd
ProtoReqInfoList[90136] = ProtoReqInfoList.LoadRecordUserCmd
ProtoReqInfoList[90137] = ProtoReqInfoList.ChangeRecordNameUserCmd
ProtoReqInfoList[90138] = ProtoReqInfoList.BuyRecordSlotUserCmd
ProtoReqInfoList[90139] = ProtoReqInfoList.DeleteRecordUserCmd
ProtoReqInfoList[90140] = ProtoReqInfoList.UpdateBranchInfoUserCmd
ProtoReqInfoList[90110] = ProtoReqInfoList.EnterCapraActivityCmd
ProtoReqInfoList[90142] = ProtoReqInfoList.InviteWithMeUserCmd
ProtoReqInfoList[90143] = ProtoReqInfoList.QueryAltmanKillUserCmd
ProtoReqInfoList[90144] = ProtoReqInfoList.BoothReqUserCmd
ProtoReqInfoList[90145] = ProtoReqInfoList.BoothInfoSyncUserCmd
ProtoReqInfoList[90146] = ProtoReqInfoList.DressUpModelUserCmd
ProtoReqInfoList[90147] = ProtoReqInfoList.DressUpHeadUserCmd
ProtoReqInfoList[90148] = ProtoReqInfoList.QueryStageUserCmd
ProtoReqInfoList[90149] = ProtoReqInfoList.DressUpLineUpUserCmd
ProtoReqInfoList[90150] = ProtoReqInfoList.DressUpStageUserCmd
ProtoReqInfoList[90141] = ProtoReqInfoList.GoToFunctionMapUserCmd
ProtoReqInfoList[1] = ProtoReqInfoList.GrowthCurInfo
ProtoReqInfoList[90154] = ProtoReqInfoList.GrowthServantUserCmd
ProtoReqInfoList[90155] = ProtoReqInfoList.ReceiveGrowthServantUserCmd
ProtoReqInfoList[90156] = ProtoReqInfoList.GrowthOpenServantUserCmd
ProtoReqInfoList[90157] = ProtoReqInfoList.CheatTagUserCmd
ProtoReqInfoList[90158] = ProtoReqInfoList.CheatTagStatUserCmd
ProtoReqInfoList[90159] = ProtoReqInfoList.ClickPosList
ProtoReqInfoList[90169] = ProtoReqInfoList.ServerInfoNtf
ProtoReqInfoList[90174] = ProtoReqInfoList.ReadyToMapUserCmd
ProtoReqInfoList[90164] = ProtoReqInfoList.SignInUserCmd
ProtoReqInfoList[90165] = ProtoReqInfoList.SignInNtfUserCmd
ProtoReqInfoList[90160] = ProtoReqInfoList.BeatPoriUserCmd
ProtoReqInfoList[90161] = ProtoReqInfoList.UnlockFrameUserCmd
ProtoReqInfoList[90170] = ProtoReqInfoList.AltmanRewardUserCmd
ProtoReqInfoList[1] = ProtoReqInfoList.ServantReservationItem
ProtoReqInfoList[90171] = ProtoReqInfoList.ServantReqReservationUserCmd
ProtoReqInfoList[90172] = ProtoReqInfoList.ServantReservationUserCmd
ProtoReqInfoList[90173] = ProtoReqInfoList.ServantRecEquipUserCmd
ProtoReqInfoList[90175] = ProtoReqInfoList.PrestigeNtfUserCmd
ProtoReqInfoList[90176] = ProtoReqInfoList.PrestigeGiveUserCmd
ProtoReqInfoList[90178] = ProtoReqInfoList.UpdateGameHealthLevelUserCmd
ProtoReqInfoList[90179] = ProtoReqInfoList.GameHealthEventStatUserCmd
ProtoReqInfoList[90181] = ProtoReqInfoList.Fishway2KillBossInformUserCmd
ProtoReqInfoList[90177] = ProtoReqInfoList.ActPointUserCmd
ProtoReqInfoList[90182] = ProtoReqInfoList.HighRefineAttrUserCmd
ProtoReqInfoList[90183] = ProtoReqInfoList.HeadwearNpcUserCmd
ProtoReqInfoList[90184] = ProtoReqInfoList.HeadwearRoundUserCmd
ProtoReqInfoList[90185] = ProtoReqInfoList.HeadwearTowerUserCmd
ProtoReqInfoList[90186] = ProtoReqInfoList.HeadwearEndUserCmd
ProtoReqInfoList[90187] = ProtoReqInfoList.HeadwearRangeUserCmd
ProtoReqInfoList[90191] = ProtoReqInfoList.ServantStatisticsUserCmd
ProtoReqInfoList[90192] = ProtoReqInfoList.ServantStatisticsMailUserCmd
ProtoReqInfoList[90201] = ProtoReqInfoList.HeadwearOpenUserCmd
ProtoReqInfoList[90198] = ProtoReqInfoList.FastTransClassUserCmd
ProtoReqInfoList[90199] = ProtoReqInfoList.FastTransGemQueryUserCmd
ProtoReqInfoList[90200] = ProtoReqInfoList.FastTransGemGetUserCmd
ProtoReqInfoList[90205] = ProtoReqInfoList.FourthSkillCostGetUserCmd
ProtoReqInfoList[90202] = ProtoReqInfoList.BuildDataQueryUserCmd
ProtoReqInfoList[90203] = ProtoReqInfoList.BuildContributeUserCmd
ProtoReqInfoList[90204] = ProtoReqInfoList.BuildOperateUserCmd
ProtoReqInfoList[90211] = ProtoReqInfoList.NightmareAttrQueryUserCmd
ProtoReqInfoList[90212] = ProtoReqInfoList.NightmareAttrGetUserCmd
ProtoReqInfoList[90197] = ProtoReqInfoList.MapAnimeUserCmd
ProtoReqInfoList[90216] = ProtoReqInfoList.ShootNpcUserCmd
ProtoReqInfoList[90217] = ProtoReqInfoList.PaySignNtfUserCmd
ProtoReqInfoList[90218] = ProtoReqInfoList.PaySignBuyUserCmd
ProtoReqInfoList[90219] = ProtoReqInfoList.PaySignRewardUserCmd
ProtoReqInfoList[90206] = ProtoReqInfoList.ExtractionQueryUserCmd
ProtoReqInfoList[90207] = ProtoReqInfoList.ExtractionOperateUserCmd
ProtoReqInfoList[90208] = ProtoReqInfoList.ExtractionActiveUserCmd
ProtoReqInfoList[90209] = ProtoReqInfoList.ExtractionRemoveUserCmd
ProtoReqInfoList[90210] = ProtoReqInfoList.ExtractionGridBuyUserCmd
ProtoReqInfoList[90214] = ProtoReqInfoList.ExtractionRefreshUserCmd
ProtoReqInfoList[90220] = ProtoReqInfoList.TeamExpRewardTypeCmd
ProtoReqInfoList[90221] = ProtoReqInfoList.SetMyselfOptionCmd
ProtoReqInfoList[90231] = ProtoReqInfoList.UseSkillEffectItemUserCmd
ProtoReqInfoList[90193] = ProtoReqInfoList.RideMultiMountUserCmd
ProtoReqInfoList[90194] = ProtoReqInfoList.KickOffPassengerUserCmd
ProtoReqInfoList[90195] = ProtoReqInfoList.SetMultiMountOptUserCmd
ProtoReqInfoList[90196] = ProtoReqInfoList.MultiMountChangePosUserCmd
ProtoReqInfoList[90222] = ProtoReqInfoList.GrouponQueryUserCmd
ProtoReqInfoList[90223] = ProtoReqInfoList.GrouponBuyUserCmd
ProtoReqInfoList[90224] = ProtoReqInfoList.GrouponRewardUserCmd
ProtoReqInfoList[90228] = ProtoReqInfoList.NtfPlayActUserCmd
ProtoReqInfoList[90225] = ProtoReqInfoList.NoviceTargetUpdateUserCmd
ProtoReqInfoList[90229] = ProtoReqInfoList.NoviceTargetRewardUserCmd
ProtoReqInfoList[90234] = ProtoReqInfoList.SetBoKiStateUserCmd
ProtoReqInfoList[90239] = ProtoReqInfoList.CloseDialogMaskUserCmd
ProtoReqInfoList[90240] = ProtoReqInfoList.CloseDialogCameraUserCmd
ProtoReqInfoList[90241] = ProtoReqInfoList.HideUIUserCmd
ProtoReqInfoList[90233] = ProtoReqInfoList.QueryMapMonsterRefreshInfo
ProtoReqInfoList[90242] = ProtoReqInfoList.SetCameraUserCmd
ProtoReqInfoList[90215] = ProtoReqInfoList.QueryProfessionDataDetailUserCmd
ProtoReqInfoList[90246] = ProtoReqInfoList.ClearProfessionDataDetailUserCmd
ProtoReqInfoList[90243] = ProtoReqInfoList.ChainExchangeUserCmd
ProtoReqInfoList[90244] = ProtoReqInfoList.ChainOptUserCmd
ProtoReqInfoList[90247] = ProtoReqInfoList.ActivityDonateQueryUserCmd
ProtoReqInfoList[90248] = ProtoReqInfoList.ActivityDonateRewardUserCmd
ProtoReqInfoList[90249] = ProtoReqInfoList.ChangeHairUserCmd
ProtoReqInfoList[90250] = ProtoReqInfoList.ChangeEyeUserCmd
ProtoReqInfoList[90245] = ProtoReqInfoList.HappyValueUserCmd
ProtoReqInfoList[90251] = ProtoReqInfoList.SendTargetPosUserCmd
ProtoReqInfoList[90252] = ProtoReqInfoList.CookGameFinishUserCmd
ProtoReqInfoList[90253] = ProtoReqInfoList.RaceGameStartUserCmd
ProtoReqInfoList[90254] = ProtoReqInfoList.RaceGameFinishUserCmd
ProtoReqInfoList[90226] = ProtoReqInfoList.SendMarksInfoUserCmd
ProtoReqInfoList[90227] = ProtoReqInfoList.UserSyncBuffFromUserCmd
ProtoReqInfoList[820001] = ProtoReqInfoList.FirstDepositInfo
ProtoReqInfoList[820002] = ProtoReqInfoList.FirstDepositReward
ProtoReqInfoList[820003] = ProtoReqInfoList.ClientPayLog
ProtoReqInfoList[820004] = ProtoReqInfoList.DailyDepositInfo
ProtoReqInfoList[820005] = ProtoReqInfoList.DailyDepositGetReward
ProtoReqInfoList[820006] = ProtoReqInfoList.BattleTimeCostSelectCmd
ProtoReqInfoList[820009] = ProtoReqInfoList.PlugInNotify
ProtoReqInfoList[820010] = ProtoReqInfoList.PlugInUpload
ProtoReqInfoList[820015] = ProtoReqInfoList.HeroStoryQuestInfo
ProtoReqInfoList[820016] = ProtoReqInfoList.HeroStoryQuestAccept
ProtoReqInfoList[820014] = ProtoReqInfoList.HeroQuestReward
ProtoReqInfoList[820013] = ProtoReqInfoList.HeroGrowthQuestInfo
ProtoReqInfoList[820008] = ProtoReqInfoList.QueryProfessionRecordSimpleData
ProtoReqInfoList[820011] = ProtoReqInfoList.HeroBuyUserCmd
ProtoReqInfoList[820012] = ProtoReqInfoList.HeroShowUserCmd
ProtoReqInfoList[820017] = ProtoReqInfoList.AccumDepositInfo
ProtoReqInfoList[820018] = ProtoReqInfoList.AccumDepositReward
ProtoReqInfoList[820019] = ProtoReqInfoList.BoliGoldGetReward
ProtoReqInfoList[820020] = ProtoReqInfoList.BoliGoldInfo
ProtoReqInfoList[820021] = ProtoReqInfoList.BoliGoldGetFreeReward
ProtoReqInfoList[820022] = ProtoReqInfoList.ResourceCheckUserCmd
ProtoReqInfoList[820024] = ProtoReqInfoList.NoviceChargeSync
ProtoReqInfoList[820025] = ProtoReqInfoList.NoviceChargeReward
ProtoReqInfoList[820027] = ProtoReqInfoList.EquipPosEffectTime
ProtoReqInfoList[820023] = ProtoReqInfoList.UpdateRecordSlotIndex
ProtoReqInfoList[820026] = ProtoReqInfoList.SyncInterferenceData
ProtoReqInfoList[820028] = ProtoReqInfoList.GetResourceRewardCmd
ProtoReqInfoList[820031] = ProtoReqInfoList.AuthQueryUserCmd
ProtoReqInfoList[820032] = ProtoReqInfoList.AuthUpdateUserCmd
ProtoReqInfoList[820033] = ProtoReqInfoList.ActionStatUserCmd
ProtoReqInfoList[820029] = ProtoReqInfoList.UnlockDress
ProtoReqInfoList[820034] = ProtoReqInfoList.QueryPrestigeCmd
ProtoReqInfoList[820035] = ProtoReqInfoList.PrestigeLevelUpNotifyCmd
ProtoReqInfoList[820036] = ProtoReqInfoList.SuperSignInUserCmd
ProtoReqInfoList[820037] = ProtoReqInfoList.SuperSignInNtfUserCmd
ProtoReqInfoList[820038] = ProtoReqInfoList.PrestigeRewardCmd
ProtoReqInfoList[820039] = ProtoReqInfoList.QueryQuestSignInfoUserCmd
ProtoReqInfoList[820040] = ProtoReqInfoList.LightFireworkUserCmd
ProtoReqInfoList[820041] = ProtoReqInfoList.RemoveFireworkUserCmd
ProtoReqInfoList[820042] = ProtoReqInfoList.QueryYearMemoryUserCmd
ProtoReqInfoList[820043] = ProtoReqInfoList.YearMemoryProcessUserCmd
ProtoReqInfoList[820044] = ProtoReqInfoList.SetYearMemoryTitleUserCmd
ProtoReqInfoList[820045] = ProtoReqInfoList.ActivityExchangeGiftsQueryUserCmd
ProtoReqInfoList[820046] = ProtoReqInfoList.ActivityExchangeGiftsRewardUserCmd
ProtoReqInfoList[820047] = ProtoReqInfoList.GvgExcellectQueryUserCmd
ProtoReqInfoList[820049] = ProtoReqInfoList.EffectInfoSyncUserCmd
ProtoReqInfoList[820050] = ProtoReqInfoList.EffectInfoUpdateUserCmd
ProtoReqInfoList[820051] = ProtoReqInfoList.EffectInfoUseUserCmd
ProtoReqInfoList[820048] = ProtoReqInfoList.GvgExcellectRewardUserCmd
ProtoReqInfoList[820052] = ProtoReqInfoList.BattleTimeOffUserCmd
ProtoReqInfoList[820053] = ProtoReqInfoList.PlayTimeOffUserCmd
ProtoReqInfoList[820054] = ProtoReqInfoList.WareHouseOperationCmd
ProtoReqInfoList[820055] = ProtoReqInfoList.FairyTaleRankQueryCmd
ProtoReqInfoList[550001] = ProtoReqInfoList.QueryAllMail
ProtoReqInfoList[550002] = ProtoReqInfoList.MailUpdate
ProtoReqInfoList[550003] = ProtoReqInfoList.GetMailAttach
ProtoReqInfoList[550004] = ProtoReqInfoList.MailRead
ProtoReqInfoList[550005] = ProtoReqInfoList.MailRemove
ProtoReqInfoList[520001] = ProtoReqInfoList.BuyShopItem
ProtoReqInfoList[520002] = ProtoReqInfoList.QueryShopConfigCmd
ProtoReqInfoList[520003] = ProtoReqInfoList.QueryQuickBuyConfigCmd
ProtoReqInfoList[520004] = ProtoReqInfoList.QueryShopSoldCountCmd
ProtoReqInfoList[520005] = ProtoReqInfoList.ShopDataUpdateCmd
ProtoReqInfoList[520006] = ProtoReqInfoList.UpdateShopConfigCmd
ProtoReqInfoList[1] = ProtoReqInfoList.ExchangeShopItem
ProtoReqInfoList[520007] = ProtoReqInfoList.UpdateExchangeShopData
ProtoReqInfoList[520008] = ProtoReqInfoList.ExchangeShopItemCmd
ProtoReqInfoList[520009] = ProtoReqInfoList.ResetExchangeShopDataShopCmd
ProtoReqInfoList[520010] = ProtoReqInfoList.FreyExchangeShopCmd
ProtoReqInfoList[520011] = ProtoReqInfoList.OpenShopTypeShopCmd
ProtoReqInfoList[520012] = ProtoReqInfoList.BulkBuyShopItem
ProtoReqInfoList[520013] = ProtoReqInfoList.BuyPackageSaleShopCmd
ProtoReqInfoList[520014] = ProtoReqInfoList.BuyDepositProductShopCmd
ProtoReqInfoList[520015] = ProtoReqInfoList.RewardSafetyQueryShopCmd
ProtoReqInfoList[520016] = ProtoReqInfoList.ExtraBonusQueryShopCmd
ProtoReqInfoList[520017] = ProtoReqInfoList.ExtraBonusResetShopCmd
ProtoReqInfoList[520018] = ProtoReqInfoList.ExtraBonusRewardShopCmd
ProtoReqInfoList[560001] = ProtoReqInfoList.QuerySocialData
ProtoReqInfoList[560002] = ProtoReqInfoList.FindUser
ProtoReqInfoList[560003] = ProtoReqInfoList.SocialUpdate
ProtoReqInfoList[1] = ProtoReqInfoList.SocialDataItem
ProtoReqInfoList[560004] = ProtoReqInfoList.SocialDataUpdate
ProtoReqInfoList[560005] = ProtoReqInfoList.FrameStatusSocialCmd
ProtoReqInfoList[560006] = ProtoReqInfoList.UseGiftCodeSocialCmd
ProtoReqInfoList[560007] = ProtoReqInfoList.OperateQuerySocialCmd
ProtoReqInfoList[560008] = ProtoReqInfoList.OperateTakeSocialCmd
ProtoReqInfoList[560009] = ProtoReqInfoList.QueryDataNtfSocialCmd
ProtoReqInfoList[560010] = ProtoReqInfoList.OperActivityNtfSocialCmd
ProtoReqInfoList[560011] = ProtoReqInfoList.AddRelation
ProtoReqInfoList[560012] = ProtoReqInfoList.RemoveRelation
ProtoReqInfoList[560013] = ProtoReqInfoList.QueryRecallListSocialCmd
ProtoReqInfoList[560014] = ProtoReqInfoList.RecallFriendSocialCmd
ProtoReqInfoList[560015] = ProtoReqInfoList.AddRelationResultSocialCmd
ProtoReqInfoList[560016] = ProtoReqInfoList.QueryChargeVirginCmd
ProtoReqInfoList[560017] = ProtoReqInfoList.QueryUserInfoCmd
ProtoReqInfoList[560018] = ProtoReqInfoList.TutorFuncStateNtfSocialCmd
ProtoReqInfoList[510001] = ProtoReqInfoList.TeamList
ProtoReqInfoList[510002] = ProtoReqInfoList.TeamDataUpdate
ProtoReqInfoList[510003] = ProtoReqInfoList.TeamMemberUpdate
ProtoReqInfoList[510004] = ProtoReqInfoList.TeamApplyUpdate
ProtoReqInfoList[510005] = ProtoReqInfoList.CreateTeam
ProtoReqInfoList[510006] = ProtoReqInfoList.InviteMember
ProtoReqInfoList[510007] = ProtoReqInfoList.ProcessTeamInvite
ProtoReqInfoList[510008] = ProtoReqInfoList.TeamMemberApply
ProtoReqInfoList[510009] = ProtoReqInfoList.ProcessTeamApply
ProtoReqInfoList[510010] = ProtoReqInfoList.KickMember
ProtoReqInfoList[510011] = ProtoReqInfoList.ExchangeLeader
ProtoReqInfoList[510012] = ProtoReqInfoList.ExitTeam
ProtoReqInfoList[510013] = ProtoReqInfoList.EnterTeam
ProtoReqInfoList[510014] = ProtoReqInfoList.MemberPosUpdate
ProtoReqInfoList[510015] = ProtoReqInfoList.MemberDataUpdate
ProtoReqInfoList[510016] = ProtoReqInfoList.LockTarget
ProtoReqInfoList[510017] = ProtoReqInfoList.TeamSummon
ProtoReqInfoList[510018] = ProtoReqInfoList.ClearApplyList
ProtoReqInfoList[510019] = ProtoReqInfoList.QuickEnter
ProtoReqInfoList[510020] = ProtoReqInfoList.SetTeamOption
ProtoReqInfoList[510021] = ProtoReqInfoList.QueryUserTeamInfoTeamCmd
ProtoReqInfoList[510022] = ProtoReqInfoList.SetMemberOptionTeamCmd
ProtoReqInfoList[510023] = ProtoReqInfoList.QuestWantedQuestTeamCmd
ProtoReqInfoList[510024] = ProtoReqInfoList.UpdateWantedQuestTeamCmd
ProtoReqInfoList[510025] = ProtoReqInfoList.AcceptHelpWantedTeamCmd
ProtoReqInfoList[510026] = ProtoReqInfoList.UpdateHelpWantedTeamCmd
ProtoReqInfoList[510027] = ProtoReqInfoList.QueryHelpWantedTeamCmd
ProtoReqInfoList[510028] = ProtoReqInfoList.QueryMemberCatTeamCmd
ProtoReqInfoList[510029] = ProtoReqInfoList.MemberCatUpdateTeam
ProtoReqInfoList[510031] = ProtoReqInfoList.CancelApplyTeamCmd
ProtoReqInfoList[510032] = ProtoReqInfoList.QueryMemberTeamCmd
ProtoReqInfoList[510033] = ProtoReqInfoList.UserApplyUpdateTeamCmd
ProtoReqInfoList[510034] = ProtoReqInfoList.InviteGroupTeamCmd
ProtoReqInfoList[510035] = ProtoReqInfoList.ProcessInviteGroupTeamCmd
ProtoReqInfoList[510036] = ProtoReqInfoList.DissolveGroupTeamCmd
ProtoReqInfoList[510037] = ProtoReqInfoList.ChangeGroupLeaderTeamCmd
ProtoReqInfoList[510038] = ProtoReqInfoList.GroupUpdateNtfTeamCmd
ProtoReqInfoList[510039] = ProtoReqInfoList.QueryGroupTeamApplyListTeamCmd
ProtoReqInfoList[510040] = ProtoReqInfoList.TeamGroupApplyUpdate
ProtoReqInfoList[510041] = ProtoReqInfoList.TeamGroupApplyTeamCmd
ProtoReqInfoList[510042] = ProtoReqInfoList.ProcessGroupApplyTeamCmd
ProtoReqInfoList[510043] = ProtoReqInfoList.MyGroupApplyUpdateTeamCmd
ProtoReqInfoList[510044] = ProtoReqInfoList.LaunckKickTeamCmd
ProtoReqInfoList[510045] = ProtoReqInfoList.ReplyKickTeamCmd
ProtoReqInfoList[510051] = ProtoReqInfoList.GMEMuteTeamCmd
ProtoReqInfoList[510046] = ProtoReqInfoList.ReqRecruitPublishTeamCmd
ProtoReqInfoList[510047] = ProtoReqInfoList.NewRecruitPublishTeamCmd
ProtoReqInfoList[510048] = ProtoReqInfoList.ReqRecruitTeamInfoTeamCmd
ProtoReqInfoList[510049] = ProtoReqInfoList.UpdateRecruitTeamInfoTeamCmd
ProtoReqInfoList[510050] = ProtoReqInfoList.ChangeGroupMemberTeamCmd
ProtoReqInfoList[510052] = ProtoReqInfoList.PublishReqHelpTeamCmd
ProtoReqInfoList[510053] = ProtoReqInfoList.AskForTeamInfoTeamCmd
ProtoReqInfoList[530001] = ProtoReqInfoList.WeatherChange
ProtoReqInfoList[530002] = ProtoReqInfoList.SkyChange
ProtoReqInfoList[690001] = ProtoReqInfoList.InviteGroupJoinRaidTeamCmd
ProtoReqInfoList[690002] = ProtoReqInfoList.ReplyGroupJoinRaidTeamCmd
ProtoReqInfoList[690003] = ProtoReqInfoList.OpenGroupRaidTeamCmd
ProtoReqInfoList[690004] = ProtoReqInfoList.JoinGroupRaidTeamCmd
ProtoReqInfoList[690005] = ProtoReqInfoList.QueryGroupRaidStatusCmd
ProtoReqInfoList[690020] = ProtoReqInfoList.CreateGroupRaidTeamCmd
ProtoReqInfoList[690021] = ProtoReqInfoList.GoToGroupRaidTeamCmd
ProtoReqInfoList[690006] = ProtoReqInfoList.EnterNextRaidGroupCmd
ProtoReqInfoList[690007] = ProtoReqInfoList.InviteConfirmRaidTeamGroupCmd
ProtoReqInfoList[690008] = ProtoReqInfoList.ReplyConfirmRaidTeamGroupCmd
ProtoReqInfoList[690009] = ProtoReqInfoList.QueryGroupRaidKillUserInfo
ProtoReqInfoList[690010] = ProtoReqInfoList.QueryGroupRaidKillGuildInfo
ProtoReqInfoList[690011] = ProtoReqInfoList.QueryGroupRaidKillUserShowData
ProtoReqInfoList[670001] = ProtoReqInfoList.TeamRaidInviteCmd
ProtoReqInfoList[670002] = ProtoReqInfoList.TeamRaidReplyCmd
ProtoReqInfoList[670003] = ProtoReqInfoList.TeamRaidEnterCmd
ProtoReqInfoList[670004] = ProtoReqInfoList.TeamRaidAltmanShowCmd
ProtoReqInfoList[670006] = ProtoReqInfoList.TeamRaidImageCreateCmd
ProtoReqInfoList[670007] = ProtoReqInfoList.TeamPvpInviteMatchCmd
ProtoReqInfoList[670008] = ProtoReqInfoList.TeamPvpReplyMatchCmd
ProtoReqInfoList[670009] = ProtoReqInfoList.ComodoTeamRaidCreateCmd
ProtoReqInfoList[670011] = ProtoReqInfoList.GuildTeamRaidCreateCmd
ProtoReqInfoList[730001] = ProtoReqInfoList.TechTreeUnlockLeafCmd
ProtoReqInfoList[730002] = ProtoReqInfoList.TechTreeSyncLeafCmd
ProtoReqInfoList[730003] = ProtoReqInfoList.AddToyDrawingCmd
ProtoReqInfoList[730004] = ProtoReqInfoList.SyncToyDrawingCmd
ProtoReqInfoList[730005] = ProtoReqInfoList.TechTreeMakeToyCmd
ProtoReqInfoList[730006] = ProtoReqInfoList.ToyTransSetPosCmd
ProtoReqInfoList[730007] = ProtoReqInfoList.TechTreeLevelAwardCmd
ProtoReqInfoList[730008] = ProtoReqInfoList.TechTreeProduceCollectCmd
ProtoReqInfoList[730009] = ProtoReqInfoList.TechTreeProdecInfoCmd
ProtoReqInfoList[730010] = ProtoReqInfoList.TechTreeInjectCmd
ProtoReqInfoList[730011] = ProtoReqInfoList.TechTreeInjectInfoCmd
ProtoReqInfoList[310001] = ProtoReqInfoList.TutorTaskUpdateNtf
ProtoReqInfoList[310002] = ProtoReqInfoList.TutorTaskQueryCmd
ProtoReqInfoList[310003] = ProtoReqInfoList.TutorTaskTeacherRewardCmd
ProtoReqInfoList[310004] = ProtoReqInfoList.TutorGrowRewardUpdateNtf
ProtoReqInfoList[310005] = ProtoReqInfoList.TutorGetGrowRewardCmd
ProtoReqInfoList[310006] = ProtoReqInfoList.TutorTaskUpdateBoxCmd
ProtoReqInfoList[740001] = ProtoReqInfoList.ReqAfkUserAfkCmd
ProtoReqInfoList[740002] = ProtoReqInfoList.RetAfkUserAfkCmd
ProtoReqInfoList[740003] = ProtoReqInfoList.SyncStatInfoAfkCmd
ProtoReqInfoList[250001] = ProtoReqInfoList.FirstActionUserEvent
ProtoReqInfoList[250002] = ProtoReqInfoList.DamageNpcUserEvent
ProtoReqInfoList[250003] = ProtoReqInfoList.NewTitle
ProtoReqInfoList[250004] = ProtoReqInfoList.AllTitle
ProtoReqInfoList[250005] = ProtoReqInfoList.UpdateRandomUserEvent
ProtoReqInfoList[250006] = ProtoReqInfoList.BuffDamageUserEvent
ProtoReqInfoList[250007] = ProtoReqInfoList.ChargeNtfUserEvent
ProtoReqInfoList[250008] = ProtoReqInfoList.ChargeQueryCmd
ProtoReqInfoList[250009] = ProtoReqInfoList.DepositCardInfo
ProtoReqInfoList[250010] = ProtoReqInfoList.DelTransformUserEvent
ProtoReqInfoList[250011] = ProtoReqInfoList.InviteCatFailUserEvent
ProtoReqInfoList[250012] = ProtoReqInfoList.TrigNpcFuncUserEvent
ProtoReqInfoList[250013] = ProtoReqInfoList.SystemStringUserEvent
ProtoReqInfoList[250014] = ProtoReqInfoList.HandCatUserEvent
ProtoReqInfoList[250015] = ProtoReqInfoList.ChangeTitle
ProtoReqInfoList[250016] = ProtoReqInfoList.QueryChargeCnt
ProtoReqInfoList[250017] = ProtoReqInfoList.NTFMonthCardEnd
ProtoReqInfoList[250018] = ProtoReqInfoList.LoveLetterUse
ProtoReqInfoList[250019] = ProtoReqInfoList.QueryActivityCnt
ProtoReqInfoList[250020] = ProtoReqInfoList.UpdateActivityCnt
ProtoReqInfoList[250023] = ProtoReqInfoList.NtfVersionCardInfo
ProtoReqInfoList[250024] = ProtoReqInfoList.DieTimeCountEventCmd
ProtoReqInfoList[250022] = ProtoReqInfoList.GetFirstShareRewardUserEvent
ProtoReqInfoList[250025] = ProtoReqInfoList.QueryResetTimeEventCmd
ProtoReqInfoList[250026] = ProtoReqInfoList.InOutActEventCmd
ProtoReqInfoList[250027] = ProtoReqInfoList.UserEventMailCmd
ProtoReqInfoList[250028] = ProtoReqInfoList.LevelupDeadUserEvent
ProtoReqInfoList[250029] = ProtoReqInfoList.SwitchAutoBattleUserEvent
ProtoReqInfoList[250030] = ProtoReqInfoList.GoActivityMapUserEvent
ProtoReqInfoList[250031] = ProtoReqInfoList.ActivityPointUserEvent
ProtoReqInfoList[250033] = ProtoReqInfoList.QueryFavoriteFriendUserEvent
ProtoReqInfoList[250034] = ProtoReqInfoList.UpdateFavoriteFriendUserEvent
ProtoReqInfoList[250035] = ProtoReqInfoList.ActionFavoriteFriendUserEvent
ProtoReqInfoList[250036] = ProtoReqInfoList.SoundStoryUserEvent
ProtoReqInfoList[250032] = ProtoReqInfoList.ThemeDetailsUserEvent
ProtoReqInfoList[250040] = ProtoReqInfoList.CameraActionUserEvent
ProtoReqInfoList[250039] = ProtoReqInfoList.BifrostContributeItemUserEvent
ProtoReqInfoList[250041] = ProtoReqInfoList.RobotOffBattleUserEvent
ProtoReqInfoList[250037] = ProtoReqInfoList.QueryAccChargeCntReward
ProtoReqInfoList[250042] = ProtoReqInfoList.ChargeSdkRequestUserEvent
ProtoReqInfoList[250043] = ProtoReqInfoList.ChargeSdkReplyUserEvent
ProtoReqInfoList[250044] = ProtoReqInfoList.ClientAISyncUserEvent
ProtoReqInfoList[250045] = ProtoReqInfoList.ClientAIUpdateUserEvent
ProtoReqInfoList[250046] = ProtoReqInfoList.GiftCodeExchangeEvent
ProtoReqInfoList[250047] = ProtoReqInfoList.SetHideOtherCmd
ProtoReqInfoList[250048] = ProtoReqInfoList.GiftTimeLimitNtfUserEvent
ProtoReqInfoList[250049] = ProtoReqInfoList.GiftTimeLimitBuyUserEvent
ProtoReqInfoList[250050] = ProtoReqInfoList.GiftTimeLimitActiveUserEvent
ProtoReqInfoList[250055] = ProtoReqInfoList.MultiCutSceneUpdateUserEvent
ProtoReqInfoList[250056] = ProtoReqInfoList.PolicyUpdateUserEvent
ProtoReqInfoList[250057] = ProtoReqInfoList.PolicyAgreeUserEvent
ProtoReqInfoList[250058] = ProtoReqInfoList.ShowSceneObject
ProtoReqInfoList[250059] = ProtoReqInfoList.DoubleAcionEvent
ProtoReqInfoList[250060] = ProtoReqInfoList.BeginMonitorUserEvent
ProtoReqInfoList[250061] = ProtoReqInfoList.StopMonitorUserEvent
ProtoReqInfoList[250065] = ProtoReqInfoList.StopMonitorRetUserEvent
ProtoReqInfoList[250062] = ProtoReqInfoList.MonitorGoToMapUserEvent
ProtoReqInfoList[250063] = ProtoReqInfoList.MonitorMapEndUserEvent
ProtoReqInfoList[250064] = ProtoReqInfoList.MonitorBuildUserEvent
ProtoReqInfoList[250073] = ProtoReqInfoList.GuideQuestEvent
ProtoReqInfoList[250075] = ProtoReqInfoList.ShowCardEvent
ProtoReqInfoList[250071] = ProtoReqInfoList.GvgOptStatueEvent
ProtoReqInfoList[250072] = ProtoReqInfoList.TimeLimitIconEvent
ProtoReqInfoList[250076] = ProtoReqInfoList.ShowRMBGiftEvent
ProtoReqInfoList[250066] = ProtoReqInfoList.ConfigActionUserEvent
ProtoReqInfoList[250067] = ProtoReqInfoList.NpcWalkStepNtfUserEvent
ProtoReqInfoList[250068] = ProtoReqInfoList.SetProfileUserEvent
ProtoReqInfoList[250070] = ProtoReqInfoList.QueryFateRelationEvent
ProtoReqInfoList[250069] = ProtoReqInfoList.SyncFateRelationEvent
ProtoReqInfoList[250077] = ProtoReqInfoList.QueryProfileUserEvent
ProtoReqInfoList[250078] = ProtoReqInfoList.GvgSandTableEvent
ProtoReqInfoList[250079] = ProtoReqInfoList.SetReliveMethodUserEvent
ProtoReqInfoList[250080] = ProtoReqInfoList.UIActionUserEvent
ProtoReqInfoList[250082] = ProtoReqInfoList.PlayCutSceneUserEvent
ProtoReqInfoList[250084] = ProtoReqInfoList.ReqPeriodicMonsterUserEvent
ProtoReqInfoList[250085] = ProtoReqInfoList.PlayHoldPetUserEvent
ProtoReqInfoList[250081] = ProtoReqInfoList.QuerySpeedUpUserEvent
ProtoReqInfoList[250083] = ProtoReqInfoList.ServerOpenTimeUserEvent
ProtoReqInfoList[250086] = ProtoReqInfoList.SkillDamageStatUserEvent
ProtoReqInfoList[250087] = ProtoReqInfoList.HeartBeatReqUserEvent
ProtoReqInfoList[250088] = ProtoReqInfoList.HeartBeatAckUserEvent
ProtoReqInfoList[250089] = ProtoReqInfoList.QueryUserReportListUserEvent
ProtoReqInfoList[250090] = ProtoReqInfoList.UserReportUserEvent
ProtoReqInfoList[2250001] = ProtoReqInfoList.UnlockPhotoFrame
ProtoReqInfoList[2250002] = ProtoReqInfoList.SyncAllPhotoFrame
ProtoReqInfoList[2250005] = ProtoReqInfoList.SelectPhotoFrame
ProtoReqInfoList[2250003] = ProtoReqInfoList.UnlockBackgroundFrame
ProtoReqInfoList[2250004] = ProtoReqInfoList.SyncAllBackgroundFrame
ProtoReqInfoList[2250006] = ProtoReqInfoList.SelectBackgroundFrame
ProtoReqInfoList[2250007] = ProtoReqInfoList.SyncUnlockChatFrame
ProtoReqInfoList[2250008] = ProtoReqInfoList.SelectChatFrame
ProtoReqInfoList[650001] = ProtoReqInfoList.ReqWeddingDateListCCmd
ProtoReqInfoList[650003] = ProtoReqInfoList.ReqWeddingOneDayListCCmd
ProtoReqInfoList[650004] = ProtoReqInfoList.ReqWeddingInfoCCmd
ProtoReqInfoList[650005] = ProtoReqInfoList.ReserveWeddingDateCCmd
ProtoReqInfoList[650006] = ProtoReqInfoList.NtfReserveWeddingDateCCmd
ProtoReqInfoList[650007] = ProtoReqInfoList.ReplyReserveWeddingDateCCmd
ProtoReqInfoList[650008] = ProtoReqInfoList.GiveUpReserveCCmd
ProtoReqInfoList[650009] = ProtoReqInfoList.ReqDivorceCCmd
ProtoReqInfoList[650010] = ProtoReqInfoList.UpdateWeddingManualCCmd
ProtoReqInfoList[650011] = ProtoReqInfoList.BuyWeddingPackageCCmd
ProtoReqInfoList[650012] = ProtoReqInfoList.BuyWeddingRingCCmd
ProtoReqInfoList[650013] = ProtoReqInfoList.WeddingInviteCCmd
ProtoReqInfoList[650014] = ProtoReqInfoList.UploadWeddingPhotoCCmd
ProtoReqInfoList[650015] = ProtoReqInfoList.CheckCanReserveCCmd
ProtoReqInfoList[650016] = ProtoReqInfoList.ReqPartnerInfoCCmd
ProtoReqInfoList[650017] = ProtoReqInfoList.NtfWeddingInfoCCmd
ProtoReqInfoList[650018] = ProtoReqInfoList.InviteBeginWeddingCCmd
ProtoReqInfoList[650019] = ProtoReqInfoList.ReplyBeginWeddingCCmd
ProtoReqInfoList[650020] = ProtoReqInfoList.GoToWeddingPosCCmd
ProtoReqInfoList[650021] = ProtoReqInfoList.QuestionWeddingCCmd
ProtoReqInfoList[650022] = ProtoReqInfoList.AnswerWeddingCCmd
ProtoReqInfoList[650023] = ProtoReqInfoList.WeddingEventMsgCCmd
ProtoReqInfoList[650024] = ProtoReqInfoList.WeddingOverCCmd
ProtoReqInfoList[650025] = ProtoReqInfoList.WeddingSwitchQuestionCCmd
ProtoReqInfoList[650026] = ProtoReqInfoList.EnterRollerCoasterCCmd
ProtoReqInfoList[650027] = ProtoReqInfoList.DivorceRollerCoasterInviteCCmd
ProtoReqInfoList[650028] = ProtoReqInfoList.DivorceRollerCoasterReplyCCmd
ProtoReqInfoList[650029] = ProtoReqInfoList.EnterWeddingMapCCmd
ProtoReqInfoList[650030] = ProtoReqInfoList.MissyouInviteWedCCmd
ProtoReqInfoList[650031] = ProtoReqInfoList.MisccyouReplyWedCCmd
ProtoReqInfoList[650032] = ProtoReqInfoList.WeddingCarrierCCmd
