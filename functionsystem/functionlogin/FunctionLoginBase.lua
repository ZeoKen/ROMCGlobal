autoImport("OverseaHostHelper")
FunctionLoginBase = class("FunctionLoginBase")
local LastSusRegistUrlPrefs = "FunctionLoginBase_LastSusRegistUrlPrefs"

function FunctionLoginBase.Me()
  if nil == FunctionLoginBase.me then
    FunctionLoginBase.me = FunctionLoginBase.new()
  end
  return FunctionLoginBase.me
end

function FunctionLoginBase:ctor()
  self.authUrlHost = nil
  self.authPort = nil
  self.AuthHostHandlerTimes = 0
  self.hasShowAnnouncement = false
  self.retryTime = 0
  self.delayTime = 1
  self.retryTime_Nov = 0
  self.delayTime_Nov = 1
  self.hasHandleResp = false
  self.parseLoginDataSus = false
  self.parseLoginDataSus_Nov = false
  if not self:EnableNoviceServer() then
    self.hasHandleResp_Nov = true
  end
end

function FunctionLoginBase:EnableNoviceServer()
  if self.EnableNovServer ~= nil then
    return self.EnableNovServer
  end
  local plat = self:GetPlat()
  if plat == "1" then
    self.EnableNovServer = GameConfig.ReleaseOpenNovServer == 1
  else
    self.EnableNovServer = GameConfig.TFOpenNovServer == 1
  end
  if BranchMgr.IsNOEN() then
    self.EnableNovServer = true
  end
  return self.EnableNovServer
end

function FunctionLoginBase:initLoginOutListen()
  FunctionSDK.Instance:ListenLogout(function(x)
    self:OnLogoutSuccess(x)
  end, function(x)
    self:OnLogoutFail(x)
  end)
  FunctionSDK.Instance:BindStatus(function(msg)
    if msg == "LogOut" then
      Game.Me():BackToLogo()
    end
  end)
end

function FunctionLoginBase:ClearLoginOutListen()
  FunctionSDK.Instance:ListenLogout(nil, nil)
  FunctionSDK.Instance:BindStatus(nil)
end

function FunctionLoginBase:OnLogoutSuccess(message)
  self:ClearLoginData()
  message = message or ""
  GameFacade.Instance:sendNotification(NewLoginEvent.LogoutEvent)
  FunctionLogin.clearRestorePay()
  LogUtility.InfoFormat("ListenLogout sucess msg:{0}", message)
end

function FunctionLoginBase:OnLogoutFail(message)
  self:ClearLoginData()
  message = message or ""
  GameFacade.Instance:sendNotification(NewLoginEvent.LogoutEvent)
  LogUtility.InfoFormat("ListenLogout failure msg:{0}", message)
end

function FunctionLoginBase:GetActiveAppendUrl()
  local sdkType = self:getSdkType()
  if sdkType == FunctionSDK.E_SDKType.XD then
    return NetConfig.ActivateUrl_Xd
  else
    return NetConfig.ActivateUrl_Tdsg
  end
end

function FunctionLoginBase:GetAuthAppendUrl()
  local sdkType = self:getSdkType()
  LogUtility.InfoFormat("GetAuthAppendUrl sdkType:{0}", sdkType)
  if sdkType == FunctionSDK.E_SDKType.XD then
    return NetConfig.AccessTokenAuthUrl_Xd
  end
end

function FunctionLoginBase:GetActiveUrl(serverData, cdKey)
  local url = ""
  local actUrl = self:GetActiveAppendUrl()
  local port = self:GetAuthPort()
  local token = self:getToken()
  local sdkType = self:getSdkType()
  local old_deviceId = FunctionLoginTDSG.Me():GetOld_DeviceID()
  local new_deviceId = FunctionLoginTDSG.Me():GetNew_DeviceID()
  if sdkType == FunctionSDK.E_SDKType.TDSG then
    local client_id = FunctionLoginTDSG.Me():GetTDSG_ClientID()
    local mac_key = FunctionLoginTDSG.Me():GetTDSG_MacKey()
    local plat = self:GetPlat()
    url = string.format("%s%s&cdkey=%s&mac_key=%s&client_id=%s&p=%s", actUrl, token, cdKey, mac_key, client_id, plat)
  elseif serverData.servertype == "novice" and self.noviceLoginData then
    url = string.format("%s%s&cdkey=%s", actUrl, token, cdKey)
  else
    url = string.format(":%s%s%s&cdkey=%s", port, actUrl, token, cdKey)
  end
  url = string.format("%s&old_deviceid=%s&new_deviceid=%s", url, old_deviceId, new_deviceId)
  return url
