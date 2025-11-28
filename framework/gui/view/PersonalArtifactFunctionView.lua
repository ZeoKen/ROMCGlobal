autoImport("HappyShopBuyItemCell")
autoImport("ShopItemCell")
autoImport("PersonalArtifactItemCell")
autoImport("PersonalArtifactComposeView")
autoImport("PersonalArtifactRefreshView")
autoImport("PersonalArtifactDecomposeView")
autoImport("PersonalArtifactExchangeView")
autoImport("PersonalArtifactFormulaCell")
PersonalArtifactFunctionView = class("PersonalArtifactFunctionView", BaseView)
PersonalArtifactFunctionView.ViewType = UIViewType.NormalLayer
PersonalArtifactFunctionTitle = {
  [PersonalArtifactFunctionState.Shop] = ZhString.PersonalArtifact_Shop,
  [PersonalArtifactFunctionState.Compose] = ZhString.PersonalArtifact_Title,
  [PersonalArtifactFunctionState.Decompose] = Table_NpcFunction[11003].NameZh,
  [PersonalArtifactFunctionState.Exchange] = Table_NpcFunction[11004].NameZh
}
PersonalArtifactFunctionIconName = {
  [PersonalArtifactFunctionState.Shop] = "tab_icon_117",
  [PersonalArtifactFunctionState.Compose] = "tab_icon_118",
  [PersonalArtifactFunctionState.Decompose] = "tab_icon_120",
  [PersonalArtifactFunctionState.Exchange] = "tab_icon_121"
}
PersonalArtifactFunctionHelpId = {
  [PersonalArtifactFunctionState.Compose] = 35043
}
PersonalArtifactFunctionAnimSkipType = {
  [PersonalArtifactFunctionState.Compose] = SKIPTYPE.PersonalArtifactCompose,
  [PersonalArtifactFunctionState.Exchange] = SKIPTYPE.PersonalArtifactExchange
}
PersonalArtifactFunctionChooseBoardTitle = {
  [PersonalArtifactFunctionState.Compose] = ZhString.PersonalArtifact_FormulaChooseTitle,
  [PersonalArtifactFunctionState.Decompose] = ZhString.EquipRefineBord_ChooseMat,
  [PersonalArtifactFunctionState.Exchange] = Table_NpcFunction[11004].NameZh
}
PersonalArtifactFunctionCtrl = {
  ShopCtrl = {
    [PersonalArtifactFunctionState.Shop] = true
  },
  ComposeCtrl = {
    [PersonalArtifactFunctionState.Compose] = true
  },
  DecomposeCtrl = {
    [PersonalArtifactFunctionState.Decompose] = true
  },
  ExchangeCtrl = {
    [PersonalArtifactFunctionState.Exchange] = true
  },
  CostCtrl1 = {
    [PersonalArtifactFunctionState.Shop] = true,
    [PersonalArtifactFunctionState.Compose] = true,
    [PersonalArtifactFunctionState.Decompose] = true,
    [PersonalArtifactFunctionState.Exchange] = true
  },
  CostCtrl2 = {
    [PersonalArtifactFunctionState.Shop] = true,
    [PersonalArtifactFunctionState.Compose] = true,
    [PersonalArtifactFunctionState.Decompose] = true,
    [PersonalArtifactFunctionState.Exchange] = true
  },
  ChooseBoard = {
    [PersonalArtifactFunctionState.Compose] = true,
    [PersonalArtifactFunctionState.Decompose] = true,
    [PersonalArtifactFunctionState.Exchange] = true
  },
  BoardCloseBtn = {
    [PersonalArtifactFunctionState.Compose] = true,
    [PersonalArtifactFunctionState.Decompose] = true,
    [PersonalArtifactFunctionState.Exchange] = true
  },
  BoardNoneTip = {},
  FormulaWrap = {
    [PersonalArtifactFunctionState.Compose] = true
  },
  DecomposeChooseContainer = {
    [PersonalArtifactFunctionState.Decompose] = true
  },
  ExchangeChooseContainer = {
    [PersonalArtifactFunctionState.Exchange] = true
  }
}
local buttonsTimeTickId = 9
local _defaultCost = "0"
local artifactIns, shopIns, bagIns, tickManager, refreshTargetPackageCheck, refreshCostPackageCheck
local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
local _ArrayRemoveByPredicate = TableUtility.ArrayRemoveByPredicate
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315)
local comparer = function(l, r)
  local lt, ls, rt, rs = l.staticData.Type, l.staticData.id, r.staticData.Type, r.staticData.id
  if lt ~= rt then
    return lt < rt
  end
  if ls ~= rs then
    return ls < rs
  end
  return l.id < r.id
end
local addDecomposeItems = function(target, chooseMap, bagType)
  local bag, item, chosen, clone = bagIns:GetBagByType(bagType)
  local source = bag and bag:GetItems()
  if not source then
    return
  end
  for i = 1, #source do
    item = source[i]
    if not bagIns:CheckIsFavorite(item, bagType) and not item:IsPersonalArtifactDebris() then
      chosen, clone = chooseMap[item.id], item:Clone()
      if chosen then
        clone.num = clone.num - chosen.num
      end
      if clone.num > 0 then
        if item.personalArtifactData then
          if item.personalArtifactData:IsActiveArtifact() then
            clone.personalArtifactData = item.personalArtifactData:Clone()
            _ArrayPushBack(target, clone)
          end
        else
          _ArrayPushBack(target, clone)
        end
      end
    end
  end
end
local tryAddFakeDataToItemData = function(item)
  if not item:IsPersonalArtifact() then
    return
  end
  item.personalArtifactData = PersonalArtifactData.new(item.staticData.id)
  if item.personalArtifactData.isInited then
    item.personalArtifactData:SetFakeData()
  end
end
local materialSelectComparer = function(l, r)
  return l.staticData.id < r.staticData.id
end
local _checkRefreshItem = function(itemId, cost)
  local myCount = bagIns:GetItemNumByStaticID(itemId, refreshCostPackageCheck)
  return myCount >= (cost or math.huge), myCount
end
local addPersonalArtifact = function(datas, bagType)
  local bag = bagIns:GetBagByType(bagType)
  local bagItems, item = bag and bag:GetItems()
  if bagItems then
    for i = 1, #bagItems do
      item = bagItems[i]
      if item:IsRarePersonalArtifact() and not bagIns:CheckIsFavorite(item, bagType) then
        _ArrayPushBack(datas, item)
      end
    end
  end
end
local equipSortFunc = function(l, r)
  if l.equiped ~= r.equiped then
    return l.equiped > r.equiped
  end
  local lRefreshed, rRefreshed = l.personalArtifactData:IsRefreshed() and 1 or 0, r.personalArtifactData:IsRefreshed() and 1 or 0
  if lRefreshed ~= rRefreshed then
    return lRefreshed > rRefreshed
  end
  local lQuality, rQuality = l.staticData.Quality, r.staticData.Quality
  if lQuality ~= rQuality then
    return lQuality > rQuality
  end
  local lSId, rSId = l.staticData.id, r.staticData.id
  if lSId ~= rSId then
    return lSId < rSId
  end
  return l.id < r.id
end
local _limited_alpha = 0.5
local _OptionBtn = {
  Normal = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0),
  Gray = LuaColor.New(0.5137254901960784, 0.5137254901960784, 0.5137254901960784),
  NormalSp = "com_btn_2",
  GraySp = "com_btn_13"
}

function PersonalArtifactFunctionView:Init()
  if not artifactIns then
    artifactIns = PersonalArtifactProxy.Instance
    shopIns = HappyShopProxy.Instance
    bagIns = BagProxy.Instance
    tickManager = TimeTickManager.Me()
    refreshTargetPackageCheck = {
      BagProxy.BagType.RoleEquip,
      BagProxy.BagType.PersonalArtifact
    }
    refreshCostPackageCheck = GameConfig.PackageMaterialCheck.equip_remould or GameConfig.PackageMaterialCheck.default
  end
  for name, _ in pairs(PersonalArtifactFunctionCtrl) do
    self[name] = self:FindGO(name)
  end
  self:_InitComposePreview()
  self:AddEvents()
  self:InitData()
  self:InitTabs()
  self:InitRight()
  self:InitLeft()
end

