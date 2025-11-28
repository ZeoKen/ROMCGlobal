AI_CMD_SpinEnd = {}

function AI_CMD_SpinEnd:Construct(args)
  return 0
end

function AI_CMD_SpinEnd:Deconstruct()
end

function AI_CMD_SpinEnd:Start(time, deltaTime, creature)
  creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
  return false
end

function AI_CMD_SpinEnd:End(time, deltaTime, creature)
end

function AI_CMD_SpinEnd:Update(time, deltaTime, creature)
end

function AI_CMD_SpinEnd.ToString()
  return "AI_CMD_SpinEnd", AI_CMD_SpinEnd
end

function AI_CMD_SpinEnd:ResetArgs(args)
end
