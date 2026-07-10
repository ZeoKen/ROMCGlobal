autoImport("ActivityIntegrationTaskCell")
ActivityIntegrationTaskCellType2 = class("ActivityIntegrationTaskCellType2", ActivityIntegrationTaskCell)

function ActivityIntegrationTaskCellType2:FindObjs()
  ActivityIntegrationTaskCellType2.super.FindObjs(self)
  self.buyBtnDefaultY = self.buyBtn and self.buyBtn.transform.localPosition.y or 0
  if self.buyBtn_DiscountMark then
    self.buyBtn_DiscountMark:SetActive(false)
  end
end

function ActivityIntegrationTaskCellType2:Set_DiscountMark(active, oriPrice, curPrice, showDiscount, priceCurrencyPrefix, discountPercent)
  priceCurrencyPrefix = priceCurrencyPrefix or ""
  if active then
    if self.buyBtn_OriPrice and oriPrice then
      self.buyBtn_OriPrice.text = string.format(ZhString.Shop_OriginPrice, priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(oriPrice))
    end
    if curPrice then
      self.buyBtn_Price.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(curPrice)
    end
  end
  if self.buyBtn_OriPrice then
    self.buyBtn_OriPrice.gameObject:SetActive(active == true)
  end
  if self.buyBtn_DiscountMark then
    self.buyBtn_DiscountMark:SetActive(false)
  end
  self:UpdateBuyBtnPos(active == true)
end

function ActivityIntegrationTaskCellType2:UpdateBuyBtnPos(showOriPrice)
  if not self.buyBtn then
    return
  end
  local pos = self.buyBtn.transform.localPosition
  self.buyBtn.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, showOriPrice and 14.5 or self.buyBtnDefaultY, pos.z)
end

function ActivityIntegrationTaskCellType2:RefreshLimitLabel()
  if self.buyBtn_LimitLabel then
    local text = self.buyBtn_LimitLabel.text
    if text == nil or text == "" then
      self.buyBtn_LimitLabel.gameObject:SetActive(false)
    end
  end
  self:RefreshLabelTable()
end

function ActivityIntegrationTaskCellType2:SetData(data)
  ActivityIntegrationTaskCellType2.super.SetData(self, data)
  self:RefreshLimitLabel()
end

function ActivityIntegrationTaskCellType2:SetShopItemData(shopItemData)
  ActivityIntegrationTaskCellType2.super.SetShopItemData(self, shopItemData)
  self:RefreshLimitLabel()
end

function ActivityIntegrationTaskCellType2:SetDepositData()
  ActivityIntegrationTaskCellType2.super.SetDepositData(self)
  self:RefreshLimitLabel()
end
