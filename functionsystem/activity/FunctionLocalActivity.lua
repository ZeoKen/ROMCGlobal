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
end

function FunctionLocalActivity:OnLeaveScene()
  redlog("FunctionLocalActivity", "OnLeaveScene")
  self:ClearPendingLocalActivity()
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
  startFromMS = startFromMS / durationMS
  local on_plot_end = function(param, result, plot)
    self.localActivityPlots[plot.pqtl] = nil
  end
  Game.PlotStoryManager:Launch(true)
  local plot_id = Game.PlotStoryManager:Start_PQTLP(plotName, on_plot_end, nil, nil, nil, nil, nil, nil, startFromMS)
  self.localActivityPlots[plot_id] = 1
end

function FunctionLocalActivity.GetWeekDay()
  local usWeekDay = os.date("*t", ServerTime.CurServerTime() / 1000).wday - 1
  if usWeekDay == 0 then
    usWeekDay = 7
  end
  return usWeekDay
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
        sec = runtimeCfg[i].sec,
        isdst = false
      }) * 1000
      local delta = ServerTime.CurServerTime() - time
      if delta < runtimeCfg[i].duration * 1000 and (not noNeg or 0 <= delta) then
        return time, delta, runtimeCfg[i].duration * 1000
      end
    end
  end
end
