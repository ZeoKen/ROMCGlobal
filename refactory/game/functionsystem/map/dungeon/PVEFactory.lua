PVEFactory = class("PVEFactory")
local facade = GameFacade.Instance
local notify = function(evtname, body)
  facade:sendNotification(evtname, body)
end
local Dungeon_Handle = class("Dungeon_Handle")

function Dungeon_Handle:ctor()
end

function Dungeon_Handle:Launch()
end

function Dungeon_Handle:Update()
end

function Dungeon_Handle:Shutdown()
end

local PveCard = class("PveCard", Dungeon_Handle)
local dungeonProxyInstance, nSceneNpcProxyInstance, uIUtilFindGO, table_PveCard, pictureManagerInstance

function PveCard:ctor()
  self.isPveCard = true
  self.normalCardEffect_npcguid_map = {}
  self.cardLoadTag_npcguid_map = {}
  self.cardSeted_map = {}
end

function PveCard:Launch()
  notify(PVEEvent.PVE_CardLaunch)
  EventManager.Me():AddEventListener(ServiceEvent.PveCardUpdateProcessPveCardCmd, self.HandleProgressUpdate, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddCreaturesHandler, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.SceneRemoveCreaturesHandler, self)
  dungeonProxyInstance = DungeonProxy.Instance
  nSceneNpcProxyInstance = NSceneNpcProxy.Instance
  uIUtilFindGO = UIUtil.FindGO
  table_PveCard = Table_PveCard
  pictureManagerInstance = PictureManager.Instance
end

function PveCard:HandleProgressUpdate()
  local action_config = GameConfig.CardRaid.play_card_action
  if action_config == nil then
    return
  end
  local table_ActionAnim = Table_ActionAnime
  for npcid, actionid in pairs(action_config) do
    local npcs = NSceneNpcProxy.Instance:FindNpcs(npcid)
    if npcs and npcs[1] then
      local animData = table_ActionAnim[actionid]
      if animData then
        npcs[1]:Client_PlayAction(animData.Name, nil, false)
      end
    end
  end
end

function PveCard:SceneAddCreaturesHandler(creatures)
  local nowProgress = dungeonProxyInstance:GetNowProgress()
  local selectIds = dungeonProxyInstance:GetSelectCardIds()
  if nowProgress == nil or selectIds == nil then
    return
  end
  for i = 1, #creatures do
    local c = creatures[i]
    if c.data and c.data.IsPveCardEffect and c.data:IsPveCardEffect() then
      local cardid = c.data.uniqueid or 111
      self.normalCardEffect_npcguid_map[c.data.id] = cardid
    end
  end
end

function PveCard:SceneRemoveCreaturesHandler(creatureids)
  for k, id in pairs(creatureids) do
    self.normalCardEffect_npcguid_map[id] = nil
    local loadtag = self.cardLoadTag_npcguid_map[id]
    if loadtag ~= nil then
      self.cardLoadTag_npcguid_map[id] = nil
      Game.AssetLoadEventDispatcher:RemoveEventListener(loadtag, PveCard.LoadPicComplete, self)
    end
  end
end

local UPDATE_THRESHOLD = 0.2
local countTime = 0

function PveCard:Update(time, deltaTime)
  if countTime < UPDATE_THRESHOLD then
    countTime = countTime + deltaTime
    return
  end
  countTime = 0
  for npcguid, cardid in pairs(self.normalCardEffect_npcguid_map) do
    self:_SetCardEffectNpcTexture(npcguid, cardid, self.normalCardEffect_npcguid_map, "IsPveCardEffect")
  end
end

local delay_setmap = {}

