ServiceSceneSealAutoProxy = class("ServiceSceneSealAutoProxy", ServiceProxy)
ServiceSceneSealAutoProxy.Instance = nil
ServiceSceneSealAutoProxy.NAME = "ServiceSceneSealAutoProxy"

function ServiceSceneSealAutoProxy:ctor(proxyName)
  if ServiceSceneSealAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneSealAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneSealAutoProxy.Instance = self
  end
end

function ServiceSceneSealAutoProxy:Init()
end

function ServiceSceneSealAutoProxy:onRegister()
  self:Listen(21, 1, function(data)
    self:RecvQuerySeal(data)
  end)
  self:Listen(21, 2, function(data)
    self:RecvUpdateSeal(data)
  end)
  self:Listen(21, 3, function(data)
    self:RecvSealTimer(data)
  end)
  self:Listen(21, 4, function(data)
    self:RecvBeginSeal(data)
  end)
  self:Listen(21, 5, function(data)
    self:RecvEndSeal(data)
  end)
  self:Listen(21, 6, function(data)
    self:RecvSealUserLeave(data)
  end)
  self:Listen(21, 7, function(data)
    self:RecvSealQueryList(data)
  end)
  self:Listen(21, 8, function(data)
    self:RecvSealAcceptCmd(data)
  end)
end

function ServiceSceneSealAutoProxy:CallQuerySeal(datas)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.QuerySeal()
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
    local msgId = ProtoReqInfoList.QuerySeal.id
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

function ServiceSceneSealAutoProxy:CallUpdateSeal(newdata, deldata)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.UpdateSeal()
    if newdata ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.newdata == nil then
        msg.newdata = {}
      end
      for i = 1, #newdata do
        table.insert(msg.newdata, newdata[i])
      end
    end
    if deldata ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deldata == nil then
        msg.deldata = {}
      end
      for i = 1, #deldata do
        table.insert(msg.deldata, deldata[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateSeal.id
    local msgParam = {}
    if newdata ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.newdata == nil then
        msgParam.newdata = {}
      end
      for i = 1, #newdata do
        table.insert(msgParam.newdata, newdata[i])
      end
    end
    if deldata ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deldata == nil then
        msgParam.deldata = {}
      end
      for i = 1, #deldata do
        table.insert(msgParam.deldata, deldata[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:CallSealTimer(speed, curvalue, maxvalue, stoptime, maxtime)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.SealTimer()
    if speed ~= nil then
      msg.speed = speed
    end
    if curvalue ~= nil then
      msg.curvalue = curvalue
    end
    if maxvalue ~= nil then
      msg.maxvalue = maxvalue
    end
    if stoptime ~= nil then
      msg.stoptime = stoptime
    end
    if maxtime ~= nil then
      msg.maxtime = maxtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SealTimer.id
    local msgParam = {}
    if speed ~= nil then
      msgParam.speed = speed
    end
    if curvalue ~= nil then
      msgParam.curvalue = curvalue
    end
    if maxvalue ~= nil then
      msgParam.maxvalue = maxvalue
    end
    if stoptime ~= nil then
      msgParam.stoptime = stoptime
    end
    if maxtime ~= nil then
      msgParam.maxtime = maxtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:CallBeginSeal(sealid, etype, finishall)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.BeginSeal()
    if sealid ~= nil then
      msg.sealid = sealid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if finishall ~= nil then
      msg.finishall = finishall
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeginSeal.id
    local msgParam = {}
    if sealid ~= nil then
      msgParam.sealid = sealid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if finishall ~= nil then
      msgParam.finishall = finishall
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:CallEndSeal(success, sealid)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.EndSeal()
    if success ~= nil then
      msg.success = success
    end
    if sealid ~= nil then
      msg.sealid = sealid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EndSeal.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    if sealid ~= nil then
      msgParam.sealid = sealid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:CallSealUserLeave()
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.SealUserLeave()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SealUserLeave.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:CallSealQueryList(configid, donetimes, maxtimes, configparts)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.SealQueryList()
    if configid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.configid == nil then
        msg.configid = {}
      end
      for i = 1, #configid do
        table.insert(msg.configid, configid[i])
      end
    end
    if donetimes ~= nil then
      msg.donetimes = donetimes
    end
    if maxtimes ~= nil then
      msg.maxtimes = maxtimes
    end
    if configparts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.configparts == nil then
        msg.configparts = {}
      end
      for i = 1, #configparts do
        table.insert(msg.configparts, configparts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SealQueryList.id
    local msgParam = {}
    if configid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.configid == nil then
        msgParam.configid = {}
      end
      for i = 1, #configid do
        table.insert(msgParam.configid, configid[i])
      end
    end
    if donetimes ~= nil then
      msgParam.donetimes = donetimes
    end
    if maxtimes ~= nil then
      msgParam.maxtimes = maxtimes
    end
    if configparts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.configparts == nil then
        msgParam.configparts = {}
      end
      for i = 1, #configparts do
        table.insert(msgParam.configparts, configparts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:CallSealAcceptCmd(seal, pos, abandon)
  if not NetConfig.PBC then
    local msg = SceneSeal_pb.SealAcceptCmd()
    if seal ~= nil then
      msg.seal = seal
    end
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    if abandon ~= nil then
      msg.abandon = abandon
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SealAcceptCmd.id
    local msgParam = {}
    if seal ~= nil then
      msgParam.seal = seal
    end
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    if abandon ~= nil then
      msgParam.abandon = abandon
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneSealAutoProxy:RecvQuerySeal(data)
  self:Notify(ServiceEvent.SceneSealQuerySeal, data)
end

function ServiceSceneSealAutoProxy:RecvUpdateSeal(data)
  self:Notify(ServiceEvent.SceneSealUpdateSeal, data)
end

function ServiceSceneSealAutoProxy:RecvSealTimer(data)
  self:Notify(ServiceEvent.SceneSealSealTimer, data)
end

function ServiceSceneSealAutoProxy:RecvBeginSeal(data)
  self:Notify(ServiceEvent.SceneSealBeginSeal, data)
end

function ServiceSceneSealAutoProxy:RecvEndSeal(data)
  self:Notify(ServiceEvent.SceneSealEndSeal, data)
end

function ServiceSceneSealAutoProxy:RecvSealUserLeave(data)
  self:Notify(ServiceEvent.SceneSealSealUserLeave, data)
end

function ServiceSceneSealAutoProxy:RecvSealQueryList(data)
  self:Notify(ServiceEvent.SceneSealSealQueryList, data)
end

function ServiceSceneSealAutoProxy:RecvSealAcceptCmd(data)
  self:Notify(ServiceEvent.SceneSealSealAcceptCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneSealQuerySeal = "ServiceEvent_SceneSealQuerySeal"
ServiceEvent.SceneSealUpdateSeal = "ServiceEvent_SceneSealUpdateSeal"
ServiceEvent.SceneSealSealTimer = "ServiceEvent_SceneSealSealTimer"
ServiceEvent.SceneSealBeginSeal = "ServiceEvent_SceneSealBeginSeal"
ServiceEvent.SceneSealEndSeal = "ServiceEvent_SceneSealEndSeal"
ServiceEvent.SceneSealSealUserLeave = "ServiceEvent_SceneSealSealUserLeave"
ServiceEvent.SceneSealSealQueryList = "ServiceEvent_SceneSealSealQueryList"
ServiceEvent.SceneSealSealAcceptCmd = "ServiceEvent_SceneSealSealAcceptCmd"
