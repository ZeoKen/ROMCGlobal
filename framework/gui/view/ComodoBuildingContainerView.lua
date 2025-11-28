autoImport("CommonNewTabListCell")
autoImport("ComodoBuildingSubPage")
ComodoBuildingContainerView = class("ComodoBuildingContainerView", ContainerView)
ComodoBuildingContainerView.ViewType = UIViewType.NormalLayer
ComodoBuildingContainerView.ViewMaskAdaption = {all = 1}
ComodoBuildingContainerView.BuildingIdExtraPagesMap = {
  [817420] = {
    "ComodoBuildingSendPage"
  },
  [817425] = {
    "ComodoBuildingFurniturePage"
  },
  [817426] = {
    "ComodoBuildingSmithingPage"
  }
}
ComodoBuildingContainerView.PageNameTabIconMap = {
  ComodoBuildingUpgradePage = "Disney_yhqd_btn_upgrade",
  ComodoBuildingFurniturePage = "139",
  ComodoBuildingSendPage = "Disney_yhqd_btn_send",
  ComodoBuildingSmithingPage = "tab_icon_86"
}

function ComodoBuildingContainerView:Init()
  self.pageContainer = self:FindGO("PageContainer")
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.tabGrid = self:FindComponent("TabGrid", UIGrid)
  self.tabCtrl = ListCtrl.new(self.tabGrid, CommonNewTabListCell, "CommonNewTabListCell")
  self.tabCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickTab, self)
  self.tabCells = self.tabCtrl:GetCells()
  self:SelectSubPages()
  self:InitSubPages()
  self:UpdateTabGrid()
  self:AddEvents()
end

function ComodoBuildingContainerView:SelectSubPages()
  self.buildingId = self.viewdata.viewdata and self.viewdata.viewdata.buildingId
  if not self.buildingId then
    LogUtility.Error("Cannot get buildingId from viewdata!")
  end
  self.pageNames = {}
  TableUtility.ArrayPushBack(self.pageNames, "ComodoBuildingUpgradePage")
  local extraPages = self.buildingId and self.BuildingIdExtraPagesMap[self.buildingId]
  if extraPages then
    for i = 1, #extraPages do
      TableUtility.ArrayPushBack(self.pageNames, extraPages[i])
    end
  end
end

function ComodoBuildingContainerView:InitSubPages()
  local name
  for i = 1, #self.pageNames do
    name = self.pageNames[i]
    autoImport(name)
    self:AddSubView(i, _G[name])
  end
end

function ComodoBuildingContainerView:UpdateTabGrid()
  local datas, element, icon = ReusableTable.CreateArray()
  for i = 1, #self.pageNames do
    icon = self.PageNameTabIconMap[self.pageNames[i]]
    if icon then
      element = ReusableTable.CreateTable()
      element.index = #datas + 1
      element.icon = icon
      TableUtility.ArrayPushBack(datas, element)
    end
  end
  self.tabCtrl:ResetDatas(datas)
  for _, t in pairs(datas) do
    ReusableTable.DestroyAndClearTable(t)
  end
  ReusableTable.DestroyAndClearArray(datas)
end

function ComodoBuildingContainerView:AddEvents()
end

function ComodoBuildingContainerView:OnEnter()
  ComodoBuildingContainerView.super.OnEnter(self)
  local index = 1
  local targetPageName = self.viewdata.viewdata and self.viewdata.viewdata.page
  if targetPageName then
    for i = 1, #self.pageNames do
      if self.pageNames[i] == targetPageName then
        index = i
      end
    end
  end
  self:SwitchToPage(index)
  self.tabGrid.gameObject:SetActive(1 < #self.tabCells)
  ComodoBuildingProxy.Query()
end

function ComodoBuildingContainerView:OnClickTab(cellCtl)
  self:SwitchToPage(cellCtl.index)
end

function ComodoBuildingContainerView:SwitchToPage(index)
  if not index or index <= 0 or index > #self.tabCells then
    return
  end
  self.tabCells[index].toggle.value = true
  local isActive
  for pageIndex, pageClass in pairs(self.viewMap) do
    isActive = pageIndex == index
    pageClass.gameObject:SetActive(isActive)
    if isActive then
      self.activePageIndex = pageIndex
      if pageClass.OnActivate then
        pageClass:OnActivate()
      end
    end
    if not isActive and pageClass.OnDeactivate then
      pageClass:OnDeactivate()
    end
  end
end
