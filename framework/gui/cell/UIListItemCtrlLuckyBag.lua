autoImport("UIModelZenyShop")
UIListItemCtrlLuckyBag = class("UIListItemCtrlLuckyBag", BaseCell)
local gReusableTable = {}
local gReusableLuaColor = LuaColor(0, 0, 0, 0)
local viewPrefabPath = ResourcePathHelper.UICell("UIListItemLuckyBag")
noLimitTime = 9999

function UIListItemCtrlLuckyBag:CreateView(parent)
  return self:CreateObj(viewPrefabPath, parent)
end

function UIListItemCtrlLuckyBag:Init()
  if self.gameObject ~= nil then
    self:GetGameObjects()
    self:RegisterButtonClickEvent()
    self:RegisterViewClickEvent()
  end
  self.purchaseLimit_N = 0
  self:ListenServerResponse()
end

function UIListItemCtrlLuckyBag:GetGameObjects()
  self.goItemIcon = self:FindGO("Icon", self.gameObject)
  self.spItemIcon = self.goItemIcon:GetComponent(UISprite)
  self.goLuckyBagPurchaseTimes = self:FindGO("PurchaseTimes", self.gameObject)
  self.labLuckyBagPurchaseTimes = self:FindGO("Lab", self.goLuckyBagPurchaseTimes):GetComponent(UILabel)
  self.goBTNPurchaseLuckyBag = self:FindGO("BTN_Purchase", self.gameObject)
  self.bcBTNPurchaseLuckyBag = self.goBTNPurchaseLuckyBag:GetComponent(BoxCollider)
  self.labTitleBTNPurchaseLuckyBag = self:FindGO("Title", self.goBTNPurchaseLuckyBag):GetComponent(UILabel)
  self.spNormalBTNPurchaseLuckyBag = self:FindGO("Normal", self.goBTNPurchaseLuckyBag):GetComponent(UISprite)
  self.goCurrency = self:FindGO("Currency", self.goBTNPurchaseLuckyBag)
  self.spCurrency = self:FindGO("Icon", self.goCurrency):GetComponent(UISprite)
  self.labCurrency = self:FindGO("Count", self.goCurrency):GetComponent(UILabel)
  self.goProductName = self:FindGO("Name", self.gameObject)
  self.goLabProductName = self:FindGO("Lab", self.goProductName)
  self.labProductName = self.goLabProductName:GetComponent(UILabel)
  self.goComingSoon = self:FindGO("ComingSoon", self.gameObject)
  self.goDiscount = self:FindGO("Discount", self.gameObject)
  self.goPercent = self:FindGO("Percent", self.goDiscount)
  self.labPercent = self:FindGO("Value1", self.goPercent):GetComponent(UILabel)
  self.goGainMore = self:FindGO("GainMore", self.gameObject)
  self.labMultipleNumber = self:FindGO("Value", self.goGainMore):GetComponent(UILabel)
  local batchHelpTip = 1202
  self.goDepositOriginBatchPurchase = self:FindGO("Deposit_OriginBatch_Purchase", self.gameObject)
  self.goBTNDepositOrigin = self:FindGO("BTN_Origin", self.goDepositOriginBatchPurchase)
  self.goBTNDepositBatch = self:FindGO("BTN_Batch", self.goDepositOriginBatchPurchase)
  self.hBtn = self:FindGO("hBtn", self.goDepositOriginBatchPurchase)
  self:RegistShowGeneralHelpByHelpID(batchHelpTip, self.hBtn)
end

function UIListItemCtrlLuckyBag:SetData(data, isReset)
  if not isReset then
    self.ori_id = data.id
  end
  self.confType = data.confType
  self.id = data.id
  self.isForbidPurchase = false
  if data.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    self.productID = data.productID
  elseif data.confType == UIModelZenyShop.luckyBagConfType.Shop then
    self.shopItemData = data.shopItemData
  end
  self:GetModelSet()
  if data.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    FuncZenyShop.Instance():AddProductPurchase(self.productConf.ProductID, function()
      self:OnClickForButtonPurchase()
    end)
    EventManager.Me():PassEvent(ZenyShopEvent.CanPurchase, self.productConf.ProductID)
  end
  if isReset then
    return
  end
  self:LoadView()
  if data.confType == UIModelZenyShop.luckyBagConfType.Deposit and self:IsOnSale() then
    self:OpenPurchaseSwitch()
  end
