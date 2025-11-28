autoImport("LotteryItemData")
LotteryData = class("LotteryData")

function LotteryData:ctor(data, clientFixRate)
  self.items = {}
  self.itemMap = {}
  self.upData = {}
  self:SetData(data, clientFixRate)
end

function LotteryData:SetData(data, clientFixRate)
  if data then
    self.year = data.year
    self.month = data.month
    self.price = data.price
    self.discount = data.discount
    self.boxItemid = data.lotterybox
    self:AddItems(data.subInfo, clientFixRate)
  end
end

function LotteryData:AddItems(subInfo, clientFixRate)
  local cumulativeRate = 0
  for i = 1, #subInfo do
    local item = LotteryItemData.new(subInfo[i])
    if clientFixRate then
      if i == #subInfo then
        local totalRate = BranchMgr.IsKorea() and 1000000000 or 1000000
        item:ResetServerItemRate(totalRate, cumulativeRate)
      else
        cumulativeRate = cumulativeRate + item.rate
      end
    end
    if 0 < item.rate then
      TableUtility.ArrayPushBack(self.items, item)
    end
    self.itemMap[item.itemid] = item
    if item.female_itemid then
      self.itemMap[item.female_itemid] = item
    end
    if item:HasConfigTime() then
      self.clientYear = item.timeShow
    end
    if item.isCurBatch == 1 then
      TableUtility.ArrayPushBack(self.upData, item:GetItemData())
    end
  end
end

function LotteryData:GetUpData()
  return self.upData
end

function LotteryData:GetFilterYear()
  return self.clientYear or self.year
end

function LotteryData:SetBgName()
  local temp = self.year * 100 + self.month
  self.bgName = "lottery_" .. temp
end

function LotteryData:SetTodayCount(todayCount, maxCount)
  self.todayCount = todayCount
  if maxCount ~= nil then
    self.maxCount = maxCount
  end
end

function LotteryData:SetFreeCount(free_cnt)
  self.freeCount = free_cnt
end

function LotteryData:SetTodayExtraCount(todayextraCount, maxextraCount)
  self.todayExtraCount = todayextraCount
  if maxextraCount ~= nil then
    self.maxExtraCount = maxextraCount
  end
end

function LotteryData:SetOnceMaxCount(onceMaxCount)
  self.onceMaxCount = onceMaxCount
end

function LotteryData:SortItemsByRate()
  table.sort(self.items, LotteryData._SortItemByRate)
end

function LotteryData:SortItemsByQuality()
  table.sort(self.items, LotteryData.SortItemByQuality)
end

function LotteryData:SortItemsByItemType()
  table.sort(self.items, LotteryData.SortItemByItemtype)
end

function LotteryData:SortItemsByLotteryId()
  table.sort(self.items, LotteryData.SortItemByLotteryId)
end

function LotteryData._SortItemByRate(l, r)
  if l.rate and r.rate then
    return l.rate < r.rate
  end
  return false
end

function LotteryData.SortItemByQuality(l, r)
  local staticDatal = Table_Item[l.itemid]
  local staticDatar = Table_Item[r.itemid]
  if staticDatal and staticDatar then
    if staticDatal.Quality == staticDatar.Quality then
      return staticDatal.id < staticDatar.id
    else
      return staticDatal.Quality > staticDatar.Quality
    end
  end
end

function LotteryData:IsPriceIncrease(type)
  if GameConfig.Lottery.CostTipHide ~= nil then
    return false
  end
  return self.price > CommonFun.calcLotteryCost(type, 0)
end

function LotteryData:GetLotteryItemData(itemid)
  return self.itemMap[itemid]
end

function LotteryData.SortItemByItemtype(l, r)
  if l.isCurBatch == r.isCurBatch then
    if l.itemType == r.itemType then
      if l.rate == r.rate then
        return l.itemid < r.itemid
      else
        return l.rate < r.rate
      end
    else
      return l.itemType < r.itemType
    end
  else
    return l.isCurBatch > r.isCurBatch
  end
end

function LotteryData.SortItemByLotteryId(l, r)
  if l.isCurBatch == r.isCurBatch then
    return l.lottery_id < r.lottery_id
  else
    return l.isCurBatch > r.isCurBatch
  end
end

function LotteryData:SetTodayTenCount(todayTenCount, maxTenCount)
  if nil ~= todayTenCount then
    self.todayTenCount = todayTenCount
  end
  if maxTenCount ~= nil then
    self.maxTenCount = maxTenCount
  end
end

local bestCardType = 2

function LotteryData:SetSafetyInfo(sInfos)
  for i = 1, #sInfos do
    if not self.safety then
      self.safety = {}
    end
    self.safety[sInfos[i].itemtype] = sInfos[i].need_count
    if sInfos[i].itemtype == bestCardType then
      self.bestCardCount = sInfos[i].need_count
    end
  end
end

function LotteryData:HasSafety()
  return nil ~= self.safety and nil ~= next(self.safety)
end

function LotteryData:GetMostSafetyInfo()
  return bestCardType, self.bestCardCount or 0
end

function LotteryData:GetSafetyInfoByType(itemtype)
  return itemtype and self.safety and self.safety[itemtype]
end

function LotteryData:GetUpDuration()
  local b, e
  for itemid, lotteryitemdata in pairs(self.itemMap) do
    b, e = lotteryitemdata:GetUpDuration()
    if b and 0 < b and e and 0 < e then
      return b, e
    end
  end
  return
end
