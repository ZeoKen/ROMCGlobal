RoguelikeSkillHandbookCell = class("RoguelikeSkillHandbookCell", BaseCell)
local TypeName = {
  [1] = ZhString.RoguelikeSkill_AttackType,
  [2] = ZhString.RoguelikeSkill_DefenseType,
  [3] = ZhString.RoguelikeSkill_AssistType
}

function RoguelikeSkillHandbookCell:Init()
  self:FindObjs()
end

function RoguelikeSkillHandbookCell:FindObjs()
  self.icon = self:FindComponent("Icon", UISprite)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.typeLabel = self:FindComponent("Type", UILabel)
  self.buildLabel = self:FindComponent("Build", UILabel)
  self:AddCellClickEvent()
end

function RoguelikeSkillHandbookCell:SetData(data)
  self.data = data
  if data then
    self.nameLabel.text = data:GetName()
    self.descLabel.text = data:GetDesc()
    self.typeLabel.text = TypeName[data:GetType()] or ""
    self.buildLabel.text = data:GetBuild()
    IconManager:SetSkillIcon(data:GetIcon(), self.icon)
  end
end
