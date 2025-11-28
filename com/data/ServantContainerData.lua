CalendarActivityData = class("CalendarActivityData")
CalendarActivityData.STATUS = {
  GO = 1,
  CANBOOK = 2,
  BOOKED = 3
}

function CalendarActivityData:ctor(y, m, d)
  self.year = y
  self.month = m
  self.day = d
end

function CalendarActivityData:SetStaticActData(id)
  self.staticData = Table_ServantCalendar[id]
  self.startHour = tonumber(string.sub(self.staticData.StartTime, 1, 2))
  self.endHour = tonumber(string.sub(self.staticData.EndTime, 1, 2))
  self.startMin = tonumber(string.sub(self.staticData.StartTime, 4, 5))
  self.endMin = tonumber(string.sub(self.staticData.EndTime, 4, 5))
  self.startStamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = self.startHour,
    min = self.startMin,
    sec = 0
  })
  self.endStamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = self.endHour,
    min = self.endMin,
    sec = 0
  })
end

local format_sTime = "%s:%s"

function CalendarActivityData:SetConsoleActData(parseData)
  self.staticData = {}
  self.staticData.Name = parseData.name
  self.staticData.Desc = parseData.desc
  self.staticData.Location = parseData.location
  self.staticData.id = parseData.id
  self.startStamp = parseData.eventStarttime
  self.startHour = os.date("%H", self.startStamp)
  self.startMin = os.date("%M", self.startStamp)
  self.endStamp = parseData.evnetEndtime
  self.endHour = os.date("%H", self.endStamp)
  self.endMin = os.date("%M", self.endStamp)
  self.staticData.StartTime = string.format(format_sTime, self.startHour, self.startMin)
  self.staticData.EndTime = string.format(format_sTime, self.endHour, self.endMin)
  self.isConsoleData = true
  self.photourl = parseData.photourl
  self.iconurl = parseData.iconurl
  self.traceType = parseData.trackType
  self.traceData = parseData.trackInfo
end

function CalendarActivityData:IsBooked()
  local datekey = self.isConsoleData and self:GetStartTimeStamp() or self:GetStartTimeStamp(5)
  local books = ServantCalendarProxy.Instance:GetBookingDataByDate(datekey)
  if not books then
    return false
  end
  return 0 ~= TableUtility.ArrayFindIndex(books, self.staticData.id)
end

local FormatNum = function(num)
  if num <= 0 then
    return 0
  else
    local int, floor = math.modf(num)
    if 0 < floor then
      return num
    else
      return int
    end
  end
end

function CalendarActivityData:GetDuringHour()
  local result = (self.endStamp - self.startStamp) / 3600
  if 15 < result then
    return FormatNum(math.floor(result * 100 + 0.5) / 100)
  else
    return FormatNum(result)
  end
end

function CalendarActivityData:IsExpired()
  return ServerTime.CurServerTime() / 1000 > self.endStamp
end

function CalendarActivityData:GetActName()
  return self.staticData.Name
end

function CalendarActivityData:GetStatus()
  if self:IsOnGoing() then
    return CalendarActivityData.STATUS.GO
  elseif self:IsBooked() then
    return CalendarActivityData.STATUS.BOOKED
  elseif self:IsComming() then
    return CalendarActivityData.STATUS.CANBOOK
  end
end

function CalendarActivityData:GetStartTimeStamp(FlagForServer)
  local h = FlagForServer or self.startHour
  local m = FlagForServer and 0 or self.startMin
  local timestamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = h,
    min = m,
    sec = 0
  })
  return timestamp
end

function CalendarActivityData:GetEndTimeStamp()
  local timestamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = self.endHour,
    min = self.endMin,
    sec = 0
  })
  return timestamp
end

local INTERVAL_STAMP = GameConfig.Servant.playNpcTalkTimeStamp

function CalendarActivityData:IsComming()
  local timestamp = self.startStamp
  return timestamp > ServerTime.CurServerTime() / 1000
