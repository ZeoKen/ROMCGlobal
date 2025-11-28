autoImport("PlotStoryProcess")
PlotStoryTimelineProcess = class("PlotStoryTimelineProcess", PlotStoryProcess)
local ResultState = {WAIT = 1, SUCCESS = 2}

function PlotStoryTimelineProcess:ctor(fake_plotid, pqtl_name, isFreePlot, fixedDuration, extraParams, loopPlay, plotStartCall, plotStartCallParam, needRestore, plotStoryShowSkip)
  self.plotid = fake_plotid
  self.pqtl = pqtl_name
  self.running = false
  self.parallelStep = {}
  self.isFreePlot = isFreePlot
  self.fixedDuration = fixedDuration
  self.extraParams = extraParams
  self.isBlockToLoop = loopPlay
  self.needRestore = needRestore
  self.plotStartCalled = false
  self.plotStartCall = plotStartCall
  self.plotStartCallParam = plotStartCallParam
  self.plotStoryShowSkip = plotStoryShowSkip
  self.dialogState = 0
  self.sceneObjectEffectMap = {}
  self.sceneObjectAudioIds = {}
  self.typeFuncResult = {}
  self.specificFilterMap = {}
  self.curveEffects = {}
  self.curveMoveTargets = {}
  self:set_need_bwwatch()
end

local FLAG_NEW_TIME_VER = false

function PlotStoryTimelineProcess:ResetTimer()
  if FLAG_NEW_TIME_VER then
    self:SyncTimer()
  else
    self.time = 0
    self.rts = UnityRealtimeSinceStartup + self.time
    self.time_2 = 0
  end
end

local syncInterval = 0.3

function PlotStoryTimelineProcess:SyncTimer()
  self.time = PQTL_Manager.Instance:LuaCtrl_PQTL_GetTime(self.plotid)
  self.syncDelta = 0
  self:OnSyncTimer()
end

function PlotStoryTimelineProcess:RefreshTimer(deltaTime)
  if FLAG_NEW_TIME_VER then
    if not self.syncDelta then
      return
    end
    self.syncDelta = self.syncDelta + deltaTime
    if self.syncDelta > syncInterval then
      self:SyncTimer()
    end
  else
    if not self.rts then
      return
    end
    self.time = UnityRealtimeSinceStartup - self.rts
    if deltaTime then
      self.time_2 = self.time_2 + deltaTime
    end
    self.time = math.max(self.time, self.time_2)
  end
end

function PlotStoryTimelineProcess:OnSyncTimer()
  if self.endMaskInfo and self.time + self.endMaskInfo.duration / 2 > self.timeline_duration then
    self:_TryTriggerEndMask()
  end
end

function PlotStoryTimelineProcess:_TryTriggerEndMask()
  if self.endMaskInfo then
    self:show_mask({
      inTime = self.endMaskInfo.config.inTime,
      mask_color = self.endMaskInfo.config.mask_color,
      mask_alpha = self.endMaskInfo.config.mask_alpha,
      outTime = self.endMaskInfo.config.outTime,
      time = self.endMaskInfo.config.duration
    })
    self.endMaskInfo = nil
  end
end

function PlotStoryTimelineProcess:_TrySetDefaultSceneFilter()
  if not self.timeline_params then
    return
  end
  if self.timeline_params.applyDefaultSceneFilter then
    self:AddStep(0, 0, "startfilter", {
      filter = GameConfig.PQTL and GameConfig.PQTL.DefaultSceneFilter or 1,
      isApplyDefault = true
    })
  end
end

function PlotStoryTimelineProcess:CSNotify_PQTLP_Start(timeline_params)
  self.timeline_params = timeline_params
  self.timeline_duration = self.timeline_params.duration
  if self.timeline_params and self.timeline_params.startMask then
    local maskConfig = GameConfig.PQTL and GameConfig.PQTL.MaskConfig and GameConfig.PQTL.MaskConfig[self.timeline_params.startMask]
    if maskConfig then
      local maskDuration = self.timeline_params.startMaskDuration or maskConfig.duration
      self:show_mask({
        inTime = maskConfig.inTime,
        mask_color = maskConfig.mask_color,
        mask_alpha = maskConfig.mask_alpha,
        outTime = maskConfig.outTime,
        time = maskDuration
      })
    end
  end
  if self.timeline_params and self.timeline_params.endMask then
    local maskConfig = GameConfig.PQTL and GameConfig.PQTL.MaskConfig and GameConfig.PQTL.MaskConfig[self.timeline_params.endMask]
    if maskConfig then
      local maskDuration = self.timeline_params.endMaskDuration or maskConfig.duration
      self.endMaskInfo = {config = maskConfig, duration = maskDuration}
    end
  end
  if self.timeline_params and self.timeline_params.freeView ~= -1 then
    FunctionSceneFilter.Me():StartFilter(56)
  end
