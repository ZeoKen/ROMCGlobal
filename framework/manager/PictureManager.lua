PictureManager = class("PictureManager")
PictureManager.Config = {
  Pic = {
    Card = "GUI/pic/Card/",
    Illustration = "GUI/pic/Illustration/",
    Loading = "GUI/pic/Loading/",
    UI = "GUI/pic/UI/",
    Map = "GUI/pic/Map/",
    MonthCard = "GUI/pic/MonthCard/",
    ZenyShopNPC = "GUI/pic/ZenyShopNPC/",
    Star = "GUI/pic/Star/",
    PetRenderTexture = "GUI/pic/Model/",
    Auction = "GUI/pic/Auction/",
    Quota = "GUI/pic/Quota/",
    GuildBuilding = "GUI/pic/GuildBuilding/",
    Recall = "GUI/pic/Recall/",
    EPCard = "GUI/pic/EPCard/",
    Wedding = "GUI/pic/Wedding/",
    PetWorkSpace = "GUI/pic/PetWorkSpace/",
    Stage = "GUI/pic/Stage/",
    PVP = "GUI/pic/PVP/",
    ExchangeShop = "GUI/pic/ExchangeShop/",
    MiniMap = "GUI/pic/miniMap/",
    TransmitterScene = "GUI/pic/TransmitterScene/",
    ExpRaid = "GUI/pic/ExpRaid/",
    SignIn = "GUI/pic/SignIn/",
    Puzzle = "GUI/pic/Puzzle/",
    Servant = "GUI/pic/Servant/",
    LotteryCover = "GUI/pic/LotteryMech/",
    Camera = "GUI/pic/Camera/",
    NPCLiHui = "GUI/pic/npclihui/",
    BattleManualPanel = "GUI/pic/BattleManualPanel/",
    Home = "GUI/pic/Home/",
    HomeBluePrint = "GUI/pic/HomeBluePrint/",
    Profession = "GUI/pic/Profession/",
    AppIcon = "GUI/pic/APPIcon/",
    HitPolly = "GUI/pic/HitPolly/",
    PaySignIn = "GUI/pic/PaySignIn/",
    Push = "GUI/pic/Push/",
    Journal = "GUI/pic/Journal/",
    Activity = "GUI/pic/activity/",
    TransferProf = "GUI/pic/College_transfer/",
    RoguelikeTarot = "GUI/pic/RoguelikeTarot/",
    PlotPic = "GUI/pic/NPCpic/",
    DriftBottle = "GUI/pic/Driftbottle/",
    LightPuzzle = "GUI/pic/LightPuzzle/",
    ColorFilling = "GUI/pic/ColorFilling/",
    PlotED = "GUI/pic/PlotED/",
    SevenRoyalFamilies = "GUI/pic/SevenRoyalFamilies/",
    Brick = "GUI/pic/Brick/",
    PlayerReflux = "GUI/pic/Reflux/",
    PlotView = "GUI/pic/PlotView/",
    ReturnActivity = "GUI/pic/ReturnActivity/",
    MindLocker = "GUI/pic/MindLocker/",
    Chapter = "GUI/pic/Chapter/",
    MusicGame = "GUI/pic/MusicGame/",
    LotteryBanner = "GUI/pic/LotteryBanner/",
    DayLogin = "GUI/pic/DayLogin/",
    DailyDeposit = "GUI/pic/DailyDeposit/",
    Hero = "GUI/pic/hero/",
    BattleField = "GUI/pic/BattleField/",
    PreviewSaleRole = "GUI/pic/mallbefore/",
    Accumulative = "GUI/pic/Accumulative/",
    MissionTrack = "GUI/pic/MissionTrack/",
    TriplePvp = "GUI/pic/TriplePvp/",
    MountFashion = "GUI/pic/MountFashion/",
    Postcard = "GUI/pic/postcard/",
    SpeedUp = "GUI/pic/SpeedUp/",
    RoadBlock = "GUI/pic/RoadBlock/",
    FlipCard = "GUI/pic/FlipCard/",
    SpecialSkill = "GUI/pic/SpecialSkill/",
    ClassPic = "GUI/pic/class/",
    EquipRecommend = "GUI/pic/EquipRecommend/",
    SelfChoose = "GUI/pic/SelfChoose/",
    HeroRoad = "GUI/pic/HeroRoad/",
    Astral = "GUI/pic/Astral/",
    ChatRoom = "GUI/pic/ChatRoom/",
    MasterSkill = "GUI/pic/MasterSkill/",
    Abyss = "GUI/pic/Abyss/",
    InheritSkill = "GUI/pic/InheritSkill/"
  }
}
PictureManager.Instance = nil

