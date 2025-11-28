NpcAIState_InteractNpc = class("NpcAIState_InteractNpc", NpcAIState)

function NpcAIState_InteractNpc:DoConstruct(asArray, args)
  self.interactNpcId = args[4]
  NpcAIState_InteractNpc.super.DoConstruct(self, asArray, args)
end

function NpcAIState_InteractNpc:DoDeconstruct()
  NpcAIState_InteractNpc.super.DoDeconstruct(self)
  self.interactNpcId = nil
  self.isEntered = nil
end

function NpcAIState_InteractNpc:OnEnter()
  if not self.ai then
    return
  end
  local data = Table_AICondition[self.id]
  if not data then
    return
  end
  local interactNpc = Game.InteractNpcManager.interactNpcMap[self.interactNpcId]
  if interactNpc then
    local eventId = data.EventId
    local eventData = Table_AIEvent[eventId]
    local slotId = eventData.SlotId
    if interactNpc:GetCharid(slotId) == self.ai.id then
      Game.InteractNpcManager:DelMountInter(self.interactNpcId, self.ai.id)
      NpcAIState_InteractNpc.super.OnEnter(self)
      self.isEntered = true
      self.ai:RemoveTriggerConditionCheck(self.id, self.targetId)
    end
  end
end

function NpcAIState_InteractNpc:OnUpdate()
  if not self.isEntered then
    self:OnEnter()
  end
end