end

function PlotStoryTimelineProcess:Launch(useless_param1)
  if self.running then
    return
  end
  self.running = true
  self.elapsed = 0
  self:ResetTimer()
  if not self.isFreePlot then
    Game.PlotStoryManager:PS_SetCameraPlotStyle(true)
    if Game.PerformanceManager then
      Game.PerformanceManager:SkinWeightHigh(true)
    end
  end
  if not (not self.needRestore and self.isFreePlot) or not self.keep then
    self.processRecorder = PlotStoryProcessRecorder.new()
    self.processRecorder:Launch(self)
  end
  self:_TrySetDefaultSceneFilter()
end

function PlotStoryTimelineProcess:Update(time, deltaTime)
  self:RefreshTimer(deltaTime)
  if not self.running then
    return
  end
  local step
  for i = 1, #self.parallelStep do
    step = self.parallelStep[i]
    if not (step.type and step.param) or not self[step.type] then
      self:ErrorLog_Plot(step.type)
      step.result = false
    end
    if (not step.halt or step.halt ~= 1) and step.result == nil then
      if not step.halt and self.needHandleBWWatch and self["BWWatch_" .. step.type] then
        step.halt = self["BWWatch_" .. step.type](self, step.param, time, deltaTime, step)
      end
      step.resultRaw = {
        self[step.type](self, step.param, time, deltaTime, step)
      }
      step.result = step.resultRaw[1]
      if step.result == false then
        step.result = nil
      end
    end
  end
  for i = #self.parallelStep, 1, -1 do
    step = self.parallelStep[i]
    if step.result ~= nil then
      if step.sendback_result then
        PQTL_Manager.Instance:ReceiveLuaActionResult(self.plotid, self.pqtl, step.caster, step.trigger_type, step.result)
      end
      if self.processRecorder and self.processRecorder["Post_" .. step.type] then
        self.processRecorder["Post_" .. step.type](self.processRecorder, step.param, select(2, unpack(step.resultRaw)))
      end
      ReusableTable.DestroyTable(self.parallelStep[i])
      table.remove(self.parallelStep, i)
    end
  end
  if self.fixedDuration and self.fixedDuration > 0 then
    self.elapsed = self.elapsed + deltaTime
    if self.elapsed >= self.fixedDuration then
      if PQTL_Manager.Instance:LuaCtrl_PQTL_ContainsCoda(self.plotid) then
        self.fixedDuration = nil
        PQTL_Manager.Instance:LuaCtrl_PQTL_BreakRepetition(self.plotid, true)
      else
        self:ShutDown(true)
      end
    end
  end
end

function PlotStoryTimelineProcess:ShutDown(isDurationEnd, doNotRestore)
  if not self.running then
    return
  end
  self.running = false
  if self.processRecorder then
    if self.needRestore or not doNotRestore then
      self.processRecorder:Restore()
    end
    self.processRecorder:ShutDown()
    self.processRecorder = nil
  end
  self.isBreakShutdown = not isDurationEnd
  PQTL_Manager.Instance:LuaNotifyShutDown_PQTL(self.plotid)
  if not self.isFreePlot then
    if Game.PlotStoryManager:IsSeqPlotProgressEnd() then
      Game.PlotStoryManager:PS_SetCameraPlotStyle(false)
    end
    if Game.PerformanceManager then
      Game.PerformanceManager:SkinWeightHigh(false)
    end
  end
  self:_TryTriggerEndMask()
  if self.random_talk_runstate then
    ReusableTable.DestroyTable(self.random_talk_runstate)
    self.random_talk_runstate = nil
  end
  if self.pqtl_object_map then
    TableUtility.TableClearByDeleter(self.pqtl_object_map, function(go)
      if not LuaGameObject.ObjectIsNull(go) then
        local rets = StringUtil.Split(go.name, "_")
        GameObject.Destroy(go)
        Game.AssetManager:UnloadAsset(ResourcePathHelper.RoleBody(rets[1]))
      end
    end)
  end
  if self.sceneObjectEffectMap then
    TableUtility.TableClearByDeleter(self.sceneObjectEffectMap, function(effect)
      effect:Destroy()
    end)
  end
  if self.sceneObjectAudioIds then
    TableUtility.ArrayClearByDeleter(self.sceneObjectAudioIds, function(audioId)
      NSceneEffectProxy.Instance:RemoveAudio(audioId)
    end)
  end
  if self.curveMoveTargets then
    TableUtility.TableClearByDeleter(self.curveMoveTargets, function(t)
      local targets = t[1]
      local oriActionSpd = t[3]
      for i = 1, #targets do
        local target = targets[i]
        if target.assetRole then
          target:Logic_SetMoveActionSpeed(oriActionSpd)
          target:Client_SetIsMoveToWorking(false)
          target:Logic_PlayAction_Idle()
        end
      end
    end)
  end
  if self.curveEffects then
    TableUtility.TableClearByDeleter(self.curveEffects, function(effect)
      effect:Destroy()
    end)
  end
  if self.specificFilterMap then
    for id, data in pairs(self.specificFilterMap) do
      local counterwise = data.counterwise
      if data.useSpecific then
        local targets = self:_getTargetByParams(data)
        local contents = ReusableTable.CreateArray()
        self:_getFilterContentsByParams(data, contents)
        if 0 < #contents then
          for i = 1, #targets do
            local creature = targets[i]
            if creature then
              SceneFilterProxy.Instance:SceneFilterUnCheckWithContents(id, contents, creature, counterwise)
            end
          end
        end
        ReusableTable.DestroyAndClearArray(contents)
      else
        FunctionSceneFilter.Me():EndFilterById(data.pqtl_id)
        self:_delCustomFilter(data)
      end
      self.specificFilterMap[id] = nil
    end
  end
  if self.mapNpc then
    TableUtility.TableClearByDeleter(self.mapNpc, function(uniqueId)
      NSceneNpcProxy.Instance:Remove(uniqueId)
    end)
  end
  if self.timeline_params and self.timeline_params.freeView ~= -1 then
    FunctionSceneFilter.Me():EndFilter(56)
  end
  self:PassEvent(PlotStoryEvent.ShutDown, self)
