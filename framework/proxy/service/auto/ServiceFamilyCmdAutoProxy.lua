ServiceFamilyCmdAutoProxy = class("ServiceFamilyCmdAutoProxy", ServiceProxy)
ServiceFamilyCmdAutoProxy.Instance = nil
ServiceFamilyCmdAutoProxy.NAME = "ServiceFamilyCmdAutoProxy"

function ServiceFamilyCmdAutoProxy:ctor(proxyName)
  if ServiceFamilyCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceFamilyCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceFamilyCmdAutoProxy.Instance = self
  end
end

function ServiceFamilyCmdAutoProxy:Init()
end

function ServiceFamilyCmdAutoProxy:onRegister()
  self:Listen(234, 1, function(data)
    self:RecvClueDataNtfFamilyCmd(data)
  end)
  self:Listen(234, 2, function(data)
    self:RecvClueUnlockFamilyCmd(data)
  end)
  self:Listen(234, 3, function(data)
    self:RecvClueRewardFamilyCmd(data)
  end)
end

function ServiceFamilyCmdAutoProxy:CallClueDataNtfFamilyCmd(datas)
  if not NetConfig.PBC then
    local msg = FamilyCmd_pb.ClueDataNtfFamilyCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClueDataNtfFamilyCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFamilyCmdAutoProxy:CallClueUnlockFamilyCmd(id, data)
  if not NetConfig.PBC then
    local msg = FamilyCmd_pb.ClueUnlockFamilyCmd()
    if id ~= nil then
      msg.id = id
    end
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.state = data.state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClueUnlockFamilyCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.state = data.state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFamilyCmdAutoProxy:CallClueRewardFamilyCmd(id, data)
  if not NetConfig.PBC then
    local msg = FamilyCmd_pb.ClueRewardFamilyCmd()
    if id ~= nil then
      msg.id = id
    end
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.state = data.state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClueRewardFamilyCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.state = data.state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceFamilyCmdAutoProxy:RecvClueDataNtfFamilyCmd(data)
  self:Notify(ServiceEvent.FamilyCmdClueDataNtfFamilyCmd, data)
end

function ServiceFamilyCmdAutoProxy:RecvClueUnlockFamilyCmd(data)
  self:Notify(ServiceEvent.FamilyCmdClueUnlockFamilyCmd, data)
end

function ServiceFamilyCmdAutoProxy:RecvClueRewardFamilyCmd(data)
  self:Notify(ServiceEvent.FamilyCmdClueRewardFamilyCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.FamilyCmdClueDataNtfFamilyCmd = "ServiceEvent_FamilyCmdClueDataNtfFamilyCmd"
ServiceEvent.FamilyCmdClueUnlockFamilyCmd = "ServiceEvent_FamilyCmdClueUnlockFamilyCmd"
ServiceEvent.FamilyCmdClueRewardFamilyCmd = "ServiceEvent_FamilyCmdClueRewardFamilyCmd"
