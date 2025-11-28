RepositoryViewBagPage = class("RepositoryViewBagPage", SubView)
autoImport("ItemNormalList")
autoImport("RepositoryBagCombineItemCell")
local readyToPutInItems = {}

function RepositoryViewBagPage:Init()
  self:InitUI()
end

function RepositoryViewBagPage:InitUI()
  self.normalStick = self.container.normalStick
  self.rightBord = self:FindGO("rightBord")
  local listObj = self:FindGO("ItemNormalList", self.rightBord)
  self.itemlist = ItemNormalList.new(listObj, RepositoryBagCombineItemCell, nil, PullStopScrollView, true)
  self.itemlist.GetTabDatas = RepositoryViewBagPage.GetTabDatas
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickItemTab, self)
  self.itemCells = self.itemlist:GetItemCells()
  self.itemListScrollPanel = self.itemlist.scrollView.panel
  self.refreshSymbol = self:FindGO("RefreshSymbol", listObj)
  self.refreshSymbol:SetActive(true)
  self.refreshSymbolGrid = self:FindGO("Grid", self.refreshSymbol):GetComponent(UIGrid)
  self.storeBtn = self:FindGO("StoreButton")
  self:AddClickEvent(self.storeBtn, function()
    if self.lock then
      MsgManager.FloatMsg("", self.tip)
      return
    end
    self:SwitchMakeingMode(true)
  end)
  self.reArrayBtn = self:FindGO("RearrayButton", listObj)
  self:AddClickEvent(self.reArrayBtn, function()
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_MAIN)
  end)
  self.tip = string.format(ZhString.Repository_storeLv, GameConfig.Item.store_baselv_req)
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
    if not self.chooseAllSwitch and self.lock then
      MsgManager.FloatMsg("", self.tip)
      return
    end
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
  self.itemlist:ChooseTab(1)
  self:UpdateList()
end

local viewTabFuncConfigMap = {
  [1] = 32,
  [2] = 30,
  [3] = 62
}

function RepositoryViewBagPage:InitShow()
  self.viewTab = self.container.viewTab
  self.funcConfigId = viewTabFuncConfigMap[self.viewTab]
  self:SetCellsLock()
  self.lock = RepositoryViewProxy.Instance:CheckLockByLevel()
  self:UpdateChooseAllLabel()
end

function RepositoryViewBagPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  local go = cellCtl and cellCtl.gameObject
  local newChooseId = data and data.id or 0
  if self.markingMode and newChooseId ~= 0 then
    if self.lock then
      MsgManager.FloatMsg("", self.tip)
      return
    end
    local hasChosen = cellCtl.data.isMark
    if hasChosen then
      cellCtl.data.isMark = false
      cellCtl:UpdateCheckMark()
      TableUtility.ArrayRemove(readyToPutInItems, data.id)
      redlog("移除添加", data.id)
    elseif not self:CheckIsLock(data) then
      cellCtl.data.isMark = true
      cellCtl:UpdateCheckMark()
      if TableUtility.ArrayFindIndex(readyToPutInItems, data.id) == 0 then
        TableUtility.ArrayPushBack(readyToPutInItems, data.id)
        xdlog("添加", data.id)
      end
    else
      MsgManager.ShowMsgByID(38)
    end
    self:UpdateChooseAllLabel()
    return
  end
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowRepositoryItemTip(data, {go})
  else
    self.chooseId = 0
    self:ShowRepositoryItemTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function RepositoryViewBagPage:DoubleClickItem(cellCtl)
  if self.markingMode then
    return
  end
  local data = cellCtl.data
  if data then
    self.chooseId = 0
    self:ShowRepositoryItemTip()
    if RepositoryViewProxy.Instance:CheckLockByStrength(data) then
      MsgManager.ShowMsgByID(2001)
      return
    end
    if self.viewTab == RepositoryView.Tab.CommonTab then
      FunctionItemFunc.DepositRepositoryEvt(data)
    elseif self.viewTab == RepositoryView.Tab.RepositoryTab then
      FunctionItemFunc.PersonalDepositRepositoryEvt(data)
    elseif self.viewTab == RepositoryView.Tab.HomeTab and self.lock == false then
      FunctionItemFunc.HomeStoreIn(data)
    end
  end
end

function RepositoryViewBagPage:ClickItemTab(cell)
  self.nowItemTabIndex = cell.data and cell.data.index or 0
  self.refreshSymbolGrid:Reposition()
  self.chooseAllSwitch = false
  self:UpdateChooseAllLabel()
  xdlog("RepositoryViewBagPage:ClickItemTab")
end

function RepositoryViewBagPage:ShowRepositoryItemTip(data, ignoreBounds)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local callback = function()
    local itemdata = BagProxy.Instance:GetItemByGuid(self.chooseId)
    if itemdata and RepositoryViewProxy.Instance:CheckLockByStrength(itemdata) then
      MsgManager.ShowMsgByID(2001)
      return
    end
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local sdata = ReusableTable.CreateTable()
  sdata.itemdata = data
  sdata.funcConfig = {
    self.funcConfigId
  }
  sdata.ignoreBounds = ignoreBounds
  sdata.callback = callback
  if self.lock then
    sdata.tip = self.tip
  end
  self:ShowItemTip(sdata, self.normalStick, nil, {-180, 0})
  ReusableTable.DestroyAndClearTable(sdata)
end

