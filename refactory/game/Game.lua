Game = class("Game")
Game.GameObjectType = {
  Camera = 1,
  Light = 2,
  RoomHideObject = 3,
  SceneObjectFinder = 4,
  SceneAnimation = 5,
  LocalNPC = 6,
  DynamicObject = 7,
  CullingObject = 8,
  SceneSeat = 9,
  ScenePhotoFrame = 10,
  SceneGuildFlag = 11,
  WeddingPhotoFrame = 12,
  MenuUnlockObj = 14,
  InteractNpc = 13,
  Furniture = 15,
  InteractCard = 16,
  SceneBossAnime = 17,
  RoomShowObject = 18,
  LockCameraForceRoomShow = 19,
  CameraFocusObj = 20,
  RaidPuzzle_Light = 21,
  Skybox = 22,
  AreaCP = 23,
  ShadowPuzzle = 24,
  StealthGame = 25,
  InsightGO = 26,
  TextMesh = 27,
  BehaviourTree = 28,
  ObjectFinder = 29,
  PhotoStand = 30,
  TrainEscortBoard = 31
}
Game.EState = {Running = 1, Finished = 2}
Game.ELayer = {
  Default = 0,
  TransparentFX = 1,
  IgnoreRaycast = 2,
  Water = 4,
  UI = 5,
  Terrain = 8,
  StaticObject = 9,
  DynamicObject = 10,
  Accessable = 11,
  SceneUI = 12,
  SceneUIBackground = 13,
  InVisible = 14,
  UIBackground = 15,
  PhotographPanel = 16,
  NavMeshDelegateDraw = 17,
  UIModel = 18,
  Barrage = 19,
  HomeBuildingCell_EditorOnly = 20,
  PPEffect = 21,
  Outline = 22,
  Cam_Filter = 27,
  HomeDefaultGround = 20,
  HomeGround = 21,
  HomeFurniture = 22,
  HomeOperate = 23,
  UIEffect = 23,
  HomeFurniture_BP = 24
}
autoImport("DataStructureManager")
autoImport("FunctionSystemManager")
autoImport("GUISystemManager")
autoImport("GCSystemManager")
autoImport("GOManager_Camera")
autoImport("GOManager_Light")
autoImport("GOManager_Room")
autoImport("GOManager_SceneObject")
autoImport("GOManager_LocalNPC")
autoImport("GOManager_DynamicObject")
autoImport("GOManager_CullingObject")
autoImport("GOManager_SceneSeat")
autoImport("GOManager_ScenePhotoFrame")
autoImport("GOManager_SceneGuildFlag")
autoImport("GOManager_WeddingPhotoFrame")
autoImport("GOManager_MenuUnlockObj")
autoImport("GOManager_InteractNpc")
autoImport("GOManager_Furniture")
autoImport("GOManager_InteractCard")
autoImport("GOManager_SceneBossAnime")
autoImport("GOManager_RoomShow")
autoImport("GOManager_LockCameraForceRoomShow")
autoImport("GOManager_CameraFocusObj")
autoImport("GOManager_RaidPuzzleLight")
autoImport("GOManager_Skybox")
autoImport("GOManager_AreaCP")
autoImport("GOManager_ShadowPuzzle")
autoImport("GOManager_InsightGO")
autoImport("GOManager_StealthGame")
autoImport("GOManager_TextMesh")
autoImport("GOManager_BehaviourTree")
autoImport("GOManager_ObjectFinder")
autoImport("GOManager_PhotoStand")
autoImport("GOManager_TrainEscortBoard")
autoImport("BTInclude")
autoImport("HotUpdateMgr")
autoImport("PreprocessHelper")
autoImport("Preprocess_Table")
autoImport("Preprocess_SceneInfo")
autoImport("Preprocess_EnviromentInfo")
autoImport("Game_Interface_ForCSharp")
autoImport("BranchMgr")
autoImport("OverSeaFunc")
autoImport("AudioDefines")
autoImport("PerformanceManager")
local ResolutionPool = {
  1836.0,
  1224.0,
  918.0,
  720,
  540
}
local ResolutionPool_Standalone = {
  2160,
  1440,
  1080,
  720,
  540
}
local ResolutionPool_Width = {
  3840,
  2560,
  1920,
  1280,
  960
}
local ResolutionTextPool = {
  "4K(3840*2160)",
  "2K(2560*1440)",
  "1080P(1920*1080)",
  "720P(1280*720)",
  "540P(960*540)"
}
local ResolutionGap = 50
local fullScreenRatio = 1.7777777777777777
Game.SwitchRoleScene = "SwitchRoleLoader"
Game.Param_SwitchRole = "Param_SwitchRole"

function Game.Me(param)
  if nil == Game.me then
    Game.me = Game.new(param)
  end
  return Game.me
end

function Game.GetResolutionNames()
  return Game.ScreenResolutionTexts
end

