autoImport("RaidStatisticsView")
MultiBossRaidStatView = class("MultiBossRaidStatView", RaidStatisticsView)
MultiBossRaidStatView.ViewType = UIViewType.NormalLayer

function MultiBossRaidStatView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryMultiBossRaidStat, self.HandleRecvQuery)
  self:AddListenEvt(PVEEvent.MultiBossRaid_Shutdown, self.CloseSelf)
end

function MultiBossRaidStatView:InitView()
  MultiBossRaidStatView.super.InitView(self)
  self.raidMapTog.gameObject:SetActive(false)
end

function MultiBossRaidStatView:OnEnter()
  MultiBossRaidStatView.super.super.OnEnter(self)
end

function MultiBossRaidStatView:HandleRecvQuery()
  MultiBossRaidStatView.super.HandleRecvQueryInfo(self)
end

local recordFilter = {}

function MultiBossRaidStatView:GetRecordFilter()
  return GroupRaidProxy.Instance:GetMultiBossRecordFilter()
end

local pulicConfig = GameConfig.Thanatos_Public

function MultiBossRaidStatView:GetStatisticFilter()
  local MultiBossConfig = GameConfig.MultiBoss
  if not MultiBossConfig then
    return pulicConfig.StatisticFilterConfig
  end
  local mapid = SceneProxy.Instance:GetCurMapID() or 0
  local raidtype = Table_MapRaid[mapid].Type or 0
  local raidConfig = MultiBossConfig.Raid[raidtype]
  return raidConfig.StatisticFilterConfig
end

function MultiBossRaidStatView:GetLeftFilter()
  local MultiBossConfig = GameConfig.MultiBoss
  if not MultiBossConfig then
    return pulicConfig.LeftFilter
  end
  local mapid = SceneProxy.Instance:GetCurMapID() or 0
  local raidtype = Table_MapRaid[mapid].Type or 0
  local raidConfig = MultiBossConfig.Raid[raidtype]
  if not raidConfig or not raidConfig.LeftFilter then
    return pulicConfig.LeftFilter
  end
  return raidConfig.LeftFilter
end

function MultiBossRaidStatView:GetRightFilter()
  local MultiBossConfig = GameConfig.MultiBoss
  if not MultiBossConfig then
    return pulicConfig.RightFilter
  end
  local mapid = SceneProxy.Instance:GetCurMapID() or 0
  local raidtype = Table_MapRaid[mapid].Type or 0
  local raidConfig = MultiBossConfig.Raid[raidtype]
  if not raidConfig or not raidConfig.RightFilter then
    return pulicConfig.RightFilter
  end
  return raidConfig.RightFilter
end

function MultiBossRaidStatView:UpdatePlayerList(gridctl, filtervalue, recordtime)
  local datas = GroupRaidProxy.Instance:GeMultiBossDataByIndex(recordtime, filtervalue)
  local weights = GroupRaidProxy.Instance:GetMultiBossWeightMapByTime(recordtime)
  if datas then
    self:SortByFilter(filtervalue, datas)
    for i = 1, #datas do
      datas[i]:SetPercentage(weights, filtervalue)
    end
    gridctl:ResetDatas(datas)
  end
end
