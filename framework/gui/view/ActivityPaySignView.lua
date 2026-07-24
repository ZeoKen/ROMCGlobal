autoImport("ActivityPaySignImportantRewardCell")
autoImport("NewRechargeVirtualRecommendTShopGoodsCell")
autoImport("SpriteLabel")
ActivityPaySignView = class("ActivityPaySignView", SubMediatorView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityPaySignView")
local Prefab_Path_NoSuper = ResourcePathHelper.UIView("ActivityPaySignView2")
local LabelEnabledEffectColor = Color(0.7686274509803922, 0.5254901960784314, 0, 1)
local ADV_UPGRADE = 1
local SUPER_UPGRADE = 2
local UPGRADE_SHOWS = {ADV_UPGRADE, SUPER_UPGRADE}

function ActivityPaySignView:Init()
  self.activityId = self.subViewData and self.subViewData.ActivityId
  self.hasSuperReward = ActivityPaySignProxy.Instance:HasAnySuperReward(self.activityId)
  redlog("ActivityPaySignView activityId", tostring(self.activityId))
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvents()
  self:InitVirtualCells()
end

function ActivityPaySignView:LoadPrefab()
  local prefabPath = self.hasSuperReward and Prefab_Path or Prefab_Path_NoSuper
  local obj = self:LoadPreferb_ByFullPath(prefabPath, self.container, true)
  obj.name = "ActivityPaySignView"
  self.gameObject = obj
end

function ActivityPaySignView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function ActivityPaySignView:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.bannerTex = self:FindComponent("Banner", UITexture)
  local descGO = self:FindGO("Desc")
  self.descLabel = SpriteLabel.new(descGO, nil, nil, nil, true)
  self.helpBTN = self:FindGO("helpBtn")
  self:RegistShowGeneralHelpByHelpID(32644, self.helpBTN)
  self.rewardScrollView = self:FindComponent("LevelRewardScrollview", UIScrollView)
  
  function self.rewardScrollView.onDragStarted()
    self:OnScrollStart()
  end
  
  function self.rewardScrollView.onStoppedMoving()
    self:OnScrollStop()
  end
  
  local cellName = self.hasSuperReward and "ActivityPaySignLevelRewardCell" or "ActivityPaySignLevelRewardCell2"
  local className = ActivityPaySignRewardCell
  local wrapCfg = {
    wrapObj = self:FindGO("LevelRewardGrid"),
    pfbNum = 7,
    cellName = cellName,
    control = className,
    dir = 2,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.levelRewardHolder = self:FindGO("bigLevelRewardHolder")
  local nextLevelCellName = self.hasSuperReward and "ActivityPaySignNextLevelRewardCell" or "ActivityPaySignNextLevelRewardCell2"
  local nextLevelCellClass = ActivityPaySignImportantRewardCell
  local go = self:LoadCellPfb(nextLevelCellName, self.levelRewardHolder)
  self.nextLevelRewardCell = nextLevelCellClass.new(go)
  local box = go:GetComponent(BoxCollider)
  if box then
    box.enabled = false
  end
  self.upgradeBtn = self:FindGO("upgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.upgradeBtnLabel = self:FindComponent("upgradeText", UILabel, self.upgradeBtn)
  self.upgradeIcon = self:FindComponent("upgradeIcon", UISprite, self.upgradeBtn)
  self.receiveAllBtn = self:FindGO("onekeyBtn")
  self:AddClickEvent(self.receiveAllBtn, function()
    self:OnReceiveAllBtnClick()
  end)
  self.rewardBg = self:FindComponent("BG", UISprite)
end

function ActivityPaySignView:AddEvents()
  self:AddListenEvt(ServiceEvent.ActivityCmdPaySignSyncActCmd, self.HandlePaySignSyncActCmd)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.HandleShopUpdate)
end

function ActivityPaySignView:InitVirtualCells()
  if self.virtualCells then
    return
  end
  self.virtualCells = {}
  for i = 1, #UPGRADE_SHOWS do
    local cell = NewRechargeVirtualRecommendTShopGoodsCell.new()
    cell:Init()
    cell:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShopItemPurchase, self)
    self.virtualCells[UPGRADE_SHOWS[i]] = cell
  end
end

function ActivityPaySignView:DestroyVirtualCells()
  if not self.virtualCells then
    return
  end
  for _, cell in pairs(self.virtualCells) do
    if cell and cell.OnCellDestroy then
      cell:OnCellDestroy()
    end
    if cell and cell.VirtualClearSetData then
      cell:VirtualClearSetData()
    end
  end
  self.virtualCells = nil
end

function ActivityPaySignView:HandlePaySignSyncActCmd()
  self:RefreshView()
  local maxSignDay = ActivityPaySignProxy.Instance:GetMaxSignDay(self.activityId)
  local curSignedDay = ActivityPaySignProxy.Instance:GetCurSignedDay(self.activityId)
  local isFullPay = ActivityPaySignProxy.Instance:IsFullPay(self.activityId)
  if curSignedDay == maxSignDay and self:IsUpgradeButtonActive(isFullPay) then
    MsgManager.ConfirmMsgByID(43664, function()
      self:OnUpgradeBtnClick()
    end)
  end
end

function ActivityPaySignView:RefreshView()
  self:UpdateUpgradeInfos()
  local maxSignDay = ActivityPaySignProxy.Instance:GetMaxSignDay(self.activityId)
  local datas = {}
  for i = 1, maxSignDay do
    local data = ActivityPaySignProxy.Instance:GetSignDayConfig(self.activityId, i)
    TableUtility.ArrayPushBack(datas, data)
  end
  self.itemWrapHelper:UpdateInfo(datas, nil, true)
  local canReceiveAll = ActivityPaySignProxy.Instance:IsHaveAvailableReward(self.activityId)
  self:SetButtonEnable(self.receiveAllBtn, canReceiveAll, LabelEnabledEffectColor)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.receiveAllBtn)
  local isFullPay = ActivityPaySignProxy.Instance:IsFullPay(self.activityId)
  local showUpgradeBtn = self:IsUpgradeButtonActive(isFullPay)
  x = showUpgradeBtn and 287 or 116
  LuaGameObject.SetLocalPositionGO(self.receiveAllBtn, x, y, z)
  local rewardBgPadding = self.hasSuperReward and 13 or 8
  self.rewardBg.width = self.itemWrapHelper.wrap.itemSize * #datas + rewardBgPadding
  self:UpdateShowNextLevelReward(true)
  self:RefreshUpgradeButton(isFullPay)
