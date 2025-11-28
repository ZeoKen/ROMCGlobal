PackageMainPage = class("PackageMainPage", SubView)
autoImport("ItemNormalList")
autoImport("BagCombineDragItemCell")
autoImport("QuestPackagePart")
autoImport("FoodPackagePart")
autoImport("PetPackagePart")
autoImport("GemPackagePart")
autoImport("FurniturePackagePart")
autoImport("PersonalArtifactPackagePart")
autoImport("ExtractionPackagePart")
local addFavoriteItems, delFavoriteItems, readyToPutInItems = {}, {}, {}

function PackageMainPage:Init()
  self:AddViewEvts()
  self:InitUI()
end

function PackageMainPage:OnEnter()
  PackageMainPage.super.OnEnter(self)
  TableUtility.ArrayClear(addFavoriteItems)
  TableUtility.ArrayClear(delFavoriteItems)
  self:UpdateCoins()
  self:SwitchFashionItemTab(false, true)
  if self.markingFavoriteMode then
    self:SwitchMarkingFavoriteMode()
    self.itemlist:ResetPosition()
  end
  self:UpdateGuide()
end

local tabDatas = {}

function PackageMainPage:InitUI()
  self.packageBordMap = {}
  self.normalStick = self.container.normalStick
  self:InitItemList()
  self:InitRefreshSymbol()
  local coins = self:FindChild("TopCoins")
  self.lottery = self:FindChild("Lottery", coins)
  self.lotterylabel = self:FindComponent("Label", UILabel, self.lottery)
  local icon = self:FindComponent("symbol", UISprite, self.lottery)
  IconManager:SetItemIcon(Table_Item[151].Icon, icon)
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  icon = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[100].Icon, icon)
  if FunctionLogin.Me():IsNoviceServer() then
    self.lottery:SetActive(false)
  else
    self.lottery:SetActive(true)
  end
end

function PackageMainPage:InitItemList()
  self.itemlist = ItemNormalList.new(self:FindGO("ItemNormalList"), BagCombineDragItemCell, nil, PullStopScrollView, true)
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickItemTab, self)
  self.itemlist:AddEventListener(DragDropEvent.StartDrag, self.OnDragStart, self)
  self.itemlist:AddEventListener(DragDropEvent.EndDrag, self.OnDragEnd, self)
  self.itemlist.GetTabDatas = PackageMainPage.GetTabDatas
  self.itemlist.UpdateTabList = PackageMainPage.UpdateTabList
  
  function self.itemlist.scrollView.onDragStarted()
    self:ShowItemTip()
    self:SetItemDragEnabled(false)
  end
  
  function self.itemlist.scrollView.onDragFinished()
    if self.markingFavoriteMode then
      return
    end
    if self.markingMode then
      return
    end
    if self.isMemoryPage then
      return
    end
    self:SetItemDragEnabled(true)
  end
  
  self.itemListScrollPanel = self.itemlist.scrollView.panel
  self.itemCells = self.itemlist:GetItemCells()
  for _, cell in pairs(self.itemCells) do
    cell.showEquipInvalidByLevel = true
  end
end

