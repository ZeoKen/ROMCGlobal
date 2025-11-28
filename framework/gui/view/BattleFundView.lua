autoImport("BattleFundCell")
BattleFundView = class("BattleFundView", ContainerView)
BattleFundView.ViewType = UIViewType.NormalLayer

function BattleFundView:Init()
  self:InitView()
  self:AddViewEvts()
  self:UpdateView()
end

function BattleFundView:InitView()
  local helpBtnGO = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(PanelConfig.BattleFundView.id, nil, helpBtnGO)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self.bgGO = self:FindGO("Bg")
  self.titleLabel = self:FindComponent("Title", UILabel, self.bgGO)
  self.line1Label = self:FindComponent("BannerLine1", UILabel, self.bgGO)
  self.line2Label = self:FindComponent("BannerLine2", UILabel, self.bgGO)
  local rewardGroupGO = self:FindGO("RewardGroup")
  self.rewardIcon = self:FindComponent("RewardIcon", UISprite, rewardGroupGO)
  self.rewardNum = self:FindComponent("RewardNum", UILabel, rewardGroupGO)
  self.buyGroupGO = self:FindGO("BuyGroup")
  self.buyBtnGO = self:FindGO("BuyBtn", self.buyGroupGO)
  self:AddClickEvent(self.buyBtnGO, function()
    self:OnPurchaseClicked()
  end)
  self.buyCostLabel = self:FindComponent("BuyCost", UILabel, self.buyBtnGO)
  self.buyCostIcon = self:FindComponent("BuyCostIcon", UISprite, self.buyBtnGO)
  self.countdownLabel = self:FindComponent("CountDownLabel", UILabel, self.buyGroupGO)
  self.rewardListGO = self:FindGO("RewardList")
  self.rewardListCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.rewardListGO), BattleFundCell, "BattleFundCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
end

function BattleFundView:GetBuyCostString()
  local config = BattleFundProxy.Instance:GetConfig()
  if config then
    local depositConfig = Table_Deposit[config.DepositID or 0]
    if depositConfig then
      if depositConfig.priceStr then
        return depositConfig.priceStr
      else
        return depositConfig.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(depositConfig.Rmb)
      end
    else
      local shopID = config.ShopID
      local shopType = config.ShopType
      local goods = ShopProxy.Instance:GetConfigByTypeId(shopType, shopID)
      for id, shopItemData in pairs(goods) do
        local _moneyId = shopItemData.ItemID
        local _singleCost = shopItemData.ItemCount
        return _singleCost, _moneyId
      end
      xdlog("商店配置", config.DepositID, config.ShopID, config.ShopType)
    end
  end
  return ""
end

function BattleFundView:OnReceivePurchaseSuccess(message)
  local dataId = message.dataid
  if dataId == self.depositId then
    PurchaseDeltaTimeLimit.Instance():End(self.productId)
  end
end

function BattleFundView:QueryRechargeCnt()
  local config = BattleFundProxy.Instance:GetConfig()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  if config.ShopID and config.ShopType then
    ShopProxy.Instance:CallQueryShopConfig(config.ShopType, config.ShopID)
    xdlog("请求商店", config.ShopType, config.ShopID)
  end
end

function BattleFundView:Purchase()
  redlog("[bf] Try Purchase BattleFund")
  local proxy = BattleFundProxy.Instance
  if proxy:HasPurchased() then
    return
  end
  if not proxy:CanPurchase() then
    return
  end
  local config = proxy:GetConfig()
  local productConf = Table_Deposit[config.DepositID or 0]
  if not productConf then
    redlog("[bug] Table_Deposit Record not found", config.DepositID)
    local goods = ShopProxy.Instance:GetConfigByTypeId(config.ShopType, config.ShopID)
    if goods then
      for id, shopItemData in pairs(goods) do
        local _moneyId = shopItemData.ItemID
        local _singleCost = shopItemData.ItemCount
        HappyShopProxy.Instance:SetSelectId(id)
        local isBuy = HappyShopProxy.Instance:BuyItemByShopItemData(shopItemData, 1)
        xdlog("购买成功", id, count, isBuy)
      end
    end
    return
  end
  self.productConf = productConf
  local productID = productConf.ProductID
  self.productId = productID
  self.depositId = config.DepositID
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
      LogUtility.Info("NewRechargeTCardSubView:OnPaySuccess, " .. str_result)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeTCardSubView:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeTCardSubView:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeTCardSubView:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeTCardSubView:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeTCardSubView:OnPayPaying, " .. strResult)
    end
    redlog("[bf] BattleFundView Do Purchase", self.depositId)
    FuncPurchase.Instance():Purchase(self.depositId, callbacks)
    local interval = (GameConfig.BattleFund and GameConfig.BattleFund.BuyInterval or 10000) / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
  else
    MsgManager.ShowMsgByID(49)
  end
