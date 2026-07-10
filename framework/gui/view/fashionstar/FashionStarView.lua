FashionStarView = class("FashionStarView", ContainerView)
FashionStarView.ViewType = UIViewType.NormalLayer
autoImport("FashionStarTabCell")
autoImport("FashionStarModel")
autoImport("MaterialItemCell")
autoImport("FashionStarVideo")
FashionStarView.TabDisplayConfig = {
  [PanelConfig.FashionStarPage1.tab] = {showModel = true, showSwitchBtn = false},
  [PanelConfig.FashionStarPage2.tab] = {showModel = true, showSwitchBtn = false},
  [PanelConfig.FashionStarPage3.tab] = {showModel = false, showSwitchBtn = true},
  [PanelConfig.FashionStarPage4.tab] = {showModel = true, showSwitchBtn = false},
  [PanelConfig.FashionStarPage5.tab] = {showModel = true, showSwitchBtn = false},
  [PanelConfig.FashionStarPage6.tab] = {showModel = true, showSwitchBtn = false},
  [PanelConfig.FashionStarPage7.tab] = {showModel = true, showSwitchBtn = false}
}

function FashionStarView:InitConfig()
  self.batchid = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.batchid or 1
  FashionStarProxy.Instance:SetCurrentBatchId(self.batchid)
  self.initialItemData = FashionStarProxy.Instance:GetInitialItemData()
  self.fashionItemData = FashionStarProxy.Instance:GetInitialFashionItemData()
  self.depositItemData = FashionStarProxy.Instance:GetInitialDepositItemData()
  self.maxStarFashionItemData = FashionStarProxy.Instance:GetMaxStarFashionItemData()
  self.maxStarConfigId = FashionStarProxy.Instance:GetMaxStarConfigId()
  self.configIds = FashionStarProxy.Instance:GetCurrentConfigIds()
  self:UpdateUnlockedStar()
end

function FashionStarView:UpdateUnlockedStar()
  self.unlockedStar = FashionStarProxy.Instance:GetUnlockedStar(self.batchid) or 1
end

