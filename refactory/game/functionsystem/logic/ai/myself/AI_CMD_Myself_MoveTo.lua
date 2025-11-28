AI_CMD_Myself_MoveToHelper = {}
setmetatable(AI_CMD_Myself_MoveToHelper, {
  __index = AI_CMD_MoveToHelper
})

function AI_CMD_Myself_MoveToHelper:Start(time, deltaTime, creature, p, ignoreNavMesh, range, customMoveActionName)
  if creature.data:NoMove() then
    self:SetKeepAlive(true)
    return false
  end
  if not self.skipCheckDirMove and creature:Client_IsDirMoving() then
    return false
  end
  return AI_CMD_MoveToHelper.Start(self, time, deltaTime, creature, p, ignoreNavMesh, range, customMoveActionName)
end

function AI_CMD_Myself_MoveToHelper:Update(time, deltaTime, creature, ignoreNavMesh)
  if creature.data:NoMove() then
    self:End(time, deltaTime, creature)
    self:SetKeepAlive(true)
    return false
  end
  if not self.skipCheckDirMove and creature:Client_IsDirMoving() then
    self:End(time, deltaTime, creature)
    return false
  end
  return AI_CMD_MoveToHelper.Update(self, time, deltaTime, creature, ignoreNavMesh)
end

local Helper = AI_CMD_Myself_MoveToHelper
AI_CMD_Myself_MoveTo = {}

function AI_CMD_Myself_MoveTo:Construct(args)
  self.args[1] = LuaVector3.Better_Clone(args[2])
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  self.args[6] = args[7]
  self.args[7] = args[8]
  self.args[8] = false
  return 8
end

function AI_CMD_Myself_MoveTo:Deconstruct()
  LuaVector3.Destroy(self.args[1])
  self.args[1] = nil
  self.args[3] = nil
  self.args[4] = nil
  self.args[5] = nil
  self.args[6] = nil
  self.args[7] = nil
  self.args[8] = nil
end

function AI_CMD_Myself_MoveTo:Start(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:SetKeepAlive(true)
    return false
  end
  if creature:IsConcurrentRotateOnly() then
    self.args[8] = true
    local targetPosition = LuaGeometry.GetTempVector3()
    if self.args[2] or not NavMeshUtility.Better_Sample(self.args[1], targetPosition, self.args[6]) then
      targetPosition = self.args[1]
    end
    Game.ClickGroundEffectManager:SetPos(targetPosition)
    creature.logicTransform:RotateTo(targetPosition)
    return true
  end
  self.skipCheckDirMove = true
  local ret = Helper.Start(self, time, deltaTime, creature, self.args[1], self.args[2], self.args[6], self.args[7])
  if ret then
    Game.ClickGroundEffectManager:SetPos(creature.logicTransform.targetPosition)
    creature:Client_TryNotifyServerAngleY(time, creature.logicTransform.targetAngleY, 1, 10)
  end
  return ret
end

function AI_CMD_Myself_MoveTo:End(time, deltaTime, creature)
  Game.ClickGroundEffectManager:HideEffect()
  if self.args[8] then
    creature:Client_NotifyServerAngleY(time, deltaTime, true)
    creature.logicTransform:StopRotation()
    return
  end
  creature:RemoveWalkEffect()
  Helper.End(self, time, deltaTime, creature)
end

function AI_CMD_Myself_MoveTo:Update(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:End(time, deltaTime, creature)
    self:SetKeepAlive(true)
    return
  end
  if self.args[8] then
    if creature.logicTransform:IsRotating() then
      creature:Client_NotifyServerAngleY(time, deltaTime)
    else
      self:End(time, deltaTime, creature)
    end
    return
  end
  if Helper.Update(self, time, deltaTime, creature, self.args[2], self.args[6]) and nil ~= self.args[3] then
    self.args[3](self.args[4], self.args[5])
    self.args[3] = nil
    self.args[4] = nil
    self.args[5] = nil
  end
end

function AI_CMD_Myself_MoveTo.ToString()
  return "AI_CMD_Myself_MoveTo", AI_CMD_Myself_MoveTo
end
