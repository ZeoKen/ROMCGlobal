autoImport("DisneySongCell")
autoImport("BaseCombineCell")
DisneySongCombineCell = class("DisneySongCombineCell", BaseCombineCell)
autoImport("DisneySongCell")

function DisneySongCombineCell:Init()
  self:InitCells(3, "DisneySongCell", DisneySongCell)
end
