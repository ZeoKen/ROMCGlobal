autoImport("GemCell")
autoImport("DragDropCell")
GemDragCell = class("GemDragCell", GemCell)

function GemDragCell:Init()
  GemDragCell.super.Init(self)
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.ShowGemCell
  
  function self.dragDrop.dragDropComponent.OnStart(dragItem)
    self:PassEvent(ItemEvent.GemDragStart, self)
  end
  
  function self.dragDrop.dragDropComponent.OnDropEmpty(dragItem)
    self:PassEvent(ItemEvent.GemDragEnd, self)
  end
  
  function self.dragDrop.onManualEndDrag()
    GemEmbedPage.RecordManualEndDragTime()
  end
  
  self:SetDragEnable(true)
end

function GemDragCell:SetData(data)
  GemDragCell.super.SetData(self, data)
  self.dragDrop.dragDropComponent.data = BagItemCell.CheckData(data) and data or nil
end

function GemDragCell:SetDragEnable(value)
  self.dragDrop:SetDragEnable(value)
end
