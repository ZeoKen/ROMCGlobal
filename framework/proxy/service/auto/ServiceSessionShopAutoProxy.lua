ServiceSessionShopAutoProxy = class("ServiceSessionShopAutoProxy", ServiceProxy)
ServiceSessionShopAutoProxy.Instance = nil
ServiceSessionShopAutoProxy.NAME = "ServiceSessionShopAutoProxy"

function ServiceSessionShopAutoProxy:ctor(proxyName)
  if ServiceSessionShopAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionShopAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionShopAutoProxy.Instance = self
  end
end

function ServiceSessionShopAutoProxy:Init()
end

function ServiceSessionShopAutoProxy:onRegister()
  self:Listen(52, 1, function(data)
    self:RecvBuyShopItem(data)
  end)
  self:Listen(52, 2, function(data)
    self:RecvQueryShopConfigCmd(data)
  end)
  self:Listen(52, 3, function(data)
    self:RecvQueryQuickBuyConfigCmd(data)
  end)
  self:Listen(52, 4, function(data)
    self:RecvQueryShopSoldCountCmd(data)
  end)
  self:Listen(52, 5, function(data)
    self:RecvShopDataUpdateCmd(data)
  end)
  self:Listen(52, 6, function(data)
    self:RecvUpdateShopConfigCmd(data)
  end)
  self:Listen(52, 7, function(data)
    self:RecvUpdateExchangeShopData(data)
  end)
  self:Listen(52, 8, function(data)
    self:RecvExchangeShopItemCmd(data)
  end)
  self:Listen(52, 9, function(data)
    self:RecvResetExchangeShopDataShopCmd(data)
  end)
  self:Listen(52, 10, function(data)
    self:RecvFreyExchangeShopCmd(data)
  end)
  self:Listen(52, 11, function(data)
    self:RecvOpenShopTypeShopCmd(data)
  end)
  self:Listen(52, 12, function(data)
    self:RecvBulkBuyShopItem(data)
  end)
  self:Listen(52, 13, function(data)
    self:RecvBuyPackageSaleShopCmd(data)
  end)
  self:Listen(52, 14, function(data)
    self:RecvBuyDepositProductShopCmd(data)
  end)
end

