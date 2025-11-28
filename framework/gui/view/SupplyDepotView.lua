autoImport("SupplyDepotCell")
autoImport("SupplyDepotItemCell")
autoImport("SupplyDepotProxy")
SupplyDepotView = class("SupplyDepotView", ContainerView)
SupplyDepotView.ViewType = UIViewType.NormalLayer
local proxy

function SupplyDepotView:Init()
  if not proxy then
    proxy = SupplyDepotProxy.Instance
  end
  self:InitObjEvents()
  self:AddViewEvts()
  self:UpdateView()
end

function SupplyDepotView:OnEnter()
  SupplyDepotView.super.OnEnter(self)
  self.timeTicker = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateAutoRefreshTime, self, 1)
end

function SupplyDepotView:OnExit()
  SupplyDepotView.super.OnExit(self)
  if self.timeTicker then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTicker = nil
  end
  RedTipProxy.Instance:RemoveWholeTip(SupplyDepotProxy.RedTipID)
end

function SupplyDepotView:InitObjEvents()
  self.titleLabel = self:FindComponent("Title", UILabel, self:FindGO("BgGroup"))
  self.autoRefreshGroupGO = self:FindGO("AutoRefreshGroup")
  self.autoRefreshTimeLabel = self:FindComponent("AutoRefreshTimeLabel", UILabel, self.autoRefreshGroupGO)
  self.moneyGroupGO = self:FindGO("MoneyGroup")
  local moneyIcon = self:FindComponent("MoneyIcon", UISprite, self.moneyGroupGO)
  local moneyIconName = Table_Item[GameConfig.MoneyId.Zeny].Icon
  IconManager:SetItemIcon(moneyIconName, moneyIcon)
  self.moneyLabel = self:FindComponent("MoneyLabel", UILabel, self.moneyGroupGO)
  self.addMoneyGO = self:FindGO("AddMoneyButton", self.moneyGroupGO)
  self:AddClickEvent(self.addMoneyGO, function()
    MsgManager.ConfirmMsgByID(41326, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
    end)
  end)
  if BranchMgr.IsKorea() or BranchMgr.IsJapan() then
    self.addMoneyGO:SetActive(false)
  end
  self.itemGroupGO = self:FindGO("ItemGroup")
  self.itemListCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.itemGroupGO), SupplyDepotCell, "SupplyDepotCell")
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemCellClicked, self)
  self.itemListCtrl:SetDisableDragIfFit()
  self.itemListCtrl.disableDragPfbNum = 10
  self.itemListCells = self.itemListCtrl:GetCells()
  self.manualRefreshGroupGO = self:FindGO("ManualRefreshGroup")
  self.refreshBtnGO = self:FindGO("ManualRefreshButton", self.manualRefreshGroupGO)
  self:AddClickEvent(self.refreshBtnGO, function()
    self:OnRefreshClicked()
  end)
  self.refreshTimesLabel = self:FindComponent("ManualRefreshCountLabel", UILabel, self.manualRefreshGroupGO)
  moneyIcon = self:FindComponent("ManualRefreshCostIcon", UISprite, self.manualRefreshGroupGO)
  IconManager:SetItemIcon(moneyIconName, moneyIcon)
  self.refreshCostLabel = self:FindComponent("ManualRefreshCostLabel", UILabel, self.manualRefreshGroupGO)
  self.refreshBg = self:FindComponent("Bg", UISprite, self.manualRefreshGroupGO)
  self.periodGroupGO = self:FindGO("PeriodGroup")
  self.periodLabel = self:FindGO("PeriodLabel", self.periodGroupGO):GetComponent(UILabel)
  self.helpBtnGO = self:FindGO("HelpButton", self.periodGroupGO)
  self:TryOpenHelpViewById(35041, nil, self.helpBtnGO)
  self.bulkBtn = self:FindGO("BulkBtn")
  self.unavailableBulkBtn = self:FindGO("UnavailableBulkBtn")
  self.exitBulkBtn = self:FindGO("ExitBulkBtn")
  self.bulkBuyBtn = self:FindGO("BulkBuyBtn")
  self.bulkBuyBtnSp = self.bulkBuyBtn:GetComponent(UIMultiSprite)
  self.bulkBuyBtnLabel = self:FindComponent("Label", UILabel, self.bulkBuyBtn)
  self.bulkBuyPriceLabel = self:FindComponent("PriceNum", UILabel, self.bulkBuyBtn)
  self.bulkBuyPriceTable = self:FindComponent("PriceIndicator", UITable, self.bulkBuyBtn)
  moneyIcon = self:FindComponent("PriceIcon", UISprite, self.bulkBuyBtn)
  IconManager:SetItemIcon(moneyIconName, moneyIcon)
  self:AddClickEvent(self.bulkBtn, function()
    self.itemDetailGO:SetActive(false)
    self:SetBulkMode(true)
  end)
  self:AddClickEvent(self.exitBulkBtn, function()
    self:SetBulkMode(false)
  end)
  self:AddClickEvent(self.bulkBuyBtn, function()
    if self.bulkBuyBtnSp.CurrentState == 0 then
      return
    end
    local bagIns = BagProxy.Instance
    if bagIns:CheckBagIsFull(BagProxy.BagType.MainBag) and bagIns:CheckBagIsFull(BagProxy.BagType.Temp) then
      MsgManager.ShowMsgByID(989)
      return
    end
    SupplyDepotProxy.BulkBuy(self.bulkCart)
  end)
  self.itemDetailGO = self:LoadPreferb("cell/HappyShopBuyItemCell", self.gameObject, true)
  self.itemDetailGO:SetActive(false)
  self.itemDetail = SupplyDepotItemCell.new(self.itemDetailGO)
