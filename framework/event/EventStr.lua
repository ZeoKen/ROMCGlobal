StartEvent = {
  StartUp = "StartEvent_StartUp"
}
AppStateEvent = {
  Quit = "AppStateEvent_Quit",
  Focus = "AppStateEvent_Focus",
  Pause = "AppStateEvent_Pause",
  BackToLogo = "AppStateEvent_BackToLogo",
  OrientationChange = "AppStateEvent_OrientationChange"
}
MaskPlayerUIType = {
  BloodType = 1,
  NameType = 2,
  NameHonorFactionType = 3,
  ChatSkillWord = 4,
  Emoji = 5,
  BloodNameHonorFactionEmojiType = 6,
  TopFrame = 7,
  QuestUI = 8,
  FloatRoleTop = 9,
  GiftSymbol = 13,
  HurtNum = 100
}
UIEvent = {
  ShowUI = "UIEvent_ShowUI",
  CloseUI = "UIEvent_CloseUI",
  JumpPanel = "UIEvent_JumpPanel",
  FinishJump = "UIEvent_FinishJump",
  UIStart = "UIEvent_StartUI",
  EnterView = "UIEvent_EnterView",
  ExitView = "UIEvent_ExitView",
  RemoveFullScreenEffect = "UIEvent_RemoveFullScreenEffect",
  View1Test = "UIEvent_View1Test",
  PopObj = "UIEvent_PopObj",
  ExitCallback = "UIEvent_ExitCallback"
}
ShortCut = {MoveToPos = "MoveToPos"}
UIMenuEvent = {
  UnlockMenu = "UIMenuEvent_UnlockMenu",
  LockMenu = "UIMenuEvent_LockMenu",
  UnRegisitButton = "UIMenuEvent_UnRegisitButton",
  UnlockPrestige = "UIMenuEvent_UnlockPrestige"
}
SecurityEvent = {
  Close = "SecurityPanel_Close"
}
SceneUIEvent = {
  VisiblePlayerUI = "SceneUIEvent_VisiblePlayerUI",
  InVisiblePlayerUI = "SceneUIEvent_InVisiblePlayerUI",
  MaskPlayersUI = "SceneUIEvent_MaskPlayerUI",
  UnMaskPlayersUI = "SceneUIEvent_UnMaskPlayerUI",
  SceneUIEnable = "SceneUIEvent_SceneUIEnable",
  SceneUIDisable = "SceneUIEvent_SceneUIDisable",
  AddMonsterNamePre = "SceneUIEvent_AddMonsterNamePre",
  RemoveMonsterNamePre = "SceneUIEvent_RemoveMonsterNamePre"
}
HandEvent = {
  StartHandInHand = "HandEvent_StartHandInHand",
  StopHandInHand = "HandEvent_StopHandInHand",
  MyStartHandInHand = "HandEvent_MyStartHandInHand",
  MyStopHandInHand = "HandEvent_MyStopHandInHand"
}
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.LoginInit = "ServiceEvent_LoginInit"
ServiceEvent.ReconnInit = "ServiceEvent_ReconnInit"
ServiceEvent.ReloadDatas = "ServiceEvent_ReloadDatas"
ServiceEvent.ConnSuccess = "ServiceEvent_ConnSuccess"
ServiceEvent.ConnReconnect = "ServiceEvent_ConnReconnect"
ServiceEvent.ConnNetDelay = "ServiceEvent_ConnNetDelay"
ServiceEvent.ConnNetDown = "ServiceEvent_ConnNetDown"
ServiceEvent.UserLoginSuccess = "ServiceEvent_UserLoginSuccess"
ServiceEvent.UserRecvRoleInfo = "ServiceEvent_UserRecvRoleInfo"
ServiceEvent.UserSelectSuccess = "ServiceEvent_UserSelectSuccess"
ServiceEvent.PlayerMapOtherUserIn = "ServiceEvent_PlayerMapOtherUserIn"
ServiceEvent.PlayerMapOtherUserOut = "ServiceEvent_PlayerMapOtherUserOut"
ServiceEvent.PlayerMapChange = "ServiceEvent_PlayerMapChange"
ServiceEvent.PlayerMapObjectData = "ServiceEvent_PlayerMapObjectData"
ServiceEvent.PlayerChangeDress = "ServiceEvent_PlayerChangeDress"
ServiceEvent.PlayerMoveTo = "ServiceEvent_PlayerMoveTo"
ServiceEvent.PlayerAddMapNpc = "ServiceEvent_PlayerAddMapNpc"
ServiceEvent.PlayerSAttrSyncData = "ServiceEvent_PlayerSAttrSyncData"
ServiceEvent.PlayerSkillBroadcast = "ServiceEvent_PlayerSkillBroadcast"
ServiceEvent.SceneUserActionNtf = "ServiceEvent_SceneUserActionNtf"
ServiceEvent.SceneShortcutBar = "ServiceEvent_SceneShortcutBar"
ServiceEvent.SceneGoToUserCmd = "ServiceEvent_SceneGoToUserCmd"
ServiceEvent.NpcDie = "ServiceEvent_NpcDie"
ServiceEvent.NpcRelive = "ServiceEvent_NpcRelive"
ServiceEvent.PlayerDie = "ServiceEvent_PlayerDie"
ServiceEvent.PlayerRelive = "ServiceEvent_PlayerRelive"
ServiceEvent.NpcChangeHp = "ServiceEvent_NpcChangeHp"
ServiceEvent.ChooseServer = "ServiceEvent_ChooseServer"
ServiceEvent.Error = "ServiceEvent_Error"
ServiceEvent.ChatCmdBarrageMsgChatCmd = "ServiceEvent_ChatCmdBarrageMsgChatCmd"
CreatureEvent = {
  Player_CampChange = "Player_CampChange",
  PVP_TeamChange = "PVP_TeamChange",
  Hiding_Change = "Hiding_Change",
  Name_Change = "CreatureEvent_Name_Change",
  Sex_Change = "CreatureEvent_SexChange",
  NpcDie = "CreatureEvent_NpcDie",
  PortraitFrame_Change = "PortraitFrame_Change",
  Background_Change = "Background_Change",
  OnAllPartLoaded = "CreatureEvent_OnAllPartLoaded",
  BuffHpChange = "CreatureEvent_BuffHpChange",
  NatureResistanceChange = "CreatureEvent_NatureResistanceChange",
  NatureChange = "CreatureEvent_NatureChange",
  PrestigeChange = "CreatureEvent_PrestigeChange"
}
PetCreatureEvent = {
  PetChangeDress = "PetChangeDress",
  PetDressPreview = "PetDressPreview"
}
PlayerEvent = {
  CapturedCamera = "PlayerEvent_CapturedCamera",
  GuildInfoChange = "PlayerEvent_GuildInfoChange",
  DeathStatusChange = "PlayerEvent_DeathStatusChange",
  BuffChange = "PlayerEvent_BuffChange",
  AddBuffDropItem = "PlayerEvent_AddBuffDropItem",
  RemoveBuffDropItem = "PlayerEvent_RemoveBuffDropItem",
  UpdateBuffDropItem = "PlayerEvent_UpdateBuffDropItem",
  AnonymousStateChange = "PlayerEvent_AnonymousStateChange"
}
PVPEvent = {
  PVPDungeonLaunch = "PVPEvent_PVPDungeonLaunch",
  PVPDungeonShutDown = "PVPEvent_PVPDungeonShutDown",
  PVP_ChaosFightLaunch = "PVP_ChaosFightLaunch",
  PVP_ChaosFightShutDown = "PVP_ChaosFightShutDown",
  PVP_DesertWolfFightLaunch = "PVP_DesertWolfFightLaunch",
  PVP_DesertWolfFightShutDown = "PVP_DesertWolfFightShutDown",
  PVP_GlamMetalFightLaunch = "PVP_GlamMetalFightLaunch",
  PVP_GlamMetalFightShutDown = "PVP_GlamMetalFightShutDown",
  PVP_PoringFightLaunch = "PVP_PoringFightLaunch",
  PVP_PoringFightShutdown = "PVP_PoringFightShutdown",
  PVP_MVPFightLaunch = "PVP_MVPFightLaunch",
  PVP_MVPFightShutDown = "PVP_MVPFightShutDown",
  TeamPws_Launch = "TeamPws_Launch",
  TeamPws_ShutDown = "TeamPws_ShutDown",
  TeamPws_BuffBallChange = "TeamPws_BuffBallChange",
  TeamPws_PlayerBuffBallChange = "TeamPws_PlayerBuffBallChange",
  TeamPws_ClearInviteMatch = "TeamPws_ClearInviteMatch",
  TeamPwsOthello_Launch = "TeamPwsOthello_Launch",
  TeamPwsOthello_ShutDown = "TeamPwsOthello_ShutDown",
  PVP_TransferFightLaunch = "PVP_TransferFightLaunch",
  PVP_TransferFightShutDown = "PVP_TransferFightShutDown",
  TeamTwelve_Launch = "TeamTwelve_Launch",
  TeamTwelve_ShutDown = "TeamTwelve_ShutDown",
  TwelveChamption_ScheduleChanged = "TwelveChamption_ScheduleChanged",
  TwelveChamption_Fighting = "TwelveChamption_Fighting",
  OnFreeFireStateChanged = "PVPEvent_OnFreeFireStateChanged",
  TripleTeams_Launch = "PVPEvent_TripleTeams_Launch",
  TripleTeams_Shutdown = "PVPEvent_TripleTeams_Shutdown",
  EndlessBattleField_Launch = "PVPEvent_EndlessBattleField_Launch",
  EndlessBattleField_Shutdown = "PVPEvent_EndlessBattleField_Shutdown",
  EndlessBattleField_Event_Start = "PVPEvent_EndlessBattleField_Event_Start",
  EndlessBattleField_Event_End = "PVPEvent_EndlessBattleField_Event_End",
  EndlessBattleField_Event_Update = "PVPEvent_EndlessBattleField_Event_Update",
  EndlessBattleField_Event_PointOccypied = "PVPEvent_EndlessBattleField_Event_PointOccypied",
  EndlessBattleField_MultiEvent_End = "PVPEvent_EndlessBattleField_MultiEvent_End",
  PVP_CampChange = "PVP_CampChange"
}
PVEEvent = {
  PVE_CardLaunch = "PVE_CardLaunch",
  PVE_CardShutdown = "PVE_CardShutdown",
  Altman_Launch = "Altman_Launch",
  Altman_Shutdown = "Altman_Shutdown",
  ExpRaid_Launch = "ExpRaid_Launch",
  ExpRaid_Shutdown = "ExpRaid_Shutdown",
  PVE_ThanatosLaunch = "PVE_ThanatosLaunch",
  PVE_ThanatosShutdown = "PVE_ThanatosShutdown",
  IPRaid_Launch = "IPRaid_Launch",
  IPRaid_Shutdown = "IPRaid_Shutdown",
  ThanksgivingRaid_Launch = "ThanksgivingRaid_Launch",
  ThanksgivingRaid_Shutdown = "ThanksgivingRaid_Shutdown",
  IPRaid_Launch = "IPRaid_Launch",
  IPRaid_Shutdown = "IPRaid_Shutdown",
  HeadwearRaid_Launch = "HeadwearRaid_Launch",
  HeadwearRaid_Shutdown = "HeadwearRaid_Shutdown",
  NewHeadwearRaid_Launch = "NewHeadwearRaid_Launch",
  NewHeadwearRaid_RemoveNpc = "NewHeadwearRaid_RemoveNpc",
  Roguelike_Launch = "Roguelike_Launch",
  Roguelike_Shutdown = "Roguelike_Shutdown",
  MiniGameMonsterQA_Launch = "MiniGameMonsterQA__Launch",
  MiniGameMonsterQA_Shutdown = "MiniGameMonsterQA__Shutdown",
  MiniGameMonsterShot_PreLaunch = "MiniGameMonsterShot_PreLaunch",
  MiniGameMonsterShot_Launch = "MiniGameMonsterShot__Launch",
  MiniGameMonsterShot_Shutdown = "MiniGameMonsterShot__Shutdown",
  MiniGameMonsterShot_EnterPhotoGraph = "MiniGameMonsterShot_EnterPhotoGraph",
  MiniGameMonsterShot_ExitPhotoGraph = "MiniGameMonsterShot_ExitPhotoGraph",
  MiniGameMonsterShot_TakePhotoGraph = "MiniGameMonsterShot_TakePhotoGraph",
  MiniGameMonsterShot_ClosePhotoGraphResult = "MiniGameMonsterShot_ClosePhotoGraphResult",
  DeadBoss_Launch = "DeadBoss_Launch",
  DeadBoss_Shutdown = "DeadBoss_Shutdown",
  Einherjar_Launch = "Einherjar_Launch",
  Einherjar_Shutdown = "Einherjar_Shutdown",
  EndlessTowerPrivate_Launch = "EndlessTowerPrivate_Launch",
  EndlessTowerPrivate_Shutdown = "EndlessTowerPrivate_Shutdown",
  ChasingScene_Launch = "ChasingScene_Launch",
  ChasingScene_Shutdown = "ChasingScene_Shutdown",
  RaidPuzzle_Launch = "RaidPuzzle_Launch",
  RaidPuzzle_Shutdown = "RaidPuzzle_Shutdown",
  RaidPuzzle_RoomStatusChange = "RaidPuzzle_RoomStatusChange",
  RaidPuzzle_RefreshDarkMask = "RaidPuzzle_RefreshDarkMask",
  RaidPuzzle_RefreshBordInfos = "RaidPuzzle_RefreshBordInfos",
  RaidPuzzle_RefreshDescInfos = "RaidPuzzle_RefreshDescInfos",
  ComodoRaid_Launch = "ComodoRaid_Launch",
  ComodoRaid_Shutdown = "ComodoRaid_Shutdown",
  MultiBossRaid_Launch = "MultiBossRaid_Launch",
  MultiBossRaid_Shutdown = "MultiBossRaid_Shutdown",
  HeartLockRaid_Launch = "HeartLockRaid_Launch",
  HeartLockRaid_Shutdown = "HeartLockRaid_Shutdown",
  ElementRaid_Launch = "ElementRaid_Launch",
  ElementRaid_ShutDown = "ElementRaid_ShutDown",
  DemoRaid_Launch = "DemoRaidRaid_Launch",
  DemoRaidRaid_Shutdown = "DemoRaidRaid_Shutdown",
  HeroJourney_Launch = "HeroJourney_Launch",
  HeroJourney_Shutdown = "HeroJourney_Shutdown",
  HeroJourney_RemoveCD = "HeroJourney_RemoveCD",
  ReplyInvite = "NewPveEntrance_ReplyInvite",
  BeginInvite = "NewPveEntrance_BeginInvite",
  CancelInvite = "NewPveEntrance_CancelInvite",
  AutoCreatTeamForInvite = "NewPveEntrance_AutoCreatTeamForInvite",
  SyncPvePassInfo = "NewPveEntrance_SyncPvePassInfo",
  BossRaid_Launch = "BossRaid_Launch",
  BossRaid_Shutdown = "BossRaid_Shutdown",
  EndlessLaunchSuccess = "PVEEvent_EndlessLaunchSuccess",
  BossRaid_CountdownUpdate = "BossRaid_CountdownUpdate",
  StarArk_Launch = "StarArk_Launch",
  StarArk_Shutdown = "StarArk_Shutdown",
  EndlessBattleField_Launch = "EndlessBattleField_Launch",
  EndlessBattleField_Shutdown = "EndlessBattleField_Shutdown",
  Astral_Launch = "Astral_Launch",
  Astral_Shutdown = "Astral_Shutdown",
  SpeceTimeIllusion_Launch = "SpeceTimeIllusion_Launch",
  SpeceTimeIllusion_Shutdown = "SpeceTimeIllusion_Shutdown",
  AbyssDragon_Launch = "AbyssDragon_Launch",
  AbyssDragon_Shutdown = "AbyssDragon_Shutdown",
  AbyssDragon_UpdateArea = "AbyssDragon_UpdateArea",
  AbyssDragon_ClientWait = "AbyssDragon_ClientWait",
  FairyTale_Launch = "FairyTale_Launch",
  FairyTale_Shutdown = "FairyTale_Shutdown",
  FairyTale_AddTrainNpc = "FairyTale_AddTrainNpc",
  FairyTale_RemoveTrainNpc = "FairyTale_RemoveTrainNpc"
}
GVGEvent = {
  GVGDungeonLaunch = "GVGEvent_GVGDungeonLaunch",
  GVGDungeonShutDown = "GVGEvent_GVGDungeonShutDown",
  ShowNewAchievemnetEffect = "GVGEvent_ShowNewAchievemnetEffect",
  GVG_FinalFightLaunch = "GVGEvent_GVG_FinalFightLaunch",
  GVG_FinalFightShutDown = "GVGEvent_GVG_FinalFightShutDown",
  GVG_UpdatePointPercentTip = "GVGEvent_GVG_UpdatePointPer",
  GVG_RemovePointPercentTip = "GVGEvent_GVG_RemovePointPer",
  GVG_PerfectDefensePause = "GVGEvent_GVG_PerfectDefensePause",
  GVG_PerfectDefenseResume = "GVGEvent_GVG_PerfectDefenseResume",
  GVG_PerfectDefenseSuccess = "GVGEvent_GVG_PerfectDefenseSuccess",
  GVG_FirstOptionLaunch = "GVGEvent_GVG_FirstOptionLaunch",
  GVG_FirstOptionShutDown = "GVGEvent_GVG_FirstOptionShutDown",
  GVG_SearchGuildTimeOut = "GVGEvent_GVG_SearchGuildTimeOut",
  GVG_SearchGuild = "GVGEvent_GVG_SearchGuild",
  GVG_SmallMetalCntUpdate = "GVGEvent_GVG_SmallMetalCntUpdate",
  GVG_QueueUpdate = "GVGEvent_GVG_QueueUpdate",
  GVG_QueueRemove = "GVGEvent_GVG_QueueRemove",
  GVG_QueueAdd = "GVGEvent_GVG_QueueAdd",
  GVG_PointUpdate = "GVGEvent_GVG_PointUpdate",
  GVG_Calm = "GVGEvent_GVG_Calm",
  GVG_CrystalInvincible = "GVGEvent_GVG_CrystalInvincible",
  GVG_MvpStateUpdate = "GVGEvent_GVG_MvpStateUpdate",
  GVG_GLandStatueDirty = "GVGEvent_GLandStatueDirty",
  GVG_TraceToCity = "GVGEvent_GVG_TraceToCity"
}
YoyoJoinRoomEvent = {
  JoinRoom = "YoyoJoinRoomEvent_JoinRoom"
}
MyselfEvent = {
  Inited = "MyselfEvent_Inited",
  PlaceTo = "MyselfEvent_PlaceTo",
  LeaveScene = "MyselfEvent_LeaveScene",
  SelectTargetChange = "MyselfEvent_SelectTargetChange",
  SelectTargetClassChange = "MyselfEvent_SelectTargetClassChange",
  MyPropChange = "MyselfEvent_MyPropChange",
  MyDataChange = "MyselfEvent_MyDataChange",
  MyAttrChange = "MyselfEvent_MyAttrChange",
  UpdateAttrEffect = "MyselfEvent_UpdateAttrEffect",
  MyProfessionChange = "MyselfEvent_MyProfessionChange",
  ScaleChange = "MyselfEvent_ScaleChange",
  AskUseSkill = "MyselfEvent_AskUseSkill",
  CancelAskUseSkill = "MyselfEvent_CancelAskUseSkill",
  LevelUp = "MyselfEvent_LevelUp",
  JobExpChange = "MyselfEvent_JobExpChange",
  BaseExpChange = "MyselfEvent_BaseExpChange",
  ZenyChange = "MyselfEvent_ZenyChange",
  ContributeChange = "MyselfEvent_ContributeChange",
  BattlePointChange = "MyselfEvent_BattlePointChange",
  MusicInfoChange = "MyselfEvent_MusicInfoChange",
  ResetHpShortCut = "MyselfEvent_ResetHpShortCut",
  MyRoleChange = "MyselfEvent_MyRoleChange",
  ChangeDress = "MyselfEvent_ChangeDress",
  ChangeDressByNpcID = "MyselfEvent_ChangeDress_ByNpcID",
  HitTargets = "MyselfEvent_HitTargets",
  BeHited = "MyselfEvent_BeHited",
  AccessTarget = "MyselfEvent_AccessTarget",
  AccessSealNpc = "MyselfEvent_AccessSealNpc",
  ManualControlled = "MyselfEvent_ManualControlled",
  SyncBuffs = "MyselfEvent_SyncBuffs",
  AddBuffs = "MyselfEvent_AddBuffs",
  RemoveBuffs = "MyselfEvent_RemoveBuffs",
  DeathBegin = "MyselfEvent_DeathBegin",
  DeathEnd = "MyselfEvent_DeathEnd",
  ReliveStatus = "MyselfEvent_ReliveStatus",
  DeathStatus = "MyselfEvent_DeathStatus",
  LeaveCarrier = "MyselfEvent_LeaveCarrier",
  SkillPointChange = "MyselfEvent_SkillPointChange",
  SpChange = "MyselfEvent_SpChange",
  HpChange = "MyselfEvent_HpChange",
  EnableUseSkillStateChange = "MyselfEvent_EnableUseSkillStateChange",
  UsedSkill = "MyselfEvent_UsedSkill",
  ChangeJobReady = "MyselfEvent_ChangeJobReady",
  ChangeJobBegin = "MyselfEvent_ChangeJobBegin",
  ChangeJobEnd = "MyselfEvent_ChangeJobEnd",
  PartnerChange = "MyselfEvent_PartnerChange",
  PetChange = "MyselfEvent_PetChange",
  MyselfSceneUIClear = "MyselfSceneUIClear",
  TransformChange = "MyselfEvent_TransformChange",
  AddWeakDialog = "MyselfEvent_AddWeakDialog",
  SkillGuideBegin = "MyselfEvent_SkillGuideBegin",
  SkillGuideEnd = "MyselfEvent_SkillGuideEnd",
  TargetPositionChange = "MyselfEvent_TargetPositionChange",
  ZoneIdChange = "MyselfEvent_ZoneIdChange",
  MissionCommandChanged = "MyselfEvent_MissionCommandChanged",
  SceneGoToUserCmdHanded = "MyselfEvent_SceneGoToUserCmd",
  BuffChange = "MyselfEvent_BuffChange",
  CookerLvChange = "MyselfEvent_CookerLvChange",
  TasterLvChange = "MyselfEvent_TasterLvChange",
  Pet_HpChange = "MyselfEvent_Pet_HpChange",
  ServantFavorChange = "MyselfEvent_ServantFavorChange",
  ServantID = "MyselfEvent_ServantID",
  TwinActionStart = "MyselfEvent_TwinActionStart",
  VoiceChange = "MyselfEvent_VoiceChange",
  EnterVoiceChannel = "MyselfEvent_EnterVoiceChannel",
  DoubleAction_Build = "MyselfEvent_DoubleAction_Build",
  DoubleAction_Break = "MyselfEvent_DoubleAction_Break",
  DoubleAction_Ready = "MyselfEvent_DoubleAction_Ready",
  BattlePassLevelChange = "MyselfEvent_BattlePassLevelChange",
  BattlePassExpChange = "MyselfEvent_BattlePassExpChange",
  BattlePassCoinChange = "MyselfEvent_BattlePassCoinChange",
  WeaponPetExpChange = "MyselfEvent_WeaponPetExpChange",
  TwelvePvpCoinChange = "MyselfEvent_TwelvePvpCoinChange",
  GuildScoreChange = "MyselfEvent_GuildScoreChange",
  TwelvePvpCampChange = "MyselfEvent_TwelvePvpCampChange",
  NoviceTargetPointChange = "MyselfEvent_NoviceTargetPointChange",
  AddBoki = "MyselfEvent_AddBoki",
  RemoveBoki = "MyselfEvent_RemoveBoki",
  BokiHidePropsChange = "BokiHidePropsChange",
  CurBulletsChange = "CurBulletsChange",
  EnterSniperMode = "MyselfEvent_EnterSniperMode",
  ExitSniperMode = "MyselfEvent_ExitSniperMode",
  SexChange = "MyselfEvent_SexChange",
  LotteryChange = "MyselfEvent_LotteryChange",
  EnterBatteryCannon = "MyselfEvent_EnterBatteryCannon",
  ExitBatteryCannon = "MyselfEvent_ExitBatteryCannon",
  LockTargetStart = "LockTargetStart",
  LockTargetEnd = "LockTargetEnd",
  ServantChallengeExpChange = "MyselfEvent_ServantChallengeExpChange",
  ChallengeTowerLayer = "MyselfEvent_ChallengeTowerLayer",
  ObservationModeStart = "MyselfEvent_ObservationModeStart",
  ObservationModeEnd = "MyselfEvent_ObservationModeEnd",
  ObservationPlayerInited = "MyselfEvent_ObservationPlayerInited",
  ObservationPlayerHpSpUpdate = "MyselfEvent_ObservationPlayerHpSpUpdate",
  ObservationPlayerOffline = "MyselfEvent_ObservationPlayerOffline",
  ObservationAddPlayer = "MyselfEvent_ObservationAddPlayer",
  ObservationGoldUpdate = "MyselfEvent_ObservationGoldUpdate",
  ObservationClearItem = "MyselfEvent_ObservationClearItem",
  ObservationAttachChanged = "MyselfEvent_ObservationAttachChanged",
  KillNameChange = "MyselfEvent_KillNameChange",
  StartToMove = "StartToMove",
  ObservationSelectPlayer = "MyselfEvent_ObservationSelectPlayer",
  SaveHSpUpdate = "MyselfEvent_SaveHSpUpdate",
  PhotoDonwloadSucc = "MyselfEvent_PhotoDonwloadSucc",
  PhotoDonwloadFailed = "MyselfEvent_PhotoDonwloadFailed",
  PhotoDonwloadTerminated = "MyselfEvent_PhotoDonwloadTerminated",
  PhotoDonwloadRequestMax = "MyselfEvent_PhotoDonwloadRequestMax",
  OnMountFormChange = "MyselfEvent_OnMountFormChange",
  AutoSell = "MyselfEvent_AutoSell",
  SelectTarget_HpChange = "MyselfEvent_SelectTargetHpChange",
  InterferenceValueChange = "MyselfEvent_InterferenceValueChange",
  ForgetSkill_Start = "MyselfEvent_ForgetSkill_Start",
  UpdateRefineBuff = "MyselfEvent_UpdateRefineBuff",
  BeginSkillBroadcast = "MyselfEvent_BeginSkillBroadcast",
  ShowDefAttr = "ShowDefAttr",
  HideDefAttr = "HideDefAttr",
  CheckInvalidSkill = "CheckInvalidSkill",
  SpecialHideBuffAdd = "MyselfEvent_SpecialHideBuffAdd",
  SpecialHideBuffRemove = "MyselfEvent_SpecialHideBuffRemove",
  RidePlayerChange = "MyselfEvent_RidePlayerChange",
  MyPippiChange = "MyselfEvent_MyPippiChange",
  AsEquipChange = "MyselfEvent_AsEquipChange",
  RecallTimeChange = "MyselfEvent_RecallTimeChange"
}
ItemEvent = {
  ItemCmd = "ItemEvent_ItemCmd",
  ItemUpdate = "ItemEvent_ItemUpdate",
  BarrowUpdate = "ItemEvent_BarrowUpdate",
  ItemReArrage = "ItemEvent_ItemReArrage",
  EquipUpdate = "ItemEvent_EquipUpdate",
  FashionUpdate = "ItemEvent_FashionUpdate",
  ItemUse = "ItemEvent_ItemUse",
  BetterEquipAdd = "ItemEvent_BetterEquipAdd",
  CardBagUpdate = "ItemEvent_CardBagUpdate",
  TempBagUpdate = "ItemEvent_TempBagUpdate",
  ClickItem = "ItemEvent_ClickItem",
  DoubleClickItem = "ItemEvent_DoubleClickItem",
  ClickItemTab = "ItemEvent_ClickItemTab",
  GoTraceItem = "ItemEvent_GoTraceItem",
  Equip = "ItemEvent_Equip",
  ReviveItemAdd = "ItemEvent_ReviveItemAdd",
  ReviveItemRemove = "ItemEvent_ReviveItemRemove",
  ItemUseTip = "ItemEvent_ItemUseTip",
  QuestUpdate = "ItemEvent_QuestUpdate",
  FoodUpdate = "ItemEvent_FoodUpdate",
  PetUpdate = "ItemEvent_PetUpdate",
  UseTimeUpdate = "UseTimeUpdate",
  FurnitureUpdate = "ItemEvent_FurnitureUpdate",
  GemUpdate = "ItemEvent_GemUpdate",
  GemDragStart = "ItemEvent_GemDragStart",
  GemDragEnd = "ItemEvent_GemDragEnd",
  GemDelete = "ItemEvent_GemDelete",
  GemPageUpdate = "ItemEvent_GemPageUpdate",
  GemDataUpdate = "ItemEvent_GemDataUpdate",
  PersonalArtifactUpdate = "ItemEvent_PersonalArtifactUpdate",
  ItemDeselect = "ItemEvent_ItemDeselect",
  ItemDeselectLongPress = "ItemEvent_ItemDeselectLongPress",
  ResurrectionToyAdd = "ItemEvent_ResurrectionToyAdd",
  ResurrectionToyRemove = "ItemEvent_ResurrectionToyRemove",
  WalletUpdate = "ItemEvent_WalletUpdate",
  QuickUseItemCheckUpdate = "ItemEvent_QuickUseItemCheckUpdate",
  QuickUseItemCheckEquipUpdate = "ItemEvent_QuickUseItemCheckEquipUpdate",
  StrengthLvUpdate = "ItemEvent_StrengthLvUpdate",
  GuildStrengthLvUpdate = "ItemEvent_GuildStrengthLvUpdate",
  StrengthLvReinit = "ItemEvent_StrengthLvReinit",
  SecretLandUpdate = "EtenEvent_SecretLandUpdate",
  EquipUpgradeSuccess = "ItemEvent_EquipUpgradeSuccess",
  EquipChooseSuccess = "ItemEvent_EquipChooseSuccess",
  EquipIntegrate_TrySelectEquip = "ItemEvent_EquipIntegrate_TrySelectEquip",
  ItemChange = "ItemEvent_ItemChange",
  MemoryUpdate = "ItemEvent_MemoryUpdate",
  SpecialFashionUpdate = "ItemEvent_SpecialFashionUpdate"
}
PackageEvent = {
  OpenBarrowBag = "PackageEvent_OpenBarrowBag",
  ActivateSetShortCut = "PackageEvent_ActivateSetShortCut",
  SwitchMarkingFavoriteMode = "PackageEvent_SwitchMarkingFavoriteMode",
  ShowBord = "PackageEvent_ShowBord",
  EquipTypeChanged = "PackageEvent_EquipTypeChanged"
}
ItemTradeEvent = {
  TradePriceChange = "ItemTradeEvent_TradePriceChange"
}
RoleEquipEvent = {
  TakeOn = "RoleEquipEvent_TakeOn",
  TakeOff = "RoleEquipEvent_TakeOff",
  OffPosBegin = "RoleEquipEvent_OffPosBegin",
  OffPosEnd = "RoleEquipEvent_OffPosEnd",
  AllOffPosEnd = "RoleEquipEvent_AllOffPosEnd",
  ProtectPosBegin = "RoleEquipEvent_ProtectPosBegin",
  ProtectPosEnd = "RoleEquipEvent_ProtectPosEnd",
  AllProtectPosEnd = "RoleEquipEvent_AllProtectPosEnd",
  BreakEquipBegin = "RoleEquipEvent_BreakEquipBegin",
  BreakEquipEnd = "RoleEquipEvent_BreakEquipEnd",
  AllBreakEquipEnd = "RoleEquipEvent_AllBreakEquipEnd"
}
ItemTipEvent = {
  ClickTipFuncEvent = "ItemTipEvent_ClickTipFuncEvent",
  ShowGetPath = "ItemTipEvent_ShowGetPath",
  ShowEquipUpgrade = "ItemTipEvent_ShowEquipUpgrade",
  ShowFashionPreview = "ItemTipEvent_ShowFashionPreview",
  ClickGotoUse = "ItemTipEvent_ClickGotoUse",
  ShowGotoUse = "ItemTipEvent_ShowGotoUse",
  CloseShowGotoUse = "ItemTipEvent_CloseShowGotoUse",
  CloseTip = "ItemTipEvent_CloseTip",
  ConfirmMsgShowing = "ItemTipEvent_ConfirmMsgShowing",
  StoreToAdvManual = "ItemTipEvent_StoreToAdvManual",
  ShowPortraitFramePreview = "ItemTipEvent_ShowPortraitFramePreview",
  ClickItemUrl = "ItemTipEvent_ClickItemUrl",
  ShowAncientRandom = "ItemTipEvent_ShowAncientRandom",
  ClickBufferUrl = "ItemTipEvent_ClickBufferUrl",
  ShowGiftDetail = "ItemTipEvent_ShowGiftDetail"
}
LoadSceneEvent = {
  StartLoad = "LoadSceneEvent_StartLoad",
  FinishLoad = "LoadSceneEvent_FinishLoad",
  BeginLoadScene = "LoadEvent_BeginLoadScene",
  FinishLoadScene = "LoadEvent_FinishLoadScene",
  SceneAnimEnd = "LoadEvent_SceneAnimEnd",
  CloseLoadView = "LoadSceneEvent_CloseLoadView",
  BWTransmitFinished = "LoadSceneEvent_BWTransmitFinished"
}
GameEvent = {
  RestartGame = "GameEvent_RestartGame"
}
SceneUserEvent = {
  SceneAddRoles = "SceneEvent_SceneAddRoles",
  PostAddSceneUser = "SceneEvent_PostAddSceneUser",
  SceneAddNpcs = "SceneEvent_SceneAddNpcs",
  SceneAddPets = "SceneEvent_SceneAddPets",
  SceneRemoveRoles = "SceneEvent_SceneRemoveRoles",
  SceneRemoveNpcs = "SceneEvent_SceneRemoveNpcs",
  SceneRemovePets = "SceneEvent_SceneRemovePets",
  LevelUp = "SceneUserEvent_LevelUp",
  EatHp = "SceneUserEvent_EatHp",
  BaseLevelUp = "SceneUserEvent_BaseLevelUp",
  JobLevelUp = "SceneUserEvent_JobLevelUp",
  ChangeProfession = "SceneUserEvent_ChangeProfession",
  FloatMsg = "SceneUserEvent_FloatMsg",
  ManualLevelUp = "SceneUserEvent_ManualLevelUp",
  AppellationUp = "SceneUserEvent_AppellationUp",
  AchievementTitleChanged = "SceneUserEvent_AchievementTitleChanged",
  NpcSyncMove = "SceneUserEvent_NpcSyncMove",
  AddNpcPosEffect = "SceneUserEvent_AddNpcPosEffect",
  ShowLocalNpcPos = "SceneUserEvent_ShowLocalNpcPos",
  Me_LevelUp = "SceneUserEvent_Me_LevelUp"
}
SceneItemEvent = {
  AddSceneItems = "SceneItemEvent_AddSceneItems",
  RemoveSceneItems = "SceneItemEvent_RemoveSceneItems"
}
SceneCreatureEvent = {
  PropChange = "SceneCreatureEvent_PropChange",
  PropHpChange = "SceneCreatureEvent_PropHpChange",
  CreatureRemove = "SceneCreatureEvent_CreatureRemove",
  DeathBegin = "SceneCreatureEvent_DeathBegin"
}
SceneGlobalEvent = {
  Map2DChanged = "SceneGlobalEvent_Map2DChanged"
}
LoadEvent = {
  StartLoadScene = "StartLoadScene",
  FinishLoadScene = "FinishLoadScene",
  SceneFadeOut = "LoadSceneEvent_SceneFadeOut"
}
MouseEvent = {
  MouseClick = "MouseEvent_MouseClick",
  DoubleClick = "MouseEvent_DoubleClick",
  MousePress = "MouseEvent_MousePress",
  LongPress = "MouseEvent_LongPress"
}
DragDropEvent = {
  SwapObj = "DragDropEvent_SwapObj",
  DropEmpty = "DragDropEvent_DropEmpty",
  StartDrag = "DragDropEvent_StartDrag",
  OnDrag = "DragDropEvent_OnDrag",
  EndDrag = "DragDropEvent_EndDrag"
}
SkillEvent = {
  SkillStartEvent = "SkillEvent_SkillStartEvent",
  SkillUpdate = "SkillEvent_SkillUpdate",
  SkillCastBegin = "SkillEvent_SkillCastBegin",
  SkillCastEnd = "SkillEvent_SkillCastEnd",
  SkillFreeCastBegin = "SkillEvent_SkillFreeCastBegin",
  SkillFreeCastEnd = "SkillEvent_SkillFreeCastEnd",
  SkillWithUseTimesChanged = "SkillEvent_SkillWithUseTimesChanged",
  SkillUnlockPos = "SkillEvent_SkillUnlockPos",
  SkillEquip = "SkillEvent_SkillEquip",
  SkillDisEquip = "SkillEvent_SkillDisEquip",
  SkillFitPreCondtion = "SkillEvent_SkillFitPreCondtion",
  SkillWaitNextUse = "SkillEvent_SkillWaitNextUse",
  SkillCancelWaitNextUse = "SkillEvent_SkillCancelWaitNextUse",
  SkillSelectPhaseStateChange = "SkillEvent_SkillSelectPhaseStateChange",
  AddSubSkill = "SkillEvent_AddSubSkill",
  RemoveSubSkill = "SkillEvent_RemoveSubSkill",
  UpdateSubSkill = "SkillEvent_UpdateSubSkill",
  ChangeIcon = "SkillEvent_ChangeIcon",
  DynamicProps = "SkillEvent_DynamicProps",
  BreakCastBegin = "SkillEvent_BreakCastBegin",
  BreakCastEnd = "SkillEvent_BreakCastEnd",
  SyncCastBegin = "SkillEvent_SyncCastBegin",
  StopSyncCast = "SkillEvent_StopSyncCast",
  SkillWaitNextCombo = "SkillEvent_SkillWaitNextCombo",
  SkillCancelWaitNextCombo = "SkillEvent_SkillCancelWaitNextCombo",
  ClearLockTarget = "SkillEvent_ClearLockTarget",
  UpdateQuestSkill = "SkillEvent_UpdateQuestSkill",
  ShowTargetPointTip = "SkillEvent_ShowTargetPointTip",
  HideTargetPointTip = "SkillEvent_HideTargetPointTip",
  BreakSkillEffect = "SkillEvent_BreakSkillEffect",
  UpdateCDTimes = "SkillEvent_UpdateCDTimes",
  CheckSkillForbid = "SkillEvent_CheckSkillForbid",
  EnterWarehouse = "SkillEvent_EnterWarehouse",
  LeaveWarehouse = "SkillEvent_LeaveWarehouse",
  BellCharge = "SkillEvent_BellCharge"
}
QuestEvent = {
  QuestDelete = "QuestEvent_QuestDelete",
  QuestAdd = "QuestEvent_QuestAdd",
  QuestEnterArea = "QuestEvent_QuestEnterArea",
  QuestExitArea = "QuestEvent_QuestExitArea",
  ProcessChange = "QuestEvent_ProcessChange",
  RemoveHelpQuest = "QuestEvent_RemoveHelpQuest",
  UpdateAnnounceQuest = "QuestEvent_UpdateAnnounceQuest",
  UpdateAnnounceQuestList = "QuestEvent_UpdateAnnounceQuestList",
  RemoveGuildQuestList = "QuestEvent_RemoveGuildQuestList",
  UpdateGuildQuestList = "QuestEvent_UpdateGuildQuestList",
  ShowManualGoEffect = "QuestEvent_ShowManualGoEffect",
  DelDahuangEvent = "QuestEvent_DelDahuangEvent",
  ShowChasingSceneDialog = "ShowChasingSceneDialog",
  QuestRepairMode = "QuestEvent_QuestRepairMode",
  QuestTraceOff = "QuestEvent_QuestTraceOff",
  QuestTraceChange = "QuestEvent_QuestTraceChange",
  QuestTraceClickQuest = "QuestEvent_QuestTraceClickQuest",
  QuestTraceSwitchPage = "QuestEvent_QuestTraceSwitchPage",
  QuestTraceShowList = "QuestEvent_QuestTraceShowList",
  QuestTraceSwitch = "QuestEvent_QuestTraceSwitch",
  QuestTracePanelOff = "QuestEvent_QuestTracePanelOff",
  QuestTraceNotice = "QuestEvent_QuestTraceNotice",
  QuestTraceShowPuzzleImage = "QuestEvent_QuestTraceShowPuzzleImage"
}
PostEvent = {
  PostDelete = "PostEvent_PostDelete",
  PostAdd = "PostEvent_PostAdd",
  PostUpdate = "PostEvent_PostUpdate",
  PostExpire = "PostEvent_PostExpire"
}
DialogEvent = {
  CloseDialog = "DialogEvent_CloseDialog",
  AddMenuEvent = "DialogEvent_AddMenuEvent",
  CameraFoucsOffNpc = "DialogEvent_CameraFoucsOffNpc",
  NpcFuncStateChange = "DialogEvent_NpcFuncStateChange",
  AddUpdateSetTextCall = "DialogEvent_AddUpdateSetTextCall",
  ServerOpenFunction = "DialogEvent_ServerOpenFunction"
}
MainViewEvent = {
  ShowOrHide = "MainViewEvent_ShowOrHide",
  NewPlayerHide = "MainViewEvent_NewPlayerHide",
  ActiveShortCutBord = "MainViewEvent_ActiveShortCutBord",
  TopFuncActive = "MainViewEvent_TopFuncActive",
  AddQuestFocus = "MainViewEvent_AddQuestFocus",
  RemoveQuestFocus = "MainViewEvent_RemoveQuestFocus",
  AddItemTrace = "MainViewEvent_AddItemTrace",
  CancelItemTrace = "MainViewEvent_CancelItemTrace",
  EmojiViewShow = "MainViewEvent_EmojiViewShow",
  EmojiBtnClick = "MainViewEvent_EmojiBtnClick",
  MenuActivityOpen = "MainViewEvent_MenuActivityOpen",
  MenuActivityClose = "MainViewEvent_MenuActivityClose",
  UpdateMatchBtn = "MainViewEvent_UpdateMatchBtn",
  UpdateTutorMatchBtn = "MainViewEvent_UpdateTutorMatchBtn",
  ShowMapBord = "MainViewEvent_ShowMapBord",
  MiniMapSettingChange = "MainViewEvent_MiniMapSettingChange",
  ClearViewSequence = "MainViewEvent_ClearViewSequence",
  HideMapForbidNode = "MainViewEvent_HideMapForbidNode",
  ShowMapForbidNode = "MainViewEvent_ShowMapForbidNode",
  ShowQuestTraceBoard = "MainViewEvent_ShowQuestTraceBoard",
  CloseQuestTraceBoard = "MainViewEvent_CloseQuestTraceBoard",
  RefreshCameraStatus = "MainViewEvent_RefreshCameraStatus",
  AddSubView = "MainViewEvent_AddSubView",
  RemoveSubView = "MainViewEvent_RemoveSubView",
  AddDungeonInfoBord = "MainViewEvent_AddDungeonInfoBord",
  RemoveDungeonInfoBord = "MainViewEvent_RemoveDungeonInfoBord",
  GetIconTexture = "MainViewEvent_GetIconTexture",
  PetInfoUpdate = "MainViewEvent_PetInfoUpdate",
  ShowOrHideHead = "MainViewEvent_ShowOrHideHead",
  SaveKapraUpdate = "MainViewEvent_SaveKapraUpdate",
  CameraModeChange = "MainViewEvent_CameraModeChange",
  BigCatInvadeUpdate = "MainViewEvent_BigCatInvadeUpdate",
  SpaceDragonCellClick = "SpaceDragonCellClick"
}
InviteConfirmEvent = {
  AddInvite = "InviteConfirmEvent_AddInvite",
  RemoveInviteByType = "InviteConfirmEvent_RemoveInviteByType",
  Agree = "InviteConfirmEvent_Agree",
  Refuse = "InviteConfirmEvent_Refuse",
  TimeOver = "InviteConfirmEvent_TimeOver",
  RollInviteTimeOver = "InviteConfirmEvent_RollInviteTimeOver",
  Courtship_OutDistance = "InviteConfirmEvent_Courtship_OutDistance",
  TempHide = "InviteConfirmEvent_TempHide",
  RecoverFromTempHide = "InviteConfirmEvent_RecoverFromTempHide"
}
EmojiEvent = {
  PlayEmoji = "EmojiEvent_PlayEmoji",
  ShowBord = "EmojiEvent_ShowBord",
  HideBord = "EmojiEvent_HideBord",
  SwapEmoji = "EmojiEvent_SwapObj",
  DeleteEmoji = "EmojiEvent_DeleteEmoji"
}
ActionEvent = {
  PlayEmojiAction = "ActionEvent_PlayEmojiAction",
  PlayNormalAction = "ActionEvent_PlayNormalAction"
}
WorldMapEvent = {
  ShowLevelDetail = "WorldMapEvent_ShowLevelDetail",
  NewKnownMap = "WorldMapEvent_NewKnownMap",
  StartTrace = "WorldMapEvent_StartTrace"
}
ChangeProfessionPanelEvent = {
  SelectTargetChange = "ChangeProfessionPanelEvent_SelectTargetChange",
  UpdateSlotIndex = "ChangeProfessionPanelEvent_UpdateSlotIndex"
}
TeamEvent = {
  NewApply = "TeamEvent_NewApply",
  MemberChangeMap = "TeamEvent_MemberChangeMap",
  MemberEnterTeam = "TeamEvent_MemberEnterTeam",
  MemberExitTeam = "TeamEvent_MemberExitTeam",
  MemberOffline = "TeamEvent_MemberOffline",
  MemberAfkChange = "TeamEvent_MemberAfkChange",
  MemberOnline = "TeamEvent_MemberOnline",
  MyLeaderChange = "TeamEvent_MyLeaderChange",
  ChangeMap = "TeamEvent_ChangeMap",
  ExitTeam = "TeamEvent_ExitTeam",
  VoiceChange = "TeamEvent_VoiceChange",
  VoiceBan = "TeamEvent_VoiceBan",
  MemberEnterGroup = "TeamEvent_MemberEnterGroup",
  MemberExitGroup = "TeamEvent_MemberExitGroup",
  ExitGroup = "TeamEvent_ExitGroup",
  GroupLeaderChanged = "TeamEvent_GroupLeaderChanged",
  MyImageChanged = "TeamEvent_MyImageChanged",
  TeamOption_SelectRole = "TeamOption_SelectRole",
  TeamOption_DeleteRole = "TeamOption_DeleteRole",
  CancelMemberSelect = "TeamEvent_CancelMemberSelect",
  UpdateRecruitTeamInfo = "TeamEvent_UpdateRecruitTeamInfo",
  TeamInviteBtnClick = "TeamEvent_TeamInviteBtnClick"
}
GuildEvent = {
  GuildUpgrade = "GuildEvent_GuildUpgrade",
  VoiceChange = "Guild_VoiceChange",
  GetAssembleReward = "Guild_GetAssembleReward",
  ExitMercenary = "Guild_ExitMercenary",
  EnterMercenary = "Guild_EnterMercenary",
  GuildBattleClientRefused = "GuildEvent_GuildBattleClientRefused"
}
GuildDateBattleEvent = {
  ChooseDate = "GuildDateBattleEvent_ChooseDate",
  ChooseClock = "GuildDateBattleEvent_ChooseClock",
  CloseGuildFindView = "GuildDateBattleEvent_CloseGuildFindPage",
  ChooseMode = "GuildDateBattleEvent_ChooseMode"
}
GuildChallengeEvent = {
  CloseUI = "GuildChallengeEvent_CloseUI"
}
CarrierEvent = {
  ShowUI = "CarrierEvent_ShowUI",
  MyCarrierStart = "CarrierEvent_MyCarrierStart",
  MyCarrierLeaveMember = "CarrierEvent_MyCarrierLeaveMember"
}
RefineEvent = {
  SelectEquip = "RefineEvent_SelectEquip"
}
HappyShopEvent = {
  SelectIconSprite = "HappyShopEvent_SelectIconSprite",
  ExchangeBtnClick = "HappyShopEvent_ExchangeBtnClick",
  GiftItemClick = "HappyShopEvent_GiftItemClick"
}
TriggerEvent = {
  AddTrigger = "TriggerEvent_AddTrigger",
  RemoveTrigger = "TriggerEvent_RemoveTrigger",
  Enter_GDFightForArea = "TriggerEvent_Enter_GDFightForArea",
  Leave_GDFightForArea = "TriggerEvent_Leave_GDFightForArea",
  Remove_GDFightForArea = "TriggerEvent_Remove_GDFightForArea",
  Enter_OthelloCheckpoint = "TriggerEvent_Enter_OthelloCheckpoint",
  Leave_OthelloCheckpoint = "TriggerEvent_Leave_OthelloCheckpoint",
  Remove_OthelloCheckpoint = "TriggerEvent_Remove_OthelloCheckpoint",
  Enter_TwelvePVPShopTrigger = "TriggerEvent_Enter_TwelvePVPShopTrigger",
  Leave_TwelvePVPShopTrigger = "TriggerEvent_Leave_OthelloCheckpoint",
  Remove_TwelvePVPShopTrigger = "TriggerEvent_Remove_OthelloCheckpoint",
  Enter_AIArea = "TriggerEvent_Enter_AIArea",
  Leave_AIArea = "TriggerEvent_Leave_AIArea",
  Leave_AIAway = "TriggerEvent_Leave_AIAway",
  Enter_EndlessBattleFieldEventArea = "TriggerEvent_Enter_EndlessBattleFieldEventArea",
  Leave_EndlessBattleFieldEventArea = "TriggerEvent_Leave_EndlessBattleFieldEventArea",
  Remove_EndlessBattleFieldEventArea = "TriggerEvent_Remove_EndlessBattleFieldEventArea",
  Enter_EndlessBattle_OccupyArea = "TriggerEvent_Enter_EndlessBattle_OccupyArea",
  Leave_EndlessBattle_OccupyArea = "TriggerEvent_Leave_EndlessBattle_OccupyArea",
  Remove_EndlessBattle_OccupyArea = "TriggerEvent_Remove_EndlessBattle_OccupyArea",
  EnterAybssLakeBattleArea = "TriggerEvent_EnterAybssLakeBattleArea",
  LeaveAybssLakeBattleArea = "TriggerEvent_LeaveAybssLakeBattleArea",
  RemoveAybssLakeBattleArea = "TriggerEvent_RemoveAybssLakeBattleArea",
  EnterAbyssDragonArea = "TriggerEvent_EnterAbyssDragonArea",
  LeaveAbyssDragonArea = "TriggerEvent_LeaveAbyssDragonArea",
  RemoveAbyssDragonArea = "TriggerEvent_RemoveAbyssDragonArea"
}
ChatRoomEvent = {
  HavePrivateChatMsg = "ChatRoomEvent_HavePrivateChatMsg",
  PresetText = "ChatRoomEvent_PresetText",
  OpenPopWindow = "ChatRoomEvent_OpenPopWindow",
  UpdateSelectChat = "ChatRoomEvent_UpdateSelectChat",
  SystemMessage = "ChatRoomEvent_SystemMessage",
  PrivateSelfMessage = "ChatRoomEvent_PrivateSelfMessage",
  SelectHead = "ChatRoomEvent_SelectHead",
  CancelCreateChatRoom = "ChatRoomEvent_CancelCreateChatRoom",
  KeywordEffect = "ChatRoomEvent_KeywordEffect",
  StopRecognizer = "ChatRoomEvent_StopRecognizer",
  SendSpeech = "ChatRoomEvent_SendSpeech",
  StartVoice = "ChatRoomEvent_StartVoice",
  StopVoice = "ChatRoomEvent_StopVoice",
  BarrageEffect = "ChatRoomEvent_BarrageEffect",
  ChangeChannel = "ChatRoomEvent_ChangeChannel",
  UpdatePrivateChatRed = "UpdatePrivateChatRed",
  UpdateCurChannel = "ChatRoomEvent_UpdateCurChannel",
  OnRedPacketSendViewEnter = "OnRedPacketSendViewEnter",
  OnRedPacketSendViewExit = "OnRedPacketSendViewExit",
  UpdateFunctionCurPage = "ChatRoomEvent_UpdateFunctionCurPage",
  AutoSendMessageEvent = "ChatRoomEvent_AutoSendMessageEvent",
  AutoSendPrivateEvent = "ChatRoomEvent_AutoSendPrivateEvent",
  AutoSendSysmsgEvent = "ChatRoomEvent_AutoSendSysmsgEvent",
  AutoSendKeywordEffect = "ChatRoomEvent_AutoSendKeywordEffect"
}
ChatZoomEvent = {
  ShowTip = "ChatZoomEvent_ShowTip",
  HideTip = "ChatZoomEvent_HideTip",
  TransmitChatZoomSummary = "ChatZoomEvent_TransmitChatZoomSummary",
  TranslateMemberTipStyle = "ChatZoomEvent_TranslateMemberTipStyle"
}
CreateRoleViewEvent = {
  HairStyleClick = "CreateRoleViewEvent_HairStyleClick",
  HeadwearClick = "CreateRoleViewEvent_HeadwearClick",
  PlayerMapChange = "CreateRoleViewEvent_PlayerMapChange"
}
NewCreateRoleViewEvent = {
  ProfRouletteSelect = "NewCreateRoleViewEvent_ProfRouletteSelect"
}
EquipChooseCellEvent = {
  ClickItemIcon = "EquipChooseCellEvent_ClickItemIcon",
  ClickCancel = "EquipChooseCellEvent_ClickCancel",
  CountChooseChange = "EquipChooseCellEvent_CountChooseChange",
  CountChooseCheck = "EquipChooseCellEvent_CountChooseCheck"
}
TopicEvent = {
  ClickLayer = "TopicEvent_ClickLayer"
}
GemEvent = {
  ClickProfession = "GemEvent_ClickProfession",
  ProfessionChanged = "GemEvent_ProfessionChanged",
  ChooseTargetProfession = "GemEvent_ChooseTargetProfession"
}
EquipRecoverEvent = {
  Select = "EquipRecoverEvent_Select"
}
ShopSaleEvent = {
  canelSale = "ShopSaleEvent_canelSale",
  SelectIconSprite = "ShopSaleEvent_SelectIconSprite",
  SaleSuccess = "ShopSaleEvent_SaleSuccess"
}
PictureWallDataEvent = {
  PhotoCompleteCallback = "PictureWallDataEvent_PhotoCompleteCallback",
  PhotoProgressCallback = "PictureWallDataEvent_PhotoProgressCallback",
  MapEnd = "PictureWallDataEvent_MapEnd",
  ShowRedTip = "PictureWallDataEvent_ShowRedTip",
  SelectedPicChange = "PictureWallDataEvent_SelectedPicChange"
}
AdventureDataEvent = {
  AdDataFashUpdate = "AdventureDataEvent_AdDataFashUpdate",
  AdDataCardUpdate = "AdventureDataEvent_AdDataCardUpdate",
  AdDataEquipUpdate = "AdventureDataEvent_AdDataEquipUpdate",
  AdDataItemUpdate = "AdventureDataEvent_AdDataItemUpdate",
  AdDataMountUpdate = "AdventureDataEvent_AdDataMountUpdate",
  AdDataMonsterUpdate = "AdventureDataEvent_AdDataMonsterUpdate",
  AdDataNpcUpdate = "AdventureDataEvent_AdDataNpcUpdate",
  SceneManualQueryManualData = "AdventureDataEvent_SceneManualManualUpdate",
  SceneManualManualUpdate = "AdventureDataEvent_SceneManualManualUpdate",
  SceneItemsUpdate = "AdventureDataEvent_SceneItemsUpdate",
  ThumbnailCompleteCallback = "AdventureDataEvent_ThumbnailCompleteCallback",
  ThumbnailTextureCompleteCallback = "AdventureDataEvent_ThumbnailTextureCompleteCallback",
  ThumbnailErrorCallback = "AdventureDataEvent_ThumbnailErrorCallback",
  ThumbnailProgressCallback = "AdventureDataEvent_ThumbnailProgressCallback",
  PhotoCompleteCallback = "AdventureDataEvent_PhotoCompleteCallback",
  PhotoProgressCallback = "AdventureDataEvent_PhotoProgressCallback",
  PhotoErrorCallback = "AdventureDataEvent_PhotoErrorCallback",
  SceneManualManualInit = "AdventureDataEvent_SceneManualManualInit",
  ClearExitEvent = "AdventureDataEvent_ClearExitEvent"
}
FollowEvent = {
  Follow = "FollowEvent_Follow",
  CancelFollow = "FollowEvent_CancelFollow"
}
SystemMsgEvent = {
  MenuMsg = "SystemMsgEvent.MenuMsg",
  MenuCoinPop = "SystemMsgEvent.MenuCoinPop",
  MenuItemPop = "SystemMsgEvent.MenuItemPop",
  NoticeMsg = "SystemMsgEvent.NoticeMsg",
  RaidAdd = "SystemMsgEvent.RaidAddMsg",
  RaidRemove = "SystemMessage.RaidRemove",
  NoticeMsgHide = "SystemMsgEvent.NoticeMsgHide"
}
SealEvent = {
  ShowSlider = "SealEvent_ShowSlider",
  HideSlider = "SealEvent_HideSlider"
}
MissionCommandEvent = {
  MissionCommandEvent = "MissionCommandEvent"
}
PhotographModeChangeEvent = {
  ModeChangeEvent = "PhotographModeChangeEvent_ModeChangeEvent"
}
EquipRecommendMainNewEvent = {
  OnStartDragEvent = "EquipRecommendMainNewEvent_OnStartDragEvent",
  OnEndDragEvent = "EquipRecommendMainNewEvent_OnEndDragEvent",
  OnCursorEvent = "EquipRecommendMainNewEvent_OnCursorEvent",
  RecvProfessionQueryUserCmd = "EquipRecommendMainNewEvent_RecvProfessionQueryUserCmd"
}
EndlessBattleFieldEvent = {
  EnterCalm = "EndlessBattleFieldEvent_EnterCalm",
  EnterFinal = "EndlessBattleFieldEvent_EnterFinal",
  EnterEvent = "EndlessBattleFieldEvent_EnterEvent",
  EnterWait = "EndlessBattleFieldEvent_EnteWait",
  StatueUpdate = "EndlessBattleFieldEvent_StatueUpdate",
  OccupyScoreUpdate = "EndlessBattleFieldEvent_OccupyScoreUpdate",
  PointUpdate = "EndlessBattleFieldEvent_PointUpdate",
  PreLaunchStatue = "EndlessBattleField_PreLaunchStatue"
}
MiniMapEvent = {
  ExitPointStateChange = "MiniMapEvent_ExitPointStateChange",
  ShowMiniMapDirEffect = "MiniMapEvent_ShowMiniMapDirEffect",
  ExitPointReInit = "MiniMapEvent_ExitPointReInit",
  CreatureScenicChange = "MiniMapEvent_CreatureScenicChange",
  CreatureScenicAdd = "MiniMapEvent_CreatureScenicAdd",
  CreatureScenicRemove = "MiniMapEvent_CreatureScenicRemove",
  GvgDroiyan_ = "",
  GvgDroiyan_ = "",
  AddCircleArea = "MiniMapEvent_AddCircleArea",
  RemoveCircleArea = "MiniMapEvent_RemoveCircleArea",
  ActivePart = "MiniMapEvent_ActivePart",
  ShowSymbolHint = "MiniMapEvent_ShowSymbolHint"
}
FriendEvent = {
  SelectHead = "FriendEvent_SelectHead"
}
BlacklistEvent = {
  SelectHead = "BlacklistEvent_SelectHead"
}
GuideEvent = {
  ShowBubble = "GuideEvent_ShowBubble",
  ShowAutoFightBubble = "GuideEvent_ShowAutoFightBubble",
  AutoFightMonster = "GuideEvent_AutoFightMonster",
  MiniMapAnim = "GuideEvent_MiniMapAnim",
  SessionShopQueryShopConfigCmd = "GuideEvent_SessionShopQueryShopConfigCmd",
  MapGuide_Change = "GuideEvent_MapGuide_Change",
  OnGuideStart = "GuideEvent_OnGuideStart",
  OnGuideEnd = "GuideEvent_OnGuideEnd",
  OnForceGuideStart = "GuideEvent_OnForceGuideStart",
  OnForceGuideEnd = "GuideEvent_OnForceGuideEnd",
  AdjustQuestList = "GuideEvent_AdjustQuestList",
  CloseMiniMapAnim = "GuideEvent_CloseMiniMapAnim",
  TargetRegisted = "GuideEvent_TargetRegisted",
  UnTargetRegisted = "GuideEvent_UnTargetRegisted",
  TargetGuideSuccess = "GuideEvent_TargetGuideSuccess"
}
BeautifulAreaPhotoNeting = {
  OnProgress = "BeautifulAreaPhotoNeting_OnProgress",
  OnComplete = "BeautifulAreaPhotoNeting_OnComplete"
}
SystemUnLockEvent = {
  ShowNextEvent = "SystemUnLockEvent.ShowNextEvent",
  UnLockMenuEvent = "SystemUnLockEvent.UnLockMenuEvent",
  NUserNewMenu = "SystemUnLockEvent.NUserNewMenu",
  CommonUnlockInfo = "SystemUnLockEvent_CommonUnlockInfo",
  UnlockAstrolabe = "SystemUnLockEvent_UnlockAstrolabe"
}
ShopMallEvent = {
  ExchangeClickFatherTypes = "ShopMallEvent_ExchangeClickFatherTypes",
  ExchangeClassifyClickIcon = "ShopMallEvent_ExchangeClassifyClickIcon",
  ExchangeCloseBuyInfo = "ShopMallEvent_ExchangeCloseBuyInfo",
  ExchangeCloseSellInfo = "ShopMallEvent_ExchangeCloseSellInfo",
  ExchangeSearchOpenDetail = "ShopMallEvent_ExchangeSearchOpenDetail",
  ExchangeUpdateBuyView = "ShopMallEvent_ExchangeUpdateBuyView",
  ExchangeSelectFriend = "ShopMallEvent_ExchangeSelectFriend"
}
ExchangeShopEvent = {
  ExchangeShopShow = "ExchangeShopShow"
}
NewLoginEvent = {
  LoginFailure = "NewLoginEvent_LoginFailure",
  StartLogin = "NewLoginEvent_StartLogin",
  UpdateServerList = "NewLoginEvent_UpdateServerList",
  StartSdkLogin = "NewLoginEvent_StartSdkLogin",
  EndSdkLogin = "NewLoginEvent_EndSdkLogin",
  ConnectServerFailure = "NewLoginEvent_ConnectServerFailure",
  ReqLoginUserCmd = "NewLoginEvent_ReqLoginUserCmd",
  StopReconnect = "NewLoginEvent_StopReconnect",
  StartReconnect = "NewLoginEvent_StartReconnect",
  StartShowWaitingView = "NewLoginEvent_StartShowWaitingView",
  StopShowWaitingView = "NewLoginEvent_StopShowWaitingView",
  LaunchFailure = "NewLoginEvent_LaunchFailure",
  SDKLoginFailure = "NewLoginEvent_SDKLoginFailure",
  DisableLoginCollider = "NewLoginEvent_DisableLoginCollider",
  EnableLoginCollider = "NewLoginEvent_EnableLoginCollider",
  TrafficCheckFinish = "NewLoginEvent_TrafficCheckFinish",
  LogoutEvent = "NewLoginEvent_LogoutEvent",
  ConfirmAgreement = "NewLoginEvent_ConfirmAgreement",
  RequestNewServerInfo = "NewLoginEvent_RequestNewServerInfo,"
}
EventFromLogin = {
  ShowAnnouncement = "EventFromLogin_ShowAnnouncement"
}
VisitNpcEvent = {
  TargetChange = "VisitNpcEvent_TargetChange",
  AccessNpc = "VisitNpcEvent_AccessNpc",
  AccessNpcEnd = "VisitNpcEvent_AccessNpcEnd"
}
SetEvent = {
  OnShowSettingUpdated = "SetEvent_OnShowSettingUpdated",
  ShowMyselfName = "SetEvent_ShowMyselfName",
  ShowMyFollowerName = "SetEvent_ShowMyFollowerName",
  ShowOtherName = "SetEvent_ShowOtherName",
  ShowOtherModel = "SetEvent_ShowOhterModel",
  ShowNpcName = "SetEvent_ShowNpcName",
  CameraCtrlChange = "SetEvent_CameraCtrlChange",
  SetShowVoicePart = "SetEvent_SetShowVoicePart"
}
SkyWheel = {
  Select = "SkyWheel_Select",
  CloseAccept = "SkyWheel_CloseAccept",
  ChangeTarget = "SkyWheel_ChangeTarget"
}
DojoEvent = {
  EnterSuccess = "DojoEvent_EnterSuccess"
}
LoginRoleEvent = {
  UIRoleBeSelected = "LoginRole_UIRoleBeSelected"
}
EDViewEvent = {
  ActiveLuPinWord = "EDView_ActiveLuPinWord"
}
TempItemEvent = {
  TempWarnning = "TempItemEvent_TempWarnning"
}
ChangeHeadEvent = {
  Select = "ChangeHead_Select"
}
PlotStoryViewEvent = {
  AddButton = "PlotStoryEvent_AddButton",
  PlaySubTitle = "PlotStoryEvent_PlaySubTitle",
  HideSubTitle = "PlotStoryEvent_HideSubTitle",
  PlayNarrator = "PlotStoryEvent_PlayNarrator",
  StartPlot = "PlotStoryViewEvent_StartPlot",
  EndPlot = "PlotStoryViewEvent_EndPlot",
  MainUIFadeIn = "PlotStoryEvent_MainUIFadeIn",
  ShowRoleController = "PlotStoryEvent_ShowRoleController",
  HideRoleController = "PlotStoryEvent_HideRoleController",
  ShowBgmButton = "PlotStoryEvent_ShowBgmButton",
  AddCredits = "PlotStoryEvent_AddCredits",
  AddEDImage = "PlotStoryEvent_AddEDImage",
  AddPicture = "PlotStoryEvent_AddPicture",
  RemovePicture = "PlotStoryEvent_RemovePicture",
  HideMask = "PlotStoryEvent_HideMask",
  AddUIPrefab = "PlotStoryEvent_AddUIPrefab",
  RemoveUIPrefab = "PlotStoryEvent_RemoveUIPrefab",
  PlayEDVideo = "PlotStoryEvent_PlayEDVideo",
  StartBWLoadingMask = "PlotStoryEvent_StartBWLoadingMask",
  StopBWLoadingMask = "PlotStoryEvent_StopBWLoadingMask"
}
CardMakeEvent = {
  Select = "CardMakeEvent_Select",
  Select_BossCard = "CardMakeEvent_SelectBosscard"
}
AstrolabeEvent = {
  TipClose = "AstrolabeEvent_TipClose"
}
CardPosChoosePopUpEvent = {
  ChoosePos = "CardPosChoosePopUp_ChoosePos"
}
FoodEvent = {
  MakeStateChange = "FoodEvent_MakeStateChange",
  PutMaterials = "FoodEvent_PutMaterials",
  MaterialExp_LvUp = "MaterialExp_LvUp",
  FoodEatExp_LvUp = "FoodEatExp_LvUp",
  FoodCookExp_LvUp = "FoodCookExp_LvUp",
  FoodGetPopUp_Enter = "FoodGetPopUp_Enter",
  FoodGetPopUp_Exit = "FoodGetPopUp_Exit"
}
ShareEvent = {
  ClickPlatform = "ShareEvent_ClickPlatform"
}
LotteryEvent = {
  Select = "LotteryEvent_Select",
  EffectStart = "LotteryEvent_EffectStart",
  EffectEnd = "LotteryEvent_EffectEnd",
  MagicPictureComplete = "LotteryEvent_MagicPictureComplete",
  RefreshCost = "LotteryEvent_RefreshCost",
  LotteryViewEnter = "LotteryEvent_LotteryViewEnter",
  LotteryViewClose = "LotteryEvent_LotteryViewClose",
  NewLotteryAnimationStart = "LotteryEvent_NewLotteryAnimationStart",
  NewLotteryAnimationEnd = "LotteryEvent_NewLotteryAnimationEnd",
  RecvLotteryDollResult = "LotteryEvent_RecvLotteryDollResult",
  RecvLotteryCardNewResult = "LotteryEvent_RecvLotteryCardNewResult",
  MixShopSiteChanged = "LotteryEvent_MixShopSiteChanged",
  MixShopYearChanged = "LotteryEvent_MixShopYearChanged",
  MixShopYearManualChanged = "LotteryEvent_MixShopYearManualChanged",
  MixShopTogChanged = "LotteryEvent_MixShopTogChanged",
  MixShopFilterChanged = "LotteryEvent_MixShopFilterChanged"
}
PetEvent = {
  AddCatchPetBord = "PetEvent_AddCatchPetBord",
  RemoveCatchPetBord = "PetEvent_RemoveCatchPetBord",
  BeingInfoData_SummonChange = "PetEvent_BeingInfoData_SummonChange",
  BeingInfoData_AliveChange = "PetEvent_BeingInfoData_AliveChange",
  Being_CountChange = "PetEvent_Being_CountChange",
  ClickPetAdventureIcon = "PetEvent_ClickIcon",
  SendHug = "PetEvent_SendHug"
}
AuctionEvent = {
  FinishCountdown = "AuctionEvent_FinishCountdown"
}
QuickBuyEvent = {
  Refresh = "QuickBuyEvent_Refresh",
  Select = "QuickBuyEvent_Select",
  Close = "QuickBuyEvent_Close",
  CloseUI = "QuickBuyEvent_CloseUI"
}
RecallEvent = {
  Select = "RecallEvent_Select"
}
GuildBuildingEvent = {
  SubmitMaterial = "GuildBuildingEvent_submitMaterial",
  OnClickBuildBtn = "GuildBuildingEvent_OnClickBuildBtn",
  OnClickIcon = "GuildBuildingEvent_OnClickIcon",
  OnClickItemIcon = "GuildBuildingEvent_OnClickItemIcon"
}
ZenyShopEvent = {
  CanPurchase = "ZenyShopEvent_CanPurchase",
  OpenBoxCollider = "OpenBoxCollider",
  CloseBoxCollider = "CloseBoxCollider"
}
WeddingEvent = {
  Buy = "WeddingEvent_Buy",
  Select = "WeddingEvent_Select"
}
SelectFriendEvent = {
  Select = "SelectFriendEvent_Select"
}
PushEvent = {
  OnReceiveNotification = "PushEvent_OnReceiveNotification",
  OnReceiveMessage = "PushEvent_OnReceiveMessage",
  OnOpenNotification = "PushEvent_OnOpenNotification",
  OnJPushTagOperateResult = "PushEvent_OnJPushTagOperateResult",
  OnJPushAliasOperateResult = "PushEvent_OnJPushAliasOperateResult"
}
TouchEvent = {
  ExitFreeCamera = "TouchEvent_ExitFreeCamera"
}
AudioHDEvent = {
  OnReceiveAudioLabel1 = "AudioHDEvent_OnReceiveAudioHint1",
  OnReceiveAudioLabel2 = "AudioHDEvent_OnReceiveAudioHint2",
  OnReceiveAudioBtn3 = "AudioHDEvent_OnReceiveAudioBtn3"
}
AudioPackageDownloadEvent = {
  OnInfoUpdate = "AudioPackageDownloadEvent_OnInfoUpdate"
}
FinanceEvent = {
  ShowDetail = "FinanceEvent_ShowDetail"
}
BoothEvent = {
  ShowMiniBooth = "BoothEvent_ShowMiniBooth",
  AddItem = "BoothEvent_AddItem",
  CloseInfo = "BoothEvent_CloseInfo",
  ConfirmInfo = "BoothEvent_ConfirmInfo",
  ChangeInfo = "BoothEvent_ChangeInfo",
  OpenBooth = "BoothEvent_OpenBooth",
  CloseBooth = "BoothEvent_CloseBooth",
  ChangeName = "BoothEvent_ChangeName"
}
QuestManualEvent = {
  BeforeGoClick = "QuestManualEvent_BeforeGoClick",
  GoClick = "QuestManualEvent_GoClick",
  AwardClick = "QuestManualEvent_AwardClick",
  PoemClick = "QuestManualEvent_PoemClick",
  ItemCellClick = "QuestManualEvent_ItemCellClick",
  FuncOpenCategoryClick = "QuestManualEvent_FuncOpenCategoryClick",
  FuncOpenToggleClick = "QuestManualEvent_FuncOpenToggleClick",
  PlotVoiceClick = "QuestManualEvent_PlotVoiceClick",
  PlotQuestClick = "QuestManualEvent_PlotQuestClick",
  RemoveNodeChooseState = "QuestManualEvent_RemoveNodeChooseState"
}
HotKeyEvent = {
  UseShortCutSkill = "HotKeyEvent_UseShortCutSkill",
  SwitchShortCutSkillIndex = "HotKeyEvent_SwitchShortCutSkillIndex",
  UseShortCutItem = "HotKeyEvent_UseShortCutItem",
  OpenMap = "HotKeyEvent_OpenMap",
  Send = "HotKeyEvent_Send",
  OpenTeamView = "HotKeyEvent_OpenTeamView",
  DialogPushOn = "HotKeyEvent_DialogPushOn",
  DialogSelectOption = "HotKeyEvent_DialogSelectOption",
  AimMonsterSelectTarget = "HotKeyEvent_AimMonsterSelectTarget",
  SelectMember = "HotKeyEvent_SelectMember",
  FollowSelectMember = "HotKeyEvent_FollowSelectMember",
  OpenAutoBattleConfig = "HotKeyEvent_OpenAutoBattleConfig",
  Interact = "HotKeyEvent_Interact",
  SelectOption = "HotKeyEvent_SelectOption",
  ClosePopView = "HotKeyEvent_ClosePopView",
  QuestGuide = "HotKeyEvent_QuestGuide",
  CloseChatRoom = "HotKeyEvent_CloseChatRoom"
}
StageEvent = {
  ChangeCountDown = "ChangeCountDown",
  CloseStageUI = "CloseStageUI"
}
ServantImproveEvent = {
  TraceBtnClick = "ServantImproveEvent_TraceBtnClick",
  FunctionListUpdate = "ServantImproveEvent_FunctionListUpdate",
  ItemListUpdate = "ServantImproveEvent_ItemListUpdate",
  GiftProgressUpdate = "ServantImproveEvent_GiftProgressUpdate",
  JiHuaIconClick = "ServantImproveEvent_JiHuaIconClick",
  BeforeGoClick = "ServantImproveEvent_BeforeGoClick",
  GoClick = "ServantImproveEvent_GoClick",
  GotomodeTrace = "ServantImproveEvent_GoClick_GotomodeTrace"
}
ServantRaidStatEvent = {
  GoToBtnClick = "ServantRaidStatEvent_GoToBtnClick",
  GetRewardClick = "ServantRaidStatEvent_GetRewardClick",
  DropItemCellClick = "ServantRaidStatEvent_DropItemCellClick",
  DropCardCellClick = "ServantRaidStatEvent_DropCardCellClick",
  RaidIconClick = "ServantRaidStatEvent_RaidIconClick"
}
UICloseEvent = {
  GeneralHelpClose = "GeneralHelpClose",
  PetPackagePopViewClose = "PetPackagePopViewClose",
  CloseStageUI = "CloseStageUI",
  CloseSubView = "UICloseEvent_CloseSubView"
}
ExchangeShopEvent = {
  ExchangeShopShow = "ExchangeShopShow",
  OpenTeamView = "HotKeyEvent_OpenTeamView"
}
TipLongPressEvent = {
  PackageView = "TipLongPressEvent_PackageView",
  PackageFashionPage = "TipLongPressEvent_PackageFashionPage",
  PetComposeView = "TipLongPressEvent_PetComposeView",
  RepositoryView = "TipLongPressEvent_RepositoryView",
  ShopSaleBagPage = "TipLongPressEvent_ShopSaleBagPage",
  PlayerDetailView = "TipLongPressEvent_PlayerDetailView",
  TeamInvitePopUp = "TipLongPressEvent_TeamInvitePopUp",
  SetView = "TipLongPressEvent_SetView",
  ChatRoomPage = "TipLongPressEvent_ChatRoomPage",
  GuildFaithPage = "TipLongPressEvent_GuildFaithPage",
  GuildInfoView = "TipLongPressEvent_GuildInfoView",
  StageView = "TipLongPressEvent_StageView",
  FriendMainView = "TipLongPressEvent_FriendMainView",
  EyeLensesView = "TipLongPressEvent_EyeLensesView",
  DressingView = "TipLongPressEvent_HairDressingView",
  Charactor = "TipLongPressEvent_Charactor",
  ServantRecommendView = "TipLongPressEvent_ServantRecommendView",
  GroupInvitePopUp = "TipLongPressEvent_GroupInvitePopUp",
  BoothMainView = "TipLongPressEvent_BoothMainView",
  HomeMainView = "TipLongPressEvent_HomeMainView",
  UIEmojiView = "TipLongPressEvent_UIEmojiView",
  MessageBoardView = "TipLongPressEvent_MessageBoardView",
  HomeWorkbenchView = "TipLongPressEvent_HomeWorkbenchView",
  BFBuildingPanel = "TipLongPressEvent_BFBuildingPanel",
  PetView = "TipLongPressEvent_PetView",
  GemFunctionPage = "TipLongPressEvent_GemFunctionPage",
  PersonalArtifactFunctionView = "TipLongPressEvent_PersonalArtifactFunctionView",
  GuildScore = "TipLongPressEvent_GuildScore",
  MiniROView = "TipLongPressEvent_MiniROView",
  NpcRefinePanel = "TipLongPressEvent_NpcRefinePanel",
  AncientRandomPanel = "TipLongPressEvent_AncientRandomPanel",
  AncientUpgradePanel = "TipLongPressEvent_AncientUpgradePanel",
  DisneyPartnerPanelStory = "TipLongPressEvent_DisneyPartnerPanelStory",
  DisneyPartnerPanelBond = "TipLongPressEvent_DisneyPartnerPanelBond",
  DMTabCell = "TipLongPressEvent_DMTabCell",
  EnchantCombineView = "TipLongPressEvent_EnchantCombineView",
  SmilingLadyShop = "TipLongPressEvent_SmilingLadyShop"
}
MoroccTimeEvent = {
  ActivityOpen = "MoroccSealEvent_ActivityOpen",
  ActivityClose = "MoroccSealEvent_ActivityClose",
  NoNextActivity = "MoroccSealEvent_NoNextActivity"
}
ExpRaidEvent = {
  MapViewClose = "ExpRaidEvent_MapViewClose"
}
TeamPwsEvent = {
  UpdateFakeEnemyPreInfo = "TeamPwsEvent_UpdateFakeEnemyPreInfo"
}
InteractNpcEvent = {
  MyselfTriggerChange = "InteractNpcEvent_MyselfTriggerChange",
  MyselfOnOffChange = "InteractNpcEvent_MyselfOnOffChange",
  MyselfTriggerMountChange = "InteractNpcEvent_MyselfTriggerMountChange",
  MyselfOnOffMountChange = "InteractNpcEvent_MyselfOnOffMountChange",
  MyselfPassengerChange = "InteractNpcEvent_MyselfPassengerChange",
  PushableTargetChange = "InteractNpcEvent_PushableTargetChange",
  LightOn = "InteractNpcEvent_LightOn",
  FlowerCarMagnetSightChange = "InteractNpcEvent_FlowerCarMagnetSightChange",
  FlowerCarPhotographActionCDUpdate = "InteractNpcEvent_FlowerCarPhotographActionCDUpdate",
  FlowerCarUpdateMiniMap = "FlowerCarUpdateMiniMap",
  FlowerCarStart = "FlowerCarStart",
  FlowerCarEnd = "FlowerCarEnd",
  RefreshNpcVisitList = "InteractNpcEvent_RefreshNpcVisitList"
}
InteractLocalEvent = {
  MyselfTriggerChange = "InteractLocalEvent_MyselfTriggerChange",
  MyselfInteractChange = "InteractLocalEvent_MyselfInteractChange"
}
NewServerSignInEvent = {
  UpdateRewardPreview = "NewServerSignInEvent_UpdateRewardPreview",
  CloseRewardPreview = "NewServerSignInEvent_CloseRewardPreview",
  RemoveBarrier = "NewServerSignInEvent_RemoveBarrier",
  MapViewClose = "NewServerSignInEvent_MapViewClose"
}
SceneSeatEvent = {
  TriggerChange = "SceneSeatEvent_TriggerChange"
}
MountLotteryEvent = {
  NewRound = "MountLotteryEvent_NewRound",
  FinishRound = "MountLotteryEvent_FinishRound",
  EndAll = "MountLotteryEvent_EndAll",
  BackToCards = "BackToCards",
  ActivityOpen = "ActivityOpen",
  ActivityClose = "ActivityClose"
}
HomeEvent = {
  EnterHome = "HomeEvent_EnterHome",
  ExitHome = "HomeEvent_EnterHome",
  EditStart = "HomeEvent_EnterHome",
  EditOver = "HomeEvent_EnterHome",
  AddFurniture = "HomeEvent_AddFurniture",
  UpdateFurniture = "HomeEvent_UpdateFurniture",
  RemoveFurniture = "HomeEvent_RemoveFurniture",
  WatchTV = "HomeEvent_WatchTV",
  RenovationChanged = "HomeEvent_RenovationChanged",
  SoundListUpdate = "HomeEvent_SoundListUpdate",
  WorkbenchStartWork = "HomeEvent_WorkbenchStartWork",
  WorkbenchHideHelpBtn = "HomeEvent_WorkbenchHideHelpBtn",
  WorkbenchShowHelpBtn = "HomeEvent_WorkbenchShowHelpBtn",
  ClickMessageTip = "HomeEvent_ClickMessageTip",
  SkadaRecordOver = "HomeEvent_SkadaRecordOver",
  QuerySkadaData = "HomeEvent_QuerySkadaData"
}
ActivityPuzzleGoEvent = {
  MouseClick = "ActivityPuzzleGoEvent_Click",
  ClickIconTip = "ActivityPuzzleGoEvent_ClickIconTip"
}
ActivityPuzzleEvent = {
  ActivityOpen = "ActivityPuzzleEvent_ActivityOpen",
  ActivityClose = "ActivityPuzzleEvent_ActivityClose"
}
GroupOnMarkEvent = {
  CloseMiniBtn = "GroupOnMarkEvent_CloseMiniBtn"
}
StoryAudioEvent = {
  StoryAudioStart = "StoryAudioEvent_StoryAudioStart",
  StoryAudioEnd = "StoryAudioEvent_StoryAudioEnd",
  PlotAudioEnd = "StoryAudioEvent_PlotAudioEnd",
  StoryAudioPause = "StoryAudioEvent_StoryAudioPause",
  StoryAudioResume = "StoryAudioEvent_StoryAudioResume",
  JumpToPoemStoryPage = "StoryAudioEvent_JumpToPoemStoryPage"
}
PermissionEvent = {
  RequestSuccess = "PermissionEvent_RequestSuccess",
  RequestFail = "PermissionEvent_RequestFail"
}
ChangeZoneEvent = {
  ZoneLanguageSetData = "ChangeZoneEvent_ZoneLanguageSetData"
}
BattlePassEvent = {
  ShowBuyLevel = "BattlePassEvent_ShowBuyLevel",
  ShowUpgrade = "BattlePassEvent_ShowUpgrade",
  ShowRewardPreview = "BattlePassEvent_ShowRewardPreview",
  UpdateExhibition = "BattlePassEvent_UpdateExhibition",
  BackToLevelView = "BattlePassEvent_BackToLevelView",
  LevelViewSelectRewardIcon = "BattlePassEvent_LevelViewSelectRewardIcon",
  RankViewSelectHead = "BattlePassEvent_RankViewSelectHead",
  PreviewToggleShow = "BattlePassEvent_PreviewToggleShow",
  HideRewardPreview = "BattlePassEvent_HideRewardPreview",
  VersionChange = "BattlePassEvent_VersionChange"
}
RoguelikeEvent = {
  ShowPlayerTip = "RoguelikeEvent_ShowPlayerTip",
  RoomChange = "RoguelikeEvent_RoomChange"
}
BFBuildingEvent = {
  UseWeather = "BFBuildingEvent_UseWeather",
  UseFunction = "BFBuildingEvent_UseFunction",
  UseRevive = "BFBuildingEvent_UseRevive",
  ReviveQuery = "BFBuildingEvent_ReviveQuery"
}
SetViewEvent = {
  ChangeAppIcon = "SetViewEvent_ChangeAppIcon",
  SaveBtnStatus = "SetViewEvent_ChangeSaveBtn"
}
SkadaRankingEvent = {
  ShowDetail = "SkadaRankingEvent_ShowDetail"
}
MagicBoxEvent = {
  CloseContainerview = "MagicBoxEvent_CloseContainerview"
}
ActivityNodeCellEvent = {
  ClickGoBtn = "ActivityNodeCellEvent_ClickGoBtn",
  GetIconTexture = "ActivityNodeCellEvent_GetIconTexture"
}
ChasingScene = {
  StartQTE = "ChasingScene_StartQTE"
}
NewbieCollegeEvent = {
  RaidNpcFakeTeamInvite = "NewbieCollegeEvent_RaidNpcFakeTeamInvite",
  RaidNpcFakeTeamEnter = "NewbieCollegeEvent_RaidNpcFakeTeamEnter",
  RaidNpcFakeTeamClearInvite = "NewbieCollegeEvent_RaidNpcFakeTeamClearInvite"
}
TwelvePVPEvent = {
  UpdateGold = "TwelvePVPEvent_UpdateGold",
  UpdateCrystalExp = "TwelvePVPEvent_CRYSTAL_EXP",
  UpdateCrystalLv = "TwelvePVPEvent_CRYSTAL_LV",
  UpdateCarPoint = "TwelvePVPEvent_UpdateCAR_POINT",
  UpdatePushNum = "TwelvePVPEvent_UpdatePUSH_NUM",
  UpdateEndTime = "TwelvePVPEvent_UpdateEndTime",
  SyncCamp = "TwelvePVPEvent_SyncCamp",
  UpdateKillNum = "TwelvePVPEvent_UpdateKillNum"
}
BuffCellEvent = {
  BuffEnd = "BuffCellEvent_BuffEnd"
}
NewRechargeEvent = {
  CanPurchase = "NewRechargeEvent_CanPurchase",
  OpenBoxCollider = "NewRechargeEvent_OpenBoxCollider",
  CloseBoxCollider = "NewRechargeEvent_CloseBoxCollider",
  GoodsCell_ShowTip = "NewRechargeEvent_GoodsCell_ShowTip",
  GoodsCell_ShowShopItemPurchaseDetail = "NewRechargeEvent_GoodsCell_ShowShopItemPurchaseDetail",
  SelectGood = "NewRechargeEvent_SelectGood",
  RemoveTimeEnd = "NewRechargeEvent_RemoveTimeEnd",
  CombinePackItemCell_ShowTip = "NewRechargeEvent_CombinePackItemCell_ShowTip",
  CombinePackItemCell_Toggle = "NewRechargeEvent_CombinePackItemCell_Toggle",
  CombinePackItemCell_PrePurchase = "NewRechargeEvent_CombinePackItemCell_PrePurchase",
  CombinePackList_ForceRefresh = "NewRechargeEvent_CombinePackList_ForceRefresh"
}
NewContentPushEvent = {
  Close = "NewContentPushEvent_Close",
  ShowDoujinshi = "NewContentPushEvent_ShowDoujinshi",
  Push = "NewContentPushEvent_Push"
}
SupplyDepotEvent = {
  UpdateItem = "SupplyDepotEvent_UpdateItem"
}
ChasingScene = {
  StartQTE = "ChasingScene_StartQTE"
}
DriftBottleEvent = {
  ClickAcceptBtn = "DriftBottleEvent_ClickAcceptBtn",
  ClickAbandonBtn = "DriftBottleEvent_ClickAbandonBtn",
  ClickShowDetail = "DriftBottleEvent_ClickShowDetail"
}
DisneyEvent = {
  DisneyGuideShutDown = "DisneyEvent_DisneyGuideShutDown",
  RankViewSelectHead = "DisneyEvent_RankViewSelectHead",
  DisneyMusicIdChanged = "DisneyEvent_DisneyMusicIdChanged",
  DisneyMusicStatusChanged = "DisneyEvent_DisneyMusicStatusChanged",
  DisneyFriendStoryCellExtendClick = "DisneyEvent_DisneyFriendStoryCellExtendClick"
}
LightShadowEvent = {
  PosChanged = "LightShadowEvent_PosChanged",
  BricksStepFinished = "LightShadowEvent_BricksStepFinished",
  BricksAllFinished = "LightShadowEvent_BricksAllFinished",
  DisplayProgress = "LightShadowEvent_DisplayProgress",
  FirstInPrpgress = "LightShadowEvent_FirstInPrpgress",
  SingleBrickSuccess = "LightShadowEvent_SingleBrickSuccess",
  GuideStepUpdate = "LightShadowEvent_GuideStepUpdate"
}
LightPuzzleEvent = {
  PuzzleSolved = "LightPuzzleEvent_PuzzleSolved"
}
RewardSelectViewEvent = {
  CloseUI = "RewardSelectView_CloseUI"
}
PlayerBehaviourEvent = {
  OnEnter = "PlayerBehaviourEvent_OnEnter",
  OnExit = "PlayerBehaviourEvent_OnExit",
  OnTrigger = "PlayerBehaviourEvent_OnTrigger",
  OnNpcAIStateUpdate = "PlayerBehaviourEvent_OnNpcAIStateUpdate"
}
PlayerSurveyEvent = {
  OnManualInputChange = "PlayerSurveyEvent_OnManualInputChange",
  OnManualInputSubmit = "PlayerSurveyEvent_OnManualInputSubmit",
  ClickClassTog = "PlayerSurveyEvent_ClickClassTog"
}
SevenRoyalFamilies = {
  JointInferenceCheckEvidence = "SevenRoyalFamilies_JointInferenceCheckEvidence",
  JointInferenceFinishProcess = "SevenRoyalFamilies_JointInferenceFinishProcess",
  JointInferenceLongPressEvidence = "SevenRoyalFamilies_JointInferenceLongPressEvidence"
}
PlayerRefluxEvent = {
  ShareRelfuxPic = "PlayerRefluxEvent_ShareRelfuxPic",
  BindUser = "PlayerRefluxEvent_BindUser",
  RefluxBackLoginReward = "PlayerRefluxEvent_RefluxBackLoginReward",
  InviteLoginAward = "PlayerRefluxEvent_InviteLoginAward"
}
ReturnActivityEvent = {
  ClickGoBtn = "ReturnActivityEvent_ClickGoBtn",
  ClickDailyReward = "ReturnActivityEvent_ClickDailyReward",
  ClickTaskReward = "ReturnActivityEvent_ClickTaskReward"
}
DetectiveEvent = {
  ClickPage = "DetectiveEvent_ClickPage"
}
IrisEvent = {
  OnEnterRoom = "Iris_Enter_Room",
  OnExitRoom = "Iris_Exit_Room",
  OnSelfState = "Iris_Self_State",
  OnMemberUpdate = "Iris_Member_Update",
  OnIrisException = "Iris_Exception"
}
PlayerRefluxEvent = {
  ShareRelfuxPic = "PlayerRefluxEvent_ShareRelfuxPic",
  BindUser = "PlayerRefluxEvent_BindUser",
  RefluxBackLoginReward = "PlayerRefluxEvent_RefluxBackLoginReward",
  InviteLoginAward = "PlayerRefluxEvent_InviteLoginAward"
}
StealthGameEvent = {
  Start = "StealthGameEvent_Start",
  End = "StealthGameEvent_End",
  AIState_Update = "AIState_Update",
  EnterTrigger = "EnterTrigger",
  ExitTrigger = "ExitTrigger",
  Skill_AttachNPC = "Skill_AttachNPC",
  Skill_CancelAttachNPC = "Skill_CancelAttachNPC",
  Skill_Update = "Skil_Update",
  HideIn = "HideIn",
  CarryBox = "CarryBox",
  RaidItem_Update = "RaidItem_Update",
  RaidItem_Add = "RaidItem_Add",
  RaidItem_Del = "RaidItem_Del",
  Update_MemoryInfo = "Update_MemoryInfo",
  Skill_CastStart = "Skill_CastStart",
  Skill_CastEnd = "Skill_CastEnd",
  Break_Skill = "Break_Skill",
  Item_UseTip = "Item_UseTip",
  ThePlayPinaoResult = "ThePlayPinaoResult",
  ClickMinMapLeave = "ClickMinMapLeave"
}
GMEEvent = {
  OnEnterRoom = "GME_Enter_Room",
  OnExitRoom = "GME_Exit_Room",
  OnSelfState = "GME_Self_State",
  OnMemberUpdate = "GME_Member_Update",
  OnMemberExit = "GME_Member_Exit",
  OnGMEException = "GME_Exception",
  OnMemberUpdateBackListInfo = "OnMemberUpdateBackListInfo",
  OnDisconnect = "OnDisconnect"
}
BoliWishingEvent = {
  LikeMyself = "BoliWishingEvent_LikeMyself"
}
UICellEvent = {
  OnCellClicked = "UICellEvent_OnCellClicked",
  OnLeftBtnClicked = "UICellEvent_OnLeftBtnClicked",
  OnMidBtnClicked = "UICellEvent_OnMidBtnClicked",
  OnRightBtnClicked = "UICellEvent_OnRightBtnClicked",
  OnCollapseFinished = "UICellEvent_OnCollapseFinished",
  OnInoutAnimFinished = "UICellEvent_OnInoutAnimFinished"
}
CupModeEvent = {
  Tree_6v6 = "CupMode_Tree_6v6",
  Leave_6v6 = "CupMode_Leave_6v6",
  Inviter_6v6 = "CupMode_Inviter_6v6",
  QueryBand_6v6 = "CupMode_QueryBand_6v6",
  BandInfo_6v6 = "CupMode_Info_6v6",
  TeamList_6v6 = "CupMode_TeamList_6v6",
  Sort_6v6 = "CupMode_Sort_6v6",
  SeasonInfo_6v6 = "CupMode_SeasonInfo_6v6",
  SeasonFinish_6v6 = "CupMode_SeasonFinish_6v6",
  SeasonTimeInfo_6v6 = "CupMode_SeasonTimeInfo_6v6",
  ScheduleChanged_6v6 = "CupMode_ScheduleChanged_6v6",
  Fighting_6v6 = "CupMode_Fighting_6v6"
}
NoviceBattlePassEvent = {
  OnGotoBtnClick = "NoviceBattlePassEvent_OnGotoBtnClick"
}
CustomRoomEvent = {
  OnCurrentRoomChanged = "CustomRoomEvent_OnCurrentRoomChanged",
  OnReadyStart = "CustomRoomEvent_OnReadyStart",
  OnReadyUpdate = "CustomRoomEvent_OnReadyUpdate",
  OnReadyStateUpdate = "CustomRoomEvent_OnReadyStateUpdate",
  OnReadyEnd = "CustomRoomEvent_OnReadyEnd",
  OnEnterBattle = "CustomRoomEvent_OnEnterBattle",
  OnExitBattle = "CustomRoomEvent_OnExitBattle"
}
BoliWishingEvent = {
  LikeMyself = "BoliWishingEvent_LikeMyself"
}
GMEEvent = {
  OnEnterRoom = "GME_Enter_Room",
  OnExitRoom = "GME_Exit_Room",
  OnSelfState = "GME_Self_State",
  OnMemberUpdate = "GME_Member_Update",
  OnMemberExit = "GME_Member_Exit",
  OnGMEException = "GME_Exception",
  OnMemberUpdateBackListInfo = "OnMemberUpdateBackListInfo",
  OnDisconnect = "OnDisconnect",
  OnTeamUpdate = "OnTeamUpdate"
}
NoviceBattlePassEvent = {
  OnGotoBtnClick = "NoviceBattlePassEvent_OnGotoBtnClick",
  ReturnBPEnd = "NoviceBattlePassEvent_ReturnBPEnd"
}
SkillRecommendEvent = {
  CloseRecommendView = "SkillRecommendEvent_CloseRecommendView",
  SelectSolution = "SkillRecommendEvent_SelectSolution",
  ResetPreset = "SkillRecommendEvent_ResetPreset"
}
NoviceShop = {
  RefreshBtn = "NoviceShop_RefreshBtn"
}
AccumulativeShop = {
  RefreshBtn = "AccumulativeShop_RefreshBtn"
}
RecommendRewardEvent = {
  Close = "RecommendReward_Close"
}
EnchantEvent = {
  ReturnToReset = "EnchantEvent_ReturnToReset",
  ResetLockedAdvCost = "EnchantEvent_ResetLockedAdvCost"
}
EquipMemoryEvent = {
  JumpToAttrReset = "EquipMemoryEvent_JumpToAttrReset"
}
ShareNewEvent = {
  HideWeekShraeTip = "ShareNewEvent_HideWeekShraeTip"
}
WildMvpEvent = {
  OnMonsterUpdated = "WildMvpEvent_OnMonsterUpdated",
  OnAffixUpdated = "WildMvpEvent_OnAffixUpdated",
  OnBuffUpdated = "WildMvpEvent_OnBuffUpdated",
  OnMiniMapMonsterUpdated = "WildMvpEvent_OnMiniMapMonsterUpdated",
  OnLuckySettingChanged = "WildMvpEvent_OnLuckySettingChanged"
}
MultiProfessionEvent = {
  ClickCurClass = "MultiProfessionEvent_ClickCurClass",
  ClickAdvanceClass = "MultiProfessionEvent_ClickAdvanceClass",
  ChooseProfession = "MultiProfessionEvent_ChooseProfession",
  OpenPanel = "MultiProfessionEvent_OpenPanel"
}
GVGCookingEvent = {
  UpdateInfo = "GVG_Cooking_UpdateInfo",
  CreateCookingNpc = "GVGCookingEvent_CreateCookingNpc",
  RemoveCookingNpc = "GVGCookingEvent_RemoveCookingNpc"
}
DesertWolfEvent = {
  OnStatChanged = "DesertWolfEvent_OnStatchanged",
  OnRuleUpdated = "DesertWolfEvent_OnRuleUpdated"
}
MultiProfessionEvent = {
  ClickCurClass = "MultiProfessionEvent_ClickCurClass",
  ClickAdvanceClass = "MultiProfessionEvent_ClickAdvanceClass",
  ChooseProfession = "MultiProfessionEvent_ChooseProfession"
}
YmirEvent = {
  OnSimpleRecordDataUpdated = "YmirEvent_OnSimpleRecordDataUpdated",
  YmirTipCellQuickSave = "YmirEvent_YmirTipCellQuickSave"
}
AfricanPoring = {
  OnActivityStart = "AfricanPoring_OnActivityStart",
  OnAcvitityEnd = "AfricanPoring_OnAcvitityEnd",
  OnShopItemUpdated = "AfricanPoring_OnShopItemUpdated"
}
RedPacketEvent = {
  OnChooseReceiver = "RedPacketEvent_OnChooseReceiver",
  OnReceiverListPageClose = "RedPacketEvent_OnReceiverListPageClose",
  OnDetailPageClose = "RedPacketEvent_OnDetailPageClose",
  OnBlessSelect = "RedPacketEvent_OnBlessSelect",
  OnBlessConfirm = "RedPacketEvent_OnBlessConfirm",
  OnBlessCancel = "RedPacketEvent_OnBlessCancel"
}
AnniversaryLive = {
  OnActivityStart = "AnniversaryLive_OnActivityStart",
  OnActivityEnd = "AnniversaryLive_OnActivityEnd"
}
DownloadEvent = {
  Downloading = "Downloading",
  Downloaded = "Downloaded"
}
PreoderEvent = {
  ClosePreorderInfo = "ClosePreorderInfo",
  ClosePreorderEditor = "ClosePreorderEditor",
  UpdateEditorCell = "UpdateEditorCell"
}
EscortEvent = {
  EscortInfoChanged = "EscortInfoChanged",
  HandStatusBuff = "HandStatusBuff"
}
BigWorldClientEvent = {
  ClientNpcLoaded = "BigWorldClientEvent_ClientNpcLoaded"
}
CraftingPotViewEvent = {
  UpdateProduct = "CraftingPotView_UpdateProduct"
}
AstralGraphEvent = {
  LightenPoint = "AstralGraphEvent_LightenPoint"
}
InheritSkillEvent = {
  ExpendSkill = "InheritSkillEvent_ExpendSkill"
}
FakeDragonEvent = {
  UpdateFakeDragonPoses = "FakeDragonEvent_UpdateFakeDragonPoses"
}
