FunctionLoginAnnounce = class("FunctionLoginAnnounce")
FunctionLoginAnnounce.IsAnnounced = "FunctionLoginAnnounce_IsAnnounced"

function FunctionLoginAnnounce.Me()
  if nil == FunctionLoginAnnounce.me then
    FunctionLoginAnnounce.me = FunctionLoginAnnounce.new()
  end
  return FunctionLoginAnnounce.me
end

function FunctionLoginAnnounce:ctor()
  self.hasShowedAnnouncement = false
  self.newServerAnnouncement = nil
end

function FunctionLoginAnnounce:showNewServerAnnouncement()
  self:showAnnouncement(self.newServerAnnouncement)
end

function FunctionLoginAnnounce:tryShowNewServerAnnouncement()
  local loginData = FunctionLogin.Me():getLoginData()
  local hasNewServer = FunctionLogin.Me():HasNewServer()
  if not loginData or loginData.accstate == FunctionLogin.AccountState.Activate or not hasNewServer then
    return
  end
  self:doShowAnnouncement()
end

function FunctionLoginAnnounce:doShowAnnouncement()
  if self.newServerAnnouncement then
    self:showAnnouncement(self.newServerAnnouncement)
  else
    self:requestNewServerAnnouncement()
  end
end

function FunctionLoginAnnounce:requestNewServerAnnouncement()
  redlog("newServerAnnouncement", tostring(self.newServerAnnouncement))
  if self.newServerAnnouncement then
    return
  end
  local address = NetConfig.AnnounceAddress
  local url = "https://%s/%s"
  local fileName = "newserver.txt"
  url = string.format(url, address, fileName)
  self:doRequest(url, function(status, content)
    redlog("doRequest callback", tostring(status))
    if status == NetConfig.ResponseCodeOk then
      self:parseNewServerAnnouncement(content)
      self:showAnnouncement(self.newServerAnnouncement)
    end
    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
  end)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
end

function FunctionLoginAnnounce:requestAnnouncemenEndTime()
  local address = NetConfig.AnnounceAddress
  local url = "https://%s/%s"
  local timestamp = os.time()
  local functionSDK = FunctionLogin.Me():getFunctionSdk()
  if not functionSDK then
    helplog("没有SDK")
    return
  end
  local plat = functionSDK:GetPlat()
  local channelId = "1"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    channelId = "2"
  end
  local fileName = "%s-%s.json"
  fileName = string.format(fileName, plat, channelId, timestamp)
  url = string.format(url, address, fileName)
  self:doRequest(url, function(status, content)
    local result = self:tryParseStrToJson(content)
    local endT = result and result["end"]
    if endT and endT ~= "" then
      endT = tonumber(endT)
      local announceTime = LocalSaveProxy.Instance:GetLastAnnouncementEndTime() or 0
      if announceTime ~= endT then
        LocalSaveProxy.Instance:SetLastAnnouncementEndTime(endT)
        self.isAnnounced = true
        GameFacade.Instance:sendNotification(NewLoginEvent.RequestNewServerInfo)
      end
    end
  end)
end

function FunctionLoginAnnounce:parseNewServerAnnouncement(content)
  local result = self:tryParseStrToJson(content)
  if result then
    self.newServerAnnouncement = result
  end
end

function FunctionLoginAnnounce:requestAnnouncement()
  if self.hasShowedAnnouncement then
    FunctionLogin.Me():launchAndLoginSdk()
    return
  end
  local address = NetConfig.AnnounceAddress
  local url = "https://%s/%s"
  local timestamp = os.time()
  local plat = FunctionLogin.Me():getFunctionSdk():GetPlat()
  local channelId = "1"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    channelId = "2"
  end
  local fileName = "%s-%s.json"
  fileName = string.format(fileName, plat, channelId, timestamp)
  url = string.format(url, address, fileName)
  self:doRequest(url, function(status, content)
    self:announceHandle(status, content)
    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
  end)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
end

function FunctionLoginAnnounce:doRequest(url, callback)
  LogUtility.Info("FunctionLogin:requestGetUrlHost address url:" .. url)
  Game.WWWRequestManager:SimpleRequest(url, 5, function(www)
    self.hasHandleRes = true
    if not www.downloadHandler then
      callback(FunctionLogin.AuthStatus.OherError, www.error)
      return
    end
    local content = www.downloadHandler.text
    local date = www:GetResponseHeader("Date")
    local p = "%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) GMT"
    local day, month, year, hour, min, sec = date:match(p)
    local MON = {
      Jan = 1,
      Feb = 2,
      Mar = 3,
      Apr = 4,
      May = 5,
      Jun = 6,
      Jul = 7,
      Aug = 8,
      Sep = 9,
      Oct = 10,
      Nov = 11,
      Dec = 12
    }
    local month = MON[month]
    local curTime = os.time({
      day = day,
      month = month,
      year = year,
      hour = hour,
      min = min,
      sec = sec
    })
    self.curTime = curTime
    callback(NetConfig.ResponseCodeOk, content)
    LogUtility.Info("FunctionLoginAnnounce:requestGetUrlHost success:" .. tostring(content))
  end, function(www, error)
    redlog("Game.WWWRequestManager:SimpleRequest failCall", tostring(self.hasHandleRes))
    if self.hasHandleRes then
      return
    end
    self.hasHandleRes = true
    callback(FunctionLogin.AuthStatus.OherError, error)
    LogUtility.Info("FunctionLoginAnnounce:requestGetUrlHost error:" .. tostring(error))
  end, function(www)
    redlog("Game.WWWRequestManager:SimpleRequest overtimeCall", tostring(self.hasHandleRes))
    if self.hasHandleRes then
      return
    end
    self.hasHandleRes = true
    callback(FunctionLogin.AuthStatus.OverTime)
    LogUtility.Info("FunctionLoginAnnounce:requestGetUrlHost OverTime")
  end)
  self.hasHandleRes = false
