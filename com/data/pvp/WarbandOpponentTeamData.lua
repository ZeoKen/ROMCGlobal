autoImport("WarbandTeamData")
WarbandOpponentTeamData = class("WarbandOpponentTeamData", WarbandTeamData)

function WarbandOpponentTeamData:ctor(data, proxy)
  self.index = data.index
  self.wintimes = data.wintimes
  self.starsone = data.starsone or 0
  self.starstwo = data.starstwo or 0
  WarbandOpponentTeamData.super.ctor(self, data.team, proxy)
end

function WarbandOpponentTeamData:IsChampionship()
  local chamption = self.proxy.champtionBand
  if nil ~= chamption and chamption.id == self.id then
    return true
  end
  return false
end