end

function PlotStoryTimelineProcess:IsPlayEnd()
  return not self.isBreakShutdown and not self.st_BreakRepetition
end

function PlotStoryTimelineProcess:PlotEnd()
  self.super.PlotEnd(self)
  TableUtility.ArrayClearByDeleter(self.parallelStep, function(step)
    ReusableTable.DestroyTable(step)
  end)
end

function PlotStoryTimelineProcess:GetExtraParam(key)
  return self.extraParams and self.extraParams[key]
end

function PlotStoryTimelineProcess:AddStep(caster, trigger_type, action_type, action_param, need_result, simple_blend_info, ff_pct, ff_time)
  local step = ReusableTable.CreateTable()
  step.plotid = self.plotid
  step.halt = nil
  step.caster = caster
  step.trigger_type = trigger_type
  step.type = action_type
  step.param = action_param
  step.sendback_result = need_result
  step.simple_blend_info = simple_blend_info
  step.ff_pct = ff_pct
  step.ff_time = ff_time
  step.param.pqtl_id = caster
  table.insert(self.parallelStep, step)
  if self.processRecorder and self.processRecorder["Pre_" .. step.type] then
    self.processRecorder["Pre_" .. step.type](self.processRecorder, step.param)
  end
  if not self.plotStartCalled then
    self.plotStartCalled = true
    if self.plotStartCall then
      self.plotStartCall(self.plotStartCallParam, self)
    end
  end
end

function PlotStoryTimelineProcess:_getTargetByParams(params, refIndex)
  local tempTargets = PlotStoryTimelineProcess.super._getTargetByParams(self, params)
  if #tempTargets == 0 and params._refParam and 0 < #params._refParam then
    refIndex = refIndex or 1
    local refTarget = self:_getTargetByExParams(params._refParam[refIndex])
    if type(refTarget) == "number" then
      refTarget = SceneCreatureProxy.FindCreature(refTarget)
      if refTarget then
        table.insert(tempTargets, refTarget)
      end
    elseif type(refTarget) == "table" and not refTarget._is_multi then
      table.insert(tempTargets, refTarget)
    elseif type(refTarget) == "table" and refTarget._is_multi then
      for i = 1, #refTarget do
        local r = refTarget[i]
        if type(r) == "number" then
          r = SceneCreatureProxy.FindCreature(r)
        end
        if r then
          table.insert(tempTargets, r)
        end
      end
    end
  end
  return tempTargets
end

function PlotStoryTimelineProcess:_getTargetByExParams(key_enum)
  return self.extraParams and self.extraParams[key_enum]
end

function PlotStoryTimelineProcess:summon(params)
  if params.waitaction_loop == nil then
    params.waitaction_loop = false
  end
  return self.super.summon(self, params)
end

