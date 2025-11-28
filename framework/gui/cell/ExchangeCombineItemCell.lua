autoImport("BaseCombineCell")
ExchangeCombineItemCell = class("ExchangeCombineItemCell", BaseCombineCell)
autoImport("ExchangeItemCell")

function ExchangeCombineItemCell:Init()
  self:InitCells(5, "ExchangeItemCell", ExchangeItemCell)
end