end

function UIListItemCtrlLuckyBag:RegisterButtonClickEvent()
  self:AddClickEvent(self.goBTNPurchaseLuckyBag, function()
    self:BTNPurchase()
  end)
  self:AddClickEvent(self.goBTNDepositOrigin, function()
    self:BTNDepositOrigin()
  end)
  self:AddClickEvent(self.goBTNDepositBatch, function()
    self:BTNDepositBatch()
  end)
end

function UIListItemCtrlLuckyBag:BTNPurchase()
  if not self.id or ShopProxy.Instance:IsThisItemCanBuyNow(self.id) then
  else
    MsgManager.ShowMsgByID(25833)
    do return end
    goto lbl_18
  end
  ::lbl_18::
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    local productID = self.productConf.ProductID
    if productID then
      local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[self.productConf.ItemId].NameZh)
      local productPrice = self.productConf.Rmb
      local productCount = self.productConf.Count
      local currencyType = self.productConf.CurrencyType
      local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[self.productConf.id].Desc)
      local productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
      if BranchMgr.IsKorea() then
        productD = " [0075BCFF]" .. productDesc .. "[-] "
      end
      OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FuncZenyShop.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
        self:OnClickForButtonPurchaseLuckyBag()
      end)
    end
  else
    self:OnClickForButtonPurchaseLuckyBag()
  end
end

function UIListItemCtrlLuckyBag:RegisterViewClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:OnClickForViewSelf()
  end)
end

function UIListItemCtrlLuckyBag:UpPurchaseLimit(productConf)
  if productConf then
    local id = productConf.id
    local limit = UIModelZenyShop.Ins():GetLuckyBagPurchaseLimit(id)
    self.purchaseLimit_N = limit ~= 0 and limit or self.productConf.MonthLimit
    self.purchaseLimit_N = self.purchaseLimit_N or 0
  end
end

function UIListItemCtrlLuckyBag:GetModelSet()
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    self.productConf = Table_Deposit[self.productID]
    if self:IsOnSale() then
      self.itemID = self.productConf.ItemId
      self.itemConf = Table_Item[self.itemID]
      self.purchaseTimes = UIModelZenyShop.Ins():GetLuckyBagPurchaseTimes(self.productID)
    end
    self.activity = UIModelZenyShop.Ins():GetProductActivity(self.productID)
    if self.activity ~= nil then
      self.discountActivity = self.activity[1]
      if self.discountActivity ~= nil then
        local dActivityEndTime = self.discountActivity[5]
        local serverTime = ServerTime.CurServerTime() / 1000
        if dActivityEndTime > serverTime then
          local activityTimes = self.discountActivity[1]
          local activityUsedTimes = self.discountActivity[3]
          if activityTimes > activityUsedTimes then
            self.activityProductID = self.discountActivity[2]
            self.productConf = Table_Deposit[self.activityProductID]
          end
        end
      end
      self.gainMoreActivity = self.activity[2]
      self.moreTimesActivity = self.activity[3]
    end
    self:UpPurchaseLimit(self.productConf)
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop then
    local itemConfID = self.shopItemData.goodsID
    self.itemConf = Table_Item[itemConfID]
    local cachedHaveBoughtItemCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount()
    if cachedHaveBoughtItemCount ~= nil then
      self.purchaseTimes = cachedHaveBoughtItemCount[self.shopItemData.id]
      self.purchaseTimes = self.purchaseTimes or 0
    else
      self.purchaseTimes = 0
    end
  end
end

