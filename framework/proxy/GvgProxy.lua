autoImport("GvgDefenseData")
autoImport("GvgSettleInfo")
autoImport("GVGPointInfoData")
autoImport("GVGGroupZone4Server")
autoImport("GVGGroupZone")
autoImport("NewGvgRankData")
autoImport("GuildInfoForQuery")
autoImport("GvgSandTableData")
autoImport("GVGCookingHelper")
autoImport("MiniMapGvgStrongHoldData")
autoImport("GvgStatueInfo")
autoImport("GvGCityShowData")
local _fubenCmd = FuBenCmd_pb
local _queueEnterCmd = QueueEnterCmd_pb
local _debugSeasonDesc = {
  [0] = "预备赛阶段",
  [1] = "正赛阶段",
  [2] = "休闲赛阶段",
  [3] = "中断阶段"
}
local _debugQueueTypeDesc = {
  [1] = "攻方",
  [2] = "守方"
}
local EGvgState = {
  None = _fubenCmd.EGVGRAIDSTATE_MIN,
  Peace = _fubenCmd.EGVGRAIDSTATE_PEACE,
  Fire = _fubenCmd.EGVGRAIDSTATE_FIRE,
  Calm = _fubenCmd.EGVGRAIDSTATE_CALM,
  PerfectDefense = _fubenCmd.EGVGRAIDSTATE_PERFECT
}
local EQueueEnter = {
  NONE = _queueEnterCmd.EQUEUEENTERTYPE_MIN,
  GVG_ATT = _queueEnterCmd.EQUEUEENTERTYPE_GVG_ATT,
  GVG_DEF = _queueEnterCmd.EQUEUEENTERTYPE_GVG_DEF
}
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _ArrayFindIndex = TableUtility.ArrayFindIndex
local _ArrayPushBack = TableUtility.ArrayPushBack
local _InsertArray = TableUtil.InsertArray
local _TableClearByDeleter = TableUtility.TableClearByDeleter
local _TimeDate_format = "%Y-%m-%d %H:%M:%S"
local _DateTime = function(time_stamp)
  return os.date(_TimeDate_format, time_stamp)
end
local _queryInterval = 60
local _debugStateDesc = {
  [0] = "未定义",
  [1] = "战斗尚未开启",
  [2] = "战斗中",
  [3] = "冷静期",
  [4] = "完美防守成功"
}
local _playerSitAction = "sit_down2"
local _GvGCityShowData_cache_dirty = {}
GvgProxy = class("GvgProxy", pm.Proxy)
GvgProxy.Instance = nil
GvgProxy.NAME = "GvgProxy"
GvgProxy.LobbyFlagID = 9
GvgProxy.LobbyFlagNPCID = 842245
GvgProxy.ESeasonType = {
  Battle = 1,
  Leisure = 2,
  Break = 3
}
GvgProxy.EpointState = {
  None = _fubenCmd.EGVGPOINT_STATE_MIN,
  Occupied = _fubenCmd.EGVGPOINT_STATE_OCCUPIED
}
GvgProxy.EMvpState = {
  None = 0,
  Will_Summon = 1,
  Summoned = 2,
  Die = 3
}
GvgProxy.MaxQuestRound = 3
GvgProxy.GvgQuestMap = {
  [_fubenCmd.EGVGDATA_PARTINTIME] = "partin_time",
  [_fubenCmd.EGVGDATA_RELIVE] = "relive_other",
  [_fubenCmd.EGVGDATA_EXPEL] = "expel_enemy",
  [_fubenCmd.EGVGDATA_DAMMETAL] = "dam_metal",
  [_fubenCmd.EGVGDATA_KILLMETAL] = "kill_metal",
  [_fubenCmd.EGVGDATA_KILLUSER] = "kill_one_user",
  [_fubenCmd.EGVGDATA_HONOR] = "get_honor",
  [_fubenCmd.EGVGDATA_OCCUPY_POINT] = "occupy_point",
  [_fubenCmd.EGVGDATA_DEF_POINT_TIME] = "def_point_time",
  [_fubenCmd.EGVGDATA_PARTIN_KILLMETAL] = "partin_kill_metal",
  [_fubenCmd.EGVGDATA_DAM_MVP] = "dam_mvp"
}
GvgProxy.GvgQuestListp = {
  _fubenCmd.EGVGDATA_HONOR,
  _fubenCmd.EGVGDATA_KILLUSER,
  _fubenCmd.EGVGDATA_PARTINTIME,
  _fubenCmd.EGVGDATA_RELIVE,
  _fubenCmd.EGVGDATA_EXPEL,
  _fubenCmd.EGVGDATA_DAMMETAL,
  _fubenCmd.EGVGDATA_KILLMETAL,
  _fubenCmd.EGVGDATA_PARTIN_KILLMETAL,
  _fubenCmd.EGVGDATA_OCCUPY_POINT,
  _fubenCmd.EGVGDATA_DEF_POINT_TIME,
  _fubenCmd.EGVGDATA_DAM_MVP
}

function GvgProxy.GVGBuildingUniqueID(npcid, lv)
  return npcid * 10000 + lv
end

GvgProxy.MetalID = 40021
GvgProxy.MaxMorale = GameConfig.GVGConfig and GameConfig.GVGConfig.max_morale or 100

function GvgProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GvgProxy.NAME
  if GvgProxy.Instance == nil then
    GvgProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

GvgProxy.newGVGDebug = false

function GvgProxy:Debug(...)
  if GvgProxy.newGVGDebug then
    helplog(...)
  end
end

function GvgProxy.Print(msg)
  if GvgProxy.newGVGDebug then
    TableUtil.Print(msg)
  end
end

function GvgProxy.ClientGroupId(id)
  return GvgProxy.Instance.server_group2client[id] or 0
end

function GvgProxy:GetServerGroupId(client_id)
  if not self.serverGroupId then
    self.serverGroupId = {}
    for s, c in pairs(self.server_group2client) do
      self.serverGroupId[c] = s
    end
  end
  return self.serverGroupId[client_id] or 0
end

function GvgProxy.GetServerIdByGroupId(gId)
  return gId // 10000
end

function GvgProxy:InitProxy()
  self.cityStatueMap = {}
  self.ruleGuild_Map = {}
  self.questInfoData = {}
  self.GvgSandTableInfo = {}
  self:InitCityShow()
  self:InitNewGVG()
  self.mvp_id = nil
  self.diffServerIdMap = {}
end

function GvgProxy:InitCityShow()
  self.cityShowDataMap = {}
  self.groupCityShowList = {}
  self._cityShowDataCacheDirty = {}
end

function GvgProxy.SetDungeonCalmDown(calm)
  local currentDungeon = Game.DungeonManager.currentDungeon
  if currentDungeon ~= nil and currentDungeon.SetCalmDown ~= nil then
    currentDungeon:SetCalmDown(calm)
  end
end

function GvgProxy:OnEnterPeaceState()
  GvgProxy.SetDungeonCalmDown(true)
end

function GvgProxy:OnEnterFireState()
  GvgProxy.SetDungeonCalmDown(false)
end

function GvgProxy:OnEnterCalmState()
  GvgProxy.SetDungeonCalmDown(true)
  GameFacade.Instance:sendNotification(GVGEvent.GVG_Calm)
end

function GvgProxy.OnEnterPerfect()
  GvgProxy.SetDungeonCalmDown(true)
end

function GvgProxy:InitNewGVG()
  GvgProxy.RaidStatusDirtyCall = {
    [EGvgState.Peace] = GvgProxy.OnEnterPeaceState,
    [EGvgState.Fire] = GvgProxy.OnEnterFireState,
    [EGvgState.Calm] = GvgProxy.OnEnterCalmState,
    [EGvgState.PerfectDefense] = GvgProxy.OnEnterPerfect
  }
  self.server_group2client = {}
  self.server_groupZoneList = {}
  self.groupZoneList = {}
  self.pointInfoMap = {}
  self.myGuildPoints = {}
  self.curOccupingPointID = nil
  self.gvgRaidState = EGvgState.None
  self:ResetQueue()
  self.guildSmallMetalCnt = {}
  self.currentSeaonRankList = {}
  self.queryGuildInfo = GuildInfoForQuery.new()
  self:InitPointScore()
  self.groupCnt = 0
  self.lobbyFlagData = {}
end

function GvgProxy:InitPointScore()
  self.losePointMap = {}
  self.pointScoreMap = {}
  self.maxPointScore = 0
end

function GvgProxy:IsScorePoint(p)
  return false
end

function GvgProxy:HandleQueryGuildInfo(server_data)
  if not server_data then
    return
  end
  self.queryGuildInfo:Reset(server_data)
end

function GvgProxy:GetQueryGuildInfo()
  return self.queryGuildInfo
end

function GvgProxy:SetCurrentPointID(id)
  local myself = Game.Myself
  if myself and myself.data and not myself.data:InGvgZone() and not self.showDiffGvgZoneMsg then
    self.showDiffGvgZoneMsg = true
    MsgManager.ShowMsgByID(2224)
  end
  local pointData = self.pointInfoMap[id]
  if pointData then
    self.curOccupingPointID = id
    self:Debug("NewGVG 更新当前争夺的据点ID： ", id)
    GameFacade.Instance:sendNotification(GVGEvent.GVG_UpdatePointPercentTip)
  else
    self:RemoveCurrentPointID()
  end
  self:_UpdateHoldMetalNpc(id)
end

function GvgProxy:RemoveCurrentPointID()
  self:Debug("NewGVG 删除当前争夺的据点ID: ", self.curOccupingPointID)
  self.curOccupingPointID = -1
  GameFacade.Instance:sendNotification(GVGEvent.GVG_RemovePointPercentTip)
end

function GvgProxy:GetCurOccupingPointID()
  return self.curOccupingPointID or -1
end

function GvgProxy:DoQueryGvgZoneGroup(force_query)
  if force_query or nil == self.queryGroupZoneTime or UnityRealtimeSinceStartup - self.queryGroupZoneTime > _queryInterval then
    self.queryGroupZoneTime = UnityRealtimeSinceStartup
    ServiceGuildCmdProxy.Instance:CallQueryGvgZoneGroupGuildCCmd()
    self:Debug("NewGVG 客户端请求公会战线分组")
  end
end

function GvgProxy:SeasonDirtyCall()
  self.queryGroupZoneTime = nil
  self:ClearGroupZoneData()
  self:ClearCurPerfectDefenseState()
  self:ClearRank()
  self.scoreInfo = nil
  _TableClear(self.losePointMap)
  _TableClear(self.lobbyFlagData)
end