function PveCard:_SetCardEffectNpcTexture(npcguid, cardid, cacheMap, checkFuncKey)
  local role = nSceneNpcProxyInstance:Find(npcguid)
  if role == nil or role.data[checkFuncKey] == nil or not role.data[checkFuncKey](role.data) then
    return
  end
  local go = role.assetRole.complete.gameObject
  local quadGO = uIUtilFindGO("Quad", go)
  if quadGO == nil then
    quadGO = uIUtilFindGO("Quad_Boss", go)
  end
  if quadGO == nil then
    return
  end
  if delay_setmap[npcguid] == nil then
    delay_setmap[npcguid] = 0
  end
  if delay_setmap[npcguid] < 2 then
    delay_setmap[npcguid] = delay_setmap[npcguid] + 1
    return
  end
  delay_setmap[npcguid] = nil
  cacheMap[npcguid] = nil
  local resStr = table_PveCard[cardid] and table_PveCard[cardid].Resource or "cardback_1"
  if resStr == nil then
    return
  end
  local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
  local loadtag = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. resStr))
  local lt = self.cardLoadTag_npcguid_map[npcguid]
  if lt ~= nil and lt ~= loadtag then
    _AssetLoadEventDispatcher:RemoveEventListener(lt, PveCard.LoadPicComplete, self)
  end
  self.cardLoadTag_npcguid_map[npcguid] = loadtag
  if loadtag ~= nil then
    _AssetLoadEventDispatcher:AddEventListener(loadtag, PveCard.LoadPicComplete, self)
  else
    local r = quadGO:GetComponent(Renderer)
    pictureManagerInstance:SetCard(resStr, r.material)
  end
end

function PveCard:LoadPicComplete(args)
  Game.AssetLoadEventDispatcher:RemoveEventListener(args.assetName, PveCard.LoadPicComplete, self)
  local npcguid
  for k, v in pairs(self.cardLoadTag_npcguid_map) do
    if args.assetName == v then
      npcguid = k
      self.cardLoadTag_npcguid_map[k] = nil
    end
  end
  if args.success then
    local role = nSceneNpcProxyInstance:Find(npcguid)
    if role == nil or role.data.IsPveCardEffect == nil or not role.data.IsPveCardEffect(role.data) then
      return
    end
    local go = role.assetRole.complete.gameObject
    local quadGO = uIUtilFindGO("Quad", go)
    if quadGO == nil then
      quadGO = uIUtilFindGO("Quad_Boss", go)
    end
    if quadGO == nil then
      return
    end
    local cardid = role.data.uniqueid or 111
    local resStr = table_PveCard[cardid] and table_PveCard[cardid].Resource or "cardback_1"
    if resStr == nil then
      return
    end
    local r = quadGO:GetComponent(Renderer)
    pictureManagerInstance:SetCard(resStr, r.material)
  end
end

function PveCard:Shutdown()
  notify(PVEEvent.PVE_CardShutdown)
  EventManager.Me():RemoveEventListener(ServiceEvent.PveCardUpdateProcessPveCardCmd, self.HandleProgressUpdate, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddCreaturesHandler, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.SceneRemoveCreaturesHandler, self)
  PictureManager.Instance:UnLoadCard()
  for k, v in pairs(self.cardLoadTag_npcguid_map) do
    Game.AssetLoadEventDispatcher:RemoveEventListener(v, PveCard.LoadPicComplete, self)
  end
end

function PVEFactory.GetPveCard()
  return PveCard.new()
end

local AltMan = class("AltMan", Dungeon_Handle)

function AltMan:ctor()
  self.isAltman = true
end

function AltMan:Launch()
  notify(PVEEvent.Altman_Launch)
end

function AltMan:Update()
end

function AltMan:Shutdown()
  notify(PVEEvent.Altman_Shutdown)
end

function PVEFactory.GetAltMan()
  return AltMan.new()
end

local ExpRaid = class("ExpRaid")

function ExpRaid:ctor()
  self.isExpRaid = true
end

function ExpRaid:Launch()
  notify(PVEEvent.ExpRaid_Launch)
  notify(MainViewEvent.AddDungeonInfoBord, "MainViewExpRaidPage")
  self.raidStartRoleLevel = MyselfProxy.Instance:RoleLevel()
end

function ExpRaid:Update()
end

function ExpRaid:Shutdown()
  notify(PVEEvent.ExpRaid_Shutdown)
  notify(MainViewEvent.RemoveDungeonInfoBord, "MainViewExpRaidPage")
  self.raidStartRoleLevel = nil
end

function PVEFactory.GetExpRaid()
  return ExpRaid.new()
end

local Thanatos = class("Thanatos", Dungeon_Handle)

function Thanatos:ctor()
  self.isThanatos = true
end

