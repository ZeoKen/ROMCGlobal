local BaseCell = autoImport("BaseCell")
DisneyHappyGoodCell = class("DisneyHappyGoodCell", BaseCell)
local DisneyHappyValueShopType = GameConfig.HappyValue.ShopType or 20171
local DisneyHappyValueShopId = GameConfig.HappyValue.ShopId or 1

function DisneyHappyGoodCell:Init()
  DisneyHappyGoodCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DisneyHappyGoodCell:FindObjs()
  self.sprite = self.gameObject:GetComponent(UISprite)
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.itemCell = self:FindGO("ItemCell")
  self.itemIcon = self:FindGO("Icon", self.itemCell):GetComponent(UISprite)
  self.itemCount = self:FindGO("Count", self.itemCell):GetComponent(UILabel)
  self.choose = self:FindGO("Choose")
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.priceIcon = self:FindGO("CostIcon"):GetComponent(UISprite)
  self.priceLabel = self:FindGO("PriceLabel"):GetComponent(UILabel)
  self.soldOut = self:FindGO("Soldout")
  self.soldOutLabel = self.soldOut:GetComponent(UILabel)
  self.soldOutLabel.text = ZhString.HappyShop_SoldOut
end

function DisneyHappyGoodCell:SetData(data)
  self.data = data
  self.goodsID = data
  self.shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(DisneyHappyValueShopType, DisneyHappyValueShopId, self.goodsID)
  self.itemID = self.shopItemData.goodsID
  self.itemConf = Table_Item[self.itemID]
  IconManager:SetItemIcon(self.itemConf.Icon, self.itemIcon)
  self.itemName.text = self.itemConf.NameZh
  self.itemCount.text = self.shopItemData.goodsCount and self.shopItemData.goodsCount > 1 and self.shopItemData.goodsCount or ""
  local totalPrice = self.shopItemData:GetBuyDiscountPrice(self.shopItemData.ItemCount, 1)
  self.priceLabel.text = totalPrice
  local moneyId = GameConfig.HappyValue.ItemId or 165
  local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
  IconManager:SetItemIcon(icon, self.priceIcon)
  local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
  if canBuyCount <= 0 then
    self.sprite.alpha = 0.6
    self.soldOut:SetActive(true)
    self.boxCollider.enabled = false
  else
    self.sprite.alpha = 1
    self.soldOut:SetActive(false)
    self.boxCollider.enabled = true
  end
end

function DisneyHappyGoodCell:SetChoose(bool)
  self.choose:SetActive(bool)
end
