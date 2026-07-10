TimeLimitShopView = class("TimeLimitShopView", BaseView)
TimeLimitShopView.ViewType = UIViewType.NormalLayer
TimeLimitShopView.DepositType = 7

function TimeLimitShopView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
end

function TimeLimitShopView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("ItemIcon"):GetComponent(UISprite)
  self.sale = self:FindGO("Sale")
  self.saleLabel = self:FindGO("SaleLabel", self.sale):GetComponent(UILabel)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.itemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.itemGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.itemListCtrl = UIGridListCtrl.new(self.itemGrid, RewardGridCell, "RewardGridCellType2")
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickItem, self)
  self.bgTexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("Gift_bg_03", self.bgTexture)
  self.buyBtn = self:FindGO("BuyBtn")
  self.helpBtn = self:FindGO("HelpBtn")
  self.priceGO = self:FindGO("Price", self.buyBtn)
  self.priceBG = self.priceGO:GetComponent(UISprite)
  self.price_Label = self:FindGO("PriceLabel", self.priceGO):GetComponent(UILabel)
  self.price_Icon = self:FindGO("PriceIcon", self.priceGO):GetComponent(UISprite)
  local itemId = 151
  local itemData = Table_Item[itemId]
  if not itemData then
    redlog("Item表缺少配置", itemId)
  end
  IconManager:SetItemIcon(itemData.Icon, self.price_Icon)
  self.leftIndicator = self:FindGO("LeftIndicator")
  self.rightIndicator = self:FindGO("RightIndicator")
  self.effectContainer = self:FindGO("EffectContainer")
  self.titleTexture = self:FindGO("TitleTexture"):GetComponent(UITexture)
end

function TimeLimitShopView:AddEvts()
  self:AddClickEvent(self.buyBtn, function()
    if self:IsDepositGood(self.curGoodData) then
      self:HandleClickDepositItem()
      return
    end
    local bCatGold = MyselfProxy.Instance:GetLottery()
    local cost = tonumber(self.price_Label.text)
    local title = self.titleLabel.text
    if bCatGold < cost then
      MsgManager.ConfirmMsgByID(41164, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        self:CloseSelf()
      end)
      return
    end
    local costStr = string.format(ZhString.Friend_RecallRewardItem, cost, Table_Item[151].NameZh)
    local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(650, 1, self.curGoodID)
    if shopItemData then
      if BranchMgr.IsJapan() then
        OverseaHostHelper:GachaUseComfirm(cost, function()
          HappyShopProxy.Instance:BuyItemByShopItemData(shopItemData, 1, true)
        end)
      else
        MsgManager.ConfirmMsgByID(9630, function()
          HappyShopProxy.Instance:BuyItemByShopItemData(shopItemData, 1, true)
        end, nil, nil, costStr, title)
      end
    end
  end)
  self:TryOpenHelpViewById(35082, nil, self.helpBtn)
  self:AddClickEvent(self.leftIndicator, function()
    self:GoLeft()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self:GoRight()
  end)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    local goodsID = (not self.shopItemData or not self.shopItemData.goodsID) and self.depositInfo and self.depositInfo.itemID
    local itemData = goodsID and ItemData.new("Main", goodsID)
    if itemData then
      self.tipData.itemdata = itemData
      self:ShowItemTip(self.tipData, self.itemIcon, NGUIUtil.AnchorSide.Center, {200, -150})
    end
  end)
end

function TimeLimitShopView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RecvQueryChargeCnt)
end

function TimeLimitShopView:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.waitQueryChargeRefresh = false
end

function TimeLimitShopView:GetGoodID(goodData)
  return type(goodData) == "table" and goodData.id or goodData
end

function TimeLimitShopView:GetGoodType(goodData)
  return type(goodData) == "table" and (goodData.type or 0) or 0
end

function TimeLimitShopView:IsDepositGood(goodData)
  return self:GetGoodType(goodData) == TimeLimitShopView.DepositType
end

function TimeLimitShopView:GoLeft()
  self.curPage = self.curPage - 1
  if self.curPage < 1 then
    self.curPage = 1
  end
  self.curGoodData = self.shopGoods[self.curPage]
  self.curGoodID = self:GetGoodID(self.curGoodData)
  self:RefreshGoodPage(self.curGoodData)
  self:UpdateIndicator()
end

