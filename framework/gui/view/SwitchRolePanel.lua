SwitchRolePanel = class("SwitchRolePanel", ContainerView)
SwitchRolePanel.ViewType = UIViewType.LoadingLayer
autoImport("LoadingSceneView")
autoImport("DefaultLoadModeView")
SwitchRolePanel.toswitchroleid = "SwitchRolePanel_toswitchroleid"
SwitchRolePanel.accid = "PlayerPrefsMYACC"
SwitchRolePanel.serverid = "PlayerPrefsMYServer"
SwitchRolePanel.isSwitchRoleIng = false

function SwitchRolePanel:Init()
  Buglylog("SwitchRolePanel:Init")
  self:initView()
  self:AddListenerEvts()
end

function SwitchRolePanel:OnEnter()
  self:initData()
  SwitchRolePanel.SetIsSwitchRole(true)
end

function SwitchRolePanel.SetIsSwitchRole(result)
  SwitchRolePanel.isSwitchRoleIng = result
end

function SwitchRolePanel:initData()
  self.isSdkLogin = false
  self.isConnectServer = false
  self.currentProgress = 0
  self.switchRole = nil
  if PlayerPrefs.HasKey(ServiceLoginUserCmdProxy.toswitchroleid) then
    self.switchRole = PlayerPrefs.GetString(ServiceLoginUserCmdProxy.toswitchroleid)
  end
  self.switchAcc = nil
  if PlayerPrefs.HasKey(SwitchRolePanel.accid) then
    self.switchAcc = PlayerPrefs.GetString(SwitchRolePanel.accid)
  end
  if not self.switchRole then
    self:goBackLogin()
    return
  end
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if SDKEnable then
    FunctionLogin.Me():launchAndLoginSdk(function()
      self.isSdkLogin = true
      self:UpdateServerList()
      if not self.serverData then
        self:goBackLogin()
        return
      end
      FunctionLogin.Me():startGameLogin(self.serverData, nil, function()
        self.isConnectServer = true
        PlayerPrefs.DeleteKey(ServiceLoginUserCmdProxy.toswitchroleid)
      end)
    end)
  else
    if PlayerPrefs.HasKey(SwitchRolePanel.serverid) then
      self.serverid = PlayerPrefs.GetInt(SwitchRolePanel.serverid)
      self.serverData = Table_ServerList[self.serverid]
    end
    if not self.serverid or not self.serverData then
      self:goBackLogin()
      return
    end
    self.isSdkLogin = true
    FunctionLogin.Me():startGameLogin(self.serverData, self.switchAcc, function()
      self.isConnectServer = true
      PlayerPrefs.DeleteKey(ServiceLoginUserCmdProxy.toswitchroleid)
    end)
  end
  self.currentView:StartLoadScene()
end

function SwitchRolePanel:goBackLogin()
  helplog("goBackLogin")
  SwitchRolePanel.SetIsSwitchRole(false)
  ServiceConnProxy.Instance:StopHeart()
  Game.Me():BackToLogo()
end

function SwitchRolePanel:initView()
  self.currentView = self:AddSubView("DefaultLoadModeView", DefaultLoadModeView)
  self.blackBg = self:FindGO("BlackBg"):GetComponent(UISprite)
  self:AddClickEvent(self.blackBg.gameObject, nil, {hideClickSound = true})
  self.timeTick = TimeTickManager.Me():CreateTick(0, 16, self.Update, self, 1)
end

function SwitchRolePanel:OnExit()
  Buglylog("SwitchRolePanel:OnExit")
  SwitchRolePanel.SetIsSwitchRole(false)
  SwitchRolePanel.super.OnExit(self)
  self.timeTick:ClearTick()
  FunctionBGMCmd.Me():GetDefaultBGM()
  self:ClearSafeDelayClose()
end

function SwitchRolePanel:ErrorMsg(msg)
  MsgManager.FloatMsgTableParam(nil, msg)
end

