ActivityIntegrationTaskSubView = class("ActivityIntegrationTaskSubView", SubView)
autoImport("ActivityIntegrationTaskCell")
autoImport("NewRechargeGiftTipCell")
autoImport("NewHappyShopBuyItemCell")
autoImport("NewRechargeRecommendTShopGoodsCell")
autoImport("ActivityIntegrationShopItemCell")
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationTaskSubView")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()
local colorTheme = {
  [1] = {
    TimeColor = Color(1, 1, 1, 1),
    TimeEffectColor = Color(0.36470588235294116, 0.7411764705882353, 0.8313725490196079, 0.5),
    ShopTitle = Color(0.43529411764705883, 0.4392156862745098, 0.6549019607843137, 1),
    DescColor = Color(0.2784313725490196, 0.403921568627451, 0.6352941176470588, 1),
    LimitColor = Color(0.15294117647058825, 0.19607843137254902, 0.5137254901960784, 0.4),
    ConditionBgColor = Color(0.7372549019607844, 0.5215686274509804, 0.34509803921568627, 1)
  },
  [2] = {
    TimeColor = Color(0.10588235294117647, 0.27450980392156865, 0.5843137254901961, 1),
    TimeEffectColor = Color(0.36470588235294116, 0.7411764705882353, 0.8313725490196079, 0),
    ShopTitle = Color(0.43529411764705883, 0.5137254901960784, 0.6549019607843137, 1),
    DescColor = Color(0.37254901960784315, 0.5490196078431373, 0.3215686274509804, 1),
    LimitColor = Color(0.15294117647058825, 0.2784313725490196, 0.5137254901960784, 0.4),
    ConditionBgColor = Color(0.7372549019607844, 0.5215686274509804, 0.34509803921568627, 1)
  },
  [3] = {
    TimeColor = Color(0.10588235294117647, 0.27450980392156865, 0.5843137254901961, 1),
    TimeEffectColor = Color(0.36470588235294116, 0.7411764705882353, 0.8313725490196079, 0),
    ShopTitle = Color(0.43529411764705883, 0.5137254901960784, 0.6549019607843137, 1),
    DescColor = Color(0.2784313725490196, 0.403921568627451, 0.6352941176470588, 1),
    LimitColor = Color(0.06666666666666667, 0.13725490196078433, 0.49019607843137253, 0.4),
    ConditionBgColor = Color(0.7647058823529411, 0.2980392156862745, 0.3254901960784314, 1)
  },
  [4] = {
    TimeColor = Color(0.10588235294117647, 0.27450980392156865, 0.5843137254901961, 1),
    TimeEffectColor = Color(0.36470588235294116, 0.7411764705882353, 0.8313725490196079, 0),
    ShopTitle = Color(0.5411764705882353, 0.47058823529411764, 0.7529411764705882, 1),
    DescColor = Color(0.5411764705882353, 0.47058823529411764, 0.7529411764705882, 1),
    LimitColor = Color(0.2784313725490196, 0.047058823529411764, 0.4745098039215686, 0.4),
    ConditionBgColor = Color(0.4196078431372549, 0.3137254901960784, 0.4666666666666667, 1)
  }
}

function ActivityIntegrationTaskSubView:Init()
  if self.inited then
    return
  end
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvts()
  self.inited = true
end

function ActivityIntegrationTaskSubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityIntegrationTaskSubView"
  self.gameObject = obj
end

function ActivityIntegrationTaskSubView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.taskScrollView = self:FindGO("TaskScrollView", self.gameObject):GetComponent(UIScrollView)
  self.taskGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.taskListCtrl = UIGridListCtrl.new(self.taskGrid, ActivityIntegrationTaskCell, "ActivityIntegrationTaskCell")
  self.taskListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickTaskItem, self)
  self.taskListCtrl:AddEventListener(MouseEvent.DoubleClick, self.HandleShowItemTip, self)
  self.taskListCtrl:AddEventListener(UICellEvent.OnCellClicked, self.HandleBuyCell, self)
  self.bgTexture = self:FindGO("BgTexture", self.gameObject):GetComponent(UITexture)
  self.shopBg = self:FindGO("BG3", self.gameObject):GetComponent(UITexture)
  self.curConditionLabel = self:FindGO("CurConditionLabel", self.gameObject):GetComponent(UILabel)
  self.curConditionBg = self:FindGO("ConditionBg", self.gameObject):GetComponent(UISprite)
  self.shopItemGO = self:FindGO("ShopItemContainer")
  self.shopItemCell = ActivityIntegrationShopItemCell.new(self.shopItemGO)
  self.shopItemCell:AddEventListener(MouseEvent.MouseClick, self.HandleClickBuyItem, self)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:AddClickEvent(self.helpBtn, function()
    self.container:HandleClickHelpBtn(self.staticData.HelpID)
  end)
  self.shopTitleBg = self:FindGO("TitleBg", self.shopItemGO):GetComponent(UISprite)
  self.shopDescBg = self:FindGO("DesBg", self.shopItemGO):GetComponent(UISprite)
  self.shopLimitBg = self:FindGO("LimitBg", self.shopItemGO):GetComponent(UISprite)
