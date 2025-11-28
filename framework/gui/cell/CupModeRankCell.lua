autoImport("WarbandSeasonRankCell")
CupModeRankCell = class("CupModeRankCell", WarbandSeasonRankCell)

function CupModeRankCell:Init()
  self.proxy = CupMode6v6Proxy.Instance
  CupModeRankCell.super.Init(self)
end
