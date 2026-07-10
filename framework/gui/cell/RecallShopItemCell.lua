RecallShopItemCell = class("RecallShopItemCell", BaseCell)
autoImport("ItemCell")

function RecallShopItemCell:ctor(gameObject, parent, cellName)
  RecallShopItemCell.super.ctor(self, gameObject, parent, cellName)
  self:FindObjs()
  self:AddViewEvts()
end

function RecallShopItemCell:FindObjs()
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labProductNum = self:FindGO("Count", self.gameObject):GetComponent(UILabel)
  self.iconBg = self:FindGO("IconBG")
  self.u_spItemIcon = self:FindGO("Icon", self.iconBg):GetComponent(UISprite)
  self.u_itemPriceBtnBg = self:FindComponent("PriceBtn", UISprite)
  self.u_itemPriceBtnBc = self:FindComponent("PriceBtn", BoxCollider)
  self.u_itemPriceBtnBc.enabled = false
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.u_itemPriceBtnBg.gameObject)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_container = self:FindComponent("container", UIWidget)
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

function RecallShopItemCell:SetData(data)
  self.data = data
  if not data or not data.serverData then
    return
  end
  local serverData = data.serverData
  self:SetGoodsInfo(serverData)
  self:SetPriceInfo(serverData)
  self:SetBuyLimitInfo(serverData)
  self:SetMarks(serverData)
  self:CheckSoldOut(serverData)
end

function RecallShopItemCell:SetGoodsInfo(serverData)
  if not serverData.good or not serverData.good.id then
    redlog("RecallShopItemCell:SetGoodsInfo 服务器商品数据无效", TableUtil.Print(serverData.good))
    return
  end
  local goodsID = serverData.good.id
  local goodsCount = serverData.good.count or 1
  self.u_labProductNum.text = goodsCount
  local staticData = Table_Item[goodsID]
  if not staticData then
    redlog("RecallShopItemCell:SetGoodsInfo 找不到物品配置", goodsID)
    return
  end
  self.u_labProductName.text = staticData.NameZh
  if nil ~= Table_Card[goodsID] then
    self.u_spItemIcon.gameObject:SetActive(false)
    if not self.itemCell then
      local obj = self:LoadCellPfb("ItemCell")
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      obj.transform.localScale = LuaGeometry.GetTempVector3(0.9, 0.9, 1)
      self.itemCell = ItemCell.new(obj)
    end
    self:Show(self.itemCell)
    self.itemCell:SetData(ItemData.new("RecallShopItemCell", goodsID))
  else
    self.u_spItemIcon.gameObject:SetActive(true)
    IconManager:SetItemIcon(staticData.Icon, self.u_spItemIcon)
    self.u_spItemIcon:MakePixelPerfect()
    if self.itemCell then
      self:Hide(self.itemCell)
    end
  end
end

function RecallShopItemCell:SetPriceInfo(serverData)
  if not serverData.cost or #serverData.cost == 0 then
    redlog("RecallShopItemCell:SetPriceInfo 服务器价格数据无效", TableUtil.Print(serverData.cost))
    return
  end
  local costInfo = serverData.cost[1]
  local costItemId = costInfo.id
  local costAmount = costInfo.count
  if serverData.off and serverData.off < 100 then
    self.u_itemPrice.text = StringUtil.NumThousandFormat(costAmount * (serverData.off or 100) / 100)
  else
    self.u_itemPrice.text = StringUtil.NumThousandFormat(costAmount)
  end
  local costItemData = Table_Item[costItemId]
  if costItemData and costItemData.Icon then
    IconManager:SetItemIcon(costItemData.Icon, self.u_itemPriceIcon)
  end
  self.u_itemPriceIcon:ResetAndUpdateAnchors()
  self.u_itemOriPrice.gameObject:SetActive(false)
  if self.u_itemOriPrice then
    if serverData.off and serverData.off < 100 then
      self.u_itemOriPrice.gameObject:SetActive(true)
      self.u_itemOriPrice.text = string.format(ZhString.Shop_OriginPrice, FunctionNewRecharge.FormatMilComma(costAmount))
    else
      self.u_itemOriPrice.gameObject:SetActive(false)
    end
  end
end

function RecallShopItemCell:SetBuyLimitInfo(serverData)
  self.buyCountLimitLabel.gameObject:SetActive(false)
end

function RecallShopItemCell:GetBoughtCount(serverData)
  return serverData and serverData.bought_count or 0
end

function RecallShopItemCell:SetMarks(serverData)
  self.u_newMark:SetActive(false)
  if serverData.off and serverData.off < 100 then
    self.u_discountMark:SetActive(true)
    self.u_discountValue.text = serverData.off .. "%"
    Game.convert2OffLbl(self.u_discountValue)
  else
    self.u_discountMark:SetActive(false)
  end
  self.m_goSuperValue:SetActive(false)
  self:Set_DescMark(false, "")
  self:SetRedTip(serverData)
end

function RecallShopItemCell:Set_DescMark(isShow, desc)
  if self.u_desMark then
    self.u_desMark:SetActive(isShow)
    if isShow and self.u_desMarkText then
      self.u_desMarkText.text = desc or ""
    end
  end
end

function RecallShopItemCell:SetRedTip(serverData)
  if self.u_fxxk_redtip then
    self.u_fxxk_redtip:SetActive(false)
  end
end

function RecallShopItemCell:CheckSoldOut(serverData)
  local buyLimit = serverData.buy_limit or 0
  local boughtCount = serverData.bought_count or 0
  local isSoldOut = false
  if 0 < buyLimit then
    isSoldOut = buyLimit <= boughtCount
  end
  self.u_soldOutMark:SetActive(isSoldOut)
  local isInteractable = not isSoldOut
  self.u_itemPricePH:SetActive(not isSoldOut)
  self.isForbidPurchase = not isInteractable
end

function RecallShopItemCell:AddViewEvts()
  self:SetEvent(self.gameObject, function()
    if not self.isForbidPurchase then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function RecallShopItemCell:ShowItemTip()
  if self.data and self.data.serverData and self.data.serverData.good then
    local goodsID = self.data.serverData.good.id
    if goodsID then
      self:PassEvent(ItemTipEvent.ShowItemTip, goodsID)
    end
  end
end

function RecallShopItemCell:OnDestroy()
  RecallShopItemCell.super.OnDestroy(self)
  if self.itemCell then
    self:Hide(self.itemCell)
    self.itemCell = nil
  end
end