function GvgProxy:GetBattleWeeklyCount()
  if not self.battle_weekly_count then
    self.battle_weekly_count = 0
    local startTimeConfig = GameConfig.GVGConfig.start_time
    for i = 1, #startTimeConfig do
      if not startTimeConfig[i].super then
        self.battle_weekly_count = self.battle_weekly_count + 1
      end
    end
  end
  return self.battle_weekly_count
end

function GvgProxy:GetWeekBattleCount()
  if not self.weekBattleCnt then
    self.weekBattleCnt = GameConfig.GVGConfig.season_week_count
  end
  return self.weekBattleCnt
end

function GvgProxy:ClearGroupZoneData()
  _ArrayClear(self.server_groupZoneList)
  _ArrayClear(self.groupZoneList)
  _TableClear(self.server_group2client)
  self.groupCnt = 0
end

function GvgProxy:RecvQueryGvgZoneGroupGuildCCmd(data)
  self:Debug("NewGVG 服务器初始化赛季信息")
  GvgProxy.Print(data)
  if self.season and self.season ~= data.season then
    self:SeasonDirtyCall()
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  self.season = data.season
  self:Debug("NewGVG 当前赛季 ：  ", data.season)
  self.begintime = data.begintime or 0
  self.battleCount = data.count or 0
  self.break_begintime = data.break_begintime or 0
  self.break_endtime = data.break_endtime or 0
  self.next_season_begintime = data.next_begintime or 0
  if curServerTime >= self.break_begintime and curServerTime <= self.break_endtime then
    self.seasonStatus = GvgProxy.ESeasonType.Break
  else
    local battle_count = GameConfig.GVGConfig.season_week_count
    local battle_week = math.floor(battle_count / self:GetBattleWeeklyCount())
    if battle_week < self.battleCount or self.season == 0 then
      self.seasonStatus = GvgProxy.ESeasonType.Leisure
      self:Debug("[NewGVG休闲模式] server_battleCount|周场次|season : ", self.battleCount, battle_week, self.season)
    else
      self.seasonStatus = GvgProxy.ESeasonType.Battle
    end
  end
  self:_debugSeasonTime()
  self:ClearGroupZoneData()
  local infos = data.infos
  if not infos or #infos == 0 then
    self:Debug("NewGVG 后端未推送战线分组信息")
    return
  end
  self:Debug("NewGVG 后端推送战线分组信息 infoCount ", #infos)
  GvgProxy.Print(infos)
  for i = 1, #infos do
    local server_group_zone = GVGGroupZone4Server.new(infos[i].groupid, infos[i].zoneids)
    _ArrayPushBack(self.server_groupZoneList, server_group_zone)
  end
  table.sort(self.server_groupZoneList, function(a, b)
    return a.groupid < b.groupid
  end)
  local server_groups_beenSort = self.server_groupZoneList
  self.groupCnt = #server_groups_beenSort
  self:Debug("NewGVG 公会线分组数: ", self.groupCnt)
  for i = 1, #server_groups_beenSort do
    local groupid = server_groups_beenSort[i].groupid
    self:Debug("NewGVG 战线分组id: ", groupid)
    local zoneids = server_groups_beenSort[i].zoneids
    self.groupZoneList[#self.groupZoneList + 1] = GVGGroupZone.new(groupid, zoneids, i)
    self.server_group2client[groupid] = i
  end
  table.sort(self.groupZoneList, function(a, b)
    return a.groupid < b.groupid
  end)
  ServiceSceneUser3Proxy.Instance:CallGvgExcellectQueryUserCmd()
end

function GvgProxy:CheckCurMapIsInGuildUnionGroup()
  if GuildDateBattleProxy.Instance:IsOpen() then
    return true
  end
  local curMapGroupId = self:GetCurMapGvgGroupID()
  local myGuildUnionGvgGroupId = self:GetMyGuildGvgGroup()
  return 0 < curMapGroupId and curMapGroupId == myGuildUnionGvgGroupId
end

function GvgProxy.GetStrongHoldStaticData(city_id)
  return Table_Guild_StrongHold[city_id] or Table_DateBattleCity[city_id]
end

function GvgProxy.GetCurMapCityConfig(city_id)
  if Game.MapManager:IsGVG_Date() then
    return Table_DateBattleCity[city_id]
  elseif Game.MapManager:IsInGVG() then
    return Table_Guild_StrongHold[city_id]
  end
  return GvgProxy.GetStrongHoldStaticData(city_id)
end

function GvgProxy:GetMyGuildGvgGroup()
  if Game.MapManager:IsGVG_Date() then
    return GuildProxy.Instance:GetMyGuildGvgGroup()
  else
    return GuildProxy.Instance:GetMyGuildUnionGvgGroupID()
  end
end

function GvgProxy:GetCurMapGvgGroupDesc()
  local result = ""
  local groupId = self:GetCurMapGvgGroupID()
  if groupId and 0 < groupId then
    result = string.format(ZhString.NewGVG_GroupID, GvgProxy.ClientGroupId(groupId))
  end
  return result
end

function GvgProxy:_debugSeasonTime()
  self:Debug("NewGVG 开赛次数 ：  ", self.battleCount)
  if self.begintime > 0 then
    self:Debug("NewGVG 赛季开始时间 ：  ", _DateTime(self.begintime))
  end
  if 0 < self.break_begintime then
    self:Debug("NewGVG 赛季中断开始时间 ：  ", _DateTime(self.break_begintime))
  end
  if 0 < self.break_endtime then
    self:Debug("NewGVG 赛季中断结束时间 ：  ", _DateTime(self.break_endtime))
  end
  if 0 < self.next_season_begintime then
    self:Debug("NewGVG 下赛季开始时间 ：  ", _DateTime(self.next_season_begintime))
  end
  self:Debug("NewGVG 赛季阶段： ", _debugSeasonDesc[self.seasonStatus])
end

function GvgProxy:GetSeasonStatus()
  return self.seasonStatus
end

function GvgProxy:IsBattleSeason()
  return self.seasonStatus == GvgProxy.ESeasonType.Battle
end

function GvgProxy:IsBreakSeason()
  return self.seasonStatus == GvgProxy.ESeasonType.Break
end

function GvgProxy:IsLeisureSeason()
  return self.seasonStatus == GvgProxy.ESeasonType.Leisure
end

function GvgProxy:NowSeason()
  return self.season or 0
end

function GvgProxy:NowBattleCount()
  return self.battleCount
end

function GvgProxy:GetGroupCnt()
  return self.groupCnt or 0
end

function GvgProxy:GetLeftWeek()
  local battle_count = GameConfig.GVGConfig.season_week_count
  local battle_week = math.floor(battle_count / self:GetBattleWeeklyCount())
  local battleCount = self.battleCount or 0
  local leftWeek = battle_week - battleCount
  if leftWeek < 0 then
    return 0
  else
    return leftWeek
  end
end

function GvgProxy:GetCurMapGvgGroupID()
  if Game.MapManager:IsInGVG() then
    return self.curMapGvgGroupId or -1
  end
  return -1
end

function GvgProxy:CheckIsCurMapGvgGroupID(groupid)
  return self:GetCurMapGvgGroupID() == groupid
end

function GvgProxy:GetGroupZoneList()
  return self.groupZoneList
end

function GvgProxy:HasMoreGroupZone()
  return self.groupCnt and self.groupCnt > 1
end

function GvgProxy:CheckGroupValid(groupid)
  if not self.groupZoneList then
    return false
  end
  for i = 1, #self.groupZoneList do
    local single = self.groupZoneList[i]
    if single.groupid == groupid then
      return true
    end
  end
  return false
end

local _GLandfilterMap = {}

function GvgProxy:GetGLandGroupZoneFilter()
  _TableClear(_GLandfilterMap)
  local curMapGroupId = self:GetCurMapGvgGroupID()
  if 0 < curMapGroupId then
    _GLandfilterMap[curMapGroupId * 10] = ZhString.GLandStatusListView_Current
  end
  local mercenyGroupId = GuildProxy.Instance:GetMyMercenaryGvgGroup()
  if 0 < mercenyGroupId then
    _GLandfilterMap[mercenyGroupId * 100] = ZhString.GLandStatusListView_Merceny
  end
  local myGuildGvgGroup = GuildProxy.Instance:GetMyGuildGvgGroup()
  if 0 < myGuildGvgGroup then
    _GLandfilterMap[myGuildGvgGroup * 1000] = ZhString.GLandStatusListView_Guild
  end
  for i = 1, #self.groupZoneList do
    _GLandfilterMap[self.groupZoneList[i].server_groupid * 10000] = self.groupZoneList[i]:GetGroupIdStr()
  end
  return _GLandfilterMap
end

function GvgProxy:_RecvPoint(points, isInit)
  if not points or #points <= 0 then
    return
  end
  if isInit then
    self:ClearPoints()
    _ArrayClear(self.myGuildPoints)
  end
  local point
  for i = 1, #points do
    local serverPoint = points[i]
    point = self:GetPointData(serverPoint.pointid)
    if nil == point then
      point = self:_AddPoint(serverPoint)
    else
      point = self:_UpdatePoint(serverPoint)
    end
    if point:IsMyGuildPoint() then
      table.insert(self.myGuildPoints, point)
    end
  end
  self:UpdateGvgStrongHoldSymbolDatas()
  GameFacade.Instance:sendNotification(GVGEvent.GVG_PointUpdate)
  EventManager.Me():DispatchEvent(GVGEvent.GVG_PointUpdate)
end

function GvgProxy:GetCurMapPointScore()
  local score = 0
  for id, data in pairs(self.pointInfoMap) do
    if data:CheckScore() then
      score = score + 1
    end
  end
  return score
end

function GvgProxy:_AddPoint(point)
  local pointData = GVGPointInfoData.new(point)
  self.pointInfoMap[pointData.pointid] = pointData
  return pointData
end

function GvgProxy:_UpdatePoint(point)
  local pointData = self.pointInfoMap[point.pointid]
  pointData:Update(point)
  return pointData
end

function GvgProxy:IHaveGuildPoint()
  return nil ~= self.myGuildPoints and nil ~= next(self.myGuildPoints)
end

function GvgProxy:GetPointData(point_id)
  return self.pointInfoMap[point_id]
end

function GvgProxy:RecvGvgPointUpdateFubenCmd(data)
  self:Debug("NewGVG 服务器更新据点信息")
  GvgProxy.Print(data)
  self:_RecvPoint(data.info)
end

function GvgProxy:RecvGvgRaidStateUpdateFubenCmd(data)
  self:_UpdateRaidState(data.raidstate)
  self:_UpdateNextRaidState(data.perfect)
end

function GvgProxy:_UpdateRaidState(state)
  if not state then
    return
  end
  if state ~= self.gvgRaidState then
    self.gvgRaidState = state
    self:Debug("NewGVG 副本状态更新 state: ", _debugStateDesc[state])
    self:_RaidStatusChange(state)
  end
end

function GvgProxy:IsFireState()
  return self.gvgRaidState == EGvgState.Fire
end

function GvgProxy:IsCalmState()
  return self.gvgRaidState == EGvgState.Calm
end

function GvgProxy:IsPeaceState()
  return self.gvgRaidState == EGvgState.Peace
end

function GvgProxy:IsPerfectDefense()
  return self.gvgRaidState == EGvgState.PerfectDefense
end

function GvgProxy:_RaidStatusChange(state)
  local call = GvgProxy.RaidStatusDirtyCall[state]
  if call then
    call(self)
  end
end

function GvgProxy:ResetQueue()
  if not self.inQueue then
    return
  end
  self.inQueue = false
  self.queueType = EQueueEnter.NONE
  self.queueWaitNum = 0
  GameFacade.Instance:sendNotification(GVGEvent.GVG_QueueRemove)
end

function GvgProxy:GetQueueInfo()
  return self.inQueue, self.queueWaitNum, self.queueType
end

function GvgProxy:CancelQueue()
  if not self.queueType then
    return
  end
  ServiceQueueEnterCmdProxy.Instance:CallReqQueueEnterCmd(true, self.queueType)
end

function GvgProxy:RecvQueueUpdateCountCmd(data)
  if data.etype ~= self.queueType then
    redlog("服务器更新排队人数变化，排队类型与服务器类型不一致, 本地类型 | 服务器类型： ", self.queueType, data.etype)
    return
  end
  self:Debug("NewGVG  服务器更新排队队列。减少人数 | 总人数： ", data.dec_num, self.queueWaitNum - data.dec_num)
  self.queueWaitNum = self.queueWaitNum - data.dec_num
  GameFacade.Instance:sendNotification(GVGEvent.GVG_QueueUpdate)
end

function GvgProxy:RecvQueueEnterRetCmd(data)
  if data.stop then
    self:Debug("NewGVG  服务器通知取消排队")
    self:ResetQueue()
    return
  end
  self:Debug("NewGVG  服务器通知排队成功 排队类型 | 排队人数 : ", _debugQueueTypeDesc[data.etype], data.waitnum)
  self.queueType = data.etype
  self.inQueue = true
  self.queueWaitNum = data.waitnum
  GameFacade.Instance:sendNotification(GVGEvent.GVG_QueueAdd)
end

function GvgProxy:HandleNewGvgRankInfo(data)
  GvgProxy.Print(data)
  local page = data.page
  if not page or "number" ~= type(page) then
    return
  end
  local infos = data.infos
  if not infos then
    return
  end
  local ranklist_myGuildData
  for i = 1, #infos do
    local gvgRankData = NewGvgRankData.new(infos[i])
    _ArrayPushBack(self.currentSeaonRankList, gvgRankData)
    if gvgRankData.id == GuildProxy.Instance.guildId then
      ranklist_myGuildData = gvgRankData
    end
  end
  self:_TrySearchGuild()
  if data.selfinfo then
    self.myGuildGvgRankInfo = ranklist_myGuildData or NewGvgRankData.new(data.selfinfo)
  end
end

function GvgProxy:DoSearchGuildInRankList(keywords)
  self.rank_searchKeywords = keywords
  if not self:HasCurrentSeasonRank() then
    self:DoQueryGvgRank(0)
    TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
      if nil ~= self.rank_searchKeywords then
        self.rank_searchKeywords = nil
        GameFacade.Instance:sendNotification(GVGEvent.GVG_SearchGuildTimeOut)
      end
    end, self, 1)
    return
  end
  self:_TrySearchGuild()
end

local searchResult = {}
local guild_name

function GvgProxy:_TrySearchGuild()
  if not self.rank_searchKeywords then
    return
  end
  _ArrayClear(searchResult)
  for i = 1, #self.currentSeaonRankList do
    guild_name = self.currentSeaonRankList[i]:GetGuildName()
    if nil ~= string.match(guild_name, self.rank_searchKeywords) then
      searchResult[#searchResult + 1] = self.currentSeaonRankList[i]
    end
  end
  GameFacade.Instance:sendNotification(GVGEvent.GVG_SearchGuild, searchResult)
  self.rank_searchKeywords = nil
end

function GvgProxy:GetMyGuildRank()
  return self.myGuildGvgRankInfo
end

function GvgProxy:HasCurrentSeasonRank()
  return nil ~= next(self.currentSeaonRankList)
end

function GvgProxy:DoQueryGvgRank(page)
  if nil == self.queryRankTime or UnityRealtimeSinceStartup - self.queryRankTime > _queryInterval then
    self.queryRankTime = UnityRealtimeSinceStartup
    _ArrayClear(self.currentSeaonRankList)
    ServiceGuildCmdProxy.Instance:CallGvgRankInfoQueryGuildCmd(page, GuildProxy.Instance.guildId)
    self:Debug("NewGVG 客户端请求GVG排行榜")
  end
end

function GvgProxy:DoQueryHistoryGvgRank()
  if self:HasHistoryGvgRank() then
    return
  end
  ServiceGuildCmdProxy.Instance:CallGvgRankHistroyQueryGuildCmd()
end

function GvgProxy:HasHistoryGvgRank()
  return nil ~= self.historyRankMap
end

function GvgProxy:ClearRank()
  if self.historyRankMap then
    _TableClear(self.historyRankMap)
    self.historyRankMap = nil
  end
  if self.historyRankList then
    _ArrayClear(self.historyRankList)
    self.historyRankList = nil
  end
  _ArrayClear(self.currentSeaonRankList)
end

function GvgProxy:HandleQueryHistoryGvgRank(data)
  local server_data = data.history_infos
  if not server_data then
    return
  end
  self.historyRankMap = {}
  local _tempRankData
  for i = 1, #server_data do
    local season = server_data[i].season
    local seasonRanks = {}
    local championCnt = 0
    for j = 1, #server_data[i].infos do
      _tempRankData = NewGvgRankData.new(server_data[i].infos[j])
      if _tempRankData:IsTop3() then
        seasonRanks[#seasonRanks + 1] = _tempRankData
      end
      if _tempRankData:IsChampion() then
        championCnt = championCnt + 1
      end
    end
    self.historyRankMap[season] = {seasonRanks, championCnt}
  end
end

function GvgProxy:GetGvgCurrentSeasonRankData()
  return self.currentSeaonRankList or _EmptyTable
end

function GvgProxy:GetGvgHistoryRankData()
  if nil == self.historyRankList then
    self.historyRankList = {}
    if self.historyRankMap then
      for season, datas in pairs(self.historyRankMap) do
        local singleSeasonData = {
          rankData = datas[1],
          championCnt = datas[2],
          season = season
        }
        table.insert(self.historyRankList, singleSeasonData)
      end
    end
  end
  return self.historyRankList
end

function GvgProxy:HandleSmallMetalCnt(guildid, count)
  if not guildid then
    return
  end
  self:Debug("NewGVG 服务器同步小华丽水晶占领数量. guildid count : ", guildid, count)
  self.guildSmallMetalCnt[guildid] = count
  if GuildProxy.Instance:IsMyGuildUnion(guildid) then
    self:Debug("NewGVG 我方公会占领小华丽水晶 ： ", count)
    GameFacade.Instance:sendNotification(GVGEvent.GVG_SmallMetalCntUpdate, count)
  end
end

function GvgProxy:GetSmallMetalCnt(id)
  return self.guildSmallMetalCnt[id] or 0
end

function GvgProxy:GetGuildID()
  if Game.MapManager:IsGVG_DateBattle() then
    return GuildProxy.Instance:GetOwnGuildID()
  else
    return GuildProxy.Instance:GetGuildID()
  end
end

function GvgProxy:GetMyGuildSmallMetalCnt()
  local myguildId = self:GetGuildID()
  return myguildId and self.guildSmallMetalCnt[myguildId] or 0
end

function GvgProxy:CanIGetMoreStrongHoldReward()
  local maxCount = GameConfig.GVGConfig and GameConfig.GVGConfig.occupy_smallmetal_maxcount
  local myCount = self:GetMyGuildSmallMetalCnt()
  if myCount and maxCount and maxCount <= myCount then
    return false
  else
    return true
  end
end

function GvgProxy:_checkCrystalInvincible()
  if not self:GetGuildID() then
    return true
  end
  return self.sync_metal_invincible == true
end

function GvgProxy:_updateCrystalInvincibleState()
  local newState = self:_checkCrystalInvincible()
  if self.crystalInvincible == newState then
    return
  end
  self.crystalInvincible = newState
  GameFacade.Instance:sendNotification(GVGEvent.GVG_CrystalInvincible)
end

function GvgProxy:IsCrystalInvincible()
  return self.crystalInvincible == true
end

function GvgProxy:ClearPoints()
  _TableClearByDeleter(self.pointInfoMap, function(v)
    v:OnClear()
  end)
end

function GvgProxy:ClearFightInfo()
  self:ClearPoints()
  _TableClear(self.lobbyFlagData)
  self.curOccupingPointID = nil
  self.gvgRaidState = EGvgState.None
  self.showDiffGvgZoneMsg = nil
  self.isDefSide = nil
  self.expelTime = nil
  self.crystalInvincible = nil
  self.isPerfect = nil
  _ArrayClear(self.gvgStrongHoldDataArray)
  _TableClear(self.gvgStrongHoldDatas)
  self:ResetMvp()
  self:ClearRoadBlock()
  self.curStrongHoldStaticData = nil
  self.curRaidMode = nil
  self:NeedMoveToCity(nil, false)
end

function GvgProxy:ClearQuestInfo()
  _TableClear(self.questInfoData)
  self.cityType = nil
end

function GvgProxy:GetRuleGuildInfo(flagid, groupid)
  if groupid and self.cityShowDataMap[groupid] and self.cityShowDataMap[groupid][flagid] then
    return self.cityShowDataMap[groupid][flagid], 2
  end
  if self.ruleGuild_Map[flagid] then
    return self.ruleGuild_Map[flagid], 1
  end
end

function GvgProxy:UpdateLobbyMapCityGuild(data)
  self:UpdateCurMapGvgGroupId(data.groupid)
  if not data.infos then
    return
  end
  for i = 1, #data.infos do
    self:SetRuleGuildInfo(data.infos[i])
  end
end

function GvgProxy:SetRuleGuildInfo(cityShowInfo)
  if cityShowInfo == nil then
    return
  end
  _TableClear(self.lobbyFlagData)
  local info = self.ruleGuild_Map[cityShowInfo.cityid]
  if cityShowInfo.guildid == 0 then
    self.ruleGuild_Map[cityShowInfo.cityid] = nil
    return
  end
  if info == nil then
    info = {}
    self.ruleGuild_Map[cityShowInfo.cityid] = info
  end
  info.id = cityShowInfo.guildid
  info.flag = cityShowInfo.cityid
  info.lv = cityShowInfo.lv
  info.membercount = cityShowInfo.membercount
  info.name = cityShowInfo.name
  info.portrait = cityShowInfo.portrait
  if nil ~= cityShowInfo.roadblock then
    info.roadBlock = cityShowInfo.roadblock
  end
  if not Game.MapManager:IsInGVG_Lobby() then
    return
  end
  self.lobbyFlagData.portrait = info.portrait
  self.lobbyFlagData.guildid = info.id
  self:InitLobbyFlag()
end

function GvgProxy:TryResetLobbyFlag()
  if not Game.MapManager:IsInGVG_Lobby() then
    return
  end
  if not next(self.lobbyFlagData) then
    return
  end
  local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag]
  if not flagManager then
    return
  end
  local flagid = flagManager:GetLobbyFlagId()
  if flagid then
    FunctionGuild.Me():SetGuildLandIcon(flagid, self.lobbyFlagData.portrait, self.lobbyFlagData.guildid)
  end
end

function GvgProxy:InitLobbyFlag()
  local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.FlagID)
  if npcs == nil or #npcs == 0 then
    return
  end
  self:TryResetLobbyFlag()
end

local flag_map

function GvgProxy:QueryCityInfo(mapid)
  if not flag_map then
    flag_map = GameConfig.GvgNewConfig.flag_map
  end
  if not flag_map then
    return
  end
  mapid = mapid or Game.MapManager:GetMapID()
  if flag_map[mapid] or Game.MapManager:IsInGVG_Lobby() then
    local query_group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
    self:Debug("[Debug 旗帜] 请求主城占城信息 groupid ", query_group_id)
    ServiceGuildCmdProxy.Instance:CallQueryGCityShowInfoGuildCmd(nil, query_group_id)
  end
  local city_id = 0
  local lobby_static_data = Game.Config_GuildStrongHold_Lobby[mapid] or Game.Config_DateBattleCity_Lobby[mapid]
  if nil ~= lobby_static_data then
    city_id = lobby_static_data.id
  end
  local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
  if (mapid == GameConfig.System.maincity_map_id or 0 < city_id) and ServiceGuildCmdProxy.Instance.CallGvgCityStatueQueryGuildCmd then
    self:Debug("[GVG雕像] 公会战城池雕像请求 group_id |city_id", group_id, city_id)
    ServiceGuildCmdProxy.Instance:CallGvgCityStatueQueryGuildCmd(group_id, city_id)
  end
end

function GvgProxy.GetStatueCity(unique_id)
  local static_data = GvgProxy.TryGetStaticLobbyStrongHold()
  if static_data then
    return static_data.id
  end
  if not unique_id then
    return nil
  end
  local config = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.NpcUniqueId2CityId
  if config then
    return config[unique_id]
  end
  return nil
end

function GvgProxy:SetCurStatueCityId(id)
  self.cur_statue_unique_id = self:GetStatueUniqueId(id)
end

function GvgProxy:GetStatueUniqueId(city_id)
  if not city_id then
    return
  end
  if not self.statue_unique_map then
    self.statue_unique_map = {}
    local config = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.NpcUniqueId2CityId
    if config then
      for statue_unique_id, cityId in pairs(config) do
        if statue_unique_id ~= cityId then
          self.statue_unique_map[cityId] = statue_unique_id
        end
      end
    end
  end
  return self.statue_unique_map[city_id]
end

function GvgProxy:HandleCityStatue(server_data)
  self:Debug("[GVG雕像] GvgCityStatueQueryGuildCmd")
  GvgProxy.Print(server_data)
  local infos = server_data.infos
  if not infos then
    return
  end
  local group_id = server_data.groupid
  local city_map = self.cityStatueMap[group_id]
  if not city_map then
    city_map = {}
    self.cityStatueMap[group_id] = city_map
  end
  for i = 1, #infos do
    city_map[infos[i].cityid] = GvgStatueInfo.new(infos[i].info)
  end
  self.cacheStatueGroupID = group_id
end

function GvgProxy:GetCurMapStatueBattleGroupID()
  local id = GuildProxy.Instance:GetMyGuildGvgGroup()
  if id == 0 then
    return self.cacheStatueGroupID or 0
  end
  return id
end

function GvgProxy:GetCurMapStatueBattleClientGroupID()
  local id = self:GetCurMapStatueBattleGroupID()
  return GvgProxy.ClientGroupId(id)
end

function GvgProxy:GetNewStatueNpc()
  local statue_id = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatueNpcID
  if not statue_id then
    return nil
  end
  if Game.MapManager:IsInGVG_Lobby() then
    local statue_npc = NSceneNpcProxy.Instance:FindNpcs(statue_id)
    return statue_npc and statue_npc[1]
  end
  if not self.cur_statue_unique_id then
    return
  end
  local statue_npc = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.cur_statue_unique_id)
  if statue_npc then
    return statue_npc[1]
  end
  return nil
