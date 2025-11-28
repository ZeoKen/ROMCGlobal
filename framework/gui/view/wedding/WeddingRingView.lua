autoImport("HappyShop")
autoImport("WeddingRingBuyCell")
WeddingRingView = class("WeddingRingView", HappyShop)
WeddingRingView.ViewType = HappyShop.ViewType

function WeddingRingView:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end

function WeddingRingView:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = WeddingRingBuyCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
end