end

function FunctionLoginBase:GetAuthAccUrl(token, noport)
  local authUrl = self:GetAuthAppendUrl()
  local version = self:getServerVersion()
  local plat = self:GetPlat()
  local port = self:GetAuthPort()
  local clientCode = CompatibilityVersion.version
  local vd = self:getvd()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    clientCode = FunctionLogin.Me().debugClientCode
  end
  local url = string.format(":%s%s%s&plat=%s&version=%s&clientCode=%s&vd=%s", port, authUrl, token, plat, version, clientCode, vd)
  if noport then
    url = string.format("%s%s&plat=%s&version=%s&clientCode=%s&vd=%s", authUrl, token, plat, version, clientCode, vd)
  end
  return url
end

function FunctionLoginBase:GetRegistUrl(token, serverData)
  local authUrl = NetConfig.GetAccDataAddress
  local version = self:getServerVersion()
  local plat = self:GetPlat()
  local port = self:GetAuthPort()
  local sid = serverData.sid
  local clientCode = CompatibilityVersion.version
  local vd = self:getvd()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    clientCode = FunctionLogin.Me().debugClientCode
  end
  local url
  if serverData.servertype == "novice" and self.noviceLoginData then
    url = string.format("%s%s&plat=%s&version=%s&clientCode=%s&vd=%s&sid=%s", authUrl, token, plat, version, clientCode, vd, sid)
  else
    url = string.format(":%s%s%s&plat=%s&version=%s&clientCode=%s&vd=%s&sid=%s", port, authUrl, token, plat, version, clientCode, vd, sid)
  end
  return url
end

function FunctionLoginBase:getServerVersion()
  return FunctionLogin.Me():getServerVersion()
end

function FunctionLoginBase:GetOld_DeviceID()
  if EnvChannel.IsReleaseBranch() then
    if not BackwardCompatibilityUtil.CompatibilityMode_V73 then
      return ""
    else
      return ""
    end
  end
  return ""
end

function FunctionLoginBase:GetNew_DeviceID()
  if EnvChannel.IsReleaseBranch() then
    if not BackwardCompatibilityUtil.CompatibilityMode_V73 then
      return ""
    else
      return ""
    end
  end
  return ""
end

function FunctionLoginBase:GetPlat()
  local plat = FunctionLogin.Me().debugPlat
  local isDebug = FunctionLogin.Me():isDebug()
  local privateMode = FunctionLogin.Me():isPrivateMode()
  if privateMode then
    plat = FunctionLogin.Me().PrivatePlat
  elseif not isDebug then
    local json = EnvChannel.GetHttpOperationJson()
    if json then
      local ele = json.elements
      if ele and ele.plat then
        plat = ele.plat
      end
    end
  end
  plat = tostring(plat)
  return plat
end

function FunctionLoginBase:GetAuthPort()
  if not self.authPort then
    local port = 5003
    local isDebug = FunctionLogin.Me():isDebug()
    if isDebug then
      port = FunctionLogin.Me().debugAuthPort
    end
    local privateMode = FunctionLogin.Me():isPrivateMode()
    if privateMode then
      port = NetConfig.PrivateAuthServerUrlPort
    else
      local verStr = VersionUpdateManager.serverResJsonString
      local result = StringUtil.Json2Lua(verStr)
      if result and result.data then
        local data = result.data
        local tmp = tonumber(data.authport)
        port = tmp and tmp or port
      end
    end
    LogUtility.InfoFormat("FunctionLoginBase:GetAuthPort() authPort:{0}", port)
    self.authPort = port
  end
  return self.authPort
end

function FunctionLoginBase:GetAddress(serverData)
  local addresses, address
  if not BranchMgr.IsChina() then
    addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
    if addresses then
      address = addresses[1]
    end
  elseif serverData.servertype == "novice" and self.noviceLoginData then
    address = NetConfig.AuthHostNovice[self:GetPlat()]
  else
    addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
    if addresses then
      address = addresses[1]
    end
  end
  return address
end

function FunctionLoginBase:StartActive(serverData, cdKey, callback)
  local address = self:GetAddress(serverData)
  local url = self:GetActiveUrl(serverData, cdKey)
  self:requestGetUrlHost(url, function(status, content)
    if callback then
      callback(status, content)
    end
  end, address)
end

function FunctionLoginBase:requestGetUrlHost(url, callback, address)
  FunctionLogin.Me():requestGetUrlHost(url, callback, address)
end

