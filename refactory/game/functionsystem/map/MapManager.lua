autoImport("EnviromentManager")
autoImport("AreaTriggerManager")
autoImport("DungeonManager")
autoImport("LockTargetEffectManager")
autoImport("FunctionScenicSpot")
autoImport("ClickGroundEffectManager")
autoImport("SkillWorkerManager")
autoImport("DynamicObjectManager")
autoImport("SceneSeatManager")
autoImport("QuestMiniMapEffectManager")
autoImport("PlotStoryManager")
autoImport("HandUpManager")
autoImport("PictureWallManager")
autoImport("WeddingWallPicManager")
autoImport("HomeManager")
autoImport("HomeWallPicManager")
autoImport("HotKeyManager")
autoImport("InteractNpcManager")
autoImport("ClientNpcManager")
autoImport("PerformanceManager")
autoImport("RaidPuzzleManager")
autoImport("LightPuzzleManager")
autoImport("CookMasterManager")
autoImport("RunnerChallengeManager")
autoImport("RandomAIManager")
autoImport("TappingManager")
autoImport("FollowNpcAIManager")
autoImport("VisitNpcManager")
autoImport("InteractLocalManager")
autoImport("LocalSimpleAIManager")
autoImport("BigWorldManager")
autoImport("QuestUseFuncManager")
autoImport("HotKeyTipManager")
MapManager = class("MapManager")
MapManager.Mode = {
  PVE = 1,
  PVP = 2,
  Raid = 3
}
MapManager.EnumNoCat = {
  HideHead_Pet = 2,
  HideHead_Being = 4,
  ForbidMultiMount = 512,
  CheckCanArrive = 4096
}
MapManager.MapRaidFeature = {
  IsRaidPuzzle = 4,
  IsLightPuzzle = 8,
  IsInPlacePuzzle = 16,
  IsOriginalCameraZoom = 32
}
local tempVector3 = LuaVector3.Zero()
local _RoleUGUIVisibleRange = LogicManager_MapCell.RoleUGUIVisibleRange

function MapManager:ctor()
  self.mapInfo = {
    0,
    nil,
    LuaVector3.Zero(),
    false,
    0,
    0
  }
  self.enviromentManager = EnviromentManager.new()
  self.areaTriggerManager = AreaTriggerManager.new()
  self.dungeonManager = DungeonManager.new()
  self.lockTargetEffectManager = LockTargetEffectManager.new()
  self.clickGroundManager = ClickGroundEffectManager.new()
  self.skillWorkerManager = SkillWorkerManager.new()
  self.dynamicObjectManager = DynamicObjectManager.new()
  self.sceneSeatManager = SceneSeatManager.new()
  self.questMiniMapEffectManager = QuestMiniMapEffectManager.new()
  self.plotStoryManager = PlotStoryManager.new()
  self.handUpManager = HandUpManager.new()
  self.pictureWallManager = PictureWallManager.new()
  self.weddingWallPicManager = WeddingWallPicManager.new()
  self.homeWallPicManager = HomeWallPicManager.new()
  self.scenicManager = FunctionScenicSpot.Me()
  self.hotKeyManager = HotKeyManager.new()
  self.interactNpcManager = InteractNpcManager.new()
  self.clientNpcManager = ClientNpcManager.new(self)
  self.visitNpcManager = VisitNpcManager.new()
  self.bigWorldManager = BigWorldManager.new()
  Game.EnviromentManager = self.enviromentManager
  Game.AreaTriggerManager = self.areaTriggerManager
  Game.DungeonManager = self.dungeonManager
  Game.LockTargetEffectManager = self.lockTargetEffectManager
  Game.ClickGroundEffectManager = self.clickGroundManager
  Game.SkillWorkerManager = self.skillWorkerManager
  Game.DynamicObjectManager = self.dynamicObjectManager
  Game.SceneSeatManager = self.sceneSeatManager
  Game.QuestMiniMapEffectManager = self.questMiniMapEffectManager
  Game.PlotStoryManager = self.plotStoryManager
  Game.HandUpManager = self.handUpManager
  Game.PictureWallManager = self.pictureWallManager
  Game.WeddingWallPicManager = self.weddingWallPicManager
  Game.HomeWallPicManager = self.homeWallPicManager
  Game.HotKeyManager = self.hotKeyManager
  Game.InteractNpcManager = self.interactNpcManager
  Game.VisitNpcManager = self.visitNpcManager
  Game.BigWorldManager = self.bigWorldManager
  Game.HotKeyTipManager = HotKeyTipManager.new()
  self.homeManager = HomeManager.Me()
  self.raidPuzzleManager = RaidPuzzleManager.Me()
  self:_Reset()
end

function MapManager:_Reset()
  self.sceneInfo = nil
  self.mode = nil
  self.sceneAnimation = nil
  self.sceneAnimationAnimator = nil
  self.sceneAnimationPlaying = false
  self.running = false
  self.diableInput = false
  self.sceneAnimationShutdownTime = -1
  self.afk = 0
  self.isIgnoreSceneUIMapCellLod = nil
  if self.enviromentManager then
    self.enviromentManager.ResetAmbientLight()
  end
  self:ClearMapRegionData()
end

function MapManager:SetInputDisable(disable)
  if self.diableInput == disable then
    return
  end
  self.diableInput = disable
  Game.InputManager.disable = disable
  LogUtility.InfoFormat("<color=yellow>SetInputDisable: </color>{0}", disable)
end

function MapManager:GetMapID()
  return self.mapInfo[1]
end

local bigWorldMapIds = {149, 154}

function MapManager:IsCurBigWorld()
  return self.mapInfo[1] and TableUtility.ArrayFindIndex(bigWorldMapIds, self.mapInfo[1]) > 0
end

function MapManager.IsMapBigWorld(mapid)
  return mapid and TableUtility.ArrayFindIndex(bigWorldMapIds, mapid) > 0
end

function MapManager:IsBigWorld()
  if self:IsCurBigWorld() then
    return true
  end
  local mapRaid = Table_MapRaid[self.mapInfo[1]]
  if mapRaid ~= nil then
    local feature = mapRaid.Feature
    if feature ~= nil then
      return feature & FeatureDefines_MapRaid.BigWorld > 0
    end
  end
  return false
end

function MapManager:GetWorldID()
  local nowMapId = self.mapInfo[1]
  local staticData = Table_Map[nowMapId]
  if staticData and staticData.World then
    return staticData.World
  end
  return 1
end

function MapManager:GetRaidID()
  return self.mapInfo[6] or 0
end

function MapManager:GetMapName()
  return self.mapInfo[2]
end

function MapManager:GetPreviewed()
  return self.mapInfo[4]
end

function MapManager:GetNeedWaitCutScene()
  return self.mapInfo[9]
end

function MapManager:GetSceneID()
  return self.mapInfo[10] or 0
end

function MapManager:SetPreview(preview)
  self.mapInfo[4] = preview and preview ~= 0 or false
end

