FollowNpcAIManager = class("FollowNpcAIManager")
local game = Game
local diff = 0.5

function FollowNpcAIManager:ctor()
  self.npcIds = {}
end

function FollowNpcAIManager.Me()
  if not FollowNpcAIManager.Instance then
    FollowNpcAIManager.Instance = FollowNpcAIManager.new()
  end
  return FollowNpcAIManager.Instance
end

function FollowNpcAIManager:Launch()
  if self.isRunning then
    return
  end
  if not self:IsNeedLaunch() then
    return
  end
  redlog("FollowNpcAIManager:Launch", #self.npcIds)
  self.isRunning = true
  self:AddEventListener()
  if #self.npcIds > 0 then
    self:CreateNpc(self.npcIds)
  end
end

function FollowNpcAIManager:Shutdown()
  if not self.isRunning then
    return
  end
  self.isRunning = false
  self:RemoveEventListener()
end

function FollowNpcAIManager:AddEventListener()
  EventManager.Me():AddEventListener(TriggerEvent.Enter_AIArea, self.OnTriggerEventEnter, self)
  EventManager.Me():AddEventListener(TriggerEvent.Leave_AIArea, self.OnTriggerEventLeave, self)
  EventManager.Me():AddEventListener(TriggerEvent.Leave_AIAway, self.OnTriggerEventAway, self)
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpc, self.OnAccessNpc, self)
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpcEnd, self.OnAccessNpcEnd, self)
end

function FollowNpcAIManager:RemoveEventListener()
  EventManager.Me():RemoveEventListener(TriggerEvent.Enter_AIArea, self.OnTriggerEventEnter, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.Leave_AIArea, self.OnTriggerEventLeave, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.Leave_AIAway, self.OnTriggerEventAway, self)
  EventManager.Me():RemoveEventListener(VisitNpcEvent.AccessNpc, self.OnAccessNpc, self)
  EventManager.Me():RemoveEventListener(VisitNpcEvent.AccessNpcEnd, self.OnAccessNpcEnd, self)
end

function FollowNpcAIManager:IsNeedLaunch()
  local mapId = game.MapManager:GetMapID()
  if GameConfig.FollowNpcAI and GameConfig.FollowNpcAI[mapId] then
    return true
  end
  return false
end