end

function BattleFundView:OnPurchaseClicked()
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    local proxy = BattleFundProxy.Instance
    local config = proxy:GetConfig()
    local productConf = Table_Deposit[config.DepositID or 0]
    if not productConf then
      redlog("[bug] Table_Deposit Record not found", config.DepositID)
      return
    end
    local productID = productConf.ProductID
    if productID then
      local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
      local productPrice = productConf.Rmb
      local productCount = productConf.Count
      local currencyType = productConf.CurrencyType
      local productDesc = OverSea.LangManager.Instance():GetLangByKey(productConf.Desc)
      local productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
      if BranchMgr.IsKorea() then
        productD = " [0075BCFF]" .. productDesc .. "[-] "
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ShopConfirmPanel,
          viewdata = {
            data = {
              title = string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FuncZenyShop.FormatMilComma(productPrice)),
              desc = ZhString.ShopConfirmDes,
              callback = function()
                self:Purchase()
              end
            }
          }
        })
      else
        OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FuncZenyShop.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
          self:Purchase()
        end)
      end
    end
  else
    self:Purchase()
  end
end

function BattleFundView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdBattleFundNofityActCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.UpdateView)
end

function BattleFundView:UpdateLeftContent()
  local proxy = BattleFundProxy.Instance
  local config = proxy:GetConfig()
  if config then
    if config.Title then
      self.titleLabel.text = config.Title
    end
    if config.BannerLine1 then
      self.line1Label.text = config.BannerLine1
    end
    if config.BannerLine2 then
      self.line2Label.text = config.BannerLine2
    end
    IconManager:SetItemIcon(config and config.RewardIcon or "item_151", self.rewardIcon)
    self.rewardNum.text = config and config.RewardNum or 0
    local costStr, moneyId = self:GetBuyCostString()
    self.buyCostLabel.text = costStr
    if moneyId then
      IconManager:SetItemIcon(Table_Item[moneyId].Icon, self.buyCostIcon)
      self.buyCostIcon.gameObject:SetActive(true)
    else
      self.buyCostIcon.gameObject:SetActive(false)
    end
  end
end

function BattleFundView:UpdateView()
  self:UpdateLeftContent()
  local proxy = BattleFundProxy.Instance
  if proxy:HasPurchased() or not proxy:CanPurchase() then
    self.buyBtnGO:SetActive(false)
  else
    self.buyBtnGO:SetActive(true)
  end
  self:UpdateCells()
  self:UpdateCountDown()
end

function BattleFundView:UpdateCells()
  local proxy = BattleFundProxy.Instance
  local list = {}
  local datas = proxy:GetRewardDatas()
  local config = proxy:GetConfig()
  xdlog("更新cell", proxy:HasPurchased(), proxy:HasResetDepositReward(), proxy:GetResetDepositReward())
  if proxy:HasPurchased() and proxy:HasResetDepositReward() and not proxy:GetResetDepositReward() then
    table.insert(list, 1, {
      ResetDepositReward = true,
      itemId = config.ResetDepositRewardShowItem,
      itemNum = 1,
      state = 1
    })
  end
  for i = 1, #datas do
    table.insert(list, datas[i])
  end
  self.rewardListCtrl:ResetDatas(list)
end