function PlotStoryTimelineProcess:summon_map_npc(params)
  local uniqueId = params.uniqueid
  local targets = self:_getTargetByParams(params)
  if #targets == 0 then
    if not uniqueId and params._refParam and 0 < #params._refParam then
      uniqueId = self:_getTargetByExParams(params._refParam[1])
    end
    local npcId = Game.MapManager:GetNpcIDByUniqueID(uniqueId)
    local pos = Game.MapManager:GetNpcPosByUniqueID(uniqueId)
    local npcConfig = Table_Npc[npcId]
    if npcConfig and npcConfig.Feature == 64 then
      NavMeshUtility.SelfSample(pos, 1)
    end
    local dir = Game.MapManager:GetNpcDirByUniqueID(uniqueId)
    local data = {}
    data.npcID = npcId
    data.id = uniqueId
    data.pos = {
      x = pos[1] * 1000,
      y = pos[2] * 1000,
      z = pos[3] * 1000
    }
    data.datas = {}
    data.attrs = {}
    data.mounts = {}
    data.staticData = npcConfig
    data.name = npcConfig.NameZh
    data.searchrange = 0
    local creature = NSceneNpcProxy.Instance:Add(data, NNpc)
    creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
    if npcConfig.ShowName then
      creature.data.userdata:Set(UDEnum.SHOWNAME, npcConfig.ShowName)
    end
    if npcConfig.Scale then
      creature:Server_SetScaleCmd(npcConfig.Scale, true)
    end
    if npcConfig.Behaviors then
      creature.data:SetBehaviourData(npcConfig.Behaviors)
    end
    local noAccessable = creature.data:NoAccessable()
    creature.assetRole:SetColliderEnable(not noAccessable)
    local waitaction = Game.MapManager:GetNpcWaitActionByUniqueID(uniqueId)
    if not StringUtil.IsEmpty(waitaction) then
      creature:Server_PlayActionCmd(waitaction)
    end
    if not self.mapNpc then
      self.mapNpc = {}
    end
    self.mapNpc[uniqueId] = uniqueId
  end
  return true
end

function PlotStoryTimelineProcess:play_effect(params)
  params.id = params.uid
  params.onshot = params.loop ~= true
  return self.super.play_effect(self, params)
end

function PlotStoryTimelineProcess:play_effect_scene(params)
  params.id = params.uid
  params.onshot = params.loop ~= true
  return self.super.play_effect_scene(self, params)
end

function PlotStoryTimelineProcess:remove_effect_scene(params)
  params.id = params.uid
  return self.super.remove_effect_scene(self, params)
end

function PlotStoryTimelineProcess:playCurveMotionEffect(params)
  local path = params.path
  local pos = params.pos
  Asset_Effect.PlayAt(path, pos, function(effectHandle, args, assetEffect)
    self.curveEffects[params.pqtl_id] = assetEffect
  end)
  return true
end

function PlotStoryTimelineProcess:removeCurveMotionEffect(params)
  local effect = self.curveEffects[params.pqtl_id]
  if effect then
    effect:Destroy()
    self.curveEffects[params.pqtl_id] = nil
  end
  return true
end

function PlotStoryTimelineProcess:shakescreen(params)
  params.time = (CameraAdditiveEffectShake.INFINITE_DURATION - 1) * 1000
  return self.super.shakescreen(self, params)
end

function PlotStoryTimelineProcess:addbutton(params)
  local state = Game.PlotStoryManager:GetButtonState(self.plotid, params.id)
  if not state then
    params.eventtype = "goon"
    local cr = self.super.addbutton(self, params)
  elseif state == 2 then
    Game.PlotStoryManager:SetButtonState(self.plotid, params.id)
    return true
  end
  return false
end

function PlotStoryTimelineProcess:client_ai_patrol(params, time, deltaTime)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    target.ai:PushCommand(FactoryAICMD.GetClientPatrolCmd(params.randomRange, params.randomSeed, params.duration, params.pause_duration, params.ignoreNavMesh), target)
  end
  return true
end

function PlotStoryTimelineProcess:client_ai_chase_target(params, time, deltaTime)
  local ref_myself = self:_getTargetByParams(params)
  local ref_target = self:_getTargetByParams(params, 2)
  if 0 < #ref_myself and 0 < #ref_target then
    for i = 1, #ref_myself do
      local target = ref_myself[i]
      target.ai:PushCommand(FactoryAICMD.GetClientChaseTargetCmd(ref_target[1], params.duration, params.range, params.moveSpeed), target)
    end
  end
  return true
end

function PlotStoryTimelineProcess:client_ai_avoid_target(params, time, deltaTime)
  local ref_myself = self:_getTargetByParams(params)
  local ref_target = self:_getTargetByParams(params, 2)
  if 0 < #ref_myself and 0 < #ref_target then
    for i = 1, #ref_myself do
      local target = ref_myself[i]
      target.ai:PushCommand(FactoryAICMD.GetClientAvoidTargetCmd(ref_target[1], params.duration, params.range, params.moveSpeed), target)
    end
  end
  return true
end

