autoImport("PopupGridListCell")
autoImport("UIGridListCtrl")
autoImport("PopupGridListCell_Preorder")
PopupGridList = class("PopupGridList", EventDispatcher)
local styleConfig = {
  [1] = {
    widthDelta = 0,
    heightDelta = 0,
    popupAsset = "PopupGridList_Black",
    popupCellAsset = "PopupGridListCell_Black"
  },
  [2] = {
    popupCellAsset = "PopupGridListCell_Preorder"
  },
  [3] = {
    popupAsset = "PopupGridList_Yellow",
    popupCellAsset = "PopupGridListCell_Yellow"
  },
  [4] = {
    popupCellAsset = "PopupGridListCell_AstralGraph"
  }
}

function PopupGridList:ctor(gameObject, funcOnChange, owner, depth, popupAsset, styleConfigID)
  self.gameObject = gameObject
  self.trans = gameObject.transform
  self.funcOnChange = funcOnChange
  self.owner = owner
  self.anchors = {}
  self.datas = {}
  self.redIDs = {}
  self.redTipOffset = {0, 0}
  self:SetMaxCellNum(8.3)
  self:InitSelf()
  self:InitList(depth, popupAsset, styleConfigID)
end

function PopupGridList:InitSelf()
  self.labCurrent = Game.GameObjectUtil:DeepFind(self.gameObject, "labCurrent"):GetComponent(UILabel)
  self.objSelect = Game.GameObjectUtil:DeepFind(self.gameObject, "ItemTabsBgSelect")
  self.l_objArrow = Game.GameObjectUtil:DeepFind(self.gameObject, "tabsArrow")
  self.tsfArrow = self.l_objArrow and self.l_objArrow.transform
  self.objListContainer = Game.GameObjectUtil:DeepFind(self.gameObject, "listContainer") or self.gameObject
  local l_objTabsBG = Game.GameObjectUtil:DeepFind(self.gameObject, "ItemTabsBg")
  self.sprTabsBG = l_objTabsBG:GetComponent(UISprite)
  self.objRedTipContainer = Game.GameObjectUtil:DeepFind(self.gameObject, "redTipParent")
  UIEventListener.Get(self.gameObject).onClick = function(go)
    AudioUtility.PlayOneShot2D_Path(AudioMap.UI.Click, AudioSourceType.UI)
    self:ShowList()
  end
end

function PopupGridList:InitList(depth, popupAsset, styleConfigID)
  self.styleConfig = styleConfig[styleConfigID]
  local popupAssetName = self.styleConfig and self.styleConfig.popupAsset or popupAsset or "PopupGridList"
  self.objList = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPopup(popupAssetName), self.objListContainer)
  if not self.objList then
    redlog("Load Failed: popup/" .. popupAssetName)
    return
  end
  self.panelList = self.objList:GetComponent(UIPanel)
  if not depth then
    local panel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
    depth = panel and panel.depth + 1
  end
  depth = depth or 0
  self.panelList.depth = depth
  local l_objContainer = Game.GameObjectUtil:DeepFind(self.objList, "Container")
  local l_objScroll = Game.GameObjectUtil:DeepFind(l_objContainer, "scrollPopupItems")
  self.scrollView = l_objScroll:GetComponent(UIScrollView)
  local l_objGrid = Game.GameObjectUtil:DeepFind(l_objScroll, "gridPopupItems")
  local l_gridPopupItems = l_objGrid:GetComponent(UIGrid)
  self.cellHeight = l_gridPopupItems.cellHeight
  if styleConfigID == 2 then
    self.listCells = UIGridListCtrl.new(l_gridPopupItems, PopupGridListCell_Preorder, self.styleConfig and self.styleConfig.popupCellAsset or "PopupGridListCell")
  else
    self.listCells = UIGridListCtrl.new(l_gridPopupItems, PopupGridListCell, self.styleConfig and self.styleConfig.popupCellAsset or "PopupGridListCell")
  end
  self.listCells:AddEventListener(MouseEvent.MouseClick, self.OnClickPopupCell, self)
  local l_panelScroll = l_objScroll:GetComponent(UIPanel)
  l_panelScroll.depth = depth + 1
  self:_AddAnchor(l_objContainer:GetComponent(UIWidget))
  self:_AddAnchor(l_panelScroll)
  self:_AddAnchor(l_objGrid:GetComponent(UIWidget))
  local l_objProgressBar = Game.GameObjectUtil:DeepFind(l_objContainer, "ProgressBar")
  self:_AddAnchor(l_objProgressBar:GetComponent(UIWidget))
  self:_AddAnchor(Game.GameObjectUtil:DeepFind(l_objProgressBar, "foreground"):GetComponent(UIWidget))
  self:_AddAnchor(Game.GameObjectUtil:DeepFind(l_objProgressBar, "background"):GetComponent(UIWidget))
  self.sprBG = Game.GameObjectUtil:DeepFind(self.objList, "bg"):GetComponent(UISprite)
  self.curBGWidth = self.sprBG.width
  self.curBGHeight = self.sprBG.height
  self.clickOtherPlaceScript = self.sprBG:GetComponent(CallBackWhenClickOtherPlace)
  
  function self.clickOtherPlaceScript.call()
    self:ShowList(false)
  end
  
  if self.sprTabsBG then
    self:SetListSize(self.sprTabsBG.width)
  end
  self:ShowList(false, true)
