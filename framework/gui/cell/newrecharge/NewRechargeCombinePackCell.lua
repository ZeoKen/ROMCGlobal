autoImport("NewRechargeCombinePackItemCell")
NewRechargeCombinePackCell = class("NewRechargeCombinePackCell", BaseCell)
local math_floor = math.floor
local F_CurServerTime = ServerTime.CurServerTime
local _ArrayPushBack = TableUtility.ArrayPushBack

function NewRechargeCombinePackCell:Init()
  self:FindObjs()
  self:RegisterClickEvent()
end

function NewRechargeCombinePackCell:FindObjs()
  self.widgetList = {}
  local bgTitleObj = self:FindGO("BGtitle")
  _ArrayPushBack(self.widgetList, self:FindComponent("sp", UISprite, bgTitleObj))
  _ArrayPushBack(self.widgetList, self:FindComponent("sp (1)", UISprite, bgTitleObj))
  _ArrayPushBack(self.widgetList, self:FindComponent("BG", UISprite, bgTitleObj))
  _ArrayPushBack(self.widgetList, self:FindComponent("LeftTime", UILabel, bgTitleObj))
  _ArrayPushBack(self.widgetList, self:FindComponent("Title", UILabel, bgTitleObj))
  _ArrayPushBack(self.widgetList, self:FindComponent("ItemNameBG", UISprite, bgTitleObj))
  self.u_Bg3 = self:FindGO("BG3", self.gameObject)
  self.u_Bg4 = self:FindGO("BG4", self.gameObject)
  self.u_spBgSp1 = self:FindGO("BGSprite1", self.gameObject):GetComponent(UISprite)
  self.u_spBgSp2 = self:FindGO("BGSprite2", self.gameObject):GetComponent(UISprite)
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.itemNameScroll = self:FindComponent("ItemNameAS", UIScrollView)
  if self.itemNameScroll then
    autoImport("UIAutoScrollCtrl")
    self.itemNameLabelCtrl = UIAutoScrollCtrl.new(self.itemNameScroll, self.u_labProductName, 4, 40)
    local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
    self.itemNameScroll.panel.depth = upPanel.depth + 1
  end
  self.u_ins = self:FindGO("ins")
  self.u_leftTimeMark = self:FindGO("LeftTimeMark")
  self.u_leftTime = self:FindComponent("LeftTime", UILabel, self.u_leftTimeMark)
  self.u_leftTimeBg = self:FindComponent("BG", UISprite, self.u_leftTimeMark)
  _ArrayPushBack(self.widgetList, self.u_leftTime)
  _ArrayPushBack(self.widgetList, self.u_leftTimeBg)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_itemOriPriceRedLine = self:FindGO("RedLine", self.u_itemOriPrice.gameObject)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_discountMark = self:FindGO("DiscountMark")
  self.u_discountValue = self:FindComponent("Value1", UILabel, self.u_discountMark)
  _ArrayPushBack(self.widgetList, self.u_discountValue)
  self.u_discountBg = self:FindComponent("BG", UISprite, self.u_discountMark)
  if self.u_discountBg then
    _ArrayPushBack(self.widgetList, self.u_discountBg)
  end
  self.u_soldoutMark = self:FindGO("SoldOutMark")
  self.u_instBtn = self:FindGO("InstBtn", self.gameObject)
  self.u_buyBtn = self:FindGO("PriceBtn")
  self.u_buyBtnSp = self.u_buyBtn:GetComponent(UIMultiSprite)
  self.u_buyBtnBc = self.u_buyBtn:GetComponent(BoxCollider)
  self.u_itemListContainer = self:FindComponent("Items", UIGrid)
  self.u_itemListCtrl = UIGridListCtrl.new(self.u_itemListContainer, NewRechargeCombinePackItemCell, "NewRechargeCombinePackItemCell")
  self.u_itemListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_Toggle, self.OnPackSelection, self)
  self.u_itemListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_ShowTip, self.OnShowCombinePackItemTip, self)
end

function NewRechargeCombinePackCell:SetAlpha(a)
  for k, v in pairs(self.widgetList) do
    v.alpha = a
  end
end

function NewRechargeCombinePackCell:OnEnable()
  NewRechargeCombinePackCell.super.OnEnable(self)
  if self.itemNameLabelCtrl then
    self.itemNameLabelCtrl:Start(false, true)
  end
end

function NewRechargeCombinePackCell:OnDisable()
  NewRechargeCombinePackCell.super.OnDisable(self)
  if self.itemNameLabelCtrl then
    self.itemNameLabelCtrl:Stop(true)
  end
end

