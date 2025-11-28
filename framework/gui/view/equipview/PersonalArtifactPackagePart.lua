autoImport("BagDragItemCell")
autoImport("WrapListCtrl")
PersonalArtifactPackagePart = class("PersonalArtifactPackagePart", CoreView)
local localPosCache = LuaVector3.Zero()

function PersonalArtifactPackagePart:ctor()
end

function PersonalArtifactPackagePart:CreateSelf(parent)
  if self.isInited == true then
    return
  end
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/PersonalArtifactPackagePart", parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
  self.isInited = true
end

function PersonalArtifactPackagePart:InitPart()
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.itemContainer = self:FindGO("ItemContainer")
  self.listCtrl = WrapListCtrl.new(self.itemContainer, BagDragItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 4, 102, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.listCtrl:AddEventListener(MouseEvent.DoubleClick, self.OnDoubleClickCell, self)
  self.itemCells = self.listCtrl:GetCells()
  
  function self.scrollView.onDragStarted()
    self:SetItemDragEnabled(false)
  end
  
  function self.scrollView.onDragFinished()
    self:SetItemDragEnabled(self:CheckCanDrag())
  end
  
  self:InitTabs()
  local hideFunc = function()
    ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_ARTIFACT)
    ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT)
    self:Hide()
  end
  self:AddButtonEvent("CloseButton", hideFunc)
  self:AddButtonEvent("FunctionBtn", function()
    TipManager.CloseTip()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PersonalArtifactFunctionView
    })
  end)
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.noneTip = self:FindGO("NoneTip")
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.closeComp.callBack = hideFunc
end

function PersonalArtifactPackagePart:SetItemDragEnabled(b)
  for _, cell in pairs(self.itemCells) do
    cell:CanDrag(b)
  end
end

function PersonalArtifactPackagePart:InitTabs()
  local tabParent = self:FindGO("Tabs")
  local sps = UIUtil.GetAllComponentsInChildren(tabParent, UISprite)
  for i = 1, #sps do
    sps[i]:MakePixelPerfect()
  end
  self:AddButtonEvent("FragmentTab", function()
    self:UpdatePage(SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT)
  end)
  self:AddButtonEvent("ArtifactTab", function()
    self:UpdatePage(SceneItem_pb.EPACKTYPE_ARTIFACT)
  end)
  self.fragTabToggle = self:FindComponent("FragmentTab", UIToggle, tabParent)
  self.artifactTabToggle = self:FindComponent("ArtifactTab", UIToggle, tabParent)
end

local isNewPredicate = function(data)
  return data.IsNew and data:IsNew() and 1 or 0
end
local comparer = function(l, r)
  local ln, rn, ls, rs = isNewPredicate(l), isNewPredicate(r), l.staticData.id, r.staticData.id
  if ln ~= rn then
    return ln > rn
  end
  if ls ~= rs then
    return ls < rs
  end
  return l.id < r.id
end

function PersonalArtifactPackagePart:CheckCanDrag()
  return self.currentBagType == SceneItem_pb.EPACKTYPE_ARTIFACT and BagProxy.Instance.packageEnter == true
end

function PersonalArtifactPackagePart:UpdatePage(bagType, noResetPos)
  self.currentBagType = bagType or self.currentBagType or SceneItem_pb.EPACKTYPE_ARTIFACT
  local items, bagItems = ReusableTable.CreateArray()
  if self.currentBagType == SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT then
    bagItems = BagProxy.Instance.personalArtifactFragmentBagData:GetItems()
  elseif self.currentBagType == SceneItem_pb.EPACKTYPE_ARTIFACT then
    bagItems = BagProxy.Instance.personalArtifactBagData:GetItems()
  end
  if not bagItems then
    LogUtility.Warning("Cannot update personal artifact package when bagData = nil!")
    return
  end
  for i = 1, #bagItems do
    TableUtility.ArrayPushBack(items, bagItems[i])
  end
  if #items == 0 then
    self.noneTip:SetActive(true)
    self.scrollView.gameObject:SetActive(false)
  else
    table.sort(items, comparer)
    self.noneTip:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
    self.listCtrl:ResetDatas(bagItems, not noResetPos)
    self:SetItemDragEnabled(self:CheckCanDrag())
    self.scrollView.enabled = true
  end
  ReusableTable.DestroyAndClearArray(items)
end

