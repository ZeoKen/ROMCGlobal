ServiceDisneyActivityAutoProxy = class("ServiceDisneyActivityAutoProxy", ServiceProxy)
ServiceDisneyActivityAutoProxy.Instance = nil
ServiceDisneyActivityAutoProxy.NAME = "ServiceDisneyActivityAutoProxy"

function ServiceDisneyActivityAutoProxy:ctor(proxyName)
  if ServiceDisneyActivityAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceDisneyActivityAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceDisneyActivityAutoProxy.Instance = self
  end
end

function ServiceDisneyActivityAutoProxy:Init()
end

function ServiceDisneyActivityAutoProxy:onRegister()
  self:Listen(232, 1, function(data)
    self:RecvQueryDisneyGuideInfoCmd(data)
  end)
  self:Listen(232, 2, function(data)
    self:RecvReceiveGuideRewardCmd(data)
  end)
  self:Listen(232, 3, function(data)
    self:RecvReceiveMickeyRewardCmd(data)
  end)
  self:Listen(232, 4, function(data)
    self:RecvDisneyChallengeTaskRankCmd(data)
  end)
  self:Listen(232, 5, function(data)
    self:RecvDisneyChallengeTaskTipCmd(data)
  end)
  self:Listen(232, 6, function(data)
    self:RecvDisneyChallengeTaskPointCmd(data)
  end)
  self:Listen(232, 7, function(data)
    self:RecvDisneyChallengeTaskNotifyFirstFinishCmd(data)
  end)
  self:Listen(232, 8, function(data)
    self:RecvDisneyMusicOpenCmd(data)
  end)
  self:Listen(232, 9, function(data)
    self:RecvDisneyMusicUpdateCmd(data)
  end)
  self:Listen(232, 10, function(data)
    self:RecvDisneyMusicChooseHeroCmd(data)
  end)
  self:Listen(232, 11, function(data)
    self:RecvDisneyMusicPrepareCmd(data)
  end)
  self:Listen(232, 12, function(data)
    self:RecvDisneyMusicChooseMusicCmd(data)
  end)
  self:Listen(232, 13, function(data)
    self:RecvDisneyMusicStartCmd(data)
  end)
  self:Listen(232, 14, function(data)
    self:RecvDisneyMusicFinishCmd(data)
  end)
  self:Listen(232, 15, function(data)
    self:RecvDisneyMusicResultCmd(data)
  end)
  self:Listen(232, 16, function(data)
    self:RecvDisneyMusicRankCmd(data)
  end)
  self:Listen(232, 17, function(data)
    self:RecvDisneyMusicClientPrepareCmd(data)
  end)
end

