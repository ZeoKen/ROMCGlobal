ComodoBuildingFurnitureTabListCell = class("ComodoBuildingFurnitureTabListCell", CoreView)

function ComodoBuildingFurnitureTabListCell:ctor(obj)
  ComodoBuildingFurnitureTabListCell.super.ctor(self, obj)
  self:Init()
end

function ComodoBuildingFurnitureTabListCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.cLabel = self:FindComponent("CheckmarkLabel", UILabel)
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ComodoBuildingFurnitureTabListCell:SetData(index)
  self.index = index
  local text = GameConfig.Manor.BuildingFurnitureShopFilter[index]
  self.label.text = text
  self.cLabel.text = text
end
