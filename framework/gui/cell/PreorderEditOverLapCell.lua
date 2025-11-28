PreorderEditOverLapCell = class("PreorderEditOverLapCell", ItemTipBaseCell)
local PreorderPriceMaxRate = GameConfig.Exchange.PreorderPriceMaxRate
local PreorderPriceMinRate = GameConfig.Exchange.PreorderPriceMinRate
local PreorderPriceMax = GameConfig.Exchange.PreorderPriceMax
local MaxCount = 99

function PreorderEditOverLapCell:Init()
  PreorderEditOverLapCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function PreorderEditOverLapCell:FindObjs()
  self.confirmButton = self:FindGO("ConfirmButton"):GetComponent(UISprite)
  self.price = self:FindGO("Price"):GetComponent(UILabel)
  self.priceIcon = self:FindGO("PriceIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.priceIcon)
  self.countInput = self:FindGO("CountInput"):GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.countInput, 6)
  self.countlabel = self:FindGO("BuyCount"):GetComponent(UILabel)
  self.countPlusBg = self:FindGO("CountPlusBg")
  self.sellCountPlusBg = self.countPlusBg:GetComponent(UISprite)
  self.sellCountPlus = self:FindGO("CountPlus", self.sellCountPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg")
  self.sellCountSubtractBg = self.countSubtractBg:GetComponent(UISprite)
  self.countSubtract = self:FindGO("BuySubtract", self.sellCountSubtractBg.gameObject):GetComponent(UISprite)
  self.maxBtn = self:FindGO("maxBtn")
  local preorderPrice = self:FindGO("preorderPrice")
  self.preorderPriceLabel = self:FindGO("preorderPriceLabel"):GetComponent(UILabel)
  self.preorderPriceIcon = self:FindGO("MoneyIcon", preorderPrice):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.preorderPriceIcon)
  local totalPreorderPrice = self:FindGO("totalPreorderPrice")
  self.totalPrice = self:FindGO("totalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("MoneyIcon", totalPreorderPrice):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.totalPriceIcon)
  self.closeBtn = self:FindGO("CloseButton")
  self.editBtn = self:FindGO("editBtn")
  self.inputPanel = self:FindGO("InputPanel")
  self.closeInputButton = self:FindGO("CloseInputButton", self.inputPanel)
  self.inputPriceLabel = self:FindGO("inputPriceLabel", self.inputPanel):GetComponent(UILabel)
  self.preorderPriceInput = self:FindGO("inputPrice", self.inputPanel):GetComponent(UIInput)
  self.inputConfirmButton = self:FindGO("InputConfirmButton")
  self:OpenInputView(false)
end

function PreorderEditOverLapCell:AddEvts()
  self:AddClickEvent(self.confirmButton.gameObject, function(g)
    self:Confirm()
  end)
  self:AddPressEvent(self.sellCountPlusBg.gameObject, function(g, b)
    self:PressCount(g, b, 1)
  end)
  self:AddPressEvent(self.sellCountSubtractBg.gameObject, function(g, b)
    self:PressCount(g, b, -1)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:CountInputOnChange()
  end)
  self:AddClickEvent(self.maxBtn, function()
    self:ClickMax()
  end)
  self:AddClickEvent(self.closeBtn, function(g)
    self:PassEvent(PreoderEvent.ClosePreorderEditor, self)
  end)
  self:AddClickEvent(self.editBtn, function(g)
    self:OpenInputView(true)
  end)
  self:AddClickEvent(self.closeInputButton, function(g)
    self:ResetPrice()
  end)
  EventDelegate.Set(self.preorderPriceInput.onChange, function()
    self:PriceInputOnChange()
  end)
  EventDelegate.Set(self.preorderPriceInput.onSubmit, function()
    self:PriceInputOnSubmit()
  end)
  self:AddClickEvent(self.inputConfirmButton, function()
    self:PriceInputOnSubmit()
    self:OpenInputView(false)
  end)
end

function PreorderEditOverLapCell:SetData(data, container)
  self.data = data
  if data then
    self:UpdateAttriContext()
    self:UpdateTopInfo()
    self.recommendPrice = 0
    self.count = 1
    self.countInput.value = self.count
    if self.ownLabel then
      self.ownLabel.text = data.num
    end
    self.currentPrice = nil
    self.orginalPrice = nil
    self.itemid = data.preorderItemData.itemid
    local exchangeData = Table_Exchange[self.itemid]
    if exchangeData then
      if not exchangeData.PreorderMaxNum or exchangeData.PreorderMaxNum == 0 then
        self.MaxCount = MaxCount
      elseif exchangeData.PreorderMaxNum and 0 < exchangeData.PreorderMaxNum then
        self.MaxCount = exchangeData.PreorderMaxNum
      else
        self.MaxCount = 0
      end
    end
    if data.preorderItemData then
      self:UpdateData(data.preorderItemData)
    end
    self.container = container
  end
end

function PreorderEditOverLapCell:UpdateData(preorderItemData, fromServer)
  self.preorderItemData = preorderItemData or self.preorderItemData
  if self.preorderItemData then
    self.currentCount = self.currentCount or self.preorderItemData.count and self.preorderItemData.count > 0 and self.preorderItemData.count or 1
    self.unitPrice = self.preorderItemData.price or 0
    self.price.text = StringUtil.NumThousandFormat(self.unitPrice)
    self.countlabel.text = tostring(self.currentCount)
    if fromServer then
      self.currentPrice = nil
    end
    local singlePreorderPrice = self.currentPrice or PreorderPriceMaxRate * self.unitPrice
    singlePreorderPrice = math.ceil(singlePreorderPrice)
    self.preorderPriceLabel.text = StringUtil.NumThousandFormat(singlePreorderPrice)
    self.totalPrice.text = StringUtil.NumThousandFormat(singlePreorderPrice * self.currentCount)
    self.totalPriceNum = singlePreorderPrice * self.currentCount // 1
    self.pricemin = self.preorderItemData.pricemin or 0
  end
end

function PreorderEditOverLapCell:Confirm()
  FunctionSecurity.Me():Preorder(function()
    self:_Confirm()
  end)
end

function PreorderEditOverLapCell:_Confirm()
  if MyselfProxy.Instance:GetROB() < self.totalPriceNum then
    MsgManager.ShowMsgByID(40803)
    self:PassEvent(PreoderEvent.ClosePreorderEditor, self)
    return
  end
  local container = self.container
  local preorderItemData = PreorderItemData.new()
  preorderItemData.itemid = container.itemid
  preorderItemData.refinelvmin = container.lowerLv or 0
  preorderItemData.refinelvmax = container.upperLv or 0
  preorderItemData.buffid = container.buffid
  preorderItemData.damage = container.damage
  preorderItemData.count = self.currentCount
  preorderItemData.cardlvmin = container.lowerCardLv or 0
  preorderItemData.cardlvmax = container.upperCardLv or 0
  local singlePreorderPrice = self.currentPrice or PreorderPriceMaxRate * self.unitPrice
  preorderItemData.price = self.totalPriceNum
  ServiceRecordTradeProxy.Instance:CallPreorderItemRecordTradeCmd(preorderItemData)
  self:PassEvent(PreoderEvent.ClosePreorderEditor, self)
end

function PreorderEditOverLapCell:PressCount(go, isPressed, change)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(change)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function PreorderEditOverLapCell:UpdateCount(change)
  self.currentCount = self.currentCount + self.countChangeRate * change
  self.countInput.value = self.currentCount
  self:UpdateData()
end

function PreorderEditOverLapCell:CountInputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.currentCount = 1
    self.countInput.value = 1
    self:UpdateData()
    return
  end
  if count <= 1 then
    count = 1
    self:SetSellCountPlus(1)
    self:SetSellCountSubtract(0.5)
  elseif count >= self.MaxCount then
    count = self.MaxCount
    self:SetSellCountPlus(0.5)
    self:SetSellCountSubtract(1)
  else
    self:SetSellCountPlus(1)
    self:SetSellCountSubtract(1)
  end
  self.currentCount = count
  self.countInput.value = count
  self:UpdateData()
end

function PreorderEditOverLapCell:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function PreorderEditOverLapCell:SetSellPricePlus(alpha)
  if self.sellPricePlusBg and self.sellPricePlus and self.sellPricePlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.sellPricePlusBg, alpha)
    self:SetSpritAlpha(self.sellPricePlus, alpha)
  end
