local singleLineLabHeight = 48
local singleLineBgHeight = 110
local deltaHeight = 60
autoImport("SkillTip")
PveSkillCell = class("PveSkillCell", BaseCell)

function PveSkillCell:Init()
  PveSkillCell.super.Init(self)
  self:FindObj()
end

function PveSkillCell:FindObj()
  self.bg = self:FindComponent("Bg", UISprite)
  self.skillIcon = self:FindComponent("Icon", UISprite)
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
end

function PveSkillCell:SetData(skill_id)
  self.data = skill_id
  local staticData = Table_Skill[skill_id]
  self.nameLab.text = staticData.NameZh
  IconManager:SetSkillIcon(staticData.Icon, self.skillIcon)
  self.descLab.text = SkillTip:GetDesc(staticData)
  if self.descLab.height <= singleLineLabHeight then
    self.bg.height = singleLineBgHeight
  else
    self.bg.height = self.descLab.height + deltaHeight
  end
end
