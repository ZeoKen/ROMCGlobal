autoImport("AEFreeTransferData")
autoImport("AERewardData")
autoImport("AEResetData")
autoImport("AERewardItemData")
autoImport("AELotteryData")
autoImport("AEGuildBuildingData")
autoImport("AECalendarData")
autoImport("AECardResource")
autoImport("AEHeadwearLotteryReward")
autoImport("AEQuestionnaireData")
autoImport("AECommunityData")
ActivityEventProxy = class("ActivityEventProxy", pm.Proxy)
ActivityEventProxy.Instance = nil
ActivityEventProxy.NAME = "ActivityEventProxy"
ActivityEventType = {
  FreeTransfer = ActivityEvent_pb.EACTIVITYEVENTTYPE_FREE_TRANSFER,
  Reward = ActivityEvent_pb.EACTIVITYEVENTTYPE_REWARD,
  ResetTime = ActivityEvent_pb.EACTIVITYEVENTTYPE_RESETTIME,
  LotteryDiscount = ActivityEvent_pb.EACTIVITYEVENTTYPE_LOTTERY_DISCOUNT,
  LotteryBanner = ActivityEvent_pb.EACTIVITYEVENTTYPE_LOTTERY_BANNER,
  GuildBuildingSubmit = ActivityEvent_pb.EACTIVITYEVENTTYPE_GUILD_BUILDING_SUBMIT,
  Shop = ActivityEvent_pb.EACTIVITYEVENTTYPE_SHOP,
  Calendar = ActivityEvent_pb.EACTIVITYEVENTTYPE_SERVANT_CALENDAR,
  CardResource = ActivityEvent_pb.EACTIVITYEVENTTYPE_CARD_RESOURCE,
  ThemeDetail = ActivityEvent_pb.EACTIVITYEVENTTYPE_THEME_DETAILS,
  HeadwearLotteryReward = ActivityEvent_pb.EACTIVITYEVENTTYPE_HEAD_LOTTERY_REWARD,
  TapTapLink = ActivityEvent_pb.EACTIVITYEVENTTYPE_TAPTAP_LINK,
  Questionnaire = ActivityEvent_pb.EACTIVITYEVENTTYPE_QUESTIONNNAIRE,
  AntiAddiction = ActivityEvent_pb.EACTIVITYEVENTTYPE_ANTI_ADDICTION_OPEN,
  Community = ActivityEvent_pb.EACTIVITYEVENTTYPE_COMMUNITY
}
AERewardType = {
  Laboratory = ActivityEvent_pb.EAEREWARDMODE_LABORATORY,
  WantedQuest = ActivityEvent_pb.EAEREWARDMODE_WANTEDQUEST,
  Seal = ActivityEvent_pb.EAEREWARDMODE_SEAL,
  GuildDonate = ActivityEvent_pb.EAEREWARDMODE_GUILD_DONATE,
  Tower = ActivityEvent_pb.EAEREWARDMODE_TOWER,
  GuildRaid = ActivityEvent_pb.EAEREWARDMODE_GUILDRAID,
  GuildDojo = ActivityEvent_pb.EAEREWARDMODE_GUILDDOJO,
  PveCard = ActivityEvent_pb.EAEREWARDMODE_PVECARD,
  EXPRaid = ActivityEvent_pb.EAEREWARDMODE_EXPRAID,
  TeamGroup = ActivityEvent_pb.EAEREWARDMODE_TEAMGROUP,
  TwelvePvP = ActivityEvent_pb.EAEREWARDMODE_TWELVEPVP,
  ComodoRaid = ActivityEvent_pb.EAEREWARDMODE_Comodo_Team,
  SevenRoyalFamiliesRaid = ActivityEvent_pb.EAEREWARDMODE_MULTIBOSS,
  NewGVGPersonal = ActivityEvent_pb.EAEREWARDMODE_NEWGVG_PERSONAL,
  NewGVGGuild = ActivityEvent_pb.EAEREWARDMODE_NEWGVG_GUILD,
  EquipUpRaid = ActivityEvent_pb.EAEREWARDMODE_EQUIP_UP_RAID
}

function ActivityEventProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityEventProxy.NAME
  if ActivityEventProxy.Instance == nil then
    ActivityEventProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityEventProxy:Init()
  self.eventMap = {}
  self.userDataMap = {}
  self.bannerMap = {}
  self.calendarMap = {}
  self.GroupRaidRewardActivityOpen = false
end

function ActivityEventProxy:SetGroupRaidRewardActivityState(isOpen)
  if isOpen then
    self.GroupRaidRewardActivityOpen = true
  else
    self.GroupRaidRewardActivityOpen = false
  end