function TimeLimitShopView:GoRight()
  self.curPage = self.curPage + 1
  if self.curPage > self.maxPage then
    self.curPage = self.maxPage
  end
  self.curGoodData = self.shopGoods[self.curPage]
  self.curGoodID = self:GetGoodID(self.curGoodData)
  self:RefreshGoodPage(self.curGoodData)
  self:UpdateIndicator()
end

function TimeLimitShopView:UpdateIndicator()
  if self.curPage == 1 then
    self.leftIndicator:SetActive(false)
  else
    self.leftIndicator:SetActive(true)
  end
  if self.curPage >= self.maxPage then
    self.rightIndicator:SetActive(false)
  else
    self.rightIndicator:SetActive(true)
  end
end

function TimeLimitShopView:InitShow()
  self.shopGoods = TimeLimitShopProxy.Instance.timeLimitGoods
  if not self.shopGoods or #self.shopGoods == 0 then
    self:CloseSelf()
    return
  end
  self.maxPage = #self.shopGoods
  local initPage = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.initPage or false
  self.curPage = 1
  if not initPage then
    local newStock = TimeLimitShopProxy.Instance.newInstock
    if newStock then
      for i = 1, #self.shopGoods do
        if TimeLimitShopProxy.Instance:IsSameGood(self.shopGoods[i], newStock) then
          self.curPage = i
        end
      end
    end
  end
  self.curGoodData = self.shopGoods[self.curPage]
  self.curGoodID = self:GetGoodID(self.curGoodData)
  self:RefreshGoodPage(self.curGoodData)
  self:UpdateIndicator()
end

function TimeLimitShopView:RefreshGoodPage(goodData)
  local ShopItemID = self:GetGoodID(goodData)
  xdlog("刷新商品界面", ShopItemID)
  self.curGoodData = goodData
  self.curGoodID = ShopItemID
  self.tipLabel.text = ZhString.TimeLimitShop_Tip_Donate
  if self:IsDepositGood(goodData) then
    self:RefreshDepositGoodPage(ShopItemID)
    return
  end
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(650, 1)
  if not shopData then
    redlog("没有指定商店类型信息")
    return
  end
  local shopItemData
  local goods = shopData:GetGoods()
  for k, good in pairs(goods) do
    if good.id == ShopItemID then
      shopItemData = good
      break
    end
  end
  if not shopItemData then
    redlog("没有找到指定商品", ShopItemID)
    return
  end
  self.shopItemData = shopItemData
  self.depositInfo = nil
  local itemData = shopItemData:GetItemData()
  IconManager:SetItemIcon(itemData.staticData.Icon, self.itemIcon)
  self.titleLabel.text = shopItemData.nameZh or ""
  self.price_Icon.gameObject:SetActive(true)
  self:UpdateRewardList(shopItemData.showInfo and shopItemData.showInfo[1], shopItemData.showInfo and shopItemData.showInfo[2])
  local superValue = 100
  local picture = ""
  for k, v in pairs(Table_ShopShow) do
    if v.ShopID == ShopItemID then
      superValue = v.SuperValue or 0
      picture = v.Picture
    end
  end
  if not IconManager:SetZenyShopItem(picture, self.itemIcon) then
    IconManager:SetItemIcon(itemData.staticData.Icon, self.itemIcon)
  end
  self.sale:SetActive(100 < superValue)
  self.saleLabel.text = superValue .. "%"
  self.price_Label.text = shopItemData.ItemCount or 0
  self.endTimeStamp = shopItemData.RemoveDate
  TimeTickManager.Me():ClearTick(self, 1)
  local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(shopItemData)
  if not canBuyCount or 0 < canBuyCount then
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshShopEndTime, self, 1)
  else
    self.timeLabel.text = ZhString.BattlePassUpgradeView_bought
    self.buyBtn:SetActive(false)
  end
end

