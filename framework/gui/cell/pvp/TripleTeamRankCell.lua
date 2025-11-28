autoImport("TeamPwsRankCell")
autoImport("TripleTeamSeasonLevelCell")
TripleTeamRankCell = class("TripleTeamRankCell", TeamPwsRankCell)

function TripleTeamRankCell:FindObjs()
  TripleTeamRankCell.super.FindObjs(self)
  self.gradeCellContainer = self:FindGO("labGrade")
  self.seasonLevelCell = TripleTeamSeasonLevelCell.new(self.gradeCellContainer)
end

function TripleTeamRankCell:UpdateLevel()
  if self.data then
    self.seasonLevelCell:SetData(self.data)
  end
end
