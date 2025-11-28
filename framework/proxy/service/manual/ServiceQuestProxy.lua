autoImport("ServiceQuestAutoProxy")
ServiceQuestProxy = class("ServiceQuestProxy", ServiceQuestAutoProxy)
ServiceQuestProxy.Instance = nil
ServiceQuestProxy.NAME = "ServiceQuestProxy"

function ServiceQuestProxy:ctor(proxyName)
  if ServiceQuestProxy.Instance == nil then
    self.proxyName = proxyName or ServiceQuestProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceQuestProxy.Instance = self
  end
  NetProtocol.NeedCacheReceive(8, 1)
end

function ServiceQuestProxy:RecvQuestDetailList(data)
  self:Notify(ServiceEvent.QuestQuestDetailList, data)
end

function ServiceQuestProxy:RecvQuestDetailUpdate(data)
  self:Notify(ServiceEvent.QuestQuestDetailUpdate, data)
end

function ServiceQuestProxy:RecvQuestList(data)
  QuestProxy.Instance:QuestQuestList(data)
  self:Notify(ServiceEvent.QuestQuestList, data)
end

function ServiceQuestProxy:RecvQuestUpdate(data)
  QuestProxy.Instance:QuestQuestUpdate(data)
  HappyShopProxy.Instance.isAutoQuestCompleteStateUpdated = false
  self:Notify(ServiceEvent.QuestQuestUpdate, data)
end

function ServiceQuestProxy:RecvQuestStepUpdate(data)
  QuestProxy.Instance:QuestQuestStepUpdate(data)
  HappyShopProxy.Instance.isAutoQuestCompleteStateUpdated = false
end

function ServiceQuestProxy:CallQueryCatPrice(catid, expiretype)
  local otherData = SceneQuest_pb.OtherData()
  otherData.param1 = catid
  otherData.param2 = expiretype
  ServiceQuestProxy.super.CallQueryOtherData(self, SceneQuest_pb.EOTHERDATA_CAT, otherData)
end

function ServiceQuestProxy:RecvQueryOtherData(data)
  if data.type == SceneQuest_pb.EOTHERDATA_CAT then
    EventManager.Me():DispatchEvent(ServiceEvent.QuestQueryOtherData, data.data)
  elseif data.type == SceneQuest_pb.EOTHERDATA_DAILY then
    QuestProxy.Instance:setDailyQuestData(data)
  elseif data.type == SceneQuest_pb.EOTHERDATA_WORLDTREASURE then
    helplog("宝物地图消息")
    QuestProxy.Instance:RecvWorldQuestTreasure(data.data)
  elseif data.type == SceneQuest_pb.EOTHERDATA_WORLD then
    QuestProxy.Instance:SetWorldQuestProcess(data.data)
  end
  self:Notify(ServiceEvent.QuestQueryOtherData, data)
end

function ServiceQuestProxy:RecvQueryWantedInfoQuestCmd(data)
  QuestProxy.Instance:setMaxWanted(data)
  self:Notify(ServiceEvent.QuestQueryWantedInfoQuestCmd, data)
end

function ServiceQuestProxy:RecvQueryWorldQuestCmd(data)
  WorldMapProxy.Instance:SetWorldQuestInfo(data.quests)
  self:Notify(ServiceEvent.QuestQueryWorldQuestCmd, data)
end

function ServiceQuestProxy:RecvQueryManualQuestCmd(data)
  QuestManualProxy.Instance:HandleRecvQueryManualQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryManualQuestCmd, data)
end

function ServiceQuestProxy:CallQueryManualQuestCmd(version, manual)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.QueryManualQuestCmd.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneQuest_pb.QueryManualQuestCmd()
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  end
end

function ServiceQuestProxy:RecvManualFunctionQuestCmd(data)
  QuestManualProxy.Instance:RecvManualFunctionQuestCmd(data)
  self:Notify(ServiceEvent.QuestManualFunctionQuestCmd, data)
end

function ServiceQuestProxy:RecvQueryQuestListQuestCmd(data)
  WorldMapProxy.Instance:SetQueryQuestList(data)
  self:Notify(ServiceEvent.QuestQueryQuestListQuestCmd, data)
end

function ServiceQuestProxy:RecvMapStepSyncCmd(data)
  QuestProxy.Instance:updateDahuangQuestData(data)
  self:Notify(ServiceEvent.QuestMapStepSyncCmd, data)
end

function ServiceQuestProxy:RecvMapStepUpdateCmd(data)
  QuestProxy.Instance:MapQuestUpdate(data)
  self:Notify(ServiceEvent.QuestMapStepUpdateCmd, data)
end

function ServiceQuestProxy:RecvMapStepFinishCmd(data)
  self:Notify(ServiceEvent.QuestMapStepFinishCmd, data)
end

function ServiceQuestProxy:RecvQueryBottleInfoQuestCmd(data)
  xdlog("Recv ---- >RecvQueryBottleInfoQuestCmd 漂流瓶列表信息")
  DriftBottleProxy.Instance:RecvQueryBottleInfoQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryBottleInfoQuestCmd, data)
end

