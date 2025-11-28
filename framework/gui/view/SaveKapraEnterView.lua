autoImport("MvpMatchView")
SaveKapraEnterView = class("SaveKapraEnterView", MvpMatchView)
SaveKapraEnterView.ViewType = UIViewType.PopUpLayer
local _GameConfig_SaveCapra = GameConfig.Activity.SaveCapra

function SaveKapraEnterView:InitData()
  self.dTitle = _GameConfig_SaveCapra.title or "No Config: GameConfig.Activity.SaveCapra.title"
  self.dContent1 = _GameConfig_SaveCapra.content1 or "No Config: GameConfig.Activity.SaveCapra.content1"
  self.dContent2 = _GameConfig_SaveCapra.content2 or "No Config: GameConfig.Activity.SaveCapra.content2"
  self.dicon = _GameConfig_SaveCapra.icon or "main_bg_MVP"
  self.dMatchLabel = _GameConfig_SaveCapra.button or "No Config: GameConfig.Activity.SaveCapra.button"
end

function SaveKapraEnterView:ClickMatchButton()
  FunctionNpcFunc.EnterCapraActivity()
  self:CloseSelf()
end
