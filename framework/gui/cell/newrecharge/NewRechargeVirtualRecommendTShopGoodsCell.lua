autoImport("NewRechargeRecommendTShopGoodsCell")
NewRechargeVirtualRecommendTShopGoodsCell = class("NewRechargeVirtualRecommendTShopGoodsCell", NewRechargeRecommendTShopGoodsCell)

function NewRechargeVirtualRecommendTShopGoodsCell:FindObjs()
end

function NewRechargeVirtualRecommendTShopGoodsCell:SetCell_Deposit()
end

function NewRechargeVirtualRecommendTShopGoodsCell:SetCell_Shop()
end

function NewRechargeVirtualRecommendTShopGoodsCell:RegisterClickEvent()
end

function NewRechargeVirtualRecommendTShopGoodsCell:OnReceivePurchaseSuccess(message)
  if self.data then
    NewRechargeVirtualRecommendTShopGoodsCell.super.OnReceivePurchaseSuccess(self, message)
  end
  if self.purchaseSuccessCB then
    self.purchaseSuccessCB()
    self.purchaseSuccessCB = nil
  end
end

function NewRechargeVirtualRecommendTShopGoodsCell:SetPurchaseSuccessCB(callback)
  self.purchaseSuccessCB = callback
end

function NewRechargeVirtualRecommendTShopGoodsCell:VirtualSetData(confType, ShopID)
  local data = {confType = confType, ShopID = ShopID}
  NewRechargeVirtualRecommendTShopGoodsCell.super.SetData(self, data)
end

function NewRechargeVirtualRecommendTShopGoodsCell:VirtualClearSetData()
  self.goodsType = nil
  self.data = nil
  self.purchaseSuccessCB = nil
end