function Game.SetResolution(index)
  if nil == Game.ScreenResolutionHeight or #Game.ScreenResolutionHeight <= 0 then
    return
  end
  index = RandomUtil.Clamp(index, 1, #Game.ScreenResolutionHeight)
  if index < 1 then
    index = 1
  end
  local screenHeight = Game.ScreenResolutionHeight[index]
  if ApplicationInfo.IsRunOnWindowns() then
    if index == 1 then
      local fullScreenWidth, fullScreenHeight = Game.GetFullScreenResolution()
      Game.ScreenResolutionHeight[1] = fullScreenHeight
      Game.ScreenResolutionWidth[1] = fullScreenWidth
      screenHeight = fullScreenHeight
    end
    local p = {}
    p.renderScale = 0.75 + 0.05 * ROSystemInfo.DeviceRate
    local scaleHeight = screenHeight * p.renderScale
    if 1080 < scaleHeight then
      p.renderScale = 1080 / screenHeight
    elseif scaleHeight < 720 then
      p.renderScale = 720 / screenHeight
    end
    Game.PerformanceManager:SetURPAssetParam(p)
    local width = Game.ScreenResolutionWidth[index]
    local height = math.floor(screenHeight)
    local fullScreen = index == 1
    Screen.SetResolution(width, height, fullScreen)
    if not ApplicationInfo.IsRunOnEditor() then
      Game.AspectRatioController:SetAspectRatio(width, height)
    end
  else
    local p = {}
    p.renderScale = 0.75 + 0.05 * ROSystemInfo.DeviceRate
    local scaleHeight = screenHeight * p.renderScale
    if 1080 < scaleHeight then
      p.renderScale = 1080 / screenHeight
    elseif scaleHeight < 720 then
      if screenHeight < LuaLuancher.originalScreenHeight then
        p.renderScale = 540 / LuaLuancher.originalScreenHeight
      else
        p.renderScale = 720 / screenHeight
      end
    end
    Game.PerformanceManager:SetURPAssetParam(p)
  end
end

function Game.GetFullScreenResolution()
  local currentResolution = Screen.currentResolution
  local ratio = currentResolution.width / currentResolution.height
  local fullScreenWidth, fullScreenHeight
  if ratio > fullScreenRatio then
    fullScreenWidth = math.floor(currentResolution.height * fullScreenRatio)
    fullScreenHeight = currentResolution.height
  else
    fullScreenWidth = currentResolution.width
    fullScreenHeight = math.floor(fullScreenWidth / fullScreenRatio)
  end
  return fullScreenWidth, fullScreenHeight
end

function Game.InitAppIsInReview()
  local inAppStoreReview = false
  local verStr = VersionUpdateManager.serverResJsonString
  helplog(verStr)
  if verStr ~= nil and verStr ~= "" then
    local result = StringUtil.Json2Lua(verStr)
    if result and result.data then
      local data = result.data
      local res = data.inAppStoreReview
      if res then
        if type(res) == "string" then
          if res == "true" then
            inAppStoreReview = true
          end
        elseif type(res) == "boolean" then
          inAppStoreReview = res
        end
      end
    end
  end
  Game.inAppStoreReview = inAppStoreReview
end

local MaxScreenHeight = 918

function Game:InitResolutions()
  local screenWidth = LuaLuancher.originalScreenWidth
  local screenHeight = LuaLuancher.originalScreenHeight
  local screenPct = screenWidth / screenHeight
  if not ApplicationInfo.IsEmulator() and (not ApplicationInfo.IsRunOnEditor() or not ApplicationInfo.IsRunOnWindowns()) and screenHeight > MaxScreenHeight then
    screenHeight = math.max(MaxScreenHeight, screenHeight * 0.85)
    screenWidth = screenHeight * screenPct
  end
  local _ResolutionPool = ResolutionPool
  if ApplicationInfo.IsRunOnWindowns() then
    _ResolutionPool = ResolutionPool_Standalone
  end
  Game.ScreenResolutionHeight = {}
  Game.ScreenResolutionTexts = {}
  Game.ScreenResolutionWidth = {}
  local currentResolution = Screen.currentResolution
  if ApplicationInfo.IsRunOnWindowns() then
    local fullScreenWidth, fullScreenHeight = Game.GetFullScreenResolution()
    Game.ScreenResolutionHeight[1] = fullScreenHeight
    Game.ScreenResolutionTexts[1] = ZhString.Game_FullScreen
    Game.ScreenResolutionWidth[1] = fullScreenWidth
  end
  for i = 1, #_ResolutionPool do
    if _ResolutionPool[i] + ResolutionGap < currentResolution.height then
      TableUtility.ArrayPushBack(Game.ScreenResolutionHeight, _ResolutionPool[i])
      TableUtility.ArrayPushBack(Game.ScreenResolutionTexts, ResolutionTextPool[i])
      TableUtility.ArrayPushBack(Game.ScreenResolutionWidth, ResolutionPool_Width[i])
    end
  end
  if ApplicationInfo.IsRunOnWindowns() and not AspectRatioController.ResolutionInited then
    local resolutionIndex = PlayerPrefs.GetInt(LocalSaveProxy.SAVE_KEY.WindowsResolution, 1)
    resolutionIndex = math.min(resolutionIndex, #Game.ScreenResolutionWidth)
    local width = Game.ScreenResolutionWidth[resolutionIndex]
    local height = math.floor(Game.ScreenResolutionHeight[resolutionIndex])
    local fullScreen = resolutionIndex == 1
    Screen.SetResolution(width, height, fullScreen)
    if not ApplicationInfo.IsRunOnEditor() then
      AspectRatioController.Instance:SetAspectRatio(width, height)
    end
    AspectRatioController.ResolutionInited = true
  end
end

function Game:PrepareCompitibleVideoPlayer()
  if BackwardCompatibilityUtil.CompatibilityModeExceptEditor(91) then
    local root = table.concat({
      ApplicationHelper.persistentDataPath,
      "/",
      ApplicationHelper.platformFolder,
      "/",
      "resources/gui/v1/"
    })
    local path = root .. "cell/newrechargeherocell_old.unity3d"
    local newpath = root .. "cell/newrechargeherocell.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
    path = root .. "part/startgamebgvideoplayer_old.unity3d"
    newpath = root .. "part/startgamebgvideoplayer.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
    path = root .. "prefab/plot/plotstoryedvideoplayer_old.unity3d"
    newpath = root .. "prefab/plot/plotstoryedvideoplayer.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
    path = root .. "view/rewardeffectview_old.unity3d"
    newpath = root .. "view/rewardeffectview.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
    path = root .. "view/videopanel_old.unity3d"
    newpath = root .. "view/videopanel.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
    path = root .. "view/videopreview_old.unity3d"
    newpath = root .. "view/videopreview.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
    path = root .. "view/videoplayer_old.unity3d"
    newpath = root .. "view/videoplayer.unity3d"
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(newpath)
      FileHelper.MoveFile(path, newpath)
    end
  end
end

function Game:ctor(param)
  Buglylog("Game:ctor")
  self:XDELogin()
  Game.State = Game.EState.Running
  Game.FrameCount = 0
  self:InitResolutions()
  if BranchMgr.IsChina() then
    if EnvChannel.IsReleaseBranch() then
      OverSea.LangManager.Instance():SetCurLang("ChineseSimplified")
    else
      local lastSetLang = PlayerPrefs.GetString("lastSetLang")
      if lastSetLang == "" then
        OverSea.LangManager.Instance():SetCurLang("ChineseSimplified")
      else
        OverSea.LangManager.Instance():SetCurLang(lastSetLang)
      end
      if EnvChannel.IsStudioBranch() or EnvChannel.IsTrunkBranch() then
        OverSea.LangManager.Instance():SetCurLang("ChineseSimplified")
      end
    end
  end
  LogUtility.SetEnable(ROLogger.enable)
  LogUtility.SetTraceEnable(ROLogger.enable)
  local luaLuancher = LuaLuancher.Instance
  self.prefabs = luaLuancher.prefabs
  self.objects = luaLuancher.objects
  ApplicationInfo.SetTargetFrameRate(30)
  Time.fixedDeltaTime = 0.02
  Time.maximumDeltaTime = 0.3333
  UnityEngine.Screen.sleepTimeout = -1
  LeanTween.init(1000)
  Game.InitAppIsInReview()
  if ApplicationInfo.IsRunOnWindowns() then
    Game.InputKey = InputKey and InputKey.Instance
    Game.WindowSetting = WindowSetting and WindowSetting.Instance
    Game.AspectRatioController = AspectRatioController and AspectRatioController.Instance
  end
  self.dataStructureManager = DataStructureManager.new()
  self.functionSystemManager = FunctionSystemManager.new()
  self.guiSystemManager = GUISystemManager.new()
  self.gcSystemManager = GCSystemManager.new()
  Game.AssetLoadEventDispatcher = AssetLoadEventDispatcher.new()
  local gameObjectManagers = {}
  gameObjectManagers[Game.GameObjectType.Camera] = GOManager_Camera.new()
  gameObjectManagers[Game.GameObjectType.Light] = GOManager_Light.new()
  gameObjectManagers[Game.GameObjectType.RoomHideObject] = GOManager_Room.new()
  local sceneObjectManager = GOManager_SceneObject.new()
  gameObjectManagers[Game.GameObjectType.SceneObjectFinder] = sceneObjectManager
  gameObjectManagers[Game.GameObjectType.SceneAnimation] = sceneObjectManager
  gameObjectManagers[Game.GameObjectType.LocalNPC] = GOManager_LocalNPC.new()
  gameObjectManagers[Game.GameObjectType.DynamicObject] = GOManager_DynamicObject.new()
  gameObjectManagers[Game.GameObjectType.CullingObject] = GOManager_CullingObject.new()
  gameObjectManagers[Game.GameObjectType.SceneSeat] = GOManager_SceneSeat.new()
  gameObjectManagers[Game.GameObjectType.ScenePhotoFrame] = GOManager_ScenePhotoFrame.new()
  gameObjectManagers[Game.GameObjectType.SceneGuildFlag] = GOManager_SceneGuildFlag.new()
  gameObjectManagers[Game.GameObjectType.WeddingPhotoFrame] = GOManager_WeddingPhotoFrame.new()
  gameObjectManagers[Game.GameObjectType.MenuUnlockObj] = GOManager_MenuUnlockObj.new()
  gameObjectManagers[Game.GameObjectType.InteractNpc] = GOManager_InteractNpc.new()
  gameObjectManagers[Game.GameObjectType.Furniture] = GOManager_Furniture.new()
  gameObjectManagers[Game.GameObjectType.InteractCard] = GOManager_InteractCard.new()
  gameObjectManagers[Game.GameObjectType.SceneBossAnime] = GOManager_SceneBossAnime.new()
  gameObjectManagers[Game.GameObjectType.RoomShowObject] = GOManager_RoomShow.new()
  gameObjectManagers[Game.GameObjectType.LockCameraForceRoomShow] = GOManager_LockCameraForceRoomShow.new()
  gameObjectManagers[Game.GameObjectType.CameraFocusObj] = GOManager_CameraFocusObj.new()
  gameObjectManagers[Game.GameObjectType.RaidPuzzle_Light] = GOManager_RaidPuzzleLight.new()
  gameObjectManagers[Game.GameObjectType.Skybox] = GOManager_Skybox.new()
  gameObjectManagers[Game.GameObjectType.AreaCP] = GOManager_AreaCP.new()
  gameObjectManagers[Game.GameObjectType.ShadowPuzzle] = GOManager_ShadowPuzzle.new()
  gameObjectManagers[Game.GameObjectType.InsightGO] = GOManager_InsightGO.new()
  gameObjectManagers[Game.GameObjectType.StealthGame] = GOManager_StealthGame.new()
  gameObjectManagers[Game.GameObjectType.TextMesh] = GOManager_TextMesh.new()
  gameObjectManagers[Game.GameObjectType.BehaviourTree] = GOManager_BehaviourTree.new()
  gameObjectManagers[Game.GameObjectType.ObjectFinder] = GOManager_ObjectFinder.new()
  gameObjectManagers[Game.GameObjectType.PhotoStand] = GOManager_PhotoStand.new()
  gameObjectManagers[Game.GameObjectType.TrainEscortBoard] = GOManager_TrainEscortBoard.new()
  self.gameObjectManagers = gameObjectManagers
  Game.Instance = self
  Game.Prefab_RoleComplete = self.prefabs[1]:GetComponent(RoleComplete)
  Game.Prefab_SceneSeat = self.prefabs[2]:GetComponent(LuaGameObjectClickable)
  Game.Prefab_ScenePhoto = self.prefabs[3]:GetComponent(Renderer)
  Game.Prefab_SceneGuildIcon = self.prefabs[4]:GetComponent(Renderer)
  Game.Object_Rect = self.objects[1]
  Game.Object_GameObjectMap = self.objects[2]
  local audioCtrl = self.objects[3]
  if not audioCtrl.gameObject:GetComponent(AudioController) then
    audioCtrl.gameObject:AddComponent(AudioController)
  end
  Game.Object_AudioSource2D = audioCtrl.gameObject:GetComponent(AudioController)
  Game.ShaderManager = ShaderManager.Instance
  Game.RoleFollowManager = RoleFollowManager.Instance
  Game.TransformFollowManager = TransformFollowManager.Instance
  Game.InputManager = InputManager.Instance
  Game.CameraPointManager = CameraPointManager.Instance
  Game.BusManager = BusManager.Instance
  Game.Map2DManager = Map2DManager.Instance
  Game.ResourceManager = ResourceManager.Instance
  Game.MapCellManager = MapCellManager.Instance
  Game.GameObjectUtil = GameObjectUtil.Instance
  Game.EffectHandleManager = EffectHandleManager.Instance
  Game.GetLocalPositionGO = LuaGameObject.GetLocalPositionGO
  Game.SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
  Game.GetLocalScaleGO = LuaGameObject.GetLocalScaleGO
  Game.SetLocalScaleGO = LuaGameObject.SetLocalScaleGO
  Game.GetLocalRotationGO = LuaGameObject.GetLocalRotationGO
  Game.SetLocalRotationGO = LuaGameObject.SetLocalRotationGO
  Game.SetLocalPositionObj = LuaGameObject.SetLocalPositionObj
  Game.SetLocalScaleObj = LuaGameObject.SetLocalScaleObj
  Game.SetLocalRotationObj = LuaGameObject.SetLocalRotationObj
  Game.NetConnectionManager = NetConnectionManager.Instance
  Game.NetConnectionManager.EnableLog = false
  Game.InternetUtil = InternetUtil.Ins
  Game.HttpWWWRequest = HttpWWWRequest.Instance
  Game.FarmlandManager = FarmlandManager.Ins
  Game.GameObjectManagers = self.gameObjectManagers
  Game.DataStructureManager = self.dataStructureManager
  Game.FunctionSystemManager = self.functionSystemManager
  Game.GUISystemManager = self.guiSystemManager
  Game.GCSystemManager = self.gcSystemManager
  Game.PerformanceManager = PerformanceManager.new()
  Game.AssetManager_Role:PreloadComplete(200)
  Game.AssetManager_Role:PreloadAnimationAssets()
  NetConnectionManager.Instance:Restart()
  GameFacade.Instance:registerCommand(StartEvent.StartUp, StartUpCommand)
  GameFacade.Instance:sendNotification(StartEvent.StartUp)
  AppStorePurchase.Ins():AddListener()
  if param == nil then
    self:PrepareCompitibleVideoPlayer()
    Game.OpenScene_CharacterChoose(function()
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "StartGamePanel"
      })
    end)
  elseif Game.Param_SwitchRole == param then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "SwitchRolePanel"
    })
  end
  DiskFileHandler.Ins():EnterRoot()
  DiskFileHandler.Ins():EnterExtension()
  DiskFileHandler.Ins():EnterPublicPicRoot()
  DiskFileHandler.Ins():EnterActivityPicture()
  DiskFileHandler.Ins():EnterLotteryPicture()
  FunctionsCallerInMainThread.Ins:Call(nil)
  CloudFile.CloudFileManager.Ins:Open()
  Game.MapManager:SetInputDisable(true)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  Game.PerformanceManager:LODHigh()
  Game.PerformanceManager:SetSRPBatch(SystemInfo.graphicsMultiThreaded)
  if not BackwardCompatibilityUtil.CompatibilityMode(50) then
    local str = SystemInfo.processorType
    if type(str) == "string" and str:lower():find("armv7") then
      ResourceManager.Instance.GCDeltatime = 60
    end
  end
  Game.ActiveTimingGC(true)
  if GameConfig.SystemForbid.Joystick2_0 then
    InputJoystickProcesser.UseVersion2 = false
  end
  if not BranchMgr.IsSEA() then
    Game.Adjust_OS_FontSize()
  end
  if SystemInfo.npotSupport == 0 then
    FunctionTyrantdb.Instance:trackEvent("#npot_None", nil)
  end
  if SystemInfo.npotSupport == 1 then
    FunctionTyrantdb.Instance:trackEvent("#npot_Restricted", nil)
  end
