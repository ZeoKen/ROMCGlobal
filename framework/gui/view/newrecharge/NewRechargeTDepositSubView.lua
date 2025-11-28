autoImport("NewRechargeCommonSubView")
autoImport("NewRechargeTShopData")
autoImport("NewRechargeTDepositGoodsCell")
NewRechargeTDepositSubView = class("NewRechargeTDepositSubView", NewRechargeCommonSubView)
NewRechargeTDepositSubView.manuallyInit = true
NewRechargeTDepositSubView.Tab = GameConfig.NewRecharge.TabDef.Deposit
NewRechargeTDepositSubView.innerTab = {ROB = 1, Zeny = 2}

function NewRechargeTDepositSubView:OnExit()
  NewRechargeTDepositSubView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveQueryChargeVirgin, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveChargeNtfUserEvent, self)
  self.cellListCtrl:Destroy()
end

function NewRechargeTDepositSubView:Init(manually)
  if self.inited then
    return
  end
  if self.manuallyInit and not manually then
    return
  end
  self:FindObjs()
  self:InitView()
  self.inited = true
end

function NewRechargeTDepositSubView:InitView()
  self:RefreshView(1)
  if BranchMgr.IsJapan() then
    EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
  end
  EventManager.Me():AddEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveQueryChargeVirgin, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveChargeNtfUserEvent, self)
end

function NewRechargeTDepositSubView:OnReceiveQueryChargeVirgin(note)
  self:LoadView(true)
end

function NewRechargeTDepositSubView:RefreshView(selectInnerTab)
  NewRechargeTDepositSubView.super.RefreshView(self, selectInnerTab)
  if selectInnerTab == self.innerTab.ROB then
    NewRechargeProxy.Instance:CallClientPayLog(112)
  end
  self:InitData()
  self:LoadView()
  self:SelectInnerSelector()
end

function NewRechargeTDepositSubView:FindObjs()
  self.gameObject = self:FindGO("NewRechargeTDepositSubView")
  NewRechargeTDepositSubView.super.FindObjs(self)
  local cellContainer = self:FindComponent("Table", UIGrid, self:FindGO("GoodsList", self.gameObject))
  self.cellListCtrl = UIGridListCtrl.new(cellContainer, NewRechargeTDepositGoodsCell, "NewRechargeTDepositGoodsCell")
  local cellTableScrollView = self:FindComponent("GoodsList", UIScrollView, self.gameObject)
  local cellTableScrollBar = cellTableScrollView.horizontalScrollBar
  local leftTriggerAction = function(invoker, switchIndex)
    local newIndex = (switchIndex + self.innerSelectTab - 1) % #self.innerSelect_validIndex + 1
    newIndex = self.innerSelect_validIndex[newIndex]
    self:RefreshView(newIndex)
  end
  self:ResetScrollUpdateParams(cellTableScrollView, cellTableScrollBar, leftTriggerAction, -1, leftTriggerAction, 1)
end

function NewRechargeTDepositSubView:InitData()
  if self.innerSelectTab == self.innerTab.ROB then
    self.itemList_r = NewRechargeProxy.Instance:TDeposit_GetDepositROBItemList()
  elseif self.innerSelectTab == self.innerTab.Zeny then
    self.itemList_r = NewRechargeProxy.Instance:TDeposit_GetDepositZenyItemList()
  end
end

function NewRechargeTDepositSubView:LoadView(noResetPos)
  self.cellListCtrl:ResetDatas(self.itemList_r)
  self.cellListCtrl:ResetPosition()
  if not noResetPos then
    self:ResetScrollBarTriggerSize()
  end
end

function NewRechargeTDepositSubView:OnReceiveChargeNtfUserEvent(note)
  self:InitData()
  self:LoadView(true)
end
