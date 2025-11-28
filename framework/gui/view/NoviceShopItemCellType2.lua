autoImport("NoviceShopItemCell")
NoviceShopItemCellType2 = class("NoviceShopItemCellType2", NoviceShopItemCell)
NoviceShopItemCellType2.depositSprite = "mall_bg_07"
NoviceShopItemCellType2.shopSprite = "mall_bg_07"

function NoviceShopItemCellType2:Init()
  NoviceShopItemCellType2.super.Init(self)
  self.soldOutLabel = self:FindGO("SoldOutLabel"):GetComponent(UILabel)
end

function NoviceShopItemCellType2:SetData(data)
  NoviceShopItemCellType2.super.SetData(self, data)
  if data then
    self.soldOutLabel.gameObject:SetActive(self.leftCount <= 0)
    self.pricePos:SetActive(self.leftCount > 0)
  end
end