end

function ActivityEventProxy:GetGroupRaidRewardActivityState()
  return self.GroupRaidRewardActivityOpen
end

function ActivityEventProxy:RecvActivityEventNtf(servicedata)
  TableUtility.TableClear(self.eventMap)
  TableUtility.TableClear(self.calendarMap)
  for i = 1, #servicedata.events do
    local event = servicedata.events[i]
    local eventType = event.type
    if eventType == ActivityEventType.FreeTransfer then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      local data = AEFreeTransferData.new(event.freetransfer)
      data:SetTime(event)
      table.insert(self.eventMap[eventType], data)
    elseif eventType == ActivityEventType.Reward then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = AERewardData.new()
      end
      self.eventMap[eventType]:SetReward(event)
    elseif eventType == ActivityEventType.ResetTime then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      local data = AEResetData.new()
      table.insert(self.eventMap[eventType], data)
      for j = 1, #event.resetinfo do
        data:SetData(event.resetinfo[j])
      end
    elseif eventType == ActivityEventType.LotteryDiscount then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      local data = AELotteryData.new()
      table.insert(self.eventMap[eventType], data)
      data:SetDiscount(event)
    elseif eventType == ActivityEventType.LotteryBanner then
      local lotterytype = event.lotterybanner.lotterytype
      if self.bannerMap[lotterytype] == nil then
        self.bannerMap[lotterytype] = {}
      end
      local data = AELotteryBannerData.new()
      table.insert(self.bannerMap[lotterytype], data)
      data:SetData(event)
    elseif eventType == ActivityEventType.GuildBuildingSubmit then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      local gData = AEGuildBuildingData.new(event.gbuildingsubmit)
      gData:SetTime(event)
      table.insert(self.eventMap[eventType], gData)
    elseif eventType == ActivityEventType.Calendar then
      local timeTable = event.calendarinfo.times
      local tracetype, traceinfo = self:ParseTrackInfo(event.calendarinfo.track)
      for i = 1, #timeTable, 2 do
        local starttime = timeTable[i]
        local endtime = timeTable[i + 1]
        self:DivideTime(starttime, endtime, event, i, tracetype, traceinfo, starttime, endtime)
      end
      ServantCalendarProxy.Instance:ResetInit()
    elseif eventType == ActivityEventType.CardResource then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
        local data = AECardResource.new(event.cardrscinfo)
        table.insert(self.eventMap[eventType], data)
      end
    elseif eventType == ActivityEventType.HeadwearLotteryReward then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
        local data = AEHeadwearLotteryReward.new(event.headlotteryextra)
        data:SetTime(data.begintime, data.endtime)
        table.insert(self.eventMap[eventType], data)
      end
    elseif eventType == ActivityEventType.ThemeDetail then
      ActivityDataProxy.Instance:InitTimeLimitActivityInfo(event.themedetailsinfo)
    elseif eventType == ActivityEventType.TapTapLink then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      local data = event.taptaplink
      if data ~= nil then
        self.eventMap[eventType][data.globalactivityid] = data
      end
    elseif eventType == ActivityEventType.Questionnaire then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      if event.questionnaire ~= nil then
        local data = AEQuestionnaireData.new(event)
        data:SetTime(event)
        self.eventMap[eventType] = data
      end
    elseif eventType == ActivityEventType.AntiAddiction then
      self.eventMap[eventType] = event.anti_addiction_open
    elseif eventType == ActivityEventType.Community then
      if self.eventMap[eventType] == nil then
        self.eventMap[eventType] = {}
      end
      local data = AECommunityData.new(event.communityinfo)
      data:SetTime(event)
      table.insert(self.eventMap[eventType], data)
      CommunityIntegrationProxy.Instance:RefreshRedtip()
    end
  end
end

function ActivityEventProxy:RecvActivityEventUserDataNtf(servicedata)
  for i = 1, #servicedata.rewarditems do
    local rewarditem = servicedata.rewarditems[i]
    self.userDataMap[rewarditem.mode] = AERewardItemData.new(rewarditem)
  end
  self.questionnaireids = servicedata.questionnaireids
  local rewardinfos = servicedata.rewardinfos
  if rewardinfos and 0 < #rewardinfos then
    for i = 1, #rewardinfos do
      local rewardinfo = rewardinfos[i]
      local eventtype = rewardinfo and rewardinfo.eventtype
      if eventtype == ActivityEventType.Community then
        CommunityIntegrationProxy.Instance:RecvActivityEventUserDataNtf(rewardinfo)
      end
    end
  end
