autoImport("IdleAI_PartnerPerform")
ParallelAIManager = class("ParallelAIManager")

function ParallelAIManager:ctor()
  self.parallelAIs = {}
  self.isStart = false
end

function ParallelAIManager:PushAI(ai)
  self.parallelAIs[#self.parallelAIs + 1] = ai
end

function ParallelAIManager:Update(idleElapsed, time, deltaTime, creature)
  if not self.isStart then
    for i = 1, #self.parallelAIs do
      local ai = self.parallelAIs[i]
      ai:Start(idleElapsed, time, deltaTime, creature)
    end
    self.isStart = true
  end
  for i = 1, #self.parallelAIs do
    local ai = self.parallelAIs[i]
    ai:Update(idleElapsed, time, deltaTime, creature)
  end
end

function ParallelAIManager:Interrupt(eventId, creature, endCall, endCallParam)
  for i = 1, #self.parallelAIs do
    local ai = self.parallelAIs[i]
    ai:Interrupt(eventId, creature, endCall, endCallParam)
  end
end

function ParallelAIManager:Resume(creature)
  for i = 1, #self.parallelAIs do
    local ai = self.parallelAIs[i]
    ai:Resume(creature)
  end
end

function ParallelAIManager:Pause(creature)
  for i = 1, #self.parallelAIs do
    local ai = self.parallelAIs[i]
    ai:Pause(creature)
  end
end

function ParallelAIManager:Clear(idleElapsed, time, deltaTime, creature)
  TableUtility.ArrayClearByDeleter(self.parallelAIs, function(ai)
    ai:Clear(idleElapsed, time, deltaTime, creature)
  end)
  self.isStart = false
end
