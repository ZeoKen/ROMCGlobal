autoImport("GuildDateBattleOverviewRankCell")
GuildDateBattle_Overview_Rank = class("GuildDateBattle_Overview_Rank", SubView)

function GuildDateBattle_Overview_Rank:Init()
  self:InitUI()
end

function GuildDateBattle_Overview_Rank:OnEnter()
  GuildDateBattle_Overview_Rank.super.OnEnter(self)
  GuildDateBattleProxy.Instance:TryQueryRank()
end

function GuildDateBattle_Overview_Rank:InitUI()
  local wrap = self:FindGO("RankWrapContent")
  local wrapConfig = {
    wrapObj = wrap,
    cellName = "GuildDateBattleOverviewRankCell",
    control = GuildDateBattleOverviewRankCell
  }
  self.rankCtrl = WrapCellHelper.new(wrapConfig)
  self.rankCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRecord, self)
  self.myGuildRank = GuildDateBattleOverviewRankCell.new(self:FindGO("MyGuild"))
end

function GuildDateBattle_Overview_Rank:UpdateView()
  local data = GuildDateBattleProxy.Instance:GetRanks()
  self.rankCtrl:ResetDatas(data, true)
  self.container.emptyGO:SetActive(#data == 0)
  local my_guild_rank = GuildDateBattleProxy.Instance:GetMyGuildRankData()
  if not my_guild_rank or not GuildProxy.Instance:IHaveGuild() then
    self:Hide(self.myGuildRank.gameObject)
  else
    self:Show(self.myGuildRank.gameObject)
    self.myGuildRank:SetData(my_guild_rank)
  end
end