function PictureManager:ctor()
  self.npclihuiCache = {}
  self.cardCatch = {}
  self.illustrationCache = {}
  self.loadingCache = {}
  self.uiCache = {}
  self.mapCache = {}
  self.monthCardCache = {}
  self.zenyShopNPCCache = {}
  self.starCache = {}
  self.PetRenderTextureCache = {}
  self.auctionCache = {}
  self.quotaCache = {}
  self.GuildBuildindCache = {}
  self.recallCache = {}
  self.epCardCache = {}
  self.weddingCache = {}
  self.petWorkSpaceCache = {}
  self.stageCache = {}
  self.pvpCache = {}
  self.exchangeShopCache = {}
  self.miniMapCache = {}
  self.transmitterSceneCache = {}
  self.expRaidCache = {}
  self.signInCache = {}
  self.puzzleBGCache = {}
  self.servantCache = {}
  self.lotteryCoverCache = {}
  self.cameraCache = {}
  self.homeCache = {}
  self.homeBluePrintCache = {}
  self.BattleManualPanelCache = {}
  self.professionCache = {}
  self.appIconCache = {}
  self.hitPollyCache = {}
  self.paySigninCache = {}
  self.pushCache = {}
  self.journalCache = {}
  self.activityCache = {}
  self.transferProfCache = {}
  self.roguelikeTarotCache = {}
  self.plotPicCache = {}
  self.driftbottleCache = {}
  self.lightPuzzleCache = {}
  self.colorFillingCache = {}
  self.sevenRoyalFamiliesCache = {}
  self.brickCache = {}
  self.playerRefluxCache = {}
  self.plotEDCache = {}
  self.plotViewCache = {}
  self.returnActivityCache = {}
  self.mindLockerCache = {}
  self.chapterCache = {}
  self.musicGameCache = {}
  self.lotterybannerCache = {}
  self.dayLoginCache = {}
  self.dailyDepositCache = {}
  self.heroCache = {}
  self.accumulativeCache = {}
  self.missionTrackCache = {}
  self.triplePvpCache = {}
  self.previewSaleRoleCache = {}
  self.battleFieldCache = {}
  self.mountFashionCache = {}
  self.postcardCache = {}
  self.speedUpCache = {}
  self.roadBlockCache = {}
  self.flipCardCache = {}
  self.specialSkillCache = {}
  self.classPicCache = {}
  self.equipRecommendCache = {}
  self.selfChooseCache = {}
  self.heroRoadCache = {}
  self.astralCache = {}
  self.chatRoomCache = {}
  self.masterSkillCache = {}
  self.abyssCache = {}
  self.inheritSkillCache = {}
  PictureManager.Instance = self
end

function PictureManager:SetBattleManualPanel(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.BattleManualPanel, self.BattleManualPanelCache)
end

function PictureManager:SetNPCLiHui(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.NPCLiHui, self.npclihuiCache)
end

function PictureManager:SetCard(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Card, self.cardCatch)
end

function PictureManager:SetIllustration(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Illustration, self.illustrationCache)
end

function PictureManager:SetLoading(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Loading, self.loadingCache)
end

function PictureManager:SetUI(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.UI, self.uiCache)
end

function PictureManager:SetMonthCardUI(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MonthCard, self.monthCardCache)
end

function PictureManager:SetMap(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Map, self.mapCache)
end

function PictureManager:SetZenyShopNPC(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ZenyShopNPC, self.zenyShopNPCCache)
end

function PictureManager:SetQuota(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Quota, self.quotaCache)
end

function PictureManager:SetGuildBuilding(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.GuildBuilding, self.GuildBuildindCache)
end

function PictureManager:SetStar(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Star, self.starCache)
end

