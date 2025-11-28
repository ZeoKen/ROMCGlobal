SubSkillProjectile = class("SubSkillProjectile", ReusableObject)
if not SubSkillProjectile.SubSkillProjectile_Inited then
  SubSkillProjectile.SubSkillProjectile_Inited = true
  SubSkillProjectile.PoolSize = 100
end
local ProjectileAIClass = {
  [1] = autoImport("SubSkill_StraightLine"),
  [2] = autoImport("SubSkill_Missile"),
  [3] = autoImport("SubSkill_Cyclotron")
}
local ProjectileEffectLogic = {
  [1] = autoImport("SubSkill_EffectOneShotOnTerrain")
}
local tempVector3 = LuaVector3.Zero()
local FindCreature = SceneCreatureProxy.FindCreature
local tempArgs = {
  [1] = nil,
  [2] = nil,
  [3] = nil,
  [4] = nil,
  [5] = nil,
  [6] = nil,
  [7] = 1,
  [8] = 1
}

function SubSkillProjectile.GetArgs(emitParams, hitWorker, forceSingleDamage, startPosition, endPosition, emitIndex, emitCount, scale)
  tempArgs[1] = ProjectileAIClass[emitParams.type]
  tempArgs[2] = emitParams
  tempArgs[3] = hitWorker
  tempArgs[4] = forceSingleDamage
  tempArgs[5] = startPosition
  tempArgs[6] = endPosition
  tempArgs[7] = emitIndex
  tempArgs[8] = emitCount
  tempArgs[12] = scale
  return tempArgs
end

function SubSkillProjectile.ClearArgs(args)
  TableUtility.ArrayClear(args)
end

function SubSkillProjectile.Create(args)
  return ReusableObject.Create(SubSkillProjectile, true, args)
end

function SubSkillProjectile:ctor()
  self.args = {}
end

function SubSkillProjectile:Update(time, deltaTime)
  local args = self.args
  if not args[10] then
    self:_End()
    return
  end
  local endPosition, refreshed = self:GetEndPosition()
  if nil == endPosition then
    self:_End()
    return
  end
  if args[1].Update(self, endPosition, refreshed, time, deltaTime) then
    if nil ~= args[11] and args[8] ~= nil then
      args[11]:Update(args[8], time, deltaTime)
    end
  else
    self:_End()
  end
end

function SubSkillProjectile:GetEndPosition()
  local endPosition = self.args[5]
  if nil == endPosition then
    local pos = self:GetHitPosition()
    if pos ~= nil then
      endPosition = pos
      return endPosition, true
    end
  end
  return endPosition, false
end

function SubSkillProjectile:GetHitPosition()
  local args = self.args
  local hitWorker = args[3]
  local targetGUID = hitWorker:GetTarget(1)
  local targetCreature = FindCreature(targetGUID)
  if nil ~= targetCreature then
    LuaVector3.Better_Set(tempVector3, targetCreature.assetRole:GetEPOrRootPosition(args[9]))
    return tempVector3
  end
  return nil
end

function SubSkillProjectile:Hit(endPosition)
  local args = self.args
  local effect = args[8]
  local hitWorker = args[3]
  local fromPosition = effect:GetLocalPosition()
  local creature = FindCreature(hitWorker:GetFromGUID())
  if creature == nil then
    return
  end
  local skillInfo = hitWorker:GetSkillInfo(creature)
  if SkillTargetType.Point == skillInfo:GetTargetType(creature) then
    local effectPath, lodLevel, priority, effectType, scale = skillInfo:GetFirePointEffectPath(creature)
    if nil ~= effectPath then
      local effect = Asset_Effect.PlayOneShotAt(effectPath, endPosition, nil, nil, nil, lodLevel, priority, effectType)
      if effect and scale and scale ~= 1 then
        effect:ResetLocalScaleXYZ(scale, scale, scale)
      end
    end
  end
  local sePath = skillInfo:GetProjectileHitSEPath(creature)
  if sePath ~= nil then
    AudioUtility.PlayOneShotAt_Path(sePath, endPosition.x, endPosition.y, endPosition.z, AudioSourceType.SCENE)
  end
  mylog("SubSkillProjectile:Hit", UnityFrameCount)
  hitWorker:SetFromPosition(fromPosition)
  hitWorker:Work(args[6], args[7], args[4])
end

function SubSkillProjectile:_Start(creature, skillInfo)
  local args = self.args
  if args[10] then
    return
  end
  local endPosition, _ = self:GetEndPosition()
  if nil == endPosition then
    return
  end
  local effect = args[8]
  local startPosition = effect:GetLocalPosition()
  if 0.25 > LuaVector3.Distance_Square(startPosition, endPosition) then
    self:Hit(endPosition)
    self:Destroy()
    return
  end
  args[10] = args[1].Start(self, endPosition)
  if args[10] then
    local emitParams = args[2]
    local effect_logic = emitParams.effect_logic
    if nil ~= effect_logic then
      local effectLogicClass = ProjectileEffectLogic[effect_logic.type]
      local effectLogicArgs = effectLogicClass.GetArgs(effect_logic, creature, skillInfo)
      args[11] = effectLogicClass.Create(effectLogicArgs)
      effectLogicClass.ClearArgs(effectLogicArgs)
    end
  end
end

function SubSkillProjectile:_End()
  if not self.args[10] then
    return
  end
  self.args[1].End(self)
  self:Destroy()
end

function SubSkillProjectile:DoConstruct(asArray, args)
  self.args[1] = args[1]
  self.args[2] = args[2]
  self.args[3] = args[3]
  self.args[4] = args[4]
  self.args[5] = VectorUtility.TryAsign_3(self.args[5], args[6])
  self.args[6] = args[7]
  self.args[7] = args[8]
  self.args[12] = args[12]
  local hitWorker = self.args[3]
  hitWorker:AddRef()
  hitWorker:Delay()
  local creature = FindCreature(hitWorker:GetFromGUID())
  local skillInfo = hitWorker:GetSkillInfo()
  self.args[9] = skillInfo:GetHitEP(creature)
  local effectPath, lodLevel, priority, effectType = skillInfo:GetEmitEffectPath(creature)
  if effectPath == nil and args[2].effect_logic == nil then
    hitWorker:SetFromPosition(self:GetEndPosition())
    hitWorker:Work(self.args[6], self.args[7], self.args[4])
    self:Destroy()
    return
  end
  local startPosition = args[5] or self:GetHitPosition()
  self.args[8] = Asset_Effect.PlayAt(effectPath, startPosition, nil, nil, nil, lodLevel, priority, effectType)
  if self.args[12] then
    self.args[8]:ResetLocalScaleXYZ(self.args[12], self.args[12], self.args[12])
  end
  self:_Start(creature, skillInfo)
end

function SubSkillProjectile:DoDeconstruct(asArray)
  local args = self.args
  args[1].Deconstruct(self)
  args[3]:SubRef()
  if nil ~= args[5] then
    args[5]:Destroy()
    args[5] = nil
  end
  if nil ~= args[8] then
    args[8]:Destroy()
    args[8] = nil
  end
  if nil ~= args[11] then
    args[11]:Destroy()
    args[11] = nil
  end
  TableUtility.ArrayClearWithCount(args, 11)
end
