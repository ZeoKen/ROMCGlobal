autoImport("TripleTeamsResultPopUp")
TripleTeamsDetailPopUp = class("TripleTeamsDetailPopUp", TripleTeamsResultPopUp)
TripleTeamsDetailPopUp.ViewType = UIViewType.NormalLayer

function TripleTeamsDetailPopUp:Init()
  TripleTeamsDetailPopUp.super.Init(self)
  self.players = {}
  ServiceFuBenCmdProxy.Instance:CallSyncTripleFightingInfoFuBenCmd()
end

function TripleTeamsDetailPopUp:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, TripleTeamReportCell, "TripleTeamReportCell")
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
  objButton = self:FindGO("labHeal", parent)
  self:AddClickEvent(objButton, function()
    self:SortByHeal()
  end)
  objButton = self:FindGO("labBeDamaged", parent)
  self:AddClickEvent(objButton, function()
    self:SortByBeDamaged()
  end)
end

function TripleTeamsDetailPopUp:AddViewEvts()
  TripleTeamsDetailPopUp.super.AddViewEvts(self)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleFightingInfoFuBenCmd, self.RefreshView)
end

function TripleTeamsDetailPopUp:OnEnter()
  TeamPwsFightResultPopUp.super.OnEnter(self)
end

function TripleTeamsDetailPopUp:OnExit()
  TeamPwsFightResultPopUp.super.OnExit(self)
end

function TripleTeamsDetailPopUp:RefreshView()
  redlog("TripleTeamsDetailPopUp:RefreshView")
  local maxScore = 0
  local maxScoreIndex = 0
  local camps = PvpProxy.Instance:GetTripleCampInfos()
  for i = 1, #camps do
    local data = camps[i]
    if maxScore < data.score then
      maxScoreIndex = i
      maxScore = data.score
    end
  end
  if 0 < maxScoreIndex then
    local maxScoreCamp = table.remove(camps, maxScoreIndex)
    table.insert(camps, 1, maxScoreCamp)
  end
  TableUtility.ArrayClear(self.players)
  for i = 1, #camps do
    for j = 1, #camps[i].users do
      local charid = camps[i].users[j]
      local user = PvpProxy.Instance:GetTripleUserInfo(charid)
      self.players[#self.players + 1] = user
    end
  end
  self:UpdateReportList()
end

function TripleTeamsDetailPopUp:ClickButtonLeave()
  self:CloseSelf()
end
