AI_CMD_MoveToHelper = {}

function AI_CMD_MoveToHelper.OnMoveFinished(creatureGUID)
  local creature = SceneCreatureProxy.FindCreature(creatureGUID)
  if nil == creature then
    return
  end
  creature.assetRole:PlayActionSE(Asset_Role.ActionName.Move)
end

function AI_CMD_MoveToHelper:Start(time, deltaTime, creature, p, ignoreNavMesh, range, customMoveActionName)
  if creature.ai.parent ~= nil then
    return false
  end
  if creature.data:DeepFreeze() then
    return false
  end
  if creature.data:NoAct() and not creature.data:IsAttrCanMove() then
    return false
  end
  if nil ~= range and VectorUtility.DistanceXZ_Square(creature:GetPosition(), p) <= range * range then
    return false
  end
  if creature.data.GetFeature_IgnoreRotation and creature.data:GetFeature_IgnoreRotation() then
    creature:Logic_LockRotation(true)
  end
  if ignoreNavMesh then
    creature:Logic_MoveTo(p)
  elseif not creature:Logic_NavMeshMoveTo(p) then
    creature:Logic_NavMeshPlaceTo(creature:GetPosition())
    if not creature:Logic_NavMeshMoveTo(p) then
      return false
    end
  end
  creature:Client_SetIsMoveToWorking(true, customMoveActionName)
  creature:Logic_PlayAction_Move(customMoveActionName, nil, AI_CMD_MoveToHelper.OnMoveFinished)
  return true
end

function AI_CMD_MoveToHelper:End(time, deltaTime, creature)
  creature:Client_SetIsMoveToWorking(false)
  creature:Logic_StopMove()
end

function AI_CMD_MoveToHelper:Update(time, deltaTime, creature, ignoreNavMesh, range)
  if nil ~= creature.logicTransform.targetPosition then
    if nil ~= range and VectorUtility.DistanceXZ_Square(creature:GetPosition(), creature.logicTransform.targetPosition) <= range * range then
      self:End(time, deltaTime, creature)
      return true
    end
    if not ignoreNavMesh then
      creature:Logic_SamplePosition(time)
    end
  else
    self:End(time, deltaTime, creature)
    return true
  end
  return false
end

local Helper = AI_CMD_MoveToHelper
AI_CMD_MoveTo = {}

function AI_CMD_MoveTo:ResetArgs(args)
  local p = args[2]
  LuaVector3.Better_Set(self.args[1], p[1], p[2], p[3])
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
end

function AI_CMD_MoveTo:Construct(args)
  self.args[1] = LuaVector3.Better_Clone(args[2])
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  return 4
end

function AI_CMD_MoveTo:Deconstruct()
  LuaVector3.Destroy(self.args[1])
  self.args[1] = nil
  self.args[3] = nil
  self.args[4] = nil
end

function AI_CMD_MoveTo:Start(time, deltaTime, creature)
  return Helper.Start(self, time, deltaTime, creature, self.args[1], self.args[2], nil, self.args[4])
end

function AI_CMD_MoveTo:End(time, deltaTime, creature)
  Helper.End(self, time, deltaTime, creature)
  if self.args[3] then
    self.args[3](creature)
    self.args[3] = nil
  end
end

function AI_CMD_MoveTo:Update(time, deltaTime, creature)
  Helper.Update(self, time, deltaTime, creature, self.args[2])
end

function AI_CMD_MoveTo.ToString()
  return "AI_CMD_MoveTo", AI_CMD_MoveTo
end
