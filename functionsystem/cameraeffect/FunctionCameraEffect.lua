CameraEffectTag = {NPC_Dialog = 1}
autoImport("CameraEffect")
autoImport("CameraEffectFocusTo")
autoImport("CameraEffectFocusAndRotateTo")
autoImport("CameraEffectFaceTo")
FunctionCameraEffect = class("FunctionCameraEffect")
FunctionCameraEffect.PhotographMode = {SELFIE = 1, PHOTOGRAPHER = 2}
FunctionCameraEffect.LockTargetType = {
  None = 0,
  Npc = 1,
  NpcEPPoint = 2,
  GameObject = 3,
  Myself = 4,
  Position = 5
}
FunctionCameraEffect.CameraMode = {
  Lock = 1,
  FreeHori = 2,
  Free = 3
}
FunctionCameraEffect.FreeHoriFeature = {EnablePushOn = 1}
FunctionCameraEffect.DefaultRestoreLockTargetTime = 1
FunctionCameraEffect.DefaultCameraVertAngle = 30
FunctionCameraEffect.FreeCameraFov = 55
FunctionCameraEffect.LockFov = nil
local defaultFreeCameraScreenSplitPercent = 0.32

function FunctionCameraEffect.Me()
  if nil == FunctionCameraEffect.me then
    FunctionCameraEffect.me = FunctionCameraEffect.new()
  end
  return FunctionCameraEffect.me
end

function FunctionCameraEffect:ctor()
  self.stack = LStack.new()
  self.paused = 0
  self.endCall = nil
  self:Reset()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(LoadEvent.StartLoadScene, self.EndCameraPlot, self)
  eventManager:AddEventListener(ServiceEvent.PlayerMapChange, self.EndCameraPlot, self)
  self.disableMoveCount = 0
  self.dialogViewEff = nil
end

function FunctionCameraEffect:EndCameraPlot()
  self.startCameraPlot = false
  self:DisableMove(false)
end

function FunctionCameraEffect:SetEndCameraPlotCall(endcall)
  self.endCall = endcall
end

function FunctionCameraEffect:Reset()
end

function FunctionCameraEffect:Paused()
  return 0 < self.paused
end

function FunctionCameraEffect:Pause()
  local oldPaused = self:Paused()
  self.paused = self.paused + 1
  if not oldPaused and self:Paused() then
    self:EndTryResume()
    self:ResetEffect(nil)
  end
end

function FunctionCameraEffect:Resume()
  local oldPaused = self:Paused()
  self.paused = self.paused - 1
  if oldPaused and not self:Paused() then
    self:BeginTryResume()
  end
end

function FunctionCameraEffect:DoResume()
  if nil ~= self.effect then
    local cameraController = CameraController.Instance
    if not Game.GameObjectUtil:ObjectIsNULL(cameraController) then
      self.effect:Start(cameraController)
    end
  end
  self:EndTryResume()
end

function FunctionCameraEffect:BeginTryResume()
  if nil ~= CameraController.singletonInstance then
    if nil == self.cameraSingletonListener then
      function self.cameraSingletonListener(cameraController, beSingleton)
        if beSingleton then
          self:EndTryResume()
          
          self:DoResume()
        end
      end
      
      CameraController.singletonInstance.singletonChangedListener = {
        "+=",
        self.cameraSingletonListener
      }
    end
  elseif nil == self.tryResumeTick then
    self.tryResumeTick = TimeTickManager.Me():CreateTick(0, 16, self.DoTrtResume, self, 1)
  end
end

function FunctionCameraEffect:EndTryResume()
  if nil ~= self.tryResumeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.tryResumeTick = nil
  end
  if nil ~= CameraController.singletonInstance and nil ~= self.cameraSingletonListener then
    CameraController.singletonInstance.singletonChangedListener = {
      "-=",
      self.cameraSingletonListener
    }
    self.cameraSingletonListener = nil
  end
end

function FunctionCameraEffect:DoTrtResume()
  if self:Paused() then
    self:EndTryResume()
    return
  end
  if nil == CameraController.singletonInstance then
    return
  end
  if nil ~= CameraController.Instance then
    self:EndTryResume()
    self:DoResume()
  else
    self:BeginTryResume()
  end
end

function FunctionCameraEffect:AddEffect(newEffect)
  if nil == newEffect then
    return
  end
  if self.stack:Has(newEffect) then
    return
  end
  self.stack:Push(newEffect)
  self:ResetEffect(newEffect)
end

function FunctionCameraEffect:RemoveEffect(effect)
  if not self.stack:Has(effect) then
    return
  end
  if 0 ~= self.stack:Remove(effect) then
    local newEffect = self.stack:Peek()
    self:ResetEffect(newEffect)
  end
end

function FunctionCameraEffect:ClearAllEffect()
  self.stack:Clear()
  self:ResetEffect(nil)
end

function FunctionCameraEffect:ResetEffect(newEffect, forceEndLastEffect)
  local oldEffect = self.effect
  if oldEffect == newEffect then
    return
  end
  self.effect = newEffect
  local cameraController = CameraController.Instance
  if nil ~= oldEffect then
    cameraController = oldEffect.cameraController
    if newEffect or forceEndLastEffect then
      oldEffect.immediateEnd = true
    end
    oldEffect:End(cameraController)
    oldEffect.immediateEnd = nil
  end
  if nil ~= newEffect and not self:Paused() and not Game.GameObjectUtil:ObjectIsNULL(cameraController) then
    newEffect:Start(cameraController)
  end