function Thanatos:Launch()
  local setting = FunctionPerformanceSetting.Me()
  local cacheSetting = setting:GetSetting()
  self.beforeSetting = {}
  self.beforeSetting[1] = cacheSetting.screenCount
  self.beforeSetting[2] = cacheSetting.skillEffect
  setting:SetBegin()
  setting:SetScreenCount(FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High))
  setting:SetSkillEffect(true)
  setting:SetEnd()
  Game.GameHealthProtector:SetForceMinPlayerCount(100)
  notify(PVEEvent.PVE_ThanatosLaunch)
end

function Thanatos:Update()
end

function Thanatos:Shutdown()
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetScreenCount(self.beforeSetting[1])
  setting:SetSkillEffect(self.beforeSetting[2])
  setting:SetEnd()
  self.beforeSetting = nil
  Game.GameHealthProtector:SetForceMinPlayerCount(5)
  local sceneUI = Game.Myself:GetSceneUI() or nil
  if sceneUI and sceneUI.roleBottomUI then
    sceneUI.roleBottomUI:ClearSanity()
  end
  notify(PVEEvent.PVE_ThanatosShutdown)
end

function PVEFactory.GetThanatos()
  return Thanatos.new()
end

local IPRaid = class("IPRaid", Dungeon_Handle)

function IPRaid:ctor()
  self.isIPRaid = true
end

function IPRaid:Launch()
  notify(PVEEvent.IPRaid_Launch)
end

function IPRaid:Update()
end

function IPRaid:Shutdown()
  notify(PVEEvent.IPRaid_Shutdown)
end

function PVEFactory.GetIPRaid()
  return IPRaid.new()
end

local ThanksgivingRaid = class("ThanksgivingRaid")

function ThanksgivingRaid:ctor()
  self.isThanksgivingRaid = true
end

function ThanksgivingRaid:Launch()
  notify(PVEEvent.ThanksgivingRaid_Launch)
end

function ThanksgivingRaid:Update()
end

function ThanksgivingRaid:Shutdown()
  notify(PVEEvent.ThanksgivingRaid_Shutdown)
end

function PVEFactory.GetThanksgivingRaid()
  return ThanksgivingRaid.new()
end

local HeadwearRaid = class("HeadwearRaid", Dungeon_Handle)

function HeadwearRaid:ctor()
  self.isHeadwearRaid = true
end

function HeadwearRaid:Launch()
  notify(PVEEvent.NewHeadwearRaid_Launch)
  HeadwearRaidProxy.Instance:InitRaidData()
end

function HeadwearRaid:Update()
end

function HeadwearRaid:Shutdown()
  HeadwearRaidProxy.Instance:Reset()
  notify(MainViewEvent.RemoveDungeonInfoBord, "MainViewHeadwearRaidPage")
end

function PVEFactory.GetHeadwearRaid()
  return HeadwearRaid.new()
end

local HeadwearActivityRaid = class("HeadwearActivityRaid", Dungeon_Handle)

function HeadwearActivityRaid:ctor()
  self.isHeadwearRaid = true
end

function HeadwearActivityRaid:Launch()
  notify(PVEEvent.HeadwearRaid_Launch)
  notify(MainViewEvent.AddDungeonInfoBord, "MainViewHeadwearRaidPage_Activity")
  HeadwearRaidProxy.Instance:InitRaidData(true)
end

function HeadwearActivityRaid:Update()
end

function HeadwearActivityRaid:Shutdown()
  notify(PVEEvent.HeadwearRaid_Shutdown)
  notify(MainViewEvent.RemoveDungeonInfoBord, "MainViewHeadwearRaidPage_Activity")
end

function PVEFactory.GetHeadwearActivityRaid()
  return HeadwearActivityRaid.new()
end

local Roguelike = class("Roguelike")

function Roguelike:ctor()
  self.isRoguelike = true
end

function Roguelike:Launch()
  dungeonProxyInstance = DungeonProxy.Instance
  notify(PVEEvent.Roguelike_Launch)
end

function Roguelike:Update()
end

function Roguelike:Shutdown()
  local raidData = dungeonProxyInstance.roguelikeRaid
  if raidData then
    raidData.grade = 0
  end
  dungeonProxyInstance:RecvRoguelikeTarotInfo()
  notify(PVEEvent.Roguelike_Shutdown)
end

function PVEFactory.GetRoguelike()
  return Roguelike.new()
end