function FashionStarView:Init()
  ServiceItemProxy.Instance:CallFashionStarQueryItemCmd()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  self:InitConfig()
  self:InitUI()
  self:MapListenEvt()
  local initialTab = math.min(self.unlockedStar + 1, #self.configIds)
  self:TabChangeHandler(initialTab)
end

function FashionStarView:InitUI()
  self.helpBtn = self:FindGO("HelpButton")
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.titleLabel.text = ZhString.UpgradeAppearance_Title
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.modelView = self:AddSubView("FashionStarModel", FashionStarModel)
  self.panelConfigs = {}
  self.pageBords = {}
  for i = 1, #self.configIds do
    self.panelConfigs[self.configIds[i]] = PanelConfig["FashionStarPage" .. i]
    self.pageBords[i] = self:FindGO("PageBord" .. i)
    local pageName = "FashionStarPage" .. i
    autoImport(pageName)
    self:AddSubView(i, _G[pageName], self.pageBords[i])
  end
  local togglesTable = self:FindComponent("Toggles", UITable)
  self.tabCtl = UIGridListCtrl.new(togglesTable, FashionStarTabCell, "FashionStarTabCell")
  self.tabCtl:AddEventListener(MouseEvent.MouseClick, self.OnTabCellClick, self)
  self.tabCtl:ResetDatas(self.configIds)
  self.togCells = self.tabCtl:GetCells()
  for k, cell in pairs(self.togCells) do
    local page = self.pageBords[cell.data]
    local config = self.panelConfigs[cell.data]
    if page and config then
      self:AddTabChangeEvent(cell.gameObject, page, config)
    end
  end
  self.currentTabLevelLab = self:FindComponent("CurrentTabLevelLab", UILabel)
  self.fashionNameLab = self:FindComponent("FashionNameLab", UILabel)
  self.buttomTipLab = self:FindComponent("ButtomTipLab", UILabel)
  self.fashionItemGrid = self:FindComponent("FashionItemGrid", UIGrid)
  self.fashionItemListCtrl = UIGridListCtrl.new(self.fashionItemGrid, MaterialItemCell, "MaterialItemCell")
  self.fashionItemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItemCell, self)
  self.fashionItemListCtrl:ResetDatas({
    self.fashionItemData
  })
  self.centerFashionItemGrid = self:FindComponent("CenterFashionItemGrid", UIGrid)
  self.centerFashionItemListCtrl = UIGridListCtrl.new(self.centerFashionItemGrid, MaterialItemCell, "MaterialItemCell")
  self.centerFashionItemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItemCell, self)
  self.nextLevelRoot = self:FindGO("NextLevelRoot")
  self.nextLevelLab = self:FindComponent("NextUnlockLevelLab", UILabel, self.nextLevelRoot)
  self.nextLevelItemGrid = self:FindComponent("NextUnlockLevelItemGrid", UIGrid, self.nextLevelRoot)
  self.nextLevelItemListCtrl = UIGridListCtrl.new(self.nextLevelItemGrid, MaterialItemCell, "MaterialItemCell")
  self.nextLevelItemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItemCell, self)
  self.costRoot = self:FindGO("CostRoot")
  self.fixedCostLab = self:FindComponent("FixedCostLab", UILabel, self.costRoot)
  self.fixedCostLab.text = ZhString.UpgradeAppearance_FixedCost
  self.costItemList = self:FindComponent("CostGrid", UIGrid, self.costRoot)
  self.costItemListCtrl = UIGridListCtrl.new(self.costItemList, MaterialItemCell, "MaterialItemCell")
  self.costItemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItemCell, self)
  self.btnGrid = self:FindGO("BtnGrid"):GetComponent(UIGrid)
  self.btn_1 = self:FindComponent("Btn_1", UISprite, self.btnGrid.gameObject)
  self.btn_2 = self:FindComponent("Btn_2", UISprite, self.btnGrid.gameObject)
  self:AddClickEvent(self.btn_1.gameObject, function()
    self:OnBtnClick(1)
  end)
  self:AddClickEvent(self.btn_2.gameObject, function()
    self:OnBtnClick(2)
  end)
  self.btnLab_1 = self:FindComponent("Label", UILabel, self.btn_1.gameObject)
  self.btnLab_2 = self:FindComponent("Label", UILabel, self.btn_2.gameObject)
  self.btnTipLab_1 = self:FindComponent("TipLabel", UILabel, self.btn_1.gameObject)
  self.btnTipLab_2 = self:FindComponent("TipLabel", UILabel, self.btn_2.gameObject)
  self.btnTipLab_1.gameObject:SetActive(false)
  self.btnTipLab_2.gameObject:SetActive(false)
  self:UpdateTabStates()
  self.switchRoot = self:FindGO("SwitchRoot")
  self.preSwitchBtn = self:FindGO("PreBtn", self.switchRoot)
  self:AddClickEvent(self.preSwitchBtn, function()
    self:OnClickSwitch(true)
  end)
  self.nextSwitchBtn = self:FindGO("NextBtn", self.switchRoot)
  self:AddClickEvent(self.nextSwitchBtn, function()
    self:OnClickSwitch(false)
  end)
  self:Hide(self.switchRoot)
end

local tipOffset = {-210, 180}

