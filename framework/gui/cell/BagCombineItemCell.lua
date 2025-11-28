autoImport("BaseCombineCell")
BagCombineItemCell = class("BagCombineItemCell", BaseCombineCell)
autoImport("BagItemCell")

function BagCombineItemCell:Init()
  self:InitCells(5, "BagItemCell", BagItemCell)
end
