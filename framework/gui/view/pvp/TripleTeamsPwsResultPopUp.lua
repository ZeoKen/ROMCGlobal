autoImport("TripleTeamsResultPopUp")
autoImport("TripleTeamPwsReportCell")
TripleTeamsPwsResultPopUp = class("TripleTeamsPwsResultPopUp", TripleTeamsResultPopUp)
local SortType = {
  Name = 1,
  Kill = 2,
  Death = 3,
  Help = 4,
  Damage = 5,
  SeasonScore = 6,
  Score = 7
}

function TripleTeamsPwsResultPopUp:InitReportList()
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, TripleTeamPwsReportCell, "TripleTeamPwsReportCell")
end

function TripleTeamsPwsResultPopUp:AddButtonEvts()
  TripleTeamsResultPopUp.super.AddButtonEvts(self)
  local parent = self:FindGO("ReportTitles")
  local objButton = self:FindGO("labName", parent)
  self:AddClickEvent(objButton, function()
    self:SortByName()
  end)
  objButton = self:FindGO("labKill", parent)
  self:AddClickEvent(objButton, function()
    self:SortByKill()
  end)
  objButton = self:FindGO("labDeath", parent)
  self:AddClickEvent(objButton, function()
    self:SortByDeath()
  end)
  objButton = self:FindGO("labHelp", parent)
  self:AddClickEvent(objButton, function()
    self:SortByHelp()
  end)
  objButton = self:FindGO("labDamage", parent)
  self:AddClickEvent(objButton, function()
    self:SortByDamage()
  end)
  objButton = self:FindGO("labSeasonScore", parent)
  self:AddClickEvent(objButton, function()
    self:SortBySeasonScore()
  end)
  objButton = self:FindGO("labScore", parent)
  self:AddClickEvent(objButton, function()
    self:SortByScore()
  end)
end

function TripleTeamsPwsResultPopUp:SortBySeasonScore()
  if self.sortType == SortType.SeasonScore then
    return
  end
  table.sort(self.players, function(x, y)
    return x.seasonScore > y.seasonScore
  end)
  self.sortType = SortType.SeasonScore
  self:UpdateReportList()
end

function TripleTeamsPwsResultPopUp:SortByScore()
  if self.sortType == SortType.Score then
    return
  end
  table.sort(self.players, function(x, y)
    return x.score > y.score
  end)
  self.sortType = SortType.Score
  self:UpdateReportList()
end
