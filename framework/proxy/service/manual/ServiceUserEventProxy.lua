autoImport("ServiceUserEventAutoProxy")
ServiceUserEventProxy = class("ServiceUserEventProxy", ServiceUserEventAutoProxy)
ServiceUserEventProxy.Instance = nil
ServiceUserEventProxy.NAME = "ServiceUserEventProxy"

function ServiceUserEventProxy:ctor(proxyName)
  if ServiceUserEventProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserEventProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserEventProxy.Instance = self
    self.initThemisTm = false
  end
end

function ServiceUserEventProxy:RecvFirstActionUserEvent(data)
  FunctionFirstTime.Me():SyncServerRecord(data.firstaction)
end

function ServiceUserEventProxy:RecvNewTitle(data)
  MyselfProxy.Instance:newTitle(data)
  self:Notify(ServiceEvent.UserEventNewTitle, data)
end

function ServiceUserEventProxy:RecvAllTitle(data)
  MyselfProxy.Instance:initAllTitle(data)
  TitleProxy.Instance:SetServiceData(data.title_datas)
end

function ServiceUserEventProxy:RecvChangeTitle(data)
  local player = NSceneUserProxy.Instance:Find(data.charid)
  if player then
    player:Sever_SetTitleID(data.title_data)
    TitleProxy.Instance:SetServiceData(data.title_data)
  end
  EventManager.Me():DispatchEvent(ServiceEvent.UserEventChangeTitle, data)
  self:Notify(ServiceEvent.UserEventChangeTitle, data)
end

function ServiceUserEventProxy:RecvUpdateRandomUserEvent(data)
  MyselfProxy.Instance:UpdateRandomFunc(data.randoms, data.beginindex, data.endindex)
  self:Notify(ServiceEvent.UserEventUpdateRandomUserEvent, data)
end

function ServiceUserEventProxy:RecvBuffDamageUserEvent(data)
  EventManager.Me():DispatchEvent(ServiceEvent.UserEventBuffDamageUserEvent, data)
  local creature = SceneCreatureProxy.FindCreature(data.charid)
  if creature then
    creature:PlayDamage_Effect(data.damage, data.etype, data.fromid)
  end
end

function ServiceUserEventProxy:RecvDepositCardInfo(data)
  self:Notify(ServiceEvent.UserEventDepositCardInfo, data)
  NewRechargeProxy.Ins:Card_SetMonthlyVIPInfo(data)
end

function ServiceUserEventProxy:AmIMonthlyVIP()
  return NewRechargeProxy.Ins:AmIMonthlyVIP()
end

function ServiceUserEventProxy:RecvQueryUserReportListUserEvent(data)
  FunctionTipoff.Me():HandleRecvList(data.reports)
  self:Notify(ServiceEvent.UserEventQueryUserReportListUserEvent, data)
end

function ServiceUserEventProxy:RecvUserReportUserEvent(data)
  FunctionTipoff.Me():HandleReportUser(data.msgid, data.report)
  self:Notify(ServiceEvent.UserEventUserReportUserEvent, data)
end

function ServiceUserEventProxy:CallDelTransformUserEvent()
  ServiceUserEventProxy.super.CallDelTransformUserEvent(self)
end

function ServiceUserEventProxy:CallChangeTitle(title_data, charid)
  ServiceUserEventProxy.super.CallChangeTitle(self, title_data, charid)
end

function ServiceUserEventProxy:RecvChargeNtfUserEvent(data)
  self:Notify(ServiceEvent.UserEventChargeNtfUserEvent, data)
  EventManager.Me():PassEvent(ServiceEvent.UserEventChargeNtfUserEvent, data)
end

function ServiceUserEventProxy:RecvQueryChargeCnt(data)
  helplog("---recv function ServiceUserEventProxy:RecvQueryChargeCnt(data)---")
  NewRechargeProxy.Ins:Deposit_UpdateChargeCntInfo(data.info)
  ShopProxy.Instance:SetChargeCntTable(data)
  BattleFundProxy.Instance:RecvQueryChargeCnt(data)
  self:Notify(ServiceEvent.UserEventQueryChargeCnt, data)
  EventManager.Me():PassEvent(ServiceEvent.UserEventQueryChargeCnt, data)
end