end

function FunctionCameraEffect:TryGetCurrentEffect()
  return self.effect
end

function FunctionCameraEffect:Bussy()
  return nil ~= self.effect and self.effect:Bussy()
end

function FunctionCameraEffect:Start(effect)
  self:AddEffect(effect)
  return true
end

function FunctionCameraEffect:End(effect)
  self:RemoveEffect(effect)
end

function FunctionCameraEffect:Shutdown()
  self:ClearAllEffect()
end

function FunctionCameraEffect:GetCameraControllerDefaultInfo()
  if nil ~= Game.CameraPointManager.originalDefaultInfo then
    return Game.CameraPointManager.originalDefaultInfo
  end
  if nil ~= CameraController.Me then
    return CameraController.Me.currentDefaultInfo
  end
  return nil
end

function FunctionCameraEffect:_getFocusByParam(focus)
  if not focus then
    return
  end
  local focusTrans = Game.Myself.assetRole.completeTransform
  if focus.UniqueID then
    local nnpcArray = NSceneNpcProxy.Instance:FindNpcByUniqueId(focus.UniqueID)
    if nnpcArray and 0 < #nnpcArray then
      focusTrans = nnpcArray[1].assetRole.completeTransform
    end
  elseif focus.NpcID then
    local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), focus.NpcID, nil, focus.Distance)
    if npc then
      focusTrans = npc.assetRole.completeTransform
    end
  elseif focus.pos then
    if not self.cameraPlotHelper then
      self.cameraPlotHelper = GameObject("CameraPlotHelper")
    end
    self.cameraPlotHelper.transform.position = LuaGeometry.GetTempVector3(focus.pos[1], focus.pos[2], focus.pos[3])
    focusTrans = self.cameraPlotHelper.transform
  end
  return focusTrans
end

function FunctionCameraEffect._getCameraPlots(groupid)
  local data = {}
  local ids = Game.Config_CameraPlot[groupid]
  if not ids or #ids == 0 then
    return
  end
  for i = 1, #ids do
    data[#data + 1] = Table_CameraPlot[ids[i]]
  end
  return data
end

function FunctionCameraEffect._getDefaultCameraInfo()
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    return cameraController.currentDefaultInfo
  end
end

local nowstep = 1
local waitStartSeconds, durationStartSeconds, totalTime = 0, 0, 0
local plots
local returnDefault = false
local showroom = false
local csToConfigDutationRatio = 2.18

function FunctionCameraEffect:PlayCameraPlot(groupid, endcall)
  if not groupid then
    self:DisableMove(false)
    return true
  end
  if not plots then
    redlog("触发CameraPlot,groupid: ", groupid)
    self.startCameraPlot = true
    plots = FunctionCameraEffect._getCameraPlots(groupid)
    self:SetEndCameraPlotCall(endcall)
    self:DisableMove(true)
    Game.PerformanceManager:SkinWeightHigh(true)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PlotStoryView
    })
  end
  if self.startCameraPlot == false then
    self:ResetCameraPlot()
    return true
  end
  local camera_config
  local waitseconds = ServerTime.CurServerTime() - waitStartSeconds
  local durationseconds = ServerTime.CurServerTime() - durationStartSeconds
  CameraPointManager.Instance.PlotValid = true
  local focusTrans
  local defaultInfo = FunctionCameraEffect._getDefaultCameraInfo()
  local firststepwaittime = plots[1].param.WaitSeconds or 0
  if nowstep == 1 and waitseconds > firststepwaittime then
    camera_config = plots[nowstep].param
    if nil == camera_config then
      redlog("FunctionCameraEffect:PlayCameraPlot error step！ 未找到配置param: ", nowstep)
      return true
    end
    local duration = camera_config.Duration or 0
    totalTime = totalTime + duration + firststepwaittime
    focusTrans = self:_getFocusByParam(plots[nowstep].focus)
    if plots[nowstep].show == 1 then
      local manager = Game.GameObjectManagers[Game.GameObjectType.LockCameraForceRoomShow]
      showroom = true
      manager:ShowAll()
    end
    local filter = plots[nowstep].sceneFilter
    if "number" == type(filter) and Table_ScreenFilter[filter] then
      FunctionSceneFilter.Me():StartFilter(filter)
    end
    if not focusTrans then
      redlog("CameraPlot Focus 配置错误")
      return true
    end
    if camera_config.ViewPort then
      self:DoFocusAndRotateTo(focusTrans, camera_config.ViewPort, camera_config.Rotation, duration / 1000 / csToConfigDutationRatio, camera_config.FieldOfView, LuaVector3.Zero(), false)
    elseif camera_config.DefaultCameraInfo then
      self:RestoreDefault(duration / csToConfigDutationRatio, true, true)
      returnDefault = true
    elseif camera_config.End then
      self:EndCall()
    end
    nowstep = nowstep + 1
    waitStartSeconds = ServerTime.CurServerTime()
    waitseconds = 0
  end
  local preDuration, curWaitTime = 0, 0
  if nowstep <= #plots then
    preDuration = 1 < nowstep and plots[nowstep - 1].param.Duration or 0
    curWaitTime = plots[nowstep].param.WaitSeconds or 0
  end
  if nowstep <= #plots and waitseconds > preDuration + curWaitTime then
    camera_config = plots[nowstep].param
    if plots[nowstep].show == 1 then
      local manager = Game.GameObjectManagers[Game.GameObjectType.LockCameraForceRoomShow]
      showroom = true
      manager:ShowAll()
    end
    local filter = plots[nowstep].sceneFilter
    if "number" == type(filter) and Table_ScreenFilter[filter] then
      FunctionSceneFilter.Me():StartFilter(filter)
    end
    if nil == camera_config then
      redlog("FunctionCameraEffect:PlayCameraPlot error step！ 未找到配置param: ", nowstep)
      return true
    end
    local duration = camera_config.Duration or 0
    local waitTime = camera_config.WaitSeconds or 0
    totalTime = totalTime + duration + waitTime
    focusTrans = self:_getFocusByParam(plots[nowstep].focus)
    if not focusTrans then
      redlog("CameraPlot Focus 配置错误")
      return true
    end
    if camera_config.ViewPort then
      self:DoFocusAndRotateTo(focusTrans, camera_config.ViewPort, camera_config.Rotation, duration / 1000 / csToConfigDutationRatio, camera_config.FieldOfView, LuaVector3.Zero(), false)
    elseif camera_config.DefaultCameraInfo then
      self:RestoreDefault(duration / csToConfigDutationRatio, true, true)
      returnDefault = true
    elseif camera_config.End then
      self:EndCall()
    end
    waitStartSeconds = ServerTime.CurServerTime()
    waitseconds = 0
    nowstep = nowstep + 1
  end
  if nowstep > #plots and durationseconds > totalTime then
    if returnDefault then
      redlog("回归默认")
      self:ResetCameraPlot()
    else
      self:ResetCameraPlotParams()
    end
    if not BackwardCompatibilityUtil.CompatibilityMode_V46 then
      CameraPointManager.Instance.PlotShowRoomValid = false
    end
    return true
  end
