autoImport("TripleTeamReportCell")
TripleTeamPwsReportCell = class("TripleTeamPwsReportCell", TripleTeamReportCell)

function TripleTeamPwsReportCell:FindObjs()
  self.objMvp = self:FindGO("objMvp")
  self.objLine = self:FindGO("objLine")
  self.sprBG = self:FindComponent("Bg", UISprite)
  self.sprBGMyself = self:FindComponent("BgAdd", UISprite)
  self.labName = self:FindComponent("labName", UILabel)
  self.sprProfession = self:FindComponent("sprProfession", UISprite)
  self.labKill = self:FindComponent("labKill", UILabel)
  self.labDeath = self:FindComponent("labDeath", UILabel)
  self.labHelp = self:FindComponent("labHelp", UILabel)
  self.labDamage = self:FindComponent("labDamage", UILabel)
  self.labScore = self:FindComponent("labScore", UILabel)
  self.labSeasonScore = self:FindComponent("labSeasonScore", UILabel)
end

function TripleTeamPwsReportCell:SetLabelData(data)
  if data.hideName then
    self.labName.text = FunctionAnonymous.Me():GetAnonymousName(data.profession)
  else
    self.labName.text = data.username
  end
  self.labKill.text = data.kill
  self.labDeath.text = data.death
  self.labHelp.text = data.help
  self.labDamage.text = StringUtil.FormatMillionNumToStr(data.damage)
  self.labSeasonScore.text = data.seasonScore
  self.labScore.text = data.score
end
