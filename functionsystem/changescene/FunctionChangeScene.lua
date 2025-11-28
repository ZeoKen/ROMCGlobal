FunctionChangeScene = class("FunctionChangeScene")

function FunctionChangeScene.Me()
  if nil == FunctionChangeScene.me then
    FunctionChangeScene.me = FunctionChangeScene.new()
  end
  return FunctionChangeScene.me
end

function FunctionChangeScene:ctor()
end

function FunctionChangeScene:Reset()
end

function FunctionChangeScene:TryPreLoadResources()
  FunctionPreload.Me():SceneNpcs(Game.Myself:GetPosition(), 33)
  FunctionPreload.Me():PreloadPackageView()
end

function FunctionChangeScene:ClientLoadInAdvence(data)
  if SceneProxy.Instance:IsCurrentScene(data) then
    return
  end
  helplog("===== (Block) Client Load Scene In Advence (Block) =====")
  if self.clientLoadFlag then
    relog("client already load in advance.", "mapid:" .. tostring(data.mapID), "dmapID" .. tostring(data.dmapID))
    return
  end
  self.fakeMapData = {
    mapID = data.mapID,
    dmapID = data.dmapID,
    pos = {
      x = 0,
      y = 0,
      z = 0
    }
  }
  self:TryLoadScene(self.fakeMapData)
  self.clientLoadBlock = true
end

function FunctionChangeScene:TryLoadScene(data)
  if self.clientLoadBlock and self:UnBlockLoadScene(data) then
    return
  end
  self.sceneProxy = SceneProxy.Instance
  local currentScene = self.sceneProxy.currentScene
  EventManager.Me():DispatchEvent(ServiceEvent.PlayerMapChange, data.mapID)
  self:PrepareData(data)
  local sameScene = self.sceneProxy:IsCurrentScene(data)
  local currentSceneLoaded = self.sceneProxy.currentScene ~= nil and self.sceneProxy.currentScene.loaded or false
  if sameScene then
    if currentSceneLoaded then
      self:LoadSameLoadedScene(data)
    else
      local lastNeedLoad = SceneProxy.Instance:GetLastNeedLoad()
      if lastNeedLoad then
        SceneProxy.Instance:RemoveNeedLoad(2)
      end
      return
    end
  else
    self:WaitForLoad(data)
  end
  self:StartLoadScene()
end

function FunctionChangeScene:UnBlockLoadScene(data)
  helplog("===== (UnBlock) Client Load Scene In Advence (UnBlock) =====")
  self.clientLoadBlock = nil
  local fakeMapData = self.fakeMapData
  self.fakeMapData = nil
  if data.mapID ~= fakeMapData.mapID or data.dmapID ~= fakeMapData.dmapID then
    return false
  end
  local firstLoadSceneInfo = SceneProxy.Instance:GetFirstNeedLoad()
  if firstLoadSceneInfo then
    if firstLoadSceneInfo.mapID == data.mapID and firstLoadSceneInfo.dmapID == data.dmapID then
      firstLoadSceneInfo.pos = data.pos
    end
  else
    SceneProxy.Instance.currentScene:Reset(data)
  end
  Game.MapManager:SetCurrentMap(data, true)
  MyselfProxy.Instance:ResetMyBornPos(data.pos.x, data.pos.y, data.pos.z)
  if self.clientLoadFinished then
    self:LoadedScene(data)
  end
  return true
end

function FunctionChangeScene:PrepareData(data)
  LogUtility.InfoFormat("准备加载map: {0} ,raidID: {1}", data.mapID, data.dmapID)
  local mapInfo = SceneProxy.Instance:GetMapInfo(data.mapID)
  if mapInfo == nil then
    error("未找到地图id:" .. data.mapID .. "的信息")
  end
  WorldMapProxy.Instance:UpdateBWZoneInfo(data.mapID)
  return mapInfo
end

function FunctionChangeScene:SetRaidID(raidID, playSceneAnim, mapInfo, isSameScene)
  FunctionDungen.Me():Shutdown()
  if 0 < raidID then
    FunctionDungen.Me():Launch(raidID)
  else
  end
end

