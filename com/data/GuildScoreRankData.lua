GuildScoreRankData = class("GuildScoreRankData")

function GuildScoreRankData.ParseServerData(table, serverData, rank)
  table.guildid = serverData.guildid
  local myGuildScore = GuildProxy.Instance.myGuildScore
  local myguildId = GuildProxy.Instance.guildId
  if nil ~= myguildId and nil ~= myGuildScore and serverData.guildid == myguildId then
    table.score = math.max(serverData.score, myGuildScore)
  else
    table.score = serverData.score
  end
  table.time = serverData.time
  table.guildname = serverData.guildname
  table.chairmanname = serverData.chairmanname
  table.rank = rank
  return table
end
