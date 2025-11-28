PveRaidType = {
  Rugelike = FuBenCmd_pb.ERAIDTYPE_ROGUELIKE or 46,
  PveCard = FuBenCmd_pb.ERAIDTYPE_PVECARD or 28,
  DeadBoss = FuBenCmd_pb.ERAIDTYPE_DEADBOSS or 51,
  Headwear = FuBenCmd_pb.ERAIDTYPE_HEADWEAR or 43,
  Comodo = FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or 59,
  MultiBoss = FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID or 62,
  InfiniteTower = FuBenCmd_pb.ERAIDTYPE_TOWER or 4,
  Thanatos = FuBenCmd_pb.ERAIDTYPE_THANATOS or 35,
  Crack = FuBenCmd_pb.ERAIDTYPE_CRACK or 65,
  GuildRaid = FuBenCmd_pb.ERAIDTYPE_GUILDRAID,
  Boss = FuBenCmd_pb.ERAIDTYPE_BOSS or 68,
  EquipUpgrade = FuBenCmd_pb.ERAIDTYPE_EQUIP_UP or 69,
  Element = FuBenCmd_pb.ERAIDTYPE_ELEMENT or 70,
  StarArk = FuBenCmd_pb.ERAIDTYPE_STAR_ARK or 71,
  NormalMaterials = FuBenCmd_pb.ERAIDTYPE_COMMON_MATERIALS or 73,
  RoadOfHero = FuBenCmd_pb.ERAIDTYPE_HERO_JOURNEY or 76,
  MemoryPalace = FuBenCmd_pb.ERAIDTYPE_MEMORY_RAID or 80,
  Astral = FuBenCmd_pb.ERAIDTYPE_ASTRAL or 79,
  MemoryRaid = FuBenCmd_pb.ERAIDTYPE_MEMORY_RAID or 80,
  SpaceTimeIllusion = FuBenCmd_pb.ERAIDTYPE_SPACETIME_ILLUSION or 81
}
RaidType2AERewardMode = {
  [PveRaidType.Crack] = ActivityEvent_pb.EAEREWARDMODE_SEAL,
  [PveRaidType.InfiniteTower] = ActivityEvent_pb.EAEREWARDMODE_TOWER,
  [PveRaidType.GuildRaid] = ActivityEvent_pb.EAEREWARDMODE_GUILDRAID,
  [PveRaidType.PveCard] = ActivityEvent_pb.EAEREWARDMODE_PVECARD,
  [PveRaidType.Thanatos] = ActivityEvent_pb.EAEREWARDMODE_TEAMGROUP,
  [PveRaidType.Comodo] = ActivityEvent_pb.EAEREWARDMODE_Comodo_Team,
  [PveRaidType.MultiBoss] = ActivityEvent_pb.EAEREWARDMODE_MULTIBOSS,
  [PveRaidType.EquipUpgrade] = ActivityEvent_pb.EAEREWARDMODE_EQUIP_UP_RAID,
  [PveRaidType.MemoryPalace] = ActivityEvent_pb.EAEREWARDMODE_MEMORY_PALACE,
  [PveRaidType.MemoryRaid] = ActivityEvent_pb.EAEREWARDMODE_MEMORY_RAID
}
RaidType2GroupID = {
  [PveRaidType.Rugelike] = 8,
  [PveRaidType.PveCard] = 4,
  [PveRaidType.DeadBoss] = 6,
  [PveRaidType.Headwear] = 3,
  [PveRaidType.Comodo] = 1,
  [PveRaidType.MultiBoss] = 2,
  [PveRaidType.InfiniteTower] = 5,
  [PveRaidType.Thanatos] = 7,
  [PveRaidType.Crack] = 9,
  [PveRaidType.GuildRaid] = 19,
  [PveRaidType.Boss] = 20,
  [PveRaidType.NormalMaterials] = EPVEGROUPTYPE_COMMON_MATERIALS or 32,
  [PveRaidType.MemoryPalace] = 33,
  [PveRaidType.MemoryRaid] = 40,
  [PveRaidType.SpaceTimeIllusion] = 44
}
RaidType2AERewardMode = {
  [PveRaidType.Comodo] = AERewardType.ComodoRaid,
  [PveRaidType.MultiBoss] = AERewardType.SevenRoyalFamiliesRaid,
  [PveRaidType.PveCard] = AERewardType.PveCard,
  [PveRaidType.InfiniteTower] = AERewardType.Tower,
  [PveRaidType.Thanatos] = AERewardType.TeamGroup,
  [PveRaidType.MemoryPalace] = ActivityEvent_pb.EAEREWARDMODE_MEMORY_PALACE,
  [PveRaidType.MemoryRaid] = ActivityEvent_pb.EAEREWARDMODE_MEMORY_RAID
}
ServerMergeStatus = {
  None = 0,
  InProcess = 1,
  Wait = 2,
  CountDown = 3,
  Open = 4
}
Pve_Difficulty_Type = {Normal = 0, Difficult = 1}
local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
PveSortEnum = {
  Open = 1,
  Lock = 2,
  Forbidden = 3
}
local _SortFunc = function(l, r)
  local l_sortId = l:GetSortId()
  local r_sortId = r:GetSortId()
  local l_configSortId = l.staticEntranceData.configSortID
  local r_configSortId = r.staticEntranceData.configSortID
  if l_sortId == r_sortId then
    if l_configSortId == r_configSortId then
      return l.id < r.id
    else
      return l_configSortId < r_configSortId
    end
  else
    return l_sortId < r_sortId
  end
