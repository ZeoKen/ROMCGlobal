autoImport("SupplyDepotData")
SupplyDepotProxy = class("SupplyDepotProxy", pm.Proxy)
SupplyDepotProxy.Instance = nil
SupplyDepotProxy.NAME = "SupplyDepotProxy"
SupplyDepotProxy.RedTipID = 10200

function SupplyDepotProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SupplyDepotProxy.NAME
  if SupplyDepotProxy.Instance == nil then
    SupplyDepotProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end

function SupplyDepotProxy:GetConfig()
  if GameConfig.TimeLimitShop and self.hasData then
    local actId = self:GetActId()
    return GameConfig.TimeLimitShop[actId]
  end
  return nil
end

function SupplyDepotProxy:UpdateActData(serverData)
  if not serverData then
    redlog("activity data cannot be nil")
    return
  end
  local actId = serverData.id
  if not actId then
    redlog("activity id cannot be nil")
    return
  end
  if self.actData then
    self.actData:SetData(serverData)
  else
    self.actData = SupplyDepotData.new(serverData)
  end
end

function SupplyDepotProxy:UpdateDepotData(serverData)
  if not serverData then
    redlog("supply depot data cannot be nil")
    return
  end
  if self.actData then
    self.actData:SetData(serverData)
  else
    self.actData = SupplyDepotData.new(serverData)
  end
  self.hasData = true
  if not self.isManualRefresh and not serverData.reqrefresh then
    RedTipProxy.Instance:UpdateRedTip(SupplyDepotProxy.RedTipID)
  end
  self.isManualRefresh = nil
end

function SupplyDepotProxy:GetActItems()
  if self.actData then
    return self.actData.items
  end
  return nil
end

function SupplyDepotProxy:IsActive()
  return FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_TIMELIMIT_SHOP) and self.hasData and true or false
end

function SupplyDepotProxy:GetActId()
  if self.actData then
    return self.actData.actId
  end
  return nil
end

function SupplyDepotProxy:UpdateRedTip()
  RedTipProxy.Instance:UpdateRedTip(SupplyDepotProxy.RedTipID)
end

function SupplyDepotProxy:GetRefreshCost()
  if self.actData then
    return self.actData.refreshCost
  end
  return 0
end

function SupplyDepotProxy:GetRefreshTimes()
  if self.actData then
    return self.actData.refreshTimes
  end
  return 0
end

function SupplyDepotProxy:GetNextRefreshSeconds()
  if self.actData and self.actData.refreshAt then
    local seconds = self.actData.refreshAt - ServerTime.CurServerTime() / 1000
    return 0 <= seconds and seconds or 0
  end
  return 0
end

function SupplyDepotProxy:GetStartDate()
  if self.actData then
    return self.actData.startDate
  end
  return nil
end

function SupplyDepotProxy:GetEndDate()
  if self.actData then
    return self.actData.endDate
  end
  return nil
end

function SupplyDepotProxy:ManualRefresh()
  ServiceActivityCmdProxy.Instance:CallTimeLimitShopPageCmd()
  self.isManualRefresh = true
end

function SupplyDepotProxy:GetItemNumByStaticID(itemid)
  local proxy = BagProxy.Instance
  return proxy:GetItemNumByStaticID(itemid, GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.TimeLimitShop_pack)
end

function SupplyDepotProxy:RecvBuyShopItem(data)
  if not (data and self.actData) or not self.actData.items then
    return
  end
  local shopItem
  for _, v in ipairs(self.actData.items) do
    if v.id == data.id and v.idx == self.curBuyItemIndex then
      shopItem = v
      break
    end
  end
  if not shopItem then
    return
  end
  if not data.success then
    MsgManager.ShowMsgByID(41327)
    return
  end
  shopItem.bought = true
  self:sendNotification(SupplyDepotEvent.UpdateItem)
end

function SupplyDepotProxy:RecvBulkBuyShopItem(items, success)
  if not success then
    MsgManager.ShowMsgByID(41327)
    return
  end
  if not (items and self.actData) or not self.actData.items then
    return
  end
  local hasItem
  for _, v in ipairs(self.actData.items) do
    for _, item in pairs(items) do
      if v.id == item.id and v.idx == item.grid then
        v.bought = true
        hasItem = true
      end
    end
  end
  if not hasItem then
    return
  end
  self:sendNotification(SupplyDepotEvent.UpdateItem)
end

function SupplyDepotProxy:SortItems()
  if self.actData then
    self.actData:SortItems()
  end
end

function SupplyDepotProxy:SetCurBuyItemIndex(index)
  self.curBuyItemIndex = index
end

function SupplyDepotProxy.BulkBuy(cart)
  if type(cart) ~= "table" then
    return
  end
  local arr, buyItem = ReusableTable.CreateArray()
  for idx, data in pairs(cart) do
    buyItem = NetConfig.PBC and {} or SessionShop_pb.BuyItemInfo()
    buyItem.id = data.id
    buyItem.count = 1
    buyItem.price = data.ItemCount - (100 - data.Discount) / 100 * data.ItemCount
    buyItem.grid = idx
    TableUtility.ArrayPushBack(arr, buyItem)
  end
  ServiceSessionShopProxy.Instance:CallBulkBuyShopItem(arr)
  ReusableTable.DestroyAndClearArray(arr)
end
