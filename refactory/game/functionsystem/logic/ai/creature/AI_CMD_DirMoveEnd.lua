AI_CMD_DirMoveEnd = {}

function AI_CMD_DirMoveEnd:Construct(args)
  self.args[1] = args[2]
  return 1
end

function AI_CMD_DirMoveEnd:Deconstruct()
  self.args[1] = nil
end

function AI_CMD_DirMoveEnd:Start(time, deltaTime, creature)
  creature:Client_SetIsDirMoving(false)
  creature.ai:SetIdleAction(self.args[1])
  return false
end

function AI_CMD_DirMoveEnd:End(time, deltaTime, creature)
end

function AI_CMD_DirMoveEnd:Update(time, deltaTime, creature)
end

function AI_CMD_DirMoveEnd.ToString()
  return "AI_CMD_DirMoveEnd", AI_CMD_DirMoveEnd
end
