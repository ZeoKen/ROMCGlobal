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
  HomeProxy.__RealInstance:HandleQueryHomeDataHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryHouseDataHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvOptUpdateHomeCmd(data)
  HomeProxy.__RealInstance:HandleOptUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdOptUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvPrintUpdateHomeCmd(data)
  local action = data.action
  if action == HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_ALL or action == HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_SOCIAL or action == HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_HOT then
    HomeBlueprintProxy.Instance:UpdateRecommendList(data)
  elseif action == HomeCmd_pb.EPRINTACTION_QUERY_SELF_COLLECTION then
    HomeBlueprintProxy.Instance:UpdateCollectionList(data)
  elseif action == HomeCmd_pb.EPRINTACTION_QUERY_SELF then
    HomeBlueprintProxy.Instance:UpdateMyList(data)
  elseif action == HomeCmd_pb.EPRINTACTION_QUERY then
    HomeBlueprintProxy.Instance:UpdateOfficialList(data)
  elseif action == HomeCmd_pb.EPRINTACTION_PRAISE or action == HomeCmd_pb.EPRINTACTION_UNPRAISE or action == HomeCmd_pb.EPRINTACTION_SAVE or action == HomeCmd_pb.EPRINTACTION_COLLECT_IN or action == HomeCmd_pb.EPRINTACTION_COLLECT_OUT then
    HomeBlueprintProxy.Instance:UpdateItemAction(data)
  elseif action == HomeCmd_pb.EPRINTACTION_DELETE then
    HomeBlueprintProxy.Instance:UpdateItemDelete(data)
  end
  self:Notify(ServiceEvent.HomeCmdPrintUpdateHomeCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.HomeCmdPrintUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvFurnitureOperHomeCmd(data)
  HomeProxy.Instance:RecvFurnitureOperHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureOperHomeCmd, data)
end

function ServiceHomeCmdProxy:CallEnterHomeCmd(accid, charid, houseType)
  if Game.MapManager:IsPVPMode() or Game.MapManager:IsPveMode_Thanatos() then
    MsgManager.ShowMsgByIDTable(38025)
    return
  end
  ServiceHomeCmdProxy.super.CallEnterHomeCmd(self, accid, charid, houseType)
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
  HomeProxy.__RealInstance:HandleRecvQueryHouseFurnitureHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryHouseFurnitureHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvQuerySnowHouseDataHomeCmd(data)
  SnowRealmProxy.Instance:HandleQuerySnowHouseDataHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQuerySnowHouseDataHomeCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.HomeCmdQuerySnowHouseDataHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvQueryRecommendHomeCmd(data)
  redlog("ServiceHomeCmdProxy:RecvQueryRecommendHomeCmd")
  HomeRecommendProxy.Instance:UpdateRecommendList(data)
  self:Notify(ServiceEvent.HomeCmdQueryRecommendHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvSnowHouseDataUpdateHomeCmd(data)
  SnowRealmProxy.Instance:RecvSnowHouseDataUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdSnowHouseDataUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvSnowFurnitureUpdateHomeCmd(data)
  SnowRealmProxy.Instance:RecvSnowFurnitureUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdSnowFurnitureUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvSnowFurnitureDataUpdateHomeCmd(data)
  SnowRealmProxy.Instance:RecvSnowFurnitureDataUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdSnowFurnitureDataUpdateHomeCmd, data)
end

function ServiceHomeCmdProxy:RecvSnowFurnitureOperHomeCmd(data)
  SnowRealmProxy.Instance:RecvSnowFurnitureOperHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdSnowFurnitureOperHomeCmd, data)
end

ServiceEvent.HomeCmdQueryBlueprintFurnitureHomeCmd = "ServiceEvent_HomeCmdQueryBlueprintFurnitureHomeCmd"
