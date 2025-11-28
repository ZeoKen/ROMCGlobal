PlotStoryTopView = class("PlotStoryTopView", BaseView)
PlotStoryTopView.ViewType = UIViewType.ConfirmLayer

function PlotStoryTopView:Init()
  self.skipButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.skipButton, function()
    self:SkipPlot(true)
  end)
  self.skipButton:SetActive(false)
end

function PlotStoryTopView:OnEnter()
  PlotStoryTopView.super.OnEnter(self)
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.plotStoryShowSkip then
    local skipDelay = self.viewdata.viewdata.skipDelay or 2
    TimeTickManager.Me():CreateOnceDelayTick(skipDelay * 1000, function(owner, deltaTime)
      self.skipButton:SetActive(true)
    end, self)
  end
end

function PlotStoryTopView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  PlotStoryTopView.super.OnExit(self)
end

function PlotStoryTopView:SkipPlot(isDoEndCall)
  Game.PlotStoryManager:DoSkip()
end
