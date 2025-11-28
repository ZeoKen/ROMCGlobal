AECalendarData = class("AECalendarData")

function AECalendarData:ctor(data, index, eventid)
  self:SetData(data, index, eventid)
end

function AECalendarData:SetData(data, index, eventid)
  self.data = data
  if self.data ~= nil then
    self.name = self.data.name
    self.iconurl = self.data.iconurls
    self.photourl = self.data.photourls
    self.desc = self.data.desc
    self.location = self.data.location
    self.id = eventid
  end
end

function AECalendarData:SetEventTime(eventStarttime, evnetEndtime)
  self.eventStarttime = eventStarttime
  self.evnetEndtime = evnetEndtime
  self.id = self.id + self.eventStarttime
end

function AECalendarData:SetTime(data)
  self.beginTime = data.begintime
  self.endTime = data.endtime
end

function AECalendarData:IsInEventActivity()
  if self.beginTime ~= nil and self.endTime ~= nil then
    local server = ServerTime.CurServerTime() / 1000
    return server >= self.beginTime and server <= self.endTime
  else
    return false
  end
end

function AECalendarData:IsInActivity()
  if self.eventStarttime ~= nil and self.evnetEndtime ~= nil then
    local server = ServerTime.CurServerTime() / 1000
    return server >= self.eventStarttime and server <= self.evnetEndtime
  else
    return false
  end
end

function AECalendarData:SetTrackInfo(trackType, trackInfo)
  self.trackType = trackType
  self.trackInfo = trackInfo
end

function AECalendarData:SetDurationDay(starttime, endtime)
  self.durationStart = starttime
  self.durationEnd = endtime
end
