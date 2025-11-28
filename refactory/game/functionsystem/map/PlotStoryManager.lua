PlotStoryManager = class("PlotStoryManager")
autoImport("PlotStoryProcess")
autoImport("PlotStoryProcessRecorder")
autoImport("PlotStoryTimeLineWrapper")
autoImport("PlotStoryTimelineProcess")
autoImport("FakeNPlayer")
PlotStoryManager.PlotStoryUIId = 800
PlotStoryManager.PlotStoryTopUIId = 803
PlotStoryManager.LimitNpc = 100
PlotConfig_Prefix = {
  Quest = "Table_PlotQuest_",
  Anim = "Table_PlotAnim_",
  PQTL = "pqtl"
}
local tempV3 = LuaVector3.Zero()

function PlotStoryManager:ctor()
  self.plotList = {}
  self.freePlotList = {}
  self.npcMap = {}
  self.uiMap = {}
  self.buttonStateMap = {}
  self.customNpcList_Map = {
    [PlotConfig_Prefix.Quest] = {},
    [PlotConfig_Prefix.Anim] = {},
    [PlotConfig_Prefix.PQTL] = {}
  }
  self.forceQueue = {}
  self.multiPlayingPQTL = {}
  self.branchPendingPlots = {}
  self.cameraPlotStyle = false
  PlotStoryProcessRecorder.new()
end

function PlotStoryManager:ForceStart(plotid, plotEndCall, plotEndCallParam, config_Prefix, customNpclist)
  if self.running then
    self:Start(plotid, plotEndCall, plotEndCallParam, config_Prefix, customNpclist)
    return
  end
  local args = ReusableTable.CreateArray()
  args[1] = plotid
  args[2] = plotEndCall
  args[3] = plotEndCallParam
  args[4] = config_Prefix
  args[5] = customNpclist
  table.insert(self.forceQueue, args)
end

function PlotStoryManager:ClearForceQueue()
  local deleter = function(t)
    ReusableTable.DestroyArray(t)
  end
  TableUtility.ArrayClearByDeleter(self.forceQueue, deleter)
end

function PlotStoryManager:ExcuteForceQueue()
  local args = table.remove(self.forceQueue, 1)
  if args == nil then
    return
  end
  self:Start(args[1], function(plotEndCallParam)
    if args[2] then
      args[2](plotEndCallParam)
    end
    self:ExcuteForceQueue()
  end, args[3], args[4], args[5])
end

function PlotStoryManager:Start(plotid, plotEndCall, plotEndCallParam, config_Prefix, customNpclist)
  if not self.running then
    local str = plotid .. "STOP"
    return
  end
  self:Stop()
  self.cameraDirty = false
  FunctionSystem.WeakInterruptMyself()
  FunctionSystem.InterruptMyselfAI()
  Game.AssetManager_Role:SetForceLoadAll(true)
  self.endCall = plotEndCall
  self.endCallParam = plotEndCallParam
  if not Game.MapManager:IsPVEMode_ChasingScene() then
    self:ShowPlotStoryView()
  end
  if Game.HandUpManager then
    Game.HandUpManager:MaunalClose()
  end
  config_Prefix = config_Prefix or PlotConfig_Prefix.Quest
  if customNpclist then
    local cacheTable = self.customNpcList_Map[config_Prefix]
    cacheTable[plotid] = customNpclist
  end
  self:Play(plotid, config_Prefix)
end

function PlotStoryManager:StartScenePlot(plotid, starttime, plotEndCall, plotEndCallParam, config_Prefix)
  config_Prefix = config_Prefix or PlotConfig_Prefix.Quest
  local config = PlotStoryProcess._getStoryConfig(plotid, config_Prefix)
  local step
  local deltatime = math.floor(ServerTime.CurServerTime() / 1000 - starttime)
  if 0 < deltatime then
    deltatime = deltatime * 1000
    for i = 1, #config do
      if config[i].Type == "wait_time" then
        deltatime = deltatime - config[i].Params.time
        if deltatime <= 0 then
          step = i
          break
        end
      end
    end
  end
  if 0 < deltatime then
    redlog("ERROR: Plot OverTime!!!", "StartTime:" .. os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime() / 1000), "NowTime:" .. os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime() / 1000))
    return
  end
  self:Play(plotid, config_Prefix, nil, step)
end

function PlotStoryManager:Play(plotid, config_Prefix, progressEndCall, step)
  local plotStoryProgress = PlotStoryProcess.new(plotid, config_Prefix)
  plotStoryProgress:AddEventListener(PlotStoryEvent.End, self.EndPlotProgress, self)
  plotStoryProgress:AddEventListener(PlotStoryEvent.ShutDown, self.ShutDownProgress, self)
  plotStoryProgress:SetEndCall(progressEndCall)
  table.insert(self.plotList, plotStoryProgress)
  if self.running then
    plotStoryProgress:Launch(step)
  end
end

function PlotStoryManager:EndPlotProgress(plotProgress)
  if plotProgress then
    plotProgress:ShutDown(true)
  end
end

function PlotStoryManager:IsSeqPlotProgressEnd()
  return self.pqtl_seq == nil or #self.pqtl_seq <= self.pqtl_seq_step
end