function PersonalArtifactFunctionView:_InitComposePreview()
  artifactIns:ResetComposePreview()
  artifactIns:SetPreviewFlag(false)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    if viewdata.state then
      self.initializedState = viewdata.state
    elseif viewdata.save_type and viewdata.save_id then
      artifactIns:ProcessSaveData(viewdata.save_type, viewdata.save_id)
      self.initializedState = PersonalArtifactFunctionState.Compose
      artifactIns:SetPreviewFlag(true)
    end
  else
    self.initializedState = PersonalArtifactFunctionState.Default
  end
end

function PersonalArtifactFunctionView:AddEvents()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.OnBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.OnShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.OnServerLimitSellCount)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.OnUpdateShopConfig)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnPersonalArtifactUpdate)
  self:AddListenEvt(ItemEvent.PersonalArtifactUpdate, self.OnPersonalArtifactUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
  self:AddListenEvt(PersonalArtifactDecomposeEvent.PutIn, self.OnDecomposePutIn)
end

function PersonalArtifactFunctionView:InitData()
  self.tipData = {
    ignoreBounds = {}
  }
  self.cachedTargetAttrMap = {}
  self.selectedExchangeMaterialData = {}
  self.maxExchangeMaterialCount = 5
  self.decomposeItems = {}
  local cfg = GameConfig.PersonalArtifact
  self.decomposeCostItemId, self.decomposePerCost = cfg.DecomposeCostItemId, cfg.DecomposeCostItemCount
  self.decomposeProductId, self.decomposeProductCfg = cfg.DecomposeProduceItemId, cfg.DecomposeProduceItemCout
end

function PersonalArtifactFunctionView:InitTabs()
  self.tabGrid = self:FindComponent("TabGrid", UIGrid)
  self.tabCollider = self:FindGO("TabCollider")
  self.tabGOs, self.tabIconSps, self.tabToggles = {}, {}, {}
  local tabGO, longPress, checkmarkIcon
  for name, state in pairs(PersonalArtifactFunctionState) do
    tabGO = self:FindGO(name .. "Tab")
    if tabGO then
      self:AddClickEvent(tabGO, function()
        self:UpdatePageState(state)
      end)
      self.tabGOs[state] = tabGO
      self.tabIconSps[state] = self:FindComponent("Icon", UISprite, tabGO)
      self.tabToggles[state] = tabGO:GetComponent(UIToggle)
      longPress = tabGO:GetComponent(UILongPress)
      
      function longPress.pressEvent(obj, pressState)
        self:PassEvent(TipLongPressEvent.PersonalArtifactFunctionView, {pressState, state})
      end
      
      local iconName = PersonalArtifactFunctionIconName[state]
      IconManager:SetUIIcon(iconName, self.tabIconSps[state])
      checkmarkIcon = self:FindComponent("CheckmarkIcon", UISprite, tabGO)
      IconManager:SetUIIcon(iconName, checkmarkIcon)
    end
  end
  self:AddEventListener(TipLongPressEvent.PersonalArtifactFunctionView, self.OnTabLongPress, self)
end

local skipAnimTipOffset = {90, 45}

function PersonalArtifactFunctionView:InitRight()
  self.helpBtn = self:FindGO("HelpBtn")
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  if self.skipBtnSp then
    self:Hide(self.skipBtnSp)
  end
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self:InitShop()
  self:InitCompose()
  self:InitRefresh()
  self:InitDecompose()
  self:InitExchange()
end

function PersonalArtifactFunctionView:InitShop()
  self.shopItemContainer = self:FindGO("ShopItemContainer")
  self.shopItemCtrl = WrapListCtrl.new(self.shopItemContainer, ShopItemCell, "ShopItemCell")
  self.shopItemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickShopItem, self)
  self.shopItemCtrl:AddEventListener(HappyShopEvent.SelectIconSprite, self.OnClickShopIcon, self)
  
  function self.shopItemCtrl.scrollView.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipManager.CloseTip()
  end
  
  shopIns:InitShop(nil, 1, GameConfig.PersonalArtifact.ShopID)
end

function PersonalArtifactFunctionView:InitCompose()
  self.composeTitle = self:FindComponent("TitleLab", UILabel, self.ComposeCtrl)
  self.composeTitle.text = ZhString.PersonalArtifact_Title
  self.unavailableComposeBtn = self:FindGO("UnavailableComposeBtn")
  if self.unavailableComposeBtn then
    self:Hide(self.unavailableComposeBtn)
  end
  self.formulaGrid = self.FormulaWrap:GetComponent(UIGrid)
  self.formulaListCtl = ListCtrl.new(self.formulaGrid, PersonalArtifactFormulaCell, "PersonalArtifactFormulaCell")
  self.formulaListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFormula, self)
  self.formulaListCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickFormulaIcon, self)
  self.formulaListCells = self.formulaListCtl:GetCells()
  local targetCellParent = self:FindGO("TargetCell", self.ComposeCtrl)
  self.targetCell = PersonalArtifactItemCell.new(targetCellParent)
  self.targetCell:SetData(BagItemEmptyType.Empty)
  self.targetCell:HideIndex()
  self:AddClickEvent(targetCellParent, function()
    self.ChooseBoard:SetActive(true)
    TipManager.CloseTip()
  end)
  self.materialCells = {}
  local go
  for i = 1, 5 do
    go = self:FindGO("MaterialCell" .. i, self.ComposeCtrl)
    self.materialCells[i] = PersonalArtifactItemCell.new(go)
    self.materialCells[i]:SetIndex(i)
    self.materialCells[i]:SetData(BagItemEmptyType.Empty)
    self.materialCells[i]:HideNum()
    self:AddClickEvent(go, function()
      self:OnClickComposeMaterialCell(i)
    end)
  end
  
  function self.composeCheckFunc(withTip)
    if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.SystemOpen_MenuId.PersonalArtifactAttr) then
      if withTip then
        MsgManager.ShowMsgByID(41404)
      end
      return false
    end
    if not BagItemCell.CheckData(self.composeTargetItemData) then
      if withTip then
        MsgManager.FloatMsg("", ZhString.PersonalArtifact_NoFormulaTip)
      end
      return false
    end
    if not self:CheckComposeMaterials() then
      if withTip then
        MsgManager.ShowMsgByID(41338)
      end
      return false
    end
    if not self:CheckComposeCostItem() then
      if withTip then
        MsgManager.ShowMsgByIDTable(25418, self.composeCostItemId and Table_Item[self.composeCostItemId].NameZh)
      end
      return false
    end
    if bagIns:CheckBagIsFull(BagProxy.BagType.PersonalArtifact) then
      if withTip then
        MsgManager.ShowMsgByID(41339)
      end
      return false
    end
    return true
  end
end

function PersonalArtifactFunctionView:CheckSafeToggleEnabled()
  return self.safeCheckTog.gameObject.activeSelf and self.safeCheckTog.value == true
end

function PersonalArtifactFunctionView:UpdateSafelyBtn()
  local safeOpen = self:CheckSafeToggleEnabled()
  if safeOpen then
    self.refreshBtnLab.text = ZhString.PersonalArtifact_Refresh_Safe
    self.HRefreshBtnLab.text = ZhString.PersonalArtifact_HRefresh_Safe
  else
    self.refreshBtnLab.text = ZhString.PersonalArtifact_Refresh
    self.HRefreshBtnLab.text = ZhString.PersonalArtifact_HRefresh
  end
end

