autoImport("BagItemCell")
autoImport("MaterialItemCell1")
autoImport("QuickBuffItemCell")
autoImport("WrapListCtrl")
QuickBuffSetPopUp = class("QuickBuffSetPopUp", ContainerView)
QuickBuffSetPopUp.ViewType = UIViewType.PopUpLayer
local FilterType = {All = 1, Owned = 2}

function QuickBuffSetPopUp:Init()
  self:FindObjs()
  self:AddViewEvts()
end

function QuickBuffSetPopUp:FindObjs()
  self.itemScrollView = self:FindGO("ItemScrollView")
  self.itemContainer = self:FindGO("ItemContainer", self.itemScrollView)
  self.itemListCtrl = WrapListCtrl.new(self.itemContainer, QuickBuffItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 8, 102, true)
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.itemListCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressItem, self)
  self.itemListCtrl:AddUpdateCall(self.OnItemListUpdated, self)
  self.chosenScrollView = self:FindComponent("ChosenScrollView", UIScrollView)
  self.chosenGrid = self:FindComponent("MaterialGrid", UIGrid, self.chosenScrollView.gameObject)
  self.chosenListCtrl = UIGridListCtrl.new(self.chosenGrid, MaterialItemCell1, "MaterialItemCell1")
  self.chosenListCtrl:AddEventListener(MaterialItemCell1.Event.Delete, self.OnDeleteChosenItem, self)
  self.activeLabel = self:FindComponent("ActiveLabel", UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
  self.helpBtn:SetActive(true)
  self:RegistShowGeneralHelpByHelpID(32660, self.helpBtn)
  self.filterPop = self:FindComponent("FilterPop", UIPopupList)
  self:InitFilter()
  self:AddButtonEvent("RemoveAllBtn", function()
    self:RemoveAllChosenItems()
  end)
  self:AddButtonEvent("ConfirmButton", function()
    self:ConfirmSelection()
  end)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
end

function QuickBuffSetPopUp:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemQuickBuffPackageItemCmd, self.OnQuickBuffPackageItemCmd)
end

function QuickBuffSetPopUp:InitFilter()
  if not self.filterPop then
    return
  end
  self.filterPop:Clear()
  self.filterPop:AddItem(ZhString.QuickBuffSetPopUp_FilterAll, FilterType.All)
  self.filterPop:AddItem(ZhString.QuickBuffSetPopUp_FilterOwned, FilterType.Owned)
  self.filterPop.value = ZhString.QuickBuffSetPopUp_FilterAll
  self.filterType = FilterType.All
  EventDelegate.Add(self.filterPop.onChange, function()
    self.filterType = self.filterPop.data or FilterType.All
    self:UpdatePage(true)
  end)
end

function QuickBuffSetPopUp:OnEnter()
  self.isDirty = false
  self:SyncSelectedItemsFromProxy()
  self:UpdatePage()
  BagProxy.Instance:RequestQuickBuffConfigItems()
end

function QuickBuffSetPopUp:OnItemUpdate()
  self:UpdatePage(true)
end

function QuickBuffSetPopUp:OnQuickBuffPackageItemCmd()
  if not self.isDirty then
    self:SyncSelectedItemsFromProxy()
  else
    self:TrimSelectedItemsToMaxCount()
  end
  self:UpdatePage(true)
end

function QuickBuffSetPopUp:SyncSelectedItemsFromProxy()
  self.selectedItems = self.selectedItems or {}
  TableUtility.TableClear(self.selectedItems)
  local itemIds = BagProxy.Instance:GetQuickBuffConfigItemIds()
  for i = 1, #itemIds do
    self.selectedItems[itemIds[i]] = true
  end
end

function QuickBuffSetPopUp:GetSelectedItemIds()
  self.selectedItemIds = self.selectedItemIds or {}
  TableUtility.ArrayClear(self.selectedItemIds)
  for itemId in pairs(self.selectedItems) do
    TableUtility.ArrayPushBack(self.selectedItemIds, itemId)
  end
  table.sort(self.selectedItemIds)
  return self.selectedItemIds
end

function QuickBuffSetPopUp:TrimSelectedItemsToMaxCount()
  local itemIds = self:GetSelectedItemIds()
  local maxCount = BagProxy.Instance:GetQuickBuffMaxSelectCount()
  for i = maxCount + 1, #itemIds do
    self.selectedItems[itemIds[i]] = nil
  end
end

function QuickBuffSetPopUp:GetSelectedCount()
  local count = 0
  for _ in pairs(self.selectedItems) do
    count = count + 1
  end
  return count
