TripleTeamSeasonLevelCell = class("TripleTeamSeasonLevelCell", BaseCell)
local Res_Path = ResourcePathHelper.UICell("TripleTeamSeasonLevelCell")
local LevelIcon = {
  [1] = "sports_pvp_1",
  [2] = "sports_pvp_2",
  [3] = "sports_pvp_3",
  [4] = "sports_pvp_4",
  [5] = "sports_pvp_5"
}

function TripleTeamSeasonLevelCell:ctor(parent)
  local go = self:LoadPreferb_ByFullPath(Res_Path, parent)
  TripleTeamSeasonLevelCell.super.ctor(self, go)
end

function TripleTeamSeasonLevelCell:Init()
  self:FindObjs()
end

function TripleTeamSeasonLevelCell:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
  self.starsGO = self:FindGO("Stars")
  self.stars = {}
  for i = 1, 5 do
    self.stars[i] = self:FindComponent("Star" .. i, UIMultiSprite)
  end
  self.levelLabel = self:FindComponent("Level", UILabel)
end

function TripleTeamSeasonLevelCell:SetData(data)
  self.data = data
  if data then
    local levelIcon = LevelIcon[data.erank]
    if levelIcon then
      self.icon.spriteName = levelIcon
      self.icon:MakePixelPerfect()
    end
    self.starsGO:SetActive(data.erank < 5)
    self.levelLabel.gameObject:SetActive(data.erank >= 5)
    if data.erank < 5 then
      for i = 1, 5 do
        self.stars[i].CurrentState = data.starnum and i <= data.starnum and 1 or 0
      end
    else
      self.levelLabel.text = (data.rank == 0 or data.rank > 9999) and "9999+" or data.rank
    end
  end
end
