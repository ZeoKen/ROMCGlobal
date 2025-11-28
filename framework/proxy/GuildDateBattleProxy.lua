local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _HashToArray = TableUtil.HashToArray
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GuildCmd_pb = GuildCmd_pb
local _EOpenState = {
  Ready = _GuildCmd_pb.EDATEBATTLE_OPEN_STATE_READY,
  Open = _GuildCmd_pb.EDATEBATTLE_OPEN_STATE_OPEN,
  Close = _GuildCmd_pb.EDATEBATTLE_OPEN_STATE_CLOSE
}
local _OpenState = {
  [_EOpenState.Ready] = 1,
  [_EOpenState.Open] = 1
}
local _DefaultMode = 1
E_GuildDateBattle_State = {
  OnMatch = 1,
  PreEnter = 2,
  UnderApproval_Me = 3,
  UnderApproval_Other = 4,
  Win = 5,
  Failed = 6,
  Refused = 7,
  Invalid = 8
}
E_GuildDateBattle_SortID = {
  Valid = 1,
  Approval = 2,
  InValid = 3,
  UnDefined = 4
}
local _Schedules = {begin_hour = 12, end_hour = 23}
EGuildDateBattleTip = {
  SecendStamp = 1,
  Clock = 2,
  Mode = 3
}
GuildDateBattleProxy = class("GuildDateBattleProxy", pm.Proxy)
GuildDateBattleProxy.Instance = nil
GuildDateBattleProxy.NAME = "GuildDateBattleProxy"
autoImport("GuildDateBattleRecordData")
autoImport("GuildDateBattleRankData")
autoImport("GuildDateBattleEntranceData")
autoImport("GuildDateBattleFlagData")
autoImport("GvgStatData")

function GuildDateBattleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GuildDateBattleProxy.NAME
  if GuildDateBattleProxy.Instance == nil then
    GuildDateBattleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

GuildDateBattleProxy.debug = true

function GuildDateBattleProxy:Debug(...)
  if GuildDateBattleProxy.debug then
    helplog(...)
  end
end

function GuildDateBattleProxyDebug(...)
  if GuildDateBattleProxy.debug then
    TableUtil.Print(...)
  end
end

local _mode_str

function GuildDateBattleProxy.GetModeName(mode)
  local mode_config = GuildDateBattleProxy.GetModeConfig()
  return mode_config[mode] and mode_config[mode].name or ""
end

function GuildDateBattleProxy.GetModeConfig()
  if not GuildDateBattleProxy.modeConfig then
    GuildDateBattleProxy.modeConfig = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.mode
  end
  return GuildDateBattleProxy.modeConfig
end

function GuildDateBattleProxy:GetMiniMapTextureName(mode)
  self.miniMapTextureName = self.miniMapTextureName or {}
  local texture_name = self.miniMapTextureName[mode]
  if not texture_name then
    local mode_config = GuildDateBattleProxy.GetModeConfig()
    local city_id = mode_config[mode] and mode_config[mode].city_id
    if city_id then
      local raid_id = Table_DateBattleCity[city_id] and Table_DateBattleCity[city_id].RaidId
      if raid_id then
        local raid_config = Table_MapRaid[raid_id]
        if raid_config then
          self.miniMapTextureName[mode] = "Scene" .. raid_config.NameEn
        end
      end
    end
  end
  return self.miniMapTextureName[mode] or ""
end

function GuildDateBattleProxy:CheckBaseModeOpen()
  local config = GuildDateBattleProxy.GetModeConfig()
  if config and config[2] and config[2].open == true then
    return true
  end
  return false
end

function GuildDateBattleProxy:InitProxy()
  self.myRecords = {}
  self.myRecordMap = {}
  self.finishedRecords = {}
  self.goingRecords = {}
  self.ranks = {}
  self.myGuildRank = nil
  self.dateStamp = {}
  self.invalidDateCache = {}
  self.myGuildInvalidDateMap = {}
  self.gameReport = {
    win = false,
    isOver = false,
    detail = {},
    enemyDetail = {}
  }
  self.currentDateCount = 0
  self.flagMap = {}
