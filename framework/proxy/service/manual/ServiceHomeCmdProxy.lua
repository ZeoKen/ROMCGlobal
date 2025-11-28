autoImport("HomeFun")
autoImport("ServiceHomeCmdAutoProxy")
ServiceHomeCmdProxy = class("ServiceHomeCmdProxy", ServiceHomeCmdAutoProxy)
ServiceHomeCmdProxy.Instance = nil
ServiceHomeCmdProxy.NAME = "ServiceHomeCmdProxy"

function ServiceHomeCmdProxy:ctor(proxyName)
  if ServiceHomeCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceHomeCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceHomeCmdProxy.Instance = self
  end
end

function ServiceHomeCmdProxy:RecvQueryFurnitureDataHomeCmd(data)
  HomeProxy.Instance:HandleQueryFurnitureDatas(data)
  self:Notify(ServiceEvent.HomeCmdQueryFurnitureDataHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvFurnitureUpdateHomeCmd(data)
  HomeProxy.Instance:HandleFurnitureUpdate(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvFurnitureDataUpdateHomeCmd(data)
  HomeProxy.Instance:RecvFurnitureDataUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureDataUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvHouseDataUpdateHomeCmd(data)
  HomeProxy.Instance:RecvHouseDataUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdHouseDataUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvQueryHouseDataHomeCmd(data)
  HomeProxy.Instance:HandleQueryHomeDataHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryHouseDataHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvOptUpdateHomeCmd(data)
  HomeProxy.Instance:HandleOptUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdOptUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvPrintUpdateHomeCmd(data)
  HomeProxy.Instance:HandlePrintUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdPrintUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvFurnitureOperHomeCmd(data)
  HomeProxy.Instance:RecvFurnitureOperHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureOperHomeCmd, data)
end

function ServiceHomeCmdProxy:CallEnterHomeCmd(accid, charid)
  if Game.MapManager:IsPVPMode() or Game.MapManager:IsPveMode_Thanatos() then
    MsgManager.ShowMsgByIDTable(38025)
    return
  end
  ServiceHomeCmdProxy.super.CallEnterHomeCmd(self, accid, charid)
end

function ServiceHomeCmdProxy:RecvBoardItemQueryHomeCmd(data)
  redlog("ServiceHomeCmdProxy:RecvBoardItemQueryHomeCmd")
  MessageBoardProxy.Instance:ClearMessageTipItems()
  MessageBoardProxy.Instance:RecvBoardItemQueryHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdBoardItemQueryHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvBoardItemUpdateHomeCmd(data)
  redlog("ServiceHomeCmdProxy:RecvBoardItemUpdateHomeCmd", #data.updates, #data.dels)
  self:Notify(ServiceEvent.HomeCmdBoardItemUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvBoardMsgUpdateHomeCmd(data)
  redlog("ServiceHomeCmdProxy:RecvBoardMsgUpdateHomeCmd")
  self:Notify(ServiceEvent.HomeCmdBoardMsgUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvEventItemQueryHomeCmd(data)
  redlog("ServiceHomeCmdProxy:RecvEventItemQueryHomeCmd")
  MessageBoardProxy.Instance:RemoveGuestTraceList()
  MessageBoardProxy.Instance:SetTracePageInfo(data)
  MessageBoardProxy.Instance:SetGuestTraceList(data.items)
  self:Notify(ServiceEvent.HomeCmdEventItemQueryHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvQueryWoodRankHomeCmd(data)
  SkadaRankingProxy.Instance:RecvRankingData(data)
  self:Notify(ServiceEvent.HomeCmdQueryWoodRankHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvQueryHouseFurnitureHomeCmd(data)
  HomeProxy.Instance:HandleRecvQueryHouseFurnitureHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryHouseFurnitureHomeCmd, data)
end
