GrouponProxy = class("GrouponProxy", pm.Proxy)
GrouponProxy.Instance = nil
GrouponProxy.NAME = "GrouponProxy"

function GrouponProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GrouponProxy.NAME
  if GrouponProxy.Instance == nil then
    GrouponProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitData()
end

function GrouponProxy:InitData()
  self.globalActMap = {}
  self.couponAct = {}
end

function GrouponProxy:RecvGrouponInfo(data)
  if self.globalActMap[data.activityid] then
    helplog("活动开启中，已初始化", data.activityid)
    local grouponData = data.info
    if grouponData then
      self.primaryID = grouponData.activityid
      local act = {}
      act.totalBuyCount = grouponData.total_count
      if grouponData.progressid then
        local reward = {}
        for i = 1, #grouponData.progressid do
          local single = grouponData.progressid[i]
          reward[single] = 1
        end
        act.recvedReward = reward
      end
      local count = 0
      if grouponData.records and 0 < #grouponData.records then
        for i = 1, #grouponData.records do
          count = count + grouponData.records[i].count
          grouponData.records[i].grouponid = grouponData.activityid
        end
      end
      act.buyRecords = grouponData.records
      act.myselfBuyCount = count
      self.couponAct[grouponData.activityid] = act
    end
  else
    redlog("Global Activity未开启，非法时间段获取到数据")
    local act = {}
    local grouponData = data.info
    if grouponData then
      self.primaryID = grouponData.activityid
      act.totalBuyCount = grouponData.total_count
      act.myselfBuyCount = grouponData.count
      act.recvedReward = grouponData.progressid
      act.buyRecords = grouponData.records
      local count = 0
      if grouponData.records and 0 < #grouponData.records then
        for i = 1, #grouponData.records do
          count = count + grouponData.records[i].count
        end
      end
      act.myselfBuyCount = count
      self.couponAct[data.activityid] = act
    end
  end
end

function GrouponProxy:SetGlobalAct(data)
  redlog("团购活动---》开启状态", data.open)
  if data.open then
    self.primaryID = data.id
    redlog("primaryid", self.primaryID)
    self.globalActMap[data.id] = GrouponAct.new(data)
  else
    self.globalActMap[data.id] = nil
  end
end

function GrouponProxy:SetCurrentDiscountStatus(grouponid, level, price)
  if not self.couponAct[grouponid] then
    redlog("当前团购活动id", grouponid, "不存在")
    return
  end
  self.couponAct[grouponid].discountLevel = level
  self.couponAct[grouponid].currentPrice = price
end

function GrouponProxy:IsActTimeValid(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return gAct:IsActTimeValid()
  end
end

function GrouponProxy:ActRealOpen(id)
  if not self.globalActMap[id] then
    return false
  end
  return self:IsActTimeValid(id)
end

function GrouponProxy:GetEndTime(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return gAct.endtime
  end
  for k, v in pairs(self.globalActMap) do
    return v.endtime
  end
end

GrouponAct = class("GrouponAct")

function GrouponAct:ctor(data)
  self.open = data.open
  self.starttime = data.starttime
  self.endtime = data.endtime
  self.type = data.type
end

function GrouponAct:IsActTimeValid()
  local curTime = ServerTime.CurServerTime() / 1000
  if self.starttime and self.endtime then
    helplog("对比时间")
    if curTime > self.starttime and curTime < self.endtime then
      return true
    end
  end
  return false
end
