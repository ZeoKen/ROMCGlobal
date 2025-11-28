HeroRoadAchievementCell = class("HeroRoadAchievementCell", BaseCell)

function HeroRoadAchievementCell:Init()
  self:FindObjs()
end

function HeroRoadAchievementCell:FindObjs()
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.starSp = self:FindComponent("Star", UIMultiSprite)
  self.bg = self:FindComponent("Bg", UISprite)
end

function HeroRoadAchievementCell:SetData(data)
  self.data = data
  if data then
    local id = data.id
    local config = Table_HeroJourneyAchievement[id]
    if config then
      self.descLabel.text = config.desc
      self.starSp.CurrentState = data.isAchieved and 1 or 0
      local descLines = math.floor(self.descLabel.printedSize.y / (self.descLabel.fontSize + self.descLabel.spacingY))
      self.bg.height = 1 < descLines and 55 or 35
    end
  end
end
