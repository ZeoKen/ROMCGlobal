FairyTaleRaidRankData = class("FairyTaleRaidRankData")

function FairyTaleRaidRankData:ctor(serverData)
  self:SetData(serverData)
end

function FairyTaleRaidRankData:SetData(serverData)
  self.charId = serverData.charid
  self.rank = serverData.rank
  self.name = serverData.name
  self.score = serverData.traincount
  self.profession = serverData.profession
  self.headData = HeadImageData.new()
  self.headData:TransByPortraitData(serverData.portraitdata)
  self.guildName = serverData.guildname
end