function PackageMainPage:InitRefreshSymbol()
  self:AddButtonEvent("StoreButton", function(go)
    self:TryeDoQuick()
  end)
  self:AddButtonEvent("SaleButton", function(go)
    self:DoSaleButton()
  end)
  self:AddButtonEvent("RearrayButton", function(go)
    self:DoRearrayButton()
  end)
  self:AddButtonEvent("MarkFavoriteButton", function(go)
    local switchModeOnAction = function()
      self:SwitchMarkingFavoriteMode(true)
    end
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(32500)
    if not dont then
      MsgManager.DontAgainConfirmMsgByID(32500, switchModeOnAction, switchModeOnAction)
    else
      switchModeOnAction()
    end
  end)
  self:AddButtonEvent("MarkFavoriteButtonFake", function(go)
    self:SwitchMarkingFavoriteMode()
  end)
  self.refreshSymbol = self:FindGO("RefreshSymbol")
  self.refreshSymbol:SetActive(true)
  self.markFavoriteControls = self:FindGO("MarkFavoriteControls")
  self.markFavoriteControls:SetActive(false)
  self.refreshSymbol_Grid = self.refreshSymbol:GetComponent(UIGrid)
  self.batchStoreBtn = self:FindGO("BatchStoreButton")
  self:AddClickEvent(self.batchStoreBtn, function()
    self:SwitchMakeingMode(true)
  end)
  self.memoryRecoverBtn = self:FindGO("MemoryRecoverButton")
  local memoryRecoverBtn_Icon = self:FindGO("Sprite", self.memoryRecoverBtn):GetComponent(UISprite)
  IconManager:SetUIIcon("memory_icon_3", memoryRecoverBtn_Icon)
  self:AddClickEvent(self.memoryRecoverBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipMemoryCombineView,
      viewdata = {
        itemdata = data,
        index = 2,
        tabs = {
          PanelConfig.EquipMemoryUpgradeView,
          PanelConfig.EquipMemoryDecomposeView,
          PanelConfig.EquipMemoryAttrResetView,
          PanelConfig.EquipMemoryAdvanceView
        }
      }
    })
  end)
  self.markGetFromPackage = self:FindGO("MarkGetFromPackage")
  self.markGetFromPackage:SetActive(false)
  local markGetFromPackageFakeBtn = self:FindGO("MarkGetFromPackageFake", self.markGetFromPackage)
  local markGetFromPackageFakeBtn_Label = self:FindGO("Label", markGetFromPackageFakeBtn):GetComponent(UILabel)
  markGetFromPackageFakeBtn_Label.text = ZhString.Repository_StoreIn
  self:AddButtonEvent("MarkGetFromPackageFake", function()
    self:SwitchMakeingMode()
    self:UpdateChooseAllLabel()
  end)
  self.chooseAllBtn = self:FindGO("ChooseAllBtn", self.markGetFromPackage)
  self:AddClickEvent(self.chooseAllBtn, function()
    self.chooseAllSwitch = not self.chooseAllSwitch
    self:MarkingChooseAll(self.chooseAllSwitch)
  end)
  self.chooseAllBtn_Label = self:FindGO("Label", self.chooseAllBtn):GetComponent(UILabel)
  self.chooseAllBtn_Label.text = ZhString.Repository_ChooseAll
  self.cancelBtn = self:FindGO("CancelBtn", self.markGetFromPackage)
  self:AddClickEvent(self.cancelBtn, function()
    TableUtility.ArrayClear(readyToPutInItems)
    self:SwitchMakeingMode()
    self:UpdateChooseAllLabel()
  end)
  self.memoryInfoBtn = self:FindGO("MemoryInfoBtn")
  self:AddClickEvent(self.memoryInfoBtn, function()
    xdlog("打开属性界面")
    if self.container.viewState == PackageView.LeftViewState.EquipMemoryInfo then
      self.container:SetLeftViewState(PackageView.LeftViewState.Default)
    else
      self.container:SetLeftViewState(PackageView.LeftViewState.EquipMemoryInfo)
    end
  end)
  self.scrollBg2 = self:FindGO("ScrollBg2")
end

function PackageMainPage:TryeDoQuick()
  if self.markingFavoriteMode then
    return
  end
  if self.markingMode then
    return
  end
  self.st = ReusableTable.CreateArray()
  local bagTypes = GameConfig.PackageMaterialCheck.quick_store or {1, 8}
  for i = 1, #bagTypes do
    BagProxy.Instance:CollectQuickStorageItems(self.st, bagTypes[i])
  end
  if #self.st == 0 then
    TableUtility.ArrayClear(self.st)
    ReusableTable.DestroyArray(self.st)
    MsgManager.ShowMsgByIDTable(25426)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25424)
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25424, function()
      self:DoQuickStore()
    end)
  else
    self:DoQuickStore()
  end
end

function PackageMainPage:DoQuickStore()
  helplog("Do QuickStore")
  local items = ReusableTable.CreateArray()
  for i = 1, #self.st do
    local item = self.st[i]
    local sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
    sitem.guid, sitem.count = item.id, item.num or 0
    table.insert(items, sitem)
  end
  ServiceItemProxy.Instance:CallQuickStoreItemCmd(items)
  ReusableTable.DestroyArray(items)
  TableUtility.ArrayClear(self.st)
  ReusableTable.DestroyArray(self.st)
end

function PackageMainPage:DoSaleButton()
  if self.markingFavoriteMode then
    return
  end
  if self.markingMode then
    return
  end
  helplog("DoSaleButton In")
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CollectSaleConfirmPopUp
  })
end