function PlotStoryManager:TryDoEndCall()
  if self.autoBattleIds and #self.autoBattleIds > 0 then
    for i = 1, #self.autoBattleIds do
      Game.Myself:Client_SetAutoBattleLockID(self.autoBattleIds[i])
    end
  elseif self.autoBattleOn then
    Game.AutoBattleManager:AutoBattleOn()
  end
  if self.autoStanding then
    Game.Myself:Client_SetAutoBattleStanding(true)
  end
  self.autoBattleOn = nil
  self.autoStanding = nil
  self.autoBattleIds = nil
  if self.endCall and #self.plotList == 0 then
    self.endCall(self.endCallParam)
  end
  self.endCall = nil
  self.endCallParam = nil
end

function PlotStoryManager:ShutDownProgress(plotProgress)
  local isFreePlot = false
  for i = #self.plotList, 1, -1 do
    local plot = self.plotList[i]
    if plot == plotProgress then
      table.remove(self.plotList, i)
    end
  end
  for i = #self.freePlotList, 1, -1 do
    local plot = self.freePlotList[i]
    if plot == plotProgress then
      table.remove(self.freePlotList, i)
      isFreePlot = true
    end
  end
  if self.pstlp_list and plotProgress.plotid then
    self.pstlp_list[plotProgress.plotid] = nil
  end
  if self.pqtl_seq then
    self:StepOn_SEQ_PQTLP()
    return
  else
    self:TryDoEndCall()
  end
  if (not isFreePlot or plotProgress.needRestore) and #self.plotList == 0 then
    if not plotProgress.keep then
      self:Clear()
    else
      helplog("ShutDownProgress keep", plotProgress.plotid)
    end
    Game.AssetManager_Role:SetForceLoadAll(false)
  end
end

function PlotStoryManager:GetNowProgressList()
  return self.plotList
end

function PlotStoryManager:GetProgressById(plotid)
  for i = 1, #self.plotList do
    if self.plotList[i].plotid == plotid then
      return self.plotList[i]
    end
  end
end

function PlotStoryManager:CombineNpcKey(plotid, npcuid)
  if plotid and npcuid then
    return plotid .. "n" .. npcuid
  end
  errorLog(string.format("Error When Combine NPCKEY %s %s", tostring(plotid), tostring(npcuid)))
  return "NULL"
end

function PlotStoryManager:GetPlotCustomNpcInfo(config_Prefix, plotid, npcindex)
  local cache = self.customNpcList_Map[config_Prefix]
  local customNpclist = cache[plotid]
  if customNpclist then
    return customNpclist[npcindex]
  end
end

function PlotStoryManager:CreateNpcRole(plotid, npcuid, npcid, pos, groupid, npcname, fullparam)
  local combineKey = self:CombineNpcKey(plotid, npcuid)
  local fakeNpc = self.npcMap[combineKey]
  if not fakeNpc then
    local fakeServerData
    if fullparam and fullparam.npcType ~= nil then
      fakeServerData = {}
      fakeServerData.name = fullparam.NameZh
      fakeServerData.id = npcuid
      if fullparam.npcType == 1 then
        fakeServerData.npcid = npcid
      else
        fakeServerData.monsterid = npcid
      end
      fakeServerData.fullparam = fullparam
    elseif Table_Npc[npcid] then
      fakeServerData = {}
      fakeServerData.id = npcuid
      fakeServerData.name = Table_Npc[npcid].NameZh
      fakeServerData.npcid = npcid
      fakeServerData.DefaultExpression = Table_Npc[npcid].DefaultExpression
      fakeServerData.ReplaceActionExpresssion = Table_Npc[npcid].ReplaceActionExpresssion
      local MountFashion = Table_Npc[npcid].MountFashion
      if MountFashion then
        local mf = ""
        for i = 1, #MountFashion do
          mf = mf .. tostring(MountFashion[i]) .. ";"
        end
        fakeServerData.datas = {
          {
            type = ProtoCommon_pb.EUSERDATATYPE_MOUNT_FASHION,
            data = mf
          }
        }
      end
    elseif Table_Monster[npcid] then
      fakeServerData = {}
      fakeServerData.id = npcuid
      fakeServerData.name = Table_Monster[npcid].NameZh
      fakeServerData.monsterid = npcid
    end
    if fakeServerData then
      if npcname then
        fakeServerData.name = npcname
      end
      fakeServerData.pos = pos
      if not fakeServerData.attrs then
        fakeServerData.attrs = {}
      end
      if not fakeServerData.datas then
        fakeServerData.datas = {}
      end
      fakeServerData.groupid = groupid
      fakeServerData.belong_plotid = plotid
      fakeNpc = FakeNPlayer.CreateAsTable(fakeServerData)
      self.npcMap[combineKey] = fakeNpc
    end
  end
  return fakeNpc
end

function PlotStoryManager:GetNpcRole(plotid, npcuid)
  local combineKey = self:CombineNpcKey(plotid, npcuid)
  return self.npcMap[combineKey]
end

function PlotStoryManager:GetNpcRoleByCombinekey(combineKey)
  return self.npcMap[combineKey]
end

function PlotStoryManager:GetNpcRoles_ByGroupId(groupid)
  if not groupid then
    return
  end
  local npcs = {}
  for _, npcRole in pairs(self.npcMap) do
    if npcRole and npcRole.data:GetGroupID() == groupid then
      table.insert(npcs, npcRole)
    end
  end
  return npcs
end

function PlotStoryManager:DestroyNpcRole(plotid, npcuid, groupid)
  if plotid == nil then
    return
  end
  if groupid ~= nil then
    local delnpcs = {}
    for k, v in pairs(self.npcMap) do
      if v.data.belong_plotid and v.data.belong_plotid == plotid and v.data.groupid == groupid then
        v:Destroy()
        table.insert(delnpcs, k)
      end
    end
    for i = 1, #delnpcs do
      self.npcMap[delnpcs[i]] = nil
    end
    return
  end
  local combineKey = self:CombineNpcKey(plotid, npcuid)
  local npcRole = self.npcMap[combineKey]
  if npcRole then
    npcRole:Destroy()
  end
  self.npcMap[combineKey] = nil
