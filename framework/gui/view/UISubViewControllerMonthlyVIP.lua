autoImport("UITableListCtrl")
autoImport("UIModelMonthlyVIP")
autoImport("UIModelZenyShop")
autoImport("UIListItemViewControllerVIPDescription")
autoImport("UIListItemModelVIPDescription")
autoImport("UIListItemViewControllerItem")
autoImport("UIPriceDiscount")
autoImport("FunctionADBuiltInTyrantdb")
autoImport("FuncZenyShop")
autoImport("PurchaseDeltaTimeLimit")
autoImport("ChargeComfirmPanel")
UISubViewControllerMonthlyVIP = class("UISubViewControllerMonthlyVIP", SubView)
UISubViewControllerMonthlyVIP.instance = nil
local gReusableTable = {}

function UISubViewControllerMonthlyVIP:Init()
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
  self:AddListenEvt(ServiceEvent.UserEventQueryAccChargeCntReward, self.HandleAccChargeCntReward)
  self:AddListenEvt(ServiceEvent.UserEventChargeQueryCmd, self.HandleChargeQueryCmd)
  self:GetModelSet()
end

function UISubViewControllerMonthlyVIP:OnEnter()
  self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
end

function UISubViewControllerMonthlyVIP:OnExit()
  if self.monthCardPictureName then
    PictureManager.Instance:UnLoadMonthCard(self.monthCardPictureName, self.texCard)
  end
  if self.epCardPictureName then
    PictureManager.Instance:UnLoadEPCard(self.epCardPictureName, self.texCard)
  end
  if self.rewardIconTexName then
    PictureManager.Instance:UnLoadUI(self.rewardIconTexName, self.rewardIconTex)
  end
  if self.rewardLabelBgTexName then
    PictureManager.Instance:UnLoadUI(self.rewardLabelBgTexName, self.rewardLabelBg)
  end
  self:CancelListenServerResponse()
end

function UISubViewControllerMonthlyVIP:MyInit()
  helplog("UISubViewControllerMonthlyVIP MyInit")
  UISubViewControllerMonthlyVIP.instance = self
  self.gameObject = self:LoadPreferb("view/UISubViewMonthlyVIP", nil, true)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:RegisterClickEvent()
  FuncZenyShop.Instance():AddProductPurchase(self.monthlyVIPShopItemConf.ProductID, function()
    self:OnClickForButtonPurchaseCard(0)
  end)
  EventManager.Me():PassEvent(ZenyShopEvent.CanPurchase, self.monthlyVIPShopItemConf.ProductID)
  self.epVIPCards = UIModelZenyShop.Ins():GetEPVIPCards()
  local usbleEpCards = {}
  for i = 1, #self.epVIPCards do
    local epVIPCard = self.epVIPCards[i]
    local productConfID = epVIPCard.id2
    if productConfID == nil or productConfID == 0 then
      productConfID = epVIPCard.id1
    end
    if Table_Deposit[productConfID] == nil then
      redlog(productConfID .. " 对应客户端ep卡配置为空，请检查配置表")
    else
      table.insert(usbleEpCards, self.epVIPCards[i])
      local productID = Table_Deposit[productConfID].ProductID
      FuncZenyShop.Instance():AddProductPurchase(productID, function()
        self:OnClickForButtonPurchaseCard(i)
      end)
      EventManager.Me():PassEvent(ZenyShopEvent.CanPurchase, productID)
    end
  end
  self.epVIPCards = usbleEpCards
  self:OnScrollViewDragFinished()
  self.showCardIndex = 0
  self.showContentIndex = 1
  self:LoadView()
  self:ListenServerResponse()
  self.isInit = true
  self:RefreshZenyCell()
  self:ShowCard(self.showCardIndex)
end

function UISubViewControllerMonthlyVIP:DyRefreshEpCards(open)
  self.goBTN_LeftPage:SetActive(open)
  self.goBTN_RightPage:SetActive(open)
  self.BGCard = self:FindGO("BGCard", self.gameObject)
  self.BGCard:SetActive(open)
end

function UISubViewControllerMonthlyVIP:GetVipCardId(card)
  if card == nil then
    return nil
  end
  if card.id2 ~= nil and card.id2 ~= 0 then
    return card.id2
  end
  return card.id1
end

local itemTipOffset = {210, -80}
local itemTipData = {}

