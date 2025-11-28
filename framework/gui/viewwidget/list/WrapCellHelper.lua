autoImport("EventDispatcher")
autoImport("WrapCombineCell")
WrapCellHelper = class("WrapCellHelper", EventDispatcher)

function WrapCellHelper:ctor(params)
  self.wrap = params.wrapObj:GetComponent(UIWrapContent)
  self.control = params.control
  self.cellName = params.cellName
  self.pfbNum = params.pfbNum
  self.eventWhenUpdate = params.eventWhenUpdate
  self.eventWhenUpdateParam = params.eventWhenUpdateParam
  self.rowNum = params.rowNum
  self.colNum = params.colNum
  self.cellWidth = params.cellWidth
  self.cellHeight = params.cellHeight
  self.scrollView = Game.GameObjectUtil:FindCompInParents(params.wrapObj, UIScrollView)
  self.panel = self.scrollView:GetComponent(UIPanel)
  if self.panel.isAnchored then
    local originalAnchor = self.panel.updateAnchors
    self.panel.updateAnchors = 0
    self.panel:ResetAndUpdateAnchors()
    self.panel.updateAnchors = originalAnchor
  end
  local size = self.panel:GetViewSize()
  self.dir = params.dir or 1
  if self.dir == 1 then
    if self.cellHeight then
      self.wrap.itemSize = self.cellHeight
    end
    self.viewLength = size.y
  else
    if self.cellWidth then
      self.wrap.itemSize = self.cellWidth
    end
    self.viewLength = size.x
  end
  if not self.pfbNum then
    local numInt, numPoint = math.modf(self.viewLength / self.wrap.itemSize)
    if numPoint < 0.5 then
      self.pfbNum = numInt + 1
    else
      self.pfbNum = numInt + 2
    end
  end
  if params.disableDragIfFit then
    self.disableDragPfbNum = math.floor(self.viewLength / self.wrap.itemSize)
  end
  self.initParams = {}
  local wrapx, wrapy, wrapz = LuaGameObject.GetLocalPosition(self.wrap.transform)
  self.initParams[1] = LuaVector3(wrapx, wrapy, wrapz)
  local panelx, panely, panelz = LuaGameObject.GetLocalPosition(self.panel.transform)
  self.initParams[2] = LuaVector3(panelx, panely, panelz)
  local clipOffset = self.panel.clipOffset
  self.initParams[3] = LuaVector2(clipOffset[1], clipOffset[2])
  self.ctls = {}
  self.datas = {}
  self.cellsListCache = {}
  self.prefabInited = false
end

function WrapCellHelper:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(self.cellName))
  if cellpfb == nil then
    error("can not find cellpfb" .. self.cellName)
  end
  cellpfb.transform:SetParent(self.wrap.transform, false)
  cellpfb.name = cName
  return cellpfb
end

function WrapCellHelper:CellAddEventListener(cell)
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

function WrapCellHelper:LoadAllPfb(pfbNum)
  if self.prefabInited then
    return
  end
  local pnum = pfbNum or self.pfbNum
  for i = 1, pnum do
    local index = i - 1
    local cellGo = self:LoadCellPfb(self.cellName .. index)
    local cell = self.control.new(cellGo)
    self:CellAddEventListener(cell)
    self.ctls[index] = cell
  end
  self.wrap:SortAlphabetically()
  
  function self.updatefunc(obj, wrapI, realI)
    local index = math.abs(realI) + 1
    if self.ctls and self.ctls[wrapI] then
      self.ctls[wrapI]:SetData(self.datas[index])
      if self.eventWhenUpdate ~= nil then
        self.eventWhenUpdate(self.eventWhenUpdateParam)
      end
    end
  end
  
  self.wrap.onInitializeItem = self.updatefunc
  self.prefabInited = true
end