end

function PopupGridList:SetMaxCellNum(maxNum)
  self.maxCellNum = maxNum or self.maxCellNum
end

function PopupGridList:SetListLocalPositionXYZ(x, y, z)
  self.objList.transform.localPosition = LuaGeometry.GetTempVector3(x, y, z)
end

function PopupGridList:SetListSize(width, height, isFix)
  local changed
  if width and self.curBGWidth ~= width then
    changed = true
    self.sprBG.width = width + (self.styleConfig and self.styleConfig.widthDelta or 0)
    self.curBGWidth = width
  end
  if height and self.curBGHeight ~= height then
    changed = true
    self.sprBG.height = height + (self.styleConfig and self.styleConfig.heightDelta or 0)
    self.curBGHeight = height
  end
  if changed then
    self:UpdateAnchors()
  end
  self.isSizeFix = isFix
end

function PopupGridList:_AddAnchor(widget)
  self.anchors[#self.anchors + 1] = widget
end

function PopupGridList:UpdateAnchors()
  if not self.anchors then
    return
  end
  for i = 1, #self.anchors do
    self.anchors[i]:ResetAndUpdateAnchors()
  end
  self:RefreshCellsLabelWidth()
end

function PopupGridList:RefreshCellsLabelWidth()
  local bgWidth = self.sprBG.width
  local cells = self.listCells:GetCells()
  for i = 1, #cells do
    cells[i]:RefreshLabelWidth(bgWidth)
  end
end

function PopupGridList:SetData(list, doNotCallback, doNotClick)
  TableUtility.TableClear(self.datas)
  self:UnRegisterRedTipChecks()
  for i = 1, #list do
    self.datas[i] = list[i]
  end
  self.value = nil
  self.data = nil
  self.listCells:ResetDatas(self.datas)
  local dataNum = #self.datas
  if not self.isSizeFix then
    self:SetListSize(nil, (math.min(dataNum, self.maxCellNum) + 0.9) * self.cellHeight)
  end
  if 0 < dataNum and not doNotClick then
    self:OnClickPopupCell(self.listCells:GetCells()[1], doNotCallback)
  end
  self:ShowList(false, true)
end

function PopupGridList:ClickFirstCell(doNotCallback)
  local dataNum = #self.datas
  if 0 < dataNum then
    local firstcell = self.listCells:GetCells()[1]
    self:OnClickPopupCell(firstcell, doNotCallback)
    return firstcell.data
  end
end

function PopupGridList:ShowRedTip(text, isShow)
  local cells = self.listCells:GetCells()
  local singleCell
  for i = 1, #cells do
    singleCell = cells[i]
    if singleCell.text == tostring(text) then
      singleCell:ShowRedTip(isShow)
      break
    end
  end
end

function PopupGridList:SetValue(text, doNotCallback)
  local cells = self.listCells:GetCells()
  local singleCell
  for i = 1, #cells do
    singleCell = cells[i]
    if singleCell.text == tostring(text) then
      self:OnClickPopupCell(singleCell, doNotCallback)
      break
    end
  end
end

function PopupGridList:OnClickPopupCell(cell, doNotCallback)
  self:ShowList(false)
  if not self.funcOnChange or self.value == cell.text then
    return
  end
  self.labCurrent.text = cell.text
  self.value = cell.text
  self.data = cell.data
  if not doNotCallback then
    self.funcOnChange(self.owner, cell.data)
  end
end

function PopupGridList:ShowList(isShow, immediate)
  if isShow == nil then
    isShow = not self.isShowList
  end
  if self.isShowList == isShow and not immediate then
    return
  end
  self.isShowList = isShow ~= false
  self.clickOtherPlaceScript.enabled = self.isShowList
  if self.objSelect then
    self.objSelect:SetActive(self.isShowList)
  end
  if self.tsfArrow then
    self.tsfArrow.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, self.isShowList and 180 or 0)
  end
  if immediate then
    local tweener = self.objList:GetComponent(TweenAlpha)
    if tweener then
      tweener.enabled = false
    end
    self.panelList.alpha = self.isShowList and 1 or 0
  else
    TweenAlpha.Begin(self.objList, 0.2, self.isShowList and 1 or 0)
  end
  if self.isShowList then
    self.scrollView:ResetPosition()
    self.listCells:Layout()
    self:RefreshCellsLabelWidth()
    local cells = self.listCells:GetCells()
    for i = 1, #cells do
      cells[i]:CheckRedTip()
    end
  end
