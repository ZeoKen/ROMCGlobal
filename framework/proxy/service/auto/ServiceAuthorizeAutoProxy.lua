ServiceAuthorizeAutoProxy = class("ServiceAuthorizeAutoProxy", ServiceProxy)
ServiceAuthorizeAutoProxy.Instance = nil
ServiceAuthorizeAutoProxy.NAME = "ServiceAuthorizeAutoProxy"

function ServiceAuthorizeAutoProxy:ctor(proxyName)
  if ServiceAuthorizeAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAuthorizeAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAuthorizeAutoProxy.Instance = self
  end
end

function ServiceAuthorizeAutoProxy:Init()
end

function ServiceAuthorizeAutoProxy:onRegister()
  self:Listen(62, 1, function(data)
    self:RecvSetAuthorizeUserCmd(data)
  end)
  self:Listen(62, 2, function(data)
    self:RecvResetAuthorizeUserCmd(data)
  end)
  self:Listen(62, 3, function(data)
    self:RecvSyncAuthorizeToSession(data)
  end)
  self:Listen(62, 4, function(data)
    self:RecvNotifyAuthorizeUserCmd(data)
  end)
  self:Listen(62, 5, function(data)
    self:RecvSyncRealAuthorizeToSession(data)
  end)
end

function ServiceAuthorizeAutoProxy:CallSetAuthorizeUserCmd(password, oldpwd)
  if not NetConfig.PBC then
    local msg = Authorize_pb.SetAuthorizeUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.password = password
    if oldpwd ~= nil then
      msg.oldpwd = oldpwd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetAuthorizeUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.password = password
    if oldpwd ~= nil then
      msgParam.oldpwd = oldpwd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuthorizeAutoProxy:CallResetAuthorizeUserCmd(reset)
  if not NetConfig.PBC then
    local msg = Authorize_pb.ResetAuthorizeUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.reset = reset
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResetAuthorizeUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.reset = reset
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuthorizeAutoProxy:CallSyncAuthorizeToSession(ignorepwd, password, resettime)
  if not NetConfig.PBC then
    local msg = Authorize_pb.SyncAuthorizeToSession()
    if ignorepwd ~= nil then
      msg.ignorepwd = ignorepwd
    end
    if password ~= nil then
      msg.password = password
    end
    if resettime ~= nil then
      msg.resettime = resettime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncAuthorizeToSession.id
    local msgParam = {}
    if ignorepwd ~= nil then
      msgParam.ignorepwd = ignorepwd
    end
    if password ~= nil then
      msgParam.password = password
    end
    if resettime ~= nil then
      msgParam.resettime = resettime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuthorizeAutoProxy:CallNotifyAuthorizeUserCmd()
  if not NetConfig.PBC then
    local msg = Authorize_pb.NotifyAuthorizeUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NotifyAuthorizeUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuthorizeAutoProxy:CallSyncRealAuthorizeToSession(authorized)
  if not NetConfig.PBC then
    local msg = Authorize_pb.SyncRealAuthorizeToSession()
    if authorized ~= nil then
      msg.authorized = authorized
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncRealAuthorizeToSession.id
    local msgParam = {}
    if authorized ~= nil then
      msgParam.authorized = authorized
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuthorizeAutoProxy:RecvSetAuthorizeUserCmd(data)
  self:Notify(ServiceEvent.AuthorizeSetAuthorizeUserCmd, data)
end

function ServiceAuthorizeAutoProxy:RecvResetAuthorizeUserCmd(data)
  self:Notify(ServiceEvent.AuthorizeResetAuthorizeUserCmd, data)
end

function ServiceAuthorizeAutoProxy:RecvSyncAuthorizeToSession(data)
  self:Notify(ServiceEvent.AuthorizeSyncAuthorizeToSession, data)
end

function ServiceAuthorizeAutoProxy:RecvNotifyAuthorizeUserCmd(data)
  self:Notify(ServiceEvent.AuthorizeNotifyAuthorizeUserCmd, data)
end

function ServiceAuthorizeAutoProxy:RecvSyncRealAuthorizeToSession(data)
  self:Notify(ServiceEvent.AuthorizeSyncRealAuthorizeToSession, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.AuthorizeSetAuthorizeUserCmd = "ServiceEvent_AuthorizeSetAuthorizeUserCmd"
ServiceEvent.AuthorizeResetAuthorizeUserCmd = "ServiceEvent_AuthorizeResetAuthorizeUserCmd"
ServiceEvent.AuthorizeSyncAuthorizeToSession = "ServiceEvent_AuthorizeSyncAuthorizeToSession"
ServiceEvent.AuthorizeNotifyAuthorizeUserCmd = "ServiceEvent_AuthorizeNotifyAuthorizeUserCmd"
ServiceEvent.AuthorizeSyncRealAuthorizeToSession = "ServiceEvent_AuthorizeSyncRealAuthorizeToSession"