function UIListItemCtrlLuckyBag:LoadView()
  if self.requestIsForVerifyPurchase then
    return
  end
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    local spriteName
    if self:IsOnSale() then
      spriteName = self.productConf.Picture
    else
      spriteName = "fudai_02"
    end
    IconManager:SetZenyShopItem(spriteName, self.spItemIcon)
    self.spItemIcon:MakePixelPerfect()
    self.labProductName.text = self.productConf.Desc
    local limitStr = self.purchaseLimit_N or 0
    if self:IsOnSale() then
      if self.purchaseTimes ~= nil then
        if limitStr >= noLimitTime or limitStr <= 0 then
          self.labLuckyBagPurchaseTimes.text = ""
        else
          local formatString = ZhString.LuckyBag_PurchaseTimesMonth
          if self.productConf.LimitType and self.productConf.LimitType == 7 then
            formatString = ZhString.LuckyBag_AlwaysCanBuy
          elseif self.productConf.LimitType and self.productConf.LimitType == 8 then
            formatString = ZhString.LuckyBag_PurchaseTimesDay0
          end
          if BranchMgr.IsSEA() and self.productConf.ItemId == 1000062 then
            formatString = ZhString.LuckyBag_AlwaysCanBuy
          end
          self.labLuckyBagPurchaseTimes.text = string.format(formatString, self.purchaseTimes, UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(limitStr))
        end
      end
    else
      self.labLuckyBagPurchaseTimes.text = ""
    end
    if self:IsOnSale() then
      if UIModelZenyShop.Ins().originToBatchProduct and UIModelZenyShop.Ins().originToBatchProduct[self.productID] then
      else
        self.goDepositOriginBatchPurchase:SetActive(false)
        self.goBTNPurchaseLuckyBag:SetActive(true)
        self.labTitleBTNPurchaseLuckyBag.enabled = true
        self.currency = self.productConf.Rmb
        self.labTitleBTNPurchaseLuckyBag.text = self.productConf.priceStr or self.productConf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(self.productConf.Rmb)
      end
      self.goCurrency:SetActive(false)
      self.goComingSoon:SetActive(false)
    else
      self.goDepositOriginBatchPurchase:SetActive(false)
      self.goBTNPurchaseLuckyBag:SetActive(false)
      self.goComingSoon:SetActive(true)
    end
    if self.purchaseTimes ~= nil then
      if self.purchaseLimit_N > 0 and self.purchaseTimes >= self.purchaseLimit_N then
        ColorUtil.ShaderGrayUIWidget(self.spNormalBTNPurchaseLuckyBag)
        LuaColor.Better_Set(gReusableLuaColor, 0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
        self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
        self.bcBTNPurchaseLuckyBag.enabled = false
        self.isForbidPurchase = true
      else
        self.spNormalBTNPurchaseLuckyBag.color = LuaGeometry.GetTempColor()
        LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
        self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
        self.bcBTNPurchaseLuckyBag.enabled = true
      end
    end
    self.goDiscount:SetActive(false)
    if self.discountActivity ~= nil then
      local dActivityEndTime = self.discountActivity[5]
      local serverTime = ServerTime.CurServerTime() / 1000
      if dActivityEndTime > serverTime then
        self.activityTimes = self.discountActivity[1]
        self.activityUsedTimes = self.discountActivity[3]
        local purchaseTimes = self.purchaseTimes or 0
        if (self.activityTimes or 0) + (self.purchaseLimit_N or 0) >= noLimitTime then
          self.labLuckyBagPurchaseTimes.text = ""
        else
          self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.activityUsedTimes + purchaseTimes, UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.activityTimes + self.purchaseLimit_N))
        end
        if self.activityTimes > self.activityUsedTimes then
          self.goDiscount:SetActive(true)
          local originPrice = Table_Deposit[self.productID].Rmb
          local discount = math.ceil(self.currency / originPrice * 100)
          if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
            discount = 100 - discount
          end
          self.labPercent.text = discount
          self.spNormalBTNPurchaseLuckyBag.color = LuaGeometry.GetTempColor()
          LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
          self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
          self.bcBTNPurchaseLuckyBag.enabled = true
          self.isForbidPurchase = false
        end
      end
    end
    if self:IsOnSale() and UIModelZenyShop.Ins().originToBatchProduct and UIModelZenyShop.Ins().originToBatchProduct[self.productID] then
      self.goDiscount:SetActive(false)
      self.goDepositOriginBatchPurchase:SetActive(true)
      self.goBTNPurchaseLuckyBag:SetActive(false)
      self:SetOriginBatchPurchaseBtnGroup()
      if self.fakeBatch_UIListItemCtrlLuckyBag == nil then
        local fakeLuckyBagGo = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("UIListItemZenyShopItem"))
        fakeLuckyBagGo.transform:SetParent(self.gameObject.transform, false)
        self.fakeBatch_UIListItemCtrlLuckyBag = UIListItemCtrlLuckyBag.new()
        local goView = self.fakeBatch_UIListItemCtrlLuckyBag:CreateView(fakeLuckyBagGo)
        self.fakeBatch_UIListItemCtrlLuckyBag.gameObject = goView
        self.fakeBatch_UIListItemCtrlLuckyBag:Init()
        self.fakeBatch_UIListItemCtrlLuckyBag:SetPurchaseSuccessCB(function()
          self:LoadView()
        end)
        local id = UIModelZenyShop.Ins().originToBatchProduct[self.ori_id]
        local conf = Table_Deposit[id]
        local newData = {
          confType = UIModelZenyShop.luckyBagConfType.Deposit,
          productID = id,
          SortingOrder = conf.SortingOrder,
          id = conf.id
        }
        self.fakeBatch_UIListItemCtrlLuckyBag:SetData(newData)
        fakeLuckyBagGo:SetActive(false)
      end
    end
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop then
    self.labProductName.text = self.itemConf.NameZh
    self.spItemIcon.spriteName = self.itemConf.Icon
    self.goComingSoon:SetActive(false)
    local zhstring
    if self.shopItemData:CheckLimitType(HappyShopProxy.LimitType.OneDay) then
      zhstring = ZhString.LuckyBag_PurchaseTimesDay
    end
    if (self.shopItemData.LimitNum or 0) >= noLimitTime then
      self.labLuckyBagPurchaseTimes.text = ""
    else
      self.labLuckyBagPurchaseTimes.text = string.format(zhstring, self.purchaseTimes, self.shopItemData.LimitNum)
    end
    self.goBTNPurchaseLuckyBag:SetActive(true)
    self.goCurrency:SetActive(true)
    self.labTitleBTNPurchaseLuckyBag.enabled = false
    self.spCurrency.spriteName = Table_Item[self.shopItemData.ItemID].Icon
    self.labCurrency.text = self.shopItemData.ItemCount
    if self.purchaseTimes >= self.shopItemData.LimitNum then
      ColorUtil.ShaderGrayUIWidget(self.spNormalBTNPurchaseLuckyBag)
      ColorUtil.ShaderGrayUIWidget(self.spCurrency)
      self.bcBTNPurchaseLuckyBag.enabled = false
      self.isForbidPurchase = true
    else
      self.spNormalBTNPurchaseLuckyBag.color = Color.white
      self.spCurrency.color = Color.white
      self.bcBTNPurchaseLuckyBag.enabled = true
    end
  end
  self.goGainMore:SetActive(false)
  if self.gainMoreActivity ~= nil then
    local gActivityEndTime = self.gainMoreActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if gActivityEndTime > serverTime then
      self.activityTimes = self.gainMoreActivity[1]
      self.activityUsedTimes = self.gainMoreActivity[3]
      local purchaseTimes = self.purchaseTimes or 0
      if (self.activityTimes or 0) + (self.purchaseLimit_N or 0) >= noLimitTime then
        self.labLuckyBagPurchaseTimes.text = ""
      else
        self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.activityUsedTimes + purchaseTimes, UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.activityTimes + self.purchaseLimit_N))
      end
      if self.activityTimes > self.activityUsedTimes then
        self.goGainMore:SetActive(true)
        self.labMultipleNumber.text = "x" .. self.gainMoreActivity[2]
        self.spNormalBTNPurchaseLuckyBag.color = LuaGeometry.GetTempColor()
        LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
        self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
        self.bcBTNPurchaseLuckyBag.enabled = true
        self.isForbidPurchase = false
      end
    end
  end
  if self.moreTimesActivity ~= nil then
    local mActivityEndTime = self.moreTimesActivity[3]
    local serverTime = ServerTime.CurServerTime() / 1000
    if mActivityEndTime > serverTime then
      local mActivityTimes = self.moreTimesActivity[1]
      local mActivityUsedTimes = self.moreTimesActivity[5]
      if self.activityTimes == nil then
        self.activityTimes = mActivityTimes
        self.activityUsedTimes = mActivityUsedTimes
      else
        self.activityTimes = self.activityTimes + mActivityTimes
        self.activityUsedTimes = self.activityUsedTimes + mActivityUsedTimes
      end
      local purchaseTimes = self.purchaseTimes or 0
      if 0 < self.activityTimes then
        if (self.activityTimes or 0) + (self.purchaseLimit_N or 0) >= noLimitTime then
          self.labLuckyBagPurchaseTimes.text = ""
        else
          self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesMonth, self.activityUsedTimes + purchaseTimes, UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.activityTimes + self.purchaseLimit_N))
        end
        if self.activityTimes > self.activityUsedTimes then
          self.spNormalBTNPurchaseLuckyBag.color = LuaGeometry.GetTempColor()
          LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
          self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
          self.bcBTNPurchaseLuckyBag.enabled = true
          self.isForbidPurchase = false
        end
      end
    end
  end
