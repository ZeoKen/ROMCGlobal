AdventureResearchPage = class("AdventureResearchPage", SubMediatorView)
autoImport("AdventureResearchCategoryCell")
autoImport("AdventureResearchDescriptionCell")
autoImport("AdventureResearchCombineItemCell")
autoImport("AdventureUtil")
AdventureResearchPage.ShowFilterConditionId = 10001
AdventureResearchPage.DataFromMenuId = 10004

function AdventureResearchPage:Init()
  self.LRUTextureCache = {}
  self.isInited = false
end

function AdventureResearchPage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureResearchPage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:AddViewEvts()
  self:initView()
  self.cureTab = nil
  self.maxCache = 100
  self.selectData = nil
  self.professionSelected = false
  self.isInited = true
  self:OnEnter()
end

function AdventureResearchPage:initData()
  local categorys = AdventureDataProxy.Instance:getTabsByCategory(SceneManual_pb.EMANUALTYPE_RESEARCH)
  local list = {}
  for k, v in pairs(categorys.childs) do
    table.insert(list, v)
  end
  table.sort(list, function(l, r)
    return l.staticData.Order < r.staticData.Order
  end)
  self.researchCategoryGrid:ResetDatas(list)
end

function AdventureResearchPage:initView()
  self.categoryScrollView = self:FindComponent("ResearchCategoryScrollView", UIScrollView)
  local ResearchTabTitle = self:FindComponent("ResearchTabTitle", UILabel)
  ResearchTabTitle.text = ZhString.AdventurePanel_ResearchTabTitle
  self.FilterCondition = self:FindComponent("FilterCondition", UIToggle)
  self.FilterConditionLabel = self:FindComponent("Label", UILabel, self.FilterCondition.gameObject)
  self.FilterConditionLabel.text = ZhString.AdventurePanel_FilterConditionLabel
  self:AddClickEvent(self.FilterCondition.gameObject, function(obj)
    self.professionSelected = self.FilterCondition.value
    self:tabClick(self.selectTabData)
  end)
  local ResearchCategoryGrid = self:FindComponent("ResearchCategoryGrid", UIGrid)
  self.researchCategoryGrid = UIGridListCtrl.new(ResearchCategoryGrid, AdventureResearchCategoryCell, "AdventureResearchCategoryCell")
  self.researchCategoryGrid:AddEventListener(MouseEvent.MouseClick, self.categoryCellClick, self)
  self.ResearchDescriptionList = self:FindGO("ResearchDescriptionList")
  self.ResearchDescScrollView = self:FindComponent("ItemScrollView", ROUIScrollView, self.ResearchDescriptionList)
  local descGrid = self:FindComponent("ResearchDescriptionGrid", UIGrid)
  self.descriptionGrid = UIGridListCtrl.new(descGrid, AdventureResearchDescriptionCell, "AdventureResearchDescriptionCell")
  self.descriptionGrid:AddEventListener(MouseEvent.MouseClick, self.descCellClick, self)
  self.OneItemTabs = self:FindGO("OneItemTabs"):GetComponent(UILabel)
  self.itemTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if self.selectTabData ~= data then
      self.selectTabData = data
      self:tabClick(self.selectTabData)
    end
  end, self, self:FindComponent("Panel", UIPanel).depth + 2)
  self:initItemWraperView()
end

function AdventureResearchPage:initItemWraperView()
  self.ResearchItemList = self:FindGO("ResearchItemList")
  local itemContainer = self:FindGO("bag_itemContainer")
  local rt = Screen.height / Screen.width
  if 0.5625 < rt then
    pfbNum = 10
  end
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = pfbNum,
    cellName = "AdventureBagCombineItemCell",
    control = AdventureResearchCombineItemCell,
    dir = 1
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.ItemWraperScrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  
  function self.ItemWraperScrollView.OnStop()
    self.ItemWraperScrollView:Revert()
  end
  
  self.tipHolder = self:FindComponent("ScrollBg", UIWidget, self.ResearchItemList)
end

function AdventureResearchPage:categoryCellClick(cellCtl)
  self:setCategoryData(cellCtl.data)
  local cells = self.researchCategoryGrid:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local cell = cells[i]
      if cell == cellCtl then
        cell:setSelected(true)
      else
        cell:setSelected(false)
      end
    end
  end
end

function AdventureResearchPage:descCellClick(cellCtl)
  local data = cellCtl.data
  if data then
    local GotoMode = data.GotoMode
    FuncShortCutFunc.Me():CallByID(GotoMode)
  end
end

