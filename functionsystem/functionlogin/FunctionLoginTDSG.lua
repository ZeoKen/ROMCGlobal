autoImport("FunctionLoginBase")
FunctionLoginTDSG = class("FunctionLoginTDSG", FunctionLoginBase)

function FunctionLoginTDSG.Me()
  if nil == FunctionLoginTDSG.me then
    FunctionLoginTDSG.me = FunctionLoginTDSG.new()
  end
  return FunctionLoginTDSG.me
end

function FunctionLoginTDSG:startSdkGameLogin(callback)
  LogUtility.InfoFormat("startSdkGameLogin:isLogined:{0}", self:isLogined())
  local isLogined = self:isLogined()
  if not isLogined then
    self:startSdkLogin(function(code, msg)
      self:SdkLoginHandler(code, msg, function()
        self:startAuthAccessToken(function()
          if callback then
            callback()
          end
        end)
      end)
    end)
  elseif not self.loginData then
    self:startAuthAccessToken(function()
      if callback then
        callback()
      end
    end)
  elseif callback then
    callback()
  end
end

function FunctionLoginTDSG:startAuthAccessToken(callback)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
  self.callback = callback
  self:RequestAuthAccToken()
end

function FunctionLoginTDSG:requestRegistUrlHost(url, callback, host, privateMode)
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local timestamp = os.time()
  timestamp = string.format("&timestamp=%s&phoneplat=%s", timestamp, phoneplat)
  local requests = HttpWWWSeveralRequests()
  local finalUrl
  if privateMode or self.privateMode then
    host = NetConfig.PrivateAuthServerUrl
    finalUrl = string.format("%s%s%s", host, url, timestamp)
    finalUrl = self:HandleUrl(finalUrl, host)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost host url:{0}", finalUrl)
    local order = HttpWWWRequestOrder(finalUrl, NetConfig.HttpRequestTimeOut, nil, false, true)
    requests:AddOrder(order)
  elseif host and "" ~= host then
    finalUrl = string.format("%s%s%s", host, url, timestamp)
    finalUrl = self:HandleUrl(finalUrl, host)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost host url:{0}", finalUrl)
    local order = HttpWWWRequestOrder(finalUrl, NetConfig.HttpRequestTimeOut, nil, false, true)
  else
    local ips = FunctionGetIpStrategy.Me():getRequestAddresss()
    for i = 1, #ips do
      host = ips[i]
      finalUrl = string.format("%s%s%s", host, url, timestamp)
      finalUrl = self:HandleUrl(finalUrl, host)
      LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost url:{0}", finalUrl)
      local order = HttpWWWRequestOrder(finalUrl, NetConfig.HttpRequestTimeOut, nil, false, true)
      requests:AddOrder(order)
    end
  end
  requests:SetCallBacks(function(response)
    callback(NetConfig.ResponseCodeOk, response.resString)
  end, function(order)
    local IsOverTime = order.IsOverTime
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost IsOverTime:{0}", IsOverTime)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost occur error,url:{0},host:{1},errorMsg:{2}", finalUrl, host, order.orderError)
    callback(FunctionLogin.AuthStatus.OherError, order)
  end)
  requests:StartRequest()
end

function FunctionLoginTDSG:GetRegistUrl(token, serverData)
  local authUrl = NetConfig.GetAccDataAddress
  local version = self:getServerVersion()
  local plat = self:GetPlat()
  local sid = serverData.sid
  local clientCode = CompatibilityVersion.version
  local vd = self:getvd()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    clientCode = FunctionLogin.Me().debugClientCode
  end
  local url = string.format("%s%s&plat=%s&version=%s&clientCode=%s&vd=%s&sid=%s", authUrl, token, plat, version, clientCode, vd, sid)
  return url
end

function FunctionLoginTDSG:GetTDSG_UserInfo()
  return ""
end

function FunctionLoginTDSG:GetTDSG_MacKey()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    return FunctionLogin.Me().debugToken
  else
    local macKey = FunctionSDK.Instance:GetMacKey()
    helplog("tdsg macKey ", tostring(macKey))
    if not macKey or macKey == "" then
      return nil
    else
      return macKey
    end
  end
end

function FunctionLoginTDSG:GetTDSG_ClientID()
  local BundleID = AppBundleConfig.BundleID
  return AppBundleConfig.TDSG_Config[BundleID] or ""
end