function WrapCellHelper:ResetWrapParama()
  self.realnum = math.max(self.pfbNum, #self.datas)
  local min = self.dir == 1 and 1 - self.realnum or 0
  local max = self.dir == 1 and 0 or self.realnum - 1
  self.wrap.minIndex = min
  self.wrap.maxIndex = max
end

function WrapCellHelper:ResetPosition()
  self.wrap:SortBasedOnScrollMovement()
  self:SetStartPositionByIndex(1)
  if self.disableDragPfbNum ~= nil and self.scrollView.enabled == false then
    self.scrollView.enabled = true
    self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
    self.scrollView:ResetPosition()
    self.scrollView.enabled = false
  else
    self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
    self.scrollView:ResetPosition()
  end
end

function WrapCellHelper:SetStartPositionByIndex(index, useTempLuaVer)
  self.scrollView:DisableSpring()
  self.wrap.transform.localPosition = self.initParams[1]
  local itemSize = self.wrap.itemSize
  index = index - 1
  local maxNum = self.realnum or self.pfbNum
  local snum = math.ceil(self.viewLength / itemSize)
  index = math.clamp(index, 0, maxNum - snum + 1)
  local offset = math.clamp(itemSize * index, 0, math.max(0, maxNum * itemSize - self.viewLength))
  local panelInitPos = self.initParams[2]
  local panelInitClipOffset = self.initParams[3]
  if self.dir == 1 then
    self.panel.transform.localPosition = LuaGeometry.GetTempVector3(panelInitPos[1], panelInitPos[2] + offset, panelInitPos[3])
    self.panel.clipOffset = LuaGeometry.GetTempVector2(panelInitClipOffset[1], panelInitClipOffset[2] - offset)
  else
    self.panel.transform.localPosition = LuaGeometry.GetTempVector3(panelInitPos[1] - offset, panelInitPos[2], panelInitPos[3])
    self.panel.clipOffset = LuaGeometry.GetTempVector2(panelInitClipOffset[1] + offset, panelInitClipOffset[2])
  end
  if useTempLuaVer and BackwardCompatibilityUtil.CompatibilityMode_V39 then
    local c = coroutine.create(function()
      Yield(WaitForEndOfFrame())
      self:TempLuaWrapContent()
    end)
    coroutine.resume(c)
  else
    self.wrap:WrapContent()
  end
end

function WrapCellHelper:TempLuaWrapContent()
  helplog("TempLuaWrapContent")
  if not self.wrap then
    return
  end
  local itemSize = self.wrap.itemSize
  local mTrans = self.wrap.transform
  local mPanel = Game.GameObjectUtil:FindCompInParents(self.wrap.gameObject, UIPanel)
  local mScroll = mPanel:GetComponent(UIScrollView)
  local mHorizontal = mScroll.movement == 0
  local mChildren = {}
  for i = 0, mTrans.childCount - 1 do
    table.insert(mChildren, mTrans:GetChild(i))
  end
  local extents = itemSize * #mChildren * 0.5
  local conners = {}
  for i = 1, 4 do
    local v = mTrans:InverseTransformPoint(mPanel.worldCorners[i])
    table.insert(conners, LuaVector3.New(v.x, v.y, v.z))
  end
  local center = LuaVector3.Lerp(conners[1], conners[3], 0.5)
  local allWithinRange = true
  local ext2 = extents * 2
  local minIndex = self.wrap.minIndex
  local maxIndex = self.wrap.maxIndex
  if mHorizontal then
    local min = conners[1].x - itemSize
    local max = conners[3].x + itemSize
    for i = 1, #mChildren do
      local t = mChildren[i]
      local distance = t.localPosition.x - center.x
      if distance < -extents then
        local pos_x = t.localPosition.x
        pos_x = pos_x + math.ceil((-extents - distance) / ext2) * ext2
        distance = pos_x - center.x
        local realIndex = math.round(pos_x / itemSize)
        if minIndex == maxIndex or minIndex <= realIndex and maxIndex >= realIndex then
          t.localPosition = LuaGeometry.GetTempVector3(pos_x, t.localPosition.y, t.localPosition.z)
          self:TempLuaUpdateItem(mScroll, itemSize, t, i - 1)
        else
          allWithinRange = false
        end
      elseif extents < distance then
        local pos_x = t.localPosition.x
        pos_x = pos_x - math.ceil((distance - extents) / ext2) * ext2
        distance = pos_x - center.x
        local realIndex = math.round(pos_x / itemSize)
        if minIndex == maxIndex or minIndex <= realIndex and maxIndex >= realIndex then
          t.localPosition = LuaGeometry.GetTempVector3(pos_x, t.localPosition.y, t.localPosition.z)
          self:TempLuaUpdateItem(mScroll, itemSize, t, i - 1)
        else
          allWithinRange = false
        end
      elseif self.wrap.mFirstTime then
        self:TempLuaUpdateItem(mScroll, itemSize, t, i - 1)
      end
      if self.wrap.cullContent then
        distance = distance + mPanel.clipOffset.x - mTrans.localPosition.x
        if UICamera.IsPressed(t.gameObject) == false then
          NGUITools.SetActive(t.gameObject, min < distance and max > distance, false)
        end
      end
    end
  else
  end
  mScroll.restrictWithinPanel = not allWithinRange
end

function WrapCellHelper:TempLuaUpdateItem(mScroll, itemSize, item, index)
  self:LoadAllPfb()
  if mScroll and itemSize and self.updatefunc then
    local realIndex = mScroll.movement == 0 and math.round(item.localPosition.x / itemSize) or math.round(item.localPosition.y / itemSize)
    self.updatefunc(item.gameObject, index, realIndex)
  end
end

function WrapCellHelper:ResetDatas(datas, layout, autohideNil)
  self:UpdateInfo(datas, layout, autohideNil)
end

function WrapCellHelper:UpdateInfo(datas, layout, autohideNil)
  self:LoadAllPfb()
  self.datas = datas
  self:ResetWrapParama()
  local idata
  for index, cell in pairs(self.ctls) do
    idata = datas[index + 1]
    cell:SetData(idata)
    if autohideNil then
      cell.gameObject:SetActive(idata ~= nil)
    end
  end
  if autohideNil then
    self.wrap.cullContent = #datas > self.pfbNum
  end
  self.wrap.mFirstTime = true
  self.wrap:WrapContent()
  self.wrap.mFirstTime = false
  if layout then
    self:ResetPosition()
  end
  if self.disableDragPfbNum then
    self.scrollView.enabled = #datas > self.disableDragPfbNum
  end
end

function WrapCellHelper:InsertData(data, index)
  if nil == index then
    index = #self.datas + 1
  end
  table.insert(self.datas, index, data)
  self:ResetWrapParama()
end

function WrapCellHelper:GetCellCtls()
  self:LoadAllPfb()
  TableUtility.TableClear(self.cellsListCache)
  for i = 0, #self.ctls do
    table.insert(self.cellsListCache, self.ctls[i])
  end
  return self.cellsListCache
end

function WrapCellHelper:GetDatas()
  return self.datas
end

function WrapCellHelper:AddEventListener(eventType, handler, handlerOwner)
  WrapCellHelper.super.AddEventListener(self, eventType, handler, handlerOwner)
  for k, v in pairs(self.ctls) do
    if v ~= nil then
      v:AddEventListener(eventType, handler, handlerOwner)
    end
  end
end

function WrapCellHelper:Destroy()
  local cells = self.prefabInited and self:GetCellCtls()
  if cells then
    for _, cell in pairs(cells) do
      if cell.OnCellDestroy and type(cell.OnCellDestroy) == "function" then
        cell:OnCellDestroy()
      end
      TableUtility.TableClear(cell)
    end
  end
  TableUtility.TableClear(self)
end

function WrapCellHelper:__OnViewDestroy()
  if self.wrap ~= nil then
    self.wrap.onInitializeItem = nil
  end
  self:Destroy()
end
