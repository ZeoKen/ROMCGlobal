ServiceBattlePassAutoProxy = class("ServiceBattlePassAutoProxy", ServiceProxy)
ServiceBattlePassAutoProxy.Instance = nil
ServiceBattlePassAutoProxy.NAME = "ServiceBattlePassAutoProxy"

function ServiceBattlePassAutoProxy:ctor(proxyName)
  if ServiceBattlePassAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBattlePassAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBattlePassAutoProxy.Instance = self
  end
end

function ServiceBattlePassAutoProxy:Init()
end

function ServiceBattlePassAutoProxy:onRegister()
  self:Listen(222, 1, function(data)
    self:RecvGetRewardBattlePassCmd(data)
  end)
  self:Listen(222, 2, function(data)
    self:RecvUpdateRewardBattlePassCmd(data)
  end)
  self:Listen(222, 3, function(data)
    self:RecvBuyLevelBattlePassCmd(data)
  end)
  self:Listen(222, 4, function(data)
    self:RecvAdvanceBattlePassCmd(data)
  end)
  self:Listen(222, 5, function(data)
    self:RecvSyncInfoBattlePassCmd(data)
  end)
  self:Listen(222, 6, function(data)
    self:RecvBattlePassQuestInfoCmd(data)
  end)
end

function ServiceBattlePassAutoProxy:CallGetRewardBattlePassCmd(all, normal_lv, pro_lv, su_lv)
  if not NetConfig.PBC then
    local msg = BattlePass_pb.GetRewardBattlePassCmd()
    if all ~= nil then
      msg.all = all
    end
    if normal_lv ~= nil then
      msg.normal_lv = normal_lv
    end
    if pro_lv ~= nil then
      msg.pro_lv = pro_lv
    end
    if su_lv ~= nil then
      msg.su_lv = su_lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetRewardBattlePassCmd.id
    local msgParam = {}
    if all ~= nil then
      msgParam.all = all
    end
    if normal_lv ~= nil then
      msgParam.normal_lv = normal_lv
    end
    if pro_lv ~= nil then
      msgParam.pro_lv = pro_lv
    end
    if su_lv ~= nil then
      msgParam.su_lv = su_lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBattlePassAutoProxy:CallUpdateRewardBattlePassCmd(levels, prolevels, sulevels)
  if not NetConfig.PBC then
    local msg = BattlePass_pb.UpdateRewardBattlePassCmd()
    if levels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.levels == nil then
        msg.levels = {}
      end
      for i = 1, #levels do
        table.insert(msg.levels, levels[i])
      end
    end
    if prolevels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.prolevels == nil then
        msg.prolevels = {}
      end
      for i = 1, #prolevels do
        table.insert(msg.prolevels, prolevels[i])
      end
    end
    if sulevels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sulevels == nil then
        msg.sulevels = {}
      end
      for i = 1, #sulevels do
        table.insert(msg.sulevels, sulevels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateRewardBattlePassCmd.id
    local msgParam = {}
    if levels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.levels == nil then
        msgParam.levels = {}
      end
      for i = 1, #levels do
        table.insert(msgParam.levels, levels[i])
      end
    end
    if prolevels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.prolevels == nil then
        msgParam.prolevels = {}
      end
      for i = 1, #prolevels do
        table.insert(msgParam.prolevels, prolevels[i])
      end
    end
    if sulevels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sulevels == nil then
        msgParam.sulevels = {}
      end
      for i = 1, #sulevels do
        table.insert(msgParam.sulevels, sulevels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBattlePassAutoProxy:CallBuyLevelBattlePassCmd(level)
  if not NetConfig.PBC then
    local msg = BattlePass_pb.BuyLevelBattlePassCmd()
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyLevelBattlePassCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBattlePassAutoProxy:CallAdvanceBattlePassCmd(level, super)
  if not NetConfig.PBC then
    local msg = BattlePass_pb.AdvanceBattlePassCmd()
    if level ~= nil then
      msg.level = level
    end
    if super ~= nil then
      msg.super = super
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AdvanceBattlePassCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    if super ~= nil then
      msgParam.super = super
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBattlePassAutoProxy:CallSyncInfoBattlePassCmd(level, pro_level, rewardlvs, reward_prolvs, exp, su_level, reward_sulvs, version)
  if not NetConfig.PBC then
    local msg = BattlePass_pb.SyncInfoBattlePassCmd()
    if level ~= nil then
      msg.level = level
    end
    if pro_level ~= nil then
      msg.pro_level = pro_level
    end
    if rewardlvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewardlvs == nil then
        msg.rewardlvs = {}
      end
      for i = 1, #rewardlvs do
        table.insert(msg.rewardlvs, rewardlvs[i])
      end
    end
    if reward_prolvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reward_prolvs == nil then
        msg.reward_prolvs = {}
      end
      for i = 1, #reward_prolvs do
        table.insert(msg.reward_prolvs, reward_prolvs[i])
      end
    end
    if exp ~= nil then
      msg.exp = exp
    end
    if su_level ~= nil then
      msg.su_level = su_level
    end
    if reward_sulvs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reward_sulvs == nil then
        msg.reward_sulvs = {}
      end
      for i = 1, #reward_sulvs do
        table.insert(msg.reward_sulvs, reward_sulvs[i])
      end
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncInfoBattlePassCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    if pro_level ~= nil then
      msgParam.pro_level = pro_level
    end
    if rewardlvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewardlvs == nil then
        msgParam.rewardlvs = {}
      end
      for i = 1, #rewardlvs do
        table.insert(msgParam.rewardlvs, rewardlvs[i])
      end
    end
    if reward_prolvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reward_prolvs == nil then
        msgParam.reward_prolvs = {}
      end
      for i = 1, #reward_prolvs do
        table.insert(msgParam.reward_prolvs, reward_prolvs[i])
      end
    end
    if exp ~= nil then
      msgParam.exp = exp
    end
    if su_level ~= nil then
      msgParam.su_level = su_level
    end
    if reward_sulvs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reward_sulvs == nil then
        msgParam.reward_sulvs = {}
      end
      for i = 1, #reward_sulvs do
        table.insert(msgParam.reward_sulvs, reward_sulvs[i])
      end
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBattlePassAutoProxy:CallBattlePassQuestInfoCmd(quests)
  if not NetConfig.PBC then
    local msg = BattlePass_pb.BattlePassQuestInfoCmd()
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
    local msgId = ProtoReqInfoList.BattlePassQuestInfoCmd.id
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

function ServiceBattlePassAutoProxy:RecvGetRewardBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassGetRewardBattlePassCmd, data)
end

function ServiceBattlePassAutoProxy:RecvUpdateRewardBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassUpdateRewardBattlePassCmd, data)
end

