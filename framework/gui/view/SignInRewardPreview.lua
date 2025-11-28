SignInRewardPreview = class("SignInRewardPreview", BaseView)
SignInRewardPreview.ViewType = UIViewType.PopUpLayer
SignInRewardPreview.IconSpriteName = {
  [0] = "item_700108",
  [1] = "sign_icon_S-box",
  [2] = "sign_icon_L-box"
}

function SignInRewardPreview:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
  self:AddListenEvts()
end

function SignInRewardPreview:FindObjs()
  self.rewardIcon = self:FindComponent("RewardIcon", UISprite)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.signInButton = self:FindGO("SignInButton")
  self.signInSprite = self.signInButton:GetComponent(UISprite)
  self.signInLabel = self:FindComponent("Label", UILabel, self.signInButton)
  self.tipStick = self:FindComponent("TipStick", UISprite)
  self.grid = self:FindComponent("Grid", UIGrid)
end

function SignInRewardPreview:InitShow()
  self.day = self.viewdata.viewdata.day
  self.proxyIns = self.viewdata.viewdata.proxy
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.rewardCtl = UIGridListCtrl.new(self.grid, BagItemCell, "BagItemCell")
end

function SignInRewardPreview:AddEvents()
  self:AddClickEvent(self.signInButton, function()
    if not self.signInSprite.enabled then
      return
    end
    self.proxyIns:CallSignIn()
  end)
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function SignInRewardPreview:AddListenEvts()
  self:AddListenEvt(NewServerSignInEvent.UpdateRewardPreview, self.HandleUpdateReward)
  self:AddListenEvt(NewServerSignInEvent.CloseRewardPreview, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserSignInUserCmd, self.HandleSignIn)
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleSignInNotify)
end

function SignInRewardPreview:UpdateShow()
  self.titleLabel.text = string.format(ZhString.NewServerSignIn_PreviewTitle, self.day)
  self:UpdateRewardIcon()
  self.rewardCtl:ResetDatas(self.proxyIns:GetRewardDataOfDay(self.day))
  self:SetSignInButtonState()
end

function SignInRewardPreview:UpdateRewardIcon()
  local tp = self.proxyIns:GetRewardTypeOfDay(self.day)
  if not tp then
    LogUtility.ErrorFormat("Cannot find reward type of day {0}", self.day)
    return
  end
  IconManager:SetUIIcon(SignInRewardPreview.IconSpriteName[tp] or SignInRewardPreview.IconSpriteName[0], self.rewardIcon)
end

function SignInRewardPreview:SetSignInButtonState()
  self:SetSignInButtonActive(self.proxyIns:IsRewardCanGet(self.day))
end

function SignInRewardPreview:SetSignInButtonActive(isActive)
  local isSigned = self.day <= self.proxyIns.signedCount
  self.signInButton:SetActive(isActive or isSigned)
  self.signInLabel.text = isSigned and ZhString.NewServerSignIn_Signed or ZhString.NewServerSignIn_SignIn
  self.signInLabel.effectColor = isActive and ColorUtil.ButtonLabelOrange or ColorUtil.NGUIGray
  self.signInSprite.enabled = isActive
end

function SignInRewardPreview:HandleUpdateReward(note)
  self.day = note.body
  self:UpdateShow()
end

function SignInRewardPreview:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end

function SignInRewardPreview:HandleSignIn(note)
  self:SetSignInButtonState()
  local isSuccess = note.body.success
  if isSuccess then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SignInRewardGetView
    })
    self:CloseSelf()
  else
    MsgManager.ShowMsgByID(28011)
  end
end

function SignInRewardPreview:HandleSignInNotify()
  self:SetSignInButtonState()
end

function SignInRewardPreview:OnEnter()
  SignInRewardPreview.super.OnEnter(self)
  self:UpdateShow()
  self:PlayUIEffect(EffectMap.UI.GlowHint9, self.startBtnEffContainer, false, function(obj, args, assetEffect)
    local effectComp = obj.gameObject:GetComponent(ChangeRqByTex)
    effectComp.depth = 12
  end)
end
