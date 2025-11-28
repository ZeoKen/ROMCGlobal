AI_CMD_Myself_SpinEnd = {}
setmetatable(AI_CMD_Myself_SpinEnd, {
  __index = AI_CMD_SpinEnd
})

function AI_CMD_Myself_SpinEnd:Update(time, deltaTime, creature)
  AI_CMD_SpinEnd.Update(self, time, deltaTime, creature)
end

function AI_CMD_Myself_SpinEnd.ToString()
  return "AI_CMD_Myself_SpinEnd", AI_CMD_Myself_SpinEnd
end
