autoImport("BaseCombineCell")
HireCatSkillCombineItemCell = class("HireCatSkillCombineItemCell", BaseCombineCell)
autoImport("HireCatSkillCell")

function HireCatSkillCombineItemCell:Init()
  self:InitCells(4, "HireCatSkillCell", HireCatSkillCell)
end
