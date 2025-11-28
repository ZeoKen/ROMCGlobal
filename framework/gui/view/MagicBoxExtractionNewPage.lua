MagicBoxExtractionNewPage = class("MagicBoxExtractionNewPage", SubView)
autoImport("ExtractionSlotCell")
autoImport("EquipChooseBord")
autoImport("ExtractionData")
autoImport("ExtractionAttrNewCell")
autoImport("ExtractionCostCell")
autoImport("EquipNewChooseBord")
autoImport("ExtractionCostData")
local prefabPath = ResourcePathHelper.UIView("Extraction/MagicBoxExtractionNewPage")
local BagProxy = BagProxy.Instance
local EquipExtractionConfig = GameConfig.EquipExtraction
local ExtractionCostItem = EquipExtractionConfig.ExtractionCostItem
local ExtraCost = EquipExtractionConfig.ExtraCost
local RefreshCost = EquipExtractionConfig.RefreshCost
local black = LuaColor.New(0.08627450980392157, 0.08627450980392157, 0.08627450980392157)
local red = LuaColor.New(0.8117647058823529, 0.10980392156862745, 0.058823529411764705)
local grey = LuaColor.New(0.4470588235294118, 0.4470588235294118, 0.4470588235294118)
local orange = LuaColor.New(0.6196078431372549, 0.27450980392156865, 0)
local mine = 0
local discount = 1
local gridid, itemid

function MagicBoxExtractionNewPage:Init()
  self:LoadSubView()
  self:InitUI()
  self:AddListener()
  self.lotteryName = Table_Item[151].NameZh
  self.iconName = Table_Item[ExtractionCostItem].NameZh
  self:ShowTab(1, true)
end

function MagicBoxExtractionNewPage:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end

function MagicBoxExtractionNewPage:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function MagicBoxExtractionNewPage:OnEnter()
  MagicBoxExtractionNewPage.super.OnEnter(self)
  ServiceNUserProxy.Instance:CallExtractionQueryUserCmd()
  HappyShopProxy.Instance:InitShop(nil, 1, 650)
end

function MagicBoxExtractionNewPage:OnExit()
  self:CancelLockCall()
  if self.slotGridCtrl then
    self.slotGridCtrl:Destroy()
  end
  for i = 1, 3 do
    if self.halo[i] then
      PictureManager.Instance:UnLoadUI("equip_bg_halo", self.halo[i])
    end
  end
  PictureManager.Instance:UnLoadUI("magicbox_bg_matrix", self.texture)
  MagicBoxExtractionNewPage.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end

function MagicBoxExtractionNewPage:LoadSubView()
  local container = self:FindGO("MagicBoxExtractionPage")
  local obj = self:LoadPreferb_ByFullPath(prefabPath, container, true)
  obj.name = "MagicBoxExtractionNewPage"
end