function FunctionLoginBase:CheckAccTokenValid(result)
  if result and result.status == FunctionLogin.AuthStatus.Ok then
    return result.data
  end
end

function FunctionLoginBase:HandleAnnoucement(accData)
  if accData then
    local msg = accData.msg
    local tips = accData.tips
    local PicUrl = accData.picurl
    if msg or tips or PicUrl then
      self.readyMSG = msg
      self.readyTips = tips
      self.readyPicURL = PicUrl
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1500.0, self.OnTimeTick, self, 1)
    end
  end
end

function FunctionLoginBase:OnTimeTick()
  FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, self.readyMSG, self.readyTips, ZhString.ServiceErrorUserCmdProxy_Confirm, self.readyPicURL)
  TimeTickManager.Me():ClearTick(self, 1)
  if not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina() then
    FunctionTyrantdb.Instance:trackEvent("#ShowMaintainMsg", nil)
  end
end

function FunctionLoginBase:RegistDataHandler(status, content, callback, address)
  if status == NetConfig.ResponseCodeOk then
    self:resetRetryTime()
    self:SetLastSusRegistUrl(address)
    local result = FunctionLoginAnnounce.Me():tryParseStrToJson(content)
    if result and result.data then
      local accData = result.data
      if not callback then
        return
      end
      callback(NetConfig.ResponseCodeOk, accData)
    else
      helplog("FunctionLogin:tryGetAccDataFromRemote parse error:", content)
      if not callback then
        return
      end
      callback(FunctionLogin.ErrorCode.RequestCreateAccParseError, content)
    end
  else
    local retry = self:checkIfNeedRetry()
    if retry then
      self.retryTime = self.retryTime + 1
      self:RetryRequestRegist()
    else
      self:resetRetryTime()
      status = tonumber(status) or 0
      helplog("FunctionLogin:tryGetAccDataFromRemote net error:", content)
      if not callback then
        return
      end
      callback(FunctionLogin.ErrorCode.RequestCreateAccNetError + status, content)
    end
  end
end

function FunctionLoginBase:RetryRequestRegist()
  self.delayTime = self.delayTime + math.random() * self.retryTime
  LogUtility.InfoFormat("FunctionLoginBase:RetryRequestRegist(  ) self.retryTime:{0},self.delayTime:{1}", self.retryTime, self.delayTime)
  if self.delayTime and self.delayTime > 0 then
    TimeTickManager.Me():CreateOnceDelayTick(self.delayTime * 1000, function(owner, deltaTime)
      self:RequestRegist(self.registServerData, self.registCallback)
    end, self)
  else
    self:RequestRegist(self.registServerData, self.registCallback)
  end
end

function FunctionLoginBase:SetRegistData(serverData, callback)
  self.registServerData = serverData
  self.registCallback = callback
end

function FunctionLoginBase:GetRegistAddress(serverData)
  return self:GetAddress(serverData)
end

function FunctionLoginBase:GetLastSusRegistUrl()
  local lastUrl = PlayerPrefs.GetString(LastSusRegistUrlPrefs, "")
  local isEmpty = StringUtil.IsEmpty(lastUrl)
  if isEmpty then
    return nil
  end
  return lastUrl
end

function FunctionLoginBase:SetLastSusRegistUrl(address)
  PlayerPrefs.SetString(LastSusRegistUrlPrefs, address)
end

function FunctionLoginBase:StartRequestRegist(serverData, callback)
  self:resetRetryTime()
  self:SetRegistData(serverData, callback)
  self:RequestRegist(self.registServerData, self.registCallback)
end

function FunctionLoginBase:RequestRegist(serverData, callback)
  local token = self:getToken()
  LogUtility.InfoFormat("FunctionLoginBase:RequestRegist token:{0}", token)
  if token then
    local url = self:GetRegistUrl(token, serverData)
    local address = self:GetRegistAddress(serverData)
    if BranchMgr.IsChina() then
      FunctionLogin.Me():requestGetUrlHost(url, function(status, content)
        self:RegistDataHandler(status, content, callback, address)
      end, address)
    else
      self:requestRegistUrlHost(url, function(status, content)
        self:RegistDataHandler(status, content, callback, address)
      end, address)
    end
  else
    if not callback then
      return
    end
    callback(FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken)
  end
end

function FunctionLoginBase:requestRegistUrlHost(url, callback, address, privateMode)
end