function FunctionChangeScene:LoadSameLoadedScene(data)
  LogUtility.InfoFormat("已在地图{0}中，请求重新加载（只重设位置，和重新添加对象）", data.mapID)
  self:ClearScene()
  local _MapManager = Game.MapManager
  if data.imageid and MirrorRaidConfig[data.imageid] then
    Game.DungeonManager:SetRaidID(data.imageid)
    _MapManager:SetImageID(data.imageid)
  end
  _MapManager:SetPreview(data.preview)
  _MapManager:Launch()
  local sceneInfo = SceneProxy.Instance.currentScene
  if sceneInfo then
    if sceneInfo.mapID ~= data.mapID then
      sceneInfo:SetData(data)
      _MapManager:SetMapIDs(data)
      _MapManager:UpdateCameraInstance()
    else
      sceneInfo.mapNameZH = data.mapName
      sceneInfo.imagescene = data.imagescene
    end
  end
  _MapManager:SetMapName(data)
  _MapManager:SetSceneID(data.sceneid)
  self:NotifyServerSceneLoaded(data.mapID, true)
  MyselfProxy.Instance:ResetMyPos(data.pos.x, data.pos.y, data.pos.z)
  Game.AreaTrigger_ExitPoint:Shutdown()
  Game.AreaTrigger_ExitPoint:SetInvisibleEPs(data.invisiblexit)
  Game.AreaTrigger_ExitPoint:Launch()
  GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
  EventManager.Me():PassEvent(LoadSceneEvent.FinishLoadScene, sceneInfo)
  GameFacade.Instance:sendNotification(MiniMapEvent.ExitPointReInit)
  HomeManager.Me():Launch()
end

function FunctionChangeScene:StartLoadScene()
  if SceneProxy.Instance:CanLoad() then
    self:CacheReceiveNet(true)
    FunctionBGMCmd.Me():ResetDefault()
    FunctionBGMCmd.Me():StopBgm(FunctionBGMCmd.BgmSort.Default)
    PlotAudioProxy.Instance:ResetAll()
    self:ClearScene(true)
    SceneProxy.Instance:StartLoadFirst()
    local data = SceneProxy.Instance.currentScene
    EventManager.Me():PassEvent(LoadSceneEvent.BeginLoadScene)
    Game.MapManager:SetCurrentMap(data.serverData, true)
    local sameScene = self.sceneProxy:IsCurrentScene(data)
    local currentSceneLoaded = self.sceneProxy.currentScene ~= nil and self.sceneProxy.currentScene.loaded or false
    self:SetRaidID(data.dungeonMapId, data.preview, Table_Map[data.mapID], sameScene and currentSceneLoaded)
    return true
  end
  return false
end

function FunctionChangeScene:WaitForLoad(data)
  LogUtility.InfoFormat("添加地图加载:{0} {1}", data.mapID, data.mapName)
  Buglylog("FunctionChangeScene:WaitForLoad:" .. data.mapID)
  if BackwardCompatibilityUtil.CompatibilityMode_V55 or GameConfig.BuglyOpen ~= 1 or not BranchMgr.IsChina() and BackwardCompatibilityUtil.CompatibilityMode_V57 then
  else
    BuglyManager.GetInstance():SetSceneId(data.mapID)
  end
  local _FunctionCheck = FunctionCheck.Me()
  _FunctionCheck:SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene, false)
  _FunctionCheck:SetSyncAngleY(FunctionCheck.CannotSyncMoveReason.LoadingScene, false)
  FunctionMapEnd.Me():Reset()
  SceneProxy.Instance:AddLoadingScene(data)
  if data.pos then
    MyselfProxy.Instance:ResetMyBornPos(data.pos.x, data.pos.y, data.pos.z)
  end
end

function FunctionChangeScene:ReplaceCurrentBgm(sceneName)
  local bgmPath = self:GetBgmName(sceneName)
  if bgmPath and bgmPath ~= "" then
    FunctionBGMCmd.Me():ReplaceCurrentBgm(bgmPath)
  end
end

function FunctionChangeScene:GetBgmName(sceneName)
  local mapBgmTable = Table_MapBgm
  sceneName = string.gsub(sceneName, "Scene", "")
  for _, mapInfo in pairs(mapBgmTable) do
    if mapInfo.NameEn == sceneName then
      return mapInfo.SceneBgm
    end
  end
  return ""
