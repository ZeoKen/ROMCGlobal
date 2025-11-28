ServiceRecallCCmdAutoProxy = class("ServiceRecallCCmdAutoProxy", ServiceProxy)
ServiceRecallCCmdAutoProxy.Instance = nil
ServiceRecallCCmdAutoProxy.NAME = "ServiceRecallCCmdAutoProxy"

function ServiceRecallCCmdAutoProxy:ctor(proxyName)
  if ServiceRecallCCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRecallCCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRecallCCmdAutoProxy.Instance = self
  end
end

function ServiceRecallCCmdAutoProxy:Init()
end

function ServiceRecallCCmdAutoProxy:onRegister()
  self:Listen(84, 1, function(data)
    self:RecvQueryRecallInfoRecallCmd(data)
  end)
  self:Listen(84, 2, function(data)
    self:RecvSignQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 3, function(data)
    self:RecvSignInRecallCmd(data)
  end)
  self:Listen(84, 4, function(data)
    self:RecvBattlePassQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 5, function(data)
    self:RecvBattlePassQuickLvUpRecallCmd(data)
  end)
  self:Listen(84, 6, function(data)
    self:RecvGetBattlePassRewardRecallCmd(data)
  end)
  self:Listen(84, 12, function(data)
    self:RecvGetAllBattlePassRewardRecallCmd(data)
  end)
  self:Listen(84, 8, function(data)
    self:RecvWeeklyTaskQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 9, function(data)
    self:RecvWeeklyTaskGetRewardRecallCmd(data)
  end)
  self:Listen(84, 10, function(data)
    self:RecvFundQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 11, function(data)
    self:RecvFundGetRewardRecallCmd(data)
  end)
  self:Listen(84, 13, function(data)
    self:RecvShopQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 14, function(data)
    self:RecvBuyShopGoodRecallCmd(data)
  end)
  self:Listen(84, 15, function(data)
    self:RecvCatchUpQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 16, function(data)
    self:RecvMvpCardQueryInfoRecallCmd(data)
  end)
  self:Listen(84, 17, function(data)
    self:RecvMvpCardSetUpCardRecallCmd(data)
  end)
  self:Listen(84, 18, function(data)
    self:RecvMvpCardRandCardRecallCmd(data)
  end)
end

