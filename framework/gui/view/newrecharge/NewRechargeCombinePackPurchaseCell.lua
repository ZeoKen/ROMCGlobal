autoImport("NewRechargeCombinePackPurchaseItemCell")
NewRechargeCombinePackPurchaseCell = class("NewRechargeCombinePackPurchaseCell", NewRechargeCombinePackCell)

function NewRechargeCombinePackPurchaseCell:FindObjs()
  self.u_spBg = self:FindGO("BG", self.gameObject):GetComponent(UISprite)
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labContent = self:FindGO("ContentLb", self.gameObject):GetComponent(UILabel)
  self.u_buyBtnGrid = self:FindComponent("Grid", UIGrid)
  self.u_buyCurrent = self:FindGO("BuyCurrent")
  self.u_buyBtn_current = self:FindGO("PriceBtn", self.u_buyCurrent.gameObject)
  self.u_buyBtnSp_current = self.u_buyBtn_current:GetComponent(UIMultiSprite)
  self.u_buyBtnBc_current = self.u_buyBtn_current:GetComponent(BoxCollider)
  self.u_itemOriPrice_current = self:FindComponent("OriPrice", UILabel, self.u_buyCurrent.gameObject)
  self.u_itemPrice_current = self:FindComponent("Price", UILabel, self.u_buyCurrent.gameObject)
  self.u_itemPriceIcon_current = self:FindComponent("PriceIcon", UISprite, self.u_buyCurrent.gameObject)
  self.u_discountMark_current = self:FindGO("DiscountMark", self.u_buyCurrent.gameObject)
  self.u_discountValue_current = self:FindComponent("Value1", UILabel, self.u_discountMark_current)
  self.u_itemPriceText_current = self:FindComponent("PriceText", UILabel, self.u_buyCurrent.gameObject)
  self.u_buyFull = self:FindGO("BuyFull")
  self.u_buyBtn_full = self:FindGO("PriceBtn", self.u_buyFull.gameObject)
  self.u_itemOriPrice_full = self:FindComponent("OriPrice", UILabel, self.u_buyFull.gameObject)
  self.u_itemPrice_full = self:FindComponent("Price", UILabel, self.u_buyFull.gameObject)
  self.u_itemPriceIcon_full = self:FindComponent("PriceIcon", UISprite, self.u_buyFull.gameObject)
  self.u_discountMark_full = self:FindGO("DiscountMark", self.u_buyFull.gameObject)
  self.u_discountValue_full = self:FindComponent("Value1", UILabel, self.u_discountMark_full)
  self.u_instBtn = self:FindGO("InstBtn", self.gameObject)
  self.u_itemListContainer = self:FindComponent("Items", UIGrid)
  self.u_itemListCtrl = UIGridListCtrl.new(self.u_itemListContainer, NewRechargeCombinePackPurchaseItemCell, "NewRechargeCombinePackPurchaseItemCell")
  self.u_itemListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_Toggle, self.OnPackSelection, self)
  self.u_closeBtn = self:FindGO("CloseButton", self.gameObject)
end

function NewRechargeCombinePackPurchaseCell:RegisterClickEvent()
  self:RegistShowGeneralHelpByHelpID(1202, self.u_instBtn)
  self:AddClickEvent(self.u_closeBtn, function()
    self.gameObject:SetActive(false)
    self:OnExit()
  end)
  self:AddClickEvent(self.u_buyBtn_current, function()
    self:Pre_Purchase()
  end)
  self:AddClickEvent(self.u_buyBtn_full, function()
    self:Pre_Purchase(true)
  end)
end

function NewRechargeCombinePackPurchaseCell:SetLeftTime()
end

function NewRechargeCombinePackPurchaseCell:SetPriceIcon()
  if self.firstInfo.shopItemData then
    local moneyItem = Table_Item[self.firstInfo.shopItemData.ItemID]
    if moneyItem and moneyItem.Icon then
      IconManager:SetItemIcon(moneyItem.Icon, self.u_itemPriceIcon_current)
      IconManager:SetItemIcon(moneyItem.Icon, self.u_itemPriceIcon_full)
    end
  end
end

function NewRechargeCombinePackPurchaseCell:UpdatePack()
  local packCnt = #self.data.PackList
  self.u_itemListCtrl:ResetDatas(self.data.PackList)
  self:UpdatePrice()
