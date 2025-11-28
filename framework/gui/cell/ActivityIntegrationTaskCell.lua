autoImport("BaseCell")
autoImport("ActivityBattlePassItemCell")
ActivityIntegrationTaskCell = class("ActivityIntegrationTaskCell", BaseCell)

function ActivityIntegrationTaskCell:Init()
  ActivityBattlePassTaskCell.super.Init(self)
  self:FindObjs()
end

function ActivityIntegrationTaskCell:FindObjs()
  self.descLabel = self:FindComponent("Label", UILabel)
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
  self.buyBtn_LimitLabel = self:FindGO("LimitLabel", self.buyBtn):GetComponent(UILabel)
  self:AddClickEvent(self.buyBtn, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
end

function ActivityIntegrationTaskCell:SetData(data)
  self.data = data
  self.id = data.id
  self.state = data.state
  self.process = data.process
  local config = Table_NewServerChallengeTarget[self.id]
  if not config then
    return
  end
  self.receiveBtn:SetActive(false)
  self.receiveUnlock:SetActive(false)
  self.finishSymbol:SetActive(false)
  self.buyBtn:SetActive(false)
  self.depositID = config.Shop and config.Shop.DepositID
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

function ActivityIntegrationTaskCell:UpdateShopItemData()
  if not self.shopItemData then
    return
  end
  self.canBuy = false
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
    self.buyBtn_Price.text = StringUtil.NumThousandFormat(self.shopItemData.ItemCount)
    local goodsID = self.shopItemData.goodsID
    local staticData = Table_Item[goodsID]
    self.descLabel.text = staticData.NameZh
    local itemData = ItemData.new("Reward", staticData.id)
    itemData:SetItemNum(self.shopItemData.goodsCount)
    self.rewardCell:SetData(itemData)
    self.canBuy = true
    return true
  end
end

function ActivityIntegrationTaskCell:UpdateDeposit()
  self.canBuy = false
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
    self.buyBtn_Price.text = info.productConf.priceStr or info.productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(info.productConf.Rmb)
    local _itemData = ItemData.new("Reward", itemData.id)
    _itemData:SetItemNum(info.productConf.Count)
    self.rewardCell:SetData(_itemData)
    self.canBuy = true
    return true
  end
end
