FunctionLocalActivity = class("FunctionLocalActivity")

function FunctionLocalActivity.Me()
  if nil == FunctionLocalActivity.me then
    FunctionLocalActivity.me = FunctionLocalActivity.new()
  end
  return FunctionLocalActivity.me
end

local MapManager

function FunctionLocalActivity:ctor()
  self.pendingLocalActivityTicks = {}
  self.localActivityPlots = {}
  self.cycleActivityTriggerTimes = {}
  self.pendingCycleActivityTicks = {}
  MapManager = Game.MapManager
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
end

function FunctionLocalActivity:Reset()
  redlog("FunctionLocalActivity", "Reset")
end

function FunctionLocalActivity:OnSceneLoaded()
  redlog("FunctionLocalActivity", "OnSceneLoaded")
  self:ClearPendingLocalActivity()
  self:CheckLocalActivity()
  self:CheckCycleActivity()
end

function FunctionLocalActivity:OnLeaveScene()
  redlog("FunctionLocalActivity", "OnLeaveScene")
  self:ClearPendingLocalActivity()
  self:ClearPendingCycleActivity()
end

function FunctionLocalActivity:HandleReconnect()
  redlog("FunctionLocalActivity", "HandleReconnect")
end

local config = {
  [1] = {
    FuncState = 1,
    RunTime = {
      {
        day = 5,
        hour = 12,
        min = 0,
        duration = 900
      },
      {
        day = 5,
        hour = 13,
        min = 0,
        duration = 900
      }
    },
    Type = "Plot_Action",
    Param = {PlotId = "1111"},
    RestrictMap = {1001}
  }
}

function FunctionLocalActivity:CheckLocalActivity()
  if not GameConfig.LocalActivity or not GameConfig.LocalActivity.ActivityList then
    return
  end
  local curMapId = MapManager:GetMapID()
  for k, cfg in pairs(GameConfig.LocalActivity.ActivityList) do
    local inRestrictMap = not cfg.RestrictMap or TableUtility.ArrayFindIndex(cfg.RestrictMap, curMapId) ~= 0
    if inRestrictMap and not FunctionUnLockFunc.checkFuncStateValid(cfg.FuncState) then
      self:SetupLocalActivityClock(k, cfg)
    end
  end
end

function FunctionLocalActivity:SetupLocalActivityClock(k, cfg)
  cfg = cfg or GameConfig.LocalActivity.ActivityList[k]
  local startTimeMS, curDeltaMS, durationMS = FunctionLocalActivity.GetStartTimeMSFromRuntime(cfg.RunTime)
  if startTimeMS and curDeltaMS and durationMS then
    if curDeltaMS < -50 then
      redlog("SetupLocalActivityClock", "pending start", 1 - curDeltaMS, ServerTime.CurServerTime())
      self.pendingLocalActivityTicks[k] = TimeTickManager.Me():CreateOnceDelayTick(1 - curDeltaMS, function(owner, deltaTime)
        self:ExecuteLocalActivity(k, cfg, durationMS)
      end, self)
    else
      redlog("SetupLocalActivityClock", "start right now", curDeltaMS, ServerTime.CurServerTime())
      self:ExecuteLocalActivity(k, cfg, durationMS, math.max(0, curDeltaMS))
    end
  end
end

function FunctionLocalActivity:ClearPendingLocalActivity()
  TimeTickManager.Me():ClearTick(self)
  TableUtility.TableClear(self.pendingLocalActivityTicks)
  for k, _ in pairs(self.localActivityPlots) do
    Game.PlotStoryManager:StopProgressById(k)
    redlog("LocalActivity_Plot_Action", "演出停止 plot_id:", k)
  end
  TableUtility.TableClear(self.localActivityPlots)
end

