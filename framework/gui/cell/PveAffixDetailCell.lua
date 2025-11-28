local _tex = "Novicecopy_affix_iconbg"
autoImport("WildMvpAffixDetailCell")
PveAffixDetailCell = class("PveAffixDetailCell", WildMvpAffixDetailCell)

function PveAffixDetailCell:Init()
  PveAffixDetailCell.super.Init(self)
  self.texture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI(_tex, self.texture)
end

function PveAffixDetailCell:OnRemove()
  PictureManager.Instance:UnLoadUI(_tex, self.texture)
end
