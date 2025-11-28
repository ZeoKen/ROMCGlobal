autoImport("RaidStatisticsView")
ComodoRaidStatisticsView = class("ComodoRaidStatisticsView", RaidStatisticsView)
ComodoRaidStatisticsView.ViewType = UIViewType.NormalLayer

function ComodoRaidStatisticsView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryComodoTeamRaidStat, self.HandleRecvQueryComodoTeamRaidStat)
  self:AddListenEvt(PVEEvent.ComodoRaid_Shutdown, self.CloseSelf)
end

function ComodoRaidStatisticsView:InitView()
  ComodoRaidStatisticsView.super.InitView(self)
  self.raidMapTog.gameObject:SetActive(false)
end

function ComodoRaidStatisticsView:OnEnter()
  ComodoRaidStatisticsView.super.super.OnEnter(self)
end

function ComodoRaidStatisticsView:HandleRecvQueryComodoTeamRaidStat()
  ComodoRaidStatisticsView.super.HandleRecvQueryInfo(self)
end

local recordFilter = {}

function ComodoRaidStatisticsView:GetRecordFilter()
  return GroupRaidProxy.Instance:GetComodoRecordFilter()
end

function ComodoRaidStatisticsView:UpdatePlayerList(gridctl, filtervalue, recordtime)
  local datas = GroupRaidProxy.Instance:GetComodoDataByIndex(recordtime, filtervalue)
  local weights = GroupRaidProxy.Instance:GetComodoWeightMapByTime(recordtime)
  if datas then
    self:SortByFilter(filtervalue, datas)
    for i = 1, #datas do
      datas[i]:SetPercentage(weights, filtervalue)
    end
    gridctl:ResetDatas(datas)
  end
end