end

local npcDeleter = function(npcRole)
  npcRole:Destroy()
end

function PlotStoryManager:ClearNpcMap()
  TableUtility.TableClearByDeleter(self.npcMap, npcDeleter)
end

function PlotStoryManager:CombineButtonKey(plotid, buttonid)
  if plotid and buttonid then
    return plotid .. buttonid
  end
  errorLog(string.format("Error When Combine BUTTONKEY %s %s", tostring(plotid), tostring(buttonid)))
  return "NULL"
end

function PlotStoryManager:AddButton(plotid, buttonid, buttonData)
  local combineKey = self:CombineButtonKey(plotid, buttonid)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.AddButton, buttonData)
  self.buttonStateMap[combineKey] = 1
end

function PlotStoryManager:SetButtonState(plotid, buttonid, state)
  local combineKey = self:CombineButtonKey(plotid, buttonid)
  self.buttonStateMap[combineKey] = state
end

function PlotStoryManager:GetButtonState(plotid, buttonid)
  local combineKey = self:CombineButtonKey(plotid, buttonid)
  return self.buttonStateMap[combineKey]
end

function PlotStoryManager:ClearButtonStates()
  TableUtility.TableClear(self.buttonStateMap)
end

function PlotStoryManager:ShowPlotStoryView(plotStoryShowSkip, skipDelay)
  if not BranchMgr.IsChina() then
    GameFacade.Instance:sendNotification(MainViewEvent.ClearViewSequence)
  end
  self:AddUIView(PlotStoryManager.PlotStoryUIId)
  self:AddUIView(PlotStoryManager.PlotStoryTopUIId, plotStoryShowSkip, {skipDelay = skipDelay})
end

function PlotStoryManager:AddUIView(panelid, plotStoryShowSkip, viewdata, panelKeep)
  if not self.uiMap[panelid] then
    local panelConfig = FunctionUnLockFunc.Me():GetPanelConfigById(panelid)
    if panelConfig then
      viewdata = viewdata or {}
      viewdata.plotStoryShowSkip = plotStoryShowSkip
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panelConfig, viewdata = viewdata})
      panelConfig.panelKeep = panelKeep
      self.uiMap[panelid] = panelConfig
    end
  end
end

function PlotStoryManager:CloseUIView(panelid, force)
  local panelConfig = self.uiMap[panelid]
  if panelConfig == nil and force then
    panelConfig = FunctionUnLockFunc.Me():GetPanelConfigById(panelid)
  end
  if not panelConfig or panelConfig.class == "PlotStoryView" and PlotStoryView.Instance and PlotStoryView.Instance:PlotStoryClearCloseSelf() then
  else
    local viewClass = _G[panelConfig.class]
    if viewClass then
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, viewClass.ViewType)
    end
    self.uiMap[panelid] = nil
  end
end

function PlotStoryManager:ClearUIView(force)
  for panelid, panelConfig in pairs(self.uiMap) do
    if force or not panelConfig.panelKeep then
      self:CloseUIView(panelid)
    end
    panelConfig.panelKeep = nil
    self.uiMap[panelid] = nil
  end
end

function PlotStoryManager:AddToUIMap(panelConfig)
  if not self.uiMap[panelConfig.id] then
    self.uiMap[panelConfig.id] = panelConfig
  end
end

function PlotStoryManager:SetCameraEndStay(b)
  self.camera_endstay = b
end

function PlotStoryManager:ActiveCameraControl(active, duration)
  self.cameraDirty = true
  if active then
    local cameraControllerInstance = CameraController.singletonInstance
    cameraControllerInstance:RestoreDefault(duration or 0.3, nil)
    GameObjectUtil.SetBehaviourEnabled(cameraControllerInstance, true)
  else
    GameObjectUtil.SetBehaviourEnabled(CameraController.singletonInstance, false)
  end
end

function PlotStoryManager:SetCamera(pos, rotation, fieldOfView)
  if not pos and not fieldOfView then
    return
  end
  local cameraTrans = Camera.main.transform
  if pos then
    cameraTrans.position = pos
  end
  if rotation then
    cameraTrans.rotation = rotation
  end
  if fieldOfView then
    Camera.main.fieldOfView = fieldOfView
  end
  CameraController.singletonInstance:UpdateCameraExtraInfo()
  self:ActiveCameraControl(false)
end

function PlotStoryManager:PS_SetCameraPlotStyle(on)
  on = on or false
  if self.cameraPlotStyle == on then
    return
  end
  self.cameraPlotStyle = on
  if on then
    local camera = CameraController.Instance or CameraController.singletonInstance
    if camera then
      self.ori_camDefaultState = camera.camDefaultState
    end
  end
  if self.ori_camDefaultState and self.ori_camDefaultState ~= 0 then
    CameraPointManager.Instance.PlotValid = on
  end
  self:SetCameraPlotStyle(on, true)
  if not on then
    CameraController.singletonInstance:ClearSmoothes()
    CameraController.singletonInstance:PlotAct_RestoreDefault(0)
    CameraController.singletonInstance:Scenario_RestoreDefault(0)
    self.ps_delayInstantFinish_CPTrigger_RestoreDefault = 1
  end
end

