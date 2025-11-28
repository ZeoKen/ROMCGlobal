SkillPhaseData = class("SkillPhaseData", ReusableObject)
SkillPhaseData.PoolSize = 200
local S2C_Number = ProtolUtility.S2C_Number
local C2S_Number = ProtolUtility.C2S_Number
local ArrayShallowCopy = TableUtility.ArrayShallowCopy
local TableShallowCopy = TableUtility.TableShallowCopy
local ArrayClear = TableUtility.ArrayClear
local TableClear = TableUtility.TableClear
local _Table_Skill
local arrayCount = 5
local CreateShareDamageInfos = function(origin, infos)
  if nil ~= origin and 0 < #origin then
    if nil == infos then
      infos = ReusableTable.CreateArray()
    end
    local shareDamageCount = #origin
    infos[1] = shareDamageCount
    local shareIndex = 1
    for i = 1, shareDamageCount do
      local shareDamageInfo = origin[i]
      infos[shareIndex + 1] = shareDamageInfo.charid
      infos[shareIndex + 2] = shareDamageInfo.type
      infos[shareIndex + 3] = shareDamageInfo.damage
      shareIndex = shareIndex + 3
    end
  elseif nil ~= infos then
    DestroyShareDamageInfos(infos)
    infos = nil
  end
  return infos
end
local DestroyShareDamageInfos = function(infos)
  if nil ~= infos then
    ReusableTable.DestroyArray(infos)
  end
end

function SkillPhaseData.Create(args)
  return ReusableObject.Create(SkillPhaseData, true, args)
end

function SkillPhaseData:ctor()
  if not _Table_Skill then
    _Table_Skill = Table_Skill
  end
  self.data = {
    0,
    0,
    nil,
    nil,
    0,
    0
  }
  self.gopos = {}
  self.hitedTarget_gopos = {}
  SkillPhaseData.super.ctor(self)
  self.isTrigger = false
  self.emit_targets = {}
end

function SkillPhaseData:ToServerData(msg, creature, targetCreatureGUID)
  local data = msg.data
  msg.skillID = self:GetSkillID()
  local skillPhase = self:GetSkillPhase()
  data.number = skillPhase
  local pos = self:GetPosition() or creature:GetPosition()
  if nil ~= pos then
    ProtolUtility.C2S_Vector3(pos, data.pos)
  end
  local dir = self:GetAngleY() or creature:GetAngleY()
  if nil ~= dir then
    data.dir = math.floor(C2S_Number(GeometryUtils.UniformAngle(dir)))
  end
  local targetsCount = self:GetTargetCount()
  if 0 < targetsCount then
    for i = 1, targetsCount do
      local hit = SceneUser_pb.HitedTarget()
      hit.charid, hit.type, hit.damage = self:GetTarget(i)
      if CommonFun.DamageType.Treatment == hit.type then
        hit.type = CommonFun.DamageType.Normal
        hit.damage = -hit.damage
      elseif CommonFun.DamageType.Treatment_Sp == hit.type then
        hit.type = CommonFun.DamageType.Normal_Sp
        hit.damage = -hit.damage
      end
      local hitedPos = self.hitedTarget_gopos[hit.charid]
      if hitedPos then
        hit.gopos.x = math.floor(hitedPos[1] * 1000)
        hit.gopos.y = math.floor(hitedPos[2] * 1000)
        hit.gopos.z = math.floor(hitedPos[3] * 1000)
      end
      table.insert(data.hitedTargets, hit)
    end
  elseif (SkillPhase.Cast == skillPhase or SkillPhase.FreeCast == skillPhase) and nil ~= targetCreatureGUID and 0 ~= targetCreatureGUID then
    local hit = SceneUser_pb.HitedTarget()
    hit.charid, hit.type, hit.damage = targetCreatureGUID, 0, 0
    local hitedPos = self.hitedTarget_gopos[hit.charid]
    if hitedPos then
      hit.gopos.x = math.floor(hitedPos[1] * 1000)
      hit.gopos.y = math.floor(hitedPos[2] * 1000)
      hit.gopos.z = math.floor(hitedPos[3] * 1000)
    end
    table.insert(data.hitedTargets, hit)
  end
  if self.gopos[1] then
    msg.gopos.x = math.floor(self.gopos[1][1] * 1000)
    msg.gopos.y = math.floor(self.gopos[1][2] * 1000)
    msg.gopos.z = math.floor(self.gopos[1][3] * 1000)
  end
  if self.actionName ~= nil then
    msg.actionname = self.actionName
  end