end

function QuickBuffSetPopUp:GetQuickBuffItems()
  self.itemDatas = self.itemDatas or {}
  TableUtility.ArrayClear(self.itemDatas)
  local itemIds = BagProxy.Instance:GetQuickBuffSelectableItemIds()
  for i = 1, #itemIds do
    local itemId = itemIds[i]
    local itemData = ItemData.new("QuickBuff_" .. itemId, itemId)
    itemData.num = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
    itemData.isMark = self.selectedItems[itemId] == true
    if self.filterType ~= FilterType.Owned or itemData.num > 0 then
      TableUtility.ArrayPushBack(self.itemDatas, itemData)
    end
  end
  return self.itemDatas
end

function QuickBuffSetPopUp:GetChosenItems()
  self.chosenDatas = self.chosenDatas or {}
  TableUtility.ArrayClear(self.chosenDatas)
  local itemIds = self:GetSelectedItemIds()
  for i = 1, #itemIds do
    local itemId = itemIds[i]
    local itemData = ItemData.new("QuickBuffChosen_" .. itemId, itemId)
    itemData.num = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
    itemData.showDelete = true
    TableUtility.ArrayPushBack(self.chosenDatas, itemData)
  end
  local maxCount = BagProxy.Instance:GetQuickBuffMaxSelectCount()
  for i = #self.chosenDatas + 1, maxCount do
    TableUtility.ArrayPushBack(self.chosenDatas, MaterialItemCell1.EmptyData.Space)
  end
  return self.chosenDatas
end

function QuickBuffSetPopUp:UpdatePage(noResetPosition)
  local items = self:GetQuickBuffItems()
  self.itemScrollView:SetActive(0 < #items)
  if 0 < #items then
    self.itemListCtrl:ResetDatas(items, not noResetPosition)
    self:RefreshItemCellStates()
  end
  self.chosenListCtrl:ResetDatas(self:GetChosenItems())
  self:UpdateActiveLabel()
end

function QuickBuffSetPopUp:OnItemListUpdated()
  self:RefreshItemCellStates()
end

function QuickBuffSetPopUp:RefreshItemCellStates()
  local itemCells = self.itemListCtrl:GetCells()
  for i = 1, #itemCells do
    local cell = itemCells[i]
    local itemCount = cell.data and tonumber(cell.data.num) or 0
    if cell.icon then
      cell.icon.alpha = 0 < itemCount and 1 or 0.5
    end
  end
end

function QuickBuffSetPopUp:OnClickItem(cellCtl)
  if self.isClickOnItemListDisabled then
    self.isClickOnItemListDisabled = nil
    return
  end
  local data = cellCtl and cellCtl.data
  if not BagItemCell.CheckData(data) then
    return
  end
  local itemId = data.staticData.id
  if not self.selectedItems[itemId] then
    if self:GetSelectedCount() >= BagProxy.Instance:GetQuickBuffMaxSelectCount() then
      return
    end
    self.selectedItems[itemId] = true
  else
    self.selectedItems[itemId] = nil
  end
  self.isDirty = true
  self:UpdatePage(true)
end

function QuickBuffSetPopUp:OnLongPressItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.itemTipData = self.itemTipData or {
    funcConfig = _EmptyTable
  }
  self.itemTipData.itemdata = data
  self:ShowItemTip(self.itemTipData, cellCtl.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  self.isClickOnItemListDisabled = true
end

function QuickBuffSetPopUp:OnDeleteChosenItem(cellCtl)
  local data = cellCtl and cellCtl.data
  local itemId = data and data.staticData and data.staticData.id
  if not itemId then
    return
  end
  self.selectedItems[itemId] = nil
  self.isDirty = true
  self:UpdatePage(true)
end

function QuickBuffSetPopUp:RemoveAllChosenItems()
  if self:GetSelectedCount() == 0 then
    return
  end
  TableUtility.TableClear(self.selectedItems)
  self.isDirty = true
  self:UpdatePage(true)
end

function QuickBuffSetPopUp:ConfirmSelection()
  BagProxy.Instance:SetQuickBuffConfigItemIds(self:GetSelectedItemIds())
  self:CloseSelf()
end

function QuickBuffSetPopUp:UpdateActiveLabel()
  self.activeLabel.text = string.format(ZhString.QuickBuffSetPopUp_ActiveLabel, self:GetSelectedCount(), BagProxy.Instance:GetQuickBuffMaxSelectCount())
end