function ServiceQuestProxy:RecvBottleUpdateQuestCmd(data)
  xdlog("Recv ---- >RecvBottleUpdateQuestCmd 更新漂流瓶信息")
  DriftBottleProxy.Instance:RecvBottleUpdateQuestCmd(data)
  self:Notify(ServiceEvent.QuestBottleUpdateQuestCmd, data)
end

function ServiceQuestProxy:RecvEvidenceQueryCmd(data)
  SevenRoyalFamiliesProxy.Instance:RecvEvidenceQueryCmd(data)
  self:Notify(ServiceEvent.QuestEvidenceQueryCmd, data)
end

function ServiceQuestProxy:RecvUnlockEvidenceMessageCmd(data)
  xdlog("recv证据解锁")
  SevenRoyalFamiliesProxy.Instance:RecvUnlockEvidenceMessageCmd(data)
  self:Notify(ServiceEvent.QuestUnlockEvidenceMessageCmd, data)
end

function ServiceQuestProxy:RecvEvidenceHintCmd(data)
  xdlog("recvCD刷新")
  SevenRoyalFamiliesProxy.Instance:RecvEvidencehintCmd(data)
  self:Notify(ServiceEvent.QuestEvidenceHintCmd, data)
end

function ServiceQuestProxy:RecvQueryCharacterInfoCmd(data)
  xdlog("关系消息")
  SevenRoyalFamiliesProxy.Instance:RecvQueryCharacterInfoCmd(data)
  self:Notify(ServiceEvent.QuestQueryCharacterInfoCmd, data)
end

function ServiceQuestProxy:RecvEnlightSecretCmd(data)
  xdlog("RecvEnlightSecretCmd  点亮秘密")
  SevenRoyalFamiliesProxy.Instance:RecvEnlightSecretCmd(data)
  self:Notify(ServiceEvent.QuestEnlightSecretCmd, data)
end

function ServiceQuestProxy:RecvNewEvidenceUpdateCmd(data)
  xdlog("新增证物")
  SevenRoyalFamiliesProxy.Instance:RecvNewEvidenceUpdateCmd(data)
  self:Notify(ServiceEvent.QuestNewEvidenceUpdateCmd, data)
end

function ServiceQuestProxy:RecvCompleteAvailableQueryQuestCmd(data)
  HappyShopProxy.Instance:UpdateAutoQuestCompleteState(data.status)
  self:Notify(ServiceEvent.QuestCompleteAvailableQueryQuestCmd, data)
end

function ServiceQuestProxy:RecvWorldCountListQuestCmd(data)
  QuestProxy.Instance:RecvWorldCountList(data)
  self:Notify(ServiceEvent.QuestWorldCountListQuestCmd, data)
end

function ServiceQuestProxy:RecvQueryQuestHeroQuestCmd(data)
  QuestProxy.Instance:RecvQueryQuestHeroQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryQuestHeroQuestCmd, data)
end

function ServiceQuestProxy:RecvUpdateQuestHeroQuestCmd(data)
  QuestProxy.Instance:RecvUpdateQuestHeroQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateQuestHeroQuestCmd, data)
end

function ServiceQuestProxy:RecvUpdateQuestStoryIndexQuestCmd(data)
  QuestManualProxy.Instance:RecvUpdateQuestStoryIndexQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateQuestStoryIndexQuestCmd, data)
end

function ServiceQuestProxy:RecvUpdateOnceRewardQuestCmd(data)
  QuestProxy.Instance:RecvUpdateOnceRewardQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateOnceRewardQuestCmd, data)
end

function ServiceQuestProxy:RecvSyncTreasureBoxNumCmd(data)
  QuestProxy.Instance:RecvSyncTreasureBoxNumCmd(data)
  self:Notify(ServiceEvent.QuestSyncTreasureBoxNumCmd, data)
end

function ServiceQuestProxy:RecvQueryAbyssQuestListQuestCmd(data)
  AbyssQuestProxy.Instance:QueryAbyssQuestList(data)
  self:Notify(ServiceEvent.QuestQueryAbyssQuestListQuestCmd, data)
end

function ServiceQuestProxy:RecvUpdateAbyssHelpCountQuestCmd(data)
  AbyssQuestProxy.Instance:UpdateAbyssHelpCount(data)
  self:Notify(ServiceEvent.QuestUpdateAbyssHelpCountQuestCmd, data)
end

function ServiceQuestProxy:RecvAbyssDragonInfoNtfQuestCmd(data)
  AbyssFakeDragonProxy.Instance:UpdateAbyssDragonInfo(data)
  self:Notify(ServiceEvent.QuestAbyssDragonInfoNtfQuestCmd, data)
end

function ServiceQuestProxy:RecvAbyssDragonHpUpdateQuestCmd(data)
  AbyssFakeDragonProxy.Instance:RecvAbyssDragonHpUpdateQuestCmd(data)
  self:Notify(ServiceEvent.QuestAbyssDragonHpUpdateQuestCmd, data)
end

function ServiceQuestProxy:RecvAbyssDragonOnOffQuestCmd(data)
  AbyssFakeDragonProxy.Instance:RecvAbyssDragonOnOffQuestCmd(data)
  self:Notify(ServiceEvent.QuestAbyssDragonOnOffQuestCmd, data)
end