end

function Game.OpenScene_CharacterChoose(call)
  SceneProxy.Instance:SyncLoad("CharacterChoose", function()
    local bgmName
    local mapBgmTable = Table_MapBgm
    local sceneName = string.gsub("CharacterChoose", "Scene", "")
    for _, mapInfo in pairs(mapBgmTable) do
      if mapInfo.NameEn == sceneName then
        bgmName = mapInfo.SceneBgm
        break
      end
    end
    if bgmName then
      FunctionBGMCmd.Me():ReplaceCurrentBgm(bgmName)
    end
    if call then
      call()
    end
  end)
end

function Game.Adjust_OS_FontSize()
  if BranchMgr.IsJapan() then
    UILabel.FontSizeOffset = -3
    return
  end
  if not BranchMgr.IsChina() then
  end
end

function Game.ActiveTimingGC(b)
  if b then
    local oriLst = ResourceManager.Instance.GCDeltaTimes
    oriLst:Clear()
    local memSize = math.ceil(SystemInfo.systemMemorySize / 1024)
    oriLst:Add(math.max(1200, 300 * memSize))
    oriLst:Add(0.5)
    oriLst:Add(1)
    oriLst:Add(1)
  else
    local oriLst = ResourceManager.Instance.GCDeltaTimes
    oriLst:Clear()
    oriLst:Add(59940)
  end
