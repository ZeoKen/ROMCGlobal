autoImport("BaseCombineCell")
autoImport("WarbandListCell")
WarbandListCombineCell = class("WarbandListCombineCell", BaseCombineCell)

function WarbandListCombineCell:Init()
  self:InitCells(2, "WarbandListCell", WarbandListCell)
end
