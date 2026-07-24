AreaTrigger_Coaster = class("AreaTrigger_Coaster")
AreaTrigger_Coaster.UpdateInterval = 0.05
AreaTrigger_Coaster_ClientType = {SnakeCoaster = 100025}

function AreaTrigger_Coaster:ctor()
  self.triggers = {}
  self.nextUpdateTime = 0
  self.triggerEnterCall = {}
  self.triggerEnterCall[AreaTrigger_Coaster_ClientType.SnakeCoaster] = self.Enter_SnakeCoasterCheckpoint
  self.triggerLeaveCall = {}
  self.triggerLeaveCall[AreaTrigger_Coaster_ClientType.SnakeCoaster] = self.Leave_SnakeCoasterCheckpoint
  self.triggerRemoveCall = {}
  self.triggerRemoveCall[AreaTrigger_Coaster_ClientType.SnakeCoaster] = self.Remove_SnakeCoasterCheckpoint
end

function AreaTrigger_Coaster:Launch()
  if self.running then
    return
  end
  self.running = true
end

function AreaTrigger_Coaster:Shutdown()
  if not self.running then
    return
  end
  self.running = false
end

local distanceFunc = VectorUtility.DistanceXZ_Square

function AreaTrigger_Coaster:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + AreaTrigger_Coaster.UpdateInterval
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

function AreaTrigger_Coaster:AddCheck(trigger)
  if self.triggers[trigger.id] == nil then
    self.triggers[trigger.id] = trigger
    trigger.reached = false
  end
end

function AreaTrigger_Coaster:RemoveCheck(id)
  local trigger = self.triggers[id]
  if trigger ~= nil then
    self:_RemoveCall(trigger)
  end
  self.triggers[id] = nil
  return trigger
end

function AreaTrigger_Coaster:EnterArea(trigger)
  if trigger.reached == false then
    trigger.reached = true
    local call = self.triggerEnterCall[trigger.type]
    if call then
      call(self, trigger)
    end
    local proxy = SceneTriggerProxy.Instance
    if proxy ~= nil then
      proxy:RemoveCoaster(trigger.id)
    else
      self:RemoveCheck(trigger.id)
    end
  end
end

function AreaTrigger_Coaster:ExitArea(trigger)
  if trigger.reached == true then
    trigger.reached = false
    local call = self.triggerLeaveCall[trigger.type]
    if call then
      call(self, trigger)
    end
  end
end

function AreaTrigger_Coaster:_RemoveCall(trigger)
  local call = self.triggerRemoveCall[trigger.type]
  if call then
    call(self, trigger)
  end
end

function AreaTrigger_Coaster:Enter_SnakeCoasterCheckpoint(trigger)
  local myself = Game.Myself
  local coaster = myself ~= nil and myself.snakeCoasterMove or nil
  if coaster ~= nil and coaster.IsRunning ~= nil and coaster:IsRunning() then
    coaster:OnCheckPointTrigger(trigger.customData)
  end
end

function AreaTrigger_Coaster:Leave_SnakeCoasterCheckpoint(trigger)
end

function AreaTrigger_Coaster:Remove_SnakeCoasterCheckpoint(trigger)
end
