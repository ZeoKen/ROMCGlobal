AreaTrigger_Common = class("AreaTrigger_Common")
AreaTrigger_Common.UpdateInterval = 0.5
AreaTrigger_Common_ClientType = {
  CatchPet = 11,
  GvgDroiyan_FightForArea = 100001,
  Othello_Checkpoint = 100002,
  TwelvePVP_ShopTrigger = 100003,
  Raid_AreaCheck = 1000004,
  MetalGvg_PointArea = 100004,
  AI_AreaCheck = 100005,
  AI_AwayCheck = 100006,
  InteractLocal_ValidArea = 100007,
  EndlessBattleField_EventArea = 100008,
  EndlessBattleField_Occupy = 100009,
  AybssLake_BattlePoint = 100020
}

function AreaTrigger_Common:ctor()
  self.triggers = {}
  self.nextUpdateTime = 0
  self.triggerEnterCall = {}
  self.triggerEnterCall[SceneMap_pb.EACTTYPE_PURIFY] = self.EnterPurify
  self.triggerEnterCall[SceneMap_pb.EACTTYPE_SEAL] = self.EnterSeal
  self.triggerEnterCall[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.EnterSceneEvent
  self.triggerEnterCall[AreaTrigger_Common_ClientType.CatchPet] = self.EnterCatchPet
  self.triggerEnterCall[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.Enter_GDFightForArea
  self.triggerEnterCall[AreaTrigger_Common_ClientType.Othello_Checkpoint] = self.Enter_OthelloCheckpoint
  self.triggerEnterCall[AreaTrigger_Common_ClientType.TwelvePVP_ShopTrigger] = self.Enter_TwelvePVPShopTrigger
  self.triggerEnterCall[AreaTrigger_Common_ClientType.Raid_AreaCheck] = self.Enter_RaidCheckArea
  self.triggerEnterCall[AreaTrigger_Common_ClientType.MetalGvg_PointArea] = self.Enter_MetalGvgPointArea
  self.triggerEnterCall[AreaTrigger_Common_ClientType.EndlessBattleField_Occupy] = self.Enter_EndlessBattleOccupyArea
  self.triggerEnterCall[AreaTrigger_Common_ClientType.AI_AreaCheck] = self.Enter_AIAreaCheck
  self.triggerEnterCall[AreaTrigger_Common_ClientType.InteractLocal_ValidArea] = self.Enter_InteractLocalValidArea
  self.triggerEnterCall[AreaTrigger_Common_ClientType.EndlessBattleField_EventArea] = self.Enter_EndlessBattleFieldEventArea
  self.triggerEnterCall[AreaTrigger_Common_ClientType.AybssLake_BattlePoint] = self.Enter_AybssLakeBattleArea
  self.triggerLeaveCall = {}
  self.triggerLeaveCall[SceneMap_pb.EACTTYPE_PURIFY] = self.LeavePurify
  self.triggerLeaveCall[SceneMap_pb.EACTTYPE_SEAL] = self.LeaveSeal
  self.triggerLeaveCall[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.LeaveSceneEvent
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.CatchPet] = self.LeaveCatchPet
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.Leave_GDFightForArea
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.Othello_Checkpoint] = self.Leave_OthelloCheckpoint
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.TwelvePVP_ShopTrigger] = self.Remove_TwelvePVPShopTrigger
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.Raid_AreaCheck] = self.Leave_RaidCheckArea
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.MetalGvg_PointArea] = self.Leave_MetalGvgPointArea
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.EndlessBattleField_Occupy] = self.Leave_EndlessBattleOccupyArea
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.AI_AreaCheck] = self.Leave_AIAreaCheck
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.AI_AwayCheck] = self.Leave_AIAwayCheck
  self.triggerEnterCall[AreaTrigger_Common_ClientType.InteractLocal_ValidArea] = self.Leave_InteractLocalValidArea
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.EndlessBattleField_EventArea] = self.Leave_EndlessBattleFieldEventArea
  self.triggerLeaveCall[AreaTrigger_Common_ClientType.AybssLake_BattlePoint] = self.Leave_AybssLakeBattleArea
  self.triggerRemoveCall = {}
  self.triggerRemoveCall[SceneMap_pb.EACTTYPE_PURIFY] = self.LeavePurify
  self.triggerRemoveCall[SceneMap_pb.EACTTYPE_SEAL] = self.RemoveSeal
  self.triggerRemoveCall[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.RemoveSceneEvent
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.CatchPet] = self.RemoveCatchPet
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.Remove_GDFightForArea
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.Othello_Checkpoint] = self.Remove_OthelloCheckpoint
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.TwelvePVP_ShopTrigger] = self.Remove_TwelvePVPShopTrigger
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.EndlessBattleField_Occupy] = self.RemoveEndlessBattleOccupyArea
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.MetalGvg_PointArea] = self.Remove_MetalGvgPointArea
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.EndlessBattleField_EventArea] = self.Remove_EndlessBattleFieldEventArea
  self.triggerRemoveCall[AreaTrigger_Common_ClientType.AybssLake_BattlePoint] = self.Remove_AybssLakeBattleArea
