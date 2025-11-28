FunctionAbyssDragon = class("FunctionAbyssDragon")
local GuideEffectPath = "Common/113TaskAperture_map"
local effectPos = LuaVector3.Zero()

function FunctionAbyssDragon.Me()
  if nil == FunctionAbyssDragon.me then
    FunctionAbyssDragon.me = FunctionAbyssDragon.new()
  end
  return FunctionAbyssDragon.me
end

function FunctionAbyssDragon:ctor()
  self.triggers = {}
  self.sceneEffects = {}
  self:InitStateFunc()
end

function FunctionAbyssDragon:InitStateFunc()
  self.state_func = {
    [MatchCCmd_pb.EABYSSROOM_STATE_WAIT] = self.Do_AbyssRoomState_Wait,
    [MatchCCmd_pb.EABYSSROOM_STATE_AVAILABLE] = self.Do_AbyssRoomState_Available
  }
end

function FunctionAbyssDragon:Launch()
  local curMap = Game.MapManager:GetMapID()
  if curMap ~= 154 or self.isRunning then
    return
  end
  redlog("FunctionAbyssDragon:Launch")
  self.isRunning = true
  EventManager.Me():AddEventListener(TriggerEvent.EnterAbyssDragonArea, self.HandleEnterAbyssDragonArea, self)
  EventManager.Me():AddEventListener(TriggerEvent.LeaveAbyssDragonArea, self.HandleLeaveAbyssDragonArea, self)
  EventManager.Me():AddEventListener(TriggerEvent.RemoveAbyssDragonArea, self.HandleRemoveAbyssDragonArea, self)
  EventManager.Me():AddEventListener(ServiceEvent.RaidCmdAbyssDragonOnOffRaidCmd, self.HandleAbyssDragonOnOffRaidCmd, self)
  self:CreateTriggers()
  TimeTickManager.Me():CreateTick(0, 60000, function()
    self:UpdateSceneEffects()
    GameFacade.Instance:sendNotification(PVEEvent.AbyssDragon_UpdateArea)
  end, self, 1000)
end

function FunctionAbyssDragon:Shutdown()
  local curMap = Game.MapManager:GetMapID()
  if curMap ~= 154 or not self.isRunning then
    return
  end
  redlog("FunctionAbyssDragon:Shutdown")
  self.isRunning = false
  EventManager.Me():RemoveEventListener(TriggerEvent.EnterAbyssDragonArea, self.HandleEnterAbyssDragonArea, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.LeaveAbyssDragonArea, self.HandleLeaveAbyssDragonArea, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.RemoveAbyssDragonArea, self.HandleRemoveAbyssDragonArea, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.RaidCmdAbyssDragonOnOffRaidCmd, self.HandleAbyssDragonOnOffRaidCmd, self)
  self:ShutdownTimeline()
  TableUtility.ArrayClearByDeleter(self.triggers, function(id)
    SceneTriggerProxy.Instance:Remove(id)
  end)
  TableUtility.TableClearByDeleter(self.sceneEffects, function(effect)
    effect:Destroy()
  end)
  TimeTickManager.Me():ClearTick(self, 1000)
  GameFacade.Instance:sendNotification(PVEEvent.AbyssDragon_Shutdown)
end

function FunctionAbyssDragon:CreateTriggers()
  local areaRaidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
  if areaRaidInfo then
    for id, info in pairs(areaRaidInfo) do
      local bpID = info.BpPoint
      local bp = Game.MapManager:FindBornPoint(bpID)
      if bp then
        local pos = {
          bp.position[1],
          bp.position[2],
          bp.position[3]
        }
        local trigger = ReusableTable.CreateTable()
        trigger.id = id
        trigger.pos = pos
        trigger.range = info.Range
        trigger.type = AreaTrigger_Common_ClientType.AbyssDragon_Area
        SceneTriggerProxy.Instance:Add(trigger)
        ReusableTable.DestroyTable(trigger)
        self.triggers[#self.triggers + 1] = id
        if info.SceneEffect then
          self:CreateSceneEffect(id, pos, "Common/" .. info.SceneEffect)
          self:CreateSceneEffect("Guide_" .. id, pos, GuideEffectPath)
        end
      end
    end
  end
end

function FunctionAbyssDragon:CreateSceneEffect(id, pos, path)
  if not self.sceneEffects[id] then
    LuaVector3.Better_Set(effectPos, pos[1], pos[2], pos[3])
    local effect = Asset_Effect.PlayAt(path, effectPos)
    effect:SetActive(false)
    self.sceneEffects[id] = effect
  end
end

function FunctionAbyssDragon:UpdateSceneEffects()
  if FunctionAbyssDragon.CheckTimeValid() then
    for id, effect in pairs(self.sceneEffects) do
      if id ~= self.inAreaId then
        effect:SetActive(true)
      end
    end
    if not self.plotRunning then
      self.plotRunning = true
      Game.PlotStoryManager:Launch()
      local areaRaidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
      if areaRaidInfo then
        for id, info in pairs(areaRaidInfo) do
          if info.CutScene then
            self:PlayTimeline(info.CutScene)
          end
        end
      end
    end
  else
    for id, effect in pairs(self.sceneEffects) do
      effect:SetActive(false)
    end
    self:ShutdownTimeline()
  end
end

function FunctionAbyssDragon:PlayTimeline(pqtl_id)
  local ids = {pqtl_id}
  Game.PlotStoryManager:Start_SEQ_PQTLP(ids, nil, nil, nil, nil, nil, nil, nil, nil, function()
    TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
      if SceneProxy.Instance:IsNeedWaitCutScene() then
        SceneProxy.Instance:ClearNeedWaitCutScene()
        GameFacade.Instance:sendNotification(LoadSceneEvent.CloseLoadView)
      end
    end, self)
  end)
