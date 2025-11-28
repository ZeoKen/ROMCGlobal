autoImport("WarbandOpponentTeamData")
autoImport("MyWarbandTeamData")
WarbandProxy = class("WarbandProxy", pm.Proxy)
WarbandProxy.Instance = nil
WarbandProxy.NAME = "WarbandProxy"
WarbandProxy.Fixed_SingleGroupNum = 8
WarbandProxy.ESchedule = {
  NoOpen = 0,
  END = 1,
  SIGN_UP_PENDING = 2,
  SIGN_UP = 3,
  FIGHT_PENDING = 4,
  FIGHTING = 5
}
local FightTimeDescByRefreshTime = function(t)
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
local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _CreateTable = ReusableTable.CreateTable
local _DestroyAndClearTable = ReusableTable.DestroyAndClearTable

function WarbandProxy:ctor(proxyName, data)
  self.proxyName = proxyName or WarbandProxy.NAME
  if WarbandProxy.Instance == nil then
    WarbandProxy.Instance = self
  end
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
  self.cal_twelveSeasonTime = {}
  self.forbiddenProMap = {}
  self.forbiddenPro = {}
  self.curStage = 0
end

function WarbandProxy:HandleUpdateMyWarband(data)
  if nil == self.myWarband then
    redlog("创建战队")
    self.myWarband = MyWarbandTeamData.new(data, self)
  else
    redlog("更新战队")
    self.myWarband:Update(data)
  end
  self.myWarbandId = self.myWarband.id
end

