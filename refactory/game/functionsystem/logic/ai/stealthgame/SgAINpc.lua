autoImport("AIStateMachine")
autoImport("AILethargy")
autoImport("AIPatrol")
autoImport("AIStand")
autoImport("AIShooting")
SgAIAlertType = {
  eNone = 0,
  eSmell = 1,
  eVision = 2
}
SgAINpc = class("SgAINpc", ReusableObject)

function SgAINpc:DoConstruct(asArray)
end

function SgAINpc:DoDeconstruct()
  self:removeNpc()
end

function SgAINpc:removeNpc()
  self.m_historyData = nil
  if self.m_stateMachine ~= nil then
    self.m_stateMachine:onDestroy()
  end
  if self.m_roleTopUI ~= nil then
    self.m_roleTopUI:RemoveSceneNpcAlert()
    self.m_roleTopUI = nil
  end
  if self.m_alertAudio ~= nil and not Slua.IsNull(self.m_alertAudio) then
    self.m_alertAudio:Stop()
    self.m_alertAudio = nil
  end
  if self.m_creature ~= nil then
    NSceneNpcProxy.Instance:Remove(self.m_uid)
    self.m_creature = nil
    self.m_stateMachine = nil
  end
  if self.m_tbData.DialogList ~= _EmptyTable then
    FunctionVisitNpc.Me():UnRegisterVisitShow(self.m_uid)
  end
  EventManager.Me():RemoveEventListener(VisitNpcEvent.AccessNpc, self.onVisitNpc, self)
  EventManager.Me():RemoveEventListener(VisitNpcEvent.AccessNpcEnd, self.onVisitNpcEnd, self)
  EventManager.Me():RemoveEventListener(StealthGameEvent.ClickMinMapLeave, self.onLeave, self)
  if not Slua.IsNull(self.m_goItem) then
    self.m_goItem:SetActive(false)
    GameObject.Destroy(self.m_goItem)
    self.m_goItem = nil
  end
  self.m_npc = nil
end

