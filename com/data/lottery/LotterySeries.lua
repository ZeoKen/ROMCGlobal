local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayFindIndex = TableUtility.ArrayFindIndex
LotterySeries = class("LotterySeries")

function LotterySeries.sortFunc(l, r)
  return l.goodsID < r.goodsID
end

function LotterySeries:ctor(period, data)
  self.shop_year = data.shop_year
  self.shop_month = data.shop_month
  self.shop_day = data.shop_day
  self.period = period
  self.items = {}
  self.fashions = {}
  self.gender_fashions = {
    [1] = {},
    [2] = {}
  }
  self.heads = {}
  self.heads[LotteryHeadwearType.Male_Headwear] = {}
  self.heads[LotteryHeadwearType.Female_Headwear] = {}
  self.needSort = true
end

function LotterySeries:Add(data)
  self.items[#self.items + 1] = data
  local type = data.headwearType
  if type == LotteryHeadwearType.Fashion then
    _ArrayPushBack(self.fashions, data)
  elseif type == LotteryHeadwearType.Male_Headwear then
    _ArrayPushBack(self.heads[LotteryHeadwearType.Male_Headwear], data)
  elseif type == LotteryHeadwearType.Female_Headwear then
    _ArrayPushBack(self.heads[LotteryHeadwearType.Female_Headwear], data)
  end
end

function LotterySeries:HasFashion()
  return #self.fashions > 0
end

function LotterySeries:IsFashionGot()
  for i = 1, #self.fashions do
    if self.fashions[i]:CheckGoodsGroupGot() then
      return true
    end
  end
end

function LotterySeries:Sort()
  if not self.needSort then
    return
  end
  table.sort(self.fashions, LotterySeries.sortFunc)
  for _, heads in pairs(self.heads) do
    table.sort(heads, LotterySeries.sortFunc)
  end
  for i = 1, #self.fashions do
    local gender = self.fashions[i].SexEquip
    _ArrayPushBack(self.gender_fashions[gender], self.fashions[i])
  end
  self.needSort = false
end

function LotterySeries:FindFashionIndex(fashion_id)
  local index
  for i = 1, #self.fashions do
    if self.fashions[i]:GetRealItemID() == fashion_id then
      index = i
      break
    end
  end
  if index then
    return index % 4
  end
end

function LotterySeries:GetRandomFashion()
  self:Sort()
  local random_index = math.random(1, #self.fashions)
  return self.fashions[random_index]
end

function LotterySeries:GetHeadByFashion(fashion_id)
  self:Sort()
  local index = self:FindFashionIndex(fashion_id)
  if not index then
    return
  end
  local myGender = MyselfProxy.Instance:GetMySex()
  local headGender = myGender == 1 and LotteryHeadwearType.Male_Headwear or LotteryHeadwearType.Female_Headwear
  local head = self.heads[headGender][index]
  if not head then
    redlog("配置错误，未取到对应头饰，检查HeadwearRepair表，时装id： ", fashion_id)
  else
    return head:GetRealItemID()
  end
end
