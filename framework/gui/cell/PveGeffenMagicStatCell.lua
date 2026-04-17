local BaseCell = autoImport("BaseCell")
PveGeffenMagicStatCell = class("PveGeffenMagicStatCell", BaseCell)

function PveGeffenMagicStatCell:Init()
  self.nameLab = self:FindComponent("Name", UILabel)
  self.valueLab = self:FindComponent("Value", UILabel)
  self.scoreLab = self:FindComponent("Score", UILabel)
  self.titleIcon = self:FindComponent("TitleIcon", UISprite)
end

function PveGeffenMagicStatCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.nameLab.text = data.desc
  if data.atlas and data.icon then
    self:Show(self.titleIcon)
    self.titleIcon.atlas = RO.AtlasMap.GetAtlas(data.atlas)
    self.titleIcon.spriteName = data.icon
    self.titleIcon:MakePixelPerfect()
  else
    self:Hide(self.titleIcon)
  end
  self.scoreLab.text = data.score
  self.valueLab.text = data.value or ""
end
