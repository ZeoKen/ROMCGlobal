autoImport("DifficultyPathNodeCell")
HeroRoadDiffPathSmallNodeCell = class("HeroRoadDiffPathSmallNodeCell", DifficultyPathNodeCell)

function HeroRoadDiffPathSmallNodeCell:FindObjs()
  HeroRoadDiffPathSmallNodeCell.super.FindObjs(self)
  self.stars = {}
  for i = 1, 3 do
    self.stars[i] = self:FindComponent("Star" .. i, UIMultiSprite)
    self.stars[i].isChangeSnap = false
  end
end

function HeroRoadDiffPathSmallNodeCell:SetData(data)
  HeroRoadDiffPathSmallNodeCell.super.SetData(self, data)
  for i = 1, #self.stars do
    if i <= self.starCount then
      self.stars[i].CurrentState = 1
    else
      self.stars[i].CurrentState = 0
    end
  end
end
