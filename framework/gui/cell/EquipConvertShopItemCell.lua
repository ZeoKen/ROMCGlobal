autoImport("ShopItemCell")
EquipConvertShopItemCell = class("EquipConvertShopItemCell", ShopItemCell)

function EquipConvertShopItemCell:SetData(data)
  EquipConvertShopItemCell.super.SetData(self, data)
  data = self:GetShopItemData(data)
  if data then
    local itemData = data:GetItemData()
    self.buyCondition.text = ItemUtil.GetItemTypeName(itemData.staticData)
  end
end