function PackageMainPage:DoRearrayButton()
  if self.markingFavoriteMode then
    return
  end
  if self.markingMode then
    return
  end
  if self.isMemoryPage then
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MEMORY)
    return
  end
  helplog("DoRearrayButton In")
  ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN)
end

function PackageMainPage:SwitchMarkingFavoriteMode(on)
  local isOn = on == true and true or false
  self.markingFavoriteMode = on
  self.itemlist.isMarkingFavorite = on
  self.markFavoriteControls:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  self.container:PassEvent(PackageEvent.SwitchMarkingFavoriteMode, self.markingFavoriteMode)
  if not self.itemlist.scrollView.isDragging then
    self:SetItemDragEnabled(not isOn)
  end
  if not on and (next(addFavoriteItems) or next(delFavoriteItems)) then
    local msgId = 32002
    if not LocalSaveProxy.Instance:GetDontShowAgain(msgId) then
      MsgManager.DontAgainConfirmMsgByID(msgId, function()
        self:TrySendFavorite()
      end, function()
        self:UpdateList()
      end)
    else
      self:TrySendFavorite()
    end
  end
  if self.isMemoryPage then
    self:ResizeScrollView(2)
  else
    self:ResizeScrollView(1)
  end
  self.refreshSymbol_Grid:Reposition()
end

function PackageMainPage:TrySendFavorite()
  local bagIns = BagProxy.Instance
  if next(addFavoriteItems) then
    bagIns:CallAddFavoriteItems(addFavoriteItems)
  end
  if next(delFavoriteItems) then
    bagIns:CallDelFavoriteItems(delFavoriteItems)
  end
  self.delayedUpdateList = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self:UpdateList()
    self.delayedUpdateList = nil
  end, self)
  for _, cell in pairs(self.itemCells) do
    cell:HideMask()
  end
  TableUtility.ArrayClear(addFavoriteItems)
  TableUtility.ArrayClear(delFavoriteItems)
end

GameConfig.ItemFashion = {
  [1] = {
    name = "头饰",
    types = {800}
  },
  [2] = {
    name = "背部",
    types = {810}
  },
  [3] = {
    name = "发型",
    types = {820}
  },
  [4] = {
    name = "脸部",
    types = {830}
  },
  [5] = {
    name = "嘴部",
    types = {850}
  },
  [6] = {
    name = "尾部",
    types = {840}
  }
}
PackageMainPage.iSFashionType = false

function PackageMainPage.GetTabDatas(itemTabConfig, tabData)
  TableUtility.ArrayClear(tabDatas)
  local bagData = BagProxy.Instance.bagData
  local datas
  if tabData.index == -1 then
    datas = BagProxy.Instance:GetFavoriteItemDatas()
  elseif tabData.index == 5 then
    xdlog("装备记忆页签")
    datas = BagProxy.Instance.memoryBagData and BagProxy.Instance.memoryBagData:GetItems()
  else
    datas = bagData:GetItems(itemTabConfig)
  end
  if datas and #datas == 0 then
    return tabDatas
  end
  if datas then
    for i = 1, #datas do
      if 0 < TableUtility.ArrayFindIndex(readyToPutInItems, datas[i].id) then
        datas[i].isMark = true
      end
      table.insert(tabDatas, datas[i])
    end
  end
  local uplimit = bagData:GetVirtualUplimit()
  if 0 < uplimit then
    for i = #tabDatas + 1, uplimit do
      table.insert(tabDatas, BagItemEmptyType.Empty)
    end
  elseif uplimit == 0 then
    local leftEmpty = (5 - #tabDatas % 5) % 5
    for i = 1, leftEmpty do
      table.insert(tabDatas, BagItemEmptyType.Empty)
    end
  end
  local unlockData = BagProxy.Instance:GetBagUnlockSpaceData()
  if unlockData then
    table.insert(tabDatas, {
      id = BagItemEmptyType.Unlock,
      unlockData = unlockData
    })
  end
  local leftEmpty = (5 - #tabDatas % 5) % 5
  for i = 1, 10 + leftEmpty do
    table.insert(tabDatas, BagItemEmptyType.Grey)
  end
  for i = #tabDatas + 1, 35 do
    table.insert(tabDatas, BagItemEmptyType.Grey)
  end
  return tabDatas
end

function PackageMainPage:UpdateTabList(tabType, customParam, resetPos)
  self.tabDatas = self.tabDatas or {}
  TableUtility.ArrayClear(self.tabDatas)
  local tabDataDefault = {
    index = 0,
    Config = nil,
    tabType = tabType
  }
  table.insert(self.tabDatas, tabDataDefault)
  for i = 1, 4 do
    local data = {
      index = i,
      tabType = tabType,
      Config = GameConfig.ItemPage[i]
    }
    table.insert(self.tabDatas, data)
  end
  if self.isShowFavoriteTab then
    local data = {index = -1, tabType = tabType}
    table.insert(self.tabDatas, 2, data)
    self.itemTabs.cellWidth = 71.7
  end
  if FunctionUnLockFunc.Me():CheckCanOpen(6211) then
    local data = {index = 5, tabType = tabType}
    table.insert(self.tabDatas, data)
    self.itemTabs.cellWidth = 66
  end
  self:SetTabDatas(self.tabDatas, resetPos)
end

function PackageMainPage:RemoveReArrageSafeLT()
  self:RemoveDelayedCall("reArrageSafeLT")
end

function PackageMainPage:PullDownPackage()
  self:RemoveReArrageSafeLT()
  self.reArrageSafeLT = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self:HandleItemReArrage()
  end, self)
  ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN)
