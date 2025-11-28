RecallShopProxy = class("RecallShopProxy", pm.Proxy)
RecallShopProxy.Instance = nil
RecallShopProxy.NAME = "RecallShopProxy"

function RecallShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallShopProxy.NAME
  if RecallShopProxy.Instance == nil then
    RecallShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RecallShopProxy:Init()
  self.serverShopData = nil
end

function RecallShopProxy:UpdateShopData(serverData)
  if not serverData then
    redlog("RecallShopProxy:UpdateShopData 参数无效", serverData)
    return
  end
  local index = serverData.index
  if not index then
    redlog("RecallShopProxy:UpdateShopData index无效")
    return
  end
  local actualIndex
  if RecallInfoProxy.Instance then
    actualIndex = RecallInfoProxy.Instance:GetIndex(serverData.index + 1)
  end
  if not actualIndex then
    redlog("RecallShopProxy:UpdateShopData 无法获取实际配置索引", "serverIndex:", serverData.index)
    actualIndex = serverData.index
  end
  local endTime = serverData.end_time
  if serverData.start_time and RecallInfoProxy.Instance then
    local continueDay = RecallInfoProxy.Instance:GetContinueDay("Shop", actualIndex)
    if continueDay then
      endTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(serverData.start_time + continueDay * 86400)
    end
  end
  self.serverShopData = {
    index = serverData.index,
    start_time = serverData.start_time,
    end_time = endTime,
    goods = {}
  }
  if serverData.goods then
    for _, goodData in pairs(serverData.goods) do
      local costCopy = {}
      if goodData.cost then
        for i, costItem in ipairs(goodData.cost) do
          costCopy[i] = {
            id = costItem.id,
            count = costItem.count
          }
        end
      end
      local goodCopy
      if goodData.good then
        goodCopy = {
          id = goodData.good.id,
          count = goodData.good.count
        }
      end
      local shopGood = {
        id = goodData.id,
        bought_count = goodData.bought_count or 0,
        buy_limit = goodData.buy_limit or 0,
        good = goodCopy,
        cost = costCopy,
        off = goodData.off
      }
      self.serverShopData.goods[goodData.id] = shopGood
    end
  end
end

function RecallShopProxy:GetShopData()
  return self.serverShopData
end

function RecallShopProxy:GetServerShopGood(shopId)
  if self.serverShopData and self.serverShopData.goods and self.serverShopData.goods[shopId] then
    return self.serverShopData.goods[shopId]
  end
  return nil
end

function RecallShopProxy:GetItemBoughtCount(shopId)
  local serverGood = self:GetServerShopGood(shopId)
  return serverGood and serverGood.bought_count or 0
end

function RecallShopProxy:CanBuyItem(shopId)
  local serverGood = self:GetServerShopGood(shopId)
  if not serverGood then
    return false
  end
  local buyLimit = serverGood.buy_limit or 0
  if 0 < buyLimit then
    local boughtCount = serverGood.bought_count or 0
    if buyLimit <= boughtCount then
      return false
    end
  end
  if serverGood.cost then
    for _, costInfo in pairs(serverGood.cost) do
      local costItemId = costInfo.id
      local costAmount = costInfo.count
      local currentAmount = MyselfProxy.Instance:GetItemCount(costItemId)
      if costAmount > currentAmount then
        return false
      end
    end
  end
  local index = self:GetShopIndexByItemId(shopId)
  if not self:IsActivityValid(index) then
    return false
  end
  return true
end

function RecallShopProxy:IsActivityValid()
  local shopData = self:GetShopData()
  if not (shopData and shopData.start_time) or not shopData.end_time then
    return false
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  return currentTime >= shopData.start_time and currentTime <= shopData.end_time
end

function RecallShopProxy:GetActivityTime()
  local shopData = self:GetShopData()
  if shopData then
    return shopData.start_time, shopData.end_time
  end
  return nil, nil
end

function RecallShopProxy:HasServerData()
  return self.serverShopData ~= nil
end

function RecallShopProxy:HasAvailableShopItems()
  return self.serverShopData and self.serverShopData.goods and next(self.serverShopData.goods) ~= nil
end

function RecallShopProxy:GetShopDataFirst()
  return self.serverShopData
end