function ServiceDisneyActivityAutoProxy:CallQueryDisneyGuideInfoCmd(global_activity_id, opened, mickey_on_ids, received_rewards, mickey_reward_ids, mickey_got_num, get_items)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.QueryDisneyGuideInfoCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if opened ~= nil then
      msg.opened = opened
    end
    if mickey_on_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mickey_on_ids == nil then
        msg.mickey_on_ids = {}
      end
      for i = 1, #mickey_on_ids do
        table.insert(msg.mickey_on_ids, mickey_on_ids[i])
      end
    end
    if received_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.received_rewards == nil then
        msg.received_rewards = {}
      end
      for i = 1, #received_rewards do
        table.insert(msg.received_rewards, received_rewards[i])
      end
    end
    if mickey_reward_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mickey_reward_ids == nil then
        msg.mickey_reward_ids = {}
      end
      for i = 1, #mickey_reward_ids do
        table.insert(msg.mickey_reward_ids, mickey_reward_ids[i])
      end
    end
    if mickey_got_num ~= nil then
      msg.mickey_got_num = mickey_got_num
    end
    if get_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.get_items == nil then
        msg.get_items = {}
      end
      for i = 1, #get_items do
        table.insert(msg.get_items, get_items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryDisneyGuideInfoCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if opened ~= nil then
      msgParam.opened = opened
    end
    if mickey_on_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mickey_on_ids == nil then
        msgParam.mickey_on_ids = {}
      end
      for i = 1, #mickey_on_ids do
        table.insert(msgParam.mickey_on_ids, mickey_on_ids[i])
      end
    end
    if received_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.received_rewards == nil then
        msgParam.received_rewards = {}
      end
      for i = 1, #received_rewards do
        table.insert(msgParam.received_rewards, received_rewards[i])
      end
    end
    if mickey_reward_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mickey_reward_ids == nil then
        msgParam.mickey_reward_ids = {}
      end
      for i = 1, #mickey_reward_ids do
        table.insert(msgParam.mickey_reward_ids, mickey_reward_ids[i])
      end
    end
    if mickey_got_num ~= nil then
      msgParam.mickey_got_num = mickey_got_num
    end
    if get_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.get_items == nil then
        msgParam.get_items = {}
      end
      for i = 1, #get_items do
        table.insert(msgParam.get_items, get_items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallReceiveGuideRewardCmd(global_activity_id, mickey_reward_id)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.ReceiveGuideRewardCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if mickey_reward_id ~= nil then
      msg.mickey_reward_id = mickey_reward_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReceiveGuideRewardCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if mickey_reward_id ~= nil then
      msgParam.mickey_reward_id = mickey_reward_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallReceiveMickeyRewardCmd(global_activity_id, mickey_num)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.ReceiveMickeyRewardCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if mickey_num ~= nil then
      msg.mickey_num = mickey_num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReceiveMickeyRewardCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if mickey_num ~= nil then
      msgParam.mickey_num = mickey_num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyChallengeTaskRankCmd(global_activity_id, datas, user_point)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyChallengeTaskRankCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
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
    if user_point ~= nil then
      msg.user_point = user_point
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyChallengeTaskRankCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
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
    if user_point ~= nil then
      msgParam.user_point = user_point
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyChallengeTaskTipCmd(global_activity_id, datas)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyChallengeTaskTipCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
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
    local msgId = ProtoReqInfoList.DisneyChallengeTaskTipCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
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

function ServiceDisneyActivityAutoProxy:CallDisneyChallengeTaskPointCmd(global_activity_id, datas)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyChallengeTaskPointCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
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
    local msgId = ProtoReqInfoList.DisneyChallengeTaskPointCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
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

function ServiceDisneyActivityAutoProxy:CallDisneyChallengeTaskNotifyFirstFinishCmd(global_activity_id, quest_id, firstusername)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyChallengeTaskNotifyFirstFinishCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if quest_id ~= nil then
      msg.quest_id = quest_id
    end
    if firstusername ~= nil then
      msg.firstusername = firstusername
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyChallengeTaskNotifyFirstFinishCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if quest_id ~= nil then
      msgParam.quest_id = quest_id
    end
    if firstusername ~= nil then
      msgParam.firstusername = firstusername
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicOpenCmd(global_activity_id)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicOpenCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicOpenCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicUpdateCmd(data)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicUpdateCmd()
    if data ~= nil and data.globalactivityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.globalactivityid = data.globalactivityid
    end
    if data ~= nil and data.musicid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.musicid = data.musicid
    end
    if data ~= nil and data.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.status = data.status
    end
    if data ~= nil and data.members ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.members == nil then
        msg.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msg.data.members, data.members[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicUpdateCmd.id
    local msgParam = {}
    if data ~= nil and data.globalactivityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.globalactivityid = data.globalactivityid
    end
    if data ~= nil and data.musicid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.musicid = data.musicid
    end
    if data ~= nil and data.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.status = data.status
    end
    if data ~= nil and data.members ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.members == nil then
        msgParam.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msgParam.data.members, data.members[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicChooseHeroCmd(heroid)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicChooseHeroCmd()
    if heroid ~= nil then
      msg.heroid = heroid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicChooseHeroCmd.id
    local msgParam = {}
    if heroid ~= nil then
      msgParam.heroid = heroid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicPrepareCmd(prepare)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicPrepareCmd()
    if prepare ~= nil then
      msg.prepare = prepare
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicPrepareCmd.id
    local msgParam = {}
    if prepare ~= nil then
      msgParam.prepare = prepare
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicChooseMusicCmd(musicid)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicChooseMusicCmd()
    if musicid ~= nil then
      msg.musicid = musicid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicChooseMusicCmd.id
    local msgParam = {}
    if musicid ~= nil then
      msgParam.musicid = musicid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicStartCmd(starttime)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicStartCmd()
    if starttime ~= nil then
      msg.starttime = starttime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicStartCmd.id
    local msgParam = {}
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicFinishCmd(musicid, point, combo)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicFinishCmd()
    if musicid ~= nil then
      msg.musicid = musicid
    end
    if point ~= nil then
      msg.point = point
    end
    if combo ~= nil then
      msg.combo = combo
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicFinishCmd.id
    local msgParam = {}
    if musicid ~= nil then
      msgParam.musicid = musicid
    end
    if point ~= nil then
      msgParam.point = point
    end
    if combo ~= nil then
      msgParam.combo = combo
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:CallDisneyMusicResultCmd(datas)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicResultCmd()
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
    local msgId = ProtoReqInfoList.DisneyMusicResultCmd.id
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

function ServiceDisneyActivityAutoProxy:CallDisneyMusicRankCmd(global_activity_id, music_id, datas)
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicRankCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if music_id ~= nil then
      msg.music_id = music_id
    end
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
    local msgId = ProtoReqInfoList.DisneyMusicRankCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if music_id ~= nil then
      msgParam.music_id = music_id
    end
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

function ServiceDisneyActivityAutoProxy:CallDisneyMusicClientPrepareCmd()
  if not NetConfig.PBC then
    local msg = DisneyActivity_pb.DisneyMusicClientPrepareCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DisneyMusicClientPrepareCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDisneyActivityAutoProxy:RecvQueryDisneyGuideInfoCmd(data)
  self:Notify(ServiceEvent.DisneyActivityQueryDisneyGuideInfoCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvReceiveGuideRewardCmd(data)
  self:Notify(ServiceEvent.DisneyActivityReceiveGuideRewardCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvReceiveMickeyRewardCmd(data)
  self:Notify(ServiceEvent.DisneyActivityReceiveMickeyRewardCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyChallengeTaskRankCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskRankCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyChallengeTaskTipCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskTipCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyChallengeTaskPointCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskPointCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyChallengeTaskNotifyFirstFinishCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskNotifyFirstFinishCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicOpenCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicOpenCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicUpdateCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicUpdateCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicChooseHeroCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicChooseHeroCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicPrepareCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicPrepareCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicChooseMusicCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicChooseMusicCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicStartCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicStartCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicFinishCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicFinishCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicResultCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicResultCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicRankCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicRankCmd, data)
end

function ServiceDisneyActivityAutoProxy:RecvDisneyMusicClientPrepareCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicClientPrepareCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.DisneyActivityQueryDisneyGuideInfoCmd = "ServiceEvent_DisneyActivityQueryDisneyGuideInfoCmd"
ServiceEvent.DisneyActivityReceiveGuideRewardCmd = "ServiceEvent_DisneyActivityReceiveGuideRewardCmd"
ServiceEvent.DisneyActivityReceiveMickeyRewardCmd = "ServiceEvent_DisneyActivityReceiveMickeyRewardCmd"
ServiceEvent.DisneyActivityDisneyChallengeTaskRankCmd = "ServiceEvent_DisneyActivityDisneyChallengeTaskRankCmd"
ServiceEvent.DisneyActivityDisneyChallengeTaskTipCmd = "ServiceEvent_DisneyActivityDisneyChallengeTaskTipCmd"
ServiceEvent.DisneyActivityDisneyChallengeTaskPointCmd = "ServiceEvent_DisneyActivityDisneyChallengeTaskPointCmd"
ServiceEvent.DisneyActivityDisneyChallengeTaskNotifyFirstFinishCmd = "ServiceEvent_DisneyActivityDisneyChallengeTaskNotifyFirstFinishCmd"
ServiceEvent.DisneyActivityDisneyMusicOpenCmd = "ServiceEvent_DisneyActivityDisneyMusicOpenCmd"
ServiceEvent.DisneyActivityDisneyMusicUpdateCmd = "ServiceEvent_DisneyActivityDisneyMusicUpdateCmd"
ServiceEvent.DisneyActivityDisneyMusicChooseHeroCmd = "ServiceEvent_DisneyActivityDisneyMusicChooseHeroCmd"
ServiceEvent.DisneyActivityDisneyMusicPrepareCmd = "ServiceEvent_DisneyActivityDisneyMusicPrepareCmd"
ServiceEvent.DisneyActivityDisneyMusicChooseMusicCmd = "ServiceEvent_DisneyActivityDisneyMusicChooseMusicCmd"
ServiceEvent.DisneyActivityDisneyMusicStartCmd = "ServiceEvent_DisneyActivityDisneyMusicStartCmd"
ServiceEvent.DisneyActivityDisneyMusicFinishCmd = "ServiceEvent_DisneyActivityDisneyMusicFinishCmd"
ServiceEvent.DisneyActivityDisneyMusicResultCmd = "ServiceEvent_DisneyActivityDisneyMusicResultCmd"
ServiceEvent.DisneyActivityDisneyMusicRankCmd = "ServiceEvent_DisneyActivityDisneyMusicRankCmd"
ServiceEvent.DisneyActivityDisneyMusicClientPrepareCmd = "ServiceEvent_DisneyActivityDisneyMusicClientPrepareCmd"
