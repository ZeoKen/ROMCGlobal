NpcAIState_Follow = class("NpcAIState_Follow", NpcAIState)

function NpcAIState_Follow:DoDeconstruct()
  NpcAIState_Follow.super.DoDeconstruct(self)
  self.range = nil
end

function NpcAIState_Follow:OnEnter()
  local data = Table_AICondition[self.id]
  local params = data.Params
  self.range = params and params.range
  self.randomPos = self:RandomPosInRange(self.range)
  NpcAIState_Follow.super.OnEnter(self)
end

function NpcAIState_Follow:OnUpdate(time, deltaTime)
  if not self.isPlaying then
    return
  end
  local creature = NSceneNpcProxy.Instance:Find(self.ai.id)
  if not creature then
    return
  end
  local target = NSceneUserProxy.Instance:Find(self.targetId)
  if not target then
    self:Dispose()
  else
    local sqrDis = self.range * self.range
    if sqrDis < LuaVector3.Distance_Square(target:GetPosition(), creature:GetPosition()) then
      self:Dispose()
    end
  end
end
