ServiceActivityEventAutoProxy = class("ServiceActivityEventAutoProxy", ServiceProxy)
ServiceActivityEventAutoProxy.Instance = nil
ServiceActivityEventAutoProxy.NAME = "ServiceActivityEventAutoProxy"

function ServiceActivityEventAutoProxy:ctor(proxyName)
  if ServiceActivityEventAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActivityEventAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActivityEventAutoProxy.Instance = self
  end
end

function ServiceActivityEventAutoProxy:Init()
end

function ServiceActivityEventAutoProxy:onRegister()
  self:Listen(64, 1, function(data)
    self:RecvActivityEventNtf(data)
  end)
  self:Listen(64, 2, function(data)
    self:RecvActivityEventUserDataNtf(data)
  end)
  self:Listen(64, 3, function(data)
    self:RecvActivityEventNtfEventCntCmd(data)
  end)
  self:Listen(64, 4, function(data)
    self:RecvFinishActivityEventCmd(data)
  end)
end

function ServiceActivityEventAutoProxy:CallActivityEventNtf(events)
  if not NetConfig.PBC then
    local msg = ActivityEvent_pb.ActivityEventNtf()
    if events ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.events == nil then
        msg.events = {}
      end
      for i = 1, #events do
        table.insert(msg.events, events[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityEventNtf.id
    local msgParam = {}
    if events ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.events == nil then
        msgParam.events = {}
      end
      for i = 1, #events do
        table.insert(msgParam.events, events[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActivityEventAutoProxy:CallActivityEventUserDataNtf(rewarditems, questionnaireids, rewardinfos)
  if not NetConfig.PBC then
    local msg = ActivityEvent_pb.ActivityEventUserDataNtf()
    if rewarditems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarditems == nil then
        msg.rewarditems = {}
      end
      for i = 1, #rewarditems do
        table.insert(msg.rewarditems, rewarditems[i])
      end
    end
    if questionnaireids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.questionnaireids == nil then
        msg.questionnaireids = {}
      end
      for i = 1, #questionnaireids do
        table.insert(msg.questionnaireids, questionnaireids[i])
      end
    end
    if rewardinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewardinfos == nil then
        msg.rewardinfos = {}
      end
      for i = 1, #rewardinfos do
        table.insert(msg.rewardinfos, rewardinfos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityEventUserDataNtf.id
    local msgParam = {}
    if rewarditems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarditems == nil then
        msgParam.rewarditems = {}
      end
      for i = 1, #rewarditems do
        table.insert(msgParam.rewarditems, rewarditems[i])
      end
    end
    if questionnaireids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.questionnaireids == nil then
        msgParam.questionnaireids = {}
      end
      for i = 1, #questionnaireids do
        table.insert(msgParam.questionnaireids, questionnaireids[i])
      end
    end
    if rewardinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewardinfos == nil then
        msgParam.rewardinfos = {}
      end
      for i = 1, #rewardinfos do
        table.insert(msgParam.rewardinfos, rewardinfos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActivityEventAutoProxy:CallActivityEventNtfEventCntCmd(cnt)
  if not NetConfig.PBC then
    local msg = ActivityEvent_pb.ActivityEventNtfEventCntCmd()
    if cnt ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cnt == nil then
        msg.cnt = {}
      end
      for i = 1, #cnt do
        table.insert(msg.cnt, cnt[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityEventNtfEventCntCmd.id
    local msgParam = {}
    if cnt ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cnt == nil then
        msgParam.cnt = {}
      end
      for i = 1, #cnt do
        table.insert(msgParam.cnt, cnt[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActivityEventAutoProxy:CallFinishActivityEventCmd(eventtype, finish_actid, reward_actid)
  if not NetConfig.PBC then
    local msg = ActivityEvent_pb.FinishActivityEventCmd()
    if eventtype ~= nil then
      msg.eventtype = eventtype
    end
    if finish_actid ~= nil then
      msg.finish_actid = finish_actid
    end
    if reward_actid ~= nil then
      msg.reward_actid = reward_actid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FinishActivityEventCmd.id
    local msgParam = {}
    if eventtype ~= nil then
      msgParam.eventtype = eventtype
    end
    if finish_actid ~= nil then
      msgParam.finish_actid = finish_actid
    end
    if reward_actid ~= nil then
      msgParam.reward_actid = reward_actid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActivityEventAutoProxy:RecvActivityEventNtf(data)
  self:Notify(ServiceEvent.ActivityEventActivityEventNtf, data)
end

function ServiceActivityEventAutoProxy:RecvActivityEventUserDataNtf(data)
  self:Notify(ServiceEvent.ActivityEventActivityEventUserDataNtf, data)
end

function ServiceActivityEventAutoProxy:RecvActivityEventNtfEventCntCmd(data)
  self:Notify(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, data)
end

function ServiceActivityEventAutoProxy:RecvFinishActivityEventCmd(data)
  self:Notify(ServiceEvent.ActivityEventFinishActivityEventCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ActivityEventActivityEventNtf = "ServiceEvent_ActivityEventActivityEventNtf"
ServiceEvent.ActivityEventActivityEventUserDataNtf = "ServiceEvent_ActivityEventActivityEventUserDataNtf"
ServiceEvent.ActivityEventActivityEventNtfEventCntCmd = "ServiceEvent_ActivityEventActivityEventNtfEventCntCmd"
ServiceEvent.ActivityEventFinishActivityEventCmd = "ServiceEvent_ActivityEventFinishActivityEventCmd"
