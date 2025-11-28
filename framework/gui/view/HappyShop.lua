autoImport("ShopItemCell")
autoImport("HappyShopBuyItemCell")
autoImport("ServantHeadCell")
autoImport("ShopItemWithGiftCell")
HappyShop = class("HappyShop", ContainerView)
HappyShop.ViewType = UIViewType.NormalLayer
ShopInfoType = {
  MyProfession = "MyProfession",
  All = "All"
}
local originWidth = 94
local originposY = -75

function HappyShop:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end

function HappyShop:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function HappyShop:FindObjs()
  self.moneySprite = {}
  self.moneySprite[1] = self:FindGO("goldIcon"):GetComponent(UISprite)
  self.moneySprite[2] = self:FindGO("silversIcon"):GetComponent(UISprite)
  self.moneyLabel = {}
  self.moneyLabel[1] = self:FindGO("gold"):GetComponent(UILabel)
  self.moneyLabel[2] = self:FindGO("silvers"):GetComponent(UILabel)
  self.LeftStick = self:FindGO("LeftStick"):GetComponent(UISprite)
  self.ItemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.ItemScrollViewSpecial = self:FindGO("ItemScrollViewSpecial"):GetComponent(UIScrollView)
  self.toggleRoot = self:FindGO("ToggleRoot")
  if self.toggleRoot then
    self.myProfessionBtn = self:FindGO("MyProfessionBtn"):GetComponent(UIToggle)
    self.myProfessionLabel = self:FindGO("MyProfessionLabel"):GetComponent(UILabel)
    self.allBtn = self:FindGO("AllBtn")
    self.allLabel = self:FindGO("AllLabel"):GetComponent(UILabel)
  end
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.skipBtn.gameObject:SetActive(HappyShopProxy.Instance:IsShowSkip())
  self.descBg = self:FindGO("Bg")
  self.descLab = self:FindGO("desc"):GetComponent(UILabel)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.specialRoot = self:FindGO("SpecialRoot")
  self.limitLab = self:FindComponent("LimitLab", UILabel)
  local titleBg = self:FindGO("titleBg")
  self.titleLab = self:FindComponent("Label", UILabel, titleBg)
  self.money1GO = self:FindGO("money1")
  if self.money1GO then
    self.money1tg = self.money1GO:GetComponent(UIToggle)
    self.money1Label = self:FindGO("money1Label"):GetComponent(UILabel)
    self.money1sprite = self:FindGO("money1Sprite"):GetComponent(UISprite)
  end
  self.money2GO = self:FindGO("money2")
  if self.money2GO then
    self.money2tg = self.money2GO:GetComponent(UIToggle)
    self.money2Label = self:FindGO("money2Label"):GetComponent(UILabel)
    self.money2sprite = self:FindGO("money2Sprite"):GetComponent(UISprite)
  end
  self.showtoggle = self:FindGO("ShowToggle")
  self:InitBuyItemCell()
  self.servantExp = self:FindGO("ServantExt")
  if self.servantExp then
    self.servantbg = self:FindGO("servantbg", self.servantExp):GetComponent(UISprite)
    self.servantBtn = self:FindGO("expandBtn", self.servantExp)
    self.servantSp = self.servantBtn:GetComponent(UISprite)
    self.servantSC = self:FindGO("ServantScrollview", self.servantExp):GetComponent(UIScrollView)
    self.servantGrid = self:FindGO("ServantGrid", self.servantExp):GetComponent(UIGrid)
    self.servantCtl = UIGridListCtrl.new(self.servantGrid, ServantHeadCell, "ServantHeadCell")
    self.servantCtl:AddEventListener(MouseEvent.MouseClick, self.ClickServantHead, self)
    self.expandToggle = false
    self:AddClickEvent(self.servantBtn, function(go)
      self.expandToggle = not self.expandToggle
      if not self.expandToggle then
        local myServantid = MyselfProxy.Instance:GetMyServantID()
        if myServantid == 0 then
          local shortcutid = Game.Myself.data:IsDoram() and 5044 or 1005
          MsgManager.ConfirmMsgByID(25405, function()
            FuncShortCutFunc.Me():CallByID(shortcutid)
          end)
          self:CloseSelf()
          return
        end
      end
      self:InitServantList()
    end)
  end
  self.customToggleRoot = self:FindGO("CustomToggle")
  self.customTgSprite = {}
  self.customToggle = {}
  for i = 1, 4 do
    local customRoot = self:FindGO("custom" .. i, self.customToggleRoot)
    self.customToggle[i] = customRoot:GetComponent(UIToggle)
    self.customTgSprite[i] = self:FindGO("custom" .. i .. "Sprite"):GetComponent(UISprite)
  end
  self.leftIndicator = self:FindGO("leftIndicator", self.customToggleRoot)
  self.rightIndicator = self:FindGO("rightIndicator", self.customToggleRoot)
  self.searchToggle = self:FindGO("SearchToggle")
  self.searchInput = self:FindGO("SearchInput"):GetComponent(UIInput)
  self.searchInput.defaultText = ZhString.HappyShop_Search
  self.noneTip = self:FindGO("NoneTip")
