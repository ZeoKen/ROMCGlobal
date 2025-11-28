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

function PeddlerShopProxy:QueryShopConfig(force)
  ShopProxy.Instance:CallQueryShopConfig(shopType, shopId, force)
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

function PeddlerShopProxy:CheckShopOpen()
  local extraBonusBatch = self:CheckExtraBonusActivity()
  if 0 < extraBonusBatch then
    return true, extraBonusBatch
  end
  return self:CheckOpen()
end

function PeddlerShopProxy:CheckExtraBonusActivity()
  if not Table_ShopExtraBonus then
    return 0
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  local isTFBranch = EnvChannel.IsTFBranch()
  for id, config in pairs(Table_ShopExtraBonus) do
    local addDateStr, removeDateStr
    if isTFBranch then
      addDateStr = config.TFAddDate
      removeDateStr = config.TFRemoveDate
    else
      addDateStr = config.AddDate
      removeDateStr = config.RemoveDate
    end
    if addDateStr and removeDateStr then
      local addTime = self:ParseDateStringToRefreshTime(addDateStr)
      local removeTime = self:ParseDateStringToRefreshTime(removeDateStr)
      if addTime and removeTime and currentTime >= addTime and currentTime <= removeTime then
        return config.id
      end
    end
  end
  return 0
end

function PeddlerShopProxy:ParseDateStringToRefreshTime(dateStr)
  if not dateStr then
    return nil
  end
  local year, month, day = dateStr:match("(%d+)/(%d+)/(%d+)")
  if not (year and month) or not day then
    return nil
  end
  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day)
  local targetTime = os.time({
    year = year,
    month = month,
    day = day,
    hour = 5,
    min = 0,
    sec = 0
  })
  return targetTime
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

function PeddlerShopProxy:UpdateExtraBonusData(data)
  xdlog("PeddlerShopProxy:UpdateExtraBonusData", TableUtil.Print(data))
  if not data then
    return
  end
  self.extraBonusData = {
    batch = data.batch or 0,
    buyTimes = data.buytimes or 0,
    resetTimes = data.resettimes or 0,
    rewardIds = data.rewardids or {}
  }
  local tableData = Table_ShopExtraBonus[data.batch or 0]
  if tableData then
    self.extraBonusConfig = tableData
  else
    xdlog("PeddlerShopProxy:UpdateExtraBonusData", "找不到额外奖励配置", data.batch)
  end
end

function PeddlerShopProxy:OnExtraBonusReset(data)
  xdlog("PeddlerShopProxy:OnExtraBonusReset", TableUtil.Print(data))
  if self.extraBonusData and data.success then
    self.extraBonusData.resetTimes = (self.extraBonusData.resetTimes or 0) + 1
    self:QueryShopConfig(true)
  end
end

function PeddlerShopProxy:OnExtraBonusReward(data)
  xdlog("PeddlerShopProxy:OnExtraBonusReward", TableUtil.Print(data))
  if self.extraBonusData and data.rewardid then
    if not self.extraBonusData.rewardIds then
      self.extraBonusData.rewardIds = {}
    end
    table.insert(self.extraBonusData.rewardIds, data.rewardid)
  end
end

function PeddlerShopProxy:GetExtraBonusData()
  return self.extraBonusData
end

function PeddlerShopProxy:GetExtraBonusConfig()
  return self.extraBonusConfig
end

function PeddlerShopProxy:IsExtraBonusRewardReceived(rewardId)
  if not self.extraBonusData or not self.extraBonusData.rewardIds then
    return false
  end
  for _, receivedId in ipairs(self.extraBonusData.rewardIds) do
    if receivedId == rewardId then
      return true
    end
  end
  return false
end

function PeddlerShopProxy:IsExtraBonusRewardReachable(rewardId)
  if not self.extraBonusData then
    return false
  end
  local currentBuyTimes = self.extraBonusData.buyTimes or 0
  return rewardId <= currentBuyTimes
end

function PeddlerShopProxy:IsAllExtraBonusRewardsReceived()
  if not self.extraBonusConfig or not self.extraBonusConfig.ExtraBonus then
    return true
  end
  for rewardId, _ in pairs(self.extraBonusConfig.ExtraBonus) do
    if not self:IsExtraBonusRewardReceived(rewardId) then
      return false
    end
  end
  return true
end

function PeddlerShopProxy:HasResetTimesLeft()
  if not self.extraBonusData or not self.extraBonusConfig then
    return false
  end
  local currentResetTimes = self.extraBonusData.resetTimes or 0
  local maxResetTimes = self.extraBonusConfig.ResetTimesLimit or 0
  return currentResetTimes < maxResetTimes
