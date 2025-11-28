PanelShowHideMode = {
  CreateAndDestroy = 1,
  ActiveAndDeactive = 2,
  MoveOutAndMoveIn = 3
}
PanelConfig = {
  Charactor = {
    id = 1,
    tab = nil,
    name = "人物",
    desc = "",
    prefab = "Charactor",
    class = "Charactor",
    hideCollider = true
  },
  CharactorAdventureSkill = {
    id = 3,
    tab = 1,
    name = "冒险技能",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  CharactorProfessSkill = {
    id = 4,
    tab = 2,
    name = "职业技能",
    desc = "",
    prefab = "SkillView",
    class = "SkillView",
    unOpenJump = 3
  },
  CharactorTitle = {
    id = 5,
    tab = 4,
    name = "人物称号",
    desc = "",
    prefab = "Charactor1",
    class = "Charactor1"
  },
  CharactorBeingSkill = {
    id = 6,
    tab = 5,
    name = "生命体技能",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  CharactorPvpTalentSkill = {
    id = 7,
    tab = 6,
    name = "竞技赛天赋",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  BlindMaskView = {
    id = 8,
    tab = nil,
    name = "致盲",
    desc = "",
    prefab = "BlindMaskView",
    class = "BlindMaskView"
  },
  CharactorFourthSkill = {
    id = 9,
    tab = 7,
    name = "四转技能",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  CharactorHeroSkill = {
    id = 17000,
    tab = 8,
    name = "英雄技能",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  SkillView = {
    id = 10,
    tab = nil,
    name = "技能",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  Bag = {
    id = 11,
    tab = 1,
    name = "背包",
    desc = "",
    prefab = "PackageView",
    class = "PackageView",
    hideCollider = true
  },
  EquipStrengthen = {
    id = 91,
    tab = 2,
    name = "强化",
    desc = "",
    prefab = "PackageView",
    class = "PackageView"
  },
  PackageWalletPage = {
    id = 13,
    tab = 3,
    name = "零钱",
    desc = "",
    prefab = "PackageWalletPage",
    class = "PackageWalletPage"
  },
  PackageRefine = {
    id = 12,
    tab = 4,
    name = "强化",
    desc = "",
    prefab = "PackageRefine",
    class = "PackageRefine"
  },
  PackageFashionPage = {
    id = 13,
    tab = 1,
    name = "幻化",
    desc = "",
    prefab = "PackageFashionPage",
    class = "PackageFashionPage"
  },
  DynamicSkillEffView = {
    id = 14,
    tab = 2,
    name = "技能特效",
    desc = "",
    prefab = "DynamicSkillEffView",
    class = "DynamicSkillEffView"
  },
  RewardEffectView = {
    id = 20,
    tab = 3,
    name = "奖励特效",
    desc = "",
    prefab = "RewardEffectView",
    class = "RewardEffectView"
  },
  UseCardPopUp = {
    id = 15,
    tab = nil,
    name = "使用卡片",
    desc = "",
    prefab = "UseCardPopUp",
    class = "UseCardPopUp"
  },
  SetCardPopUp = {
    id = 16,
    tab = nil,
    name = "镶嵌卡片",
    desc = "",
    prefab = "SetCardPopUp",
    class = "SetCardPopUp"
  },
  CollectSaleConfirmPopUp = {
    id = 17,
    tab = nil,
    name = "一键出售",
    desc = "",
    prefab = "CollectSaleConfirmPopUp",
    class = "CollectSaleConfirmPopUp"
  },
  EquipCardView = {
    id = 18,
    tab = nil,
    name = "镶嵌卡片",
    desc = "",
    prefab = "EquipCardView",
    class = "EquipCardView"
  },
  EquipStrengthView = {
    id = 19,
    tab = nil,
    name = "装备格子强化",
    desc = "",
    prefab = "EquipStrengthView",
    class = "EquipStrengthView"
  },
  TempPackageView = {
    id = 21,
    tab = nil,
    name = "临时背包",
    desc = "",
    prefab = "TempPackageView",
    class = "TempPackageView",
    hideCollider = true
  },
  NpcRefinePanel = {
    id = 31,
    tab = 1,
    name = "精炼界面",
    desc = "",
    prefab = "NpcRefinePanel",
    class = "NpcRefinePanel"
  },
  NpcRefineBatchPanel = {
    id = 33,
    tab = 2,
    name = "一键精炼",
    desc = "",
    prefab = "NpcRefinePanel",
    class = "NpcRefinePanel"
  },
  HighRefinePanel = {
    id = 41,
    tab = nil,
    name = "极限精炼",
    desc = "",
    prefab = "HighRefinePanel",
    class = "HighRefinePanel"
  },
  PhotographPanel = {
    id = 71,
    tab = nil,
    name = "照相模式",
    desc = "",
    prefab = "PhotographPanel",
    class = "PhotographPanel",
    hideCollider = true
  },
  PhotographResultPanel = {
    id = 81,
    tab = nil,
    name = "照相结果",
    desc = "",
    prefab = "PhotographResultPanel",
    class = "PhotographResultPanel"
  },
  PictureDetailPanel = {
    id = 82,
    tab = nil,
    name = "照片墙详情",
    desc = "",
    prefab = "PictureDetailPanel",
    class = "PictureDetailPanel",
    hideCollider = true
  },
  PersonalPicturePanel = {
    id = 83,
    tab = nil,
    name = "个人相册",
    desc = "",
    prefab = "PersonalPicturePanel",
    class = "PersonalPicturePanel"
  },
  PersonalPictureDetailPanel = {
    id = 84,
    tab = nil,
    name = "个人相册详情",
    desc = "",
    prefab = "PersonalPictureDetailPanel",
    class = "PersonalPictureDetailPanel"
  },
  PicutureWallSyncPanel = {
    id = 85,
    tab = nil,
    name = "公会墙同步",
    desc = "",
    prefab = "PicutureWallSyncPanel",
    class = "PicutureWallSyncPanel"
  },
  TempPersonalPicturePanel = {
    id = 86,
    tab = nil,
    name = "临时相册",
    desc = "",
    prefab = "TempPersonalPicturePanel",
    class = "TempPersonalPicturePanel"
  },
  TempPersonalPictureDetailPanel = {
    id = 87,
    tab = nil,
    name = "临时相册详情",
    desc = "",
    prefab = "TempPersonalPictureDetailPanel",
    class = "TempPersonalPictureDetailPanel"
  },
  WeddingWallPictureDetail = {
    id = 88,
    tab = nil,
    name = "婚礼相框详情",
    desc = "",
    prefab = "WeddingWallPictureDetail",
    class = "WeddingWallPictureDetail"
  },
  WeddingWallPictureSyncPanel = {
    id = 89,
    tab = nil,
    name = "婚礼相框上传",
    desc = "",
    prefab = "PicutureWallSyncPanel",
    class = "WeddingWallPictureSyncPanel"
  },
  EnchantView = {
    id = 90,
    tab = nil,
    name = "装备附魔",
    desc = "",
    prefab = "EnchantView",
    class = "EnchantView"
  },
  DeComposeView = {
    id = 92,
    tab = nil,
    name = "分解",
    desc = "",
    prefab = "DeComposeView",
    class = "DeComposeView"
  },
  DeComposeNewView = {
    id = 93,
    tab = nil,
    name = "分解",
    desc = "",
    prefab = "DeComposeView",
    class = "DeComposeNewView"
  },
  ReplaceView = {
    id = 94,
    tab = nil,
    name = "装备置换",
    desc = "",
    prefab = "ReplaceView",
    class = "ReplaceView"
  },
  EnchantCombineView = {
    id = 95,
    tab = nil,
    name = "附魔集合",
    desc = "",
    prefab = "EnchantCombineView",
    class = "EnchantCombineView",
    hideCollider = true
  },
  RefineCombineView = {
    id = 96,
    tab = nil,
    name = "精炼集合",
    desc = "",
    prefab = "RefineCombineView",
    class = "RefineCombineView",
    hideCollider = true
  },
  EquipRecoverCombinedView = {
    id = 97,
    tab = nil,
    name = "分解还原集合",
    desc = "",
    prefab = "CommonCombineView",
    class = "EquipRecoverCombinedView",
    hideCollider = true
  },
  QuenchCombineView = {
    id = 98,
    tab = nil,
    name = "淬炼集合",
    desc = "",
    prefab = "EnchantCombineView",
    class = "QuenchCombineView",
    hideCollider = true
  },
  CommonCombineView = {
    id = 99,
    tab = nil,
    name = "通用集合",
    desc = "",
    prefab = "CommonCombineView",
    class = "CommonCombineView",
    hideCollider = true
  },
  EnchantNewCombineView = {
    id = 100,
    tab = nil,
    name = "新-附魔集合",
    desc = "",
    prefab = "CommonCombineView",
    class = "EnchantNewCombineView",
    hideCollider = true
  },
  RaidEntranceCombineView = {
    id = 102,
    tab = nil,
    name = "Pve副本页签",
    desc = "",
    prefab = "CommonCombineView",
    class = "RaidEntranceCombineView",
    hideCollider = true
  },
  BossView = {
    id = 101,
    tab = nil,
    name = "Boss",
    desc = "",
    prefab = "BossView",
    class = "BossView"
  },
  SocialityPage = {
    id = 110,
    tab = 4,
    name = "社交信息",
    desc = "",
    prefab = "SocialityPage",
    class = "SocialityPage"
  },
  AddPointPage = {
    id = 111,
    tab = 1,
    name = "加点",
    desc = "",
    prefab = "AddPointPage",
    class = "AddPointPage"
  },
  ProfessionPage = {
    id = 121,
    tab = 3,
    name = "职业",
    desc = "",
    prefab = "ProfessionPage",
    class = "ProfessionPage"
  },
  InfomationPage = {
    id = 122,
    tab = 2,
    name = "角色信息",
    desc = "",
    prefab = "InfomationPage",
    class = "InfomationPage"
  },
  ProfessionSaveLoadView = {
    id = 123,
    tab = nil,
    name = "职业存储",
    desc = "",
    prefab = "ProfessionInfoViewMP",
    class = "ProfessionContainerView"
  },
  PlayerDetailViewMP = {
    id = 124,
    tab = nil,
    name = "玩家详细信息界面",
    desc = "",
    prefab = "PlayerDetailViewMP",
    class = "PlayerDetailViewMP",
    hideCollider = true
  },
  ChangeSaveNamePopUp = {
    id = 125,
    tab = nil,
    name = "存档改名",
    desc = "",
    prefab = "ChangeSaveNamePopUp",
    class = "ChangeSaveNamePopUp"
  },
  PurchaseSaveSlotPopUp = {
    id = 126,
    tab = nil,
    name = "存档改名",
    desc = "",
    prefab = "PurchaseSaveSlotPopUp",
    class = "PurchaseSaveSlotPopUp"
  },
  CheckAllProfessionPanel = {
    id = 127,
    tab = nil,
    name = "查看职业面板",
    desc = "",
    prefab = "CheckAllProfessionPanel",
    class = "CheckAllProfessionPanel"
  },
  MultiProfessionNewView = {
    id = 128,
    tab = nil,
    name = "新-多职业",
    desc = "",
    prefab = "MultiProfessionNewView",
    class = "MultiProfessionNewView"
  },
  ProfessionNewPage = {
    id = 129,
    tab = 1,
    name = "新-多职业1",
    desc = "",
    prefab = "ProfessionNewPage",
    class = "ProfessionNewPage"
  },
  TransferProfessionPreviewView = {
    id = 130,
    name = "转职职业树",
    desc = "",
    prefab = "TransferProfessionPreviewView",
    class = "TransferProfessionPreviewView"
  },
  ProfessionNewHeroPage = {
    id = 133,
    tab = 1,
    name = "新-英雄养成",
    desc = "",
    prefab = "ProfessionNewHeroPage",
    class = "ProfessionNewHeroPage"
  },
  LowBloodBlinkView = {
    id = 134,
    tab = nil,
    name = "低血泛红",
    desc = "",
    prefab = "ClickEffectView",
    class = "LowBloodBlinkView"
  },
  FloatAwardView = {
    id = 135,
    tab = nil,
    name = "奖励",
    desc = "",
    prefab = "FloatAwardView",
    class = "FloatAwardView"
  },
  ShareAwardView = {
    id = 136,
    tab = nil,
    name = "分享",
    desc = "",
    prefab = "ShareAwardView",
    class = "ShareAwardView"
  },
  QuestPanel = {
    id = 137,
    tab = nil,
    name = "任务面板",
    desc = "",
    prefab = "QuestPanel",
    class = "QuestPanel"
  },
  QuestTracePanel = {
    id = 138,
    tab = nil,
    name = "任务追踪面板",
    desc = "",
    prefab = "QuestTracePanel",
    class = "QuestTracePanel"
  },
  RaidInfoPopUp = {
    id = 140,
    tab = nil,
    name = "副本信息",
    desc = "",
    prefab = "RaidInfoPopUp",
    class = "RaidInfoPopUp",
    hideCollider = true
  },
  RepositoryView = {
    id = 141,
    tab = nil,
    name = "仓库",
    desc = "",
    prefab = "RepositoryView",
    class = "RepositoryView"
  },
  HappyShop = {
    id = 151,
    tab = nil,
    name = "乐园团商店",
    desc = "",
    prefab = "HappyShop",
    class = "HappyShop"
  },
  SmilingLadyShop = {
    id = 152,
    tab = nil,
    name = "微笑小姐商店",
    desc = "",
    prefab = "SmilingLady/SmilingLadyShop",
    class = "SmilingLadyShop"
  },
  WorldMapView = {
    id = 161,
    tab = nil,
    name = "世界地图",
    desc = "",
    prefab = "WorldMapView",
    class = "WorldMapView"
  },
  BWMiniMapView = {
    id = 173,
    tab = nil,
    name = "大世界小地图",
    desc = "",
    prefab = "BWMiniMapView",
    class = "BWMiniMapView"
  },
  BWMiniMapPopupView = {
    id = 172,
    tab = nil,
    name = "大世界小地图(弹出)",
    desc = "",
    prefab = "BWMiniMapView",
    class = "BWMiniMapPopupView"
  },
  ChatRoomPage = {
    id = 181,
    tab = nil,
    name = "聊天室",
    desc = "",
    prefab = "ChatRoom",
    class = "ChatRoomPage",
    hideCollider = false
  },
  ChatBarrageView = {
    id = 182,
    tab = nil,
    name = "聊天弹幕",
    desc = "",
    prefab = "ChatBarrageView",
    class = "ChatBarrageView"
  },
  ChatEmojiView = {
    id = 191,
    tab = nil,
    name = "表情",
    desc = "",
    prefab = "UIEmojiView",
    class = "UIEmojiView",
    hideCollider = false
  },
  AnnounceQuestPanel = {
    id = 201,
    tab = nil,
    name = "公告任务版",
    desc = "",
    prefab = "AnnounceQuestPanel",
    class = "AnnounceQuestPanel",
    hideCollider = false
  },
  AnnounceQuestActivityPanel = {
    id = 202,
    tab = nil,
    name = "公告任务活动版",
    desc = "",
    prefab = "AnnounceQuestActivityPanel",
    class = "AnnounceQuestPanel",
    hideCollider = false
  },
  AnnounceQuestPanelNew = {
    id = 203,
    tab = nil,
    name = "新看版",
    desc = "",
    prefab = "AnnounceQuestPanelNew",
    class = "AnnounceQuestPanelNew",
    hideCollider = false
  },
  SoundBoxView = {
    id = 211,
    tab = nil,
    name = "音乐盒播放列表",
    desc = "",
    prefab = "SoundBoxView",
    class = "SoundBoxView",
    hideCollider = false
  },
  SoundItemChoosePopUp = {
    id = 212,
    tab = nil,
    name = "音乐盒道具列表",
    desc = "",
    prefab = "SoundItemChoosePopUp",
    class = "SoundItemChoosePopUp",
    hideCollider = false
  },
  ClickEffectView = {
    id = 310,
    tab = nil,
    name = "全屏点击",
    desc = "",
    prefab = "ClickEffectView",
    class = "ClickEffectView",
    hideCollider = true
  },
  CreateChatRoom = {
    id = 320,
    tab = nil,
    name = "聊天室",
    desc = "",
    prefab = "CreateChatRoom",
    class = "CreateChatRoom",
    hideCollider = false
  },
  EndlessTower = {
    id = 330,
    tab = nil,
    name = "无尽之塔",
    desc = "",
    prefab = "EndlessTower",
    class = "EndlessTower",
    hideCollider = false
  },
  EndlessTowerWaitView = {
    id = 331,
    tab = nil,
    name = "无尽之塔等待队友",
    desc = "",
    prefab = "EndlessTowerWaitView",
    class = "EndlessTowerWaitView"
  },
  TriplePlayerPvpWaittingView = {
    id = 340,
    tab = nil,
    name = "3v3v3等待",
    desc = "",
    prefab = "TriplePlayerPvpWaittingView",
    class = "TriplePlayerPvpWaittingView"
  },
  TriplePlayerPvpChooseProView = {
    id = 341,
    tab = nil,
    name = "3v3v3选职业",
    desc = "",
    prefab = "TriplePlayerPvpChooseProView",
    class = "TriplePlayerPvpChooseProView"
  },
  TeamMemberListPopUp = {
    id = 351,
    tab = nil,
    name = "队伍信息",
    desc = "",
    prefab = "TeamMemberListPopUp",
    class = "TeamMemberListPopUp",
    hideCollider = false
  },
  TeamFindPopUp = {
    id = 352,
    tab = nil,
    name = "查找队伍",
    desc = "",
    prefab = "TeamFindPopUp",
    class = "TeamFindPopUp",
    hideCollider = false
  },
  TeamApplyListPopUp = {
    id = 353,
    tab = nil,
    name = "申请列表",
    desc = "",
    prefab = "TeamApplyListPopUp",
    class = "TeamApplyListPopUp",
    hideCollider = false
  },
  TeamInvitePopUp = {
    id = 354,
    tab = nil,
    name = "邀请队员",
    desc = "",
    prefab = "TeamInvitePopUp",
    class = "TeamInvitePopUp",
    hideCollider = false
  },
  TeamOptionPopUp = {
    id = 355,
    tab = nil,
    name = "队伍设置",
    desc = "",
    prefab = "TeamOptionPopUp",
    class = "TeamOptionPopUp",
    hideCollider = false
  },
  GroupInvitePopUp = {
    id = 356,
    tab = nil,
    name = "邀请建立团队",
    desc = "",
    prefab = "GroupInvitePopUp",
    class = "GroupInvitePopUp",
    hideCollider = false
  },
  TeamInfoPopup = {
    id = 357,
    tab = nil,
    name = "队伍详情",
    desc = "",
    prefab = "TeamInfoPopup",
    class = "TeamInfoPopup",
    hideCollider = false
  },
  SelectTeamRolePopUp = {
    id = 360,
    tab = nil,
    name = "队伍职能选择界面",
    desc = "",
    prefab = "SelectTeamRolePopUp",
    class = "SelectTeamRolePopUp",
    hideCollider = false
  },
  TeamOption_SetRolePopup = {
    id = 361,
    tab = nil,
    name = "队伍设置_职能设置",
    desc = "",
    prefab = "TeamOption_SetRolePopup",
    class = "TeamOption_SetRolePopup",
    hideCollider = false
  },
  PostView = {
    id = 370,
    tab = nil,
    name = "邮件",
    desc = "",
    prefab = "PostView",
    class = "PostView",
    hideCollider = false
  },
  XOView = {
    id = 380,
    tab = nil,
    name = "问答系统",
    desc = "",
    prefab = "XOView",
    class = "XOView",
    hideCollider = false
  },
  PlayerSurveyView = {
    id = 381,
    tab = nil,
    name = "玩家问卷调查",
    desc = "",
    prefab = "PlayerSurveyView",
    class = "PlayerSurveyView",
    hideCollider = false
  },
  AdventurePanel = {
    id = 400,
    tab = nil,
    name = "冒险日志",
    desc = "",
    prefab = "AdventurePanel",
    class = "AdventurePanel"
  },
  AdventureRewardPanel = {
    id = 401,
    tab = nil,
    name = "冒险奖励",
    desc = "",
    prefab = "AdventureRewardPanel",
    class = "AdventureRewardPanel"
  },
  ScenerytDetailPanel = {
    id = 402,
    tab = nil,
    name = "景点详情",
    desc = "",
    prefab = "ScenerytDetailPanel",
    class = "ScenerytDetailPanel"
  },
  MonthCardDetailPanel = {
    id = 403,
    tab = nil,
    name = "月卡详情",
    desc = "",
    prefab = "MonthCardDetailPanel",
    class = "MonthCardDetailPanel"
  },
  EpCardDetailPanel = {
    id = 404,
    tab = nil,
    name = "Ep详情",
    desc = "",
    prefab = "EpCardDetailPanel",
    class = "EpCardDetailPanel"
  },
  AdventureZoneRewardPopUp = {
    id = 405,
    tab = nil,
    name = "冒险手册区域奖励",
    desc = "",
    prefab = "AdventureZoneRewardPopUp",
    class = "AdventureZoneRewardPopUp",
    hideCollider = true
  },
  ShopSale = {
    id = 410,
    tab = nil,
    name = "商店出售",
    desc = "",
    prefab = "ShopSale",
    class = "ShopSale"
  },
  ChangeJobView = {
    id = 420,
    tab = nil,
    name = "转职长廊界面",
    desc = "",
    prefab = "ChangeJobView",
    class = "ChangeJobView"
  },
  GuidePanel = {
    id = 430,
    tab = nil,
    name = "引导提示确认",
    desc = "",
    prefab = "GuidePanel",
    class = "GuidePanel"
  },
  GuideMaskView = {
    id = 440,
    tab = nil,
    name = "引导",
    desc = "",
    prefab = "GuideMaskView",
    class = "GuideMaskView"
  },
  ClientGuideView = {
    id = 445,
    tab = nil,
    name = "引导",
    desc = "",
    prefab = "ClientGuideView",
    class = "ClientGuideView"
  },
  UIMapAreaList = {
    id = 450,
    tab = nil,
    name = "区域界面",
    desc = "",
    prefab = "UIMapAreaList",
    class = "UIMapAreaList"
  },
  UIMapMapList = {
    id = 460,
    tab = nil,
    name = "地图界面",
    desc = "",
    prefab = "UIMapAreaList",
    class = "UIMapMapList"
  },
  LoadingViewDefault = {
    id = 470,
    tab = 1,
    name = "默认加载界面",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewIllustration = {
    id = 471,
    tab = 2,
    name = "插画加载界面",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewNewExplore = {
    id = 472,
    tab = 3,
    name = "新区域解锁",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewQuickWithoutProgress = {
    id = 473,
    tab = 4,
    name = "什么都没的黑界面",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewThanatos = {
    id = 473,
    tab = 5,
    name = "团四特殊loading",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  FriendMainView = {
    id = 480,
    tab = nil,
    name = "好友主界面",
    desc = "",
    prefab = "FriendMainView",
    class = "FriendMainView"
  },
  AddFriendView = {
    id = 481,
    tab = nil,
    name = "添加好友",
    desc = "",
    prefab = "AddFriendView",
    class = "AddFriendView"
  },
  FriendApplyInfoView = {
    id = 482,
    tab = nil,
    name = "好友申请列表",
    desc = "",
    prefab = "FriendApplyInfoView",
    class = "FriendApplyInfoView"
  },
  BlacklistView = {
    id = 483,
    tab = nil,
    name = "黑名单",
    desc = "",
    prefab = "BlacklistView",
    class = "BlacklistView"
  },
  FriendView = {
    id = 484,
    tab = 1,
    name = "好友界面",
    desc = "",
    prefab = "FriendMainView",
    class = "FriendView"
  },
  TutorView = {
    id = 485,
    tab = 2,
    name = "导师界面",
    desc = "",
    prefab = "FriendMainView",
    class = "TutorMainView"
  },
  TutorApplyView = {
    id = 486,
    tab = nil,
    name = "导师申请界面",
    desc = "",
    prefab = "TutorApplyView",
    class = "TutorApplyView"
  },
  TutorTaskView = {
    id = 487,
    tab = nil,
    name = "导师任务界面",
    desc = "",
    prefab = "TutorTaskView",
    class = "TutorTaskView"
  },
  TutorGraduationView = {
    id = 488,
    tab = nil,
    name = "导师毕业界面",
    desc = "",
    prefab = "TutorGraduationView",
    class = "TutorGraduationView"
  },
  PicMakeView = {
    id = 490,
    tab = nil,
    name = "图纸制作界面",
    desc = "",
    prefab = "PicMakeView",
    class = "PicMakeView"
  },
  PicTipPopUp = {
    id = 495,
    tab = nil,
    name = "图纸制作弹框",
    desc = "",
    prefab = "PicTipPopUp",
    class = "PicTipPopUp"
  },
  ShopMallMainView = {
    id = 500,
    tab = nil,
    name = "商城主界面",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ShopMallExchangeBuyInfoView = {
    id = 501,
    tab = nil,
    name = "商城交易所购买详情界面",
    desc = "",
    prefab = "ShopMallExchangeInfoView",
    class = "ShopMallExchangeBuyInfoView"
  },
  ShopMallExchangeSellInfoView = {
    id = 502,
    tab = nil,
    name = "商城交易所出售详情界面",
    desc = "",
    prefab = "ShopMallExchangeInfoView",
    class = "ShopMallExchangeSellInfoView"
  },
  ShopMallExchangeSearchView = {
    id = 503,
    tab = nil,
    name = "商城交易所搜索界面",
    desc = "",
    prefab = "ShopMallExchangeSearchView",
    class = "ShopMallExchangeSearchView"
  },
  ShopMallExchangeView = {
    id = 504,
    tab = nil,
    name = "商城交易所",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ShopMallShopView = {
    id = 505,
    tab = nil,
    name = "商城商城",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ShopMallRechargeView = {
    id = 506,
    tab = nil,
    name = "商城充值",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ExchangeExpressView = {
    id = 507,
    tab = nil,
    name = "交易所赠送",
    desc = "",
    prefab = "ExchangeExpressView",
    class = "ExchangeExpressView"
  },
  ExchangeRecordDetailView = {
    id = 508,
    tab = nil,
    name = "交易所交易记录详情",
    desc = "",
    prefab = "ExchangeRecordDetailView",
    class = "ExchangeRecordDetailView"
  },
  ExchangeFriendView = {
    id = 509,
    tab = nil,
    name = "交易所赠送好友选择",
    desc = "",
    prefab = "ExchangeFriendView",
    class = "ExchangeFriendView"
  },
  ExchangeSignExpressView = {
    id = 510,
    tab = nil,
    name = "交易所签收快递",
    desc = "",
    prefab = "ExchangeSignExpressView",
    class = "ExchangeSignExpressView"
  },
  ShopMallPreorderEditView = {
    id = 511,
    tab = nil,
    name = "商城交易预购编辑界面",
    desc = "",
    prefab = "ShopMallPreorderEditView",
    class = "ShopMallPreorderEditView"
  },
  ShopMallPreorderInfoView = {
    id = 512,
    tab = nil,
    name = "商城交易预购信息界面",
    desc = "",
    prefab = "ShopMallPreorderInfoView",
    class = "ShopMallPreorderInfoView"
  },
  GuildInfoView = {
    id = 520,
    tab = 1,
    name = "公会主界面",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildInfoPage = {
    id = 521,
    tab = 1,
    name = "公会信息界面",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildMemberListPage = {
    id = 522,
    tab = 2,
    name = "公会队员界面",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildFaithPage = {
    id = 523,
    tab = 3,
    name = "公会信仰界面",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildFindPage = {
    id = 524,
    tab = 4,
    name = "公会查找界面",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildAssetPage = {
    id = 525,
    tab = 5,
    name = "公会资产界面",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildFindView = {
    id = 526,
    tab = nil,
    name = "公会大厅界面",
    desc = "",
    prefab = "GuildFindView",
    class = "GuildFindView"
  },
  GvgLandPlanView = {
    id = 527,
    tab = nil,
    name = "GVG占城计划界面",
    desc = "",
    prefab = "GvgLandPlanView",
    class = "GvgLandPlanView"
  },
  GLandStatusListView = {
    id = 528,
    tab = 5,
    name = "公会据点状态界面",
    desc = "",
    prefab = "GLandStatusListView",
    class = "GLandStatusListView"
  },
  GuildApplyApprove = {
    id = 529,
    tab = nil,
    name = "公会申请审批",
    desc = "",
    prefab = "GuildApplyApprove",
    class = "GuildApplyApprove"
  },
  CreateGuildPopUp = {
    id = 530,
    tab = nil,
    name = "公会创建",
    desc = "",
    prefab = "CreateGuildPopUp",
    class = "CreateGuildPopUp"
  },
  GuildJobEditPopUp = {
    id = 531,
    tab = nil,
    name = "公会职位编辑",
    desc = "",
    prefab = "GuildJobEditPopUp",
    class = "GuildJobEditPopUp"
  },
  GuildJobChangePopUp = {
    id = 532,
    tab = nil,
    name = "公会职位变更",
    desc = "",
    prefab = "GuildJobChangePopUp",
    class = "GuildJobChangePopUp"
  },
  GuildApplyListPopUp = {
    id = 533,
    tab = 1,
    name = "公会申请列表",
    desc = "",
    prefab = "GuildApplyListPopUp",
    class = "GuildApplyListPopUp"
  },
  GuildHeadChoosePopUp = {
    id = 534,
    tab = nil,
    name = "公会头像更换界面",
    desc = "",
    prefab = "GuildHeadChoosePopUp",
    class = "GuildHeadChoosePopUp"
  },
  GuildEventPopUp = {
    id = 535,
    tab = nil,
    name = "公会事件界面",
    desc = "",
    prefab = "GuildEventPopUp",
    class = "GuildEventPopUp"
  },
  GuildTreasurePopUp = {
    id = 536,
    tab = nil,
    name = "公会宝箱贡献界面",
    desc = "",
    prefab = "GuildTreasurePopUp",
    class = "GuildTreasurePopUp"
  },
  GuildApprovePopUp = {
    id = 537,
    tab = 2,
    name = "公会审批界面",
    desc = "",
    prefab = "GuildApprovePopUp",
    class = "GuildApprovePopUp"
  },
  GuildPrayDialog = {
    id = 538,
    tab = nil,
    name = "公会祈祷界面",
    desc = "",
    prefab = "GuildPrayDialog",
    class = "GuildPrayDialog"
  },
  GuildFindPopUp = {
    id = 540,
    tab = nil,
    name = "加入公会",
    desc = "",
    prefab = "GuildFindPopUp",
    class = "GuildFindPopUp"
  },
  GuildDonateView = {
    id = 545,
    tab = nil,
    name = "公会贡献界面",
    desc = "",
    prefab = "GuildDonateView",
    class = "GuildDonateView"
  },
  GuildOpenRaidDialog = {
    id = 546,
    tab = nil,
    name = "公会挑战界面",
    desc = "",
    prefab = "GuildOpenRaidDialog",
    class = "GuildOpenRaidDialog"
  },
  AstrolabeView = {
    id = 547,
    tab = nil,
    name = "公会星盘界面",
    desc = "",
    prefab = "AstrolabeView",
    class = "AstrolabeView"
  },
  GuildChangeNamePopUp = {
    id = 548,
    tab = nil,
    name = "公会更名",
    desc = "",
    prefab = "GuildChangeNamePopUp",
    class = "GuildChangeNamePopUp"
  },
  GuildChallengeTaskPopUp = {
    id = 549,
    tab = nil,
    name = "公会挑战任务",
    desc = "",
    prefab = "GuildChallengeTaskPopUp",
    class = "GuildChallengeTaskPopUp"
  },
  AdventureAppendRewardPanel = {
    id = 550,
    tab = nil,
    name = "冒险手册追加",
    desc = "",
    prefab = "AdventureAppendRewardPanel",
    class = "AdventureAppendRewardPanel"
  },
  AstrolabeAskForConvertPopUp = {
    id = 551,
    name = "星盘请求兑换绑定",
    desc = "",
    prefab = "AstrolabeAskForConvertPopUp",
    class = "AstrolabeAskForConvertPopUp"
  },
  RollRewardWaitForRollPopUp = {
    id = 552,
    name = "roll币等待",
    desc = "",
    prefab = "RollRewardWaitForRollPopUp",
    class = "RollRewardWaitForRollPopUp"
  },
  GLandStatusCombineView = {
    id = 553,
    name = "GVG信息整合",
    desc = "",
    prefab = "GLandStatusCombineView",
    class = "GLandStatusCombineView"
  },
  GLandChallengeView = {
    id = 554,
    name = "GVG目标",
    desc = "",
    prefab = "GLandChallengeView",
    class = "GLandChallengeView"
  },
  SpeechRecognizerView = {
    id = 560,
    tab = nil,
    name = "语音弹出小话筒",
    desc = "",
    prefab = "SpeechRecognizerView",
    class = "SpeechRecognizerView"
  },
  GVGRankPopUp = {
    id = 565,
    tab = nil,
    name = "GVG排名",
    desc = "",
    prefab = "GVGRankPopUp",
    class = "GVGRankPopUp"
  },
  GVGRankPopUp_Gvg = {
    id = 566,
    tab = 1,
    name = "公会战排名",
    desc = "",
    prefab = "GVGRankPopUp",
    class = "GVGRankPopUp_Gvg"
  },
  GVGRankPopUp_SuperGvg = {
    id = 566,
    tab = 2,
    name = "巅峰赛排名",
    desc = "",
    prefab = "GVGRankPopUp",
    class = "GVGRankPopUp_SuperGvg"
  },
  DojoGroupView = {
    id = 570,
    tab = nil,
    name = "选择道场",
    desc = "",
    prefab = "DojoGroupView",
    class = "DojoGroupView"
  },
  DojoMainView = {
    id = 571,
    tab = nil,
    name = "挑战道场",
    desc = "",
    prefab = "DojoMainView",
    class = "DojoMainView"
  },
  DojoWaitView = {
    id = 572,
    tab = nil,
    name = "道场等待队友",
    desc = "",
    prefab = "DojoWaitView",
    class = "DojoWaitView"
  },
  DungeonCountDownView = {
    id = 573,
    tab = nil,
    name = "进入副本倒计时",
    desc = "",
    prefab = "DungeonCountDownView",
    class = "DungeonCountDownView"
  },
  DojoResultPopUp = {
    id = 574,
    tab = nil,
    name = "道场胜利奖励",
    desc = "",
    prefab = "DojoResultPopUp",
    class = "DojoResultPopUp"
  },
  RaidResultPopUp = {
    id = 575,
    tab = nil,
    name = "副本胜利",
    desc = "",
    prefab = "RaidResultPopUp",
    class = "RaidResultPopUp"
  },
  CountDownView = {
    id = 580,
    tab = nil,
    name = "副本倒计时",
    desc = "",
    prefab = "CountDownView",
    class = "CountDownView"
  },
  CountDownPopUp = {
    id = 581,
    tab = nil,
    name = "任务用倒计时",
    desc = "",
    prefab = "CountDownPopUp",
    class = "CountDownPopUp"
  },
  SealTaskPopUp = {
    id = 590,
    tab = nil,
    name = "封印接取面板",
    desc = "",
    prefab = "SealTaskPopUp",
    class = "SealTaskPopUp"
  },
  SealTaskPopUpV2 = {
    id = 591,
    tab = nil,
    name = "新版封印接取面板",
    desc = "",
    prefab = "SealTaskPopUp",
    class = "SealTaskPopUpV2"
  },
  RepairSealConfirmPopUp = {
    id = 595,
    tab = nil,
    name = "封印开始面板",
    desc = "",
    prefab = "RepairSealConfirmPopUp",
    class = "RepairSealConfirmPopUp",
    hideCollider = true
  },
  InstituteResultPopUp = {
    id = 610,
    tab = nil,
    name = "研究所结算面板",
    desc = "",
    prefab = "InstituteResultPopUp",
    class = "InstituteResultPopUp"
  },
  AdventureSkill = {
    id = 620,
    name = "冒险技能",
    prefab = "UIViewAdventureSkill",
    class = "UIViewControllerAdventureSkill"
  },
  SetView = {
    id = 630,
    name = "设置",
    prefab = "SetView",
    class = "SetView",
    hideCollider = true
  },
  SetViewSystemState = {
    id = 631,
    tab = 1,
    name = "系统设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewEffectState = {
    id = 632,
    tab = 2,
    name = "特效设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewSecurityPage = {
    id = 633,
    tab = 3,
    name = "安全设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServicePage = {
    id = 634,
    tab = 4,
    name = "日服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceTWPage = {
    id = 635,
    tab = 4,
    name = "台服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceKRPage = {
    id = 636,
    tab = 4,
    name = "韩服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceWWPage = {
    id = 637,
    tab = 4,
    name = "东南亚服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceNAPage = {
    id = 638,
    tab = 4,
    name = "北美服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceEUPage = {
    id = 639,
    tab = 4,
    name = "欧服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceNOPage = {
    id = 642,
    tab = 4,
    name = "东南亚服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceNOTWPage = {
    id = 643,
    tab = 4,
    name = "东南亚服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  SetViewServiceNOENPage = {
    id = 644,
    tab = 4,
    name = "欧美初心服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  PCSetView = {
    id = 640,
    name = "PC设置",
    prefab = "PCSetView",
    class = "PCSetView",
    hideCollider = true
  },
  PCHotKeySetView = {
    id = 641,
    name = "PC快捷键设置",
    prefab = "PCHotKeySetView",
    class = "PCHotKeySetView"
  },
  NoticeMsgView = {
    id = 649,
    name = "公告",
    prefab = "NoticeMsgView",
    class = "NoticeMsgView"
  },
  PlayerDetailView = {
    id = 650,
    tab = nil,
    name = "玩家详细信息界面",
    desc = "",
    prefab = "PlayerDetailView",
    class = "PlayerDetailView",
    hideCollider = true
  },
  EDView = {
    id = 660,
    tab = nil,
    name = "EDUI界面",
    desc = "",
    prefab = "EDView",
    class = "EDView",
    hideCollider = true
  },
  EDView2 = {
    id = 661,
    tab = nil,
    name = "EDUI2界面",
    desc = "",
    prefab = "EDView2",
    class = "EDView2",
    hideCollider = true
  },
  SkyWheelAcceptView = {
    id = 670,
    tab = nil,
    name = "摩天轮接受",
    desc = "",
    prefab = "SkyWheelAcceptView",
    class = "SkyWheelAcceptView"
  },
  SkyWheelSearchView = {
    id = 671,
    tab = nil,
    name = "摩天轮搜索",
    desc = "",
    prefab = "SkyWheelSearchView",
    class = "SkyWheelSearchView"
  },
  SkyWheelFriendView = {
    id = 672,
    tab = nil,
    name = "摩天轮好友",
    desc = "",
    prefab = "SkyWheelFriendView",
    class = "SkyWheelFriendView"
  },
  EquipMakeView = {
    id = 680,
    tab = nil,
    name = "装备制作",
    desc = "",
    prefab = "EquipMakeView",
    class = "EquipMakeView"
  },
  EquipRecoverView = {
    id = 681,
    tab = nil,
    name = "装备熔炉",
    desc = "",
    prefab = "EquipRecoverView",
    class = "EquipRecoverView"
  },
  EquipRecoverNewView = {
    id = 682,
    tab = nil,
    name = "装备熔炉",
    desc = "",
    prefab = "EquipRecoverNewView",
    class = "EquipRecoverNewView"
  },
  EquipAlchemyView = {
    id = 685,
    tab = nil,
    name = "装备炼金",
    desc = "",
    prefab = "EquipAlchemyView",
    class = "EquipAlchemyView"
  },
  ItemMakeView = {
    id = 686,
    tab = nil,
    name = "道具制作",
    desc = "",
    prefab = "EquipMakeView",
    class = "ItemMakeView"
  },
  EquipMfrView = {
    id = 687,
    tab = nil,
    name = "新装备制作",
    desc = "",
    prefab = "EquipMfrView",
    class = "EquipMfrView"
  },
  ChangeZoneView = {
    id = 690,
    tab = nil,
    name = "切换异次元",
    desc = "",
    prefab = "ChangeZoneView",
    class = "ChangeZoneView"
  },
  GiftActivePanel = {
    id = 700,
    tab = nil,
    name = "礼包码兑换",
    desc = "",
    prefab = "GiftActivePanel",
    class = "GiftActivePanel"
  },
  ChangeHeadView = {
    id = 710,
    tab = nil,
    name = "更换头像",
    desc = "",
    prefab = "ChangeHeadView",
    class = "ChangeHeadView"
  },
  ZenyShop = {
    id = 720,
    tab = 1,
    name = "Zeny商城",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  ZenyShopMonthlyVIP = {
    id = 721,
    tab = 2,
    name = "月卡购买",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  ZenyShopGachaCoin = {
    id = 722,
    tab = 3,
    name = "扭蛋币购买",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  ZenyShopItem = {
    id = 723,
    tab = 4,
    name = "道具购买",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  AppStorePurchase = {
    id = 724,
    tab = nil,
    name = "",
    desc = "",
    prefab = "UIViewAppStorePurchase",
    class = "UVC_AppStorePurchase"
  },
  NewRecharge_TShop = {
    id = 725,
    tab = 1,
    name = "新打赏-商城",
    desc = "",
    prefab = "NewRechargeView",
    class = "NewRechargeView"
  },
  NewRecharge_TCard = {
    id = 726,
    tab = 2,
    name = "新打赏-特典",
    desc = "",
    prefab = "NewRechargeView",
    class = "NewRechargeView"
  },
  NewRecharge_TDeposit = {
    id = 727,
    tab = 3,
    name = "新打赏-打赏",
    desc = "",
    prefab = "NewRechargeView",
    class = "NewRechargeView"
  },
  NewRecharge_THot = {
    id = 728,
    tab = 4,
    name = "新打赏-热销",
    desc = "",
    prefab = "NewRechargeView",
    class = "NewRechargeView"
  },
  NewRecharge_THero = {
    id = 729,
    tab = 5,
    name = "新打赏-英雄",
    desc = "",
    prefab = "NewRechargeView",
    class = "NewRechargeView"
  },
  ChangeNameView = {
    id = 730,
    tab = nil,
    name = "更换角色名称",
    desc = "",
    prefab = "ChangeNameView",
    class = "ChangeNameView"
  },
  RoleChangeNamePopUp = {
    id = 731,
    tab = nil,
    name = "更换角色名称",
    desc = "",
    prefab = "RoleChangeNamePopUp",
    class = "RoleChangeNamePopUp"
  },
  ShortCutOptionPopUp = {
    id = 740,
    tab = nil,
    name = "追踪选择界面",
    desc = "",
    prefab = "ShortCutOptionPopUp",
    class = "ShortCutOptionPopUp"
  },
  AuguryView = {
    id = 750,
    tab = nil,
    name = "占卜",
    desc = "",
    prefab = "AuguryView",
    class = "AuguryView"
  },
  ValentineView = {
    id = 760,
    tab = nil,
    name = "白色情人节情书",
    desc = "",
    prefab = "ValentineView",
    class = "ValentineView"
  },
  StarView = {
    id = 761,
    tab = nil,
    name = "星座絮语情书",
    desc = "",
    prefab = "StarView",
    class = "StarView"
  },
  ChristmasInviteView = {
    id = 762,
    tab = nil,
    name = "圣诞情书邀请",
    desc = "",
    prefab = "ChristmasInviteView",
    class = "ChristmasInviteView"
  },
  ChristmasView = {
    id = 763,
    tab = nil,
    name = "圣诞情书",
    desc = "",
    prefab = "ChristmasView",
    class = "ChristmasView"
  },
  SpringActivityInviteView = {
    id = 764,
    tab = nil,
    name = "春节贺卡邀请",
    desc = "",
    prefab = "SpringActivityInviteView",
    class = "SpringActivityInviteView"
  },
  SpringActivityView = {
    id = 765,
    tab = nil,
    name = "春节贺卡",
    desc = "",
    prefab = "SpringActivityView",
    class = "SpringActivityView"
  },
  LotteryGiftView = {
    id = 766,
    tab = nil,
    name = "扭蛋祝福",
    desc = "",
    prefab = "LotteryGiftView",
    class = "LotteryGiftView"
  },
  WeddingDressSendView = {
    id = 767,
    tab = nil,
    name = "婚纱赠送赠送",
    desc = "",
    prefab = "WeddingDressSendView",
    class = "WeddingDressSendView"
  },
  WeddingDressView = {
    id = 768,
    tab = nil,
    name = "婚纱赠送书信",
    desc = "",
    prefab = "WeddingDressView",
    class = "WeddingDressView"
  },
  VideoPanel = {
    id = 770,
    tab = nil,
    name = "冒险手册珍藏品视频",
    desc = "",
    prefab = "VideoPanel",
    class = "VideoPanel",
    hideCollider = false
  },
  PreVideoPanel = {
    id = 771,
    tab = nil,
    name = "预加载冒险手册珍藏品视频",
    desc = "",
    prefab = "PreVideoPanel",
    class = "PreVideoPanel",
    hideCollider = false
  },
  UIVictoryView = {
    id = 780,
    tab = nil,
    name = "打斗场结算界面",
    desc = "",
    prefab = "UIVictoryView",
    class = "UIVictoryView"
  },
  DressingView = {
    id = 790,
    tab = nil,
    name = "理发店美瞳商城",
    desc = "",
    prefab = "DressingView",
    class = "DressingView"
  },
  HairPage = {
    id = 791,
    tab = 1,
    name = "理发界面",
    desc = "",
    prefab = "DressingView",
    class = "HairPage"
  },
  EyePage = {
    id = 792,
    tab = 2,
    name = "美瞳界面",
    desc = "",
    prefab = "DressingView",
    class = "EyePage"
  },
  PlotStoryView = {
    id = 800,
    tab = nil,
    name = "剧情故事界面",
    desc = "",
    prefab = "PlotStoryView",
    class = "PlotStoryView",
    forbidesc = true
  },
  StoryView = {
    id = 801,
    tab = nil,
    name = "剧情界面",
    desc = "",
    prefab = "PlotStoryView",
    class = "StoryView",
    forbidesc = true,
    hideCollider = true
  },
  PlotStoryEndingCreditsView = {
    id = 802,
    tab = nil,
    name = "ed界面",
    desc = "",
    prefab = "PlotStoryEndingCreditsView",
    class = "PlotStoryEndingCreditsView",
    forbidesc = true
  },
  PlotStoryTopView = {
    id = 803,
    tab = nil,
    name = "剧情最高层级界面",
    desc = "",
    prefab = "PlotStoryTopView",
    class = "PlotStoryTopView",
    forbidesc = true,
    hideCollider = true
  },
  HireCatInfoView = {
    id = 810,
    tab = nil,
    name = "雇佣猫详情",
    desc = "",
    prefab = "HireCatInfoView",
    class = "HireCatInfoView"
  },
  SecretReportPvpPopUp = {
    id = 820,
    tab = nil,
    name = "密码报名",
    desc = "",
    prefab = "SecretReportPvpPopUp",
    class = "SecretReportPvpPopUp"
  },
  DialogView = {
    id = 829,
    tab = nil,
    name = "对话",
    desc = "",
    prefab = "DialogView",
    class = "DialogView",
    hideCollider = false
  },
  WeakDialogView = {
    id = 830,
    tab = nil,
    name = "滑动对话",
    desc = "",
    prefab = "WeakDialogView",
    class = "WeakDialogView",
    hideCollider = true
  },
  DialogMaskView = {
    id = 831,
    tab = nil,
    name = "对话蒙板",
    desc = "",
    prefab = "DialogMaskView",
    class = "DialogMaskView",
    hideCollider = false
  },
  ShowPicturePopup = {
    id = 832,
    tab = nil,
    name = "查看图片提示",
    desc = "",
    prefab = "ShowPicturePopup",
    class = "ShowPicturePopup",
    hideCollider = false
  },
  DialogView_Popup = {
    id = 833,
    tab = nil,
    name = "浮动窗层级对话",
    desc = "",
    prefab = "DialogView",
    class = "DialogView_Popup",
    hideCollider = true
  },
  HandUpView = {
    id = 900,
    tab = nil,
    name = "挂机界面",
    desc = "",
    prefab = "HandUpView",
    class = "HandUpView"
  },
  PopUpItemView = {
    id = 910,
    tab = nil,
    name = "道具获得弹框",
    desc = "",
    prefab = "PopUpItemView",
    class = "PopUpItemView",
    hideCollider = false
  },
  ItemGuidePopUp = {
    id = 911,
    tab = nil,
    name = "道具使用限制引导弹框",
    desc = "",
    prefab = "ItemGuidePopUp",
    class = "ItemGuidePopUp",
    hideCollider = false
  },
  TipoffView = {
    id = 912,
    tab = nil,
    name = "举报",
    desc = "",
    prefab = "TipoffView",
    class = "TipoffView",
    hideCollider = false
  },
  DesertWolfNewView = {
    id = 913,
    tab = 2,
    name = "沙漠之狼斗技场新",
    desc = "",
    prefab = "DesertWolf/DesertWolfNewView",
    class = "DesertWolfNewView"
  },
  DesertWolfCreateRoomPopup = {
    id = 914,
    tab = nil,
    name = "沙漠之狼创建房间",
    desc = "",
    prefab = "DesertWolf/DesertWolfCreateRoomPopup",
    class = "DesertWolfCreateRoomPopup"
  },
  DesertWolfRoomInfoPopup = {
    id = 915,
    tab = nil,
    name = "沙漠之狼房间详情",
    desc = "",
    prefab = "TeamPwsCustomRoomInfoPopup",
    class = "DesertWolfRoomInfoPopup"
  },
  DesertWolfReportPopup = {
    id = 916,
    tab = nil,
    name = "沙漠之狼统计面板",
    desc = "",
    prefab = "DesertWolf/DesertWolfReportPopup",
    class = "DesertWolfReportPopup"
  },
  DesertWolfFightResultPopup = {
    id = 917,
    tab = nil,
    name = "沙漠之狼结算面板",
    desc = "",
    prefab = "DesertWolf/DesertWolfFightResultPopup",
    class = "DesertWolfFightResultPopup"
  },
  PvpContainerView = {
    id = 920,
    tab = nil,
    name = "新版打斗场",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  YoyoViewPage = {
    id = 921,
    tab = 1,
    name = "溜溜猴打斗场",
    desc = "",
    prefab = "YoyoViewPage",
    class = "YoyoViewPage"
  },
  DesertWolfView = {
    id = 922,
    tab = 2,
    name = "沙漠之狼斗技场",
    desc = "",
    prefab = "DesertWolfView",
    class = "DesertWolfView"
  },
  GorgeousMetalView = {
    id = 923,
    tab = 3,
    name = "华丽金属抢夺战",
    desc = "",
    prefab = "GorgeousMetalView",
    class = "GorgeousMetalView"
  },
  DesertWolfJoinView = {
    id = 924,
    tab = nil,
    name = "沙漠之狼报名",
    desc = "",
    prefab = "DesertWolfJoinView",
    class = "DesertWolfJoinView"
  },
  TeamPwsView = {
    id = 925,
    tab = 1,
    name = "排位竞技赛",
    desc = "",
    prefab = "TeamPwsView",
    class = "TeamPwsView"
  },
  CupModeView = {
    id = 933,
    tab = 18,
    name = "杯赛模式",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  CompetiveModeView = {
    id = 934,
    tab = 11,
    name = "竞技模式",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  FreeBattleView = {
    id = 926,
    tab = 12,
    name = "休闲竞技赛",
    desc = "",
    prefab = "FreeBattleView",
    class = "FreeBattleView"
  },
  ClassicBattleView = {
    id = 927,
    tab = 13,
    name = "经典模式战场",
    desc = "",
    prefab = "ClassicBattleView",
    class = "ClassicBattleView"
  },
  MultiPvpView = {
    id = 928,
    tab = 14,
    name = "12人PVP",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  LeisureModelView = {
    id = 929,
    tab = 1,
    name = "12人PVP休闲模式",
    desc = "",
    prefab = "LeisureModelView",
    class = "LeisureModelView"
  },
  WarbandModelView = {
    id = 945,
    tab = 17,
    name = "12人PVP杯赛模式",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  WarbandRewardPopUp = {
    id = 946,
    tab = nil,
    name = "12人PVP杯赛奖励详情",
    desc = "",
    prefab = "WarbandRewardPopUp",
    class = "WarbandRewardPopUp"
  },
  WarbandSignupPopUp = {
    id = 947,
    tab = nil,
    name = "战队报名",
    desc = "",
    prefab = "WarbandSignupPopUp",
    class = "WarbandSignupPopUp"
  },
  WarbandSeasonRankPopUp = {
    id = 948,
    tab = nil,
    name = "赛季排名",
    desc = "",
    prefab = "WarbandSeasonRankPopUp",
    class = "WarbandSeasonRankPopUp"
  },
  MobaPVPView = {
    id = 949,
    tab = 15,
    name = "3v3v3",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  MobaPvpCompetiveView = {
    id = 936,
    tab = 16,
    name = "3v3v3",
    desc = "",
    prefab = "PvpContainerView",
    class = "PvpContainerView"
  },
  BusinessmanMakeView = {
    id = 930,
    tab = nil,
    name = "商人制作",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "BusinessmanMakeView"
  },
  AlchemistMakeView = {
    id = 931,
    tab = nil,
    name = "炼金制作",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "AlchemistMakeView"
  },
  KnightMakeView = {
    id = 932,
    tab = nil,
    name = "炼金制作",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "KnightMakeView"
  },
  HollgrehennMakeView = {
    id = 935,
    tab = nil,
    name = "忽克连制作",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "HollgrehennMakeView"
  },
  MagicStoneRecoverView = {
    id = 940,
    tab = nil,
    name = "卸卡魔石",
    desc = "",
    prefab = "MagicStoneRecoverView",
    class = "MagicStoneRecoverView"
  },
  CardRandomMakeView = {
    id = 950,
    tab = nil,
    name = "卡片再生机抽卡",
    desc = "",
    prefab = "CardRandomMakeView",
    class = "CardRandomMakeView"
  },
  CardMakeView = {
    id = 960,
    tab = nil,
    name = "卡片再生机合成",
    desc = "",
    prefab = "CardMakeView",
    class = "CardMakeView"
  },
  GeneralShareView = {
    id = 970,
    tab = nil,
    name = "分享通用界面",
    desc = "",
    prefab = "GeneralShareView",
    class = "GeneralShareView"
  },
  FoodMakeView = {
    id = 980,
    tab = nil,
    name = "料理制作界面",
    desc = "",
    prefab = "FoodMakeView",
    class = "FoodMakeView"
  },
  FoodGetPopUp = {
    id = 985,
    tab = nil,
    name = "料理获得界面",
    desc = "",
    prefab = "FoodGetPopUp",
    class = "FoodGetPopUp",
    hideCollider = true
  },
  EatFoodPopUp = {
    id = 986,
    tab = nil,
    name = "吃料理界面",
    desc = "",
    prefab = "EatFoodPopUp",
    class = "EatFoodPopUp",
    hideCollider = true
  },
  AdventurePutFoodPopUp = {
    id = 987,
    name = "放置食物界面",
    desc = "",
    prefab = "AdventurePutFoodPopUp",
    class = "AdventurePutFoodPopUp"
  },
  AdventureMakeFoodPopUp = {
    id = 988,
    name = "制作食物界面",
    desc = "",
    prefab = "AdventureMakeFoodPopUp",
    class = "AdventureMakeFoodPopUp"
  },
  LotteryHeadwearView = {
    id = 990,
    tab = nil,
    name = "扭蛋头饰",
    desc = "",
    prefab = "LotteryHeadwearView",
    class = "LotteryHeadwearView"
  },
  LotteryEquipView = {
    id = 991,
    tab = nil,
    name = "扭蛋装备",
    desc = "",
    prefab = "LotteryEquipView",
    class = "LotteryEquipView"
  },
  LotteryCardView = {
    id = 992,
    tab = nil,
    name = "扭蛋卡片",
    desc = "",
    prefab = "LotteryCardView",
    class = "LotteryCardView"
  },
  CatLitterBoxView = {
    id = 993,
    tab = nil,
    name = "福利猫砂盆",
    desc = "",
    prefab = "CatLitterBoxView",
    class = "CatLitterBoxView"
  },
  LotteryMagicView = {
    id = 994,
    tab = nil,
    name = "扭蛋魔力",
    desc = "",
    prefab = "LotteryMagicView",
    class = "LotteryMagicView"
  },
  LotteryExpressView = {
    id = 995,
    tab = nil,
    name = "扭蛋赠送",
    desc = "",
    prefab = "LotteryExpressView",
    class = "LotteryExpressView",
    hideCollider = false
  },
  LotteryMagicSecView = {
    id = 996,
    tab = nil,
    name = "扭蛋魔力2",
    desc = "",
    prefab = "LotteryMagicView",
    class = "LotteryMagicSecView"
  },
  LotteryMagicThirdView = {
    id = 1996,
    tab = nil,
    name = "扭蛋魔力3",
    desc = "",
    prefab = "LotteryMagicView",
    class = "LotteryMagicThirdView"
  },
  LotteryResultView = {
    id = 997,
    tab = nil,
    name = "扭蛋十连抽结算",
    desc = "",
    prefab = "LotteryResultView",
    class = "LotteryResultView"
  },
  MountLotteryResultView = {
    id = 998,
    tab = nil,
    name = "坐骑扭蛋十连抽结算",
    desc = "",
    prefab = "LotteryResultView",
    class = "MountLotteryResultView"
  },
  HeadWearRecoverView = {
    id = 1997,
    tab = nil,
    name = "头饰回收",
    desc = "",
    prefab = "HeadWearRecoverView",
    class = "HeadWearRecoverView"
  },
  AuctionView = {
    id = 1000,
    tab = nil,
    name = "拍卖",
    desc = "",
    prefab = "AuctionView",
    class = "AuctionView"
  },
  AuctionSignUpView = {
    id = 1001,
    tab = nil,
    name = "拍卖报名",
    desc = "",
    prefab = "AuctionSignUpView",
    class = "AuctionSignUpView"
  },
  AuctionSignUpDetailView = {
    id = 1002,
    tab = nil,
    name = "拍卖报名详情",
    desc = "",
    prefab = "AuctionSignUpDetailView",
    class = "AuctionSignUpDetailView"
  },
  AuctionRecordView = {
    id = 1003,
    tab = nil,
    name = "拍卖日志",
    desc = "",
    prefab = "AuctionRecordView",
    class = "AuctionRecordView"
  },
  AuctionSignUpSelectView = {
    id = 1004,
    tab = nil,
    name = "拍卖报名选择",
    desc = "",
    prefab = "AuctionSignUpSelectView",
    class = "AuctionSignUpSelectView"
  },
  SlotMachineView = {
    id = 1010,
    tab = nil,
    name = "拉霸机",
    desc = "",
    prefab = "SlotMachineView",
    class = "SlotMachineView"
  },
  PetCatchSuccessView = {
    id = 1011,
    tab = nil,
    name = "宠物捕获成功界面",
    desc = "",
    prefab = "PetCatchSuccessView",
    class = "PetCatchSuccessView"
  },
  PetMakeNamePopUp = {
    id = 1012,
    tab = nil,
    name = "宠物取名界面",
    desc = "",
    prefab = "PetMakeNamePopUp",
    class = "PetMakeNamePopUp"
  },
  PetInfoView = {
    id = 1020,
    tab = nil,
    name = "宠物详情界面",
    desc = "",
    prefab = "PetInfoView",
    class = "PetInfoView"
  },
  EquipConvertView = {
    id = 1030,
    name = "新装备兑换",
    desc = "",
    prefab = "HappyShop",
    class = "EquipConvertView"
  },
  EquipConvertResultView = {
    id = 1031,
    name = "新装备属性解锁",
    desc = "",
    prefab = "EquipConvertResultView",
    class = "EquipConvertResultView"
  },
  ClothDressingView = {
    id = 1041,
    tab = nil,
    name = "服装店",
    desc = "",
    prefab = "ClothDressingView",
    class = "ClothDressingView"
  },
  GvgLandInfoPopUp = {
    id = 1050,
    tab = nil,
    name = "公会战争",
    desc = "",
    prefab = "GvgLandInfoPopUp",
    class = "GvgLandInfoPopUp"
  },
  GVGSandTablePanel = {
    id = 1051,
    tab = nil,
    name = "公会沙盘",
    desc = "",
    prefab = "GVGSandTablePanel",
    class = "GVGSandTablePanel"
  },
  GVGWeeklyPointPopUp = {
    id = 1052,
    tab = nil,
    name = "公会排行榜-公会每周分数",
    desc = "",
    prefab = "GVGWeeklyPointPopUp",
    class = "GVGWeeklyPointPopUp"
  },
  UniqueConfirmView_GvgLandGiveUp = {
    id = 1055,
    tab = nil,
    name = "公会据点放弃确认框",
    desc = "",
    prefab = "UniqueConfirmView_GvgLandGiveUp",
    class = "UniqueConfirmView_GvgLandGiveUp"
  },
  UniqueConfirmView_Hotfix = {
    id = 1056,
    tab = nil,
    name = "热更提示确认框",
    desc = "",
    prefab = "UniqueConfirmView_Hotfix",
    class = "UniqueConfirmView_Hotfix"
  },
  QuotaCardView = {
    id = 1060,
    tab = nil,
    name = "猫金打赏积分卡",
    desc = "",
    prefab = "QuotaCardView",
    class = "QuotaCardView"
  },
  LotteryMainView = {
    id = 1061,
    tab = nil,
    name = "扭蛋主界面",
    desc = "",
    prefab = "LotteryMainView",
    class = "LotteryMainView"
  },
  LotteryMixed = {
    id = 1062,
    tab = nil,
    name = "混合扭蛋",
    desc = "",
    prefab = "LotteryMainView",
    class = "LotteryMixed"
  },
  LotteryMagic = {
    id = 1063,
    tab = nil,
    name = "大扭蛋",
    desc = "",
    prefab = "LotteryMainView",
    class = "LotteryMagic"
  },
  LotteryCard = {
    id = 1064,
    tab = nil,
    name = "卡片扭蛋",
    desc = "",
    prefab = "LotteryMainView",
    class = "LotteryCard"
  },
  LotteryHead = {
    id = 1065,
    tab = nil,
    name = "小扭蛋",
    desc = "",
    prefab = "LotteryMainView",
    class = "LotteryHead"
  },
  LotteryMixedShop = {
    id = 1066,
    tab = nil,
    name = "混合扭蛋新版商店",
    desc = "",
    prefab = "LotteryMainView",
    class = "LotteryMixedShop"
  },
  QuickBuyView = {
    id = 1070,
    tab = nil,
    name = "快速购买",
    desc = "",
    prefab = "QuickBuyView",
    class = "QuickBuyView"
  },
  BeingInfoView = {
    id = 1080,
    tab = nil,
    name = "快速购买",
    desc = "",
    prefab = "BeingInfoView",
    class = "BeingInfoView"
  },
  GvGPvPPrayDialog = {
    id = 1090,
    tab = nil,
    name = "工会祈祷2.0",
    desc = "",
    prefab = "GvGPvPPrayDialog",
    class = "GvGPvPPrayDialog"
  },
  GvGPvPPrayResetPopUp = {
    id = 1091,
    tab = nil,
    name = "女神祈祷重置",
    desc = "",
    prefab = "GvGPvPPrayResetPopUp",
    class = "GvGPvPPrayResetPopUp"
  },
  GuildHolyPrayDialog = {
    id = 1092,
    tab = nil,
    name = "神圣祝福",
    desc = "",
    prefab = "GuildHolyPrayDialog",
    class = "GuildHolyPrayDialog"
  },
  PoringFightResultView = {
    id = 1100,
    tab = nil,
    name = "波利大乱斗结算界面",
    desc = "",
    prefab = "PoringFightResultView",
    class = "PoringFightResultView"
  },
  RecallShareView = {
    id = 1110,
    tab = nil,
    name = "好友召回分享",
    desc = "",
    prefab = "RecallShareView",
    class = "RecallShareView"
  },
  RecallContractSelectView = {
    id = 1111,
    tab = nil,
    name = "召回契约选择界面",
    desc = "",
    prefab = "RecallContractSelectView",
    class = "RecallContractSelectView"
  },
  RecallView = {
    id = 1112,
    tab = nil,
    name = "召回好友",
    desc = "",
    prefab = "RecallView",
    class = "RecallView"
  },
  RecallContractView = {
    id = 1113,
    tab = nil,
    name = "召回契约",
    desc = "",
    prefab = "RecallContractView",
    class = "RecallContractView"
  },
  RecallPrivilegeView = {
    id = 1114,
    tab = nil,
    name = "契约特权",
    desc = "",
    prefab = "RecallPrivilegeView",
    class = "RecallPrivilegeView"
  },
  EquipUpgradePopUp = {
    id = 1120,
    tab = nil,
    name = "装备升级",
    desc = "",
    prefab = "EquipUpgradePopUp",
    class = "EquipUpgradePopUp"
  },
  EquipUpgradeView = {
    id = 1121,
    tab = nil,
    name = "装备升级",
    desc = "",
    prefab = "EquipUpgradeView",
    class = "EquipUpgradeView"
  },
  EquipUpgradeSubView = {
    id = 1122,
    tab = nil,
    name = "装备升级整合版",
    desc = "",
    prefab = "EquipUpgradeViewType2",
    class = "EquipUpgradeSubView"
  },
  PoringFightTipView = {
    id = 1130,
    tab = nil,
    name = "波利乱斗Tip",
    desc = "",
    prefab = "PoringFightTipView",
    class = "PoringFightTipView",
    hideCollider = true
  },
  QuickMakePopUp = {
    id = 1140,
    name = "装备快速制作",
    desc = "",
    prefab = "EquipUpgradePopUp",
    class = "QuickMakePopUp"
  },
  QuickMfrPopUp = {
    id = 1141,
    name = "装备快速制作-新",
    desc = "",
    prefab = "EquipUpgradePopUp_Mfr",
    class = "QuickMfrPopUp"
  },
  QuickBuyCountChoosePopUp = {
    id = 1150,
    name = "快速购买数量选择",
    desc = "",
    prefab = "QuickBuyCountChoosePopUp",
    class = "QuickBuyCountChoosePopUp"
  },
  MercenaryCatView = {
    id = 1200,
    tab = nil,
    name = "进阶佣兵猫界面",
    desc = "",
    prefab = "MercenaryCatView",
    class = "MercenaryCatView"
  },
  GuildBuildingView = {
    id = 1480,
    tab = nil,
    name = "公会设施",
    desc = "",
    prefab = "GuildBuildingView",
    class = "GuildBuildingView"
  },
  GuildBuildingMatSubmitView = {
    id = 1490,
    tab = nil,
    name = "公会设施提交材料",
    desc = "",
    prefab = "GuildBuildingMatSubmitView",
    class = "GuildBuildingMatSubmitView"
  },
  GuildBuildingRankPopUp = {
    id = 1491,
    tab = nil,
    name = "公会设施贡献排行界面",
    desc = "",
    prefab = "GuildBuildingRankPopUp",
    class = "GuildBuildingRankPopUp",
    hideCollider = true
  },
  RedeemCodeView = {
    id = 1500,
    tab = nil,
    name = "线下兑换",
    desc = "",
    prefab = "RedeemCodeView",
    class = "RedeemCodeView"
  },
  ArtifactMakeView = {
    id = 1510,
    tab = nil,
    name = "制作神器",
    desc = "",
    prefab = "ArtifactMakeView",
    class = "ArtifactMakeView"
  },
  ArtifactDecomposeView = {
    id = 1511,
    tab = nil,
    name = "分解神器",
    desc = "",
    prefab = "EquipMemoryDecomposeView",
    class = "ArtifactDecomposeView"
  },
  ReturnArtifactView = {
    id = 1520,
    tab = nil,
    name = "返还神器",
    desc = "",
    prefab = "ReturnArtifactView",
    class = "ReturnArtifactView"
  },
  ArtifactDistributePopUp = {
    id = 1525,
    tab = nil,
    name = "选择分配神器",
    desc = "",
    prefab = "ArtifactDistributePopUp",
    class = "ArtifactDistributePopUp",
    hideCollider = true
  },
  RealNameCentifyView = {
    id = 1530,
    tab = nil,
    name = "实名认证",
    desc = "",
    prefab = "RealNameCentifyView",
    class = "RealNameCentifyView",
    hideCollider = true
  },
  EngageMainView = {
    id = 1540,
    tab = nil,
    name = "订婚",
    desc = "",
    prefab = "EngageMainView",
    class = "EngageMainView"
  },
  WeddingManualMainView = {
    id = 1541,
    tab = nil,
    name = "结婚手册",
    desc = "",
    prefab = "WeddingManualMainView",
    class = "WeddingManualMainView"
  },
  WeddingProcessView = {
    id = 1542,
    tab = nil,
    name = "婚礼仪式详情",
    desc = "",
    prefab = "WeddingProcessView",
    class = "WeddingProcessView"
  },
  WeddingPackageView = {
    id = 1543,
    tab = nil,
    name = "婚礼仪式套餐",
    desc = "",
    prefab = "WeddingPackageView",
    class = "WeddingPackageView"
  },
  WeddingRingView = {
    id = 1544,
    tab = nil,
    name = "婚礼戒指套餐",
    desc = "",
    prefab = "HappyShop",
    class = "WeddingRingView"
  },
  WeddingInviteView = {
    id = 1545,
    tab = nil,
    name = "婚礼邀请",
    desc = "",
    prefab = "WeddingInviteView",
    class = "WeddingInviteView"
  },
  WeddingQuestionView = {
    id = 1546,
    tab = nil,
    name = "婚礼仪式问答",
    desc = "",
    prefab = "WeddingQuestionView",
    class = "WeddingQuestionView"
  },
  SelectFriendView = {
    id = 1547,
    tab = nil,
    name = "选择好友",
    desc = "",
    prefab = "SelectFriendView",
    class = "SelectFriendView"
  },
  GuildTreasureView = {
    id = 1550,
    tab = nil,
    name = "公会宝箱",
    desc = "",
    prefab = "GuildTreasureView",
    class = "GuildTreasureView"
  },
  ComodoBuildingContainerView = {
    id = 1560,
    name = "克魔岛建筑",
    desc = "",
    prefab = "ComodoBuildingContainerView",
    class = "ComodoBuildingContainerView"
  },
  ComodoBuildingMusicBoxView = {
    id = 1561,
    name = "祈愿八音盒",
    desc = "",
    prefab = "ComodoBuildingMusicBoxView",
    class = "ComodoBuildingMusicBoxView"
  },
  OricalCardInfoView = {
    id = 1570,
    tab = nil,
    name = "神谕牌卡牌预览界面",
    desc = "",
    prefab = "OricalCardInfoView",
    class = "OricalCardInfoView"
  },
  CardDecomposeView = {
    id = 1580,
    tab = nil,
    name = "卡片分解",
    desc = "",
    prefab = "CardDecomposeView",
    class = "CardDecomposeView"
  },
  CardContainerView = {
    id = 1581,
    tab = nil,
    name = "卡片界面",
    desc = "",
    prefab = "CardContainerView",
    class = "CardContainerView"
  },
  CardUpgradeShareView = {
    id = 1582,
    tab = nil,
    name = "卡片强化分享",
    desc = "",
    prefab = "CardUpgradeShareView",
    class = "CardUpgradeShareView"
  },
  EnchantTransferView = {
    id = 1590,
    name = "附魔转移",
    desc = "",
    prefab = "EnchantNewTransferView",
    class = "EnchantTransferView"
  },
  ItemExtractView = {
    id = 1591,
    name = "材料提炼",
    desc = "",
    prefab = "ItemExtractView",
    class = "ItemExtractView"
  },
  RefineTransferView = {
    id = 1592,
    name = "精炼转移",
    desc = "",
    prefab = "RefineTransferView",
    class = "RefineTransferView"
  },
  EquipReplaceNewView = {
    id = 1593,
    name = "新装备开洞",
    desc = "",
    prefab = "EquipReplaceNewView",
    class = "EquipReplaceNewView"
  },
  EquipRecoveryView = {
    id = 1594,
    name = "装备回收交易自由",
    desc = "",
    prefab = "EquipRecoveryView",
    class = "EquipRecoveryView"
  },
  EnchantNewView = {
    id = 1595,
    name = "新附魔界面",
    desc = "",
    prefab = "EnchantView2",
    class = "EnchantNewView"
  },
  EnchantAttrUpView = {
    id = 1596,
    name = "附魔属性提升",
    desc = "",
    prefab = "EnchantAttrUpView2",
    class = "EnchantAttrUpView"
  },
  EnchantThirdAttrResetView = {
    id = 1597,
    name = "附魔第三属性提升",
    desc = "",
    prefab = "EnchantThirdAttrResetView2",
    class = "EnchantThirdAttrResetView"
  },
  EnchantInfoPopup = {
    id = 1598,
    name = "附魔词条展示",
    desc = "",
    prefab = "EnchantInfoPopup",
    class = "EnchantInfoPopup",
    hideCollider = true
  },
  RaidEnterWaitView = {
    id = 1600,
    tab = nil,
    name = "副本进入等待界面",
    desc = "",
    prefab = "EndlessTowerWaitView",
    class = "RaidEnterWaitView"
  },
  GuildTreasureRewardPopUp = {
    id = 1610,
    tab = nil,
    name = "公会宝箱红包界面",
    desc = "",
    prefab = "GuildTreasureRewardPopUp",
    class = "GuildTreasureRewardPopUp"
  },
  RecommendDailyMonsterView = {
    id = 1619,
    tab = nil,
    name = "初心服挂机推荐点",
    desc = "",
    prefab = "RecommendDailyMonsterView",
    class = "RecommendDailyMonsterView"
  },
  ServantNewMainView = {
    id = 1620,
    tab = nil,
    name = "女仆",
    desc = "",
    prefab = "ServantNewMainView",
    class = "ServantNewMainView"
  },
  ServantRecommendView = {
    id = 1621,
    tab = 1,
    name = "今日推荐",
    desc = "",
    prefab = "ServantRecommendView",
    class = "ServantRecommendView"
  },
  FinanceView = {
    id = 1622,
    tab = 2,
    name = "今日财经",
    desc = "",
    prefab = "FinanceView",
    class = "FinanceView"
  },
  ServantImproveViewNew = {
    id = 1624,
    tab = 3,
    name = "提升计划",
    desc = "",
    prefab = "ServantImproveViewNew",
    class = "ServantImproveViewNew"
  },
  ServantCalendarView = {
    id = 1625,
    tab = 4,
    name = "活动日历",
    desc = "",
    prefab = "ServantCalendarView",
    class = "ServantCalendarView"
  },
  ServantActivityInfoView = {
    id = 1626,
    tab = nil,
    name = "日历活动详情",
    desc = "",
    prefab = "ServantActivityInfoView",
    class = "ServantActivityInfoView",
    hideCollider = false
  },
  ServantRaidStatView = {
    id = 1627,
    tab = nil,
    name = "执事周常统计",
    desc = "",
    prefab = "ServantRaidStatView",
    class = "ServantRaidStatView"
  },
  ServantBattlePassView = {
    id = 1628,
    tab = nil,
    name = "战令系统",
    desc = "",
    prefab = "ServantBattlePassView",
    class = "ServantBattlePassView"
  },
  EquipRecommendMainNew = {
    id = 1629,
    tab = 4,
    name = "装备推荐",
    desc = "",
    prefab = "EquipRecommendMainNew",
    class = "EquipRecommendMainNew"
  },
  GVGPortalView = {
    id = 1630,
    tab = nil,
    name = "GVG决战传送门",
    desc = "",
    prefab = "GVGPortalView",
    class = "GVGPortalView"
  },
  GVGResultView = {
    id = 1631,
    tab = nil,
    name = "GVG决战结果",
    desc = "",
    prefab = "GVGResultView",
    class = "GVGResultView"
  },
  GVGDetailView = {
    id = 1632,
    tab = nil,
    name = "GVG决战详细信息",
    desc = "",
    prefab = "GVGDetailView",
    class = "GVGDetailView"
  },
  LastGVGDetailView = {
    id = 1633,
    tab = nil,
    name = "上一期GVG决战详细信息",
    desc = "",
    prefab = "GVGDetailView",
    class = "LastGVGDetailView"
  },
  GVGStatView = {
    id = 1638,
    tab = nil,
    name = "GVG结算界面",
    desc = "",
    prefab = "Gvg/GVGStatView",
    class = "GVGStatView"
  },
  SaveKapraEnterView = {
    id = 1639,
    tab = nil,
    name = "卡普拉保卫战",
    desc = "",
    prefab = "MvpMatchView",
    class = "SaveKapraEnterView"
  },
  MVPResultView = {
    id = 1640,
    tab = nil,
    name = "MVP结算",
    desc = "",
    prefab = "MVPResultView",
    class = "MVPResultView"
  },
  MvpMatchView = {
    id = 1641,
    tab = nil,
    name = "MVP匹配",
    desc = "",
    prefab = "MvpMatchView",
    class = "MvpMatchView"
  },
  QuestManualView = {
    id = 1642,
    tab = nil,
    name = "任务手册",
    desc = "",
    prefab = "QuestManualView",
    class = "QuestManualView"
  },
  MainQuestPage = {
    id = 1643,
    tab = 1,
    name = "主线任务",
    desc = "",
    prefab = "MainQuestPage",
    class = "MainQuestPage"
  },
  BranchQuestPage = {
    id = 1644,
    tab = 2,
    name = "支线任务",
    desc = "",
    prefab = "BranchQuestPage",
    class = "BranchQuestPage"
  },
  PoemStoryPage = {
    id = 1645,
    tab = 3,
    name = "诗人故事",
    desc = "",
    prefab = "PoemStoryPage",
    class = "PoemStoryPage"
  },
  PlotVoicePage = {
    id = 1646,
    tab = 4,
    name = "异闻",
    desc = "",
    prefab = "PlotVoicePage",
    class = "PlotVoicePage"
  },
  MenuUnlockTracePage = {
    id = 1647,
    tab = 5,
    name = "功能引导",
    desc = "",
    prefab = "MenuUnlockTracePage",
    class = "MenuUnlockTracePage"
  },
  WebViewPanel = {
    id = 1650,
    name = "内置浏览器",
    desc = "",
    prefab = "WebViewPanel",
    class = "WebViewPanel"
  },
  StageView = {
    id = 1651,
    tab = 1,
    name = "换装舞台",
    desc = "",
    prefab = "StageView",
    class = "StageView",
    hideCollider = true
  },
  StageOutfit = {
    id = 1652,
    tab = 2,
    name = "造型",
    desc = "",
    prefab = "StageView",
    class = "StageView",
    hideCollider = true
  },
  StageStyleView = {
    id = 1653,
    tab = nil,
    name = "舞台",
    desc = "",
    prefab = "StageStyleView",
    class = "StageStyleView",
    hideCollider = false
  },
  JoinStagePopUp = {
    id = 1654,
    tab = nil,
    name = "进入舞台",
    desc = "",
    prefab = "JoinStagePopUp",
    class = "JoinStagePopUp",
    hideCollider = true
  },
  ExchangeShopView = {
    id = 1660,
    tab = nil,
    name = "追踪商店",
    desc = "",
    prefab = "ExchangeShopView",
    class = "ExchangeShopView"
  },
  TutorMatchView = {
    id = 1670,
    tab = nil,
    name = "导师匹配",
    desc = "",
    prefab = "TutorMatchView",
    class = "TutorMatchView",
    hideCollider = true
  },
  TutorMatchResultView = {
    id = 1671,
    tab = nil,
    name = "导师匹配结果",
    desc = "",
    prefab = "TutorMatchResultView",
    class = "TutorMatchResultView",
    hideCollider = true
  },
  BoothMainView = {
    id = 1680,
    tab = nil,
    name = "摆摊主",
    desc = "",
    prefab = "BoothMainView",
    class = "BoothMainView"
  },
  BoothExchangeView = {
    id = 1681,
    tab = 1,
    name = "摆摊交易",
    desc = "",
    prefab = "BoothMainView",
    class = "BoothExchangeView"
  },
  BoothRecordView = {
    id = 1682,
    tab = 2,
    name = "摆摊日志",
    desc = "",
    prefab = "BoothMainView",
    class = "BoothRecordView"
  },
  BoothNameView = {
    id = 1683,
    tab = nil,
    name = "摆摊名称",
    desc = "",
    prefab = "BoothNameView",
    class = "BoothNameView"
  },
  BoothSellInfoView = {
    id = 1684,
    tab = nil,
    name = "摆摊卖详情",
    desc = "",
    prefab = "BoothExchangeInfoView",
    class = "BoothSellInfoView"
  },
  BoothBuyInfoView = {
    id = 1685,
    tab = nil,
    name = "摆摊买详情",
    desc = "",
    prefab = "BoothExchangeInfoView",
    class = "BoothBuyInfoView"
  },
  TeamPwsReportPopUp = {
    id = 1690,
    tab = nil,
    name = "组队竞技赛战报",
    desc = "",
    prefab = "TeamPwsReportPopUp",
    class = "TeamPwsReportPopUp",
    hideCollider = true
  },
  TeamPwsFightResultPopUp = {
    id = 1691,
    tab = nil,
    name = "组队竞技赛结算",
    desc = "",
    prefab = "TeamPwsFightResultPopUp",
    class = "TeamPwsFightResultPopUp"
  },
  TeamPwsRankPopUp = {
    id = 1692,
    tab = nil,
    name = "组队竞技赛排名",
    desc = "",
    prefab = "TeamPwsRankPopUp",
    class = "TeamPwsRankPopUp"
  },
  MatchPreparePopUp = {
    id = 1693,
    tab = nil,
    name = "组队竞技赛准备",
    desc = "",
    prefab = "MatchPreparePopUp",
    class = "MatchPreparePopUp",
    hideCollider = true
  },
  TeamPwsMatchPopUp = {
    id = 1694,
    tab = nil,
    name = "组队竞技赛匹配状态",
    desc = "",
    prefab = "TeamPwsMatchPopUp",
    class = "TeamPwsMatchPopUp",
    hideCollider = true
  },
  TeamPwsRewardPopUp = {
    id = 1695,
    tab = nil,
    name = "组队竞技赛奖励",
    desc = "",
    prefab = "TeamPwsRewardPopUp",
    class = "TeamPwsRewardPopUp",
    hideCollider = true
  },
  OthelloResultPopUp = {
    id = 1696,
    tab = nil,
    name = "黑白棋结算",
    desc = "",
    prefab = "TeamPwsFightResultPopUp",
    class = "OthelloResultPopUp"
  },
  OthelloReportPopUp = {
    id = 1697,
    tab = nil,
    name = "黑白棋战报",
    desc = "",
    prefab = "TeamPwsReportPopUp",
    class = "OthelloReportPopUp"
  },
  TripleTeamsResultPopUp = {
    id = 1698,
    tab = nil,
    name = "3v3v3战报",
    desc = "",
    prefab = "TripleTeamsResultPopUp",
    class = "TripleTeamsResultPopUp"
  },
  TripleTeamsDetailPopUp = {
    id = 1699,
    tab = nil,
    name = "3v3v3详情",
    desc = "",
    prefab = "TripleTeamsDetailPopUp",
    class = "TripleTeamsDetailPopUp"
  },
  TripleTeamRankPopUp = {
    id = 16991,
    tab = nil,
    name = "3v3v3赛季排名",
    desc = "",
    prefab = "TripleTeamRankPopUp",
    class = "TripleTeamRankPopUp"
  },
  TripleTeamPwsRewardPopUp = {
    id = 16992,
    tab = nil,
    name = "3v3v3赛季奖励",
    desc = "",
    prefab = "TripleTeamPwsRewardPopUp",
    class = "TripleTeamPwsRewardPopUp"
  },
  TripleTeamsPwsResultPopUp = {
    id = 16993,
    tab = nil,
    name = "3v3v3竞技战报",
    desc = "",
    prefab = "TripleTeamsPwsResultPopUp",
    class = "TripleTeamsPwsResultPopUp"
  },
  PetView = {
    id = 1700,
    tab = nil,
    name = "宠物",
    desc = "",
    prefab = "PetView",
    class = "PetView"
  },
  PetAdventureView = {
    id = 1701,
    tab = 1,
    name = "宠物冒险界面",
    desc = "",
    prefab = "PetAdventureView",
    class = "PetAdventureView"
  },
  PetComposeView = {
    id = 1702,
    tab = 2,
    name = "宠物融合",
    desc = "",
    prefab = "PetComposeView",
    class = "PetComposeView"
  },
  PetWorkSpaceView = {
    id = 1703,
    tab = 3,
    name = "宠物打工",
    desc = "",
    prefab = "PetWorkSpaceView",
    class = "PetWorkSpaceView"
  },
  PetComposePreviewPopUp = {
    id = 1704,
    tab = nil,
    name = "宠物融合预览",
    desc = "",
    prefab = "PetComposePreviewPopUp",
    class = "PetComposePreviewPopUp"
  },
  PetComposePopUp = {
    id = 1705,
    tab = nil,
    name = "宠物融合",
    desc = "",
    prefab = "PetComposePopUp",
    class = "PetComposePopUp"
  },
  EquipComposeView = {
    id = 1710,
    tab = nil,
    name = "装备合成",
    desc = "",
    prefab = "EquipComposeView",
    class = "EquipComposeView"
  },
  EquipQuenchView = {
    id = 1711,
    tab = nil,
    name = "装备淬炼",
    desc = "",
    prefab = "EquipQuenchView",
    class = "EquipQuenchView"
  },
  HotKeyInfoSetView = {
    id = 1720,
    tab = nil,
    name = "选项",
    prefab = "HotKeyInfoSetView",
    class = "HotKeyInfoSetView",
    hideCollider = true
  },
  HotKeyInfoView = {
    id = 1721,
    tab = nil,
    name = "快捷键界面",
    prefab = "HotKeyInfoView",
    class = "HotKeyInfoView"
  },
  ColliderView = {
    id = 1730,
    tab = nil,
    name = "通用挡板",
    prefab = "ColliderView",
    class = "ColliderView",
    hideCollider = true
  },
  MoroccTimePopUp = {
    id = 1731,
    tab = nil,
    name = "梦罗克裂隙提示界面",
    prefab = "MoroccTimePopUp",
    class = "MoroccTimePopUp",
    hideCollider = true
  },
  GemContainerView = {
    id = 1732,
    tab = nil,
    name = "符文界面",
    desc = "",
    prefab = "GemContainerView",
    class = "GemContainerView"
  },
  GemResultView = {
    id = 1733,
    name = "符文操作结果",
    desc = "",
    prefab = "BaseItemResultView",
    class = "GemResultView",
    hideCollider = true
  },
  GemComposeView = {
    id = 1734,
    name = "符文融合",
    desc = "",
    prefab = "GemComposeView",
    class = "GemComposeView"
  },
  GemAskForArrangeRangePopUp = {
    id = 1735,
    name = "符文合成等级选择",
    desc = "",
    prefab = "GemAskForArrangeRangePopUp",
    class = "GemAskForArrangeRangePopUp"
  },
  GemEmbedPreview = {
    id = 1736,
    name = "符文镶嵌预览界面",
    desc = "",
    prefab = "GemContainerView",
    class = "GemEmbedPreview"
  },
  GemSculptView = {
    id = 1737,
    name = "符文雕刻界面",
    desc = "",
    prefab = "GemSculptView",
    class = "GemSculptView"
  },
  GemSmeltView = {
    id = 1738,
    name = "符文熔炼界面",
    desc = "",
    prefab = "GemSmeltView",
    class = "GemSmeltView"
  },
  GemShopView = {
    id = 1739,
    name = "日服符文礼包界面",
    desc = "",
    prefab = "HappyShop",
    class = "GemShopView"
  },
  PersonalArtifactComposeView = {
    id = 1740,
    name = "个人神器组合",
    desc = "",
    prefab = "PersonalArtifactComposeView",
    class = "PersonalArtifactComposeView"
  },
  PersonalArtifactRefreshView = {
    id = 1741,
    name = "个人神器重塑",
    desc = "",
    prefab = "PersonalArtifactRefreshView",
    class = "PersonalArtifactRefreshView"
  },
  PersonalArtifactDecomposeView = {
    id = 1742,
    name = "个人神器分解",
    desc = "",
    prefab = "DeComposeView",
    class = "PersonalArtifactDecomposeView"
  },
  PersonalArtifactExchangeView = {
    id = 1743,
    name = "个人神器置换",
    desc = "",
    prefab = "PersonalArtifactExchangeView",
    class = "PersonalArtifactExchangeView"
  },
  PersonalArtifactResultView = {
    id = 1744,
    name = "个人神器鉴定结果",
    desc = "",
    prefab = "BaseItemResultView",
    class = "PersonalArtifactResultView",
    hideCollider = true
  },
  PersonalArtifactFunctionView = {
    id = 1745,
    name = "个人神器综合界面",
    desc = "",
    prefab = "PersonalArtifactFunctionView",
    class = "PersonalArtifactFunctionView"
  },
  HitBoliView = {
    id = 1750,
    tab = nil,
    name = "天天打波利",
    desc = "",
    prefab = "HitBoli",
    class = "HitBoliView"
  },
  TicketPreview = {
    id = 1751,
    name = "兑换券预览界面",
    desc = "",
    prefab = "TicketPreview",
    class = "TicketPreview",
    hideCollider = true
  },
  ExpRaidMapView = {
    id = 1761,
    tab = nil,
    name = "经验副本地图",
    prefab = "ExpRaidMapView",
    class = "ExpRaidMapView"
  },
  ExpRaidDetailView = {
    id = 1762,
    tab = nil,
    name = "经验副本详情",
    prefab = "ExpRaidDetailView",
    class = "ExpRaidDetailView"
  },
  ExpRaidResultView = {
    id = 1763,
    tab = nil,
    name = "经验副本结算",
    prefab = "DojoResultPopUp",
    class = "ExpRaidResultView"
  },
  ExpRaidShopView = {
    id = 1764,
    tab = nil,
    name = "经验副本商店",
    prefab = "HappyShop",
    class = "ExpRaidShopView"
  },
  ExpRaidPrestigeShopView = {
    id = 1765,
    tab = nil,
    name = "经验副本声望商店",
    prefab = "PrestigeShopView",
    class = "ExpRaidPrestigeShopView"
  },
  ExpRaidQuickFinishChooseView = {
    id = 1766,
    tab = nil,
    name = "经验副本快速完成",
    prefab = "ExpRaidQuickFinishChooseView",
    class = "ExpRaidQuickFinishChooseView"
  },
  RecommendRewardView = {
    id = 1767,
    tab = nil,
    name = "推荐礼盒奖励",
    prefab = "RecommendRewardView",
    class = "RecommendRewardView"
  },
  OptionalGiftRewardView = {
    id = 1769,
    tab = nil,
    name = "自选礼盒奖励",
    prefab = "OptionalGiftRewardView",
    class = "OptionalGiftRewardView"
  },
  SingleGiftRewardView = {
    id = 1768,
    tab = nil,
    name = "单选礼盒奖励",
    prefab = "SingleGiftRewardView",
    class = "SingleGiftRewardView"
  },
  NewServerSignInMapView = {
    id = 1770,
    tab = nil,
    name = "新服签到界面",
    desc = "",
    prefab = "NewServerSignInMapView",
    class = "NewServerSignInMapView"
  },
  SignInRewardPreview = {
    id = 1771,
    tab = nil,
    name = "新服签到奖励预览",
    desc = "",
    prefab = "SignInRewardPreview",
    class = "SignInRewardPreview",
    hideCollider = true
  },
  SignInTipsView = {
    id = 1772,
    tab = nil,
    name = "新服签到小提示",
    desc = "",
    prefab = "SignInTipsView",
    class = "SignInTipsView"
  },
  SignInQAView = {
    id = 1773,
    tab = nil,
    name = "新服签到奖励问答",
    desc = "",
    prefab = "SignInQAView",
    class = "SignInQAView",
    hideCollider = true
  },
  SignInCatEncounterView = {
    id = 1774,
    tab = nil,
    name = "新服签到B格猫动画",
    desc = "",
    prefab = "SignInCatEncounterView",
    class = "SignInCatEncounterView"
  },
  SignInRewardGetView = {
    id = 1775,
    tab = nil,
    name = "新服签到成功提示",
    desc = "",
    prefab = "SignInRewardGetView",
    class = "SignInRewardGetView",
    hideCollider = true
  },
  ActivitySignInMapView = {
    id = 1776,
    tab = nil,
    name = "活动签到界面",
    desc = "",
    prefab = "NewServerSignInMapView",
    class = "ActivitySignInMapView"
  },
  CourageRankPopUp = {
    id = 1780,
    tab = nil,
    name = "勇气排行界面",
    prefab = "CourageRankPopUp",
    class = "CourageRankPopUp"
  },
  MapTransmitterView = {
    id = 1790,
    tab = nil,
    name = "传送器地图选择界面",
    desc = "",
    prefab = "MapTransmitterView",
    class = "MapTransmitterView"
  },
  MapTransmitterAreaView = {
    id = 1791,
    tab = nil,
    name = "传送器地点选择界面",
    desc = "",
    prefab = "MapTransmitterAreaView",
    class = "MapTransmitterAreaView"
  },
  ChangeCatPopUp = {
    id = 1800,
    tab = nil,
    name = "更换佣兵猫",
    desc = "",
    prefab = "ChangeCatPopUp",
    class = "ChangeCatPopUp"
  },
  BossCardComposeView = {
    id = 1800,
    tab = nil,
    name = "Boss卡合成",
    desc = "",
    prefab = "BossCardComposeView",
    class = "BossCardComposeView"
  },
  ActivityDungeonView = {
    id = 1810,
    tab = nil,
    name = "活动副本",
    desc = "",
    prefab = "ActivityDungeonView",
    class = "ActivityDungeonView"
  },
  ActivityDungeonInfo = {
    id = 1811,
    tab = 1,
    name = "活动副本介绍",
    desc = "",
    prefab = "ActivityDungeonInfo",
    class = "ActivityDungeonInfo"
  },
  ActivityDungeonRate = {
    id = 1812,
    tab = 2,
    name = "活动副本评级",
    desc = "",
    prefab = "ActivityDungeonRate",
    class = "ActivityDungeonRate"
  },
  RatingRewardPreview = {
    id = 1813,
    tab = nil,
    name = "评级奖励预览",
    desc = "",
    prefab = "RatingRewardPreview",
    class = "RatingRewardPreview"
  },
  WorldMapMenuPopUp = {
    id = 1830,
    tab = nil,
    name = "世界地图详情界面",
    desc = "",
    prefab = "WorldMapMenuPopUp",
    class = "WorldMapMenuPopUp",
    hideCollider = true
  },
  GuildDateBattleEntranceView = {
    id = 1831,
    tab = nil,
    name = "公会约战比赛开始入口界面",
    desc = "",
    prefab = "GuildDateBattleEntranceView",
    class = "GuildDateBattleEntranceView"
  },
  GuildDateBattlefieldReport = {
    id = 1832,
    tab = nil,
    name = "约战战报界面",
    desc = "",
    prefab = "GuildDateBattlefieldReport",
    class = "GuildDateBattlefieldReport"
  },
  GuildDateBattleOverview = {
    id = 1833,
    tab = nil,
    name = "约战总览界面",
    desc = "",
    prefab = "GuildDateBattleOverview",
    class = "GuildDateBattleOverview"
  },
  GuildDateBattle_Overview_Result = {
    id = 1834,
    tab = 1,
    name = "约战总览(约战结果)",
    desc = "",
    prefab = "GuildDateBattleOverview",
    class = "GuildDateBattle_Overview_Result"
  },
  GuildDateBattle_Overview_Going = {
    id = 1835,
    tab = 2,
    name = "约战总览(即将开赛、正在进行)",
    desc = "",
    prefab = "GuildDateBattleOverview",
    class = "GuildDateBattle_Overview_Going"
  },
  GuildDateBattle_Overview_Rank = {
    id = 1836,
    tab = 3,
    name = "约战总览界面(30天内胜利次数排行榜)",
    desc = "",
    prefab = "GuildDateBattleOverview",
    class = "GuildDateBattle_Overview_Rank"
  },
  GuildDateBattleInviteView = {
    id = 1837,
    tab = nil,
    name = "约战邀请界面",
    desc = "",
    prefab = "GuildDateBattleInviteView",
    class = "GuildDateBattleInviteView"
  },
  GuildDateBattleRecordView = {
    id = 1838,
    tab = nil,
    name = "本公会约战记录界面",
    desc = "",
    prefab = "GuildDateBattleRecordView",
    class = "GuildDateBattleRecordView"
  },
  GuildDateBattlePreEnterView = {
    id = 1839,
    tab = nil,
    name = "公会约战准备阶段预览界面",
    desc = "",
    prefab = "GuildDateBattlePreEnterView",
    class = "GuildDateBattlePreEnterView"
  },
  HomeBuildingView = {
    id = 1840,
    tab = nil,
    name = "家园建造界面",
    desc = "",
    prefab = "HomeBuildingView",
    class = "HomeBuildingView"
  },
  FurnitureDialogView = {
    id = 1841,
    tab = nil,
    name = "家具对话界面",
    desc = "",
    prefab = "FurnitureDialogView",
    class = "FurnitureDialogView",
    hideCollider = true
  },
  HomeMainView = {
    id = 1842,
    tab = nil,
    name = "家园主界面",
    desc = "",
    prefab = "HomeMainView",
    class = "HomeMainView"
  },
  HomeInfoPage = {
    id = 1843,
    tab = 1,
    name = "家园信息页",
    desc = "",
    prefab = "HomeInfoPage",
    class = "HomeInfoPage",
    hideCollider = true
  },
  HomeScorePage = {
    id = 1844,
    tab = 2,
    name = "家具评分页",
    desc = "",
    prefab = "HomeScorePage",
    class = "HomeScorePage",
    hideCollider = true
  },
  HomeSettingPage = {
    id = 1845,
    tab = 3,
    name = "家园设置页",
    desc = "",
    prefab = "HomeSettingPage",
    class = "HomeSettingPage",
    hideCollider = true
  },
  HomeScoreLvPopUp = {
    id = 1846,
    tab = nil,
    name = "评分属性收益",
    desc = "",
    prefab = "HomeScoreLvPopUp",
    class = "HomeScoreLvPopUp"
  },
  HomeBluePrintView = {
    id = 1847,
    tab = nil,
    name = "蓝图选择界面",
    desc = "",
    prefab = "HomeBluePrintView",
    class = "HomeBluePrintView"
  },
  HomeBPDetailView = {
    id = 1848,
    tab = nil,
    name = "蓝图详情界面",
    desc = "",
    prefab = "HomeBPDetailView",
    class = "HomeBPDetailView"
  },
  HomeMakeView = {
    id = 1849,
    tab = nil,
    name = "家具合成界面",
    desc = "",
    prefab = "HomeMakeView",
    class = "HomeMakeView",
    hideCollider = true
  },
  HomeAtmosphereSelectView = {
    id = 1850,
    tab = nil,
    name = "氛围选择页面",
    desc = "",
    prefab = "HomeAtmosphereSelectView",
    class = "HomeAtmosphereSelectView",
    hideCollider = true
  },
  HomeWorkbenchView = {
    id = 1851,
    tab = nil,
    name = "家园工作台",
    desc = "",
    prefab = "CommonCombineView",
    class = "HomeWorkbenchView",
    hideCollider = true
  },
  HomeTelevisionView = {
    id = 1852,
    tab = nil,
    name = "家园电视",
    desc = "",
    prefab = "HomeTelevisionView",
    class = "HomeTelevisionView"
  },
  HomeTipPopUp = {
    id = 1853,
    tab = nil,
    name = "家具合成界面",
    desc = "",
    prefab = "HomeTipPopUp",
    class = "HomeTipPopUp"
  },
  EquipIntegrateView = {
    id = 1854,
    tab = nil,
    name = "装备提升整合",
    desc = "",
    prefab = "EquipIntegrateView",
    class = "EquipIntegrateView",
    hideCollider = true
  },
  PrestigeShopView = {
    id = 1860,
    tab = nil,
    name = "声望商店",
    desc = "",
    prefab = "PrestigeShopView",
    class = "PrestigeShopView"
  },
  RoguelikeDungeonView = {
    id = 1870,
    name = "进入秘境副本",
    desc = "",
    prefab = "RoguelikeDungeonView",
    class = "RoguelikeDungeonView"
  },
  RoguelikeRankPopUp = {
    id = 1871,
    name = "秘境排行",
    desc = "",
    prefab = "RoguelikeRankPopUp",
    class = "RoguelikeRankPopUp",
    hideCollider = true
  },
  RoguelikeShopView = {
    id = 1872,
    name = "秘境商店",
    desc = "",
    prefab = "HappyShop",
    class = "RoguelikeShopView"
  },
  RoguelikeStatisticsView = {
    id = 1873,
    name = "秘境战斗统计",
    desc = "",
    prefab = "RaidStatistics",
    class = "RoguelikeStatisticsView",
    hideCollider = true
  },
  RoguelikeResultView = {
    id = 1874,
    name = "秘境结算",
    desc = "",
    prefab = "RoguelikeResultView",
    class = "RoguelikeResultView"
  },
  RoguelikeTarotView = {
    id = 1875,
    name = "秘境塔罗牌",
    desc = "",
    prefab = "RoguelikeTarotView",
    class = "RoguelikeTarotView",
    hideCollider = true
  },
  TechTreeContainerView = {
    id = 1880,
    name = "科技树界面",
    desc = "",
    prefab = "TechTreeContainerView",
    class = "TechTreeContainerView"
  },
  NewbieTechTreeContainerView = {
    id = 1881,
    name = "新手科技树界面",
    desc = "",
    prefab = "NewbieTechTreeContainerView",
    class = "NewbieTechTreeContainerView"
  },
  TechTreeGuidePopUp = {
    id = 1886,
    name = "心始之源引导界面",
    desc = "",
    prefab = "TechTreeGuidePopUp",
    class = "TechTreeGuidePopUp",
    hideCollider = true
  },
  CharacterEncounterView = {
    id = 1890,
    name = "联动角色开屏",
    desc = "",
    prefab = "CharacterEncounterView",
    class = "CharacterEncounterView"
  },
  RaidStatisticsView = {
    id = 1900,
    tab = nil,
    name = "团本信息",
    desc = "",
    prefab = "RaidStatistics",
    class = "RaidStatisticsView",
    hideCollider = true
  },
  GroupOnMarkView = {
    id = 1911,
    tab = nil,
    name = "就位确认",
    desc = "",
    prefab = "GroupOnMarkView",
    class = "GroupOnMarkView",
    hideCollider = true
  },
  CalendarView = {
    id = 1920,
    tab = nil,
    name = "CalendarView",
    desc = "",
    prefab = "CalendarView",
    class = "CalendarView"
  },
  MountLotteryView = {
    id = 1930,
    tab = nil,
    name = "坐骑扭蛋",
    desc = "",
    prefab = "MountLotteryView",
    class = "MountLotteryView"
  },
  PetHouseView = {
    id = 1940,
    tab = nil,
    name = "PetHouseView",
    desc = "",
    prefab = "PetHouseView",
    class = "PetHouseView"
  },
  AstrologyView = {
    id = 1950,
    tab = nil,
    name = "AstrologyView",
    desc = "",
    prefab = "AstrologyView",
    class = "AstrologyView"
  },
  AstrolotyResultView = {
    id = 1951,
    tab = nil,
    name = "AstrolotyResultView",
    desc = "",
    prefab = "AstrolotyResultView",
    class = "AstrologyResultView"
  },
  ActivityPuzzleView = {
    id = 1960,
    tab = nil,
    name = "ActivityPuzzleView",
    desc = "",
    prefab = "ActivityPuzzleView",
    class = "ActivityPuzzleView"
  },
  ThanatosMonumentView = {
    id = 1970,
    tab = nil,
    name = "ThanatosMonumentView",
    desc = "",
    prefab = "ThanatosMonumentView",
    class = "ThanatosMonumentView"
  },
  ThanatosGuildRankView = {
    id = 1980,
    tab = nil,
    name = "ThanatosGuildRankView",
    desc = "",
    prefab = "ThanatosGuildRankView",
    class = "ThanatosGuildRankView"
  },
  HomePersonalPicturePanel = {
    id = 1990,
    tab = nil,
    name = "家园相册",
    desc = "",
    prefab = "HomePersonalPicturePanel",
    class = "HomePersonalPicturePanel"
  },
  HomeLetterPanel = {
    id = 2000,
    tab = nil,
    name = "家园信",
    desc = "",
    prefab = "LetterContainerView",
    class = "HomeLetterPanel"
  },
  BlackSmithCertiify = {
    id = 2001,
    tab = nil,
    name = "铁匠铺营业准许信",
    desc = "",
    prefab = "LetterContainerView",
    class = "BlackSmithCertiify"
  },
  FurnitureShopView = {
    id = 2010,
    tab = nil,
    name = "家园便捷商店",
    desc = "",
    prefab = "FurnitureShopView",
    class = "FurnitureShopView"
  },
  HouseChooseView = {
    id = 2020,
    tab = nil,
    name = "花园房型选择",
    desc = "",
    prefab = "HouseChooseView",
    class = "HouseChooseView"
  },
  TutorRewardBoxPopUp = {
    id = 2020,
    tab = nil,
    name = "导师奖励箱",
    desc = "",
    prefab = "TutorRewardBoxPopUp",
    class = "TutorRewardBoxPopUp"
  },
  ChangeIconPopup = {
    id = 2021,
    tab = nil,
    name = "更换APP图标",
    desc = "",
    prefab = "ChangeIconPopup",
    class = "ChangeIconPopup"
  },
  MiniGameEntranceView = {
    id = 2030,
    tab = nil,
    name = "小游戏入口",
    desc = "",
    prefab = "MiniGameEntranceView",
    class = "MiniGameEntranceView"
  },
  CardsMatchView = {
    id = 2031,
    tab = nil,
    name = "卡牌配对",
    desc = "",
    prefab = "CardsMatchView",
    class = "CardsMatchView"
  },
  MiniGameMonsterQAPage = {
    id = 2032,
    tab = nil,
    name = "魔物问答",
    desc = "",
    prefab = "MiniGameMonsterQAPage",
    class = "MiniGameMonsterQAPage"
  },
  MiniGameMonsterShotPage = {
    id = 2033,
    tab = nil,
    name = "魔物拍摄",
    desc = "",
    prefab = "MiniGameMonsterShotPage",
    class = "MiniGameMonsterShotPage"
  },
  MiniGameRankPopUp = {
    id = 2034,
    tab = nil,
    name = "小游戏排行榜",
    desc = "",
    prefab = "MiniGameRankPopUp",
    class = "MiniGameRankPopUp"
  },
  AppStoreCodeRewardPopup = {
    id = 2040,
    tab = nil,
    name = "AppStore兑换码领取",
    desc = "",
    prefab = "AppStoreCodeRewardPopup",
    class = "AppStoreCodeRewardPopup"
  },
  SkadaRecordView = {
    id = 2050,
    tab = nil,
    name = "家园木桩伤害统计",
    desc = "",
    prefab = "SkadaRecordView",
    class = "SkadaRecordView"
  },
  GuildFubenGateView = {
    id = 2050,
    tab = nil,
    name = "公会瓦尔哈拉遗迹",
    desc = "",
    prefab = "GuildFubenGateView",
    class = "GuildFubenGateView"
  },
  SkadaAnalysisPopup = {
    id = 2051,
    tab = nil,
    name = "家园木桩伤害分析",
    desc = "",
    prefab = "SkadaAnalysisPopup",
    class = "SkadaAnalysisPopup"
  },
  SkadaSettingView = {
    id = 2052,
    tab = nil,
    name = "家园木桩设置",
    desc = "",
    prefab = "SkadaSettingView",
    class = "SkadaSettingView"
  },
  SkadaRankingPopup = {
    id = 2053,
    tab = nil,
    name = "家园木桩全服排行",
    desc = "",
    prefab = "SkadaRankingPopup",
    class = "SkadaRankingPopup"
  },
  QuestMiniGame1Panel = {
    id = 2060,
    tab = nil,
    name = "任务小游戏1-qte",
    desc = "",
    prefab = "QuestMiniGame1Panel",
    class = "QuestMiniGame1Panel"
  },
  QuestMiniGame2Panel = {
    id = 2061,
    tab = nil,
    name = "任务小游戏2-钓鱼",
    desc = "",
    prefab = "QuestMiniGame2Panel",
    class = "QuestMiniGame2Panel"
  },
  QuestMiniGame3Panel = {
    id = 2062,
    tab = nil,
    name = "任务小游戏3-杀怪",
    desc = "",
    prefab = "QuestMiniGame3Panel",
    class = "QuestMiniGame3Panel"
  },
  QuestMiniGame1DebugPanel = {
    id = 2069,
    tab = nil,
    name = "任务小游戏1-qteDEBUG",
    desc = "",
    prefab = "QuestMiniGame1Panel",
    class = "QuestMiniGame1DebugPanel"
  },
  ChooseProfessionBranchPopup = {
    id = 2069,
    tab = nil,
    name = "选择职业分支",
    desc = "",
    prefab = "ChooseBranchPopup",
    class = "ChooseProfessionBranchPopup"
  },
  TeleportToyPopUp = {
    id = 2070,
    tab = nil,
    name = "传送器玩具界面",
    desc = "",
    prefab = "TeleportToyPopUp",
    class = "TeleportToyPopUp"
  },
  LoveChallengeView = {
    id = 2071,
    name = "爱情挑战",
    desc = "",
    prefab = "LoveChallengeView",
    class = "LoveChallengeView"
  },
  BFBuildingPanel = {
    id = 2080,
    tab = nil,
    name = "建筑界面",
    desc = "",
    prefab = "BFBuildingPanel",
    class = "BFBuildingPanel"
  },
  BFSecretHistoryPopup = {
    id = 2081,
    tab = nil,
    name = "小道消息弹出",
    desc = "",
    prefab = "BFSecretHistoryPopup",
    class = "BFSecretHistoryPopup"
  },
  MidSummerActView = {
    id = 2090,
    name = "仲夏之邀",
    desc = "",
    prefab = "MidSummerActView",
    class = "MidSummerActView"
  },
  CrowdfundingActView = {
    id = 2091,
    name = "全服众筹",
    desc = "",
    prefab = "CrowdfundingActView",
    class = "CrowdfundingActView"
  },
  NPCHeadMsgInputView = {
    id = 2100,
    tab = nil,
    name = "NPCHeadMsgInputView",
    desc = "",
    prefab = "NPCHeadMsgInputView",
    class = "NPCHeadMsgInputView"
  },
  QuestionnaireView = {
    id = 2110,
    name = "职业问卷调查",
    desc = "",
    prefab = "QuestionnaireView",
    class = "QuestionnaireView"
  },
  RaidSelectCardView = {
    id = 2111,
    name = "副本选卡界面",
    desc = "",
    prefab = "RaidSelectCardView",
    class = "RaidSelectCardView"
  },
  SevenRoyalLetterView = {
    id = 2114,
    name = "七王室邀请函",
    desc = "",
    prefab = "LetterContainerView",
    class = "SevenRoyalLetterView"
  },
  TransferProfPreview = {
    id = 2120,
    name = "学院转职UI",
    desc = "",
    prefab = "TransferProfPreview",
    class = "TransferProfPreview"
  },
  SignIn21View = {
    id = 2130,
    name = "21天签到",
    desc = "",
    prefab = "SignIn21View",
    class = "SignIn21View"
  },
  VideoPreview = {
    id = 2140,
    name = "视频预览",
    desc = "",
    prefab = "VideoPreview",
    class = "VideoPreview"
  },
  SevenRoyalFamilyTreeView = {
    id = 2150,
    name = "七王室族谱",
    desc = "",
    prefab = "SevenRoyalFamilyTreeView",
    class = "SevenRoyalFamilyTreeView"
  },
  MaximumSkillGemView = {
    id = 2200,
    name = "技能符文满级界面",
    desc = "",
    prefab = "MaximumSkillGemView",
    class = "MaximumSkillGemView"
  },
  HeadWearRaidShop = {
    id = 2250,
    tab = nil,
    name = "头饰副本商店",
    prefab = "HeadwearRaidShop",
    class = "HeadwearRaidShop"
  },
  HeadwearRaidMonsterInfoView = {
    id = 2252,
    tab = nil,
    name = "头饰副本内怪物详情界面",
    prefab = "HeadwearRaidMonsterInfoView",
    class = "HeadwearRaidMonsterInfoView"
  },
  HeadwearRaidTowerUpgradeView = {
    id = 2253,
    tab = nil,
    name = "头饰副本内防御塔详情界面",
    prefab = "HeadwearRaidTowerUpgradeView",
    class = "HeadwearRaidTowerUpgradeView"
  },
  HeadwearRaidResultView = {
    id = 2254,
    tab = nil,
    name = "头饰副本内结算界面",
    prefab = "HeadwearRaidResultPopUp",
    class = "HeadwearRaidResultView"
  },
  HeadWearActivityRaidEnterView = {
    id = 2255,
    tab = nil,
    name = "活动头饰副本入场",
    prefab = "HeadWearActivityRaidEnterView",
    class = "HeadWearActivityRaidEnterView"
  },
  MagicBoxPanel = {
    id = 2301,
    tab = nil,
    name = "属性萃取主界面",
    desc = "",
    prefab = "MagicBoxPanel",
    class = "MagicBoxPanel"
  },
  MagicBoxExtractionPage = {
    id = 2302,
    tab = 1,
    name = "属性萃取页",
    desc = "",
    prefab = "Extraction/MagicBoxExtractionNewPage",
    class = "MagicBoxExtractionNewPage"
  },
  MagicBoxIllustrationPage = {
    id = 2303,
    tab = 2,
    name = "属性萃取图鉴",
    desc = "",
    prefab = "MagicBoxIllustrationPage",
    class = "MagicBoxIllustrationPage"
  },
  ExtractionSlotPopUp = {
    id = 2304,
    tab = nil,
    name = "购买萃取档位",
    desc = "",
    prefab = "PurchaseSaveSlotPopUp",
    class = "ExtractionSlotPopUp"
  },
  MagicBoxExtractionPreviewPage = {
    id = 2305,
    tab = 1,
    name = "属性萃取预览页",
    desc = "",
    prefab = "MagicBoxExtractionPage",
    class = "MagicBoxExtractionPreviewPage"
  },
  TransferFightRankPopUp = {
    id = 2400,
    tab = nil,
    name = "魔物乱斗结算",
    desc = "",
    prefab = "TransferFightRankPopUp",
    class = "TransferFightRankPopUp"
  },
  TransferFightMonsterChooseView = {
    id = 2404,
    tab = nil,
    name = "怪物选择界面",
    desc = "",
    prefab = "TransferFightMonsterChooseView",
    class = "TransferFightMonsterChooseView"
  },
  ActivityHitPollyView = {
    id = 2410,
    tab = nil,
    name = "活动打波利",
    desc = "",
    prefab = "ActivityHitPollyView",
    class = "ActivityHitPollyView"
  },
  PeddlerShop = {
    id = 2500,
    tab = nil,
    name = "流浪商人",
    prefab = "NewPeddlerShop",
    class = "NewPeddlerShop"
  },
  SupplyDepotView = {
    id = 2550,
    tab = nil,
    name = "初心者补给站",
    prefab = "SupplyDepotView",
    class = "SupplyDepotView"
  },
  GunShootPanel = {
    id = 2600,
    tab = nil,
    name = "魔物射击",
    prefab = "GunShootPanel",
    class = "GunShootPanel"
  },
  GunShootBirdPanel = {
    id = 2601,
    tab = nil,
    name = "qws魔物射击",
    prefab = "GunShootBirdPanel",
    class = "GunShootPanel"
  },
  GunShootLocalPanel = {
    id = 2602,
    tab = nil,
    name = "魔物射击本地",
    prefab = "GunShootLocalPanel",
    class = "GunShootLocalPanel"
  },
  PickingReorderPanel = {
    id = 2603,
    tab = nil,
    name = "选择物件排序",
    prefab = "PickingReorderPanel",
    class = "PickingReorderPanel"
  },
  PaySignEntryView = {
    id = 2700,
    tab = nil,
    name = "付费签到购买入口",
    prefab = "PaySignEntryView",
    class = "PaySignEntryView"
  },
  PaySignRewardView = {
    id = 2701,
    tab = nil,
    name = "付费签到奖励",
    prefab = "PaySignRewardView",
    class = "PaySignRewardView"
  },
  EnterPaySignRewardView = {
    id = 2702,
    tab = nil,
    name = "进入付费签到奖励动画",
    prefab = "EnterPaySignRewardView",
    class = "EnterPaySignRewardView"
  },
  TwelvePVPShopView = {
    id = 2810,
    tab = nil,
    name = "12pvp水晶商店",
    desc = "",
    prefab = "TwelvePVPShopView",
    class = "TwelvePVPShopView"
  },
  TwelvePVP_PersonalInfoPopUp = {
    id = 2811,
    tab = nil,
    name = "12pvp详细信息(优化、预设沿用老的)",
    desc = "",
    prefab = "TwelvePVPDetailView",
    class = "TwelvePVP_PersonalInfoPopUp"
  },
  TwelvePVPWeeklyTaskPopUp = {
    id = 2812,
    tab = nil,
    name = "12pvp周常奖励",
    desc = "",
    prefab = "TwelvePVPWeeklyTask",
    class = "TwelvePVPWeeklyTaskPopUp"
  },
  TwelvePVPResultPanel = {
    id = 2813,
    tab = nil,
    name = "12pvp优胜信息",
    desc = "",
    prefab = "TwelvePVPResultPanel",
    class = "TwelvePVPResultPanel"
  },
  HarpView = {
    id = 2820,
    tab = nil,
    name = "竖琴界面",
    desc = "",
    prefab = "HarpView",
    class = "HarpView"
  },
  MusicGamePanel = {
    id = 2821,
    tab = nil,
    name = "音乐演奏",
    desc = "",
    prefab = "MusicGamePanel",
    class = "MusicGamePanel"
  },
  OldPlayerPanel = {
    id = 2830,
    tab = nil,
    name = "老玩家邀请回归",
    desc = "",
    prefab = "OldPlayerPanel",
    class = "OldPlayerPanel"
  },
  InviteCodePopView = {
    id = 2831,
    tab = nil,
    name = "老玩家回归邀请码",
    desc = "",
    prefab = "InviteCodePopView",
    class = "InviteCodePopView"
  },
  OldPlayerShareView = {
    id = 2832,
    tab = nil,
    name = "老玩家邀请回归分享",
    desc = "",
    prefab = "OldPlayerShareView",
    class = "OldPlayerShareView"
  },
  ReturnRewardView = {
    id = 2835,
    tab = nil,
    name = "老玩家回归奖励领取",
    desc = "",
    prefab = "ReturnRewardView",
    class = "ReturnRewardView"
  },
  ReturnActivityDepositPage = {
    id = 2844,
    tab = 3,
    name = "老玩家回归界面-特惠",
    desc = "",
    prefab = "ReturnActivityShopPage",
    class = "ReturnActivityDepositPage"
  },
  OldPlayerOverSeaPanel = {
    id = 2833,
    tab = nil,
    name = "老玩家邀请回归海外",
    desc = "",
    prefab = "OldPlayerOverSeaPanel",
    class = "OldPlayerOverSeaPanel"
  },
  OldPlayerShareOverSeaView = {
    id = 2834,
    tab = nil,
    name = "老玩家邀请回归分享海外",
    desc = "",
    prefab = "OldPlayerShareView",
    class = "OldPlayerShareOverSeaView"
  },
  InviteCodePopOverSeaView = {
    id = 2831,
    tab = nil,
    name = "老玩家回归邀请码",
    desc = "",
    prefab = "InviteCodePopView",
    class = "InviteCodePopOverSeaView"
  },
  GroupPurchaseView = {
    id = 2840,
    tab = nil,
    name = "波利集市团购界面",
    desc = "",
    prefab = "GroupPurchaseView",
    class = "GroupPurchaseView"
  },
  TimeLimitShopView = {
    id = 2841,
    tab = nil,
    name = "限时商店",
    desc = "",
    prefab = "TimeLimitShopView",
    class = "TimeLimitShopView"
  },
  ReturnActivityPanel = {
    id = 2842,
    tab = nil,
    name = "老玩家回归界面",
    desc = "",
    prefab = "ReturnActivityPanel",
    class = "ReturnActivityPanel"
  },
  ReturnActivityTaskPage = {
    id = 2843,
    tab = 1,
    name = "老玩家回归界面-任务",
    desc = "",
    prefab = "ReturnActivityTaskPage",
    class = "ReturnActivityTaskPage"
  },
  ReturnActivityShopPage = {
    id = 2844,
    tab = 2,
    name = "老玩家回归界面-商店",
    desc = "",
    prefab = "ReturnActivityShopPage",
    class = "ReturnActivityShopPage"
  },
  BoliWishingPanel = {
    id = 2845,
    tab = nil,
    name = "波利许愿",
    desc = "",
    prefab = "BoliWishingPanel",
    class = "BoliWishingPanel"
  },
  DayloginAnniversaryPanel = {
    id = 2846,
    tab = nil,
    name = "活动签到1",
    desc = "",
    prefab = "DayloginAnniversaryPanel",
    class = "DayloginAnniversaryPanel"
  },
  DayloginNewbiePanel = {
    id = 2847,
    tab = nil,
    name = "活动签到2",
    desc = "",
    prefab = "DayloginNewbiePanel",
    class = "DayloginNewbiePanel"
  },
  ActivityIntegrationView = {
    id = 2848,
    tab = nil,
    name = "活动签到2",
    desc = "",
    prefab = "ActivityIntegrationView",
    class = "ActivityIntegrationView"
  },
  CommunityIntegrationView = {
    id = 2849,
    tab = nil,
    name = "社群",
    desc = "",
    prefab = "ActivityIntegrationView",
    class = "CommunityIntegrationView"
  },
  ChasingView = {
    id = 2850,
    tab = nil,
    name = "追逐战",
    desc = "",
    prefab = "ChasingView",
    class = "ChasingView"
  },
  CameraGuidePopUp = {
    id = 2851,
    tab = nil,
    name = "自由视角引导",
    prefab = "CameraGuidePopUp",
    class = "CameraGuidePopUp",
    hideCollider = true
  },
  GuildScoreRankView = {
    id = 2860,
    tab = 1,
    name = "公会积分排名",
    desc = "",
    prefab = "GuildScoreRankView",
    class = "GuildScoreRankView"
  },
  BifrostMatSubmitView = {
    id = 2861,
    tab = nil,
    name = "彩虹桥捐献",
    desc = "",
    prefab = "BifrostMatSubmitView",
    class = "BifrostMatSubmitView"
  },
  GuildScoreRankPage = {
    id = 2862,
    tab = 1,
    name = "公会积分排名",
    desc = "",
    prefab = "GuildScoreRankView",
    class = "GuildScoreRankView"
  },
  GuildScoreMemberRankPage = {
    id = 2863,
    tab = 2,
    name = "公会成员积分排名",
    desc = "",
    prefab = "GuildScoreRankView",
    class = "GuildScoreRankView"
  },
  RecommendScoreView = {
    id = 2870,
    tab = nil,
    name = "评论推荐",
    desc = "",
    prefab = "RecommendScoreView",
    class = "RecommendScoreView"
  },
  ActivityCalendarView = {
    id = 2871,
    tab = nil,
    name = "活动日历",
    desc = "",
    prefab = "ActivityCalendarView",
    class = "ActivityCalendarView"
  },
  QuestionnaireScoreView = {
    id = 2872,
    tab = nil,
    name = "问卷星调查",
    desc = "",
    prefab = "RecommendScoreView",
    class = "QuestionnaireScoreView"
  },
  PracticeFieldView = {
    id = 2900,
    tab = nil,
    name = "演练场",
    prefab = "PracticeFieldView",
    class = "PracticeFieldView",
    hideCollider = true
  },
  ImproveShortCutView = {
    id = 2901,
    tab = nil,
    name = "强化推荐界面",
    prefab = "ImproveShortCutView",
    class = "ImproveShortCutView"
  },
  CameraSelectView = {
    id = 2910,
    tab = nil,
    name = "镜头初始选择界面",
    desc = "",
    prefab = "CameraSelectView",
    class = "CameraSelectView"
  },
  LotteryMixedView = {
    id = 2920,
    tab = nil,
    name = "拾光扭蛋",
    desc = "",
    prefab = "LotteryMixedView",
    class = "LotteryMixedView"
  },
  StealthGameEntranceView = {
    id = 2930,
    name = "心锁副本入口",
    desc = "",
    prefab = "StealthGameEntranceView",
    class = "StealthGameEntranceView"
  },
  MemoryEquipPopUp = {
    id = 2940,
    tab = nil,
    name = "装备记忆",
    desc = "",
    prefab = "MemoryEquipPopUp",
    class = "MemoryEquipPopUp"
  },
  EquipMemoryCombineView = {
    id = 2941,
    tab = nil,
    name = "装备记忆功能整合界面",
    desc = "",
    prefab = "CommonCombineView",
    class = "EquipMemoryCombineView",
    hideCollider = true
  },
  EquipMemoryUpgradeView = {
    id = 2942,
    tab = nil,
    name = "装备记忆升级",
    desc = "",
    prefab = "EquipMemoryUpgradeView",
    class = "EquipMemoryUpgradeView"
  },
  EquipMemoryAttrResetView = {
    id = 2943,
    tab = nil,
    name = "装备记忆词条重置",
    desc = "",
    prefab = "EquipMemoryAttrResetView",
    class = "EquipMemoryAttrResetView"
  },
  EquipMemoryDecomposeView = {
    id = 2944,
    tab = nil,
    name = "装备记忆词条拆解",
    desc = "",
    prefab = "EquipMemoryDecomposeView",
    class = "EquipMemoryDecomposeView"
  },
  EquipMemoryEmbedView = {
    id = 2945,
    tab = nil,
    name = "装备镶嵌记忆",
    desc = "",
    prefab = "EquipMemoryEmbedView",
    class = "EquipMemoryEmbedView"
  },
  EquipMemoryWaxView = {
    id = 2946,
    tab = nil,
    name = "记忆封蜡界面",
    desc = "",
    prefab = "EquipMemoryWaxView",
    class = "EquipMemoryWaxView"
  },
  EquipMemoryAutoDecomposePopup = {
    id = 2947,
    tab = nil,
    name = "自动分解记忆设置",
    desc = "",
    prefab = "EquipMemoryAutoDecomposePopup",
    class = "EquipMemoryAutoDecomposePopup",
    hideCollider = true
  },
  EquipMemoryAdvanceView = {
    id = 2948,
    tab = nil,
    name = "记忆升阶",
    desc = "",
    prefab = "EquipMemoryAdvanceView",
    class = "EquipMemoryAdvanceView"
  },
  RefineIntegerCombineView = {
    id = 2950,
    tab = nil,
    name = "精炼整合-整合内",
    desc = "",
    prefab = "RefineCombineView",
    class = "RefineIntegerCombineView",
    hideCollider = true
  },
  NpcRefineSubView = {
    id = 2951,
    tab = 1,
    name = "精炼子界面",
    desc = "",
    prefab = "NpcRefineSubView",
    class = "NpcRefineSubView"
  },
  RefineTransferSubView = {
    id = 2952,
    tab = 2,
    name = "精炼转移子界面",
    desc = "",
    prefab = "RefineTransferSubView",
    class = "RefineTransferSubView"
  },
  EnchantIntegerCombineView = {
    id = 2960,
    tab = nil,
    name = "附魔整合-整合内",
    desc = "",
    prefab = "CommonCombineView",
    class = "EnchantIntegerCombineView",
    hideCollider = true
  },
  EnchantSubView = {
    id = 2961,
    name = "附魔子界面",
    desc = "",
    prefab = "EnchantSubView",
    class = "EnchantSubView"
  },
  EnchantAttrUpSubView = {
    id = 2962,
    name = "附魔子界面2",
    desc = "",
    prefab = "EnchantAttrUpSubView",
    class = "EnchantAttrUpSubView"
  },
  EnchantThirdAttrResetSubView = {
    id = 2963,
    name = "附魔子界面3",
    desc = "",
    prefab = "EnchantThirdAttrResetSubView",
    class = "EnchantThirdAttrResetSubView"
  },
  EnchantTransferSubView = {
    id = 2964,
    name = "附魔子界面3",
    desc = "",
    prefab = "EnchantTransferSubView",
    class = "EnchantTransferSubView"
  },
  LotteryDollView = {
    id = 3001,
    tab = nil,
    name = "娃娃机",
    desc = "",
    prefab = "LotteryDollView",
    class = "LotteryDollView"
  },
  ComodoRaidStatisticsView = {
    id = 3010,
    tab = nil,
    name = "克魔岛团本信息",
    desc = "",
    prefab = "RaidStatistics",
    class = "ComodoRaidStatisticsView",
    hideCollider = true
  },
  BokiMainView = {
    id = 3020,
    tab = nil,
    name = "波姬",
    desc = "",
    prefab = "BokiMainView",
    class = "BokiMainView"
  },
  BokiView = {
    id = 3021,
    tab = 1,
    name = "装备信息界面",
    desc = "",
    prefab = "BokiView",
    class = "BokiView"
  },
  BokiSkillPage = {
    id = 3022,
    tab = 2,
    name = "技能界面",
    desc = "",
    prefab = "BokiSkillPage",
    class = "BokiSkillPage"
  },
  MayPalaceEntranceView = {
    id = 3030,
    tab = nil,
    name = "美之宫入口",
    desc = "",
    prefab = "MayPalaceEntranceView",
    class = "MayPalaceEntranceView"
  },
  MiniROView = {
    id = 3035,
    tab = nil,
    name = "大富翁",
    desc = "",
    prefab = "MiniROView",
    class = "MiniROView"
  },
  MiniRORewardView = {
    id = 3036,
    tab = nil,
    name = "大富翁奖励列表",
    desc = "",
    prefab = "MiniRORewardView",
    class = "MiniRORewardView"
  },
  MiniRODirectDiceView = {
    id = 3037,
    tab = nil,
    name = "大富翁定向骰子",
    desc = "",
    prefab = "MiniRODirectDiceView",
    class = "MiniRODirectDiceView"
  },
  ServantRoundRewardView = {
    id = 3038,
    tab = nil,
    name = "执事奖励列表",
    desc = "",
    prefab = "MiniRORewardView",
    class = "ServantRoundRewardView"
  },
  VideoDownloadView = {
    id = 3040,
    tab = nil,
    name = "下载界面",
    desc = "",
    prefab = "VideoDownloadView",
    class = "VideoDownloadView"
  },
  RaidPuzzleChooseBuffView = {
    id = 3050,
    tab = nil,
    name = "选择增益buff",
    prefab = "RaidPuzzleChooseBuffView",
    class = "RaidPuzzleChooseBuffView"
  },
  BlackCatFishingView = {
    id = 3051,
    tab = nil,
    name = "七王室黑猫钓鱼",
    prefab = "BlackCatFishing",
    class = "BlackCatFishingView"
  },
  JournalView = {
    id = 3060,
    tab = nil,
    name = "初心者手账",
    prefab = "JournalView",
    class = "JournalView"
  },
  ImproveShortCutView = {
    id = 3070,
    tab = nil,
    name = "强化途径指引",
    prefab = "ImproveShortCutView",
    class = "ImproveShortCutView"
  },
  FailView = {
    id = 3071,
    tab = nil,
    name = "挑战失败提示",
    prefab = "FailView",
    class = "FailView"
  },
  NoviceExpGuideView = {
    id = 3072,
    tab = nil,
    name = "升级途径提示",
    prefab = "NoviceExpGuideView",
    class = "NoviceExpGuideView"
  },
  ChapterEditableView = {
    id = 3080,
    tab = nil,
    name = "章节界面",
    desc = "",
    prefab = "ChapterEditableView",
    class = "ChapterEditableView"
  },
  DisneyQTEView = {
    id = 3199,
    tab = nil,
    name = "迪士尼QTE",
    desc = "",
    prefab = "DisneyQTEView",
    class = "DisneyQTEView"
  },
  DisneyQTEResultView = {
    id = 3198,
    tab = nil,
    name = "迪士尼副本内结算",
    desc = "",
    prefab = "DisneyQTEResultView",
    class = "DisneyQTEResultView"
  },
  CrossSceneMaskView = {
    id = 3081,
    tab = nil,
    name = "跨场景遮罩界面",
    desc = "",
    prefab = "ChapterEditableView",
    class = "CrossSceneMaskView"
  },
  NewChapterView = {
    id = 3082,
    tab = nil,
    name = "副本地点UI动画",
    desc = "",
    prefab = "NewChapterView",
    class = "NewChapterView"
  },
  RewardSelectView = {
    id = 3090,
    tab = nil,
    name = "奖励道具选择界面",
    prefab = "RewardSelectView",
    class = "RewardSelectView"
  },
  DisneyFlowerCarPhotographPanel = {
    id = 3197,
    tab = nil,
    name = "迪士尼花车拍照",
    desc = "",
    prefab = "PhotographPanel",
    class = "DisneyFlowerCarPhotographPanel",
    hideCollider = true
  },
  LightPuzzleHandleView = {
    id = 3200,
    tab = nil,
    name = "光线解谜操作台界面",
    desc = "",
    prefab = "LightPuzzleHandleView",
    class = "LightPuzzleHandleView"
  },
  UniqueConfirmView_Hotfix = {
    id = 1056,
    tab = nil,
    name = "热更提示确认框",
    desc = "",
    prefab = "UniqueConfirmView_Hotfix",
    class = "UniqueConfirmView_Hotfix"
  },
  DisneyActivityOverview = {
    id = 3111,
    tab = nil,
    name = "迪斯尼活动引导",
    desc = "",
    prefab = "DisneyActivityOverview",
    class = "DisneyActivityOverview"
  },
  DisneyTeamView = {
    id = 3112,
    tab = nil,
    name = "迪斯尼组队",
    desc = "",
    prefab = "DisneyTeamView",
    class = "DisneyTeamView"
  },
  DisneyMusicView = {
    id = 3112,
    tab = nil,
    name = "迪斯尼选曲",
    desc = "",
    prefab = "DisneyMusicView",
    class = "DisneyMusicView"
  },
  ColorFillingView = {
    id = 3120,
    tab = nil,
    name = "迪士尼填色游戏",
    desc = "",
    prefab = "ColorFillingView",
    class = "ColorFillingView"
  },
  ColorFillingShareView = {
    id = 3121,
    tab = nil,
    name = "迪士尼填色游戏分享界面",
    desc = "",
    prefab = "ColorFillingShareView",
    class = "ColorFillingShareView"
  },
  SevenRoyalColorFillingView = {
    id = 3122,
    tab = nil,
    name = "金弦琴填色游戏",
    desc = "",
    prefab = "SevenRoyalColorFillingView",
    class = "SevenRoyalColorFillingView"
  },
  DonateView = {
    id = 3130,
    tab = nil,
    name = "活动捐献",
    prefab = "DonateView",
    class = "DonateView"
  },
  ElementStaticsView = {
    id = 3140,
    tab = nil,
    name = "元素副本信息",
    desc = "",
    prefab = "RaidStatistics",
    class = "ElementStaticsView",
    hideCollider = true
  },
  BaseQTEView = {
    id = 3150,
    tab = nil,
    name = "基础通用QTE",
    desc = "",
    prefab = "BaseQTEView",
    class = "BaseQTEView"
  },
  LightPuzzleHandleView = {
    id = 3200,
    tab = nil,
    name = "光线解谜操作台界面",
    desc = "",
    prefab = "LightPuzzleHandleView",
    class = "LightPuzzleHandleView"
  },
  DisneyRankView = {
    id = 3501,
    tab = nil,
    name = "迪士尼挑战任务排行",
    desc = "",
    prefab = "DisneyRankView",
    class = "DisneyRankView"
  },
  DisneyHappyPointPanel = {
    id = 3511,
    tab = nil,
    name = "迪士尼欢乐值界面",
    desc = "",
    prefab = "DisneyHappyPointPanel",
    class = "DisneyHappyPointPanel"
  },
  CookMasterView = {
    id = 3521,
    tab = nil,
    name = "厨王争霸赛",
    desc = "",
    prefab = "CookMasterView",
    class = "CookMasterView"
  },
  CookMasterResultView = {
    id = 3522,
    tab = nil,
    name = "厨王争霸赛结算",
    desc = "",
    prefab = "CookMasterResultView",
    class = "CookMasterResultView"
  },
  NewAgreeMentPanel = {
    id = 3510,
    tab = nil,
    name = "许可协议",
    desc = "",
    prefab = "NewAgreeMentPanel",
    class = "NewAgreeMentPanel"
  },
  AgeDetailInfoPanel = {
    id = 3512,
    tab = nil,
    name = "适龄提示",
    desc = "",
    prefab = "AgeDetailInfoPanel",
    class = "AgeDetailInfoPanel"
  },
  AndroidPermissionPanel = {
    id = 3520,
    tab = nil,
    name = "安卓权限请求",
    desc = "",
    prefab = "AndroidPermissionPanel",
    class = "AndroidPermissionPanel"
  },
  NewCreateRoleView = {
    id = 3523,
    tab = nil,
    name = "NewCreateRoleView",
    desc = "新创角",
    prefab = "NewCreateRoleView",
    class = "NewCreateRoleView"
  },
  PetPackagePopView = {
    id = 3524,
    tab = nil,
    name = "PetPackagePopView",
    desc = "弹框",
    prefab = "PetPackagePopView",
    class = "PetPackagePopView"
  },
  CreateRoleView_v3 = {
    id = 3525,
    tab = nil,
    name = "CreateRoleView_v3",
    desc = "新创角v3",
    prefab = "CreateRoleView_v3",
    class = "CreateRoleView_v3"
  },
  ChooseServantView = {
    id = 3550,
    tab = nil,
    name = "选择执事",
    desc = "",
    prefab = "ChooseServantView",
    class = "ChooseServantView"
  },
  DisneyFriendsInfoPanel = {
    id = 3531,
    tab = nil,
    name = "克魔岛伙伴界面",
    desc = "",
    prefab = "DisneyFriendsInfoPanel",
    class = "DisneyFriendsInfoPanel"
  },
  ManorPartnerGiftPopUp = {
    id = 3532,
    tab = nil,
    name = "克魔岛伙伴送礼",
    desc = "",
    prefab = "ManorPartnerGiftPopUp",
    class = "ManorPartnerGiftPopUp"
  },
  DyeComposeView = {
    id = 3540,
    tab = nil,
    name = "染料合成",
    desc = "",
    prefab = "DyeComposeView",
    class = "DyeComposeView"
  },
  DriftBottleView = {
    id = 3600,
    tab = nil,
    name = "漂流瓶界面",
    desc = "",
    prefab = "DriftBottleView",
    class = "DriftBottleView"
  },
  DriftBottlePanel = {
    id = 3601,
    tab = nil,
    name = "漂流瓶面板",
    desc = "",
    prefab = "DriftBottlePanel",
    class = "DriftBottlePanel"
  },
  SniperView = {
    id = 3700,
    tab = nil,
    name = "枪手鹰眼模式",
    desc = "",
    prefab = "SniperView",
    class = "SniperView"
  },
  LightShadowView = {
    id = 3710,
    tab = nil,
    name = "光影系统",
    desc = "",
    prefab = "LightShadowView",
    class = "LightShadowView"
  },
  PlayerRefluxBackView = {
    id = 3710,
    tab = nil,
    name = "玩家回归",
    desc = "",
    prefab = "PlayerRefluxBackView",
    class = "PlayerRefluxBackView"
  },
  PlayerRefluxView = {
    id = 3711,
    tab = nil,
    name = "呼朋唤友",
    desc = "",
    prefab = "PlayerRefluxView",
    class = "PlayerRefluxView"
  },
  PlayerRefluxShareView = {
    id = 3712,
    tab = nil,
    name = "召回分享",
    desc = "",
    prefab = "PlayerRefluxShareView",
    class = "PlayerRefluxShareView"
  },
  PlayerRefluxPopView = {
    id = 3713,
    tab = nil,
    name = "弹窗",
    desc = "",
    prefab = "PlayerRefluxPopView",
    class = "PlayerRefluxPopView"
  },
  NewPartnerActView = {
    id = 3714,
    tab = nil,
    name = "海外玩家回归新",
    desc = "",
    prefab = "PlayerRefluxBackView",
    class = "NewPartnerActView"
  },
  QuestLimitTimeView = {
    id = 5202,
    tab = nil,
    name = "限时任务奖励",
    desc = "",
    prefab = "QuestLimitTimeView",
    class = "QuestLimitTimeView"
  },
  DetectiveMainPanel = {
    id = 4000,
    tab = nil,
    name = "证据手册",
    desc = "",
    prefab = "DetectiveMainPanel",
    class = "DetectiveMainPanel"
  },
  DetectiveEvidencePage = {
    id = 4001,
    tab = 1,
    name = "证物",
    desc = "",
    prefab = "DetectiveEvidencePage",
    class = "DetectiveEvidencePage"
  },
  DetectiveFilePage = {
    id = 4002,
    tab = 2,
    name = "档案",
    desc = "",
    prefab = "DetectiveFilePage",
    class = "DetectiveFilePage"
  },
  DetectiveSkillPage = {
    id = 4003,
    tab = 3,
    name = "洞察技能",
    desc = "",
    prefab = "DetectiveSkillPage",
    class = "DetectiveSkillPage"
  },
  EvidenceShowPanel = {
    id = 4005,
    tab = nil,
    name = "证物出示",
    desc = "",
    prefab = "EvidenceShowPanel",
    class = "EvidenceShowPanel"
  },
  JointInferencePanel = {
    id = 4010,
    tab = nil,
    name = "联合推理",
    desc = "",
    prefab = "JointInferencePanel",
    class = "JointInferencePanel"
  },
  PveView = {
    id = 4110,
    tab = nil,
    name = "Pve副本入口",
    desc = "",
    prefab = "PveView",
    class = "PveView"
  },
  PveAchievementPopup = {
    id = 4111,
    tab = nil,
    name = "Pve成就",
    desc = "",
    prefab = "PveAchievementPopup",
    class = "PveAchievementPopup"
  },
  PveMonsterPopUp = {
    id = 4112,
    tab = 1,
    name = "Pve魔物",
    desc = "",
    prefab = "PveMonsterPopUp",
    class = "PveMonsterPopUp"
  },
  PveSkillPage = {
    id = 4113,
    tab = 1,
    name = "Pve魔物技能阶段",
    desc = "",
    prefab = "PveMonsterPopUp",
    class = "PveSkillPage"
  },
  PveSummonPage = {
    id = 4114,
    tab = 2,
    name = "Pve召唤",
    desc = "",
    prefab = "PveMonsterPopUp",
    class = "PveSummonPage"
  },
  PveIntroductionPage = {
    id = 4115,
    tab = 3,
    name = "Pve介绍",
    desc = "",
    prefab = "PveMonsterPopUp",
    class = "PveIntroductionPage"
  },
  PveInvitePopUp = {
    id = 4116,
    tab = nil,
    name = "新版Pve邀请",
    desc = "",
    prefab = "PveInvitePopUp",
    class = "PveInvitePopUp",
    hideCollider = true
  },
  PveGroupInvitePopUp = {
    id = 4117,
    tab = nil,
    name = "新版团队Pve邀请",
    desc = "",
    prefab = "PveGroupInvitePopUp",
    class = "PveGroupInvitePopUp",
    hideCollider = true
  },
  PveViewCardPopUp = {
    id = 4118,
    tab = nil,
    name = "PveCard新增奖励",
    desc = "",
    prefab = "PveViewCardPopUp",
    class = "PveViewCardPopUp"
  },
  PveViewEndlessPopUp = {
    id = 4119,
    tab = nil,
    name = "无限塔超级弹射",
    desc = "",
    prefab = "PveViewEndlessPopUp",
    class = "PveViewEndlessPopUp"
  },
  MultiBossRaidStatView = {
    id = 4020,
    tab = nil,
    name = "七王室团本信息",
    desc = "",
    prefab = "RaidStatistics",
    class = "MultiBossRaidStatView",
    hideCollider = true
  },
  PveAffixSubview = {
    id = 4021,
    tab = nil,
    name = "古城秘境本周词缀子界面",
    desc = "",
    prefab = "WildMvp/WildMvpAffixSubview",
    class = "PveAffixSubview"
  },
  PveAffixPopUp = {
    id = 4022,
    tab = nil,
    name = "PVE词缀",
    desc = "",
    prefab = "PveAffixSubview",
    class = "PveAffixPopUp"
  },
  RoadOfHeroView = {
    id = 4120,
    tab = nil,
    name = "英雄之路",
    desc = "",
    prefab = "RoadOfHeroView",
    class = "RoadOfHeroView"
  },
  HeroRoadPicPopUp = {
    id = 4121,
    tab = nil,
    name = "英雄之路剧照",
    desc = "",
    prefab = "HeroRoadPicPopUp",
    class = "HeroRoadPicPopUp"
  },
  AstralPrayPopUp = {
    id = 4200,
    tab = nil,
    name = "星座之塔祝福",
    desc = "",
    prefab = "AstralPrayPopUp",
    class = "AstralPrayPopUp"
  },
  AstralRewardPopUp = {
    id = 4201,
    tab = nil,
    name = "星座之塔奖励",
    desc = "",
    prefab = "AstralRewardPopUp",
    class = "AstralRewardPopUp"
  },
  AstralStaticsView = {
    id = 4202,
    tab = nil,
    name = "星座之塔统计",
    desc = "",
    prefab = "RaidStatistics",
    class = "AstralStaticsView",
    hideCollider = true
  },
  AstralDestinyGraphView = {
    id = 4203,
    tab = nil,
    name = "星座命运图谱",
    desc = "",
    prefab = "AstralDestinyGraphView",
    class = "AstralDestinyGraphView"
  },
  AbyssDailyQuestBoardView = {
    id = 4300,
    tab = nil,
    name = "深渊任务",
    desc = "",
    prefab = "AbyssDailyQuestBoardView",
    class = "AbyssDailyQuestBoardView"
  },
  RedPacketSendView = {
    id = 5101,
    tab = nil,
    name = "发送红包",
    desc = "",
    prefab = "RedPacketSendView",
    class = "RedPacketSendView"
  },
  RedPacketView = {
    id = 5102,
    tab = nil,
    name = "抢红包",
    desc = "",
    prefab = "RedPacketView",
    class = "RedPacketView"
  },
  GVGRedPacketSendView = {
    id = 5103,
    tab = nil,
    name = "GVG红包",
    desc = "",
    prefab = "GVGRedPacketSendView",
    class = "GVGRedPacketSendView"
  },
  GVGGuildLeaderBlessView = {
    id = 5104,
    tab = nil,
    name = "会长祝福",
    desc = "",
    prefab = "GVGGuildLeaderBlessView",
    class = "GVGGuildLeaderBlessView"
  },
  MindLockerView = {
    id = 5200,
    tab = nil,
    name = "心锁特效",
    desc = "",
    prefab = "MindLockerView",
    class = "MindLockerView"
  },
  RememberLoginView = {
    id = 5201,
    tab = nil,
    name = "纪念登录",
    desc = "",
    prefab = "RememberLoginView",
    class = "RememberLoginView"
  },
  SetAutoHealingView = {
    id = 5400,
    tab = nil,
    name = "自动吃药",
    prefab = "SetAutoHealingView",
    class = "SetAutoHealingView",
    hideCollider = true
  },
  InheritSkillView = {
    id = 4310,
    tab = nil,
    name = "技能传承",
    desc = "",
    prefab = "InheritSkillView",
    class = "InheritSkillView"
  },
  InheritSkillExtendCostPointPopUp = {
    id = 4311,
    tab = nil,
    name = "技能传承扩展点数",
    desc = "",
    prefab = "InheritSkillExtendCostPointPopUp",
    class = "InheritSkillExtendCostPointPopUp"
  },
  AchieveRewardView = {
    id = 4312,
    tab = nil,
    name = "地图成就领奖",
    desc = "",
    prefab = "AchieveRewardView",
    class = "AchieveRewardView"
  },
  PveMatchPopup = {
    id = 4313,
    tab = nil,
    name = "Pve副本队伍职责匹配",
    desc = "",
    prefab = "PveMatchPopup",
    class = "PveMatchPopup"
  },
  CupModeRankPopup = {
    id = 5002,
    tab = nil,
    name = "杯赛排名",
    desc = "",
    prefab = "WarbandSeasonRankPopUp",
    class = "CupModeRankPopup"
  },
  CupModeSignupPopup = {
    id = 5003,
    tab = nil,
    name = "杯赛战队报名",
    desc = "",
    prefab = "WarbandSignupPopUp",
    class = "CupModeSignupPopup"
  },
  TeamPwsCreateRoomPopup = {
    id = 6001,
    tab = nil,
    name = "自定义创建房间",
    desc = "",
    prefab = "TeamPwsCreateRoomPopup",
    class = "TeamPwsCreateRoomPopup"
  },
  TeamPwsCustomRoomListPopup = {
    id = 6002,
    tab = nil,
    name = "自定义房间列表",
    desc = "",
    prefab = "TeamPwsCustomRoomListPopup",
    class = "TeamPwsCustomRoomListPopup"
  },
  TeamPwsCustomRoomInfoPopup = {
    id = 6003,
    tab = nil,
    name = "房间信息",
    desc = "",
    prefab = "TeamPwsCustomRoomInfoPopup",
    class = "TeamPwsCustomRoomInfoPopup"
  },
  TeamPwsCustomRoomReadyPopup = {
    id = 6010,
    tab = nil,
    name = "自定义就绪确认",
    desc = "",
    prefab = "TeamPwsCustomRoomReadyPopup",
    class = "TeamPwsCustomRoomReadyPopup"
  },
  BanCardPopup = {
    id = 6011,
    tab = nil,
    name = "ban卡弹窗",
    desc = "",
    prefab = "BanCardPopup",
    class = "BanCardPopup"
  },
  PasswordPopup = {
    id = 6050,
    tab = nil,
    name = "输入密码",
    desc = "",
    prefab = "PasswordPopup",
    class = "PasswordPopup"
  },
  DownloadTip = {
    id = 6051,
    tab = nil,
    name = "下载ui",
    desc = "",
    prefab = "DownloadTip",
    class = "DownloadTip"
  },
  DownloadConfirmView = {
    id = 6052,
    tab = nil,
    name = "下载ui",
    desc = "",
    prefab = "DownloadConfirmView",
    class = "DownloadConfirmView"
  },
  PvpCustomRoomPopup = {
    id = 6053,
    tab = nil,
    name = "12v12房间列表",
    desc = "",
    prefab = "PvpCustomRoomPopup",
    class = "PvpCustomRoomPopup"
  },
  TransferProfessionView = {
    id = 5230,
    tab = nil,
    name = "转职UI",
    prefab = "TransferProfessionView",
    class = "TransferProfessionView"
  },
  SkillRecommendPopUp = {
    id = 5300,
    tab = nil,
    name = "技能推荐加点",
    prefab = "SkillRecommendPopUp",
    class = "SkillRecommendPopUp"
  },
  GuildAssembleRewardView = {
    id = 5500,
    tab = nil,
    name = "公会集结奖励",
    prefab = "GuildAssembleRewardView",
    class = "GuildAssembleRewardView"
  },
  CardLotteryView = {
    id = 5320,
    tab = nil,
    name = "新卡片扭蛋",
    desc = "",
    prefab = "CardLotteryView",
    class = "CardLotteryView"
  },
  NewLotteryResultView = {
    id = 5321,
    tab = nil,
    name = "扭蛋十连抽结算",
    desc = "",
    prefab = "NewLotteryResultView",
    class = "NewLotteryResultView"
  },
  NoviceCombineView = {
    id = 5501,
    tab = nil,
    name = "初心者",
    prefab = "NoviceCombineView",
    class = "NoviceCombineView"
  },
  NoviceLoginView = {
    id = 5502,
    tab = 1,
    name = "初心签到",
    prefab = "NoviceLoginView",
    class = "NoviceLoginView"
  },
  NoviceShopView = {
    id = 5510,
    tab = nil,
    name = "初心福利",
    prefab = "NoviceShopView",
    class = "NoviceShopView"
  },
  NoviceShopNotifPanel = {
    id = 5511,
    tab = nil,
    name = "初心福利活动宣传",
    prefab = "NoviceShopNotifPanel",
    class = "NoviceShopNotifPanel"
  },
  AccumulativeShopView = {
    id = 5555,
    tab = nil,
    name = "累计充值",
    prefab = "AccumulativeShopView",
    class = "AccumulativeShopView"
  },
  LotteryBannerView = {
    id = 5310,
    tab = nil,
    name = "扭蛋banner图",
    prefab = "LotteryBannerView",
    class = "LotteryBannerView"
  },
  TopicView = {
    id = 5600,
    tab = nil,
    name = "课题",
    prefab = "TopicView",
    class = "TopicView"
  },
  NoviceTarget2023View = {
    id = 5601,
    name = "2023版新手课题",
    desc = "",
    prefab = "NoviceTarget2023View",
    class = "NoviceTarget2023View"
  },
  BattleFundView = {
    id = 7001,
    tab = nil,
    name = "备战基金",
    prefab = "BattleFundView",
    class = "BattleFundView"
  },
  DailyDepositView = {
    id = 7101,
    tab = nil,
    name = "每日充值",
    prefab = "DailyDepositView",
    class = "DailyDepositView"
  },
  TreasuryRechargeView = {
    id = 7102,
    tab = nil,
    name = "充值奖励",
    prefab = "TreasuryRechargeView",
    class = "TreasuryRechargeView"
  },
  NewCardRewardPopup = {
    id = 8001,
    tab = nil,
    name = "新卡片奖励获取界面",
    desc = "",
    prefab = "NewCardRewardPopup",
    class = "NewCardRewardPopup"
  },
  BattleFundConfirmPopup = {
    id = 7002,
    tab = nil,
    name = "备战基金确认",
    prefab = "BattleFundConfirmPopup",
    class = "BattleFundConfirmPopup"
  },
  EndlessBattleResultView = {
    id = 8010,
    tab = nil,
    name = "无尽战场事件结束",
    desc = "",
    prefab = "EndlessBattleResultView",
    class = "EndlessBattleResultView",
    hideCollider = true
  },
  EndlessBattleFieldBannerView = {
    id = 8011,
    tab = nil,
    name = "无尽战场阵营提示",
    desc = "",
    prefab = "EndlessBattleFieldBannerView",
    class = "EndlessBattleFieldBannerView",
    hideCollider = true
  },
  EndlessBattleFieldResultPopUp = {
    id = 8012,
    tab = nil,
    name = "无尽战场战报",
    desc = "",
    prefab = "EndlessBattleFieldResultPopUp",
    class = "EndlessBattleFieldResultPopUp"
  },
  WildMvpView = {
    id = 9001,
    tab = nil,
    name = "野外MVP",
    desc = "",
    prefab = "WildMvp/WildMvpView",
    class = "WildMvpView"
  },
  WildMvpAllAffixPopup = {
    id = 9002,
    tab = nil,
    name = "野外MVP所有词缀",
    desc = "",
    prefab = "WildMvp/WildMvpAllAffixPopup",
    class = "WildMvpAllAffixPopup"
  },
  WildMvpAffixSubview = {
    id = 9003,
    tab = nil,
    name = "野外MVP本周词缀子界面",
    desc = "",
    prefab = "WildMvp/WildMvpAffixSubview",
    class = "WildMvpAffixSubview"
  },
  WildMvpBuffSubview = {
    id = 9004,
    tab = nil,
    name = "野外MVP地图增益子界面",
    desc = "",
    prefab = "WildMvp/WildMvpBuffSubview",
    class = "WildMvpBuffSubview"
  },
  WildMvpMonsterSubview = {
    id = 9005,
    tab = nil,
    name = "野外MVP野怪子界面",
    desc = "",
    prefab = "WildMvp/WildMvpMonsterSubview",
    class = "WildMvpMonsterSubview"
  },
  WildMvpSelectBuffView = {
    id = 9006,
    tab = nil,
    name = "野外MVP增益选取",
    desc = "",
    prefab = "WildMvp/WildMvpSelectBuffView",
    class = "WildMvpSelectBuffView"
  },
  YmirTipView = {
    id = 21001,
    tab = nil,
    name = "伊米尔之书tip",
    desc = "",
    prefab = "YmirTipView",
    class = "YmirTipView",
    hideCollider = true
  },
  YmirTipView_TriplePvp = {
    id = 21002,
    tab = nil,
    name = "伊米尔之书3v3",
    desc = "",
    prefab = "YmirTipView_TriplePvp",
    class = "YmirTipView_TriplePvp",
    hideCollider = true
  },
  AfricanPoringView = {
    id = 22001,
    tab = nil,
    name = "波利转盘",
    desc = "",
    prefab = "AfricanPoring/AfricanPoringView",
    class = "AfricanPoringView"
  },
  PhotoStandPanel = {
    id = 23001,
    tab = nil,
    name = "照片立牌",
    desc = "",
    prefab = "PhotoStandPanel",
    class = "PhotoStandPanel"
  },
  AncientRandomCombineView = {
    id = 24001,
    tab = nil,
    name = "远古装备刷新集合",
    desc = "",
    prefab = "EnchantCombineView",
    class = "AncientRandomCombineView",
    hideCollider = true
  },
  AncientRandomPanel = {
    id = 24002,
    tab = nil,
    name = "远古装备刷新界面",
    desc = "",
    prefab = "AncientRandomPanel",
    class = "AncientRandomPanel"
  },
  AncientUpgradeCombineView = {
    id = 25001,
    tab = nil,
    name = "远古装备品质提升集合",
    desc = "",
    prefab = "EnchantCombineView",
    class = "AncientUpgradeCombineView",
    hideCollider = true
  },
  AncientUpgradePanel = {
    id = 25002,
    tab = nil,
    name = "远古装备品质提升界面",
    desc = "",
    prefab = "AncientUpgradePanel",
    class = "AncientUpgradePanel"
  },
  Anniversary2023SigninView = {
    id = 27001,
    tab = nil,
    name = "2023周年直播签到界面",
    desc = "",
    prefab = "Anniversary/Anniversary2023SigninView",
    class = "Anniversary2023SigninView"
  },
  Anniversary2023LiveView = {
    id = 27002,
    tab = nil,
    name = "2023周年直播界面",
    desc = "",
    prefab = "Anniversary/Anniversary2023LiveView",
    class = "Anniversary2023LiveView"
  },
  Anniversary2023ShareView = {
    id = 27003,
    tab = nil,
    name = "2023周年直播分享界面",
    desc = "",
    prefab = "Anniversary/Anniversary2023ShareView",
    class = "Anniversary2023ShareView"
  },
  MemoryPopup = {
    id = 27005,
    tab = nil,
    name = "七周年回忆录",
    desc = "",
    prefab = "MemoryPopup",
    class = "MemoryPopup"
  },
  MountDressingView = {
    id = 28001,
    tab = nil,
    name = "坐骑换装",
    desc = "",
    prefab = "MountDressingView",
    class = "MountDressingView"
  },
  MountFashionActiveCostPopUp = {
    id = 28002,
    tab = nil,
    name = "坐骑换装资源",
    desc = "",
    prefab = "MountFashionActiveCostPopUp",
    class = "MountFashionActiveCostPopUp"
  },
  AierBlacksmithPanel = {
    id = 29001,
    tab = nil,
    name = "艾尔铁匠铺",
    desc = "",
    prefab = "AierBlacksmithPanel",
    class = "AierBlacksmithPanel"
  },
  PostcardView = {
    id = 30001,
    tab = nil,
    name = "明信片",
    desc = "",
    prefab = "PostcardView",
    class = "PostcardView"
  },
  FoundElfPopup = {
    id = 31001,
    tab = nil,
    name = "找到精灵解锁对应功能",
    desc = "",
    prefab = "FoundElfPopup",
    class = "FoundElfPopup",
    hideCollider = true
  },
  BatteryCannonView = {
    id = 32001,
    tab = nil,
    name = "假的炮击玩法",
    desc = "",
    prefab = "BatteryCannonView",
    class = "BatteryCannonView",
    hideCollider = true
  },
  GVGRoadBlockEditorView = {
    id = 33001,
    tab = nil,
    name = "路障编辑界面",
    desc = "",
    prefab = "GVGRoadBlockEditorView",
    class = "GVGRoadBlockEditorView"
  },
  GVGRoadBlockView = {
    id = 33002,
    tab = nil,
    name = "路径查看界面",
    desc = "",
    prefab = "GVGRoadBlockView",
    class = "GVGRoadBlockView"
  },
  StarArkVictoryView = {
    id = 30011,
    tab = nil,
    name = "古城秘境结算界面",
    desc = "",
    prefab = "StarArkVictoryView",
    class = "StarArkVictoryView"
  },
  StarArkStatisticsView = {
    id = 30012,
    name = "古城秘境战斗统计",
    desc = "",
    prefab = "RaidStatistics",
    class = "StarArkStatisticsView",
    hideCollider = true
  },
  LevelUpPanel = {
    id = 30020,
    tab = nil,
    name = "升级提示",
    desc = "",
    prefab = "LevelUpPanel",
    class = "LevelUpPanel"
  },
  EquipRecommendNewUserView = {
    id = 30021,
    tab = nil,
    name = "玩家装备推荐",
    desc = "",
    prefab = "EquipRecommendNewUserView",
    class = "EquipRecommendNewUserView"
  },
  BigCatInvadeEnterView = {
    id = 30022,
    tab = nil,
    name = "B格猫入侵",
    desc = "",
    prefab = "MvpMatchView",
    class = "BigCatInvadeEnterView"
  },
  ExchangeGiftView = {
    id = 30024,
    tab = nil,
    name = "交换礼物",
    prefab = "DonateView",
    class = "ExchangeGiftView"
  },
  CraftingPotView = {
    id = 30025,
    tab = nil,
    name = "新装备制作",
    desc = "",
    prefab = "CraftingPotView",
    class = "CraftingPotView"
  },
  ResetSecretLandGemPopUp = {
    id = 30030,
    tab = nil,
    name = "重置奥秘符文",
    desc = "",
    prefab = "ResetSecretLandGemPopUp",
    class = "ResetSecretLandGemPopUp"
  },
  SpaceDragonIntroView = {
    id = 30040,
    tab = nil,
    name = "时空龙入口",
    desc = "",
    prefab = "SpaceDragonIntroView",
    class = "SpaceDragonIntroView"
  },
  RoguelikeSkillChooseView = {
    id = 30050,
    tab = nil,
    name = "时空幻境技能选择",
    desc = "",
    prefab = "RoguelikeSkillChooseView",
    class = "RoguelikeSkillChooseView"
  },
  RoguelikeSkillHandbookView = {
    id = 30051,
    tab = nil,
    name = "时空幻境技能手册",
    desc = "",
    prefab = "RoguelikeSkillHandbookView",
    class = "RoguelikeSkillHandbookView"
  },
  FaceBookFavPanel = {
    id = 100001,
    tab = nil,
    name = "点赞礼盒",
    desc = "",
    prefab = "FaceBookFavPanel",
    class = "FaceBookFavPanel"
  },
  LinePanel = {
    id = 100002,
    tab = nil,
    name = "Line",
    desc = ""
  },
  TXWYPlatPanel = {
    id = 100003,
    tab = nil,
    name = "TXWYPlat",
    desc = "",
    prefab = "TXWYPlatPanel",
    class = "TXWYPlatPanel",
    hideCollider = true
  },
  ServiceSettingPage = {
    id = 100004,
    tab = 5,
    name = "客服设置",
    desc = "",
    prefab = "",
    class = ""
  },
  ZenyConvertPanel = {
    id = 100005,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6300",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  ShopConfirmPanel = {
    id = 100006,
    tab = nil,
    name = "ShopConfirmPanel",
    desc = "",
    prefab = "ShopConfirmPanel",
    class = "ShopConfirmPanel"
  },
  NewShopConfirmPanel = {
    id = 1000061,
    tab = nil,
    name = "NewShopConfirmPanel",
    desc = "",
    prefab = "NewShopConfirmPanel",
    class = "NewShopConfirmPanel"
  },
  ZenyConvertPanel1 = {
    id = 100007,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6301",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  ZenyConvertPanel2 = {
    id = 100008,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6302",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  ZenyConvertPanel3 = {
    id = 100009,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6303",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  CreateTipPanel = {
    id = 100010,
    tab = nil,
    name = "CreateTipPanel",
    desc = "",
    prefab = "CreateTipPanel",
    class = "CreateTipPanel",
    hideCollider = true
  },
  ChargeLimitPanel = {
    id = 100011,
    tab = nil,
    name = "ChargeLimitPanel",
    desc = "",
    prefab = "ChargeLimitPanel",
    class = "ChargeLimitPanel"
  },
  ChargeComfirmPanel = {
    id = 100012,
    tab = nil,
    name = "ChargeComfirmPanel",
    desc = "",
    prefab = "ChargeComfirmPanel",
    class = "ChargeComfirmPanel"
  },
  LotteryCoinInfo = {
    id = 100013,
    tab = nil,
    name = "LotteryCoinInfo",
    desc = "",
    prefab = "LotteryCoinInfo",
    class = "LotteryCoinInfo",
    hideCollider = true
  },
  QualitySelect = {
    id = 100014,
    tab = nil,
    name = "QualitySelect",
    desc = "",
    prefab = "QualitySelect",
    class = "QualitySelect"
  },
  ReplenishmentPanel = {
    id = 100020,
    tab = nil,
    name = "海外补款",
    desc = "",
    prefab = "ReplenishmentPanel",
    class = "ReplenishmentPanel"
  },
  LangSwitchPanel = {
    id = 100021,
    tab = nil,
    name = "LangSwitchPanel",
    desc = "",
    prefab = "LangSwitchPanel",
    class = "LangSwitchPanel",
    hideCollider = true
  },
  CustomerServicePanel = {
    id = 100022,
    tab = nil,
    name = "CustomerServicePanel",
    desc = "",
    prefab = "CustomerServicePanel",
    class = "CustomerServicePanel"
  },
  LisaRankPanel = {
    id = 100998,
    tab = nil,
    name = "LisaRankPanel",
    desc = "",
    prefab = "LisaRankPanel",
    class = "LisaRankPanel"
  },
  StorePayPanel = {
    id = 100999,
    tab = nil,
    name = "StorePayPanel",
    desc = "",
    prefab = "StorePayPanel",
    class = "StorePayPanel"
  },
  MaidDungeonView = {
    id = 2201,
    tab = nil,
    name = "女仆活动副本",
    desc = "",
    prefab = "ActivityDungeonView",
    class = "MaidDungeonView"
  },
  MaidDungeonInfo = {
    id = 2202,
    tab = 1,
    name = "女仆活动副本介绍",
    desc = "",
    prefab = "ActivityDungeonInfo",
    class = "MaidDungeonInfo"
  },
  MaidDungeonRate = {
    id = 2203,
    tab = 2,
    name = "女仆活动副本评级",
    desc = "",
    prefab = "ActivityDungeonRate",
    class = "MaidDungeonRate"
  },
  MaidDungeonShop = {
    id = 2204,
    tab = 3,
    name = "女仆活动副本商店",
    desc = "",
    prefab = "ActivityDungeonShop",
    class = "MaidDungeonShop"
  },
  AuthUserInfoView = {
    id = 102000,
    tab = nil,
    name = "用户信息绑定",
    desc = "",
    prefab = "AuthUserInfoView",
    class = "AuthUserInfoView"
  },
  TypeBranchSpeedUpView = {
    id = 103000,
    tab = nil,
    name = "职业分支加速",
    desc = "",
    prefab = "TypeBranchSpeedUpView",
    class = "TypeBranchSpeedUpView"
  },
  SpecialSkillUpgradeView = {
    id = 104000,
    tab = nil,
    name = "骑士技能",
    desc = "",
    prefab = "SpecialSkillUpgradeView",
    class = "SpecialSkillUpgradeView"
  },
  ActivePanel = {
    id = 10004,
    tab = nil,
    name = "激活界面",
    desc = "",
    prefab = "ActivePanel",
    class = "ActivePanel"
  },
  TempActivityView = {
    id = 10005,
    tab = nil,
    name = "运营活动",
    desc = "",
    prefab = "TempActivityView",
    class = "TempActivityView",
    hideCollider = true
  },
  ActiveErrorBord = {
    id = 10006,
    tab = nil,
    name = "激活错误弹框",
    desc = "",
    prefab = "ActiveErrorBord",
    class = "ActiveErrorBord"
  },
  RolesSelect = {
    id = 10009,
    tab = nil,
    name = "角色选择",
    desc = "",
    prefab = "UIViewRolesList",
    class = "UIViewControllerRolesList"
  },
  SecurityPanel = {
    id = 10010,
    tab = nil,
    name = "安全验证",
    desc = "",
    prefab = "SecurityPanel",
    class = "SecurityPanel"
  },
  AgreementPanel = {
    id = 10020,
    tab = nil,
    name = "许可协议",
    desc = "",
    prefab = "AgreementPanel",
    class = "AgreementPanel"
  },
  ActivityDetailPanel = {
    id = 10030,
    tab = nil,
    name = "活动详情",
    desc = "",
    prefab = "ActivityDetailPanel",
    class = "ActivityDetailPanel"
  },
  MiyinStrengthen = {
    id = 10040,
    tab = nil,
    name = "秘银强化",
    desc = "",
    prefab = "UIViewMiyinStrengthen",
    class = "UIViewControllerMiyinStrengthen"
  },
  MarriageCertificate = {
    id = 10050,
    tab = nil,
    name = "结婚证书",
    desc = "",
    prefab = "MarriageCertificate",
    class = "MarriageCertificate"
  },
  MarriageManualPicDiy = {
    id = 10051,
    tab = nil,
    name = "结婚手册diy证书",
    desc = "",
    prefab = "MarriageManualPicDiy",
    class = "MarriageManualPicDiy"
  },
  KFCActivityShowView = {
    id = 10061,
    tab = nil,
    name = "kfc活动分享",
    desc = "",
    prefab = "KFCActivityShowView",
    class = "KFCActivityShowView"
  },
  KFCARCameraPanel = {
    id = 10062,
    tab = nil,
    name = "kfcarcamera",
    desc = "",
    prefab = "KFCARCameraPanel",
    class = "KFCARCameraPanel"
  },
  SharePanel = {
    id = 10063,
    tab = nil,
    name = "SharePanel",
    desc = "",
    prefab = "SharePanel",
    class = "SharePanel"
  },
  BattleManualPanel = {
    id = 10070,
    tab = nil,
    name = "BattleManualPanel",
    desc = "",
    prefab = "BattleManualPanel",
    class = "BattleManualPanel"
  },
  DungeonManualView = {
    id = 10071,
    tab = 1,
    name = "DungeonManualView",
    desc = "",
    prefab = "DungeonManualView",
    class = "DungeonManualView"
  },
  GuildGVGRewardMsgView = {
    id = 10075,
    tab = nil,
    name = "GuildGVGRewardMsgView",
    desc = "",
    prefab = "GuildGVGRewardMsgView",
    class = "GuildGVGRewardMsgView"
  },
  FastClassChangeGetGemPopUp = {
    id = 10080,
    tab = 1,
    name = "临时奖励功能（测试服）",
    desc = "",
    prefab = "FastClassChangeGetGemPopUp",
    class = "FastClassChangeGetGemPopUp",
    hideCollider = true
  },
  QualitySelectView = {
    id = 10110,
    tab = nil,
    name = "QualitySelectView",
    desc = "",
    prefab = "QualitySelectView",
    class = "QualitySelectView"
  },
  ChooseRouteView = {
    id = 10111,
    tab = nil,
    name = "ChooseRouteView",
    desc = "",
    prefab = "ChooseRouteView",
    class = "ChooseRouteView"
  },
  FullScreenEffectView = {
    id = 10120,
    tab = nil,
    name = "FullScreenEffectView",
    desc = "",
    prefab = "FullScreenEffectView",
    class = "FullScreenEffectView"
  },
  MessageBoardView = {
    id = 11000,
    tab = nil,
    name = "留言板主界面",
    desc = "",
    prefab = "MessageBoardView",
    class = "MessageBoardView"
  },
  MessageTipPage = {
    id = 11001,
    tab = 1,
    name = "留言显示页",
    desc = "",
    prefab = "MessageTipPage",
    class = "MessageTipPage",
    hideCollider = true
  },
  MessageBoardTracePage = {
    id = 11002,
    tab = 2,
    name = "留言板访客记录",
    desc = "",
    prefab = "MessageBoardTracePage",
    class = "MessageBoardTracePage",
    hideCollider = true
  },
  CouponCodeView = {
    id = 12000,
    tab = nil,
    name = "兑换券界面",
    desc = "",
    prefab = "CouponCodeView",
    class = "CouponCodeView"
  },
  IllustrationShowView = {
    id = 12100,
    tab = nil,
    name = "CG图片展示界面",
    desc = "",
    prefab = "IllustrationShowView",
    class = "IllustrationShowView"
  },
  ScreenTransitView = {
    id = 12110,
    tab = nil,
    name = "淡入淡出界面",
    desc = "",
    prefab = "IllustrationShowView",
    class = "ScreenTransitView"
  },
  NewContentPushView = {
    id = 13000,
    tab = nil,
    name = "NewContentPushView",
    desc = "",
    prefab = "NewContentPushView",
    class = "NewContentPushView"
  },
  SgMachineView = {
    id = 14000,
    tab = nil,
    name = "心锁机关",
    desc = "",
    prefab = "SgMachineView",
    class = "SgMachineView"
  },
  SgGuideView = {
    id = 14001,
    tab = nil,
    name = "心锁引导",
    desc = "",
    prefab = "SgGuideView",
    class = "SgGuideView"
  },
  SgPutDownItemView = {
    id = 14002,
    tab = nil,
    name = "心锁放下/取出物品",
    desc = "",
    prefab = "SgPutDownItem",
    class = "SgPutDownItemView"
  },
  NoviceBattlePassView = {
    id = 15000,
    tab = nil,
    name = "新手/回归战令",
    desc = "",
    prefab = "NoviceBattlePassView",
    class = "NoviceBattlePassView"
  },
  NoviceBattlePassTaskView = {
    id = 15001,
    tab = nil,
    name = "新手战令任务",
    desc = "",
    prefab = "NoviceBattlePassTaskView",
    class = "NoviceBattlePassTaskView"
  },
  NewShopQuickBuyView = {
    id = 15100,
    tab = nil,
    name = "商城小购买界面",
    desc = "",
    prefab = "NewHappyShopBuyItemCell",
    class = "NewHappyShopBuyItemCell"
  },
  NewShopBuyView = {
    id = 15101,
    tab = nil,
    name = "商城大购买界面",
    desc = "",
    prefab = "NewRechargeGiftTipCell",
    class = "NewRechargeGiftTipCell"
  },
  GvGCookingView = {
    id = 15200,
    tab = nil,
    name = "大乱炖",
    desc = "",
    prefab = "GVGCookingView",
    class = "GVGCookingView"
  },
  LotteryResultShareView = {
    id = 16001,
    tab = nil,
    name = "十连抽奖分享界面",
    desc = "",
    prefab = "ShareNew/LotteryResultShareView",
    class = "LotteryResultShareView"
  },
  FloatAwardShareView = {
    id = 16002,
    tab = nil,
    name = "抽奖分享界面",
    desc = "",
    prefab = "ShareNew/FloatAwardShareView",
    class = "FloatAwardShareView"
  },
  RefineShareView = {
    id = 16003,
    tab = nil,
    name = "精炼分享界面",
    desc = "",
    prefab = "ShareNew/RefineShareView",
    class = "RefineShareView"
  },
  EquipConvertResultShareView = {
    id = 16004,
    tab = nil,
    name = "装备兑换分享界面",
    desc = "",
    prefab = "ShareNew/EquipConvertResultShareView",
    class = "EquipConvertResultShareView"
  },
  EnchantNewShareView = {
    id = 16005,
    tab = nil,
    name = "附魔分享界面",
    desc = "",
    prefab = "ShareNew/EnchantNewShareView",
    class = "EnchantNewShareView"
  },
  MagicBoxExtractionShareView = {
    id = 16006,
    tab = nil,
    name = "魔盒分享界面",
    desc = "",
    prefab = "ShareNew/MagicBoxExtractionShareView",
    class = "MagicBoxExtractionShareView"
  },
  PersonalArtifactShareView = {
    id = 16007,
    tab = nil,
    name = "上古遗物分享界面",
    desc = "",
    prefab = "ShareNew/PersonalArtifactShareView",
    class = "PersonalArtifactShareView"
  },
  PersonalArtifactRefreshShareView = {
    id = 16008,
    tab = nil,
    name = "上古遗物刷新属性分享界面",
    desc = "",
    prefab = "ShareNew/PersonalArtifactRefreshShareView",
    class = "PersonalArtifactRefreshShareView"
  },
  AdventureShareView = {
    id = 16009,
    tab = nil,
    name = "冒险分享界面",
    desc = "",
    prefab = "ShareNew/AdventureShareView",
    class = "AdventureShareView"
  },
  AllProfessionShareView = {
    id = 16010,
    tab = nil,
    name = "职业解锁分享界面",
    desc = "",
    prefab = "ShareNew/AllProfessionShareView",
    class = "AllProfessionShareView"
  },
  PackageEquipShareView = {
    id = 16011,
    tab = nil,
    name = "装备分享界面",
    desc = "",
    prefab = "ShareNew/PackageEquipShareView",
    class = "PackageEquipShareView"
  },
  PhotoStandShareView = {
    id = 16012,
    tab = nil,
    name = "照片立牌分享界面",
    desc = "",
    prefab = "ShareNew/PhotoStandShareView",
    class = "PhotoStandShareView"
  },
  LotteryResultChatShareView = {
    id = 16051,
    tab = nil,
    name = "十连抽奖聊天分享界面",
    desc = "",
    prefab = "ShareNew/LotteryResultChatShareView",
    class = "LotteryResultChatShareView"
  },
  FloatAwardChatShareView = {
    id = 16052,
    tab = nil,
    name = "抽奖聊天分享界面",
    desc = "",
    prefab = "ShareNew/FloatAwardChatShareView",
    class = "FloatAwardChatShareView"
  },
  RefineChatShareView = {
    id = 16053,
    tab = nil,
    name = "精炼聊天分享界面",
    desc = "",
    prefab = "ShareNew/RefineChatShareView",
    class = "RefineChatShareView"
  },
  EquipConvertResultChatShareView = {
    id = 16054,
    tab = nil,
    name = "装备兑换聊天分享界面",
    desc = "",
    prefab = "ShareNew/EquipConvertResultChatShareView",
    class = "EquipConvertResultChatShareView"
  },
  EnchantNewChatShareView = {
    id = 16055,
    tab = nil,
    name = "附魔聊天分享界面",
    desc = "",
    prefab = "ShareNew/EnchantNewChatShareView",
    class = "EnchantNewChatShareView"
  },
  MagicBoxExtractionChatShareView = {
    id = 16056,
    tab = nil,
    name = "魔盒聊天分享界面",
    desc = "",
    prefab = "ShareNew/MagicBoxExtractionChatShareView",
    class = "MagicBoxExtractionChatShareView"
  },
  PersonalArtifactChatShareView = {
    id = 16057,
    tab = nil,
    name = "上古遗物聊天分享界面",
    desc = "",
    prefab = "ShareNew/PersonalArtifactChatShareView",
    class = "PersonalArtifactChatShareView"
  },
  PersonalArtifactRefreshChatShareView = {
    id = 16058,
    tab = nil,
    name = "上古遗物刷新属性聊天分享界面",
    desc = "",
    prefab = "ShareNew/PersonalArtifactRefreshChatShareView",
    class = "PersonalArtifactRefreshChatShareView"
  },
  PreviewSaleRoleTaskView = {
    id = 17000,
    tab = nil,
    name = "售前任务",
    desc = "",
    prefab = "PreviewSaleRoleTaskView",
    class = "PreviewSaleRoleTaskView"
  }
}
