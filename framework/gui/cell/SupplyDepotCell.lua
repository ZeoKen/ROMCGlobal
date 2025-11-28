autoImport("BaseCell")
SupplyDepotCell = class("PeddlerShopFlipCell", BaseCell)

function SupplyDepotCell:Init()
  SupplyDepotCell.super.Init(self)
  self:AddCellClickEvent()
  self.maskGO = self:FindGO("Mask")
  self.discountGO = self:FindGO("Discount")
  self.discountLabel = self:FindGO("DiscountLabel", self.discountGO):GetComponent(UILabel)
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("Icon"):GetComponent(UISprite)
  self.countLabel = self:FindGO("CountLabel"):GetComponent(UILabel)
  self.fullCostGO = self:FindGO("FullCost")
  self.fullCostLabel = self:FindGO("FullCostLabel", self.fullCostGO):GetComponent(UILabel)
  self.costGO = self:FindGO("Cost")
  self.costIconGO = self:FindGO("CostIcon", self.costGO)
  local moneyIcon = self.costIconGO:GetComponent(UISprite)
  local moneyIconName = Table_Item[GameConfig.MoneyId.Zeny].Icon
  IconManager:SetItemIcon(moneyIconName, moneyIcon)
  self.costLabelGO = self:FindGO("CostLabel", self.costGO)
  self.costLabel = self.costLabelGO:GetComponent(UILabel)
  self.soldoutGO = self:FindGO("SoldoutLabel", self.costGO)
  self.toggleGO = self:FindGO("Toggle")
  self.toggle = self.toggleGO:GetComponent(UIToggle)
  self.isBulk = false
end

function SupplyDepotCell:SetData(data)
  if data then
    self.data = data
    local bought = not not data.bought
    self.maskGO:SetActive(bought)
    self.soldoutGO:SetActive(bought)
    self.costIconGO:SetActive(not bought)
    self.costLabelGO:SetActive(not bought)
    local item = Table_Item[data.goodsID or ""]
    if item then
      IconManager:SetItemIcon(item.Icon, self.itemIcon)
      self.titleLabel.text = item.NameZh
    end
    local count = data.goodsCount or 1
    self.countLabel.text = "x " .. tostring(count)
    local cost = data.ItemCount
    local finalCost = cost
    local discount = data.Discount or 100
    if 0 < discount and discount < 100 then
      self.fullCostGO:SetActive(true)
      self.discountGO:SetActive(true)
      finalCost = math.floor(cost * discount / 100)
      self.discountLabel.text = tostring(100 - discount) .. "%"
      self.fullCostLabel.text = string.format(ZhString.Shop_OriginPrice, StringUtil.NumThousandFormat(cost))
    else
      self.fullCostGO:SetActive(false)
      self.discountGO:SetActive(false)
    end
    self.costLabel.text = StringUtil.NumThousandFormat(finalCost)
  end
  self:UpdateByBulkReference()
end

function SupplyDepotCell:SetBulkMode(active)
  if self.data and self.data.bought then
    active = false
  end
  self.isBulk = active and true or false
  self:UpdateBulkMode()
end

function SupplyDepotCell:UpdateBulkMode()
  if not self.isBulk then
    self.toggle.value = false
  end
  self.toggleGO:SetActive(self.isBulk)
  self:UpdateByBulkReference()
end

function SupplyDepotCell:SetBulkReference(reference)
  self.bulkReference = reference
end

function SupplyDepotCell:UpdateByBulkReference()
  if not (self.isBulk and self.data) or not self.bulkReference then
    return
  end
  self.toggle.value = self.bulkReference[self.data.idx] and true or false
end
