autoImport("SecurityPanel")
autoImport("LangSwitchPanel")
SetViewSecurityPage = class("SetViewSecurityPage", SetViewSubPage)
local ICP = "沪ICP备11033765号-26A"
local ICPCheckURL = "https://beian.miit.gov.cn/#/Integrated/index"

function SetViewSecurityPage:Init(initParama)
  SetViewSecurityPage.super.Init(self, initParama)
  self:AddEvts()
  self:InitView()
  self:AddViewEvents()
  self:InitData()
end

function SetViewSecurityPage:InitView()
  local obj = self:FindGO("SecuritySetting")
  local Label = self:FindComponent("Label", UILabel, obj)
  Label.text = ZhString.SetViewSecurityPage_TabText
  local securityEventTip = self:FindComponent("securityEventTip", UILabel)
  securityEventTip.text = ZhString.SetViewSecurityPage_SecurityEventTipText
  self.tipLabel = self:FindComponent("tipLabel", UILabel)
  self.tipLabel.text = ZhString.SetViewSecurityPage_TipLabelText
  self.securityGrid = self:FindGO("securityGrid"):GetComponent(UITable)
  self.securityEventGO = self:FindGO("securityEventContent")
  self.securitySetBtnText = self:FindComponent("securitySetBtnText", UILabel)
  self.securityModifyBtn = self:FindGO("securityModifyBtn")
  local securityModifyBtnText = self:FindComponent("securityModifyBtnText", UILabel)
  securityModifyBtnText.text = ZhString.SetViewSecurityPage_SecurityModifyBtnText
  local privacyProtectionText = self:FindComponent("privacyProtection", UILabel)
  privacyProtectionText.text = ZhString.NewAgreeMentPanel_networkPrivacyLabel
  local serviceAgreementLable = self:FindComponent("serviceAgreement", UILabel)
  serviceAgreementLable.text = ZhString.NewAgreeMentPanel_AgreetmentLabel
  local privacyBriefLabel = self:FindComponent("privacyBrief", UILabel)
  privacyBriefLabel.text = ZhString.NewAgreeMentPanel_privacyAbstract
  local thirdPartyShareLabel = self:FindComponent("thirdPartyShare", UILabel)
  thirdPartyShareLabel.text = ZhString.NewAgreeMentPanel_thirdPartyShare
  local collectedPersonInfoLabel = self:FindComponent("collectedPersonInfo", UILabel)
  collectedPersonInfoLabel.text = ZhString.NewAgreeMentPanel_collectedPersonInfo
  local agreetRoot = self:FindGO("Agreement")
  if not BranchMgr:IsChina() then
    agreetRoot:SetActive(false)
  end
  local accId = self:FindComponent("AccValue", UILabel)
  accId.text = tostring(OverseaHostHelper.accId)
  local CopyBtn = self:FindGO("CopyBtn")
  self:AddClickEvent(CopyBtn, function(go)
    ApplicationInfo.CopyToSystemClipboard(OverseaHostHelper.accId)
  end)
  local GoServiceBtn = self:FindGO("GoServiceBtn")
  self:AddClickEvent(GoServiceBtn, function(go)
    OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member/support")
  end)
  local privacyPolicy = GameConfig.PrivacyPolicy
  self:AddButtonEvent("privacyProtection", function()
    if privacyPolicy and privacyPolicy.PrivacyProtect then
      Application.OpenURL(privacyPolicy.PrivacyProtect)
    end
  end)
  self:AddButtonEvent("serviceAgreement", function()
    if privacyPolicy and privacyPolicy.XDservice then
      Application.OpenURL(privacyPolicy.XDservice)
    end
  end)
  self:AddButtonEvent("privacyBrief", function()
    if privacyPolicy and privacyPolicy.PrivacyAbstract then
      Application.OpenURL(privacyPolicy.PrivacyAbstract)
    end
  end)
  self:AddButtonEvent("thirdPartyShare", function()
    if privacyPolicy and privacyPolicy.ThirdPartyShare then
      Application.OpenURL(privacyPolicy.ThirdPartyShare)
    end
  end)
  self:AddButtonEvent("collectedPersonInfo", function()
    if privacyPolicy and privacyPolicy.CollectedPersonalInfo then
      Application.OpenURL(privacyPolicy.CollectedPersonalInfo)
    end
  end)
  self.languageLabel = self:FindComponent("Label", UILabel, self:FindGO("LanguageFilterRoot"))
  self.thaiFont = self:FindComponent("Thai", UIFont)
  self:InitAuthUserInfo()
  self:TryInitLanguageSet()
  self:TryInitGovRecord()
end

