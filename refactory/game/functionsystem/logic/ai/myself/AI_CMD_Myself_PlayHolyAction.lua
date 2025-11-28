AI_CMD_Myself_PlayHolyAction = {}
setmetatable(AI_CMD_Myself_PlayHolyAction, {
  __index = AI_CMD_PlayAction
})

function AI_CMD_Myself_PlayHolyAction.ToString()
  return "AI_CMD_Myself_PlayHolyAction", AI_CMD_Myself_PlayHolyAction
end