end

function PackageMainPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
  end
  if data ~= nil and data.id == BagItemEmptyType.Unlock then
    MsgManager.ShowMsgByIDTable(3107, {
      data.unlockData.id,
      data.unlockData.pack
    })
    return
  end
  local newChooseId = data and data.id or 0
  local go = cellCtl and cellCtl.gameObject
  if self.markingFavoriteMode then
    if BagProxy.CheckIfCanDoFavoriteActions(data) then
      cellCtl:NegateFavoriteTip()
      TableUtility.ArrayRemove(addFavoriteItems, data.id)
      TableUtility.ArrayRemove(delFavoriteItems, data.id)
      local wasFavorite = BagProxy.Instance:CheckIsFavorite(data)
      local newFavorite = cellCtl:GetFavoriteTipActive()
      if wasFavorite ~= newFavorite then
        local arrToAdd = newFavorite and addFavoriteItems or delFavoriteItems
        TableUtility.ArrayPushBack(arrToAdd, data.id)
        cellCtl:ShowMask()
      else
        cellCtl:HideMask()
      end
    end
    return
  elseif self.markingMode then
    local hasChosen = cellCtl.data.isMark
    if hasChosen then
      cellCtl.data.isMark = false
      cellCtl:UpdateCheckMark()
      TableUtility.ArrayRemove(readyToPutInItems, data.id)
      redlog("移除添加", data.id)
    else
      cellCtl.data.isMark = true
      cellCtl:UpdateCheckMark()
      if TableUtility.ArrayFindIndex(readyToPutInItems, data.id) == 0 then
        TableUtility.ArrayPushBack(readyToPutInItems, data.id)
        xdlog("添加", data.id)
      end
    end
    self:UpdateChooseAllLabel()
    return
  end
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    if type(data) == "table" then
      local sid = data.staticData.id
      if sid == 5045 then
        self:CloseOtherAndShowPackageBord("Quest")
      elseif sid == 5047 then
        self:CloseOtherAndShowPackageBord("Food")
      elseif sid == 5640 then
        self:CloseOtherAndShowPackageBord("Pet")
      elseif sid == 5660 then
        self:CloseOtherAndShowPackageBord("Furniture")
      elseif sid == 5671 then
        self:CloseOtherAndShowPackageBord("Gem")
      elseif sid == 7203 then
        self:CloseOtherAndShowPackageBord("PersonalArtifact")
      elseif sid == 5544 then
        local jumpConfig = Table_ShortcutPower[data.staticData.UseMode]
        local jumpEvent = jumpConfig and jumpConfig.Event
        if jumpEvent then
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
            view = jumpEvent.panelid,
            viewdata = {
              offset = jumpEvent.offsetbag,
              side = jumpEvent.side,
              cellCtl = cellCtl
            }
          })
        end
      elseif sid == 5681 then
        self:CloseOtherAndShowPackageBord("Extraction")
      else
        self:ShowPackageItemTip(data, {go})
      end
    else
      self:ShowPackageItemTip(data, {go})
    end
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
  self:UpdateItemChoose()
end