function MapManager:SetMapName(serverData)
  if serverData.mapName and string.find(serverData.mapName, "&&") then
    local strsp = string.split(serverData.mapName, "&&")
    serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(strsp[1]) .. strsp[2]
  else
    local lastNumbers = serverData.mapName and string.match(serverData.mapName, "%d+$")
    if lastNumbers then
      local mapName = serverData.mapName:gsub(lastNumbers, "")
      serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(mapName) .. lastNumbers
    end
  end
  self.mapInfo[2] = serverData.mapName
end

function MapManager:SetSceneID(sceneid)
  self.mapInfo[10] = sceneid
end

function MapManager:GetCreatureMaskRange()
  return _RoleUGUIVisibleRange
end

function MapManager:GetSceneInfo()
  return self.sceneInfo
end

function MapManager:GetMode()
  return self.mode
end

function MapManager:IsPVEMode()
  return MapManager.Mode.PVE == self.mode
end

function MapManager:IsPVPMode()
  return MapManager.Mode.PVP == self.mode or self.dungeonManager:IsPVPRaidMode()
end

function MapManager:CheckMsgForbidden()
  return self:IsPVPMode() or self:IsPVPMode_EndlessBattleField()
end

function MapManager:IsPVPRaidMode()
  return self.dungeonManager:IsPVPRaidMode()
end

function MapManager:CreatureHidePropInvalid()
  return self:IsPVPRaidMode() and not PvpObserveProxy.Instance:IsRunning()
end

function MapManager:IsPVPMode_GVGDetailed()
  return self.dungeonManager:IsGVG_Detailed()
end

function MapManager:IsMainCity()
  return self.mapType == 6
end

function MapManager:IsInGVGRaid()
  return self:IsPVPMode_GVGDetailed() or self:IsGvgMode_Droiyan()
end

function MapManager:IsInGVG(exclude_dateBattle)
  if exclude_dateBattle then
    return self.dungeonManager:IsGVGMetal() or self.dungeonManager:IsGVG_Lobby()
  else
    return self:IsPVPMode_GVGDetailed() or self:IsInGVG_Lobby()
  end
end

function MapManager:IsGVG_Date()
  return self:IsGVG_DateBattle() or self:IsGVG_DateBattle_Lobby()
end

function MapManager:GetLobbyMode()
  return self.dungeonManager:GetLobbyMode()
end

function MapManager:IsGVG_DateBattle()
  return self.dungeonManager:IsGVG_DateBattle()
end

function MapManager:IsGVG_DateBattle_Lobby()
  return self.dungeonManager:IsGVG_Lobby_Date_Battle()
end

function MapManager:IsInGVG_Lobby()
  return self.dungeonManager:IsGVG_Lobby() or self.dungeonManager:IsGVG_Lobby_Date_Battle()
end

function MapManager:TryMoveToGvGCity(isMyCity)
  if self:IsInGVG_Lobby() then
    self.dungeonManager:GVG_Lobby_Transfer(isMyCity)
  end
end

function MapManager:IsPVPMode_PoringFight()
  return self.dungeonManager:IsPVPMode_PoringFight()
end

function MapManager:IsPVPMode_MvpFight()
  return self.dungeonManager:IsPVPMode_MvpFight()
end

function MapManager:IsPVPMode_TeamPws()
  return self.dungeonManager:IsPVPMode_TeamPws()
end

function MapManager:IsPVPMode_TeamPwsExcludeOthello()
  return self.dungeonManager:IsPVPMode_TeamPwsExcludeOthello()
end

function MapManager:IsPVPMode_TeamPwsOthello()
  return self.dungeonManager:IsPVPMode_TeamPwsOthello()
end

function MapManager:IsPVPMode_TransferFight()
  return self.dungeonManager:IsPVPMode_TransferFight()
end

function MapManager:IsPveMode_PveCard()
  return self.dungeonManager:IsPveMode_PveCard()
end

function MapManager:IsHeroJournery()
  return self.dungeonManager:IsHeroJournery()
end

function MapManager:IsPveMode_AltMan()
  return self.dungeonManager:IsPveMode_AltMan()
end

function MapManager:IsPveMode_Thanatos()
  return self.dungeonManager:IsPveMode_Thanatos()
end

function MapManager:IsGvgMode_Droiyan()
  return self.dungeonManager:IsGvgMode_Droiyan()
end

function MapManager:IsPVPMode_Polly3v3v3()
  return self.dungeonManager:IsPVPMode_Polly3v3v3()
end

function MapManager:IsPVEMode_DemoRaid()
  return self.dungeonManager:IsPVEMode_DemoRaid()
end

function MapManager:IsTeamPwsFire()
  return self.dungeonManager:IsTeamPwsFire()
end

function MapManager:IsRaidMode(checkImageId)
  local inRaid = MapManager.Mode.Raid == self.mode
  if inRaid and checkImageId then
    local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
    local inMirrorRaid = imgId ~= nil and 0 < imgId
    return not inMirrorRaid
  end
  return inRaid
end

function MapManager:IsInGuildMap()
  return self:GetMapID() == 10001
end

function MapManager:IsInAbyssLake()
  return self:GetMapID() == 154
end

function MapManager:IsPVEMode_ExpRaid()
  return self.dungeonManager:IsPVEMode_ExpRaid()
end

function MapManager:IsPVEMode_HeadwearRaid()
  return self.dungeonManager:IsPVEMode_HeadwearRaid()
end

function MapManager:IsPVEMode_Roguelike()
  return self.dungeonManager:IsPVEMode_Roguelike()
end

function MapManager:IsPVEMode_MonsterShot()
  return self.dungeonManager:IsPVEMode_MonsterShot()
end

function MapManager:IsPVEMode_MonsterQA()
  return self.dungeonManager:IsPVEMode_MonsterQA()
end

function MapManager:IsPVEMode_DeadBoss()
  return self.dungeonManager:IsPVEMode_DeadBoss()
end

function MapManager:IsNoSelectTarget()
  return self.dungeonManager:IsNoSelectTarget()
end

function MapManager:IsEndlessTower()
  if self:IsRaidMode() then
    return self.dungeonManager:IsEndlessTower()
  end
  return false
end

function MapManager:IsPveMode_Arena()
  return self.dungeonManager:IsPveMode_Arena()
end

function MapManager:IsPvpMode_DesertWolf()
  return self.dungeonManager and self.dungeonManager:IsPvpMode_DesertWolf()
end

function MapManager:IsPveMode_IPRaid()
  return self.dungeonManager:IsPveMode_IPRaid()
end

function MapManager:IsPveMode_ThanksgivingRaid()
  return self.dungeonManager:IsPVEMode_ThanksgivingRaid()
end

function MapManager:IsPveMode_IPRaid()
  return self.dungeonManager:IsPveMode_IPRaid()
end

function MapManager:IsPVeMode_EndlessTowerPrivate()
  return self.dungeonManager:IsPVEMode_EndlessTowerPrivate()
end

function MapManager:IsHomeMap(mapId)
  return (GameConfig.Home.MapDatas and GameConfig.Home.MapDatas[mapId]) ~= nil