end

function CalendarActivityData:IsOnGoing()
  local curStamp = ServerTime.CurServerTime() / 1000
  if curStamp < self.endStamp and curStamp > self.startStamp then
    return true
  end
  return false
end

ServantContainerData = class("ServantContainerData")

function ServantContainerData:ctor(year, month, day)
  self.activeData = {}
  self.weekActiveData = {}
  self.year = year
  self.month = month
  self.day = day
  self.weekday = os.date("%a", os.time({
    year = year,
    month = month,
    day = day
  }))
  self.dayStartTime = os.time({
    year = year,
    month = month,
    day = day,
    hour = 5,
    min = 0,
    sec = 0
  })
  self.timeIntervalArray = {}
  self.consoleData = {}
  self:SetActivityData()
  self.weekDisplayData = {}
end

local p = "(%d+)-(%d+)-(%d+)"
local SEVENDAYSEC = 604800

function ServantContainerData:ParseTimeUnit3(frequencyCsv)
  if not frequencyCsv or #frequencyCsv ~= 2 then
    return
  end
  local year, month, day = frequencyCsv[2]:match(p)
  local weekFrequency = frequencyCsv[1]
  local timeUnit3stamp = os.time({
    year = year,
    month = month,
    day = day,
    hour = 5,
    min = 0,
    sec = 0
  })
  local stamp = self.dayStartTime - timeUnit3stamp
  local secs = SEVENDAYSEC * weekFrequency
  return stamp % secs == 0 and 0 <= stamp / secs
end

function ServantContainerData:IsToday()
  local y, m, d = ServantCalendarProxy.GetCurDate()
  return self.year == y and self.month == m and self.day == d
end

function ServantContainerData:GetUIDisplayDay()
  return self.day
end

function ServantContainerData:IsExpired()
  local lastStamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = 23,
    min = 59,
    sec = 59
  })
  return lastStamp < ServerTime.CurServerTime() / 1000
end

