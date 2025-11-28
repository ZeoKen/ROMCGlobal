RecallSignProxy = class("RecallSignProxy", pm.Proxy)
RecallSignProxy.Instance = nil
RecallSignProxy.NAME = "RecallSignProxy"

function RecallSignProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallSignProxy.NAME
  if RecallSignProxy.Instance == nil then
    RecallSignProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RecallSignProxy:Init()
  self.staticSignData = {}
  self.serverSignData = {}
  self:InitStaticData()
end

function RecallSignProxy:InitStaticData()
  if not Table_UserRecall_Sign then
    redlog("表格不存在 Table_UserRecall_Sign")
    return
  end
  for id, info in pairs(Table_UserRecall_Sign) do
    local index = info.Index
    local day = info.Day
    if not self.staticSignData[index] then
      self.staticSignData[index] = {}
    end
    self.staticSignData[index][day] = id
  end
end

function RecallSignProxy:UpdateSignData(index, serverData)
  if not index or not serverData then
    redlog("RecallSignProxy:UpdateSignData 参数无效", index, serverData)
    return
  end
  self.serverSignData = {}
  local actualIndex
  if RecallInfoProxy.Instance then
    actualIndex = RecallInfoProxy.Instance:GetIndex(serverData.index + 1)
  end
  if not actualIndex then
    redlog("RecallSignProxy:UpdateSignData 无法获取实际配置索引", "serverIndex:", serverData.index)
    actualIndex = serverData.index
  end
  local endTime = serverData.end_time
  if serverData.start_time and RecallInfoProxy.Instance then
    local continueDay = RecallInfoProxy.Instance:GetContinueDay("SignIn", actualIndex)
    if continueDay then
      endTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(serverData.start_time + continueDay * 86400)
    end
  end
  self.serverSignData[index] = {
    index = serverData.index,
    start_time = serverData.start_time,
    end_time = endTime,
    cur_day = serverData.cur_day,
    next_time = serverData.next_time
  }
  xdlog("RecallSignProxy:UpdateSignData", index, TableUtil.Print(self.serverSignData))
  self:UpdateRedTipStatus(index)
end

function RecallSignProxy:GetSignData(index)
  return self.serverSignData[index]
end

function RecallSignProxy:GetStaticSignId(index, day)
  if self.staticSignData[index] and self.staticSignData[index][day] then
    return self.staticSignData[index][day]
  end
  return nil
end

function RecallSignProxy:GetStaticSignDataByIndex(index)
  if not self.staticSignData then
    redlog("RecallSignProxy:GetStaticSignDataByIndex staticSignData为nil!")
    return nil
  end
  if not self.staticSignData[index] then
    redlog("RecallSignProxy:GetStaticSignDataByIndex 静态数据不存在", "Index:", index)
    return nil
  end
  return self.staticSignData[index]
end

function RecallSignProxy:CanSignIn(index)
  local signData = self:GetSignData(index)
  if not signData then
    return false
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  if signData.start_time and signData.end_time and (currentTime < signData.start_time or currentTime > signData.end_time) then
    return false
  end
  if signData.next_time and currentTime < signData.next_time then
    return false
  end
  return true
end

function RecallSignProxy:IsActivityValid(index)
  local signData = self:GetSignData(index)
  if not signData then
    return false
  end
  if not signData.start_time or not signData.end_time then
    return false
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  return currentTime >= signData.start_time and currentTime <= signData.end_time
end

function RecallSignProxy:GetRewardConfig(index, day)
  local signId = self:GetStaticSignId(index, day)
  if signId and Table_UserRecall_Sign[signId] then
    return Table_UserRecall_Sign[signId].Reward
  end
  return nil
end

function RecallSignProxy:GetCurrentSignDay(index)
  local signData = self:GetSignData(index)
  return signData and signData.cur_day or 0
end

function RecallSignProxy:GetActivityTime(index)
  local signData = self:GetSignData(index)
  if signData then
    return signData.start_time, signData.end_time
  end
  return nil, nil
end

function RecallSignProxy:GetNextSignTime(index)
  local signData = self:GetSignData(index)
  return signData and signData.next_time or 0
end

function RecallSignProxy:GetValidSignIndexes()
  local indexes = {}
  for index, _ in pairs(self.serverSignData) do
    if self:IsActivityValid(index) then
      table.insert(indexes, index)
    end
  end
  return indexes
end

function RecallSignProxy:HasServerData()
  return next(self.serverSignData) ~= nil
end

function RecallSignProxy:GetSignDataFirst()
  for index, signData in pairs(self.serverSignData) do
    return signData
  end
  return nil
end

function RecallSignProxy:GetDisplayInfo()
  for index, signData in pairs(self.serverSignData) do
    if signData.start_time and signData.end_time then
      return {
        startTime = signData.start_time,
        endTime = signData.end_time
      }
    end
  end
  return {startTime = 0, endTime = 0}
end

function RecallSignProxy:UpdateRedTipStatus(index)
  if not RedTipProxy or not RedTipProxy.Instance then
    return
  end
  local redTipId = 10778
  local subTipId = 1001
  if self:CanSignIn(index) then
    RedTipProxy.Instance:AddRedTipParam(redTipId, subTipId)
  else
    RedTipProxy.Instance:RemoveRedTipParam(redTipId, subTipId)
  end
end

function RecallSignProxy:HasCanSignInActivity()
  for index, _ in pairs(self.serverSignData) do
    if self:CanSignIn(index) then
      return true
    end
  end
  return false
end
