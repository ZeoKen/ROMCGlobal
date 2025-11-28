autoImport("QuickBuyItemData")
QuickBuyProxy = class("QuickBuyProxy", pm.Proxy)
QuickBuyProxy.Instance = nil
QuickBuyProxy.NAME = "QuickBuyProxy"
QuickBuyReason = {
  NotExist = 1,
  Publicity = 2,
  NotEnough = 3,
  PriceHigher = 4,
  PriceLower = 5,
  OverHoldLimit = 6
}
QuickBuyOrigin = {
  Exchange = 1,
  Shop = 2,
  BlackMarket = 3
}
QuickBuyMoney = {
  Zeny = 100,
  Happy = 110,
  Lottery = 151
}
QuickBuyProxy.QueryType = {
  All = RecordTrade_pb.ETRADEITEM_All,
  NoDamage = RecordTrade_pb.ETRADEITEM_NON_DAMAGE
}
local CreateArray = ReusableTable.CreateArray
local CreateTable = ReusableTable.CreateTable
local DestroyAndClearArray = ReusableTable.DestroyAndClearArray
local DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local itemInfo = {}
local costlist = {}
local RealNameCentify = function(self)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.QuickBuyView
  })
end

function QuickBuyProxy:ctor(proxyName, data)
  self.proxyName = proxyName or QuickBuyProxy.NAME
  if QuickBuyProxy.Instance == nil then
    QuickBuyProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function QuickBuyProxy:Init()
  self.itemList = {}
  self.compareEquipList = {}
  self.buyItemList = {}
  self.holdedTradeItem = {}
  self.sellTradeItem = {}
end

function QuickBuyProxy:TryOpenView(list, queryType, filterRefinelv)
  self.filterRefinelv = filterRefinelv
  self:SetItemList(list, queryType)
  if #self.itemList > 0 then
    FunctionSecurity.Me():TryDoRealNameCentify(RealNameCentify, self)
    return true
  end
  return false
end

function QuickBuyProxy:SetItemList(list, queryType)
  TableUtility.ArrayClear(self.itemList)
  for i = 1, #list do
    local data = list[i]
    if ItemData.CheckIsEquip(data.id) then
      for j = 1, data.count do
        local buyItemData = QuickBuyItemData.new(data)
        buyItemData:SetNeedCount(1)
        TableUtility.ArrayPushBack(self.itemList, buyItemData)
      end
    else
      local buyItemData = QuickBuyItemData.new(data)
      TableUtility.ArrayPushBack(self.itemList, buyItemData)
    end
  end
  self.queryType = queryType or self.QueryType.All
end

function QuickBuyProxy:CallItemInfo()
  local _CheckItemCanTrade = ItemData.CheckItemCanTrade
  local list = CreateArray()
  for i = 1, #self.itemList do
    local item = self.itemList[i]
    if _CheckItemCanTrade(item.id) then
      local itemCount = self:TryGetItemCount(list, item.id)
      if itemCount == nil then
        local data = NetConfig.PBC and {} or RecordTrade_pb.ItemCount()
        data.itemid = item.id
        data.count = item.needCount
        TableUtility.ArrayPushBack(list, data)
      else
        itemCount.count = itemCount.count + item.needCount
      end
    end
  end
  ServiceRecordTradeProxy.Instance:CallQueryItemCountTradeCmd(Game.Myself.data.id, list, nil, self.queryType)
  DestroyAndClearArray(list)
end

