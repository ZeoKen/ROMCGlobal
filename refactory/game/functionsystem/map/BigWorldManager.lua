autoImport("BigWorldData")
BigWorldManager = class("BigWorldManager")

function BigWorldManager:ctor()
  self.map = {}
  self.cacheStep = {}
  self.waitMap = {}
  BigWorld.BigWorldManager.SetMonsterCellRefreshAction(BigWorldManager.SetMonsterCellRefreshAction)
end

function BigWorldManager.SetMonsterCellRefreshAction(cellindex, add)
  local self = Game.BigWorldManager
  self.cacheStep[cellindex] = add == true and add or nil
  for k, v in pairs(self.map) do
    if v.cellIndex == cellindex then
      if add then
        self:RequestAddClientNpc(k)
      else
        self:RequestRemoveClientNpc(k, v.guid, v.uniqueID)
      end
    end
  end
  if self.orginDressDisableLevel == nil then
    self.orginDressDisableLevel = NNpc.MonsterDressDisableDistanceLevel
    NNpc.MonsterDressDisableDistanceLevel = LogicManager_MapCell.LODLevel.Invisible
  end
  if self.orginWorldTeleportValidRange == nil then
    self.orginWorldTeleportValidRange = WorldTeleport.DESTINATION_VALID_RANGE
    WorldTeleport.DESTINATION_VALID_RANGE = 750
  end
end

function BigWorldManager:RecvMapNpcShowMapCmd(data)
  Game.MapManager.clientNpcManager:Pause()
  Game.AreaTrigger_Mission:OnPlayerMapChangeReCheck()
  local noCache = false
  local mapId = Game.MapManager:GetMapID()
  if GameConfig.ClientShowNormalMap and TableUtility.ArrayFindIndex(GameConfig.ClientShowNormalMap, mapId) > 0 then
    noCache = true
  end
  local npc
  for i = 1, #data.npcs do
    npc = data.npcs[i]
    local guid = npc.guid
    local uniqueid = npc.uniqueid
    if guid ~= 0 then
      local info = self.map[uniqueid]
      if info ~= nil then
        self:ChangeClientNpc(uniqueid, guid, info)
        info:SetServerData(npc)
        NSceneNpcProxy.Instance:ChangeClientNpc(uniqueid, guid)
      else
        info = self.map[guid]
        if info == nil then
          info = BigWorldData.CreateAsTable()
          self.map[guid] = info
          info:SetServerData(npc)
          if noCache or self.cacheStep[info.cellIndex] then
            self:RequestAddClientNpc(guid)
          end
        end
      end
    else
      local info = self.map[uniqueid]
      if info == nil then
        local sceneinfo = Game.MapManager:GetNpcInfoByUniqueID(uniqueid)
        if sceneinfo ~= nil then
          info = BigWorldData.CreateAsTable()
          info:SetSceneInfo(sceneinfo)
          self.map[uniqueid] = info
          if noCache or self.cacheStep[info.cellIndex] then
            self:RequestAddClientNpc(uniqueid)
          end
        end
      end
    end
  end
end

function BigWorldManager:RecvMapNpcDelMapCmd(data)
  local npc
  for i = 1, #data.npcs do
    npc = data.npcs[i]
    local id, info = self:GetData(npc.guid, npc.uniqueid)
    if info ~= nil then
      self:RequestRemoveClientNpc(id, npc.guid, npc.uniqueid)
      info:Destroy()
      self.map[id] = nil
    end
  end
  for i = 1, #data.invalid_guid_npcs do
    self:ChangeInvalidNpc(data.invalid_guid_npcs[i])
  end
end

function BigWorldManager:RecvNpcPreloadForbidMapCmd(uniqueIds)
  for i = 1, #uniqueIds do
    local uniqueid = uniqueIds[i]
    local info = self.map[uniqueid]
    if info == nil then
      local npc = NSceneNpcProxy.Instance:GetClientNpcInfo(nil, uniqueid)
      if npc ~= nil then
        npc.data:ClearClientData()
      end
    end
  end
end

