local BaseCell = autoImport("BaseCell")
WildMvpAffixDetailCell = class("WildMvpAffixDetailCell", BaseCell)

function WildMvpAffixDetailCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.title = self:FindComponent("Title", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
end

function WildMvpAffixDetailCell:SetData(data)
  self.data = data
  if data and data.staticData then
    local staticData = data.staticData
    self.title.text = staticData.Name or ""
    self.desc.text = staticData.Desc or ""
    if staticData.Icon then
      IconManager:SetSkillIcon(staticData.Icon, self.icon)
      self.icon:SetMaskPath(UIMaskConfig.SkillMask)
      self.icon.OpenMask = true
      self.icon.OpenCompress = true
    end
  end
end