end

function GuildDateBattleProxy:ClearMyRecords()
  _TableClear(self.myRecordMap)
  _ArrayClear(self.myRecords)
  _TableClear(self.myGuildInvalidDateMap)
  self.currentDateCount = 0
  self.myRecordDirty = true
end

function GuildDateBattleProxy:UpdateRecords(datas, id)
  self:Debug("[公会约战] UpdateRecords datasCount id", #datas, id)
  local is_init = id and id == 0
  if is_init then
    self:ClearMyRecords()
  end
  if datas and 0 < #datas then
    for i = 1, #datas do
      self:SetRecord(datas[i])
    end
    self.myRecordDirty = true
  end
  local isSingleUpdate = id and 0 < id
  if isSingleUpdate and #datas == 1 then
    local record = self:GetRecordById(datas[1].id)
    self:OpenViewByState(record)
  end
end

function GuildDateBattleProxy:OpenViewByState(record)
  if record:IsOnMatch() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildDateBattleEntranceView
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildDateBattleInviteView,
      viewdata = {data = record}
    })
  end
end

function GuildDateBattleProxy:SetRecord(server_data)
  GuildDateBattleProxyDebug(server_data)
  local record = self:GetRecordById(server_data.id)
  if not record then
    record = self:AddRecored(server_data)
  else
    record:Update(server_data)
  end
  if record:IsInvalidStamp() then
    self.myGuildInvalidDateMap[record.stamp] = 1
  else
    self.myGuildInvalidDateMap[record.stamp] = nil
  end
  return record
end

function GuildDateBattleProxy:AddRecored(server_data)
  local data = GuildDateBattleRecordData.new(server_data)
  self.myRecordMap[data.id] = data
  if data:MatchCurrentDay() then
    self.currentDateCount = self.currentDateCount + 1
  end
  return data
end

function GuildDateBattleProxy:SetCurDate(stamp)
  self.curYear = tonumber(os.date("%Y", stamp))
  self.curMonth = tonumber(os.date("%m", stamp))
  self.curDay = tonumber(os.date("%d", stamp))
end

function GuildDateBattleProxy:SetCurClock(h)
  self.curHour = h
end

function GuildDateBattleProxy:SetCurMode(m)
  self.curMode = m
end

function GuildDateBattleProxy:ClearCacheDate()
  self.curYear = nil
  self.curMonth = nil
  self.curDay = nil
  self.curHour = nil
  self.curMode = nil
end

function GuildDateBattleProxy:GetDate()
  return self.curYear, self.curMonth, self.curDay, self.curHour
end

function GuildDateBattleProxy:CheckClockInValid(clock)
  if nil == self.curYear then
    local date_clock_num = 0
    for id, record in pairs(self.myRecordMap) do
      if record:IsInvalidStamp() and record:GetClock() == clock then
        date_clock_num = date_clock_num + 1
      end
    end
    local max = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.date_range
    return date_clock_num >= max
  else
    local stamp = os.time({
      year = self.curYear,
      month = self.curMonth,
      day = self.curDay,
      hour = clock,
      min = 0,
      sec = 0
    })
    if GuildDateBattleProxy.CheckStampExpire(stamp) then
      return true
    end
    if self:_checkTargetGuildDateInvalid(stamp) then
      return true
    end
    if self:_checkMyGuildDateInvalid(stamp) then
      return true
    end
    return false
  end
end

function GuildDateBattleProxy.CheckStampExpire(stamp)
  local curServerTime = ServerTime.CurServerTime() / 1000
  if stamp <= curServerTime then
    return true
  end
  local last_approval_time = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.last_approval_time or 600
  if last_approval_time > stamp - curServerTime then
    return true
  end
end

