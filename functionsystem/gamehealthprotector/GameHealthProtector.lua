autoImport("GameHealthWorker_ClickButton")
GameHealthProtector = class("GameHealthProtector", EventDispatcher)
GameHealthProtector.E_EvtType = {
  Pos = SceneUser2_pb.EGHEVENTTYPE_POS,
  Time = SceneUser2_pb.EGHEVENTTYPE_TIME,
  Danger = SceneUser2_pb.EGHEVENTTYPE_DANGER_LEVEL,
  Count = SceneUser2_pb.EGHEVENTTYPE_COUNT,
  NPC = SceneUser2_pb.EGHEVENTTYPE_NPC,
  Barrage = SceneUser2_pb.EGHEVENTTYPE_BARRAGE
}
local _GVGSettingOptions = {
  [1] = {
    func = FunctionPerformanceSetting.Me().SetHurtNumStyleDetail,
    param = false,
    field = FunctionPerformanceSetting.Me().GetHurtNumStyleDetail
  },
  [2] = {
    func = FunctionPerformanceSetting.Me().SetFrameRate,
    param = 1,
    field = FunctionPerformanceSetting.Me().GetTargetFrameRate
  },
  [3] = {
    func = FunctionPerformanceSetting.Me().SetQualityLevel,
    param = 1,
    field = FunctionPerformanceSetting.Me().GetQualitySet
  },
  [4] = {
    func = FunctionPerformanceSetting.Me().SetOutLine,
    param = false,
    field = FunctionPerformanceSetting.Me().GetOutline
  },
  [5] = {
    func = FunctionPerformanceSetting.Me().SetPeak,
    param = false,
    field = FunctionPerformanceSetting.Me().GetPeak
  },
  [6] = {
    func = FunctionPerformanceSetting.Me().SetSlim,
    param = false,
    field = FunctionPerformanceSetting.Me().GetSlim
  },
  [7] = {
    func = FunctionPerformanceSetting.Me().SetOtherPlayerExterior,
    param = 63,
    field = FunctionPerformanceSetting.Me().GetOtherPlayerExterior
  },
  [8] = {
    func = FunctionPerformanceSetting.Me().SetShowHurtNum,
    param = 3,
    field = FunctionPerformanceSetting.Me().ShowHurtNum
  },
  [9] = {
    func = FunctionPerformanceSetting.Me().SetEffectLv,
    param = 0,
    field = FunctionPerformanceSetting.Me().GetEffectLv
  }
}

function GameHealthProtector:OptimizeGVGSettingOption()
  local setting = FunctionPerformanceSetting.Me()
  self.beforeSetting = {}
  setting:SetBegin()
  for i = 1, #_GVGSettingOptions do
    if type(_GVGSettingOptions[i].func) == "function" then
      if nil ~= _GVGSettingOptions[i].field then
        self.beforeSetting[i] = _GVGSettingOptions[i].field(setting)
      end
      if nil ~= _GVGSettingOptions[i].param then
        _GVGSettingOptions[i].func(setting, _GVGSettingOptions[i].param)
      end
    end
  end
  setting:SetEnd()
end

function GameHealthProtector:GameEnd()
  self:TryRestoreFpsCacheSetting()
  GvgProxy.Instance:ClearFPSCheckTime()
end

function GameHealthProtector:TryRestoreFpsCacheSetting()
  if not GvgProxy.Instance:IsFPSOptimizeSet() then
    return
  end
  if not self.beforeSetting then
    return
  end
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  for i = 1, #_GVGSettingOptions do
    if nil ~= self.beforeSetting[i] then
      _GVGSettingOptions[i].func(setting, self.beforeSetting[i])
    end
  end
  setting:SetEnd()
  self.beforeSetting = nil
end

function GameHealthProtector:ctor()
  self.maxRecordNum = GameConfig.GameHealth and GameConfig.GameHealth.MaxRecord or 200
  self.sendInterval = GameConfig.GameHealth and GameConfig.GameHealth.TimeInterval or 600
  self.sendTimeRecord = 0
  self.level = 0
  self.eventRecords = {}
  self.vecMouseWorldPos = LuaVector3(0, 0, 0)
  self.eventWorkers = {
    GameHealthWorker_ClickButton.new()
  }
  self.fpsLaunch = true
