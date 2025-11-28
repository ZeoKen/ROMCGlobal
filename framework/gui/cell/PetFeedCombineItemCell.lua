autoImport("BaseCombineCell")
PetFeedCombineItemCell = class("PetFeedCombineItemCell", BaseCombineCell)
autoImport("ExchangeItemCell")

function PetFeedCombineItemCell:Init()
  self:InitCells(4, "ExchangeItemCell", ExchangeItemCell)
end
