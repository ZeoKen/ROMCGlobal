local BaseCell = autoImport("BaseCell")
SpaceTimeAffixCell = class("SpaceTimeAffixCell", BaseCell)

function SpaceTimeAffixCell:Init()
  self:FindObjs()
end

function SpaceTimeAffixCell:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
end

function SpaceTimeAffixCell:SetData(data)
  self.data = data
  local staticData = Table_MonsterAffix[data]
  if staticData then
    self.gameObject:SetActive(true)
    IconManager:SetSkillIcon(staticData.Icon, self.icon)
    self.icon:SetMaskPath(UIMaskConfig.SkillMask)
    self.icon.OpenMask = true
    self.icon.OpenCompress = true
  else
    self.gameObject:SetActive(false)
  end
end
