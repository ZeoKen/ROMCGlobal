AI_CMD_Action_MoveHelper = {}
local NotifyServerInterval = 0.3
local NotifyServerDistance = 0.25
local nextNotifyTime = 0
local prevNotifyPosition = LuaVector3.Zero()
local tempVector3 = LuaVector3.Zero()
local Better_MoveTowards = LuaVector3.Better_MoveTowards
local Distance = LuaVector3.Distance
local AlmostEqual_3 = VectorUtility.AlmostEqual_3

function AI_CMD_Action_MoveHelper:Step(time, deltaTime, creature, stepTarget)
  creature.logicTransform:PlaceTo(stepTarget)
end

function AI_CMD_Action_MoveHelper:NotifyServer(time, deltaTime, creature)
  if time > nextNotifyTime then
    local p = creature:GetPosition()
    if LuaVector3.Distance_Square(prevNotifyPosition, p) > NotifyServerDistance then
      nextNotifyTime = time + NotifyServerInterval
      LuaVector3.Better_Set(prevNotifyPosition, p[1], p[2], p[3])
    end
  end
end

AI_CMD_Action_Move = {}

function AI_CMD_Action_Move:Construct(args)
  if args[2] then
    self.args[1] = LuaVector3.Better_Clone(args[2])
  else
    self.args[1] = LuaVector3.Zero()
  end
  self.args[2] = args[3]
  self.args[3] = LuaVector3.Better_Clone(args[4])
  self.args[4] = args[5]
  self.args[5] = args[6]
  return 5
end

function AI_CMD_Action_Move:Deconstruct()
  if self.args[1] then
    self.args[1]:Destroy()
  end
  self.args[3]:Destroy()
  self.args[1] = nil
  self.args[3] = nil
  self.args[4] = nil
  self.args[5] = nil
end

function AI_CMD_Action_Move:TryRestart(args, creature)
  local p = args[2]
  self.args[1]:Set(p[1], p[2], p[3])
  self.args[2] = args[3]
  if not self.running then
    return true
  end
  return AI_CMD_Action_Move.Start(self, time, deltaTime, creature)
end

function AI_CMD_Action_Move:Start(time, deltaTime, creature)
  if creature.data:NoMove() then
    return false
  end
  creature:Logic_LockRotation(true)
  local params = Asset_Role.GetPlayActionParams(self.args[4])
  creature:Logic_PlayAction(params)
  local currentPosition = creature.logicTransform.currentPosition
  self.speed = Distance(currentPosition, self.args[3]) / self.args[5]
  return true
end

function AI_CMD_Action_Move:End(time, deltaTime, creature)
  local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Idle)
  creature:Logic_PlayAction(params)
end

function AI_CMD_Action_Move:Update(time, deltaTime, creature)
  if creature.data:NoMove() then
    self:End(creature)
    return
  end
  local currentPosition = creature.logicTransform.currentPosition
  if AlmostEqual_3(currentPosition, self.args[3]) then
    self:End(time, deltaTime, creature)
    return true
  else
    Better_MoveTowards(currentPosition, self.args[3], tempVector3, self.speed * deltaTime)
    AI_CMD_Action_MoveHelper.Step(self, time, deltaTime, creature, tempVector3)
  end
  AI_CMD_Action_MoveHelper.NotifyServer(self, time, deltaTime, creature)
end

function AI_CMD_Action_Move.ToString()
  return "AI_CMD_Action_Move", AI_CMD_Action_Move
end
