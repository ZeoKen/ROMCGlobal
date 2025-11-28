autoImport("RewardSelectCell")
RewardSelectView = class("RewardSelectView", BaseView)
RewardSelectView.ViewType = UIViewType.PopUpLayer

function RewardSelectView:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if not viewdata then
    return
  end
  self.itemguid = viewdata.guid
  if not self.rewards then
    self.rewards = {}
  end
  for i = 1, #viewdata.rand_items do
    local single = {}
    single.itemguid = self.itemguid
    single.itemid = viewdata.rand_items[i]
    table.insert(self.rewards, single)
  end
  self:FindObjs()
  self:AddCloseButtonEvent()
  self:AddListenEvts()
  self:UpdateView()
end

function RewardSelectView:AddListenEvts()
  self:AddListenEvt(RewardSelectViewEvent.CloseUI, self.CloseSelf)
end

function RewardSelectView:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.listCtrl = UIGridListCtrl.new(self.grid, RewardSelectCell, "RewardSelectCell")
end

function RewardSelectView:OnEnter()
  RewardSelectView.super.OnEnter(self)
end

function RewardSelectView:UpdateView()
  self.listCtrl:ResetDatas(self.rewards)
end