end

function ActivityIntegrationTaskSubView:AddEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdNewServerChallengeSyncCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.ActivityCmdActPersonalTimeSyncCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshPage)
end

function ActivityIntegrationTaskSubView:HandleClickTaskItem(cellCtrl)
  local id = cellCtrl and cellCtrl.id
  xdlog("点击领取", self.activityID, id)
  ServiceActivityCmdProxy.Instance:CallNewServerChallengeRewardCmd(self.activityID, id)
end

function ActivityIntegrationTaskSubView:HandleShowItemTip(cellCtrl)
  local itemData = cellCtrl and cellCtrl.rewardCell and cellCtrl.rewardCell.data
  local sdata = {
    itemdata = itemData,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, cellCtrl.rewardCell.icon, nil, {-280, 0})
end

function ActivityIntegrationTaskSubView:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function ActivityIntegrationTaskSubView:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell")
  self.buyCell = NewHappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.gameObject:SetActive(false)
end

function ActivityIntegrationTaskSubView:InitGiftItemCell()
  local go = self:LoadCellPfb("NewRechargeGiftTipCell")
  self.giftCell = NewRechargeGiftTipCell.new(go)
  self.giftCell.RealConfirm = ActivityIntegrationTaskSubView.RealConfirm
  self.giftCell.gameObject:SetActive(false)
end

function ActivityIntegrationTaskSubView:RealConfirm()
  xdlog("RealConfirm")
  NewRechargeGiftTipCell.super.RealConfirm(self)
end