end

function PopupGridList:SetPopupEnable(enable)
  local boxCollider = self.gameObject:GetComponent(BoxCollider)
  if not boxCollider then
    local boxColliders = self.gameObject:GetComponentsInChildren(BoxCollider, true)
    boxCollider = boxColliders[1]
  end
  boxCollider.enabled = enable
  if self.l_objArrow then
    local arrowIcon = self.l_objArrow:GetComponent(UISprite)
    arrowIcon.alpha = enable and 1 or 0.4
  end
end

function PopupGridList:RegisterTopRedTips(redTipIds, depth)
  self:UnRegisterRedTipChecks()
  if not redTipIds then
    return
  end
  if not self.objRedTipContainer then
    redlog("No RedTip Container!")
    return
  end
  if not depth then
    if self.sprTabsBG then
      depth = self.sprTabsBG.depth + 1
    elseif self.labCurrent then
      depth = self.labCurrent.depth
    end
  end
  if type(redTipIds) == "table" then
    for key, id in pairs(redTipIds) do
      self.redIDs[#self.redIDs + 1] = id
    end
  elseif type(redTipIds) == "number" then
    self.redIDs[1] = redTipIds
  end
  for i = 1, #self.redIDs do
    RedTipProxy.Instance:RegisterUI(self.redIDs[i], self.objRedTipContainer, depth, self.redTipOffset, NGUIUtil.AnchorSide.Center)
  end
end

function PopupGridList:UnRegisterRedTipChecks()
  for i = 1, #self.redIDs do
    RedTipProxy.Instance:UnRegisterUI(self.redIDs[i], self.objRedTipContainer)
  end
  TableUtility.TableClear(self.redIDs)
end

function PopupGridList:Destroy()
  self:UnRegisterRedTipChecks()
  TableUtility.TableClear(self.anchors)
  self.listCells:Destroy()
  GameObject.Destroy(self.objList)
  TableUtility.TableClear(self)
end