function SetViewSecurityPage:ChangeFont()
  local dropDownList = self:FindGO("Drop-down List")
  if dropDownList and BranchMgr.IsSEA() and self.thaiFont then
    local thaiLab = self:FindComponent("1", UILabel, dropDownList)
    if thaiLab then
      thaiLab.trueTypeFont = nil
      thaiLab.bitmapFont = self.thaiFont
    end
  end
end

function SetViewSecurityPage:LanguageSetEnable()
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() or BranchMgr.IsVN() or BranchMgr.IsNO() or BranchMgr.IsNOTW() or BranchMgr.IsNOEN() then
    return true
  end
  if BranchMgr.IsChina() and not BackwardCompatibilityUtil.CompatibilityMode_V75 then
    if EnvChannel.IsTrunkBranch() or EnvChannel.IsStudioBranch() or EnvChannel.IsTFBranch() then
      return true
    else
      return false
    end
  end
  return false
end

function SetViewSecurityPage:InitAuthUserInfo()
  if Game.inAppStoreReview then
    return
  end
  local branch = BranchMgr.GetBranchName()
  if GameConfig.AuthUserInfo and GameConfig.AuthUserInfo.CountryCode[branch] then
    local authUserRoot = self:FindGO("AuthUser")
    authUserRoot:SetActive(true)
    local phone = self:FindGO("phone", authUserRoot)
    self:AddClickEvent(phone, function()
      self:OnAuthUserInfoBtnClick(1)
    end)
    local phoneSp = phone:GetComponent(UISprite)
    self.phoneLabel = self:FindComponent("content", UILabel, phone)
    local mail = self:FindGO("mail", authUserRoot)
    self:AddClickEvent(mail, function()
      self:OnAuthUserInfoBtnClick(2)
    end)
    local mailSp = mail:GetComponent(UISprite)
    self.mailLabel = self:FindComponent("content", UILabel, mail)
    self:RegisterRedTipCheck(GameConfig.AuthUserInfo.PhoneRedTip, phoneSp, 15)
    self:RegisterRedTipCheck(GameConfig.AuthUserInfo.MailRedTip, mailSp, 15)
    self:SetAuthUserInfo()
  end
end

function SetViewSecurityPage:OnAuthUserInfoBtnClick(type)
  if AuthUserInfoProxy.Instance:IsAuthUpdatedThisMonth(type) then
    MsgManager.ShowMsgByID(43441)
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AuthUserInfoView,
      viewdata = type
    })
  end
end

function SetViewSecurityPage:TryInitLanguageSet()
  if not self:LanguageSetEnable() then
    local langSet = self:FindGO("LanguageSet")
    langSet:SetActive(false)
    return
  end
  local langSet = self:FindGO("LanguageSet")
  langSet:SetActive(true)
  self.LanguageFilter = self:FindGO("LanguageFilter", langSet):GetComponent("UIPopupList")
  self.LanguageFilter:Clear()
  self:AddClickEvent(self:FindGO("LanguageFilter", langSet), function()
    self:ChangeFont()
  end)
  local lc = LangSwitchPanel:GetCurLanguageConf()
  self.LanguageFilter.value = lc.title
  for i = 1, #LangSwitchPanel.NeedLanguage do
    self.LanguageFilter:AddItem(LangSwitchPanel.NeedLanguage[i].title)
  end
  EventDelegate.Add(self.LanguageFilter.onChange, function()
    local selectValue = self.LanguageFilter.value
    if selectValue ~= LangSwitchPanel:GetCurLanguageConf().title then
      local lanName
      if selectValue == LangSwitchPanel.ThaiTitle then
        lanName = "Thai"
      else
        lanName = OverSea.LangManager.Instance():GetLangByKey(selectValue)
      end
      UIUtil.PopUpConfirmYesNoView(ZhString.NoticeTitle, string.format(ZhString.ChangeLangDes, tostring(lanName)), function()
        LangSwitchPanel:ReloadLanguage(LangSwitchPanel:GetCurLanguageKey(selectValue))
      end, nil, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
    end
    self.languageLabel.trueTypeFont = nil
    self.languageLabel.bitmapFont = selectValue == LangSwitchPanel.ThaiTitle and self.thaiFont or self.tipLabel.bitmapFont
  end)
end

function SetViewSecurityPage:TryInitGovRecord()
  self.govRecordContent = self:FindGO("GovRecordContent")
  self.govRecordContent_Label = self:FindGO("govRecordLabel", self.govRecordContent):GetComponent(UILabel)
  self.recordCheckBtn = self:FindGO("recordCheckBtn", self.govRecordContent)
  self.govRecordContent_Label.text = string.format(ZhString.SetViewSecurityPage_ICP_Code, ICP)
  self:AddClickEvent(self.recordCheckBtn, function()
    Application.OpenURL(ICPCheckURL)
  end)
  if BranchMgr.IsChina() then
    self.govRecordContent:SetActive(true)
  else
    self.govRecordContent:SetActive(false)
  end
end

function SetViewSecurityPage:AddViewEvents()
  self:AddButtonEvent("securitySetBtn", function()
    if not self.hasSet then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.SecurityPanel,
        viewdata = {
          ActionType = SecurityPanel.ActionType.Setting
        }
      })
    elseif self.hasReSet then
      MsgManager.ConfirmMsgByID(6008, function()
        ServiceAuthorizeProxy.Instance:CallResetAuthorizeUserCmd(false)
      end)
    else
      MsgManager.ConfirmMsgByID(6003, function()
        ServiceAuthorizeProxy.Instance:CallResetAuthorizeUserCmd(true)
      end)
    end
  end)
  self:AddClickEvent(self.securityModifyBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SecurityPanel,
      viewdata = {
        ActionType = SecurityPanel.ActionType.Modify
      }
    })
  end)