function MagicBoxExtractionNewPage:InitUI()
  self.scrollView = self:FindGO("SlotScrollview"):GetComponent(UIScrollView)
  self.slotGrid = self:FindGO("slotGrid"):GetComponent(UIGrid)
  self.slotGridCtrl = UIGridListCtrl.new(self.slotGrid, ExtractionSlotCell, "ExtractionSlotCell")
  self.slotGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickSlotCell, self)
  local chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord.new(chooseContainer, function()
    return self:GetValidEquips()
  end)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.upgradeEquipChooseBord = EquipExtractionCountChooseBord.new(chooseContainer)
  self.upgradeEquipChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self.upgradeEquipChooseBord:Hide()
  self.texture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI("magicbox_bg_matrix", self.texture)
  self.effect = self:FindGO("effect")
  self:PlayUIEffect(EffectMap.UI.Eff_53EquipStreng, self.effect, false)
  self.halo = {}
  for i = 1, 3 do
    self.halo[i] = self:FindComponent("halo" .. i, UITexture)
    PictureManager.Instance:SetUI("equip_bg_halo", self.halo[i])
  end
  self.activeBtnGO = self:FindGO("ActiveBtn")
  self:AddClickEvent(self.activeBtnGO, function(go)
    self:CallActive()
  end)
  self.activeBtnLabel = self:FindComponent("Label", UILabel, self.activeBtnGO)
  self.emptyBtn = self:FindGO("EmptyBtn")
  self:AddClickEvent(self.emptyBtn, function(go)
    self:CallEmpty()
  end)
  self:AddClickEvent(self:FindGO("CloseButton"), function(go)
    self:sendNotification(MagicBoxEvent.CloseContainerview)
  end)
  local helpBtn = self:FindGO("HelpBtn")
  local penelID = PanelConfig.MagicBoxPanel.id
  self:RegistShowGeneralHelpByHelpID(penelID, helpBtn)
  local infoContainer = self:FindGO("InfoContainer")
  self.chooseItemIcon = self:FindComponent("chooseItem", UISprite, infoContainer)
  self:AddClickEvent(self.chooseItemIcon.gameObject, function(go)
    if not self.currentCell then
      return
    end
    if self.currentCell.data.itemid == 0 then
      self:ShowEquipBord()
    end
  end)
  self.lvTip = self:FindComponent("lvTip", UILabel, infoContainer)
  self.equipName = self:FindComponent("equipName", UILabel, infoContainer)
  self.hideContainer = self:FindGO("hideContainer", infoContainer)
  local tip1 = self:FindComponent("tip1", UILabel, self.hideContainer)
  local tip2 = self:FindComponent("tip2", UILabel, self.hideContainer)
  tip1.text = ZhString.MagicBox_Tip1
  tip2.text = ZhString.MagicBox_Tip2
  self.addBtn = self:FindGO("AddBtn", self.hideContainer)
  self:AddClickEvent(self.addBtn, function(go)
    if not self.currentCell then
      return
    end
    self:ShowEquipBord()
  end)
  self.resultContainer = self:FindComponent("ResultContainer", UIWidget, infoContainer)
  self.resultContainer.alpha = 0
  self.resultSuccessGO = self:FindGO("ResultSucc", self.resultContainer.gameObject)
  self.resultFailGO = self:FindGO("ResultFail", self.resultContainer.gameObject)
  self.resultTween = self.resultContainer.gameObject:GetComponent(UITweener)
  local tabGO = self:FindGO("Tabs")
  self.tabs = {}
  local extractionTabGO = self:FindGO("ExtractionTab", tabGO)
  self:AddClickEvent(extractionTabGO, function()
    self:ShowTab(1)
  end)
  self.tabs[1] = {
    rootGO = extractionTabGO,
    normalGO = self:FindGO("Normal", extractionTabGO),
    selectedGO = self:FindGO("Selected", extractionTabGO)
  }
  self.isUpgradeForbid = GameConfig.SystemForbid and GameConfig.SystemForbid.ExtractLevelUp
  local upgradeTabGO = self:FindGO("UpgradeTab", tabGO)
  if self.isUpgradeForbid then
    upgradeTabGO:SetActive(false)
    LuaGameObject.SetLocalPositionGO(extractionTabGO, 0, 0, 0)
  else
    upgradeTabGO:SetActive(true)
    LuaGameObject.SetLocalPositionGO(extractionTabGO, -77.2, 0, 0)
    self:AddClickEvent(upgradeTabGO, function()
      self:ShowTab(2)
    end)
  end
  self.tabs[2] = {
    rootGO = upgradeTabGO,
    normalGO = self:FindGO("Normal", upgradeTabGO),
    selectedGO = self:FindGO("Selected", upgradeTabGO)
  }
  self.tabPanels = {}
  local tabPanelRootGO = self:FindGO("TabPanels", infoContainer)
  local exPanelGO = self:FindGO("ExtractionPanel", tabPanelRootGO)
  self.tabPanels[1] = exPanelGO
  self.exCostCtrl = ListCtrl.new(self:FindComponent("CostContainer", UIGrid, exPanelGO), ExtractionCostCell, "Extraction/ExtractionCostCell")
  self.exCostCtrl:SetNoScrollView(true)
  self.exCostCtrl:AddEventListener(UICellEvent.OnCellClicked, self.OnUpgradeItemClicked, self)
  self.noRefreshTipGO = self:FindGO("NoRefreshTip", exPanelGO)
  local noRefreshTipLabel = self:FindComponent("Label", UILabel, self.noRefreshTipGO)
  noRefreshTipLabel.text = ZhString.MagicBox_NoRefreshTip
  self.exCurrentTip = self:FindComponent("currentTip", UILabel, exPanelGO)
  self.exInfoTable = self:FindComponent("Table", UITable, exPanelGO)
  self.exInfoTableCtrl = UIGridListCtrl.new(self.exInfoTable, ExtractionAttrNewCell, "Extraction/ExtractionAttrNewCell")
  self.extractBtnGO = self:FindGO("ExtractBtn", exPanelGO)
  self.extractButton = self.extractBtnGO:GetComponent(UIButton)
  self:AddClickEvent(self.extractBtnGO, function(go)
    local single = self.currentCell and self.currentCell.data
    if single and single.itemStaticData then
      self:CallRefresh()
    else
      FunctionSecurity.Me():EquipExtraction(self.CallExtract, self)
    end
    self:LockCall()
  end)
  self.extractBtnLabel = self:FindComponent("Label", UILabel, self.extractBtnGO)
  local upgradePanelGO = self:FindGO("UpgradePanel", tabPanelRootGO)
  self.tabPanels[2] = upgradePanelGO
  self.upgradeBtnGO = self:FindGO("UpgradeBtn", upgradePanelGO)
  self:AddClickEvent(self.upgradeBtnGO, function()
    self:CallUpgrade()
  end)
  self.upTipGO = self:FindGO("Tip", upgradePanelGO)
  self.upFromTip = self:FindComponent("FromLab", UILabel, self.upTipGO)
  self.upToTip = self:FindComponent("ToLab", UILabel, self.upTipGO)
  self.upMaxLevelGO = self:FindGO("MaxLevelReached", upgradePanelGO)
  self.upMaxLevelTip = self:FindComponent("MaxLab", UILabel, self.upMaxLevelGO)
  self.upCostCtrl = ListCtrl.new(self:FindComponent("UpgradeCostContainer", UIGrid, upgradePanelGO), ExtractionCostCell, "Extraction/ExtractionCostCell")
  self.upCostCtrl:SetNoScrollView(true)
  self.upCostCtrl:AddEventListener(UICellEvent.OnCellClicked, self.OnUpgradeItemClicked, self)
