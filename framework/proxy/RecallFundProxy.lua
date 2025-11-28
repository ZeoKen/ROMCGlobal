RecallFundProxy = class("RecallFundProxy", pm.Proxy)
RecallFundProxy.Instance = nil
RecallFundProxy.NAME = "RecallFundProxy"

function RecallFundProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallFundProxy.NAME
  if RecallFundProxy.Instance == nil then
    RecallFundProxy.Instance = self
    self:Init()
  else
    self:InitStaticData()
  end
  if data ~= nil then
    self:setData(data)
  end
end

function RecallFundProxy:Init()
  self.staticFundData = {}
  self.serverFundData = nil
  self:InitPurchaseData()
  self:InitStaticData()
end

function RecallFundProxy:InitStaticData()
  if not Table_UserRecall_Fund then
    redlog("RecallFundProxy:InitStaticData 表格不存在 Table_UserRecall_Fund，可能是服务器类型不匹配")
    return
  end
  self.staticFundData = {}
  for fundId, fundConfig in pairs(Table_UserRecall_Fund) do
    local index = fundConfig.Index
    local day = fundConfig.Day
    if not self.staticFundData[index] then
      self.staticFundData[index] = {}
    end
    self.staticFundData[index][day] = fundConfig
  end
end

function RecallFundProxy:UpdateFundData(serverData)
  if not serverData then
    redlog("RecallFundProxy:UpdateFundData 参数无效", serverData)
    return
  end
  local actualIndex
  if RecallInfoProxy.Instance then
    actualIndex = RecallInfoProxy.Instance:GetIndex(serverData.index + 1)
  end
  if not actualIndex then
    redlog("RecallFundProxy:UpdateFundData 无法获取实际配置索引", "serverIndex:", serverData.index)
    actualIndex = serverData.index
  end
  local endTime = serverData.end_time
  if serverData.start_time and RecallInfoProxy.Instance then
    local continueDay = RecallInfoProxy.Instance:GetContinueDay("Fund", actualIndex)
    if continueDay then
      endTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(serverData.start_time + continueDay * 86400)
    end
  end
  self.serverFundData = {
    index = serverData.index,
    start_time = serverData.start_time,
    end_time = endTime,
    login_day = serverData.login_day or 0,
    reward_day = {},
    buy_time = serverData.buy_time or 0,
    active = serverData.active or false
  }
  if serverData.buy_time then
    self:UpdatePurchaseData(serverData.buy_time)
  end
  if serverData.reward_day then
    for _, day in pairs(serverData.reward_day) do
      table.insert(self.serverFundData.reward_day, day)
    end
  end
  self:UpdateRedTipStatus()
end

function RecallFundProxy:RecvFundGetRewardRecallCmd(day)
  if self.serverFundData and TableUtility.ArrayFindIndex(self.serverFundData.reward_day, day) == 0 then
    table.insert(self.serverFundData.reward_day, day)
  end
  self:UpdateRedTipStatus()
end

function RecallFundProxy:GetFundData()
  return self.serverFundData
end

function RecallFundProxy:GetStaticFundData()
  return self.staticFundData
end

function RecallFundProxy:GetStaticFundDataByIndex(index)
  if not self.staticFundData then
    redlog("RecallFundProxy:GetStaticFundDataByIndex staticFundData为nil!")
    return nil
  end
  if not self.staticFundData[index] then
    redlog("RecallFundProxy:GetStaticFundDataByIndex 静态数据不存在", "Index:", index)
    return nil
  end
  return self.staticFundData[index]
end

function RecallFundProxy:GetFundDaysByIndex(index)
  local staticFunds = self:GetStaticFundDataByIndex(index)
  if not staticFunds then
    return {}
  end
  local fundDays = {}
  for day, _ in pairs(staticFunds) do
    table.insert(fundDays, day)
  end
  table.sort(fundDays)
  return fundDays
end

function RecallFundProxy:GetFundDataListByIndex(index)
  local configIndex = RecallInfoProxy.Instance:GetIndex(index)
  local staticFunds = self:GetStaticFundDataByIndex(configIndex)
  if not staticFunds then
    return {}
  end
  local fundDataList = {}
  for day, staticData in pairs(staticFunds) do
    local fundData = {
      day = day,
      staticData = staticData,
      status = 1,
      canClaim = false,
      hasClaimed = false
    }
    if self.serverFundData then
      local loginDay = self.serverFundData.login_day or 0
      local rewardDays = self.serverFundData.reward_day or {}
      for _, rewardDay in pairs(rewardDays) do
        if rewardDay == day then
          fundData.hasClaimed = true
          break
        end
      end
      if fundData.hasClaimed then
        fundData.status = 3
        fundData.canClaim = false
      elseif day <= loginDay then
        fundData.status = 2
        fundData.canClaim = true
      else
        fundData.status = 1
        fundData.canClaim = false
      end
    end
    table.insert(fundDataList, fundData)
  end
  table.sort(fundDataList, function(a, b)
    return a.day < b.day
  end)
  return fundDataList
end

function RecallFundProxy:CanClaimReward(day)
  if not self.serverFundData then
    return false
  end
  local loginDay = self.serverFundData.login_day or 0
  local rewardDays = self.serverFundData.reward_day or {}
  for _, rewardDay in pairs(rewardDays) do
    if rewardDay == day then
      return false
    end
  end
  return day <= loginDay
end

function RecallFundProxy:HasClaimedReward(day)
  if not self.serverFundData then
    return false
  end
  local rewardDays = self.serverFundData.reward_day or {}
  for _, rewardDay in pairs(rewardDays) do
    if rewardDay == day then
      return true
    end
  end
  return false