end

function MapManager:IsNightmareMap(mapId)
  local nightmareMapCfg = GameConfig.Nightmare and GameConfig.Nightmare.EffLimitMap
  return nightmareMapCfg ~= nil and TableUtility.ArrayFindIndex(nightmareMapCfg, mapId) > 0
end

function MapManager:IsPvPMode_TeamTwelve()
  return self.dungeonManager:IsPvPMode_TeamTwelve()
end

function MapManager:IsPVEMode_ChasingScene()
  return self.dungeonManager:IsPVEMode_ChasingScene()
end

function MapManager:IsRaidPuzzle()
  return RaidPuzzleManager.Me():IsWorking()
end

function MapManager:IsPVEMode_ComodoRaid()
  return self.dungeonManager:IsPVEMode_ComodoRaid()
end

function MapManager:IsPVEMode_Element()
  return self.dungeonManager:IsPVEMode_Element()
end

function MapManager:IsPVEMode_MultiBossRaid()
  return self.dungeonManager:IsPVEMode_MultiBossRaid()
end

function MapManager:IsPVEMode_HeartLockRaid()
  return self.dungeonManager:IsPVEMode_HeartLockRaid()
end

function MapManager:IsPVEMode_CrackRaid()
  return self.dungeonManager:IsPVEMode_CrackRaid()
end

function MapManager:IsPVEMode_BossScene()
  return self.dungeonManager:IsPVEMode_BossScene()
end

function MapManager:IsPVEMode_StarArk()
  return self.dungeonManager:IsPVEMode_StarArk()
end

function MapManager:IsPVPMode_3Teams()
  return self.dungeonManager:IsPVPMode_3Teams()
end

function MapManager:IsPVPMode_EndlessBattleField()
  return self.dungeonManager:IsPVPMode_EndlessBattleField()
end

function MapManager:CheckForbiddenChatRoom()
  if self:IsInGVGRaid() then
    return true
  end
  if self:IsPVPMode_EndlessBattleField() then
    return SceneProxy.Instance:IsPvPScene()
  end
  if self:IsPVPMode() then
    return true
  end
  return false
end

function MapManager:IsPVEMode_SpaceTimeIllusion()
  return self.dungeonManager:IsPVEMode_SpaceTimeIllusion()
end

function MapManager:IsInDungeon()
  return self.dungeonManager:IsRunning()
end

function MapManager:MapTeamNoNeedInPvpZone()
  return self:IsPVEMode_HeadwearRaid() or self:IsEndlessTower()
end

function MapManager:MapForbidLeaveButton()
  if GameConfig.School and not GameConfig.School.leave_button_forbid_raid_off then
    return self:IsMapForbid()
  end
end

function MapManager:MapForbidTeamButton()
  if GameConfig.School and GameConfig.School.forbid_raid then
    return TableUtility.ArrayFindIndex(GameConfig.School.forbid_raid, self:GetMapID()) > 0
  end
end

function MapManager:IsMapForbid()
  if GameConfig.School and GameConfig.School.forbid_raid then
    return TableUtility.ArrayFindIndex(GameConfig.School.forbid_raid, self:GetMapID()) > 0
  end
end

function MapManager:IsInGuildRaidMap()
  return self:GetMapID() == 7051
end

function MapManager:IsInSchoolMap()
  return self:GetMapID() == 113
end

function MapManager:IsEndlessBattleMap(id)
  local config = GameConfig.EndlessBattleField
  if not config then
    return false
  end
  return id == config.PvpRaidID or id == config.PveRaidID
end

function MapManager:IsInSuperGvg()
  local mapid = self:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid and mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_SUPERGVG then
      return true
    end
  end
end

function MapManager:IsMapRaidTypeForbid(config)
  if not config then
    return false
  end
  local mapid = self:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid then
      for _, v in pairs(config) do
        if mapRaid.Type == v then
          return true
        end
      end
    end
  end
  return false
end

function MapManager:IsFpsCheckForbid()
  local mapid = self:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid and (mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_GUILDFIRE or mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_SUPERGVG or mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_MVPBATTLE) then
      return true
    end
  end
  return false
end

function MapManager:IsForbidMultiMount()
  local staticData = Table_Map[self:GetMapID()]
  local NoCat = staticData and staticData.NoCat
  return NoCat and NoCat & MapManager.EnumNoCat.ForbidMultiMount
end

function MapManager:GetBornPointArray()
  return self.sceneInfo and self.sceneInfo.bps or nil
end

function MapManager:GetExitPointArray(mapID)
  local sceneInfo = mapID and self:GetSceneInfoByMapID(mapID) or self.sceneInfo
  return sceneInfo and sceneInfo.eps or nil
end

function MapManager:GetNPCPointArray()
  return self.sceneInfo and self.sceneInfo.nps or nil
end

function MapManager:GetBornPointMap()
  return self.sceneInfo and self.sceneInfo.bpMap or nil
end

function MapManager:GetExitPointMap()
  return self.sceneInfo and self.sceneInfo.epMap or nil
end

function MapManager:GetNPCPointMap()
  return self.sceneInfo and self.sceneInfo.npMap or nil
end

function MapManager:FindBornPoint(ID)
  local map = self:GetBornPointMap()
  return map and map[ID] or nil
end

function MapManager:FindExitPoint(ID)
  local map = self:GetExitPointMap()
  return map and map[ID] or nil
end

function MapManager:FindNPCPoint(ID)
  local map = self:GetNPCPointMap()
  return map and map[ID] or nil
end

function MapManager:SetCurrentMap(serverData, force)
  local currentMapID = self.mapInfo[1]
  local currentRaidID = self.mapInfo[6]
  local mapID = serverData.mapID
  local raidID = serverData.dmapID
  if not force and currentMapID == mapID and currentRaidID == raidID then
    return
  end
  self:Shutdown()
  self.mapInfo[1] = mapID
  self.mapInfo[6] = raidID or 0
  self:ResetSceneInfo()
  if serverData.mapName and string.find(serverData.mapName, "&&") then
    local strsp = string.split(serverData.mapName, "&&")
    serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(strsp[1]) .. strsp[2]
  else
    local lastNumbers = serverData.mapName and string.match(serverData.mapName, "%d+$")
    if lastNumbers then
      local mapName = serverData.mapName:gsub(lastNumbers, "")
      serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(mapName) .. lastNumbers
    end
  end
  self.mapInfo[2] = serverData.mapName
  if serverData.pos ~= nil then
    ProtolUtility.Better_S2C_Vector3(serverData.pos, self.mapInfo[3])
    self.mapInfo[7] = nil
  else
    self.mapInfo[7] = true
  end
  self.mapInfo[4] = nil ~= serverData.preview and 0 ~= serverData.preview
  self.mapInfo[9] = nil ~= serverData.cutscene and false ~= serverData.cutscene
  self.mapInfo[10] = serverData.sceneid
  self.mapInfo[5] = _RoleUGUIVisibleRange
  LogUtility.InfoFormat("<color=yellow>Creature Mask Priority: </color>{0}", self.mapInfo[5])
  Game.AreaTrigger_ExitPoint:SetInvisibleEPs(serverData.invisiblexit)
  Game.Myself.data:ResetRandom()
  local curID = self:GetRaidID() or 0
  if curID == 0 then
    QuestProxy.Instance:clearFubenQuestData()
  end
  local raidInfo = Table_MapRaid[self.mapInfo[1]]
  if raidInfo and raidInfo.Feature and 0 < raidInfo.Feature & FeatureDefines_MapRaid.DefineAsCommonMap then
    self:SetInnerAreaTrigger(self.mapInfo[1])
  end
  self:RaidIDChanged()
  self:ShutdownAutoBattle(currentMapID)
  GvgProxy.Instance:QueryCityInfo(self.mapInfo[1])