function UISubViewControllerMonthlyVIP:GetGameObjects()
  self.goMonthlyVIPDesp = self:FindGO("MonthlyVIPDesp", self.gameObject)
  self.goDescriptionsList = self:FindGO("DescriptionsList", self.goMonthlyVIPDesp)
  self.goSv = self:FindGO("DescriptionsList"):GetComponent(UIScrollView)
  self.goPanel = self:FindGO("DescriptionsList"):GetComponent(UIPanel)
  self.goListArrow = self:FindGO("Arrow", self.goMonthlyVIPDesp)
  self.goCard = self:FindGO("Card", self.gameObject)
  self.texCard = self.goCard:GetComponent(UITexture)
  self.goBoardM = self:FindGO("Board_MonthlyVIPCard", self.gameObject)
  self.goBoardM_Logo = self:FindGO("Board_MonthlyVIPCard_Logo", self.gameObject)
  self.goBoardM_Logo_Sp = self.goBoardM_Logo:GetComponent(UISprite)
  IconManager:SetArtFontIcon("recharge_bg_06", self.goBoardM_Logo_Sp)
  self.goBoardM_Logo_Sp:MakePixelPerfect()
  self.goBoardM_Logo.transform.localScale = LuaGeometry.GetTempVector3(0.9, 0.9, 0.9)
  self.goBoardM_Logo.gameObject:SetActive(true)
  if BranchMgr.IsJapan() then
    self.goBoardM_Logo.gameObject:SetActive(false)
  elseif BranchMgr.IsChina() then
    self.goBoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-215.3, 169.8, 0)
  elseif BranchMgr.IsTW() then
    self.goBoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-203, 170, 0)
  elseif BranchMgr.IsKorea() then
    self.goBoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-202.8, 172.7, 0)
  else
    self.goBoardM_Logo.transform.localPosition = LuaGeometry.GetTempVector3(-221, 161, 0)
  end
  self.goBoardE = self:FindGO("Board_EPVIPCard", self.gameObject)
  self.goBoard1E = self:FindGO("Board1_EPVIPCard", self.gameObject)
  self.goValidTime = self:FindGO("ValidTime", self.gameObject)
  self:Hide(self.goValidTime)
  self.goBTNPurchaseMonthlyVIP = self:FindGO("BTN_Purchase", self.gameObject)
  self.goBTNTitlePurchaseMonthlyVIP = self:FindGO("Title", self.goBTNPurchaseMonthlyVIP)
  self.labBTNTitlePurchaseMonthlyVIP = self.goBTNTitlePurchaseMonthlyVIP:GetComponent(UILabel)
  self.goTip = self:FindGO("Tip", self.gameObject)
  self.goExpirationTime = self:FindGO("ExpirationTime", self.gameObject)
  self.labExpirationTime = self.goExpirationTime:GetComponent(UILabel)
  self.goYearAndMonth = self:FindGO("YearAndMonth", self.gameObject)
  self.goLabYear = self:FindGO("Year", self.goYearAndMonth)
  self.labYear = self.goLabYear:GetComponent(UILabel)
  self.goMonth = self:FindGO("Month", self.goYearAndMonth)
  self.goLabMonth = self:FindGO("Lab", self.goMonth)
  self.labMonth = self.goLabMonth:GetComponent(UILabel)
  self.goEPVIPReward = self:FindGO("EPVIPReward", self.gameObject)
  self.goRewardList = self:FindGO("ItemsList", self.goEPVIPReward)
  self.goRewardRoot = self:FindGO("ItemsRoot", self.goEPVIPReward)
  self.goBTN_LeftPage = self:FindGO("BTN_LeftPage", self.gameObject)
  self.goBGBTN_LeftPage = self:FindGO("BG", self.goBTN_LeftPage)
  self.goBTN_RightPage = self:FindGO("BTN_RightPage", self.gameObject)
  self.goBGBTN_RightPage = self:FindGO("BG", self.goBTN_RightPage)
  self.goBCForScrollDesp = self:FindGO("BCForScroll", self.goMonthlyVIPDesp)
  self.goBCForScrollReward = self:FindGO("BCForScroll", self.goEPVIPReward)
  self.goEPNumber = self:FindGO("EPNumber", self.goBoard1E)
  self.labEP = self.goEPNumber:GetComponent(UILabel)
  self.goDiscount = self:FindGO("Discount")
  self.goPercent = self:FindGO("Percent", self.goDiscount)
  self.spPercentBG = self:FindGO("BG", self.goPercent):GetComponent(UISprite)
  self.labPercent = self:FindGO("Value1", self.goPercent):GetComponent(UILabel)
  self.labPercentSymbol = self:FindGO("Value2", self.goPercent):GetComponent(UILabel)
  self.goOriginPrice = self:FindGO("OriginPrice")
  self.labOriginPrice = self:FindGO("Lab", self.goOriginPrice):GetComponent(UILabel)
  self.spDelLine = self:FindGO("DelLine", self.goOriginPrice):GetComponent(UISprite)
  self.scrollViewReward = self.goRewardList:GetComponent(UIScrollView)
  self.goTable = self:FindGO("DescriptionsRoot"):GetComponent(UITable)
  self.listControllerOfVIPDescriptions = UIGridListCtrl.new(self.goTable, UIListItemViewControllerVIPDescription, "UIListItemMonthlyVIPDescription")
  self.helpButton = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(1002, self.helpButton)
  self.LeftYouHuiNumber = self:FindGO("LeftYouHuiNumber")
  self.LeftYouHuiNumberLab = self:FindGO("Lab", self.LeftYouHuiNumber)
  self.LeftYouHuiNumberLab_UILabel = self.LeftYouHuiNumberLab:GetComponent(UILabel)
  self.LeftCanBuyNumber = self:FindGO("LeftCanBuyNumber")
  self.LeftCanBuyNumberLab = self:FindGO("Lab", self.LeftCanBuyNumber)
  self.LeftCanBuyNumberLab_UILabel = self.LeftCanBuyNumberLab:GetComponent(UILabel)
  self.LeftCanBuyNumber.gameObject:SetActive(false)
  self.goMonthlyReward = self:FindGO("Board_MonthlyVIPReward")
  self.rewardIconTex = self:FindComponent("RewardIcon", UITexture)
  self.rewardLabelBg = self:FindComponent("RewardLabelBg", UITexture)
  self.rewardLabel = self:FindComponent("RewardLabel", UILabel)
  self.rewardIconTexName = "recharge_icon_00"
  self.rewardLabelBgTexName = "recharge_bg_00"
  PictureManager.Instance:SetUI(self.rewardIconTexName, self.rewardIconTex)
  PictureManager.Instance:SetUI(self.rewardLabelBgTexName, self.rewardLabelBg)
  self:AddClickEvent(self.rewardIconTex.gameObject, function()
    if not next(itemTipData) then
      itemTipData.itemdata = ItemData.new()
    end
    if not self.depositCardReward then
      return
    end
    itemTipData.itemdata:ResetData("DepositCardReward", self.depositCardReward.rewardItems[1].itemid)
    self:ShowItemTip(itemTipData, self.rewardIconTex, NGUIUtil.AnchorSide.Right, itemTipOffset)
  end)
  self:PlayUIEffect(EffectMap.UI.reminder_MonthlyCard, self:FindGO("RewardEffectContainer"))
  self:PlayUIEffect(EffectMap.UI.turn_MonthlyCard, self:FindGO("RewardFrameEffectContainer"))
