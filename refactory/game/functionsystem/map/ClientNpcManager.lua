ClientNpcManager = class("ClientNpcManager")
local ClientNpcRange = GameConfig.System.ClientNpcRange or 50
local V3_Distance = function(a, b)
  local x = a[1] - b[1]
  local y = a[2] - b[2]
  local z = a[3] - b[3]
  return math.sqrt(x * x + y * y + z * z)
end

function ClientNpcManager:ctor(mapManager)
  self.mapManager = mapManager
  self.running = false
  self.cacheMyPos = LuaVector3.New(9999, 9999, 9999)
end

function ClientNpcManager:Launch()
  if not self.mapManager:IsMainCity() then
    return
  end
  local npcPoints = self.mapManager:GetNPCPointArray()
  if npcPoints then
    self.running = true
    self.npcPointMap = {}
    for _, npcPoint in pairs(npcPoints) do
      if npcPoint.uniqueID then
        self.npcPointMap[npcPoint.uniqueID] = npcPoint
      end
    end
  end
end

function ClientNpcManager:Update(time, deltaTime, forceUpdate)
  if not (self.running and self.npcPointMap) or self.paused then
    return
  end
  local myPos = Game.Myself:GetPosition()
  if not forceUpdate and V3_Distance(self.cacheMyPos, myPos) < 0.01 then
    return
  end
  self.cacheMyPos:Set(myPos[1], myPos[2], myPos[3])
  for k, point in pairs(self.npcPointMap) do
    if V3_Distance(point.position, myPos) < ClientNpcRange and (not self.forbidMap or not self.forbidMap[point.uniqueID]) then
      self:CreateClientNpc(point)
    else
      self:RemoveClientNpc(point)
    end
  end
end

function ClientNpcManager:CreateClientNpc(point)
  local clientNpc = NSceneNpcProxy.Instance:GetClientNpc(point.uniqueID)
  if not clientNpc and not point.init_no_summon then
    local npcSData = Table_Npc[point.ID]
    if not npcSData or npcSData.Hide or npcSData.NormalDisplay or npcSData.DefaultNotShown then
      return
    end
    if FunctionUnLockFunc.CheckNpcIsForbiddenByFuncState(point.ID) then
      return
    end
    local npc = NSceneNpcProxy.Instance:FindNpc(point.ID, point.uniqueID)
    if npc then
      if not npc.data:GetClientData() then
        local clientData = NpcData.CreateClientData(point)
        if clientData then
          npc.data:SetClientData(clientData)
        end
      end
    else
      local clientData = NpcData.CreateClientData(point)
      if clientData then
        local clientNpc = NNpc.CreateAsTable(clientData)
        NSceneNpcProxy.Instance:AddClientNpc(clientNpc)
      end
    end
  end
end

function ClientNpcManager:RemoveClientNpc(point)
  local clientNpc = NSceneNpcProxy.Instance:GetClientNpc(point.uniqueID)
  if clientNpc then
    NSceneNpcProxy.Instance:RemoveFromClientMap(point.uniqueID)
    clientNpc:Destroy()
  end
end

function ClientNpcManager:Shutdown()
  self.paused = nil
  self:Clear()
  self.running = false
  self.npcPointMap = nil
end

function ClientNpcManager:Clear()
  NSceneNpcProxy.Instance:ClearClientNpcs()
end

function ClientNpcManager:SetForbidNpcUniqueIds(mapID, uniqueIds)
  self.forbidMap = {}
  for i = 1, #uniqueIds do
    self.forbidMap[uniqueIds[i]] = 1
  end
  self:Update(nil, nil, true)
end

function ClientNpcManager:IsForbid(npc)
  local uniqueid = npc and npc.data and npc.data.uniqueid
  if uniqueid and self.forbidMap and self.forbidMap[uniqueid] then
    return true
  end
  return false
end

function ClientNpcManager:Pause()
  if self.paused then
    return
  end
  self.paused = true
  self:Clear()
end

function ClientNpcManager:Resume()
  self.paused = nil
  self:Update()
end
