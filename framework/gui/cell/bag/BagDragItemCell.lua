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
  self:AddOrRemoveGuideId(self.gameObject)
  local guideId
  if data and data.CodeData and data.CodeData.staticData.id and data.CodeData.staticData.id == 5400 then
    guideId = 201
  end
  if data and data.staticData then
    if data.staticData.id == 114 then
      guideId = 1106
    elseif data.staticData.id == 5501 then
      guideId = 1011
    elseif data.staticData.id == 5670 then
      guideId = 1031
    elseif data.staticData.id == 14175 then
      guideId = 490
    elseif data.staticData.id == 14176 then
      guideId = 491
    elseif data.staticData.id == 42691 then
      guideId = 537
    elseif data.staticData.id == 42692 then
      guideId = 540
    elseif data.staticData.id == 45563 then
      guideId = 563
    end
  end
  if guideId then
    self:AddOrRemoveGuideId(self.gameObject, guideId)
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
