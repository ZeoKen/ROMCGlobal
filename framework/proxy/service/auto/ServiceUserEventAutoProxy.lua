ServiceUserEventAutoProxy = class("ServiceUserEventAutoProxy", ServiceProxy)
ServiceUserEventAutoProxy.Instance = nil
ServiceUserEventAutoProxy.NAME = "ServiceUserEventAutoProxy"

function ServiceUserEventAutoProxy:ctor(proxyName)
  if ServiceUserEventAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserEventAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserEventAutoProxy.Instance = self
  end
end

function ServiceUserEventAutoProxy:Init()
end

function ServiceUserEventAutoProxy:onRegister()
  self:Listen(25, 1, function(data)
    self:RecvFirstActionUserEvent(data)
  end)
  self:Listen(25, 2, function(data)
    self:RecvDamageNpcUserEvent(data)
  end)
  self:Listen(25, 3, function(data)
    self:RecvNewTitle(data)
  end)
  self:Listen(25, 4, function(data)
    self:RecvAllTitle(data)
  end)
  self:Listen(25, 5, function(data)
    self:RecvUpdateRandomUserEvent(data)
  end)
  self:Listen(25, 6, function(data)
    self:RecvBuffDamageUserEvent(data)
  end)
  self:Listen(25, 7, function(data)
    self:RecvChargeNtfUserEvent(data)
  end)
  self:Listen(25, 8, function(data)
    self:RecvChargeQueryCmd(data)
  end)
  self:Listen(25, 9, function(data)
    self:RecvDepositCardInfo(data)
  end)
  self:Listen(25, 10, function(data)
    self:RecvDelTransformUserEvent(data)
  end)
  self:Listen(25, 11, function(data)
    self:RecvInviteCatFailUserEvent(data)
  end)
  self:Listen(25, 12, function(data)
    self:RecvTrigNpcFuncUserEvent(data)
  end)
  self:Listen(25, 13, function(data)
    self:RecvSystemStringUserEvent(data)
  end)
  self:Listen(25, 14, function(data)
    self:RecvHandCatUserEvent(data)
  end)
  self:Listen(25, 15, function(data)
    self:RecvChangeTitle(data)
  end)
  self:Listen(25, 16, function(data)
    self:RecvQueryChargeCnt(data)
  end)
  self:Listen(25, 17, function(data)
    self:RecvNTFMonthCardEnd(data)
  end)
  self:Listen(25, 18, function(data)
    self:RecvLoveLetterUse(data)
  end)
  self:Listen(25, 19, function(data)
    self:RecvQueryActivityCnt(data)
  end)
  self:Listen(25, 20, function(data)
    self:RecvUpdateActivityCnt(data)
  end)
  self:Listen(25, 23, function(data)
    self:RecvNtfVersionCardInfo(data)
  end)
  self:Listen(25, 24, function(data)
    self:RecvDieTimeCountEventCmd(data)
  end)
  self:Listen(25, 22, function(data)
    self:RecvGetFirstShareRewardUserEvent(data)
  end)
  self:Listen(25, 25, function(data)
    self:RecvQueryResetTimeEventCmd(data)
  end)
  self:Listen(25, 26, function(data)
    self:RecvInOutActEventCmd(data)
  end)
  self:Listen(25, 27, function(data)
    self:RecvUserEventMailCmd(data)
  end)
  self:Listen(25, 28, function(data)
    self:RecvLevelupDeadUserEvent(data)
  end)
  self:Listen(25, 29, function(data)
    self:RecvSwitchAutoBattleUserEvent(data)
  end)
  self:Listen(25, 30, function(data)
    self:RecvGoActivityMapUserEvent(data)
  end)
  self:Listen(25, 31, function(data)
    self:RecvActivityPointUserEvent(data)
  end)
  self:Listen(25, 33, function(data)
    self:RecvQueryFavoriteFriendUserEvent(data)
  end)
  self:Listen(25, 34, function(data)
    self:RecvUpdateFavoriteFriendUserEvent(data)
  end)
  self:Listen(25, 35, function(data)
    self:RecvActionFavoriteFriendUserEvent(data)
  end)
  self:Listen(25, 36, function(data)
    self:RecvSoundStoryUserEvent(data)
  end)
  self:Listen(25, 32, function(data)
    self:RecvThemeDetailsUserEvent(data)
  end)
  self:Listen(25, 40, function(data)
    self:RecvCameraActionUserEvent(data)
  end)
  self:Listen(25, 39, function(data)
    self:RecvBifrostContributeItemUserEvent(data)
  end)
  self:Listen(25, 41, function(data)
    self:RecvRobotOffBattleUserEvent(data)
  end)
  self:Listen(25, 37, function(data)
    self:RecvQueryAccChargeCntReward(data)
  end)
  self:Listen(25, 42, function(data)
    self:RecvChargeSdkRequestUserEvent(data)
  end)
  self:Listen(25, 43, function(data)
    self:RecvChargeSdkReplyUserEvent(data)
  end)
  self:Listen(25, 44, function(data)
    self:RecvClientAISyncUserEvent(data)
  end)
  self:Listen(25, 45, function(data)
    self:RecvClientAIUpdateUserEvent(data)
  end)
  self:Listen(25, 46, function(data)
    self:RecvGiftCodeExchangeEvent(data)
  end)
  self:Listen(25, 47, function(data)
    self:RecvSetHideOtherCmd(data)
  end)
  self:Listen(25, 48, function(data)
    self:RecvGiftTimeLimitNtfUserEvent(data)
  end)
  self:Listen(25, 49, function(data)
    self:RecvGiftTimeLimitBuyUserEvent(data)
  end)
  self:Listen(25, 50, function(data)
    self:RecvGiftTimeLimitActiveUserEvent(data)
  end)
  self:Listen(25, 55, function(data)
    self:RecvMultiCutSceneUpdateUserEvent(data)
  end)
  self:Listen(25, 56, function(data)
    self:RecvPolicyUpdateUserEvent(data)
  end)
  self:Listen(25, 57, function(data)
    self:RecvPolicyAgreeUserEvent(data)
  end)
  self:Listen(25, 58, function(data)
    self:RecvShowSceneObject(data)
  end)
  self:Listen(25, 59, function(data)
    self:RecvDoubleAcionEvent(data)
  end)
  self:Listen(25, 60, function(data)
    self:RecvBeginMonitorUserEvent(data)
  end)
  self:Listen(25, 61, function(data)
    self:RecvStopMonitorUserEvent(data)
  end)
  self:Listen(25, 65, function(data)
    self:RecvStopMonitorRetUserEvent(data)
  end)
  self:Listen(25, 62, function(data)
    self:RecvMonitorGoToMapUserEvent(data)
  end)
  self:Listen(25, 63, function(data)
    self:RecvMonitorMapEndUserEvent(data)
  end)
  self:Listen(25, 64, function(data)
    self:RecvMonitorBuildUserEvent(data)
  end)
  self:Listen(25, 73, function(data)
    self:RecvGuideQuestEvent(data)
  end)
  self:Listen(25, 75, function(data)
    self:RecvShowCardEvent(data)
  end)
  self:Listen(25, 71, function(data)
    self:RecvGvgOptStatueEvent(data)
  end)
  self:Listen(25, 72, function(data)
    self:RecvTimeLimitIconEvent(data)
  end)
  self:Listen(25, 76, function(data)
    self:RecvShowRMBGiftEvent(data)
  end)
  self:Listen(25, 66, function(data)
    self:RecvConfigActionUserEvent(data)
  end)
  self:Listen(25, 67, function(data)
    self:RecvNpcWalkStepNtfUserEvent(data)
  end)
  self:Listen(25, 68, function(data)
    self:RecvSetProfileUserEvent(data)
  end)
  self:Listen(25, 70, function(data)
    self:RecvQueryFateRelationEvent(data)
  end)
  self:Listen(25, 69, function(data)
    self:RecvSyncFateRelationEvent(data)
  end)
  self:Listen(25, 77, function(data)
    self:RecvQueryProfileUserEvent(data)
  end)
  self:Listen(25, 78, function(data)
    self:RecvGvgSandTableEvent(data)
  end)
  self:Listen(25, 79, function(data)
    self:RecvSetReliveMethodUserEvent(data)
  end)
  self:Listen(25, 80, function(data)
    self:RecvUIActionUserEvent(data)
  end)
  self:Listen(25, 82, function(data)
    self:RecvPlayCutSceneUserEvent(data)
  end)
  self:Listen(25, 84, function(data)
    self:RecvReqPeriodicMonsterUserEvent(data)
  end)
  self:Listen(25, 85, function(data)
    self:RecvPlayHoldPetUserEvent(data)
  end)
  self:Listen(25, 81, function(data)
    self:RecvQuerySpeedUpUserEvent(data)
  end)
  self:Listen(25, 83, function(data)
    self:RecvServerOpenTimeUserEvent(data)
  end)
  self:Listen(25, 86, function(data)
    self:RecvSkillDamageStatUserEvent(data)
  end)
  self:Listen(25, 87, function(data)
    self:RecvHeartBeatReqUserEvent(data)
  end)
  self:Listen(25, 88, function(data)
    self:RecvHeartBeatAckUserEvent(data)
  end)
  self:Listen(25, 89, function(data)
    self:RecvQueryUserReportListUserEvent(data)
  end)
  self:Listen(25, 90, function(data)
    self:RecvUserReportUserEvent(data)
  end)
