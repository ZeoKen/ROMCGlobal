local _prefix = "Lv."
GuildInfoForQuery = class("GuildInfoForQuery")

function GuildInfoForQuery:Reset(data)
  self.id = data.guildid
  self.lv = data.level
  self.memberCount = data.memnum
  self.guildName = data.guildname
  self.leaderName = data.leadername
end

function GuildInfoForQuery:Lv2String()
  return _prefix .. tostring(self.lv)
end
