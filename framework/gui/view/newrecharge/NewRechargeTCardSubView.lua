autoImport("NewRechargeCommonSubView")
NewRechargeTCardSubView = class("NewRechargeTCardSubView", NewRechargeCommonSubView)
NewRechargeTCardSubView.Tab = GameConfig.NewRecharge.TabDef.Card
NewRechargeTCardSubView.innerTab = {MonthlyVIP = 1, EP = 2}
NewRechargeTCardSubView.bg_Tex_Name = "mall_bg_decorate_10"

function NewRechargeTCardSubView:Func_AddListenEvent()
  EventManager.Me():AddEventListener(LotteryEvent.MagicPictureComplete, self.HandlePicture, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryAccChargeCntReward, self.HandleAccChargeCntReward, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeQueryCmd, self.OnReceiveChargeQuery, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
end

function NewRechargeTCardSubView:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(LotteryEvent.MagicPictureComplete, self.HandlePicture, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryAccChargeCntReward, self.HandleAccChargeCntReward, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeQueryCmd, self.OnReceiveChargeQuery, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
end

function NewRechargeTCardSubView:HandlePicture(note)
  local data = note.body
  if data and self.monthCardUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end

function NewRechargeTCardSubView:HandleAccChargeCntReward(note)
  if self.gameObject.name ~= "NewRechargeTCardSubView" then
    return
  end
  if self.innerSelectTab == self.innerTab.MonthlyVIP then
    self:ShowCard_MonthlyVIP(self.isCover or true)
    self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
  elseif self.innerSelectTab == self.innerTab.EP then
    self:ShowCard_EP(self.isCover or true, self.showEPCardIndex)
  end
end

function NewRechargeTCardSubView:OnReceivePurchaseSuccess(message)
  local messageContent = message
  local confID = messageContent.dataid
  if confID and 0 < confID then
    local conf = Table_Deposit[confID]
    if conf and conf.Type == 2 then
      PurchaseDeltaTimeLimit.Instance():End(conf.ProductID)
    elseif conf and conf.Type == 5 then
      PurchaseDeltaTimeLimit.Instance():End(conf.ProductID)
    end
  end
  if self.innerSelectTab == self.innerTab.MonthlyVIP then
    NewRechargeProxy.Instance:CallClientPayLog(111)
  end
end

function NewRechargeTCardSubView:OnReceiveChargeQuery(data)
  helplog("---OnReceiveChargeQuery(data)---")
  if not self.monthlyVIPShopItemConf then
    return
  end
  if not self.inited then
    return
  end
  if data.data_id == self.monthlyVIPShopItemConf.id then
    self.monthlyVIPShopItemChargedCount = data.charged_count
  end
  if self.showEPCardIndex and self.showEPCardIndex == 0 then
    if self.innerSelectTab == self.innerTab.MonthlyVIP then
      self:ShowCard_MonthlyVIP(self.isCover or true)
    else
      self:UpdateMonthlyVIPLeftCanBuy()
    end
  end
  if self.queryChargeAndPurchaseMonthlyVIPCard then
    self.queryChargeAndPurchaseMonthlyVIPCard = nil
    if data.data_id == self.monthlyVIPShopItemConf.id then
      if data.ret then
        self:Purchase()
      else
        local depositData = Table_Deposit[data.data_id]
        helplog("111 data.data_id:" .. data.data_id)
        if depositData and depositData.MonthLimit then
          local purchaseLimit = depositData.MonthLimit
          local tabFormatParams = {purchaseLimit}
          if depositData.Type == 2 then
            MsgManager.ShowMsgByIDTable(2645, tabFormatParams)
          elseif depositData.Type == 5 then
            MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
          else
            redlog("There's something wrong with OnReceiveChargeQuery")
          end
        end
      end
    end
  end
end

function NewRechargeTCardSubView:OnReceiveQueryChargeCnt(data)
  if self.queryChargeAndPurchaseEPCardID ~= nil then
    local purchaseTimes = 0
    local info = data.info
    for i = 1, #info do
      local purchaseInfo = info[i]
      local productConfID = purchaseInfo.dataid
      if productConfID == self.queryChargeAndPurchaseEPCardID then
        purchaseTimes = purchaseInfo.count
      end
    end
    local productConf = Table_Deposit[self.queryChargeAndPurchaseEPCardID]
    if purchaseTimes < productConf.MonthLimit then
      self:Purchase()
    elseif self.dazhe then
      productConf = Table_Deposit[self.budazheid]
      if purchaseTimes < productConf.MonthLimit then
        self:Purchase(self.budazheid)
      elseif productConf.MonthLimit then
        local purchaseLimit = productConf.MonthLimit
        local tabFormatParams = {purchaseLimit}
        if productConf.Type == 2 then
          MsgManager.ShowMsgByIDTable(2645, tabFormatParams)
        elseif productConf.Type == 5 then
          MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
        else
          helplog("bug")
        end
      end
    elseif productConf.MonthLimit then
      local purchaseLimit = productConf.MonthLimit
      local tabFormatParams = {purchaseLimit}
      if productConf.Type == 2 then
        MsgManager.ShowMsgByIDTable(2645, tabFormatParams)
      elseif productConf.Type == 5 then
        MsgManager.ShowMsgByIDTable(31020, tabFormatParams)
      else
        helplog("bug")
      end
    end
    self.queryChargeAndPurchaseEPCardID = nil
  end
  if self.showEPCardIndex and 0 < self.showEPCardIndex then
    self:UpdateEPCardUIByChargeCntTable()
  end
  if self.innerSelectTab == self.innerTab.MonthlyVIP then
    self:ShowCard_MonthlyVIP(self.isCover)
  elseif self.innerSelectTab == self.innerTab.EP then
    self:ShowCard_EP(self.isCover, self.showEPCardIndex)
  end
end

function NewRechargeTCardSubView:RequestChargeQuery(shop_item_conf_id)
  ServiceUserEventProxy.Instance:CallChargeQueryCmd(shop_item_conf_id)
end

function NewRechargeTCardSubView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function NewRechargeTCardSubView:OnEnter()
  NewRechargeTCardSubView.super.OnEnter(self)
  self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
end

function NewRechargeTCardSubView:OnExit()
  NewRechargeTCardSubView.super.OnExit(self)
  if self.monthCardPictureName then
    PictureManager.Instance:UnLoadMonthCard(self.monthCardPictureName, self.u_cardTex)
  end
  if self.epCardPictureName then
    PictureManager.Instance:UnLoadEPCard(self.epCardPictureName, self.u_cardTex)
  end
  if self.rewardIconTexName then
    PictureManager.Instance:UnLoadUI(self.rewardIconTexName, self.u_rewardIconTex)
  end
  if self.rewardLabelBgTexName then
    PictureManager.Instance:UnLoadUI(self.rewardLabelBgTexName, self.u_rewardLabelBg)
  end
  if self.cardViewGirlTexName then
    PictureManager.Instance:UnLoadUI(self.cardViewGirlTexName, self.u_girlTex)
  end
  PictureManager.Instance:UnLoadUI(self.bg_Tex_Name, self.m_uiTexBg)
  self:Func_RemoveListenEvent()
  self.lastSelectEPCardIndex = nil
end

function NewRechargeTCardSubView:Init()
  if self.inited then
    return
  end
  self.carrentMonthLimit = -10
  self:FindObjs()
  self:Func_AddListenEvent()
  self:InitView()
  self.inited = true
end

function NewRechargeTCardSubView:InitView()
  self:RefreshView(1)
end

function NewRechargeTCardSubView:RefreshView(selectInnerTab)
  NewRechargeTCardSubView.super.RefreshView(self, selectInnerTab)
  if selectInnerTab == self.innerTab.MonthlyVIP then
    NewRechargeProxy.Instance:CallClientPayLog(110)
  end
  self:InitData()
  self:LoadView()
  self:SelectInnerSelector()
end

local itemTipOffset = {210, -80}
local itemTipData = {}

function NewRechargeTCardSubView:FindObjs()
  self.gameObject = self:FindGO("NewRechargeTCardSubView")
  NewRechargeTCardSubView.super.FindObjs(self)
  self.u_girlTex = self:FindComponent("girlTex", UITexture, self.gameObject)
  self.cardViewGirlTexName = "new_recharge_npc"
  PictureManager.Instance:SetUI(self.cardViewGirlTexName, self.u_girlTex)
  self.u_card = self:FindGO("Card", self.gameObject)
  self.u_goDiscount = self:FindGO("Discount", self.u_card)
  local _goPercent = self:FindGO("Percent", self.u_goDiscount)
  self.u_spPercentBG = self:FindGO("BG", _goPercent):GetComponent(UISprite)
  self.u_labPercent = self:FindGO("Value1", _goPercent):GetComponent(UILabel)
  self.u_viewSwitch = self:FindGO("Switch", self.u_card)
  self.u_viewSwitch_cover = self:FindComponent("Tip", UISprite, self.u_viewSwitch)
  self.u_viewSwitch_back = self:FindComponent("Back", UISprite, self.u_viewSwitch)
  self.u_LeftCanBuyNumber = self:FindGO("LeftCanBuyNumber", self.u_card)
  self.u_LeftCanBuyNumberLab = self:FindComponent("Lab", UILabel, self.u_LeftCanBuyNumber)
  self.u_LeftYouHuiNumber = self:FindGO("LeftYouHuiNumber")
  self.u_LeftYouHuiNumberLab = self:FindComponent("Lab", UILabel, self.u_LeftYouHuiNumber)
  self.u_cover = self:FindGO("Cover", self.u_card)
  self.u_cardTex = self:FindComponent("CardTex", UITexture, self.u_cover)
  self.u_ep = self:FindGO("EP", self.u_card)
  self.u_epCardTex = self:FindComponent("EPCardTex", UITexture, self.u_ep)
  self.u_goOriginPrice = self:FindGO("OriginPrice", self.u_ep)
  self.u_labOriginPrice = self:FindGO("Lab", self.u_goOriginPrice):GetComponent(UILabel)
  self.u_LeftPageBtn = self:FindGO("BG", self:FindGO("BTN_LeftPage", self.u_ep))
  self.u_RightPageBtn = self:FindGO("BG", self:FindGO("BTN_RightPage", self.u_ep))
  self.u_EPNum = self:FindComponent("EPNumber", UILabel, self.u_ep)
  self.u_ep_back = self:FindGO("Back", self.u_ep)
  self.u_goEPReward = self:FindGO("EPVIPReward", self.u_ep_back)
  local _EPRewardListGrid = self:FindComponent("ItemsRoot", UIGrid, self.u_goEPReward)
  self.listCtrl_EPReward = UIGridListCtrl.new(_EPRewardListGrid, UIListItemViewControllerItem, "UIListItemItem")
  self.u_EPRewardHelpButton = self:FindGO("HelpButton", self.u_goEPReward)
  self.u_epBackBc = self:FindGO("BCForScroll", self.u_goEPReward)
  self.u_mvip = self:FindGO("MonthlyVIP", self.u_card)
  self.u_mvipDiscountGO = self:FindGO("MVipOriginPrice", self.u_mvip)
  self.u_mvipDiscountText = self:FindComponent("Lab", UILabel, self.u_mvipDiscountGO)
  local expirationTimeGO = self:FindGO("ExpirationTime", self.u_mvip)
  self.u_labExpirationTime = expirationTimeGO:GetComponent(UILabel)
  self.u_spritelabExpirationTime = SpriteLabel.new(self.u_labExpirationTime, nil, 28, 28, false)
  self.u_spriteExpirationTimeBG = self:FindComponent("BG", UISprite, expirationTimeGO)
  self.u_mvip_back = self:FindGO("Back", self.u_mvip)
  local _goMVIPDesc = self:FindGO("MonthlyVIPDesp", self.u_mvip_back)
  self.u_MVIPDescListArrow = self:FindGO("Arrow", _goMVIPDesc)
  self.u_MVIPDescSv = self:FindComponent("DescriptionsList", UIScrollView, _goMVIPDesc)
  self.u_MVIPDescPanel = self:FindComponent("DescriptionsList", UIPanel, _goMVIPDesc)
  local _goTable = self:FindGO("DescriptionsRoot"):GetComponent(UITable)
  self.listCtrl_MVIPDesc = UIGridListCtrl.new(_goTable, UIListItemViewControllerVIPDescription, "UIListItemMonthlyVIPDescription")
  self.listCtrl_MVIPDesc:AddEventListener(MouseEvent.MouseClick, self.HandleMVIPDescClick, self)
  local _goYearAndMonth = self:FindGO("YearAndMonth", self.u_mvip_back)
  self.u_labYear = self:FindComponent("Year", UILabel, _goYearAndMonth)
  self.u_labMonth = self:FindComponent("Lab", UILabel, _goYearAndMonth)
  self.u_mvipBackBc = self:FindGO("BCForScroll", _goMVIPDesc)
  self.goBoardE = self:FindComponent("Board_EPVIPCard", UIWidget, self.gameObject)
  self.u_PurchaseBtn = self:FindGO("BTN_Purchase", self.gameObject)
  self.u_PurchaseBtnText = self:FindComponent("Title", UILabel, self.u_PurchaseBtn)
  self.u_PurchaseBtnBc = self.u_PurchaseBtn:GetComponent(BoxCollider)
  self.u_LeftCanBuyNumber.gameObject:SetActive(false)
  self:SetMonthlyVIPDescLogo()
  self:LoadMonthlyVIPRewardBoard()
  self.u_EPCoverElement1 = self:FindComponent("Board_EPVIPCard", UISprite, self.gameObject)
  self.u_EPCoverElement2 = self:FindComponent("Board1_EPVIPCard", UISprite, self.gameObject)
  self.u_EPCoverElement3 = self:FindComponent("EPNumber", UILabel, self.gameObject)
  self.u_EPCoverElement4 = self.u_cardTex
  self.u_EPCoverElement5 = self:FindComponent("Normal", UISprite, self.u_PurchaseBtn)
  self.u_MVIPCoverElement1 = self.u_rewardIconTex
  self.u_MVIPCoverElement2 = self:FindGO("RewardEffectContainer")
  self.u_MVIPCoverElement3 = self:FindGO("RewardFrameEffectContainer")
  self.u_MVIPCoverElement4 = self.u_rewardLabel.gameObject
  self.u_MVIPCoverElement5 = self.u_cardTex
  self.u_MVIPCoverElement6 = self:FindComponent("Normal", UISprite, self.u_PurchaseBtn)
  self.m_uiBtnHelp = self:FindGO("uiImgBtnHelp")
  self.m_uiTexBg = self:FindGO("uiTexBg"):GetComponent(UITexture)
  PictureManager.Instance:SetUI(self.bg_Tex_Name, self.m_uiTexBg)
  self:RegisterClickEvent()
end

function NewRechargeTCardSubView:SetMonthlyVIPDescLogo()
  local _mvip_BoardM_Logo = self:FindGO("Board_MonthlyVIPCard_Logo", self.u_mvip_back)
  local _mvip_BoardM_Logo_Sp = _mvip_BoardM_Logo:GetComponent(UISprite)
  IconManager:SetArtFontIcon("recharge_bg_06", _mvip_BoardM_Logo_Sp)
  _mvip_BoardM_Logo_Sp:MakePixelPerfect()
  _mvip_BoardM_Logo.transform.localScale = LuaGeometry.GetTempVector3(0.9, 0.9, 0.9)
  _mvip_BoardM_Logo.gameObject:SetActive(false)
  if BranchMgr.IsJapan() then
    _mvip_BoardM_Logo.gameObject:SetActive(false)
  elseif BranchMgr.IsChina() then
    _mvip_BoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-215.3, 169.8, 0)
  elseif BranchMgr.IsTW() then
    _mvip_BoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-203, 170, 0)
  elseif BranchMgr.IsKorea() then
    _mvip_BoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-202.8, 172.7, 0)
  else
    _mvip_BoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-221, 161, 0)
  end
