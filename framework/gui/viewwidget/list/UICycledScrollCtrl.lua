UICycledScrollCtrl = class("UICycledScrollCtrl")
local CalculateRelativeWidgetBounds = NGUIMath.CalculateRelativeWidgetBounds

function UICycledScrollCtrl:SortCell(transA, transB)
  local ax, ay, az = LuaGameObject.GetLocalPosition(transA)
  local bx, by, bz = LuaGameObject.GetLocalPosition(transB)
  if self.scrollDir == 0 then
    if ax > bx then
      return 1
    elseif ax < bx then
      return -1
    else
      return 0
    end
  elseif ay > by then
    return -1
  elseif ay < by then
    return 1
  else
    return 0
  end
end

function UICycledScrollCtrl:ctor(layoutCtrl, cellCtrl, cellPfb, maxShowNum, sprintBuffer)
  self:Init(layoutCtrl, cellCtrl, cellPfb, maxShowNum, sprintBuffer)
end

function UICycledScrollCtrl:Update(go)
  self:UpdateScrollView()
end

function UICycledScrollCtrl:RegUpdateListener()
  if Game.GameObjectUtil:ObjectIsNULL(self.scrollView) then
    return
  end
  local updateComp = self.scrollView.gameObject:GetComponent(UpdateDelegate)
  updateComp = updateComp or self.scrollView.gameObject:AddComponent(UpdateDelegate)
  self.updateComp = updateComp
  
  function self.updateComp.listener(go)
    self:Update(go)
  end
end

function UICycledScrollCtrl:UnregUpdateListener()
  if not Game.GameObjectUtil:ObjectIsNULL(self.updateComp) then
    self.updateComp.listener = nil
  end
end

function UICycledScrollCtrl:Init(layoutCtrl, cellCtrl, cellPfb, maxShowNum, sprintBuffer)
  self.headCellIndex = nil
  self.tailCellIndex = nil
  self.firstDataIndex = nil
  self.layoutCtrl = layoutCtrl
  self.layoutCtrl.sorting = 4
  
  function self.layoutCtrl.onCustomSort(transA, transB)
    return self:SortCell(transA, transB)
  end
  
  self.cellPadding = self.layoutCtrl.padding
  self.pivotOffset = NGUIMath.GetPivotOffset(layoutCtrl.cellAlignment)
  self.cellCtrl = cellCtrl
  self.cellPfb = cellPfb
  self.scrollView = Game.GameObjectUtil:FindCompInParents(self.layoutCtrl.gameObject, UIScrollView)
  self.scrollDir = self.scrollView.canMoveHorizontally and 0 or 1
  self.scrollViewTrans = self.scrollView.transform
  
  function self.scrollView.onDragStarted()
    self:OnScrollDragStart()
  end
  
  function self.scrollView.onDragFinished()
    self:OnScrollDragEnd()
  end
  
  function self.scrollView.onStoppedMoving()
    self:OnScrollMoveEnd()
  end
  
  self.panel = self.scrollView:GetComponent(UIPanel)
  local baseClipRegion = self.panel.baseClipRegion
  self.clipSizeX = baseClipRegion[3]
  self.clipSizeY = baseClipRegion[4]
  self.cells = {}
  self.maxShowNum = maxShowNum or 10
  self.sprintBuffer = sprintBuffer or 100
  self.allocCellNum = self.maxShowNum + 6
  for i = 1, self.allocCellNum do
    local cell = self:LoadCellCtrl()
    LuaGameObject.SetLocalPositionGO(cell.gameObject, i * 10, -i * 10, 0)
    table.insert(self.cells, cell)
    cell.gameObject:SetActive(false)
  end
end

function UICycledScrollCtrl:GetTempVec3(x, y, z)
  if not self.tempVec3 then
    self.tempVec3 = LuaVector3.Zero()
  end
  if x then
    self.tempVec3[1] = x
  end
  if y then
    self.tempVec3[2] = y
  end
  if z then
    self.tempVec3[3] = z
  end
  return self.tempVec3
end

function UICycledScrollCtrl:LoadCellCtrl(cName)
  local cellGO = self:LoadCellPfb(cName)
  if not cellGO then
    return nil
  end
  local cellCtrl = self.cellCtrl.new(cellGO)
  return cellCtrl