function RecallShopProxy:GetDisplayInfo()
  if self.serverShopData and self.serverShopData.start_time and self.serverShopData.end_time then
    return {
      startTime = self.serverShopData.start_time,
      endTime = self.serverShopData.end_time
    }
  end
  return {startTime = 0, endTime = 0}
end

function RecallShopProxy:GetAllShopItems()
  if not self.serverShopData or not self.serverShopData.goods then
    return {}
  end
  local shopItems = {}
  for shopId, serverGood in pairs(self.serverShopData.goods) do
    local itemData = {
      id = shopId,
      serverData = serverGood,
      actDiscount = 0,
      Discount = serverGood.off
    }
    table.insert(shopItems, itemData)
  end
  table.sort(shopItems, function(a, b)
    return a.id < b.id
  end)
  return shopItems
end

function RecallShopProxy:GetShopItemsByIndex(index)
  return self:GetAllShopItems()
end

function RecallShopProxy:HasItemCanBuy()
  local shopItems = self:GetAllShopItems()
  for _, item in pairs(shopItems) do
    if self:CanBuyItem(item.id) then
      return true
    end
  end
  return false
end

function RecallShopProxy:OnItemBought(shopId, newBoughtCount)
  if not self.serverShopData or not self.serverShopData.goods then
    return
  end
  if self.serverShopData.goods[shopId] then
    self.serverShopData.goods[shopId].bought_count = newBoughtCount
    xdlog("RecallShopProxy:OnItemBought", shopId, newBoughtCount)
  end
end

function RecallShopProxy:OnBuyShopGoodSuccess(data)
  if not data or not data.id then
    redlog("RecallShopProxy:OnBuyShopGoodSuccess 数据无效", data)
    return
  end
  local shopId = data.id
  local buyCount = data.count or 1
  if self.serverShopData and self.serverShopData.goods and self.serverShopData.goods[shopId] then
    local currentBoughtCount = self.serverShopData.goods[shopId].bought_count or 0
    local newBoughtCount = currentBoughtCount + buyCount
    self.serverShopData.goods[shopId].bought_count = newBoughtCount
    xdlog("RecallShopProxy:OnBuyShopGoodSuccess 库存已更新", "商品ID:", shopId, "原购买次数:", currentBoughtCount, "新购买次数:", newBoughtCount, "本次购买:", buyCount)
  else
    redlog("RecallShopProxy:OnBuyShopGoodSuccess 找不到商品数据", shopId)
  end
end

function RecallShopProxy:GetItemPriceInfo(shopId)
  local serverGood = self:GetServerShopGood(shopId)
  if not serverGood or not serverGood.cost then
    return nil
  end
  if #serverGood.cost > 0 then
    return {
      itemId = serverGood.cost[1].id,
      amount = serverGood.cost[1].count
    }
  end
  return nil
end

function RecallShopProxy:GetItemRewardInfo(shopId)
  local serverGood = self:GetServerShopGood(shopId)
  if not serverGood or not serverGood.good then
    return nil
  end
  return {
    itemId = serverGood.good.id,
    amount = serverGood.good.count
  }
end

function RecallShopProxy:GetItemBuyLimitInfo(shopId)
  local serverGood = self:GetServerShopGood(shopId)
  if not serverGood then
    return nil
  end
  local buyLimit = serverGood.buy_limit or 0
  local boughtCount = serverGood.bought_count or 0
  return {
    buyLimit = buyLimit,
    boughtCount = boughtCount,
    remainCount = 0 < buyLimit and buyLimit - boughtCount or -1
  }
end

function RecallShopProxy:RequestShopData(index)
  local queryData = {
    index = index or 1
  }
  ServiceRecallCCmdProxy.Instance:CallShopQueryInfoRecallCmd(queryData)
  xdlog("RecallShopProxy 请求商店数据", index)
end

function RecallShopProxy:RequestBuyItem(shopId, count)
  if not self:CanBuyItem(shopId) then
    redlog("RecallShopProxy:RequestBuyItem 商品不可购买", shopId)
    return
  end
  local buyCount = count or 1
  ServiceRecallCCmdProxy.Instance:CallBuyShopGoodRecallCmd(shopId, buyCount)
  xdlog("RecallShopProxy 请求购买商品", shopId, count)
end