end

function FunctionCameraEffect:DisableMove(var)
  redlog("DisableMove:", var)
  if var then
    if self.disableMoveCount > 0 then
      return
    end
    FunctionSystem.InterruptMyselfAll()
    Game.InputManager.disableMove = Game.InputManager.disableMove + 1
    local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.NormalLayer)
    if layer then
      layer:ShowMask()
    end
    Game.PlotStoryManager:SetCameraPlotStyle(true)
    self.disableMoveCount = self.disableMoveCount + 1
  else
    if self.disableMoveCount <= 0 then
      return
    end
    Game.InputManager.disableMove = Game.InputManager.disableMove - 1
    local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.NormalLayer)
    if layer then
      layer:HideMask()
    end
    Game.PlotStoryManager:SetCameraPlotStyle(false)
    self.disableMoveCount = self.disableMoveCount - 1
  end
end

function FunctionCameraEffect:ResetCameraPlotParams()
  nowstep = 1
  waitStartSeconds = ServerTime.CurServerTime()
  plots = nil
  totalTime = 0
  durationStartSeconds = ServerTime.CurServerTime()
  self.cameraPlotHelper = nil
  returnDefault = false
  if showroom then
    local manager = Game.GameObjectManagers[Game.GameObjectType.LockCameraForceRoomShow]
    manager:HideAll()
  end
  showroom = false
  self:ResetFreeCameraLocked()
  self:ResetCameraPushOnStatus()
end

local needManulRestore = false

function FunctionCameraEffect:ResetCameraTrans(cameraController)
  if cameraController == nil then
    return
  end
  local cameraInfo = cameraController.defaultInfo
  if cameraInfo.focus == nil then
    cameraInfo.focus = Game.Myself.assetRole.completeTransform
  end
end

function FunctionCameraEffect:ResetCameraPlot()
  self:ResetCameraPlotParams()
  CameraPointManager.Instance.PlotValid = false
  self:Shutdown()
  self.cft = nil
  self.startCameraPlot = false
  if needManulRestore then
    needManulRestore = false
    local cameraController = CameraController.singletonInstance
    if nil ~= cameraController then
      cameraController:InterruptSmoothTo()
      cameraController:RestoreDefault(0.5, nil)
      if self.resetTick then
        TimeTickManager.Me():ClearTick(self, 100)
        self.resetTick = nil
      end
      self.resetTick = TimeTickManager.Me():CreateTick(500, 33, function(deltaTime)
        self:DisableMove(false)
        if not Slua.IsNull(cameraController) then
          self:ResetCameraTrans(cameraController)
          cameraController:SetDefault()
        end
        TimeTickManager.Me():ClearTick(self, 100)
        self.resetTick = nil
      end, self, 100)
    else
      self:DisableMove(false)
    end
  else
    self:DisableMove(false)
  end
  FunctionSceneFilter.Me():ShutDownAll()
  if not UIManagerProxy.Instance:IsLayerActive(UIViewType.DialogLayer) then
    UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, true)
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, "PlotStoryView")
  self:EndCall()
  Game.PerformanceManager:SkinWeightHigh(false)
end