end

function FunctionChangeScene:LoadedScene(data)
  redlog("FunctionChangeScene LoadedScene")
  if data == nil then
    redlog("data cannot be nil.")
    return
  end
  Buglylog("FunctionChangeScene LoadedScene 场景加载完毕:" .. data.mapID)
  if self.clientLoadBlock then
    self.clientLoadFinished = true
    return
  end
  self.clientLoadFinished = nil
  LogUtility.InfoFormat("{0} {1} 场景加载完毕", data.mapID, data.mapName)
  local mapData = Table_Map[data.mapID]
  if mapData ~= nil then
    local mapNameEN = mapData.NameEn
    self:ReplaceCurrentBgm(mapNameEN)
  end
  self:TryPreLoadResources()
  local sceneQueue = SceneProxy.Instance:FinishLoadScene(data)
  self:EnterScene()
  if sceneQueue == nil or #sceneQueue == 0 then
    self:AllFinishLoad(data)
    if GameConfig.loadingFade and GameConfig.loadingFade[data.mapID] then
      local config = GameConfig.loadingFade[data.mapID]
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ScreenTransitView,
        viewdata = {
          inTime = 0.1,
          outTime = 0.5,
          time = config.time,
          color = config.color
        }
      })
    end
  else
    GameFacade.Instance:sendNotification(LoadingSceneView.ServerReceiveLoaded)
    self:StartLoadScene()
  end
  self:RunMapActivityBossAnime(data.mapID)
end

function FunctionChangeScene:EnterScene()
  SceneProxy.Instance:EnterScene()
  SceneProxy.Instance.sceneLoader:SetAllowSceneActivation()
end

function FunctionChangeScene:NotifyServerSceneLoaded(mapID, pauseIdleAI)
  if not self.blockCount then
    self.blockCount = 1
  else
    self.blockCount = self.blockCount + 1
  end
  redlog(string.format("==========客户端场景加载完毕，通知服务器.(MapID:%s)===========", tostring(mapID)))
  Buglylog("FunctionChangeScene:NotifyServerSceneLoaded mapid:" .. mapID)
  Game.Myself:Client_NoAttack(true)
  Game.Myself:Client_NoMove(true)
  FunctionSystem.InterruptMyself()
  ServicePlayerProxy.Instance:CallChangeMap("", 0, 0, 0, mapID)
  if pauseIdleAI then
    if not self.pauseIdleCount then
      self.pauseIdleCount = 1
    else
      self.pauseIdleCount = self.pauseIdleCount + 1
    end
    Game.Myself:Client_PauseIdleAI()
  end
end

function FunctionChangeScene:StartTickTMCR()
  self:StopTickTMCR()
  self.lastTMCTtime = ServerTime.CurServerTime()
  self.speedTimer = TimeTickManager.Me():CreateTick(0, 60000, function()
    self:TickTMCR()
  end, self, 999)
end

function FunctionChangeScene:TickTMCR()
  if not self.lastTMCTtime or not self.lastSceneID then
    return
  end
  local serverTime = ServerTime.CurServerTime()
  local deltaTime = (serverTime - self.lastTMCTtime) / 1000
  if 3600 < deltaTime then
    if ServiceUserEventProxy.Instance.initThemisTm then
      pcall(function()
        BuglyManager.GetInstance():TMCR(tostring(self.lastSceneID), false)
      end)
      pcall(function()
        BuglyManager.GetInstance():TMCR(tostring(self.lastSceneID), true)
      end)
    end
    self.lastTMCTtime = serverTime
  end
end

function FunctionChangeScene:SendTMCR()
  if self.lastSceneID then
    if ServiceUserEventProxy.Instance.initThemisTm then
      pcall(function()
        BuglyManager.GetInstance():TMCR(tostring(self.lastSceneID), false)
      end)
    end
    self.lastSceneID = nil
  end
end

function FunctionChangeScene:StopTickTMCR()
  self.lastTMCTtime = nil
  if self.speedTimer then
    TimeTickManager.Me():ClearTick(self, 999)
    self.speedTimer = nil
  end
end

local callonce

