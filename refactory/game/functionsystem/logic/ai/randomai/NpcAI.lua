autoImport("NpcAIState")
autoImport("NpcAIState_Photograph")
autoImport("NpcAIState_InteractNpc")
autoImport("NpcAIState_Wait")
autoImport("NpcAIState_Follow")
autoImport("NpcAIState_Time")
NpcAI = class("NpcAI", ReusableObject)
local AIState = {
  IDLE = 0,
  INEVENT = 1,
  INTRANSITION = 2,
  INPAUSE = 3,
  DISABLE = 4,
  WAIT = 5
}
local ConditionStateClass = {
  photograph = NpcAIState_Photograph,
  damage = NpcAIState,
  fashion = NpcAIState_Follow,
  time = NpcAIState_Time,
  interactNpc = NpcAIState_InteractNpc,
  cpOccupied = NpcAIState_Wait
}
local ConditionStateType = {
  TIME = 1,
  USER_TRIGGER = 2,
  USER_STATE = 3
}
local timeStep = 1
local timeCheckInterval = 300
local matchFunc = function(obj, id)
  return obj.id == id
end

function NpcAI:DoConstruct(asArray, id)
  self.id = id
  self.eventPool = {}
  self.eventCache = {}
  self.eventQueue = {}
  self.lockedEvents = {}
  self.triggerConditionCheckList = {}
  self.state = AIState.DISABLE
  self.currentEvent = nil
  self.isFirstInit = true
  self.triggerConditionFuncMap = {
    photograph = self.OnPlayerBehaviourNotified,
    damage = self.OnPlayerBehaviourNotified,
    interactNpc = self.OnInteractNpcNotified
  }
  EventManager.Me():AddEventListener(ServiceEvent.NUserNewMenu, self.OnMenuUnlock, self)
  self:InitData()
end

function NpcAI:DoDeconstruct()
  self:DeactiveAI()
  self:ClearData()
  self.id = nil
  self.eventPool = nil
  self.eventCache = nil
  self.eventQueue = nil
  self.lockedEvents = nil
  self.triggerConditionCheckList = nil
  self.conditions = nil
  self.state = nil
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserNewMenu, self.OnMenuUnlock, self)
end