function FunctionCameraEffect:EndCall()
  if nil ~= self.endCall then
    self.endCall()
    self.endCall = nil
  end
end

function FunctionCameraEffect:ReturnDefault(duration)
  if CameraController.singletonInstance then
    CameraController.singletonInstance:RestoreDefault(duration, nil)
    LuaLuancher.Instance.ignoreAreaTrigger = false
  end
end

function FunctionCameraEffect:DoFocusAndRotateTo(transform, viewPort, rotation, duration, fieldOfView, focusOffset, inverse, noRestore, listener)
  if nil == CameraController.singletonInstance then
    return
  end
  focusOffset = LuaVector3.zero
  if inverse then
    CameraController.singletonInstance:SetInverseInfo(transform, focusOffset, viewPort, rotation, fieldOfView, true)
  end
  CameraController.singletonInstance:ResetFocusOffset(LuaVector3.Zero())
  if noRestore == nil then
    noRestore = true
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  duration = duration or CameraConfig.UI_Duration
  CameraController.singletonInstance:FieldOfViewTo(fieldOfView, duration, nil)
  local temp = LuaVector3()
  local rot_V3 = LuaVector3()
  LuaVector3.Better_Set(temp, viewPort[1], viewPort[2], viewPort[3])
  LuaVector3.Better_Set(rot_V3, rotation[1], rotation[2], rotation[3])
  self.cft = CameraEffectFocusAndRotateTo.new(transform, focusOffset, temp, rot_V3, duration, listener, inverse, noRestore)
  LuaVector3.Destroy(temp)
  self:Start(self.cft)
end

function FunctionCameraEffect:RestoreDefault(duration, inverse, cleraSmooth)
  local cameraController = CameraController.singletonInstance
  if nil == cameraController then
    return
  end
  if cleraSmooth then
    cameraController:InterruptSmoothTo()
  end
  local currentDefaultInfo = cameraController.currentDefaultInfo
  if duration == 0 then
    cameraController:RestoreDefault(0, nil)
    cameraController:FieldOfViewTo(currentDefaultInfo.fieldOfView, 0, nil)
  elseif inverse then
    needManulRestore = true
    self:DoFocusAndRotateTo(Game.Myself.assetRole.completeTransform, currentDefaultInfo.focusViewPort, currentDefaultInfo.rotation, duration / 1000, currentDefaultInfo.fieldOfView, currentDefaultInfo.focusOffset, true, true)
  else
    cameraController:RestoreDefault(duration, nil)
    cameraController:FieldOfViewTo(currentDefaultInfo.fieldOfView, 0, nil)
  end
end

function FunctionCameraEffect:IsFreeCameraLocked()
  if Game.IsLocalEditorGame and Game.IsLocalEditorLockFreeCamera then
    return true
  end
  return self:GetCameraValidMode() == 1
end

function FunctionCameraEffect:IsFreeCameraLockVert()
  return self:GetCameraValidMode() == 2
end

function FunctionCameraEffect:GetCurCameraMode()
  if self.disableFreeCamera then
    return FunctionCameraEffect.CameraMode.Lock
  elseif self.disableCameraVert then
    return FunctionCameraEffect.CameraMode.FreeHori
  else
    return FunctionCameraEffect.CameraMode.Free
  end
end

function FunctionCameraEffect:GetCameraValidMode()
  local mode = FunctionPerformanceSetting.Me():GetCameraMode()
  if not SceneProxy.Instance:IsCurForbidCameraMode(mode) then
    return mode
  end
  for i = 3, 1, -1 do
    if i ~= mode and not SceneProxy.Instance:IsCurForbidCameraMode(i) then
      return i
    end
  end
  Debug.LogError("该地图没有合法的镜头配置.")
  return 1
end

function FunctionCameraEffect:ResetFreeDefaultInfo(cameraController, disableCameraVert, newCameraEuler)
  local freeDefaultInfo = cameraController and cameraController.FreeDefaultInfo
  if not freeDefaultInfo then
    return false
  end
  if disableCameraVert then
    local rotation = newCameraEuler or freeDefaultInfo.rotation
    rotation.x = FunctionCameraEffect.DefaultCameraVertAngle
    freeDefaultInfo.rotation = rotation
    local cfgFov = GameConfig.CameraUnlock and GameConfig.CameraUnlock.FreeHori_FOV
    freeDefaultInfo.fieldOfView = cfgFov and cfgFov[Game.MapManager:GetMapID()] or 24
  else
    if newCameraEuler then
      freeDefaultInfo.rotation = newCameraEuler
    end
    if not FunctionCameraEffect.LockFov then
      freeDefaultInfo.fieldOfView = FunctionCameraEffect.FreeCameraFov
    end
  end
  local viewPort = self:AdjustCameraViewportAndFocusoffset(cameraController, LuaGeometry.GetTempVector3(0.5, 0.5, 23), true)
  freeDefaultInfo.focusViewPort = LuaGeometry.GetTempVector3(0.5, 0.5, viewPort.z)
  return true
end

