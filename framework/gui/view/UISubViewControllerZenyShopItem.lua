autoImport("UIModelZenyShop")
autoImport("UIListItemControllerItemSale")
autoImport("HappyShopBuyItemCell")
UISubViewControllerZenyShopItem = class("UISubViewControllerZenyShopItem", SubView)
UISubViewControllerZenyShopItem.instance = nil
local goPurchaseDetailLocalPosX, goPurchaseDetailLocalPosY = -421, -16

function UISubViewControllerZenyShopItem:Init()
end

function UISubViewControllerZenyShopItem:OnExit()
  UISubViewControllerZenyShopItem.super.OnExit(self)
  UISubViewControllerZenyShopItem.instance = nil
  if self.puchaseDetailCtrl ~= nil then
    self.puchaseDetailCtrl:Exit()
  end
  self:CancelListenServerResponse()
end

function UISubViewControllerZenyShopItem:MyInit()
  UISubViewControllerZenyShopItem.instance = self
  self.gameObject = self:LoadPreferb("view/UISubViewZenyShopItem", nil, true)
  self:GetGameObjects()
  self:SetActivePurchaseDetail(false)
  self:GetModelSet()
  self:LoadView()
  self:ListenServerResponse()
  HappyShopProxy.Instance:InitShop(nil, UIModelZenyShop.ItemShopID, UIModelZenyShop.ItemShopType)
  self.isInit = true
end

function UISubViewControllerZenyShopItem:ReInit()
  self:SetActivePurchaseDetail(false)
end

function UISubViewControllerZenyShopItem:GetGameObjects()
  self.goItemsList = self:FindGO("ItemsList")
  self.uiGridItem = self:FindGO("ItemsRoot", self.goItemsList):GetComponent(UIGrid)
  self.widgetTipRelative = self:FindGO("TipRelative"):GetComponent(UIWidget)
  self.goPurchaseDetail = self:LoadPreferb("cell/HappyShopBuyItemCell", self.gameObject, true)
  self.goPurchaseDetail.transform.localPosition = LuaGeometry.GetTempVector3(goPurchaseDetailLocalPosX, goPurchaseDetailLocalPosY)
end

function UISubViewControllerZenyShopItem:GetModelSet()
  self.shopItemDatas = UIModelZenyShop.Ins():GetItemShopConf()
  if self.arrShopItemData == nil then
    self.arrShopItemData = {}
  end
  TableUtility.ArrayClear(self.arrShopItemData)
  for k, v in pairs(self.shopItemDatas) do
    table.insert(self.arrShopItemData, v)
  end
  table.sort(self.arrShopItemData, function(x, y)
    return x.ShopOrder < y.ShopOrder
  end)
end

function UISubViewControllerZenyShopItem:LoadView()
  if self.itemListCtrl == nil then
    self.itemListCtrl = UIGridListCtrl.new(self.uiGridItem, UIListItemControllerItemSale, "UIListItemItemSale")
  end
  self.itemListCtrl:ResetDatas(self.arrShopItemData)
end

function UISubViewControllerZenyShopItem:LoadPurchaseDetailView(shop_item_data)
  self:SetActivePurchaseDetail(true)
  TipManager.CloseTip()
  if self.puchaseDetailCtrl == nil then
    self.puchaseDetailCtrl = HappyShopBuyItemCell.new(self.goPurchaseDetail)
    self.puchaseDetailCtrl:AddEventListener(ItemTipEvent.ClickItemUrl, self.ClickDetailCtrlItemUrl, self)
    self.puchaseDetailCtrlCloseComp = self.puchaseDetailCtrl.gameObject:GetComponent(CloseWhenClickOtherPlace)
  end
  self.puchaseDetailCtrl:SetData(shop_item_data)
end

function UISubViewControllerZenyShopItem:ListenServerResponse()
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnReceiveItemGetCount, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
end

function UISubViewControllerZenyShopItem:CancelListenServerResponse()
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnReceiveItemGetCount, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
end

function UISubViewControllerZenyShopItem:OnReceiveQueryShopConfigCmd(message)
  self:GetModelSet()
  self:LoadView()
end

function UISubViewControllerZenyShopItem:OnReceiveItemGetCount(data)
  if data and self.puchaseDetailCtrl ~= nil then
    self.puchaseDetailCtrl:SetItemGetCount(data.data)
  end
end

local itemClickUrlTipData = {}

function UISubViewControllerZenyShopItem:ClickDetailCtrlItemUrl(id)
  if not next(itemClickUrlTipData) then
    itemClickUrlTipData.itemdata = ItemData.new()
  end
  itemClickUrlTipData.itemdata:ResetData("itemClickUrl", id)
  
  function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
    TipManager.Instance:CloseTip()
    itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
    self:ShowClickItemUrlTip(itemClickUrlTipData)
  end
  
  self:ShowClickItemUrlTip(itemClickUrlTipData)
end

local clickItemUrlTipOffset = {270, 0}

function UISubViewControllerZenyShopItem:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, UISubViewControllerZenyShopItem.instance.widgetTipRelative, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip and self.puchaseDetailCtrl then
    tip:AddIgnoreBounds(self.puchaseDetailCtrl.gameObject)
    self.puchaseDetailCtrlCloseComp:AddTarget(tip.gameObject.transform)
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
    tip:AddEventListener(ItemTipEvent.ShowGetPath, self.OnTipGetPathShow, self)
    tip:AddEventListener(GainWayTip.CloseGainWay, self.OnTipGetPathClose, self)
  end
end

function UISubViewControllerZenyShopItem:OnTipFashionPreviewShow(preview)
  self.puchaseDetailCtrlCloseComp:AddTarget(preview.gameObject.transform)
end

function UISubViewControllerZenyShopItem:OnTipFashionPreviewClose()
  self.puchaseDetailCtrlCloseComp:ReCalculateBound()
end

function UISubViewControllerZenyShopItem:OnTipGetPathShow(gainWayTip)
  self:SetActivePurchaseDetail(false)
  local tip = TipsView.Me().currentTip
  if tip then
    local trans = tip.gameObject.transform
    local v = LuaGeometry.TempGetLocalPosition(trans)
    v.x = goPurchaseDetailLocalPosX
    trans.localPosition = v
  end
end

function UISubViewControllerZenyShopItem:OnTipGetPathClose()
end

function UISubViewControllerZenyShopItem:OnReceiveUpdateShopGotItem(data)
  self:GetModelSet()
  self:LoadView()
end

function UISubViewControllerZenyShopItem:SetActivePurchaseDetail(b)
  self.goPurchaseDetail:SetActive(b)
end
