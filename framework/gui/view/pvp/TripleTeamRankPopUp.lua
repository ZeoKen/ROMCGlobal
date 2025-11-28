autoImport("TeamPwsRankPopUp")
autoImport("TripleTeamRankCell")
TripleTeamRankPopUp = class("TripleTeamRankPopUp", TeamPwsRankPopUp)
TripleTeamRankPopUp.ViewType = UIViewType.PopUpLayer
local SelectCol = "B36B24"
local UnselectCol = "3E59A7"

function TripleTeamRankPopUp:FindObjs()
  TripleTeamRankPopUp.super.FindObjs(self)
  self.scoreLimitLabel = self:FindComponent("ScoreLimit", UILabel)
  self.bestRankLabel = self:FindComponent("BestRank", UILabel)
  self:AddButtonEvent("LastSeason", function()
    self:ShowLastRankData()
  end)
  self:AddButtonEvent("CurrentSeason", function()
    self:ShowCurrentRankData()
  end)
end

function TripleTeamRankPopUp:InitView()
  self.listRanks = WrapListCtrl.new(self:FindGO("rankContainer"), TripleTeamRankCell, "TripleTeamRankCell", WrapListCtrl_Dir.Vertical)
  self.listRanks:AddEventListener(MouseEvent.MouseClick, self.ClickCellHead, self)
  self.selectLast = false
  if self.hasDiffSeason then
    self:SetButtonState(self.lastSeasonSp, self.lastSeasonLabel, 0)
    self:SetButtonState(self.currentSeasonSp, self.currentSeasonLabel, 1)
  end
end

function TripleTeamRankPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTriplePwsRankMatchCCmd, self.HandleQueryTriplePwsRankMatchCCmd)
end

function TripleTeamRankPopUp:ShowLastRankData()
  self.selectLast = true
  self:SetButtonState(self.lastSeasonSp, self.lastSeasonLabel, 1)
  self:SetButtonState(self.currentSeasonSp, self.currentSeasonLabel, 0)
  self:RefreshRankData(nil, true)
  self:UpdateData(true)
end

function TripleTeamRankPopUp:ShowCurrentRankData()
  self.selectLast = false
  self:SetButtonState(self.lastSeasonSp, self.lastSeasonLabel, 0)
  self:SetButtonState(self.currentSeasonSp, self.currentSeasonLabel, 1)
  self:RefreshRankData()
  self:UpdateData()
end

function TripleTeamRankPopUp:HandleQueryTriplePwsRankMatchCCmd(note)
  local data = note and note.body
  if data and data.isfinish then
    self:RefreshRankData(nil, self.selectLast)
    self:UpdateData()
  end
end

function TripleTeamRankPopUp:QueryRankData()
  PvpProxy.Instance:QueryTriplePwsRankData()
end

function TripleTeamRankPopUp:RefreshRankData(searchInput, last)
  if not StringUtil.IsEmpty(searchInput) then
    self.data = PvpProxy.Instance:GetTriplePwsRankSearchResult(searchInput, self.selectLast)
  else
    self.data = PvpProxy.Instance:GetTriplePwsRankData(self.selectLast)
  end
end

function TripleTeamRankPopUp:UpdateData(isLayout, last)
  TripleTeamRankPopUp.super.UpdateData(self, isLayout)
  local scoreLimit = PvpProxy.Instance:GetTriplePwsScoreLimit()
  self.scoreLimitLabel.text = last and "" or string.format(ZhString.Triple_RankScoreLimit, scoreLimit)
  local bestRank = PvpProxy.Instance:GetTriplePwsBestRank() or 0
  bestRank = 0 < bestRank and bestRank or ZhString.ItemTip_None
  self.bestRankLabel.text = last and "" or string.format(ZhString.Triple_BestRank, bestRank)
end

function TripleTeamRankPopUp:OnExit()
  TeamPwsRankPopUp.super.OnExit(self)
end