function QuickBuyProxy:CallHoldedItemCountTrade(itemid)
  local _CheckItemCanTrade = ItemData.CheckItemCanTrade
  local list = CreateArray()
  if itemid then
    TableUtility.ArrayClear(self.itemList)
    if TableUtility.ArrayFindIndex(list, itemid) == 0 and _CheckItemCanTrade(itemid) then
      TableUtility.ArrayPushBack(list, itemid)
      xdlog("单独请求金车数据", itemid)
    end
  else
    for i = 1, #self.itemList do
      local item = self.itemList[i]
      if TableUtility.ArrayFindIndex(list, item.id) == 0 and _CheckItemCanTrade(item.id) then
        TableUtility.ArrayPushBack(list, item.id)
        xdlog("请求快速购买中商品的金车数据", item.id)
      end
    end
  end
  if list and 0 < #list then
    local result = {}
    for i = 1, #list do
      local data = {}
      data.itemid = list[i]
      TableUtility.ArrayPushBack(result, data)
    end
    ServiceRecordTradeProxy.Instance:CallQueryHoldedItemCountTradeCmd(result)
  elseif self.itemList and #self.itemList > 0 then
    self:CallItemInfo()
  end
  DestroyAndClearArray(list)
end

function QuickBuyProxy:CallShopInfo()
  local list = CreateArray()
  for i = 1, #self.itemList do
    local data = self.itemList[i]
    if TableUtility.ArrayFindIndex(list, data.id) == 0 then
      TableUtility.ArrayPushBack(list, data.id)
    end
  end
  if 0 < #list then
    ServiceSessionShopProxy.Instance:CallQueryQuickBuyConfigCmd(list)
  else
    self:TryCompareEquipPrice()
  end
  DestroyAndClearArray(list)
end

function QuickBuyProxy:TryCompareEquipPrice()
  TableUtility.ArrayClear(self.compareEquipList)
  for i = 1, #self.itemList do
    local data = self.itemList[i]
    local equip = data:GetCompareEquipPrice()
    if equip ~= nil and not self:CheckExist(self.compareEquipList, data.id) then
      TableUtility.ArrayPushBack(self.compareEquipList, equip)
    end
  end
  self.callCompareEquipPriceIndex = 1
  self:CallCompareEquipPrice()
end

function QuickBuyProxy:CallCompareEquipPrice()
  if self.callCompareEquipPriceIndex ~= nil then
    if #self.compareEquipList >= self.callCompareEquipPriceIndex then
      FunctionItemTrade.Me():GetTradePrice(self.compareEquipList[self.callCompareEquipPriceIndex], true)
    else
      self.callCompareEquipPriceIndex = nil
      self:sendNotification(QuickBuyEvent.Refresh)
    end
  end
end

function QuickBuyProxy:CallBuyItem()
  if self.callBuyItemIndex ~= nil then
    if #self.buyItemList >= self.callBuyItemIndex then
      local data = self.buyItemList[self.callBuyItemIndex]
      if data.origin == QuickBuyOrigin.Exchange then
        TableUtility.TableClear(itemInfo)
        itemInfo.itemid = data.id
        itemInfo.price = data.price
        itemInfo.count = data.needCount < data.totalCount and data.needCount or data.totalCount
        itemInfo.publicity_id = data.publicityId
        itemInfo.order_id = data.orderId
        ShopMallProxy.Instance:CallBuyItemRecordTradeCmd(itemInfo)
      elseif data.origin == QuickBuyOrigin.Shop or data.origin == QuickBuyOrigin.BlackMarket then
        HappyShopProxy.Instance:BuyItemByShopItemData(data.shopItemData, data:GetShopBuyCount())
      end
    else
      self.callBuyItemIndex = nil
      for i = 1, 3 do
        costlist[i] = 0
      end
      local failCount = 0
      for i = 1, #self.buyItemList do
        local data = self.buyItemList[i]
        if data:IsBuySuccess() then
          if data.moneyType == QuickBuyMoney.Zeny then
            costlist[1] = costlist[1] + data:GetTotalCost()
          elseif data.moneyType == QuickBuyMoney.Happy then
            costlist[2] = costlist[2] + data:GetTotalCost()
          elseif data.moneyType == QuickBuyMoney.Lottery then
            costlist[3] = costlist[3] + data:GetTotalCost()
          end
        else
          failCount = failCount + 1
        end
      end
      MsgManager.ShowMsgByIDTable(2967, costlist)
      if 0 < failCount then
        MsgManager.ShowMsgByID(2968, failCount)
      end
      for i = #self.buyItemList, 1, -1 do
        if self.buyItemList[i].origin == QuickBuyOrigin.Shop then
          table.remove(self.buyItemList, i)
        end
      end
      if #self.buyItemList > 0 then
        self.callRecordIndex = 0
        self:CallRecord()
      else
        self:EndRecord()
      end
    end
  end
