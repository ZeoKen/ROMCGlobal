autoImport("TechTreePageCombineCell")
autoImport("TechTreeToyCell")
TechTreeToyCombineCell = class("TechTreeToyCombineCell", TechTreePageCombineCell)

function TechTreeToyCombineCell:Init()
  TechTreeToyCombineCell.super.Init(self)
  self:InitCells(TechTreeToyPage.ColumnNum, "TechTreeToyCell", TechTreeToyCell, self.grid)
end