function PersonalArtifactFunctionView:InitRefresh()
  self.refreshAttrGrid = self:FindComponent("AttrGrid", UIGrid, self.ComposeCtrl)
  self.refreshAttrListCtl = ListCtrl.new(self.refreshAttrGrid, PersonalArtifactRefreshAttributeCell, "PersonalArtifactRefreshAttributeCell")
  self.refreshAttrListCells = self.refreshAttrListCtl:GetCells()
  self.refreshMainCtrlParent = self:FindGO("MainCtrls", self.ComposeCtrl)
  self.safeCheckTog = self:FindComponent("SafeCheckTog", UIToggle, self.refreshMainCtrlParent)
  self.safeCheckLab = self:FindComponent("Label", UILabel, self.safeCheckTog.gameObject)
  self.safeCheckLab.text = ZhString.PersonalArtifact_SafelyCheck
  EventDelegate.Add(self.safeCheckTog.onChange, function()
    self:UpdateSafelyBtn()
    self:UpdateRefreshCost()
  end)
  self.costRoot = self:FindComponent("Cost", UISprite, self.refreshMainCtrlParent)
  self.refreshCostItemSp = self:FindComponent("CostItem", UISprite, self.costRoot.gameObject)
  self.refreshCostLabel = self:FindComponent("CostLabel", UILabel, self.costRoot.gameObject)
  self.refreshCostAddBtn = self:FindGO("CostAddBtn", self.costRoot.gameObject)
  self.hCostRoot = self:FindComponent("HCost", UISprite, self.refreshMainCtrlParent)
  self.refreshHCostItemSp = self:FindComponent("HCostItem", UISprite, self.hCostRoot.gameObject)
  self.refreshHCostLabel = self:FindComponent("HCostLabel", UILabel, self.hCostRoot.gameObject)
  self.refreshHCostAddBtn = self:FindGO("HCostAddBtn", self.hCostRoot.gameObject)
  self.refreshBtnParent = self:FindGO("RefreshBtns", self.refreshMainCtrlParent)
  self.saveBtnParent = self:FindGO("SaveBtns", self.refreshMainCtrlParent)
  self.refreshBtnSp = self:FindComponent("RefreshBtn", UISprite, self.refreshBtnParent)
  self.refreshBtnLab = self:FindComponent("Label", UILabel, self.refreshBtnSp.gameObject)
  self.refreshBtnLab.text = ZhString.PersonalArtifact_Refresh
  self.HRefreshBtnSp = self:FindComponent("HRefreshBtn", UISprite, self.refreshBtnParent)
  self.HRefreshBtnLab = self:FindComponent("Label", UILabel, self.HRefreshBtnSp.gameObject)
  self.HRefreshBtnLab.text = ZhString.PersonalArtifact_HRefresh
  local tryRefreshFunc = function(isH)
    if self.fragmentLimited then
      return
    end
    if artifactIns:IsInPreview() then
      return
    end
    if not self.clickButtonEnabled then
      return
    end
    if not self:CheckRefresh(isH) then
      return
    end
    if self:CheckRefreshAttrsAllMax() then
      MsgManager.ShowMsgByID(41399)
      return
    end
    self:SetButtonsEnabled(false)
    tickManager:CreateOnceDelayTick(500, function(self)
      self:SetButtonsEnabled(true)
    end, self, buttonsTimeTickId)
    local t
    if isH then
      t = self:CheckSafeToggleEnabled() and SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_PAY_TEN or SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_PAY
    else
      t = self:CheckSafeToggleEnabled() and SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_FREE_TEN or SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_FREE
    end
    ServiceItemProxy.Instance:CallPersonalArtifactRemouldItemCmd(self.composeTargetItemData.id, t)
  end
  self:AddButtonEvent("RefreshBtn", function()
    tryRefreshFunc(false)
  end)
  self:AddButtonEvent("HRefreshBtn", function()
    tryRefreshFunc(true)
  end)
  local saveBtn = self:FindGO("SaveBtn", self.saveBtnParent)
  local saveBtnLab = self:FindComponent("Label", UILabel, saveBtn)
  saveBtnLab.text = ZhString.PersonalArtifact_Save
  self:AddClickEvent(saveBtn, function()
    if not self.clickButtonEnabled then
      return
    end
    if not self.composeTargetItemData then
      LogUtility.Error("Cannot get target item while saving!")
      return
    end
    ServiceItemProxy.Instance:CallPersonalArtifactAttrSaveItemCmd(self.composeTargetItemData.id, true)
  end)
  local cancelBtn = self:FindGO("CancelBtn", self.saveBtnParent)
  local cancelBtnLab = self:FindComponent("Label", UILabel, cancelBtn)
  cancelBtnLab.text = ZhString.PersonalArtifact_Quit
  
  function self.cancelSavingFunc()
    ServiceItemProxy.Instance:CallPersonalArtifactAttrSaveItemCmd(self.composeTargetItemData.id, false)
  end
  
  self:AddClickEvent(cancelBtn, function()
    if not self.clickButtonEnabled then
      return
    end
    if not self.composeTargetItemData then
      LogUtility.Error("Cannot get target item while cancelling save!")
      return
    end
    if self:CheckHasBetterRefreshAttrToSave() then
      MsgManager.ConfirmMsgByID(41342, self.cancelSavingFunc)
    else
      self.cancelSavingFunc()
    end
  end)
  self:AddClickEvent(self.refreshCostAddBtn, function()
    if not self.clickButtonEnabled then
      return
    end
    if self.fragmentLimited then
      return
    end
    if artifactIns:IsInPreview() then
      return
    end
    self:UpdatePageState(PersonalArtifactFunctionState.Shop)
  end)
  self:AddClickEvent(self.refreshHCostAddBtn, function()
    if self.fragmentLimited then
      return
    end
    if artifactIns:IsInPreview() then
      return
    end
    if not self.clickButtonEnabled then
      return
    end
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TShop, FunctionNewRecharge.InnerTab.Shop_Recommend)
  end)
end

function PersonalArtifactFunctionView:InitDecompose()
  self.decomposeTipLabelGO = self:FindGO("TipLabel", self.DecomposeCtrl)
  self.decomposeNoneTip = self:FindGO("NoneTip", self.DecomposeCtrl)
  local noneTipLabel = self:FindComponent("Label", UILabel, self.decomposeNoneTip)
  noneTipLabel.text = Table_Sysmsg[41334].Text
  self.decomposeListContainer = self:FindGO("ItemContainer", self.DecomposeCtrl)
  self.decomposeListCtl = WrapListCtrl.new(self.decomposeListContainer, BagItemCell, "BagItemCell", nil, 5, 100)
  self.decomposeListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDecomposeListCell, self)
  self.decomposeResultGrid = self:FindComponent("ResultGrid", UIGrid, self.DecomposeCtrl)
  self.decomposeResultCtl = UIGridListCtrl.new(self.decomposeResultGrid, DecomposeItemCell, "DecomposeItemCell")
  self.decomposeResultCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDecomposeResultCell, self)
  self.decomposeCostLabel = self:FindComponent("Cost", UILabel, self.DecomposeCtrl)
  self.decomposeCostSp = self:FindComponent("Sprite", UISprite, self.decomposeCostLabel.gameObject)
  IconManager:SetItemIcon(Table_Item[self.decomposeCostItemId].Icon, self.decomposeCostSp)
  self.decomposeChooseCtl = WrapListCtrl.new(self.DecomposeChooseContainer, EquipChooseCell, "EquipChooseCell")
  self.decomposeChooseCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDecomposeChooseCell, self)
  self.decomposeChooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickDecomposeChooseCellIcon, self)
  self.unavailableDecomposeBtn = self:FindGO("UnavailableDecomposeBtn")
  self.decomposeBtn = self:FindGO("DecomposeBtn")
  self:AddClickEvent(self.decomposeBtn, function()
    if not self:CheckDecomposeCost(true) then
      return
    end
    if bagIns:CheckBagIsFull(BagProxy.BagType.MainBag) then
      MsgManager.ShowMsgByID(989)
      return
    end
    MsgManager.ConfirmMsgByID(41335, function()
      PersonalArtifactProxy.CallDecompose(self.decomposeItems)
    end)
  end)
end