end

function SupplyDepotView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnMyDataChange)
  self:AddListenEvt(ServiceEvent.ActivityCmdTimeLimitShopPageCmd, self.RefreshView)
  self:AddListenEvt(SupplyDepotEvent.UpdateItem, self.RefreshView)
end

function SupplyDepotView:UpdateView()
  self:UpdateTitle()
  self:UpdateMoney()
  self:UpdateRefresh()
  self:UpdateDate()
  self:UpdateAutoRefreshTime()
  self:UpdateItems(true)
  self:SetBulkMode(false)
end

function SupplyDepotView:UpdateTitle()
  local config = proxy:GetConfig()
  self.titleLabel.text = config and config.activityName or ZhString.DefaultSupplyDepotTitle
end

function SupplyDepotView:RefreshView()
  self:UpdateRefresh()
  self:UpdateItems()
  self:SetBulkMode(self.isBulkMode)
end

function SupplyDepotView:UpdateMoney()
  self.moneyLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function SupplyDepotView:UpdateRefresh()
  self.refreshTimesLabel.text = proxy:GetRefreshTimes()
  self.refreshCostLabel.text = StringUtil.NumThousandFormat(proxy:GetRefreshCost())
  self.refreshBg:UpdateAnchors()
end

function SupplyDepotView:UpdateDate()
  local startDate = proxy:GetStartDate()
  local endDate = proxy:GetEndDate()
  if startDate and endDate then
    self.periodLabel.text = string.format(ZhString.TimePeriodFormat2, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min)
  else
    self.periodLabel.text = ""
  end
end

function SupplyDepotView:OnMyDataChange()
  self:UpdateMoney()
  if self.isBulkMode then
    self:UpdateBulkPrice()
  end
end

function SupplyDepotView:OnItemCellClicked(cell)
  local data = cell.data
  if self.isBulkMode then
    if data.bought then
      return
    end
    if self.bulkCart[data.idx] then
      self.bulkCart[data.idx] = nil
    else
      self.bulkCart[data.idx] = data
    end
    self:_ForEachCell(SupplyDepotCell.UpdateByBulkReference)
    self:UpdateBulkPrice()
  elseif data.bought then
    self.itemDetailGO:SetActive(false)
  else
    self.itemDetailGO:SetActive(true)
    self.itemDetail:SetData(data)
  end