function SgAINpc:initData(npc, uid, historyData)
  self.m_npc = npc
  self.m_id = npc.m_tid
  self.m_uid = uid
  self.m_originBirthX, self.m_originBirthY, self.m_originBirthZ = LuaGameObject.GetPosition(self.m_npc.transform)
  self.m_birthX = self.m_originBirthX
  self.m_birthY = self.m_originBirthY
  self.m_birthZ = self.m_originBirthZ
  self.m_tbData = Table_NPCAIxinsuo[self.m_id]
  local data = {}
  data.npcID = self.m_tbData.id
  data.id = self.m_uid
  if historyData ~= nil then
    data.pos = {
      x = historyData.m_posX * 1000,
      y = historyData.m_posY * 1000,
      z = historyData.m_posZ * 1000
    }
    data.dir = historyData.m_dir
    if historyData.m_isChangedBirth then
      self.m_npc:ChangedBirth()
    else
      self.m_isChangedBirth = false
    end
    self.m_npc.IsDead = false
  else
    local a, b, c = LuaGameObject.GetPosition(npc.transform)
    local _, angle, _ = LuaGameObject.GetEulerAngles(npc.transform)
    self.m_birthAngleY = angle
    data.pos = {
      x = a * 1000,
      y = b * 1000,
      z = c * 1000
    }
    data.dir = angle
    self.m_isChangedBirth = SgAIManager.Me():isResetBirth(self.m_uid)
    self.m_npc.IsDead = false
  end
  data.datas = {}
  data.attrs = {}
  data.mounts = {}
  local staticData = Table_Npc[data.npcID]
  data.staticData = staticData
  if staticData.NameZh ~= nil then
    data.name = staticData.NameZh
  end
  data.searchrange = 0
  self.m_creature = NSceneNpcProxy.Instance:Add(data, NNpc)
  if staticData then
    if staticData.ShowName then
      self.m_creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
    end
    if staticData.Scale then
      self.m_creature:Server_SetScaleCmd(staticData.Scale, true)
    end
  end
  self.m_creature.assetRole:SetColliderEnable(true)
  self.m_creature.assetRole:SetPosition(npc.transform.position)
  self.m_isLoaded = false
  local isCanFindPossessed = false
  if self.m_tbData.penetrate == 1 then
    isCanFindPossessed = true
  end
  self.m_npc.IsPenetratePossessed = isCanFindPossessed
  if self.m_tbData.DefaultDialog ~= _EmptyTable then
    self.m_autoSpeakInterval = self.m_tbData.DefaultDialog.time / 1000
  end
  self.m_stateMachine = AIStateMachine.new(self)
  self:getStateMachine():switchByType(AIBehaviourType.eEmpty)
  self:setStateQueue(0)
  if self.m_tbData.cycle == nil or self.m_tbData.cycle == 0 then
    self.m_stateMachine:queueIsLoop(true)
  else
    self.m_stateMachine:queueIsLoop(false)
  end
  self.m_historyData = historyData
  self.m_isFindPlayer = false
  self:RemoveLookAtEffect()
  if self.m_tbData.vision ~= _EmptyTable then
    self.m_npc:AddVision(self.m_tbData.vision.radius, self.m_tbData.vision.angle)
  end
  if self.m_tbData.smell ~= nil and 0 < self.m_tbData.smell then
    self.m_npc:AddSmell(self.m_tbData.smell)
  end
  self:enabledDialog(false)
  self.m_oldRoateSpeed = self.m_creature.logicTransform:GetRotateSpeed()
  local rotateSpeed = self.m_tbData.RotateSpeed
  if nil == rotateSpeed then
    rotateSpeed = 1
  end
  self.m_creature.logicTransform:SetRotateSpeed(self.m_oldRoateSpeed * rotateSpeed)
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpc, self.onVisitNpc, self)
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpcEnd, self.onVisitNpcEnd, self)
  EventManager.Me():AddEventListener(StealthGameEvent.ClickMinMapLeave, self.onLeave, self)
  self.m_checkLoadedTick = TimeTickManager.Me():CreateTick(0, 1000, self.onNpcLoaded, self, self.m_uid)
  self.m_alertType = SgAIAlertType.eNone
  self.m_leaveBattle = false
end

function SgAINpc:onNpcLoaded()
  if not self.m_isLoaded and self.m_creature:HasAllPartLoaded() then
    TimeTickManager.Me():ClearTick(self, self.m_uid)
    self.m_checkLoadedTick = nil
    if self.m_historyData == nil then
      local _, angle, _ = LuaGameObject.GetEulerAngles(self.m_npc.transform)
      self:setAngleY(angle)
    else
      self:setAngleY(self.m_historyData.m_dir)
    end
    TimeTickManager.Me():CreateTick(500, 0, self.startStateMachine, self, self.m_uid)
    self:showItemIcon()
    self.m_isLoaded = true
    self.m_npc:SetAITransform(self:getAITransform())
  end
end

function SgAINpc:startStateMachine()
  if self.m_historyData == nil then
    self:getStateMachine():switchNext()
  else
    local histroyStateInfo = self.m_historyData.m_stateInfo
    if nil == histroyStateInfo then
      self:getStateMachine():switchNext()
    else
      self:setHistoryStateData(histroyStateInfo)
      self.m_stateMachine.m_curIndex = self.m_historyData.m_stateQueueIndex
      if #self.m_stateMachine.m_stateQueue < 1 then
        self:getStateMachine():switchByType(AIBehaviourType.eEmpty)
      else
        local data = self.m_stateMachine.m_stateQueue[self.m_stateMachine.m_curIndex]
        if data ~= nil then
          if 1 < #data then
            local time = self.m_stateMachine.m_stateQueue[self.m_stateMachine.m_curIndex][2]
            self:getStateMachine():switchByType(self.m_stateData.m_type, time)
          else
            self:getStateMachine():switchByType(self.m_stateData.m_type, 0)
          end
        end
      end
    end
  end
  TimeTickManager.Me():ClearTick(self, self.m_uid)
