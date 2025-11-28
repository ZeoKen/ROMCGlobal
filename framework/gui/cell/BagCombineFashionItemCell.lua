autoImport("BaseCombineCell")
BagCombineFashionItemCell = class("BagCombineFashionItemCell", BaseCombineCell)
autoImport("BagFashionItemCell")

function BagCombineFashionItemCell:Init()
  self:InitCells(5, "BagFashionItemCell", BagFashionItemCell)
end