end

function SkillPhaseData:ParseFromServer(msg, force)
  local data = force and msg or msg and msg.data
  if not data then
    return
  end
  self:SetSkillPhase(data.number)
  local pos = data.pos
  self:SetPositionXYZ(S2C_Number(pos.x), S2C_Number(pos.y), S2C_Number(pos.z))
  self:SetAngleY(S2C_Number(data.dir))
  self:SetIsLastHit(data.last_hit)
  if not force then
    self:SetCastTime(S2C_Number(msg.chanttime))
  end
  self:ClearTargets()
  self.use_stiffaction = msg.stiffaction == 1
  self.is_client_use = msg.is_client_use == true
  if nil ~= data.hitedTargets then
    local hit
    for i = 1, #data.hitedTargets do
      hit = data.hitedTargets[i]
      if hit.is_emit_target then
        self:AddEmitTarget(hit.charid)
      end
      if 0 > hit.damage then
        if CommonFun.DamageType.Normal_Sp == hit.type or CommonFun.DamageType.Treatment_Sp == hit.type then
          self:AddTarget(hit.charid, CommonFun.DamageType.Treatment_sp, -hit.damage, hit.shareTargets)
        else
          self:AddTarget(hit.charid, CommonFun.DamageType.Treatment, -hit.damage, hit.shareTargets)
        end
      else
        self:AddTarget(hit.charid, hit.type, hit.damage, hit.shareTargets)
      end
      if hit.gopos and (hit.gopos.x ~= 0 or hit.gopos.y ~= 0 or hit.gopos.z ~= 0) then
        local hitEffect = self:GetSpecialHitEffect()
        if hitEffect then
          self:AddHitedTargetPos(hit.gopos.x / 1000, hit.gopos.y / 1000, hit.gopos.z / 1000, hitEffect.speed, hitEffect.direction, hit.charid)
        end
      end
    end
  end
  self:ClearGoPos()
  if msg.gopos and (msg.gopos.x ~= 0 or msg.gopos.y ~= 0 or msg.gopos.z ~= 0) then
    local atkEffect = self:GetDirectionAttackEffect()
    if atkEffect then
      self:AddGoPos(msg.gopos.x / 1000, msg.gopos.y / 1000, msg.gopos.z / 1000, atkEffect.speed, atkEffect.direction)
    end
  end
  if msg.actionname ~= "" then
    self.actionName = msg.actionname
  end
end

function SkillPhaseData:Clone()
  local newData = SkillPhaseData.Create(self.data[1])
  self:CopyTo(newData)
  return newData
end

function SkillPhaseData:Reset(skillID)
  self.data[1] = skillID
  self.data[2] = SkillPhase.None
  self:ClearTargets()
  self:ClearGoPos()
  self.data[6] = 0
  self.isTrigger = false
  self.isLastHit = false
  self.actionName = nil
  self:ClearEmitTarget()
  self.use_stiffaction = nil
end

