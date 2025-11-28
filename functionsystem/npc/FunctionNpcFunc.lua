FunctionNpcFunc = class("FunctionNpcFunc")
autoImport("FuncLaboratoryShop")
autoImport("FuncAdventureSkill")
autoImport("FunctionMiyinStrengthen")
autoImport("UIMapAreaList")
autoImport("UIMapMapList")
autoImport("RaidEnterWaitView")
NpcFuncState = {
  Active = 1,
  InActive = 2,
  Grey = 3
}

function FunctionNpcFunc.Me()
  if nil == FunctionNpcFunc.me then
    FunctionNpcFunc.me = FunctionNpcFunc.new()
  end
  return FunctionNpcFunc.me
end

local NpcFuncType = {
  Common_Shop = "Common_Shop",
  Common_NotifyServer = "NotifyServer",
  Common_GuildRaid = "Common_GuildRaid",
  Common_InvitethePersonoflove = "Common_InvitethePersonoflove",
  Common_AboutDateLand = "Common_AboutDateLand",
  Common_Augury = "Common_Augury",
  Common_AboutAugury = "Common_AboutAugury",
  Common_Hyperlink = "Common_Hyperlink",
  Roguelike = "Roguelike",
  Common_ShortCut = "Common_ShortCut"
}

function FunctionNpcFunc:ctor()
  self.funcMap = {}
  self.checkMap = {}
  self.updateCheckMap = {}
  local handles = {}
  handles[NpcFuncType.Common_Shop] = FunctionNpcFunc.TypeFunc_Shop
  handles[NpcFuncType.Common_NotifyServer] = FunctionNpcFunc.TypeFunc_NotifyServer
  handles[NpcFuncType.Common_GuildRaid] = FunctionNpcFunc.TypeFunc_GuildRaid
  handles[NpcFuncType.Common_InvitethePersonoflove] = FunctionNpcFunc.TypeFunc_InvitethePersonoflove
  handles[NpcFuncType.Common_AboutDateLand] = FunctionNpcFunc.TypeFunc_AboutDateLand
  handles[NpcFuncType.Common_Augury] = FunctionNpcFunc.TypeFunc_Augury
  handles[NpcFuncType.Common_AboutAugury] = FunctionNpcFunc.TypeFunc_AboutAugury
  handles[NpcFuncType.Common_Hyperlink] = FunctionNpcFunc.TypeFunc_Hyperlink
  handles[NpcFuncType.Roguelike] = FunctionNpcFunc.Roguelike
  handles[NpcFuncType.Common_ShortCut] = FunctionNpcFunc.TypeFunc_ShortCut
  self:PreprocessNpcFunctionConfig(handles)
  local checkHandles = {}
  checkHandles[NpcFuncType.Common_Shop] = FunctionNpcFunc.CheckTypeFunc_Shop
  checkHandles[NpcFuncType.Roguelike] = FunctionNpcFunc.CheckRoguelike
  self:PreprocessNpcFuncCheckConfig(checkHandles)
  self.funcMap.Oversea_PlayersRecall = FunctionNpcFunc.Oversea_PlayersRecall
  self.funcMap.GooglePlay = FunctionNpcFunc.GooglePlay
  self.funcMap.WeiJing = FunctionNpcFunc.WeiJing
  self.funcMap.Close = FunctionNpcFunc.Close
  self.funcMap.storehouse = FunctionNpcFunc.storehouse
  self.funcMap.Transfer = FunctionNpcFunc.Transfer
  self.funcMap.Refine = FunctionNpcFunc.Refine
  self.funcMap.DeCompose = FunctionNpcFunc.DeCompose
  self.funcMap.Transmit = FunctionNpcFunc.Transmit
  self.funcMap.EndLessTower = FunctionNpcFunc.EndLessTower
  self.funcMap.EndLessTeam = FunctionNpcFunc.EndLessTeam
  self.funcMap.Repair = FunctionNpcFunc.Repair
  self.funcMap.Laboratory = FunctionNpcFunc.Laboratory
  self.funcMap.LaboratoryTeam = FunctionNpcFunc.LaboratoryTeam
  self.funcMap.LaboratoryShop = FunctionNpcFunc.LaboratoryShop
  self.funcMap.Sell = FunctionNpcFunc.Sell
  self.funcMap.Teleporter = FunctionNpcFunc.Teleporter
  self.funcMap.JoinStage = FunctionNpcFunc.JoinStage
  self.funcMap.QueryDefeatBossTime = FunctionNpcFunc.QueryDefeatBossTime
  self.funcMap.DefeatBoss = FunctionNpcFunc.DefeatBoss
  self.funcMap.PicMake = FunctionNpcFunc.PicMake
  self.funcMap.GvgLand = FunctionNpcFunc.GvgLand
  self.funcMap.strengthen = FunctionNpcFunc.strengthen
  self.funcMap.CreateGuild = FunctionNpcFunc.CreateGuild
  self.funcMap.ApplyGuild = FunctionNpcFunc.ApplyGuild
  self.funcMap.GuildManor = FunctionNpcFunc.GuildManor
  self.funcMap.UpgradeGuild = FunctionNpcFunc.UpgradeGuild
  self.funcMap.DisMissGuild = FunctionNpcFunc.DisMissGuild
  self.funcMap.OpenGuildRaid = FunctionNpcFunc.OpenGuildRaid
  self.funcMap.ReadyToGuildRaid = FunctionNpcFunc.ReadyToGuildRaid
  self.funcMap.AdventureSkill = FunctionNpcFunc.AdventureSkill
  self.funcMap.SewingStrengthen = FunctionNpcFunc.SewingStrengthen
  self.funcMap.CancelDissolution = FunctionNpcFunc.CancelDissolution
  self.funcMap.OpenBokiView = FunctionNpcFunc.OpenBokiView
  self.funcMap.Dojo = FunctionNpcFunc.Dojo
  self.funcMap.ExitGuild = FunctionNpcFunc.ExitGuild
  self.funcMap.QuickTeam = FunctionNpcFunc.QuickTeam
  self.funcMap.DojoTeam = FunctionNpcFunc.DojoTeam
  self.funcMap.PrimaryEnchant = FunctionNpcFunc.PrimaryEnchant
  self.funcMap.MediumEnchant = FunctionNpcFunc.MediumEnchant
  self.funcMap.SeniorEnchant = FunctionNpcFunc.SeniorEnchant
  self.funcMap.seal = FunctionNpcFunc.seal
  self.funcMap.sealV2 = FunctionNpcFunc.sealV2
  self.funcMap.GuildDonate = FunctionNpcFunc.GuildDonate
  self.funcMap.EquipMake = FunctionNpcFunc.EquipMake
  self.funcMap.EquipUpgrade = FunctionNpcFunc.EquipUpgrade
  self.funcMap.ItemMake = FunctionNpcFunc.ItemMake
  self.funcMap.EquipRecover = FunctionNpcFunc.EquipRecover
  self.funcMap.DoQuench = FunctionNpcFunc.DoQuench
  self.funcMap.DoQuenchIntro = FunctionNpcFunc.DoQuenchIntro
  self.funcMap.DoQuenchGetMat = FunctionNpcFunc.DoQuenchGetMat
  self.funcMap.Exchange = FunctionNpcFunc.Exchange
  self.funcMap.GuildDateBattleRecord = FunctionNpcFunc.GuildDateBattleRecord
  self.funcMap.ChangeGuildLine = FunctionNpcFunc.ChangeGuildLine
  self.funcMap.ChangeGvgLine = FunctionNpcFunc.ChangeGvgLine
  self.funcMap.ReleaseActivity = FunctionNpcFunc.ReleaseActivity
  self.funcMap.GetIceCream = FunctionNpcFunc.GetIceCream
  self.funcMap.GetCdkey = FunctionNpcFunc.GetCdkey
  self.funcMap.FindGM = FunctionNpcFunc.FindGM
  self.funcMap.QuestionSurvey = FunctionNpcFunc.QuestionSurvey
  self.funcMap.QuestActAnswer = FunctionNpcFunc.QuestActAnswer
  self.funcMap.AutumnAdventure = FunctionNpcFunc.AutumnAdventure
  self.funcMap.GetOldConsume = FunctionNpcFunc.GetOldConsume
  self.funcMap.GetAutumnEquip = FunctionNpcFunc.GetAutumnEquip
  self.funcMap.MillionHitThanks = FunctionNpcFunc.MillionHitThanks
  self.funcMap.AppointmentThanks = FunctionNpcFunc.AppointmentThanks
  self.funcMap.ChinaNewYear = FunctionNpcFunc.ChinaNewYear
  self.funcMap.ChangeHairEye = FunctionNpcFunc.ChangeHairEye
  self.funcMap.ChangeClothColor = FunctionNpcFunc.ChangeClothColor
  self.funcMap.GuildPray = FunctionNpcFunc.GuildPray
  self.funcMap.EditHeadText = FunctionNpcFunc.EditHeadText
  self.funcMap.EditDefaultDialog = FunctionNpcFunc.EditDefaultDialog
  self.funcMap.RandomProperty = FunctionNpcFunc.RandomProperty
  self.funcMap.FastClassChange = FunctionNpcFunc.FastClassChange
  self.funcMap.FastChangeClassGetGem = FunctionNpcFunc.FastChangeClassGetGem
  self.funcMap.GetMonsterBatch = FunctionNpcFunc.GetMonsterBatch
  self.funcMap.TransMultiExp = FunctionNpcFunc.TransMultiExp
  self.funcMap.QuestRepair = FunctionNpcFunc.QuestRepair
  self.funcMap.QuestionAnswer = FunctionNpcFunc.QuestionAnswer
  self.funcMap.AlreadyGet = FunctionNpcFunc.AlreadyGet
  self.funcMap.PurifyStake = FunctionNpcFunc.PurifyStake
  if not GameConfig.SystemForbid.GvGPvP_Pray then
    self.funcMap.GvGPvPPray = FunctionNpcFunc.GvGPvpPray
  end
  self.funcMap.DyeCloth = FunctionNpcFunc.DyeCloth
  self.funcMap.GuildBuilding = FunctionNpcFunc.GuildBuilding
  self.funcMap.GetGuildWelfare = FunctionNpcFunc.GetGuildWelfare
  self.funcMap.BuildingSubmitMaterial = FunctionNpcFunc.BuildingSubmitMaterial
  self.funcMap.Safetyrewards = FunctionNpcFunc.Safetyrewards
  self.funcMap.MonthCard = FunctionNpcFunc.MonthCard
  self.funcMap.Opengift = FunctionNpcFunc.Opengift
  self.funcMap.HireCatInfo = FunctionNpcFunc.HireCatInfo
  self.funcMap.HelpGuildChallenge = FunctionNpcFunc.HelpGuildChallenge
  self.funcMap.CardRandomMake = FunctionNpcFunc.CardRandomMake
  self.funcMap.CardMake = FunctionNpcFunc.CardMake
  self.funcMap.Donate = FunctionNpcFunc.Donate
  self.funcMap.CardDecompose = FunctionNpcFunc.CardDecompose
  self.funcMap.Astrolabe = FunctionNpcFunc.Astrolabe
  self.funcMap.Lottery = FunctionNpcFunc.LotteryHeadwear
  self.funcMap.Lottery2 = FunctionNpcFunc.LotteryEquip
  self.funcMap.Lottery3 = FunctionNpcFunc.LotteryCard
  self.funcMap.Lottery_Doll = FunctionNpcFunc.LotteryDoll
  self.funcMap.LotteryMixed = FunctionNpcFunc.LotteryMixed
  self.funcMap.CatLitterBox = FunctionNpcFunc.CatLitterBox
  self.funcMap.MagicLottery = FunctionNpcFunc.LotteryMagic
  self.funcMap.MagicLottery2 = FunctionNpcFunc.LotteryMagicSec
  self.funcMap.MagicLottery3 = FunctionNpcFunc.LotteryMagicThird
  self.funcMap.HeadwearRecovery = FunctionNpcFunc.HeadwearRecovery
  self.funcMap.TestCheck = FunctionNpcFunc.TestCheck
  self.funcMap.ChangeGuildName = FunctionNpcFunc.ChangeGuildName
  self.funcMap.GiveUpGuildLand = FunctionNpcFunc.GiveUpGuildLand
  self.funcMap.GuildLandManage = FunctionNpcFunc.GuildLandManage
  self.funcMap.EquipAlchemy = FunctionNpcFunc.EquipAlchemy
  self.funcMap.EnterCapraActivity = FunctionNpcFunc.EnterCapraActivity
  self.funcMap.ReportPoringFight = FunctionNpcFunc.ReportPoringFight
  self.funcMap.ReportMvpFight = FunctionNpcFunc.ReportMvpFight
  self.funcMap.ReportTransferFight = FunctionNpcFunc.ReportTransferFight
  self.funcMap.JoinRoom = FunctionNpcFunc.JoinRoom
  if not GameConfig.SystemForbid.Auction then
    self.funcMap.AuctionShop = FunctionNpcFunc.AuctionShop
  end
  self.funcMap.OpenGuildFunction = FunctionNpcFunc.OpenGuildFunction
  self.funcMap.OpenGuildChallengeTaskView = FunctionNpcFunc.OpenGuildChallengeTaskView
  self.funcMap.HighRefine = FunctionNpcFunc.HighRefine
  self.funcMap.SewingRefine = FunctionNpcFunc.SewingRefine
  self.funcMap.ArtifactMake = FunctionNpcFunc.ArtifactMake
  self.funcMap.ArtifactDecompose = FunctionNpcFunc.ArtifactDecompose
  self.funcMap.ReturnArtifact = FunctionNpcFunc.ReturnArtifact
  self.funcMap.RetrieveAllArtifacts = FunctionNpcFunc.RetrieveAllArtifacts
  self.funcMap.ServerOpenFunction = FunctionNpcFunc.ServerOpenFunction
  self.funcMap.YoyoSeat = FunctionNpcFunc.YoyoSeat
  self.funcMap.UpJobLevel = FunctionNpcFunc.UpJobLevel
  self.funcMap.WeddingCememony = FunctionNpcFunc.WeddingCememony
  self.funcMap.WeddingDay = FunctionNpcFunc.WeddingDay
  self.funcMap.BookingWedding = FunctionNpcFunc.BookingWedding
  self.funcMap.CancelWedding = FunctionNpcFunc.CancelWedding
  self.funcMap.ConsentDivorce = FunctionNpcFunc.ConsentDivorce
  self.funcMap.UnilateralDivorce = FunctionNpcFunc.UnilateralDivorce
  self.funcMap.GuildHoldTreasure = FunctionNpcFunc.GuildHoldTreasure
  self.funcMap.GuildTreasure = FunctionNpcFunc.GuildTreasure
  self.funcMap.GuildTreasurePreview = FunctionNpcFunc.GuildTreasurePreview
  self.funcMap.EnterRollerCoaster = FunctionNpcFunc.EnterRollerCoaster
  self.funcMap.TakeMarryCarriage = FunctionNpcFunc.TakeMarryCarriage
  self.funcMap.EnterWeddingMap = FunctionNpcFunc.EnterWeddingMap
  self.funcMap.WeddingRingShop = FunctionNpcFunc.WeddingRingShop
  self.funcMap.PveCard_StartFight = FunctionNpcFunc.PveCard_StartFight
  self.funcMap.EquipCompose = FunctionNpcFunc.EquipCompose
  self.funcMap.EnterPoringFight = FunctionNpcFunc.EnterPoringFight
  self.funcMap.HireCatConfirm = FunctionNpcFunc.HireCatConfirm
  self.funcMap.DialogGoddessOfferDead = FunctionNpcFunc.DialogGoddessOfferDead
  self.funcMap.DeathTransfer = FunctionNpcFunc.DeathTransfer
  self.funcMap.CourageRanking = FunctionNpcFunc.CourageRanking
  self.funcMap.GuildDateBattle = FunctionNpcFunc.GuildDateBattle
  self.funcMap.HeadWearStart = FunctionNpcFunc.HeadWearStart
  self.funcMap.ActivityHeadWearStart = FunctionNpcFunc.ActivityHeadWearStart
  self.funcMap.StartRaid = FunctionNpcFunc.StartRaid
  self.funcMap.EnterPveCard = FunctionNpcFunc.EnterPveCard
  self.funcMap.ShowPveCard = FunctionNpcFunc.ShowPveCard
  self.funcMap.OpenKFCShareView = FunctionNpcFunc.OpenKFCShareView
  self.funcMap.SelectPveCard = FunctionNpcFunc.SelectPveCard
  self.funcMap.OpenConcertShareView = FunctionNpcFunc.OpenConcertShareView
  self.funcMap.Browserjump = FunctionNpcFunc.Browserjump
  if not GameConfig.SystemForbid.BossCardCompose then
    self.funcMap.BossCardCompose = FunctionNpcFunc.BossCardCompose
    self.funcMap.MvpCardCompose = FunctionNpcFunc.MvpCardCompose
    self.funcMap.DungeonMvpCardCompose = FunctionNpcFunc.DungeonMvpCardCompose
  end
  self.funcMap.CardUpgrade = FunctionNpcFunc.CardUpgrade
  self.funcMap.GVGPortal = FunctionNpcFunc.OpenGVGPortal
  self.funcMap.EnterAltmanRaid = FunctionNpcFunc.EnterAltmanRaid
  self.funcMap.GetAltmanRankInfo = FunctionNpcFunc.GetAltmanRankInfo
  self.funcMap.SummonDeadBoss = FunctionNpcFunc.SummonDeadBoss
  self.funcMap.SummonDeadBoss2 = FunctionNpcFunc.SummonDeadBoss2
  self.funcMap.SummonDeadBoss3 = FunctionNpcFunc.SummonDeadBoss3
  self.funcMap.SummonDeadBoss4 = FunctionNpcFunc.SummonDeadBoss4
  self.funcMap.SelectTeamPwsEffect = FunctionNpcFunc.SelectTeamPwsEffect
  self.funcMap.GetPveCardReward = FunctionNpcFunc.GetPveCardReward
  self.funcMap.MoroccSeal = FunctionNpcFunc.MoroccSeal
  self.funcMap.BeatPoring = FunctionNpcFunc.BeatBoli
  self.funcMap.ExpRaidShop = FunctionNpcFunc.ExpRaidShop
  self.funcMap.ExpRaidBegin = FunctionNpcFunc.ExpRaidBegin
  self.funcMap.ExpRaidEntrance = FunctionNpcFunc.ExpRaidEntrance
  self.funcMap.ExpPreShop = FunctionNpcFunc.ExpPreShop
  self.funcMap.SpringFestivalRaid = FunctionNpcFunc.SpringFestivalRaid
  self.funcMap.MaidRaidBegin = FunctionNpcFunc.MaidRaidBegin
  self.funcMap.MaidRaidEntrance = FunctionNpcFunc.MaidRaidEntrance
  self.funcMap.DyeCompose = FunctionNpcFunc.DyeCompose
  self.funcMap.ThreeForOne = FunctionNpcFunc.Gem3to1Compose
  self.funcMap.FiveForOne = FunctionNpcFunc.Gem5to1Compose
  self.funcMap.SameForOne = FunctionNpcFunc.GemSameNameCompose
  self.funcMap.GemCarve = FunctionNpcFunc.GemSculpt
  self.funcMap.GemSmelt = FunctionNpcFunc.GemSmelt
  self.funcMap.GemLock = FunctionNpcFunc.GemLock
  self.funcMap.CommonMenuLock = FunctionNpcFunc.CommonMenuLock
  self.funcMap.EvaRaid = FunctionNpcFunc.EvaRaid
  self.funcMap.MountLottery = FunctionNpcFunc.MountLottery
  self.funcMap.ThanatosRaid = FunctionNpcFunc.ThanatosRaid
  self.funcMap.HeadWearRaid = FunctionNpcFunc.HeadwearRaid
  self.funcMap.HeadWearActivity = FunctionNpcFunc.HeadWearActivity
  self.funcMap.HeadWearRaidShop = FunctionNpcFunc.HeadWearRaidShop
  self.funcMap.EnterRoguelike = FunctionNpcFunc.EnterRoguelike
  self.funcMap.SaveRoguelike = FunctionNpcFunc.SaveRoguelike
  self.funcMap.RoguelikeScoreModel = FunctionNpcFunc.RoguelikeScoreModel
  self.funcMap.RoguelikeShop = FunctionNpcFunc.RoguelikeShop
  self.funcMap.RoguelikeRank = FunctionNpcFunc.RoguelikeRank
  self.funcMap.RoguelikeChargeMagicBottle = FunctionNpcFunc.RoguelikeChargeMagicBottle
  self.funcMap.RoguelikeTarot = FunctionNpcFunc.RoguelikeTarot
  self.funcMap.EnterNextRaidGroup = FunctionNpcFunc.EnterNextRaidGroup
  self.funcMap.Prestige_Shop = FunctionNpcFunc.Prestige_Shop
  self.funcMap.HomeEnterEditMode = FunctionNpcFunc.HomeEnterEditMode
  self.funcMap.HomeClearAllFurnitures = FunctionNpcFunc.HomeClearAllFurnitures
  self.funcMap.Astrology = FunctionNpcFunc.Astrology
  self.funcMap.BearRaid = FunctionNpcFunc.BearRaid
  self.funcMap.ChangeRaidGroup = FunctionNpcFunc.ChangeRaidGroup
  self.funcMap.TeampveLog = FunctionNpcFunc.TeampveLog
  self.funcMap.FurnitureShop = FunctionNpcFunc.FurnitureShop
  self.funcMap.EnterThanksgivingRaid = FunctionNpcFunc.EnterThanksgivingRaid
  self.funcMap.OpenLisaShareView = FunctionNpcFunc.OpenLisaShareView
  self.funcMap.AppForward = FunctionNpcFunc.AppForward
  self.funcMap.FourthSkillCostGet = FunctionNpcFunc.FourthSkillCostGet
  self.funcMap.Stake = FunctionNpcFunc.Stake
  self.funcMap.MiniGameEntrance = FunctionNpcFunc.MiniGameEntrance
  self.funcMap.TechTree = FunctionNpcFunc.TechTree
  self.funcMap.TransferFight = FunctionNpcFunc.TransferFightEnter
  self.funcMap.DeadBossRaid = FunctionNpcFunc.DeadBossRaid
  self.funcMap.DeadBossSummon = FunctionNpcFunc.DeadBossSummon
  self.funcMap.BifrostSubmitMaterial = FunctionNpcFunc.BifrostSubmitMaterial
  self.funcMap.GuildLeaderBoard = FunctionNpcFunc.GuildLeaderBoard
  self.funcMap.PlayVideo = FunctionNpcFunc.PlayVideo
  self.funcMap.Einherjar = FunctionNpcFunc.Einherjar
  self.funcMap.SlayersRaid = FunctionNpcFunc.SlayersRaid
  self.funcMap.PersonalEndlessTower = FunctionNpcFunc.PersonalEndlessTower
  self.funcMap.ItemExtract = FunctionNpcFunc.ItemExtract
  self.funcMap.RefineMovement = FunctionNpcFunc.RefineTransfer
  self.funcMap.EnchantMovement = FunctionNpcFunc.EnchantTransfer
  self.funcMap.NewEquipReplace = FunctionNpcFunc.EquipReplaceNew
  self.funcMap.EquipRecovery = FunctionNpcFunc.EquipRecovery
  self.funcMap.EquipRecoveryPlus = FunctionNpcFunc.EquipRecoveryPlus
  self.funcMap.MayPalaceEnter = FunctionNpcFunc.MayPalaceEnter
  self.funcMap.RotateRaidPuzzleObj = FunctionNpcFunc.RotateRaidPuzzleObj
  self.funcMap.InteractTorchObj = FunctionNpcFunc.InteractTorchObj
  self.funcMap.AncientRelicsShop = FunctionNpcFunc.PersonalArtifactShop
  self.funcMap.AncientRelicsCompose = FunctionNpcFunc.PersonalArtifactCompose
  self.funcMap.AncientRelicsRefresh = FunctionNpcFunc.PersonalArtifactRefresh
  self.funcMap.AncientRelicsDecompose = FunctionNpcFunc.PersonalArtifactDecompose
  self.funcMap.AncientRelicsExchange = FunctionNpcFunc.PersonalArtifactExchange
  self.funcMap.VisitLightPuzzleObj = FunctionNpcFunc.VisitLightPuzzleObj
  self.funcMap.DisneyTeam = FunctionNpcFunc.DisneyTeam
  self.funcMap.HolyPray = FunctionNpcFunc.HolyPray
  self.funcMap.CookMaster = FunctionNpcFunc.CookMaster
  self.funcMap.RunGameEnter = FunctionNpcFunc.RunGameEnter
  self.funcMap.ComodoRaid = FunctionNpcFunc.ComodoRaid
  self.funcMap.EnterManorRaid = FunctionNpcFunc.EnterManorRaid
  self.funcMap.PartnerGift = FunctionNpcFunc.PartnerGift
  self.funcMap.ManorBuild = FunctionNpcFunc.ManorBuild
  self.funcMap.ManorMusicBox = FunctionNpcFunc.ManorMusicBox
  self.funcMap.DriftBottle = FunctionNpcFunc.DriftBottle
  self.funcMap.DriftBottlePanel = FunctionNpcFunc.DriftBottlePanel
  self.funcMap.QueryPrice = FunctionNpcFunc.QueryPrice
  self.funcMap.MultiBossRaid = FunctionNpcFunc.MultiBossRaid
  self.funcMap.EnterReturnChatRoom = FunctionNpcFunc.EnterReturnChatRoom
  self.funcMap.SevenRoyalSecrets = FunctionNpcFunc.SevenRoyalSecrets
  self.funcMap.BoliWishing = FunctionNpcFunc.BoliWishing
  self.funcMap.CrackRaid = FunctionNpcFunc.CrackRaid
  self.funcMap.CardLottery = FunctionNpcFunc.CardLottery
  self.funcMap.ChangeAvatar = FunctionNpcFunc.ChangeAvatar
  self.funcMap.ChangeAction = FunctionNpcFunc.ChangeAction
  self.funcMap.PresidentRule = FunctionNpcFunc.PresidentRule
  self.funcMap.CardLottery = FunctionNpcFunc.CardLottery
  self.funcMap.FirstTransferProfession = FunctionNpcFunc.FirstTransferProfession
  self.funcMap.GuildRaid = FunctionNpcFunc.GuildRaid
  self.funcMap.OpenSandTable = FunctionNpcFunc.OpenSandTable
  self.funcMap.TimeQuicksand = FunctionNpcFunc.ExchangeSand
  self.funcMap.GvGCooking = FunctionNpcFunc.GvGCooking
  self.funcMap.ViewFashionUnlockCount = FunctionNpcFunc.ViewFashionUnlockCount
  self.funcMap.MountDressing = FunctionNpcFunc.OpenMountDressingView
  self.funcMap.AierBlacksmith = FunctionNpcFunc.AierBlacksmith
  self.funcMap.AierBlacksmithRandomTalk = FunctionNpcFunc.AierBlacksmithRandomTalk
  self.funcMap.PhotoBoardMyPost = FunctionNpcFunc.PhotoBoardMyPost
  self.funcMap.GVGRoadBlock = FunctionNpcFunc.GVGRoadBlock
  self.funcMap.SpecialSkillUpgrade = FunctionNpcFunc.OpenSpecialSkillUpgradeView
  self.funcMap.ShowPrestigeInfo = FunctionNpcFunc.ShowPrestigeInfo
  self.funcMap.BatteryCannon = FunctionNpcFunc.BatteryCannon
  self.funcMap.GiftCard = FunctionNpcFunc.GiftCard
  self.funcMap.LaunchFirework = FunctionNpcFunc.LaunchFirework
  self.funcMap.RemoveFirework = FunctionNpcFunc.RemoveFirework
  self.funcMap.OpenPveMonsterPopup = FunctionNpcFunc.OpenPveMonsterPopup
  self.funcMap.EnterBigCatInvadeActivity = FunctionNpcFunc.EnterBigCatInvadeActivity
  self.funcMap.ExchangeGift = FunctionNpcFunc.ExchangeGift
  self.funcMap.ReceiveTripleTeamPwsTargetReward = FunctionNpcFunc.ReceiveTripleTeamPwsTargetReward
  self.funcMap.ReceiveTripleTeamPwsRankReward = FunctionNpcFunc.ReceiveTripleTeamPwsRankReward
  self.funcMap.AstralRaidNextLevel = FunctionNpcFunc.AstralRaidNextLevel
  self.funcMap.AstralRaidExitRaid = FunctionNpcFunc.AstralRaidExitRaid
  self.funcMap.OpenAstralDestinyGraph = FunctionNpcFunc.OpenAstralDestinyGraph
  self.funcMap.CraftingPot = FunctionNpcFunc.CraftingPot
  self.funcMap.OpenRankPop = FunctionNpcFunc.OpenRankPop
  self.funcMap.OpenCupModeView = FunctionNpcFunc.OpenCupModeView
  self.funcMap.ChangePVPAvatar = FunctionNpcFunc.ChangePVPAvatar
  self.funcMap.ChangePVPAction = FunctionNpcFunc.ChangePVPAction
  self.funcMap.ChangeMaterial = FunctionNpcFunc.ChangeMaterial
  self.funcMap.ReceiveTeamPwsTargetReward = FunctionNpcFunc.ReceiveTeamPwsTargetReward
  self.funcMap.ReceiveTeamPwsTargetRewardMix = FunctionNpcFunc.ReceiveTeamPwsTargetRewardMix
  self.funcMap.ReceiveTwelveTargetReward = FunctionNpcFunc.ReceiveTwelveTargetReward
  self.funcMap.ReceiveTwelveTargetRewardMix = FunctionNpcFunc.ReceiveTwelveTargetRewardMix
  self.funcMap.PresidentPvpRule = FunctionNpcFunc.PresidentPvpRule
  self.funcMap.OpenAbyssQuestBoard = FunctionNpcFunc.OpenAbyssQuestBoard
  self.funcMap.OpenInheritSkillView = FunctionNpcFunc.OpenInheritSkillView
  self.funcMap.OpenInheritSkillExtendCostPointPopUp = FunctionNpcFunc.OpenInheritSkillExtendCostPointPopUp
  self.funcMap.OpenAchieveRewardView = FunctionNpcFunc.OpenAchieveRewardView
  self.checkMap.CreateGuild = FunctionNpcFunc.CheckCreateGuild
  self.checkMap.ApplyGuild = FunctionNpcFunc.CheckCreateGuild
  self.checkMap.QuickTeam = FunctionNpcFunc.CheckQuickTeam
  self.checkMap.ExitGuild = FunctionNpcFunc.CheckExitGuild
  self.checkMap.OpenGuildRaid = FunctionNpcFunc.CheckOpenGuildRaid
  self.checkMap.ReadyToGuildRaid = FunctionNpcFunc.CheckOpenGuildRaid
  self.checkMap.LaboratoryTeam = FunctionNpcFunc.CheckLaboratoryTeam
  self.checkMap.DojoTeam = FunctionNpcFunc.CheckDojoTeam
  self.checkMap.EndLessTeam = FunctionNpcFunc.CheckEndLessTeam
  self.checkMap.Astrolabe = FunctionNpcFunc.CheckAstrolabe
  self.checkMap.GetOldConsume = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.GetAutumnEquip = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.GetIceCream = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.MillionHitThanks = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.AppointmentThanks = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.ChinaNewYear = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.MonthCard = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.GiveUpGuildLand = FunctionNpcFunc.CheckGiveUpGuildLand
  self.checkMap.BuildingSubmitMaterial = FunctionNpcFunc.CheckOpenBuildingSubmitMat
  self.checkMap.CatLitterBox = FunctionNpcFunc.CheckCatLitterBox
  self.checkMap.GuildStoreCat = FunctionNpcFunc.CheckGuildStoreAuto
  self.checkMap.GuildStoreAuto = FunctionNpcFunc.CheckStoreAuto
  self.checkMap.SewingRefine = FunctionNpcFunc.CheckSewing
  self.checkMap.SewingStrengthen = FunctionNpcFunc.CheckSewing
  self.checkMap.OpenGuildFunction = FunctionNpcFunc.CheckOpenGuildFunction
  self.checkMap.OpenGuildChallengeTaskView = FunctionNpcFunc.CheckOpenGuildChallengeTaskView
  self.checkMap.HighRefine = FunctionNpcFunc.CheckHighRefine
  self.checkMap.ArtifactMake = FunctionNpcFunc.CheckArtifactMake
  self.checkMap.ArtifactDecompose = FunctionNpcFunc.CheckArtifactDecompose
  self.checkMap.WeddingDay = FunctionNpcFunc.CheckWeddingDay
  self.checkMap.BookingWedding = FunctionNpcFunc.CheckBookingWedding
  self.checkMap.CancelWedding = FunctionNpcFunc.CheckCancelWedding
  self.checkMap.WeddingCememony = FunctionNpcFunc.CheckWeddingCememony
  self.checkMap.ConsentDivorce = FunctionNpcFunc.CheckConsentDivorce
  self.checkMap.UnilateralDivorce = FunctionNpcFunc.CheckUnilateralDivorce
  self.checkMap.GuildHoldTreasure = FunctionNpcFunc.CheckGuildHoldTreasure
  self.checkMap.EnterRollerCoaster = FunctionNpcFunc.CheckEnterRollerCoaster
  self.checkMap.EnterWeddingMap = FunctionNpcFunc.CheckEnterWeddingMap
  self.checkMap.TakeMarryCarriage = FunctionNpcFunc.CheckTakeMarryCarriage
  self.checkMap.PveCard_StartFight = FunctionNpcFunc.CheckEnterPveCard
  self.checkMap.ShowPveCard = FunctionNpcFunc.CheckShowPveCard
  self.checkMap.GvgLand = FunctionNpcFunc.CheckGvgLand
  self.checkMap.ChangeClothColor = FunctionNpcFunc.CheckChangeClothColor
  self.checkMap.EnterCapraActivity = FunctionNpcFunc.CheckEnterCapraActivity
  self.checkMap.EquipCompose = FunctionNpcFunc.CheckEquipCompose
  self.checkMap.AncientRelicsShop = FunctionNpcFunc.CheckAncientRelicsShop
  self.checkMap.HireCatConfirm = FunctionNpcFunc.CheckHireCatConfirm
  self.checkMap.SummonDeadBoss = FunctionNpcFunc.CheckSummonDeadBoss
  self.checkMap.SummonDeadBoss2 = FunctionNpcFunc.CheckSummonDeadBoss2
  self.checkMap.SummonDeadBoss3 = FunctionNpcFunc.CheckSummonDeadBoss3
  self.checkMap.SummonDeadBoss4 = FunctionNpcFunc.CheckSummonDeadBoss4
  self.checkMap.SelectTeamPwsEffect = FunctionNpcFunc.CheckSelectTeamPwsEffect
  self.checkMap.ExpRaidShop = FunctionNpcFunc.CheckExpRaid
  self.checkMap.ExpRaidBegin = FunctionNpcFunc.CheckExpRaid
  self.checkMap.EnterNextRaidGroup = FunctionNpcFunc.CheckEnterNextRaidGroup
  self.checkMap.Prestige_Shop = FunctionNpcFunc.CheckPrestige_Shop
  self.checkMap.HomeEnterEditMode = FunctionNpcFunc.CheckAtMyselfHome
  self.checkMap.HomeClearAllFurnitures = FunctionNpcFunc.CheckHomeClearAllFurnitures
  self.checkMap.ThreeForOne = FunctionNpcFunc.CheckGem3to1
  self.checkMap.FiveForOne = FunctionNpcFunc.CheckGem5to1
  self.checkMap.SameForOne = FunctionNpcFunc.CheckGemSameName
  self.checkMap.GemCarve = FunctionNpcFunc.CheckGemCarve
  self.checkMap.GemSmelt = FunctionNpcFunc.CheckGem
  self.checkMap.CommonMenuLock = FunctionNpcFunc.CheckCommonMenuLock
  self.checkMap.ChangeHairEye = FunctionNpcFunc.CheckHairEye
  self.checkMap.HeadWearStart = FunctionNpcFunc.CheckHeadWearStart
  self.checkMap.ReturnArtifact = FunctionNpcFunc.CheckReturnArtifact
  self.checkMap.RetrieveAllArtifacts = FunctionNpcFunc.CheckRetrieveAllArtifacts
  self.checkMap.GuildPray = FunctionNpcFunc.CheckPray
  self.checkMap.GvGPvPPray = FunctionNpcFunc.CheckBless
  self.checkMap.HolyPray = FunctionNpcFunc.CheckHolyBless
  self.checkMap.ActivityHeadWearStart = FunctionNpcFunc.CheckHeadWearStart
  self.checkMap.DisneyTeam = FunctionNpcFunc.CheckDisneyTeam
  self.checkMap.FirstTransferProfession = FunctionNpcFunc.CheckFirstTransferProfession
  self.checkMap.TechTree = FunctionNpcFunc.CheckTechTree
  self.checkMap.EditHeadText = FunctionNpcFunc.CheckEditHeadText
  self.checkMap.EditDefaultDialog = FunctionNpcFunc.CheckEditDefaultDialog
  self.checkMap.DeadBossSummon = FunctionNpcFunc.CheckDeadBossSummon
  self.checkMap.BifrostSubmitMaterial = FunctionNpcFunc.CheckBifrostSubmitMaterial
  self.checkMap.PersonalEndlessTower = FunctionNpcFunc.CheckPersonalEndlessTower
  self.checkMap.DriftBottlePanel = FunctionNpcFunc.CheckDriftBottlePanel
  self.checkMap.VisitLightPuzzleObj = FunctionNpcFunc.CheckVisitLightPuzzleObj
  self.checkMap.CookMaster = FunctionNpcFunc.CheckCookMaster
  self.checkMap.RunGameEnter = FunctionNpcFunc.CheckRunGameEnter
  self.checkMap.EnterManorRaid = FunctionNpcFunc.CheckEnterManorRaid
  self.checkMap.PartnerGift = FunctionNpcFunc.CheckPartnerGift
  self.checkMap.Donate = FunctionNpcFunc.CheckDonate
  self.checkMap.GetGuildWelfare = FunctionNpcFunc.CheckGetGuildWelfare
  self.checkMap.DirectPassFunc = FunctionNpcFunc.CheckDirectPassFunc
  self.checkMap.EquipRecovery = FunctionNpcFunc.CheckEquipRecovery
  self.checkMap.EquipRecoveryPlus = FunctionNpcFunc.CheckEquipRecoveryPlus
  self.checkMap.ChangeAvatar = FunctionNpcFunc.CheckOptStatue
  self.checkMap.ChangeAction = FunctionNpcFunc.CheckOptStatue
  self.checkMap.PresidentRule = FunctionNpcFunc.CheckOptStatue
  self.checkMap.OpenSandTable = FunctionNpcFunc.CheckOpenSandTable
  self.checkMap.DoQuench = FunctionNpcFunc.CheckDoQuench
  self.checkMap.MountDressing = FunctionNpcFunc.CheckOpenMountDressingView
  self.checkMap.AierBlacksmith = FunctionNpcFunc.CheckAierBlacksmith
  self.checkMap.GVGRoadBlock = FunctionNpcFunc.CheckGVGRoadBlock
  self.checkMap.BatteryCannon = FunctionNpcFunc.CheckBatteryCannon
  self.checkMap.ShowPrestigeInfo = FunctionNpcFunc.CheckShowPrestigeInfo
  self.checkMap.StartRaid = FunctionNpcFunc.CheckStartRaid
  self.checkMap.SpecialSkillUpgrade = FunctionNpcFunc.CheckOpenSpecialSkillUpgradeView
  self.checkMap.LaunchFirework = FunctionNpcFunc.CheckLaunchFirework
  self.checkMap.RemoveFirework = FunctionNpcFunc.CheckRemoveFirework
  self.checkMap.OpenPveMonsterPopup = FunctionNpcFunc.CheckOpenPveMonsterPopup
  self.checkMap.EnterBigCatInvadeActivity = FunctionNpcFunc.CheckEnterBigCatInvadeActivity
  self.checkMap.QueryPrice = FunctionNpcFunc.CheckQueryPrice
  self.checkMap.ReceiveTripleTeamPwsTargetReward = FunctionNpcFunc.CheckReceiveTripleTeamPwsTargetReward
  self.checkMap.ReceiveTripleTeamPwsRankReward = FunctionNpcFunc.CheckReceiveTripleTeamPwsRankReward
  self.checkMap.AstralRaidNextLevel = FunctionNpcFunc.CheckAstralRaidNextLevel
  self.checkMap.OpenAstralDestinyGraph = FunctionNpcFunc.CheckAstralDestinyGraph
  self.checkMap.ChangePVPAvatar = FunctionNpcFunc.CheckPVPOptStatue
  self.checkMap.ChangePVPAction = FunctionNpcFunc.CheckPVPOptStatue
  self.checkMap.ChangeMaterial = FunctionNpcFunc.CheckPVPOptStatue
  self.checkMap.ReceiveTeamPwsTargetReward = FunctionNpcFunc.CheckCanReceiveTeamPwsTargetReward
  self.checkMap.ReceiveTeamPwsTargetRewardMix = FunctionNpcFunc.CheckCanReceiveTeamPwsTargetRewardMix
  self.checkMap.ReceiveTwelveTargetReward = FunctionNpcFunc.CheckCanReceiveTwelveTargetReward
  self.checkMap.ReceiveTwelveTargetRewardMix = FunctionNpcFunc.CheckCanReceiveTwelveTargetRewardMix
  if not GameConfig.SystemForbid.BossCardCompose then
    self.checkMap.DungeonMvpCardCompose = FunctionNpcFunc.CheckDungeonMvpCardCompose
  end
  self.checkMap.OpenAbyssQuestBoard = FunctionNpcFunc.CheckOpenAbyssQuestBoard
  self.checkMap.OpenInheritSkillView = FunctionNpcFunc.CheckOpenInheritSkillView
  self.checkMap.CardUpgrade = FunctionNpcFunc.CheckCardUpgrade
  self.checkMap.OpenInheritSkillExtendCostPointPopUp = FunctionNpcFunc.CheckOpenInheritSkillExtendCostPointPopUp
  self.updateCheckCache = {}
