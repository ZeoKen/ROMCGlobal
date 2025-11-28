autoImport("BaseView")
autoImport("BagItemCell")
ReturnRewardView = class("ReturnRewardView", BaseView)
ReturnRewardView.ViewType = UIViewType.PopUpLayer

function ReturnRewardView:Init()
  local grid = self:FindComponent("ItemGrid", UIGrid)
  self.itemCtrl = UIGridListCtrl.new(grid, BagItemCell, "BagItemCell")
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(self.confirmButton, function()
    self:ConfirmReward()
  end)
end

function ReturnRewardView:OnClickItem(cellCtl)
  local d = cellCtl.data
  if not d then
    self:ShowItemTip()
  else
    local sdata = {
      itemdata = d,
      ignoreBounds = {
        cellCtl.gameObject
      }
    }
    self:ShowItemTip(sdata, cellCtl:GetBgSprite(), NGUIUtil.AnchorSide.Left, {-200, 0})
  end
end

function ReturnRewardView:ConfirmReward()
  ServiceNoviceBattlePassProxy.Instance:CallReturnBPReturnRewardCmd()
  if NoviceBattlePassProxy.Instance:IsReturnBPAvailable() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.NoviceBattlePassView,
      viewdata = {bPType = 2}
    })
  end
  self:CloseSelf()
end

function ReturnRewardView:RefreshItemList()
  self.itemCtrl:ResetDatas(NoviceBattlePassProxy.Instance:GetReturnRewardItems() or {})
end

function ReturnRewardView:OnEnter()
  ReturnRewardView.super.OnEnter(self)
  self:RefreshItemList()
  self.timer = TimeTickManager.Me():CreateTick(0, 1000, function()
    if not NoviceBattlePassProxy.Instance:IsReturnBPAvailable() then
      self:CloseSelf()
    end
  end, self, 121)
end

function ReturnRewardView:OnExit()
  ReturnRewardView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