function FunctionLocalActivity:ExecuteLocalActivity(k, cfg, durationMS, startFromMS)
  if self["LocalActivity_" .. cfg.Type] then
    self["LocalActivity_" .. cfg.Type](self, cfg, durationMS, startFromMS)
  end
  redlog("ExecuteLocalActivity", "pending next check(after this end)", durationMS - (startFromMS or 0) + 1, ServerTime.CurServerTime())
  self.pendingLocalActivityTicks[k] = TimeTickManager.Me():CreateOnceDelayTick(durationMS - (startFromMS or 0) + 1, function(owner, deltaTime)
    self:SetupLocalActivityClock(k, cfg)
  end, self)
end

function FunctionLocalActivity:LocalActivity_Plot_Action(cfg, durationMS, startFromMS)
  local plotName = cfg and cfg.Param and cfg.Param.PlotId
  if not plotName or not durationMS then
    return
  end
  startFromMS = startFromMS or 0
  local progressRatio = startFromMS / durationMS
  redlog("LocalActivity_Plot_Action", "演出开启 PlotId:", plotName)
  local on_plot_end = function(param, result, plot)
    self.localActivityPlots[plot.pqtl] = nil
    redlog("LocalActivity_Plot_Action", "演出结束 PlotId:", plotName)
  end
  Game.PlotStoryManager:Launch(true)
  local plot_id = Game.PlotStoryManager:Start_PQTLP(plotName, on_plot_end, nil, nil, nil, nil, nil, nil, progressRatio)
  self.localActivityPlots[plot_id] = 1
end

function FunctionLocalActivity.GetWeekDay()
  local usWeekDay = os.date("*t", ServerTime.CurServerTime() / 1000).wday - 1
  if usWeekDay == 0 then
    usWeekDay = 7
  end
  return usWeekDay
end

function FunctionLocalActivity.ParseTimeString(timeStr)
  if not timeStr or timeStr == "" then
    return nil, nil
  end
  local pattern = "(%d+):(%d+)"
  local hour, min = timeStr:match(pattern)
  if not hour then
    return nil, nil
  end
  return tonumber(hour), tonumber(min)
end

function FunctionLocalActivity.GetStartTimeMSFromRuntime(RunTime, noNeg)
  local weekDay = FunctionLocalActivity.GetWeekDay()
  local runtimeCfg = RunTime
  local curDate = os.date("*t", ServerTime.CurServerTime() / 1000)
  for i = 1, #runtimeCfg do
    if runtimeCfg[i].day == weekDay then
      local time = os.time({
        year = curDate.year,
        month = curDate.month,
        day = curDate.day,
        hour = runtimeCfg[i].hour,
        min = runtimeCfg[i].min,
        sec = runtimeCfg[i].sec or 0,
        isdst = false
      }) * 1000
      local delta = ServerTime.CurServerTime() - time
      if delta < runtimeCfg[i].duration * 1000 and (not noNeg or 0 <= delta) then
        return time, delta, runtimeCfg[i].duration * 1000
      end
    end
  end
end

function FunctionLocalActivity.ParseDateTime(timeStr)
  if not timeStr or timeStr == "" then
    return nil
  end
  local pattern = "(%d+)-(%d+)-(%d+)%s+(%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = timeStr:match(pattern)
  if not year then
    return nil
  end
  return os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec),
    isdst = false
  }) * 1000
end

function FunctionLocalActivity.IsInYearlyCycle(startTimeStr, endTimeStr)
  local startTimeMS = FunctionLocalActivity.ParseDateTime(startTimeStr)
  local endTimeMS = FunctionLocalActivity.ParseDateTime(endTimeStr)
  if not startTimeMS or not endTimeMS then
    return false
  end
  local currentMS = ServerTime.CurServerTime()
  local currentDate = os.date("*t", currentMS / 1000)
  local startDate = os.date("*t", startTimeMS / 1000)
  local endDate = os.date("*t", endTimeMS / 1000)
  local cycleStartMS = os.time({
    year = currentDate.year,
    month = startDate.month,
    day = startDate.day,
    hour = startDate.hour,
    min = startDate.min,
    sec = startDate.sec,
    isdst = false
  }) * 1000
  local cycleEndMS = os.time({
    year = currentDate.year,
    month = endDate.month,
    day = endDate.day,
    hour = endDate.hour,
    min = endDate.min,
    sec = endDate.sec,
    isdst = false
  }) * 1000
  if endDate.month < startDate.month or endDate.month == startDate.month and endDate.day < startDate.day then
    if currentDate.month >= startDate.month then
      cycleEndMS = os.time({
        year = currentDate.year + 1,
        month = endDate.month,
        day = endDate.day,
        hour = endDate.hour,
        min = endDate.min,
        sec = endDate.sec,
        isdst = false
      }) * 1000
    else
      cycleStartMS = os.time({
        year = currentDate.year - 1,
        month = startDate.month,
        day = startDate.day,
        hour = startDate.hour,
        min = startDate.min,
        sec = startDate.sec,
        isdst = false
      }) * 1000
    end
  end
  return currentMS >= cycleStartMS and currentMS <= cycleEndMS, cycleStartMS, cycleEndMS
