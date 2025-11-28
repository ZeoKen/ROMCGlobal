autoImport("WrapListCtrl")
WrapInfiniteListCtrl = class("WrapInfiniteListCtrl", WrapListCtrl)

function WrapInfiniteListCtrl:ctor(container, control, prefabName, dir, springStrength, disableDragIfFit, combineCellExtraNum)
  prefabName = prefabName or control.__cname
  WrapInfiniteListCtrl.super.ctor(self, container, control, prefabName, dir, nil, nil, disableDragIfFit, combineCellExtraNum)
  self.springStrength = springStrength or 20
  self.centerOffset = 0
  
  function self.scrollView.onStoppedMoving()
    local minDistCell, minDistToCurrent = self:GetNearestActiveCellToCurrent()
    if minDistCell then
      self:_SpringScroll(-minDistToCurrent)
      if self.onStoppedMoving_call then
        self.onStoppedMoving_call(self.onStoppedMoving_callParam, self:GetControlFromWrapCell(minDistCell))
      end
    end
  end
end

function WrapInfiniteListCtrl:AddStoppedMovingCall(call, callParam)
  self.onStoppedMoving_call = call
  self.onStoppedMoving_callParam = callParam
end

function WrapInfiniteListCtrl:ResetWrapParama()
  if #self.datas < self.cellNum then
    return WrapInfiniteListCtrl.super.ResetWrapParama(self)
  else
    self.realnum = #self.datas
    self.wrap.minIndex = 0
    self.wrap.maxIndex = 0
  end
end

function WrapInfiniteListCtrl:GetDataIndexFromRealIndex(realI)
  if #self.datas < self.cellNum then
    return WrapInfiniteListCtrl.super.GetDataIndexFromRealIndex(self, realI)
  elseif 0 < realI then
    return self.realnum - math.fmod(realI - 1, self.realnum)
  else
    return math.fmod(-realI, self.realnum) + 1
  end
end

function WrapInfiniteListCtrl:ReUnitData(datas, cellNum)
  local uData = {}
  if datas then
    for i = 1, #datas do
      table.insert(uData, {
        datas[i]
      })
    end
  end
  return uData
end

function WrapInfiniteListCtrl:ResetDatas(datas, isLayOut)
  self:InitPreferb()
  self.datas = self:ReUnitData(datas, self.cellChildNum)
  self:ResetWrapParama()
  for index, cell in pairs(self.ctls) do
    cell:SetData(self.datas[index + 1])
  end
  self.wrap.mFirstTime = true
  if #self.datas > self.cellNum then
    self.wrap:WrapContent()
  end
  self.wrap.mFirstTime = false
  if self.disableDragPfbNum then
    self.scrollView.enabled = #datas > self.disableDragPfbNum
  end
  if isLayOut or not self.pos_reseted then
    self:ResetPosition()
  end
end

function WrapInfiniteListCtrl:ScrollTowardsCell(cellCtl)
  if not cellCtl then
    return
  end
  local wrapCell
  for _, wrapC in pairs(self.ctls) do
    if self:GetControlFromWrapCell(wrapC) == cellCtl then
      wrapCell = wrapC
      break
    end
  end
  if not wrapCell then
    return
  end
  local minDistCell, minDistToCurrent = self:GetNearestCellToCurrent()
  if not minDistCell then
    return
  end
  local minDistCellPosFactor = self:GetLocalPosFactorFromCellByDir(minDistCell)
  local dist = minDistCellPosFactor - self:GetLocalPosFactorFromCellByDir(wrapCell) - minDistToCurrent
  self:_SpringScroll(dist)
end

function WrapInfiniteListCtrl:_SpringScroll(dist)
  local targetX, targetY, targetZ = LuaGameObject.GetLocalPosition(self.scrollView.transform)
  if self.dir == WrapListCtrl_Dir.Vertical then
    targetY = targetY + dist
  else
    targetX = targetX + dist
  end
  SpringPanel.Begin(self.scrollView.gameObject, LuaGeometry.GetTempVector3(targetX, targetY, targetZ), self.springStrength)
end

function WrapInfiniteListCtrl:GetNearestCellToCurrent()
  local scrollViewPosFactor, containerPosFactor = self:GetLocalPosFactorFromTransformByDir(self.scrollView.transform), self:GetLocalPosFactorByDir(self.initParams[1])
  scrollViewPosFactor = scrollViewPosFactor + self.centerOffset
  local minDistToCurrent, minDistCell, dist = self.cellNum * self.wrap.itemSize
  for _, wrapC in pairs(self.ctls) do
    dist = self:GetLocalPosFactorFromCellByDir(wrapC) + scrollViewPosFactor + containerPosFactor
    if math.abs(dist) <= math.abs(minDistToCurrent) then
      minDistToCurrent = dist
      minDistCell = wrapC
    end
  end
  return minDistCell, minDistToCurrent