function GuildDateBattleProxy:CheckDateInvalid(date)
  if nil ~= self.curHour then
    local stamp = date + self.curHour * 3600
    if GuildDateBattleProxy.CheckStampExpire(stamp) then
      return true
    end
    if self:_checkMyGuildDateInvalid(stamp) then
      return true
    end
    if self:_checkTargetGuildDateInvalid(stamp) then
      return true
    end
  else
    local schedule = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.schedule
    local max = schedule and schedule.end_hour - schedule.begin_hour + 1 or 12
    local target_date_count, my_guild_date_count = 0, 0
    for i = schedule.begin_hour, schedule.end_hour do
      local stamp = date + i * 3600
      if self:_checkTargetGuildDateInvalid(stamp) then
        target_date_count = target_date_count + 1
      end
      if self:_checkMyGuildDateInvalid(stamp) then
        my_guild_date_count = my_guild_date_count + 1
      end
    end
    if max <= target_date_count then
      return true
    end
    if max <= my_guild_date_count then
      return true
    end
  end
end

function GuildDateBattleProxy:GetRecordById(id)
  return self.myRecordMap[id]
end

function GuildDateBattleProxy:SetClientRefused(id)
  local cacheData = self:GetRecordById(id)
  cacheData.state = E_GuildDateBattle_State.Refused
  GameFacade.Instance:sendNotification(GuildEvent.GuildBattleClientRefused)
end

function GuildDateBattleProxy:GetRecordByData(match_data)
  if not self.myRecordMap then
    return
  end
  if not match_data then
    return
  end
  local id = match_data.id
  if id and 0 < id then
    return self:GetRecordById(id)
  end
  for k, v in pairs(self.myRecordMap) do
    if v.stamp == match_data.stamp and v.defGuildid == match_data.defGuildid and v.atkGuildid == match_data.atkGuildid and v:IsUnderApproval() then
      return v
    end
  end
end

function GuildDateBattleProxy:HasApproveData(stamp)
  for k, v in pairs(self.myRecordMap) do
    if v.osStamp == stamp and v:IsUnderApproval_Me() then
      return true
    end
  end
  return false
end

function GuildDateBattleProxy:IsDated(id)
  return nil ~= self.myRecordMap[id]
end

function GuildDateBattleProxy:ClearTargetInvalidDateMap()
  _TableClear(self.invalidDateCache)
end

function GuildDateBattleProxy:_checkMyGuildDateInvalid(stamp)
  local curServerTime = ServerTime.CurServerTime() / 1000
  if stamp < curServerTime then
    return true
  end
  if nil == next(self.myGuildInvalidDateMap) then
    return false
  end
  return nil ~= self.myGuildInvalidDateMap[stamp]
end

function GuildDateBattleProxy:_checkTargetGuildDateInvalid(stamp)
  local curServerTime = ServerTime.CurServerTime() / 1000
  if stamp < curServerTime then
    return true
  end
  if nil == next(self.invalidDateCache) then
    return false
  end
  return nil ~= self.invalidDateCache[stamp]
end

function GuildDateBattleProxy:QueryBattleInfo(id)
  ServiceGuildCmdProxy.Instance:CallDateBattleInfoGuildCmd(id)
end

function GuildDateBattleProxy:QueryTargetGuild(guild_id)
  self:ClearTargetInvalidDateMap()
  ServiceGuildCmdProxy.Instance:CallDateBattleTargetGuildCmd(guild_id)
end