function FunctionCameraEffect:ResetFreeCameraLocked(isLock, force, fogCamMode, forceZoom)
  self:SaveCameraInfoToLocal()
  if isLock == nil then
    isLock = self:IsFreeCameraLocked()
  end
  local isCameraModeChanged = false
  if self.disableFreeCamera ~= isLock then
    self.disableFreeCamera = isLock
    Game.InputManager.disableFreeCamera = isLock
    isCameraModeChanged = true
  end
  local disableVert = self:IsFreeCameraLockVert()
  local config = GameConfig.CameraUnlock and GameConfig.CameraUnlock.FreeHori_AllowAreaTrigger
  if config and config[Game.MapManager:GetMapID()] == 1 then
    Game.InputManager.ForceAllowAreaTrigger = disableVert
  else
    Game.InputManager.ForceAllowAreaTrigger = false
  end
  local resetFreeCameraDisableVert = self.disableCameraVert ~= disableVert
  if resetFreeCameraDisableVert then
    Game.InputManager.disableVerticalFreeCamera = disableVert
    Game.InputManager:ResetFreeCameraParams()
    self.disableCameraVert = disableVert
  end
  local cameraController = CameraController.singletonInstance
  if cameraController then
    cameraController:SetCameraDefaultState(isLock and 0 or 1)
    if (resetFreeCameraDisableVert or force) and self:ResetFreeDefaultInfo(cameraController, self.disableCameraVert) then
      isCameraModeChanged = true
    end
  end
  if isCameraModeChanged then
    self:CameraModeChanged()
  end
  self:UpdateLinearFogOffset(fogCamMode or self:GetCurCameraMode())
  if forceZoom then
    cameraController.zoom = forceZoom
  end
end

function FunctionCameraEffect:CameraModeChanged()
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    return
  end
  local cameraMode = self:GetCurCameraMode()
  local zoom, zoomMin = LocalSaveProxy.Instance:GetCameraZoom()
  if cameraMode == FunctionCameraEffect.CameraMode.Lock then
    cameraController:SetShadowUpdateConfig(4, 1.72, 0, 15, 54)
    cameraController.defaultCameraZoomMin = 0.4
    zoomMin = 0.4
  elseif cameraMode == FunctionCameraEffect.CameraMode.FreeHori then
    cameraController:SetShadowUpdateConfig(4, 1.72, 0, 12, 54)
    cameraController.freeCameraZoomMin = 0.38
    zoomMin = 0.38
  elseif cameraMode == FunctionCameraEffect.CameraMode.Free then
    cameraController:SetShadowUpdateConfig(30, 0, 0.6, 10, 30)
    cameraController.freeCameraZoomMin = 0.32
    zoomMin = 0.32
  end
  if zoom then
    zoom = math.max(zoom, zoomMin)
    cameraController:ResetCameraZoomMinMaxByStatus()
    cameraController.zoom = zoom
  end
  GameFacade.Instance:sendNotification(MainViewEvent.CameraModeChange)
end

function FunctionCameraEffect:UpdateLinearFogOffset(cameraMode)
  local manager = Game.EnviromentManager
  if not manager then
    return
  end
  local offset = 0
  if cameraMode == FunctionCameraEffect.CameraMode.Lock or cameraMode == FunctionCameraEffect.CameraMode.FreeHori then
    local cameraController = CameraController.singletonInstance
    if cameraController then
      local currentDefaultInfo
      if cameraMode == FunctionCameraEffect.CameraMode.Lock then
        currentDefaultInfo = cameraController.currentDefaultInfo
      else
        currentDefaultInfo = cameraController.FreeDefaultInfo
      end
      local fov = currentDefaultInfo and currentDefaultInfo.fieldOfView or 0
      local focusZ = currentDefaultInfo and currentDefaultInfo.focusViewPort.z or 0
      if fov <= 0 then
        fov = cameraController.cameraFieldOfView
      end
      if 0 < fov then
        offset = (math.tan(math.rad(0.5 * FunctionCameraEffect.FreeCameraFov)) / math.tan(math.rad(0.5 * fov)) - 1.0) * focusZ * 0.8
      end
    end
  end
  manager:SetLinearFogOffset(offset, 0.5)
end

function FunctionCameraEffect:ForceDisableCameraPushOn(disablePushOn)
  local lastStatus = self:IsCameraPushOnForceDisable()
  self.forceDisablePushOnCount = (self.forceDisablePushOnCount or 0) + (disablePushOn and 1 or -1)
  local curStatus = self:IsCameraPushOnForceDisable()
  if lastStatus ~= curStatus then
    self:ResetCameraPushOnStatus()
    local cameraController = CameraController.singletonInstance
    if cameraController then
      cameraController:ResetPushOn()
    end
  end
end

function FunctionCameraEffect:IsCameraPushOnForceDisable()
  return 0 < (self.forceDisablePushOnCount or 0)
end

function FunctionCameraEffect:ResetCameraPushOnStatus(enablePushOn)
  if self:IsCameraPushOnForceDisable() then
    enablePushOn = false
  end
  if enablePushOn == nil then
    local cameraMode = self:GetCurCameraMode()
    if cameraMode == FunctionCameraEffect.CameraMode.Free then
      enablePushOn = true
    elseif cameraMode == FunctionCameraEffect.CameraMode.FreeHori then
      local cfgFeature = GameConfig.CameraUnlock and GameConfig.CameraUnlock.FreeHori_Features
      local curCfg = cfgFeature and cfgFeature[Game.MapManager:GetMapID()]
      enablePushOn = curCfg and curCfg & FunctionCameraEffect.FreeHoriFeature.EnablePushOn > 0
    end
    enablePushOn = enablePushOn or Game.InputManager.IsSelfiePhotoMode
  end
  local cameraController = CameraController.singletonInstance
  if cameraController then
    cameraController:ActivePushOn(enablePushOn == true)
  end