end

function UISubViewControllerMonthlyVIP:RegisterButtonClickEvent()
  self:AddClickEvent(self.goBTNPurchaseMonthlyVIP, function()
    self:OnClickForButtonPurchaseCard()
  end)
  self:AddClickEvent(self.goBGBTN_LeftPage, function()
    self:OnClickForButtonLeftPage()
    self:RefreshZenyCell()
  end)
  self:AddClickEvent(self.goBGBTN_RightPage, function()
    self:OnClickForButtonRightPage()
    self:RefreshZenyCell()
  end)
end

function UISubViewControllerMonthlyVIP:RegisterClickEvent()
  self:AddClickEvent(self.goCard, function()
    self:OnClickForViewCard()
  end)
  self:AddClickEvent(self.goBCForScrollDesp, function()
    self:ShowCard(self.showCardIndex)
  end)
  self:AddClickEvent(self.goBCForScrollReward, function()
    self:ShowCard(self.showCardIndex)
  end)
end

function UISubViewControllerMonthlyVIP:GetModelSet()
  for _, v in pairs(Table_Deposit) do
    if v.Type == 2 then
      self.monthlyVIPShopItemConf = v
      break
    end
  end
end

function UISubViewControllerMonthlyVIP:GetMonthCardConfigure()
  local year = UIModelMonthlyVIP.YearOfServer(-18000)
  local month = UIModelMonthlyVIP.MonthOfServer(-18000)
  if (BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()) and year == 2018 and month == 10 then
    month = 11
  end
  for _, v in pairs(Table_MonthCard) do
    if v.Year == year and v.Month == month then
      return v
    end
  end
  return nil
end

function UISubViewControllerMonthlyVIP:LoadView()
  if self.showContentIndex == 1 or self.showContentIndex == 3 then
    self:ShowCard(self.showCardIndex)
  elseif self.showContentIndex == 2 then
    self:ShowMonthlyVIPDesp()
  elseif self.showContentIndex == 4 then
    self:ShowEPVIPReward()
  end
end

function UISubViewControllerMonthlyVIP:SetActive_Card(b)
  self.goCard:SetActive(b)
end

function UISubViewControllerMonthlyVIP:SetActive_MonthlyVIPDesp(b)
  self.goMonthlyVIPDesp:SetActive(b)
  self.goBoardM:SetActive(b)
  self.goYearAndMonth:SetActive(b)
end

function UISubViewControllerMonthlyVIP:SetActive_EPVIPReward(b)
  self.goEPVIPReward:SetActive(b)
end

function UISubViewControllerMonthlyVIP:SetActive_EPBoard(b)
  self.goBoard1E:SetActive(b)
  self.goBoardE:SetActive(b)
  self.goEPNumber:SetActive(b)
  self.helpButton:SetActive(b and not BranchMgr.IsJapan())
end

function UISubViewControllerMonthlyVIP:SetActive_ExpirationTime(b)
  self.goExpirationTime:SetActive(b)
end