end

function ActivityPaySignView:OnEnter()
  ActivityPaySignView.super.OnEnter(self)
  self:InitVirtualCells()
  local config = (not Table_ActivityNew or not Table_ActivityNew[self.activityId]) and GameConfig.ActPaySign and GameConfig.ActPaySign[self.activityId]
  if config then
    self.titleLabel.text = config.TitleName
    local params = config.Params_Inte
    if params then
      PictureManager.Instance:SetActivityTexture(params.Banner or "", self.bannerTex)
      self.descLabel:SetText(params.Desc)
    end
  end
  self:RefreshView()
end

function ActivityPaySignView:OnExit()
  local config = (not Table_ActivityNew or not Table_ActivityNew[self.activityId]) and GameConfig.ActPaySign and GameConfig.ActPaySign[self.activityId]
  if config and config.Params_Inte then
    PictureManager.Instance:UnloadActivityTexture(config.Params_Inte.Banner or "", self.bannerTex)
  end
  TimeTickManager.Me():ClearTick(self, 998)
  self:DestroyVirtualCells()
  ActivityPaySignView.super.OnExit(self)
end

function ActivityPaySignView:OnUpgradeBtnClick()
  local show, info = self:GetCurrentUpgradeInfo()
  self:BuyInfo(show, info)