function ActivityIntegrationTaskSubView:RefreshPage(id)
  if not self.staticData then
    return
  end
  self.titleLabel.text = self.staticData.TitleName
  local helpID = self.staticData.HelpID
  self.helpBtn:SetActive(helpID ~= nil or false)
  self.endTime = nil
  local actPersonalData = Table_ActPersonalTimer[self.activityID]
  local baseOnCreate = ActivityIntegrationProxy.Instance:IsActBasedOnCreateDay(self.activityID)
  if not baseOnCreate then
    local isTF = EnvChannel.IsTFBranch()
    local duration = isTF and self.staticData.TFDuration or self.staticData.Duration
    self.startTime = duration[1] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[1])
    self.endTime = duration[2] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[2])
  else
    local closeOnDay = actPersonalData and actPersonalData.CloseOnAccDay
    if closeOnDay then
      local createDay = ActivityIntegrationProxy.Instance.createDay or 1
      if closeOnDay < createDay then
        redlog("时间错误  应该关闭")
      end
      self.endTime = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(ServerTime.CurServerTime() / 1000 + 86400 * (closeOnDay - createDay))
    elseif actPersonalData and actPersonalData.CloseDay then
      local allFinish = ActivityIntegrationProxy.Instance:IsChallengeAllFinish(self.activityID)
      if allFinish then
        local actPersonalInfo = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(self.activityID)
        self.endTime = actPersonalInfo and actPersonalInfo.endtime
      end
    end
  end
  if self.endTime then
    self.timeLabel.gameObject:SetActive(true)
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 10000, self.UpdateLeftTime, self)
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.gameObject:SetActive(false)
  end
  self:UpdateShopInfo()
  local processList = ActivityIntegrationProxy.Instance:GetChallengeProcessList(self.activityID)
  if not processList then
    return
  end
  local _HappyShopProxy = HappyShopProxy.Instance
  local result = {}
  for id, info in pairs(processList) do
    local config = Table_NewServerChallengeTarget[id]
    info.canBuy = false
    local shopItemID = config and config.ShopItemID
    local _shopItemData = shopItemID and ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.shopId, shopItemID)
    if _shopItemData then
      local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(_shopItemData)
      local maxLimit = _shopItemData.LimitNum
      if canBuyCount == 0 then
        info.canBuy = true
      end
    elseif config and config.DepositID then
      local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(config.DepositID)
      local purchasedTimes, purchaseLimitTimes
      purchasedTimes = info.purchaseTimes or 0
      purchaseLimitTimes = info.purchaseLimit_N or 0
      if purchasedTimes < purchaseLimitTimes then
        info.canBuy = true
      end
    end
    table.insert(result, info)
  end
  table.sort(result, function(l, r)
    local l_sortOrder, r_sortOrder
    if l.state == 1 then
      l_sortOrder = 1
    elseif l.canBuy then
      l_sortOrder = 2
    elseif l.state == 0 then
      l_sortOrder = 3
    elseif l.state == 2 then
      l_sortOrder = 4
    end
    if r.state == 1 then
      r_sortOrder = 1
    elseif r.canBuy then
      r_sortOrder = 2
    elseif r.state == 0 then
      r_sortOrder = 3
    elseif r.state == 2 then
      r_sortOrder = 4
    end
    if l_sortOrder ~= r_sortOrder then
      return l_sortOrder < r_sortOrder
    end
    local l_id = l.id
    local r_id = r.id
    if l_id ~= r_id then
      return l_id < r_id
    end
  end)
  self.taskListCtrl:ResetDatas(result)
  local commonProcess, activeGem, gemStar_Sliver, gemStar_Gold = 0, 0, 0, 0
  local allFinish = true
  local isGemCheck = false
  local cells = self.taskListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].state ~= 2 then
      allFinish = false
    end
    local id = cells[i].id
    local config = Table_NewServerChallengeTarget[id]
    if config then
      if config.TargetType == "gem_activate" then
        if activeGem == 0 or activeGem < cells[i].process then
          activeGem = cells[i].process
        end
        isGemCheck = true
      elseif config.TargetType == "gem_star" then
        local starSign = config.Param.min_star_sign
        if starSign == 1 then
          if gemStar_Sliver == 0 or gemStar_Sliver < cells[i].process then
            gemStar_Sliver = cells[i].process
          end
        elseif starSign == 2 and (gemStar_Gold == 0 or gemStar_Gold < cells[i].process) then
          gemStar_Gold = cells[i].process
        end
        isGemCheck = true
      elseif self.targetType then
        if config.TargetType == self.targetType and (commonProcess == 0 or commonProcess < cells[i].process) then
          commonProcess = cells[i].process
        end
      elseif commonProcess == 0 or commonProcess < cells[i].process then
        commonProcess = cells[i].process
      end
    end
  end
  if allFinish then
    if self.endTime and actPersonalData and actPersonalData.CloseDay then
      self.curConditionLabel.gameObject:SetActive(true)
      self.curConditionLabel.text = string.format(ZhString.ActivityIntegration_CloseDayTip, actPersonalData.CloseDay * 24)
      self.curConditionBg.width = self.curConditionLabel.printedSize.x + 100
    else
      self.curConditionLabel.gameObject:SetActive(false)
    end
  else
    local descStr = self.descStr or ""
    if isGemCheck then
      self.curConditionLabel.gameObject:SetActive(true)
      if self:HasReplaceInfo(descStr) then
        self.curConditionLabel.text = self:AdaptReplaceInfo(descStr, activeGem, gemStar_Sliver, gemStar_Gold)
      else
        self.curConditionLabel.text = string.format(self.descStr, activeGem, gemStar_Sliver, gemStar_Gold)
      end
    elseif self.descStr and self.descStr ~= "" then
      self.curConditionLabel.gameObject:SetActive(true)
      self.curConditionLabel.text = string.format(self.descStr, commonProcess)
    else
      self.curConditionLabel.gameObject:SetActive(false)
    end
    self.curConditionBg.width = self.curConditionLabel.printedSize.x + 100
  end
end

function ActivityIntegrationTaskSubView:RecvQueryShopConfig(note)
  self:UpdateShopInfo()
  self:UpdateTaskCellShopInfo()
end

function ActivityIntegrationTaskSubView:UpdateShopInfo()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.shopId)
  if not shopData then
    return
  end
  local config = shopData:GetGoods()
  local shopData
  for _, v in pairs(config) do
    if self.shopItemID then
      if self.shopItemID == v.id then
        shopData = v
        break
      end
    else
      shopData = v
      break
    end
  end
  if shopData then
    self.shopItemGO:SetActive(true)
    self.shopItemCell:SetData(shopData)
    if self.showShopID then
      self.shopItemCell:ReplaceIconByShopShow(self.showShopID)
    end
  else
    self.shopItemGO:SetActive(false)
  end
end