function ServiceSessionShopAutoProxy:CallBuyShopItem(id, count, price, price2, success, grid, accweeklimitshow)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.BuyShopItem()
    if id ~= nil then
      msg.id = id
    end
    if count ~= nil then
      msg.count = count
    end
    if price ~= nil then
      msg.price = price
    end
    if price2 ~= nil then
      msg.price2 = price2
    end
    if success ~= nil then
      msg.success = success
    end
    if grid ~= nil then
      msg.grid = grid
    end
    if accweeklimitshow ~= nil then
      msg.accweeklimitshow = accweeklimitshow
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyShopItem.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if count ~= nil then
      msgParam.count = count
    end
    if price ~= nil then
      msgParam.price = price
    end
    if price2 ~= nil then
      msgParam.price2 = price2
    end
    if success ~= nil then
      msgParam.success = success
    end
    if grid ~= nil then
      msgParam.grid = grid
    end
    if accweeklimitshow ~= nil then
      msgParam.accweeklimitshow = accweeklimitshow
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallQueryShopConfigCmd(type, shopid, goods, screen, tab)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.QueryShopConfigCmd()
    if type ~= nil then
      msg.type = type
    end
    if shopid ~= nil then
      msg.shopid = shopid
    end
    if goods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.goods == nil then
        msg.goods = {}
      end
      for i = 1, #goods do
        table.insert(msg.goods, goods[i])
      end
    end
    if screen ~= nil then
      msg.screen = screen
    end
    if tab ~= nil then
      msg.tab = tab
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryShopConfigCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if shopid ~= nil then
      msgParam.shopid = shopid
    end
    if goods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.goods == nil then
        msgParam.goods = {}
      end
      for i = 1, #goods do
        table.insert(msgParam.goods, goods[i])
      end
    end
    if screen ~= nil then
      msgParam.screen = screen
    end
    if tab ~= nil then
      msgParam.tab = tab
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallQueryQuickBuyConfigCmd(itemids, goods)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.QueryQuickBuyConfigCmd()
    if itemids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemids == nil then
        msg.itemids = {}
      end
      for i = 1, #itemids do
        table.insert(msg.itemids, itemids[i])
      end
    end
    if goods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.goods == nil then
        msg.goods = {}
      end
      for i = 1, #goods do
        table.insert(msg.goods, goods[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryQuickBuyConfigCmd.id
    local msgParam = {}
    if itemids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemids == nil then
        msgParam.itemids = {}
      end
      for i = 1, #itemids do
        table.insert(msgParam.itemids, itemids[i])
      end
    end
    if goods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.goods == nil then
        msgParam.goods = {}
      end
      for i = 1, #goods do
        table.insert(msgParam.goods, goods[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallQueryShopSoldCountCmd(items)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.QueryShopSoldCountCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryShopSoldCountCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallShopDataUpdateCmd(type, shopid)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.ShopDataUpdateCmd()
    if type ~= nil then
      msg.type = type
    end
    if shopid ~= nil then
      msg.shopid = shopid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShopDataUpdateCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if shopid ~= nil then
      msgParam.shopid = shopid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallUpdateShopConfigCmd(type, shopid, del_goods_id, add_goods)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.UpdateShopConfigCmd()
    if type ~= nil then
      msg.type = type
    end
    if shopid ~= nil then
      msg.shopid = shopid
    end
    if del_goods_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_goods_id == nil then
        msg.del_goods_id = {}
      end
      for i = 1, #del_goods_id do
        table.insert(msg.del_goods_id, del_goods_id[i])
      end
    end
    if add_goods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add_goods == nil then
        msg.add_goods = {}
      end
      for i = 1, #add_goods do
        table.insert(msg.add_goods, add_goods[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateShopConfigCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if shopid ~= nil then
      msgParam.shopid = shopid
    end
    if del_goods_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_goods_id == nil then
        msgParam.del_goods_id = {}
      end
      for i = 1, #del_goods_id do
        table.insert(msgParam.del_goods_id, del_goods_id[i])
      end
    end
    if add_goods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add_goods == nil then
        msgParam.add_goods = {}
      end
      for i = 1, #add_goods do
        table.insert(msgParam.add_goods, add_goods[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallUpdateExchangeShopData(items, del_items, menu_open, reset)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.UpdateExchangeShopData()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if del_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_items == nil then
        msg.del_items = {}
      end
      for i = 1, #del_items do
        table.insert(msg.del_items, del_items[i])
      end
    end
    if menu_open ~= nil then
      msg.menu_open = menu_open
    end
    if reset ~= nil then
      msg.reset = reset
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateExchangeShopData.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if del_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_items == nil then
        msgParam.del_items = {}
      end
      for i = 1, #del_items do
        table.insert(msgParam.del_items, del_items[i])
      end
    end
    if menu_open ~= nil then
      msgParam.menu_open = menu_open
    end
    if reset ~= nil then
      msgParam.reset = reset
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallExchangeShopItemCmd(id, items)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.ExchangeShopItemCmd()
    if id ~= nil then
      msg.id = id
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeShopItemCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallResetExchangeShopDataShopCmd(items)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.ResetExchangeShopDataShopCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResetExchangeShopDataShopCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallFreyExchangeShopCmd(shopid, items)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.FreyExchangeShopCmd()
    if shopid ~= nil then
      msg.shopid = shopid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FreyExchangeShopCmd.id
    local msgParam = {}
    if shopid ~= nil then
      msgParam.shopid = shopid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallOpenShopTypeShopCmd(shoptype, open)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.OpenShopTypeShopCmd()
    if shoptype ~= nil then
      msg.shoptype = shoptype
    end
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenShopTypeShopCmd.id
    local msgParam = {}
    if shoptype ~= nil then
      msgParam.shoptype = shoptype
    end
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallBulkBuyShopItem(items, success)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.BulkBuyShopItem()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BulkBuyShopItem.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallBuyPackageSaleShopCmd(saleid, config_md5, items)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.BuyPackageSaleShopCmd()
    if saleid ~= nil then
      msg.saleid = saleid
    end
    if config_md5 ~= nil then
      msg.config_md5 = config_md5
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyPackageSaleShopCmd.id
    local msgParam = {}
    if saleid ~= nil then
      msgParam.saleid = saleid
    end
    if config_md5 ~= nil then
      msgParam.config_md5 = config_md5
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:CallBuyDepositProductShopCmd(id, product_id)
  if not NetConfig.PBC then
    local msg = SessionShop_pb.BuyDepositProductShopCmd()
    if id ~= nil then
      msg.id = id
    end
    if product_id ~= nil then
      msg.product_id = product_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyDepositProductShopCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if product_id ~= nil then
      msgParam.product_id = product_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionShopAutoProxy:RecvBuyShopItem(data)
  self:Notify(ServiceEvent.SessionShopBuyShopItem, data)
end

function ServiceSessionShopAutoProxy:RecvQueryShopConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryShopConfigCmd, data)
end

function ServiceSessionShopAutoProxy:RecvQueryQuickBuyConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryQuickBuyConfigCmd, data)
end

function ServiceSessionShopAutoProxy:RecvQueryShopSoldCountCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryShopSoldCountCmd, data)
end

function ServiceSessionShopAutoProxy:RecvShopDataUpdateCmd(data)
  self:Notify(ServiceEvent.SessionShopShopDataUpdateCmd, data)
end

function ServiceSessionShopAutoProxy:RecvUpdateShopConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopUpdateShopConfigCmd, data)
end

function ServiceSessionShopAutoProxy:RecvUpdateExchangeShopData(data)
  self:Notify(ServiceEvent.SessionShopUpdateExchangeShopData, data)
end

function ServiceSessionShopAutoProxy:RecvExchangeShopItemCmd(data)
  self:Notify(ServiceEvent.SessionShopExchangeShopItemCmd, data)
end

function ServiceSessionShopAutoProxy:RecvResetExchangeShopDataShopCmd(data)
  self:Notify(ServiceEvent.SessionShopResetExchangeShopDataShopCmd, data)
end

function ServiceSessionShopAutoProxy:RecvFreyExchangeShopCmd(data)
  self:Notify(ServiceEvent.SessionShopFreyExchangeShopCmd, data)
end

function ServiceSessionShopAutoProxy:RecvOpenShopTypeShopCmd(data)
  self:Notify(ServiceEvent.SessionShopOpenShopTypeShopCmd, data)
end

function ServiceSessionShopAutoProxy:RecvBulkBuyShopItem(data)
  self:Notify(ServiceEvent.SessionShopBulkBuyShopItem, data)
end

function ServiceSessionShopAutoProxy:RecvBuyPackageSaleShopCmd(data)
  self:Notify(ServiceEvent.SessionShopBuyPackageSaleShopCmd, data)
end

function ServiceSessionShopAutoProxy:RecvBuyDepositProductShopCmd(data)
  self:Notify(ServiceEvent.SessionShopBuyDepositProductShopCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SessionShopBuyShopItem = "ServiceEvent_SessionShopBuyShopItem"
ServiceEvent.SessionShopQueryShopConfigCmd = "ServiceEvent_SessionShopQueryShopConfigCmd"
ServiceEvent.SessionShopQueryQuickBuyConfigCmd = "ServiceEvent_SessionShopQueryQuickBuyConfigCmd"
ServiceEvent.SessionShopQueryShopSoldCountCmd = "ServiceEvent_SessionShopQueryShopSoldCountCmd"
ServiceEvent.SessionShopShopDataUpdateCmd = "ServiceEvent_SessionShopShopDataUpdateCmd"
ServiceEvent.SessionShopUpdateShopConfigCmd = "ServiceEvent_SessionShopUpdateShopConfigCmd"
ServiceEvent.SessionShopUpdateExchangeShopData = "ServiceEvent_SessionShopUpdateExchangeShopData"
ServiceEvent.SessionShopExchangeShopItemCmd = "ServiceEvent_SessionShopExchangeShopItemCmd"
ServiceEvent.SessionShopResetExchangeShopDataShopCmd = "ServiceEvent_SessionShopResetExchangeShopDataShopCmd"
ServiceEvent.SessionShopFreyExchangeShopCmd = "ServiceEvent_SessionShopFreyExchangeShopCmd"
ServiceEvent.SessionShopOpenShopTypeShopCmd = "ServiceEvent_SessionShopOpenShopTypeShopCmd"
ServiceEvent.SessionShopBulkBuyShopItem = "ServiceEvent_SessionShopBulkBuyShopItem"
ServiceEvent.SessionShopBuyPackageSaleShopCmd = "ServiceEvent_SessionShopBuyPackageSaleShopCmd"
ServiceEvent.SessionShopBuyDepositProductShopCmd = "ServiceEvent_SessionShopBuyDepositProductShopCmd"