end

function AreaTrigger_Common:Launch()
  if self.running then
    return
  end
  self.running = true
end

function AreaTrigger_Common:Shutdown()
  if not self.running then
    return
  end
  self.running = false
end

local distanceFunc = VectorUtility.DistanceXZ_Square

function AreaTrigger_Common:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + AreaTrigger_Common.UpdateInterval
  local myselfPosition = Game.Myself:GetPosition()
  for id, trigger in pairs(self.triggers) do
    if trigger.distanceCheck then
      if trigger.distanceCheck(trigger, myselfPosition, trigger.pos) then
        self:EnterArea(trigger)
      else
        self:ExitArea(trigger)
      end
    elseif distanceFunc(myselfPosition, trigger.pos) <= trigger.reachDis * trigger.reachDis then
      self:EnterArea(trigger)
    else
      self:ExitArea(trigger)
    end
  end
end

function AreaTrigger_Common:EnterPurify(trigger)
  QuickUseProxy.Instance:AddTriggerData(trigger)
end

function AreaTrigger_Common:EnterSeal(trigger)
  FunctionRepairSeal.Me():EnterSealArea()
end

function AreaTrigger_Common:EnterSceneEvent(trigger)
  helplog("Enter Scene Event!!!", trigger.id)
  ServiceUserEventProxy.Instance:CallInOutActEventCmd(trigger.id, true)
end

function AreaTrigger_Common:EnterCatchPet(trigger)
end

function AreaTrigger_Common:LeavePurify(trigger)
  QuickUseProxy.Instance:RemoveTrigger(trigger)
end

function AreaTrigger_Common:LeaveSeal(trigger)
  FunctionRepairSeal.Me():ExitSealArea()
end

function AreaTrigger_Common:LeaveCatchPet(trigger)
  MsgManager.ShowMsgByIDTable(9008)
end

function AreaTrigger_Common:LeaveSceneEvent(trigger)
  helplog("Leave Scene Event!!!", trigger.id)
  ServiceUserEventProxy.Instance:CallInOutActEventCmd(trigger.id, false)
end

function AreaTrigger_Common:RemoveSeal(trigger)
  FunctionRepairSeal.Me():ExitSealArea(true)
end

function AreaTrigger_Common:RemoveSceneEvent(trigger)
end

function AreaTrigger_Common:EnterArea(trigger)
  if trigger.reached == false then
    trigger.reached = true
    local call = self.triggerEnterCall[trigger.type]
    if call then
      call(self, trigger)
    end
  end
end

function AreaTrigger_Common:ExitArea(trigger)
  if trigger.reached == true then
    trigger.reached = false
    local call = self.triggerLeaveCall[trigger.type]
    if call then
      call(self, trigger)
    end
  end
end