end

function SgAINpc:setStateQueue(t)
  self.m_stateMachine:clearQueue()
  if t == 0 then
    for _, value in ipairs(self.m_tbData.AIBehaviour1) do
      local time = value.time
      if time == nil then
        time = 0
      end
      self.m_stateMachine:addStateInQueue(value.type, time / 1000)
    end
  else
    for _, value in ipairs(self.m_tbData.AIBehaviour2) do
      local time = value.time
      if time == nil then
        time = 0
      end
      self.m_stateMachine:addStateInQueue(value.type, time / 1000)
    end
  end
end

function SgAINpc:beginMoveTo(pos, actionName, isPatrol, func, table)
  self.m_isMoving = true
  self.m_targetPosition = pos
  self.m_curMoveActionName = actionName
  self.m_funcArrive = func
  self.m_funcTable = table
  if self.m_testSpeed ~= nil and self.m_testSpeed > 0 then
    self.m_creature.logicTransform:SetMoveSpeed(self.m_testSpeed)
  elseif isPatrol ~= nil then
    if isPatrol then
      self.m_creature.logicTransform:SetMoveSpeed(self.m_tbData.normalPatrol)
    else
      self.m_creature.logicTransform:SetMoveSpeed(self.m_tbData.alertPatrol)
    end
  end
  self.m_creature:Logic_PlayAction_Simple(actionName)
  self.m_creature:Logic_NavMeshMoveTo(self.m_targetPosition)
end

function SgAINpc:endMove(isBreak)
  self:playAction("wait")
  self.m_creature:Logic_StopMove()
  self.m_isMoving = false
  self.m_targetPosition = nil
  self.m_curMoveActionName = nil
  if isBreak == nil or not isBreak then
    if self.m_funcTable ~= nil and self.m_funcArrive ~= nil then
      self.m_funcArrive(self.m_funcTable)
    end
  else
    self.m_funcTable = nil
    self.m_funcArrive = nil
  end
end

function SgAINpc:playAction(actionName)
  self.m_creature:Logic_PlayAction_Simple(actionName)
end

function SgAINpc:getAITransform()
  return self.m_creature.assetRole:GetRoleComplete().transform
end

function SgAINpc:changeEnterFieldType(value)
  self.m_alertType = value
end

function SgAINpc:enterField(value)
  self.m_alertType = value
  if self:IsVertigo() or self.m_stateMachine:isType(AIBehaviourType.eLethargy) or self.m_stateMachine:isType(AIBehaviourType.eEmpty) then
    return
  end
  self.m_isFindPlayer = true
  self:AddLookAtEffect()
  local alertState = self.m_stateMachine.m_allStates[AIBehaviourType.eAlert]
  if alertState ~= nil and alertState:getCurValue() >= 1 then
    self:getStateMachine():breakSwitch(AIBehaviourType.eAlertPatrol)
  else
    self:getStateMachine():breakSwitch(AIBehaviourType.eAlert)
  end
end

function SgAINpc:AddLookAtEffect()
  Game.Myself:PlayLookAtEffect(self.m_uid, EffectMap.Maps.cfx_play_tips_prf, RoleDefines_EP.Bottom, nil, true, true, self:getAITransform())
end

function SgAINpc:RemoveLookAtEffect()
  Game.Myself:RemoveLookAtEffect(self.m_uid)
end

function SgAINpc:exitField()
  self.m_isFindPlayer = false
  self:RemoveLookAtEffect(self.m_uid)
end

function SgAINpc:onLookAtPlayer()
  self.m_creature:LookAt(Game.Myself.assetRole:GetRoleComplete().transform.position)
end

