MainViewMiniMap = class("MainViewMiniMap", SubView)
autoImport("WrapCellHelper")
autoImport("MiniMapWindow")
autoImport("NearlyCreatureCell")
autoImport("MiniMapData")
autoImport("MiniMapGuideAnim")
autoImport("TwelvePVPInfoTip")
autoImport("GVGPointPerTip")
autoImport("MiniMapChangeCell")
autoImport("BigMapGvgInfoTip")
autoImport("EndlessBattleFieldEventBoard")
local _PvpProxy = PvpProxy.Instance
local MapManager = Game.MapManager
local _Game = Game
local TwelveNpcMapSymbols = GameConfig.TwelvePvp.MiniMapSymbol
local TwelvePvpConfig = GameConfig.TwelvePvp.HpShow
local _TableMonster = Table_Monster
local _TableNpc = Table_Npc
local RaidNPCSymbols = GameConfig.RaidNPCSymbols
local SkillWeatherIcon = GameConfig.SkillWeather and GameConfig.SkillWeather.MapIcon
local miniMapDataDeleteFunc = function(data)
  data:Destroy()
end

function MainViewMiniMap:Init()
  self:InitData()
  self:InitUI()
  self:MapEvent()
end

local _NSceneNpcProxy, _TableClearByDeleter, _TableClear, _SuperGvgProxy, _TeamProxy

function MainViewMiniMap:InitData()
  _NSceneNpcProxy = NSceneNpcProxy.Instance
  _TableClearByDeleter = TableUtility.TableClearByDeleter
  _TableClear = TableUtility.TableClear
  _SuperGvgProxy = SuperGvgProxy.Instance
  _TeamProxy = TeamProxy.Instance
  _PvpObProxy = PvpObserveProxy.Instance
  self.tempMap = {}
  self.questShowDatas = {}
  self.nearlyPlayers = {}
  self.npcRoles = {}
  self.monsterDataMap = {}
  self.teamMemberMapDatas = {}
  self.spotDatas = {}
  self.sealDatasMap = {}
  self.treeMapDatasMap = {}
  self.focusMap = {}
  self.playerMap = {}
  self.showNpcs = {}
  self.npcWalkMap = {}
  self.gvgDroiyanMap = {}
  self.poringFightDropMap = {}
  self.UseButterflyButtonInfo = {}
  self.UseFlyButtonInfo = {}
  self.thanatosSymbols = {}
  self.teamPwsMapInfo = {}
  self.othelloMapInfo = {}
  self.othelloLinkInfo = {}
  self.roguelikeMapInfo = {}
  self.stealthGameInfo = {}
  self.metalGvgPointSymbolMap = {}
  self.metalGvgGuildIconMap = {}
  self.minimapTreasureInfo = {}
  self.fixedTreasureMap = {}
  self.outScreenMapInfo = {}
  self.outScreenNpcIDMap = {}
  self.outScreenNpcSymbolMap = {}
  self.activeStatusMap = {}
  self.raidPuzzleRoomIconMap = {}
  self.quickTargetMap = {}
  self.flowerCarMap = {}
  self.trainEscortMap = {}
  self.areaTipsInfo = {}
  self.gvgMetalMap = {}
  self.tripleTeamsMapInfo = {}
  self.EBFEventAreaMapInfo = {}
  self.astralMapInfo = {}
  self.gvgFightPointDatas = {}
  self.gvgFriendLeaderDatas = {}
  self.gvgEnemyLeaderDatas = {}
  self.gvgFriendChairmanDatas = {}
  self.gvgEnemyChairmanDatas = {}
  self.abyssDragonMapInfo = {}
end

local tempArgs = {}

function MainViewMiniMap:InitUI()
  self.mapBord = self:FindGO("MapBord")
  self.container:RegisterChildPopObj(self.mapBord)
  self:InitBigMap()
  self.miniMapButton = self:FindGO("MiniMapButton")
  local miniMapSp = self:FindComponent("HotKeyContainer", UIWidget)
  Game.HotKeyTipManager:RegisterHotKeyTip(34, miniMapSp, NGUIUtil.AnchorSide.TopLeft)
  self:AddOrRemoveGuideId(self.miniMapButton, 107)
  self:AddClickEvent(self.miniMapButton, function(go)
    if MapManager:IsBigWorld() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BWMiniMapView,
        viewdata = {}
      })
    else
      self:ActiveMapBord(not self.mapBord.activeInHierarchy)
    end
  end)
  local miniMapWindowGO = self:FindGO("MiniMapWindow")
  self.minimapWindow = MiniMapWindow.new(miniMapWindowGO, 1)
  self.mPanel = self:FindComponent("Panel_MiniMap", UIPanel)
  self.minimapWindow:ActiveFocusArrowUpdate(true)
  self.minimapWindow:ActiveCenterMiniMapWindow(true)
  local nearlyBord = self:FindGO("NearlyBord", self.mapBord)
  if nearlyBord then
    GameObject.DestroyImmediate(nearlyBord)
  end
  self.nearlyBord = self:LoadPreferb_ByFullPath("GUI/v1/part/NearlyBord", self.mapBord)
  self.container:RegisterChildPopObj(self.nearlyBord)
  self.nearlyPlayerTipStick = self:FindComponent("NearlyPlayerTipStick", UIWidget, self.nearlyBord)
  self.gvgFinalFightTip = self:FindGO("GvgFinalFightTip")
  self.gvgPointPerTipContainer = self:FindGO("GVGPointPerTipContainer")
  self.container:RegisterChildPopObj(self.gvgFinalFightTip)
  self.twelvePVPInfoTipContainer = self:FindGO("TwelvePVPInfoTip")
  local nearly_playerTog = self:FindGO("PlayerTog", self.nearlyBord)
  self.playerTog = nearly_playerTog:GetComponent(UIToggle)
  self:AddClickEvent(nearly_playerTog, function(go)
    self:UpdateNearlyCreature(1, true)
  end)
  local nearly_npcTog = self:FindGO("NPCTog", self.nearlyBord)
  self.npcTog = nearly_npcTog:GetComponent(UIToggle)
  self:AddClickEvent(nearly_npcTog, function(go)
    self:UpdateNearlyCreature(2, true)
  end)
  local nearly_mapTog = self:FindGO("MapTog", self.nearlyBord)
  if nearly_mapTog then
    self.mapTog = nearly_mapTog:GetComponent(UIToggle)
    self:AddClickEvent(nearly_mapTog, function(go)
      self:UpdateNearlyCreature(3, true)
    end)
  end
  local nearlyButton = self:FindGO("NearlyButton")
  self.showQuestBtn = self:FindGO("ShowQuestButton")
  self.showQuestBtn_Symbol = self:FindComponent("ShowQuestButton", UISprite)
  self.bigMapQuestShow = false
  if MapManager:IsInGVGDetailedRaid() then
    self:ActiveBigMapGvgInfoTip(true)
    self.bigMapQuestShow = true
  end
  self.gvgCrystalInvincibleLab = self:FindComponent("GvgCrystalInvincibleLab", UILabel)
  self:Hide(self.gvgCrystalInvincibleLab)
  self.worldQuestProcess = self:FindGO("WorldQuestProcess")
  self.worldQuestProcess:SetActive(false)
  self:AddClickEvent(self.showQuestBtn, function()
    if self:IsObjActive(self.nearlyBord) then
      self:ActiveNearlyBord(false)
    end
    if MapManager:IsGvgMode_Droiyan() then
      self:ActiveGvgFinalFightTip(not self:IsObjActive(self.gvgFinalFightTip))
      return
    end
    if MapManager:IsPVPMode_EndlessBattleField() then
      local isShow = false
      if self.ebfEventBoard then
        isShow = not self.ebfEventBoard.gameObject.activeSelf
      end
      self:ActiveEBFEventBoard(isShow)
      return
    end
    if MapManager:IsPvPMode_TeamTwelve() then
      return
    end
    if MapManager:IsInGVGDetailedRaid() then
      self:ActiveBigMapGvgInfoTip(not self.bigMapQuestShow)
    else
      self:ActiveBigMapQuestTip(not self.bigMapQuestShow)
    end
    self.bigMapQuestShow = not self.bigMapQuestShow
  end)
  self.settingButton = self:FindGO("SettingButton")
  self.settingButton:SetActive(false)
  self.worldLineGO = self:FindGO("Map_WorldLine")
  self.worldLineChangeTip = self:FindGO("TipLabel", self.frontMapInfo)
  self.worldLineChangeBtnSp = self:FindComponent("ChangeWorldLine", UISprite, self.frontMapInfo)
  self:AddClickEvent(self.worldLineChangeBtnSp.gameObject, function()
    if not self:IsWorldLineChangeAvailable() then
      self.worldLineChangeTip:SetActive(true)
      return
    end
    ServiceNUserProxy.Instance:CallQueryZoneStatusUserCmd()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeZoneView
    })
  end)
  self:AddClickEvent(nearlyButton, function(go)
    if MapManager:IsPVPMode_PoringFight() or MapManager:IsPVPMode_TransferFight() then
      MsgManager.ShowMsgByIDTable(3606)
      return
    end
    if MapManager:IsGvgMode_Droiyan() then
      return
    end
    if MapManager:IsPvPMode_TeamTwelve() then
      self:ActiveTwelvePVPInfoTip(not self:IsObjActive(self.twelvePVPInfoTipContainer))
      return
    end
    if MapManager:IsPVPMode_EndlessBattleField() then
      self:ActiveEBFEventBoard(false)
    end
    if not self:IsObjActive(self.nearlyBord) then
      self:ActiveNearlyBord(true)
    else
      self:ActiveNearlyBord(false)
    end
    if self.bigMapQuestShow then
      self:ActiveBigMapQuestTip(not self.bigMapQuestShow)
      self:ActiveBigMapGvgInfoTip(false)
      self.bigMapQuestShow = not self.bigMapQuestShow
    end
  end)
  local nearlyGrid = self:FindGO("NearlyGrid", self.nearlyBord)
  local wrapConfig = {
    wrapObj = nearlyGrid,
    cellName = "NearlyCreatureCell",
    control = NearlyCreatureCell,
    dir = 1
  }
  self.nearlyCreaturesCtl = WrapCellHelper.new(wrapConfig)
  self.nearlyCreaturesCtl:AddEventListener(MouseEvent.MouseClick, self.ClickNearlyCell, self)
  self.noPlayerTip = self:FindGO("PlayerNoneTip", self.nearlyBord)
  self.noNpcTip = self:FindGO("NpcNoneTip", self.nearlyBord)
  self.bubbleStick = self:FindComponent("BubbleStick", UIWidget)
  self.nearlyCreaturesTweenAlpha = self.nearlyBord.gameObject:GetComponent(TweenAlpha)
  self.nearlyCreaturesTweenPosition = self.nearlyBord.gameObject:GetComponent(TweenPosition)
  local closeMapGO = self:FindGO("CloseMap")
  self:AddClickEvent(closeMapGO, function()
    self:ActiveMapBord(false)
    self:ActiveChangeBord(false)
  end)
  self.weather = self:FindComponent("MapWeather", UISprite)
  self.weathername = self:FindComponent("weathername", UILabel)
  self:UpdateWeather()
  self.exitRaid = self:FindGO("ExitRaid")
  local inRaid = MapManager:IsRaidMode(true)
  self.exitRaid:SetActive(inRaid == true)
  self:AddClickEvent(self.exitRaid, function()
    local inRaid = MapManager:IsRaidMode(true)
    local isActMap = MapManager:IsActivityMap()
    if inRaid or isActMap then
      self:TryExitRaid()
    end
  end)
  self.mapTreasure = self:FindGO("MapTreasure"):GetComponent(UILabel)
  self.mapTreasure_Icon = self:FindGO("MapTreasureIcon"):GetComponent(UISprite)
  self.skillWeatherGO = self:FindGO("SkillWeather")
  self.skillWeatherName = self:FindGO("SkillWeatherName", self.skillWeatherGO)
  self.skillWeatherSp = self.skillWeatherGO:GetComponent(UISprite)
  self:UpdateSkillWeather()
end

function MainViewMiniMap:UpdateSkillWeather()
  local skillWeather = SkillProxy.Instance:GetSkillWeather()
  if skillWeather and SkillWeatherIcon and SkillWeatherIcon[skillWeather] then
    self.skillWeatherGO:SetActive(true)
    self.skillWeatherSp.spriteName = SkillWeatherIcon[skillWeather]
  else
    self.skillWeatherGO:SetActive(false)
  end
end

function MainViewMiniMap:TryExitRaid()
  local isObRunning = PvpObserveProxy.Instance:IsRunning()
  if (MapManager:IsPVPMode_TeamPws() or MapManager:IsPvPMode_TeamTwelve() or MapManager:IsPVPMode_3Teams()) and not isObRunning then
    MsgManager.ShowMsgByIDTable(25923)
    return
  end
  if MapManager:IsPVEMode_HeadwearRaid() or isObRunning or MapManager:IsPVEMode_ExpRaid() or MapManager:IsPVPMode_TransferFight() or MapManager:IsPVeMode_EndlessTowerPrivate() or MapManager:IsPVEMode_FairyTaleRaid() then
    MsgManager.ConfirmMsgByID(7, function()
      redlog("---------CallExitMapFubenCmd")
      ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    end, nil)
    return
  end
  if MapManager:IsActivityMap() then
    MsgManager.ConfirmMsgByID(7, function()
      ServiceActivityCmdProxy.Instance:CallLeaveActStaticMapCmd()
    end)
    return
  end
  local confirmMsg = 7
  local raidReward = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_HAS_USERRETURN_RAID_AWARD) or 0
  if 0 < raidReward then
    confirmMsg = 42085
  end
  MsgManager.ConfirmMsgByID(confirmMsg, function()
    EventManager.Me():PassEvent(StealthGameEvent.ClickMinMapLeave)
    ServiceNUserProxy.Instance:ReturnToHomeCity()
  end, nil)
end

function MainViewMiniMap:WindowInvoke(window, func, ...)
  if window == self.bigmapWindow then
    if self.bigmapWindow:IsOn() then
      func(window, ...)
    end
  else
    func(window, ...)
  end
end

function MainViewMiniMap:UpdateGvgCrystalInvincible()
  local invincible = GvgProxy.Instance:IsCrystalInvincible()
  if GvgProxy.Instance:IsPeaceState() then
    self.gvgCrystalInvincibleLab.text = ""
  else
    self.gvgCrystalInvincibleLab.text = invincible and ZhString.NewGVG_CrystalInvincible or ZhString.NewGVG_CrystalCanBeAttack
  end
  local npcs = _NSceneNpcProxy:FindNpcs(GvgProxy.MetalID)
  if npcs and 0 < #npcs then
    local metalNpc = npcs[1]
    if invincible then
      metalNpc:PlayGvgCrystalInvincibleEffect()
    else
      metalNpc:DestroyGvgCrystalInvincibleEffect()
    end
  end
end

function MainViewMiniMap:UpdateGvgCalm()
  if GvgProxy.Instance:NextStateIsPerfectDefense() then
    self.gvgCrystalInvincibleLab.text = ZhString.NewGVG_CrystalInvincible
  else
    self.gvgCrystalInvincibleLab.text = ZhString.NewGVG_CrystalBroken
  end
end

function MainViewMiniMap:ClickNearlyCell(cellCtl)
  local id = cellCtl.id
  local creatureType = cellCtl.creatureType
  if cellCtl.isExitPoint then
    local currentMapID = MapManager:GetMapID()
    local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
    if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
      MsgManager.ShowMsgByIDTable(50)
    else
      tempArgs.targetPos = cellCtl.pos
      tempArgs.showClickGround = true
      tempArgs.allowExitPoint = true
      local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
      if cmd then
        Game.Myself:TryUseQuickRide()
        Game.Myself:Client_SetMissionCommand(cmd)
      end
      _TableClear(tempArgs)
    end
    return
  end
  if creatureType == Creature_Type.Player then
    local creature = SceneCreatureProxy.FindCreature(id)
    if creature then
      if GuildProxy.Instance:GetMercenaryGuildName(creature.data) ~= nil then
        MsgManager.ShowMsgByID(2669)
        return
      end
      local playerData = PlayerTipData.new()
      playerData:SetByCreature(creature)
      if creature ~= self.lastCreature then
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.nearlyPlayerTipStick, NGUIUtil.AnchorSide.Right, {-356, 0})
        local tipData = {playerData = playerData}
        tipData.funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(id)
        table.insert(tipData.funckeys, "Booth")
        table.insert(tipData.funckeys, "EnterHomeRoom")
        playerTip:SetData(tipData)
        
        function playerTip.closecallback(go)
          self.lastCreature = nil
        end
        
        playerTip:AddIgnoreBound(cellCtl.gameObject)
        self.lastCreature = creature
      else
        FunctionPlayerTip.Me():CloseTip()
        self.lastCreature = nil
      end
    end
  elseif creatureType == Creature_Type.Npc then
    local pos = cellCtl.pos
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.SetTipPos, pos)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetTipPos, pos)
    local npcid, uniqueid = cellCtl.npcid, cellCtl.uniqueid
    tempArgs.targetMapID = MapManager:GetMapID()
    tempArgs.npcID = npcid
    tempArgs.npcUID = uniqueid
    tempArgs.targetPos = pos
    local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc)
    Game.Myself:TryUseQuickRide()
    Game.Myself:Client_SetMissionCommand(cmd)
    _TableClear(tempArgs)
  end
end

function MainViewMiniMap:InitBigMap()
  self.mapName = self:FindComponent("MapName", UILabel, self.mapBord)
  local mapWindow = self:FindGO("BigMapWindow")
  self.bigmapWindow = MiniMapWindow.new(mapWindow, 2)
  self.bigmapWindow:AddMapClick()
  self.bigmapWindow:ActiveFocusArrowUpdate(false)
  self:AddButtonEvent("ReturnHome", function(go)
    MsgManager.ConfirmMsgByID(7, function()
      EventManager.Me():PassEvent(StealthGameEvent.ClickMinMapLeave)
      ServiceNUserProxy.Instance:ReturnToHomeCity()
    end, nil)
  end)
  self.bigMapButton = self:FindGO("BigMapButton")
  self.bigMapLab = self:FindComponent("Label", UILabel, self.bigMapButton)
  self.normalMapIcon = self:FindGO("Icon", self.bigMapButton)
  self.exitRaidIcon = self:FindGO("ExitRaidIcon", self.bigMapButton)
  local inRaid = MapManager:IsRaidMode(true)
  self.normalMapIcon:SetActive(not inRaid)
  self.exitRaidIcon:SetActive(inRaid == true)
  self:AddClickEvent(self.bigMapButton, function(go)
    if self.bigmapWindow.lock then
      return
    end
    local inRaid = MapManager:IsRaidMode(true)
    local isActMap = MapManager:IsActivityMap()
    if inRaid or isActMap then
      self:TryExitRaid()
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WorldMapView,
        viewdata = {}
      })
    end
    self:ActiveMapBord(false)
  end)
  self.frontMapInfo = self:FindGO("MapFrontInfo")
  self.enlargeSprite = self:FindComponent("EnLargeButton", GradientUISprite, self.frontMapInfo)
  self:AddClickEvent(self.enlargeSprite.gameObject, function(go)
    self:EnLargeBigMap(not self.bigmaplarge)
  end)
  local activeComp = self.mapBord:GetComponent(RelateGameObjectActive)
  
  function activeComp.enable_Call()
    self:EnLargeBigMap(false)
  end
  
  self.UseButterflyButtonInfo.itemID = 50001
  self.UseButterflyButtonInfo.msgID = 25440
  self.UseButterflyButtonInfo.msgDoNotHaveID = 25444
  self.UseButterflyButtonInfo.base = self:FindComponent("UseButterflyWingsButton", UISprite, self.frontMapInfo)
  self.UseButterflyButtonInfo.icon = self:FindComponent("Icon", UISprite, self.UseButterflyButtonInfo.base.gameObject)
  IconManager:SetItemIcon("item_" .. self.UseButterflyButtonInfo.itemID, self.UseButterflyButtonInfo.icon)
  self:AddClickEvent(self.UseButterflyButtonInfo.base.gameObject, function(go)
    self:TryUseButterflyOrFly(self.UseButterflyButtonInfo)
  end)
  self.UseButterflyButtonInfo.base.gameObject:SetActive(GameConfig.MapIconShow.mapicon_butterfly_open ~= 0)
  self.UseFlyButtonInfo.itemID = 5024
  self.UseFlyButtonInfo.msgID = 25439
  self.UseFlyButtonInfo.msgDoNotHaveID = 25444
  self.UseFlyButtonInfo.base = self:FindComponent("UseFlyWingsButton", UISprite, self.frontMapInfo)
  self.UseFlyButtonInfo.icon = self:FindComponent("Icon", UISprite, self.UseFlyButtonInfo.base.gameObject)
  IconManager:SetItemIcon("item_" .. self.UseFlyButtonInfo.itemID, self.UseFlyButtonInfo.icon)
  self:AddClickEvent(self.UseFlyButtonInfo.base.gameObject, function(go)
    self:TryUseButterflyOrFly(self.UseFlyButtonInfo)
  end)
  self.UseFlyButtonInfo.base.gameObject:SetActive(GameConfig.MapIconShow.mapicon_fly_open ~= 0)
  self:RefreshButterflyAndFlyButtons()
  self.sceneRoot = self:FindGO("SceneRoot", self.mapBord)
  self.sceneName = self:FindGO("SceneName", self.mapBord):GetComponent(UILabel)
  self.sceneHelp = self:FindGO("SceneHelp", self.mapBord)
  self:RegistShowGeneralHelpByHelpID(35238, self.sceneHelp)
  self.changeSceneTrans = self:FindGO("ChangeScene", self.mapBord).transform
  self:AddClickEvent(self.changeSceneTrans.gameObject, function()
    if not self:CallQueryCloneMapStatusMapCmd() then
      if self.changeBord == nil then
        self.changeBord = self:LoadPreferb_ByFullPath("GUI/v1/part/MiniMapChangeBord", self.mapBord, true)
        local container = self:FindGO("Container", self.changeBord)
        self.changeList = WrapListCtrl.new(container, MiniMapChangeCell, "MiniMapChangeCell", 1, 2, 117, true)
        self.changeList:AddEventListener(MouseEvent.MouseClick, self.ClickChangeMap, self)
      else
        self:ActiveChangeBord(true)
      end
      local list = WorldMapProxy.Instance:GetCloneMapList()
      self.changeList:ResetDatas(list)
    end
  end)
  self.cloneMap = self:FindGO("CloneMap")
  self.infoGrid = self:FindGO("InfoGrid"):GetComponent(UIGrid)
  self.sgAIResetButton = self:FindGO("SgAIResetButton", self.frontMapInfo)
  self:AddClickEvent(self.sgAIResetButton, function(go)
    MsgManager.ConfirmMsgByID(43230, function()
      SgAIManager.Me():resetAll()
    end, nil, nil)
  end)
end