end

function HappyShop:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
end

function HappyShop:SetScrollView()
  local isSpecial = HappyShopProxy.Instance:isGuildMaterialType()
  self.ItemScrollView.gameObject:SetActive(not isSpecial)
  self.specialRoot:SetActive(isSpecial)
  local sv = isSpecial and self.ItemScrollViewSpecial or self.ItemScrollView
  
  function sv.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
end

function HappyShop:AddEvts()
  if self.buyCell.countPlusBg then
    self:AddOrRemoveGuideId(self.buyCell.countPlusBg.gameObject, 16)
  end
  if self.buyCell.confirmButton then
    self:AddOrRemoveGuideId(self.buyCell.confirmButton.gameObject, 17)
  end
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:OnClickSkip()
  end)
  if self.myProfessionBtn then
    self:AddClickEvent(self.myProfessionBtn.gameObject, function(g)
      self:ClickMyProfession(g)
    end)
  end
  if self.allBtn then
    self:AddClickEvent(self.allBtn, function(g)
      self:ClickAll(g)
    end)
  end
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  self.npcFuctionID = config.id
  self.toggleOffset = 0
  if config.Parama.ItemID then
    if self.money1tg then
      self:AddClickEvent(self.money1tg.gameObject, function(g)
        self.tabid = 1
        self:ClickMoneyType()
      end)
    end
    if self.money2tg then
      self:AddClickEvent(self.money2tg.gameObject, function(g)
        self.tabid = 2
        self:ClickMoneyType()
      end)
    end
    for i = 1, 4 do
      self:AddClickEvent(self.customToggle[i].gameObject, function(g)
        self.tabid = i + self.toggleOffset
        self:ClickCustomeType()
      end)
    end
    if self.leftIndicator then
      self:AddClickEvent(self.leftIndicator.gameObject, function(g)
        self.toggleOffset = self.toggleOffset - 1
        self:RefreshIndicator()
        self:ClickIndicator()
      end)
    end
    if self.rightIndicator then
      self:AddClickEvent(self.rightIndicator.gameObject, function(g)
        self.toggleOffset = self.toggleOffset + 1
        self:RefreshIndicator()
        self:ClickIndicator()
      end)
    end
    self:RefreshIndicator()
  end
end

function HappyShop:OnClickSkip()
  local skipType = HappyShopProxy.Instance.aniConfig[2]
  if skipType then
    TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Top, {120, 50})
  end
end

function HappyShop:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopInfo)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopSoldCountCmd, self.HandleShopSoldCountCmd)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvUpdateShopConfig)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.SessionShopExchangeShopItemCmd, self.HideGoodsTip)
  self:AddListenEvt(ServiceEvent.SessionShopFreyExchangeShopCmd, self.HideGoodsTip)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.SetLimitLab)
  self:AddListenEvt(ServiceEvent.GuildCmdBuildingNtfGuildCmd, self.SetLimitLab)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserSysMsg, self.JumpToAppReview)
  self:AddListenEvt(XDEUIEvent.CloseHappyShopView, self.OverseaAndroidBack)
  EventDelegate.Add(self.searchInput.onSubmit, function()
    self:OnSearchSubmit()
  end)
end

function HappyShop:InitShow()
  self.tipData = {
    funcConfig = _EmptyTable
  }
end

function HappyShop:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function HappyShop:InitUI()
  self:InitShopInfo()
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.RecvItemGetCount, self)
  self:InitScreen()
  self:InitSearchToggle()
  self:InitShowtoggle()
  self:InitLeftUpIcon()
  self:UpdateShopInfo(true)
  self:UpdateMoney()
  self.descLab.text = HappyShopProxy.Instance.desc
  self:SetScrollView()
  self:SetLimitLab()
  self.buyCell.gameObject:SetActive(false)
  self.default = HappyShopProxy.Instance:GetShopType()
  self.lastSelect = nil
  self:InitServantList()
  self:InitFilter()
end

function HappyShop:InitShopInfo()
  local isGuildMaterialType = HappyShopProxy.Instance:isGuildMaterialType()
  self.itemContainer = isGuildMaterialType and self:FindGO("shop_itemContainerSpecial") or self:FindGO("shop_itemContainer")
  self:ReInitShopInfo()
  self.CloseWhenClickOtherPlace:AddTarget(self.itemContainer.transform)
end