function ServiceBattlePassAutoProxy:RecvBuyLevelBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassBuyLevelBattlePassCmd, data)
end

function ServiceBattlePassAutoProxy:RecvAdvanceBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassAdvanceBattlePassCmd, data)
end

function ServiceBattlePassAutoProxy:RecvSyncInfoBattlePassCmd(data)
  self:Notify(ServiceEvent.BattlePassSyncInfoBattlePassCmd, data)
end

function ServiceBattlePassAutoProxy:RecvBattlePassQuestInfoCmd(data)
  self:Notify(ServiceEvent.BattlePassBattlePassQuestInfoCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.BattlePassGetRewardBattlePassCmd = "ServiceEvent_BattlePassGetRewardBattlePassCmd"
ServiceEvent.BattlePassUpdateRewardBattlePassCmd = "ServiceEvent_BattlePassUpdateRewardBattlePassCmd"
ServiceEvent.BattlePassBuyLevelBattlePassCmd = "ServiceEvent_BattlePassBuyLevelBattlePassCmd"
ServiceEvent.BattlePassAdvanceBattlePassCmd = "ServiceEvent_BattlePassAdvanceBattlePassCmd"
ServiceEvent.BattlePassSyncInfoBattlePassCmd = "ServiceEvent_BattlePassSyncInfoBattlePassCmd"
ServiceEvent.BattlePassBattlePassQuestInfoCmd = "ServiceEvent_BattlePassBattlePassQuestInfoCmd"