end

function Game:End(toScene, keepResManager)
  DynamicSceneBottomUIPool.Me():clear()
  Game.InputManager:Interrupt()
  local list = LuaUtils.CreateStringList()
  if ApplicationInfo.IsRunOnEditor() then
  else
    ROPush.SetTags(os.time(), list)
  end
  FunctionCameraEffect.Me():SaveCameraInfoToLocal()
  HomeManager.Me():Shutdown()
  MountLotteryProxy.Instance:Reset()
  Game.PlotStoryManager:Clear()
  Game.PlotStoryManager:ClearMyTempEffect()
  Game.QuestMiniMapEffectManager:Shutdown()
  Game.AreaTriggerManager:Shutdown()
  toScene = toScene or "Launch"
  Buglylog("Game:end toScene:" .. toScene)
  Game.State = Game.EState.Finished
  Game.isSecurityDevice = false
  FunctionCloudFile.Me():Clear()
  local netError = FunctionNetError.Me()
  netError:DisConnect()
  NetManager.GameClose()
  UpYunNetIngFileTaskManager.Ins:Close()
  CloudFile.CloudFileManager.Ins:Close()
  DiskFileManager.Instance:Reset()
  FrameRateSpeedUpChecker.Instance():Close()
  AppStorePurchase.Ins():ClearCallbackAppStorePurchase()
  netError:Clear()
  if Game.Myself then
    Game.Myself:Destroy()
    Game.Myself = nil
  end
  UIModelUtil.Instance:Reset()
  UIMultiModelUtil.Instance:Reset()
  FunctionAppStateMonitor.Me():Reset()
  HttpWWWRequest.Instance:Clear()
  local independentTestGo = GameObject.Find("IndependentTest (delete)")
  if independentTestGo ~= nil then
    GameObject.Destroy(independentTestGo)
  end
  FunctionPreload.Me():Reset()
  local shaderManager = GameObject.Find("ShaderManager(Clone)")
  if shaderManager then
    GameObject.Destroy(shaderManager)
  end
  local ImageCrop = GameObject.Find("ImageCrop")
  if ImageCrop then
    GameObject.Destroy(ImageCrop)
  end
  local gmeMgr = GameObject.Find("GME(Clone)")
  if gmeMgr ~= nil then
    GameObject.DestroyImmediate(gmeMgr)
    gmeMgr = nil
  end
  if toScene == "Launch" then
    HotUpdateMgr.Shutdown(true)
  end
  UIManagerProxy.Instance:Clear()
  FunctionBGMCmd.Me():Destroy()
  if LuaLuancher.Instance then
    GameObject.DestroyImmediate(LuaLuancher.Instance.monoGameObject)
  end
  ModelEpPointRefs.Clear()
  EffectHandleManager.Instance:ClearCheckList()
  LeanTween.CancelAll()
  TimeTickManager.Me():Clear()
  FunctionGetIpStrategy.Me():GameEnd()
  FunctionServerForbidTable.Me():TryRestore()
  SceneUtil.SyncLoad(toScene)
  PlotAudioProxy.Instance:ResetAll()
  SceneUIManager.Instance:Destroy()
  if not keepResManager then
    ResourceManager.Instance.IsAsyncLoadOn = false
  end
  redlog("ResourceManager.Instance.IsAsyncLoadOn =======1======= " .. tostring(ResourceManager.Instance.IsAsyncLoadOn))
  if SkillProxy and SkillProxy.Instance then
    SkillProxy.Instance:ClearSkillLeftCDMap()
  end
  Game.GameHealthProtector:GameEnd()
  FunctionLogin.Me():ClearLoginOutListen()
  Game.AssetLoadEventDispatcher:Destroy()