function UISubViewControllerMonthlyVIP:SetActive_Discount(b)
  self.goDiscount:SetActive(b)
  self.goOriginPrice:SetActive(b)
  self.LeftYouHuiNumber:SetActive(b)
  self.LeftCanBuyNumber.gameObject:SetActive(b)
end

function UISubViewControllerMonthlyVIP:SetActive_MonthlyVIPReward(b)
  self.goMonthlyReward:SetActive(b)
end

function UISubViewControllerMonthlyVIP:TryShowDepositCardReward(isAccLimit, count)
  self.depositCardReward = ShopProxy.Instance:GetDepositCardRewardByDepositAndCount(self.productConf.id, isAccLimit, count)
  if self.depositCardReward then
    self.rewardLabel.text = self.depositCardReward.desc or ""
    self:SetActive_MonthlyVIPReward(true)
    return true
  else
    self:SetActive_MonthlyVIPReward(false)
    return false
  end
end

function UISubViewControllerMonthlyVIP:ShowCard(show_index)
  self:SetActive_MonthlyVIPDesp(false)
  self:SetActive_EPVIPReward(false)
  self:SetActive_MonthlyVIPReward(false)
  self:SetActive_Card(true)
  if show_index == 0 then
    self:SetActive_EPBoard(false)
    self:SetActive_ExpirationTime(true)
    self:ShowMonthlyVIPTime()
    local monthCardConfigure = self:GetMonthCardConfigure()
    if monthCardConfigure and not StringUtil.IsEmpty(monthCardConfigure.Picture) then
      if self.monthCardPictureName then
        PictureManager.Instance:UnLoadMonthCard(self.monthCardPictureName)
      end
      PictureManager.Instance:SetMonthCardUI(monthCardConfigure.Picture, self.texCard)
      self.monthCardPictureName = monthCardConfigure.Picture
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
          self.texCard.mainTexture = nil
        end
      end
    end
    self.labBTNTitlePurchaseMonthlyVIP.text = self.monthlyVIPShopItemConf.priceStr or self:GetPriceString(self.monthlyVIPShopItemConf.Rmb)
    self:SetActive_Discount(false)
    self.showContentIndex = 1
    self.LeftYouHuiNumber.gameObject:SetActive(false)
    self.productConf = self.monthlyVIPShopItemConf
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
  else
    self:SetActive_EPBoard(true)
    self:SetActive_ExpirationTime(false)
    self:SetPurchaseBTNPos(true)
    self.epCardConf = Table_Deposit[self.epVIPCards[show_index].id1]
    if self.epCardConf.ReplaceName and self.epCardConf.ReplaceName ~= "" then
      self.labEP.text = self.epCardConf.ReplaceName
    else
      local ep = self.epVIPCards[show_index].version
      self.labEP.text = "EP " .. ep
      if math.floor(ep) == ep then
        self.labEP.text = "EP " .. ep .. ".0"
      end
    end
    self.productConf = self.epCardConf
    self.epCardPictureName = self.epCardConf.Picture
    PictureManager.Instance:SetEPCardUI(self.epCardPictureName, self.texCard)
    if self:IsDiscount() then
      self.discountEPCardConf = Table_Deposit[self.epVIPCards[show_index].id2]
      self.labBTNTitlePurchaseMonthlyVIP.text = self.discountEPCardConf.priceStr or self:GetPriceString(self.discountEPCardConf.Rmb)
      self.labOriginPrice.text = ZhString.HappyShop_originalCost .. self:GetPriceString(self.epCardConf.Rmb)
      self.spDelLine.width = self.labOriginPrice.width + 20
      local percent = math.ceil(self.discountEPCardConf.Rmb * 100 / self.epCardConf.Rmb)
      if not BranchMgr.IsChina() and not BranchMgr.IsTW() then
        percent = 100 - percent
      else
        percent = percent - 100
      end
      UIPriceDiscount.SetDiscount(percent, self.spPercentBG, self.labPercent, self.labPercentSymbol)
      if percent == 0 or percent == 100 then
        self.goDiscount:SetActive(false)
      end
      self.productConf = self.discountEPCardConf
    else
      self.labBTNTitlePurchaseMonthlyVIP.text = self.epCardConf.priceStr or self:GetPriceString(self.epCardConf.Rmb)
    end
    self.showContentIndex = 3
    if self:IsDiscount() and self.discountEPCardConf and self.discountEPCardConf.ActivityDiscountLimit and 0 < self.discountEPCardConf.ActivityDiscountLimit then
      self.LeftYouHuiNumberLab_UILabel.text = ZhString.HappyShop_DiscountLeftTimes .. self.discountEPCardConf.ActivityDiscountLimit
      self.LeftYouHuiNumber.gameObject:SetActive(true)
    else
      self.LeftYouHuiNumber.gameObject:SetActive(false)
    end
    self.LeftCanBuyNumberLab_UILabel.text = ZhString.HappyShop_CanBuy .. self.epCardConf.MonthLimit
    self:UpdateUIAccordingToChargeCntTable()
  end
