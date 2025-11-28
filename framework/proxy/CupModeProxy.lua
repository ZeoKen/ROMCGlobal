autoImport("WarbandOpponentTeamData")
CupModeProxy = class("CupModeProxy", pm.Proxy)
local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _CreateTable = ReusableTable.CreateTable
local _DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local time_format = "%Y-%m-%d %H:%M:%S"
local p = "(%d+):(%d+):(%d+)"
local DAY_SECOND, HOUR_SECOND, MINSCEOND = 86400, 3600, 60

function CupModeProxy.FightTimeDescByRefreshTime(t)
  local day, hour, min = ClientTimeUtil.GetFormatRefreshTimeStr(t)
  if 0 < day then
    return string.format(ZhString.Warband_FightCD_DayTime, day)
  elseif 0 < hour then
    return string.format(ZhString.Warband_FightCD_Hour_Time, hour)
  elseif 0 < min then
    return string.format(ZhString.Warband_FightCD_Min_Time, min)
  else
    return ZhString.Warband_FightCD_Sec_Time
  end
end

function CupModeProxy.CupModeStartTimeLeft(t)
  local day, hour, min = ClientTimeUtil.GetFormatRefreshTimeStr(t)
  if 0 < day then
    return string.format(ZhString.Warband_Tab_DayTimeLeft, day)
  elseif 0 < hour then
    return string.format(ZhString.Warband_Tab_HourTimeLeft, hour)
  elseif 0 < min then
    return string.format(ZhString.Warband_Tab_MinTimeLeft, min)
  else
    return ZhString.Warband_Tab_SecTimeLeft
  end
end

function CupModeProxy:ctor(proxyName, data)
  self.proxyName = proxyName
  if data ~= nil then
    self:setData(data)
  end
  self.myWarband = nil
  self.myWarbandId = -1
  self.warbandMap = {}
  self.warbandList = {}
  self.opponentGroup = {}
  self.preRoundOpponentGroup = {}
  self.opponentPlayoff = {}
  self.ESchedule = WarbandProxy.ESchedule.NoOpen
  self.opponentCount = {}
  self.preRoundOpponentCount = {}
  self.effectMap = {}
  self.effectList = {}
  self.seasonReward = {}
  self.opponentStatus = false
  self.calSeasonTime = {}
  self.forbiddenProMap = {}
  self.forbiddenPro = {}
  self.Fixed_SingleGroupNum = 8
  self.curStage = 0
end

function CupModeProxy:OnDestroy()
end