function PictureManager:SetPetRenderTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PetRenderTexture, self.PetRenderTextureCache)
end

function PictureManager:SetAuction(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Auction, self.auctionCache)
end

function PictureManager:SetRecall(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Recall, self.recallCache)
end

function PictureManager:SetEPCardUI(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.EPCard, self.epCardCache)
end

function PictureManager:SetWedding(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Wedding, self.weddingCache)
end

function PictureManager:SetPetWorkSpace(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PetWorkSpace, self.petWorkSpaceCache)
end

function PictureManager:SetExchangeShop(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ExchangeShop, self.exchangeShopCache)
end

function PictureManager:SetStagePart(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Stage, self.stageCache)
end

function PictureManager:SetPVP(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PVP, self.pvpCache)
end

function PictureManager:SetMiniMap(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MiniMap, self.miniMapCache)
end

function PictureManager:SetTransmitterScene(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.TransmitterScene, self.transmitterSceneCache)
end

function PictureManager:SetExpRaid(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ExpRaid, self.expRaidCache)
end

function PictureManager:SetSignIn(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.SignIn, self.signInCache)
end

function PictureManager:SetPuzzleBG(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Puzzle, self.puzzleBGCache)
end

function PictureManager:SetServantBG(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Servant, self.servantCache)
end

function PictureManager:SetLotteryCover(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.LotteryCover, self.lotteryCoverCache)
end

function PictureManager:SetCameraBG(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Camera, self.cameraCache)
end

function PictureManager:SetHome(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Home, self.homeCache)
end

function PictureManager:SetHomeBluePrint(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.HomeBluePrint, self.homeBluePrintCache)
end

function PictureManager:SetProfession(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Profession, self.professionCache)
end

function PictureManager:SetAppIcon(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.AppIcon, self.appIconCache)
end

function PictureManager:SetHitPolly(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.HitPolly, self.hitPollyCache)
end

function PictureManager:SetPaySignIn(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PaySignIn, self.paySigninCache)
end

function PictureManager:SetPushTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Push, self.pushCache)
end

function PictureManager:SetJournalTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Journal, self.journalCache)
end

function PictureManager:SetActivityTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Activity, self.activityCache)
end

function PictureManager:SetTransferProf(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.TransferProf, self.transferProfCache)
end

function PictureManager:SetRoguelikeTarot(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.RoguelikeTarot, self.roguelikeTarotCache)
end

function PictureManager:SetPlotPic(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PlotPic, self.plotPicCache)
end

function PictureManager:SetDriftbottleTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.DriftBottle, self.driftbottleCache)
end

function PictureManager:SetLightPuzzleHandlerTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.LightPuzzle, self.lightPuzzleCache)
end

function PictureManager:SetColorFillingTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ColorFilling, self.colorFillingCache)
end

function PictureManager:SetSevenRoyalFamiliesTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.SevenRoyalFamilies, self.sevenRoyalFamiliesCache)
end

function PictureManager:SetBrickTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Brick, self.brickCache)
end

function PictureManager:SetPlayerRefluxTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PlayerReflux, self.playerRefluxCache)
end

function PictureManager:SetPlotEDTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PlotED, self.plotEDCache)
end

function PictureManager:SetPlotViewTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PlotView, self.plotViewCache)
end

function PictureManager:SetReturnActivityTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ReturnActivity, self.returnActivityCache)
end

function PictureManager:SetMindLockerTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MindLocker, self.mindLockerCache)
end

function PictureManager:SetChapterTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Chapter, self.chapterCache)
end

function PictureManager:SetMusicGameTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MusicGame, self.musicGameCache)
end

function PictureManager:SetLotteryBannerTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.LotteryBanner, self.lotterybannerCache)
end

function PictureManager:SetDayLoginTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.DayLogin, self.dayLoginCache)
end

function PictureManager:SetDailyDepositTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.DailyDeposit, self.dailyDepositCache)
end

function PictureManager:SetHeroTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Hero, self.heroCache)
end

function PictureManager:SetPreviewSaleRoleTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PreviewSaleRole, self.previewSaleRoleCache)
end

function PictureManager:SetBattleFieldTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.BattleField, self.battleFieldCache)
end

function PictureManager:SetAccumulativeTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Accumulative, self.accumulativeCache)
end