function AdventureResearchPage:setCategoryData(data)
  self.data = data
  local list = {}
  if data and data.classifys and #data.classifys > 0 then
    for i = 1, #data.classifys do
      local single = data.classifys[i]
      table.insert(list, single)
    end
    table.sort(list, function(l, r)
      return l.Order < r.Order
    end)
    local allRedTips = ReusableTable.CreateArray()
    if #list < 2 then
      list = {}
      self:Hide(self.itemTabs.gameObject)
      self.OneItemTabs.text = data.staticData.Name
      self:Show(self.OneItemTabs.gameObject)
      helplog("@14")
      self:tabClick()
    else
      self:Hide(self.OneItemTabs)
      self:Show(self.itemTabs.gameObject)
      local tmpData = {
        id = AdventureItemNormalListPage.MaxCategory.id,
        Name = string.format(ZhString.AdventurePanel_AllTab, data.staticData.Name)
      }
      local redTips
      for i = 1, #list do
        redTips = list[i].RidTip
        if redTips then
          for j = 1, #redTips do
            allRedTips[#allRedTips + 1] = redTips[j]
          end
        end
      end
      table.insert(list, 1, tmpData)
    end
    self.itemTabs:SetData(list)
    self.itemTabs:RegisterTopRedTips(allRedTips, 35)
    ReusableTable.DestroyAndClearArray(allRedTips)
    if data.staticData.id == AdventureResearchPage.ShowFilterConditionId then
      self:Show(self.FilterCondition.gameObject)
    else
      self:Hide(self.FilterCondition.gameObject)
    end
  else
    self:Hide(self.FilterCondition.gameObject)
    self:Hide(self.itemTabs.gameObject)
    self:Hide(self.OneItemTabs)
    helplog("@15")
    self:tabClick()
  end
end

function AdventureResearchPage:tabClick(selectTabData, noResetPos)
  if not self.data then
    return
  end
  self.selectTabData = selectTabData
  self:resetSelectState()
  if self.data.staticData.id == AdventureResearchPage.DataFromMenuId then
    helplog("@1")
    self:Hide(self.ResearchItemList)
    self:Show(self.ResearchDescriptionList)
    local descDatas = {}
    for k, v in pairs(Table_GameFunction) do
      table.insert(descDatas, v)
    end
    table.sort(descDatas, function(l, r)
      return l.Order < r.Order
    end)
    table.sort(descDatas, function(l, r)
      if FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) and FunctionUnLockFunc.Me():CheckCanOpen(r.MenuID) then
        return l.Order < r.Order
      elseif FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) then
        return true
      else
        return false
      end
    end)
    self.descriptionGrid:ResetDatas(descDatas)
  else
    helplog("@2")
    self:Hide(self.ResearchDescriptionList)
    self:Show(self.ResearchItemList)
    local datas
    if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      datas = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(self.data.staticData.id, self.professionSelected, selectTabData.id)
    else
      datas = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(self.data.staticData.id, self.professionSelected, nil)
    end
    local result = {}
    local collaborEquipBanned = FunctionUnLockFunc.checkFuncStateValid(16)
    local bannedList = Table_FuncState[16] and Table_FuncState[16].ItemID
    for i = 1, #datas do
      if collaborEquipBanned or TableUtility.ArrayFindIndex(bannedList, datas[i].staticData.id) == 0 then
        table.insert(result, datas[i])
      end
    end
    self:SetData(result, noResetPos)
  end
end

function AdventureResearchPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.HandleNUserNewMenu)
end

function AdventureResearchPage:HandleManualUpdate(note)
  AdventureUtil:DelayCallback(note, function(data)
    self:DelayHandleManualUpdate(data)
  end)
end

function AdventureResearchPage:DelayHandleManualUpdate(data)
  local result, adventureType = AdventureUtil:CheckManualUpdateData(data, "AdventureResearchPage")
  if not result then
    return nil
  end
  helplog("@11")
  self:tabClick(self.selectTabData, true)
end

function AdventureResearchPage:HandleNUserNewMenu(note)
  self:Log("HandleNUserNewMenu")
end

function AdventureResearchPage:OnExit()
  if self.isInited then
    self:ClearSelectData()
  end
  AdventureResearchPage.super.OnExit(self)
end

function AdventureResearchPage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureResearchPage.super.OnEnter(self)
  self:ClearSelectData()
end

function AdventureResearchPage:resetSelectState(datas, noResetPos)
  if not noResetPos and self.gameObject.activeSelf then
    if self.wraplist then
      self.wraplist:ResetPosition()
    end
    if self.chooseItem and self.chooseItemData then
      self.chooseItemData:setIsSelected(false)
      self.chooseItem:setIsSelected(false)
    end
    self:ClearSelectData()
  end
