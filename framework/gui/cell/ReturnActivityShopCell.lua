local BaseCell = autoImport("BaseCell")
ReturnActivityShopCell = class("ReturnActivityShopCell", BaseCell)

function ReturnActivityShopCell:Init()
  ReturnActivityShopCell.super.Init(self)
  self:FindObjs()
  self:RegisterClickEvent()
  self:Func_AddListenEvent()
end

function ReturnActivityShopCell:FindObjs()
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labProductNum = self:FindGO("Count", self.gameObject):GetComponent(UILabel)
  self.u_spItemIcon = self:FindGO("Icon", self.gameObject):GetComponent(UISprite)
  self.u_itemPriceBtnBg = self:FindComponent("PriceBtn", UISprite)
  self.u_itemPriceBtnBc = self:FindComponent("PriceBtn", BoxCollider)
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.u_itemPriceBtnBg.gameObject)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_container = self.gameObject:GetComponent(UIWidget)
  self.u_desMark = self:FindGO("DesMark", self.gameObject)
  self.u_desMarkText = self:FindComponent("Des", UILabel, self.u_desMark)
  self.u_soldOutMark = self:FindGO("SoldOutMark", self.gameObject)
  self.u_discountMark = self:FindGO("DiscountMark", self.gameObject)
  self.u_discountValue = self:FindComponent("Value1", UILabel, self.u_discountMark)
  self.u_discountBG = self:FindComponent("BG", UISprite, self.u_discountMark)
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
  self.buyCountLimitLabel = self:FindGO("BuyCountLimitLabel"):GetComponent(UILabel)
  self.m_goSuperValue = self:FindGO("SuperValueMark", self.gameObject)
  self.m_uiTxtSuperValueNum = self:FindComponent("Value1", UILabel, self.m_goSuperValue)
end

function ReturnActivityShopCell:SetData(data)
  self.data = data
  self.isForbidPurchase = nil
  self.m_goSuperValue.gameObject:SetActive(false)
  if data.depositID then
    self:UpdateDepositItem()
  else
    self:UpdateShopItem()
  end
end

function ReturnActivityShopCell:UpdateShopItem()
  local data = self.data
  local goodsID = self.data.goodsID
  local staticData = Table_Item[goodsID]
  if not staticData then
    return
  end
  local _HappyShopProxy = HappyShopProxy.Instance
  IconManager:SetItemIcon(staticData.Icon, self.u_spItemIcon)
  self.u_spItemIcon:MakePixelPerfect()
  self.u_spItemIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  self.u_labProductNum.text = data.goodsCount
  self.u_labProductName.text = staticData.NameZh
  self.u_itemPrice.text = StringUtil.NumThousandFormat(data.ItemCount)
  local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(data)
  local isSaleOut = canBuyCount and canBuyCount <= 0 or false
  self.u_soldOutMark:SetActive(isSaleOut)
  self.u_itemPriceBtnBg.gameObject:SetActive(not isSaleOut)
  self.u_container.alpha = isSaleOut and 0.4 or 1
  self.u_itemPriceIcon.gameObject:SetActive(true)
  local moneyItem = Table_Item[data.ItemID]
  if moneyItem and moneyItem.Icon and not isSaleOut then
    IconManager:SetItemIcon(moneyItem.Icon, self.u_itemPriceIcon)
  end
  self.u_itemPriceIcon:ResetAndUpdateAnchors()
  local offset_x = (32 + self.u_itemPrice.printedSize.x) / 2 - self.u_itemPrice.printedSize.x
  self.u_itemPrice.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offset_x, 0, 0)
  self.u_itemPriceIcon.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offset_x, 0, 0)
  self.u_itemPricePH:SetActive(not isSaleOut)
  local maxLimit = data.LimitNum
  local canBuyCount = _HappyShopProxy:GetCanBuyCount(data)
  self.buyCountLimitLabel.gameObject:SetActive(canBuyCount ~= nil)
  if canBuyCount ~= nil then
    local str = string.format(ZhString.NewRecharge_BuyLimit_Acc_Ever, maxLimit - canBuyCount, maxLimit)
    self.buyCountLimitLabel.text = str
  end
  local oriPrice = data.ItemCount
  if data.changeCost then
    local curCount = data.sum_count or 0
    oriPrice = data:GetChangeCost(curCount + 1)
  end
  local discount = data.Discount or 100
  local actDiscountLeftCount = data:GetActDiscountCanBuyCount()
  local hasDiscount = discount < 100 and (not actDiscountLeftCount or actDiscountLeftCount ~= 0)
  if hasDiscount then
    self:Set_DiscountMark(true, oriPrice, math.floor(oriPrice * discount / 100), true)
  else
    self:Set_DiscountMark(false, oriPrice)
  end
  for k, v in pairs(Table_ShopShow) do
    if v.ShopID == data.id then
      local superValue = v.SuperValue
      if superValue then
        self.m_goSuperValue.gameObject:SetActive(true)
        self.m_uiTxtSuperValueNum.text = superValue .. "%"
      else
        self.m_goSuperValue.gameObject:SetActive(false)
      end
      if v.Picture then
        if not IconManager:SetZenyShopItem(v.Picture, self.u_spItemIcon) then
          IconManager:SetItemIcon(v.Picture, self.u_spItemIcon)
        end
        self.u_spItemIcon:MakePixelPerfect()
        if v.IconScale then
          self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(v.IconScale, v.IconScale, v.IconScale)
          break
        end
        self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
      end
      break
    end
  end