function PackageMainPage:DoubleClickItem(cellCtl)
  local data = cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
  end
  if data ~= nil and data.id == BagItemEmptyType.Unlock then
    return
  end
  if self.markingFavoriteMode then
    return
  end
  if self.markingMode then
    return
  end
  if data then
    if data.staticData and data.staticData.id == 5544 then
      local jumpConfig = Table_ShortcutPower[data.staticData.UseMode]
      local jumpEvent = jumpConfig and jumpConfig.Event
      if jumpEvent then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = jumpEvent.panelid,
          viewdata = {
            offset = jumpEvent.offsetbag,
            side = jumpEvent.side,
            cellCtl = cellCtl
          }
        })
      end
    else
      local func, funcId
      if self.container.viewState == PackageView.LeftViewState.BarrowBag then
        func, funcId = FunctionItemFunc.Me():GetFuncById(37), 37
      else
        func, funcId = self.container:GetItemDefaultFunc(data, FunctionItemFunc_Source.MainBag)
      end
      if func then
        if self.container.viewState ~= PackageView.LeftViewState.Default and funcId == 4 then
          self.container:SetLeftViewState(PackageView.LeftViewState.Default)
        end
        if data.staticData.ExistTimeType ~= 3 or data.deltime == nil or data.deltime == 0 or not (data.deltime <= ServerTime.CurServerTime() / 1000) then
          func(data)
        end
      end
      self:ShowPackageItemTip()
      self.chooseId = 0
    end
    self:UpdateItemChoose()
  end
end

function PackageMainPage:ClickItemTab(cellCtrl)
  self:TryUpdateTemporarilyMarkFavorite()
  local index = cellCtrl and cellCtrl.indexInList
  if index then
    BagProxy.Instance:SetPackageViewTab(index)
  end
  self:UpdateChooseAllLabel()
  local itemPageIndex = cellCtrl and cellCtrl.data and cellCtrl.data.index
  if itemPageIndex == 5 then
    self:ResizeScrollView(2)
    self.memoryInfoBtn:SetActive(true)
    self.scrollBg2.transform.localPosition = LuaGeometry.GetTempVector3(0, -515, 0)
    self.memoryRecoverBtn:SetActive(true)
    self.isMemoryPage = true
    ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_MEMORY)
  else
    self:ResizeScrollView(1)
    self.memoryInfoBtn:SetActive(false)
    self.scrollBg2.transform.localPosition = LuaGeometry.GetTempVector3(0, -615, 0)
    self.memoryRecoverBtn:SetActive(false)
    if self.container.viewState == PackageView.LeftViewState.EquipMemoryInfo then
      self.container:SetLeftViewState(PackageView.LeftViewState.Default)
    end
    self.isMemoryPage = false
    if not self.markingFavoriteMode then
      self:SetItemDragEnabled(true)
    end
  end
  self.refreshSymbol_Grid:Reposition()
end

function PackageMainPage:OnDragStart(cellCtrl)
  xdlog("PackageMainPage OnDragStart")
  local data = cellCtrl.data
  self.container:OnBagItemDragStart(data)
end

function PackageMainPage:OnDragEnd(cellCtrl)
  xdlog("PackageMainPage OnDragEnd")
  local data = cellCtrl.data
  self.container:OnBagItemDragEnd(data)
end

function PackageMainPage:ResizeScrollView(type)
  if type == 2 then
    if self.markingFavoriteMode then
      self.itemlist.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(0, 0, 508, 408)
    else
      self.itemlist.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(0, 50, 508, 508)
    end
  elseif self.markingFavoriteMode then
    self.itemlist.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(0, -50, 508, 508)
  else
    self.itemlist.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(0, 0, 508, 608)
  end
end

local comps = {}
local tipOffset = {0, 0}

function PackageMainPage:ShowPackageItemTip(data, ignoreBounds)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local callback = function()
    self.chooseId = 0
    self:UpdateItemChoose()
  end
  local sdata = {
    itemdata = data,
    showUpTip = true,
    funcConfig = self.container:GetDataFuncs(data),
    ignoreBounds = ignoreBounds,
    callback = callback,
    showFrom = "bag",
    showButton = "bag"
  }
  TableUtility.TableClear(comps)
  tipOffset[1] = -210
  if self.container.viewState ~= PackageView.LeftViewState.BarrowBag and (data.equipInfo or data:IsMount()) then
    local site = data.equipInfo:GetEquipSite()
    local _bagProxy = BagProxy.Instance
    local _bagData = _bagProxy:IsViceEquipType() and _bagProxy.shadowBagData or _bagProxy.roleEquip
    for i = 1, #site do
      local comp = _bagData:GetEquipBySite(site[i])
      if comp then
        table.insert(comps, comp)
      end
    end
  end
  sdata.compdata1 = comps[1]
  sdata.compdata2 = comps[2]
  if comps[1] then
    tipOffset[1] = 0
  end
  local tip = self:ShowItemTip(sdata, self.normalStick, nil, tipOffset)
  if tip and tip.ActiveFavorite then
    tip:ActiveFavorite()
  end
