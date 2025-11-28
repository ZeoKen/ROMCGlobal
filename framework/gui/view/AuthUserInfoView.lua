autoImport("AuthUserCountryCodeCell")
AuthUserInfoView = class("AuthUserInfoView", ContainerView)
AuthUserInfoView.ViewType = UIViewType.PopUpLayer
local AuthType = {PHONE = 1, MAIL = 2}
local AuthTypeMsg = {
  [AuthType.PHONE] = ZhString.AuthUser_ThisMonth_Phone,
  [AuthType.MAIL] = ZhString.AuthUser_ThisMonth_Mail
}

function AuthUserInfoView:Init()
  self.type = self.viewdata and self.viewdata.viewdata
  self:FindObjs()
  self:InitView()
  self:AddEvts()
end

function AuthUserInfoView:FindObjs()
  self.titleLabel = self:FindComponent("title", UILabel)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self.phonePart = self:FindGO("Phone")
  local countryCode = self:FindGO("countryCode", self.phonePart)
  self:AddClickEvent(countryCode, function()
    self:OnCountryCodeClick()
  end)
  self.countryCodeLabel = self:FindComponent("code", UILabel, countryCode)
  self.countryCodeArrow = self:FindComponent("arrow", UISprite, countryCode)
  self.countryCodeListPanel = self:FindGO("CodeList", self.phonePart)
  local closeScript = self.countryCodeListPanel:GetComponent(CloseWhenClickOtherPlace)
  if closeScript then
    function closeScript.callBack()
      self.countryCodeArrow.flip = 0
    end
  end
  local grid = self:FindComponent("Grid", UIGrid, self.countryCodeListPanel)
  self.countryCodeListCtrl = UIGridListCtrl.new(grid, AuthUserCountryCodeCell, "AuthUserCountryCodeCell")
  self.countryCodeListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCountryCodeSelected, self)
  local phoneNumber = self:FindGO("phoneNumber", self.phonePart)
  self.phoneNumberLabel = self:FindComponent("number", UILabel, phoneNumber)
  self.mailPart = self:FindGO("Mail")
  self.emailLabel = self:FindComponent("address", UILabel, self.mailPart)
  self.authCode = self:FindGO("authCode")
  self.authCodeLabel = self:FindComponent("code", UILabel, self.authCode)
  local sendBtn = self:FindGO("sendBtn", self.authCode)
  self:AddClickEvent(sendBtn, function()
    self:OnSendAuthCodeBtnClick()
  end)
  self.sendBtnCollider = sendBtn:GetComponent(BoxCollider)
  self.sendBtnLabel = self:FindComponent("Label", UILabel, sendBtn)
  self.bindBtn = self:FindGO("BindBtn")
  self:AddClickEvent(self.bindBtn, function()
    self:OnBindBtnClick()
  end)
  self.successTipPanel = self:FindGO("SuccessTip")
  self.successTipLabel = self:FindComponent("Title", UILabel, self.successTipPanel)
  self.rewardTip = self:FindGO("rewardTip", self.successTipPanel)
  local confirmBtn = self:FindGO("confirmBtn", self.successTipPanel)
  self:AddClickEvent(confirmBtn, function()
    self.successTipPanel:SetActive(false)
    self:CloseSelf()
  end)
  self.changeBindPanel = self:FindGO("ChangeBind")
  self.changeBindTitleLabel = self:FindComponent("title", UILabel, self.changeBindPanel)
  self.changeContentLabel = self:FindComponent("content", UILabel, self.changeBindPanel)
  local changeBtn = self:FindGO("changeBtn", self.changeBindPanel)
  self:AddClickEvent(changeBtn, function()
    self:OnChangeBindBtnClick()
  end)
  local confirm = self:FindGO("confirmBtn", self.changeBindPanel)
  self:AddClickEvent(confirm, function()
    self:OnBindConfirmBtnClick()
  end)
  local cancelBtn = self:FindGO("cancelBtn", self.changeBindPanel)
  self:AddClickEvent(cancelBtn, function()
    self:CloseSelf()
  end)
  self.check = self:FindGO("check")
  self:AddButtonEvent("PrivacyTip", function()
    if GameConfig.PrivacyPolicy and GameConfig.PrivacyPolicy.PrivacyProtect then
      Application.OpenURL(GameConfig.PrivacyPolicy.PrivacyProtect)
    end
  end)
  self:AddButtonEvent("checkBg", function()
    self:OnPrivacyCheckClick()
  end)
end

function AuthUserInfoView:AddEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3AuthUpdateUserCmd, self.HandleAuthUpdateUserCmd)
end