end

function QuickBuyProxy:CallRecord()
  if self.callRecordIndex ~= nil then
    ServiceRecordTradeProxy.Instance:CallMyTradeLogRecordTradeCmd(Game.Myself.data.id, self.callRecordIndex)
  end
end

function QuickBuyProxy:RecvQueryItemCountTradeCmd(serviceData)
  if #serviceData.res_items > 0 then
    local map = CreateTable()
    for i = 1, #self.itemList do
      local data = self.itemList[i]
      if map[data.id] == nil then
        map[data.id] = CreateArray()
      end
      TableUtility.ArrayPushBack(map[data.id], data)
    end
    for i = 1, #serviceData.res_items do
      local data = serviceData.res_items[i]
      if map[data.itemid] ~= nil then
        local length = #map[data.itemid]
        if length > data.count then
          length = data.count
        end
        for j = length, 1, -1 do
          local item = map[data.itemid][j]
          if item ~= nil then
            item:SetExchangeInfo(data)
            if self.filterRefinelv and ItemData.CheckIsEquip(data.itemid) and not item:CheckMaterialLevel() then
              item:ClearInfo()
              item:SetReason()
            end
            local holdLimit = ItemData.GetHoldedCountLimit(data.itemid)
            if holdLimit then
              local holdedCount = self.holdedTradeItem[data.itemid] or {}
              xdlog("持有数量上限", data.itemid, holdLimit, holdedCount)
              if holdLimit <= (holdedCount[1] or 0) + (holdedCount[2] or 0) then
                item.overHoldLimit = true
              end
            end
            item:SetReason()
            table.remove(map[data.itemid], j)
          end
        end
      end
    end
    for k, v in pairs(map) do
      DestroyAndClearArray(v)
    end
    DestroyAndClearTable(map)
  end
  if self.itemList and 0 < #self.itemList then
    for i = 1, #self.itemList do
      local single = self.itemList[i]
      local needSetReason = single.origin == nil
      if needSetReason then
        single:SetReason()
      end
    end
  end
  self:CallShopInfo()
  self:TryCompareEquipPrice()
end

function QuickBuyProxy:RecvQueryHoldedItemCountTradeCmd(data)
  local items = data and data.items
  if items and 0 < #items then
    for i = 1, #items do
      local item = items[i]
      self.holdedTradeItem[item.itemid] = {
        item.owncount,
        item.tradecount
      }
      xdlog("清单数量", item.itemid, item.owncount, item.tradecount)
    end
  end
  if self.itemList and 0 < #self.itemList then
    self:CallItemInfo()
  end
end

function QuickBuyProxy:RecvQueryQuickBuyConfigCmd(serviceData)
  local goodsMap = CreateTable()
  for i = 1, #serviceData.goods do
    local goods = serviceData.goods[i]
    goodsMap[goods.itemid] = goods
  end
  local count = #self.itemList
  if 0 < count then
    for i = 1, count do
      local data = self.itemList[i]
      local needSetReason = data.origin == nil
      local goods = goodsMap[data.id]
      local newData
      if goods then
        if not needSetReason and data.reason ~= QuickBuyReason.Publicity then
          if data.totalCount < data.needCount then
            newData = QuickBuyItemData.new({
              id = data.id
            })
            if data.price and data.price < goods.moneycount then
              newData.needCount = data.needCount - data.totalCount
            else
              data.isChoose = false
              newData.needCount = data.needCount
            end
            newData:SetShopInfo(goods, goods.shoptype ~= 410)
            newData:SetReason()
            newData.isChoose = true
            table.insert(self.itemList, newData)
          else
            newData = QuickBuyItemData.new({
              id = data.id
            })
            newData.needCount = data.needCount
            newData:SetShopInfo(goods, goods.shoptype ~= 410)
            newData:SetReason()
            newData.isChoose = false
            table.insert(self.itemList, newData)
          end
        elseif goods.moneyid2 == 0 and not data:CheckExchangeAvailable() then
          newData = QuickBuyItemData.new({
            id = data.id,
            count = data.needCount
          })
          newData:SetShopInfo(goods, goods.shoptype ~= 410)
          newData:SetReason()
          table.insert(self.itemList, newData)
        end
      end
      if needSetReason then
        data:SetReason()
      end
    end
  end
  DestroyAndClearTable(goodsMap)
  self:TryCompareEquipPrice()