end

function Game:BackToSwitchRole()
  if CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil then
    CameraController.Instance.monoGameObject:SetActive(false)
  end
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  if ApplicationHelper.AssetBundleLoadMode then
    ResourceManager.Instance:SAsyncLoadScene(Game.SwitchRoleScene, function()
      self:End(Game.SwitchRoleScene, true)
    end)
  else
    self:End(Game.SwitchRoleScene, true)
  end
end

function Game:BackToLogo(toScene)
  FunctionChangeScene.Me():SendTMCR()
  if CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil then
    CameraController.Instance.monoGameObject:SetActive(false)
  end
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  self:End(toScene)
end

NoTransString = {}
OverseasConfig = {}
OverseasConfig.EquipParts = {}
OverseasConfig.IsPlayerInGuild = false
OverseasConfig.LastEnterAreaTime = 0
OverseasConfig.EnterAreaCD = 20

function clone(object)
  local lookup_table = {}
  
  local function copyObj(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for key, value in pairs(object) do
      new_table[copyObj(key)] = copyObj(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  
  return copyObj(object)
end

function Game:XDELogin()
  OverseasConfig.Award_EN = "Areward"
  OverseasConfig.OriginTeamName = GameConfig.Team and GameConfig.Team.teamname or "_的队伍"
  orginStringFormat = string.format
  if BranchMgr.IsChina() then
    return
  end
  if BranchMgr.IsJapan() then
    ZhString.Lottery_DetailRate = ZhString.Lottery_DetailRate_Japan
    ZhString.Lottery_RateTip = ZhString.Lottery_RateTip_Japan
    ZhString.QuotaCard_Desc = ZhString.QuotaCard_Desc_JP
    ZhString.NpcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
  elseif BranchMgr.IsTW() then
    ZhString.Oversea_Hard_Code_Client_1 = ZhString.Oversea_Hard_Code_Client_1_TW
    ZhString.Oversea_Hard_Code_Client_2 = ZhString.Oversea_Hard_Code_Client_2_TW
    ZhString.Oversea_Hard_Code_Client_3 = ZhString.Oversea_Hard_Code_Client_3_TW
    ZhString.Oversea_Hard_Code_Client_4 = ZhString.Oversea_Hard_Code_Client_4_TW
  elseif BranchMgr.IsNA() then
    ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1
    ZhString.Lottery_RateUrl = ZhString.Lottery_RateUrl_Na
  elseif BranchMgr.IsEU() then
    ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1
  elseif BranchMgr.IsSEA() then
    if BackwardCompatibilityUtil.CompatibilityMode_V65 then
      NGUIText.RemoveIgnoreEasternRange(3584)
    end
    ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1
  elseif BranchMgr.IsKorea() then
    ZhString.StartGamePanel_CopyRightTips = ZhString.StartGamePanel_CopyRightTips_KR
    ZhString.Lottery_DetailRate = ZhString.Lottery_DetailRate_KR
    ZhString.Lottery_RateTip = ZhString.Lottery_RateTip_KR
    ZhString.Lottery_MixLotteryRate = ZhString.Lottery_MixLotteryRate_KR
    ZhString.CardLottery_ExtraRate = ZhString.CardLottery_ExtraRate_KR
  end
  OverseasConfig.EquipParts = clone(GameConfig.EquipParts)
  NoTransString.FunctionDialogEvent_Replace = ZhString.FunctionDialogEvent_Replace
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() or BranchMgr.IsVN() then
    local lastSetLang = PlayerPrefs.GetString("lastSetLang")
    if lastSetLang == "" then
      lastSetLang = AppBundleConfig.GetLangString(tostring(Application.systemLanguage))
      helplog("使用了非法的语言，当前没有设置过语言，lua层尝试再设置一次系统语言", lastSetLang)
      OverSea.LangManager.Instance():SetCurLang(lastSetLang)
      OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang_TDSG())
    elseif lastSetLang ~= "English" and OverSea.LangManager.Instance().CurSysLang == "English" then
      helplog("使用了非法的语言，本地已经设置过语言，lua层尝试再设置一次", lastSetLang)
      OverSea.LangManager.Instance():SetCurLang(lastSetLang)
      OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang_TDSG())
    end
    if OverSea.LangManager.Instance().CurSysLang == "French" or OverSea.LangManager.Instance().CurSysLang == "Turkish" then
      OverSea.LangManager.Instance():SetCurLang("English")
      OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang_TDSG())
    end
    OverSea.LangManager.Instance():InitLangConfig()
  end
  
  function string.format(format, ...)
    local arg = {}
    for i = 1, select("#", ...) do
      local p = select(i, ...)
      local langP = OverSea.LangManager.Instance():GetLangByKey(p)
      table.insert(arg, langP)
    end
    return orginStringFormat(OverSea.LangManager.Instance():GetLangByKey(format), unpack(arg))
  end
  
  OverSea.LangManager.Instance():InitAtlass()
  Game.TrackTable()
  ZhString.MultiProfession_SaveName = ZhString.MultiProfession_SaveName:gsub(" ", "_")
  local keys = {"Text"}
  for _, v in pairs(Table_Sysmsg) do
    for __, key in pairs(keys) do
      v[key] = v[key]:gsub("Item", "item")
    end
  end
  if BranchMgr.IsTW() and ObscenceLanguage.NameExclude == nil then
    XDLog("Error", "ObscenceLanguage.NameExclude 不存在")
    ObscenceLanguage.NameExclude = {
      " ",
      "%%",
      "-",
      "/",
      "*",
      "#",
      ",",
      ":",
      ";",
      ".",
      "。",
      "(",
      ")",
      "&",
      "$",
      "\"",
      "'",
      "!",
      "@",
      "|",
      "\n"
    }
  end
  for k, v in pairs(GameConfig.AdventureUnlockCodition) do
    GameConfig.AdventureUnlockCodition[k] = v:gsub(" $", "")
  end
  if OverSea.LangManager.Instance().CurSysLang == "Thai" then
    GameConfig.ActivityCountDown[28] = {
      effectPath = "HappyNewYear_time",
      finalEffectPath = "HappyNewYear_2"
    }
  end