function SwitchRolePanel:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.HandlerRecvRoleInfo)
  self:AddListenEvt(NewLoginEvent.LaunchFailure, self.goBackLogin)
  self:AddListenEvt(NewLoginEvent.SDKLoginFailure, self.goBackLogin)
  self:AddListenEvt(NewLoginEvent.LoginFailure, self.goBackLogin)
  self:AddListenEvt(ServiceEvent.ErrorUserCmdMaintainUserCmd, self.goBackLogin)
  self:AddListenEvt(LoadEvent.SceneFadeOut, self.SceneFadeOut)
  self:AddListenEvt(LoadEvent.StartLoadScene, self.StartLoadScene)
  self:AddListenEvt(ServiceEvent.Error, self.HandlerServiceError)
  self:AddListenEvt(ServiceEvent.ConnNetDown, self.HandlerConnDown)
end

function SwitchRolePanel:UpdateServerList(note)
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if SDKEnable then
    local sid = PlayerPrefs.GetInt(SwitchRolePanel.serverid)
    self.serverData = self:GetServerDataBySid(sid)
    FunctionLogin.Me():setCurServerData(self.serverData)
  end
end

function SwitchRolePanel:GetServerDataBySid(sid)
  local serverDatas = FunctionLogin.Me():getServerDatas()
  if not serverDatas or 0 == #serverDatas then
    return
  end
  if sid then
    for i = 1, #serverDatas do
      local single = serverDatas[i]
      local serverSid = tonumber(single.sid)
      if serverSid == sid then
        return single
      end
    end
  end
  local tmpServer = FunctionLogin.Me():getDefaultServerData()
  tmpServer = tmpServer or serverDatas[#serverDatas]
  return tmpServer
end

function SwitchRolePanel:HandlerRecvRoleInfo(note)
  local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
  if allRoles and 0 < #allRoles then
    for i = 1, #allRoles do
      local single = allRoles[i]
      local isban = single.isban
      if tostring(single.id) == self.switchRole and single.deletetime == 0 and not isban then
        ServiceUserProxy.Instance:CallSelect(tonumber(self.switchRole))
        return
      end
    end
  end
  self:goBackLogin()
end

function SwitchRolePanel:HandlerServiceError(note)
  self.serverError = true
  self:CheckNetError()
end

function SwitchRolePanel:HandlerConnDown(note)
  self.serverError = true
  self:CheckNetError()
end

function SwitchRolePanel:SceneFadeOut(note)
  SceneProxy.Instance:ASyncLoad()
end

function SwitchRolePanel:LoadFinish()
  self.currentView:LoadFinish()
end

function SwitchRolePanel:CheckNetError()
  if self.serverError and self.Loaded then
    FunctionMapEnd.Me():Launch()
  end
end

function SwitchRolePanel:FireLoadFinishEvent()
  self:CheckNetError()
  self:sendNotification(ServiceEvent.PlayerMapChange, self.sceneInfo, LoadSceneEvent.FinishLoad)
end

function SwitchRolePanel:StartLoadScene(note)
  self.sceneInfo = note.body
  self.Loaded = false
  SceneProxy.Instance:SetLoadFinish(function(info)
    self.Loaded = true
    self.timeTick:ClearTick()
    self:LoadFinish()
  end)
  self.timeTick:Restart()
end

function SwitchRolePanel:Update(delta)
  if not self.isSdkLogin then
    self.currentProgress = self.currentProgress + 0.13
    if self.currentProgress >= 20 then
      self.currentProgress = 20
    end
  elseif self.isSdkLogin and not self.isConnectServer then
    if self.currentProgress < 25 then
      self.currentProgress = 25
    end
    self.currentProgress = self.currentProgress + 0.13
    if self.currentProgress >= 40 then
      self.currentProgress = 40
    end
  elseif self.isConnectServer then
    self.currentProgress = 50
  end
end

function SwitchRolePanel:ClearSafeDelayClose()
  local timer = self.safeCloseTimer
  if timer ~= nil then
    timer:Destroy()
    self.safeCloseTimer = nil
  end
end

function SwitchRolePanel:SafeDelayClose(noDelayClose)
  self:ClearSafeDelayClose()
  if not noDelayClose then
    self.safeCloseTimer = TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
      self:CloseSelf()
    end, self)
  end
end

return SwitchRolePanel
