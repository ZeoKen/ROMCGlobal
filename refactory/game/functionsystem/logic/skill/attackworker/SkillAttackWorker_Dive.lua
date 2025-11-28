local SelfClass = class("SkillAttackWorker_Dive", ReusableObject)
SelfClass.PoolSize = 100
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.Zero()
local tempVector2 = LuaVector2.Zero()
local tempVector2_1 = LuaVector2.Zero()

function SelfClass.Create(args)
  return ReusableObject.Create(SelfClass, true, args)
end

function SelfClass:ctor()
  self.args = {}
end

function SelfClass:Start(skill, creature)
  skill:AddFireIndex()
  local phaseData = skill.phaseData
  if 0 >= phaseData:GetTargetCount() then
    return false
  end
  local targetGUID = phaseData:GetTarget(1)
  local targetCreature = FindCreature(targetGUID)
  if nil == targetCreature then
    return false
  end
  local args = self.args
  local logicParams = args[1]
  local assetRole = creature.assetRole
  local skillInfo = skill.info
  creature.logicTransform:LookAt(targetCreature:GetPosition())
  local action = SelfClass.GetAttackAction(logicParams)
  local playActionParams = Asset_Role.GetPlayActionParams(action)
  playActionParams[6] = true
  creature:Logic_PlayAction(playActionParams)
  local attackEP = skillInfo:GetAttackEP(creature)
  local effectPath, lodLevel, priority, effectType, scale = skillInfo:GetAttackEffectPath(creature)
  if nil ~= effectPath then
    local effect
    if skillInfo:AttackEffectOnRole(creature) then
      effect = assetRole:PlayEffectOneShotOn(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
    else
      effect = assetRole:PlayEffectOneShotAt(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
      effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
    end
    if effect and scale and scale ~= 1 then
      effect:ResetLocalScaleXYZ(scale, scale, scale)
    end
  end
  local sePath = skillInfo:GetAttackSEPath(creature)
  if nil ~= sePath then
    assetRole:PlaySEOneShotOn(sePath)
  end
  args[2] = targetGUID
  args[3] = logicParams.initSpeed
  args[4] = logicParams.acceleration
  args[5] = logicParams.speedLimit
  args[6] = LuaVector3.Zero()
  args[7] = LuaVector3.Zero()
  args[8] = LuaVector3.Zero()
  args[9] = false
  return true
end

function SelfClass:End(skill, creature)
end

function SelfClass:Update(skill, time, deltaTime, creature)
  local args = self.args
  local logicParams = args[1]
  local targetGUID = args[2]
  local targetCreature = FindCreature(targetGUID)
  if nil == targetCreature then
    return false
  end
  local currentPosition = creature:GetPosition()
  local targetPosition = targetCreature:GetPosition()
  local p0 = args[6]
  local p1 = args[7]
  local p2 = args[8]
  if not args[9] then
    creature.logicTransform:LookAt(targetPosition)
    LuaVector3.Better_Set(p0, currentPosition[1], currentPosition[2], currentPosition[3])
    LuaVector3.Better_Set(p1, targetPosition[1], targetPosition[2], targetPosition[3])
    VectorUtility.SubXZ_2(p1, p0, tempVector2)
    LuaVector2.Normalized(tempVector2)
    LuaVector2.Mul(tempVector2, logicParams.over_distance)
    tempVector2[1] = p1[1] + tempVector2[1]
    tempVector2[2] = p1[3] + tempVector2[2]
    LuaVector3.Better_Set(p2, tempVector2[1], p1[2], tempVector2[2])
  end
  VectorUtility.SetXZ_2(p0, tempVector2)
  VectorUtility.SetXZ_2(p2, tempVector2_1)
  local distanceXZ = LuaVector2.Distance(tempVector2, tempVector2_1)
  local deltaDistance = args[3] * deltaTime
  VectorUtility.Better_MoveTowardsXZ_2(currentPosition, p2, tempVector2, deltaDistance)
  VectorUtility.SetXZ_2(p0, tempVector2_1)
  local movedDistanceXZ = LuaVector2.Distance(tempVector2, tempVector2_1)
  local progress = NumberUtility.Clamp01(movedDistanceXZ / distanceXZ)
  VectorUtility.Better_Bezier(p0, p1, p2, tempVector3, progress)
  VectorUtility.SetXZ_3(tempVector2, tempVector3)
  creature.logicTransform:PlaceTo(tempVector3)
  currentPosition = creature:GetPosition()
  local minSpeed = args[3]
  local maxSpeed = args[5]
  if minSpeed > maxSpeed then
    local tempSpeed = minSpeed
    minSpeed = maxSpeed
    maxSpeed = tempSpeed
  end
  local newSpeed = args[3] + args[4] * deltaTime
  args[3] = NumberUtility.Clamp(newSpeed, minSpeed, maxSpeed)
  if not args[9] then
    local restDistance = VectorUtility.DistanceXZ(currentPosition, p2)
    if restDistance <= logicParams.over_distance then
      args[9] = true
      args[4] = -args[3] * args[3] / (2 * restDistance)
      args[5] = 0
      local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(skill, creature, skill.phaseData, creature.assetRole, skill.info)
      hitWorker:Work(1, 1)
      hitWorker:Destroy()
    end
  else
    local squareRange = logicParams.over_distance * logicParams.over_distance
    if args[3] <= 0 or squareRange <= VectorUtility.DistanceXZ_Square(currentPosition, p1) then
      return false
    end
  end
  return true
end

function SelfClass.GetAttackAction(params)
  return params.action
end

function SelfClass:DoConstruct(asArray, args)
  self.args[1] = args
end

function SelfClass:DoDeconstruct(asArray)
  local args = self.args
  if nil ~= args[6] then
    LuaVector3.Destroy(args[6])
  end
  if nil ~= args[7] then
    LuaVector3.Destroy(args[7])
  end
  if nil ~= args[8] then
    LuaVector3.Destroy(args[8])
  end
  TableUtility.ArrayClearWithCount(args, 9)
end

return SelfClass