function PictureManager:SetMissionTrackTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MissionTrack, self.missionTrackCache)
end

function PictureManager:SetTriplePvpTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.TriplePvp, self.triplePvpCache)
end

function PictureManager:SetMountFashionTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MountFashion, self.mountFashionCache)
end

function PictureManager:SetPostcardTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Postcard, self.postcardCache)
end

function sss()
end

function PictureManager:SetSpeedUpTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.SpeedUp, self.speedUpCache)
end

function PictureManager:SetFlipCardTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.FlipCard, self.flipCardCache)
end

function PictureManager:SetSpecialSkillTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.SpecialSkill, self.specialSkillCache)
end

function PictureManager:SetClassPicTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ClassPic, self.classPicCache)
end

function PictureManager:SetEquipRecommendTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.EquipRecommend, self.equipRecommendCache)
end

function PictureManager:SetSelfChooseTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.SelfChoose, self.selfChooseCache)
end

function PictureManager:SetRoadBlockTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.RoadBlock, self.roadBlockCache)
end

function PictureManager:SetHeroRoadTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.HeroRoad, self.heroRoadCache)
end

function PictureManager:SetAstralTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Astral, self.astralCache)
end

function PictureManager:SetChatRoomTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ChatRoom, self.chatRoomCache)
end

function PictureManager:SetMasterSkillTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MasterSkill, self.masterSkillCache)
end

function PictureManager:SetAbyssTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Abyss, self.abyssCache)
end

function PictureManager:SetInheritSkillTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.InheritSkill, self.inheritSkillCache)
end

function PictureManager:SetTexture(sName, uiTexture, path, cache)
  local rID = path .. sName
  local cacheInfo = cache[sName]
  if cacheInfo == nil then
    cacheInfo = {}
    cache[sName] = cacheInfo
  end
  cacheInfo[1] = rID
  if cacheInfo[2] then
    cacheInfo[2] = cacheInfo[2] + 1
  else
    cacheInfo[2] = 1
  end
  Game.AssetManager_UI:LoadAsset(rID, Texture, PictureManager._LoadTexture, uiTexture)
  return true
end

function PictureManager._LoadTexture(uiTexture, asset)
  uiTexture.mainTexture = asset
end

function PictureManager.ReFitManualHeight(uiTexture)
  if not uiTexture or not uiTexture.mainTexture then
    return
  end
  local scale = 720 / uiTexture.mainTexture.height
  uiTexture.height = 720
  uiTexture.width = uiTexture.mainTexture.width * scale
end

function PictureManager.ReFitFullScreen(uiTexture, exVal)
  exVal = exVal or 1
  local width, height, scale = UIManagerProxy.Instance:GetMyMobileScreenSize(2 * exVal)
  if width / height > uiTexture.width / uiTexture.height then
    scale = width / uiTexture.width
    uiTexture.width = width
    uiTexture.height = uiTexture.height * scale
  else
    scale = height / uiTexture.height
    uiTexture.height = height
    uiTexture.width = uiTexture.width * scale
  end
end

function PictureManager:UnLoadBattleManualPanel(sName, uiTexture)
  self:UnLoadTexture(self.BattleManualPanelCache, sName, uiTexture)
end

function PictureManager:UnLoadNPCLiHui(sName, uiTexture)
  self:UnLoadTexture(self.npclihuiCache, sName, uiTexture)
end

function PictureManager:UnLoadCard(sName, uiTexture)
  self:UnLoadTexture(self.cardCatch, sName, uiTexture)
end

function PictureManager:UnLoadIllustration(sName, uiTexture)
  self:UnLoadTexture(self.illustrationCache, sName, uiTexture)
end

function PictureManager:UnLoadLoading(sName, uiTexture)
  self:UnLoadTexture(self.loadingCache, sName, uiTexture)
end

function PictureManager:UnLoadUI(sName, uiTexture)
  self:UnLoadTexture(self.uiCache, sName, uiTexture)
end

function PictureManager:UnLoadUIAndClearCache(sName, uiTexture)
  self:UnLoadTextureAndClearCache(self.uiCache, sName, uiTexture)
end

