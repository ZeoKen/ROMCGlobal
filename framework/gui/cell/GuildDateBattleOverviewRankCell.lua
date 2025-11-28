local _RankSpritePrefix = "Guild_icon_NO"
GuildDateBattleOverviewRankCell = class("GuildDateBattleOverviewRankCell", BaseCell)

function GuildDateBattleOverviewRankCell:Init()
  self.root = self:FindGO("Root")
  self.bg = self.gameObject:GetComponent(UISprite)
  self.rankLab = self:FindComponent("Rank", UILabel)
  self.rankSp = self:FindComponent("RankSp", UISprite)
  self.guildName = self:FindComponent("GuildName", UILabel)
  self.winNum = self:FindComponent("Num", UILabel)
  self.leaderName = self:FindComponent("LeaderName", UILabel)
  local guildHeadCellGO = self:FindGO("GuildHeadCell")
  self.headCell = GuildHeadCell.new(guildHeadCellGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.serverIDLab = self:FindComponent("ServerId", UILabel)
  self:Hide(self.serverIDLab)
end

function GuildDateBattleOverviewRankCell:SetData(data)
  self.data = data
  if not data then
    self:Hide(self.root)
    return
  end
  self:Show(self.root)
  self.guildName.text = data.guildName
  self.leaderName.text = data.leaderName
  self.winNum.text = data.wintimes
  self:SetRank(data.rank)
  self.headCell:SetData(data.guildHeadData)
  self.serverIDLab.text = tostring(data.serverId)
end

function GuildDateBattleOverviewRankCell:SetRank(rank)
  if not rank then
    return
  end
  if 3 < rank then
    self:Hide(self.rankSp)
    self:Show(self.rankLab)
    self.rankLab.text = tostring(rank)
  else
    self:Hide(self.rankLab)
    self:Show(self.rankSp)
    self.rankSp.spriteName = _RankSpritePrefix .. tostring(rank)
  end
end