local MiniGame_MonsterQA = class("MiniGame_MonsterQA", Dungeon_Handle)

function MiniGame_MonsterQA:ctor()
  self.isMiniGame_MonsterQA = true
end

function MiniGame_MonsterQA:Launch()
  Game.AutoBattleManager:AutoBattleOff()
  Game.Myself:Client_SetAutoBattle(false)
  facade:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MiniGameMonsterQAPage
  })
  notify(PVEEvent.MiniGameMonsterQA_Launch)
end

function MiniGame_MonsterQA:Shutdown()
  notify(PVEEvent.MiniGameMonsterQA_Shutdown)
end

function PVEFactory.GetMiniGame_MonsterQA()
  return MiniGame_MonsterQA.new()
end

local MiniGame_MonsterShot = class("MiniGame_MonsterShot", Dungeon_Handle)

function MiniGame_MonsterShot:ctor()
  self.isMonsterShot = true
end

function MiniGame_MonsterShot:Launch()
  Game.AutoBattleManager:AutoBattleOff()
  Game.Myself:Client_SetAutoBattle(false)
  notify(PVEEvent.MiniGameMonsterShot_PreLaunch)
  facade:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MiniGameMonsterShotPage
  })
  notify(PVEEvent.MiniGameMonsterShot_Launch)
end

function MiniGame_MonsterShot:Shutdown()
  notify(PVEEvent.MiniGameMonsterShot_Shutdown)
end

function PVEFactory.GetMiniGame_MonsterShot()
  return MiniGame_MonsterShot.new()
end

local DeadBoss = class("DeadBoss", Dungeon_Handle)

function DeadBoss:ctor()
  self.isDeadBoss = true
end

function DeadBoss:Launch()
  notify(PVEEvent.DeadBoss_Launch)
end

function DeadBoss:Update()
end

function DeadBoss:Shutdown()
  notify(PVEEvent.DeadBoss_Shutdown)
end

function PVEFactory.GetDeadBoss()
  return DeadBoss.new()
end

local Einherjar = class("Einherjar", Dungeon_Handle)

function Einherjar:ctor()
  self.isEinherjar = true
end

function Einherjar:Launch()
  notify(PVEEvent.Einherjar_Launch)
end

function Einherjar:Update()
end

function Einherjar:Shutdown()
  notify(PVEEvent.Einherjar_Shutdown)
end

function PVEFactory.GetEinherjar()
  return Einherjar.new()
end

local ChasingScene = class("ChasingScene", Dungeon_Handle)

function ChasingScene:ctor()
  self.isChasingScene = true
end

function ChasingScene:Launch()
  redlog("ChasingScene:Launch()")
  Game.AutoBattleManager:AutoBattleOff()
  Game.Myself:Client_SetAutoBattle(false)
  FunctionSystem.WeakInterruptMyself(true)
  FunctionSystem.InterruptMyselfAI()
  InputManager.Instance.disableMove = InputManager.Instance.disableMove + 1
  Game.Myself:Client_NoMove(true)
  notify(PVEEvent.ChasingScene_Launch)
  notify(MainViewEvent.ShowOrHide, false)
  if not UIManagerProxy.Instance:HasUINode(PanelConfig.ChasingView) then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChasingView
    })
  end
end

function ChasingScene:Update()
end

function ChasingScene:Shutdown()
  redlog("ChasingScene:Shutdown()")
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChasingViewLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ConfirmLayer)
  notify(PVEEvent.ChasingScene_Shutdown)
  FunctionSystem.WeakInterruptMyself(true)
  FunctionSystem.InterruptMyselfAI()
  InputManager.Instance.disableMove = InputManager.Instance.disableMove - 1
  Game.Myself:Client_NoMove(false)
  local charid = Game.Myself.data.id
  Game.InteractNpcManager:DelInteractMountNPC(charid)
  notify(MainViewEvent.ShowOrHide, true)
  Game.PlotStoryManager:Clear()
  Game.PlotStoryManager:ClearMyTempEffect()
end

function PVEFactory.GetChasingScene()
  return ChasingScene.new()
end

local EndlessTowerPrivate = class("EndlessTowerPrivate", Dungeon_Handle)

function EndlessTowerPrivate:ctor()
  self.isEndlessTowerPrivate = true
end