function ServantContainerData:SetActivityData()
  if not Table_ServantCalendar then
    return
  end
  local valid
  for k, v in pairs(Table_ServantCalendar) do
    if v.FuncState then
      valid = nil == Table_FuncState[v.FuncState] or FunctionUnLockFunc.checkFuncStateValid(v.FuncState)
      if valid then
        if v.id == 14 then
          valid = WarbandProxy.Instance:CheckCalendarTimeValid(PvpProxy.Type.TeamPwsChampion, self.dayStartTime)
        elseif v.id == 4 then
          valid = WarbandProxy.Instance:CheckCalendarTimeValid(PvpProxy.Type.TeamPws, self.dayStartTime)
        elseif v.id == 12 then
          valid = WarbandProxy.Instance:CheckCalendarTimeValid(PvpProxy.Type.TwelvePVPBattle, self.dayStartTime)
        elseif v.id == 13 then
          valid = WarbandProxy.Instance:CheckCalendarTimeValid(PvpProxy.Type.TwelvePVPChampion, self.dayStartTime)
        elseif v.id == 15 then
          valid = WarbandProxy.Instance:CheckCalendarTimeValid(PvpProxy.Type.TeamPwsChampion, self.dayStartTime, true)
        end
      end
    else
      valid = true
    end
    if valid and v.InValid ~= 1 then
      local acData = CalendarActivityData.new(self.year, self.month, self.day)
      acData:SetStaticActData(v.id)
      if 1 == v.TimeUnit or 2 == v.TimeUnit and self.weekday == v.Wday or 3 == v.TimeUnit and self:ParseTimeUnit3(v.frequency) then
        self.activeData[#self.activeData + 1] = acData
      end
    end
  end
  local consoleData = ActivityEventProxy.Instance:GetCalendarEventDataByTimeStamp(self.dayStartTime)
  if consoleData then
    for i = 1, #consoleData do
      local acData = CalendarActivityData.new(self.year, self.month, self.day)
      acData:SetConsoleActData(consoleData[i])
      self.consoleData[#self.consoleData + 1] = acData
      self.activeData[#self.activeData + 1] = acData
    end
  end
  table.sort(self.activeData, function(l, r)
    if l.startStamp == r.startStamp then
      return l.staticData.id > r.staticData.id
    else
      return l.startStamp < r.startStamp
    end
  end)
  self:SetWeekData()
end

function ServantContainerData:HasActData()
  return #self.activeData > 0
end

function ServantContainerData:FindStartStamp(id)
  for i = 1, #self.consoleData do
    if self.consoleData[i].staticData.id == id then
      return self.consoleData[i].startStamp
    end
  end
  for i = 1, #self.activeData do
    if self.activeData[i].staticData.id == id then
      return self.activeData[i].startStamp
    end
  end
end

function ServantContainerData:GetActiveData(ignoreExpired)
  if ignoreExpired then
    return self.activeData
  end
  local validAcData = {}
  for i = 1, #self.activeData do
    if not self.activeData[i]:IsExpired() then
      validAcData[#validAcData + 1] = self.activeData[i]
    end
  end
  return validAcData
end

function ServantContainerData:GetCommingActData()
  local data = {}
  local acData = self:GetActiveData()
  for i = 1, #acData do
    if acData[i]:IsComming() then
      data[#data + 1] = acData[i]
    end
  end
  return data
end

function ServantContainerData:GetOnGoingActData()
  local data = {}
  local acData = self:GetActiveData()
  for i = 1, #acData do
    if acData[i]:IsOnGoing() then
      data[#data + 1] = acData[i]
    end
  end
  return data
end

function ServantContainerData:GetBookActData()
  local data = {}
  local acData = self:GetActiveData()
  for i = 1, #acData do
    if acData[i]:IsBooked() then
      data[#data + 1] = acData[i]
    end
  end
  return data
end

function ServantContainerData:SetWeekData()
  for i = 1, #self.activeData do
    local act = self.activeData[i]
    if not act.isConsoleData then
      if nil == self.weekActiveData[act.startHour] then
        self.weekActiveData[act.startHour] = {}
        self.timeIntervalArray[#self.timeIntervalArray + 1] = act.startHour
      end
      TableUtility.ArrayPushBack(self.weekActiveData[act.startHour], act)
    end
  end
end

function ServantContainerData:GetMinTimeInterval()
  return self.timeIntervalArray and math.min(unpack(self.timeIntervalArray))
end

function ServantContainerData:GetMaxTimeInterval()
  return self.timeIntervalArray and math.max(unpack(self.timeIntervalArray))
end

function ServantContainerData:CheckTransparent()
  local status = ServantCalendarProxy.Instance:GetViewStatus()
  if status == ServantCalendarProxy.EViewStatus.WEEK then
    return self:IsExpired()
  else
    local _, viewMon = ServantCalendarProxy.Instance:ViewDate()
    return viewMon ~= self.month
  end
end

function ServantContainerData:HasConsoleData()
  return #self.consoleData > 0
end

function ServantContainerData:GetWeekDisplayData(includeConsole)
  local intervalData = {}
  if includeConsole then
    local _, maxNum = ServantCalendarProxy.Instance:GetWeekConsoleData()
    if 0 < maxNum then
      intervalData[#intervalData + 1] = self.consoleData
    end
  end
  local weekData = ServantCalendarProxy.Instance:GetCurWeekData()
  local minValue, maxValue = ServantCalendarProxy.Instance:GetMinMaxTimeGap(weekData)
  if minValue and maxValue then
    for i = minValue, maxValue do
      if nil == self.weekActiveData[i] then
        intervalData[#intervalData + 1] = {}
      else
        intervalData[#intervalData + 1] = self.weekActiveData[i]
      end
    end
  end
  return intervalData
end

function ServantContainerData:GetUIDisplayDate()
  return string.format(ZhString.Servant_Calendar_DATE_FORMAT, self.year, self.month, self.day)
end