function MainViewMiniMap:ActiveMapBord(b)
  if self.bigmapWindow.lock then
    return false
  end
  b = b == true
  self.mapBord:SetActive(b)
  self:ActiveNearlyBord(false)
  if b then
    if MapManager:IsInGVGDetailedRaid() and self.bigmapWindow.active ~= b then
      self.bigMapQuestShow = false
      self:ActiveBigMapGvgInfoTip(true)
      self.bigMapQuestShow = true
    end
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.Show)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateQuestNpcSymbol, self.questShowDatas, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ResetMapPos)
    self:UpdateNearlyMonsters()
    self:RefreshButterflyAndFlyButtons()
    self.container.menuPage.moreBord:SetActive(false)
    if self.bigMapQuestTipCtl and self.bigMapQuestTip.activeInHierarchy then
      self.bigMapQuestTipCtl:RefreshList()
    end
    self:UpdateWorldLineChange()
    self:UpdateTrainEscortPos()
    self:UpdateMapTreasure()
  else
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.Hide)
    self:ShutDownGuideAnim()
    self:EnLargeBigMap(false)
    TipManager.CloseTip()
  end
  if MapManager:IsGvgMode_Droiyan() then
    self:ActiveGvgFinalFightTip(b)
  end
  if MapManager:IsPvPMode_TeamTwelve() then
    self:ActiveTwelvePVPInfoTip(b)
  end
  if MapManager:IsPVPMode_EndlessBattleField() then
    self:ActiveEBFEventBoard(b)
    self.worldLineGO:SetActive(false)
  end
  GameFacade.Instance:sendNotification(MainViewEvent.ShowMapBord, b)
  EventManager.Me():DispatchEvent(MainViewEvent.ShowMapBord, b)
  return true
end

function MainViewMiniMap:ShowSettingAndWorldLine(b)
  b = not not b
  self.worldLineGO:SetActive(b)
end

function MainViewMiniMap:EnLargeBigMap(b, notCenterMyPos)
  if self.bigmapWindow.lock then
    return
  end
  if b then
    self.bigmaplarge = true
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMapScale, MiniMapWindow.MAPSCALE_LARGE)
    if notCenterMyPos == nil or notCenterMyPos == false then
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.CenterOnMyPos, true)
    end
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.EnableDrag, true)
    self.enlargeSprite.spriteName = "com_icon_narrow2"
    self.worldLineGO:SetActive(false)
    self.gvgCrystalInvincibleLab.gameObject:SetActive(false)
  else
    self.bigmaplarge = false
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMapScale, MiniMapWindow.MAPSCALE_NORMAL)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ResetMapPos)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.EnableDrag, false)
    self.enlargeSprite.spriteName = "com_icon_enlarge2"
    if not MapManager:IsPVPMode_EndlessBattleField() then
      self.worldLineGO:SetActive(true)
    end
    self.gvgCrystalInvincibleLab.gameObject:SetActive(Game.MapManager:IsPVPMode_GVGDetailed() == true)
  end
end

function MainViewMiniMap:ActiveGvgFinalFightTip(isShow)
  self:SetObjActive(self.gvgFinalFightTip, isShow)
  if isShow then
    if not self.gvgFinalFightTipCtl then
      self.gvgFinalFightTipCtl = GvgFinalFightTip.new(self.gvgFinalFightTip)
    end
    self.gvgFinalFightTipCtl:OnShow()
  elseif self.gvgFinalFightTipCtl then
    self.gvgFinalFightTipCtl:OnHide()
  end
  self.showQuestBtn_Symbol.flip = self:IsObjActive(self.gvgFinalFightTip) and 0 or 1
end

function MainViewMiniMap:ActiveBigMapQuestTip(isShow)
  if isShow then
    if not self.bigMapQuestTipCtl then
      self.bigMapQuestTip = self:LoadPreferb_ByFullPath("GUI/v1/part/BigMapQuestTip", self.mapBord)
      self.bigMapQuestTip.transform.localPosition = LuaGeometry.GetTempVector3(-418.44, 13.15, 0)
      self.bigMapQuestTipCtl = BigMapQuestTip.new(self.bigMapQuestTip)
      self.bigMapQuestTipCtl:OnShow()
      self.container:RegisterChildPopObj(self.bigMapQuestTip)
    end
  elseif self.bigMapQuestTipCtl then
    self.bigMapQuestTipCtl:OnHide()
    GameObject.DestroyImmediate(self.bigMapQuestTip)
    self.bigMapQuestTip = nil
    self.bigMapQuestTipCtl = nil
  end
  self.showQuestBtn_Symbol.flip = self.bigMapQuestShow and 0 or 1
end

function MainViewMiniMap:ActiveBigMapGvgInfoTip(isShow)
  if isShow then
    if not self.bigMapGvgInfoTipCtl then
      self.bigMapGvgInfoTip = self:LoadPreferb_ByFullPath("GUI/v1/part/BigMapGvgInfoTip", self.mapBord)
      self.bigMapGvgInfoTip.transform.localPosition = LuaGeometry.GetTempVector3(-200, 13.15, 0)
      self.bigMapGvgInfoTipCtl = BigMapGvgInfoTip.new(self.bigMapGvgInfoTip)
      self.bigMapGvgInfoTipCtl:OnShow()
      self.container:RegisterChildPopObj(self.bigMapGvgInfoTip)
    end
  elseif self.bigMapGvgInfoTipCtl then
    self.bigMapGvgInfoTipCtl:OnHide()
    GameObject.DestroyImmediate(self.bigMapGvgInfoTip)
    self.bigMapGvgInfoTipCtl = nil
  end
  self.showQuestBtn_Symbol.flip = self.bigMapQuestShow and 0 or 1
end

function MainViewMiniMap:ActiveCameraSettingPage(isShow)
  if isShow then
    if not self.cameraPage then
      self.cameraPage = self:LoadPreferb_ByFullPath("GUI/v1/part/MainviewCameraSettingPage", self.mapBord)
      self.cameraPage.transform.localPosition = LuaGeometry.GetTempVector3(-23.8, 61.3, 0)
      self.cameraPageCtrl = MainViewMapSettingPage.new(self.settingPage)
      self.cameraPageCtrl:RefreshGrid()
    end
  elseif self.cameraPageCtrl then
    GameObject.DestroyImmediate(self.cameraPage)
    self.cameraPageCtrl = nil
  end
end

function MainViewMiniMap:ActiveEBFEventBoard(isShow)
  if self.ebfEventBoard then
    if isShow then
      self.ebfEventBoard:Show()
      self.ebfEventBoard:OnShow()
    else
      self.ebfEventBoard:Hide()
      self.ebfEventBoard:OnHide()
    end
    self.showQuestBtn_Symbol.flip = isShow and 0 or 1
  end
end

function MainViewMiniMap:OnShow()
  self:UpdateMyMapPos()
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.OnViewShow)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.OnViewShow)
  if self.miniMapGuideAnim then
    self.miniMapGuideAnim:Continue()
  end
end

function MainViewMiniMap:OnHide()
  if self.miniMapGuideAnim then
    self.miniMapGuideAnim:Pause()
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.OnViewHide)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.OnViewHide)
end

function MainViewMiniMap:OnEnter()
  MainViewMiniMap.super.OnEnter(self)
  self.minimapWindow:Show()
  self:ActiveMapBord(false)
  if MapManager:IsPVPMode_PoringFight() then
    self:ShowPoringFightMapItems()
  end
  self:ActiveCheckMonstersPoses(true)
end

function MainViewMiniMap:OnExit()
  self.minimapWindow:Hide()
  self:ActiveCheckMonstersPoses(false)
  self:ClearPoringFightMapItems()
  self:ClearOutScreenDatas()
  self:ClearObjActiveMap()
  self:ClearBigWorldWildMvpPassDayRefresh()
  MainViewMiniMap.super.OnExit(self)
end

function MainViewMiniMap:OnDestroy()
  if self.nearlyCreaturesCtl then
    self.nearlyCreaturesCtl:Destroy()
  end
  MainViewMiniMap.super.OnDestroy(self)
end

function MainViewMiniMap:ActiveNearlyBord(b)
  if self:IsObjActive(self.nearlyBord) == b then
    return
  end
  if b then
    self:SetObjActive(self.nearlyBord, true)
    self.nearlyCreaturesTweenAlpha:ResetToBeginning()
    self.nearlyCreaturesTweenPosition:ResetToBeginning()
    self.nearlyCreaturesTweenAlpha:PlayForward()
    self.nearlyCreaturesTweenPosition:PlayForward()
    self.nowNearlyTog = 1
    self:UpdateNearlyCreature(1, true)
  else
    self:SetObjActive(self.nearlyBord, false)
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.ShowOrHideExitInfo, false)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ShowOrHideExitInfo, false)
end

local _InnerTransShow = {
  [9101] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9106] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9108] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9110] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9112] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9114] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9116] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9118] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9125] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9127] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  },
  [9129] = {
    [3] = ZhString.GVGExitPointName1,
    [4] = ZhString.GVGExitPointName2
  }
}

function MainViewMiniMap:UpdateNearlyCreature(tog, forceUpdate)
  local needUpdateList = true
  if not forceUpdate and not self:IsObjActive(self.nearlyBord) then
    needUpdateList = false
  end
  if not needUpdateList then
    return
  end
  self.nearlyCreaturesCtl:ResetPosition()
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.ShowOrHideExitInfo, false)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ShowOrHideExitInfo, false)
  if tog == 1 then
    self.playerTog.value = true
    _TableClearByDeleter(self.nearlyPlayers, miniMapDataDeleteFunc)
    local allRole = NSceneUserProxy.Instance.userMap
    for _, role in pairs(allRole) do
      local playerMapData = MiniMapData.CreateAsTable(role.data.id)
      playerMapData:SetParama("creatureType", Creature_Type.Player)
      local name = role.data:GetName()
      local _GuildProxy = GuildProxy.Instance
      local isPlayerMercenary = _GuildProxy:IsPlayerMercenary(role.data) and Game.MapManager:IsInGVG()
      name = isPlayerMercenary and not _GuildProxy:IsPlayerInMyGuildUnion(role.data) and role.data:GetMercenaryGuildName() or name
      playerMapData:SetParama("name", name)
      local profession = role.data.userdata:Get(UDEnum.PROFESSION)
      playerMapData:SetParama("Profession", profession)
      local gender = role.data.userdata:Get(UDEnum.SEX)
      playerMapData:SetParama("gender", gender)
      local level = role.data.userdata:Get(UDEnum.ROLELEVEL)
      playerMapData:SetParama("level", level)
      table.insert(self.nearlyPlayers, playerMapData)
    end
    self.nearlyCreaturesCtl:ResetDatas(self.nearlyPlayers)
    self:SetObjActive(self.noPlayerTip, #self.nearlyPlayers == 0)
    self:SetObjActive(self.noNpcTip, false)
  elseif tog == 2 then
    self.npcTog.value = true
    _TableClearByDeleter(self.npcRoles, miniMapDataDeleteFunc)
    local npcRolesMap = {}
    local npcList = MapManager:GetNPCPointArray()
    if npcList then
      for i = 1, #npcList do
        local point = npcList[i]
        local npcData = Table_Npc[point.ID]
        if npcData and npcData.MapIcon ~= "" and npcData.NoShowMapIcon ~= 1 and FunctionNpcFunc.checkNPCValid(npcData.id) and not FunctionUnLockFunc.CheckNpcIsForbiddenByFuncState(npcData.id) then
          local isUnlock = true
          if npcData.MenuId ~= nil then
            isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcData.MenuId)
          end
          if isUnlock then
            local combineId = QuestDataStepType.QuestDataStepType_VISIT .. point.ID .. point.uniqueID
            local npcMapData = npcRolesMap[combineId]
            if npcMapData == nil then
              npcMapData = MiniMapData.CreateAsTable(combineId)
            end
            npcMapData:SetParama("creatureType", Creature_Type.Npc)
            npcMapData:SetParama("npcid", npcData.id)
            npcMapData:SetParama("uniqueid", point.uniqueID)
            npcMapData:SetParama("name", npcData.NameZh)
            npcMapData:SetParama("icon", npcData.MapIcon)
            npcMapData:SetParama("PositionTip", npcData.Position)
            npcMapData:SetPos(point.position[1], point.position[2], point.position[3])
            npcRolesMap[combineId] = npcMapData
            table.insert(self.npcRoles, npcMapData)
          end
        end
      end
    end
    local gvgCookingNpc = GVGCookingHelper.Me():getNpc()
    if gvgCookingNpc then
      local npcData = gvgCookingNpc.data
      local npcSData = npcData and npcData.staticData
      if npcSData and npcSData.MapIcon ~= "" and npcSData.NoShowMapIcon ~= 1 and FunctionNpcFunc.checkNPCValid(npcData.id) and not FunctionUnLockFunc.CheckNpcIsForbiddenByFuncState(npcData.id) then
        local currentPos = gvgCookingNpc.logicTransform.currentPosition
        local combineId = QuestDataStepType.QuestDataStepType_VISIT .. npcSData.id .. npcData.uniqueid
        local npcMapData = npcRolesMap[combineId]
        if npcMapData == nil then
          npcMapData = MiniMapData.CreateAsTable(combineId)
        end
        npcMapData:SetParama("creatureType", Creature_Type.Npc)
        npcMapData:SetParama("npcid", npcSData.id)
        npcMapData:SetParama("uniqueid", npcData.uniqueid)
        npcMapData:SetParama("name", npcSData.NameZh)
        npcMapData:SetParama("icon", npcSData.MapIcon)
        npcMapData:SetParama("PositionTip", npcSData.Position)
        npcMapData:SetPos(currentPos[1], currentPos[2], currentPos[3])
        npcRolesMap[combineId] = npcMapData
        table.insert(self.npcRoles, npcMapData)
      end
    end
    for npcCombineId, npcInfo in pairs(self.showNpcs) do
      local nearShow = npcInfo.nearShow
      if nearShow then
        local npcid = npcInfo.staticId
        local combineId = QuestDataStepType.QuestDataStepType_VISIT .. npcCombineId
        local npcMapData = npcRolesMap[combineId]
        if npcMapData == nil then
          npcMapData = MiniMapData.CreateAsTable(combineId)
        end
        local npcData = Table_Npc[npcid]
        npcMapData:SetParama("creatureType", Creature_Type.Npc)
        npcMapData:SetParama("npcid", npcid)
        npcMapData:SetParama("name", npcData.NameZh)
        npcMapData:SetParama("icon", npcData.MapIcon)
        npcMapData:SetParama("PositionTip", npcData.Position)
        npcMapData:SetPos(npcInfo.pos[1], npcInfo.pos[2], npcInfo.pos[3])
        xdlog(npcInfo.pos[1])
        npcRolesMap[combineId] = npcMapData
        table.insert(self.npcRoles, npcMapData)
      end
    end
    table.sort(self.npcRoles, function(qa, qb)
      return qa:GetParama("npcid") < qb:GetParama("npcid")
    end)
    self.nearlyCreaturesCtl:ResetDatas(self.npcRoles)
    self:SetObjActive(self.noNpcTip, #self.npcRoles == 0)
    self:SetObjActive(self.noPlayerTip, false)
  elseif tog == 3 then
    self.mapTog.value = true
    if self.exitPoints == nil then
      self.exitPoints = {}
    else
      _TableClearByDeleter(self.exitPoints, miniMapDataDeleteFunc)
    end
    local exitPointArray = MapManager:GetExitPointArray()
    if MapManager:IsPVEMode_Roguelike() then
      exitPointArray = nil
    end
    local curMap = MapManager:GetMapID()
    if exitPointArray then
      for i = 1, #exitPointArray do
        local edata = exitPointArray[i]
        if edata and edata.nextSceneID and Game.AreaTrigger_ExitPoint:IsInvisible(edata.ID) == false then
          local data = MiniMapData.CreateAsTable(edata.ID)
          data:SetParama("isExitPoint", true)
          data:SetParama("nextSceneID", edata.nextSceneID)
          data:SetParama("index", i)
          data:SetPos(edata.position[1], edata.position[2], edata.position[3])
          if edata.nextSceneID == 0 then
            if _InnerTransShow[curMap] and _InnerTransShow[curMap][i] then
              xdlog("特殊地图配置")
              data:SetParama("StaticName", _InnerTransShow[curMap][i])
              table.insert(self.exitPoints, data)
            end
          else
            table.insert(self.exitPoints, data)
          end
        end
      end
    end
    self.nearlyCreaturesCtl:ResetDatas(self.exitPoints)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.ShowOrHideExitInfo, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ShowOrHideExitInfo, true)
    self:SetObjActive(self.noNpcTip, false)
    self:SetObjActive(self.noPlayerTip, false)
  end
  self.nowNearlyTog = tog
end

function MainViewMiniMap:ActiveCheckMonstersPoses(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateMonsterSymbols, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function MainViewMiniMap:UpdateMonsterSymbols()
  self:UpdateNearlyMonsters()
  if self.worldQuestMap then
    self:UpdateNearlyTreasures()
  end
end

function MainViewMiniMap:ActiveCheckNpcWalkPoses(note)
  local npcid = note.body.npcid
  local status = note.body.status
  if status == 1 then
    TimeTickManager.Me():CreateTick(0, 2000, function()
      self:UpdateNpcWalk()
    end, self, 5)
    self:HandleNpcWalkQestSymbol(npcid, status)
  elseif status == 2 then
    self:HandleNpcWalkQestSymbol(npcid, status)
    if self.npcWalkMap then
      local tempNum = 0
      for k, v in pairs(self.npcWalkMap) do
        if v then
          tempNum = tempNum + 1
        end
      end
      if tempNum == 0 then
        TimeTickManager.Me():ClearTick(self, 5)
      end
      self:UpdateNpcWalk()
    end
  end
end

function MainViewMiniMap:HandleNpcWalkQestSymbol(npcid, status)
  local npc = NSceneNpcProxy.Instance:FindNpcs(npcid)
  local status = status
  if npc == nil or #npc == 0 then
    local tempID = npcid
    if self.npcWalkMap[tempID] then
      self.npcWalkMap[tempID] = nil
    end
    return
  end
  local npcData = npc[1]
  if npcData then
    local cacheMap
    if self.mapInited then
      cacheMap = self.npcWalkMap
    else
      cache_servershowNpcMap = {}
      cacheMap = cache_servershowNpcMap
    end
    if status == 1 then
      local createNpcID = npcid
      local miniMapData = cacheMap[createNpcID]
      if miniMapData == nil then
        miniMapData = MiniMapData.CreateAsTable(createNpcID)
        cacheMap[createNpcID] = miniMapData
      end
      scenePos = npcData:GetPosition()
      miniMapData:SetPos(scenePos.x, scenePos.y, scenePos.z)
      miniMapData:SetParama("Symbol", "main_icon_wait")
    elseif status == 2 then
      local createNpcID = npcid
      local miniMapData = cacheMap[createNpcID]
      if miniMapData then
        miniMapData:Destroy()
        cacheMap[createNpcID] = nil
        self:UpdateNpcWalk()
      end
    end
  end
end

function MainViewMiniMap:UpdateNpcWalk()
  local cacheMap
  if self.mapInited then
    cacheMap = self.npcWalkMap
  end
  if cacheMap then
    for k, v in pairs(cacheMap) do
      local npc = NSceneNpcProxy.Instance:FindNpcs(k)
      if npc then
        local npcData = npc[1]
        if npcData then
          local miniMapData = cacheMap[k]
          scenePos = npcData:GetPosition()
          miniMapData:SetPos(scenePos.x, scenePos.y, scenePos.z)
        end
      end
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateNpcWalkPointMap, cacheMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateNpcWalkPointMap, cacheMap, true)
end

function MainViewMiniMap:UpdateNearlyMonsters()
  if not self.minimapWindow:IsActive() then
    return
  end
  self.monsterDataMap, self.tempMap = self.tempMap, self.monsterDataMap
  local isMvpFight = MapManager:IsPVPMode_MvpFight()
  local isTwelvePVP = MapManager:IsPvPMode_TeamTwelve()
  local monsterList = FunctionMonster.Me():FilterMonster(isMvpFight or isTwelvePVP)
  local rolelv = MyselfProxy.Instance:RoleLevel()
  local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  local isRaid = MapManager:IsRaidMode() or 0 < curImageId
  local _roleDefunes_Camp = RoleDefines_Camp
  local staticMonsterId, monster, monsterMapData
  local nowMapId = MapManager:GetMapID()
  local isInGVGDetailedRaid = MapManager:IsInGVGDetailedRaid()
  for i = 1, #monsterList do
    monster = monsterList[i]
    local symbolName, depth
    staticMonsterId = monster.data.staticData and monster.data.staticData.id or 0
    if _roleDefunes_Camp.ENEMY == monster.data:GetCamp() and not self.thanatosSymbols[monster.data.id] and monster.data.userdata:Get(UDEnum.OPTION) ~= 1 then
      monsterMapData = self.tempMap[monster.data.id]
      if monsterMapData then
        self.tempMap[monster.data.id] = nil
      else
        monsterMapData = MiniMapData.CreateAsTable(monster.data.id)
        local sdata = monster.data.staticData
        local tempRaidType = nowMapId and Table_MapRaid[nowMapId] and Table_MapRaid[nowMapId].Type
        local currentRaidNPCSymbols = tempRaidType and RaidNPCSymbols and RaidNPCSymbols[tempRaidType]
        if currentRaidNPCSymbols and currentRaidNPCSymbols[staticMonsterId] then
          symbolName = currentRaidNPCSymbols[staticMonsterId]
          depth = 5
        elseif monster:GetBossType() == 3 then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "ui_mvp_dead11_JM"
          depth = 2
        elseif sdata.Type == "MVP" then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          if staticMonsterId == 276614 then
            symbolName = "map_icon_shikonglong"
          else
            symbolName = "map_mvpboss"
          end
          depth = 3
        elseif sdata.Type == "MINI" then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "map_miniboss"
          depth = 2
        elseif sdata.Type == "RareElite" then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "map_jingying"
          depth = 2
        elseif sdata.Type == "WorldBoss" then
          symbolName = "map_worldboss"
          depth = 2
        elseif sdata.Type == "StormBoss" then
          if isMvpFight then
            monsterMapData:SetParama("monster_icon", sdata.Icon)
          end
          symbolName = "main_icon_StormBoss"
          depth = 2
        elseif TwelvePvpConfig[staticMonsterId] then
          symbolName = TwelvePvpConfig[staticMonsterId]
          depth = 5
          monsterMapData:SetParama("iconSize", 1)
        elseif TwelveNpcMapSymbols[staticMonsterId] then
          symbolName = TwelveNpcMapSymbols[staticMonsterId]
          depth = 8
          monsterMapData:SetParama("iconSize", 1)
        elseif sdata.MmapHide ~= 1 then
          if isRaid then
            if not isInGVGDetailedRaid or isInGVGDetailedRaid and staticMonsterId ~= GvgProxy.MetalID then
              symbolName = "map_dot"
            end
          elseif Game.Myself:IsAtNightmareMap() and monster.data:IsNightmareMonster() and not monster.data:IsNightmareStatus() then
            symbolName = "map_green"
          elseif sdata.MmapHide == 2 then
            symbolName = "map_icon_chuansong"
          else
            local search = monster.data.search or 0
            local searchrange = monster.data.searchrange or 0
            if 0 < search or 0 < searchrange then
              local mdata = monster.data.staticData
              if mdata.PassiveLv and rolelv >= mdata.PassiveLv then
                symbolName = "map_dot"
              else
                symbolName = "map_green"
              end
            else
              symbolName = "map_green"
            end
          end
          depth = 1
        end
        if symbolName then
          monsterMapData:SetParama("Symbol", symbolName)
          monsterMapData:SetParama("depth", depth)
        else
          monsterMapData:Destroy()
          monsterMapData = nil
        end
      end
      if monsterMapData then
        local pos = monster:GetPosition()
        monsterMapData:SetPos(pos[1], pos[2], pos[3])
        self.monsterDataMap[monsterMapData.id] = monsterMapData
      end
    elseif _roleDefunes_Camp.FRIEND == monster.data:GetCamp() then
      local tempRaidType = nowMapId and Table_MapRaid[nowMapId] and Table_MapRaid[nowMapId].Type
      local currentRaidNPCSymbols = tempRaidType and RaidNPCSymbols and RaidNPCSymbols[tempRaidType]
      if MapManager:IsPvPMode_TeamTwelve() then
        monsterMapData = self.tempMap[monster.data.id]
        if monsterMapData then
          self.tempMap[monster.data.id] = nil
        else
          monsterMapData = MiniMapData.CreateAsTable(monster.data.id)
          if TwelvePvpConfig[staticMonsterId] then
            monsterMapData:SetParama("Symbol", TwelvePvpConfig[staticMonsterId])
            monsterMapData:SetParama("depth", 5)
            monsterMapData:SetParama("iconSize", 1)
          elseif TwelveNpcMapSymbols[staticMonsterId] then
            monsterMapData:SetParama("Symbol", TwelveNpcMapSymbols[staticMonsterId])
            monsterMapData:SetParama("depth", 8)
            monsterMapData:SetParama("iconSize", 1)
          else
            monsterMapData:SetParama("Symbol", "map_green")
            monsterMapData:SetParama("depth", 1)
          end
        end
        local pos = monster:GetPosition()
        monsterMapData:SetPos(pos[1], pos[2], pos[3])
        self.monsterDataMap[monsterMapData.id] = monsterMapData
      elseif currentRaidNPCSymbols and currentRaidNPCSymbols[staticMonsterId] then
        monsterMapData = self.tempMap[monster.data.id]
        if monsterMapData then
          self.tempMap[monster.data.id] = nil
        else
          monsterMapData = MiniMapData.CreateAsTable(monster.data.id)
        end
        monsterMapData:SetParama("Symbol", currentRaidNPCSymbols[staticMonsterId])
        monsterMapData:SetParama("depth", 5)
        monsterMapData:SetParama("iconSize", 1)
        local pos = monster:GetPosition()
        monsterMapData:SetPos(pos[1], pos[2], pos[3])
        self.monsterDataMap[monsterMapData.id] = monsterMapData
      end
    end
  end
  if MapManager:IsPvPMode_TeamTwelve() then
    local symbolName, depth, iconSize
    for npcSID, mapDataMap in pairs(self.outScreenMapInfo) do
      symbolName = self.outScreenNpcSymbolMap[npcSID]
      depth = 3
      iconSize = nil
      if TwelvePvpConfig[npcSID] then
        depth = 5
        iconSize = 1
      elseif TwelveNpcMapSymbols[npcSID] then
        depth = 8
        iconSize = 1
      end
      if symbolName then
        for guid, posData in pairs(mapDataMap) do
          if not self.monsterDataMap[guid] then
            monsterMapData = self.tempMap[guid]
            if monsterMapData then
              self.tempMap[guid] = nil
            else
              monsterMapData = MiniMapData.CreateAsTable(guid)
              monsterMapData:SetParama("Symbol", symbolName)
              monsterMapData:SetParama("depth", depth)
              if iconSize then
                monsterMapData:SetParama("iconSize", iconSize)
              end
            end
            monsterMapData:SetPos(posData.x, posData.y, posData.z)
            self.monsterDataMap[monsterMapData.id] = monsterMapData
          end
        end
      end
    end
  end
  _TableClearByDeleter(self.tempMap, miniMapDataDeleteFunc)
  if self.minimapWindow:IsActive() then
    self.minimapWindow:UpdateMonstersPoses(self.monsterDataMap, true)
  end
  if self.bigmapWindow:IsActive() then
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMonstersPoses, self.monsterDataMap, true)
  end
