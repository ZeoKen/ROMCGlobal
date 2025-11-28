NpcAIState = class("NpcAIState", ReusableObject)

function NpcAIState:DoConstruct(asArray, args)
  self.id = args[1]
  self.ai = args[2]
  self.targetId = args[3]
  self.randomPos = nil
  self:OnEnter()
end

function NpcAIState:DoDeconstruct()
  self.id = nil
  self.ai = nil
  self.targetId = nil
  self.randomPos = nil
  self.isPlaying = nil
end

function NpcAIState:OnEnter()
  if not self.ai then
    return
  end
  local data = Table_AICondition[self.id]
  if not data then
    return
  end
  local probability = data.Probability
  local rand = math.random(1, 100)
  if probability >= rand then
    local eventId = data.EventId
    local interval
    if self.isLoop then
      interval = -1
    else
      interval = self.ai:RandomEventInterval(eventId)
    end
    local target = NSceneUserProxy.Instance:Find(self.targetId)
    self.isPlaying = self.ai:CompareEvent(eventId, interval, self.isLoop, target, self.randomPos)
    self.eventId = eventId
    if target then
      local args = ReusableTable.CreateArray()
      args[1] = self.id
      args[2] = self.targetId
      args[3] = true
      EventManager.Me():PassEvent(PlayerBehaviourEvent.OnNpcAIStateUpdate, args)
      ReusableTable.DestroyAndClearArray(args)
    end
  end
end

function NpcAIState:OnExit()
  if self.isPlaying and self.targetId then
    local args = ReusableTable.CreateArray()
    args[1] = self.id
    args[2] = self.targetId
    args[3] = false
    EventManager.Me():PassEvent(PlayerBehaviourEvent.OnNpcAIStateUpdate, args)
    ReusableTable.DestroyAndClearArray(args)
  end
  ReusableObject.Destroy(self)
end

function NpcAIState:OnUpdate(time, deltaTime)
end

function NpcAIState:Dispose()
  self.ai:OnEventStop()
end

local quaternion = LuaQuaternion()
local tempV3 = LuaVector3()

function NpcAIState:RandomPosInRange(range, minAngle, maxAngle)
  if not range then
    return
  end
  local target = NSceneUserProxy.Instance:Find(self.targetId)
  if not target then
    return
  end
  local x, y, z = LuaGameObject.GetTransformForward(target.assetRole.complete)
  local dir = LuaGeometry.GetTempVector3(x, y, z)
  local pos = LuaGeometry.TempGetPosition(target.assetRole.completeTransform)
  local randomR = math.random(1, 100) / 100 * range
  minAngle = minAngle or 0
  maxAngle = maxAngle or 359
  local randomAngle = math.random(minAngle, maxAngle)
  tempV3[2] = randomAngle
  LuaQuaternion.Better_Euler(quaternion, tempV3[1], tempV3[2], tempV3[3])
  local randomPos = LuaQuaternion.Better_MulVector3(quaternion, dir)
  LuaVector3.Normalized(randomPos)
  LuaVector3.Mul(randomPos, randomR)
  LuaVector3.Add(randomPos, pos)
  return randomPos
end
