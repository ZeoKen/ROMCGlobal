TXWYPlatPanel = class("TXWYPlatPanel", BaseView)
TXWYPlatPanel.ViewType = UIViewType.PopUpLayer
local accid, serverID, version, SelfInstance
TXWYPlatPanel.UIElements = {
  "Acc",
  "Security",
  "Copy",
  "ServiceBtn",
  "ActBtn",
  "System",
  "UserCenter",
  "LangBtn"
}
TXWYPlatPanel.BranchConfig = {
  Japan = {
    ServiceBtn = function(go)
      OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member/support")
    end,
    ActBtn = function(go)
      OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/rules/terms.html")
    end,
    System = function(go)
      OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/rm/privacy")
    end,
    UserCenter = function(go)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    LogoIcon = "GOElogo"
  },
  TW = {
    Security = function(go)
      PlayerPrefs.SetInt("NeedCheckGuest", 1)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      Application.OpenURL("https://www.gnjoy.com.tw/Cs")
    end,
    LogoIcon = "index2-ro"
  },
  NOTW = {
    Security = function(go)
      PlayerPrefs.SetInt("NeedCheckGuest", 1)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CustomerServicePanel
      })
    end,
    LogoIcon = "index2-ro"
  },
  NOEN = {
    Security = function(go)
      PlayerPrefs.SetInt("NeedCheckGuest", 1)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CustomerServicePanel
      })
    end,
    LangBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LangSwitchPanel
      })
      if SelfInstance then
        SelfInstance:CloseSelf()
      end
    end,
    LogoIcon = "index2-ro"
  },
  Korea = {
    Security = function(go)
      PlayerPrefs.SetInt("NeedCheckGuest", 1)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      Application.OpenURL("https://member.gnjoy.com/mobile/inquiry/rom")
    end,
    LogoIcon = "index2-ro"
  },
  SEA = {
    Security = function(go)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CustomerServicePanel
      })
    end,
    LangBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LangSwitchPanel
      })
      if SelfInstance then
        SelfInstance:CloseSelf()
      end
    end,
    LogoIcon = "index2-ro"
  },
  NO = {
    Security = function(go)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CustomerServicePanel
      })
    end,
    LangBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LangSwitchPanel
      })
      if SelfInstance then
        SelfInstance:CloseSelf()
      end
    end,
    LogoIcon = "index2-ro"
  },
  NA = {
    Security = function(go)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CustomerServicePanel
      })
    end,
    LangBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LangSwitchPanel
      })
      if SelfInstance then
        SelfInstance:CloseSelf()
      end
    end,
    LogoIcon = "index2-ro"
  },
  EU = {
    Security = function(go)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    ServiceBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CustomerServicePanel
      })
    end,
    LangBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LangSwitchPanel
      })
      if SelfInstance then
        SelfInstance:CloseSelf()
      end
    end,
    LogoIcon = "index2-ro"
  },
  VN = {
    Security = function(go)
      FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
    end,
    LangBtn = function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LangSwitchPanel
      })
      if SelfInstance then
        SelfInstance:CloseSelf()
      end
    end,
    LogoIcon = "index2-ro"
  }
}

function TXWYPlatPanel:Init()
  self:SetBranch()
  if not self.branchConfig then
    LogUtility.Warning("TXWYPlatPanel has not been set to any of the branches.")
    self:CloseSelf()
    return
  end
  self:SetLogo()
  local server = FunctionLogin.Me():getCurServerData()
  serverID = server ~= nil and server.serverid or 1
  accid = OverseaHostHelper.accId
  local resVersion = VersionUpdateManager.CurrentVersion
  if resVersion == nil then
    resVersion = "Unknown"
  end
  local currentVersion = CompatibilityVersion.version
  local bundleVersion = GetAppBundleVersion.BundleVersion
  version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
  for _, goName in pairs(TXWYPlatPanel.UIElements) do
    local go = self:FindGO(goName)
    if go then
      go:SetActive(false)
      self[goName] = go
    end
  end
  local activeGOCount = 0
  for goName, goConfig in pairs(self.branchConfig) do
    if self[goName] then
      self[goName]:SetActive(true)
      activeGOCount = activeGOCount + 1
      if type(goConfig) == "function" then
        self:AddClickEvent(self[goName], goConfig)
      end
    end
  end
  self.bg = self:FindComponent("Bg", UISprite)
  self.btnGrid = self:FindComponent("BtnGrid", UIGrid)
  self.bg.height = 340 + activeGOCount * 40
  self.btnGrid:Reposition()
  self.accId = self:FindComponent("AccID", UILabel)
  if self.accId then
    self.accId.text = string.format(ZhString.ACCIDJP, accid)
  end
  self:AddButtonEvent("LogOut", function()
    self:CloseSelf()
    OverSeas_TW.OverSeasManager.GetInstance():SignOut()
    Game.Me():BackToLogo()
  end)
end

function TXWYPlatPanel:SetBranch()
  for branch, config in pairs(TXWYPlatPanel.BranchConfig) do
    if BranchMgr["Is" .. branch] and BranchMgr["Is" .. branch]() then
      self.branchConfig = config
      LogUtility.InfoFormat("TXWYPlatPanel has been set to branch {0}", branch)
      return
    end
  end
end

function TXWYPlatPanel:SetLogo()
  local logoSp = self:FindComponent("Logo", UISprite)
  logoSp.spriteName = self.branchConfig.LogoIcon
  logoSp:MakePixelPerfect()
end

function TXWYPlatPanel.ReloadLanguage(lang)
  OverSea.LangManager.Instance():SetCurLang(lang)
  Game.Me():BackToLogo()
end

function TXWYPlatPanel:OnEnter()
  TXWYPlatPanel.super.OnEnter(self)
  SelfInstance = self
end

function TXWYPlatPanel:OnExit()
  SelfInstance = nil
  TXWYPlatPanel.super.OnExit(self)
end