end

function UISubViewControllerMonthlyVIP:HandleAccChargeCntReward(note)
  if self.gameObject.name ~= "UISubViewMonthlyVIP" then
    return
  end
  self:ShowCard(self.showCardIndex)
end

function UISubViewControllerMonthlyVIP:HandleChargeQueryCmd(note)
  local data = note.body
  if not data then
    return
  end
  if data.data_id == self.monthlyVIPShopItemConf.id then
    self.monthlyVIPShopItemChargedCount = data.charged_count
  end
end

function UISubViewControllerMonthlyVIP:HandlePicture(note)
  local data = note.body
  if data and self.monthCardUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end

function UISubViewControllerMonthlyVIP:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    self.texCard.mainTexture = texture
  end
end

function UISubViewControllerMonthlyVIP:UpdateUIAccordingToChargeCntTable()
  local shopIns = ShopProxy.Instance
  if shopIns.ChargeCntTable and self.discountEPCardConf and self.epCardConf then
    for k, v in pairs(shopIns.ChargeCntTable) do
      if v.dataid == self.epCardConf.id then
        local leftAllLimit = self.epCardConf.MonthLimit - v.count
        if leftAllLimit < 0 then
          leftAllLimit = 0
        end
        self.LeftCanBuyNumberLab_UILabel.text = ZhString.HappyShop_CanBuy .. leftAllLimit
        self:SetActive_Discount(false)
        self.labBTNTitlePurchaseMonthlyVIP.text = self.epCardConf.priceStr or self:GetPriceString(self.epCardConf.Rmb)
        break
      elseif v.dataid == self.discountEPCardConf.id then
        local leftAllLimit = self.epCardConf.MonthLimit - v.count
        if leftAllLimit < 0 then
          leftAllLimit = 0
        end
        self.LeftCanBuyNumberLab_UILabel.text = ZhString.HappyShop_CanBuy .. leftAllLimit
        local leftDiscount = self.discountEPCardConf.ActivityDiscountLimit - v.count
        if leftDiscount < 0 then
          leftDiscount = 0
        end
        self.LeftYouHuiNumberLab_UILabel.text = ZhString.HappyShop_DiscountLeftTimes .. leftDiscount
        if leftDiscount == 0 then
          self:SetActive_Discount(false)
          self.labBTNTitlePurchaseMonthlyVIP.text = self.epCardConf.priceStr or self:GetPriceString(self.epCardConf.Rmb)
        end
        break
      end
    end
  end
end

function UISubViewControllerMonthlyVIP:ShowMonthlyVIPDesp()
  self:SetActive_MonthlyVIPDesp(true)
  self:SetActive_EPVIPReward(false)
  self:SetActive_Card(false)
  self:SetActive_EPBoard(false)
  self.listControllerOfVIPDescriptions:ResetDatas(self:GetUIData(), true, true)
  self.goSv:ResetPosition()
  self:ShowMonthlyVIPTime()
  self.showContentIndex = 2
end

local SQR_MAGNITUDE = LuaVector3.SqrMagnitude

function UISubViewControllerMonthlyVIP:OnScrollViewDragFinished()
  self.InitScrollViewLocalPos = self.goSv.gameObject.transform.localPosition.y
  
  function self.goSv.onDragFinished()
    local b = self.goSv.bounds
    local constraint = self.goPanel:CalculateConstrainOffset(b.min, b.max)
    local curPos = self.goSv.gameObject.transform.localPosition.y
    if 0.1 < SQR_MAGNITUDE(constraint) and curPos > self.InitScrollViewLocalPos then
      self.goListArrow:SetActive(false)
    else
      self.goListArrow:SetActive(true)
    end
  end
end

function UISubViewControllerMonthlyVIP:GetUIData()
  monthlyVIPInfosForUITableListCtrl = {}
  local dynamicVIPDescription
  for _, v in pairs(GameConfig.DepositCard) do
    if v.type1 == 2 then
      dynamicVIPDescription = v.funcs
      break
    end
  end
  local monthConf = self:GetMonthCardConfigure()
  for k, _ in pairs(Table_DepositFunction) do
    local vipDescriptionConfID = k
    if table.ContainsValue(dynamicVIPDescription, vipDescriptionConfID) then
      local uiListItemModelVIPDescription = UIListItemModelVIPDescription.new(monthConf)
      uiListItemModelVIPDescription:SetDescriptionConfigID(vipDescriptionConfID)
      table.insert(monthlyVIPInfosForUITableListCtrl, uiListItemModelVIPDescription)
    end
  end
  return monthlyVIPInfosForUITableListCtrl
end

