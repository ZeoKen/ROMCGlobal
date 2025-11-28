autoImport("GuildMemberBifrostInfoData")
autoImport("GuildMemberBifrostInfoCell")
GuildScoreMemberRankPage = class("GuildScoreMemberRankPage", SubView)

function GuildScoreMemberRankPage:Init()
  self:FindObjs()
  self:InitList()
  self:AddViewEvts()
end

function GuildScoreMemberRankPage:FindObjs()
  self.root = self:FindGO("MemberScoreBord")
  self.emptyLab = self:FindComponent("EmptyLabel", UILabel, self.root)
  local titleRoot = self:FindGO("ReportTitles", self.root)
  self.nameLab = self:FindComponent("Name", UILabel, titleRoot)
  self.rankLab = self:FindComponent("Rank", UILabel, titleRoot)
  self.todayLab = self:FindComponent("Today", UILabel, titleRoot)
  self.totalLab = self:FindComponent("Total", UILabel, titleRoot)
  self.scoreBg = self:FindGO("ScoreBg", self.root)
  self.guildScoreLab = self:FindComponent("GuildMemberScoreLab", UILabel, self.scoreBg)
  self.scoreBg:SetActive(false)
  self.reportList = self:FindGO("ReportList")
  self:initLab()
end

function GuildScoreMemberRankPage:initLab()
  self.emptyLab.text = ZhString.GuildScoreRankPage_MemberEmpty
  self.nameLab.text = ZhString.GuildScoreRankView_MemberName
  self.rankLab.text = ZhString.GuildScoreRankView_Rank
  self.todayLab.text = ZhString.GuildScoreRankView_Dayscore
  self.totalLab.text = ZhString.GuildScoreRankView_Totalscore
end

function GuildScoreMemberRankPage:InitList()
  self.objEmptyList = self:FindGO("EmptyList", self.root)
  self.objEmptyList:SetActive(true)
  local container = self:FindGO("memberScoreContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 12,
    cellName = "GuildMemberBifrostInfoCell",
    control = GuildMemberBifrostInfoCell
  }
  self.memberListReports = WrapCellHelper.new(wrapConfig)
end

function GuildScoreMemberRankPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryMemberBifrostInfoGuildCmd, self.UpdateScore)
end

function GuildScoreMemberRankPage:UpdateScore()
  local score = GuildProxy.Instance.memberBifrostScore or 0
  self.guildScoreLab.text = string.format(ZhString.GuildScoreRankView_GuildScore, score)
  self.memberRankDatas = GuildProxy.Instance:GetMemberBifrostInfo() or {}
  local length = #self.memberRankDatas
  self.objEmptyList:SetActive(length == 0)
  self.reportList:SetActive(0 < length)
  self.scoreBg:SetActive(0 < length)
  self.memberListReports:ResetDatas(self.memberRankDatas)
end

function GuildScoreMemberRankPage:OnEnter()
  GuildScoreMemberRankPage.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallQueryMemberBifrostInfoGuildCmd()
end

function GuildScoreMemberRankPage:OnDestroy()
  self.memberListReports:Destroy()
  GuildScoreMemberRankPage.super.OnDestroy(self)
end
