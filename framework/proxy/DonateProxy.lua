autoImport("DonateMatData")
autoImport("ExchangeActivityData")
DonateProxy = class("DonateProxy", pm.Proxy)
DonateProxy.Instance = nil
DonateProxy.NAME = "DonateProxy"

function DonateProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DonateProxy.NAME
  if DonateProxy.Instance == nil then
    DonateProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:ProcessActivityId()
  self.activityMap = {}
end

function DonateProxy:ProcessActivityId()
  self.npcFuncMap = {}
  local gameConfig_Donate = GameConfig.Donate
  if not gameConfig_Donate then
    return
  end
  for k, v in pairs(gameConfig_Donate) do
    self.npcFuncMap[v.npcfunction] = k
  end
end

function DonateProxy:AddActivity(actType, id, startTime, endTime)
  local activityData = self.activityMap[id]
  if not activityData then
    activityData = ActivityData.new(actType, nil, startTime, endTime)
    self.activityMap[id] = activityData
  else
    activityData:UpdateInfo(nil, startTime, endTime)
  end
end

function DonateProxy:CheckActivityValid(npcFunctionId)
  local activeId = self.npcFuncMap[npcFunctionId]
  if not activeId then
    return false
  end
  local activityData = self.activityMap[activeId]
  if activityData then
    return activityData:InRunningTime()
  else
    return false
  end
end

function DonateProxy:InitByAct(npcFunctionId)
  local activeId = self.npcFuncMap[npcFunctionId]
  if not activeId then
    return
  end
  local gameConfigStatic = GameConfig.Donate[activeId]
  if not gameConfigStatic then
    return
  end
  local cfgStatic = {}
  for k, v in pairs(Table_DonateActivity) do
    if v.ActivityID == activeId then
      local donateData = DonateMatData.new(v)
      cfgStatic[#cfgStatic + 1] = donateData
    end
  end
  self.curActivity = activeId
  self.donateActivityName = gameConfigStatic.donate_name
  self.donateTotalCount = gameConfigStatic.donate_limit
  self.bgTex = gameConfigStatic.donate_background
  self.donateActivity = cfgStatic
end

function DonateProxy:ResetParam()
  self.curActivityDay = nil
  self.curActivity = nil
end

function DonateProxy:RemoveActivity(activeId)
  local act = self.activityMap[activeId]
  if act then
    act:Destroy()
  end
  self.activityMap[activeId] = nil
end

function DonateProxy:GetDonateMatByDay(day)
  local result = {}
  for i = 1, #self.donateActivity do
    if self.donateActivity[i].day == day then
      result[#result + 1] = self.donateActivity[i]
    end
  end
  return result
end

local DAY_SECOND = 86400

function DonateProxy:SetQueryActivityDay()
  self.curActivityDay = nil
  local actData = self:GetCurActivityData()
  if nil ~= actData then
    local st, et = actData:GetDuringTime()
    local now = ServerTime.CurServerTime() / 1000
    local interval = now - st
    if interval < DAY_SECOND then
      self.curActivityDay = 1
    else
      self.curActivityDay = math.ceil(interval / DAY_SECOND)
    end
    helplog("当前活动第几天： ", self.curActivityDay)
  end
  return nil ~= self.curActivityDay
end

function DonateProxy:GetCurActivityData()
  local curActivity = self.curActivity
  if curActivity then
    return self.activityMap[curActivity]
  end
  return nil
end

function DonateProxy:DoQueryDonateTime()
  ServiceNUserProxy.Instance:CallActivityDonateQueryUserCmd(self.curActivity)
end

function DonateProxy:HandleRecvDonateTime(data)
  self.curDonateCount = data.times
end

function DonateProxy:GetDonateCount()
  return self.curDonateCount or 0
end

function DonateProxy:GetDonateTotalCount()
  return self.donateTotalCount or 0
end

function DonateProxy:DoDonate(itemId, count)
  local oldActivityDay = self.curActivityDay
  if nil == oldActivityDay then
    return false
  end
  self:SetQueryActivityDay()
  local nowActivityDay = self.curActivityDay
  if nil == nowActivityDay or oldActivityDay ~= nowActivityDay then
    MsgManager.ShowMsgByID(41467)
    return false
  end
  if self:GetDonateCount() >= self:GetDonateTotalCount() then
    MsgManager.ShowMsgByID(3702)
    return
  end
  local activeId = self.curActivity
  local iteminfo = {id = itemId, count = count}
  ServiceNUserProxy.Instance:CallActivityDonateRewardUserCmd(activeId, iteminfo)
  return true
end

function DonateProxy:HandleRecvDonate(data)
  if not data.success then
    return
  end
  self.curDonateCount = data.times
end

function DonateProxy:HandleActivityExchangeGiftsQueryUserCmd(data)
  if not self.exchangeActivityMap then
    self.exchangeActivityMap = {}
  end
  self.exchangeActivityMap[data.activityid] = ExchangeActivityData.new(data)
end

function DonateProxy:GetExchangeGifts(activityid)
  if activityid and self.exchangeActivityMap and self.exchangeActivityMap[activityid] then
    return self.exchangeActivityMap[activityid]:GetMaterials()
  end
end

function DonateProxy:GetExchangeCount(activityid)
  if activityid and self.exchangeActivityMap and self.exchangeActivityMap[activityid] then
    return self.exchangeActivityMap[activityid].times
  end
  return 0
end

function DonateProxy:GetExchangeLimit(activityid)
  if activityid and Table_ActPersonalTimer[activityid] and Table_ActPersonalTimer[activityid].Misc then
    return Table_ActPersonalTimer[activityid].Misc.ExchangeNumPerDay
  end
  return 0
end
