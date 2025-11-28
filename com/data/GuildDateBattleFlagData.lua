GuildDateBattleFlagData = class("GuildDateBattleFlagData")

function GuildDateBattleFlagData:ctor(id, svr_data)
  self.id = id
  self.guildId = svr_data.guildid
  local portrait = svr_data.guildportrait
  self.portrait = tonumber(portrait) or portrait
end
