RepositoryViewItemPage = class("RepositoryViewItemPage", SubView)
autoImport("ItemNormalList")
autoImport("RepositoryItemCombineItemCell")
local readyToGetItems = {}

function RepositoryViewItemPage:Init()
  self:InitUI()
end

function RepositoryViewItemPage:InitUI()
  self.normalStick = self.container.normalStick
  self.leftBord = self:FindGO("leftBord")
  local listObj = self:FindGO("ItemNormalList", self.leftBord)
  self.itemlist = ItemNormalList.new(listObj, RepositoryItemCombineItemCell, nil, PullStopScrollView)
  self.itemlist.PullRefreshTip = ZhString.RepositoryNormalList_PullRefresh
  self.itemlist.BackRefreshTip = ZhString.RepositoryNormalList_CanRefresh
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickItemTab, self)
  self.itemlist:SetTabToggleGroup(13)
  self.itemlist:ChooseTab(1)
  self.itemCells = self.itemlist:GetItemCells()
  self.itemListScrollPanel = self.itemlist.scrollView.panel
  self.refreshSymbol = self:FindGO("RefreshSymbol", listObj)
  self.refreshSymbol:SetActive(true)
  self.getOutBtn = self:FindGO("GetOutButton")
  self:AddClickEvent(self.getOutBtn, function()
    if self.lock then
      MsgManager.FloatMsg("", self.tip)
      return
    end
    self:SwitchMakeingMode(true)
  end)
  self.reArrayBtn = self:FindGO("RearrayButton", listObj)
  self:AddClickEvent(self.reArrayBtn, function()
    xdlog("整理仓库")
    ServiceItemProxy.Instance:CallPackageSort(self.container:GetPackTypeFromViewTab())
  end)
  self.markGetFromRepository = self:FindGO("MarkGetFromRepository")
  self.markGetFromRepository:SetActive(false)
  local markGetFromRepositoryFake = self:FindGO("MarkGetFromRepositoryFake", self.markGetFromPackage)
  local markGetFromRepositoryFake_Label = self:FindGO("Label", markGetFromRepositoryFake):GetComponent(UILabel)
  markGetFromRepositoryFake_Label.text = ZhString.Repository_GetOut
  self:AddButtonEvent("MarkGetFromRepositoryFake", function()
    self:SwitchMakeingMode()
  end)
  self.cancelBtn = self:FindGO("CancelBtn", self.markGetFromRepositor)
  self:AddClickEvent(self.cancelBtn, function()
    TableUtility.TableClear(readyToGetItems)
    self:SwitchMakeingMode()
  end)
  self.tip = string.format(ZhString.Repository_takeoutLv, GameConfig.Item.store_takeout_baselv_req)
end

local viewTabFuncConfigMap = {
  [1] = 33,
  [2] = 31,
  [3] = 63
}
local callPackageSort = function(bagType)
  ServiceItemProxy.Instance:CallPackageSort(bagType)
end

function RepositoryViewItemPage:InitShow()
  self.viewTab = self.container.viewTab
  self.funcConfigId = viewTabFuncConfigMap[self.viewTab]
  self.itemlist:SetScrollPullDownEvent(callPackageSort, self.container:GetPackTypeFromViewTab())
  if self.viewTab == RepositoryView.Tab.RepositoryTab then
    self.itemlist.GetTabDatas = RepositoryViewItemPage.RepositoryTab
  elseif self.viewTab == RepositoryView.Tab.CommonTab then
    self.itemlist.GetTabDatas = RepositoryViewItemPage.CommonTab
  elseif self.viewTab == RepositoryView.Tab.HomeTab then
    self.itemlist.GetTabDatas = RepositoryViewItemPage.HomeTab
  end
  self:HandleItemUpdate()
  self:SetCellsLock()
  self.lock = not RepositoryViewProxy.Instance:CanTakeOut()
end

function RepositoryViewItemPage.RepositoryTab(tabConfig)
  return RepositoryViewItemPage.GetTabDatas(BagProxy.Instance:GetPersonalRepositoryBagData(), tabConfig)
end

function RepositoryViewItemPage.CommonTab(tabConfig)
  return RepositoryViewItemPage.GetTabDatas(BagProxy.Instance:GetRepositoryBagData(), tabConfig)