function PersonalArtifactFunctionView:InitExchange()
  self.exchangeEffContainer = self:FindGO("EffectContainer", self.ExchangeCtrl)
  self.exchangeMainLabel = self:FindComponent("MainLabel", UILabel, self.ExchangeCtrl)
  local itemCell = self:LoadPreferb("cell/BagItemCell", self:FindGO("TargetCell", self.ExchangeCtrl))
  self.exchangeTargetCell = BagItemCell.new(itemCell)
  self:AddClickEvent(itemCell, function()
    self:OnClickExchangeTargetCell()
  end)
  local longPress = itemCell:GetComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPressing)
    if not isPressing then
      return
    end
    self:ShowItemTip(self.exchangeTargetCell.data, nil, NGUIUtil.AnchorSide.Right, 30)
    self.isClickOnTargetCellDisabled = true
  end
  
  self.exchangeTargetCellItemPart = self:FindGO("Common_ItemCell", itemCell)
  self.exchangeCostSp = self:FindComponent("CostSprite", UISprite, self.ExchangeCtrl)
  self.exchangeCostLabel = self:FindComponent("CostLabel", UILabel, self.ExchangeCtrl)
  local exchangeBtn = self:FindGO("ExchangeBtn")
  self:AddClickEvent(exchangeBtn, function()
    if not self.clickButtonEnabled then
      return
    end
    self:TryExchange()
  end)
  self.exchangeBtnBgSp = exchangeBtn:GetComponent(UISprite)
  self.exchangeBtnLabel = self:FindComponent("Label", UILabel, exchangeBtn)
  self.exchangeMaterialGO = self:FindGO("5Material")
  self.exchangeMaterialListCtrl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.exchangeMaterialGO), MaterialSelectItemCell, "MaterialSelectItemCell")
  self.exchangeMaterialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExchangeMaterialCell, self)
  self.exchangeMaterialListCtrl:AddEventListener(ItemEvent.ItemDeselect, self.OnClickExchangeMaterialCell, self)
  self.exchangeMaterialSelectCtrl = WrapListCtrl.new(self.ExchangeChooseContainer, PersonalArtifactExchangeItemCell, "BagItemCell", nil, 5, 100, true)
  self.exchangeMaterialSelectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExchangeMaterialSelectCell, self)
  self.exchangeMaterialSelectCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressExchangeMaterialSelectCell, self)
  self.exchangeMaterialSelectCells = self.exchangeMaterialSelectCtrl:GetCells()
end

function PersonalArtifactFunctionView:InitLeft()
  self:InitBuyItemCell()
  self:InitCostCtrls()
  self.chooseBoardTitle = self:FindComponent("BoardTitle", UILabel)
  self.boardPanel = self:FindComponent("BoardScrollView", UIPanel)
  self:AddButtonEvent("BoardCloseBtn", function()
    self.ChooseBoard:SetActive(false)
  end)
end

function PersonalArtifactFunctionView:InitBuyItemCell()
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"))
  if not go then
    return
  end
  go.transform:SetParent(self.gameObject.transform, false)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.buyCell.closeWhenClickOtherPlace:AddTarget(self.shopItemContainer.transform)
  go:SetActive(false)
end

function PersonalArtifactFunctionView:InitCostCtrls()
  self.costSps, self.costLabels = {}, {}
  local go
  for i = 1, 2 do
    go = self:FindGO("CostCtrl" .. i)
    self.costSps[i] = go:GetComponent(UISprite)
    self.costLabels[i] = self:FindComponent("Label", UILabel, go)
  end
end

function PersonalArtifactFunctionView:OnEnter()
  SaveInfoProxy.Instance:CheckHasInfo(SaveInfoEnum.Branch)
  PersonalArtifactFunctionView.super.OnEnter(self)
  self:SetButtonsEnabled(true)
  if not artifactIns:IsInPreview() then
    self:CameraRotateToMe()
  end
  self:UpdatePageState(self.initializedState)
  self:HideOtherTab()
end

function PersonalArtifactFunctionView:HideOtherTab()
  if not artifactIns:IsInPreview() then
    return
  end
  for state, obj in pairs(self.tabGOs) do
    obj:SetActive(state == self.initializedState)
  end
  self.tabGrid:Reposition()
end

function PersonalArtifactFunctionView:OnExit()
  tickManager:ClearTick(self)
  if not artifactIns:IsInPreview() then
    self:CameraReset()
  end
  PersonalArtifactFunctionView.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end

function PersonalArtifactFunctionView:OnTabLongPress(param)
  local isPressing, state = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, PersonalArtifactFunctionTitle[state], nil, self.tabIconSps[state])
end

function PersonalArtifactFunctionView:OnBuyShopItem(note)
  self:UpdateShopInfo()
end

function PersonalArtifactFunctionView:OnQueryShopConfig(note)
  self:UpdateShopInfo(true)
end

function PersonalArtifactFunctionView:OnShopDataUpdate(note)
  self:UpdateShopInfo()
end

function PersonalArtifactFunctionView:OnServerLimitSellCount(note)
  self:UpdateShopInfo()
end

function PersonalArtifactFunctionView:OnUpdateShopConfig(note)
  self:UpdateShopInfo(true)
end

function PersonalArtifactFunctionView:UpdateFormulaChoose()
  local chooseid = self.composeTargetItemData.id
  local cells = self.formulaListCells
  for i = 1, #cells do
    cells[i]:SetChoose(chooseid)
  end
end

function PersonalArtifactFunctionView:OnPersonalArtifactUpdate()
  if self.state == PersonalArtifactFunctionState.Compose then
    if self.composeTargetItemData then
      local staticId = self.composeTargetItemData.staticData.id
      self.composeTargetItemData = artifactIns:TryGetPersonalArtifactItem(self.composeTargetItemData.id)
      if not self.composeTargetItemData then
        self.composeTargetItemData = artifactIns:TryGetPersonalArtifactItems(staticId, true)
      end
    end
    self:UpdateComposeTargetCell(self.composeTargetItemData)
    self:UpdateFormulaList()
    self:UpdateFormulaChoose()
  elseif self.state == PersonalArtifactFunctionState.Decompose then
    _TableClear(self.decomposeItems)
    self:UpdateDecompose()
  elseif self.state == PersonalArtifactFunctionState.Exchange then
    _TableClear(self.selectedExchangeMaterialData)
    self:UpdateSelectedExchangeMaterial()
    self:UpdateExchangeMaterialSelectList(true)
  end
end

function PersonalArtifactFunctionView:OnItemUpdate()
  self:UpdateCostCtrls()
  self:UpdateRefreshCost()
end

function PersonalArtifactFunctionView:OnDecomposePutIn(note)
  return PersonalArtifactDecomposeView.OnPutIn(self, note)
end

function PersonalArtifactFunctionView:OnClickShopItem(cellCtl)
  if self.currentShopItem ~= cellCtl then
    if self.currentShopItem then
      self.currentShopItem:SetChoose(false)
    end
    cellCtl:SetChoose(true)
    self.currentShopItem = cellCtl
  end
  local id = cellCtl.data
  local data = shopIns:GetShopItemDataByTypeId(id)
  local go = cellCtl.gameObject
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
    shopIns:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end

function PersonalArtifactFunctionView:OnClickShopIcon(cellCtl)
  local data = shopIns:GetShopItemDataByTypeId(cellCtl.data)
  if data and data.goodsID then
    if #self.tipData.ignoreBounds == 0 then
      _ArrayPushBack(self.tipData.ignoreBounds, self.shopItemContainer)
    end
    self:ShowItemTip(data:GetItemData(), nil, nil, -180)
  end
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function PersonalArtifactFunctionView:OnClickFormula(cell)
  local itemid = cell and cell.data and cell.data.staticData and cell.data.staticData.id
  if not itemid then
    return
  end
  self:UpdateComposeTargetCell(cell.data)
  self:UpdateFormulaChoose()
end

function PersonalArtifactFunctionView:OnClickFormulaIcon(data)
  self:ShowItemTip(data, nil, NGUIUtil.AnchorSide.Right, -100)
  do return end
  local itemid = data and data.staticData and data.staticData.id
  if not itemid then
    return
  end
  local tip = self:ShowComposeItemTip(itemid)
  if tip then
    for _, childCell in pairs(self.formulaListCells) do
      tip:AddIgnoreBounds(childCell.icon.gameObject)
    end
  end
end

