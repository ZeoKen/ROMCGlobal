autoImport("SkillSubCell")
SkillSubSkillListCell = class("SkillSubSkillListCell", SkillSubCell)

function SkillSubSkillListCell:UpdateCell(data)
  local staticData = Table_Skill[data]
  if staticData ~= nil then
    IconManager:SetSkillIconByProfess(staticData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
  end
end
