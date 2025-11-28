VerticalMoveHelper = {}

function VerticalMoveHelper:Step(creature, stepTarget)
  creature.logicTransform:PlaceTo(stepTarget)
end

local SelfClass = class("SkillCastWorker_JumpUp", ReusableObject)
SelfClass.PoolSize = 100
local JumpSpeed = 5
local JumpMaxHeight = 3
local Step1 = 0.6
local Step2 = 1 - Step1
local JumpDuration = 1000
local AttackActionInterruptMaxLength = 1
local waitForActionWorkerArray = {}
local WorkerFindPredicate = function(worker, workerInstanceID)
  return worker.instanceID == workerInstanceID
end
local OnActionFinished = function(creatureGUID, workerInstanceID)
  local worker, i = TableUtility.ArrayFindByPredicate(waitForActionWorkerArray, WorkerFindPredicate, workerInstanceID)
  if worker ~= nil then
    worker.args[4] = 0
  end
end
local tempVector3 = LuaVector3.Zero()
local Better_MoveTowards = LuaVector3.Better_MoveTowards
local Distance = LuaVector3.Distance
local AlmostEqual = NumberUtility.AlmostEqual

function SelfClass.Create(args)
  return ReusableObject.Create(SelfClass, true, args)
end

function SelfClass:ctor()
  self.args = {}
end

function SelfClass:Start(skill, creature)
  local skillInfo = skill.info
  local assetRole = creature.assetRole
  LuaVector3.Better_SetPos(self.args[7], creature:GetPosition())
  self.casttime, _ = skill:GetCastInfo(creature)
  self.castTimeElapsed = 0
  local actionPlayed = false
  local actionName = SelfClass.GetCastAction(nil, skill, creature)
  if actionName ~= nil then
    local playActionParams = Asset_Role.GetPlayActionParams(actionName)
    playActionParams[6] = true
    playActionParams[7] = OnActionFinished
    playActionParams[8] = self.instanceID
    actionPlayed = creature:Logic_PlayAction(playActionParams)
    if actionPlayed then
      TableUtility.ArrayPushBack(waitForActionWorkerArray, self)
    end
    Asset_Role.ClearPlayActionParams(playActionParams)
  end
  local sePath = skillInfo:GetCastSEPath(creature)
  if sePath ~= nil then
    assetRole:PlaySEOneShotOn(sePath)
  end
  local args = self.args
  if actionPlayed then
    local time = UnityTime
    args[4] = time + JumpDuration
    args[5] = time + (skillInfo:GetPreAttackJumpTime() or AttackActionInterruptMaxLength)
  else
    args[4] = 1000
    args[5] = 1000
  end
  self.speed = JumpSpeed
  return actionPlayed
end

function SelfClass:End(skill, creature)
  creature.logicTransform:PlaceTo(self.args[7])
end

local tempSpd, effectFlag = 0, false

function SelfClass:Update(skill, time, deltaTime, creature)
  local args = self.args
  if args[4] == 0 or time >= args[4] then
    return false
  end
  if skill.interrupt or time >= args[5] then
    if not args[6] then
      creature.logicTransform:StopMove()
      args[6] = true
    end
    return true
  end
  local skillInfo = skill.info
  self.castTimeElapsed = self.castTimeElapsed + deltaTime
  local currentPosition = creature:GetPosition()
  local height, tempHeight = currentPosition[2], 0
  if self.casttime * Step1 > self.castTimeElapsed then
    tempSpd = self.speed / Step1
    tempHeight = currentPosition[2] + tempSpd * deltaTime
  elseif self.castTimeElapsed >= self.casttime * Step1 and self.casttime > self.castTimeElapsed then
    tempSpd = self.speed * Step2
    tempHeight = currentPosition[2] + tempSpd * deltaTime
  elseif AlmostEqual(self.casttime, self.castTimeElapsed) then
    tempHeight = currentPosition[2] + self.speed * deltaTime
  end
  height = math.clamp(tempHeight, height, height + JumpMaxHeight)
  tempVector3:Set(currentPosition[1], height, currentPosition[3])
  if not creature.data:NoMove() then
    local Helper = VerticalMoveHelper
    Helper.Step(self, creature, tempVector3)
  end
  return true
end

function SelfClass.GetCastAction(params, skill, creature)
  local actionName = skill.info:GetCastAction(creature)
  if actionName ~= nil and creature.assetRole:HasActionRaw(actionName) then
    return actionName
  end
  return nil
end

function SelfClass:DoConstruct(asArray, args)
  self.args[2] = LuaVector3.Zero()
  self.args[3] = LuaVector3.Zero()
  self.args[7] = LuaVector3.Zero()
end

function SelfClass:DoDeconstruct(asArray)
  if self.args[1] ~= nil then
    self.args[1]:Destroy()
    self.args[1] = nil
  end
  LuaVector3.Destroy(self.args[2])
  self.args[2] = nil
  LuaVector3.Destroy(self.args[3])
  self.args[3] = nil
  self.args[4] = nil
  self.args[5] = nil
  self.args[6] = nil
  LuaVector3.Destroy(self.args[7])
  self.args[7] = nil
  TableUtility.ArrayRemove(waitForActionWorkerArray, self)
end

return SelfClass