end

function GvgProxy:HandleCityStatueUpdate(server_data)
  self:Debug("[GVG雕像] GvgCityStatueUpdateGuildCmd")
  GvgProxy.Print(server_data)
  local group_id = server_data.groupid
  local city_map = self.cityStatueMap[group_id]
  if not city_map then
    city_map = {}
    self.cityStatueMap[group_id] = city_map
  end
  local city_id = server_data.cityid
  local statue = city_map[city_id]
  if not statue then
    statue = GvgStatueInfo.new(server_data.info.info)
    city_map[city_id] = statue
  end
  if server_data.exterior then
    statue:UpdateAvatar(server_data.info.info)
    self:Debug("[GVG雕像] 更新外观")
    local statue_npc = self:GetNewStatueNpc()
    if statue_npc then
      statue_npc:ReDress()
    end
  else
    local pose = server_data.info.info.pose
    local cache_pos = statue:GetPose()
    if pose and pose ~= cache_pos then
      statue:UpdatePose(pose)
      self:Debug("[GVG雕像] 更新Pose ", pose)
      self:ChangeStatuePos(pose)
    else
      self:Debug("[GVG雕像] 更新雕像")
      statue:Update(server_data.info.info)
    end
  end
  GvgProxy.Print(self.cityStatueMap)
