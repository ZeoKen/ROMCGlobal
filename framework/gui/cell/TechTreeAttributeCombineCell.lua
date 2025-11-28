autoImport("TechTreePageCombineCell")
autoImport("TechTreeAttributeCell")
TechTreeAttributeCombineCell = class("TechTreeAttributeCombineCell", TechTreePageCombineCell)

function TechTreeAttributeCombineCell:Init()
  TechTreeAttributeCombineCell.super.Init(self)
  self:InitCells(TechTreeAttributePage.ColumnNum, "TechTreeAttributeCell", TechTreeAttributeCell, self.grid)
end