function GuildDateBattleProxy:HandleTargetGuildDateData(guild_id, datas)
  self:Debug("[公会约战] RecvDateBattleTargetGuildCmd guild_id|datas count ", guild_id, #datas)
  GuildDateBattleProxyDebug(datas)
  for i = 1, #datas do
    local record = GuildDateBattleRecordData.new(datas[i], guild_id)
    if record and record:IsInvalidStamp() then
      local stamp = record:GetStamp()
      self.invalidDateCache[stamp] = 1
    end
  end
end

function GuildDateBattleProxy:HandleGuildDateReportDetail(serverData)
  self:Debug("DateBattleDetailGuildCmd")
  GuildDateBattleProxyDebug(serverData)
  local my_guild = GuildProxy.Instance:GetOwnGuildID()
  self.gameReport.win = serverData.winner_guildid == my_guild
  self.gameReport.isOver = serverData.isover
  _ArrayClear(self.gameReport.detail)
  _ArrayClear(self.gameReport.enemyDetail)
  self.gameReport.mydata = nil
  local reports = serverData.reports
  if not reports then
    return
  end
  local server_guild_id
  for i = 1, #reports do
    server_guild_id = reports[i].guildid
    local starStats = {}
    for _, sData in ipairs(reports[i].datas) do
      local statData = GvgStatData.new()
      statData:SetServerData(sData)
      for _, key in pairs(GvgStatData.SortableKeys) do
        local maxStat = starStats[key]
        if not maxStat then
          if statData[key] and 0 < statData[key] then
            statData:SetStar(key, true)
            starStats[key] = statData
          else
            statData:SetStar(key, false)
          end
        elseif statData[key] and statData[key] >= maxStat[key] then
          maxStat:SetStar(key, false)
          statData:SetStar(key, true)
          starStats[key] = statData
        end
      end
      if server_guild_id == my_guild then
        _ArrayPushBack(self.gameReport.detail, statData)
        if statData:IsMySelf() then
          self.gameReport.mydata = statData
        end
      else
        _ArrayPushBack(self.gameReport.enemyDetail, statData)
      end
    end
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GuildDateBattlefieldReport
  })
end

function GuildDateBattleProxy:SortResultByKey(key, asc, isMyGuild)
  local cacheData = isMyGuild and self.gameReport.detail or self.gameReport.enemyDetail
  if not cacheData then
    return
  end
  table.sort(cacheData, function(a, b)
    if asc then
      return a[key] and b[key] and a[key] < b[key]
    else
      return a[key] and b[key] and a[key] > b[key]
    end
  end)
end

function GuildDateBattleProxy:TryQueryRank()
  local refresh_time = ClientTimeUtil.GetCurrentDaily5ClockTime()
  if nil == self.rankCacheTime or refresh_time > self.rankCacheTime then
    self.rankCacheTime = refresh_time
    ServiceGuildCmdProxy.Instance:CallDateBattleRankGuildCmd()
    self:Debug("[公会约战] 客户端请求30天排行榜")
  end
end