end

function GvgProxy:GetStatueByCityId(group_id, city_id)
  local city_map = self.cityStatueMap[group_id]
  if city_map then
    return city_map[city_id]
  end
  return nil
end

function GvgProxy:CheckMyGroupCityStatueEmpty(city_id)
  local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
  local key, city_map
  if Game.MapManager:IsInGVG_Lobby() then
    local mapid = Game.MapManager:GetMapID()
    local lobby_static_data = Game.Config_GuildStrongHold_Lobby[mapid] or Game.Config_DateBattleCity_Lobby[mapid]
    if nil ~= lobby_static_data then
      city_id = lobby_static_data.id
      for groupid, data in pairs(self.cityStatueMap) do
        if data[city_id] then
          city_map = self.cityStatueMap[groupid]
          break
        end
      end
    end
  elseif not group_id or group_id == 0 then
    key, city_map = next(self.cityStatueMap)
  else
    city_map = self.cityStatueMap[group_id]
  end
  local statue_info = city_map and city_map[city_id]
  if not statue_info then
    return true
  end
  return statue_info:IsEmpty()
end

function GvgProxy:GetPoseByCityId(group_id, city_id)
  local data = self:GetStatueByCityId(group_id, city_id)
  if data then
    return data:GetPose()
  end
  return nil
end

function GvgProxy:GetStatueLeaderIdByCityId(group_id, city_id)
  local data = self:GetStatueByCityId(group_id, city_id)
  if data then
    return data:GetLeaderId()
  end
  return nil
end

function GvgProxy:GetLeaderNameByStatusCity(group_id, city_id)
  local data = self:GetStatueByCityId(group_id, city_id)
  if data then
    return data:GetLeaderName()
  end
  return nil
end

function GvgProxy:GetGuildNameByStatusCity(group_id, city_id)
  local data = self:GetStatueByCityId(group_id, city_id)
  if data then
    return data:GetGuildName()
  end
  return nil
end

function GvgProxy.TryGetStaticLobbyStrongHold()
  local raidId = Game.MapManager:GetMapID()
  local lobbyMap = Game.MapManager:IsGVG_DateBattle_Lobby() and Game.Config_DateBattleCity_Lobby or Game.Config_GuildStrongHold_Lobby
  return raidId and lobbyMap[raidId]
end

function GvgProxy:InitializeStatuePos(city_id, nnpc)
  local gvg_group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
  local pose = self:GetPoseByCityId(gvg_group_id, city_id)
  pose = pose or self:GetPoseByCityId(0, city_id)
  if not pose then
    return
  end
  local config = Table_ActionAnime[pose]
  if not config then
    return
  end
  nnpc:Server_PlayActionCmd(config.Name, nil, true)
end

function GvgProxy:ChangeStatuePos(pose)
  if not pose then
    return
  end
  local nnpc = self:GetNewStatueNpc()
  if not nnpc then
    return
  end
  local config = Table_ActionAnime[pose]
  if not config then
    return
  end
  nnpc:Server_PlayActionCmd(config.Name, nil, true)
end

function GvgProxy:ClearRuleGuildInfos()
  _TableClear(self.ruleGuild_Map)
end

function GvgProxy:IsInFightingTime()
  return self.gvg_isopen
end

function GvgProxy:SetGvgOpenTime(isOpen, starttime)
  self.gvg_isopen = isOpen
  self.gvg_opentime = starttime
end

function GvgProxy:GetGvgOpenTime()
  return self.gvg_opentime
end

function GvgProxy:RecvGuildFireMetalHpFubenCmd(data)
  self.metal_hpper = data.hpper
  self.sync_metal_invincible = data.god == true
  self:_updateCrystalInvincibleState()
end

function GvgProxy:RecvGvgDefNameChangeFubenCmd(data)
  self.def_guildname = data.newname
  self:Debug("NewGVGDebug防守方公会名 防守方公会名修改： ", data.newname)
end

function GvgProxy:IsNeutral()
  return self.def_guildid and self.def_guildid == 0
end