function ServiceRecallCCmdAutoProxy:CallQueryRecallInfoRecallCmd(info)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.QueryRecallInfoRecallCmd()
    if info ~= nil and info.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.start_time = info.start_time
    end
    if info ~= nil and info.acc_offline_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.acc_offline_time = info.acc_offline_time
    end
    if info ~= nil and info.indexs ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.indexs == nil then
        msg.info.indexs = {}
      end
      for i = 1, #info.indexs do
        table.insert(msg.info.indexs, info.indexs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryRecallInfoRecallCmd.id
    local msgParam = {}
    if info ~= nil and info.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.start_time = info.start_time
    end
    if info ~= nil and info.acc_offline_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.acc_offline_time = info.acc_offline_time
    end
    if info ~= nil and info.indexs ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.indexs == nil then
        msgParam.info.indexs = {}
      end
      for i = 1, #info.indexs do
        table.insert(msgParam.info.indexs, info.indexs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallSignQueryInfoRecallCmd(data)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.SignQueryInfoRecallCmd()
    if data ~= nil and data.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.index = data.index
    end
    if data ~= nil and data.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.start_time = data.start_time
    end
    if data ~= nil and data.cur_day ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.cur_day = data.cur_day
    end
    if data ~= nil and data.next_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.next_time = data.next_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SignQueryInfoRecallCmd.id
    local msgParam = {}
    if data ~= nil and data.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.index = data.index
    end
    if data ~= nil and data.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.start_time = data.start_time
    end
    if data ~= nil and data.cur_day ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.cur_day = data.cur_day
    end
    if data ~= nil and data.next_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.next_time = data.next_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallSignInRecallCmd()
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.SignInRecallCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SignInRecallCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallBattlePassQueryInfoRecallCmd(data)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.BattlePassQueryInfoRecallCmd()
    if data ~= nil and data.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.index = data.index
    end
    if data ~= nil and data.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.start_time = data.start_time
    end
    if data ~= nil and data.end_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.end_time = data.end_time
    end
    if data ~= nil and data.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.exp = data.exp
    end
    if data ~= nil and data.normal_level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.normal_level = data.normal_level
    end
    if data ~= nil and data.nor_reward_geted ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.nor_reward_geted = data.nor_reward_geted
    end
    if data ~= nil and data.adv_reward_geted ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.adv_reward_geted = data.adv_reward_geted
    end
    if data ~= nil and data.adv_lock ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.adv_lock = data.adv_lock
    end
    if data ~= nil and data.quests ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.quests == nil then
        msg.data.quests = {}
      end
      for i = 1, #data.quests do
        table.insert(msg.data.quests, data.quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattlePassQueryInfoRecallCmd.id
    local msgParam = {}
    if data ~= nil and data.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.index = data.index
    end
    if data ~= nil and data.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.start_time = data.start_time
    end
    if data ~= nil and data.end_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.end_time = data.end_time
    end
    if data ~= nil and data.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.exp = data.exp
    end
    if data ~= nil and data.normal_level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.normal_level = data.normal_level
    end
    if data ~= nil and data.nor_reward_geted ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.nor_reward_geted = data.nor_reward_geted
    end
    if data ~= nil and data.adv_reward_geted ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.adv_reward_geted = data.adv_reward_geted
    end
    if data ~= nil and data.adv_lock ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.adv_lock = data.adv_lock
    end
    if data ~= nil and data.quests ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.quests == nil then
        msgParam.data.quests = {}
      end
      for i = 1, #data.quests do
        table.insert(msgParam.data.quests, data.quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallBattlePassQuickLvUpRecallCmd(level)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.BattlePassQuickLvUpRecallCmd()
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattlePassQuickLvUpRecallCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallGetBattlePassRewardRecallCmd(normal, level)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.GetBattlePassRewardRecallCmd()
    if normal ~= nil then
      msg.normal = normal
    end
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetBattlePassRewardRecallCmd.id
    local msgParam = {}
    if normal ~= nil then
      msgParam.normal = normal
    end
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallGetAllBattlePassRewardRecallCmd()
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.GetAllBattlePassRewardRecallCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetAllBattlePassRewardRecallCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallWeeklyTaskQueryInfoRecallCmd(info)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.WeeklyTaskQueryInfoRecallCmd()
    if info ~= nil and info.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.start_time = info.start_time
    end
    if info ~= nil and info.tasks ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.tasks == nil then
        msg.info.tasks = {}
      end
      for i = 1, #info.tasks do
        table.insert(msg.info.tasks, info.tasks[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeeklyTaskQueryInfoRecallCmd.id
    local msgParam = {}
    if info ~= nil and info.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.start_time = info.start_time
    end
    if info ~= nil and info.tasks ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.tasks == nil then
        msgParam.info.tasks = {}
      end
      for i = 1, #info.tasks do
        table.insert(msgParam.info.tasks, info.tasks[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallWeeklyTaskGetRewardRecallCmd(task)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.WeeklyTaskGetRewardRecallCmd()
    if task ~= nil and task.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.task == nil then
        msg.task = {}
      end
      msg.task.id = task.id
    end
    if task ~= nil and task.complete_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.task == nil then
        msg.task = {}
      end
      msg.task.complete_count = task.complete_count
    end
    if task ~= nil and task.complete ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.task == nil then
        msg.task = {}
      end
      msg.task.complete = task.complete
    end
    if task ~= nil and task.reward_geted ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.task == nil then
        msg.task = {}
      end
      msg.task.reward_geted = task.reward_geted
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeeklyTaskGetRewardRecallCmd.id
    local msgParam = {}
    if task ~= nil and task.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.task == nil then
        msgParam.task = {}
      end
      msgParam.task.id = task.id
    end
    if task ~= nil and task.complete_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.task == nil then
        msgParam.task = {}
      end
      msgParam.task.complete_count = task.complete_count
    end
    if task ~= nil and task.complete ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.task == nil then
        msgParam.task = {}
      end
      msgParam.task.complete = task.complete
    end
    if task ~= nil and task.reward_geted ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.task == nil then
        msgParam.task = {}
      end
      msgParam.task.reward_geted = task.reward_geted
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallFundQueryInfoRecallCmd(info)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.FundQueryInfoRecallCmd()
    if info ~= nil and info.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.start_time = info.start_time
    end
    if info ~= nil and info.end_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.end_time = info.end_time
    end
    if info ~= nil and info.login_day ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.login_day = info.login_day
    end
    if info ~= nil and info.reward_day ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.reward_day == nil then
        msg.info.reward_day = {}
      end
      for i = 1, #info.reward_day do
        table.insert(msg.info.reward_day, info.reward_day[i])
      end
    end
    if info ~= nil and info.active ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.active = info.active
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FundQueryInfoRecallCmd.id
    local msgParam = {}
    if info ~= nil and info.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.start_time = info.start_time
    end
    if info ~= nil and info.end_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.end_time = info.end_time
    end
    if info ~= nil and info.login_day ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.login_day = info.login_day
    end
    if info ~= nil and info.reward_day ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.reward_day == nil then
        msgParam.info.reward_day = {}
      end
      for i = 1, #info.reward_day do
        table.insert(msgParam.info.reward_day, info.reward_day[i])
      end
    end
    if info ~= nil and info.active ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.active = info.active
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallFundGetRewardRecallCmd(day)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.FundGetRewardRecallCmd()
    if day ~= nil then
      msg.day = day
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FundGetRewardRecallCmd.id
    local msgParam = {}
    if day ~= nil then
      msgParam.day = day
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallShopQueryInfoRecallCmd(info)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.ShopQueryInfoRecallCmd()
    if info ~= nil and info.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.start_time = info.start_time
    end
    if info ~= nil and info.end_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.end_time = info.end_time
    end
    if info ~= nil and info.goods ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.goods == nil then
        msg.info.goods = {}
      end
      for i = 1, #info.goods do
        table.insert(msg.info.goods, info.goods[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShopQueryInfoRecallCmd.id
    local msgParam = {}
    if info ~= nil and info.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.start_time = info.start_time
    end
    if info ~= nil and info.end_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.end_time = info.end_time
    end
    if info ~= nil and info.goods ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.goods == nil then
        msgParam.info.goods = {}
      end
      for i = 1, #info.goods do
        table.insert(msgParam.info.goods, info.goods[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallBuyShopGoodRecallCmd(id, count)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.BuyShopGoodRecallCmd()
    if id ~= nil then
      msg.id = id
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyShopGoodRecallCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallCatchUpQueryInfoRecallCmd(info)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.CatchUpQueryInfoRecallCmd()
    if info ~= nil and info.adv_pass ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.adv_pass == nil then
        msg.info.adv_pass = {}
      end
      for i = 1, #info.adv_pass do
        table.insert(msg.info.adv_pass, info.adv_pass[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatchUpQueryInfoRecallCmd.id
    local msgParam = {}
    if info ~= nil and info.adv_pass ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.adv_pass == nil then
        msgParam.info.adv_pass = {}
      end
      for i = 1, #info.adv_pass do
        table.insert(msgParam.info.adv_pass, info.adv_pass[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallMvpCardQueryInfoRecallCmd(info)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.MvpCardQueryInfoRecallCmd()
    if info ~= nil and info.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.start_time = info.start_time
    end
    if info ~= nil and info.end_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.end_time = info.end_time
    end
    if info ~= nil and info.up_card ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.up_card = info.up_card
    end
    if info ~= nil and info.rand_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.rand_count = info.rand_count
    end
    if info ~= nil and info.card_pool ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.card_pool == nil then
        msg.info.card_pool = {}
      end
      for i = 1, #info.card_pool do
        table.insert(msg.info.card_pool, info.card_pool[i])
      end
    end
    if info ~= nil and info.up_card_pool ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.up_card_pool == nil then
        msg.info.up_card_pool = {}
      end
      for i = 1, #info.up_card_pool do
        table.insert(msg.info.up_card_pool, info.up_card_pool[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MvpCardQueryInfoRecallCmd.id
    local msgParam = {}
    if info ~= nil and info.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.index = info.index
    end
    if info ~= nil and info.start_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.start_time = info.start_time
    end
    if info ~= nil and info.end_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.end_time = info.end_time
    end
    if info ~= nil and info.up_card ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.up_card = info.up_card
    end
    if info ~= nil and info.rand_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.rand_count = info.rand_count
    end
    if info ~= nil and info.card_pool ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.card_pool == nil then
        msgParam.info.card_pool = {}
      end
      for i = 1, #info.card_pool do
        table.insert(msgParam.info.card_pool, info.card_pool[i])
      end
    end
    if info ~= nil and info.up_card_pool ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.up_card_pool == nil then
        msgParam.info.up_card_pool = {}
      end
      for i = 1, #info.up_card_pool do
        table.insert(msgParam.info.up_card_pool, info.up_card_pool[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallMvpCardSetUpCardRecallCmd(card_id)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.MvpCardSetUpCardRecallCmd()
    if card_id ~= nil then
      msg.card_id = card_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MvpCardSetUpCardRecallCmd.id
    local msgParam = {}
    if card_id ~= nil then
      msgParam.card_id = card_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:CallMvpCardRandCardRecallCmd(rand_count, msg_id)
  if not NetConfig.PBC then
    local msg = RecallCCmd_pb.MvpCardRandCardRecallCmd()
    if rand_count ~= nil then
      msg.rand_count = rand_count
    end
    if msg_id ~= nil then
      msg.msg_id = msg_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MvpCardRandCardRecallCmd.id
    local msgParam = {}
    if rand_count ~= nil then
      msgParam.rand_count = rand_count
    end
    if msg_id ~= nil then
      msgParam.msg_id = msg_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRecallCCmdAutoProxy:RecvQueryRecallInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdQueryRecallInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvSignQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdSignQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvSignInRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdSignInRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvBattlePassQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdBattlePassQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvBattlePassQuickLvUpRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdBattlePassQuickLvUpRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvGetBattlePassRewardRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdGetBattlePassRewardRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvGetAllBattlePassRewardRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdGetAllBattlePassRewardRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvWeeklyTaskQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdWeeklyTaskQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvWeeklyTaskGetRewardRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdWeeklyTaskGetRewardRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvFundQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdFundQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvFundGetRewardRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdFundGetRewardRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvShopQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdShopQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvBuyShopGoodRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdBuyShopGoodRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvCatchUpQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvMvpCardQueryInfoRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdMvpCardQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvMvpCardSetUpCardRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdMvpCardSetUpCardRecallCmd, data)
end

function ServiceRecallCCmdAutoProxy:RecvMvpCardRandCardRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdMvpCardRandCardRecallCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.RecallCCmdQueryRecallInfoRecallCmd = "ServiceEvent_RecallCCmdQueryRecallInfoRecallCmd"
ServiceEvent.RecallCCmdSignQueryInfoRecallCmd = "ServiceEvent_RecallCCmdSignQueryInfoRecallCmd"
ServiceEvent.RecallCCmdSignInRecallCmd = "ServiceEvent_RecallCCmdSignInRecallCmd"
ServiceEvent.RecallCCmdBattlePassQueryInfoRecallCmd = "ServiceEvent_RecallCCmdBattlePassQueryInfoRecallCmd"
ServiceEvent.RecallCCmdBattlePassQuickLvUpRecallCmd = "ServiceEvent_RecallCCmdBattlePassQuickLvUpRecallCmd"
ServiceEvent.RecallCCmdGetBattlePassRewardRecallCmd = "ServiceEvent_RecallCCmdGetBattlePassRewardRecallCmd"
ServiceEvent.RecallCCmdGetAllBattlePassRewardRecallCmd = "ServiceEvent_RecallCCmdGetAllBattlePassRewardRecallCmd"
ServiceEvent.RecallCCmdWeeklyTaskQueryInfoRecallCmd = "ServiceEvent_RecallCCmdWeeklyTaskQueryInfoRecallCmd"
ServiceEvent.RecallCCmdWeeklyTaskGetRewardRecallCmd = "ServiceEvent_RecallCCmdWeeklyTaskGetRewardRecallCmd"
ServiceEvent.RecallCCmdFundQueryInfoRecallCmd = "ServiceEvent_RecallCCmdFundQueryInfoRecallCmd"
ServiceEvent.RecallCCmdFundGetRewardRecallCmd = "ServiceEvent_RecallCCmdFundGetRewardRecallCmd"
ServiceEvent.RecallCCmdShopQueryInfoRecallCmd = "ServiceEvent_RecallCCmdShopQueryInfoRecallCmd"
ServiceEvent.RecallCCmdBuyShopGoodRecallCmd = "ServiceEvent_RecallCCmdBuyShopGoodRecallCmd"
ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd = "ServiceEvent_RecallCCmdCatchUpQueryInfoRecallCmd"
ServiceEvent.RecallCCmdMvpCardQueryInfoRecallCmd = "ServiceEvent_RecallCCmdMvpCardQueryInfoRecallCmd"
ServiceEvent.RecallCCmdMvpCardSetUpCardRecallCmd = "ServiceEvent_RecallCCmdMvpCardSetUpCardRecallCmd"
ServiceEvent.RecallCCmdMvpCardRandCardRecallCmd = "ServiceEvent_RecallCCmdMvpCardRandCardRecallCmd"
