ActivityChallengeProxy = class("ActivityChallengeProxy", pm.Proxy)
ActivityChallengeProxy.Instance = nil
ActivityChallengeProxy.NAME = "ActivityChallengeProxy"

function ActivityChallengeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityChallengeProxy.NAME
  if ActivityChallengeProxy.Instance == nil then
    ActivityChallengeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityChallengeProxy:Init()
  self.challengeData = {}
  self:InitChallengeData()
end

function ActivityChallengeProxy:InitChallengeData()
  if not Table_NewServerChallengeTarget then
    return
  end
  for id, config in pairs(Table_NewServerChallengeTarget) do
    if not config.BatchID or config.BatchID == 0 then
      local actID = config.ActID
      if not self.challengeData[actID] then
        self.challengeData[actID] = {}
      end
      self.challengeData[actID][id] = config
    end
  end
end

function ActivityChallengeProxy:BatchChallengeData(activityId, batchID)
  if not self.challengeData[activityId] then
    return
  end
  if not batchID or batchID == 0 then
    return
  end
  if not Table_NewServerChallengeTarget then
    return
  end
  for id, config in pairs(Table_NewServerChallengeTarget) do
    if config.ActID == activityId and config.BatchID == batchID then
      self.challengeData[activityId][id] = config
      xdlog("合并挑战任务批次数据", activityId, batchID, id)
    end
  end
end

function ActivityChallengeProxy:GetChallengeConfigList(activityId)
  return self.challengeData[activityId]
end

function ActivityChallengeProxy:GetChallengeConfig(id)
  if not Table_NewServerChallengeTarget then
    return nil
  end
  return Table_NewServerChallengeTarget[id]
end

return ActivityChallengeProxy
