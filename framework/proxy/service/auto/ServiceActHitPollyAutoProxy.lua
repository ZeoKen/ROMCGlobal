ServiceActHitPollyAutoProxy = class("ServiceActHitPollyAutoProxy", ServiceProxy)
ServiceActHitPollyAutoProxy.Instance = nil
ServiceActHitPollyAutoProxy.NAME = "ServiceActHitPollyAutoProxy"

function ServiceActHitPollyAutoProxy:ctor(proxyName)
  if ServiceActHitPollyAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActHitPollyAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActHitPollyAutoProxy.Instance = self
  end
end

function ServiceActHitPollyAutoProxy:Init()
end

function ServiceActHitPollyAutoProxy:onRegister()
  self:Listen(226, 1, function(data)
    self:RecvActityQueryHitedList(data)
  end)
  self:Listen(226, 2, function(data)
    self:RecvActivityHitPolly(data)
  end)
  self:Listen(226, 3, function(data)
    self:RecvActityHitPollySync(data)
  end)
  self:Listen(226, 4, function(data)
    self:RecvActityHitPollySubmitQuest(data)
  end)
  self:Listen(226, 5, function(data)
    self:RecvActityHitPollyNtfQuest(data)
  end)
end

function ServiceActHitPollyAutoProxy:CallActityQueryHitedList(round, currentround, list, restbuy)
  if not NetConfig.PBC then
    local msg = ActHitPolly_pb.ActityQueryHitedList()
    if round ~= nil then
      msg.round = round
    end
    if currentround ~= nil then
      msg.currentround = currentround
    end
    if list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      for i = 1, #list do
        table.insert(msg.list, list[i])
      end
    end
    if restbuy ~= nil then
      msg.restbuy = restbuy
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActityQueryHitedList.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if currentround ~= nil then
      msgParam.currentround = currentround
    end
    if list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      for i = 1, #list do
        table.insert(msgParam.list, list[i])
      end
    end
    if restbuy ~= nil then
      msgParam.restbuy = restbuy
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActHitPollyAutoProxy:CallActivityHitPolly(round, pos, rewardid)
  if not NetConfig.PBC then
    local msg = ActHitPolly_pb.ActivityHitPolly()
    if round ~= nil then
      msg.round = round
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if rewardid ~= nil then
      msg.rewardid = rewardid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityHitPolly.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if rewardid ~= nil then
      msgParam.rewardid = rewardid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActHitPollyAutoProxy:CallActityHitPollySync(globalactid, curround, quests)
  if not NetConfig.PBC then
    local msg = ActHitPolly_pb.ActityHitPollySync()
    if globalactid ~= nil then
      msg.globalactid = globalactid
    end
    if curround ~= nil then
      msg.curround = curround
    end
    if quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quests == nil then
        msg.quests = {}
      end
      for i = 1, #quests do
        table.insert(msg.quests, quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActityHitPollySync.id
    local msgParam = {}
    if globalactid ~= nil then
      msgParam.globalactid = globalactid
    end
    if curround ~= nil then
      msgParam.curround = curround
    end
    if quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quests == nil then
        msgParam.quests = {}
      end
      for i = 1, #quests do
        table.insert(msgParam.quests, quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActHitPollyAutoProxy:CallActityHitPollySubmitQuest(questid)
  if not NetConfig.PBC then
    local msg = ActHitPolly_pb.ActityHitPollySubmitQuest()
    if questid ~= nil then
      msg.questid = questid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActityHitPollySubmitQuest.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActHitPollyAutoProxy:CallActityHitPollyNtfQuest(quests)
  if not NetConfig.PBC then
    local msg = ActHitPolly_pb.ActityHitPollyNtfQuest()
    if quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quests == nil then
        msg.quests = {}
      end
      for i = 1, #quests do
        table.insert(msg.quests, quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActityHitPollyNtfQuest.id
    local msgParam = {}
    if quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quests == nil then
        msgParam.quests = {}
      end
      for i = 1, #quests do
        table.insert(msgParam.quests, quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActHitPollyAutoProxy:RecvActityQueryHitedList(data)
  self:Notify(ServiceEvent.ActHitPollyActityQueryHitedList, data)
end

function ServiceActHitPollyAutoProxy:RecvActivityHitPolly(data)
  self:Notify(ServiceEvent.ActHitPollyActivityHitPolly, data)
end

function ServiceActHitPollyAutoProxy:RecvActityHitPollySync(data)
  self:Notify(ServiceEvent.ActHitPollyActityHitPollySync, data)
end

function ServiceActHitPollyAutoProxy:RecvActityHitPollySubmitQuest(data)
  self:Notify(ServiceEvent.ActHitPollyActityHitPollySubmitQuest, data)
end

function ServiceActHitPollyAutoProxy:RecvActityHitPollyNtfQuest(data)
  self:Notify(ServiceEvent.ActHitPollyActityHitPollyNtfQuest, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ActHitPollyActityQueryHitedList = "ServiceEvent_ActHitPollyActityQueryHitedList"
ServiceEvent.ActHitPollyActivityHitPolly = "ServiceEvent_ActHitPollyActivityHitPolly"
ServiceEvent.ActHitPollyActityHitPollySync = "ServiceEvent_ActHitPollyActityHitPollySync"
ServiceEvent.ActHitPollyActityHitPollySubmitQuest = "ServiceEvent_ActHitPollyActityHitPollySubmitQuest"
ServiceEvent.ActHitPollyActityHitPollyNtfQuest = "ServiceEvent_ActHitPollyActityHitPollyNtfQuest"