end

function RecallFundProxy:GetLoginDay()
  if not self.serverFundData then
    return 0
  end
  return self.serverFundData.login_day or 0
end

function RecallFundProxy:GetCanClaimRewardCountByIndex(index)
  local count = 0
  local fundDays = self:GetFundDaysByIndex(index)
  for _, day in pairs(fundDays) do
    if self:CanClaimReward(day) then
      count = count + 1
    end
  end
  return count
end

function RecallFundProxy:GetCanClaimRewardCount()
  local count = 0
  for index, _ in pairs(self.staticFundData) do
    count = count + self:GetCanClaimRewardCountByIndex(index)
  end
  return count
end

function RecallFundProxy:HasRewardToGet()
  return self:GetCanClaimRewardCount() > 0
end

function RecallFundProxy:RequestFundData()
  self.serverFundData = nil
  ServiceRecallCCmdProxy.Instance:CallFundQueryInfoRecallCmd()
  if not self:HasPurchased() then
    local depositId = GameConfig.UserRecall.FundDeposit
    if depositId then
      ServiceUserEventProxy.Instance:CallChargeQueryCmd(depositId)
      xdlog("RecallFundProxy 请求购买记录", depositId)
    end
  end
end

function RecallFundProxy:RequestClaimReward(day)
  if not self:CanClaimReward(day) then
    redlog("RecallFundProxy:RequestClaimReward 基金不可领取", day)
    return
  end
  ServiceRecallCCmdProxy.Instance:CallFundGetRewardRecallCmd(day)
  xdlog("RecallFundProxy 请求领取基金奖励", day)
end

function RecallFundProxy:IsActivityValid(index)
  local staticFunds = self:GetStaticFundDataByIndex(index)
  if not staticFunds or next(staticFunds) == nil then
    redlog("RecallFundProxy:IsActivityValid Index无静态数据", index)
    return false
  end
  local serverData = self:GetFundData()
  if serverData and serverData.index == index then
    redlog("RecallFundProxy:IsActivityValid 活动有效", index)
    return true
  end
  redlog("RecallFundProxy:IsActivityValid 有静态配置但无服务器数据", index)
  return true
end

function RecallFundProxy:GetActivityTime(index)
  local serverData = self:GetFundData()
  if serverData and serverData.index == index then
    local startTime = serverData.start_time
    local endTime = serverData.end_time
    xdlog("RecallFundProxy:GetActivityTime", index, startTime, endTime)
    return startTime, endTime
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  local defaultStartTime = currentTime - 86400
  local defaultEndTime = currentTime + 1123200
  return defaultStartTime, defaultEndTime
end

function RecallFundProxy:HasServerData()
  return self.serverFundData ~= nil
end

function RecallFundProxy:InitPurchaseData()
  self.buyTime = 0
  self.purchaseCnt = 0
  self.purchaseLimit = 0
  self.canPurchase = true
end

function RecallFundProxy:HasPurchased()
  if self.serverFundData and self.serverFundData.active ~= nil then
    return self.serverFundData.active
  end
  return self.buyTime and self.buyTime > 0 and true or false
end

function RecallFundProxy:GetFundActive()
  if self.serverFundData and self.serverFundData.active ~= nil then
    return self.serverFundData.active
  end
  return false
end

function RecallFundProxy:CanPurchase()
  if self:HasPurchased() then
    return false
  end
  if self.canPurchase == false or self.purchaseCnt and self.purchaseCnt > 0 then
    return false
  end
  return true
end

function RecallFundProxy:UpdatePurchaseData(buyTime)
  if buyTime then
    self.buyTime = buyTime
    xdlog("RecallFundProxy:UpdatePurchaseData 更新购买时间", buyTime)
  end
end

function RecallFundProxy:UpdatePurchaseCnt(serverData)
  if not serverData or not serverData.info then
    return
  end
  local depositId = GameConfig.UserRecall.FundDeposit
  if not depositId then
    return
  end
  for _, v in ipairs(serverData.info) do
    if v.dataid == depositId then
      self.purchaseCnt = v.count
      self.purchaseLimit = v.limit
      xdlog("RecallFundProxy:UpdatePurchaseCnt 更新购买次数", v.count, v.limit)
      break
    end
  end
end

function RecallFundProxy:RecvChargeQueryCmd(serverData)
  if not serverData then
    return
  end
  local depositId = GameConfig.UserRecall.FundDeposit
  if not depositId then
    return
  end
  if depositId == serverData.data_id then
    self.purchaseCnt = serverData.charged_count or 0
    self.canPurchase = serverData.ret
    xdlog("RecallFundProxy:RecvChargeQueryCmd 更新购买记录", self.purchaseCnt, self.canPurchase)
  end
end

function RecallFundProxy:GetDisplayInfo()
  if self.serverFundData and self.serverFundData.start_time and self.serverFundData.end_time then
    local startTime = self.serverFundData.start_time
    local endTime = self.serverFundData.end_time
    return {startTime = startTime, endTime = endTime}
  end
  return {startTime = 0, endTime = 0}
end

function RecallFundProxy:UpdateRedTipStatus()
  if not RedTipProxy or not RedTipProxy.Instance then
    return
  end
  local redTipId = 10778
  local subTipId = 1003
  if self:HasRewardToGet() then
    RedTipProxy.Instance:AddRedTipParam(redTipId, subTipId)
  else
    RedTipProxy.Instance:RemoveRedTipParam(redTipId, subTipId)
  end
end
