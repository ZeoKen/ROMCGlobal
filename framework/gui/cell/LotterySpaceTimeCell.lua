autoImport("LotteryMagicDetailCell")
LotterySpaceTimeCell = class("LotterySpaceTimeCell", LotteryMagicDetailCell)

function LotterySpaceTimeCell:GetRateShowConfig()
  return GameConfig.Lottery.SpaceTimeLotteryRateShow
end