function PersonalArtifactFunctionView:OnClickComposeMaterialCell(index)
  if not BagItemCell.CheckData(self.composeTargetItemData) then
    return
  end
  local cell = self.materialCells[index]
  if not cell or not BagItemCell.CheckData(cell.data) then
    return
  end
  self.chooseMaterialCellIndex = index
  local data = self.materialCells[index].data
  if BagItemCell.CheckData(data) then
    local mats = self:_GetMaterialsByIndexOfTargetFormulaData(index)
    self:ShowComposeItemTip(0 < #mats and mats[1] or data.staticData.id)
  end
end

function PersonalArtifactFunctionView:OnClickDecomposeResultCell(cellCtl)
  if not cellCtl or not cellCtl.data then
    return
  end
  local tip = self:ShowItemTip(cellCtl.data, nil, nil, -180)
  if tip then
    tip:AddIgnoreBounds(self.decomposeResultGrid)
  end
end

function PersonalArtifactFunctionView:OnClickDecomposeListCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  if self.decomposeItems[data.id] then
    self.decomposeItems[data.id] = nil
    self:UpdateDecompose()
  end
end

local decomposeFuncConfig = {72}

function PersonalArtifactFunctionView:OnClickDecomposeChooseCell(cellCtl)
  self.ChooseBoard:SetActive(true)
  local itemData = cellCtl and cellCtl.data
  if not itemData then
    return
  end
  local chooseData = self:GetDecomposeItems()
  if #chooseData >= self:GetMaxDecomposeCount() then
    MsgManager.ShowMsgByID(244)
    return
  end
  if itemData.num > 1 then
    self:ShowItemTip(itemData, nil, nil, 200, nil, decomposeFuncConfig)
  elseif itemData.num == 1 then
    self:_PutIn(itemData, 1)
  else
    LogUtility.WarningFormat("Num of the item is 0. There must be sth wrong.")
  end
end

function PersonalArtifactFunctionView:OnClickDecomposeChooseCellIcon(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  local tip = self:ShowItemTip(data, nil, NGUIUtil.AnchorSide.Right, -100)
  if tip then
    for _, cell in pairs(self.decomposeChooseCtl:GetCells()) do
      tip:AddIgnoreBounds(cell.itemCell.icon.gameObject)
    end
  end
end

function PersonalArtifactFunctionView:OnClickExchangeTargetCell()
  if self.isClickOnTargetCellDisabled then
    self.isClickOnTargetCellDisabled = nil
    return
  end
  self.ChooseBoard:SetActive(false)
  self.exchangeCandidates = self.exchangeCandidates or {}
  if not next(self.exchangeCandidates) then
    for id, data in pairs(GameConfig.PersonalArtifact.ExchangeItem) do
      if data.quality > 0 then
        _ArrayPushBack(self.exchangeCandidates, ItemData.new("TargetSelect" .. id, id))
      end
    end
  end
  table.sort(self.exchangeCandidates, function(l, r)
    return l.id < r.id
  end)
  if #self.exchangeCandidates > 1 then
    self:OnClickExchangeTargetSelectCell(self.exchangeCandidates[1])
  elseif #self.exchangeCandidates == 1 then
    self:OnClickExchangeTargetSelectCell(self.exchangeCandidates[1])
  else
    LogUtility.Warning("There is no candidates for exchanging")
  end
end

function PersonalArtifactFunctionView:OnClickExchangeTargetSelectCell(data)
  self.ChooseBoard:SetActive(true)
  self:SetItemToExchange(data)
end

function PersonalArtifactFunctionView:OnClickExchangeMaterialCell(cellCtl)
  if not self.exchangeTargetFragmentStaticId then
    MsgManager.ShowMsgByID(41332)
    return
  end
  if not self.clickButtonEnabled then
    return
  end
  self.ChooseBoard:SetActive(true)
  local data = cellCtl.data
  _ArrayRemoveByPredicate(self.selectedExchangeMaterialData, function(item)
    return BagItemCell.CheckData(data) and data.id == item.id
  end)
  self:UpdateSelectedExchangeMaterial()
  self:UpdateExchangeMaterialSelectList()
end

function PersonalArtifactFunctionView:OnClickExchangeMaterialSelectCell(cellCtl)
  if not self.clickButtonEnabled then
    return
  end
  if self.isClickOnListCtrlDisabled then
    self.isClickOnListCtrlDisabled = nil
    return
  end
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  for _, cell in pairs(self.exchangeMaterialSelectCells) do
    cell:SetChooseId(data and data.id or 0)
  end
  if #self.selectedExchangeMaterialData < self.maxExchangeMaterialCount then
    if 0 < self:GetUnselectedExchangeCountByStaticId(data.id) then
      local cloneData = data:Clone()
      cloneData:SetItemNum(1)
      _ArrayPushBack(self.selectedExchangeMaterialData, cloneData)
    end
    self:UpdateSelectedExchangeMaterial()
    self:UpdateExchangeMaterialSelectList()
  end
end

function PersonalArtifactFunctionView:OnLongPressExchangeMaterialSelectCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl and cellCtl.data then
    self:ShowItemTip(bagIns:GetItemByGuid(cellCtl.data.id), nil, NGUIUtil.AnchorSide.Right, 180)
    self.isClickOnListCtrlDisabled = true
  end
end

function PersonalArtifactFunctionView:UpdatePageState(state)
  if not state then
    return
  end
  if self.state and self.state == state then
    return
  end
  self.state = state
  self.tabToggles[self.state].value = true
  for name, cfg in pairs(PersonalArtifactFunctionCtrl) do
    if cfg[self.state] then
      self[name]:SetActive(true)
    else
      self[name]:SetActive(false)
    end
  end
  self.helpId = PersonalArtifactFunctionHelpId[self.state]
  self:TryOpenHelpViewById(self.helpId, nil, self.helpBtn)
  self.chooseBoardTitle.text = PersonalArtifactFunctionChooseBoardTitle[self.state] or ""
  self:UpdateCostCtrls()
  if state == PersonalArtifactFunctionState.Shop then
    self:UpdateShopInfo(true)
  elseif state == PersonalArtifactFunctionState.Compose then
    self:UpdateFormulaList(true)
  elseif state == PersonalArtifactFunctionState.Decompose then
    self:OnPersonalArtifactUpdate()
  elseif state == PersonalArtifactFunctionState.Exchange then
    self:SetItemToExchange()
    self:UpdateSelectedExchangeMaterial()
    self:OnClickExchangeTargetCell()
    if not self.exchangeBackEffect then
      self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.exchangeEffContainer, false, function(obj, args, assetEffect)
        self.exchangeBackEffect = assetEffect
        self.exchangeBackEffect:ResetAction("ronghe_1", 0, true)
      end)
    else
      self.exchangeBackEffect:ResetAction("ronghe_1", 0, true)
    end
    self:SetExchangeBtnActive(false)
  end
end

function PersonalArtifactFunctionView:UpdateCostCtrls(state)
  state = state or self.state
  if state == PersonalArtifactFunctionState.Shop then
    local moneyTypes = shopIns:GetMoneyType() or _EmptyTable
    for i = 1, #self.costSps do
      self:_UpdateCostCtrl(i, moneyTypes[i])
    end
  elseif state == PersonalArtifactFunctionState.Compose or state == PersonalArtifactFunctionState.Exchange then
    self:_UpdateCostCtrl(1, GameConfig.MoneyId.Zeny)
    self:_UpdateCostCtrl(2)
  elseif state == PersonalArtifactFunctionState.Decompose then
    self:_UpdateCostCtrl(1, GameConfig.MoneyId.Zeny)
    self:_UpdateCostCtrl(2, self.decomposeProductId)
  end
end

function PersonalArtifactFunctionView:_UpdateCostCtrl(index, moneyId)
  if index and self.costSps[index] then
    if moneyId and Table_Item[moneyId] then
      IconManager:SetItemIcon(Table_Item[moneyId].Icon, self.costSps[index])
      self.costSps[index].gameObject:SetActive(true)
      self.costLabels[index].text = StringUtil.NumThousandFormat(shopIns:GetItemNum(moneyId))
    else
      self.costSps[index].gameObject:SetActive(false)
    end
  end
end

function PersonalArtifactFunctionView:UpdateShopInfo(isReset)
  if self.state ~= PersonalArtifactFunctionState.Shop then
    return
  end
  local datas = shopIns:GetShopItems()
  if datas then
    self.shopItemCtrl:ResetDatas(datas)
    shopIns:SetSelectId(nil)
  end
  if isReset == true then
    self:UpdateCostCtrls()
    self.shopItemCtrl:ResetPosition()
    self.buyCell.gameObject:SetActive(false)
  end
  self.currentShopItem = nil
  self.selectGo = nil
end

function PersonalArtifactFunctionView:UpdateBuyItemInfo(data)
  if not data then
    return
  end
  local itemType = data.itemtype
  if itemType and itemType ~= 2 then
    self.buyCell:SetData(data)
    self.buyCell:UpdateConfirmBtn(shopIns:GetCanBuyCount(data) ~= 0)
    self.buyCell.gameObject:SetActive(true)
    TipManager.CloseTip()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

function PersonalArtifactFunctionView:UpdateComposeTargetCell(itemData)
  TipManager.Instance:CloseItemTip()
  if itemData == nil or nil == itemData.staticData then
    LogUtility.Warning("Cannot get item id when updating targetcell!")
    return
  end
  local isSameTarget = self.composeTargetItemData ~= nil and self.composeTargetItemData.id == itemData.id
  self.composeTargetItemData = itemData
  self.targetCell:SetData(self.composeTargetItemData)
  local itemId = self.composeTargetItemData.staticData.id
  self.targetFormulaStaticData = Table_PersonalArtifactCompose[itemId]
  artifactIns:SetTargetArtifact(self.composeTargetItemData)
  self:UpdateComposeMaterialCells()
  self:UpdateRefreshAttrList(self.composeTargetItemData.personalArtifactData, isSameTarget)
  self.safeCheckTog.gameObject:SetActive(not artifactIns:IsInPreview() and self.composeTargetItemData.personalArtifactData:GetAdvancedAttrCount(GameConfig.PersonalArtifact.RemouldTenCondition) >= 1)
  self:UpdateSafelyBtn()
  self:UpdateRefreshCost()
end

function PersonalArtifactFunctionView:UpdateComposeMaterialCells()
  self.fragmentLimited = true
  local materialData, cell = self:_GetMaterialDataFromTargetFormulaData()
  for i = 1, #materialData do
    cell = self.materialCells[i]
    local staticId = materialData[i][1]
    if type(cell.data) == "table" then
      cell.data:ResetData("material", staticId)
      cell:SetData(cell.data)
    else
      cell:SetData(ItemData.new("material", staticId))
    end
    local fragmentActive = self.composeTargetItemData:CheckFragmentActive(staticId)
    self.materialCells[i]:SetIconGrey(not fragmentActive)
    if fragmentActive then
      self.fragmentLimited = false
    end
  end
  for i = #materialData + 1, 5 do
    self.materialCells[i]:SetData(BagItemEmptyType.Empty)
  end
  self:UpdateMainCtrl()
end

function PersonalArtifactFunctionView:UpdateMainCtrl()
  local inPreview = artifactIns:IsInPreview()
  if self.fragmentLimited or inPreview then
    self.costRoot.alpha, self.hCostRoot.alpha = _limited_alpha, _limited_alpha
    self.refreshBtnSp.spriteName, self.HRefreshBtnSp.spriteName = _OptionBtn.GraySp, _OptionBtn.GraySp
    self.refreshBtnLab.effectColor, self.HRefreshBtnLab.effectColor = _OptionBtn.Gray, _OptionBtn.Gray
  else
    self.costRoot.alpha, self.hCostRoot.alpha = 1, 1
    self.refreshBtnSp.spriteName, self.HRefreshBtnSp.spriteName = _OptionBtn.NormalSp, _OptionBtn.NormalSp
    self.refreshBtnLab.effectColor, self.HRefreshBtnLab.effectColor = _OptionBtn.Normal, _OptionBtn.Normal
  end
end

function PersonalArtifactFunctionView:UpdateFormulaList(first)
  self.formulaListCtl:ResetDatas(artifactIns:GetAllFormulaItems())
  self.formulaListCtl:ResetPosition()
  if not first then
    return
  end
  local targetCell
  local cells = self.formulaListCells
  local isPreview = PersonalArtifactProxy.Instance:IsInPreview()
  for i = 1, #cells do
    if isPreview then
      if cells[i]:IsEquipSavedFormularCell() then
        targetCell = cells[i]
        break
      end
    elseif cells[i]:IsEquipedFormularCell() then
      targetCell = cells[i]
      break
    end
  end
  if targetCell then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.boardPanel.cachedTransform, targetCell.gameObject.transform)
    local offset = self.boardPanel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.formulaListCtl.scrollView:MoveRelative(offset)
    self:OnClickFormula(targetCell)
  elseif #self.formulaListCells > 0 then
    self:OnClickFormula(self.formulaListCells[1])
  end