end

function WrapInfiniteListCtrl:GetNearestActiveCellToCurrent()
  local minDistCell, minDistToCurrent = self:GetNearestCellToCurrent()
  local minDistFactor, minDistControl = self:GetLocalPosFactorFromCellByDir(minDistCell), self:GetControlFromWrapCell(minDistCell)
  if minDistControl.gameObject.activeSelf then
    return minDistCell, minDistToCurrent
  end
  local posFactorWrapCMap, itemSize = ReusableTable.CreateTable(), self.wrap.itemSize
  for _, wrapC in pairs(self.ctls) do
    posFactorWrapCMap[self:GetLocalPosFactorFromCellByDir(wrapC)] = wrapC
  end
  local factorUpwards, factorDownwards, minDistChanged = minDistFactor + itemSize, minDistFactor - itemSize, false
  local wrapCUpwards, wrapCDownwards, cUpwards, cDownwards = posFactorWrapCMap[factorUpwards], posFactorWrapCMap[factorDownwards]
  while wrapCUpwards or wrapCDownwards do
    cUpwards, cDownwards = self:GetControlFromWrapCell(wrapCUpwards), self:GetControlFromWrapCell(wrapCDownwards)
    if cUpwards and cUpwards.gameObject.activeSelf then
      minDistCell = wrapCUpwards
      minDistToCurrent = minDistToCurrent + factorUpwards - minDistFactor
      minDistChanged = true
      break
    end
    if cDownwards and cDownwards.gameObject.activeSelf then
      minDistCell = wrapCDownwards
      minDistToCurrent = minDistToCurrent + factorDownwards - minDistFactor
      minDistChanged = true
      break
    end
    factorUpwards, factorDownwards = factorUpwards + itemSize, factorDownwards - itemSize
    wrapCUpwards, wrapCDownwards = posFactorWrapCMap[factorUpwards], posFactorWrapCMap[factorDownwards]
  end
  ReusableTable.DestroyAndClearTable(posFactorWrapCMap)
  if minDistChanged then
    return minDistCell, minDistToCurrent
  end
end

function WrapInfiniteListCtrl:GetControlFromWrapCell(wrapC)
  return wrapC and wrapC:GetCells()[1]
end

function WrapInfiniteListCtrl:GetLocalPosFactorByDir(pos)
  if not pos then
    return
  end
  return self.dir == WrapListCtrl_Dir.Vertical and pos.y or pos.x
end

function WrapInfiniteListCtrl:GetLocalPosFactorFromTransformByDir(trans)
  return self:GetLocalPosFactorByDir(trans and trans.localPosition)
end

function WrapInfiniteListCtrl:GetLocalPosFactorFromCellByDir(cell)
  return self:GetLocalPosFactorFromTransformByDir(cell and cell.gameObject.transform)
end

function WrapInfiniteListCtrl:SetCenterOffset(centerOffset)
  self.centerOffset = centerOffset
end

function WrapInfiniteListCtrl:SetStartPositionByIndex(index)
  if #self.datas < self.cellNum then
    return WrapInfiniteListCtrl.super.SetStartPositionByIndex(self, index)
  else
    self.scrollView:DisableSpring()
    self.container.localPosition = self.initParams[1]
    local itemSize = self.wrap.itemSize
    index = index - 1
    local offset = itemSize * index
    if self.dir == WrapListCtrl_Dir.Vertical then
      local panelInitPos = self.initParams[2]
      self.panel.transform.localPosition = LuaGeometry.GetTempVector3(panelInitPos[1], panelInitPos[2] + offset, panelInitPos[3])
      local panelInitClipOffset = self.initParams[3]
      self.panel.clipOffset = LuaGeometry.GetTempVector2(panelInitClipOffset[1], panelInitClipOffset[2] - offset)
    elseif self.dir == WrapListCtrl_Dir.Horizontal then
      local panelInitPos = self.initParams[2]
      self.panel.transform.localPosition = LuaGeometry.GetTempVector3(panelInitPos[1] - offset, panelInitPos[2], panelInitPos[3])
      local panelInitClipOffset = self.initParams[3]
      self.panel.clipOffset = LuaGeometry.GetTempVector2(panelInitClipOffset[1] + offset, panelInitClipOffset[2])
    end
    self.wrap:WrapContent()
  end
end