function FunctionLoginBase:LoginDataHandler(status, content, callback, novice)
  Buglylog("FunctionLoginBase:LoginDataHandler(")
  local result
  local isCall = pcall(function(i)
    result = StringUtil.Json2Lua(content)
    if result == nil and status == NetConfig.ResponseCodeOk then
      result = json.decode(content)
    end
  end)
  local accData = self:CheckAccTokenValid(result)
  helplog("LoginDataHandler:", novice, self.hasHandleResp_Nov, self.hasHandleResp)
  helplog("LoginDataHandler:", self.parseLoginDataSus, self.parseLoginDataSus_Nov)
  helplog("FunctionLoginBase:LoginDataHandler:", status, content, tostring(self:getToken()))
  if status == NetConfig.ResponseCodeOk and accData then
    FunctionTyrantdb.Instance:trackEvent("#GameAuthVerifySucess", nil)
    local regions = accData.regions
    local hasServerList = regions and 0 < #regions
    if hasServerList then
      local loginData = {}
      loginData.default = accData.default
      loginData.accstate = accData.accstate
      loginData.uid = accData.uid
      loginData.lastlogintm = accData.lastlogintm and accData.lastlogintm or 0
      loginData.uidstate = accData.uidstate
      loginData.activePlayer = accData.activePlayer and tonumber(accData.activePlayer) or 1
      loginData.resourceReward = accData.resourceReward
      loginData.authorize_state = accData.authorize_state
      loginData.param = accData.param
      loginData.agreed = accData.agreed
      loginData.flag = accData.flag
      loginData.site = accData.site
      loginData.lang_zone = accData.lang_zone
      loginData.oneid = accData.oneid
      helplog("oneid:", accData.oneid)
      loginData.phone = accData.phone
      local isActivated = accData.isActivated
      loginData.isActivated = isActivated
      FunctionLogin.Me():setAgreeStatus(accData.agreed)
      FunctionLogin.Me():setLogin_authoriz_state(accData.authorize_state)
      FunctionLogin.Me():setSecurityParam(accData.param)
      SpyInfo.specialUser = accData.uidstate
      if novice then
        self:SetNoviceLoginData(loginData)
      else
        self:SetNormalLoginData(loginData)
      end
      self:setServerData(regions, loginData)
      FunctionLogin.Me():setPhoneNum(accData.phone)
      FunctionLogin.Me():setLoginSite(accData.site)
      if not BranchMgr.IsChina() then
        FunctionLogin.Me():set_IsTmp(accData.isGuest ~= nil and tonumber(accData.isGuest) or 0)
        OverseaHostHelper.isGuest = accData.isGuest ~= nil and tonumber(accData.isGuest) or 0
      else
        FunctionLogin.Me():set_IsTmp(accData.is_tmp)
      end
      if BranchMgr.IsKorea() then
        OverseaHostHelper:SetFireBaseNotify(accData.uid, accData.firebaseNotify, accData.firebaseNotifyUpdated, accData.firebaseNotifyExpired)
      end
      if novice then
        self.parseLoginDataSus_Nov = true
      else
        self.parseLoginDataSus = true
      end
      if self.hasHandleResp and self.hasHandleResp_Nov then
        self:SetLoginData()
        if callback then
          callback()
        end
        GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
      end
    elseif self.hasHandleResp and self.hasHandleResp_Nov then
      self:SetLoginData()
      if not self.parseLoginDataSus and not self.parseLoginDataSus_Nov then
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.LoginDataHandler_ServerListEmpty
        })
      else
        GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
      end
    end
  elseif status ~= NetConfig.ResponseCodeOk and self.hasHandleResp and self.hasHandleResp_Nov then
    self:SetLoginData()
    if not self.parseLoginDataSus and not self.parseLoginDataSus_Nov then
      GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
      MsgManager.ShowMsgByIDTable(1017, {
        FunctionLogin.ErrorCode.LoginDataHandler_Failure + status
      })
    else
      GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
    end
  else
    if not self.hasHandleResp or not self.hasHandleResp_Nov then
      return
    end
    self:SetLoginData()
    if self.parseLoginDataSus or self.parseLoginDataSus_Nov then
      GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
    elseif result then
      GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
      if result.status == FunctionLogin.AuthStatus.NoActive then
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "ActivePanel"
        })
      elseif result.status == 888003 then
        if not BranchMgr.IsChina() then
          FunctionSDK.Instance:TDSGRefundStatus(function(msg)
            if msg == "success" then
              GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
                viewname = "StartGamePanel"
              })
            end
          end)
        else
          local orders = result.data.orders
          if orders ~= nil then
            helplog("海外补单", #orders)
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.ReplenishmentPanel,
              viewdata = orders
            })
          end
        end
      elseif result.status == FunctionLogin.AuthStatus.GetServerListFailure then
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.CheckAccTokenValid_Failure_GetServerListFailure
        })
      elseif result.status == FunctionLogin.AuthStatus.CreateRoleFailure then
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.CheckAccTokenValid_Failure_CreateRoleFailure
        })
      elseif result.status == 888001 then
        MsgManager.ShowMsgByIDTable(888001, {})
      elseif result.status == 888002 then
        MsgManager.ShowMsgByIDTable(888002, {})
      elseif result.status == 889001 then
        MsgManager.ShowMsgByIDTable(889001, {})
      else
        MsgManager.ShowMsgByIDTable(1017, {
          result.status
        })
      end
    else
      GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
      MsgManager.ShowMsgByIDTable(1017, {
        FunctionLogin.ErrorCode.LoginDataHandler_Failure
      })
    end
  end