function PictureManager:UnLoadMap(sName, uiTexture)
  self:UnLoadTexture(self.mapCache, sName, uiTexture)
end

function PictureManager:UnLoadMonthCard(sName, uiTexture)
  self:UnLoadTexture(self.monthCardCache, sName, uiTexture)
end

function PictureManager:UnLoadZenyShopNPC(sName, uiTexture)
  self:UnLoadTexture(self.zenyShopNPCCache, sName, uiTexture)
end

function PictureManager:UnLoadStar(sName, uiTexture)
  self:UnLoadTexture(self.starCache, sName, uiTexture)
end

function PictureManager:UnloadPetTexture(sName, uiTexture)
  self:UnLoadTexture(self.PetRenderTextureCache, sName, uiTexture)
end

function PictureManager:UnLoadAuction(sName, uiTexture)
  self:UnLoadTexture(self.auctionCache, sName, uiTexture)
end

function PictureManager:UnLoadQuota(sName, uiTexture)
  self:UnLoadTexture(self.quotaCache, sName, uiTexture)
end

function PictureManager:UnloadGuildBuilding(sName, uiTexture)
  self:UnLoadTexture(self.GuildBuildindCache, sName, uiTexture)
end

function PictureManager:UnLoadRecall(sName, uiTexture)
  self:UnLoadTexture(self.recallCache, sName, uiTexture)
end

function PictureManager:UnLoadWedding(sName, uiTexture)
  self:UnLoadTexture(self.weddingCache, sName, uiTexture)
end

function PictureManager:UnLoadEPCard(sName, uiTexture)
  self:UnLoadTexture(self.epCardCache, sName, uiTexture)
end

function PictureManager:UnloadPetWorkSpace(sName, uiTexture)
  self:UnLoadTexture(self.petWorkSpaceCache, sName, uiTexture)
end

function PictureManager:UnloadExchangeShop(sName, uiTexture)
  self:UnLoadTexture(self.exchangeShopCache, sName, uiTexture)
end

function PictureManager:UnLoadStagePart(sName, uiTexture)
  self:UnLoadTexture(self.stageCache, sName, uiTexture)
end

function PictureManager:UnLoadPVP(sName, uiTexture)
  self:UnLoadTexture(self.pvpCache, sName, uiTexture)
end

function PictureManager:UnLoadMiniMap(sName, uiTexture)
  self:UnLoadTexture(self.miniMapCache, sName, uiTexture)
end

function PictureManager:UnLoadTransmitterScene(sName, uiTexture)
  self:UnLoadTexture(self.transmitterSceneCache, sName, uiTexture)
end

function PictureManager:UnLoadExpRaid(sName, uiTexture)
  self:UnLoadTexture(self.expRaidCache, sName, uiTexture)
end

function PictureManager:UnLoadSignIn(sName, uiTexture)
  self:UnLoadTexture(self.signInCache, sName, uiTexture)
end

function PictureManager:UnLoadPuzzleBG(sName, uiTexture)
  self:UnLoadTexture(self.puzzleBGCache, sName, uiTexture)
end

function PictureManager:UnLoadServantBG(sName, uiTexture)
  self:UnLoadTexture(self.servantCache, sName, uiTexture)
end

function PictureManager:UnLoadLotteryCover(sName, uiTexture)
  self:UnLoadTexture(self.lotteryCoverCache, sName, uiTexture)
end

function PictureManager:UnLoadCameraBG(sName, uiTexture)
  self:UnLoadTexture(self.cameraCache, sName, uiTexture)
end

function PictureManager:UnLoadHome(sName, uiTexture)
  self:UnLoadTexture(self.homeCache, sName, uiTexture)
end

function PictureManager:UnLoadHomeBluePrint(sName, uiTexture)
  self:UnLoadTexture(self.homeBluePrintCache, sName, uiTexture)
end

function PictureManager:UnLoadProfession(sName, uiTexture)
  self:UnLoadTexture(self.professionCache, sName, uiTexture)
end

function PictureManager:UnLoadAppIcon(sName, uiTexture)
  self:UnLoadTexture(self.appIconCache, sName, uiTexture)
end

function PictureManager:UnLoadHitPolly(sName, uiTexture)
  self:UnLoadTexture(self.hitPollyCache, sName.uiTexture)