end

function SupplyDepotView:OnRefreshClicked()
  if not proxy:IsActive() then
    MsgManager.ShowMsgByID(40973)
    return
  end
  local refreshTimes = proxy:GetRefreshTimes()
  if refreshTimes <= 0 then
    MsgManager.ShowMsgByID(41324)
    return
  end
  local refreshCost = proxy:GetRefreshCost()
  local money = MyselfProxy.Instance:GetROB()
  if refreshCost > money then
    MsgManager.ShowMsgByID(41325)
    return
  end
  if LocalSaveProxy.Instance:GetDontShowAgain(41323) then
    proxy:ManualRefresh()
  else
    MsgManager.DontAgainConfirmMsgByID(41323, function()
      proxy:ManualRefresh()
    end, nil, nil, refreshCost)
  end
end

function SupplyDepotView:UpdateAutoRefreshTime()
  local nextRefreshSeconds = proxy:GetNextRefreshSeconds()
  if nextRefreshSeconds < 0 then
    nextRefreshSeconds = 0
  end
  self.autoRefreshTimeLabel.text = DateUtil.ParseHHMMSSBySecondsV2(nextRefreshSeconds)
end

function SupplyDepotView:UpdateItems(needSort)
  if needSort then
    proxy:SortItems()
  end
  local items = proxy:GetActItems() or _EmptyTable
  local forceLayout = #items <= 10
  self.itemListCtrl:ResetDatas(items, forceLayout)
end

function SupplyDepotView:SetBulkMode(active)
  if self.bulkCart then
    TableUtility.TableClear(self.bulkCart)
    if not self.isBulkMode or active then
      self:_ForEachCell(function(cell, cart)
        if cell.data and not cell.data.bought then
          cart[cell.data.idx] = cell.data
        end
      end, self.bulkCart)
    end
  end
  if self:IsAllBought() then
    active = false
  end
  self.isBulkMode = active and true or false
  self:UpdateBulkMode()
end

function SupplyDepotView:UpdateBulkMode()
  self.bulkBtn:SetActive(not self.isBulkMode and not self:IsAllBought())
  self.unavailableBulkBtn:SetActive(not self.isBulkMode and self:IsAllBought())
  self.exitBulkBtn:SetActive(self.isBulkMode)
  self.bulkBuyBtn:SetActive(self.isBulkMode)
  self.bulkCart = self.bulkCart or {}
  self:_ForEachCell(SupplyDepotCell.SetBulkReference, self.bulkCart)
  self:_ForEachCell(SupplyDepotCell.SetBulkMode, self.isBulkMode)
  self:UpdateBulkPrice()
end

function SupplyDepotView:UpdateBulkPrice()
  local sum, cost, discount = 0
  for _, data in pairs(self.bulkCart) do
    cost = data.ItemCount
    discount = data.Discount or 100
    sum = sum + math.floor(cost * discount / 100 + 0.01)
  end
  self.bulkBuyPriceLabel.text = StringUtil.NumThousandFormat(sum)
  local canBuy = sum <= MyselfProxy.Instance:GetROB()
  self.bulkBuyPriceLabel.color = canBuy and ColorUtil.NGUIWhite or LuaGeometry.GetTempColor(1, 0.3764705882352941, 0.12941176470588237)
  self.bulkBuyPriceTable:Reposition()
  canBuy = canBuy and 0 < sum
  self.bulkBuyBtnSp.CurrentState = canBuy and 1 or 0
  self.bulkBuyBtnLabel.effectColor = canBuy and LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0) or LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
end

function SupplyDepotView:_ForEachCell(action, ...)
  for _, cell in pairs(self.itemListCells) do
    action(cell, ...)
  end
end

function SupplyDepotView:IsAllBought()
  local items = proxy:GetActItems()
  if not items then
    return false
  end
  local isAllBought = true
  for _, item in pairs(items) do
    if not item.bought then
      isAllBought = false
      break
    end
  end
  return isAllBought
end
