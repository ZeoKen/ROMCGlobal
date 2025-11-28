ServiceSceneUser3AutoProxy = class("ServiceSceneUser3AutoProxy", ServiceProxy)
ServiceSceneUser3AutoProxy.Instance = nil
ServiceSceneUser3AutoProxy.NAME = "ServiceSceneUser3AutoProxy"

function ServiceSceneUser3AutoProxy:ctor(proxyName)
  if ServiceSceneUser3AutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneUser3AutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneUser3AutoProxy.Instance = self
  end
end

function ServiceSceneUser3AutoProxy:Init()
end

function ServiceSceneUser3AutoProxy:onRegister()
  self:Listen(82, 1, function(data)
    self:RecvFirstDepositInfo(data)
  end)
  self:Listen(82, 2, function(data)
    self:RecvFirstDepositReward(data)
  end)
  self:Listen(82, 3, function(data)
    self:RecvClientPayLog(data)
  end)
  self:Listen(82, 4, function(data)
    self:RecvDailyDepositInfo(data)
  end)
  self:Listen(82, 5, function(data)
    self:RecvDailyDepositGetReward(data)
  end)
  self:Listen(82, 6, function(data)
    self:RecvBattleTimeCostSelectCmd(data)
  end)
  self:Listen(82, 9, function(data)
    self:RecvPlugInNotify(data)
  end)
  self:Listen(82, 10, function(data)
    self:RecvPlugInUpload(data)
  end)
  self:Listen(82, 15, function(data)
    self:RecvHeroStoryQuestInfo(data)
  end)
  self:Listen(82, 16, function(data)
    self:RecvHeroStoryQuestAccept(data)
  end)
  self:Listen(82, 14, function(data)
    self:RecvHeroQuestReward(data)
  end)
  self:Listen(82, 13, function(data)
    self:RecvHeroGrowthQuestInfo(data)
  end)
  self:Listen(82, 8, function(data)
    self:RecvQueryProfessionRecordSimpleData(data)
  end)
  self:Listen(82, 11, function(data)
    self:RecvHeroBuyUserCmd(data)
  end)
  self:Listen(82, 12, function(data)
    self:RecvHeroShowUserCmd(data)
  end)
  self:Listen(82, 17, function(data)
    self:RecvAccumDepositInfo(data)
  end)
  self:Listen(82, 18, function(data)
    self:RecvAccumDepositReward(data)
  end)
  self:Listen(82, 19, function(data)
    self:RecvBoliGoldGetReward(data)
  end)
  self:Listen(82, 20, function(data)
    self:RecvBoliGoldInfo(data)
  end)
  self:Listen(82, 21, function(data)
    self:RecvBoliGoldGetFreeReward(data)
  end)
  self:Listen(82, 22, function(data)
    self:RecvResourceCheckUserCmd(data)
  end)
  self:Listen(82, 24, function(data)
    self:RecvNoviceChargeSync(data)
  end)
  self:Listen(82, 25, function(data)
    self:RecvNoviceChargeReward(data)
  end)
  self:Listen(82, 27, function(data)
    self:RecvEquipPosEffectTime(data)
  end)
  self:Listen(82, 23, function(data)
    self:RecvUpdateRecordSlotIndex(data)
  end)
  self:Listen(82, 26, function(data)
    self:RecvSyncInterferenceData(data)
  end)
  self:Listen(82, 28, function(data)
    self:RecvGetResourceRewardCmd(data)
  end)
  self:Listen(82, 31, function(data)
    self:RecvAuthQueryUserCmd(data)
  end)
  self:Listen(82, 32, function(data)
    self:RecvAuthUpdateUserCmd(data)
  end)
  self:Listen(82, 33, function(data)
    self:RecvActionStatUserCmd(data)
  end)
  self:Listen(82, 29, function(data)
    self:RecvUnlockDress(data)
  end)
  self:Listen(82, 34, function(data)
    self:RecvQueryPrestigeCmd(data)
  end)
  self:Listen(82, 35, function(data)
    self:RecvPrestigeLevelUpNotifyCmd(data)
  end)
  self:Listen(82, 36, function(data)
    self:RecvSuperSignInUserCmd(data)
  end)
  self:Listen(82, 37, function(data)
    self:RecvSuperSignInNtfUserCmd(data)
  end)
  self:Listen(82, 38, function(data)
    self:RecvPrestigeRewardCmd(data)
  end)
  self:Listen(82, 39, function(data)
    self:RecvQueryQuestSignInfoUserCmd(data)
  end)
  self:Listen(82, 40, function(data)
    self:RecvLightFireworkUserCmd(data)
  end)
  self:Listen(82, 41, function(data)
    self:RecvRemoveFireworkUserCmd(data)
  end)
  self:Listen(82, 42, function(data)
    self:RecvQueryYearMemoryUserCmd(data)
  end)
  self:Listen(82, 43, function(data)
    self:RecvYearMemoryProcessUserCmd(data)
  end)
  self:Listen(82, 44, function(data)
    self:RecvSetYearMemoryTitleUserCmd(data)
  end)
  self:Listen(82, 45, function(data)
    self:RecvActivityExchangeGiftsQueryUserCmd(data)
  end)
  self:Listen(82, 46, function(data)
    self:RecvActivityExchangeGiftsRewardUserCmd(data)
  end)
  self:Listen(82, 47, function(data)
    self:RecvGvgExcellectQueryUserCmd(data)
  end)
  self:Listen(82, 49, function(data)
    self:RecvEffectInfoSyncUserCmd(data)
  end)
  self:Listen(82, 50, function(data)
    self:RecvEffectInfoUpdateUserCmd(data)
  end)
  self:Listen(82, 51, function(data)
    self:RecvEffectInfoUseUserCmd(data)
  end)
  self:Listen(82, 48, function(data)
    self:RecvGvgExcellectRewardUserCmd(data)
  end)
  self:Listen(82, 52, function(data)
    self:RecvBattleTimeOffUserCmd(data)
  end)
  self:Listen(82, 53, function(data)
    self:RecvPlayTimeOffUserCmd(data)
  end)
  self:Listen(82, 54, function(data)
    self:RecvWareHouseOperationCmd(data)
  end)
end