function HappyShop:ReInitShopInfo()
  local isGuildMaterialType = HappyShopProxy.Instance:isGuildMaterialType()
  local hasGift = HappyShopProxy.Instance:HasGift() or false
  if self.hasGift == hasGift and self.isGuildMaterialType == isGuildMaterialType then
    return
  end
  self.hasGift = hasGift
  self.isGuildMaterialType = isGuildMaterialType
  local wrap = self.itemContainer:GetComponent(UIWrapContent)
  wrap.itemSize = hasGift and 150 or 115
  local cellName = hasGift and "ShopItemWithGiftCell" or "ShopItemCell"
  local control = hasGift and ShopItemWithGiftCell or ShopItemCell
  local wrapConfig = {
    wrapObj = self.itemContainer,
    pfbNum = 6,
    cellName = cellName,
    control = control,
    dir = 1,
    disableDragIfFit = true
  }
  if isGuildMaterialType then
    if self.specialItemWrapHelper then
      local cells = self.specialItemWrapHelper:GetCellCtls()
      for _, cell in pairs(cells) do
        GameObject.DestroyImmediate(cell.gameObject)
      end
      self.specialItemWrapHelper:__OnViewDestroy()
      self.specialItemWrapHelper = nil
    end
    self.specialItemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.specialItemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.specialItemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
    self.specialItemWrapHelper:AddEventListener(HappyShopEvent.ExchangeBtnClick, self.HandleClickItemExchange, self)
    self.specialItemWrapHelper:AddEventListener(HappyShopEvent.GiftItemClick, self.HandleClickGiftItem, self)
  else
    if self.itemWrapHelper then
      local cells = self.itemWrapHelper:GetCellCtls()
      for _, cell in pairs(cells) do
        GameObject.DestroyImmediate(cell.gameObject)
      end
      self.itemWrapHelper:__OnViewDestroy()
      self.itemWrapHelper = nil
    end
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
    self.itemWrapHelper:AddEventListener(HappyShopEvent.ExchangeBtnClick, self.HandleClickItemExchange, self)
    self.itemWrapHelper:AddEventListener(HappyShopEvent.GiftItemClick, self.HandleClickGiftItem, self)
  end
end

function HappyShop:InitScreen()
  if HappyShopProxy.Instance:GetScreen() then
    self.infoType = ShopInfoType.MyProfession
    if self.toggleRoot then
      self.toggleRoot:SetActive(true)
      self.myProfessionBtn.value = true
      self.myProfessionLabel.color = ColorUtil.TitleBlue
      self.allLabel.color = ColorUtil.TitleGray
    end
  else
    self.infoType = ShopInfoType.All
    if self.toggleRoot then
      self.toggleRoot:SetActive(false)
    end
  end
end

function HappyShop:InitShowtoggle()
  self.tabid = 1
  if HappyShopProxy.Instance:GetTab() then
    local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
    local itemid = config.Parama.ItemID
    if config.Parama.TabCustomIcon then
      self:InitCustomToggle()
    else
      self.showtoggle:SetActive(true)
      self.customToggleRoot:SetActive(false)
      self.money1tg.value = true
      self.money1Label.color = ColorUtil.TitleBlue
      self.money1Label.text = Table_Item[itemid[1]].NameZh
      self.money1sprite.spriteName = "shop_icon_" .. itemid[1]
      self.money1sprite.color = ColorUtil.TitleBlue
      self.money2Label.color = ColorUtil.TitleGray
      self.money2Label.text = Table_Item[itemid[2]].NameZh
      local sp2Name = "shop_icon_" .. itemid[2]
      local sp2Atlas = self.money2sprite.atlas
      if sp2Atlas:GetSprite(sp2Name) ~= nil then
        self.money2sprite.gameObject:SetActive(true)
        self.money2sprite.spriteName = sp2Name
        self.money2sprite.color = ColorUtil.TitleGray
        self.money2Label.transform.localPosition = LuaGeometry.GetTempVector3(-8, 0, 0)
      else
        self.money2sprite.gameObject:SetActive(false)
        self.money2Label.transform.localPosition = LuaGeometry.GetTempVector3(-28, 0, 0)
      end
    end
  else
    self.showtoggle:SetActive(false)
    self.customToggleRoot:SetActive(false)
  end
end

