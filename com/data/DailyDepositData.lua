DailyDepositData = class("DailyDepositData")
local RewardState = {
  UnTaken = 1,
  CannotTake = 2,
  Taken = 3
}
DailyDepositData.RewardState = RewardState

function DailyDepositData:ctor(serverData)
  self:SetData(serverData)
end

function DailyDepositData:SetData(serverData)
  if not serverData or not GameConfig.DailyDeposit then
    return
  end
  self.actId = serverData.version
  self.taken = {}
  if serverData.gotten_rewards then
    for _, v in ipairs(serverData.gotten_rewards) do
      table.insert(self.taken, v)
    end
  end
  self.totalDeposit = serverData.deposit_gold or 0
  self.startTime = serverData.start_time
  self.endTime = serverData.end_time
  local config = self:GetConfig()
  if not config then
    return
  end
  if not self.rewardDatas then
    self.rewardDatas = {}
    for i, rewardConfig in ipairs(config.Rewards) do
      local rewardData = {}
      rewardData.id = i
      rewardData.NeedDeposit = rewardConfig.NeedDeposit or 0
      rewardData.Condition = string.format(config.Msgs[rewardConfig.MsgId], unpack(rewardConfig.MsgParams))
      local items = {}
      for _, itemConfig in ipairs(rewardConfig.Items) do
        local item = ItemData.new("", itemConfig[1])
        item:SetItemNum(itemConfig[2])
        table.insert(items, item)
      end
      rewardData.rewardItems = items
      table.insert(self.rewardDatas, rewardData)
    end
  end
  if self.rewardDatas then
    for i, v in ipairs(self.rewardDatas) do
      if table.ContainsValue(self.taken, i) then
        v.state = RewardState.Taken
      elseif self.totalDeposit >= v.NeedDeposit then
        v.state = RewardState.UnTaken
      else
        v.state = RewardState.CannotTake
      end
    end
  end
  self:SortRewardDatas()
end

function DailyDepositData:SortRewardDatas()
  if not self.rewardDatas then
    return
  end
  table.sort(self.rewardDatas, function(a, b)
    if a.state ~= b.state then
      return a.state < b.state
    else
      return a.id < b.id
    end
  end)
end

function DailyDepositData:GetRewardDatas()
  return self.rewardDatas
end

function DailyDepositData:HasUntakenReward()
  if not self.rewardDatas then
    return false
  end
  for _, v in ipairs(self.rewardDatas) do
    if v.state == RewardState.UnTaken then
      return true
    end
  end
  return false
end

function DailyDepositData:GetActId()
  return self.actId
end

function DailyDepositData:GetConfig()
  if GameConfig.DailyDeposit and self.actId then
    return GameConfig.DailyDeposit.VersionCfg[self.actId]
  end
end

function DailyDepositData:IsActive()
  local config = self:GetConfig()
  if not config then
    return false
  end
  local startTime, endTime = self:GetActivityPeriod()
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if not (startTime and endTime) or startTime > serverTime or endTime < serverTime then
    return false
  end
  return true
end

function DailyDepositData:GetTotalDeposit()
  return self.totalDeposit
end

function DailyDepositData:GetActivityPeriod()
  return self.startTime, self.endTime
end

function DailyDepositData:GetActivityPeriodStr()
  local startTime, endTime = self:GetActivityPeriod()
  if not startTime or not endTime then
    return ""
  end
  local startDate = os.date("%m/%d %H:%M", startTime)
  local endDate = os.date("%m/%d %H:%M", endTime)
  return string.format(ZhString.DailyDepositDate, startDate, endDate)
end