function PlotStoryManager:SetCameraPlotStyle(on, isNewPlot)
  if on then
    if not isNewPlot then
      FunctionCameraEffect.Me():ResetFreeCameraLocked(true, nil, FunctionCameraEffect.CameraMode.Free)
    end
    GameFacade.Instance:sendNotification(PlotStoryViewEvent.StartPlot)
  else
    if not isNewPlot then
      FunctionCameraEffect.Me():ResetFreeCameraLocked()
    end
    GameFacade.Instance:sendNotification(PlotStoryViewEvent.EndPlot)
  end
  FunctionCameraEffect.Me():ForceDisableCameraPushOn(on == true)
  Game.Myself.assetRole:SetEnableVisibleByCameraPos(not on)
  FunctionCameraEffect.Me():SetPauseLockTarget(on == true)
  Asset_Effect.SetEffectLODDisable(on == true)
end

function PlotStoryManager:MoveCamera(pos, targetPos, time)
end

function PlotStoryManager:Clear()
  self:ClearNpcMap()
  self:ClearButtonStates()
  self:ClearUIView()
  local customNpclist_quest = self.customNpcList_Map[PlotConfig_Prefix.Quest]
  TableUtility.TableClear(customNpclist_quest)
  local customNpclist_anim = self.customNpcList_Map[PlotConfig_Prefix.Anim]
  TableUtility.TableClear(customNpclist_anim)
  if self.inPQTL == 0 then
    self:RestoreOriRoleParts()
    if Game.Myself then
      Game.Myself:Client_PlayAction(Game.Myself:GetIdleAction())
    end
    if Game.IsLocalEditorGame then
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
      if self.plotstory_on_campoints then
        for i = 1, #self.plotstory_on_campoints do
          CameraPointManager.Instance:DisableGroup(self.plotstory_on_campoints[i])
        end
        TableUtility.ArrayClear(self.plotstory_on_campoints)
      end
    end
    self:RestorePlotStorySceneFilter()
    self:ResetMoveSpd()
    self:ResetMoveActionSpd()
    TableUtility.TableClear(self.roleMoveSpdCache)
    if self.roleActionSpdCache then
      TableUtility.TableClear(self.roleActionSpdCache)
    end
    if self.screenShakeToken then
      CameraAdditiveEffectManager.Me():EndShake(self.screenShakeToken)
      self.screenShakeToken = nil
    end
  end
  if self.cameraDirty then
    self.cameraDirty = false
    if not self.camera_endstay then
      self:ActiveCameraControl(true)
    end
  end
  if Game.HandUpManager then
    Game.HandUpManager:MaunalOpen()
  end
  PlotStoryProcess._setCreatureAnimatorCullingMode(Game.Myself, 1)
  if self.inPQTL and self.inPQTL > 0 then
    self:PQTLP_CS_TmpFix()
    self.inPQTL = self.inPQTL - 1
  end
  self.isSkipBreak = false
end

function PlotStoryManager:StopProgressById(plotid)
  for i = #self.plotList, 1, -1 do
    if self.plotList[i].plotid == plotid then
      self.plotList[i]:ShutDown()
      break
    end
  end
  for i = #self.freePlotList, 1, -1 do
    if self.freePlotList[i].plotid == plotid then
      self.freePlotList[i]:ShutDown()
      break
    end
  end
end

function PlotStoryManager:StopFreeProgress(id, tryBreakRepetition)
  for i = #self.freePlotList, 1, -1 do
    if self.freePlotList[i].plotid == id then
      if tryBreakRepetition then
        self.freePlotList[i]:StopFreeProgress()
        break
      end
      self.freePlotList[i]:ShutDown()
      break
    end
  end
end

function PlotStoryManager:Stop()
  for i = #self.plotList, 1, -1 do
    self.plotList[i]:ShutDown()
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
end

function PlotStoryManager:StopFreePlot(doNotRestore)
  for i = #self.freePlotList, 1, -1 do
    self.freePlotList[i]:ShutDown(nil, doNotRestore)
  end
end

function PlotStoryManager:StopMultiProgress(pqtls)
  if pqtls then
    for i = 1, #pqtls do
      local pqtl_name = tostring(pqtls[i])
      local pqtl_id = self.multiPlayingPQTL[pqtl_name]
      if pqtl_id then
        Game.PlotStoryManager:StopProgressById(pqtl_id)
        self.multiPlayingPQTL[pqtl_name] = nil
      end
    end
  end
end

function PlotStoryManager:Launch(isMapInitLaunch)
  if self.running then
    return
  end
  self.running = true
  self.camera_endstay = false
  self.inPQTL = 0
  for i = 1, #self.plotList do
    self.plotList[i]:Launch()
  end
  self:ExcuteForceQueue()
  if isMapInitLaunch then
    self:TryExecuteMapPlot()
  end
end

function PlotStoryManager:Update(time, deltaTime)
  if self.ps_delayInstantFinish_CPTrigger_RestoreDefault then
    if self.ps_delayInstantFinish_CPTrigger_RestoreDefault <= 0 then
      self.ps_delayInstantFinish_CPTrigger_RestoreDefault = nil
      CameraController.singletonInstance:InterruptSmoothTo()
    else
      self.ps_delayInstantFinish_CPTrigger_RestoreDefault = self.ps_delayInstantFinish_CPTrigger_RestoreDefault - 1
    end
  end
  if not self.running then
    return
  end
  for i = 1, #self.plotList do
    self.plotList[i]:Update(time, deltaTime)
  end
  for i = 1, #self.freePlotList do
    if self.freePlotList[i] then
      self.freePlotList[i]:Update(time, deltaTime)
    end
  end
  for _, npc in pairs(self.npcMap) do
    npc:Update(time, deltaTime)
  end