end

function MainViewMiniMap:ClearMonsterDatas()
  _TableClearByDeleter(self.monsterDataMap, miniMapDataDeleteFunc)
end

function MainViewMiniMap:UpdateNearlyTreasures()
  if not self.minimapWindow:IsActive() then
    return
  end
  _TableClearByDeleter(self.fixedTreasureMap, miniMapDataDeleteFunc)
  local treasure = _NSceneNpcProxy:FindNearNpcs(Game.Myself:GetPosition(), 10, function(npc)
    for i = 1, #GameConfig.Quest.TreasureNpcID do
      local singleId = GameConfig.Quest.TreasureNpcID[i]
      if singleId == npc.data.staticData.id then
        return true
      end
    end
  end)
  if treasure and 0 < #treasure then
    local single = treasure[1]
    local pos = single:GetPosition()
    if pos then
      local treasureData = MiniMapData.CreateAsTable(single.data.id)
      treasureData:SetPos(pos[1], pos[2], pos[3])
      treasureData:SetParama("Symbol", "main_icon_Treasure-chest")
      treasureData:SetParama("depth", 3)
      self.fixedTreasureMap[treasureData.id] = treasureData
    end
    if self.minimapTreasureInfo[single.data.id] then
      QuestProxy.Instance:RemoveSingleWorldQuestTreause(single.data.id)
      self:UpdateWorldQuestTreasure()
    end
  end
  if self.minimapWindow:IsActive() then
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateFixedTreasurePoses, self.fixedTreasureMap, true)
  end
  if self.bigmapWindow:IsActive() then
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateFixedTreasurePoses, self.fixedTreasureMap, true)
  end
end

function MainViewMiniMap:GetMapNpcPointByNpcId(npcid)
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      if npcPoint and npcPoint.ID == npcid then
        return npcPoint
      end
    end
  end
end

function MainViewMiniMap:UpdateQuestMapSymbol()
  local inRaid = MapManager:IsRaidMode()
  if not inRaid then
    local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
    inRaid = imgId ~= nil and imgId ~= 0
  end
  if MapManager:IsInGuildMap() then
    inRaid = false
  end
  local questlst
  if inRaid then
    questlst = QuestProxy.Instance:getCurRaidQuest()
  else
    questlst = inRaid and not MapManager:IsInGuildMap() and {} or QuestProxy.Instance:getQuestListByMapAndSymbol(MapManager:GetMapID())
  end
  _TableClearByDeleter(self.questShowDatas, miniMapDataDeleteFunc)
  for _, q in pairs(questlst) do
    local params = q.staticData and q.staticData.Params
    if params.ShowSymbol ~= 2 and params.ShowSymbol ~= 3 then
      local symbolType = QuestSymbolCheck.GetQuestSymbolByQuest(q)
      if symbolType then
        local combineId, npcPoint
        local uniqueid, npcid = params.uniqueid, params.npc
        npcid = type(npcid) == "table" and npcid[1] or npcid
        if uniqueid then
          local mapNpcID = MapManager:GetNpcIDByUniqueID(uniqueid)
          if mapNpcID then
            if not FunctionUnLockFunc.CheckNpcIsForbiddenByFuncState(mapNpcID) then
              npcPoint = MapManager:FindNPCPoint(uniqueid)
            end
          else
            npcPoint = MapManager:FindNPCPoint(uniqueid)
          end
        elseif npcid then
          if not FunctionUnLockFunc.CheckNpcIsForbiddenByFuncState(npcid) then
            npcPoint = self:GetMapNpcPointByNpcId(npcid)
            uniqueid = npcPoint and npcPoint.uniqueID or 0
          end
        else
          combineId = q.questDataStepType .. q.id
        end
        if nil == combineId then
          if npcid == nil and uniqueid == nil then
            errorLog("Not Find Npc (questId:%s)", q.id)
          end
          combineId = QuestDataStepType.QuestDataStepType_VISIT .. tostring(npcid) .. tostring(uniqueid)
        end
        local miniMapData = self.questShowDatas[combineId]
        if not miniMapData then
          local pos = params.pos
          if not pos and npcPoint then
            pos = npcPoint.position
          end
          if pos then
            miniMapData = self.questShowDatas[combineId]
            if miniMapData == nil then
              miniMapData = MiniMapData.CreateAsTable(combineId)
            end
            miniMapData:SetPos(pos[1], pos[2], pos[3])
            miniMapData:SetParama("questId", q.id)
            miniMapData:SetParama("npcid", npcid)
            miniMapData:SetParama("uniqueid", uniqueid)
            miniMapData:SetParama("SymbolType", symbolType)
            miniMapData:SetParama("combineId", combineId)
            self.questShowDatas[combineId] = miniMapData
          end
        else
          local cacheSymbolType = miniMapData:GetParama("SymbolType")
          if symbolType < cacheSymbolType then
            miniMapData:SetParama("SymbolType", symbolType)
          end
        end
      end
    end
  end
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      local npcid, uniqueid = npcPoint.ID, npcPoint.uniqueID
      local combineId = QuestDataStepType.QuestDataStepType_VISIT .. npcPoint.ID .. npcPoint.uniqueID
      local miniMapData = self.questShowDatas[combineId]
      if not miniMapData then
        local npcSData = Table_Npc[npcid]
        if QuestSymbolCheck.HasDailySymbol(npcSData) then
          miniMapData = self.questShowDatas[combineId]
          if miniMapData == nil then
            miniMapData = MiniMapData.CreateAsTable(combineId)
            self.questShowDatas[combineId] = miniMapData
          end
          local pos = npcPoint.position
          miniMapData:SetPos(pos[1], pos[2], pos[3])
          miniMapData:SetParama("npcid", npcid)
          miniMapData:SetParama("uniqueid", uniqueid)
          miniMapData:SetParama("SymbolType", QuestSymbolType.Daily)
        end
      end
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateQuestNpcSymbol, self.questShowDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateQuestNpcSymbol, self.questShowDatas, true)
  self:UpdateNpcPointState()
end

function MainViewMiniMap:UpdateNpcPointState()
  local configs = GameConfig.NpcMapIconShowCondition
  if configs then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    for npcid, config in pairs(configs) do
      local isNowMap = config.mapid == nil or config.mapid == MapManager:GetMapID()
      local islvReach = config.level == nil or mylv ~= nil and mylv >= config.level
      local isCompelete = QuestProxy.Instance:isQuestComplete(config.questId)
      self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateNpcPointState, npcid, isNowMap and (islvReach or isCompelete))
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateNpcPointState, npcid, isNowMap and (islvReach or isCompelete))
    end
  end
end

local Func_IsTeamSymbolRestrict = function()
  local nowMapid = MapManager:GetMapID()
  local showAllNpc = Table_MapRaid[nowMapid] and Table_MapRaid[nowMapid].ShowAllNpc
  if showAllNpc and showAllNpc == 1 then
    return true
  end
  return false
end

function MainViewMiniMap:UpdateTeamMembersPos(refreshSymbol)
  if Func_IsTeamSymbolRestrict() then
    self:ClearTeamMemberPos()
    return
  end
  if _TeamProxy:IHaveTeam() then
    local myTeam = _TeamProxy.myTeam
    local memberMap = myTeam:GetMemberMap()
    for id, member in pairs(memberMap) do
      self:UpdateTeamMemberPos(member.id, refreshSymbol)
    end
    for id, data in pairs(self.teamMemberMapDatas) do
      if not myTeam:GetMemberByGuid(id) then
        self:RemoveTeamMemberPos(id)
      end
    end
  else
    self:ClearTeamMemberPos()
  end
end

function MainViewMiniMap:UpdateTeamMemberPos(id, refreshSymbol)
  local myGuid = Game.Myself.data.id
  if not id or Game.Myself and id == myGuid then
    return
  end
  if Func_IsTeamSymbolRestrict() then
    return
  end
  if not _TeamProxy:IHaveTeam() then
    return
  end
  local nowMapid = MapManager:GetMapID()
  local nowSceneid = MapManager:GetSceneID()
  local myTeam = _TeamProxy.myTeam
  local mymData = myTeam:GetMemberByGuid(myGuid)
  local memData = myTeam:GetMemberByGuid(id)
  if not (memData and (memData.mapid == nowMapid or memData.raid == nowMapid) and memData.offline ~= 1 and (memData:IsSameline() or memData:IsInCommonlineMap())) or mymData and nowSceneid ~= memData.sceneid then
    self:RemoveTeamMemberPos(id)
    return
  end
  if Game.DungeonManager:IsInGuildArea() and GuildProxy.Instance:IHaveGuild() and GuildProxy.Instance.myGuildData.guid ~= memData.guildid then
    self:RemoveTeamMemberPos(id)
    return
  end
  local miniMapData = self.teamMemberMapDatas[id]
  if not miniMapData then
    miniMapData = MiniMapData.CreateAsTable(id)
    miniMapData:SetParama("Symbol", "map_teammate")
    self.teamMemberMapDatas[id] = miniMapData
  end
  local pos = memData.pos
  miniMapData:SetPos(pos[1], pos[2], pos[3])
  self:UpdateTeamMateSymbol(id, miniMapData)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTeamMemberSymbol, self.teamMemberMapDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTeamMemberSymbol, self.teamMemberMapDatas, true)
  self:_RemovePlayerSymbolData(id)
end

function MainViewMiniMap:RemoveTeamMemberPos(id)
  if not id then
    return
  end
  local miniMapData = self.teamMemberMapDatas[id]
  if miniMapData then
    miniMapData:Destroy()
  end
  self.teamMemberMapDatas[id] = nil
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveTeamMemberSymbol, id)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveTeamMemberSymbol, id)
  self:_UpdatePlayerSymbolData(NSceneUserProxy.Instance:Find(id))
end

function MainViewMiniMap:ClearTeamMemberPos()
  for id, teamMemberData in pairs(self.teamMemberMapDatas) do
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveTeamMemberSymbol, id)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveTeamMemberSymbol, id)
  end
  _TableClear(self.teamMemberMapDatas, miniMapDataDeleteFunc)
end

function MainViewMiniMap:UpdateGroupUniteMembers()
  local uniteGroupTeam = _TeamProxy:IHaveGroup() and _TeamProxy.uniteGroupTeam
  if uniteGroupTeam then
    local memberMap = uniteGroupTeam:GetMemberMap()
    local player
    for id, member in pairs(memberMap) do
      player = NSceneUserProxy.Instance:Find(member.id)
      if player then
        self:_UpdatePlayerSymbolData(player)
      end
    end
  end
  self:UpdatePlayerSymbolsPos()
end

local lastMapId, cache_servershowNpcMap

function MainViewMiniMap:UpdateMapAllInfo(map2d)
  self.mapInited = true
  map2d = map2d or Game.Map2DManager:GetMap2D()
  self:CheckWorldQuestMap()
  local nowMapId = MapManager:GetMapID()
  local mapIdChanged = false
  if nowMapId ~= lastMapId then
    lastMapId = nowMapId
    mapIdChanged = true
  end
  self.mapdata = Table_Map[nowMapId]
  self.mapName.text = self.mapdata.NameZh
  self:UpdateSceneRoot()
  local twelvePVPLeaveForbidden
  if MapManager:IsPvPMode_TeamTwelve() then
    if PvpObserveProxy.Instance:IsRunning() then
      twelvePVPLeaveForbidden = false
    else
      twelvePVPLeaveForbidden = true
    end
  else
    twelvePVPLeaveForbidden = false
  end
  self:SetObjActive(self.bigMapButton, not twelvePVPLeaveForbidden and not Game.MapManager:MapForbidLeaveButton())
  if MapManager:IsRaidMode(true) or MapManager:IsActivityMap() then
    self.bigMapLab.text = ZhString.MainViewMiniMap_ReturnHome
    self.normalMapIcon:SetActive(false)
    self.exitRaidIcon:SetActive(true)
    self.exitRaid:SetActive(true)
  else
    self.bigMapLab.text = ZhString.MainViewMiniMap_WorldMap
    self.normalMapIcon:SetActive(true)
    self.exitRaidIcon:SetActive(false)
    self.exitRaid:SetActive(false)
  end
  local tempRaid = Table_MapRaid[nowMapId]
  if tempRaid and tempRaid.Type == PveRaidType.PveCard and DungeonProxy.Instance.select_index and DungeonProxy.Instance.select_index > 0 then
    self.mapName.text = ZhString.PveShenYu .. GameConfig.CardRaid.cardraid_DifficultyName[DungeonProxy.Instance.select_index]
  elseif tempRaid and tempRaid.Type == PveRaidType.StarArk then
    self.mapName.text = DungeonProxy.Instance:GetStarArkRaidName()
  end
  if map2d then
    if self.bigmapWindow.map2D ~= map2d then
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.Reset)
      self:WindowInvoke(self.minimapWindow, self.minimapWindow.Reset)
      if MapManager:IsBigWorld() then
        self.bigmapWindow:Switch(false)
      else
        self.bigmapWindow:Switch(true)
        self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapTexture, self.mapdata, LuaGeometry.GetTempVector3(MiniMapWindow.DefaultMapTextureSize, MiniMapWindow.DefaultMapTextureSize), map2d)
      end
      if self.mapdata.MapScale then
        local maxline = math.max(map2d.size.x, map2d.size.y)
        maxline = maxline * (150 / self.mapdata.MapScale)
        self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapTexture, self.mapdata, LuaGeometry.GetTempVector3(maxline, maxline), map2d)
      end
    end
    if self.bigmaplarge then
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMapScale, MiniMapWindow.MAPSCALE_LARGE)
    else
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMapScale, MiniMapWindow.MAPSCALE_NORMAL)
    end
    self:UpdateQuestMapSymbol()
    self:UpdateMapSealPoint()
    self:RefreshScenicSpots()
    self:UpdateTeamMembersPos(true)
    self:UpdateGvgDroiyanInfos()
    self:UpdateTeamPwsMapInfo()
    self:UpdateThanatosSymbol()
    self:UpdateNearlyMonsters()
    self:UpdateNearlyTreasures()
    self:UpdateOthelloMapInfo()
    self:UpdateRoguelikeMapInfo()
    self:UpdateStealthGameInfo()
    self:UpdateTwelvePVPMapInfo()
    self:UpdateGvgStrongHold()
    self:UpdateGVGInfo()
    self:UpdateTripleTeamsMapInfo()
    self:UpdateAstralTowerMapInfo()
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateQuestFocuses, self.focusMap)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateQuestFocuses, self.focusMap)
    self:UpdateTransmitter()
    self:UpdateShowAreaTips()
    self:RefreshYahahaSymbol()
    self:UpdateAbyssDragonMapInfo()
    if mapIdChanged then
      _TableClear(self.showNpcs, miniMapDataDeleteFunc)
      if cache_servershowNpcMap ~= nil then
        for k, v in pairs(cache_servershowNpcMap) do
          self.showNpcs[k] = v
          cache_servershowNpcMap[k] = nil
        end
        cache_servershowNpcMap = nil
      end
    else
      self:RefreshTreeListUpdate()
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateServerNpcPointMap, self.showNpcs, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateServerNpcPointMap, self.showNpcs, true)
    self:UpdateWildMvpMonsters()
    self:RefreshUnlockRoomIDsFuBenCmd()
    self:UpdateMapTreasure()
    self:UpdateEBFEventBoard()
  else
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.Reset)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.Reset)
  end
  self:ActiveNearlyBord(false)
  self:ActiveChangeBord(false)
  if GameConfig.DisablePanelCenterOn and 0 < TableUtility.ArrayFindIndex(GameConfig.DisablePanelCenterOn, nowMapId) then
    self.minimapWindow:ActiveCenterMiniMapWindow(false)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.ResetMapPos)
  else
    self.minimapWindow:ActiveCenterMiniMapWindow(true)
  end
end

