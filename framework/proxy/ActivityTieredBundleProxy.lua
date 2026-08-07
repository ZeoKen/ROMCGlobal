ActivityTieredBundleProxy = class("ActivityTieredBundleProxy", pm.Proxy)
ActivityTieredBundleProxy.Instance = nil
ActivityTieredBundleProxy.NAME = "ActivityTieredBundleProxy"

function ActivityTieredBundleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityTieredBundleProxy.NAME
  if ActivityTieredBundleProxy.Instance == nil then
    ActivityTieredBundleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityTieredBundleProxy:Init()
  self.bundleDatas = {}
end

function ActivityTieredBundleProxy:GetOrCreateData(act_id)
  if not act_id then
    return
  end
  local data = self.bundleDatas[act_id]
  if not data then
    data = {
      act_id = act_id,
      rewardedMap = {}
    }
    self.bundleDatas[act_id] = data
  end
  return data
end

function ActivityTieredBundleProxy:UpdateGlobalActTime(act_id, startTime, endTime)
  local data = self:GetOrCreateData(act_id)
  if data then
    data.startTime = startTime
    data.endTime = endTime
    self:UpdateRedTips(act_id)
  end
end

function ActivityTieredBundleProxy:ClearGlobalAct(act_id)
  if act_id then
    self.bundleDatas[act_id] = nil
    self:RemoveRedTips(act_id)
  else
    for id in pairs(self.bundleDatas) do
      self:RemoveRedTips(id)
    end
    self.bundleDatas = {}
  end
end

function ActivityTieredBundleProxy:GetGlobalActTime(act_id)
  local data = self.bundleDatas[act_id]
  return data and data.startTime, data and data.endTime
end

function ActivityTieredBundleProxy:IsActivityAvailable(act_id)
  local data = self.bundleDatas[act_id]
  local startTime = data and data.startTime
  local endTime = data and data.endTime
  if startTime and endTime then
    local curTime = ServerTime.CurServerTime() / 1000
    return startTime <= curTime and endTime > curTime
  end
  return false
end

function ActivityTieredBundleProxy:UpdateTieredBundleInfo(info)
  if not info or not info.act_id then
    return
  end
  local data = self:GetOrCreateData(info.act_id)
  data.batch_id = info.batch_id or 0
  data.startTime = info.start_time or data.startTime
  data.endTime = info.end_time or data.endTime
  data.day_reward_time = info.day_reward_time or 0
  data.rewardedMap = {}
  local rewardedIds = info.rewarded_ids
  if rewardedIds then
    for i = 1, #rewardedIds do
      data.rewardedMap[rewardedIds[i]] = true
    end
  end
  self:UpdateRedTips(info.act_id)
end

function ActivityTieredBundleProxy:MarkDayRewarded(act_id)
  local data = self:GetOrCreateData(act_id)
  if data then
    data.day_reward_time = ServerTime.CurServerTime() / 1000
    self:UpdateRedTips(act_id)
  end
end

function ActivityTieredBundleProxy:MarkRewarded(act_id, id)
  local data = self:GetOrCreateData(act_id)
  if data and id then
    data.rewardedMap[id] = true
    self:UpdateRedTips(act_id)
  end
end

function ActivityTieredBundleProxy:GetInfo(act_id)
  return self.bundleDatas[act_id]
end

function ActivityTieredBundleProxy:GetBatchID(act_id)
  local data = self.bundleDatas[act_id]
  return data and data.batch_id or 0
end

function ActivityTieredBundleProxy:GetBundleConfig(id)
  return Table_TieredBundle and Table_TieredBundle[id]
end

