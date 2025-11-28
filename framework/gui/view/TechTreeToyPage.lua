autoImport("TechTreeToyCombineCell")
TechTreeToyPage = class("TechTreeToyPage", SubView)
TechTreeToyPage.ColumnNum = 3
TechTreeToyPage.MapToggle = {
  [102] = 1,
  [105] = 2
}

function TechTreeToyPage:Init()
  self:ReLoadPerferb("view/TechTreeToyPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:FindObjs()
  self:InitData()
  self:InitPage()
  self:AddEvents()
end

function TechTreeToyPage:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.panel = self.scrollView.panel
  self.mapToggle = {}
  for i = 1, 2 do
    local toggleGO = self:FindGO("MapTab" .. i):GetComponent(UIToggle)
    self.mapToggle[i] = toggleGO
    EventDelegate.Set(toggleGO.onChange, function()
      if toggleGO.value then
        self.treeId = i
        self:UpdatePage()
      end
    end)
  end
  self.toggles = self:FindGO("Toggles")
end

function TechTreeToyPage:InitData()
  local mapid = SceneProxy.Instance:GetCurMapID()
  local toggle = TechTreeToyPage.MapToggle[mapid]
  if toggle and self.mapToggle[toggle] and TechTreeProxy.Instance:CheckCanOpen() then
    self.mapToggle[toggle].value = true
    self.treeId = toggle
  else
    self.mapToggle[1].value = true
    self.treeId = self.container.treeId
  end
end

function TechTreeToyPage:InitPage()
  self.toyCtl = UIGridListCtrl.new(self.grid, TechTreeToyCombineCell, "TechTreePageCombineCell")
  self.toyCtl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
  local _, h = UIManagerProxy.Instance:GetMyMobileScreenSize()
  local tmpClipRegion = self.panel.baseClipRegion
  tmpClipRegion.w = h - 100
  self.panel.baseClipRegion = tmpClipRegion
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(self.grid.transform))
  tempV3.y = h / 2 - 63
  self.grid.transform.localPosition = tempV3
  tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(self.toggles.transform))
  tempV3.y = h / 2 - 80
  self.toggles.transform.localPosition = tempV3
  self.toggles:SetActive(FunctionUnLockFunc.checkFuncStateValid(118))
end

function TechTreeToyPage:AddEvents()
  self:AddListenEvt(ServiceEvent.TechTreeCmdAddToyDrawingCmd, self.UpdatePage)
end

function TechTreeToyPage:UpdatePage()
  local data, reunitData = ReusableTable.CreateArray()
  for id, v in pairs(Table_ToyDrawing) do
    if v.TreeID == self.treeId then
      TableUtility.ArrayPushBack(data, id)
    end
  end
  table.sort(data)
  for i = 1, #data do
    data[i] = Table_ToyDrawing[data[i]]
  end
  reunitData = self:ReUnitData(data)
  TableUtility.ArrayClear(data)
  for i = 1, #reunitData do
    TableUtility.ArrayPushBack(data, reunitData[i])
  end
  ReusableTable.DestroyAndClearArray(reunitData)
  self.toyCtl:ResetDatas(data)
  ReusableTable.DestroyAndClearArray(data)
  self.scrollView:ResetPosition()
end

function TechTreeToyPage:ReUnitData(datas)
  local unitData, i1, i2 = ReusableTable.CreateArray()
  if datas and 0 < #datas then
    for i = 1, #datas do
      i1 = math.floor((i - 1) / TechTreeToyPage.ColumnNum) + 1
      i2 = math.floor((i - 1) % TechTreeToyPage.ColumnNum) + 1
      unitData[i1] = unitData[i1] or {}
      unitData[i1][i2] = datas[i]
    end
  end
  return unitData
end

function TechTreeToyPage:OnActivate()
  self:UpdatePage()
end

function TechTreeToyPage:OnMouseClick(data)
  if type(data) == "string" then
    self:UpdatePage()
  elseif type(data) == "table" then
    self.chooseId = self.chooseId ~= data.id and data.id or nil
    self.container:ShowToyTip(self.chooseId)
    local combineCells, cells = self.toyCtl:GetCells()
    for _, combineCell in pairs(combineCells) do
      cells = combineCell:GetCells()
      for _, cell in pairs(cells) do
        cell:SetChooseId(self.chooseId)
      end
    end
  end
end
