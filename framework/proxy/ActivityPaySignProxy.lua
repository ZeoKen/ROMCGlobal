ActivityPaySignProxy = class("ActivityPaySignProxy", pm.Proxy)
ActivityPaySignProxy.Instance = nil
ActivityPaySignProxy.NAME = "ActivityPaySignProxy"

function ActivityPaySignProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityPaySignProxy.NAME
  if ActivityPaySignProxy.Instance == nil then
    ActivityPaySignProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityPaySignProxy:Init()
  self.signDatas = {}
end

function ActivityPaySignProxy:InitSignDatas()
  for act_id, config in pairs(Game.Config_ActPaySign) do
    local signData = self.signDatas[act_id]
    if not signData then
      signData = {}
      signData.act_id = act_id
      signData.staticData = {}
      self.signDatas[act_id] = signData
    end
    local templateData = config[0]
    if templateData then
      for day, v in pairs(templateData) do
        signData.staticData[day] = v
        if not signData.deposit_id then
          signData.deposit_id = v.DepositID
        end
      end
    end
  end
end

function ActivityPaySignProxy:BatchSignDatas(act_id, batch_id)
  self:InitSignDatas()
  local signData = self.signDatas[act_id]
  if not signData then
    signData = {}
    signData.act_id = act_id
    signData.staticData = {}
    self.signDatas[act_id] = signData
  end
  local config = Game.Config_ActPaySign[act_id]
  if not config then
    redlog("ActPaySign表中无活动数据：", act_id)
    return
  end
  local batchData = config[batch_id]
  if batchData then
    for day, v in pairs(batchData) do
      signData.staticData[day] = v
      if not signData.deposit_id then
        signData.deposit_id = v.DepositID
      end
    end
    signData.batch_id = batch_id
  end
end

function ActivityPaySignProxy:UpdatePaySignDatas(serverData)
  if serverData then
    self:BatchSignDatas(serverData.act_id, serverData.batch_id)
    local signData = self.signDatas[serverData.act_id]
    signData.signed_day = serverData.signed_count or 0
    signData.rewarded_normal_day = serverData.rewarded_normal_day or 0
    signData.rewarded_pro_day = serverData.rewarded_pro_day or 0
    signData.is_pro = serverData.is_pro or false
  end
end

function ActivityPaySignProxy:GetSignDayConfig(act_id, day)
  local signData = self.signDatas[act_id]
  return signData and signData.staticData and signData.staticData[day]
end

function ActivityPaySignProxy:GetCurSignedDay(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.signed_day or 0
end

function ActivityPaySignProxy:GetRewardedNormalDay(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.rewarded_normal_day or 0
end

function ActivityPaySignProxy:GetRewardedProDay(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.rewarded_pro_day or 0
end

function ActivityPaySignProxy:IsPro(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.is_pro or false
end

function ActivityPaySignProxy:GetNextImportantDay(act_id, day)
  local staticData = self.signDatas[act_id] and self.signDatas[act_id].staticData
  if staticData then
    for i = day, #staticData do
      local data = staticData[i]
      if data.Important == 1 then
        return i
      end
    end
  end
end

function ActivityPaySignProxy:GetMaxSignDay(act_id)
  local staticData = self.signDatas[act_id] and self.signDatas[act_id].staticData
  if staticData then
    return #staticData
  end
  return 0
end

function ActivityPaySignProxy:IsNormalRewardReceived(act_id, day)
  return day <= self:GetRewardedNormalDay(act_id)
end

function ActivityPaySignProxy:IsProRewardReceived(act_id, day)
  return day <= self:GetRewardedProDay(act_id)
end

function ActivityPaySignProxy:IsNormalRewardLocked(act_id, day)
  local curDay = self:GetCurSignedDay(act_id)
  return day > curDay
end

function ActivityPaySignProxy:IsProRewardLocked(act_id, day)
  local curDay = self:GetCurSignedDay(act_id)
  return not self:IsPro(act_id) or day > curDay
end

function ActivityPaySignProxy:IsHaveAvailableReward(act_id)
  local curDay = self:GetCurSignedDay(act_id)
  for i = 1, curDay do
    local isNormalAvailable = not self:IsNormalRewardReceived(act_id, i)
    if isNormalAvailable then
      return true
    end
    if self:IsPro(act_id) then
      local isProAvailable = not self:IsProRewardReceived(act_id, i)
      if isProAvailable then
        return true
      end
    end
  end
  return false
end

function ActivityPaySignProxy:GetDepositID(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.deposit_id or 0
end

function ActivityPaySignProxy:GetBatchID(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.batch_id or 0
end

function ActivityPaySignProxy:IsPaySignAvailable(act_id)
  local signData = self.signDatas[act_id]
  local curTime = ServerTime.CurServerTime() / 1000
  local startTime = signData and signData.startTime
  local endTime = signData and signData.endTime
  if startTime and endTime then
    return curTime >= startTime and curTime < endTime
  end
  return false
end

function ActivityPaySignProxy:UpdateGlobalActTime(act_id, startTime, endTime)
  local signData = self.signDatas[act_id]
  if signData then
    signData.startTime = startTime
    signData.endTime = endTime
  end
end

function ActivityPaySignProxy:GetGlobalActTime(act_id)
  local signData = self.signDatas[act_id]
  return signData and signData.startTime, signData and signData.endTime
end
