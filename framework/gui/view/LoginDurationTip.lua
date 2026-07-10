LoginDurationTip = class("LoginDurationTip", BaseView)
LoginDurationTip.ViewType = UIViewType.WarnLayer
LoginDurationTip.ForceCoExist = true

function LoginDurationTip:Init()
  self:FindObjs()
  self:SetTip()
end

function LoginDurationTip:FindObjs()
  self.tip = self:FindGO("Tip")
  self.tipTweenPosition = self.tip and self.tip:GetComponent(TweenPosition)
  self.tipLabel = self:FindComponent("TipLabel", UILabel)
end

function LoginDurationTip:SetTip()
  local hour = tonumber(self.viewdata and self.viewdata.hour) or 0
  if self.tipLabel then
    self.tipLabel.text = string.format(ZhString.LoginDurationTip_Text, hour)
  end
end

function LoginDurationTip:OnEnter()
  LoginDurationTip.super.OnEnter(self)
  if self.tipTweenPosition then
    self.tipTweenPosition:ResetToBeginning()
    self.tipTweenPosition:SetOnFinished(function()
      self:CloseSelf()
    end)
    self.tipTweenPosition:PlayForward()
  else
    self:CloseSelf()
  end
end