function ActivityIntegrationTaskSubView:UpdateTaskCellShopInfo()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.shopId)
  local shopDatas = shopData and shopData:GetGoods()
  local cells = self.taskListCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local single = cells[i]
      local config = Table_NewServerChallengeTarget[single.id]
      if config and config.ShopItemID then
        if shopDatas and shopDatas[config.ShopItemID] then
          single:SetShopItemData()
        end
      elseif config and config.DepositID then
        single:SetDepositData()
      end
    end
  end
end

function ActivityIntegrationTaskSubView:HandleClickBuyItem(cellctl)
  if self.currentItem ~= cellctl then
    if self.currentItem then
    end
    self.currentItem = cellctl
  end
  local data = cellctl.data
  if data and data.depositID then
    self:HandleClickDepositItem(cellctl)
  else
    self:HandleClickShopItem(data)
  end
end

function ActivityIntegrationTaskSubView:HandleBuyCell(cellCtrl)
  xdlog("Handle buycell")
  local shopItemData = cellCtrl.shopItemData
  if shopItemData then
    self:HandleClickShopItem(shopItemData)
  elseif cellCtrl.depositID then
    self:HandleClickDepositItem(cellCtrl)
  end
end

function ActivityIntegrationTaskSubView:HandleClickDepositItem(cellctl)
  local depositID = cellctl.depositID
  xdlog("click deposit", depositID)
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositID)
  if not info then
    redlog("no info")
    return
  end
  local cbfunc = function(count)
    if not self.endTime or self.endTime - ServerTime.CurServerTime() / 1000 > 0 then
      self:PurchaseDeposit(info, count)
    end
  end
  local m_funcRmbBuy = function(count)
    if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
      self:Invoke_DepositConfirmPanel(cbfunc)
    else
      cbfunc(count)
    end
  end
  local tbItem = Table_Item[info.itemID]
  if tbItem ~= nil and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
    self.giftCell.gameObject:SetActive(true)
    self.giftCell:SetData(info, m_funcRmbBuy)
  else
    self.buyCell.gameObject:SetActive(true)
    self:UpdateBuyItemInfo(info, m_funcRmbBuy)
  end
end

function ActivityIntegrationTaskSubView:PurchaseDeposit(info, count)
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
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPaySuccess, " .. str_result)
      local currency = productConf and productConf.Rmb or 0
      ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      LogUtility.Warning("OnPaySuccess")
      NewRechargeProxy.CDeposit:SetFPRFlag2(productConf.id)
      xdlog(NewRechargeProxy.CDeposit:IsFPR(productID))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      NewRechargeProxy.Instance:CallClientPayLog(113)
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
    FuncPurchase.Instance():Purchase(productConf.id, callbacks, count)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function ActivityIntegrationTaskSubView:Invoke_DepositConfirmPanel(cb)
  local depositInfo = self.currentItem.data and self.currentItem.data.info
  local productConf = depositInfo.productConf
  local productID = depositInfo and depositInfo.productConf and depositInfo.productConf.ProductID
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

function ActivityIntegrationTaskSubView:HandleClickShopItem(shopItemData)
  xdlog("click shop item")
  local id = shopItemData and shopItemData.id
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.shopId, id)
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    local goodsID = data.goodsID
    local tbItem = Table_Item[goodsID]
    if tbItem and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
      self.buyCell.gameObject:SetActive(false)
      self.giftCell.gameObject:SetActive(true)
      self.giftCell:SetData(data)
      HappyShopProxy.Instance:SetSelectId(data.id)
    else
      self.giftCell.gameObject:SetActive(false)
      self.buyCell.gameObject:SetActive(true)
      self:UpdateBuyItemInfo(data)
    end
  end
end