end

function UICycledScrollCtrl:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(self.cellPfb))
  if cellpfb == nil then
    error("can not find cellpfb" .. self.cellPfb)
  else
    cName = cName or string.gsub(self.cellPfb, ".*/", "") .. "_"
    cellpfb.transform:SetParent(self.layoutCtrl.transform, false)
    cellpfb.transform.localPosition = self:GetTempVec3(0, 0, 0)
    cellpfb.name = cName
  end
  return cellpfb
end

function UICycledScrollCtrl:ResetDatas(datas, firstDataIndex, resetScrollPosition)
  local lastDataNum = self.datas and #self.datas or 0
  self.datas = datas or {}
  local dataNum = #self.datas
  if firstDataIndex then
    self.firstDataIndex = firstDataIndex
  elseif not self.firstDataIndex or self.firstDataIndex == 0 then
    self.firstDataIndex = math.min(dataNum, 1)
  elseif dataNum == 0 then
    self.firstDataIndex = 0
  elseif lastDataNum > dataNum then
    self.firstDataIndex = math.max(1, self.firstDataIndex - (lastDataNum - dataNum))
  end
  if not self:IsIndexValid(self.headCellIndex) then
    self.headCellIndex = 1
    resetScrollPosition = true
  end
  self.tailCellIndex = 0
  local curCellIndex, cellCtrl = self.headCellIndex
  local clipSize = self.scrollDir == 0 and self.clipSizeX or self.clipSizeY
  local size = 0
  for i = self.firstDataIndex, #self.datas do
    cellCtrl = self:UpdateCell(curCellIndex, i)
    if not cellCtrl then
      break
    end
    LuaGameObject.SetLocalPositionGO(cellCtrl.gameObject, i * 10, -i * 10, 0)
    self.tailCellIndex = curCellIndex
    curCellIndex = self:GetNextCellIndex(curCellIndex)
    if curCellIndex == self.headCellIndex then
      break
    end
    local bounds = CalculateRelativeWidgetBounds(self.scrollViewTrans, cellCtrl.gameObject.transform, false, true)
    size = size + (self.scrollDir == 0 and bounds.size.x or bounds.size.y)
    if clipSize < size then
      break
    end
  end
  if self.tailCellIndex == 0 then
    self.headCellIndex = 0
  end
  self:HideUnusedCells()
  self.layoutCtrl:Reposition()
  if resetScrollPosition and self.scrollView then
    self.scrollView:ResetPosition()
  end
  self:RecordScrollPos()
end

function UICycledScrollCtrl:HideUnusedCells()
  local headCellIndex = self.headCellIndex or 0
  local tailCellIndex = self.tailCellIndex or 0
  local factor = headCellIndex <= tailCellIndex and 1 or -1
  for i, cell in ipairs(self.cells) do
    if tailCellIndex == 0 or headCellIndex == 0 or 0 < (i - headCellIndex) * (i - tailCellIndex) * factor then
      cell.gameObject:SetActive(false)
    end
  end
end

function UICycledScrollCtrl:IsInClipRegion(x, y)
  local finalClipRegion = self.panel.finalClipRegion
  local minX = finalClipRegion[1] - finalClipRegion[3] / 2
  local maxX = finalClipRegion[1] + finalClipRegion[3] / 2
  local minY = finalClipRegion[2] - finalClipRegion[4] / 2
  local maxY = finalClipRegion[2] + finalClipRegion[4] / 2
  return x >= minX and x <= maxX and y >= minY and y <= maxY
end

function UICycledScrollCtrl:IsOutOfClipMinSide(x, y)
  local finalClipRegion = self.panel.finalClipRegion
  if self.scrollDir == 0 then
    return x < finalClipRegion[1] - finalClipRegion[3] / 2
  else
    return y > finalClipRegion[2] + finalClipRegion[4] / 2
  end
end

function UICycledScrollCtrl:IsOutOfClipMaxSide(x, y)
  local finalClipRegion = self.panel.finalClipRegion
  if self.scrollDir == 0 then
    return x > finalClipRegion[1] + finalClipRegion[3] / 2
  else
    return y < finalClipRegion[2] - finalClipRegion[4] / 2
  end
