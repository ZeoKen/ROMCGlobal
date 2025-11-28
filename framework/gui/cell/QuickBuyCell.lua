QuickBuyCell = class("QuickBuyCell", ItemCell)

function QuickBuyCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  QuickBuyCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function QuickBuyCell:FindObjs()
  self.chooseRoot = self:FindGO("ChooseRoot")
  self.choose = self:FindGO("Choose")
  self.reason = self:FindGO("Reason"):GetComponent(UILabel)
  self.reasonBg = self:FindGO("ReasonBg"):GetComponent(UIMultiSprite)
  self.reasonPrice = self:FindGO("ReasonPrice"):GetComponent(UIMultiSprite)
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  self.lock = self:FindGO("Lock")
  self.lockLab = self:FindComponent("Label", UILabel, self.lock)
  self.originType = self:FindGO("originType")
end

function QuickBuyCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.chooseRoot, function()
    self:PassEvent(QuickBuyEvent.Select, self)
  end)
end

function QuickBuyCell:SetData(data)
  if data then
    QuickBuyCell.super.SetData(self, data:GetItemData())
    self:ActiveNewTag(false)
    self.chooseRoot:SetActive(data.canChoose)
    self.choose:SetActive(data.isChoose)
    self.money.text = StringUtil.NumThousandFormat(data.price)
    if data.shopItemData ~= nil then
      local money = Table_Item[data.shopItemData.ItemID]
      if money and money.Icon then
        IconManager:SetItemIcon(money.Icon, self.moneyIcon)
      end
      local isLocked = data.shopItemData:GetLock() or false
      self.lock:SetActive(isLocked)
      if isLocked then
        self.lockLab.text = data.shopItemData.GetMenuDes and data.shopItemData:GetMenuDes() or ZhString.AchievementTitle_Unlock
      end
    else
      IconManager:SetItemIcon(Table_Item[100].Icon, self.moneyIcon)
      self.lock:SetActive(false)
    end
    local reason
    if data.reason == QuickBuyReason.NotExist then
      self.reasonPrice.gameObject:SetActive(false)
      reason = ZhString.QuickBuy_NotExist
      self.reasonBg.CurrentState = 0
    elseif data.reason == QuickBuyReason.Publicity then
      self.reasonPrice.gameObject:SetActive(false)
      reason = ZhString.QuickBuy_Publicity
      self.reasonBg.CurrentState = 1
    elseif data.reason == QuickBuyReason.NotEnough then
      self.reasonPrice.gameObject:SetActive(false)
      reason = ZhString.QuickBuy_NotEnough
      self.reasonBg.CurrentState = 0
    elseif data.reason == QuickBuyReason.PriceHigher then
      self.reasonPrice.gameObject:SetActive(true)
      reason = ZhString.QuickBuy_Price
      self.reasonBg.CurrentState = 0
      self.reasonPrice.CurrentState = 0
    elseif data.reason == QuickBuyReason.PriceLower then
      self.reasonPrice.gameObject:SetActive(true)
      reason = ZhString.QuickBuy_Price
      self.reasonBg.CurrentState = 0
      self.reasonPrice.CurrentState = 1
    elseif data.reason == QuickBuyReason.OverHoldLimit then
      self.reasonPrice.gameObject:SetActive(false)
      reason = ZhString.QuickBuy_OverHoldLimit
      self.reasonBg.CurrentState = 0
    end
    if reason ~= nil then
      self.reason.text = reason
    end
    self.reason.gameObject:SetActive(reason ~= nil)
    self.originType:SetActive(data.origin == QuickBuyOrigin.Shop or data.origin == QuickBuyOrigin.BlackMarket or false)
  end
  self.data = data
end

function QuickBuyCell:SetChoose()
  self.data:SetChoose()
  self.choose:SetActive(self.data.isChoose)
end