end

function PersonalArtifactFunctionView:CheckComposeMaterials()
  local materialData, rslt = self:_GetMaterialDataFromTargetFormulaData(), true
  for i = 1, #materialData do
    rslt = rslt and self:_CheckComposeMaterial(i)
  end
  return rslt
end

function PersonalArtifactFunctionView:_CheckComposeMaterial(index)
  return PersonalArtifactComposeView._CheckMaterial(self, index)
end

function PersonalArtifactFunctionView:CheckComposeCostItem()
  if not self.composeCostItemId then
    LogUtility.Warning("Cannot get id of cost item while checking")
    return false
  end
  return shopIns:GetItemNum(self.composeCostItemId) >= (self.composeCost or math.huge)
end

function PersonalArtifactFunctionView:TryPlayComposeEffectThenCall(func)
  if self.state ~= PersonalArtifactFunctionState.Compose then
    return
  end
  self:SetButtonsEnabled(false)
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.PersonalArtifactCompose) then
    func(self)
  else
    tickManager:CreateOnceDelayTick(4000, func, self)
  end
end

function PersonalArtifactFunctionView:_GetMaterialDataFromTargetFormulaData()
  return self.targetFormulaStaticData and self.targetFormulaStaticData.CostFlagments
end

function PersonalArtifactFunctionView:_GetCostDataFromTargetFormulaData()
  return PersonalArtifactComposeView._GetCostDataFromTargetFormulaData(self)
end

function PersonalArtifactFunctionView:_GetMaterialsByIndexOfTargetFormulaData(index)
  return PersonalArtifactComposeView._GetMaterialsByIndexOfTargetFormulaData(self, index)
end

function PersonalArtifactFunctionView:ShowComposeItemTip(data)
  if not self.fakeItemData then
    self.fakeItemData = ItemData.new()
  end
  if type(data) == "number" then
    self.fakeItemData:ResetData("TipData", data)
  elseif type(data) == "table" then
    self.fakeItemData:ResetData("TipData", data.staticData.id)
  else
    TipManager.Instance:CloseItemTip()
    return
  end
  tryAddFakeDataToItemData(self.fakeItemData)
  local tip = self:ShowItemTip(self.fakeItemData, nil, NGUIUtil.AnchorSide.Right, -100)
  for i = 1, #self.materialCells do
    tip:AddIgnoreBounds(self.materialCells[i].gameObject)
  end
  tip:AddIgnoreBounds(self.targetCell.gameObject)
  return tip
end

function PersonalArtifactFunctionView:UpdateRefreshCostWidgets()
  if self.state ~= PersonalArtifactFunctionState.Compose then
    return
  end
  local lackCost = not self:CheckRefreshCostItem()
  local lackHCost = not self:CheckRefreshHCostItem()
  local inPreview = artifactIns:IsInPreview()
  self.refreshCostLabel.color = lackCost and ColorUtil.Red or costLabelColor
  self.refreshCostAddBtn:SetActive(lackCost and not inPreview)
  self.refreshHCostLabel.color = lackHCost and ColorUtil.Red or costLabelColor
  self.refreshHCostAddBtn:SetActive(lackHCost and not inPreview)
end

function PersonalArtifactFunctionView:UpdateRefreshCost()
  self.refreshCostLabel.text = _defaultCost
  self.refreshHCostLabel.text = _defaultCost
  self.refreshCostAddBtn:SetActive(false)
  self.refreshHCostAddBtn:SetActive(false)
  local sData = self.targetFormulaStaticData
  if not sData then
    return
  end
  local data, HData
  if self:CheckSafeToggleEnabled() then
    data = sData.RefreshSafeCost[1]
    HData = sData.RefreshCostAdvanceTen[1]
  else
    data = sData.RefreshCost[1]
    HData = sData.RefreshCostAdvance[1]
  end
  self.refreshCostItemId, self.refreshCost = data[1], data[2]
  self.refreshHCostItemId, self.refreshHCost = HData[1], HData[2]
  if self.refreshCostItemId then
    IconManager:SetItemIcon(Table_Item[self.refreshCostItemId].Icon, self.refreshCostItemSp)
    self.refreshCostItemSp:MakePixelPerfect()
  end
  local _, myCostCount = self:CheckRefreshCostItem()
  self.refreshCostLabel.text = string.format("%s/%s", myCostCount, self.refreshCost)
  if self.refreshHCostItemId then
    IconManager:SetItemIcon(Table_Item[self.refreshHCostItemId].Icon, self.refreshHCostItemSp)
    self.refreshHCostItemSp:MakePixelPerfect()
  end
  local _, myHCostCount = self:CheckRefreshHCostItem()
  self.refreshHCostLabel.text = string.format("%s/%s", myHCostCount, self.refreshHCost)
  self:UpdateRefreshCostWidgets()
