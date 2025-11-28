SetViewServiceEUPage = class("SetViewServiceEUPage", SetViewSubPage)

function SetViewServiceEUPage:Init(initParama)
  SetViewServiceEUPage.super.Init(self, initParama)
  self.conditionBtn = self:FindGO("condition")
  self:AddClickEvent(self.conditionBtn, function(go)
    Application.OpenURL("https://eu.ragnaroketernallove.com/en/terms-of-service-for-eu-residents")
  end)
  self.policyBtn = self:FindGO("policy")
  self:AddClickEvent(self.policyBtn, function(go)
    Application.OpenURL("https://eu.ragnaroketernallove.com/en/privacy-policy-for-eea-uk-residents")
  end)
  self.serviceBtn = self:FindGO("service")
  self:AddClickEvent(self.serviceBtn, function(go)
    local resVersion = VersionUpdateManager.CurrentVersion
    if resVersion == nil then
      resVersion = "Unknown"
    end
    local currentVersion = CompatibilityVersion.version
    local bundleVersion = GetAppBundleVersion.BundleVersion
    local version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.sid or 1
    local playerName = "未登入"
    if Game ~= nil and Game.Myself ~= nil then
      playerName = Game.Myself.data:GetName()
    end
    local lineName = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
    xdlog(playerName, lineName)
    playerName = playerName .. " | " .. lineName
    local info = OverSeaFunc.GetZenDeskInfo()
    if FunctionSDK.E_SDKType.TDSG == FunctionSDK.Instance.CurrentType then
      local roleInfo = ServiceUserProxy.Instance:GetNewRoleInfo()
      roleInfo = roleInfo ~= nil and roleInfo or ServiceUserProxy.Instance:GetRoleInfo()
      local roleId = roleInfo.id
      local roleName = Game.Myself.data:GetName()
      FunctionSDK.Instance:EnterBugReport(serverID, roleId, roleName)
    else
      FunctionSDK.Instance:EnterUserCenter(serverID, info, version)
    end
  end)
  self.notiToggle = self:FindGO("noticeTog"):GetComponent("UIToggle")
  self.notiToggle.value = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
  self.accountCancel = self:FindGO("accountCancel")
  if GameConfig.Logout_MenuId == 1 then
    self.accountCancel:SetActive(true)
    self:AddClickEvent(self.accountCancel, function(go)
      OverSeas_TW.OverSeasManager.GetInstance():AccountCancellation()
      Game.Me():BackToLogo()
    end)
  else
    self.accountCancel:SetActive(false)
  end
  self.userCenterBtn = self:FindGO("userCenter")
  self.userCenterBtn:SetActive(false)
  self:AddClickEvent(self.userCenterBtn, function(go)
    local version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.sid or 1
    Debug.LogError("userCenterBtn Click")
    FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
  end)
  self.notiToggle = self:FindGO("noticeTog"):GetComponent("UIToggle")
  self.oldStatus = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
  self.notiToggle.value = self.oldStatus
  EventDelegate.Add(self.notiToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus)
  end)
end

function SetViewServiceEUPage:Save()
  self.oldStatus = self.notiToggle.value
  OverSeas_TW.OverSeasManager.GetInstance():SetNotification(self.notiToggle.value)
end

function SetViewServiceEUPage:IsChanged()
  return self.oldStatus ~= self.notiToggle.value
end
