local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local _format = "%d-%d-%d %02d:%02d:%02d"
MixLotteryItemData = class("MixLotteryItemData")

function MixLotteryItemData:ctor(mix_type, groupId, grouprate, server_item)
  self.unique_id = 0
  self.unique_period = 0
  self:SetData(mix_type, groupId, grouprate, server_item)
  self:SetCoinGroupRate()
end

function MixLotteryItemData:SetCoinGroupRate()
  self.coinRateMap = {}
  local coinGroup = GameConfig.MixLottery.CoinGroup
  if coinGroup then
    for _, v in pairs(coinGroup) do
      self.coinRateMap[v.count] = v.Weight / 100
    end
  end
end

function MixLotteryItemData:SetData(mix_type, groupId, grouprate, server_item)
  self.type = mix_type
  self.groupId = groupId
  self.rate = grouprate
  self.itemid = server_item.id
  self.count = server_item.count or 1
  if LotteryProxy.IsOldMixLottery(mix_type) then
    return
  end
  self.in_pool = server_item.in_pool == true
  self.in_shop = server_item.in_shop == true
  self.in_shop_time = server_item.in_shop_time and server_item.in_shop_time > 0 and server_item.in_shop_time or nil
  if self.in_shop_time then
    self.in_shop_date = os.date("*t", self.in_shop_time)
  end
  self.goodsID = self.itemid
  self.ItemID = FunctionLottery.Me():GetMixLotteryShopCostID()
  self.ItemCount = FunctionLottery.Me():GetGroupidPrice(self.goodsID)
  self.shop_year, self.shop_month, self.shop_day = FunctionLottery.Me():GetYearMonth(self.goodsID)
  self.headwearRepairStaticData = Table_HeadwearRepair[self.goodsID]
  if self.headwearRepairStaticData then
    if self.in_pool then
      local female_ID = Game.Config_EquipMale2FemaleMap[self.goodsID]
      if nil ~= female_ID then
        self.female_itemid = female_ID
      end
    end
    self.headwearType = self.headwearRepairStaticData.Type
    local sell_time = self.headwearRepairStaticData.SellTime
    if not StringUtil.IsEmpty(sell_time) then
      local year, month, day, hour, min, sec = sell_time:match(p)
      self.sellTime = os.time({
        year = year,
        month = month,
        day = day,
        hour = hour,
        min = min,
        sec = sec
      })
      if ServerTime.CurServerTime() / 1000 < self.sellTime then
        redlog("混合扭蛋商店上架时间错误通知后端排查，上架物品ID: ", self.goodsID)
      end
    end
    local equipStatic = Table_Equip[self.goodsID]
    if not equipStatic then
      redlog("Equip表未配置 请联系配置警察徐可人 错误ID： ", self.goodsID)
    end
    self.SexEquip = equipStatic.SexEquip or 1
    local my_gender = MyselfProxy.Instance:GetMySex()
    self.group_id = equipStatic.GroupID
    self.genderSortId = self.SexEquip == my_gender and 1 or 2
    if self.headwearType ~= LotteryHeadwearType.Wing then
      self.groupId, self.rate, self.headwearSortID = FunctionLottery.Me():GetGroupIDRateSortID(self.goodsID)
      if self.shop_year and self.shop_month then
        self.shop_time = string.format("%d.%02d", self.shop_year, self.shop_month)
        self.unique_id = self.shop_year * 1000 + self.shop_month * 10 + self.headwearSortID
        self.unique_period = self.shop_year * 10000 + self.shop_month * 100 + self.shop_day
      end
    end
  end
  self.unlockSortId = self:CheckPurchaseInvalid() and 0 or 1
end

function MixLotteryItemData:GetShopTimeDisplay()
  if self:CheckPurchaseInvalid() then
    return string.format(ZhString.LotteryMixed_ShopPurchaseInvalid, self.shop_time, self:GetPurchaseSuitShopTimeStr())
  else
    local got_cnt, cnt = LotteryProxy.Instance:GetYearMonthGotCount(self.shop_year, self.shop_month)
    return string.format(ZhString.LotteryMixed_ShopPurchaseValid, self.shop_time, got_cnt, cnt)
  end
end

function MixLotteryItemData:SetSeriesFlag(var)
  self.newSeries = var
end

function MixLotteryItemData:CheckGoodsGot(baseOnGoodsID)
  local id = baseOnGoodsID and self.goodsID or self:GetRealItemID()
  return LotteryProxy.CheckGot(id)
