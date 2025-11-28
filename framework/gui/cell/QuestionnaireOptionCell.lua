QuestionnaireOptionCell = class("QuestionnaireOptionCell", CoreView)

function QuestionnaireOptionCell:ctor(obj)
  QuestionnaireOptionCell.super.ctor(self, obj)
  self:Init()
end

function QuestionnaireOptionCell:Init()
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self.label = self:FindComponent("Label", UILabel)
end

function QuestionnaireOptionCell:SetData(data)
  self.data = data
  self.label.text = data and data.text or ""
end
