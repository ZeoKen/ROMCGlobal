BattlePassExchangeCell = class("BattlePassExchangeCell", BaseCell)
BattlePassExchangeCell.LimitBuyDesc = {
  [HappyShopProxy.LimitType.OneDay] = ZhString.BattlePassExchangeView_LimitOneDay,
  [HappyShopProxy.LimitType.UserWeek] = ZhString.BattlePassExchangeView_LimitUserWeek,
  [HappyShopProxy.LimitType.AccUser] = ZhString.BattlePassExchangeView_LimitOneDay,
  [HappyShopProxy.LimitType.AccUserAlways] = ZhString.BattlePassExchangeView_LimitAccUser
}

function BattlePassExchangeCell:Init()
  BattlePassExchangeCell.super.Init(self)
  self:FindObjs()
end

function BattlePassExchangeCell:FindObjs()
  self.name = self:FindComponent("Lab", UILabel)
  self.select = self:FindGO("Select")
  self.soldout = self:FindGO("SoldOut")
  self.icon = self:FindComponent("Icon", UISprite)
  self.num = self:FindComponent("Num", UILabel)
  self.limit = self:FindComponent("LimitInfo", UILabel)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function BattlePassExchangeCell:SetData(data)
  self.goodsID = data
  self.shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(BattlePassProxy.Instance.CurrentBPConfig.ExchangeShopType, BattlePassProxy.Instance.CurrentBPConfig.ExchangeShopId, self.goodsID)
  self.itemID = self.shopItemData.goodsID
  self.itemConf = Table_Item[self.itemID]
  self.select:SetActive(false)
  IconManager:SetItemIcon(self.itemConf.Icon, self.icon)
  self.num.text = self.shopItemData.goodsCount and self.shopItemData.goodsCount > 1 and "x" .. self.shopItemData.goodsCount or ""
  self.name.text = self.itemConf.NameZh
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
  if limitType and canBuyCount then
    self.limit.text = string.format(self.LimitBuyDesc[limitType] or ZhString.BattlePassExchangeView_LimitDefault, canBuyCount)
  else
    self.limit.text = ""
  end
  if canBuyCount and canBuyCount == 0 then
    self.soldout:SetActive(true)
  else
    self.soldout:SetActive(false)
  end
end
