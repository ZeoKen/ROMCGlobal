AreaTrigger_Npc = class("AreaTrigger_Npc")
AreaTrigger_Npc_ClientType = 200000
local Distance_Square = LuaVector3.Distance_Square

function AreaTrigger_Npc:ctor()
  self.triggers = {}
end

function AreaTrigger_Npc:Launch()
  if self.isrunning then
    return
  end
  self.isrunning = true
end

function AreaTrigger_Npc:Shutdown()
  if not self.isrunning then
    return
  end
  self.isrunning = false
end

function AreaTrigger_Npc:Update(time, deltaTime)
  if not self.isrunning then
    return
  end
  for _, trigger in pairs(self.triggers) do
    local npcId = trigger.npcId
    local uniqueId = trigger.uniqueId
    local range = trigger.range
    if range then
      local myPos = Game.Myself:GetPosition()
      local npcs = NSceneNpcProxy.Instance:FindNpcs(npcId)
      for i = 1, #npcs do
        local npc = npcs[i]
        if npc.data.uniqueid == uniqueId then
          if Distance_Square(myPos, npc:GetPosition()) <= range * range then
            self:EnterArea(trigger.id)
            break
          end
          self:LeaveArea(trigger.id)
          break
        end
      end
    end
  end
end

function AreaTrigger_Npc:AddCheck(trigger)
  if not self.triggers[trigger.id] then
    self.triggers[trigger.id] = trigger
    trigger.reached = false
  end
end

function AreaTrigger_Npc:RemoveCheck(id)
  local trigger = self.triggers[id]
  self.triggers[id] = nil
  return trigger
end

function AreaTrigger_Npc:EnterArea(triggerId)
  local trigger = self.triggers[triggerId]
  if trigger and not trigger.reached then
    EventManager.Me():PassEvent(TriggerEvent.Enter_AIArea, triggerId)
    trigger.reached = true
  end
end

function AreaTrigger_Npc:LeaveArea(triggerId)
  local trigger = self.triggers[triggerId]
  if trigger and trigger.reached then
    EventManager.Me():PassEvent(TriggerEvent.Leave_AIArea, triggerId)
    trigger.reached = false
  end
end