end

function FunctionLoginAnnounce:announceHandle(status, content)
  if status == NetConfig.ResponseCodeOk then
    self:doAnnounce(content)
  elseif status ~= NetConfig.ResponseCodeOk then
    FunctionLogin.Me():launchAndLoginSdk()
  end
end

function FunctionLoginAnnounce:checkTimeValid(startT, endT)
  local result = false
  local isCall = pcall(function(i)
    startT = tonumber(startT)
    endT = tonumber(endT)
    local timeStr1 = os.date("%Y-%m-%d %H:%M:%S", startT)
    local timeStr2 = os.date("%Y-%m-%d %H:%M:%S", endT)
    local timeStr3 = os.date("%Y-%m-%d %H:%M:%S", self.curTime)
    LogUtility.InfoFormat("checkTimeValid startT:{0},endT:{1},curTime:{2}", timeStr1, timeStr2, timeStr3)
    if self.curTime and self.curTime >= startT and self.curTime <= endT then
      result = true
    end
  end)
  return isCall and result
end

function FunctionLoginAnnounce:tryParseStrToJson(content)
  local result
  local isCall = pcall(function(i)
    result = StringUtil.Json2Lua(content)
    if nil == result then
      result = json.decode(content)
    end
  end)
  return result
end

function FunctionLoginAnnounce:doAnnounce(content)
  local result = self:tryParseStrToJson(content)
  local callback = function()
    FunctionLogin.Me():launchAndLoginSdk()
  end
  if result then
    local valid = self:showAnnouncement(result, callback)
    if valid then
      self.hasShowedAnnouncement = true
    end
  else
    callback()
  end
end

function FunctionLoginAnnounce:showAnnouncement(result, callback)
  if not result then
    return
  end
  local msg = result.msg
  local tips = result.tips
  local picURL = result.picture
  local startT = result.startTime
  local endT = result.endTime
  local valid = self:checkTimeValid(startT, endT)
  local contentValid = msg and msg ~= "" or tips and tips ~= "" or picURL and picURL ~= ""
  if contentValid and valid then
    FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, msg, tips, ZhString.ServiceErrorUserCmdProxy_Confirm, picURL, callback)
    return true
  elseif callback then
    callback()
  end
end

function FunctionLoginAnnounce:showCDNAnnounce()
  local address = NetConfig.AnnounceAddress
  local url = "https://%s/%s"
  local timestamp = os.time()
  local plat = FunctionLogin.Me():getFunctionSdk():GetPlat()
  local channelId = "1"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    channelId = "2"
  end
  local fileName = "%s-%s.json?timestamp=%s"
  fileName = string.format(fileName, plat, channelId, timestamp)
  url = string.format(url, address, fileName)
  Debug.Log("showCDNAnnounce:" .. url)
  self:doRequest(url, function(status, content)
    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
    self:handleCDNAnnounce(status, content)
  end)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
end

function FunctionLoginAnnounce:handleCDNAnnounce(status, content)
  if status == NetConfig.ResponseCodeOk then
    self:doCDNAnnounce(content)
  elseif status ~= NetConfig.ResponseCodeOk then
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.LoginAnnounceError
    })
  end
end

function FunctionLoginAnnounce:doCDNAnnounce(content)
  local result
  local isCall = pcall(function(i)
    result = StringUtil.Json2Lua(content)
    if result == nil then
      result = json.decode(content)
    end
  end)
  if result then
    local msg, tips, picURL, startT, endT
    if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
      local realData = result[ApplicationInfo.GetSystemLanguage()] ~= nil and result[ApplicationInfo.GetSystemLanguage()] or result["10"]
      msg = realData.msg
      msg = string.gsub(msg, "\\n", "\n")
      tips = realData.tips
      picURL = realData.picture
      startT = result.start
      endT = result["end"]
    else
      msg = result.msg
      tips = result.tips
      picURL = result.picture
      startT = result.startTime
      endT = result.endTime
    end
    local valid = self:checkTimeValid(startT, endT)
    local contentValid = msg and msg ~= "" or tips and tips ~= "" or picURL and picURL ~= ""
    if contentValid and valid then
      FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, msg, tips, ZhString.ServiceErrorUserCmdProxy_Confirm, picURL, function()
      end)
    else
      MsgManager.ShowMsgByIDTable(1017, {
        FunctionLogin.ErrorCode.InvalidServerIP
      })
    end
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.LoginAnnounceFormatError
    })
  end
end
