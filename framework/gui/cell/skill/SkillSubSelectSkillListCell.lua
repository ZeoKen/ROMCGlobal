autoImport("SkillSubSelectCell")
SkillSubSelectSkillListCell = class("SkillSubSelectSkillListCell", SkillSubSelectCell)

function SkillSubSelectSkillListCell:UpdateCell(data)
  local staticData = Table_Skill[data]
  if staticData ~= nil then
    IconManager:SetSkillIconByProfess(staticData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
    self.name.text = staticData.NameZh
    self.bg:SetActive(false)
  end
end
