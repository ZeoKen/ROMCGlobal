AI_CMD_PlaceTo = {}

function AI_CMD_PlaceTo:ResetArgs(args)
  local p = args[2]
  LuaVector3.Better_Set(self.args[1], p[1], p[2], p[3])
  self.args[2] = args[3]
end

function AI_CMD_PlaceTo:Construct(args)
  self.args[1] = LuaVector3.Better_Clone(args[2])
  self.args[2] = args[3]
  return 2
end

function AI_CMD_PlaceTo:Deconstruct()
  LuaVector3.Destroy(self.args[1])
  self.args[1] = nil
end

function AI_CMD_PlaceTo:Start(time, deltaTime, creature)
  if self.args[2] then
    creature.logicTransform:PlaceTo(self.args[1])
  else
    creature.logicTransform:NavMeshPlaceTo(self.args[1])
  end
  return false
end

function AI_CMD_PlaceTo:End(time, deltaTime, creature)
end

function AI_CMD_PlaceTo:Update(time, deltaTime, creature)
end

function AI_CMD_PlaceTo.ToString()
  return "AI_CMD_PlaceTo", AI_CMD_PlaceTo
end
