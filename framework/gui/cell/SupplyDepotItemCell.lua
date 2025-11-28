SupplyDepotItemCell = class("SupplyDepotItemCell", ShopItemInfoCell)

function SupplyDepotItemCell:FindObjs()
  SupplyDepotItemCell.super.FindObjs(self)
  self.priceTitle = self:FindGO("PriceTitle"):GetComponent(UILabel)
  self.totalPriceTitle = self:FindGO("TotalPriceTitle"):GetComponent(UILabel)
  self.ownInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
  self.limitCount = self:FindGO("LimitCount"):GetComponent(UILabel)
  self.todayCanBuy = self:FindGO("TodayCanBuy"):GetComponent(UILabel)
  self.priceRoot = self:FindGO("PriceRoot")
  self.multiplePriceRoot = self:FindGO("MultiplePriceRoot")
  self.confirmSprite = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
  self.countBg = self:FindGO("CountBg")
end

function SupplyDepotItemCell:SetData(data)
  if data then
    self.itemData = data
    self.data = data:GetItemData()
    self.todayCanBuy.gameObject:SetActive(false)
    self.limitCount.gameObject:SetActive(false)
    self.multiplePriceRoot:SetActive(false)
    self.priceRoot:SetActive(true)
    local moneyID = data.ItemID
    local moneyData = Table_Item[moneyID]
    if moneyData ~= nil then
      local icon = moneyData.Icon
      if icon ~= nil then
        IconManager:SetItemIcon(icon, self.priceIcon)
        IconManager:SetItemIcon(icon, self.totalPriceIcon)
      end
    end
    self.maxcount = 1
    self.discount = (100 - data.Discount) / 100
    self.discountCount = self.discount * data.ItemCount
    self.discountTotal = data.ItemCount - self.discountCount
    self.maxcount = 1
    self.moneycount = self.discountTotal
    self:UpdateSale(self.discount, self.discountCount)
    self:UpdateOwnedInfo()
    SupplyDepotItemCell.super.SetData(self, data)
  end
end

function SupplyDepotItemCell:Confirm()
  if not SupplyDepotProxy.Instance:IsActive() then
    MsgManager.ShowMsgByID(40973)
    return
  end
  local zenyCount = MyselfProxy.Instance:GetROB()
  if zenyCount < self.discountTotal then
    MsgManager.ShowMsgByID(1)
    return
  end
  SupplyDepotProxy.Instance:SetCurBuyItemIndex(self.itemData.idx)
  ServiceSessionShopProxy.Instance:CallBuyShopItem(self.itemData.id, 1, self.discountTotal, nil, nil, nil, nil, self.itemData.idx)
  self:PlayUISound(AudioMap.UI.Click)
  self.gameObject:SetActive(false)
end

function SupplyDepotItemCell:UpdateSale(discount, totalCost)
  self.salePrice:SetActive(false)
end

function SupplyDepotItemCell:UpdateOwnedInfo()
  local owned = SupplyDepotProxy.Instance:GetItemNumByStaticID(self.itemData.goodsID) or 0
  self.ownInfo.text = string.format(ZhString.HappyShop_OwnInfo, owned)
end