function GvgProxy:CanShowPointScore()
  if self:IsNeutral() then
    return false
  end
  return self:GetCurMapPointScore() > 0
end

function GvgProxy:GetDefGuildName()
  if StringUtil.IsEmpty(self.def_guildname) then
    if self.def_guildid and self.def_guildid > 0 then
      redlog("-------------------------[NewGVG]后端未赋值防守公会名")
    end
    return ""
  end
  return self.def_guildname
end

function GvgProxy:IsDefSide()
  return self.isDefSide
end

function GvgProxy:GetExpelTime()
  return self.expelTime or 15
end

function GvgProxy:EnterDeathStatus()
  if not Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  if not self:IHaveGuildPoint() then
    return
  end
  local expelTime = self:GetExpelTime()
  UIUtil.SceneCountDownMsg(2225, {
    tostring(expelTime)
  }, true)
end

function GvgProxy:ExitDeathStatus()
  if not Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  UIUtil.EndSceenCountDown(2225)
end

function GvgProxy:RecvGuildFireNewDefFubenCmd(data)
  self.def_guildid = data.guildid
  self.isDefSide = GuildProxy.Instance:IsMyGuildUnion(self.def_guildid)
  self.expelTime = self.isDefSide and GameConfig.GVGConfig.def_expel_time or GameConfig.GVGConfig.att_expel_time
  self.def_guildname = data.guildname
  self.metal_hpper = 100
  self:ClearMetalNpcMap()
  self:UpdateRoadBlock()
  self:Debug("NewGVG 切换攻守方，重置华丽水晶血量。新的防守方同步|防守方公会名： ", data.guildid, data.guildname)
end

function GvgProxy:RecvGvgDataSyncCmd(data)
  if not Game.MapManager:IsInGVG() then
    self:ClearQuestInfo()
  end
  local datas = data.datas
  for i = 1, #datas do
    local single = datas[i]
    self.questInfoData[single.type] = single.value
  end
  self.cityType = data.citytype
end

function GvgProxy:RecvGvgDataUpdateCmd(data)
  local gvgData = data.data
  self:CheckIfAchieve(self.questInfoData[gvgData.type], gvgData)
  self.questInfoData[gvgData.type] = gvgData.value
end

function GvgProxy:GetHonor()
  return self.questInfoData[FuBenCmd_pb.EGVGDATA_HONOR] or 0
end

function GvgProxy:GetCoin()
  return self.questInfoData[FuBenCmd_pb.EGVGDATA_COIN] or 0
end

function GvgProxy:GetMvpDamage()
  return self.questInfoData[FuBenCmd_pb.EGVGDATA_DAM_MVP] or 0
end

function GvgProxy:CheckIfAchieve(oldData, data)
  local key = data.type
  local value = data.value
  local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]
  if configData then
    local index = 1
    local dataInfo
    local maxRound = index < #configData and #configData or index
    if key == _fubenCmd.EGVGDATA_KILLUSER then
      return
    end
    while true do
      if configData[index] and value < configData[index].times or index > maxRound then
        if value >= configData[maxRound].times then
          if oldData and oldData < configData[maxRound].times or not oldData then
            GameFacade.Instance:sendNotification(GVGEvent.ShowNewAchievemnetEffect)
          end
          break
        end
        if configData[index - 1] and (oldData and oldData < configData[index - 1].times or not oldData) then
          GameFacade.Instance:sendNotification(GVGEvent.ShowNewAchievemnetEffect)
        end
        break
      end
      index = index + 1
    end
  end
end

function GvgProxy:CheckPersonalTaskIsFinish(key)
  local value = self.questInfoData[key]
  if not value then
    return false
  end
  local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]
  if configData then
    local index = 1
    local dataInfo
    local maxRound = index < #configData and #configData or index
    if key == _fubenCmd.EGVGDATA_KILLUSER then
      return false
    end
    if value >= configData[maxRound].times then
      return true
    end
  end
end

function GvgProxy:_TryShowCDTime(calm_time)
  if calm_time and 0 < calm_time then
    if not self:IsCalmState() then
      redlog("NewGVG 非冷静期后端同步了冷静期截止时间")
      return
    end
    local curServerTime = ServerTime.CurServerTime() / 1000
    local cdtime = calm_time - curServerTime
    if 0 < cdtime then
      MsgManager.ShowMsgByIDTable(2220, {
        tostring(cdtime)
      })
    end
  end
end

function GvgProxy:_UpdateNextRaidState(perfect)
  if not perfect then
    return
  end
  if self.isPerfect == perfect then
    return
  end
  self.isPerfect = perfect
end

function GvgProxy:NextStateIsPerfectDefense()
  return self.isPerfect == true
end

function GvgProxy:RecvGuildFireInfoFubenCmd(data)
  self:Debug("NewGVG 玩家进入时同步公会战信息 ")
  GvgProxy.Print(data)
  self:_UpdateRaidState(data.raidstate)
  self:_UpdateNextRaidState(data.perfect)
  self:_TryShowCDTime(data.calm_time)
  self.def_guildid = data.def_guildid
  redlog("Debug防守方公会id： ", data.def_guildid)
  self.isDefSide = GuildProxy.Instance:IsMyGuildUnion(self.def_guildid)
  self.expelTime = self.isDefSide and GameConfig.GVGConfig.def_expel_time or GameConfig.GVGConfig.att_expel_time
  self.endfire_time = data.endfire_time
  self.metal_hpper = data.metal_hpper
  self.def_guildname = data.def_guildname
  self:Debug("NewGVGDebug防守方公会名 进入副本防守公会名字 ", self.def_guildname)
  self.def_perfect = data.def_perfect
  self.danger = data.danger
  self:ClearPoints()
  self:_RecvPoint(data.points, true)
  if data.my_smallmetal_cnt then
    self:HandleSmallMetalCnt(self:GetGuildID(), data.my_smallmetal_cnt)
  end
  self:DoQueryGvgZoneGroup(true)
  self:_resetPerfectDefense(self:IsPerfectDefense())
  self.perfectTimeInfo = GvGPerfectTimeInfo.new(data.perfect_time)
  self:_resetPerfectDefensePause(data.perfect_time.pause)
  self:Debug("[NewGVG]进入副本 完美防守暂停|时间： ", self.perfectTimeInfo.pause, os.date("%Y-%m-%d-%H-%M-%S", self.perfectTimeInfo.time))
  self.sync_metal_invincible = data.metal_god == true
  self:_updateCrystalInvincibleState()
  if nil ~= data.roadblock then
    self.roadBlock = data.roadblock
  end
  self:UpdateCurMapGvgGroupId(data.gvg_group)
  self:HandleMvpUpdate(data.mvp_hp_per, data.mvp_state)
  self:UpdateRoadBlock()
end

function GvgProxy:UpdateRoadBlock()
  local npcid = GameConfig.GvgNewConfig.roadblock_npcid
  if npcid then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(npcid)
    if npcs then
      for _, v in pairs(npcs) do
        if v then
          v:TryUpdateRoadBlock()
        end
      end
    end
  end
end

function GvgProxy:ClearRoadBlock()
end

function GvgProxy:UpdateCurMapGvgGroupId(id)
  self.curMapGvgGroupId = id
end

function GvgProxy:HandleRoadBlockChange(data)
  if nil ~= data.roadblock then
    self.roadBlock = data.roadblock
  end
end

function GvgProxy:GetRoadBlock()
  return self.roadBlock
end

function GvgProxy:_resetPerfectDefensePause(pause)
  if not self.perfectTimeInfo then
    return
  end
  if nil == pause then
    return
  end
  local event = pause and GVGEvent.GVG_PerfectDefensePause or GVGEvent.GVG_PerfectDefenseResume
  local _debugStr = pause and "[NewGVG] 主界面暂停完美防守" or "[NewGVG] 主界面重启完美防守"
  self:Debug(_debugStr)
  GameFacade.Instance:sendNotification(event)
end

function GvgProxy:_resetPerfectDefense(perfect)
  self:Debug("[NewGVG] 重置是否为完美防守 ", perfect)
  if nil == perfect then
    return
  end
  if self.isPerfectDefense == perfect then
    return
  end
  self.isPerfectDefense = perfect
  if perfect then
    GameFacade.Instance:sendNotification(GVGEvent.GVG_PerfectDefenseSuccess)
  end
end

function GvgProxy:CheckPerfectDefense()
  return self.isPerfectDefense == true
end

function GvgProxy:ClearCurPerfectDefenseState()
  self.isPerfectDefense = nil
  self.perfectTimeInfo = nil
end

function GvgProxy:RecvPerfectStateUpdate(server_data)
  self:_resetPerfectDefense(server_data.perfect)
  self.perfectTimeInfo = GvGPerfectTimeInfo.new(server_data.perfect_time)
  self:_resetPerfectDefensePause(server_data.perfect_time.pause)
  self:Debug("[NewGVG] 完美防守状态更新 pause|perfect|time ", self.perfectTimeInfo.pause, server_data.perfect, os.date("%Y-%m-%d-%H-%M-%S", self.perfectTimeInfo.time))
end

function GvgProxy:GetPerfectTimeInfo()
  return self.perfectTimeInfo
end