end

function FunctionLocalActivity.IsInMonthlyCycle(startTimeStr, endTimeStr)
  local startTimeMS = FunctionLocalActivity.ParseDateTime(startTimeStr)
  local endTimeMS = FunctionLocalActivity.ParseDateTime(endTimeStr)
  if not startTimeMS or not endTimeMS then
    return false
  end
  local currentMS = ServerTime.CurServerTime()
  local currentDate = os.date("*t", currentMS / 1000)
  local startDate = os.date("*t", startTimeMS / 1000)
  local endDate = os.date("*t", endTimeMS / 1000)
  local cycleStartMS = os.time({
    year = currentDate.year,
    month = currentDate.month,
    day = startDate.day,
    hour = startDate.hour,
    min = startDate.min,
    sec = startDate.sec,
    isdst = false
  }) * 1000
  local cycleEndMS = os.time({
    year = currentDate.year,
    month = currentDate.month,
    day = endDate.day,
    hour = endDate.hour,
    min = endDate.min,
    sec = endDate.sec,
    isdst = false
  }) * 1000
  if endDate.day < startDate.day then
    local nextMonth = currentDate.month + 1
    local nextYear = currentDate.year
    if 12 < nextMonth then
      nextMonth = 1
      nextYear = nextYear + 1
    end
    if currentDate.day >= startDate.day then
      cycleEndMS = os.time({
        year = nextYear,
        month = nextMonth,
        day = endDate.day,
        hour = endDate.hour,
        min = endDate.min,
        sec = endDate.sec,
        isdst = false
      }) * 1000
    else
      local prevMonth = currentDate.month - 1
      local prevYear = currentDate.year
      if prevMonth < 1 then
        prevMonth = 12
        prevYear = prevYear - 1
      end
      cycleStartMS = os.time({
        year = prevYear,
        month = prevMonth,
        day = startDate.day,
        hour = startDate.hour,
        min = startDate.min,
        sec = startDate.sec,
        isdst = false
      }) * 1000
    end
  end
  return currentMS >= cycleStartMS and currentMS <= cycleEndMS, cycleStartMS, cycleEndMS
end

function FunctionLocalActivity:LoadFireworkActivities()
  if not Table_ActivityNew then
    return {}
  end
  local fireworkActivities = {}
  for id, actCfg in pairs(Table_ActivityNew) do
    if actCfg.Type == "firework" and actCfg.StartTime and actCfg.EndTime and actCfg.Cycle then
      fireworkActivities[id] = actCfg
    end
  end
  return fireworkActivities
end

function FunctionLocalActivity:ClearPendingCycleActivity()
  TimeTickManager.Me():ClearTick(self)
  TableUtility.TableClear(self.pendingCycleActivityTicks)
end

function FunctionLocalActivity:CheckCycleActivity()
  if not GameConfig.LocalActivity or not GameConfig.LocalActivity.CycleActivityList then
    return
  end
  local curMapId = MapManager:GetMapID()
  for k, cfg in pairs(GameConfig.LocalActivity.CycleActivityList) do
    local inRestrictMap = not cfg.RestrictMap or TableUtility.ArrayFindIndex(cfg.RestrictMap, curMapId) ~= 0
    if inRestrictMap then
      self:SetupCycleActivityClock(k, cfg)
    end
  end
