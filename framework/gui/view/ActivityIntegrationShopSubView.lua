ActivityIntegrationShopSubView = class("ActivityIntegrationShopSubView", SubView)
autoImport("ActivityIntegrationShopItemCell")
autoImport("NewRechargeGiftTipCell")
autoImport("NewHappyShopBuyItemCell")
local viewPath = ResourcePathHelper.UIView("ActivityIntegrationShopSubView")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()

function ActivityIntegrationShopSubView:Init()
  if self.inited then
    return
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self.inited = true
end

function ActivityIntegrationShopSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "ActivityIntegrationShopSubView"
end

function ActivityIntegrationShopSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("ActivityIntegrationShopSubView")
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.shopScrollView = self:FindGO("ShopScrollView", self.gameObject):GetComponent(UIScrollView)
  self.shopGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.shopListCtrl = UIGridListCtrl.new(self.shopGrid, ActivityIntegrationShopItemCell, "NewRechargeCommonGoodsCellType2")
  self.shopListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.goGachaCoinBalance = self:FindGO("GachaCoinBalance", self.gameObject)
  self.goLabGachaCoinBalance = self:FindGO("Lab", self.goGachaCoinBalance)
  self.labGachaCoinBalance = self.goLabGachaCoinBalance:GetComponent(UILabel)
  self.spGachaCoin = self:FindGO("Icon", self.goGachaCoinBalance):GetComponent(UISprite)
  self.goGachaCoinBalance2 = self:FindGO("GachaCoinBalance2", self.gameObject)
  self.goLabGachaCoinBalance2 = self:FindGO("Lab", self.goGachaCoinBalance2)
  self.labGachaCoinBalance2 = self.goLabGachaCoinBalance2:GetComponent(UILabel)
  self.spGachaCoin2 = self:FindGO("Icon", self.goGachaCoinBalance2):GetComponent(UISprite)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
  self:InitGiftItemCell()
end

function ActivityIntegrationShopSubView:AddViewEvts()
  self:AddClickEvent(self.helpBtn, function()
    self.container:HandleClickHelpBtn(self.staticData.HelpID)
  end)
end

function ActivityIntegrationShopSubView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RecvQueryShopConfig)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateBalance)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBalance)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdateBalance)
end

function ActivityIntegrationShopSubView:InitDatas()
end

function ActivityIntegrationShopSubView:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function ActivityIntegrationShopSubView:RefreshPage(id)
  self.titleLabel.text = self.staticData.TitleName
  local helpID = self.staticData.HelpID
  self.helpBtn:SetActive(helpID ~= nil or false)
  local isTF = EnvChannel.IsTFBranch()
  local duration = isTF and self.staticData.TFDuration or self.staticData.Duration
  self.startTime = duration[1] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[1])
  self.endTime = duration[2] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[2])
  self.timeLabel.gameObject:SetActive(true)
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 10000, self.UpdateLeftTime, self)
  if self.shopItemID then
    local itemData = Table_Item[self.shopItemID]
    IconManager:SetItemIcon(itemData.Icon, self.spGachaCoin)
  end
  self.goGachaCoinBalance2:SetActive(self.shopItemID2 ~= nil)
  if self.shopItemID2 then
    local itemData = Table_Item[self.shopItemID2]
    IconManager:SetItemIcon(itemData.Icon, self.spGachaCoin2)
  end
  self:UpdateBalance()
  self:UpdateShopInfo()
end

function ActivityIntegrationShopSubView:UpdateLeftTime()
  if not self.endTime then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.gameObject:SetActive(false)
  else
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
      self.timeLabel.gameObject:SetActive(false)
    end
  end
end

function ActivityIntegrationShopSubView:RecvQueryShopConfig(note)
  self:UpdateShopInfo()
end

function ActivityIntegrationShopSubView:UpdateShopInfo()
  if not self.shopItems then
    self.shopItems = {}
  else
    TableUtility.ArrayClear(self.shopItems)
  end
  if self.depositIDs and #self.depositIDs > 0 then
    for i = 1, #self.depositIDs do
      if ShopProxy.Instance:GetDepositItemCanBuy(self.depositIDs[i]) then
        local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.depositIDs[i])
        local tempData = {
          depositID = self.depositIDs[i],
          info = info,
          ShopOrder = self.depositIDs[i],
          id = self.depositIDs[i]
        }
        TableUtility.ArrayPushBack(self.shopItems, tempData)
      end
    end
  end
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.shopId)
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      TableUtility.ArrayPushBack(self.shopItems, v)
    end
  end
  local _HappyShopProxy = HappyShopProxy.Instance
  table.sort(self.shopItems, function(l, r)
    local l_DepositID = l.depositID or 999
    local r_DepositID = r.depositID or 999
    local lCanByCount = 999
    local rCanByCount = 999
    if l.depositID then
      lCanByCount = l.info:IsSoldOut() and 0 or 999
    else
      lCanByCount = _HappyShopProxy:GetCanBuyCount(l) or 999
    end
    if r.depositID then
      rCanByCount = r.info:IsSoldOut() and 0 or 999
    else
      rCanByCount = _HappyShopProxy:GetCanBuyCount(r) or 999
    end
    if lCanByCount and rCanByCount then
      if 0 < lCanByCount and 0 < rCanByCount then
        if l_DepositID ~= r_DepositID then
          return l_DepositID < r_DepositID
        elseif l.ShopOrder == r.ShopOrder then
          return l.id < r.id
        else
          return l.ShopOrder < r.ShopOrder
        end
      else
        return lCanByCount > rCanByCount
      end
    end
    if l_DepositID ~= r_DepositID then
      return l_DepositID < r_DepositID
    end
  end)
  self.shopListCtrl:ResetDatas(self.shopItems)
  self.shopScrollView:ResetPosition()
