autoImport("BaseCombineCell")
StageCombineItemCell = class("StageCombineItemCell", BaseCombineCell)
autoImport("StageItemCell")

function StageCombineItemCell:Init()
  self:InitCells(4, "StageItemCell", StageItemCell)
end
