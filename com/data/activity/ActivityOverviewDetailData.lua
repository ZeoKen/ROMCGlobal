ActivityOverviewDetailData = class("ActivityOverviewDetailData")

function ActivityOverviewDetailData:ctor(serverData)
  self:updateData(serverData)
end

function ActivityOverviewDetailData:TransferTime(serverTime)
  local time = serverTime
  local year = os.date("%Y", time)
  local month = os.date("%m", time)
  local day = os.date("%d", time)
  local combine = os.date("%Y-%m-%d", time)
  return combine
end

function ActivityOverviewDetailData:updateData(serverData)
  self.index = serverData.index
  self.title = serverData.name or "-"
  self.desc = serverData.desc
  local times = serverData.time
  for i = 1, #times, 2 do
    self.starttime = self:TransferTime(times[i])
    self.endtime = self:TransferTime(times[i + 1])
  end
  local aeurl = serverData.photourls
  self.photourls = aeurl.url
  self.rewards = serverData.rewards
  local track = serverData.track
  local tracetype, traceinfo = self:ParseTrackInfo(track)
  self.tracetype = tracetype
  self.traceinfo = traceinfo
end

local tempPos = LuaVector3()

function ActivityOverviewDetailData:ParseTrackInfo(track)
  local trackType = track.type
  local result = {}
  result.panelid = track.panelid
  local posx = track.pos[1]
  local posy = track.pos[2]
  local posz = track.pos[3]
  local mapid = track.mapid
  tempPos:Set(tonumber(posx), tonumber(posy), tonumber(posz))
  result.pos = tempPos
  result.mapid = mapid
  local data = {}
  data.Event = result
  return trackType, data
end