end

function GameHealthProtector:UpdateStatus(serverData)
  self.level = serverData and serverData.level or 0
  self.fishWay = serverData and serverData.fishWay or 0
  self:SendEventRecords()
  self.curMapID = Game.MapManager:GetMapID()
  if self.level > 0 ~= self.isDelegatesWorking then
    self:UpdateCameraEventDelegates(self.level > 0)
  end
  if self.level > 0 then
    EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnFinishLoadScene, self)
    EventManager.Me():AddEventListener(UIEvent.EnterView, self.OnEnterView, self)
    EventManager.Me():AddEventListener(UIEvent.ExitView, self.OnExitView, self)
  else
    EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnFinishLoadScene, self)
    EventManager.Me():RemoveEventListener(UIEvent.EnterView, self.OnEnterView, self)
    EventManager.Me():RemoveEventListener(UIEvent.ExitView, self.OnExitView, self)
  end
  local singleWorker, isActive
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    singleWorker:SetLevel(self, self.level)
    isActive = self:IsWorkerActive(singleWorker)
    if isActive ~= singleWorker._IsWorkerActive then
      singleWorker:SetWorkStatus(isActive)
      singleWorker._IsWorkerActive = isActive
    end
  end
end

function GameHealthProtector:UpdateCameraEventDelegates(isAdd)
  local tmpTable = ReusableTable.CreateArray()
  tmpTable[1] = isAdd and "+=" or "-="
  tmpTable[2] = GameHealthProtector.OnClick
  UICamera.onClick = tmpTable
  tmpTable[2] = GameHealthProtector.OnPress
  UICamera.onPress = tmpTable
  tmpTable[2] = GameHealthProtector.OnScroll
  UICamera.onScroll = tmpTable
  tmpTable[2] = GameHealthProtector.OnDrag
  UICamera.onDrag = tmpTable
  ReusableTable.DestroyAndClearArray(tmpTable)
  self.isDelegatesWorking = isAdd
end

function GameHealthProtector:Update(time, deltaTime)
  self:UpdateFps(time, deltaTime)
  self:UpdateCheckFpsFunc(time, deltaTime)
  if not self.level or self.level < 1 then
    return
  end
  self.curTime = ServerTime.CurServerTime() / 1000
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.Update then
      singleWorker:Update(time, deltaTime)
    end
  end
  if self.curTime - self.sendTimeRecord > self.sendInterval then
    self:SendEventRecords()
  end
end

function GameHealthProtector:IsWorkerActive(worker)
  return self.level >= worker.Level and (not worker.FishID or self.fishWay == worker.FishID)
end

