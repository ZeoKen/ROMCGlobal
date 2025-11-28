ServiceGoalCmdAutoProxy = class("ServiceGoalCmdAutoProxy", ServiceProxy)
ServiceGoalCmdAutoProxy.Instance = nil
ServiceGoalCmdAutoProxy.NAME = "ServiceGoalCmdAutoProxy"

function ServiceGoalCmdAutoProxy:ctor(proxyName)
  if ServiceGoalCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGoalCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGoalCmdAutoProxy.Instance = self
  end
end

function ServiceGoalCmdAutoProxy:Init()
end

function ServiceGoalCmdAutoProxy:onRegister()
  self:Listen(75, 1, function(data)
    self:RecvQueryGoalListGoalCmd(data)
  end)
  self:Listen(75, 2, function(data)
    self:RecvNewGoalItemUpdateGoalCmd(data)
  end)
  self:Listen(75, 3, function(data)
    self:RecvNewGroupUpdateGoalCmd(data)
  end)
  self:Listen(75, 4, function(data)
    self:RecvNewGoalScoreUpdateGoalCmd(data)
  end)
  self:Listen(75, 5, function(data)
    self:RecvGetGroupRewardGoalCmd(data)
  end)
  self:Listen(75, 6, function(data)
    self:RecvGetScoreGoalCmd(data)
  end)
  self:Listen(75, 7, function(data)
    self:RecvGetScoreRewardGoalCmd(data)
  end)
end