function GvgProxy:HandleRecvGvgScoreInfoUpdateGuildCmd(server_data)
  local info = server_data.info
  if not info then
    return
  end
  self.scoreInfo = {}
  self.scoreInfo.defense = info.defense_score
  self.scoreInfo.attack = info.attack_score
  self.scoreInfo.perfect = info.perfect_score
  self.scoreInfo.kill_mvp = info.mvp_score
  self:Debug("[NewGVG] 本场公会战积分信息 保卫城池得分|击破华丽金属得分|完美防守得分 ", info.defense_score, info.attack_score, info.perfect_score)
  self.scoreInfo.scoreDefenseCityMap = {}
  local defensecitys = info.defensecitys
  if not defensecitys then
    self:Debug("[NewGVG] no defensecitys")
    return
  end
  self:Debug("[NewGVG] server defensecitys length: ", #defensecitys)
  for i = 1, #defensecitys do
    self:_UpdateDefenseData(defensecitys[i])
  end
  self.preCityID = info.precityid
  _TableClear(self.losePointMap)
  self.scoreInfo.pointScore = self:GetMaxPointScore()
  local lose_points = info.lose_points
  if nil ~= lose_points then
    self.scoreInfo.pointScore = self.scoreInfo.pointScore - #lose_points
    for i = 1, #lose_points do
      self.losePointMap[lose_points[i]] = 1
    end
  end
  if not self:HasPreCity() then
    if self:GetPointScore() > 0 then
      redlog("服务器发错，无原城池时，防守积分应该为全部丢失,客户端强制改为0")
    end
    self.scoreInfo.pointScore = 0
  end
end

function GvgProxy:HasPreCity()
  return nil ~= self.preCityID and self.preCityID > 0
end

function GvgProxy:GetPointScore()
  return self.scoreInfo and self.scoreInfo.pointScore or 0
end

function GvgProxy:CheckPointIsLost(p)
  return nil ~= self.losePointMap[p]
end

function GvgProxy:GetMaxPointScore()
  return self.maxPointScore
end

function GvgProxy:GetCurRaidMode()
  return self.curRaidMode or 1
end

function GvgProxy:_UpdateDefenseData(server_data)
  local defenseData = GvgDefenseData.new(server_data)
  self.scoreInfo.scoreDefenseCityMap[defenseData.cityid] = defenseData
end

function GvgProxy:GetMaxOccupyCityScore()
  if not self.maxOccupy_city_score then
    self.maxOccupy_city_score = 0
    local config = GameConfig.GVGConfig and GameConfig.GVGConfig.citytype_data
    if config then
      local mathMax = math.max
      for _, v in pairs(config) do
        if v.occupy_city_score then
          self.maxOccupy_city_score = mathMax(v.occupy_city_score, self.maxOccupy_city_score)
        end
      end
    end
  end
  return self.maxOccupy_city_score
end

function GvgProxy:GetBattleEndInfo()
  if not self.battleEndConfig then
    self.battleEndConfig = GameConfig.GVGConfig.ScoreTip.Season and GameConfig.GVGConfig.ScoreTip.Season.battleEnd
  end
  return self.battleEndConfig
end

function GvgProxy:GetBattleInfo()
  if not self.battleScoreConfig then
    self.battleScoreConfig = GameConfig.GVGConfig.ScoreTip.Season and GameConfig.GVGConfig.ScoreTip.Season.battle
  end
  return self.battleScoreConfig
end

function GvgProxy:GetLeisureBattleEndInfo()
  if not self.leisureBattleEndConfig then
    self.leisureBattleEndConfig = GameConfig.GVGConfig.ScoreTip.Leisure and GameConfig.GVGConfig.ScoreTip.Leisure.battleEnd
  end
  return self.leisureBattleEndConfig
end

function GvgProxy:GetLeisureBattleInfo()
  if not self.leisureBattleScoreConfig then
    self.leisureBattleScoreConfig = GameConfig.GVGConfig.ScoreTip.Leisure and GameConfig.GVGConfig.ScoreTip.Leisure.battle
  end
  return self.leisureBattleScoreConfig
end

function GvgProxy:GetScorePerfectDefenseInfo()
  local mapData = self.scoreInfo and self.scoreInfo.scoreDefenseCityMap
  if not mapData then
    return
  end
  local defensePerfectData = {}
  for k, v in pairs(mapData) do
    defensePerfectData[#defensePerfectData + 1] = {
      v.cityName,
      v.time,
      v.perfect,
      v.pause
    }
  end
  return defensePerfectData
end

function GvgProxy:GetScoreInfoByKey(key)
  return self.scoreInfo and self.scoreInfo[key] or 0
end

function GvgProxy:HandleSettleInfo(info)
  if not info then
    return
  end
  self.settleInfo = GvgSettleInfo.new(info)
  if self.settleInfo.settleFinish then
    if not self.manualSettleReq then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GLandStatusCombineView
      })
    end
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GvgLandPlanView
    })
  end
  self.manualSettleReq = nil
end

function GvgProxy:IsPlanConfirmed()
  return self.settleInfo and self.settleInfo:IsPlanConfirmed()
end

function GvgProxy:GetGLandSettleData()
  return self.settleInfo and self.settleInfo.settleCityList or _EmptyTable
end

function GvgProxy:GetLastWeekGuildName()
  return self.settleInfo and self.settleInfo:GetLastWeekGuildName()
end

function GvgProxy:GetLastWeekCityName()
  return self.settleInfo and self.settleInfo:GetLastWeekCityName()
end

function GvgProxy:HasSelectCitys()
  return self.settleInfo and self.settleInfo:HasSelectCitys()
end

function GvgProxy:initGuildDateRaidStrongHold()
  if not Game.MapManager:IsGVG_DateBattle() then
    return
  end
  local raidId = Game.MapManager:GetRaidID()
  local staticData = Game.Config_DateBattleCity_RaidMap[raidId]
  if not staticData then
    redlog("未在Table_DateBattleCity表中找到[公会约战]城池配置。 当前RaidID ", raidId)
    return
  end
  self.curStrongHoldStaticData = staticData
end

function GvgProxy:initGvgRaidStrongHold()
  local raidId = Game.MapManager:GetRaidID()
  self:Debug("NewGVG 当前raidId ： ", raidId)
  local staticData = Game.Config_GuildStrongHold_RaidMap[raidId]
  if not staticData then
    redlog("Table_Guild_StrongHold 配置未找到  raidId : ", raidId)
    return
  end
  self.curStrongHoldStaticData = staticData
end

local _invalid_mvp_id = 0

function GvgProxy:GetCurMvpId()
  if not self.mvp_id then
    if Game.MapManager:IsGVG_DateBattle() then
      self.mvp_id = _invalid_mvp_id
    else
      local static_data = self:GetCurStrongHoldConfig()
      local city_type = static_data and static_data.CityType
      if city_type then
        local config = GameConfig.GvgNewConfig and GameConfig.GvgNewConfig.city_type_to_mvp
        self.mvp_id = config and config[city_type] and config[city_type].monster or _invalid_mvp_id
      else
        self.mvp_id = _invalid_mvp_id
      end
    end
  end
  return self.mvp_id
end

function GvgProxy:HasMapMvp()
  if self:IsMvpDead() then
    return false
  end
  local mvp = self:GetCurMvpId()
  return nil ~= mvp and 0 < mvp
end

function GvgProxy:ResetMvp()
  self.mvp_id = nil
  self.mvp_state = GvgProxy.EMvpState.None
  self.mvp_hp_per = 0
end

local mvp_state_debug_str
local Get_mvp_state_str = function(state)
  if not mvp_state_debug_str then
    local EMvpState = GvgProxy.EMvpState
    mvp_state_debug_str = {
      [EMvpState.None] = ZhString.GvgLand_Mvp_State_None,
      [EMvpState.Will_Summon] = ZhString.GvgLand_Mvp_State_WillSommon,
      [EMvpState.Summoned] = ZhString.GvgLand_Mvp_State_Sommoned,
      [EMvpState.Die] = ZhString.GvgLand_Mvp_State_Die
    }
  end
  return mvp_state_debug_str[state]
end

function GvgProxy:HandleMvpUpdate(hp_per, mvp_state)
  self.mvp_hp_per, self.mvp_state = hp_per, mvp_state
  self:Debug("NewGVG MVP 血量百分比|mvp 状态： ", self.mvp_hp_per, Get_mvp_state_str(self.mvp_state))
  GameFacade.Instance:sendNotification(GVGEvent.GVG_MvpStateUpdate)
end

function GvgProxy:GetMvpHpPer()
  return self.mvp_hp_per
end

function GvgProxy:IsMvpAlive()
  return self.mvp_state == GvgProxy.EMvpState.Summoned
end

function GvgProxy:IsMvpDead()
  return self.mvp_state == GvgProxy.EMvpState.Die
end

function GvgProxy:GetCurStrongHoldConfig()
  return self.curStrongHoldStaticData
end

function GvgProxy:InitCurRaidStrongHold()
  self:ResetMvp()
  if Game.MapManager:IsGVG_DateBattle() then
    self:initGuildDateRaidStrongHold()
  else
    self:initGvgRaidStrongHold()
  end
  self.curRaidMode = self.curStrongHoldStaticData and self.curStrongHoldStaticData.Mode or 1
end

local _separator = ","

function GvgProxy:GetAllProtectMetalStr()
  if nil == self.allProtectMetelStr then
    local pointConfig = self:GetCurRaidStrongHoldPointConfig()
    if pointConfig then
      for id, conf in pairs(pointConfig) do
        if conf.protect_metal == 1 then
          if not self.allProtectMetelStr then
            self.allProtectMetelStr = tostring(id)
          else
            self.allProtectMetelStr = self.allProtectMetelStr .. _separator .. tostring(id)
          end
        end
      end
    end
  end
  return self.allProtectMetelStr
end

function GvgProxy:GetCurRaidStrongHoldPointConfig()
  local staticData = self.curStrongHoldStaticData
  local point = staticData and staticData.Point or nil
  return point
end

function GvgProxy:_UpdateHoldMetalNpc(point_id)
  self.metalNpc = self.metalNpc or {}
  local staticData = self.curStrongHoldStaticData
  local ratio = staticData and staticData.Point and staticData.Point[point_id] and staticData.Point[point_id].calc_ratio
  if not ratio then
    self:SetActiveNpc(point_id, point_id)
  else
    for i = 1, ratio do
      self:SetActiveNpc(i, point_id)
    end
  end
end

function GvgProxy:SetActiveNpc(uniqueid, point_id)
  local nnpcArray = NSceneNpcProxy.Instance:FindNpcByUniqueId(uniqueid)
  if nnpcArray and 0 < #nnpcArray and nnpcArray[1].assetRole then
    local miniMapGvgStrongHoldData = self.gvgStrongHoldDatas and self.gvgStrongHoldDatas[point_id]
    local active = miniMapGvgStrongHoldData and miniMapGvgStrongHoldData:IsActive()
    if active then
      nnpcArray[1].assetRole:SetInvisible(false)
      self:SetHideCreatureSceneUI(nnpcArray[1], false)
    else
      nnpcArray[1].assetRole:SetInvisible(true)
      self:SetHideCreatureSceneUI(nnpcArray[1], true)
    end
    self.metalNpc[nnpcArray[1].data.id] = active
  end
end

local maskTypes = {
  MaskPlayerUIType.NameType
}

function GvgProxy:SetHideCreatureSceneUI(creature, isHide)
  if not creature then
    return
  end
  local methodName = isHide and "MaskUI" or "UnMaskUI"
  if creature[methodName] then
    for _, t in pairs(maskTypes) do
      creature[methodName](creature, PUIVisibleReason.GVGNPC, t)
    end
  end
end

function GvgProxy:CheckMetalNpcBornHide(id)
  return nil ~= self.metalNpc and nil ~= id and self.metalNpc[id] == false
end

function GvgProxy:ClearMetalNpcMap()
  if self.metalNpc then
    _TableClear(self.metalNpc)
  end
  self.allProtectMetelStr = nil
end

function GvgProxy:GetGvgStrongHoldDatas()
  return self.gvgStrongHoldDataArray