end

function MagicBoxExtractionNewPage:AddListener()
  self:AddListenEvt(ServiceEvent.NUserExtractionQueryUserCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.NUserExtractionOperateUserCmd, self.OperateResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionActiveUserCmd, self.ActiveResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionRemoveUserCmd, self.RemoveResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionGridBuyUserCmd, self.PurchaseResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionRefreshUserCmd, self.RefreshResult)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleUpdateCurrentCost)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleUpdateCurrentCost)
end

function MagicBoxExtractionNewPage:ShowTab(tabIndex, force)
  if tabIndex ~= 1 then
    local data = self.currentCell and self.currentCell.data
    if not (data and data.itemid) or not (data.itemid > 0) then
      return
    end
    if GameConfig.SystemForbid and GameConfig.SystemForbid.ExtractLevelUp then
      tabIndex = 1
    end
  end
  if self.selectedTabIndex ~= tabIndex or force then
    self.selectedTabIndex = tabIndex
    for i, tab in ipairs(self.tabs) do
      if i == tabIndex then
        tab.normalGO:SetActive(false)
        tab.selectedGO:SetActive(true)
      else
        tab.normalGO:SetActive(true)
        tab.selectedGO:SetActive(false)
      end
    end
    for i, panel in ipairs(self.tabPanels) do
      panel:SetActive(i == tabIndex)
    end
    self:UpdateCurrentPanel()
  end
end

function MagicBoxExtractionNewPage:UpdateCurrentPanel()
  if self.selectedTabIndex == 2 then
    self:UpdateUpgradePanel()
  else
    self:UpdateExtractionPanel()
  end
end

function MagicBoxExtractionNewPage:UpdateExtractionPanel()
  local single = self.currentCell and self.currentCell.data
  if not single or single.itemid == 0 then
    self.noRefreshTipGO:SetActive(false)
    self.extractBtnGO:SetActive(true)
    self.extractBtnLabel.text = ZhString.MagicBox_Extract
    self.extractButton.isEnabled = false
    self.extractBtnLabel.effectColor = grey
    self:UpdateBuffInfo()
    self.showExtractionCost = false
    self.exCurrentTip.text = ""
  else
    self.extractButton.isEnabled = true
    self.extractBtnLabel.effectColor = orange
    self:UpdateBuffInfo(single.itemid)
    local refreshType = Table_EquipExtraction[single.itemid].RefreshType
    if refreshType == 1 and single.refinelv ~= 0 then
      self.exCurrentTip.text = string.format(ZhString.MagicBox_RefreshTip, single.refinelv, single.extractionLv)
    else
      self.exCurrentTip.text = ""
    end
    if refreshType == 1 and single.refinelv > single.extractionLv then
      self.extractBtnLabel.text = ZhString.MagicBox_Refresh
      self.noRefreshTipGO:SetActive(false)
      self.extractBtnGO:SetActive(true)
      self.showExtractionCost = true
    else
      self.noRefreshTipGO:SetActive(true)
      self.extractBtnGO:SetActive(false)
      self.showExtractionCost = false
    end
  end
  self:UpdateExtractionCost(true)
