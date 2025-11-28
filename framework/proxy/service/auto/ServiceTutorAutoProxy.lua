ServiceTutorAutoProxy = class("ServiceTutorAutoProxy", ServiceProxy)
ServiceTutorAutoProxy.Instance = nil
ServiceTutorAutoProxy.NAME = "ServiceTutorAutoProxy"

function ServiceTutorAutoProxy:ctor(proxyName)
  if ServiceTutorAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTutorAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTutorAutoProxy.Instance = self
  end
end

function ServiceTutorAutoProxy:Init()
end

function ServiceTutorAutoProxy:onRegister()
  self:Listen(31, 1, function(data)
    self:RecvTutorTaskUpdateNtf(data)
  end)
  self:Listen(31, 2, function(data)
    self:RecvTutorTaskQueryCmd(data)
  end)
  self:Listen(31, 3, function(data)
    self:RecvTutorTaskTeacherRewardCmd(data)
  end)
  self:Listen(31, 4, function(data)
    self:RecvTutorGrowRewardUpdateNtf(data)
  end)
  self:Listen(31, 5, function(data)
    self:RecvTutorGetGrowRewardCmd(data)
  end)
  self:Listen(31, 6, function(data)
    self:RecvTutorTaskUpdateBoxCmd(data)
  end)
end

function ServiceTutorAutoProxy:CallTutorTaskUpdateNtf(items)
  if not NetConfig.PBC then
    local msg = Tutor_pb.TutorTaskUpdateNtf()
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
    local msgId = ProtoReqInfoList.TutorTaskUpdateNtf.id
    local msgParam = {}
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

function ServiceTutorAutoProxy:CallTutorTaskQueryCmd(charid, items, finishtaskids, refresh)
  if not NetConfig.PBC then
    local msg = Tutor_pb.TutorTaskQueryCmd()
    if charid ~= nil then
      msg.charid = charid
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
    if finishtaskids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.finishtaskids == nil then
        msg.finishtaskids = {}
      end
      for i = 1, #finishtaskids do
        table.insert(msg.finishtaskids, finishtaskids[i])
      end
    end
    if refresh ~= nil then
      msg.refresh = refresh
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorTaskQueryCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
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
    if finishtaskids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.finishtaskids == nil then
        msgParam.finishtaskids = {}
      end
      for i = 1, #finishtaskids do
        table.insert(msgParam.finishtaskids, finishtaskids[i])
      end
    end
    if refresh ~= nil then
      msgParam.refresh = refresh
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTutorAutoProxy:CallTutorTaskTeacherRewardCmd(charid, taskid)
  if not NetConfig.PBC then
    local msg = Tutor_pb.TutorTaskTeacherRewardCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if taskid ~= nil then
      msg.taskid = taskid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorTaskTeacherRewardCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if taskid ~= nil then
      msgParam.taskid = taskid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTutorAutoProxy:CallTutorGrowRewardUpdateNtf(growrewards)
  if not NetConfig.PBC then
    local msg = Tutor_pb.TutorGrowRewardUpdateNtf()
    if growrewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.growrewards == nil then
        msg.growrewards = {}
      end
      for i = 1, #growrewards do
        table.insert(msg.growrewards, growrewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorGrowRewardUpdateNtf.id
    local msgParam = {}
    if growrewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.growrewards == nil then
        msgParam.growrewards = {}
      end
      for i = 1, #growrewards do
        table.insert(msgParam.growrewards, growrewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTutorAutoProxy:CallTutorGetGrowRewardCmd()
  if not NetConfig.PBC then
    local msg = Tutor_pb.TutorGetGrowRewardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorGetGrowRewardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTutorAutoProxy:CallTutorTaskUpdateBoxCmd(items)
  if not NetConfig.PBC then
    local msg = Tutor_pb.TutorTaskUpdateBoxCmd()
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
    local msgId = ProtoReqInfoList.TutorTaskUpdateBoxCmd.id
    local msgParam = {}
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

function ServiceTutorAutoProxy:RecvTutorTaskUpdateNtf(data)
  self:Notify(ServiceEvent.TutorTutorTaskUpdateNtf, data)
end

function ServiceTutorAutoProxy:RecvTutorTaskQueryCmd(data)
  self:Notify(ServiceEvent.TutorTutorTaskQueryCmd, data)
end

function ServiceTutorAutoProxy:RecvTutorTaskTeacherRewardCmd(data)
  self:Notify(ServiceEvent.TutorTutorTaskTeacherRewardCmd, data)
end

function ServiceTutorAutoProxy:RecvTutorGrowRewardUpdateNtf(data)
  self:Notify(ServiceEvent.TutorTutorGrowRewardUpdateNtf, data)
end

function ServiceTutorAutoProxy:RecvTutorGetGrowRewardCmd(data)
  self:Notify(ServiceEvent.TutorTutorGetGrowRewardCmd, data)
end

function ServiceTutorAutoProxy:RecvTutorTaskUpdateBoxCmd(data)
  self:Notify(ServiceEvent.TutorTutorTaskUpdateBoxCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.TutorTutorTaskUpdateNtf = "ServiceEvent_TutorTutorTaskUpdateNtf"
ServiceEvent.TutorTutorTaskQueryCmd = "ServiceEvent_TutorTutorTaskQueryCmd"
ServiceEvent.TutorTutorTaskTeacherRewardCmd = "ServiceEvent_TutorTutorTaskTeacherRewardCmd"
ServiceEvent.TutorTutorGrowRewardUpdateNtf = "ServiceEvent_TutorTutorGrowRewardUpdateNtf"
ServiceEvent.TutorTutorGetGrowRewardCmd = "ServiceEvent_TutorTutorGetGrowRewardCmd"
ServiceEvent.TutorTutorTaskUpdateBoxCmd = "ServiceEvent_TutorTutorTaskUpdateBoxCmd"
