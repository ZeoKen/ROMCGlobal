autoImport("LotteryResultView")
MountLotteryResultView = class("MountLotteryResultView", LotteryResultView)
MountLotteryResultView.ViewType = UIViewType.PopUpLayer

function MountLotteryResultView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddCloseButtonEvent()
end
