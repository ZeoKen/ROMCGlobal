PackageBarrowBagPage = class("PackageBarrowBagPage", SubView)
PackageBarrowBagPage.PfbPath = "part/BarrowBag"
local readyToGetItems = {}

function PackageBarrowBagPage:Init()
  self:AddViewEvts()
  self.initPage = false
end

function PackageBarrowBagPage:InitPage()
  self.initPage = true
  self.holder = self:FindGO("BarrowBagHolder")
  self.gameObject = self:LoadPreferb(PackageBarrowBagPage.PfbPath, self.holder, true)
  local closeBord = self:FindGO("CloseSpecialBord")
  self:AddClickEvent(closeBord, function(go)
    self.container:SetLeftViewState(PackageView.LeftViewState.Default)
  end)
  local listObj = self:FindGO("ItemNormalList")
  self.itemlist = ItemNormalList.new(listObj, BagCombineDragItemCell, nil, PullStopScrollView, true)
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickItem, self)
  self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.DoubleClickItem, self)
  self.itemlist:SetScrollPullDownEvent(PackageBarrowBagPage.PullDownPackage, self)
  self.itemlist.GetTabDatas = PackageBarrowBagPage.GetTabDatas
  
  function self.itemlist.scrollView.onDragStarted()
    self:ShowItemTip()
  end
  
  self.itemCells = self.itemlist:GetItemCells()
  self.itemListScrollPanel = self.itemlist.scrollView.panel
  self.refreshSymbol = self:FindGO("RefreshSymbol", listObj)
  self.refreshSymbol:SetActive(true)
  self.getOutBtn = self:FindGO("GetOutButton", listObj)
  self:AddClickEvent(self.getOutBtn, function()
    self:SwitchMakeingMode(true)
  end)
  self.reArrayBtn = self:FindGO("RearrayButton", listObj)
  self:AddClickEvent(self.reArrayBtn, function()
    self:PullDownPackage()
  end)
  self:AddButtonEvent("MarkGetFromBarrowFake", function()
    self:SwitchMakeingMode()
  end)
  self:AddButtonEvent("CancelBtn", function()
    TableUtility.ArrayClear(readyToGetItems)
    self:SwitchMakeingMode()
  end)
  self.markGetFromBarrow = self:FindGO("MarkGetFromBarrow")
  self.markGetFromBarrow:SetActive(false)
  self.normalStick = self.container.normalStick
end

local tabDatas = {}

function PackageBarrowBagPage.GetTabDatas(tabConfig)
  TableUtility.ArrayClear(tabDatas)
  local bagData = BagProxy.Instance.barrowBag
  local datas = bagData:GetItems(tabConfig)
  for i = 1, #datas do
    table.insert(tabDatas, datas[i])
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
  local leftEmpty = (5 - #tabDatas % 5) % 5
  for i = 1, 10 + leftEmpty do
    table.insert(tabDatas, BagItemEmptyType.Grey)
  end
  for i = #tabDatas + 1, 35 do
    table.insert(tabDatas, BagItemEmptyType.Grey)
  end
  return tabDatas
end

function PackageBarrowBagPage:PullDownPackage()
  self:RemoveReArrageSafeLT()
  self.reArrageSafeLT = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self:HandleItemReArrage()
  end, self)
  ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_BARROW)
end

function PackageBarrowBagPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data == "Empty" or data == "Grey" then
    data = nil
  end
  local newChooseId = data and data.id or 0
  if self.markingMode and newChooseId ~= 0 then
    local hasChosen = cellCtl.data.isMark
    if hasChosen then
      cellCtl.data.isMark = false
      cellCtl:UpdateCheckMark()
      TableUtility.ArrayRemove(readyToGetItems, data.id)
      redlog("移除添加", data.id)
    else
      cellCtl.data.isMark = true
      cellCtl:UpdateCheckMark()
      if TableUtility.ArrayFindIndex(readyToGetItems, data.id) == 0 then
        TableUtility.ArrayPushBack(readyToGetItems, data.id)
        xdlog("添加", data.id)
      end
    end
    return
  end
  local go = cellCtl and cellCtl.gameObject
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowPackageItemTip(data, {go})
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function PackageBarrowBagPage:DoubleClickItem(cellCtl)
  if self.markingMode then
    return
  end
  local data = cellCtl.data
  if data == "Empty" or data == "Grey" then
    data = nil
  end
  if data then
    local funcId = 38
    if type(funcId) == "number" then
      local func = FunctionItemFunc.Me():GetFuncById(funcId)
      if type(func) == "function" then
        func(data)
      end
    end
    self:ShowPackageItemTip()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