end

function FunctionLoginBase:LaunchSdkHandler(bRet, msg, callback)
  local result
  if bRet then
    result = "FunctionLoginBase:LaunchSdk result sucess!"
  else
    result = "FunctionLoginBase:LaunchSdk result failure!"
  end
  LogUtility.InfoFormat("FunctionLoginBase:LaunchSdkHandler(  ) Launch result:{0},msg:{1}", bRet, tostring(msg))
  Buglylog(result)
  if callback then
    callback(bRet, msg)
  end
end

function FunctionLoginBase:LaunchSdk(callback)
  Buglylog("FunctionLoginBase:LaunchSdk")
  if not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina() then
    FunctionTyrantdb.Instance:trackEvent("#SDKInit", nil)
  end
  local launchScs = self:isInitialized()
  local debug = FunctionLogin.Me():isDebug()
  if not debug then
    if launchScs then
      if callback then
        callback(launchScs)
      end
    else
      local currentType = FunctionSDK.Instance.CurrentType
      if currentType == FunctionSDK.E_SDKType.XD then
        local xdsdkApplicationInfo = AppBundleConfig.GetXDSDKInfo()
        FunctionSDK.Instance:XDSDKInitialize(xdsdkApplicationInfo.APP_ID, xdsdkApplicationInfo.APP_SECRET, xdsdkApplicationInfo.PRIVATE_SECRET, xdsdkApplicationInfo.ORIENTATION, function(sucMsg)
          self:LaunchSdkHandler(true, sucMsg, callback)
        end, function(failMsg)
          self:LaunchSdkHandler(false, failMsg, callback)
        end)
      elseif currentType == FunctionSDK.E_SDKType.TDSG then
        local lang = AppBundleConfig.GetSDKLang_TDSG()
        FunctionSDK.Instance:TDSGSDKInitialize(tonumber(lang), function(sucMsg)
          self:LaunchSdkHandler(true, sucMsg, callback)
        end, function(failMsg)
          self:LaunchSdkHandler(false, failMsg, callback)
        end)
      end
    end
    self:initLoginOutListen()
  else
    self:LaunchSdkHandler(true, "debug mode launchScs", callback)
  end
end

function FunctionLoginBase:SdkLoginHandler(code, msg, callback)
  LogUtility.InfoFormat("FunctionLoginBase:SdkLoginHandler(  ) return,Login result:{0},msg:{1}", bRet, msg)
  self:ClearLoginData()
  if code == FunctionLogin.LoginCode.SdkLoginSuc then
    if callback then
      callback()
    end
  elseif code == FunctionLogin.LoginCode.SdkLoginCancel then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  elseif code == FunctionLogin.LoginCode.SdkLoginNoneSdkType then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    LogUtility.Info(ZhString.Login_SdkLoginNoneSdkType, "none")
  else
    msg = msg and tostring(msg) or "null"
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    MsgManager.ShowMsgByIDTable(1037, {
      FunctionLogin.ErrorCode.Login_SDKLoginFailure,
      msg
    })
  end
  if code == FunctionLogin.LoginCode.SdkLoginSuc then
    Buglylog("FunctionLoginBase:SdkLoginHandler SDKLoginSucess")
    FunctionTyrantdb.Instance:trackEvent("#SDKLoginSucess", nil)
  else
    Buglylog("FunctionLoginBase:SdkLoginHandler SDKLoginFailure")
    FunctionTyrantdb.Instance:trackEvent("#SDKLoginFailure", nil)
  end
end

