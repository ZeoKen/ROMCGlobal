ActivityHitPollyProxy = class("ActivityHitPollyProxy", pm.Proxy)
ActivityHitPollyProxy.Instance = nil
ActivityHitPollyProxy.NAME = "ActivityHitPollyProxy"
ActivityHitPollyProxy.MAXPOLLY = 9
ActivityHitPollyProxy.PACKAGE_CHECK = {
  1,
  6,
  7,
  8,
  9
}
local SortQuestFunc = function(a, b)
  return a.sortId < b.sortId
end

function ActivityHitPollyProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityHitPollyProxy.NAME
  if ActivityHitPollyProxy.Instance == nil then
    ActivityHitPollyProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitData()
end

function ActivityHitPollyProxy:InitData()
  self.infoMap = {}
  self.restbuy = 0
  self.questData = {}
  self.previewRewards = {}
  self.MaxRound = 4
  self.currentRound = -1
end

function ActivityHitPollyProxy:InitInfoMap()
  for i = 1, self.MaxRound do
    self.infoMap[i] = ActivityHitPollyRoundData.new(i)
  end
  self:InitRewardPreview()
end

function ActivityHitPollyProxy:HandleQueryList(serverData)
  self.restbuy = serverData.restbuy
  self.currentRound = serverData.currentround
  local round = self.infoMap[serverData.round]
  round:SetData(serverData.list, serverData.round)
  self:RefreshPreviewRewards()
  if not self:HasAllRewardLeft() then
    self:TryRemoveShopQuest()
  else
    local shopcfg = self.activityCFG.coin
    ShopProxy.Instance:CallQueryShopConfig(shopcfg.ShopType, shopcfg.ShopIDClient)
  end
end

function ActivityHitPollyProxy:HandleHitPolly(serverData)
  if not (serverData.round and serverData.pos) or not serverData.rewardid then
    return
  end
  local rewards = ItemUtil.GetRewardItemIdsByTeamId(serverData.rewardid)
  if rewards and #rewards == 1 then
    local round = self.infoMap[serverData.round]
    round:SetData({serverData}, serverData.round)
  end
  if not self:HasAllRewardLeft() then
    self:TryRemoveShopQuest()
  end
  self:RefreshPreviewRewards()
end

function ActivityHitPollyProxy:NoRewardLeft()
  return not self:HasRoundRewardLeft(self.currentRound)
end

function ActivityHitPollyProxy:NeedQueryNextRound()
  return self:NoRewardLeft() and self.currentRound < self.MaxRound
end

function ActivityHitPollyProxy:HandleQuest(quests)
  if quests then
    for i = 1, #quests do
      self.questData[quests[i].questid] = ActivityHitPollyQuestData.new(quests[i])
    end
  end
end

function ActivityHitPollyProxy:CallQueryActivityList()
  if -1 ~= self.currentRound then
    if self:NeedQueryNextRound() then
      ServiceActHitPollyProxy.Instance:CallActityQueryHitedList(self.currentRound + 1)
    else
      ServiceActHitPollyProxy.Instance:CallActityQueryHitedList(self.currentRound)
    end
  end
end

function ActivityHitPollyProxy:GetRoundData(r)
  return self.infoMap[r]
end

function ActivityHitPollyProxy:IsRoundInited(r)
  local r = self.infoMap[r]
  if r then
    return r.inited == true
  end
end

function ActivityHitPollyProxy:GetActDuringTime()
  if not self.activityID then
    return ""
  end
  if not ActivityCmd_pb.GACTIVITY_HITPOLLY then
    return
  end
  local actData = FunctionActivity.Me():GetActivityData(ActivityCmd_pb.GACTIVITY_HITPOLLY)
  if actData then
    local st, et = actData:GetDuringTime()
    local startMonth = os.date("%m", st)
    local startDay = os.date("%d", st)
    local endMonth = os.date("%m", et)
    local endDay = os.date("%d", et)
    return string.format(ZhString.ActivityHitPolly_ValidDate, startMonth, startDay, endMonth, endDay)
  end
  return ""
end

