autoImport("PaySignRewardCell")
autoImport("PaySignConfig")
autoImport("NewRechargeGiftTipCell")
autoImport("NewHappyShopBuyItemCell")
PaySignRewardView = class("PaySignRewardView", ContainerView)
PaySignRewardView.ViewType = UIViewType.NormalLayer
local _STATUS_BTN = {
  [1] = {
    ZhString.PaySignRewardView_Receive,
    "new-com_btn_02",
    UILabel.Effect.Outline
  },
  [2] = {
    ZhString.PaySignRewardView_Wait,
    "new-com_btn_03",
    UILabel.Effect.None
  },
  [3] = {
    ZhString.PaySignRewardView_Finished,
    "new-com_btn_03",
    UILabel.Effect.None
  }
}
local SIGN_STYLE_COMMON = {
  {
    bg_spriteName = "sign_bg_day1",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8baadf",
    cat_spriteName = "sign_pic_cat_day1",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day2",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "778ee0",
    cat_spriteName = "sign_pic_cat_day2",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day3",
    bg2_Color = "aeb5fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8290d2",
    cat_spriteName = "sign_pic_cat_day3",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day4",
    bg2_Color = "abacfe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "7971d9",
    cat_spriteName = "sign_pic_cat_day4",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day5",
    bg2_Color = "a6a3fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "8366cc",
    cat_spriteName = "sign_pic_cat_day5",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day6",
    bg2_Color = "a69efe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "7858b3",
    cat_spriteName = "sign_pic_cat_day6",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day7",
    bg2_Color = "f2baa8",
    bg3_spriteName = "sign_bg_icon2",
    bg4_Color = "f1deb2",
    index_Color = "ff9656",
    cat_spriteName = "sign_pic_cat_day7",
    embeSp_Color = "9a655e"
  }
}
local SIGN_STYLE_INCLUDESHOP = {
  {
    bg_spriteName = "sign_bg_day1",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8baadf",
    cat_spriteName = "sign_pic_cat_day1",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day2",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "778ee0",
    cat_spriteName = "sign_pic_cat_day2",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day2",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "778ee0",
    cat_spriteName = "sign_pic_cat_day2",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day3",
    bg2_Color = "aeb5fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8290d2",
    cat_spriteName = "sign_pic_cat_day3",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day4",
    bg2_Color = "abacfe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "7971d9",
    cat_spriteName = "sign_pic_cat_day4",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day5",
    bg2_Color = "a6a3fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "8366cc",
    cat_spriteName = "sign_pic_cat_day5",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day6",
    bg2_Color = "a69efe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "7858b3",
    cat_spriteName = "sign_pic_cat_day6",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day7",
    bg2_Color = "f2baa8",
    bg3_spriteName = "sign_bg_icon2",
    bg4_Color = "f1deb2",
    index_Color = "ff9656",
    cat_spriteName = "sign_pic_cat_day7",
    embeSp_Color = "9a655e"
  }
}
local tempVector3 = LuaVector3.Zero()

function PaySignRewardView:Init()
  self.actID = self.viewdata.viewdata.id
  self.actConfigData = PaySignConfig.new(self.actID)
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function PaySignRewardView:OnEnter()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  self.super.OnEnter(self)
  local shopInfo = PaySignProxy.Instance:GetShopInfo(self.actID)
  if shopInfo then
    if shopInfo.DepositID then
      ServiceUserEventProxy.Instance:CallQueryChargeCnt()
    elseif shopInfo.ShopId and shopInfo.ShopType then
      self.shopType = shopInfo.ShopType
      self.shopId = shopInfo.ShopId
      ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.shopId)
      HappyShopProxy.Instance:InitShop(nil, self.shopId, self.shopType)
    end
  end
end

function PaySignRewardView:OnExit()
  self.super.OnExit(self)
  TipsView.Me():HideCurrent()
  self:_DestroyEffect()
  PictureManager.Instance:UnLoadPaySignIn()
end

function PaySignRewardView:_DestroyEffect()
  if not self.effect then
    return
  end
  local cacheEffect
  for i = #self.effect, 1, -1 do
    cacheEffect = self.effect[i]
    if cacheEffect then
      if cacheEffect:Alive() then
        cacheEffect:Destroy()
      end
      self.effect[i] = nil
    end
  end
  self.effect = nil
end

function PaySignRewardView:FindObjs()
  self.descLab1 = self:FindComponent("DescLab1", UILabel)
  self.descLab3 = self:FindComponent("DescLab3", UILabel)
  self.timeLab = self:FindComponent("TimeLab", UILabel)
  self.rewardBtn = self:FindGO("RewardButton")
  self.rewardSpr = self.rewardBtn:GetComponent(UISprite)
  self.rewardLab = self:FindComponent("Lab", UILabel, self.rewardBtn)
  self:AddClickEvent(self.rewardBtn, function()
    self:OnRewardButton()
  end)
  self.cellContainer = self:FindGO("CellContainer")
  self.cellGrid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.effectParent = self:FindGO("Effect")
  self:PlayUIEffect(EffectMap.UI.PaySignRewardView, self.effectParent)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
  self:InitGiftItemCell()
end

function PaySignRewardView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function PaySignRewardView:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell", self.gameObject)
  self.buyCell = NewHappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.gameObject:SetActive(false)
end

function PaySignRewardView:InitGiftItemCell()
  local go = self:LoadCellPfb("NewRechargeGiftTipCell", self.gameObject)
  self.giftCell = NewRechargeGiftTipCell.new(go)
  self.giftCell.gameObject:SetActive(false)
end

local itemClickUrlTipData = {}

function PaySignRewardView:OnClickItemUrl(id)
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

