local GetValue = function(value, use_second)
  if use_second then
    return value
  else
    return value // 60
  end
end
local ProfessionIndex = function()
  local pro = Game.Myself.data:GetProfesstion()
  if pro / 10 < 1 then
    return 0
  else
    return pro % 10
  end
end
BattleTimeDataProxy = class("BattleTimeDataProxy", pm.Proxy)
BattleTimeDataProxy.ETime = {
  PLAY = SceneUser3_pb.EPRIORBATTLECOST_PLAY,
  BATTLE = SceneUser3_pb.EPRIORBATTLECOST_BATTLE
}
BattleTimeDataProxy.ESwitchType = {BATTLE = "battle", PLAY = "play"}
BattleTimeDataProxy.ReverseType = {
  [SceneUser3_pb.EPRIORBATTLECOST_PLAY] = SceneUser3_pb.EPRIORBATTLECOST_BATTLE,
  [SceneUser3_pb.EPRIORBATTLECOST_BATTLE] = SceneUser3_pb.EPRIORBATTLECOST_PLAY
}
BattleTimeDataProxy.EStatus = {
  EASY = SceneUser2_pb.EBATTLESTATUS_EASY,
  TIRED = SceneUser2_pb.EBATTLESTATUS_TIRED,
  HIGHTIRED = SceneUser2_pb.EBATTLESTATUS_HIGHTIRED
}

function BattleTimeDataProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "BattleTimeDataProxy"
  if not BattleTimeDataProxy.Instance then
    BattleTimeDataProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function BattleTimeDataProxy:Init()
  self.timelen = 0
  self.totaltime = 0
  self.dailyKillNum = 0
  self.dailyKillMaxNum = 0
  self.musictime = 0
  self.tutortime = 0
  self.powertime = 0
  self.playtime = 0
  self.usedplaytime = 0
  self.status = BattleTimeDataProxy.EStatus.EASY
  self.dailyMaxPlayTime = 0
  self.weeklyMaxPlayTime = 0
  self.used_playtime_extra_daily = 0
  self.total_playtime_extra_daily = 0
  self.used_playtime_extra = 0
  self.total_playtime_extra = 0
  self.switchStatus = {
    [BattleTimeDataProxy.ESwitchType.BATTLE] = true,
    [BattleTimeDataProxy.ESwitchType.PLAY] = true
  }
end

function BattleTimeDataProxy.QueryBattleTimelenUserCmd()
  ServiceNUserProxy.Instance:CallBattleTimelenUserCmd()
end

function BattleTimeDataProxy:QuerySwitch(switchType)
  if switchType == BattleTimeDataProxy.ESwitchType.BATTLE then
    local battle_time_interval = GameConfig.System.battle_time_cd or 1
    local curTime = ServerTime.CurServerTime() / 1000
    if self.battleTimeSwitch_cd and curTime < self.battleTimeSwitch_cd + battle_time_interval then
      MsgManager.ShowMsgByID(43596)
      return
    end
    ServiceSceneUser3Proxy.Instance:CallBattleTimeOffUserCmd(self.switchStatus[BattleTimeDataProxy.ESwitchType.BATTLE])
  elseif switchType == BattleTimeDataProxy.ESwitchType.PLAY then
    ServiceSceneUser3Proxy.Instance:CallPlayTimeOffUserCmd(self.switchStatus[BattleTimeDataProxy.ESwitchType.PLAY])
  end
end

function BattleTimeDataProxy.QueryBattleTimeCostSelectCmd(var)
  if ISNoviceServerType then
    return
  end
  if not var then
    return
  end
  ServiceSceneUser3Proxy.Instance:CallBattleTimeCostSelectCmd(var)
end

function BattleTimeDataProxy:CheckSwitchOn(switchType)
  return self.switchStatus[switchType] == true
end

function BattleTimeDataProxy:HandleRecvBattleTimelenUserCmd(data)
  if not (data and data.timelen) or not data.totaltime then
    return
  end
  self:SetServerGameMaxPlayTime(data.config)
  self.useDailyPlayTime = self.dailyMaxPlayTime > 0
  self.timelen = data.timelen or 0
  self.totaltime = data.totaltime or 0
  self.musictime = data.musictime or 0
  self.tutortime = data.tutortime or 0
  self.powertime = data.powertime or 0
  self.playtime = data.playtime or 0
  self.usedplaytime = data.usedplaytime or 0
  self.status = data.estatus
  self.dailyKillNum = data.used_count
  self.dailyKillMaxNum = data.total_count
  self.used_playtime_extra_daily = data.used_playtime_extra_daily
  self.total_playtime_extra_daily = data.total_playtime_extra_daily
  self.used_playtime_extra = data.used_playtime_extra
  self.total_playtime_extra = data.total_playtime_extra
  ServiceFuBenCmdProxy.Instance:CallTeamExpQueryInfoFubenCmd()
end

function BattleTimeDataProxy:HandleRecvSyncPvePassInfoFubenCmd(data)
  if data.totalbattletime and data.battletime then
    self.totaltime = data.totalbattletime
    self.timelen = data.totalbattletime - data.battletime
  end
  if data.totalplaytime and data.playtime then
    self.playtime = data.totalplaytime
    self.usedplaytime = self.playtime - data.playtime
  end
end

function BattleTimeDataProxy:HandleRecvBattleTimeCostSelectCmd(data)
  self.gameTimeSetting = data and data.ecost or BattleTimeDataProxy.ETime.PLAY
end