end

function PackageMainPage:SetItemDragEnabled(b)
  for _, cell in pairs(self.itemCells) do
    cell:CanDrag(b)
  end
end

function PackageMainPage:SwitchFashionItemTab(go, force)
  if not force and PackageMainPage.iSFashionType == go then
    return
  end
  PackageMainPage.iSFashionType = go
  if go then
    self.itemlist:UpdateTabList(ItemNormalList.TabType.FashionPage)
  else
    self.itemlist:UpdateTabList(ItemNormalList.TabType.ItemPage)
  end
  local lastPackageTab = BagProxy.Instance.packageTab or 1
  self.itemlist:ChooseTab(lastPackageTab, true)
end

function PackageMainPage:LockUpdate(b)
  if self.lockUpdate == b then
    return
  end
  self.lockUpdate = b
  self:UpdateList()
end

function PackageMainPage:UpdateList()
  if self.lockUpdate then
    return
  end
  self.itemlist:UpdateList(true)
  local instance = GuideMaskView.Instance
  if instance then
    instance:showGuideByQuestDataRepeat()
  end
  local cells = self.itemlist:GetItemCells()
  for _, cell in pairs(cells) do
    local guid = cell.data and cell.data.id
    if guid then
      if TableUtility.ArrayFindIndex(readyToPutInItems, guid) > 0 then
        cell.data.isMark = true
        cell:UpdateCheckMark()
      else
        cell.data.isMark = false
        cell:UpdateCheckMark()
      end
    else
      cell:UpdateCheckMark()
    end
  end
end

function PackageMainPage:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
  self.lotterylabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
end

function PackageMainPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.ItemReArrage, self.HandleItemReArrage)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemPackSlotNtfItemCmd, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemPackageSort, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.UseTimeUpdate, self.HandleItemUpdate)
  self:AddListenEvt(SkillEvent.SkillStartEvent, self.HandleSkillStart)
  self:AddListenEvt(PackageEvent.ShowBord, self.HandleShowBord)
  self:AddListenEvt(PlayerEvent.AnonymousStateChange, self.HandleItemUpdate)
end

function PackageMainPage:HandleItemUpdate(note)
  self:RemoveDelayedCall("delayedUpdateList")
  self:UpdateList()
  local tip = TipsView.Me().currentTip
  if tip and TipsView.Me():IsCurrentTip(ItemFloatTip) and tip.UpdateFavorite then
    tip:UpdateFavorite()
  end
end

function PackageMainPage:HandleItemReArrage(note)
  local arrageType = note.body
  local bord
  if arrageType == SceneItem_pb.EPACKTYPE_PET then
    bord = self.packageBordMap.Pet
    if bord then
      bord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_FOOD then
    bord = self.packageBordMap.Food
    if bord then
      bord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_QUEST then
    if self.packageBordMap.Quest then
      self.packageBordMap.Quest:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_FURNITURE then
    if self.packageBordMap.Furniture then
      self.packageBordMap.Furniture:UpdateInfo()
    end
    bord = self.packageBordMap.Quest
    if bord then
      bord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_FURNITURE then
    bord = self.packageBordMap.Furniture
    if bord then
      bord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_GEM_SKILL or arrageType == SceneItem_pb.EPACKTYPE_GEM_ATTR then
    bord = self.packageBordMap.Gem
    if bord then
      bord:UpdateInfo()
    end
  elseif arrageType == SceneItem_pb.EPACKTYPE_ARTIFACT or arrageType == SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT then
    bord = self.packageBordMap.PersonalArtifact
    if bord then
      bord:UpdateInfo()
    end
  else
    self:RemoveReArrageSafeLT()
    self:PlayUISound(AudioMap.UI.ReArrage)
    local callback = function()
      self:UpdateList()
    end
    self.itemlist:ScrollViewRevert(callback)
  end
end

function PackageMainPage:HandleSkillStart(note)
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    self:HandleItemUpdate()
  end, self)
