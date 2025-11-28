CardRandomMakeMaterialCell = class("CardRandomMakeMaterialCell", ItemCell)

function CardRandomMakeMaterialCell:InitItemCell()
  CardRandomMakeMaterialCell.super.InitItemCell(self)
  self:AddCellClickEvent()
end