end

function SetViewSecurityPage:AddEvts()
  self:AddListenEvt(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, self.HandleRecvAuthorizeInfo)
  self:AddListenEvt(ServiceEvent.SceneUser3AuthUpdateUserCmd, self.HandleAuthUpdateUserCmd)
end

function SetViewSecurityPage:HandleRecvAuthorizeInfo()
  self:SettingUI()
end

function SetViewSecurityPage:HandleAuthUpdateUserCmd()
  self:SetAuthUserInfo()
end

function SetViewSecurityPage:InitData()
  for k, v in pairs(Table_SecuritySetting) do
    local desc = v.Desc
    local labObj, labComp = self:CopyGameObject(self.securityEventGO)
    labObj:SetActive(true)
    labComp = labObj:GetComponent(UILabel)
    labComp.text = desc
  end
  self.securityGrid:Reposition()
end

function SetViewSecurityPage:SettingUI()
  TimeTickManager.Me():ClearTick(self)
  local tipText = ""
  local myself = FunctionSecurity.Me()
  local resetTime = myself.verifySecuriyResettime
  self.hasSet = myself.verifySecuriyhasSet
  self.hasReSet = resetTime and resetTime ~= 0
  if not self.hasSet then
    self:Hide(self.securityModifyBtn)
    tipText = string.format(ZhString.SetViewSecurityPage_TipLabelText, "[c][D91E1DFF]" .. ZhString.SetViewSecurityPage_UnSet .. "[-][/c]")
    self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecuritySetBtnText
  elseif self.hasReSet then
    self:Hide(self.securityModifyBtn)
    TimeTickManager.Me():CreateTick(0, 1000, self.ChangetipText, self)
    self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecurityCancelBtnText
  else
    self:Show(self.securityModifyBtn)
    tipText = string.format(ZhString.SetViewSecurityPage_TipLabelText, "[c][13C433FF]" .. ZhString.SetViewSecurityPage_valiable .. "[-][/c]")
    self.securitySetBtnText.text = ZhString.SetViewSecurityPage_SecurityResetBtnText
  end
  self.tipLabel.text = tipText
end

function SetViewSecurityPage:SetAuthUserInfo()
  local phoneNumber = AuthUserInfoProxy.Instance:GetAuthContent(1)
  local mailAddress = AuthUserInfoProxy.Instance:GetAuthContent(2)
  if not StringUtil.IsEmpty(phoneNumber) then
    self.phoneLabel.text = StringUtil.ReplacePhoneOrEmail(phoneNumber)
  else
    self.phoneLabel.text = "Mobile"
  end
  if not StringUtil.IsEmpty(mailAddress) then
    self.mailLabel.text = StringUtil.ReplacePhoneOrEmail(mailAddress)
  else
    self.mailLabel.text = "Mail"
  end
end

function SetViewSecurityPage:ChangetipText()
  local myself = FunctionSecurity.Me()
  local resetTime = myself.verifySecuriyResettime
  local leftTime = resetTime - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(myself.verifySecuriyCode)
    leftTime = 0
    TimeTickManager.Me():ClearTick(self)
  end
  leftTime = math.floor(leftTime)
  local day = math.floor(leftTime / 3600 / 24)
  local hour = math.floor((leftTime - day * 24 * 3600) / 3600)
  local m = math.floor((leftTime - day * 24 * 3600 - hour * 3600) / 60)
  local timeStr = string.format(ZhString.SetViewSecurityPage_SecurityResetTimeLeft, day, hour, m)
  local tipText = string.format(ZhString.SetViewSecurityPage_ResetPassDelay, timeStr)
  self.tipLabel.text = tipText
end

function SetViewSecurityPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
end

function SetViewSecurityPage:SwitchOn()
  SetViewSecurityPage.super.SwitchOn(self)
  self:SettingUI()
end
