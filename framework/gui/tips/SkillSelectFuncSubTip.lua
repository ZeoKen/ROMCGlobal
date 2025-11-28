autoImport("SkillMultiSelectCell")
SkillSelectFuncSubTip = class("SkillSelectFuncSubTip", CoreView)

function SkillSelectFuncSubTip:Init(cellCtrl, cellPfb, handler, handlerOwner)
  self.baseBGHeight = 54
  self.perHeight = 40
  self.FuncMaxHeight = 154
  self.cellNumInRow = 1
  self:FindObjs()
  self:InitShow(cellCtrl, cellPfb, handler, handlerOwner)
end

function SkillSelectFuncSubTip:FindObjs()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self.colWidth = self.collider.size.x
  self.colStartCenterY = self.collider.center.y
  self.originBGHeight = self.bg.height
  local view = self:FindGO("ScrollView")
  if view then
    self.panel = view:GetComponent(UIPanel)
    self.scrollView = view:GetComponent(UIScrollView)
  end
  self.extraTop = self:FindGO("ExtraTop")
end

function SkillSelectFuncSubTip:InitShow(cellCtrl, cellPfb, handler, handlerOwner)
  local grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.listCtrl = ListCtrl.new(grid, cellCtrl, cellPfb)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, handler, handlerOwner)
end

function SkillSelectFuncSubTip:ResetParams(baseBGHeight, perHeight, maxHeight, cellNumInRow)
  if baseBGHeight then
    self.baseBGHeight = baseBGHeight
  end
  if perHeight then
    self.perHeight = perHeight
  end
  if maxHeight then
    self.maxHeight = maxHeight
  end
  if cellNumInRow then
    self.cellNumInRow = cellNumInRow
  end
end

function SkillSelectFuncSubTip:UpdateTip(datas, extraPer, extraOptions)
  if datas ~= nil then
    self:Show()
    if self.extraTop then
      if extraOptions then
        self.extraTop:SetActive(true)
        self.extraTop.transform:SetSiblingIndex(0)
        self.cell = SkillMultiSelectCell.new(self.extraTop)
        self.cell:SetData(extraOptions)
      else
        self.extraTop:SetActive(false)
      end
    end
    extraPer = extraPer or 0
    local height = self.baseBGHeight + math.ceil(#datas / self.cellNumInRow) * self.perHeight + self.perHeight * extraPer
    height = math.min(height, self.FuncMaxHeight)
    self.bg.height = height
    self.collider.center = LuaGeometry.GetTempVector3(0, self.colStartCenterY - (height - self.originBGHeight) / 2, 0)
    self.collider.size = LuaGeometry.GetTempVector3(self.colWidth, height - 39, 1)
    self.bgHeight = height
    self.listCtrl:ResetDatas(datas)
    if self.panel then
      self.panel:ResetAndUpdateAnchors()
    end
    if self.scrollView then
      self.scrollView:ResetPosition()
    end
  else
    self:Hide()
  end
end

function SkillSelectFuncSubTip:GetBgHeight()
  return self.bgHeight or 0
end

function SkillSelectFuncSubTip:GetRealBgHeight()
  if self.bgHeight then
    return math.max(self.bgHeight - 35, 0)
  else
    return 0
  end
end

function SkillSelectFuncSubTip:GetListCtrl()
  return self.listCtrl
end

function SkillSelectFuncSubTip:GetCells()
  return self.listCtrl:GetCells()
end

function SkillSelectFuncSubTip:GetSelectedList(noRefresh)
  local list = self.selectedList
  if list == nil then
    list = {}
    self.selectedList = list
    self:_GetSelectedList(list)
  elseif not noRefresh then
    TableUtility.ArrayClear(list)
    self:_GetSelectedList(list)
  end
  return list
end

function SkillSelectFuncSubTip:_GetSelectedList(list)
  if self.listCtrl ~= nil then
    local cell, data
    local cells = self.listCtrl:GetCells()
    for i = 1, #cells do
      cell = cells[i]
      data = cell.data
      if data ~= nil and data.id ~= nil and cell:IsSelect() then
        list[#list + 1] = data.id
      end
    end
  end
end

function SkillSelectFuncSubTip:GetSelectedCount()
  local count = 0
  if self.listCtrl ~= nil then
    local cells = self.listCtrl:GetCells()
    for i = 1, #cells do
      if cells[i]:IsSelect() then
        count = count + 1
      end
    end
  end
  return count
end

function SkillSelectFuncSubTip:GetToggleCells()
  local tcells = {}
  if self.listCtrl ~= nil then
    local cells = self.listCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].IsToggle and cells[i]:IsToggle() then
        table.insert(tcells, cells[i])
      end
    end
  end
  return tcells
end

function SkillSelectFuncSubTip:GetExtraParam()
  return self.cell and self.cell.select
end
