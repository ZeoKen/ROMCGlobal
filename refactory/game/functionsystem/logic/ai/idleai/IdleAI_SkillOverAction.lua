IdleAI_SkillOverAction = class("IdleAI_SkillOverAction")
local OverInterval = 2

function IdleAI_SkillOverAction:ctor()
  self.overTime = 0
  self.priority = 6
end

function IdleAI_SkillOverAction:Clear(idleElapsed, time, deltaTime, creature)
end

function IdleAI_SkillOverAction:Prepare(idleElapsed, time, deltaTime, creature)
  if self.endAction == nil then
    return false
  end
  return time >= self.overTime
end

function IdleAI_SkillOverAction:Start(idleElapsed, time, deltaTime, creature)
  creature:Client_PlayAction(self.endAction)
end

function IdleAI_SkillOverAction:End(idleElapsed, time, deltaTime, creature)
  self.overTime = 0
  self.endAction = nil
end

function IdleAI_SkillOverAction:Update(idleElapsed, time, deltaTime, creature)
  return false
end

function IdleAI_SkillOverAction:Request_Set(endAction)
  self.overTime = Time.time + OverInterval
  self.endAction = endAction
end