function GameHealthProtector:AddEventRecord(id, evtType, param1, param2)
  if evtType == GameHealthProtector.E_EvtType.Count and not param1 then
    param1 = 1
  end
  local tmpTable = ReusableTable.CreateTable()
  tmpTable.eventid = id
  tmpTable.type = evtType
  tmpTable.time = ServerTime.CurServerTime()
  tmpTable.param1 = param1
  tmpTable.param2 = param2
  self.eventRecords[#self.eventRecords + 1] = tmpTable
  self:CheckSendEventRecords()
end

function GameHealthProtector:CheckSendEventRecords()
  if #self.eventRecords > self.maxRecordNum then
    self:SendEventRecords()
  end
end

function GameHealthProtector:SendEventRecords()
  if #self.eventRecords > 0 then
    ServiceNUserProxy.Instance:CallGameHealthEventStatUserCmd(self.eventRecords)
  end
  self.sendTimeRecord = ServerTime.CurServerTime() / 1000
  self:ClearRecords()
end

function GameHealthProtector:ClearRecords()
  for i = 1, #self.eventRecords do
    ReusableTable.DestroyAndClearTable(self.eventRecords[i])
  end
  TableUtility.TableClear(self.eventRecords)
end

function GameHealthProtector.OnClick(gameObject)
  if Game.GameHealthProtector.level < 1 then
    return
  end
  gameObject = gameObject or UICamera.selectedObject
  local eventWorkers = Game.GameHealthProtector.eventWorkers
  local singleWorker
  for i = 1, #eventWorkers do
    singleWorker = eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnClick then
      singleWorker:OnClick(gameObject)
    end
  end
end

function GameHealthProtector.OnPress(gameObject, isPress)
  if Game.GameHealthProtector.level < 1 then
    return
  end
  gameObject = gameObject or UICamera.selectedObject
  local eventWorkers = Game.GameHealthProtector.eventWorkers
  local singleWorker
  for i = 1, #eventWorkers do
    singleWorker = eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnPress then
      singleWorker:OnPress(gameObject, isPress)
    end
  end
end

function GameHealthProtector.OnScroll(gameObject, delta)
  if Game.GameHealthProtector.level < 1 then
    return
  end
  gameObject = gameObject or UICamera.selectedObject
  local eventWorkers = Game.GameHealthProtector.eventWorkers
  local singleWorker
  for i = 1, #eventWorkers do
    singleWorker = eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnScroll then
      singleWorker:OnScroll(gameObject, delta)
    end
  end
end

function GameHealthProtector.OnDrag(gameObject, deltaV2)
  if Game.GameHealthProtector.level < 1 then
    return
  end
  gameObject = gameObject or UICamera.selectedObject
  local eventWorkers = Game.GameHealthProtector.eventWorkers
  local singleWorker
  for i = 1, #eventWorkers do
    singleWorker = eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnDrag then
      singleWorker:OnDrag(gameObject, deltaV2)
    end
  end
end

function GameHealthProtector:OnClickRole(nCreature)
  if self.level < 1 then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnClickRole then
      singleWorker:OnClickRole(nCreature)
    end
  end
end

function GameHealthProtector:OnClickObject(gameObject)
  if self.level < 1 then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnClickObject then
      singleWorker:OnClickObject(gameObject)
    end
  end
end

function GameHealthProtector:OnClickTerrain(position)
  if self.level < 1 then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnClickTerrain then
      singleWorker:OnClickTerrain(position)
    end
  end
end

function GameHealthProtector:OnInputJoyStick(deltaV3)
  if self.level < 1 then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnInputJoyStick then
      singleWorker:OnInputJoyStick(deltaV3)
    end
  end
end

function GameHealthProtector:OnInputJoyStickEnd()
  if self.level < 1 then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnInputJoyStickEnd then
      singleWorker:OnInputJoyStickEnd()
    end
  end
end

function GameHealthProtector:EnterScene()
  self:RefreshCheckGameFrameRateStatus()
  self.ignoreFrameCheckTime = 10
  self:InitFps()
end

function GameHealthProtector:LeaveScene()
  self.checkFrameRate = false
end

function GameHealthProtector:OnFinishLoadScene(msg)
  if self.level < 1 then
    return
  end
  self:UpdateCameraEventDelegates(false)
  self:UpdateCameraEventDelegates(true)
  self.curMapID = msg and msg.mapID
  if not self.curMapID then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnFinishLoadScene then
      singleWorker:OnFinishLoadScene(self.curMapID)
    end
  end
end

function GameHealthProtector:OnEnterView(note)
  if self.level < 1 then
    return
  end
  local viewCtrl = note.data
  if not viewCtrl then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnEnterView then
      singleWorker:OnEnterView(viewCtrl)
    end
  end
end

function GameHealthProtector:OnExitView(note)
  if self.level < 1 then
    return
  end
  local viewCtrl = note.data
  if not viewCtrl then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.OnExitView then
      singleWorker:OnExitView(viewCtrl)
    end
  end
end

function GameHealthProtector:GetMouseWorldPosition()
  if self.timeMouseWorldPos == self.curTime then
    return self.vecMouseWorldPos
  end
  if not self.cameraUI then
    self.cameraUI = NGUIUtil:GetCameraByLayername("UI")
  end
  if not self.cameraUI then
    return
  end
  local mousePosition = LuaGeometry.GetTempVector3(LuaGameObject.GetMousePosition())
  if UIUtil.IsScreenPosValid(mousePosition[1], mousePosition[2]) then
    LuaVector3.Better_Set(self.vecMouseWorldPos, LuaGameObject.ScreenToWorldPointByVector3(self.cameraUI, mousePosition))
  else
    LuaVector3.Better_Set(self.vecMouseWorldPos, 0, 0, 0)
  end
  self.vecMouseWorldPos[1] = self.vecMouseWorldPos[1] * 10000
  self.vecMouseWorldPos[2] = self.vecMouseWorldPos[2] * 10000
  self.vecMouseWorldPos[3] = 0
  self.timeMouseWorldPos = self.curTime
  return self.vecMouseWorldPos
end

function GameHealthProtector:FindView(name, layerType)
  local layer = UIManagerProxy.Instance:GetLayerByType(layerType)
  if not layer then
    LogUtility.Error("Cannot find layer type: ", tostring(layerType and layerType.name))
    return nil
  end
  local ctrl = layer:FindNodeByName(name)
  return ctrl and ctrl.viewCtrl
end

function GameHealthProtector:ObjIsChildOfView(obj, name, layerType)
  if not obj then
    return false
  end
  local viewCtrl = self:FindView(name, layerType)
  return self:IsChild(obj.transform, viewCtrl and viewCtrl.trans)
end

function GameHealthProtector:IsChild(child, parent)
  if not child or not parent then
    return false
  end
  return child:IsChildOf(parent)
end

function GameHealthProtector:IsAtMainCity()
  if not self.curMapID then
    self.curMapID = Game.MapManager:GetMapID()
  end
  local mapSData = self.curMapID and Table_Map[self.curMapID]
  return (mapSData and mapSData.Type == 6) == true
end

function GameHealthProtector:RecvFishway2KillBossInformUserCmd(serverData)
  if self.fishWay ~= 2 then
    return
  end
  local singleWorker
  for i = 1, #self.eventWorkers do
    singleWorker = self.eventWorkers[i]
    if singleWorker._IsWorkerActive and singleWorker.MapNpcRoundOver then
      singleWorker:MapNpcRoundOver(serverData)
      break
    end
  end
end

function GameHealthProtector:RefreshCheckGameFrameRateStatus()
  self.checkFrameRate = GameConfig.CheckFrameRate and not GameConfig.SystemForbid.CheckFrame and LocalSaveProxy.Instance:IsCheckFrameRateOpen()
  self.checkFrameRate = self.checkFrameRate and FunctionPerformanceSetting.Me():GetSetting().screenCount > FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Low)
  if GameConfig.CheckFrameRate and GameConfig.CheckFrameRate.DurationTime then
    local curFrameRateCheckDutation = LocalSaveProxy.Instance:GetCheckFrameRateTime()
    local timeNotEnough = curFrameRateCheckDutation < GameConfig.CheckFrameRate.DurationTime
    self.checkFrameRate = self.checkFrameRate and timeNotEnough
    if timeNotEnough and self.checkFrameTotalTime and self.checkFrameTotalTime > 0 then
      LocalSaveProxy.Instance:SetCheckFrameRateTime(math.modf(curFrameRateCheckDutation + self.checkFrameTotalTime))
      self.checkFrameTotalTime = 0
    end
  end
  if not self.checkFrameRate then
    return
  end
  self.checkMinFramePerSec = GameConfig.CheckFrameRate.MinFramePerSec or 0
  self.checkFrameDuration = GameConfig.CheckFrameRate.CheckTime or 0
  self.checkFrameMinCount = GameConfig.CheckFrameRate.CheckMinFrame or 0
  self.frameCount = self.frameCount or 0
  self.checkFrameTime = self.checkFrameTime or 0
  self.checkFrameTotalTime = self.checkFrameTotalTime or 0
  self.ignoreFrameCheckTime = self.ignoreFrameCheckTime or 0
