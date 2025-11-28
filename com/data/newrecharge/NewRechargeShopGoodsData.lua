autoImport("HappyShopProxy")
NewRechargeShopGoodsData = class("NewRechargeShopGoodsData")

function NewRechargeShopGoodsData:ctor()
  NewRechargeShopGoodsData.GetLimitStr()
end

function NewRechargeShopGoodsData.GetLimitStr()
  if not NewRechargeShopGoodsData.LimitStr then
    NewRechargeShopGoodsData.LimitStr = {
      [1] = ZhString.NewRecharge_BuyLimit_Char_Daily,
      [4] = ZhString.NewRecharge_BuyLimit_Acc_Daily,
      [8] = ZhString.NewRecharge_BuyLimit_Acc_Ever,
      [16] = ZhString.NewRecharge_BuyLimit_Char_Weekly,
      [32] = ZhString.NewRecharge_BuyLimit_Char_Monthly,
      [64] = ZhString.NewRecharge_BuyLimit_Acc_Weekly,
      [128] = ZhString.NewRecharge_BuyLimit_Acc_Monthly,
      [512] = ZhString.NewRecharge_BuyLimit_Char_Permanent
    }
  end
  return NewRechargeShopGoodsData.LimitStr
end

function NewRechargeShopGoodsData:ResetData(shopItemData)
  self.shopItemData = shopItemData
  local itemConfID = self.shopItemData.goodsID
  self.itemConf = Table_Item[itemConfID]
  self.itemID = self.itemConf.id
  local cachedHaveBoughtItemCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount()
  if cachedHaveBoughtItemCount ~= nil then
    self.purchaseTimes = cachedHaveBoughtItemCount[self.shopItemData.id]
    self.purchaseTimes = self.purchaseTimes or 0
  else
    self.purchaseTimes = 0
  end
  self.purchaseLimitStr = nil
  for k, v in pairs(self.LimitStr) do
    if self.shopItemData:CheckLimitType(k) then
      self.purchaseLimitStr = v
      break
    end
  end
end

function NewRechargeShopGoodsData:GetLimitCanBuyCount()
  local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
  return canBuyCount
end

function NewRechargeShopGoodsData:GetDisCount()
  local discount = 100
  if self.shopItemData then
    local oriPrice = self.shopItemData.ItemCount
    if math.abs(self.shopItemData:GetBuyFinalPrice(oriPrice, 1) - oriPrice) > math.Epsilon then
      if self.shopItemData.actDiscount ~= 0 then
        discount = self.shopItemData.actDiscount
      elseif self.shopItemData.Discount ~= 0 then
        discount = self.shopItemData.Discount
      end
    end
  end
  return discount
end

function NewRechargeShopGoodsData:GetCurPrice()
  local price = self:GetOriPrice()
  return math.floor(price * self:GetDisCount() / 100)
end

function NewRechargeShopGoodsData:GetOriPrice()
  if self.shopItemData.changeCost then
    local curSum = self.shopItemData.sum_count or 0
    return self.shopItemData:GetChangeCost(curSum + 1)
  end
  return self.shopItemData.ItemCount
end

function NewRechargeShopGoodsData:IsNewAdd()
  return self.shopItemData:CheckIsNewAdd()
end