end

function FunctionCameraEffect:ResetFreeCameraScreenSplitPercent(percent)
  percent = percent or defaultFreeCameraScreenSplitPercent
  if percent == self.curScreenSplitPercent then
    return
  end
  self.curScreenSplitPercent = percent
  Game.InputManager.freeCameraScreenSplitPercent = percent
  Game.InputManager:ResetProcesserParams()
end

function FunctionCameraEffect:SetPauseLockTarget(isPause, duration, rotateBack)
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    return
  end
  if isPause then
    cameraController:SetPauseLockTarget(duration or 0, rotateBack == true)
  else
    cameraController:SetResumeLockTarget()
  end
end

function FunctionCameraEffect:SaveCameraInfoToLocal()
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    return
  end
  LocalSaveProxy.Instance:SetCameraZoom(cameraController.zoom)
  if FunctionPerformanceSetting.Me():GetCameraLocked() then
    return
  end
  local freeInfo = cameraController and cameraController.FreeDefaultInfo
  if not freeInfo then
    return
  end
  local eulerAngles = freeInfo.rotation
  LocalSaveProxy.Instance:SetFreeCameraRotation(eulerAngles.x, eulerAngles.y)
end

function FunctionCameraEffect:InitFreeCameraParam()
  if self.freeCameraParamInit then
    return
  end
  self.freeCameraParamInit = true
  self.disableFreeCamera = Game.InputManager.disableFreeCamera
  Game.InputManager.finglesRotateSpeed = GameConfig.CameraUnlock.finglesRotateSpeed or 1
  Game.InputManager.mouseAngelOneDistance = GameConfig.CameraUnlock.mouseAngelOneDistance or 5
  Game.InputManager:ResetFreeCameraParams()
end

local FreeFocusOffsetY = 1.2
local newViewPort = LuaVector3.Zero()
local newOffset = LuaVector3.Zero()

function FunctionCameraEffect:AdjustCameraViewportAndFocusoffset(cameraController, oldViewPort, forceNew, angleX)
  LuaVector3.Better_Set(newOffset, 0, 0, 0)
  if forceNew or not self.disableFreeCamera then
    if cameraController ~= nil then
      local oldFov = 24
      local newFov = cameraController.FreeDefaultInfo.fieldOfView
      local fovFactor = math.tan(math.rad(oldFov)) / math.tan(math.rad(newFov))
      if newFov <= 0.001 then
        newFov = 24
      end
      LuaVector3.Better_Set(newViewPort, oldViewPort[1], oldViewPort[2], oldViewPort[3] * fovFactor)
      newOffset[2] = FreeFocusOffsetY
      angleX = angleX or FunctionCameraEffect.DefaultCameraVertAngle
      local vpX, vpY, vpZ = cameraController:AdjustViewportByOffset(newViewPort, LuaGeometry.GetTempVector2(newOffset[1], newOffset[2]), angleX)
      LuaVector3.Better_Set(newViewPort, oldViewPort[1], vpY, vpZ)
      return newViewPort, newOffset
    end
    LuaVector3.Better_Set(newViewPort, oldViewPort[1], oldViewPort[2] + 0.05, oldViewPort[3])
    newOffset[2] = FreeFocusOffsetY
    return newViewPort, newOffset
  end
  return oldViewPort, newOffset
end

function FunctionCameraEffect:ClearCameraLockPosObj()
  if not self.tsfCameraLockPos then
    return
  end
  LuaGameObject.DestroyGameObject(self.tsfCameraLockPos)
  self.tsfCameraLockPos = nil
end

function FunctionCameraEffect:CancelLockTarget(onlyOnce)
  self:_EndLockTarget(CameraController.singletonInstance)
  if not onlyOnce then
    self.forbidLockTarget = true
  end
end

function FunctionCameraEffect:_EndLockTarget(cameraController, isFinish)
  if cameraController then
    cameraController.lockTarget = nil
    cameraController.forceShadowDistance = -1
  end
  self:ClearCameraLockPosObj()
  if isFinish then
    self.forbidLockTarget = false
  end
  GameFacade.Instance:sendNotification(MyselfEvent.LockTargetEnd)
end

function FunctionCameraEffect:RecvCameraAction(actionStr)
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    LogUtility.Error("Cannot Find CameraController When Do Camera Action: " .. tostring(actionStr))
    return
  end
  if StringUtil.IsEmpty(actionStr) then
    cameraController.lockTargetSwitchDuration = FunctionCameraEffect.DefaultRestoreLockTargetTime
    self:_EndLockTarget(cameraController, true)
    return
  end
  local funcData = loadstring("return " .. actionStr)
  local actionData = funcData and funcData()
  if nil == actionData then
    cameraController.lockTargetSwitchDuration = FunctionCameraEffect.DefaultRestoreLockTargetTime
    self:_EndLockTarget(cameraController)
    LogUtility.Error("Camera Action Cannot Parse: " .. tostring(actionStr))
    return
  end
  if actionData.LockType then
    self:DoLockTargetAction(actionData, cameraController, actionStr)
  elseif actionData.Action == "Rotate" then
    self:DoRotateAction(actionData, cameraController, actionStr)
  end