end

function PackageMainPage:HandleShowBord(note)
  local data = note and note.body
  if not data then
    return
  end
  local bordKey = data.bordKey
  self:CloseOtherAndShowPackageBord(bordKey)
  local bordCtrl = self.packageBordMap[bordKey]
  if bordCtrl then
    if data.tab and bordCtrl.ShowTab then
      bordCtrl:ShowTab(data.tab)
    end
    if bordCtrl.SetAnchorSide then
      bordCtrl:SetAnchorSide(data.side or NGUIUtil.AnchorSide.Left)
    end
  end
end

function PackageMainPage:CloseOtherAndShowPackageBord(bordKey)
  self:CloseOtherPackageBord(bordKey)
  self:ShowPackageBord(bordKey)
end

function PackageMainPage:CloseOtherPackageBord(bordKey)
  for name, bord in pairs(self.packageBordMap) do
    if bordKey ~= name then
      self:HidePackageBord(bord)
    end
  end
end

function PackageMainPage:HidePackageBord(bord)
  if bord and bord.gameObject.activeSelf then
    bord:Hide()
  end
end

function PackageMainPage:ShowPackageBord(bordKey)
  local bord = self:GetPackageBord(bordKey)
  bord:UpdateInfo()
  bord:Show()
end

function PackageMainPage:GetPackageBord(bordKey)
  if self.packageBordMap[bordKey] then
    return self.packageBordMap[bordKey]
  end
  local parent = self:FindGO("QuestPackageParent")
  local bord = _G[bordKey .. "PackagePart"].new()
  bord:CreateSelf(parent)
  bord:Hide()
  self.packageBordMap[bordKey] = bord
  return bord
end

function PackageMainPage:TryUpdateTemporarilyMarkFavorite()
  if not self.markingFavoriteMode then
    return
  end
  self:UpdateTemporarilyMarkFavoriteByArray(addFavoriteItems)
  self:UpdateTemporarilyMarkFavoriteByArray(delFavoriteItems)
end

function PackageMainPage:UpdateTemporarilyMarkFavoriteByArray(arr)
  for _, tempMarkId in pairs(arr) do
    for _, cell in pairs(self.itemCells) do
      if cell.data and cell.data.id == tempMarkId then
        cell:ShowMask()
        cell:NegateFavoriteTip()
      end
    end
  end
end

function PackageMainPage:CheckFavoriteModeOnExit(checkCompleteHandler)
  if self.markingFavoriteMode and (next(addFavoriteItems) or next(delFavoriteItems)) then
    MsgManager.ConfirmMsgByID(32002, function()
      self:TrySendFavorite()
      checkCompleteHandler()
    end, checkCompleteHandler)
  else
    checkCompleteHandler()
  end
end

function PackageMainPage:RemoveDelayedCall(keyOfCall)
  if self[keyOfCall] and self[keyOfCall].Destroy then
    self[keyOfCall]:Destroy()
    self[keyOfCall] = nil
  end
end

function PackageMainPage:OnShow()
  if self.itemlist == nil then
    return
  end
  if self.itemlist.panel then
    self.itemlist.panel:SetDirty()
  end
  self.itemlist:ResetPosition()
end

function PackageMainPage:OnExit()
  self:RemoveReArrageSafeLT()
  self:RemoveDelayedCall("delayedUpdateList")
  self.chooseId = 0
  self:ShowPackageItemTip()
  self:UpdateItemChoose()
  PackageMainPage.iSFashionType = false
  PackageMainPage.super.OnExit(self)
end

function PackageMainPage:OnDestroy()
  self.itemlist:OnExit()
  self.itemlist = nil
end

function PackageMainPage:UpdateItemChoose()
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function PackageMainPage:UpdateGuide()
  local guideItemId
  if FunctionClientGuide.Me():TryTakeCustomParam(ClientGuide.ParamType.trace_packageview_astrolabepos) then
    guideItemId = 5501
  elseif FunctionClientGuide.Me():TryTakeCustomParam(ClientGuide.ParamType.trace_packageview_gempos) then
    guideItemId = 5670
  elseif FunctionClientGuide.Me():TryTakeCustomParam(ClientGuide.ParamType.trace_packageview_guideCommonEquip) then
    guideItemId = 42691
  elseif FunctionClientGuide.Me():TryTakeCustomParam(ClientGuide.ParamType.trace_packageview_guideShadowEquip) then
    guideItemId = 42692
  end
  if guideItemId then
    self.itemlist:SetItemPosition(guideItemId)
  end
  local cells = self.itemlist:GetItemCells()
  for i = 1, #cells do
    cells[i]:ActiveGuide(true)
  end
