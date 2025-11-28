local baseCell = autoImport("BaseCell")
SkillSubSelectCell = class("SkillSubSelectCell", baseCell)
SkillSubSelectCell.EnableColor = Color(1, 1, 1, 1)
SkillSubSelectCell.DisableColor = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)

function SkillSubSelectCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SkillSubSelectCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.bg = self:FindGO("Bg")
end

function SkillSubSelectCell:SetData(data)
  self.data = data and data
  self.gameObject:SetActive(data ~= nil)
  if data and data then
    self:UpdateCell(self.data)
  end
end

function SkillSubSelectCell:UpdateCell(data)
end
