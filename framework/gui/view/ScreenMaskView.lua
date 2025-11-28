ScreenMaskView = class("ScreenMaskView", BaseView)
ScreenMaskView.ViewType = UIViewType.LoadingLayer

function ScreenMaskView:Init()
  self:FindBg()
end

function ScreenMaskView:FindBg()
  self.bgMask = self:FindGO("BgMask"):GetComponent(UISprite)
  self.bgMask.color = self.viewdata.color
end

function ScreenMaskView:OnEnter()
  self:FadeIn()
end

function ScreenMaskView:OnExit()
  LeanTween.cancel(self.gameObject)
end

function ScreenMaskView:FadeIn()
  LeanTween.alphaNGUI(self.bgMask, 0, 1, self.viewdata.fadeInTime):setOnComplete(function()
    if self.viewdata.fadeInCallBack then
      self.viewdata.fadeInCallBack()
    end
    if self.viewdata.fadeOutTime then
      self:FadeOut()
    end
  end)
end

function ScreenMaskView:FadeOut()
  LeanTween.alphaNGUI(self.bgMask, 1, 0, self.viewdata.fadeOutTime):setOnComplete(function()
    if self.viewdata.fadeOutCallBack then
      self.viewdata.fadeOutCallBack()
    end
    self:CloseSelf()
  end)
end

function ScreenMaskView:FadeMask(fadeInTime, fadeOutTime, fadeInCallBack, fadeOutCallBack, color)
end
