ServiceComodoCmdAutoProxy = class("ServiceComodoCmdAutoProxy", ServiceProxy)
ServiceComodoCmdAutoProxy.Instance = nil
ServiceComodoCmdAutoProxy.NAME = "ServiceComodoCmdAutoProxy"

function ServiceComodoCmdAutoProxy:ctor(proxyName)
  if ServiceComodoCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceComodoCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceComodoCmdAutoProxy.Instance = self
  end
end

function ServiceComodoCmdAutoProxy:Init()
end

function ServiceComodoCmdAutoProxy:onRegister()
  self:Listen(233, 1, function(data)
    self:Recvcomodoreqoperatebuilding(data)
  end)
  self:Listen(233, 3, function(data)
    self:RecvQueryPartnerInfo(data)
  end)
  self:Listen(233, 4, function(data)
    self:RecvGiftPartner(data)
  end)
end

function ServiceComodoCmdAutoProxy:Callcomodoreqoperatebuilding(bid, op, opParam, reply)
  if not NetConfig.PBC then
    local msg = ComodoCmd_pb.comodoreqoperatebuilding()
    if bid ~= nil then
      msg.bid = bid
    end
    if op ~= nil then
      msg.op = op
    end
    if opParam ~= nil and opParam.placeholder1 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opParam == nil then
        msg.opParam = {}
      end
      msg.opParam.placeholder1 = opParam.placeholder1
    end
    if opParam ~= nil and opParam.placeholder2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opParam == nil then
        msg.opParam = {}
      end
      msg.opParam.placeholder2 = opParam.placeholder2
    end
    if opParam ~= nil and opParam.placeholder3 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opParam == nil then
        msg.opParam = {}
      end
      msg.opParam.placeholder3 = opParam.placeholder3
    end
    if opParam ~= nil and opParam.placeholder4 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opParam == nil then
        msg.opParam = {}
      end
      msg.opParam.placeholder4 = opParam.placeholder4
    end
    if reply ~= nil and reply.placeholder ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reply == nil then
        msg.reply = {}
      end
      msg.reply.placeholder = reply.placeholder
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.comodoreqoperatebuilding.id
    local msgParam = {}
    if bid ~= nil then
      msgParam.bid = bid
    end
    if op ~= nil then
      msgParam.op = op
    end
    if opParam ~= nil and opParam.placeholder1 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opParam == nil then
        msgParam.opParam = {}
      end
      msgParam.opParam.placeholder1 = opParam.placeholder1
    end
    if opParam ~= nil and opParam.placeholder2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opParam == nil then
        msgParam.opParam = {}
      end
      msgParam.opParam.placeholder2 = opParam.placeholder2
    end
    if opParam ~= nil and opParam.placeholder3 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opParam == nil then
        msgParam.opParam = {}
      end
      msgParam.opParam.placeholder3 = opParam.placeholder3
    end
    if opParam ~= nil and opParam.placeholder4 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opParam == nil then
        msgParam.opParam = {}
      end
      msgParam.opParam.placeholder4 = opParam.placeholder4
    end
    if reply ~= nil and reply.placeholder ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reply == nil then
        msgParam.reply = {}
      end
      msgParam.reply.placeholder = reply.placeholder
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceComodoCmdAutoProxy:CallQueryPartnerInfo(partners, doc)
  if not NetConfig.PBC then
    local msg = ComodoCmd_pb.QueryPartnerInfo()
    if partners ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.partners == nil then
        msg.partners = {}
      end
      for i = 1, #partners do
        table.insert(msg.partners, partners[i])
      end
    end
    if doc ~= nil and doc.version ~= nil then
      if msg.doc == nil then
        msg.doc = {}
      end
      if msg.doc.version == nil then
        msg.doc.version = {}
      end
      for i = 1, #doc.version do
        table.insert(msg.doc.version, doc.version[i])
      end
    end
    if doc ~= nil and doc.personal ~= nil then
      if msg.doc == nil then
        msg.doc = {}
      end
      if msg.doc.personal == nil then
        msg.doc.personal = {}
      end
      for i = 1, #doc.personal do
        table.insert(msg.doc.personal, doc.personal[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPartnerInfo.id
    local msgParam = {}
    if partners ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.partners == nil then
        msgParam.partners = {}
      end
      for i = 1, #partners do
        table.insert(msgParam.partners, partners[i])
      end
    end
    if doc ~= nil and doc.version ~= nil then
      if msgParam.doc == nil then
        msgParam.doc = {}
      end
      if msgParam.doc.version == nil then
        msgParam.doc.version = {}
      end
      for i = 1, #doc.version do
        table.insert(msgParam.doc.version, doc.version[i])
      end
    end
    if doc ~= nil and doc.personal ~= nil then
      if msgParam.doc == nil then
        msgParam.doc = {}
      end
      if msgParam.doc.personal == nil then
        msgParam.doc.personal = {}
      end
      for i = 1, #doc.personal do
        table.insert(msgParam.doc.personal, doc.personal[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceComodoCmdAutoProxy:CallGiftPartner(pid, guid)
  if not NetConfig.PBC then
    local msg = ComodoCmd_pb.GiftPartner()
    if pid ~= nil then
      msg.pid = pid
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiftPartner.id
    local msgParam = {}
    if pid ~= nil then
      msgParam.pid = pid
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceComodoCmdAutoProxy:Recvcomodoreqoperatebuilding(data)
  self:Notify(ServiceEvent.ComodoCmdcomodoreqoperatebuilding, data)
end

function ServiceComodoCmdAutoProxy:RecvQueryPartnerInfo(data)
  self:Notify(ServiceEvent.ComodoCmdQueryPartnerInfo, data)
end

function ServiceComodoCmdAutoProxy:RecvGiftPartner(data)
  self:Notify(ServiceEvent.ComodoCmdGiftPartner, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ComodoCmdcomodoreqoperatebuilding = "ServiceEvent_ComodoCmdcomodoreqoperatebuilding"
ServiceEvent.ComodoCmdQueryPartnerInfo = "ServiceEvent_ComodoCmdQueryPartnerInfo"
ServiceEvent.ComodoCmdGiftPartner = "ServiceEvent_ComodoCmdGiftPartner"
