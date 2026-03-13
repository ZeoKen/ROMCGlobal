SuperGvgRankData = class("SuperGvgRankData")

function SuperGvgRankData:ctor(data)
  self.id = data.guildid
  self.grade = data.grade
  self.guildName = data.guildname
  self.zoneid = data.zoneid
  self.portrait = data.portrait
  self.gvgGroup = data.gvg_group
  self.serverId = data.serverid
  self.battlelineStr = GuildProxy.ParseServerGroupID(self.gvgGroup, true)
  GvgProxy.Instance:SetDiffServer(self.serverId)
end

function SuperGvgRankData:GetGuildName()
  return self.guildName
end

function SuperGvgRankData:GetBattlelineStr()
  return self.battlelineStr
end
