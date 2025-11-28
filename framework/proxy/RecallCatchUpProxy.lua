RecallCatchUpProxy = class("RecallCatchUpProxy", pm.Proxy)
RecallCatchUpProxy.Instance = nil
RecallCatchUpProxy.NAME = "RecallCatchUpProxy"

function RecallCatchUpProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallCatchUpProxy.NAME
  if RecallCatchUpProxy.Instance == nil then
    RecallCatchUpProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RecallCatchUpProxy:Init()
  self.staticCatchUpData = {}
  self.latestCatchUpData = nil
  self:InitStaticData()
end

function RecallCatchUpProxy:InitStaticData()
  if not Table_UserRecall_CatchUp then
    redlog("表格不存在 Table_UserRecall_CatchUp")
    return
  end
  self.staticCatchUpData = {}
  for configId, config in pairs(Table_UserRecall_CatchUp) do
    local index = config.Index
    if index and config.Deposit then
      if not self.staticCatchUpData[index] then
        self.staticCatchUpData[index] = {}
      end
      local depositData = {
        configId = configId,
        config = config,
        depositID = config.Deposit
      }
      table.insert(self.staticCatchUpData[index], depositData)
    end
  end
end

function RecallCatchUpProxy:UpdateCatchUpData(data)
  if not data then
    redlog("RecallCatchUpProxy:UpdateCatchUpData 参数无效", data)
    return
  end
  self.latestCatchUpData = nil
  local maxIndex = -1
  if data.adv_pass then
    for i, passData in ipairs(data.adv_pass) do
      if passData.index and maxIndex < passData.index then
        local actualIndex = RecallInfoProxy.Instance:GetIndex(passData.index + 1) or passData.index
        local endTime = passData.end_time
        if passData.start_time and RecallInfoProxy.Instance then
          local continueDay = RecallInfoProxy.Instance:GetContinueDay("CatchUp", actualIndex)
          if continueDay then
            endTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(passData.start_time + continueDay * 86400)
          end
        end
        maxIndex = passData.index
        self.latestCatchUpData = {
          index = passData.index,
          start_time = passData.start_time,
          end_time = endTime
        }
      end
    end
  end
  xdlog("RecallCatchUpProxy:UpdateCatchUpData 最新数据", TableUtil.Print(self.latestCatchUpData))
end

function RecallCatchUpProxy:GetLatestCatchUpData()
  return self.latestCatchUpData
end

function RecallCatchUpProxy:GetStaticCatchUpData(index)
  return self.staticCatchUpData[index] or {}
end

function RecallCatchUpProxy:GetDisplayDataList()
  local dataList = {}
  local latestCatchUpData = self.latestCatchUpData
  if latestCatchUpData then
    local latestIndex = latestCatchUpData.index
    local staticDataArray = self:GetStaticCatchUpData(latestIndex + 1)
    if staticDataArray and 0 < #staticDataArray then
      for _, staticData in ipairs(staticDataArray) do
        local depositConfig = Table_Deposit and Table_Deposit[staticData.depositID]
        if depositConfig then
          local displayData = {
            index = latestIndex,
            depositID = staticData.depositID,
            depositConfig = depositConfig,
            catchUpData = latestCatchUpData,
            startTime = latestCatchUpData.start_time,
            configId = staticData.configId,
            staticConfig = staticData.config
          }
          table.insert(dataList, displayData)
        end
      end
    end
  end
  return dataList
end

function RecallCatchUpProxy:GetDisplayInfo()
  local latestCatchUpData = self.latestCatchUpData
  if latestCatchUpData then
    return {
      startTime = latestCatchUpData.start_time or 0,
      endTime = latestCatchUpData.end_time or 0
    }
  end
  return {startTime = 0, endTime = 0}
end

function RecallCatchUpProxy:HasServerData()
  return self.latestCatchUpData ~= nil
end

function RecallCatchUpProxy:IsActivityEnded()
  local latestCatchUpData = self.latestCatchUpData
  if not latestCatchUpData then
    return true
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  if latestCatchUpData.end_time and currentTime < latestCatchUpData.end_time then
    return false
  end
  return true
end

function RecallCatchUpProxy:GetCatchUpDataFirst()
  return self.latestCatchUpData
end

function RecallCatchUpProxy:RequestCatchUpData()
  ServiceRecallCCmdProxy.Instance:CallCatchUpQueryInfoRecallCmd()
end
