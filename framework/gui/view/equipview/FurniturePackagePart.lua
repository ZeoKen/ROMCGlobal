autoImport("CoreView")
FurniturePackagePart = class("FurniturePackagePart", CoreView)
autoImport("BagItemCell")
autoImport("WrapListCtrl")

function FurniturePackagePart:ctor()
end

local FurniturePackagePart_Path = "GUI/v1/part/FurniturePackagePart"

function FurniturePackagePart:CreateSelf(parent)
  if self.inited == true then
    return
  end
  self.inited = true
  self.gameObject = self:LoadPreferb_ByFullPath(FurniturePackagePart_Path, parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
end

function FurniturePackagePart:InitPart()
  self:InitScrollPull()
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    self:Hide()
  end)
  local container = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(container, BagItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 4, 100)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.noneTip = self:FindGO("NoneTip")
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:Hide()
  end
  
  self:MapEvent()
end

function FurniturePackagePart:InitScrollPull()
  self.waitting = self:FindComponent("Waitting", UILabel)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.panel = self.scrollView.gameObject:GetComponent(UIPanel)
  
  function self.scrollView.OnBackToStop()
    self.waitting.text = ZhString.ItemNormalList_Refreshing
  end
  
  function self.scrollView.OnStop()
    self.scrollView:Revert()
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_FURNITURE)
  end
  
  function self.scrollView.OnPulling(offsetY, triggerY)
    self.waitting.text = offsetY < triggerY and ZhString.ItemNormalList_PullRefresh or ZhString.ItemNormalList_CanRefresh
  end
  
  function self.scrollView.OnRevertFinished()
    self.waitting.text = ZhString.ItemNormalList_PullRefresh
  end
end

function FurniturePackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function FurniturePackagePart:ClickItemCell(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowPackageItemTip(data, go)
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function FurniturePackagePart:ShowPackageItemTip(data, cellGO)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local offset = {}
  local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, cellGO.transform, Space.World)
  if 0 < x then
    offset[1] = -650
    offset[2] = 0
  else
    offset[1] = 190
    offset[2] = 0
  end
  local callback = function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds,
    callback = callback,
    funcConfig = FunctionItemFunc.GetItemFuncIds(data.staticData.id)
  }
  local itemtip = self:ShowItemTip(sdata, self.normalStick, NGUIUtil.AnchorSide.Right, offset)
  itemtip:AddIgnoreBounds(self.gameObject)
  self:AddIgnoreBounds(itemtip.gameObject)
end

function FurniturePackagePart:UpdateInfo()
  local furnitureBag = BagProxy.Instance.furnitureBagData
  local items = furnitureBag:GetItems()
  if #items == 0 then
    self.noneTip:SetActive(true)
    self.scrollView.gameObject:SetActive(false)
    return
  else
    self.noneTip:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
  end
  self.itemCtrl:ResetDatas(items)
end

function FurniturePackagePart:SetPos(x, y, z)
  if self.gameObject then
    self.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, z)
    self:UpdateLocalPosCache()
  end
end

function FurniturePackagePart:UpdateLocalPosCache()
  self.localPos_x, self.localPos_y, self.localPos_z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
end

function FurniturePackagePart:SetLocalOffset(x, y, z)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.localPos_x + x, self.localPos_y + y, self.localPos_z + z)
end

function FurniturePackagePart:MapEvent()
end

function FurniturePackagePart:Show()
  if not self.inited then
    return
  end
  self.gameObject:SetActive(true)
  EventManager.Me():AddEventListener(ItemEvent.FurnitureUpdate, self.UpdateInfo, self)
end

function FurniturePackagePart:Hide()
  if not self.inited then
    return
  end
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_FURNITURE)
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.FurnitureUpdate, self.UpdateInfo, self)
  TipManager.Instance:CloseTip()
end
