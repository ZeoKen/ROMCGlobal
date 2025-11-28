ServiceNoviceBattlePassAutoProxy = class("ServiceNoviceBattlePassAutoProxy", ServiceProxy)
ServiceNoviceBattlePassAutoProxy.Instance = nil
ServiceNoviceBattlePassAutoProxy.NAME = "ServiceNoviceBattlePassAutoProxy"

function ServiceNoviceBattlePassAutoProxy:ctor(proxyName)
  if ServiceNoviceBattlePassAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNoviceBattlePassAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNoviceBattlePassAutoProxy.Instance = self
  end
end

function ServiceNoviceBattlePassAutoProxy:Init()
end

function ServiceNoviceBattlePassAutoProxy:onRegister()
  self:Listen(77, 1, function(data)
    self:RecvNoviceBPTargetUpdateCmd(data)
  end)
  self:Listen(77, 2, function(data)
    self:RecvNoviceBPRewardUpdateCmd(data)
  end)
  self:Listen(77, 3, function(data)
    self:RecvNoviceBPTargetRewardCmd(data)
  end)
  self:Listen(77, 4, function(data)
    self:RecvNoviceBpBuyLevelCmd(data)
  end)
  self:Listen(77, 5, function(data)
    self:RecvChallengeTargetUpdateCmd(data)
  end)
  self:Listen(77, 6, function(data)
    self:RecvReturnBpTargetUpdateCmd(data)
  end)
  self:Listen(77, 7, function(data)
    self:RecvReturnBPRewardUpdateCmd(data)
  end)
  self:Listen(77, 8, function(data)
    self:RecvReturnBPTargetRewardCmd(data)
  end)
  self:Listen(77, 9, function(data)
    self:RecvReturnBPReturnRewardCmd(data)
  end)
  self:Listen(77, 10, function(data)
    self:RecvReturnBpBuyLevelCmd(data)
  end)
end

