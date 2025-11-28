autoImport("IconManager")
autoImport("UIPriceDiscount")
autoImport("FuncZenyShop")
UIListItemControllerItemSale = class("UIListItemControllerItemSale", BaseCell)

function UIListItemControllerItemSale:Init()
  self:GetGameObjects()
end

function UIListItemControllerItemSale:SetData(data)
  self.shopItemData = data
  self:GetModelSet()
  self:LoadView()
  self:RegisterClickEvent()
end

function UIListItemControllerItemSale:GetGameObjects()
  self.spIcon = self:FindGO("Icon", self.gameObject):GetComponent(UISprite)
  self.labCount = self:FindGO("Count"):GetComponent(UILabel)
  self.labName = self:FindGO("Name", self.gameObject):GetComponent(UILabel)
  self.goPrice = self:FindGO("Price")
  self.labPrice = self:FindGO("Lab", self.goPrice):GetComponent(UILabel)
  self.spGoldIcon = self:FindGO("Icon", self.goPrice):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.spGoldIcon)
  self.goOriginPrice = self:FindGO("OriginPrice")
  self.labOriginPrice = self:FindGO("Lab", self.goOriginPrice):GetComponent(UILabel)
  self.goPriceBG = self:FindGO("BG", self.goPrice)
  self.goDiscount = self:FindGO("Discount", self.gameObject)
  self.goPercent = self:FindGO("Percent", self.goDiscount)
  self.labPercent = self:FindGO("Value1", self.goPercent):GetComponent(UILabel)
  self.labPercentSymbol = self:FindGO("Value2", self.goPercent):GetComponent(UILabel)
  self.spPercentBG = self:FindGO("BG", self.goPercent):GetComponent(UIMultiSprite)
  self.goSoldOut = self:FindGO("SoldOut")
  self.extraDes = self:FindGO("ExtraDes"):GetComponent(UILabel)
  self.newMark = self:FindGO("NewMark")
  self.newMarkLab = self:FindGO("markLab", self.newMark):GetComponent(UILabel)
  self.newMarkLab.text = ZhString.HappyShop_NewMark
end

function UIListItemControllerItemSale:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:OnClickForSelf()
  end)
  self:AddClickEvent(self.goPriceBG, function()
    self:OnClickForPriceView()
  end)
  self:AddClickEvent(self.spIcon.gameObject, function()
    self:OnClickForIconView()
  end)
end

function UIListItemControllerItemSale:GetModelSet()
  self.itemID = self.shopItemData.goodsID
  self.itemConf = Table_Item[self.itemID]
  self.canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
end

function UIListItemControllerItemSale:LoadView()
  if self.itemConf == nil then
    redlog("Good Is Nil:", self.itemID)
    return
  end
  IconManager:SetItemIcon(self.itemConf.Icon, self.spIcon)
  self.labCount.text = self.shopItemData.goodsCount
  self.labName.text = self.itemConf.NameZh
  self.price = self:GetDiscountPrice()
  self.labPrice.text = FuncZenyShop.FormatMilComma(self.price)
  if self:IsSoldOut() then
    self.goSoldOut:SetActive(true)
  else
    self.goSoldOut:SetActive(false)
  end
  self.newMark:SetActive(self.shopItemData:CheckIsNewAdd())
  self.extraDes.text = self.shopItemData.extraDes or ""
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
  local leftCount
  if canBuyCount ~= nil then
  elseif self.shopItemData.discountMax ~= 0 then
    leftCount = self.shopItemData.discountMax - HappyShopProxy.Instance:GetDiscountItemCount(self.shopItemData.id)
    if leftCount < 0 then
      leftCount = 0
    end
  end
  local moneyItem = Table_Item and Table_Item[self.shopItemData.ItemID]
  if moneyItem and moneyItem.Icon then
    IconManager:SetItemIcon(moneyItem.Icon, self.spGoldIcon)
  end
  if self:IsDiscount() then
    if leftCount and leftCount == 0 then
      self.labPrice.text = FuncZenyShop.FormatMilComma(self.shopItemData.ItemCount)
      self.goOriginPrice:SetActive(false)
      self.goDiscount:SetActive(false)
    else
      self.goOriginPrice:SetActive(true)
      self.labOriginPrice.text = ZhString.HappyShop_originalCost .. FuncZenyShop.FormatMilComma(self.shopItemData.ItemCount)
      self.goDiscount:SetActive(true)
      self.labPercent.text = self:GetDisCount() - 100
      local mulSpriteState, color = UIPriceDiscount.GetDiscountColor(self:GetDisCount())
      self.labPercent.effectColor = color
      self.labPercentSymbol.effectColor = color
      self.spPercentBG.CurrentState = mulSpriteState
    end
  else
    self.goOriginPrice:SetActive(false)
    self.goDiscount:SetActive(false)
  end
  RedTipProxy.Instance:UnRegisterUI(UIModelZenyShop.DailyOneZenyRedTipID, self.spIcon.gameObject)
  if self.shopItemData.id == UIModelZenyShop.DailyOneZenyGoodsID then
    RedTipProxy.Instance:RegisterUI(UIModelZenyShop.DailyOneZenyRedTipID, self.spIcon.gameObject)
  end
end

function UIListItemControllerItemSale:OnClickForSelf()
  UISubViewControllerZenyShopItem.instance:LoadPurchaseDetailView(self.shopItemData)
  HappyShopProxy.Instance:SetSelectId(self.shopItemData.id)
end

function UIListItemControllerItemSale:OnClickForPriceView()
  if self:IsHaveEnoughCostForBuy() and not self.shopItemData:CheckCanRemove() then
    ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopItemData.id, 1)
  end
end

local iconTipOffset = {-148, -37}

function UIListItemControllerItemSale:OnClickForIconView()
  local itemData = ItemData.new(nil, self.itemID)
  local tab = ReusableTable.CreateTable()
  tab.itemdata = itemData
  tab.showFrom = "ZenyShopItem"
  self:ShowItemTip(tab, UISubViewControllerZenyShopItem.instance.widgetTipRelative, NGUIUtil.AnchorSide.Center, iconTipOffset)
  ReusableTable.DestroyAndClearTable(tab)
end

function UIListItemControllerItemSale:IsHaveEnoughCostForBuy()
  local bCatGold = MyselfProxy.Instance:GetLottery()
  if bCatGold < self.price then
    MsgManager.ShowMsgByID(3634)
    return false
  else
    return true
  end
end

function UIListItemControllerItemSale:GetDiscountPrice()
  return math.floor(self.shopItemData.ItemCount * self:GetDisCount() / 100)
end

function UIListItemControllerItemSale:IsDiscount()
  return self:GetDiscountPrice() < self.shopItemData.ItemCount
end

function UIListItemControllerItemSale:IsSoldOut()
  return self.canBuyCount ~= nil and self.canBuyCount <= 0
end

function UIListItemControllerItemSale:GetDisCount()
  local discount = 100
  if self.shopItemData then
    if self.shopItemData.actDiscount ~= 0 then
      discount = self.shopItemData.actDiscount
    elseif self.shopItemData.Discount ~= 0 then
      discount = self.shopItemData.Discount
    end
  end
  return discount
end
