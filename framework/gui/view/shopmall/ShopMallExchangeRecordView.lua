autoImport("ExchangeRecordCell")
ShopMallExchangeRecordView = class("ShopMallExchangeRecordView", SubView)

function ShopMallExchangeRecordView:OnExit()
  if self.wrapHelper then
    local cells = self.wrapHelper:GetCellCtls()
    for i = 1, #cells do
      cells[i]:OnDestroy()
    end
  end
  self:ClearQuickTakeLt()
  self:ClearCallRecordLt()
  ShopMallExchangeRecordView.super.OnExit(self)
end

function ShopMallExchangeRecordView:SetShow(show)
  self.isShow = show
  if show and self.dirty then
    self.dirty = nil
    self:CallRecordList(self.currentPage, true)
  end
end

function ShopMallExchangeRecordView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function ShopMallExchangeRecordView:FindObjs()
  self.recordView = self:FindGO("RecordView", self.container.exchangeView)
  self.contentContainer = self:FindGO("RecordContainer", self.recordView)
  self.empty = self:FindGO("RecordEmpty", self.recordView)
  self.tips = self:FindGO("Tips", self.recordView):GetComponent(UILabel)
  self.receive = self:FindGO("RecordReceive", self.recordView):GetComponent(UILabel)
  self.recordFilter = self:FindGO("RecordFilter", self.recordView):GetComponent(UIPopupList)
  self.turnLeft = self:FindGO("TurnLeft", self.recordView)
  self.turnRight = self:FindGO("TurnRight", self.recordView)
  self.page = self:FindGO("Page", self.recordView):GetComponent(UILabel)
  self.loadingRoot = self:FindGO("LoadingRoot", self.recordView)
end

function ShopMallExchangeRecordView:AddEvts()
  self:AddClickEvent(self.receive.gameObject, function()
    self:ClickReceive()
  end)
  EventDelegate.Add(self.recordFilter.onChange, function()
    if self.recordFilter.data == nil then
      return
    end
    if self.recordFilterData ~= self.recordFilter.data then
      self.recordFilterData = self.recordFilter.data
      self:UpdateRecord()
      self.wrapHelper:ResetPosition()
    end
  end)
  self:AddClickEvent(self.turnLeft, function()
    self:ClickTurnLeft()
  end)
  self:AddClickEvent(self.turnRight, function()
    self:ClickTurnRight()
  end)
  local quickTakeBtn = self:FindGO("QuickTakeBtn", self.recordView)
  self:AddClickEvent(quickTakeBtn, function()
    self:ClickQuickTake()
  end)
end

function ShopMallExchangeRecordView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.RecordTradeMyTradeLogRecordTradeCmd, self.RecvMyTradeLog)
  self:AddListenEvt(ServiceEvent.RecordTradeListNtfRecordTrade, self.RecvListNtf)
  self:AddListenEvt(ServiceEvent.RecordTradeTakeLogCmd, self.RecvTakeLog)
  self:AddListenEvt(ServiceEvent.RecordTradeTakeAllLogCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.RecordTradeAddNewLog, self.RecvLog)
  self:AddListenEvt(ServiceEvent.RecordTradeNtfCanTakeCountTradeCmd, self.UpdateReceive)
  self:AddListenEvt(ServiceEvent.RecordTradeQucikTakeLogTradeCmd, self.RecvQucikTakeLogTrade)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateRedTip)
  self:AddListenEvt(ServiceEvent.NUserSysMsg, self.ClearQuickTip)
end

local day = 86400

function ShopMallExchangeRecordView:InitShow()
  self.receiveNum = 4
  self.tips.text = string.format(ZhString.ShopMall_ExchangeRecordMaxLog, math.floor(GameConfig.Exchange.LogTime / day), math.floor(GameConfig.Exchange.SendButtonTime / day), math.floor(GameConfig.Exchange.ReceiveTime / day))
  self.empty:SetActive(false)
  self.loadingRoot:SetActive(false)
  self:InitFilter()
  local wrapConfig = {
    wrapObj = self.contentContainer,
    pfbNum = 9,
    cellName = "ShopMallExchangeRecordCell",
    control = ExchangeRecordCell,
    dir = 1
  }
  self.wrapHelper = WrapCellHelper.new(wrapConfig)
  self:UpdateView()
  self:ResetPage()
  self:CallRecordList(self.currentPage)
end

