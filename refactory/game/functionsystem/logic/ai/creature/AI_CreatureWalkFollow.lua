autoImport("IdleAIManager")
AI_CreatureWalkFollow = class("AI_CreatureWalkFollow", AI_Creature)

function AI_CreatureWalkFollow:Construct(creature)
  AI_CreatureWalkFollow.super.Construct(self, creature)
  self.idleAIManager:PushAI(IdleAI_WalkFollow.new())
end

local idleAIManagerUpdate = IdleAIManager.Update

function AI_CreatureWalkFollow:_Idle(time, deltaTime, creature)
  if not self.idle then
    self.idle = true
    self.idleElapsed = 0
  else
    self.idleElapsed = self.idleElapsed + deltaTime
  end
  idleAIManagerUpdate(self.idleAIManager, self.idleElapsed, time, deltaTime, creature)
  return true
end