end

local tempAttrData = {isUniqueEffect = true}

function PersonalArtifactFunctionView:UpdateRefreshAttrList(paData, isSameTarget)
  local datas, isShowRefreshAnim = ReusableTable.CreateArray()
  if paData then
    local attrs, isToSave = paData.attrs, next(paData.candidateAttrs) ~= nil
    if isToSave then
      if not paData:HasBetterAttrToSave() then
        helplog("There is no better attr for this personal artifact. Cancel saving.")
        MsgManager.ShowMsgByID(43107)
        self.cancelSavingFunc()
        self:SetButtonsEnabled(false)
        self.buttonsDisabledWithoutBetterRefreshAttr = true
        self:CacheAttrs(paData, true)
        isSameTarget = false
      end
    elseif self.buttonsDisabledWithoutBetterRefreshAttr then
      self:SetButtonsEnabled(true)
      self.buttonsDisabledWithoutBetterRefreshAttr = nil
    end
    self:SetRefreshSaveMode(isToSave)
    for i = 1, #attrs do
      _ArrayPushBack(datas, attrs[i])
    end
    if paData.percentage then
      tempAttrData.personalArtifactData = paData
      _ArrayPushBack(datas, tempAttrData)
    end
    if isSameTarget then
      isShowRefreshAnim = not self:CheckRefreshAttrsSameFromCache(attrs) and self.nameOfLastEventButton ~= "CancelBtn"
    else
      self:CacheAttrs(paData)
    end
  else
    self:SetRefreshSaveMode(false)
    LogUtility.Warning("You're trying to refresh a personal artifact without personalArtifactData!!!")
    _TableClear(self.cachedTargetAttrMap)
  end
  self.refreshAttrListCtl:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
  for _, cell in pairs(self.refreshAttrListCells) do
    if self.isRefreshSaveMode then
      cell:TryCompareAttributes(paData.candidateAttrs)
    elseif isShowRefreshAnim and cell.data and not cell.data.isUniqueEffect then
      self:SetButtonsEnabled(false)
      tickManager:ClearTick(self, buttonsTimeTickId)
      cell:TryShowRefreshAnim(self.cachedTargetAttrMap, function(self)
        self:CacheAttrs(self.composeTargetItemData.personalArtifactData)
        tickManager:CreateOnceDelayTick(100, function(owner)
          owner:SetButtonsEnabled(true)
        end, self, buttonsTimeTickId)
      end, self)
    end
  end
end

function PersonalArtifactFunctionView:CheckRefreshCostItem()
  if not self.refreshCostItemId then
    LogUtility.Warning("Cannot get id of cost item while checking")
    return false
  end
  return _checkRefreshItem(self.refreshCostItemId, self.refreshCost)
end

function PersonalArtifactFunctionView:CheckRefreshHCostItem()
  if not self.refreshHCostItemId then
    LogUtility.Warning("Cannot get id of Hcost item while checking")
    return false
  end
  return _checkRefreshItem(self.refreshHCostItemId, self.refreshHCost)
end

function PersonalArtifactFunctionView:CheckRefresh(isH)
  if not self.composeTargetItemData then
    MsgManager.FloatMsg("", ZhString.PersonalArtifact_NoRefreshTargetTip)
    return false
  end
  local checkCostItemFunc = isH and self.CheckRefreshHCostItem or self.CheckRefreshCostItem
  local costItemId = isH and self.refreshHCostItemId or self.refreshCostItemId
  if not checkCostItemFunc(self) then
    MsgManager.ShowMsgByIDTable(25418, costItemId and Table_Item[costItemId].NameZh)
    return false
  end
  return true
end

function PersonalArtifactFunctionView:CheckHasBetterRefreshAttrToSave()
  if not self.isRefreshSaveMode or not self.composeTargetItemData then
    return
  end
  local paData = self.composeTargetItemData.personalArtifactData
  if not paData then
    return
  end
  return paData:HasBetterAttrToSave()
end

function PersonalArtifactFunctionView:CheckRefreshAttrsAllMax()
  local paData = self.composeTargetItemData and self.composeTargetItemData.personalArtifactData
  if not paData then
    return
  end
  return paData:AreAttrsAllMax()
end

function PersonalArtifactFunctionView:SetRefreshSaveMode(isSave)
  isSave = isSave and true or false
  self.isRefreshSaveMode = isSave
  self.refreshBtnParent:SetActive(not isSave)
  self.saveBtnParent:SetActive(isSave)
end

function PersonalArtifactFunctionView:CheckRefreshAttrsSameFromCache(attrs)
  return PersonalArtifactRefreshView.CheckAttrsSameFromCache(self, attrs)
end

function PersonalArtifactFunctionView:CacheAttrs(personalArtifactData, isCandidate)
  return PersonalArtifactRefreshView.CacheAttrs(self, personalArtifactData, isCandidate)
end

function PersonalArtifactFunctionView:_PutIn(item, count)
  local guid = item.id
  if self.decomposeItems[guid] then
    self.decomposeItems[guid].num = self.decomposeItems[guid].num + count
  else
    self.decomposeItems[guid] = item:Clone()
    self.decomposeItems[guid].num = count
  end
  self:UpdateDecompose()
end

function PersonalArtifactFunctionView:UpdateDecompose()
  if not self.decomposeResultData then
    self.decomposeResultData = {
      ItemData.new("DecomposeProduct", self.decomposeProductId)
    }
  end
  local totalCount, t, quality, count = 0
  for _, item in pairs(self.decomposeItems) do
    t, quality = item.staticData.Type, item.staticData.Quality
    count = self.decomposeProductCfg[t] and self.decomposeProductCfg[t][quality] or 0
    totalCount = totalCount + count * item.num
  end
  self.decomposeResultData[1]:SetItemNum(totalCount)
  local chooseData, totalCost = self:GetDecomposeItems()
  local hasChooseData = 0 < #chooseData
  self.unavailableDecomposeBtn:SetActive(not hasChooseData)
  self.decomposeBtn:SetActive(hasChooseData)
  self.decomposeListContainer:SetActive(hasChooseData)
  self.decomposeTipLabelGO:SetActive(not hasChooseData)
  self.decomposeResultCtl:ResetDatas(self.decomposeResultData)
  self.decomposeListCtl:ResetDatas(chooseData)
  self:UpdateDecomposeChooseBoard()
  self.decomposeCostLabel.text = self:CheckDecomposeCost() and tostring(totalCost) or string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, totalCost)
end

function PersonalArtifactFunctionView:GetCurrentDecomposeItems()
  local result = {}
  addDecomposeItems(result, self.decomposeItems, BagProxy.BagType.PersonalArtifact)
  addDecomposeItems(result, self.decomposeItems, BagProxy.BagType.PersonalArtifactFragment)
  table.sort(result, comparer)
  return result
end

