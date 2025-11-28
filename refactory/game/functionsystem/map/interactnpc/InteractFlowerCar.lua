InteractFlowerCarPhaseData = class("InteractFlowerCarPhaseData")

function InteractFlowerCarPhaseData:ctor(cfg)
  self:Init(cfg)
end

function InteractFlowerCarPhaseData:Init(cfg)
  self.config = cfg
  self.timing = {}
  self.phase = 0
  local tim = 0
  for i = 1, #self.config do
    tim = self.config[i].time + tim
    table.insert(self.timing, tim)
  end
end

function InteractFlowerCarPhaseData:Reset()
  self.startTimeMS = nil
  self.phase = 0
end

function InteractFlowerCarPhaseData:SetStartTime(time)
  self.startTimeMS = time
end

function InteractFlowerCarPhaseData:CheckAllPhasesEnd()
  return self.phase < 0
end

function InteractFlowerCarPhaseData:CheckPhaseEnd(checkAnim)
  if checkAnim and self.phase > 0 and self.animator and self.targetAnimName then
    local stateInfo = self.animator:GetCurrentAnimatorStateInfo(0)
    local inTargetAnim = stateInfo and stateInfo:IsName("Base Layer." .. self.targetAnimName)
    if not inTargetAnim then
      local curElapsed = ServerTime.CurServerTime() - self.startTimeMS - (self.timing[self.phase - 1] or 0)
      self.animator:Play(self.targetAnimName, -1, curElapsed / self:GetPhaseConfig().time)
    else
      self.targetAnimName = nil
    end
  end
  return self.phase == 0 or ServerTime.CurServerTime() - self.startTimeMS > self.timing[self.phase]
end

function InteractFlowerCarPhaseData:CalculatePhaseElapsed()
  local curDelta = ServerTime.CurServerTime() - self.startTimeMS
  local _phase, _phaseElapsed = -1, -1
  for i = self.phase, #self.timing do
    if self.timing[i] and curDelta < self.timing[i] then
      _phase = i
      break
    end
  end
  if 0 < _phase then
    _phaseElapsed = curDelta - (self.timing[_phase - 1] or 0)
  end
  return _phase, _phaseElapsed
end

function InteractFlowerCarPhaseData:UpdatePhaseElapsed(dealingAnimator)
  self.phase, self.phaseElapsed = self:CalculatePhaseElapsed()
  if self.phase > 0 then
    self.phaseElapsedPct = self.phaseElapsed / self:GetPhaseConfig().time
  end
end

function InteractFlowerCarPhaseData:GetPhaseConfig()
  return self.config[self.phase]
end

function InteractFlowerCarPhaseData:GetFirstPhaseConfig()
  return self.config[1]
end

function InteractFlowerCarPhaseData:SetCheckAnim(targetAnimName, animator)
  self.targetAnimName = targetAnimName
  self.animator = animator
end

autoImport("InteractTrain")
InteractFlowerCar = class("InteractFlowerCar", InteractTrain)
local pos = LuaVector3.Zero()
local _GameFacade = GameFacade
local VectorDistanceXZ = VectorUtility.DistanceXZ_Square
local ArrayPushBack = TableUtility.ArrayPushBack
local LuaGetPosition = LuaGameObject.GetPosition
local checkInMagnetRangeInterval = 10