end

function PlotStoryManager:Shutdown(isSkipBreak, doNotRestore)
  if not self.running then
    return
  end
  self.running = false
  self.isSkipBreak = isSkipBreak
  self:Stop()
  self:StopFreePlot(doNotRestore)
  TableUtility.TableClear(self.multiPlayingPQTL)
  TableUtility.ArrayClear(self.branchPendingPlots)
  self:ClearUIView(true)
end

function PlotStoryManager:DoSkip()
  if self.pqtl_seq then
    if not self.running then
      return
    end
    self.isSkipBreak = true
    self:Stop()
  else
    self:Shutdown(true)
  end
end

function PlotStoryManager:DoSkipForVideoPanel()
  if self.pqtl_seq then
    if not self.running then
      return
    end
    self.isSkipBreak = true
    self:Stop()
  else
    self.isSkipBreak = true
    self:Stop()
    self:StopFreePlot(nil)
  end
end

PlotStoryManager.pqtl_seq = nil
PlotStoryManager.pqtl_seq_step = nil

function PlotStoryManager:Start_SEQ_PQTLP(pqtl_seq, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, skipDelay, anchorPos, anchorDir)
  if type(pqtl_seq) == "table" and #pqtl_seq == 1 then
    return self:Start_PQTLP(pqtl_seq[1], plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, nil, skipDelay, anchorPos, anchorDir)
  elseif type(pqtl_seq) == "string" then
    return self:Start_PQTLP(pqtl_seq, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, nil, skipDelay, anchorPos, anchorDir)
  end
  if not self.running then
    return false
  end
  self.endCall = plotEndCall
  self.endCallParam = plotEndCallParam
  self.pqtl_seq = pqtl_seq
  self.pqtl_seq_params = {
    plotEndCall,
    plotEndCallParam,
    customNpclist,
    plotStoryShowSkip,
    fixedDuration,
    extraParams,
    isLoopPlay,
    startFromPct,
    plotStartCall,
    plotStartCallParam
  }
  self.pqtl_seq_step = 0
  self.pqtl_seq_current = nil
  return self:StepOn_SEQ_PQTLP()
end

function PlotStoryManager:StepOn_SEQ_PQTLP()
  if self.pqtl_seq_current and not self.pqtl_seq_current.keep then
    self:Clear()
  end
  self.pqtl_seq_step = self.pqtl_seq_step + 1
  if self.pqtl_seq == nil or #self.pqtl_seq < self.pqtl_seq_step then
    Game.AssetManager_Role:SetForceLoadAll(false)
    self:TryDoEndCall()
    self.pqtl_seq = nil
    self.pqtl_seq_step = nil
    self.pqtl_seq_current = nil
    return
  end
  local pqtl_name = self.pqtl_seq[self.pqtl_seq_step]
  local launchResult = self:Launch_SEQ_PQTLP(pqtl_name)
  if not launchResult then
    return self:StepOn_SEQ_PQTLP()
  else
    return launchResult
  end
end

function PlotStoryManager:Launch_SEQ_PQTLP(pqtl_name)
  local pqtl_id = PQTL_Manager.Instance:Create_PQTL(pqtl_name)
  if pqtl_id == 0 then
    return false
  end
  local isFreePlot = self.curPendingPQTLisFreePlot == -1
  local plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay = self.pqtl_seq_params[1], self.pqtl_seq_params[2], self.pqtl_seq_params[3], self.pqtl_seq_params[4], self.pqtl_seq_params[5], self.pqtl_seq_params[6], self.pqtl_seq_params[7]
  local plot_id = pqtl_id
  local pstlp = PlotStoryTimelineProcess.new(plot_id, pqtl_name, isFreePlot, fixedDuration, extraParams, isLoopPlay, nil, nil, nil, plotStoryShowSkip)
  if self.pstlp_timeline_params_cache and self.pstlp_timeline_params_cache[plot_id] then
    pstlp:CSNotify_PQTLP_Start(self.pstlp_timeline_params_cache[plot_id])
    self.pstlp_timeline_params_cache[plot_id] = nil
  end
  if not self.pstlp_list then
    self.pstlp_list = {}
  end
  self.pstlp_list[plot_id] = pstlp
  self.pqtl_seq_current = pstlp
  if not self.curPQTLisBranch and not isFreePlot then
    self:Stop()
    self.cameraDirty = false
    FunctionSystem.WeakInterruptMyself()
    FunctionSystem.InterruptMyselfAI()
    Game.AssetManager_Role:SetForceLoadAll(true)
    if not Game.MapManager:IsPVEMode_ChasingScene() then
      self:ShowPlotStoryView(plotStoryShowSkip)
    end
    if Game.HandUpManager then
      Game.HandUpManager:MaunalClose()
    end
  end
  if customNpclist then
    local cacheTable = self.customNpcList_Map[PlotConfig_Prefix.PQTL]
    cacheTable[pstlp.plot_id] = customNpclist
  end
  pstlp:AddEventListener(PlotStoryEvent.End, self.EndPlotProgress, self)
  pstlp:AddEventListener(PlotStoryEvent.ShutDown, self.ShutDownProgress, self)
  if isFreePlot then
    table.insert(self.freePlotList, pstlp)
  else
    table.insert(self.plotList, pstlp)
  end
  if self.running then
    pstlp:Launch()
    self.inPQTL = self.inPQTL + 1
  end
  return plot_id