end

function PictureManager:UnLoadPaySignIn(sName, uiTexture)
  self:UnLoadTexture(self.paySigninCache, sName, uiTexture)
end

function PictureManager:UnloadPushTexture(sName, uiTexture)
  self:UnLoadTexture(self.pushCache, sName, uiTexture)
end

function PictureManager:UnloadJournalTexture(sName, uiTexture)
  self:UnLoadTexture(self.journalCache, sName, uiTexture)
end

function PictureManager:UnloadActivityTexture(sName, uiTexture)
  self:UnLoadTexture(self.activityCache, sName, uiTexture)
end

function PictureManager:UnLoadTransferProf(sName, uiTexture)
  self:UnLoadTexture(self.transferProfCache, sName, uiTexture)
end

function PictureManager:UnLoadRoguelikeTarot(sName, uiTexture)
  self:UnLoadTexture(self.roguelikeTarotCache, sName, uiTexture)
end

function PictureManager:UnLoadPlotPic(sName, uiTexture)
  self:UnLoadTexture(self.plotPicCache, sName, uiTexture)
end

function PictureManager:UnloadDriftbottleTexture(sName, uiTexture)
  self:UnLoadTexture(self.driftbottleCache, sName, uiTexture)
end

function PictureManager:UnloadLightPuzzleHandlerTexture(sName, uiTexture)
  self:UnLoadTexture(self.lightPuzzleCache, sName, uiTexture)
end

function PictureManager:UnloadColorFillingTexture(sName, uiTexture)
  self:UnLoadTexture(self.colorFillingCache, sName, uiTexture)
end

function PictureManager:UnloadSevenRoyalFamiliesTexture(sName, uiTexture)
  self:UnLoadTexture(self.sevenRoyalFamiliesCache, sName, uiTexture)
end

function PictureManager:UnloadBrickTexture(sName, uiTexture)
  self:UnLoadTexture(self.brickCache, sName, uiTexture)
end

function PictureManager:UnloadPlayerRefluxTexture(sName, uiTexture)
  self:UnLoadTexture(self.playerRefluxCache, sName, uiTexture)
end

function PictureManager:UnloadPlotEDTexture(sName, uiTexture)
  self:UnLoadTexture(self.plotEDCache, sName, uiTexture)
end

function PictureManager:UnloadPlotViewTexture(sName, uiTexture)
  self:UnLoadTexture(self.plotViewCache, sName, uiTexture)
end

function PictureManager:UnloadReturnActivityTexture(sName, uiTexture)
  self:UnLoadTexture(self.returnActivityCache, sName, uiTexture)
end

function PictureManager:UnloadMindLockerTexture(sName, uiTexture)
  self:UnLoadTexture(self.mindLockerCache, sName, uiTexture)
end

function PictureManager:UnloadChapterTexture(sName, uiTexture)
  self:UnLoadTexture(self.chapterCache, sName, uiTexture)
end

function PictureManager:UnloadMusicGameTexture(sName, uiTexture)
  self:UnLoadTexture(self.musicGameCache, sName, uiTexture)
end

function PictureManager:UnloadLotteryBannerTexture(sName, uiTexture)
  self:UnLoadTexture(self.lotterybannerCache, sName, uiTexture)
end

function PictureManager:UnloadDayLoginTexture(sName, uiTexture)
  self:UnLoadTexture(self.dayLoginCache, sName, uiTexture)
end

function PictureManager:UnloadDalyDepositTexture(sName, uiTexture)
  self:UnLoadTexture(self.dailyDepositCache, sName, uiTexture)
end

function PictureManager:UnloadHeroTexture(sName, uiTexture)
  self:UnLoadTexture(self.heroCache, sName, uiTexture)
end

function PictureManager:UnloadPreviewSaleRoleTexture(sName, uiTexture)
  self:UnLoadTexture(self.previewSaleRoleCache, sName, uiTexture)
end

function PictureManager:UnloadBattleFieldTexture(sName, uiTexture)
  self:UnLoadTexture(self.battleFieldCache, sName, uiTexture)
end

function PictureManager:UnloadAccumulativeTexture(sName, uiTexture)
  self:UnLoadTexture(self.accumulativeCache, sName, uiTexture)