end

function NewRechargeTCardSubView:LoadMonthlyVIPRewardBoard()
  self.u_goMonthlyReward = self:FindGO("Board_MonthlyVIPReward")
  self.u_rewardIconTex = self:FindComponent("RewardIcon", UITexture)
  self.u_rewardLabelBg = self:FindComponent("RewardLabelBg", UITexture)
  self.u_rewardLabel = self:FindComponent("RewardLabel", UILabel)
  self.rewardIconTexName = "recharge_icon_00"
  self.rewardLabelBgTexName = "recharge_bg_00"
  PictureManager.Instance:SetUI(self.rewardIconTexName, self.u_rewardIconTex)
  PictureManager.Instance:SetUI(self.rewardLabelBgTexName, self.u_rewardLabelBg)
  self:AddClickEvent(self.u_rewardIconTex.gameObject, function()
    if not next(itemTipData) then
      itemTipData.itemdata = ItemData.new()
    end
    if not self.depositCardReward then
      return
    end
    itemTipData.itemdata:ResetData("DepositCardReward", self.depositCardReward.rewardItems[1].itemid)
    self:ShowItemTip(itemTipData, self.u_rewardIconTex, NGUIUtil.AnchorSide.Right, itemTipOffset)
  end)
end

function NewRechargeTCardSubView:RegisterClickEvent()
  self:RegistShowGeneralHelpByHelpID(1002, self.m_uiBtnHelp)
  self:AddClickEvent(self.u_PurchaseBtn, function()
    self:OnClickForButtonPurchaseCard()
  end)
  self:AddClickEvent(self.u_LeftPageBtn, function()
    self:OnClickForButtonLeftPage()
    self:RefreshZenyCell()
  end)
  self:AddClickEvent(self.u_RightPageBtn, function()
    self:OnClickForButtonRightPage()
    self:RefreshZenyCell()
  end)
  self:AddClickEvent(self.u_viewSwitch, function()
    self:SwitchShowCardCoverBack()
  end)
  self:AddClickEvent(self.u_cover, function()
    self:SwitchShowCardCoverBack()
  end)
  self:AddClickEvent(self.u_epBackBc, function()
    self:SwitchShowCardCoverBack()
  end)
  self:AddClickEvent(self.u_mvipBackBc, function()
    self:SwitchShowCardCoverBack()
  end)
