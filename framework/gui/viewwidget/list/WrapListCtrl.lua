autoImport("EventDispatcher")
autoImport("WrapCombineCell")
WrapListCtrl = class("WrapListCtrl", EventDispatcher)
WrapListCtrl_Dir = {Vertical = 1, Horizontal = 2}

function WrapListCtrl:ctor(container, control, prefabName, dir, childNum, childInterval, disableDragIfFit, combineCellExtraNum)
  self.container = container.transform
  self.wrap = container:GetComponent(UIWrapContent)
  self.prefabName = prefabName
  self.control = control
  self.dir = dir or WrapListCtrl_Dir.Vertical
  self.scrollView = Game.GameObjectUtil:FindCompInParents(container, UIScrollView)
  self.panel = self.scrollView:GetComponent(UIPanel)
  self.viewLength = nil
  local size = self.panel:GetViewSize()
  if self.dir == WrapListCtrl_Dir.Vertical then
    self.viewLength = size.y
  else
    self.viewLength = size.x
  end
  if self.panel.isAnchored then
    local originalAnchor = self.panel.updateAnchors
    self.panel.updateAnchors = 0
    self.panel:ResetAndUpdateAnchors()
    self.panel.updateAnchors = originalAnchor
  end
  local numInt, numPoint = math.modf(self.viewLength / self.wrap.itemSize)
  self.cellNum = numInt + 2 + (combineCellExtraNum or 0)
  self.cellChildNum = childNum or 1
  self.cellChildInterval = childInterval or 0
  if disableDragIfFit then
    self.disableDragPfbNum = math.floor(self.viewLength / self.wrap.itemSize)
  end
  self.initParams = {}
  local wrapx, wrapy, wrapz = LuaGameObject.GetLocalPosition(self.container)
  self.initParams[1] = LuaVector3(wrapx, wrapy, wrapz)
  local panelx, panely, panelz = LuaGameObject.GetLocalPosition(self.panel.transform)
  self.initParams[2] = LuaVector3(panelx, panely, panelz)
  local clipOffset = self.panel.clipOffset
  self.initParams[3] = LuaVector2(clipOffset[1], clipOffset[2])
  self.ctls = {}
  self.datas = {}
  self.pos_reseted = false
  self.prefabInited = false
  self:OnInit()
end

function WrapListCtrl:InitPreferb()
  if self.prefabInited then
    return
  end
  local p_num, c_num = self.cellNum, self.cellChildNum
  for i = 1, p_num do
    local index = i - 1
    local wrapCombineCell_go = self:LoadCellPfb("WrapCombineCell" .. index)
    local wrapCombineCell = WrapCombineCell.new(wrapCombineCell_go)
    wrapCombineCell:InitCells(c_num, self.prefabName, self.control)
    wrapCombineCell:Reposition(self.dir, self.cellChildInterval)
    self:CellAddEventListener(wrapCombineCell)
    self.ctls[index] = wrapCombineCell
  end
  self.cellsList_dirty = true
  self.wrap:SortAlphabetically()
  self:_AddWrapEvent()
  self.prefabInited = true
end

function WrapListCtrl:_AddWrapEvent()
  function self.wrap.onInitializeItem(obj, wrapI, realI)
    if not self.ctls then
      return
    end
    local index = self:GetDataIndexFromRealIndex(realI)
    if self.ctls[wrapI] then
      self.ctls[wrapI]:SetData(self.datas[index])
    end
    if self.update_call then
      self.update_call(self.update_callParam)
    end
  end
end

function WrapListCtrl:GetDataIndexFromRealIndex(realI)
  return math.abs(realI) + 1
end

function WrapListCtrl:CellAddEventListener(cell)
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

function WrapListCtrl:AddUpdateCall(call, callParam)
  self.update_call = call
  self.update_callParam = callParam
end

function WrapListCtrl:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("WrapCombineCell"))
  if cellpfb == nil then
    error("can not find cellpfb" .. cellName)
  end
  cellpfb.transform:SetParent(self.container, false)
  cellpfb.name = cName
  return cellpfb