function HappyShop:InitLeftUpIcon()
  local _HappyShopProxy = HappyShopProxy
  local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
  self.shopSource = config and config.Parama.Source
  if self.shopSource == _HappyShopProxy.SourceType.Guild then
    FunctionGuild.Me():QueryGuildItemList()
    if config.Parama.ShowGuildPack ~= 1 then
      for i = 1, #self.moneySprite do
        self.moneySprite[i].gameObject:SetActive(false)
      end
      return
    end
  end
  local moneyTypes = _HappyShopProxy.Instance:GetMoneyType()
  if moneyTypes then
    for i = 1, #self.moneySprite do
      local moneyId = moneyTypes[i]
      if moneyId then
        local item = Table_Item[moneyId]
        if item then
          IconManager:SetItemIcon(item.Icon, self.moneySprite[i])
          self.moneySprite[i].gameObject:SetActive(true)
        end
      else
        self.moneySprite[i].gameObject:SetActive(false)
      end
    end
  else
    for i = 1, #self.moneySprite do
      self.moneySprite[i].gameObject:SetActive(false)
    end
  end
end

function HappyShop:JumpToAppReview(note)
  if (BranchMgr.IsSEA() or BranchMgr.IsNOTW() or BranchMgr.IsNO()) and self.npcFuctionID == 100013 and ApplicationInfo.IsMobile() then
    for i = 1, #note.body.params do
      if string.find(tostring(note.body.params[i]), "3684", 1) then
        OverSeas_TW.OverSeasManager.GetInstance():StoreReview()
        return
      end
    end
  end
end

function HappyShop:HandleClickItem(cellctl)
  if self.currentItem ~= cellctl then
    if self.currentItem then
      self.currentItem:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.currentItem = cellctl
  end
  local id = cellctl.data
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
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

function HappyShop:HandleClickItemExchange(cellctl)
  local serverFlag = MyselfProxy.Instance:GetServerId()
  local FRAY_EXCHANGE = GameConfig.Shop and GameConfig.Shop.frey_coin_exchange and GameConfig.Shop.frey_coin_exchange[serverFlag]
  if FRAY_EXCHANGE[cellctl.data] then
    ExchangeShopProxy.Instance:ResetChoose()
    TipManager.Instance:ShowExchangeGoodsTip(cellctl.data, self.tipStick, NGUIUtil.AnchorSide.Center, {-40, 0})
  end
end

function HappyShop:HandleClickIconSprite(cellctl)
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(cellctl.data)
  self:ShowHappyItemTip(data)
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function HappyShop:HandleClickGiftItem(cellctl)
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(cellctl.data)
  if data.giftItem then
    self.tipData.itemdata = data.giftItem
    self.tipData.ignoreBounds = {
      self.itemContainer
    }
    self:ShowItemTip(self.tipData, self.LeftStick)
  end
end

function HappyShop:ShowHappyItemTip(data)
  if data.goodsID then
    self.tipData.itemdata = data:GetItemData()
    if GemProxy.CheckIsGemStaticData(self.tipData.itemdata.staticData) then
      GemCell.ShowGemTip(nil, self.tipData.itemdata, self.LeftStick)
    else
      self.tipData.ignoreBounds = {
        self.itemContainer
      }
      self:ShowItemTip(self.tipData, self.LeftStick)
    end
  else
    errorLog("HappyShop ShowItemTip data.goodsID == nil")
  end
end

function HappyShop:OnEnter()
  HappyShop.super.OnEnter(self)
  local viewData = self.viewdata.viewdata
  self.preViewPort = viewData and viewData.viewPort
  self.preRotation = viewData and viewData.rotation
  self:handleCameraQuestStart()
  self:InitUI()
  self:HandleSpecial(true)
  self.currentItem = nil
  local viewData = self.viewdata.viewdata
  if viewData and viewData.onEnter then
    viewData.onEnter()
  end
  self.quality = 0
end

function HappyShop:OnExit()
  self:CameraReset()
  self.expandToggle = false
  HappyShopProxy.Instance:SetSelectId(nil)
  HappyShopProxy.Instance:RemoveLeanTween()
  self.buyCell:Exit()
  TipsView.Me():HideCurrent()
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.RecvItemGetCount, self)
  if self.needUpdateSold then
    self.needUpdateSold = false
    ServiceMatchCCmdProxy.Instance:CallOpenGlobalShopPanelCCmd(false)
  end
  self:HandleSpecial(false)
  local viewData = self.viewdata.viewdata
  HappyShop.super.OnExit(self)
  if viewData and viewData.onExit then
    viewData.onExit(viewData.onExitParam)
  end
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SHOP_COUPON)
end

function HappyShop:OnItemUpdate()
  self:UpdateMoney()
  self:UpdateShopInfo()
end

local shopCameraConfig = {
  BAR = 923,
  VENDING_MACHINE = 924,
  GUILD_MATERIAL_MACHINE = 988
}