end

local checkIsInMarriageHouse = function()
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  return curHouseData ~= nil and curHouseData:IsMarriageHouse()
end
local homeTabDataFilter = function(item)
  return not item.homeOwnerId or item.homeOwnerId == FunctionLogin.Me():getLoginData().accid
end

function RepositoryViewItemPage.HomeTab(tabConfig)
  return RepositoryViewItemPage.GetTabDatas(BagProxy.Instance:GetHomeRepositoryBagData(), tabConfig, not checkIsInMarriageHouse() and homeTabDataFilter or nil)
end

local tabDatas = {}

function RepositoryViewItemPage.GetTabDatas(bagData, tabConfig, filter)
  TableUtility.ArrayClear(tabDatas)
  local datas = bagData:GetItems(tabConfig)
  if datas and #datas == 0 then
    return false
  end
  for i = 1, #datas do
    if not filter or filter(datas[i]) then
      local tempData = datas[i]:Clone()
      table.insert(tabDatas, tempData)
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
  if bagData.type == BagProxy.BagType.PersonalStorage then
    local unlockData = BagProxy.Instance:GetBagUnlockSpaceData()
    if unlockData then
      table.insert(tabDatas, {
        id = BagItemEmptyType.Unlock,
        unlockData = unlockData
      })
    end
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

function RepositoryViewItemPage:OnExit()
  RepositoryViewItemPage.super.OnExit(self)
  TableUtility.TableClear(readyToGetItems)
end

function RepositoryViewItemPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data ~= nil and data.id == BagItemEmptyType.Unlock then
    MsgManager.ShowMsgByIDTable(3108, {
      data.unlockData.id,
      data.unlockData.pstore
    })
    return
  end
  local go = cellCtl and cellCtl.gameObject
  local newChooseId = data and data.id or 0
  if self.markingMode and newChooseId ~= 0 then
    if self.lock then
      MsgManager.FloatMsg("", self.tip)
      return
    end
    local curChosenGetItems = readyToGetItems[self.viewTab] or {}
    local hasChosen = cellCtl.data.isMark
    if hasChosen then
      cellCtl.data.isMark = false
      cellCtl:UpdateCheckMark()
      TableUtility.ArrayRemove(curChosenGetItems, data.id)
    else
      cellCtl.data.isMark = true
      cellCtl:UpdateCheckMark()
      if TableUtility.ArrayFindIndex(curChosenGetItems, data.id) == 0 then
        TableUtility.ArrayPushBack(curChosenGetItems, data.id)
      end
    end
    readyToGetItems[self.viewTab] = curChosenGetItems
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

function RepositoryViewItemPage:DoubleClickItem(cellCtl)
  if self.markingMode then
    return
  end
  local data = cellCtl.data
  if data then
    self.chooseId = 0
    self:ShowRepositoryItemTip()
    if self.viewTab == RepositoryView.Tab.RepositoryTab then
      FunctionItemFunc.PersonalWthdrawnRepositoryEvt(data)
    elseif self.viewTab == RepositoryView.Tab.CommonTab then
      FunctionItemFunc.WthdrawnRepositoryEvt(data)
    elseif self.viewTab == RepositoryView.Tab.HomeTab then
      FunctionItemFunc.HomeStoreOut(data)
    end
  end
end

function RepositoryViewItemPage:ClickItemTab()
  local cells = self.itemlist:GetItemCells()
  local curChosenGetItems = readyToGetItems[self.viewTab] or {}
  for _, c in pairs(cells) do
    c:SetShowGender(self.viewTab == RepositoryView.Tab.HomeTab and checkIsInMarriageHouse())
    local guid = c.data and c.data.id
    if guid then
      if TableUtility.ArrayFindIndex(curChosenGetItems, guid) > 0 then
        c.data.isMark = true
        c:UpdateCheckMark()
      else
        c.data.isMark = false
        c:UpdateCheckMark()
      end
    else
      c:UpdateCheckMark()
    end
  end
end

local tipOffset = {180, 0}

function RepositoryViewItemPage:ShowRepositoryItemTip(data, ignoreBounds)
  if not BagItemCell.CheckData(data) then
    self:ShowItemTip()
    return
  end
  local callback = function()
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
  self:ShowItemTip(sdata, self.normalStick, nil, tipOffset)
  ReusableTable.DestroyAndClearTable(sdata)