end

function MixLotteryItemData:CheckGoodsGroupGot(baseOnGoodsID)
  local id = baseOnGoodsID and self.goodsID or self:GetRealItemID()
  return LotteryProxy.CheckGoodsGroupGot(id)
end

function MixLotteryItemData:CheckGot(baseOnGoodsID)
  if self.group_id then
    return self:CheckGoodsGroupGot(baseOnGoodsID)
  else
    return self:CheckGoodsGot(baseOnGoodsID)
  end
end

function MixLotteryItemData:HasGetFashion()
  if self.group_id or self.headwearType == LotteryHeadwearType.Fashion then
    return self.got
  end
  return false
end

function MixLotteryItemData:IsNeverDisplay()
  return AdventureDataProxy.Instance:IsFashionNeverDisplay(self.itemid, true)
end

function MixLotteryItemData:InPool()
  return self.in_pool == true
end

function MixLotteryItemData:InShop()
  if not self.sellTime then
    return false
  end
  return self.sellTime < ServerTime.CurServerTime() / 1000
end

function MixLotteryItemData:GetPurchaseShopTimeStr()
  if not self.in_shop_date then
    return
  end
  local timeStr = string.format(_format, self.in_shop_date.year, self.in_shop_date.month, self.in_shop_date.day, self.in_shop_date.hour, self.in_shop_date.min, self.in_shop_date.sec)
  return timeStr
end

function MixLotteryItemData:GetPurchaseSuitShopTimeStr()
  if not self.in_shop_date then
    return
  end
  local timeStr = string.format(ZhString.LotteryMixed_ShopPurchaseTime, self.in_shop_date.month, self.in_shop_date.day)
  return timeStr
end

function MixLotteryItemData:CheckPurchaseInvalid()
  return self.in_shop ~= true
end

function MixLotteryItemData:GetServerItemData()
  if self.serverItemData == nil then
    self.serverItemData = ItemData.new("LotteryItem", self.itemid)
    self.serverItemData.num = self.count
  end
  return self.serverItemData
end

function MixLotteryItemData:GetItemData()
  if self.itemData == nil then
    local itemid = self.itemid
    if self.female_itemid and self.female_itemid ~= 0 then
      local sex = Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
      if sex == 2 then
        itemid = self.female_itemid
      end
    end
    self.itemData = ItemData.new("LotteryItem", itemid)
    self.itemData.num = self.count
  end
  return self.itemData
end

function MixLotteryItemData:GetRate()
  if LotteryProxy.IsOldMixLottery(self.type) then
    if self.rate then
      local ungetCount = FunctionLottery.Me():GetUngetCnt(self.groupId)
      if ungetCount and 0 ~= ungetCount then
        local tempRate = self.rate / 100
        return string.format(ZhString.Lottery_MixLotteryRate, math.floor(tempRate + 0.5) / 100 / ungetCount)
      end
    end
    return 0
  elseif self.groupId ~= LotteryProxy.MixCoinGroup then
    local ungetCount = FunctionLottery.Me():GetUngetCnt(self.groupId)
    if ungetCount and 0 ~= ungetCount then
      return string.format(ZhString.Lottery_MixLotteryRate, self.rate * 100 / ungetCount)
    end
    return 0
  else
    local rate = self.coinRateMap[self.count] or 0
    local grouprate = FunctionLottery.Me():GetRateByGroup(LotteryProxy.MixCoinGroup)
    return rate * grouprate * 10000
  end
end

function MixLotteryItemData.SortFunc(l, r)
  local l_sortId = l:CheckGot() and 0 or 1
  local r_sortId = r:CheckGot() and 0 or 1
  if l_sortId == r_sortId then
    if l.groupId == r.groupId then
      if l.itemid == r.itemid then
        return l.count < r.count
      else
        return l.itemid < r.itemid
      end
    else
      return l.groupId < r.groupId
    end
  else
    return l_sortId > r_sortId
  end
end

function MixLotteryItemData.NewMixSortFunc(a, b)
  if a.unique_id == b.unique_id then
    if a.headwearType == b.headwearType then
      return a.itemid < b.itemid
    else
      return a.headwearType < b.headwearType
    end
  else
    return a.unique_id > b.unique_id
  end
end

function MixLotteryItemData:GetRealItemID()
  local itemData = self:GetItemData()
  return itemData and itemData.staticData and itemData.staticData.id
end