end

function PeddlerShopProxy:IsAllShopItemsSoldOut()
  if not (self.extraBonusConfig and self.extraBonusConfig.ShopID) or not self.allGoodsList then
    return false
  end
  for _, shopId in ipairs(self.extraBonusConfig.ShopID) do
    local shopItemData = self:GetPeddlerShopItemData(shopId)
    if shopItemData then
      local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(shopItemData)
      if 0 < canBuyCount then
        return false
      end
    else
      xdlog("PeddlerShopProxy:IsAllShopItemsSoldOut", "找不到商品数据", shopId)
    end
  end
  return true
end

function PeddlerShopProxy:CanResetExtraBonus()
  return self:IsAllShopItemsSoldOut() and self:HasResetTimesLeft()
end

function PeddlerShopProxy:GetExtraBonusDisplayData()
  if not (self.extraBonusConfig and self.extraBonusConfig.ExtraBonus) or not self.extraBonusData then
    return {}
  end
  local displayData = {}
  local sortedRewards = {}
  for rewardId, rewardInfo in pairs(self.extraBonusConfig.ExtraBonus) do
    table.insert(sortedRewards, {id = rewardId, info = rewardInfo})
  end
  table.sort(sortedRewards, function(a, b)
    return a.id < b.id
  end)
  local currentBuyTimes = self.extraBonusData.buyTimes or 0
  local previousTarget = 0
  for i, reward in ipairs(sortedRewards) do
    local targetAmount = reward.id
    local rewardItemId = reward.info[1] or 0
    local rewardCount = reward.info[2] or 0
    local status = "pending"
    if self:IsExtraBonusRewardReceived(targetAmount) then
      status = "received"
    elseif self:IsExtraBonusRewardReachable(targetAmount) then
      status = "complete"
    end
    local progressCurrent = math.max(0, currentBuyTimes - previousTarget)
    local progressTarget = targetAmount - previousTarget
    progressCurrent = math.min(progressCurrent, progressTarget)
    local cellData = {
      targetAmount = targetAmount,
      currentAmount = currentBuyTimes,
      rewardId = rewardItemId,
      rewardCount = rewardCount,
      status = status,
      progressCurrent = progressCurrent,
      progressTarget = progressTarget,
      index = i
    }
    table.insert(displayData, cellData)
    previousTarget = targetAmount
  end
  return displayData
end

function PeddlerShopProxy:QueryExtraBonusData()
  ServiceSessionShopProxy.Instance:CallExtraBonusQueryShopCmd()
end

function PeddlerShopProxy:RequestResetExtraBonus()
  if not self:CanResetExtraBonus() then
    xdlog("PeddlerShopProxy:RequestResetExtraBonus", "不满足重置条件")
    return
  end
  if self.extraBonusConfig then
    local batch = self.extraBonusConfig.id or 0
    ServiceSessionShopProxy.Instance:CallExtraBonusResetShopCmd(batch)
  end
end

function PeddlerShopProxy:RequestReceiveExtraBonus(rewardId)
  if not self:IsExtraBonusRewardReachable(rewardId) or self:IsExtraBonusRewardReceived(rewardId) then
    xdlog("PeddlerShopProxy:RequestReceiveExtraBonus", "奖励不可领取", rewardId)
    return
  end
  if self.extraBonusConfig then
    local batch = self.extraBonusConfig.id or 0
    ServiceSessionShopProxy.Instance:CallExtraBonusRewardShopCmd(rewardId)
  end
end

function PeddlerShopProxy:OnShopItemBought(data)
  if not data or not data.success then
    return
  end
  if not self.extraBonusConfig or not self.extraBonusConfig.ShopID then
    return
  end
  local shopId = data.id
  local isInShopIdList = false
  for _, configShopId in ipairs(self.extraBonusConfig.ShopID) do
    if shopId == configShopId then
      isInShopIdList = true
      break
    end
  end
  if not isInShopIdList then
    return
  end
  if not self.extraBonusData then
    self.extraBonusData = {
      batch = self.extraBonusConfig.id or 0,
      buyTimes = 0,
      resetTimes = 0,
      rewardIds = {}
    }
  end
  local count = data.count or 0
  self.extraBonusData.buyTimes = (self.extraBonusData.buyTimes or 0) + count
  xdlog("PeddlerShopProxy:OnShopItemBought", "更新buyTimes", "shopId:", shopId, "count:", count, "新的buyTimes:", self.extraBonusData.buyTimes)
  EventManager.Me():PassEvent(ServiceEvent.SessionShopBuyShopItem, data)
end
