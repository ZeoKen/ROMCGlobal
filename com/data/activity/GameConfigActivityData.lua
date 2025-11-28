GameConfigActivityData = class("GameConfigActivityData")

function GameConfigActivityData:ctor(activityData)
  self:SetData(activityData)
end

function GameConfigActivityData:SetData(activityData)
  if not activityData then
    return false
  end
  self.id = activityData.id
  self.activityType = activityData.type
  self.startTime = activityData.starttime
  self.startDate = self.startTime and os.date("*t", self.startTime)
  self.endTime = activityData.endtime
  self.endDate = self.endTime and os.date("*t", self.endTime)
  return true
end

function GameConfigActivityData:GetTimePeriodStr()
  if self.startDate and self.endDate then
    return string.format(ZhString.TimePeriodFormat3, self.startDate.month, self.startDate.day, self.startDate.hour, self.startDate.min, self.endDate.month, self.endDate.day, self.endDate.hour, self.endDate.min)
  end
  return ""
end

function GameConfigActivityData:GetGlobalConfig()
  return self.globalConfig
end

function GameConfigActivityData:GetConfig()
  return self.id and self.globalConfig and self.globalConfig[self.id]
end

function GameConfigActivityData:IsActive()
  if not self:GetConfig() then
    return false
  end
  if config.MenuID and config.MenuID ~= 0 and not FunctionUnLockFunc.Me():CheckCanOpen(config.MenuID) then
    return false
  end
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if not (self.startTime and self.endTime) or serverTime < self.startTime or serverTime > self.endTime then
    return false
  end
  return true
end