end

function UIListItemCtrlLuckyBag:IsOnSale()
  return self.productConf.Switch == 1
end

function UIListItemCtrlLuckyBag:OnClickForButtonPurchaseLuckyBag()
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if self.activityTimes and self.activityTimes > 0 and self.activityTimes > self.activityUsedTimes then
      if self.purchaseSwitch then
        self:ClosePurchaseSwitch()
        self:PurchaseLuckyBag()
        self.isActivity = true
        if self.timerForPurchaseSwitch == nil then
          local interval = GameConfig.PurchaseMonthlyVIP.interval or 30000
          self.timerForPurchaseSwitch = TimeTickManager.Me():CreateTick(interval, interval, function()
            self.timerForPurchaseSwitch:StopTick()
            self:OpenPurchaseSwitch()
          end, self, 1)
        else
          self.timerForPurchaseSwitch:Restart()
        end
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      self:RequestQueryChargeCnt()
      self.requestIsForVerifyPurchase = true
    end
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop and not self.shopItemData:CheckCanRemove() and self:IsHaveEnoughVirtualCurrency() then
    self:RequestBuyLuckyBag(self.shopItemData.id)
  end
end

local tipData, tipOffset = {}, {0, -90}

function UIListItemCtrlLuckyBag:OnClickForViewSelf()
  local itemConfID
  if self.confType == UIModelZenyShop.luckyBagConfType.Deposit then
    if self:IsOnSale() then
      itemConfID = self.productConf.ItemId
    end
  elseif self.confType == UIModelZenyShop.luckyBagConfType.Shop then
    itemConfID = self.itemConf.id
  end
  if itemConfID ~= nil then
    tipData.itemdata = ItemData.new(nil, itemConfID)
    TipManager.Instance:ShowItemFloatTip(tipData, UIViewControllerZenyShop.instance.widgetTipRelative, NGUIUtil.AnchorSide.Center, tipOffset)
  end
