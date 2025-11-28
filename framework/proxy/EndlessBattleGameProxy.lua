Camp_Neutral = FuBenCmd_pb.ETEAMPWS_MIN or 0
Camp_Human = FuBenCmd_pb.ETEAMPWS_RED or 1
Camp_Vampire = FuBenCmd_pb.ETEAMPWS_BLUE or 2
EndlessEventCountExceptStatue = 5
autoImport("EndlessBattleOccupyData")
autoImport("EndlessBattleStatueData")
EndlessBattleDebugEnable = false

function EndlessBattleDebug(...)
  if EndlessBattleDebugEnable then
    helplog(...)
  end
end

function EndlessBattleDebugAll(...)
  if EndlessBattleDebugEnable then
    TableUtil.Print(...)
  end
end

EndlessBattleGameProxy = class("EndlessBattleGameProxy", pm.Proxy)
EndlessBattleGameProxy.Instance = nil
EndlessBattleGameProxy.NAME = "EndlessBattleGameProxy"

function EndlessBattleGameProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EndlessBattleGameProxy.NAME
  if EndlessBattleGameProxy.Instance == nil then
    EndlessBattleGameProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function EndlessBattleGameProxy:GetFinalId()
  if not self.final_id then
    self.final_id = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.Final or 7
  end
  return self.final_id
end

function EndlessBattleGameProxy:IsFinalEvent(id)
  return id == self:GetFinalId()
end

function EndlessBattleGameProxy:Init()
  self.state = -1
  self:InitStateCall()
  self:InitOccupyPoint()
  self:InitStatue()
end

function EndlessBattleGameProxy:InitStateCall()
  self.stateCall = {}
  self.stateCall[FuBenCmd_pb.EEBF_FIELD_EVENT] = self.Enter_Pre_Event
  self.stateCall[FuBenCmd_pb.EEBF_FIELD_FINAL] = self.Enter_Final_Event
  self.stateCall[FuBenCmd_pb.EEBF_FIELD_WAITING] = self.Enter_Waiting
end

function EndlessBattleGameProxy:HandleMiscDataUpdate(server_data)
  local id = server_data.next_event_id
  if self:IsFinalEvent(id) then
    EventManager.Me():PassEvent(EndlessBattleFieldEvent.PreLaunchStatue, id)
  end
  self:SetState(server_data.state)
  if self.state == FuBenCmd_pb.EEBF_FIELD_WAITING then
    return
  end
  self.statueData:UpdateScore(server_data.score_human, server_data.score_vampire)
end

function EndlessBattleGameProxy:HandleEventDataUpdate()
  local statue_event = EndlessBattleFieldProxy.Instance:GetStatueEventData()
  if not statue_event then
    return
  end
  self.statueData:UpdateState(StatueNpcState.Active)
  self:UpdateStatueValue(statue_event.humanScore, statue_event.vampireScore)
  self:SetWinner(statue_event.winner)
end

function EndlessBattleGameProxy:SetState(var)
  if self.state == var then
    return
  end
  self.oldState = self.state
  self.state = var
  local stateCall = self.stateCall[var]
  if stateCall then
    stateCall(self)
  end
end

function EndlessBattleGameProxy:Enter_Waiting()
  EndlessBattleDebug("[无尽战场] 进入等待期")
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.EnterWait)
  if self.oldState == FuBenCmd_pb.EEBF_FIELD_FINAL then
    self:EnterCalm()
  else
    FunctionEndlessBattleField.Me():ClearCalmCD()
  end
end

function EndlessBattleGameProxy:EnterCalm()
  EndlessBattleDebug("[无尽战场] 进入冷静期")
  self.statueData:UpdateState(StatueNpcState.Calm)
  local calm_end_time = EndlessBattleFieldProxy.Instance:GetNextEventTime()
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.EnterCalm, calm_end_time)
  EventManager.Me():PassEvent(EndlessBattleFieldEvent.EnterCalm, calm_end_time)
end

function EndlessBattleGameProxy:Enter_Final_Event()
  EndlessBattleDebug("[无尽战场] 进入最终事件")
  self.statueData:UpdateState(StatueNpcState.Active)
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.EnterFinal)
end

function EndlessBattleGameProxy:Enter_Pre_Event()
  EndlessBattleDebug("[无尽战场] 进入事件")
  if self.oldState == FuBenCmd_pb.EEBF_FIELD_WAITING then
    self:Reset()
  end
  self.statueData:UpdateState(StatueNpcState.InActive)
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.EnterEvent)
  FunctionEndlessBattleField.Me():ClearCalmCD()
end

function EndlessBattleGameProxy:Reset(shut_down)
  self.oldState = nil
  self.statueData:Reset()
  self.occupyData:Reset()
  if shut_down then
    self.state = -1
  end
end

function EndlessBattleGameProxy:InitStatue()
  local id = self:GetFinalId()
  self.statueData = EndlessBattleStatueData.new(id)
end

function EndlessBattleGameProxy:UpdateStatueValue(arg1, arg2)
  self.statueData:UpdateValue(arg1, arg2)
  EndlessBattleDebug("[无尽战场] UpdateStatueValue arg1|arg2", arg1, arg2)
end

function EndlessBattleGameProxy:SetWinner(w)
  self.statueData:SetWinner(w)
end

function EndlessBattleGameProxy:GetWinner()
  return self.statueData:GetWinner()
end

function EndlessBattleGameProxy:GetStatueData()
  return self.statueData:GetData()
end

function EndlessBattleGameProxy:GetStatueHP(camp)
  return self.statueData:GetHP(camp)
end

function EndlessBattleGameProxy:GetStatueHeadIcon(camp)
  return self.statueData:GetHeadIcon(camp)
end

function EndlessBattleGameProxy:GetStatueName(camp)
  return self.statueData:GetName(camp)
end

function EndlessBattleGameProxy:GetStatueValue(camp)
  return self.statueData:GetValue(camp)
end

function EndlessBattleGameProxy:GetStatueScore(camp)
  return self.statueData:GetValue(camp)
end

function EndlessBattleGameProxy:InitOccupyPoint()
  self.occupyData = EndlessBattleOccupyData.new()
end

function EndlessBattleGameProxy:SyncOccupyPointData(data)
  if not data then
    return
  end
  self.occupyData:UpdatePoints(data.update_datas, data.del_points)
end

function EndlessBattleGameProxy:GetPointData(id)
  return self.occupyData:GetPoint(id)
end

function EndlessBattleGameProxy:TryTraceEvent(event_id)
  if not event_id then
    return
  end
  local event_static = Table_EndlessBattleFieldEvent[event_id]
  if not event_static then
    return
  end
  local center = event_static.AreaCenter
  local cmdArgs, cmd = ReusableTable.CreateTable()
  cmdArgs.targetMapID = SceneProxy.Instance:GetCurMapID()
  cmdArgs.targetPos = LuaGeometry.GetTempVector3(center[1] or 0, center[2] or 0, center[3] or 0)
  cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  Game.Myself:Client_SetMissionCommand(cmd)
  ReusableTable.DestroyAndClearTable(cmdArgs)
end