end

function NewRechargeTCardSubView:InitData()
  self.monthlyVIPShopItemConf, self.monthlyVIPShopItemOriginConf = NewRechargeProxy.TCard:GetMonthlyVIPConf()
  self.epCards = NewRechargeProxy.TCard:GetEPCards()
end

function NewRechargeTCardSubView:LoadView()
  FunctionNewRecharge.Instance():AddProductPurchase(self.monthlyVIPShopItemConf.ProductID, function()
    self:OnClickForButtonPurchaseCard(0)
  end)
  for i = 1, #self.epCards do
    local productConfID = self.epCards[i].productConfID
    local ProductID = Table_Deposit[productConfID].ProductID
    FunctionNewRecharge.Instance():AddProductPurchase(ProductID, function()
      self:OnClickForButtonPurchaseCard(i)
    end)
  end
  self.isCover = true
  if self.innerSelectTab == self.innerTab.MonthlyVIP then
    self:ShowCard_MonthlyVIP(self.isCover or true)
  elseif self.innerSelectTab == self.innerTab.EP then
    self:ShowCard_EP(self.isCover or true, self.showEPCardIndex)
  end
  self:OnScrollViewDragFinished()
  self:RefreshZenyCell()
end

function NewRechargeTCardSubView:ShowCard_MonthlyVIP(isCover)
  self.showEPCardIndex = 0
  self.monthlyVIPShopItemConf, self.monthlyVIPShopItemOriginConf = NewRechargeProxy.TCard:GetMonthlyVIPConf()
  self.productConf = self.monthlyVIPShopItemConf
  self.u_goDiscount:SetActive(false)
  self.u_LeftYouHuiNumber.gameObject:SetActive(false)
  self.u_LeftCanBuyNumber.gameObject:SetActive(false)
  self.u_ep:SetActive(false)
  self.u_mvip:SetActive(true)
  self.u_cardTex.gameObject:SetActive(isCover)
  self.u_mvip_back:SetActive(not isCover)
  self.u_viewSwitch_cover.gameObject:SetActive(isCover)
  self.u_viewSwitch_back.gameObject:SetActive(not isCover)
  if isCover then
    self:LoadMonthlyVIPCardTex()
  else
    self.listCtrl_MVIPDesc:ResetDatas(self:GetMonthlyVIPDescData(), true, true)
    self.listCtrl_MVIPDesc:ResetPosition()
  end
  if self.monthlyVIPShopItemOriginConf then
    self.u_mvipDiscountGO:SetActive(true)
    self.u_mvipDiscountText.text = string.format(ZhString.Shop_OriginPrice, self:GetPriceStringByConf(self.monthlyVIPShopItemOriginConf))
  else
    self.u_mvipDiscountGO:SetActive(false)
  end
  self.u_PurchaseBtnText.text = self:GetPriceStringByConf(self.monthlyVIPShopItemConf)
  self:CheckShowDepositCardRewardBoard()
  self:ShowMonthlyVIPTime()
  self:UpdateMonthlyVIPLeftCanBuy()