function FunctionLoginBase:startSdkLogin(callback)
  Buglylog("FunctionLoginBase:startSdkLogin")
  local launchScs = self:isInitialized()
  FunctionLogin.Me().callback = callback
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    callback(FunctionLogin.LoginCode.SdkLoginSuc, "debug mode sucMsg")
    return
  end
  LogUtility.InfoFormat("FunctionLoginBase:startSdkLogin(  ) Launch result:{0}", launchScs)
  local index = 1
  local eventMap = {}
  local callbackTimer
  FunctionTyrantdb.Instance:trackEvent("#SDKLoginStart", nil)
  if launchScs then
    if not BranchMgr.IsChina() then
      FunctionSDK.Instance:Login(function(sucMsg)
        Debug.Log("sdk login  sucMsg : " .. tostring(sucMsg))
        if sucMsg == nil or sucMsg == "" then
          Debug.Log("sdk login panel show 111")
          GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
            viewname = "SdkLoginPanel",
            data = callback
          })
        elseif callback then
          eventMap[index] = sucMsg
          if index == 1 and (BranchMgr.IsTW() or BranchMgr.IsKorea()) then
            OverSeas_TW.OverSeasManager.GetInstance():TrackEvent(AppBundleConfig.GetAdjustByName("sdkLogin"))
          end
          index = index + 1
          TimeTickManager.Me():ClearTick(self)
          callbackTimer = TimeTickManager.Me():CreateTick(200, 300000, function()
            callback(FunctionLogin.LoginCode.SdkLoginSuc, eventMap[#eventMap])
            TimeTickManager.Me():ClearTick(self)
            callbackTimer = nil
          end, self)
        end
      end, function(failMsg)
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "SdkLoginPanel",
          data = callback
        })
      end, function(failMsg)
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "SdkLoginPanel",
          data = callback
        })
      end)
    else
      FunctionSDK.Instance:Login(function(sucMsg)
        LogUtility.InfoFormat("startSdkLogin sucMsg:{0}", sucMsg)
        if callback then
          callback(FunctionLogin.LoginCode.SdkLoginSuc, sucMsg)
        end
      end, function(failMsg)
        if callback and failMsg ~= "自动登录失败" then
          callback(FunctionLogin.LoginCode.SdkLoginFailure, failMsg)
        end
      end, function(failMsg)
        if callback then
          callback(FunctionLogin.LoginCode.SdkLoginCancel, failMsg)
        end
      end)
    end
  else
    self:LaunchSdk(function(scuccess, msg)
      if scuccess then
        self:startSdkLogin(callback)
      else
        msg = msg and tostring(msg) or "null"
        LogUtility.Info("LoginFailure msg:" .. msg)
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
        MsgManager.ShowMsgByIDTable(1037, {
          FunctionLogin.ErrorCode.Login_SDKLaunchFailure,
          msg
        })
      end
    end)
  end
end

function FunctionLoginBase:createRole(name, role_sex, profession, hair, haircolor, clothcolor)
  haircolor = haircolor or 0
  bodycolor = bodycolor or 0
  name = tostring(name)
  role_sex = tonumber(role_sex) or 0
  profession = tonumber(profession) or 0
  hair = tonumber(hair) or 0
  haircolor = tonumber(haircolor) or 0
  clothcolor = tonumber(clothcolor) or 0
  ServiceLoginUserCmdProxy.Instance:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor)
end

function FunctionLoginBase:getLoginData()
  return self.loginData
end

function FunctionLoginBase:SetNormalLoginData(data)
  self.normalLoginData = data
end

function FunctionLoginBase:SetNoviceLoginData(data)
  self.noviceLoginData = data
end

function FunctionLoginBase:CopyLoginData(data)
  if not data then
    return
  end
  local copy = {}
  for k, v in pairs(data) do
    copy[k] = v
  end
  return copy
end

function FunctionLoginBase:SetLoginData()
  if not self.normalLoginData then
    self.loginData = self:CopyLoginData(self.noviceLoginData)
  elseif not self.noviceLoginData then
    self.loginData = self:CopyLoginData(self.normalLoginData)
  elseif self.noviceLoginData and self.normalLoginData then
    self.loginData = self:CopyLoginData(self.normalLoginData)
    if BranchMgr.IsNOEN() then
      if self.normalLoginData.default ~= 0 and self.noviceLoginData.default ~= 0 then
        self.loginData.default = self.normalLoginData.lastlogintm > self.noviceLoginData.lastlogintm and self.normalLoginData.default or self.noviceLoginData.default
      else
        self.loginData.default = self.normalLoginData.default ~= 0 and self.normalLoginData.default or self.noviceLoginData.default
      end
    elseif self.normalLoginData.accstate ~= 2 then
      self.loginData.default = self.noviceLoginData.default
    elseif self.normalLoginData.accstate == 2 and self.noviceLoginData.accstate == 2 then
      self.loginData.default = self.normalLoginData.lastlogintm > self.noviceLoginData.lastlogintm and self.normalLoginData.default or self.noviceLoginData.default
    end
    self.loginData.agreed = self.normalLoginData.agreed or self.noviceLoginData.agreed
  end
  if self.loginData then
    FunctionLogin.Me():setAgreeStatus(self.loginData.agreed)
    self:setDefaultServerData(self.loginData.default)
  end
