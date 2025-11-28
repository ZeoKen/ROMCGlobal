NpcAIState_Wait = class("NpcAIState_Wait", NpcAIState)

function NpcAIState_Wait:DoConstruct(asArray, args)
  self.interactNpcId = args[4]
  self.exitEventId = args[5]
  NpcAIState_Wait.super.DoConstruct(self, asArray, args)
end

function NpcAIState_Wait:DoDeconstruct()
  NpcAIState_Wait.super.DoDeconstruct(self)
  self.interactNpcId = nil
end

function NpcAIState_Wait:OnEnter()
  local data = Table_AICondition[self.id]
  if not data then
    return
  end
  local params = data.Params
  local range = params and params.range
  self.randomPos = self:RandomPosInRange(range, 0, 0)
  self.isLoop = true
  NpcAIState_Wait.super.OnEnter(self)
end

function NpcAIState_Wait:OnExit()
  if not self.ai then
    return
  end
  local data = Table_AICondition[self.id]
  if not data then
    return
  end
  if self.exitEventId then
    local interval = self.ai:RandomEventInterval(self.exitEventId)
    self.ai:CompareEvent(self.exitEventId, interval)
  end
  ReusableObject.Destroy(self)
end