end

function PackageBarrowBagPage:ShowPackageItemTip(data, ignoreBounds)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local callback = function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local sdata = {
    itemdata = data,
    funcConfig = {38},
    ignoreBounds = ignoreBounds,
    callback = callback
  }
  self:ShowItemTip(sdata, self.normalStick, nil, {210, 0})
end

function PackageBarrowBagPage:Open()
  if self.initPage == false then
    self:InitPage()
  end
  self.itemlist:ChooseTab(1)
  BagProxy.Instance:SetBarrowOpen(true)
end

function PackageBarrowBagPage:Close()
  self:RemoveReArrageSafeLT()
  self.chooseId = 0
  self:ShowPackageItemTip()
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_BARROW)
  BagProxy.Instance:SetBarrowOpen(false)
  TableUtility.ArrayClear(readyToGetItems)
end

function PackageBarrowBagPage:UpdateList()
  self.itemlist:UpdateList(true)
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
  local cells = self.itemlist:GetItemCells()
  for _, cell in pairs(cells) do
    local guid = cell.data and cell.data.id
    if guid then
      if TableUtility.ArrayFindIndex(readyToGetItems, guid) > 0 then
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

function PackageBarrowBagPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.BarrowUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.ItemReArrage, self.HandleItemReArrage)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleItemUpdate)
end

function PackageBarrowBagPage:HandleItemReArrage(note)
  if not self.initPage then
    return
  end
  self:RemoveReArrageSafeLT()
  self:PlayUISound(AudioMap.UI.ReArrage)
  local callback = function()
    self:UpdateList()
  end
  self.itemlist:ScrollViewRevert(callback)
end

function PackageBarrowBagPage:HandleItemUpdate()
  if not self.initPage then
    return
  end
  self:UpdateList()
end

function PackageBarrowBagPage:RemoveReArrageSafeLT()
  if self.reArrageSafeLT then
    self.reArrageSafeLT:Destroy()
    self.reArrageSafeLT = nil
  end
end

function PackageBarrowBagPage:OnDestroy()
  if not self.initPage then
    return
  end
  helplog("OnDestroy")
  self.itemlist:OnExit()
end

function PackageBarrowBagPage:SwitchMakeingMode(on)
  local isOn = on == true and true or false
  self.markingMode = on
  self.markGetFromBarrow:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  if not on then
    self:TrySendGetFromBarrow()
  end
  local tmpClipRegion = self.itemListScrollPanel.baseClipRegion
  local refreshSymbolHeight = 92
  tmpClipRegion.y = on and -refreshSymbolHeight / 2 or 0
  tmpClipRegion.w = tmpClipRegion.w + refreshSymbolHeight * (on and -1 or 1)
  self.itemListScrollPanel.baseClipRegion = tmpClipRegion
end

function PackageBarrowBagPage:TrySendGetFromBarrow()
  for _, cell in pairs(self.itemCells) do
    local guid = cell.data and cell.data.id
    if guid then
      cell.data.isMark = false
      cell:UpdateCheckMark()
    end
  end
  if next(readyToGetItems) then
    self:CallStoreOffItemItemCmd()
    TableUtility.ArrayClear(readyToGetItems)
  end
  GameFacade.Instance:sendNotification(ItemEvent.ItemReArrage)
end

function PackageBarrowBagPage:CallStoreOffItemItemCmd()
  ServiceItemProxy.Instance:CallStoreOffItemItemCmd(SceneItem_pb.EPACKTYPE_BARROW, readyToGetItems, furniture)
end