end

function GvgProxy:UpdateGvgStrongHoldSymbolDatas()
  if not self.gvgStrongHoldDatas then
    self.gvgStrongHoldDatas = {}
  end
  if not self.gvgStrongHoldDataArray then
    self.gvgStrongHoldDataArray = {}
  end
  TableUtility.ArrayClear(self.gvgStrongHoldDataArray)
  local configs = self:GetCurRaidStrongHoldPointConfig()
  if not configs then
    TableUtility.TableClear(self.gvgStrongHoldDatas)
    return
  end
  for k, v in pairs(self.gvgStrongHoldDatas) do
    if not configs[v.id] then
      self.gvgStrongHoldDatas[k] = nil
    end
  end
  for id, conf in pairs(configs) do
    local data = self:GetPointData(id)
    local cachedData = self.gvgStrongHoldDatas[id]
    if cachedData then
      cachedData:SetConfig(conf)
      cachedData:SetData(data)
    else
      cachedData = MiniMapGvgStrongHoldData.new(id, conf, data)
      self.gvgStrongHoldDatas[id] = cachedData
    end
    table.insert(self.gvgStrongHoldDataArray, cachedData)
    self:_UpdateHoldMetalNpc(id)
  end
  table.sort(self.gvgStrongHoldDataArray, function(a, b)
    return a and b and a:GetIndex() < b:GetIndex()
  end)
end

function GvgProxy:GetCurCityId()
  if not self.curStrongHoldStaticData then
    self:InitCurRaidStrongHold()
  end
  return self.curStrongHoldStaticData and self.curStrongHoldStaticData.id or -1
end

function GvgProxy:_getOrCreateCityShowData(groupid, cityid)
  local group_map = self.cityShowDataMap[groupid]
  if not group_map then
    group_map = {}
    self.cityShowDataMap[groupid] = group_map
  end
  local cityShowData = group_map[cityid]
  if not cityShowData then
    cityShowData = GvGCityShowData.new(cityid, groupid)
    group_map[cityid] = cityShowData
  end
  return cityShowData
end

function GvgProxy:_updateSingleCityInfo(server_info, groupid)
  if not (server_info and server_info.cityid) or not groupid then
    return
  end
  local cityShowData = self:_getOrCreateCityShowData(groupid, server_info.cityid)
  cityShowData:SetSrvData(server_info)
  FunctionGuild.Me():SetGuildLandIcon(cityShowData.cityid, cityShowData.portrait, cityShowData.guildid)
end

function GvgProxy:NeedMoveToCity(var, isMyCity)
  self.needMoveToCity = var
  self.isMyCity = isMyCity
end

local tempV3 = LuaVector3()
local fName = "Scene_Guild_battle_enter"

function GvgProxy:LaunchMoveToCity(targetCityId, curRaidId, force, isMyCity)
  if not targetCityId or not curRaidId then
    return
  end
  if not self.needMoveToCity and not force then
    return
  end
  local sceneInfo = autoImport(fName)
  if not (sceneInfo and sceneInfo.Raids[curRaidId]) or not sceneInfo.Raids[curRaidId].eps then
    return
  end
  local epIndex
  if nil ~= isMyCity then
    self.isMyCity = isMyCity
  end
  if self.isMyCity then
    epIndex = 1
  else
    local myGuildOccupyCity = GuildProxy.Instance:GetMyGuildOccupyCity()
    epIndex = myGuildOccupyCity == targetCityId and 1 or 0
  end
  local index
  local eps = sceneInfo.Raids[curRaidId].eps
  for i = 1, #eps do
    if eps[i].exitType == epIndex then
      index = i
      break
    end
  end
  if not index then
    return
  end
  local epPos = eps[index].position
  local cmdArgs = ReusableTable.CreateTable()
  LuaVector3.Better_Set(tempV3, epPos[1], epPos[2], epPos[3])
  cmdArgs.targetPos = tempV3
  cmdArgs.showClickGround = true
  cmdArgs.allowExitPoint = true
  
  function cmdArgs.callback(callerCMD, cmdEvent)
    self.needMoveToCity = false
    self:Debug("NewGVG 移动到城池 ", targetCityId)
  end
  
  local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  Game.Myself:Client_SetMissionCommand(cmd)
  ReusableTable.DestroyAndClearTable(cmdArgs)
  GameFacade.Instance:sendNotification(GVGEvent.GVG_TraceToCity)
end

function GvgProxy:Update_GLandStatusInfos(server_infos, groupid)
  if not groupid then
    return
  end
  if not server_infos or #server_infos == 0 then
    return
  end
  for _, server_info in ipairs(server_infos) do
    self:_updateSingleCityInfo(server_info, groupid)
  end
  self._cityShowDataCacheDirty[groupid] = true
end

function GvgProxy:GetGvGCityShowData(city_id)
  local myGuildGvgGroup = GuildProxy.Instance:GetMyGuildGvgGroup()
  local group_id = myGuildGvgGroup ~= 0 and myGuildGvgGroup or 0
  local city_map = self.cityShowDataMap[group_id]
  if city_map then
    return city_map[city_id]
  end
end

function GvgProxy:SetDiffServer(server_id)
  if not server_id or server_id == 0 then
    return
  end
  self.diffServerCount = self.diffServerCount or 0
  if not self.diffServerIdMap[server_id] then
    self.diffServerCount = self.diffServerCount + 1
    self.diffServerIdMap[server_id] = 1
  end
end

function GvgProxy:CheckDiffServerValid()
  return self.diffServerCount and self.diffServerCount > 1
end

function GvgProxy:Get_GLandStatusInfos(groupid)
  if not self._cityShowDataCacheDirty[groupid] then
    return self.groupCityShowList[groupid]
  end
  self._cityShowDataCacheDirty[groupid] = false
  local resultList = self.groupCityShowList[groupid]
  if not resultList then
    resultList = {}
    self.groupCityShowList[groupid] = resultList
  else
    _ArrayClear(resultList)
  end
  local cityMap = self.cityShowDataMap[groupid]
  if not cityMap then
    return resultList
  end
  local count = 0
  for _, cityData in pairs(cityMap) do
    count = count + 1
    resultList[count] = cityData
  end
  if 0 < count then
    table.sort(resultList, function(a, b)
      return a.cityid < b.cityid
    end)
  end
  return resultList
end

function GvgProxy:GetGuildInfos()
  local testDatas = {}
  for i = 1, 4 do
    local guildData = {
      id = 12312,
      customIconUpTime = 215456464,
      customicon = 1545
    }
    guildData.pieces = i
    guildData.metal = i
    guildData.occupationValue = 100
    testDatas[#testDatas + 1] = guildData
  end
  return testDatas
end

function GvgProxy:ShowGvgFinalFightTip(stick)
  TipManager.Instance:ShowGvgFinalFightTip(stick, NGUIUtil.AnchorSide.Right, {-450, 0})
end

function GvgProxy:HandleSyncGvgFightPoint(fight_points)
end

function GvgProxy:HandleSyncGvgLeaderPos(friend_leaders, enemy_leaders)
end

function GvgProxy:SetGvgOpenFireState(data)
  self.gvgOpenFireState = data.fire or false
  self.gvgFireSettleTime = data.settle_time
  self.gvgStartTime = data.start_time
  if self.gvgStartTime and self.gvgStartTime > 0 and self.gvgStartTime - ServerTime.CurServerTime() / 1000 <= 300 then
    RedTipProxy.Instance:UpdateRedTip(10773)
  end
  self:Debug("[NewGVG] GvgOpenFireGuildCmd fire | settleTime ", self.gvgOpenFireState, os.date("%Y-%m-%d-%H-%M-%S", self.gvgFireSettleTime), os.date("%Y-%m-%d-%H-%M-%S", self.gvgStartTime))
  self:ManualQuerySettleInfo()
end

function GvgProxy:ManualQuerySettleInfo()
  if self.gvgOpenFireState == false and self:CheckInSettleTime() and (GuildProxy.Instance:ImGuildChairman() or GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GvgCity)) then
    self.manualSettleReq = true
    ServiceGuildCmdProxy.Instance:CallGvgSettleReqGuildCmd()
  end
end

function GvgProxy:GetGvgOpenFireState()
  return self.gvgOpenFireState
end

function GvgProxy:CheckInSettleTime()
  return self.gvgFireSettleTime and self.gvgFireSettleTime > 0 and self.gvgFireSettleTime > ServerTime.CurServerTime() / 1000
end

function GvgProxy:GetSettleTime()
  return self.gvgFireSettleTime
end

function GvgProxy:CheckIsReadyToOpen()
  return self.gvgStartTime and self.gvgStartTime > 0 and self.gvgStartTime - ServerTime.CurServerTime() / 1000 <= 300
end

function GvgProxy:IsGvgFlagShow()
  return not self:GetGvgOpenFireState() and (not self:CheckInSettleTime() or not GuildProxy.Instance:IHaveGuild()) and self:CheckIsReadyToOpen() and GuildProxy.Instance:IHaveGuild()
end

local _defaultTime = 1800

function GvgProxy:IsFPSOptimizeValid()
  local _mapMgr = Game.MapManager
  local isGVG = _mapMgr:IsPVPMode_GVGDetailed()
  local isGVGDroiyan = _mapMgr:IsGvgMode_Droiyan()
  local durationTime
  if isGVG then
    durationTime = GameConfig.GVGConfig.last_time
  elseif isGVGDroiyan then
    durationTime = GameConfig.GvgDroiyan.LastTime
  else
    durationTime = _defaultTime
  end
  if self.frameCheckTime and durationTime > UnityRealtimeSinceStartup - self.frameCheckTime then
    return true
  end
  return false
end

function GvgProxy:SetFPSOptimizeFlag()
  self.frameCheckTime = UnityRealtimeSinceStartup
end

function GvgProxy:IsFPSOptimizeSet()
  return nil ~= self.frameCheckTime
end

function GvgProxy:ClearFPSCheckTime()
  self.frameCheckTime = nil
end

function GvgProxy:FpsReEnterMap()
  if self:IsFPSOptimizeValid() and Game.GameHealthProtector then
    Game.GameHealthProtector:OptimizeGVGSettingOption()
  end
end

function GvgProxy:SetStatueInfo(data)
  if data.serverid ~= MyselfProxy.Instance:GetServerId() then
    return
  end
  self:SetStatueAppearance(data.appearance)
  self:SetStatuePose(data.pose)
  self:SetPrefire(data.prefire)
  self.statueInfo.season = data.season
end