function GuildDateBattleProxy:HandleQueryRank(ranks, my_rank)
  self:Debug("[公会约战] RecvDateBattleListGuildCmd rank count", #ranks)
  GuildDateBattleProxyDebug(ranks)
  GuildDateBattleProxyDebug(my_rank)
  if not ranks then
    return
  end
  _ArrayClear(self.ranks)
  self.myGuildRank = GuildDateBattleRankData.new(my_rank)
  for i = 1, #ranks do
    local rank_data = GuildDateBattleRankData.new(ranks[i], i)
    _ArrayPushBack(self.ranks, rank_data)
  end
  self:SetClientRank()
end

function GuildDateBattleProxy:SetClientRank()
  local pre_winTime, display_rank
  for i = 1, #self.ranks do
    pre_winTime = self.ranks[i - 1] and self.ranks[i - 1].wintimes
    if pre_winTime and pre_winTime == self.ranks[i].wintimes then
      display_rank = self.ranks[i - 1]:GetRank()
    else
      display_rank = i
    end
    self.ranks[i]:SetRank(display_rank)
    if self.ranks[i]:IsMyself() then
      self.myGuildRank:SetRank(display_rank)
    end
  end
end

local _queryInterval = 1

function GuildDateBattleProxy:TryQueryDateBattleRecords(type, force)
  if force or nil == self.queryAllRecordTime or UnityRealtimeSinceStartup - self.queryAllRecordTime > _queryInterval then
    self.queryAllRecordTime = UnityRealtimeSinceStartup
    ServiceGuildCmdProxy.Instance:CallDateBattleListGuildCmd(type)
    self:Debug("NewGVG 客户端请求公会约战总览 type", type)
  end
end

local sort_function = function(a, b)
  return a.stamp > b.stamp
end

function GuildDateBattleProxy:HandleQueryAllRecords(datas, type)
  self:Debug("[公会约战] RecvDateBattleListGuildCmd", #datas, type)
  if not datas then
    return
  end
  local only_show_same_server = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.only_show_same_server == true
  local is_end = type == GuildCmd_pb.EGUILDDATEBATTLELISTTYPE_END
  local cacheData = is_end and self.finishedRecords or self.goingRecords
  local insertValid
  _ArrayClear(cacheData)
  for i = 1, #datas do
    GuildDateBattleProxyDebug(datas[i])
    local data = GuildDateBattleRecordData.new(datas[i])
    if only_show_same_server then
      if MyselfProxy.Instance:IsSameServer(data:GetServerId()) then
        _ArrayPushBack(cacheData, data)
      end
    else
      _ArrayPushBack(cacheData, data)
    end
  end
  table.sort(cacheData, sort_function)
end

function GuildDateBattleProxy:HandleRedtip(server_data)
  self:Debug("[公会约战] 接收红点 RecvRedtipOptGuildCmd redtips count ", #server_data.redtips)
  GuildDateBattleProxyDebug(server_data.redtips)
  RedTipProxy.Instance:UpdateRedTipsByServer(server_data.redtips)
end

function GuildDateBattleProxy:BrowseRedtip(tipid, sub_tipid)
  self:Debug("[公会约战] 浏览红点 tipid|sub_tipid", tipid, sub_tipid)
  RedTipProxy.Instance:SeenNew(tipid, sub_tipid, true)
end

local BaseFlagId = 1000

function GuildDateBattleProxy:HandleDateBattleFlag(server_data)
  self:Debug("[公会约战] 接收红点 HandleDateBattleFlag")
  GuildDateBattleProxyDebug(server_data)
  local map_id = server_data.mapid
  local map = self.flagMap[map_id]
  if not map then
    map = {}
    self.flagMap[map_id] = map
  end
  local datas = server_data.datas
  for i = 1, #datas do
    local data = GuildDateBattleFlagData.new(i, datas[i])
    local flag_guid = BaseFlagId + data.id
    FunctionGuild.Me():SetGuildLandIcon(flag_guid, data.portrait, data.guildId)
    map[flag_guid] = data
  end
end

function GuildDateBattleProxy:GetFlagData(map_id, guid)
  local map = self.flagMap[map_id]
  if map then
    return map[guid]
  end
end

function GuildDateBattleProxy:CallInvite(guild_id, ban_cards, game_mode, target_num)
  if not GuildProxy.Instance:ImGuildChairman() then
    return
  end
  if not self.curYear or not self.curHour then
    return
  end
  local stamp = os.time({
    year = self.curYear,
    month = self.curMonth,
    day = self.curDay,
    hour = self.curHour,
    min = 0,
    sec = 0
  })
  if not self:HasApproveData(stamp) then
    self:CallDateInvite(guild_id, stamp, self.curMode, game_mode, target_num, ban_cards)
  else
    MsgManager.ConfirmMsgByID(43551, function()
      self:CallDateInvite(guild_id, stamp, self.curMode, game_mode, target_num, ban_cards)
    end, nil, nil)
  end
end

function GuildDateBattleProxy:CallDateInvite(guild_id, stamp, mode, game_mode, target_num, ban_cards)
  mode = mode or 1
  stamp = math.floor(stamp)
  self:Debug("[公会约战] 发起邀请CallDateBattleInviteGuildCmd guild_id | stamp | mode | game_mode | target_num ", guild_id, stamp, mode, game_mode, target_num)
  local info = ReusableTable.CreateTable()
  info.type = game_mode or _DefaultMode
  info.target_num = target_num or 0
  info.cardids = ban_cards
  ServiceGuildCmdProxy.Instance:CallDateBattleInviteGuildCmd(guild_id, stamp, mode, nil, info)
  ReusableTable.DestroyAndClearTable(info)
  MsgManager.ShowMsgByID(43557)
end

function GuildDateBattleProxy:CallAgreeInvite(id)
  if not GuildProxy.Instance:ImGuildChairman() then
    return
  end
  if not self:HasApproveData(stamp) then
    ServiceGuildCmdProxy.Instance:CallDateBattleReplyGuildCmd(id, true)
  else
    MsgManager.ConfirmMsgByID(43549, function()
      ServiceGuildCmdProxy.Instance:CallDateBattleReplyGuildCmd(id, true)
    end, nil, nil)
  end
end

function GuildDateBattleProxy:CallRefuseInvite(id, guild_name)
  if not GuildProxy.Instance:ImGuildChairman() then
    return
  end
  MsgManager.ConfirmMsgByID(43588, function()
    ServiceGuildCmdProxy.Instance:CallDateBattleReplyGuildCmd(id, false)
    MsgManager.ShowMsgByID(43559, guild_name)
  end, nil, nil, guild_name)
end

function GuildDateBattleProxy:HandleSetEntranceData(server_data)
  self:Debug("公会约战简报 RecvDateBattleReportGuildCmd")
  GuildDateBattleProxyDebug(server_data)
  if not self.entranceData then
    self:Debug("公会约战 后端同步简报协议DateBattleReportGuildCmd时未开放约战入口->DateBattleOpenGuildCmd")
    return
  end
  self.entranceData:SetEntrance(server_data)
end

function GuildDateBattleProxy:HandleDateBattleOpen(server_data)
  self:Debug("公会约战入口 RecvDateBattleOpenGuildCmd state ", server_data.state)
  GuildDateBattleProxyDebug(server_data)
  self.state = server_data.state
  if nil ~= _OpenState[server_data.state] then
    self.entranceData = GuildDateBattleEntranceData.new(server_data.data)
    ServiceGuildCmdProxy.Instance:CallDateBattleReportGuildCmd()
  else
    self.entranceData = nil
  end
end

function GuildDateBattleProxy:HandleGvgDateBattleInfoSync(server_data)
  self:Debug("公会战-约战模式相关信息 RecvGvgDateBattleInfoSyncCmd")
  GuildDateBattleProxyDebug(server_data)
  self.raid_battle_type = server_data.battle_type
  self.raid_death_count = server_data.death_info.death_count
  self.raid_death_limit = server_data.death_info.death_limit
  self.raid_blood_atk_kill_count = server_data.blood_info.atk_kill_count
  self.raid_blood_def_kill_count = server_data.blood_info.def_kill_count
  self.raid_blood_kill_target = server_data.blood_info.kill_target
end

function GuildDateBattleProxy:IsInPreview()
  return self.state == _EOpenState.Ready
end

function GuildDateBattleProxy:IsOpen()
  return self.state == _EOpenState.Open
end

function GuildDateBattleProxy:NeedShow()
  return self:IsOpen() or self:IsInPreview()
end

function GuildDateBattleProxy:GetEndTime()
  if self.entranceData then
    return self.entranceData:GetEndTime()
  end
end

function GuildDateBattleProxy:GetStartTime()
  if self.entranceData then
    return self.entranceData:GetBattleStartTime()
  end
end

function GuildDateBattleProxy:GetEntranceId()
  if self.entranceData then
    return self.entranceData:GetId()
  end
end

function GuildDateBattleProxy:TryOpenEntrance()
  if self:IsInPreview() then
    local record_data = self:GetEntranceRecordData()
    if record_data then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GuildDateBattlePreEnterView,
        viewdata = {data = record_data}
      })
    end
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildDateBattleEntranceView
    })
  end
