ServiceAchieveCmdAutoProxy = class("ServiceAchieveCmdAutoProxy", ServiceProxy)
ServiceAchieveCmdAutoProxy.Instance = nil
ServiceAchieveCmdAutoProxy.NAME = "ServiceAchieveCmdAutoProxy"

function ServiceAchieveCmdAutoProxy:ctor(proxyName)
  if ServiceAchieveCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAchieveCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAchieveCmdAutoProxy.Instance = self
  end
end

function ServiceAchieveCmdAutoProxy:Init()
end

function ServiceAchieveCmdAutoProxy:onRegister()
  self:Listen(17, 1, function(data)
    self:RecvQueryUserResumeAchCmd(data)
  end)
  self:Listen(17, 2, function(data)
    self:RecvQueryAchieveDataAchCmd(data)
  end)
  self:Listen(17, 3, function(data)
    self:RecvNewAchieveNtfAchCmd(data)
  end)
  self:Listen(17, 4, function(data)
    self:RecvRewardGetAchCmd(data)
  end)
  self:Listen(17, 5, function(data)
    self:RecvRewardGetQuickAchCmd(data)
  end)
  self:Listen(17, 6, function(data)
    self:RecvNewNpcAchieveNtfAchCmd(data)
  end)
  self:Listen(17, 7, function(data)
    self:RecvQueryNpcAchieveAchCmd(data)
  end)
  self:Listen(17, 8, function(data)
    self:RecvUpdateNpcAchieveAchCmd(data)
  end)
  self:Listen(17, 9, function(data)
    self:RecvGetNpcAchieveRewardAchCmd(data)
  end)
end