function ActivityIntegrationTaskSubView:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("HarpView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

function ActivityIntegrationTaskSubView:UpdateBuyItemInfo(data, funcBuy)
  if data then
    local itemType = data.itemtype
    local positionX, positionY = self:GetScreenTouchedPos()
    if 0 < positionX then
      self.buyCell:updateLocalPostion(-217)
    else
      self.buyCell:updateLocalPostion(300)
    end
    self.buyCell:SetData(data, funcBuy)
    TipsView.Me():HideCurrent()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

local tipData, tipOffset = {}, {0, -90}

function ActivityIntegrationTaskSubView:ShowGoodsItemTip(itemConfID)
  if itemConfID ~= nil then
    tipData.itemdata = ItemData.new(nil, itemConfID)
    TipManager.Instance:ShowItemFloatTip(tipData, nil, NGUIUtil.AnchorSide.Center, tipOffset)
  end
end

function ActivityIntegrationTaskSubView:ShowShopItemPurchaseDetail(data)
  local shop_item_data = data.info
  if self.parentView and shop_item_data then
    self.giftCell:SetData(shop_item_data)
    HappyShopProxy.Instance:SetSelectId(shop_item_data.id)
  end
end

function ActivityIntegrationTaskSubView:UpdateLeftTime()
  if not self.endTime then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.gameObject:SetActive(false)
    return
  end
  local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
  if 0 < leftTime then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
    if 0 < day then
      timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
      self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
    else
      timeText = string.format("%02d:%02d:%02d", hour, min, sec)
      self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
    end
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.text = ZhString.RememberLoginView_OntimeEnd
  end
end

function ActivityIntegrationTaskSubView:HasReplaceInfo(desc)
  if StringUtil.IsEmpty(desc) then
    return
  end
  for str in string.gmatch(desc, "%[(.-)%]") do
    if str and str ~= "" then
      return true
    end
  end
  return false
end

function ActivityIntegrationTaskSubView:AdaptReplaceInfo(desc, active, gem_sliver, gem_gold)
  if StringUtil.IsEmpty(desc) then
    return
  end
  return string.gsub(desc, "%[(.-)%]", function(str)
    if str == "gem_star_gold" then
      return gem_gold
    elseif str == "gem_star_sliver" then
      return gem_sliver
    elseif str == "gem_activate" then
      return active
    end
  end)
end

function ActivityIntegrationTaskSubView:ResetColorTheme(index)
  local themeConfig = colorTheme[self.colorTheme]
  if not themeConfig then
    return
  end
  xdlog("颜色主题变更")
  self.timeLabel.color = themeConfig.TimeColor
  self.timeLabel.effectColor = themeConfig.TimeEffectColor
  self.shopTitleBg.color = themeConfig.ShopTitle
  self.shopDescBg.color = themeConfig.DescColor
  self.shopLimitBg.color = themeConfig.LimitColor
  self.curConditionBg.color = themeConfig.ConditionBgColor
end

local itemClickUrlTipData = {}

function ActivityIntegrationTaskSubView:OnClickItemUrl(id)
  if not next(itemClickUrlTipData) then
    itemClickUrlTipData.itemdata = ItemData.new()
  end
  itemClickUrlTipData.itemdata:ResetData("itemClickUrl", id)
  
  function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
    TipManager.Instance:CloseTip()
    itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
    self:ShowClickItemUrlTip(itemClickUrlTipData)
  end
  
  self:ShowClickItemUrlTip(itemClickUrlTipData)
end

local clickItemUrlTipOffset = {196, 0}

function ActivityIntegrationTaskSubView:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function ActivityIntegrationTaskSubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  ActivityIntegrationTaskSubView.super.OnEnter(self)
  self.activityID = self.staticData.Params and self.staticData.Params.ActivityId
  if not self.activityID then
    redlog("活动ID不存在")
    return
  end
  local actPersonConfig = Table_ActPersonalTimer[self.activityID]
  local params = actPersonConfig and actPersonConfig.Misc
  self.shopShowID = params and params.ShopShowID
  self.shopType = params and params.ShopType
  self.shopId = params and params.ShopId
  self.shopItemID = params and params.ShopItemID
  xdlog("ShopShow", self.shopShowID, self.shopType, self.shopId)
  self.descStr = params and params.Des and OverSea.LangManager.Instance():GetLangByKey(params.Des)
  self.showShopID = params and params.ShopShowID
  self.targetType = params and params.TargetType
  local params = self.staticData.Params
  self.textureName = params and params.Texture
  picIns:SetUI(self.textureName, self.bgTexture)
  picIns:SetUI("openactivity_bottom_01", self.shopBg)
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.shopId)
  HappyShopProxy.Instance:InitShop(nil, self.shopId, self.shopType)
  if not self.buyCell then
    self:InitBuyItemCell()
  end
  if not self.giftCell then
    self:InitGiftItemCell()
  end
  self.buyCell.gameObject:SetActive(false)
  self.giftCell.gameObject:SetActive(false)
  local colorTheme = params and params.ColorTheme or 1
  if not self.colorTheme or colorTheme ~= self.colorTheme then
    self.colorTheme = colorTheme
    self:ResetColorTheme()
  end
  self:RefreshPage(id)
end

function ActivityIntegrationTaskSubView:OnExit()
  ActivityIntegrationTaskSubView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  picIns:UnLoadUI(self.textureName, self.bgTexture)
  picIns:UnLoadUI("openactivity_bottom_01", self.shopBg)
  self.textureName = nil
end
