local SceneLoader = class("SceneLoader")
local defaultLimitTime = 2
local defaultLerpSpd = 2.5
local LoadState_AddSubScene = {
  None = -1,
  Unloading = 0,
  LoadingAB = 1,
  LoadingScene = 2,
  Loaded = 3
}

function SceneLoader:ctor()
  self.limitLoadingTime = defaultLimitTime
  self.fakeStopProgress = 100
  self.lerpSpd = defaultLerpSpd
  self.fadeBGM = true
  self.subScenes = {}
  self.subAsyncLoads = {}
  self:Init()
  self.addSubScenes = {}
end

function SceneLoader:Init()
  self.autoAllowSceneActivation = true
  self.Progress = 0
  self.passedTime = 0
  self.isLoading = false
  self.sceneInfo = nil
  self.arriveLimitTime = false
  self.subSceneInterval = 0
  self.subSceneXAxisOffset = 0
  self.subSceneYAxisOffset = 0
  self.subSceneZAxisOffset = 0
  local _ArrayClear = TableUtility.ArrayClear
  _ArrayClear(self.subScenes)
  _ArrayClear(self.subAsyncLoads)
  if Application.isEditor and not BranchMgr.IsChina() then
    autoImport("Table_MapIdPath")
    if BranchMgr.IsJapan() then
      autoImport("Table_MapIdPath_JP")
    elseif BranchMgr.IsTW() then
      autoImport("Table_MapIdPath_TW")
    end
  end
end

function SceneLoader:EnableFadeBGM(value)
  self.fadeBGM = value
end

function SceneLoader:SyncLoad(name, callBack)
  self:TryLoadBundle(name, function()
    SceneUtil.SyncLoad(name)
    if callBack then
      callBack()
    end
  end)
end

function SceneLoader:SetLimitLoadTime(time, lerpSpd)
  self.limitLoadingTime = time
  self.lerpSpd = lerpSpd
end

function SceneLoader:RestoreLimitLoadTime()
  self.limitLoadingTime = defaultLimitTime
  self.lerpSpd = defaultLerpSpd
end