end

function UICycledScrollCtrl:UpdateCell(cellIndex, dataIndex)
  local cellCtrl = self.cells and self.cells[cellIndex]
  if not cellCtrl then
    return
  end
  local data = dataIndex and self.datas and self.datas[dataIndex]
  if data then
    cellCtrl.gameObject:SetActive(true)
    cellCtrl:SetData(data)
    return cellCtrl
  else
    cellCtrl.gameObject:SetActive(false)
    return
  end
end

function UICycledScrollCtrl:IsIndexValid(index)
  return index and 0 < index
end

function UICycledScrollCtrl:ValidateCellIndex(index)
  if not index then
    return 0
  end
  if not self.cells then
    return 0
  end
  local cellNum = #self.cells
  if index < 1 then
    index = cellNum
  elseif cellNum < index then
    index = 1
  end
  return index
end

function UICycledScrollCtrl:GetPrevCellIndex(index)
  local prevCellIndex = index - 1
  if prevCellIndex <= 0 then
    prevCellIndex = #self.cells
  end
  return prevCellIndex
end

function UICycledScrollCtrl:GetNextCellIndex(index)
  local nextCellIndex = index + 1
  if nextCellIndex > #self.cells then
    nextCellIndex = 1
  end
  return nextCellIndex
end

function UICycledScrollCtrl:GetCellData(offset)
  if not self:IsIndexValid(self.firstDataIndex) then
    return
  end
  local index = self.firstDataIndex + (offset or 0)
  if index <= 0 then
    return
  end
  return self.datas and self.datas[index], index
end

function UICycledScrollCtrl:GetCells()
  return self.cells
end

function UICycledScrollCtrl:GetCellNum()
  return self.cells and #self.cells or 0
end

function UICycledScrollCtrl:GetActiveCellNum()
  if not self:IsIndexValid(self.headCellIndex) or not self:IsIndexValid(self.tailCellIndex) then
    return 0
  end
  local num = self.tailCellIndex - self.headCellIndex
  if num < 0 then
    num = num + self:GetCellNum()
  end
  return num + 1
end

function UICycledScrollCtrl:GetCell(index)
  index = self:ValidateCellIndex(index)
  return self.cells and self.cells[index]
end

function UICycledScrollCtrl:GetPrevHeadCell()
  local prevCellIndex = self:GetPrevCellIndex(self.headCellIndex)
  if prevCellIndex == self.tailCellIndex then
    return nil
  end
  return self.cells[prevCellIndex], prevCellIndex
end

function UICycledScrollCtrl:GetNextTailCell()
  local nextCellIndex = self:GetNextCellIndex(self.tailCellIndex)
  if nextCellIndex == self.headCellIndex then
    return nil
  end
  return self.cells[nextCellIndex], nextCellIndex
end

function UICycledScrollCtrl:CalcCellSize(cell)
  local tempVec3 = self:GetTempVec3()
  local bounds = CalculateRelativeWidgetBounds(self.scrollViewTrans, cell.gameObject.transform, false, true)
  LuaVector3.Better_Set(tempVec3, bounds.size[1] + self.cellPadding[1], bounds.size[2] + self.cellPadding[2], 0)
  return tempVec3
end

function UICycledScrollCtrl:AdjustScrollPos(cellSize, dirFactor)
  local tempVec3 = self:GetTempVec3()
  if self.scrollDir == 0 then
    LuaVector3.Better_Set(tempVec3, dirFactor * cellSize[1], 0, 0)
  else
    LuaVector3.Better_Set(tempVec3, 0, -dirFactor * cellSize[2], 0)
  end
  self.scrollView:MoveRelative(tempVec3)
end

function UICycledScrollCtrl:ReachMaxShowNum()
  if self.headCellIndex and self.headCellIndex > 0 and self.tailCellIndex and self.maxShowNum then
    local curShowNum = self.tailCellIndex - self.headCellIndex + 1
    if curShowNum <= 0 then
      curShowNum = curShowNum + #self.cells
    end
    return curShowNum >= self.maxShowNum
  end
  return false
end

