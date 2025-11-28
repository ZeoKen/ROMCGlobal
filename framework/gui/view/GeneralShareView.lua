GeneralShareView = class("GeneralShareView", ContainerView)
GeneralShareView.ViewType = UIViewType.PopUpLayer

function GeneralShareView:Init()
  self:FindObj()
  self:AddEvt()
  self:AddViewEvt()
  self:InitShow()
end

function GeneralShareView:FindObj()
  local qq = self:FindGO("QQ")
  self:AddClickEvent(qq, function()
    self:ClickQQ()
  end)
  local wechat = self:FindGO("Wechat")
  self:AddClickEvent(wechat, function()
    self:ClickWechat()
  end)
  local wechatMoments = self:FindGO("WechatMoments")
  self:AddClickEvent(wechatMoments, function()
    self:ClickWechatMoments()
  end)
  local sina = self:FindGO("Sina")
  self:AddClickEvent(sina, function()
    self:ClickSina()
  end)
  if not BranchMgr.IsJapan() then
    wechat:SetActive(false)
    wechatMoments:SetActive(false)
    sina:SetActive(false)
  end
  self:ROOShare()
end

function GeneralShareView:ROOShare()
  if BranchMgr.IsChina() then
    return
  end
  self.goUIViewSocialShare = self:FindGO("Grid", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local sp = self.goButtonQQ:GetComponent(UISprite)
  IconManager:SetUIIcon("Facebook", sp)
  sp = self.goButtonWechat:GetComponent(UISprite)
  IconManager:SetUIIcon("Twitter", sp)
  sp = self.goButtonWechatMoments:GetComponent(UISprite)
  IconManager:SetUIIcon("line", sp)
  GameObject.Destroy(self.goButtonSina)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sendNotification(ShareEvent.ClickPlatform, "line")
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:sendNotification(ShareEvent.ClickPlatform, "twitter")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sendNotification(ShareEvent.ClickPlatform, "fb")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
end

function GeneralShareView:AddEvt()
end

function GeneralShareView:AddViewEvt()
end

function GeneralShareView:InitShow()
end

function GeneralShareView:ClickQQ()
  local platform = E_PlatformType.QQ
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function GeneralShareView:ClickWechat()
  local platform = E_PlatformType.Wechat
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function GeneralShareView:ClickWechatMoments()
  local platform = E_PlatformType.WechatMoments
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function GeneralShareView:ClickSina()
  local platform = E_PlatformType.Sina
  if SocialShare.Instance:IsClientValid(platform) then
    self:sendNotification(ShareEvent.ClickPlatform, platform)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end