end

function PackageMainPage:SwitchMakeingMode(on)
  local isOn = on == true and true or false
  local needResetPos = false
  if self.markingMode ~= on then
    needResetPos = true
  end
  self.markingMode = on
  self.markGetFromPackage:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  if not on then
    self:TrySendGetFromPackage()
  end
  if not needResetPos then
    return
  end
  local tmpClipRegion = self.itemListScrollPanel.baseClipRegion
  local refreshSymbolHeight = 92
  tmpClipRegion.y = on and -refreshSymbolHeight / 2 or 0
  tmpClipRegion.w = tmpClipRegion.w + refreshSymbolHeight * (on and -1 or 1)
  self.itemListScrollPanel.baseClipRegion = tmpClipRegion
end

function PackageMainPage:TrySendGetFromPackage()
  local datas = self.itemlist:GetDatas()
  for i = 1, #datas do
    if type(datas[i]) == "table" then
      datas[i].isMark = false
    end
  end
  self.itemlist:SetData(datas, true)
  local tryCall = false
  if 0 < #readyToPutInItems then
    tryCall = true
  end
  if tryCall then
    self:CallStorePutItemItemCmd()
    TableUtility.ArrayClear(readyToPutInItems)
  end
  GameFacade.Instance:sendNotification(ItemEvent.ItemReArrage)
end

function PackageMainPage:MarkingChooseAll(bool)
  local datas = self.itemlist:GetDatas()
  for i = 1, #datas do
    if type(datas[i]) == "table" then
      if bool then
        if TableUtility.ArrayFindIndex(readyToPutInItems, datas[i].id) == 0 then
          TableUtility.ArrayPushBack(readyToPutInItems, datas[i].id)
          datas[i].isMark = bool
        end
      else
        TableUtility.ArrayRemove(readyToPutInItems, datas[i].id)
        datas[i].isMark = bool
      end
    end
  end
  self.itemlist:SetData(datas, true)
  for _, cell in pairs(self.itemCells) do
    local guid = cell.data and cell.data.id
    if guid then
      cell.data.isMark = bool
      cell:UpdateCheckMark()
    end
  end
  self:UpdateChooseAllLabel()
end

function PackageMainPage:CheckIsLock(itemData)
  if not itemData then
    return false
  end
  if self.viewTab == RepositoryView.Tab.RepositoryTab then
    if not itemData:CanStorage(BagProxy.BagType.PersonalStorage) then
      return true
    end
  elseif self.viewTab == RepositoryView.Tab.CommonTab then
    if not itemData:CanStorage(BagProxy.BagType.PersonalStorage) then
      return true
    end
  elseif self.viewTab == RepositoryView.Tab.HomeTab and not itemData:CanStorage(BagProxy.BagType.PersonalStorage) then
    return true
  end
  return false
end

function PackageMainPage:UpdateChooseAllLabel()
  local datas = self.itemlist:GetDatas()
  self.chooseAllSwitch = false
  for i = 1, #datas do
    if type(datas[i]) == "table" and datas[i].isMark then
      self.chooseAllSwitch = true
    end
  end
  if self.chooseAllSwitch then
    self.chooseAllBtn_Label.text = ZhString.Repository_CancelChooseAll
  else
    self.chooseAllBtn_Label.text = ZhString.Repository_ChooseAll
  end
end

function PackageMainPage:CallStorePutItemItemCmd()
  local toPackage = SceneItem_pb.EPACKTYPE_BARROW
  if not toPackage then
    redlog("仓库类型缺失")
    return
  end
  ServiceItemProxy.Instance:CallStorePutItemItemCmd(toPackage, readyToPutInItems)
end

function PackageMainPage:UpdateSwtichStatus()
  if self.container.viewState == PackageView.LeftViewState.BarrowBag then
    self.batchStoreBtn:SetActive(true)
  else
    self.batchStoreBtn:SetActive(false)
  end
  self.refreshSymbol_Grid:Reposition()
end

function PackageMainPage:CheckMarkingModeOnExit()
  TableUtility.ArrayClear(readyToPutInItems)
  self:SwitchMakeingMode()
  self:UpdateChooseAllLabel()
end