end

function MapManager:SetMapIDs(serverData)
  self.mapInfo[1] = serverData.mapID
  self.mapInfo[6] = serverData.dmapID or 0
  self:RaidIDChanged()
end

function MapManager:RaidIDChanged()
  local raidID = self:GetRaidID()
  NCreature.SetForceVisible(raidID == 1900050 or raidID == 1003621)
  self:ResetSceneInfo()
end

function MapManager:ResetSceneInfo()
  local raidID = self:GetRaidID()
  local imageID = ServicePlayerProxy.Instance:GetCurMapImageId()
  local staticData
  local activeMapID = raidID
  self.isInImageMap = false
  if raidID and raidID ~= 0 then
    activeMapID = raidID
  elseif imageID and imageID ~= 0 then
    activeMapID = imageID
    self.isInImageMap = true
  else
    activeMapID = self:GetMapID()
  end
  if self.curActiveMapID == activeMapID then
    return
  end
  self.curActiveMapID = activeMapID
  staticData = Table_Map[activeMapID]
  if not staticData and self.isInImageMap then
    staticData = Table_Map[self:GetMapID()]
  end
  if not staticData then
    self.mode = MapManager.Mode.Raid
    self.sceneInfo = nil
    redlog("Map表中缺失地图ID", tostring(self.isInImageMap and self:GetMapID() or activeMapID))
    return
  end
  self.curActiveMapID = activeMapID
  self.mapType = staticData.Type
  local mode = staticData.Mode
  local sceneName = staticData.NameEn
  local sceneInfoName = "Scene_" .. sceneName
  local sceneInfo = autoImport(sceneInfoName)
  local scenePartInfo
  if MapManager.Mode.PVE == mode then
    LogUtility.InfoFormat("<color=yellow>Switch Map PVE: </color>{0}", mapID)
    scenePartInfo = sceneInfo.PVE
  elseif MapManager.Mode.PVP == mode then
    LogUtility.InfoFormat("<color=yellow>Switch Map PVP: </color>{0}", mapID)
    scenePartInfo = sceneInfo.PVP
  elseif MapManager.Mode.Raid == mode then
    LogUtility.InfoFormat("<color=yellow>Switch Map Raid: </color>{0}, {1}", mapID, activeMapID)
    scenePartInfo = sceneInfo.Raids[activeMapID]
  end
  if nil ~= scenePartInfo then
    Game.DoPreprocess_ScenePartInfo(scenePartInfo, sceneInfoName)
  end
  self:processMonsterGroupInfo(scenePartInfo)
  self.mode = mode
  self.sceneInfo = scenePartInfo
  self:LoadMapRegionData()
end

function MapManager:ClearMapRegionData()
  self.regionConfig = nil
  if self.mapRegionPath then
    Game.AssetManager:UnloadAsset(self.mapRegionPath)
    self.mapRegionPath = nil
  end
  if self.mapRegionData then
    self.mapRegionData = nil
  end
end

function MapManager:LoadMapRegionData()
  self:ClearMapRegionData()
  self.regionConfig = WorldMapProxy.Instance:GetRegionMap()
  if self.regionConfig then
    local sData = Table_Map[self:GetMapID()]
    if sData then
      self.mapRegionPath = ResourcePathHelper.MapRegion("Scene" .. sData.NameEn)
      Game.AssetManager:LoadAssetAsync(self.mapRegionPath, MapRegionData, self.OnRegionDataLoaded, self, self.mapRegionPath)
    end
  end
end

function MapManager:OnRegionDataLoaded(asset, path, regionPath)
  local mapId = self:GetMapID()
  local staticData = Table_Map[mapId]
  local nowSceneInfoName = staticData and "Scene_" .. staticData.NameEn
  if regionPath == self.mapRegionPath then
    self.mapRegionData = asset
  end
end

function MapManager:GetMyRegionInfo()
  if not self.regionConfig or not self.mapRegionData then
    return
  end
  local regionID = self.mapRegionData:GetRegionId(Game.Myself:GetPosition())
  if regionID and 0 < regionID then
    return regionID, self.regionConfig[regionID]
  end
  return
end

function MapManager:GetSceneInfoByMapID(mapID)
  local staticData = Table_Map[mapID]
  if not staticData then
    redlog("当前地图map表中缺失", mapID)
    return
  end
  local mode = staticData.Mode
  local sceneInfoName = "Scene_" .. staticData.NameEn
  self.mapType = staticData.Type
  local sceneInfo = autoImport(sceneInfoName)
  local scenePartInfo
  if MapManager.Mode.PVE == mode then
    scenePartInfo = sceneInfo.PVE
  elseif MapManager.Mode.PVP == mode then
    scenePartInfo = sceneInfo.PVP
  elseif MapManager.Mode.Raid == mode then
    local raidID, partInfo = next(sceneInfo.Raids)
    scenePartInfo = partInfo
  end
  if nil ~= scenePartInfo then
    Game.DoPreprocess_ScenePartInfo(scenePartInfo, sceneInfoName)
  end
  return scenePartInfo
end

function MapManager:SetEnviroment(enviromentID, duration)
  self.enviromentManager:SetBaseInfo(enviromentID, duration)
end

function MapManager:SetSceneAnimation(a)
  self.sceneAnimation = a
  if nil ~= a then
    self.sceneAnimationAnimator = a.animator
  else
    self.sceneAnimationAnimator = nil
  end
end

function MapManager:Previewing()
  return self.sceneAnimationPlaying
end

function MapManager:StartPreview()
  if nil ~= self.sceneAnimation and self.sceneAnimationShutdownTime < 0 then
    self.sceneAnimation:Play()
    return true
  end
  return false
end

function MapManager:StopPreview()
  if nil ~= self.sceneAnimation then
    self.sceneAnimation:Stop()
  end
end

function MapManager:SceneAnimationLaunch(animName, time)
  if self.sceneAnimationPlaying then
    return
  end
  if self.sceneAnimationAnimator == nil then
    return
  end
  if 0 < time then
    self.sceneAnimationShutdownTime = UnityTime + time
  else
    self.sceneAnimationShutdownTime = 0
  end
  local cameraController = CameraController.singletonInstance
  if cameraController ~= nil then
    GameObjectUtil.SetBehaviourEnabled(cameraController, false)
    cameraController.updateCameras = true
  end
  GameObjectUtil.SetBehaviourEnabled(self.sceneAnimationAnimator, true)
  self.sceneAnimationAnimator:Play(animName)
  Game.PerformanceManager:SkinWeightHigh(true)
