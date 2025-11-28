RecallFundSubView = class("RecallFundSubView", SubMediatorView)
autoImport("RecallFundCell")
local viewPath = ResourcePathHelper.UIView("RecallFundSubView")

function RecallFundSubView:Init()
  if self.inited then
    return
  end
  self:LoadSubView()
  self:AddMapEvts()
  self.gameObject = self:FindGO("RecallFundSubView")
  self.fundCells = {}
  self.inited = true
end

function RecallFundSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "RecallFundSubView"
end

function RecallFundSubView:FindObjs()
  self.helpBtn = self:FindGO("HelpBtn")
  self.helpBtn:SetActive(true)
  self.timeLabel = self:FindGO("CountDownLabel", self.gameObject):GetComponent(UILabel)
  self.bgGO = self:FindGO("Bg")
  self.line1Label = self:FindComponent("BannerLine1", UILabel, self.bgGO)
  self.line2Label = self:FindComponent("BannerLine2", UILabel, self.bgGO)
  self.batchLabel = self:FindGO("BatchLabel", self.gameObject):GetComponent(UILabel)
  local rewardGroupGO = self:FindGO("RewardGroup")
  if rewardGroupGO then
    self.rewardIcon = self:FindComponent("RewardIcon", UISprite, rewardGroupGO)
    self.rewardNum = self:FindComponent("RewardNum", UILabel, rewardGroupGO)
  end
  self.buyGroupGO = self:FindGO("BuyGroup")
  if self.buyGroupGO then
    self.buyBtnGO = self:FindGO("BuyBtn", self.buyGroupGO)
    if self.buyBtnGO then
      self.buyCostLabel = self:FindComponent("BuyCost", UILabel, self.buyBtnGO)
      self.buyCostIcon = self:FindComponent("BuyCostIcon", UISprite, self.buyBtnGO)
    end
    self.countdownLabel = self:FindComponent("CountDownLabel", UILabel, self.buyGroupGO)
  end
  self.fundScrollView = self:FindGO("RewardScrollView", self.gameObject):GetComponent(UIScrollView)
  self.fundGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  if not self.fundListCtrl then
    self.fundListCtrl = UIGridListCtrl.new(self.fundGrid, RecallFundCell, "RecallFundCell")
    self.fundListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleFundCellClick, self)
  end
end

function RecallFundSubView:AddViewEvts()
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      self:HandleClickHelpBtn()
    end)
  end
  if self.buyBtnGO then
    self:AddClickEvent(self.buyBtnGO, function()
      self:HandleBuyBtnClick()
    end)
  end
end

function RecallFundSubView:AddMapEvts()
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdFundQueryInfoRecallCmd, self.OnFundDataUpdate)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdFundGetRewardRecallCmd, self.OnFundRewardGet)
  self:AddDispatcherEvt(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess)
end

function RecallFundSubView:InitDatas()
  if not self.activityIndex then
    redlog("RecallFundSubView: activityIndex not set")
    return
  end
  if not RecallFundProxy.Instance then
    redlog("RecallFundProxy未初始化")
    return
  end
  self.serverFundData = RecallFundProxy.Instance:GetFundData()
  if not self.serverFundData then
    self.serverFundData = {
      index = self.activityIndex,
      start_time = 0,
      end_time = 0,
      login_day = 0,
      reward_day = {}
    }
    RecallFundProxy.Instance:RequestFundData()
  end
  xdlog("基金数据初始化完成, 配置期数:", self.activityIndex)
  self:FindObjs()
  self:AddViewEvts()
end

