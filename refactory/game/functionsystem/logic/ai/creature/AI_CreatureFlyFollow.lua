autoImport("IdleAIManager")
AI_CreatureFlyFollow = class("AI_CreatureFlyFollow", AI_Creature)

function AI_CreatureFlyFollow:FlyFollow()
  self.idleAIManager:PushAI_Sort(IdleAI_FlyFollow.new())
end

function AI_CreatureFlyFollow:WalkFollow()
  self.idleAIManager:PushAI_Sort(IdleAI_WalkFollow.new())
end

local idleAIManagerUpdate = IdleAIManager.Update

function AI_CreatureFlyFollow:_Idle(time, deltaTime, creature)
  if not self.idle then
    self.idle = true
    self.idleElapsed = 0
  else
    self.idleElapsed = self.idleElapsed + deltaTime
  end
  idleAIManagerUpdate(self.idleAIManager, self.idleElapsed, time, deltaTime, creature)
  return true
end