function EndlessTowerPrivate:Launch()
  notify(PVEEvent.EndlessTowerPrivate_Launch)
end

function EndlessTowerPrivate:Shutdown()
  notify(PVEEvent.EndlessTowerPrivate_Shutdown)
end

function PVEFactory.GetEndlessTowerPrivate()
  return EndlessTowerPrivate.new()
end

local ComodoRaid = class("ComodoRaid", Dungeon_Handle)

function ComodoRaid:ctor()
  self.isComodoRaid = true
end

function ComodoRaid:Launch()
  notify(PVEEvent.ComodoRaid_Launch)
end

function ComodoRaid:Shutdown()
  GroupRaidProxy.Instance:SetComodoRaidPhase(0)
  notify(PVEEvent.ComodoRaid_Shutdown)
end

function PVEFactory.GetComodoRaid()
  return ComodoRaid.new()
end

local SevenRoyalsRaid = class("SevenRoyalsRaid", Dungeon_Handle)

function SevenRoyalsRaid:ctor()
  self.isSevenRoyalsRaid = true
  self.isMultiBossRaid = true
end

function SevenRoyalsRaid:Launch()
  notify(PVEEvent.MultiBossRaid_Launch)
end

function SevenRoyalsRaid:Shutdown()
  GroupRaidProxy.Instance:SetMultiBossRaidPhase(0)
  notify(PVEEvent.MultiBossRaid_Shutdown)
end

function PVEFactory.GetSevenRoyals()
  return SevenRoyalsRaid.new()
end

local HeartLockRaid = class("HeartLockRaid", Dungeon_Handle)

function HeartLockRaid:ctor()
  self.isHeartLockRaid = true
end

function HeartLockRaid:Launch()
  SgAIManager.Me():LaunchSkill()
  SgAIManager.Me():setSkill()
  notify(PVEEvent.HeartLockRaid_Launch)
  EventManager.Me():PassEvent(StealthGameEvent.RaidItem_Update)
end

function HeartLockRaid:Shutdown()
  SgAIManager.Me():ClearSkills()
  notify(PVEEvent.HeartLockRaid_Shutdown)
end

function PVEFactory.GetHeartLockRaid()
  return HeartLockRaid.new()
end

local CrackRaid = class("CrackRaid", Dungeon_Handle)

function CrackRaid:ctor()
  self.isCrackRaid = true
end

function CrackRaid:Launch()
end

function CrackRaid:Shutdown()
end

function PVEFactory.GetCrackRaid()
  return CrackRaid.new()
end

local DemoRaid = class("DemoRaid", Dungeon_Handle)

function DemoRaid:ctor()
  self.isDemoRaid = true
end

function DemoRaid:Launch()
  Game.AutoBattleManager:AutoBattleOff()
  notify(PVEEvent.DemoRaid_Launch)
  ProfessionProxy.Instance:TryUseNewClassID()
end

function DemoRaid:Shutdown()
  notify(PVEEvent.DemoRaidRaid_Shutdown)
end

function PVEFactory.GetDemoRaid()
  return DemoRaid.new()
end

local GvgLobby = class("GvgLobby")

function GvgLobby:ctor()
  self.isGvgLobby = true
end

function GvgLobby:Launch()
  self:SetMode()
  ServiceGuildCmdProxy.Instance:CallGvgCookingUpdateCmd()
  self:TryMoveToCity(nil)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.HandleRelogin, self)
end

function GvgLobby:SetMode()
  self.curRaidId = Game.MapManager:GetRaidID()
  self.lobbyConfig = Game.Config_GuildStrongHold_Lobby[self.curRaidId]
  self.cityId = Game.Config_GuildStrongHold_Lobby[self.curRaidId].id
end

function GvgLobby:GetMode()
  return self.lobbyConfig and self.lobbyConfig.Mode or 1
end

function GvgLobby:TryMoveToCity(force, isMyCity)
  GvgProxy.Instance:LaunchMoveToCity(self.cityId, self.curRaidId, force, isMyCity)
end

function GvgLobby:HandleRelogin()
  ServiceGuildCmdProxy.Instance:CallGvgCookingUpdateCmd()
end

function GvgLobby:Update(time, deltatime)
end

function GvgLobby:Shutdown()
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.HandleRelogin, self)
  GVGCookingHelper.Me():DoDeconstruct()
