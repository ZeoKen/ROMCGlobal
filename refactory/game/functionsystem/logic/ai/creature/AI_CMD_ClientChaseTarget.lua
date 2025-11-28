AI_CMD_ClientChaseTarget = {}

function AI_CMD_ClientChaseTarget:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
end

function AI_CMD_ClientChaseTarget:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  return 4
end

function AI_CMD_ClientChaseTarget:Deconstruct()
end

local checkPosInterval = 0.3

function AI_CMD_ClientChaseTarget:Start(time, deltaTime, creature)
  if creature.ai.parent ~= nil then
    return false
  end
  if creature.data:NoAct() then
    return false
  end
  if nil == self.args[1] or nil == self.args[2] or nil == self.args[3] then
    return false
  end
  self.args[5] = creature.logicTransform:GetMoveSpeed()
  if nil == self.args[4] then
    creature.logicTransform:SetMoveSpeed(self.args[1].logicTransform:GetMoveSpeed())
  else
    creature.logicTransform:SetMoveSpeed(self.args[4])
  end
  self.args[6] = 0
  self.args[7] = checkPosInterval
  return true
end

function AI_CMD_ClientChaseTarget:End(time, deltaTime, creature)
  creature:Logic_StopMove()
  creature.logicTransform:SetMoveSpeed(self.args[5])
  creature:Logic_PlayAction_Idle()
end

local tempV2 = LuaVector2.Zero()
local tempV3 = LuaVector3.Zero()

function AI_CMD_ClientChaseTarget:Update(time, deltaTime, creature)
  if self.args[6] >= self.args[2] or self.args[1] == nil then
    self:End(time, deltaTime, creature)
    return true
  end
  if self.args[7] >= checkPosInterval then
    self.args[7] = 0
    while true do
      local endPos, srcPos = self.args[1]:GetPosition(), creature:GetPosition()
      if not endPos then
        self:End(time, deltaTime, creature)
        return true
      end
      LuaVector3.Better_Sub(endPos, srcPos, tempV3)
      tempV2[1] = tempV3[1]
      tempV2[2] = tempV3[3]
      if LuaVector2.SqrMagnitude(tempV2) < self.args[3] * self.args[3] then
        creature:Logic_StopMove()
        creature:Logic_PlayAction_Idle()
        break
      end
      if not creature:Logic_NavMeshMoveTo(endPos) then
        creature:Logic_NavMeshPlaceTo(creature:GetPosition())
        if not creature:Logic_NavMeshMoveTo(endPos) then
          redlog("AI_CMD_ClientChaseTarget", "NavMeshMoveTo failed.")
          break
        end
      end
      creature:Logic_PlayAction_Move()
      break
    end
  end
  self.args[6] = self.args[6] + deltaTime
  self.args[7] = self.args[7] + deltaTime
end

function AI_CMD_ClientChaseTarget.ToString()
  return "AI_CMD_ClientChaseTarget", AI_CMD_ClientChaseTarget
end