function WarbandProxy:HandleSessionSort(data)
  self.seasonRank = {}
  local season, tempkey, oldSessionRank = 0, {}, {}
  for i = 1, #data do
    season = data[i].season
    tempkey[#tempkey + 1] = season
    oldSessionRank[season] = {}
    for j = 1, #data[i].teams do
      local bandData = WarbandTeamData.new(data[i].teams[j])
      bandData.season = season
      table.insert(oldSessionRank[season], bandData)
    end
    table.sort(oldSessionRank[season], function(a, b)
      return a.rank < b.rank
    end)
  end
  table.sort(tempkey, function(s1, s2)
    return s1 < s2
  end)
  for i = 1, #tempkey do
    self.seasonRank[#self.seasonRank + 1] = oldSessionRank[tempkey[i]]
  end
end

function WarbandProxy:GetLastSeasonRank()
  if self.seasonRank and #self.seasonRank > 0 then
    return self.seasonRank[#self.seasonRank]
  end
end

function WarbandProxy:GetLastSeasonRankByRank(rank)
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

function WarbandProxy:GetMyWarbandID()
  return self.myWarbandId
end

function WarbandProxy:GetMyWarbandName()
  local name = self.myWarband and self.myWarband.name or ""
  local suffix = GameConfig.TwelveSeasonTime and GameConfig.TwelveSeasonTime.WarbandSuffixName or "的战队"
  name = name:gsub(suffix, OverSea.LangManager.Instance():GetLangByKey(suffix))
  return name
end

function WarbandProxy:GetCurStage()
  return self.curStage
end

function WarbandProxy:CheckIsFinalRound()
  for _, v in pairs(self.opponentPlayoff) do
    if v.wintimes >= 2 then
      return true
    end
  end
  return false
end

local ChamptionWinTime = 3

function WarbandProxy:HandleTreeBandData(data)
  _TableClear(self.opponentCount)
  local playoffTeamInfo = data.championteaminfo and data.championteaminfo.groupteaminfo
  if not playoffTeamInfo then
    _ArrayClear(self.opponentPlayoff)
    local playoffData = {}
    for i = 1, WarbandProxy.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      playoffData[i] = WarbandOpponentTeamData.new(cellData, self)
    end
  elseif 0 < #playoffTeamInfo then
    local playoffData = {}
    for i = 1, WarbandProxy.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      playoffData[i] = WarbandOpponentTeamData.new(cellData)
    end
    self.opponentPlayoff = playoffData
    for i = 1, #playoffTeamInfo do
      local td = WarbandOpponentTeamData.new(playoffTeamInfo[i])
      self.opponentCount[td.id] = td
      self.opponentPlayoff[td.index] = td
      if td.wintimes and td.wintimes == ChamptionWinTime then
        self.champtionBand = td
      end
    end
  end
  local group = data.teaminfo
  if not group or 0 == #group then
    return
  end
  redlog("TwelveWarbandTreeMatchCCmd teaminfo length 分组数: ", #group)
  if 0 < #group then
    _TableClear(self.opponentCount)
  end
  _TableClear(self.opponentGroup)
  for i = 1, #group do
    local teamGroupData = {}
    for i = 1, WarbandProxy.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      teamGroupData[i] = WarbandOpponentTeamData.new(cellData)
    end
    self.opponentGroup[i] = teamGroupData
    local teaminfo = group[i].groupteaminfo
    for t = 1, #teaminfo do
      local td = WarbandOpponentTeamData.new(teaminfo[t])
      self.opponentCount[td.id] = td
      self.opponentGroup[i][td.index] = td
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
        xdlog("预选赛队伍数据", td.index)
      end
    end
  end
  self.curStage = data.stage or 0
  xdlog("当前比赛阶段", self.curStage)
end

function WarbandProxy:GetOpponentCount()
  local result = 0
  for k, v in pairs(self.opponentCount) do
    result = result + 1
  end
  return result
end

function WarbandProxy:HandleQueryList(list)
  self:ClearMemberMap()
  for i = 1, #list do
    local data = WarbandTeamData.new(list[i])
    self.warbandMap[data.id] = data
  end
end

function WarbandProxy:HandleQueryMember(data)
  if nil == self.memberinfoData then
    self.memberinfoData = {}
  else
    _ArrayClear(self.memberinfoData)
  end
  if data.memberinfo then
    for i = 1, #data.memberinfo do
      self.memberinfoData[i] = WarbandMemberData.new(data.memberinfo[i])
    end
  end
end

function WarbandProxy:GetSignupWarbandList()
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

function WarbandProxy:DoMemberPrepare(ready)
  if self:CheckBandAuthority() then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandPrepareMatchCCmd(ready, nil, self.isCrossServer)
end

function WarbandProxy:GetTeamScore()
  if self.myWarband then
    return self.myWarband:GetTeamScore()
  end
  return 0
end

function WarbandProxy:GetOpponentServerList()
  return self.opponentServerList or {}
end

function WarbandProxy:GetGroupTabData()
  local data = {}
  local cell = {}
  for i = 1, #self.opponentGroup do
    cell = {index = i, isPlayoff = false}
    data[#data + 1] = cell
  end
  return data
end

function WarbandProxy:GetPreRoundGroupTabData()
  local data = {}
  local cell = {}
  for i = 1, #self.preRoundOpponentGroup do
    cell = {index = i, isPlayoff = false}
    data[#data + 1] = cell
  end
  return data
end

function WarbandProxy:GetFinalRoundGroupTabData()
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

function WarbandProxy:GetOpponentData(tab)
  if tab.isPlayoff then
    return self.opponentPlayoff or {}
  else
    return self.opponentGroup[tab.index]
  end
end

function WarbandProxy:GetPreRoundOpponentData(tab)
  if tab.isPlayoff then
    return self.opponentPlayoff or {}
  else
    return self.preRoundOpponentGroup[tab.index]
  end
end

function WarbandProxy:GetFinalRoundOpponentData()
  if TableUtil.TableIsEmpty(self.opponentPlayoff) then
    local playoffData = {}
    for i = 1, self.Fixed_SingleGroupNum do
      local cellData = {index = i, wintimes = 0}
      playoffData[i] = WarbandOpponentTeamData.new(cellData, self)
    end
    self.opponentPlayoff = playoffData
  end
  return self.opponentPlayoff or {}
end

function WarbandProxy:GetMyWarbandViewMember()
  return self.myWarband and self.myWarband:GetViewMembers() or {}
end

function WarbandProxy:GetWarbandMembers(id)
  local band = self.warbandMap[id]
  if band then
    return band:GetMembers()
  end
end

function WarbandProxy:GetSessionRank()
  return self.seasonRank or {}
end

function WarbandProxy:UpdateTeamMember(updates, dels)
  if not self.myWarband then
    return
  end
  self.myWarband:SetMembers(updates)
  self.myWarband:RemoveMembers(dels)
end

function WarbandProxy:ExitMyband()
  if self.myWarband then
    self.myWarband:Exit()
    self.myWarband = nil
  end
end

function WarbandProxy:ClearMemberMap()
  _TableClear(self.warbandMap)
end

function WarbandProxy:ShutDown()
  redlog("ShutDown", self.proxyName)
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

function WarbandProxy:IHaveWarband()
  return nil ~= self.myWarband and self.myWarband.id ~= 0
end

function WarbandProxy:DoSignUp()
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
    redlog("报名CallTwelveWarbandSignUpMatchCCmd")
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSignUpMatchCCmd()
  end
  if self:CheckHasInvalidPro() then
    local param = self:GetForbiddenProStr()
    MsgManager.ConfirmMsgByID(28088, confirmCallback, nil, nil, param)
  else
    confirmCallback()
  end
end

function WarbandProxy:DoMatch()
  if not self:CheckMatchTimeValid() then
    MsgManager.ShowMsgByID(28075)
    return
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
  local raidconfigID = Table_MatchRaid[self.champtionRoomId].RaidConfigID
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.TwelvePVPChampion, raidconfigID, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, not self.isCrossServer)
  return true
end

function WarbandProxy:DoQuerySeasonRank()
  if self.seasonRunning and self.seasonRank and #self.seasonRank > 0 then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSortMatchCCmd()
end

function WarbandProxy:GetWarbandLimitedLv()
  local raidCfg = self.champtionRoomId and self.champtionRoomId and Table_MatchRaid[self.champtionRoomId]
  return raidCfg and raidCfg.EnterLevel
end

function WarbandProxy:DoCreatWarband()
  if self:IsWarbandInBreakTime() then
    return
  end
  local enterLv = self:GetWarbandLimitedLv()
  if not enterLv then
    redlog("创建战队等级限制未找到")
    return
  end
  if enterLv > Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) then
    MsgManager.ShowMsgByID(28071, enterLv)
    return
  end
  if self:IHaveWarband() then
    return
  end
  local suffixName = GameConfig.TwelveSeasonTime and GameConfig.TwelveSeasonTime.WarbandSuffixName or "的战队"
  local str = Game.Myself.data.name .. suffixName
  if FunctionMaskWord.Me():CheckMaskWord(str, GameConfig.MaskWord.WarbandName) then
    MsgManager.ShowMsgByIDTable(2604)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandCreateMatchCCmd(str, nil, self.isCrossServer)
end

function WarbandProxy:DoChangeName(name)
  if self:IsWarbandInBreakTime() then
    return
  end
  if not self:CheckBandAuthority() then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandNameMatchCCmd(name)
end

function WarbandProxy:DoLeaveWarband()
  if self:IsWarbandInBreakTime() then
    return
  end
  MsgManager.ConfirmMsgByID(28048, function()
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandLeaveMatchCCmd()
  end, nil)
end

function WarbandProxy:DoKickMember(guid, name)
  if self:IsWarbandInBreakTime() then
    return
  end
  if self:CheckBandAuthority() and self:CheckInMyBand(guid) then
    MsgManager.ConfirmMsgByID(28047, function()
      ServiceMatchCCmdProxy.Instance:CallTwelveWarbandDeleteMatchCCmd(guid)
    end, nil, nil, name)
  end
end

function WarbandProxy:DoDisband()
  xdlog("12v12取消报名")
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSignUpMatchCCmd(self.etype, true)
end

function WarbandProxy:CheckMatchValid()
  if not TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    MsgManager.ShowMsgByID(28073)
    return
  end
  local minMatchNum = GameConfig.TwelveSeasonTime.minMatchNum
  if not minMatchNum then
    redlog("参与匹配最低人数minMatchNum未配")
    return
  end
  if minMatchNum > TeamProxy.Instance:GetGroupTeammateNum() then
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

function WarbandProxy:CheckInMyBand(guid)
  if self:IHaveWarband() then
    return nil ~= self.myWarband:GetMemberByGuid(guid)
  end
  return false
end

function WarbandProxy:CheckAllReady()
  if self.myWarband then
    return self.myWarband:CheckAllReady()
  end
  return true
end

function WarbandProxy:CheckHasInvalidPro()
  local _teamProxy = TeamProxy.Instance
  if _teamProxy:IHaveGroup() then
    local list = _teamProxy.myTeam:GetMembersList()
    for i = 1, #list do
      if self:CheckProInvalid(list[i].profession) then
        return true
      end
    end
    local uniteteam = _teamProxy:GetGroupUniteTeamData()
    if uniteteam then
      local list = uniteteam:GetMembersList()
      for i = 1, #list do
        if self:CheckProInvalid(list[i].profession) then
          return true
        end
      end
    end
  end
  return false
end

function WarbandProxy:CheckHasSignup()
  if self.myWarband then
    return self.myWarband:IsSignUp()
  end
end

function WarbandProxy:CheckBandAuthority()
  local my = Game.Myself.data and Game.Myself.data.id
  if not my or not self:IHaveWarband() then
    return false
  end
  local md = self.myWarband:GetMemberByGuid(my)
  return nil ~= md and md.isCaptial == true
end

function WarbandProxy:CheckImReady()
  local my = Game.Myself.data and Game.Myself.data.id
  if not my or not self:IHaveWarband() then
    return false
  end
  local md = self.myWarband:GetMemberByGuid(my)
  return nil ~= md and md.prepare == true
end

function WarbandProxy:CheckFull()
  if self.myWarband then
    return self.myWarband:IsFull()
  end
  return false
end

function WarbandProxy:CheckInPreParticipants()
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

function WarbandProxy:CheckInParticipants()
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

function WarbandProxy:CheckInFinal()
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

local time_format = "%Y-%m-%d %H:%M:%S"
local p = "(%d+):(%d+):(%d+)"
local DAY_SECOND, HOUR_SECOND, MINSCEOND = 86400, 3600, 60

function WarbandProxy:HandleWarbandTime(data)
  self.etype = data.etype
  redlog("HandleWarbandTime curSeason | etype : ", data.season, self.etype)
  if data.etype ~= PvpProxy.Type.TwelvePVPChampion then
    self.twelveRelaxStartTime, self.twelveRelaxEndTime = data.season_begin, data.season_end
    self.twelveRelaxBreakStartTime, self.twelveRelaxBreakEndTime = data.season_breakbegin, data.season_breakend
    return
  end
  self:Launch(data)
end

function WarbandProxy:Launch(data)
  self.seasonRunning = true
  self.curSeason = data.season > 10000 and data.season - 10000 or data.season
  self:ProcessRewardBySeason(self.curSeason)
  if nil == self.champtionRoomId then
    self.champtionRoomId = GameConfig.TwelvePvp and GameConfig.TwelvePvp.ChampionMode and GameConfig.TwelvePvp.ChampionMode.MatchRaidID
  end
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
  self.isCrossServer = data.cross_server_champion or false
  redlog("杯赛 console时间: ", os.date(time_format, self.consoleStartTime), os.date(time_format, self.consoleEndTime), os.date(time_format, ServerTime.CurServerTime() / 1000))
  redlog("组战队开始时间 | 杯赛报名开始时间 | 组战队结束时间 : ", os.date(time_format, self.warbandStartTime), os.date(time_format, self.signupStartTime), os.date(time_format, self.signupEndTime))
  redlog("杯赛开打时间 | 第一次匹配时间 | 下一轮比赛时间 : ", os.date(time_format, self.fightStartTime), os.date(time_format, self.canMatchTime), os.date(time_format, self.nextFightTime))
  redlog("[cup] 杯赛是否跨服  : ", self.curSeason, self.isCrossServer)
  self:ResetForbiddenPro(data.forbid_profession)
  self:TryUpdateScheduleStatus()
end

function WarbandProxy:_resetForbiddenPro()
  _TableClear(self.forbiddenProMap)
  _ArrayClear(self.forbiddenPro)
  self.forbiddenProStr = nil
end

function WarbandProxy:ResetForbiddenPro(array)
  self:_resetForbiddenPro()
  for i = 1, #array do
    self.forbiddenProMap[array[i]] = 1
    self.forbiddenPro[#self.forbiddenPro + 1] = array[i]
  end
end

function WarbandProxy:CheckProInvalid(pro)
  return nil ~= self.forbiddenProMap[pro]
end

function WarbandProxy:CheckForbiddenProConfig()
  return nil ~= next(self.forbiddenProMap)
end

function WarbandProxy:GetForbiddenProStr()
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

function WarbandProxy:CheckCalendarTimeValid(type, dependencyStamp, isCrossServer)
  local cal_times = self.cal_twelveSeasonTime[type]
  local isCrossServer = isCrossServer or false
  if cal_times then
    for i = 1, #cal_times do
      local isSeasonCrossServer = cal_times[i].season > 10000
      if isCrossServer == isSeasonCrossServer then
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
  end
  return false
end

function WarbandProxy:HandleTwelveSeasonTime4Calendar(data)
  local infos = data.time_infos
  if not infos then
    return
  end
  for i = 1, #infos do
    local serverInfo = infos[i]
    local info = _CreateTable()
    local etype = serverInfo.etype
    info.season = serverInfo.season
    info.season_begin = serverInfo.season_begin
    info.season_end = serverInfo.season_end
    info.season_breakbegin = serverInfo.season_breakbegin
    info.season_breakend = serverInfo.season_breakend
    local calendarData = self.cal_twelveSeasonTime[etype] or {}
    _ArrayPushBack(calendarData, info)
    self.cal_twelveSeasonTime[etype] = calendarData
  end
end

function WarbandProxy:ProcessRewardBySeason(season)
  local cfg = GameConfig.TwelveSeasonTime.reward
  if nil == cfg then
    return
  end
  local curSeasonReward = cfg[season]
  if nil == curSeasonReward then
    redlog("当前赛季奖励未配置: ", season)
    return
  end
  local cfg_rankReward
  cfg_rankReward = curSeasonReward.rankReward
  local data = {
    rankReward = {},
    itemReward = {},
    itemRewardRank = 0
  }
  for i = 1, #cfg_rankReward do
    local rewardData = cfg_rankReward[i]
    local d = {
      index = i,
      beginRank = rewardData.beginRank,
      endRank = rewardData.endRank,
      rewardIDs = rewardData.rewards
    }
    data.rankReward[#data.rankReward + 1] = d
  end
  if curSeasonReward.itemReward then
    for i = 1, #curSeasonReward.itemReward do
      data.itemReward[#data.itemReward + 1] = ItemData.new("seasonReward", curSeasonReward.itemReward[i])
    end
  end
  data.itemRewardRank = curSeasonReward.itemRewardRank
  self.seasonReward[season] = data
end

function WarbandProxy:IsCurSeasonRunning()
  return self.seasonRunning == true
end

function WarbandProxy:GetCurSeasonReward()
  return self.curSeason and self.seasonReward[self.curSeason] or {}
end

function WarbandProxy:GetFightCDTime()
  local curTime = ServerTime.CurServerTime() / 1000
  local refreshTime
  if curTime < self.nextFightTime then
    refreshTime = self.nextFightTime
  else
    local stage = math.ceil((curTime - self.nextFightTime) / self.figthInterval)
    refreshTime = stage * self.figthInterval + self.nextFightTime
  end
  return FightTimeDescByRefreshTime(refreshTime)
end

function WarbandProxy:CheckMatchTimeValid()
  if self.canMatchTime then
    local curTime = ServerTime.CurServerTime() / 1000
    return curTime > self.canMatchTime
  end
  return false
end

function WarbandProxy:IsWarbandInBreakTime()
  local curTime = ServerTime.CurServerTime() / 1000
  if self.breakStartTime and self.breakEndTime then
    return curTime > self.breakStartTime and curTime < self.breakEndTime
  end
  return false
end

function WarbandProxy:CheckSignupTimeValid()
  if self.signupStartTime and self.signupEndTime then
    local curTime = ServerTime.CurServerTime() / 1000
    return curTime >= self.signupStartTime and curTime <= self.signupEndTime
  end
  return false
end

function WarbandProxy:SetSchedule(status)
  if status ~= self.ESchedule then
    self.ESchedule = status
    redlog("设置当前时间区间 ESchedule：", self.ESchedule)
    GameFacade.Instance:sendNotification(PVPEvent.TwelveChamption_ScheduleChanged)
  end
  if status == WarbandProxy.ESchedule.FIGHTING then
    GameFacade.Instance:sendNotification(PVPEvent.TwelveChamption_Fighting)
  end
end

function WarbandProxy:TryUpdateScheduleStatus()
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

function WarbandProxy:IsSeasonNoOpen()
  return WarbandProxy.ESchedule.NoOpen == self.ESchedule
end

function WarbandProxy:IsSeasonEnd()
  return WarbandProxy.ESchedule.END == self.ESchedule
end

function WarbandProxy:IsSigthupPending()
  return WarbandProxy.ESchedule.SIGN_UP_PENDING == self.ESchedule
end

function WarbandProxy:IsInSignupTime()
  return WarbandProxy.ESchedule.SIGN_UP == self.ESchedule
end

function WarbandProxy:IsFighting()
  return WarbandProxy.ESchedule.FIGHTING == self.ESchedule
end

function WarbandProxy:IsFightingPending()
  return WarbandProxy.ESchedule.FIGHT_PENDING == self.ESchedule
end

function WarbandProxy:SetOpponentStatus(treeOpen)
  if treeOpen ~= self.opponentStatus then
    self.opponentStatus = treeOpen
    ServiceMatchCCmdProxy.Instance:CallSyncMatchBoardOpenStateMatchCCmd(treeOpen, nil, self.isCrossServer)
  end
end

function WarbandProxy:HandleSkillEff(data)
  local effs = data and data.proeffects
  if "table" ~= type(effs) then
    return
  end
  self._effDataDirty = true
  _TableClear(self.effectMap)
  for i = 1, #effs do
    self:UpdateEffect(effs[i])
  end
end

function WarbandProxy:UpdateEffect(data)
  local effectsByPro = self:GetProEffect(data.eprofession)
  if nil == effectsByPro then
    self:AddProEffect(data)
  else
    effectsByPro:SetEffects(data.seffect)
  end
end

function WarbandProxy:AddProEffect(data)
  local effData = ProSkillEffectData.new(data)
  self.effectMap[effData.pro] = effData
end

function WarbandProxy:GetProEffect(pro)
  return self.effectMap[pro]
end

function WarbandProxy:GetEffectList()
  if self._effDataDirty then
    self._effDataDirty = false
    _ArrayClear(self.effectList)
    for pro, data in pairs(self.effectMap) do
      local tmp = ReusableTable.CreateTable()
      tmp.pro = pro
      tmp.value = data
      self.effectList[#self.effectList + 1] = tmp
    end
  end
  return self.effectList
end

function WarbandProxy:DoQueryBand(season, guid)
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandQueryMatchCCmd(0, guid)
end

function WarbandProxy:DoQueryTeamList()
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandTeamListMatchCCmd()
end

function WarbandProxy:GetMinSignupMemberCount()
  return GameConfig.TwelveSeasonTime and GameConfig.TwelveSeasonTime.warbandMemberNum or 12
end

function WarbandProxy:DoCallInviter(guid, bandName, leaderName)
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviterMatchCCmd(guid, bandName, leaderName)
end

ProSkillEffectData = class("ProSkillEffectData")

function ProSkillEffectData:ctor(data)
  self.pro = data.eprofession
  self.effects = {}
  self:SetEffects(data.seffect)
end

function ProSkillEffectData:SetEffects(seffect)
  if "table" ~= type(seffect) then
    return
  end
  for i = 1, #seffect do
    local skillEffData = SingleSkillEffectItemData.new(seffect[i], self.pro)
    self.effects[seffect[i].id] = skillEffData
  end
end

function ProSkillEffectData:GetEffectList()
  local result = {}
  for k, v in pairs(self.effects) do
    result[#result + 1] = v
  end
  table.sort(result, function(a, b)
    return a.itemId < b.itemId
  end)
  return result
end

SingleSkillEffectItemData = class("SingleSkillEffectItemData")

function SingleSkillEffectItemData:ctor(data, pro)
  self.pro = pro
  self.effectStatus = data.effect
  self.sendStatus = data.effect == 0 and 1 or 0
  self.endTime = data.endtime
  self.itemId = data.id
  local itemStatic = Table_Item[self.itemId]
  if nil == itemStatic then
    redlog("SingleSkillEffectItemData | Table_Item未找到id : ", self.itemId)
    return
  end
  self.itemdata = ItemData.new("SingleSkillEffect", data.id)
end