function FunctionChangeScene:RecvServerSceneLoaded(data)
  if self.lastSceneID then
    if ServiceUserEventProxy.Instance.initThemisTm then
      pcall(function()
        BuglyManager.GetInstance():TMCR(tostring(self.lastSceneID), false)
      end)
    end
    self.lastSceneID = nil
    self:StopTickTMCR()
  end
  if data and data.mapID and data.mapID ~= 0 then
    self.lastSceneID = data.mapID
    if ServiceUserEventProxy.Instance.initThemisTm then
      pcall(function()
        BuglyManager.GetInstance():TMCR(tostring(self.lastSceneID), true)
      end)
    end
    self:StartTickTMCR()
  end
  redlog("==========客户端场景加载完毕，收到服务器确认.===========")
  if self.blockCount then
    for i = 1, self.blockCount do
      Game.Myself:Client_NoAttack(false)
      Game.Myself:Client_NoMove(false)
    end
    GameFacade.Instance:sendNotification(SkillEvent.CheckSkillForbid)
  end
  self.blockCount = 0
  if self.pauseIdleCount then
    for i = 1, self.pauseIdleCount do
      Game.Myself:Client_ResumeIdleAI()
    end
  end
  self.pauseIdleCount = 0
  if not TeamProxy.Instance:IHaveTeam() and Game.MapManager:IsPVPMode() then
    ServiceSessionTeamProxy.Instance:CallAskForTeamInfoTeamCmd()
  end
  if callonce == nil then
    callonce = true
    if ApplicationInfo.IsRunOnWindowns() then
      local screenCountLevel = FunctionPerformanceSetting.Me():GetWindownsScreenCountLevel()
      ServiceLoginUserCmdProxy.Instance:CallSetMaxScopeUserCmd(screenCountLevel)
    end
  end
end

local needStaticCombine = false
local esVersion = string.match(SystemInfo.graphicsDeviceVersion, "OpenGL ES %d.%d")
if esVersion then
  local version = string.match(esVersion, "%d.%d")
  version = tonumber(version)
  needStaticCombine = version and version < 3.1 or false
end

function FunctionChangeScene:AllFinishLoad(sceneInfo)
  LogUtility.Info(string.format("send change map: %d", sceneInfo.mapID))
  LogUtility.Info(string.format("TotalFinishLoad raid: %s", tostring(sceneInfo.dmapID)))
  if nil ~= sceneInfo.dmapID and sceneInfo.dmapID > 0 then
    local rotationOffsetY = Table_MapRaid[sceneInfo.dmapID] and Table_MapRaid[sceneInfo.dmapID].CameraAdj
    LogUtility.Info(string.format("TotalFinishLoad rotationOffsetY: %s", tostring(rotationOffsetY)))
    if nil ~= rotationOffsetY and 0 ~= rotationOffsetY then
      local cameraController = CameraController.Instance
      if nil ~= cameraController then
        cameraController.cameraRotationEulerOffset = Vector3(0, rotationOffsetY, 0)
        cameraController:ApplyCurrentInfo()
      end
    end
  end
  if nil ~= sceneInfo.dmapID and sceneInfo.dmapID > 0 then
    local cameraController = CameraController.singletonInstance
    local resetFov = Table_MapRaid[sceneInfo.dmapID] and Table_MapRaid[sceneInfo.dmapID].DefaultFov
    if cameraController and resetFov then
      local defaultInfo = cameraController.defaultInfo
      defaultInfo.fieldOfView = resetFov
    end
  end
  local _FunctionCheck = FunctionCheck.Me()
  _FunctionCheck:SetSyncMove(FunctionCheck.CannotSyncMoveReason.LoadingScene, true)
  _FunctionCheck:SetSyncAngleY(FunctionCheck.CannotSyncMoveReason.LoadingScene, true)
  _FunctionCheck:SetSysMsg(nil)
  self:NotifyServerSceneLoaded(sceneInfo.mapID)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "MainView"})
  GameFacade.Instance:sendNotification(LoadSceneEvent.FinishLoad)
  FunctionDungen.Me():HandleSceneLoaded()
  FunctionMapEnd.Me():TempSetDurationToTimeLine()
  FunctionActivity.Me():UpdateNowMapTraceInfo()
  self:CacheReceiveNet(false)
  EventManager.Me():PassEvent(LoadSceneEvent.FinishLoadScene, sceneInfo)
  Game.MapManager:Launch()
  MyLuaSrv.ClearLuaMapAsset()
  if needStaticCombine then
    local isHome = GameConfig.Home.MapDatas[sceneInfo.mapID] ~= nil
    if not isHome then
      local go = GameObject.Find("static")
      if not Slua.IsNull(go) then
        local t1 = os.clock()
        StaticBatchingUtility.Combine(go)
        helplog("Static Batching Cost:", os.clock() - t1)
      end
    end
  end
  if self.syncTimeTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 1111)
    self.syncTimeTick = nil
  end
  self.syncCount = 0
  self.syncTimeTick = TimeTickManager.Me():CreateTick(1000, 10000, function()
    ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
    self.syncCount = self.syncCount + 1
    if self.syncCount >= 5 then
      TimeTickManager.Me():ClearTick(self, 1111)
      self.syncTimeTick = nil
    end
  end, self, 1111)
  if Game.Myself then
    Game.Myself:RefreshNightmareStatus()
  end
  if BranchMgr.IsKorea() then
    OverseaHostHelper:CheckFirstFirebaseCallServer()
  end
  AbyssLakeProxy.Instance:ClearExtraRewards()