function BattleFundView:OnEnter()
  BattleFundView.super.OnEnter(self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  if not self.ticker then
    local proxy = BattleFundProxy.Instance
    self.ticker = TimeTickManager.Me():CreateTick(0, 10000, self.UpdateCountDown, self)
    self:QueryRechargeCnt()
  end
end

function BattleFundView:OnExit()
  BattleFundView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  if self.ticker then
    self.ticker:Destroy()
    self.ticker = nil
  end
end

function BattleFundView:UpdateCountDown()
  local proxy = BattleFundProxy.Instance
  if proxy:HasPurchased() then
    local actData = proxy:GetActData()
    local extraEndTime = actData and actData.extraEndTime or 0
    if extraEndTime and 0 < extraEndTime then
      local leftTime = extraEndTime - ServerTime.CurServerTime() / 1000
      if leftTime <= 0 then
        self:CloseSelf()
        return
      end
      local leftDay, leftHour, leftMin = ClientTimeUtil.FormatTimeBySec(leftTime)
      if leftDay and 0 < leftDay then
        self.countdownLabel.text = string.format(ZhString.BattleFundExtraDayEndTime, leftDay)
      else
        self.countdownLabel.text = string.format(ZhString.BattleFundExtraTimeFormat, leftHour, leftMin)
      end
    else
      local loginDay = actData and actData.loginDay or 0
      self.countdownLabel.text = string.format(ZhString.BattleFundLoginDays, loginDay)
    end
  else
    local leftTime = proxy:GetLeftBuyTime()
    if leftTime <= 0 then
      leftTime = 0
      self:CloseSelf()
      return
    end
    local leftDay, leftHour, leftMin = ClientTimeUtil.FormatTimeBySec(leftTime)
    if leftDay and 0 < leftDay then
      self.countdownLabel.text = string.format(ZhString.BattleFundCountdownDayFormat, leftDay)
    else
      self.countdownLabel.text = string.format(ZhString.BattleFundCountdownTimeFormat, leftHour, leftMin)
    end
  end
end

function BattleFundView:OnCellClicked(cell)
  if not cell or not cell.data then
    return
  end
  local proxy = BattleFundProxy.Instance
  local hasPurchased = proxy:HasPurchased()
  local canPurchase = proxy:CanPurchase()
  if cell.data.free then
    proxy:TakeReward(cell.data.day, cell.data.free)
    if not hasPurchased and canPurchase then
      local config = proxy:GetConfig()
      local viewData = {
        content = config.ConfirmText or "",
        itemIcon = config.RewardIcon,
        itemNum = proxy:GetTakableRewards(),
        confirmText = self:GetBuyCostString(),
        callbackTarget = self,
        confirmCallback = function()
          self:OnPurchaseClicked()
        end
      }
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BattleFundConfirmPopup,
        viewdata = viewData
      })
    end
  elseif cell.data.ResetDepositReward then
    xdlog("领取重置奖励")
    local config = proxy:GetConfig()
    local resetDepositReward = config.ResetDepositReward or {}
    for i = 1, #resetDepositReward do
      local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(resetDepositReward[i])
      local purchasedTimes = info.purchaseTimes or 0
      local purchaseLimitTimes = info.purchaseLimit_N or 0
      xdlog("检测重置deposit购买次数", purchasedTimes, purchaseLimitTimes)
      if purchasedTimes < purchaseLimitTimes then
        local sysmsgData = Table_Sysmsg[3000005]
        local textStr = string.format(sysmsgData.Text, info.productConf.Desc)
        if sysmsgData then
          UIUtil.PopUpConfirmYesNoView("", textStr, function()
            FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
          end, nil, nil, sysmsgData.button, sysmsgData.buttonF)
        end
      else
        redlog("领取重置奖励")
        proxy:TakeReward(cell.data.day, false, cell.data.ResetDepositReward)
        local sysmsgData = Table_Sysmsg[3000006]
        local textStr = string.format(sysmsgData.Text, info.productConf.Desc)
        if sysmsgData then
          UIUtil.PopUpConfirmYesNoView("", textStr, function()
            FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
          end, nil, nil, sysmsgData.button, sysmsgData.buttonF)
        end
      end
    end
  elseif not hasPurchased then
    if not canPurchase then
      MsgManager.ConfirmMsgByID(43154, function()
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PostView
        })
      end)
    else
      MsgManager.ConfirmMsgByID(43151, function()
        self:OnPurchaseClicked()
      end)
    end
  else
    proxy:TakeReward(cell.data.day, cell.data.free)
  end
end
