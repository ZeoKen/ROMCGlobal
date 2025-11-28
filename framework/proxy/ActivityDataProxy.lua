ActivityDataProxy = class("ActivityDataProxy", pm.Proxy)
ActivityDataProxy.Instance = nil
ActivityDataProxy.NAME = "ActivityDataProxy"
autoImport("ActivityGroupData")
autoImport("ActivitySubData")
autoImport("CurrentRecommendActivityData")

function ActivityDataProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityDataProxy.NAME
  if ActivityDataProxy.Instance == nil then
    ActivityDataProxy.Instance = self
  end
  self.activitys = {}
end

function ActivityDataProxy:InitActivityDatas(data)
  TableUtility.ArrayClear(self.activitys)
  local activitys = data.activity
  if activitys and 0 < #activitys then
    for i = 1, #activitys do
      local single = activitys[i]
      local data = ActivityGroupData.new(single)
      self.activitys[#self.activitys + 1] = data
    end
  end
end

function ActivityDataProxy:getActiveActivitys()
  if self.activitys and #self.activitys > 0 then
    local result = {}
    local currentTime = ServerTime.CurServerTime()
    currentTime = math.floor(currentTime / 1000)
    local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
    for i = 1, #self.activitys do
      local single = self.activitys[i]
      local monthcardForbid = single.monthcard and 0 < single.monthcard and (amIMonthlyVIP == true and 1 or 2) ~= single.monthcard
      if single:CheckRegionValid() and currentTime >= single.begintime and currentTime <= single.endtime and monthcardForbid ~= true then
        local subActs = single.sub_activity
        local valid = false
        if subActs and 0 < #subActs then
          for i = 1, #subActs do
            local singleSub = subActs[i]
            local monthcardSubForbid = singleSub.monthcard and 0 < singleSub.monthcard and (amIMonthlyVIP == true and 1 or 2) ~= singleSub.monthcard
            if currentTime >= singleSub.begintime and currentTime <= singleSub.endtime and monthcardSubForbid ~= true then
              valid = true
              break
            end
          end
        end
        if valid then
          result[#result + 1] = single
        end
      end
    end
    return result
  end
end

function ActivityDataProxy:getActiveSubActivitys(groupId)
  local currentTime = ServerTime.CurServerTime()
  currentTime = math.floor(currentTime / 1000)
  local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
  for i = 1, #self.activitys do
    local activity = self.activitys[i]
    if activity.id == groupId and activity:CheckRegionValid() then
      local subActs = activity.sub_activity
      if subActs and 0 < #subActs then
        local result = {}
        for i = 1, #subActs do
          local single = subActs[i]
          local monthcardForbid = single.monthcard and 0 < single.monthcard and (amIMonthlyVIP == true and 1 or 2) ~= single.monthcard
          if currentTime >= single.begintime and currentTime <= single.endtime and monthcardForbid ~= true then
            result[#result + 1] = single
          end
        end
        return result
      end
      break
    end
  end
end

function ActivityDataProxy:getActivitys()
  return self.activitys
end

function ActivityDataProxy:InitTimeLimitActivityInfo(data)
  if self.currentTimeLimitActivity == nil then
    self.currentTimeLimitActivity = CurrentRecommendActivityData.new(data)
  else
    self.currentTimeLimitActivity:SetData(data)
  end
end

function ActivityDataProxy:getCurrentTimeLimitActivity()
  return self.currentTimeLimitActivity
end