end
local _SortByDifficulty = function(l, r)
  return l.staticEntranceData.staticDifficulty < r.staticEntranceData.staticDifficulty
end
autoImport("PvePassInfo")
autoImport("PveDropItemData")
PveEntranceProxy = class("PveEntranceProxy", pm.Proxy)
PveEntranceProxy.Instance = nil
PveEntranceProxy.NAME = "PveEntranceProxy"
PveEntranceProxy.EmptyDiff = "EMPTY_DIFF"
local EUseItem_QuickPass = {roguelike = 1, thanatos = 2}
local quick_pass_msg = {
  [EUseItem_QuickPass.roguelike] = 43598,
  [EUseItem_QuickPass.thanatos] = 43601
}

function PveEntranceProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PveEntranceProxy.NAME
  if PveEntranceProxy.Instance == nil then
    PveEntranceProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function PveEntranceProxy:Init()
  self.raidMap = {}
  self.catalogAll = {}
  self.dirtyRaidForbiddenMap = {}
  self.catalogAll_raid = {}
  self.catalogAll_crack = {}
  self.catalogAll_boss = {}
  self.catalogAll_SpaceTimeIllusion = {}
  self.catalogAll_RoadOfHero = {}
  self.catalogAll_Astral = {}
  self.catalogAll_Memory = {}
  self.catalogMap = {}
  self.catalogMap_raid = {}
  self.catalogMap_crack = {}
  self.catalogMap_boss = {}
  self.catalogMap_RoadOfHero = {}
  self.catalogMap_Astral = {}
  self.catalogMap_Memory = {}
  self.catalogMap_SpaceTimeIllusion = {}
  self.passInfoMap = {}
  self.targetMap = {}
  self.dropMap = {}
  self.raidCombinedMap = {}
  self.teamLeaderOpenMap = {}
  self.pvecardRewardTime = {}
  self.goalMap = {}
  self.bossId2MatchIdMap = {}
  self.quickBossMap = {}
  self:InitMultiRewardCondition()
end

function PveEntranceProxy:TryResetCatalogAll()
  if not next(self.dirtyRaidForbiddenMap) and self.initialAllCatalog then
    return
  end
  _ArrayClear(self.catalogAll_raid)
  _ArrayClear(self.catalogAll_crack)
  _ArrayClear(self.catalogAll_boss)
  _ArrayClear(self.catalogAll_SpaceTimeIllusion)
  _ArrayClear(self.catalogAll_RoadOfHero)
  _ArrayClear(self.catalogAll_Astral)
  _ArrayClear(self.catalogAll_Memory)
  _TableClear(self.catalogMap_raid)
  self:SetAllCatalogByRaidMap()
  _TableClear(self.dirtyRaidForbiddenMap)
end