end

function FunctionLoginBase:SetLoginDataByServerRegion(serverData)
  if self.loginData then
    local accid = tonumber(serverData.accid)
    self.loginData.accid = accid
    self.loginData.sha1 = serverData.sha1
    if not StringUtil.IsEmpty(serverData.timestamp) or serverData.timestamp == 0 then
      self.loginData.timestamp = serverData.timestamp
    end
    OverseaHostHelper.accId = accid
    FunctionGetIpStrategy.Me():setAccId(accid)
    GamePhoto.SetPlayerAccount(accid)
    self:SetExtraLoginData(serverData.loginData)
  end
end

function FunctionLoginBase:CheckIsActive(serverData)
  if serverData.servertype == "novice" and self.noviceLoginData then
    return self.noviceLoginData.isActivated
  elseif self.normalLoginData then
    return self.normalLoginData.isActivated
  else
    Debug.LogError("login error: servertype is unknow && nomallogindata nil!")
    return true
  end
end

function FunctionLoginBase:SetExtraLoginData(data)
  helplog("oneid:", data.oneid, self.loginData.oneid)
  self.loginData.flag = data.flag
  self.loginData.isActivated = data.isActivated
  self.loginData.uid = data.uid
  self.loginData.activePlayer = data.activePlayer and tonumber(data.activePlayer) or 1
  self.loginData.resourceReward = data.resourceReward
  if data.oneid and data.oneid ~= "" then
    self.loginData.oneid = data.oneid
  end
  FunctionLogin.Me():setPhoneNum(data.phone)
  FunctionLogin.Me():setSecurityParam(data.param)
  FunctionLogin.Me():setLoginSite(data.site)
  FunctionLogin.Me():setLogin_authoriz_state(data.authorize_state)
  OverseaHostHelper.langZone = data.lang_zone
  GamePhoto.SetPlayerSdkUid(self.loginData.uid)
end

function FunctionLoginBase:setLastLoginToken(token)
  self.lastLoginToken = token
end

function FunctionLoginBase:getServerDatas()
  return self.serverDatas
end

function FunctionLoginBase:setServerData(regions, loginData)
  if not self.serverDatas and regions then
    self.serverDatas = regions
    for i = 1, #self.serverDatas do
      local single = self.serverDatas[i]
      single.loginData = loginData
    end
  elseif regions then
    for i = 1, #regions do
      local single = regions[i]
      local sid = single.sid
      local has = false
      for j = 1, #self.serverDatas do
        local old = self.serverDatas[j]
        if old.sid == sid then
          has = true
          break
        end
      end
      single.loginData = loginData
      if not has then
        table.insert(self.serverDatas, single)
      end
    end
  end
  if self.serverDatas then
    table.sort(self.serverDatas, function(l, r)
      if l.serverid == r.serverid then
        if l.state == r.state then
          return l.sid < r.sid
        else
          return l.state < r.state
        end
      else
        return l.serverid > r.serverid
      end
    end)
    OverseaHostHelper.regions = self.serverDatas
  end
end

function FunctionLoginBase:ClearDefaultServerData()
  self.DefaultServerData = nil
end

function FunctionLoginBase:ClearLoginData()
  self.loginData = nil
  self.serverDatas = nil
end

function FunctionLoginBase:setDefaultServerData(default)
  helplog("FunctionLoginBase:setDefaultServerData", default)
  if default and self.serverDatas then
    if default == "" then
      self.DefaultServerData = self.serverDatas[1]
    else
      default = tostring(default)
      for i = 1, #self.serverDatas do
        local single = self.serverDatas[i]
        local sid = tostring(single.sid)
        if sid == default then
          self.DefaultServerData = single
          break
        end
      end
      if not self.DefaultServerData then
        self.DefaultServerData = self.serverDatas[1]
      end
    end
    FunctionGetIpStrategy.Me():setAccId(self.DefaultServerData.accid)
  end
  GameFacade.Instance:sendNotification(NewLoginEvent.UpdateServerList)