function PaySignRewardView:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function PaySignRewardView:OnTipFashionPreviewShow(preview)
  self.CloseWhenClickOtherPlace:AddTarget(preview.gameObject.transform)
end

function PaySignRewardView:OnTipFashionPreviewClose()
  self.CloseWhenClickOtherPlace:ReCalculateBound()
end

function PaySignRewardView:AddEvts()
  self:AddListenEvt(ServiceEvent.NUserPaySignRewardUserCmd, self.HandleSign)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.HandleShopUpdate)
end

function PaySignRewardView:InitView()
  self.actData = PaySignProxy.Instance:GetInfoMap(self.actID)
  if self.actConfigData:IsNoviceMode() then
    self:Hide(self.timeLab)
  else
    self:Show(self.timeLab)
    self.timeLab.text = PaySignProxy.Instance:GetActTime(self.actID)
  end
  self.descLab1.text = self.actConfigData:GetEntryDesc()
  self.descLab3.text = self.actConfigData:GetEntryRechargeDesc()
  self.effect = {}
  self.effectContainer = {}
  self.reward = {}
  self:Refresh()
end

function PaySignRewardView:RefreshReward()
  local shopInfo = PaySignProxy.Instance:GetShopInfo(self.actID)
  self.hasShop = shopInfo ~= nil
  local _pageStype = self.hasShop and SIGN_STYLE_INCLUDESHOP or SIGN_STYLE_COMMON
  local prepTab = PaySignProxy.Instance:GetConfig_PaySign(self.actID)
  local cellNum = #prepTab + (self.hasShop and 1 or 0)
  self.cellGrid.cellWidth = self.hasShop and 157.7 or 183
  local rewardDay = self.actData.rewardDay
  local unrewardDay = self.actData.unrewardDay
  for i = 1, cellNum do
    if not self.reward[i] then
      local rootGO = self:FindGO("Root" .. i, self.cellContainer)
      rootGO:SetActive(true)
      local cellPath = self.hasShop and "cell/PaySignRewardCell_S" or "cell/PaySignRewardCell"
      local cell = self:LoadPreferb(cellPath, self:FindGO("RewardRoot" .. i, rootGO))
      self.reward[i] = PaySignRewardCell.new(cell)
      if prepTab[i] then
        self.reward[i]:SetData(prepTab[i])
      elseif i == cellNum then
        self.reward[i]:SetData(shopInfo)
      end
      self.reward[i]:SetStyle(_pageStype[i])
      self.effectContainer[i] = self:FindGO("EffContainer" .. i)
      self.reward[i]:AddEventListener(UICellEvent.OnCellClicked, self.OnRewardButton, self)
      self.reward[i]:AddEventListener(UICellEvent.OnLeftBtnClicked, self.HandleBuyCell, self)
    end
    self.reward[i]:SetFinishFlag(self.actData.rewardDay and i <= self.actData.rewardDay)
    self.reward[i]:SetSignBtnActive(i > rewardDay and i <= rewardDay + unrewardDay)
    self.reward[i]:SetLock(i > rewardDay + unrewardDay and i < cellNum)
    if i <= self.actData.rewardDay then
      if self.effect[i] then
        self.effect[i]:SetActive(false)
      end
    elseif i <= self.actData.unrewardDay + self.actData.rewardDay and i > self.actData.rewardDay then
      if nil == self.effect[i] then
        self:PlayUIEffect(EffectMap.UI.PaidCheckln_ui_remind, self.effectContainer[i], false, function(obj, args, assetEffect)
          self.effect[i] = assetEffect
          self.effect[i]:SetActive(true)
        end)
      else
        self.effect[i]:SetActive(true)
      end
    elseif self.effect[i] then
      self.effect[i]:SetActive(false)
    end
  end
end

function PaySignRewardView:Refresh()
  redlog("PaySignRewardView:", self.actData.status)
  local statuscfg = _STATUS_BTN[self.actData.status]
  self.rewardLab.text = statuscfg[1]
  self.rewardSpr.spriteName = statuscfg[2]
  self.rewardLab.effectStyle = statuscfg[3]
  self:RefreshReward()
end

function PaySignRewardView:OnRewardButton()
  if PaySignProxy.RECEIVE_REWARD_STATUS.CANRECEIVE ~= PaySignProxy.Instance:GetActStatus(self.actID) then
    return
  end
  xdlog("申请签到")
  ServiceNUserProxy.Instance:CallPaySignRewardUserCmd(self.actID)
end

function PaySignRewardView:HandleSign()
  self.actData = PaySignProxy.Instance:GetInfoMap(self.actID)
  self:Refresh()
end

function PaySignRewardView:HandleShopUpdate()
  if self.hasShop then
    self.reward[#self.reward]:RefreshSelf()
  end
end

function PaySignRewardView:HandleBuyCell(cellCtrl)
  xdlog("Handle buycell")
  local shopItemData = cellCtrl.shopItemData
  if shopItemData then
    self:HandleClickShopItem(shopItemData)
  elseif cellCtrl.data and cellCtrl.data.DepositID then
    self:HandleClickDepositItem(cellCtrl)
  end
end

function PaySignRewardView:HandleClickShopItem(shopItemData)
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

function PaySignRewardView:GetScreenTouchedPos()
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

function PaySignRewardView:UpdateBuyItemInfo(data, funcBuy)
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

function PaySignRewardView:HandleClickDepositItem(cellctl)
  local depositID = cellctl and cellctl.data and cellctl.data.DepositID
  xdlog("click deposit", depositID)
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositID)
  if not info then
    redlog("no info")
    return
  end
  local cbfunc = function(count)
    self:PurchaseDeposit(info, count)
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

function PaySignRewardView:PurchaseDeposit(info, count)
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

function PaySignRewardView:Invoke_DepositConfirmPanel(cb)
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