end

function QuickBuyProxy:RecvCompareEquipPrice(serviceData)
  if self.callCompareEquipPriceIndex ~= nil and #self.compareEquipList >= self.callCompareEquipPriceIndex then
    local id = self.compareEquipList[self.callCompareEquipPriceIndex].staticData.id
    if serviceData.itemData.base.id == id then
      for i = 1, #self.itemList do
        local data = self.itemList[i]
        if data.id == id then
          data:SetCompareEquipPrice(serviceData.price)
        end
      end
    end
    self.callCompareEquipPriceIndex = self.callCompareEquipPriceIndex + 1
    self:CallCompareEquipPrice()
  end
end

function QuickBuyProxy:RecvBuyItem(serviceData)
  if self.callBuyItemIndex ~= nil and #self.buyItemList >= self.callBuyItemIndex then
    local buyItemData = self.buyItemList[self.callBuyItemIndex]
    if serviceData.item_info.itemid == buyItemData.id then
      buyItemData:SetBuyResult(serviceData.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS)
      buyItemData:SetRecordId(serviceData.item_info.order_id)
    end
    self.callBuyItemIndex = self.callBuyItemIndex + 1
    self:CallBuyItem()
  end
end

function QuickBuyProxy:RecvBuyShopItem(serviceData)
  if self.callBuyItemIndex ~= nil and #self.buyItemList >= self.callBuyItemIndex then
    local buyItemData = self.buyItemList[self.callBuyItemIndex]
    if buyItemData.shopItemData ~= nil and serviceData.id == buyItemData.shopItemData.id then
      buyItemData:SetShopBuyCount(serviceData.count)
      local leftCount = buyItemData:GetShopBuyCount()
      if leftCount == 0 then
        buyItemData:SetBuyResult(serviceData.success)
        self.callBuyItemIndex = self.callBuyItemIndex + 1
      end
    end
    self:CallBuyItem()
  end
end

