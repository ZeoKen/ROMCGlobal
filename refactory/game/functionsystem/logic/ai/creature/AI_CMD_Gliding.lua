AI_CMD_Gliding = {}

function AI_CMD_Gliding:Construct(args)
  return 0
end

function AI_CMD_Gliding:Deconstruct()
end

function AI_CMD_Gliding:Start(time, deltaTime, creature)
  local skatingMove = creature.skatingMove
  if skatingMove == nil or not skatingMove:IsGliding() then
    return false
  end
  return true
end

function AI_CMD_Gliding:Update(time, deltaTime, creature)
  local skatingMove = creature.skatingMove
  if skatingMove == nil or not skatingMove:IsGliding() then
    self:End(time, deltaTime, creature)
    return
  end
end

function AI_CMD_Gliding:End(time, deltaTime, creature)
  local skatingMove = creature.skatingMove
  if skatingMove == nil then
    return
  end
  local ai = creature.ai
  local nextCmd = ai and (ai.nextCmd or ai.nextCmd1)
  local nextClass = nextCmd and nextCmd.AIClass
  if nextClass == AI_CMD_Myself_DirMove or nextClass == AI_CMD_Myself_MoveTo or nextClass == AI_CMD_DirMove or nextClass == AI_CMD_MoveTo then
    skatingMove:ExitGlideHandoff()
  else
    skatingMove:InterruptGlide()
  end
end

function AI_CMD_Gliding.ToString()
  return "AI_CMD_Gliding", AI_CMD_Gliding
end