function ServiceAchieveCmdAutoProxy:CallQueryUserResumeAchCmd(data)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.QueryUserResumeAchCmd()
    if data ~= nil and data.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.createtime = data.createtime
    end
    if data ~= nil and data.logintime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.logintime = data.logintime
    end
    if data ~= nil and data.bepro_1_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.bepro_1_time = data.bepro_1_time
    end
    if data ~= nil and data.bepro_2_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.bepro_2_time = data.bepro_2_time
    end
    if data ~= nil and data.bepro_3_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.bepro_3_time = data.bepro_3_time
    end
    if data ~= nil and data.bepro_4_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.bepro_4_time = data.bepro_4_time
    end
    if data ~= nil and data.bepro_5_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.bepro_5_time = data.bepro_5_time
    end
    if data ~= nil and data.walk_distance ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.walk_distance = data.walk_distance
    end
    if data ~= nil and data.max_team ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.max_team = data.max_team
    end
    if data ~= nil and data.max_hand ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.max_hand = data.max_hand
    end
    if data ~= nil and data.max_wheel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.max_wheel = data.max_wheel
    end
    if data ~= nil and data.max_chat ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.max_chat = data.max_chat
    end
    if data ~= nil and data.max_teams ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_teams == nil then
        msg.data.max_teams = {}
      end
      for i = 1, #data.max_teams do
        table.insert(msg.data.max_teams, data.max_teams[i])
      end
    end
    if data ~= nil and data.max_hands ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_hands == nil then
        msg.data.max_hands = {}
      end
      for i = 1, #data.max_hands do
        table.insert(msg.data.max_hands, data.max_hands[i])
      end
    end
    if data ~= nil and data.max_wheels ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_wheels == nil then
        msg.data.max_wheels = {}
      end
      for i = 1, #data.max_wheels do
        table.insert(msg.data.max_wheels, data.max_wheels[i])
      end
    end
    if data ~= nil and data.max_chats ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_chats == nil then
        msg.data.max_chats = {}
      end
      for i = 1, #data.max_chats do
        table.insert(msg.data.max_chats, data.max_chats[i])
      end
    end
    if data ~= nil and data.max_music ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_music == nil then
        msg.data.max_music = {}
      end
      for i = 1, #data.max_music do
        table.insert(msg.data.max_music, data.max_music[i])
      end
    end
    if data ~= nil and data.max_save ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_save == nil then
        msg.data.max_save = {}
      end
      for i = 1, #data.max_save do
        table.insert(msg.data.max_save, data.max_save[i])
      end
    end
    if data ~= nil and data.max_besave ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.max_besave == nil then
        msg.data.max_besave = {}
      end
      for i = 1, #data.max_besave do
        table.insert(msg.data.max_besave, data.max_besave[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserResumeAchCmd.id
    local msgParam = {}
    if data ~= nil and data.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.createtime = data.createtime
    end
    if data ~= nil and data.logintime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.logintime = data.logintime
    end
    if data ~= nil and data.bepro_1_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.bepro_1_time = data.bepro_1_time
    end
    if data ~= nil and data.bepro_2_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.bepro_2_time = data.bepro_2_time
    end
    if data ~= nil and data.bepro_3_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.bepro_3_time = data.bepro_3_time
    end
    if data ~= nil and data.bepro_4_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.bepro_4_time = data.bepro_4_time
    end
    if data ~= nil and data.bepro_5_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.bepro_5_time = data.bepro_5_time
    end
    if data ~= nil and data.walk_distance ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.walk_distance = data.walk_distance
    end
    if data ~= nil and data.max_team ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.max_team = data.max_team
    end
    if data ~= nil and data.max_hand ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.max_hand = data.max_hand
    end
    if data ~= nil and data.max_wheel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.max_wheel = data.max_wheel
    end
    if data ~= nil and data.max_chat ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.max_chat = data.max_chat
    end
    if data ~= nil and data.max_teams ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_teams == nil then
        msgParam.data.max_teams = {}
      end
      for i = 1, #data.max_teams do
        table.insert(msgParam.data.max_teams, data.max_teams[i])
      end
    end
    if data ~= nil and data.max_hands ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_hands == nil then
        msgParam.data.max_hands = {}
      end
      for i = 1, #data.max_hands do
        table.insert(msgParam.data.max_hands, data.max_hands[i])
      end
    end
    if data ~= nil and data.max_wheels ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_wheels == nil then
        msgParam.data.max_wheels = {}
      end
      for i = 1, #data.max_wheels do
        table.insert(msgParam.data.max_wheels, data.max_wheels[i])
      end
    end
    if data ~= nil and data.max_chats ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_chats == nil then
        msgParam.data.max_chats = {}
      end
      for i = 1, #data.max_chats do
        table.insert(msgParam.data.max_chats, data.max_chats[i])
      end
    end
    if data ~= nil and data.max_music ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_music == nil then
        msgParam.data.max_music = {}
      end
      for i = 1, #data.max_music do
        table.insert(msgParam.data.max_music, data.max_music[i])
      end
    end
    if data ~= nil and data.max_save ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_save == nil then
        msgParam.data.max_save = {}
      end
      for i = 1, #data.max_save do
        table.insert(msgParam.data.max_save, data.max_save[i])
      end
    end
    if data ~= nil and data.max_besave ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.max_besave == nil then
        msgParam.data.max_besave = {}
      end
      for i = 1, #data.max_besave do
        table.insert(msgParam.data.max_besave, data.max_besave[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAchieveCmdAutoProxy:CallQueryAchieveDataAchCmd(type, items)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.QueryAchieveDataAchCmd()
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
    local msgId = ProtoReqInfoList.QueryAchieveDataAchCmd.id
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

function ServiceAchieveCmdAutoProxy:CallNewAchieveNtfAchCmd(type, items)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.NewAchieveNtfAchCmd()
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
    local msgId = ProtoReqInfoList.NewAchieveNtfAchCmd.id
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

function ServiceAchieveCmdAutoProxy:CallRewardGetAchCmd(id)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.RewardGetAchCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RewardGetAchCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAchieveCmdAutoProxy:CallRewardGetQuickAchCmd(ids)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.RewardGetQuickAchCmd()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RewardGetQuickAchCmd.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAchieveCmdAutoProxy:CallNewNpcAchieveNtfAchCmd(groupid)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.NewNpcAchieveNtfAchCmd()
    if groupid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groupid == nil then
        msg.groupid = {}
      end
      for i = 1, #groupid do
        table.insert(msg.groupid, groupid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewNpcAchieveNtfAchCmd.id
    local msgParam = {}
    if groupid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groupid == nil then
        msgParam.groupid = {}
      end
      for i = 1, #groupid do
        table.insert(msgParam.groupid, groupid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAchieveCmdAutoProxy:CallQueryNpcAchieveAchCmd()
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.QueryNpcAchieveAchCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryNpcAchieveAchCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAchieveCmdAutoProxy:CallUpdateNpcAchieveAchCmd(datas)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.UpdateNpcAchieveAchCmd()
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
    local msgId = ProtoReqInfoList.UpdateNpcAchieveAchCmd.id
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

function ServiceAchieveCmdAutoProxy:CallGetNpcAchieveRewardAchCmd(id)
  if not NetConfig.PBC then
    local msg = AchieveCmd_pb.GetNpcAchieveRewardAchCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetNpcAchieveRewardAchCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAchieveCmdAutoProxy:RecvQueryUserResumeAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdQueryUserResumeAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvQueryAchieveDataAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvNewAchieveNtfAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvRewardGetAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdRewardGetAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvRewardGetQuickAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdRewardGetQuickAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvNewNpcAchieveNtfAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdNewNpcAchieveNtfAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvQueryNpcAchieveAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdQueryNpcAchieveAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvUpdateNpcAchieveAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdUpdateNpcAchieveAchCmd, data)
end

function ServiceAchieveCmdAutoProxy:RecvGetNpcAchieveRewardAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdGetNpcAchieveRewardAchCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.AchieveCmdQueryUserResumeAchCmd = "ServiceEvent_AchieveCmdQueryUserResumeAchCmd"
ServiceEvent.AchieveCmdQueryAchieveDataAchCmd = "ServiceEvent_AchieveCmdQueryAchieveDataAchCmd"
ServiceEvent.AchieveCmdNewAchieveNtfAchCmd = "ServiceEvent_AchieveCmdNewAchieveNtfAchCmd"
ServiceEvent.AchieveCmdRewardGetAchCmd = "ServiceEvent_AchieveCmdRewardGetAchCmd"
ServiceEvent.AchieveCmdRewardGetQuickAchCmd = "ServiceEvent_AchieveCmdRewardGetQuickAchCmd"
ServiceEvent.AchieveCmdNewNpcAchieveNtfAchCmd = "ServiceEvent_AchieveCmdNewNpcAchieveNtfAchCmd"
ServiceEvent.AchieveCmdQueryNpcAchieveAchCmd = "ServiceEvent_AchieveCmdQueryNpcAchieveAchCmd"
ServiceEvent.AchieveCmdUpdateNpcAchieveAchCmd = "ServiceEvent_AchieveCmdUpdateNpcAchieveAchCmd"
ServiceEvent.AchieveCmdGetNpcAchieveRewardAchCmd = "ServiceEvent_AchieveCmdGetNpcAchieveRewardAchCmd"
