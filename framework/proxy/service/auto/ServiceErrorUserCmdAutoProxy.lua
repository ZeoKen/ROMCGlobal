ServiceErrorUserCmdAutoProxy = class("ServiceErrorUserCmdAutoProxy", ServiceProxy)
ServiceErrorUserCmdAutoProxy.Instance = nil
ServiceErrorUserCmdAutoProxy.NAME = "ServiceErrorUserCmdAutoProxy"

function ServiceErrorUserCmdAutoProxy:ctor(proxyName)
  if ServiceErrorUserCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceErrorUserCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceErrorUserCmdAutoProxy.Instance = self
  end
end

function ServiceErrorUserCmdAutoProxy:Init()
end

function ServiceErrorUserCmdAutoProxy:onRegister()
  self:Listen(2, 1, function(data)
    self:RecvRegErrUserCmd(data)
  end)
  self:Listen(2, 2, function(data)
    self:RecvKickUserErrorCmd(data)
  end)
  self:Listen(2, 3, function(data)
    self:RecvMaintainUserCmd(data)
  end)
end

function ServiceErrorUserCmdAutoProxy:CallRegErrUserCmd(ret, accid, zoneID, charid, args, lockreason)
  if not NetConfig.PBC then
    local msg = ErrorUserCmd_pb.RegErrUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.ret = ret
    if accid ~= nil then
      msg.accid = accid
    end
    if zoneID ~= nil then
      msg.zoneID = zoneID
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if args ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.args == nil then
        msg.args = {}
      end
      for i = 1, #args do
        table.insert(msg.args, args[i])
      end
    end
    if lockreason ~= nil then
      msg.lockreason = lockreason
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RegErrUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.ret = ret
    if accid ~= nil then
      msgParam.accid = accid
    end
    if zoneID ~= nil then
      msgParam.zoneID = zoneID
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if args ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.args == nil then
        msgParam.args = {}
      end
      for i = 1, #args do
        table.insert(msgParam.args, args[i])
      end
    end
    if lockreason ~= nil then
      msgParam.lockreason = lockreason
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceErrorUserCmdAutoProxy:CallKickUserErrorCmd(accid)
  if not NetConfig.PBC then
    local msg = ErrorUserCmd_pb.KickUserErrorCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickUserErrorCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceErrorUserCmdAutoProxy:CallMaintainUserCmd(content, tip, picture)
  if not NetConfig.PBC then
    local msg = ErrorUserCmd_pb.MaintainUserCmd()
    if content ~= nil then
      msg.content = content
    end
    if tip ~= nil then
      msg.tip = tip
    end
    if picture ~= nil then
      msg.picture = picture
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MaintainUserCmd.id
    local msgParam = {}
    if content ~= nil then
      msgParam.content = content
    end
    if tip ~= nil then
      msgParam.tip = tip
    end
    if picture ~= nil then
      msgParam.picture = picture
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceErrorUserCmdAutoProxy:RecvRegErrUserCmd(data)
  self:Notify(ServiceEvent.ErrorUserCmdRegErrUserCmd, data)
end

function ServiceErrorUserCmdAutoProxy:RecvKickUserErrorCmd(data)
  self:Notify(ServiceEvent.ErrorUserCmdKickUserErrorCmd, data)
end

function ServiceErrorUserCmdAutoProxy:RecvMaintainUserCmd(data)
  self:Notify(ServiceEvent.ErrorUserCmdMaintainUserCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ErrorUserCmdRegErrUserCmd = "ServiceEvent_ErrorUserCmdRegErrUserCmd"
ServiceEvent.ErrorUserCmdKickUserErrorCmd = "ServiceEvent_ErrorUserCmdKickUserErrorCmd"
ServiceEvent.ErrorUserCmdMaintainUserCmd = "ServiceEvent_ErrorUserCmdMaintainUserCmd"
