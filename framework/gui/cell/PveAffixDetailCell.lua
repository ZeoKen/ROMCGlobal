local _tex = "Novicecopy_affix_iconbg"
autoImport("WildMvpAffixDetailCell")
PveAffixDetailCell = class("PveAffixDetailCell", WildMvpAffixDetailCell)

function PveAffixDetailCell:Init()
  PveAffixDetailCell.super.Init(self)
  self.texture = self:FindComponent("Texture", UITexture)
  local panel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if panel then
    self.panel = self:FindComponent("ScrollView", UIPanel)
    if self.panel then
      self.panel.depth = panel.depth + 1
    end
  end
  PictureManager.Instance:SetUI(_tex, self.texture)
end

function PveAffixDetailCell:OnRemove()
  PictureManager.Instance:UnLoadUI(_tex, self.texture)
end