end

function FunctionNpcFunc:PreprocessNpcFunctionConfig(handles)
  local configs = Table_NpcFunction
  local handle
  for k, config in pairs(configs) do
    handle = handles[config.Type]
    if handle ~= nil then
      self.funcMap[config.NameEn] = handle
    end
  end
end

function FunctionNpcFunc:PreprocessNpcFuncCheckConfig(handles)
  local handle
  for k, config in pairs(Table_NpcFunction) do
    handle = handles[config.Type]
    if handle ~= nil then
      self.checkMap[config.NameEn] = handle
    end
  end
end

function FunctionNpcFunc:DoNpcFunc(npcFunctionData, lnpc, param, endfunc)
  if npcFunctionData == nil then
    return
  end
  local event = self:getFunc(npcFunctionData.id)
  if not event then
    return
  end
  lnpc = lnpc or FunctionVisitNpc.Me():GetTarget()
  if npcFunctionData.id == 5001 or npcFunctionData.id == 5000 then
    FunctionSecurity.Me():TryDoRealNameCentify(function()
      event(lnpc, param, npcFunctionData)
    end)
    return
  end
  return event(lnpc, param, npcFunctionData, endfunc)
end

function FunctionNpcFunc.checkNPCValid(npc_uniqueid)
  local funcStateId = GameConfig.FuncStateMiniMapForbid[npc_uniqueid]
  if funcStateId then
    return FunctionUnLockFunc.checkFuncStateValid(funcStateId)
  else
    return true
  end