end

function FunctionCameraEffect:DoLockTargetAction(actionData, cameraController, actionStr)
  local tsfTarget
  local followLerpTime = 0.15
  cameraController.lockTargetFov = FunctionCameraEffect.FreeCameraFov
  if actionData.LockType == FunctionCameraEffect.LockTargetType.None then
    cameraController.lockTargetSwitchDuration = actionData.SwitchDuration or FunctionCameraEffect.DefaultRestoreLockTargetTime
  elseif actionData.LockType == FunctionCameraEffect.LockTargetType.Npc or actionData.LockType == FunctionCameraEffect.LockTargetType.NpcEPPoint then
    local npc = NSceneNpcProxy.Instance:FindNearestNpc_IngoreCanArrive(Game.Myself:GetPosition(), actionData.TargetID)
    if npc then
      if actionData.LockType == FunctionCameraEffect.LockTargetType.NpcEPPoint then
        tsfTarget = npc.assetRole:GetEP(actionData.PointID)
        if not tsfTarget then
          tsfTarget = npc.assetRole.completeTransform
          LogUtility.Error(string.format("Cannot Find EP Point: %s From Npc: %s", tostring(actionData.PointID), tostring(actionData.TargetID)))
        end
      else
        tsfTarget = npc.assetRole.completeTransform
      end
    end
  elseif actionData.LockType == FunctionCameraEffect.LockTargetType.GameObject then
    local luaGoTrans = Game.GameObjectManagers[Game.GameObjectType.CameraFocusObj]:FindObjTransform(actionData.TargetID)
    if actionData.PointID and actionData.PointID > 0 then
      local ep = Game.GameObjectUtil:DeepFind(luaGoTrans.gameObject, "EP_" .. actionData.PointID)
      if ep then
        tsfTarget = ep.transform
      else
        tsfTarget = luaGoTrans
      end
    else
      tsfTarget = luaGoTrans
    end
  elseif actionData.LockType == FunctionCameraEffect.LockTargetType.Myself then
    tsfTarget = Game.Myself.assetRole.completeTransform
    followLerpTime = 0
  elseif actionData.LockType == FunctionCameraEffect.LockTargetType.Position then
    tsfTarget = GameObject().transform
    tsfTarget.name = "CameraLockPosition"
    tsfTarget.position = LuaGeometry.GetTempVector3(actionData.TargetPosition[1], actionData.TargetPosition[2], actionData.TargetPosition[3])
  else
    LogUtility.Error("Unsupport Target Type In Camera Action: " .. tostring(actionStr))
  end
  if not tsfTarget then
    if actionData.LockType ~= FunctionCameraEffect.LockTargetType.None then
      cameraController.lockTargetSwitchDuration = FunctionCameraEffect.DefaultRestoreLockTargetTime
      LogUtility.Error("Cannot find target transform when do camera action: " .. tostring(actionStr))
    end
    self:_EndLockTarget(cameraController, actionData.LockType == FunctionCameraEffect.LockTargetType.None)
    return
  end
  if self.forbidLockTarget then
    return
  end
  GameFacade.Instance:sendNotification(MyselfEvent.LockTargetStart, actionData.AllowPlayerCancel)
  if not cameraController.IsLockingTarget then
    cameraController.forceShadowDistance = 30
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V57 then
    cameraController:ForceResetLockTargetStatus()
  end
  local fov = actionData.fov or cameraController.lockTargetFov
  cameraController:ResetLockTargetParams(actionData.CameraDistance, actionData.CameraHoriOffset or 0, followLerpTime, actionData.CancelDistance or -1, actionData.MaxHeight, actionData.MinHeight, actionData.MaxAngle, fov)
  local focusOffset = LuaGeometry.GetTempVector3(0, 0, 0)
  if actionData.TargetOffset then
    focusOffset:Set(actionData.TargetOffset[1], actionData.TargetOffset[2], actionData.TargetOffset[3])
  end
  local viewport = LuaGeometry.GetTempVector2(actionData.TargetViewport[1], actionData.TargetViewport[2])
  cameraController:SetLockTarget(tsfTarget, focusOffset, viewport, actionData.SwitchDuration)
  self:ClearCameraLockPosObj()
  if actionData.LockType == FunctionCameraEffect.LockTargetType.Position then
    self.tsfCameraLockPos = tsfTarget
  end
end

function FunctionCameraEffect:DoRotateAction(actionData, cameraController, actionStr)
  LocalSaveProxy.Instance:SetFreeCameraRotation(actionData.AngleX or 0, actionData.AngleY or 0)
  local rotation = LuaGeometry.GetTempVector3(actionData.AngleX or 0, actionData.AngleY or 0, 0)
  if self:GetCurCameraMode() == FunctionCameraEffect.CameraMode.Free then
    cameraController:ResetRotationWithCustomDefaultInfo(rotation)
  elseif actionData.forceUpdate == 1 then
    local freeDefaultInfo = cameraController.FreeDefaultInfo
    if freeDefaultInfo then
      freeDefaultInfo.rotation = rotation
    end
  end
end