function PersonalArtifactPackagePart:UpdateInfo(noResetPos)
  self:UpdatePage(self.currentBagType or SceneItem_pb.EPACKTYPE_ARTIFACT, noResetPos)
end

function PersonalArtifactPackagePart:OnDoubleClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  local funcIds = data and FunctionItemFunc.GetItemFuncIds(data.staticData.id)
  if not funcIds then
    return
  end
  local arr, cfgData, state = ReusableTable.CreateArray()
  for i = 1, #funcIds do
    cfgData = GameConfig.ItemFunction[funcIds[i]]
    state = cfgData and FunctionItemFunc.Me():CheckFuncState(cfgData.type, data)
    if state == ItemFuncState.Active then
      TableUtility.ArrayPushBack(arr, funcIds[i])
    end
  end
  local func = FunctionItemFunc.Me():GetFuncById(arr[1])
  if type(func) == "function" then
    func(data)
  end
  ReusableTable.DestroyAndClearArray(arr)
  self:UpdateChooseId()
end

function PersonalArtifactPackagePart:OnClickCell(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self:UpdateChooseId(newChooseId)
    self:ShowItemTip(go, data)
  else
    self:UpdateChooseId()
  end
end

local tipOffset = {190, 0}

function PersonalArtifactPackagePart:ShowItemTip(cellGO, data)
  if not data then
    TipManager.CloseTip()
    return
  end
  local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, cellGO.transform, Space.World)
  tipOffset[1] = 0 < x and -650 or 190
  self.tipData = self.tipData or {
    ignoreBounds = {
      self.itemContainer
    },
    callback = function()
      self:UpdateChooseId()
    end
  }
  self.tipData.itemdata = data
  self.tipData.funcConfig = FunctionItemFunc.GetItemFuncIds(data.staticData.id)
  local tip = PersonalArtifactPackagePart.super.ShowItemTip(self, self.tipData, self.normalStick, NGUIUtil.AnchorSide.Right, tipOffset)
  if tip then
    self:AddIgnoreBounds(tip.gameObject)
    if tip.ActiveFavorite then
      tip:ActiveFavorite()
    end
  end
end

function PersonalArtifactPackagePart:SetPos(x, y, z)
  if self.gameObject then
    self.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, z)
    self:UpdateLocalPosCache()
  end
end

function PersonalArtifactPackagePart:UpdateLocalPosCache()
  LuaVector3.Better_Set(localPosCache, LuaGameObject.GetLocalPosition(self.gameObject.transform))
end

function PersonalArtifactPackagePart:SetLocalOffset(x, y, z)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(localPosCache[1] + x, localPosCache[2] + y, localPosCache[3] + z)
end

function PersonalArtifactPackagePart:Show()
  if not self.isInited then
    LogUtility.Warning("Trying to show PersonalArtifactPackagePart without initializing it first.")
    return
  end
  self.gameObject:SetActive(true)
  self:UpdatePage()
  EventManager.Me():AddEventListener(ItemEvent.PersonalArtifactUpdate, self.OnItemUpdate, self)
end

function PersonalArtifactPackagePart:Hide()
  if not self.isInited then
    LogUtility.Warning("Trying to hide PersonalArtifactPackagePart without initializing it first.")
    return
  end
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.PersonalArtifactUpdate, self.OnItemUpdate, self)
end

function PersonalArtifactPackagePart:OnItemUpdate()
  self:UpdatePage()
  self:OnClickCell()
end

function PersonalArtifactPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function PersonalArtifactPackagePart:UpdateChooseId(id)
  id = id or 0
  self.chooseId = id
  if id == 0 then
    TipManager.CloseTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function PersonalArtifactPackagePart:ShowTab(tabIndex)
  if tabIndex == 2 then
    self:UpdatePage(SceneItem_pb.EPACKTYPE_ARTIFACT)
    self.artifactTabToggle.value = true
  else
    self:UpdatePage(SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT)
    self.fragTabToggle.value = true
  end
end

function PersonalArtifactPackagePart:SetAnchorSide(side)
  side = side or NGUIUtil.AnchorSide.Left
  if self.anchorSide ~= side then
    self.anchorSide = side
    if side == NGUIUtil.AnchorSide.Right then
      self:SetLocalOffset(440, 0, 0)
    else
      self:SetLocalOffset(0, 0, 0)
    end
  end
end