end

function AdventureResearchPage:ShowSelf(obj)
  self:InitPage()
  self:Show()
  self:initData()
  local cells = self.researchCategoryGrid:GetCells()
  if cells and 0 < #cells then
    local cell = cells[1]
    self:categoryCellClick(cell)
  end
  self.categoryScrollView:ResetPosition()
end

function AdventureResearchPage:SetData(datas, noResetPos)
  datas = datas or {}
  self:resetSelectState(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 5)
  self.wraplist:UpdateInfo(newdata)
  self.selectData = nil
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end

function AdventureResearchPage:getDefaultSelectedItemData()
  local cells = self:GetItemCells() or {}
  if 0 < #cells then
    if self.chooseItemData then
      for i = 1, #cells do
        local single = cells[i]
        if single.data then
          return single
        end
      end
    else
      for i = 1, #cells do
        local cell = cells[i]
        if cell.data then
          return cell
        end
      end
    end
  end
end

function AdventureResearchPage:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = datas[i]
    end
  end
  return self.unitData
end

function AdventureResearchPage:HandleClickItem(cellCtl, noClickSound)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    if self.chooseItem ~= cellCtl or data ~= self.chooseItemData then
      if self.chooseItemData then
        self.chooseItemData:setIsSelected(false)
      end
      if self.chooseItem then
        self.chooseItem:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      data:setIsSelected(true)
      cellCtl:setIsSelected(true)
      self:ShowItemTip(data)
      self.chooseItem = cellCtl
      self.chooseItemData = data
    elseif self.chooseItem == cellCtl or data == self.chooseItemData then
      self:ClearSelectData()
    end
  end
end

local catTipOffsetY, itemTipOffsetY = 0, 347
local qMakeEquipProductMap, qMakeFuncConfig = {}, {70}

function AdventureResearchPage:ShowItemTip(data)
  if not self.tipOffset then
    self.tipOffset = {200, 0}
  end
  if data.type == SceneManual_pb.EMANUALTYPE_MATE then
    self.tipOffset[2] = catTipOffsetY
    TipManager.Instance:ShowCatTipById(data:getCatId(), self.tipHolder, NGUIUtil.AnchorSide.Right, self.tipOffset)
  else
    self.tipOffset[2] = itemTipOffsetY
    self.itemTipData = self.itemTipData or {
      itemdata = ItemData.new(),
      ignoreBounds = {
        self.wraplist.panel.gameObject
      }
    }
    self.itemTipData.itemdata:ResetData(data.id, data.staticId)
    local equipInfo = self.itemTipData.itemdata.equipInfo
    if equipInfo and equipInfo:IsNextGen() then
      equipInfo.isRandomPreview = true
    end
    if not next(qMakeEquipProductMap) and ItemData.CheckIsEquip(data.staticId) then
      for _, d in pairs(Table_Compose) do
        if d.Type == 2 and d.Category == 1 and d.Product and d.Product.id and FunctionUnLockFunc.Me():CheckCanOpen(d.MenuID) then
          qMakeEquipProductMap[d.Product.id] = true
        end
      end
    end
    self.itemTipData.funcConfig = qMakeEquipProductMap[data.staticId] and qMakeFuncConfig or _EmptyTable
    TipManager.Instance:ShowItemFloatTip(self.itemTipData, self.tipHolder, NGUIUtil.AnchorSide.Right, self.tipOffset)
  end
end

function AdventureResearchPage:ClearSelectData()
  if self.chooseItemData then
    self.chooseItemData:setIsSelected(false)
  end
  if self.chooseItem then
    self.chooseItem:setIsSelected(false)
  end
  self.chooseItem = nil
  self.chooseItemData = nil
  TipManager.Instance:HideCatTip()
end

function AdventureResearchPage:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
  local result = {}
  for i = 1, #combineCells do
    local v = combineCells[i]
    local childs = v:GetCells()
    for i = 1, #childs do
      table.insert(result, childs[i])
    end
  end
  return result
end

function AdventureResearchPage:Show(target)
  if not target and not self.isInited then
    return
  end
  AdventureResearchPage.super.Show(self, target)
end

function AdventureResearchPage:Hide(target)
  if not target then
    if not self.isInited then
      return
    end
    if self.data then
      self:resetSelectState()
    end
  end
  AdventureResearchPage.super.Hide(self, target)
end

function AdventureResearchPage:OnDestroy()
  if self.isInited then
    self.itemTabs:Destroy()
    if self.wraplist then
      self.wraplist:Destroy()
    end
    self:ClearSelectData()
  end
  AdventureResearchPage.super.OnDestroy(self)
end