end

function MapManager:SceneAnimationShutdown(noReset)
  if self.sceneAnimationShutdownTime < 0 then
    return
  end
  self.sceneAnimationShutdownTime = -1
  local cameraController = CameraController.singletonInstance
  if cameraController ~= nil then
    if not noReset then
      GameObjectUtil.SetBehaviourEnabled(cameraController, true)
    end
    cameraController.updateCameras = false
  end
  if self.sceneAnimationAnimator then
    GameObjectUtil.SetBehaviourEnabled(self.sceneAnimationAnimator, false)
  end
  Game.PerformanceManager:SkinWeightHigh(false)
end

function MapManager:OnPreviewStart()
  if self.sceneAnimationPlaying then
    return
  end
  self.sceneAnimationPlaying = true
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    cameraController.updateCameras = true
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus(false)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "SceneAnimationPanel"
  })
end

function MapManager:OnPreviewStop()
  if not self.sceneAnimationPlaying then
    return
  end
  self.sceneAnimationPlaying = false
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    cameraController.updateCameras = false
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, SceneAnimationPanel.ViewType)
  FunctionQuest.Me():CheckPlayQuestVideo()
  self:OnObSceneAnimationShutDown()
end

function MapManager:_RestoreZoomAtFirst()
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    return
  end
  local cameraMode = FunctionCameraEffect.Me():GetCurCameraMode()
  local zoom = LocalSaveProxy.Instance:GetCameraZoom()
  if cameraMode == FunctionCameraEffect.CameraMode.Lock then
    cameraController.defaultCameraZoomMin = 0.4
    cameraController.freeCameraZoomMin = 0.4
  elseif cameraMode == FunctionCameraEffect.CameraMode.FreeHori then
    cameraController.defaultCameraZoomMin = 0.38
    cameraController.freeCameraZoomMin = 0.38
  elseif cameraMode == FunctionCameraEffect.CameraMode.Free then
    cameraController.defaultCameraZoomMin = 0.32
    cameraController.freeCameraZoomMin = 0.32
  end
  local mapId = self:GetMapID()
  local raidInfo = Table_MapRaid[mapId]
  local needRestore = true
  if raidInfo and raidInfo.Feature and raidInfo.Feature & MapManager.MapRaidFeature.IsOriginalCameraZoom > 0 then
    needRestore = false
  end
  if zoom and needRestore then
    zoom = math.max(zoom, cameraController.defaultCameraZoomMin)
    cameraController:ResetCameraZoomMinMaxByStatus()
    cameraController.zoom = zoom
  end
end

function MapManager:_CameraFocusMyself()
  self:UpdateCameraInstance(CameraController.singletonInstance)
  FunctionCameraEffect.Me():InitFreeCameraParam()
  Game.InputManager:SetPhotographCameraLock(SceneProxy.Instance:IsCurMapCameraLocked())
  EventManager.Me():PassEvent(PlayerEvent.CapturedCamera)
end

function MapManager:_HandleCameraEffect()
  Game.EnviromentManager:RefreshCurrentBloom()
end

function MapManager:UpdateCameraInstance(cameraController)
  if cameraController == nil then
    cameraController = CameraController.singletonInstance
  end
  if cameraController == nil then
    return
  end
  local cameraInfo = cameraController.defaultInfo
  local savedRotX, savedRotY = LocalSaveProxy.Instance:GetFreeCameraRotation()
  local freeCameraRotation = LuaGeometry.GetTempVector3(savedRotX, savedRotY, 0)
  local mapId = self:GetMapID()
  local ignoreSavedRotation = GameConfig.CameraUnlock.IgnoreSavedRotation
  if savedRotX == 0 and savedRotY == 0 or ignoreSavedRotation and 0 < TableUtility.ArrayFindIndex(ignoreSavedRotation, mapId) then
    freeCameraRotation:Set(cameraInfo.rotation.x, cameraInfo.rotation.y, cameraInfo.rotation.z)
  end
  if FunctionPerformanceSetting.Me():GetCameraLocked() then
    freeCameraRotation.x = cameraInfo.rotation.x
    freeCameraRotation.y = cameraInfo.rotation.y
  elseif FunctionPerformanceSetting.Me():VerticalCameraLocked() then
    freeCameraRotation.x = FunctionCameraEffect.DefaultCameraVertAngle
  end
  local myselfTransform = Game.Myself.assetRole.completeTransform
  if nil ~= cameraInfo then
    cameraInfo.focus = myselfTransform
  end
  local freeDefaultInfo = cameraController.FreeDefaultInfo
  if nil ~= freeDefaultInfo then
    freeDefaultInfo.focus = myselfTransform
    freeDefaultInfo.rotation = freeCameraRotation
  end
  local photographInfo = cameraController.photographInfo
  if nil ~= photographInfo then
    photographInfo.focus = myselfTransform
  end
  self:UpdateCameraState(cameraController)
  local zoom = LocalSaveProxy.Instance:GetCameraZoom()
  if zoom then
    cameraController.zoom = zoom
  end
end

function MapManager:UpdateCameraState(cameraController)
  if cameraController == nil then
    return
  end
  FunctionCameraEffect.Me():ResetFreeCameraLocked(nil, true)
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
  FunctionCameraEffect.ResetFreeCameraFocusOffset(Game.Myself.assetRole, true)
  if not cameraController.IsPhotoMode and cameraController.enabled then
    cameraController:InterruptSmoothTo()
    cameraController:RestoreDefault(0, nil)
    cameraController:FieldOfViewTo(cameraController.cameraFieldOfView)
    if Game.CameraPointManager then
      Game.CameraPointManager:SendMessage("LateUpdate", SendMessageOptions.DontRequireReceiver)
      cameraController:InterruptSmoothTo()
    end
    cameraController:ForceUpdateCamera(true, false)
  end
end

function MapManager:_LaunchAfterPreview()
  self:_RestoreZoomAtFirst()
  self:_CameraFocusMyself()
  self:_HandleCameraEffect()
  SceneUIManager.Instance:ResetCanvasCamera()
  self:SetInputDisable(false)
  self.areaTriggerManager:Launch()
  local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
  if MapManager.Mode.Raid == self.mode or imgId and MirrorRaidConfig[imgId] then
    self.dungeonManager:Launch()
  end
  self.handUpManager:Launch()
  self.plotStoryManager:Launch(true)
  GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  GameFacade.Instance:sendNotification(LoadSceneEvent.SceneAnimEnd)
end

