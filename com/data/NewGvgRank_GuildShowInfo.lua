NewGvgRank_GuildShowInfo = class("NewGvgRank_GuildShowInfo")

function NewGvgRank_GuildShowInfo:ctor(gid, data)
  self.id = gid
  if self.id == GuildProxy.Instance.guildId then
    local myGuildData = GuildProxy.Instance.myGuildData
    self.guildName = myGuildData.name
    self.portrait = myGuildData.portrait or 1
    local leaderMD = myGuildData:GetChairMan()
    self.leaderid = leaderMD.id
    self.leaderName = AppendSpace2Str(leaderMD.name)
    self.zoneid = myGuildData.zoneid
    self.gvgGroup = myGuildData.battle_group or 0
    self.serverId = myGuildData.serverid
  else
    self.guildName = data.name
    self.portrait = data.portrait
    self.leaderid = data.leaderid
    self.leaderName = data.leadername
    self.zoneid = data.zoneid
    self.gvgGroup = data.gvg_group or 0
    self.serverId = data.serverid
  end
  GvgProxy.Instance:SetDiffServer(self.serverId)
end
