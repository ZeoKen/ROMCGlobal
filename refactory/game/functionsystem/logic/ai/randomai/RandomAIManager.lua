autoImport("NpcAI")
RandomAIManager = class("RandomAIManager")
RandomAIManager.TriggerConditionEnum = {
  PHOTOGRAPH = "photograph",
  DAMAGE = "damage",
  INTERACTNPC = "interactNpc"
}
local game = Game

function RandomAIManager:ctor()
  self.aiPool = {}
  self.CPPool = {}
  self.cpAIMap = {}
  self.cpMap = {}
  self.interruptGroup = {}
  self.subEventAIGroup = {}
  self.questMap = {}
  self.conditionObserverMap = {}
  self.multiEventMap = {}
  EventManager.Me():AddEventListener(InteractNpcEvent.FlowerCarStart, self.OnFlowerCarStart, self)
  EventManager.Me():AddEventListener(InteractNpcEvent.FlowerCarEnd, self.OnFlowerCarEnd, self)
end

function RandomAIManager.Me()
  if not RandomAIManager.Instance then
    RandomAIManager.Instance = RandomAIManager.new()
  end
  return RandomAIManager.Instance
end

function RandomAIManager:SetData(npcIds)
  self:InitNpcAI(npcIds)
  self:InitData()
end

function RandomAIManager:InitNpcAI(npcIds)
  for i = 1, #npcIds do
    local id = npcIds[i]
    local ai = ReusableObject.Create(NpcAI, false, id)
    ai:ActiveAI()
    self.aiPool[id] = ai
  end
end

function RandomAIManager:InitData()
  if Table_AIEvent then
    local manager = game.GameObjectManagers[game.GameObjectType.AreaCP]
    local areaCP = manager:GetAreaCP()
    if not areaCP then
      redlog("AreaCP not exist!!!")
      return
    end
    self.cpParent = areaCP.gameObject
    for id, _ in pairs(self.aiPool) do
      self:InitAIData(id)
    end
  end
end

function RandomAIManager:InitAIData(npcId)
  local preferenceData = Table_AIPreference and Table_AIPreference[npcId]
  if preferenceData then
    local randomEvents = preferenceData.RandomEvents
    if randomEvents then
      for i = 1, #randomEvents do
        local id = randomEvents[i].id
        local weight = randomEvents[i].weight
        if 0 <= weight then
          self:InitEventData(id)
        end
      end
    end
  end
end

function RandomAIManager:InitEventData(eventId)
  self:InitCP(eventId)
  if Table_AIEventMultiplayer and Table_AIEventMultiplayer[eventId] then
    local subEvents = Table_AIEventMultiplayer[eventId].SubEvents
    for i = 1, #subEvents do
      local subEvent = subEvents[i]
      self:InitCP(subEvent)
      if not self.multiEventMap[subEvent] then
        self.multiEventMap[subEvent] = eventId
      end
    end
  end
end

function RandomAIManager:InitCP(eventId)
  local eventData = Table_AIEvent[eventId]
  if not eventData then
    return
  end
  if not self.CPPool[eventId] then
    self.CPPool[eventId] = {}
    if eventData.CP then
      for i = 1, #eventData.CP do
        local cp = eventData.CP[i]
        table.insert(self.CPPool[eventId], cp)
        self:InitCPData(cp)
      end
    end
  end
end

function RandomAIManager:InitCPData(cp)
  if not self.cpParent then
    return
  end
  if self.cpMap[cp] then
    return
  end
  local cpGo = game.GameObjectUtil:DeepFind(self.cpParent, "CP_" .. cp)
  if cpGo then
    local cpData = {}
    local trans = cpGo.transform
    local position = trans.position
    local pos = {}
    pos[1] = position.x
    pos[2] = position.y
    pos[3] = position.z
    local angleY = trans.eulerAngles.y
    local dir = angleY
    if angleY < 0 then
      dir = angleY + 360
    end
    cpData.pos = pos
    cpData.dir = dir
    self.cpMap[cp] = cpData
  end
end