end

function ActivityEventProxy:RecvActivityEventNtfEventCntCmd(servicedata)
  for i = 1, #servicedata.cnt do
    local countdata = servicedata.cnt[i]
    local eventType = countdata.type
    local datas = self.eventMap[eventType]
    local data
    for i = 1, #datas do
      data = datas[i]
      if data ~= nil and eventType == ActivityEventType.LotteryDiscount then
        local discount = data:GetDiscountDataById(countdata.id)
        if discount ~= nil then
          discount:SetUsedCount(countdata.count)
        end
      end
    end
  end
end

function ActivityEventProxy:IsFreeTransferMap(mapid, Ftype)
  local datas = self.eventMap[ActivityEventType.FreeTransfer]
  local data
  if datas == nil then
    return false
  end
  for i = 1, #datas do
    data = datas[i]
    if data ~= nil and data:IsFreeTransferMap(mapid, Ftype) then
      return true
    end
  end
  return false
end

function ActivityEventProxy:IsStorageFree()
  local datas = self.eventMap[ActivityEventType.FreeTransfer]
  if datas == nil then
    return false
  end
  local data
  for i = 1, #datas do
    data = datas[i]
    if data ~= nil and data:IsStorageFree() then
      return true
    end
  end
  return false
end

function ActivityEventProxy:GetUserDataByType(rewardType)
  return self.userDataMap[rewardType]
end

function ActivityEventProxy:GetRewardByType(rewardType)
  local event = self.eventMap[ActivityEventType.Reward]
  if event ~= nil then
    return event:GetRewardByType(rewardType)
  end
end

function ActivityEventProxy:GetRewardByMode(mode)
  local _AERewardInfoData = self:GetRewardByType(mode)
  if not _AERewardInfoData then
    return nil
  end
  return _AERewardInfoData:GetExtraRewards(), _AERewardInfoData:CheckExtraRewardValid()
end

function ActivityEventProxy:GetRewardByRaidType(raid_type)
  local mode = RaidType2AERewardMode[raid_type]
  if not mode then
    return
  end
  local result, valid = self:GetRewardByMode(mode)
  return result, valid
end

function ActivityEventProxy:GetPveCardRewardByDif(difficulty)
  local event = self.eventMap[ActivityEventType.Reward]
  if event ~= nil then
    local reward = event:GetRewardByType(AERewardType.PveCard)
    return reward:GetRewardByDifficulty(difficulty)
  end
end

function ActivityEventProxy:GetResetTimeByType(rewardType)
  local events = self.eventMap[ActivityEventType.ResetTime]
  if not events then
    return nil
  end
  local event
  for i = 1, #events do
    event = events[i]
    if event ~= nil then
      return event:GetDataByType(rewardType)
    end
  end
end

function ActivityEventProxy:GetLotteryDiscount(lotterytype)
  local events = self.eventMap[ActivityEventType.LotteryDiscount]
  if not events then
    return nil
  end
  local event
  for i = 1, #events do
    event = events[i]
    if event ~= nil then
      return event:GetDiscount(lotterytype)
    end
  end
end

function ActivityEventProxy:GetLotteryDiscountByCoinType(lotterytype, cointype, year, month)
  local events = self.eventMap[ActivityEventType.LotteryDiscount]
  if not events then
    return nil
  end
  local event
  for i = 1, #events do
    event = events[i]
    if event ~= nil then
      local discountinfo = event:GetDiscountByCoinType(lotterytype, cointype, year, month)
      if discountinfo then
        return discountinfo
      end
    end
  end
  return nil
end

function ActivityEventProxy:GetLotteryBanner(lotterytype)
  if self.bannerMap then
    return self.bannerMap[lotterytype]
  end
end

function ActivityEventProxy:GetGuildBuildingEventData()
  local events = self.eventMap[ActivityEventType.GuildBuildingSubmit]
  if not events then
    return nil
  end
  local event
  for i = 1, #events do
    event = events[i]
    if event then
      return event
    end
  end
end

function ActivityEventProxy:GetCalendarEventData(starttime, endtime)
  local calendarEventList = {}
  for k, v in pairs(self.calendarMap) do
    if starttime <= k and k <= endtime then
      local eventlist = self.calendarMap[k]
      table.sort(eventlist, function(a, b)
        return a.eventStarttime < b.eventStarttime
      end)
      table.insert(calendarEventList, eventlist)
    end
  end
  return calendarEventList
end

function ActivityEventProxy:GetCalendarEventDataByTimeStamp(t)
  return self.calendarMap[t]
end