function MainViewMiniMap:MapEvent()
  self:AddListenEvt(MiniMapEvent.ActivePart, self.HandleActivePart)
  self:AddListenEvt(MyselfEvent.TargetPositionChange, self.HandleUpdateDestPos)
  self:AddListenEvt(MyselfEvent.PlaceTo, self.UpdateMyMapPos)
  self:AddListenEvt(ServiceEvent.SceneGoToUserCmd, self.UpdateMyMapPos)
  self:AddListenEvt(LoadSceneEvent.FinishLoadScene, self.HandleChangeMap)
  self:AddListenEvt(GuideEvent.ShowBubble, self.HandleMiniMapGuide)
  self:AddListenEvt(GuideEvent.MiniMapAnim, self.HandleMiniMapGuideAnim)
  self:AddListenEvt(GuideEvent.CloseMiniMapAnim, self.HandleCloseMiniMapGuideAnim)
  self:AddListenEvt(MiniMapEvent.ExitPointStateChange, self.HandleChangeExitPointState)
  self:AddListenEvt(MiniMapEvent.ExitPointReInit, self.HandleExitPointReInit)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberPosUpdate, self.HandleTeamMemberPosUpdate)
  self:AddListenEvt(TeamEvent.MemberChangeMap, self.HandleTeamMemberUpdate)
  self:AddListenEvt(TeamEvent.MemberOffline, self.HandleTeamMemberUpdate)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.HandleTeamMemberUpdate)
  self:AddListenEvt(TeamEvent.ExitTeam, self.ClearTeamMemberPos)
  self:AddListenEvt(TeamEvent.MemberEnterGroup, self.UpdateGroupUniteMembers)
  self:AddListenEvt(TeamEvent.MemberExitGroup, self.UpdatePlayersSymbolData)
  self:AddListenEvt(ServiceEvent.BossCmdBossPosUserCmd, self.HanldBossPosUpdate)
  self:AddListenEvt(FunctionScenicSpot.Event.StateChanged, self.UpdateScenicSpotSymbol)
  self:AddListenEvt(AdventureDataEvent.SceneItemsUpdate, self.HandleScenicSpotUpdate)
  self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.HandleUpdateMap2d)
  self:AddListenEvt(ServiceEvent.SceneSealUpdateSeal, self.UpdateMapSealPoint)
  self:AddListenEvt(ServiceEvent.SceneSealQuerySeal, self.UpdateMapSealPoint)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleQuesUpdate)
  self:AddListenEvt(SystemUnLockEvent.NUserNewMenu, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleQuesUpdate)
  self:AddListenEvt(QuestEvent.RemoveGuildQuestList, self.HandleQuesUpdate)
  self:AddListenEvt(ServiceEvent.FuBenCmdFubenStepSyncCmd, self.HandleQuesUpdate)
  self:AddListenEvt(MainViewEvent.AddQuestFocus, self.HandleAddQuestFocus)
  self:AddListenEvt(MainViewEvent.RemoveQuestFocus, self.HandleRemoveQuestFocus)
  self:AddListenEvt(MiniMapEvent.ShowMiniMapDirEffect, self.HandlePlayQuestDirEffect)
  self:AddListenEvt(ServiceEvent.NUserNtfVisibleNpcUserCmd, self.HandleShowNpcPos)
  self:AddListenEvt(SceneUserEvent.AddNpcPosEffect, self.ActiveCheckNpcWalkPoses)
  self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.HandleAddRoles)
  self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles)
  self:AddListenEvt(ServiceEvent.NUserTreeListUserCmd, self.HandleTreeListUpdate)
  self:AddListenEvt(ServiceEvent.NUserBCatActivityStartUserCmd, self.HandleUpdateBCatPos)
  self:AddListenEvt(ServiceEvent.ActivityCmdBCatUFOPosActCmd, self.HandleUpdateBCatPos)
  self:AddListenEvt(MiniMapEvent.CreatureScenicChange, self.HandleCreatureScenicChange)
  self:AddListenEvt(MiniMapEvent.CreatureScenicAdd, self.HandleCreatureScenicAdd)
  self:AddListenEvt(MiniMapEvent.CreatureScenicRemove, self.HandleCreatureScenicRemove)
  self:AddListenEvt(GuideEvent.MapGuide_Change, self.HandleMapGuide_Change)
  self:AddDispatcherEvt(CreatureEvent.Player_CampChange, self.HandlePlayerCampChange)
  self:AddDispatcherEvt(CreatureEvent.Hiding_Change, self.HandlePlayerHidingChange)
  self:AddDispatcherEvt(PlayerEvent.DeathStatusChange, self.HandlePlayerStatusChange)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgMetalDieFubenCmd, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(GVGEvent.GVG_FinalFightLaunch, self.UpdateGvgDroiyanInfos)
  self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.ClearGvgDroiyanInfos)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncGvgFightPointCmd, self.HandleSyncGvgFightPoint)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncGvgLeaderPosCmd, self.HandleSyncGvgLeaderPos)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.ShowPoringFightMapItems)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.ClearPoringFightMapItems)
  self:AddListenEvt(ServiceEvent.MapAddMapItem, self.HandleAddMapItem)
  self:AddListenEvt(ServiceEvent.MapPickupItem, self.HandelPickupItem)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RefreshButterflyAndFlyButtons)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.UpdateTeamPwsMapInfo)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.ClearAllTeamPwsMapInfo)
  self:AddListenEvt(PVPEvent.TeamPws_PlayerBuffBallChange, self.HandleTeamPwsBallChange)
  self:AddListenEvt(PVPEvent.PVP_MVPFightLaunch, self.ClearMonsterDatas)
  self:AddListenEvt(PVPEvent.PVP_MVPFightShutDown, self.ClearMonsterDatas)
  self:AddListenEvt(HotKeyEvent.OpenMap, self.HandleOpenMap)
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs)
  self:AddListenEvt(ServiceEvent.WeatherWeatherChange, self.UpdateWeather)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.UpdateOthelloMapInfo)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_ShutDown, self.ClearAllOthelloMapInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd, self.HandleOthelloPointChange)
  self:AddListenEvt(PVEEvent.Roguelike_Launch, self.OnRoguelikeLaunch)
  self:AddListenEvt(PVEEvent.Roguelike_Shutdown, self.OnRoguelikeShutdown)
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd, self.OnRoguelikeRaidInfo)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Launch, self.OnStealthGameLaunch)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Shutdown, self.OnStealthGameShutdown)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.UpdateMapChangeEvents)
  self:AddListenEvt(ServiceEvent.NUserNewDeathTransferCmd, self.HandleUpdateTransmitter)
  self:AddListenEvt(ServiceEvent.QuestQueryOtherData, self.SetWorldQuestTreasureTimer)
  self:AddListenEvt("ClickBigMapBoardQuestCell", self.RunQuestSymbolAnimator)
  self:AddListenEvt(SceneUserEvent.LevelUp, self.UpdateQuestMapSymbol)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.UpdateTwelvePVPMapInfo)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.ClearAllTwelvePVPMapInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdPosSyncFubenCmd, self.HandlePosSyncFubenCmd)
  self:AddListenEvt(LoadScene.LoadSceneLoaded, self.ClearOutScreenDatas)
  self:AddListenEvt(PVEEvent.RaidPuzzle_Launch, self.OnRaidPuzzleLaunch)
  self:AddListenEvt(PVEEvent.RaidPuzzle_Shutdown, self.OnRaidPuzzleShutdown)
  self:AddListenEvt(PVEEvent.RaidPuzzle_RoomStatusChange, self.UpdatePuzzleShadow)
  self:AddListenEvt(MainViewEvent.RefreshCameraStatus, self.refreshCameraStatus)
  self:AddListenEvt(ServiceEvent.RaidCmdRaidPuzzleRoomIconRaidCmd, self.HandleRaidPuzzleRoomIconRaidCmd)
  self:AddListenEvt(UIEvent.PopObj, self.HandlePopObjEvent)
  self:AddListenEvt(ServiceEvent.NUserSendTargetPosUserCmd, self.UpdateQuickTargetPos)
  self:AddListenEvt(MiniMapEvent.AddCircleArea, self.HandleAddCircleArea)
  self:AddListenEvt(MiniMapEvent.RemoveCircleArea, self.HandleRemoveCircleArea)
  self:AddListenEvt(InteractNpcEvent.FlowerCarUpdateMiniMap, self.UpdateFlowerCarPos)
  self:AddListenEvt(EscortEvent.EscortInfoChanged, self.UpdateTrainEscortPos)
  self:AddListenEvt(SceneUserEvent.ShowLocalNpcPos, self.ShowLocalNpcPos)
  self:AddListenEvt(GVGEvent.GVG_UpdatePointPercentTip, self.UpdateMetalGvgPointOccupyProgress)
  self:AddListenEvt(GVGEvent.GVG_RemovePointPercentTip, self.UpdateMetalGvgPointOccupyProgress)
  self:AddListenEvt(GVGEvent.GVG_PointUpdate, self.UpdateGvgStrongHold)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgPointUpdateFubenCmd, self.UpdateGvgStrongHold)
  self:AddListenEvt(GVGEvent.GVG_SmallMetalCntUpdate, self.UpdateGvgStrongHold)
  self:AddListenEvt(GVGEvent.GVGDungeonLaunch, self.HandleGvgLaunch)
  self:AddListenEvt(GVGEvent.GVG_MvpStateUpdate, self.UpdateGVGInfo)
  self:AddListenEvt(GVGEvent.GVGDungeonShutDown, self.HandleGvgShutDown)
  self:AddListenEvt(GVGEvent.GVG_CrystalInvincible, self.UpdateGvgCrystalInvincible)
  self:AddListenEvt(GVGEvent.GVG_Calm, self.UpdateGvgCalm)
  self:AddListenEvt(ServiceEvent.MapQueryCloneMapStatusMapCmd, self.HandleMapQueryCloneMapStatusMapCmd)
  self:AddDispatcherEvt(WildMvpEvent.OnMiniMapMonsterUpdated, self.UpdateWildMvpMonsters)
  self:AddDispatcherEvt(StealthGameEvent.Start, self.EnableSgAIResetButton)
  self:AddDispatcherEvt(StealthGameEvent.End, self.DisableSgAIResetButton)
  self:AddDispatcherEvt(GVGCookingEvent.CreateCookingNpc, self.UpdateGvgCookingNpc)
  self:AddDispatcherEvt(GVGCookingEvent.RemoveCookingNpc, self.UpdateGvgCookingNpc)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncUnlockRoomIDsFuBenCmd, self.RefreshUnlockRoomIDsFuBenCmd)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncStarArkInfoFuBenCmd, self.UpdateMapName)
  self:AddListenEvt(MiniMapEvent.ShowSymbolHint, self.HandleShowSymbolHint)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.RefreshYahahaSymbol)
  self:AddListenEvt(MainViewEvent.CameraModeChange, self.UpdateCameraSymbol)
  self:AddListenEvt(ServiceEvent.QuestSyncTreasureBoxNumCmd, self.UpdateMapTreasure)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleCampInfoFuBenCmd, self.UpdateTripleTeamsMapInfo)
  self:AddListenEvt(PVPEvent.TripleTeams_Shutdown, self.ClearTripleTeamsMapInfo)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Launch, self.LaunchEBFEventAreaMapInfo)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Shutdown, self.ClearEBFEventAreaMapInfo)
  self:AddListenEvt(ServiceEvent.MapSkillWeatherSyncCmd, self.UpdateSkillWeather)
  self:AddListenEvt(PVEEvent.AbyssDragon_UpdateArea, self.UpdateAbyssDragonMapInfo)
  self:AddListenEvt(PVEEvent.AbyssDragon_Shutdown, self.ClearAbyssDragonMapInfo)
  self:AddListenEvt(PVEEvent.FairyTale_AddTrainNpc, self.HandleFairyTaleAddTrainNpc)
  self:AddListenEvt(PVEEvent.FairyTale_RemoveTrainNpc, self.HandleFairyTaleRemoveTrainNpc)
  self:AddListenEvt(PVEEvent.FairyTale_Launch, self.HandleFairyTaleLaunch)
  self:AddListenEvt(PVEEvent.FairyTale_Shutdown, self.HandleFairyTaleShutdown)
end

function MainViewMiniMap:HandleChangeMap(note)
  self:UpdateTeamMembersPos(true)
  self:RefreshYahahaSymbol()
  self:UpdateAbyssDragonMapInfo()
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ClearSymbolHintParam)
  self:UpdateTeamMembersPos(true)
  self:TrySetupBigWorldWildMvpPassDayRefresh()
  self:UpdateAstralTowerMapInfo()
  self:UpdateGvgMapSymbols()
end

function MainViewMiniMap:HandleActivePart(note)
  local ids, opt = note.body and note.body[1], note.body and note.body[2]
  if not ids or type(ids) ~= "table" then
    return
  end
  for i = 1, #ids do
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.SetMiniMapPart, ids[i], opt == "show")
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMiniMapPart, ids[i], opt == "show")
  end
end

function MainViewMiniMap:RefreshUnlockRoomIDsFuBenCmd(note)
  local unlockIds = DungeonProxy.Instance:GetUnlockRoomIDs()
  local conf
  if Game.MapManager:IsPVEMode_Element() then
    conf = GameConfig.ElementRaid.MiniMapPart[Game.MapManager:GetMapID()]
  end
  if not conf then
    return
  end
  if unlockIds then
    local roomConf, lastId
    for i = 1, #unlockIds do
      roomConf = conf[unlockIds[i]]
      if roomConf then
        if lastId and roomConf[lastId] then
          self:WindowInvoke(self.minimapWindow, self.minimapWindow.SetMiniMapPart, roomConf[lastId], true)
          self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMiniMapPart, roomConf[lastId], true)
        elseif roomConf[0] then
          self:WindowInvoke(self.minimapWindow, self.minimapWindow.SetMiniMapPart, roomConf[0], true)
          self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetMiniMapPart, roomConf[0], true)
        end
      end
      lastId = unlockIds[i]
    end
  end
end

function MainViewMiniMap:EnableSgAIResetButton()
  self.sgAIResetButton:SetActive(true)
end

function MainViewMiniMap:DisableSgAIResetButton()
  self.sgAIResetButton:SetActive(false)
end

function MainViewMiniMap:UpdateGvgCookingNpc()
  local gvgCookingNpc = GVGCookingHelper.Me():getNpc()
  local npcData = gvgCookingNpc and gvgCookingNpc.data
  local npcSData = npcData and npcData.staticData
  local createNpcID = "GVGCookingNpc"
  local miniMapData = self.showNpcs[createNpcID]
  if npcData then
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(createNpcID)
      self.showNpcs[createNpcID] = miniMapData
    end
    local pos = gvgCookingNpc.logicTransform.currentPosition
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", npcSData.MapIcon)
    miniMapData:SetParama("w", 30)
    miniMapData:SetParama("h", 25)
  elseif miniMapData then
    miniMapData:Destroy()
    self.showNpcs[createNpcID] = nil
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateServerNpcPointMap, self.showNpcs, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateServerNpcPointMap, self.showNpcs, true)
end

function MainViewMiniMap:UpdateMapChangeEvents(note)
  if self.bigMapQuestTipCtl then
    self:ActiveBigMapQuestTip(false)
  end
  if self.bigMapGvgInfoTipCtl then
    self:ActiveBigMapGvgInfoTip(false)
  end
  self.bigMapQuestShow = false
  if self.treasureTimeTick then
    TimeTickManager.Me():ClearTick(self, 18)
    self:RemoveTreasureShow()
    self.treasureTimeTick = nil
  end
  self:ClearRaidPuzzleRoomIcons()
  self:ClearTreeList()
  TimeTickManager.Me():ClearTick(self, 5)
  self:ClearLocalNpcPos()
  self:UpdateWorldLineChange()
  local mapid = note.body and note.body.mapID
  if mapid == 149 then
    self:ActiveMapBord(false)
  end
  self:TrySetupBigWorldWildMvpPassDayRefresh(mapid)
  self:UpdateTeamMembersPos(true)
end

function MainViewMiniMap:UpdateWorldLineChange()
  local available = self:IsWorldLineChangeAvailable()
  self.worldLineChangeBtnSp.alpha = available and 1 or 0.4
  self.worldLineChangeTip:SetActive(false)
end

function MainViewMiniMap:IsWorldLineChangeAvailable()
  local currentMap = SceneProxy.Instance.currentScene
  local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
  return not currentMap:IsDScene() and (imgId == nil or imgId == 0)
end

function MainViewMiniMap:isDailyQuest(questType)
  if QuestDataTypeSymbolMap[questType] and QuestDataTypeSymbolMap[questType] == QuestSymbolType.Daily then
    return true
  end
  return false
end

function MainViewMiniMap:CheckTransmitterIconAvailableInMap()
  local inRaid = MapManager:IsRaidMode()
  if inRaid then
    local dungeonLimit = GameConfig.MapPlay.DungeonsUseTrans
    if dungeonLimit then
      local curRaidId = Game.MapManager:GetRaidID()
      if TableUtility.ArrayFindIndex(dungeonLimit, curRaidId) > 0 then
        inRaid = false
      end
    end
  end
  return not inRaid
end

function MainViewMiniMap:GetBitByInt(num, index)
  return num >> index & 1 == 0
end

function MainViewMiniMap:SetWorldQuestTreasureTimer(note)
  if note and note.body.type == SceneQuest_pb.EOTHERDATA_WORLDTREASURE then
    self:UpdateWorldQuestTreasure()
    self.treasureTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.updateTreasureShow, self, 18)
    self.treasureTickClickTime = UnityUnscaledTime
  end
end

function MainViewMiniMap:updateTreasureShow(deltaTime)
  if UnityUnscaledTime - self.treasureTickClickTime > 300 then
    helplog("超时,取消显示")
    TimeTickManager.Me():ClearTick(self, 18)
    self:RemoveTreasureShow()
    self.treasureTimeTick = nil
  end
end

function MainViewMiniMap:RemoveTreasureShow()
  _TableClearByDeleter(self.minimapTreasureInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateWorldQuestTreasure, self.minimapTreasureInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateWorldQuestTreasure, self.minimapTreasureInfo, true)
  QuestProxy.Instance:RemoveWorldQuestTreasure()
end

function MainViewMiniMap:UpdateWorldQuestTreasure()
  local treasures = QuestProxy.Instance:GetWorldQuestTreasure()
  if treasures and 0 < #treasures then
    _TableClearByDeleter(self.minimapTreasureInfo, miniMapDataDeleteFunc)
    for i = 1, #treasures do
      local q = treasures[i]
      local combineId = q.npcid
      local pos = q.pos
      if pos then
        local treasureData = self.minimapTreasureInfo[combineId]
        treasureData = treasureData or MiniMapData.CreateAsTable(combineId)
        treasureData:SetPos(pos[1], pos[2], pos[3])
        treasureData:SetParama("npcid", q.npcid)
        treasureData:SetParama("Symbol", "main_icon_Treasure-chest")
        treasureData:SetParama("depth", 3)
        self.minimapTreasureInfo[combineId] = treasureData
      end
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateWorldQuestTreasure, self.minimapTreasureInfo, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateWorldQuestTreasure, self.minimapTreasureInfo, true)
  else
    _TableClearByDeleter(self.minimapTreasureInfo, miniMapDataDeleteFunc)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateWorldQuestTreasure, self.minimapTreasureInfo, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateWorldQuestTreasure, self.minimapTreasureInfo, true)
    redlog("treasures 为空,删除地图显示")
  end
end

function MainViewMiniMap:RunQuestSymbolAnimator(note)
  if not note or not note.body then
    return
  end
  local cellCtrl = note.body.cellCtrl
  local questData = cellCtrl.data
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.PlayChooseQuestSymbolAnimation, questData)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.PlayChooseQuestSymbolAnimation, questData)
end

function MainViewMiniMap:HandleUpdateMap2d(note)
  self:UpdateMapAllInfo(note.body)
end

function MainViewMiniMap:HandleAddRoles(note)
  if self.nowNearlyTog == 1 then
    self:UpdateNearlyCreature(1)
  end
  local players = note.body
  if players then
    for _, player in pairs(players) do
      self:_UpdatePlayerSymbolData(player)
    end
  end
  self:UpdatePlayerSymbolsPos()
end

function MainViewMiniMap:ClearPlayerMap()
  _TableClearByDeleter(self.playerMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePlayerPoses, self.playerMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePlayerPoses, self.playerMap, true)
end

function MainViewMiniMap:HandleRemoveRoles(note)
  if self.nowNearlyTog == 1 then
    self:UpdateNearlyCreature(1)
  end
  local dirty = false
  local playerids = note.body
  if playerids then
    for _, playerid in pairs(playerids) do
      if not self:IsOutOfNineScreen(playerid) then
        local miniMapData = self.playerMap[playerid]
        if miniMapData then
          miniMapData:Destroy()
        end
        self.playerMap[playerid] = nil
        dirty = true
      end
    end
  end
  if dirty then
    self:UpdatePlayerSymbolsPos()
  end
end

function MainViewMiniMap:HandleUpdateDestPos(note)
  local destPos = note.body
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateDestPos, destPos)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateDestPos, destPos)
end

function MainViewMiniMap:UpdateMyMapPos(note)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMyPos, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RefreshMapSymbols)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMyPos, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.RefreshMapSymbols)
end

function MainViewMiniMap:ShutDownGuideAnim()
  if self.miniMapGuideAnim then
    self.miniMapGuideAnim:ShutDown()
    self.miniMapGuideAnim = nil
  end
end

function MainViewMiniMap:HandleMiniMapGuideAnim(note)
  if note.body then
    if not self.mapBord.activeInHierarchy then
      self:ActiveMapBord(true)
    end
    self:ShutDownGuideAnim()
    local questData, bubbleId = note.body.questData, note.body.bubbleId
    self.miniMapGuideAnim = MiniMapGuideAnim.new(self.bigmapWindow, self)
    self.enlargeSprite.spriteName = "com_icon_narrow2"
    self.miniMapGuideAnim:Launch(questData, bubbleId, self.bubbleStick)
    self.miniMapGuideAnim:SetEndCall(MainViewMiniMap._MiniMapAnimEndCall, self)
    self.miniMapGuideAnim:SetShutDownCall(MainViewMiniMap._MiniMapAnimShutDownCall, self)
  end
end

function MainViewMiniMap:HandleCloseMiniMapGuideAnim()
  if self.miniMapGuideAnim then
    self.miniMapGuideAnim:CloseBubbleTip()
    self.miniMapGuideAnim = nil
  end
end

function MainViewMiniMap:_MiniMapAnimEndCall(miniMapGuideAnim)
  if not miniMapGuideAnim then
    return
  end
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(miniMapGuideAnim.questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  end
end

function MainViewMiniMap:_MiniMapAnimShutDownCall(miniMapGuideAnim)
  if not miniMapGuideAnim then
    return
  end
  self:EnLargeBigMap(true, true)
  if not miniMapGuideAnim.isEnd then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(miniMapGuideAnim.questId)
    if questData then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    end
  end
  self.miniMapGuideAnim = nil
end

function MainViewMiniMap:HandleMiniMapGuide(note)
  local bubbleid = note.body
  if not self.bubbleStick then
  end
  if bubbleid == BubbleID.MapBubbleID then
    self:ActiveMapBord(true)
    self.bubbleStick.transform.localPosition = LuaGeometry.GetTempVector3(-433, -313)
    TipManager.Instance:ShowBubbleTipById(bubbleid, self.bubbleStick, NGUIUtil.AnchorSide.Center, {50, 10})
  elseif bubbleid == BubbleID.MapQuestId or bubbleid == BubbleID.MapQuestGuideId1 or bubbleid == BubbleID.MapQuestGuideId2 then
    self.bubbleStick.transform.localPosition = LuaGeometry.GetTempVector3(-433, -313)
    TipManager.Instance:ShowBubbleTipById(bubbleid, self.bubbleStick, NGUIUtil.AnchorSide.Center, {50, 10})
  end
end

function MainViewMiniMap:HandleShowSymbolHint(note)
  local hint_param = note and note.body and note.body.hint_param
  if not hint_param then
    return
  end
  self:ActiveMapBord(true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.SetSymbolHintParam, hint_param)
end

function MainViewMiniMap:HandleQuesUpdate(note)
  self:CheckWorldQuestMap()
  if self:IsObjActive(self.worldQuestProcess) then
    local curProcess = QuestProxy.Instance:GetWorldQuestProcess()
    if curProcess and 0 < curProcess then
      for i = 1, #self.questProcess do
        if i <= curProcess then
          self.questProcess[i].color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
        else
          self.questProcess[i].color = LuaGeometry.GetTempVector4(0.2627450980392157, 0.2627450980392157, 0.2627450980392157, 1)
        end
      end
    else
      for i = 1, #self.questProcess do
        self.questProcess[i].color = LuaGeometry.GetTempVector4(0.2627450980392157, 0.2627450980392157, 0.2627450980392157, 1)
      end
    end
    if 4 <= curProcess then
      self.giftIcon_UISprite.spriteName = "growup2"
    else
      self.giftIcon_UISprite.spriteName = "growup1"
    end
  end
  self:UpdateQuestMapSymbol()
end

function MainViewMiniMap:HandleChangeExitPointState(note)
  local id = note.body.id
  local state = note.body.state
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateExitPointMapState, id, state)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateExitPointMapState, id, state)
end

function MainViewMiniMap:HandleExitPointReInit(note)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateExitPoints)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateExitPoints)
end

function MainViewMiniMap:HandleTeamMemberUpdate(note)
  local member = note.body
  if member then
    self:UpdateTeamMemberPos(member.id, true)
    self:HandlePlayerHidingChange(member.id)
  end
end

function MainViewMiniMap:HandleTeamMemberPosUpdate(note)
  local id = note.body.id
  self:UpdateTeamMemberPos(id)
end

function MainViewMiniMap:HanldBossPosUpdate(note)
  local pos = note.body
  if pos then
    local x, y, z = pos.x or 0, pos.y or 0, pos.z or 0
    pos = LuaVector3.New(x, y, z)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateBossSymbol, pos)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateBossSymbol, pos)
  end
end

function MainViewMiniMap:HandleShowNpcPos(note)
  local data = note.body
  if data then
    local cacheMap
    if self.mapInited then
      cacheMap = self.showNpcs
    else
      cache_servershowNpcMap = {}
      cacheMap = cache_servershowNpcMap
    end
    local showNpcs, type = data.npcs, data.type
    if type == 1 then
      local npc, scenePos
      for i = 1, #showNpcs do
        npc = showNpcs[i]
        local npcData = Table_Npc[npc.npcid]
        if npcData and npcData.MapIcon ~= "" and npc.map_show then
          local createNpcID = "Server_ShowNpc_" .. npc.npcid .. "_" .. tostring(npc.uniqueid)
          local miniMapData = cacheMap[createNpcID]
          if miniMapData == nil then
            miniMapData = MiniMapData.CreateAsTable(createNpcID)
            cacheMap[createNpcID] = miniMapData
          end
          scenePos = npc.pos
          miniMapData:SetPos(scenePos.x / 1000, scenePos.y / 1000, scenePos.z / 1000)
          miniMapData:SetParama("Symbol", npcData.MapIcon)
          miniMapData:SetParama("Symbol_Disabled", npcData.MapIconDisabled)
          miniMapData:SetParama("active_time", npc.active_time)
          miniMapData:SetParama("total_time", npc.total_need_time)
          miniMapData:SetServerData(npc)
          miniMapData.symbolSize = 22
          if Table_BuildingCooperate and Table_BuildingCooperate[npc.npcid] then
            miniMapData:SetParama("depth", 40)
          end
        end
      end
      self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateServerNpcPointMap, cacheMap, false)
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateServerNpcPointMap, cacheMap, false)
    elseif type == 0 then
      for i = 1, #showNpcs do
        local createNpcID = "Server_ShowNpc_" .. showNpcs[i].npcid .. "_" .. tostring(showNpcs[i].uniqueid)
        local miniMapData = cacheMap[createNpcID]
        if miniMapData then
          miniMapData:Destroy()
          cacheMap[createNpcID] = nil
          self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveServerNpcPointMap, createNpcID)
          self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveServerNpcPointMap, createNpcID)
        end
      end
    end
  end