end

function PlotStoryManager:Start_PQTLP(pqtl_name, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, needRestore, skipDelay, anchorPos, anchorDir)
  if not self.running then
    return false
  end
  local pqtl_id
  if anchorPos and anchorDir then
    pqtl_id = PQTL_Manager.Instance:Create_PQTLInstance(pqtl_name, anchorPos, anchorDir)
  else
    pqtl_id = PQTL_Manager.Instance:Create_PQTL(pqtl_name)
  end
  return self:Create_PSTLP(pqtl_id, pqtl_name, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, needRestore, skipDelay)
end

function PlotStoryManager:Start_Multi_PQTLP(pqtls)
  if pqtls then
    for i = 1, #pqtls do
      local pqtl_name = tostring(pqtls[i].id)
      local params = QuestDataUtil.parseParams(pqtls[i].param.params)
      local isLoop = params.isLoop == 1
      local pqtl_id = Game.PlotStoryManager:Start_PQTLP(pqtl_name, nil, nil, nil, true, nil, nil, isLoop)
      self.multiPlayingPQTL[pqtl_name] = pqtl_id
    end
  end
end

function PlotStoryManager:Start_Preview_PQTLP(pqtl_id, pqtl_name, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, needRestore, skipDelay)
  if not self.running then
    return false
  end
  return self:Create_PSTLP(pqtl_id, pqtl_name, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, needRestore, skipDelay)
end

function PlotStoryManager:Create_PSTLP(plot_id, pqtl_name, plotEndCall, plotEndCallParam, customNpclist, plotStoryShowSkip, fixedDuration, extraParams, isLoopPlay, startFromPct, plotStartCall, plotStartCallParam, needRestore, skipDelay)
  if plot_id == 0 then
    return false
  end
  local isFreePlot = self.curPendingPQTLisFreePlot == -1
  self.pqtl_seq = nil
  local pstlp = PlotStoryTimelineProcess.new(plot_id, pqtl_name, isFreePlot, fixedDuration, extraParams, isLoopPlay, plotStartCall, plotStartCallParam, needRestore, plotStoryShowSkip)
  if self.pstlp_timeline_params_cache and self.pstlp_timeline_params_cache[plot_id] then
    pstlp:CSNotify_PQTLP_Start(self.pstlp_timeline_params_cache[plot_id])
    self.pstlp_timeline_params_cache[plot_id] = nil
  end
  if not self.pstlp_list then
    self.pstlp_list = {}
  end
  self.pstlp_list[plot_id] = pstlp
  if not self.curPQTLisBranch and not isFreePlot then
    self:Stop()
    self.cameraDirty = false
    self.autoBattleIds = {}
    local loadIds = Game.Myself:Client_GetAutoBattleLockIDs()
    for k, v in pairs(loadIds) do
      table.insert(self.autoBattleIds, k)
    end
    self.autoBattleOn = Game.AutoBattleManager.on
    self.autoStanding = Game.Myself:IsAutoBattleStanding()
    FunctionSystem.WeakInterruptMyself()
    FunctionSystem.InterruptMyselfAI()
    Game.AssetManager_Role:SetForceLoadAll(true)
    if not Game.MapManager:IsPVEMode_ChasingScene() then
      self:ShowPlotStoryView(plotStoryShowSkip, skipDelay)
    end
    if Game.HandUpManager then
      Game.HandUpManager:MaunalClose()
    end
  else
    self.autoBattleIds = nil
    self.autoBattleOn = nil
  end
  pstlp:SetEndCall(plotEndCall, plotEndCallParam)
  if customNpclist then
    local cacheTable = self.customNpcList_Map[PlotConfig_Prefix.PQTL]
    cacheTable[pstlp.plot_id] = customNpclist
  end
  pstlp:AddEventListener(PlotStoryEvent.End, self.EndPlotProgress, self)
  pstlp:AddEventListener(PlotStoryEvent.ShutDown, self.ShutDownProgress, self)
  if isFreePlot then
    table.insert(self.freePlotList, pstlp)
  else
    table.insert(self.plotList, pstlp)
  end
  if self.running then
    pstlp:Launch()
    if startFromPct and 0 < startFromPct and startFromPct < 1 then
      PQTL_Manager.Instance:LuaCtrl_PQTL_StartFrom(plot_id, startFromPct)
    end
    PQTL_Manager.Instance:LuaCtrl_PQTL_CheckLuaActionPreload(plot_id)
    self.inPQTL = self.inPQTL + 1
  end
  return plot_id
end

function PlotStoryManager:Get_PQTLP(plot_id)
  return self.pstlp_list and self.pstlp_list[plot_id]
end

function PlotStoryManager:CSNotify_PQTLP_End(plot_id, wait_stop_watching)
  local pstlp = self:Get_PQTLP(plot_id)
  if not pstlp then
    return
  end
  if pstlp:OnPlotEndCheckClaimCrossScene() then
    return
  end
  if wait_stop_watching then
    pstlp:MarkWaitStopWatching()
    return
  end
  pstlp:PlotEnd()
  TableUtility.TableRemove(self.multiPlayingPQTL, plot_id)
  self.curPendingPQTLisFreePlot = -1
end