end

function FunctionNpcFunc:GetConfigByKey(key)
  for _, config in pairs(Table_NpcFunction) do
    if key == config.NameEn then
      return config
    end
  end
end

function FunctionNpcFunc:getFunc(id)
  local config = Table_NpcFunction[id]
  return config and self.funcMap[config.NameEn]
end

function FunctionNpcFunc:CheckFuncState(key, npcdata, param, funcStaticId)
  if not key then
    return
  end
  local updateCheckState = self:AddUpdateCheckFunc(key, npcdata.data.id, param)
  if updateCheckState ~= nil then
    return updateCheckState
  end
  if self.checkMap[key] then
    return self.checkMap[key](npcdata, param, funcStaticId)
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc:AddUpdateCheckFunc(key, npcguid, param)
  local func = self.updateCheckMap[key]
  if func == nil then
    return
  end
  local state, name = func(npcguid, param)
  self.updateCheckCache[key] = {
    key = key,
    state = state,
    name = name,
    npcguid = npcguid,
    param = param
  }
  if self.updateCheck_Tick == nil then
    self.updateCheck_Tick = TimeTickManager.Me():CreateTick(0, 1000, self._updateCheckFunc, self, 1)
  end
  return state, name
end

local stateChangeFuncs = {}

function FunctionNpcFunc:_updateCheckFunc()
  TableUtility.ArrayClear(stateChangeFuncs)
  for key, cache in pairs(self.updateCheckCache) do
    local newV, newName = self.updateCheckMap[key](cache.npcguid, cache.param)
    if newV ~= cache.state then
      cache.state, cache.name = newV, newName
      table.insert(stateChangeFuncs, cache)
    end
  end
  if 0 < #stateChangeFuncs then
    GameFacade.Instance:sendNotification(DialogEvent.NpcFuncStateChange, stateChangeFuncs)
  end
end

function FunctionNpcFunc:RemoveUpdateCheckTick()
  if self.updateCheck_Tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateCheck_Tick = nil
  end
end

function FunctionNpcFunc:RemoveUpdateCheck(key)
  self.updateCheckCache[key] = nil
  if next(self.updateCheckCache) == nil then
    self:RemoveUpdateCheckTick()
  end
end

function FunctionNpcFunc:ClearUpdateCheck()
  TableUtility.TableClear(self.updateCheckCache)
  self:RemoveUpdateCheckTick()
end

local npcFuncIdViewNameMap = {
  [800] = "SmilingLadyShop",
  [3302] = "GemShopView",
  [9101] = "HeadWearRaidShop"
}
local Items4EpicEquipMerchantShowRandomPreview = {
  6820,
  6821,
  6884,
  6885
}

function FunctionNpcFunc.TypeFunc_Shop(nnpc, params, npcFunctionData, exitCall, exitCallParam)
  local fId, fName, parama = npcFunctionData.id, npcFunctionData.NameEn, npcFunctionData.Parama
  if fName == "BcatGoldShop" then
    NewRechargeProxy.Ins:SetShopID(params)
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TShop, FunctionNewRecharge.InnerTab.Shop_Normal1)
  elseif fName == "RechargeShop" then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TShop, FunctionNewRecharge.InnerTab.Shop_Recommend)
  elseif fName == "EpicEquipMerchant" then
    HappyShopProxy.Instance:InitShop(nnpc, params, fId)
    local useRandomPreview = false
    if parama and parama.ItemID and type(parama.ItemID) == "table" then
      for i = 1, #parama.ItemID do
        if TableUtility.ArrayFindIndex(Items4EpicEquipMerchantShowRandomPreview, parama.ItemID[i]) > 0 then
          useRandomPreview = true
          break
        end
      end
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.EquipConvertView, {
      npcdata = nnpc,
      onExit = exitCall,
      onExitParam = exitCallParam,
      useRandomPreview = useRandomPreview
    })
  elseif parama.ShowType and parama.ShowType == 1 then
    local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
    local servantShopMap = HappyShopProxy.Instance:GetServantShopMap()
    if myServantid and servantShopMap then
      local initCFG = servantShopMap[myServantid]
      local npcStaticid = nnpc and nnpc.data and nnpc.data.staticData and nnpc.data.staticData.id or 0
      if initCFG and npcStaticid == 0 then
        HappyShopProxy.Instance:InitShop(nnpc, initCFG.param, initCFG.type)
        FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
          npcdata = nnpc,
          onExit = exitCall,
          onExitParam = exitCallParam
        })
      else
        HappyShopProxy.Instance:InitShop(nnpc, params, fId)
        FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
          npcdata = nnpc,
          onExit = exitCall,
          onExitParam = exitCallParam
        })
      end
    end
  else
    HappyShopProxy.Instance:InitShop(nnpc, params, fId)
    local viewName = npcFuncIdViewNameMap[fId] or "HappyShop"
    FunctionNpcFunc.JumpPanel(PanelConfig[viewName], {
      npcdata = nnpc,
      onExit = exitCall,
      onExitParam = exitCallParam
    })
  end
end

function FunctionNpcFunc.TypeFunc_NotifyServer(nnpc, param, npcFunctionData)
  ServiceUserEventProxy.Instance:CallTrigNpcFuncUserEvent(nnpc.data.id, npcFunctionData.id)
end

local CheckCanOpenGuildGate = function()
  local staticNpcId, config = next(GameConfig.GuildRaid)
  if staticNpcId then
    local myGuildLv = GuildProxy.Instance.myGuildData.level
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if myGuildLv < config.GuildLevel then
      MsgManager.ShowMsgByID(28044, config.GuildLevel)
      return false
    end
    if mylv < config.UserLevel then
      MsgManager.ShowMsgByID(7301, config.UserLevel)
      return false
    end
  end
  return true
end

function FunctionNpcFunc.TypeFunc_GuildRaid(nnpc, param, npcFunctionData)
  if npcFunctionData.NameEn == "OpenGuildGate" then
    if not CheckCanOpenGuildGate() then
      return
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.GuildFubenGateView)
    return
  end
  if npcFunctionData.NameEn == "Unlock" then
    local chooselevel = npcFunctionData.Parama[1]
    local npcid = nnpc.data.staticData.id
    local unlockConfig = GameConfig.GuildRaid[npcid]
    local costTip = ""
    for i = 1, #unlockConfig.UnlockItem do
      local cfg = unlockConfig.UnlockItem[i]
      if cfg and cfg[1] and cfg[2] then
        local itemCfg = Table_Item[cfg[1]]
        if itemCfg then
          costTip = costTip .. itemCfg.NameZh .. cfg[2]
        end
      end
    end
    local unlockText = string.format(ZhString.FunctionNpcFunc_UnlockTip, chooselevel, costTip)
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {unlockText},
      npcinfo = nnpc
    }
    viewdata.addfunc = {}
    viewdata.addfunc[1] = {
      event = function()
        ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_UNLOCK, chooselevel)
      end,
      closeDialog = true,
      NameZh = ZhString.FunctionNpcFunc_Unlock
    }
    viewdata.addfunc[2] = {
      event = function()
        return true
      end,
      NameZh = ZhString.FunctionNpcFunc_Cancel
    }
    FunctionNpcFunc.ShowUI(viewdata)
  elseif npcFunctionData.NameEn == "Open" then
    ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_OPEN)
  elseif npcFunctionData.NameEn == "Enter" then
    local gateInfo = GuildProxy.Instance:GetGuildGateInfoByNpcId(nnpc.data.id)
    if gateInfo and gateInfo.state == Guild_GateState.Open then
      ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_ENTER)
    else
      MsgManager.ShowMsgByIDTable(7202)
    end
  end
end

function FunctionNpcFunc.TypeFunc_InvitethePersonoflove(nnpc, param, npcFunctionData)
  local parama = npcFunctionData.Parama
  local data = Table_DateLand[parama.id]
  local hasTicket = false
  if not data.ticket_item or #data.ticket_item == 0 then
    hasTicket = true
  else
    for i = 1, #data.ticket_item do
      local item = BagProxy.Instance:GetItemByStaticID(data.ticket_item[i])
      if item ~= nil then
        hasTicket = true
      end
    end
  end
  if hasTicket == false then
    MsgManager.ShowMsgByID(parama.msgId, data.Name)
    return
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      parama.dialog
    },
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.TypeFunc_AboutDateLand(nnpc, param, npcFunctionData)
  local parama = npcFunctionData.Parama
  MsgManager.DontAgainConfirmMsgByID(parama.msgId)
end

function FunctionNpcFunc.TypeFunc_Augury(nnpc, param, npcFunctionData)
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  if isHandFollow == false and Game.Myself:Client_GetHandInHandFollower() == 0 then
    MsgManager.ShowMsgByID(927)
    return
  end
  local parama = npcFunctionData.Parama
  ServiceSceneAuguryProxy.Instance:CallAuguryInvite(nil, nil, nnpc.data.id, parama.type)
  local dialog = DialogUtil.GetDialogData(GameConfig.Augury.WaitWord)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      dialog.Text
    },
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.TypeFunc_AboutAugury(nnpc, param, npcFunctionData)
  local parama = npcFunctionData.Parama
  if type(parama.helpId) == "number" then
    local data = Table_Help[parama.helpId]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
    end
  elseif type(parama.helpId) == "table" and #parama.helpId > 0 then
    if #parama.helpId == 1 then
      local data = Table_Help[parama.helpId[1]]
      if data then
        TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
      end
    else
      local tip_data = {}
      for i = 1, #parama.helpId do
        local staticData = Table_Help[parama.helpId[i]]
        if staticData then
          tip_data[#tip_data + 1] = staticData
        else
          redlog("Help表未配置ID： ", parama.helpId[i])
        end
      end
      if nil ~= next(tip_data) then
        TipsView.Me():ShowMultiGeneralHelp(tip_data)
      end
    end
  end
end

function FunctionNpcFunc.TypeFunc_Hyperlink(nnpc, param, npcFunctionData)
  local funcParam = npcFunctionData.Parama
  if funcParam.url then
    ApplicationInfo.OpenUrl(funcParam.url)
  end
end

function FunctionNpcFunc.TypeFunc_ShortCut(nnpc, param, npcFunctionData)
  if npcFunctionData.Parama and npcFunctionData.Parama.shortcutid then
    FuncShortCutFunc.Me():CallByID(npcFunctionData.Parama.shortcutid)
  end
end

function FunctionNpcFunc.Astrolabe(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.AstrolabeView, {npcdata = nnpc})
end

function FunctionNpcFunc.LotteryMixed(nnpc, params, npcFunctionData)
  FunctionLottery.Me():OpenNewLotteryByType(params)
end

function FunctionNpcFunc.LotteryHeadwear(nnpc, param, npcFunctionData)
  FunctionLottery.Me():OpenNewLotteryByType(SceneItem_pb.ELotteryType_Head)
end

function FunctionNpcFunc.LotteryEquip(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryEquipView, {npcdata = nnpc})
end

function FunctionNpcFunc.LotteryCard(nnpc, param, npcFunctionData)
  FunctionLottery.Me():OpenNewLotteryByType(SceneItem_pb.ELotteryType_Card)
end

function FunctionNpcFunc.CatLitterBox(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.CatLitterBoxView, {npcdata = nnpc})
end

function FunctionNpcFunc.LotteryMagic(nnpc, param, npcFunctionData)
  FunctionLottery.Me():OpenNewLotteryByType(SceneItem_pb.ELotteryType_Magic)
end

function FunctionNpcFunc.LotteryMagicSec(nnpc, param, npcFunctionData)
  FunctionLottery.Me():OpenNewLotteryByType(SceneItem_pb.ELotteryType_Magic_2)
end

function FunctionNpcFunc.LotteryMagicThird(nnpc, param, npcFunctionData)
  FunctionLottery.Me():OpenNewLotteryByType(SceneItem_pb.ELotteryType_Magic_3)
end

function FunctionNpcFunc.LotteryDoll(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryDollView, {npcdata = nnpc})
end

function FunctionNpcFunc.HeadwearRecovery(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.HeadWearRecoverView, {npcdata = nnpc})
end

function FunctionNpcFunc.Oversea_PlayersRecall(nnpc, param, npcFunctionData)
  local funcParam = npcFunctionData.Parama
  if funcParam.url then
    local accid = FunctionGetIpStrategy.Me():getAccId()
    local lang = AppBundleConfig.GetSDKLang()
    local isreferee = param and param.isreferee or "false"
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.serverid or 1
    local url = string.format(funcParam.url, accid, lang, isreferee, serverID, BranchMgr.GetBranchName())
    redlog("url === ", url)
    local resVersion = VersionUpdateManager.CurrentVersion
    if resVersion == nil then
      resVersion = "Unknown"
    end
    local currentVersion = CompatibilityVersion.version
    local bundleVersion = GetAppBundleVersion.BundleVersion
    version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
    if ApplicationInfo.IsWindows() or ApplicationInfo.IsRunOnEditor() then
      Application.OpenURL(url)
    else
      FunctionSDK.Instance:EnterBugReport(serverID, OverSeaFunc.GetZenDeskInfo(), version)
    end
  end
end

function FunctionNpcFunc.Close()
  return false
end

function FunctionNpcFunc.DefeatBoss(nnpc, params)
  local hasAccepted = QuestProxy.Instance:hasQuestAccepted(params)
  if hasAccepted then
    MsgManager.ShowMsgByID(704)
  else
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, params)
  end
end

function FunctionNpcFunc.QueryDefeatBossTime(nnpc, params)
  local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
  local count = 0
  local curCount = 0
  if dailyData then
    count = dailyData.param1
    curCount = dailyData.param2
  end
  local unCount = count - curCount
  local str = string.format(ZhString.NpcFun_DefeatBossCount, curCount, unCount)
  local dialoglist = {str}
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.storehouse(nnpc, params)
  if MyselfProxy.Instance:GetROB() < GameConfig.System.warehouseZeny and BagProxy.Instance:GetItemNumByStaticID(GameConfig.Item.store_item) < 1 then
    MsgManager.ShowMsgByIDTable(1)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.RepositoryView, {npcdata = nnpc})
end

function FunctionNpcFunc.Transfer(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.CharactorProfession, {npcdata = nnpc})
end

function FunctionNpcFunc.Refine(nnpc, params, funcConfig, isFromBag)
  if not FunctionUnLockFunc.Me():CheckCanOpen(4) then
    MsgManager.ShowMsgByIDTable(43191)
    return
  end
  local isfashion = params and params.isfashion
  if isfashion then
    FunctionNpcFunc.JumpPanel(PanelConfig.EquipIntegrateView, {
      npcdata = nnpc,
      index = 2,
      isfashion = true,
      isFromBag = isFromBag,
      selectTicket = params and params.selectTicket
    })
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.EquipIntegrateView, {
      npcdata = nnpc,
      index = 2,
      isFromBag = isFromBag,
      OnClickChooseBordCell_data = params and params.OnClickChooseBordCell_data,
      selectTicket = params and params.selectTicket
    })
  end
end

function FunctionNpcFunc.RandomProperty(nnpc, params, funcConfig, isFromBag)
  if GameConfig.SystemForbid.RandomAttrRefresh then
    return
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(4) then
    MsgManager.ShowMsgByIDTable(43191)
    return
  end
  if type(params) == "number" then
    params = nil
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.AncientRandomCombineView, {
    npcdata = nnpc,
    index = 1,
    isFromBag = isFromBag,
    OnClickChooseBordCell_data = params and params.OnClickChooseBordCell_data
  })
end

function FunctionNpcFunc.AncientUpgrade(nnpc, params, funcConfig, isFromBag)
  if GameConfig.SystemForbid.AncientUpgrade then
    return
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(4) then
    MsgManager.ShowMsgByIDTable(43191)
    return
  end
  if type(params) == "number" then
    params = nil
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.AncientRandomCombineView, {
    npcdata = nnpc,
    index = 2,
    isFromBag = isFromBag,
    OnClickChooseBordCell_data = params and params.OnClickChooseBordCell_data
  })
end

function FunctionNpcFunc.Transmit(nnpc, params)
  printRed("竞技场传送~")
end

function FunctionNpcFunc.EndLessTower(nnpc, params)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.InfiniteTower)
end

function FunctionNpcFunc.CrackRaid(nnpc, params, npcFunctionData)
  local groupid = npcFunctionData and npcFunctionData.Parama and npcFunctionData.Parama.GroupId
  if groupid then
    PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.Crack, groupid)
  else
    redlog("裂隙副本 没有配置GroupId")
  end
end

function FunctionNpcFunc.EndLessTeam(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc})
  elseif FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id) then
    local target = params
    if not target then
      local config = FunctionNpcFunc.Me():GetConfigByKey("EndLessTeam")
      if config.Parama.teamGoal then
        target = config.Parama.teamGoal
      end
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = target})
  end
end

function FunctionNpcFunc.Repair(nnpc, params)
end

function FunctionNpcFunc.DeCompose(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipRecoverCombinedView, {
    npcdata = nnpc,
    params = params,
    index = 2
  })
end

function FunctionNpcFunc.Laboratory(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    if TeamProxy.Instance:ForbiddenByRaidType(FuBenCmd_pb.ERAIDTYPE_LABORATORY) then
      MsgManager.ShowMsgByID(42042)
      return
    end
    if not TeamProxy.Instance:CheckMatchTypeSupportDiffServer(MatchCCmd_pb.EPVPTYPE_LABORATORY) then
      MsgManager.ShowMsgByID(42042)
      return
    end
    local funcid
    for _, funcCfg in pairs(Table_NpcFunction) do
      if funcCfg.NameEn == "Laboratory" then
        funcid = funcCfg.id
        break
      end
    end
    ServiceNUserProxy.Instance:CallGotoLaboratoryUserCmd(funcid)
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.InstituteChallenge_notTeam)
  end
end

function FunctionNpcFunc.LaboratoryTeam(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc})
  elseif FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id) then
    local target = params
    if not target then
      local config = FunctionNpcFunc.Me():GetConfigByKey("LaboratoryTeam")
      if config.Parama.teamGoal then
        target = config.Parama.teamGoal
      end
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = target})
  end
end

function FunctionNpcFunc.LaboratoryShop(nnpc, params)
  HappyShopProxy.Instance:SetNPC(nnpc)
  HappyShopProxy.Instance:SetParams(params)
  local npcFunction = nnpc.npcData.NpcFunction
  local shopType = 800
  if npcFunction ~= nil then
    for _, v in pairs(npcFunction) do
      local param = v.param
      if param and param == params then
        shopType = v.type
      end
    end
  end
  FuncLaboratoryShop.Instance():OpenUI(shopType, params)
end

function FunctionNpcFunc.Sell(nnpc, params)
  if params == nil then
    params = 1
  end
  ShopSaleProxy.Instance:SetParams(params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ShopSale, {npcdata = nnpc, params = params})
end

function FunctionNpcFunc.Teleporter(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {
        ZhString.KaplaTransmit_SelectTransmitType
      },
      npcinfo = nnpc,
      addfunc = {
        [1] = {
          event = function()
            UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Single
            UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Single
            FunctionNpcFunc.JumpPanel(PanelConfig.UIMapMapList, {npcdata = nnpc, params = params})
          end,
          closeDialog = true,
          NameZh = ZhString.Transmit
        }
      }
    }
    viewdata.addfunc[2] = {
      event = function()
        if TeamProxy.Instance:IHaveTeam() then
          UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Team
          UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Team
          FunctionNpcFunc.JumpPanel(PanelConfig.UIMapMapList, {npcdata = nnpc, params = params})
        else
          MsgManager.ShowMsgByID(352)
        end
      end,
      closeDialog = true,
      NameZh = ZhString.TeammateTransmit
    }
    FunctionNpcFunc.ShowUI(viewdata)
    return true
  else
    UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Single
    UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Single
    FunctionNpcFunc.JumpPanel(PanelConfig.UIMapMapList, {npcdata = nnpc, params = params})
  end
  return nil
end

function FunctionNpcFunc.JoinStage(nnpc, params)
  ServiceNUserProxy.Instance:CallQueryStageUserCmd(0)
  StageProxy.Instance:TakeNpcData(nnpc)