function AuthUserInfoView:InitView()
  self.titleLabel.text = self.type == AuthType.PHONE and ZhString.AuthUser_PhoneTitle or ZhString.AuthUser_MailTitle
  local content = AuthUserInfoProxy.Instance:GetAuthContent(self.type)
  if StringUtil.IsEmpty(content) then
    self:ShowBindPart()
    self:HideChangeBindPart()
  else
    self:HideBindPart()
    self:ShowChangeBindPart(content)
  end
  local branch = BranchMgr.GetBranchName()
  local codeList = GameConfig.AuthUserInfo.CountryCode[branch]
  if codeList then
    local datas = ReusableTable.CreateArray()
    for i = 1, #codeList do
      local data = {}
      data.countryName = codeList[i][1]
      data.countryCode = codeList[i][2]
      datas[#datas + 1] = data
    end
    self.countryCodeListCtrl:ResetDatas(datas)
    self.countryCodeLabel.text = "+" .. datas[1].countryCode
    ReusableTable.DestroyArray(datas)
  end
  local str = self.type == AuthType.PHONE and ZhString.AuthUser_Phone or ZhString.AuthUser_Mail
  self.successTipLabel.text = string.format(ZhString.AuthUser_AuthSuccess, str)
end

function AuthUserInfoView:HandleAuthUpdateUserCmd()
  self.successTipPanel:SetActive(true)
end

function AuthUserInfoView:ShowBindPart()
  self.phonePart:SetActive(self.type == AuthType.PHONE)
  self.mailPart:SetActive(self.type == AuthType.MAIL)
  self.authCode:SetActive(true)
  self.bindBtn:SetActive(true)
end

function AuthUserInfoView:HideBindPart()
  self.phonePart:SetActive(false)
  self.mailPart:SetActive(false)
  self.authCode:SetActive(false)
  self.bindBtn:SetActive(false)
end

function AuthUserInfoView:ShowChangeBindPart(content)
  self.changeBindPanel:SetActive(true)
  self.changeBindTitleLabel.text = self.type == AuthType.PHONE and ZhString.AuthUser_PhoneContinueBindTitle or ZhString.AuthUser_MailContinueBindTitle
  self.changeContentLabel.text = StringUtil.ReplacePhoneOrEmail(content)
end

function AuthUserInfoView:HideChangeBindPart()
  self.changeBindPanel:SetActive(false)
end

function AuthUserInfoView:OnEnter()
end

function AuthUserInfoView:OnExit()
  TimeTickManager.Me():ClearTick(self)
end

function AuthUserInfoView:OnCountryCodeClick()
  self.countryCodeListPanel:SetActive(true)
  self.countryCodeArrow.flip = 2
end

function AuthUserInfoView:OnCountryCodeSelected(cell)
  self.countryCodeLabel.text = "+" .. cell.code
  self.countryCodeListPanel:SetActive(false)
  self.countryCodeArrow.flip = 0
end

function AuthUserInfoView:OnBindBtnClick()
  if not self.privacyCheck then
    MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_PrivacyNotCheck)
    return
  end
  local authCode = self.authCodeLabel.text
  if self.type == AuthType.PHONE then
    local countryCode = self.countryCodeLabel.text
    local phone = self.phoneNumberLabel.text
    phone = countryCode .. phone
    if StringUtil.ValidatePhoneNumber(phone) then
      if self:ValidateAuthCode(authCode) then
        self:CallAuthUpdate(phone, authCode, true)
      end
    else
      MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_PhoneError)
    end
  elseif self.type == AuthType.MAIL then
    local email = self.emailLabel.text
    if StringUtil.ValidateEmail(email) then
      if self:ValidateAuthCode(authCode) then
        self:CallAuthUpdate(email, authCode, true)
      end
    else
      MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_EmailError)
    end
  end
end

function AuthUserInfoView:ValidateAuthCode(authCode)
  if not StringUtil.IsEmpty(authCode) then
    return true
  else
    MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_AuthCodeError)
    return false
  end
end

function AuthUserInfoView:CallAuthUpdate(content, authCode, verifyCode)
  local auth = {}
  auth.auth = self.type
  auth.content = content
  ServiceSceneUser3Proxy.Instance:CallAuthUpdateUserCmd(auth, authCode, verifyCode)
end

function AuthUserInfoView:OnPrivacyCheckClick()
  self.privacyCheck = not self.privacyCheck
  self.check:SetActive(self.privacyCheck)
end

function AuthUserInfoView:OnSendAuthCodeBtnClick()
  if self.type == AuthType.PHONE then
    local countryCode = self.countryCodeLabel.text
    local phone = self.phoneNumberLabel.text
    phone = countryCode .. phone
    if StringUtil.ValidatePhoneNumber(phone) then
      self:CallAuthUpdate(phone, nil, false)
    else
      MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_PhoneError)
      return
    end
  elseif self.type == AuthType.MAIL then
    local email = self.emailLabel.text
    if StringUtil.ValidateEmail(email) then
      self:CallAuthUpdate(email, nil, false)
    else
      MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_EmailError)
      return
    end
  end
  local sendCodeCd = 60
  self.sendBtnCollider.enabled = false
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self.sendBtnLabel.text = string.format(ZhString.AuthUser_SendCodeCd, sendCodeCd)
    sendCodeCd = sendCodeCd - 1
    if sendCodeCd <= 0 then
      TimeTickManager.Me():ClearTick(self)
      self.sendBtnLabel.text = ZhString.AuthUser_SendCode
      self.sendBtnCollider.enabled = true
    end
  end, self)
end

function AuthUserInfoView:OnChangeBindBtnClick()
  self:HideChangeBindPart()
  self:ShowBindPart()
end

function AuthUserInfoView:OnBindConfirmBtnClick()
  if not self.privacyCheck then
    MsgManager.FloatMsg_S4(nil, ZhString.AuthUser_PrivacyNotCheck)
    return
  end
  if AuthUserInfoProxy.Instance:IsAuthUpdatedThisMonth(self.type) then
    local str = AuthTypeMsg[self.type] or ""
    MsgManager.FloatMsg_S4(nil, str)
    return
  end
  self:HideChangeBindPart()
  self:ShowBindPart()
  local content = AuthUserInfoProxy.Instance:GetAuthContent(self.type)
  if self.type == AuthType.PHONE then
    self.phoneNumberLabel.text = content
  else
    self.emailLabel.text = content
  end
end