function SgAINpc:onWakeUpByTrigger(triggerUid)
  self.m_curTriggerUid = triggerUid
  local playEnd = function()
    self.m_wakeUpByTriggerPlotId = nil
    if self.m_stateMachine:isType(AIBehaviourType.eAlert) or self.m_stateMachine:isType(AIBehaviourType.eAlertPatrol) then
      Game.PlotStoryManager:Start_PQTLP("11108", nil, nil, nil, false, nil, {
        myself = self.m_uid
      }, false)
    else
      local trigger = SgAIManager.Me():findTrigger(triggerUid)
      if nil ~= trigger then
        if trigger:getType() == SgTriggerType.eRubble then
          if self:doubtIslookAtTarget() then
            self:getStateMachine():breakSwitch(AIBehaviourType.eDoubtStand, 4)
          else
            self:getStateMachine():breakSwitch(AIBehaviourType.eDoubtMoveTo, 4)
          end
        elseif trigger:getType() == SgTriggerType.eMachine then
          self:getStateMachine():breakSwitch(AIBehaviourType.eMoveToLightUp)
        end
      end
    end
  end
  if self.m_stateMachine:isType(AIBehaviourType.eLethargy) then
    self.m_curTriggerUid = triggerUid
    if self.m_wakeUpByTriggerPlotId == nil then
      self.m_wakeUpByTriggerPlotId = Game.PlotStoryManager:Start_PQTLP("3035", playEnd, nil, nil, false, nil, {
        myself = self.m_creature.data.id
      }, false)
    end
  else
    playEnd()
  end
end

function SgAINpc:onWakeUpByNpc()
  if self:IsVertigo() then
    local playEnd = function()
      if self.m_leaveBattle then
        return
      end
      self:getStateMachine():switchByType(AIBehaviourType.ePatrol)
    end
    Game.PlotStoryManager:Start_PQTLP("3035", playEnd, nil, nil, false, nil, {
      myself = self.m_creature.data.id
    }, false)
  end
end

function SgAINpc:onFindLight(triggerUid)
  self.m_curTriggerUid = triggerUid
  self:getStateMachine():breakSwitch(AIBehaviourType.eMoveToLightUp)
end

function SgAINpc:getLightUpTrigger()
  return SgAIManager.Me():findTrigger(self.m_curTriggerUid)
end

function SgAINpc:isFindPlayer()
  return self.m_isFindPlayer
end

function SgAINpc:getUid()
  return self.m_uid
end

function SgAINpc:changedBirth()
  if self.m_isChangedBirth then
    return
  end
  self.m_isChangedBirth = true
  self.m_birthX, self.m_birthY, self.m_birthZ = LuaGameObject.GetPosition(self.m_npc.transform)
  local _, angle, _ = LuaGameObject.GetEulerAngles(self.m_npc.transform)
  self.m_birthAngleY = angle
  if self.m_stateMachine ~= nil then
    self.m_stateMachine:resetQueue()
    self:getStateMachine():switchByType(AIBehaviourType.eMoveToNewBirth)
  end
  SgAIManager.Me():npcResetBirth(self:getUid())
end

function SgAINpc:getStateMachine()
  return self.m_stateMachine
end

function SgAINpc:getPosition()
  return self.m_creature:GetPosition()
end

function SgAINpc:getForward()
  return LuaGameObject.GetTransformForward(self.m_creature.assetRole.complete)
end