end

function FunctionNpcFunc.PicMake(nnpc, params)
  local bagProxy = BagProxy.Instance
  local bagTypes = bagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce)
  local picType = 50
  local picDatas = {}
  for i = 1, #bagTypes do
    local bagdatas = bagProxy:GetBagItemsByType(picType, bagTypes[i])
    for _, item in pairs(bagdatas) do
      local sdata = item.staticData
      if item:IsPic() and sdata.ComposeID and Table_Compose[sdata.ComposeID] then
        table.insert(picDatas, item)
      end
    end
  end
  local picCount = #picDatas
  if picCount == 0 then
    MsgManager.ShowMsgByIDTable(703)
  elseif picCount == 1 then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PicTipPopUp",
      data = picDatas[1]
    })
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.PicMakeView, {
      npcdata = nnpc,
      params = params,
      datas = picDatas,
      isNpcFuncView = true
    })
  end
end

function FunctionNpcFunc.GvgLand()
  local groupid = GvgProxy.Instance:GetCurMapGvgGroupID()
  if groupid < 0 then
    return
  end
  local staticData = GvgProxy.TryGetStaticLobbyStrongHold()
  if not staticData then
    return
  end
  local cityid = staticData.id
  local viewdata = {
    view = PanelConfig.GvgLandInfoPopUp,
    viewdata = {
      flagid = cityid,
      groupid = groupid,
      hide_downinfo = true
    }
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, viewdata)
end

function FunctionNpcFunc.strengthen(nnpc, params)
  BagProxy.Instance:SetLastOperEquip()
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipIntegrateView, {index = 1})
end

function FunctionNpcFunc.CreateGuild(nnpc, params)
  if GuildProxy.Instance:IsInJoinCD() then
    MsgManager.ShowMsgByIDTable(4046)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.CreateGuildPopUp, {npcdata = nnpc, params = params})
end

function FunctionNpcFunc.ApplyGuild(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildFindPopUp, {npcdata = nnpc, params = params})
end

function FunctionNpcFunc.GuildManor(nnpc, params)
  if GuildProxy.Instance:IHaveGuild() then
    ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
  else
    MsgManager.ShowMsgByIDTable(2620)
  end
end

function FunctionNpcFunc.UpgradeGuild(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if not guildData then
    return
  end
  local upConfig = guildData:GetUpgradeConfig()
  if not upConfig then
    return
  end
  local guildLevel = GuildProxy.Instance.myGuildData.level
  if guildLevel >= GuildProxy.Instance:GetGuildMaxLevel() then
    MsgManager.ShowMsgByIDTable(2637)
    return
  end
  FunctionGuild.Me():QueryGuildItemList()
  local upItemId, upItemNum = upConfig.DeductItem[1], upConfig.DeductItem[2]
  local upItemName = upItemId and Table_Item[upItemId] and Table_Item[upItemId].NameZh
  local tipText = string.format(ZhString.FunctionNpcFunc_GuildUpgradeConfirm, tostring(upConfig.ReviewFund), tostring(upItemNum), tostring(upItemName))
  local dialog = {Text = tipText}
  local guildUpEvent = function(npcinfo)
    FunctionGuild.Me():MakeGuildUpgrade()
  end
  local guildUpFunc = {
    event = guildUpEvent,
    closeDialog = true,
    NameZh = ZhString.FunctionNpcFunc_GuildUpgrade
  }
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {dialog},
    npcinfo = nnpc,
    addfunc = {guildUpFunc},
    addleft = true
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.DisMissGuild(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if guildData.change_group_time ~= 0 or guildData.zonetime ~= 0 then
    MsgManager.ShowMsgByID(3099)
    return
  end
  local createTime = ClientTimeUtil.FormatTimeTick(ServerTime.CurServerTime() / 1000, "yyyy-MM-dd")
  MsgManager.DontAgainConfirmMsgByID(2803, function()
    local memberlist = guildData:GetMemberList()
    local baseDismissTime = GameConfig.Guild.dismisstime / 3600
    local lastDayOnlineMemeberNum = 0
    for i = 1, #memberlist do
      local offlinetime = memberlist[i].offlinetime
      if offlinetime == 0 then
        lastDayOnlineMemeberNum = lastDayOnlineMemeberNum + 1
      else
        local offlineSec = ServerTime.CurServerTime() / 1000 - offlinetime
        if offlineSec <= 86400 then
          lastDayOnlineMemeberNum = lastDayOnlineMemeberNum + 1
        end
      end
    end
    local dismisstime = #memberlist <= 1 and 0 or baseDismissTime + math.floor(lastDayOnlineMemeberNum / 10)
    MsgManager.DontAgainConfirmMsgByID(2804, function()
      if #memberlist == 1 then
        ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd()
      else
        ServiceGuildCmdProxy.Instance:CallDismissGuildCmd(true)
      end
    end, nil, nil, guildData.name, tostring(dismisstime))
  end, nil, nil, guildData.name, createTime)
end

function FunctionNpcFunc.CancelDissolution(nnpc, params)
  ServiceGuildCmdProxy.Instance:CallDismissGuildCmd(false)
end

function FunctionNpcFunc.OpenBokiView()
  BokiProxy.Instance:OpenBokiView(true)
end

function FunctionNpcFunc.ExitGuild(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
  local contribute = myMemberData.contribution
  MsgManager.DontAgainConfirmMsgByID(2802, function()
    ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd()
  end, nil, nil, myGuildData.name, contribute * 0.5)
end

function FunctionNpcFunc.OpenGuildRaid(npc, param)
  helplog("do Open Guild Raid")
end

function FunctionNpcFunc.ReadyToGuildRaid(npc, param)
  helplog("Ready To Guild Raid")
end

function FunctionNpcFunc.AdventureSkill(nnpc, params)
  FuncAdventureSkill.Instance():SetNPCCreature(nnpc)
  FuncAdventureSkill.Instance():OpenUI(1)
end

function FunctionNpcFunc.Dojo(nnpc, params)
  ServiceDojoProxy.Instance:CallDojoQueryStateCmd()
end

function FunctionNpcFunc.QuickTeam(nnpc, param)
  local teamGoal = param or 10000
  if not TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {goalid = teamGoal})
  end
end

function FunctionNpcFunc.DojoTeam(nnpc, params)
  if not TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {
      npcdata = nnpc,
      goalid = TeamGoalType.Dojo
    })
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc})
  end
end

function FunctionNpcFunc.PrimaryEnchant(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantNewView, {
    enchantType = EnchantType.Primary,
    npcdata = nnpc
  })
end

function FunctionNpcFunc.MediumEnchant(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantNewView, {
    enchantType = EnchantType.Medium,
    npcdata = nnpc
  })
end

function FunctionNpcFunc.SeniorEnchant(nnpc, params, funcConfig, isFromBag)
  if not FunctionUnLockFunc.Me():CheckCanOpen(73) then
    MsgManager.ShowMsgByIDTable(43192)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipIntegrateView, {index = 5})
end

function FunctionNpcFunc.EnchantAttrUpgrade(nnpc)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantNewCombineView, {npcdata = nnpc, index = 2})
end

function FunctionNpcFunc.EnchantThirdAttrReset(nnpc)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantNewCombineView, {npcdata = nnpc, index = 3})
end

function FunctionNpcFunc.EnchantTransfer(nnpc)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantNewCombineView, {npcdata = nnpc, index = 4})
end

function FunctionNpcFunc.seal(nnpc, params)
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByIDTable(1607)
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.SealTaskPopUp, {
      enchantType = EnchantType.Senior,
      npcdata = nnpc
    })
  end
end

function FunctionNpcFunc.sealV2(nnpc, params)
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByIDTable(1607)
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.SealTaskPopUpV2, {
      enchantType = EnchantType.Senior,
      npcdata = nnpc,
      costID = 5503
    })
  end
end

function FunctionNpcFunc.GuildDonate(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if guildData then
    local myGuildMembData = GuildProxy.Instance:GetMyGuildMemberData()
    if myGuildMembData then
      local entertime = myGuildMembData.entertime
      local donatelimit = GameConfig.Guild.donate_limittime or 24
      donatelimit = donatelimit * 3600
      if donatelimit <= ServerTime.CurServerTime() / 1000 - entertime then
        FunctionNpcFunc.JumpPanel(PanelConfig.GuildDonateView, {npcdata = nnpc})
      else
        MsgManager.ShowMsgByIDTable(2647)
      end
    end
  else
    MsgManager.ShowMsgByIDTable(2620)
  end
end

local npcFunction, shopType
local GetShopType = function(npc, param)
  npcFunction = npc and npc.data and npc.data.staticData and npc.data.staticData.NpcFunction
  if npcFunction then
    for _, v in pairs(npcFunction) do
      if v.param then
        local shopid = type(v.param) == "number" and v.param or v.param[1]
        if shopid == param then
          return v.type, v.isDoram
        end
      end
    end
  end
  return nil
end
local CheckIsInMagicMachine = function()
  if Game.Myself.data:IsInMagicMachine() then
    MsgManager.ShowMsgByID(28041)
    return true
  end
  return false
end

function FunctionNpcFunc.ChangeHairEye(nnpc, params)
  if CheckIsInMagicMachine() then
    return
  end
  shopType = GetShopType(nnpc, params[1])
  if shopType then
    ShopDressingProxy.Instance:InitQueryDressing(params)
    FunctionNpcFunc.JumpPanel(PanelConfig.DressingView)
  end
end

function FunctionNpcFunc.ChangeClothColor(nnpc, params)
  if CheckIsInMagicMachine() then
    return
  end
  shopType = GetShopType(nnpc, params)
  if shopType then
    ShopDressingProxy.Instance:InitProxy(params, shopType)
    FunctionNpcFunc.JumpPanel(PanelConfig.ClothDressingView)
  end
end

function FunctionNpcFunc.GuildPray(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildPrayDialog, {npcdata = nnpc})
end

function FunctionNpcFunc.GvGPvpPray(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GvGPvPPrayDialog, {npcdata = nnpc})
end

function FunctionNpcFunc.HolyPray(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildHolyPrayDialog, {npcdata = nnpc})
end

function FunctionNpcFunc.DyeCloth(nnpc, params)
  MsgManager.FloatMsgTableParam(nil, ZhString.ItemTip_LockCardSlot)
end

function FunctionNpcFunc.EquipMake(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.CommonCombineView, {
    npcdata = nnpc,
    index = 1,
    tabs = {
      PanelConfig.EquipMfrView
    }
  })
end

function FunctionNpcFunc.EquipUpgrade(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.CommonCombineView, {
    npcdata = nnpc,
    index = 1,
    tabs = {
      PanelConfig.EquipUpgradeView
    }
  })
end

function FunctionNpcFunc.ItemMake(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ItemMakeView, {npcdata = nnpc})
end

function FunctionNpcFunc.EquipRecover(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipRecoverCombinedView, {
    npcdata = nnpc,
    params = params,
    index = 1
  })
end

function FunctionNpcFunc.DoQuench(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.QuenchCombineView, {
    npcdata = nnpc,
    params = params,
    index = 1,
    OnClickChooseBordCell_data = params and params.OnClickChooseBordCell_data
  })
end

function FunctionNpcFunc.DoQuenchIntro(nnpc, params)
  local m_helpId, data = 1711
  data = Table_Help[m_helpId]
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  end
end

function FunctionNpcFunc.DoQuenchGetMat(nnpc, params)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {initialGroupId = 22}
  })
end

function FunctionNpcFunc.Exchange(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ShopMallMainView)
end

function FunctionNpcFunc.GuildDateBattleRecord(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildDateBattleRecordView)
end

function FunctionNpcFunc.ChangeGuildLine(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if guildData and guildData.dismisstime and guildData.dismisstime ~= 0 then
    MsgManager.ShowMsgByID(3091)
    return
  end
  ServiceNUserProxy.Instance:CallQueryZoneStatusUserCmd()
  local count = GuildProxy.Instance:GetGuildPackItemNumByItemid(GameConfig.Zone.guild_zone_exchange.cost[1][1])
  local dialogStr = DialogUtil.GetDialogData(8230).Text
  local str = string.format(dialogStr, count)
  local dialoglist = {str}
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    npcinfo = nnpc,
    subViewId = 3
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.ChangeGvgLine(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if guildData and guildData.dismisstime and guildData.dismisstime ~= 0 then
    MsgManager.ShowMsgByID(3091)
    return
  end
  local nextBeginTime = GvgProxy.Instance.next_season_begintime
  if nextBeginTime and nextBeginTime ~= 0 then
    local curTime = ServerTime.CurServerTime() / 1000
    if curTime > nextBeginTime - 7200 then
      MsgManager.ShowMsgByID(3080)
      return
    end
  end
  local ownCountList = {}
  local costArray = GameConfig.GvgNewConfig and GameConfig.GvgNewConfig.change_group_cost
  if not costArray then
    return
  end
  local costStr = ""
  for i = 1, #costArray do
    local itemid = costArray[i][1]
    local num = costArray[i][2]
    local itemData = Table_Item[itemid]
    if itemData then
      local count = GuildProxy.Instance:GetGuildPackItemNumByItemid(itemid)
      costStr = costStr .. itemData.NameZh .. count .. "/" .. num
      if i ~= #costArray then
        costStr = costStr .. ZhString.GuildDonateConfirmTip_And
      end
    end
  end
  local timeStr = ""
  local timeNeed = GameConfig.GvgNewConfig and GameConfig.GvgNewConfig.change_group_time
  if timeNeed then
    local leftHour = math.floor(timeNeed / 3600)
    timeStr = leftHour .. ZhString.ItemTip_DelRefreshTip_Hour
  end
  local dialogStr = DialogUtil.GetDialogData(396621).Text
  local str = string.format(dialogStr, costStr, timeStr)
  local dialoglist = {str}
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    npcinfo = nnpc,
    subViewId = 12
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.GetCdkey(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GiftActivePanel)
end

function FunctionNpcFunc.ReleaseActivity(npc, param)
  local viewdata = {
    viewname = "TempActivityView",
    viewdata = {
      Config = {
        Params = GameConfig.Activity.ReleaseActivity
      }
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.FindGM(npc, param)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      GameConfig.Activity.GMInfo.Text
    },
    npcinfo = npc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.QuestionSurvey(npc, param)
  local viewdata = {
    viewname = "TempActivityView",
    viewdata = {
      Config = {
        Params = GameConfig.Activity.QuestionSurvey
      }
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.AutumnAdventure(npc, param)
  local viewdata = {
    viewname = "TempActivityView",
    viewdata = {
      Config = {
        Params = GameConfig.Activity.AutumnAdventure
      }
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.GetIceCream(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Summer)
  return true
end

function FunctionNpcFunc.GetAutumnEquip(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Autumn)
  return true
end

function FunctionNpcFunc.GooglePlay(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_OpenServer)
  return true
end

function FunctionNpcFunc.WeiJing(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_WeiJingOpenServer)
  return true
end

function FunctionNpcFunc.MillionHitThanks(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_CodeBW)
  return true
end

function FunctionNpcFunc.AppointmentThanks(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_CodeMX)
  return true
end

function FunctionNpcFunc.ChinaNewYear(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_RedBag)
  return true
end

function FunctionNpcFunc.Safetyrewards(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Phone)
  return true
end

function FunctionNpcFunc.MonthCard(npc, subKey)
  if subKey then
    ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_MonthCard, nil, subKey)
    return true
  end
end

function FunctionNpcFunc.QuestActAnswer(npc, param)
  if npc then
    FunctionXO.Me():QueryQuestion(npc.data.id)
  end
  return true
end

function FunctionNpcFunc.GetOldConsume(npc, param)
  helplog("param", param[1], param[2], param[3])
  local viewdata = {viewname = "DialogView", npcinfo = npc}
  local oldConsumeTip = string.format(ZhString.FunctionNpcFunc_GetOldConsumeTip, param[1], param[3] or 0)
  viewdata.dialoglist = {oldConsumeTip}
  local getEvent = function()
    ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Charge)
  end
  local laterGetEvent = function()
    local lgviewdata = {viewname = "DialogView"}
    local timeDateInfo = os.date("*t", param[2])
    local text = string.format(ZhString.FunctionNpcFunc_LaterGetOldConsumeTip, timeDateInfo.month, timeDateInfo.day, timeDateInfo.hour)
    lgviewdata.dialoglist = {text}
    lgviewdata.npcinfo = npc
    FunctionNpcFunc.ShowUI(lgviewdata)
  end
  viewdata.addfunc = {}
  viewdata.addfunc[1] = {
    event = getEvent,
    closeDialog = true,
    NameZh = ZhString.FunctionNpcFunc_GetOldConsumeButton
  }
  viewdata.addfunc[2] = {
    event = laterGetEvent,
    NameZh = ZhString.FunctionNpcFunc_LaterGetOldConsumeButton
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.Opengift(npc, parama)
  if npc.data.type == SceneMap_pb.EGiveType_Trade then
    ServiceRecordTradeProxy.Instance:CallReqGiveItemInfoCmd(npc.data.giveid)
  else
    ServiceSessionMailProxy.Instance:CallGetMailAttach({
      npc.data.giveid
    })
  end
end

function FunctionNpcFunc.HireCatInfo(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.HireCatInfoView, {catid = param})
end

function FunctionNpcFunc.HelpGuildChallenge(npc, param)
  if GuildProxy.Instance:IsInJoinCD() then
    MsgManager.ShowMsgByIDTable(4046)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.CreateGuildPopUp, {npcdata = npc})
  return true
end

function FunctionNpcFunc.CardRandomMake(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1700})
end

function FunctionNpcFunc.Donate(npc, param, npcFunctionData)
  DonateProxy.Instance:InitByAct(npcFunctionData.id)
  FunctionNpcFunc.JumpPanel(PanelConfig.DonateView, {npcdata = npc})
end

function FunctionNpcFunc.CardMake(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1701})
end

function FunctionNpcFunc.CardDecompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1702})
end

function FunctionNpcFunc.AuctionShop(npc, param)
  ServiceAuctionCCmdProxy.Instance:CallReqAuctionInfoCCmd()
end

function FunctionNpcFunc.TestCheck(npc, param)
  helplog("TestCheck")
end

function FunctionNpcFunc.ChangeGuildName(npc, param)
  if FunctionPerformanceSetting.CheckInputForbidden() then
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildChangeNamePopUp, {npcdata = npc})
end

function FunctionNpcFunc.GiveUpGuildLand(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  local giveUpCd = myGuildData:GetGiveupCityTime()
  local cityids = myGuildData.cityids
  if not next(cityids) and (giveUpCd == nil or giveUpCd == 0) then
    MsgManager.ShowMsgByID(2209)
    return
  end
  local viewdata = {}
  if giveUpCd and 0 < giveUpCd then
    if 0 < ServerTime.ServerDeltaSecondTime(giveUpCd * 1000) then
      viewdata.iscancel = true
      viewdata.msgId = 2200
      viewdata.giveupcd = giveUpCd
      
      function viewdata.confirmHandler()
        helplog("CallCityActionGuildCmd", GuildCmd_pb.ECITYACTION_CANCEL_GIVEUP, cityids[1])
        ServiceGuildCmdProxy.Instance:CallCityActionGuildCmd(GuildCmd_pb.ECITYACTION_CANCEL_GIVEUP, cityids[1])
      end
    else
      MsgManager.ShowMsgByID(25535)
      return
    end
  else
    viewdata.iscancel = false
    viewdata.msgId = 2199
    
    function viewdata.confirmHandler()
      helplog("CallCityActionGuildCmd", GuildCmd_pb.ECITYACTION_GIVEUP, cityids[1])
      ServiceGuildCmdProxy.Instance:CallCityActionGuildCmd(GuildCmd_pb.ECITYACTION_GIVEUP, cityids[1])
    end
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UniqueConfirmView_GvgLandGiveUp,
    viewdata = viewdata
  })
end

function FunctionNpcFunc.GuildLandManage(npc, param)
  local _GuildProxy = GuildProxy.Instance
  local citys = _GuildProxy:GetGuildCitys()
  if citys == nil or #citys == 0 then
    MsgManager.ShowMsgByID(31054)
    return
  end
  local no_attack_metal = _GuildProxy.myGuildData.no_attack_metal
  local canManage = _GuildProxy:ImGuildChairman() or _GuildProxy:ImGuildViceChairman()
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      string.format(ZhString.FunctionNpcFunc_GuildLandManage, no_attack_metal and ZhString.FunctionNpcFunc_GuildLandManageNoAttackMetal or ZhString.FunctionNpcFunc_GuildLandManageAttackMetal, canManage and ZhString.FunctionNpcFunc_GuildLandIfManage or "")
    }
  }
  if canManage then
    viewdata.addfunc = {
      [1] = {
        NameZh = ZhString.FunctionNpcFunc_GuildLandManageYes,
        event = function()
          ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(nil, nil, nil, nil, nil, nil, nil, nil, not no_attack_metal and ProtoCommon_pb.EOPTIONALBOOL_TRUE or ProtoCommon_pb.EOPTIONALBOOL_FALSE)
        end,
        closeDialog = true
      },
      [2] = {
        NameZh = ZhString.FunctionNpcFunc_GuildLandManageNo,
        event = function()
          return true
        end,
        closeDialog = true
      }
    }
  end
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.EquipAlchemy(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipAlchemyView, {npcdata = npc, groupid = param})
end