end

function GuildDateBattleProxy:GetEntranceRecordData()
  if self.entranceData then
    return self.entranceData:GetRecordData()
  end
end

function GuildDateBattleProxy:EnterBattleMap(id)
  self:Debug("[公会约战] 进入战场CallDateBattleEnterGuildCmd", id)
  ServiceGuildCmdProxy.Instance:CallDateBattleEnterGuildCmd(id)
end

local SortMyRecordFunc = function(a, b)
  if a.sortID == b.sortID then
    if a.sortID == E_GuildDateBattle_SortID.InValid then
      return a.stamp > b.stamp
    else
      return a.stamp < b.stamp
    end
  else
    return a.sortID < b.sortID
  end
end

function GuildDateBattleProxy:GetRecords()
  if self.myRecordDirty then
    self.myRecordDirty = false
    _ArrayClear(self.myRecords)
    _HashToArray(self.myRecordMap, self.myRecords)
    table.sort(self.myRecords, SortMyRecordFunc)
  end
  return self.myRecords
end

function GuildDateBattleProxy:GetFinishedRecords()
  return self.finishedRecords
end

function GuildDateBattleProxy:GetGoingRecords()
  return self.goingRecords
end

function GuildDateBattleProxy:GetRanks()
  return self.ranks
end

function GuildDateBattleProxy:GetMyGuildRankData()
  return self.myGuildRank