end

function PVEFactory.GetGvgLobby()
  return GvgLobby.new()
end

local HeroJourney = class("HeroJourney", Dungeon_Handle)

function HeroJourney:ctor()
  self.isHeroJourney = true
end

function HeroJourney:Launch()
  notify(PVEEvent.HeroJourney_Launch)
end

function HeroJourney:Shutdown()
  FunctionPve.Me():ClearFightState()
  notify(PVEEvent.HeroJourney_Shutdown)
end

function PVEFactory.GetHeroJourney()
  return HeroJourney.new()
end

local GvgDateBattleLobby = class("GvgDateBattleLobby", GvgLobby)

function GvgDateBattleLobby:ctor()
  self.IsGvgDateBattleLobby = true
end

function GvgDateBattleLobby:SetMode()
  self.curRaidId = Game.MapManager:GetRaidID()
  self.lobbyConfig = Game.Config_DateBattleCity_Lobby[self.curRaidId]
  self.cityId = Game.Config_DateBattleCity_Lobby[self.curRaidId].id
end

function PVEFactory.GetGvgLobbyDateBattle()
  return GvgDateBattleLobby.new()
end

local BossRaid = class("BossRaid", Dungeon_Handle)

function BossRaid:ctor()
  self.isBossRaid = true
end

function BossRaid:Launch()
  notify(PVEEvent.BossRaid_Launch)
end

function BossRaid:Shutdown()
  notify(PVEEvent.BossRaid_Shutdown)
end

function PVEFactory.GetBossRaid()
  return BossRaid.new()
end

local ElementRaid = class("ElementRaid", Dungeon_Handle)

function ElementRaid:ctor()
  self.isElementRaid = true
end

function ElementRaid:Launch()
  if Game.MapManager:GetRaidID() == GameConfig.ElementRaid.QuestRaidID then
    GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewRaidInfoPage")
  else
    GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewElementPage")
  end
end

function ElementRaid:Shutdown()
  if Game.MapManager:GetRaidID() == GameConfig.ElementRaid.QuestRaidID then
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewRaidInfoPage")
  else
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewElementPage")
  end
  DungeonProxy.Instance:ClearElementInfo()
  DungeonProxy.Instance:ClearReviveCount()
  DungeonProxy.Instance:ClearLeftMonsterCount()
  DungeonProxy.Instance:ClearUnlockRoomIDs()
end

function PVEFactory.GetElementRaid()
  return ElementRaid.new()
end

local StarArkRaid = class("StarArkRaid", Dungeon_Handle)

function StarArkRaid:ctor()
  self.isStarArkRaid = true
end

function StarArkRaid:Launch()
  DungeonProxy.Instance:InitTowers()
  DungeonProxy.Instance.starArk_Passed = false
  notify(PVEEvent.StarArk_Launch)
end

function StarArkRaid:Shutdown()
  notify(PVEEvent.StarArk_Shutdown)
end

function PVEFactory.GetStarArkRaid()
  return StarArkRaid.new()
end

local AstralRaid = class("AstralRaid", Dungeon_Handle)

function AstralRaid:ctor()
  self.isAstralRaid = true
end

function AstralRaid:Launch()
  notify(PVEEvent.Astral_Launch)
end

function AstralRaid:Shutdown()
  notify(PVEEvent.Astral_Shutdown)
end

function PVEFactory.GetAstralRaid()
  return AstralRaid.new()
end

local SpaceTimeIllusionRaid = class("SpaceTimeIllusionRaid", Dungeon_Handle)

function SpaceTimeIllusionRaid:ctor()
  self.isSpaceTimeIllusionRaid = true
end

function SpaceTimeIllusionRaid:Launch()
  notify(PVEEvent.SpeceTimeIllusion_Launch)
end

function SpaceTimeIllusionRaid:Shutdown()
  notify(PVEEvent.SpeceTimeIllusion_Shutdown)
end

function PVEFactory.GetSpaceTimeIllusion()
  return SpaceTimeIllusionRaid.new()
end

local AbyssDragonRaid = class("AbyssDragonRaid", Dungeon_Handle)
local EffectPathPrefix = "Common/"
local EffectPos = LuaVector3.Zero()

