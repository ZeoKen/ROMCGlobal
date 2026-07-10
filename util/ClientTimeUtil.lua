ClientTimeUtil = {}
DATA_FORMAT = "%y-%m-%d %H:%M:%S"
local _calendarFormat = "%s/%s %s:%s - %s/%s %s:%s"
local _DateMatchFormat = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local _GetServerTimeZone = function()
  if ServerTime.SERVER_TIMEZONE then
    return ServerTime.SERVER_TIMEZONE
  end
  return tonumber(ServerTime.Ori_OsDate("%z", 0)) / 100
end
local _GetServerDate = function(timestamp)
  local timezone = _GetServerTimeZone() or 0
  return ServerTime.Ori_OsDate("!*t", timestamp + timezone * 3600)
end
local _GetTimestampByServerDate = function(serverDate, hour, min, sec, dayOffset)
  return os.time({
    year = serverDate.year,
    month = serverDate.month,
    day = serverDate.day + (dayOffset or 0),
    hour = hour or 0,
    min = min or 0,
    sec = sec or 0
  })
end
local _GetFixedHourTimeByTimeStamp = function(timestamp, hour, min, sec)
  local serverDate = _GetServerDate(timestamp)
  return _GetTimestampByServerDate(serverDate, hour, min, sec)
end
local _GetCurrentDailyRefreshTimeByTimeStamp = function(timestamp)
  local refreshTime = _GetFixedHourTimeByTimeStamp(timestamp, 5, 0, 0)
  if timestamp < refreshTime then
    refreshTime = refreshTime - 86400
  end
  return refreshTime
end

function ClientTimeUtil.IsCurTimeInRegion(startStrTime, endStrTime)
  return DateTimeHelper.IsCurTimeInRegion(startStrTime, endStrTime)
end

function ClientTimeUtil.FormatTimeTick(secend, format)
  format = format or "yyyy-MM-dd"
  return DateTimeHelper.FormatTimeTick(secend, format)
end

function ClientTimeUtil.TransTimeStrToTimeTick(startStrTime, compTick, deltaDay)
  return DateTimeHelper.IsTimeInRegionByDeltaDay(startStrTime, compTick, deltaDay)
end

function ClientTimeUtil.GetNowHourMinStr()
  local now = ServerTime.Ori_OsDate("*t")
  return orginStringFormat("%02d:%02d", now.hour, now.min)
end

function ClientTimeUtil.GetFormatOfflineTimeStr(serverTime)
  if serverTime == 0 then
    return ZhString.ClientTimeUtil_Online
  end
  local offlineSec = ServerTime.CurServerTime() / 1000 - serverTime
  if 0 <= offlineSec then
    return ClientTimeUtil.GetFormatTimeStr(serverTime)
  else
    return ZhString.ClientTimeUtil_Online
  end
end

function ClientTimeUtil.GetFormatTimeStr(serverTime)
  local offlineSec = ServerTime.CurServerTime() / 1000 - serverTime
  local offlineMin = math.floor(offlineSec / 60)
  if 0 <= offlineSec then
    if offlineMin < 1 then
      return ZhString.ClientTimeUtil_OfflineSecond
    elseif offlineMin < 60 then
      return string.format(ZhString.ClientTimeUtil_OfflineMinute, offlineMin)
    else
      local offlineHour = math.floor(offlineMin / 60)
      if offlineHour < 24 then
        return string.format(ZhString.ClientTimeUtil_OfflineHour, offlineHour)
      else
        local offlineDay = math.floor(offlineHour / 24)
        if offlineDay < 7 then
          return string.format(ZhString.ClientTimeUtil_OfflineDay, offlineDay)
        else
          local offlineWeek = math.floor(offlineDay / 7)
          if offlineWeek < 4 or offlineDay < 30 then
            return string.format(ZhString.ClientTimeUtil_OfflineWeek, offlineWeek)
          else
            local offlineMonth = math.floor(offlineWeek / 4)
            return string.format(ZhString.ClientTimeUtil_OfflineMonth, offlineMonth)
          end
        end
      end
    end
  end
  return ZhString.ClientTimeUtil_OfflineSecond
end

function ClientTimeUtil.GetFormatDayTimeStr(serverTime)
  local offlineSec = ServerTime.CurServerTime() / 1000 - serverTime
  local offlineDay = math.floor(offlineSec / 86400)
  if offlineDay < 1 then
    return ZhString.ClientTimeUtil_OfflineToday
  else
    return string.format(ZhString.ClientTimeUtil_OfflineDay, offlineDay)
  end
end

function ClientTimeUtil.GetFormatRefreshTimeStr(refreshtime)
  if refreshtime == 0 then
    return ZhString.ClientTimeUtil_Online
  end
  return ClientTimeUtil.FormatTimeBySec(refreshtime - ServerTime.CurServerTime() / 1000)
end

function ClientTimeUtil.GetFormatSecTimeStr(totalSec)
  local minSec = 60
  local min = math.floor(totalSec / minSec)
  local sec = math.floor(totalSec - min * minSec)
  return min, sec
end

function ClientTimeUtil.GetHourMinSec(totalSec)
  return math.floor(totalSec / 3600), math.floor(math.fmod(totalSec, 3600) / 60), math.floor(math.fmod(totalSec, 60))
