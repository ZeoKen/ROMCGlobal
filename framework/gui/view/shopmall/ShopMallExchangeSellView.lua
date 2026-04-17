autoImport("ExchangeBagSellCell")
autoImport("ShopMallExchangeSellingCombineCell")
autoImport("ItemTabCell")
ShopMallExchangeSellView = class("ShopMallExchangeSellView", SubView)

function ShopMallExchangeSellView:OnExit()
  local cells = self.sellingCombineList:GetCells()
  for i = 1, #cells do
    cells[i]:OnDestroy()
  end
  self.quickSellQueue = nil
  self.quickSellIndex = nil
  self.isQuickSelling = false
  self.lastQuickSellTime = nil
  self.lastQuickSellCount = nil
  self.hasQuickSellSuccess = false
  self.quickSellSuccessCount = 0
  self.quickSellFailCount = 0
  self.quickSellSentCount = 0
  self.quickSellResponseCount = 0
  self:ClearQuickSellTimer()
  if self.refreshTimer then
    self.refreshTimer:Destroy()
    self.refreshTimer = nil
  end
  ShopMallExchangeSellView.super.OnExit(self)
end

function ShopMallExchangeSellView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function ShopMallExchangeSellView:FindObjs()
  self.sellView = self:FindGO("SellView", self.container.exchangeView)
  self.tipsLabel = self:FindGO("TipsLabel", self.sellView):GetComponent(UILabel)
  self.sellingTitle = self:FindGO("SellingTitle", self.sellView):GetComponent(UILabel)
  self.sellingScrollView = self:FindGO("SellingScrollView", self.sellView):GetComponent(UIScrollView)
  self.bagSellContainer = self:FindGO("BagSellContainer", self.sellView)
  self.sellingContainer = self:FindGO("SellingContainer", self.sellView)
  self.sellingGrid = self.sellingContainer:GetComponent(UIGrid)
  self.itemTabs = self:FindComponent("ItemTabs", UIGrid)
  self.loadingRoot = self:FindGO("LoadingRoot", self.recordView)
  self.quickSellContainer = self:FindGO("QuickSellContainer", self.sellView)
  if self.quickSellContainer then
    self.quickSellButton = self:FindGO("QuickSellButton", self.quickSellContainer)
    self.quickSellContainer:SetActive(false)
    self:AddClickEvent(self.quickSellButton, function()
      self:ClickQuickSell()
    end)
  end
  self.quickSellWaitingPanel = self:FindGO("QuickSellWaitingPanel")
  self.quickSellWaitingPanel:SetActive(false)
end

function ShopMallExchangeSellView:AddEvts()
  self:AddListenEvt(ServiceEvent.RecordTradeMyPendingListRecordTradeCmd, self.RecvPendingList)
  self:AddListenEvt(ServiceEvent.RecordTradeListNtfRecordTrade, self.RecvListNtf)
  self:AddListenEvt(ServiceEvent.RecordTradeQueryItemPriceRecordTradeCmd, self.RecvItemPriceList)
  self:AddListenEvt(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd, self.RecvQuickSellItemPrice)
  self:AddListenEvt(ServiceEvent.RecordTradeSellItemRecordTradeCmd, self.RecvSellItem)
end

function ShopMallExchangeSellView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.BarrowUpdate, self.OnItemUpdate)
end

function ShopMallExchangeSellView:InitShow()
  self.maxPendingCount = CommonFun.calcTradeMaxPendingCout(Game.Myself.data)
  self.bagSellWrapHelper = WrapListCtrl.new(self.bagSellContainer, ExchangeBagSellCell, "ExchangeBagSellCell", WrapListCtrl_Dir.Vertical, 4, 100)
  self.bagSellWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickBagSell, self)
  self.sellingCombineList = ListCtrl.new(self.sellingGrid, ShopMallExchangeSellingCombineCell, "ShopMallExchangeSellingCombineCell")
  self.sellingCombineList:AddEventListener(MouseEvent.MouseClick, self.ClickSelling, self)
  self.tabCtl = UIGridListCtrl.new(self.itemTabs, ItemTabCell, "ItemTabCell")
  self.tabCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItemTab, self)
  self:UpdateTabList()
  self:ChooseTab(1)
  self:UpdateSelling()
  ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd(nil, Game.Myself.data.id)
  self.tipsLabel.text = ZhString.ShopMall_ExchangeSellTip
  self.loadingRoot:SetActive(false)