end

function NewRechargeTCardSubView:HandleMVIPDescClick(cell)
  if cell and cell.isTitle and cell.isFold then
    local foldState = cell:SwitchFoldState()
    local cells = self.listCtrl_MVIPDesc:GetCells()
    local s, e
    for i = 1, #cells do
      local c = cells[i]
      if c and c == cell then
        s = i
      elseif s and c.isTitle then
        e = i
        break
      end
    end
    e = e or #cells
    for i = s + 1, e do
      local c = cells[i]
      if c then
        c.gameObject:SetActive(not foldState)
      end
    end
    self.listCtrl_MVIPDesc:ResetPosition()
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.u_MVIPDescPanel.cachedTransform, cell.gameObject.transform)
    local offset = self.u_MVIPDescPanel:CalculateConstrainOffset(bound.min, bound.max)
    offset = LuaGeometry.GetTempVector3(0, offset.y, 0)
    self.u_MVIPDescSv:MoveRelative(offset)
  end
end

function NewRechargeTCardSubView:GetMonthlyVIPDescData()
  monthlyVIPInfosForUITableListCtrl = {}
  local dynamicVIPDescription
  for _, v in pairs(GameConfig.DepositCard) do
    if v.type1 == 2 then
      dynamicVIPDescription = v.funcs
      break
    end
  end
  local monthConf = NewRechargeProxy.CCard.GetMonthCardConfigure()
  for i = 1, #dynamicVIPDescription do
    local vipDescriptionConfID = dynamicVIPDescription[i]
    if Table_DepositFunction[vipDescriptionConfID] then
      local uiListItemModelVIPDescription = UIListItemModelVIPDescription.new(monthConf)
      uiListItemModelVIPDescription:SetDescriptionConfigID(vipDescriptionConfID)
      table.insert(monthlyVIPInfosForUITableListCtrl, uiListItemModelVIPDescription)
    end
  end
  return monthlyVIPInfosForUITableListCtrl