function MapManager:Launch()
  if self.running then
    helplog("MapManager:Launch : isrunning")
  end
  self.running = true
  helplog("MapManager:Launch")
  Game.GameObjectManagers[Game.GameObjectType.Camera]:DeterminMainCamera()
  local cameraInfo = self.sceneInfo and self.sceneInfo.cameraInfo
  if nil ~= cameraInfo then
    local cameraController = CameraController.singletonInstance
    if nil ~= cameraController then
      local cameraDefaultInfo = cameraController.defaultInfo
      cameraDefaultInfo.focusOffset = cameraInfo.focusOffset
      cameraDefaultInfo.focusViewPort = cameraInfo.focusViewPort
      cameraDefaultInfo.rotation = cameraInfo.rotation
      cameraDefaultInfo.fieldOfView = cameraInfo.fieldOfView
    end
  end
  self:TrySetMirrorObjInScene()
  Game.Myself:EnterScene()
  if not self.mapInfo[7] then
    Game.Myself:Client_PlaceTo(self.mapInfo[3])
  end
  ServiceUserProxy.Instance:CheckRealInitialized()
  self.homeManager:Launch()
  self.sceneSeatManager:Launch()
  self.enviromentManager:Launch()
  self.skillWorkerManager:Launch()
  self.dynamicObjectManager:Launch()
  self.questMiniMapEffectManager:Launch()
  self.pictureWallManager:Launch()
  self.weddingWallPicManager:Launch()
  self.homeWallPicManager:Launch()
  self.hotKeyManager:Launch()
  self.interactNpcManager:Launch()
  self.clickGroundManager:Launch()
  self.clientNpcManager:Launch()
  Game.PerformanceManager:Launch()
  Game.GameHealthProtector:EnterScene()
  BifrostProxy.Instance:LaunchBrokenCrystalTick()
  Game.LogicManager_MapCell:Launch()
  self.raidPuzzleManager:Launch()
  LightPuzzleManager.Me():Launch()
  FunctionSniperMode.Me():EnterScene()
  FunctionPhotoStand.Me():Launch()
  FunctionPostcardTex.Me():Launch()
  RunnerChallengeManager.Me():Launch()
  RandomAIManager.Me():Launch()
  TappingManager.Me():Launch()
  SgAIManager.Me():Launch()
  FollowNpcAIManager.Me():Launch()
  RunnerChallengeManager.Me():Launch()
  self.visitNpcManager:Launch()
  InteractLocalManager.Me():Launch()
  LocalSimpleAIManager.Me():Launch()
  QuestUseFuncManager.Me():Launch()
  FunctionAstral.Me():Launch()
  FunctionAbyssLake.Me():Launch(self.mapInfo[1])
  if MapManager.Mode.Raid == self.mode then
    self.dungeonManager:SetRaidID(self.curActiveMapID)
  else
    redlog("self.mode: ", self.mode)
  end
  if self.mapInfo[4] and not self:GetNeedWaitCutScene() and self:StartPreview() then
    self:OnPreviewStart()
  else
    self:_LaunchAfterPreview()
  end
  self:ShowMapName()
  self:SetMapFilter()
  if self:IsPVPMode() then
    SkillInfo.SetMapMode(2)
  else
    SkillInfo.SetMapMode(1)
  end
end

function MapManager:ShowMapName()
  if self.mapInfo[8] and self.mapInfo[8] ~= 0 then
    return
  end
  local nowMapId = self.mapInfo[1]
  local homeMapConfig = GameConfig.Home and GameConfig.Home.MapDatas
  if homeMapConfig and homeMapConfig[nowMapId] then
    return
  end
  if self:IsPVEMode_Roguelike() or self:IsPveMode_IPRaid() or self:IsPVPMode_3Teams() then
    return
  end
  if 0 < ViewSequenceManager.Me():GetWorkingViewSequenceCount() then
    return
  end
  local mapdata = nowMapId and Table_Map[nowMapId]
  if mapdata ~= nil and mapdata.MapTips == 1 then
    FloatingPanel.Instance:ShowMapName(mapdata.NameZh, mapdata.Desc)
  end
end

function MapManager:SetMapFilter()
  local nowMapId = self.mapInfo[1]
  local nowRaidId = self.mapInfo[6]
  local currentMapId
  if nowRaidId ~= 0 then
    currentMapId = nowRaidId
  else
    currentMapId = nowMapId
  end
  local staticData = Table_Map[currentMapId]
  if staticData then
    if staticData.HideOthers and staticData.HideOthers == 1 then
      helplog("该地图需要隐藏其他玩家")
      FunctionSceneFilter.Me():StartFilter(6)
    end
  else
    redlog("Map表中搜寻不到当前地图ID，请检查")
  end
end

function MapManager:TrySetMirrorObjInScene()
  local l_objLowLevel = GameObject.Find("Mirror_LowLevel")
  if not l_objLowLevel then
    redlog("Mirror: Cannot Find Low Level")
    return
  end
  local l_objHighLevel = GameObject.Find("Mirror_HighLevel")
  if not l_objHighLevel then
    redlog("Mirror: Cannot Find High Level")
    return
  end
  local isLowLevel = not BackwardCompatibilityUtil.CompatibilityMode_V54 or ApplicationInfo.IsIphone7P_or_Worse() or ApplicationInfo.IsIpad6_or_Worse()
  redlog("Mirror: Set Mirror Low Level", isLowLevel)
  l_objHighLevel:SetActive(isLowLevel ~= true)
  l_objLowLevel:SetActive(isLowLevel == true)
end

function MapManager:Shutdown()
  if Game.Myself then
    Game.Myself:RemoveObjsWhenLeaveScene()
    Game.Myself:LeaveScene()
  end
  if not self.running then
    return
  end
  self.running = false
  FunctionCameraEffect.Me():SaveCameraInfoToLocal()
  FunctionSceneFilter.Me():ShutDownAll()
  Game.GameObjectManagers[Game.GameObjectType.Camera]:ClearMainCamera()
  if nil ~= Camera.main then
    Camera.main.gameObject:SetActive(false)
  end
  self:SetInputDisable(true)
  Game.LogicManager_MapCell:Shutdown()
  self.homeManager:Shutdown()
  self.sceneSeatManager:Shutdown()
  self.enviromentManager:Shutdown()
  self.areaTriggerManager:Shutdown()
  self.dungeonManager:Shutdown()
  self.clickGroundManager:Shutdown()
  self.lockTargetEffectManager:ClearLockedTarget()
  self.skillWorkerManager:Shutdown()
  Game.EffectManager:ClearAllStat()
  self.dynamicObjectManager:Shutdown()
  self.questMiniMapEffectManager:Shutdown()
  self.plotStoryManager:Shutdown(nil, true)
  self.pictureWallManager:Shutdown()
  self.weddingWallPicManager:Shutdown()
  self.homeWallPicManager:Shutdown()
  self:SceneAnimationShutdown()
  self.hotKeyManager:Shutdown()
  self.interactNpcManager:Shutdown()
  self.clientNpcManager:Shutdown()
  Game.PerformanceManager:Shutdown()
  FunctionSkillTargetPointLauncher.Me():Shutdown()
  Game.GameHealthProtector:LeaveScene()
  self.raidPuzzleManager:Shutdown()
  self.visitNpcManager:Shutdown()
  LightPuzzleManager.Me():Shutdown()
  FunctionSniperMode.Me():LeaveScene()
  RunnerChallengeManager.Me():Shutdown()
  RandomAIManager.Me():Shutdown()
  FunctionLocalActivity.Me():OnLeaveScene()
  FunctionShadowBricks.Me():ShutDown()
  FunctionPvpObserver.Me():OnLeaveScene()
  TappingManager.Me():Shutdown()
  FollowNpcAIManager.Me():Shutdown()
  FunctionSkill.Me():Shutdown()
  FunctionPhotoStand.Me():Shutdown()
  FunctionPostcardTex.Me():Shutdown()
  InteractLocalManager.Me():Shutdown()
  LocalSimpleAIManager.Me():Shutdown()
  self.bigWorldManager:Shutdown()
  QuestUseFuncManager.Me():Shutdown()
  FunctionAstral.Me():Shutdown()
  self:OnPreviewStop()
  self.sceneAnimation = nil
  self.sceneAnimationAnimator = nil
  self.sceneAnimationPlaying = false
  self.isIgnoreSceneUIMapCellLod = nil
  if self.nowRegionBgm then
    self.nowRegionBgm = nil
    FunctionBGMCmd.Me():StopRegionBgm()
  end
