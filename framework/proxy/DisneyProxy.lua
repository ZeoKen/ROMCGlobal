autoImport("DisneyRankShowData")
DisneyProxy = class("DisneyProxy", pm.Proxy)
DisneyProxy.Instance = nil
DisneyProxy.NAME = "DisneyProxy"

function DisneyProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DisneyProxy.NAME
  if DisneyProxy.Instance == nil then
    DisneyProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function DisneyProxy:Init()
  self.globalActMap = {}
  self.challengePoint = {}
  self.allRankInfo = {}
  self.challengeFirstBlood = {}
  self.challengeTaskList = {}
  self.myselfChallengeInfo = {}
  self.allServerHappyValue = 0
  self.happyValueIndices = {}
end

function DisneyProxy:SetGlobalAct(data)
  if data.open then
    self.globalActMap[data.id] = DisneyChallengeAct.new(data)
    self.challengeTaskList[data.id] = {}
    for k, v in pairs(Table_DisneyChallengeTask) do
      if v.GlobalActivityId == data.id then
        table.insert(self.challengeTaskList[data.id], k)
      end
    end
    table.sort(self.challengeTaskList[data.id], function(l, r)
      return l < r
    end)
  else
    self.globalActMap[data.id] = nil
    self.challengeTaskList[data.id] = nil
  end
end

function DisneyProxy:IsActTimeValid(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return gAct:IsActTimeValid()
  end
end

function DisneyProxy:ActRealOpen(id)
  if not self.globalActMap[id] then
    return false
  end
  return self:IsActTimeValid(id)
end

function DisneyProxy:GetEndTime(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return gAct.endtime
  end
  for k, v in pairs(self.globalActMap) do
    return v.endtime
  end
end

function DisneyProxy:GetCurActivityID()
  if self.globalActMap then
    for k, v in pairs(self.globalActMap) do
      return k
    end
  end
end

function DisneyProxy:GetMaxTaskTip(activityId)
  local config = GameConfig.DisneyChallengeTask[activityId]
  if config then
    local taskTipStartTime = ServerTime.CurServerTime() / 1000
    xdlog("当前服务器时间戳", taskTipStartTime)
    local nextRefreshTime
    local refreshInterval = config.RefreshTaskTipInterval or 3
    local maxTipPage = 0
    if EnvChannel.IsTFBranch() then
      taskTipStartTime = config.TfRefreshTaskTipTime
    else
      taskTipStartTime = config.RefreshTaskTipTime
    end
    local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(taskTipStartTime)
    local startTime = os.time({
      day = st_day,
      month = st_month,
      year = st_year,
      hour = st_hour,
      min = st_min,
      sec = st_sec
    })
    local maxTaskNum = 0
    for k, v in pairs(Table_DisneyChallengeTask) do
      if v.GlobalActivityId == activityId then
        maxTaskNum = maxTaskNum + 1
      end
    end
    nextRefreshTime = startTime
    for i = 1, maxTaskNum do
      if nextRefreshTime < ServerTime.CurServerTime() / 1000 then
        nextRefreshTime = startTime + refreshInterval * 24 * 3600 * i
        maxTipPage = 0 + i
      else
        break
      end
    end
    if maxTipPage == maxTaskNum then
      return maxTipPage, 0, 0, 0
    end
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(nextRefreshTime)
    return maxTipPage, leftDay, leftHour, leftMin
  else
    redlog("GameConfig - 迪士尼挑战缺失GlobalActID配置", activityId)
    return
  end
end

function DisneyProxy:GetActivityEndTime(activityId)
  local config = GameConfig.DisneyChallengeTask[activityId]
  if config then
    local endTime = ServerTime.CurServerTime() / 1000
    local nextRefreshTime
    local maxTipPage = 1
    if EnvChannel.IsTFBranch() then
      endTime = config.TfEndTime
    else
      endTime = config.EndTime
    end
    local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(endTime)
    local endTimeStamp = os.time({
      day = st_day,
      month = st_month,
      year = st_year,
      hour = st_hour,
      min = st_min,
      sec = st_sec
    })
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(endTimeStamp)
    return leftDay, leftHour, leftMin, leftSec
  end
end

function DisneyProxy:RecvDisneyChallengePointCmd(data)
  if data then
    local taskDatas = data.datas
    if taskDatas and 0 < #taskDatas then
      for i = 1, #taskDatas do
      end
    end
  end
end

function DisneyProxy:RecvDisneyChallengeTaskRankCmd(data)
  TableUtility.TableClear(self.allRankInfo)
  self.rankinAll = nil
  self.myselfScore = data.user_point or 0
  for i = 1, #data.datas do
    TableUtility.ArrayPushBack(self.allRankInfo, DisneyRankShowData.new(0, data.datas[i], i))
    if data.datas[i].charid == Game.Myself.data.id then
      self.rankinAll = i
    end
  end
end

function DisneyProxy:RecvDisneyChallengeTaskTipCmd(data)
  TableUtility.TableClear(self.challengeFirstBlood)
  local global_activity_id = data.global_activity_id
  local data = data.datas
  if not self.challengeFirstBlood[global_activity_id] then
    self.challengeFirstBlood[global_activity_id] = {}
  end
  local list = {}
  if data and 0 < #data then
    for i = 1, #data do
      local questid = data[i].quest_id
      local userName = data[i].user_name
      list[questid] = userName
    end
  end
  self.challengeFirstBlood[global_activity_id].challengeFirstBlood = list
end

function DisneyProxy:RecvDisneyChallengeTaskPointCmd(data)
  TableUtility.TableClear(self.myselfChallengeInfo)
  local global_activity_id = data.global_activity_id
  local data = data.datas
  if not self.myselfChallengeInfo[global_activity_id] then
    self.myselfChallengeInfo[global_activity_id] = {}
  end
  local list = {}
  if data and 0 < #data then
    for i = 1, #data do
      local questid = data[i].quest_id
      local point = data[i].point
      list[questid] = point
    end
  end
  self.myselfChallengeInfo[global_activity_id] = list
end

function DisneyProxy:GetDisneyFirstChallengePlayer(activityID)
  if self.challengeFirstBlood[activityID] then
    return self.challengeFirstBlood[activityID].challengeFirstBlood
  end
end

function DisneyProxy:RecvHappyValueUserCmd(data)
  self.allServerHappyValue = data.value
  local indices = data.indices
  if indices and #indices then
    for i = 1, #indices do
      table.insert(self.happyValueIndices, indices[i])
    end
  end
end

function DisneyProxy:RecvDisneyChallengeTaskNotifyFirstFinishCmd(data)
  if not data then
    return
  end
  local activityID = data.global_activity_id
  local questId = data.quest_id
  local userName = data.firstusername
  local questName, msgID
  for k, v in pairs(Table_DisneyChallengeTask) do
    if v.QuestId == questId then
      msgID = v.MsgId
      break
    end
  end
  if msgID then
    local msgData = Table_Sysmsg[msgID]
    if msgData then
      local text = msgData.Text
      local str = string.format(text, userName)
      MsgManager.NoticeMsgTableParam("", str)
    end
  end
end

DisneyChallengeAct = class("DisneyChallengeAct")

function DisneyChallengeAct:ctor(data)
  self.open = data.open
  self.starttime = data.starttime
  self.endtime = data.endtime
  self.type = data.type
end

function DisneyChallengeAct:IsActTimeValid()
  local curTime = ServerTime.CurServerTime() / 1000
  if self.starttime and self.endtime then
    helplog("对比时间")
    if curTime > self.starttime and curTime < self.endtime then
      return true
    end
  end
  return false
end