end

function NewRechargeTCardSubView:ShowMonthlyVIPTime()
  local timeOffset = GameConfig.System and GameConfig.System.MonthCardRefreshTime or 0
  local year = NewRechargeProxy.CCard.YearOfServer(-timeOffset)
  local month = NewRechargeProxy.CCard.MonthOfServer(-timeOffset)
  self.u_labYear.text = tostring(year)
  if month < 10 then
    self.u_labMonth.text = "0" .. tostring(month)
  else
    self.u_labMonth.text = tostring(month)
  end
  local expirationTime = NewRechargeProxy.CCard:Get_TimeOfExpirationMonthlyVIP()
  if expirationTime ~= nil then
    self:SetPurchaseBTNPos(false)
  end
  if self.monthlyVIPShopItemOriginConf then
    self.u_labExpirationTime.gameObject:SetActive(true)
    local descConf = ShopProxy.Instance:GetDepositCardRewardByDepositAndCount(self.monthlyVIPShopItemConf.id, true, 1)
    self.u_spritelabExpirationTime:SetText(descConf and descConf.desc2 or "")
    self.u_spriteExpirationTimeBG.width = (self.u_labExpirationTime.printedSize[1] or 0) + 50
  else
    self.u_spritelabExpirationTime:SetText("")
    self.u_labExpirationTime.gameObject:SetActive(false)
  end
end

function NewRechargeTCardSubView:UpdateMonthlyVIPLeftCanBuy()
  if FunctionNewRecharge.Instance():IsChuXinServer() then
    self.u_mvipDiscountGO:SetActive(false)
    self.u_spritelabExpirationTime:SetText("")
    self.u_labExpirationTime.gameObject:SetActive(false)
    self.u_PurchaseBtnText.text = ZhString.NewRecharge_ChuXinServer_EPCardPrice
    self.u_PurchaseBtnText.fontSize = 20
    self:SetNormal_MonthlyVIPCardCover()
    return
  end
  self.u_PurchaseBtnText.fontSize = 24
  if not (self.monthlyVIPShopItemConf and self.monthlyVIPShopItemChargedCount) or not self.monthlyVIPShopItemConf.MonthLimit then
    return
  end
  local monthLimit = self.monthlyVIPShopItemConf.MonthLimit
  if not (999 < monthLimit) or self.monthlyVIPShopItemConf.LimitType ~= 1 then
    self.u_LeftCanBuyNumber.gameObject:SetActive(false)
    self.u_LeftCanBuyNumberLab.text = ZhString.HappyShop_CanBuy .. monthLimit
  end
  local leftAllLimit = monthLimit - self.monthlyVIPShopItemChargedCount
  if leftAllLimit < 0 then
    leftAllLimit = 0
  end
  self.carrentMonthLimit = leftAllLimit
  self.u_LeftCanBuyNumberLab.text = ZhString.HappyShop_CanBuy .. leftAllLimit
  if leftAllLimit and leftAllLimit <= 0 then
    self:SetGray_MonthlyVIPCardCover()
  else
    self:SetNormal_MonthlyVIPCardCover()
    self:RefreshZenyCell()
  end
end

function NewRechargeTCardSubView:LoadMonthlyVIPCardTex()
  local monthCardConfigure = NewRechargeProxy.CCard.GetMonthCardConfigure()
  if self.epCardPictureName then
    PictureManager.Instance:UnLoadEPCard(self.epCardPictureName, self.u_epCardTex)
    self.epCardPictureName = nil
  end
  if monthCardConfigure and not StringUtil.IsEmpty(monthCardConfigure.Picture) then
    if self.monthCardPictureName ~= monthCardConfigure.Picture then
      if self.monthCardPictureName then
        self.u_cardTex.mainTexture = nil
        PictureManager.Instance:UnLoadMonthCard(self.monthCardPictureName)
      end
      PictureManager.Instance:SetMonthCardUI(monthCardConfigure.Picture, self.u_cardTex)
      self.monthCardPictureName = monthCardConfigure.Picture
    end
  else
    local monthCardUrl = ActivityEventProxy.Instance:GetCardResourceUrl()
    if monthCardUrl then
      local bytes = LotteryProxy.Instance:DownloadMagicPicFromUrl(monthCardUrl)
      if self.monthCardUrl ~= monthCardUrl then
        self.monthCardUrl = monthCardUrl
      end
      if bytes then
        self:UpdatePicture(bytes)
      else
        self.u_cardTex.mainTexture = nil
      end
    end
  end
end

function NewRechargeTCardSubView:CheckShowDepositCardRewardBoard()
  local shopIns, productId = ShopProxy.Instance, self.productConf.id
  if shopIns.accChargeCntRewardInfos then
    local showed = false
    for _, info in pairs(shopIns.accChargeCntRewardInfos) do
      if productId == info.dataid then
        showed = self:TryShowDepositCardReward(true, info.count + 1)
      end
    end
    if not showed then
      local count = self.monthlyVIPShopItemChargedCount or 0
      self:TryShowDepositCardReward(false, count + 1)
    end
  else
    self:TryShowDepositCardReward(true, 1)
  end
end

function NewRechargeTCardSubView:TryShowDepositCardReward(isAccLimit, count)
  self.depositCardReward = ShopProxy.Instance:GetDepositCardRewardByDepositAndCount(self.productConf.id, isAccLimit, count)
  if self.depositCardReward then
    self.u_rewardLabel.text = self.depositCardReward.desc or ""
    UIUtil.FitLableMaxWidth(self.u_rewardLabel, 590)
    self:SetActive_MonthlyVIPReward(true)
    return true
  else
    self:SetActive_MonthlyVIPReward(false)
    return false
  end
