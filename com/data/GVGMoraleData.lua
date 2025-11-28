autoImport("GuildHeadData")
GVGMoraleData = class("GVGMoraleData")

function GVGMoraleData:ctor(server_data)
  local guildid = server_data.guildid
  self.guildid = guildid
  self.morale = server_data.morale
  self.guildName = server_data.guildname
  self.serverPortrait = server_data.portrait
  local portrait = self.serverPortrait or 1
  self.guildHeadData = GuildHeadData.new()
  self.guildHeadData:SetBy_InfoId(portrait)
  self.guildHeadData:SetGuildId(guildid)
end

function GVGMoraleData:Update(server_data)
  if server_data.portrait and self.serverPortrait ~= server_data.portrait then
    self.guildHeadData:SetBy_InfoId(server_data.portrait)
  end
  if server_data.guildname and self.guildName ~= server_data.guildname then
    self.guildName = server_data.guildname
  end
  if server_data.morale and self.morale ~= server_data.morale then
    self.morale = server_data.morale
  end
end
