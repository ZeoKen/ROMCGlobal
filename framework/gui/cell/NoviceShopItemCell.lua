autoImport("BaseCell")
autoImport("NewRechargeDepositGoodsData")
NoviceShopItemCell = class("NoviceShopItemCell", BaseCell)
NoviceShopItemCell.GoodsTypeEnum = {Deposit = 1, Shop = 2}
NoviceShopItemCell.depositSprite = "activity_novice_bg_02"
NoviceShopItemCell.shopSprite = "activity_novice_bg_01"
local tempV3 = LuaVector3()

function NoviceShopItemCell:Init()
  NoviceShopItemCell.super.Init(self)
  self:AddCellClickEvent()
  self.name = self:FindGO("Title"):GetComponent(UILabel)
  self.count = self:FindGO("Count"):GetComponent(UILabel)
  self.itemicon = self:FindGO("Icon"):GetComponent(UISprite)
  self.priceBtn = self:FindGO("PriceBtn")
  self.priceSprite = self.priceBtn:GetComponent(UISprite)
  self.priceLabel = self:FindComponent("Price", UILabel)
  self.priceIcon = self:FindComponent("PriceIcon", UISprite)
  self.pricePos = self:FindGO("PricePosHolder")
  self.desMark = self:FindGO("DesMark")
  self.desc = self:FindComponent("Des", UILabel)
  self.mask = self:FindGO("Mask")
  self.limit = self:FindGO("Limit"):GetComponent(UILabel)
  self:AddClickEvent(self.priceBtn, function()
    if not self:CheckValidTime() then
      return
    end
    if self.leftCount and self.leftCount > 0 then
      self:Purchase()
    end
  end)
  self:AddClickEvent(self.itemicon.gameObject, function()
    local sdata = {
      itemdata = ItemData.new("noviceshopitem", self.itemid),
      funcConfig = {},
      callback = callback
    }
    TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
  end)
end

function NoviceShopItemCell:CheckValidTime()
  if not NoviceShopProxy.Instance:CheckValidTime() then
    MsgManager.ShowMsgByID(40973)
    return false
  end
  return true
end

function NoviceShopItemCell:SetData(data)
  if data then
    self.data = data
    if data.GoodsType == NoviceShopProxy.GoodsTypeEnum.Shop then
      self.goodsType = self.GoodsTypeEnum.Shop
      local shopType, shopId = NoviceShopProxy.Instance:GetShopConfig()
      self.shopData = ShopProxy.Instance:GetShopItemDataByTypeId(shopType, shopId, self.data.goodsID)
      local item = Table_Item[self.shopData.goodsID or ""]
      self.itemid = self.shopData.goodsID
      if item then
        IconManager:SetItemIcon(item.Icon, self.itemicon)
        self.name.text = item.NameZh
        self.itemicon:MakePixelPerfect()
      end
      local count = self.shopData.goodsCount or 1
      self.count.text = "x " .. tostring(count)
      local cost = self.shopData.ItemCount
      local finalCost = cost
      self.priceLabel.text = StringUtil.NumThousandFormat(finalCost)
      local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.shopData)
      self.leftCount = canBuyCount
      self.limit.text = string.format(ZhString.NoviceShop_BuyLimit, self.shopData.LimitNum - canBuyCount, self.shopData.LimitNum)
      self.mask:SetActive(canBuyCount < self.shopData.LimitNum)
      self.desc.text = self.shopData.extraDes
      self.desMark:SetActive(true)
      local moneyItem = Table_Item[self.shopData.ItemID]
      if moneyItem and moneyItem.Icon then
        IconManager:SetItemIcon(moneyItem.Icon, self.priceIcon)
      end
      self.priceIcon.gameObject:SetActive(true)
      self.priceSprite.spriteName = self.shopSprite
    else
      self.goodsType = self.GoodsTypeEnum.Deposit
      self.depositData = NewRechargeDepositGoodsData.new()
      self.depositData:ResetData(data.depositID)
      self.itemid = self.depositData.productConf.ItemId
      local item = Table_Item[self.itemid]
      if item then
        IconManager:SetItemIcon(item.Icon, self.itemicon)
        self.name.text = item.NameZh
        self.itemicon:MakePixelPerfect()
      end
      local extraDes = self.depositData.productConf.ExtraDes
      if extraDes and extraDes ~= "" then
        self.desMark:SetActive(true)
        self.desc.text = extraDes
      else
        self.desMark:SetActive(false)
      end
      self.count.text = "x " .. tostring(self.depositData.productConf.Count)
      local purchasedTimes = self.depositData.purchaseTimes or 0
      local purchaseLimitTimes = self.depositData.purchaseLimit_N or 0
      self.leftCount = purchaseLimitTimes - purchasedTimes
      self.limit.text = string.format(ZhString.NoviceShop_BuyLimit, purchasedTimes, purchaseLimitTimes)
      self.mask:SetActive(purchaseLimitTimes > self.leftCount)
      self.priceIcon.gameObject:SetActive(false)
      self.priceSprite.spriteName = self.depositSprite
      self.priceLabel.text = self.depositData.productConf.priceStr or self.depositData.productConf.CurrencyType .. FunctionNewRecharge.FormatMilComma(self.depositData.productConf.Rmb)
    end
    local lLen = self.priceIcon.gameObject.activeSelf and self.priceIcon.width or 0
    local rLen = self.priceLabel.width
    self.pricePos.transform.localPosition = LuaGeometry.GetTempVector3(lLen / 2 - rLen / 2, 0, 0)
  end