function RecallFundSubView:RefreshPage(forceRefresh)
  if not self.fundListCtrl then
    return
  end
  local fundDataList = {}
  if RecallFundProxy.Instance then
    fundDataList = RecallFundProxy.Instance:GetFundDataListByIndex(self.activityIndex + 1)
  end
  xdlog("基金数据长度", #fundDataList)
  self.fundListCtrl:RemoveAll()
  self.fundListCtrl:ResetDatas(fundDataList)
  if forceRefresh then
    self.fundScrollView:ResetPosition()
  end
  if self.batchLabel and self.serverFundData then
    local currentBatch = self.serverFundData.index + 1 or 1
    local totalBatch = RecallInfoProxy.Instance:GetTotalBatchCount() or 1
    self.batchLabel.text = string.format(ZhString.RecallIntegration_BatchNumber or "第%d/%d期", currentBatch, totalBatch)
  end
  self:UpdateLeftContent()
  self:UpdateBuyButtonState()
  self:UpdateTimeDisplay()
end

function RecallFundSubView:GetBuyCostString()
  local depositId = GameConfig.UserRecall.FundDeposit
  if depositId then
    local depositConfig = Table_Deposit[depositId]
    if depositConfig then
      if depositConfig.priceStr then
        return depositConfig.priceStr
      else
        return depositConfig.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(depositConfig.Rmb)
      end
    end
  end
  return ""
end

function RecallFundSubView:UpdateLeftContent()
  if self.line1Label then
    self.line1Label.text = ZhString.RecallIntegration_Fund_Line1 or "每日登录获得奖励"
  end
  if self.line2Label then
    self.line2Label.text = self.activityIndex == 0 and ZhString.RecallIntegration_Fund_Line2 or ZhString.RecallIntegration_Fund_Line2_7 or "连续登录14天获得丰厚奖励"
  end
  if self.rewardIcon and self.rewardNum then
    IconManager:SetItemIcon(Table_Item[100].Icon, self.rewardIcon)
    self.rewardNum.text = 22800000
  end
  local costStr = self:GetBuyCostString()
  if self.buyCostLabel then
    self.buyCostLabel.text = costStr
  end
  if self.buyCostIcon then
    self.buyCostIcon.gameObject:SetActive(false)
  end
end

function RecallFundSubView:UpdateTimeDisplay()
  if not self.timeLabel or not self.serverFundData then
    return
  end
  local endTime = self.serverFundData.end_time
  if endTime then
    local currentTime = ServerTime.CurServerTime() / 1000
    local leftTime = endTime - currentTime
    if 0 < leftTime then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
      local timeText
      if 0 < day then
        timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
        self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
      else
        timeText = string.format("%02d:%02d:%02d", hour, min, sec)
        self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
      end
    else
      self:StopUpdateTimer()
      self.timeLabel.text = ZhString.Activity_End
    end
  else
    self.timeLabel.text = ""
  end
end

function RecallFundSubView:HandleClickHelpBtn()
  if Table_Help[500006] then
    local helpConfig = Table_Help[500006]
    self:OpenHelpView(helpConfig)
  end
end

function RecallFundSubView:OnReceivePurchaseSuccess(message)
  local dataId = message.dataid
  if dataId == self.depositId then
    PurchaseDeltaTimeLimit.Instance():End(self.productId)
  end
end

function RecallFundSubView:Purchase()
  redlog("[rf] Try Purchase RecallFund")
  local proxy = RecallFundProxy.Instance
  if not proxy then
    redlog("[rf] RecallFundProxy not found")
    return
  end
  if proxy:HasPurchased() then
    redlog("[rf] Already purchased")
    return
  end
  local depositId = GameConfig.UserRecall.FundDeposit
  if not depositId then
    redlog("[rf] FundDeposit not configured")
    return
  end
  local productConf = Table_Deposit[depositId]
  if not productConf then
    redlog("[bug] Table_Deposit Record not found", depositId)
    return
  end
  self.productConf = productConf
  local productID = productConf.ProductID
  self.productId = productID
  self.depositId = depositId
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
      LogUtility.Info("RecallFundSubView:OnPaySuccess, " .. str_result)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallFundSubView:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallFundSubView:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallFundSubView:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallFundSubView:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("RecallFundSubView:OnPayPaying, " .. strResult)
    end
    redlog("[rf] RecallFundSubView Do Purchase", self.depositId)
    FuncPurchase.Instance():Purchase(self.depositId, callbacks)
    local interval = 10.0
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
  else
    MsgManager.ShowMsgByID(49)
  end
end

function RecallFundSubView:HandleBuyBtnClick()
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    local depositId = GameConfig.UserRecall.FundDeposit
    if not depositId then
      redlog("[rf] FundDeposit not configured")
      return
    end
    local productConf = Table_Deposit[depositId]
    if not productConf then
      redlog("[bug] Table_Deposit Record not found", depositId)
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

function RecallFundSubView:HandleFundCellClick(cellCtrl)
  if not cellCtrl or not cellCtrl.data then
    return
  end
  local fundData = cellCtrl.data
  local canClaim = fundData.canClaim
  if canClaim then
    self:ClaimFundReward(fundData)
  else
    self:ShowFundRewardPreview(fundData, cellCtrl.gameObject)
  end
end

function RecallFundSubView:ClaimFundReward(fundData)
  if not fundData or not fundData.day then
    return
  end
  xdlog("领取基金奖励:", fundData.day)
  if RecallFundProxy.Instance then
    RecallFundProxy.Instance:RequestClaimReward(fundData.day)
  else
    redlog("RecallFundProxy未初始化")
  end
end

function RecallFundSubView:ShowFundRewardPreview(fundData, anchorObject)
  if not (fundData and fundData.staticData) or not fundData.staticData.Reward then
    return
  end
  local reward = fundData.staticData.Reward
  if reward.id then
    local funcData = {}
    funcData.itemdata = ItemData.new("ItemData", reward.id)
    funcData.itemdata:SetItemNum(reward.num or 1)
    self:ShowItemTip(funcData, anchorObject, NGUIUtil.AnchorSide.Right, {200, 0})
  end
end

function RecallFundSubView:OnFundDataUpdate(data)
  xdlog("基金数据更新", data)
  local forceRefresh = false
  if RecallFundProxy.Instance then
    self.serverFundData = RecallFundProxy.Instance:GetFundData()
    if self.serverFundData then
      local oldActivityIndex = self.activityIndex
      self.activityIndex = self.serverFundData.index
      xdlog("OnFundDataUpdate 重新获取activityIndex:", self.activityIndex, "原来的:", oldActivityIndex)
      if oldActivityIndex ~= self.activityIndex then
        xdlog("基金期数发生变化，activityIndex已更新")
        forceRefresh = true
      end
    end
  end
  self:RefreshPage(forceRefresh)
end

function RecallFundSubView:OnFundRewardGet(data)
  xdlog("基金奖励领取成功", data)
  self:RefreshPage()
end

function RecallFundSubView:StartUpdateTimer()
  self:StopUpdateTimer()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTimeDisplay()
  end, self, "TimeUpdate")
