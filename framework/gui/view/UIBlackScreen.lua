UIBlackScreen = class("UIBlackScreen")

function UIBlackScreen.Begin(originAlpha, targetAlpha, sp, duration, completeCallback)
  if sp ~= nil then
    sp.alpha = originAlpha
    local ta = TweenAlpha.Begin(sp.gameObject, duration, targetAlpha)
    if completeCallback ~= nil then
      ta:SetOnFinished(function()
        completeCallback()
      end)
    end
  end
end

function UIBlackScreen.DoFadeIn(sp, duration, completeCallback)
  UIBlackScreen.Begin(0, 1, sp, duration, completeCallback)
end

function UIBlackScreen.DoFadeOut(sp, duration, completeCallback)
  UIBlackScreen.Begin(1, 0, sp, duration, completeCallback)
end
