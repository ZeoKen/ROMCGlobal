autoImport("SkillSubCell")
SkillSubSelectMountCell = class("SkillSubSelectMountCell", SkillSubCell)

function SkillSubSelectMountCell:UpdateCell(data)
  local itemData = BagProxy.Instance:GetItemByGuid(data)
  if itemData ~= nil then
    IconManager:SetItemIcon(GameConfig.Pet.PetMountIcon[itemData.staticData.id] or itemData.staticData.Icon, self.icon)
  end
end
