GuildMemberBifrostInfoData = class("GuildMemberBifrostInfoData")

function GuildMemberBifrostInfoData.ParseServerData(table, serverData, rank)
  table.charid = serverData.charid
  table.name = serverData.name
  table.rank = rank
  table.dayscore = serverData.dayscore
  table.totalscore = serverData.totalscore
  return table
end