function PveEntranceProxy:SetAllCatalogByRaidMap()
  self.initialAllCatalog = true
  for _, difficultyMap in pairs(self.raidMap) do
    local firstPveData = difficultyMap[1]
    if not firstPveData then
      redlog("error groupid: ", _)
    end
    if firstPveData.staticEntranceData:IsCrack() then
      _ArrayPushBack(self.catalogAll_crack, firstPveData)
    elseif firstPveData.staticEntranceData:IsBoss() then
      if not firstPveData:Forbidden() then
        _ArrayPushBack(self.catalogAll_boss, firstPveData)
      end
    elseif firstPveData.staticEntranceData:IsSpaceTimeIllusion() then
      for index, data in pairs(difficultyMap) do
        if not data:Forbidden() then
          _ArrayPushBack(self.catalogAll_SpaceTimeIllusion, data)
        end
      end
    elseif firstPveData.staticEntranceData:IsRoadOfHero() then
      _ArrayPushBack(self.catalogAll_RoadOfHero, firstPveData)
    elseif firstPveData.staticEntranceData:IsAstral() then
      _ArrayPushBack(self.catalogAll_Astral, firstPveData)
    elseif firstPveData.staticEntranceData:IsMemoryRaid() then
      _ArrayPushBack(self.catalogAll_Memory, firstPveData)
    else
      local catalogs = firstPveData.staticEntranceData.staticData.Catalog
      for i = 1, #catalogs do
        local catalogData = self.catalogMap_raid[catalogs[i]]
        catalogData = catalogData or {}
        catalogData[#catalogData + 1] = firstPveData
        self.catalogMap_raid[catalogs[i]] = catalogData
      end
      _ArrayPushBack(self.catalogAll_raid, firstPveData)
    end
  end
  self:StaticSortEntrance()
end

function PveEntranceProxy:TryInitStatic()
  if self._inited then
    return
  end
  self._inited = true
  PveEntranceProxy.minUnlockLv = 999
  PveEntranceProxy.endlessTowerUnlockLv = 999
  for k, v in pairs(Table_PveRaidEntrance) do
    if v.Goal then
      self.goalMap[v.Goal] = v.id
    end
    local difficultyMap = self.raidMap[v.GroupId]
    if nil == difficultyMap then
      difficultyMap = {}
    end
    local data = PvePassInfo.new(k)
    difficultyMap[v.DifficultyName[2]] = data
    self.raidMap[v.GroupId] = difficultyMap
    PveEntranceProxy.minUnlockLv = math.min(PveEntranceProxy.minUnlockLv, v.UnlockLv)
    if data.staticEntranceData:IsInfiniteTower() then
      PveEntranceProxy.endlessTowerUnlockLv = math.min(PveEntranceProxy.endlessTowerUnlockLv, data.staticEntranceData.UnlockLv)
    end
  end
  self:SetAllCatalogByRaidMap()
end

function PveEntranceProxy:PreprocessCrackEntrance()
  _TableClear(self.catalogMap_crack)
  local maxLvEntranceData
  for i = #self.catalogAll_crack, 1, -1 do
    if self:IsOpen(self.catalogAll_crack[i].id) then
      maxLvEntranceData = self.catalogAll_crack[i]
      break
    end
  end
  self.crackRaidFirstPveData = maxLvEntranceData or self.catalogAll_crack[1]
  local catalogs = self.crackRaidFirstPveData.staticEntranceData.staticData.Catalog
  for i = 1, #catalogs do
    local catalogData = self.catalogMap_crack[catalogs[i]]
    catalogData = catalogData or {}
    catalogData[#catalogData + 1] = self.crackRaidFirstPveData
    self.catalogMap_crack[catalogs[i]] = catalogData
  end
end

function PveEntranceProxy:PreprocessHeroRoadEntrance()
  _TableClear(self.catalogMap_RoadOfHero)
  local maxLvEntranceData = self.catalogAll_RoadOfHero[1]
  self.heroRoadFirstPveData = maxLvEntranceData or self.catalogAll_RoadOfHero[1]
  if self.heroRoadFirstPveData then
    local catalogs = self.heroRoadFirstPveData.staticEntranceData.staticData.Catalog
    for i = 1, #catalogs do
      local catalogData = self.catalogMap_RoadOfHero[catalogs[i]]
      catalogData = catalogData or {}
      catalogData[#catalogData + 1] = self.heroRoadFirstPveData
      self.catalogMap_RoadOfHero[catalogs[i]] = catalogData
    end
  end
end

function PveEntranceProxy:PreprocessAstralEntrance()
  _TableClear(self.catalogMap_Astral)
  self.astralFirstPveData = self.catalogAll_Astral[1]
  if self.astralFirstPveData then
    local catalogs = self.astralFirstPveData.staticEntranceData.staticData.Catalog
    for i = 1, #catalogs do
      local catalogData = self.catalogMap_Astral[catalogs[i]]
      catalogData = catalogData or {}
      catalogData[#catalogData + 1] = self.astralFirstPveData
      self.catalogMap_Astral[catalogs[i]] = catalogData
    end
  end
end

function PveEntranceProxy:PreprocessMemoryRaidEntrance()
  _TableClear(self.catalogMap_Memory)
  local maxLvEntranceData = self.catalogAll_Memory[1]
  self.memoryFirstPveData = maxLvEntranceData or self.catalogAll_Memory[1]
  if self.memoryFirstPveData then
    local catalogs = self.memoryFirstPveData.staticEntranceData.staticData.Catalog
    for i = 1, #catalogs do
      local catalogData = self.catalogMap_Memory[catalogs[i]]
      catalogData = catalogData or {}
      catalogData[#catalogData + 1] = self.memoryFirstPveData
      self.catalogMap_Memory[catalogs[i]] = catalogData
    end
  end
end

function PveEntranceProxy:_setCatalogMap(targetMap)
  for catalog, list in pairs(targetMap) do
    local catalogData = self.catalogMap[catalog]
    catalogData = catalogData or {}
    for i = 1, #list do
      catalogData[#catalogData + 1] = list[i]
    end
    self.catalogMap[catalog] = catalogData
  end
end

function PveEntranceProxy:SetCatalogMap()
  _TableClear(self.catalogMap)
  self:_setCatalogMap(self.catalogMap_raid)
  self:_setCatalogMap(self.catalogMap_crack)
  self:_setCatalogMap(self.catalogMap_boss)
  self:_setCatalogMap(self.catalogMap_RoadOfHero)
  self:_setCatalogMap(self.catalogMap_Astral)
  self:_setCatalogMap(self.catalogMap_Memory)
  self:_setCatalogMap(self.catalogMap_SpaceTimeIllusion)
end

function PveEntranceProxy:SetCatalogAll()
  _ArrayClear(self.catalogAll)
  for i = 1, #self.catalogAll_raid do
    _ArrayPushBack(self.catalogAll, self.catalogAll_raid[i])
  end
  _ArrayPushBack(self.catalogAll, self.crackRaidFirstPveData)
  _ArrayPushBack(self.catalogAll, self.bossFirstPveData)
  _ArrayPushBack(self.catalogAll, self.heroRoadFirstPveData)
  _ArrayPushBack(self.catalogAll, self.astralFirstPveData)
  _ArrayPushBack(self.catalogAll, self.memoryFirstPveData)
  _ArrayPushBack(self.catalogAll, self.spaceTimeIllusionFirstPveData)
end

function PveEntranceProxy:GetCatalogAll()
  return self.catalogAll
end

function PveEntranceProxy:HasServerLastBossEntranceInfo()
  return nil ~= self.lastBossEntranceId and self.lastBossEntranceId > 0
end

function PveEntranceProxy:PreprocessSpaceTimeIllusionEntrance()
  self.spaceTimeIllusionFirstPveData = nil
  _TableClear(self.catalogMap_SpaceTimeIllusion)
  for i = #self.catalogAll_SpaceTimeIllusion, 1, -1 do
    if self:IsOpen(self.catalogAll_SpaceTimeIllusion[i].id) then
      self.spaceTimeIllusionFirstPveData = self.catalogAll_SpaceTimeIllusion[i]
      break
    end
  end
  self.spaceTimeIllusionFirstPveData = self.spaceTimeIllusionFirstPveData or self.catalogAll_SpaceTimeIllusion[1]
  if not self.spaceTimeIllusionFirstPveData then
    return
  end
  local catalogs = self.spaceTimeIllusionFirstPveData.staticEntranceData.staticData.Catalog
  for i = 1, #catalogs do
    local catalogData = self.catalogMap_SpaceTimeIllusion[catalogs[i]]
    catalogData = catalogData or {}
    catalogData[#catalogData + 1] = self.spaceTimeIllusionFirstPveData
    self.catalogMap_SpaceTimeIllusion[catalogs[i]] = catalogData
  end
end

function PveEntranceProxy:PreprocessBossEntrance()
  self.bossFirstPveData = nil
  _TableClear(self.catalogMap_boss)
  if self:HasServerLastBossEntranceInfo() then
    for i = #self.catalogAll_boss, 1, -1 do
      if self.catalogAll_boss[i].id == self.lastBossEntranceId and not self.catalogAll_boss[i]:Forbidden() then
        self.bossFirstPveData = self.catalogAll_boss[i]
        break
      end
    end
    self.bossFirstPveData = self.bossFirstPveData or self.catalogAll_boss[1]
  else
    local maxLvEntranceData
    if #self.catalogAll_boss > 0 then
      if self.catalogAll_boss[1]:CheckActivityValid() then
        maxLvEntranceData = self.catalogAll_boss[1]
      else
        for i = #self.catalogAll_boss, 1, -1 do
          if self:IsOpen(self.catalogAll_boss[i].id) and not self.catalogAll_boss[i].no_show then
            maxLvEntranceData = self.catalogAll_boss[i]
            break
          end
        end
      end
    end
    self.bossFirstPveData = maxLvEntranceData or self.catalogAll_boss[1]
  end
  local catalogs = self.bossFirstPveData.staticEntranceData.staticData.Catalog
  for i = 1, #catalogs do
    local catalogData = self.catalogMap_boss[catalogs[i]]
    catalogData = catalogData or {}
    catalogData[#catalogData + 1] = self.bossFirstPveData
    self.catalogMap_boss[catalogs[i]] = catalogData
  end
end

function PveEntranceProxy:GetAllCrackPveData()
  return self.catalogAll_crack
end

function PveEntranceProxy:GetAllBossPveData()
  return self.catalogAll_boss
end

function PveEntranceProxy:GetAllRoadOfHeroData()
  return self.catalogAll_RoadOfHero
end

function PveEntranceProxy:GetAllAstralData()
  return self.catalogAll_Astral
end

function PveEntranceProxy:GetAllMemoryRaidData()
  return self.catalogAll_Memory
end

function PveEntranceProxy:StaticSortEntrance()
  table.sort(self.catalogAll_raid, _SortFunc)
  table.sort(self.catalogAll_crack, _SortFunc)
  table.sort(self.catalogAll_boss, _SortFunc)
  table.sort(self.catalogAll_SpaceTimeIllusion, _SortFunc)
  table.sort(self.catalogAll_RoadOfHero, _SortFunc)
  table.sort(self.catalogAll_Astral, _SortFunc)
  table.sort(self.catalogAll_Memory, _SortFunc)
end

function PveEntranceProxy:SortEntrance()
  table.sort(self.catalogAll, _SortFunc)
  for _, v in pairs(self.catalogMap) do
    table.sort(v, _SortFunc)
  end
end

function PveEntranceProxy:IsNewEntrancePveByRaidType(type)
  return nil ~= self.raidMap[type]
end

function PveEntranceProxy.IsNewEntrancePveById(id)
  return nil ~= id and nil ~= Table_PveRaidEntrance[id]
end

function PveEntranceProxy:GetCatalogData(c)
  return self.catalogMap[c]
end

function PveEntranceProxy:GetRaidData(groupid)
  return self.raidMap[groupid]
end

function PveEntranceProxy:GetDifficultyData(groupid, difficulty_type)
  local diffDatas = {}
  local diffMap = self:GetRaidData(groupid)
  if diffMap then
    for k, data in pairs(diffMap) do
      if not data:Forbidden() then
        if difficulty_type then
          if data.staticEntranceData.difficultyType == difficulty_type then
            diffDatas[#diffDatas + 1] = data
          end
        else
          diffDatas[#diffDatas + 1] = data
        end
      end
    end
  end
  table.sort(diffDatas, _SortByDifficulty)
  if #diffDatas < 7 then
    local _emptyDiff = PveEntranceProxy.EmptyDiff
    for i = 1, 7 - #diffDatas do
      diffDatas[#diffDatas + 1] = _emptyDiff
    end
  end
  return diffDatas
end

function PveEntranceProxy:GetCurMaxPickupLayer(gId, diffMode, cur_layer)
  local max = 0
  local _emptyDiff = PveEntranceProxy.EmptyDiff
  local diff = self:GetDifficultyData(gId, diffMode)
  for i = 1, #diff do
    if diff[i] ~= _emptyDiff and diff[i].IsPickup and diff[i]:IsPickup() and cur_layer > diff[i].staticEntranceData.difficultyIgoreType then
      max = math.max(max, diff[i].staticEntranceData.difficultyIgoreType)
    end
  end
  return max + 1
end

function PveEntranceProxy:GetRaidDifficultyData(type, difficulty)
  local map = self:GetRaidData(type)
  return map and map[difficulty]
end

function PveEntranceProxy:SetQuickBossMap(array)
  _TableClear(self.quickBossMap)
  if array then
    for i = 1, #array do
      self.quickBossMap[array[i]] = 1
    end
  end
end

function PveEntranceProxy:CheckBossCanQuick(bossid)
  return nil ~= self.quickBossMap[bossid]
end

function PveEntranceProxy:RecvSyncPvePassInfoFubenCmd(server_data, battletime, lastBossInfo, quickBoss, endlessrewardlayer, all_crack_non_first)
  self:TryInitStatic()
  self:SetQuickBossMap(quickBoss)
  if not server_data and not battletime then
    return
  end
  self:SetLastBossInfo(lastBossInfo)
  self.battletime = battletime
  local raidType
  for i = 1, #server_data do
    local data = self:UpdatePassInfo(server_data[i])
    if data and data:Forbidden() then
      raidType = data.staticEntranceData.raidType
      if nil == self.dirtyRaidForbiddenMap[raidType] then
        self.dirtyRaidForbiddenMap[raidType] = 1
      end
    end
  end
  self:HandleCombinePveData()
  self.endlessrewardlayer = endlessrewardlayer
  self.all_crack_non_first = all_crack_non_first
  GameFacade.Instance:sendNotification(PVEEvent.SyncPvePassInfo)
end

function PveEntranceProxy:GetEndlessRewardLayer()
  return self.endlessrewardlayer
end

function PveEntranceProxy:HandleCombinePveData()
  self:TryResetCatalogAll()
  self:PreprocessCrackEntrance()
  self:PreprocessBossEntrance()
  self:PreprocessSpaceTimeIllusionEntrance()
  self:PreprocessHeroRoadEntrance()
  self:PreprocessAstralEntrance()
  self:PreprocessMemoryRaidEntrance()
  self:SetCatalogAll()
  self:SetCatalogMap()
  self:SortEntrance()
end

function PveEntranceProxy:SetLastBossInfo(serverLastBossInfo)
  if not (serverLastBossInfo and serverLastBossInfo.id) or serverLastBossInfo.id == 0 then
    return
  end
  self.lastBossEntranceId = serverLastBossInfo.id
  self.lastBossId = serverLastBossInfo.bossid
end

function PveEntranceProxy:HandleTeamLeaderPveCardOpenState(server_passinfos)
  if not server_passinfos then
    return
  end
  for i = 1, #server_passinfos do
    self.teamLeaderOpenMap[server_passinfos[i].id] = server_passinfos[i].open
  end
end

function PveEntranceProxy:CheckTeamLeaderOpenState(id)
  return self.teamLeaderOpenMap[id]
end

function PveEntranceProxy:UpdatePassInfo(data)
  local staticData = Table_PveRaidEntrance[data.id]
  if staticData then
    local diff = staticData.DifficultyName[2]
    local cacheData = self.raidMap[staticData.GroupId][diff]
    local oldForbidden = cacheData:Forbidden()
    cacheData:SetServerData(data)
    if oldForbidden ~= cacheData:Forbidden() and nil == self.dirtyRaidForbiddenMap[staticData.RaidType] then
      self.dirtyRaidForbiddenMap[staticData.RaidType] = 1
    end
    self.passInfoMap[data.id] = cacheData
    FunctionPve.Debug("Pve副本入口 SyncPvePassInfo 服务器同步 id| firstpass | passtime | open :  ", data.id, data.firstpass, data.passtime, data.open)
    return cacheData
  else
  end
end

function PveEntranceProxy:IsOpen(id)
  local _teamMgr = TeamProxy.Instance
  if _teamMgr:IHaveTeam() and _teamMgr:CheckIHaveLeaderAuthority() then
    local leaderOpenState = self:CheckTeamLeaderOpenState(id)
    if nil ~= leaderOpenState then
      return leaderOpenState
    end
  end
  local passInfo = self:GetPassInfo(id)
  if nil ~= passInfo then
    return passInfo.open
  end
  return false
end

function PveEntranceProxy:IsPickup(id)
  local passInfo = self:GetPassInfo(id)
  if nil ~= passInfo then
    return passInfo:IsPickup()
  end
  return false
end

function PveEntranceProxy:GetPassInfo(id)
  return self.passInfoMap[id]
end

function PveEntranceProxy:GetMatchRaidIdByBossId(id)
  local matchid = self.bossId2MatchIdMap[id]
  if not matchid then
    for _, passInfo in pairs(self.passInfoMap) do
      if passInfo.isBoss and passInfo:HasBossInfo(id) then
        matchid = passInfo:GetMatchRaidId()
        self.bossId2MatchIdMap[id] = matchid
        break
      end
    end
  end
  return matchid
end

function PveEntranceProxy:GetPassTime(id)
  local info = self:GetPassInfo(id)
  return info and info:GetPassTime() or 0
end

function PveEntranceProxy:GetCrackPassTime()
  return self.all_crack_non_first or 0
end

function PveEntranceProxy:OpenViewByBossId(entrance_id, boss_id)
  local info = self:GetPassInfo(entrance_id)
  if not info then
    self:OpenTargetPve(PveRaidType.Boss)
    return
  end
  local diff = info:GetDifficultyByBossId(boss_id)
  if not diff then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveView,
      viewdata = {initialEntranceId = entrance_id}
    })
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {
      initialBossData = {
        entrance_id,
        diff,
        boss_id
      }
    }
  })
end

function PveEntranceProxy:OpenTargetPve(t, gid)
  if not t then
    return
  end
  gid = gid or RaidType2GroupID[t]
  local targetData = self.targetMap[gid]
  if not targetData then
    targetData = self.raidMap[gid]
    if not next(targetData) then
      redlog("检查配置表 Table_PveRaidEntrance . RaidType: ", t)
      return
    end
    self.targetMap[gid] = targetData
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {
      targetData = {
        targetData[1]
      }
    }
  })
end

function PveEntranceProxy:OpenMultiTargetPve(t, gid)
  if not t then
    return
  end
  local resultList = {}
  for i = 1, #t do
    gid = gid or RaidType2GroupID[t[i]]
    local targetData = self.targetMap[gid]
    if not targetData then
      targetData = self.raidMap[gid]
      if not next(targetData) then
        redlog("检查配置表 Table_PveRaidEntrance . RaidType: ", t[i])
        return
      end
      self.targetMap[gid] = targetData
    end
    table.insert(resultList, targetData[1])
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {targetData = resultList}
  })
end

function PveEntranceProxy:OpenMultiTargetPveByGroupID(gids)
  if not gids then
    return
  end
  local resultList = {}
  local crackList = {}
  local single_group = #gids == 1
  for i = 1, #gids do
    local targetData = self.targetMap[gids[i]]
    if targetData == nil then
      targetData = self.raidMap[gids[i]]
      if not targetData or not next(targetData) then
        redlog("检查配置表 Table_PveRaidEntrance . 缺少groupid: ", gids[i])
        return
      end
      self.targetMap[gids[i]] = targetData
    end
    if targetData[1].staticEntranceData:IsCrack() then
      crackList[#crackList + 1] = targetData[1]
    else
      resultList[#resultList + 1] = targetData[1]
    end
  end
  table.sort(crackList, _SortFunc)
  self.targetMaxLvEntranceData = nil
  for i = #crackList, 1, -1 do
    if single_group or self:IsOpen(crackList[i].id) then
      self.targetMaxLvEntranceData = crackList[i]
      break
    end
  end
  if self.targetMaxLvEntranceData then
    table.insert(resultList, 1, self.targetMaxLvEntranceData)
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {targetData = resultList}
  })
end

function PveEntranceProxy:GetCurCrackRaidFirstEnternceData()
  return self.targetMaxLvEntranceData or self.crackRaidFirstPveData
end

function PveEntranceProxy:GetCurBossFirstPveData()
  return self.bossFirstPveData
end

function PveEntranceProxy:GetCurAstralFirstPveData()
  return self.astralFirstPveData
end

function PveEntranceProxy:GetCurMemoryFirstPveData()
  return self.memoryFirstPveData
end

function PveEntranceProxy:HandleSyncPveRaidAchieveFubenCmd(server_data)
  if not server_data then
    return
  end
  for i = 1, #server_data do
    self:UpdateAchieveInfo(server_data[i])
  end
  GameFacade.Instance:sendNotification(PVEEvent.SyncPvePassInfo)
end

function PveEntranceProxy:HandleSyncQuickPassItemInfoMessCCmd(data)
  FunctionPve.Debug("[背包道具扫荡副本] 后端同步背包道具扫荡副本信息")
  TableUtil.Print(data)
  local item_guid = data.guid
  if StringUtil.IsEmpty(item_guid) then
    return
  end
  local type = data.type
  if type and 0 < type then
    local status = data.status
    if status == MessCCmd_pb.QUICK_PASS_STATUS_LOCK then
      MsgManager.ShowMsgByID(43600)
      return
    end
    local confirmFunc = function()
      local item_data = BagProxy.Instance:GetItemByGuid(item_guid)
      if not item_data then
        return
      end
      ServiceItemProxy.Instance:CallItemUse(item_data, nil, 1)
    end
    if status == MessCCmd_pb.QUICK_PASS_STATUS_FULL then
      MsgManager.ConfirmMsgByID(43599, confirmFunc)
      return
    end
    local msg_id = quick_pass_msg[type]
    if not msg_id then
      return
    end
    local prefix, suffix
    local roguelike_pass = data.roguelikepass
    if type == MessCCmd_pb.QUICK_PASS_ITEM_ROGUELIKE and roguelike_pass and 0 < roguelike_pass then
      prefix = roguelike_pass - 9
      suffix = roguelike_pass
    end
    MsgManager.ConfirmMsgByID(msg_id, confirmFunc, nil, nil, tostring(prefix), tostring(suffix))
  end
end

function PveEntranceProxy:UpdateAchieveInfo(data)
  if not self.achieveMap then
    self.achieveMap = {}
  end
  local p = self.achieveMap[data.groupid]
  p = p or {}
  local achID
  for i = 1, #data.achieveids do
    local single = data.achieveids[i]
    achID = single.achieveid
    if achID then
      p[achID] = data.achieveids[i].pick
    end
  end
  self.achieveMap[data.groupid] = p
end

function PveEntranceProxy:CheckDone(groupid, index)
  if not self.achieveMap or not self.achieveMap[groupid] then
    return nil
  end
  return self.achieveMap[groupid][index]
end

function PveEntranceProxy:GetGroupAchieve(groupid)
  if not (self.achieveMap and self.achieveMap[groupid]) or not self.achieveMap[groupid] then
    return 0
  end
  local count = 0
  for key, value in pairs(self.achieveMap[groupid]) do
    if value then
      count = count + 1
    end
  end
  return count
end

local BattleTimeStringColor = {
  [1] = "[000000]%d[-])",
  [2] = "[E4593D]%d[-]"
}

function PveEntranceProxy:GetBattleTimelen(cost, strFormat)
  local color = 1
  if (self.battletime or 0) < cost * 60 then
    color = 2
  end
  return string.format(strFormat, string.format(BattleTimeStringColor[color], cost)), color
end

function PveEntranceProxy:HandlePveCardTimes(data)
  self.pveCard_addTimes = data.addtimes
  self.pveCard_battleTime = data.battletime
  self.pveCard_totalBattleTime = data.totalbattletime
  self.pvecardTimeInited = true
end

function PveEntranceProxy:GetPveCardAddTimes()
  return self.pveCard_addTimes or 0
end

function PveEntranceProxy:HandlePveCardRewardTime(items)
  if not items then
    return
  end
  for i = 1, #items do
    self.pvecardRewardTime[items[i].diff] = {
      times = items[i].times,
      firstpass = items[i].firstpass
    }
  end
end

function PveEntranceProxy:GetPveCardRewardTime(diff)
  local rewardTimeData = self.pvecardRewardTime[diff]
  if not rewardTimeData then
    return 0, false
  else
    return rewardTimeData.times, rewardTimeData.firstpass
  end
end

function PveEntranceProxy:CanAddPveCardTime(show_msg)
  if not self.pvecardTimeInited then
    return
  end
  local config = GameConfig.AddPveCardTimes
  if not config then
    FunctionPve.Debug("未配置GameConfig.AddPveCardTimes")
    return false
  end
  local unit_price = config.BattleTime
  if not unit_price then
    FunctionPve.Debug("未配置GameConfig.AddPveCardTimes.BattleTime")
    return false
  end
  if unit_price > self.pveCard_battleTime then
    if show_msg then
      MsgManager.ShowMsgByID(43144)
    end
    return false
  end
  local limitTimes = config.LimitTimes
  if "number" == type(limitTimes) and 0 < limitTimes then
    if limitTimes <= self.pveCard_addTimes then
      if show_msg then
        MsgManager.ShowMsgByID(43143)
      end
      return false
    end
  else
    self.pvecard_noLimited = true
  end
  return true
end

function PveEntranceProxy:HandleQueryRaidServerCombinedCmd(data)
  local combinedData = data.data
  if not combinedData then
    return
  end
  for i = 1, #combinedData do
    local tempData = {}
    TableUtility.TableShallowCopy(tempData, combinedData[i])
    xdlog("进度", tempData.raidid)
    self.raidCombinedMap[tempData.raidid] = tempData
  end
end

function PveEntranceProxy:GetRaidServerCombinedData(raidid)
  if not self.raidCombinedMap[raidid] then
    return nil
  end
  return self.raidCombinedMap[raidid]
end

function PveEntranceProxy:IsRaidCombined(raidid)
  local combinedInfo = self:GetRaidServerCombinedData(raidid)
  if not combinedInfo then
    return false
  end
  if combinedInfo.passnum >= combinedInfo.neednum and combinedInfo.opentick <= ServerTime.CurServerTime() / 1000 then
    return false
  end
end

function PveEntranceProxy:GetRaidCombinedStatus(raidid)
  local combinedInfo = self:GetRaidServerCombinedData(raidid)
  if not combinedInfo then
    return ServerMergeStatus.None
  end
  if combinedInfo.passnum >= combinedInfo.neednum then
    if not combinedInfo.opentick or combinedInfo.opentick == 0 then
      return ServerMergeStatus.Wait, combinedInfo
    elseif combinedInfo.opentick > ServerTime.CurServerTime() / 1000 then
      return ServerMergeStatus.CountDown, combinedInfo
    elseif combinedInfo.opentick <= ServerTime.CurServerTime() / 1000 then
      return ServerMergeStatus.Open, combinedInfo
    end
  else
    return ServerMergeStatus.InProcess, combinedInfo
  end
end

function PveEntranceProxy:IsOpenByTeamGoal(teamgoal)
  local id = self.goalMap and self.goalMap[teamgoal]
  return self:IsOpen(id)
end

function PveEntranceProxy:HandleTowerLaunchCmd()
  GameFacade.Instance:sendNotification(PVEEvent.EndlessLaunchSuccess)
end

local _RewardMultiples
local RewardMultiples = function(t)
  if not _RewardMultiples then
    _RewardMultiples = {}
    _RewardMultiples[PveRaidType.PveCard] = GameConfig.NewPveRaid and GameConfig.NewPveRaid.MultiTimes
  end
  return _RewardMultiples[t]
end

function PveEntranceProxy:InitMultiRewardCondition()
  self.multi_reward_condition = {}
  self.multi_reward_condition[PveRaidType.PveCard] = self.MultiRewardCheckCondition_PveCard
end

function PveEntranceProxy:MultiRewardCheckCondition_PveCard(id, multiples)
  return multiples > self:GetPassTime(id)
end

function PveEntranceProxy:TryGetRewardMultiply(id, onlyCalcActivity)
  local result = 1
  local type = Table_PveRaidEntrance[id].RaidType
  if not onlyCalcActivity then
    local condition = self.multi_reward_condition[type]
    local multiples = RewardMultiples(type)
    if condition and multiples and condition(self, id, multiples) then
      result = multiples
    end
  end
  local rewardMode = RaidType2AERewardMode[type]
  if rewardMode then
    local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(rewardMode)
    if rewardInfo then
      local multiply = rewardInfo:GetMultiple() or 1
      if 1 < multiply then
        result = result * multiply
      end
    end
  end
  if 1 < result then
    return result
  else
    return nil
  end
end

function PveEntranceProxy:CanResetRaidFuben(entranceid)
  local passinfo = self:GetPassInfo(entranceid)
  local staticData = Table_PveRaidEntrance[entranceid]
  return (passinfo.reset_time or 0) < (staticData.MaxResetTime or 0)
end

function PveEntranceProxy.IsSingleRaid(raidType)
  if raidType == PveRaidType.RoadOfHero then
    return true
  end
end