end

function MagicBoxExtractionNewPage:UpdateBuffInfo(equipID)
  local contextlabel = {}
  if equipID and 0 < equipID then
    local str = Table_EquipExtraction[equipID].Dsc
    local bufferStrs = string.split(str, "\n")
    for j = 1, #bufferStrs do
      table.insert(contextlabel, bufferStrs[j])
    end
  end
  self.exInfoTableCtrl:ResetDatas(contextlabel)
end

function MagicBoxExtractionNewPage:UpdateUpgradePanel()
  local single = self.currentCell and self.currentCell.data
  if not single or single.itemid == 0 then
    self.upTipGO:SetActive(false)
    self.upMaxLevelGO:SetActive(false)
    self.upgradeBtnGO:SetActive(false)
    self.showUpgradeCost = false
  else
    local refreshType = Table_EquipExtraction[single.itemid].RefreshType
    local maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(Table_Item[single.itemid]) or 0
    local curRefineLv = single.refinelv or 0
    if refreshType == 1 and maxRefineLv > curRefineLv then
      self.upMaxLevelGO:SetActive(false)
      self.upgradeBtnGO:SetActive(true)
      self.showUpgradeCost = true
      self.upTipGO:SetActive(true)
      self.upFromTip.text = string.format(ZhString.MagicBox_UpgradeLevel, curRefineLv)
      self.upToTip.text = string.format("+%d", curRefineLv + 1)
    else
      if refreshType ~= 1 then
        maxRefineLv = "?"
      end
      self.upMaxLevelGO:SetActive(true)
      self.upMaxLevelTip.text = string.format(ZhString.MagicBox_UpgradeLevel, maxRefineLv)
      self.upTipGO:SetActive(false)
      self.upgradeBtnGO:SetActive(false)
      self.showUpgradeCost = false
    end
  end
  self:UpdateUpgradeCost()
end

function MagicBoxExtractionNewPage:ClickSlotCell(cell)
  if not cell then
    return
  end
  if not cell.data.got then
    if BranchMgr.IsJapan() then
      OverseaHostHelper:ExtractionSlotConfirm({
        costid = EquipExtractionConfig.GridBuyCostItem,
        costnum = EquipExtractionConfig.GridBuyCostCount
      })
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ExtractionSlotPopUp,
        viewdata = {
          costid = EquipExtractionConfig.GridBuyCostItem,
          costnum = EquipExtractionConfig.GridBuyCostCount
        }
      })
    end
    return
  end
  self.currentCell = cell
  local cells = self.slotGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cells[i].data.gridid == cell.data.gridid)
  end
  self.equipName.text = ""
  self.hideContainer:SetActive(true)
  self:UpdateInfoContainer()
  self:UpdateButton()
  local data = self.currentCell and self.currentCell.data
  if data and data.itemid and data.itemid > 0 then
    self:ShowTab(self.selectedTabIndex or 1, true)
  else
    self:ShowTab(1, true)
  end
end

function MagicBoxExtractionNewPage:UpdateInfoContainer()
  local single = self.currentCell and self.currentCell.data
  if not single or single.itemid == 0 then
    self.hideContainer:SetActive(true)
    self.equipName.text = ""
    self.chooseItemIcon.gameObject:SetActive(false)
  else
    self.hideContainer:SetActive(false)
    self.equipName.text = single.itemStaticData.NameZh
    if single.itemStaticData then
      IconManager:SetItemIcon(single.itemStaticData.Icon, self.chooseItemIcon)
      self.equipName.text = single.itemStaticData.NameZh
      self.chooseItemIcon.gameObject:SetActive(true)
    end
    local refreshType = Table_EquipExtraction[single.itemid].RefreshType
    if refreshType == 1 and single.refinelv ~= 0 then
      self.lvTip.gameObject:SetActive(true)
      self.lvTip.text = string.format(ZhString.MagicBox_LvTip, single.extractionLv, single.refinelv)
    else
      self.lvTip.text = ""
      self.lvTip.gameObject:SetActive(false)
    end
    if refreshType == 1 and single.refinelv > single.extractionLv then
      self.currentCost = RefreshCost
    end
  end
