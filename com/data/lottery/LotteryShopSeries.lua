local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayFindIndex = TableUtility.ArrayFindIndex
LotteryShopSeries = class("LotteryShopSeries")

function LotteryShopSeries.sortFunc(l, r)
  return l.goodsID < r.goodsID
end

function LotteryShopSeries:ctor(period, data)
  self.shop_year = data.shop_year
  self.shop_month = data.shop_month
  self.shop_day = data.shop_day
  self.period = period
  self.items = {}
  self.groupItemMap = {}
end

function LotteryShopSeries:Add(data)
  local group_id = data.group_id
  if group_id then
    local group_items = self.groupItemMap[group_id]
    if not group_items then
      group_items = {}
      self.groupItemMap[group_id] = group_items
    end
    _ArrayPushBack(group_items, data)
  else
    _ArrayPushBack(self.items, data)
  end
end

function LotteryShopSeries:GetCount()
  local groupCount = 0
  local groupGotCount = 0
  for k, v in pairs(self.groupItemMap) do
    groupCount = groupCount + 1
    for i = 1, #v do
      if v[i]:CheckGoodsGroupGot(true) then
        groupGotCount = groupGotCount + 1
        break
      end
    end
  end
  local item_got = 0
  for i = 1, #self.items do
    if self.items[i]:CheckGoodsGot(true) then
      item_got = item_got + 1
    end
  end
  self.count = #self.items + groupCount
  self.got_count = item_got + groupGotCount
  return self.got_count, self.count
end

function LotteryShopSeries:MatchYearMonth(year, month)
  return self.shop_year == year and self.shop_month == month
end