end

function ShopMallExchangeSellView:UpdateBagSell(tabType)
  local bagSellData = ShopMallProxy.Instance:GetExchangeBagSell(tabType)
  self.bagSellWrapHelper:ResetDatas(bagSellData)
end

function ShopMallExchangeSellView:UpdateSelling()
  local sellingData = ShopMallProxy.Instance:GetExchangeSelfSelling()
  self.sellingTitle.text = string.format(ZhString.ShopMall_ExchangeSellTitle, tostring(#sellingData), tostring(self.maxPendingCount))
  local newData = self:ReUniteCellData(sellingData, 2)
  self.sellingCombineList:ResetDatas(newData)
  local hasExpired = false
  for i = 1, #sellingData do
    if sellingData[i].isExpired then
      hasExpired = true
      break
    end
  end
  self.quickSellContainer:SetActive(hasExpired)
end

function ShopMallExchangeSellView:ClickBagSell(cellCtl)
  if cellCtl.data == nil then
    return
  end
  local hasQuench = cellCtl.data:HasQuench()
  if hasQuench then
    MsgManager.ConfirmMsgByID(43332, function()
      FuncShortCutFunc.Me():CallByID(20)
    end)
    return
  end
  if self.currentBagSellCell and self.currentBagSellCell ~= cellCtl then
    self.currentBagSellCell:SetChoose(false)
  end
  cellCtl:SetChoose(true)
  self.currentBagSellCell = cellCtl
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ShopMallExchangeSellInfoView,
    viewdata = {
      data = cellCtl.data,
      type = ShopMallExchangeSellEnum.Sell
    }
  })
end

function ShopMallExchangeSellView:ClickSelling(cellCtl)
  local data = cellCtl.data
  if data == nil then
    return
  end
  local type
  if data:CanExchange() and data.isExpired then
    type = ShopMallExchangeSellEnum.Resell
  else
    type = ShopMallExchangeSellEnum.Cancel
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ShopMallExchangeSellInfoView,
    viewdata = {
      cell = cellCtl,
      data = data:GetItemData(),
      type = type
    }
  })
end

function ShopMallExchangeSellView:RecvPendingList()
  self:UpdateSelling()
end

function ShopMallExchangeSellView:RecvListNtf(note)
  local data = note.body
  if data.trade_type == BoothProxy.TradeType.Exchange and data.type == RecordTrade_pb.ELIST_NTF_MY_PENDING then
    ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd(nil, Game.Myself.data.id)
  end
end

function ShopMallExchangeSellView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function ShopMallExchangeSellView:UpdateTabList()
  local tabDatas = ReusableTable.CreateArray()
  for i = 0, 4 do
    local data = {
      index = i,
      tabType = 1,
      Config = GameConfig.ItemPage[i]
    }
    table.insert(tabDatas, data)
  end
  self.tabCtl:ResetDatas(tabDatas)
  ReusableTable.DestroyAndClearArray(tabDatas)
end

function ShopMallExchangeSellView:ClickItemTab(cell)
  local data = cell.data
  if not data then
    return
  end
  self:UpdateBagSell(data.Config)
  self.bagSellWrapHelper:ResetPosition()
  self.curTab = cell.indexInList
end

function ShopMallExchangeSellView:ChooseTab(tab)
  local cells = self.tabCtl:GetCells()
  local cell = cells[tab]
  if cell then
    self:ClickItemTab(cell)
    cell:SetTog(true)
  end
end

function ShopMallExchangeSellView:OnItemUpdate()
  local cells = self.tabCtl:GetCells()
  local cell = cells[self.curTab]
  if cell and cell.data then
    self:UpdateBagSell(cell.data.Config)
  end
end