function PlotStoryTimelineProcess:block(params)
  if self.isBlockToLoop then
    PQTL_Manager.Instance:LuaCtrl_PQTL_JumpTo(self.plotid, 0)
    return true
  end
  return false
end

function PlotStoryTimelineProcess:noaction(params)
  return true
end

function PlotStoryProcess:random_talk(params, time, deltaTime)
  if not self.random_talk_runstate then
    if params._refParam and #params._refParam > 0 then
      local cfg = self:_getTargetByExParams(params._refParam[2])
      if not cfg then
        redlog("random_talk", "refParam not set")
        return true
      end
      self.random_talk_runstate = ReusableTable.CreateTable()
      self.random_talk_runstate.cur = 0
      self.random_talk_runstate.curT = 0
      self.random_talk_runstate.interval = cfg[1]
      self.random_talk_runstate.times = #cfg - 1
      self.random_talk_runstate.infinite = params.infinite
      local talk = {}
      for i = 2, #cfg do
        table.insert(talk, cfg[i])
      end
      self.random_talk_runstate.talk = {}
      while 0 < #talk do
        local n = math.random(#talk)
        table.insert(self.random_talk_runstate.talk, talk[n])
        table.remove(talk, n)
      end
    else
      redlog("random_talk", "refParam not set")
      return true
    end
  end
  self.random_talk_runstate.cur = self.random_talk_runstate.cur + deltaTime
  if self.random_talk_runstate.cur >= self.random_talk_runstate.interval then
    self.random_talk_runstate.curT = self.random_talk_runstate.curT + 1
    self.random_talk_runstate.cur = 0
    local dialogId = self.random_talk_runstate.talk[self.random_talk_runstate.curT]
    local msg = DialogUtil.GetDialogData(dialogId) and DialogUtil.GetDialogData(dialogId).Text
    local targets = self:_getTargetByParams(params)
    for i = 1, #targets do
      local target = targets[i]
      local sceneUI = target:GetSceneUI()
      if sceneUI then
        sceneUI.roleTopUI:Speak(msg, target, true)
      end
    end
    if self.random_talk_runstate.curT >= self.random_talk_runstate.times then
      if self.random_talk_runstate.infinite then
        self.random_talk_runstate.curT = 0
      else
        if self.random_talk_runstate then
          ReusableTable.DestroyTable(self.random_talk_runstate)
          self.random_talk_runstate = nil
        end
        return true
      end
    end
  end
end

function PlotStoryTimelineProcess:start_manual_move(params)
  local pos = params.pos
  if not pos then
    self:ErrorLog_Plot()
    return true
  end
  local move_action_name = params.custom_move_action and Table_ActionAnime[params.custom_move_action]
  move_action_name = move_action_name and move_action_name.Name
  local idle_action_name = params.custom_idle_action and Table_ActionAnime[params.custom_idle_action]
  idle_action_name = idle_action_name and idle_action_name.Name
  local targets = self:_getTargetByParams(params)
  local target = targets[1]
  local moveSpd = target:Client_GetMoveSpeed()
  local moveActionSpd = target:Logic_GetMoveActionSpeed()
  local moveActionName = target:Client_GetMoveToCustomActionName()
  if params.spd or params.spdFactor then
    local roleData = target and target.data
    if roleData then
      local moveSpdProp = roleData.props:GetPropByName("MoveSpd")
      local newSpd = (params.spd or moveSpdProp:GetValue()) * (params.spdFactor or 1)
      target:Client_SetMoveSpeed(newSpd)
    end
  end
  if params.actionSpd then
    target:Logic_SetMoveActionSpeed(params.actionSpd)
  end
  Game.PlotStoryManager:StartManualMove(target, pos, move_action_name, idle_action_name, params.showGuide)
  return true, target, moveSpd, moveActionSpd, moveActionName
end

function PlotStoryTimelineProcess:end_manual_move(params)
  local targets = self:_getTargetByParams(params)
  local target = targets[1]
  Game.PlotStoryManager:EndManualMove(target)
  return true
end

function PlotStoryTimelineProcess:start_curve_move(params)
  local move_action_name = params.custom_move_action and Table_ActionAnime[params.custom_move_action]
  move_action_name = move_action_name and move_action_name.Name
  local expression = params.custom_expression
  local targets = self:_getTargetByParams(params)
  local target = targets[1]
  local oriActionSpd = target:Logic_GetMoveActionSpeed()
  target:Logic_SetMoveActionSpeed(params.actionSpd)
  target:Client_SetIsMoveToWorking(true)
  target:Client_PlayActionMove(move_action_name, nil, true, nil, nil, nil, expression, true)
  self.curveMoveTargets[params.pqtl_id] = {
    targets,
    params,
    oriActionSpd
  }
  return true
end

function PlotStoryTimelineProcess:end_curve_move(params)
  local targets = self.curveMoveTargets[params.pqtl_id] and self.curveMoveTargets[params.pqtl_id][1]
  local oriActionSpd = self.curveMoveTargets[params.pqtl_id] and self.curveMoveTargets[params.pqtl_id][3]
  local idle_action_name = params.custom_idle_action and Table_ActionAnime[params.custom_idle_action]
  idle_action_name = idle_action_name and idle_action_name.Name
  local expression = params.custom_expression
  if targets then
    for i = 1, #targets do
      local target = targets[i]
      if target ~= nil then
        target:Logic_SetMoveActionSpeed(oriActionSpd)
        target:Client_SetIsMoveToWorking(false)
        target:Client_PlayActionIdle(idle_action_name, nil, nil, nil, nil, nil, nil, expression, true)
      end
    end
    self.curveMoveTargets[params.pqtl_id] = nil
  end
  return true
end

function PlotStoryTimelineProcess:add_credits(params)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.AddCredits, params)
  return true