end

function ActivityPaySignView:OnReceiveAllBtnClick()
  if self.activityId then
    local batchID = ActivityPaySignProxy.Instance:GetBatchID(self.activityId)
    ServiceActivityCmdProxy.Instance:CallPaySignRewardActCmd(self.activityId, batchID)
  end
end

function ActivityPaySignView:OnScrollStart()
  TimeTickManager.Me():CreateTick(0, 500, self.UpdateShowNextLevelReward, self, 998)
end

function ActivityPaySignView:OnScrollStop()
  TimeTickManager.Me():ClearTick(self, 998)
end

function ActivityPaySignView:UpdateShowNextLevelReward(forceUpdate)
  local maxShowDay = 0
  local cells = self.itemWrapHelper:GetCellCtls()
  local cell
  for i = 1, #cells do
    cell = cells[i]
    if cell.gameObject.activeSelf and maxShowDay < cell.level then
      maxShowDay = cell.level
    end
  end
  local nextDay = ActivityPaySignProxy.Instance:GetNextImportantDay(self.activityId, maxShowDay)
  if forceUpdate == true or self.nextLevelRewardCell.level ~= nextDay then
    self.nextLevelRewardCell:SetData(ActivityPaySignProxy.Instance:GetSignDayConfig(self.activityId, nextDay))
  end
end

function ActivityPaySignView:PurchaseDeposit(info, count)
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
  if not PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    MsgManager.ShowMsgByID(49)
    return
  end
  local doPurchase = function()
    if not PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
      MsgManager.ShowMsgByID(49)
      return
    end
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
  end
  if not BranchMgr.IsJapan() and not BranchMgr.IsKorea() and not BranchMgr.IsNOKR() then
    return doPurchase()
  end
  local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
  local productPrice = productConf.Rmb
  local productCount = productConf.Count
  local currencyType = productConf.CurrencyType
  local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[productConf.id].Desc)
  local productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
  if BranchMgr.IsKorea() or BranchMgr.IsNOKR() then
    productD = " [0075BCFF]" .. productDesc .. "[-] "
  end
  OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, doPurchase)
  return true
end

function ActivityPaySignView:UpdateUpgradeInfos()
  self:InitVirtualCells()
  if not self.upgradeInfos then
    self.upgradeInfos = {}
  else
    TableUtility.TableClear(self.upgradeInfos)
  end
  self.upgradeInfos[ADV_UPGRADE] = ActivityPaySignProxy.Instance:GetUpgradeInfo(self.activityId, false)
  self.upgradeInfos[SUPER_UPGRADE] = ActivityPaySignProxy.Instance:GetUpgradeInfo(self.activityId, true)
  self:InitShopData()
  for i = 1, #UPGRADE_SHOWS do
    local show = UPGRADE_SHOWS[i]
    self:SetVirtualCellData(show, self.upgradeInfos[show])
  end
end

function ActivityPaySignView:InitShopData()
  if not self.upgradeInfos then
    return
  end
  for _, info in pairs(self.upgradeInfos) do
    if self:IsShopItem(info) then
      ShopProxy.Instance:CallQueryShopConfig(info.ShopType, info.ShopId)
      HappyShopProxy.Instance:InitShop(nil, info.ShopId, info.ShopType)
    end
  end
end

function ActivityPaySignView:SetVirtualCellData(show, info)
  local cell = self.virtualCells and self.virtualCells[show]
  if not cell then
    return
  end
  if not info then
    cell:VirtualClearSetData()
    return
  end
  if info.DepositeId then
    cell:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit, info.DepositeId)
  elseif self:IsShopItem(info) then
    NewRechargeProxy.Instance.ShopType = info.ShopType
    NewRechargeProxy.Instance.ShopID = info.ShopId
    cell:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Shop, info.ShopItemId)
    cell.shopType = info.ShopType
    cell.shopId = info.ShopId
  end
  cell:SetPurchaseSuccessCB(function()
    self:RefreshView()
  end)