function FollowNpcAIManager:CreateNpc(npcIds, isNotifyServer)
  if not npcIds then
    return
  end
  redlog("FollowNpcAIManager:CreateNpc", npcIds[1])
  local myself = game.Myself
  local step = #npcIds - 1
  for i = 1, #npcIds do
    local npcId = npcIds[i]
    local data = {}
    data.npcID = npcId
    data.id = npcId
    local myPos = myself:GetPosition()
    local posX, posY, posZ = myPos[1], myPos[2], myPos[3]
    data.pos = {
      x = posX * 1000,
      y = posY * 1000,
      z = posZ * 1000
    }
    data.datas = {}
    data.attrs = {}
    data.mounts = {}
    local staticData = Table_Npc[npcId]
    data.staticData = staticData
    data.name = staticData.NameZh
    data.searchrange = 0
    local offsetX = (2 * i - 2 - step) * diff
    data.followTargetOffset = LuaVector3(offsetX, 0, 0)
    local npc = NSceneNpcProxy.Instance:Add(data, NFollowNpc)
    npc:SetWeakData("CreatureFollowTarget", myself)
    if isNotifyServer then
      self.npcIds[#self.npcIds + 1] = npcId
    end
  end
  if isNotifyServer then
    ServiceScenePetProxy.Instance:CallSevenRoyalsFollowNpc(npcIds, true)
  end
  return true
end

function FollowNpcAIManager:RemoveNpc(npcIds)
  if npcIds then
    for i = 1, #npcIds do
      local npcId = npcIds[i]
      NSceneNpcProxy.Instance:Remove(npcId)
      TableUtility.ArrayRemove(self.npcIds, npcId)
    end
    ServiceScenePetProxy.Instance:CallSevenRoyalsFollowNpc(npcIds, false)
    return true
  end
end

function FollowNpcAIManager:SetFollowNpc(npcIds)
  if not npcIds then
    return
  end
  redlog("FollowNpcAIManager:SetFollowNpc", npcIds[1])
  for i = 1, #npcIds do
    self.npcIds[i] = npcIds[i]
  end
end

function FollowNpcAIManager:AddNpcEvent(npcIds, eventId)
  if not npcIds then
    return
  end
  for i = 1, #npcIds do
    local npc = NSceneNpcProxy.Instance:Find(npcIds[i])
    if npc then
      npc.ai:AddEvent(eventId)
    end
  end
  local config = Table_FollowNpcEvent[eventId]
  redlog("FollowNpcAIManager:AddNpcEvent eventId", eventId)
  if config then
    local param = config.condition
    if param and next(param) then
      if param.type == AreaTrigger_Common_ClientType.AI_AreaCheck or param.type == AreaTrigger_Common_ClientType.AI_AwayCheck then
        local data = ReusableTable.CreateTable()
        data.id = param.id
        data.pos = param.pos
        data.range = param.range
        data.type = param.type
        SceneTriggerProxy.Instance:Add(data)
      elseif param.type == AreaTrigger_Npc_ClientType then
        local trigger = ReusableTable.CreateTable()
        trigger.id = param.id
        trigger.npcId = param.npcid
        trigger.uniqueId = param.uniqueid
        trigger.range = param.range
        game.AreaTrigger_Npc:AddCheck(trigger)
      end
    end
  end
end

function FollowNpcAIManager:RemoveNpcEvent(npcIds, eventId)
  if not npcIds then
    return
  end
  for i = 1, #npcIds do
    local npc = NSceneNpcProxy.Instance:Find(npcIds[i])
    if npc then
      npc.ai:RemoveEvent(eventId)
    end
  end
  local config = Table_FollowNpcEvent[eventId]
  if config then
    local param = config.condition
    if param and next(param) then
      local triggerId = param.id
      if param.type == AreaTrigger_Common_ClientType.AI_AreaCheck or param.type == AreaTrigger_Common_ClientType.AI_AwayCheck then
        SceneTriggerProxy.Instance:Remove(triggerId)
      elseif param.type == AreaTrigger_Npc_ClientType then
        local trigger = game.AreaTrigger_Npc:RemoveCheck(triggerId)
        ReusableTable.DestroyAndClearTable(trigger)
      end
    end
  end
end

function FollowNpcAIManager:ExecuteNpcEvent(npcIds, eventId)
  if not npcIds then
    return
  end
  for i = 1, #npcIds do
    local npc = NSceneNpcProxy.Instance:Find(npcIds[i])
    if npc then
      npc.ai:ExecuteEventDirectly(eventId)
    end
  end
end

function FollowNpcAIManager:OnTriggerEventEnter(triggerId)
  for i = 1, #self.npcIds do
    local npc = NSceneNpcProxy.Instance:Find(self.npcIds[i])
    if npc then
      npc.ai:OnConditionEnter(triggerId)
    end
  end
end

function FollowNpcAIManager:OnTriggerEventLeave(triggerId)
  for i = 1, #self.npcIds do
    local npc = NSceneNpcProxy.Instance:Find(self.npcIds[i])
    if npc then
      npc.ai:OnConditionLeave(triggerId)
    end
  end
end

function FollowNpcAIManager:OnTriggerEventAway(triggerId)
  for i = 1, #self.npcIds do
    local npc = NSceneNpcProxy.Instance:Find(self.npcIds[i])
    if npc then
      npc.ai:OnConditionTrigger(triggerId)
    end
  end
end

function FollowNpcAIManager:OnAccessNpc(note)
  local creature = note and note.data
  if creature and creature:GetCreatureType() == Creature_Type.Npc then
    local npcId = creature.data.staticData.id
    if TableUtility.ArrayFindIndex(self.npcIds, npcId) > 0 then
      local npc = NSceneNpcProxy.Instance:Find(npcId)
      if npc then
        npc.ai:OnVisitNpc()
      end
    end
  end
end

function FollowNpcAIManager:OnAccessNpcEnd(note)
  local creature = note and note.data
  if creature and creature:GetCreatureType() == Creature_Type.Npc then
    local npcId = creature.data.staticData.id
    if TableUtility.ArrayFindIndex(self.npcIds, npcId) > 0 then
      local npc = NSceneNpcProxy.Instance:Find(npcId)
      if npc then
        npc.ai:OnVisitNpcEnd()
      end
    end
  end
end
