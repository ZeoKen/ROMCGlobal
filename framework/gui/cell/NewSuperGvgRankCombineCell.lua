autoImport("BaseCombineCell")
autoImport("NewSuperGvgRankCell")
NewSuperGvgRankCombineCell = class("NewSuperGvgRankCombineCell", BaseCombineCell)

function NewSuperGvgRankCombineCell:Init()
  self:InitCells(3, "NewSuperGvgRankCell", NewSuperGvgRankCell)
end