end

function MapManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  self.enviromentManager:Update(time, deltaTime)
  if self.sceneAnimationPlaying then
    if self.sceneAnimationAnimator.enabled then
      self:UpdateObClientPosition()
      return
    else
      self:OnPreviewStop()
      self:_LaunchAfterPreview()
    end
  end
  self.homeManager:Update(time, deltaTime)
  self.areaTriggerManager:Update(time, deltaTime)
  self.dungeonManager:Update(time, deltaTime)
  self.skillWorkerManager:Update(time, deltaTime)
  self.dynamicObjectManager:Update(time, deltaTime)
  self.sceneSeatManager:Update(time, deltaTime)
  self.questMiniMapEffectManager:Update(time, deltaTime)
  self.plotStoryManager:Update(time, deltaTime)
  self.handUpManager:Update(time, deltaTime)
  self.scenicManager:Update(time, deltaTime)
  self.interactNpcManager:Update(time, deltaTime)
  self.clientNpcManager:Update(time, deltaTime)
  self.raidPuzzleManager:Update(time, deltaTime)
  LightPuzzleManager.Me():Update(time, deltaTime)
  RunnerChallengeManager.Me():Update(time, deltaTime)
  RandomAIManager.Me():Update(time, deltaTime)
  TappingManager.Me():Update(time, deltaTime)
  self.visitNpcManager:Update(time, deltaTime)
  InteractLocalManager.Me():Update(time, deltaTime)
  LocalSimpleAIManager.Me():Update(time, deltaTime)
  local btManager = Game.GameObjectManagers[Game.GameObjectType.BehaviourTree]
  if btManager then
    btManager:Update(time, deltaTime)
  end
  self.bigWorldManager:Update(time, deltaTime)
  if self.sceneAnimationShutdownTime > 0 and time >= self.sceneAnimationShutdownTime then
    self:SceneAnimationShutdown()
  end
  SceneTrapProxy.Instance:Update()
end

function MapManager:LateUpdate(time, deltaTime)
  if not self.running then
    return
  end
end

function MapManager:SetImageID(Imageid)
  self.mapInfo[8] = Imageid
  self:ResetSceneInfo()
  FunctionShadowBricks.Me():OnImageMapChanged()
  self.raidPuzzleManager:Launch()
  LightPuzzleManager.Me():Launch()
  if Imageid and Imageid ~= 0 then
    self.clientNpcManager:Pause()
    self.bigWorldManager:Stop()
    self.questMiniMapEffectManager:Shutdown()
  else
    self.clientNpcManager:Resume()
    self.bigWorldManager:Start()
  end
end

function MapManager:GetImageID()
  return self.mapInfo[8] or 0
end

function MapManager:SetInnerAreaTrigger(mapId)
  local config = Game.Config_TaskLimit
  if not config then
    return
  end
  local ids = config[mapId]
  if not ids then
    return
  end
  for i = 1, #ids do
    local single = Table_TaskLimit[ids[i]]
    if single then
      local triggerData = {}
      triggerData.id = single.id
      triggerData.type = AreaTrigger_Common_ClientType.Raid_AreaCheck
      local pos = single.pos
      local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
      triggerData.pos = triggerPos
      triggerData.range = single.distance or 999
      triggerData.IO = single.type
      SceneTriggerProxy.Instance:Add(triggerData)
    end
  end
end

function MapManager:IsMapForbidInnerExitPoint(mapid)
  local config = GameConfig.ForbidMiniMapInnerEp
  if config then
    for i = 1, #config do
      if mapid == config[i] then
        return true
      end
    end
  end
  return false
end

function MapManager:NoOverStep()
  if self:IsRaidPuzzle() then
    return true
  end
  return false
end

local _roomShowObjType = Game.GameObjectType.RoomShowObject

function MapManager:LaunchObSceneAnimation()
  if self.obSceneAnimationPlaying then
    return
  end
  if nil == Camera.main then
    return
  end
  local p = Game.Myself:GetPosition()
  self.obInitPos = {
    p[1],
    p[2],
    p[3]
  }
  self.obSceneAnimationCameraTrans = Camera.main.transform
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    GameObjectUtil.SetBehaviourEnabled(cameraController, false)
  end
  Game.AreaTriggerManager:SetIgnore(true)
  local manager = Game.GameObjectManagers[_roomShowObjType]
  manager:ShowAll()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, false)
  if self:StartPreview() then
    self:OnPreviewStart()
    self.obSceneAnimationPlaying = true
  end
end

function MapManager:UpdateObClientPosition()
  if not self.obSceneAnimationPlaying then
    return
  end
  local p = self.obSceneAnimationCameraTrans.position
  Game.Myself:Logic_NavMeshPlaceXYZTo(p.x, p.y, p.z)
end

function MapManager:OnObSceneAnimationShutDown()
  if not self.obSceneAnimationPlaying then
    return
  end
  self.obSceneAnimationPlaying = false
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    GameObjectUtil.SetBehaviourEnabled(cameraController, true)
  end
  local manager = Game.GameObjectManagers[_roomShowObjType]
  manager:HideAll()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, true)
  Game.Myself:Logic_NavMeshPlaceTo(self.obInitPos)
  ServiceFuBenCmdProxy.Instance:CallObCameraMoveEndCmd()
  Game.AreaTriggerManager:SetIgnore(false)
end

function MapManager:ShutdownAutoBattle(lastMapId)
  local lastMapConfig = Table_MapRaid[lastMapId]
  if not lastMapConfig then
    return
  end
  local curMapId = self:GetMapID()
  local curMapConfig = Table_MapRaid[curMapId]
  if not curMapConfig then
    Game.AutoBattleManager:AutoBattleOff()
  end
end