end

function PlotStoryTimelineProcess:add_image(params)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.AddEDImage, params)
  return true
end

function PlotStoryTimelineProcess:play_ed_video(params)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.PlayEDVideo, params)
  return true
end

function PlotStoryTimelineProcess:move(params)
  local pos = params.pos
  if not pos then
    self:ErrorLog_Plot()
    return true
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
    return true
  end
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  local moveEndCall = function(owner)
    self.typeFuncResult[params.pqtl_id] = ResultState.SUCCESS
  end
  params.moveEndCall = moveEndCall
  PlotStoryTimelineProcess.super.move(self, params)
  return false
end

function PlotStoryTimelineProcess:start_continually_dialog(params)
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  local viewName = "DialogView"
  if params.isExtendDialog then
    viewName = "ExtendDialogView"
  end
  local viewdata = {
    viewname = viewName,
    dialoglist = params.dialog,
    keepOpen = params.keepOpen,
    viewdata = {
      reEntnerNotDestory = params.reEnter
    }
  }
  
  function viewdata.callback(owner)
    owner.typeFuncResult[params.pqtl_id] = ResultState.SUCCESS
  end
  
  viewdata.callbackData = self
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  if params.roleSpeak and not params.isExtendDialog then
    self:_dialog_roleSpeak(params)
  end
  return true
end

function PlotStoryTimelineProcess:end_contiunally_dialog(params)
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
  end
  return true
end

function PlotStoryTimelineProcess:BreakRepetition(toCoda)
  if PQTL_Manager.Instance:LuaCtrl_PQTL_ContainsCoda(self.plotid) then
    self.fixedDuration = nil
    self.st_BreakRepetition = true
    PQTL_Manager.Instance:LuaCtrl_PQTL_BreakRepetition(self.plotid, toCoda or false)
  end
end

function PlotStoryTimelineProcess:StopFreeProgress()
  if PQTL_Manager.Instance:LuaCtrl_PQTL_ContainsCoda(self.plotid) then
    self:BreakRepetition(true)
  else
    self:ShutDown()
  end
end

function PlotStoryTimelineProcess:ProcessPreload(caster, trigger_type, action_type, param)
  if self["PRELOAD_" .. action_type] then
    self["PRELOAD_" .. action_type](self, param)
  end
end

function PlotStoryTimelineProcess:PRELOAD_play_effect(params)
  Asset_Effect.PreloadToPool(params.path)
end

function PlotStoryTimelineProcess:PRELOAD_play_effect_scene(params)
  Asset_Effect.PreloadToPool(params.path)
end

function PlotStoryTimelineProcess:PRELOAD_start_qte(params)
  FunctionQTE.Me():ResetQteOrderInfo()
end

function PlotStoryTimelineProcess:PRELOAD_qte_step(params)
  FunctionQTE.Me():AddQteOrderInfo(params)
end

function PlotStoryTimelineProcess:PRELOAD_qte_permanent_start(params)
  FunctionQTE.Me():AddQteOrderInfo(params)
end

local CurveMoveTargetType = {EFFECT = 1, ROLE = 2}

function PlotStoryTimelineProcess:UpdateCurvePos(caster, curvePos, targetType)
  if targetType == CurveMoveTargetType.EFFECT then
    local assetEffect = self.curveEffects[caster]
    if assetEffect and assetEffect.effectTrans then
      assetEffect.effectTrans.position = curvePos
    end
  elseif targetType == CurveMoveTargetType.ROLE then
    self:UpdateCurveMoveRole(caster, curvePos)
  end
end

local IsNull = Slua.IsNull