end

function MagicBoxExtractionNewPage:UpdateButton()
  local single = self.currentCell and self.currentCell.data
  if single and single.active then
    self.activeBtnLabel.text = ZhString.MagicBox_Deactive
  else
    self.activeBtnLabel.text = ZhString.MagicBox_Active
  end
end

function MagicBoxExtractionNewPage:ShowEquipBord()
  local datas = self:GetValidEquips()
  self.chooseBord:ResetDatas(datas, true)
  self.chooseBord:Show(false, function(self, data)
    self:SetTargetItem(data)
    self.chooseBord:Hide()
  end, self)
  local nowData = self:GetNowItemData()
  if nowData then
    self.chooseBord:SetChoose(nowData)
  end
  self.chooseBord:SetNoneTip(ZhString.MagicBox_NoneTip)
  self.chooseBord:SetBordTitle(ZhString.NpcRefinePanel_ChooseEquip)
end

function MagicBoxExtractionNewPage:SetTargetItem(data)
  self.itemdata = data
end

function MagicBoxExtractionNewPage:GetNowItemData()
  return self.itemdata
end

function MagicBoxExtractionNewPage:ChooseItem(itemdata)
  if not self.currentCell then
    return
  end
  self:SetTargetItem(itemdata)
  self:ShowTab(1, true)
  IconManager:SetItemIcon(self.itemdata.staticData.Icon, self.chooseItemIcon)
  self.chooseItemIcon.gameObject:SetActive(true)
  local equipid = self.itemdata.staticData.id
  local config = Table_EquipExtraction[equipid] and Table_EquipExtraction[equipid].RefineLvCost
  local refinelv = self.itemdata.equipInfo.refinelv or 0
  self.equipName.text = self.itemdata.staticData.NameZh
  refreshType = Table_EquipExtraction[equipid].RefreshType
  if refreshType == 1 then
    self.exCurrentTip.text = string.format(ZhString.MagicBox_RefreshTip, refinelv, "?")
    self.lvTip.gameObject:SetActive(true)
    self.lvTip.text = string.format(ZhString.MagicBox_LvTip, "?", refinelv)
  else
    self.exCurrentTip.text = string.format(ZhString.MagicBox_NoRefreshTip2)
    if refinelv ~= 0 then
      self.lvTip.gameObject:SetActive(true)
      self.lvTip.text = string.format("[c][39E0F3]%s[-][/c]", refinelv)
    else
      self.lvTip.text = ""
      self.lvTip.gameObject:SetActive(false)
    end
  end
  self:UpdateBuffInfo(equipid)
  self.hideContainer:SetActive(false)
  self.currentCost = config and config[refinelv + 1]
  self.showExtractionCost = true
  self:UpdateExtractionCost(false)
end

function MagicBoxExtractionNewPage:UpdateExtractionCost(setRefresh)
  local costDataList = {}
  if self.showExtractionCost then
    self.currentCost = self.currentCost or 0
    local costitem = ExtractionCostItem
    local mine = BagProxy.Instance:GetItemNumByStaticID(costitem)
    local discount = 1
    if setRefresh then
      discount = AttrExtractionProxy.Instance:GetDiscount(costitem)
    end
    if mine >= self.currentCost * discount and self.currentCost > 0 then
      self.extractButton.isEnabled = true
      self.extractBtnLabel.effectColor = orange
      table.insert(costDataList, ExtractionCostData.new(costitem, self.currentCost, mine, discount))
    else
      self.extractButton.isEnabled = false
      self.extractBtnLabel.effectColor = grey
      table.insert(costDataList, ExtractionCostData.new(costitem, self.currentCost, mine, discount))
    end
  end
  self.exCostCtrl:ResetDatas(costDataList)
end

