autoImport("LotteryMagicView")
LotteryMagicThirdView = class("LotteryMagicThirdView", LotteryMagicView)
LotteryMagicThirdView.ViewType = LotteryMagicView.ViewType

function LotteryMagicThirdView:UpdateLotteryType()
  self.lotteryType = LotteryType.MagicThird
end
