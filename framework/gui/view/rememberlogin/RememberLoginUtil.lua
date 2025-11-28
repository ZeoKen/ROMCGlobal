RememberLoginUtil = {}
RememberLoginUtil.ConfigID = 104301
RememberLoginUtil.SignInDays = 7

function RememberLoginUtil:GetServerTime()
  return math.floor(ServerTime.CurServerTime() * 0.001)
end

function RememberLoginUtil:GetTimeDate(st, et, strFormat)
  local startMonth = os.date("%m", st)
  local startDay = os.date("%d", st)
  local endMonth = os.date("%m", et)
  local endDay = os.date("%d", et)
  return string.format(strFormat, startMonth, startDay, endMonth, endDay)
end

function RememberLoginUtil:GetCurServerDate(mode)
  local serverTime = self:GetServerTime()
  local year = tonumber(os.date("%Y", serverTime))
  local month = tonumber(os.date("%m", serverTime))
  local day = tonumber(os.date("%d", serverTime))
  if mode == "Point" then
    return string.format("%d.%d.%d", year, month, day)
  elseif mode == "YMD" then
    return year, month, day
  else
    return string.format("%d/%d/%d", year, month, day)
  end
end

function RememberLoginUtil:GetTimestampByStrHMS(timeStr, offsetDay)
  local curTime = self:GetServerTime()
  curTime = curTime + (offsetDay and offsetDay * 86400 or 0)
  local st_year, st_month, st_day = os.date("%Y", curTime), os.date("%m", curTime), os.date("%d", curTime)
  local st_hour, st_min, st_sec = StringUtil.GetDateDataEx(timeStr)
  return math.floor(os.time({
    day = st_day,
    month = st_month,
    year = st_year,
    hour = st_hour,
    min = st_min,
    sec = st_sec
  }))
end

function RememberLoginUtil:GetTimeByHHMMSS(seconds, mode)
  local hours = math.floor(seconds / 3600)
  seconds = seconds - hours * 3600
  local minutes = math.floor(seconds / 60)
  seconds = seconds - minutes * 60
  if mode ~= nil and mode == 2 then
    return 0 < minutes and string.format("%02d:%02d", hours, minutes) or "00:01"
  else
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
  end
end
