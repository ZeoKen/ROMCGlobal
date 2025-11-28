ServerTime = class("ServerTime")
local TimeZoneConfig = {NOTW = 8}
ServerTime.CacheUnscaledTime = 0
ServerTime.SERVER_TIMEZONE = nil
ServerTime.DATE_TIMEZONE = nil
ServerTime.Ori_OsDate = os.date

function os.date(fmt, time)
  if ServerTime.DATE_TIMEZONE and time then
    time = time + 3600 * ServerTime.DATE_TIMEZONE
    local date = ServerTime.Ori_OsDate("!" .. fmt, time)
    if date.isdst then
      date = ServerTime.Ori_OsDate("!" .. fmt, time - 3600)
      date.isdst = false
    end
    return date
  end
  local date = ServerTime.Ori_OsDate(fmt, time)
  if date.isdst and time then
    date = ServerTime.Ori_OsDate(fmt, time - 3600)
    date.isdst = false
  end
  return date
end

ServerTime.Ori_OsTime = os.time

function os.time(date)
  if date then
    date.isdst = false
  end
  local result = ServerTime.Ori_OsTime(date)
  if not date or not ServerTime.SERVER_TIMEZONE then
    return result
  end
  local localTimeZone = tonumber(ServerTime.Ori_OsDate("%z", 0)) / 100
  return result - (ServerTime.SERVER_TIMEZONE - localTimeZone) * 3600
end

function ServerTime.ClampClientTime()
  ServerTime.clamp = ServerTime.CurClientTime()
end

function ServerTime.InitTime(serverTime, timeZone)
  if type(timeZone) == "number" then
    if timeZone < -12 or 12 < timeZone then
      redlog("TimeZone Param Error：", timeZone)
    else
      ServerTime.SERVER_TIMEZONE = timeZone
      local timezone = TimeZoneConfig[BranchMgr.GetBranchName()]
      ServerTime.DATE_TIMEZONE = timezone or ServerTime.SERVER_TIMEZONE
    end
  end
  if not ServerTime.SERVER_TIMEZONE then
    redlog("没有设置服务器时区，临时使用系统时区")
    ServerTime.SERVER_TIMEZONE = tonumber(ServerTime.Ori_OsDate("%z", 0)) / 100
  end
  local dataFormat = "%Y-%m-%d %H:%M:%S"
  ServerTime.serverTimeStamp = serverTime
  ServerTime.clientTimeStamp = ServerTime.CurClientTime()
  ServerTime.deltaStamp = ServerTime.serverTimeStamp - ServerTime.clientTimeStamp
  if ServerTime.clamp then
    ServerTime.deltaStamp = ServerTime.deltaStamp + (ServerTime.CurClientTime() - ServerTime.clamp)
  end
  if ServerTime.timeTick == nil then
    ServerTime.timeTick = TimeTickManager.Me():CreateTick(0, 33, ServerTime.Update, ServerTime, 1, true)
  end
  ServerTime.Update()
end

function ServerTime.SetServerOpenTime(time)
  if time <= 0 then
    time = ServerTime.ServerTime / 1000
  end
  ServerTime.serverOpenTime = time
  local date = os.date("*t", time)
  ServerTime.formatServerOpenTime = os.time({
    year = date.year,
    month = date.month,
    day = date.day,
    hour = 5
  })
end

function ServerTime.GetServerOpenTime()
  return ServerTime.serverOpenTime
end

function ServerTime.GetFormatServerOpenTime()
  return ServerTime.formatServerOpenTime or 0
end

function ServerTime.GetServerOpenWeekday()
  return tonumber(os.date("%w", ServerTime.GetServerOpenTime()))
end

function ServerTime.StampClientSend()
  ServerTime.clientStamp = ServerTime.CurServerTime()
end

function ServerTime.CurServerTime()
  return ServerTime.ServerTime
end

function ServerTime.CurServerWeek()
  return tonumber(os.date("%W", ServerTime.ServerTime / 1000))
end

function ServerTime.CurClientTime()
  return (UnityRealtimeSinceStartup or 0) * 1000
end

function ServerTime.ServerDeltaSecondTime(serverTime, curServerTime)
  return ServerTime.ServerDeltaMillTime(serverTime, curServerTime) / 1000
end

function ServerTime.ServerDeltaMillTime(serverTime, curServerTime)
  curServerTime = curServerTime or ServerTime.CurServerTime()
  return serverTime - curServerTime
end

function ServerTime.Update(owner, deltaTime)
  ServerTime.ServerTime = ServerTime.CurClientTime() + ServerTime.deltaStamp
  ServerTime.CacheUnscaledTime = UnityUnscaledTime
end

function ServerTime.GetDayStartTimestamp()
  local timetable = os.date("*t", ServerTime.ServerTime / 1000)
  local delta = timetable.hour * 3600 + timetable.min * 60 + timetable.sec
  return ServerTime.ServerTime / 1000 - delta
end

function ServerTime.GetAMPMString()
  local timetable = os.date("*t", ServerTime.ServerTime / 1000)
  local hour = timetable.hour
  if 0 <= hour and hour < 12 then
    return "AM"
  else
    return "PM"
  end
  ServerTime.CacheUnscaledTime = UnityUnscaledTime
end

function ServerTime.GetStartTimestamp(timestamp)
  timestamp = timestamp or ServerTime.ServerTime / 1000
  local timetable = os.date("*t", timestamp)
  local delta = timetable.hour * 3600 + timetable.min * 60 + timetable.sec
  return timestamp - delta
end

function ServerTime.GetGameStartTimestamp(timestamp)
  local timetable = os.date("*t", timestamp)
  local delta = (timetable.hour - 5) * 3600 + timetable.min * 60 + timetable.sec
  return timestamp - delta
end

function ServerTime.GetPastGameStartTimestamp(timestamp)
  timestamp = timestamp or ServerTime.ServerTime / 1000
  local timetable = os.date("*t", timestamp)
  local delta = (timetable.hour - 5) * 3600 + timetable.min * 60 + timetable.sec
  local result = timestamp - delta
  if delta < 0 then
    result = result - 86400
  end
  return result
end

ServerTime.DayPhase = {
  Dawn = 1,
  Day = 2,
  Dusk = 3,
  Night = 4
}

function ServerTime.GetDayPhase()
  local timetable = os.date("*t", (ServerTime.ServerTime or 0) / 1000)
  local hour = timetable.hour % 6 * 6
  if 4 <= hour and hour < 6 then
    return ServerTime.DayPhase.Dawn
  elseif 6 <= hour and hour < 18 then
    return ServerTime.DayPhase.Day
  elseif 18 <= hour and hour < 20 then
    return ServerTime.DayPhase.Dusk
  else
    return ServerTime.DayPhase.Night
  end
end

function ServerTime.GetWeekStartTimeStamp(timestamp)
  local timetable = os.date("*t", timestamp)
  return timestamp - (((timetable.wday + 5) % 7 * 24 + timetable.hour) * 60 + timetable.min) * 60 - timetable.sec
end
