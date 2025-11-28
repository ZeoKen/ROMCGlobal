autoImport("GuildScoreRankData")
autoImport("GuildScoreRankCell")
GuildScoreRankPage = class("GuildScoreRankPage", SubView)

function GuildScoreRankPage:Init()
  self:FindObjs()
  self:InitList()
  self:AddViewEvts()
end

function GuildScoreRankPage:FindObjs()
  self.root = self:FindGO("ScoreBord")
  self.myScoreLab = self:FindComponent("MyScoreLab", UILabel, self.root)
  self.emptyLab = self:FindComponent("EmptyLabel", UILabel)
  local titleRoot = self:FindGO("ReportTitles", self.root)
  self.guildNameLab = self:FindComponent("GuildNameLab", UILabel, titleRoot)
  self.guildChairmanLab = self:FindComponent("GuildChairmanLab", UILabel, titleRoot)
  self.guildRankLab = self:FindComponent("GuildRankLab", UILabel, titleRoot)
  self.guildScoreLab = self:FindComponent("GuildScoreLab", UILabel, titleRoot)
  self.reportList = self:FindGO("ReportList")
  self:initLab()
end

function GuildScoreRankPage:initLab()
  self.emptyLab.text = ZhString.GuildScoreRankPage_Empty
  self.guildNameLab.text = ZhString.GuildScoreRankPage_GuildName
  self.guildChairmanLab.text = ZhString.GuildScoreRankPage_GuildChairmanName
  self.guildRankLab.text = ZhString.GuildScoreRankPage_GuildRankName
  self.guildScoreLab.text = ZhString.GuildScoreRankPage_Score
end

function GuildScoreRankPage:InitList()
  self.objLoading = self:FindGO("LoadingRoot", self.root)
  self.objEmptyList = self:FindGO("EmptyList", self.root)
  local container = self:FindGO("scoreContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 12,
    cellName = "GuildScoreRankCell",
    control = GuildScoreRankCell
  }
  self.listReports = WrapCellHelper.new(wrapConfig)
end

function GuildScoreRankPage:AddViewEvts()
  self:AddListenEvt(MyselfEvent.BattlePassLevelChange, self.UpdateMyScore)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryBifrostRankGuildCmd, self.HandleQuery)
end

function GuildScoreRankPage:UpdateMyScore()
  local score = MyselfProxy.Instance:GetMyGuildScore()
  self.myScoreLab.text = string.format(ZhString.GuildScoreRankPage_PersonalScore, score)
  if self.rankDatas then
    self.listReports:ResetDatas(self.rankDatas)
  end
end

function GuildScoreRankPage:HandleQuery()
  self.rankDatas = GuildProxy.Instance:GetGuildScoreRank()
  self.objLoading:SetActive(false)
  local length = #self.rankDatas
  self.objEmptyList:SetActive(length == 0)
  self.reportList:SetActive(0 < length)
  self.listReports:ResetDatas(self.rankDatas, true)
end

function GuildScoreRankPage:OnEnter()
  GuildScoreRankPage.super.OnEnter(self)
  self:UpdateMyScore()
end

function GuildScoreRankPage:OnDestroy()
  self.listReports:Destroy()
  GuildScoreRankPage.super.OnDestroy(self)
end