end

function UIListItemCtrlLuckyBag:ListenServerResponse()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
end

local gReusableLuaColor = LuaColor(0, 0, 0, 0)

function UIListItemCtrlLuckyBag:RefreshZenyCell()
  if not BranchMgr.IsJapan() then
    return
  end
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.productConf and self.productConf.Rmb or 0
    helplog(currency, left)
    if left < currency or self.isForbidPurchase then
      self:SetEnable(false)
    else
      self:SetEnable(true)
    end
  else
    helplog("unlimit")
    self:SetEnable(not self.isForbidPurchase)
  end
end

function UIListItemCtrlLuckyBag:SetEnable(enable)
  local back = self:FindGO("Normal", self.goBTNPurchaseLuckyBag):GetComponent(UISprite)
  if enable then
    LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
    self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
    back.color = LuaGeometry.GetTempColor()
  else
    LuaColor.Better_Set(gReusableLuaColor, 0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    self.labTitleBTNPurchaseLuckyBag.effectColor = gReusableLuaColor
    ColorUtil.ShaderGrayUIWidget(back)
  end
  self.bcBTNPurchaseLuckyBag.enabled = enable
end

function UIListItemCtrlLuckyBag:OnReceivePurchaseSuccess(message)
  local confID = message.dataid
  if confID == self.productID then
    self:OpenPurchaseSwitch()
    if self.timerForPurchaseSwitch then
      self.timerForPurchaseSwitch:StopTick()
    end
    if not self.isActivity then
      UIModelZenyShop.Ins():AddLuckyBagPurchaseTimes(self.productID)
    end
  end
  self:GetModelSet()
  self:LoadView()
  if self.purchaseSuccessCB then
    self.purchaseSuccessCB()
    self.purchaseSuccessCB = nil
  end
end

function UIListItemCtrlLuckyBag:SetPurchaseSuccessCB(callback)
  self.purchaseSuccessCB = callback
end

function UIListItemCtrlLuckyBag:OnPaySuccess(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPaySuccess, " .. strResult)
  if self.productConf and self.productConf.id then
    ServiceUserEventProxy.Instance:CallChargeSdkReplyUserEvent(self.productConf.id, ServerTime.CurServerTime(), true)
  end
  if BranchMgr.IsJapan() then
    local currency = self.productConf and self.productConf.Rmb or 0
    ChargeComfirmPanel:ReduceLeft(tonumber(currency))
    EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
    Debug.LogWarning("OnPaySuccess")
    UIModelZenyShop.Ins():SetFPRFlag2(self.productID)
    xdlog(UIModelZenyShop.Ins():IsFPR(self.productID))
    self:LoadView()
  end
  if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      if BranchMgr.IsChina() then
        if self.orderIDOfXDSDKPay ~= nil then
          FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(self.orderIDOfXDSDKPay, self.productConf.Rmb)
        end
      else
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), self.productConf.Rmb)
      end
    elseif runtimePlatform == RuntimePlatform.Android then
      if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
        if BranchMgr.IsChina() then
          FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd("", self.productConf.Rmb)
        else
          FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), self.productConf.Rmb)
        end
      elseif BranchMgr.IsChina() then
        local orderID = FunctionSDK.Instance:GetOrderID()
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(orderID, self.productConf.Rmb)
      else
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), self.productConf.Rmb)
      end
    end
  end
