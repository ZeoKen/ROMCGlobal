autoImport("ServiceSessionShopAutoProxy")
ServiceSessionShopProxy = class("ServiceSessionShopProxy", ServiceSessionShopAutoProxy)
ServiceSessionShopProxy.Instance = nil
ServiceSessionShopProxy.NAME = "ServiceSessionShopProxy"

function ServiceSessionShopProxy:ctor(proxyName)
  if ServiceSessionShopProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionShopProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionShopProxy.Instance = self
  end
end

function ServiceSessionShopProxy:CallQueryShopItem(type, items)
  ServiceSessionShopProxy.super.CallQueryShopItem(self, type, items)
end

function ServiceSessionShopProxy:CallBuyPackageSaleShopCmd(cost, saleid, config_md5, items)
  OverseaHostHelper:GachaUseComfirm(cost, function()
    ServiceSessionShopProxy.super.CallBuyPackageSaleShopCmd(self, saleid, config_md5, items)
  end)
end

function ServiceSessionShopProxy:CallBuyShopItem(id, count, price, price2, success, hideNetDelayPrompt, ingnoreSecurity, grid)
  if not ingnoreSecurity then
    FunctionSecurity.Me():NormalOperation(function()
      xdlog("CallBuyShopItem", self, self.callBuyShopItem, self.receiveBuyShopItem)
      local now = UnityUnscaledTime
      if self.callBuyShopItem ~= nil and self.receiveBuyShopItem == nil and now - self.callBuyShopItem < (GameConfig.ShopNetDelay or 60) then
        if not hideNetDelayPrompt then
          MsgManager.ShowMsgByID(89)
        end
        redlog("没有收到服务器回复，判断为断线，不处理购买请求")
        return
      end
      self.callBuyShopItem = now
      self.receiveBuyShopItem = nil
      xdlog("CallBuyShopItem", self, self.callBuyShopItem, self.receiveBuyShopItem)
      NewRechargeProxy.Instance:TryUseLastSort()
      ServiceSessionShopProxy.super.CallBuyShopItem(self, id, count, price, price2, success, grid)
    end)
  else
    xdlog("CallBuyShopItem", self, self.callBuyShopItem, self.receiveBuyShopItem)
    local now = Time.unscaledTime
    if self.callBuyShopItem ~= nil and self.receiveBuyShopItem == nil and now - self.callBuyShopItem < (GameConfig.ShopNetDelay or 60) then
      if not hideNetDelayPrompt then
        MsgManager.ShowMsgByID(89)
      end
      redlog("没有收到服务器回复，判断为断线，不处理购买请求")
      return
    end
    self.callBuyShopItem = now
    self.receiveBuyShopItem = nil
    xdlog("CallBuyShopItem", self, self.callBuyShopItem, self.receiveBuyShopItem)
    NewRechargeProxy.Instance:TryUseLastSort()
    ServiceSessionShopProxy.super:CallBuyShopItem(id, count, price, price2, success, grid)
  end
end

function ServiceSessionShopProxy:RecvBuyShopItem(data)
  xdlog("RecvBuyShopItem", ServiceSessionShopProxy.super, ServiceSessionShopProxy.super.__cname)
  self.receiveBuyShopItem = UnityUnscaledTime
  QuickBuyProxy.Instance:RecvBuyShopItem(data)
  HappyShopProxy.Instance:RecvBuyShopItem(data)
  SupplyDepotProxy.Instance:RecvBuyShopItem(data)
  ShopProxy.Instance:updateWeekLimitNum(data)
  self:Notify(ServiceEvent.SessionShopBuyShopItem, data)
  EventManager.Me():PassEvent(ServiceEvent.SessionShopBuyShopItem, data)
end

function ServiceSessionShopProxy:RecvBulkBuyShopItem(data)
  SupplyDepotProxy.Instance:RecvBulkBuyShopItem(data.items, data.success)
  self:Notify(ServiceEvent.SessionShopBulkBuyShopItem, data)
  EventManager.Me():PassEvent(ServiceEvent.SessionShopBulkBuyShopItem, data)