end

function RepositoryViewItemPage:ShowPrompt()
  local data = self.container.repositoryViewBagPage.itemlist.chooseItemData
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
      self.container.repositoryViewBagPage.itemlist.chooseItemData.num
    }, self.itemlist.ItemTabLst[index].transform.position, {0, 10})
  end
end

function RepositoryViewItemPage:UpdateList(noResetPos)
  self.itemlist:UpdateList(noResetPos)
  local curChosenGetItems = readyToGetItems[self.viewTab] or {}
  local cells = self.itemlist:GetItemCells()
  for _, cell in pairs(cells) do
    local guid = cell.data and cell.data.id
    if guid then
      if TableUtility.ArrayFindIndex(curChosenGetItems, guid) > 0 then
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

function RepositoryViewItemPage:HandleItemUpdate(note)
  self:UpdateList(true)
end

function RepositoryViewItemPage:HandleItemReArrage(note)
  self:PlayUISound(AudioMap.UI.ReArrage)
  self:UpdateList()
  self.itemlist:ScrollViewRevert()
end

function RepositoryViewItemPage:HandleLevelUp(note)
  self:SetCellsLock()
  self.lock = not RepositoryViewProxy.Instance:CanTakeOut()
end

function RepositoryViewItemPage:SetCellsLock()
  for i = 1, #self.itemCells do
    self.itemCells[i]:SetCellLock()
  end
end

function RepositoryViewItemPage:CallOneClickPutStore(itemPageIndex)
  if not itemPageIndex or itemPageIndex <= 0 then
    redlog("Invalid ItemPageIndex:", itemPageIndex)
    return
  end
  local packType, furniture = self.container:GetPackTypeFromViewTab(), HomeManager.Me().workingHomeStore
  if not packType then
    return
  end
  furniture = furniture and furniture.data.id
  ServiceItemProxy.Instance:CallOneClickPutTakeStoreCmd(SceneItem_pb.EPACKTYPE_MAIN, packType, itemPageIndex, furniture)
end

function RepositoryViewItemPage:SwitchMakeingMode(on)
  local isOn = on == true and true or false
  self.markingMode = on
  self.markGetFromRepository:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  if not on then
    self:TrySendGetFromRepository()
  end
  local tmpClipRegion = self.itemListScrollPanel.baseClipRegion
  local refreshSymbolHeight = 92
  tmpClipRegion.y = on and -refreshSymbolHeight / 2 or 0
  tmpClipRegion.w = tmpClipRegion.w + refreshSymbolHeight * (on and -1 or 1)
  self.itemListScrollPanel.baseClipRegion = tmpClipRegion
end

function RepositoryViewItemPage:TrySendGetFromRepository()
  for _, cell in pairs(self.itemCells) do
    local guid = cell.data and cell.data.id
    if guid then
      cell.data.isMark = false
      cell:UpdateCheckMark()
    end
  end
  local tryCall = false
  for _, guids in pairs(readyToGetItems) do
    if guids and 0 < #guids then
      tryCall = true
      break
    end
  end
  if tryCall then
    self:CallStoreOffItemItemCmd()
    TableUtility.TableClear(readyToGetItems)
  end
  GameFacade.Instance:sendNotification(ItemEvent.ItemReArrage)
end

local repositoryMap = {
  [1] = SceneItem_pb.EPACKTYPE_PERSONAL_STORE,
  [2] = SceneItem_pb.EPACKTYPE_STORE,
  [3] = SceneItem_pb.EPACKTYPE_HOME
}

function RepositoryViewItemPage:CallStoreOffItemItemCmd()
  local packType, furniture = self.container:GetPackTypeFromViewTab(), HomeManager.Me().workingHomeStore
  if not packType then
    return
  end
  furniture = furniture and furniture.data.id
  for viewTab, guids in pairs(readyToGetItems) do
    local fromPackage = repositoryMap[viewTab]
    if not fromPackage then
      redlog("缺少仓库枚举")
    end
    if guids and 0 < #guids then
      ServiceItemProxy.Instance:CallStoreOffItemItemCmd(fromPackage, guids, furniture)
    end
  end
end