function RepositoryViewBagPage:ShowPrompt()
  local data = self.container.repositoryViewItemPage.itemlist.chooseItemData
  if data then
    local index = 1
    for i = 1, #GameConfig.ItemPage do
      for j = 1, #GameConfig.ItemPage[i].types do
        if data.staticData.Type == GameConfig.ItemPage[i].types[j] then
          index = index + i
          break
        end
      end
    end
    MsgManager.ShowEightTypeMsgByIDTable(820, {
      self.container.repositoryViewItemPage.itemlist.chooseItemData.num
    }, self.itemlist.ItemTabLst[index].transform.position, {0, 10})
  end
end

function RepositoryViewBagPage:UpdateList(note)
  self.itemlist:UpdateList(true)
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

function RepositoryViewBagPage:HandleItemUpdate(note)
  self:UpdateList(note)
  self:SetCellsLock()
end

function RepositoryViewBagPage:HandleItemReArrage(note)
  self:PlayUISound(AudioMap.UI.ReArrage)
  self:UpdateList()
  self.itemlist:ScrollViewRevert()
  self:SetCellsLock()
end

function RepositoryViewBagPage:HandleLevelUp(note)
  self:SetCellsLock()
  self.lock = RepositoryViewProxy.Instance:CheckLockByLevel()
end

function RepositoryViewBagPage:SetCellsLock()
  for i = 1, #self.itemCells do
    self.itemCells[i]:SetCellLock()
  end
end

local tabDatas = {}

function RepositoryViewBagPage.GetTabDatas(itemTabConfig, tabData)
  TableUtility.ArrayClear(tabDatas)
  local datas = tabData.index ~= -1 and BagProxy.Instance.bagData:GetItems(itemTabConfig) or BagProxy.Instance:GetFavoriteItemDatas()
  if datas and #datas == 0 then
    return tabDatas
  end
  for i = 1, #datas do
    local tempData = datas[i]:Clone()
    if 0 < TableUtility.ArrayFindIndex(readyToPutInItems, tempData.id) then
      tempData.isMark = true
    end
    table.insert(tabDatas, tempData)
  end
  return tabDatas
end

function RepositoryViewBagPage:SwitchMakeingMode(on)
  local isOn = on == true and true or false
  self.markingMode = on
  self.markGetFromPackage:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  if not on then
    self:TrySendGetFromPackage()
  end
  local tmpClipRegion = self.itemListScrollPanel.baseClipRegion
  local refreshSymbolHeight = 92
  tmpClipRegion.y = on and -refreshSymbolHeight / 2 or 0
  tmpClipRegion.w = tmpClipRegion.w + refreshSymbolHeight * (on and -1 or 1)
  self.itemListScrollPanel.baseClipRegion = tmpClipRegion
end

function RepositoryViewBagPage:TrySendGetFromPackage()
  local datas = self.itemlist:GetDatas()
  for i = 1, #datas do
    datas[i].isMark = false
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

function RepositoryViewBagPage:MarkingChooseAll(bool)
  local datas = self.itemlist:GetDatas()
  for i = 1, #datas do
    if bool then
      if not self:CheckIsLock(datas[i]) and TableUtility.ArrayFindIndex(readyToPutInItems, datas[i].id) == 0 then
        TableUtility.ArrayPushBack(readyToPutInItems, datas[i].id)
        datas[i].isMark = bool
      end
    else
      TableUtility.ArrayRemove(readyToPutInItems, datas[i].id)
      datas[i].isMark = bool
    end
  end
  self.itemlist:SetData(datas, true)
  for _, cell in pairs(self.itemCells) do
    local guid = cell.data and cell.data.id
    if guid and not self:CheckIsLock(cell.data) then
      cell.data.isMark = bool
      cell:UpdateCheckMark()
    end
  end
  self:UpdateChooseAllLabel()
end

function RepositoryViewBagPage:CheckIsLock(itemData)
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

function RepositoryViewBagPage:UpdateChooseAllLabel()
  local datas = self.itemlist:GetDatas()
  self.chooseAllSwitch = false
  for i = 1, #datas do
    if datas[i].isMark then
      self.chooseAllSwitch = true
    end
  end
  if self.chooseAllSwitch then
    self.chooseAllBtn_Label.text = ZhString.Repository_CancelChooseAll
  else
    self.chooseAllBtn_Label.text = ZhString.Repository_ChooseAll
  end
end

local repositoryMap = {
  [1] = SceneItem_pb.EPACKTYPE_PERSONAL_STORE,
  [2] = SceneItem_pb.EPACKTYPE_STORE,
  [3] = SceneItem_pb.EPACKTYPE_HOME
}

function RepositoryViewBagPage:CallStorePutItemItemCmd()
  local toPackage = repositoryMap[self.viewTab]
  if not toPackage then
    redlog("仓库类型缺失")
    return
  end
  if self.lock then
    MsgManager.FloatMsg("", self.tip)
  end
  local packType, furniture = self.container:GetPackTypeFromViewTab(), HomeManager.Me().workingHomeStore
  furniture = furniture and furniture.data.id
  ServiceItemProxy.Instance:CallStorePutItemItemCmd(toPackage, readyToPutInItems, furniture)
end

function RepositoryViewBagPage:OnExit()
  RepositoryViewBagPage.super.OnExit(self)
  TableUtility.ArrayClear(readyToPutInItems)
end