function PlotStoryManager:CSNotify_PQTLP_Start(plot_id, timeline_params)
  self.curPendingPQTLisFreePlot = timeline_params and timeline_params.freeView
  self.curPQTLisBranch = timeline_params and timeline_params.branch == 1
  local pstlp = self:Get_PQTLP(plot_id)
  if pstlp then
    pstlp:CSNotify_PQTLP_Start(timeline_params)
  else
    if not self.pstlp_timeline_params_cache then
      self.pstlp_timeline_params_cache = {}
    end
    self.pstlp_timeline_params_cache[plot_id] = timeline_params
  end
end

function PlotStoryManager:CSNotify_PQTLP_LoadingMask(plot_id, isShow)
  local pstlp = self:Get_PQTLP(plot_id)
  if pstlp then
    pstlp:CSNotify_PQTLP_LoadingMask(isShow)
  end
end

function PlotStoryManager:CSNotify_PQTLP_FinishHalt(plot_id, caster)
  local pstlp = self:Get_PQTLP(plot_id)
  if pstlp then
    pstlp:CSNotify_PQTLP_FinishHalt(caster)
  end
end

function PlotStoryManager:PQTLP_CS_TmpFix()
end

function PlotStoryManager:LocalChangeWeather(wid)
  LogUtility.InfoFormat("<color=green>PQ WeatherChange: </color>{0}", wid)
  ServiceWeatherProxy.Instance:PlayWeatherEffect(wid)
end

function PlotStoryManager:RestoreToServerWeather()
  ServiceWeatherProxy.Instance:PlayWeatherEffect(ServiceWeatherProxy.Instance.weatherID)
end

function PlotStoryManager:SetRoleDefaultMoveSpd(role)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  local roleData = role and role.data
  if roleData then
    local moveSpdProp = roleData.props:GetPropByName("MoveSpd")
    role:Client_SetMoveSpeed(moveSpdProp:GetValue())
  end
end

function PlotStoryManager:SetRoleMoveSpd(role, moveSpd, moveSpdFactor)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.roleMoveSpdCache then
    self.roleMoveSpdCache = {}
  end
  local roleData = role and role.data
  if roleData then
    local id = roleData.id
    local moveSpdProp = roleData.props:GetPropByName("MoveSpd")
    if self.roleMoveSpdCache[id] == nil then
      self.roleMoveSpdCache[id] = moveSpdProp:GetValue()
    end
    local newSpd = (moveSpd or moveSpdProp:GetValue()) * (moveSpdFactor or 1)
    role:Client_SetMoveSpeed(newSpd)
  end
end

function PlotStoryManager:SetRoleMoveActionSpd(role, actionSpd)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.roleActionSpdCache then
    self.roleActionSpdCache = {}
  end
  local id = role and role.data and role.data.id
  if id then
    local actionSpeed = role:Logic_GetMoveActionSpeed()
    self.roleActionSpdCache[id] = {id = id, actionSpd = actionSpeed}
  end
  role:Logic_SetMoveActionSpeed(actionSpd)
end

function PlotStoryManager:ResetMoveSpd(role)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.roleMoveSpdCache then
    self.roleMoveSpdCache = {}
  end
  if role then
    local oriSpd = self.roleMoveSpdCache[role.data.id]
    if oriSpd then
      local moveSpdProp = role.data.props:GetPropByName("MoveSpd")
      moveSpdProp:SetValue(oriSpd * 1000)
      role:Client_SetMoveSpeed(moveSpdProp:GetValue())
    end
  else
    for roleid, oriSpd in pairs(self.roleMoveSpdCache) do
      local role = SceneCreatureProxy.FindCreature(roleid)
      if role then
        local moveSpdProp = role.data.props:GetPropByName("MoveSpd")
        moveSpdProp:SetValue(oriSpd * 1000)
        role:Client_SetMoveSpeed(moveSpdProp:GetValue())
      end
    end
  end
end

function PlotStoryManager:ResetMoveActionSpd(role)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.roleActionSpdCache then
    return
  end
  if role then
    local id = role.data and role.data.id
    local cache = self.roleActionSpdCache[id]
    if cache then
      role:Logic_SetMoveActionSpeed(cache.actionSpd)
    end
  else
    for id, cache in pairs(self.roleActionSpdCache) do
      local role = SceneCreatureProxy.Instance:FindCreature(id)
      if role and cache then
        role:Logic_SetMoveActionSpeed(cache.actionSpd)
      end
    end
  end
end

function PlotStoryManager:RecordPlotStoryOnCameraPoint(groupid)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not Game.IsLocalEditorGame then
    return
  end
  if not self.plotstory_on_campoints then
    self.plotstory_on_campoints = {}
  end
  if TableUtility.ArrayFindIndex(self.plotstory_on_campoints, groupid) == 0 then
    TableUtility.ArrayPushBack(self.plotstory_on_campoints, groupid)
  end
end

function PlotStoryManager:RemovePlotStoryOnCameraPoint(groupid)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not Game.IsLocalEditorGame then
    return
  end
  if not self.plotstory_on_campoints then
    self.plotstory_on_campoints = {}
  else
    TableUtility.ArrayRemove(self.plotstory_on_campoints, groupid)
  end
end

function PlotStoryManager:RecordPlotStorySceneFilter(filter)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.plotstory_scene_filters then
    self.plotstory_scene_filters = {}
  end
  if TableUtility.ArrayFindIndex(self.plotstory_scene_filters, filter) == 0 then
    TableUtility.ArrayPushBack(self.plotstory_scene_filters, filter)
  end
end

function PlotStoryManager:RemovePlotStorySceneFilter(filter)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.plotstory_scene_filters then
    self.plotstory_scene_filters = {}
  else
    TableUtility.ArrayRemove(self.plotstory_scene_filters, filter)
  end