function SgAINpc:killPlayer()
  SgAIManager.Me():setPlayerIsDead(true)
  SgAIManager.Me():CancelAttachNPC()
  Game.Myself:Client_NoMove(true)
  SgAIManager.Me():setIsGameOver(true)
  self.m_stateMachine:onDestroy()
  local playEnd = function()
    Game.Myself:Client_NoMove(false)
    if not self.m_leaveBattle then
      SgAIManager.Me():onRestart()
    end
  end
  redlog("结束游戏 play " .. 3043)
  SgAIManager.Me():RemoveLookAtEffect()
  Game.PlotStoryManager:Start_PQTLP("3043", playEnd, nil, nil, false, nil, {
    myself = self:getUid()
  }, false)
  if self.m_tbData.behavior.type == 1 then
    Game.PlotStoryManager:Start_PQTLP("3040", nil, nil, nil, false, nil, {
      myself = self:getUid()
    }, false)
    local arrNpcs = SgAIManager.Me():getAllNpcs()
    for _, n in ipairs(arrNpcs) do
      if not n:IsVertigo() and not n:isDead() and not n.m_stateMachine:isType(AIBehaviourType.eAlertPatrol) and not n:doubtIslookAtTarget() then
        local dis = LuaVector3.Distance(self.getPosition(), n:getPosition())
        if dis <= self.m_tbData.behavior.radius then
          n:setDogPos(self:getPosition())
          if n.m_stateMachine:isType(AIBehaviourType.eLethargy) then
            local playEnd = function(result)
              n:getStateMachine():breakSwitch(AIBehaviourType.eDoubtMoveTo, 4, true)
            end
            Game.PlotStoryManager:Start_PQTLP("3035", playEnd, nil, nil, false, nil, {
              myself = n:getUid()
            }, false)
          else
            n:getStateMachine():breakSwitch(AIBehaviourType.eDoubtMoveTo, 4, true)
          end
        end
      end
    end
  end
end

function SgAINpc:setDogPos(pos)
  local dir = pos - self:getPosition()
  local dis = LuaVector3.Distance(self:getPosition(), pos) - 0.2
  self.m_dogPos = self:getPosition() + dir.normalized * dis
end

function SgAINpc:getDogPos()
  return self.m_dogPos
end

function SgAINpc:onDead()
  self:getStateMachine():switchByType(AIBehaviourType.eDead)
  if self:getDropItem() ~= nil then
    for _, v in ipairs(self:getDropItem()) do
      SgAIManager.Me():playerAddItem(v, 1)
    end
  end
  local dialog = self:getMemoryDialog()
  if dialog and 0 < #dialog then
    SgAIManager.Me():AddMemory(dialog)
    RedTipProxy.Instance:UpdateRedTip(711)
    EventManager.Me():PassEvent(StealthGameEvent.Update_MemoryInfo)
  end
  local plotId = self.m_tbData.deadPlot
  if plotId ~= nil then
    Game.PlotStoryManager:Start_PQTLP(tostring(plotId), nil, nil, nil, false, nil, {
      myself = self.m_uid
    }, false)
  end
end

function SgAINpc:isDead()
  if nil == self.m_stateMachine then
    return true
  end
  return self.m_stateMachine:isType(AIBehaviourType.eDead)
end

function SgAINpc:IsVertigo()
  if nil == self.m_stateMachine then
    return false
  end
  return self.m_stateMachine:isType(AIBehaviourType.eVertigo)
end

function SgAINpc:isMoving()
  return self.m_isMoving ~= nil and self.m_isMoving
end

function SgAINpc:onUpdate(deltaTime)
  if self.m_stateMachine == nil then
    return
  end
  if self.m_isMoving then
    if self:isCanMove(self.m_targetPosition) then
      self.m_creature:Logic_PlayAction_Simple(self.m_curMoveActionName)
      self.m_creature:Logic_NavMeshMoveTo(self.m_targetPosition)
    else
      self:endMove()
    end
  end
  if self.m_goItem ~= nil then
    local dis = math.abs(LuaVector3.Distance(self:getPosition(), Game.Myself:GetPosition()))
    self.m_goItem:SetActive(dis < GameConfig.HeartLock.uiShowDistance)
  end
  if not self:IsVertigo() and not self.m_stateMachine:isType(AIBehaviourType.eMoveToVertigoNpc) then
    self.m_vetrigoNpc = SgAIManager.Me():getNpcArroundInVertigo(self)
    if self.m_vetrigoNpc ~= nil then
      self:getStateMachine():breakSwitch(AIBehaviourType.eMoveToVertigoNpc)
    end
  end
  self.m_stateMachine:onUpdate(deltaTime)
