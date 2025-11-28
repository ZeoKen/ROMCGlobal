DesertWolfReportData = class("DesertWolfReportData")

function DesertWolfReportData:ctor(serverData)
  self:SetServerData(serverData)
end

function DesertWolfReportData:SetServerData(serverData)
  self.charid = serverData.charid
  self.color = serverData.color
  self.name = serverData.name
  self.kill = serverData.kill
  self.death = serverData.death
  self.assist = serverData.assist
  self.combo = serverData.combo
  self.heal = serverData.heal
  self.damage = serverData.damage
end