function SceneLoader:StartLoad(name, subScenes, subSceneInterval, subSceneXAxisOffset, subSceneYAxisOffset, subSceneZAxisOffset)
  if self.asyncLoad ~= nil and self.asyncLoad.isDone == false then
    return false
  end
  self:Init()
  self.isLoading = true
  self.sceneInfo = name
  if subScenes ~= nil then
    local data
    for i = 1, #subScenes do
      data = Table_Map[subScenes[i]]
      if data ~= nil then
        self.subScenes[#self.subScenes + 1] = data.NameEn
      end
    end
  end
  self.subSceneInterval = subSceneInterval
  self.subSceneXAxisOffset = subSceneXAxisOffset
  self.subSceneYAxisOffset = subSceneYAxisOffset
  self.subSceneZAxisOffset = subSceneZAxisOffset
  self.toProgress = 0
  self.percent = 0
  self:LoadSceneAsync(name, nil, function(asyncLoad)
    self.asyncLoad = asyncLoad
    if self.asyncLoad then
      if self.loadTick then
        self.loadTick:Destroy()
        self.loadTick = nil
      end
      self.loadTick = TimeTickManager.Me():CreateTick(0, 16, self.Loading, self, 1, true)
    end
  end)
  helplog("SceneLoader:StartLoad", name, UnityFrameCount)
  return true
end

function SceneLoader:LoadSceneAsync(name, mode, callBack, callBackArgs)
  local bundleName = self:GetBundleName(name)
  self:TryLoadBundle(bundleName, function()
    if Application.isEditor and not BranchMgr.IsChina() then
      local path = Table_MapIdPath[name]
      if path then
        name = path
      end
    end
    mode = mode or SceneManagement.LoadSceneMode.Single
    local asyncLoad = SceneManagement.SceneManager.LoadSceneAsync(name, mode)
    asyncLoad.allowSceneActivation = false
    if callBack then
      callBack(asyncLoad, callBackArgs)
    end
  end)
end

local SceneBundleLoaded = function(param, args)
  local name, callBack = param[1], param[2]
  if args ~= nil then
    if args.success == true then
      if name ~= "LoadScene" then
        GameFacade.Instance:sendNotification(DownloadEvent.Downloaded, DownloadEvent.Downloaded)
      end
      ResourceManager.Instance:SAsyncLoadScene(name, callBack)
    elseif args.errMsg == 1 then
      helplog("download error not enough space")
      MsgManager.ShowMsgByID(43304)
    end
  else
    if name ~= "LoadScene" then
      GameFacade.Instance:sendNotification(DownloadEvent.Downloaded, DownloadEvent.Downloaded)
    end
    ResourceManager.Instance:SAsyncLoadScene(name, callBack)
  end
end

function SceneLoader:TryLoadBundle(name, callBack)
  self.isDownloading = false
  if ApplicationHelper.AssetBundleLoadMode then
    if self.nowLoadTag then
      Game.AssetLoadEventDispatcher:RemoveEventListener(self.sceneLoadTag)
      self.nowLoadTag = nil
    end
    local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
    self.nowLoadTag = _AssetLoadEventDispatcher:AddSceneRequestUrl(name)
    if not self.nowLoadTag then
      SceneBundleLoaded({name, callBack})
    else
      if name ~= "LoadScene" then
        self.isDownloading = true
        GameFacade.Instance:sendNotification(DownloadEvent.Downloading, DownloadEvent.Downloading)
      end
      _AssetLoadEventDispatcher:AddEventListener(self.nowLoadTag, SceneBundleLoaded, {name, callBack})
    end
  elseif callBack then
    callBack()
  end
end

function SceneLoader:Loading(deltaTime)
  if self.asyncLoad == nil then
    return
  end
  self.passedTime = self.passedTime + UnityDeltaTime
  self.arriveLimitTime = self.passedTime >= self.limitLoadingTime
  local progress = self:GetProgress()
  if progress < 0.89 then
    self.toProgress = progress * 100
  elseif not self.arriveLimitTime then
    self.toProgress = self.fakeStopProgress
  else
    self.toProgress = 100
  end
  if self.Progress < self.toProgress then
    self.Progress = math.min(self.lerpSpd + self.Progress, self.toProgress)
    if self.Progress >= self.toProgress and self.toProgress == 100 and self.arriveLimitTime then
      self:AllowSceneActivation()
    else
    end
  elseif self.toProgress == 100 and self.arriveLimitTime then
    if self.autoAllowSceneActivation then
      self:AllowSceneActivation()
    end
    self:LoadFinish()
  end
end

function SceneLoader:GetProgress()
  local count = 1 + #self.subScenes
  local progress = self.asyncLoad.progress
  if 1 < count and 0.89 <= progress and not self.asyncLoad.allowSceneActivation then
    self.asyncLoad.allowSceneActivation = true
  end
  for i = 1, #self.subAsyncLoads do
    progress = progress + self.subAsyncLoads[i].progress
  end
  return progress / count
end

function SceneLoader:AllowSceneActivation()
  local asyncLoad = self.asyncLoad
  if not asyncLoad.allowSceneActivation then
    asyncLoad.allowSceneActivation = true
  end
  for i = 1, #self.subAsyncLoads do
    asyncLoad = self.subAsyncLoads[i]
    if not asyncLoad.allowSceneActivation then
      asyncLoad.allowSceneActivation = true
    end
  end
end

function SceneLoader:SetAllowSceneActivation()
  if self.asyncLoad and self.asyncLoad.allowSceneActivation then
    self.asyncLoad.allowSceneActivation = true
    self.asyncLoad = nil
  end
end

function SceneLoader:SetDoneCallBack(callBack)
  self.DoneCallBack = callBack
end

local BigWorldIdMap = {
  [149] = 1
}

function SceneLoader:SceneAwake()
  self:LoadSubScenes()
  local success, errorMsg = xpcall(SceneLoader.LoadSceneEnviroment, debug.traceback, self)
  if not success then
    LogUtility.Error("兼容." .. tostring(errorMsg))
  end
  if self.isLoading and self:IsDone() then
    if self.waitDoneTick then
      TimeTickManager.Me():ClearTick(self, 1225)
      self.waitDoneTick = nil
    end
    local isBig = BigWorldIdMap[Game.MapManager:GetMapID()]
    if isBig then
      self.waitDoneTick = TimeTickManager.Me():CreateTick(0, 33, function(self, deltaTime)
        if BigWorld.BigWorldManager.Instance:GetInitProgress() < 1 then
          return
        end
        self:SceneAwakeDone(deltaTime)
        TimeTickManager.Me():ClearTick(self, 1225)
        self.waitDoneTick = nil
      end, self, 1225)
    else
      TimeTickManager.Me():CreateOnceDelayTick(100, self.SceneAwakeDone, self)
    end
  end
end

function SceneLoader:SceneAwakeDone(deltaTime)
  if self.isLoading then
    self.isLoading = false
    self:ApplySubScenes()
    if self.asyncLoad and self.asyncLoad.allowSceneActivation then
      self.asyncLoad = nil
    end
    TableUtility.ArrayClear(self.subAsyncLoads)
    if self.sceneInfo then
      self.NeedUnload = self.sceneInfo
    else
      self.NeedUnload = nil
    end
    if self.DoneCallBack ~= nil then
      self.DoneCallBack(self.sceneInfo)
      self.DoneCallBack = nil
    end
  end
end

function SceneLoader:LoadSceneEnviroment()
  if BackwardCompatibilityUtil.CompatibilityMode_V70 then
    return
  end
  if Slua.IsNull(G_RimLightSetting) then
    local asset = Game.AssetManager:Load("Public/RimLightSetting")
    G_RimLightSetting = GameObject.Instantiate(asset)
  end
end

function SceneLoader:LoadSubScenes()
  if not self.isLoading then
    return
  end
  if #self.subScenes == #self.subAsyncLoads then
    return
  end
  local mode = SceneManagement.LoadSceneMode.Additive
  for i = 1, #self.subScenes do
    self:LoadSceneAsync("Scene" .. self.subScenes[i], mode, function(asyncLoad, index)
      self.subAsyncLoads[index] = asyncLoad
    end, i)
  end
end

function SceneLoader:AddSubScene(sceneName, sucEndCall)
  if self.addSubScenes[sceneName] == nil then
    self.addSubScenes[sceneName] = {
      state = LoadState_AddSubScene.None,
      asyncOperation = nil,
      loadedCall = {},
      unloadedCall = {}
    }
  end
  if self.addSubScenes[sceneName].state == LoadState_AddSubScene.LoadingAB or self.addSubScenes[sceneName].state == LoadState_AddSubScene.LoadingScene then
    table.insert(self.addSubScenes[sceneName].loadedCall, sucEndCall)
    return
  elseif self.addSubScenes[sceneName].state == LoadState_AddSubScene.Loaded then
    if sucEndCall then
      sucEndCall()
    end
    return
  end
  self.addSubScenes[sceneName].state = LoadState_AddSubScene.LoadingAB
  table.insert(self.addSubScenes[sceneName].loadedCall, sucEndCall)
  self:LoadSceneAsync(sceneName, SceneManagement.LoadSceneMode.Additive, function(asyncLoad, index)
    asyncLoad.allowSceneActivation = true
    if asyncLoad == nil then
      self.addSubScenes[sceneName].state = LoadState_AddSubScene.None
      for i = 1, #info.loadedCall do
        info.loadedCall[i](sceneName, false)
      end
      TableUtility.ArrayClear(info.loadedCall)
      return
    end
    local info = self.addSubScenes[sceneName]
    if info.state ~= LoadState_AddSubScene.LoadingAB then
      redlog("场景加载状态出错", sceneName)
      self:RemoveSubScene(sceneName)
    else
      self.addSubScenes[sceneName].state = LoadState_AddSubScene.LoadingScene
      self.addSubScenes[sceneName].asyncOperation = asyncLoad
    end
  end)
  if not self.subLoadTick then
    self.subLoadTick = TimeTickManager.Me():CreateTick(0, 16, self.SubSceneLoadingTick, self, 11, true)
  end
end

function SceneLoader:SubSceneLoadingTick(deltaTime)
  for sceneName, info in pairs(self.addSubScenes) do
    if info.state == LoadState_AddSubScene.LoadingScene then
      if info.asyncOperation and info.asyncOperation.isDone then
        info.state = LoadState_AddSubScene.Loaded
        if info.loadedCall and #info.loadedCall > 0 then
          for i = 1, #info.loadedCall do
            info.loadedCall[i](sceneName, true)
          end
          TableUtility.ArrayClear(info.loadedCall)
        end
      end
    elseif info.state == LoadState_AddSubScene.Unloading and info.asyncOperation and info.asyncOperation.isDone then
      info.state = LoadState_AddSubScene.None
      if info.unloadedCall and 0 < #info.unloadedCall then
        for i = 1, #info.unloadedCall do
          info.unloadedCall[i](sceneName)
        end
        TableUtility.ArrayClear(info.unloadedCall)
      end
    end
  end
  local isClear = true
  for sceneName, info in pairs(self.addSubScenes) do
    if info.state ~= LoadState_AddSubScene.None and info.state ~= LoadState_AddSubScene.Loaded then
      isClear = false
      break
    end
  end
  if isClear then
    self:ClearSubLoadTick()
  end
end

function SceneLoader:ClearSubLoadTick()
  if not self.subLoadTick then
    return
  end
  TimeTickManager.Me():ClearTick(self, 11)
  self.subLoadTick = nil
end

function SceneLoader:RemoveSubScene(sceneName, completeCall)
  local info = self.addSubScenes[sceneName]
  if not info then
    return
  end
  if info.state == LoadState_AddSubScene.Unloading or info.state == LoadState_AddSubScene.None then
    return
  end
  info.state = LoadState_AddSubScene.Unloading
  table.insert(info.unloadedCall, completeCall)
  info.asyncOperation = SceneManagement.SceneManager.UnloadSceneAsync(sceneName)
end

function SceneLoader:ApplySubScenes()
  local obj
  local interval = self.subSceneInterval
  local xAxisOffset = self.subSceneXAxisOffset or 0
  local yAxisOffset = self.subSceneYAxisOffset or 0
  local zAxisOffset = self.subSceneZAxisOffset or 0
  local count = #self.subScenes
  local num = math.sqrt(count)
  for i = 1, count do
    obj = GameObject.Find(self.subScenes[i])
    if obj ~= nil then
      obj.transform.position = LuaGeometry.GetTempVector3((i - 1) % num * interval + xAxisOffset, yAxisOffset, -math.floor((i - 1) / num) * interval + zAxisOffset)
      obj.name = self.subScenes[i] .. "_" .. i
    end
  end
end

function SceneLoader:IsDone()
  if #self.subScenes > 0 and #self.subScenes ~= #self.subAsyncLoads then
    return false
  end
  for i = 1, #self.subAsyncLoads do
    if not self.subAsyncLoads[i].isDone then
      return false
    end
  end
  return self.asyncLoad and self.asyncLoad.isDone
end

function SceneLoader:LoadFinish()
  self.Progress = 100
  self.fadeBGM = true
  TimeTickManager.Me():ClearTick(self, 1)
  Game.EnviromentManager.ResetAmbientLight()
  Game.EnviromentManager:SwitchLightmap(ServerTime.GetDayPhase() <= ServerTime.DayPhase.Dusk and 0 or 1)
  Game.EnviromentManager:SwitchLightmapColor(LuaGeometry.Const_Col_white)
end

function SceneLoader:GetBundleName(name)
  if string.find(name, "___") then
    return string.gsub(name, "___(%w+)", "")
  end
  return name
end

return SceneLoader