end

function NewRechargeCombinePackPurchaseCell:UpdatePrice()
  local cells = self.u_itemListCtrl:GetCells()
  self.current_items = {}
  self.full_items = {}
  local selectedCnt = 0
  local oriPrice = 0
  local fullCnt = 0
  local oriPrice_full = 0
  for i = 1, #cells do
    local cell = cells[i]
    if cell:IsSelected() then
      oriPrice = oriPrice + cell.info:GetCurPrice()
      selectedCnt = selectedCnt + 1
      table.insert(self.current_items, cell.info.shopItemData.id)
    end
    if not cell.data.alreadyBought then
      fullCnt = fullCnt + 1
      oriPrice_full = oriPrice_full + cell.info:GetCurPrice()
      table.insert(self.full_items, cell.info.shopItemData.id)
    end
  end
  if selectedCnt == 0 then
    self.u_buyBtnSp_current.CurrentState = 1
    self.u_buyBtnBc_current.enabled = false
    self.u_itemPriceText_current.effectColor = ColorUtil.NGUIGray
    self.u_discountMark_current:SetActive(false)
    self.u_itemOriPrice_current.text = ""
    self.u_itemPrice_current.text = "0"
  else
    self.u_buyBtn_current:SetActive(true)
    self.u_buyBtnSp_current.CurrentState = 0
    self.u_buyBtnBc_current.enabled = true
    self.u_itemPriceText_current.effectColor = ColorUtil.ButtonLabelBlue
    local discount = self.data.staticData.Discount[selectedCnt]
    self.finalPrice = math.floor(oriPrice * discount / 100)
    self.u_itemOriPrice_current.text = FunctionNewRecharge.FormatMilComma(oriPrice)
    self.u_itemPrice_current.text = FunctionNewRecharge.FormatMilComma(self.finalPrice)
    if discount < 100 then
      self.u_discountMark_current:SetActive(true)
      self.u_discountValue_current.text = discount .. "%"
      Game.convert2OffLbl(self.u_discountValue_current)
    else
      self.u_discountMark_current:SetActive(false)
    end
  end
  if fullCnt == 0 then
    self.u_buyBtn_full:SetActive(false)
    self.u_discountMark_full:SetActive(false)
    self.u_itemOriPrice_full.text = ""
    self.u_itemPrice_full.text = ""
  else
    self.u_buyBtn_full:SetActive(true)
    local discount = self.data.staticData.Discount[fullCnt]
    self.finalPrice_full = math.floor(oriPrice_full * discount / 100)
    self.u_itemOriPrice_full.text = FunctionNewRecharge.FormatMilComma(oriPrice_full)
    self.u_itemPrice_full.text = FunctionNewRecharge.FormatMilComma(self.finalPrice_full)
    if discount < 100 then
      self.u_discountMark_full:SetActive(true)
      self.u_discountValue_full.text = discount .. "%"
      Game.convert2OffLbl(self.u_discountValue_full)
    else
      self.u_discountMark_full:SetActive(false)
    end
  end
  if selectedCnt < fullCnt then
    self.u_labContent.text = ZhString.NewRechargeCombinePack_BuyAllHint
  else
    self.u_labContent.text = ZhString.NewRechargeCombinePack_BuyAllOKHint
  end
  self.u_buyCurrent:SetActive(0 < selectedCnt)
  self.u_buyBtnGrid:Reposition()
end

function NewRechargeCombinePackPurchaseCell:Pre_Purchase(is_full)
  local price = is_full and self.finalPrice_full or self.finalPrice
  local flag, func = self:IsHaveEnoughVirtualCurrency(price)
  if not flag and func ~= nil then
    func()
    return
  end
  local md5 = Table_PackageSale.MD5 or ""
  local items = is_full and self.full_items or self.current_items
  ServiceSessionShopProxy.Instance:CallBuyPackageSaleShopCmd(self.u_itemPrice_current.text, self.data.staticData.id, md5, items)
  self.gameObject:SetActive(false)
  self:OnExit()
end

function NewRechargeCombinePackPurchaseCell:OnExit()
  EventManager.Me():PassEvent(NewRechargeEvent.CombinePackList_ForceRefresh, false)
end