function SkillPhaseData:CopyTo(to)
  local fromData = self.data
  local toData = to.data
  toData[1] = fromData[1]
  toData[2] = fromData[2]
  toData[3] = VectorUtility.TryAsign_3(toData[3], fromData[3])
  toData[4] = fromData[4]
  toData[5] = fromData[5]
  toData[6] = fromData[6]
  toData[7] = fromData[7]
  local targetCount = fromData[6]
  if 0 < targetCount then
    local index = 6
    for i = 1, targetCount do
      toData[index + 1] = fromData[index + 1]
      toData[index + 2] = fromData[index + 2]
      toData[index + 3] = fromData[index + 3]
      local shareDamageInfos = fromData[index + 4]
      if nil ~= shareDamageInfos and 0 < #shareDamageInfos then
        local toShareDamageInfos = toData[index + 4]
        if nil == toShareDamageInfos then
          toShareDamageInfos = ReusableTable.CreateArray()
          toData[index + 4] = toShareDamageInfos
        end
        TableUtility.ArrayShallowCopyWithCount(toShareDamageInfos, shareDamageInfos, shareDamageInfos[1] * 3 + 1)
      else
        DestroyShareDamageInfos(toData[index + 4])
        toData[index + 4] = nil
      end
      toData[index + 5] = fromData[index + 5]
      index = index + arrayCount
    end
  end
  to:ClearHitedTarget_GoPos()
  TableShallowCopy(to.hitedTarget_gopos, self.hitedTarget_gopos)
  to:ClearGoPos()
  ArrayShallowCopy(to.gopos, self.gopos)
  to.actionName = self.actionName
  to:ClearEmitTarget()
  TableShallowCopy(to.emit_targets, self.emit_targets)
  to.use_stiffaction = self.use_stiffaction
end

function SkillPhaseData:GetDirectionAttackEffect()
  if not self.data[1] then
    return
  end
  local sData = _Table_Skill[self.data[1]]
  if not sData then
    return
  end
  local attackEffects = sData.AttackEffects
  for _, effect in pairs(attackEffects) do
    if effect.type == 1 then
      return effect
    end
  end
  local preattack = sData.Logic_Param.pre_attack
  if preattack ~= nil and preattack.type == 4 then
    return preattack
  end
  return nil
end

function SkillPhaseData:GetSpecialHitEffect()
  if not self.data[1] then
    return
  end
  local sData = _Table_Skill[self.data[1]]
  if not sData then
    return
  end
  local hitEffects = sData.HitEffects
  if not hitEffects then
    return
  end
  return hitEffects[1]
end

function SkillPhaseData:GetSkillID()
  return self.data[1]
end

function SkillPhaseData:GetSkillPhase()
  return self.data[2]
end

function SkillPhaseData:SetSkillPhase(phase)
  self.data[2] = phase
end

function SkillPhaseData:GetPosition()
  return self.data[3]
end

function SkillPhaseData:GetPositionClone()
  return self.data[3] and LuaVector3.Better_Clone(self.data[3]) or nil
end

function SkillPhaseData:SetPosition(p)
  if nil ~= self.data[3] then
    LuaVector3.Better_Set(self.data[3], p[1], p[2], p[3])
  else
    self.data[3] = LuaVector3.Better_Clone(p)
  end
end

function SkillPhaseData:SamplePosition(p)
  if nil ~= self.data[3] then
    NavMeshUtility.SelfSample(self.data[3])
  end
end

function SkillPhaseData:SetPositionXYZ(x, y, z)
  if nil ~= self.data[3] then
    LuaVector3.Better_Set(self.data[3], x, y, z)
  else
    self.data[3] = LuaVector3.New(x, y, z)
  end
end

function SkillPhaseData:GetAngleY()
  return self.data[4]
end

function SkillPhaseData:SetAngleY(v)
  self.data[4] = v
end

function SkillPhaseData:GetCastTime()
  return self.data[5]
end

function SkillPhaseData:SetCastTime(v)
  self.data[5] = v
end

function SkillPhaseData:AddTarget(guid, damageType, damage, shareDamageInfos, damageCount)
  local data = self.data
  local targetCount = data[6]
  local index = 6 + targetCount * arrayCount
  targetCount = targetCount + 1
  data[6] = targetCount
  data[index + 1] = guid
  data[index + 2] = damageType
  data[index + 3] = damage
  data[index + 4] = CreateShareDamageInfos(shareDamageInfos, data[index + 4])
  data[index + 5] = damageCount
end

function SkillPhaseData:GetTargetCount()
  return self.data[6]
end

function SkillPhaseData:GetTarget(index)
  local data = self.data
  index = 6 + (index - 1) * arrayCount
  return data[index + 1], data[index + 2], data[index + 3], data[index + 4], data[index + 5]