end

function NewRechargeTCardSubView:ShowCard_EP(isCover, cardIndex)
  cardIndex = cardIndex ~= 0 and cardIndex or self.lastSelectEPCardIndex or 1
  self.lastSelectEPCardIndex = cardIndex
  self.showEPCardIndex = cardIndex
  local curEpCard = self:GetCurrentEPCard()
  self.epCardConf = Table_Deposit[self.epCards[cardIndex].id1]
  self.productConf = self.epCardConf
  self.u_mvip:SetActive(false)
  self.u_ep:SetActive(true)
  self.u_cardTex.gameObject:SetActive(isCover)
  self.u_epCardTex.gameObject:SetActive(isCover)
  self.u_ep_back:SetActive(not isCover)
  self.u_viewSwitch_cover.gameObject:SetActive(isCover)
  self.u_viewSwitch_back.gameObject:SetActive(not isCover)
  self.u_EPRewardHelpButton:SetActive(not isCover and not BranchMgr.IsJapan())
  self:SetPurchaseBTNPos(true)
  if isCover then
    if self.monthCardPictureName then
      PictureManager.Instance:UnLoadMonthCard(self.monthCardPictureName, self.u_cardTex)
      self.monthCardPictureName = nil
    end
    if self.epCardPictureName ~= self.epCardConf.Picture then
      if self.epCardPictureName then
        PictureManager.Instance:UnLoadEPCard(self.epCardPictureName)
      end
      self.epCardPictureName = self.epCardConf.Picture
      PictureManager.Instance:SetEPCardUI(self.epCardPictureName, self.u_epCardTex)
    end
  else
    self:ShowEPVIPReward()
  end
  if self.epCardConf.ReplaceName and self.epCardConf.ReplaceName ~= "" then
    self.u_EPNum.text = self.epCardConf.ReplaceName
  else
    local ep = self.epCards[cardIndex].version
    self.u_EPNum.text = "EP " .. ep
    if math.floor(ep) == ep then
      self.u_EPNum.text = "EP " .. ep .. ".0"
    end
  end
  local isDiscount = self:IsEPCardDiscount(curEpCard)
  self:SetActive_Discount(isDiscount)
  if isDiscount then
    self.discountEPCardConf = Table_Deposit[self.epCards[cardIndex].id2]
    self.u_PurchaseBtnText.text = self:GetPriceStringByConf(self.discountEPCardConf)
    self.u_labOriginPrice.text = ZhString.HappyShop_originalCost .. self.epCardConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(self.epCardConf.Rmb)
    local percent = math.ceil(self.discountEPCardConf.Rmb * 100 / self.epCardConf.Rmb)
    percent = 100 - percent
    self.u_labPercent.text = percent .. "%"
    if percent == 0 or percent == 100 then
      self.u_goDiscount:SetActive(false)
    end
    self.productConf = self.discountEPCardConf
  else
    self.u_PurchaseBtnText.text = self:GetPriceStringByConf(self.epCardConf)
  end
  if isDiscount and self.discountEPCardConf and self.discountEPCardConf.ActivityDiscountLimit and 0 < self.discountEPCardConf.ActivityDiscountLimit then
    self.u_LeftYouHuiNumberLab.text = ZhString.HappyShop_DiscountLeftTimes .. self.discountEPCardConf.ActivityDiscountLimit
    self.u_LeftYouHuiNumber.gameObject:SetActive(true)
  else
    self.u_LeftYouHuiNumber.gameObject:SetActive(false)
  end
  local monthLimit = self.epCardConf.MonthLimit
  if not (999 < monthLimit) or self.epCardConf.LimitType ~= 1 then
    self.u_LeftCanBuyNumber.gameObject:SetActive(true)
    self.u_LeftCanBuyNumberLab.text = ZhString.HappyShop_CanBuy .. monthLimit
  end
  self:UpdateEPCardUIByChargeCntTable()
end

function NewRechargeTCardSubView:GetCurrentEPCard()
  return self.epCards and self.epCards[self.showEPCardIndex]
end

function NewRechargeTCardSubView:IsEPCardDiscount(card)
  local retValue = false
  if card then
    retValue = card.id2 > 0
    if card.id2 == card.id1 then
      retValue = false
    end
  end
  return retValue
end

function NewRechargeTCardSubView:UpdateEPCardUIByChargeCntTable()
  if FunctionNewRecharge.Instance():IsChuXinServer() then
    self.u_LeftCanBuyNumberLab.text = ""
    self:SetActive_Discount(false)
    self.u_PurchaseBtnText.text = ZhString.NewRecharge_ChuXinServer_EPCardPrice
    self.u_PurchaseBtnText.fontSize = 20
    return
  end
  self.u_PurchaseBtnText.fontSize = 24
  local shopIns = ShopProxy.Instance
  local leftAllLimit
  if shopIns.ChargeCntTable and self.epCardConf then
    for k, v in pairs(shopIns.ChargeCntTable) do
      if v.dataid == self.epCardConf.id then
        leftAllLimit = self.epCardConf.MonthLimit - v.count
        if leftAllLimit < 0 then
          leftAllLimit = 0
        end
        self.carrentMonthLimit = leftAllLimit
        self.u_LeftCanBuyNumberLab.text = ZhString.HappyShop_CanBuy .. leftAllLimit
        self:SetActive_Discount(false)
        self.u_PurchaseBtnText.text = self:GetPriceStringByConf(self.epCardConf)
        break
      elseif self.discountEPCardConf and v.dataid == self.discountEPCardConf.id then
        leftAllLimit = self.epCardConf.MonthLimit - v.count
        if leftAllLimit < 0 then
          leftAllLimit = 0
        end
        self.carrentMonthLimit = leftAllLimit
        self.u_LeftCanBuyNumberLab.text = ZhString.HappyShop_CanBuy .. leftAllLimit
        local leftDiscount = self.discountEPCardConf.ActivityDiscountLimit - v.count
        if leftDiscount < 0 then
          leftDiscount = 0
        end
        self.u_LeftYouHuiNumberLab.text = ZhString.HappyShop_DiscountLeftTimes .. leftDiscount
        if leftDiscount == 0 then
          self:SetActive_Discount(false)
          self.u_PurchaseBtnText.text = self:GetPriceStringByConf(self.epCardConf)
        end
        break
      end
    end
    if leftAllLimit and leftAllLimit <= 0 then
      self:SetGray_EPCardCover()
    else
      self:SetNormal_EPCardCover()
      self:RefreshZenyCell()
    end
  end
