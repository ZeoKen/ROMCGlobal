AI_CMD_DirMoveHelper = {}
local tempVector3 = LuaVector3.Zero()

function AI_CMD_DirMoveHelper:Step(time, deltaTime, creature, dir, stepTarget, rotateDir)
  local p = creature:GetPosition()
  local ret, _ = NavMeshUtility.Better_RaycastDirection(p, stepTarget, dir)
  if not ret then
    ret, _ = NavMeshUtility.Better_SampleDirection(p, stepTarget, dir)
  end
  if not ret then
    NavMeshUtility.Better_Sample(p, tempVector3)
    creature.logicTransform:PlaceTo(tempVector3)
    if Game.MapManager:NoOverStep() then
      return
    end
  end
  LuaVector3.Better_Add(p, dir, rotateDir)
  creature.logicTransform:MoveTo(stepTarget, rotateDir)
end

AI_CMD_DirMove = {}

function AI_CMD_DirMove:Construct(args)
  self.args[1] = LuaVector3.Better_Clone(args[2])
  self.args[2] = args[3]
  self.args[3] = LuaVector3.Zero()
  self.args[4] = LuaVector3.Zero()
  self.args[5] = args[4]
  return 5
end

function AI_CMD_DirMove:Deconstruct()
  LuaVector3.Destroy(self.args[1])
  LuaVector3.Destroy(self.args[3])
  LuaVector3.Destroy(self.args[4])
  self.args[1] = nil
  self.args[3] = nil
  self.args[4] = nil
end

function AI_CMD_DirMove:Start(time, deltaTime, creature)
  creature:Client_SetIsDirMoving(true, self.args[5])
  AI_CMD_DirMoveHelper.Step(self, time, deltaTime, creature, self.args[1], self.args[3], self.args[4])
  creature:Logic_PlayAction_Move(self.args[5])
  return true
end

function AI_CMD_DirMove:End(time, deltaTime, creature)
  creature:Logic_StopMove()
  creature:Client_SetIsDirMoving(false)
end

function AI_CMD_DirMove:Update(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:End(time, deltaTime, creature)
    self:SetKeepAlive(true)
    return
  end
  if nil ~= creature.logicTransform.targetPosition then
    if not self.args[2] then
      creature:Logic_SamplePosition(time)
    end
  else
    AI_CMD_DirMoveHelper.Step(self, time, deltaTime, creature, self.args[1], self.args[3], self.args[4])
  end
end

function AI_CMD_DirMove.ToString()
  return "AI_CMD_DirMove", AI_CMD_DirMove
end
