AI_CMD_ClientPatrol = {}

function AI_CMD_ClientPatrol:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
end

function AI_CMD_ClientPatrol:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  return 5
end

function AI_CMD_ClientPatrol:Deconstruct()
  self.args[1] = nil
  self.args[2] = nil
  self.args[3] = nil
  self.args[4] = nil
  self.args[5] = nil
  self.args[6] = nil
  self.args[7] = nil
end

local maxTrial = 10
local Logic_NavMeshMoveToRandom = function(creature, range)
  local cpos = creature:GetPosition()
  local trial, rx, rz, rpos = 0
  while trial < maxTrial do
    rx = math.random(-range, range)
    rz = math.random(-range, range)
    if math.abs(rx) + math.abs(rz) >= range / 2 then
      rpos = LuaGeometry.GetTempVector3(cpos[1] + rx, 0, cpos[3] + rz)
      if not creature:Logic_NavMeshMoveTo(rpos) then
        creature:Logic_NavMeshPlaceTo(creature:GetPosition())
        if not creature:Logic_NavMeshMoveTo(rpos) then
          trial = trial + 1
        else
          return true
        end
      else
        return true
      end
    end
  end
end

function AI_CMD_ClientPatrol:Start(time, deltaTime, creature)
  if creature.ai.parent ~= nil then
    return false
  end
  if creature.data:NoAct() then
    return false
  end
  if nil == self.args[1] or nil == self.args[3] or nil == self.args[4] then
    return false
  end
  if self.args[2] then
    math.randomseed(tostring(self.args[2]))
  else
    math.randomseed(tostring(ServerTime.CurServerTime()):reverse():sub(5, -1))
  end
  local randomMove = Logic_NavMeshMoveToRandom(creature, self.args[1])
  if randomMove == true then
    creature:Logic_PlayAction_Move()
    creature:Client_SetMoveSpeed(1)
    self.args[7] = -1
  else
    self.args[7] = 0
  end
  self.args[6] = 0
  return true
end

function AI_CMD_ClientPatrol:End(time, deltaTime, creature)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  creature:Logic_StopMove()
end

function AI_CMD_ClientPatrol:Update(time, deltaTime, creature)
  if self.args[6] >= self.args[3] then
    self:End(time, deltaTime, creature)
    return true
  end
  self.args[6] = self.args[6] + deltaTime
  if self.args[7] < 0 then
    if nil ~= creature.logicTransform.targetPosition then
      creature:Logic_SamplePosition(time)
    else
      self.args[7] = 0
      creature:Logic_StopMove()
      creature:Logic_PlayAction_Idle()
    end
  else
    self.args[7] = self.args[7] + deltaTime
    if self.args[7] >= self.args[4] then
      local randomMove = Logic_NavMeshMoveToRandom(creature, self.args[1])
      if randomMove == true then
        creature:Logic_PlayAction_Move()
        self.args[7] = -1
      else
        self.args[7] = 0
      end
    end
  end
end

function AI_CMD_ClientPatrol.ToString()
  return "AI_CMD_ClientPatrol", AI_CMD_ClientPatrol
end
