autoImport("GuildHeadData")
GuildDateBattleRankData = class("GuildDateBattleRankData")

function GuildDateBattleRankData:ctor(serverData, server_rank)
  if not serverData then
    return
  end
  self.rank = server_rank or 0
  self.wintimes = serverData.wintimes
  self.guildName = serverData.guildname
  self.guildId = serverData.guildid
  self.leaderName = serverData.chairmanname
  self.guildportrait = serverData.guildportrait
  self.serverId = serverData.serverid
  self.guildHeadData = GuildHeadData.new()
  self.guildHeadData:SetBy_InfoId(self.guildportrait)
  self.guildHeadData:SetGuildId(self.guildId)
end

function GuildDateBattleRankData:SetRank(r)
  self.rank = r
end

function GuildDateBattleRankData:GetRank()
  return self.rank
end

function GuildDateBattleRankData:IsMyself()
  return self.guildId == GuildProxy.Instance:GetOwnGuildID()
end