function ServiceUserEventProxy:RecvNTFMonthCardEnd(data)
  self:Notify(ServiceEvent.UserEventNTFMonthCardEnd, data)
  NewRechargeProxy.Ins:Card_HandleMonthCardEnd(data)
end

function ServiceUserEventProxy:CallQueryResetTimeEventCmd(etype, resettime)
  ServiceUserEventProxy.super.CallQueryResetTimeEventCmd(self, etype, resettime)
end

function ServiceUserEventProxy:RecvQueryResetTimeEventCmd(data)
  if data.etype == AERewardType.Tower then
    EndlessTowerProxy.Instance:Server_SerResetTime(data.resettime)
    EventManager.Me():PassEvent(ServiceEvent.UserEventQueryResetTimeEventCmd, data.resettime)
  end
  self:Notify(ServiceEvent.UserEventQueryResetTimeEventCmd, data)
end

function ServiceUserEventProxy:RecvQueryActivityCnt(data)
  self:Notify(ServiceEvent.UserEventQueryActivityCnt, data)
  local purchaseActivityInfos = data.info
  for i = 1, #purchaseActivityInfos do
    NewRechargeProxy.Ins:Deposit_SetActivityUsedTimes(purchaseActivityInfos[i])
  end
end

function ServiceUserEventProxy:RecvUpdateActivityCnt(data)
  NewRechargeProxy.Ins:Deposit_SetActivityUsedTimes(data.info)
  self:Notify(ServiceEvent.UserEventUpdateActivityCnt, data)
  EventManager.Me():PassEvent(ServiceEvent.UserEventUpdateActivityCnt, data)
end

function ServiceUserEventProxy:RecvDieTimeCountEventCmd(data)
  MyselfProxy.Instance:HandleRelieveCd(data)
  self:Notify(ServiceEvent.UserEventDieTimeCountEventCmd, data)
end

function ServiceUserEventProxy:RecvNtfVersionCardInfo(data)
  NewRechargeProxy.Instance:Card_SetVersionCardInfo(data.info)
  self:Notify(ServiceEvent.UserEventNtfVersionCardInfo, data)
end

function ServiceUserEventProxy:RecvChargeQueryCmd(data)
  BattleFundProxy.Instance:RecvChargeQueryCmd(data)
  NewRechargeProxy.Instance:Deposit_RecvChargeQueryCmd(data)
  self:Notify(ServiceEvent.UserEventChargeQueryCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.UserEventChargeQueryCmd, data)
end

function ServiceUserEventProxy:CallUserEventQueryStageCmd(stageid, info)
  self.super:CallUserEventQueryStageCmd(stageid, info)
  redlog("CallUserEventQueryStageCmd", stageid)
end

function ServiceUserEventProxy:RecvUserEventQueryStageCmd(data)
  self.super:RecvUserEventQueryStageCmd(data)
  StageProxy.Instance:RecvStageInfo(data)
  local len = 0
  if data.info then
    len = #data.info
    if len == 3 then
      StageProxy.Instance:ShowDialog()
    elseif len == 1 then
      StageProxy.Instance:ShowTip()
    end
  end
  redlog("RecvUserEventQueryStageCmd")
  self:Notify(ServiceEvent.UserEventUserEventQueryStageCmd, data)
end

function ServiceUserEventProxy:CallUserEventLineUpCmd(stageid, mode, enter)
  self.super:CallUserEventLineUpCmd(stageid, mode, enter)
  redlog("CallUserEventLineUpCmd", stageid, mode, enter)
end

function ServiceUserEventProxy:RecvSoundStoryUserEvent(data)
  PlotAudioProxy.Instance:RecvSoundStoryUserEvent(data)
  self:Notify(ServiceEvent.UserEventSoundStoryUserEvent, data)
end

function ServiceUserEventProxy:RecvQueryFavoriteFriendUserEvent(data)
  FriendProxy.Instance:RecvQueryFavoriteFriendUserEvent(data.charid)
  self:Notify(ServiceEvent.UserEventQueryFavoriteFriendUserEvent, data)
end

function ServiceUserEventProxy:RecvUpdateFavoriteFriendUserEvent(data)
  FriendProxy.Instance:RecvUpdateFavoriteFriendUserEvent(data)
  self:Notify(ServiceEvent.UserEventUpdateFavoriteFriendUserEvent, data)