function FunctionNpcFunc.EnterCapraActivity(npc, param)
  local actId = GameConfig.Activity.SaveCapra and GameConfig.Activity.SaveCapra.ActivityID or 6
  local running = FunctionActivity.Me():IsActivityRunning(actId)
  if running then
    ServiceNUserProxy.Instance:CallEnterCapraActivityCmd()
  else
    MsgManager.ShowMsgByIDTable(7202)
  end
end

function FunctionNpcFunc.EnterAltmanRaid()
  DungeonProxy.InviteTeamRaid(nil, FuBenCmd_pb.ERAIDTYPE_ALTMAN, true)
end

function FunctionNpcFunc.GetAltmanRankInfo(nnpc, param)
  ServiceNUserProxy.Instance:CallQueryAltmanKillUserCmd()
end

function FunctionNpcFunc.SelectTeamPwsEffect(nnpc, param)
  local teamId = TeamProxy.Instance.myTeam.id
  local enemyBall
  local red = PvpProxy.Instance:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Red)
  if red and red.teamid ~= teamId then
    enemyBall = red.balls
  else
    local blue = PvpProxy.Instance:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Blue)
    enemyBall = blue.balls
  end
  local ballCount = 0
  for k, _ in pairs(enemyBall) do
    ballCount = ballCount + 1
  end
  if ballCount <= 2 then
    MsgManager.ShowMsgByIDTable(856)
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  if _PvpTeamRaid == nil then
    _, _PvpTeamRaid = next(GameConfig.PvpTeamRaid)
  end
  local dialogID = _PvpTeamRaid.SelectEffectDialogId
  local text = DialogUtil.GetDialogData(dialogID).Text
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {text},
    npcinfo = nnpc
  }
  viewdata.addfunc = {}
  local elementCombine = _PvpTeamRaid.ElementCombine
  local option_event = function(nnpc, configid)
    ServiceFuBenCmdProxy.Instance:CallSelectTeamPwsMagicFubenCmd(configid)
  end
  for k, v in pairs(elementCombine) do
    local match = true
    for n in tostring(k):gmatch("%d") do
      if not enemyBall[tonumber(n)] then
        match = false
        break
      end
    end
    if match then
      local option = {}
      option.NameZh = v.name
      option.event = option_event
      option.eventParam = k
      option.closeDialog = true
      table.insert(viewdata.addfunc, option)
    end
  end
  table.sort(viewdata.addfunc, function(a, b)
    return a.eventParam < b.eventParam
  end)
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

local deadBossDifficultyVarNameMap
local getSummonDeadBossCount = function(difficulty)
  if not deadBossDifficultyVarNameMap then
    deadBossDifficultyVarNameMap = {
      [FuBenCmd_pb.EDEADBOSSDIFF_NORMAL] = Var_pb.EVARTYPE_DEADBOSS_COUNT_PVECARD2,
      [FuBenCmd_pb.EDEADBOSSDIFF_HARD] = Var_pb.EVARTYPE_DEADBOSS_COUNT_PVECARD3,
      [FuBenCmd_pb.EDEADBOSSDIFF_SUPER] = Var_pb.EVARTYPE_DEADBOSS_COUNT_PVECARD4
    }
  end
  return MyselfProxy.Instance:getVarValueByType(deadBossDifficultyVarNameMap[difficulty]) or 0
end
local callSummonDeadBoss = function(difficulty)
  if 0 < getSummonDeadBossCount(difficulty) then
    MsgManager.ShowMsgByIDTable(26242)
    return
  end
  ServiceFuBenCmdProxy.Instance:CallInviteSummonBossFubenCmd(difficulty)
end

function FunctionNpcFunc.SummonDeadBoss(nnpc, param)
  return callSummonDeadBoss()
end

function FunctionNpcFunc.SummonDeadBoss2(nnpc, param)
  return callSummonDeadBoss(FuBenCmd_pb.EDEADBOSSDIFF_NORMAL)
end

function FunctionNpcFunc.SummonDeadBoss3(nnpc, param)
  return callSummonDeadBoss(FuBenCmd_pb.EDEADBOSSDIFF_HARD)
end

function FunctionNpcFunc.SummonDeadBoss4(nnpc, param)
  return callSummonDeadBoss(FuBenCmd_pb.EDEADBOSSDIFF_SUPER)
end

function FunctionNpcFunc.GuildBuilding(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingView, {npcdata = nnpc})
end

function FunctionNpcFunc.GetGuildWelfare()
  ServiceGuildCmdProxy.Instance:CallGetWelfareGuildCmd()
end

function FunctionNpcFunc.BuildingSubmitMaterial(nnpc, param)
  local data = GuildBuildingProxy.Instance:GetCurBuilding()
  if data and param == data.type then
    GuildBuildingProxy.Instance:InitBuilding(nnpc, param)
    FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingMatSubmitView, {npcdata = nnpc})
  end
end

function FunctionNpcFunc.ReportPoringFight(npc, param)
  if PvpProxy.Instance:Is_polly_match() then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(PvpProxy.Type.PoringFight) then
    MsgManager.ShowMsgByID(42042)
    return
  end
  local running = FunctionActivity.Me():IsActivityRunning(GameConfig.PoliFire.PoringFight_ActivityId or 111)
  helplog("FunctionNpcFunc ReportPoringFight", running)
  if running then
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.PoringFight)
  else
    MsgManager.ShowMsgByIDTable(3605)
  end
end

function FunctionNpcFunc.ReportMvpFight(npc, param)
  local tipActID = GameConfig.MvpBattle.ActivityID or 4000000
  local running = FunctionActivity.Me():IsActivityRunning(tipActID)
  if not running then
    MsgManager.ShowMsgByIDTable(7300)
    return
  end
  local baselv = GameConfig.MvpBattle.BaseLevel
  local rolelv = MyselfProxy.Instance:RoleLevel()
  if baselv > rolelv then
    MsgManager.ShowMsgByID(7301, baselv)
    return
  end
  local teamProxy = TeamProxy.Instance
  if not teamProxy:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  if not teamProxy:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(7303)
    return
  end
  local mblsts = teamProxy.myTeam:GetMembersListExceptMe()
  for i = 1, #mblsts do
    if baselv > mblsts[i].baselv then
      MsgManager.ShowMsgByID(7305, baselv)
      return
    end
  end
  local matchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.MvpFight)
  if matchStatus and matchStatus.ismatch then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(PvpProxy.Type.MvpFight) then
    MsgManager.ShowMsgByID(42042)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.MvpFight)
end

function FunctionNpcFunc.ReportTransferFight(npc, param)
  local matchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.TransferFight)
  if matchStatus and matchStatus.ismatch then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(PvpProxy.Type.TransferFight) then
    MsgManager.ShowMsgByID(42042)
    return
  end
  local activityID = GameConfig.TransferFight.ActivityID or 999999
  local running = FunctionActivity.Me():IsActivityRunning(activityID)
  helplog("FunctionNpcFunc ReportTransferFight", running)
  if running then
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.TransferFight)
  else
    MsgManager.ShowMsgByIDTable(3605)
  end
end

function FunctionNpcFunc.JoinRoom(npc, param)
  helplog("FunctionNpcFunc JoinRoom 进入副本 |类型", param)
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(param)
end

function FunctionNpcFunc.OpenGuildFunction(npc, param)
  ServiceGuildCmdProxy.Instance:CallOpenFunctionGuildCmd(GuildCmd_pb.EGUILDFUNCTION_BUILDING)
end

function FunctionNpcFunc.SewingStrengthen(npc, param)
  if not FunctionUnLockFunc.Me():CheckCanOpen(7) then
    MsgManager.ShowMsgByID(803)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
    return
  end
  FunctionMiyinStrengthen.Ins():SetNPCCreature(npc)
  FunctionMiyinStrengthen.Ins():OpenUI()
end

function FunctionNpcFunc.OpenGuildChallengeTaskView(npc, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GuildChallengeTaskPopUp
  })
end

function FunctionNpcFunc.HighRefine(npc, param)
  local unlockPoses = BlackSmithProxy.Instance:GetHighRefinePoses()
  if unlockPoses == nil or #unlockPoses == 0 then
    MsgManager.ShowMsgByIDTable(3605)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.HighRefinePanel, {npcdata = npc})
end

function FunctionNpcFunc.SewingRefine(npc, param)
  FunctionNpcFunc.Refine(npc, {isfashion = true})
end

function FunctionNpcFunc.ArtifactMake(npc, param)
  ArtifactProxy.Instance:InitParam(param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ArtifactMakeView, {npcdata = npc})
end

function FunctionNpcFunc.GuildHoldTreasure(npc, param)
  ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil, nil, nil, GuildTreasureProxy.ActionType.GVG_FRAME_ON)
end

function FunctionNpcFunc.GuildTreasure(npc, param)
  ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil, nil, nil, GuildTreasureProxy.ActionType.GUILD_FRAME_ON)
end

function FunctionNpcFunc.GuildTreasurePreview(npc, param)
  GuildTreasureProxy.Instance:SetViewType(3)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildTreasureView, {npcdata = npc})
end

function FunctionNpcFunc.ReturnArtifact(npc, param)
  local myArt = ArtifactProxy.Instance:GetMySelfArtifact()
  if myArt and 0 < #myArt then
    FunctionNpcFunc.JumpPanel(PanelConfig.ReturnArtifactView, {npcdata = npc})
  else
    MsgManager.ShowMsgByID(3787)
  end
end

function FunctionNpcFunc.ArtifactDecompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ArtifactDecomposeView, {npcdata = npc})
end

function FunctionNpcFunc.RetrieveAllArtifacts(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_RetrieveAllArtifacts", npc)
  return true
end

function FunctionNpcFunc.ServerOpenFunction(npc, param)
  GameFacade.Instance:sendNotification(DialogEvent.ServerOpenFunction, {npcdata = npc, param = param})
end

function FunctionNpcFunc.YoyoSeat(npc, param)
  ServiceNUserProxy.Instance:CallYoyoSeatUserCmd(npc.data.id)
end

function FunctionNpcFunc.UpJobLevel(npc, param)
  local userdata = Game.Myself.data.userdata
  local jobLv = userdata:Get(UDEnum.JOBLEVEL)
  if jobLv < 91 then
    MsgManager.ShowMsgByID(25442)
    return
  end
  FunctionDialogEvent.SetDialogEventEnter("UpJobLevel", npc)
  return true
end

function FunctionNpcFunc.FastClassChange(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("FastClassChange", npc)
  return true
end

function FunctionNpcFunc.FastChangeClassGetGem(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("FastChangeClassGetGem", npc)
  return true
end

function FunctionNpcFunc.QuestionAnswer(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_GetNewBFSecret", npc)
  return true
end

function FunctionNpcFunc.AlreadyGet(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_GetBFSecretHistory", npc)
  return true
end

function FunctionNpcFunc.PurifyStake(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_NightmareDialogStart", npc)
  return true
end

function FunctionNpcFunc.GetMonsterBatch(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_GetMonsterBatch", npc)
  return true
end

function FunctionNpcFunc.NextMonsterBatch(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_GetNextMonsterBatch", npc)
  return true
end

function FunctionNpcFunc.TransMultiExp(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_TransMultiExp", npc)
  return true
end

function FunctionNpcFunc.QuestRepair(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_QuestRepair", npc)
  return true
end

function FunctionNpcFunc.ViewFashionUnlockCount(npc, param)
  local briefInfo = string.format(ZhString.AdventureUnlockBrief_Fashion, AdventureDataProxy.Instance:GetUnlockBrief_Fashion())
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {briefInfo},
    npcinfo = npc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.ExchangeSand(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("Func_ExchangeSand", npc)
  return true
end

function FunctionNpcFunc.WeddingCememony(npc, param)
  if not WeddingProxy.Instance:IsHandPartner() then
    MsgManager.ShowMsgByIDTable(9644)
    return
  end
  helplog("Call-->InviteBeginWeddingCCmd")
  ServiceWeddingCCmdProxy.Instance:CallInviteBeginWeddingCCmd()
end

function FunctionNpcFunc.WeddingDay(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.EngageMainView, {
    viewEnum = WeddingProxy.EngageViewEnum.Check
  })
end

function FunctionNpcFunc.BookingWedding(npc, param)
  if GameConfig.SystemForbid.WeddingReserve then
    MsgManager.ShowMsgByID(30000)
    return
  end
  if not WeddingProxy.Instance:IsSelfSingle() then
    MsgManager.ShowMsgByID(9601)
    return
  end
  local _Myself = Game.Myself
  local isHandFollow = _Myself:Client_IsFollowHandInHand()
  if isHandFollow == false and _Myself:Client_GetHandInHandFollower() == 0 then
    MsgManager.ShowMsgByID(9600)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.EngageMainView, {
    viewEnum = WeddingProxy.EngageViewEnum.Book
  })
end

function FunctionNpcFunc.CancelWedding(npc, param)
  local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
  if weddingInfo ~= nil and weddingInfo.status == WeddingInfoData.Status.Reserve then
    MsgManager.ConfirmMsgByID(9611, function()
      ServiceWeddingCCmdProxy.Instance:CallGiveUpReserveCCmd(weddingInfo.id)
    end)
  end
end

function FunctionNpcFunc.ConsentDivorce(npc, param)
  local _TeamProxy = TeamProxy.Instance
  if not _TeamProxy:IHaveTeam() then
    MsgManager.ShowMsgByID(9622)
    return
  end
  local _WeddingProxy = WeddingProxy.Instance
  local partner = _WeddingProxy:GetPartnerData()
  if partner == nil then
    return
  end
  local partnerGuid = partner.charid
  if partnerGuid == nil then
    return
  end
  if #_TeamProxy.myTeam:GetPlayerMemberList(true, true) ~= 2 or not _TeamProxy:IsInMyTeam(partnerGuid) then
    MsgManager.ShowMsgByID(9622)
    return
  end
  local partnerTeamData = _TeamProxy.myTeam:GetMemberByGuid(partnerGuid)
  if partnerTeamData:IsOffline() then
    MsgManager.ShowMsgByID(9624)
    return
  end
  local creature = NSceneUserProxy.Instance:Find(partnerGuid)
  local squareNpcDistance = GameConfig.Wedding.Divorce_NpcDistance * GameConfig.Wedding.Divorce_NpcDistance
  if creature == nil or squareNpcDistance < VectorUtility.DistanceXZ_Square(Game.Myself:GetPosition(), creature:GetPosition()) then
    MsgManager.ShowMsgByID(9623)
    return
  end
  local weddingInfo = _WeddingProxy:GetWeddingInfo()
  if weddingInfo ~= nil then
    local _Myself = Game.Myself
    local canDivorce = _Myself and _Myself.data.userdata:Get(UDEnum.DIVORCE_ROLLERCOASTER) or 0
    if canDivorce == 1 then
      MsgManager.ConfirmMsgByID(9613, function()
        ServiceWeddingCCmdProxy.Instance:CallReqDivorceCCmd(weddingInfo.id, WeddingCCmd_pb.EGiveUpType_Together)
      end, nil, nil, partner.name)
    else
      ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterInviteCCmd(nil, partnerGuid)
    end
  end
end

function FunctionNpcFunc.UnilateralDivorce(npc, param)
  local _WeddingProxy = WeddingProxy.Instance
  local weddingInfo = _WeddingProxy:GetWeddingInfo()
  if weddingInfo ~= nil then
    MsgManager.ConfirmMsgByID(9621, function()
      ServiceWeddingCCmdProxy.Instance:CallReqDivorceCCmd(weddingInfo.id, WeddingCCmd_pb.EGiveUpType_Single)
    end, nil, nil, _WeddingProxy:GetPartnerName())
  end
end

function FunctionNpcFunc.EnterRollerCoaster(npc, param)
  if not WeddingProxy.Instance:IsHandPartner() then
    MsgManager.ShowMsgByID(927)
    return
  end
  ServiceWeddingCCmdProxy.Instance:CallEnterRollerCoasterCCmd()
end

function FunctionNpcFunc.TakeMarryCarriage(npc, param)
  if not WeddingProxy.Instance:IsHandPartner() then
    MsgManager.ShowMsgByID(927)
    return
  end
  ServiceWeddingCCmdProxy.Instance:CallWeddingCarrierCCmd()
end

function FunctionNpcFunc.EnterWeddingMap(npc, param)
  local letters = {}
  local marryInviteLetters = BagProxy.Instance:GetMarryInviteLetters()
  for i = 1, #marryInviteLetters do
    local weddingData = marryInviteLetters[i].weddingData
    if weddingData and weddingData:CheckInWeddingTime() then
      table.insert(letters, marryInviteLetters[i])
    end
  end
  ServiceWeddingCCmdProxy.Instance:CallEnterWeddingMapCCmd()
end

function FunctionNpcFunc.WeddingRingShop(nnpc, params, npcFunctionData)
  HappyShopProxy.Instance:InitShop(nnpc, params, npcFunctionData.id)
  FunctionNpcFunc.JumpPanel(PanelConfig.WeddingRingView, {npcdata = nnpc})
end

function FunctionNpcFunc.GetPveCardReward(nnpc, params)
  ServicePveCardProxy.Instance:CallGetPveCardRewardCmd()
end

function FunctionNpcFunc.EnterPveCard(nnpc, params, npcFunctionData)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.PveCard)
end

function FunctionNpcFunc._DoEnterPveCard(configid)
  RaidEnterWaitView.SetListenEvent(ServiceEvent.PveCardReplyPveCardCmd, function(view, note)
    local charid, agree = note.body.charid, note.body.agree
    view:UpdateMemberEnterState(charid, agree)
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.PreEnableButton_Start(false)
  RaidEnterWaitView.SetAllApplyCall(function(view)
    view:EnableButton_Start(view:IsAllMembersAgreed())
  end, true)
  RaidEnterWaitView.SetStartFunc(function(view)
    ServicePveCardProxy.Instance:CallSelectPveCardCmd(configid)
    ServicePveCardProxy.Instance:CallEnterPveCardCmd(configid)
  end)
  ServicePveCardProxy.Instance:CallInvitePveCardCmd(configid)
  FunctionNpcFunc.JumpPanel(PanelConfig.RaidEnterWaitView)
end

function FunctionNpcFunc.ShowPveCard(nnpc, params)
  local configid = params
  FunctionNpcFunc.JumpPanel(PanelConfig.OricalCardInfoView, {index = configid})
end

function FunctionNpcFunc.SelectPveCard(nnpc, params)
  local configid = params
  ServicePveCardProxy.Instance:CallSelectPveCardCmd(configid)
end

function FunctionNpcFunc.PveCard_StartFight(nnpc)
  ServicePveCardProxy.Instance:CallBeginFirePveCardCmd()
end

function FunctionNpcFunc.HeadWearStart(nnpc)
  HeadwearRaidProxy.Instance:InitRaidData(false)
  ServiceNUserProxy.Instance:CallHeadwearOpenUserCmd()
end

function FunctionNpcFunc.ActivityHeadWearStart(nnpc)
  HeadwearRaidProxy.Instance:InitRaidData(true)
  ServiceRaidCmdProxy.Instance:CallHeadwearActivityOpenUserCmd()
end

function FunctionNpcFunc.OpenGVGPortal(npc, param)
  local viewdata = {
    viewname = "GVGPortalView",
    view = PanelConfig.GVGPortalView,
    npcinfo = npc
  }
  FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.EnterPoringFight(npc, param)
  ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(SceneUser2_pb.EFUNCMAPTYPE_POLLY)
end

function FunctionNpcFunc.EquipCompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipComposeView)
end

function FunctionNpcFunc.HireCatConfirm(npc, param)
  local viewdata = {
    viewname = "HireCatPopUp",
    catid = param[1],
    isNewHire = true
  }
  FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.DialogGoddessOfferDead(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("DialogGoddessOfferDead", npc)
  return true
end

function FunctionNpcFunc.DeathTransfer(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.MapTransmitterView, {npcdata = nnpc, params = params})
end

function FunctionNpcFunc.BeatBoli(nnpc, params)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HitBoliView
  })
end

function FunctionNpcFunc.CourageRanking(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.CourageRankPopUp)
end

function FunctionNpcFunc.GuildDateBattle(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildDateBattleOverview)
end

function FunctionNpcFunc.MoroccSeal(nnpc)
  FunctionRepairSeal.Me():DoMoroccConfirmRepair(nnpc.data.staticData.id)
end

function FunctionNpcFunc.Roguelike(nnpc, params, npcFunctionData)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeEventNpcCmd(nnpc.data.id, npcFunctionData.Parama.Option or 1)
end

function FunctionNpcFunc.ExpRaidShop(nnpc, param)
  ExpRaidProxy.Instance:InitShop(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ExpRaidShopView)
end

function FunctionNpcFunc.ExpRaidBegin()
  ExpRaidProxy.Instance:CallBeginRaid()
end

function FunctionNpcFunc.ExpRaidEntrance()
  FunctionNpcFunc.JumpPanel(PanelConfig.ExpRaidMapView)
end

function FunctionNpcFunc.ExpPreShop(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ExpRaidPrestigeShopView, {npcdata = nnpc})
end

function FunctionNpcFunc.Gem3to1Compose()
  FunctionNpcFunc.JumpPanel(PanelConfig.GemComposeView, {mode = 1})
end

function FunctionNpcFunc.Gem5to1Compose()
  FunctionNpcFunc.JumpPanel(PanelConfig.GemComposeView, {mode = 2})
end

function FunctionNpcFunc.GemSameNameCompose()
  FunctionNpcFunc.JumpPanel(PanelConfig.GemComposeView, {mode = 0})
end

function FunctionNpcFunc.GemSculpt()
  FunctionNpcFunc.JumpPanel(PanelConfig.GemSculptView)
end

function FunctionNpcFunc.GemSmelt()
  FunctionNpcFunc.JumpPanel(PanelConfig.GemSmeltView)
end

function FunctionNpcFunc.CommonMenuLock(nnpc, param)
  local dialogids = param.dialogids
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialogids,
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.GemLock(nnpc, param)
  local lockFlag = FunctionNpcFunc.CheckCommonMenuLock(nnpc, param)
  if lockFlag == NpcFuncState.Active then
    return FunctionNpcFunc.CommonMenuLock(nnpc, param)
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.GemContainerView, {
      page = "GemFunctionPage",
      fromNpc = true
    })
  end
end

function FunctionNpcFunc.EvaRaid(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {npcdata = npc, raidtype = "EvaRaid"})
end

function FunctionNpcFunc.BossCardCompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1703})
end

function FunctionNpcFunc.MvpCardCompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1704})
end

function FunctionNpcFunc.DungeonMvpCardCompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1705})
end

function FunctionNpcFunc.MountLottery(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.MountLotteryView, {npcdata = npc})
end

function FunctionNpcFunc.ThanatosRaid(npc, params, npcFunctionData)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.Thanatos)
end

