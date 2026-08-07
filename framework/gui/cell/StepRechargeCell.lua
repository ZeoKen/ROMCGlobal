autoImport("BaseCell")
autoImport("ColliderItemCell")
StepRechargeEvent = StepRechargeEvent or {}
StepRechargeEvent.Buy = "StepRechargeEvent_Buy"
StepRechargeEvent.Receive = "StepRechargeEvent_Receive"
StepRechargeCell = class("StepRechargeCell", BaseCell)
local SetObjActive = function(go, active)
  if go then
    go:SetActive(active)
  end
end

function StepRechargeCell:Init()
  StepRechargeCell.super.Init(self)
  self:FindObjs()
  self:AddEvents()
end

function StepRechargeCell:FindObjs()
  local rewardGrid = self:FindComponent("Grid", UIGrid)
  if rewardGrid then
    self.rewardList = UIGridListCtrl.new(rewardGrid, ColliderItemCell, "ColliderItemCell")
    self.rewardList:AddEventListener(MouseEvent.MouseClick, self.HandleClickRewardCell, self)
  end
  self.buyBtn = self:FindGO("BuyBtn")
  self.receiveBtn = self:FindGO("ReceiveBtn")
  self.disableBtn = self:FindGO("DisableBtn")
  self.lock = self:FindGO("Lock")
  self.saleIcon = self:FindComponent("SaleIcon", UISprite)
  self.bgSprite = self:FindComponent("BgSprite", UISprite)
  self.rewardScrollView = self:FindGO("Scroll View")
  self.buyBtnLabel = self.buyBtn and self:FindComponent("Label", UILabel, self.buyBtn)
  self.receiveBtnLabel = self.receiveBtn and self:FindComponent("Label", UILabel, self.receiveBtn)
  self.disableBtnLabel = self.disableBtn and self:FindComponent("Label", UILabel, self.disableBtn)
  self.uiTxtOriPrice = self:FindGO("uiTxtOriPrice")
  self.oriPrice = self:FindComponent("OriPrice", UILabel)
  self.discountMark = self:FindGO("DiscountMark")
  self.discountValue = self.discountMark and self:FindComponent("Value1", UILabel, self.discountMark)
  self.discountPercent = self.discountMark and self:FindComponent("Percent", UILabel, self.discountMark)
  self.superValueMark = self:FindGO("SuperValueMark")
  self.superValueValue = self.superValueMark and self:FindComponent("Value1", UILabel, self.superValueMark)
  self.buyBtnTable = self.buyBtn and self:FindComponent("Table", UITable, self.buyBtn)
  self.buyBtnCostIcon = self.buyBtn and self:FindComponent("CostIcon", UISprite, self.buyBtn)
end