function HappyShop:handleCameraQuestStart()
  local focusOffset = LuaVector3.Zero()
  local npcdata = HappyShopProxy.Instance:GetNPC()
  if npcdata then
    local isSpecial = true
    local shopType, viewPort, rotation
    shopType = HappyShopProxy.Instance.shopType
    if self.preViewPort and self.preRotation then
      viewPort = self.preViewPort
      rotation = self.preRotation
    elseif shopType == shopCameraConfig.VENDING_MACHINE then
      viewPort = CameraConfig.Vending_Machine_ViewPort
      rotation = CameraConfig.Vending_Machine_Rotation
    elseif shopType == shopCameraConfig.BAR then
      viewPort = CameraConfig.Bar_ViewPort
      rotation = CameraConfig.Bar_Rotation
    elseif shopType == shopCameraConfig.GUILD_MATERIAL_MACHINE then
      viewPort = CameraConfig.GuildMaterial_ViewPort
      rotation = CameraConfig.GuildMaterial_Rotation
    else
      isSpecial = false
      viewPort = CameraConfig.HappyShop_ViewPort
      rotation = CameraConfig.HappyShop_Rotation
      local uiIns = UIManagerProxy.Instance
      if uiIns:GetUIRootSize()[2] > 720 then
        viewPort = viewPort + CameraConfig.HappyShop_Ipad_ViewPortOffset
      elseif uiIns.mobileScreenAdaptionMap then
        viewPort = viewPort + CameraConfig.HappyShop_WithMobileScreenAdaption_ViewPortOffset
      end
      if npcdata.data and npcdata.data.staticData and npcdata.data.staticData.CameraShopOffset then
        LuaVector3.Better_Set(focusOffset, 0, npcdata.data.staticData.CameraShopOffset, 0)
      end
    end
    if isSpecial then
      self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, viewPort, rotation)
    else
      self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation, nil, nil, nil, focusOffset)
    end
  else
    self:CameraFocusToMe()
  end
end

function HappyShop:UpdateShopInfo(isReset)
  local datas
  if self.infoType == ShopInfoType.MyProfession then
    datas = HappyShopProxy.Instance:GetMyProfessionItems()
  elseif self.infoType == ShopInfoType.All then
    datas = HappyShopProxy.Instance:GetShopItems()
  end
  if HappyShopProxy.Instance:GetTab() then
    if datas then
      TableUtility.ArrayClear(datas)
    end
    datas = HappyShopProxy.Instance:GetTabItem(self.tabid)
  end
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local tabSystemIDConfig = config.Parama.TabSystemID
  local tabSysID = tabSystemIDConfig and self.tabid and tabSystemIDConfig[self.tabid]
  if tabSysID then
    MsgManager.ShowMsgByID(tabSysID)
  end
  if HappyShopProxy.Instance:CheckQuality() then
    if datas then
      TableUtility.ArrayClear(datas)
    end
    datas = HappyShopProxy.Instance:GetQualityItem(self.quality)
  end
  if self.searchToggle.activeSelf and self.searchInput and self.searchInput.value ~= "" then
    datas = HappyShopProxy.Instance:GetShopDataByName(self.searchInput.value, self.tabid)
  end
  if self.titleLab then
    self.titleLab.text = HappyShopProxy.Instance:IsRent() and ZhString.HappyShop_Title_Rent or ZhString.HappyShop_Title
  end
  local wrap = self:GetWrapHelper()
  if datas then
    self:NeedUpdateSold(datas)
    wrap:UpdateInfo(datas)
    HappyShopProxy.Instance:SetSelectId(nil)
  else
    printRed("HappyShop:UpdateShopInfo : datas is nil ~")
  end
  if self.noneTip then
    self.noneTip:SetActive(#datas == 0)
  end
  if isReset == true then
    wrap:ResetPosition()
  end
end

function HappyShop:GetWrapHelper()
  local isGuildMaterialType = HappyShopProxy.Instance:isGuildMaterialType()
  if isGuildMaterialType then
    return self.specialItemWrapHelper
  else
    return self.itemWrapHelper
  end
end

function HappyShop:NeedUpdateSold(datas)
  if self.needUpdateSold == true then
    return
  end
  local _HappyShopProxy = HappyShopProxy.Instance
  for i = 1, #datas do
    local id = datas[i]
    local shopdata = _HappyShopProxy:GetShopItemDataByTypeId(id)
    if shopdata and shopdata.produceNum and shopdata.produceNum > 0 then
      ServiceMatchCCmdProxy.Instance:CallOpenGlobalShopPanelCCmd(true)
      self.needUpdateSold = true
      return
    end
  end
end

function HappyShop:UpdateMoney()
  local moneyTypes = HappyShopProxy.Instance:GetMoneyType()
  if moneyTypes then
    for i = 1, #self.moneyLabel do
      local moneyType = moneyTypes[i]
      if moneyType then
        local money = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(moneyTypes[i], self.shopSource))
        self.moneyLabel[i].text = money
      else
        self.moneyLabel[i].text = ""
      end
    end
  end