function MagicBoxExtractionNewPage:UpdateUpgradeCost()
  if self.costDataList then
    TableUtility.ArrayClear(self.costDataList)
  end
  if self.selectedUpgradeEquips then
    TableUtility.ArrayClear(self.selectedUpgradeEquips)
  end
  if self.showUpgradeCost then
    local single = self.currentCell and self.currentCell.data
    local upgradeConfig = GameConfig.ExtractLevelUp
    local equipCostConfig = GameConfig.ExtractLevelUp.equip_cost
    if single and single.itemid > 0 then
      local refreshType = Table_EquipExtraction[single.itemid].RefreshType
      local maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(single.itemStaticData) or 0
      if refreshType == 1 and maxRefineLv > single.refinelv then
        self.costDataList, self.selectedUpgradeEquips, self.selectedUpgradeEquipCount = AttrExtractionProxy.Instance:GetUpgradeCostConfig(single)
      end
    end
  end
  self.upCostCtrl:ResetDatas(self.costDataList or {})
end

function MagicBoxExtractionNewPage:ShowItemTip(itemId, stick, anchor, offset)
  local itemData = ItemData.new("MagicBoxExtractionNewPage", itemId)
  local sdata = {
    itemdata = itemData,
    funcConfig = {}
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick:GetComponent(UIWidget), anchor, offset)
end

local ItemTipOffset = {-220, 90}

function MagicBoxExtractionNewPage:OnUpgradeItemClicked(cell)
  local cellData = cell.cellData
  if not cellData then
    return
  end
  if cellData and cellData.isEquip then
    local costNum = 0
    if self.costDataList then
      for _, costData in ipairs(self.costDataList) do
        if costData.itemId == cellData.itemId then
          costNum = costData.costNum
          break
        end
      end
    end
    local showSelectedDatas = {}
    local selectedItems, selectedCount = self.selectedUpgradeEquips, self.selectedUpgradeEquipCount
    if not selectedCount or costNum > selectedCount then
      self:UpdateUpgradeCost()
      selectedItems = self.selectedUpgradeEquips
      selectedCount = self.selectedUpgradeEquipCount
    end
    for _, item in ipairs(selectedItems) do
      local cloneData = item:Clone()
      if item.ownedNum then
        cloneData:SetItemNum(item.ownedNum)
      end
      table.insert(showSelectedDatas, cloneData)
    end
    if costNum > selectedCount then
      local lackItems = {
        {
          id = cellData.itemId,
          count = costNum - selectedCount
        }
      }
      if QuickBuyProxy.Instance:TryOpenView(lackItems) then
        return
      end
    end
    self.ignoreCountChange = true
    self.upgradeEquipChooseBord:SetUseItemNum(true)
    self.upgradeEquipChooseBord:ResetDatas(showSelectedDatas)
    self.upgradeEquipChooseBord:SetChooseReference(selectedItems)
    self.upgradeEquipChooseBord:Show()
    self.ignoreCountChange = nil
  elseif cellData:HasEnoughItems() then
    self:ShowItemTip(cellData.itemId, cell.gameObject, NGUIUtil.AnchorSide.TopLeft, ItemTipOffset)
  elseif cellData.itemId == 5930 then
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(650, 1)
    local buyGood
    if shopData then
      local goods = shopData:GetGoods()
      for k, good in pairs(goods) do
        if good.id == 201340 then
          buyGood = good
        end
      end
    end
    if buyGood then
      local buyCell = TipsView.Me():HappyShopBuyItem(cell, {-220, 300}, buyGood)
      buyCell:UpdateOwnInfo(GameConfig.PackageMaterialCheck.extraction)
    else
      MsgManager.ShowMsgByID(3626)
    end
  elseif not cellData:IsMoney() then
    local lackItems = {
      {
        id = cellData.itemId,
        count = cellData.costNum - cellData.ownedNum
      }
    }
    QuickBuyProxy.Instance:TryOpenView(lackItems)
  else
    self:ShowItemTip(cellData.itemId, cell.gameObject, NGUIUtil.AnchorSide.TopLeft, ItemTipOffset)
  end
end

function MagicBoxExtractionNewPage:GetCostDataByWithSameVID(equip)
  if self.costDataList then
    for _, data in ipairs(self.costDataList) do
      if not self.tempItemData then
        self.tempItemData = ItemData.new("MagicBoxExtractionNewPage", data.itemId)
      else
        self.tempItemData:ResetData("MagicBoxExtractionNewPage", data.itemId)
      end
      if BlackSmithProxy.DoEquipsHaveSameVID(self.tempItemData, equip, true) then
        return data
      end
    end
  end
