RecallInfoProxy = class("RecallInfoProxy", pm.Proxy)
RecallInfoProxy.Instance = nil
RecallInfoProxy.NAME = "RecallInfoProxy"

function RecallInfoProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallInfoProxy.NAME
  if RecallInfoProxy.Instance == nil then
    RecallInfoProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RecallInfoProxy:Init()
  self.indexes = {}
  self.continueDayMap = {}
  self:InitContinueDayData()
end

function RecallInfoProxy:UpdateInfo(info)
  self.startTime = info.start_time
  self.acc_offline_time = info.acc_offline_time
  TableUtility.ArrayClear(self.indexes)
  for i = 1, #info.indexs do
    table.insert(self.indexes, info.indexs[i])
  end
end

function RecallInfoProxy:GetIndex(index)
  return self.indexes[index]
end

function RecallInfoProxy:GetTotalBatchCount()
  return #self.indexes
end

function RecallInfoProxy:InitContinueDayData()
  if not Table_UserRecall then
    redlog("RecallInfoProxy:InitContinueDayData 表格不存在 Table_UserRecall")
    return
  end
  self.continueDayMap = {}
  for id, config in pairs(Table_UserRecall) do
    local activityType = config.Type
    local index = config.Index
    local continueDay = config.ContinueDay
    if not self.continueDayMap[activityType] then
      self.continueDayMap[activityType] = {}
    end
    self.continueDayMap[activityType][index] = continueDay
  end
  xdlog("RecallInfoProxy:InitContinueDayData 持续时间数据初始化完成")
end

function RecallInfoProxy:GetContinueDay(activityType, index)
  if self.continueDayMap[activityType] and self.continueDayMap[activityType][index] then
    return self.continueDayMap[activityType][index]
  end
  redlog("RecallInfoProxy:GetContinueDay 未找到持续天数配置", "Type:", activityType, "Index:", index)
  return nil
end