end

function HappyShop:UpdateBuyItemInfo(data)
  if data then
    local itemType = data.itemtype
    if itemType and itemType ~= 2 then
      self.buyCell:SetData(data)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end

function HappyShop:ClickMyProfession()
  if self.toggleRoot then
    self.myProfessionLabel.color = ColorUtil.TitleBlue
    self.allLabel.color = ColorUtil.TitleGray
  end
  self.infoType = ShopInfoType.MyProfession
  self:UpdateShopInfo(true)
end

function HappyShop:ClickAll()
  if self.toggleRoot then
    self.myProfessionLabel.color = ColorUtil.TitleGray
    self.allLabel.color = ColorUtil.TitleBlue
  end
  self.infoType = ShopInfoType.All
  self:UpdateShopInfo(true)
end

function HappyShop:RecvBuyShopItem(note)
  local success = note.body.success
  if HappyShopProxy.Instance.aniConfig[2] and success then
    if HappyShopProxy.Instance.aniConfig[2] == "functional_action" then
      HappyShopProxy.Instance:PlayFunctionalAction()
    else
      HappyShopProxy.Instance:PlayAnimationEff()
    end
  end
  self:UpdateShopInfo()
end

function HappyShop:RecvQueryShopConfig(note)
  self:InitScreen()
  self:InitShowtoggle()
  self:ReInitShopInfo()
  self:UpdateShopInfo(true)
  self:InitLeftUpIcon()
  self:InitFilter()
  self.buyCell.gameObject:SetActive(false)
end

function HappyShop:RecvShopDataUpdate(note)
  local data = note.body
  if data then
    local _HappyShopProxy = HappyShopProxy.Instance
    if data.type == _HappyShopProxy:GetShopType() and data.shopid == _HappyShopProxy:GetShopId() then
      _HappyShopProxy:CallQueryShopConfig()
    end
  end
end

function HappyShop:RecvItemGetCount(note)
  self.buyCell:SetItemGetCount(note.data)
end

function HappyShop:SetLimitLab()
  if not HappyShopProxy.Instance:isGuildMaterialType() then
    return
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  local gmLimitCount = GuildBuildingProxy.Instance:GetGuildMaterialLimitCount()
  if myGuildData and gmLimitCount ~= 0 then
    self.limitLab.text = string.format(ZhString.HappyShop_GuildMaterialCanBuy, gmLimitCount - myGuildData.material_machine_count)
    self.limitLab.gameObject:SetActive(true)
  else
    self.limitLab.gameObject:SetActive(false)
  end
end

function HappyShop:RecvUpdateShopConfig(note)
  self:UpdateShopInfo(true)
  self.buyCell.gameObject:SetActive(false)
end

function HappyShop:HandleShopSoldCountCmd(note)
  local wrap = self:GetWrapHelper()
  local cells = wrap:GetCellCtls()
  for j = 1, #cells do
    cells[j]:RefreshBuyCondition()
  end
  if self.buyCell.gameObject.activeSelf then
    self.buyCell:UpdateSoldCountInfo()
  end
end

function HappyShop:AddCloseButtonEvent()
  HappyShop.super.AddCloseButtonEvent(self)
  self:AddOrRemoveGuideId("CloseButton", 15)
end

function HappyShop:HandleSpecial(on)
  local _HappyShopProxy = HappyShopProxy
  local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
  if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild then
    ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(on)
  end
end

function HappyShop:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function HappyShop:HideGoodsTip()
  TipManager.Instance:HideExchangeGoodsTip()
end

function HappyShop:ClickMoneyType()
  if self.tabid and self.tabid == 1 then
    self.money1Label.color = ColorUtil.TitleBlue
    self.money1sprite.color = ColorUtil.TitleBlue
    self.money2Label.color = ColorUtil.TitleGray
    self.money2sprite.color = ColorUtil.TitleGray
  elseif self.tabid and self.tabid == 2 then
    self.money1Label.color = ColorUtil.TitleGray
    self.money1sprite.color = ColorUtil.TitleGray
    self.money2Label.color = ColorUtil.TitleBlue
    self.money2sprite.color = ColorUtil.TitleBlue
  end
  self:UpdateShopInfo(true)
end

function HappyShop:ClickCustomeType()
  local currentToggle = self.tabid - self.toggleOffset
  if self.customTgSprite and self.customTgSprite[currentToggle] then
    for i = 1, 4 do
      if i == currentToggle then
        self.customTgSprite[i].color = ColorUtil.TitleBlue
      else
        self.customTgSprite[i].color = ColorUtil.TitleGray
      end
    end
  end
  self:UpdateShopInfo(true)
end

local tempVector3 = LuaVector3.Zero()
local onRotation, offRotation = Quaternion.Euler(0, 0, 90), Quaternion.Euler(0, 0, -90)

