autoImport("LotteryResultView")
NewLotteryResultView = class("NewLotteryResultView", LotteryResultView)
NewLotteryResultView.ViewType = UIViewType.PopUpLayer

function NewLotteryResultView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddCloseButtonEvent()
end

function NewLotteryResultView:FindObjs()
  NewLotteryResultView.super.FindObjs(self)
end

function NewLotteryResultView:InitShow()
  NewLotteryResultView.super.InitShow(self)
end
