FunctionItemTrade = class("FunctionItemTrade")
FunctionItemTrade.IntervalTime = 60000
autoImport("ItemData")

function FunctionItemTrade.Me()
  if nil == FunctionItemTrade.me then
    FunctionItemTrade.me = FunctionItemTrade.new()
  end
  return FunctionItemTrade.me
end

function FunctionItemTrade:ctor()
  self.tradePriceMap = {}
end

function FunctionItemTrade:CombineItemKey(itemData)
  local itemid = itemData.staticData.id
  local refinelv = 0
  local damage = 0
  local equiplv = 0
  if itemData.equipInfo then
    refinelv = itemData.equipInfo.refinelv
    damage = itemData.equipInfo.damage and 1 or 0
    equiplv = itemData.equipInfo.equiplv or 0
  end
  local enchant = "0"
  if itemData.enchantInfo then
    local attris = itemData.enchantInfo:GetEnchantAttrs()
    if 0 < #attris then
      enchant = itemData.enchantInfo.enchantType .. "-"
      for i = 1, #attris do
        local attriStr = string.format("%s-%s", attris[i].type, attris[i].serverValue)
        if i < #attris then
          attriStr = attriStr .. "-"
        end
        enchant = enchant .. attriStr
      end
      local combineEffect = itemData.enchantInfo:GetCombineEffects()
      if 0 < #combineEffect then
        enchant = enchant .. "-"
        for i = 1, #combineEffect do
          local effectStr = string.format("%s-%s", combineEffect[i].configid, combineEffect[i].buffid)
          if i < #combineEffect then
            enchant = enchant .. "-"
          end
          enchant = enchant .. effectStr
        end
      end
    end
  end
  local cardLv = 0
  if itemData:IsCard() then
    cardLv = itemData.cardLv or 0
  end
  return itemid .. "_" .. refinelv .. "_" .. damage .. "_" .. enchant .. "_" .. equiplv .. "_" .. cardLv
end

function FunctionItemTrade:SetTradePrice(serverItem, price)
  local tempItem = ItemData.new()
  tempItem:ParseFromServerData(serverItem)
  local combineKey = self:CombineItemKey(tempItem)
  local cacheData = self.tradePriceMap[combineKey]
  if not cacheData then
    cacheData = {}
    self.tradePriceMap[combineKey] = cacheData
  end
  cacheData.id = combineKey
  cacheData.itemid = tempItem.staticData.id
  cacheData.price = price
  EventManager.Me():DispatchEvent(ItemTradeEvent.TradePriceChange, cacheData)
end

function FunctionItemTrade:GetTradePrice(itemData, forceRequire, issell, tradeType)
  local result = 0
  if not itemData then
    return result
  end
  local combineKey = self:CombineItemKey(itemData)
  local nowServerTime, deltatime = ServerTime.CurServerTime(), 0
  local cacheData = self.tradePriceMap[combineKey]
  if cacheData then
    deltatime = nowServerTime - cacheData.lastUpdateTime
    result = cacheData.price or 0
  else
    cacheData = {}
    self.tradePriceMap[combineKey] = cacheData
    cacheData.lastUpdateTime = nowServerTime
    self:CallServerTradePrice(itemData, issell, tradeType)
    return result
  end
  cacheData.lastRequireTime = nowServerTime
  if deltatime > FunctionItemTrade.IntervalTime or forceRequire then
    cacheData.lastUpdateTime = nowServerTime
    self:CallServerTradePrice(itemData, issell, tradeType)
  end
  return result
end

function FunctionItemTrade:CallServerTradePrice(itemData, issell, tradeType)
  if not ItemData.CheckItemCanTrade(itemData.staticData.id) then
    return
  end
  if itemData.petEggInfo and not itemData.petEggInfo:CanExchange() then
    return
  end
  ServiceRecordTradeProxy.Instance:CallReqServerPriceRecordTradeCmd(Game.Myself.data.id, itemData, nil, issell, nil, nil, nil, nil, tradeType)
end

function FunctionItemTrade:IsRequireOverTime(itemData)
  local combineKey = self:CombineItemKey(itemData)
  local nowServerTime, deltatime = ServerTime.CurServerTime(), 0
  local cacheData = self.tradePriceMap[combineKey]
  if cacheData then
    local lastUpdateTime = cacheData.lastUpdateTime or 0
    deltatime = nowServerTime - lastUpdateTime
  else
    return true
  end
  return deltatime > FunctionItemTrade.IntervalTime
end

function FunctionItemTrade:GetTradePriceCache(itemData)
  local success = not self:IsRequireOverTime(itemData)
  local combineKey = self:CombineItemKey(itemData)
  local cache = self.tradePriceMap[combineKey]
  local price = cache and cache.price or 0
  return success, price
end

function FunctionItemTrade:SetTradePriceCache(serverItem, price)
  local tempItem = ItemData.new()
  tempItem:ParseFromServerData(serverItem)
  local combineKey = self:CombineItemKey(tempItem)
  local cache = self.tradePriceMap[combineKey]
  if not cache then
    cache = {}
    cache.id = combineKey
    cache.itemid = tempItem.staticData.id
    self.tradePriceMap[combineKey] = cache
  end
  cache.price = price
  local nowServerTime = ServerTime.CurServerTime()
  cache.lastUpdateTime = nowServerTime
end

function FunctionItemTrade:QueryCardListPrice(list)
  ServiceRecordTradeProxy.Instance:CallQueryItemPriceRecordTradeCmd(list)
end