end

function RecallFundSubView:StopUpdateTimer()
  TimeTickManager.Me():ClearTick(self, "TimeUpdate")
end

function RecallFundSubView:OnEnter()
  if RecallFundProxy.Instance and RecallFundProxy.Instance:HasServerData() then
    local serverData = RecallFundProxy.Instance:GetFundData()
    if serverData then
      self.activityIndex = serverData.index
      xdlog("RecallFundSubView:OnEnter 从服务器数据获取index:", self.activityIndex)
    else
      redlog("RecallFundSubView:OnEnter 服务器数据为空")
      return
    end
  else
    redlog("RecallFundSubView:OnEnter 没有服务器数据")
    return
  end
  self:InitDatas()
  RecallSignSubView.super.OnEnter(self)
  self:RefreshPage()
  self:StartUpdateTimer()
end

function RecallFundSubView:OnShow()
  self:RefreshPage()
  self:StartUpdateTimer()
end

function RecallFundSubView:OnHide()
  self:StopUpdateTimer()
end

function RecallFundSubView:OnExit()
  xdlog("RecallFundSubView:OnExit")
  self:StopUpdateTimer()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  if self.fundListCtrl then
    self.fundListCtrl:RemoveAll()
    self.fundListCtrl = nil
  end
  if self.fundCells then
    for _, cell in pairs(self.fundCells) do
      if cell and cell.OnDestroy then
        cell:OnDestroy()
      end
    end
    TableUtility.ArrayClear(self.fundCells)
  end
  RecallFundSubView.super.OnExit(self)
end

function RecallFundSubView:UpdateBuyButtonState()
  if not self.buyBtnGO then
    return
  end
  local proxy = RecallFundProxy.Instance
  if not proxy then
    self.buyBtnGO:SetActive(false)
    return
  end
  if proxy:HasPurchased() or not proxy:CanPurchase() then
    self.buyBtnGO:SetActive(false)
  else
    self.buyBtnGO:SetActive(true)
  end
end
