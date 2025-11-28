SignInRewardGetView = class("SignInRewardGetView", BaseView)
SignInRewardGetView.ViewType = UIViewType.PopUpLayer

function SignInRewardGetView:Init()
  IconManager:SetArtFontIcon("sign_txt", self:FindComponent("TitleIcon", UISprite))
  self.effectParent = self:FindGO("TitleEffect")
  self:PlayUIEffect(EffectMap.UI.SignInRewardGetView, self.effectParent)
  local clickZone = self:FindGO("ClickZone")
  self:AddClickEvent(clickZone, function()
    self:CloseSelf()
  end)
end