function StepRechargeCell:HandleClickRewardCell(cell)
  if not cell or not cell.data then
    return
  end
  self.tipData = self.tipData or {
    funcConfig = {}
  }
  self.tipData.itemdata = cell.data
  local stick = cell.icon or cell.gameObject
  local x = 0
  if cell.icon and cell.icon.gameObject then
    x = NGUIUtil.GetUIPositionXYZ(cell.icon.gameObject)
  elseif cell.gameObject then
    x = NGUIUtil.GetUIPositionXYZ(cell.gameObject)
  end
  if 0 < x then
    self:ShowItemTip(self.tipData, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
  else
    self:ShowItemTip(self.tipData, stick, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function StepRechargeCell:AddEvents()
  if self.buyBtn then
    self:AddClickEvent(self.buyBtn, function()
      self:PassEvent(StepRechargeEvent.Buy, self)
    end)
  end
  if self.receiveBtn then
    self:AddClickEvent(self.receiveBtn, function()
      self:PassEvent(StepRechargeEvent.Receive, self)
    end)
  end
end

function StepRechargeCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.activityId = data.activityId
  self.staticData = data.staticData
  self:UpdateRewards()
  self:UpdatePrice()
  self:UpdateState()
end

function StepRechargeCell:UpdateRewards()
  if not self.rewardList then
    return
  end
  local rewards = self.staticData and self.staticData.RewardItems
  local datas = {}
  if rewards then
    for i = 1, #rewards do
      local reward = rewards[i]
      local itemData = reward and ItemData.new("Reward", reward[1])
      if itemData then
        itemData:SetItemNum(reward[2] or 1)
        datas[#datas + 1] = itemData
      end
    end
  end
  self.rewardList:ResetDatas(datas)
  local cells = self.rewardList:GetCells()
  for i = 1, #cells do
    LuaGameObject.SetLocalScaleGO(cells[i].gameObject, 0.78, 0.78, 1)
  end
end

function StepRechargeCell:GetDepositInfo()
  local depositID = ActivityTieredBundleProxy.Instance:GetDepositID(self.staticData)
  if depositID then
    return NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositID)
  end
end

function StepRechargeCell:GetCurrentPrice()
  local cfg = self.staticData
  if not cfg then
    return 0
  end
  if ActivityTieredBundleProxy.Instance:IsDepositStage(cfg) then
    local info = self:GetDepositInfo()
    local productConf = info and info.productConf
    return productConf and productConf.Rmb or 0
  end
  local _, costNum = ActivityTieredBundleProxy.Instance:GetCostItem(cfg)
  return costNum or 0
end

function StepRechargeCell:GetPriceShowInfo()
  local priceShow = self.staticData and self.staticData.PriceShow
  if type(priceShow) == "table" then
    return tonumber(priceShow.OriPrice), tonumber(priceShow.Discount), tonumber(priceShow.SuperValue)
  end
  return tonumber(priceShow)
end

function StepRechargeCell:GetPriceCurrencyPrefix()
  local cfg = self.staticData
  local currencyType = ActivityTieredBundleProxy.Instance and ActivityTieredBundleProxy.Instance:GetCurrencyType(self.activityId)
  if currencyType and currencyType ~= "" then
    return currencyType .. " "
  end
  local depositID = ActivityTieredBundleProxy.Instance:GetDepositID(cfg)
  local deposit = Table_Deposit and depositID and Table_Deposit[depositID]
  currencyType = deposit and deposit.CurrencyType
  if currencyType and currencyType ~= "" then
    return currencyType .. " "
  end
  return ""
end

function StepRechargeCell:GetBuyLabelText()
  local cfg = self.staticData
  if not cfg then
    return ""
  end
  if ActivityTieredBundleProxy.Instance:IsDepositStage(cfg) then
    local info = self:GetDepositInfo()
    local productConf = info and info.productConf
    if productConf then
      return productConf.priceStr or productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(productConf.Rmb)
    end
  elseif ActivityTieredBundleProxy.Instance:IsCostStage(cfg) then
    local itemId, itemNum = ActivityTieredBundleProxy.Instance:GetCostItem(cfg)
    if itemId and itemNum then
      return FunctionNewRecharge.FormatMilComma(itemNum)
    end
  end
  return ZhString.HappyShop_Buy or ""
end

function StepRechargeCell:UpdateBuyBtnCost()
  local cfg = self.staticData
  if not cfg then
    return
  end
  local itemId = ActivityTieredBundleProxy.Instance:GetCostItem(cfg)
  local hasBought = ActivityTieredBundleProxy.Instance:IsStageFinished(self.activityId, cfg)
  local showCostIcon = itemId ~= nil and ActivityTieredBundleProxy.Instance:IsCostStage(cfg) and not hasBought
  if self.buyBtnCostIcon then
    self.buyBtnCostIcon.gameObject:SetActive(showCostIcon)
    if showCostIcon then
      IconManager:SetItemIconById(itemId, self.buyBtnCostIcon)
      if IconManager.FitAspect then
        IconManager:FitAspect(self.buyBtnCostIcon)
      end
    end
  end
  if self.buyBtnTable then
    self.buyBtnTable:Reposition()
  end
end

function StepRechargeCell:UpdatePrice()
  local cfg = self.staticData
  if not cfg then
    return
  end
  if self.buyBtnLabel then
    self.buyBtnLabel.text = self:GetBuyLabelText()
  end
  self:UpdateBuyBtnCost()
  if self.receiveBtnLabel then
    if ActivityTieredBundleProxy.Instance:IsFreeStage(cfg) then
      self.receiveBtnLabel.text = ZhString.ActivityIntegrationStepRecharge_Free or ZhString.NewRecharge_Free or ""
    else
      self.receiveBtnLabel.text = ZhString.Post_Receive or ZhString.Servant_Recommend_Receive or ""
    end
  end
  local hasBought = ActivityTieredBundleProxy.Instance:IsStageFinished(self.activityId, cfg)
  local itemId = ActivityTieredBundleProxy.Instance:GetCostItem(cfg)
  if self.saleIcon then
    local showSaleIcon = itemId ~= nil and ActivityTieredBundleProxy.Instance:IsCostStage(cfg) and not hasBought and self.buyBtnCostIcon == nil
    self.saleIcon.gameObject:SetActive(showSaleIcon)
    if showSaleIcon then
      local itemStatic = Table_Item[itemId]
      if itemStatic and itemStatic.Icon then
        IconManager:SetItemIcon(itemStatic.Icon, self.saleIcon)
      end
    end
  end
  local oriPrice, discount, superValue = self:GetPriceShowInfo()
  if not hasBought and oriPrice and 0 < oriPrice then
    self:SetOriPrice(true, oriPrice)
  else
    self:SetOriPrice(false)
  end
  self:SetDiscountMark(false)
  self:SetSuperValueMark(false)
  if not hasBought and superValue and 0 < superValue then
    self:SetSuperValueMark(true, superValue)
  end
  if not hasBought and (ActivityTieredBundleProxy.Instance:IsDepositStage(cfg) or ActivityTieredBundleProxy.Instance:IsCostStage(cfg)) then
    local curPrice = self:GetCurrentPrice()
    if discount and 0 < discount and discount < 100 then
      self:SetDiscountMark(true, oriPrice, curPrice, discount)
    elseif oriPrice and curPrice and 0 < curPrice and oriPrice > curPrice then
      self:SetDiscountMark(true, oriPrice, curPrice)
    end
  end
end

function StepRechargeCell:SetOriPrice(active, oriPrice)
  self:UpdateOriPriceLayout(active == true)
  SetObjActive(self.uiTxtOriPrice, false)
  if self.oriPrice then
    self.oriPrice.gameObject:SetActive(active)
    if active and oriPrice then
      local priceText = self:GetPriceCurrencyPrefix() .. FunctionNewRecharge.FormatMilComma(oriPrice)
      self.oriPrice.text = string.format(ZhString.Shop_OriginPrice, priceText)
    end
  end
end

function StepRechargeCell:UpdateOriPriceLayout(showOriPrice)
  if self.bgSprite then
    self.bgSprite.spriteName = showOriPrice and "tieredbundle_list_bg02" or "tieredbundle_list_bg01"
    self.bgSprite:MakePixelPerfect()
  end
  if self.rewardScrollView then
    local scrollViewY = showOriPrice and 35.7 or 28.7
    self.rewardScrollView.transform.localPosition = LuaGeometry.GetTempVector3(0, scrollViewY, 0)
  end
  if self.lock then
    local lockY = showOriPrice and 90 or 73
    self.lock.transform.localPosition = LuaGeometry.GetTempVector3(96, lockY, 0)
  end
end

function StepRechargeCell:SetDiscountMark(active, oriPrice, curPrice, discountPercent)
  SetObjActive(self.discountMark, active)
  if active and self.discountValue then
    local discount = discountPercent
    if not discount and oriPrice and curPrice then
      discount = math.ceil(curPrice / oriPrice * 100)
    end
    if discount then
      self.discountValue.text = discount .. "%"
      if Game.convert2OffLbl then
        Game.convert2OffLbl(self.discountValue)
      end
    else
      SetObjActive(self.discountMark, false)
    end
  end
  if self.discountPercent then
    self.discountPercent.gameObject:SetActive(false)
  end
end

function StepRechargeCell:SetSuperValueMark(active, superValue)
  SetObjActive(self.superValueMark, active)
  if active and self.superValueValue and superValue then
    self.superValueValue.text = superValue .. "%"
  end
end

function StepRechargeCell:UpdateState()
  local proxy = ActivityTieredBundleProxy.Instance
  local actId = self.activityId
  local cfg = self.staticData
  local finished = proxy:IsStageFinished(actId, cfg)
  local unlocked = proxy:IsUnlocked(actId, cfg)
  local canReceive = proxy:CanReceive(actId, cfg)
  local canBuy = proxy:CanBuy(actId, cfg)
  local isBuyStage = proxy:IsDepositStage(cfg) or proxy:IsCostStage(cfg)
  local isFreeStage = proxy:IsFreeStage(cfg)
  local showLockedBuy = not unlocked and not finished and isBuyStage and proxy:IsActivityAvailable(actId)
  local showLockedFree = not unlocked and not finished and isFreeStage and proxy:IsActivityAvailable(actId)
  SetObjActive(self.lock, not unlocked)
  SetObjActive(self.buyBtn, canBuy or showLockedBuy)
  SetObjActive(self.receiveBtn, canReceive or showLockedFree)
  local showDisable = not canBuy and not canReceive and not showLockedBuy and not showLockedFree
  SetObjActive(self.disableBtn, showDisable)
  if self.disableBtnLabel and showDisable then
    if finished then
      self.disableBtnLabel.text = ZhString.Post_HasReceived or ZhString.CollectGroupScoreTip_ReceivedBtn or ""
    elseif not unlocked then
      self.disableBtnLabel.text = ZhString.AchievementTitle_Unlock or ""
    elseif proxy:IsFreeStage(cfg) then
      self.disableBtnLabel.text = ZhString.Post_Receive or ZhString.Servant_Recommend_Receive or ""
    elseif proxy:IsDepositStage(cfg) then
      self.disableBtnLabel.text = ZhString.HappyShop_Buy or ""
    else
      self.disableBtnLabel.text = ZhString.HappyShop_Buy or ""
    end
  end
end