function MapManager:IsInGVGDetailedRaid()
  if not self.dungeonManager:IsGVG_Detailed() then
    return false
  end
  if self:IsGVG_DateBattle() then
    return true
  end
  local raidId = self:GetRaidID() or 0
  local staticData = Game.Config_GuildStrongHold_RaidMap[raidId]
  if not staticData then
    return false
  end
  return true
end

function MapManager:GetUniqueIdByNpc(npcId)
  local npcMap = self.sceneInfo and self.sceneInfo.npMap
  for k, v in pairs(npcMap) do
    if v.ID == npcId then
      return k
    end
  end
end

function MapManager:SetCurWorldQuestGroup()
  local id = self:GetMapID()
  if GameConfig and GameConfig.Quest and GameConfig.Quest and GameConfig.Quest.worldquestmap then
    local mapGroup = GameConfig.Quest.worldquestmap
    for k, v in pairs(mapGroup) do
      if TableUtility.ArrayFindIndex(v.map, id) > 0 then
        self.worldQuestMapGroup = k
        return
      end
    end
  end
  self.worldQuestMapGroup = nil
end

function MapManager:GetWorldQuestGroupByMapID(mapid)
  if GameConfig.Quest and GameConfig.Quest.worldquestmap then
    local mapGroup = GameConfig.Quest.worldquestmap
    for k, v in pairs(mapGroup) do
      if TableUtility.ArrayFindIndex(v.map, mapid) > 0 then
        return k
      end
    end
  end
end

function MapManager:getCurWorldQuestGroup()
  return self.worldQuestMapGroup
end

function MapManager:GetWorldQuestProcessAllFinish(group)
  if group == 1 then
    return TechTreeProxy.Instance:CheckTreeHasReachMaxLevel(3)
  elseif group == 3 then
    local menuUnlock = FunctionUnLockFunc.Me():CheckCanOpen(9928)
    local bokiSkillMax = BokiProxy.Instance:CheckSkillAllMax()
    if menuUnlock and bokiSkillMax then
      return true
    end
    return false
  elseif group == 4 then
    return ServiceFamilyCmdProxy.Instance:IsClueAllFinish()
  elseif group == 7 then
    local versionType = VersionPrestigeProxy.Instance:GetTypeByGroup(group)
    if versionType then
      local menuid = GameConfig.Prestige.PrestigeUnlockMenu and GameConfig.Prestige.PrestigeUnlockMenu[versionType]
      if not menuid or FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
        return VersionPrestigeProxy.Instance:GetVersionAllFinish(versionType)
      end
    end
  end
end

function MapManager:processMonsterGroupInfo(info)
  local npMap = info and info.npMap
  if not npMap then
    return
  end
  local groupList = {}
  for uid, info in pairs(npMap) do
    local monsterConfig = Table_Monster[info.ID]
    if monsterConfig and monsterConfig.GroupID then
      if not groupList[monsterConfig.GroupID] then
        groupList[monsterConfig.GroupID] = {}
      end
      groupList[monsterConfig.GroupID][uid] = info
    end
  end
  info.monsterGroup = groupList
end

function MapManager:GetMonsterPosByGroupID(groupid)
  local groupInfo = self.sceneInfo and self.sceneInfo.monsterGroup or nil
  if groupInfo and groupInfo[groupid] then
    for uid, info in pairs(groupInfo[groupid]) do
      LuaVector3.Better_Set(tempVector3, info.position[1], info.position[2], info.position[3])
      return tempVector3
    end
  end
end

function MapManager:GetNpcPosByID(id)
  local npMap = self.sceneInfo and self.sceneInfo.npMap
  if npMap then
    for uid, info in pairs(npMap) do
      if info.ID == id then
        LuaVector3.Better_Set(tempVector3, info.position[1], info.position[2], info.position[3])
        return tempVector3
      end
    end
  end
end

function MapManager:GetNpcPosByUniqueID(uniqueID)
  local npMap = self.sceneInfo and self.sceneInfo.npMap
  if npMap then
    for uid, info in pairs(npMap) do
      if uid == uniqueID then
        LuaVector3.Better_Set(tempVector3, info.position[1], info.position[2], info.position[3])
        return tempVector3
      end
    end
  end
end

function MapManager:GetNpcInfoByUniqueID(uniqueID)
  if self.sceneInfo == nil then
    return nil
  end
  local npMap = self.sceneInfo.npMap
  if npMap then
    local info = self:GetNpcInfo(npMap, uniqueID)
    if info ~= nil then
      return info
    end
  end
  npMap = self.sceneInfo.onpMap
  if npMap then
    local info = self:GetNpcInfo(npMap, uniqueID)
    if info ~= nil then
      return info
    end
  end
end

function MapManager:GetNpcIDByUniqueID(uniqueID)
  local npMap = self.sceneInfo and self.sceneInfo.npMap
  if npMap then
    for uid, info in pairs(npMap) do
      if uid == uniqueID then
        return info.ID
      end
    end
  end
end

function MapManager:GetNpcDirByUniqueID(uniqueID)
  local npMap = self.sceneInfo and self.sceneInfo.npMap
  if npMap then
    for uid, info in pairs(npMap) do
      if uid == uniqueID then
        return info.dir
      end
    end
  end
end

function MapManager:GetNpcInfo(map, uniqueID)
  for uid, info in pairs(map) do
    if uid == uniqueID then
      return info
    end
  end
end

function MapManager:GetNpcWaitActionByUniqueID(uniqueID)
  local npMap = self.sceneInfo and self.sceneInfo.npMap
  if npMap then
    for uid, info in pairs(npMap) do
      if uid == uniqueID then
        return info.waitaction
      end
    end
  end
end

function MapManager:GetCurMapQuestVersion()
  if not Table_QuestVersion then
    return
  end
  local mapid = self:GetMapID()
  for i = 1, #Table_QuestVersion do
    local mapIDs = Table_QuestVersion[i].MapID or {}
    if TableUtility.ArrayFindIndex(mapIDs, mapid) > 0 then
      return Table_QuestVersion[i].version
    end
  end
end

function MapManager:CheckCanArrive()
  local staticData = Table_Map[self:GetMapID()]
  local NoCat = staticData and staticData.NoCat
  return NoCat and NoCat & MapManager.EnumNoCat.CheckCanArrive > 0
end

function MapManager:IsIgnoreSceneUIMapCellLod()
  return self.isIgnoreSceneUIMapCellLod == true
end

function MapManager:SetIgnoreSceneUIMapCellLod(isTrue)
  self.isIgnoreSceneUIMapCellLod = isTrue
end

function MapManager:IsInAllGVG()
  return self:IsPVPMode_GVGDetailed() or self:IsGvgMode_Droiyan() or self:IsInGVG_Lobby()
end

function MapManager:IsActivityMap()
  local staticData = Table_Map[self:GetMapID()]
  if staticData and staticData.EnterCond and staticData.EnterCond.type == "activity" then
    local actId = tonumber(staticData.EnterCond.id)
    return FunctionActivity.Me():IsActivityRunning(actId)
  end
end