end

function MagicBoxExtractionNewPage:OnCountChooseChange(cell)
  if self.ignoreCountChange then
    return
  end
  if not self.costDataList or not cell then
    return
  end
  local cellData = cell.data
  for _, equip in ipairs(self.selectedUpgradeEquips) do
    if cellData.id == equip.id then
      local costData = self:GetCostDataByWithSameVID(equip)
      if costData then
        local lastChooseNum = equip.num or 0
        local chooseNum = cellData.chooseCount or 0
        local delta = chooseNum - lastChooseNum
        local costNum = costData.costNum
        local ownedNum = costData.ownedNum
        local newOwnedNum = ownedNum + delta
        if costNum < newOwnedNum then
          chooseNum = chooseNum - (newOwnedNum - costNum)
          delta = chooseNum - lastChooseNum
          cellData.chooseCount = chooseNum
          equip.num = chooseNum
          costData.ownedNum = costNum
        else
          equip.num = cellData.chooseCount
          costData.ownedNum = newOwnedNum
        end
        self.selectedUpgradeEquipCount = self.selectedUpgradeEquipCount + chooseNum - lastChooseNum
      end
      break
    end
  end
  self.upCostCtrl:ResetDatas(self.costDataList or {})
  self.upgradeEquipChooseBord:SetChooseReference(self.selectedUpgradeEquips)
end

function MagicBoxExtractionNewPage:HandleUpdateCurrentCost(setRefresh)
  if self.selectedTabIndex == 2 then
    self:UpdateUpgradeCost()
  else
    self:UpdateExtractionCost(setRefresh)
  end
end

function MagicBoxExtractionNewPage:GetValidEquips()
  local result = {}
  for k, v in pairs(Table_EquipExtraction) do
    local equiplist = BagProxy:GetItemsByStaticID(v.id) or {}
    for i = 1, #equiplist do
      if not BagProxy:CheckIsFavorite(equiplist[i]) and BagProxy.CheckEquipIsClean(equiplist[i], true) and not equiplist[i].equipInfo.damage then
        if v.RefreshType == 1 and equiplist[i].equipInfo.refinelv > 0 then
          table.insert(result, equiplist[i])
        elseif v.RefreshType == 0 then
          table.insert(result, equiplist[i])
        end
      end
    end
  end
  return result
end

function MagicBoxExtractionNewPage:CheckEquipValid(item)
  local equipInfo = item.equipInfo
  local enchantInfo = item.enchantInfo
  local nocards = not item:HasEquipedCard()
  if equipInfo and equipInfo.strengthlv <= 0 and 0 >= equipInfo.strengthlv2 and 0 >= equipInfo.equiplv and nocards and (not enchantInfo or not enchantInfo:HasAttri()) then
    if expRefine == true then
      return true
    else
      return 0 >= equipInfo.refinelv
    end
  end
  return false
end

function MagicBoxExtractionNewPage:UpdateView(note)
  if note and note.body then
    self:UpdateSlotList()
  end
  local showdata = {}
  showdata.data = AttrExtractionProxy.Instance:GetExtractionDataByGrid(1)
  self:ClickSlotCell(showdata)
end

function MagicBoxExtractionNewPage:UpdateSlotList()
  local gridlist = AttrExtractionProxy.Instance:GetExtractDataList()
  self.slotGridCtrl:ResetDatas(gridlist)
end

function MagicBoxExtractionNewPage:CallExtract()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid and self.itemdata then
    gridid = self.currentCell.data.gridid
    itemid = self.itemdata.id
    FunctionSecurity.Me():NormalOperation(function()
      MsgManager.ConfirmMsgByID(40988, function()
        ServiceNUserProxy.Instance:CallExtractionOperateUserCmd(gridid, itemid)
      end)
    end)
  end
end

function MagicBoxExtractionNewPage:CallActive()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid then
    if self.currentCell.data.itemid == 0 then
      MsgManager.ShowMsgByIDTable(40917)
    else
      ServiceNUserProxy.Instance:CallExtractionActiveUserCmd(self.currentCell.data.gridid)
    end
  end
end

