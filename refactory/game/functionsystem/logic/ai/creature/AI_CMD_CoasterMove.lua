AI_CMD_CoasterMoveHelper = {}
local tempVector3 = LuaVector3.Zero()

function AI_CMD_CoasterMoveHelper:GetMoveProvider()
  local provider = self.args[1]
  if provider == nil then
    return nil
  end
  if provider.IsRunning == nil or not provider:IsRunning() then
    return nil
  end
  return provider
end

function AI_CMD_CoasterMoveHelper:GetMoveDir()
  local provider = AI_CMD_CoasterMoveHelper.GetMoveProvider(self)
  if provider == nil then
    return nil
  end
  return provider:GetCurrentMoveDir()
end

function AI_CMD_CoasterMoveHelper:Step(time, deltaTime, creature, dir, stepTarget, rotateDir)
  local moveDistance = 0
  if creature.logicTransform ~= nil then
    moveDistance = creature.logicTransform:GetMoveSpeedWithFastForward() * deltaTime
  end
  if moveDistance <= 0 then
    return false
  end
  local p = creature:GetPosition()
  dir[2] = 0
  LuaVector3.Better_Mul(dir, moveDistance, stepTarget)
  LuaVector3.Better_Add(p, stepTarget, stepTarget)
  local ret, _ = NavMeshUtility.Better_Sample(stepTarget, stepTarget, 1)
  if not ret then
    NavMeshUtility.Better_Sample(p, tempVector3)
    creature:Logic_NavMeshPlaceTo(tempVector3)
    if Game.MapManager:NoOverStep() then
      return false
    end
  end
  LuaVector3.Better_Add(p, dir, rotateDir)
  creature.logicTransform:RotateTo(rotateDir)
  creature:Logic_NavMeshPlaceTo(stepTarget)
  return true
end

AI_CMD_CoasterMove = {}

function AI_CMD_CoasterMove:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = LuaVector3.Zero()
  self.args[4] = LuaVector3.Zero()
  self.args[5] = args[4]
  return 5
end

function AI_CMD_CoasterMove:Deconstruct()
  LuaVector3.Destroy(self.args[3])
  LuaVector3.Destroy(self.args[4])
  self.args[1] = nil
  self.args[3] = nil
  self.args[4] = nil
  self.args[5] = nil
end

function AI_CMD_CoasterMove:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[5] = args[4]
end

function AI_CMD_CoasterMove:Start(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:SetKeepAlive(true)
    return false
  end
  local dir = AI_CMD_CoasterMoveHelper.GetMoveDir(self)
  if dir == nil then
    return false
  end
  creature:Client_SetIsDirMoving(true, self.args[5])
  if not AI_CMD_CoasterMoveHelper.Step(self, time, deltaTime, creature, dir, self.args[3], self.args[4]) then
    return false
  end
  creature:Logic_PlayAction_Move(self.args[5])
  return true
end

function AI_CMD_CoasterMove:End(time, deltaTime, creature)
  creature:Logic_StopMove()
  creature:Client_SetIsDirMoving(false)
end

function AI_CMD_CoasterMove:Update(time, deltaTime, creature)
  local provider = AI_CMD_CoasterMoveHelper.GetMoveProvider(self)
  if creature.data:NoMove() or provider == nil then
    self:End(time, deltaTime, creature)
    return
  end
  local dir = AI_CMD_CoasterMoveHelper.GetMoveDir(self)
  if dir == nil then
    self:End(time, deltaTime, creature)
    return
  end
  AI_CMD_CoasterMoveHelper.Step(self, time, deltaTime, creature, dir, self.args[3], self.args[4])
end

function AI_CMD_CoasterMove.ToString()
  return "AI_CMD_CoasterMove", AI_CMD_CoasterMove
end