function UISubViewControllerMonthlyVIP:ShowEPVIPReward()
  self:SetActive_Card(false)
  self:SetActive_EPVIPReward(true)
  if self.listControllerOfReward == nil then
    self.uiGridOfReward = self.goRewardRoot:GetComponent(UIGrid)
    self.listControllerOfReward = UIGridListCtrl.new(self.uiGridOfReward, UIListItemViewControllerItem, "UIListItemItem")
  end
  local useItemID = self.epCardConf.ItemId
  local team = Table_UseItem[useItemID].UseEffect.id
  local items = ItemUtil.GetRewardItemIdsByTeamId(team)
  if items then
    self.listControllerOfReward:ResetDatas(items)
    self.itemsController = self.listControllerOfReward:GetCells()
    self.scrollViewReward:ResetPosition()
    self.showContentIndex = 4
  end
end

function UISubViewControllerMonthlyVIP:ShowMonthlyVIPTime()
  local year = UIModelMonthlyVIP.YearOfServer(-18000)
  local month = UIModelMonthlyVIP.MonthOfServer(-18000)
  self.labYear.text = tostring(year)
  if month < 10 then
    self.labMonth.text = "0" .. tostring(month)
  else
    self.labMonth.text = tostring(month)
  end
  local expirationTime = UIModelMonthlyVIP.Instance():Get_TimeOfExpirationMonthlyVIP()
  if expirationTime ~= nil then
    expirationTime = expirationTime - 18001
    local year = UIModelMonthlyVIP.YearOfUnixTimestamp(expirationTime)
    local month = UIModelMonthlyVIP.MonthOfUnixTimestamp(expirationTime)
    local day = UIModelMonthlyVIP.DayOfUnixTimestamp(expirationTime)
    self.labExpirationTime.text = string.format(ZhString.MouthCard_End, year, month, day)
    self:SetPurchaseBTNPos(false)
  else
    self.labExpirationTime.text = ""
  end
end

function UISubViewControllerMonthlyVIP:SetPurchaseBTNPos(b)
  local xValue
  if b then
    xValue = 117
  else
    xValue = 135
  end
  local posOfBTN = self.goBTNPurchaseMonthlyVIP.transform.localPosition
  posOfBTN.x = xValue
  self.goBTNPurchaseMonthlyVIP.transform.localPosition = posOfBTN
end

function UISubViewControllerMonthlyVIP:OnClickForButtonPurchaseCard(show_card_index)
  local showCardIndex = show_card_index or self.showCardIndex
  if not BranchMgr.IsJapan() and not BranchMgr.IsKorea() then
    helplog("OnClickForButtonPurchaseCard:", self.showCardIndex)
    if showCardIndex == 0 then
      self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
      self.dazhe = false
    elseif 0 < showCardIndex then
      self:RequestQueryChargeCnt()
      local card = self.epVIPCards[showCardIndex]
      self.queryChargeAndPurchaseID = card.id2 or card.id1
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
    if BranchMgr.IsKorea() then
      self.dazhe = false
    end
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", "[0075BCFF]" .. productName .. "[-]", currencyType, FuncZenyShop.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
      self:RequestChargeQuery(self.monthlyVIPShopItemConf.id)
    end)
  elseif 0 < showCardIndex then
    local card = self.epVIPCards[showCardIndex]
    self.queryChargeAndPurchaseID = card.id2 or card.id1
    local cardConf = Table_Deposit[self.queryChargeAndPurchaseID]
    local productName = OverSea.LangManager.Instance():GetLangByKey(cardConf.Desc)
    if BranchMgr.IsKorea() then
      if card.id2 == card.id1 then
        self.dazhe = false
      else
        self.budazheid = card.id1
        self.dazhe = true
      end
    end
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle2 .. "[-]", "[0075BCFF]" .. productName .. "[-]", "", self.labBTNTitlePurchaseMonthlyVIP.text), ZhString.ShopConfirmDes, productName, "", function()
      self:RequestQueryChargeCnt()
    end)
  end
end

function UISubViewControllerMonthlyVIP:OnClickForButtonLeftPage()
  if self.epVIPCards ~= nil then
    if self.showCardIndex <= 0 then
      self.showCardIndex = #self.epVIPCards
    else
      self.showCardIndex = self.showCardIndex - 1
    end
    self:ShowCard(self.showCardIndex)
  end
end

function UISubViewControllerMonthlyVIP:OnClickForButtonRightPage()
  if self.epVIPCards ~= nil then
    if self.showCardIndex >= #self.epVIPCards then
      self.showCardIndex = 0
    else
      self.showCardIndex = self.showCardIndex + 1
    end
    self:ShowCard(self.showCardIndex)
  end
end

function UISubViewControllerMonthlyVIP:OnClickForViewCard()
  if self.showContentIndex == 1 then
    self:ShowMonthlyVIPDesp()
  elseif self.showContentIndex == 3 then
    self:ShowEPVIPReward()
  end
end

function UISubViewControllerMonthlyVIP:ListenServerResponse()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeQueryCmd, self.OnReceiveChargeQuery, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
end

function UISubViewControllerMonthlyVIP:CancelListenServerResponse()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeQueryCmd, self.OnReceiveChargeQuery, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
end

