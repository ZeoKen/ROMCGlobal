ActivityExchangeProxy = class("ActivityExchangeProxy", pm.Proxy)
ActivityExchangeProxy.Instance = nil
ActivityExchangeProxy.NAME = "ActivityExchangeProxy"
ActivityExchangeProxy.RedTipId = 10765

function ActivityExchangeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityExchangeProxy.NAME
  if ActivityExchangeProxy.Instance == nil then
    ActivityExchangeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityExchangeProxy:Init()
  self.exchangeItems = {}
  EventManager.Me():AddEventListener(ItemEvent.ItemChange, self.HandleItemUpdate, self)
end

function ActivityExchangeProxy:UpdateExchangeInfo(data)
  local items = self.exchangeItems[data.act_id]
  if not items then
    items = {}
    self.exchangeItems[data.act_id] = items
  end
  for i = 1, #data.datas do
    local serverdata = data.datas[i]
    items[serverdata.index] = serverdata.exchanged_count
  end
end

function ActivityExchangeProxy:GetExchangedCount(act_id, index)
  if self.exchangeItems[act_id] then
    return self.exchangeItems[act_id][index] or 0
  end
  return 0
end

function ActivityExchangeProxy:UpdateExchangedCount(act_id, index)
  if self.exchangeItems[act_id] then
    local count = self.exchangeItems[act_id][index] or 0
    count = count + 1
    self.exchangeItems[act_id][index] = count
  end
end

function ActivityExchangeProxy:IsRed(act_id)
  local config = Table_ActPersonalTimer[act_id]
  if config then
    local items = config.Misc and config.Misc.exchange_item
    if items then
      for i = 1, #items do
        local data = items[i]
        if data.red_tip == 1 and self:CheckItemCanExchange(act_id, i) then
          return true
        end
      end
    end
  end
  return false
end

function ActivityExchangeProxy:CheckItemCanExchange(act_id, index)
  local config = Table_ActPersonalTimer[act_id]
  if config then
    local items = config.Misc and config.Misc.exchange_item
    local data = items and items[index]
    if data then
      local hasExchangeCount = true
      if data.exchange_count and data.exchange_count > 0 then
        local exchangedCount = self:GetExchangedCount(act_id, index)
        hasExchangeCount = exchangedCount < data.exchange_count
      end
      if hasExchangeCount then
        local cost = data.cost
        local isCostEnough = true
        local checkPackage = GameConfig.PackageMaterialCheck.exchange_shop
        for j = 1, #cost do
          local id = cost[j][1]
          local num = cost[j][2]
          local bagNum = BagProxy.Instance:GetItemNumByStaticID(id, checkPackage)
          if num > bagNum then
            isCostEnough = false
            break
          end
        end
        if isCostEnough then
          return true
        end
      end
    end
  end
  return false
end

function ActivityExchangeProxy:HandleItemUpdate(packageType)
  if not next(self.exchangeItems) then
    return
  end
  local checkPackage = GameConfig.PackageMaterialCheck.exchange_shop
  if TableUtility.ArrayFindIndex(checkPackage, packageType) == 0 then
    return
  end
  local redActId
  for act_id, items in pairs(self.exchangeItems) do
    if self:IsRed(act_id) then
      redActId = act_id
      break
    end
  end
  if redActId then
    RedTipProxy.Instance:UpdateRedTip(ActivityExchangeProxy.RedTipId, {redActId})
  else
    RedTipProxy.Instance:RemoveWholeTip(ActivityExchangeProxy.RedTipId)
  end
end