function PlotStoryTimelineProcess:UpdateCurveMoveRole(caster, curvePos)
  if self.curveMoveTargets[caster] then
    local targets = self.curveMoveTargets[caster][1]
    local params = self.curveMoveTargets[caster][2]
    local ignoreNavMesh = params.ignoreNavMesh
    if targets then
      for i = 1, #targets do
        local target = targets[i]
        if target == nil or target.assetRole == nil or IsNull(target) or IsNull(target.assetRole) then
        else
          if ignoreNavMesh then
            target:Logic_PlaceTo(curvePos)
          else
            target:Logic_NavMeshPlaceTo(curvePos)
          end
          target.assetRole:RotateTo(curvePos)
        end
      end
    end
  end
end

function PlotStoryTimelineProcess:enter_photograph(params)
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
    return true
  end
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  local cameraId = params.cameraId
  local useCurCameraZAndFov = params.useCurCameraFov
  local hideExitBtn = params.hideExitButton
  local callback = function(owner)
    owner.typeFuncResult[params.pqtl_id] = ResultState.SUCCESS
  end
  local callbackParam = self
  local cameraController = CameraController.singletonInstance
  local currentInfo = cameraController.currentInfo
  currentInfo.fieldOfView = cameraController.activeCamera.fieldOfView
  cameraController:PlotAct_RestoreDefault(0)
  cameraController:SetInfo(currentInfo)
  Game.PlotStoryManager:CloseUIView(PlotStoryManager.PlotStoryUIId)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PhotographPanel,
    force = true,
    viewdata = {
      cameraId = cameraId,
      useCurCameraZAndFov = useCurCameraZAndFov,
      hideExitBtnTemp = hideExitBtn,
      callback = callback,
      callbackParam = callbackParam
    }
  })
  Game.PlotStoryManager:AddToUIMap(PanelConfig.PhotographPanel)
  return false
end

function PlotStoryTimelineProcess:quest_step(params)
  local questId = params.questId
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  end
  return true
end

function PlotStoryTimelineProcess:start_specific_filter(params)
  local id = params.id
  local counterwise = params.counterwise
  if params.useSpecific then
    local checkContents = ReusableTable.CreateArray()
    self:_getFilterContentsByParams(params, checkContents)
    local targets = self:_getTargetByParams(params)
    for i = 1, #targets do
      local creature = targets[i]
      if creature then
        SceneFilterProxy.Instance:SceneFilterCheckWithContents(id, checkContents, creature, counterwise)
      end
    end
    ReusableTable.DestroyAndClearArray(checkContents)
  else
    self:_addCustomFilter(params)
    FunctionSceneFilter.Me():StartFilterById(params.pqtl_id, nil, counterwise)
  end
  if not self.specificFilterMap[id] then
    self.specificFilterMap[id] = params
  end
  return true
end

function PlotStoryTimelineProcess:end_specific_filter(params)
  local id = params.id
  local ori_params = self.specificFilterMap[id]
  if ori_params then
    local counterwise = ori_params.counterwise
    if ori_params.useSpecific then
      local checkContents = ReusableTable.CreateArray()
      self:_getFilterContentsByParams(ori_params, checkContents)
      local targets = self:_getTargetByParams(ori_params)
      if 0 < #checkContents then
        for i = 1, #targets do
          local creature = targets[i]
          if creature then
            SceneFilterProxy.Instance:SceneFilterUnCheckWithContents(id, checkContents, creature, counterwise)
          end
        end
      end
      ReusableTable.DestroyAndClearArray(checkContents)
    else
      FunctionSceneFilter.Me():EndFilterById(ori_params.pqtl_id)
      self:_delCustomFilter(ori_params)
    end
    self.specificFilterMap[id] = nil
  end
  return true
end