function NewRechargeCombinePackCell:RegisterClickEvent()
  self:RegistShowGeneralHelpByHelpID(1202, self.u_instBtn)
  self:AddClickEvent(self.u_buyBtn, function()
    self:Pre_Purchase()
  end)
end

function NewRechargeCombinePackCell:Pre_Purchase()
  self:PassEvent(NewRechargeEvent.CombinePackItemCell_PrePurchase, self)
end

function NewRechargeCombinePackCell:SetData(data)
  self.data = data
  self.u_labProductName.text = data.staticData.TabName
  self.firstShopID = self.data.PackList[1].ShopID
  self.firstInfo = NewRechargeProxy.Ins:GenerateShopGoodsInfo(self.firstShopID)
  self:UpdatePack()
  self:SetLeftTime()
  self:SetPriceIcon()
  if self.itemNameLabelCtrl then
    self.itemNameLabelCtrl:Start(false, true)
  end
end

function NewRechargeCombinePackCell:SetPriceIcon()
  if self.firstInfo.shopItemData then
    local moneyItem = Table_Item[self.firstInfo.shopItemData.ItemID]
    if moneyItem and moneyItem.Icon then
      IconManager:SetItemIcon(moneyItem.Icon, self.u_itemPriceIcon)
    end
  end
end

function NewRechargeCombinePackCell:UpdatePack()
  local packCnt = #self.data.PackList
  self.u_itemListCtrl:ResetDatas(self.data.PackList)
  if packCnt == 3 then
    self.u_Bg3:SetActive(true)
    self.u_Bg4:SetActive(false)
  else
    self.u_Bg3:SetActive(false)
    self.u_Bg4:SetActive(true)
  end
  local cells = self.u_itemListCtrl:GetCells()
  cells[#cells]:ShowBgLine(false)
  self:UpdatePrice()
end

function NewRechargeCombinePackCell:GetSelectSatatus()
  local current_items = {}
  local selectedCnt = 0
  local fullCnt = 0
  local cells = self.u_itemListCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell:IsSelected() then
      selectedCnt = selectedCnt + 1
      table.insert(current_items, cell.info.shopItemData.id)
    end
    if not cell.data.alreadyBought then
      fullCnt = fullCnt + 1
    end
  end
  return selectedCnt, fullCnt, current_items
end

function NewRechargeCombinePackCell:UpdatePrice()
  local oriPrice = 0
  local cells = self.u_itemListCtrl:GetCells()
  local selectedCnt = 0
  local fullCnt = 0
  for i = 1, #cells do
    local cell = cells[i]
    if cell:IsSelected() then
      oriPrice = oriPrice + cell.info:GetCurPrice()
      selectedCnt = selectedCnt + 1
    end
    if not cell.data.alreadyBought then
      fullCnt = fullCnt + 1
    end
  end
  if fullCnt == 0 then
    self.u_soldoutMark:SetActive(true)
    self:SetAlpha(0.5)
    self.u_buyBtn:SetActive(false)
    self.u_discountMark:SetActive(false)
    self.u_ins:SetActive(false)
    return
  end
  self.u_soldoutMark:SetActive(false)
  self:SetAlpha(1)
  self.u_buyBtn:SetActive(true)
  self.u_ins:SetActive(false)
  if selectedCnt == 0 then
    self.u_buyBtnSp.CurrentState = 1
    self.u_buyBtnBc.enabled = false
    self.u_itemPrice.effectColor = ColorUtil.NGUIGray
    self.u_itemOriPriceRedLine:SetActive(false)
  else
    self.u_buyBtnSp.CurrentState = 0
    self.u_buyBtnBc.enabled = true
    self.u_itemPrice.effectColor = ColorUtil.ButtonLabelOrange
    self.u_itemOriPriceRedLine:SetActive(true)
  end
  if selectedCnt == 0 then
    self.u_discountMark:SetActive(false)
    self.u_itemOriPrice.text = ZhString.NewRechargeCombinePack_Please
    self.u_itemPrice.text = "0"
  else
    self.u_buyBtn:SetActive(true)
    local discount = self.data.staticData.Discount[selectedCnt]
    local finalPrice = 0
    for i = 1, #cells do
      local cell = cells[i]
      if cell:IsSelected() then
        finalPrice = finalPrice + math.floor(cell.info:GetCurPrice() * discount / 100)
      end
    end
    self.finalPrice = finalPrice
    self.u_itemOriPrice.text = ZhString.NewRechargeCombinePack_TotalPrice .. FunctionNewRecharge.FormatMilComma(oriPrice)
    self.u_itemPrice.text = FunctionNewRecharge.FormatMilComma(self.finalPrice)
    if discount < 100 then
      self.u_discountMark:SetActive(true)
      self.u_discountValue.text = discount .. "%"
      Game.convert2OffLbl(self.u_discountValue)
    else
      self.u_discountMark:SetActive(false)
    end
    if selectedCnt == 1 then
      self.u_discountMark:SetActive(false)
      self.u_itemOriPrice.text = ""
      self.u_itemOriPriceRedLine:SetActive(false)
    end
  end
end

function NewRechargeCombinePackCell:OnPackSelection(cell)
  self:UpdatePrice()
end

function NewRechargeCombinePackCell:OnShowCombinePackItemTip(cell)
  self:PassEvent(NewRechargeEvent.CombinePackItemCell_ShowTip, {
    cell = cell,
    list = self.u_itemListCtrl
  })
end

function NewRechargeCombinePackCell:SetLeftTime()
  self:Set_LeftTimeMark(false)
  self:removeTickTime()
  local totalSec, d, h, m, s = self:GetRemoveLeftTime()
  if totalSec then
    if totalSec <= 0 then
      if not Slua.IsNull(self.gameObject) then
        self.gameObject:SetActive(false)
      end
    elseif self.u_leftTime ~= nil and d <= 365 then
      if d == 0 and h == 0 then
        self.m_tickTime = TimeTickManager.Me():CreateTick(0, 1000, self.updateLeftTime, self, 988)
      else
        self.m_tickTime = TimeTickManager.Me():CreateTick(0, 60000, self.updateLeftTime, self, 988)
      end
    end
  end
end

function NewRechargeCombinePackCell:GetRemoveLeftTime()
  local removeTime
  if self.firstInfo.shopItemData then
    removeTime = self.firstInfo.shopItemData:GetRemoveDate() or 0
  else
    removeTime = self.depositRemoveTime or 0
  end
  local totalSec
  if removeTime and 0 < removeTime then
    totalSec = math_floor(removeTime - F_CurServerTime() / 1000)
    if 0 < totalSec then
      return totalSec, ClientTimeUtil.FormatTimeBySec(totalSec)
    else
      return totalSec
    end
  end
  return nil
end

function NewRechargeCombinePackCell:updateLeftTime()
  local totalSec, d, h, m, s = self:GetRemoveLeftTime()
  if totalSec <= 0 then
    self:Set_LeftTimeMark(false)
    self:removeTickTime()
    self:PassEvent(NewRechargeEvent.RemoveTimeEnd, self)
    return
  end
  self:Set_LeftTimeMark(true)
  if 0 < d then
    self.u_leftTime.text = string.format(ZhString.NewRecharge_LeftTime, d, h)
  elseif 0 < h then
    self.u_leftTime.text = string.format(ZhString.NewRecharge_LeftTime_Hour, h, m)
  else
    self.u_leftTime.text = string.format(ZhString.NewRecharge_LeftTime_Min, m, s)
  end
end

function NewRechargeCombinePackCell:removeTickTime()
  if self.m_tickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, 988)
    self.m_tickTime = nil
  end