end

function PreorderEditOverLapCell:SetSellPriceSubtract(alpha)
  if self.sellPriceSubtractBg and self.sellPriceSubtract and self.sellPriceSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.sellPriceSubtractBg, alpha)
    self:SetSpritAlpha(self.sellPriceSubtract, alpha)
  end
end

function PreorderEditOverLapCell:SetSellCountPlus(alpha)
  if self.sellCountPlusBg and self.sellCountPlus and self.sellCountPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.sellCountPlusBg, alpha)
    self:SetSpritAlpha(self.sellCountPlus, alpha)
  end
end

function PreorderEditOverLapCell:SetSellCountSubtract(alpha)
  if self.sellCountSubtractBg and self.countSubtract and self.sellCountSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.sellCountSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function PreorderEditOverLapCell:ClickMax()
  self.currentCount = self.MaxCount
  self.countInput.value = self.MaxCount
  self:CountInputOnChange()
end

function PreorderEditOverLapCell:OpenInputView(show)
  self.inputPanel:SetActive(show == true)
  if show then
    self.orginalPrice = self.currentPrice or PreorderPriceMaxRate * self.unitPrice
    self:InitInputField()
  end
end

function PreorderEditOverLapCell:ResetPrice()
  self:OpenInputView(false)
  self.currentPrice = self.orginalPrice
  self:UpdateData()
