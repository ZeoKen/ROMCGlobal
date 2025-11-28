NewRechargeShopItemCtrl = class("NewRechargeShopItemCtrl")

function NewRechargeShopItemCtrl:Ins()
  if NewRechargeShopItemCtrl.ins == nil then
    NewRechargeShopItemCtrl.ins = NewRechargeShopItemCtrl.new()
  end
  return NewRechargeShopItemCtrl.ins
end

function NewRechargeShopItemCtrl:ctor()
end

function NewRechargeShopItemCtrl:RequestQueryShopItem(shop_type, shop_id)
  ShopProxy.Instance:CallQueryShopConfig(shop_type, shop_id)
end

NewRechargeShopItemCtrl.ItemShopType = 650
NewRechargeShopItemCtrl.ItemShopID = 1

function NewRechargeShopItemCtrl:GetItemShopConf()
  return ShopProxy.Instance:GetConfigByTypeId(NewRechargeShopItemCtrl.ItemShopType, NewRechargeShopItemCtrl.ItemShopID)
end

NewRechargeShopItemCtrl.DailyOneZenyRedTipID = 10600

function NewRechargeShopItemCtrl:UpdateOneZenyGoodsBuyInfo()
end