end

function NewRechargeCombinePackCell:Set_LeftTimeMark(active)
  if not self.u_leftTimeMark then
    return
  end
  self.u_leftTimeMark:SetActive(active)
end

function NewRechargeCombinePackCell:OnCellDestroy()
  self.u_itemListCtrl:Destroy()
  NewRechargeCombinePackCell.super.OnCellDestroy(self)
  self:removeTickTime()
end

function NewRechargeCombinePackCell:IsHaveEnoughVirtualCurrency(price)
  local needCount = price or self.finalPrice
  local func
  local gachaCoin = 0
  local moneyId = self.firstInfo.shopItemData.ItemID
  if moneyId == GameConfig.MoneyId.Zeny then
    function func()
      MsgManager.ShowMsgByID(40803)
    end
    
    gachaCoin = MyselfProxy.Instance:GetROB()
  elseif moneyId == GameConfig.MoneyId.Lottery then
    function func()
      MsgManager.ConfirmMsgByID(3551, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
      end)
    end
    
    gachaCoin = MyselfProxy.Instance:GetLottery()
  else
    local itemSData = Table_Item[moneyId]
    
    function func()
      MsgManager.ShowMsgByID(9620, tostring(itemSData and itemSData.NameZh))
    end
    
    gachaCoin = BagProxy.Instance:GetItemNumByStaticID(moneyId, GameConfig.PackageMaterialCheck.shop)
  end
  local retValue = needCount <= gachaCoin
  return retValue, not retValue and func or nil
end