function AreaTrigger_Common:_RemoveCall(trigger)
  local call = self.triggerRemoveCall[trigger.type]
  if call then
    call(self, trigger)
  end
end

function AreaTrigger_Common:RemoveCatchPet(trigger)
end

function AreaTrigger_Common:AddCheck(trigger)
  if self.triggers[trigger.id] == nil then
    self.triggers[trigger.id] = trigger
    trigger.reached = false
  end
end

function AreaTrigger_Common:RemoveCheck(id)
  local trigger = self.triggers[id]
  if trigger ~= nil then
    self:_RemoveCall(trigger)
  end
  self.triggers[id] = nil
  return trigger
end

function AreaTrigger_Common:Enter_GDFightForArea(trigger)
  GameFacade.Instance:sendNotification(TriggerEvent.Enter_GDFightForArea, trigger.id)
end

function AreaTrigger_Common:Leave_GDFightForArea(trigger)
  GameFacade.Instance:sendNotification(TriggerEvent.Leave_GDFightForArea, trigger.id)
end

function AreaTrigger_Common:Remove_GDFightForArea(id)
  GameFacade.Instance:sendNotification(TriggerEvent.Remove_GDFightForArea, id)
end

function AreaTrigger_Common:Enter_OthelloCheckpoint(trigger)
  local proxy = PvpObserveProxy.Instance
  if proxy:IsRunning() and not proxy:IsAttaching() then
    return
  end
  GameFacade.Instance:sendNotification(TriggerEvent.Enter_OthelloCheckpoint, trigger.id)
end

function AreaTrigger_Common:Leave_OthelloCheckpoint(trigger)
  GameFacade.Instance:sendNotification(TriggerEvent.Leave_OthelloCheckpoint, trigger.id)
end

function AreaTrigger_Common:Remove_OthelloCheckpoint(id)
  GameFacade.Instance:sendNotification(TriggerEvent.Remove_OthelloCheckpoint, id)
end

function AreaTrigger_Common:Enter_TwelvePVPShopTrigger(trigger)
  local myCamp = MyselfProxy.Instance:GetTwelvePVPCamp()
  if myCamp == trigger.id and not PvpObserveProxy.Instance:IsRunning() then
    QuickUseProxy.Instance:AddTwelveTriggerData(trigger, myCamp)
  end
end

function AreaTrigger_Common:Remove_TwelvePVPShopTrigger(trigger)
  local myCamp = MyselfProxy.Instance:GetTwelvePVPCamp()
  if myCamp == trigger.id then
    QuickUseProxy.Instance:RemoveTwelveTriggerData(trigger)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end
end

function AreaTrigger_Common:Enter_RaidCheckArea(trigger)
  if trigger.IO and trigger.IO == 1 then
    redlog("进入副本判定区域", trigger.id)
    ServiceQuestProxy.Instance:CallQuestAreaAction(trigger.id)
  end
end

function AreaTrigger_Common:Leave_RaidCheckArea(trigger)
  if trigger.IO and trigger.IO == 2 then
    redlog("离开副本判定区域", trigger.id)
    ServiceQuestProxy.Instance:CallQuestAreaAction(trigger.id)
  end
end

function AreaTrigger_Common:Refresh_RaidCheckArea()
  for id, trigger in pairs(self.triggers) do
    if trigger.type == AreaTrigger_Common_ClientType.Raid_AreaCheck then
      trigger.reached = not trigger.reached
    end
  end
end

function AreaTrigger_Common:Enter_MetalGvgPointArea(trigger)
  GvgProxy.Instance:SetCurrentPointID(trigger.id)
end

function AreaTrigger_Common:Leave_MetalGvgPointArea(trigger)
  GvgProxy.Instance:RemoveCurrentPointID()
end

function AreaTrigger_Common:Remove_MetalGvgPointArea(id)
  GvgProxy.Instance:RemoveCurrentPointID()
end

