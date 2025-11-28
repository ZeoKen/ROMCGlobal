SuperGvgRankData = class("SuperGvgRankData")

function SuperGvgRankData:ctor(data)
  self.id = data.guildid
  self.grade = data.grade
  self.guildName = data.guildname
  self.zoneid = data.zoneid
  self.portrait = data.portrait
  self.gvgGroup = data.gvg_group or 10000
  self.serverId = data.serverid
  GvgProxy.Instance:SetDiffServer(self.serverId)
end

function SuperGvgRankData:GetGuildName()
  return self.guildName
end

function SuperGvgRankData:GetZoneId()
  return GvgProxy.ClientGroupId(self.gvgGroup)
end