end

function SkillPhaseData:SetTarget(index, guid, damageType, damage, shareDamageInfos, damageCount)
  local data = self.data
  index = 6 + (index - 1) * arrayCount
  data[index + 1] = guid
  data[index + 2] = damageType
  data[index + 3] = damage
  data[index + 4] = CreateShareDamageInfos(shareDamageInfos, data[index + 4])
  data[index + 5] = damageCount
end

function SkillPhaseData:ClearTargets()
  local data = self.data
  local targetCount = data[6]
  data[6] = 0
  if 0 < targetCount then
    local index = 6
    for i = 1, targetCount do
      DestroyShareDamageInfos(data[index + 4])
      data[index + 4] = nil
      index = index + arrayCount
    end
  end
  self:ClearHitedTarget_GoPos()
end

function SkillPhaseData:ClearGoPos()
  ArrayClear(self.gopos)
end

function SkillPhaseData:ClearHitedTarget_GoPos()
  TableClear(self.hitedTarget_gopos)
end

function SkillPhaseData:AddGoPos(x, y, z, speed, direction)
  table.insert(self.gopos, {
    x,
    y,
    z,
    speed,
    direction
  })
end

function SkillPhaseData:GetGoPos()
  return self.gopos
end

function SkillPhaseData:AddHitedTargetPos(x, y, z, speed, direction, targetId)
  self.hitedTarget_gopos[targetId] = {
    x,
    y,
    z,
    speed,
    direction
  }
end

function SkillPhaseData:GetHitedTargetPos()
  return self.hitedTarget_gopos
end

function SkillPhaseData:SetIsTrigger(v)
  self.isTrigger = v
end

function SkillPhaseData:GetIsTrigger()
  return self.isTrigger
end

function SkillPhaseData:SetIsLastHit(v)
  self.isLastHit = v
end

function SkillPhaseData:GetIsLastHit(v)
  return self.isLastHit
end

function SkillPhaseData:GetForceServerDamage()
  if not self.data[1] then
    return false
  end
  local sData = _Table_Skill[self.data[1]]
  if not sData then
    return false
  end
  local LogicParam = sData.Logic_Param
  if not LogicParam then
    return false
  end
  local logicName = sData.Logic
  if "SkillTargetBehindRect" == logicName or "SkillTargetRect" == logicName or "MultiLockedTarget" == logicName then
    return true
  end
  return LogicParam.force_service_damage == 1
end

function SkillPhaseData:IsSkipBreak()
  if not self.data[1] then
    return false
  end
  local sData = _Table_Skill[self.data[1]]
  if not sData then
    return false
  end
  local LogicParam = sData.Logic_Param
  if not LogicParam then
    return false
  end
  return LogicParam.skip_break == 1
end

function SkillPhaseData:SetActionName(name)
  self.actionName = name
end

function SkillPhaseData:GetActionName()
  return self.actionName
end

function SkillPhaseData:BuffSkillEffect()
  if not self.data[1] then
    return false
  end
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(self.data[1])
  if skillinfo then
    return skillinfo:BuffSkillEffect()
  end
end

function SkillPhaseData:AddEmitTarget(charid)
  self.emit_targets[charid] = true
end

function SkillPhaseData:IsEmitTarget(charid)
  return self.emit_targets[charid]
end

function SkillPhaseData:GetEmitTarget()
  return self.emit_targets
end

function SkillPhaseData:ClearEmitTarget()
  TableClear(self.emit_targets)
end

function SkillPhaseData:IsClientUse()
  return self.is_client_use
end

function SkillPhaseData:DoConstruct(asArray, args)
  self:Reset(args)
end

function SkillPhaseData:DoDeconstruct(asArray)
  if nil ~= self.data[3] then
    LuaVector3.Destroy(self.data[3])
    self.data[3] = nil
  end
  self.data[4] = nil
  self:ClearTargets()
  self:ClearGoPos()
  self.isTrigger = false
  self.isLastHit = false
  self.actionName = nil
  self:ClearEmitTarget()
end