end

function PreorderEditOverLapCell:InitInputField()
  local unitPrice = self.preorderItemData.price or 0
  local singlePreorderPrice = math.ceil(PreorderPriceMaxRate * unitPrice)
  self.preorderPriceInput.value = singlePreorderPrice
  self.inputPriceLabel.text = StringUtil.NumThousandFormat(singlePreorderPrice)
end

function PreorderEditOverLapCell:PriceInputOnChange()
  if not self.preorderPriceInput.value then
    self.preorderPriceInput.value = 0
  end
  local inputValue = tonumber(self.preorderPriceInput.value) or 0
  if inputValue > PreorderPriceMax then
    inputValue = PreorderPriceMax
  end
  inputValue = math.ceil(inputValue)
  self.currentPrice = inputValue
  self.preorderPriceInput.value = inputValue
  self.inputPriceLabel.text = StringUtil.NumThousandFormat(inputValue)
  self:UpdateData()
end

function PreorderEditOverLapCell:PriceInputOnSubmit()
  if not self.preorderPriceInput.value then
    self.preorderPriceInput.value = 0
  end
  local inputValue = tonumber(self.preorderPriceInput.value) or 0
  if inputValue > PreorderPriceMax then
    inputValue = PreorderPriceMax
  elseif inputValue < self.pricemin then
    inputValue = self.pricemin
  end
  inputValue = math.ceil(inputValue)
  self.currentPrice = inputValue
  self.preorderPriceInput.value = inputValue
  self.inputPriceLabel.text = StringUtil.NumThousandFormat(inputValue)
  self:UpdateData()
end

function PreorderEditOverLapCell:Exit()
  TimeTickManager.Me():ClearTick(self, 1001)
  PreorderEditOverLapCell.super.Exit(self)
end