end

function ServiceUserEventProxy:RecvThemeDetailsUserEvent(data)
  redlog("recv ThemeDetailData", data.name)
  ActivityDataProxy.Instance:InitTimeLimitActivityInfo(data)
  self:Notify(ServiceEvent.UserEventThemeDetailsUserEvent, data)
end

function ServiceUserEventProxy:RecvCameraActionUserEvent(data)
  FunctionCameraEffect.Me():RecvCameraAction(data.params)
  self:Notify(ServiceEvent.UserEventCameraActionUserEvent, data)
end

function ServiceUserEventProxy:RecvQueryAccChargeCntReward(data)
  ShopProxy.Instance:RecvQueryAccChargeCntReward(data.infos)
  self:Notify(ServiceEvent.UserEventQueryAccChargeCntReward, data)
  EventManager.Me():PassEvent(ServiceEvent.UserEventQueryAccChargeCntReward, data)
end

function ServiceUserEventProxy:RecvClientAISyncUserEvent(data)
  RandomAIManager.Me():OnNpcAIStateSync(data)
  ServiceUserEventProxy.super.RecvClientAISyncUserEvent(self, data)
end

function ServiceUserEventProxy:RecvClientAIUpdateUserEvent(data)
  RandomAIManager.Me():OnNpcAIStateUpdate(data)
  ServiceUserEventProxy.super.RecvClientAIUpdateUserEvent(self, data)
end

function ServiceUserEventProxy:RecvGiftTimeLimitNtfUserEvent(data)
  TimeLimitShopProxy.Instance:RecvGiftTimeLimitNtfUserEvent(data.infos)
  self:Notify(ServiceEvent.UserEventGiftTimeLimitBuyUserEvent, data)
end

function ServiceUserEventProxy:RecvGiftTimeLimitActiveUserEvent(data)
  TimeLimitShopProxy.Instance:RecvGiftTimeLimitActiveUserEvent(data)
  self:Notify(ServiceEvent.UserEventGiftTimeLimitActiveUserEvent, data)
end

local privacyTag = -999

function ServiceUserEventProxy:RecvPolicyUpdateUserEvent(data)
  if privacyTag == data.tag then
    return
  end
  privacyTag = data.tag
  local agreeHandle = function()
    helplog("agreeHandle")
    self:CallPolicyAgreeUserEvent()
  end
  local refuseHandle = function()
    helplog("refuseHandle")
    PlayerPrefs.DeleteKey(PlayerPrefsAgreement)
    PlayerPrefs.Save()
    ApplicationInfo.Quit()
  end
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "NewAgreeMentPanel",
    agreeHandle = agreeHandle,
    refuseHandle = refuseHandle
  })
end

function ServiceUserEventProxy:RecvMultiCutSceneUpdateUserEvent(data)
  Game.PlotStoryManager:Start_Multi_PQTLP(data.updates)
  Game.PlotStoryManager:StopMultiProgress(data.dels)
  self:Notify(ServiceEvent.UserEventMultiCutSceneUpdateUserEvent, data)
end

function ServiceUserEventProxy:RecvShowSceneObject(data)
  xdlog("洞察技能对象屏蔽", data.hide)
  local GOManager = Game.GameObjectManagers
  local objManager = GOManager[Game.GameObjectType.InsightGO]
  objManager:InsightBlock(data)
end

function ServiceUserEventProxy:RecvBeginMonitorUserEvent(data)
  MonitorProxy.Instance:RecvBeginMonitor(data.charid)
  ServiceUserEventProxy.super.RecvBeginMonitorUserEvent(self, data)
end

function ServiceUserEventProxy:RecvStopMonitorRetUserEvent(data)
  MonitorProxy.Instance:RecvStopMonitor()
  ServiceUserEventProxy.super.RecvStopMonitorRetUserEvent(self, data)
end

function ServiceUserEventAutoProxy:RecvGvgOptStatueEvent(data)
  GvgProxy.Instance:SetOptStatueTime(data.endtime)
end

function ServiceUserEventAutoProxy:RecvGvgOptStatueEvent(data)
  GvgProxy.Instance:SetOptStatueTime(data.endtime)
