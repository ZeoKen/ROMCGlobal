AI_CMD_Myself_DirMoveHelper = {}
local NotifyServerInterval = 0.3
local NotifyServerDistance = 0.25
local nextNotifyTime = 0
local prevNotifyPosition = LuaVector3.Zero()
local tempVector3 = LuaVector3.Zero()

function AI_CMD_Myself_DirMoveHelper:Step(time, deltaTime, creature, dir, stepTarget, rotateDir)
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

function AI_CMD_Myself_DirMoveHelper:NotifyServer(time, deltaTime, creature, interval)
  if time > nextNotifyTime then
    local p = creature:GetPosition()
    if LuaVector3.Distance_Square(prevNotifyPosition, p) > NotifyServerDistance then
      nextNotifyTime = time + (interval or NotifyServerInterval)
      LuaVector3.Better_Set(prevNotifyPosition, p[1], p[2], p[3])
      creature:Client_MoveHandler(p)
    end
  end
end

AI_CMD_Myself_DirMove = {}

function AI_CMD_Myself_DirMove:Construct(args)
  self.args[1] = LuaVector3.Better_Clone(args[2])
  self.args[2] = args[3]
  self.args[3] = LuaVector3.Zero()
  self.args[4] = LuaVector3.Zero()
  self.args[5] = false
  self.args[6] = false
  self.args[7] = args[4]
  return 7
end

function AI_CMD_Myself_DirMove:Deconstruct()
  LuaVector3.Destroy(self.args[1])
  LuaVector3.Destroy(self.args[3])
  LuaVector3.Destroy(self.args[4])
  self.args[1] = nil
  self.args[3] = nil
  self.args[4] = nil
  self.args[6] = nil
end

function AI_CMD_Myself_DirMove:TryRestart(args, creature)
  local p = args[2]
  LuaVector3.Better_Set(self.args[1], p[1], p[2], p[3])
  self.args[2] = args[3]
  if not self.running then
    return true
  end
  return AI_CMD_Myself_DirMove.Start(self, time, deltaTime, creature)
end

function AI_CMD_Myself_DirMove:Start(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:SetKeepAlive(true)
    return false
  end
  if creature:IsConcurrentRotateOnly() then
    self.args[6] = true
    LuaVector3.Better_Add(creature:GetPosition(), self.args[1], self.args[4])
    creature.logicTransform:RotateTo(self.args[4])
    return true
  end
  creature:Client_SetIsDirMoving(true, self.args[7])
  AI_CMD_Myself_DirMoveHelper.Step(self, time, deltaTime, creature, self.args[1], self.args[3], self.args[4])
  if not self.args[5] then
    self.args[5] = creature:Logic_PlayAction_Move(self.args[7])
  end
  creature:Client_TryNotifyServerAngleY(UnityTime, creature.logicTransform.targetAngleY, 1, 10)
  return true
end

function AI_CMD_Myself_DirMove:End(time, deltaTime, creature)
  if self.args[6] then
    creature:Client_NotifyServerAngleY(time, deltaTime, true)
    creature.logicTransform:StopRotation()
    return
  end
  creature:Logic_StopMove()
  creature:RemoveWalkEffect()
  creature:Client_SetIsDirMoving(false)
  self.args[5] = false
end

function AI_CMD_Myself_DirMove:Update(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:End(time, deltaTime, creature)
    self:SetKeepAlive(true)
    return
  end
  if self.args[6] then
    if creature.logicTransform:IsRotating() then
      creature:Client_NotifyServerAngleY(time, deltaTime)
    else
      self:End(time, deltaTime, creature)
    end
    return
  end
  if nil ~= creature.logicTransform.targetPosition then
    if not self.args[2] then
      creature:Logic_SamplePosition(time)
    end
  else
    AI_CMD_Myself_DirMoveHelper.Step(self, time, deltaTime, creature, self.args[1], self.args[3], self.args[4])
  end
  AI_CMD_Myself_DirMoveHelper.NotifyServer(self, time, deltaTime, creature)
end

function AI_CMD_Myself_DirMove.ToString()
  return "AI_CMD_Myself_DirMove", AI_CMD_Myself_DirMove
end
