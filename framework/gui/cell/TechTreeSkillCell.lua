local baseCell = autoImport("BaseCell")
TechTreeSkillCell = class("TechTreeSkillCell", baseCell)

function TechTreeSkillCell:Init()
  self.icon = self.gameObject:GetComponent(UISprite)
  self.choose = self:FindGO("Choose")
  self:AddCellClickEvent()
end

function TechTreeSkillCell:SetData(data)
  self.data = data
  if data then
    IconManager:SetSkillIcon(Table_Skill[data].Icon, self.icon)
  end
  self:UpdateChoose()
end

function TechTreeSkillCell:SetChooseId(id)
  self.chooseId = id
  self:UpdateChoose()
end

function TechTreeSkillCell:UpdateChoose()
  self.choose:SetActive(self.chooseId ~= nil and self.data ~= nil and self.chooseId == self.data)
end

function TechTreeSkillCell:HandleDragScroll(dragComp)
  UIUtil.HandleDragScrollForObj(self.gameObject, dragComp)
end