function ActivityHitPollyProxy:GetQuests()
  local nopen, ongoing, finished = {}, {}, {}
  if self.questData then
    for k, v in pairs(self.questData) do
      if ActHitPolly_pb.EACCHITPOLLY_QUEST_NOT_OPEN == v.status then
        nopen[#nopen + 1] = v
      elseif ActHitPolly_pb.EACCHITPOLLY_QUEST_ON == v.status or ActHitPolly_pb.EACCHITPOLLY_QUEST_SUBMITABLE == v.status then
        ongoing[#ongoing + 1] = v
      elseif ActHitPolly_pb.EACCHITPOLLY_QUEST_FINISH == v.status then
        finished[#finished + 1] = v
      end
    end
  end
  table.sort(nopen, SortQuestFunc)
  table.sort(ongoing, SortQuestFunc)
  table.sort(finished, SortQuestFunc)
  return nopen, ongoing, finished
end

function ActivityHitPollyProxy:GetCurrentRoundData()
  if -1 == self.currentRound then
    redlog("currentRound 未初始化")
    return {}
  end
  local roundData = self:GetRoundData(self.currentRound)
  if roundData then
    return roundData
  end
end

function ActivityHitPollyProxy:GetRoundDatas()
  local data = {}
  for _, v in pairs(self.infoMap) do
    data[#data + 1] = v
  end
  return data
end

function ActivityHitPollyProxy:InitRewardPreview()
  local rewardCfg = self.activityCFG.preview
  for i = 1, #rewardCfg do
    local temp = ReusableTable.CreateTable()
    temp.index = i
    temp.itemdata = ItemData.new("mat", rewardCfg[i][1])
    temp.itemdata:SetItemNum(rewardCfg[i][2])
    self.previewRewards[#self.previewRewards + 1] = temp
  end
end

function ActivityHitPollyProxy:GetPreviewRewards()
  return self.previewRewards
end

function ActivityHitPollyProxy:RefreshPreviewRewards()
  for i = 1, #self.previewRewards do
    if i > self.currentRound then
      self.previewRewards[i].forcehideFinish = true
    elseif i < self.currentRound then
      self.previewRewards[i].forcehideFinish = false
    elseif self:GetBestReward(i) then
      self.previewRewards[i].forcehideFinish = false
    else
      self.previewRewards[i].forcehideFinish = true
    end
  end
end

function ActivityHitPollyProxy:SetCurrentActivityID(data)
  if not data.globalactid then
    redlog("--------HitPolly 后端未同步活动ID ")
    return
  end
  if not data.curround then
    redlog("--------HitPolly 后端未同步轮次 ")
    return
  end
  if data.globalactid ~= 0 and data.curround ~= 0 then
    self.activityID = data.globalactid
    self.currentRound = data.curround or 1
    TableUtility.ArrayClear(self.previewRewards)
    if nil == GameConfig.HitPollyActivity or nil == GameConfig.HitPollyActivity[data.globalactid] then
      redlog("客户端GameConfig HitPollyActivity 配置错误，活动ID:  ", data.globalactid)
    end
    self.activityCFG = GameConfig.HitPollyActivity[self.activityID]
    if nil == self.activityCFG then
      redlog("打boli活动GameConfig.HitPollyActivity 未配，错误ID: ", self.activityID)
    end
    local coinID = self.activityCFG.coin and self.activityCFG.coin.ItemID or nil
    if not coinID or not Table_Item[coinID] then
      redlog("GameConfig.HitPollyActivity coin ItemID 配置错误  对应的key值 ActivityID: ", self.activityID)
    end
    self.MaxRound = #self.activityCFG.round
    self.shopQuestID = nil
    TableUtility.TableClear(self.questData)
    self:InitInfoMap()
    self:HandleQuest(data.quests)
  end
end

function ActivityHitPollyProxy:GetCoinID()
  if self.activityCFG then
    return self.activityCFG.coin.ItemID
  end
  return 100
end

function ActivityHitPollyProxy:GetActivityCFG()
  return self.activityCFG
end

function ActivityHitPollyProxy:HasAllRewardLeft()
  return self:HasRoundRewardLeft(self.MaxRound)
end

function ActivityHitPollyProxy:IsActivityDateValid()
  return nil ~= ActivityCmd_pb.GACTIVITY_HITPOLLY and FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_HITPOLLY)
end

function ActivityHitPollyProxy:SetPurchaseCount(c)
  self.purchaseCount = c
end

function ActivityHitPollyProxy:GetRestBuyParam()
  return self.restbuy, self.activityCFG.coin.dailyCount
end

function ActivityHitPollyProxy:HasRoundRewardLeft(round)
  if round < self.currentRound then
    return false
  end
  local roundData = self.infoMap[round]
  if roundData then
    for _, v in pairs(roundData.rewardData) do
      if not v.itemdata then
        return true
      end
    end
  end
  return false
end

function ActivityHitPollyProxy:GetBestReward(round)
  local roundData = self.infoMap[round]
  if roundData and roundData.getBestReward then
    return true
  end
end

function ActivityHitPollyProxy:GetPosCost(r, pos)
  if self.activityCFG then
    return self.activityCFG.round[r].cost[pos]
  end
end

function ActivityHitPollyProxy:AddShopQuest(data)
  local temp = ReusableTable.CreateTable()
  temp.goodsID = data.itemid
  temp.ItemCount = data.moneycount
  temp.id = data.id
  temp.status = ActHitPolly_pb.EACCHITPOLLY_QUEST_ON
  self.questData[data.id] = ActivityHitPollyQuestData.new(temp)
  self.shopQuestID = data.id
  ReusableTable.DestroyAndClearArray(temp)
end

function ActivityHitPollyProxy:TryRemoveShopQuest()
  if nil ~= self.shopQuestID then
    self.questData[self.shopQuestID] = nil
    self.shopQuestID = nil
  end
end

ActivityHitPollyRoundData = class("ActivityHitPollyRoundData")

function ActivityHitPollyRoundData:ctor(round)
  self.round = round
  self.rewardData = {}
  for i = 1, ActivityHitPollyProxy.MAXPOLLY do
    local temp = {}
    temp.index = i
    temp.num = 0
    self.rewardData[i] = temp
  end
end

function ActivityHitPollyRoundData:SetData(serverPosList, round)
  self.round = round
  self.inited = true
  if serverPosList then
    for i = 1, #serverPosList do
      self.round = serverPosList[i].round
      local rewards = ItemUtil.GetRewardItemIdsByTeamId(serverPosList[i].rewardid)
      if rewards and 0 < #rewards then
        self.rewardData[serverPosList[i].pos].itemdata = ItemData.new("HitPollyItemData", rewards[1].id)
        self.rewardData[serverPosList[i].pos].itemdata:SetItemNum(rewards[1].num)
        if self.rewardData[serverPosList[i].pos].itemdata.staticData and self.rewardData[serverPosList[i].pos].itemdata.staticData.id == ActivityHitPollyProxy.Instance.previewRewards[self.round].itemdata.staticData.id then
          self.getBestReward = true
        end
      end
    end
  end
end

ActivityHitPollyQuestData = class("ActivityHitPollyQuestData")

function ActivityHitPollyQuestData:ctor(data)
  if data.questid then
    self.staticData = Table_ActivityHitPolly[data.questid]
    self.id = self.staticData.id
    if nil == self.staticData then
      redlog("Table_ActivityHitPolly 服务器客户端 配置不一样")
    end
    self.sortId = self.id
    local startTime, endTime
    if EnvChannel.IsReleaseBranch() then
      startTime, endTime = self.staticData.GoStartTime, self.staticData.GoEndTime
    else
      startTime, endTime = self.staticData.TFGoStartTime, self.staticData.TFGoEndTime
    end
    local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(startTime)
    local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(endTime)
    self.param = data.param
    self.subParam = data.subParam
    self.status = data.status
    self.process = data.process
    self.durationStr = string.format(ZhString.TimePeriodFormat, st_month, st_day, end_month, end_day)
    self.endTimeStamp = os.time({
      year = end_year,
      month = end_month,
      day = end_day,
      hour = end_hour,
      min = end_min,
      sec = end_sec
    })
    self.startTimeStamp = os.time({
      year = st_year,
      month = st_month,
      day = st_day,
      hour = st_hour,
      min = st_min,
      sec = st_sec
    })
  elseif data.goodsID and data.ItemCount then
    self.goodsID = data.goodsID
    self.id = data.id
    self.price = data.ItemCount
    self.status = data.status
    self.sortId = 1
  end
end
