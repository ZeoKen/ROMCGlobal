GlobalActivityProxy = class("GlobalActivityProxy", pm.Proxy)
GlobalActivityProxy.NAME = "GlobalActivityProxy"

function GlobalActivityProxy:ctor(proxyName, data)
  self.proxyName = proxyName or self.NAME
  if not _G[self.proxyName].Instance then
    _G[self.proxyName].Instance = self
  end
  if data then
    self:setData(data)
  end
  self:InitActConfig()
end

function GlobalActivityProxy:InitActConfig()
  self.actIdMap, self.activityMap = {}, {}
  if self.Config then
    for id, _ in pairs(self.Config) do
      self.actIdMap[id] = true
    end
  end
end

function GlobalActivityProxy:AddActivity(id, startTime, endTime)
  if not self:CheckActivityId(id) then
    return
  end
  local data = self.activityMap[id]
  if data then
    data:UpdateInfo(nil, startTime, endTime)
  else
    data = ActivityData.new(ActivityCmd_pb.GACTIVITY_GLOBAL_DONATE, nil, startTime, endTime)
    self.activityMap[id] = data
  end
  self:OnAddActivity(data)
end

function GlobalActivityProxy:OnAddActivity(activityData)
end

function GlobalActivityProxy:RemoveActivity(id)
  if self.activityMap[id] then
    self.activityMap[id]:Destroy()
    self.activityMap[id] = nil
  end
  self:OnRemoveActivity(id)
end

function GlobalActivityProxy:OnRemoveActivity(id)
end

function GlobalActivityProxy:CheckActivityId(id)
  return id and self.actIdMap and self.actIdMap[id] or false
end

function GlobalActivityProxy:CheckActivityValid(id)
  if id then
    local data = self.activityMap[id]
    return data ~= nil and data:InRunningTime()
  else
    local rslt = false
    for aId, _ in pairs(self.activityMap) do
      rslt = rslt or self:CheckActivityValid(aId)
    end
    return rslt
  end
end

function GlobalActivityProxy:GetActivityTimeText(id, format)
  format = format or ZhString.MidSummerAct_ActTime
  local text = ""
  self:_TryActionByActId(id, function(actId, formatStr, self)
    local actData = self.activityMap[actId]
    if actData then
      local startTime, endTime = actData:GetDuringTime()
      text = ServantCalendarProxy.GetTimeDate(startTime, endTime, formatStr)
    end
  end, format, self)
  return text
end

function GlobalActivityProxy:SetShowingActivity(id)
  self.showingActId = id
end

function GlobalActivityProxy:ClearShowingActivity()
  self:SetShowingActivity()
end

function GlobalActivityProxy:_TryActionByActId(id, action, ...)
  id = id or self.showingActId
  if self:CheckActivityId(id) then
    if action then
      action(id, ...)
    else
      LogUtility.Warning("ArgumentNilException: there is no action!")
    end
  else
    LogUtility.Warning("Checking actId failed. Nothing will happen.")
  end
end
