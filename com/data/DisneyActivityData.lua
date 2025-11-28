DisneyActivityData = class("DisneyActivityData")
local daySec = 86400
local st, et, cur
local transWeekDay = function(time)
  local curDay = os.date("*t", time)
  local weekDay = curDay.wday - 1
  if weekDay == 0 then
    weekDay = 7
  end
  return weekDay
end
DisneyActivityData.AcivityStatus = {
  ENone = 0,
  ERunning = 1,
  EOpen_Sooner = 2,
  EOpen_Later = 3,
  EClosed = 4
}

function DisneyActivityData:ctor(staticData)
  self.staticData = staticData
  self.id = staticData.id
  self.isMickeyActive = false
  self.hasGetMickeyReward = false
  self.isRelease = EnvChannel.IsReleaseBranch()
  self:SetRewards()
  self:SetTime()
end

function DisneyActivityData:SetRewards()
  local rewards = self.staticData.Rewards
  if rewards then
    self.rewards = {}
    for i = 1, #rewards do
      local rewardItem = ItemData.new("DisneyActivityReward", rewards[i][1])
      rewardItem:SetItemNum(rewards[i][2])
      self.rewards[#self.rewards + 1] = rewardItem
    end
  end
end

function DisneyActivityData:GetRewards()
  return self.rewards or _EmptyTable
end

function DisneyActivityData:GetRewardByDayIndex(index)
  return self.rewards and self.rewards[index] or _EmptyTable
end

function DisneyActivityData:SetActiveFlag()
  self.isMickeyActive = true
end

function DisneyActivityData:SetGetRewardFlag()
  self.hasGetMickeyReward = true
end

function DisneyActivityData:HasMickey()
  return self.staticData and nil ~= self.staticData.MickeyItemId and 0 ~= self.staticData.MickeyItemId or false
end

function DisneyActivityData:CheckCanGetReward()
  return self:HasMickey() and self.isMickeyActive and not self.hasGetMickeyReward
end

function DisneyActivityData:GetHelpDesc()
  return self.staticData and self.staticData.HelpID and Table_Help[self.staticData.HelpID] and Table_Help[self.staticData.HelpID].Desc or nil
end

function DisneyActivityData:IsMickeyActive()
  return self.isMickeyActive
end

function DisneyActivityData:GetTimeDesc()
  return self.staticData.TimeDesc or ""
end

local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local parseStamp = function(str)
  local year, month, day, hour, min, sec = str:match(p)
  return os.time({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  })
end

function DisneyActivityData:SetTime()
  self.startTime = self.isRelease and self.staticData.StartTime or self.staticData.TfStartTime
  self.endTime = self.isRelease and self.staticData.EndTime or self.staticData.TfEndTime
  self.startTime = parseStamp(self.startTime)
  self.endTime = parseStamp(self.endTime)
  self:SetIntervalTime()
  self:ResetStatus()
end

function DisneyActivityData:SetIntervalTime()
  local staticTimes = self.staticData.Time
  if staticTimes and 0 < #staticTimes then
    self.timeMap = {}
    for i = 1, #staticTimes do
      local single = staticTimes[i]
      local wday = single.wday
      local sSec = single.hour * 3600 + single.min * 60 + single.sec
      local eSec = sSec + single.duration
      self.timeMap[wday] = {sSec, eSec}
    end
  end
end

function DisneyActivityData:ResetStatus()
  self.status = DisneyActivityData.AcivityStatus.ENone
  local differenceDays = DisneyStageProxy.Instance:GetIntervalDays()
  if not differenceDays then
    return
  end
  differenceDays = differenceDays * daySec
  st, et = self.startTime, self.endTime
  local cur = ServerTime.CurServerTime() / 1000
  if cur > st and cur < et then
    self.status = DisneyActivityData.AcivityStatus.ERunning
  elseif cur > et then
    self.status = DisneyActivityData.AcivityStatus.EClosed
  elseif st < differenceDays + cur then
    self.status = DisneyActivityData.AcivityStatus.EOpen_Sooner
  else
    self.status = DisneyActivityData.AcivityStatus.EOpen_Later
  end
  return self.status
end

function DisneyActivityData:CheckCanShow()
  if self.staticData.Type == 2 then
    return self:IsGuideActivityRunning()
  else
    return true
  end
end

function DisneyActivityData:IsComming()
  return self:IsOpenLater() or self:IsOpenSooner()
end

function DisneyActivityData:IsOpenLater()
  return self.status == DisneyActivityData.AcivityStatus.EOpen_Later
end

function DisneyActivityData:IsOpenSooner()
  return self.status == DisneyActivityData.AcivityStatus.EOpen_Sooner
end

function DisneyActivityData:IsGuideActivityRunning()
  return self.status == DisneyActivityData.AcivityStatus.ERunning
end

function DisneyActivityData:IsRunning()
  if self.status ~= DisneyActivityData.AcivityStatus.ERunning then
    return false
  end
  if nil ~= self.timeMap then
    local curServerTime = ServerTime.CurServerTime() / 1000
    local weekDay = transWeekDay(curServerTime)
    local curDay = os.date("*t", curServerTime)
    local daySecs = curDay.hour * 3600 + curDay.min * 60 + curDay.sec
    local timeData = self.timeMap[weekDay]
    if nil ~= timeData and daySecs > timeData[1] and daySecs < timeData[2] then
      return true
    end
    return false
  else
    return true
  end
end

function DisneyActivityData:IsClosed()
  return self.status == DisneyActivityData.AcivityStatus.EClosed
end