end

local CFG_FPS = {
  SampleTime = 30,
  IncreaseFps = 825.0,
  DecreaseFps = 810,
  minPlayerCount = 5
}

function GameHealthProtector:CloseBloomAndFxaa()
  if ApplicationInfo.IsEmulator() or ROSystemInfo.DeviceRate <= 3 then
    self.lastBloom = FunctionPerformanceSetting.Me():GetBloom()
    self.lastfxaa = FunctionPerformanceSetting.Me():GetFxaa()
    FunctionPerformanceSetting.Me():SetBloom(false)
    FunctionPerformanceSetting.Me():ApplyBloom()
    FunctionPerformanceSetting.Me():SetFxaa(false)
    FunctionPerformanceSetting.Me():ApplyFxaa(false)
  end
end

function GameHealthProtector:RecoverBloomAndMsaa()
  if ApplicationInfo.IsEmulator() or ROSystemInfo.DeviceRate <= 3 then
    if self.lastBloom ~= nil then
      FunctionPerformanceSetting.Me():SetBloom(self.lastBloom)
      FunctionPerformanceSetting.Me():ApplyBloom()
    end
    if self.lastfxaa ~= nil then
      FunctionPerformanceSetting.Me():SetFxaa(self.lastfxaa)
      FunctionPerformanceSetting.Me():ApplyFxaa(self.lastfxaa)
    end
  end
