AI_CreatureLookAt = class("AI_CreatureLookAt", AI_Creature)

function AI_CreatureLookAt:LookAt(creatureGUID)
  if self.ai_LookAt == nil then
    self.ai_LookAt = IdleAI_LookAt.new()
    self.idleAIManager:PushAI(self.ai_LookAt)
  end
  self.ai_LookAt:Request_Set(creatureGUID)
end