end

function MainViewMiniMap:RefreshScenicSpots()
  self:UpdateSceneSpots(FunctionScenicSpot.Me():GetAllScenicSpot())
end

function MainViewMiniMap:UpdateSceneSpots(validScenicSpots)
  _TableClearByDeleter(self.spotDatas, miniMapDataDeleteFunc)
  if MapManager:IsPVPMode_TeamPws() or validScenicSpots == nil then
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
    return
  end
  for k, v in pairs(validScenicSpots) do
    if v.ID then
      self:_UpdateSceneSpot(v)
    else
      for i = 1, #v do
        if v[i].ID then
          self:_UpdateSceneSpot(v[i])
        end
      end
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
end

function MainViewMiniMap:_UpdateSceneSpot(scenicSpot, forceUpdate)
  if MapManager:IsPVPMode_TeamPws() then
    return
  end
  local isDiaplay, mapStr = AdventureDataProxy.Instance:IsSceneryHasTakePic(scenicSpot.ID)
  if isDiaplay then
    mapStr = "map_Lookout"
  else
    mapStr = "map_Lookout_lock"
  end
  local spotConfig = Table_Viewspot[scenicSpot.ID]
  if not isDiaplay and spotConfig and (spotConfig.Type == 1 or spotConfig.Type == 3) then
    local p = scenicSpot.position
    if p ~= nil then
      local guid = scenicSpot.ID
      if scenicSpot.guid then
        guid = scenicSpot.ID .. "_" .. scenicSpot.guid
      end
      local spotData = self.spotDatas[guid]
      if spotData == nil then
        spotData = MiniMapData.CreateAsTable(guid)
        self.spotDatas[guid] = spotData
      end
      spotData:SetPos(p[1], p[2], p[3])
      spotData:SetParama("Symbol", mapStr)
    end
  end
  if forceUpdate then
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
  end
end

function MainViewMiniMap:_RemoveSceneSpot(scenicSpot, forceUpdate)
  local ID, guid = scenicSpot.ID, scenicSpot.guid
  guid = guid and ID .. "_" .. guid
  local spotData = self.spotDatas[guid]
  if spotData ~= nil then
    spotData:Destroy()
  end
  self.spotDatas[guid] = nil
  if forceUpdate then
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
  end
end

function MainViewMiniMap:HandleCreatureScenicChange(note)
  local spotDatas = note.body
  if spotDatas then
    for i = 1, #spotDatas do
      self:_UpdateSceneSpot(spotDatas[i])
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
  end
end

function MainViewMiniMap:HandleCreatureScenicAdd(note)
  local sceneSpots = note.body
  for i = 1, #sceneSpots do
    self:_UpdateSceneSpot(sceneSpots[i])
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
end

function MainViewMiniMap:HandleCreatureScenicRemove(note)
  self:_RemoveSceneSpot(note.body, true)
end

function MainViewMiniMap:UpdateScenicSpotSymbol(note)
  self:UpdateSceneSpots(note.body.validScenicSpots)
end

function MainViewMiniMap:HandleScenicSpotUpdate(note)
  local updateSceneIds = note.body
  for i = 1, #updateSceneIds do
    local id = updateSceneIds[i]
    if id and self.spotDatas[id] then
      self.spotDatas[id]:Destroy()
      self.spotDatas[id] = nil
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateScenicSpotSymbol, self.spotDatas, true)
end

function MainViewMiniMap:UpdateMapSealPoint()
  local nowMapId = MapManager:GetMapID()
  local data = SealProxy.Instance:GetSealData(nowMapId)
  if data then
    if not self.sealDatasMap then
      self.sealDatasMap = {}
    else
      _TableClearByDeleter(self.sealDatasMap, miniMapDataDeleteFunc)
    end
    for k, v in pairs(data.itemMap) do
      local symbol = v.issealing and "map_whirlpool2" or "map_whirlpool"
      local sealMapData = self.sealDatasMap[k]
      if sealMapData == nil then
        sealMapData = MiniMapData.CreateAsTable(k)
        self.sealDatasMap[k] = sealMapData
      end
      sealMapData:SetPos(v.pos[1], v.pos[2], v.pos[3])
      sealMapData:SetParama("Symbol", symbol)
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateSealSymbol, self.sealDatasMap, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateSealSymbol, self.sealDatasMap, true)
  end
end

function MainViewMiniMap:RefreshTreeListUpdate()
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTreePoints, self.treeMapDatasMap, false)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTreePoints, self.treeMapDatasMap, false)
end

function MainViewMiniMap:HandleTreeListUpdate(note)
  local treePoints = note.body.updates
  local dels = note.body.dels
  if treePoints ~= nil then
    if not self.treeMapDatasMap then
      self.treeMapDatasMap = {}
    else
      _TableClearByDeleter(self.treeMapDatasMap, miniMapDataDeleteFunc)
    end
    for i = 1, #treePoints do
      local single = treePoints[i]
      local treeMapData = self.treeMapDatasMap[single.id]
      if treeMapData == nil then
        treeMapData = MiniMapData.CreateAsTable(single.id)
        self.treeMapDatasMap[single.id] = treeMapData
      end
      treeMapData:SetPos(single.pos.x / 1000, single.pos.y / 1000, single.pos.z / 1000)
      treeMapData:SetParama("Symbol", "map_plant")
    end
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTreePoints, self.treeMapDatasMap, false)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTreePoints, self.treeMapDatasMap, false)
  end
  if dels ~= nil then
    for i = 1, #dels do
      self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveTreePoint, dels[i])
      self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveTreePoint, dels[i])
    end
  end
end

function MainViewMiniMap:ClearTreeList()
  if not self.treeMapDatasMap then
    return
  end
  _TableClearByDeleter(self.treeMapDatasMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTreePoints, self.treeMapDatasMap, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTreePoints, self.treeMapDatasMap, true)
end

function MainViewMiniMap:HandleUpdateBCatPos(note)
  local bigCatActivityData = FunctionActivity.Me():GetActivityData(ACTIVITYTYPE.EACTIVITYTYPE_BCAT)
  local mapId = bigCatActivityData and bigCatActivityData.mapid
  local serverPos = note.body.pos
  if serverPos and MapManager:GetMapID() == mapId then
    local tempV3 = LuaGeometry.GetTempVector3(serverPos.x / 1000, serverPos.y / 1000, serverPos.z / 1000)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateBigCatSymbol, tempV3)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateBigCatSymbol, tempV3)
  else
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateBigCatSymbol)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateBigCatSymbol)
  end
end

function MainViewMiniMap:HandleAddQuestFocus(note)
  if not self.focusMap then
    self.focusMap = {}
  end
  local questId, pos, hideSymbol = note.body[1], note.body[2], note.body[3]
  local focusData = self.focusMap[questId]
  if not focusData then
    focusData = MiniMapData.CreateAsTable(questId)
    focusData:SetParama("questId", questId)
    self.focusMap[questId] = focusData
  end
  focusData:SetPos(pos[1], pos[2], pos[3])
  focusData:SetParama("hideSymbol", hideSymbol)
  focusData:SetShowRange(-1)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateQuestFocuses, self.focusMap)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateQuestFocuses, self.focusMap)
end

function MainViewMiniMap:HandleRemoveQuestFocus(note)
  local questId = note.body
  if questId and self.focusMap then
    local focusData = self.focusMap[questId]
    if focusData then
      focusData:Destroy()
    end
    self.focusMap[questId] = nil
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveQuestFocusByQuestId, questId)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveQuestFocusByQuestId, questId)
  end
end

function MainViewMiniMap:HandlePlayQuestDirEffect(note)
  local questId = note.body
  if questId then
    self.minimapWindow:PlayFocusFrameEffect(questId)
  end
end

function MainViewMiniMap:HandlePlayerCampChange(player)
  if player then
    self:_UpdatePlayerSymbolData(player)
    self:UpdatePlayerSymbolsPos()
  end
end

function MainViewMiniMap:HandlePlayerHidingChange(playerid)
  local player = NSceneUserProxy.Instance:Find(playerid)
  if player then
    self:_UpdatePlayerSymbolData(player)
    self:UpdatePlayerSymbolsPos()
  end
end

function MainViewMiniMap:HandlePlayerStatusChange(note)
  local player = note.body
  if player then
    self:_UpdatePlayerSymbolData(player)
    self:UpdatePlayerSymbolsPos()
    self:UpdateTeamMemberPos(player.data.id, true)
  end
end

function MainViewMiniMap:UpdateTransmitter()
  if self:IsCurMapHasTransmitter() and self:CheckTransmitterIconAvailableInMap() then
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTransmitterPoints, self.bigmaplarge or false)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTransmitterPoints, self.bigmaplarge or false, true)
  else
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveTransmitterPoints)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveTransmitterPoints)
  end
  if MapManager:IsBigWorld() and self:IsCurMapHasTransmitter() then
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateZoneBlocks)
  else
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.RemoveZoneBlocks)
  end
end

function MainViewMiniMap:HandleUpdateTransmitter()
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.RemoveTransmitterPoints)
  self:UpdateTransmitter()
end

local updateAreaTipsMiniMapData = function(miniMapData, tipsData)
  miniMapData:SetPos(tipsData[1], tipsData[2], 0)
  miniMapData:SetParama("Text", tipsData[3])
end

function MainViewMiniMap:UpdateShowAreaTips()
  local areaTipsData = self.mapdata and self.mapdata.AreaTips
  local areaTipsCount = type(areaTipsData) == "table" and #areaTipsData or 0
  local miniMapData
  for i = 1, areaTipsCount do
    miniMapData = self.areaTipsInfo[i]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(i)
      self.areaTipsInfo[i] = miniMapData
    end
    updateAreaTipsMiniMapData(miniMapData, areaTipsData[i])
  end
  for i = areaTipsCount + 1, #self.areaTipsInfo do
    miniMapDataDeleteFunc(self.areaTipsInfo[i])
    self.areaTipsInfo[i] = nil
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateAreaTips, self.areaTipsInfo)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateAreaTips, self.areaTipsInfo)
end

local Player_Symbol_Name_Map = {
  [1] = "map_red",
  [2] = "map_blue",
  [3] = "map_yellow"
}
local GvgDroiyan_Player_Symbol_Name_Map = {
  [1] = "map_red",
  [2] = "map_blue",
  [3] = "map_purple",
  [4] = "map_green"
}
local Othello_Player_Symbol = {
  [1] = "othello_white",
  [2] = "othello_black"
}
local BuffToBallMap
local Init_BuffToBallMap = function()
  if BuffToBallMap ~= nil then
    return
  end
  BuffToBallMap = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    BuffToBallMap[raidId] = {}
    local npcsID = config.ElementNpcsID
    for k, v in pairs(npcsID) do
      BuffToBallMap[raidId][v.buffid] = v
    end
  end
end
local Func_GetTeamPwsBallSymbol = function(creature)
  if MapManager:IsPVPMode_TeamPwsOthello() then
    return
  end
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local buffs = creature.buffs
  if buffs == nil then
    return
  end
  Init_BuffToBallMap()
  local nowRaid = MapManager:GetRaidID()
  local map = BuffToBallMap[nowRaid] or next(BuffToBallMap)
  for buffid, _ in pairs(buffs) do
    if map[buffid] then
      return map[buffid].mapicon
    end
  end
end

function MainViewMiniMap:_GetScenePlayerSymbolName(player, includeMyself)
  if player == Game.Myself and not includeMyself then
    return
  end
  local myPvpColor = MyselfProxy.Instance:GetPvpColor()
  local isOb = _PvpObProxy:IsRunning()
  local playerid = player.data.id
  local playerSymbolName
  local tag = player.data.userdata:Get(UDEnum.PVP_COLOR)
  local symbolMap = MapManager:IsGvgMode_Droiyan() and GvgDroiyan_Player_Symbol_Name_Map or Player_Symbol_Name_Map
  symbolMap = MapManager:IsPVPMode_TeamPwsOthello() and Othello_Player_Symbol or symbolMap
  if MapManager:IsPVPMode_PoringFight() then
    playerSymbolName = "map_green"
  elseif MapManager:IsPVPMode_TeamPwsExcludeOthello() and not isOb then
    playerSymbolName = myPvpColor == tag and Player_Symbol_Name_Map[2] or Player_Symbol_Name_Map[1]
  elseif symbolMap and tag and symbolMap[tag] then
    playerSymbolName = symbolMap[tag]
  elseif MapManager:IsPVPMode_3Teams() then
    local tripleUser = PvpProxy.Instance:GetTripleUserInfo(playerid)
    if tripleUser then
      local tripleCamp = tripleUser.camp
      if tripleCamp == ETRIPLECAMP.ETRIPLE_CAMP_RED then
        playerSymbolName = "map_dot"
      elseif tripleCamp == ETRIPLECAMP.ETRIPLE_CAMP_YELLOW then
        playerSymbolName = "map_yellow"
      elseif tripleCamp == ETRIPLECAMP.ETRIPLE_CAMP_BLUE then
        playerSymbolName = "map_blue"
      elseif tripleCamp == ETRIPLECAMP.ETRIPLE_CAMP_GREEN then
        playerSymbolName = "map_green"
      end
    end
  elseif MapManager:IsPVPMode_EndlessBattleField() then
    local camp = player.data:GetCamp()
    if camp == RoleDefines_Camp.ENEMY then
      playerSymbolName = "map_dot"
    elseif camp == RoleDefines_Camp.FRIEND then
      playerSymbolName = "map_blue"
    end
  else
    local camp = player.data:GetCamp()
    if camp == RoleDefines_Camp.ENEMY then
      playerSymbolName = "map_dot"
    end
  end
  local pwsSymbol = Func_GetTeamPwsBallSymbol(player)
  if pwsSymbol then
    playerSymbolName = pwsSymbol
  end
  if playerSymbolName == nil and not self.teamMemberMapDatas[playerid] then
    if _TeamProxy:IsInMyTeam(playerid) then
      playerSymbolName = "map_teammate"
    elseif _TeamProxy:IsInMyGroup(playerid) and (MapManager:IsPveMode_Thanatos() or MapManager:IsPvPMode_TeamTwelve()) then
      playerSymbolName = "map_teammate"
    end
  end
  local hideValue = player.data.props:GetPropByName("Hiding"):GetValue()
  if 0 < hideValue and not Game.MapManager:IsPVPRaidMode() then
    playerSymbolName = nil
  end
  return playerSymbolName
end

function MainViewMiniMap:_GetOutNineScreenPlayerSymbolName(playerid, camp)
  if _PvpObProxy:IsRunning() then
    return _PvpObProxy:IsInFriendCamp(playerid) and "map_teammate" or "map_dot"
  elseif camp and camp ~= 0 then
    if MapManager:IsPvPMode_TeamTwelve() then
      return camp == Game.Myself.data:GetTwelvePVPCamp() and "map_teammate" or "map_dot"
    else
      return camp == Game.Myself.data:GetNormalPVPCamp() and "map_blue" or "map_dot"
    end
  else
    return _TeamProxy:IsInMyGroup(playerid) and "map_teammate" or "map_dot"
  end
end

function MainViewMiniMap:_UpdatePlayerSymbolData(player)
  if player == nil then
    return
  end
  if player.GetCreatureType and player:GetCreatureType() ~= Creature_Type.Player then
    return
  end
  local playerid = player.data.id
  local playerSymbolName
  if self.teamMemberMapDatas[playerid] and not Game.MapManager:IsPvpMode_DesertWolf() then
    playerSymbolName = nil
  else
    playerSymbolName = self:_GetScenePlayerSymbolName(player)
  end
  local miniMapData = self.playerMap[playerid]
  if playerSymbolName ~= nil then
    if miniMapData == nil then
      miniMapData = MiniMapData.CreateAsTable(playerid)
      self.playerMap[playerid] = miniMapData
    end
    local pos = player:GetPosition()
    if pos then
      miniMapData:SetPos(pos[1], pos[2], pos[3])
    end
    miniMapData:SetParama("Symbol", playerSymbolName)
    miniMapData:SetParama("depth", 4)
  elseif miniMapData ~= nil then
    miniMapData:Destroy()
    self.playerMap[playerid] = nil
  end
end

function MainViewMiniMap:_RemovePlayerSymbolData(id)
  local miniMapData = self.playerMap[id]
  if miniMapData then
    miniMapData:Destroy()
  end
  self.playerMap[id] = nil
end

function MainViewMiniMap:UpdatePlayerSymbolsPos()
  local hasPlayer = false
  local outScreenPlayers = self.outScreenMapInfo[0]
  for playerid, miniMapData in pairs(self.playerMap) do
    if self.teamMemberMapDatas[playerid] then
      if miniMapData then
        miniMapData:Destroy()
      end
      self.playerMap[playerid] = nil
    else
      local player = SceneCreatureProxy.FindCreature(playerid)
      if player ~= nil then
        local pos = player:GetPosition()
        if pos then
          miniMapData:SetPos(pos[1], pos[2], pos[3])
        end
        self:UpdateTeamMateSymbol(playerid, miniMapData)
      else
        local posData = outScreenPlayers and outScreenPlayers[playerid]
        if posData and miniMapData then
          miniMapData:SetPos(posData.x, posData.y, posData.z)
        else
          if miniMapData then
            miniMapData:Destroy()
          end
          self.playerMap[playerid] = nil
        end
      end
    end
    hasPlayer = true
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePlayerPoses, self.playerMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePlayerPoses, self.playerMap, true)
  if hasPlayer == true then
    if self.playerPosCheck == nil then
      self.playerPosCheck = TimeTickManager.Me():CreateTick(0, 1000, self.UpdatePlayerSymbolsPos, self, 2)
    end
  elseif self.playerPosCheck then
    TimeTickManager.Me():ClearTick(self, 2)
    self.playerPosCheck = nil
  end
end

function MainViewMiniMap:HandleMapGuide_Change(note)
  FunctionGuide.Me():AttachGuideEffect(self.bigMapButton, Guild_RemoveType.Time | Guild_RemoveType.Click)
  FunctionGuide.Me():AttachGuideEffect(self.miniMapButton, Guild_RemoveType.Time | Guild_RemoveType.Click)
end

local GameConfig_GvgDroiyan = GameConfig.GvgDroiyan
local RobPlatformId_Prefix = "RobPlatform_"
local BornGorgeousMetalId_Prefix = "BornGorgeousMetal_"
local GvgDroiyan_SymbolMap = {
  [0] = "gvg_bg_gray",
  [1] = "gvg_bg_red",
  [2] = "gvg_bg_blue",
  [3] = "gvg_bg_purple",
  [4] = "gvg_bg_green"
}

function MainViewMiniMap:UpdateGvgDroiyanInfos(note)
  if not MapManager:IsGvgMode_Droiyan() then
    self:ClearGvgDroiyanInfos()
    return
  end
  _TableClearByDeleter(self.gvgDroiyanMap, miniMapDataDeleteFunc)
  local robPlatform = GameConfig_GvgDroiyan and GameConfig_GvgDroiyan.RobPlatform
  for index, v in pairs(robPlatform) do
    local pos = v.pos
    local map_guid = RobPlatformId_Prefix .. index
    local miniMapData = MiniMapData.CreateAsTable(map_guid)
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", GvgDroiyan_SymbolMap[0])
    self.gvgDroiyanMap[map_guid] = miniMapData
  end
  local towersMap = _SuperGvgProxy:GetTowersMap() or _EmptyTable
  for k, clientGvgTowerData in pairs(towersMap) do
    local index = _SuperGvgProxy:GetIndexByGuildId(clientGvgTowerData.owner_guild)
    if index and index ~= 0 then
      local map_guid = RobPlatformId_Prefix .. tostring(clientGvgTowerData.etype)
      local miniMapData = self.gvgDroiyanMap[map_guid]
      if miniMapData ~= nil then
        miniMapData:SetParama("Symbol", GvgDroiyan_SymbolMap[index])
      end
    end
  end
  local bornGorgeousMetal = GameConfig_GvgDroiyan and GameConfig_GvgDroiyan.BornGorgeousMetal
  for index, v in pairs(bornGorgeousMetal) do
    local pos = v.pos
    local map_guid = BornGorgeousMetalId_Prefix .. index
    local miniMapData = MiniMapData.CreateAsTable(map_guid)
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", GvgDroiyan_SymbolMap[index])
    self.gvgDroiyanMap[map_guid] = miniMapData
  end
  local guildsMap = _SuperGvgProxy:GetGuildsMap()
  for k, clientGvgGuildInfo in pairs(guildsMap) do
    local map_guid = BornGorgeousMetalId_Prefix .. clientGvgGuildInfo.index
    local miniMapData = self.gvgDroiyanMap[map_guid]
    if miniMapData ~= nil then
      miniMapData:SetParama("metal_live", clientGvgGuildInfo.metal_live and 1 or 0)
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgDroiyanInfos, self.gvgDroiyanMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgDroiyanInfos, self.gvgDroiyanMap, true)
end

function MainViewMiniMap:ClearGvgDroiyanInfos()
  _TableClearByDeleter(self.gvgDroiyanMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgDroiyanInfos, self.gvgDroiyanMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgDroiyanInfos, self.gvgDroiyanMap, true)
  self:ActiveGvgFinalFightTip(false)
end

function MainViewMiniMap:ShowPoringFightMapItems()
  _TableClearByDeleter(self.poringFightDropMap, miniMapDataDeleteFunc)
  if SceneItemProxy.Instance ~= nil then
    for id, data in pairs(SceneItemProxy.Instance.userMap) do
      if data.staticData.id == 157 then
        local miniMapData = MiniMapData.CreateAsTable(id)
        local pos = data.pos
        miniMapData:SetPos(pos.x, pos.y, pos.z)
        miniMapData:SetParama("Symbol", "map_apple")
        self.poringFightDropMap[id] = miniMapData
      end
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
end

function MainViewMiniMap:ClearPoringFightMapItems()
  _TableClearByDeleter(self.poringFightDropMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
end

function MainViewMiniMap:HandleAddMapItem(note)
  if not MapManager:IsPVPMode_PoringFight() or not SceneItemProxy.Instance then
    return
  end
  local items = note.body and note.body.items
  if not items then
    return
  end
  for i = 1, #items do
    local item = SceneItemProxy.Instance.userMap[items[i].guid]
    if item and item.staticData.id == 157 and not self.poringFightDropMap[item.id] then
      local miniMapData = MiniMapData.CreateAsTable(item.id)
      local pos = item.pos
      miniMapData:SetPos(pos.x, pos.y, pos.z)
      miniMapData:SetParama("Symbol", "map_apple")
      self.poringFightDropMap[item.id] = miniMapData
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
end

function MainViewMiniMap:HandelPickupItem(note)
  if not MapManager:IsPVPMode_PoringFight() or not SceneItemProxy.Instance then
    return
  end
  local id = note.body and note.body.itemguid
  if self.poringFightDropMap[id] then
    self.poringFightDropMap[id]:Destroy()
    self.poringFightDropMap[id] = nil
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePoringFightMapItems, self.poringFightDropMap, true)
  end
end

