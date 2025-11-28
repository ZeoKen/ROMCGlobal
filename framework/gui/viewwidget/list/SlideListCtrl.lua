autoImport("ListCtrl")
SlideListCtrl = class("SlideListCtrl", ListCtrl)

function SlideListCtrl:Init()
  SlideListCtrl.super.Init(self)
  SlideListCtrl.super.Init(self)
  self.disableDragPfbNum = nil
end

function SlideListCtrl:SetLRButton(l, r)
  self.l_btn = l
  self.r_btn = r
  if self.l_btn then
    self:AddClickEvent(self.l_btn, function()
      self:Layout(self.showIdx - 1, false)
    end)
  end
  if self.r_btn then
    self:AddClickEvent(self.r_btn, function()
      self:Layout(self.showIdx + 1, false)
    end)
  end
end

function SlideListCtrl:FindGO(name, parent)
  parent = parent or self.gameObject
  return parent ~= nil and Game.GameObjectUtil:DeepFind(parent, name) or nil
end

local lastClickEventTime = 0

function SlideListCtrl:AddClickEvent(obj, event)
  if event == nil then
    UIEventListener.Get(obj).onClick = nil
    return
  end
  UIEventListener.Get(obj).onClick = function(go)
    if go and not Game.GameObjectUtil:ObjectIsNULL(go) then
      local cmt = go:GetComponent(GuideTagCollection)
      if cmt and cmt.id ~= -1 then
        FunctionGuide.Me():triggerWithTag(cmt.id)
      end
      local positionX, positionY = LuaGameObject.GetMousePosition()
      AAAManager.Me():ClickEvent(go.name, positionX, positionY)
    end
    local nowTime = ServerTime.CurClientTime()
    if nowTime - lastClickEventTime >= self.animTime * 1000 then
      event(go)
      lastClickEventTime = nowTime
    end
  end
end

function SlideListCtrl:SetLayoutCfg(container, maxShow, animTime)
  local ts = math.floor(maxShow / 2)
  self.tt = {}
  for i = -ts, ts do
    self.tt[i] = self:FindGO(tostring(i), container).transform
  end
  self.tth = self:FindGO("H", container).transform
  self.maxShow = maxShow
  self.animTime = animTime
end

local cellPlayTween = function(self, cell, tIdx, skipAnim)
  if not cell.tIdx then
    skipAnim = true
  end
  if cell.tIdx == tIdx then
    return
  end
  local tweenTrans = cell.gameObject:GetComponent(TweenTransform)
  tweenTrans.from = cell.tIdx and self.tt[cell.tIdx] or self.tth
  tweenTrans.to = self.tt[tIdx] or self.tth
  local cellPanel = cell.gameObject:GetComponent(UIPanel)
  cell.tIdx = tIdx
  if skipAnim then
    tweenTrans:Sample(1, true)
    tweenTrans.enabled = false
    cellPanel.depth = tIdx == "H" and self.baseDepth or self.baseDepth + (self.maxShow + 1) / 2 - math.abs(cell.tIdx)
    if cell.OnLayout and type(cell.OnLayout) == "function" then
      cell:OnLayout(self)
    end
  else
    tweenTrans:ResetToBeginning()
    tweenTrans:PlayForward()
    local c = coroutine.create(function()
      Yield(WaitForSeconds(self.animTime / 2))
      cellPanel.depth = tIdx == "H" and self.baseDepth or self.baseDepth + (self.maxShow + 1) / 2 - math.abs(cell.tIdx)
      if cell.OnLayout and type(cell.OnLayout) == "function" then
        cell:OnLayout(self)
      end
    end)
    coroutine.resume(c)
  end
end
local getIdx = function(self, idxInCell, showIdx)
  local bOffset = (self.maxShow - 1) / 2
  local offset = idxInCell - showIdx
  if offset >= -bOffset and bOffset >= offset then
    return offset
  end
  local offsetAdd = offset + #self.cells
  if offsetAdd >= -bOffset and bOffset >= offsetAdd then
    return offsetAdd
  end
  local offsetMinus = offset - #self.cells
  if offsetMinus >= -bOffset and bOffset >= offsetMinus then
    return offsetMinus
  end
  return "H"
end

function SlideListCtrl:ResetDatas(datas, ...)
  SlideListCtrl.super.ResetDatas(self, datas, nil, false)
end

function SlideListCtrl:Layout(showIdx, skipAnim)
  if not self.cells or #self.cells == 0 then
    return
  end
  if 0 < showIdx then
    self.showIdx = (showIdx - 1) % #self.cells + 1
  else
    self.showIdx = #self.cells - math.abs(showIdx) % #self.cells
  end
  local ppanel = UIUtil.GetComponentInParents(self.layoutCtrl, UIPanel)
  self.baseDepth = ppanel and ppanel.depth or 0
  for i = 1, #self.cells do
    local cell = self.cells[i]
    cellPlayTween(self, cell, getIdx(self, i, self.showIdx), skipAnim)
  end
end

function SlideListCtrl:LoadCellPfb(cName)
  local cellpfb = SlideListCtrl.super.LoadCellPfb(self, cName)
  cellpfb:AddComponent(TweenTransform).duration = self.animTime or 1
  cellpfb:AddComponent(TweenAlpha).duration = self.animTime or 1
  cellpfb:AddComponent(UIPanel)
  return cellpfb
end
