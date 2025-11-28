SetViewServiceNAPage = class("SetViewServiceNAPage", SetViewServiceWWPage)

function SetViewServiceNAPage:Init(initParam)
  SetViewServiceNAPage.super.Init(self, initParam)
end

function SetViewServiceNAPage:InitUnique()
  self.privacyNoticeBtn = self:FindGO("privacyNoticeforCalifornia")
  self:AddClickEvent(self.privacyNoticeBtn, function(go)
    Application.OpenURL("https://na.ragnaroketernallove.com/privacy-notice")
  end)
  self:AddClickEvent(self.conditionBtn, function(go)
    Application.OpenURL("https://na.ragnaroketernallove.com/terms-of-service")
  end)
  self:AddClickEvent(self.policyBtn, function(go)
    Application.OpenURL("https://na.ragnaroketernallove.com/privacy-policy")
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
    local charid
    if Game ~= nil and Game.Myself ~= nil then
      playerName = Game.Myself.data:GetName()
      if Game.Myself.data ~= nil and Game.Myself.data.userdata ~= nil then
        local server = FunctionLogin.Me():getCurServerData()
        level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
        charid = Game.Myself.data.id
      end
    end
    FunctionSDK.Instance:EnterBugReport(serverID, charid, playerName)
  end)
  self.userCenterBtn = self:FindGO("userCenter")
  self.userCenterBtn:SetActive(false)
  self:AddClickEvent(self.userCenterBtn, function(go)
    Debug.LogError("go = >" .. go.name)
    local version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.sid or 1
    FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
  end)
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
end
