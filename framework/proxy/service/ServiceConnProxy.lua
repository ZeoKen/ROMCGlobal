local ServiceConnProxy = class("ServiceConnProxy", ServiceProxy)
ServiceConnProxy.Instance = nil
ServiceConnProxy.NAME = "ServiceConnProxy"

function ServiceConnProxy:ctor(proxyName)
  if ServiceConnProxy.Instance == nil then
    self.proxyName = proxyName or ServiceConnProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    ServiceConnProxy.Instance = self
    self:Init()
    self:ResetLoseHeartTime()
  end
end

function ServiceConnProxy:Init()
  self.isConnect = false
  self.stopCheckHeart = false
  self.checkHeartTime = 0
  self.checkHeartInterval = 15.0
  self.sendHeartTime = 0
  self.sendHeartInterval = 150
  self.recvHeartTime = nil
  self.loseHeartTime = 300
  self.maxLoseHeartTime = 900
  self.tryReconnectTime = 0
  self.tryReconnectInterval = 153.0
  self.hasPressHome = false
  self.leftTime = GameConfig.TimeOfHomeKey.TimeWithLogin
  self.homeStartTime = 0
  self.autoReconnect = true
end

function ServiceConnProxy:ResetLoseHeartTime()
  self.loseHeartTime = math.random(10, 15) * 30
end

function ServiceConnProxy:handleNotification(notification)
  if self.viewComponent ~= nil then
    return self.viewComponent:handleNotification(notification)
  end
end

function ServiceConnProxy:onRegister()
  NetManager.GameSetUpdate(function()
    self:SendHeart()
    self:CheckHeart()
  end)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(AppStateEvent.Pause, self.GamePaused, self)
end

function ServiceConnProxy:NetworkStateReset()
  self.isConnect = false
  self.recvHeartTime = nil
end

function ServiceConnProxy:TryReconnect()
  if self.isConnect then
    return
  end
  local time = UnityFrameCount
  local off = time - self.tryReconnectTime
  if off < self.tryReconnectInterval then
    return
  end
  self.tryReconnectTime = time
  LogUtility.Warning("ServiceConnProxy::TryReconnect!!!")
  self:NotifyNetDelay()
  ServiceUserProxy.Instance:IsReConnect(true)
  local loginData = FunctionLogin.Me():getLoginData()
  if loginData and ServerTime.CurServerTime() then
    local serverTime = ServerTime.CurServerTime() / 1000
    local timeOut = 82800
    local timestamp = tonumber(loginData.timestamp)
    if timeOut < serverTime - timestamp then
      FunctionLogin.Me():ClearLoginData()
    end
  end
  FunctionLogin.Me():reStartGameLogin(function()
    if not FunctionLogin.Me():getSdkEnable() then
      FunctionLogin.Me():LoginUserCmd()
    end
  end)
end

function ServiceConnProxy:UpdateSendHeartTime()
  self.sendHeartTime = UnityFrameCount
end

function ServiceConnProxy:SendHeart()
  if not self.isConnect then
    return
  end
  local time = UnityFrameCount
  local sendOff = time - self.sendHeartTime
  if sendOff > self.sendHeartInterval then
    local serverTime = ServerTime.CurServerTime()
    if serverTime then
      ServiceLoginUserCmdProxy.Instance:CallHeartBeatUserCmd(serverTime)
    end
  end
end

function ServiceConnProxy:RecvHeart()
  self.isConnect = true
  self.recvHeartTime = UnityFrameCount
end

function ServiceConnProxy:StopHeart()
  LogUtility.Info("ServiceConnProxy::StopHeart!!!")
  self.isConnect = false
  self.recvHeartTime = nil
  self.stopCheckHeart = true
  GmeVoiceProxy.Instance:ExitRoom()
  NetManager.GameDisConnect()
end

function ServiceConnProxy:CheckHeartStatus()
  self.stopCheckHeart = false
end

function ServiceConnProxy:CheckHeart()
  if self.recvHeartTime == nil or self.stopCheckHeart then
    return
  end
  local time = UnityFrameCount
  local off = time - self.checkHeartTime
  if off < self.checkHeartInterval then
    return
  end
  local recvOff = self.checkHeartTime - self.recvHeartTime
  self.checkHeartTime = time
  if recvOff > self.loseHeartTime and not self.hasPressHome then
    FunctionChangeScene.Me():SendTMCR()
    if self.autoReconnect then
      if self.isConnect then
        LogUtility.Warning("ServiceConnProxy--------CheckHeart netmanager gameclose")
        NetManager.GameDisConnect()
        self.isConnect = false
      end
      if recvOff > self.maxLoseHeartTime then
        self:NotifyNetDown()
      else
        self:TryReconnect()
      end
    end
  end
end

function ServiceConnProxy:NotifyNetDown()
  UIWarning.Instance:RestartEvt()
  self:Notify(ServiceEvent.ConnNetDown)
end

function ServiceConnProxy:NotifyNetDelay()
  UIWarning.Instance:WaitEvt()
  self:Notify(ServiceEvent.ConnNetDelay)
  local monitor = AppStateMonitor.Instance
  local hostInfo = FunctionGetIpStrategy.Me():getCurrentSocketInfo()
  if monitor and hostInfo and hostInfo.ip then
    pcall(function()
      if monitor.SendInfo then
        local s = "ip:" .. hostInfo.ip
        if hostInfo.domain then
          s = s .. ";domain:" .. hostInfo.domain
        end
        Debug.Log("netinfo:" .. s)
        monitor:SendInfo(s)
      end
    end)
  end
end

function ServiceConnProxy:NotifyReconnect()
  UIWarning.Instance:ReConnEvt()
  self:Notify(ServiceEvent.ConnReconnect)
  EventManager.Me():PassEvent(ServiceEvent.ConnReconnect)
  self:Notify(ServiceEvent.ReconnInit)
  self.stopCheckHeart = false
  self:ResetLoseHeartTime()
  GVoiceProxy.Instance:QuitVoice(nil)
end

function ServiceConnProxy:HandleConnect()
  self:Notify(ServiceEvent.ConnSuccess)
  UIWarning.Instance:HideBord()
end

function ServiceConnProxy:pressHomeKey()
end

function ServiceConnProxy:gameReActivie()
end

function ServiceConnProxy:GamePaused(note)
  local paused = note.data
  self.homeStartTime = 0
  if paused then
    self.homeStartTime = UnityFrameCount
    self.hasPressHome = true
    LogUtility.Info(string.format("pressHomeKey(  ):homeStartTime:%s,isConnect:%s", tostring(self.homeStartTime), tostring(self.isConnect)))
    FunctionTyrantdb.Instance:Stop()
  else
    self.hasPressHome = false
    FunctionTyrantdb.Instance:Resume()
    if not UnityFrameCount then
      return
    end
    local dtTime = UnityFrameCount - self.homeStartTime
    LogUtility.Info(string.format("gameReActivie(  ):hasPressHome:%s,homeStartTime:%s,dtTime:%s,isConnect:%s", tostring(self.hasPressHome), tostring(self.homeStartTime), tostring(dtTime), tostring(self.isConnect)))
    if dtTime >= self.leftTime and self.hasPressHome then
      self.homeStartTime = 0
      FunctionNetError.Me():ErrorBackToLogo()
    elseif dtTime < self.leftTime and self.hasPressHome and self.isConnect then
      self.recvHeartTime = UnityFrameCount
    end
  end
end

function ServiceConnProxy:IsConnect()
  return self.isConnect
end

return ServiceConnProxy
