MiniGameRankData = class("MiniGameRankData")

function MiniGameRankData:ctor(serverData, rank)
  self.rank = rank
  if serverData then
    self:SetUserinfo(serverData.user)
    self:SetRankinfo(serverData.record)
  end
end

function MiniGameRankData:SetUserinfo(serverData)
  self.charid = serverData.charid
  self.name = serverData.name
  self.profession = serverData.profession
  self.portrait = serverData.portrait
end

function MiniGameRankData:SetRankinfo(serverData)
  self.record = serverData.value
  self.recordtime = serverData.timestamp
end
