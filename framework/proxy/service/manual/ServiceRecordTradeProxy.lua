autoImport("ServiceRecordTradeAutoProxy")
ServiceRecordTradeProxy = class("ServiceRecordTradeProxy", ServiceRecordTradeAutoProxy)
ServiceRecordTradeProxy.Instance = nil
ServiceRecordTradeProxy.NAME = "ServiceRecordTradeProxy"

function ServiceRecordTradeProxy:ctor(proxyName)
  if ServiceRecordTradeProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRecordTradeProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRecordTradeProxy.Instance = self
  end
end

function ServiceRecordTradeProxy:RecvBriefPendingListRecordTradeCmd(data)
  ShopMallProxy.Instance:RecvExchangeBuySellingClassify(data)
  self:Notify(ServiceEvent.RecordTradeBriefPendingListRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvDetailPendingListRecordTradeCmd(data)
  ShopMallProxy.Instance:RecvExchangeBuyDetail(data)
  self:Notify(ServiceEvent.RecordTradeDetailPendingListRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvMyPendingListRecordTradeCmd(data)
  ShopMallProxy.Instance:RecvExchangePendingList(data)
  self:Notify(ServiceEvent.RecordTradeMyPendingListRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvItemSellInfoRecordTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeItemSellInfoRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvMyTradeLogRecordTradeCmd(data)
  helplog("-----------RecvMyTradeLogRecordTradeCmd ", data.trade_type)
  if data.trade_type == BoothProxy.TradeType.Exchange then
    QuickBuyProxy.Instance:RecvRecord(data)
    ShopMallProxy.Instance:RecvExchangeRecord(data)
  else
    BoothProxy.Instance:RecvExchangeRecord(data)
  end
  self:Notify(ServiceEvent.RecordTradeMyTradeLogRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:CallReqServerPriceRecordTradeCmd(charid, itemData, price, issell, statetype, count, buyer_count, end_time, trade_type)
  local serverItem = itemData and itemData:ExportServerItem() or nil
  NetConfig.PBC = false
  ServiceRecordTradeProxy.super.CallReqServerPriceRecordTradeCmd(self, charid, serverItem, price, issell, statetype, count, buyer_count, end_time, trade_type)
  NetConfig.PBC = true
end

function ServiceRecordTradeProxy:CallSellItemRecordTradeCmd(item_info, charid, ret, type)
  NetConfig.PBC = false
  ServiceRecordTradeProxy.super.CallSellItemRecordTradeCmd(self, item_info, charid, ret, type)
  NetConfig.PBC = true
end

function ServiceRecordTradeProxy:RecvReqServerPriceRecordTradeCmd(data)
  FunctionItemTrade.Me():SetTradePrice(data.itemData, data.price)
  QuickBuyProxy.Instance:RecvCompareEquipPrice(data)
  self:Notify(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvHotItemidRecordTrade(data)
  ShopMallProxy.Instance:RecvExchangeBuySellingClassify(data)
  self:Notify(ServiceEvent.RecordTradeHotItemidRecordTrade, data)
end

function ServiceRecordTradeProxy:RecvTakeLogCmd(data)
  ShopMallProxy.Instance:RecvTakeLog(data)
  if data.log and data.log.trade_type == BoothProxy.TradeType.Booth then
    BoothProxy.Instance:RecvTakeLog(data)
  end
  self:Notify(ServiceEvent.RecordTradeTakeLogCmd, data)
end

function ServiceRecordTradeProxy:RecvTakeAllLogCmd(data)
  ShopMallProxy.Instance:RecvTakeAllLog(data)
  BoothProxy.Instance:RecvTakeAllLog(data)
  self:Notify(ServiceEvent.RecordTradeTakeAllLogCmd, data)
end

function ServiceRecordTradeProxy:RecvAddNewLog(data)
  ShopMallProxy.Instance:RecvAddNewLog(data)
  if data.log and data.log.trade_type == BoothProxy.TradeType.Booth then
    BoothProxy.Instance:RecvAddNewLog(data)
  end
  self:Notify(ServiceEvent.RecordTradeAddNewLog, data)
end

function ServiceRecordTradeProxy:RecvFetchNameInfoCmd(data)
  ShopMallProxy.Instance:RecvExchangeRecordDetail(data)
  self:Notify(ServiceEvent.RecordTradeFetchNameInfoCmd, data)
end

function ServiceRecordTradeProxy:RecvNtfCanTakeCountTradeCmd(data)
  if data.trade_type == BoothProxy.TradeType.Exchange then
    ShopMallProxy.Instance:RecvCanTakeCount(data)
  else
    BoothProxy.Instance:RecvCanTakeCount(data)
  end
  self:Notify(ServiceEvent.RecordTradeNtfCanTakeCountTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvReqGiveItemInfoCmd(data)
  ShopMallProxy.Instance:RecvReqGiveItemInfoCmd(data.iteminfo)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ExchangeSignExpressView
  })
  self:Notify(ServiceEvent.RecordTradeReqGiveItemInfoCmd, data)
end

function ServiceRecordTradeProxy:RecvBuyItemRecordTradeCmd(data)
  if data.type == BoothProxy.TradeType.Exchange then
    QuickBuyProxy.Instance:RecvBuyItem(data)
  end
  self:Notify(ServiceEvent.RecordTradeBuyItemRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvQueryItemCountTradeCmd(data)
  QuickBuyProxy.Instance:RecvQueryItemCountTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeQueryItemCountTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvTodayFinanceRank(data)
  ShopMallProxy.Instance:RecvTodayFinanceRank(data)
  self:Notify(ServiceEvent.RecordTradeTodayFinanceRank, data)
end

function ServiceRecordTradeProxy:RecvTodayFinanceDetail(data)
  ShopMallProxy.Instance:RecvTodayFinanceDetail(data)
  self:Notify(ServiceEvent.RecordTradeTodayFinanceDetail, data)
end

function ServiceRecordTradeProxy:RecvBoothPlayerPendingListCmd(data)
  BoothProxy.Instance:RecvBoothPlayerPendingListCmd(data)
  self:Notify(ServiceEvent.RecordTradeBoothPlayerPendingListCmd, data)
end

function ServiceRecordTradeProxy:RecvUpdateOrderTradeCmd(data)
  if data.type == BoothProxy.TradeType.Booth then
    BoothProxy.Instance:RecvUpdateOrderTradeCmd(data)
  end
  self:Notify(ServiceEvent.RecordTradeUpdateOrderTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvQueryItemPriceRecordTradeCmd(data)
  for i = 1, #data.items do
    local item = data.items[i]
    FunctionItemTrade.Me():SetTradePriceCache(item.itemdata, item.price)
  end
  self:Notify(ServiceEvent.RecordTradeQueryItemPriceRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:CallCancelItemRecordTrade(item_info, charid, ret, order_id, type, quota, item_id)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.CancelItemRecordTrade.id
    local msgParam = {}
    if item_info ~= nil then
      msgParam.item_info = item_info
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if order_id ~= nil then
      msgParam.order_id = order_id
    end
    if type ~= nil then
      msgParam.type = type
    end
    if item_id ~= nil then
      msgParam.item_id = item_id
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = RecordTrade_pb.CancelItemRecordTrade()
    if item_info ~= nil then
      msg.item_info = item_info
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if order_id ~= nil then
      msg.order_id = order_id
    end
    if type ~= nil then
      msg.type = type
    end
    if item_id ~= nil then
      msg.item_id = item_id
    end
    self:SendProto(msg)
  end
end

function ServiceRecordTradeProxy:CallResellPendingRecordTrade(item_info, charid, ret, order_id, type)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ResellPendingRecordTrade.id
    local msgParam = {}
    msgParam.item_info = {}
    if item_info ~= nil and item_info.itemid ~= nil then
      msgParam.item_info.itemid = item_info.itemid
    end
    if item_info ~= nil and item_info.price ~= nil then
      msgParam.item_info.price = item_info.price
    end
    if item_info ~= nil and item_info.publicity_id ~= nil then
      msgParam.item_info.publicity_id = item_info.publicity_id
    end
    if item_info ~= nil and item_info.up_rate ~= nil then
      msgParam.item_info.up_rate = item_info.up_rate
    end
    if item_info ~= nil and item_info.down_rate ~= nil then
      msgParam.item_info.down_rate = item_info.down_rate
    end
    if item_info ~= nil and item_info.item_data ~= nil then
      msgParam.item_info.item_data = item_info.item_data
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if order_id ~= nil then
      msgParam.order_id = order_id
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = RecordTrade_pb.ResellPendingRecordTrade()
    if item_info ~= nil and item_info.itemid ~= nil then
      msg.item_info.itemid = item_info.itemid
    end
    if item_info ~= nil and item_info.price ~= nil then
      msg.item_info.price = item_info.price
    end
    if item_info ~= nil and item_info.publicity_id ~= nil then
      msg.item_info.publicity_id = item_info.publicity_id
    end
    if item_info ~= nil and item_info.up_rate ~= nil then
      msg.item_info.up_rate = item_info.up_rate
    end
    if item_info ~= nil and item_info.down_rate ~= nil then
      msg.item_info.down_rate = item_info.down_rate
    end
    if item_info ~= nil and item_info.item_data ~= nil then
      msgParam.item_info.item_data = item_info.item_data
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if order_id ~= nil then
      msg.order_id = order_id
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  end
end

function ServiceRecordTradeProxy:CallBuyItemRecordTradeCmd(item_info, charid, ret, type)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.BuyItemRecordTradeCmd.id
    local msgParam = {}
    msgParam.item_info = {}
    if item_info ~= nil and item_info.itemid ~= nil then
      msgParam.item_info.itemid = item_info.itemid
    end
    if item_info ~= nil and item_info.price ~= nil then
      msgParam.item_info.price = item_info.price
    end
    if item_info ~= nil and item_info.count ~= nil then
      msgParam.item_info.count = item_info.count
    end
    if item_info ~= nil and item_info.order_id ~= nil then
      msgParam.item_info.order_id = item_info.order_id
    end
    if item_info ~= nil and item_info.publicity_id ~= nil then
      msgParam.item_info.publicity_id = item_info.publicity_id
    end
    if item_info ~= nil and item_info.charid ~= nil then
      msgParam.item_info.charid = item_info.charid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = RecordTrade_pb.BuyItemRecordTradeCmd()
    if item_info ~= nil and item_info.itemid ~= nil then
      msg.item_info.itemid = item_info.itemid
    end
    if item_info ~= nil and item_info.price ~= nil then
      msg.item_info.price = item_info.price
    end
    if item_info ~= nil and item_info.count ~= nil then
      msg.item_info.count = item_info.count
    end
    if item_info ~= nil and item_info.order_id ~= nil then
      msg.item_info.order_id = item_info.order_id
    end
    if item_info ~= nil and item_info.publicity_id ~= nil then
      msg.item_info.publicity_id = item_info.publicity_id
    end
    if item_info ~= nil and item_info.charid ~= nil then
      msg.item_info.charid = item_info.charid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  end
end

function ServiceRecordTradeProxy:CallTakeLogCmd(log, success)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.TakeLogCmd.id
    local msgParam = {}
    if log ~= nil then
      msgParam.log = {}
      if log.id ~= nil then
        msgParam.log.id = log.id
      end
      if log.logtype ~= nil then
        msgParam.log.logtype = log.logtype
      end
      if log.trade_type ~= nil then
        msgParam.log.trade_type = log.trade_type
      end
    end
    if log ~= nil and log.trade_type ~= nil then
      msgParam.log.trade_type = log.trade_type
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = RecordTrade_pb.TakeLogCmd()
    if log ~= nil then
      if log.id ~= nil then
        msg.log.id = log.id
      end
      if log.logtype ~= nil then
        msg.log.logtype = log.logtype
      end
      if log.trade_type ~= nil then
        msg.log.trade_type = log.trade_type
      end
    end
    if log ~= nil and log.trade_type ~= nil then
      msg.log.trade_type = log.trade_type
    end
    self:SendProto(msg)
  end
end

function ServiceRecordTradeProxy:CallReqGiveItemInfoCmd(id, iteminfo)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ReqGiveItemInfoCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = RecordTrade_pb.ReqGiveItemInfoCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  end
end

function ServiceRecordTradeProxy:RecvPreorderQueryPriceRecordTradeCmd(data)
  ShopMallPreorderProxy.Instance:RecvPreorderQueryPriceRecordTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradePreorderQueryPriceRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvPreorderItemRecordTradeCmd(data)
  ShopMallPreorderProxy.Instance:RecvPreorderItemRecordTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradePreorderItemRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvPreorderCancelRecordTradeCmd(data)
  ShopMallPreorderProxy.Instance:RecvPreorderCancelRecordTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradePreorderCancelRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvPreorderListRecordTradeCmd(data)
  ShopMallPreorderProxy.Instance:RecvPreorderListRecordTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradePreorderListRecordTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvQueryHoldedItemCountTradeCmd(data)
  QuickBuyProxy.Instance:RecvQueryHoldedItemCountTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeQueryHoldedItemCountTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvQuerySelledItemCountTradeCmd(data)
  QuickBuyProxy.Instance:RecvQuerySellItemCountTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeQuerySelledItemCountTradeCmd, data)
end

function ServiceRecordTradeProxy:RecvRecommendItemTradeCmd(data)
  redlog("ServiceRecordTradeProxy:RecvRecommendItemTradeCmd")
  ShopMallProxy.Instance:RecvRecommendItemTradeCmd(data)
  self:Notify(ServiceEvent.RecordTradeRecommendItemTradeCmd, data)
end