end

function ServiceSessionShopProxy:RecvQueryShopConfigCmd(data)
  ShopProxy.Instance:RecvQueryShopConfig(data)
  HappyShopProxy.Instance:RecvQueryShopConfig(data)
  PeddlerShopProxy.Instance:UpdateShopConfig(data)
  NoviceShopProxy.Instance:RecvQueryShopConfig(data)
  AfricanPoringProxy.Instance:RecvQueryShopConfigCmd(data)
  NewRechargeProxy.Ins:RefreshCombinePackInfo(data)
  self:Notify(ServiceEvent.SessionShopQueryShopConfigCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.SessionShopQueryShopConfigCmd, data)
  self:Notify(GuideEvent.SessionShopQueryShopConfigCmd)
  NewRechargeProxy.Ins:Shop_UpdateOneZenyGoodsBuyInfo(data)
end

function ServiceSessionShopProxy:RecvQueryQuickBuyConfigCmd(data)
  QuickBuyProxy.Instance:RecvQueryQuickBuyConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopQueryQuickBuyConfigCmd, data)
end

function ServiceSessionShopProxy:RecvServerLimitSellCountCmd(data)
  ShopProxy.Instance:RecvServerLimitSellCountCmd(data)
  self:Notify(ServiceEvent.SessionShopServerLimitSellCountCmd, data)
end

function ServiceSessionShopProxy:RecvQueryShopSoldCountCmd(data)
  ShopProxy.Instance:Server_SetShopSoldCountCmdInfo(data.items)
  self:Notify(ServiceEvent.SessionShopQueryShopSoldCountCmd, data)
end

function ServiceSessionShopProxy:RecvShopDataUpdateCmd(data)
  ShopProxy.Instance:RecvShopDataUpdateCmd(data)
  self:Notify(ServiceEvent.SessionShopShopDataUpdateCmd, data)
end

function ServiceSessionShopProxy:RecvUpdateShopConfigCmd(data)
  ShopProxy.Instance:RecvUpdateShopConfigCmd(data)
  HappyShopProxy.Instance:RecvUpdateShopConfigCmd(data)
  self:Notify(ServiceEvent.SessionShopUpdateShopConfigCmd, data)
end

function ServiceSessionShopProxy:RecvUpdateExchangeShopData(data)
  ExchangeShopProxy.Instance:UpdateExchange(data)
  self:Notify(ServiceEvent.SessionShopUpdateExchangeShopData, data)
end

function ServiceSessionShopProxy:RecvResetExchangeShopDataShopCmd(data)
  ExchangeShopProxy.Instance:HandleResetData(data)
  self:Notify(ServiceEvent.SessionShopResetExchangeShopDataShopCmd, data)
end

function ServiceSessionShopProxy:RecvFreyExchangeShopCmd(data)
  ExchangeShopProxy.Instance:ResetChoose()
  self:Notify(ServiceEvent.SessionShopFreyExchangeShopCmd, data)
end

function ServiceSessionShopProxy:RecvExchangeShopItemCmd(data)
  ExchangeShopProxy.Instance:ResetChoose()
  self:Notify(ServiceEvent.SessionShopExchangeShopItemCmd, data)
end

function ServiceSessionShopAutoProxy:RecvHeadwearShopResetTimeCmd(data)
  helplog("recv--->RecvHeadwearShopResetTimeCmd")
  ShopProxy.Instance:SetNextRefreshTime(data)
  self:Notify(ServiceEvent.SessionShopHeadwearShopResetTimeCmd, data)
end

function ServiceSessionShopProxy:RecvOpenShopTypeShopCmd(data)
  if data.open then
    local shopType = data.shoptype
    HappyShopProxy.Instance:InitShop(nil, 1, shopType)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HappyShop,
      viewdata = {
        onExit = function()
          ServiceSessionShopProxy.Instance:CallOpenShopTypeShopCmd(shopType, false)
        end
      }
    })
  end
  ServiceSessionShopProxy.super.RecvOpenShopTypeShopCmd(self, data)
end