function QuickBuyProxy:RecvRecord(serviceData)
  if self.callRecordIndex ~= nil then
    if #self.buyItemList == 0 then
      return
    end
    local array = ReusableTable.CreateArray()
    local recordId
    for i = 1, #self.buyItemList do
      recordId = self.buyItemList[i].recordId
      if recordId ~= nil then
        array[#array + 1] = recordId
      end
    end
    ServiceRecordTradeProxy.Instance:CallQucikTakeLogTradeCmd(BoothProxy.TradeType.Exchange, array)
    ReusableTable.DestroyAndClearArray(array)
    self:EndRecord()
  end
end

function QuickBuyProxy:StartBuyItem(includeShop)
  TableUtility.ArrayClear(self.buyItemList)
  for i = 1, #self.itemList do
    local data = self.itemList[i]
    if data.isChoose and (includeShop or data.origin ~= QuickBuyOrigin.BlackMarket) then
      TableUtility.ArrayPushBack(self.buyItemList, data)
    end
  end
  self.callBuyItemIndex = 1
  self:CallBuyItem()
end

function QuickBuyProxy:EndRecord()
  self.callRecordIndex = nil
  self:sendNotification(QuickBuyEvent.Close)
  helplog("------------ QuickBuyProxy:EndRecord()  sendNotification QuickBuyProxy.Close")
end

function QuickBuyProxy:Clear()
  self.callItemInfoIndex = nil
  self.callBuyItemIndex = nil
  self.callRecordIndex = nil
  self.safeRefineLimitVal = nil
end

function QuickBuyProxy:TryGetItemCount(list, itemid)
  for i = 1, #list do
    if list[i].itemid == itemid then
      return list[i]
    end
  end
end

function QuickBuyProxy:CheckExist(list, itemid)
  for i = 1, #list do
    if list[i].staticData.id == itemid then
      return true
    end
  end
  return false
end

function QuickBuyProxy:GetSafeRefineLimitVal()
  return self.safeRefineLimitVal
end

function QuickBuyProxy:SetSafeRefineLimitVal(val)
  self.safeRefineLimitVal = val
end

local BuyItemValid = function(pram, item)
  if item and item.id == "QuickBuy" then
    return false
  end
  return true
end

function QuickBuyProxy:GetItemList(includeShop)
  if self.safeRefineLimitVal then
    local tempDatas = {}
    for i = 1, #self.itemList do
      local itemData = self.itemList[i]:GetItemData()
      itemData.index = i
      table.insert(tempDatas, itemData)
    end
    local newItemList = {}
    local fillDatas = BlackSmithProxy.Instance:DoFitEquipRefineVal(tempDatas, self.safeRefineLimitVal, BuyItemValid)
    if fillDatas then
      local index, num
      for i = 1, #fillDatas do
        index, num = fillDatas[i].index, fillDatas[i].num
        local buyItemData = self.itemList[index]
        buyItemData:SetNeedCount(num)
        table.insert(newItemList, buyItemData)
      end
    end
    if 0 < #newItemList then
      self.itemList = newItemList
    end
  end
  return self.itemList
end

function QuickBuyProxy:GetTotalCost(includeShop)
  local zenyCost = 0
  local happyCost = 0
  local lotteryCost = 0
  for i = 1, #self.itemList do
    local data = self.itemList[i]
    if data.isChoose and (includeShop or data.origin ~= QuickBuyOrigin.BlackMarket) then
      if data.moneyType == QuickBuyMoney.Zeny then
        zenyCost = zenyCost + data:GetTotalCost()
      elseif data.moneyType == QuickBuyMoney.Happy then
        happyCost = happyCost + data:GetTotalCost()
      elseif data.moneyType == QuickBuyMoney.Lottery then
        lotteryCost = lotteryCost + data:GetTotalCost()
      end
    end
  end
  return zenyCost, happyCost, lotteryCost
end

function QuickBuyProxy:SetEquipUpgradeExLevel(level)
  self.equipUpgradeExLevel = level
end

function QuickBuyProxy:SetPreviewInfo(itemid, count)
  self.previewItemID = itemid
  self.previewCount = count
end

function QuickBuyProxy:GetTradeCount(itemID)
  if not self.holdedTradeItem then
    return
  end
  local counts = self.holdedTradeItem[itemID] or {}
  return counts[1] or 0, counts[2] or 0, ItemData.GetHoldedCountLimit(itemID)
end

function QuickBuyProxy:RecvQuerySellItemCountTradeCmd(data)
  local records = data and data.records
  local itemID, count = 0, 0
  if records and 0 < #records then
    for i = 1, #records do
      itemID = records[i].itemid
      count = records[i].count
      self.sellTradeItem[itemID] = count
    end
  end
end

function QuickBuyProxy:GetSellTradeCount(itemID)
  if not self.sellTradeItem then
    return
  end
  return self.sellTradeItem[itemID] or 0, ItemData.GetSellCountLimit(itemID)
end

function QuickBuyProxy:CallQuerySelledItemCountTradeCmd(itemid)
  local _CheckItemCanTrade = ItemData.CheckItemCanTrade
  local list = CreateArray()
  if itemid and _CheckItemCanTrade(itemid) then
    local data = {}
    data.itemid = itemid
    TableUtility.ArrayPushBack(list, data)
  end
  ServiceRecordTradeProxy.Instance:CallQuerySelledItemCountTradeCmd(list)
end