end

function FunctionLoginBase:getDefaultServerData()
  return self.DefaultServerData
end

function FunctionLoginBase:getSdkEnable()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return true
  else
    local SDKEnable = EnvChannel.SDKEnable()
    LogUtility.InfoFormat("SDKEnable:{0}", SDKEnable)
    return SDKEnable
  end
end

function FunctionLoginBase:getServerIp()
  return FunctionLogin.Me():getServerIp()
end

function FunctionLoginBase:getServerPort()
  return FunctionLogin.Me():getServerPort()
end

function FunctionLoginBase:getToken()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return FunctionLogin.Me().debugToken
  else
    local token
    token = FunctionSDK.Instance:GetAccessToken()
    if not token or token == "" then
      return nil
    else
      return token
    end
  end
end

function FunctionLoginBase:isLogined()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return true
  else
    return FunctionSDK.Instance:IsLogined()
  end
end

function FunctionLoginBase:isInitialized()
  return FunctionSDK.Instance.IsInitialized
end

function FunctionLoginBase:getSdkType()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return FunctionSDK.E_SDKType.XD
  else
    return FunctionSDK.Instance.CurrentType
  end
end

function FunctionLoginBase:replaceBracket(arg)
  return FunctionLogin.Me():replaceBracket(arg)
end

function FunctionLoginBase:checkIfNeedRetry(novice)
  if novice then
    return self.retryTime_Nov <= 3
  else
    local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
    if addresses and self.retryTime == #addresses then
      return false
    else
      return true
    end
  end
end

function FunctionLoginBase:resetRetryTime()
  self.retryTime = 0
  self.delayTime = 1
end

function FunctionLoginBase:HandleUrl(url, host)
  if not string.find(url, "http") then
    if string.find(host, "172.2") then
      url = string.format("http://%s", url)
    else
      url = string.format("https://%s", url)
    end
  end
  return url
end

function FunctionLoginBase:resetNovRetryTime()
  self.retryTime_Nov = 0
  self.delayTime_Nov = 1
end

local abSize_Script2

function FunctionLoginBase:getvd()
  if abSize_Script2 ~= nil then
    return abSize_Script2
  end
  local getScriptPath = function()
    return table.concat({
      ApplicationHelper.persistentDataPath,
      "/",
      ApplicationHelper.platformFolder,
      "/resources/script2/"
    })
  end
  local scriptFolderList = {
    "util.unity3d",
    "login.unity3d",
    "config_item_daoju.unity3d",
    "oversea.unity3d",
    "diskfilehandler.unity3d",
    "overseas.unity3d",
    "config_resource_ziyuan.unity3d",
    "envchannel.unity3d",
    "net.unity3d",
    "config_pay_zhifu.unity3d",
    "config_guild_gonghui.unity3d",
    "test.unity3d",
    "org.unity3d",
    "unionwallphoto.unity3d",
    "purchase.unity3d",
    "framework.unity3d",
    "mconfig.unity3d",
    "config_adventure_chengjiu_maoxian.unity3d",
    "config_hint_tishizhiyin.unity3d",
    "config_event_shijian.unity3d",
    "protocolstatistics.unity3d",
    "config.unity3d",
    "tablemathextension.unity3d",
    "config_npc_mowu.unity3d",
    "functionsystem.unity3d",
    "gmtool.unity3d",
    "itemswithrolestatuschange.unity3d",
    "personalphoto.unity3d",
    "config_text_wenben.unity3d",
    "config_pvp_jingjisai.unity3d",
    "config_skill_jineng.unity3d",
    "unionlogo.unity3d",
    "config_pet_suicong.unity3d",
    "main.unity3d",
    "config_marry_jiehun.unity3d",
    "config_map_fuben.unity3d",
    "config_property_zhiye_shuxing.unity3d",
    "refactory.unity3d",
    "marryphoto.unity3d",
    "com.unity3d",
    "gamephotoutil.unity3d",
    "scenicspotsphoto.unity3d",
    "config_equip_zhuangbei_kapian.unity3d"
  }
  local p = ApplicationHelper.platformFolder
  abSize_Script2 = p:sub(1, 1) .. "Q"
  for i = 1, #scriptFolderList do
    local path = getScriptPath() .. scriptFolderList[i]
    local file = io.open(getScriptPath() .. scriptFolderList[i], "r")
    if file then
      local singleSize = file:seek("end")
      abSize_Script2 = abSize_Script2 .. i .. "_" .. singleSize .. "Q"
      file:close()
    end
  end
  return abSize_Script2
end
