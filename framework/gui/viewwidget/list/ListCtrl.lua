autoImport("EventDispatcher")
ListCtrl = class("ListCtrl", EventDispatcher)

function ListCtrl:ctor(layoutCtrl, cellCtrl, cellPfb)
  self.reverse = false
  self.layoutCtrl = layoutCtrl
  self.cellCtrl = cellCtrl
  self.cellPfb = cellPfb
  self.cells = {}
  self:Init()
end

function ListCtrl:SetReverse(val)
  self.reverse = val
end

function ListCtrl:Init()
end

function ListCtrl:SetNoScrollView(b)
  if b then
    self.noScrollView = true
  else
    self.noScrollView = nil
  end
end

function ListCtrl:SetNoLayout(b)
  if b then
    self.noLayout = true
  else
    self.noLayout = nil
  end
end

function ListCtrl:SetAddCellHandler(handler, handlerowner)
  self.addCellHandler = {func = handler, owner = handlerowner}
end

function ListCtrl:AddEventListener(eventType, handler, handlerOwner)
  ListCtrl.super.AddEventListener(self, eventType, handler, handlerOwner)
  for i = 1, #self.cells do
    self.cells[i]:AddEventListener(eventType, handler, handlerOwner)
  end
end

function ListCtrl:CellAddEventListener(cell)
  if cell and self.handlers then
    for eventType, eventHandlers in pairs(self.handlers) do
      for i = 1, #eventHandlers do
        local e = eventHandlers[i]
        if e.owners then
          for j = 1, #e.owners do
            cell:AddEventListener(eventType, e.func, e.owners[j])
          end
        end
      end
    end
  end
end

local key = {}

function ListCtrl:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(self.cellPfb))
  if cellpfb == nil then
    error("can not find cellpfb" .. self.cellPfb)
  end
  cellpfb.transform:SetParent(self.layoutCtrl.transform, false)
  cellpfb.name = cName
  return cellpfb
end

function ListCtrl:SetEmptyDatas(num)
  self:RemoveAll()
  for i = 1, num do
    self:AddCell(nil)
  end
end

function ListCtrl:ResetDatas(datas, removeOther, isLayOut)
  datas = datas or {}
  if removeOther == nil then
    removeOther = true
  end
  if isLayOut == nil then
    isLayOut = true
  end
  local currentNum = #self.cells
  local newNum = #datas
  local delta = newNum - currentNum
  if 0 < delta then
    for i = 1, delta do
      self:AddCell(nil)
    end
  elseif delta < 0 and removeOther then
    for i = 1, -delta do
      self:RemoveCell(1)
    end
  end
  for i = 1, newNum do
    self:UpdateCell(i, datas[i])
  end
  for i = newNum + 1, #self.cells do
    self:UpdateCell(i, nil, true)
  end
  if isLayOut then
    self:Layout()
  end
  if self.disableDragPfbNum and self.scrollView then
    self.scrollView.enabled = newNum > self.disableDragPfbNum
  end
end

function ListCtrl:AddCell(cellData, index)
  index = index or 0
  local cell = self:LoadCellPfb(self.cellPfb .. "_")
  local cellCtrl = self.cellCtrl.new(cell)
  if 0 < index and index < #self.cells then
    table.insert(self.cells, index, cellCtrl)
  else
    table.insert(self.cells, cellCtrl)
  end
  if cellData ~= nil then
    cellCtrl:SetData(cellData)
  end
  if self.addCellHandler ~= nil then
    local func = self.addCellHandler.func
    local owner = self.addCellHandler.owner
    func(owner or self, cellCtrl)
  end
  self:CellAddEventListener(cellCtrl)
  return cellCtrl
end

function ListCtrl:RemoveCell(index)
  if index <= #self.cells then
    local cellCtrl = table.remove(self.cells, index)
    cellCtrl:ClearEvent()
    if cellCtrl.OnRemove then
      cellCtrl:OnRemove()
    end
    if cellCtrl.OnCellDestroy and type(cellCtrl.OnCellDestroy) == "function" then
      cellCtrl:OnCellDestroy()
    end
    GameObject.DestroyImmediate(cellCtrl.gameObject)
    TableUtility.TableClear(cellCtrl)
    cellCtrl = nil
  end
end

function ListCtrl:RemoveAll()
  for i = 1, #self.cells do
    local cellCtrl = self.cells[i]
    cellCtrl:ClearEvent()
    if cellCtrl.OnRemove then
      cellCtrl:OnRemove()
    end
    if cellCtrl.OnCellDestroy and type(cellCtrl.OnCellDestroy) == "function" then
      cellCtrl:OnCellDestroy()
    end
    GameObject.DestroyImmediate(cellCtrl.gameObject)
    TableUtility.TableClear(cellCtrl)
    cellCtrl = nil
  end
  self.cells = {}