function MainViewMiniMap:RefreshButterflyAndFlyButtons()
  self:RefreshButtonStatus(self.UseButterflyButtonInfo)
  self:RefreshButtonStatus(self.UseFlyButtonInfo)
end

function MainViewMiniMap:RefreshButtonStatus(go)
  local item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.MainBag)
  if nil == item then
    item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.Temp)
  end
  if nil == item then
    self:SetTextureGrey(go.base)
    self:SetTextureGrey(go.icon)
  else
    self:SetTextureWhite(go.base)
    self:SetTextureWhite(go.icon)
  end
end

function MainViewMiniMap:TryUseButterflyOrFly(go)
  local item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.MainBag)
  if nil == item then
    item = BagProxy.Instance:GetItemByStaticID(go.itemID, BagProxy.BagType.Temp)
  end
  if nil ~= item then
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(go.msgID)
    if nil == dont then
      MsgManager.DontAgainConfirmMsgByID(go.msgID, function()
        FunctionItemFunc.TryUseItem(item)
      end)
    else
      local raidReward = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_HAS_USERRETURN_RAID_AWARD) or 0
      if 0 < raidReward then
        MsgManager.ConfirmMsgByID(42085, function()
          FunctionItemFunc.TryUseItem(item)
        end, nil)
      else
        FunctionItemFunc.TryUseItem(item)
      end
    end
  else
    item = Table_Item[go.itemID]
    if nil ~= item then
      MsgManager.ShowMsgByID(go.msgDoNotHaveID, item.NameZh)
    else
      redlog("Cannot Find Item Data: " .. go.itemID)
    end
  end
  self:RefreshButtonStatus(go)
end

function MainViewMiniMap:UpdatePlayersSymbolData(note)
  local nSceneUserProxy = NSceneUserProxy.Instance
  for id, _ in pairs(self.playerMap) do
    self:_UpdatePlayerSymbolData(nSceneUserProxy:Find(id))
  end
end

local GetBallBornPosSID = function(id)
  return "Born_" .. id
end
local GetBallBallPosSID = function(id)
  return "Ball_" .. id
end

function MainViewMiniMap:UpdateTeamPwsMapInfo(note)
  if MapManager:IsPVPMode_TeamPwsOthello() then
    return
  end
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  local ballBornPos = _PvpTeamRaid.ElementBornPosition
  local sid
  for id, pos in pairs(ballBornPos) do
    sid = GetBallBornPosSID(id)
    local miniMapData = self.teamPwsMapInfo[sid]
    if miniMapData == nil then
      miniMapData = MiniMapData.CreateAsTable(sid)
      self.teamPwsMapInfo[sid] = miniMapData
    end
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", "map_tpvppt")
    miniMapData:SetParama("depth", 10)
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
end

function MainViewMiniMap:UpdateTeamBallInfos(updates)
  if MapManager:IsPVPMode_TeamPwsOthello() then
    return
  end
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  if updates == nil or #updates == 0 then
    return
  end
  for i = 1, #updates do
    self:UpdateTeamPwsBallInfoData(updates[i])
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
  self:UpdatePlayersSymbolData()
end

local tempBallMap

function MainViewMiniMap:UpdateTeamPwsBallInfoData(ballNpc)
  if MapManager:IsPVPMode_TeamPwsOthello() then
    return
  end
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  if tempBallMap == nil then
    tempBallMap = {}
    local ballConfig = _PvpTeamRaid.ElementNpcsID
    for id, config in pairs(ballConfig) do
      tempBallMap[config.npcid] = {id, config}
    end
  end
  local npcid = ballNpc.data.staticData and ballNpc.data.staticData.id
  local tempConfig = npcid and tempBallMap[npcid]
  if tempConfig == nil then
    return
  end
  local sid = GetBallBallPosSID(ballNpc.data.id)
  local miniMapData = self.teamPwsMapInfo[sid]
  if miniMapData == nil then
    miniMapData = MiniMapData.CreateAsTable(sid)
    self.teamPwsMapInfo[sid] = miniMapData
  end
  miniMapData:SetParama("Symbol", tempConfig[2].mapicon)
  local p = ballNpc:GetPosition()
  miniMapData:SetPos(p[1], p[2], p[3])
  miniMapData:SetParama("depth", 11)
end

function MainViewMiniMap:RemoveTeamPwsBallInfo(dels)
  if MapManager:IsPVPMode_TeamPwsOthello() then
    return
  end
  if not MapManager:IsPVPMode_TeamPws() then
    return
  end
  local dirty = false
  for i = 1, #dels do
    local npcid = dels[i]
    local sid = GetBallBallPosSID(npcid)
    local miniMapData = self.teamPwsMapInfo[sid]
    if miniMapData then
      miniMapData:Destroy()
      self.teamPwsMapInfo[sid] = nil
      dirty = true
    end
  end
  if dirty then
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
  end
end

function MainViewMiniMap:ClearAllTeamPwsMapInfo()
  _TableClearByDeleter(self.teamPwsMapInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTeamPwsInfo, self.teamPwsMapInfo, true)
  self:UpdateTeamMembersPos(true)
  self:ClearPlayerMap()
end

function MainViewMiniMap:HandleOpenMap(note)
  local t = note.body
  if MapManager:IsBigWorld() then
    if t == "forward" then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BWMiniMapView,
        viewdata = {}
      })
    elseif t == "reverse" then
      self:sendNotification(UIEvent.CloseUI, {
        className = "BWMiniMapView",
        needRollBack = false
      })
    elseif not UIManagerProxy.Instance:HasUINode(PanelConfig.BWMiniMapView) then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BWMiniMapView,
        viewdata = {}
      })
    else
      self:sendNotification(UIEvent.CloseUI, {
        className = "BWMiniMapView",
        needRollBack = false
      })
    end
  elseif t == "forward" then
    self:ActiveMapBord(true)
  elseif t == "reverse" then
    self:ActiveMapBord(false)
  else
    self:ActiveMapBord(not self.mapBord.activeInHierarchy)
  end
end

function MainViewMiniMap:HandleAddNpcs(note)
  self:UpdateTeamBallInfos(note.body)
  self:UpdateTripleTeamRobotPlayerMapInfo(note.body)
end

function MainViewMiniMap:HandleRemoveNpcs(note)
  self:RemoveTeamPwsBallInfo(note.body)
  self:RemoveTripleTeamRobotPlayerMapInfo(note.body)
end

function MainViewMiniMap:HandleTeamPwsBallChange(note)
  self:UpdateTeamMembersPos(true)
  self:UpdatePlayersSymbolData()
end

function MainViewMiniMap:HandleOthelloPointChange(note)
  self:UpdateOthelloMapInfo()
end

function MainViewMiniMap:UpdateWeather()
  local weatherid = ServiceWeatherProxy.Instance.weatherID
  if self.weather then
    self:SetObjActive(self.weather.gameObject, weatherid and weatherid ~= 0)
    local staticData = Table_Weather[weatherid]
    if not staticData or staticData.Icon == "" then
      self:SetObjActive(self.weather.gameObject, false)
    else
      local atlas = RO.AtlasMap.GetAtlas("Weather")
      self.weather.atlas = atlas
      self.weather.spriteName = staticData and staticData.Icon or ""
      self.weathername.text = staticData and staticData.NameZh or ""
    end
  end
end

function MainViewMiniMap:UpdateThanatosSymbol()
  _TableClearByDeleter(self.thanatosSymbols, miniMapDataDeleteFunc)
  local isThanatosMap = MapManager:IsPveMode_Thanatos()
  if isThanatosMap then
    if self.thanatosTick == nil then
      self.thanatosTick = TimeTickManager.Me():CreateTick(0, 500, self._UpdateThanatosSymbol, self, 111)
    end
  elseif self.thanatosTick then
    TimeTickManager.Me():ClearTick(self, 111)
    self.thanatosTick = nil
    if self.thanatosSymbols == nil then
      self.thanatosSymbols = {}
    else
      _TableClearByDeleter(self.thanatosSymbols, miniMapDataDeleteFunc)
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateThanatosInfo, self.thanatosSymbols, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateThanatosInfo, self.thanatosSymbols, true)
  end
end

local Crystal_ShieldID_Map

function MainViewMiniMap:Get_Crystal_ShieldID_Map(currentMapID)
  if Crystal_ShieldID_Map then
    return Crystal_ShieldID_Map
  end
  Crystal_ShieldID_Map = {}
  local tgConfig = Table_TeamGroupRaid[currentMapID]
  if not tgConfig then
    for k, v in pairs(Table_TeamGroupRaid) do
      if v.InnerRaidID and v.InnerRaidID == currentMapID then
        tgConfig = v
        break
      end
    end
  end
  local CrystalInfoMap = GameConfig.Thanatos[tgConfig.Difficulty].CrystalshieldID
  for k, info in pairs(CrystalInfoMap) do
    Crystal_ShieldID_Map[info[1]] = info[2]
  end
  return Crystal_ShieldID_Map
end

function MainViewMiniMap:_UpdateThanatosSymbol()
  local npcMapSymbols = GameConfig.Thanatos_Public.NpcMapSymbols
  if npcMapSymbols == nil then
    return
  end
  local frameCount = UnityFrameCount
  local npcs, npc
  for npcID, iconInfo in pairs(npcMapSymbols) do
    npcs = _NSceneNpcProxy:FindNpcs(npcID)
    if npcs and 0 < #npcs then
      for i = 1, #npcs do
        npc = npcs[i]
        local mapData = self.thanatosSymbols[npc.data.id]
        if mapData == nil then
          mapData = MiniMapData.CreateAsTable(npc.data.id)
          self.thanatosSymbols[npc.data.id] = mapData
        end
        local pos = npc:GetPosition()
        mapData:SetPos(pos[1], pos[2], pos[3])
        mapData:SetParama("Symbol", iconInfo[1])
        mapData:SetParama("SymbolBg", iconInfo[2] or "")
        mapData:SetParama("tag", frameCount)
      end
    end
  end
  local iconMap = self:Get_Crystal_ShieldID_Map(MapManager:GetRaidID())
  local crystalMapSymbol = GameConfig.Thanatos_Public.CrystalMapSymbol
  for npcID, iconInfo in pairs(crystalMapSymbol) do
    npcs = _NSceneNpcProxy:FindNpcs(npcID)
    if npcs and 0 < #npcs then
      for i = 1, #npcs do
        npc = npcs[i]
        local mapData = self.thanatosSymbols[npc.data.id]
        if mapData == nil then
          mapData = MiniMapData.CreateAsTable(npc.data.id)
          mapData:SetParama("SymbolBg", "")
          self.thanatosSymbols[npc.data.id] = mapData
        end
        if npc:IsDead() then
          mapData:SetParama("Symbol", iconInfo[3])
        else
          local sheildNpc_uid = iconMap[npc.data.uniqueid]
          local sheildNpc = _NSceneNpcProxy:FindNpcByUniqueId(sheildNpc_uid)
          if sheildNpc then
            mapData:SetParama("Symbol", iconInfo[2])
          else
            mapData:SetParama("Symbol", iconInfo[1])
          end
        end
        local pos = npc:GetPosition()
        mapData:SetPos(pos[1], pos[2], pos[3])
        mapData:SetParama("tag", frameCount)
      end
    end
  end
  for k, data in pairs(self.thanatosSymbols) do
    local tag = data:GetParama("tag")
    if tag ~= frameCount then
      data:Destroy()
      self.thanatosSymbols[k] = nil
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateThanatosInfo, self.thanatosSymbols, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateThanatosInfo, self.thanatosSymbols, true)
end

function MainViewMiniMap:UpdateOthelloMapInfo(note)
  if not MapManager:IsPVPMode_TeamPwsOthello() then
    return
  end
  if not self.isInitLinkPoint then
    self:InitLinkPoint()
  end
  local othelloCfg = DungeonProxy.Instance:GetOthelloConfigRaid()
  if not othelloCfg then
    return
  end
  local symbolMap = othelloCfg.PointMapSymbols
  local checkpointConfig = othelloCfg.points
  local symbolValue, pos, npc, npcs
  for id, pointConfig in pairs(checkpointConfig) do
    local miniMapData = self.othelloMapInfo[id]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(id)
      self.othelloMapInfo[id] = miniMapData
    end
    npcs = _NSceneNpcProxy:FindNpcs(pointConfig.npcid)
    if not npcs then
      redlog("pointConfig.uniqueid", pointConfig.uniqueid)
      return
    else
      pos = npcs[1]:GetPosition()
    end
    if not self.othelloCacheMapInfo then
      self.othelloCacheMapInfo = {}
    end
    symbolValue = _PvpProxy:GetOthelloOccupyStatus(id) or 0
    if not self.othelloCacheMapInfo[id] then
      self.othelloCacheMapInfo[id] = symbolValue
    end
    if pos then
      miniMapData:SetPos(pos[1], pos[2], pos[3])
    end
    if pointConfig.type ~= 3 then
      miniMapData:SetParama("check_Symbol", symbolMap[symbolValue][1])
    else
      miniMapData:SetParama("check_Symbol", symbolMap[symbolValue][2])
    end
    miniMapData:SetParama("depth", 10)
  end
  local bornsymbolMap = othelloCfg.BirthPosition
  for index, config in pairs(bornsymbolMap) do
    local miniMapData = self.othelloMapInfo[10 * index]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(10 * index)
      self.othelloMapInfo[10 * index] = miniMapData
    end
    if config.pos then
      miniMapData:SetPos(config.pos[1], config.pos[2], config.pos[3])
    end
    miniMapData:SetParama("check_Symbol", config.mapSymbols)
    miniMapData:SetParama("depth", 10)
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateOthelloInfos, self.othelloMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateOthelloInfos, self.othelloMapInfo, true)
  self:CheckLink()
end

local occupy
local updateindex = 0

function MainViewMiniMap:UpdateCheckpointMap(note)
  if not note then
    return
  end
  occupy = note and note.body.occupy
  for i = 1, #occupy do
    updateindex = occupy[i].pointid
    self:UpdateSinglePoint(updateindex)
  end
end

function MainViewMiniMap:UpdateSinglePoint(id)
  local othelloCfg = DungeonProxy.Instance:GetOthelloConfigRaid()
  if not othelloCfg then
    return
  end
  local symbolMap = othelloCfg.PointMapSymbols
  local checkpointConfig = othelloCfg.points
  local miniMapData = self.othelloMapInfo[id]
  pointConfig = checkpointConfig[id]
  local npcs = _NSceneNpcProxy:FindNpcs(pointConfig.npcid)
  if not miniMapData then
    miniMapData = MiniMapData.CreateAsTable(id)
    self.othelloMapInfo[id] = miniMapData
  end
  local pos
  if not npcs then
    redlog("pointConfig.uniqueid", pointConfig.uniqueid)
    return
  else
    pos = npcs[1]:GetPosition()
  end
  if not self.othelloCacheMapInfo then
    self.othelloCacheMapInfo = {}
  end
  local symbolValue = _PvpProxy:GetOthelloOccupyStatus(id)
  if not self.othelloCacheMapInfo[id] then
    self.othelloCacheMapInfo[id] = symbolValue
  end
  miniMapData:SetPos(pos[1], pos[2], pos[3])
  if pointConfig.type ~= 3 then
    miniMapData:SetParama("check_Symbol", symbolMap[symbolValue][1])
  else
    miniMapData:SetParama("check_Symbol", symbolMap[symbolValue][2])
  end
  miniMapData:SetParama("depth", 10)
end

local OthelloLinkPoint = {
  [1] = {
    {
      point = {2, 3},
      angle = 135,
      width = 110
    },
    {
      point = {9, 5},
      angle = 90,
      width = 152
    },
    {
      point = {8, 7},
      angle = 45,
      width = 110
    }
  },
  [2] = {
    {
      point = {9, 6},
      angle = 45,
      width = 110
    }
  },
  [3] = {
    {
      point = {9, 7},
      angle = 0,
      width = 152
    },
    {
      point = {4, 5},
      angle = 45,
      width = 110
    }
  },
  [4] = {
    {
      point = {9, 8},
      angle = -45,
      width = 110
    }
  },
  [5] = {
    {
      point = {6, 7},
      angle = -45,
      width = 110
    }
  },
  MaxCheck = 5
}
local tempSymbolA, tempSymbolB, starti, endi

function MainViewMiniMap:CheckLink()
  local findall
  for k, v in pairs(self.othelloLinkInfo) do
    starti = v:GetParama("startPoint")
    endilist = v:GetParama("endPoint")
    tempSymbolA = _PvpProxy:GetOthelloOccupyStatus(starti)
    findall = true
    if endilist then
      for i = 1, #endilist do
        findall = tempSymbolA == _PvpProxy:GetOthelloOccupyStatus(endilist[i]) and findall
      end
      if findall then
        if tempSymbolA == 1 then
          self.othelloLinkInfo[k]:SetParama("spriteName", "com_bg_shadow-W")
        elseif tempSymbolA == 2 then
          self.othelloLinkInfo[k]:SetParama("spriteName", "com_bg_shadow")
        end
        self.othelloLinkInfo[k]:SetParama("display", true)
      else
        self.othelloLinkInfo[k]:SetParama("display", false)
      end
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateLinkInfos, self.othelloLinkInfo, false)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateLinkInfos, self.othelloLinkInfo, false)
end

function MainViewMiniMap:InitLinkPoint()
  if self.isInitLinkPoint then
    return
  end
  local othelloCfg = DungeonProxy.Instance:GetOthelloConfigRaid()
  if not othelloCfg then
    return
  end
  local checkpointConfig = othelloCfg.points
  local pointConfig
  for i = 1, OthelloLinkPoint.MaxCheck do
    local single = OthelloLinkPoint[i]
    for j = 1, #single do
      local endConfig = single[j]
      local index = i * 10 + endConfig.point[#endConfig.point]
      local miniMapData = self.othelloLinkInfo[index]
      if not miniMapData then
        miniMapData = MiniMapData.CreateAsTable(index)
        self.othelloLinkInfo[index] = miniMapData
      end
      pointConfig = checkpointConfig[i]
      local npcs = _NSceneNpcProxy:FindNpcs(pointConfig.npcid)
      local pos
      if not npcs then
        redlog("pointConfig.uniqueid", pointConfig.uniqueid)
        return
      else
        pos = npcs[1]:GetPosition()
      end
      if pos then
        miniMapData:SetPos(pos[1], pos[2], pos[3])
        miniMapData:SetParama("depth", 9)
        miniMapData:SetParama("startPoint", i)
        miniMapData:SetParama("endPoint", endConfig.point)
        miniMapData:SetParama("angle", endConfig.angle)
        miniMapData:SetParama("display", false)
        miniMapData:SetParama("width", endConfig.width)
        if not self.isInitLinkPoint then
          self.isInitLinkPoint = true
        end
      else
        redlog("not pos")
      end
    end
  end
end

function MainViewMiniMap:ClearAllOthelloMapInfo()
  self.isInitLinkPoint = false
  _TableClearByDeleter(self.othelloMapInfo, miniMapDataDeleteFunc)
  _TableClearByDeleter(self.othelloLinkInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateOthelloInfos, self.othelloMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateOthelloInfos, self.othelloMapInfo, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateLinkInfos, self.othelloLinkInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateLinkInfos, self.othelloLinkInfo, true)
  self:UpdateTeamMembersPos(true)
  self:ClearPlayerMap()
end

local unlockRoomTypeMap = {}
local updateRoguelikeMiniMapData = function(miniMapData, roomType, hasFakeFog)
  miniMapData:SetParama("RoomType", roomType)
  miniMapData:SetParama("FakeFog", hasFakeFog)
end

function MainViewMiniMap:UpdateRoguelikeMapInfo()
  if not MapManager:IsPVEMode_Roguelike() then
    return
  end
  local subScenes = SceneProxy.Instance.currentScene.subScenes
  local totalRoomCount = subScenes and #subScenes
  if type(totalRoomCount) ~= "number" or totalRoomCount <= 0 then
    self:ClearAllRoguelikeMapInfo()
    return
  end
  local raid = DungeonProxy.Instance.roguelikeRaid
  _TableClear(unlockRoomTypeMap)
  for _, i in pairs(raid and raid.unlockRooms or _EmptyTable) do
    unlockRoomTypeMap[i] = true
  end
  local miniMapData
  for i = 1, totalRoomCount do
    miniMapData = self.roguelikeMapInfo[i]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(i)
      self.roguelikeMapInfo[i] = miniMapData
    end
    if unlockRoomTypeMap[i] then
      local roomType = DungeonProxy.GetRoguelikeRoomTypeByIndex(i)
      unlockRoomTypeMap[i] = roomType
      updateRoguelikeMiniMapData(miniMapData, roomType, false)
    else
      updateRoguelikeMiniMapData(miniMapData, raid and i == raid.exitRoom and 2 or nil, true)
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateRoguelikeMap, self.roguelikeMapInfo, totalRoomCount, unlockRoomTypeMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateRoguelikeMap, self.roguelikeMapInfo, totalRoomCount, unlockRoomTypeMap, true)
end

function MainViewMiniMap:ClearAllRoguelikeMapInfo()
  _TableClearByDeleter(self.roguelikeMapInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.ClearRoguelikeMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ClearRoguelikeMap)
  self:UpdateTeamMembersPos(true)
  self:ClearPlayerMap()
end

function MainViewMiniMap:OnRoguelikeLaunch()
  self.isRoguelikeMapNameShowed = false
end

function MainViewMiniMap:OnRoguelikeShutdown()
  self:ClearAllRoguelikeMapInfo()
  local raid = DungeonProxy.Instance.roguelikeRaid
  if raid then
    _TableClear(raid.unlockRooms)
  end
end

function MainViewMiniMap:OnRoguelikeRaidInfo()
  self:UpdateMapAllInfo()
  TimeTickManager.Me():CreateOnceDelayTick(50, function(self)
    self:UpdateMapAllInfo()
  end, self, 99)
  if not self.isRoguelikeMapNameShowed and MapManager:IsPVEMode_Roguelike() then
    local mapId = MapManager:GetMapID()
    local mapdata = mapId and Table_Map[mapId]
    if mapdata then
      local raid = DungeonProxy.Instance.roguelikeRaid
      FloatingPanel.Instance:ShowMapName(mapdata.NameZh .. DungeonProxy.GetGradeStr(raid and raid.grade))
    end
    self.isRoguelikeMapNameShowed = true
  end
end

local _sgManager

function MainViewMiniMap:UpdateStealthGameInfo()
  if not MapManager:IsPVEMode_HeartLockRaid() then
    return
  end
  if not _sgManager then
    _sgManager = SgAIManager.Me()
  end
  local index = 1
  for _, npc in pairs(_sgManager:getAllNpcs()) do
    if not npc:isDead() and self:_AddStealthGameNpc(npc, index) then
      index = index + 1
    end
  end
  for _, trigger in pairs(_sgManager:getAllTriggers()) do
    if self:_AddStealthGameTrigger(trigger, index) then
      index = index + 1
    end
  end
  for i = index, #self.stealthGameInfo do
    miniMapDataDeleteFunc(self.stealthGameInfo[i])
    self.stealthGameInfo[i] = nil
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateStealthGame, self.stealthGameInfo)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateStealthGame, self.stealthGameInfo)
end

function MainViewMiniMap:_AddStealthGameNpc(npc, index)
  local miniMapData = self:_GetStealthGameMiniMapData(index)
  local pos = npc:getPosition()
  if pos then
    miniMapData:SetParama("X", pos[1])
    miniMapData:SetParama("Z", pos[3])
    return true
  end
  return false
end

