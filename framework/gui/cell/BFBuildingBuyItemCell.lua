autoImport("HappyShopBuyItemCell")
BFBuildingBuyItemCell = class("BFBuildingBuyItemCell", HappyShopBuyItemCell)

function BFBuildingBuyItemCell:RealConfirm()
  if BagProxy.Instance:CheckBagIsFull(BagProxy.BagType.MainBag) then
    MsgManager.ShowMsgByID(989)
    return
  end
  BFBuildingBuyItemCell.super.RealConfirm(self)
end