end

function ReturnActivityShopCell:UpdateDepositItem()
  self:Set_DiscountMark(false)
  local data = self.data
  local depositID = data.depositID
  local depositConfig = depositID and Table_Deposit[depositID]
  local info = data.info
  local itemID = info.productConf.ItemId
  local itemData = Table_Item[itemID]
  IconManager:SetItemIcon(itemData and itemData.Icon, self.u_spItemIcon)
  self.u_spItemIcon:MakePixelPerfect()
  self.u_spItemIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  self.u_labProductName.text = itemData.NameZh
  self.u_labProductNum.text = ""
  self.u_itemPrice.text = info.productConf.priceStr or info.productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(info.productConf.Rmb)
  local purchasedTimes, purchaseLimitTimes
  purchasedTimes = info.purchaseTimes or 0
  purchaseLimitTimes = info.purchaseLimit_N or 0
  local formatString = info.purchaseLimitStr
  if 9999 <= purchaseLimitTimes or purchaseLimitTimes <= 0 or not formatString then
    self:Set_BuyTimesMark(false)
  else
    self:Set_BuyTimesMark(true, string.format(formatString, purchasedTimes, purchaseLimitTimes))
  end
  self.u_itemPriceIcon.gameObject:SetActive(false)
  self.u_itemPriceIcon:ResetAndUpdateAnchors()
  if info.purchaseTimes ~= nil and 0 < info.purchaseLimit_N and info.purchaseTimes >= info.purchaseLimit_N then
    self.isForbidPurchase = true
  end
  local isSaleOut = info:IsSoldOut()
  self.u_soldOutMark:SetActive(isSaleOut)
  self.u_itemPriceBtnBg.gameObject:SetActive(not isSaleOut)
  self.u_container.alpha = isSaleOut and 0.4 or 1
  for k, v in pairs(Table_ShopShow) do
    if v.ShopID == depositID then
      local superValue = v.SuperValue
      if superValue then
        self.m_goSuperValue.gameObject:SetActive(true)
        self.m_uiTxtSuperValueNum.text = superValue .. "%"
        break
      end
      self.m_goSuperValue.gameObject:SetActive(false)
      break
    end
  end
end

function ReturnActivityShopCell:Set_BuyTimesMark(active, buy_times)
  if not self.buyCountLimitLabel then
    return
  end
  self.buyCountLimitLabel.gameObject:SetActive(active)
  self.buyCountLimitLabel.text = buy_times or ""
end

function ReturnActivityShopCell:Set_DiscountMark(active, oriPrice, curPrice, showDiscount, priceCurrencyPrefix)
  if not self.u_itemPrice then
    return
  end
  if not self.u_itemOriPrice then
    return
  end
  priceCurrencyPrefix = priceCurrencyPrefix or ""
  if active then
    if oriPrice then
      self.u_itemOriPrice.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(oriPrice)
    end
    if curPrice then
      self.u_itemPrice.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(curPrice)
    end
  elseif oriPrice then
    self.u_itemPrice.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(oriPrice)
  end
  self.u_itemOriPrice.gameObject:SetActive(active)
  if self.u_discountMark then
    self.u_discountMark:SetActive(showDiscount == true and active == true)
    if showDiscount and active and oriPrice and curPrice then
      local discount = math.ceil(curPrice / oriPrice * 100)
      self.u_discountValue.text = discount .. "%"
      Game.convert2OffLbl(self.u_discountValue)
    end
  end
end

function ReturnActivityShopCell:Func_AddListenEvent()
end

function ReturnActivityShopCell:RegisterClickEvent()
  self:SetEvent(self.gameObject, function()
    if not self.isForbidPurchase then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function ReturnActivityShopCell:OnClickForViewGoodsItem()
  local itemConfID = self.info.itemID
  if itemConfID ~= nil then
    self:PassEvent(NewRechargeEvent.GoodsCell_ShowTip, itemConfID)
  end
end

function ReturnActivityShopCell:Purchase()
  self:PassEvent(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, {
    info = self.info.shopItemData
  })
end