function AreaTrigger_Common:Enter_AIAreaCheck(trigger)
  EventManager.Me():PassEvent(TriggerEvent.Enter_AIArea, trigger.id)
end

function AreaTrigger_Common:Leave_AIAreaCheck(trigger)
  EventManager.Me():PassEvent(TriggerEvent.Leave_AIArea, trigger.id)
end

function AreaTrigger_Common:Leave_AIAwayCheck(trigger)
  EventManager.Me():PassEvent(TriggerEvent.Leave_AIAway, trigger.id)
end

function AreaTrigger_Common:Enter_InteractLocalValidArea(args)
end

function AreaTrigger_Common:Leave_InteractLocalValidArea(args)
end

function AreaTrigger_Common:Enter_EndlessBattleFieldEventArea(trigger)
  EndlessBattleDebug("[无尽战场] 进去区域抛事件 unique_id: ", trigger.id)
  EventManager.Me():PassEvent(TriggerEvent.Enter_EndlessBattleFieldEventArea, trigger.id)
  GameFacade.Instance:sendNotification(TriggerEvent.Enter_EndlessBattleFieldEventArea, trigger.id)
end

function AreaTrigger_Common:Leave_EndlessBattleFieldEventArea(trigger)
  EndlessBattleDebug("[无尽战场] 离开区域抛事件 unique_id: ", trigger.id)
  EventManager.Me():PassEvent(TriggerEvent.Leave_EndlessBattleFieldEventArea, trigger.id)
  GameFacade.Instance:sendNotification(TriggerEvent.Leave_EndlessBattleFieldEventArea, trigger.id)
end

function AreaTrigger_Common:Remove_EndlessBattleFieldEventArea(trigger)
  EndlessBattleDebug("[无尽战场] 移除区域抛事件 unique_id: ", trigger.id)
  EventManager.Me():PassEvent(TriggerEvent.Remove_EndlessBattleFieldEventArea, trigger.id)
  GameFacade.Instance:sendNotification(TriggerEvent.Remove_EndlessBattleFieldEventArea, trigger.id)
end

function AreaTrigger_Common:Enter_EndlessBattleOccupyArea(trigger)
  GameFacade.Instance:sendNotification(TriggerEvent.Enter_EndlessBattle_OccupyArea, trigger.id)
end

function AreaTrigger_Common:Leave_EndlessBattleOccupyArea(trigger)
  GameFacade.Instance:sendNotification(TriggerEvent.Leave_EndlessBattle_OccupyArea, trigger.id)
end

function AreaTrigger_Common:RemoveEndlessBattleOccupyArea(trigger)
  GameFacade.Instance:sendNotification(TriggerEvent.Remove_EndlessBattle_OccupyArea, trigger.id)
end

function AreaTrigger_Common:Enter_AybssLakeBattleArea(trigger)
  redlog("Enter_AybssLakeBattleArea", trigger.id)
  ServiceMapProxy.Instance:CallAbyssAreaChangeNotifyCmd(trigger.id)
  AbyssLakeProxy.Instance:Enter_AybssLakeBattleArea(trigger.id)
  GameFacade.Instance:sendNotification(TriggerEvent.EnterAybssLakeBattleArea, trigger.id)
end

function AreaTrigger_Common:Leave_AybssLakeBattleArea(trigger)
  redlog("Leave_AybssLakeBattleArea", trigger.id)
  ServiceMapProxy.Instance:CallAbyssAreaChangeNotifyCmd(0)
  AbyssLakeProxy.Instance:Leave_AybssLakeBattleArea()
  GameFacade.Instance:sendNotification(TriggerEvent.LeaveAybssLakeBattleArea, trigger.id)
end

function AreaTrigger_Common:Remove_AybssLakeBattleArea(trigger)
  redlog("Remove_AybssLakeBattleArea", trigger.id)
  AbyssLakeProxy.Instance:Leave_AybssLakeBattleArea()
  GameFacade.Instance:sendNotification(TriggerEvent.RemoveAybssLakeBattleArea, trigger.id)
end