end

function NewRechargeTCardSubView:GetVipCardId(card)
  if card == nil then
    return nil
  end
  if card.id2 ~= nil and card.id2 ~= 0 then
    return card.id2
  end
  return card.id1
end

function NewRechargeTCardSubView:GetPriceStringByConf(productConf)
  if not productConf then
    return
  end
  if productConf.priceStr then
    return productConf.priceStr
  end
  return productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(productConf.Rmb)
end

function NewRechargeTCardSubView:RefreshZenyCell()
  if not BranchMgr.IsJapan() then
    return
  end
  helplog("NewRechargeTCardSubView:RefreshZenyCell", self.showEPCardIndex)
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.productConf and self.productConf.Rmb or 0
    helplog(currency, left)
    if left < currency then
      self:SetEnable(false)
    elseif 0 < self.carrentMonthLimit then
      self:SetEnable(true)
    end
  else
    helplog("unlimit")
    if 0 < self.carrentMonthLimit then
      self:SetEnable(true)
    end
  end
end

function NewRechargeTCardSubView:SetEnable(enable)
  if not BranchMgr.IsJapan() then
    return
  end
  local goBTNPurchaseCollider = self.u_PurchaseBtn:GetComponent(BoxCollider)
  local back = self:FindGO("Normal", self.u_PurchaseBtn):GetComponent(UISprite)
  if enable then
    self.u_PurchaseBtnText.effectColor = LuaGeometry.GetTempColor(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
    back.color = Color.white
  else
    self.u_PurchaseBtnText.effectColor = LuaGeometry.GetTempColor(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    ColorUtil.ShaderGrayUIWidget(back)
  end
  goBTNPurchaseCollider.enabled = enable
end

function NewRechargeTCardSubView:SwitchShowCardCoverBack()
  self.isCover = not self.isCover
  if self.innerSelectTab == self.innerTab.MonthlyVIP then
    self:ShowCard_MonthlyVIP(self.isCover)
  elseif self.innerSelectTab == self.innerTab.EP then
    self:ShowCard_EP(self.isCover, self.showEPCardIndex)
  end
end

function NewRechargeTCardSubView:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    self.u_cardTex.mainTexture = texture
  end
end

local SQR_MAGNITUDE = LuaVector3.SqrMagnitude

function NewRechargeTCardSubView:OnScrollViewDragFinished()
  self.InitScrollViewLocalPos = self.u_MVIPDescSv.gameObject.transform.localPosition.y
  
  function self.u_MVIPDescSv.onDragFinished()
    local b = self.u_MVIPDescSv.bounds
    local constraint = self.u_MVIPDescPanel:CalculateConstrainOffset(b.min, b.max)
    local curPos = self.u_MVIPDescSv.gameObject.transform.localPosition.y
    if 0.1 < SQR_MAGNITUDE(constraint) and curPos > self.InitScrollViewLocalPos then
      self.u_MVIPDescListArrow:SetActive(false)
    else
      self.u_MVIPDescListArrow:SetActive(true)
    end
  end
end

function NewRechargeTCardSubView:ShowEPVIPReward()
  local useItemID = self.epCardConf.ItemId
  local team = Table_UseItem[useItemID].UseEffect.id
  local items = ItemUtil.GetRewardItemIdsByTeamId(team)
  if items then
    self.listCtrl_EPReward:ResetDatas(items)
    local itemsCells = self.listCtrl_EPReward:GetCells()
    for i = 1, #itemsCells do
      itemsCells[i]:SetItemTipAnchor(self.goBoardE)
    end
    self.listCtrl_EPReward:ResetPosition()
  end
end

function NewRechargeTCardSubView:SetPurchaseBTNPos(b)
  local xValue
  if b then
    xValue = 117
  else
    xValue = 135
  end
  local posOfBTN = self.u_PurchaseBtn.transform.localPosition
  posOfBTN.x = xValue
  self.u_PurchaseBtn.transform.localPosition = posOfBTN
end

function NewRechargeTCardSubView:OnClickForButtonPurchaseCard(show_card_index)
  if FunctionNewRecharge.Instance():IsChuXinServer() then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ServantBattlePassView"
    })
    return
  end
  local showCardIndex = show_card_index or self.showEPCardIndex
  if not BranchMgr.IsJapan() and not BranchMgr.IsKorea() then
    helplog("OnClickForButtonPurchaseCard:", self.showEPCardIndex)
    if showCardIndex == 0 then
      self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
      self.queryChargeAndPurchaseMonthlyVIPCard = true
      self.dazhe = false
    elseif 0 < showCardIndex then
      self:RequestQueryChargeCnt()
      local card = self.epCards[showCardIndex]
      self.queryChargeAndPurchaseEPCardID = card.id2 or card.id1
      if card.id2 == card.id1 then
        self.dazhe = false
      else
        self.budazheid = card.id1
        self.dazhe = true
      end
    end
    return
  end
  if showCardIndex == 0 then
    local productName = OverSea.LangManager.Instance():GetLangByKey(self.monthlyVIPShopItemConf.Desc)
    local productPrice = self.monthlyVIPShopItemConf.Rmb
    local currencyType = self.monthlyVIPShopItemConf.CurrencyType
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", "[0075BCFF]" .. productName .. "[-]", currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
      self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
      self.queryChargeAndPurchaseMonthlyVIPCard = true
      self.dazhe = false
    end)
  elseif 0 < showCardIndex then
    local card = self.epCards[showCardIndex]
    local purchaseEPCardID = card.id2 or card.id1
    local cardConf = Table_Deposit[purchaseEPCardID]
    local productName = OverSea.LangManager.Instance():GetLangByKey(cardConf.Desc)
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle2 .. "[-]", "[0075BCFF]" .. productName .. "[-]", "", self.u_PurchaseBtnText.text), ZhString.ShopConfirmDes, productName, cardConf.Rmb, function()
      self:RequestQueryChargeCnt()
      self.queryChargeAndPurchaseEPCardID = purchaseEPCardID
      if card.id2 == card.id1 then
        self.dazhe = false
      else
        self.budazheid = card.id1
        self.dazhe = true
      end
    end)
  end