end

function Game.TrackTable()
  Game.track(Table_Map, {"NameZh", "CallZh"})
  Game.track(Table_Sysmsg, {"Text"})
  Game.track(Table_ItemType, {"Name"})
  Game.track(Table_NpcFunction, {"NameZh"})
  Game.track(Table_Class, {
    "NameZh",
    "NameZhFemale"
  })
  Game.track(Table_WantedQuest, {"Target"})
  Game.track(Table_AdventureAppend, {"Desc"})
  Game.track(Table_MCharacteristic, {"NameZh", "Desc"})
  Game.track(Table_Appellation, {"Name"})
  Game.track(Table_RoleData, {"PropName", "RuneName"})
  Game.track(Table_Viewspot, {"SpotName"})
  Game.track(Table_EquipSuit, {"EffectDesc"})
  Game.track(Table_ChatEmoji, {"Emoji"})
  Game.track(Table_RuneSpecial, {"RuneName"})
  Game.track(Table_Guild_Faith, {"Name"})
  Game.track(Table_Recipe, {"Name"})
  Game.track(Table_ItemTypeAdventureLog, {"Name"})
  Game.track(Table_ActivityStepShow, {"Trace_Text"})
  Game.track(Table_GuildBuilding, {
    "FuncDesc",
    "LevelUpPreview",
    "TraceTitle",
    "Traceinfo"
  })
  Game.track(Table_ItemAdvManual, {"LockDesc"})
  Game.track(Table_Menu, {"text", "Tip"})
  Game.track(Table_Guild_Treasure, {"Desc"})
  Game.track(Table_QuestVersion, {
    "VersionStory"
  })
  Game.track(Table_Growth, {"desc"})
  Game.track(Table_ServantImproveGroup, {"desc", "maintitle"})
  Game.track(Table_ServantUnlockFunction, {"desc"})
  Game.track(Table_MercenaryCat, {"Job"})
  Game.track(Table_HomeFurniture, {"NameZh"})
  Game.track(Table_HomeFurnitureMaterial, {"NameZh"})
  autoImport("Table_HomeOfficialBluePrint")
  Game.track(Table_HomeOfficialBluePrint, {"RewardTip", "Desc"})
  Game.track(Table_GemEffect, {"Desc"})
  Game.track(Table_GemUpgrade, {"Dsc"})
  Game.track(Table_Exchange, {"NameZh"})
  Game.track(Table_Help, {"Desc"})
  Game.track(Table_AddWay, {"NameEn", "Desc"})
  Game.track(Table_TeamGoals, {
    "NameZh",
    "RootRaidDesc"
  })
  autoImport("DialogEventConfig")
  Game.track(EventDialog, {"DialogText"})
  Game.track(Table_AssetEffect, {"Desc"})
  Game.track(Table_Equip_recommend, {"genre"})
  Game.track(Table_DepositCountReward, {"Des", "Des2"})
  Game.track(Table_EquipExtraction, {"Dsc"})
  Game.track(Table_BuffReward, {"Name", "Desc"})
  Game.transTable(Table_RedPacket)
  Game.transTable(GameConfig)
  Game.transTable(ZhString)
  StrTablesManager.DoInitTranslate()