end

function PictureManager:UnloadMissionTrackTexture(sName, uiTexture)
  self:UnLoadTexture(self.missionTrackCache, sName, uiTexture)
end

function PictureManager:UnloadTriplePvpTexture(sName, uiTexture)
  self:UnLoadTexture(self.triplePvpCache, sName, uiTexture)
end

function PictureManager:UnloadMountFashionTexture(sName, uiTexture)
  self:UnLoadTexture(self.mountFashionCache, sName, uiTexture)
end

function PictureManager:UnloadPostcardTexture(sName, uiTexture)
  self:UnLoadTexture(self.postcardCache, sName, uiTexture)
end

function PictureManager:UnloadSpeedUpTexture(sName, uiTexture)
  self:UnLoadTexture(self.speedUpCache, sName, uiTexture)
end

function PictureManager:UnloadFlipCardTexture(sName, uiTexture)
  self:UnLoadTexture(self.flipCardCache, sName, uiTexture)
end

function PictureManager:UnloadSpecialSkillTexture(sName, uiTexture)
  self:UnLoadTexture(self.specialSkillCache, sName, uiTexture)
end

function PictureManager:UnloadClassPicTexture(sName, uiTexture)
  self:UnLoadTexture(self.classPicCache, sName, uiTexture)
end

function PictureManager:UnloadEquipRecommendTexture(sName, uiTexture)
  self:UnLoadTexture(self.equipRecommendCache, sName, uiTexture)
end

function PictureManager:UnloadSelfChooseTexture(sName, uiTexture)
  self:UnLoadTexture(self.selfChooseCache, sName, uiTexture)
end

function PictureManager:UnloadRoadBlockTexture(sName, uiTexture)
  self:UnLoadTexture(self.roadBlockCache, sName, uiTexture)
end

function PictureManager:UnloadHeroRoadTexture(sName, uiTexture)
  self:UnLoadTexture(self.heroRoadCache, sName, uiTexture)
end

function PictureManager:UnloadAstralTexture(sName, uiTexture)
  self:UnLoadTexture(self.astralCache, sName, uiTexture)
end

function PictureManager:UnloadChatRoomTexture(sName, uiTexture)
  self:UnLoadTexture(self.chatRoomCache, sName, uiTexture)
end

function PictureManager:UnloadMasterSkillTexture(sName, uiTexture)
  self:UnLoadTexture(self.masterSkillCache, sName, uiTexture)
end

function PictureManager:UnloadAbyssTexture(sName, uiTexture)
  self:UnLoadTexture(self.abyssCache, sName, uiTexture)
end

function PictureManager:UnloadInheritSkillTexture(sName, uiTexture)
  self:UnLoadTexture(self.inheritSkillCache, sName, uiTexture)
end

function PictureManager:UnLoadTexture(cache, sName, uiTexture)
  if cache then
    if sName == nil then
      for sName, resInfo in pairs(cache) do
        resInfo[2] = resInfo[2] - 1
        if resInfo[2] <= 0 then
          Game.AssetManager_UI:UnLoadAsset(resInfo[1])
          cache[sName] = nil
          if uiTexture then
            uiTexture.mainTexture = nil
          end
        end
      end
    else
      local resInfo = cache[sName]
      if resInfo then
        resInfo[2] = resInfo[2] - 1
        if resInfo[2] <= 0 then
          Game.AssetManager_UI:UnLoadAsset(resInfo[1])
          cache[sName] = nil
          if uiTexture then
            uiTexture.mainTexture = nil
          end
        end
      end
    end
  end
end

function PictureManager:UnLoadTextureAndClearCache(cache, sName, uiTexture)
  if cache then
    if sName == nil then
      for sName, resInfo in pairs(cache) do
        Game.AssetManager_UI:UnLoadAsset(resInfo[1])
        cache[sName] = nil
        if uiTexture then
          uiTexture.mainTexture = nil
        end
      end
    else
      local resInfo = cache[sName]
      if resInfo then
        Game.AssetManager_UI:UnLoadAsset(resInfo[1])
        cache[sName] = nil
        if uiTexture then
          uiTexture.mainTexture = nil
        end
      end
    end
  end
end