function FunctionNpcFunc.HeadwearRaid(npc)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.Headwear)
end

function FunctionNpcFunc.HeadWearActivity(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.HeadWearActivityRaidEnterView, {npcdata = npc})
end

function FunctionNpcFunc.HeadWearActivity(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.HeadWearActivityRaidEnterView, {npcdata = npc})
end

function FunctionNpcFunc.HeadWearRaidShop(nnpc, params, npcFunctionData)
  HappyShopProxy.Instance:InitShop(nnpc, params, 3009)
  FunctionNpcFunc.JumpPanel(PanelConfig.HeadWearRaidShop, {npcdata = nnpc})
end

function FunctionNpcFunc.EnterRoguelike()
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.Rugelike)
end

function FunctionNpcFunc.SaveRoguelike()
  FunctionPve.SaveRoguelike()
end

function FunctionNpcFunc.RoguelikeScoreModel()
  MsgManager.ConfirmMsgByID(40716, function()
    ServiceRoguelikeCmdProxy.Instance:CallRoguelikeScoreModelCmd()
  end)
end

function FunctionNpcFunc.RoguelikeShop(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.RoguelikeShopView, {npcdata = nnpc})
end

function FunctionNpcFunc.RoguelikeRank(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.RoguelikeRankPopUp)
end

function FunctionNpcFunc.RoguelikeChargeMagicBottle(nnpc, param)
  local raid = DungeonProxy.Instance.roguelikeRaid
  if not raid then
    LogUtility.Error("You're trying to charge magic bottle outside roguelike map!")
    return
  end
  if raid.bottleCharged then
    MsgManager.ShowMsgByID(26263)
    return
  end
  if raid.magicBottleCount and raid.magicBottleCount == GameConfig.Roguelike.MagicBottleItemNum then
    MsgManager.ShowMsgByID(26264)
    return
  end
  ServiceRoguelikeCmdProxy.Instance:CallRogueChargeMagicBottle(nnpc.data.id)
end

function FunctionNpcFunc.RoguelikeTarot(nnpc, param)
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(26266)
    return
  end
  if next(DungeonProxy.Instance.roguelikeTarotIds) then
    FunctionNpcFunc.JumpPanel(PanelConfig.RoguelikeTarotView)
  else
    ServiceRoguelikeCmdProxy.Instance:CallRogueTarotOperateCmd(RoguelikeCmd_pb.EROGUETAROTOPETATE_RE_THREE)
  end
end

function FunctionNpcFunc.EnterNextRaidGroup(npc, params)
  local rollingCount = DungeonProxy.Instance:GetRollingPlayerCount()
  if 0 < rollingCount then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RollRewardWaitForRollPopUp
    })
  else
    ServiceTeamGroupRaidProxy.Instance:CallEnterNextRaidGroupCmd()
  end
end

function FunctionNpcFunc.Prestige_Shop(nnpc, params, npcFunctionData)
  HappyShopProxy.Instance:InitShop(nnpc, params, npcFunctionData.id)
  FunctionNpcFunc.JumpPanel(PanelConfig.PrestigeShopView, {npcdata = nnpc})
end

function FunctionNpcFunc.HomeEnterEditMode(npc, params)
  HomeManager.Me():EnterEditMode()
end

function FunctionNpcFunc.HomeClearAllFurnitures(npc, params)
  MsgManager.ConfirmMsgByID(38020, function()
    HomeManager.Me():RemoveAllFurnitures()
  end)
end

local AstrologyMap = {
  [SceneAugury_pb.EASTROLOGYTYPE_CONSTELLATION] = ActivityCmd_pb.GACTIVITY_EASTROLOGYTYPE_CONSTELLATION,
  [SceneAugury_pb.EASTROLOGYTYPE_ACTIVITY] = ActivityCmd_pb.GACTIVITY_EASTROLOGYTYPE_ACTIVITY
}

function FunctionNpcFunc.Astrology(npc, params, npcFunctionData)
  local atype = npcFunctionData.Parama.parama
  local activityType = AstrologyMap[atype]
  if not activityType then
    return
  end
  if not FunctionActivity.Me():IsActivityRunning(activityType) then
    MsgManager.ShowMsgByID(5225)
    return
  end
  local param = FunctionActivity.Me():GetParams(activityType)
  local count = 0
  if not param then
    return
  end
  if atype == SceneAugury_pb.EASTROLOGYTYPE_CONSTELLATION then
    count = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_EASTROLOGYTYPE_CONSTELLATION) or 0
  elseif atype == SceneAugury_pb.EASTROLOGYTYPE_ACTIVITY then
    count = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_EASTROLOGYTYPE_ACTIVITY) or 0
  end
  if count < param[1] then
    FunctionNpcFunc.JumpPanel(PanelConfig.AstrologyView, {AstrologyType = atype})
  else
    MsgManager.ShowMsgByID(5224)
    return
  end
end

function FunctionNpcFunc.BearRaid(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {npcdata = npc, raidtype = "Kumamoto"})
end

function FunctionNpcFunc.ChangeRaidGroup(npc, params, npcFunctionData)
  local curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[curmapid]
  if not tgConfig then
    for k, v in pairs(Table_TeamGroupRaid) do
      if v.InnerRaidID and v.InnerRaidID == curmapid then
        tgConfig = v
        break
      end
    end
  end
  if not tgConfig then
    return
  end
  local configThanatos
  if tgConfig then
    configThanatos = GameConfig.Thanatos[tgConfig.Difficulty]
  end
  local buffID = configThanatos and configThanatos.GoOuterCDBuff
  local npcguid = npc.data.id
  local ncreature = NSceneNpcProxy.Instance:Find(npcguid)
  if ncreature and ncreature.data:HasBuffID(buffID) then
    MsgManager.ShowMsgByID(25974)
  else
    MsgManager.ConfirmMsgByID(25983, function()
      ServiceFuBenCmdProxy.Instance:CallGroupRaidFourthGoOuterCmd(npcguid)
    end, nil, nil)
  end
end

function FunctionNpcFunc.TeampveLog(npc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.ThanatosMonumentView)
end

function FunctionNpcFunc.FurnitureShop(npc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.FurnitureShopView)
end

function FunctionNpcFunc.EnterThanksgivingRaid()
  DungeonProxy.InviteTeamRaid(nil, FuBenCmd_pb.ERAIDTYPE_THANKSGIVING, true)
end

function FunctionNpcFunc.OpenKFCShareView(npc, param)
  autoImport("FloatAwardView")
  if FloatAwardView.ShareFunctionIsOpen() then
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.KFCActivityShowView,
      viewdata = param
    })
  end
end

function FunctionNpcFunc.OpenConcertShareView(npc, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SharePanel,
    viewdata = param
  })
end

function FunctionNpcFunc.Stake(npc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.SkadaRankingPopup)
end

function FunctionNpcFunc.MiniGameEntrance(npc, params, npcFunctionData)
  ServiceMiniGameCmdProxy.Instance:CallMiniGameUnlockList()
  FunctionNpcFunc.JumpPanel(PanelConfig.MiniGameEntranceView)
end

local TechTreeMapIDToggle = {
  [102] = 3,
  [104] = 3,
  [105] = 3
}

function FunctionNpcFunc.TechTree(npc, params, npcFunctionData)
  local mapid = SceneProxy.Instance:GetCurMapID()
  if TechTreeProxy.Instance:CheckTechTreeUnlock() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TechTreeContainerView, {
      treeId = TechTreeMapIDToggle[mapid] or 3
    })
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.TechTreeContainerView, {treeId = 3})
  end
end

function FunctionNpcFunc.TransferFightEnter(npc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {
    npcdata = npc,
    raidtype = "TransferFight"
  })
end

function FunctionNpcFunc.MaidRaidBegin()
  ExpRaidProxy.Instance:CallBeginRaid()
end

function FunctionNpcFunc.MaidRaidEntrance(npc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {npcdata = npc, raidtype = "MaidRaid"})
end

function FunctionNpcFunc.DyeCompose(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.DyeComposeView, {npcdata = nnpc})
end

function FunctionNpcFunc.QueryPrice(npc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ShopMallExchangeSearchView, {isQueryPrice = true})
end

function FunctionNpcFunc.OpenLisaShareView(npc, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SharePanel,
    viewdata = param
  })
end

function FunctionNpcFunc.Browserjump(npc, param)
  helplog("Browserjump")
  if param and param.url then
    local url = param.url
    helplog("url:" .. url)
    Application.OpenURL(url)
  else
    helplog("请检查表")
  end
end

function FunctionNpcFunc.SpringFestivalRaid(npc, params)
  DungeonProxy.InviteTeamRaid(nil, FuBenCmd_pb.ERAIDTYPE_SPRING, true)
end

function FunctionNpcFunc.DeadBossRaid(npc)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.DeadBoss)
end

local getDeadBossSummonFinished = function(param)
  local count = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_DEADBOSSRAID_COUNT) or 0
  return 0 < count >> param - 1 & 1
end

function FunctionNpcFunc.DeadBossSummon(npc, params)
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByIDTable(39100)
    return
  end
  if getDeadBossSummonFinished(params) then
    MsgManager.ShowMsgByIDTable(26242)
    return
  end
  ServiceFuBenCmdProxy.Instance:CallInviteSummonBossFubenCmd(nil, params)
end

function FunctionNpcFunc.BifrostSubmitMaterial(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.BifrostMatSubmitView, {npcdata = nnpc})
end

function FunctionNpcFunc.GuildLeaderBoard(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildScoreRankView)
end

function FunctionNpcFunc.PlayVideo(npc, param)
  if "string" == type(param) and not StringUtil.IsEmpty(param) then
    VideoPanel.PlayVideo(param)
  else
    redlog("FunctionNpcFunc.PlayVideo 视频资源名未配")
  end
end

function FunctionNpcFunc.Einherjar(npc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {
    npcdata = npc,
    raidtype = "Einherjar",
    turnid = params
  })
end

function FunctionNpcFunc.SlayersRaid(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {npcdata = npc, raidtype = "Slayers"})
end

function FunctionNpcFunc.PersonalEndlessTower(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.PracticeFieldView, {npcdata = npc})
end

function FunctionNpcFunc.MayPalaceEnter(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.MayPalaceEntranceView)
end

function FunctionNpcFunc.DisneyTeam(npc)
  local _disneyStageMgr = DisneyStageProxy.Instance
  local _TeamMgr = TeamProxy.Instance
  if not _disneyStageMgr.musicActId then
    MsgManager.ShowMsgByID(42052)
    return
  end
  if not _TeamMgr:IHaveTeam() then
    MsgManager.ShowMsgByID(42051)
    return
  end
  if _TeamMgr:IHaveGroup() then
    MsgManager.ShowMsgByID(42061)
    return
  end
  if _disneyStageMgr:IsStageClosed() and not _TeamMgr:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(42050)
    return
  end
  if _disneyStageMgr:IsGameStart() then
    MsgManager.ShowMsgByID(42060)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.DisneyTeamView)
end

function FunctionNpcFunc.RotateRaidPuzzleObj(npc, params)
  RaidPuzzleManager.Me():RotatePushableObject(npc)
end

function FunctionNpcFunc.InteractTorchObj(npc, params)
  RaidPuzzleManager.Me():InteractTorchObj(npc)
end

function FunctionNpcFunc.PersonalArtifactShop(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.PersonalArtifactFunctionView, {state = 0})
end

function FunctionNpcFunc.PersonalArtifactCompose(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.PersonalArtifactFunctionView, {state = 1})
end

function FunctionNpcFunc.PersonalArtifactRefresh(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.PersonalArtifactFunctionView, {state = 2})
end

function FunctionNpcFunc.PersonalArtifactDecompose(npc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.PersonalArtifactFunctionView, {state = 3})
end

function FunctionNpcFunc.PersonalArtifactExchange(npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.PersonalArtifactFunctionView, {state = 4})
end

function FunctionNpcFunc.ItemExtract(nnpc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.ItemExtractView, {npcdata = nnpc, npcfunctiondata = npcFunctionData})
end

function FunctionNpcFunc.RefineTransfer(nnpc)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipIntegrateView, {index = 2})
end

function FunctionNpcFunc.EquipReplaceNew(nnpc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipReplaceNewView, {npcdata = nnpc, npcfunctiondata = npcFunctionData})
end

function FunctionNpcFunc.DriftBottle(npc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.DriftBottleView, {npcdata = npc, npcfunctiondata = npcFunctionData})
end

function FunctionNpcFunc.DriftBottlePanel(npc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.DriftBottlePanel, {npcdata = npc, npcfunctiondata = npcFunctionData})
end

function FunctionNpcFunc.EquipRecovery(nnpc, params, npcFunctionData)
  if not BlackSmithProxy.CheckEquipRecoveryTime() then
    MsgManager.ShowMsgByID(40973)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipRecoveryView, {npcdata = nnpc, npcfunctiondata = npcFunctionData})
end

function FunctionNpcFunc.EquipRecoveryPlus(nnpc, params, npcFunctionData)
  if not BlackSmithProxy.CheckEquipRecoveryTime() then
    MsgManager.ShowMsgByID(40973)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipRecoveryView, {
    npcdata = nnpc,
    plus = true,
    npcfunctiondata = npcFunctionData
  })
end

function FunctionNpcFunc.VisitLightPuzzleObj(npc, param)
  local npcId = npc.data.staticData.id
  LightPuzzleManager.Me():HandlePuzzleObject(npcId, param)
end

function FunctionNpcFunc.CookMaster(npc, param, npcFunctionData, endfunc)
  FunctionNpcFunc.JumpPanel(PanelConfig.CookMasterView, {
    npcdata = npc,
    npcfunctiondata = npcFunctionData,
    params = param
  })
end

function FunctionNpcFunc.RunGameEnter(npc, param, npcFunctionData, endfunc)
  ServiceNUserProxy.Instance:CallRaceGameStartUserCmd()
end

function FunctionNpcFunc.ManorBuild(npc, param, npcFunctionData, endfunc)
  local buildingId = param
  if not buildingId or not Table_Npc[buildingId] then
    buildingId = npc.data.staticData.id
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.ComodoBuildingContainerView, {buildingId = buildingId}, npc, endfunc)
end

function FunctionNpcFunc.ManorMusicBox(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ComodoBuildingMusicBoxView, {npcdata = npc})
end

function FunctionNpcFunc.EnterManorRaid(npc, param)
  xdlog("申请进入庄园", npc.data.id)
  ServiceSceneManorProxy.Instance:CallReqEnterRaidManorCmd(npc.data.id)
end

function FunctionNpcFunc.PartnerGift(npc, param)
  local dialogId = 782571
  local dialogData = DialogUtil.GetDialogData(dialogId)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      dialogData.Text
    },
    npcinfo = npc,
    subViewId = 9,
    keepVisitRef = true
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.EditHeadText(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.NPCHeadMsgInputView, {npcdata = nnpc, msgType = 1})
end

function FunctionNpcFunc.EditDefaultDialog(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.NPCHeadMsgInputView, {npcdata = nnpc, msgType = 2})
end

function FunctionNpcFunc.ComodoRaid(npc, params, npcFunctionData)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.Comodo)
end

function FunctionNpcFunc.MultiBossRaid(npc, params, npcFunctionData)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.MultiBoss)
end

function FunctionNpcFunc.FirstTransferProfession()
  if not Table_TransferClass then
    redlog("策划未上传新手转职表 Table_TransferClass")
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.TransferProfessionView)
end

function FunctionNpcFunc.CheckFirstTransferProfession(npc, param)
  local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if myClass == 1 then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.EnterReturnChatRoom(npc, param)
  xdlog("申请进入回归者聊天室")
  ServiceActivityCmdProxy.Instance:CallUserReturnEnterChatRoomCmd()
end

function FunctionNpcFunc.SevenRoyalSecrets(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.SevenRoyalFamilyTreeView, {npcdata = npc})
end

function FunctionNpcFunc.BoliWishing(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.BoliWishingPanel, {npcdata = npc})
end

function FunctionNpcFunc.CardLottery(npc, param, npcFunctionData)
  local lotterytype = npcFunctionData.Parama.lotterytype
  if not lotterytype then
    redlog("lottery nil", npcFunctionData.id)
  elseif LotteryProxy.IsNewCardLottery(lotterytype) then
    FunctionLottery.Me():OpenNewLotteryByType(lotterytype)
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.CardLotteryView, {npcdata = npc, lotteryType = lotterytype})
  end
end

function FunctionNpcFunc.ChangeAvatar(npc, param)
  if npc.data.staticData.id == GameConfig.GVGConfig.StatuePedestalNpcID then
    ServiceUserEventProxy.Instance:CallGvgOptStatueEvent(true)
    return
  end
  local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
  local city_id = GvgProxy.GetStatueCity(npc.data.uniqueid)
  if not city_id then
    return
  end
  GvgProxy.Instance:Debug("[GVG雕像]更改形象 group_id|city_id ", group_id, city_id)
  ServiceGuildCmdProxy.Instance:CallGvgCityStatueUpdateGuildCmd(group_id, city_id, true, {info = nil})
end