end

function ActivityPaySignView:GetCurrentUpgradeInfo()
  local show = ADV_UPGRADE
  local hasSuperReward = ActivityPaySignProxy.Instance:HasAnySuperReward(self.activityId)
  if hasSuperReward and ActivityPaySignProxy.Instance:IsPro(self.activityId) and not ActivityPaySignProxy.Instance:IsSuper(self.activityId) then
    show = SUPER_UPGRADE
  end
  return show, self.upgradeInfos and self.upgradeInfos[show] or ActivityPaySignProxy.Instance:GetUpgradeInfo(self.activityId, show == SUPER_UPGRADE)
end

function ActivityPaySignView:IsUpgradeButtonActive(isFullPay)
  if isFullPay then
    return false
  end
  local _, info = self:GetCurrentUpgradeInfo()
  return info ~= nil
end

function ActivityPaySignView:RefreshUpgradeButton(isFullPay)
  local showUpgradeBtn = self:IsUpgradeButtonActive(isFullPay)
  self.upgradeBtn:SetActive(showUpgradeBtn)
  if not showUpgradeBtn then
    self:SetUpgradePriceIcon(nil)
    return
  end
  local show, info = self:GetCurrentUpgradeInfo()
  local price, priceItemId = self:GetPriceInfo(info)
  local textFormat = ZhString.ActivityPaySignView_Upgrade
  self.upgradeBtnLabel.text = string.format(textFormat, price or ZhString.HappyShop_Buy)
  self:SetUpgradePriceIcon(priceItemId)
end

function ActivityPaySignView:GetPriceInfo(info)
  if not info then
    return
  end
  if info.DepositeId then
    local deposit = Table_Deposit and Table_Deposit[info.DepositeId]
    if deposit then
      return not deposit.priceStr and deposit.CurrencyType and deposit.Rmb and deposit.CurrencyType .. FunctionNewRecharge.FormatMilComma(deposit.Rmb)
    end
  elseif self:IsShopItem(info) then
    local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(info.ShopType, info.ShopId, info.ShopItemId)
    if shopItemData then
      local priceItemId = shopItemData.ItemID
      local priceNum = shopItemData.ItemCount
      if priceItemId and priceNum then
        return tostring(priceNum), priceItemId
      end
    end
  end
  return ZhString.HappyShop_Buy
end

function ActivityPaySignView:SetUpgradePriceIcon(priceItemId)
  if not self.upgradeIcon then
    return
  end
  local itemData = priceItemId and Table_Item and Table_Item[priceItemId]
  local icon = itemData and itemData.Icon
  self.upgradeIcon.gameObject:SetActive(icon ~= nil)
  if icon then
    IconManager:SetItemIcon(icon, self.upgradeIcon)
  end
end

function ActivityPaySignView:IsShopItem(info)
  return info and info.ShopType and info.ShopId and info.ShopItemId
end

function ActivityPaySignView:BuyInfo(show, info)
  if not info then
    return
  end
  if self:IsShopItem(info) then
    NewRechargeProxy.Instance.ShopType = info.ShopType
    NewRechargeProxy.Instance.ShopID = info.ShopId
    HappyShopProxy.Instance:InitShop(nil, info.ShopId, info.ShopType)
  end
  local cell = self.virtualCells and self.virtualCells[show]
  if cell then
    cell:Pre_Purchase()
  end
end

function ActivityPaySignView:ShopItemPurchase(data)
  if not data then
    return
  end
  if data.m_funcRmbBuy then
    data.m_funcRmbBuy(1)
  elseif data.info and data.info.id then
    HappyShopProxy.Instance:BuyItem(data.info.id, 1)
  end
end

function ActivityPaySignView:HandleShopUpdate()
  self:UpdateUpgradeInfos()
  local isFullPay = ActivityPaySignProxy.Instance:IsFullPay(self.activityId)
  self:RefreshUpgradeButton(isFullPay)
end
