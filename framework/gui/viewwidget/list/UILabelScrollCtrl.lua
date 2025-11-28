UILabelScrollCtrl = class("UILabelScrollCtrl")

function UILabelScrollCtrl:ctor(panel, label, interval, duration, overScroll)
  self.panel = panel
  self.label = label
  self.interval = interval
  self.duration = duration / 1000
  self.overScroll = overScroll or 0
  local originTransform = label.transform
  self.originPos = originTransform.localPosition
  self.toPos = LuaVector3.New(self.originPos[1], self.originPos[2], self.originPos[3])
  local containerTransform = originTransform.parent
  if containerTransform then
    self.containerWidget = containerTransform:GetComponent(UIWidget)
  end
end

function UILabelScrollCtrl:Start()
  if not self.label or not self.panel then
    return
  end
  if self.label.width < self.panel.width then
    if self.containerWidget then
      self.containerWidget.pivot = UIWidget.Pivot.Center
      self.label.pivot = UIWidget.Pivot.Center
      self.label.transform.localPosition = self.originPos
    end
    return
  end
  if self.containerWidget then
    self.containerWidget.pivot = UIWidget.Pivot.Left
    self.label.pivot = UIWidget.Pivot.Left
    self.label.transform.localPosition = self.originPos
  end
  if self.isAnimating then
    return
  end
  self.toPos[1] = self.originPos[1] - self.label.width + self.panel.width - self.overScroll
  self:RestartScrollTimer()
end

function UILabelScrollCtrl:Stop()
  if self.timer then
    self.timer:Destroy()
    self.timer = nil
  end
  if self.tweener then
    self.tweener.enabled = false
  end
  self.isAnimating = false
end

function UILabelScrollCtrl:DoStartScroll()
  self.tweener = TweenPosition.Begin(self.label.gameObject, self.duration or 1.0, self.toPos)
  self.tweener:SetOnFinished(function()
    self:OnTweenFinished()
  end)
  self.isAnimating = true
end

function UILabelScrollCtrl:OnTweenFinished()
  self.isAnimating = false
  self.label.transform.localPosition = self.originPos
  self:RestartScrollTimer()
end

function UILabelScrollCtrl:RestartScrollTimer()
  if self.timer then
    self.timer:Destroy()
  end
  self.timer = TimeTickManager.Me():CreateOnceDelayTick(self.interval or 0, function(owner, deltaTime)
    self:DoStartScroll()
  end, self)
end
