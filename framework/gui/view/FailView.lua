FailView = class("DeathPopView", ContainerView)
FailView.ViewType = UIViewType.ReviveLayer

function FailView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
end

function FailView:FindObjs()
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.failHint = self:FindGO("FailHint"):GetComponent(UILabel)
  self.backBtn = self:FindGO("BackBtn")
  self.backLabel = self:FindGO("BackLabel"):GetComponent(UILabel)
  self.bgTexture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI("persona_bg_npc", self.bgTexture)
end

function FailView:AddEvts()
  self:AddClickEvent(self.backBtn, function()
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    MyselfProxy.Instance.failPassPersonalEndlessTower = true
  end)
end

function FailView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function FailView:InitShow()
  self.title.text = ZhString.PracticeField_Failed
  self.failHint.text = ZhString.PracticeField_FailTip
  self.backLabel.text = ZhString.PracticeField_BackLabel
end

function FailView:OnExit()
  PictureManager.Instance:UnLoadUI("persona_bg_npc", self.bgTexture)
  self.super.OnExit(self)
end