end

function SgAINpc:isCanMove(targetPos)
  if targetPos ~= nil then
    local dis = math.abs(LuaVector3.Distance_Square(self:getPosition(), targetPos))
    return 0.3 < dis
  end
  return false
end

function SgAINpc:getVertigoNpc()
  return self.m_vetrigoNpc
end

function SgAINpc:getBirthPosition()
  return {
    self.m_birthX,
    self.m_birthY,
    self.m_birthZ
  }
end

function SgAINpc:getBirthAngleY()
  return self.m_birthAngleY
end

function SgAINpc:isAlert()
  if not self.m_stateMachine then
    return false
  end
  return self.m_stateMachine:isType(AIBehaviourType.eAlert)
end

function SgAINpc:isAlertPatron()
  if not self.m_stateMachine then
    return false
  end
  return self.m_stateMachine:isType(AIBehaviourType.eAlertPatrol)
end

function SgAINpc:lookAtTrigger()
  local trigger = SgAIManager.Me():getCurTrigger()
  if trigger ~= nil then
    redlog("看向触发器")
    self.m_creature:LookAt(trigger:getPosition())
  end
end

function SgAINpc:getPatrolPosition()
  local ts = self.m_npc:GetNextPosition(self.m_isChangedBirth)
  if ts == nil then
    return LuaVector3.New()
  end
  local a, _, c = LuaGameObject.GetPosition(ts)
  local _, angle, _ = LuaGameObject.GetEulerAngles(ts)
  local pos = self:getPosition()
  return LuaVector3.New(a, pos[2], c), angle
end

function SgAINpc:setAngleY(value)
  self.m_creature.logicTransform:SetTargetAngleY(value)
end

function SgAINpc:getAiAlertAddSpeed()
  return self.m_tbData.alert.yellow
end

function SgAINpc:getAiAlertReduceSpeed()
  return self.m_tbData.alert.reduce
end

function SgAINpc:getAiAlertPatrolAddSpeed()
  return self.m_tbData.alert.red
end

function SgAINpc:getAiAlertPatrolReduceSpeed()
  return self.m_tbData.alert.reduce
end

function SgAINpc:getAiAlertPatrolTotalTimes()
  return self.m_tbData.patrolRadius.count
end

function SgAINpc:getAiAlertPatrolRadius()
  return self.m_tbData.patrolRadius.radius
end

function SgAINpc:doubtIslookAtTarget()
  return nil ~= self.m_tbData.doubt and 1 == self.m_tbData.doubt
end

function SgAINpc:getVisionRadius()
  if self.m_alertType == SgAIAlertType.eSmell then
    if self.m_tbData.smell ~= _EmptyTable then
      return self.m_tbData.smell
    end
  elseif self.m_tbData.vision ~= _EmptyTable then
    return self.m_tbData.vision.radius
  end
  return 0
end

function SgAINpc:inView(x, y, z)
  return self.m_npc:InView(x, y, z)
end

function SgAINpc:getSKill()
  if self.m_tbData.Transform_Skill == _EmptyTable then
    return nil
  end
  return self.m_tbData.Transform_Skill
end

function SgAINpc:getMemoryDialog()
  if self.m_tbData.memorydialog == _EmptyTable then
    return nil
  end
  return self.m_tbData.memorydialog
end

function SgAINpc:getDropItem()
  return self.m_tbData.item
end

function SgAINpc:getDogVoiceRadius()
  if self.m_tbData.behavior then
    return false, 0
  end
  return true, self.m_tbData.behavior.radius
end

function SgAINpc:getControlTime()
  return self.m_tbData.controltime
end

function SgAINpc:getWalkLimit()
  return self.m_tbData.WalkLimit
end

function SgAINpc:getAttachedSuccessPlotId()
  return self.m_tbData.AttachedSuccessPlotId
end