end

function FunctionLocalActivity:SetupCycleActivityClock(k, cfg)
  if not cfg.RunTime then
    redlog("SetupCycleActivityClock", "No RunTime config for activity", k)
    return
  end
  local runTime = cfg.RunTime
  if runTime.Day and #runTime.Day > 0 then
    local currentWeekDay = FunctionLocalActivity.GetWeekDay()
    local dayMatch = false
    for _, day in ipairs(runTime.Day) do
      if day == currentWeekDay then
        dayMatch = true
        break
      end
    end
    if not dayMatch then
      return
    end
  end
  local startHour, startMin = FunctionLocalActivity.ParseTimeString(runTime.StartTime)
  local endHour, endMin = FunctionLocalActivity.ParseTimeString(runTime.EndTime)
  if not startHour or not endHour then
    return
  end
  local currentMS = ServerTime.CurServerTime()
  local currentDate = os.date("*t", currentMS / 1000)
  local todayStartMS = os.time({
    year = currentDate.year,
    month = currentDate.month,
    day = currentDate.day,
    hour = startHour,
    min = startMin,
    sec = 0,
    isdst = false
  }) * 1000
  local todayEndMS = os.time({
    year = currentDate.year,
    month = currentDate.month,
    day = currentDate.day,
    hour = endHour,
    min = endMin,
    sec = 0,
    isdst = false
  }) * 1000
  if todayStartMS >= todayEndMS then
    todayEndMS = todayEndMS + 86400000
  end
  if currentMS < todayStartMS then
    self.pendingCycleActivityTicks[k] = TimeTickManager.Me():CreateOnceDelayTick(todayStartMS - currentMS, function(owner, deltaTime)
      self:SetupCycleActivityClock(k, cfg)
    end, self)
    return
  end
  if currentMS >= todayEndMS then
    return
  end
  local intervalMS = (runTime.Interval or 180) * 1000
  local durationMS = (runTime.Duration or 150) * 1000
  local elapsedFromStart = currentMS - todayStartMS
  local shouldTriggerCount = math.floor(elapsedFromStart / intervalMS)
  local nextTriggerMS = todayStartMS + (shouldTriggerCount + 1) * intervalMS
  local currentTriggerStartMS = todayStartMS + shouldTriggerCount * intervalMS
  local currentTriggerEndMS = currentTriggerStartMS + durationMS
  if currentMS >= currentTriggerStartMS and currentMS < currentTriggerEndMS then
    local elapsedInActivity = currentMS - currentTriggerStartMS
    self:ExecuteCycleActivity(k, cfg, durationMS, elapsedInActivity)
    self.cycleActivityTriggerTimes[k] = currentTriggerStartMS
    local delayToNext = nextTriggerMS - currentMS
    if todayEndMS > nextTriggerMS then
      self:ScheduleCycleActivity(k, cfg, delayToNext)
    end
  elseif todayEndMS > nextTriggerMS then
    local delayToNext = nextTriggerMS - currentMS
    self:ScheduleCycleActivity(k, cfg, delayToNext)
  end
end

function FunctionLocalActivity:ScheduleCycleActivity(k, cfg, delayMS)
  if delayMS <= 0 then
    self:SetupCycleActivityClock(k, cfg)
    return
  end
  self.pendingCycleActivityTicks[k] = TimeTickManager.Me():CreateOnceDelayTick(delayMS, function(owner, deltaTime)
    local durationMS = (cfg.RunTime.Duration or 150) * 1000
    self:ExecuteCycleActivity(k, cfg, durationMS)
    self.cycleActivityTriggerTimes[k] = ServerTime.CurServerTime()
    self:SetupCycleActivityClock(k, cfg)
  end, self)
end

function FunctionLocalActivity:ExecuteCycleActivity(k, cfg, durationMS, startFromMS)
  if self["LocalActivity_" .. cfg.Type] then
    self["LocalActivity_" .. cfg.Type](self, cfg, durationMS, startFromMS)
  end
end