function PersonalArtifactFunctionView:UpdateDecomposeChooseBoard()
  function self.boardPanel.onClipMove(panel)
    self.decomposeChooseCtl.wrap:WrapContent()
  end
  
  local items = self:GetCurrentDecomposeItems()
  self.decomposeChooseCtl:ResetDatas(items, true)
  self.decomposeNoneTip:SetActive(#items == 0)
end

local tempDecomposeItems = {}

function PersonalArtifactFunctionView:GetDecomposeItems()
  _TableClear(tempDecomposeItems)
  local cost = 0
  for _, item in pairs(self.decomposeItems) do
    _ArrayPushBack(tempDecomposeItems, item)
    cost = cost + self:GetDecomposeCost(item)
  end
  return tempDecomposeItems, cost
end

function PersonalArtifactFunctionView:GetDecomposeCost(item)
  if not item then
    return 0
  end
  return self.decomposePerCost * item.num
end

function PersonalArtifactFunctionView:CheckDecomposeCost(showTip)
  local _, totalCost = self:GetDecomposeItems()
  if totalCost and totalCost > shopIns:GetItemNum(self.decomposeCostItemId) then
    if showTip then
      if self.decomposeCostItemId == GameConfig.MoneyId.Zeny then
        MsgManager.ShowMsgByID(1)
      else
        MsgManager.ShowMsgByIDTable(25418, Table_Item[self.decomposeCostItemId].NameZh)
      end
    end
    return false
  end
  return true
end

function PersonalArtifactFunctionView:GetMaxDecomposeCount()
  return PersonalArtifactDecomposeView.GetMaxDeComposeCount()
end

function PersonalArtifactFunctionView:SetItemToExchange(data)
  self.exchangeMainLabel.text = data == nil and ZhString.PersonalArtifact_ExchangeTipWithoutTarget or ZhString.PersonalArtifact_ExchangeTipWithTarget
  local oldTargetFragmentStaticId = self.exchangeTargetFragmentStaticId
  self:SetExchangeTargetCellData(data)
  if not data then
    return
  end
  if self.exchangeTargetFragmentStaticId ~= oldTargetFragmentStaticId then
    self:OnPersonalArtifactUpdate()
  end
end

function PersonalArtifactFunctionView:SetExchangeTargetCellData(data)
  self.exchangeTargetCellItemPart:SetActive(data ~= nil)
  self.exchangeTargetFragmentStaticId = data and data.staticData.id
  if not self.exchangeTargetFragmentStaticId then
    return
  end
  self.exchangeTargetCell:SetData(data)
  self.targetQualityFragmentIds = artifactIns:GetFragmentItemIdsByQuality(data.staticData.Quality)
end

function PersonalArtifactFunctionView:UpdateExchangeMaterialSelectList(resetAll)
  if not self.ChooseBoard.activeInHierarchy then
    return
  end
  if not self.exchangeTargetFragmentStaticId then
    LogUtility.Error("Cannot get materials when target fragment is nil")
    self.ChooseBoard:SetActive(false)
    return
  end
  
  function self.boardPanel.onClipMove(panel)
    self.exchangeMaterialSelectCtrl.wrap:WrapContent()
  end
  
  if resetAll or not self.exchangeMaterialSelectDatas then
    self.exchangeMaterialSelectDatas = {}
    local sId, fakeItem
    for i = 1, #self.targetQualityFragmentIds do
      sId = self.targetQualityFragmentIds[i]
      fakeItem = ItemData.new(sId, sId)
      fakeItem:SetItemNum(PersonalArtifactProxy.GetFragmentItemNumByStaticId(sId))
      _ArrayPushBack(self.exchangeMaterialSelectDatas, fakeItem)
    end
    table.sort(self.exchangeMaterialSelectDatas, materialSelectComparer)
  end
  for _, item in pairs(self.exchangeMaterialSelectDatas) do
    item:SetItemNum(self:GetUnselectedExchangeCountByStaticId(item.id))
  end
  self.exchangeMaterialSelectCtrl:ResetDatas(self.exchangeMaterialSelectDatas, resetAll)
end

function PersonalArtifactFunctionView:UpdateSelectedExchangeMaterial()
  TipManager.Instance:CloseItemTip()
  local tempArr = ReusableTable.CreateArray()
  _ArrayShallowCopy(tempArr, self.selectedExchangeMaterialData)
  for i = #self.selectedExchangeMaterialData + 1, self.maxExchangeMaterialCount do
    _ArrayPushBack(tempArr, BagItemEmptyType.Empty)
  end
  self.exchangeMaterialListCtrl:ResetDatas(tempArr)
  for _, cell in pairs(self.exchangeMaterialListCtrl:GetCells()) do
    if cell.data ~= BagItemEmptyType.Empty then
      cell:TrySetShowDeselect(true)
    end
  end
  ReusableTable.DestroyAndClearArray(tempArr)
  self:CheckExchangeReady()
end

function PersonalArtifactFunctionView:CheckExchangeReady()
  local isReady = #self.selectedExchangeMaterialData == self.maxExchangeMaterialCount
  self:SetExchangeBtnActive(isReady)
  self:SetExchangeCost(GameConfig.PersonalArtifact.ExchangeCostItemId, isReady and GameConfig.PersonalArtifact.ExchangeCostItemCount or 0)
end

function PersonalArtifactFunctionView:TryExchange()
  if not self.clickButtonEnabled then
    return
  end
  if not self.isExchangeBtnActive then
    return
  end
  if not self.exchangeTargetFragmentStaticId then
    MsgManager.ShowMsgByID(41332)
    return
  end
  if not self:CheckExchangeCostItem() then
    MsgManager.ShowMsgByIDTable(25418, Table_Item[self.exchangeCostItemId].NameZh)
    return
  end
  if bagIns:CheckBagIsFull(BagProxy.BagType.MainBag) then
    MsgManager.ShowMsgByID(989)
    return
  end
  self:TryPlayExchangeEffectThenCall(self._Exchange)
end

function PersonalArtifactFunctionView:_Exchange()
  PersonalArtifactProxy.CallExchange(self.exchangeTargetFragmentStaticId, self.selectedExchangeMaterialData)
  self:SetButtonsEnabled(true)
end

function PersonalArtifactFunctionView:TryPlayExchangeEffectThenCall(func)
  self:SetButtonsEnabled(false)
  local delayedTime = 1000
  if self.exchangeForeEffect then
    self.exchangeForeEffect:Stop()
  end
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.PersonalArtifactExchange) then
    func(self)
  else
    local actionName = "ronghe_2"
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.exchangeEffContainer, true, function(obj, args, assetEffect)
      self.exchangeForeEffect = assetEffect
      self.exchangeForeEffect:ResetAction(actionName, 0, true)
    end)
    if self.exchangeBackEffect then
      self.exchangeBackEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    tickManager:CreateOnceDelayTick(delayedTime, func, self, 1)
  end
  self:SetExchangeBtnActive(false)
  tickManager:CreateOnceDelayTick(delayedTime + 800, self.CheckExchangeReady, self, 2)
end

function PersonalArtifactFunctionView:SetExchangeCost(itemId, cost)
  if type(itemId) ~= "number" or type(cost) ~= "number" then
    LogUtility.Error("Invalid argument while calling SetCost!")
    return
  end
  self.exchangeCostItemId = itemId
  self.exchangeCost = cost
  IconManager:SetItemIcon(Table_Item[itemId].Icon, self.exchangeCostSp)
  self.exchangeCostLabel.text = StringUtil.NumThousandFormat(cost)
  self:UpdateExchangeCostLabelColor()
end

function PersonalArtifactFunctionView:UpdateExchangeCostLabelColor()
  self.exchangeCostLabel.color = not self:CheckExchangeCostItem() and ColorUtil.Red or costLabelColor
end

function PersonalArtifactFunctionView:CheckExchangeCostItem()
  if not self.exchangeCostItemId then
    LogUtility.Warning("Cannot get id of cost item while checking")
    return
  end
  return shopIns:GetItemNum(self.exchangeCostItemId) >= (self.exchangeCost or math.huge)
end

function PersonalArtifactFunctionView:GetSelectedExchangeCountByStaticId(sId)
  local count = 0
  for _, selected in pairs(self.selectedExchangeMaterialData) do
    if selected.staticData.id == sId then
      count = count + 1
    end
  end
  return count
end

function PersonalArtifactFunctionView:GetUnselectedExchangeCountByStaticId(sId)
  return PersonalArtifactProxy.GetFragmentItemNumByStaticId(sId) - self:GetSelectedExchangeCountByStaticId(sId)
end

function PersonalArtifactFunctionView:SetExchangeBtnActive(isActive)
  return PersonalArtifactExchangeView.SetExchangeBtnActive(self, isActive)
end

local tipOffset = {0, 0}

function PersonalArtifactFunctionView:ShowItemTip(itemData, stick, side, offsetX, offsetY, funcConfig)
  self.tipData.itemdata = itemData
  self.tipData.funcConfig = funcConfig or _EmptyTable
  stick = stick or self.normalStick
  side = side or NGUIUtil.AnchorSide.Left
  tipOffset[1] = offsetX or 0
  tipOffset[2] = offsetY or 0
  return PersonalArtifactFunctionView.super.ShowItemTip(self, self.tipData, stick, side, tipOffset)
end

function PersonalArtifactFunctionView:SetButtonsEnabled(enabled)
  self.clickButtonEnabled = enabled and true or false
  self.tabCollider:SetActive(not self.clickButtonEnabled)
end

function PersonalArtifactFunctionView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    if not self.clickButtonEnabled then
      return
    end
    self:CloseSelf()
  end)
end

function PersonalArtifactFunctionView:AddButtonEvent(name, event, hideType)
  PersonalArtifactFunctionView.super.AddButtonEvent(self, name, function()
    self.nameOfLastEventButton = name
    event()
  end, hideType)
end