function FunctionLoginTDSG:requestAuthGetUrlHost()
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local appPreVersion = CompatibilityVersion.appPreVersion
  local accToken = self:getToken()
  Debug.LogFormat("getToken accToken : {0}", tostring(accToken))
  local version = self:getServerVersion()
  local plat = self:GetPlat()
  local clientCode = CompatibilityVersion.version
  local macKey = self:GetTDSG_MacKey()
  local old_deviceId = self:GetOld_DeviceID()
  local new_deviceId = self:GetNew_DeviceID()
  local hosts = NetConfig.NewAccessTokenAuthHost or {}
  local hostCount = #hosts
  if hostCount == 0 then
    helplog("FunctionLoginTDSG:requestAuthGetUrlHost NewAccessTokenAuthHost is empty")
    self.hasHandleResp = true
    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
    self:LoginDataHandler(FunctionLogin.AuthStatus.OherError, "", self.callback)
    return
  end
  
  local function doRequest(hostIndex, lastErrorCode)
    local host = hosts[hostIndex]
    if not host or host == "" then
      helplog("FunctionLoginTDSG:requestAuthGetUrlHost invalid host index:", hostIndex)
      if hostIndex < hostCount then
        doRequest(hostIndex + 1, lastErrorCode)
      else
        self.hasHandleResp = true
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(lastErrorCode or FunctionLogin.AuthStatus.OherError, "", self.callback)
      end
      return
    end
    local url = string.format("%s/auth?sid=%s&p=%s&sver=%s&cver=%s&client_id=%s&mac_key=%s&lang=%s", host, accToken, plat, version, clientCode, self:GetTDSG_ClientID(), macKey, ApplicationInfo.GetSystemLanguage())
    url = string.format("%s&old_deviceid=%s&new_deviceid=%s", url, old_deviceId, new_deviceId)
    url = string.format("%s&appPreVersion=%s&phoneplat=%s", url, appPreVersion, phoneplat)
    url = string.format("%s&ver=6.x", url)
    url = self:HandleUrl(url, host)
    local finger_print = BuglyManager.GetInstance():GetOneidData()
    local form = WWWForm()
    form:AddField("finger_print", finger_print)
    OverseaHostHelper.lastAuthUrl = url
    helplog(" RequestAuthAccToken url ", url, hostIndex)
    local order = HttpWWWRequestOrder(url, NetConfig.HttpRequestTimeOut, form, false, true)
    if order then
      self.hasHandleResp = false
      order:SetCallBacks(function(response)
        self.hasHandleResp = true
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(NetConfig.ResponseCodeOk, response.resString, self.callback)
      end, function(order)
        helplog("FunctionLoginTDSG:requestAuthGetUrlHost timeout, hostIndex:", hostIndex, " host:", tostring(host))
        local errorCode = FunctionLogin.AuthStatus.OverTime
        if hostIndex < hostCount then
          doRequest(hostIndex + 1, errorCode)
        else
          self.hasHandleResp = true
          GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
          self:LoginDataHandler(errorCode, "", self.callback)
        end
      end, function(order)
        local errorCode = FunctionLogin.AuthStatus.OherError
        if nil ~= order and order.errorWraper then
          errorCode = order.errorWraper.ErrorCode
          local errorMsg = order.errorWraper.ErrorMessage
          helplog("RequestAuthAccToken lerrorMsg:", errorMsg, " hostIndex:", hostIndex, " host:", tostring(host))
        else
          helplog("RequestAuthAccToken unknown error, hostIndex:", hostIndex, " host:", tostring(host))
        end
        if hostIndex < hostCount then
          doRequest(hostIndex + 1, errorCode)
        else
          self.hasHandleResp = true
          GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
          self:LoginDataHandler(errorCode, "", self.callback)
        end
      end)
      Game.HttpWWWRequest:RequestByOrder(order)
    else
      helplog("FunctionLoginTDSG:requestAuthGetUrlHost create order failed, hostIndex:", hostIndex, " host:", tostring(host))
      local errorCode = lastErrorCode or FunctionLogin.AuthStatus.OherError
      if hostIndex < hostCount then
        doRequest(hostIndex + 1, errorCode)
      else
        self.hasHandleResp = true
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(errorCode, "", self.callback)
      end
    end
  end
  
  doRequest(1, nil)
end

function FunctionLoginTDSG:RequestAuthAccToken()
  FunctionTyrantdb.Instance:trackEvent("#GameAuthVerifyStart", nil)
  local accToken = self:getToken()
  if accToken then
    OverseaHostHelper:RefreshPriceInfo()
    self:requestAuthGetUrlHost()
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