function UISubViewControllerMonthlyVIP:RefreshZenyCell()
  if not BranchMgr.IsJapan() then
    return
  end
  helplog("UISubViewControllerMonthlyVIP:RefreshZenyCell", self.showCardIndex)
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.productConf and self.productConf.Rmb or 0
    helplog(currency, left)
    if left < currency then
      self:SetEnable(false)
    else
      self:SetEnable(true)
    end
  else
    helplog("unlimit")
    self:SetEnable(true)
  end
end

function UISubViewControllerMonthlyVIP:SetEnable(enable)
  if not BranchMgr.IsJapan() then
    return
  end
  local goBTNPurchaseCollider = self.goBTNPurchaseMonthlyVIP:GetComponent(BoxCollider)
  local back = self:FindGO("Normal", self.goBTNPurchaseMonthlyVIP):GetComponent(UISprite)
  if enable then
    self.labBTNTitlePurchaseMonthlyVIP.effectColor = LuaGeometry.GetTempColor(0.6784313725490196, 0.38823529411764707, 0.027450980392156862, 1)
    back.color = Color.white
  else
    self.labBTNTitlePurchaseMonthlyVIP.effectColor = LuaGeometry.GetTempColor(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    ColorUtil.ShaderGrayUIWidget(back)
  end
  goBTNPurchaseCollider.enabled = enable
end

function UISubViewControllerMonthlyVIP:RequestChargeQuery(shop_item_conf_id)
  ServiceUserEventProxy.Instance:CallChargeQueryCmd(shop_item_conf_id)
end

function UISubViewControllerMonthlyVIP:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function UISubViewControllerMonthlyVIP:OnReceiveChargeQuery(data)
  helplog("---OnReceiveChargeQuery(data)---")
  if not self.monthlyVIPShopItemConf then
    return
  end
  if not self.isInit then
    return
  end
  if data.data_id == self.monthlyVIPShopItemConf.id then
    if data.ret then
      if PurchaseDeltaTimeLimit.Instance():IsEnd(self.monthlyVIPShopItemConf.ProductID) then
        self:Purchase()
        local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
        PurchaseDeltaTimeLimit.Instance():Start(self.monthlyVIPShopItemConf.ProductID, interval)
      else
        MsgManager.ShowMsgByID(49)
      end
    else
      local depositData = Table_Deposit[data.data_id]
      helplog("111 data.data_id:" .. data.data_id)
      if depositData.MonthLimit then
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

function UISubViewControllerMonthlyVIP:OnReceivePurchaseSuccess(message)
  local messageContent = message
  local confID = messageContent.dataid
  if confID and 0 < confID then
    local conf = Table_Deposit[confID]
    if conf.Type == 2 then
      PurchaseDeltaTimeLimit.Instance():End(conf.ProductID)
    elseif conf.Type == 5 then
      PurchaseDeltaTimeLimit.Instance():End(conf.ProductID)
    end
  end
end

function UISubViewControllerMonthlyVIP:OnReceiveQueryChargeCnt(data)
  if self.queryChargeAndPurchaseID ~= nil then
    local purchaseTimes = 0
    local info = data.info
    for i = 1, #info do
      local purchaseInfo = info[i]
      local productConfID = purchaseInfo.dataid
      if productConfID == self.queryChargeAndPurchaseID then
        purchaseTimes = purchaseInfo.count
      end
    end
    local productConf = Table_Deposit[self.queryChargeAndPurchaseID]
    if purchaseTimes < productConf.MonthLimit then
      if PurchaseDeltaTimeLimit.Instance():IsEnd(productConf.ProductID) then
        self:Purchase()
        local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
        PurchaseDeltaTimeLimit.Instance():Start(productConf.ProductID, interval)
      else
        MsgManager.ShowMsgByID(49)
      end
    elseif self.dazhe then
      productConf = Table_Deposit[self.budazheid]
      if purchaseTimes < productConf.MonthLimit then
        if PurchaseDeltaTimeLimit.Instance():IsEnd(productConf.ProductID) then
          self:Purchase(self.budazheid)
          local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
          PurchaseDeltaTimeLimit.Instance():Start(productConf.ProductID, interval)
        else
          MsgManager.ShowMsgByID(49)
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
    self.queryChargeAndPurchaseID = nil
  end
  self:UpdateUIAccordingToChargeCntTable()
end

function UISubViewControllerMonthlyVIP:IsDiscount()
  local retValue = false
  if self.showCardIndex > 0 then
    local card = self.epVIPCards[self.showCardIndex]
    retValue = 0 < card.id2
    if card.id2 == card.id1 then
      retValue = false
    end
  end
  self:SetActive_Discount(retValue)
  return retValue
end

function UISubViewControllerMonthlyVIP:GetPriceString(price)
  return self.monthlyVIPShopItemConf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(price)
end

function UISubViewControllerMonthlyVIP:Purchase(custom_pid)
  local productConf
  if self.showCardIndex == 0 then
    productConf = self.monthlyVIPShopItemConf
  else
    local card = self.epVIPCards[self.showCardIndex]
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
      LogUtility.Info("UIViewControllerZenyShop:OnPaySuccess, " .. str_result)
      if BranchMgr.IsJapan() then
        local currency = self.productConf and self.productConf.Rmb or 0
        ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      end
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("UIViewControllerZenyShop:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("UIViewControllerZenyShop:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("UIViewControllerZenyShop:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("UIViewControllerZenyShop:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("UIViewControllerZenyShop:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
  else
    MsgManager.ShowMsgByID(49)
  end
end

function UISubViewControllerMonthlyVIP:Purchase2(customid)
  local productConf
  if self.showCardIndex == 0 then
    productConf = self.monthlyVIPShopItemConf
  else
    local card = self.epVIPCards[self.showCardIndex]
    local confID = self:GetVipCardId(card)
    if customid then
      confID = customid
    end
    productConf = Table_Deposit[confID]
  end
  local productID = productConf.ProductID
  if productID then
    ServiceUserEventProxy.Instance:CallChargeSdkRequestUserEvent(self.productConf.id, ServerTime.CurServerTime())
    local productName = productConf.Desc
    local productPrice = productConf.Rmb
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
        if not BranchMgr.IsChina() then
          TableUtility.TableClear(gReusableTable)
          return
        end
        local runtimePlatform = ApplicationInfo.GetRunPlatform()
        if runtimePlatform == RuntimePlatform.Android then
          TableUtility.TableClear(gReusableTable)
          gReusableTable.productGameID = tostring(productConf.id)
          gReusableTable.serverID = tostring(serverID)
          FuncPurchase.SetPayCallbackCode(gReusableTable)
          local ext = json.encode(gReusableTable)
          if not BackwardCompatibilityUtil.CompatibilityMode_V81 then
            FunctionSDK.Instance:XDSDKPay(productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext, function(x)
              self:OnPaySuccess(x)
            end, function(x)
              self:OnPayFail(productID, x)
            end, function(x)
              self:OnPayCancel(productID, x)
            end)
          else
            FunctionXDSDK.Ins:Pay(productName, productID, productPrice * 100, 5, tostring(roleID), "", ext, function(x)
              self:OnPaySuccess(productConf, x)
            end, function(x)
              self:OnPayFail(productConf, x)
            end, function(x)
              self:OnPayCancel(productConf, x)
            end)
          end
        elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then
          TableUtility.TableClear(gReusableTable)
          gReusableTable.productGameID = tostring(productConf.id)
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
          local roleAndServerTime = roleID .. "_" .. currentServerTime
          self.orderIDOfXDSDKPay = MyMD5.HashString(roleAndServerTime)
          FunctionSDK.Instance:XDSDKPay(productPrice * 100, tostring(serverID), productID, productName, tostring(roleID), ext, productCount, self.orderIDOfXDSDKPay, function(x)
            self:OnPaySuccess(x)
          end, function(x)
            self:OnPayFail(productID, x)
          end, function(x)
            self:OnPayTimeout(productID, x)
          end, function(x)
            self:OnPayCancel(productID, x)
          end, function(x)
            self:OnPayProductIllegal(productID, x)
          end)
        end
      end
    end
  end
end

function UISubViewControllerMonthlyVIP:OnPaySuccess(str_result)
  local str_result = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPaySuccess, " .. str_result)
  if self.productConf and self.productConf.id then
    ServiceUserEventProxy.Instance:CallChargeSdkReplyUserEvent(self.productConf.id, ServerTime.CurServerTime(), true)
  end
  if BranchMgr.IsJapan() then
    local currency = self.productConf and self.productConf.Rmb or 0
    ChargeComfirmPanel:ReduceLeft(tonumber(currency))
  end
  EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.IPhonePlayer then
    if self.orderIDOfXDSDKPay ~= nil then
      FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(self.orderIDOfXDSDKPay, self.monthlyVIPShopItemConf.Rmb)
    end
  elseif runtimePlatform == RuntimePlatform.Android then
    FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd("", self.monthlyVIPShopItemConf.Rmb)
  end
end

function UISubViewControllerMonthlyVIP:OnPayFail(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayFail, " .. strResult)
  if self.productConf and self.productConf.id then
    ServiceUserEventProxy.Instance:CallChargeSdkReplyUserEvent(self.productConf.id, ServerTime.CurServerTime(), false)
  end
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end

function UISubViewControllerMonthlyVIP:OnPayTimeout(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayTimeout, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end

function UISubViewControllerMonthlyVIP:OnPayCancel(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayCancel, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end

function UISubViewControllerMonthlyVIP:OnPayProductIllegal(product_id, str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayProductIllegal, " .. strResult)
  PurchaseDeltaTimeLimit.Instance():End(product_id)
end

function UISubViewControllerMonthlyVIP:OnPayPaying(str_result)
  local strResult = str_result or "nil"
  LogUtility.Info("UIViewControllerZenyShop:OnPayPaying, " .. strResult)
end