function InteractFlowerCar:DoConstruct(asArray, data)
  InteractFlowerCar.super.DoConstruct(self, asArray, data)
  for _, v in pairs(Table_FuncState) do
    if v.Type == "interact_npc" and v.Param[1] == self.id then
      self.funcStateId = v.id
      break
    end
  end
  self.arrivetimeMS = nil
  self.flowerCarId = self.staticData.Param.FlowerCarConfigId
  local cfgSet = GameConfig.FlowerCar or FlowerCarConfig
  self.flowerCarConfig = cfgSet[self.flowerCarId]
  if self.flowerCarConfig.onMountLocalNpc then
    self.mountNpcInfo = {}
    TableUtility.ArrayShallowCopy(self.mountNpcInfo, self.flowerCarConfig.onMountLocalNpc)
    self.mountNpc = {}
    self:TryGetMountLocalNpc()
  end
  if self.flowerCarConfig.pathPhaseConfig then
    self.pathPhase = InteractFlowerCarPhaseData.new(self.flowerCarConfig.pathPhaseConfig, self.pathAnimator)
  end
  self.actionPhase = InteractFlowerCarPhaseData.new(self.flowerCarConfig.actionPhaseConfig, self.actionAnimator)
  self.needCheckTrigger = not self:IsAuto() and self.flowerCarConfig.interact
  if self.needCheckTrigger then
    self.triggerCheckRange = self.staticData.Range
  end
  self.nextUpdateTime = 0
  self.getOnState = InteractNpc.GetOnState.Ready
  local objData = self:GetNpc()
  self.transform = objData.transform
  local triggerCount = tonumber(objData:GetProperty(0))
  self.triggerTransform = {}
  for i = 1, triggerCount do
    ArrayPushBack(self.triggerTransform, objData:GetComponentProperty(i - 1))
  end
  local cpCount = tonumber(objData:GetProperty(1))
  self.cpTransform = {}
  for i = 1, cpCount do
    self.cpTransform[i] = objData:GetComponentProperty(triggerCount + i - 1)
  end
  local l_objAnimator = objData:GetComponentProperty(triggerCount + cpCount)
  self.actionAnimator = l_objAnimator and l_objAnimator:GetComponent(Animator)
  l_objAnimator = objData:GetComponentProperty(triggerCount + cpCount + 1)
  self.pathAnimator = l_objAnimator and l_objAnimator:GetComponent(Animator)
  self.cmpDistanceTransform = self.actionAnimator.transform or self.transform
  self.audioSource3d = self.cmpDistanceTransform:GetComponent(AudioSource)
  self.checkInMagnetRangeTC = 0
end

function InteractFlowerCar:DoDeconstruct(asArray)
  InteractFlowerCar.super.DoDeconstruct(self, asArray)
  if self.mountNpc then
    TableUtility.ArrayClear(self.mountNpc)
  end
end

function InteractFlowerCar:UpdatePhase(time, deltaTime)
  if not self.startTimeMS or not self.duration then
    return
  end
  if not self.pathPhaseEnd or not self.actionPhaseEnd then
    if self.pathPhase and not self.pathPhaseEnd then
      self.pathPhaseEnd = self.pathPhase:CheckAllPhasesEnd()
      if not self.pathPhaseEnd and self.pathPhase:CheckPhaseEnd(true) then
        self:SetPathPhase()
      end
    end
    if not self.actionPhaseEnd then
      self.actionPhaseEnd = self.actionPhase:CheckAllPhasesEnd()
      if not self.actionPhaseEnd and (self.actionPhase:CheckPhaseEnd(true) or self:TryGetMountLocalNpc()) then
        self:SetActionPhase()
      end
    end
    if self.flowerCarConfig.magnetTarget then
      self.checkInMagnetRangeTC = self.checkInMagnetRangeTC + 1
      if self.checkInMagnetRangeTC > checkInMagnetRangeInterval then
        self.checkInMagnetRangeTC = 0
        local inMagnetRange = self:CheckInMagnetRange()
        if self.inMagnetRange ~= inMagnetRange then
          self.inMagnetRange = inMagnetRange
          Game.InteractNpcManager:SetMagnetLockTarget(self.id)
          self:NotifyMagnetStatus()
        end
        if self.inMagnet and not self:CheckInDistance(self.flowerCarConfig.leaveMagnetDistance) then
          Game.InteractNpcManager:SetMagnetLockTarget()
          self:DisableMagnet()
        end
      end
    end
    if self.pathPhaseEnd and self.actionPhaseEnd then
      self:EndPhaseAct()
    else
      self:SendUpdateMiniMap()
    end
  end
  if self.PlayerDoMagnetAction_cooldown then
    self.PlayerDoMagnetAction_cooldown = self.PlayerDoMagnetAction_cooldown - deltaTime
    if 0 > self.PlayerDoMagnetAction_cooldown then
      self.PlayerDoMagnetAction_cooldown = nil
    end
  end
  if self:CheckDurationEnd() then
    self:EndAndCheckNextRun()
  end
end

function InteractFlowerCar:CheckDurationEnd()
  return ServerTime.CurServerTime() - self.startTimeMS >= self.duration
end

function InteractFlowerCar:Update(time, deltaTime)
  if not self:IsInteractEnabled() then
    return false
  end
  local isTrigger = InteractFlowerCar.super.Update(self, time, deltaTime)
  if isTrigger and self:IsFull() then
    for _, v in pairs(self.cpMap) do
      if v == Game.Myself.data.id then
        return isTrigger
      end
    end
    return false
  end
  return isTrigger
