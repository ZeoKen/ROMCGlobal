ServiceAstrolabeCmdAutoProxy = class("ServiceAstrolabeCmdAutoProxy", ServiceProxy)
ServiceAstrolabeCmdAutoProxy.Instance = nil
ServiceAstrolabeCmdAutoProxy.NAME = "ServiceAstrolabeCmdAutoProxy"

function ServiceAstrolabeCmdAutoProxy:ctor(proxyName)
  if ServiceAstrolabeCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAstrolabeCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAstrolabeCmdAutoProxy.Instance = self
  end
end

function ServiceAstrolabeCmdAutoProxy:Init()
end

function ServiceAstrolabeCmdAutoProxy:onRegister()
  self:Listen(28, 1, function(data)
    self:RecvAstrolabeQueryCmd(data)
  end)
  self:Listen(28, 2, function(data)
    self:RecvAstrolabeActivateStarCmd(data)
  end)
  self:Listen(28, 3, function(data)
    self:RecvAstrolabeQueryResetCmd(data)
  end)
  self:Listen(28, 4, function(data)
    self:RecvAstrolabeResetCmd(data)
  end)
  self:Listen(28, 5, function(data)
    self:RecvAstrolabePlanSaveCmd(data)
  end)
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeQueryCmd(stars, astrolabetype)
  if not NetConfig.PBC then
    local msg = AstrolabeCmd_pb.AstrolabeQueryCmd()
    if stars ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stars == nil then
        msg.stars = {}
      end
      for i = 1, #stars do
        table.insert(msg.stars, stars[i])
      end
    end
    if astrolabetype ~= nil then
      msg.astrolabetype = astrolabetype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstrolabeQueryCmd.id
    local msgParam = {}
    if stars ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stars == nil then
        msgParam.stars = {}
      end
      for i = 1, #stars do
        table.insert(msgParam.stars, stars[i])
      end
    end
    if astrolabetype ~= nil then
      msgParam.astrolabetype = astrolabetype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeActivateStarCmd(stars, success)
  if not NetConfig.PBC then
    local msg = AstrolabeCmd_pb.AstrolabeActivateStarCmd()
    if stars ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stars == nil then
        msg.stars = {}
      end
      for i = 1, #stars do
        table.insert(msg.stars, stars[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstrolabeActivateStarCmd.id
    local msgParam = {}
    if stars ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stars == nil then
        msgParam.stars = {}
      end
      for i = 1, #stars do
        table.insert(msgParam.stars, stars[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeQueryResetCmd(type, items)
  if not NetConfig.PBC then
    local msg = AstrolabeCmd_pb.AstrolabeQueryResetCmd()
    if type ~= nil then
      msg.type = type
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstrolabeQueryResetCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabeResetCmd(stars, success)
  if not NetConfig.PBC then
    local msg = AstrolabeCmd_pb.AstrolabeResetCmd()
    if stars ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stars == nil then
        msg.stars = {}
      end
      for i = 1, #stars do
        table.insert(msg.stars, stars[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstrolabeResetCmd.id
    local msgParam = {}
    if stars ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stars == nil then
        msgParam.stars = {}
      end
      for i = 1, #stars do
        table.insert(msgParam.stars, stars[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAstrolabeCmdAutoProxy:CallAstrolabePlanSaveCmd(stars)
  if not NetConfig.PBC then
    local msg = AstrolabeCmd_pb.AstrolabePlanSaveCmd()
    if stars ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stars == nil then
        msg.stars = {}
      end
      for i = 1, #stars do
        table.insert(msg.stars, stars[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AstrolabePlanSaveCmd.id
    local msgParam = {}
    if stars ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stars == nil then
        msgParam.stars = {}
      end
      for i = 1, #stars do
        table.insert(msgParam.stars, stars[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeQueryCmd(data)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeActivateStarCmd(data)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeQueryResetCmd(data)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryResetCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabeResetCmd(data)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, data)
end

function ServiceAstrolabeCmdAutoProxy:RecvAstrolabePlanSaveCmd(data)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabePlanSaveCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.AstrolabeCmdAstrolabeQueryCmd = "ServiceEvent_AstrolabeCmdAstrolabeQueryCmd"
ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd = "ServiceEvent_AstrolabeCmdAstrolabeActivateStarCmd"
ServiceEvent.AstrolabeCmdAstrolabeQueryResetCmd = "ServiceEvent_AstrolabeCmdAstrolabeQueryResetCmd"
ServiceEvent.AstrolabeCmdAstrolabeResetCmd = "ServiceEvent_AstrolabeCmdAstrolabeResetCmd"
ServiceEvent.AstrolabeCmdAstrolabePlanSaveCmd = "ServiceEvent_AstrolabeCmdAstrolabePlanSaveCmd"