function FunctionCameraEffect.ResetFreeCameraFocusOffset(assetRole, notRestoreDefault)
  local cameraController = CameraController.singletonInstance
  local freeInfo = cameraController and cameraController.FreeDefaultInfo
  if not freeInfo then
    return
  end
  freeInfo.focusOffset = FunctionCameraEffect.GetFreeCameraFocusOffset(assetRole)
  if notRestoreDefault or FunctionCameraEffect.Me():IsFreeCameraLocked() or not cameraController.IsIdle then
    return
  end
  cameraController:InterruptSmoothTo()
  cameraController:RestoreDefault(0, nil)
end

function FunctionCameraEffect.GetFreeCameraFocusOffset(assetRole)
  local offset = LuaGeometry.GetTempVector3(0, 0, 0)
  if not assetRole then
    return offset
  end
  local scaleX, scaleY, scaleZ = assetRole:GetScaleXYZ()
  local posX, posY, posZ = assetRole:GetCPPosition(1)
  if posY then
    offset:Set(0, posY, 0)
    posX, posY, posZ = assetRole:GetPositionXYZ()
    offset.y = (offset.y - posY) / scaleY
  end
  if offset.y < 0.3 then
    local body = assetRole:GetPartObject(Asset_Role.PartIndex.Body)
    if body then
      offset:Set(body:CalFreeCameraFocusOffsetForLua())
    end
    offset:Set(offset[1] / scaleX, offset[2] / scaleY, offset[3] / scaleZ)
  end
  offset.y = math.max(offset.y + 0.3, CameraController.TerrainUplift + 0.1)
  return offset
end

function FunctionCameraEffect:SetDialogViewEffect(eff)
  self.dialogViewEff = eff
end

function FunctionCameraEffect:EndDialogViewEffect()
  if self.dialogViewEff then
    self:RemoveEffect(self.dialogViewEff)
  end
end

local tempVector3 = LuaVector3.zero
local getDir = function(pos)
  LuaVector3.Better_Set(tempVector3, pos.x, pos.y, pos.z)
  return tempVector3
end

function FunctionCameraEffect:HandleManualCameraSetting(serverdata)
  if serverdata.reset then
    self:ClearManualSetting()
    return
  end
  if nil == self.manualSettingInfo then
    self.manualSettingInfo = ReusableTable.CreateArray()
  end
  self.manualSettingInfo[1] = getDir(serverdata.camera_dir)
  self.manualSettingInfo[2] = serverdata.role_dir
  self.manualSettingInfo[3] = serverdata.zoom
  self.manualSettingInfo[4] = serverdata.filter_effect
  self.manualSettingInfo[5] = serverdata.hide
end

function FunctionCameraEffect:ClearManualSetting()
  if self.manualSettingInfo then
    ReusableTable.DestroyAndClearArray(self.manualSettingInfo)
    self.manualSettingInfo = nil
  end
end

function FunctionCameraEffect:ClearSomeWhenChangeScene()
  self:EndDialogViewEffect()
  self:ClearManualSetting()
  self:CancelLockTarget(true)
end

function FunctionCameraEffect:GetManualSetting()
  return self.manualSettingInfo or {}
end

function FunctionCameraEffect:CameraMoveToDefaultPos(eulerX, eulerY, duration, curve, onFinish)
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    redlog("CameraMoveToDefaultPos: Cannot find CameraController!")
    if onFinish then
      onFinish()
    end
    return
  end
  local defaultMode = self:GetCameraValidMode()
  local targetInfo
  if defaultMode == FunctionCameraEffect.CameraMode.Lock then
    targetInfo = cameraController.defaultInfo
    eulerX, eulerY = targetInfo.rotation.x, targetInfo.rotation.y
  else
    local disableCameraVert = defaultMode == FunctionCameraEffect.CameraMode.FreeHori
    self:ResetFreeDefaultInfo(cameraController, disableCameraVert, LuaGeometry.GetTempVector3(eulerX, eulerY, 0))
    targetInfo = cameraController.FreeDefaultInfo
  end
  local success, posX, posY, posZ = cameraController:CalTargetCameraPosForLua(targetInfo)
  if not success then
    redlog("CameraMoveToDefaultPos: Do not have focus!")
    if onFinish then
      onFinish()
    end
    return
  end
  local objCamera = cameraController.gameObject
  local tweener = TweenPosition.Begin(objCamera, duration, LuaGeometry.GetTempVector3(posX, posY, posZ), true)
  if not curve then
    curve = AnimationCurve()
    LuaGameObject.AddKeyFrameToCurve(curve, 0, 0, 0, 0.01)
    LuaGameObject.AddKeyFrameToCurve(curve, 1, 1, 0.01, 0)
  end
  tweener.animationCurve = curve
  tweener = TweenRotation.Begin(objCamera, duration, LuaGeometry.GetTempVector3(eulerX, eulerY, 0), true)
  tweener.quaternionLerp = true
  tweener.animationCurve = curve
  tweener = TweenFOV.Begin(objCamera, duration, targetInfo.fieldOfView)
  tweener.animationCurve = curve
  tweener:SetOnFinished(function()
    LuaGameObject.RemoveComponentsFromObj(objCamera, UITweener)
    if onFinish then
      onFinish()
    end
  end)
end
