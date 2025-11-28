autoImport("OthelloReportCell")
autoImport("TeamPwsReportPanel")
OthelloReportPanel = class("OthelloReportPanel", TeamPwsReportPanel)

function OthelloReportPanel:Init()
  local lb = self:FindGO("labBallScore"):GetComponent(UILabel)
  lb.text = ZhString.PvpOthello_ocupiedScore
  OthelloReportPanel.super.Init(self)
end

function OthelloReportPanel:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  self.labRedTeamScore = self:FindComponent("labRedTeamScore", UILabel)
  self.labBlueTeamScore = self:FindComponent("labBlueTeamScore", UILabel)
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, OthelloReportCell, "TeamPwsReportCell")
  local labRedTeam = self:FindComponent("labRedTeam", UILabel)
  local labBlueTeam = self:FindComponent("labBlueTeam", UILabel)
  labRedTeam.text = ZhString.PvpOthello_whiteTeam
  labBlueTeam.text = ZhString.PvpOthello_blackTeam
end

function OthelloReportPanel:InitData()
  self.data = PvpProxy.Instance:GetOthelloReportData()
  self:UpdateData()
end

function OthelloReportPanel:SortByBallScore()
  if self.sortType == TeamPwsReportPanel.SortType.BallScore then
    return
  end
  table.sort(self.data.reports, function(x, y)
    return x.occupyscore > y.occupyscore
  end)
  self.sortType = TeamPwsReportPanel.SortType.BallScore
  self:UpdateData()
end

function OthelloReportPanel:StartLoading()
  OthelloReportPanel.super.StartLoading(self)
end
