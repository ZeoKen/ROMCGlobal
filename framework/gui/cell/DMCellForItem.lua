local baseCell = autoImport("BaseCell")
DMCellForItem = class("DMCellForItem", baseCell)
autoImport("BaseItemCell")

function DMCellForItem:Init()
  self:FindObjs()
  self.DropItemCell = self:FindGO("DropItemCell", self.gameObject)
  self.DropItemCell_ItemCell = BaseItemCell.new(self.DropItemCell)
  self:AddClickEvent(self.DropItemCell.gameObject, function(g)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function DMCellForItem:FindObjs()
end

function DMCellForItem:SetChoose(isChoose)
end

function DMCellForItem:SetData(data)
  local id = data
  local item = ItemData.new("Reward", id)
  self.data = item
  self.DropItemCell_ItemCell:SetData(item)
end