function HappyShop:InitServantList()
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local myServantid = MyselfProxy.Instance:GetMyServantID()
  local isShowList = config.Parama.ShowType
  local npcstaticid = HappyShopProxy.Instance:GetNPCStaticid()
  if isShowList and isShowList == 1 then
    self.servantExp:SetActive(true)
    local servantShopMap = HappyShopProxy.Instance:GetServantShopMap()
    local servantShopList = {}
    local defaultdata
    local flag = false
    if servantShopMap then
      for k, v in pairs(servantShopMap) do
        local single = v
        if FunctionUnLockFunc.Me():CheckCanOpen(v.menuid) then
          table.insert(servantShopList, single)
        end
        if not flag then
          if not self.lastSelect then
            if myServantid == 0 and v.type == self.default then
              defaultdata = single
              flag = true
            elseif npcstaticid ~= 0 and npcstaticid == v.npcid then
              defaultdata = single
              flag = true
            elseif npcstaticid == 0 and myServantid == v.npcid then
              defaultdata = single
              flag = true
            end
          elseif v.npcid == self.lastSelect then
            defaultdata = single
            flag = true
          end
        end
      end
      table.sort(servantShopList, function(a, b)
        return a.npcid > b.npcid
      end)
    end
    local delta = 0
    if self.expandToggle then
      self.servantCtl:ResetDatas({defaultdata}, true)
      self.servantbg.width = originWidth
      LuaVector3.Better_Set(tempVector3, 3, originposY, 0)
      self.servantBtn.gameObject.transform.localPosition = tempVector3
      self.servantSp.transform.localRotation = offRotation
      self.servantSC.panel.baseClipRegion = Vector4(0, 184, 64.8, 64)
      self.descBg:SetActive(not FunctionUnLockFunc.Me():CheckCanOpen(defaultdata.menuid2))
    else
      delta = (#servantShopList < 6 and #servantShopList or 5.7) - 1
      self.servantCtl:ResetDatas(servantShopList, true)
      self.servantbg.width = originWidth + delta * 62
      LuaVector3.Better_Set(tempVector3, 3, originposY - delta * 62, 0)
      self.servantBtn.gameObject.transform.localPosition = tempVector3
      self.servantSp.transform.localRotation = onRotation
      self.servantSC.panel.baseClipRegion = Vector4(0, 184 - delta * 31, 64.8, 64 + delta * 62)
    end
    self.servantSC:ResetPosition()
  else
    self.servantExp:SetActive(false)
  end
end

function HappyShop:ClickServantHead(cell)
  local data = cell.data
  if data then
    self.lastSelect = data.npcid
    HappyShopProxy.Instance:InitShop(nil, data.param, data.type)
    self:InitLeftUpIcon()
    self:UpdateShopInfo(true)
    self:UpdateMoney()
    local canopen = FunctionUnLockFunc.Me():CheckCanOpen(data.menuid2)
    if canopen then
      self.descBg:SetActive(false)
    else
      self.descBg:SetActive(true)
      self.descLab.text = HappyShopProxy.Instance.desc
    end
    local cells = self.servantCtl:GetCells()
    for _, v in pairs(cells) do
      v:SetChoose(data.npcid == v.data.npcid)
    end
  end
end

local atlas_UI5

function HappyShop:SetTabCustomIcon(sp, spName)
  if Slua.IsNull(atlas_UI5) then
    atlas_UI5 = RO.AtlasMap.GetAtlas("NewUI5")
  end
  if atlas_UI5:GetSprite(spName) then
    sp.spriteName = spName
  else
    IconManager:SetUIIcon(spName, sp)
  end
end

function HappyShop:InitCustomToggle()
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local TabCustomIcon = config.Parama.TabCustomIcon
  if not TabCustomIcon then
    self.customToggleRoot:SetActive(false)
    return
  end
  self.showtoggle:SetActive(false)
  self.customToggleRoot:SetActive(true)
  self.customToggle[1].value = true
  local toggleShowNum = 2
  if 4 < #TabCustomIcon then
    toggleShowNum = 4
  else
    toggleShowNum = #TabCustomIcon
  end
  for i = 1, 4 do
    if i <= toggleShowNum then
      self:Show(self:FindGO("custom" .. i, self.customToggleRoot))
      self:SetTabCustomIcon(self.customTgSprite[i], TabCustomIcon[i])
      self.customTgSprite[i]:MakePixelPerfect()
    else
      self:Hide(self:FindGO("custom" .. i, self.customToggleRoot))
    end
  end
  self.customTgSprite[1].color = ColorUtil.TitleBlue
  self.customTgSprite[2].color = ColorUtil.TitleGray
  self.customTgSprite[3].color = ColorUtil.TitleGray
  self.customTgSprite[4].color = ColorUtil.TitleGray
  self:RefreshIndicator()
end

function HappyShop:InitSearchToggle()
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local searchOn = config.Parama.Search
  if searchOn and searchOn == 1 then
    self.searchToggle:SetActive(true)
  else
    self.searchToggle:SetActive(false)
  end
end

function HappyShop:OnSearchSubmit()
  local shopDatas = HappyShopProxy.Instance:GetShopDataByName(self.searchInput.value, self.tabid)
  local wrap = self:GetWrapHelper()
  if shopDatas then
    self:NeedUpdateSold(shopDatas)
    wrap:UpdateInfo(shopDatas)
    HappyShopProxy.Instance:SetSelectId(nil)
  else
    printRed("HappyShop:UpdateShopInfo : shopDatas is nil ~")
  end
  if self.noneTip then
    self.noneTip:SetActive(#shopDatas == 0)
  end
  wrap:ResetPosition()
end

function HappyShop:RefreshIndicator()
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local TabCustomIcon = config.Parama.TabCustomIcon
  if not TabCustomIcon then
    self.customToggleRoot:SetActive(false)
    return
  end
  if self.toggleOffset and self.toggleOffset == 0 then
    self:Hide(self.leftIndicator)
  else
    self:Show(self.leftIndicator)
  end
  if 4 < #TabCustomIcon then
    if #TabCustomIcon - self.toggleOffset > 4 then
      self:Show(self.rightIndicator)
    else
      self:Hide(self.rightIndicator)
    end
  else
    self:Hide(self.rightIndicator)
  end
end

function HappyShop:ClickIndicator()
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local TabCustomIcon = config.Parama.TabCustomIcon
  if not TabCustomIcon then
    self.customToggleRoot:SetActive(false)
    return
  end
  local switchPage = false
  if self.tabid < 1 + self.toggleOffset then
    self.tabid = 1 + self.toggleOffset
    switchPage = true
  elseif self.tabid > 4 + self.toggleOffset then
    self.tabid = 4 + self.toggleOffset
    switchPage = true
  end
  local currentToggle = self.tabid - self.toggleOffset
  if self.customTgSprite[currentToggle] and self.customToggle[currentToggle] then
    for i = 1, 4 do
      if i == currentToggle then
        self.customTgSprite[i].color = ColorUtil.TitleBlue
        self.customToggle[i].value = true
      else
        self.customTgSprite[i].color = ColorUtil.TitleGray
        self.customToggle[i].value = false
      end
      if TabCustomIcon[i + self.toggleOffset] then
        self.customTgSprite[i].spriteName = TabCustomIcon[i + self.toggleOffset]
        self.customTgSprite[i]:MakePixelPerfect()
      end
    end
  end
  if switchPage then
    self:UpdateShopInfo(true)
  end
end

local itemClickUrlTipData = {}

function HappyShop:OnClickItemUrl(id)
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

function HappyShop:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddIgnoreBounds(self.buyCell.gameObject)
    self.CloseWhenClickOtherPlace:AddTarget(tip.gameObject.transform)
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function HappyShop:OnTipFashionPreviewShow(preview)
  self.CloseWhenClickOtherPlace:AddTarget(preview.gameObject.transform)
end

function HappyShop:OnTipFashionPreviewClose()
  self.CloseWhenClickOtherPlace:ReCalculateBound()
end

function HappyShop:OverseaAndroidBack()
  if self.buyCell.gameObject.activeSelf then
    self.buyCell.gameObject:SetActive(false)
  else
    self:CloseSelf()
  end
end

local QualityFilter = GameConfig.Shop.QualityFilter

function HappyShop:InitFilter()
  self.qualityFilterPanel = self:FindGO("QualityFilterPanel")
  if not self.qualityFilterPanel then
    return
  end
  if not HappyShopProxy.Instance:CheckQuality() then
    self.qualityFilterPanel:SetActive(false)
    return
  end
  self.qualityFilterPanel:SetActive(true)
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.quality ~= self.filter.data or self.quality == 0 then
      self.quality = self.filter.data
      self:UpdateChooseQuality()
    end
  end)
  self.filter:Clear()
  local rangeList = HappyShopProxy.Instance:GetFilter(QualityFilter)
  for i = 1, #rangeList do
    local rangeData = QualityFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.quality = range
    local rangeData = QualityFilter[range]
    self.filter.value = rangeData
  end
  self.quality = 0
end

function HappyShop:UpdateChooseQuality()
  self:UpdateShopInfo(true)
end

function HappyShop:CloseSelf()
  if self.searchInput then
    self.searchInput.value = ""
  end
  HappyShop.super.CloseSelf(self)
end