function SgAINpc:getDeadSpeak()
  return self.m_tbData.deadDialog
end

function SgAINpc:getHistoryStateData()
  return self.m_stateData
end

function SgAINpc:setHistoryStateData(value)
  self.m_stateData = value
end

function SgAINpc:getCurState()
  if self.m_stateMachine == nil then
    return nil
  end
  local state = self.m_stateMachine:getCurState()
  if state == nil then
    return
  end
  return state:getType()
end

function SgAINpc:isCanStop(tarPos)
  if nil == tarPos then
    return true
  end
  local aiPos = self:getPosition()
  local dis = SgAIManager:Me():getInstance():GetDistance(aiPos[1], aiPos[2], aiPos[3], tarPos[1], tarPos[2], tarPos[3])
  if 0.5 < dis then
    return false
  end
  return true
end

function SgAINpc:getData()
  local arg = {}
  arg.m_uid = self:getUid()
  if not self:isDead() then
    local state = self.m_stateMachine:getCurState()
    if state ~= nil then
      arg.m_stateInfo = state:getData()
    end
    arg.m_stateQueueIndex = self.m_stateMachine.m_curIndex
    local pos = self:getPosition()
    arg.m_posX = pos[1]
    arg.m_posY = pos[2]
    arg.m_posZ = pos[3]
    arg.m_dir = self.m_creature:GetAngleY()
    arg.m_isChangedBirth = self.m_isChangedBirth
  end
  return arg
end

function SgAINpc:showAlertUI()
  if self:isDead() then
    return
  end
  self.m_roleTopUI = self.m_creature:GetSceneUI().roleTopUI
  self.m_roleTopUI:SetAlertInfo(self.m_creature)
  if self.m_alertAudio == nil then
    local pos = self:getPosition()
    self.m_alertAudio = AudioUtility.PlayLoop_At(AudioMap.StealthGame.AIAlert, pos[1], pos[2], pos[3], AudioSourceType.SCENE)
  end
end

function SgAINpc:updateAlertValue(isPatrol, value)
  if self:isDead() then
    return
  end
  if self.m_roleTopUI == nil then
    return
  end
  if isPatrol then
    self.m_roleTopUI:UpdateHighValue(value / 2, self.m_creature)
  else
    self.m_roleTopUI:UpdateLowValue(value / 2, self.m_creature)
  end
end

function SgAINpc:hideAlertUI()
  if self:isDead() then
    return
  end
  if self.m_alertAudio ~= nil and not Slua.IsNull(self.m_alertAudio) then
    self.m_alertAudio:Stop()
    self.m_alertAudio = nil
  end
  self.m_roleTopUI = self.m_roleTopUI:RemoveSceneNpcAlert()
end

function SgAINpc:showOutLine(effectName, r, g, b)
  self.m_npc:SetIsOutLine(true, effectName, r, g, b)
end

function SgAINpc:hideOutLine()
  self.m_npc:SetIsOutLine(false, nil, 1, 1, 1)
end

function SgAINpc:disableDialog()
  FunctionVisitNpc.Me():RegisterVisitShow(self.m_uid, nil, function()
  end, nil)
end

function SgAINpc:enabledDialog(value)
  if value or nil == value then
    FunctionVisitNpc.Me():UnRegisterVisitShow(self.m_uid)
  end
  if self.m_tbData.DialogList ~= _EmptyTable then
    FunctionVisitNpc.Me():RegisterVisitShow(self.m_uid, self.m_tbData.DialogList, function(data)
      self:onVisitNpcEnd(data.m_creature)
    end, self)
  end
end

function SgAINpc:onVisitNpcEnd(note)
  if note == nil or note.data == nil then
    return
  end
  local id = note.data.id
  if id == nil then
    id = note.data.data.id
  end
  if note ~= nil and id == self.m_uid and self.m_stateMachine:isType(AIBehaviourType.eVisit) then
    self.m_creature.logicTransform:SetAngleY(self.m_angleYInVisit)
    self:getStateMachine():switchLastState()
  end