function ServiceGoalCmdAutoProxy:CallQueryGoalListGoalCmd(version, items, groups, score)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.QueryGoalListGoalCmd()
    if version ~= nil then
      msg.version = version
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
    if groups ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groups == nil then
        msg.groups = {}
      end
      for i = 1, #groups do
        table.insert(msg.groups, groups[i])
      end
    end
    if score ~= nil and score.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.score == nil then
        msg.score = {}
      end
      msg.score.version = score.version
    end
    if score ~= nil and score.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.score == nil then
        msg.score = {}
      end
      msg.score.score = score.score
    end
    if score ~= nil and score.rewards ~= nil then
      if msg.score == nil then
        msg.score = {}
      end
      if msg.score.rewards == nil then
        msg.score.rewards = {}
      end
      for i = 1, #score.rewards do
        table.insert(msg.score.rewards, score.rewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGoalListGoalCmd.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
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
    if groups ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groups == nil then
        msgParam.groups = {}
      end
      for i = 1, #groups do
        table.insert(msgParam.groups, groups[i])
      end
    end
    if score ~= nil and score.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.score == nil then
        msgParam.score = {}
      end
      msgParam.score.version = score.version
    end
    if score ~= nil and score.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.score == nil then
        msgParam.score = {}
      end
      msgParam.score.score = score.score
    end
    if score ~= nil and score.rewards ~= nil then
      if msgParam.score == nil then
        msgParam.score = {}
      end
      if msgParam.score.rewards == nil then
        msgParam.score.rewards = {}
      end
      for i = 1, #score.rewards do
        table.insert(msgParam.score.rewards, score.rewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:CallNewGoalItemUpdateGoalCmd(item)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.NewGoalItemUpdateGoalCmd()
    if item ~= nil and item.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.id = item.id
    end
    if item ~= nil and item.process ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.process = item.process
    end
    if item ~= nil and item.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.status = item.status
    end
    if item ~= nil and item.point ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.point = item.point
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewGoalItemUpdateGoalCmd.id
    local msgParam = {}
    if item ~= nil and item.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.id = item.id
    end
    if item ~= nil and item.process ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.process = item.process
    end
    if item ~= nil and item.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.status = item.status
    end
    if item ~= nil and item.point ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.point = item.point
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:CallNewGroupUpdateGoalCmd(group)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.NewGroupUpdateGoalCmd()
    if group ~= nil and group.group ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.group == nil then
        msg.group = {}
      end
      msg.group.group = group.group
    end
    if group ~= nil and group.rewardcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.group == nil then
        msg.group = {}
      end
      msg.group.rewardcount = group.rewardcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewGroupUpdateGoalCmd.id
    local msgParam = {}
    if group ~= nil and group.group ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.group == nil then
        msgParam.group = {}
      end
      msgParam.group.group = group.group
    end
    if group ~= nil and group.rewardcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.group == nil then
        msgParam.group = {}
      end
      msgParam.group.rewardcount = group.rewardcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:CallNewGoalScoreUpdateGoalCmd(score)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.NewGoalScoreUpdateGoalCmd()
    if score ~= nil and score.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.score == nil then
        msg.score = {}
      end
      msg.score.version = score.version
    end
    if score ~= nil and score.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.score == nil then
        msg.score = {}
      end
      msg.score.score = score.score
    end
    if score ~= nil and score.rewards ~= nil then
      if msg.score == nil then
        msg.score = {}
      end
      if msg.score.rewards == nil then
        msg.score.rewards = {}
      end
      for i = 1, #score.rewards do
        table.insert(msg.score.rewards, score.rewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewGoalScoreUpdateGoalCmd.id
    local msgParam = {}
    if score ~= nil and score.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.score == nil then
        msgParam.score = {}
      end
      msgParam.score.version = score.version
    end
    if score ~= nil and score.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.score == nil then
        msgParam.score = {}
      end
      msgParam.score.score = score.score
    end
    if score ~= nil and score.rewards ~= nil then
      if msgParam.score == nil then
        msgParam.score = {}
      end
      if msgParam.score.rewards == nil then
        msgParam.score.rewards = {}
      end
      for i = 1, #score.rewards do
        table.insert(msgParam.score.rewards, score.rewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:CallGetGroupRewardGoalCmd(group)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.GetGroupRewardGoalCmd()
    if group ~= nil then
      msg.group = group
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetGroupRewardGoalCmd.id
    local msgParam = {}
    if group ~= nil then
      msgParam.group = group
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:CallGetScoreGoalCmd(id)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.GetScoreGoalCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetScoreGoalCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:CallGetScoreRewardGoalCmd(version, value)
  if not NetConfig.PBC then
    local msg = GoalCmd_pb.GetScoreRewardGoalCmd()
    if version ~= nil then
      msg.version = version
    end
    if value ~= nil then
      msg.value = value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetScoreRewardGoalCmd.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    if value ~= nil then
      msgParam.value = value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGoalCmdAutoProxy:RecvQueryGoalListGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdQueryGoalListGoalCmd, data)
end

function ServiceGoalCmdAutoProxy:RecvNewGoalItemUpdateGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdNewGoalItemUpdateGoalCmd, data)
end

function ServiceGoalCmdAutoProxy:RecvNewGroupUpdateGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdNewGroupUpdateGoalCmd, data)
end

function ServiceGoalCmdAutoProxy:RecvNewGoalScoreUpdateGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdNewGoalScoreUpdateGoalCmd, data)
end

function ServiceGoalCmdAutoProxy:RecvGetGroupRewardGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdGetGroupRewardGoalCmd, data)
end

function ServiceGoalCmdAutoProxy:RecvGetScoreGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdGetScoreGoalCmd, data)
end

function ServiceGoalCmdAutoProxy:RecvGetScoreRewardGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdGetScoreRewardGoalCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GoalCmdQueryGoalListGoalCmd = "ServiceEvent_GoalCmdQueryGoalListGoalCmd"
ServiceEvent.GoalCmdNewGoalItemUpdateGoalCmd = "ServiceEvent_GoalCmdNewGoalItemUpdateGoalCmd"
ServiceEvent.GoalCmdNewGroupUpdateGoalCmd = "ServiceEvent_GoalCmdNewGroupUpdateGoalCmd"
ServiceEvent.GoalCmdNewGoalScoreUpdateGoalCmd = "ServiceEvent_GoalCmdNewGoalScoreUpdateGoalCmd"
ServiceEvent.GoalCmdGetGroupRewardGoalCmd = "ServiceEvent_GoalCmdGetGroupRewardGoalCmd"
ServiceEvent.GoalCmdGetScoreGoalCmd = "ServiceEvent_GoalCmdGetScoreGoalCmd"
ServiceEvent.GoalCmdGetScoreRewardGoalCmd = "ServiceEvent_GoalCmdGetScoreRewardGoalCmd"