end

function ServiceUserEventAutoProxy:RecvTimeLimitIconEvent(data)
  NewRechargeProxy.Ins:SetTimeLimitIcon(data.show_items, data.show_deposits)
  self:Notify(ServiceEvent.UserEventTimeLimitIconEvent, data)
end

function ServiceUserEventProxy:RecvShowCardEvent(data)
  if data and data.cardid then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.NewCardRewardPopup,
      viewdata = {
        itemId = data.cardid
      }
    })
  end
  ServiceUserEventProxy.super.RecvShowCardEvent(self, data)
end

function ServiceUserEventProxy:RecvShowRMBGiftEvent(data)
  NewRechargeProxy.Instance:setRmbShopInfo(data)
  ServiceUserEventProxy.super.RecvShowRMBGiftEvent(self, data)
end

function ServiceUserEventProxy:RecvSyncFateRelationEvent(data)
  self:Notify(ServiceEvent.UserEventSyncFateRelationEvent, data)
  EventManager.Me():DispatchEvent(ServiceEvent.UserEventSyncFateRelationEvent, data)
end

function ServiceUserEventProxy:RecvQueryProfileUserEvent(data)
  EventManager.Me():DispatchEvent(ServiceEvent.UserEventQueryProfileUserEvent, data)
  self:Notify(ServiceEvent.UserEventQueryProfileUserEvent, data)
end

function ServiceUserEventProxy:RecvGvgSandTableEvent(data)
  GvgProxy.Instance:SetSandTableInfos(data)
  self:Notify(ServiceEvent.UserEventGvgSandTableEvent, data)
end

function ServiceUserEventProxy:RecvSetReliveMethodUserEvent(data)
  GvgProxy.Instance:RecvSetReliveMethodUserEvent(data)
  self:Notify(ServiceEvent.UserEventSetReliveMethodUserEvent, data)
end

function ServiceUserEventProxy:RecvReqPeriodicMonsterUserEvent(data)
  AierBlacksmithProxy.Instance:Recv_ReqPeriodicMonsterUserEvent(data)
  self:Notify(ServiceEvent.UserEventReqPeriodicMonsterUserEvent, data)
end

function ServiceUserEventProxy:RecvPlayCutSceneUserEvent(data)
  local params = data.params
  local tb = TableUtil.unserialize(data.params)
  local id = tb.id
  if id then
    Game.PlotStoryManager:Start_SEQ_PQTLP(tostring(id), nil, nil, nil, true)
  end
  self:Notify(ServiceEvent.UserEventPlayCutSceneUserEvent, data)
end

function ServiceUserEventProxy:RecvPlayHoldPetUserEvent(data)
  local params = data.params
  local tb = TableUtil.unserialize(data.params)
  local type = tb.type
  local npcid = tb.id
  local dirX = tb.dirx
  local dirY = tb.diry
  local offset = tb.offset
  if type == 1 and npcid then
    Game.Myself:Client_AddHugRole(npcid, dirX, dirY, offset)
  elseif type == 2 then
    Game.Myself:Client_RemoveHugRole()
  end
  self:Notify(ServiceEvent.UserEventPlayHoldPetUserEvent, data)
end

function ServiceUserEventProxy:RecvQuerySpeedUpUserEvent(data)
  MyselfProxy.Instance:UpdateSpeedUp(data)
  self:Notify(ServiceEvent.UserEventQuerySpeedUpUserEvent, data)
end

function ServiceUserEventProxy:RecvServerOpenTimeUserEvent(data)
  ServerTime.SetServerOpenTime(data.opentime)
end

function ServiceUserEventProxy:RecvHeartBeatAckUserEvent(data)
  local codec_group = data.codec_group
  local codec_seed = data.codec_seed
  local themis_data
  local buglyMgr = BuglyManager.GetInstance()
  pcall(function()
    if buglyMgr.GetHeartbeat then
      if not self.initThemisTm then
        self.initThemisTm = true
        buglyMgr:TMInit()
      end
      themis_data = buglyMgr:GetHeartbeat(codec_group, codec_seed)
    end
  end)
  if "" == themis_data or not themis_data then
    return
  end
  self:CallHeartBeatReqUserEvent(codec_group, codec_seed, themis_data)
end
