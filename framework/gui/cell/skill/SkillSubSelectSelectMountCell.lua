autoImport("SkillSubSelectCell")
SkillSubSelectSelectMountCell = class("SkillSubSelectSelectMountCell", SkillSubSelectCell)

function SkillSubSelectSelectMountCell:UpdateCell(data)
  local itemData = BagProxy.Instance:GetItemByGuid(data)
  if itemData ~= nil then
    IconManager:SetItemIcon(GameConfig.Pet.PetMountIcon[itemData.staticData.id] or itemData.staticData.Icon, self.icon)
    self.name.text = itemData:GetName()
    self.bg:SetActive(true)
  end
end
