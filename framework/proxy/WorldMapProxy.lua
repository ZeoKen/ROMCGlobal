WorldMapProxy = class("WorldMapProxy", pm.Proxy)
WorldMapProxy.Instance = nil
WorldMapProxy.NAME = "WorldMapProxy"
autoImport("MapAreaData")
autoImport("MapStatusData")
WorldMapCellSize = {x = 142, y = 142}
WorldMapOriPos = {60, -72}
WorldMapProxy.Size_X = 28
WorldMapProxy.Size_Y = 16
WorldMapProxy.Ori_X = 14
WorldMapProxy.Ori_Y = 8

function WorldMapProxy:ctor(proxyName, data)
  self.proxyName = proxyName or WorldMapProxy.NAME
  if WorldMapProxy.Instance == nil then
    WorldMapProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function WorldMapProxy:Init()
  self.worldQuestMap = {}
  self.tableMapDatas = {}
  self.availableTransmitterMap = {}
  self:InitMapDatas()
  self.worldmapQuestList = {}
  self.followBannedMapList = {}
  self.cloneMapList = {}
  self.cloneMapDatas = {}
end

function WorldMapProxy:InitMapDatas()
  self.mapAreaDatas = {}
  local tableworldmap = not (not Table_WorldMap or TableUtil.TableIsEmpty(Table_WorldMap)) and Table_WorldMap or {
    [1] = {}
  }
  for k, _ in pairs(tableworldmap) do
    local worldmap = {}
    for i = 1, self.Size_X do
      for j = 1, self.Size_Y do
        table.insert(worldmap, i * 10000 + j)
      end
    end
    self.mapAreaDatas[k] = worldmap
  end
  local maxIndex = self.Size_X * self.Size_Y
  local x, y, index, world
  for id, mapSData in pairs(Table_Map) do
    x = mapSData.Position[1]
    y = mapSData.Position[2]
    world = mapSData.World or 1
    if x and y and id == mapSData.MapArea then
      x = x + self.Ori_X
      y = y + self.Ori_Y
      index = self.Size_X * (y - 1) + x
      if maxIndex >= index and self.mapAreaDatas[world] then
        self.mapAreaDatas[world][index] = MapAreaData.new(id, x, y)
      end
    end
  end
  self.mapTransmitterDatas = {}
  self.mapTransmitterNpcMap = {}
  local mapGroup, mapID
  if Table_DeathTransferMap then
    local datas = {}
    for _, transferData in pairs(Table_DeathTransferMap) do
      datas[#datas + 1] = transferData
    end
    table.sort(datas, function(a, b)
      return a.id < b.id
    end)
    for i = 1, #datas do
      local transferData = datas[i]
      mapGroup = transferData.MapGroup
      if mapGroup then
        if not self.mapTransmitterDatas[mapGroup] then
          self.mapTransmitterDatas[mapGroup] = {}
        end
        mapID = transferData.MapID
        if not self.mapTransmitterDatas[mapGroup][mapID] then
          self.mapTransmitterDatas[mapGroup][mapID] = {}
        end
        self.mapTransmitterDatas[mapGroup][mapID][#self.mapTransmitterDatas[mapGroup][mapID] + 1] = transferData
      else
        redlog("Missing MapGroup")
      end
      local mapid = transferData.MapID
      if not self.availableTransmitterMap[mapid] then
        self.availableTransmitterMap[mapid] = mapid
      end
      self.mapTransmitterNpcMap[transferData.NpcID] = transferData.id
    end
  end
  self.activeMaps = {}
  self.activeTransmitterPoints = {}
  self.curQuestPosDatas = {}
  self.activeWorlds = {}
end

function WorldMapProxy:GetMapAreaDatas(world)
  return self.mapAreaDatas[world or 1]
end

function WorldMapProxy:RecvGoToListUser(data)
  for i = 1, #data.mapid do
    self:AddActiveMap(data.mapid[i])
  end
end

function WorldMapProxy:AddActiveMap(mapID)
  if mapID == nil then
    return
  end
  self.activeMaps[mapID] = 1
  local mapData = Table_Map[mapID]
  if mapData and mapData.World then
    self.activeMaps[mapData.World] = 1
  end
end

function WorldMapProxy:RecvDeathTransferList(data)
  TableUtility.TableClear(self.activeTransmitterPoints)
  local transferIDs = data.transferId
  for i = 1, #transferIDs do
    self.activeTransmitterPoints[transferIDs[i]] = 1
  end
end

function WorldMapProxy:AddDeathTransferPoint(data)
  local transferId = data.transferId
  local active = data.active
  self.activeTransmitterPoints[transferId] = active and 1 or 0
end

function WorldMapProxy:GetMapAreaDataByMapId(mapid)
  local mapData = Table_Map[mapid]
  if mapData == nil then
    helplog(string.format("MapData Is Nil(id:%s)", mapid))
    return
  end
  local areaid = mapData.MapArea
  if areaid == nil then
    return
  end
  local areaSData = Table_Map[areaid]
  if areaSData == nil then
    return
  end
  local areaData, index = self:GetMapAreaDataByPos(areaSData.Position[1], areaSData.Position[2], areaSData.World)
  if areaData ~= nil then
    return areaData, index
  end
  redlog("Not Find AreaData By Position.")
  for _, worlddata in pairs(self.mapAreaDatas) do
    for k, v in pairs(worlddata) do
      if type(v) == "table" and v.mapid == mapid then
        return v
      end
    end
  end
end

function WorldMapProxy:GetMapAreaDataByPos(x, y, world)
  if x == nil or y == nil then
    return
  end
  x = x + self.Ori_X
  y = y + self.Ori_Y
  world = world or 1
  local index = self.Size_X * (y - 1) + x
  local d = self.mapAreaDatas[world] and self.mapAreaDatas[world][index]
  if not d or type(d) == "number" then
    return
  end
  return d, index
end

function WorldMapProxy:ActiveMapAreaData(mapid, active, isNew)
  local areaData = self:GetMapAreaDataByMapId(mapid)
  if type(areaData) ~= "table" then
    return
  end
  if active == nil then
    active = true
  end
  areaData:SetActive(active)
  areaData:SetIsNew(isNew)
  FunctionGuide.Me():RemoveMapGuide(mapid)
end

function WorldMapProxy:SetCurQuestPosData(id, pos)
  self.curQuestPosDatas[id] = LuaVector3.New(pos[1], pos[2], pos[3])
end

function WorldMapProxy:RemoveCurQuestPosData(id)
  self.curQuestPosDatas[id] = nil
end

function WorldMapProxy:GetCurQuestPosDatas()
  return self.curQuestPosDatas
end

function WorldMapProxy:SetWorldQuestInfo(server_quests)
  if server_quests == nil then
    return
  end
  TableUtility.TableClear(self.worldQuestMap)
  for i = 1, #server_quests do
    local server_quest = server_quests[i]
    if server_quest then
      local client_quest = self.worldQuestMap[server_quest.mapid]
      if client_quest == nil then
        client_quest = {}
        client_quest[1] = server_quest.type_main
        client_quest[2] = server_quest.type_branch
        client_quest[3] = server_quest.type_daily
        self.worldQuestMap[server_quest.mapid] = client_quest
      end
    end
  end
end

function WorldMapProxy:GetWorldQuestInfo(mapid)
  return self.worldQuestMap[mapid]
end

function WorldMapProxy:GetTransmitGroupByNpcId(npcid)
  for groupid, groupdata in pairs(self.mapTransmitterDatas) do
    for mapid, mapdata in pairs(groupdata) do
      for i = 1, #mapdata do
        if mapdata[i].NpcID == npcid then
          return groupid
        end
      end
    end
  end
  return nil
end

function WorldMapProxy:GetTransmitterMapByGroup(groupID)
  if self.mapTransmitterDatas[groupID] then
    return self.mapTransmitterDatas[groupID]
  else
    return nil
  end
end

function WorldMapProxy:GetTransmitterIDByNpcID(npcid)
  if self.mapTransmitterNpcMap[npcid] then
    return self.mapTransmitterNpcMap[npcid]
  end
end

function WorldMapProxy:CheckTransmitterNpcIsActive(npcid)
  local transferID = self:GetTransmitterIDByNpcID(npcid)
  if transferID then
    if self.activeTransmitterPoints[transferID] then
      return true
    end
    return false
  else
    redlog("No TransferID  Check Table_DeathTransferMap", npcid)
    return false
  end
end

function WorldMapProxy:SetQueryQuestList(serverData)
  redlog("WorldMapProxy:SetQueryQuestList", serverData.mapid, #serverData.datas)
  local mapid = serverData.mapid
  local questData = serverData.datas
  if self.worldmapQuestList[mapid] then
    for i = 1, #questData do
      local single = questData[i]
      if single.id ~= 0 then
        local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
        questData:setQuestData(single)
        self.worldmapQuestList[mapid][single.id] = questData
      end
    end
  else
    local list = {}
    for i = 1, #questData do
      local single = questData[i]
      if single.id ~= 0 then
        local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
        questData:setQuestData(single)
        list[single.id] = questData
      end
    end
    self.worldmapQuestList[mapid] = list
  end
end

local endlessBattleFieldGroup = {151, 152}

function WorldMapProxy:GetQueryQuestList(mapid)
  if not self.worldmapQuestList[mapid] then
    redlog("获取不到任务")
  else
    local result = {}
    if TableUtility.ArrayFindIndex(endlessBattleFieldGroup, mapid) > 0 then
      for i = 1, #endlessBattleFieldGroup do
        if self.worldmapQuestList[endlessBattleFieldGroup[i]] then
          for _, v in pairs(self.worldmapQuestList[endlessBattleFieldGroup[i]]) do
            table.insert(result, v)
          end
        end
      end
    else
      for _, v in pairs(self.worldmapQuestList[mapid]) do
        table.insert(result, v)
      end
    end
    return result
  end
end

function WorldMapProxy:ClearQueryQuestList()
  redlog("清理任务缓存")
  TableUtility.TableClear(self.worldmapQuestList)
end

function WorldMapProxy:RecvFollowBannedMapList(data)
  local list = data.list
  local updateFlag = data.updateflag
  if list and 0 < #list then
    if not updateFlag then
      for i = 1, #list do
        local single = list[i]
        self.followBannedMapList[single] = 1
      end
    else
      for i = 1, #list do
        local single = list[i]
        if self.followBannedMapList[single] then
          self.followBannedMapList[single] = 0
        end
      end
    end
  end
end

function WorldMapProxy:CheckMapBannedFollow(mapid)
  if mapid then
    if self.followBannedMapList[mapid] then
      if self.followBannedMapList[mapid] == 1 then
        return true
      else
        return false
      end
    end
    return false
  end
  return false
end

function WorldMapProxy:RecvQueryCloneMapStatusMap(datas)
  TableUtility.ArrayClear(self.cloneMapList)
  local status = datas.status
  for i = 1, #status do
    self.cloneMapList[#self.cloneMapList + 1] = MapStatusData.new(status[i])
  end
end

function WorldMapProxy:GetCloneMapList()
  TableUtility.ArrayClear(self.cloneMapDatas)
  local mapid = Game.MapManager:GetMapID()
  local isClone = self:IsCloneMap()
  local data
  for i = 1, #self.cloneMapList do
    data = self.cloneMapList[i]
    if isClone then
      self.cloneMapDatas[#self.cloneMapDatas + 1] = data
    elseif data.id ~= mapid then
      self.cloneMapDatas[#self.cloneMapDatas + 1] = data
    end
  end
  return self.cloneMapDatas
end

function WorldMapProxy:GetCloneMapData(sceneid)
  local data
  for i = 1, #self.cloneMapList do
    data = self.cloneMapList[i]
    if data.id == sceneid then
      return data
    end
  end
  return nil
end

function WorldMapProxy:IsCloneMap()
  local mapid = Game.MapManager:GetMapID()
  local data = Table_Map[mapid]
  if data ~= nil and data.CloneMap ~= nil then
    return Game.MapManager:GetSceneID() // 100 == mapid
  end
  return false
end

autoImport("BWMapZoneData")

function WorldMapProxy:UpdateBWZoneInfo(mapID)
  self.zoneMap = nil
  self.regionMap = nil
  if not Table_BWMapZone then
    return
  end
  for id, zoneData in pairs(Table_BWMapZone) do
    if zoneData.MapId == mapID then
      if zoneData.Type == 2 then
        if not self.zoneMap then
          self.zoneMap = {}
        end
        self.zoneMap[id] = BWMapZoneData.new(zoneData)
        if zoneData.RegionId then
          if not self.regionMap then
            self.regionMap = {}
          end
          self.regionMap[zoneData.RegionId] = zoneData
        end
      elseif zoneData.Type == 3 and zoneData.RegionId then
        if not self.regionMap then
          self.regionMap = {}
        end
        self.regionMap[zoneData.RegionId] = zoneData
      end
    end
  end
end

function WorldMapProxy:RefreshBWZoneInfo()
  for k, v in pairs(self.zoneMap) do
    v:RefreshData()
  end
end

function WorldMapProxy:GetZoneMap()
  return self.zoneMap
end

function WorldMapProxy:GetRegionMap()
  return self.regionMap
end

function WorldMapProxy:GetBWAreaTips()
  if not Table_BWMapZone then
    return
  end
  local rets = {}
  local mapId = Game.MapManager:GetMapID()
  for id, zoneData in pairs(Table_BWMapZone) do
    if zoneData.MapId == mapId and zoneData.Type == 1 then
      table.insert(rets, zoneData)
    end
  end
  return rets
end

function WorldMapProxy:SetMapStepForeverRewardInfo(serverData)
  self.mapStepFRewardMap = {}
  local infos = serverData.infos
  if infos then
    for i = 1, #infos do
      local stepId = infos[i].mapstep_questid
      local groupId = infos[i].mapstep_groupid
      self.mapStepFRewardMap[stepId] = 1
    end
  end
end

function WorldMapProxy:GetMapStepForeverRewardInfo(stepId)
  return self.mapStepFRewardMap and self.mapStepFRewardMap[stepId] == 1
end

function WorldMapProxy:DebugPrintZoneProgressInfo()
  if not self.zoneMap then
    return
  end
  for k, v in pairs(self.zoneMap) do
    v:DebugPrintProgressInfo()
  end
end

function WorldMapProxy:GetUnlockBWZoneByMapID(targetMapID)
  local activePoints = WorldMapProxy.Instance.activeTransmitterPoints
  local unlockedZone = {}
  for groupid, groupdata in pairs(self.mapTransmitterDatas) do
    for mapid, transfers in pairs(groupdata) do
      if mapid == targetMapID then
        for i = 1, #transfers do
          local transferID = transfers[i].id
          unlockedZone[i] = activePoints[transferID] == 1
        end
      end
    end
  end
  return unlockedZone
end
