BaseRoundRewardView = class("BaseRoundRewardView", BaseView)
BaseRoundRewardView.ViewType = UIViewType.PopUpLayer

function BaseRoundRewardView:Init()
  self:FindObjs()
end

function BaseRoundRewardView:OnEnter()
  BaseRoundRewardView.super.OnEnter(self)
  self:UpdateView()
end

function BaseRoundRewardView:OnExit()
  BaseRoundRewardView.super.OnExit(self)
end

function BaseRoundRewardView:FindObjs()
  self.txtTitleLab = self:FindComponent("txtTitle", UILabel)
  if self.txtTitleLab then
    self.txtTitleLab.text = ZhString.RoundReward_Title
  end
  self.tipStick = self:FindComponent("tipStick", UISprite)
  self:InitWrap()
end

function BaseRoundRewardView:InitWrap()
end

function BaseRoundRewardView:UpdateView()
end
