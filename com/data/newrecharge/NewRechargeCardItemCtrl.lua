NewRechargeCardItemCtrl = class("NewRechargeCardItemCtrl")

function NewRechargeCardItemCtrl:Ins()
  if NewRechargeCardItemCtrl.ins == nil then
    NewRechargeCardItemCtrl.ins = NewRechargeCardItemCtrl.new()
  end
  return NewRechargeCardItemCtrl.ins
end

function NewRechargeCardItemCtrl:ctor()
end

function NewRechargeCardItemCtrl.GetMonthCardConfigure()
  local timeOffset = GameConfig.System and GameConfig.System.MonthCardRefreshTime or 0
  local year = NewRechargeProxy.CCard.YearOfServer(-timeOffset)
  local month = NewRechargeProxy.CCard.MonthOfServer(-timeOffset)
  if (BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()) and year == 2018 and month == 10 then
    month = 11
  end
  for _, v in pairs(Table_MonthCard) do
    if v.Year == year and v.Month == month then
      return v
    end
  end
  return nil
end

function NewRechargeCardItemCtrl:Set_TimeOfLatestPurchaseMonthlyVIP(unix_time)
  self.timeOfLatestPurchaseMonthlyVIP = unix_time
end

function NewRechargeCardItemCtrl:Get_TimeOfLatestPurchaseMonthlyVIP()
  return self.timeOfLatestPurchaseMonthlyVIP
end

function NewRechargeCardItemCtrl:Set_TimeOfExpirationMonthlyVIP(unix_time)
  self.timeOfExpirationMonthlyVIP = unix_time
end

function NewRechargeCardItemCtrl:Get_TimeOfExpirationMonthlyVIP()
  return self.timeOfExpirationMonthlyVIP
end

function NewRechargeCardItemCtrl:AmIMonthlyVIP()
  local currentServerTime = ServerTime.CurServerTime()
  if currentServerTime ~= nil then
    currentServerTime = currentServerTime / 1000
    local timeOfExpirationMonthlyVIP = self:Get_TimeOfExpirationMonthlyVIP()
    if timeOfExpirationMonthlyVIP ~= nil and currentServerTime < timeOfExpirationMonthlyVIP then
      return true
    end
  end
  return false
end

function NewRechargeCardItemCtrl:GetMonthCardLeftDays()
  if self.timeOfExpirationMonthlyVIP then
    local currentServerTime = ServerTime.CurServerTime()
    if currentServerTime ~= nil then
      currentServerTime = currentServerTime / 1000
      local timeOfExpirationMonthlyVIP = self:Get_TimeOfExpirationMonthlyVIP()
      local delta = timeOfExpirationMonthlyVIP - currentServerTime
      if delta < 0 then
        return 0
      else
        local days = delta / 3600 / 24
        days = math.ceil(days)
        return days
      end
    end
    return 0
  end
  return nil
end

function NewRechargeCardItemCtrl.YearOfServer(delta)
  local year = 0
  local currentTime = ServerTime.CurServerTime()
  if currentTime ~= nil then
    currentTime = currentTime / 1000
  else
    currentTime = os.time()
  end
  if delta ~= nil then
    currentTime = currentTime + delta
  end
  return NewRechargeCardItemCtrl.YearOfUnixTimestamp(currentTime)
end

function NewRechargeCardItemCtrl.MonthOfServer(delta)
  local month = 0
  local currentTime = ServerTime.CurServerTime()
  if currentTime ~= nil then
    currentTime = currentTime / 1000
  else
    currentTime = os.time()
  end
  if delta ~= nil then
    currentTime = currentTime + delta
  end
  return NewRechargeCardItemCtrl.MonthOfUnixTimestamp(currentTime)
end

function NewRechargeCardItemCtrl.YearOfUnixTimestamp(timestamp)
  local strYear = os.date("%Y", timestamp)
  return tonumber(strYear)
end

function NewRechargeCardItemCtrl.MonthOfUnixTimestamp(timestamp)
  local strMonth = os.date("%m", timestamp)
  return tonumber(strMonth)
end

function NewRechargeCardItemCtrl.DayOfUnixTimestamp(timestamp)
  local strDay = os.date("%d", timestamp)
  return tonumber(strDay)
end

function NewRechargeCardItemCtrl.HourOfUnixTimestamp(timestamp)
  local strHour = os.date("%H", timestamp)
  return tonumber(strHour)
end

function NewRechargeCardItemCtrl.MinuteOfUnixTimestamp(timestamp)
  local strMinute = os.date("%M", timestamp)
  return tonumber(strMinute)
end

function NewRechargeCardItemCtrl.SecondOfUnixTimestamp(timestamp)
  local strSecond = os.date("%S", timestamp)
  return tonumber(strSecond)
end
