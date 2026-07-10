autoImport("BaseCell")
autoImport("ActivityBattlePassItemCell")
ActivityIntegrationTaskCell = class("ActivityIntegrationTaskCell", BaseCell)

function ActivityIntegrationTaskCell:Init()
  ActivityBattlePassTaskCell.super.Init(self)
  self:FindObjs()
end

function ActivityIntegrationTaskCell:FindObjs()
  self.labelTable = self:FindGO("Table"):GetComponent(UITable)
  self.descLabel = self:FindComponent("Label", UILabel, self.labelTable.gameObject)
  self.buyBtn_LimitLabel = self:FindGO("LimitLabel", self.labelTable.gameObject):GetComponent(UILabel)
  self.receiveBtn = self:FindGO("ReceiveBtn")
  self:AddClickEvent(self.receiveBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.receiveUnlock = self:FindGO("ReceiveUnlock")
  self.finishSymbol = self:FindGO("FinishSymbol")
  local rewardHolder = self:FindGO("RewardHolder")
  self.rewardCell = ActivityBattlePassItemCell.new(rewardHolder)
  self:AddClickEvent(rewardHolder, function()
    self:PassEvent(MouseEvent.DoubleClick, self)
  end)
  self.buyBtn = self:FindGO("BuyBtn")
  self.buyBtn_Price = self:FindGO("Label", self.buyBtn):GetComponent(UILabel)
  self.buyBtn_Icon = self:FindGO("icon", self.buyBtn):GetComponent(UISprite)
  self.buyBtn_OriPrice = self:FindComponent("OriPrice", UILabel, self.gameObject)
  self.buyBtn_DiscountMark = self:FindGO("DiscountMark", self.gameObject)
  self.buyBtn_OriPrice.gameObject:SetActive(false)
  self.buyBtn_LimitLabel.gameObject:SetActive(false)
  if self.buyBtn_DiscountMark then
    self.buyBtn_DiscountValue = self:FindComponent("Value1", UILabel, self.buyBtn_DiscountMark)
  end
  self:AddClickEvent(self.buyBtn, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
end

function ActivityIntegrationTaskCell:SetData(data)
  self.data = data
  self.id = data.id
  self.state = data.state
  self.process = data.process
  self.shopItemData = nil
  self.shopConfig = nil
  self.shopItemID = nil
  self.depositID = nil
  self.canBuy = false
  self:Set_DiscountMark(false)
  local config = Table_NewServerChallengeTarget[self.id]
  if not config then
    return
  end
  self.receiveBtn:SetActive(false)
  self.receiveUnlock:SetActive(false)
  self.finishSymbol:SetActive(false)
  self.buyBtn:SetActive(false)
  self.buyBtn_LimitLabel.gameObject:SetActive(false)
  self.shopConfig = config.Shop
  self.shopItemID = self.shopConfig and self.shopConfig.ShopItemID or config.ShopItemID
  self.depositID = self.shopConfig and self.shopConfig.DepositID or config.DepositID
  if self:UpdateShopItemData() then
    return
  elseif self:UpdateDeposit() then
    return
  end
  local targetNum = config.TargetNum
  local descStr = OverSea.LangManager.Instance():GetLangByKey(config.Title)
  if self.state == 1 then
    self.receiveBtn:SetActive(true)
    self.descLabel.text = string.format(descStr, targetNum)
  elseif self.state == 2 then
    self.finishSymbol:SetActive(true)
    self.descLabel.text = string.format(descStr, targetNum)
  else
    self.receiveUnlock:SetActive(true)
    local processStr = data.process .. "/" .. targetNum
    self.descLabel.text = string.format(descStr, processStr)
  end
  local mySex = MyselfProxy.Instance:GetMySex()
  local reward = mySex == 1 and config.MaleReward or config.FemaleReward
  reward = reward and reward[1]
  if reward then
    local itemid = reward[1]
    local num = reward[2]
    local itemData = ItemData.new("Reward", itemid)
    itemData:SetItemNum(num)
    self.rewardCell:SetData(itemData)
  end
  self:RefreshLabelTable()
end

function ActivityIntegrationTaskCell:SetShopItemData(shopItemData)
  if not shopItemData then
    return
  end
  self.shopItemData = shopItemData
  self:UpdateShopItemData()
end

function ActivityIntegrationTaskCell:SetDepositData()
  self:UpdateDeposit()
end

function ActivityIntegrationTaskCell:RefreshLabelTable()
  if self.labelTable then
    self.labelTable.repositionNow = true
    self.labelTable:Reposition()
  end
end

function ActivityIntegrationTaskCell:GetShopDiscount()
  local discount = self.shopConfig and self.shopConfig.Discount
  discount = discount and tonumber(discount)
  if discount and 0 < discount and discount < 100 then
    return discount
  end
end

function ActivityIntegrationTaskCell:GetOriginPriceByDiscount(curPrice)
  local discount = self:GetShopDiscount()
  if discount and curPrice then
    return math.ceil(curPrice * 100 / discount), discount
  end
end

function ActivityIntegrationTaskCell:Set_DiscountMark(active, oriPrice, curPrice, showDiscount, priceCurrencyPrefix, discountPercent)
  priceCurrencyPrefix = priceCurrencyPrefix or ""
  if active then
    if self.buyBtn_OriPrice and oriPrice then
      self.buyBtn_OriPrice.text = string.format(ZhString.Shop_OriginPrice, priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(oriPrice))
    end
    if curPrice then
      self.buyBtn_Price.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(curPrice)
    end
  end
  if self.buyBtn_OriPrice then
    self.buyBtn_OriPrice.gameObject:SetActive(active == true)
  end
  if self.buyBtn_DiscountMark then
    self.buyBtn_DiscountMark:SetActive(showDiscount == true and active == true)
    if showDiscount and active and oriPrice and curPrice and self.buyBtn_DiscountValue then
      local discount = discountPercent or math.ceil(curPrice / oriPrice * 100)
      self.buyBtn_DiscountValue.text = discount .. "%"
      Game.convert2OffLbl(self.buyBtn_DiscountValue)
    end
  end
end

function ActivityIntegrationTaskCell:UpdateShopItemData()
  if not self.shopItemData then
    return
  end
  self.canBuy = false
  self:Set_DiscountMark(false)
  self.buyBtn:SetActive(false)
  self.buyBtn_LimitLabel.gameObject:SetActive(false)
  self:RefreshLabelTable()
  if self.state == 2 then
    local _HappyShopProxy = HappyShopProxy.Instance
    local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(self.shopItemData)
    local maxLimit = self.shopItemData.LimitNum
    if canBuyCount == 0 then
      xdlog("售罄")
      return false
    end
    if canBuyCount ~= nil then
      local str = string.format(ZhString.NewRecharge_BuyLimit_Acc_Ever, maxLimit - canBuyCount, maxLimit)
      self.buyBtn_LimitLabel.gameObject:SetActive(true)
      self.buyBtn_LimitLabel.text = str
    else
      self.buyBtn_LimitLabel.gameObject:SetActive(false)
    end
    self.finishSymbol:SetActive(false)
    self.buyBtn:SetActive(true)
    local moneyItem = Table_Item[self.shopItemData.ItemID]
    if moneyItem and moneyItem.Icon then
      self.buyBtn_Icon.gameObject:SetActive(true)
      IconManager:SetItemIcon(moneyItem.Icon, self.buyBtn_Icon)
    else
      self.buyBtn_Icon.gameObject:SetActive(false)
    end
    local curPrice = self.shopItemData.GetChangeCost and self.shopItemData:GetChangeCost() or self.shopItemData.ItemCount
    local oriPrice, discount = self:GetOriginPriceByDiscount(curPrice)
    if oriPrice then
      self:Set_DiscountMark(true, oriPrice, curPrice, true, nil, discount)
    else
      self:Set_DiscountMark(false)
      self.buyBtn_Price.text = StringUtil.NumThousandFormat(curPrice)
    end
    local goodsID = self.shopItemData.goodsID
    local staticData = Table_Item[goodsID]
    self.descLabel.text = staticData.NameZh
    local itemData = ItemData.new("Reward", staticData.id)
    itemData:SetItemNum(self.shopItemData.goodsCount)
    self.rewardCell:SetData(itemData)
    self.canBuy = true
    self:RefreshLabelTable()
    return true
  end
end

function ActivityIntegrationTaskCell:UpdateDeposit()
  self.canBuy = false
  self:Set_DiscountMark(false)
  self.buyBtn:SetActive(false)
  self.buyBtn_LimitLabel.gameObject:SetActive(false)
  self:RefreshLabelTable()
  local depositid = self.depositID
  if self.state == 2 and ShopProxy.Instance:GetDepositItemCanBuy(depositid) then
    local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositid)
    local purchasedTimes, purchaseLimitTimes
    purchasedTimes = info.purchaseTimes or 0
    purchaseLimitTimes = info.purchaseLimit_N or 0
    local formatString = info.purchaseLimitStr
    if 9999 <= purchaseLimitTimes or purchaseLimitTimes <= 0 or not formatString then
      self.buyBtn_LimitLabel.gameObject:SetActive(false)
      redlog("无限次购买  不符合设计")
    else
      if purchasedTimes == purchaseLimitTimes then
        xdlog("deposit 售罄")
        return false
      end
      self.buyBtn_LimitLabel.gameObject:SetActive(true)
      self.buyBtn_LimitLabel.text = string.format(formatString, purchasedTimes, purchaseLimitTimes)
    end
    self.finishSymbol:SetActive(false)
    self.buyBtn:SetActive(true)
    self.buyBtn_Icon.gameObject:SetActive(false)
    local itemID = info.productConf.ItemId
    local itemData = Table_Item[itemID]
    if itemData then
      self.descLabel.text = itemData.NameZh
    end
    local curPrice = info.productConf.Rmb
    local priceCurrencyPrefix = info.productConf.CurrencyType .. " "
    local oriPrice, discount = self:GetOriginPriceByDiscount(curPrice)
    if oriPrice then
      self:Set_DiscountMark(true, oriPrice, curPrice, true, priceCurrencyPrefix, discount)
    else
      self:Set_DiscountMark(false)
      self.buyBtn_Price.text = info.productConf.priceStr or priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(curPrice)
    end
    local _itemData = ItemData.new("Reward", itemData.id)
    _itemData:SetItemNum(info.productConf.Count)
    self.rewardCell:SetData(_itemData)
    self.canBuy = true
    self:RefreshLabelTable()
    return true
  end
end