local _sgMapIconCfg

function MainViewMiniMap:_AddStealthGameTrigger(trigger, index)
  if not _sgMapIconCfg then
    _sgMapIconCfg = GameConfig.HeartLockMapIconShow
  end
  local uid = trigger:getUid()
  local icon = uid and _sgMapIconCfg[uid]
  if not icon then
    return false
  end
  local miniMapData = self:_GetStealthGameMiniMapData(index)
  local posX, _, posZ = trigger:getPositionXYZ()
  miniMapData:SetParama("X", posX)
  miniMapData:SetParama("Z", posZ)
  miniMapData:SetParama("Symbol", icon)
  return true
end

function MainViewMiniMap:_GetStealthGameMiniMapData(index)
  local miniMapData = self.stealthGameInfo[index]
  if not miniMapData then
    miniMapData = MiniMapData.CreateAsTable(index)
    self.stealthGameInfo[index] = miniMapData
  end
  return miniMapData
end

function MainViewMiniMap:ClearAllStealthGameInfo()
  _TableClearByDeleter(self.stealthGameInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.ClearStealthGame)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.ClearStealthGame)
  self:UpdateTeamMembersPos(true)
  self:ClearPlayerMap()
end

local stealthGameTickId = 82983

function MainViewMiniMap:OnStealthGameLaunch()
  TimeTickManager.Me():CreateTick(0, 33, self.UpdateStealthGameInfo, self, stealthGameTickId)
end

function MainViewMiniMap:OnStealthGameShutdown()
  self:ClearAllStealthGameInfo()
  TimeTickManager.Me():ClearTick(self, stealthGameTickId)
end

function MainViewMiniMap:IsCurMapHasTransmitter()
  local activeMapList = WorldMapProxy.Instance.availableTransmitterMap
  for mapID, status in pairs(activeMapList) do
    if mapID == MapManager:GetMapID() or mapID == MapManager:GetRaidID() then
      return true
    end
  end
  return false
end

function MainViewMiniMap:InitSettingToggle()
  if self.settingPageCtrl then
    local areaTips = self.mapdata and self.mapdata.AreaTips
    self.settingPageCtrl:ShowAreaTipsToggle(areaTips and next(areaTips))
  end
  self:UpdateQuestMapSymbol()
end

function MainViewMiniMap:CheckWorldQuestMap()
  local curMapId = MapManager:GetMapID()
  if GameConfig and GameConfig.Quest then
    if GameConfig.Quest and GameConfig.Quest.worldquestmap and type(GameConfig.Quest.worldquestmap[1].map) == "table" then
      local mapGroup = GameConfig.Quest.worldquestmap
      for k, v in pairs(mapGroup) do
        if TableUtility.ArrayFindIndex(v.map, curMapId) > 0 then
          local startMenu = v.start_menu and FunctionUnLockFunc.Me():CheckCanOpen(v.start_menu)
          local endMenu = v.close_menu and FunctionUnLockFunc.Me():CheckCanOpen(v.close_menu)
          if not v.start_menu or startMenu and not endMenu then
            self.worldQuestMap = true
            return k
          end
        end
      end
      self.worldQuestMap = false
    end
    self.worldQuestMap = false
  end
end

function MainViewMiniMap:UpdateTwelvePVPMapInfo()
  if MapManager:IsPvPMode_TeamTwelve() then
    self:SetObjActive(self.showQuestBtn, false)
  end
end

function MainViewMiniMap:ClearAllTwelvePVPMapInfo()
  self:UpdateTeamMembersPos(true)
  self:ClearOutScreenDatas()
  self:ClearPlayerMap()
  self:ActiveTwelvePVPInfoTip(false)
  self:SetObjActive(self.showQuestBtn, true)
end

function MainViewMiniMap:ActiveTwelvePVPInfoTip(isShow)
  if not self.twelvePVPInfoTip then
    local tObj = self:LoadPreferb_ByFullPath("GUI/v1/tip/TwelvePVPInfoTip", self.twelvePVPInfoTipContainer)
    self.twelvePVPInfoTip = TwelvePVPInfoTip.new(tObj)
    if not tObj then
      return
    end
  end
  self:SetObjActive(self.twelvePVPInfoTipContainer, isShow)
  if isShow then
    PvpObserveProxy.Instance:CallBeginCheckUI(PvpObserveProxy.UIType.Crystal)
    self.twelvePVPInfoTip:OnShow()
  else
    PvpObserveProxy.Instance:CallEndCheckUI(PvpObserveProxy.UIType.Crystal)
    if self.twelvePVPInfoTip then
      self.twelvePVPInfoTip:OnHide()
    end
  end
end

function MainViewMiniMap:HandlePosSyncFubenCmd(note)
  local serverData = note and note.body
  if not serverData then
    return
  end
  local posDatas = serverData.datas
  local hasNewPlayer = false
  if posDatas then
    local myselfId = _Game.Myself.data.id
    local mapDataMap, posData, guid, npcSID, serverPos, mapData, symbolName, staticData, camp
    for i = 1, #posDatas do
      guid = posDatas[i].id
      npcSID = posDatas[i].npcid
      serverPos = posDatas[i].pos
      camp = posDatas[i].camp
      self.outScreenNpcIDMap[guid] = npcSID
      mapDataMap = self.outScreenMapInfo[npcSID]
      if not mapDataMap then
        mapDataMap = ReusableTable.CreateTable()
        self.outScreenMapInfo[npcSID] = mapDataMap
        if npcSID ~= 0 then
          symbolName = TwelvePvpConfig[npcSID] or TwelveNpcMapSymbols[npcSID]
          if not symbolName then
            staticData = _TableMonster[npcSID] or _TableNpc[npcSID]
            if staticData then
              if staticData.Type == "MVP" then
                symbolName = "map_mvpboss"
              elseif staticData.Type == "MINI" then
                symbolName = "map_miniboss"
              end
            end
          end
          if symbolName then
            self.outScreenNpcSymbolMap[npcSID] = symbolName
          end
        end
      end
      posData = mapDataMap[guid]
      if not posData then
        posData = ReusableTable.CreateTable()
        mapDataMap[guid] = posData
      end
      posData.x = serverPos.x / 1000
      posData.y = serverPos.y / 1000
      posData.z = serverPos.z / 1000
      if npcSID == 0 and guid ~= myselfId then
        local mapData = self.playerMap[guid]
        if mapData == nil then
          mapData = MiniMapData.CreateAsTable(guid)
          mapData:SetParama("depth", 4)
          self.playerMap[guid] = mapData
          hasNewPlayer = true
        end
        mapData:SetPos(posData.x, posData.y, posData.z)
        mapData:SetParama("Symbol", self:_GetOutNineScreenPlayerSymbolName(guid, camp))
      end
    end
  end
  local removeIds = serverData.out_scope_ids
  if removeIds then
    local npcSID, mapDataMap, guid, posData
    for i = 1, #removeIds do
      guid = removeIds[i]
      npcSID = self.outScreenNpcIDMap[guid]
      if npcSID then
        mapDataMap = self.outScreenMapInfo[npcSID]
        if mapDataMap then
          posData = mapDataMap[guid]
          if posData then
            ReusableTable.DestroyAndClearTable(posData)
            mapDataMap[guid] = nil
            if not next(mapDataMap) then
              ReusableTable.DestroyAndClearTable(mapDataMap)
              self.outScreenMapInfo[npcSID] = nil
            end
          end
        end
      else
        for sid, map in pairs(self.outScreenMapInfo) do
          posData = map[guid]
          if posData then
            ReusableTable.DestroyAndClearTable(posData)
            map[guid] = nil
            if not next(map) then
              ReusableTable.DestroyAndClearTable(map)
              self.outScreenMapInfo[sid] = nil
            end
            break
          end
        end
      end
      self.outScreenNpcIDMap[guid] = nil
    end
  end
  if hasNewPlayer then
    self:UpdatePlayerSymbolsPos()
  end
end

function MainViewMiniMap:IsOutOfNineScreen(guid)
  return self.outScreenNpcIDMap[guid] ~= nil
end

function MainViewMiniMap:ClearOutScreenDatas()
  for npcSID, mapDataMap in pairs(self.outScreenMapInfo) do
    for guid, posData in pairs(mapDataMap) do
      ReusableTable.DestroyAndClearTable(posData)
    end
    ReusableTable.DestroyAndClearTable(mapDataMap)
  end
  TableUtility.TableClear(self.outScreenMapInfo)
  TableUtility.TableClear(self.outScreenNpcIDMap)
  TableUtility.TableClear(self.outScreenNpcSymbolMap)
  self.callQueryCloneMapStatusTime = nil
end

function MainViewMiniMap:refreshCameraStatus()
  local setting = FunctionPerformanceSetting.Me()
  if setting:GetSetting().disableFreeCamera then
    self.cameraLabel.text = "Lock"
  elseif setting:GetSetting().disableFreeCameraVert then
    self.cameraLabel.text = "2.5D"
  else
    self.cameraLabel.text = "3D"
  end
end

function MainViewMiniMap:OnRaidPuzzleLaunch()
  if not _Game.MapManager:IsRaidPuzzle() then
    return
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.CreatePuzzleMap, _Game.MapManager:GetRaidID())
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.CreatePuzzleMap, _Game.MapManager:GetRaidID(), true)
  self:UpdatePuzzleShadow()
end

function MainViewMiniMap:OnRaidPuzzleShutdown()
  self.minimapWindow:RemovePuzzleMap()
  self.bigmapWindow:RemovePuzzleMap()
end

function MainViewMiniMap:UpdatePuzzleShadow()
  if not _Game.MapManager:IsRaidPuzzle() then
    return
  end
  local roomStrMap = ReusableTable.CreateTable()
  RaidPuzzleManager.Me():GetMiniMapRoomStringStatusMap(roomStrMap)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdatePuzzleMap, roomStrMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdatePuzzleMap, roomStrMap)
  ReusableTable.DestroyAndClearTable(roomStrMap)
end

function MainViewMiniMap:SetObjActive(obj, active)
  if not obj then
    LogUtility.Error("SetObjActive but obj is nil!")
  end
  active = active ~= false
  if self.activeStatusMap[obj] == active then
    return
  end
  self.activeStatusMap[obj] = active
  obj:SetActive(active)
end

function MainViewMiniMap:IsObjActive(obj)
  if not obj then
    LogUtility.Error("Get IsObjActive but obj is nil!")
  end
  local curStatus = self.activeStatusMap[obj]
  if curStatus == nil then
    curStatus = obj.activeSelf
    self.activeStatusMap[obj] = curStatus
  end
  return curStatus
end

function MainViewMiniMap:ClearObjActiveMap()
  TableUtility.TableClear(self.activeStatusMap)
end

function MainViewMiniMap:HandleRaidPuzzleRoomIconRaidCmd(note)
  local iconDatas = note.body and note.body.icons
  if not iconDatas then
    return
  end
  local _rpManager = RaidPuzzleManager.Me()
  local depthConfig = _rpManager:GetRaidConfig("MiniMapIconDepth")
  local miniMapData, singleData
  for i = 1, #iconDatas do
    singleData = iconDatas[i]
    miniMapData = MiniMapData.CreateAsTable(#self.raidPuzzleRoomIconMap + 1)
    miniMapData:SetParama("Symbol", singleData.icon)
    miniMapData:SetParama("depth", depthConfig and depthConfig[singleData.icon] or 1)
    miniMapData:SetPos(singleData.posx, 0, singleData.posz)
    self.raidPuzzleRoomIconMap[#self.raidPuzzleRoomIconMap + 1] = miniMapData
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.RaidPuzzleRoom, self.raidPuzzleRoomIconMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.RaidPuzzleRoom, self.raidPuzzleRoomIconMap)
end

function MainViewMiniMap:ClearRaidPuzzleRoomIcons()
  _TableClearByDeleter(self.raidPuzzleRoomIconMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.RaidPuzzleRoom, self.raidPuzzleRoomIconMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.RaidPuzzleRoom, self.raidPuzzleRoomIconMap)
end

function MainViewMiniMap:HandlePopObjEvent(note)
  local obj = note and note.body
  if obj == self.mapBord then
    self:ActiveMapBord(false)
  end
end

function MainViewMiniMap:UpdateQuickTargetPos(note)
  local data = note and note.body
  if not data then
    return
  end
  if data.sign and data.guid then
    local miniMapData
    miniMapData = MiniMapData.CreateAsTable(data.guid)
    miniMapData:SetParama("Symbol", "Games_icon_the-goal2")
    miniMapData:SetParama("depth", 40)
    miniMapData:SetPos(data.pos.x / 1000, 0, data.pos.z / 1000)
    self.quickTargetMap[1] = miniMapData
  else
    self:ClearQuickTargetMap()
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.QuickTarget, self.quickTargetMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.QuickTarget, self.quickTargetMap)
end

function MainViewMiniMap:ClearQuickTargetMap()
  _TableClearByDeleter(self.quickTargetMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.QuickTarget, self.quickTargetMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.QuickTarget, self.quickTargetMap)
end

function MainViewMiniMap:HandleAddCircleArea(note)
  if not self.circleAreaMap then
    self.circleAreaMap = {}
  end
  local questId, pos, radius = note.body[1], note.body[2], note.body[3]
  local data = self.circleAreaMap[questId]
  if not data then
    data = MiniMapData.CreateAsTable(questId)
    data:SetParama("questId", questId)
    data:SetParama("areaSymbol", "new_main_bg_task")
    data:SetParama("areaSymbolDepth", 100)
    self.circleAreaMap[questId] = data
  end
  data:SetPos(pos[1], pos[2], pos[3])
  data:SetParama("radius", radius)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapCircleAreas, self.circleAreaMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapCircleAreas, self.circleAreaMap)
end

function MainViewMiniMap:HandleRemoveCircleArea(note)
  local questId = note.body
  if questId and self.circleAreaMap then
    local data = self.circleAreaMap[questId]
    if data then
      data:Destroy()
    end
    self.circleAreaMap[questId] = nil
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapCircleAreas, self.circleAreaMap, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapCircleAreas, self.circleAreaMap, true)
  end
end

function MainViewMiniMap:UpdateFlowerCarPos(note)
  local data = note and note.body
  if data and data.guid then
    local miniMapData
    miniMapData = MiniMapData.CreateAsTable(data.guid)
    miniMapData:SetParama("Symbol", "map_huache")
    miniMapData:SetParama("depth", 40)
    miniMapData:SetPos(data.posx, data.posy, data.posz)
    self.flowerCarMap[1] = miniMapData
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.FlowerCar, self.flowerCarMap, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.FlowerCar, self.flowerCarMap, true)
  else
    self:ClearFlowerCarMap()
  end
end

function MainViewMiniMap:ClearFlowerCarMap()
  _TableClearByDeleter(self.flowerCarMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.FlowerCar, self.flowerCarMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.FlowerCar, self.flowerCarMap, true)
end

function MainViewMiniMap:UpdateTrainEscortPos()
  local is_open = FunctionTrainEscort.Me().is_open
  local is_inEscortMap = FunctionTrainEscort.Me().is_inEscortMap
  local trainTopId = FunctionTrainEscort.Me().trainTopId
  local clientState = FunctionTrainEscort.Me().clientState
  if is_open and is_inEscortMap and trainTopId and clientState ~= 0 and clientState ~= 999 then
    local miniMapData
    miniMapData = MiniMapData.CreateAsTable(trainTopId)
    miniMapData:SetParama("Symbol", "map_icon_huisong")
    miniMapData:SetParama("depth", 40)
    local data = FunctionTrainEscort.Me().escortActData
    local x = data.train_pos and data.train_pos.x / 1000 or 0
    local y = data.train_pos and data.train_pos.y / 1000 or 0
    local z = data.train_pos and data.train_pos.z / 1000 or 0
    miniMapData:SetPos(x, y, z)
    self.trainEscortMap[1] = miniMapData
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.TrainEscort, self.trainEscortMap, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.TrainEscort, self.trainEscortMap, true)
  else
    self:ClearTrainEscortMap()
  end
end

function MainViewMiniMap:ClearTrainEscortMap()
  _TableClearByDeleter(self.trainEscortMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.TrainEscort, self.trainEscortMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateMapSymbolDatas, MiniMapWindow.Type.TrainEscort, self.trainEscortMap, true)
end

local updateLocalNpcPosTickId = 200

function MainViewMiniMap:ShowLocalNpcPos(note)
  local npcId = note and note.body
  if npcId then
    if not self.npcPosMap then
      self.npcPosMap = {}
      TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLocalNpcPos, self, updateLocalNpcPosTickId)
    end
    local data = self.npcPosMap[1]
    local npc = NSceneNpcProxy.Instance:Find(npcId)
    if npc then
      if not data then
        data = MiniMapData.CreateAsTable(npcId)
        data:SetParama("Symbol", "map_blue")
        data:SetParama("depth", 40)
        self.npcPosMap[1] = data
      elseif data.id ~= npcId then
        data.id = npcId
      end
      MsgManager.ShowMsgByID(42047)
    else
      if data then
        data:Destroy()
        self.npcPosMap[1] = nil
      end
      MsgManager.ShowMsgByID(42046)
    end
  end
end

function MainViewMiniMap:UpdateMetalGvgPointOccupyProgress()
  local _GvgMrg = GvgProxy.Instance
  local id = _GvgMrg:GetCurOccupingPointID()
  if 0 < id then
    local pd = _GvgMrg:GetPointData(id)
    if pd and 0 < pd:GetOccupyProcess() then
      self:_UpdateGvgPointTip(pd)
    else
      self:_ClearGvgPointTip()
    end
  else
    self:_ClearGvgPointTip()
  end
end

function MainViewMiniMap:_UpdateGvgPointTip(pd)
  if not self.gvgPointPerTip then
    self.gvgPointPerObj = self:LoadPreferb_ByFullPath("GUI/v1/part/GVGPointPerTip", self.gvgPointPerTipContainer)
    self.gvgPointPerTip = GVGPointPerTip.new(self.gvgPointPerObj)
  end
  self.gvgPointPerTip:OnShow(pd)
end

function MainViewMiniMap:_ClearGvgPointTip()
  if self.gvgPointPerTip then
    GameObject.DestroyImmediate(self.gvgPointPerObj)
    self.gvgPointPerTip = nil
  end
end

function MainViewMiniMap:UpdateGvgStrongHold()
  if not _Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgStrongHoldSymbols, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgStrongHoldSymbols, true)
end

function MainViewMiniMap:UpdateLocalNpcPos()
  local data = self.npcPosMap[1]
  if data then
    local npc = NSceneNpcProxy.Instance:Find(data.id)
    if npc then
      local pos = npc:GetPosition()
      data:SetPos(pos[1], pos[2], pos[3])
    else
      data:Destroy()
      self.npcPosMap[1] = nil
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateLocalNpcPos, self.npcPosMap)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateLocalNpcPos, self.npcPosMap)
end

function MainViewMiniMap:ClearLocalNpcPos()
  if self.npcPosMap then
    local data = self.npcPosMap[1]
    if data then
      data:Destroy()
      self.npcPosMap[1] = nil
    end
    self.npcPosMap = nil
    TimeTickManager.Me():ClearTick(self, updateLocalNpcPosTickId)
  end
end

function MainViewMiniMap:UpdateTeamMateSymbol(id, miniMapData)
  if not _TeamProxy:IHaveTeam() then
    return
  end
  local myTeam = _TeamProxy.myTeam
  local memData = myTeam:GetMemberByGuid(id)
  if not memData then
    return
  end
  local symbolName
  if memData.dead then
    symbolName = "map_teamdied"
  elseif Game.MapManager:IsPVPMode() then
    local player = NSceneUserProxy.Instance:Find(id)
    if player then
      symbolName = self:_GetScenePlayerSymbolName(player, true)
    end
    if not symbolName then
      symbolName = "map_teammate"
    end
  else
    symbolName = "map_teammate"
  end
  miniMapData:SetParama("Symbol", symbolName)
end

function MainViewMiniMap:CallQueryCloneMapStatusMapCmd()
  if self.callQueryCloneMapStatusTime == nil or UnityTime > self.callQueryCloneMapStatusTime then
    self.callQueryCloneMapStatusTime = UnityTime + 60
    ServiceMapProxy.Instance:CallQueryCloneMapStatusMapCmd()
    return true
  end
  return false
end

function MainViewMiniMap:UpdateSceneRoot()
  if self.mapdata ~= nil and self.mapdata.CloneMap ~= nil then
    self.sceneRoot:SetActive(true)
    local width = self.mapName.printedSize.x / 2
    self.sceneHelp.transform.localPosition = LuaGeometry.GetTempVector3(-width - 28, 0, 0)
  else
    self.sceneRoot:SetActive(false)
  end
end

function MainViewMiniMap:ActiveChangeBord(active)
  if self.changeBord then
    self.changeBord:SetActive(active)
  end
end

function MainViewMiniMap:HandleMapQueryCloneMapStatusMapCmd()
  self:UpdateSceneName()
  self:UpdateChangeMapList()
end

function MainViewMiniMap:UpdateSceneName()
  if WorldMapProxy.Instance:IsCloneMap() then
    self.sceneHelp:SetActive(true)
    local data = WorldMapProxy.Instance:GetCloneMapData(Game.MapManager:GetSceneID())
    if data ~= nil then
      self.sceneName.text = data.name
      self.sceneName.color = MiniMapChangeCell.StatusColor[data.status] or MiniMapChangeCell.StatusColor[4]
    else
      self.sceneName.text = ""
    end
    self.cloneMap:SetActive(true)
  else
    self.sceneHelp:SetActive(false)
    self.sceneName.text = ""
    self.cloneMap:SetActive(false)
  end
  self.infoGrid:Reposition()
  local mapwidth = self.mapName.printedSize.x / 2
  self.sceneName.transform.localPosition = LuaGeometry.GetTempVector3(mapwidth + 28, 0, 0)
  if 0 < #WorldMapProxy.Instance:GetCloneMapList() then
    self.changeSceneTrans.gameObject:SetActive(true)
    local scenewidth = self.sceneName.printedSize.x
    self.changeSceneTrans.localPosition = LuaGeometry.GetTempVector3(mapwidth + scenewidth + 20, 0, 0)
  else
    self.changeSceneTrans.gameObject:SetActive(false)
  end
end

function MainViewMiniMap:UpdateChangeMapList()
  if self.changeList == nil or self.changeBord ~= nil and not self.changeBord.activeInHierarchy then
    return
  end
  local list = WorldMapProxy.Instance:GetCloneMapList()
  self.changeList:ResetDatas(list)
end

function MainViewMiniMap:ClickChangeMap(cell)
  local data = cell.data
  if data then
    if Game.MapManager:GetSceneID() == data.id then
      return
    end
    ServiceMapProxy.Instance:CallChangeCloneMapCmd(data.id)
    self.changeBord:SetActive(false)
  end
end

function MainViewMiniMap:UpdateCloneMap()
  self.cloneMap:SetActive(WorldMapProxy.Instance:IsCloneMap())
  self.infoGrid:Reposition()
end

function MainViewMiniMap:HandleGvgLaunch()
  self:UpdateGVGInfo()
  self:Show(self.gvgCrystalInvincibleLab)
end

function MainViewMiniMap:HandleGvgShutDown()
  self:ClearGVGMetaInfo()
  self:ClearGvgLeaderFightPointSymbols()
  self:Hide(self.gvgCrystalInvincibleLab)
end

