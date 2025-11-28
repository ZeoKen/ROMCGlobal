NpcAIState_Time = class("NpcAIState_Time", NpcAIState)

function NpcAIState_Time:DoConstruct(asArray, args)
  NpcAIState_Time.super.DoConstruct(self, asArray, args)
end

function NpcAIState_Time:DoDeconstruct()
  NpcAIState_Time.super.DoDeconstruct(self)
end

function NpcAIState_Time:OnEnter()
  NpcAIState_Time.super.OnEnter(self)
  self:SetActiveInteractNpc(true)
end

function NpcAIState_Time:OnExit()
  self:SetActiveInteractNpc(false)
  NpcAIState_Time.super.OnExit(self)
end

function NpcAIState_Time:SetActiveInteractNpc(isActive)
  local data = Table_AICondition[self.id]
  if not data then
    return
  end
  local params = data.Params
  local npcId = params and params.interactNpcId
  if not npcId then
    return
  end
  local interactNpc = Game.InteractNpcManager.interactNpcMap[npcId]
  if interactNpc then
    interactNpc:SetRunningState(isActive)
  end
end