function TimeLimitShopView:RefreshDepositGoodPage(depositID)
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositID)
  if not info then
    redlog("no deposit info", depositID)
    return
  end
  self.depositInfo = info
  self.shopItemData = nil
  local itemData = info:GetItemData()
  if itemData and itemData.staticData then
    IconManager:SetItemIcon(itemData.staticData.Icon, self.itemIcon)
    self.titleLabel.text = itemData.staticData.NameZh or ""
  else
    self.titleLabel.text = ""
  end
  local mainList, subList = NewRechargeProxy.Instance:findRmbShopInfo(depositID)
  self:UpdateRewardList(mainList, subList, info.productConf and info.productConf.Count or 1, info.itemID)
  self.sale:SetActive(false)
  self.price_Icon.gameObject:SetActive(false)
  self.price_Label.text = info.productConf.priceStr or info.productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(info.productConf.Rmb)
  self.endTimeStamp = self:GetDepositEndTimeStamp(depositID)
  self.tipLabel.text = self:IsFashionStarGiftDeposit(depositID) and ZhString.TimeLimitShop_Tip_FashionStar or ZhString.TimeLimitShop_Tip_Donate
  TimeTickManager.Me():ClearTick(self, 1)
  if info:IsSoldOut() or info.purchaseState == 0 then
    self.timeLabel.text = ZhString.BattlePassUpgradeView_bought
    self.buyBtn:SetActive(false)
    return
  end
  self.buyBtn:SetActive(true)
  if self.endTimeStamp and self.endTimeStamp > 0 then
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshShopEndTime, self, 1)
  else
    self.timeLabel.text = ""
  end
end

function TimeLimitShopView:UpdateRewardList(mainList, subList, fallbackNum, fallbackItemId)
  local result = {}
  if mainList then
    for i = 1, #mainList do
      local data = {}
      local itemid = mainList[i].itemid
      data.itemData = ItemData.new("Goods", itemid)
      data.num = mainList[i].num or 1
      table.insert(result, data)
    end
  end
  if subList then
    for i = 1, #subList do
      local data = {}
      local itemid = subList[i].itemid
      data.itemData = ItemData.new("Goods", itemid)
      data.num = subList[i].num or 1
      table.insert(result, data)
    end
  end
  if #result == 0 and fallbackItemId then
    table.insert(result, {
      itemData = ItemData.new("Goods", fallbackItemId),
      num = fallbackNum or 1
    })
  end
  if 3 < #result then
    self.itemScrollView.contentPivot = UIWidget.Pivot.Left
  else
    self.itemScrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.itemListCtrl:ResetDatas(result)
  self.itemScrollView:ResetPosition()
end

function TimeLimitShopView:GetGiftTimeLimitConfigByDepositId(depositID)
  if not depositID or not Table_GiftTimeLimit then
    return nil
  end
  for _, config in pairs(Table_GiftTimeLimit) do
    if config.Type == TimeLimitShopView.DepositType and config.DepositId == depositID then
      return config
    end
  end
  return nil
end

function TimeLimitShopView:IsFashionStarGiftDeposit(depositID)
  local fashionStarConfig = GameConfig.FashionStar and GameConfig.FashionStar.Deposit
  local giftTimeLimit = fashionStarConfig and fashionStarConfig.GiftTimeLimit
  if not giftTimeLimit then
    return false
  end
  local giftConfig = self:GetGiftTimeLimitConfigByDepositId(depositID)
  if not giftConfig then
    return false
  end
  for _, giftIds in pairs(giftTimeLimit) do
    for i = 1, #giftIds do
      if giftIds[i] == giftConfig.id then
        return true
      end
    end
  end
  return false
end

function TimeLimitShopView:GetDepositEndTimeStamp(depositID)
  local giftConfig = self:GetGiftTimeLimitConfigByDepositId(depositID)
  if not (giftConfig and giftConfig.LiveTime) or giftConfig.LiveTime <= 0 then
    return nil
  end
  return math.floor((ServerTime.CurServerTime() or 0) / 1000) + giftConfig.LiveTime
end

function TimeLimitShopView:RefreshShopEndTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.endTimeStamp then
    TimeTickManager.Me():ClearTick(self, 1)
    self.buyBtn:SetActive(false)
    self.timeLabel.text = ZhString.ActivityPuzzle_Outtime
    return
  elseif not self.buyBtn.activeSelf then
    self.buyBtn:SetActive(true)
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTimeStamp)
  if 0 < leftDay then
    self.timeLabel.text = string.format(ZhString.NoviceBattlePassRemainTime, leftDay, leftHour)
  elseif 0 < leftHour then
    self.timeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeHourMin, leftHour, leftMin)
  elseif 0 < leftMin or 0 < leftSec then
    self.timeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeMin, leftMin)
  end
end

