autoImport("ShopItemInfoCell")
ShopSaleSellItemCell = class("ShopSaleSellItemCell", ShopItemInfoCell)

function ShopSaleSellItemCell:SetData(data)
  if data then
    self.data = data
    local moneytype = data.moneytype
    self.moneycount = ShopSaleProxy.Instance:GetPrice(data)
    self.maxcount = data.maxcount
    IconManager:SetMoneyIcon(moneytype, self.priceIcon)
    IconManager:SetMoneyIcon(moneytype, self.totalPriceIcon)
    local pureCost = ShopSaleProxy.Instance:GetPurePrice(self.data)
    self.discount, self.discountCount = ShopSaleProxy.Instance:GetTotalSellDiscount(pureCost)
    if self.discount ~= 0 then
      self.salePrice:SetActive(true)
      self:UpdateSale(self.discount, self.discountCount)
    else
      self.salePrice:SetActive(false)
    end
  end
  ShopSaleSellItemCell.super.SetData(self, data)
end

function ShopSaleSellItemCell:TryInitItemCell(container, pfbName, control)
  ShopSaleSellItemCell.super.super.TryInitItemCell(self, container, pfbName, control)
end

function ShopSaleSellItemCell:Confirm()
  local nums = self.count
  if 0 < nums then
    self:CalcTotalPrice(nums)
    ShopSaleProxy.Instance:AddToWaitSaleItems(self.data.id, nums, self.totalCost)
    self:PassEvent(ShopSaleEvent.SaleSuccess)
  end
  ShopSaleSellItemCell.super.Confirm(self)
end

function ShopSaleSellItemCell:CalcTotalPrice(count)
  self.totalCost = ShopSaleSellItemCell.super.CalcTotalPrice(self, count)
  local pureCost = ShopSaleProxy.Instance:GetPurePrice(self.data)
  self.discount, self.discountCount = ShopSaleProxy.Instance:GetTotalSellDiscount(pureCost)
  self.discountCount = self.discountCount * count
  self.discountTotal = self.discountCount + self.totalCost
end

function ShopSaleSellItemCell:UpdateSale(discount, totalCost)
  self.salePriceTip.text = string.format(ZhString.ShopSale_SellExpensive, discount * 100, StringUtil.NumThousandFormat(totalCost))
end