end

function InteractFlowerCar:SetPathPhase()
  self.pathPhase:UpdatePhaseElapsed()
  if self.pathPhase:CheckAllPhasesEnd() then
    return
  end
  local cfg = self.pathPhase:GetPhaseConfig()
  if cfg.path_anim then
    self.pathPhase:SetCheckAnim(cfg.path_anim, self.pathAnimator)
    redlog(self.pathPhase.phase, ServerTime.CurServerTime() - self.startTimeMS, "SetPathPhase", self.flowerCarId .. " | " .. cfg.path_anim, self.pathPhase.phaseElapsedPct)
    if self.pathAnimator then
      self.pathAnimator:Play(cfg.path_anim, -1, self.pathPhase.phaseElapsedPct)
    else
      redlog("RO-136208")
    end
  end
end

function InteractFlowerCar:SetActionPhase()
  self.actionPhase:UpdatePhaseElapsed()
  if self.actionPhase:CheckAllPhasesEnd() then
    return
  end
  local cfg = self.actionPhase:GetPhaseConfig()
  if cfg.car_anim then
    self.actionPhase:SetCheckAnim(cfg.car_anim, self.actionAnimator)
    redlog(self.actionPhase.phase, ServerTime.CurServerTime() - self.startTimeMS, "SetActionPhase", self.flowerCarId .. " | " .. cfg.car_anim, self.actionPhase.phaseElapsedPct)
    if self.actionAnimator then
      self.transform.gameObject:SetActive(true)
      self.actionAnimator:Play(cfg.car_anim, -1, self.actionPhase.phaseElapsedPct)
    else
      redlog("RO-136208")
    end
  end
  if cfg.npc_action and self.mountNpc then
    for i = 1, #self.mountNpc do
      self.RoleModelPlayAction(self.mountNpc[i], cfg.npc_action, self.actionPhase.phaseElapsedPct)
    end
  end
  if cfg.plot_action and self.actionPhase.phaseElapsedPct < 0.95 then
    self.plot = Game.PlotStoryManager:Start_PQTLP(cfg.plot_action, nil, nil, nil, nil, nil, nil, nil, self.actionPhase.phaseElapsedPct, nil, nil, true)
  end
  if cfg.se3d and self.audioSource3d and self.actionPhase.phaseElapsedPct < 0.95 then
    local resPath = ResourcePathHelper.AudioSE(cfg.se3d)
    local clip = AudioUtility.GetAudioClip(resPath)
    if clip then
      self.audioSource3d:Stop()
      self.audioSource3d.volume = 1
      self.audioSource3d.clip = clip
      self.audioSource3d.time = self.actionPhase.phaseElapsed / 1000
      self.audioSource3d:Play()
    end
  end
end

function InteractFlowerCar:TryGetMountLocalNpc()
  if not self.mountNpcInfo or #self.mountNpcInfo == 0 then
    return
  end
  local foundNewNpc = false
  local localnpcs = Game.GameObjectManagers[Game.GameObjectType.LocalNPC].npcs
  for i = #self.mountNpcInfo, 1, -1 do
    if localnpcs[self.mountNpcInfo[i]] then
      table.insert(self.mountNpc, localnpcs[self.mountNpcInfo[i]].assetRole)
      table.remove(self.mountNpcInfo, i)
      foundNewNpc = true
    end
  end
  return foundNewNpc
end

function InteractFlowerCar.RoleModelPlayAction(roleModel, action, normalizedTime, reset, callBack)
  if not roleModel then
    return
  end
  reset = reset or true
  local params = Asset_Role.GetPlayActionParams(action)
  params[4] = normalizedTime or 0
  params[6] = reset
  params[7] = callBack
  roleModel:PlayAction(params)
end

function InteractFlowerCar:CheckInDistance(distance)
  LuaVector3.Better_Set(pos, LuaGetPosition(self.cmpDistanceTransform))
  return VectorDistanceXZ(pos, Game.Myself:GetPosition()) < distance * distance
end

function InteractFlowerCar:EnableMagnet()
  FunctionCameraEffect.Me():RecvCameraAction(self.flowerCarConfig.magnetConfig.cameraConfigStr)
  self.inMagnet = true
  self:NotifyMagnetStatus()