end

function ClientTimeUtil.FormatTimeBySec(totalSec)
  totalSec = math.floor(totalSec)
  local dir = totalSec < 0 and -1 or 1
  totalSec = dir * totalSec
  local day = totalSec // 86400
  local hour = (totalSec - day * 86400) // 3600
  local min = (totalSec - day * 86400 - hour * 3600) // 60
  local sec = totalSec - day * 86400 - hour * 3600 - min * 60
  return day * dir, hour * dir, min * dir, sec * dir
end

function ClientTimeUtil.GetNowAMPM()
  local now = ServerTime.Ori_OsDate("*t")
  if now.hour >= 0 and now.hour < 12 then
    return "AM"
  else
    return "PM"
  end
end

function ClientTimeUtil.GetDailyRefreshTime()
  local mycreatetime = Game.Myself.data.userdata:Get(UDEnum.CREATETIME) or 0
  return _GetCurrentDailyRefreshTimeByTimeStamp(mycreatetime)
end

function ClientTimeUtil.GetNextDailyRefreshTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  return ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(curServerTime)
end

function ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(timestamp)
  if not timestamp then
    return
  end
  return _GetCurrentDailyRefreshTimeByTimeStamp(timestamp) + 86400
end

function ClientTimeUtil.GetCurrentDaily5ClockTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  return _GetCurrentDailyRefreshTimeByTimeStamp(curServerTime)
end

function ClientTimeUtil.GetNextDaily5ClockTime(interval)
  return ClientTimeUtil.GetCurrentDaily5ClockTime() + interval * 86400
end

function ClientTimeUtil.GetWeeklyRefreshTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local serverDate = _GetServerDate(curServerTime)
  local weekDay = serverDate.wday - 1
  if weekDay == 0 then
    weekDay = 7
  end
  local todayRefreshTime = _GetTimestampByServerDate(serverDate, 5, 0, 0)
  if weekDay == 1 and curServerTime < todayRefreshTime then
    return todayRefreshTime
  end
  local diffDays = 8 - weekDay
  if diffDays <= 0 then
    diffDays = diffDays + 7
  end
  return todayRefreshTime + diffDays * 86400
end

function ClientTimeUtil.GetOSDateTime(format_Time)
  if not StringUtil.IsEmpty(format_Time) then
    local year, month, day, hour, min, sec = format_Time:match(_DateMatchFormat)
    local dateTab = ReusableTable.CreateTable()
    dateTab.year = year
    dateTab.month = month
    dateTab.day = day
    dateTab.hour = hour
    dateTab.min = min
    dateTab.sec = sec
    local timeDate = os.time(dateTab)
    ReusableTable.DestroyAndClearTable(dateTab)
    return timeDate
  end
end

function ClientTimeUtil.IsSameDay(lastTimeStamp, newTimeStamp)
  local lastMidNight = ServerTime.GetStartTimestamp(lastTimeStamp)
  local newMidNight = ServerTime.GetStartTimestamp(newTimeStamp)
  local delta = newMidNight - lastMidNight
  return -2 < delta and delta < 2
end

function ClientTimeUtil.GetTimeStampByWeekday(wday, hour, min, sec)
  local curTime = ServerTime.CurServerTime() / 1000
  local curDate = _GetServerDate(curTime)
  local curWday = (curDate.wday - 1) % 7
  curWday = 0 < curWday and curWday or 7
  local diffWday = wday - curWday
  local timeStamp = _GetTimestampByServerDate(curDate, hour, min, sec, diffWday)
  return timeStamp
end

local _ymdMatchFormat = "(%d+)-(%d+)-(%d+)"

function ClientTimeUtil.GetYMDByTimeFormat(formatStr)
  local y, m, d = formatStr:match(_ymdMatchFormat)
  return y, m, d
end

local _matchFormat = "(%d+):(%d+):(%d+)"

function ClientTimeUtil.GetHMSByTimeFormat(formatStr)
  local h, m, s = formatStr:match(_matchFormat)
  return h, m, s
end

function ClientTimeUtil.ConvertTimeToDateFormat(dateTimeStr)
  local year, month, day = ClientTimeUtil.GetYMDByTimeFormat(dateTimeStr)
  if year and month and day then
    return string.format("%s-%s-%s", year, month, day)
  end
  return dateTimeStr
end

function ClientTimeUtil.GetServerHourMinStr()
  local serverTime = ServerTime.CurServerTime() / 1000
  local now = _GetServerDate(serverTime)
  return string.format("%02d:%02d", now.hour, now.min)
end

function ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(timestamp)
  if not timestamp then
    return nil
  end
  return _GetFixedHourTimeByTimeStamp(timestamp, 5, 0, 0)
end

function ClientTimeUtil.GetTimeDate(st, et, strFormat)
  local startMonth = os.date("%m", st)
  local startDay = os.date("%d", st)
  local startHour = os.date("%H", st)
  local startMin = os.date("%M", st)
  local endMonth = os.date("%m", et)
  local endDay = os.date("%d", et)
  local endHour = os.date("%H", et)
  local endMin = os.date("%M", et)
  strFormat = strFormat or _calendarFormat
  return string.format(strFormat, startMonth, startDay, startHour, startMin, endMonth, endDay, endHour, endMin)
end