end

function WrapListCtrl:OnInit()
end

function WrapListCtrl:ResetWrapParama()
  self.realnum = math.max(self.cellNum, #self.datas)
  local min = self.dir == WrapListCtrl_Dir.Vertical and 1 - self.realnum or 0
  local max = self.dir == WrapListCtrl_Dir.Vertical and 0 or self.realnum - 1
  self.wrap.minIndex = min
  self.wrap.maxIndex = max
end

function WrapListCtrl:ResetPosition()
  self.wrap:SortBasedOnScrollMovement()
  self:SetStartPositionByIndex(1)
  if self.disableDragPfbNum ~= nil and self.scrollView.enabled == false then
    self.scrollView.enabled = true
    self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
    self.scrollView:ResetPosition()
    self.scrollView.enabled = false
    return
  end
  self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
  self.scrollView:ResetPosition()
  self.pos_reseted = true
end

function WrapListCtrl:SetStartPositionByIndex(index)
  self.scrollView:DisableSpring()
  self.container.localPosition = self.initParams[1]
  local itemSize = self.wrap.itemSize
  index = index - 1
  local maxNum = self.realnum or self.cellNum
  local snum = math.ceil(self.viewLength / itemSize)
  index = math.clamp(index, 0, maxNum - snum + 1)
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

function WrapListCtrl:ReUnitData(datas, cellNum)
  local unitData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / cellNum) + 1
      local i2 = math.floor((i - 1) % cellNum) + 1
      unitData[i1] = unitData[i1] or {}
      unitData[i1][i2] = datas[i]
    end
  end
  return unitData
end

function WrapListCtrl:ResetDatas(datas, isLayOut)
  self:InitPreferb()
  self.datas = self:ReUnitData(datas, self.cellChildNum)
  self:ResetWrapParama()
  for index, cell in pairs(self.ctls) do
    cell:SetData(self.datas[index + 1])
  end
  self.wrap.mFirstTime = true
  self.wrap:WrapContent()
  self.wrap.mFirstTime = false
  if self.disableDragPfbNum then
    self.scrollView.enabled = #datas > self.disableDragPfbNum
  end
  if isLayOut or not self.pos_reseted then
    self:ResetPosition()
  end
end

function WrapListCtrl:InsertData(data, index)
  if nil == index then
    index = #self.datas + 1
  end
  table.insert(self.datas, index, data)
  self:ResetWrapParama()
end

function WrapListCtrl:GetCells()
  self:InitPreferb()
  if self.cellsList_dirty == false then
    return self.cellsList
  end
  self.cellsList = self.cellsList or {}
  TableUtility.ArrayClear(self.cellsList)
  for i = 0, #self.ctls do
    local cells = self.ctls[i]:GetCells()
    for j = 1, #cells do
      table.insert(self.cellsList, cells[j])
    end
  end
  return self.cellsList
end

function WrapListCtrl:GetDatas()
  return self.datas
end

function WrapListCtrl:AddEventListener(eventType, handler, handlerOwner)
  WrapListCtrl.super.AddEventListener(self, eventType, handler, handlerOwner)
  for k, v in pairs(self.ctls) do
    if v ~= nil then
      v:AddEventListener(eventType, handler, handlerOwner)
    end
  end
end

function WrapListCtrl:Destroy()
  local cells = self.prefabInited and self:GetCells()
  if cells then
    for _, cell in pairs(cells) do
      if cell.OnRemove then
        cell:OnRemove()
      end
      if type(cell.OnCellDestroy) == "function" then
        cell:OnCellDestroy()
      end
      TableUtility.TableClear(cell)
    end
  end
  TableUtility.TableClear(self)
end

function WrapListCtrl:OnDestroy()
  if self.wrap ~= nil then
    self.wrap.onInitializeItem = nil
  end
end

function WrapListCtrl:__OnViewDestroy()
  if self.wrap ~= nil then
    self.wrap.onInitializeItem = nil
  end
  self:Destroy()
end
