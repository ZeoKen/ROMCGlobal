EndlessBattleFieldProxy = class("EndlessBattleFieldProxy", pm.Proxy)
EndlessBattleFieldProxy.Instance = nil
EndlessBattleFieldProxy.NAME = "EndlessBattleFieldProxy"

function EndlessBattleFieldProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EndlessBattleFieldProxy.NAME
  if EndlessBattleFieldProxy.Instance == nil then
    EndlessBattleFieldProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function EndlessBattleFieldProxy:Init()
  self.eventDatas = {}
  self.playerStatDatas = {}
  self:ResetEBFState()
end

function EndlessBattleFieldProxy:ResetEBFState()
  self.BFState = 0
  self.humanScoreTotal = 0
  self.vampireScoreTotal = 0
  self.nextEventTime = 0
end

function EndlessBattleFieldProxy:SyncEBFState(serverdata)
  if serverdata then
    redlog("EndlessBattleFieldProxy:SyncEBFState", "BFState=" .. tostring(self.BFState), "serverdata.state=" .. tostring(serverdata.state))
    if self.BFState == 0 and serverdata.state ~= 0 then
      self:ClearEBF()
    end
    self.BFState = serverdata.state
    self.humanScoreTotal = serverdata.score_human
    self.vampireScoreTotal = serverdata.score_vampire
    self.nextEventTime = serverdata.next_event_time
    self.nextEventId = serverdata.next_event_id
  end
end

function EndlessBattleFieldProxy:IsAllSync()
  return self.allSync == true
end

function EndlessBattleFieldProxy:SyncEBFEventData(datas, all_sync)
  self.allSync = all_sync
  if datas then
    for i = 1, #datas do
      local serverdata = datas[i]
      local uniqueId = serverdata.id .. "_" .. serverdata.start_time
      local data = self.eventDatas[uniqueId]
      local updateDirty = false
      if not data then
        data = {}
        self.eventDatas[uniqueId] = data
        data.eventId = serverdata.id
        data.staticData = Table_EndlessBattleFieldEvent[data.eventId]
        data.startTime = serverdata.start_time
        data.maxEndTime = serverdata.start_time + data.staticData.MaxTime
        data.uniqueId = uniqueId
        self:OnEventStart(data)
      elseif data.isEnd == false and not serverdata.is_end then
        updateDirty = true
      end
      data.humanScore = serverdata.event_param_human
      data.vampireScore = serverdata.event_param_vampire
      data.winner = serverdata.winner
      if not data.isEnd and serverdata.is_end then
        data.isEnd = true
        self:OnEventEnd(uniqueId)
      end
      data.isEnd = serverdata.is_end or false
      if updateDirty then
        self:OnEventUpdate(uniqueId)
      end
    end
  end
end

function EndlessBattleFieldProxy:SyncEBFStatData(stats)
  if stats and 0 < #stats then
    TableUtility.TableClear(self.playerStatDatas)
    for i = 1, #stats do
      local stat = stats[i]
      redlog("EndlessBattleFieldProxy:SyncEBFStatData", stat.charid, stat.username)
      local data = self.playerStatDatas[stat.charid]
      if not data then
        data = {}
        data.charid = stat.charid
        data.username = stat.username
        self.playerStatDatas[data.charid] = data
      end
      data.camp = stat.camp
      data.profession = stat.profession
      data.kill = stat.kill or 0
      data.death = stat.death or 0
      data.heal = stat.heal or 0
      data.help = stat.assist or 0
      data.pvpDamage = stat.damage_user or 0
      data.pveDamage = stat.damage_npc or 0
    end
  end
end

function EndlessBattleFieldProxy:SyncEBFKickTime(time)
  redlog("EndlessBattleFieldProxy:SyncEBFKickTime", tostring(time))
  self.kickoutTime = time
end

function EndlessBattleFieldProxy:OnEventStart(data)
  redlog("[无尽战场] 事件开启", data.uniqueId)
  GameFacade.Instance:sendNotification(PVPEvent.EndlessBattleField_Event_Start, data.uniqueId)
  EventManager.Me():PassEvent(PVPEvent.EndlessBattleField_Event_Start, data.uniqueId)
  self:CreateSceneTrigger(data)
end