end

function GuildDateBattleProxy:GetEntranceData()
  return self.entranceData
end

function GuildDateBattleProxy.GetStaticSchedule()
  if not GuildDateBattleProxy.static_schedule then
    GuildDateBattleProxy.static_schedule = {}
    local config = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.schedule or _Schedules
    local _begin, _end = config.begin_hour, config.end_hour
    for i = _begin, _end do
      _ArrayPushBack(GuildDateBattleProxy.static_schedule, {
        [1] = EGuildDateBattleTip.Clock,
        [2] = i
      })
    end
  end
  return GuildDateBattleProxy.static_schedule
end

local day_sec = 86400

function GuildDateBattleProxy:GetStampData()
  _ArrayClear(self.dateStamp)
  local curTime = ServerTime.CurServerTime() / 1000
  local curDate = os.date("*t", curTime)
  local baseTime = os.time({
    year = curDate.year,
    month = curDate.month,
    day = curDate.day,
    hour = 0,
    min = 0,
    sec = 0
  })
  local lastTime = os.time({
    year = curDate.year,
    month = curDate.month,
    day = curDate.day,
    hour = 22,
    min = 50,
    sec = 0
  })
  if curTime > lastTime then
    baseTime = baseTime + day_sec
  end
  _ArrayPushBack(self.dateStamp, {
    [1] = EGuildDateBattleTip.SecendStamp,
    [2] = baseTime
  })
  local date_range = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.date_range or 7
  date_range = date_range - 1
  for i = 1, date_range do
    _ArrayPushBack(self.dateStamp, {
      [1] = EGuildDateBattleTip.SecendStamp,
      [2] = baseTime + i * day_sec
    })
  end
  return self.dateStamp
end

function GuildDateBattleProxy:GetModeTipData()
  if not self.modeTipData then
    self.modeTipData = {}
    local mode_config = GuildDateBattleProxy.GetModeConfig()
    for mode, _ in pairs(mode_config) do
      _ArrayPushBack(self.modeTipData, {
        [1] = EGuildDateBattleTip.Mode,
        [2] = mode
      })
    end
  end
  return self.modeTipData
end

function GuildDateBattleProxy:GetReportDetail(use_myguild)
  return use_myguild and self.gameReport.detail or self.gameReport.enemyDetail
end

function GuildDateBattleProxy:GetReportMyself()
  return self.gameReport.mydata
end

function GuildDateBattleProxy:IsReportWin()
  return self.gameReport.win
end

function GuildDateBattleProxy:IsReportOver()
  return self.gameReport.isOver
end

function GuildDateBattleProxy:GetCurDateCount()
  return self.currentDateCount
end
