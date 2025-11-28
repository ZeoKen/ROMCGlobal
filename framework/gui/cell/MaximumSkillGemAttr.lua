MaximumSkillGemAttr = class("MaximumSkillGemAttr", CoreView)

function MaximumSkillGemAttr:ctor(obj)
  MaximumSkillGemAttr.super.ctor(self, obj)
  self.content = self:FindComponent("Content", UILabel)
  self.bg = self:FindComponent("Bg", UIWidget)
end

function MaximumSkillGemAttr:SetData(data)
  self.content.text = data
  self.bg:ResetAndUpdateAnchors()
end