end

function GameHealthProtector:ReduceByLimit(delta)
  CFG_FPS.IncreaseFps = CFG_FPS.IncreaseFps - delta * 30
  CFG_FPS.DecreaseFps = CFG_FPS.DecreaseFps - delta * 30
end

function GameHealthProtector:ForceReduceConfig()
  local basicFps = 30
  self.delta = 5
  local setting = FunctionPerformanceSetting.Me()
  self.lastSetting = setting:GetSetting()
  self.lastTargetFramerate = UnityEngine.Application.targetFrameRate
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.IPhonePlayer then
    ApplicationInfo.SetTargetFrameRate(basicFps)
  elseif runtimePlatform == RuntimePlatform.Android then
    ApplicationInfo.SetTargetFrameRate(basicFps)
  end
  self:ReduceByLimit(5)
  setting:SetQualityLevel(1)
  setting:SetBloom(false)
  setting:SetShadow(0)
  setting:SetEffectLv(0)
  setting:Apply()
end

function GameHealthProtector:ResetPerformConfig()
  local setting = FunctionPerformanceSetting.Me()
  ApplicationInfo.SetTargetFrameRate(self.lastTargetFramerate)
  if self.lastSetting then
    setting:Apply(self.lastSetting)
  end
  self.delta = self.delta * -1
  self:ReduceByLimit(self.delta)
end

function GameHealthProtector:TryReduceConfig()
  if ROSystemInfo.DeviceRate <= 2 or ApplicationInfo.GetSystemMemorySize() < 2800 then
    local basicFps = 30
    local forceFps = 25
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      ApplicationInfo.SetTargetFrameRate(basicFps)
    elseif runtimePlatform == RuntimePlatform.Android then
      ApplicationInfo.SetTargetFrameRate(basicFps)
    end
  end
  FunctionPerformanceSetting.AdjustLodBiasByDevice()
end

function GameHealthProtector:ProcressFps()
  if self.frame < CFG_FPS.DecreaseFps then
    if Game.MapManager:IsInGVGRaid() and not GvgProxy.Instance:IsFPSOptimizeValid() then
      MsgManager.ConfirmMsgByID(27182, function()
        self:OptimizeGVGSettingOption()
        GvgProxy.Instance:SetFPSOptimizeFlag()
      end, function()
        GvgProxy.Instance:SetFPSOptimizeFlag()
      end)
    else
      self:_handleFPSDanger()
    end
  else
    if self.frame > CFG_FPS.IncreaseFps and self.limitedScreenCount < self.settingScreenCount then
      self:_handleHealthy()
    else
    end
    goto lbl_39
  end
  ::lbl_39::
  self:ResetFpsParam()
end

function GameHealthProtector:LaunchFpsCheck()
  self.fpsLaunch = true
end

function GameHealthProtector:ShutDownFpsCheck()
  self.fpsLaunch = false
end

function GameHealthProtector:SetCheckFpsFunc(funcSampleTime, callback)
  if not funcSampleTime or 0 == funcSampleTime then
    return
  end
  self.funcCheckSampleTime = funcSampleTime
  self:LaunchFpsFuncCheck(callback)
end

function GameHealthProtector:LaunchFpsFuncCheck(callback)
  self.funcCallback = callback
  self.checkFpsFuncStartup = UnityRealtimeSinceStartup
  self.funcCheckFrame = 0
end

function GameHealthProtector:UpdateCheckFpsFunc()
  if nil == self.funcCheckSampleTime then
    return
  end
  self.funcCheckFrame = self.funcCheckFrame + 1
  if UnityRealtimeSinceStartup - self.checkFpsFuncStartup > self.funcCheckSampleTime then
    self:ProcressFuncFps()
  end
end