function MainViewMiniMap:AddGvgMetalData(config, minimap_data_id)
  if self.gvgMetalMap[minimap_data_id] then
    return
  end
  if config and config.pos and config.icon and minimap_data_id then
    local mode = GvgProxy.Instance:GetCurRaidMode()
    local pos = config.pos[mode]
    local miniMapData = MiniMapData.CreateAsTable(minimap_data_id)
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", config.icon)
    miniMapData:SetParama("Scale", 0.5)
    self.gvgMetalMap[minimap_data_id] = miniMapData
  end
end

local MetalSymbols = GameConfig.GVGConfig.NpcMapSymbols
local gvg_mvp_data_id = {metal = 1, mvp = 2}

function MainViewMiniMap:UpdateGvgMvpData()
  local gvg_proxy = GvgProxy.Instance
  local symbol_id = gvg_mvp_data_id.mvp
  if not gvg_proxy:HasMapMvp() then
    self.gvgMetalMap[symbol_id] = nil
  else
    local config = MetalSymbols.mvp
    if not config then
      return
    end
    local icon = gvg_proxy:IsMvpAlive() and config.icon or config.gray_icon
    local mini_data = self.gvgMetalMap[symbol_id]
    if not mini_data then
      mini_data = MiniMapData.CreateAsTable(symbol_id)
      self.gvgMetalMap[symbol_id] = mini_data
    end
    local mode = GvgProxy.Instance:GetCurRaidMode()
    local pos = config.pos and config.pos[mode]
    mini_data:SetPos(pos[1], pos[2], pos[3])
    mini_data:SetParama("Symbol", icon)
    mini_data:SetParama("Scale", 1)
  end
end

function MainViewMiniMap:UpdateGVGInfo()
  if not Game.MapManager:IsInGVGDetailedRaid() then
    self:ClearGVGMetaInfo()
    return
  end
  _TableClearByDeleter(self.gvgMetalMap, miniMapDataDeleteFunc)
  self:AddGvgMetalData(MetalSymbols.metal, gvg_mvp_data_id.metal)
  self:UpdateGvgMvpData()
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgSymbol, self.gvgMetalMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgSymbol, self.gvgMetalMap, true)
end

function MainViewMiniMap:ClearGVGMetaInfo()
  _TableClearByDeleter(self.gvgMetalMap, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgSymbol, self.gvgMetalMap, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgSymbol, self.gvgMetalMap, true)
end

function MainViewMiniMap:UpdateWildMvpMonsters()
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateWildMvpSymbols, true, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateWildMvpSymbols, true, true)
end

function MainViewMiniMap:UpdateMapName()
  local nowMapId = MapManager:GetMapID()
  local tempRaid = Table_MapRaid[nowMapId]
  if tempRaid and tempRaid.Type == PveRaidType.StarArk then
    self.mapName.text = DungeonProxy.Instance:GetStarArkRaidName()
  end
end

function MainViewMiniMap:TrySetupBigWorldWildMvpPassDayRefresh(mapID)
  mapID = mapID or Game.MapManager:GetMapID()
  if mapID == 149 then
    self:SetupBigWorldWildMvpPassDayRefresh()
  else
    self:ClearBigWorldWildMvpPassDayRefresh()
  end
end

function MainViewMiniMap:SetupBigWorldWildMvpPassDayRefresh()
  self:OnBigWorldWildMvpPassDayRefresh()
  TimeTickManager.Me():ClearTick(self, 11451)
  local waitTimeMs = (ServerTime.GetStartTimestamp() + 86400 + 10) * 1000 - ServerTime.CurServerTime()
  TimeTickManager.Me():CreateOnceDelayTick(waitTimeMs, self.OnBigWorldWildMvpPassDayRefresh, self, 11451)
end

function MainViewMiniMap:ClearBigWorldWildMvpPassDayRefresh()
  TimeTickManager.Me():ClearTick(self, 11451)
end

function MainViewMiniMap:OnBigWorldWildMvpPassDayRefresh()
  WildMvpProxy.Instance:ManualForceUpdateDailyRewardStatus()
end

function MainViewMiniMap:RefreshYahahaSymbol()
  self:UpdateYahahaSymbol()
end

function MainViewMiniMap:_UpdateYahahaDatas()
  if self.yahahaDatas then
    _TableClearByDeleter(self.yahahaDatas, miniMapDataDeleteFunc)
  else
    self.yahahaDatas = {}
  end
  local curMapId = MapManager:GetMapID()
  local yahahaStaticConfigs = Table_YahahaQuest
  for k, v in pairs(yahahaStaticConfigs) do
    local data = self.yahahaDatas[k]
    local mapValid = v.MapID == curMapId
    local show = FunctionUnLockFunc.Me():CheckCanOpen(v.QuestMenu) and mapValid
    local fin = FunctionUnLockFunc.Me():CheckCanOpen(v.Menu)
    if show then
      if not data then
        data = MiniMapData.CreateAsTable(k)
        self.yahahaDatas[k] = data
        data:SetParama("Depth", 36)
      end
      local p = v.Pos
      data:SetPos(p[1], p[2], p[3])
      if fin then
        data:SetParama("Symbol", "map_icon_Emoelf2")
      else
        data:SetParama("Symbol", "map_icon_Emoelf1")
      end
    else
      if data ~= nil then
        data:Destroy()
      end
      self.yahahaDatas[k] = nil
    end
  end
end

function MainViewMiniMap:UpdateYahahaSymbol()
  self:_UpdateYahahaDatas()
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateYahahaSymbol, self.yahahaDatas, true)
end

function MainViewMiniMap:UpdateCameraSymbol()
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateCameraSymbol)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateCameraSymbol)
end

function MainViewMiniMap:UpdateMapTreasure()
  local mapid = Game.MapManager:GetMapID()
  local treasureData = QuestProxy.Instance:GetTreasureBoxData(mapid)
  if treasureData then
    self.mapTreasure.gameObject:SetActive(true)
    local gotNum = treasureData.gotten_num or 0
    local maxNum = treasureData.total_num or 0
    self.mapTreasure.text = gotNum .. " / " .. maxNum
  else
    self.mapTreasure.gameObject:SetActive(false)
  end
end

function MainViewMiniMap:UpdateTripleTeamsMapInfo()
  if not MapManager:IsPVPMode_3Teams() then
    return
  end
  local infos = PvpProxy.Instance:GetTripleCampInfos()
  local campPosition = GameConfig.Triple.CampPosition
  for i = 1, #infos do
    local camp = infos[i].camp
    local miniMapData = self.tripleTeamsMapInfo[camp]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(camp)
      self.tripleTeamsMapInfo[camp] = miniMapData
    end
    local pos = campPosition[camp].pos
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", campPosition[camp].mapSymbols)
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTripleTeamsSymbol, self.tripleTeamsMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTripleTeamsSymbol, self.tripleTeamsMapInfo, true)
end

function MainViewMiniMap:ClearTripleTeamsMapInfo()
  _TableClearByDeleter(self.tripleTeamsMapInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateTripleTeamsSymbol, self.tripleTeamsMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateTripleTeamsSymbol, self.tripleTeamsMapInfo, true)
end

function MainViewMiniMap:UpdateTripleTeamRobotPlayerMapInfo(npcs)
  if not MapManager:IsPVPMode_3Teams() then
    return
  end
  if npcs then
    local dirty = false
    for i = 1, #npcs do
      local npc = npcs[i]
      if npc.data:IsTripleTeamRobot() then
        self:_UpdatePlayerSymbolData(npc)
        dirty = true
      end
    end
    if dirty then
      self:UpdatePlayerSymbolsPos()
    end
  end
end

function MainViewMiniMap:RemoveTripleTeamRobotPlayerMapInfo(npcIds)
  if not MapManager:IsPVPMode_3Teams() then
    return
  end
  if npcIds then
    local dirty = false
    for i = 1, #npcIds do
      local npcId = npcIds[i]
      local npc = NSceneNpcProxy.Instance:Find(npcId)
      if npc and npc.data:IsTripleTeamRobot() then
        local miniMapData = self.playerMap[npc.data.id]
        if miniMapData then
          miniMapData:Destroy()
        end
        self.playerMap[npc.data.id] = nil
        dirty = true
      end
    end
    if dirty then
      self:UpdatePlayerSymbolsPos()
    end
  end
end

function MainViewMiniMap:LaunchEBFEventAreaMapInfo()
  if not MapManager:IsPVPMode_EndlessBattleField() then
    return
  end
  if not self.ebfEventBoard then
    self.ebfEventBoard = self:AddSubView("EBFEventBoard", EndlessBattleFieldEventBoard)
  end
  self:UpdateEBFEventBoard()
  local curMapId = MapManager:GetMapID()
  local EBFEvents = Game.EBFMinimapArea and Game.EBFMinimapArea[curMapId]
  if not EBFEvents then
    redlog("当前地图没有配置事件！ mapId=", curMapId)
    return
  end
  local areaSymbol = "battlefield_map_brown"
  for id, data in pairs(EBFEvents) do
    local miniMapData = self.EBFEventAreaMapInfo[id]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(id)
      self.EBFEventAreaMapInfo[id] = miniMapData
      local pos = data.AreaCenter
      local range = data.AreaRange
      miniMapData:SetPos(pos[1], pos[2], pos[3])
      miniMapData:SetParama("range", range)
      local symbol = data.Icon or "battlefield_map_icon_1"
      miniMapData:SetParama("Symbol", symbol)
      miniMapData:SetParama("areaSymbol", areaSymbol)
    end
  end
  local campPosition = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.CampPosition
  local miniMapData = self.EBFEventAreaMapInfo.human
  if not miniMapData then
    miniMapData = MiniMapData.CreateAsTable("human")
    self.EBFEventAreaMapInfo.human = miniMapData
    local pos = campPosition and campPosition[1] and campPosition[1].pos
    local symbol = campPosition and campPosition[1] and campPosition[1].mapSymbol
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", symbol)
    areaSymbol = "battlefield_map_blue"
    miniMapData:SetParama("areaSymbol", areaSymbol)
  end
  miniMapData = self.EBFEventAreaMapInfo.vampire
  if not miniMapData then
    miniMapData = MiniMapData.CreateAsTable("vampire")
    self.EBFEventAreaMapInfo.vampire = miniMapData
    local pos = campPosition and campPosition[2] and campPosition[2].pos
    local symbol = campPosition and campPosition[2] and campPosition[2].mapSymbol
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", symbol)
    areaSymbol = "battlefield_map_red"
    miniMapData:SetParama("areaSymbol", areaSymbol)
  end
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateEBFEventAreaMapSymbols()
  end, self, 300)
end

function MainViewMiniMap:UpdateEBFEventBoard()
  if not MapManager:IsPVPMode_EndlessBattleField() then
    return
  end
  self:ActiveEBFEventBoard(self.mapBord.activeSelf)
  self.worldLineGO:SetActive(false)
end

function MainViewMiniMap:UpdateEBFEventAreaMapSymbols()
  local _proxy = EndlessBattleFieldProxy.Instance
  local areaSymbolInactive = "battlefield_map_brown"
  local areaSymbolActive = "battlefield_map_white"
  for id, miniMapData in pairs(self.EBFEventAreaMapInfo) do
    if id ~= "human" and id ~= "vampire" then
      local srcSymbol = miniMapData:GetParama("areaSymbol")
      local dstSymbol = _proxy:IsEventActive(id) and areaSymbolActive or areaSymbolInactive
      if srcSymbol ~= dstSymbol then
        miniMapData:SetParama("areaSymbol", dstSymbol)
      end
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateEBFEventAreaSymbol, self.EBFEventAreaMapInfo)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateEBFEventAreaSymbol, self.EBFEventAreaMapInfo)
end

function MainViewMiniMap:ClearEBFEventAreaMapInfo()
  TimeTickManager.Me():ClearTick(self, 300)
  _TableClearByDeleter(self.EBFEventAreaMapInfo, miniMapDataDeleteFunc)
  if self.ebfEventBoard then
    self:RemoveSubView("EBFEventBoard")
    self.ebfEventBoard = nil
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateEBFEventAreaSymbol, self.EBFEventAreaMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateEBFEventAreaSymbol, self.EBFEventAreaMapInfo, true)
end

function MainViewMiniMap:UpdateAstralTowerMapInfo()
  local curMap = MapManager:GetMapID()
  local mapConfig = GameConfig.Astral and GameConfig.Astral.MiniMapArea
  if mapConfig and curMap == mapConfig.mapId then
    local miniMapData = self.astralMapInfo.tower
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable("tower")
      self.astralMapInfo.tower = miniMapData
    end
    local pos = mapConfig.pos
    miniMapData:SetPos(pos[1], pos[2], pos[3])
    miniMapData:SetParama("Symbol", mapConfig.mapSymbol)
  else
    _TableClearByDeleter(self.astralMapInfo, miniMapDataDeleteFunc)
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateAstralTowerSymbol, self.astralMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateAstralTowerSymbol, self.astralMapInfo, true)
end

function MainViewMiniMap:HandleSyncGvgFightPoint(note)
  if not MapManager:IsInGVGDetailedRaid() then
    return
  end
  local fightPoints = note.body.fight_points
  for i = #fightPoints + 1, #self.gvgFightPointDatas do
    if self.gvgFightPointDatas[i] then
      self.gvgFightPointDatas[i]:Destroy()
      self.gvgFightPointDatas[i] = nil
    end
  end
  for i = 1, #fightPoints do
    local point = fightPoints[i]
    local mapData = self.gvgFightPointDatas[i]
    if not mapData then
      mapData = MiniMapData.CreateAsTable(i)
      self.gvgFightPointDatas[i] = mapData
    end
    mapData:SetParama("Symbol", "map_war_circle")
    mapData:SetParama("Depth", 9)
    mapData:SetPos(point.x / 1000, point.y / 1000, point.z / 1000)
  end
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgFightPointSymbol, self.gvgFightPointDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgFightPointSymbol, self.gvgFightPointDatas, true)
end

local _createCacheIfNeeded = function(pool, index)
  local cache = pool[index]
  if not cache then
    cache = {}
    pool[index] = cache
  end
  return cache
end
local _updatePositionCache = function(pos, cache)
  cache.x = pos.x * 0.001
  cache.y = pos.y * 0.001
  cache.z = pos.z * 0.001
end

function MainViewMiniMap:HandleSyncGvgLeaderPos(note)
  if not MapManager:IsInGVGDetailedRaid() then
    return
  end
  local guild_leader_pos = note.body.guild_leader_pos
  if not guild_leader_pos then
    return
  end
  local clock_tag = os.clock()
  local myGuildId = GuildProxy.Instance:GetGuildID()
  local friend_count, enemy_count, chairman_friend_count, chairman_enemy_count = 0, 0, 0, 0
  local guild_data, leader_pos, guild_chairman_pos
  if not self.pos_cache_pool then
    self.pos_cache_pool = {
      friend = {},
      enemy = {},
      chairman_friend = {},
      chairman_enemy = {}
    }
  end
  for i = 1, #guild_leader_pos do
    guild_data = guild_leader_pos[i]
    leader_pos = guild_data.leader_pos
    guild_chairman_pos = guild_data.guild_chairman_pos
    local cache_pool = guild_data.guild_id == myGuildId and self.pos_cache_pool.friend or self.pos_cache_pool.enemy
    local chairman_cache_pool = guild_data.guild_id == myGuildId and self.pos_cache_pool.chairman_friend or self.pos_cache_pool.chairman_enemy
    for j = 1, #leader_pos do
      if guild_data.guild_id == myGuildId then
        friend_count = friend_count + 1
        local cache = _createCacheIfNeeded(cache_pool, friend_count)
        _updatePositionCache(leader_pos[j], cache)
      else
        enemy_count = enemy_count + 1
        local cache = _createCacheIfNeeded(cache_pool, enemy_count)
        _updatePositionCache(leader_pos[j], cache)
      end
    end
    if guild_chairman_pos and next(guild_chairman_pos) then
      if guild_data.guild_id == myGuildId then
        chairman_friend_count = chairman_friend_count + 1
        local cache = _createCacheIfNeeded(chairman_cache_pool, chairman_friend_count)
        _updatePositionCache(guild_chairman_pos, cache)
      else
        chairman_enemy_count = chairman_enemy_count + 1
        local cache = _createCacheIfNeeded(chairman_cache_pool, chairman_enemy_count)
        _updatePositionCache(guild_chairman_pos, cache)
      end
    end
  end
  self:UpdateGvgLeaderMapData(self.gvgFriendLeaderDatas, self.pos_cache_pool.friend, friend_count, "map_teammate", 12)
  self:UpdateGvgLeaderMapData(self.gvgEnemyLeaderDatas, self.pos_cache_pool.enemy, enemy_count, "map_dot", 10)
  self:UpdateGvgLeaderMapData(self.gvgFriendChairmanDatas, self.pos_cache_pool.chairman_friend, chairman_friend_count, "map_green", 13)
  self:UpdateGvgLeaderMapData(self.gvgEnemyChairmanDatas, self.pos_cache_pool.chairman_enemy, chairman_enemy_count, "map_dot", 11)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgFriendLeaderPointSymbol, self.gvgFriendLeaderDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgFriendLeaderPointSymbol, self.gvgFriendLeaderDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgEnemyLeaderPointSymbol, self.gvgEnemyLeaderDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgEnemyLeaderPointSymbol, self.gvgEnemyLeaderDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgFriendChairmanPointSymbol, self.gvgFriendChairmanDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgFriendChairmanPointSymbol, self.gvgFriendChairmanDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgEnemyChairmanPointSymbol, self.gvgEnemyChairmanDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgEnemyChairmanPointSymbol, self.gvgEnemyChairmanDatas, true)
end

function MainViewMiniMap:_clearGvGFightPointLeader()
  _TableClearByDeleter(self.gvgFightPointDatas, miniMapDataDeleteFunc)
  _TableClearByDeleter(self.gvgFriendLeaderDatas, miniMapDataDeleteFunc)
  _TableClearByDeleter(self.gvgEnemyLeaderDatas, miniMapDataDeleteFunc)
  _TableClearByDeleter(self.gvgFriendChairmanDatas, miniMapDataDeleteFunc)
  _TableClearByDeleter(self.gvgEnemyChairmanDatas, miniMapDataDeleteFunc)
  if self.pos_cache_pool then
    _TableClear(self.pos_cache_pool.friend)
    _TableClear(self.pos_cache_pool.enemy)
    _TableClear(self.pos_cache_pool.chairman_friend)
    _TableClear(self.pos_cache_pool.chairman_enemy)
  end
end

function MainViewMiniMap:ClearGvgLeaderFightPointSymbols()
  self:_clearGvGFightPointLeader()
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgFightPointSymbol, self.gvgFightPointDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgFightPointSymbol, self.gvgFightPointDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgFriendLeaderPointSymbol, self.gvgFriendLeaderDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgFriendLeaderPointSymbol, self.gvgFriendLeaderDatas, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateGvgEnemyLeaderPointSymbol, self.gvgEnemyLeaderDatas, true)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateGvgEnemyLeaderPointSymbol, self.gvgEnemyLeaderDatas, true)
end

function MainViewMiniMap:UpdateGvgLeaderMapData(mapDataArray, posCache, count, symbolName, depth)
  for i = count + 1, #mapDataArray do
    if mapDataArray[i] then
      mapDataArray[i]:Destroy()
      mapDataArray[i] = nil
    end
  end
  local pos
  for i = 1, count do
    local mapData = mapDataArray[i]
    if not mapData then
      mapData = MiniMapData.CreateAsTable(i)
      mapData:SetParama("Symbol", symbolName)
      mapData:SetParama("Depth", depth)
      mapDataArray[i] = mapData
    end
    pos = posCache[i]
    mapData:SetPos(pos.x, pos.y, pos.z)
  end
end

function MainViewMiniMap:UpdateAbyssDragonMapInfo()
  local mapId = Game.MapManager:GetMapID()
  if mapId ~= 154 then
    self:ClearAbyssDragonMapInfo()
    return
  end
  if FunctionAbyssDragon.CheckTimeValid() then
    if not next(self.abyssDragonMapInfo) then
      local raidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
      if raidInfo then
        for id, info in pairs(raidInfo) do
          local bpID = info.BpPoint
          local bp = Game.MapManager:FindBornPoint(bpID)
          if bp then
            local miniMapData = self.abyssDragonMapInfo[id]
            if not miniMapData then
              miniMapData = MiniMapData.CreateAsTable(id)
              self.abyssDragonMapInfo[id] = miniMapData
              miniMapData:SetPos(bp.position[1], bp.position[2], bp.position[3])
              if info.MapEffect then
                miniMapData:SetParama("effect", info.MapEffect)
              end
            end
          end
        end
      end
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateAbyssDragonSymbol, self.abyssDragonMapInfo, true)
  else
    self:ClearAbyssDragonMapInfo()
  end
end

function MainViewMiniMap:ClearAbyssDragonMapInfo()
  _TableClearByDeleter(self.abyssDragonMapInfo, miniMapDataDeleteFunc)
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateAbyssDragonSymbol, self.abyssDragonMapInfo, true)
end

function MainViewMiniMap:HandleFairyTaleAddTrainNpc(note)
  local trainNpcs = note.body
  if not trainNpcs then
    return
  end
  for i = 1, #trainNpcs do
    local npc = trainNpcs[i]
    local miniMapData = self.fairyTaleMapInfo[npc.data.id]
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(npc.data.id)
      self.fairyTaleMapInfo[npc.data.id] = miniMapData
    end
    local rider = npc:GetRideRole()
    if rider then
      miniMapData:SetParama("RiderId", rider.data.staticData.id)
    end
    miniMapData:SetParama("hp", npc.data:GetHP())
    miniMapData:SetParama("maxHp", npc.data.props:GetPropByName("MaxHp"):GetValue())
    local pos = npc:GetPosition()
    miniMapData:SetPos(pos[1], pos[2], pos[3])
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
end

function MainViewMiniMap:HandleFairyTaleRemoveTrainNpc(note)
  local npcs = note.body
  if not npcs then
    return
  end
  for i = 1, #npcs do
    local id = npcs[i]
    local miniMapData = self.fairyTaleMapInfo[id]
    if miniMapData then
      miniMapData:Destroy()
      self.fairyTaleMapInfo[id] = nil
    end
  end
  self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
  self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
end

function MainViewMiniMap:HandleFairyTaleLaunch()
  self.fairyTaleMapInfo = {}
  self.fairyTaleTimeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
    for id, miniMapData in pairs(self.fairyTaleMapInfo) do
      local npc = _NSceneNpcProxy:Find(id)
      if npc then
        local hp = npc.data:GetHP()
        miniMapData:SetParama("hp", hp)
        local pos = npc:GetPosition()
        miniMapData:SetPos(pos[1], pos[2], pos[3])
        local rider = npc:GetRideRole()
        if rider then
          miniMapData:SetParama("RiderId", rider.data.staticData.id)
        end
      else
        miniMapData:Destroy()
        self.fairyTaleMapInfo[id] = nil
      end
    end
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
  end, self, 1001)
end

function MainViewMiniMap:HandleFairyTaleShutdown()
  if self.fairyTaleMapInfo then
    _TableClearByDeleter(self.fairyTaleMapInfo, miniMapDataDeleteFunc)
    self:WindowInvoke(self.minimapWindow, self.minimapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
    self:WindowInvoke(self.bigmapWindow, self.bigmapWindow.UpdateFairyTaleSymbol, self.fairyTaleMapInfo, true)
    self.fairyTaleMapInfo = nil
  end
  if self.fairyTaleTimeTick then
    TimeTickManager.Me():ClearTick(self, 1001)
    self.fairyTaleTimeTick = nil
  end
end