end

function Game.DontTrack()
  local dontrack = BranchMgr.IsChina() and string.find(OverSea.LangManager.Instance().CurSysLang, "Chinese")
  return dontrack
end

function Game.track2(t, keys)
  if Game.DontTrack() then
    return
  end
  for __, key in pairs(keys) do
    if t[key] == nil then
      t[key] = ""
    end
    t[key] = OverSea.LangManager.Instance():GetLangByKey(t[key])
  end
end

function Game.track3(t, keys)
  if Game.DontTrack() then
    return
  end
  for __, key in pairs(keys) do
    if t[key] ~= nil then
      t[key] = OverSea.LangManager.Instance():GetLangByKey(t[key])
    end
  end
end

function Game.track(t, keys)
  if Game.DontTrack() then
    return
  end
  if not t then
    LogUtility.Error("表不存在！！请检查修复后再运行游戏")
    return
  end
  for _, v in pairs(t) do
    for __, key in pairs(keys) do
      if v[key] == nil then
        v[key] = ""
      end
      v[key] = OverSea.LangManager.Instance():GetLangByKey(v[key])
    end
  end
end

function Game.transTable(tbl)
  if Game.DontTrack() then
    return
  end
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      tbl[k] = OverSea.LangManager.Instance():GetLangByKey(v)
    elseif type(v) == "table" then
      Game.transTable(v)
    end
  end