end

function InteractFlowerCar:DisableMagnet()
  FunctionCameraEffect.Me():CancelLockTarget(true)
  self.inMagnet = false
  self:NotifyMagnetStatus()
end

function InteractFlowerCar:NotifyMagnetStatus()
  _GameFacade.Instance:sendNotification(InteractNpcEvent.FlowerCarMagnetSightChange, {
    inRange = self.inMagnetRange,
    inMagnet = self.inMagnet
  })
end

local MAGNET_VIEW_PORT_RANGE = {
  x = {0.1, 0.9},
  y = {0.1, 0.9}
}

function InteractFlowerCar:CheckInMagnetRange()
  local inRange = self:CheckInDistance(self.flowerCarConfig.enterMagnetDistance)
  if inRange then
    LuaVector3.Better_Set(pos, LuaGetPosition(self.cmpDistanceTransform))
    local viewport = self.cam:WorldToViewportPoint(pos)
    inRange = viewport.x > MAGNET_VIEW_PORT_RANGE.x[1] and viewport.x < MAGNET_VIEW_PORT_RANGE.x[2] and viewport.y > MAGNET_VIEW_PORT_RANGE.y[1] and viewport.y < MAGNET_VIEW_PORT_RANGE.y[2] and viewport.z < self.cam.farClipPlane
  end
  return inRange
end

local action_cooldown = 5
local magnetActionEffectKey = "magnetActionEffectKey"

function InteractFlowerCar:PlayerDoMagnetAction()
  if self.PlayerDoMagnetAction_cooldown then
    return
  end
  self.PlayerDoMagnetAction_cooldown = action_cooldown
  local cfg = self.flowerCarConfig.magnetConfig
  local rand_action = RandomUtil.RandomInTable(cfg.playerAction)
  local rand_effect = RandomUtil.RandomInTable(cfg.playerEffect)
  Game.Myself:Client_PlayAction(rand_action)
  Game.Myself:RemoveEffect(magnetActionEffectKey)
  Game.Myself:PlayEffect(magnetActionEffectKey, rand_effect, cfg.playerEffectEP, nil, nil, true)
end

function InteractFlowerCar:ShutdownPlotShow()
  if self.plot then
    Game.PlotStoryManager:StopProgressById(self.plot)
    self.plot = nil
  end
end

function InteractFlowerCar:TryEnable()
  self.delayedCheckStartTick = nil
  if self.funcStateId and not FunctionUnLockFunc.checkFuncStateValid(self.funcStateId) then
    return
  end
  local startTimeMS, curDeltaMS, duration, delay = self:GetStartTimeMS()
  if not startTimeMS or not curDeltaMS then
    return
  end
  if curDeltaMS < -50 then
    delay = 1 - curDeltaMS
    if 3000 < delay then
      delay = delay / 3
    end
    redlog("InteractFlowerCar:TryEnable:Delay", delay)
    self.delayedCheckStartTick = TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
      self:TryEnable()
    end, self)
  else
    redlog("InteractFlowerCar:TryEnable", curDeltaMS)
    self:Start(startTimeMS, duration)
  end
end

function InteractFlowerCar:Disable()
  self:End()
  self:ShutdownPlotShow()
end

function InteractFlowerCar:Start(startTimeMS, duration)
  self.startTimeMS = startTimeMS or ServerTime.CurServerTime()
  self.duration = duration
  if math.abs(self.startTimeMS - ServerTime.CurServerTime()) < 500 then
    self.startTimeMS = ServerTime.CurServerTime()
  end
  if self.pathPhase then
    self.pathPhase:SetStartTime(self.startTimeMS)
  end
  self.actionPhase:SetStartTime(self.startTimeMS)
  if not self.cam then
    self.cam = NGUIUtil:GetCameraByLayername("Default")
  end
  EventManager.Me():DispatchEvent(InteractNpcEvent.FlowerCarStart)
end

function InteractFlowerCar:EndPhaseAct()
  self.transform.gameObject:SetActive(false)
  Game.InteractNpcManager:TryNotifyGetOff()
  Game.InteractNpcManager:SetMagnetLockTarget()
  self.inMagnetRange = false
  self:DisableMagnet()
  self:SendUpdateMiniMap(true)
end

