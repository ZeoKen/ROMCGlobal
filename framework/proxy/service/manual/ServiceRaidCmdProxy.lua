autoImport("ServiceRaidCmdAutoProxy")
ServiceRaidCmdProxy = class("ServiceRaidCmdProxy", ServiceRaidCmdAutoProxy)
ServiceRaidCmdProxy.Instance = nil
ServiceRaidCmdProxy.NAME = "ServiceRaidCmdProxy"

function ServiceRaidCmdProxy:ctor(proxyName)
  if ServiceRaidCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRaidCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRaidCmdProxy.Instance = self
  end
end

function ServiceRaidCmdProxy:RecvQueryRaidPuzzleListRaidCmd(data)
  RaidPuzzleProxy.Instance:RecvQueryRaidPuzzleListRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdQueryRaidPuzzleListRaidCmd, data)
end

function ServiceRaidCmdProxy:RecvRaidPuzzleActionRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleActionRaidCmd, data)
end

function ServiceRaidCmdProxy:RecvRaidPuzzleTargetSyncRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleTargetSyncRaidCmd, data)
end

function ServiceRaidCmdProxy:RecvRaidPuzzleDataUpdateRaidCmd(data)
  RaidPuzzleManager.Me():RecvRaidPuzzleDataUpdateRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleDataUpdateRaidCmd, data)
end

function ServiceRaidCmdProxy:RecvRaidPuzzleObjChangeNtfRaidCmd(data)
  RaidPuzzleManager.Me():HandlePuzzleObjChange(data.guids)
end

function ServiceRaidCmdProxy:RecvClientQueryRaidCmd(data)
  DungeonProxy.Instance:RecvClientQueryRaid(data.raidid, data.achievement_datas, data.treasure_boxs, data.rewarded_point)
  if data.complete_info then
    DungeonProxy.Instance:SetClientRaidSaveData(data.raidid, data.process_data)
  end
  EventManager.Me():PassEvent(ServiceEvent.RaidCmdClientQueryRaidCmd, data.raidid)
  ServiceRaidCmdProxy.super.RecvClientQueryRaidCmd(self, data)
end

function ServiceRaidCmdProxy:RecvClientRaidAchRewardCmd(data)
  if data.success then
    DungeonProxy.Instance:AddClientRaidAchievementReward(data.raidid, data.point)
  end
  ServiceRaidCmdProxy.super.RecvClientRaidAchRewardCmd(self, data)
end

function ServiceRaidCmdProxy:RecvClientSaveResultCmd(data)
  if data.success then
    DungeonProxy.Instance:RecordClientRaidSaveResult(data.raidid, data.record_tag)
  end
  EventManager.Me():PassEvent(ServiceEvent.RaidCmdClientSaveResultCmd, data.raidid)
  ServiceRaidCmdProxy.super.RecvClientSaveResultCmd(self, data)
end

function ServiceRaidCmdProxy:RecvHeadwearActivityNpcUserCmd(data)
  HeadwearRaidProxy.Instance:RecvHeadwearNpcUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityNpcUserCmd, data)
end

function ServiceRaidCmdProxy:RecvHeadwearActivityRoundUserCmd(data)
  HeadwearRaidProxy.Instance:RecvActivityHeadwearRoundUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityRoundUserCmd, data)
end

function ServiceRaidCmdProxy:RecvHeadwearActivityTowerUserCmd(data)
  HeadwearRaidProxy.Instance:RecvActivityHeadwearTowerUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityTowerUserCmd, data)
end

function ServiceRaidCmdProxy:RecvHeadwearActivityEndUserCmd(data)
  HeadwearRaidProxy.Instance:RecvActivityHeadwearActivityEndUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityEndUserCmd, data)
end

function ServiceRaidCmdProxy:RecvHeadwearActivityRangeUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityRangeUserCmd, data)
end

function ServiceRaidCmdProxy:RecvRaidOptionalCardCmd(data)
  DungeonProxy.Instance:RecvRaidSelectCard(data.endtime, data.cardids, data.recommend_ids)
  ServiceRaidCmdProxy.super.RecvRaidOptionalCardCmd(self, data)
end

function ServiceRaidCmdProxy:RecvRaidSelectCardResultRes(data)
  DungeonProxy.Instance:RecvRaidSelectCardResult(data.resultid)
  ServiceRaidCmdProxy.super.RecvRaidSelectCardResultRes(self, data)
end

function ServiceRaidCmdProxy:RecvRaidSelectCardHistoryResultCmd(data)
  DungeonProxy.Instance:RecvRaidSelectCardHistory(data.resultids)
  ServiceRaidCmdProxy.super.RecvRaidSelectCardHistoryResultCmd(self, data)
end

function ServiceRaidCmdProxy:RecvRaidSelectCardResetCmd(data)
  DungeonProxy.Instance:RecvRaidSelectCardReset()
  ServiceRaidCmdProxy.super.RecvRaidSelectCardResetCmd(self, data)
end

function ServiceRaidCmdProxy:RecvRaidNewResetCmd(data)
  QuestProxy.Instance:clearFubenQuestData()
  self:Notify(ServiceEvent.RaidCmdRaidNewResetCmd, data)
end