function NpcAI:InitData()
  local preferenceData = Table_AIPreference and Table_AIPreference[self.id]
  if not preferenceData then
    return
  end
  local randomEvents = preferenceData.RandomEvents
  if randomEvents then
    for i = 1, #randomEvents do
      local id = randomEvents[i].id
      local weight = randomEvents[i].weight
      if 0 < weight and Table_AIEvent and Table_AIEvent[id] then
        local menuId = Table_AIEvent[id].Unlock
        if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
          if self:CheckEventOpenTime(id) then
            self.eventPool[#self.eventPool + 1] = id
          else
            self.lockedEvents[#self.lockedEvents + 1] = id
          end
        else
          self.lockedEvents[#self.lockedEvents + 1] = id
        end
      end
    end
  end
  self.conditions = preferenceData.Conditions
  if self.conditions then
    local temp = ReusableTable.CreateTable()
    for i = 1, #self.conditions do
      local condition = self.conditions[i]
      if Table_AICondition and Table_AICondition[condition] then
        local conditionData = Table_AICondition[condition]
        if conditionData.Type == ConditionStateType.USER_TRIGGER then
          local content = conditionData.Content
          if not temp[content] then
            RandomAIManager.Instance:AddCondObserver(content, self.triggerConditionFuncMap[content], self)
            temp[content] = true
          end
        elseif conditionData.Type == ConditionStateType.TIME then
          local params = conditionData.Params
          local interactNpcId = params and params.interactNpcId
          if interactNpcId then
            local interactNpc = Game.InteractNpcManager.interactNpcMap[interactNpcId]
            if interactNpc then
              interactNpc:SetRunningState(false)
            end
          end
        end
      end
    end
    ReusableTable.DestroyAndClearTable(temp)
  end
end

function NpcAI:ClearData()
  if self.conditions then
    local temp = ReusableTable.CreateTable()
    for i = 1, #self.conditions do
      local condition = self.conditions[i]
      local conditionData = Table_AICondition[condition]
      if conditionData and conditionData.Type == ConditionStateType.USER_TRIGGER then
        local content = conditionData.Content
        if not temp[content] then
          RandomAIManager.Instance:RemoveCondObserver(content, self)
          temp[content] = true
        end
      end
    end
    ReusableTable.DestroyAndClearTable(temp)
  end
  TableUtility.ArrayClear(self.eventPool)
  TableUtility.ArrayClear(self.eventCache)
  TableUtility.ArrayClear(self.eventQueue)
  TableUtility.ArrayClear(self.lockedEvents)
  TableUtility.TableClearByDeleter(self.triggerConditionCheckList, function(list)
    TableUtility.TableClear(list)
  end)
end

function NpcAI:OnMenuUnlock(menuIds)
  if not menuIds then
    return
  end
  for i = 1, #menuIds do
    local menuId = menuIds[i]
    for j = #self.lockedEvents, 1, -1 do
      local eventId = self.lockedEvents[j]
      local data = Table_AIEvent[eventId]
      if menuId == data.Unlock and self:CheckEventOpenTime(eventId) then
        self.eventPool[#self.eventPool + 1] = eventId
        self.lockedEvents[j] = nil
      end
    end
  end
end

function NpcAI:CheckEventOpenTime(eventId)
  if Table_AIEvent and Table_AIEvent[eventId] then
    local openTime = Table_AIEvent[eventId].OpenTime
    local currentTime = os.date("*t", (ServerTime.ServerTime or 0) / 1000)
    local hour = currentTime.hour
    return hour >= openTime[1] and hour < openTime[2]
  end
end

function NpcAI:CreateCreature(pos)
  local creature = NSceneNpcProxy.Instance:Find(self.id)
  if not creature then
    local data = {}
    data.npcID = self.id
    data.id = self.id
    local posX, posY, posZ = 0, 0, 0
    if pos then
      posX = pos.x or posX
      posY = pos.y or posY
      posZ = pos.z or posZ
    end
    data.pos = {
      x = posX,
      y = posY,
      z = posZ
    }
    data.datas = {}
    data.attrs = {}
    data.mounts = {}
    local staticData = Table_Npc[self.id]
    data.staticData = staticData
    data.name = staticData.NameZh
    data.searchrange = 0
    creature = NSceneNpcProxy.Instance:Add(data, NNpc)
    if staticData then
      if staticData.ShowName then
        creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
      end
      if staticData.Scale then
        creature:Server_SetScaleCmd(staticData.Scale, true)
      end
      if staticData.Behaviors then
        creature.data:SetBehaviourData(staticData.Behaviors)
      end
    end
    local noAccessable = creature.data:NoAccessable()
    creature.assetRole:SetColliderEnable(not noAccessable)
  end
end

function NpcAI:RemoveCreature()
  NSceneNpcProxy.Instance:Remove(self.id)
end

function NpcAI:ActiveAI(pos)
  self.state = AIState.IDLE
  self:CreateCreature(pos)
end

function NpcAI:DeactiveAI()
  if self.state == AIState.INEVENT then
    function self.eventStopHandler()
      self:RemoveCreature()
      
      self:ClearEvent()
    end
    
    self:StopEvent()
  else
    self:RemoveCreature()
    self:ClearEvent()
  end
  self.state = AIState.DISABLE
end

function NpcAI:PrepareEvent()
  local eventId, cp, interval, isLoop, target, randomPos, interactNpcId
  if #self.eventQueue > 0 then
    local eventData = TableUtility.ArrayPopBack(self.eventQueue)
    eventId = eventData.eventId
    cp = eventData.cp
    interval = eventData.interval
    isLoop = eventData.isLoop
    target = eventData.target
    randomPos = eventData.randomPos
    interactNpcId = eventData.interactNpcId
  else
    eventId = self:RandomEvent()
    cp = RandomAIManager.Instance:RandomCP(eventId, self.id)
    if not cp then
      local hasEmptyCP = false
      for i = 1, #self.eventPool do
        local id = self.eventPool[i]
        if RandomAIManager.Instance:hasEmptyCP(id) then
          hasEmptyCP = true
          break
        end
      end
      if not hasEmptyCP then
        for i = 1, #self.eventCache do
          local id = self.eventCache[i]
          if RandomAIManager.Instance:hasEmptyCP(id) then
            hasEmptyCP = true
            break
          end
        end
      end
      if hasEmptyCP then
        self:PrepareEvent()
      end
      return
    end
    interval = self:RandomEventInterval(eventId)
  end
  self:UpdateEvent(eventId, cp, interval, isLoop, target, randomPos, interactNpcId)
end

function NpcAI:RandomEvent()
  local preferenceData = Table_AIPreference and Table_AIPreference[self.id]
  if not preferenceData then
    return
  end
  if #self.eventPool == 0 then
    self.eventPool, self.eventCache = self.eventCache, self.eventPool
  end
  local weights = 0
  for i = 1, #self.eventPool do
    local id = self.eventPool[i]
    local event = TableUtility.ArrayFindByPredicate(preferenceData.RandomEvents, matchFunc, id)
    local weight = event.weight
    weights = weights + weight
  end
  local randomWeight = math.random(0, weights)
  for i = 1, #self.eventPool do
    local id = self.eventPool[i]
    local event = TableUtility.ArrayFindByPredicate(preferenceData.RandomEvents, matchFunc, id)
    local weight = event.weight
    weights = weights - weight
    if randomWeight >= weights then
      table.remove(self.eventPool, i)
      table.insert(self.eventCache, id)
      return id
    end
  end
end

function NpcAI:RandomEventInterval(eventId)
  local eventData = Table_AIEvent and Table_AIEvent[eventId]
  if not eventData then
    return
  end
  local interval = eventData.Interval
  if interval and 0 < #interval then
    local startTime = interval[1]
    local endTime = interval[2]
    local executeTime = math.random(startTime, endTime)
    return executeTime
  end
end

function NpcAI:ExecuteEvent()
  if self.state == AIState.INTRANSITION then
    return
  end
  RandomAIManager.Instance:OnEventExcute(self.currentEvent, self.id)
  self:ExecuteImmediately()
end

function NpcAI:StartIdleBehaivour()
  self:PrepareEvent()
  self:ExecuteEvent()
end

function NpcAI:InterruptEventInternal(eventId, cp, interval, isLoop, target, randomPos)
  if self.state == AIState.INEVENT then
    function self.eventStopHandler()
      self:UpdateEvent(eventId, cp, interval, isLoop, target, randomPos)
      
      if self.state ~= AIState.INTRANSITION then
        self:ExecuteImmediately()
      end
    end
    
    self:StopEvent()
  else
    self:UpdateEvent(eventId, cp, interval, isLoop, target, randomPos)
    if self.state ~= AIState.INTRANSITION then
      self:ExecuteImmediately()
    end
  end
end

function NpcAI:CompareEvent(eventId, interval, isLoop, target, randomPos)
  local eventData = Table_AIEvent[eventId]
  if not eventData then
    return false
  end
  if self.state == AIState.DISABLE then
    return
  end
  local currentEventData = Table_AIEvent[self.currentEvent]
  if not currentEventData then
    return
  end
  if eventData.priority > currentEventData.priority then
    local cp
    if not target then
      cp = RandomAIManager.Instance:RandomCP(eventId, self.id)
      if not cp then
        redlog("cp not exist!!! eventId = ", eventId)
        return false
      end
    end
    if eventData.interruptImmediately > 0 then
      self:InterruptEventInternal(eventId, cp, interval, isLoop, target, randomPos)
    else
      local data = {}
      data.eventId = eventId
      data.cp = cp
      data.interval = interval
      data.isLoop = isLoop
      data.target = target
      data.randomPos = randomPos
      TableUtility.ArrayPushBack(self.eventQueue, data)
    end
    return true
  end
end

function NpcAI:UpdateEvent(eventId, cp, interval, isLoop, target, randomPos)
  local lastEvent = self.currentEvent
  self.currentEvent = eventId
  self.interval = interval
  self.isLoop = isLoop
  self.target = target
  self:UpdateCP(lastEvent, cp, randomPos)
end

function NpcAI:StopEvent()
  RandomAIManager.Instance:OnEventEnd(self.currentEvent)
  self:StopMotion()
end

function NpcAI:PauseEvent()
  if self.state == AIState.INEVENT then
    self.state = AIState.INPAUSE
  elseif self.state == AIState.INTRANSITION then
    self.manualStopMove = true
    local creature = NSceneNpcProxy.Instance:Find(self.id)
    if creature then
      creature:Logic_StopMove()
      creature:Logic_PlayAction_Idle()
      FunctionVisitNpc.Me():NpcTurnToMe(creature)
    end
  end
end

function NpcAI:UpdateCP(eventId, cp, pos)
  local creature = NSceneNpcProxy.Instance:Find(self.id)
  if not creature then
    return
  end
  if cp then
    pos = RandomAIManager.Instance:GetCPPos(cp)
    if not pos then
      redlog("cp pos not exist!!!cp = ", cp)
      return
    end
    local dir = RandomAIManager.Instance:GetCPDir(cp)
    if self.isFirstInit then
      creature:Server_SetPosXYZCmd(pos[1], pos[2], pos[3], nil, true)
      creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
      self.isFirstInit = nil
    elseif self.cp ~= cp then
      self:Transition(pos, function()
        if not self:IsInTransition() then
          return
        end
        if self.manualStopMove then
          return
        end
        if dir then
          creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
        end
        self:OnTransitionEnd(cp)
      end)
      if self.cp then
        RandomAIManager.Instance:ReleaseCP(self.cp, eventId)
      end
    end
  else
    local dir
    if self.target then
      dir = self.target:GetAngleY()
    end
    if pos then
      self:Transition(pos, function()
        if not self:IsInTransition() then
          return
        end
        if self.manualStopMove then
          return
        end
        if dir then
          creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
        end
        self:OnTransitionEnd()
      end)
    end
    if self.cp then
      RandomAIManager.Instance:ReleaseCP(self.cp, eventId)
    end
  end
  self.cp = cp
end

function NpcAI:ExecuteImmediately()
  self.state = AIState.INEVENT
  self:PlayMotion()
end

function NpcAI:OnNotifyInterruptEvent(pos, dir, questId, npcIndex)
  if self.state == AIState.INPAUSE then
    GameFacade.Instance:sendNotification(DialogEvent.CloseDialog)
  end
  if self.state == AIState.INEVENT then
    function self.eventStopHandler()
      self:Transition(pos, function()
        if not self:IsInTransition() then
          return
        end
        if self.manualStopMove then
          return
        end
        if dir then
          local creature = NSceneNpcProxy.Instance:Find(self.id)
          creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
        end
        RandomAIManager.Instance:OnAIMoveEnd(self.id, questId, npcIndex)
      end, true)
    end
    
    self:StopEvent()
  else
    self:Transition(pos, function()
      if not self:IsInTransition() then
        return
      end
      if self.manualStopMove then
        return
      end
      if dir then
        local creature = NSceneNpcProxy.Instance:Find(self.id)
        creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
      end
      RandomAIManager.Instance:OnAIMoveEnd(self.id, questId, npcIndex)
    end, true)
  end
end

function NpcAI:OnNotifyPauseEvent()
  self:PauseEvent()
end

function NpcAI:OnNotifyRestartEvent(pos)
  self:ActiveAI(pos)
  self:StartIdleBehaivour()
end

function NpcAI:OnNotifyResumeEvent()
  if self.state == AIState.INPAUSE then
    self.state = AIState.INEVENT
  elseif self.state == AIState.INTRANSITION then
    local pos = RandomAIManager.Instance:GetCPPos(self.cp)
    local dir = RandomAIManager.Instance:GetCPDir(self.cp)
    self.manualStopMove = nil
    local creature = NSceneNpcProxy.Instance:Find(self.id)
    FunctionVisitNpc.Me():NpcTurnBack(creature)
    self:Transition(pos, function()
      if not self:IsInTransition() then
        return
      end
      if self.manualStopMove then
        return
      end
      if dir then
        creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
      end
      self:OnTransitionEnd(self.cp)
    end)
  end
end

function NpcAI:PlayMotion()
  local currentEventData = Table_AIEvent and Table_AIEvent[self.currentEvent]
  if not currentEventData then
    return
  end
  local dialogData = Table_AIEventDialog and Table_AIEventDialog[self.id]
  local dialogParam
  if dialogData then
    local eventDialog = TableUtility.ArrayFindByPredicate(dialogData.Dialogs, matchFunc, self.currentEvent)
    if eventDialog then
      dialogParam = eventDialog.dialogParams
    end
  end
  local pqtl_name = currentEventData.ActionName
  self.actionInstanceId = Game.PlotStoryManager:Start_PQTLP(pqtl_name, self.OnEventEnd, self, nil, false, self.interval, {
    myself = self.id,
    target = self.target,
    random_talk = dialogParam
  }, self.isLoop)
end

function NpcAI:StopMotion()
  if self.actionInstanceId then
    Game.PlotStoryManager:StopFreeProgress(self.actionInstanceId, true)
    self.actionInstanceId = nil
  end
end

function NpcAI:OnEventEnd(result)
  if result then
    if self.conditionState then
      self.conditionState:OnExit()
      self.conditionState = nil
    end
    if self.state == AIState.INPAUSE then
      GameFacade.Instance:sendNotification(DialogEvent.CloseDialog)
    end
    self.state = AIState.IDLE
    RandomAIManager.Instance:OnEventEnd(self.currentEvent)
    self:StartIdleBehaivour()
  else
    self.state = AIState.IDLE
    if self.eventStopHandler then
      self.eventStopHandler()
      self.eventStopHandler = nil
    end
  end
end

function NpcAI:OnEventStop()
  if self.conditionState then
    self.conditionState:OnExit()
    self.conditionState = nil
  end
  if self.state == AIState.INEVENT then
    function self.eventStopHandler()
      self:StartIdleBehaivour()
    end
    
    self:StopEvent()
  else
    self:StartIdleBehaivour()
  end
end

function NpcAI:OnTransitionEnd(cp)
  if self.cp ~= cp then
    return
  end
  self.state = AIState.WAIT
end

function NpcAI:Transition(pos, endFunc, isQuestMove)
  if not pos then
    redlog("pos not exist!!!npcId = ", self.id)
    return
  end
  local creature = NSceneNpcProxy.Instance:Find(self.id)
  if creature then
    if not NavMeshUtils.CanArrived(creature:GetPosition(), pos, 5, true) then
      redlog("pos can't arrived!!!npcId = ", self.id)
      return
    end
    self.state = AIState.INTRANSITION
    if not isQuestMove then
      local eventData = Table_AIEvent[self.currentEvent]
      local moveAction = eventData.MoveAction and eventData.MoveAction > 0 and eventData.MoveAction or 1
      local moveSpeed = eventData.MoveSpeed and 0 < eventData.MoveSpeed and eventData.MoveSpeed
      local animData = Table_ActionAnime[moveAction]
      creature:SetDefaultWalkAnime(animData.Name)
      creature:Server_SetMoveSpeed(moveSpeed)
    end
    creature:Server_MoveToXYZCmd(pos[1], pos[2], pos[3], nil, false, endFunc)
  end
end

function NpcAI:IsInTransition()
  return self.state == AIState.INTRANSITION
end

function NpcAI:ClearEvent()
  self.currentEvent = nil
  self.interval = nil
  self.isLoop = nil
  self.cp = nil
  self.target = nil
  self.interactNpcId = nil
end

function NpcAI:OnPlayerBehaviourNotified(content, userId, isEnter, isExit)
  if self.conditions then
    for i = 1, #self.conditions do
      local condition = self.conditions[i]
      local config = Table_AICondition[condition]
      if config and config.Content == content then
        self:OnConditionTrigger(condition, userId, isEnter, isExit)
        break
      end
    end
  end
end

function NpcAI:OnInteractNpcNotified(content, userId, isEnter, isExit, interactNpcId)
  if self.conditions then
    for i = 1, #self.conditions do
      local condition = self.conditions[i]
      local config = Table_AICondition[condition]
      if config and config.Content == content then
        local params = config.Params
        local npcId = params and params.interactNpcId
        if npcId == interactNpcId then
          self:OnConditionTrigger(condition, userId, isEnter, isExit, interactNpcId)
          break
        end
      end
    end
  end
end

function NpcAI:OnConditionTrigger(condition, userId, isEnter, isExit, interactNpcId)
  local checkList = self.triggerConditionCheckList[condition]
  if not checkList then
    checkList = {}
    self.triggerConditionCheckList[condition] = checkList
  end
  self.interactNpcId = interactNpcId
  if not isExit then
    if not checkList[userId] then
      checkList[userId] = userId
    end
  else
    self:RemoveTriggerConditionCheck(condition, userId)
  end
  if not isEnter and not isExit then
    self:TriggerConditionEvent(condition, userId)
  end
end

function NpcAI:RemoveTriggerConditionCheck(condition, userId)
  local checkList = self.triggerConditionCheckList[condition]
  if checkList then
    checkList[userId] = nil
    if self.conditionState and self.conditionState.id == condition then
      self.conditionState:Dispose()
      self.conditionState = nil
    end
  end
end

function NpcAI:TriggerConditionEvent(condition, userId, time, deltaTime)
  if self.conditionState and (self.conditionState.id ~= condition or self.conditionState.targetId ~= userId) then
    return
  end
  local creature = NSceneNpcProxy.Instance:Find(self.id)
  if not creature then
    return
  end
  local user = NSceneUserProxy.Instance:Find(userId)
  if not user then
    return
  end
  if Table_AICondition and Table_AICondition[condition] then
    local data = Table_AICondition[condition]
    local content = data.Content
    local params = data.Params
    local range = params and params.range
    if range then
      local sqrDis = range * range
      if sqrDis >= LuaVector3.Distance_Square(user:GetPosition(), creature:GetPosition()) then
        if not self.conditionState then
          local args = ReusableTable.CreateArray()
          args[1] = condition
          args[2] = self
          args[3] = userId
          args[4] = self.interactNpcId
          self.conditionState = ReusableObject.Create(ConditionStateClass[content], false, args)
          ReusableTable.DestroyAndClearArray(args)
        end
        self.conditionState:OnUpdate(time, deltaTime)
      elseif self.conditionState then
        self.conditionState:Dispose()
        self.conditionState = nil
      end
    end
  end
end

function NpcAI:CheckStateCondition(creature, conditionData, time, deltaTime)
  if self.conditionState and (self.conditionState.id ~= conditionData.id or self.conditionState.targetId ~= creature.data.id) then
    return
  end
  local params = conditionData.Params
  if not params then
    return
  end
  local content = conditionData.Content
  if content == "fashion" then
    local array_and = params.And
    local array_or = params.Or
    local isMatch = false
    if array_and then
      isMatch = true
      for i = 1, #array_and do
        local data = array_and[i]
        local part = data.part
        local id = data.id
        local fashionId = creature.data.userdata:Get(UDEnum[part])
        if fashionId ~= id then
          isMatch = false
          break
        end
      end
    end
    if array_or then
      for i = 1, #array_or do
        local data = array_or[i]
        local part = data.part
        local id = data.id
        local fashionId = creature.data.userdata:Get(UDEnum[part])
        if fashionId == id then
          isMatch = true
          break
        end
      end
    end
    if isMatch then
      if not self.conditionState then
        local args = ReusableTable.CreateArray()
        args[1] = conditionData.id
        args[2] = self
        args[3] = creature.data.id
        self.conditionState = ReusableObject.Create(ConditionStateClass[content], false, args)
        ReusableTable.DestroyAndClearArray(args)
      end
      self.conditionState:OnUpdate(time, deltaTime)
      return true
    elseif self.conditionState then
      self.conditionState:Dispose()
      self.conditionState = nil
    end
  elseif content == "cpOccupied" then
    local interactNpcs = params.occupiedNpcs
    if interactNpcs then
      for i = 1, #interactNpcs do
        local npcId = interactNpcs[i].id
        local slotId = params.slotId
        local charId = Game.InteractNpcManager:GetCharid(npcId, slotId)
        if charId == creature.data.id then
          if not self.conditionState then
            local args = ReusableTable.CreateArray()
            args[1] = conditionData.id
            args[2] = self
            args[3] = creature.data.id
            args[4] = npcId
            args[5] = interactNpcs[i].exitEventId
            self.conditionState = ReusableObject.Create(ConditionStateClass[content], false, args)
            ReusableTable.DestroyAndClearArray(args)
          end
          self.conditionState:OnUpdate(time, deltaTime)
          return true
        elseif not charId and self.conditionState and self.conditionState.interactNpcId == npcId then
          self.conditionState:OnExit()
          self.conditionState = nil
        end
      end
    end
  end
end

function NpcAI:Update(time, deltaTime)
  local creature = NSceneNpcProxy.Instance:Find(self.id)
  if not creature then
    return
  end
  if not self.time then
    self.time = time
    self.timeInterval = 0
  end
  if time - self.time > timeStep then
    self.timeInterval = self.timeInterval + timeStep
    self.time = time
    for condition, checkList in pairs(self.triggerConditionCheckList) do
      for _, userId in pairs(checkList) do
        self:TriggerConditionEvent(condition, userId, time, deltaTime)
      end
    end
  end
  if self.conditions then
    for i = 1, #self.conditions do
      local condition = self.conditions[i]
      if Table_AICondition and Table_AICondition[condition] then
        local data = Table_AICondition[condition]
        local params = data.Params
        if data.Type == ConditionStateType.USER_STATE then
          local distance = params and params.range
          if not distance then
            goto lbl_181
          end
          local position = creature:GetPosition()
          local nearUsers = NSceneUserProxy.Instance:FindNearUsers(position, distance)
          if 0 < #nearUsers then
            for j = 1, #nearUsers do
              local user = nearUsers[j]
              if self:CheckStateCondition(user, data, time, deltaTime) then
                break
              end
            end
          else
            local sqrDis = distance * distance
            local myself = Game.Myself
            if sqrDis >= LuaVector3.Distance_Square(myself:GetPosition(), position) then
              self:CheckStateCondition(myself, data, time, deltaTime)
            end
          end
        elseif data.Type == ConditionStateType.TIME and self.timeInterval > timeCheckInterval then
          local currentTime = os.date("*t", (ServerTime.ServerTime or 0) / 1000)
          local curHour = currentTime.hour
          local curMin = currentTime.min
          local hour = params and params.hour
          local min = params and params.min
          min = min or 0
          if curHour == hour and curMin - min < 5 and 0 <= curMin - min then
            if self.conditionState then
              self.conditionState:Dispose()
              self.conditionState = nil
            end
            local args = ReusableTable.CreateArray()
            args[1] = condition
            args[2] = self
            self.conditionState = ReusableObject.Create(ConditionStateClass[data.Content], false, args)
            ReusableTable.DestroyAndClearArray(args)
            self.conditionState:OnUpdate(time, deltaTime)
          end
        end
      end
      ::lbl_181::
    end
  end
  if self.state == AIState.WAIT then
    self:ExecuteEvent()
  end
  if self.timeInterval > timeCheckInterval then
    for i = #self.lockedEvents, 1, -1 do
      local eventId = self.lockedEvents[i]
      local menuId = Table_AIEvent[eventId].Unlock
      if FunctionUnLockFunc.Me():CheckCanOpen(menuId) and self:CheckEventOpenTime(eventId) then
        self.eventPool[#self.eventPool + 1] = eventId
        self.lockedEvents[i] = nil
      end
    end
    for i = #self.eventPool, 1, -1 do
      local eventId = self.eventPool[i]
      if not self:CheckEventOpenTime(eventId) then
        self.lockedEvents[#self.lockedEvents + 1] = eventId
        self.eventPool[#self.eventPool + 1] = nil
      end
    end
    self.timeInterval = 0
  end
end
