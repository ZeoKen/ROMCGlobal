autoImport("ExchangeBagSellCell")
autoImport("ShopMallExchangeSellingCombineCell")
autoImport("ItemTabCell")
ShopMallExchangeSellView = class("ShopMallExchangeSellView", SubView)

function ShopMallExchangeSellView:OnExit()
  local cells = self.sellingCombineList:GetCells()
  for i = 1, #cells do
    cells[i]:OnDestroy()
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
  self.QuickSellButton = self:FindGO("QuickSellButton")
end

function ShopMallExchangeSellView:AddEvts()
  self:AddListenEvt(ServiceEvent.RecordTradeMyPendingListRecordTradeCmd, self.RecvPendingList)
  self:AddListenEvt(ServiceEvent.RecordTradeListNtfRecordTrade, self.RecvListNtf)
  self:AddListenEvt(ServiceEvent.RecordTradeQueryItemPriceRecordTradeCmd, self.RecvItemPriceList)
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
  local sellReceiveCount = ShopMallProxy.Instance:GetExchangeRecordReceiveCount()
  if 0 < sellReceiveCount then
    self:ClearQuickSellLt()
    self.quickSellLt = TimeTickManager.Me():CreateOnceDelayTick(15000, function(owner, deltaTime)
      self.quickSellLt = nil
      self.loadingRoot:SetActive(false)
    end, self)
    self.loadingRoot:SetActive(true)
    self:QueryItemPriceList()
  end
end

function ShopMallExchangeSellView:ClearQuickSellLt()
  if self.quickSellLt then
    self.quickSellLt:Destroy()
    self.quickSellLt = nil
  end
end
