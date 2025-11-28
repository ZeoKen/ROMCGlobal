autoImport("ElementStaticsView")
AstralStaticsView = class("AstralStaticsView", ElementStaticsView)
AstralStaticsView.ViewType = UIViewType.NormalLayer

function AstralStaticsView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryElementRaidStat, self.HandleRecvQueryElementRaidStat)
  self:AddListenEvt(PVEEvent.Astral_Shutdown, self.CloseSelf)
end

function AstralStaticsView:OnEnter()
  RaidStatisticsView.super.OnEnter(self)
  ServiceFuBenCmdProxy.Instance:CallQueryElementRaidStat(nil, nil, nil, PveRaidType.Astral)
end

function AstralStaticsView:GetRecordFilter()
  local filter = GroupRaidProxy.Instance:GetAstralRecordFilter()
  if not self.recordDataL then
    self.recordDataL = 1
  end
  if not self.recordDataR then
    self.recordDataR = 1
  end
  return filter
end
