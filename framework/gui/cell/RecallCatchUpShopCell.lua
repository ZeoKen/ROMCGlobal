autoImport("BaseCell")
autoImport("NewRechargeDepositGoodsData")
RecallCatchUpShopCell = class("RecallCatchUpShopCell", BaseCell)
RecallCatchUpShopCell.depositSprite = "mall_bg_07"
local tempV3 = LuaVector3()

function RecallCatchUpShopCell:Init()
  RecallCatchUpShopCell.super.Init(self)
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
  self.soldOutLabel = self:FindGO("SoldOutLabel"):GetComponent(UILabel)
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
      itemdata = ItemData.new("recallcatchupitem", self.itemid),
      funcConfig = {},
      callback = callback
    }
    TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
  end)
end

function RecallCatchUpShopCell:CheckValidTime()
  return true
end

function RecallCatchUpShopCell:SetData(data)
  if data then
    self.data = data
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
    self.soldOutLabel.gameObject:SetActive(0 >= self.leftCount)
    self.pricePos:SetActive(0 < self.leftCount)
    self.priceIcon.gameObject:SetActive(false)
    self.priceSprite.spriteName = self.depositSprite
    self.priceLabel.text = self.depositData.productConf.priceStr or self.depositData.productConf.CurrencyType .. FunctionNewRecharge.FormatMilComma(self.depositData.productConf.Rmb)
    local lLen = self.priceIcon.gameObject.activeSelf and self.priceIcon.width or 0
    local rLen = self.priceLabel.width
    self.pricePos.transform.localPosition = LuaGeometry.GetTempVector3(lLen / 2 - rLen / 2, 0, 0)
  end
end

function RecallCatchUpShopCell:Purchase()
  self:Purchase_Deposit()
end

function RecallCatchUpShopCell:Purchase_Deposit()
  self:RequestQueryChargeVirgin()
  local couldPurchaseWithActivity = true
  if self:Exec_Deposit_Purchase() then
    self.isActivity = couldPurchaseWithActivity
  end
end

function RecallCatchUpShopCell:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end

function RecallCatchUpShopCell:Exec_Deposit_Purchase()
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
      LogUtility.Info("RecallCatchUpShopCell:OnPaySuccess, " .. str_result)
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
      LogUtility.Info("RecallCatchUpShopCell:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallCatchUpShopCell:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallCatchUpShopCell:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallCatchUpShopCell:OnPayFail_NoProduct, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallCatchUpShopCell:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
    return false
  end
end

function RecallCatchUpShopCell:GetDepositID()
  return self.data and self.data.depositID or nil
end

function RecallCatchUpShopCell:GetIndex()
  return self.data and self.data.index or nil
end
