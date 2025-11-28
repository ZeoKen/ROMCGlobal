RecallCatchUpSubView = class("RecallCatchUpSubView", SubView)
local viewPath = ResourcePathHelper.UIView("RecallCatchUpSubView")
autoImport("RecallCatchUpShopCell")
local proxy

function RecallCatchUpSubView:Init()
  if self.inited then
    return
  end
  if not proxy then
    proxy = RecallCatchUpProxy.Instance
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitView()
  self.inited = true
end

function RecallCatchUpSubView:OnEnter()
  RecallCatchUpSubView.super.OnEnter(self)
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  self:RefreshPage()
end

function RecallCatchUpSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "RecallCatchUpSubView"
end

function RecallCatchUpSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("RecallCatchUpSubView")
  self.itemGroupGO = self:FindGO("ItemGroup", self.gameObject)
  self.itemListCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.itemGroupGO), RecallCatchUpShopCell, "NoviceShopItemCellType2")
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemCellClicked, self)
  self.itemListCells = self.itemListCtrl:GetCells()
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.batchLabel = self:FindGO("BatchLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.shopView = self:FindGO("ShopView")
end

function RecallCatchUpSubView:AddViewEvts()
  self:AddClickEvent(self.helpBtn, function()
    self:HandleClickHelpBtn(500008)
  end)
end

function RecallCatchUpSubView:AddMapEvts()
  self:AddDispatcherEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.SessionShopBuyShopItem, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.NUserUpdateShopGotItem, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd, self.OnCatchUpDataUpdate)
end

function RecallCatchUpSubView:InitView()
  self:RefreshShopList()
  self.titleLabel.text = ZhString.RecallIntegration_CatchUp
  self:UpdateLeftTime()
end

function RecallCatchUpSubView:RefreshPage()
  self:RefreshShopList()
  self:UpdateBatchLabel()
end

function RecallCatchUpSubView:RefreshShopList()
  local items = proxy:GetDisplayDataList()
  if items and 0 < #items then
    table.sort(items, function(a, b)
      local leftCountA = self:GetLeftCount(a)
      local leftCountB = self:GetLeftCount(b)
      if leftCountA <= 0 ~= (leftCountB <= 0) then
        return 0 < leftCountA
      end
      return false
    end)
    self.itemListCtrl:ResetDatas(items)
  else
    self.itemListCtrl:ResetDatas({})
  end
  xdlog("RecallCatchUpSubView:RefreshShopList", "商品数量:", #items)
end

function RecallCatchUpSubView:OnCatchUpDataUpdate(data)
  xdlog("RecallCatchUpSubView:OnCatchUpDataUpdate", "追赶数据更新", data)
  if RecallCatchUpProxy.Instance then
    self:RefreshPage()
  end
end

function RecallCatchUpSubView:UpdateBatchLabel()
  if not self.batchLabel then
    return
  end
  local catchUpData = proxy:GetCatchUpDataFirst()
  if catchUpData then
    local currentBatch = catchUpData.index + 1 or 1
    local totalBatch = RecallInfoProxy.Instance:GetTotalBatchCount() or 1
    self.batchLabel.text = string.format(ZhString.RecallIntegration_BatchNumber or "第%d/%d期", currentBatch, totalBatch)
  end
end

function RecallCatchUpSubView:OnItemCellClicked(cell)
  xdlog("RecallCatchUpSubView:OnItemCellClicked", "点击商品", cell:GetIndex(), cell:GetDepositID())
end

function RecallCatchUpSubView:GetDisplayInfo()
  return proxy:GetDisplayInfo()
end

function RecallCatchUpSubView:GetCatchUpDataFirst()
  return proxy:GetCatchUpDataFirst()
end

function RecallCatchUpSubView:GetLeftCount(itemData)
  if not itemData or not itemData.depositID then
    return 0
  end
  local depositData = NewRechargeDepositGoodsData.new()
  depositData:ResetData(itemData.depositID)
  local purchasedTimes = depositData.purchaseTimes or 0
  local purchaseLimitTimes = depositData.purchaseLimit_N or 0
  local leftCount = purchaseLimitTimes - purchasedTimes
  return leftCount
end

function RecallCatchUpSubView:UpdateLeftTime()
  local displayInfo = proxy:GetDisplayInfo()
  if displayInfo and displayInfo.endTime and displayInfo.endTime > 0 then
    self.timeLabel.gameObject:SetActive(true)
    self:StartUpdateTimer()
  else
    self.timeLabel.gameObject:SetActive(false)
  end
end

function RecallCatchUpSubView:StartUpdateTimer()
  self:StopUpdateTimer()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTimeDisplay()
  end, self, "TimeUpdate")
end

function RecallCatchUpSubView:StopUpdateTimer()
  TimeTickManager.Me():ClearTick(self, "TimeUpdate")
end

function RecallCatchUpSubView:UpdateTimeDisplay()
  if not self.timeLabel then
    return
  end
  local displayInfo = proxy:GetDisplayInfo()
  if not (displayInfo and displayInfo.endTime) or displayInfo.endTime <= 0 then
    self:StopUpdateTimer()
    self.timeLabel.gameObject:SetActive(false)
    return
  end
  local endTime = displayInfo.endTime
  local currentTime = ServerTime.CurServerTime() / 1000
  local leftTime = endTime - currentTime
  if 0 < leftTime then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
    local timeText
    if 0 < day then
      timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
      self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
    else
      timeText = string.format("%02d:%02d:%02d", hour, min, sec)
      self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
    end
  else
    self:StopUpdateTimer()
    self.timeLabel.text = ZhString.Activity_End
  end
end

function RecallCatchUpSubView:HandleClickHelpBtn(helpid)
  if helpid and Table_Help[helpid] then
    local helpConfig = Table_Help[helpid]
    self:OpenHelpView(helpConfig)
  end
end
