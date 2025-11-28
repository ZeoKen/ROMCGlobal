autoImport("DifficultyPathNodeCell")
HeroRoadDiffPathBigNodeCell = class("HeroRoadDiffPathBigNodeCell", DifficultyPathNodeCell)

function HeroRoadDiffPathBigNodeCell:FindObjs()
  HeroRoadDiffPathBigNodeCell.super.FindObjs(self)
  self.icon = self:FindComponent("Icon", UISprite)
end

function HeroRoadDiffPathBigNodeCell:SetData(data)
  HeroRoadDiffPathBigNodeCell.super.SetData(self, data)
  local monsters = self.pvePassInfo:GetMonsters()
  IconManager:SetNpcMonsterIconByID(monsters[1], self.icon)
  self.icon:SetMaskPath(UIMaskConfig.SimpleHeadMask)
  self.icon.OpenMask = true
  self.icon.OpenCompress = false
  self.icon.NeedOffset2 = false
  local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_simple"
  Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.icon)
  if data.isUnlocked then
    self.icon.color = ColorUtil.NGUIWhite
  else
    self.icon.color = ColorUtil.NGUIShaderGray
  end
end