function PlotStoryTimelineProcess:_getFilterContentsByParams(params, checkContents)
  for k, v in pairs(params) do
    if v and SceneFilterDefine.Content[k] then
      checkContents[#checkContents + 1] = SceneFilterDefine.Content[k]
    end
  end
end

function PlotStoryTimelineProcess:_addCustomFilter(params)
  local id = params.pqtl_id
  if Table_ScreenFilter[id] then
    redlog("StartFilterByCustomConfig", id, "exist in Table_ScreenFilter!")
    return
  end
  if not self.customFilterIds then
    self.customFilterIds = {}
  end
  self.customFilterIds[id] = id
  local customFilter = {
    id = id,
    Group = id,
    Classifys = _EmptyTable,
    Targets = {},
    Range = {},
    ParamCond = _EmptyTable,
    Content = {},
    Name = id
  }
  for k, v in pairs(params) do
    if v and SceneFilterDefine.Target[k] then
      customFilter.Targets[#customFilter.Targets + 1] = SceneFilterDefine.Target[k]
    end
    if v and SceneFilterDefine.Range[k] then
      customFilter.Range[#customFilter.Range + 1] = SceneFilterDefine.Range[k]
    end
    if v and SceneFilterDefine.Content[k] then
      customFilter.Content[#customFilter.Content + 1] = SceneFilterDefine.Content[k]
    end
  end
  Table_ScreenFilter[id] = customFilter
end

function PlotStoryTimelineProcess:_delCustomFilter(params)
  local id = params.pqtl_id
  if self.customFilterIds and self.customFilterIds[id] then
    Table_ScreenFilter[id] = nil
    self.customFilterIds[id] = nil
  end
end

function PlotStoryTimelineProcess:OnPlotEndCheckClaimCrossScene()
  if not self.crossSceneParams then
    return
  end
  local inTime = self.crossSceneParams.inTime or 0.1
  local mask_color = self.crossSceneParams.mask_color or 1
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CrossSceneMaskView,
    viewdata = {inTime = inTime, color = mask_color}
  })
  FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
    GameFacade.Instance:sendNotification(PlotStoryViewEvent.HideMask)
  end)
  self.crossSceneParams = nil
  if self.endCall then
    self.endCall(self.endCallParam, self:IsPlayEnd(), self)
  end
  self.endCall = nil
  self.endCallParam = nil
  return true
end

function PlotStoryTimelineProcess:dialog_branch(params)
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
    return true
  end
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  Game.PlotStoryManager:EnterBranch(self.plotid)
  local viewName = "DialogView"
  if params.isExtendDialog then
    viewName = "ExtendDialogView"
  end
  local viewdata = {
    viewname = viewName,
    dialoglist = params.dialog
  }
  
  function viewdata.callback(questId, optionId)
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    if questData then
      QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionId)
    end
  end
  
  viewdata.callbackData = params.questId
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  return false
end

function PlotStoryTimelineProcess:dialog_branch_end(params)
  Game.PlotStoryManager:ExitBranch()
  return true
end

local tempPos = LuaVector3()

function PlotStoryTimelineProcess:BWWatch_place_to(params, _, _, step)
  local pos = params.pos
  local ignoreNavMesh = params.ignoreNavMesh
  local hasAnchorOrMount = params.anchor_ep or params.anchor_cp or params.anchor_mapnpcid or params.anchor_mapnpcuid
  if not hasAnchorOrMount and pos then
    LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
    if not ignoreNavMesh then
      NavMeshUtility.SelfSample(tempPos, sampleRange or 1)
    end
    local targets = self:_getTargetByParams(params)
    for i = 1, #targets do
      local target = targets[i]
      if self:NotifyWatchInfo(step.caster, target.data.id, tempPos) then
        return 1
      end
    end
  end
  return 2
end

function PlotStoryTimelineProcess:NotifyWatchInfo(caster_id, focus_guid, watch_pos)
  return PQTL_Manager.Instance:LuaNotifyWatchInfo(self.plotid, caster_id, focus_guid, watch_pos)
end

function PlotStoryTimelineProcess:FinishCurrentStepHalt(caster)
  for i = 1, #self.parallelStep do
    local step = self.parallelStep[i]
    if step.halt == 1 then
      if step.caster == caster then
        step.halt = 2
      else
        step.halt = 2
        redlog("FinishCurrentStepHalt error", step.caster, caster)
      end
    end
  end
end

function PlotStoryTimelineProcess:set_need_bwwatch()
  self.waitStopBWWatch = false
  self.needHandleBWWatch = not self.isFreePlot and Game.MapManager:IsBigWorld()
end

local bw_loading_show_mask_cfg = {
  mask_color = 1,
  mask_alpha = 1,
  inTime = 0.1
}
local bw_loading_hide_mask_cfg = {outTime = 0.1}
local loading_mask_type = 2

function PlotStoryTimelineProcess:CSNotify_PQTLP_LoadingMask(isShow)
  if loading_mask_type == 1 then
    if isShow then
      self:show_mask(bw_loading_show_mask_cfg)
    else
      self:hide_mask(bw_loading_hide_mask_cfg)
    end
  elseif isShow then
    self:show_bw_loading_mask()
  else
    self:hide_bw_loading_mask()
    if self.waitStopBWWatch then
      if PlotStoryView.Instance then
        PlotStoryView.Instance:SetPlotStoryClearDelayClose(800)
      end
      Game.PlotStoryManager:CSNotify_PQTLP_End(self.plotid)
      self.waitStopBWWatch = nil
    end
  end
end

function PlotStoryTimelineProcess:CSNotify_PQTLP_FinishHalt(caster)
  self:FinishCurrentStepHalt(caster)
end

function PlotStoryTimelineProcess:MarkWaitStopWatching()
  self.waitStopBWWatch = true
end