end

function FunctionAbyssDragon:ShutdownTimeline()
  Game.PlotStoryManager:Shutdown(nil, true, true)
  self.plotRunning = false
end

function FunctionAbyssDragon:HandleEnterAbyssDragonArea(id)
  self.inAreaId = id
  if FunctionAbyssDragon.CheckTimeValid() then
    self:AskJoinRoom()
  end
end

function FunctionAbyssDragon:HandleLeaveAbyssDragonArea(id)
  self:Do_AbyssRoomState_Stop()
  self.inAreaId = nil
end

function FunctionAbyssDragon:HandleRemoveAbyssDragonArea(id)
  self:Do_AbyssRoomState_Stop()
  self.inAreaId = nil
  TableUtility.ArrayRemove(self.triggers, id)
end

function FunctionAbyssDragon:HandleAbyssDragonOnOffRaidCmd(data)
  self:UpdateSceneEffects()
  if self.inAreaId and FunctionAbyssDragon.CheckTimeValid() then
    self:AskJoinRoom()
  end
end

function FunctionAbyssDragon.CheckTimeValid()
  return AbyssFakeDragonProxy.Instance:GetOnOff()
end

function FunctionAbyssDragon:NotifyJoinRoom(id, server_state)
  if Game.MapManager:IsPVEMode_AbyssDragon() then
    return
  end
  if not id or not server_state then
    return
  end
  local check_option = {state = server_state}
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(id, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, check_option)
end

function FunctionAbyssDragon:AskJoinRoom()
  if not self.inAreaId then
    return
  end
  self:NotifyJoinRoom(self.inAreaId, MatchCCmd_pb.EABYSSROOM_STATE_CHECK)
  local areaRaidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
  if areaRaidInfo then
    local info = areaRaidInfo[self.inAreaId]
    if info then
      local config = Table_Map[info.RaidID]
      MsgManager.ShowMsgByID(43665, config and config.NameZh or "")
    end
  end
end

function FunctionAbyssDragon:Do_AbyssRoomState_Stop()
  if not self.inAreaId then
    return
  end
  local waitChanged = self:Set_Client_Wait(nil)
  self:NotifyJoinRoom(self.inAreaId, MatchCCmd_pb.EABYSSROOM_STATE_STOP)
  if waitChanged then
    MsgManager.CloseConfirmMsgByID(43655)
    MsgManager.ShowMsgByID(43663)
  end
end

function FunctionAbyssDragon:Set_Client_Wait(var)
  if Game.MapManager:IsPVEMode_AbyssDragon() then
    return false
  end
  if self.client_wait == var then
    return false
  end
  self.client_wait = var
  GameFacade.Instance:sendNotification(PVEEvent.AbyssDragon_ClientWait)
  return true
end

function FunctionAbyssDragon:Check_Client_IsWaiting()
  return self.client_wait == true
end

function FunctionAbyssDragon:HandleAbyssRoomState(server_state)
  if not self.inAreaId then
    return
  end
  self.cache_state = server_state
  local func = self.state_func[server_state]
  if func then
    func(self)
  end
end

function FunctionAbyssDragon:NoCheckGo()
  self:Set_Client_Wait(nil)
  self:NotifyJoinRoom(self.inAreaId, MatchCCmd_pb.EABYSSROOM_STATE_NO_CHECK)
end

function FunctionAbyssDragon:Do_AbyssRoomState_Wait()
  self:Set_Client_Wait(true)
  local areaRaidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
  if areaRaidInfo then
    local info = areaRaidInfo[self.inAreaId]
    if info then
      local config = Table_Map[info.RaidID]
      local confirmFunc = function()
        self:NoCheckGo()
      end
      MsgManager.ConfirmMsgByID(43655, confirmFunc, nil, nil, config and config.NameZh or "")
    end
  end
end

function FunctionAbyssDragon:Do_AbyssRoomState_Available()
  self:Set_Client_Wait(nil)
  self:NotifyJoinRoom(self.inAreaId, MatchCCmd_pb.EABYSSROOM_STATE_NO_CHECK)
end