function CupModeProxy:GetSignupWarbandList()
  if not self.warbandMap then
    return
  end
  _ArrayClear(self.warbandList)
  for _, v in pairs(self.warbandMap) do
    self.warbandList[#self.warbandList + 1] = v
  end
  table.sort(self.warbandList, function(a, b)
    return a.rank < b.rank
  end)
  return self.warbandList
end

function CupModeProxy:GetOpponentServerList()
  return self.opponentServerList or {}
end

function CupModeProxy:GetGroupTabData()
  local data = {}
  local cell = {}
  for i = 1, #self.opponentGroup do
    cell = {index = i, isPlayoff = false}
    data[#data + 1] = cell
  end
  return data
end

function CupModeProxy:GetPreRoundGroupTabData()
  local data = {}
  local cell = {}
  for i = 1, #self.preRoundOpponentGroup do
    cell = {index = i, isPlayoff = false}
    data[#data + 1] = cell
  end
  return data
end

function CupModeProxy:GetFinalRoundGroupTabData()
  local data = {}
  local cell = {}
  if self.opponentPlayoff and #self.opponentPlayoff > 0 then
    cell = {
      index = #data + 1,
      isPlayoff = true
    }
    data[#data + 1] = cell
  elseif 0 < self.curStage and self.curStage < 4 then
    cell = {index = 1, isPlayoff = true}
    data[#data + 1] = cell
  end
  return data
end

function CupModeProxy:GetOpponentData(tab)
  if tab.isPlayoff then
    return self.opponentPlayoff or {}
  else
    return self.opponentGroup[tab.index]
  end
end

function CupModeProxy:GetPreRoundOpponentData(tab)
  if tab.isPlayoff then
    return self.opponentPlayoff or {}
  else
    return self.preRoundOpponentGroup[tab.index]
  end
end

function CupModeProxy:GetFinalRoundOpponentData()
  if TableUtil.TableIsEmpty(self.opponentPlayoff) and self.curStage > 0 and self.curStage < 4 then
    local playoffData = {}
    for i = 1, self.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      playoffData[i] = WarbandOpponentTeamData.new(cellData, self)
    end
    self.opponentPlayoff = playoffData
  end
  return self.opponentPlayoff or {}
end

function CupModeProxy:GetMyWarbandViewMember()
  return self.myWarband and self.myWarband:GetViewMembers() or {}
end

function CupModeProxy:GetWarbandMembers(id)
  local band = self.warbandMap[id]
  if band then
    return band:GetMembers()
  end
end

function CupModeProxy:GetTeamScore()
  if self.myWarband then
    return self.myWarband:GetTeamScore()
  end
  return 0
end

function CupModeProxy:GetOpponentCount()
  local result = 0
  for k, v in pairs(self.opponentCount) do
    result = result + 1
  end
  return result
end

function CupModeProxy:GetPreRoundOpponentCount()
  local result = 0
  for k, v in pairs(self.preRoundOpponentCount) do
    result = result + 1
  end
  return result
end

function CupModeProxy:GetSessionRank()
  return self.seasonRank or {}
end

function CupModeProxy:UpdateTeamMember(updates, dels)
  if not self.myWarband then
    return
  end
  self.myWarband:SetMembers(updates)
  self.myWarband:RemoveMembers(dels)
end

function CupModeProxy:ExitMyband()
  if self.myWarband then
    self.myWarband:Exit()
    self.myWarband = nil
  end
end

function CupModeProxy:ClearMemberMap()
  _TableClear(self.warbandMap)
end

function CupModeProxy:ShutDown()
  redlog("[cup] CupModeProxy:ShutDown", UnityFrameCount)
  self:ExitMyband()
  self.myWarbandId = -1
  self.champtionBand = nil
  _ArrayClear(self.opponentPlayoff)
  _ArrayClear(self.warbandList)
  _TableClear(self.opponentGroup)
  _TableClear(self.preRoundOpponentGroup)
  self:_resetForbiddenPro()
  self:ClearMemberMap()
  if self.seasonRunning then
    self:DoQuerySeasonRank()
  end
  self.seasonRunning = false
  self:SetSchedule(WarbandProxy.ESchedule.END)
end

function CupModeProxy:IHaveWarband()
  return nil ~= self.myWarband and self.myWarband.id ~= 0
end

function CupModeProxy:CheckInMyBand(guid)
  if self:IHaveWarband() then
    return nil ~= self.myWarband:GetMemberByGuid(guid)
  end
  return false
end

function CupModeProxy:CheckAllReady()
  if self.myWarband then
    return self.myWarband:CheckAllReady()
  end
  return true
end

function CupModeProxy:CheckHasInvalidPro()
  local _TeamProxy = TeamProxy.Instance
  if _TeamProxy:IHaveTeam() then
    local list = _TeamProxy.myTeam:GetMembersList()
    for i = 1, #list do
      if self:CheckProInvalid(list[i].profession) then
        return true
      end
    end
  end
  return false
end

function CupModeProxy:CheckHasSignup()
  if self.myWarband then
    return self.myWarband:IsSignUp()
  end
end

function CupModeProxy:CheckBandAuthority()
  if not self:IHaveWarband() then
    return false
  end
  local my = Game.Myself.data and Game.Myself.data.id
  if not my then
    return false
  end
  local md = self.myWarband:GetMemberByGuid(my)
  return nil ~= md and md.isCaptial == true
end

function CupModeProxy:CheckImReady()
  local my = Game.Myself.data and Game.Myself.data.id
  if not my or not self:IHaveWarband() then
    return false
  end
  local md = self.myWarband:GetMemberByGuid(my)
  return nil ~= md and md.prepare == true
end

function CupModeProxy:CheckFull()
  if self.myWarband then
    return self.myWarband:IsFull()
  end
  return false
end

function CupModeProxy:CheckInPreParticipants()
  local opponentData = self.preRoundOpponentGroup
  if not opponentData then
    return 0
  end
  for _group, _teams in pairs(opponentData) do
    for _index, _teamData in pairs(_teams) do
      if _teamData.id == self.myWarbandId then
        return _group
      end
    end
  end
  return 0
end

function CupModeProxy:CheckInParticipants()
  local opponentData = self.opponentGroup
  if not opponentData then
    return 0
  end
  for _group, _teams in pairs(opponentData) do
    for _index, _teamData in pairs(_teams) do
      if _teamData.id == self.myWarbandId then
        return _group
      end
    end
  end
  return 0
end

function CupModeProxy:CheckInFinal()
  local finalGroup = self.opponentPlayoff
  if not finalGroup then
    return 0
  end
  for _index, _teamData in pairs(finalGroup) do
    if _teamData.id == self.myWarbandId then
      return _index
    end
  end
  return 0
end

function CupModeProxy:ProcessRewardBySeason(season)
  assert(false, "每个赛事的奖励配置格式可能不同，请在实现类中处理")
end

function CupModeProxy:IsCurSeasonRunning()
  return self.seasonRunning == true
end

function CupModeProxy:GetCurSeasonReward()
  return self.curSeason and self.seasonReward[self.curSeason] or {}
end

function CupModeProxy:GetFightCDTime()
  local curTime = ServerTime.CurServerTime() / 1000
  local refreshTime
  if self.curStage == 1 then
    if curTime < self.preNextFightTime then
      refreshTime = self.preNextFightTime
    else
      local stage = math.ceil((curTime - self.preNextFightTime) / self.figthInterval)
      refreshTime = stage * self.figthInterval + self.preNextFightTime
    end
  elseif curTime < self.nextFightTime then
    refreshTime = self.nextFightTime
  else
    local stage = math.ceil((curTime - self.nextFightTime) / self.figthInterval)
    refreshTime = stage * self.figthInterval + self.nextFightTime
  end
  return CupModeProxy.FightTimeDescByRefreshTime(refreshTime)
end

function CupModeProxy:CheckMatchTimeValid()
  if self.curStage == 1 then
    if self.preCanMatchTime then
      local curTime = ServerTime.CurServerTime() / 1000
      return curTime > self.preCanMatchTime
    end
  else
    local preCount = self:GetPreRoundOpponentCount()
    if 0 < preCount then
      return true
    elseif self.canMatchTime then
      local curTime = ServerTime.CurServerTime() / 1000
      return curTime > self.canMatchTime
    end
  end
  return false
end

function CupModeProxy:IsWarbandInBreakTime()
  local curTime = ServerTime.CurServerTime() / 1000
  if self.breakStartTime and self.breakEndTime then
    return curTime > self.breakStartTime and curTime < self.breakEndTime
  end
  return false
end

function CupModeProxy:CheckSignupTimeValid()
  if self.signupStartTime and self.signupEndTime then
    local curTime = ServerTime.CurServerTime() / 1000
    return curTime >= self.signupStartTime and curTime <= self.signupEndTime
  end
  return false
end

function CupModeProxy:SetSchedule(status)
  if status ~= self.ESchedule then
    self.ESchedule = status
    GameFacade.Instance:sendNotification(CupModeEvent.ScheduleChanged_6v6)
  end
  if status == WarbandProxy.ESchedule.FIGHTING then
    GameFacade.Instance:sendNotification(CupModeEvent.Fighting_6v6)
  end
end

function CupModeProxy:TryUpdateScheduleStatus()
  if nil == self.seasonRunning then
    self:SetSchedule(WarbandProxy.ESchedule.NoOpen)
  elseif self.seasonRunning then
    local curTime = ServerTime.CurServerTime() / 1000
    if curTime < self.warbandStartTime then
      self:SetSchedule(WarbandProxy.ESchedule.SIGN_UP_PENDING)
    elseif curTime <= self.signupEndTime then
      self:SetSchedule(WarbandProxy.ESchedule.SIGN_UP)
    elseif curTime <= self.fightStartTime then
      self:SetSchedule(WarbandProxy.ESchedule.FIGHT_PENDING)
    else
      self:SetSchedule(WarbandProxy.ESchedule.FIGHTING)
    end
  else
    self:SetSchedule(WarbandProxy.ESchedule.END)
  end
end

function CupModeProxy:IsSeasonNoOpen()
  return WarbandProxy.ESchedule.NoOpen == self.ESchedule
end

function CupModeProxy:IsSeasonEnd()
  return WarbandProxy.ESchedule.END == self.ESchedule
end

function CupModeProxy:IsSigthupPending()
  return WarbandProxy.ESchedule.SIGN_UP_PENDING == self.ESchedule
end

function CupModeProxy:IsInSignupTime()
  return WarbandProxy.ESchedule.SIGN_UP == self.ESchedule
end

function CupModeProxy:IsFighting()
  return WarbandProxy.ESchedule.FIGHTING == self.ESchedule
end

function CupModeProxy:IsFightingPending()
  return WarbandProxy.ESchedule.FIGHT_PENDING == self.ESchedule
end

function CupModeProxy:GetWarbandLimitedLv()
  assert(self.RequireLv, "必须在实现类中给RequireLv赋值")
  return self.RequireLv
end

function CupModeProxy:CheckMatchValid()
  assert(self.MinMatchNum, "必须在实现类中给MinMatchNum赋值")
  local teamProxy = TeamProxy.Instance
  if not teamProxy:CheckImTheLeader() then
    MsgManager.ShowMsgByID(28086)
    return
  end
  if teamProxy:HasOfflineMember() then
    MsgManager.ShowMsgByID(25903)
    return
  end
  local minMatchNum = self.MinMatchNum
  if not minMatchNum then
    redlog("参与匹配最低人数minMatchNum未配")
    return
  end
  if minMatchNum > TeamProxy.Instance:GetMyTeamMemberCount() then
    MsgManager.ShowMsgByID(28063, minMatchNum)
    return
  end
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return
  end
  local enterLv = self:GetWarbandLimitedLv()
  if not enterLv then
    redlog("创建战队等级限制未找到")
    return
  end
  local mydata = Game.Myself.data
  local mylv = mydata.userdata:Get(UDEnum.ROLELEVEL)
  if enterLv > mylv then
    MsgManager.ShowMsgByID(28071, enterLv)
    return
  end
  if not self.myWarband:CheckMatchValid(enterLv) then
    return
  end
  return true
end

function CupModeProxy:GetLastSeasonRank()
  if self.seasonRank and #self.seasonRank > 0 then
    return self.seasonRank[#self.seasonRank]
  end
end

function CupModeProxy:GetLastSeasonRankByRank(rank)
  local result = rank == 3 and {} or nil
  local data = self:GetLastSeasonRank()
  if data then
    for i = 1, #data do
      if data[i].rank == rank then
        if rank == 3 then
          result[#result + 1] = data[i]
        else
          return data[i]
        end
      end
    end
  end
  return result
end

function CupModeProxy:GetMyWarbandID()
  return self.myWarbandId
end

function CupModeProxy:GetMyWarbandName()
  local name = self.myWarband and self.myWarband.name or ""
  local suffix = GameConfig.TeamSeasonTime and GameConfig.TeamSeasonTime.WarbandSuffixName or "的战队"
  name = name:gsub(suffix, OverSea.LangManager.Instance():GetLangByKey(suffix))
  return name
end

function CupModeProxy:GetCurStage()
  return self.curStage
end

function CupModeProxy:CheckIsFinalRound()
  for _, v in pairs(self.opponentPlayoff) do
    if v.wintimes >= 2 then
      return true
    end
  end
  return false
end

local ChamptionWinTime = 3

function CupModeProxy:HandleTreeBandData(data)
  _TableClear(self.opponentCount)
  local playoffTeamInfo = data.championteaminfo and data.championteaminfo.groupteaminfo
  if not playoffTeamInfo then
    _ArrayClear(self.opponentPlayoff)
    local playoffData = {}
    for i = 1, self.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      playoffData[i] = WarbandOpponentTeamData.new(cellData, self)
    end
    self.opponentPlayoff = playoffData
  elseif 0 < #playoffTeamInfo then
    local playoffData = {}
    for i = 1, self.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      playoffData[i] = WarbandOpponentTeamData.new(cellData, self)
    end
    self.opponentPlayoff = playoffData
    for i = 1, #playoffTeamInfo do
      local td = WarbandOpponentTeamData.new(playoffTeamInfo[i], self)
      self.opponentCount[td.id] = td
      self.opponentPlayoff[td.index] = td
      if td.wintimes and td.wintimes == ChamptionWinTime then
        self.champtionBand = td
      end
    end
  end
  local group = data.teaminfo
  if group and 0 < #group then
    _TableClear(self.opponentCount)
    _TableClear(self.opponentGroup)
    for i = 1, #group do
      local teamGroupData = {}
      for i = 1, self.Fixed_SingleGroupNum do
        local cellData = {index = i, wintimes = 0}
        teamGroupData[i] = WarbandOpponentTeamData.new(cellData, self)
      end
      self.opponentGroup[i] = teamGroupData
      local teaminfo = group[i].groupteaminfo
      for t = 1, #teaminfo do
        local td = WarbandOpponentTeamData.new(teaminfo[t], self)
        self.opponentCount[td.id] = td
        self.opponentGroup[i][td.index] = td
      end
    end
  end
  local preteaminfo = data.preteaminfo
  if preteaminfo and 0 < #preteaminfo then
    _TableClear(self.preRoundOpponentCount)
    _TableClear(self.preRoundOpponentGroup)
    for i = 1, #preteaminfo do
      local teamGroupData = {}
      for i = 1, self.Fixed_SingleGroupNum do
        local cellData = {index = i, wintimes = 0}
        teamGroupData[i] = WarbandOpponentTeamData.new(cellData, self)
      end
      self.preRoundOpponentGroup[i] = teamGroupData
      local teaminfo = preteaminfo[i].groupteaminfo
      for t = 1, #teaminfo do
        local td = WarbandOpponentTeamData.new(teaminfo[t], self)
        self.preRoundOpponentCount[td.id] = td
        self.preRoundOpponentGroup[i][td.index] = td
      end
    end
  end
  self.curStage = data.stage or 0
  xdlog("当前比赛阶段", self.curStage)
  if self.curStage ~= 4 and self:GetOpponentCount() == 0 and self:GetPreRoundOpponentCount() == 0 then
    self:DoQuerySeasonInfo()
  end
end

function CupModeProxy:HandleQueryMember(data)
  if nil == self.memberinfoData then
    self.memberinfoData = {}
  else
    _ArrayClear(self.memberinfoData)
  end
  self.memberinfoTeamName = data.teamname
  if data.memberinfo then
    for i = 1, #data.memberinfo do
      self.memberinfoData[i] = WarbandMemberData.new(data.memberinfo[i])
    end
  end
end

function CupModeProxy:HandleUpdateMyWarband(data)
  if nil == self.myWarband then
    self.myWarband = MyWarbandTeamData.new(data, self)
  else
    self.myWarband:Update(data)
  end
  self.myWarbandId = self.myWarband.id
end

function CupModeProxy:HandleQueryList(list)
  self:ClearMemberMap()
  for i = 1, #list do
    local data = WarbandTeamData.new(list[i], self)
    self.warbandMap[data.id] = data
  end
end

function CupModeProxy:HandleSessionSort(data)
  self.seasonRank = {}
  local season, tempkey, oldSessionRank = 0, {}, {}
  for i = 1, #data do
    season = data[i].season
    if season and 0 < season then
      tempkey[#tempkey + 1] = season
      oldSessionRank[season] = {}
      for j = 1, #data[i].teams do
        local bandData = WarbandTeamData.new(data[i].teams[j], self)
        bandData.season = season
        table.insert(oldSessionRank[season], bandData)
      end
      table.sort(oldSessionRank[season], function(a, b)
        return a.rank < b.rank
      end)
    end
  end
  table.sort(tempkey, function(s1, s2)
    return s1 < s2
  end)
  for i = 1, #tempkey do
    self.seasonRank[#self.seasonRank + 1] = oldSessionRank[tempkey[i]]
  end
  xdlog("排名数据", self.proxyName, #self.seasonRank)
end

function CupModeProxy:HandleWarbandTime(data)
  self.etype = data.etype
  self:Launch(data)
end

function CupModeProxy:Launch(data)
  self.seasonRunning = true
  self.season = data.season
  self.curSeason = data.season > 10000 and data.season - 10000 or data.season
  self.consoleStartTime, self.consoleEndTime = data.season_begin, data.season_end
  self.breakStartTime, self.breakEndTime = data.season_breakbegin, data.season_breakend
  self.warbandStartTime = data.warband_createbegin
  self.signupStartTime = data.warband_signupbegin
  self.signupEndTime = data.warband_createend
  self.fightStartTime = data.season_initfighttime
  self.matchTime = data.season_matchtime
  self.canMatchTime = self.fightStartTime - self.matchTime
  self.figthInterval = data.season_fighttime
  self.nextFightTime = data.season_nextfighttime and 0 ~= data.season_nextfighttime and data.season_nextfighttime or self.fightStartTime
  self.preFightStartTime = data.season_initprefighttime
  self.preCanMatchTime = self.preFightStartTime - self.matchTime
  self.preNextFightTime = data.season_nextprefighttime and 0 ~= data.season_nextprefighttime and season_nextprefighttime or self.preFightStartTime
  self.isCrossServer = data.cross_server_champion or false
  self:TryUpdateScheduleStatus()
  self:ResetForbiddenPro(data.forbid_profession)
  redlog("[cup] 杯赛 console时间 | 当前服务器时间: ", os.date(time_format, self.consoleStartTime), os.date(time_format, self.consoleEndTime), os.date(time_format, ServerTime.CurServerTime() / 1000))
  redlog("[cup] 组战队开始时间 | 杯赛报名开始时间 | 组战队结束时间 : ", os.date(time_format, self.warbandStartTime), os.date(time_format, self.signupStartTime), os.date(time_format, self.signupEndTime))
  if self.preFightStartTime and self.preFightStartTime ~= 0 then
    redlog("[cup] 杯赛预选赛 开打时间 | 第一次匹配时间 | 下一轮比赛时间 : ", os.date(time_format, self.preFightStartTime), os.date(time_format, self.preCanMatchTime), os.date(time_format, self.preNextFightTime))
  end
  redlog("[cup] 杯赛开打时间 | 第一次匹配时间 | 下一轮比赛时间 : ", os.date(time_format, self.fightStartTime), os.date(time_format, self.canMatchTime), os.date(time_format, self.nextFightTime))
  redlog("[cup] 杯赛是否跨服  : ", self.curSeason, self.isCrossServer)
end

function CupModeProxy:_resetForbiddenPro()
  _TableClear(self.forbiddenProMap)
  _ArrayClear(self.forbiddenPro)
  self.forbiddenProStr = nil
end

function CupModeProxy:ResetForbiddenPro(array)
  self:_resetForbiddenPro()
  for i = 1, #array do
    self.forbiddenProMap[array[i]] = 1
    self.forbiddenPro[#self.forbiddenPro + 1] = array[i]
  end
end

function CupModeProxy:CheckProInvalid(pro)
  return nil ~= self.forbiddenProMap[pro]
end

function CupModeProxy:CheckForbiddenProConfig()
  return nil ~= next(self.forbiddenProMap)
end

function CupModeProxy:GetForbiddenProStr()
  if not self.forbiddenProStr then
    self.forbiddenProStr = ""
    local _table = Table_Class
    for i = 1, #self.forbiddenPro do
      if _table[self.forbiddenPro[i]] then
        self.forbiddenProStr = self.forbiddenProStr .. _table[self.forbiddenPro[i]].NameZh
        if i < #self.forbiddenPro then
          self.forbiddenProStr = self.forbiddenProStr .. "、"
        end
      end
    end
  end
  return self.forbiddenProStr
end

function CupModeProxy:CheckCalendarTimeValid(type, dependencyStamp)
  local cal_times = self.calSeasonTime[type]
  if cal_times then
    for i = 1, #cal_times do
      local startTime = cal_times[i].season_begin
      local endTime = cal_times[i].season_end
      local startbreakTime = cal_times[i].season_breakbegin
      local endbreakTime = cal_times[i].season_breakend
      local intime = startTime and endTime and dependencyStamp > startTime and dependencyStamp < endTime
      local inbreakTime = 0 ~= startbreakTime and 0 ~= endbreakTime and dependencyStamp > startbreakTime and dependencyStamp < endbreakTime
      if intime and not inbreakTime then
        return true
      end
    end
  end
  return false
end

function CupModeProxy:HandleSeasonTime4Calendar(data)
  _TableClear(self.calSeasonTime)
  local infos = data.time_infos
  if not infos then
    return
  end
  for i = 1, #infos do
    local serverInfo = infos[i]
    local info = _CreateTable()
    local etype = serverInfo.etype
    info.season = serverInfo.season_begin
    info.season_begin = serverInfo.season_begin
    info.season_end = serverInfo.season_end
    info.season_breakbegin = serverInfo.season_breakbegin
    info.season_breakend = serverInfo.season_breakend
    if not self.calSeasonTime[etype] then
      self.calSeasonTime[etype] = {}
    end
    _ArrayPushBack(self.calSeasonTime[etype], info)
  end
end

function CupModeProxy:DoQuerySeasonRank()
  assert(self.CupModeType, "必须在实现类中赋值")
  if self.seasonRunning and self.seasonRank and #self.seasonRank > 0 then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSortMatchCCmd(nil, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:DoMemberPrepare(ready)
  assert(self.CupModeType, "必须在实现类中赋值")
  if self:CheckBandAuthority() then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandPrepareMatchCCmd(ready, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:DoSignUp()
  assert(self.CupModeType, "必须在实现类中赋值")
  if self:IsWarbandInBreakTime() then
    return
  end
  if not self:CheckSignupTimeValid() then
    MsgManager.ShowMsgByID(28059)
    return
  end
  if not self:CheckBandAuthority() then
    return
  end
  if not self:CheckFull() then
    MsgManager.ShowMsgByID(28049)
    return
  end
  if not self:CheckAllReady() then
    MsgManager.ShowMsgByID(28050)
    return
  end
  local confirmCallback = function()
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSignUpMatchCCmd(self.CupModeType, nil, self.isCrossServer)
  end
  if self:CheckHasInvalidPro() then
    local param = self:GetForbiddenProStr()
    MsgManager.ConfirmMsgByID(28088, confirmCallback, nil, nil, param)
  else
    confirmCallback()
  end
end

function CupModeProxy:DoMatch()
  assert(self.CupModeType, "必须在实现类中赋值")
  if not self.isCrossServer and TeamProxy.Instance:CheckHasDiffServerMember() then
    MsgManager.ShowMsgByID(42041)
    return
  end
  if not self:CheckMatchTimeValid() then
    MsgManager.ShowMsgByID(28075)
    return false
  end
  if self:IsWarbandInBreakTime() then
    return false
  end
  if not self:CheckMatchValid() then
    return false
  end
  if self:CheckHasInvalidPro() then
    local param = self:GetForbiddenProStr()
    MsgManager.ConfirmMsgByID(28088, nil, nil, nil, param)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(self.CupModeType, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, not self.isCrossServer and true or false)
  return true
end

function CupModeProxy:DoCreatWarband()
  assert(self.CupModeType, "必须在实现类中赋值")
  if self:IsWarbandInBreakTime() then
    redlog("[cup] IsWarbandInBreakTime")
    return
  end
  local enterLv = self:GetWarbandLimitedLv()
  if not enterLv then
    redlog("[cup] 创建战队等级限制未找到")
    return
  end
  if enterLv > Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) then
    MsgManager.ShowMsgByID(28071, enterLv)
    return
  end
  if self:IHaveWarband() then
    return
  end
  local suffixName = self.SeasonTimeConfig and self.SeasonTimeConfig.WarbandSuffixName or "的战队"
  local str = Game.Myself.data.name .. suffixName
  if FunctionMaskWord.Me():CheckMaskWord(str, GameConfig.MaskWord.WarbandName) then
    MsgManager.ShowMsgByIDTable(2604)
    return
  end
  redlog("[cup] CallTwelveWarbandCreateMatchCCmd", self.CupModeType, self.isCrossServer)
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandCreateMatchCCmd(str, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:DoChangeName(name)
  assert(self.CupModeType, "必须在实现类中赋值")
  if self:IsWarbandInBreakTime() then
    return
  end
  if not self:CheckBandAuthority() then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandNameMatchCCmd(name, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:DoLeaveWarband()
  assert(self.CupModeType, "必须在实现类中赋值")
  if self:IsWarbandInBreakTime() then
    return
  end
  MsgManager.ConfirmMsgByID(28048, function()
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandLeaveMatchCCmd(self.CupModeType, self.isCrossServer)
  end, nil)
end

function CupModeProxy:DoKickMember(guid, name)
  assert(self.CupModeType, "必须在实现类中赋值")
  if self:IsWarbandInBreakTime() then
    return
  end
  if self:CheckBandAuthority() and self:CheckInMyBand(guid) then
    MsgManager.ConfirmMsgByID(28047, function()
      ServiceMatchCCmdProxy.Instance:CallTwelveWarbandDeleteMatchCCmd(guid, self.CupModeType, self.isCrossServer)
    end, nil, nil, name)
  end
end

function CupModeProxy:DoDisband()
  xdlog("取消报名")
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSignUpMatchCCmd(self.CupModeType, true, self.isCrossServer)
end

function CupModeProxy:DoQueryBand(season, guid)
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandQueryMatchCCmd(season, guid, nil, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:DoQueryTeamList()
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandTeamListMatchCCmd(nil, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:SetOpponentStatus(treeOpen)
  if treeOpen ~= self.opponentStatus then
    self.opponentStatus = treeOpen
    ServiceMatchCCmdProxy.Instance:CallSyncMatchBoardOpenStateMatchCCmd(treeOpen, self.CupModeType, self.isCrossServer)
  end
end

function CupModeProxy:DoCallInviter(guid, bandName, leaderName)
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviterMatchCCmd(guid, bandName, leaderName, nil, nil, self.CupModeType, self.isCrossServer)
end

function CupModeProxy:DoQuerySeasonInfo()
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(self.CupModeType)
end