function FunctionNpcFunc.ChangeAction(npc, param)
  local npc_static_id = npc.data.staticData.id
  local is_old = npc_static_id == GameConfig.GVGConfig.StatuePedestalNpcID
  local config = GameConfig.GVGConfig.StatuePose
  local my_guild_group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
  local city_id = GvgProxy.GetStatueCity(npc.data.uniqueid)
  GvgProxy.Instance:SetCurStatueCityId(city_id)
  local npcs, changePoseFunc, savePoseFunc
  if is_old then
    npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatueNpcID)
    
    function changePoseFunc(pose)
      GvgProxy.Instance:UpdateStatuePose(pose)
    end
    
    function savePoseFunc(pose)
      ServiceUserEventProxy.Instance:CallGvgOptStatueEvent(nil, pose)
    end
  else
    function changePoseFunc(pose)
      GvgProxy.Instance:ChangeStatuePos(pose)
    end
    
    function savePoseFunc(pose)
      if not pose or pose == 0 then
        return
      end
      local send_info = {
        cityid = city_id,
        info = {pose = pose}
      }
      GvgProxy.Instance:Debug("[GVG雕像]请求更改动作pose: ", pose)
      ServiceGuildCmdProxy.Instance:CallGvgCityStatueUpdateGuildCmd(my_guild_group_id, city_id, false, send_info)
    end
  end
  if Game.Myself.data:IsTransformState() then
    MsgManager.ShowMsgByID(31078)
    return
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      DialogUtil.GetDialogData(396138).Text
    },
    forceNotify = true
  }
  local cur_pos
  if is_old then
    local info = GvgProxy.Instance:GetStatueInfo()
    cur_pos = info.pose
    
    function viewdata.callback()
      if Game.Myself.data:HasBuffID(GameConfig.GVGConfig.PoseCdBuff) then
        GvgProxy.Instance:UpdateStatuePose()
      end
    end
  else
    cur_pos = GvgProxy.Instance:GetPoseByCityId(my_guild_group_id, city_id)
  end
  local index = cur_pos and TableUtility.ArrayFindIndex(config, cur_pos) or 0
  if index == 0 then
    index = 1
  end
  viewdata.addfunc = {
    [1] = {
      NameZh = ZhString.FunctionNpcFunc_ChangeActionLast,
      event = function()
        index = index - 1
        if index < 1 then
          index = #config
        end
        changePoseFunc(config[index])
      end
    },
    [2] = {
      NameZh = ZhString.FunctionNpcFunc_ChangeActionNext,
      event = function()
        index = index + 1
        if index > #config then
          index = 1
        end
        changePoseFunc(config[index])
      end
    },
    [3] = {
      NameZh = ZhString.FunctionNpcFunc_ChangeActionSave,
      event = function()
        savePoseFunc(config[index])
      end,
      closeDialog = true
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.PresidentRule(npc, param, npcFunctionData)
  local data = Table_Help[npcFunctionData.Parama.helpId]
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  end
end

function FunctionNpcFunc.GuildRaid(nnpc, params, npcFunctionData)
  PveEntranceProxy.Instance:OpenTargetPve(PveRaidType.GuildRaid)
end

function FunctionNpcFunc.OpenSandTable(nnpc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.GVGSandTablePanel, {
    npcdata = npc
  })
end

function FunctionNpcFunc.OpenMountDressingView(nnpc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.MountDressingView, {mountId = params})
end

function FunctionNpcFunc.AierBlacksmith(npc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.AierBlacksmithPanel, {npcdata = npc, npcfunctiondata = npcFunctionData})
end

function FunctionNpcFunc.AierBlacksmithRandomTalk(npc, param, npcFunctionData)
  local dl = AierBlacksmithProxy.Instance:Query_GetRandomTalk()
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dl,
    npcinfo = npc,
    callback = nil
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  return true
end

function FunctionNpcFunc.PhotoBoardMyPost(npc, param, npcFunctionData)
  local hasMyPost = PhotoStandProxy.Instance.mypostList and PhotoStandProxy.Instance.mypostList.sum and PhotoStandProxy.Instance.mypostList.sum > 0
  if hasMyPost then
    FunctionNpcFunc.JumpPanel(PanelConfig.PhotoStandPanel, {
      npcdata = npc,
      npcfunctiondata = npcFunctionData,
      usage = "mypost"
    })
  else
    MsgManager.ShowMsgByID(43403)
  end
end

function FunctionNpcFunc.BatteryCannon(npc, param, npcFunctionData, callbackList)
  FunctionNpcFunc.JumpPanel(PanelConfig.BatteryCannonView, {
    npcdata = npc,
    npcfunctiondata = npcFunctionData,
    param = param,
    callbackList = callbackList
  }, npc)
end

function FunctionNpcFunc.ShowPrestigeInfo(npc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.QuestTracePanel, {tabID = 1, PrestigeVersion = param})
end

function FunctionNpcFunc.OpenSpecialSkillUpgradeView(npc, params, npcFunctionData)
  local skillId = params
  local professionSkill = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
  local skillData = professionSkill:FindSkillById(skillId)
  FunctionNpcFunc.JumpPanel(PanelConfig.SpecialSkillUpgradeView, skillData)
end

function FunctionNpcFunc.GiftCard(npc, param, npcFunctionData)
  if not HomeManager.Me():IsAtMyselfHome() then
    return
  end
  local postcard_id = npc and npc.data and npc.data.postcard or 1
  xdlog("明信片ID", postcard_id)
  local postcard_cfg = postcard_id and Table_QuestPostcard and Table_QuestPostcard[postcard_id]
  if postcard_cfg then
    local postcard = PostcardData.new()
    postcard:Config_SetData(postcard_cfg)
    postcard:SetAsReceiveTemp()
    local npcGuid = npc and npc.data and npc.data.id
    local callback = function()
      local realNpc = NSceneNpcProxy.Instance:Find(npcGuid)
      if realNpc then
        ServiceActivityCmdProxy.Instance:CallOpenHomeGiftBoxCmd(npcGuid)
        local effectPos = realNpc:GetPosition()
        Asset_Effect.PlayOneShotAt(EffectMap.Maps.Clown, effectPos)
        realNpc:HideMyself(1)
      end
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PostcardView,
      viewdata = {
        usageType = 4,
        postcard = postcard,
        questData = questData,
        callback = callback
      }
    })
  end
end

function FunctionNpcFunc.GVGRoadBlock(npc, param, npcFunctionData)
end

function FunctionNpcFunc.LaunchFirework(npc, param, npcFunctionData)
  ServiceSceneUser3Proxy.Instance:CallLightFireworkUserCmd()
  Game.LockTargetEffectManager:ClearLockedTarget()
  GameFacade.Instance:sendNotification(ItemEvent.ItemUseTip)
end

function FunctionNpcFunc.RemoveFirework(npc, param, npcFunctionData)
  local guid = npc and npc.data and npc.data.id
  local ownerid = npc and npc.data and npc.data.ownerID
  ServiceSceneUser3Proxy.Instance:CallRemoveFireworkUserCmd(guid)
end

function FunctionNpcFunc.ShowUI(viewdata)
  if viewdata then
    local vdata = viewdata.viewdata or {}
    vdata.isNpcFuncView = true
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
end

function FunctionNpcFunc.JumpPanel(panel, viewdata, npc, endfunc)
  if panel then
    viewdata = viewdata or {}
    viewdata.isNpcFuncView = true
    if endfunc then
      local funcList = {}
      for k, v in pairs(endfunc) do
        if FunctionNpcFunc["EndCallBack_" .. k] then
          funcList[#funcList + 1] = {
            func = FunctionNpcFunc["EndCallBack_" .. k],
            param = v,
            npc = npc
          }
        end
      end
      viewdata.callbackList = funcList
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panel, viewdata = viewdata})
  end
end

function FunctionNpcFunc.EndCallBack_playdialog(npc, params)
  xdlog("EndCallBack_Dialog", params[1])
  local viewdata = {
    viewname = "DialogView",
    dialoglist = params,
    npcinfo = npc
  }
  FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.EndCallBack_animid(npc, params)
  xdlog("EndCallBack_animid", params)
  if npc then
    local actionid = params
    local actionName = Table_ActionAnime[actionid].Name
    npc:Server_PlayActionCmd(actionName, nil, false)
  else
    redlog("npc不存在")
  end
end

function FunctionNpcFunc.EndCallBack_effect(npc, params)
  xdlog("EndCallBack_effect", params)
  if npc then
    npc.assetRole:PlayEffectOneShotOn(params, 1)
  else
    redlog("目标NPC不存在")
  end
end

function FunctionNpcFunc.OpenPveMonsterPopup(npc, params)
  if params then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveMonsterPopUp,
      viewdata = {monsterIndex = 1, monstersData = params}
    })
  end
end

function FunctionNpcFunc.EnterBigCatInvadeActivity(npc, params)
  local actId = GameConfig.Activity.BigCatInvade and GameConfig.Activity.BigCatInvade.ActivityID
  local running = FunctionActivity.Me():IsActivityRunning(actId)
  if running then
    ServiceActivityCmdProxy.Instance:CallEnterBigCatInvadeCmd()
  else
    MsgManager.ShowMsgByIDTable(7202)
  end
end

function FunctionNpcFunc.ExchangeGift(npc, params, npcFunctionData)
  local activityid = npcFunctionData and npcFunctionData.Parama and npcFunctionData.Parama.activityID
  redlog("activityid", activityid)
  ServiceSceneUser3Proxy.Instance:CallActivityExchangeGiftsQueryUserCmd(activityid)
  FunctionNpcFunc.JumpPanel(PanelConfig.ExchangeGiftView, {activityID = activityid, npcdata = npc})
end

function FunctionNpcFunc.ReceiveTripleTeamPwsTargetReward(npc, params, npcFunctionData)
  ServiceMatchCCmdProxy.Instance:CallTriplePvpPickRewardCmd(MatchCCmd_pb.TRIPLE_REWARD_GOAL)
end

function FunctionNpcFunc.ReceiveTripleTeamPwsRankReward(npc, params, npcFunctionData)
  ServiceMatchCCmdProxy.Instance:CallTriplePvpPickRewardCmd(MatchCCmd_pb.TRIPLE_REWARD_RANK)
end

function FunctionNpcFunc.CraftingPot(npc, params, npcFunctionData)
  CraftingPotProxy.Instance:InitCall(true)
  ServiceMessCCmdProxy.Instance:CallPurifyProductsMaterialsMessCCmd()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CraftingPotView
  })
end

function FunctionNpcFunc.AstralRaidNextLevel(npc, params, npcFunctionData)
  local raidId = Game.MapManager:GetRaidID()
  local entranceData = AstralProxy.Instance:GetNextLevelEntranceDataByRaidId(raidId)
  if not entranceData then
    redlog("Table_PveRaidEntrance里无当前副本！raidId=" .. raidId)
    return
  end
  FunctionPve.Me():SetCurPve(entranceData)
  FunctionPve.Me():DoChallenge()
end

function FunctionNpcFunc.AstralRaidExitRaid(npc, params, npcFunctionData)
  MsgManager.ConfirmMsgByID(7, function()
    ServiceNUserProxy.Instance:ReturnToHomeCity()
  end)
end

function FunctionNpcFunc.OpenAstralDestinyGraph(npc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.AstralDestinyGraphView)
end

function FunctionNpcFunc.OpenRankPop(npc, params, npcFunctionData)
  local rankType = npcFunctionData.Parama and npcFunctionData.Parama.rankType
  if rankType == 1 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TripleTeamRankPopUp
    })
  elseif rankType == 2 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsRankPopUp
    })
  elseif rankType == 3 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MultiPvpView,
      viewdata = {
        tab = PanelConfig.WarbandModelView.tab
      }
    })
  end
end

function FunctionNpcFunc.OpenCupModeView()
  if CupMode6v6Proxy_MultiServer.Instance:IsCurSeasonRunning() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CompetiveModeView,
      viewdata = "MergeServerCupModeTab"
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CompetiveModeView,
      viewdata = "CupModeTab"
    })
  end
end

function FunctionNpcFunc.ChangePVPAvatar(npc, param, npcFunctionData)
  local sType = PvpProxy.Instance:GetStatueType(npc.data.staticData.id)
  ServiceMessCCmdProxy.Instance:CallSetPvpChampionStatueMessCCmd(sType, {
    type = MessCCmd_pb.ESTATUE_OPTION_APPEARANCE
  })
end

function FunctionNpcFunc.ChangePVPAction(npc, param, npcFunctionData)
  local npcid = npc.data.staticData.id
  local sType = PvpProxy.Instance:GetStatueType(npcid)
  local config = GameConfig.PvpStatue.Pose
  local hasaction = false
  local TableActionAnime = Table_ActionAnime
  local npcs = NSceneNpcProxy.Instance:FindNpcs(npcid)
  local statueInfo = PvpProxy.Instance:GetStatueInfo(sType)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      DialogUtil.GetDialogData(396138).Text
    },
    callback = function()
      statueInfo:UpdatePose()
    end,
    forceNotify = true
  }
  local index = statueInfo and TableUtility.ArrayFindIndex(config, statueInfo.pose) or 0
  viewdata.addfunc = {
    [1] = {
      NameZh = ZhString.FunctionNpcFunc_ChangeActionLast,
      event = function()
        index = index - 1
        if index < 1 then
          index = #config
        end
        statueInfo:UpdatePose(config[index])
      end
    },
    [2] = {
      NameZh = ZhString.FunctionNpcFunc_ChangeActionNext,
      event = function()
        index = index + 1
        if index > #config then
          index = 1
        end
        statueInfo:UpdatePose(config[index])
      end
    },
    [3] = {
      NameZh = ZhString.FunctionNpcFunc_ChangeActionSave,
      event = function()
        ServiceMessCCmdProxy.Instance:CallSetPvpChampionStatueMessCCmd(sType, {
          type = MessCCmd_pb.ESTATUE_OPTION_POSE,
          value = config[index]
        })
      end,
      closeDialog = true
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.OpenAchieveRewardView(npc, params, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.AchieveRewardView, {groupid = params, npc = npc})
end

function FunctionNpcFunc.CheckWildTransfer(npc, param)
  local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
  if not amIMonthlyVIP then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckQuickTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckLaboratoryTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckDojoTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckEndLessTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckAstrolabe(npc, param)
  if FunctionUnLockFunc.Me():CheckCanOpen(5000) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckCatLitterBox(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX)
end

function FunctionNpcFunc.CheckGuildStoreAuto(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_BAR)
end

function FunctionNpcFunc.CheckStoreAuto(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_VENDING_MACHINE)
end

function FunctionNpcFunc.CheckSewing(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
end

function FunctionNpcFunc.CheckGetGuildWelfare()
  if GuildProxy.Instance:HasGuildWelfare() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckArtifactMake(npc, param)
  if ArtifactProxy.Type.WeaponArtifact == param then
    return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
  elseif ArtifactProxy.Type.HeadBackArtifact == param then
    return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_ARTIFACT_HEAD)
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckArtifactDecompose(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    if myMemberData.job == 1 or myMemberData.job == 2 then
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckGuildHoldTreasure(npc, param)
  local hasHoldTreasure = GuildTreasureProxy.Instance:HasGuildHoldTreasure()
  if hasHoldTreasure and GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.checkBuildingActiveSelf(type)
  if not GuildProxy.Instance:IHaveGuild() then
    return NpcFuncState.InActive
  end
  local data = GuildBuildingProxy.Instance:GetBuildingDataByType(type)
  if data then
    if nil ~= data:GetCondMenu() then
      return NpcFuncState.InActive
    else
      return NpcFuncState.Active
    end
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckOpenGuildRaid(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    local leftRaidTime = myGuildData.nextraidTime - ServerTime.CurServerTime() / 1000
    local canOpenRaid = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.OpenGuildRaid)
    if leftRaidTime <= 0 and canOpenRaid then
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.InActiveNpcFunc(npc, param)
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckGiveUpGuildLand(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return NpcFuncState.InActive
  end
  if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GiveUpLand) then
    local cdTime = myGuildData:GetGiveupCityTime()
    if cdTime and 0 < cdTime then
      return NpcFuncState.Active, ZhString.FunctionNpcFunc_CancelGiveUpGuildLand
    else
      return NpcFuncState.Active, ZhString.FunctionNpcFunc_GiveUpGuildLand
    end
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckOpenBuildingSubmitMat(npc, param)
  if not Game.MapManager:IsInGuildMap() then
    return NpcFuncState.InActive
  end
  local data = GuildBuildingProxy.Instance:GetCurBuilding()
  if data and param == data.type and data.level >= 0 then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckOpenGuildFunction(npc, param)
  if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.OpenGuildFunction) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckOpenGuildChallengeTaskView(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return NpcFuncState.InActive
  end
  if not myGuildData:CheckFunctionOpen(GuildCmd_pb.EGUILDFUNCTION_BUILDING) then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckHighRefine(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
end

function FunctionNpcFunc.CheckWeddingDay(npc, param)
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckBookingWedding(npc, param)
  if not WeddingProxy.Instance:IsSelfEngage() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckCancelWedding(npc, param)
  local _WeddingProxy = WeddingProxy.Instance
  if _WeddingProxy:IsSelfEngage() and not _WeddingProxy:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckWeddingCememony(npc, param)
  if WeddingProxy.Instance:IsSelfMarried() then
    return NpcFuncState.InActive
  end
  if WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckConsentDivorce(npc, param)
  if WeddingProxy.Instance:IsSelfMarried() and not WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckUnilateralDivorce(npc, param)
  if WeddingProxy.Instance:CanSingleDivorce() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterRollerCoaster(npc, param)
  if WeddingProxy.Instance:IsSelfMarried() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterWeddingMap(npc, param)
  if WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  local marryInviteLetters = BagProxy.Instance:GetMarryInviteLetters()
  for i = 1, #marryInviteLetters do
    local weddingData = marryInviteLetters[i].weddingData
    if weddingData and weddingData:CheckInWeddingTime() then
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckTakeMarryCarriage(npc, param)
  if WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterPveCard(npc, param, npcFunctionId)
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckShowPveCard(npc, param, npcFunctionId)
  local config = GameConfig.SystemForbid.ShowPveCard
  if config and param and param == 4 then
    return NpcFuncState.InActive
  end
  if param then
    local cfg = GameConfig.FuncState_eps_func and GameConfig.FuncState_eps_func.npcfunc and GameConfig.FuncState_eps_func.npcfunc[npcFunctionId]
    if cfg and not FunctionUnLockFunc.checkFuncStateValid(cfg[param]) then
      return NpcFuncState.InActive
    end
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckGvgLand()
  local groupid = GvgProxy.Instance:GetCurMapGvgGroupID()
  if groupid < 0 then
    return NpcFuncState.InActive
  end
  local staticData = GvgProxy.TryGetStaticLobbyStrongHold()
  if not staticData then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckReturnArtifact(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_ARTIFACT_HEAD) or FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
end

function FunctionNpcFunc.CheckRetrieveAllArtifacts(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    if myMemberData.job == 1 then
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckHeadWearStart(npc, param)
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckPray(npc, param)
  if GuildPrayProxy.CheckPrayForbidden() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckBless(npc, param)
  if GuildPrayProxy.CheckGvgPrayForbidden() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckHolyBless(npc, param)
  if GuildPrayProxy.CheckHolyPrayForbidden() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckGuildPray4(npc, param)
  if GuildPrayProxy.CheckPray4Forbidden() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckDisneyTeam(npc, param)
  if DisneyStageProxy.Instance.isrunning == false then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckChangeClothColor(npc, param)
  local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local forbidFeature = Table_Class[myClass].Feature and Table_Class[myClass].Feature & 4 > 0
  if forbidFeature or myClass % 10 ~= 4 then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckEnterCapraActivity()
  local actId = GameConfig.Activity.SaveCapra and GameConfig.Activity.SaveCapra.ActivityID or 6
  local running = FunctionActivity.Me():IsActivityRunning(actId)
  if not running then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckCreateGuild(npc)
  if GuildProxy.Instance:IHaveGuild() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckExitGuild(npc, param)
  if GuildProxy.Instance:IHaveGuild() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEquipCompose(npc, param)
  if FunctionUnLockFunc.Me():CheckCanOpen(param) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckHireCatConfirm(npc, param)
  if FunctionUnLockFunc.Me():CheckCanOpen(param[2]) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

local checkSummonDeadBoss = function(difficulty)
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.InActive
  end
  return 0 < getSummonDeadBossCount(difficulty) and NpcFuncState.Grey or NpcFuncState.Active
end

function FunctionNpcFunc.CheckSummonDeadBoss()
  return checkSummonDeadBoss()
end

function FunctionNpcFunc.CheckSummonDeadBoss2()
  return checkSummonDeadBoss(FuBenCmd_pb.EDEADBOSSDIFF_NORMAL)
end

function FunctionNpcFunc.CheckSummonDeadBoss3()
  return checkSummonDeadBoss(FuBenCmd_pb.EDEADBOSSDIFF_HARD)
end

function FunctionNpcFunc.CheckSummonDeadBoss4()
  return checkSummonDeadBoss(FuBenCmd_pb.EDEADBOSSDIFF_SUPER)
end

function FunctionNpcFunc.CheckSelectTeamPwsEffect(npc, param)
  if not Game.MapManager:IsPVPMode_TeamPws() then
    return NpcFuncState.InActive
  end
  if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckTypeFunc_Shop(npc, param)
  if npc and npc.data and npc.data.staticData then
    npcFunction = npc.data.staticData.NpcFunction
  end
  if npcFunction then
    for _, v in pairs(npcFunction) do
      local NameEn = v.type and Table_NpcFunction[v.type] and Table_NpcFunction[v.type].NameEn
      if NameEn and (NameEn == "GuildMaterialShop" or NameEn == "GuildMaterialShop_Leader") then
        local bd = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_EGUILDBUILDING_MATERIAL_MACHINE)
        if bd and nil == bd:GetCondMenu() then
          if NameEn == "GuildMaterialShop" then
            return NpcFuncState.Active
          elseif NameEn == "GuildMaterialShop_Leader" then
            local myGuildMD = GuildProxy.Instance:GetMyGuildMemberData()
            if myGuildMD and myGuildMD.job == GuildCmd_pb.EGUILDJOB_CHAIRMAN then
              return NpcFuncState.Active
            else
              return NpcFuncState.InActive
            end
          end
        else
          return NpcFuncState.InActive
        end
      end
    end
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckRoguelike(npc, param, funcStaticId)
  npcFunction = npc and npc.data and npc.data.staticData and npc.data.staticData.NpcFunction
  if not npcFunction then
    return NpcFuncState.InActive
  end
  local staticFunc, name = Table_NpcFunction[funcStaticId]
  if staticFunc then
    name = DungeonProxy.Instance:GetRoguelikeNpcOptionName(npc.data.staticData.id, staticFunc.Parama.Option)
  end
  return name and NpcFuncState.Active or NpcFuncState.InActive, name
end

function FunctionNpcFunc.FourthSkillCostGet(npc, param)
  if ProfessionProxy.Instance:GetDepthByClassId(MyselfProxy.Instance:GetMyProfession()) < 5 then
    MsgManager.ShowMsgByID(12100)
    return
  end
  ServiceNUserProxy.Instance:CallFourthSkillCostGetUserCmd()
end

function FunctionNpcFunc.AppForward(npc, param)
  helplog("AppForward")
  if param and param.id then
    if not param.exparam then
      FunctionAppForward.Me():AppForwardByID(param.id)
    elseif "table" == type(param.exparam) then
      FunctionAppForward.Me():AppForwardByID(param.id, unpack(param.exparam))
    else
      FunctionAppForward.Me():AppForwardByID(param.id, param.exparam)
    end
  end
end

function FunctionNpcFunc.CheckGetPveCardReward(npc, param)
  local npcSData = npc.data.staticData
  if npcSData == nil then
    return NpcFuncState.InActive
  end
  if QuestSymbolCheck.HasPveCardSymbolCheck(npcSData) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckExpRaid()
  if Game.MapManager:IsPVEMode_ExpRaid() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterNextRaidGroup()
  local teamProxy = TeamProxy.Instance
  if teamProxy:IHaveGroup() then
    if teamProxy:CheckIHaveGroupLeaderAuthority() then
      return NpcFuncState.Active
    end
  elseif teamProxy:CheckIHaveLeaderAuthority() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckPrestige_Shop(npc, param)
  local npcid = npc.data.staticData.id
  local prestigedata = PrestigeProxy.Instance:GetPrestigeDataByNPC(npcid)
  if prestigedata and prestigedata:CheckCampOpen() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckAtMyselfHome(npc, param)
  if HomeManager.Me():IsAtMyselfHome() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckHomeClearAllFurnitures(npc, param)
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  if curHouseData and not curHouseData:IsFinishedGuide() then
    return NpcFuncState.InActive
  end
  return FunctionNpcFunc.CheckAtMyselfHome(npc, param)
end

function FunctionNpcFunc:CheckFuncStatelist(typeid)
  if not GameConfig.FuncStateChecklist then
    return false
  end
  for k, v in pairs(GameConfig.FuncStateChecklist) do
    if 0 ~= TableUtility.ArrayFindIndex(v.NpcFunction, typeid) and self:CheckSingleFuncForbidState(v.id) then
      return true
    end
  end
  return false
end

function FunctionNpcFunc.CheckAncientRelicsShop(npc, param)
  if FunctionUnLockFunc.Me():CheckCanOpen(10014) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

local invalidFuncState, invalidFuncTime = {}, {}

function FunctionNpcFunc:CheckSingleFuncForbidState(funcStateID)
  local singleCFG = Table_FuncState[funcStateID]
  if not singleCFG then
    if not invalidFuncState[funcStateID] then
      redlog(string.format("Cannot Find State %s", funcStateID))
      invalidFuncState[funcStateID] = 1
    end
    return false
  end
  local validtime = Table_FuncTime[singleCFG.TimeID]
  if not validtime then
    if not invalidFuncTime[singleCFG.TimeID] then
      redlog(string.format("Cannot Find validtime of TimeID ", singleCFG.TimeID))
      invalidFuncTime[singleCFG.TimeID] = 1
    end
    return false
  end
  if self:CheckServerID(singleCFG.ServerID) then
    local serverTime = ServerTime.CurServerTime()
    if serverTime == nil then
      return false
    end
    serverTime = serverTime / 1000
    if serverTime > validtime.StartTimeStamp and serverTime < validtime.EndTimeStamp then
      return true
    end
  end
  return false
end

function FunctionNpcFunc:CheckServerID(ServerIDs)
  if not ServerIDs or #ServerIDs == 0 then
    return false
  end
  local server = FunctionLogin.Me():getCurServerData()
  local linegroup = 0
  if server then
    linegroup = server.linegroup or 1
  end
  if ServerIDs then
    for n, m in pairs(ServerIDs) do
      if m == linegroup then
        return true
      end
    end
  end
  return false
end

function FunctionNpcFunc.CheckGem()
  if FunctionUnLockFunc.Me():CheckCanOpen(6200) then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckCommonMenuLock(npc, param)
  local _unlockFunc = FunctionUnLockFunc.Me()
  local lock = false
  for i = 1, #param.menuid do
    if not _unlockFunc:CheckCanOpen(param.menuid[i]) then
      lock = true
      break
    end
  end
  if lock then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckGemCarve()
  if FunctionUnLockFunc.Me():CheckCanOpen(6209) then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckGem3to1()
  if FunctionUnLockFunc.Me():CheckCanOpen(6201) then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckGem5to1()
  if FunctionUnLockFunc.Me():CheckCanOpen(6202) then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckGemSameName()
  if FunctionUnLockFunc.Me():CheckCanOpen(6203) then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckHairEye(nnpc, param)
  return FunctionNpcFunc.CheckDoramShopDressing(nnpc, param[1])
end

function FunctionNpcFunc.CheckDoramShopDressing(npc, param)
  local _, isStaticDoram = GetShopType(npc, param)
  local isDoram = Game.Myself.data:IsDoram()
  if isDoram and isStaticDoram == 1 then
    return NpcFuncState.Active
  end
  if not isDoram and isStaticDoram == 0 then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckTechTree()
  if TechTreeProxy.Instance:CheckTechTreeUnlock() then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckEditHeadText(npc, param)
  local headText = npc.data.userdata:GetBytes(UDEnum.HEAD_TEXT)
  if headText ~= nil and headText ~= "" then
    return NpcFuncState.InActive
  else
    return NpcFuncState.Active
  end
end

function FunctionNpcFunc:CheckDonate(npc, param)
  if DonateProxy.Instance:CheckActivityValid(param) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEditDefaultDialog(npc, param)
  local headText = npc.data.userdata:GetBytes(UDEnum.NPC_DIALOG)
  if headText ~= nil and headText ~= "" then
    return NpcFuncState.InActive
  else
    return NpcFuncState.Active
  end
end

function FunctionNpcFunc.CheckDeadBossSummon(npc, params)
  return getDeadBossSummonFinished(params) and NpcFuncState.Grey or NpcFuncState.Active
end

function FunctionNpcFunc:CheckBifrostSubmitMaterial(npc, param)
  if ActivityCmd_pb.GACTIVITY_BIFROST and FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_BIFROST) then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc:CheckPersonalEndlessTower(npc, param)
  local maxLayer = GameConfig.endlessPrivate.MaxLevel or 100
  local layer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ENDLESS_PRIVATE_LAYER) or 0
  if maxLayer > layer then
    return NpcFuncState.Active
  else
    return NpcFuncState.InActive
  end
end

function FunctionNpcFunc.CheckVisitLightPuzzleObj(npc, param)
  local npcId = npc.data.staticData.id
  if LightPuzzleManager.Me():CheckLightPuzzleSolvedByNpc(npcId) then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckEnterManorRaid(npc, param)
  local menuid = GameConfig.Manor.NeedMenuID or 9930
  if FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
    return NpcFuncState.Active
  end
  redlog("庄园入口条件不满足")
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckAierBlacksmith(npc, param)
  if not GameConfig.Smithy.func_need_menu then
    return NpcFuncState.Active
  end
  local menuid = GameConfig.Smithy.func_need_menu
  if FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
    return NpcFuncState.Active
  end
  redlog("条件不满足")
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckDriftBottlePanel(npc, param)
  local bottleList = DriftBottleProxy.Instance:GetAcceptBottleList()
  if bottleList then
    for k, v in pairs(bottleList) do
      if k then
        return NpcFuncState.Active
      end
    end
  end
  MsgManager.ShowMsgByID(41493)
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckDirectPassFunc(npc, param)
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckCookMaster(npc, param)
  local dailyReward = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_COOK_GAME_DAILY_REWARD) or 0
  if 1 <= dailyReward then
    return NpcFuncState.InActive
  end
  local dailyCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_COOK_GAME_DAILY_DAY_LIMIT) or 0
  local dailyLimit = GameConfig.CookGame.daily_play_limit_day or 3
  xdlog("今日厨王争霸赛挑战次数", dailyCount)
  if dailyCount >= dailyLimit then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckRunGameEnter(npc, param)
  local dailyReward = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_RACE_GAME_DAILY_REWARD) or 0
  if 1 <= dailyReward then
    return NpcFuncState.InActive
  end
  local dailyCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_RACE_GAME_DAILY_DAY_LIMIT) or 0
  local dailyLimit = GameConfig.CookGame.daily_race_limit_day or 3
  xdlog("今日赛跑挑战次数", dailyCount)
  if dailyCount >= dailyLimit then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckPartnerGift(npc, param)
  local npcid = npc and npc.data.staticData.id
  if not Table_ManorPartner then
    return NpcFuncState.InActive
  end
  local partnerInfo = ManorPartnerProxy.Instance:GetPartnerInfo(npcid)
  if not partnerInfo then
    return NpcFuncState.InActive
  end
  local curMaxfavor = partnerInfo.maxFavor
  local curFavor = partnerInfo.favor
  if curMaxfavor <= curFavor then
    return NpcFuncState.InActive
  end
  local hasFavorItem = false
  local itemFavor = ComodoBuildingProxy.Instance.partnerFavoredItemsMap[npcid]
  if itemFavor then
    for i = 1, #itemFavor do
      if BagProxy.Instance:GetItemNumByStaticID(itemFavor[i][1], GameConfig.PackageMaterialCheck.Exist) > 0 then
        hasFavorItem = true
        break
      end
    end
  end
  return hasFavorItem and NpcFuncState.Active or NpcFuncState.InActive
