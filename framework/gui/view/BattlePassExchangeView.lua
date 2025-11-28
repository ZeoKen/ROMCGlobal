autoImport("BattlePassExchangeCell")
BattlePassExchangeView = class("BattlePassExchangeView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("BattlePassExchangeView")

function BattlePassExchangeView:LoadSubView()
  local container = self:FindGO("exchangeViewPos")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "BattlePassExchangeView"
  self.gameObject = obj
end

function BattlePassExchangeView:Init()
  self:LoadSubView()
  self:InitView()
end

function BattlePassExchangeView:InitView()
  self.coinIcon = self:FindComponent("coinIcon", UISprite)
  self.coinNum = self:FindComponent("coinNum", UILabel)
  self.buyBtn = self:FindGO("buyBtn")
  self.buyUIButton = self.buyBtn:GetComponent(BoxCollider)
  self.priceIcon = self:FindComponent("priceIcon", UISprite)
  self.priceNum = self:FindComponent("priceNum", UILabel)
  self:AddClickEvent(self.buyBtn, function()
    self:BuyItem()
  end)
  self.ecellsv = self:FindComponent("ExchangeScrollView", UIScrollView)
  self.ecellgrid = self:FindComponent("ExchangeGrid", UIGrid)
  self.ecellListCtl = UIGridListCtrl.new(self.ecellgrid, BattlePassExchangeCell, "BattlePassExchangeCell")
  self.ecellListCtl:AddEventListener(MouseEvent.MouseClick, self.SelectBuyItem, self)
end

function BattlePassExchangeView:UpdateCoinInfo()
  local itemId = BattlePassProxy.Instance.BattlePassCoin
  local itemIcon = Table_Item[itemId] and Table_Item[itemId].Icon or ""
  IconManager:SetItemIcon(itemIcon, self.coinIcon)
  self.coinNum.text = HappyShopProxy.Instance:GetItemNum(itemId)
end

function BattlePassExchangeView:UpdateExchangeShop()
  if self.exchangeList then
    TableUtility.ArrayClear(self.exchangeList)
  else
    self.exchangeList = {}
  end
  local shopId, shopType = BattlePassProxy.Instance.CurrentBPConfig.ExchangeShopId, BattlePassProxy.Instance.CurrentBPConfig.ExchangeShopType
  HappyShopProxy.Instance:InitShop(nil, shopId, shopType)
  local goods = ShopProxy.Instance:GetConfigByTypeId(shopType, shopId)
  for id, _ in pairs(goods) do
    TableUtility.InsertSort(self.exchangeList, id, function(a, b)
      return goods[a].ShopOrder > goods[b].ShopOrder
    end)
  end
  self.ecellListCtl:ResetDatas(self.exchangeList)
  self:SelectBuyItem(self.selectItem)
end

function BattlePassExchangeView:SelectBuyItem(data)
  self.selectItem = data
  if not data then
    self.selectExchangeItem = nil
    self.buyBtn:SetActive(false)
    return
  end
  self.selectExchangeItem = data.goodsID
  EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
    type = "item",
    data = {
      itemid = data.itemID
    }
  })
  self.buyBtn:SetActive(true)
  if self:IsThisShopItemHaveSoldOut(data.shopItemData) then
    self.buyUIButton.enabled = false
    self:SetTextureGrey(self.buyBtn)
  else
    self.buyUIButton.enabled = true
    self:SetTextureWhite(self.buyBtn, ColorUtil.ButtonLabelOrange)
  end
  local priceId = data.shopItemData.ItemID
  local priceNum = data.shopItemData.ItemCount
  IconManager:SetItemIcon(Table_Item[priceId] and Table_Item[priceId].Icon or "", self.priceIcon)
  self.priceNum.text = priceNum
end

function BattlePassExchangeView:IsThisShopItemHaveSoldOut(goodData)
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(goodData)
  if canBuyCount and goodData.LimitNum and canBuyCount == 0 then
    return true
  end
  return false
end

function BattlePassExchangeView:BuyItem()
  local isBuy = HappyShopProxy.Instance:BuyItem(self.selectExchangeItem, 1, true)
end

function BattlePassExchangeView:OnEnter()
  BattlePassExchangeView.super.OnEnter(self)
  ShopProxy.Instance:CallQueryShopConfig(BattlePassProxy.Instance.CurrentBPConfig.ExchangeShopType, BattlePassProxy.Instance.CurrentBPConfig.ExchangeShopId)
  self:UpdateCoinInfo()
  self:UpdateExchangeShop()
end