function BattleTimeDataProxy:RecvBattleTimeSwitch(server_off, start_timestamp)
  self:RecvSwitch(BattleTimeDataProxy.ESwitchType.BATTLE, server_off, start_timestamp)
end

function BattleTimeDataProxy:RecvPlayTimeSwitch(server_off)
  self:RecvSwitch(BattleTimeDataProxy.ESwitchType.PLAY, server_off)
end

function BattleTimeDataProxy:RecvSwitch(switchType, server_off, start_timestamp)
  self.switchStatus[switchType] = not server_off
  if switchType == BattleTimeDataProxy.ESwitchType.BATTLE then
    self.battleTimeSwitch_cd = start_timestamp
  end
end

function BattleTimeDataProxy:UseDailyPlayTime()
  return self.useDailyPlayTime == true
end

function BattleTimeDataProxy:SetServerGameMaxPlayTime(config)
  if not config then
    return
  end
  self.dailyMaxPlayTime = config.daily_max_time or 0
  self.weeklyMaxPlayTime = config.weekly_base_time or 0
  if self.dailyMaxPlayTime == 0 and self.weeklyMaxPlayTime == 0 or self.dailyMaxPlayTime > 0 and 0 < self.weeklyMaxPlayTime then
    redlog("策划配置错误，检查ServerGame.PlayTime.weekly_base_time、 ServerGame.PlayTime.daily_max_time")
  end
end

function BattleTimeDataProxy:GetGameTimeSetting()
  return self.gameTimeSetting or BattleTimeDataProxy.ETime.PLAY
end

function BattleTimeDataProxy:GetLeftTime(timeType, consider_switch)
  timeType = timeType or self.gameTimeSetting
  if timeType == BattleTimeDataProxy.ETime.PLAY then
    if consider_switch and not self:CheckSwitchOn(BattleTimeDataProxy.ESwitchType.PLAY) then
      return 0
    else
      return self.playtime - self.usedplaytime
    end
  elseif ISNoviceServerType then
    return 0
  elseif consider_switch and not self:CheckSwitchOn(BattleTimeDataProxy.ESwitchType.BATTLE) then
    return 0
  else
    return self.totaltime - self.timelen
  end
end

function BattleTimeDataProxy:CheckBattleTimelen(include_PlayTime)
  local threshold = GameConfig.TeamExpRaid.sysmsg_remind_battletime
  if ISNoviceServerType then
    return threshold <= self:GetLeftTime(BattleTimeDataProxy.ETime.PLAY)
  else
    if threshold > self:GetLeftTime(BattleTimeDataProxy.ETime.BATTLE) then
      if include_PlayTime then
        return threshold <= self:GetLeftTime(BattleTimeDataProxy.ETime.PLAY)
      end
      return false
    end
    return true
  end
end

function BattleTimeDataProxy:GetStatus()
  return self.status
end

function BattleTimeDataProxy:TotalTimeLen(sec)
  if ISNoviceServerType then
    return self:GetDailyMaxKillNum()
  else
    return GetValue(self.totaltime, sec)
  end
end

function BattleTimeDataProxy:Timelen(sec)
  if ISNoviceServerType then
    return self.dailyKillNum
  else
    return GetValue(self.timelen, sec)
  end
end

function BattleTimeDataProxy:TotalPlayTime(sec)
  return GetValue(self.playtime, sec)
end

function BattleTimeDataProxy:TotalPlaytime_extra(sec)
  return GetValue(self.total_playtime_extra, sec)
end

function BattleTimeDataProxy:TotalPlaytime_extra_daily(sec)
  return GetValue(self.total_playtime_extra_daily, sec)
end

function BattleTimeDataProxy:UsedPlayTime(sec)
  return GetValue(self.usedplaytime, sec)
end

function BattleTimeDataProxy:TutorTime(sec)
  return GetValue(self.tutortime, sec)
end

function BattleTimeDataProxy:MusicTime(sec)
  return GetValue(self.musictime, sec)
end

function BattleTimeDataProxy:PowerTime(sec)
  return GetValue(self.powertime, sec)
end

function BattleTimeDataProxy:GetDailyMaxKillNum()
  return self.dailyKillMaxNum
end

function BattleTimeDataProxy.KillCountEachRound()
  if not BattleTimeDataProxy.killCountEachRound then
    BattleTimeDataProxy.killCountEachRound = GameConfig.BattleTime and GameConfig.BattleTime.killCountEachRound or 500
  end
  return BattleTimeDataProxy.killCountEachRound
end

function BattleTimeDataProxy:GetMaxRewardRound()
  return self:GetDailyMaxKillNum() / BattleTimeDataProxy.KillCountEachRound()
end

function BattleTimeDataProxy:GetCurRewardRound()
  local max = self:GetMaxRewardRound()
  local result = self:Timelen() // BattleTimeDataProxy.KillCountEachRound() + 1
  return math.min(result, max)
end

function BattleTimeDataProxy:GetSpareBattleTime()
  local spare_play_time = self:GetLeftTime(BattleTimeDataProxy.ETime.PLAY)
  local spare_battle_time = self:GetLeftTime(BattleTimeDataProxy.ETime.BATTLE)
  return spare_battle_time + spare_play_time
end

function BattleTimeDataProxy:GetDifferenceCostTime(costTime)
  if not costTime then
    return
  end
  local time = self:GetLeftTime()
  if 0 < time and costTime > time then
    local timeType = self:GetGameTimeSetting()
    local reverseTime = self:GetLeftTime(BattleTimeDataProxy.ReverseType[timeType])
    if costTime <= reverseTime + time then
      local differenceCostTime = (costTime - time) // 60
      return differenceCostTime
    end
  end
end
