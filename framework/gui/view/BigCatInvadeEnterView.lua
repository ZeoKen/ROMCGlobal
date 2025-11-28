autoImport("MvpMatchView")
BigCatInvadeEnterView = class("BigCatInvadeEnterView", MvpMatchView)
BigCatInvadeEnterView.ViewType = UIViewType.PopUpLayer

function BigCatInvadeEnterView:InitData()
  local config = GameConfig.Activity.BigCatInvade
  if config then
    self.dTitle = config.title
    self.dContent1 = config.content1
    self.dContent2 = config.content2
    self.dicon = config.icon
    self.dMatchLabel = config.button
  end
end

function BigCatInvadeEnterView:ClickMatchButton()
  FunctionNpcFunc.EnterBigCatInvadeActivity()
  self:CloseSelf()
end
