autoImport("ElementStaticsView")
FairyTaleStaticsView = class("FairyTaleStaticsView", ElementStaticsView)

function FairyTaleStaticsView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryElementRaidStat, self.HandleRecvQueryElementRaidStat)
  self:AddListenEvt(PVEEvent.FairyTale_Shutdown, self.CloseSelf)
end

function FairyTaleStaticsView:OnEnter()
  RaidStatisticsView.super.OnEnter(self)
  ServiceFuBenCmdProxy.Instance:CallQueryElementRaidStat(nil, nil, nil, PveRaidType.FairyTale)
end

function FairyTaleStaticsView:GetRecordFilter()
  local filter = GroupRaidProxy.Instance:GetFairyTaleRecordFilter()
  if not self.recordDataL then
    self.recordDataL = 1
  end
  if not self.recordDataR then
    self.recordDataR = 1
  end
  return filter
end