function ServiceSceneUser3AutoProxy:CallFirstDepositInfo(end_time, got_gear, accumlated_deposit, first_deposit_rewarded, version)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.FirstDepositInfo()
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if got_gear ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.got_gear == nil then
        msg.got_gear = {}
      end
      for i = 1, #got_gear do
        table.insert(msg.got_gear, got_gear[i])
      end
    end
    if accumlated_deposit ~= nil then
      msg.accumlated_deposit = accumlated_deposit
    end
    if first_deposit_rewarded ~= nil then
      msg.first_deposit_rewarded = first_deposit_rewarded
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FirstDepositInfo.id
    local msgParam = {}
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if got_gear ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.got_gear == nil then
        msgParam.got_gear = {}
      end
      for i = 1, #got_gear do
        table.insert(msgParam.got_gear, got_gear[i])
      end
    end
    if accumlated_deposit ~= nil then
      msgParam.accumlated_deposit = accumlated_deposit
    end
    if first_deposit_rewarded ~= nil then
      msgParam.first_deposit_rewarded = first_deposit_rewarded
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallFirstDepositReward(first_deposit_reward, gear)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.FirstDepositReward()
    if first_deposit_reward ~= nil then
      msg.first_deposit_reward = first_deposit_reward
    end
    if gear ~= nil then
      msg.gear = gear
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FirstDepositReward.id
    local msgParam = {}
    if first_deposit_reward ~= nil then
      msgParam.first_deposit_reward = first_deposit_reward
    end
    if gear ~= nil then
      msgParam.gear = gear
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallClientPayLog(event_id, event_param)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ClientPayLog()
    if event_id ~= nil then
      msg.event_id = event_id
    end
    if event_param ~= nil then
      msg.event_param = event_param
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientPayLog.id
    local msgParam = {}
    if event_id ~= nil then
      msgParam.event_id = event_id
    end
    if event_param ~= nil then
      msgParam.event_param = event_param
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallDailyDepositInfo(version, deposit_gold, start_time, end_time, gotten_rewards)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.DailyDepositInfo()
    if version ~= nil then
      msg.version = version
    end
    if deposit_gold ~= nil then
      msg.deposit_gold = deposit_gold
    end
    if start_time ~= nil then
      msg.start_time = start_time
    end
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if gotten_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gotten_rewards == nil then
        msg.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msg.gotten_rewards, gotten_rewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DailyDepositInfo.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    if deposit_gold ~= nil then
      msgParam.deposit_gold = deposit_gold
    end
    if start_time ~= nil then
      msgParam.start_time = start_time
    end
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if gotten_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gotten_rewards == nil then
        msgParam.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msgParam.gotten_rewards, gotten_rewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallDailyDepositGetReward(reward_index, version)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.DailyDepositGetReward()
    if reward_index ~= nil then
      msg.reward_index = reward_index
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DailyDepositGetReward.id
    local msgParam = {}
    if reward_index ~= nil then
      msgParam.reward_index = reward_index
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallBattleTimeCostSelectCmd(ecost)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BattleTimeCostSelectCmd()
    if ecost ~= nil then
      msg.ecost = ecost
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattleTimeCostSelectCmd.id
    local msgParam = {}
    if ecost ~= nil then
      msgParam.ecost = ecost
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallPlugInNotify(infos, detectinterval)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PlugInNotify()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if detectinterval ~= nil then
      msg.detectinterval = detectinterval
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlugInNotify.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if detectinterval ~= nil then
      msgParam.detectinterval = detectinterval
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallPlugInUpload(infos, flag)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PlugInUpload()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if flag ~= nil then
      msg.flag = flag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlugInUpload.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if flag ~= nil then
      msgParam.flag = flag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallHeroStoryQuestInfo(profession_data)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroStoryQuestInfo()
    if profession_data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profession_data == nil then
        msg.profession_data = {}
      end
      for i = 1, #profession_data do
        table.insert(msg.profession_data, profession_data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroStoryQuestInfo.id
    local msgParam = {}
    if profession_data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profession_data == nil then
        msgParam.profession_data = {}
      end
      for i = 1, #profession_data do
        table.insert(msgParam.profession_data, profession_data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallHeroStoryQuestAccept(id, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroStoryQuestAccept()
    if id ~= nil then
      msg.id = id
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroStoryQuestAccept.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallHeroQuestReward(id, profession, extra_reward_complete_num, type, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroQuestReward()
    if id ~= nil then
      msg.id = id
    end
    if profession ~= nil then
      msg.profession = profession
    end
    if extra_reward_complete_num ~= nil then
      msg.extra_reward_complete_num = extra_reward_complete_num
    end
    if type ~= nil then
      msg.type = type
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroQuestReward.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if profession ~= nil then
      msgParam.profession = profession
    end
    if extra_reward_complete_num ~= nil then
      msgParam.extra_reward_complete_num = extra_reward_complete_num
    end
    if type ~= nil then
      msgParam.type = type
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallHeroGrowthQuestInfo(profession, growth_quests, extra_rewarded_id)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroGrowthQuestInfo()
    if profession ~= nil then
      msg.profession = profession
    end
    if growth_quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.growth_quests == nil then
        msg.growth_quests = {}
      end
      for i = 1, #growth_quests do
        table.insert(msg.growth_quests, growth_quests[i])
      end
    end
    if extra_rewarded_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extra_rewarded_id == nil then
        msg.extra_rewarded_id = {}
      end
      for i = 1, #extra_rewarded_id do
        table.insert(msg.extra_rewarded_id, extra_rewarded_id[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroGrowthQuestInfo.id
    local msgParam = {}
    if profession ~= nil then
      msgParam.profession = profession
    end
    if growth_quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.growth_quests == nil then
        msgParam.growth_quests = {}
      end
      for i = 1, #growth_quests do
        table.insert(msgParam.growth_quests, growth_quests[i])
      end
    end
    if extra_rewarded_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extra_rewarded_id == nil then
        msgParam.extra_rewarded_id = {}
      end
      for i = 1, #extra_rewarded_id do
        table.insert(msgParam.extra_rewarded_id, extra_rewarded_id[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallQueryProfessionRecordSimpleData(records)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.QueryProfessionRecordSimpleData()
    if records ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.records == nil then
        msg.records = {}
      end
      for i = 1, #records do
        table.insert(msg.records, records[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryProfessionRecordSimpleData.id
    local msgParam = {}
    if records ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.records == nil then
        msgParam.records = {}
      end
      for i = 1, #records do
        table.insert(msgParam.records, records[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallHeroBuyUserCmd(branch, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroBuyUserCmd()
    if branch ~= nil then
      msg.branch = branch
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroBuyUserCmd.id
    local msgParam = {}
    if branch ~= nil then
      msgParam.branch = branch
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallHeroShowUserCmd(infos)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroShowUserCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroShowUserCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallAccumDepositInfo(cur_act, accumlated_deposit, gotten_rewards, end_time)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.AccumDepositInfo()
    if cur_act ~= nil then
      msg.cur_act = cur_act
    end
    if accumlated_deposit ~= nil then
      msg.accumlated_deposit = accumlated_deposit
    end
    if gotten_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gotten_rewards == nil then
        msg.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msg.gotten_rewards, gotten_rewards[i])
      end
    end
    if end_time ~= nil then
      msg.end_time = end_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AccumDepositInfo.id
    local msgParam = {}
    if cur_act ~= nil then
      msgParam.cur_act = cur_act
    end
    if accumlated_deposit ~= nil then
      msgParam.accumlated_deposit = accumlated_deposit
    end
    if gotten_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gotten_rewards == nil then
        msgParam.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msgParam.gotten_rewards, gotten_rewards[i])
      end
    end
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallAccumDepositReward(get_reward)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.AccumDepositReward()
    if get_reward ~= nil then
      msg.get_reward = get_reward
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AccumDepositReward.id
    local msgParam = {}
    if get_reward ~= nil then
      msgParam.get_reward = get_reward
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallBoliGoldGetReward(select, reward, rest_key)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BoliGoldGetReward()
    if select ~= nil then
      msg.select = select
    end
    if reward ~= nil then
      msg.reward = reward
    end
    if rest_key ~= nil then
      msg.rest_key = rest_key
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoliGoldGetReward.id
    local msgParam = {}
    if select ~= nil then
      msgParam.select = select
    end
    if reward ~= nil then
      msgParam.reward = reward
    end
    if rest_key ~= nil then
      msgParam.rest_key = rest_key
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallBoliGoldInfo(act_id, deposit_gold, selected, gotten_rewards, rest_key, free_reward_gotten)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BoliGoldInfo()
    if act_id ~= nil then
      msg.act_id = act_id
    end
    if deposit_gold ~= nil then
      msg.deposit_gold = deposit_gold
    end
    if selected ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.selected == nil then
        msg.selected = {}
      end
      for i = 1, #selected do
        table.insert(msg.selected, selected[i])
      end
    end
    if gotten_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gotten_rewards == nil then
        msg.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msg.gotten_rewards, gotten_rewards[i])
      end
    end
    if rest_key ~= nil then
      msg.rest_key = rest_key
    end
    if free_reward_gotten ~= nil then
      msg.free_reward_gotten = free_reward_gotten
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoliGoldInfo.id
    local msgParam = {}
    if act_id ~= nil then
      msgParam.act_id = act_id
    end
    if deposit_gold ~= nil then
      msgParam.deposit_gold = deposit_gold
    end
    if selected ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.selected == nil then
        msgParam.selected = {}
      end
      for i = 1, #selected do
        table.insert(msgParam.selected, selected[i])
      end
    end
    if gotten_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gotten_rewards == nil then
        msgParam.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msgParam.gotten_rewards, gotten_rewards[i])
      end
    end
    if rest_key ~= nil then
      msgParam.rest_key = rest_key
    end
    if free_reward_gotten ~= nil then
      msgParam.free_reward_gotten = free_reward_gotten
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallBoliGoldGetFreeReward()
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BoliGoldGetFreeReward()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoliGoldGetFreeReward.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallResourceCheckUserCmd(resources, uploadinfo)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ResourceCheckUserCmd()
    if resources ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.resources == nil then
        msg.resources = {}
      end
      for i = 1, #resources do
        table.insert(msg.resources, resources[i])
      end
    end
    if uploadinfo ~= nil and uploadinfo.cmd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.cmd = uploadinfo.cmd
    end
    if uploadinfo ~= nil and uploadinfo.param ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.param = uploadinfo.param
    end
    if uploadinfo ~= nil and uploadinfo.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.type = uploadinfo.type
    end
    if uploadinfo ~= nil and uploadinfo.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.id = uploadinfo.id
    end
    if uploadinfo ~= nil and uploadinfo.customparam ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.customparam = uploadinfo.customparam
    end
    if uploadinfo ~= nil and uploadinfo.path ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.path = uploadinfo.path
    end
    if uploadinfo ~= nil and uploadinfo.params ~= nil then
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      if msg.uploadinfo.params == nil then
        msg.uploadinfo.params = {}
      end
      for i = 1, #uploadinfo.params do
        table.insert(msg.uploadinfo.params, uploadinfo.params[i])
      end
    end
    if uploadinfo ~= nil and uploadinfo.useaws ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.uploadinfo == nil then
        msg.uploadinfo = {}
      end
      msg.uploadinfo.useaws = uploadinfo.useaws
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResourceCheckUserCmd.id
    local msgParam = {}
    if resources ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.resources == nil then
        msgParam.resources = {}
      end
      for i = 1, #resources do
        table.insert(msgParam.resources, resources[i])
      end
    end
    if uploadinfo ~= nil and uploadinfo.cmd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.cmd = uploadinfo.cmd
    end
    if uploadinfo ~= nil and uploadinfo.param ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.param = uploadinfo.param
    end
    if uploadinfo ~= nil and uploadinfo.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.type = uploadinfo.type
    end
    if uploadinfo ~= nil and uploadinfo.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.id = uploadinfo.id
    end
    if uploadinfo ~= nil and uploadinfo.customparam ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.customparam = uploadinfo.customparam
    end
    if uploadinfo ~= nil and uploadinfo.path ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.path = uploadinfo.path
    end
    if uploadinfo ~= nil and uploadinfo.params ~= nil then
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      if msgParam.uploadinfo.params == nil then
        msgParam.uploadinfo.params = {}
      end
      for i = 1, #uploadinfo.params do
        table.insert(msgParam.uploadinfo.params, uploadinfo.params[i])
      end
    end
    if uploadinfo ~= nil and uploadinfo.useaws ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.uploadinfo == nil then
        msgParam.uploadinfo = {}
      end
      msgParam.uploadinfo.useaws = uploadinfo.useaws
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallNoviceChargeSync(end_time, act_id, items)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.NoviceChargeSync()
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if act_id ~= nil then
      msg.act_id = act_id
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
    local msgId = ProtoReqInfoList.NoviceChargeSync.id
    local msgParam = {}
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if act_id ~= nil then
      msgParam.act_id = act_id
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

function ServiceSceneUser3AutoProxy:CallNoviceChargeReward(item_id)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.NoviceChargeReward()
    if item_id ~= nil then
      msg.item_id = item_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceChargeReward.id
    local msgParam = {}
    if item_id ~= nil then
      msgParam.item_id = item_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallEquipPosEffectTime(type, pos, end_time, total_cd)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.EquipPosEffectTime()
    if type ~= nil then
      msg.type = type
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if total_cd ~= nil then
      msg.total_cd = total_cd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPosEffectTime.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if total_cd ~= nil then
      msgParam.total_cd = total_cd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallUpdateRecordSlotIndex(slot_indexs)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.UpdateRecordSlotIndex()
    if slot_indexs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.slot_indexs == nil then
        msg.slot_indexs = {}
      end
      for i = 1, #slot_indexs do
        table.insert(msg.slot_indexs, slot_indexs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateRecordSlotIndex.id
    local msgParam = {}
    if slot_indexs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.slot_indexs == nil then
        msgParam.slot_indexs = {}
      end
      for i = 1, #slot_indexs do
        table.insert(msgParam.slot_indexs, slot_indexs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallSyncInterferenceData(adds, reduces, tar_reduces)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.SyncInterferenceData()
    if adds ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.adds == nil then
        msg.adds = {}
      end
      for i = 1, #adds do
        table.insert(msg.adds, adds[i])
      end
    end
    if reduces ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reduces == nil then
        msg.reduces = {}
      end
      for i = 1, #reduces do
        table.insert(msg.reduces, reduces[i])
      end
    end
    if tar_reduces ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.tar_reduces == nil then
        msg.tar_reduces = {}
      end
      for i = 1, #tar_reduces do
        table.insert(msg.tar_reduces, tar_reduces[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncInterferenceData.id
    local msgParam = {}
    if adds ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.adds == nil then
        msgParam.adds = {}
      end
      for i = 1, #adds do
        table.insert(msgParam.adds, adds[i])
      end
    end
    if reduces ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reduces == nil then
        msgParam.reduces = {}
      end
      for i = 1, #reduces do
        table.insert(msgParam.reduces, reduces[i])
      end
    end
    if tar_reduces ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.tar_reduces == nil then
        msgParam.tar_reduces = {}
      end
      for i = 1, #tar_reduces do
        table.insert(msgParam.tar_reduces, tar_reduces[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallGetResourceRewardCmd()
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.GetResourceRewardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetResourceRewardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallAuthQueryUserCmd(auths)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.AuthQueryUserCmd()
    if auths ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.auths == nil then
        msg.auths = {}
      end
      for i = 1, #auths do
        table.insert(msg.auths, auths[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuthQueryUserCmd.id
    local msgParam = {}
    if auths ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.auths == nil then
        msgParam.auths = {}
      end
      for i = 1, #auths do
        table.insert(msgParam.auths, auths[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallAuthUpdateUserCmd(auth, code, verify)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.AuthUpdateUserCmd()
    if auth ~= nil and auth.auth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.auth == nil then
        msg.auth = {}
      end
      msg.auth.auth = auth.auth
    end
    if auth ~= nil and auth.content ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.auth == nil then
        msg.auth = {}
      end
      msg.auth.content = auth.content
    end
    if auth ~= nil and auth.updatetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.auth == nil then
        msg.auth = {}
      end
      msg.auth.updatetime = auth.updatetime
    end
    if code ~= nil then
      msg.code = code
    end
    if verify ~= nil then
      msg.verify = verify
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuthUpdateUserCmd.id
    local msgParam = {}
    if auth ~= nil and auth.auth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.auth == nil then
        msgParam.auth = {}
      end
      msgParam.auth.auth = auth.auth
    end
    if auth ~= nil and auth.content ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.auth == nil then
        msgParam.auth = {}
      end
      msgParam.auth.content = auth.content
    end
    if auth ~= nil and auth.updatetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.auth == nil then
        msgParam.auth = {}
      end
      msgParam.auth.updatetime = auth.updatetime
    end
    if code ~= nil then
      msgParam.code = code
    end
    if verify ~= nil then
      msgParam.verify = verify
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallActionStatUserCmd(actiontype, param1, param2)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ActionStatUserCmd()
    if actiontype ~= nil then
      msg.actiontype = actiontype
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    if param2 ~= nil then
      msg.param2 = param2
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActionStatUserCmd.id
    local msgParam = {}
    if actiontype ~= nil then
      msgParam.actiontype = actiontype
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    if param2 ~= nil then
      msgParam.param2 = param2
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallUnlockDress(dress_type, style_id)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.UnlockDress()
    if dress_type ~= nil then
      msg.dress_type = dress_type
    end
    if style_id ~= nil then
      msg.style_id = style_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockDress.id
    local msgParam = {}
    if dress_type ~= nil then
      msgParam.dress_type = dress_type
    end
    if style_id ~= nil then
      msgParam.style_id = style_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallQueryPrestigeCmd(type, level, value, cond_datas, rewarded_levels, day_num_from_limit)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.QueryPrestigeCmd()
    if type ~= nil then
      msg.type = type
    end
    if level ~= nil then
      msg.level = level
    end
    if value ~= nil then
      msg.value = value
    end
    if cond_datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cond_datas == nil then
        msg.cond_datas = {}
      end
      for i = 1, #cond_datas do
        table.insert(msg.cond_datas, cond_datas[i])
      end
    end
    if rewarded_levels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarded_levels == nil then
        msg.rewarded_levels = {}
      end
      for i = 1, #rewarded_levels do
        table.insert(msg.rewarded_levels, rewarded_levels[i])
      end
    end
    if day_num_from_limit ~= nil then
      msg.day_num_from_limit = day_num_from_limit
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPrestigeCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if level ~= nil then
      msgParam.level = level
    end
    if value ~= nil then
      msgParam.value = value
    end
    if cond_datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cond_datas == nil then
        msgParam.cond_datas = {}
      end
      for i = 1, #cond_datas do
        table.insert(msgParam.cond_datas, cond_datas[i])
      end
    end
    if rewarded_levels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarded_levels == nil then
        msgParam.rewarded_levels = {}
      end
      for i = 1, #rewarded_levels do
        table.insert(msgParam.rewarded_levels, rewarded_levels[i])
      end
    end
    if day_num_from_limit ~= nil then
      msgParam.day_num_from_limit = day_num_from_limit
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallPrestigeLevelUpNotifyCmd(type, origin_level, new_level, origin_value, new_value)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PrestigeLevelUpNotifyCmd()
    if type ~= nil then
      msg.type = type
    end
    if origin_level ~= nil then
      msg.origin_level = origin_level
    end
    if new_level ~= nil then
      msg.new_level = new_level
    end
    if origin_value ~= nil then
      msg.origin_value = origin_value
    end
    if new_value ~= nil then
      msg.new_value = new_value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrestigeLevelUpNotifyCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if origin_level ~= nil then
      msgParam.origin_level = origin_level
    end
    if new_level ~= nil then
      msgParam.new_level = new_level
    end
    if origin_value ~= nil then
      msgParam.origin_value = origin_value
    end
    if new_value ~= nil then
      msgParam.new_value = new_value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallSuperSignInUserCmd(sign)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.SuperSignInUserCmd()
    if sign ~= nil and sign.actid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sign == nil then
        msg.sign = {}
      end
      msg.sign.actid = sign.actid
    end
    if sign ~= nil and sign.day ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sign == nil then
        msg.sign = {}
      end
      msg.sign.day = sign.day
    end
    if sign ~= nil and sign.last_sign_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sign == nil then
        msg.sign = {}
      end
      msg.sign.last_sign_time = sign.last_sign_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SuperSignInUserCmd.id
    local msgParam = {}
    if sign ~= nil and sign.actid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sign == nil then
        msgParam.sign = {}
      end
      msgParam.sign.actid = sign.actid
    end
    if sign ~= nil and sign.day ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sign == nil then
        msgParam.sign = {}
      end
      msgParam.sign.day = sign.day
    end
    if sign ~= nil and sign.last_sign_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sign == nil then
        msgParam.sign = {}
      end
      msgParam.sign.last_sign_time = sign.last_sign_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallSuperSignInNtfUserCmd(data)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.SuperSignInNtfUserCmd()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SuperSignInNtfUserCmd.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallPrestigeRewardCmd(type, level)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PrestigeRewardCmd()
    if type ~= nil then
      msg.type = type
    end
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrestigeRewardCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallQueryQuestSignInfoUserCmd(groupid, data)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.QueryQuestSignInfoUserCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryQuestSignInfoUserCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallLightFireworkUserCmd()
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.LightFireworkUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LightFireworkUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallRemoveFireworkUserCmd(guid)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.RemoveFireworkUserCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RemoveFireworkUserCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallQueryYearMemoryUserCmd(year, datas)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.QueryYearMemoryUserCmd()
    if year ~= nil then
      msg.year = year
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
    local msgId = ProtoReqInfoList.QueryYearMemoryUserCmd.id
    local msgParam = {}
    if year ~= nil then
      msgParam.year = year
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

function ServiceSceneUser3AutoProxy:CallYearMemoryProcessUserCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.YearMemoryProcessUserCmd()
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
    local msgId = ProtoReqInfoList.YearMemoryProcessUserCmd.id
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

function ServiceSceneUser3AutoProxy:CallSetYearMemoryTitleUserCmd(year, title_id, keypoint_ids)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.SetYearMemoryTitleUserCmd()
    if year ~= nil then
      msg.year = year
    end
    if title_id ~= nil then
      msg.title_id = title_id
    end
    if keypoint_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.keypoint_ids == nil then
        msg.keypoint_ids = {}
      end
      for i = 1, #keypoint_ids do
        table.insert(msg.keypoint_ids, keypoint_ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetYearMemoryTitleUserCmd.id
    local msgParam = {}
    if year ~= nil then
      msgParam.year = year
    end
    if title_id ~= nil then
      msgParam.title_id = title_id
    end
    if keypoint_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.keypoint_ids == nil then
        msgParam.keypoint_ids = {}
      end
      for i = 1, #keypoint_ids do
        table.insert(msgParam.keypoint_ids, keypoint_ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallActivityExchangeGiftsQueryUserCmd(activityid, times, gifts_info)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ActivityExchangeGiftsQueryUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if times ~= nil then
      msg.times = times
    end
    if gifts_info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gifts_info == nil then
        msg.gifts_info = {}
      end
      for i = 1, #gifts_info do
        table.insert(msg.gifts_info, gifts_info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityExchangeGiftsQueryUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if times ~= nil then
      msgParam.times = times
    end
    if gifts_info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gifts_info == nil then
        msgParam.gifts_info = {}
      end
      for i = 1, #gifts_info do
        table.insert(msgParam.gifts_info, gifts_info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallActivityExchangeGiftsRewardUserCmd(activityid, itemcost, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ActivityExchangeGiftsRewardUserCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if itemcost ~= nil and itemcost.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.guid = itemcost.guid
    end
    if itemcost ~= nil and itemcost.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.id = itemcost.id
    end
    if itemcost ~= nil and itemcost.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.count = itemcost.count
    end
    if itemcost ~= nil and itemcost.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.index = itemcost.index
    end
    if itemcost ~= nil and itemcost.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.createtime = itemcost.createtime
    end
    if itemcost ~= nil and itemcost.cd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.cd = itemcost.cd
    end
    if itemcost ~= nil and itemcost.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.type = itemcost.type
    end
    if itemcost ~= nil and itemcost.bind ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.bind = itemcost.bind
    end
    if itemcost ~= nil and itemcost.expire ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.expire = itemcost.expire
    end
    if itemcost ~= nil and itemcost.quality ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.quality = itemcost.quality
    end
    if itemcost ~= nil and itemcost.equipType ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.equipType = itemcost.equipType
    end
    if itemcost ~= nil and itemcost.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.source = itemcost.source
    end
    if itemcost ~= nil and itemcost.isnew ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.isnew = itemcost.isnew
    end
    if itemcost ~= nil and itemcost.maxcardslot ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.maxcardslot = itemcost.maxcardslot
    end
    if itemcost ~= nil and itemcost.ishint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.ishint = itemcost.ishint
    end
    if itemcost ~= nil and itemcost.isactive ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.isactive = itemcost.isactive
    end
    if itemcost ~= nil and itemcost.source_npc ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.source_npc = itemcost.source_npc
    end
    if itemcost ~= nil and itemcost.refinelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.refinelv = itemcost.refinelv
    end
    if itemcost ~= nil and itemcost.chargemoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.chargemoney = itemcost.chargemoney
    end
    if itemcost ~= nil and itemcost.overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.overtime = itemcost.overtime
    end
    if itemcost ~= nil and itemcost.quota ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.quota = itemcost.quota
    end
    if itemcost ~= nil and itemcost.usedtimes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.usedtimes = itemcost.usedtimes
    end
    if itemcost ~= nil and itemcost.usedtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.usedtime = itemcost.usedtime
    end
    if itemcost ~= nil and itemcost.isfavorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.isfavorite = itemcost.isfavorite
    end
    if itemcost ~= nil and itemcost.mailhint ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.mailhint == nil then
        msg.itemcost.mailhint = {}
      end
      for i = 1, #itemcost.mailhint do
        table.insert(msg.itemcost.mailhint, itemcost.mailhint[i])
      end
    end
    if itemcost ~= nil and itemcost.subsource ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.subsource = itemcost.subsource
    end
    if itemcost ~= nil and itemcost.randkey ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.randkey = itemcost.randkey
    end
    if itemcost ~= nil and itemcost.sceneinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.sceneinfo = itemcost.sceneinfo
    end
    if itemcost ~= nil and itemcost.local_charge ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.local_charge = itemcost.local_charge
    end
    if itemcost ~= nil and itemcost.charge_deposit_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.charge_deposit_id = itemcost.charge_deposit_id
    end
    if itemcost ~= nil and itemcost.issplit ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.issplit = itemcost.issplit
    end
    if itemcost.tmp ~= nil and itemcost.tmp.none ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.tmp == nil then
        msg.itemcost.tmp = {}
      end
      msg.itemcost.tmp.none = itemcost.tmp.none
    end
    if itemcost.tmp ~= nil and itemcost.tmp.num_param ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.tmp == nil then
        msg.itemcost.tmp = {}
      end
      msg.itemcost.tmp.num_param = itemcost.tmp.num_param
    end
    if itemcost.tmp ~= nil and itemcost.tmp.from_reward ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.tmp == nil then
        msg.itemcost.tmp = {}
      end
      msg.itemcost.tmp.from_reward = itemcost.tmp.from_reward
    end
    if itemcost ~= nil and itemcost.mount_fashion_activated ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.mount_fashion_activated = itemcost.mount_fashion_activated
    end
    if itemcost ~= nil and itemcost.no_trade_reason ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      msg.itemcost.no_trade_reason = itemcost.no_trade_reason
    end
    if itemcost.card_info ~= nil and itemcost.card_info.lv ~= nil then
      if msg.itemcost == nil then
        msg.itemcost = {}
      end
      if msg.itemcost.card_info == nil then
        msg.itemcost.card_info = {}
      end
      msg.itemcost.card_info.lv = itemcost.card_info.lv
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityExchangeGiftsRewardUserCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if itemcost ~= nil and itemcost.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.guid = itemcost.guid
    end
    if itemcost ~= nil and itemcost.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.id = itemcost.id
    end
    if itemcost ~= nil and itemcost.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.count = itemcost.count
    end
    if itemcost ~= nil and itemcost.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.index = itemcost.index
    end
    if itemcost ~= nil and itemcost.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.createtime = itemcost.createtime
    end
    if itemcost ~= nil and itemcost.cd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.cd = itemcost.cd
    end
    if itemcost ~= nil and itemcost.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.type = itemcost.type
    end
    if itemcost ~= nil and itemcost.bind ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.bind = itemcost.bind
    end
    if itemcost ~= nil and itemcost.expire ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.expire = itemcost.expire
    end
    if itemcost ~= nil and itemcost.quality ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.quality = itemcost.quality
    end
    if itemcost ~= nil and itemcost.equipType ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.equipType = itemcost.equipType
    end
    if itemcost ~= nil and itemcost.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.source = itemcost.source
    end
    if itemcost ~= nil and itemcost.isnew ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.isnew = itemcost.isnew
    end
    if itemcost ~= nil and itemcost.maxcardslot ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.maxcardslot = itemcost.maxcardslot
    end
    if itemcost ~= nil and itemcost.ishint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.ishint = itemcost.ishint
    end
    if itemcost ~= nil and itemcost.isactive ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.isactive = itemcost.isactive
    end
    if itemcost ~= nil and itemcost.source_npc ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.source_npc = itemcost.source_npc
    end
    if itemcost ~= nil and itemcost.refinelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.refinelv = itemcost.refinelv
    end
    if itemcost ~= nil and itemcost.chargemoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.chargemoney = itemcost.chargemoney
    end
    if itemcost ~= nil and itemcost.overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.overtime = itemcost.overtime
    end
    if itemcost ~= nil and itemcost.quota ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.quota = itemcost.quota
    end
    if itemcost ~= nil and itemcost.usedtimes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.usedtimes = itemcost.usedtimes
    end
    if itemcost ~= nil and itemcost.usedtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.usedtime = itemcost.usedtime
    end
    if itemcost ~= nil and itemcost.isfavorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.isfavorite = itemcost.isfavorite
    end
    if itemcost ~= nil and itemcost.mailhint ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.mailhint == nil then
        msgParam.itemcost.mailhint = {}
      end
      for i = 1, #itemcost.mailhint do
        table.insert(msgParam.itemcost.mailhint, itemcost.mailhint[i])
      end
    end
    if itemcost ~= nil and itemcost.subsource ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.subsource = itemcost.subsource
    end
    if itemcost ~= nil and itemcost.randkey ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.randkey = itemcost.randkey
    end
    if itemcost ~= nil and itemcost.sceneinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.sceneinfo = itemcost.sceneinfo
    end
    if itemcost ~= nil and itemcost.local_charge ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.local_charge = itemcost.local_charge
    end
    if itemcost ~= nil and itemcost.charge_deposit_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.charge_deposit_id = itemcost.charge_deposit_id
    end
    if itemcost ~= nil and itemcost.issplit ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.issplit = itemcost.issplit
    end
    if itemcost.tmp ~= nil and itemcost.tmp.none ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.tmp == nil then
        msgParam.itemcost.tmp = {}
      end
      msgParam.itemcost.tmp.none = itemcost.tmp.none
    end
    if itemcost.tmp ~= nil and itemcost.tmp.num_param ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.tmp == nil then
        msgParam.itemcost.tmp = {}
      end
      msgParam.itemcost.tmp.num_param = itemcost.tmp.num_param
    end
    if itemcost.tmp ~= nil and itemcost.tmp.from_reward ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.tmp == nil then
        msgParam.itemcost.tmp = {}
      end
      msgParam.itemcost.tmp.from_reward = itemcost.tmp.from_reward
    end
    if itemcost ~= nil and itemcost.mount_fashion_activated ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.mount_fashion_activated = itemcost.mount_fashion_activated
    end
    if itemcost ~= nil and itemcost.no_trade_reason ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      msgParam.itemcost.no_trade_reason = itemcost.no_trade_reason
    end
    if itemcost.card_info ~= nil and itemcost.card_info.lv ~= nil then
      if msgParam.itemcost == nil then
        msgParam.itemcost = {}
      end
      if msgParam.itemcost.card_info == nil then
        msgParam.itemcost.card_info = {}
      end
      msgParam.itemcost.card_info.lv = itemcost.card_info.lv
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallGvgExcellectQueryUserCmd(rewardid, leisure)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.GvgExcellectQueryUserCmd()
    if rewardid ~= nil then
      msg.rewardid = rewardid
    end
    if leisure ~= nil then
      msg.leisure = leisure
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgExcellectQueryUserCmd.id
    local msgParam = {}
    if rewardid ~= nil then
      msgParam.rewardid = rewardid
    end
    if leisure ~= nil then
      msgParam.leisure = leisure
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallEffectInfoSyncUserCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.EffectInfoSyncUserCmd()
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
    local msgId = ProtoReqInfoList.EffectInfoSyncUserCmd.id
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

function ServiceSceneUser3AutoProxy:CallEffectInfoUpdateUserCmd(type, datas, del)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.EffectInfoUpdateUserCmd()
    if type ~= nil then
      msg.type = type
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
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EffectInfoUpdateUserCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
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
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallEffectInfoUseUserCmd(id, type)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.EffectInfoUseUserCmd()
    if id ~= nil then
      msg.id = id
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EffectInfoUseUserCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallGvgExcellectRewardUserCmd(rewardid)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.GvgExcellectRewardUserCmd()
    if rewardid ~= nil then
      msg.rewardid = rewardid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgExcellectRewardUserCmd.id
    local msgParam = {}
    if rewardid ~= nil then
      msgParam.rewardid = rewardid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallBattleTimeOffUserCmd(off, cd)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BattleTimeOffUserCmd()
    if off ~= nil then
      msg.off = off
    end
    if cd ~= nil then
      msg.cd = cd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattleTimeOffUserCmd.id
    local msgParam = {}
    if off ~= nil then
      msgParam.off = off
    end
    if cd ~= nil then
      msgParam.cd = cd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallPlayTimeOffUserCmd(off)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PlayTimeOffUserCmd()
    if off ~= nil then
      msg.off = off
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlayTimeOffUserCmd.id
    local msgParam = {}
    if off ~= nil then
      msgParam.off = off
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:CallWareHouseOperationCmd(opr, guid)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.WareHouseOperationCmd()
    if opr ~= nil then
      msg.opr = opr
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WareHouseOperationCmd.id
    local msgParam = {}
    if opr ~= nil then
      msgParam.opr = opr
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneUser3AutoProxy:RecvFirstDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositInfo, data)
end

function ServiceSceneUser3AutoProxy:RecvFirstDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositReward, data)
end

function ServiceSceneUser3AutoProxy:RecvClientPayLog(data)
  self:Notify(ServiceEvent.SceneUser3ClientPayLog, data)
end

function ServiceSceneUser3AutoProxy:RecvDailyDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3DailyDepositInfo, data)
end

function ServiceSceneUser3AutoProxy:RecvDailyDepositGetReward(data)
  self:Notify(ServiceEvent.SceneUser3DailyDepositGetReward, data)
end

function ServiceSceneUser3AutoProxy:RecvBattleTimeCostSelectCmd(data)
  self:Notify(ServiceEvent.SceneUser3BattleTimeCostSelectCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvPlugInNotify(data)
  self:Notify(ServiceEvent.SceneUser3PlugInNotify, data)
end

function ServiceSceneUser3AutoProxy:RecvPlugInUpload(data)
  self:Notify(ServiceEvent.SceneUser3PlugInUpload, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroStoryQuestInfo(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestInfo, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroStoryQuestAccept(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestAccept, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroQuestReward(data)
  self:Notify(ServiceEvent.SceneUser3HeroQuestReward, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroGrowthQuestInfo(data)
  self:Notify(ServiceEvent.SceneUser3HeroGrowthQuestInfo, data)
end

function ServiceSceneUser3AutoProxy:RecvQueryProfessionRecordSimpleData(data)
  self:Notify(ServiceEvent.SceneUser3QueryProfessionRecordSimpleData, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroBuyUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3HeroBuyUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroShowUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3HeroShowUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvAccumDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositInfo, data)
end

function ServiceSceneUser3AutoProxy:RecvAccumDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositReward, data)
end

function ServiceSceneUser3AutoProxy:RecvBoliGoldGetReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetReward, data)
end

function ServiceSceneUser3AutoProxy:RecvBoliGoldInfo(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldInfo, data)
end

function ServiceSceneUser3AutoProxy:RecvBoliGoldGetFreeReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetFreeReward, data)
end

function ServiceSceneUser3AutoProxy:RecvResourceCheckUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ResourceCheckUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvNoviceChargeSync(data)
  self:Notify(ServiceEvent.SceneUser3NoviceChargeSync, data)
end

function ServiceSceneUser3AutoProxy:RecvNoviceChargeReward(data)
  self:Notify(ServiceEvent.SceneUser3NoviceChargeReward, data)
end

function ServiceSceneUser3AutoProxy:RecvEquipPosEffectTime(data)
  self:Notify(ServiceEvent.SceneUser3EquipPosEffectTime, data)
end

function ServiceSceneUser3AutoProxy:RecvUpdateRecordSlotIndex(data)
  self:Notify(ServiceEvent.SceneUser3UpdateRecordSlotIndex, data)
end

function ServiceSceneUser3AutoProxy:RecvSyncInterferenceData(data)
  self:Notify(ServiceEvent.SceneUser3SyncInterferenceData, data)
end

function ServiceSceneUser3AutoProxy:RecvGetResourceRewardCmd(data)
  self:Notify(ServiceEvent.SceneUser3GetResourceRewardCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvAuthQueryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3AuthQueryUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvAuthUpdateUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3AuthUpdateUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvActionStatUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ActionStatUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvUnlockDress(data)
  self:Notify(ServiceEvent.SceneUser3UnlockDress, data)
end

function ServiceSceneUser3AutoProxy:RecvQueryPrestigeCmd(data)
  self:Notify(ServiceEvent.SceneUser3QueryPrestigeCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvPrestigeLevelUpNotifyCmd(data)
  self:Notify(ServiceEvent.SceneUser3PrestigeLevelUpNotifyCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvSuperSignInUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3SuperSignInUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvSuperSignInNtfUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3SuperSignInNtfUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvPrestigeRewardCmd(data)
  self:Notify(ServiceEvent.SceneUser3PrestigeRewardCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvQueryQuestSignInfoUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3QueryQuestSignInfoUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvLightFireworkUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3LightFireworkUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvRemoveFireworkUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3RemoveFireworkUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvQueryYearMemoryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3QueryYearMemoryUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvYearMemoryProcessUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3YearMemoryProcessUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvSetYearMemoryTitleUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3SetYearMemoryTitleUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvActivityExchangeGiftsQueryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ActivityExchangeGiftsQueryUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvActivityExchangeGiftsRewardUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ActivityExchangeGiftsRewardUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvGvgExcellectQueryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3GvgExcellectQueryUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvEffectInfoSyncUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3EffectInfoSyncUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvEffectInfoUpdateUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3EffectInfoUpdateUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvEffectInfoUseUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3EffectInfoUseUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvGvgExcellectRewardUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3GvgExcellectRewardUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvBattleTimeOffUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3BattleTimeOffUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvPlayTimeOffUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3PlayTimeOffUserCmd, data)
end

function ServiceSceneUser3AutoProxy:RecvWareHouseOperationCmd(data)
  self:Notify(ServiceEvent.SceneUser3WareHouseOperationCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneUser3FirstDepositInfo = "ServiceEvent_SceneUser3FirstDepositInfo"
ServiceEvent.SceneUser3FirstDepositReward = "ServiceEvent_SceneUser3FirstDepositReward"
ServiceEvent.SceneUser3ClientPayLog = "ServiceEvent_SceneUser3ClientPayLog"
ServiceEvent.SceneUser3DailyDepositInfo = "ServiceEvent_SceneUser3DailyDepositInfo"
ServiceEvent.SceneUser3DailyDepositGetReward = "ServiceEvent_SceneUser3DailyDepositGetReward"
ServiceEvent.SceneUser3BattleTimeCostSelectCmd = "ServiceEvent_SceneUser3BattleTimeCostSelectCmd"
ServiceEvent.SceneUser3PlugInNotify = "ServiceEvent_SceneUser3PlugInNotify"
ServiceEvent.SceneUser3PlugInUpload = "ServiceEvent_SceneUser3PlugInUpload"
ServiceEvent.SceneUser3HeroStoryQuestInfo = "ServiceEvent_SceneUser3HeroStoryQuestInfo"
ServiceEvent.SceneUser3HeroStoryQuestAccept = "ServiceEvent_SceneUser3HeroStoryQuestAccept"
ServiceEvent.SceneUser3HeroQuestReward = "ServiceEvent_SceneUser3HeroQuestReward"
ServiceEvent.SceneUser3HeroGrowthQuestInfo = "ServiceEvent_SceneUser3HeroGrowthQuestInfo"
ServiceEvent.SceneUser3QueryProfessionRecordSimpleData = "ServiceEvent_SceneUser3QueryProfessionRecordSimpleData"
ServiceEvent.SceneUser3HeroBuyUserCmd = "ServiceEvent_SceneUser3HeroBuyUserCmd"
ServiceEvent.SceneUser3HeroShowUserCmd = "ServiceEvent_SceneUser3HeroShowUserCmd"
ServiceEvent.SceneUser3AccumDepositInfo = "ServiceEvent_SceneUser3AccumDepositInfo"
ServiceEvent.SceneUser3AccumDepositReward = "ServiceEvent_SceneUser3AccumDepositReward"
ServiceEvent.SceneUser3BoliGoldGetReward = "ServiceEvent_SceneUser3BoliGoldGetReward"
ServiceEvent.SceneUser3BoliGoldInfo = "ServiceEvent_SceneUser3BoliGoldInfo"
ServiceEvent.SceneUser3BoliGoldGetFreeReward = "ServiceEvent_SceneUser3BoliGoldGetFreeReward"
ServiceEvent.SceneUser3ResourceCheckUserCmd = "ServiceEvent_SceneUser3ResourceCheckUserCmd"
ServiceEvent.SceneUser3NoviceChargeSync = "ServiceEvent_SceneUser3NoviceChargeSync"
ServiceEvent.SceneUser3NoviceChargeReward = "ServiceEvent_SceneUser3NoviceChargeReward"
ServiceEvent.SceneUser3EquipPosEffectTime = "ServiceEvent_SceneUser3EquipPosEffectTime"
ServiceEvent.SceneUser3UpdateRecordSlotIndex = "ServiceEvent_SceneUser3UpdateRecordSlotIndex"
ServiceEvent.SceneUser3SyncInterferenceData = "ServiceEvent_SceneUser3SyncInterferenceData"
ServiceEvent.SceneUser3GetResourceRewardCmd = "ServiceEvent_SceneUser3GetResourceRewardCmd"
ServiceEvent.SceneUser3AuthQueryUserCmd = "ServiceEvent_SceneUser3AuthQueryUserCmd"
ServiceEvent.SceneUser3AuthUpdateUserCmd = "ServiceEvent_SceneUser3AuthUpdateUserCmd"
ServiceEvent.SceneUser3ActionStatUserCmd = "ServiceEvent_SceneUser3ActionStatUserCmd"
ServiceEvent.SceneUser3UnlockDress = "ServiceEvent_SceneUser3UnlockDress"
ServiceEvent.SceneUser3QueryPrestigeCmd = "ServiceEvent_SceneUser3QueryPrestigeCmd"
ServiceEvent.SceneUser3PrestigeLevelUpNotifyCmd = "ServiceEvent_SceneUser3PrestigeLevelUpNotifyCmd"
ServiceEvent.SceneUser3SuperSignInUserCmd = "ServiceEvent_SceneUser3SuperSignInUserCmd"
ServiceEvent.SceneUser3SuperSignInNtfUserCmd = "ServiceEvent_SceneUser3SuperSignInNtfUserCmd"
ServiceEvent.SceneUser3PrestigeRewardCmd = "ServiceEvent_SceneUser3PrestigeRewardCmd"
ServiceEvent.SceneUser3QueryQuestSignInfoUserCmd = "ServiceEvent_SceneUser3QueryQuestSignInfoUserCmd"
ServiceEvent.SceneUser3LightFireworkUserCmd = "ServiceEvent_SceneUser3LightFireworkUserCmd"
ServiceEvent.SceneUser3RemoveFireworkUserCmd = "ServiceEvent_SceneUser3RemoveFireworkUserCmd"
ServiceEvent.SceneUser3QueryYearMemoryUserCmd = "ServiceEvent_SceneUser3QueryYearMemoryUserCmd"
ServiceEvent.SceneUser3YearMemoryProcessUserCmd = "ServiceEvent_SceneUser3YearMemoryProcessUserCmd"
ServiceEvent.SceneUser3SetYearMemoryTitleUserCmd = "ServiceEvent_SceneUser3SetYearMemoryTitleUserCmd"
ServiceEvent.SceneUser3ActivityExchangeGiftsQueryUserCmd = "ServiceEvent_SceneUser3ActivityExchangeGiftsQueryUserCmd"
ServiceEvent.SceneUser3ActivityExchangeGiftsRewardUserCmd = "ServiceEvent_SceneUser3ActivityExchangeGiftsRewardUserCmd"
ServiceEvent.SceneUser3GvgExcellectQueryUserCmd = "ServiceEvent_SceneUser3GvgExcellectQueryUserCmd"
ServiceEvent.SceneUser3EffectInfoSyncUserCmd = "ServiceEvent_SceneUser3EffectInfoSyncUserCmd"
ServiceEvent.SceneUser3EffectInfoUpdateUserCmd = "ServiceEvent_SceneUser3EffectInfoUpdateUserCmd"
ServiceEvent.SceneUser3EffectInfoUseUserCmd = "ServiceEvent_SceneUser3EffectInfoUseUserCmd"
ServiceEvent.SceneUser3GvgExcellectRewardUserCmd = "ServiceEvent_SceneUser3GvgExcellectRewardUserCmd"
ServiceEvent.SceneUser3BattleTimeOffUserCmd = "ServiceEvent_SceneUser3BattleTimeOffUserCmd"
ServiceEvent.SceneUser3PlayTimeOffUserCmd = "ServiceEvent_SceneUser3PlayTimeOffUserCmd"
ServiceEvent.SceneUser3WareHouseOperationCmd = "ServiceEvent_SceneUser3WareHouseOperationCmd"