function BigWorldManager:RequestAddClientNpc(id)
  if self.waitMap[id] ~= nil then
    return
  end
  self.waitMap[id] = true
end

function BigWorldManager:RequestRemoveClientNpc(id, guid, uniqueid)
  self.waitMap[id] = nil
  self:RemoveClientNpc(guid, uniqueid)
end

function BigWorldManager:AddClientNpc(data)
  local npc = NSceneNpcProxy.Instance:GetClientNpcInfo(data.guid, data.uniqueID)
  npc = npc or SceneCreatureProxy.FindCreature(data.guid)
  npc = npc or data.uniqueID ~= 0 and NSceneNpcProxy.Instance:FindNpc(data.ID, data.uniqueID) or nil
  if npc ~= nil then
    return
  end
  local clientData = NpcData.CreateClientData(data)
  if clientData then
    local clientNpc = NNpc.CreateAsTable(clientData)
    NSceneNpcProxy.Instance:AddClientNpc(clientNpc)
    EventManager.Me():PassEvent(BigWorldClientEvent.ClientNpcLoaded)
  end
end

function BigWorldManager:RemoveClientNpc(guid, uniqueid)
  local clientNpc, key = NSceneNpcProxy.Instance:GetClientNpcInfo(guid, uniqueid)
  if clientNpc == nil then
    clientNpc = NSceneNpcProxy.Instance:PureFind(guid)
    if clientNpc ~= nil then
      clientNpc.data:ClearClientData()
    end
    return
  end
  NSceneNpcProxy.Instance:RemoveFromClientMap(key)
  clientNpc:Destroy()
end

function BigWorldManager:ChangeInvalidNpc(guid)
  local data = self.map[guid]
  if data ~= nil then
    local uniqueid = data.uniqueID
    if uniqueid ~= nil and uniqueid ~= 0 then
      data.guid = nil
    end
    self:ChangeClientNpc(guid, uniqueid, data)
    NSceneNpcProxy.Instance:ChangeClientNpc(guid, uniqueid)
  end
end

function BigWorldManager:ChangeClientNpc(from, to, data)
  if from == nil or from == 0 or to == nil or to == 0 then
    return
  end
  self.map[from] = nil
  self.map[to] = data
  local wait = self.waitMap[from]
  if wait ~= nil then
    self.waitMap[from] = nil
    self.waitMap[to] = wait
  end
end

function BigWorldManager:GetData(guid, uniqueid)
  if guid ~= 0 then
    local info = self.map[guid]
    if info ~= nil then
      return guid, info
    end
  end
  if uniqueid ~= 0 then
    local info = self.map[uniqueid]
    if info ~= nil then
      return uniqueid, info
    end
  end
end

function BigWorldManager:Update(time, deltaTime)
  if self.stopped then
    return
  end
  for k, v in pairs(self.waitMap) do
    local info = self.map[k]
    if info ~= nil then
      self:AddClientNpc(info)
      self.waitMap[k] = nil
      break
    else
      self.waitMap[k] = nil
    end
  end
end

function BigWorldManager:Shutdown()
  self:Clear()
  self.stopped = nil
  if self.orginDressDisableLevel ~= nil then
    NNpc.MonsterDressDisableDistanceLevel = self.orginDressDisableLevel
    self.orginDressDisableLevel = nil
  end
  if self.orginWorldTeleportValidRange ~= nil then
    WorldTeleport.DESTINATION_VALID_RANGE = self.orginWorldTeleportValidRange
    self.orginWorldTeleportValidRange = nil
  end
end

function BigWorldManager:Clear()
  for k, v in pairs(self.map) do
    self:RemoveClientNpc(v.guid, v.uniqueID)
    v:Destroy()
    self.map[k] = nil
  end
  TableUtility.TableClear(self.cacheStep)
  TableUtility.TableClear(self.waitMap)
  NSceneNpcProxy.Instance:ClearClientNpcs()
end

function BigWorldManager:Stop()
  if self.stopped then
    return
  end
  self.stopped = true
  self:Clear()
end

function BigWorldManager:Start()
  self:Shutdown()
end
