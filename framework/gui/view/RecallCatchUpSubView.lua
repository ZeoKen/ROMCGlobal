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
  if proxy then
    proxy:QueryShopConfig()
  end
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
  self.goGachaCoinBalance = self:FindGO("GachaCoinBalance", self.gameObject)
  if self.goGachaCoinBalance then
    self.labGachaCoinBalance = self:FindComponent("Lab", UILabel, self.goGachaCoinBalance)
    self.spGachaCoin = self:FindComponent("Icon", UISprite, self.goGachaCoinBalance)
  end
  self.goGachaCoinBalance2 = self:FindGO("GachaCoinBalance2", self.gameObject)
  if self.goGachaCoinBalance2 then
    self.labGachaCoinBalance2 = self:FindComponent("Lab", UILabel, self.goGachaCoinBalance2)
    self.spGachaCoin2 = self:FindComponent("Icon", UISprite, self.goGachaCoinBalance2)
  end
  self.shopView = self:FindGO("ShopView")
end

function RecallCatchUpSubView:AddViewEvts()
  self:AddClickEvent(self.helpBtn, function()
    self:HandleClickHelpBtn(500008)
  end)
end

function RecallCatchUpSubView:AddMapEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateBalance)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBalance)
  self:AddDispatcherEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.SessionShopBuyShopItem, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.NUserUpdateShopGotItem, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnShopConfigUpdate)
  self:AddDispatcherEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.OnShopConfigUpdate)
  self:AddDispatcherEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RefreshPage)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd, self.OnCatchUpDataUpdate)
end

function RecallCatchUpSubView:InitView()
  self:RefreshShopList()
  self:UpdateCurrencyDisplay()
  self.titleLabel.text = ZhString.RecallIntegration_CatchUp
  self:UpdateLeftTime()
end

function RecallCatchUpSubView:RefreshPage()
  self:RefreshShopList()
  self:UpdateCurrencyDisplay()
  self:UpdateBatchLabel()
end

function RecallCatchUpSubView:RefreshShopList()
  local items = proxy:GetDisplayDataList() or {}
  if items and 0 < #items then
    table.sort(items, function(a, b)
      local soldOutA, typePriorityA, orderA = self:GetSortInfo(a)
      local soldOutB, typePriorityB, orderB = self:GetSortInfo(b)
      if soldOutA ~= soldOutB then
        return not soldOutA
      end
      if typePriorityA ~= typePriorityB then
        return typePriorityA < typePriorityB
      end
      return orderA < orderB
    end)
    self.itemListCtrl:ResetDatas(items)
  else
    self.itemListCtrl:ResetDatas({})
  end
  xdlog("RecallCatchUpSubView:RefreshShopList", "商品数量:", #items)
end

function RecallCatchUpSubView:UpdateCurrencyDisplay()
  self.shopItemID = nil
  self.shopItemID2 = nil
  local currencyList = {}
  local currencySet = {}
  local items = proxy and proxy:GetDisplayDataList()
  if items then
    for i = 1, #items do
      local shopItemData = items[i] and items[i].shopItemData
      if shopItemData then
        for j = 1, 5 do
          local suffix = j == 1 and "" or tostring(j)
          local itemID = shopItemData["ItemID" .. suffix]
          if itemID and not currencySet[itemID] then
            currencySet[itemID] = true
            currencyList[#currencyList + 1] = itemID
            if 2 <= #currencyList then
              break
            end
          end
        end
      end
      if 2 <= #currencyList then
        break
      end
    end
  end
  self.shopItemID = currencyList[1]
  self.shopItemID2 = currencyList[2]
  self:SetCurrencyWidget(self.goGachaCoinBalance, self.spGachaCoin, self.shopItemID)
  self:SetCurrencyWidget(self.goGachaCoinBalance2, self.spGachaCoin2, self.shopItemID2)
  self:UpdateBalance()
end

function RecallCatchUpSubView:SetCurrencyWidget(widgetGO, iconSprite, itemID)
  if not widgetGO then
    return
  end
  widgetGO:SetActive(itemID ~= nil)
  if itemID and iconSprite then
    local itemData = Table_Item[itemID]
    if itemData then
      IconManager:SetItemIcon(itemData.Icon, iconSprite)
    end
  end
end

function RecallCatchUpSubView:UpdateBalance()
  if self.shopItemID and self.labGachaCoinBalance then
    local coinNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(self.shopItemID)
    self.labGachaCoinBalance.text = FunctionNewRecharge.FormatMilComma(coinNum) or 0
  end
  if self.shopItemID2 and self.labGachaCoinBalance2 then
    local coinNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(self.shopItemID2)
    self.labGachaCoinBalance2.text = FunctionNewRecharge.FormatMilComma(coinNum) or 0
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

function RecallCatchUpSubView:OnCatchUpDataUpdate(data)
  xdlog("RecallCatchUpSubView:OnCatchUpDataUpdate", "catch up data update", data)
  if RecallCatchUpProxy.Instance then
    RecallCatchUpProxy.Instance:QueryShopConfig()
    self:RefreshPage()
  end
end

function RecallCatchUpSubView:OnShopConfigUpdate()
  self:RefreshPage()
end

function RecallCatchUpSubView:GetSortInfo(itemData)
  local leftCount = self:GetLeftCount(itemData)
  local isSoldOut = leftCount <= 0
  local typePriority = itemData and itemData.shopItemData and 1 or 2
  local order = 0
  if itemData and itemData.shopItemData then
    order = itemData.shopItemData.ShopOrder or itemData.shopItemID or itemData.shopItemData.id or 0
  elseif itemData then
    order = itemData.configId or itemData.depositID or 0
  end
  return isSoldOut, typePriority, order
end

function RecallCatchUpSubView:GetLeftCount(itemData)
  if itemData and itemData.shopItemData then
    return HappyShopProxy.Instance:GetCanBuyCount(itemData.shopItemData) or 1
  end
  if not itemData or not itemData.depositID then
    return 0
  end
  local depositData = NewRechargeDepositGoodsData.new()
  depositData:ResetData(itemData.depositID)
  local purchasedTimes = depositData.purchaseTimes or 0
  local purchaseLimitTimes = depositData.purchaseLimit_N or 0
  return purchaseLimitTimes - purchasedTimes
end
