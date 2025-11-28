autoImport("NewRechargePrototypeGoodsCell")
NewRechargeNormalTShopGoodsCell = class("NewRechargeNormalTShopGoodsCell", NewRechargePrototypeGoodsCell)
local _ArrayPushBack = TableUtility.ArrayPushBack

function NewRechargeNormalTShopGoodsCell:FindObjs()
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labProductNum = self:FindGO("Count", self.gameObject):GetComponent(UILabel)
  self.u_spItemIcon = self:FindGO("Icon", self.gameObject):GetComponent(UISprite)
  self.u_itemPriceBtnBg = self:FindComponent("PriceBtn", UISprite)
  self.widgetList = {}
  _ArrayPushBack(self.widgetList, self.u_labProductName)
  _ArrayPushBack(self.widgetList, self.u_labProductNum)
  _ArrayPushBack(self.widgetList, self.u_spItemIcon)
  _ArrayPushBack(self.widgetList, self.u_itemPriceBtnBg)
  _ArrayPushBack(self.widgetList, self:FindComponent("uiImgTitleBg", UISprite))
  self.u_itemPriceBtnBc = self:FindComponent("PriceBtn", BoxCollider)
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.u_itemPriceBtnBg.gameObject)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_container = self:FindComponent("container", UIWidget)
  self.u_desMark = self:FindGO("DesMark", self.gameObject)
  self.u_desMarkText = self:FindComponent("Des", UILabel, self.u_desMark)
  _ArrayPushBack(self.widgetList, self.u_desMarkText)
  self.u_soldOutMark = self:FindGO("SoldOutMark", self.gameObject)
  self.u_discountMark = self:FindGO("DiscountMark", self.gameObject)
  self.u_discountValue = self:FindComponent("Value1", UILabel, self.u_discountMark)
  _ArrayPushBack(self.widgetList, self.u_discountValue)
  self.u_discountBG = self:FindComponent("BG", UISprite, self.u_discountMark)
  if self.u_discountBG then
    _ArrayPushBack(self.widgetList, self.u_discountBG)
  end
  self.u_newMark = self:FindGO("NewMark", self.gameObject)
  local u_newMarkText = self:FindComponent("markLab", UILabel, self.u_newMark)
  if u_newMarkText then
    u_newMarkText.text = ZhString.HappyShop_NewMark
  end
  self.u_fxxk_redtip = self:FindGO("RedTipCell", self.gameObject)
  if self.u_fxxk_redtip then
    self.u_sp_fxxk_redtip = self.u_fxxk_redtip:GetComponent(UIWidget)
  end
  self.u_buyBtn = self:FindGO("PriceBtn", self.gameObject)
  self.m_goSuperValue = self:FindGO("SuperValueMark", self.gameObject)
  self.m_uiTxtSuperValueNum = self:FindComponent("Value1", UILabel, self.m_goSuperValue)
  _ArrayPushBack(self.widgetList, self.m_uiTxtSuperValueNum)
  _ArrayPushBack(self.widgetList, self:FindComponent("BG", UISprite, self.m_goSuperValue))
  _ArrayPushBack(self.widgetList, self:FindComponent("SaleIcon", UISprite, self.m_goSuperValue))
end

function NewRechargeNormalTShopGoodsCell:SetAlpha(a)
  for k, v in pairs(self.widgetList) do
    v.alpha = a
  end
end

function NewRechargeNormalTShopGoodsCell:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:Purchase()
  end)
  self:AddClickEvent(self.u_spItemIcon.gameObject, function()
    self:OnClickForViewGoodsItem()
  end)
end

function NewRechargeNormalTShopGoodsCell:SetData(data)
  NewRechargeNormalTShopGoodsCell.super.SetData(self, data)
end

function NewRechargeNormalTShopGoodsCell:SetData_Shop()
  self.info = NewRechargeProxy.Ins:GenerateShopGoodsInfo(self.data.ShopID)
  self.shopGoodsInfo = self.info
end

function NewRechargeNormalTShopGoodsCell:SetCell()
  NewRechargeNormalTShopGoodsCell.super.SetCell(self)
  if self.data.Icon then
  end
  if self.data.Picture then
    if not IconManager:SetZenyShopItem(self.data.Picture, self.u_spItemIcon) then
      IconManager:SetItemIcon(self.data.Picture, self.u_spItemIcon)
    end
    self.u_spItemIcon:MakePixelPerfect()
    if self.data.IconScale then
      self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(self.data.IconScale, self.data.IconScale, self.data.IconScale)
    else
      self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
    end
  end
end

function NewRechargeNormalTShopGoodsCell:SetCell_Shop()
  if self.info.itemConf == nil then
    redlog("Good Is Nil:", self.info.itemID)
    return
  end
  IconManager:SetItemIcon(self.info.itemConf.Icon, self.u_spItemIcon)
  self.u_labProductNum.text = self.info.shopItemData.goodsCount
  self.u_labProductName.text = self.info.itemConf.NameZh
  self.u_itemPrice.text = FunctionNewRecharge.FormatMilComma(self.info:GetCurPrice())
  local limitCanBuyCount = self.info:GetLimitCanBuyCount()
  local isSaleOut = limitCanBuyCount and limitCanBuyCount <= 0 or false
  self:Set_SoldOutMark(isSaleOut)
  self:SetAlpha(isSaleOut and 0.5 or 1)
  self:Set_NewMark(self.info:IsNewAdd())
  local desc = self.info.shopItemData.extraDes
  self:Set_DescMark(not StringUtil.IsEmpty(desc), desc)
  local moneyItem = Table_Item[self.info.shopItemData.ItemID]
  if moneyItem and moneyItem.Icon and not isSaleOut then
    IconManager:SetItemIcon(moneyItem.Icon, self.u_itemPriceIcon)
  end
  self.u_itemPrice.alpha = isSaleOut and 0 or 1
  self.u_itemPriceIcon.alpha = isSaleOut and 0 or 1
  if not isSaleOut then
    self.u_itemPriceIcon:ResetAndUpdateAnchors()
  end
  local actDiscountLeftCount = not limitCanBuyCount and self.info.shopItemData:GetActDiscountCanBuyCount()
  local hasDisCount = self.info:GetDisCount() < 100 and (not actDiscountLeftCount or actDiscountLeftCount ~= 0)
  local oriPrice = self.info:GetOriPrice()
  if hasDisCount then
    self:Set_DiscountMark(true, oriPrice, self.info:GetCurPrice(), true)
  else
    self:Set_DiscountMark(false, oriPrice)
  end
  self:isShowSuperValue(self.data.SuperValue)
end

function NewRechargeNormalTShopGoodsCell:Purchase_Shop()
  self.info.shopItemData.m_checkFunc = nil
  self.info.shopItemData.m_checkTable = nil
  self:PassEvent(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, {
    info = self.info.shopItemData
  })
end

function NewRechargeNormalTShopGoodsCell:OnClickForViewGoodsItem()
  local itemConfID = self.info.itemID
  if itemConfID ~= nil then
    self:PassEvent(NewRechargeEvent.GoodsCell_ShowTip, itemConfID)
  end
end

function NewRechargeNormalTShopGoodsCell:IsHaveEnoughCostForBuy()
  local bCatGold = MyselfProxy.Instance:GetLottery()
  if bCatGold < self.info:GetCurPrice() then
    MsgManager.ShowMsgByID(3634)
    return false
  else
    return true
  end
end