function TimeLimitShopView:RefreshTweenShow()
  self.discount_TweenAlpha:ResetToBeginning()
  self.costNum_TweenAlpha:ResetToBeginning()
  self.discount_TweenAlpha:PlayForward()
  self.costNum_TweenAlpha:PlayForward()
end

function TimeLimitShopView:RecvQueryShopConfig()
  self:InitShow()
end

function TimeLimitShopView:RecvQueryChargeCnt()
  if not self.curGoodData or not self:IsDepositGood(self.curGoodData) then
    return
  end
  self:RefreshGoodPage(self.curGoodData)
  if self.waitQueryChargeRefresh then
    self.waitQueryChargeRefresh = false
    if self.depositInfo and (self.depositInfo:IsSoldOut() or self.depositInfo.purchaseState == 0) then
      TimeLimitShopProxy.Instance:RemoveGood(self.curGoodID, self:GetGoodType(self.curGoodData))
      self:CloseSelf()
    end
  end
end

function TimeLimitShopView:RecvBuyShopItem(note)
  local success = note.body.success
  xdlog("购买是否成功", success)
  if success then
    local id = note.body.id or self.curGoodID
    TimeLimitShopProxy.Instance:RemoveGood(id)
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(650, 1)
    if shopData then
      shopData:RemoveShopItemData(id)
    end
    self:CloseSelf()
  end
end

function TimeLimitShopView:HandleClickDepositItem()
  if not self.depositInfo then
    return
  end
  local cbfunc = function(count)
    self:PurchaseDeposit(self.depositInfo, count or 1)
  end
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() or BranchMgr.IsNOKR() then
    self:Invoke_DepositConfirmPanel(cbfunc)
  else
    cbfunc(1)
  end
end

function TimeLimitShopView:PurchaseDeposit(info, count)
  if not info then
    redlog("Purchase no info")
    return
  end
  local depositInfo = info
  local productConf = depositInfo.productConf
  local productID = depositInfo and depositInfo.productConf and depositInfo.productConf.ProductID
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
      LogUtility.Info("TimeLimitShopView:OnPaySuccess, " .. str_result)
      local currency = productConf and productConf.Rmb or 0
      ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      LogUtility.Warning("OnPaySuccess")
      NewRechargeProxy.CDeposit:SetFPRFlag2(productConf.id)
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      NewRechargeProxy.Instance:CallClientPayLog(113)
      self.waitQueryChargeRefresh = true
      ServiceUserEventProxy.Instance:CallQueryChargeCnt()
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("TimeLimitShopView:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("TimeLimitShopView:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("TimeLimitShopView:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("TimeLimitShopView:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("TimeLimitShopView:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks, count or 1)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function TimeLimitShopView:Invoke_DepositConfirmPanel(cb)
  local depositInfo = self.depositInfo
  local productConf = depositInfo and depositInfo.productConf
  local productID = productConf and productConf.ProductID
  if productID then
    local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
    local productPrice = productConf.Rmb
    local productCount = productConf.Count
    local currencyType = productConf.CurrencyType
    local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[productConf.id].Desc)
    local productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
    if BranchMgr.IsKorea() then
      productD = " [0075BCFF]" .. productDesc .. "[-] "
    end
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
      if cb then
        cb()
      end
    end)
  end
end

function TimeLimitShopView:handleClickItem(cellCtrl)
  xdlog("点击查看商品")
  local data = cellCtrl and cellCtrl.data
  local itemData = data and data.itemData
  if itemData then
    self.tipData.itemdata = itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {200, -150})
  end
end

function TimeLimitShopView:OnEnter()
  ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(650, 1)
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  TimeLimitShopView.super.OnEnter(self)
  PictureManager.Instance:SetUI("Gift_bg_03", self.bgTexture)
  PictureManager.Instance:SetUI("Gift_bg_title", self.titleTexture)
  TimeLimitShopProxy.Instance.showView = false
  self:InitShow()
  self:PlayUIEffect(EffectMap.UI.DisneyBubble, self.effectContainer)
end

function TimeLimitShopView:OnExit()
  PictureManager.Instance:UnLoadUI("Gift_bg_03", self.bgTexture)
  PictureManager.Instance:UnLoadUI("Gift_bg_title", self.titleTexture)
  TimeLimitShopView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  TimeLimitShopProxy.Instance:RemoveAllGoods()
end