function AbyssDragonRaid:ctor()
  self.isAbyssDragonRaid = true
end

function AbyssDragonRaid:Launch()
  notify(PVEEvent.AbyssDragon_Launch)
  self:CreateSceneEffect()
end

function AbyssDragonRaid:Shutdown()
  notify(PVEEvent.AbyssDragon_Shutdown)
  self:DestroySceneEffect()
end

function AbyssDragonRaid:CreateSceneEffect()
  local mapId = Game.MapManager:GetMapID()
  local effectPath, bpID
  local areaRaidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
  if areaRaidInfo then
    for _, info in pairs(areaRaidInfo) do
      if info.RaidID == mapId then
        effectPath = EffectPathPrefix .. info.SceneEffect
        bpID = info.BpPoint
        break
      end
    end
  end
  if effectPath and bpID then
    local bp = Game.MapManager:FindBornPoint(bpID)
    if bp then
      LuaVector3.Better_Set(EffectPos, bp.position[1], bp.position[2], bp.position[3])
      self.sceneEffect = Asset_Effect.PlayAt(effectPath, EffectPos)
    end
  end
end

function AbyssDragonRaid:DestroySceneEffect()
  if self.sceneEffect then
    self.sceneEffect:Destroy()
    self.sceneEffect = nil
  end
end

function PVEFactory.GetAbyssDragon()
  return AbyssDragonRaid.new()
end

local FairyTaleRaid = class("FairyTaleRaid", Dungeon_Handle)

function FairyTaleRaid:ctor()
  self.isFairyTaleRaid = true
  self.trainNpcIds = {2055150, 2055151}
end

function FairyTaleRaid:Launch()
  notify(PVEEvent.FairyTale_Launch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs, self)
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdFairyTaleRaidRewardSyncCmd, self.HandleRewardSync, self)
end

function FairyTaleRaid:Shutdown()
  self.npcguid = nil
  FunctionVisitNpc.Me():RemoveDirectDoNpcFuncList(12018)
  notify(PVEEvent.FairyTale_Shutdown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdFairyTaleRaidRewardSyncCmd, self.HandleRewardSync, self)
end

function FairyTaleRaid:HandleAddNpcs(npcs)
  local trainNpcs = {}
  for i = 1, #npcs do
    local npc = npcs[i]
    if npc.data and npc.data.staticData and npc.data.staticData.id == 851999 then
      self.npcguid = npc.data.id
      self:UpdateRewardCount()
      FunctionVisitNpc.Me():AddDirectDoNpcFuncList(12018)
    end
    if npc.data and npc.data.staticData and TableUtility.ArrayFindIndex(self.trainNpcIds, npc.data.staticData.id) > 0 then
      table.insert(trainNpcs, npc)
    end
  end
  if 0 < #trainNpcs then
    GameFacade.Instance:sendNotification(PVEEvent.FairyTale_AddTrainNpc, trainNpcs)
  end
end

function FairyTaleRaid:HandleRemoveNpcs(npcs)
  for i = 1, #npcs do
    local guid = npcs[i]
    if self.npcguid == guid then
      self.npcguid = nil
    end
  end
  GameFacade.Instance:sendNotification(PVEEvent.FairyTale_RemoveTrainNpc, npcs)
end

function FairyTaleRaid:HandleRewardSync()
  redlog("FairyTaleRaid:HandleRewardSync")
  self:UpdateRewardCount()
end

function FairyTaleRaid:UpdateRewardCount()
  if self.npcguid then
    local npc = SceneCreatureProxy.FindCreature(self.npcguid)
    if not npc then
      return
    end
    local rewardCount = FairyTaleProxy.Instance:GetRewardCount()
    redlog("FairyTaleRaid:UpdateRewardCount", rewardCount)
    if not self.rewardIcon then
      local rewardItem = GameConfig.FairyTaleRaid and GameConfig.FairyTaleRaid.CoinID
      local config = Table_Item[rewardItem]
      self.rewardIcon = config and config.Icon or ""
    end
    local roleTopUI = npc:GetSceneUI().roleTopUI
    if roleTopUI then
      roleTopUI:UpdateGetReward(self.rewardIcon, rewardCount)
    end
  end
end

function PVEFactory.GetFairyTaleRaid()
  return FairyTaleRaid.new()
end