end

function NoviceShopItemCell:IsDepositGoods()
  return self.goodsType == self.GoodsTypeEnum.Deposit
end

function NoviceShopItemCell:IsShopGoods()
  return self.goodsType == self.GoodsTypeEnum.Shop
end

function NoviceShopItemCell:Purchase_Deposit()
  self:RequestQueryChargeVirgin()
  local couldPurchaseWithActivity = true
  if self:Exec_Deposit_Purchase() then
    self.isActivity = couldPurchaseWithActivity
  end
end

function NoviceShopItemCell:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end

function NoviceShopItemCell:Exec_Deposit_Purchase()
  if not self:IsDepositGoods() then
    return
  end
  local productConf = self.depositData.productConf
  local productID = productConf.ProductID
  if ApplicationInfo.IsPcWebPay() then
    if productConf.PcEnable == 1 then
      MsgManager.ConfirmMsgByID(43467, function()
        ApplicationInfo.OpenPCRechargeUrl()
      end, nil, nil, nil)
    else
      MsgManager.ShowMsgByID(43466)
    end
    return
  end
  if PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    local callbacks = {}
    callbacks[1] = function(str_result)
      local str_result = str_result or "nil"
      LogUtility.Info("NoviceShopItemCell:OnPaySuccess, " .. str_result)
      if BranchMgr.IsJapan() then
        local currency = productConf and productConf.Rmb or 0
        ChargeComfirmPanel:ReduceLeft(tonumber(currency))
        EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
        LogUtility.Warning("OnPaySuccess")
        NewRechargeProxy.CDeposit:SetFPRFlag2(productID)
        xdlog(NewRechargeProxy.CDeposit:IsFPR(productID))
      end
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NoviceShopItemCell:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NoviceShopItemCell:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NoviceShopItemCell:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NoviceShopItemCell:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NoviceShopItemCell:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function NoviceShopItemCell:Purchase()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    if self.depositData then
      if BranchMgr.IsKorea() then
        local item = self.itemid and Table_Item[self.itemid]
        local productName = item and item.NameZh or ""
        local currencyType = self.depositData.productConf.priceStr or self.depositData.productConf.CurrencyType or ""
        local productPrice = FunctionNewRecharge.FormatMilComma(self.depositData.productConf.Rmb)
        OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", "[0075BCFF]" .. productName .. "[-]", currencyType, productPrice), ZhString.ShopConfirmDes, productName, productPrice, function()
          self:Purchase_Deposit(self.depositData.id)
        end)
      else
        self:Purchase_Deposit(self.depositData.id)
      end
    end
  else
    self:Purchase_Shop()
  end
end

function NoviceShopItemCell:Purchase_Shop()
  if self:IsHaveEnoughVirtualCurrency() then
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(43146)
    if dont == nil then
      MsgManager.DontAgainConfirmMsgByID(43146, function()
        ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopData.id, 1)
      end, nil, nil)
      return
    else
      ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopData.id, 1)
    end
  end
end

function NoviceShopItemCell:IsHaveEnoughVirtualCurrency()
  local limitCanBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopData)
  local needCount = self.shopData.ItemCount
  local gachaCoin = MyselfProxy.Instance:GetLottery()
  local retValue = needCount <= gachaCoin
  if not retValue then
    MsgManager.ConfirmMsgByID(3551, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
    end)
  end
  return retValue
end
