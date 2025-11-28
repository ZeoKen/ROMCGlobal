local SelfClass = class("SkillAttackWorker_Jump", ReusableObject)
SelfClass.PoolSize = 100
local AttackActionMaxLength = 3
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

function SelfClass.Create(args)
  return ReusableObject.Create(SelfClass, true, args)
end

function SelfClass:ctor()
  self.args = {}
end

function SelfClass:Start(skill, creature)
  skill:AddFireIndex()
  local skillInfo = skill.info
  local assetRole = creature.assetRole
  local actionPlayed = false
  local actionName = SelfClass.GetAttackAction(nil, skill, creature)
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
  local attackEP = skillInfo:GetAttackEP(creature)
  local effectPath, lodLevel, priority, effectType, scale = skillInfo:GetAttackEffectPath(creature)
  if effectPath ~= nil then
    local effect
    if skillInfo:AttackEffectOnRole(creature) then
      effect = assetRole:PlayEffectOneShotOn(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
    else
      effect = assetRole:PlayEffectOneShotAt(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
      effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
    end
    if effect then
      effect:SetPlaybackSpeed(creature.logicTransform:GetFastForwardSpeed())
      if scale and scale ~= 1 then
        effect:ResetLocalScaleXYZ(scale, scale, scale)
      end
    end
  end
  local sePath = skillInfo:GetAttackSEPath(creature)
  if sePath ~= nil then
    assetRole:PlaySEOneShotOn(sePath)
  end
  if actionPlayed then
    local spdRate = skillInfo:GetPreAttackJumpSpdRate(creature)
    if spdRate ~= nil then
      local moveSpeed = creature.data.props:GetPropByName("MoveSpd"):GetValue()
      local spdLimit = skillInfo:GetPreAttackJumpSpdLimit(creature)
      if spdLimit ~= nil then
        moveSpeed = math.min(moveSpeed * spdRate, spdLimit)
      else
        moveSpeed = moveSpeed * spdRate
      end
      creature:Client_SetMoveSpeed(moveSpeed)
    end
    local args = self.args
    local time = UnityTime
    args[4] = time + AttackActionMaxLength
    args[5] = time + (skillInfo:GetPreAttackJumpTime() or AttackActionInterruptMaxLength)
    if creature == Game.Myself and Game.IsJoyStick then
      self:SetWorkerDir(Game.JoyStickDir)
    end
  end
  return actionPlayed
end

function SelfClass:End(skill, creature)
  local moveSpeed = creature.data.props:GetPropByName("MoveSpd"):GetValue()
  creature:Client_SetMoveSpeed(moveSpeed)
  creature:Logic_StopMove()
end

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
  if not creature.data:NoMove() and args[1] ~= nil then
    local Helper = AI_CMD_Myself_DirMoveHelper
    if creature.logicTransform.targetPosition ~= nil then
      creature:Logic_SamplePosition(time)
    else
      Helper.Step(self, time, deltaTime, creature, args[1], args[2], args[3])
    end
    Helper.NotifyServer(self, time, deltaTime, creature, 0.2)
  end
  return true
end

function SelfClass:SetWorkerDir(dir)
  local args = self.args
  if args[1] ~= nil then
    return
  end
  args[1] = dir:Clone()
end

function SelfClass:SetWorkerMove(skill, creature, x, y, z)
  if skill.interrupt then
    return false
  end
  LuaVector3.Better_Set(self.args[2], x, y, z)
  creature:Logic_NavMeshMoveTo(self.args[2])
end

function SelfClass.GetAttackAction(params, skill, creature)
  local actionName = skill.info:GetAttackAction(creature)
  if actionName ~= nil and creature.assetRole:HasActionRaw(actionName) then
    return actionName
  end
  return nil
end

function SelfClass:DoConstruct(asArray, args)
  self.args[2] = LuaVector3.Zero()
  self.args[3] = LuaVector3.Zero()
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
  TableUtility.ArrayRemove(waitForActionWorkerArray, self)
end

return SelfClass