function ShopMallExchangeRecordView:InitFilter()
  self.recordFilter:Clear()
  local rangeList = ShopMallProxy.Instance:GetExchangeFilter(GameConfig.Exchange.ExchangeLogScreen)
  for i = 1, #rangeList do
    local rangeData = GameConfig.Exchange.ExchangeLogScreen[rangeList[i]]
    self.recordFilter:AddItem(rangeData, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.recordFilterData = range
    local rangeData = GameConfig.Exchange.ExchangeLogScreen[range]
    self.recordFilter.value = rangeData
  end
end

function ShopMallExchangeRecordView:UpdateRecord()
  self:ClearCallRecordLt()
  local data = ShopMallProxy.Instance:GetExchangeRecordFilter(self.recordFilterData)
  self.wrapHelper:UpdateInfo(data)
  if 0 < #data then
    self.empty:SetActive(false)
  else
    self.empty:SetActive(true)
  end
end

function ShopMallExchangeRecordView:UpdateView()
  self:UpdateRecord()
  self:UpdateReceive()
end

function ShopMallExchangeRecordView:UpdateReceive()
  local sellReceiveCount = ShopMallProxy.Instance:GetExchangeRecordReceiveCount()
  self.receive.gameObject:SetActive(0 < sellReceiveCount)
  self.receive.text = string.format(ZhString.ShopMall_ExchangeRecordReceive, sellReceiveCount)
end

function ShopMallExchangeRecordView:UpdatePage()
  self.page.text = self.currentPage .. "/" .. self.totalPage
end

function ShopMallExchangeRecordView:ResetPage()
  self.currentPage = 1
  self.totalPage = 1
  self:UpdatePage()
end

function ShopMallExchangeRecordView:RecvMyTradeLog(note)
  if not note.body or note.body.trade_type ~= BoothProxy.TradeType.Exchange then
    return
  end
  self:RecvLog(note)
  self.wrapHelper:ResetPosition()
end

function ShopMallExchangeRecordView:RecvLog(note)
  local data = note.body
  if data then
    self:UpdateView()
    if data.total_page_count then
      self.totalPage = math.max(data.total_page_count, 1)
    else
      self.totalPage = 1
    end
    if data.index then
      self.currentPage = math.clamp(data.index + 1, 1, self.totalPage)
    end
    self:UpdatePage()
  end
end

function ShopMallExchangeRecordView:RecvListNtf(note)
  local data = note.body
  if not data or data.trade_type ~= BoothProxy.TradeType.Exchange then
    return
  end
  local type = data.type
  if type == RecordTrade_pb.ELIST_NTF_MY_LOG or type == RecordTrade_pb.ELIST_NTF_MY_LOG_RED_POINT then
    if self.isShow then
      self:CallRecordList(self.currentPage, true)
    else
      self.dirty = true
      if type == RecordTrade_pb.ELIST_NTF_MY_LOG_RED_POINT then
        RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TRADE_RECORD)
      end
    end
  end
end

function ShopMallExchangeRecordView:RecvTakeLog(note)
  local data = note.body
  if data.success then
    self:UpdateView()
  end
end

function ShopMallExchangeRecordView:RecvQucikTakeLogTrade(note)
  if not note.body or note.body.trade_type ~= BoothProxy.TradeType.Exchange then
    return
  end
  self:ClearQuickTakeLt()
  self.loadingRoot:SetActive(false)
end

function ShopMallExchangeRecordView:ClickReceive()
  if self.wrapHelper then
    local cells = self.wrapHelper:GetCellCtls()
    for i = 1, 8 do
      if cells[i].data and cells[i].data:CanReceive() then
        return
      end
    end
  end
  local closestIndex = ShopMallProxy.Instance:GetClosestReceiveIndex(self.recordFilterData)
  if closestIndex then
    self.wrapHelper:SetStartPositionByIndex(closestIndex)
  end
end

function ShopMallExchangeRecordView:ClickTurnLeft()
  local page = self.currentPage - 1
  if 1 <= page then
    self.currentPage = page
    self:CallRecordList(self.currentPage)
  end
end

function ShopMallExchangeRecordView:ClickTurnRight()
  self:CallRecordList(self.currentPage + 1)
end

function ShopMallExchangeRecordView:ClickQuickTake()
  local sellReceiveCount = ShopMallProxy.Instance:GetExchangeRecordReceiveCount()
  if 0 < sellReceiveCount then
    self:ClearQuickTakeLt()
    self.quickTakeLt = TimeTickManager.Me():CreateOnceDelayTick(15000, function(owner, deltaTime)
      self.quickTakeLt = nil
      self.loadingRoot:SetActive(false)
    end, self)
    self.loadingRoot:SetActive(true)
    ServiceRecordTradeProxy.Instance:CallQucikTakeLogTradeCmd()
  end
end

function ShopMallExchangeRecordView:CallRecordList(index, isAuto)
  if not isAuto then
    self.callRecordLt = TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
      self.callRecordLt = nil
      MsgManager.FloatMsgTableParam(nil, ZhString.ExchangeTimeoutError)
    end, self)
  end
  if index and 0 < index and index <= self.totalPage then
    ServiceRecordTradeProxy.Instance:CallMyTradeLogRecordTradeCmd(Game.Myself.data.id, index - 1)
  end
end

function ShopMallExchangeRecordView:ClearQuickTakeLt()
  if self.quickTakeLt then
    self.quickTakeLt:Destroy()
    self.quickTakeLt = nil
  end
end

function ShopMallExchangeRecordView:ClearCallRecordLt()
  if self.callRecordLt then
    if self.callRecordLt.completeFunc then
      self.callRecordLt.completeFunc = nil
    end
    self.callRecordLt:Destroy()
    self.callRecordLt = nil
  end
end

function ShopMallExchangeRecordView:UpdateRedTip()
  ShopMallProxy.Instance:UpdateRedTip()
end

function ShopMallExchangeRecordView:ClearQuickTip(note)
  if note and note.body and note.body.id == 989 then
    self:ClearQuickTakeLt()
    self.loadingRoot:SetActive(false)
  end
end
