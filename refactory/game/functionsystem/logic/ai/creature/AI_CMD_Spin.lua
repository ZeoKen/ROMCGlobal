local RotateHelper = {}
local tempVector3 = LuaVector3.Zero()
local targetAngleY = 1800
local currentAngleY
local turnspeed = 2000
local tempRot = LuaQuaternion()
local AlmostEqualAngle = NumberUtility.AlmostEqualAngle

function RotateHelper:Step(time, deltaTime, creature, speed)
  currentAngleY = creature:GetAngleY()
  deltaAngle = speed * deltaTime
  currentAngleY = currentAngleY + deltaAngle
  creature.logicTransform:SetAngleY(currentAngleY)
end

AI_CMD_Spin = {}
local Duration = 1

function AI_CMD_Spin:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
end

function AI_CMD_Spin:Construct(args)
  self.args[1] = args[2] or 1
  self.args[2] = args[3] or turnspeed
  return 2
end

function AI_CMD_Spin:Deconstruct()
end

function AI_CMD_Spin:Start(time, deltaTime, creature)
  self.args[4] = time + self.args[1]
  return true
end

function AI_CMD_Spin:End(time, deltaTime, creature)
  creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
end

function AI_CMD_Spin:Update(time, deltaTime, creature)
  if time > self.args[4] then
    self:End(time, deltaTime, creature)
  else
    RotateHelper.Step(self, time, deltaTime, creature, self.args[2])
  end
end

function AI_CMD_Spin.ToString()
  return "AI_CMD_Spin", AI_CMD_Spin
end