end

function FunctionChangeScene:CacheReceiveNet(v)
  NetProtocol.CachingSomeReceives = v
  if not v then
    if NetConfig.IsOldNet == true then
      NetProtocol.CallCachedReceives()
    else
      NetProtocol.CallCachedReceives2()
    end
  end
end

function FunctionChangeScene:GC()
  ResourceManager.Instance:GC()
  ResourceManager.Instance:SetDelayedGC(5)
end

function FunctionChangeScene:ClearScene(loadOtherScene)
  if loadOtherScene then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles, {
      MyselfProxy.Instance.myself
    })
    FunctionCameraEffect.Me():Shutdown()
    FunctionCameraAdditiveEffect.Me():Shutdown()
    FunctionMapEnd.Me():BeginIgnoreAreaTrigger()
  end
  FunctionGuide.Me():tryStopGuide()
  SceneObjectProxy.ClearAll()
  Game.AssetManager:ClearAudioClips()
  Game.GOLuaPoolManager:ClearAllPools()
  GameObjPool.Instance:ClearAll()
  GvgProxy.Instance:ClearRuleGuildInfos()
end

function FunctionChangeScene:RunMapActivityBossAnime(mapId)
  if not mapId or mapId == 0 then
    return
  end
  local config = GameConfig.ActivitySceneBossAnime
  if config and config[mapId] then
    for k, v in pairs(config[mapId]) do
      local activityData = FunctionActivity.Me():GetActivityData(k)
      if activityData then
        for i = 1, #v do
          local animeId = v[i]
          xdlog("播放活动场景ScneBossAnime", animeId)
          if animeId and Table_SceneBossAnime[animeId] then
            local objId = Table_SceneBossAnime[animeId].ObjID
            local anim = Table_SceneBossAnime[animeId].Name
            Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:PlayAnimation(objId, anim)
          end
        end
      end
    end
  end
end

function FunctionChangeScene:SetSceneLoadFinishActionForOnce(action, param)
  self.sceneLoadFinishActionForOnce = action
  self.sceneLoadFinishActionForOnceParam = param
end

function FunctionChangeScene:TriggerSceneLoadFinishActionForOnce()
  if self.sceneLoadFinishActionForOnce then
    self.sceneLoadFinishActionForOnce(self.sceneLoadFinishActionForOnceParam)
    self.sceneLoadFinishActionForOnce = nil
    self.sceneLoadFinishActionForOnceParam = nil
  end
end

function FunctionChangeScene:UpdateGCStrategy()
  local mapManager = Game.MapManager
  if Game.ActiveTimingGC and mapManager then
    local isTimingGCEnabled = true
    if mapManager:IsPveMode_Arena() or mapManager:IsPVPMode_TeamPws() or mapManager:IsPvPMode_TeamTwelve() or mapManager:IsPVEMode_ComodoRaid() or mapManager:IsPVEMode_MultiBossRaid() or mapManager:IsPveMode_Thanatos() then
      isTimingGCEnabled = false
    end
    Game.ActiveTimingGC(isTimingGCEnabled)
  end
end
