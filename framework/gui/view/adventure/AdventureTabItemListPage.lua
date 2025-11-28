autoImport("AdventureCombineItemCell")
autoImport("AdventureSmallCategoryCell")
autoImport("AdventureNormalList")
autoImport("AdventureUtil")
AdventureTabItemListPage = class("AdventureTabItemListPage", SubMediatorView)
AdventureTabItemListPage.ClickReward = "AdventureNpcListPage_ClickReward"

function AdventureTabItemListPage:Init()
  self.categoryDatas = {}
  self.isInited = false
end

function AdventureTabItemListPage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureTabItemListPage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:initView()
  self:AddEvents()
  self.isInited = true
  self:OnEnter()
end

function AdventureTabItemListPage:initView()
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  local tipHolder = self:FindGO("tipHolder")
  local listObj = self:FindGO("normalList")
  self.normalList = AdventureNormalList.new(listObj, tipHolder, AdventureCombineItemCell)
  self.normalList:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
  self.itemTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if self.selectTabData ~= data then
      self.selectTabData = data
      self:tabClick(self.selectTabData)
      self.normalList:SetPropData(nil, nil)
    end
  end, self, self:FindComponent("Panel", UIPanel).depth + 2)
  self.listCategories = UIGridListCtrl.new(self:FindComponent("gridTabs", UIGrid), AdventureSmallCategoryCell, "AdventureSmallCategoryCell")
  self.listCategories:AddEventListener(MouseEvent.MouseClick, self.HandleClickCategory, self)
end

function AdventureTabItemListPage:AddEvents()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
end

function AdventureTabItemListPage:setCategoryData(data)
  self:InitPage()
  self.data = data
  if self.curCategoryCell then
    self.curCategoryCell:Select(false)
    self.curCategoryCell = nil
  end
  local catagories = GameConfig.AdventureTypeCategoryTabs[data.staticData.id]
  if not catagories or #catagories < 1 then
    redlog("没有找到Category配置！")
    return
  end
  TableUtility.ArrayClear(self.categoryDatas)
  for i = 1, #catagories do
    self.categoryDatas[#self.categoryDatas + 1] = AdventureDataProxy.Instance.categoryDatas[catagories[i]]
  end
  self.listCategories:ResetDatas(self.categoryDatas)
  local cells = self.listCategories:GetCells()
  if cells and 0 < #cells then
    self:HandleClickCategory(cells[1])
  end
end

local listPopUpItems = {}

function AdventureTabItemListPage:HandleClickCategory(cell)
  if self.curCategoryCell == cell then
    if self.normalList and self.normalList.JumpToFirstClickableItem and not BackwardCompatibilityUtil.CompatibilityMode_V40 then
      self.normalList:JumpToFirstClickableItem(true)
    end
    return
  end
  if self.curCategoryCell then
    self.curCategoryCell:Select(false)
  end
  self.curCategoryCell = cell
  self.curCategoryCell:Select(true)
  if self.normalList then
    self.normalList:SetPropData(nil, nil)
  end
  self.realData = cell.data
  if not self.realData or not self.realData.childs then
    return
  end
  if self.normalList then
    self.normalList:removeTip()
  end
  if #listPopUpItems < 2 then
    self:Hide(self.itemTabs.gameObject)
    self:tabClick()
  else
    self:Show(self.itemTabs.gameObject)
    local tmpData = {
      id = AdventureItemNormalListPage.MaxCategory.id,
      Name = string.format(ZhString.AdventurePanel_AllTab, self.realData.staticData.Name)
    }
    local allRedTips = ReusableTable.CreateArray()
    local redTips
    for i = 1, #listPopUpItems do
      redTips = listPopUpItems[i].RidTip
      if redTips then
        for j = 1, #redTips do
          allRedTips[#allRedTips + 1] = redTips[j]
        end
      end
    end
    table.insert(listPopUpItems, 1, tmpData)
    self.itemTabs:SetData(listPopUpItems)
    self.itemTabs:RegisterTopRedTips(allRedTips, 35)
    ReusableTable.DestroyAndClearArray(allRedTips)
  end
  if self.normalList and self.normalList.JumpToFirstClickableItem and not BackwardCompatibilityUtil.CompatibilityMode_V40 then
    self.normalList:JumpToFirstClickableItem()
  end
end

function AdventureTabItemListPage:tabClick(selectTabData, noResetPos)
  if self.normalList then
    self.normalList:removeTip()
  end
  self.selectTabData = selectTabData
  if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
    self.normalList:setCategoryAndTab(self.realData, selectTabData)
  else
    self.normalList:setCategoryAndTab(self.realData, nil)
  end
  self:UpdateList(noResetPos)
end

function AdventureTabItemListPage:JumpToFirstClickableItem(force)
  if self.normalList and self.normalList.JumpToFirstClickableItem then
    self.normalList:JumpToFirstClickableItem(force)
  end
end

function AdventureTabItemListPage:UpdateList(noResetPos)
  self.normalList:UpdateList(noResetPos)
end

function AdventureTabItemListPage:HandleManualUpdate(note)
  AdventureUtil:DelayCallback(note, function(data)
    self:DelayHandleManualUpdate(data)
  end)
end

function AdventureTabItemListPage:DelayHandleManualUpdate(data)
  local result, adventureType = AdventureUtil:CheckManualUpdateData(data, "AdventureTabItemListPage")
  if not result then
    return nil
  end
  local data = data
  local type = data.update.type
  if self.realData and self.gameObject.activeSelf and self.realData.staticData.id == type then
    if self.selectTabData and self.selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self.normalList:setCategoryAndTab(self.realData, self.selectTabData)
    else
      self.normalList:setCategoryAndTab(self.realData, nil)
    end
    self:UpdateList(true)
  end
end

function AdventureTabItemListPage:updateCellTip(data)
  local cellCtl = data.ctrl
  local ret = data.ret
  if ret and cellCtl and cellCtl.data and cellCtl.data.staticData.RedTip then
    self:RegisterRedTipCheck(cellCtl.data.staticData.RedTip, cellCtl.bg, nil, {-15, -15})
  end
end

function AdventureTabItemListPage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureTabItemListPage.super.OnEnter(self)
  self.normalList:OnEnter()
end

function AdventureTabItemListPage:OnExit()
  if self.isInited then
    self.normalList:removeTip()
  end
  AdventureTabItemListPage.super.OnExit(self)
end

function AdventureTabItemListPage:Show(obj)
  if not obj and not self.isInited then
    return
  end
  AdventureTabItemListPage.super.Show(self, obj)
end

function AdventureTabItemListPage:Hide(obj)
  if not obj then
    if not self.isInited then
      return
    end
    self.normalList:removeTip()
  end
  AdventureTabItemListPage.super.Hide(self, obj)
end

function AdventureTabItemListPage:OnDestroy()
  if self.isInited then
    self.itemTabs:Destroy()
    self.normalList:OnExit()
  end
  AdventureTabItemListPage.super.OnDestroy(self)
end