end

function ActivityIntegrationShopSubView:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell")
  self.buyCell = NewHappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.gameObject:SetActive(false)
end

function ActivityIntegrationShopSubView:InitGiftItemCell()
  local go = self:LoadCellPfb("NewRechargeGiftTipCell")
  self.giftCell = NewRechargeGiftTipCell.new(go)
  self.giftCell.gameObject:SetActive(false)
end

function ActivityIntegrationShopSubView:HandleClickItem(cellctl)
  if self.currentItem ~= cellctl then
    if self.currentItem then
    end
    self.currentItem = cellctl
  end
  local data = cellctl.data
  if data and data.depositID then
    self:HandleClickDepositItem(cellctl)
  else
    self:HandleClickShopItem(cellctl)
  end
end

function ActivityIntegrationShopSubView:HandleClickDepositItem(cellctl)
  local depositID = cellctl.depositID
  local info = cellctl.data and cellctl.data.info
  local cbfunc = function(count)
    local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
    if 0 < leftTime then
      self:PurchaseDeposit(count)
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

function ActivityIntegrationShopSubView:PurchaseDeposit(count)
  if not self.currentItem then
    return
  end
  local depositInfo = self.currentItem.data and self.currentItem.data.info
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

function ActivityIntegrationShopSubView:Invoke_DepositConfirmPanel(cb)
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

function ActivityIntegrationShopSubView:HandleClickShopItem(cellctl)
  local id = cellctl and cellctl.data and cellctl.data.id
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.shopId, id)
  local go = cellctl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
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
    self:UpdateBuyItemInfo(data)
  end
end

function ActivityIntegrationShopSubView:GetScreenTouchedPos()
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

function ActivityIntegrationShopSubView:UpdateBuyItemInfo(data, funcBuy)
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

local itemClickUrlTipData = {}

function ActivityIntegrationShopSubView:OnClickItemUrl(id)
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

function ActivityIntegrationShopSubView:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function ActivityIntegrationShopSubView:OnTipFashionPreviewShow(preview)
  self.CloseWhenClickOtherPlace:AddTarget(preview.gameObject.transform)
end

function ActivityIntegrationShopSubView:OnTipFashionPreviewClose()
  self.CloseWhenClickOtherPlace:ReCalculateBound()
end

function ActivityIntegrationShopSubView:UpdateBalance()
  local coinNum = BagProxy.Instance:GetItemNumByStaticID(self.shopItemID)
  local milCommaBalance = FunctionNewRecharge.FormatMilComma(coinNum)
  if milCommaBalance then
    self.labGachaCoinBalance.text = milCommaBalance
  end
  if self.shopItemID2 then
    coinNum = BagProxy.Instance:GetItemNumByStaticID(self.shopItemID2)
    milCommaBalance = FunctionNewRecharge.FormatMilComma(coinNum) or 0
    if milCommaBalance then
      self.labGachaCoinBalance2.text = milCommaBalance
    end
  end
end

function ActivityIntegrationShopSubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  local params = self.staticData.Params
  self.shopType = params and params.ShopType
  self.shopId = params and params.ShopId
  self.shopItemID = params and params.ShopItemID or 151
  self.shopItemID2 = params and params.ShopItemID2
  local depositIDs = params and params.DepositIDs
  if not self.depositIDs then
    self.depositIDs = {}
  else
    TableUtility.ArrayClear(self.depositIDs)
  end
  if depositIDs and 0 < #depositIDs then
    TableUtility.ArrayShallowCopy(self.depositIDs, depositIDs)
    ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  end
  ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.shopId)
  HappyShopProxy.Instance:InitShop(nil, self.shopId, self.shopType)
  self:RefreshPage(id)
  ActivityIntegrationShopSubView.super.OnEnter(self)
end

function ActivityIntegrationShopSubView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  ActivityIntegrationShopSubView.super.OnExit(self)
end
