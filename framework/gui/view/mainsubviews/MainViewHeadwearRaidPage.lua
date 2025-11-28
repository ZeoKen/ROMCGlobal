MainViewHeadwearRaidPage = class("MainViewHeadwearRaidPage", MainViewDungeonInfoSubPage)
local proxyInstance, tickInstance
local countdownTid = 1
local _GetTimeStateDesc = function()
  if not _timeState then
    local ETimeState = HeadwearRaidProxy.RoundState
    _timeState = {
      [ETimeState.None] = ZhString.MainViewHeadwearRaidPage_New_None,
      [ETimeState.SkipTime] = ZhString.MainViewHeadwearRaidPage_New_skipTime,
      [ETimeState.NextRoundTime] = ZhString.MainViewHeadwearRaidPage_New_NextRound_Time,
      [ETimeState.FuryTime] = ZhString.MainViewHeadwearRaidPage_New_Fury_Time,
      [ETimeState.Default] = ZhString.MainViewHeadwearRaidPage_New_skipTime
    }
  end
  return _timeState[proxyInstance.timeState]
end

function MainViewHeadwearRaidPage:Init()
  proxyInstance = HeadwearRaidProxy.Instance
  tickInstance = TimeTickManager.Me()
  self:ReLoadPerferb("view/MainViewHeadwearRaidPage")
  self:InitView()
  self:AddViewEvents()
end

function MainViewHeadwearRaidPage:InitView()
  self.timetext = self:FindComponent("timetext", UILabel)
  self.timetext.text = ZhString.MainViewHeadwearRaidPage_New_skipTime
  self.round = self:FindComponent("round", UILabel)
  self.roundFixed = self:FindComponent("roundFixed", UILabel)
  self.roundFixed.text = ZhString.MainViewHeadwearRaidPage_New_FixedRound
  self.timeSlider = self:FindComponent("timeSlider", UISlider)
  self.timeLabel = self:FindComponent("timeLabel", UILabel)
  self.timeLabel.text = proxyInstance.CDTime or "20"
end

function MainViewHeadwearRaidPage:AddViewEvents()
  self:AddListenEvt(ServiceEvent.NUserHeadwearRoundUserCmd, self.RecvHeadwearRoundUserCmd)
end

function MainViewHeadwearRaidPage:OnExit()
  self:_ClearTick()
  MainViewHeadwearRaidPage.super.OnExit(self)
end

function MainViewHeadwearRaidPage:RecvHeadwearRoundUserCmd(data)
  self:UpdateCurrentRound()
  self:_ClearTick()
  self:RefreshTimeInfo()
end

function MainViewHeadwearRaidPage:UpdateCurrentRound()
  self.round.text = string.format(ZhString.MainViewHeadwearRaidPage_New_Round, proxyInstance.new_round, proxyInstance.config.maxRound)
end

function MainViewHeadwearRaidPage:_ClearTick()
  if self.countdownTick then
    tickInstance:ClearTick(self, countdownTid)
    self.countdownTick = nil
  end
end

function MainViewHeadwearRaidPage:RefreshTimeInfo()
  self.timetext.text = _GetTimeStateDesc()
  if proxyInstance.timeState == HeadwearRaidProxy.RoundState.None or proxyInstance.timeState == HeadwearRaidProxy.RoundState.Default then
    return
  end
  if proxyInstance.CDTime and proxyInstance.CDTime > 0 then
    self.endTime = ServerTime.CurServerTime() / 1000 + proxyInstance.CDTime
    self.countdownTick = tickInstance:CreateTick(0, 300, self.UpdateCD, self, countdownTid)
  end
end

function MainViewHeadwearRaidPage:UpdateCD()
  local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    leftTime = 0
    self:_ClearTick()
  end
  leftTime = math.floor(leftTime)
  self.timeLabel.text = leftTime
  self.timeSlider.value = leftTime / proxyInstance.CDTime
end