function ServiceNoviceBattlePassAutoProxy:CallNoviceBPTargetUpdateCmd(datas, end_time, is_pro)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.NoviceBPTargetUpdateCmd()
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
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if is_pro ~= nil then
      msg.is_pro = is_pro
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceBPTargetUpdateCmd.id
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
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if is_pro ~= nil then
      msgParam.is_pro = is_pro
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallNoviceBPRewardUpdateCmd(rewarded_normal_lvs, rewarded_pro_lvs)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.NoviceBPRewardUpdateCmd()
    if rewarded_normal_lvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarded_normal_lvs == nil then
        msg.rewarded_normal_lvs = {}
      end
      for i = 1, #rewarded_normal_lvs do
        table.insert(msg.rewarded_normal_lvs, rewarded_normal_lvs[i])
      end
    end
    if rewarded_pro_lvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarded_pro_lvs == nil then
        msg.rewarded_pro_lvs = {}
      end
      for i = 1, #rewarded_pro_lvs do
        table.insert(msg.rewarded_pro_lvs, rewarded_pro_lvs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceBPRewardUpdateCmd.id
    local msgParam = {}
    if rewarded_normal_lvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarded_normal_lvs == nil then
        msgParam.rewarded_normal_lvs = {}
      end
      for i = 1, #rewarded_normal_lvs do
        table.insert(msgParam.rewarded_normal_lvs, rewarded_normal_lvs[i])
      end
    end
    if rewarded_pro_lvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarded_pro_lvs == nil then
        msgParam.rewarded_pro_lvs = {}
      end
      for i = 1, #rewarded_pro_lvs do
        table.insert(msgParam.rewarded_pro_lvs, rewarded_pro_lvs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallNoviceBPTargetRewardCmd(is_all, lv)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.NoviceBPTargetRewardCmd()
    if is_all ~= nil then
      msg.is_all = is_all
    end
    if lv ~= nil then
      msg.lv = lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceBPTargetRewardCmd.id
    local msgParam = {}
    if is_all ~= nil then
      msgParam.is_all = is_all
    end
    if lv ~= nil then
      msgParam.lv = lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallNoviceBpBuyLevelCmd(level)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.NoviceBpBuyLevelCmd()
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceBpBuyLevelCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallChallengeTargetUpdateCmd(datas)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.ChallengeTargetUpdateCmd()
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
    local msgId = ProtoReqInfoList.ChallengeTargetUpdateCmd.id
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

function ServiceNoviceBattlePassAutoProxy:CallReturnBpTargetUpdateCmd(datas, end_time, is_pro, version, bp_class, return_reward_got)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.ReturnBpTargetUpdateCmd()
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
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if is_pro ~= nil then
      msg.is_pro = is_pro
    end
    if version ~= nil then
      msg.version = version
    end
    if bp_class ~= nil then
      msg.bp_class = bp_class
    end
    if return_reward_got ~= nil then
      msg.return_reward_got = return_reward_got
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReturnBpTargetUpdateCmd.id
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
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if is_pro ~= nil then
      msgParam.is_pro = is_pro
    end
    if version ~= nil then
      msgParam.version = version
    end
    if bp_class ~= nil then
      msgParam.bp_class = bp_class
    end
    if return_reward_got ~= nil then
      msgParam.return_reward_got = return_reward_got
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallReturnBPRewardUpdateCmd(rewarded_normal_lvs, rewarded_pro_lvs)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.ReturnBPRewardUpdateCmd()
    if rewarded_normal_lvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarded_normal_lvs == nil then
        msg.rewarded_normal_lvs = {}
      end
      for i = 1, #rewarded_normal_lvs do
        table.insert(msg.rewarded_normal_lvs, rewarded_normal_lvs[i])
      end
    end
    if rewarded_pro_lvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarded_pro_lvs == nil then
        msg.rewarded_pro_lvs = {}
      end
      for i = 1, #rewarded_pro_lvs do
        table.insert(msg.rewarded_pro_lvs, rewarded_pro_lvs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReturnBPRewardUpdateCmd.id
    local msgParam = {}
    if rewarded_normal_lvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarded_normal_lvs == nil then
        msgParam.rewarded_normal_lvs = {}
      end
      for i = 1, #rewarded_normal_lvs do
        table.insert(msgParam.rewarded_normal_lvs, rewarded_normal_lvs[i])
      end
    end
    if rewarded_pro_lvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarded_pro_lvs == nil then
        msgParam.rewarded_pro_lvs = {}
      end
      for i = 1, #rewarded_pro_lvs do
        table.insert(msgParam.rewarded_pro_lvs, rewarded_pro_lvs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallReturnBPTargetRewardCmd(is_all, lv)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.ReturnBPTargetRewardCmd()
    if is_all ~= nil then
      msg.is_all = is_all
    end
    if lv ~= nil then
      msg.lv = lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReturnBPTargetRewardCmd.id
    local msgParam = {}
    if is_all ~= nil then
      msgParam.is_all = is_all
    end
    if lv ~= nil then
      msgParam.lv = lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallReturnBPReturnRewardCmd()
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.ReturnBPReturnRewardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReturnBPReturnRewardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:CallReturnBpBuyLevelCmd(level)
  if not NetConfig.PBC then
    local msg = NoviceBattlePass_pb.ReturnBpBuyLevelCmd()
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReturnBpBuyLevelCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceBattlePassAutoProxy:RecvNoviceBPTargetUpdateCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvNoviceBPRewardUpdateCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassNoviceBPRewardUpdateCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvNoviceBPTargetRewardCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassNoviceBPTargetRewardCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvNoviceBpBuyLevelCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassNoviceBpBuyLevelCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvChallengeTargetUpdateCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassChallengeTargetUpdateCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvReturnBpTargetUpdateCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvReturnBPRewardUpdateCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBPRewardUpdateCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvReturnBPTargetRewardCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBPTargetRewardCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvReturnBPReturnRewardCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBPReturnRewardCmd, data)
end

function ServiceNoviceBattlePassAutoProxy:RecvReturnBpBuyLevelCmd(data)
  self:Notify(ServiceEvent.NoviceBattlePassReturnBpBuyLevelCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd = "ServiceEvent_NoviceBattlePassNoviceBPTargetUpdateCmd"
ServiceEvent.NoviceBattlePassNoviceBPRewardUpdateCmd = "ServiceEvent_NoviceBattlePassNoviceBPRewardUpdateCmd"
ServiceEvent.NoviceBattlePassNoviceBPTargetRewardCmd = "ServiceEvent_NoviceBattlePassNoviceBPTargetRewardCmd"
ServiceEvent.NoviceBattlePassNoviceBpBuyLevelCmd = "ServiceEvent_NoviceBattlePassNoviceBpBuyLevelCmd"
ServiceEvent.NoviceBattlePassChallengeTargetUpdateCmd = "ServiceEvent_NoviceBattlePassChallengeTargetUpdateCmd"
ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd = "ServiceEvent_NoviceBattlePassReturnBpTargetUpdateCmd"
ServiceEvent.NoviceBattlePassReturnBPRewardUpdateCmd = "ServiceEvent_NoviceBattlePassReturnBPRewardUpdateCmd"
ServiceEvent.NoviceBattlePassReturnBPTargetRewardCmd = "ServiceEvent_NoviceBattlePassReturnBPTargetRewardCmd"
ServiceEvent.NoviceBattlePassReturnBPReturnRewardCmd = "ServiceEvent_NoviceBattlePassReturnBPReturnRewardCmd"
ServiceEvent.NoviceBattlePassReturnBpBuyLevelCmd = "ServiceEvent_NoviceBattlePassReturnBpBuyLevelCmd"
