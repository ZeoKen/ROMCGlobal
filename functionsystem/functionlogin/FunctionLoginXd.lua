autoImport("FunctionLoginBase")
FunctionLoginXd = class("FunctionLoginXd", FunctionLoginBase)

function FunctionLoginXd.Me()
  if nil == FunctionLoginXd.me then
    FunctionLoginXd.me = FunctionLoginXd.new()
  end
  return FunctionLoginXd.me
end

function FunctionLoginXd:RequestAuthAccToken(novice)
  local token = self:getToken()
  LogUtility.InfoFormat("FunctionLoginXd:RequestAuthAccToken token:{0}", token)
  Buglylog("FunctionLoginXd:RequestAuthAccToken")
  FunctionTyrantdb.Instance:trackEvent("#GameAuthVerifyStart", nil)
  if token then
    self:setLastLoginToken(token)
    if nil == novice or not novice then
      local url = self:GetAuthAccUrl(token)
      self:requestGetUrlHost(url, function(status, content)
        if self.hasHandleResp and self.hasHandleResp_Nov then
          GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        end
        self:LoginDataHandler(status, content, self.callback, false)
      end, nil, false)
    end
    if self:EnableNoviceServer() and (nil == novice or novice) then
      local url = self:GetAuthAccUrl(token, true)
      self:requestGetUrlHost(url, function(status, content)
        if self.hasHandleResp and self.hasHandleResp_Nov then
          GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        end
        self:LoginDataHandler(status, content, self.callback, true)
      end, NetConfig.AuthHostNovice[self:GetPlat()], true)
    end
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end

function FunctionLoginXd:startAuthAccessToken(callback)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
  self.callback = callback
  self:RequestAuthAccToken()
end

function FunctionLoginXd:startSdkGameLogin(callback)
  Buglylog("FunctionLoginXd:startSdkGameLogin")
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

function FunctionLoginXd:requestGetUrlHost(url, callback, host, novice)
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local appPreVersion = CompatibilityVersion.appPreVersion
  local timestamp = string.format("&timestamp=%s&phoneplat=%s&appPreVersion=%s", os.time(), phoneplat, appPreVersion)
  local order
  local finger_print = BuglyManager.GetInstance():GetOneidData()
  local form = WWWForm()
  form:AddField("finger_print", finger_print)
  local finalUrl
  if self.privateMode then
    host = NetConfig.PrivateAuthServerUrl
    finalUrl = string.format("http://%s%s%s", host, url, timestamp)
    LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost address url:{0}", finalUrl)
    order = HttpWWWRequestOrder(finalUrl, NetConfig.HttpRequestTimeOut, nil, false, true)
  elseif host and "" ~= host then
    finalUrl = string.format("%s%s%s", host, url, timestamp)
    finalUrl = self:HandleUrl(finalUrl, host)
    LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost address url:{0}", finalUrl)
    order = HttpWWWRequestOrder(finalUrl, NetConfig.HttpRequestTimeOut, form, false, true)
  else
    local addresses = FunctionGetIpStrategy.Me():getRequestAddresss()
    if not addresses then
      callback(FunctionLogin.AuthStatus.OherError)
      return
    end
    host = addresses[self.retryTime]
    host = host or addresses[1]
    finalUrl = string.format("%s%s%s", host, url, timestamp)
    finalUrl = self:HandleUrl(finalUrl, host)
    LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost url:{0}", finalUrl)
    order = HttpWWWRequestOrder(finalUrl, NetConfig.HttpRequestTimeOut, form, false, true)
  end
  if order then
    order:SetCallBacks(function(response)
      if novice then
        self.hasHandleResp_Nov = true
        self:resetNovRetryTime()
      else
        self:resetRetryTime()
        self.hasHandleResp = true
      end
      callback(NetConfig.ResponseCodeOk, response.resString, novice)
    end, function(order)
      self:RequestError(callback, order, finalUrl, novice)
    end, function(order)
      self:RequestError(callback, order, finalUrl, novice)
    end)
    if novice then
      self.hasHandleResp_Nov = false
    else
      self.hasHandleResp = false
    end
    Game.HttpWWWRequest:RequestByOrder(order)
  else
    callback(FunctionLogin.AuthStatus.OherError, nil, novice)
  end
end

function FunctionLoginXd:RequestError(callback, order, address, novice)
  if not novice and self.hasHandleResp then
    return
  elseif novice and self.hasHandleResp_Nov then
    return
  end
  if novice then
    self.hasHandleResp_Nov = true
  else
    self.hasHandleResp = true
  end
  if not order and not novice then
    self:resetRetryTime()
    callback(FunctionLogin.AuthStatus.OherError, nil, novice)
    return
  end
  if not order and novice then
    self:resetNovRetryTime()
    callback(FunctionLogin.AuthStatus.OherError, nil, novice)
    return
  end
  local IsOverTime = order.IsOverTime
  LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost IsOverTime:{0},requestUrl:{1}", IsOverTime, address)
  LogUtility.InfoFormat("FunctionLoginXd:requestGetUrlHost occur error,address:{0},errorMsg:{1}", address, order.orderError)
  if self.privateMode then
    self:resetRetryTime()
    self:resetNovRetryTime()
    callback(FunctionLogin.AuthStatus.OherError, nil, novice)
  elseif self:checkIfNeedRetry(novice) then
    self:startRetryRequsetAuth(novice)
    return
  else
    self:resetRetryTime()
    self:resetNovRetryTime()
    local errorCode = FunctionLogin.AuthStatus.OherError
    if nil ~= order then
      errorCode = order.errorWraper.ErrorCode
      local errorMsg = order.errorWraper.ErrorMessage
      helplog("RequestAuthAccToken lerrorMsg:", errorMsg)
    elseif IsOverTime then
      errorCode = FunctionLogin.AuthStatus.OverTime
    end
    callback(errorCode, nil, novice)
  end
end

function FunctionLoginXd:startRetryRequsetAuth(novice)
  if novice then
    self.retryTime_Nov = self.retryTime_Nov + 1
    self.delayTime_Nov = self.delayTime_Nov + math.random() * self.retryTime_Nov
    LogUtility.InfoFormat("FunctionLoginXd:startRetryRequsetAuth(  ) self.retryTime:{0},self.delayTime_Nov:{1}", self.retryTime_Nov, self.delayTime_Nov)
    if self.delayTime_Nov and self.delayTime_Nov > 0 then
      TimeTickManager.Me():CreateOnceDelayTick(self.delayTime_Nov * 1000, function(owner, deltaTime)
        self:RequestAuthAccToken(novice)
      end, self)
    else
      self:RequestAuthAccToken(novice)
    end
  else
    self.retryTime = self.retryTime + 1
    self.delayTime = self.delayTime + math.random() * self.retryTime
    LogUtility.InfoFormat("FunctionLoginXd:startRetryRequsetAuth(  ) self.retryTime:{0},self.delayTime:{1}", self.retryTime, self.delayTime)
    if self.delayTime and 0 < self.delayTime then
      TimeTickManager.Me():CreateOnceDelayTick(self.delayTime * 1000, function(owner, deltaTime)
        self:RequestAuthAccToken(novice)
      end, self)
    else
      self:RequestAuthAccToken(novice)
    end
  end
end
