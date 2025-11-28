PeddlerShopProxy = class("PeddlerShopProxy", pm.Proxy)
PeddlerShopProxy.Instance = nil
PeddlerShopProxy.NAME = "PeddlerShopProxy"
local shopType, shopId = 20060, 1
local MysticalShopType, MysticalShopId = 20325, 1

function PeddlerShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PeddlerShopProxy.NAME
  if PeddlerShopProxy.Instance == nil then
    PeddlerShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end

function PeddlerShopProxy:QueryShopConfig()
  ShopProxy.Instance:CallQueryShopConfig(MysticalShopType, MysticalShopId)
  ShopProxy.Instance:CallQueryShopConfig(shopType, shopId)
end

function PeddlerShopProxy:UpdateShopConfig(data)
  if data.shopid ~= shopId or data.type ~= shopType then
    return
  end
  if self.allGoodsList then
    TableUtility.ArrayClear(self.allGoodsList)
  else
    self.allGoodsList = {}
  end
  if self.shopList then
    TableUtility.ArrayClear(self.shopList)
  else
    self.shopList = {}
  end
  local goods = ShopProxy.Instance:GetConfigByTypeId(shopType, shopId)
  for id, good in pairs(goods) do
    if self:CheckDateValid(good) then
      TableUtility.InsertSort(self.shopList, {good}, function(a, b)
        return a[1].ShopOrder > b[1].ShopOrder
      end)
    end
    TableUtility.InsertSort(self.allGoodsList, good, function(a, b)
      return a.ShopOrder > b.ShopOrder
    end)
  end
  local MysticalGoods = ShopProxy.Instance:GetConfigByTypeId(MysticalShopType, MysticalShopId)
  if MysticalGoods ~= nil then
    local tDatas = {}
    for id, good in pairs(MysticalGoods) do
      good.m_isMysticalShop = true
      TableUtility.InsertSort(tDatas, good, function(a, b)
        return a[1].ShopOrder > b[1].ShopOrder
      end)
    end
    for i = #tDatas, 1, -1 do
      table.insert(self.shopList, 1, {
        tDatas[i]
      })
      table.insert(self.allGoodsList, 1, tDatas[i])
    end
  end
  for i = 1, #self.shopList do
    self.shopList[i][2] = i
  end
  self:UpdateWholeRedTip()
end

function PeddlerShopProxy:InitShop()
  HappyShopProxy.Instance:InitShop(nil, shopId, shopType)
end

function PeddlerShopProxy:GetPeddlerShopItemData(goodId)
  for i = 1, #self.allGoodsList do
    if self.allGoodsList[i].id == goodId then
      return self.allGoodsList[i]
    end
  end
end

function PeddlerShopProxy:CheckUnlockByPre(goodId)
  local shopItemData = self:GetPeddlerShopItemData(goodId)
  if not shopItemData then
    return false
  end
  local pre_goodId = shopItemData.unlockpreid
  local pre_shopItemData = self:GetPeddlerShopItemData(pre_goodId)
  if not pre_shopItemData then
    return true
  end
  local pre_unlocknextcount = pre_shopItemData.unlocknextcount
  local pre_buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(pre_goodId) or 0
  return pre_unlocknextcount <= pre_buyCount
end

function PeddlerShopProxy:CheckOpen()
  return self.shopList and #self.shopList > 0 or false
end

local getTime = function(delta)
  local hour = math.ceil(delta / 3600)
  local day = math.floor(hour / 24)
  hour = hour % 24
  local str = ""
  if 0 < day then
    str = str .. string.format(ZhString.PeddlerShop_timeDay, day)
  end
  if 0 < hour then
    str = str .. string.format(ZhString.PeddlerShop_timeHour, hour)
  end
  return str
end

function PeddlerShopProxy:GetNewGoodsArrival()
  local delta
  local curServerTime = ServerTime.CurServerTime() / 1000
  for i = 1, #self.allGoodsList do
    local good = self.allGoodsList[i]
    if not self:CheckDateValid(good) then
      local _delta = good.AddDate - curServerTime
      if 0 < _delta then
        delta = delta and math.min(delta, _delta) or _delta
      end
    end
  end
  if delta then
    local hour = math.ceil(delta / 3600)
    local day = math.floor(hour / 24)
    hour = hour - day * 24
    return getTime(delta)
  end
end

function PeddlerShopProxy:GetCloseTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local delta = 0
  for i = 1, #self.allGoodsList do
    local good = self.allGoodsList[i]
    local _delta = good.RemoveDate - curServerTime
    if 0 < _delta then
      delta = math.max(delta, _delta)
    end
  end
  if delta then
    return getTime(delta)
  end
end

function PeddlerShopProxy:CheckDateValid(goods)
  local AddDate = goods.AddDate or -1
  local RemoveDate = goods.RemoveDate or -1
  local curServerTime = ServerTime.CurServerTime() / 1000
  return AddDate <= curServerTime and RemoveDate >= curServerTime
end

function PeddlerShopProxy:GetCfg()
  if not self.cfg then
    self.cfg = {
      icon = "tab_icon_75",
      name = ZhString.PeddlerShop_name
    }
  end
  return self.cfg
end

function PeddlerShopProxy:HasCanBuyGoods()
  if self.shopList then
    for i = 1, #self.shopList do
      local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.shopList[i][1])
      if 0 < canBuyCount then
        return true
      end
    end
  end
end

PeddlerShopProxy.WholeRedTipID = 10500

function PeddlerShopProxy:UpdateWholeRedTip()
  if self:isShowRedTip() then
    RedTipProxy.Instance:UpdateRedTip(self.WholeRedTipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(self.WholeRedTipID)
  end
end

function PeddlerShopProxy:isShowRedTip()
  local ret = not LocalSaveProxy.Instance:CheckPeddlerDailyDot() and self:HasCanBuyGoods()
  redlog("is show red tip = " .. tostring(ret))
  return ret
end

function PeddlerShopProxy:GetShopDataByTypeId(id)
  return ShopProxy.Instance:GetShopItemDataByTypeId(MysticalShopType, MysticalShopId, id)
end