function ActivityEventProxy:GetCardResourceUrl()
  local events = self.eventMap[ActivityEventType.CardResource]
  if events and 0 < #events then
    return events[1].url.url
  end
end

function ActivityEventProxy:GetEvents(activityEventType)
  return self.eventMap[activityEventType]
end

local tempPos = LuaVector3()

function ActivityEventProxy:ParseTrackInfo(track)
  local trackType = track.type
  local result = {}
  result.panelid = track.panelid
  local posx = track.pos[1]
  local posy = track.pos[2]
  local posz = track.pos[3]
  local mapid = track.mapid
  LuaVector3.Better_Set(tempPos, tonumber(posx), tonumber(posy), tonumber(posz))
  result.pos = tempPos
  result.mapid = mapid
  local data = {}
  data.Event = result
  return trackType, data
end

local deltaday = 86400

function ActivityEventProxy:IsSameDay(timestampOld, timestampNew, offset)
  return (timestampNew - offset) / deltaday - (timestampOld - offset) / deltaday < 1
end

function ActivityEventProxy:DivideTime(starttime, endtime, event, index, tracetype, traceinfo, Dstarttime, Dendtime)
  if self:IsSameDay(starttime, endtime, (5 + ServerTime.SERVER_TIMEZONE) * 60 * 60) then
    local daySatrt = ServerTime.GetGameStartTimestamp(starttime)
    if self.calendarMap[daySatrt] == nil then
      self.calendarMap[daySatrt] = {}
    end
    local data = self:SpawnCalenarData(event, index, tracetype, traceinfo)
    data:SetEventTime(starttime, endtime)
    data:SetDurationDay(Dstarttime, Dendtime)
    table.insert(self.calendarMap[daySatrt], data)
  else
    local data = self:SpawnCalenarData(event, index, tracetype, traceinfo)
    local daySatrt = ServerTime.GetGameStartTimestamp(starttime)
    if self.calendarMap[daySatrt] == nil then
      self.calendarMap[daySatrt] = {}
    end
    data:SetEventTime(starttime, daySatrt + deltaday - 1)
    data:SetDurationDay(Dstarttime, Dendtime)
    table.insert(self.calendarMap[daySatrt], data)
    daySatrt = daySatrt + deltaday
    self:DivideTime(daySatrt, endtime, event, index, tracetype, traceinfo, Dstarttime, Dendtime)
  end
end

function ActivityEventProxy:SpawnCalenarData(event, index, tracetype, traceinfo)
  local data = AECalendarData.new(event.calendarinfo, index, event.id)
  data:SetTrackInfo(tracetype, traceinfo)
  data:SetTime(event)
  return data
end

function ActivityEventProxy:GetHeadwearLotteryReward()
  local events = self.eventMap[ActivityEventType.HeadwearLotteryReward]
  if not events then
    return nil
  end
  local event
  for i = 1, #events do
    event = events[i]
    if event then
      return event
    end
  end
end

function ActivityEventProxy:GetTapTapLinkInfo()
  local events = self.eventMap[ActivityEventType.TapTapLink]
  return events
end

function ActivityEventProxy:GetQuestionnaireInfo()
  local events = self.eventMap[ActivityEventType.Questionnaire]
  return events
end

function ActivityEventProxy:CheckQuestionnaireFinished()
  local info = self:GetQuestionnaireInfo()
  return self.questionnaireids and info and TableUtility.ArrayFindIndex(self.questionnaireids, info.id) > 0
end

function ActivityEventProxy:CheckQuestionnaireVisitedToday()
  local charid = Game.Myself.data.id
  local lastRedTipDay = PlayerPrefs.GetInt("LastVisitRedTip_Questionnaire_" .. tostring(charid), 0)
  local curDay = os.date("*t", ServerTime.CurServerTime() / 1000).yday
  if lastRedTipDay ~= curDay then
    RedTipProxy.Instance:UpdateRedTip(GameConfig.QuestionnaireScore.RedTipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(GameConfig.QuestionnaireScore.RedTipID)
  end
end

function ActivityEventProxy:SetQuestionnaireVisitedToday()
  local charid = Game.Myself.data.id
  local curDay = os.date("*t", ServerTime.CurServerTime() / 1000).yday
  PlayerPrefs.SetInt("LastVisitRedTip_Questionnaire_" .. tostring(charid), curDay)
  PlayerPrefs.Save()
  RedTipProxy.Instance:RemoveWholeTip(GameConfig.QuestionnaireScore.RedTipID)
end

function ActivityEventProxy:IsAntiAddictionOpen()
  return self.eventMap[ActivityEventType.AntiAddiction]
end
