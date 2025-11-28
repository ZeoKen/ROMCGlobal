MainViewAfkPanel = class("MainViewAfkPanel", SubView)

function MainViewAfkPanel:Init()
  self:BindRef()
end

function MainViewAfkPanel:OnExit()
  MainViewAfkPanel.super.OnExit(self)
end

function MainViewAfkPanel:BindRef()
end

function MainViewAfkPanel:OnCloseClicked()
end

function MainViewAfkPanel:OnSettingClicked()
end

function MainViewAfkPanel:UpdateTime()
end
