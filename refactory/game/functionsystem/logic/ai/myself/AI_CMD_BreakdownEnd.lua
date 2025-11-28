AI_CMD_BreakdownEnd = {}

function AI_CMD_BreakdownEnd:Construct(args)
  return 0
end

function AI_CMD_BreakdownEnd:Deconstruct()
end

function AI_CMD_BreakdownEnd:Start(time, deltaTime, creature)
  creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
  return false
end

function AI_CMD_BreakdownEnd:End(time, deltaTime, creature)
end

function AI_CMD_BreakdownEnd:Update(time, deltaTime, creature)
end

function AI_CMD_BreakdownEnd:ResetArgs(args)
end

function AI_CMD_BreakdownEnd.ToString()
  return "AI_CMD_BreakdownEnd", AI_CMD_BreakdownEnd
end