function ShopMallExchangeSellView:QueryItemPriceList()
  local sellingData = ShopMallProxy.Instance:GetExchangeSelfSelling()
  self.sellingTitle.text = string.format(ZhString.ShopMall_ExchangeSellTitle, tostring(#sellingData), tostring(self.maxPendingCount))
end

function ShopMallExchangeSellView:RecvItemPriceList()
  self.loadingRoot:SetActive(false)
end

function ShopMallExchangeSellView:ClickQuickSell()
  if self.isQuickSelling then
    MsgManager.ShowMsgByID(49)
    return
  end
  if self.lastQuickSellTime and self.lastQuickSellCount then
    local currentTime = ServerTime.CurServerTime()
    local timeDiff = currentTime - self.lastQuickSellTime
    local cooldownTime = self.lastQuickSellCount * (GameConfig.Exchange.QuickSellInterval or 2000)
    if timeDiff < cooldownTime then
      MsgManager.ShowMsgByID(49)
      return
    end
  end
  local sellingData = ShopMallProxy.Instance:GetExchangeSelfSelling()
  local expiredItems = {}
  for i = 1, #sellingData do
    local data = sellingData[i]
    if data:CanExchange() and data.isExpired then
      table.insert(expiredItems, data)
    end
  end
  if #expiredItems == 0 then
    return
  end
  MsgManager.ConfirmMsgByID(1000013, function()
    self.isQuickSelling = true
    self.hasQuickSellSuccess = false
    self.quickSellSuccessCount = 0
    self.quickSellFailCount = 0
    self.quickSellSentCount = 0
    self.quickSellResponseCount = 0
    self.quickSellQueue = expiredItems
    self.quickSellIndex = 1
    if self.quickSellWaitingPanel then
      self.quickSellWaitingPanel:SetActive(true)
    end
    self:ClearQuickSellTimer()
    local timeoutDuration = #expiredItems * (GameConfig.Exchange.QuickSellInterval or 2000)
    self.quickSellTimer = TimeTickManager.Me():CreateOnceDelayTick(timeoutDuration, function()
      self.quickSellTimer = nil
      if self.quickSellWaitingPanel then
        self.quickSellWaitingPanel:SetActive(false)
      end
      self.quickSellQueue = nil
      self.quickSellIndex = nil
      self.isQuickSelling = false
    end, self)
    self:ProcessNextQuickSellItem()
  end)
end

function ShopMallExchangeSellView:ProcessNextQuickSellItem()
  local queueCount = self.quickSellQueue and #self.quickSellQueue or 0
  local currentIndex = self.quickSellIndex or 0
  if not self.quickSellQueue or self.quickSellIndex > #self.quickSellQueue then
    if self.quickSellWaitingPanel then
      self.quickSellWaitingPanel:SetActive(false)
    end
    if self.refreshTimer then
      self.refreshTimer:Destroy()
      self.refreshTimer = nil
    end
    self.refreshTimer = TimeTickManager.Me():CreateOnceDelayTick(1000, function()
      ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd(nil, Game.Myself.data.id)
    end, self)
    self:ClearQuickSellTimer()
    return
  end
  local data = self.quickSellQueue[self.quickSellIndex]
  if not data then
    self.quickSellFailCount = (self.quickSellFailCount or 0) + 1
    self.quickSellIndex = self.quickSellIndex + 1
    self:ProcessNextQuickSellItem()
    return
  end
  local itemData = data:GetItemData()
  if not itemData then
    self.quickSellFailCount = (self.quickSellFailCount or 0) + 1
    self.quickSellIndex = self.quickSellIndex + 1
    self:ProcessNextQuickSellItem()
    return
  end
  FunctionItemTrade.Me():GetTradePrice(itemData, true, true)
end

function ShopMallExchangeSellView:RecvQuickSellItemPrice(note)
  if not self.quickSellQueue or not self.quickSellIndex then
    return
  end
  local priceData = note.body
  if not priceData then
    self.quickSellFailCount = (self.quickSellFailCount or 0) + 1
    self.quickSellIndex = self.quickSellIndex + 1
    self:ProcessNextQuickSellItem()
    return
  end
  local data = self.quickSellQueue[self.quickSellIndex]
  if not data then
    return
  end
  local itemData = data:GetItemData()
  if not itemData then
    return
  end
  if priceData.itemData and priceData.itemData.base and itemData.staticData.id ~= priceData.itemData.base.id then
    return
  end
  local count = data.count or 1
  local boothfee = ShopMallProxy.Instance:GetBoothfee(priceData.price, count)
  local currentROB = MyselfProxy.Instance:GetROB()
  if boothfee > currentROB then
    MsgManager.ShowMsgByID(10109)
    self.quickSellFailCount = (self.quickSellFailCount or 0) + 1
    self.quickSellIndex = self.quickSellIndex + 1
    self:ProcessNextQuickSellItem()
    return
  end
  local sellingData = ShopMallProxy.Instance:GetExchangeSelfSelling()
  local currentSellingCount = 0
  for i = 1, #sellingData do
    if not sellingData[i].isExpired then
      currentSellingCount = currentSellingCount + 1
    end
  end
  if currentSellingCount >= self.maxPendingCount then
    MsgManager.ShowMsgByID(10104)
    self.quickSellQueue = nil
    self.quickSellIndex = nil
    self:CheckQuickSellFinish()
    return
  end
  local itemInfo = {}
  itemInfo.itemid = itemData.staticData.id
  itemInfo.price = priceData.price
  itemInfo.publicity_id = (priceData.statetype == ShopMallStateTypeEnum.WillPublicity or priceData.statetype == ShopMallStateTypeEnum.InPublicity) and 1 or 0
  itemInfo.item_data = itemData:ExportServerItem()
  ServiceRecordTradeProxy.Instance:CallResellPendingRecordTrade(itemInfo, Game.Myself.data.id, nil, data.orderId)
  self.quickSellSentCount = (self.quickSellSentCount or 0) + 1
  self.quickSellIndex = self.quickSellIndex + 1
  self:ProcessNextQuickSellItem()
end

function ShopMallExchangeSellView:ClearQuickSellLt()
  if self.quickSellLt then
    self.quickSellLt:Destroy()
    self.quickSellLt = nil
  end
end

function ShopMallExchangeSellView:ClearQuickSellTimer()
  if self.quickSellTimer then
    self.quickSellTimer:Destroy()
    self.quickSellTimer = nil
  end
end

function ShopMallExchangeSellView:RecvSellItem(note)
  local data = note.body
  if data.type == BoothProxy.TradeType.Exchange and data.ret == ProtoCommon_pb.ETRADE_RET_CODE_SUCCESS then
    if self.isQuickSelling then
      self.hasQuickSellSuccess = true
      self.quickSellSuccessCount = (self.quickSellSuccessCount or 0) + 1
      self.quickSellResponseCount = (self.quickSellResponseCount or 0) + 1
      self:CheckQuickSellFinish()
    end
  elseif data.type == BoothProxy.TradeType.Exchange and self.isQuickSelling then
    self.quickSellFailCount = (self.quickSellFailCount or 0) + 1
    self.quickSellResponseCount = (self.quickSellResponseCount or 0) + 1
    self:CheckQuickSellFinish()
  end
end

function ShopMallExchangeSellView:CheckQuickSellFinish()
  if not self.isQuickSelling then
    return
  end
  if self.quickSellResponseCount >= self.quickSellSentCount and self.quickSellSentCount > 0 or self.quickSellSentCount == 0 then
    if self.hasQuickSellSuccess then
      ServiceRecordTradeProxy.Instance:CallMyPendingListRecordTradeCmd(nil, Game.Myself.data.id)
    end
    if self.quickSellSentCount > 0 then
      self.lastQuickSellTime = ServerTime.CurServerTime()
      self.lastQuickSellCount = self.quickSellSentCount
    end
    if self.quickSellWaitingPanel then
      self.quickSellWaitingPanel:SetActive(false)
    end
    self:ClearQuickSellTimer()
    self.quickSellQueue = nil
    self.quickSellIndex = nil
    self.isQuickSelling = false
    self.hasQuickSellSuccess = false
    self.quickSellSuccessCount = 0
    self.quickSellFailCount = 0
    self.quickSellSentCount = 0
    self.quickSellResponseCount = 0
  end
end
