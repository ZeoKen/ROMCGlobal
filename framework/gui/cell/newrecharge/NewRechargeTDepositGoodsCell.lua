NewRechargeTDepositGoodsCell = class("NewRechargeTDepositGoodsCell", BaseCell)

function NewRechargeTDepositGoodsCell:Init()
  self.widget = self.gameObject:GetComponent(UISprite)
  self.u_Desc = self:FindComponent("Desc", UILabel)
  self.u_Picture = self:FindComponent("Picture", UISprite)
  self.u_CountLabel = SpriteLabel.new(self:FindGO("Count"), 250, 30, 30, true)
  self.u_CountLabelBg = self:FindComponent("CountBg", UISprite)
  self.u_VirginCountGO = self:FindGO("VirginCount")
  self.u_VirginCount = self.u_VirginCountGO:GetComponent(UILabel)
  self.u_Price = self:FindComponent("Price", UILabel)
  self.u_Mask = self:FindGO("Mask")
  self.g_collider = self.gameObject:GetComponent(BoxCollider)
  self:AddClickEvent(self.gameObject, function()
    if self.info and not self.info:IsSoldOut() then
      self:Pre_Purchase()
    end
  end)
  self.purchaseLimitLab = self:FindComponent("PurchaseLimitLab", UILabel)
  self.purchaseLimitBg = self:FindComponent("PurchaseLimitBg", UISprite)
end

function NewRechargeTDepositGoodsCell:Pre_Purchase()
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    local productConf = self.info.productConf
    local productID = productConf.ProductID
    if productID then
      local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
      local productPrice = productConf.Rmb
      local productCount = productConf.Count
      local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[productConf.id].Desc)
      local productD = " [0075BCFF]" .. productDesc .. "[-] "
      if not BranchMgr.IsKorea() then
        local zenyAdditionCount = self.info:GetFreeBonusCount()
        if 0 < zenyAdditionCount then
          productCount = tostring(productCount + zenyAdditionCount)
        end
        productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
      end
      local currencyType = productConf.CurrencyType
      OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
        self:Purchase()
      end)
    end
  else
    self:Purchase()
  end
end

function NewRechargeTDepositGoodsCell:CouldPurchaseWithActivity()
  local info = self.info
  if info.discountActivity ~= nil then
    local dActivityEndTime = info.discountActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if dActivityEndTime > serverTime then
      local activityTimes = info.discountActivity[1]
      local activityUsedTimes = info.discountActivity[3]
      if activityTimes > activityUsedTimes and 0 < activityTimes then
        return true
      end
    end
  end
  if info.gainMoreActivity ~= nil then
    local gActivityEndTime = info.gainMoreActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if gActivityEndTime > serverTime then
      local activityTimes = info.gainMoreActivity[1]
      local activityUsedTimes = info.gainMoreActivity[3]
      if activityTimes > activityUsedTimes and 0 < activityTimes then
        return true
      end
    end
  end
  return false
end

function NewRechargeTDepositGoodsCell:Exec_Deposit_Purchase()
  local productConf = self.info.productConf
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
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPaySuccess, " .. str_result)
      local currency = productConf and productConf.Rmb or 0
      ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      LogUtility.Warning("OnPaySuccess")
      NewRechargeProxy.CDeposit:SetFPRFlag2(productConf.id)
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      self:SetData(self.data)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function NewRechargeTDepositGoodsCell:Purchase()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
  if self:Exec_Deposit_Purchase() then
    self.isActivity = self:CouldPurchaseWithActivity()
  end
end

function NewRechargeTDepositGoodsCell:SetLimit()
  if not self.purchaseLimitLab then
    return
  end
  local info = self.info
  if not info then
    return
  end
  if info.purchaseTimes and info.purchaseLimit_N and info.purchaseLimitStr then
    self:Show(self.purchaseLimitLab)
    self.purchaseLimitLab.text = string.format(info.purchaseLimitStr, info.purchaseTimes, info.purchaseLimit_N)
    self.purchaseLimitBg:UpdateAnchors()
  else
    self:Hide(self.purchaseLimitLab)
  end
end

function NewRechargeTDepositGoodsCell:SetData(data)
  self.data = data
  self.info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.data.ShopID)
  self:SetLimit()
  local productConf = self.info.productConf
  if productConf then
    self.u_Desc.text = productConf.Desc
    IconManager:SetZenyShopItem(productConf and productConf.Picture or "", self.u_Picture)
    if NewRechargeProxy.CDeposit:IsFPR(self.info.id) and productConf.VirginCount and productConf.VirginCount > 0 then
      self.u_VirginCountGO:SetActive(true)
      self.u_VirginCount.text = string.format(ZhString.NewRechargeTDepositGoodsCell_VirginCount, productConf.VirginCount)
    elseif productConf.Count2 and 0 < productConf.Count2 then
      self.u_VirginCountGO:SetActive(true)
      self.u_VirginCount.text = string.format(ZhString.NewRechargeTDepositGoodsCell_Count2, productConf.Count2)
    else
      self.u_VirginCountGO:SetActive(false)
    end
    self.u_CountLabel:SetText(string.format(ZhString.NewRechargeTDepositGoodsCell_Count, productConf.Count, productConf.ItemId))
    if self.u_CountLabelBg then
      self.u_CountLabelBg:UpdateAnchors()
    end
    self.u_Price.text = productConf.priceStr or productConf.CurrencyType .. productConf.Rmb
  end
  if self.info.purchaseState == 0 then
    self.isForbidPurchase = true
    if self.info.batch_is_Origin and self.info.purchaseLimitStr then
      self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, purchaseLimitTimes, purchaseLimitTimes))
      self.u_Price.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
    else
      self:Set_BuyTimesMark(false)
      self.u_Price.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
    end
    self.widget.alpha = 0.5
  elseif self.info.purchaseState == 1 then
    if self.info.batch_is_Batch and self.info.batch_DailyCount == 1 then
      self:Set_BuyTimesMark(false, ZhString.NewRechargeRecommendTShopGoodsCell_FeedAgain)
    elseif self.info.batch_is_Batch and 1 < self.info.batch_DailyCount then
      self:Set_BuyTimesMark(true, string.format(ZhString.NewRechargeRecommendTShopGoodsCell_LeftDay, self.info.batch_DailyCount - 1))
    end
    self.widget.alpha = 1
  elseif self.info:IsSoldOut() then
    self.u_Price.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
    self.widget.alpha = 0.5
  else
    self.widget.alpha = 1
  end
  self:RefreshZenyCell()
end

function NewRechargeTDepositGoodsCell:Func_AddListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveUpdateActivityCnt, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
end

function NewRechargeTDepositGoodsCell:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveUpdateActivityCnt, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
end

function NewRechargeTDepositGoodsCell:OnReceiveUpdateActivityCnt(data)
  self:SetData(self.data)
end

function NewRechargeTDepositGoodsCell:RefreshZenyCell()
  if not BranchMgr.IsJapan() then
    return
  end
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.info.productConf and self.info.productConf.Rmb or 0
    if left < currency then
      self:SetEnable(false)
    else
      self:SetEnable(true)
    end
  else
    self:SetEnable(true)
  end
end

function NewRechargeTDepositGoodsCell:SetEnable(enable)
  self.g_collider.enabled = enable
end
