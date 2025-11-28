ServiceQueueEnterCmdAutoProxy = class("ServiceQueueEnterCmdAutoProxy", ServiceProxy)
ServiceQueueEnterCmdAutoProxy.Instance = nil
ServiceQueueEnterCmdAutoProxy.NAME = "ServiceQueueEnterCmdAutoProxy"

function ServiceQueueEnterCmdAutoProxy:ctor(proxyName)
  if ServiceQueueEnterCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceQueueEnterCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceQueueEnterCmdAutoProxy.Instance = self
  end
end

function ServiceQueueEnterCmdAutoProxy:Init()
end

function ServiceQueueEnterCmdAutoProxy:onRegister()
  self:Listen(78, 3, function(data)
    self:RecvQueueEnterRetCmd(data)
  end)
  self:Listen(78, 4, function(data)
    self:RecvQueueUpdateCountCmd(data)
  end)
  self:Listen(78, 1, function(data)
    self:RecvRequireQueueNotifyCmd(data)
  end)
  self:Listen(78, 2, function(data)
    self:RecvReqQueueEnterCmd(data)
  end)
end

function ServiceQueueEnterCmdAutoProxy:CallQueueEnterRetCmd(stop, waitnum, etype)
  if not NetConfig.PBC then
    local msg = QueueEnterCmd_pb.QueueEnterRetCmd()
    if stop ~= nil then
      msg.stop = stop
    end
    if waitnum ~= nil then
      msg.waitnum = waitnum
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueueEnterRetCmd.id
    local msgParam = {}
    if stop ~= nil then
      msgParam.stop = stop
    end
    if waitnum ~= nil then
      msgParam.waitnum = waitnum
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQueueEnterCmdAutoProxy:CallQueueUpdateCountCmd(dec_num, etype)
  if not NetConfig.PBC then
    local msg = QueueEnterCmd_pb.QueueUpdateCountCmd()
    if dec_num ~= nil then
      msg.dec_num = dec_num
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueueUpdateCountCmd.id
    local msgParam = {}
    if dec_num ~= nil then
      msgParam.dec_num = dec_num
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQueueEnterCmdAutoProxy:CallRequireQueueNotifyCmd(etype)
  if not NetConfig.PBC then
    local msg = QueueEnterCmd_pb.RequireQueueNotifyCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RequireQueueNotifyCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQueueEnterCmdAutoProxy:CallReqQueueEnterCmd(stop, etype)
  if not NetConfig.PBC then
    local msg = QueueEnterCmd_pb.ReqQueueEnterCmd()
    if stop ~= nil then
      msg.stop = stop
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqQueueEnterCmd.id
    local msgParam = {}
    if stop ~= nil then
      msgParam.stop = stop
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQueueEnterCmdAutoProxy:RecvQueueEnterRetCmd(data)
  self:Notify(ServiceEvent.QueueEnterCmdQueueEnterRetCmd, data)
end

function ServiceQueueEnterCmdAutoProxy:RecvQueueUpdateCountCmd(data)
  self:Notify(ServiceEvent.QueueEnterCmdQueueUpdateCountCmd, data)
end

function ServiceQueueEnterCmdAutoProxy:RecvRequireQueueNotifyCmd(data)
  self:Notify(ServiceEvent.QueueEnterCmdRequireQueueNotifyCmd, data)
end

function ServiceQueueEnterCmdAutoProxy:RecvReqQueueEnterCmd(data)
  self:Notify(ServiceEvent.QueueEnterCmdReqQueueEnterCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.QueueEnterCmdQueueEnterRetCmd = "ServiceEvent_QueueEnterCmdQueueEnterRetCmd"
ServiceEvent.QueueEnterCmdQueueUpdateCountCmd = "ServiceEvent_QueueEnterCmdQueueUpdateCountCmd"
ServiceEvent.QueueEnterCmdRequireQueueNotifyCmd = "ServiceEvent_QueueEnterCmdRequireQueueNotifyCmd"
ServiceEvent.QueueEnterCmdReqQueueEnterCmd = "ServiceEvent_QueueEnterCmdReqQueueEnterCmd"