function RandomAIManager:AddEventListener()
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpc, self.OnAccessNpc, self)
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpcEnd, self.OnAccessNpcEnd, self)
  EventManager.Me():AddEventListener(PlayerBehaviourEvent.OnEnter, self.OnPlayerBehaviourEnter, self)
  EventManager.Me():AddEventListener(PlayerBehaviourEvent.OnExit, self.OnPlayerBehaviourExit, self)
  EventManager.Me():AddEventListener(PlayerBehaviourEvent.OnTrigger, self.OnPlayerBehaviourTrigger, self)
  EventManager.Me():AddEventListener(PlayerBehaviourEvent.OnNpcAIStateUpdate, self.UpdateNpcAIState, self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
end

function RandomAIManager:RemoveEventListener()
  EventManager.Me():RemoveEventListener(VisitNpcEvent.AccessNpc, self.OnAccessNpc, self)
  EventManager.Me():RemoveEventListener(VisitNpcEvent.AccessNpcEnd, self.OnAccessNpcEnd, self)
  EventManager.Me():RemoveEventListener(PlayerBehaviourEvent.OnEnter, self.OnPlayerBehaviourEnter, self)
  EventManager.Me():RemoveEventListener(PlayerBehaviourEvent.OnExit, self.OnPlayerBehaviourExit, self)
  EventManager.Me():RemoveEventListener(PlayerBehaviourEvent.OnTrigger, self.OnPlayerBehaviourTrigger, self)
  EventManager.Me():RemoveEventListener(PlayerBehaviourEvent.OnNpcAIStateUpdate, self.UpdateNpcAIState, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
end

function RandomAIManager:AddCondObserver(content, func, owner)
  local list = self.conditionObserverMap[content]
  if not list then
    list = {}
    self.conditionObserverMap[content] = list
  end
  local observer = {}
  observer.func = func
  observer.owner = owner
  list[#list + 1] = observer
end

function RandomAIManager:RemoveCondObserver(content, owner)
  local list = self.conditionObserverMap[content]
  if not list then
    return
  end
  TableUtility.ArrayRemoveByPredicate(list, function(v, owner)
    return v.owner == owner
  end, owner)
end

function RandomAIManager:OnSceneManorPartnerIdleList(data)
  if not self.isRunning then
    return
  end
  if self.isLocalNpc then
    return
  end
  self:SetData(data.partners)
  self:StartAIBehaviour()
  local questList = QuestProxy.Instance:getQuestListByStepType(QuestDataStepType.QuestDataStepType_PARTNERMOVE)
  if questList and 0 < #questList then
    for i = 1, #questList do
      local questData = questList[i]
      self:OnEventInterruptByQuest(questData)
    end
  end
end

function RandomAIManager:OnSceneManorPartnerIdleUpdate(data)
  if not self.isRunning then
    return
  end
  if self.isLocalNpc then
    return
  end
  self:OnAIActivenessUpdate(data.adds, data.delid)
end

function RandomAIManager:OnEventInterruptByQuest(questData)
  if not self.isRunning then
    return
  end
  local partnerid = questData.params.partnerid
  local partnerPos = questData.params.checkpos
  local questId = questData.id
  if not partnerid or #partnerid == 0 then
    redlog("partnerid not exist!!!questId = ", questId)
    return
  end
  self.interruptGroup[questId] = math.pow(2, #partnerid) - 1
  self.questMap[questId] = questData
  for i = 1, #partnerid do
    local npcId = partnerid[i]
    local pos = partnerPos[i]
    local ai = self.aiPool[npcId]
    if ai then
      ai:OnNotifyInterruptEvent(pos, nil, questId, i)
    end
  end
end

function RandomAIManager:OnEventInterruptByEvent(data)
  local userId = data.charid
  local events = data.aidata
  if events then
    for i = 1, #events do
      local eventId = events[i].eventid
    end
  end
end

function RandomAIManager:OnAIMoveEnd(npcId, questId, npcIndex)
  local result = self.interruptGroup[questId]
  result = result ~ math.pow(2, npcIndex - 1)
  if result == 0 then
    local questData = self.questMap[questId]
    if questData then
      QuestProxy.Instance:notifyQuestState(questData.scope, questId, questData.staticData.FinishJump)
    end
  end
  self.interruptGroup[questId] = result
end

function RandomAIManager:OnAIActivenessUpdate(activeDatas, deactiveIds)
  if activeDatas and 0 < #activeDatas then
    for i = 1, #activeDatas do
      local npcData = activeDatas[i]
      local npcId = npcData.partnerid
      local ai = self.aiPool[npcId]
      if not ai then
        ai = ReusableObject.Create(NpcAI, false, npcId)
        self.aiPool[npcId] = ai
        self:InitAIData(npcId)
      end
      local pos
      local scenePos = npcData.pos
      if scenePos then
        pos = LuaGeometry.GetTempVector3(scenePos.x, scenePos.y, scenePos.z)
      end
      ai:OnNotifyRestartEvent(pos)
    end
  end
  if deactiveIds and 0 < #deactiveIds then
    for i = 1, #deactiveIds do
      local npcId = deactiveIds[i]
      local ai = self.aiPool[npcId]
      if ai then
        ai:DeactiveAI()
      end
    end
  end
end

function RandomAIManager:OnAccessNpc(note)
  local creature = note and note.data
  if creature and creature:GetCreatureType() == Creature_Type.Npc then
    local npcId = creature.data.staticData.id
    local ai = self.aiPool[npcId]
    if ai then
      ai:OnNotifyPauseEvent()
    end
  end
end

function RandomAIManager:OnAccessNpcEnd(note)
  local creature = note and note.data
  if creature and creature:GetCreatureType() == Creature_Type.Npc then
    local npcId = creature.data.staticData.id
    local ai = self.aiPool[npcId]
    if ai then
      ai:OnNotifyResumeEvent()
    end
  end
end

function RandomAIManager:StartAIBehaviour()
  math.randomseed(os.time())
  for id, ai in pairs(self.aiPool) do
    ai:PrepareEvent()
  end
  for _, ai in pairs(self.aiPool) do
    ai:ExecuteEvent()
  end
end

function RandomAIManager:RandomCP(eventId, npcId)
  local cpList = self.CPPool[eventId]
  if cpList and 0 < #cpList then
    local index = math.random(1, #cpList)
    local cp = table.remove(cpList, index)
    if self.cpAIMap[cp] then
      local oldCP = cp
      cp = self:RandomCP(eventId, npcId)
      table.insert(cpList, oldCP)
    end
    if cp then
      self.cpAIMap[cp] = npcId
    end
    return cp
  end
end

function RandomAIManager:ReleaseCP(cp, eventId)
  local cpList = self.CPPool[eventId]
  if cpList and TableUtility.ArrayFindIndex(cpList, cp) == 0 then
    cpList[#cpList + 1] = cp
    self.cpAIMap[cp] = nil
  end
end

function RandomAIManager:hasEmptyCP(eventId)
  local cpList = self.CPPool[eventId]
  if not cpList then
    return false
  end
  for i = 1, #cpList do
    local cp = cpList[i]
    if not self.cpAIMap[cp] then
      return true
    end
  end
  return false
end

function RandomAIManager:GetCPPos(cp)
  local data = self.cpMap[cp]
  if data then
    return data.pos
  end
end

function RandomAIManager:GetCPDir(cp)
  local data = self.cpMap[cp]
  if data then
    return data.dir
  end
end

function RandomAIManager:OnEventExcute(eventId, npcId)
  self:CheckMultiEvent(eventId, npcId)
end

function RandomAIManager:OnEventEnd(eventId, npcId)
  if Table_AIEventMultiplayer and Table_AIEventMultiplayer[eventId] then
    self:OnMultiEventEnd(eventId)
  end
  local mainEvent = self.multiEventMap[eventId]
  if mainEvent then
    local subAIGroup = self.subEventAIGroup[mainEvent]
    if subAIGroup then
      TableUtility.ArrayRemove(subAIGroup, npcId)
    end
  end
end

function RandomAIManager:CheckMultiEvent(eventId, npcId)
  local multiEventData = Table_AIEventMultiplayer and Table_AIEventMultiplayer[eventId]
  if not multiEventData then
    return
  end
  local subEvents = multiEventData.SubEvents
  if subEvents then
    local subAIGroup = {}
    local cache = ReusableTable.CreateArray()
    
    local function randomSubEventFunc(id)
      if #subEvents == 0 then
        return
      end
      local index = math.random(1, #subEvents)
      local subEvent = subEvents[index]
      local cpList = self.CPPool[subEvent]
      if cpList then
        if #cpList == 0 then
          cache[#cache + 1] = subEvent
          table.remove(subEvents, index)
          randomSubEventFunc(id)
        else
          local preferenceData = Table_AIPreference and Table_AIPreference[id]
          if preferenceData then
            local excludeEvents = preferenceData.ExcludeEvents
            if not excludeEvents or TableUtility.ArrayFindIndex(excludeEvents, subEvent) == 0 then
              local ai = self.aiPool[id]
              local result = ai:CompareEvent(subEvent, -1, true)
              if result then
                subAIGroup[#subAIGroup + 1] = id
              elseif result == false then
                cache[#cache + 1] = subEvent
                table.remove(subEvents, index)
                randomSubEventFunc(id)
              end
            end
          end
        end
      end
    end
    
    for id, ai in pairs(self.aiPool) do
      if id ~= npcId then
        randomSubEventFunc(id)
      end
    end
    for i = 1, #cache do
      subEvents[#subEvents + 1] = cache[i]
    end
    ReusableTable.DestroyAndClearArray(cache)
    self.subEventAIGroup[eventId] = subAIGroup
  end
end

function RandomAIManager:OnMultiEventEnd(eventId)
  local subAIGroup = self.subEventAIGroup[eventId]
  if not subAIGroup then
    return
  end
  for i = 1, #subAIGroup do
    local npcId = subAIGroup[i]
    local ai = self.aiPool[npcId]
    if ai then
      ai:OnEventStop()
    end
  end
  TableUtility.ArrayClear(subAIGroup)
  self.subEventAIGroup[eventId] = nil
end

function RandomAIManager:OnPlayerBehaviourEnter(args)
  self:OnPlayerBehaviourNotified(args, true, false)
end

function RandomAIManager:OnPlayerBehaviourExit(args)
  self:OnPlayerBehaviourNotified(args, false, true)
end

function RandomAIManager:OnPlayerBehaviourTrigger(args)
  self:OnPlayerBehaviourNotified(args)
end

function RandomAIManager:OnPlayerBehaviourNotified(args, isEnter, isExit)
  local content = args[1]
  local userId = args[2]
  local interactNpc = args[3]
  local list = self.conditionObserverMap[content]
  if not list then
    return
  end
  for i = 1, #list do
    local observer = list[i]
    local func = observer.func
    local owner = observer.owner
    func(owner, content, userId, isEnter, isExit, interactNpc)
  end
end

function RandomAIManager:GetNpcIdByCP(cp)
  return self.cpAIMap[cp]
end

function RandomAIManager:DeactiveAll()
  if self.isLocalNpc then
    for _, ai in pairs(self.aiPool) do
      ai:DeactiveAI()
    end
  end
end

function RandomAIManager:ReactiveAll()
  if self.isLocalNpc then
    for _, ai in pairs(self.aiPool) do
      ai:OnNotifyRestartEvent()
    end
  end
end

function RandomAIManager:OnNpcAIStateSync(data)
  local userId = data.charid
  if not userId then
    return
  end
  if userId ~= Game.Myself.data.id and data.aidata then
    for i = 1, #data.aidata do
      local eventData = data.aidata[i]
      local condition = eventData.eventid
      local conditionData = Table_AICondition[condition]
      if conditionData then
        local args = ReusableTable.CreateArray()
        args[1] = conditionData.Content
        args[2] = userId
        self:OnPlayerBehaviourEnter(args)
        ReusableTable.DestroyAndClearArray(args)
      end
    end
  end
end

function RandomAIManager:UpdateNpcAIState(args)
  local condition = args[1]
  local userId = args[2]
  local isEnter = args[3]
  if userId ~= game.Myself.data.id then
    return
  end
  local conditionData = Table_AICondition[condition]
  if not conditionData then
    return
  end
  if conditionData.NeedSync == 1 then
    self.syncConditionGuid = self.syncConditionGuid + 1
    local data = ReusableTable.CreateTable()
    data.eventid = condition
    data.guid = self.syncConditionGuid
    redlog("CallClientAIUpdateUserEvent", userId, data.eventid, data.guid, tostring(isEnter))
    ServiceUserEventProxy.Instance:CallClientAIUpdateUserEvent(userId, data, not isEnter)
    ReusableTable.DestroyAndClearTable(data)
  end
end

function RandomAIManager:OnNpcAIStateUpdate(data)
  local userId = data.charid
  if not userId or userId == Game.Myself.data.id then
    return
  end
  local eventData = data.aidata
  if not eventData then
    return
  end
  local condition = eventData.eventid
  local isExit = data.del
  local conditionData = Table_AICondition[condition]
  if conditionData then
    local args = ReusableTable.CreateArray()
    args[1] = conditionData.Content
    args[2] = userId
    if isExit then
      self:OnPlayerBehaviourExit(args)
    else
      self:OnPlayerBehaviourEnter(args)
    end
    ReusableTable.DestroyAndClearArray(args)
  end
end

function RandomAIManager:OnFlowerCarStart()
  if self.inFlowerCarPhase then
    return
  end
  if self.isRunning then
    self:DeactiveAll()
  end
  self.inFlowerCarPhase = true
end

function RandomAIManager:OnFlowerCarEnd()
  if not self.inFlowerCarPhase then
    return
  end
  self.inFlowerCarPhase = false
  if self.isRunning then
    self:ReactiveAll()
  end
end

function RandomAIManager:ClearData()
  self:ClearAIData()
  TableUtility.TableClearByDeleter(self.CPPool, function(list)
    TableUtility.ArrayClear(list)
  end)
  TableUtility.TableClear(self.cpMap)
  TableUtility.TableClear(self.multiEventMap)
end

function RandomAIManager:ClearAIData()
  TableUtility.TableClearByDeleter(self.subEventAIGroup, function(list)
    TableUtility.ArrayClear(list)
  end)
  TableUtility.TableClearByDeleter(self.aiPool, function(ai)
    ReusableObject.Destroy(ai)
  end)
  TableUtility.TableClear(self.cpAIMap)
  TableUtility.TableClear(self.interruptGroup)
  TableUtility.TableClear(self.questMap)
  TableUtility.TableClearByDeleter(self.conditionObserverMap, function(list)
    TableUtility.ArrayClear(list)
  end)
end

function RandomAIManager:Launch()
  if self.isRunning then
    return
  end
  self.isRunning = true
  self:AddEventListener()
  Game.PlotStoryManager:Launch(true)
  local mapId = game.MapManager:GetMapID()
  if GameConfig.LocalAI and GameConfig.LocalAI[mapId] and not self.inFlowerCarPhase then
    local npcIds = GameConfig.LocalAI[mapId]
    self:SetData(npcIds)
    self:StartAIBehaviour()
    self.isLocalNpc = true
    self.syncConditionGuid = 0
  end
end

function RandomAIManager:Shutdown()
  if not self.isRunning then
    return
  end
  self.isRunning = false
  self.isLocalNpc = nil
  self.syncConditionGuid = 0
  self:RemoveEventListener()
  self:ClearData()
end

function RandomAIManager:HandleReconnect()
  self:ClearAIData()
end

function RandomAIManager:OnSceneLoaded()
  local mapId = game.MapManager:GetMapID()
  if GameConfig.LocalAI and GameConfig.LocalAI[mapId] and not self.inFlowerCarPhase then
    local npcIds = GameConfig.LocalAI[mapId]
    self:InitNpcAI(npcIds)
    self:StartAIBehaviour()
  end
end

function RandomAIManager:Update(time, deltaTime)
  for _, ai in pairs(self.aiPool) do
    ai:Update(time, deltaTime)
  end
end
