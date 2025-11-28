autoImport("ItemCell")
InheritSkillMaterialCell = class("InheritSkillMaterialCell", ItemCell)
local RedColor = "ee5b5b"
local BlackColor = "000000"

function InheritSkillMaterialCell:SetNumLabelState(isLack)
  if not self.numLab then
    self.numLab = self:FindComponent("NumLabel", UILabel, self.item)
  end
  local colStr = isLack and RedColor or BlackColor
  local str = self.data.num
  self.numLab.text = string.format("[c][%s]%s[-][/c]", colStr, str)
end

function InheritSkillMaterialCell:GetBgSprite()
  local bg = InheritSkillMaterialCell.super.GetBgSprite(self)
  self:AddClickEvent(bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  return bg
end