end

function ListCtrl:UpdateCell(index, data, forceNewData)
  if self.reverse then
    index = #self.cells - index + 1
  end
  local cellCtrl = self.cells[index]
  if cellCtrl ~= nil then
    if not forceNewData and not data then
      data = cellCtrl.data
    end
    cellCtrl.indexInList = index
    cellCtrl:SetData(data)
  end
end

function ListCtrl:GetCells()
  return self.cells
end

function ListCtrl:FindCellByData(data)
  for i = 1, #self.cells do
    if self.cells[i].data == data then
      return self.cells[i], i
    end
  end
  return nil, 0
end

function ListCtrl:Layout()
  if self.noLayout then
    return
  end
  if self.layoutCtrl.Reposition then
    self.layoutCtrl:Reposition()
  end
end

function ListCtrl:ResetPosition()
  self:Layout()
  if self.noScrollView then
    return
  end
  if not self.scrollView then
    self.scrollView = Game.GameObjectUtil:FindCompInParents(self.layoutCtrl.gameObject, UIScrollView)
  end
  if self.scrollView.enabled == false then
    self.scrollView.enabled = true
    self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
    self.scrollView:ResetPosition()
    self.scrollView.enabled = false
  else
    self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
    self.scrollView:ResetPosition()
  end
end

function ListCtrl:SetDisableDragIfFit()
  if self.noScrollView then
    return
  end
  self.scrollView = Game.GameObjectUtil:FindCompInParents(self.layoutCtrl.gameObject, UIScrollView)
  self.panel = self.scrollView:GetComponent(UIPanel)
  if self.panel.isAnchored then
    local originalAnchor = self.panel.updateAnchors
    self.panel.updateAnchors = 0
    self.panel:ResetAndUpdateAnchors()
    self.panel.updateAnchors = originalAnchor
  end
  local size = self.panel:GetViewSize()
  local cellLength
  if self.layoutCtrl.arrangement == 1 then
    self.viewLength = size.y
    cellLength = self.layoutCtrl.cellHeight
  elseif self.layoutCtrl.arrangement == 0 then
    self.viewLength = size.x
    cellLength = self.layoutCtrl.cellWidth
  end
  if cellLength then
    self.disableDragPfbNum = math.floor(self.viewLength / cellLength)
  end
end

function ListCtrl:Destroy()
  local cells = self:GetCells()
  if cells then
    for _, cell in pairs(cells) do
      if cell.OnCellDestroy and type(cell.OnCellDestroy) == "function" then
        cell:OnCellDestroy()
      end
      GameObject.DestroyImmediate(cell.gameObject)
      TableUtility.TableClear(cell)
    end
  end
  TableUtility.TableClear(self)
end

function ListCtrl:__OnViewDestroy()
  self:Destroy()
end

function ListCtrl:ScrollToIndex(index, recalculateBounds)
  if self.noScrollView then
    return
  end
  if not self.layoutCtrl or not self.layoutCtrl.cellWidth then
    return
  end
  local cells = self:GetCells()
  if not cells or #cells == 0 then
    return
  end
  if not index or index == 0 or index > #cells then
    return
  end
  if not self.scrollView then
    self.scrollView = Game.GameObjectUtil:FindCompInParents(self.layoutCtrl.gameObject, UIScrollView)
  end
  if not self.scrollView then
    return
  end
  local disableDragIfFits = self.scrollView.disableDragIfFits
  local horizontallyFits = not self.scrollView.shouldMoveHorizontally
  local verticallyFits = not self.scrollView.shouldMoveVertically
  local bias = 0
  if not self.panel then
    self.panel = self.scrollView:GetComponent(UIPanel)
  end
  local viewSize = self.panel:GetViewSize()
  if self.scrollView.canMoveHorizontally then
    bias = viewSize.x / self.layoutCtrl.cellWidth
  elseif self.scrollView.canMoveVertically then
    bias = viewSize.y / self.layoutCtrl.cellHeight
  end
  local per = (index - 1) / (#cells - bias)
  per = math.clamp(per, 0, 1)
  if recalculateBounds then
    self.scrollView:InvalidateBounds()
  end
  if self.scrollView.canMoveHorizontally then
    if not disableDragIfFits or not horizontallyFits then
      self.scrollView:SetDragAmount(per, 0, false)
    end
  elseif self.scrollView.canMoveVertically and (not disableDragIfFits or not verticallyFits) then
    self.scrollView:SetDragAmount(0, per, false)
  end
end
