AI_CMD_Myself_Spin = {}
setmetatable(AI_CMD_Myself_Spin, {
  __index = AI_CMD_Spin
})

function AI_CMD_Myself_Spin:Update(time, deltaTime, creature)
  AI_CMD_Spin.Update(self, time, deltaTime, creature)
end

function AI_CMD_Myself_Spin.ToString()
  return "AI_CMD_Myself_Spin", AI_CMD_Myself_Spin
end