end

function ServiceUserEventAutoProxy:CallFirstActionUserEvent(firstaction)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.FirstActionUserEvent()
    if firstaction ~= nil then
      msg.firstaction = firstaction
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FirstActionUserEvent.id
    local msgParam = {}
    if firstaction ~= nil then
      msgParam.firstaction = firstaction
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallDamageNpcUserEvent(npcguid, userid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.DamageNpcUserEvent()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DamageNpcUserEvent.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallNewTitle(title_data, charid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.NewTitle()
    if title_data ~= nil and title_data.title_type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_data == nil then
        msg.title_data = {}
      end
      msg.title_data.title_type = title_data.title_type
    end
    if title_data ~= nil and title_data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_data == nil then
        msg.title_data = {}
      end
      msg.title_data.id = title_data.id
    end
    if title_data ~= nil and title_data.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_data == nil then
        msg.title_data = {}
      end
      msg.title_data.createtime = title_data.createtime
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewTitle.id
    local msgParam = {}
    if title_data ~= nil and title_data.title_type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_data == nil then
        msgParam.title_data = {}
      end
      msgParam.title_data.title_type = title_data.title_type
    end
    if title_data ~= nil and title_data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_data == nil then
        msgParam.title_data = {}
      end
      msgParam.title_data.id = title_data.id
    end
    if title_data ~= nil and title_data.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_data == nil then
        msgParam.title_data = {}
      end
      msgParam.title_data.createtime = title_data.createtime
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallAllTitle(title_datas)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.AllTitle()
    if title_datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_datas == nil then
        msg.title_datas = {}
      end
      for i = 1, #title_datas do
        table.insert(msg.title_datas, title_datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AllTitle.id
    local msgParam = {}
    if title_datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_datas == nil then
        msgParam.title_datas = {}
      end
      for i = 1, #title_datas do
        table.insert(msgParam.title_datas, title_datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallUpdateRandomUserEvent(beginindex, endindex, randoms)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.UpdateRandomUserEvent()
    if beginindex ~= nil then
      msg.beginindex = beginindex
    end
    if endindex ~= nil then
      msg.endindex = endindex
    end
    if randoms ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.randoms == nil then
        msg.randoms = {}
      end
      for i = 1, #randoms do
        table.insert(msg.randoms, randoms[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateRandomUserEvent.id
    local msgParam = {}
    if beginindex ~= nil then
      msgParam.beginindex = beginindex
    end
    if endindex ~= nil then
      msgParam.endindex = endindex
    end
    if randoms ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.randoms == nil then
        msgParam.randoms = {}
      end
      for i = 1, #randoms do
        table.insert(msgParam.randoms, randoms[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallBuffDamageUserEvent(charid, damage, etype, fromid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.BuffDamageUserEvent()
    if charid ~= nil then
      msg.charid = charid
    end
    if damage ~= nil then
      msg.damage = damage
    end
    if etype ~= nil then
      msg.etype = etype
    end
    if fromid ~= nil then
      msg.fromid = fromid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuffDamageUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if damage ~= nil then
      msgParam.damage = damage
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    if fromid ~= nil then
      msgParam.fromid = fromid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallChargeNtfUserEvent(charid, dataid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ChargeNtfUserEvent()
    if charid ~= nil then
      msg.charid = charid
    end
    if dataid ~= nil then
      msg.dataid = dataid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChargeNtfUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if dataid ~= nil then
      msgParam.dataid = dataid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallChargeQueryCmd(data_id, ret, charged_count)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ChargeQueryCmd()
    if data_id ~= nil then
      msg.data_id = data_id
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if charged_count ~= nil then
      msg.charged_count = charged_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChargeQueryCmd.id
    local msgParam = {}
    if data_id ~= nil then
      msgParam.data_id = data_id
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if charged_count ~= nil then
      msgParam.charged_count = charged_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallDepositCardInfo(card_datas)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.DepositCardInfo()
    if card_datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.card_datas == nil then
        msg.card_datas = {}
      end
      for i = 1, #card_datas do
        table.insert(msg.card_datas, card_datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DepositCardInfo.id
    local msgParam = {}
    if card_datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.card_datas == nil then
        msgParam.card_datas = {}
      end
      for i = 1, #card_datas do
        table.insert(msgParam.card_datas, card_datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallDelTransformUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.DelTransformUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DelTransformUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallInviteCatFailUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.InviteCatFailUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteCatFailUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallTrigNpcFuncUserEvent(npcguid, funcid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.TrigNpcFuncUserEvent()
    if msg == nil then
      msg = {}
    end
    msg.npcguid = npcguid
    if msg == nil then
      msg = {}
    end
    msg.funcid = funcid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TrigNpcFuncUserEvent.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcguid = npcguid
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.funcid = funcid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSystemStringUserEvent(etype)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SystemStringUserEvent()
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SystemStringUserEvent.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallHandCatUserEvent(catguid, breakup)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.HandCatUserEvent()
    if msg == nil then
      msg = {}
    end
    msg.catguid = catguid
    if breakup ~= nil then
      msg.breakup = breakup
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HandCatUserEvent.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.catguid = catguid
    if breakup ~= nil then
      msgParam.breakup = breakup
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallChangeTitle(title_data, charid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ChangeTitle()
    if title_data ~= nil and title_data.title_type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_data == nil then
        msg.title_data = {}
      end
      msg.title_data.title_type = title_data.title_type
    end
    if title_data ~= nil and title_data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_data == nil then
        msg.title_data = {}
      end
      msg.title_data.id = title_data.id
    end
    if title_data ~= nil and title_data.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.title_data == nil then
        msg.title_data = {}
      end
      msg.title_data.createtime = title_data.createtime
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeTitle.id
    local msgParam = {}
    if title_data ~= nil and title_data.title_type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_data == nil then
        msgParam.title_data = {}
      end
      msgParam.title_data.title_type = title_data.title_type
    end
    if title_data ~= nil and title_data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_data == nil then
        msgParam.title_data = {}
      end
      msgParam.title_data.id = title_data.id
    end
    if title_data ~= nil and title_data.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.title_data == nil then
        msgParam.title_data = {}
      end
      msgParam.title_data.createtime = title_data.createtime
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryChargeCnt(info)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryChargeCnt()
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryChargeCnt.id
    local msgParam = {}
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallNTFMonthCardEnd()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.NTFMonthCardEnd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NTFMonthCardEnd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallLoveLetterUse(itemguid, targets, content, type)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.LoveLetterUse()
    if itemguid ~= nil then
      msg.itemguid = itemguid
    end
    if targets ~= nil then
      msg.targets = targets
    end
    if content ~= nil then
      msg.content = content
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LoveLetterUse.id
    local msgParam = {}
    if itemguid ~= nil then
      msgParam.itemguid = itemguid
    end
    if targets ~= nil then
      msgParam.targets = targets
    end
    if content ~= nil then
      msgParam.content = content
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryActivityCnt(info)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryActivityCnt()
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryActivityCnt.id
    local msgParam = {}
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallUpdateActivityCnt(info)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.UpdateActivityCnt()
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.count = info.count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateActivityCnt.id
    local msgParam = {}
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.count = info.count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallNtfVersionCardInfo(info)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.NtfVersionCardInfo()
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfVersionCardInfo.id
    local msgParam = {}
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallDieTimeCountEventCmd(time, name)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.DieTimeCountEventCmd()
    if time ~= nil then
      msg.time = time
    end
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DieTimeCountEventCmd.id
    local msgParam = {}
    if time ~= nil then
      msgParam.time = time
    end
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGetFirstShareRewardUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GetFirstShareRewardUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetFirstShareRewardUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryResetTimeEventCmd(etype, resettime)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryResetTimeEventCmd()
    if msg == nil then
      msg = {}
    end
    msg.etype = etype
    if resettime ~= nil then
      msg.resettime = resettime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryResetTimeEventCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.etype = etype
    if resettime ~= nil then
      msgParam.resettime = resettime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallInOutActEventCmd(actid, inout)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.InOutActEventCmd()
    if msg == nil then
      msg = {}
    end
    msg.actid = actid
    if inout ~= nil then
      msg.inout = inout
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InOutActEventCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.actid = actid
    if inout ~= nil then
      msgParam.inout = inout
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallUserEventMailCmd(eType, param32, param64)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.UserEventMailCmd()
    if eType ~= nil then
      msg.eType = eType
    end
    if param32 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.param32 == nil then
        msg.param32 = {}
      end
      for i = 1, #param32 do
        table.insert(msg.param32, param32[i])
      end
    end
    if param64 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.param64 == nil then
        msg.param64 = {}
      end
      for i = 1, #param64 do
        table.insert(msg.param64, param64[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserEventMailCmd.id
    local msgParam = {}
    if eType ~= nil then
      msgParam.eType = eType
    end
    if param32 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.param32 == nil then
        msgParam.param32 = {}
      end
      for i = 1, #param32 do
        table.insert(msgParam.param32, param32[i])
      end
    end
    if param64 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.param64 == nil then
        msgParam.param64 = {}
      end
      for i = 1, #param64 do
        table.insert(msgParam.param64, param64[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallLevelupDeadUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.LevelupDeadUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LevelupDeadUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSwitchAutoBattleUserEvent(open)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SwitchAutoBattleUserEvent()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SwitchAutoBattleUserEvent.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGoActivityMapUserEvent(actid, mapid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GoActivityMapUserEvent()
    if actid ~= nil then
      msg.actid = actid
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoActivityMapUserEvent.id
    local msgParam = {}
    if actid ~= nil then
      msgParam.actid = actid
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallActivityPointUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ActivityPointUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivityPointUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryFavoriteFriendUserEvent(charid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryFavoriteFriendUserEvent()
    if charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.charid == nil then
        msg.charid = {}
      end
      for i = 1, #charid do
        table.insert(msg.charid, charid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFavoriteFriendUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.charid == nil then
        msgParam.charid = {}
      end
      for i = 1, #charid do
        table.insert(msgParam.charid, charid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallUpdateFavoriteFriendUserEvent(updateids, delids)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.UpdateFavoriteFriendUserEvent()
    if updateids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updateids == nil then
        msg.updateids = {}
      end
      for i = 1, #updateids do
        table.insert(msg.updateids, updateids[i])
      end
    end
    if delids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delids == nil then
        msg.delids = {}
      end
      for i = 1, #delids do
        table.insert(msg.delids, delids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateFavoriteFriendUserEvent.id
    local msgParam = {}
    if updateids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updateids == nil then
        msgParam.updateids = {}
      end
      for i = 1, #updateids do
        table.insert(msgParam.updateids, updateids[i])
      end
    end
    if delids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delids == nil then
        msgParam.delids = {}
      end
      for i = 1, #delids do
        table.insert(msgParam.delids, delids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallActionFavoriteFriendUserEvent(addids, delids)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ActionFavoriteFriendUserEvent()
    if addids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addids == nil then
        msg.addids = {}
      end
      for i = 1, #addids do
        table.insert(msg.addids, addids[i])
      end
    end
    if delids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delids == nil then
        msg.delids = {}
      end
      for i = 1, #delids do
        table.insert(msg.delids, delids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActionFavoriteFriendUserEvent.id
    local msgParam = {}
    if addids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addids == nil then
        msgParam.addids = {}
      end
      for i = 1, #addids do
        table.insert(msgParam.addids, addids[i])
      end
    end
    if delids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delids == nil then
        msgParam.delids = {}
      end
      for i = 1, #delids do
        table.insert(msgParam.delids, delids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSoundStoryUserEvent(id, times, replace, forcestop, bgmkeep, replacecontext)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SoundStoryUserEvent()
    if id ~= nil then
      msg.id = id
    end
    if times ~= nil then
      msg.times = times
    end
    if replace ~= nil then
      msg.replace = replace
    end
    if forcestop ~= nil then
      msg.forcestop = forcestop
    end
    if bgmkeep ~= nil then
      msg.bgmkeep = bgmkeep
    end
    if replacecontext ~= nil then
      msg.replacecontext = replacecontext
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SoundStoryUserEvent.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if times ~= nil then
      msgParam.times = times
    end
    if replace ~= nil then
      msgParam.replace = replace
    end
    if forcestop ~= nil then
      msgParam.forcestop = forcestop
    end
    if bgmkeep ~= nil then
      msgParam.bgmkeep = bgmkeep
    end
    if replacecontext ~= nil then
      msgParam.replacecontext = replacecontext
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallThemeDetailsUserEvent(type)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ThemeDetailsUserEvent()
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ThemeDetailsUserEvent.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallCameraActionUserEvent(params)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.CameraActionUserEvent()
    if params ~= nil then
      msg.params = params
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CameraActionUserEvent.id
    local msgParam = {}
    if params ~= nil then
      msgParam.params = params
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallBifrostContributeItemUserEvent(id, times)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.BifrostContributeItemUserEvent()
    if id ~= nil then
      msg.id = id
    end
    if times ~= nil then
      msg.times = times
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BifrostContributeItemUserEvent.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if times ~= nil then
      msgParam.times = times
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallRobotOffBattleUserEvent(inplace, protect_team, monsterids)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.RobotOffBattleUserEvent()
    if inplace ~= nil then
      msg.inplace = inplace
    end
    if protect_team ~= nil then
      msg.protect_team = protect_team
    end
    if monsterids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.monsterids == nil then
        msg.monsterids = {}
      end
      for i = 1, #monsterids do
        table.insert(msg.monsterids, monsterids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RobotOffBattleUserEvent.id
    local msgParam = {}
    if inplace ~= nil then
      msgParam.inplace = inplace
    end
    if protect_team ~= nil then
      msgParam.protect_team = protect_team
    end
    if monsterids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.monsterids == nil then
        msgParam.monsterids = {}
      end
      for i = 1, #monsterids do
        table.insert(msgParam.monsterids, monsterids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryAccChargeCntReward(infos)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryAccChargeCntReward()
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
    local msgId = ProtoReqInfoList.QueryAccChargeCntReward.id
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

function ServiceUserEventAutoProxy:CallChargeSdkRequestUserEvent(dataid, client_timestamp)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ChargeSdkRequestUserEvent()
    if dataid ~= nil then
      msg.dataid = dataid
    end
    if client_timestamp ~= nil then
      msg.client_timestamp = client_timestamp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChargeSdkRequestUserEvent.id
    local msgParam = {}
    if dataid ~= nil then
      msgParam.dataid = dataid
    end
    if client_timestamp ~= nil then
      msgParam.client_timestamp = client_timestamp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallChargeSdkReplyUserEvent(dataid, client_timestamp, success)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ChargeSdkReplyUserEvent()
    if dataid ~= nil then
      msg.dataid = dataid
    end
    if client_timestamp ~= nil then
      msg.client_timestamp = client_timestamp
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChargeSdkReplyUserEvent.id
    local msgParam = {}
    if dataid ~= nil then
      msgParam.dataid = dataid
    end
    if client_timestamp ~= nil then
      msgParam.client_timestamp = client_timestamp
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallClientAISyncUserEvent(charid, aidata)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ClientAISyncUserEvent()
    if charid ~= nil then
      msg.charid = charid
    end
    if aidata ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.aidata == nil then
        msg.aidata = {}
      end
      for i = 1, #aidata do
        table.insert(msg.aidata, aidata[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientAISyncUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if aidata ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.aidata == nil then
        msgParam.aidata = {}
      end
      for i = 1, #aidata do
        table.insert(msgParam.aidata, aidata[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallClientAIUpdateUserEvent(charid, aidata, del)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ClientAIUpdateUserEvent()
    if charid ~= nil then
      msg.charid = charid
    end
    if aidata ~= nil and aidata.eventid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.aidata == nil then
        msg.aidata = {}
      end
      msg.aidata.eventid = aidata.eventid
    end
    if aidata ~= nil and aidata.param32 ~= nil then
      if msg.aidata == nil then
        msg.aidata = {}
      end
      if msg.aidata.param32 == nil then
        msg.aidata.param32 = {}
      end
      for i = 1, #aidata.param32 do
        table.insert(msg.aidata.param32, aidata.param32[i])
      end
    end
    if aidata ~= nil and aidata.param64 ~= nil then
      if msg.aidata == nil then
        msg.aidata = {}
      end
      if msg.aidata.param64 == nil then
        msg.aidata.param64 = {}
      end
      for i = 1, #aidata.param64 do
        table.insert(msg.aidata.param64, aidata.param64[i])
      end
    end
    if aidata ~= nil and aidata.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.aidata == nil then
        msg.aidata = {}
      end
      msg.aidata.guid = aidata.guid
    end
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientAIUpdateUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if aidata ~= nil and aidata.eventid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.aidata == nil then
        msgParam.aidata = {}
      end
      msgParam.aidata.eventid = aidata.eventid
    end
    if aidata ~= nil and aidata.param32 ~= nil then
      if msgParam.aidata == nil then
        msgParam.aidata = {}
      end
      if msgParam.aidata.param32 == nil then
        msgParam.aidata.param32 = {}
      end
      for i = 1, #aidata.param32 do
        table.insert(msgParam.aidata.param32, aidata.param32[i])
      end
    end
    if aidata ~= nil and aidata.param64 ~= nil then
      if msgParam.aidata == nil then
        msgParam.aidata = {}
      end
      if msgParam.aidata.param64 == nil then
        msgParam.aidata.param64 = {}
      end
      for i = 1, #aidata.param64 do
        table.insert(msgParam.aidata.param64, aidata.param64[i])
      end
    end
    if aidata ~= nil and aidata.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.aidata == nil then
        msgParam.aidata = {}
      end
      msgParam.aidata.guid = aidata.guid
    end
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGiftCodeExchangeEvent(code)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GiftCodeExchangeEvent()
    if code ~= nil then
      msg.code = code
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiftCodeExchangeEvent.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSetHideOtherCmd(hideid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SetHideOtherCmd()
    if hideid ~= nil then
      msg.hideid = hideid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetHideOtherCmd.id
    local msgParam = {}
    if hideid ~= nil then
      msgParam.hideid = hideid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGiftTimeLimitNtfUserEvent(infos)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GiftTimeLimitNtfUserEvent()
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
    local msgId = ProtoReqInfoList.GiftTimeLimitNtfUserEvent.id
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

function ServiceUserEventAutoProxy:CallGiftTimeLimitBuyUserEvent(id)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GiftTimeLimitBuyUserEvent()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiftTimeLimitBuyUserEvent.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGiftTimeLimitActiveUserEvent(id)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GiftTimeLimitActiveUserEvent()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiftTimeLimitActiveUserEvent.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallMultiCutSceneUpdateUserEvent(updates, dels)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.MultiCutSceneUpdateUserEvent()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MultiCutSceneUpdateUserEvent.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallPolicyUpdateUserEvent(tag)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.PolicyUpdateUserEvent()
    if tag ~= nil then
      msg.tag = tag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PolicyUpdateUserEvent.id
    local msgParam = {}
    if tag ~= nil then
      msgParam.tag = tag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallPolicyAgreeUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.PolicyAgreeUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PolicyAgreeUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallShowSceneObject(mapid, hide, npcid, objectid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ShowSceneObject()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if hide ~= nil then
      msg.hide = hide
    end
    if npcid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcid == nil then
        msg.npcid = {}
      end
      for i = 1, #npcid do
        table.insert(msg.npcid, npcid[i])
      end
    end
    if objectid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.objectid == nil then
        msg.objectid = {}
      end
      for i = 1, #objectid do
        table.insert(msg.objectid, objectid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShowSceneObject.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if hide ~= nil then
      msgParam.hide = hide
    end
    if npcid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcid == nil then
        msgParam.npcid = {}
      end
      for i = 1, #npcid do
        table.insert(msgParam.npcid, npcid[i])
      end
    end
    if objectid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.objectid == nil then
        msgParam.objectid = {}
      end
      for i = 1, #objectid do
        table.insert(msgParam.objectid, objectid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallDoubleAcionEvent(userid, actionid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.DoubleAcionEvent()
    if userid ~= nil then
      msg.userid = userid
    end
    if actionid ~= nil then
      msg.actionid = actionid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DoubleAcionEvent.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    if actionid ~= nil then
      msgParam.actionid = actionid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallBeginMonitorUserEvent(charid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.BeginMonitorUserEvent()
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeginMonitorUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallStopMonitorUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.StopMonitorUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopMonitorUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallStopMonitorRetUserEvent()
  if not NetConfig.PBC then
    local msg = UserEvent_pb.StopMonitorRetUserEvent()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopMonitorRetUserEvent.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallMonitorGoToMapUserEvent(monitor_charid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.MonitorGoToMapUserEvent()
    if monitor_charid ~= nil then
      msg.monitor_charid = monitor_charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MonitorGoToMapUserEvent.id
    local msgParam = {}
    if monitor_charid ~= nil then
      msgParam.monitor_charid = monitor_charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallMonitorMapEndUserEvent(monitor_accid, monitor_charid, monitor_proxyid, mapid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.MonitorMapEndUserEvent()
    if monitor_accid ~= nil then
      msg.monitor_accid = monitor_accid
    end
    if monitor_charid ~= nil then
      msg.monitor_charid = monitor_charid
    end
    if monitor_proxyid ~= nil then
      msg.monitor_proxyid = monitor_proxyid
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MonitorMapEndUserEvent.id
    local msgParam = {}
    if monitor_accid ~= nil then
      msgParam.monitor_accid = monitor_accid
    end
    if monitor_charid ~= nil then
      msgParam.monitor_charid = monitor_charid
    end
    if monitor_proxyid ~= nil then
      msgParam.monitor_proxyid = monitor_proxyid
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallMonitorBuildUserEvent(be_monitor_charid, be_monitor_accid, be_monitor_proxyid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.MonitorBuildUserEvent()
    if be_monitor_charid ~= nil then
      msg.be_monitor_charid = be_monitor_charid
    end
    if be_monitor_accid ~= nil then
      msg.be_monitor_accid = be_monitor_accid
    end
    if be_monitor_proxyid ~= nil then
      msg.be_monitor_proxyid = be_monitor_proxyid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MonitorBuildUserEvent.id
    local msgParam = {}
    if be_monitor_charid ~= nil then
      msgParam.be_monitor_charid = be_monitor_charid
    end
    if be_monitor_accid ~= nil then
      msgParam.be_monitor_accid = be_monitor_accid
    end
    if be_monitor_proxyid ~= nil then
      msgParam.be_monitor_proxyid = be_monitor_proxyid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGuideQuestEvent(targetid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GuideQuestEvent()
    if targetid ~= nil then
      msg.targetid = targetid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuideQuestEvent.id
    local msgParam = {}
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallShowCardEvent(cardid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ShowCardEvent()
    if cardid ~= nil then
      msg.cardid = cardid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShowCardEvent.id
    local msgParam = {}
    if cardid ~= nil then
      msgParam.cardid = cardid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGvgOptStatueEvent(exterior, pose)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GvgOptStatueEvent()
    if exterior ~= nil then
      msg.exterior = exterior
    end
    if pose ~= nil then
      msg.pose = pose
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgOptStatueEvent.id
    local msgParam = {}
    if exterior ~= nil then
      msgParam.exterior = exterior
    end
    if pose ~= nil then
      msgParam.pose = pose
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallTimeLimitIconEvent(show_items, show_deposits)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.TimeLimitIconEvent()
    if show_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.show_items == nil then
        msg.show_items = {}
      end
      for i = 1, #show_items do
        table.insert(msg.show_items, show_items[i])
      end
    end
    if show_deposits ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.show_deposits == nil then
        msg.show_deposits = {}
      end
      for i = 1, #show_deposits do
        table.insert(msg.show_deposits, show_deposits[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TimeLimitIconEvent.id
    local msgParam = {}
    if show_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.show_items == nil then
        msgParam.show_items = {}
      end
      for i = 1, #show_items do
        table.insert(msgParam.show_items, show_items[i])
      end
    end
    if show_deposits ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.show_deposits == nil then
        msgParam.show_deposits = {}
      end
      for i = 1, #show_deposits do
        table.insert(msgParam.show_deposits, show_deposits[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallShowRMBGiftEvent(show)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ShowRMBGiftEvent()
    if show ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.show == nil then
        msg.show = {}
      end
      for i = 1, #show do
        table.insert(msg.show, show[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShowRMBGiftEvent.id
    local msgParam = {}
    if show ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.show == nil then
        msgParam.show = {}
      end
      for i = 1, #show do
        table.insert(msgParam.show, show[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallConfigActionUserEvent(action, sessionid, name, infos, over)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ConfigActionUserEvent()
    if action ~= nil then
      msg.action = action
    end
    if sessionid ~= nil then
      msg.sessionid = sessionid
    end
    if name ~= nil then
      msg.name = name
    end
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
    if over ~= nil then
      msg.over = over
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ConfigActionUserEvent.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if sessionid ~= nil then
      msgParam.sessionid = sessionid
    end
    if name ~= nil then
      msgParam.name = name
    end
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
    if over ~= nil then
      msgParam.over = over
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallNpcWalkStepNtfUserEvent(guid, id, walkid, type)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.NpcWalkStepNtfUserEvent()
    if guid ~= nil then
      msg.guid = guid
    end
    if id ~= nil then
      msg.id = id
    end
    if walkid ~= nil then
      msg.walkid = walkid
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcWalkStepNtfUserEvent.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if id ~= nil then
      msgParam.id = id
    end
    if walkid ~= nil then
      msgParam.walkid = walkid
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSetProfileUserEvent(profile)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SetProfileUserEvent()
    if profile ~= nil and profile.birthmonth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.birthmonth = profile.birthmonth
    end
    if profile ~= nil and profile.birthday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.birthday = profile.birthday
    end
    if profile ~= nil and profile.needpartner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.needpartner = profile.needpartner
    end
    if profile ~= nil and profile.signtext ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.signtext = profile.signtext
    end
    if profile ~= nil and profile.label ~= nil then
      if msg.profile == nil then
        msg.profile = {}
      end
      if msg.profile.label == nil then
        msg.profile.label = {}
      end
      for i = 1, #profile.label do
        table.insert(msg.profile.label, profile.label[i])
      end
    end
    if profile ~= nil and profile.unlocklabels ~= nil then
      if msg.profile == nil then
        msg.profile = {}
      end
      if msg.profile.unlocklabels == nil then
        msg.profile.unlocklabels = {}
      end
      for i = 1, #profile.unlocklabels do
        table.insert(msg.profile.unlocklabels, profile.unlocklabels[i])
      end
    end
    if profile ~= nil and profile.birthupdatetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.birthupdatetime = profile.birthupdatetime
    end
    if profile ~= nil and profile.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.version = profile.version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetProfileUserEvent.id
    local msgParam = {}
    if profile ~= nil and profile.birthmonth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.birthmonth = profile.birthmonth
    end
    if profile ~= nil and profile.birthday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.birthday = profile.birthday
    end
    if profile ~= nil and profile.needpartner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.needpartner = profile.needpartner
    end
    if profile ~= nil and profile.signtext ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.signtext = profile.signtext
    end
    if profile ~= nil and profile.label ~= nil then
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      if msgParam.profile.label == nil then
        msgParam.profile.label = {}
      end
      for i = 1, #profile.label do
        table.insert(msgParam.profile.label, profile.label[i])
      end
    end
    if profile ~= nil and profile.unlocklabels ~= nil then
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      if msgParam.profile.unlocklabels == nil then
        msgParam.profile.unlocklabels = {}
      end
      for i = 1, #profile.unlocklabels do
        table.insert(msgParam.profile.unlocklabels, profile.unlocklabels[i])
      end
    end
    if profile ~= nil and profile.birthupdatetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.birthupdatetime = profile.birthupdatetime
    end
    if profile ~= nil and profile.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.version = profile.version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryFateRelationEvent(id)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryFateRelationEvent()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFateRelationEvent.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSyncFateRelationEvent(fateval, fateid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SyncFateRelationEvent()
    if fateval ~= nil then
      msg.fateval = fateval
    end
    if fateid ~= nil then
      msg.fateid = fateid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncFateRelationEvent.id
    local msgParam = {}
    if fateval ~= nil then
      msgParam.fateval = fateval
    end
    if fateid ~= nil then
      msgParam.fateid = fateid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryProfileUserEvent(charid, profile)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryProfileUserEvent()
    if charid ~= nil then
      msg.charid = charid
    end
    if profile ~= nil and profile.birthmonth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.birthmonth = profile.birthmonth
    end
    if profile ~= nil and profile.birthday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.birthday = profile.birthday
    end
    if profile ~= nil and profile.needpartner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.needpartner = profile.needpartner
    end
    if profile ~= nil and profile.signtext ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.signtext = profile.signtext
    end
    if profile ~= nil and profile.label ~= nil then
      if msg.profile == nil then
        msg.profile = {}
      end
      if msg.profile.label == nil then
        msg.profile.label = {}
      end
      for i = 1, #profile.label do
        table.insert(msg.profile.label, profile.label[i])
      end
    end
    if profile ~= nil and profile.unlocklabels ~= nil then
      if msg.profile == nil then
        msg.profile = {}
      end
      if msg.profile.unlocklabels == nil then
        msg.profile.unlocklabels = {}
      end
      for i = 1, #profile.unlocklabels do
        table.insert(msg.profile.unlocklabels, profile.unlocklabels[i])
      end
    end
    if profile ~= nil and profile.birthupdatetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.birthupdatetime = profile.birthupdatetime
    end
    if profile ~= nil and profile.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profile == nil then
        msg.profile = {}
      end
      msg.profile.version = profile.version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryProfileUserEvent.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if profile ~= nil and profile.birthmonth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.birthmonth = profile.birthmonth
    end
    if profile ~= nil and profile.birthday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.birthday = profile.birthday
    end
    if profile ~= nil and profile.needpartner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.needpartner = profile.needpartner
    end
    if profile ~= nil and profile.signtext ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.signtext = profile.signtext
    end
    if profile ~= nil and profile.label ~= nil then
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      if msgParam.profile.label == nil then
        msgParam.profile.label = {}
      end
      for i = 1, #profile.label do
        table.insert(msgParam.profile.label, profile.label[i])
      end
    end
    if profile ~= nil and profile.unlocklabels ~= nil then
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      if msgParam.profile.unlocklabels == nil then
        msgParam.profile.unlocklabels = {}
      end
      for i = 1, #profile.unlocklabels do
        table.insert(msgParam.profile.unlocklabels, profile.unlocklabels[i])
      end
    end
    if profile ~= nil and profile.birthupdatetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.birthupdatetime = profile.birthupdatetime
    end
    if profile ~= nil and profile.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profile == nil then
        msgParam.profile = {}
      end
      msgParam.profile.version = profile.version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallGvgSandTableEvent(gvg_group, starttime, endtime, info, nomore_smallmetal)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.GvgSandTableEvent()
    if gvg_group ~= nil then
      msg.gvg_group = gvg_group
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    if nomore_smallmetal ~= nil then
      msg.nomore_smallmetal = nomore_smallmetal
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgSandTableEvent.id
    local msgParam = {}
    if gvg_group ~= nil then
      msgParam.gvg_group = gvg_group
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    if nomore_smallmetal ~= nil then
      msgParam.nomore_smallmetal = nomore_smallmetal
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSetReliveMethodUserEvent(relive_method)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SetReliveMethodUserEvent()
    if relive_method ~= nil then
      msg.relive_method = relive_method
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetReliveMethodUserEvent.id
    local msgParam = {}
    if relive_method ~= nil then
      msgParam.relive_method = relive_method
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallUIActionUserEvent(params)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.UIActionUserEvent()
    if params ~= nil then
      msg.params = params
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UIActionUserEvent.id
    local msgParam = {}
    if params ~= nil then
      msgParam.params = params
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallPlayCutSceneUserEvent(params)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.PlayCutSceneUserEvent()
    if params ~= nil then
      msg.params = params
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlayCutSceneUserEvent.id
    local msgParam = {}
    if params ~= nil then
      msgParam.params = params
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallReqPeriodicMonsterUserEvent(killed_monsters)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ReqPeriodicMonsterUserEvent()
    if killed_monsters ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.killed_monsters == nil then
        msg.killed_monsters = {}
      end
      for i = 1, #killed_monsters do
        table.insert(msg.killed_monsters, killed_monsters[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqPeriodicMonsterUserEvent.id
    local msgParam = {}
    if killed_monsters ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.killed_monsters == nil then
        msgParam.killed_monsters = {}
      end
      for i = 1, #killed_monsters do
        table.insert(msgParam.killed_monsters, killed_monsters[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallPlayHoldPetUserEvent(params)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.PlayHoldPetUserEvent()
    if params ~= nil then
      msg.params = params
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlayHoldPetUserEvent.id
    local msgParam = {}
    if params ~= nil then
      msgParam.params = params
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQuerySpeedUpUserEvent(month_card_effect, exp_item_branchs, in_max_profession, server_open_day, base_speedup, job_speedup, gem_speedup)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QuerySpeedUpUserEvent()
    if month_card_effect ~= nil then
      msg.month_card_effect = month_card_effect
    end
    if exp_item_branchs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.exp_item_branchs == nil then
        msg.exp_item_branchs = {}
      end
      for i = 1, #exp_item_branchs do
        table.insert(msg.exp_item_branchs, exp_item_branchs[i])
      end
    end
    if in_max_profession ~= nil then
      msg.in_max_profession = in_max_profession
    end
    if server_open_day ~= nil then
      msg.server_open_day = server_open_day
    end
    if base_speedup ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.base_speedup == nil then
        msg.base_speedup = {}
      end
      for i = 1, #base_speedup do
        table.insert(msg.base_speedup, base_speedup[i])
      end
    end
    if job_speedup ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job_speedup == nil then
        msg.job_speedup = {}
      end
      for i = 1, #job_speedup do
        table.insert(msg.job_speedup, job_speedup[i])
      end
    end
    if gem_speedup ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gem_speedup == nil then
        msg.gem_speedup = {}
      end
      for i = 1, #gem_speedup do
        table.insert(msg.gem_speedup, gem_speedup[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuerySpeedUpUserEvent.id
    local msgParam = {}
    if month_card_effect ~= nil then
      msgParam.month_card_effect = month_card_effect
    end
    if exp_item_branchs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.exp_item_branchs == nil then
        msgParam.exp_item_branchs = {}
      end
      for i = 1, #exp_item_branchs do
        table.insert(msgParam.exp_item_branchs, exp_item_branchs[i])
      end
    end
    if in_max_profession ~= nil then
      msgParam.in_max_profession = in_max_profession
    end
    if server_open_day ~= nil then
      msgParam.server_open_day = server_open_day
    end
    if base_speedup ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.base_speedup == nil then
        msgParam.base_speedup = {}
      end
      for i = 1, #base_speedup do
        table.insert(msgParam.base_speedup, base_speedup[i])
      end
    end
    if job_speedup ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job_speedup == nil then
        msgParam.job_speedup = {}
      end
      for i = 1, #job_speedup do
        table.insert(msgParam.job_speedup, job_speedup[i])
      end
    end
    if gem_speedup ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gem_speedup == nil then
        msgParam.gem_speedup = {}
      end
      for i = 1, #gem_speedup do
        table.insert(msgParam.gem_speedup, gem_speedup[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallServerOpenTimeUserEvent(opentime)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.ServerOpenTimeUserEvent()
    if opentime ~= nil then
      msg.opentime = opentime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServerOpenTimeUserEvent.id
    local msgParam = {}
    if opentime ~= nil then
      msgParam.opentime = opentime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallSkillDamageStatUserEvent(skillid, ave_dam, dam_distri)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.SkillDamageStatUserEvent()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    if ave_dam ~= nil then
      msg.ave_dam = ave_dam
    end
    if dam_distri ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dam_distri == nil then
        msg.dam_distri = {}
      end
      for i = 1, #dam_distri do
        table.insert(msg.dam_distri, dam_distri[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillDamageStatUserEvent.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    if ave_dam ~= nil then
      msgParam.ave_dam = ave_dam
    end
    if dam_distri ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dam_distri == nil then
        msgParam.dam_distri = {}
      end
      for i = 1, #dam_distri do
        table.insert(msgParam.dam_distri, dam_distri[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallHeartBeatReqUserEvent(codec_group, codec_seed, themis_data)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.HeartBeatReqUserEvent()
    if codec_group ~= nil then
      msg.codec_group = codec_group
    end
    if codec_seed ~= nil then
      msg.codec_seed = codec_seed
    end
    if themis_data ~= nil then
      msg.themis_data = themis_data
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeartBeatReqUserEvent.id
    local msgParam = {}
    if codec_group ~= nil then
      msgParam.codec_group = codec_group
    end
    if codec_seed ~= nil then
      msgParam.codec_seed = codec_seed
    end
    if themis_data ~= nil then
      msgParam.themis_data = themis_data
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallHeartBeatAckUserEvent(codec_group, codec_seed)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.HeartBeatAckUserEvent()
    if codec_group ~= nil then
      msg.codec_group = codec_group
    end
    if codec_seed ~= nil then
      msg.codec_seed = codec_seed
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeartBeatAckUserEvent.id
    local msgParam = {}
    if codec_group ~= nil then
      msgParam.codec_group = codec_group
    end
    if codec_seed ~= nil then
      msgParam.codec_seed = codec_seed
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallQueryUserReportListUserEvent(reports)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.QueryUserReportListUserEvent()
    if reports ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reports == nil then
        msg.reports = {}
      end
      for i = 1, #reports do
        table.insert(msg.reports, reports[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserReportListUserEvent.id
    local msgParam = {}
    if reports ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reports == nil then
        msgParam.reports = {}
      end
      for i = 1, #reports do
        table.insert(msgParam.reports, reports[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:CallUserReportUserEvent(report, msgid)
  if not NetConfig.PBC then
    local msg = UserEvent_pb.UserReportUserEvent()
    if report ~= nil and report.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.report == nil then
        msg.report = {}
      end
      msg.report.charid = report.charid
    end
    if report ~= nil and report.last_report_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.report == nil then
        msg.report = {}
      end
      msg.report.last_report_time = report.last_report_time
    end
    if report ~= nil and report.reasons ~= nil then
      if msg.report == nil then
        msg.report = {}
      end
      if msg.report.reasons == nil then
        msg.report.reasons = {}
      end
      for i = 1, #report.reasons do
        table.insert(msg.report.reasons, report.reasons[i])
      end
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReportUserEvent.id
    local msgParam = {}
    if report ~= nil and report.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.report == nil then
        msgParam.report = {}
      end
      msgParam.report.charid = report.charid
    end
    if report ~= nil and report.last_report_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.report == nil then
        msgParam.report = {}
      end
      msgParam.report.last_report_time = report.last_report_time
    end
    if report ~= nil and report.reasons ~= nil then
      if msgParam.report == nil then
        msgParam.report = {}
      end
      if msgParam.report.reasons == nil then
        msgParam.report.reasons = {}
      end
      for i = 1, #report.reasons do
        table.insert(msgParam.report.reasons, report.reasons[i])
      end
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserEventAutoProxy:RecvFirstActionUserEvent(data)
  self:Notify(ServiceEvent.UserEventFirstActionUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvDamageNpcUserEvent(data)
  self:Notify(ServiceEvent.UserEventDamageNpcUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvNewTitle(data)
  self:Notify(ServiceEvent.UserEventNewTitle, data)
end

function ServiceUserEventAutoProxy:RecvAllTitle(data)
  self:Notify(ServiceEvent.UserEventAllTitle, data)
end

function ServiceUserEventAutoProxy:RecvUpdateRandomUserEvent(data)
  self:Notify(ServiceEvent.UserEventUpdateRandomUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvBuffDamageUserEvent(data)
  self:Notify(ServiceEvent.UserEventBuffDamageUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvChargeNtfUserEvent(data)
  self:Notify(ServiceEvent.UserEventChargeNtfUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvChargeQueryCmd(data)
  self:Notify(ServiceEvent.UserEventChargeQueryCmd, data)
end

function ServiceUserEventAutoProxy:RecvDepositCardInfo(data)
  self:Notify(ServiceEvent.UserEventDepositCardInfo, data)
end

function ServiceUserEventAutoProxy:RecvDelTransformUserEvent(data)
  self:Notify(ServiceEvent.UserEventDelTransformUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvInviteCatFailUserEvent(data)
  self:Notify(ServiceEvent.UserEventInviteCatFailUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvTrigNpcFuncUserEvent(data)
  self:Notify(ServiceEvent.UserEventTrigNpcFuncUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvSystemStringUserEvent(data)
  self:Notify(ServiceEvent.UserEventSystemStringUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvHandCatUserEvent(data)
  self:Notify(ServiceEvent.UserEventHandCatUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvChangeTitle(data)
  self:Notify(ServiceEvent.UserEventChangeTitle, data)
end

function ServiceUserEventAutoProxy:RecvQueryChargeCnt(data)
  self:Notify(ServiceEvent.UserEventQueryChargeCnt, data)
end

function ServiceUserEventAutoProxy:RecvNTFMonthCardEnd(data)
  self:Notify(ServiceEvent.UserEventNTFMonthCardEnd, data)
end

function ServiceUserEventAutoProxy:RecvLoveLetterUse(data)
  self:Notify(ServiceEvent.UserEventLoveLetterUse, data)
end

function ServiceUserEventAutoProxy:RecvQueryActivityCnt(data)
  self:Notify(ServiceEvent.UserEventQueryActivityCnt, data)
end

function ServiceUserEventAutoProxy:RecvUpdateActivityCnt(data)
  self:Notify(ServiceEvent.UserEventUpdateActivityCnt, data)
end

function ServiceUserEventAutoProxy:RecvNtfVersionCardInfo(data)
  self:Notify(ServiceEvent.UserEventNtfVersionCardInfo, data)
end

function ServiceUserEventAutoProxy:RecvDieTimeCountEventCmd(data)
  self:Notify(ServiceEvent.UserEventDieTimeCountEventCmd, data)
end

function ServiceUserEventAutoProxy:RecvGetFirstShareRewardUserEvent(data)
  self:Notify(ServiceEvent.UserEventGetFirstShareRewardUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvQueryResetTimeEventCmd(data)
  self:Notify(ServiceEvent.UserEventQueryResetTimeEventCmd, data)
end

function ServiceUserEventAutoProxy:RecvInOutActEventCmd(data)
  self:Notify(ServiceEvent.UserEventInOutActEventCmd, data)
end

function ServiceUserEventAutoProxy:RecvUserEventMailCmd(data)
  self:Notify(ServiceEvent.UserEventUserEventMailCmd, data)
end

function ServiceUserEventAutoProxy:RecvLevelupDeadUserEvent(data)
  self:Notify(ServiceEvent.UserEventLevelupDeadUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvSwitchAutoBattleUserEvent(data)
  self:Notify(ServiceEvent.UserEventSwitchAutoBattleUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvGoActivityMapUserEvent(data)
  self:Notify(ServiceEvent.UserEventGoActivityMapUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvActivityPointUserEvent(data)
  self:Notify(ServiceEvent.UserEventActivityPointUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvQueryFavoriteFriendUserEvent(data)
  self:Notify(ServiceEvent.UserEventQueryFavoriteFriendUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvUpdateFavoriteFriendUserEvent(data)
  self:Notify(ServiceEvent.UserEventUpdateFavoriteFriendUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvActionFavoriteFriendUserEvent(data)
  self:Notify(ServiceEvent.UserEventActionFavoriteFriendUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvSoundStoryUserEvent(data)
  self:Notify(ServiceEvent.UserEventSoundStoryUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvThemeDetailsUserEvent(data)
  self:Notify(ServiceEvent.UserEventThemeDetailsUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvCameraActionUserEvent(data)
  self:Notify(ServiceEvent.UserEventCameraActionUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvBifrostContributeItemUserEvent(data)
  self:Notify(ServiceEvent.UserEventBifrostContributeItemUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvRobotOffBattleUserEvent(data)
  self:Notify(ServiceEvent.UserEventRobotOffBattleUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvQueryAccChargeCntReward(data)
  self:Notify(ServiceEvent.UserEventQueryAccChargeCntReward, data)
end

function ServiceUserEventAutoProxy:RecvChargeSdkRequestUserEvent(data)
  self:Notify(ServiceEvent.UserEventChargeSdkRequestUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvChargeSdkReplyUserEvent(data)
  self:Notify(ServiceEvent.UserEventChargeSdkReplyUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvClientAISyncUserEvent(data)
  self:Notify(ServiceEvent.UserEventClientAISyncUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvClientAIUpdateUserEvent(data)
  self:Notify(ServiceEvent.UserEventClientAIUpdateUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvGiftCodeExchangeEvent(data)
  self:Notify(ServiceEvent.UserEventGiftCodeExchangeEvent, data)
end

function ServiceUserEventAutoProxy:RecvSetHideOtherCmd(data)
  self:Notify(ServiceEvent.UserEventSetHideOtherCmd, data)
end

function ServiceUserEventAutoProxy:RecvGiftTimeLimitNtfUserEvent(data)
  self:Notify(ServiceEvent.UserEventGiftTimeLimitNtfUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvGiftTimeLimitBuyUserEvent(data)
  self:Notify(ServiceEvent.UserEventGiftTimeLimitBuyUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvGiftTimeLimitActiveUserEvent(data)
  self:Notify(ServiceEvent.UserEventGiftTimeLimitActiveUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvMultiCutSceneUpdateUserEvent(data)
  self:Notify(ServiceEvent.UserEventMultiCutSceneUpdateUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvPolicyUpdateUserEvent(data)
  self:Notify(ServiceEvent.UserEventPolicyUpdateUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvPolicyAgreeUserEvent(data)
  self:Notify(ServiceEvent.UserEventPolicyAgreeUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvShowSceneObject(data)
  self:Notify(ServiceEvent.UserEventShowSceneObject, data)
end

function ServiceUserEventAutoProxy:RecvDoubleAcionEvent(data)
  self:Notify(ServiceEvent.UserEventDoubleAcionEvent, data)
end

function ServiceUserEventAutoProxy:RecvBeginMonitorUserEvent(data)
  self:Notify(ServiceEvent.UserEventBeginMonitorUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvStopMonitorUserEvent(data)
  self:Notify(ServiceEvent.UserEventStopMonitorUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvStopMonitorRetUserEvent(data)
  self:Notify(ServiceEvent.UserEventStopMonitorRetUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvMonitorGoToMapUserEvent(data)
  self:Notify(ServiceEvent.UserEventMonitorGoToMapUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvMonitorMapEndUserEvent(data)
  self:Notify(ServiceEvent.UserEventMonitorMapEndUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvMonitorBuildUserEvent(data)
  self:Notify(ServiceEvent.UserEventMonitorBuildUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvGuideQuestEvent(data)
  self:Notify(ServiceEvent.UserEventGuideQuestEvent, data)
end

function ServiceUserEventAutoProxy:RecvShowCardEvent(data)
  self:Notify(ServiceEvent.UserEventShowCardEvent, data)
end

function ServiceUserEventAutoProxy:RecvGvgOptStatueEvent(data)
  self:Notify(ServiceEvent.UserEventGvgOptStatueEvent, data)
end

function ServiceUserEventAutoProxy:RecvTimeLimitIconEvent(data)
  self:Notify(ServiceEvent.UserEventTimeLimitIconEvent, data)
end

function ServiceUserEventAutoProxy:RecvShowRMBGiftEvent(data)
  self:Notify(ServiceEvent.UserEventShowRMBGiftEvent, data)
end

function ServiceUserEventAutoProxy:RecvConfigActionUserEvent(data)
  self:Notify(ServiceEvent.UserEventConfigActionUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvNpcWalkStepNtfUserEvent(data)
  self:Notify(ServiceEvent.UserEventNpcWalkStepNtfUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvSetProfileUserEvent(data)
  self:Notify(ServiceEvent.UserEventSetProfileUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvQueryFateRelationEvent(data)
  self:Notify(ServiceEvent.UserEventQueryFateRelationEvent, data)
end

function ServiceUserEventAutoProxy:RecvSyncFateRelationEvent(data)
  self:Notify(ServiceEvent.UserEventSyncFateRelationEvent, data)
end

function ServiceUserEventAutoProxy:RecvQueryProfileUserEvent(data)
  self:Notify(ServiceEvent.UserEventQueryProfileUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvGvgSandTableEvent(data)
  self:Notify(ServiceEvent.UserEventGvgSandTableEvent, data)
end

function ServiceUserEventAutoProxy:RecvSetReliveMethodUserEvent(data)
  self:Notify(ServiceEvent.UserEventSetReliveMethodUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvUIActionUserEvent(data)
  self:Notify(ServiceEvent.UserEventUIActionUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvPlayCutSceneUserEvent(data)
  self:Notify(ServiceEvent.UserEventPlayCutSceneUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvReqPeriodicMonsterUserEvent(data)
  self:Notify(ServiceEvent.UserEventReqPeriodicMonsterUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvPlayHoldPetUserEvent(data)
  self:Notify(ServiceEvent.UserEventPlayHoldPetUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvQuerySpeedUpUserEvent(data)
  self:Notify(ServiceEvent.UserEventQuerySpeedUpUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvServerOpenTimeUserEvent(data)
  self:Notify(ServiceEvent.UserEventServerOpenTimeUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvSkillDamageStatUserEvent(data)
  self:Notify(ServiceEvent.UserEventSkillDamageStatUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvHeartBeatReqUserEvent(data)
  self:Notify(ServiceEvent.UserEventHeartBeatReqUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvHeartBeatAckUserEvent(data)
  self:Notify(ServiceEvent.UserEventHeartBeatAckUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvQueryUserReportListUserEvent(data)
  self:Notify(ServiceEvent.UserEventQueryUserReportListUserEvent, data)
end

function ServiceUserEventAutoProxy:RecvUserReportUserEvent(data)
  self:Notify(ServiceEvent.UserEventUserReportUserEvent, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.UserEventFirstActionUserEvent = "ServiceEvent_UserEventFirstActionUserEvent"
ServiceEvent.UserEventDamageNpcUserEvent = "ServiceEvent_UserEventDamageNpcUserEvent"
ServiceEvent.UserEventNewTitle = "ServiceEvent_UserEventNewTitle"
ServiceEvent.UserEventAllTitle = "ServiceEvent_UserEventAllTitle"
ServiceEvent.UserEventUpdateRandomUserEvent = "ServiceEvent_UserEventUpdateRandomUserEvent"
ServiceEvent.UserEventBuffDamageUserEvent = "ServiceEvent_UserEventBuffDamageUserEvent"
ServiceEvent.UserEventChargeNtfUserEvent = "ServiceEvent_UserEventChargeNtfUserEvent"
ServiceEvent.UserEventChargeQueryCmd = "ServiceEvent_UserEventChargeQueryCmd"
ServiceEvent.UserEventDepositCardInfo = "ServiceEvent_UserEventDepositCardInfo"
ServiceEvent.UserEventDelTransformUserEvent = "ServiceEvent_UserEventDelTransformUserEvent"
ServiceEvent.UserEventInviteCatFailUserEvent = "ServiceEvent_UserEventInviteCatFailUserEvent"
ServiceEvent.UserEventTrigNpcFuncUserEvent = "ServiceEvent_UserEventTrigNpcFuncUserEvent"
ServiceEvent.UserEventSystemStringUserEvent = "ServiceEvent_UserEventSystemStringUserEvent"
ServiceEvent.UserEventHandCatUserEvent = "ServiceEvent_UserEventHandCatUserEvent"
ServiceEvent.UserEventChangeTitle = "ServiceEvent_UserEventChangeTitle"
ServiceEvent.UserEventQueryChargeCnt = "ServiceEvent_UserEventQueryChargeCnt"
ServiceEvent.UserEventNTFMonthCardEnd = "ServiceEvent_UserEventNTFMonthCardEnd"
ServiceEvent.UserEventLoveLetterUse = "ServiceEvent_UserEventLoveLetterUse"
ServiceEvent.UserEventQueryActivityCnt = "ServiceEvent_UserEventQueryActivityCnt"
ServiceEvent.UserEventUpdateActivityCnt = "ServiceEvent_UserEventUpdateActivityCnt"
ServiceEvent.UserEventNtfVersionCardInfo = "ServiceEvent_UserEventNtfVersionCardInfo"
ServiceEvent.UserEventDieTimeCountEventCmd = "ServiceEvent_UserEventDieTimeCountEventCmd"
ServiceEvent.UserEventGetFirstShareRewardUserEvent = "ServiceEvent_UserEventGetFirstShareRewardUserEvent"
ServiceEvent.UserEventQueryResetTimeEventCmd = "ServiceEvent_UserEventQueryResetTimeEventCmd"
ServiceEvent.UserEventInOutActEventCmd = "ServiceEvent_UserEventInOutActEventCmd"
ServiceEvent.UserEventUserEventMailCmd = "ServiceEvent_UserEventUserEventMailCmd"
ServiceEvent.UserEventLevelupDeadUserEvent = "ServiceEvent_UserEventLevelupDeadUserEvent"
ServiceEvent.UserEventSwitchAutoBattleUserEvent = "ServiceEvent_UserEventSwitchAutoBattleUserEvent"
ServiceEvent.UserEventGoActivityMapUserEvent = "ServiceEvent_UserEventGoActivityMapUserEvent"
ServiceEvent.UserEventActivityPointUserEvent = "ServiceEvent_UserEventActivityPointUserEvent"
ServiceEvent.UserEventQueryFavoriteFriendUserEvent = "ServiceEvent_UserEventQueryFavoriteFriendUserEvent"
ServiceEvent.UserEventUpdateFavoriteFriendUserEvent = "ServiceEvent_UserEventUpdateFavoriteFriendUserEvent"
ServiceEvent.UserEventActionFavoriteFriendUserEvent = "ServiceEvent_UserEventActionFavoriteFriendUserEvent"
ServiceEvent.UserEventSoundStoryUserEvent = "ServiceEvent_UserEventSoundStoryUserEvent"
ServiceEvent.UserEventThemeDetailsUserEvent = "ServiceEvent_UserEventThemeDetailsUserEvent"
ServiceEvent.UserEventCameraActionUserEvent = "ServiceEvent_UserEventCameraActionUserEvent"
ServiceEvent.UserEventBifrostContributeItemUserEvent = "ServiceEvent_UserEventBifrostContributeItemUserEvent"
ServiceEvent.UserEventRobotOffBattleUserEvent = "ServiceEvent_UserEventRobotOffBattleUserEvent"
ServiceEvent.UserEventQueryAccChargeCntReward = "ServiceEvent_UserEventQueryAccChargeCntReward"
ServiceEvent.UserEventChargeSdkRequestUserEvent = "ServiceEvent_UserEventChargeSdkRequestUserEvent"
ServiceEvent.UserEventChargeSdkReplyUserEvent = "ServiceEvent_UserEventChargeSdkReplyUserEvent"
ServiceEvent.UserEventClientAISyncUserEvent = "ServiceEvent_UserEventClientAISyncUserEvent"
ServiceEvent.UserEventClientAIUpdateUserEvent = "ServiceEvent_UserEventClientAIUpdateUserEvent"
ServiceEvent.UserEventGiftCodeExchangeEvent = "ServiceEvent_UserEventGiftCodeExchangeEvent"
ServiceEvent.UserEventSetHideOtherCmd = "ServiceEvent_UserEventSetHideOtherCmd"
ServiceEvent.UserEventGiftTimeLimitNtfUserEvent = "ServiceEvent_UserEventGiftTimeLimitNtfUserEvent"
ServiceEvent.UserEventGiftTimeLimitBuyUserEvent = "ServiceEvent_UserEventGiftTimeLimitBuyUserEvent"
ServiceEvent.UserEventGiftTimeLimitActiveUserEvent = "ServiceEvent_UserEventGiftTimeLimitActiveUserEvent"
ServiceEvent.UserEventMultiCutSceneUpdateUserEvent = "ServiceEvent_UserEventMultiCutSceneUpdateUserEvent"
ServiceEvent.UserEventPolicyUpdateUserEvent = "ServiceEvent_UserEventPolicyUpdateUserEvent"
ServiceEvent.UserEventPolicyAgreeUserEvent = "ServiceEvent_UserEventPolicyAgreeUserEvent"
ServiceEvent.UserEventShowSceneObject = "ServiceEvent_UserEventShowSceneObject"
ServiceEvent.UserEventDoubleAcionEvent = "ServiceEvent_UserEventDoubleAcionEvent"
ServiceEvent.UserEventBeginMonitorUserEvent = "ServiceEvent_UserEventBeginMonitorUserEvent"
ServiceEvent.UserEventStopMonitorUserEvent = "ServiceEvent_UserEventStopMonitorUserEvent"
ServiceEvent.UserEventStopMonitorRetUserEvent = "ServiceEvent_UserEventStopMonitorRetUserEvent"
ServiceEvent.UserEventMonitorGoToMapUserEvent = "ServiceEvent_UserEventMonitorGoToMapUserEvent"
ServiceEvent.UserEventMonitorMapEndUserEvent = "ServiceEvent_UserEventMonitorMapEndUserEvent"
ServiceEvent.UserEventMonitorBuildUserEvent = "ServiceEvent_UserEventMonitorBuildUserEvent"
ServiceEvent.UserEventGuideQuestEvent = "ServiceEvent_UserEventGuideQuestEvent"
ServiceEvent.UserEventShowCardEvent = "ServiceEvent_UserEventShowCardEvent"
ServiceEvent.UserEventGvgOptStatueEvent = "ServiceEvent_UserEventGvgOptStatueEvent"
ServiceEvent.UserEventTimeLimitIconEvent = "ServiceEvent_UserEventTimeLimitIconEvent"
ServiceEvent.UserEventShowRMBGiftEvent = "ServiceEvent_UserEventShowRMBGiftEvent"
ServiceEvent.UserEventConfigActionUserEvent = "ServiceEvent_UserEventConfigActionUserEvent"
ServiceEvent.UserEventNpcWalkStepNtfUserEvent = "ServiceEvent_UserEventNpcWalkStepNtfUserEvent"
ServiceEvent.UserEventSetProfileUserEvent = "ServiceEvent_UserEventSetProfileUserEvent"
ServiceEvent.UserEventQueryFateRelationEvent = "ServiceEvent_UserEventQueryFateRelationEvent"
ServiceEvent.UserEventSyncFateRelationEvent = "ServiceEvent_UserEventSyncFateRelationEvent"
ServiceEvent.UserEventQueryProfileUserEvent = "ServiceEvent_UserEventQueryProfileUserEvent"
ServiceEvent.UserEventGvgSandTableEvent = "ServiceEvent_UserEventGvgSandTableEvent"
ServiceEvent.UserEventSetReliveMethodUserEvent = "ServiceEvent_UserEventSetReliveMethodUserEvent"
ServiceEvent.UserEventUIActionUserEvent = "ServiceEvent_UserEventUIActionUserEvent"
ServiceEvent.UserEventPlayCutSceneUserEvent = "ServiceEvent_UserEventPlayCutSceneUserEvent"
ServiceEvent.UserEventReqPeriodicMonsterUserEvent = "ServiceEvent_UserEventReqPeriodicMonsterUserEvent"
ServiceEvent.UserEventPlayHoldPetUserEvent = "ServiceEvent_UserEventPlayHoldPetUserEvent"
ServiceEvent.UserEventQuerySpeedUpUserEvent = "ServiceEvent_UserEventQuerySpeedUpUserEvent"
ServiceEvent.UserEventServerOpenTimeUserEvent = "ServiceEvent_UserEventServerOpenTimeUserEvent"
ServiceEvent.UserEventSkillDamageStatUserEvent = "ServiceEvent_UserEventSkillDamageStatUserEvent"
ServiceEvent.UserEventHeartBeatReqUserEvent = "ServiceEvent_UserEventHeartBeatReqUserEvent"
ServiceEvent.UserEventHeartBeatAckUserEvent = "ServiceEvent_UserEventHeartBeatAckUserEvent"
ServiceEvent.UserEventQueryUserReportListUserEvent = "ServiceEvent_UserEventQueryUserReportListUserEvent"
ServiceEvent.UserEventUserReportUserEvent = "ServiceEvent_UserEventUserReportUserEvent"