end

function SgAINpc:onVisitNpc(note)
  local n = FunctionVisitNpc.Me():GetTarget()
  if n ~= nil and n.data.id == self.m_uid then
    if self.m_stateMachine:isType(AIBehaviourType.eLethargy) then
      local playEnd = function()
        self.m_lethargyPlotId = nil
      end
      if self.m_lethargyPlotId == nil then
        self.m_lethargyPlotId = Game.PlotStoryManager:Start_PQTLP("11104", playEnd, nil, nil, false, nil, {
          myself = self.m_uid
        }, false)
      end
    elseif self.m_stateMachine:isType(AIBehaviourType.eAlert) or self.m_stateMachine:isType(AIBehaviourType.eAlertPatrol) then
      local playEnd = function()
        self.m_alertPlotId = nil
      end
      if self.m_alertPlotId == nil then
        self.m_alertPlotId = Game.PlotStoryManager:Start_PQTLP("11105", playEnd, nil, nil, false, nil, {
          myself = self.m_uid
        }, false)
      end
    else
      self.m_angleYInVisit = self.m_creature.logicTransform:GetCurAngleY()
      self:getStateMachine():breakSwitch(AIBehaviourType.eVisit)
      self:onLookAtPlayer()
    end
  end
end

function SgAINpc:testEditorSpeed(value)
  self.m_testSpeed = value
end

function SgAINpc:getAutoSpeakInterval()
  return self.m_autoSpeakInterval
end

function SgAINpc:isHasAlertPatrolState()
  if self.m_tbData.smell ~= nil and self.m_tbData.smell > 0 then
    return false
  end
  if self.m_alertType == SgAIAlertType.eSmell then
    return false
  end
  return true
end

function SgAINpc:autoSpeak()
  if self.m_tbData.DefaultDialog == _EmptyTable then
    return
  end
  local ids = self.m_tbData.DefaultDialog.dialogList
  if #ids < 1 then
    return
  end
  if #ids == 1 then
    local tb = Table_Dialog[ids[1]]
    if tb == nil then
      return
    end
    local sceneUI = self.m_creature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleTopUI:Speak(tb.Text, self.m_creature)
    end
    return
  end
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  local index = math.random(1, #ids)
  local tb = Table_Dialog[ids[index]]
  if tb == nil then
    return
  end
  local sceneUI = self.m_creature:GetSceneUI() or nil
  if sceneUI then
    sceneUI.roleTopUI:Speak(tb.Text, self.m_creature)
  end
end

function SgAINpc:showItemIcon()
  if self.m_goItem ~= nil then
    return
  end
  local id = 0
  for _, v in ipairs(self:getDropItem()) do
    id = v
    break
  end
  local tb = Table_Item[id]
  if tb == nil then
    return
  end
  local sceneUI = self.m_creature:GetSceneUI()
  if sceneUI then
    local container = sceneUI.roleTopUI:GetSceneUITopFollow(SceneUIType.RoleTopInfo)
    local path = ResourcePathHelper.EffectUI("SgAIItemIcon")
    self.m_goItem = Game.AssetManager_UI:CreateSceneUIAsset(path, container.transform)
    self.m_goItem:SetActive(true)
    self.m_goItem.transform.localPosition = LuaGeometry.GetTempVector3(-20, 20)
    self.m_goItem.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.m_goItem.transform.localScale = LuaGeometry.Const_V3_one
    local spObj = UIUtil.GetAllComponentsInChildren(self.m_goItem, Image, false)
    if spObj ~= nil then
      for i = 1, #spObj do
        if spObj[i].name == "uiImgIcon" then
          local img = spObj[i]:GetComponent(Image)
          SpriteManager.SetUISprite("sceneui", tb.Icon, img)
        end
      end
    end
  end
end

function SgAINpc:onLeave()
  self.m_leaveBattle = true
end
