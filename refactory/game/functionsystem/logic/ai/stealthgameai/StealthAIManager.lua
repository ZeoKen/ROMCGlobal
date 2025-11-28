autoImport("StealthNpcAI")
StealthAIManager = class("StealthAIManager")

function StealthAIManager:ctor()
  self.npcsMap = {}
  self.tmpNpcsList = {}
end

function StealthAIManager.Me()
  if not StealthAIManager.Instance then
    StealthAIManager.Instance = StealthAIManager.new()
  end
  return StealthAIManager.Instance
end

function StealthAIManager:SetData(npcIds)
  self:InitNpcAI(npcIds)
  self:InitData()
end

function StealthAIManager:InitNpcAI(npcIds)
  for i = 1, #npcIds do
    local ai = ReusableObject.Create(StealthNpcAI, false, npcIds[i])
    self.npcsMap[id] = ai
  end
end

function StealthAIManager:AddEventListener()
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
end

function StealthAIManager:RemoveEventListener()
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
end

function StealthAIManager:Launch()
  if self.running then
    return
  end
  self:AddEventListener()
  local mapId = Game.MapManager:GetMapID()
  self.running = true
end

function StealthAIManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self:RemoveEventListener()
end

function StealthAIManager:HandleReconnect()
end

function StealthAIManager:OnSceneLoaded()
  local mapId = game.MapManager:GetMapID()
  if GameConfig.LocalAI and GameConfig.LocalAI[mapId] and not self.inFlowerCarPhase then
    local npcIds = GameConfig.LocalAI[mapId]
    self:InitNpcAI(npcIds)
    self:StartAIBehaviour()
  end
end

function StealthAIManager:GetStealthNpc(guid)
  return self.npcsMap[guid]
end

function StealthAIManager:FindNearNpcs(position, distance, filter)
  local npcs = NSceneNpcProxy.Instance:FindNearNpcs(position, distance, function(npc)
    if not self.npcsMap[npc.data.id] then
      return false
    end
    return not filter or filter(npc)
  end)
  TableUtility.TableClear(self.tmpNpcsList)
  for i = 1, #npcs do
    self.tmpNpcsList[#self.tmpNpcsList + 1] = self.npcsMap[npcs[i].data.id]
  end
  return self.tmpNpcsList
end

function StealthAIManager:SendNoise(position, distance)
end

function StealthAIManager:Update(time, deltaTime)
  for _, ai in pairs(self.npcsMap) do
    ai:Update(time, deltaTime)
  end
end