end

local testTime

function FunctionNpcFunc.CheckTestCheck(npcguid, param)
  if testTime == nil then
    testTime = ServerTime.CurServerTime() / 1000 + 20
  end
  if ServerTime.CurServerTime() / 1000 < testTime then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEquipRecovery(npc, params)
  return BlackSmithProxy.CheckEquipRecoveryTime() and NpcFuncState.Active or NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEquipRecoveryPlus(npc, params)
  return FunctionNpcFunc.CheckEquipRecovery(npc, params)
end

function FunctionNpcFunc.CheckOptStatue(npc, param)
  local npc_static_id = npc.data.staticData.id
  if npc_static_id == GameConfig.GVGConfig.StatuePedestalNpcID then
    return GvgProxy.Instance:CanOptStatue() and NpcFuncState.Active or NpcFuncState.InActive
  else
    local newGvgStatue = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatuePedestalNpcID
    if newGvgStatue and npc_static_id == newGvgStatue then
      local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
      if not group_id or group_id == 0 then
        return NpcFuncState.InActive
      end
      local unique_id = npc.data.uniqueid
      local city_id = GvgProxy.GetStatueCity(unique_id)
      if city_id then
        local leaderId = GvgProxy.Instance:GetStatueLeaderIdByCityId(group_id, city_id)
        if leaderId and leaderId == Game.Myself.data.id then
          return NpcFuncState.Active
        end
      end
      return NpcFuncState.InActive
    end
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckOpenSandTable(npc, param)
  local b = GvgProxy.Instance:GetGvgOpenFireState()
  if not b then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckLv_strengthen()
  return FunctionUnLockFunc.Me():CheckCanOpen(7)
end

function FunctionNpcFunc.CheckLv_Refine()
  return FunctionUnLockFunc.Me():CheckCanOpen(4)
end

function FunctionNpcFunc.CheckLv_SeniorEnchant()
  return FunctionUnLockFunc.Me():CheckCanOpen(73)
end

function FunctionNpcFunc.GvGCooking()
  if GVGCookingHelper.Me().m_creature ~= nil then
    redlog("已有铁锅大乱炖npc")
    return
  end
  local itemId = GVGCookingHelper.Me().m_itemId
  local count = BagProxy.Instance:GetItemNumByStaticID(itemId)
  if count == nil or count <= 0 then
    MsgManager.ShowMsgByID(43175)
    return
  end
  MsgManager.ConfirmMsgByID(43171, function()
    local itemData = BagProxy.Instance:GetItemByStaticID(itemId)
    if itemData then
      FunctionItemFunc.TryUseItem(itemData, nil, 1)
    end
  end)
end

function FunctionNpcFunc.CheckDoQuench(npc, param)
  local unlockConfig = GameConfig.ShadowEquip.PosUnlock
  if not unlockConfig then
    return NpcFuncState.InActive
  end
  for k, v in pairs(unlockConfig) do
    local menuid = v.UnlockMenu
    if menuid and FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
      return NpcFuncState.Active
    end
  end
end

function FunctionNpcFunc.CheckOpenMountDressingView(npc, param, npcFuncId)
  local npcFuncConfig = Table_NpcFunction[npcFuncId]
  local menuId = npcFuncConfig.Parama and npcFuncConfig.Parama.MenuID
  local isMenuUnlock = FunctionUnLockFunc.Me():CheckCanOpen(menuId)
  local mountId = param or GameConfig.MountFashion.DefaultFashionMountId
  local item = BagProxy.Instance:GetItemByStaticID(mountId)
  local isStored = false
  if not item then
    item = BagProxy.Instance:GetItemByStaticID(mountId, BagProxy.BagType.RoleEquip)
    if not item then
      isStored = AdventureDataProxy.Instance:IsMountStored(mountId)
    end
  end
  if isMenuUnlock and (item or isStored) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckShowPrestigeInfo(npc, param)
  if param then
    local menuid = GameConfig.Prestige and GameConfig.Prestige.PrestigeUnlockMenu and GameConfig.Prestige.PrestigeUnlockMenu[param]
    if not menuid or FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
      return NpcFuncState.Active
    else
      return NpcFuncState.InActive
    end
  else
    return NpcFuncState.Active
  end
end

function FunctionNpcFunc.CheckBatteryCannon(npc, param)
  do return NpcFuncState.Active end
  local cannon_skill = param.CannonSkill
  local has_any_bullet = false
  for i = 1, #cannon_skill do
    local skill_id = cannon_skill[i]
    local need_bullet = GameConfig.BatteryCannon and GameConfig.BatteryCannon.CannonSkill and GameConfig.BatteryCannon.CannonSkill[skill_id]
    need_bullet = need_bullet and need_bullet.shot
    local own = BagProxy.Instance:GetItemNumByStaticID(need_bullet, GameConfig.PackageMaterialCheck.Exist or {10})
    if 0 < own then
      has_any_bullet = true
      break
    end
  end
  if has_any_bullet then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.StartRaid(nnpc, param, npcFunctionData)
  local raidtype = npcFunctionData and npcFunctionData.Parama and npcFunctionData.Parama.raidtype
  if raidtype then
    ServiceFuBenCmdProxy.Instance:CallOpenNtfFuBenCmd(raidtype)
  end
end

function FunctionNpcFunc.CheckStartRaid(nnpc, param)
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end

function FunctionNpcFunc.CheckOpenSpecialSkillUpgradeView(npc, param)
  local skillId = param
  local professionSkill = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
  local skillData = professionSkill:FindSkillById(skillId)
  if skillData then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckGVGRoadBlock(npc, param)
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckLaunchFirework(npc, param)
  local ownerid = npc and npc.data and npc.data.ownerID
  local isMyFirework = ownerid and ownerid == Game.Myself.data.id
  if isMyFirework then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckRemoveFirework(npc, param)
  local ownerid = npc and npc.data and npc.data.ownerID
  local isMyFirework = ownerid and ownerid == Game.Myself.data.id
  if isMyFirework then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckOpenPveMonsterPopup(npc, params)
  if params and 0 < #params then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterBigCatInvadeActivity(npc, params)
  local actId = GameConfig.Activity.BigCatInvade and GameConfig.Activity.BigCatInvade.ActivityID
  local isrunning = FunctionActivity.Me():IsActivityRunning(actId)
  if isrunning then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckQueryPrice(npc, params)
  if ChangeZoneProxy.Instance:CheckServerCanQueryPrice() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckReceiveTripleTeamPwsTargetReward(npc, params)
  local canReceive = PvpProxy.Instance:IsTriplePwsTargetRewardCanReceive()
  if canReceive then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckReceiveTripleTeamPwsRankReward(npc, params)
  local canReceive = PvpProxy.Instance:IsTriplePwsRankRewardCanReceive()
  if canReceive then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckAstralRaidNextLevel(npc, params)
  local raidId = Game.MapManager:GetRaidID()
  local entranceData = AstralProxy.Instance:GetNextLevelEntranceDataByRaidId(raidId)
  if entranceData then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckAstralDestinyGraph(npc, params)
  local menuId = GameConfig.Astral and GameConfig.Astral.GraphMenuID
  if FunctionUnLockFunc.Me():CheckCanOpen(menuId) and not AstralProxy.Instance:IsSeasonNotOpen() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckPVPOptStatue(npc, param, funcStaticId)
  local staticFunc = Table_NpcFunction[funcStaticId]
  local stype = PvpProxy.Instance:GetStatueType(npc.data.staticData.id)
  return PvpProxy.Instance:CanOptStatue(stype) and NpcFuncState.Active or NpcFuncState.InActive
end

function FunctionNpcFunc.ReceiveTeamPwsTargetReward(npc, param, funcStaticId)
  ServiceMatchCCmdProxy.Instance:CallChampionPvpPickRewardCmd(MatchCCmd_pb.CHAMPION_REWARD_TEAMPWS)
end

function FunctionNpcFunc.CheckCanReceiveTeamPwsTargetReward(npc, param, funcStaticId)
  if PvpProxy.Instance:CheckChampionPvpRewardStatusCmd(MatchCCmd_pb.CHAMPION_REWARD_TEAMPWS) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.ReceiveTeamPwsTargetRewardMix(npc, param, funcStaticId)
  ServiceMatchCCmdProxy.Instance:CallChampionPvpPickRewardCmd(MatchCCmd_pb.CHAMPION_REWARD_TEAMPWS_CROSS)
end

function FunctionNpcFunc.CheckCanReceiveTeamPwsTargetRewardMix(npc, param, funcStaticId)
  if PvpProxy.Instance:CheckChampionPvpRewardStatusCmd(MatchCCmd_pb.CHAMPION_REWARD_TEAMPWS_CROSS) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.ReceiveTwelveTargetReward(npc, param, funcStaticId)
  ServiceMatchCCmdProxy.Instance:CallChampionPvpPickRewardCmd(MatchCCmd_pb.CHAMPION_REWARD_TWELVE)
end

function FunctionNpcFunc.CheckCanReceiveTwelveTargetReward(npc, param, funcStaticId)
  if PvpProxy.Instance:CheckChampionPvpRewardStatusCmd(MatchCCmd_pb.CHAMPION_REWARD_TWELVE) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.ReceiveTwelveTargetRewardMix(npc, param, funcStaticId)
  ServiceMatchCCmdProxy.Instance:CallChampionPvpPickRewardCmd(MatchCCmd_pb.CHAMPION_REWARD_TWELVE_CROSS)
end

function FunctionNpcFunc.CheckCanReceiveTwelveTargetRewardMix(npc, param, funcStaticId)
  if PvpProxy.Instance:CheckChampionPvpRewardStatusCmd(MatchCCmd_pb.CHAMPION_REWARD_TWELVE_CROSS) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.PresidentPvpRule(npc, param, npcFunctionData)
  local data = Table_Help[npcFunctionData.Parama.helpId]
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  end
end

function FunctionNpcFunc.ChangeMaterial(npc, param, funcStaticId)
  local PvpStatueConfig = GameConfig.PvpStatue
  if not PvpStatueConfig then
    return
  end
  local materialDialogs = PvpStatueConfig.MaterialDialog
  local sType = PvpProxy.Instance:GetStatueType(npc.data.staticData.id)
  local dialogid = PvpStatueConfig.DefaultDialog[sType]
  local materialCount = materialDialogs and #materialDialogs or 0
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {dialogid},
    npcinfo = npc
  }
  viewdata.addfunc = {}
  for i = 1, materialCount do
    local addfunc = {}
    
    function addfunc.event()
      ServiceMessCCmdProxy.Instance:CallSetPvpChampionStatueMessCCmd(sType, {
        type = MessCCmd_pb.ESTATUE_OPTION_MATERIAL,
        value = materialDialogs[i].buffID
      })
    end
    
    addfunc.closeDialog = true
    addfunc.NameZh = materialDialogs[i].name
    viewdata.addfunc[i] = addfunc
  end
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionNpcFunc.CheckDungeonMvpCardCompose(npc, param, npcFunctionData)
  local activitys = {}
  for _, v in pairs(Table_ActivityIntegration) do
    if v.Type == 12 then
      activitys[#activitys + 1] = v
    end
  end
  local isUp = false
  for i = 1, #activitys do
    if ActivityIntegrationProxy.Instance:CheckGroupValid(activitys[i].Group) then
      isUp = true
      break
    end
  end
  if isUp then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.OpenAbyssQuestBoard(npc, param, npcFunctionData)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AbyssDailyQuestBoardView,
    viewdata = param
  })
end

function FunctionNpcFunc.CheckOpenAbyssQuestBoard(npc, param)
  local config = GameConfig.Prestige and GameConfig.Prestige.PrestigeUnlockMenu
  local menuId = config and config[param]
  redlog("CheckOpenAbyssQuestBoard", menuId)
  if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.OpenInheritSkillView(npc, param, npcFunctionData)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.InheritSkillView
  })
end

function FunctionNpcFunc.OpenInheritSkillExtendCostPointPopUp(npc, param, npcFunctionData)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.InheritSkillExtendCostPointPopUp
  })
end

function FunctionNpcFunc.CheckOpenInheritSkillView(npc, param, npcFunctionData)
  local menuId = param and param.menuid
  redlog("FunctionNpcFunc.CheckOpenInheritSkillView", tostring(menuId), tostring(FunctionUnLockFunc.Me():CheckCanOpen(menuId)))
  if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckOpenInheritSkillExtendCostPointPopUp(npc, param, npcFunctionData)
  local menuId = param and param.menuid
  if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end

function FunctionNpcFunc.CardUpgrade(npc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, {npcdata = npc, tabIndex = 1706})
end

function FunctionNpcFunc.CheckCardUpgrade(npc, param, npcFunctionData)
  if not Game.CardUpgradeMap or not next(Game.CardUpgradeMap) then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end