function EndlessBattleFieldProxy:OnEventEnd(uniqueId)
  self:RemoveSceneTrigger(uniqueId)
  redlog("[无尽战场] 事件结束", uniqueId)
  GameFacade.Instance:sendNotification(PVPEvent.EndlessBattleField_Event_End, uniqueId)
  EventManager.Me():PassEvent(PVPEvent.EndlessBattleField_Event_End, uniqueId)
end

function EndlessBattleFieldProxy:OnEventUpdate(uniqueId)
  GameFacade.Instance:sendNotification(PVPEvent.EndlessBattleField_Event_Update, uniqueId)
  EventManager.Me():PassEvent(PVPEvent.EndlessBattleField_Event_Update, uniqueId)
end

function EndlessBattleFieldProxy:CreateSceneTrigger(eventData)
  local staticData = eventData.staticData
  if not staticData then
    redlog("event data not exist! event id", eventData.eventId)
    return
  end
  local data = ReusableTable.CreateTable()
  data.id = eventData.uniqueId
  data.pos = staticData.AreaCenter
  data.range = staticData.AreaRange
  data.type = AreaTrigger_Common_ClientType.EndlessBattleField_EventArea
  SceneTriggerProxy.Instance:Add(data)
  ReusableTable.DestroyTable(data)
end

function EndlessBattleFieldProxy:RemoveSceneTrigger(triggerId)
  SceneTriggerProxy.Instance:Remove(triggerId)
end

function EndlessBattleFieldProxy:ClearEBF()
  redlog("EndlessBattleFieldProxy:ClearEBF")
  TableUtility.TableClearByDeleter(self.eventDatas, function(v)
    self:RemoveSceneTrigger(v.uniqueId)
  end)
  TableUtility.TableClear(self.playerStatDatas)
  self:ResetEBFState()
  self.statue_unique_id = nil
end

function EndlessBattleFieldProxy:GetEventDataByUniqueId(uniqueId)
  return self.eventDatas[uniqueId]
end

function EndlessBattleFieldProxy:GetCurEventDataByEventId(eventId)
  for _, data in pairs(self.eventDatas) do
    if data.eventId == eventId and not data.isEnd then
      return data
    end
  end
end

function EndlessBattleFieldProxy:GetStatueEventData()
  if not self.statue_unique_id then
    local statue_event_id = EndlessBattleGameProxy.Instance:GetFinalId()
    for k, v in pairs(self.eventDatas) do
      if v.eventId == statue_event_id then
        self.statue_unique_id = k
        break
      end
    end
  end
  if self.statue_unique_id then
    return self:GetEventDataByUniqueId(self.statue_unique_id)
  end
end

function EndlessBattleFieldProxy:IsEventActive(eventId)
  local data = self:GetCurEventDataByEventId(eventId)
  return data and not data.isEnd or false
end

function EndlessBattleFieldProxy:GetActiveEvents()
  local result = {}
  for _, data in pairs(self.eventDatas) do
    if not data.isEnd then
      table.insert(result, data)
    end
  end
  return result
end

local DefaultFilterFunc = function(v)
  return true
end
local DefaultSortFunc = function(l, r)
  return l.startTime < r.startTime
end

function EndlessBattleFieldProxy:GetEventList(filterFunc, sortFunc)
  local eventList = {}
  filterFunc = filterFunc or DefaultFilterFunc
  for _, v in pairs(self.eventDatas) do
    if filterFunc(v) then
      eventList[#eventList + 1] = v
    end
  end
  sortFunc = sortFunc or DefaultSortFunc
  table.sort(eventList, sortFunc)
  return eventList
end

function EndlessBattleFieldProxy:GetNextEventTime()
  return self.nextEventTime or 0
end

function EndlessBattleFieldProxy:GetNextEventId()
  return self.nextEventId
end

function EndlessBattleFieldProxy:GetEBFUserStatInfos()
  return self.playerStatDatas
end

function EndlessBattleFieldProxy:GetKickOutTimeStamp()
  return self.kickoutTime
end

function EndlessBattleFieldProxy:IsWaitingForStart()
  return self.BFState == FuBenCmd_pb.EEBF_FIELD_WAITING
end

function EndlessBattleFieldProxy:IsContinue()
  return self.kickoutTime == 0
end