function FashionStarView:OnClickItemCell(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  FashionStarView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end

function FashionStarView:OnClickSwitch(isPre)
  if self.currentSubView and self.currentSubView.OnClickSwitch then
    self.currentSubView:OnClickSwitch(isPre)
  end
end

function FashionStarView:OnTabCellClick(cell)
  local config = self.panelConfigs[cell.data]
  if config and config.tab then
    self:TabChangeHandler(config.tab)
  end
  return true
end

function FashionStarView:UpdateTabStates()
  for i, cell in ipairs(self.togCells) do
    if cell then
      cell:UpdateLockState()
    end
  end
end

function FashionStarView:TabChangeHandler(key)
  if self.currentKey == key then
    return
  end
  local ret = FashionStarView.super.TabChangeHandler(self, key)
  if ret then
    self.currentKey = key
    if self.currentSubView then
      self.currentSubView:OnHide()
    end
    self.currentSubView = self.viewMap[key]
    self.currentConfigId = self.configIds[key]
    self.currentStaticData = Table_FashionStar[self.currentConfigId]
    FashionStarProxy.Instance:SetCurrentConfigId(self.currentConfigId)
    self:UpdateTabCellSelection(key)
    self:OnTabChanged(key)
    self:UpdateRightUI()
    self.currentSubView:OnShow()
  end
  return ret
end

function FashionStarView:UpdateTabCellSelection(selectedTab)
  for _, cell in ipairs(self.togCells) do
    if cell then
      local config = self.panelConfigs[cell.data]
      if config and config.tab then
        cell:SetSelected(config.tab == selectedTab)
      end
    end
  end
end

function FashionStarView:OpenVideo(video_path)
  if video_path then
    if not self.videoView then
      self.videoView = self:AddSubView("FashionStarVideo", FashionStarVideo)
    end
    self.videoView:ShowVideo(video_path)
  elseif self.videoView then
    self.videoView:HideVideo()
  end
end

function FashionStarView:HideVideo()
  if self.videoView then
    self.videoView:HideVideo()
  end
end

function FashionStarView:ShowSwitchBtn(show)
  if show then
    self:Show(self.switchRoot)
  else
    self:Hide(self.switchRoot)
  end
end

function FashionStarView:OnTabChanged(key)
  local cfg = FashionStarView.TabDisplayConfig[key]
  if cfg then
    self.modelView:ShowModel(cfg.showModel)
    local video = self.currentStaticData and self.currentStaticData.Param and self.currentStaticData.Param.Video
    if type(video) == "table" then
      local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
      video = video[gender][1]
    end
    self.hasVideo = not StringUtil.IsEmpty(video)
    self:OpenVideo(video)
    self:ShowSwitchBtn(cfg.showSwitchBtn)
  end
end

function FashionStarView:ChangeBodyPart(equip_id, head_id)
  self.modelView:ChangeBodyPart(equip_id, head_id)
end

function FashionStarView:Revert2DefaultModel()
  local defaultFashionId, defaultHeadId = FashionStarProxy.Instance:GetDefaultFashionId(), FashionStarProxy.Instance:GetDefaultHeadId()
  self:ChangeBodyPart(defaultFashionId, defaultHeadId)
end

function FashionStarView:PlayAction(action_id)
  self.modelView:PlayAction(action_id)
end

function FashionStarView:UpdateDescription(str)
  self.buttomTipLab.text = str
end

function FashionStarView:CheckDepositSoldOut(deposit_id)
  if not deposit_id then
    return false
  end
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(deposit_id)
  if not info then
    return false
  end
  local purchasedTimes = info.purchaseTimes or 0
  local purchaseLimitTimes = info.purchaseLimit_N or 0
  if 9999 <= purchaseLimitTimes or purchaseLimitTimes <= 0 then
    return false
  end
  return purchasedTimes >= purchaseLimitTimes
end

function FashionStarView:CheckDepositPurchased(deposit_id)
  if not deposit_id then
    return false
  end
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(deposit_id)
  if not info then
    return false
  end
  local purchasedTimes = info.purchaseTimes or 0
  local purchaseLimitTimes = info.purchaseLimit_N or 0
  if 9999 <= purchaseLimitTimes or purchaseLimitTimes <= 0 then
    return false
  end
  return purchasedTimes >= purchaseLimitTimes
end

function FashionStarView:SetupDoubleButtons(deposit_ids)
  self.isDoubleButtonMode = true
  self.currentDepositIds = deposit_ids
  self.btn_1.gameObject:SetActive(true)
  self.btn_2.gameObject:SetActive(true)
  for i = 1, 2 do
    local depositId = deposit_ids[i]
    local btn = i == 1 and self.btn_1 or self.btn_2
    local btnLab = i == 1 and self.btnLab_1 or self.btnLab_2
    local priceStr = self:GetPriceStringByDepositId(depositId)
    btnLab.text = priceStr
    local isPurchased = self:CheckDepositPurchased(depositId)
    if isPurchased then
      UIUtil.TempSetButtonStyle(0, btn.gameObject, btn, btnLab)
    else
      UIUtil.TempSetButtonStyle(4, btn.gameObject, btn, btnLab)
    end
  end
  self:UpdateDepositButtonTip(self.btnTipLab_1, deposit_ids[1])
  self:UpdateDepositButtonTip(self.btnTipLab_2, deposit_ids[2])
  self.btnGrid:Reposition()
  self.centerFashionItemGrid.transform.localPosition = LuaGeometry.GetTempVector3(0, -35, 0)
end

function FashionStarView:OnBtnClick(btn_index)
  btn_index = btn_index or 1
  if self.currentKey == 1 then
    self:OnClickPurchase(btn_index)
    return
  end
  local canUpgrade, msgID = FashionStarProxy.Instance:CanUpgradeStar(self.currentKey)
  if not canUpgrade then
    if msgID then
      MsgManager.ShowMsgByID(msgID)
    end
    return
  end
  ServiceItemProxy.Instance:CallFashionStarUpItemCmd(self.batchid)
end

function FashionStarView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.ItemFashionStarQueryItemCmd, self.HandleServerUpdate)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.OnChargeCntUpdate)
end