function UICycledScrollCtrl:CanUnloadCell(cellSize)
  local bounds = self.scrollView.bounds
  if self.scrollDir == 0 then
    return bounds.size[1] - cellSize[1] >= self.clipSizeX
  else
    return bounds.size[2] - cellSize[2] >= self.clipSizeY
  end
end

function UICycledScrollCtrl:LoadPrevHeadCell()
  local prevCell, prevCellIndex = self:GetPrevHeadCell()
  if not prevCell then
    return
  end
  local cellData, newDataIndex = self:GetCellData(-1)
  if cellData then
    prevCell.gameObject:SetActive(true)
    prevCell:SetData(cellData)
    self.firstDataIndex = newDataIndex
    self.headCellIndex = prevCellIndex
    LuaGameObject.SetLocalPositionGO(prevCell.gameObject, -100000, 100000, 0)
    self.layoutCtrl:Reposition()
    self.panel:SetDirty()
    self.scrollView:InvalidateBounds()
    local cellSize = self:CalcCellSize(prevCell)
    self:AdjustScrollPos(cellSize, -1)
    self:RecordScrollPos()
  end
end

function UICycledScrollCtrl:UnloadHeadCell()
  if not self:IsIndexValid(self.headCellIndex) or self.headCellIndex == self.tailCellIndex then
    return
  end
  if not self:ReachMaxShowNum() then
    return
  end
  local cell = self:GetCell(self.headCellIndex)
  if cell then
    local cellSize = self:CalcCellSize(cell)
    if self:CanUnloadCell(cellSize) then
      cell.gameObject:SetActive(false)
      self.layoutCtrl:Reposition()
      self.scrollView:InvalidateBounds()
      self:AdjustScrollPos(cellSize, 1)
      self:RecordScrollPos()
      self.headCellIndex = self:GetNextCellIndex(self.headCellIndex)
      self.firstDataIndex = self.firstDataIndex + 1
    end
  end
end

function UICycledScrollCtrl:LoadNextTailCell()
  local nextCell, nextCellIndex = self:GetNextTailCell()
  if not nextCell then
    return
  end
  local cellData, _ = self:GetCellData(self:GetActiveCellNum())
  if cellData then
    nextCell.gameObject:SetActive(true)
    nextCell:SetData(cellData)
    self.tailCellIndex = nextCellIndex
    LuaGameObject.SetLocalPositionGO(nextCell.gameObject, 100000, -100000, 0)
    self.layoutCtrl:Reposition()
    self.panel:SetDirty()
    self.scrollView:InvalidateBounds()
  end
end

function UICycledScrollCtrl:UnloadTailCell()
  if not self:IsIndexValid(self.tailCellIndex) or self.tailCellIndex == self.headCellIndex then
    return
  end
  if not self:ReachMaxShowNum() then
    return
  end
  local cell = self:GetCell(self.tailCellIndex)
  if cell then
    local cellSize = self:CalcCellSize(cell)
    if self:CanUnloadCell(cellSize) then
      cell.gameObject:SetActive(false)
      self.layoutCtrl:Reposition()
      self.scrollView:InvalidateBounds()
      self.tailCellIndex = self:GetPrevCellIndex(self.tailCellIndex)
    end
  end
end

function UICycledScrollCtrl:CheckHeadCells(delta)
  local headCell = self:GetCell(self.headCellIndex)
  if not headCell then
    return
  end
  local bounds = CalculateRelativeWidgetBounds(self.scrollViewTrans, headCell.gameObject.transform, false, true)
  if delta < 0 then
    if self:IsOutOfClipMinSide(bounds.center[1] + bounds.size[1] / 2, bounds.center[2] - bounds.size[2] / 2) then
      local nextCellIndex = self:GetNextCellIndex(self.headCellIndex)
      local nextCell = self:GetCell(nextCellIndex)
      if nextCell then
        local nBounds = CalculateRelativeWidgetBounds(self.scrollViewTrans, nextCell.gameObject.transform, false, true)
        if self:IsOutOfClipMinSide(nBounds.center[1], nBounds.center[2]) then
          self:UnloadHeadCell()
        end
      end
    end
  elseif 0 < delta and not self:IsOutOfClipMinSide(bounds.center[1] + bounds.size[1] / 2 + self.sprintBuffer, bounds.center[2] - bounds.size[2] - self.sprintBuffer) then
    self:LoadPrevHeadCell()
  end
