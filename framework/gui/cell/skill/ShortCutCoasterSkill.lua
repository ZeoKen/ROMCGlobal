autoImport("BaseCell")
ShortCutCoasterSkill = class("ShortCutCoasterSkill", BaseCell)

function ShortCutCoasterSkill:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.clickObj = self:FindGO("Click") or self.gameObject
  self.labelOrder = self:FindGO("LabelOrder"):GetComponent(UILabel)
  self:SetEvent(self.clickObj, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ShortCutCoasterSkill:SetData(data)
  self.data = data
  self:SetSkillIcon(data.icon)
  self.labelOrder.text = tostring(self.data.text)
end

function ShortCutCoasterSkill:SetSkillIcon(icon)
  IconManager:SetSkillIcon(icon, self.icon)
end