function InteractFlowerCar:End()
  self.startTimeMS = nil
  self.pathPhaseEnd = nil
  self.actionPhaseEnd = nil
  self.PlayerDoMagnetAction_cooldown = nil
  self.checkInMagnetRangeTC = 0
  if self.pathPhase then
    self.pathPhase:Reset()
  end
  self.actionPhase:Reset()
  self:EndPhaseAct()
  EventManager.Me():DispatchEvent(InteractNpcEvent.FlowerCarEnd)
  self.cam = nil
  TimeTickManager.Me():ClearTick(self)
end

function InteractFlowerCar:IsInteractEnabled()
  return self.startTimeMS ~= nil and (self.pathPhase and not self.pathPhaseEnd or not self.actionPhaseEnd)
end

function InteractFlowerCar:EndAndCheckNextRun()
  self:End()
  self:TryEnable()
end

function InteractFlowerCar:CheckServerActivityBeginTime(dateStr)
  dateStr = dateStr or self.staticData.Param.BeginTime
  if not dateStr then
    return true
  end
  local time = KFCARCameraProxy.Instance:GetSelfCustomDate(dateStr)
  return time < ServerTime.CurServerTime() / 1000
end

local GetWeekDay = function()
  local usWeekDay = os.date("*t", ServerTime.CurServerTime() / 1000).wday - 1
  if usWeekDay == 0 then
    usWeekDay = 7
  end
  return usWeekDay
end

function InteractFlowerCar:GetStartTimeMS(noNeg)
  local weekDay = GetWeekDay()
  local runtimeCfg = self.staticData.Param.RunTime
  local curDate = os.date("*t", ServerTime.CurServerTime() / 1000)
  for i = 1, #runtimeCfg do
    if runtimeCfg[i].day == weekDay then
      local time = os.time({
        year = curDate.year,
        month = curDate.month,
        day = curDate.day,
        hour = runtimeCfg[i].hour,
        min = runtimeCfg[i].min,
        isdst = false
      }) * 1000
      local delta = ServerTime.CurServerTime() - time
      if delta < runtimeCfg[i].duration * 1000 and (not noNeg or 0 <= delta) then
        return time, delta, runtimeCfg[i].duration * 1000
      end
    end
  end
  local testRunTimeConfig = Game.InteractNpcManager.testFlowerCarRunTime
  if testRunTimeConfig and testRunTimeConfig.day == weekDay then
    local time = os.time({
      year = curDate.year,
      month = curDate.month,
      day = curDate.day,
      hour = testRunTimeConfig.hour,
      min = testRunTimeConfig.min,
      isdst = false
    }) * 1000
    local sss = os.date("*t", time / 1000)
    local delta = ServerTime.CurServerTime() - time
    if delta < testRunTimeConfig.duration * 1000 then
      return time, delta
    end
  end
end

function InteractFlowerCar:OnMountOpenPhotographUI()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DisneyFlowerCarPhotographPanel,
    viewdata = {
      cameraId = 3,
      interactid = self.id
    },
    force = true
  })
end

function InteractFlowerCar:OnMountClosePhotographUI()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, DisneyFlowerCarPhotographPanel.ViewType)
end

function InteractFlowerCar:GetOn(cpid, charid)
  InteractFlowerCar.super.GetOn(self, cpid, charid)
  self:OnMountOpenPhotographUI()
end

function InteractFlowerCar:GetOff(charid)
  self:OnMountClosePhotographUI()
  InteractFlowerCar.super.GetOff(self, charid)
end

function InteractFlowerCar:SendUpdateMiniMap(clear)
  if not self.flowerCarConfig.showMiniMap then
    return
  end
  local data
  if not clear then
    data = {
      guid = self.id,
      posx = self.cmpDistanceTransform.position.x,
      posy = self.cmpDistanceTransform.position.y,
      posz = self.cmpDistanceTransform.position.z
    }
  end
  GameFacade.Instance:sendNotification(InteractNpcEvent.FlowerCarUpdateMiniMap, data)
end

function InteractFlowerCar:PlayEffectOnCp(effect_path, cp)
  local cpTrans = self.cpTransform and self.cpTransform[cp] or self.transform
  if not cpTrans then
    redlog("InteractFlowerCar:PlayEffectOnCp", "fail to get transform")
    return
  end
  local effect = Asset_Effect.PlayOneShotOn(effect_path, cpTrans)
  if effect then
    effect:CreateWeakData()
    effect:PushBackWeakData(self)
  end
end
