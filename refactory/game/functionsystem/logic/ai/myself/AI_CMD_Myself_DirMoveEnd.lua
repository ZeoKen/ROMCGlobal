AI_CMD_Myself_DirMoveEnd = {}

function AI_CMD_Myself_DirMoveEnd:Construct(args)
  self.args[1] = args[2]
  return 1
end

function AI_CMD_Myself_DirMoveEnd:Deconstruct()
  self.args[1] = nil
end

function AI_CMD_Myself_DirMoveEnd:Start(time, deltaTime, creature)
  creature:Client_SetIsDirMoving(false)
  creature.ai:SetIdleAction(self.args[1])
  return false
end

function AI_CMD_Myself_DirMoveEnd:End(time, deltaTime, creature)
end

function AI_CMD_Myself_DirMoveEnd:Update(time, deltaTime, creature)
end

function AI_CMD_Myself_DirMoveEnd.ToString()
  return "AI_CMD_Myself_DirMoveEnd", AI_CMD_Myself_DirMoveEnd
end