function GameHealthProtector:ProcressFuncFps()
  if self.funcCallback then
    local averageFps = self.funcCheckFrame / self.funcCheckSampleTime
    redlog("sampleTime平均帧率： ", self.funcCheckSampleTime, averageFps)
    self.funcCallback(averageFps)
  end
  self:ShutDownFpsFuncCheck()
end

function GameHealthProtector:ShutDownFpsFuncCheck()
  self.funcCheckSampleTime = nil
  self.funcCallback = nil
  self.funcCheckFrame = 0
end

local forbiddenRaidType

function GameHealthProtector:UpdateFps(time, deltaTime)
  if not self.fpsLaunch then
    self.fpsRunning = false
    return
  end
  if not self.sampleTime or not self.frame then
    self.fpsRunning = false
    return
  end
  if Game.HandUpManager:IsInHandingUp() then
    self.fpsRunning = false
    return
  end
  if Game.MapManager:IsMapRaidTypeForbid(self.checkFpsCheckRaid) then
    self.fpsRunning = false
    return
  end
  self.fpsRunning = true
  self.frame = self.frame + 1
  if UnityRealtimeSinceStartup - self.sampleTime > CFG_FPS.SampleTime then
    self:ProcressFps()
  end
end

function GameHealthProtector:SetForceMinPlayerCount(count)
  self.forceMinPlayerCount = count
end

function GameHealthProtector:IsLowFps()
  return self.limitedScreenCount and self.limitedScreenCount < self.settingScreenCount
end

function GameHealthProtector:SetSettingLimitCount(c)
  c = Game.LogicManager_RoleDress:UpdateLimitCount(c)
  self.settingScreenCount = c
  self.limitedScreenCount = c
  Game.LogicManager_RoleDress:SetLimitCount(c)
  self:ResetFpsParam()
end

function GameHealthProtector:ResetFpsParam()
  self.frame = 0
  self.sampleTime = UnityRealtimeSinceStartup
end

function GameHealthProtector:InitFps()
  if not self.checkFpsCheckRaid then
    self.checkFpsCheckRaid = GameConfig.Setting.FpsForbiddenCheckMapRaid
  end
  local settingScreenCount = FunctionPerformanceSetting.Me():GetScreenCount()
  self:SetSettingLimitCount(settingScreenCount)
end

function GameHealthProtector:_handleFPSDanger()
  local dressLimitCount = Game.LogicManager_RoleDress:GetLimitCount()
  local minPlayerCount = self.forceMinPlayerCount or CFG_FPS.minPlayerCount
  if dressLimitCount > minPlayerCount then
    self.limitedScreenCount = dressLimitCount - 1
    Game.LogicManager_RoleDress:SetLimitCount(self.limitedScreenCount)
  else
  end
end

function GameHealthProtector:_handleHealthy()
  self.limitedScreenCount = self.limitedScreenCount + 1
  if self.limitedScreenCount > self.settingScreenCount then
    self.limitedScreenCount = self.settingScreenCount
  end
  Game.LogicManager_RoleDress:SetLimitCount(self.limitedScreenCount)
end

function GameHealthProtector:CheckGameFrameRate(time, deltaTime)
  if not self.checkFrameRate then
    return
  end
  if self.ignoreFrameCheckTime > 0 then
    self.ignoreFrameCheckTime = self.ignoreFrameCheckTime - deltaTime
    return
  end
  self.checkFrameTime = self.checkFrameTime + deltaTime
  self.checkFrameTotalTime = self.checkFrameTotalTime + deltaTime
  self.frameCount = self.frameCount + 1
  if self.startStatisticsFrameRate then
    if self.checkFrameTime > self.checkFrameDuration then
      if self.frameCount < self.checkFrameMinCount then
        MsgManager.ConfirmMsgByID(27181, function()
          local low = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Low)
          FunctionPerformanceSetting.Me():SetScreenCount(low)
        end)
        LocalSaveProxy.Instance:SetCheckFrameRateOpenClose()
        self.checkFrameRate = false
      else
        self.startStatisticsFrameRate = false
        self.checkFrameTime = 0
        self.frameCount = 0
      end
    end
  elseif self.checkFrameTime > 1 then
    if self.frameCount < self.checkMinFramePerSec then
      self.startStatisticsFrameRate = true
    end
    self.checkFrameTime = 0
    self.frameCount = 0
  end
end
