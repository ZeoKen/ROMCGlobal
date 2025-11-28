AI_CMD_ClientAvoidTarget = {}

function AI_CMD_ClientAvoidTarget:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
end

function AI_CMD_ClientAvoidTarget:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  return 5
end

function AI_CMD_ClientAvoidTarget:Deconstruct()
  if self.args[9] then
    LuaVector3.Destroy(self.args[9])
    self.args[9] = nil
  end
end

local offsetCheckSet = {
  0,
  -30,
  30,
  -60,
  60,
  -90,
  90,
  180
}
local Logic_GetRotatedDir = function(dirx, diry, offset)
  if offset == 0 then
    return dirx, diry
  end
  offset = math.rad(offset)
  return dirx * math.cos(offset) - diry * math.sin(offset), dirx * math.cos(offset) + diry * math.sin(offset)
end
local tempV2 = LuaVector2.Zero()
local tempV3 = LuaVector3.Zero()
local Logic_GetAvoidPosition = function(endPos, srcPos, avoidDistance, targetPos)
  LuaVector3.Better_Sub(endPos, srcPos, tempV3)
  tempV2[1] = tempV3[1]
  tempV2[2] = tempV3[3]
  if LuaVector2.SqrMagnitude(tempV2) > avoidDistance * avoidDistance then
    return true, true
  end
  LuaVector2.Normalized(tempV2)
  for i = 1, #offsetCheckSet do
    tempV3[1], tempV3[3] = Logic_GetRotatedDir(tempV2[1], tempV2[2], offsetCheckSet[i])
    tempV3[2] = 0
    local ret, _ = NavMeshUtility.Better_RaycastDirection(srcPos, targetPos, tempV3, avoidDistance)
    if not ret then
      targetPos[1] = srcPos[1] + tempV3[1] * avoidDistance
      targetPos[2] = srcPos[2] + tempV3[2] * avoidDistance
      targetPos[3] = srcPos[3] + tempV3[3] * avoidDistance
      return true
    end
  end
end
local Logic_GetAvoidPositionInRange = function(endPos, srcPos, avoidDistance, targetPos, rangeRect)
  LuaVector3.Better_Sub(endPos, srcPos, tempV3)
  tempV2[1] = tempV3[1]
  tempV2[2] = tempV3[3]
  if LuaVector2.SqrMagnitude(tempV2) > avoidDistance * avoidDistance then
    return true, true
  end
  LuaVector2.Normalized(tempV2)
  for i = 1, #offsetCheckSet do
    tempV3[1], tempV3[3] = Logic_GetRotatedDir(tempV2[1], tempV2[2], offsetCheckSet[i])
    tempV3[2] = 0
    local ret, _ = NavMeshUtility.Better_RaycastDirection(srcPos, targetPos, tempV3, avoidDistance)
    if not ret then
      targetPos[1] = srcPos[1] + tempV3[1] * avoidDistance
      targetPos[2] = srcPos[2] + tempV3[2] * avoidDistance
      targetPos[3] = srcPos[3] + tempV3[3] * avoidDistance
      if targetPos[1] > rangeRect[1] and targetPos[1] < rangeRect[2] and targetPos[3] > rangeRect[3] and targetPos[3] < rangeRect[4] then
        return true
      end
    end
  end
end
local Logic_MoveToAvoidPos = function(myself, avoid_target, avoidDistance, targetPos, rangeRect)
  if myself == nil or avoid_target == nil then
    return -1
  end
  local endPos, srcPos = myself:GetPosition(), avoid_target:GetPosition()
  if endPos == nil or srcPos == nil then
    return -1
  end
  local ret, no_move
  if rangeRect then
    ret, no_move = Logic_GetAvoidPositionInRange(endPos, srcPos, avoidDistance, targetPos, rangeRect)
  else
    ret, no_move = Logic_GetAvoidPosition(endPos, srcPos, avoidDistance, targetPos)
  end
  if ret then
    if no_move then
      myself:Logic_StopMove()
      myself:Logic_PlayAction_Idle()
      return true
    end
    if not myself:Logic_NavMeshMoveTo(targetPos) then
      myself:Logic_NavMeshPlaceTo(myself:GetPosition())
      if not myself:Logic_NavMeshMoveTo(targetPos) then
        redlog("AI_CMD_ClientAvoidTarget", "NavMeshMoveTo failed.")
        return false
      end
    end
    myself:Logic_PlayAction_Move()
    return true
  end
end
local checkPosInterval = 0.3

function AI_CMD_ClientAvoidTarget:Start(time, deltaTime, creature)
  if creature.ai.parent ~= nil then
    return false
  end
  if creature.data:NoAct() then
    return false
  end
  if nil == self.args[1] or nil == self.args[2] or nil == self.args[3] then
    return false
  end
  self.args[6] = creature.logicTransform:GetMoveSpeed()
  if nil == self.args[4] then
    creature.logicTransform:SetMoveSpeed(self.args[1].logicTransform:GetMoveSpeed())
  else
    creature.logicTransform:SetMoveSpeed(self.args[4])
  end
  self.args[7] = 0
  self.args[8] = checkPosInterval
  self.args[9] = LuaVector3.Zero()
  return true
end

function AI_CMD_ClientAvoidTarget:End(time, deltaTime, creature)
  creature:Logic_StopMove()
  creature.logicTransform:SetMoveSpeed(self.args[6])
  creature:Logic_PlayAction_Idle()
end

function AI_CMD_ClientAvoidTarget:Update(time, deltaTime, creature)
  if self.args[7] >= self.args[2] then
    self:End(time, deltaTime, creature)
    return true
  end
  if self.args[8] >= checkPosInterval then
    self.args[8] = 0
    if nil == self.args[4] then
      creature.logicTransform:SetMoveSpeed(self.args[1].logicTransform:GetMoveSpeed())
    end
    if Logic_MoveToAvoidPos(creature, self.args[1], self.args[3], self.args[9], self.args[5]) == -1 then
      self:End(time, deltaTime, creature)
      return true
    end
  end
  self.args[7] = self.args[7] + deltaTime
  self.args[8] = self.args[8] + deltaTime
end

function AI_CMD_ClientAvoidTarget.ToString()
  return "AI_CMD_ClientAvoidTarget", AI_CMD_ClientAvoidTarget
end
