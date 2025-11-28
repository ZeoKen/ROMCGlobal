autoImport("BagItemCell")
autoImport("DragDropCell")
BagDragItemCell = class("BagDragItemCell", BagItemCell)

function BagDragItemCell:Init()
  BagDragItemCell.super.Init(self)
  self:InitDragEvent()
end

function BagDragItemCell:InitDragEvent()
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.OnCursor = self.OnCursor
  
  function self.dragDrop.onManualStartDrag()
    xdlog("开始拖拽")
    self:PassEvent(DragDropEvent.StartDrag, self)
  end
  
  function self.dragDrop.onManualEndDrag()
    xdlog("结束拖拽")
    self:PassEvent(DragDropEvent.EndDrag, self)
  end
end

function BagDragItemCell:SetData(data)
  BagDragItemCell.super.SetData(self, data)
  if data and data ~= "Grey" and data ~= "Empty" then
    self.dragDrop.dragDropComponent.data = {itemdata = data}
  else
    self.dragDrop.dragDropComponent.data = nil
  end
  if data and data.CodeData and data.CodeData.staticData.id then
    if data.CodeData.staticData.id == 5400 then
      self:AddOrRemoveGuideId(self.gameObject, 201)
    else
      self:AddOrRemoveGuideId(self.gameObject)
    end
  end
  if data and data.staticData then
    if data.staticData.id == 5501 then
      self:AddOrRemoveGuideId(self.gameObject, 1011)
    elseif data.staticData.id == 5670 then
      self:AddOrRemoveGuideId(self.gameObject, 1031)
    elseif data.staticData.id == 14175 then
      self:AddOrRemoveGuideId(self.gameObject, 490)
    elseif data.staticData.id == 14176 then
      self:AddOrRemoveGuideId(self.gameObject, 491)
    elseif data.staticData.id == 42691 then
      self:AddOrRemoveGuideId(self.gameObject, 537)
    elseif data.staticData.id == 42692 then
      self:AddOrRemoveGuideId(self.gameObject, 540)
    end
  end
end

function BagDragItemCell:CanDrag(value)
  self.dragDrop:SetDragEnable(value)
end

function BagDragItemCell:OnCellDestroy()
  TableUtility.TableClear(self.dragDrop)
end

function BagDragItemCell.OnCursor(dragItem)
  DragCursorPanel.Instance.ShowItemCell(dragItem)
  local itemData = dragItem.data.itemdata
  local isMemory = itemData and itemData:HasMemoryInfo()
  if not isMemory then
    EventManager.Me():PassEvent(PackageEvent.ActivateSetShortCut)
  end
end
