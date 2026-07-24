AI_CMD_CoasterMoveEnd = {}

function AI_CMD_CoasterMoveEnd:Construct(args)
  self.args[1] = args[2]
  return 1
end

function AI_CMD_CoasterMoveEnd:Deconstruct()
  self.args[1] = nil
end

function AI_CMD_CoasterMoveEnd:Start(time, deltaTime, creature)
  creature:Client_SetIsDirMoving(false)
  creature.ai:SetIdleAction(self.args[1])
  return false
end

function AI_CMD_CoasterMoveEnd:End(time, deltaTime, creature)
end

function AI_CMD_CoasterMoveEnd:Update(time, deltaTime, creature)
end

function AI_CMD_CoasterMoveEnd.ToString()
  return "AI_CMD_CoasterMoveEnd", AI_CMD_CoasterMoveEnd
end
