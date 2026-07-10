autoImport("NewRechargeNormalTShopGoodsCell")
autoImport("NewRechargeShopGoodsData")
ActivityIntegrationLotteryRaidShopGoodsCell = class("ActivityIntegrationLotteryRaidShopGoodsCell", NewRechargeNormalTShopGoodsCell)

function ActivityIntegrationLotteryRaidShopGoodsCell:FindObjs()
  ActivityIntegrationLotteryRaidShopGoodsCell.super.FindObjs(self)
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.gameObject)
  self.bgSprite = self:FindComponent("BgSprite", UIMultiSprite, self.gameObject)
end

function ActivityIntegrationLotteryRaidShopGoodsCell:SetData_Shop()
  local shopItemData = self.data and self.data.shopItemData
  if not shopItemData and self.data and self.data.shopType and self.data.shopId and self.data.ShopID then
    shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(self.data.shopType, self.data.shopId, self.data.ShopID)
  end
  if not shopItemData then
    self.info = {
      itemConf = nil,
      itemID = self.data and self.data.ShopID
    }
    self.shopGoodsInfo = self.info
    return
  end
  local itemID = shopItemData.goodsID
  if not itemID or not Table_Item[itemID] then
    self.info = {
      itemConf = nil,
      itemID = itemID,
      shopItemData = shopItemData
    }
    self.shopGoodsInfo = self.info
    return
  end
  if not self.info or not self.info.ResetData then
    self.info = NewRechargeShopGoodsData.new()
  end
  self.info:ResetData(shopItemData)
  self.shopGoodsInfo = self.info
end

function ActivityIntegrationLotteryRaidShopGoodsCell:SetCell()
  ActivityIntegrationLotteryRaidShopGoodsCell.super.SetCell(self)
  self:UpdateKeyShow()
end

function ActivityIntegrationLotteryRaidShopGoodsCell:UpdateKeyShow()
  if self.bgSprite then
    local state = self.data and self.data.KeyShow == 1 and 1 or 0
    self.bgSprite.CurrentState = state
  end
end

function ActivityIntegrationLotteryRaidShopGoodsCell:Purchase_Shop()
  if not self.info or not self.info.shopItemData then
    return
  end
  ActivityIntegrationLotteryRaidShopGoodsCell.super.Purchase_Shop(self)
end