end

function NewRechargeTCardSubView:OnClickForButtonLeftPage()
  if self.epCards ~= nil then
    if self.showEPCardIndex <= 1 then
      self.showEPCardIndex = #self.epCards
    else
      self.showEPCardIndex = self.showEPCardIndex - 1
    end
    self:ShowCard_EP(true, self.showEPCardIndex)
  end
end

function NewRechargeTCardSubView:OnClickForButtonRightPage()
  if self.epCards ~= nil then
    if self.showEPCardIndex >= #self.epCards then
      self.showEPCardIndex = 1
    else
      self.showEPCardIndex = self.showEPCardIndex + 1
    end
    self:ShowCard_EP(true, self.showEPCardIndex)
  end
end

function NewRechargeTCardSubView:Purchase(custom_pid)
  local productConf
  if self.showEPCardIndex == 0 then
    productConf = self.monthlyVIPShopItemConf
  else
    local card = self.epCards[self.showEPCardIndex]
    local confID = self:GetVipCardId(card)
    if custom_pid then
      confID = custom_pid
    end
    productConf = Table_Deposit[confID]
  end
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
      LogUtility.Info("NewRechargeTCardSubView:OnPaySuccess, " .. str_result)
      if BranchMgr.IsJapan() then
        local currency = self.productConf and self.productConf.Rmb or 0
        ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      end
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
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
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
  else
    MsgManager.ShowMsgByID(49)
  end
end

function NewRechargeTCardSubView:SetActive_Discount(b)
  self.u_goDiscount:SetActive(b)
  self.u_goOriginPrice:SetActive(b)
  self.u_LeftYouHuiNumber:SetActive(b)
end

function NewRechargeTCardSubView:SetActive_MonthlyVIPReward(b)
  self.u_goMonthlyReward:SetActive(b)
end

local c_gray1 = LuaColor.New(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
local c_gray2 = LuaColor.New(0.788235294117647, 0.788235294117647, 0.788235294117647)
local c_normal_outline = LuaColor.New(0.8274509803921568, 0.6470588235294118, 0.023529411764705882)
local c_gray_outline = LuaColor.New(0.5882352941176471, 0.5882352941176471, 0.5882352941176471)
local colorWhite = LuaColor.White()

function NewRechargeTCardSubView:SetGray_EPCardCover()
  self.u_EPCoverElement1.color = c_gray1
  self.u_EPCoverElement2.color = c_gray1
  self.u_EPCoverElement3.color = c_gray2
  self.u_EPCoverElement4.color = c_gray1
  self.u_EPCoverElement5.color = c_gray1
  self.u_PurchaseBtnText.effectColor = c_gray_outline
  self.u_PurchaseBtnText.text = ZhString.HappyShop_SoldOut
  self.u_PurchaseBtnBc.enabled = false
end

function NewRechargeTCardSubView:SetNormal_EPCardCover()
  self.u_EPCoverElement1.color = colorWhite
  self.u_EPCoverElement2.color = colorWhite
  self.u_EPCoverElement3.color = colorWhite
  self.u_EPCoverElement4.color = colorWhite
  self.u_EPCoverElement5.color = colorWhite
  self.u_PurchaseBtnText.effectColor = c_normal_outline
  self.u_PurchaseBtnBc.enabled = true
end

function NewRechargeTCardSubView:SetGray_MonthlyVIPCardCover()
  self.u_MVIPCoverElement1.color = c_gray1
  self.u_MVIPCoverElement2:SetActive(false)
  self.u_MVIPCoverElement3:SetActive(false)
  self.u_MVIPCoverElement4:SetActive(false)
  self.u_MVIPCoverElement5.color = c_gray1
  self.u_MVIPCoverElement6.color = c_gray1
  self.u_PurchaseBtnText.effectColor = c_gray_outline
  self.u_PurchaseBtnText.text = ZhString.HappyShop_SoldOut
  self.u_PurchaseBtnBc.enabled = false
end

function NewRechargeTCardSubView:SetNormal_MonthlyVIPCardCover()
  self.u_MVIPCoverElement1.color = colorWhite
  self.u_MVIPCoverElement2:SetActive(true)
  self.u_MVIPCoverElement3:SetActive(true)
  self.u_MVIPCoverElement4:SetActive(false)
  self.u_MVIPCoverElement5.color = colorWhite
  self.u_MVIPCoverElement6.color = colorWhite
  self.u_PurchaseBtnText.effectColor = c_normal_outline
  self.u_PurchaseBtnBc.enabled = true
end