function FashionStarView:HandleServerUpdate()
  self:UpdateTabStates()
  self:UpdateUnlockedStar()
  self:TabChangeHandler(self.unlockedStar)
  self:UpdateRightUI()
end

function FashionStarView:OnEnter()
  FashionStarView.super.OnEnter(self)
  self:UpdateTabStates()
end

function FashionStarView:HandleClose()
  self:CloseSelf()
end

function FashionStarView:UpdateRightUI()
  local staticData = self.currentStaticData
  if not staticData then
    return
  end
  local currentStar = staticData.Star
  local isCurrentUnlocked = FashionStarProxy.Instance:IsUnlocked(self.currentConfigId)
  local isMaxStar = self.currentConfigId == self.maxStarConfigId
  self.fashionName = isMaxStar and self.maxStarFashionItemData.NameZh or self.fashionItemData.staticData.NameZh
  self.fashionNameLab.text = self.fashionName
  self.currentTabLevelLab.text = tostring(currentStar)
  local buttomTip
  if self.currentKey == PanelConfig.FashionStarPage3.tab then
    buttomTip = string.format(ZhString.UpgradeAppearance_ButtomTip_Page3_1, self.fashionName)
  else
    buttomTip = string.format(ZhString["UpgradeAppearance_ButtomTip_Page" .. self.currentKey], self.fashionName)
  end
  self:UpdateDescription(buttomTip)
  if isMaxStar then
    self:Hide(self.fashionItemGrid)
    self:Show(self.centerFashionItemGrid)
    if self.maxStarFashionItemData then
      self.centerFashionItemListCtrl:ResetDatas({
        self.maxStarFashionItemData
      })
    end
    self:SetupSingleButton()
  elseif self.currentKey == 1 then
    self:Hide(self.fashionItemGrid)
    self:Show(self.centerFashionItemGrid)
    local mainDepositId = staticData.Deposit
    local isMainSoldOut = self:CheckDepositSoldOut(mainDepositId)
    if isMainSoldOut then
      local extraDepositIds = FashionStarProxy.Instance:GetExtraDepositIds(self.currentConfigId)
      extraDepositIds = self:FilterVisibleDepositIds(extraDepositIds)
      local depositItemDatas = self:CreateDepositItemDatas(extraDepositIds)
      xdlog("商店内容", extraDepositIds and #extraDepositIds)
      if depositItemDatas and 2 <= #depositItemDatas then
        local displayDepositIds = {
          extraDepositIds[1],
          extraDepositIds[2]
        }
        self:SetupDoubleButtons(displayDepositIds)
        self.centerFashionItemListCtrl:ResetDatas(depositItemDatas)
      elseif depositItemDatas and #depositItemDatas == 1 then
        self.centerFashionItemListCtrl:ResetDatas(depositItemDatas)
        self:SetupSingleButton(extraDepositIds[1])
      else
        if self.depositItemData then
          self.centerFashionItemListCtrl:ResetDatas({
            self.depositItemData
          })
        end
        self:SetupSingleButton(mainDepositId)
      end
    else
      if self.depositItemData then
        self.centerFashionItemListCtrl:ResetDatas({
          self.depositItemData
        })
      end
      self:SetupSingleButton(mainDepositId)
    end
  else
    self:Hide(self.fashionItemGrid)
    self:Hide(self.centerFashionItemGrid)
    local clientItemId = staticData.Param and staticData.Param.ClientItemId
    local itemData
    if clientItemId and 0 < clientItemId then
      itemData = ItemData.new(MaterialItemCell.MaterialType.Material, clientItemId)
    end
    if itemData then
      self.fashionItemListCtrl:ResetDatas({itemData})
    end
    self:SetupSingleButton()
  end
  local nextAppearanceId = self.currentConfigId + 1
  local nextStaticData = Table_FashionStar[nextAppearanceId]
  if not nextStaticData or not isCurrentUnlocked and self.currentKey == 1 then
    self:Hide(self.nextLevelRoot)
  else
    self.nextLevelLab.text = string.format(ZhString.UpgradeAppearance_UnlockTip, currentStar)
    local nextItemDatas = {}
    local nextItems = staticData.Param and staticData.Param.NextStarItem
    if nextItems and 0 < #nextItems then
      for i = 1, #nextItems do
        nextItemDatas[#nextItemDatas + 1] = ItemData.new(MaterialItemCell.MaterialType.Material, nextItems[i])
      end
      self:Show(self.nextLevelRoot)
      if self.hasVideo then
        self.nextLevelRoot.transform.localPosition = LuaGeometry.GetTempVector3(-5, 0, 0)
      else
        self.nextLevelRoot.transform.localPosition = LuaGeometry.GetTempVector3(-5, 50, 0)
      end
      self.nextLevelItemListCtrl:ResetDatas(nextItemDatas)
    else
      self:Hide(self.nextLevelRoot)
    end
  end
  local costs = staticData.ItemCost
  if not isCurrentUnlocked and costs and 0 < #costs then
    self:Show(self.costRoot)
    local costItemDatas = {}
    local itemData
    for i = 1, #costs do
      itemData = ItemData.new(MaterialItemCell.MaterialType.Material, costs[i][1])
      itemData.num = BagProxy.Instance:GetItemNumByStaticID(costs[i][1], GameConfig.PackageMaterialCheck.fashion_star)
      itemData.neednum = costs[i][2]
      costItemDatas[#costItemDatas + 1] = itemData
    end
    self.costItemListCtrl:ResetDatas(costItemDatas)
  else
    self:Hide(self.costRoot)
  end
  if not self.isDoubleButtonMode then
    local depositId = self.currentKey == 1 and self:GetCurrentPurchaseDepositId(1) or nil
    if self.currentKey == 1 and depositId then
      self.btnLab_1.text = depositId and self:GetPriceStringByDepositId(depositId) or ZhString.UpgradeAppearance_Btn
      local style = self:CheckDepositPurchased(depositId) and 0 or 4
      UIUtil.TempSetButtonStyle(style, self.btn_1.gameObject, self.btn_1, self.btnLab_1)
    elseif isCurrentUnlocked then
      self.btnLab_1.text = nil == nextStaticData and ZhString.UpgradeAppearance_Btn_Max or ZhString.UpgradeAppearance_Btn_Unlock
      UIUtil.TempSetButtonStyle(0, self.btn_1.gameObject, self.btn_1, self.btnLab_1)
    else
      self.btnLab_1.text = ZhString.UpgradeAppearance_Btn
      local style = FashionStarProxy.Instance:CheckCurrentStarCanUpgrade(self.batchid, self.currentKey) and 4 or 0
      UIUtil.TempSetButtonStyle(style, self.btn_1.gameObject, self.btn_1, self.btnLab_1)
    end
  end
end

function FashionStarView:CreateDepositItemDatas(deposit_ids)
  if not deposit_ids or #deposit_ids <= 0 then
    return nil
  end
  local depositItemDatas = {}
  local maxCount = math.min(#deposit_ids, 2)
  for i = 1, maxCount do
    local depositId = deposit_ids[i]
    if depositId then
      local depositConfig = Table_Deposit[depositId]
      if depositConfig and depositConfig.ItemId then
        local itemData = ItemData.new(MaterialItemCell.MaterialType.Material, depositConfig.ItemId)
        if itemData and itemData.staticData then
          itemData.num = 0
          itemData.neednum = 0
          depositItemDatas[#depositItemDatas + 1] = itemData
        end
      end
    end
  end
  return depositItemDatas
end

function FashionStarView:FilterVisibleDepositIds(deposit_ids)
  if not deposit_ids or #deposit_ids <= 0 then
    return deposit_ids
  end
  local visibleIds = {}
  for i = 1, #deposit_ids do
    local depositId = deposit_ids[i]
    local isTimeLimitGift = FashionStarProxy.Instance:GetGiftInfoByDepositId(self.batchid, depositId) ~= nil
    if not isTimeLimitGift or not self:CheckDepositPurchased(depositId) then
      visibleIds[#visibleIds + 1] = depositId
    end
  end
  return next(visibleIds) and visibleIds or nil
end

function FashionStarView:SetupSingleButton(deposit_id)
  self.isDoubleButtonMode = false
  self.currentDepositIds = deposit_id and {deposit_id} or nil
  self.btn_1.gameObject:SetActive(true)
  self.btn_2.gameObject:SetActive(false)
  self:UpdateDepositButtonTip(self.btnTipLab_1, deposit_id)
  self:UpdateDepositButtonTip(self.btnTipLab_2)
  self.btnGrid:Reposition()
  local y_axis = self.currentKey == 7 and -35 or 9
  self.centerFashionItemGrid.transform.localPosition = LuaGeometry.GetTempVector3(0, y_axis, 0)
end

function FashionStarView:GetDepositRemainTimeText(deposit_id)
  if not deposit_id then
    return nil
  end
  local endTime = FashionStarProxy.Instance:GetDepositEndTime(self.batchid, deposit_id)
  if not endTime or endTime <= 0 then
    return nil
  end
  local curServerTime = math.floor((ServerTime.CurServerTime() or 0) / 1000)
  if endTime <= curServerTime then
    return nil
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(endTime)
  if 0 < leftDay then
    return string.format(ZhString.NoviceBattlePassRemainTime, leftDay, leftHour)
  elseif 0 < leftHour then
    return string.format(ZhString.NoviceBattlePassRemainTimeHourMin, leftHour, leftMin)
  elseif 0 < leftMin or 0 < leftSec then
    return string.format(ZhString.NoviceBattlePassRemainTimeMin, leftMin)
  end
  return nil
end

function FashionStarView:UpdateDepositButtonTip(label, deposit_id)
  if not label then
    return
  end
  local tipText = self:GetDepositRemainTimeText(deposit_id)
  local show = tipText ~= nil and tipText ~= ""
  label.gameObject:SetActive(show)
  if show then
    label.text = tipText
  end
end

function FashionStarView:GetPriceStringByDepositId(deposit_id)
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(deposit_id)
  local productConf = info and info.productConf
  if productConf and productConf.priceStr then
    return productConf.priceStr
  end
  local depositConfig = Table_Deposit[deposit_id]
  if not depositConfig or not depositConfig.Rmb then
    return ""
  end
  if depositConfig.priceStr then
    return depositConfig.priceStr
  end
  return depositConfig.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(depositConfig.Rmb)
end

function FashionStarView:GetCurrentPurchaseDepositId(btn_index)
  btn_index = btn_index or 1
  if self.currentDepositIds and self.currentDepositIds[btn_index] then
    return self.currentDepositIds[btn_index]
  end
  local currentConfigId = FashionStarProxy.Instance:GetCurrentConfigId()
  local staticData = Table_FashionStar[currentConfigId]
  return staticData and staticData.Deposit
end

function FashionStarView:Invoke_DepositConfirmPanel(info, cb)
  local productConf = info and info.productConf
  local productID = productConf and productConf.ProductID
  if not productID then
    if cb then
      cb()
    end
    return
  end
  local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
  local productPrice = productConf.Rmb
  local productCount = productConf.Count
  local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[productConf.id].Desc)
  local productD = " [0075BCFF]" .. productDesc .. "[-] "
  if not BranchMgr.IsKorea() and not BranchMgr.IsNOKR() then
    local zenyAdditionCount = info.GetFreeBonusCount and info:GetFreeBonusCount() or 0
    if 0 < zenyAdditionCount then
      productCount = tostring(productCount + zenyAdditionCount)
    end
    productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
  end
  local currencyType = productConf.CurrencyType
  local confirmDesc, clickUrlCallback = OverseaHostHelper:GetRechargeShopConfirmDesc()
  OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), confirmDesc, productName, productPrice, function()
    if cb then
      cb()
    end
  end, nil, clickUrlCallback)
end

function FashionStarView:PurchaseDeposit(info)
  local productConf = info and info.productConf
  if not productConf then
    return
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
      local strResult = str_result or "nil"
      helplog("FashionStarView:OnPaySuccess, ", strResult)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      helplog("FashionStarView:OnPayFail, ", strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      helplog("FashionStarView:OnPayTimeout, ", strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      helplog("FashionStarView:OnPayCancel, ", strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      helplog("FashionStarView:OnPayProductIllegal, ", strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      helplog("FashionStarView:OnPayPaying, ", strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function FashionStarView:OnClickPurchase(btn_index)
  btn_index = btn_index or 1
  local depositId = self:GetCurrentPurchaseDepositId(btn_index)
  if not depositId then
    return
  end
  if self:CheckDepositPurchased(depositId) then
    MsgManager.ShowMsgByID(49)
    return
  end
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositId)
  if not info or not info.productConf then
    return
  end
  local cbfunc = function()
    self:PurchaseDeposit(info)
  end
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() or BranchMgr.IsNOKR() then
    self:Invoke_DepositConfirmPanel(info, cbfunc)
    return true
  end
  return self:PurchaseDeposit(info)
end

function FashionStarView:OnChargeCntUpdate()
  self:UpdateRightUI()
end