end

function PlotStoryManager:RestorePlotStorySceneFilter()
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if self.plotstory_scene_filters then
    for i = 1, #self.plotstory_scene_filters do
      FunctionSceneFilter.Me():EndFilter(self.plotstory_scene_filters[i])
    end
    TableUtility.ArrayClear(self.plotstory_scene_filters)
  end
end

function PlotStoryManager:RecordOriRolePart(creature, params)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  local uid, assetRole = creature.data.id, creature.assetRole
  if not self.plotstory_record_ori_roleparts then
    self.plotstory_record_ori_roleparts = {}
  end
  if self.plotstory_record_ori_roleparts[uid] then
    return
  end
  local tempPartArray = Asset_Role.CreatePartArray()
  assetRole:GetPartsInfo(tempPartArray)
  self.plotstory_record_ori_roleparts[uid] = {
    tempPartArray,
    params.Partner ~= true
  }
end

function PlotStoryManager:RestoreOriRoleParts()
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.plotstory_record_ori_roleparts then
    return
  end
  local rolePartArray, partnerInvisible, target
  for k, _ in pairs(self.plotstory_record_ori_roleparts) do
    rolePartArray = self.plotstory_record_ori_roleparts[k][1]
    partnerInvisible = self.plotstory_record_ori_roleparts[k][2]
    target = SceneCreatureProxy.FindCreature(k)
    if target then
      target.assetRole:Redress(rolePartArray)
    end
    Asset_Role.DestroyPartArray(rolePartArray)
    if partnerInvisible then
      target:SetPartnerVisible(true, PlotStoryProcess.ChangePartInvisibleReason)
    end
  end
  TableUtility.TableClear(self.plotstory_record_ori_roleparts)
end

function PlotStoryManager:AddMyTempEffect(epPathKey)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if not self.my_temp_effect then
    self.my_temp_effect = {}
  end
  if epPathKey then
    self.my_temp_effect[epPathKey] = true
  end
end

function PlotStoryManager:RemoveMyTempEffect(epPathKey)
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if self.my_temp_effect and epPathKey then
    self.my_temp_effect[epPathKey] = nil
  end
end

function PlotStoryManager:ClearMyTempEffect()
  if self.inPQTL and self.inPQTL > 0 then
    return
  end
  if self.my_temp_effect then
    for epPathKey, _ in pairs(self.my_temp_effect) do
      Game.Myself:RemoveEffect(epPathKey)
      self.my_temp_effect[epPathKey] = nil
    end
  end
end

function PlotStoryManager:TryExecuteMapPlot()
  local currentMap = SceneProxy.Instance.currentScene
  local currentMapPlot = currentMap and Table_Map[currentMap.mapID]
  currentMapPlot = currentMapPlot and currentMapPlot.Plot
  if not currentMapPlot then
    return
  end
  for i = 1, #currentMapPlot do
    Game.PlotStoryManager:Start_PQTLP(currentMapPlot[i])
  end
end

function PlotStoryManager:PlotBreakRepetition(plotid, toCoda)
  for i = #self.plotList, 1, -1 do
    if self.plotList[i].plotid == plotid then
      self.plotList[i]:BreakRepetition(toCoda)
      break
    end
  end
  for i = #self.freePlotList, 1, -1 do
    if self.freePlotList[i].plotid == plotid then
      self.freePlotList[i]:BreakRepetition(toCoda)
      break
    end
  end
end

function PlotStoryManager:ManualMove()
  if self.inManualMove then
    return
  end
  self.inManualMove = true
  if self.manualControlTarget and self.targetPos then
    local curPos = self.manualControlTarget:GetPosition()
    LuaVector3.Better_Sub(self.targetPos, curPos, tempV3)
    local squreDis = tempV3[1] * tempV3[1] + tempV3[2] * tempV3[2] + tempV3[3] * tempV3[3]
    if 0.25 < squreDis then
      self.manualControlTarget:Client_DirMove(tempV3, false, self.customMoveActionName)
    else
      self:ManualMoveStop()
    end
  end
end

function PlotStoryManager:ManualMoveStop()
  if not self.inManualMove then
    return
  end
  self.inManualMove = false
  if self.manualControlTarget then
    self.manualControlTarget:Client_DirMoveEnd(self.customIdleAction)
  end
end

function PlotStoryManager:StartManualMove(target, targetPos, customMoveActionName, customIdleAction, showGuide)
  self.manualControlTarget = target
  self.targetPos = targetPos
  self.customMoveActionName = customMoveActionName
  self.customIdleAction = customIdleAction
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.ShowRoleController, showGuide)
end

function PlotStoryManager:EndManualMove(target)
  if self.manualControlTarget == target then
    GameFacade.Instance:sendNotification(PlotStoryViewEvent.HideRoleController)
    self:ManualMoveStop()
    self.manualControlTarget = nil
    self.targetPos = nil
  end
end

function PlotStoryManager:EnterBranch(pqtl_id)
  self.branchPendingPlots[#self.branchPendingPlots + 1] = pqtl_id
end

function PlotStoryManager:ExitBranch()
  TableUtility.ArrayClearByDeleter(self.branchPendingPlots, function(pqtl_id)
    self:StopProgressById(pqtl_id)
  end)
end

function PlotStoryManager:IsFreeView()
  local isFreePlot = self.curPendingPQTLisFreePlot == -1
  return isFreePlot
end

function PlotStoryManager:isInPQTL()
  if not self.inPQTL then
    return false
  end
  return self.inPQTL > 0
end