function ActivityTieredBundleProxy:GetBundleList(act_id)
  if not Table_TieredBundle then
    return _EmptyTable
  end
  local result = {}
  local info = self:GetInfo(act_id)
  local batchID = info and info.batch_id
  for _, cfg in pairs(Table_TieredBundle) do
    if cfg.ActID == act_id and (not (cfg.BatchID and batchID) or cfg.BatchID == batchID) then
      result[#result + 1] = cfg
    end
  end
  table.sort(result, function(l, r)
    return (l.id or 0) < (r.id or 0)
  end)
  return result
end

function ActivityTieredBundleProxy:GetCurrencyType(act_id)
  local list = self:GetBundleList(act_id)
  for i = 1, #list do
    local depositID = self:GetDepositID(list[i])
    local deposit = Table_Deposit and depositID and Table_Deposit[depositID]
    local currencyType = deposit and deposit.CurrencyType
    if currencyType and currencyType ~= "" then
      return currencyType
    end
  end
end

function ActivityTieredBundleProxy:IsRewarded(act_id, id)
  local data = self.bundleDatas[act_id]
  return data and data.rewardedMap and data.rewardedMap[id] == true or false
end

function ActivityTieredBundleProxy:IsStageFinished(act_id, cfg)
  if not cfg then
    return false
  end
  if self:IsRewarded(act_id, cfg.id) then
    return true
  end
  return false
end

function ActivityTieredBundleProxy:GetDepositID(cfg)
  local depositID = cfg and cfg.Deposit
  if type(depositID) == "table" then
    depositID = depositID[1]
  end
  if depositID and depositID ~= 0 then
    return depositID
  end
end

function ActivityTieredBundleProxy:IsDepositStage(cfg)
  return self:GetDepositID(cfg) ~= nil
end

function ActivityTieredBundleProxy:IsFreeStage(cfg)
  return cfg and cfg.Free == 1 and not self:IsDepositStage(cfg)
end

function ActivityTieredBundleProxy:IsUnlocked(act_id, cfg)
  if not cfg then
    return false
  end
  if not cfg.PreID or cfg.PreID == 0 then
    return true
  end
  local preCfg = self:GetBundleConfig(cfg.PreID)
  return self:IsStageFinished(act_id, preCfg)
end

function ActivityTieredBundleProxy:GetCostItem(cfg)
  local costItems = cfg and cfg.CostItems
  if costItems and costItems ~= _EmptyTable then
    return costItems[1], costItems[2]
  end
end

function ActivityTieredBundleProxy:HasCostItem(cfg)
  local itemId, itemNum = self:GetCostItem(cfg)
  return itemId ~= nil and itemNum ~= nil and 0 < itemNum
end

function ActivityTieredBundleProxy:IsCostStage(cfg)
  return cfg and not self:IsDepositStage(cfg) and not self:IsFreeStage(cfg) and self:HasCostItem(cfg)
end

function ActivityTieredBundleProxy:GetCostItemCount(itemId)
  if not itemId then
    return 0
  end
  local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.tiered_bundle
  return BagProxy.Instance:GetItemNumByStaticID(itemId, packageCheck) or 0
end

function ActivityTieredBundleProxy:HasCostEnough(cfg)
  local itemId, itemNum = self:GetCostItem(cfg)
  if not itemId or not itemNum then
    return true
  end
  return itemNum <= self:GetCostItemCount(itemId)
end

function ActivityTieredBundleProxy:CanBuy(act_id, cfg)
  if not cfg or not self:IsDepositStage(cfg) and not self:IsCostStage(cfg) then
    return false
  end
  if not self:IsActivityAvailable(act_id) then
    return false
  end
  if not self:IsUnlocked(act_id, cfg) then
    return false
  end
  if self:IsRewarded(act_id, cfg.id) then
    return false
  end
  if self:IsDepositStage(cfg) then
    return true
  end
  return self:IsCostStage(cfg)
end

function ActivityTieredBundleProxy:CanReceive(act_id, cfg)
  if not cfg or not self:IsActivityAvailable(act_id) then
    return false
  end
  if not self:IsUnlocked(act_id, cfg) or self:IsRewarded(act_id, cfg.id) then
    return false
  end
  return self:IsFreeStage(cfg)
end

function ActivityTieredBundleProxy:CanReceiveDayReward(act_id)
  if not self:IsActivityAvailable(act_id) then
    return false
  end
  local staticData = Table_ActivityNew and Table_ActivityNew[act_id]
  local misc = staticData and staticData.Misc
  local rewardItems = misc and misc.DayRewardItems
  if not rewardItems or not rewardItems[1] then
    return false
  end
  local data = self.bundleDatas[act_id]
  local lastTime = data and data.day_reward_time or 0
  if not lastTime or lastTime <= 0 then
    return true
  end
  local curTime = ServerTime.CurServerTime() / 1000
  local lastDailyRefresh = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(lastTime)
  local curDailyRefresh = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(curTime)
  return lastDailyRefresh < curDailyRefresh
end

function ActivityTieredBundleProxy:HasStageReward(act_id)
  local list = self:GetBundleList(act_id)
  for i = 1, #list do
    if self:CanReceive(act_id, list[i]) then
      return true
    end
  end
  return false
end

function ActivityTieredBundleProxy:UpdateRedTips(act_id)
  if not (RedTipProxy and RedTipProxy.Instance) or not SceneTip_pb then
    return
  end
  local redtip = RedTipProxy.Instance
  if self:HasStageReward(act_id) then
    redtip:AddRedTipParam(SceneTip_pb.EREDSYS_TIERED_BUNDLE, act_id)
  else
    redtip:RemoveRedTipParam(SceneTip_pb.EREDSYS_TIERED_BUNDLE, act_id)
  end
  if self:CanReceiveDayReward(act_id) then
    redtip:AddRedTipParam(SceneTip_pb.EREDSYS_TIERED_BUNDLE_DAY_REWARD, act_id)
  else
    redtip:RemoveRedTipParam(SceneTip_pb.EREDSYS_TIERED_BUNDLE_DAY_REWARD, act_id)
  end
end

function ActivityTieredBundleProxy:RemoveRedTips(act_id)
  if RedTipProxy and RedTipProxy.Instance and SceneTip_pb then
    RedTipProxy.Instance:RemoveRedTipParam(SceneTip_pb.EREDSYS_TIERED_BUNDLE, act_id)
    RedTipProxy.Instance:RemoveRedTipParam(SceneTip_pb.EREDSYS_TIERED_BUNDLE_DAY_REWARD, act_id)
  end
end
