autoImport("DefaultLoadModeView")
SwitchRoleLoadingView = class("SwitchRoleLoadingView", DefaultLoadModeView)

function SwitchRoleLoadingView:Init()
  SwitchRoleLoadingView.super.Init(self)
  self:initView()
  self:initData()
end

function SwitchRoleLoadingView:initView()
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    local barWidget = self.bar.gameObject:GetComponent(UIWidget)
    if barWidget then
      barWidget:ResetAndUpdateAnchors()
      self.barWidth = barWidget.width
      local barForeground = self:FindGO("Foreground"):GetComponent(UISprite)
      barForeground.width = self.barWidth
      self.bar.value = 0
    end
  end, self)
end

function SwitchRoleLoadingView:initData()
  self:TryLoadPic("loading")
  self:CardMode()
  self.bar.gameObject:SetActive(true)
end