end

function UIListItemCtrlLuckyBag:OnPayFail(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayFail, " .. strResult)
  if self.productConf and self.productConf.id then
    ServiceUserEventProxy.Instance:CallChargeSdkReplyUserEvent(self.productConf.id, ServerTime.CurServerTime(), false)
  end
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end

function UIListItemCtrlLuckyBag:OnPayTimeout(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayTimeout, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end

function UIListItemCtrlLuckyBag:OnPayCancel(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayCancel, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end

function UIListItemCtrlLuckyBag:OnPayProductIllegal(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayProductIllegal, " .. strResult)
  self:OpenPurchaseSwitch()
  self.timerForPurchaseSwitch:StopTick()
end

function UIListItemCtrlLuckyBag:OnPayPaying(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIListItemCtrlLuckyBag:OnPayPaying, " .. strResult)
end

function UIListItemCtrlLuckyBag:PurchaseLuckyBag()
  if self.productConf then
    local productID = self.productConf.ProductID
    if productID then
      ServiceUserEventProxy.Instance:CallChargeSdkRequestUserEvent(self.productConf.id, ServerTime.CurServerTime())
      local productName = self.productConf.Desc
      local productPrice = self.productConf.Rmb
      local productCount = 1
      local roleID = Game.Myself and Game.Myself.data and Game.Myself.data.id or nil
      if roleID then
        local roleInfo = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
        local roleName = roleInfo and roleInfo.name or ""
        local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
        local roleBalance = MyselfProxy.Instance:GetROB() or 0
        local server = FunctionLogin.Me():getCurServerData()
        local serverID = server ~= nil and server.serverid or nil
        if serverID then
          local currentServerTime = ServerTime.CurServerTime() / 1000
          local runtimePlatform = ApplicationInfo.GetRunPlatform()
          local isPayCondition1 = false
          if BranchMgr.IsChina() then
            isPayCondition1 = runtimePlatform == RuntimePlatform.Android
          end
          if isPayCondition1 then
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = tostring(self.productConf.id)
            gReusableTable.serverID = tostring(serverID)
            FuncPurchase.SetPayCallbackCode(gReusableTable)
            local ext = json.encode(gReusableTable)
            if not BackwardCompatibilityUtil.CompatibilityMode_V81 then
              FunctionSDK.Instance:XDSDKPay(productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext, function(x)
                self:OnPaySuccess(x)
              end, function(x)
                self:OnPayFail(x)
              end, function(x)
                self:OnPayCancel(x)
              end)
            else
              FunctionXDSDK.Ins:Pay(productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext, function(x)
                self:OnPaySuccess(x)
              end, function(x)
                self:OnPayFail(x)
              end, function(x)
                self:OnPayCancel(x)
              end)
            end
          elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = tostring(self.productConf.id)
            gReusableTable.serverID = tostring(serverID)
            if BranchMgr.IsChina() and ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
              gReusableTable.accid = tostring(FunctionLogin.Me():getLoginData().accid)
              helplog("ios pay: accid: ", gReusableTable.accid)
              if PlayerPrefs.HasKey(PlayerPrefsMYServer) then
                gReusableTable.sid = tostring(PlayerPrefs.GetInt(PlayerPrefsMYServer))
                helplog("ios pay: sid: ", gReusableTable.sid)
              end
            end
            local runtimePlatform = ApplicationInfo.GetRunPlatform()
            FuncPurchase.SetPayCallbackCode(gReusableTable)
            local ext = json.encode(gReusableTable)
            if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
              local roleAndServerTime = roleID .. "_" .. currentServerTime
              self.orderIDOfXDSDKPay = MyMD5.HashString(roleAndServerTime)
              ShopProxy.Instance:XDSDKPay(productPrice * 100, tostring(serverID), productID, productName, tostring(roleID), ext, productCount, self.orderIDOfXDSDKPay, function(x)
                self:OnPaySuccess(x)
              end, function(x)
                self:OnPayFail(x)
              end, function(x)
                self:OnPayTimeout(x)
              end, function(x)
                self:OnPayCancel(x)
              end, function(x)
                self:OnPayProductIllegal(x)
              end)
            else
              self.orderIDOfXDSDKPay = ShopProxy.Instance:XDSDKPay(productPrice * 100, tostring(serverID), productID, productName, tostring(roleID), ext, productCount, function(x)
                self:OnPaySuccess(x)
              end, function(x)
                self:OnPayFail(x)
              end, function(x)
                self:OnPayTimeout(x)
              end, function(x)
                self:OnPayCancel(x)
              end, function(x)
                self:OnPayProductIllegal(x)
              end)
            end
          end
        end
      end
    end
  end
end

function UIListItemCtrlLuckyBag:OpenPurchaseSwitch()
  self.purchaseSwitch = true
end

function UIListItemCtrlLuckyBag:ClosePurchaseSwitch()
  self.purchaseSwitch = false
end

function UIListItemCtrlLuckyBag:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
  if self.timerForPurchaseSwitch ~= nil then
    self.timerForPurchaseSwitch:ClearTick()
    self.timerForPurchaseSwitch = nil
  end
  if self.fakeBatch_UIListItemCtrlLuckyBag then
    self.fakeBatch_UIListItemCtrlLuckyBag:OnExit()
  end
end

function UIListItemCtrlLuckyBag:RequestBuyLuckyBag(shop_item_id)
  ServiceSessionShopProxy.Instance:CallBuyShopItem(shop_item_id, 1)
end

function UIListItemCtrlLuckyBag:IsHaveEnoughVirtualCurrency()
  local gachaCoin = MyselfProxy.Instance:GetLottery()
  local needCount = self.shopItemData.ItemCount
  local retValue = gachaCoin >= needCount
  if not retValue then
    local sysMsgID = 3551
    MsgManager.ShowMsgByID(sysMsgID)
  end
  return retValue
end

function UIListItemCtrlLuckyBag:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function UIListItemCtrlLuckyBag:OnReceiveQueryChargeCnt(data)
  if self.requestIsForVerifyPurchase then
    self:UpPurchaseLimit(self.productConf)
    self:GetModelSet()
    self:LoadView()
    if self.purchaseTimes < self.purchaseLimit_N or self.purchaseLimit_N < 0 then
      if self.purchaseSwitch then
        self:ClosePurchaseSwitch()
        self:PurchaseLuckyBag()
        self.isActivity = false
        if self.timerForPurchaseSwitch == nil then
          local interval = GameConfig.PurchaseMonthlyVIP.interval or 30000
          self.timerForPurchaseSwitch = TimeTickManager.Me():CreateTick(interval, interval, function()
            self.timerForPurchaseSwitch:StopTick()
            self:OpenPurchaseSwitch()
          end, self, 1)
        else
          self.timerForPurchaseSwitch:Restart()
        end
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      local purchaseLimit = self.purchaseLimit_N
      local tabFormatParams = {purchaseLimit}
      MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
    end
    self.requestIsForVerifyPurchase = false
  end
end

function UIListItemCtrlLuckyBag:OnReceiveUpdateActivityCnt(data)
  self:GetModelSet()
  self:LoadView()
end

UIListItemCtrlLuckyBag.colorPurchaseTimes = "4185C6FF"
UIListItemCtrlLuckyBag.colorMorePurchaseTimes = "41c419"

function UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(str)
  return "[" .. UIListItemCtrlLuckyBag.colorPurchaseTimes .. "]" .. str .. "[-]"
end

function UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(str)
  return "[" .. UIListItemCtrlLuckyBag.colorMorePurchaseTimes .. "]" .. str .. "[-]"
end

function UIListItemCtrlLuckyBag:SetOriginBatchPurchaseBtnGroup()
  local ori_conf = Table_Deposit[self.ori_id]
  local batch_conf = Table_Deposit[UIModelZenyShop.Ins().originToBatchProduct[self.ori_id]]
  local ori_lbl = self:FindGO("Title", self.goBTNDepositOrigin):GetComponent(UILabel)
  local batch_lbl = self:FindGO("Title", self.goBTNDepositBatch):GetComponent(UILabel)
  ori_lbl.text = ori_conf.priceStr or ori_conf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(ori_conf.Rmb)
  batch_lbl.text = batch_conf.priceStr or batch_conf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(batch_conf.Rmb)
  if batch_conf.DailyCount and GameConfig.BatchLuckyBagDuration and GameConfig.BatchLuckyBagDuration[batch_conf.DailyCount - 1] then
    batch_lbl.text = batch_lbl.text .. "\n" .. GameConfig.BatchLuckyBagDuration[batch_conf.DailyCount - 1]
  end
  local batchDailyCount = UIModelZenyShop.Ins():GetLuckyBagBatchDailyCount(self.ori_id)
  local alreadyBought = batchDailyCount and 0 < batchDailyCount or self.purchaseTimes ~= nil and 0 < self.purchaseLimit_N and self.purchaseTimes >= self.purchaseLimit_N
  if alreadyBought then
    self:EnableOriginBatchPurchaseBtnGroup(false)
    self.isForbidPurchase = true
    self.labLuckyBagPurchaseTimes.text = ZhString.LuckyBag_Batch_TomorrowCanBuy
  else
    self:EnableOriginBatchPurchaseBtnGroup(true)
    self.isForbidPurchase = false
    self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_PurchaseTimesDay, self.purchaseTimes or 0, self.purchaseLimit_N)
  end
  if batchDailyCount and 0 < batchDailyCount then
    if 1 < batchDailyCount then
      self.labLuckyBagPurchaseTimes.text = string.format(ZhString.LuckyBag_Batch_LeftCount, batchDailyCount - 1)
    else
      self.labLuckyBagPurchaseTimes.text = ZhString.LuckyBag_Batch_TomorrowCanBuy
    end
  end
end

function UIListItemCtrlLuckyBag:EnableOriginBatchPurchaseBtnGroup(enable)
  local back = self:FindGO("Normal", self.goBTNDepositOrigin):GetComponent(UISprite)
  local text = self:FindGO("Title", self.goBTNDepositOrigin):GetComponent(UILabel)
  if enable then
    LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
    text.effectColor = gReusableLuaColor
    back.color = LuaGeometry.GetTempColor()
  else
    LuaColor.Better_Set(gReusableLuaColor, 0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    text.effectColor = gReusableLuaColor
    ColorUtil.ShaderGrayUIWidget(back)
  end
  back = self:FindGO("Normal", self.goBTNDepositBatch):GetComponent(UISprite)
  text = self:FindGO("Title", self.goBTNDepositBatch):GetComponent(UILabel)
  local sale = self:FindGO("SaleIcon", self.goBTNDepositBatch):GetComponent(UISprite)
  if enable then
    LuaColor.Better_Set(gReusableLuaColor, 0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
    text.effectColor = gReusableLuaColor
    back.color = LuaGeometry.GetTempColor()
    sale.color = LuaGeometry.GetTempColor()
  else
    LuaColor.Better_Set(gReusableLuaColor, 0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    text.effectColor = gReusableLuaColor
    ColorUtil.ShaderGrayUIWidget(back)
    ColorUtil.ShaderGrayUIWidget(sale)
  end
  self.goBTNDepositOrigin:GetComponent(BoxCollider).enabled = enable
  self.goBTNDepositBatch:GetComponent(BoxCollider).enabled = enable
end

function UIListItemCtrlLuckyBag:BTNDepositOrigin()
  self:BTNPurchase()
end

function UIListItemCtrlLuckyBag:BTNDepositBatch()
  if self.fakeBatch_UIListItemCtrlLuckyBag then
    self.fakeBatch_UIListItemCtrlLuckyBag:BTNPurchase()
  end
end
