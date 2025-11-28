UIAutoScrollCtrl = class("UIAutoScrollCtrl")

function UIAutoScrollCtrl:ctor(scroll, content, interval, speed)
  self.scroll = scroll
  self.scrollGO = scroll and scroll.gameObject
  self.canMoveHorizontally = self.scroll.canMoveHorizontally
  self.canMoveVertically = self.scroll.canMoveVertically
  self.panel = scroll and scroll:GetComponent(UIPanel)
  self.content = content
  self.interval = interval or 1000
  self.speed = speed or 10
end

function UIAutoScrollCtrl:Destroy()
  self:Stop()
end

function UIAutoScrollCtrl:IsGameObjectValid()
  if not self.scrollGO or LuaGameObject.ObjectIsNull(self.scrollGO) then
    return false
  end
  return true
end

function UIAutoScrollCtrl:Start(immediate, resetPosition, invalidateBounds)
  if not (self:IsGameObjectValid() and self.panel) or not self.content then
    return
  end
  if self.tweener then
    return
  end
  if self.timer then
    return
  end
  if invalidateBounds then
    self.scroll:InvalidateBounds()
  end
  if not NGUIUtil.CheckScrollViewShouldMove(self.scroll) then
    return
  end
  if resetPosition then
    self.scroll:ResetPosition()
  end
  self:RestartScrollTimer(immediate)
end

function UIAutoScrollCtrl:Stop(resetPosition)
  if self.timer then
    self.timer:Destroy()
    self.timer = nil
  end
  local isValid = self:IsGameObjectValid()
  if self.tweener then
    if isValid then
      LeanTween.cancel(self.scroll.gameObject)
    end
    self.tweener = nil
  end
  if resetPosition and isValid then
    self.scroll:ResetPosition()
  end
end

function UIAutoScrollCtrl:ResetInitialScroll()
  if self.scroll then
    self.scroll:MoveRelative(LuaGeometry.GetTempVector3(self.panel.clipOffset.x, 0, 0))
  end
end

function UIAutoScrollCtrl:ResetPosition()
  if self.scroll then
    self.scroll:ResetPosition()
  end
end

local tempVec3 = LuaVector3.Zero()

function UIAutoScrollCtrl:DoStartScroll()
  if not self:IsGameObjectValid() then
    return
  end
  local bounds = self.scroll.bounds
  local min = bounds.min
  local max = bounds.max
  if self.canMoveHorizontally then
    self.minVal = min[1]
    self.maxVal = max[1] - self.panel.width / 2
  else
    self.minVal = min[2]
    self.maxVal = max[2] - self.panel.height / 2
  end
  local duration = self.speed <= 0 and 0 or (self.maxVal - self.minVal) / self.speed
  if duration <= 0 then
    self:OnTweenFinished()
    return
  end
  self.lastVal = self.minVal
  self.tweener = LeanTween.value(self.scroll.gameObject, function(val)
    local delta = val - self.lastVal
    if 0 < delta then
      if self.canMoveHorizontally then
        tempVec3[1] = -delta
      else
        tempVec3[2] = delta
      end
      self.lastVal = val
      self.scroll:MoveRelative(tempVec3)
    end
  end, self.minVal, self.maxVal, duration):setOnComplete(function()
    self:OnTweenFinished()
  end)
end

function UIAutoScrollCtrl:OnTweenFinished()
  self.tweener = nil
  self.scroll:ResetPosition()
  self:RestartScrollTimer()
end

function UIAutoScrollCtrl:RestartScrollTimer(immediate)
  if self.timer then
    self.timer:Destroy()
  end
  local delay = immediate and 0 or self.interval or 0
  self.timer = TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function(owner, deltaTime)
    self:DoStartScroll()
  end, self)
end

function UIAutoScrollCtrl:InvalidateClipping()
  if self.panel then
    local clipOffset = self.panel.clipOffset
    local lastOffsetX = clipOffset[1]
    clipOffset[1] = clipOffset[1] + 0.002
    self.panel.clipOffset = clipOffset
    clipOffset[1] = lastOffsetX
    self.panel.clipOffset = clipOffset
  end
end