end

function UICycledScrollCtrl:CheckTailCells(delta)
  local tailCell = self:GetCell(self.tailCellIndex)
  if not tailCell then
    return
  end
  local bounds = CalculateRelativeWidgetBounds(self.scrollViewTrans, tailCell.gameObject.transform, false, true)
  if 0 < delta then
    if self:IsOutOfClipMaxSide(bounds.center[1] - bounds.size[1] / 2, bounds.center[2] + bounds.size[2] / 2) then
      local prevCellIndex = self:GetPrevCellIndex(self.tailCellIndex)
      local prevCell = self:GetCell(prevCellIndex)
      if prevCell then
        local pBounds = CalculateRelativeWidgetBounds(self.scrollViewTrans, prevCell.gameObject.transform, false, true)
        if self:IsOutOfClipMaxSide(pBounds.center[1], pBounds.center[2]) then
          self:UnloadTailCell()
        end
      end
    end
  elseif delta < 0 and not self:IsOutOfClipMaxSide(bounds.center[1] - bounds.size[1] / 2 - self.sprintBuffer, bounds.center[2] + bounds.size[2] / 2 + self.sprintBuffer) then
    self:LoadNextTailCell()
  end
end

function UICycledScrollCtrl:OnScrollDragStart()
  self.isDragging = true
  self:RecordScrollPos()
  self:RegUpdateListener()
end

function UICycledScrollCtrl:OnScrollDragEnd()
  self.isDragging = false
end

function UICycledScrollCtrl:OnScrollMoveEnd()
  self:UnregUpdateListener()
end

function UICycledScrollCtrl:OnScrollChanged(delta)
  if delta == 0 then
    return
  end
  if 0 < delta then
    self:CheckTailCells(delta)
    self:CheckHeadCells(delta)
  else
    self:CheckHeadCells(delta)
    self:CheckTailCells(delta)
  end
end

function UICycledScrollCtrl:RecordScrollPos()
  local x, y, _ = LuaGameObject.GetLocalPosition(self.scrollViewTrans)
  self.lastPos = self.scrollDir == 0 and x or y
end

function UICycledScrollCtrl:UpdateScrollView()
  if Game.GameObjectUtil:ObjectIsNULL(self.scrollView) then
    return
  end
  if not self.springPanel then
    self.springPanel = self.scrollView:GetComponent(SpringPanel)
  end
  if self.springPanel and self.springPanel.enabled then
    return
  end
  local x, y, _ = LuaGameObject.GetLocalPosition(self.scrollViewTrans)
  local curPos = self.scrollDir == 0 and x or y
  if not self.lastPos then
    self.lastPos = curPos
    return
  end
  local delta = curPos - self.lastPos
  if self.scrollDir == 1 then
    delta = -delta
  end
  if math.abs(delta) < 0.001 then
    return
  end
  self.lastPos = curPos
  self:OnScrollChanged(delta)
end

function UICycledScrollCtrl:Destroy()
  local cells = self:GetCells()
  if cells then
    for _, cell in ipairs(cells) do
      if cell.OnCellDestroy and type(cell.OnCellDestroy) == "function" then
        cell:OnCellDestroy()
      end
    end
    TableUtility.ArrayClear(self.cells)
  end
  if not Game.GameObjectUtil:ObjectIsNULL(self.scrollView) then
    self.scrollView.onDragStarted = nil
    self.scrollView.onDragFinished = nil
    self.scrollView.onStoppedMoving = nil
  end
  self:UnregUpdateListener()
end

function UICycledScrollCtrl:__OnViewDestroy()
  self:Destroy()
end

function UICycledScrollCtrl:AddEventListener(eventType, handler, handlerOwner)
  for k, v in pairs(self.cells) do
    if v ~= nil then
      v:AddEventListener(eventType, handler, handlerOwner)
    end
  end
end

function UICycledScrollCtrl:GetDatas()
  return self.datas
end

function UICycledScrollCtrl:Reposition()
  self.layoutCtrl:Reposition()
end
