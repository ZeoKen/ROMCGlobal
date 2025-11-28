autoImport("GameConfigActivityData")
autoImport("Anniversary2023CellData")
Anniversary2023Data = class("Anniversary2023Data", GameConfigActivityData)

function Anniversary2023Data:ctor(activityData)
  self.globalConfig = Table_AnniversaryLive
  Anniversary2023Data.super.ctor(self, activityData)
end

function Anniversary2023Data:SetData(activityData)
  if not Anniversary2023Data.super.SetData(self, activityData) then
    return false
  end
  local config = self:GetConfig()
  if not config then
    return
  end
  if EnvChannel.IsTFBranch() then
    self.signinStartTime = StringUtil.FormatTime2TimeStamp2(config.TfSignInDuration[1])
    self.signinStartDate = self.signinStartTime and os.date("*t", self.signinStartTime)
    self.signinEndTime = StringUtil.FormatTime2TimeStamp2(config.TfSignInDuration[2])
    self.signinEndDate = self.signinEndTime and os.date("*t", self.signinEndTime)
    self.liveStartTime = StringUtil.FormatTime2TimeStamp2(config.TFLiveDuration[1])
    self.liveEndTime = StringUtil.FormatTime2TimeStamp2(config.TFLiveDuration[2])
  else
    self.signinStartTime = StringUtil.FormatTime2TimeStamp2(config.SignInDuration[1])
    self.signinStartDate = self.signinStartTime and os.date("*t", self.signinStartTime)
    self.signinEndTime = StringUtil.FormatTime2TimeStamp2(config.SignInDuration[2])
    self.signinEndDate = self.signinEndTime and os.date("*t", self.signinEndTime)
    self.liveStartTime = StringUtil.FormatTime2TimeStamp2(config.LiveDuration[1])
    self.liveEndTime = StringUtil.FormatTime2TimeStamp2(config.LiveDuration[2])
  end
  return true
end

function Anniversary2023Data:UpdateServerData(serverData)
  local config = self:GetConfig()
  if not config then
    return
  end
  if not self.dataList then
    self.dataList = {}
  end
  self.scrollToIndex = 1
  local newCount = #serverData.sign_ins
  for i, v in ipairs(serverData.sign_ins) do
    local data = self.dataList[i]
    if not data then
      data = Anniversary2023CellData.new(v, config)
      self.dataList[i] = data
    else
      data:SetData(v, config)
    end
    if data:IsRewarded() then
      self.scrollToIndex = i
    end
  end
  if self.scrollToIndex == newCount then
    self.scrollToIndex = nil
  end
  for i = #self.dataList, newCount + 1, -1 do
    table.remove(self.dataList, i)
  end
  if self.extraData then
    self.extraData:SetData(serverData.share_data, config, true)
  else
    self.extraData = Anniversary2023CellData.new(serverData.share_data, config, true)
  end
end

function Anniversary2023Data:HasUntakenReward()
  if self.extraData and self.extraData:CanTakeReward() then
    return true
  end
  if self.dataList then
    for _, data in ipairs(self.dataList) do
      if data:CanTakeReward() then
        return true
      end
    end
  end
  return false
end

function Anniversary2023Data:GetSigninPeriodStr()
  if self.signinStartDate and self.signinEndDate then
    return string.format(ZhString.TimePeriodFormat3, self.signinStartDate.month, self.signinStartDate.day, self.signinStartDate.hour, self.signinStartDate.min, self.signinEndDate.month, self.signinEndDate.day, self.signinEndDate.hour, self.signinEndDate.min)
  end
  return ""
end

function Anniversary2023Data:IsSigninEnd()
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if self.signinEndTime and serverTime >= self.signinEndTime then
    return true
  end
  return false
end

function Anniversary2023Data:IsInLivePeriod()
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if self.liveStartTime and self.liveEndTime and serverTime >= self.liveStartTime and serverTime <= self.liveEndTime then
    return true
  end
  return false
end

function Anniversary2023Data:HasLiveEnded()
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if self.liveEndTime and serverTime > self.liveEndTime then
    return true
  end
  return false
end

function Anniversary2023Data:GetLiveCD()
  local serverTime = ServerTime.CurServerTime()
  serverTime = serverTime and serverTime / 1000 or 0
  if self.liveStartTime then
    return self.liveStartTime - serverTime
  end
end

function Anniversary2023Data:GetCellData(index)
  return self.dataList and self.dataList[index]
end

function Anniversary2023Data:GetLuckyNumStr(pattern, delimiter)
  local tempArray = {}
  if self.extraData and self.extraData:IsLuckyNumValid() then
    table.insert(tempArray, string.format(pattern, self.extraData.luckyNum))
  end
  if self.dataList then
    for _, data in ipairs(self.dataList) do
      if data and data:IsLuckyNumValid() then
        table.insert(tempArray, string.format(pattern, data.luckyNum))
      end
    end
  end
  return table.concat(tempArray, delimiter)
end