function MagicBoxExtractionNewPage:CallEmpty()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid then
    if self.currentCell.data.itemid == 0 then
      return
    end
    if self.currentCell.data.active then
      MsgManager.ShowMsgByIDTable(40915)
    else
      gridid = self.currentCell.data.gridid
      FunctionSecurity.Me():NormalOperation(function()
        MsgManager.ConfirmMsgByID(40987, function()
          ServiceNUserProxy.Instance:CallExtractionRemoveUserCmd(gridid)
        end)
      end)
    end
  else
    redlog("self.currentCell nil")
  end
end

function MagicBoxExtractionNewPage:CallRefresh()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid then
    if self.currentCell.data.active then
      MsgManager.ShowMsgByIDTable(41110)
      return
    end
    gridid = self.currentCell.data.gridid
    mine = BagProxy.Instance:GetItemNumByStaticID(ExtractionCostItem)
    local discount = AttrExtractionProxy.Instance:GetDiscount(ExtractionCostItem)
    local needNum = RefreshCost * discount
    if needNum > mine then
      QuickBuyProxy.Instance:TryOpenView({
        {
          id = ExtractionCostItem,
          count = needNum - mine
        }
      })
    else
      FunctionSecurity.Me():NormalOperation(function()
        ServiceNUserProxy.Instance:CallExtractionRefreshUserCmd(gridid)
      end)
    end
  else
    redlog("self.currentCell nil")
  end
end

function MagicBoxExtractionNewPage:OperateResult(note)
  if note and note.body and note.body.data then
    self:UpdateSlotList()
    self:ClickSlotCell(self.currentCell)
  end
  self:CancelLockCall()
end

function MagicBoxExtractionNewPage:ActiveResult(note)
  if note and note.body then
    self:UpdateSlotList()
    self:UpdateButton()
  end
end

function MagicBoxExtractionNewPage:RemoveResult(note)
  if note and note.body and note.body.success then
    self:UpdateSlotList()
    self:ClickSlotCell(self.currentCell)
  end
end

function MagicBoxExtractionNewPage:PurchaseResult(note)
  if note and note.body then
    self:UpdateSlotList()
  end
end

function MagicBoxExtractionNewPage:RefreshResult(note)
  if note and note.body and note.body.data then
    self:UpdateSlotList()
    self:ClickSlotCell(self.currentCell)
    local res = note.body.update_type
    if res == 1 or res == 2 then
      if res == 1 then
        self.resultSuccessGO:SetActive(true)
        self.resultFailGO:SetActive(false)
      elseif res == 2 then
        self.resultSuccessGO:SetActive(false)
        self.resultFailGO:SetActive(true)
      end
      self.resultTween:ResetToBeginning()
      self.resultTween:Play(true)
      self:CheckShare()
    end
  end
  self:CancelLockCall()
end

function MagicBoxExtractionNewPage:CheckShare()
  if self.currentCell and self.currentCell.data then
    local single = self.currentCell.data
    if single.refinelv == single.extractionLv then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.MagicBoxExtractionShareView,
        viewdata = single
      })
    end
  end
end

function MagicBoxExtractionNewPage:CallUpgrade()
  local extractionData = self.currentCell and self.currentCell.data
  if not extractionData or not self.costDataList then
    return
  end
  local lackItems
  local hasEnoughItems = true
  for _, data in ipairs(self.costDataList) do
    if not data:HasEnoughItems() then
      hasEnoughItems = false
      if not data:IsMoney() then
        lackItems = lackItems or {}
        table.insert(lackItems, {
          id = data.itemId,
          count = data.costNum - data.ownedNum
        })
      end
    end
  end
  if not hasEnoughItems then
    if lackItems and 0 < #lackItems then
      QuickBuyProxy.Instance:TryOpenView(lackItems)
    end
    return
  end
  local selectedEquips = {}
  local refineItems = {}
  if self.selectedUpgradeEquips then
    for _, v in ipairs(self.selectedUpgradeEquips) do
      if v.num and 0 < v.num then
        table.insert(selectedEquips, v)
        table.insert(refineItems, v:ExportServerItemInfo())
      end
    end
  end
  if FunctionItemFunc.RecoverEquips(selectedEquips) then
    return
  end
  ServiceItemProxy.Instance:CallExtractLevelUpItemCmd(extractionData.gridid, refineItems)
end
