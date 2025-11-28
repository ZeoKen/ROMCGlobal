autoImport("PveDifficultyCell")
SkadaPveDifficultyCell = class("SkadaPveDifficultyCell", PveDifficultyCell)
local bgSprite = "Novicecopy_bg_06"
local effectColor = Color(0.4980392156862745, 0.6941176470588235, 0.8705882352941177, 1)

function SkadaPveDifficultyCell:SetData(data)
  SkadaPveDifficultyCell.super.SetData(self, data)
  self.finishGo:SetActive(false)
  self.lockGo:SetActive(false)
  self.bg.spriteName = bgSprite
  self.desc.effectColor = effectColor
end