end

function Game.transArray(arr)
  if Game.DontTrack() then
    return
  end
  if not arr then
    return
  end
  for i = 1, #arr do
    arr[i] = OverSea.LangManager.Instance():GetLangByKey(arr[i])
  end
end

local candidates = {
  "找不到目标地图",
  "_的队伍",
  "的房间"
}

function Game.simpleReplace(origin)
  if Game.DontTrack() then
    return origin
  end
  local ret = origin
  for _, candidate in ipairs(candidates) do
    local translated = OverSea.LangManager.Instance():GetLangByKey(candidate)
    ret = string.gsub(ret, candidate, translated)
  end
  return ret
end

function Game.convert2OffLbl(lbl)
  local tmp = lbl.text
  local hasPct = tmp:find("%%")
  tmp = tmp:gsub("%%", "")
  tmp = tonumber(tmp)
  lbl.text = 100 - tmp
  if hasPct then
    lbl.text = lbl.text .. "%"
  end
end

function Game.DestroyDebugRoot()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if not (runtimePlatform == RuntimePlatform.IPhonePlayer and EnvChannel.IsReleaseBranch()) or CompatibilityVersion.version ~= 45 then
    return
  end
  Game.DoDestroyDebugRoot()
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    Game.DoDestroyDebugRoot()
  end, self)
end

function Game.DoDestroyDebugRoot()
  local go = GameObject.Find("Debug(Clone)")
  if go then
    GameObject.DestroyImmediate(go)
  end
  go = GameObject.Find("DebugRoot(Clone)")
  if go then
    GameObject.DestroyImmediate(go)
  end
end

function Game.UseNewVersionInput()
  return Game.InputManager and Game.InputManager.USE_NEW_VERSION
end
