PushProxy = class("PushProxy", pm.Proxy)
PushProxy.Instance = nil
PushProxy.NAME = "PushProxy"

function PushProxy:DebugLog(msg)
  if self:IsThisFuncForbid() then
    return
  end
  if false then
    LogUtility.Info("-------PushProxy-----------:::" .. msg)
  end
end

function PushProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PushProxy.NAME
  if PushProxy.Instance == nil then
    PushProxy.Instance = self
    self:Init()
    self:AddEvts()
  end
  if data ~= nil then
    self:setData(data)
  end
end

function PushProxy:IsThisFuncForbid()
end

function PushProxy:Init()
  if self:IsThisFuncForbid() then
    return
  end
  self:DebugLog("function PushProxy:Init()")
  
  function ROPushReceiver.Instance._OnReceiveNotification(msg)
    self:DebugLog("_OnReceiveNotification:" .. msg)
  end
  
  function ROPushReceiver.Instance._OnReceiveMessage(msg)
    self:DebugLog("_OnReceiveMessage" .. msg)
  end
  
  function ROPushReceiver.Instance._OnOpenNotification(msg)
    self:DebugLog("_OnOpenNotification" .. msg)
  end
  
  function ROPushReceiver.Instance._OnJPushTagOperateResult(msg)
    self:DebugLog("_OnJPushTagOperateResult" .. msg)
  end
  
  function ROPushReceiver.Instance._OnJPushAliasOperateResult(msg)
    self:DebugLog("_OnJPushAliasOperateResult" .. msg)
  end
  
  if ApplicationInfo.IsRunOnEditor() then
    self:DebugLog("编辑器模式 无法使用jpush")
    return
  end
  if not BranchMgr.IsChina() then
    return
  end
  if ROPush.hasInit == false then
    ROPush.StopPush()
  end
end

function PushProxy:AddEvts()
  if self:IsThisFuncForbid() then
    return
  end
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(AppStateEvent.Pause, self.OnPause, self)
end

function PushProxy:OnPause(note)
  if self:IsThisFuncForbid() then
    return
  end
  local paused = note.data
  if paused then
    self:DebugLog("paused ")
  else
    self:DebugLog("paused ~= return")
  end
  if ROPush.hasInit then
    if paused then
      ROPush.ResumePush()
    else
      ROPush.StopPush()
    end
  end
end

function PushProxy:SetTags(k, v)
  if self:IsThisFuncForbid() then
    return
  end
  ROPush.SetTags(k, v)
end

function PushProxy.InitPushModule()
  if GameConfig.SystemForbid and GameConfig.SystemForbid.OpenPushFunc then
  else
    local channelConfig = EnvChannel.ChannelConfig
    ROPush.Init("JPushBinding")
    ROPush.SetDebug(envChannel == channelConfig.Develop.Name or envChannel == channelConfig.Studio.Name)
    ROPush.ResetBadge()
    ROPush.SetApplicationIconBadgeNumber(0)
  end
end

return PushProxy