function GvgProxy:SetStatueAppearance(info)
  local statueInfo = self.statueInfo
  if statueInfo == nil then
    statueInfo = {}
    self.statueInfo = statueInfo
  end
  local dirty
  for k, v in pairs(info) do
    if statueInfo[k] ~= info[k] then
      dirty = true
      statueInfo[k] = v
    end
  end
  local config = Table_Body[statueInfo.body]
  if config == nil then
    statueInfo.body = nil
  end
  if dirty then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatueNpcID)
    if npcs ~= nil and 0 < #npcs then
      npcs[1]:ReDress()
    end
  end
end

function GvgProxy:SetStatuePose(pose)
  local curPose = self.statueInfo.pose
  if pose == curPose then
    return
  end
  self.statueInfo.pose = pose
  self:UpdateStatuePose(pose)
end

local _ObstacleAction = {Defensive = "state3001", Offensive = "state1001"}

function GvgProxy:InitObstacleAction(npc)
  if not Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  local actionName = self:IsDefSide() and _ObstacleAction.Defensive or _ObstacleAction.Offensive
  npc:Server_PlayActionCmd(actionName)
end

function GvgProxy:UpdateStatuePose(pose, npc)
  if pose == nil then
    local info = self.statueInfo
    if info == nil then
      return
    end
    pose = info.pose
  end
  if npc == nil then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatueNpcID)
    if npcs == nil or #npcs == 0 then
      return
    end
    npc = npcs[1]
  end
  local config = Table_ActionAnime[pose]
  if config then
    npc:Server_PlayActionCmd(config.Name, nil, true)
  end
end

function GvgProxy:SetPrefire(prefire)
  local curPrefire = self.statueInfo.prefire
  if prefire == curPrefire then
    return
  end
  self.statueInfo.prefire = prefire
  local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatuePedestalNpcID)
  if npcs == nil or #npcs == 0 then
    return
  end
  local pose = prefire and 200 or 0
  local config = Table_ActionAnime[pose]
  if config then
    npcs[1]:Server_PlayActionCmd(config.Name, nil, true)
  end
end

function GvgProxy:GetStatueInfo()
  return self.statueInfo
end

function GvgProxy:CanOptStatue()
  local statueInfo = self.statueInfo
  if statueInfo == nil then
    return false
  end
  if statueInfo.leaderid ~= Game.Myself.data.id then
    return false
  end
  return true
end

function GvgProxy:updateCookingInfo(data)
  GVGCookingHelper.Me():updateCookingInfo(data)
end

function GvgProxy:RecvGvgTaskUpdateGuildCmd(data)
  xdlog("GVG团队任务")
  if not self.groupTask then
    self.groupTask = {}
  end
  if not Game.MapManager:IsInGVG() then
    TableUtility.TableClear(self.groupTask)
  end
  local tasks = data.tasks
  if tasks and 0 < #tasks then
    for i = 1, #tasks do
      self.groupTask[tasks[i].taskid] = tasks[i].progress
      xdlog("团队赛任务进度同步", tasks[i].taskid, tasks[i].progress)
    end
  end
end

function GvgProxy:GetGroupTasks()
  return self.groupTask
end

function GvgProxy:GetTaskProgress(id)
  if self.groupTask[id] then
    return self.groupTask[id]
  end
end

function GvgProxy:CheckGroupTaskIsFinish(taskid)
  if not self.groupTask then
    return false
  end
  local config
  for k, v in pairs(GameConfig.GVGConfig.GvgTask) do
    if v.taskid == taskid then
      config = v
      break
    end
  end
  if config then
    local progress = self.groupTask[taskid] or 0
    if config.task_type == GuildCmd_pb.EGVGGUILDTASK_POINT_TIME or config.task_type == GuildCmd_pb.EGVGGUILDTASK_POINT_FIGHT then
      progress = progress // 60
    elseif config.task_type == GuildCmd_pb.EGVGGUILDTASK_PERFECT_DEFENSE and 0 < progress then
      progress = config.need_count
    end
    if progress >= config.need_count then
      return true
    end
  end
  return false
end

function GvgProxy:GetGroupTaskID()
  return self.groupTaskID
end

function GvgProxy:GetGroupTaskProgress()
  return self.groupTaskProgress
end

function GvgProxy:RecvGvgExcellectQueryUserCmd(data)
  self.rewardid = data.rewardid
  self.isLeisure = data.leisure
  self:Debug("GvgExcellectQueryUserCmd", self.rewardid, self.isLeisure)
  if not self.isLeisure then
    self:DoQueryGvgZoneGroup()
  end
  self:RefreshExcellentRewardRedTip()
end

function GvgProxy:RefreshExcellentRewardRedTip()
  if not self.season then
    return
  end
  local hasUnRecv = false
  if not self.isLeisure then
    local curExcellent = Game.Myself.data.userdata:Get(UDEnum.EXCELLECT) or 0
    for _id, _info in pairs(Table_GuildGvgProgressReward) do
      local curRewardId = self.rewardid or 0
      if curExcellent >= _info.Excellent and _id > curRewardId then
        hasUnRecv = true
        break
      end
    end
  end
  if hasUnRecv then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_EXCELLENT_REWARD)
  else
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_EXCELLENT_REWARD)
  end
end

function GvgProxy:RecvGvgExcellectRewardUserCmd(data)
  self.rewardid = data.rewardid
  self:Debug("GvgExcellectRewardUserCmd", self.rewardid)
  self:RefreshExcellentRewardRedTip()
end

function GvgProxy:IsGvgInLeisureMode()
  return self.isLeisure
end

function GvgProxy:GetExcellentRewardid()
  return self.rewardid
end

function GvgProxy:GetExcellentRank()
  if not Table_GuildGvgProgressReward then
    return
  end
  local nowSeason = self:NowSeason()
  if not nowSeason then
    return
  end
  local curExcellent = Game.Myself.data.userdata:Get(UDEnum.EXCELLECT) or 0
  local curRank = 1
  for _id, _info in pairs(Table_GuildGvgProgressReward) do
    if curExcellent >= _info.Excellent and _info.Rank and curRank < _info.Rank then
      curRank = _info.Rank
      xdlog("设置rank", _id, curRank)
    end
  end
  return curRank
end

function GvgProxy:SetSandTableInfos(data)
  self.GvgSandTableInfo.group = data.gvg_group
  self.GvgSandTableInfo.starttime = data.starttime
  self.GvgSandTableInfo.endtime = data.endtime
  self.GvgSandTableInfo.noMoreMetal = data.nomore_smallmetal
  local tableInfos = data.info or {}
  local sandTableInfo = self.GvgSandTableInfo.sandTableInfo or {}
  for i = 1, #tableInfos do
    local singleTableInfo = GvgSandTableData.new(tableInfos[i])
    sandTableInfo[tableInfos[i].city] = singleTableInfo
  end
  self.GvgSandTableInfo.sandTableInfo = sandTableInfo
end

function GvgProxy:GetSandTableInfoByID(id)
  local sandTableInfo = self.GvgSandTableInfo.sandTableInfo
  if sandTableInfo[id] then
    return sandTableInfo[id]
  end
end

function GvgProxy:GetSandTableTimes()
  return self.GvgSandTableInfo.starttime, self.GvgSandTableInfo.endtime
end

function GvgProxy:noMoreMetal()
  return self.GvgSandTableInfo.noMoreMetal
end

function GvgProxy:updateCookingInfo(data)
  GVGCookingHelper.Me():updateCookingInfo(data)
end

function GvgProxy:RecvSetReliveMethodUserEvent(data)
  self.reviveMethod = data.relive_method
end

function GvgProxy:GetReviveMethod()
  return self.reviveMethod
end

function GvgProxy:SetReviveMethod(method)
  self.reviveMethod = method
end

function GvgProxy:IsInRoadBlockActivedTime()
  if self:GetGvgOpenFireState() then
    return true
  end
  if self:CheckInSettleTime() then
    return true
  end
  local gvg_openTime
  local curTime = ServerTime.CurServerTime() / 1000
  local weekStartTime = ServerTime.GetWeekStartTimeStamp(curTime)
  local startTimes = GameConfig.GVGConfig.start_time
  if startTimes then
    for i = 1, #startTimes do
      local config = startTimes[i]
      if not config.super then
        local openTime = weekStartTime + (((config.day - 1) * 24 + config.hour) * 60 + config.min) * 60
        if curTime < openTime then
          gvg_openTime = openTime
          break
        end
      end
    end
    if not gvg_openTime then
      local config = startTimes[1]
      gvg_openTime = weekStartTime + 604800 + (((config.day - 1) * 24 + config.hour) * 60 + config.min) * 60
    end
  end
  local modify_endTime = GameConfig.GvgNewConfig.roadblock_modify_endtime or 0
  return curTime < gvg_openTime and curTime >= gvg_openTime - modify_endTime
end

function GvgProxy:UpdateMyGuildRoadBlock(roadBlock)
  self.myRoadBlock = roadBlock
end

function GvgProxy:GetMyGuildRoadBlock()
  return self.myRoadBlock
end

function GvgProxy:GetGvgFinalTimeStr()
  local startTimes = GameConfig.GVGConfig.start_time
  if not startTimes or #startTimes == 0 then
    return ""
  end
  local finalConfig
  for i = 1, #startTimes do
    if startTimes[i].super then
      finalConfig = startTimes[i]
      break
    end
  end
  if not finalConfig then
    return ""
  end
  local lastTime = GameConfig.GvgDroiyan and GameConfig.GvgDroiyan.LastTime or GameConfig.GVGConfig.last_time or 3600
  local lastTimeHours = math.floor(lastTime / 3600)
  local lastTimeMinutes = math.floor(lastTime % 3600 / 60)
  local endHour = finalConfig.hour + lastTimeHours
  local endMin = finalConfig.min + lastTimeMinutes
  if 60 <= endMin then
    endHour = endHour + 1
    endMin = endMin - 60
  end
  if 24 <= endHour then
    endHour = endHour - 24
  end
  local timeStr = string.format("%02d:%02d ~ %02d:%02d", finalConfig.hour, finalConfig.min, endHour, endMin)
  return timeStr
end

function GvgProxy:GetGvgTimeStr()
  local startTime = GameConfig.GVGConfig.start_time[1]
  local lastTime = GameConfig.GVGConfig.last_time
  local day = startTime.day
  local hour = startTime.hour
  local min = startTime.min or 0
  local totalMinutes = hour * 60 + min + math.floor(lastTime / 60)
  local endHour = math.floor(totalMinutes / 60) % 24
  local endMin = totalMinutes % 60
  local timeRangeStr = string.format("%02d:%02d ~ %02d:%02d", hour, min, endHour, endMin)
  return timeRangeStr
end
