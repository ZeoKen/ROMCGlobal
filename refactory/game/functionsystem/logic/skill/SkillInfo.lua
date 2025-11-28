autoImport("Table_SkillEffect")
SkillInfo = class("SkillInfo")
local m_Table_Buffer
local _Table_Buffer = function(id)
  if not m_Table_Buffer then
    m_Table_Buffer = Table_Buffer
  end
  return m_Table_Buffer[id]
end
local SpecialCamp_Team = -1
local DamageType = CommonFun.DamageType
local CampMap = {
  Neutral = RoleDefines_Camp.NEUTRAL,
  Enemy = RoleDefines_Camp.ENEMY,
  Friend = RoleDefines_Camp.FRIEND,
  Team = SpecialCamp_Team
}
local pointTargetLargeLaunchRange = 5
local LockSkillType = GameConfig.DirtyBuff.lock_skill_type
local LockSkillMap = {}
for k, v in pairs(LockSkillType) do
  LockSkillMap[v] = 1
end
local MaxSECountPerFrame = 1
local DefaultRangeNum = GameConfig.SkillFunc.MaxTargetCount
local SkillRangeDisplay = GameConfig.SkillRangeDisplay and GameConfig.SkillRangeDisplay.skillID
local SECount, SEFrame
local LimitSEPerFrame = function(creature, se)
  if creature == Game.Myself then
    return se
  end
  local frame = UnityFrameCount
  if SEFrame ~= frame then
    SECount = 0
  end
  SECount = SECount + 1
  SEFrame = frame
  if SECount > MaxSECountPerFrame then
    return nil
  end
  return se
end
local Priority = {
  S = 0,
  A = 1,
  B = 2
}
SkillInfo.EffectPriority = Priority
local FindCreature = SceneCreatureProxy.FindCreature
local GetEffectPriority = function(creature, effectType, targetCreature, camps)
  local myself = Game.Myself
  if effectType == Asset_Effect.EffectTypes.Hit then
    if targetCreature == myself then
      return Priority.A
    end
  elseif creature ~= nil then
    if creature == myself then
      return Priority.S
    end
    if creature:GetCreatureType() == Creature_Type.Npc then
      return creature.data:GetPriority() or Priority.S
    end
    if effectType == Asset_Effect.EffectTypes.Map and camps ~= nil then
      local camp = creature.data:GetCamp()
      local campEnemy = CampMap.Enemy
      local _ArrayFindIndex = TableUtility.ArrayFindIndex
      if camp == campEnemy and 0 < _ArrayFindIndex(camps, campEnemy) then
        return Priority.A
      end
      local campFriend = CampMap.Friend
      if camp == campFriend and (0 < _ArrayFindIndex(camps, campFriend) or 0 < _ArrayFindIndex(camps, CampMap.Team)) then
        return Priority.A
      end
    end
  end
  return Priority.B
end
SkillInfo.GetEffectPriority = GetEffectPriority
local GetDynamicSkillInfoAndProp = function(creature, staticData)
  local dynamicSkillInfo = creature and creature.data:GetDynamicSkillInfo(staticData.id)
  local dynamicSkillInfoProp = dynamicSkillInfo ~= nil and dynamicSkillInfo.props or nil
  return dynamicSkillInfo, dynamicSkillInfoProp
end
local GetSPCost = function(creature, staticData)
  local SpCost = staticData.SkillCost.sp or 0
  local props = creature and creature.data.props
  if nil ~= props and nil ~= SpCost then
    local SpCostPer = props:GetPropByName("SpCostPer"):GetValue()
    local RSpCost = props:GetPropByName("SpCost"):GetValue()
    local dynamicSkillInfo, dynamicSkillInfoProp = GetDynamicSkillInfoAndProp(creature, staticData)
    if dynamicSkillInfoProp ~= nil then
      SpCostPer = SpCostPer + dynamicSkillInfoProp:GetPropByName("SpCostPer"):GetValue()
      RSpCost = RSpCost + dynamicSkillInfoProp:GetPropByName("SpCost"):GetValue()
    end
    SpCost = math.max(0, SpCost * (1 + SpCostPer) + RSpCost)
  end
  local maxSpPer = staticData.SkillCost.maxspper
  if maxSpPer ~= nil then
    local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(staticData.id)
    if dynamicSkillInfo ~= nil then
      maxSpPer = maxSpPer + dynamicSkillInfo:GetMaxSpPer()
    end
    SpCost = math.max(0, props:GetPropByName("MaxSp"):GetValue() * maxSpPer / 100)
  end
  if SpCost == 0 and staticData.SkillCost.sp == nil and maxSpPer == nil then
    return nil
  end
  return SpCost
end
SkillInfo.GetSPCost = GetSPCost

function SkillInfo.Get_Origin_CTChange(creature, staticData)
  local props = creature.data.props
  local val1 = props and props:GetPropByName("Origin_CTChange"):GetValue() or 0
  local dynamicSkillInfo, dynamicSkillInfoProp = GetDynamicSkillInfoAndProp(creature, staticData)
  local val2 = dynamicSkillInfoProp and dynamicSkillInfoProp:GetPropByName("Origin_CTChange"):GetValue() or 0
  return val1 + val2
end

local GetCastTime = function(creature, staticData)
  if not creature then
    return 0
  end
  local castParams = staticData.Lead_Type
  local castTime = 0
  local castAllowInterrupted = false
  if nil ~= castParams then
    if SkillCastType.Physics == castParams.type then
      castTime = castParams.ReadyTime
      local dynamicSkillInfo, dynamicSkillInfoProp = GetDynamicSkillInfoAndProp(creature, staticData)
      if dynamicSkillInfo ~= nil then
        castTime = castTime + dynamicSkillInfo:GetChangeReady()
      end
      if castTime < 0 then
        castTime = 0
      end
      if creature and creature.data:NextSkillNoReady() and staticData.Logic_Param.reverseSkillNoReady ~= 1 then
        castTime = 0
      end
    elseif SkillCastType.Magic == castParams.type then
      local props = creature.data.props
      local CTChangePer = props:GetPropByName("CTChangePer"):GetValue()
      local CTChange = props:GetPropByName("CTChange"):GetValue()
      local CastSpd = props:GetPropByName("CastSpd"):GetValue()
      local CTFixedPer = props:GetPropByName("CTFixedPer"):GetValue()
      local CTFixed = props:GetPropByName("CTFixed"):GetValue()
      local Origin_CTChange = props:GetPropByName("Origin_CTChange"):GetValue()
      local dynamicSkillInfo, dynamicSkillInfoProp = GetDynamicSkillInfoAndProp(creature, staticData)
      if dynamicSkillInfoProp ~= nil then
        CTChangePer = CTChangePer + dynamicSkillInfoProp:GetPropByName("CTChangePer"):GetValue()
        CTChange = CTChange + dynamicSkillInfoProp:GetPropByName("CTChange"):GetValue()
        CastSpd = CastSpd + dynamicSkillInfoProp:GetPropByName("CastSpd"):GetValue()
        CTFixedPer = CTFixedPer + dynamicSkillInfoProp:GetPropByName("CTFixedPer"):GetValue()
        CTFixed = CTFixed + dynamicSkillInfoProp:GetPropByName("CTFixed"):GetValue()
        Origin_CTChange = Origin_CTChange + dynamicSkillInfoProp:GetPropByName("Origin_CTChange"):GetValue()
      end
      if CastSpd < 0 then
        CastSpd = 0
      end
      local fct = (castParams.FCT + Origin_CTChange) * (1 + CTChangePer) + CTChange - CastSpd
      if fct < 0 or creature.data:NoFCT() then
        fct = 0
      end
      local fixedCCT = castParams.CCT + CTFixed
      if fixedCCT < 0 then
        fixedCCT = 0
      end
      local cct = fixedCCT * (1 + CTFixedPer)
      if cct < 0 then
        cct = 0
      end
      castTime = cct + fct
      if creature.data:NextSkillNoReady() and staticData.Logic_Param.reverseSkillNoReady ~= 1 then
        castTime = 0
      end
    elseif SkillCastType.Lead == castParams.type then
      castTime = castParams.duration
      castAllowInterrupted = true
    elseif SkillCastType.Guide == castParams.type then
      local props = creature.data.props
      local DChangePer = props:GetPropByName("DChangePer"):GetValue()
      local DChange = props:GetPropByName("DChange"):GetValue()
      local dynamicSkillInfo, dynamicSkillInfoProp = GetDynamicSkillInfoAndProp(creature, staticData)
      if nil ~= dynamicSkillInfoProp then
        DChangePer = DChangePer + dynamicSkillInfoProp:GetPropByName("DChangePer"):GetValue()
        DChange = DChange + dynamicSkillInfoProp:GetPropByName("DChange"):GetValue()
      end
      if not castParams.DCT and castParams.clientinterrupt then
        castTime = 9999999999
      else
        castTime = (castParams.DCT + DChange) * (1 + DChangePer)
        if castTime < 0 then
          castTime = 0
        end
      end
    end
  end
  return castTime, castAllowInterrupted
end
SkillInfo.GetCastTime = GetCastTime
local mapMode = 1

function SkillInfo.SetMapMode(mode)
  mapMode = mode
end

function SkillInfo:ctor(staticData, LogicClass)
  self.staticData = staticData
  self.LogicClass = LogicClass or autoImport("SkillLogic_None")
  self.speakName = staticData.NameZh and staticData.NameZh .. "!!" or nil
  local logicParam = staticData.Logic_Param or {}
  self.logicParam = logicParam
  self.emit = logicParam.emit
  local hide_target_damage_num = self.logicParam.hide_target_damage_num
  if hide_target_damage_num and #hide_target_damage_num ~= 0 then
    self.hideDamgeNumTargets = {}
    for i = 1, #hide_target_damage_num do
      self.hideDamgeNumTargets[hide_target_damage_num[i]] = true
    end
  end
  self.rotateOnly = nil
  if logicParam.chant_buff then
    local buffId, buffEffect
    for i = 1, #logicParam.chant_buff do
      buffId = logicParam.chant_buff[i]
      buffEffect = _Table_Buffer(buffId) and _Table_Buffer(buffId).BuffEffect
      if buffEffect and buffEffect.rotateonly then
        self.rotateOnly = true
        break
      end
    end
  end
  local campStrs = StringUtil.Split(staticData.Camps, "|")
  if nil ~= campStrs and 0 < #campStrs then
    local camps = {}
    for i = 1, #campStrs do
      local camp = CampMap[campStrs[i]]
      TableUtility.ArrayPushBack(camps, camp)
    end
    self.camps = camps
    self.campsOnlyEnemy = 1 == #camps and RoleDefines_Camp.ENEMY == camps[1]
    self.campsOnlyTeam = 1 == #camps and SpecialCamp_Team == camps[1]
    self.campsOnlyFriend = 1 == #camps and RoleDefines_Camp.FRIEND == camps[1]
  end
  self.buffs = {
    {},
    {}
  }
  if nil ~= staticData.Buff then
    local buffMap = staticData.Buff
    local selfBuffs = {}
    if nil ~= buffMap.self then
      local buffs = buffMap.self
      for i = 1, #buffs do
        selfBuffs[#selfBuffs + 1] = buffs[i]
      end
    end
    if nil ~= buffMap.self_skill then
      local buffs = buffMap.self_skill
      for i = 1, #buffs do
        selfBuffs[#selfBuffs + 1] = buffs[i]
      end
    end
    if 0 < #selfBuffs then
      self.buffs[1].selfBuffs = selfBuffs
    end
    self.buffs[1].teamBuffs = buffMap.team
  end
  if nil ~= staticData.Pvp_buff then
    local buffMap = staticData.Pvp_buff
    local selfBuffs = {}
    if nil ~= buffMap.self then
      local buffs = buffMap.self
      for i = 1, #buffs do
        selfBuffs[#selfBuffs + 1] = buffs[i]
      end
    end
    if nil ~= buffMap.self_skill then
      local buffs = buffMap.self_skill
      for i = 1, #buffs do
        selfBuffs[#selfBuffs + 1] = buffs[i]
      end
    end
    if 0 < #selfBuffs then
      self.buffs[2].selfBuffs = selfBuffs
    end
    self.buffs[2].teamBuffs = buffMap.team
  end
  self.effectsPath = {}
  self.effectsPathMap = {}
  local effectConfig = Table_SkillEffect[staticData.id]
  if effectConfig ~= nil then
    local effectsPath = self.effectsPath
    effectsPath[1] = effectConfig.E_Cast
    effectsPath[2] = effectConfig.E_Attack
    effectsPath[3] = effectConfig.E_Fire
    effectsPath[4] = effectConfig.E_Hit
    effectsPath[5] = effectConfig.E_Miss
    effectsPath[6] = effectConfig.E_CastLock
    local effectsPathMap = self.effectsPathMap
    effectsPathMap.effect = effectConfig.LP_Effect
    effectsPathMap.point_effect = effectConfig.LP_Point_Effect
    effectsPathMap.reading_effect = effectConfig.LP_Reading_Effect
    effectsPathMap.main_hit_effect = effectConfig.LP_Main_Hit_Effect
    effectsPathMap.treatment_hit_effect = effectConfig.LP_Treatment_Hit_Effect
    effectsPathMap.trap_effect = effectConfig.LP_Trap_Effect
    effectsPathMap.pre_attack_effect = effectConfig.LP_Pre_Attack_Effect
    effectsPathMap.interval_effect = effectConfig.LP_Interval_Effect
    effectsPathMap.center_effect = effectConfig.LP_Center_Effect
    effectsPathMap.center_warn_effect = effectConfig.LP_Center_Warn_Effect
    if nil ~= self.emit then
      self.emitEffectPath = effectConfig.LP_Emit
      self.emitLogicEffectPath = effectConfig.LP_Emit_Logic
    end
  end
  self.sesPath = {
    StringUtil.Split(staticData.SE_cast, "-"),
    StringUtil.Split(staticData.SE_attack, "-"),
    StringUtil.Split(staticData.SE_fire, "-"),
    StringUtil.Split(staticData.SE_hit, "-"),
    StringUtil.Split(staticData.SE_miss, "-"),
    StringUtil.Split(staticData.SE_bg, "-")
  }
  local targetFilter = staticData.TargetFilter
  if targetFilter then
    local classes = targetFilter.classID
    if classes then
      self.targetfilterClassIDMap = {}
      for i = 1, #classes do
        self.targetfilterClassIDMap[classes[i]] = 1
      end
    end
    local npcs = targetFilter.npcID
    if npcs then
      self.targetfilterNpcIDMap = {}
      for i = 1, #npcs do
        self.targetfilterNpcIDMap[npcs[i]] = 1
      end
    end
  end
  self.specialEffectHandler = {
    random_interval_effect = {
      _GetEffectPath = self.GetRandomIntervalEffect
    }
  }
end

function SkillInfo:GetEffectPath(creature, paths, effectType, targetCreature)
  if nil == paths then
    return nil
  end
  if SceneFilterProxy.Instance:MaskSkillEffect() then
    return nil
  end
  effectType = effectType or self:IsMapSkill() and Asset_Effect.EffectTypes.Map or nil
  local priority = GetEffectPriority(creature, effectType, targetCreature, self.camps)
  local path, lodLevel, scale = Game.EffectManager:GetEffectPath(paths, priority, effectType)
  return path, lodLevel, priority, effectType, scale
end

function SkillInfo:IsMapSkill()
  return self.logicParam.isCountTrap == 1 or self.logicParam.isTimeTrap == 1
end

function SkillInfo:GetSkillID(creature)
  return self.staticData.id
end

function SkillInfo:GetSkillType(creature)
  return self.staticData.SkillType
end

function SkillInfo:IsNormalAttack(creature)
  return 1 == self.staticData.Launch_Type
end

function SkillInfo:IsMagicType()
  return self.staticData.RollType == 2
end

function SkillInfo:IsPhyType()
  return self.staticData.RollType == 1
end

function SkillInfo:GetLeadType()
  return self.staticData and self.staticData.Lead_Type
end

function SkillInfo:CanClientInterrupt()
  return self.staticData and self.staticData.Lead_Type and self.staticData.Lead_Type.clientinterrupt == 1
end

function SkillInfo:GetChant_can_use_skill(creature)
  local staticInfo = self.staticData.Logic_Param and self.staticData.Logic_Param.chant_can_use_skill
  if staticInfo then
    return staticInfo
  end
  if not creature or not creature.data then
    return false
  end
  local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
  if dynamicSkillInfo ~= nil then
    local skills = dynamicSkillInfo:GetChantCanUseSkill()
    if skills and 0 < #skills then
      return skills
    end
  end
  return false
end

function SkillInfo:GetWuDi()
  if not Game.MapManager:IsPVPMode() then
    return self.staticData.Logic_Param and self.staticData.Logic_Param.notcontroled or nil
  end
  return false
end

function SkillInfo:CanUseOtherSkill(skillId, creature)
  local chant_can_use_skill = self:GetChant_can_use_skill(creature)
  if not chant_can_use_skill then
    return false
  end
  skillId = skillId // 1000
  for i = 1, #chant_can_use_skill do
    if chant_can_use_skill[i] == skillId then
      return true
    end
  end
  return false
end

function SkillInfo:ShowMagicCrit(creature)
  return not self:IsNormalAttack(creature) and 1 ~= self.staticData.RollType
end

function SkillInfo:IsEarthMagic(creature)
  if creature.data:GetNoEarthSkill(self.staticData.id) then
    return false
  end
  local logicParam = self.logicParam
  if logicParam.fieldarea_cannot_immune == 1 then
    return false
  end
  local skillType = self:GetSkillType()
  return logicParam.isCountTrap == 1 or logicParam.isTimeTrap == 1 or skillType == SkillType.TrapSkill or skillType == SkillType.HellPlant
end

function SkillInfo:NoEarthMagic()
  return self.logicParam.no_earth_magic == 1
end

function SkillInfo:IsElementTrap(creature)
  return self:GetSkillType(creature) == SkillType.ElementTrap
end

function SkillInfo:NoElementTrap(creature)
  return self.logicParam.clear_element_trap == 1
end

function SkillInfo:GetSpeakName(creature)
  return self.speakName
end

function SkillInfo:NoSpeak(creature)
  return self.logicParam.noSpeak == 1 or not creature:IsDressEnable()
end

function SkillInfo:GetAutoCondition(creature)
  return self.staticData.AutoCondition
end

function SkillInfo:GetSelfBuffs(creature)
  return self.buffs[mapMode].selfBuffs
end

function SkillInfo:GetTeamBuffs(creature)
  return self.buffs[mapMode].teamBuffs
end

function SkillInfo:GetSelectBuffs(creature)
  return self.logicParam.select_buff_ids
end

function SkillInfo:NoTargetAutoCast(creature)
  return 1 == self.staticData.NoTargetAutoCast
end

function SkillInfo:NoAttackWait(creature)
  return "Buff" == self.staticData.SkillType
end

function SkillInfo:IsMountTransform(creature)
  return "RideReform" == self.staticData.SkillType
end

function SkillInfo:NoWait(creature)
  return 1 == self.staticData.AttackStatus
end

function SkillInfo:GetTargetType(creature)
  return self.LogicClass.TargetType
end

function SkillInfo:GetEmitParams(creature)
  return self.emit
end

function SkillInfo:GetPreLaunchParams(creature)
  return self.logicParam.pre_launch
end

function SkillInfo:GetPreAttackParams(creature)
  return self.logicParam.pre_attack
end

function SkillInfo:GetAttackEP(creature)
  return self.staticData.Attack_EP or 0
end

function SkillInfo:GetFireEP(creature)
  if self.logicParam.random_ep then
    local random_ep = self.logicParam.random_ep
    return random_ep[math.random(#random_ep)] or 0
  else
    return self.staticData.Fire_EP or 0
  end
end

function SkillInfo:GetFireEPWeapon()
  return self.staticData.Fire_EP_Weapon
end

function SkillInfo:GetFollowWeaponEp()
  return self.logicParam.follow_weapon_ep == 1
end

function SkillInfo:GetHitEP(creature)
  return self.staticData.Target_EP or 0
end

function SkillInfo:GetCastLockEP(creature)
  return self.staticData.CastLock_EP or 0
end

function SkillInfo:GetPreAttackEffectEP(creature)
  if nil == self.logicParam.pre_attack then
    return 0
  end
  return self.logicParam.pre_attack.effect_ep or 0
end

function SkillInfo:GetPreAttackJumpSpdRate(creature)
  local preAttack = self.logicParam.pre_attack
  if preAttack == nil then
    return
  end
  return preAttack.jumpSpdRate
end

function SkillInfo:GetPreAttackJumpSpdLimit(creature)
  local preAttack = self.logicParam.pre_attack
  if preAttack == nil then
    return
  end
  return preAttack.jumpSpdLimit
end

function SkillInfo:GetPreAttackJumpTime(creature)
  local preAttack = self.logicParam.pre_attack
  if preAttack == nil then
    return
  end
  return preAttack.jumpTime
end

function SkillInfo:GetCastEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if not self:IgnoreEffectCulling(creature) and not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  if self:IsHideInShadowViel() and Game.Myself.data:IsInShadowViel() then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.CastEffect)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig)
  end
  local paths = self.effectsPath[1]
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetCastLockEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  return self:GetEffectPath(creature, EffectMap.Maps.LockOn)
end

function SkillInfo:GetCastLockConfigEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local paths = self.effectsPath[6]
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetCastPointEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if self:GetSkillType(creature) == SkillType.LeadSkill then
    return nil
  end
  if self.logicParam.noReadingEffect == 1 then
    return nil
  end
  local paths = self.effectsPathMap.reading_effect
  if nil ~= paths then
    return self:GetEffectPath(creature, paths), false
  end
  if RoleDefines_Camp.ENEMY == creature.data:GetCamp() then
    return self:GetEffectPath(creature, EffectMap.Maps.MagicCircleEnemy), true
  end
  return self:GetEffectPath(creature, EffectMap.Maps.MagicCircleAlly), true
end

function SkillInfo:GetPointEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local paths = self.effectsPathMap.point_effect
  if paths ~= nil then
    return self:GetEffectPath(creature, paths)
  end
  return self:GetEffectPath(creature, EffectMap.Maps.MagicCircleAlly)
end

function SkillInfo:GetPointEffectSize(creature)
  return self.LogicClass.GetPointEffectSize(self, creature)
end

function SkillInfo:IsPointEffectTrack()
  return self.LogicClass.PointEffectTrack ~= nil
end

function SkillInfo:PointEffectTrack(creature, effect, point)
  local func = self.LogicClass.PointEffectTrack
  if func ~= nil then
    func(self, creature, effect, point)
    return true
  end
  return false
end

function SkillInfo:GetAttackEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.AttackEffect)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig)
  end
  local paths = self.effectsPath[2]
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:AttackEffectOnRole(creature)
  return 1 == self.staticData.E_Attack_On
end

function SkillInfo:GetFireEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.E_fire)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig)
  end
  local paths = self.effectsPath[3]
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetFirePointEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.LP_Effect)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig)
  end
  local paths = self.effectsPathMap.effect
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetHitEffectPath(creature, targetCreature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if creature == nil then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.HitEffect)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig, Asset_Effect.EffectTypes.Hit, targetCreature)
  end
  local paths = self.effectsPath[4]
  if paths == nil then
    return nil
  end
  return self:GetEffectPath(creature, paths, Asset_Effect.EffectTypes.Hit, targetCreature)
end

function SkillInfo:GetDefaultHitEffectPath(creature, damageType, targetCreature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if creature == nil then
    return nil
  end
  if DamageType.Crit == damageType then
    return self:GetEffectPath(creature, EffectMap.Maps.CriticalHit, Asset_Effect.EffectTypes.Hit, targetCreature)
  end
  return self:GetEffectPath(creature, EffectMap.Maps.NormalHit, Asset_Effect.EffectTypes.Hit, targetCreature)
end

function SkillInfo:GetEffectInfoByPhase(creature, effectPhase)
  if creature == nil then
    return nil, -1, nil, nil
  end
  local paths
  if self.specialEffectHandler[effectPhase] then
    local GetEffectPath = self.specialEffectHandler[effectPhase]._GetEffectPath
    return GetEffectPath(self, creature)
  end
  paths = self.effectsPathMap[effectPhase] or {}
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetMainHitEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local paths = self.effectsPathMap.main_hit_effect
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetTreatmentHitEffectPath(creature, targetCreature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local paths = self.effectsPathMap.treatment_hit_effect
  return self:GetEffectPath(creature, paths, Asset_Effect.EffectTypes.Hit, targetCreature)
end

function SkillInfo:GetTrapEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.LP_TrapEffect)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig)
  end
  local paths = self.effectsPathMap.trap_effect
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetPreAttackEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local paths = self.effectsPathMap.pre_attack_effect
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetEmitEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local dynamicConfig = self:GetDynamicConfig(creature, SkillDynamicManager.Config.LP_EmitEffect)
  if dynamicConfig ~= nil then
    return self:GetEffectPath(creature, dynamicConfig)
  end
  local paths = self.emitEffectPath
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetEmitLogicEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local paths = self.emitLogicEffectPath
  return self:GetEffectPath(creature, paths)
end

function SkillInfo:GetBlockHitEffectInfo(creature, targetCreature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil, nil
  end
  local HarmImmune = targetCreature.data:GetProperty("HarmImmune")
  if nil ~= HarmImmune and 0 < HarmImmune then
    local harmImmuneInfo = Game.Config_BuffStateOdds[HarmImmune]
    if nil ~= harmImmuneInfo and nil ~= harmImmuneInfo.Effect then
      return self:GetEffectPath(creature, harmImmuneInfo.Effect, Asset_Effect.EffectTypes.Hit, targetCreature), harmImmuneInfo.EP
    end
  end
  return nil, nil
end

function SkillInfo:GetSpecialAttackEffects(creature)
  return self.staticData.AttackEffects
end

function SkillInfo:GetSpecialFireEffects(creature)
  return self.staticData.FireEffects
end

function SkillInfo:GetSpecialHitEffects(creature)
  return self.staticData.HitEffects
end

function SkillInfo:_GetSEPath(creature, index)
  local paths = self.sesPath[index]
  if nil ~= paths then
    local pathLen = #paths
    if 1 < pathLen then
      local p = RandomUtil.Range(1, pathLen)
      p = RandomUtil.RoundInt(p)
      return paths[p]
    else
      return paths[1]
    end
  end
  return nil
end

function SkillInfo:GetCastSEPath(creature)
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  return LimitSEPerFrame(creature, self:_GetSEPath(creature, 1))
end

function SkillInfo:GetAttackSEPath(creature)
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local path = self:_GetSEPath(creature, 2)
  if nil ~= path then
    if "None" == path then
      return nil
    end
    return LimitSEPerFrame(creature, path)
  end
  local weaponID = creature.assetRole:GetWeaponID()
  if 0 ~= weaponID then
    local weaponInfo = Table_Equip[weaponID]
    if nil ~= weaponInfo then
      local se = weaponInfo.SE_attack
      if se ~= "" then
        return LimitSEPerFrame(creature, se)
      end
    end
  end
  return nil
end

function SkillInfo:GetFireSEPath(creature)
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  local path = self:_GetSEPath(creature, 3)
  if nil ~= path then
    if "None" == path then
      return nil
    end
    return LimitSEPerFrame(creature, path)
  end
  local weaponID = creature.assetRole:GetWeaponID()
  if 0 ~= weaponID then
    local weaponInfo = Table_Equip[weaponID]
    if nil ~= weaponInfo then
      local se = weaponInfo.SE_fire
      if se ~= "" then
        return LimitSEPerFrame(creature, se)
      end
    end
  end
  return nil
end

local tempCalcDamageParams = {}

function SkillInfo:GetHitSEPath(creature, weaponID, damageType, element)
  if damageType == DamageType.Crit then
    return LimitSEPerFrame(creature, AudioMap.Maps.CriticalHit)
  end
  local path = self:_GetSEPath(creature, 4)
  if nil ~= path then
    if "None" == path then
      return nil
    end
    return LimitSEPerFrame(creature, path)
  end
  local damage = self.staticData.Damage[1]
  if damage ~= nil then
    if element == nil then
      element = damage.elementparam
      if element == nil and creature ~= nil then
        tempCalcDamageParams.skillIDAndLevel = self:GetSkillID()
        element = CommonFun.GetUserAtkAttr(creature.data, tempCalcDamageParams, damage)
      end
    end
    if element ~= nil then
      local paths = GameConfig.SkillCommon.ElementHitSE[element]
      if paths ~= nil then
        path = paths[math.random(#paths)]
        return LimitSEPerFrame(creature, path), element
      end
    end
  end
  if (nil == weaponID or 0 == weaponID) and nil ~= creature then
    weaponID = creature.assetRole:GetWeaponID()
  end
  if 0 ~= weaponID then
    local weaponInfo = Table_Equip[weaponID]
    if nil ~= weaponInfo then
      local se = weaponInfo.SE_hit
      if se ~= "" then
        return LimitSEPerFrame(creature, se)
      end
    end
  end
  return LimitSEPerFrame(creature, AudioMap.Maps.DefaultHit)
end

function SkillInfo:GetMissSEPath(creature)
  return LimitSEPerFrame(creature, self:_GetSEPath(creature, 5))
end

function SkillInfo:GetBgSEPath(creature)
  return LimitSEPerFrame(creature, self:_GetSEPath(creature, 6))
end

function SkillInfo:GetHitSEDelay(creature)
  return self.staticData.SE_HitDelay
end

function SkillInfo:GetCastAction(creature)
  return self.staticData.CastAct
end

function SkillInfo:GetAttackAction(creature)
  local attackAct = self.staticData.AttackAct
  local length = #attackAct
  return 0 < length and attackAct[math.random(length)] or ""
end

function SkillInfo:GetEndAction(creature)
  return self.staticData.EndAct
end

function SkillInfo:GetPointAction(creature)
  return self.staticData.PointAct
end

function SkillInfo:GetLaunchRange(creature)
  local launchRange = self.staticData.Launch_Range
  if nil ~= creature and nil ~= creature.data and launchRange then
    local props = creature.data.props
    if nil ~= props then
      local AtkDistancePer = props:GetPropByName("AtkDistancePer"):GetValue()
      local AtkDistance = props:GetPropByName("AtkDistance"):GetValue()
      local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
      local dynamicSkillInfoProp = dynamicSkillInfo ~= nil and dynamicSkillInfo.props or nil
      if dynamicSkillInfoProp ~= nil then
        AtkDistancePer = AtkDistancePer + dynamicSkillInfoProp:GetPropByName("AtkDistancePer"):GetValue()
        AtkDistance = AtkDistance + dynamicSkillInfoProp:GetPropByName("AtkDistance"):GetValue()
      end
      launchRange = launchRange * (1 + AtkDistancePer) + AtkDistance
      local initrange, addrange = creature.data:GetInitLaunchRangeMoreThenAdd()
      if initrange ~= nil and initrange < self.staticData.Launch_Range then
        launchRange = launchRange + addrange
      end
      if launchRange < 0 then
        launchRange = 0
      end
    end
    if self:GetTargetType(creature) == SkillTargetType.Point and creature.data:NextPointTargetSkillLargeLaunchRange() then
      launchRange = launchRange + pointTargetLargeLaunchRange
    end
    if self:IsLockTargetSkill(creature) and creature.data:NextTargetSkillLargeLaunchRange() then
      launchRange = 9999
    end
  end
  local extraRange = 0
  if creature == Game.Myself then
    local lockTarget = Game.Myself:GetLockTarget()
    local guid, _ = MyselfProxy.Instance:GetTargetAndPos()
    if guid == (lockTarget and lockTarget.data.id) then
      extraRange = Game.Myself.data:CheckTrackTargetEffect(self.staticData.id // 1000)
    end
  end
  local finalRange = (launchRange or 0) + extraRange
  local tempRange = 0
  local rangeSkillID = self.logicParam.launch_range_as_skill
  if rangeSkillID and self.staticData.id ~= rangeSkillID then
    local rangeSkillInfo = Game.LogicManager_Skill:GetSkillInfo(rangeSkillID)
    tempRange = rangeSkillInfo:GetLaunchRange(creature)
  end
  if creature then
    local shrinkTo = creature:GetMinShrinkRange()
    if shrinkTo and 0 < shrinkTo then
      if 0 < tempRange then
        tempRange = math.max(finalRange, tempRange)
      else
        tempRange = math.min(finalRange, shrinkTo)
      end
    end
  end
  local resultRange = math.max(finalRange, tempRange)
  local targetCreature = Game.Myself:GetLockTarget()
  local hasMark = MyselfProxy.Instance:CheckInMarks(self.staticData.id, targetCreature and targetCreature.data and targetCreature.data.id)
  if hasMark then
    resultRange = resultRange * (1 + MyselfProxy.Instance:GetMarkParam(targetCreature))
  end
  return resultRange
end

function SkillInfo:NoAction(creature)
  return 1 == self.logicParam.no_action
end

function SkillInfo:NoSelect(creature)
  local logicName = self.staticData.Logic
  if (1 == self.logicParam.no_select or self.logicParam.SortByMinHpPercent == 1) and logicName ~= "SkillTargetPoint" and logicName ~= "MultiLockedTarget" and logicName ~= "SkillTargetBehindRect" and logicName ~= "SkillTargetRect" then
    return true
  end
  if self.logicParam.Search_SignAssassinate == 1 then
    return false
  end
  if Game.MapManager:IsNoSelectTarget() and ("SkillSelfRange" == logicName or "SkillForwardRect" == logicName or "SkillPointRange" == logicName or "SkillPointRect" == logicName or "SkillDirectionRect" == logicName) then
    return true
  end
  return false
end

function SkillInfo:NoHit(creature, damageType)
  if 1 == self.logicParam.no_hit then
    return true
  end
  if creature and creature.IsFakeDead and creature:IsFakeDead() then
    return true
  end
  return DamageType.None == damageType or DamageType.Miss == damageType or DamageType.Treatment == damageType or DamageType.Treatment_Sp == damageType or DamageType.Barrier == damageType or DamageType.Block == damageType or DamageType.WeaponBlock == damageType
end

function SkillInfo:NoHitEffectMove(creature, damageType, damage)
  if nil ~= creature and creature.data:NoHitEffectMove() then
    return true
  end
  if nil ~= creature and creature.data:IsPippi() and creature.data:GetUpID() ~= 0 then
    return true
  end
  if nil ~= creature and creature.data and creature.data:GetDownID() ~= 0 then
    local downCreature = FindCreature(creature.data:GetDownID())
    if downCreature and downCreature:GetCreatureType() == Creature_Type.Player then
      return true
    end
  end
  if DamageType.None == damageType or DamageType.Miss == damageType or DamageType.Treatment == damageType or DamageType.Treatment_Sp == damageType or DamageType.Barrier == damageType or DamageType.Block == damageType or DamageType.AutoBlock == damageType or DamageType.WeaponBlock == damageType then
    return true
  end
  if 1 ~= self.logicParam.zero_damage_hitback and 0 == damage then
    return true
  end
  return false
end

function SkillInfo:NoAttackEffectMove(creature)
  if nil ~= creature and creature.data and creature.data:GetDownID() ~= 0 then
    local downCreature = FindCreature(creature.data:GetDownID())
    if downCreature and downCreature:GetCreatureType() == Creature_Type.Player then
      return true
    end
  end
  return nil ~= creature and creature.data:NoAttackEffectMove()
end

function SkillInfo:NoRepelMajor(creature)
  return 1 == self.logicParam.no_repel_major
end

function SkillInfo:GetFireCount(creature)
  return self.logicParam.fire_count or 1
end

function SkillInfo:GetFireInterval()
  return self.logicParam.fire_interval
end

function SkillInfo:TargetIncludeSelf(creature)
  return 1 == self.logicParam.include_self
end

function SkillInfo:TargetExcludeSelf(creature)
  return self.logicParam.exclude_self == 1
end

function SkillInfo:IsTrap()
  return 1 == self.logicParam.isCountTrap or 1 == self.logicParam.isNpcTrap or 1 == self.logicParam.isTimeTrap
end

function SkillInfo:TargetIncludeTeamRange(creature)
  return self.logicParam.team_range or 0
end

function SkillInfo:TargetIncludeHide(creature)
  return self.logicParam.select_hide == 1
end

function SkillInfo:CheckTeamPriority()
  if self.logicParam.team_priority == 1 then
    return true
  end
  if self:TargetIncludeTeamRange() > 0 then
    return false
  end
  if not self.campsOnlyFriend then
    return false
  end
  local buffs = self:GetTeamBuffs()
  return buffs and 0 < #buffs
end

function SkillInfo:GetTargetsMaxCount(creature)
  local logicParam_range_num = self.logicParam.range_num
  if not logicParam_range_num then
    local logicName = self.staticData.Logic
    if "SkillSelfRange" == logicName then
      logicParam_range_num = DefaultRangeNum
    elseif "SkillTargetBehindRect" == logicName then
      logicParam_range_num = 1
    elseif "SkillTargetRect" == logicName then
      logicParam_range_num = 1
    end
  end
  local range_num = logicParam_range_num or 999
  local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
  if dynamicSkillInfo ~= nil and dynamicSkillInfo:GetTargetNumChange() ~= 0 then
    range_num = logicParam_range_num or 0
    range_num = range_num + dynamicSkillInfo:GetTargetNumChange()
    if range_num < 0 then
      range_num = 0
    end
  end
  return range_num
end

function SkillInfo:GetTargetRange(creature)
  local range = self.logicParam.range or self.logicParam.multi_range and self.logicParam.multi_range[1] or 0
  local dynamicSkillInfo = creature.data:GetDynamicSkillInfo(self.staticData.id)
  if dynamicSkillInfo ~= nil then
    range = range + dynamicSkillInfo:GetTargetRange()
  end
  return range
end

function SkillInfo:GetTargetForwardRect(creature, offset, size)
  size[1] = self.logicParam.width
  size[2] = self.logicParam.distance
  offset[1] = 0
  offset[2] = size[2] / 2 + self.logicParam.forward_offset or 0
end

function SkillInfo:GetTargetRect(creature, offset, size)
  size[1] = self.logicParam.width
  size[2] = self.logicParam.distance
  offset[1] = 0
  offset[2] = 0
end

function SkillInfo:GetTargetAction(creature)
  return self.logicParam.target_action
end

function SkillInfo:PlaceTarget(creature)
  return 1 == self.logicParam.place_target
end

function SkillInfo:SelectLockedTarget(creature)
  return 1 == self.logicParam.select_target
end

function SkillInfo:GetDamageCount(creature, targetCreature, damageType, damage)
  local damageCount = 1
  if DamageType.ErLianJi == damageType then
    damageCount = 2
  else
    local damageCountInfo = self.staticData.DamTime
    if 1 == damageCountInfo.type then
      damageCount = damageCountInfo.value
    elseif 2 == damageCountInfo.type then
      local targetShape = targetCreature.data.shape
      if nil ~= targetShape then
        if CommonFun.Shape.S == targetShape then
          damageCount = damageCountInfo.value.S
        elseif CommonFun.Shape.M == targetShape then
          damageCount = damageCountInfo.value.M
        elseif CommonFun.Shape.L == targetShape then
          damageCount = damageCountInfo.value.L
        end
      end
    elseif damageCountInfo.type == 3 then
      local value = damageCountInfo.value
      local layer = creature and creature:GetBuffLayer(value.buffid) or 0
      if not value.calc then
        damageCount = layer + value.default
      else
        local calcParam = value.calc
        damageCount = CommonFun.calcBuffValue(creature.data, targetCreature.data, calcParam.type, calcParam.a, calcParam.b, calcParam.c, calcParam.d, layer, 0) or 0
      end
    end
  end
  if damage < damageCount then
    damageCount = damage
  end
  return damageCount
end

function SkillInfo:TargetOnlyEnemy(creature)
  return self.campsOnlyEnemy
end

function SkillInfo:TargetEnemy(creature)
  if nil == self.camps then
    return false
  end
  if self.campsOnlyEnemy then
    return true
  end
  if 0 == TableUtility.ArrayFindIndex(self.camps, RoleDefines_Camp.ENEMY) then
    return false
  end
  return true
end

function SkillInfo:TargetOnlyTeam(creature)
  return self.campsOnlyTeam
end

function SkillInfo:TargetInFilter(creature, targetCreature)
  return self:TargetInClassFilter(creature, targetCreature) or self:TargetInNpcFilter(creature, targetCreature)
end

function SkillInfo:TargetInClassFilter(creature, targetCreature)
  if self.targetfilterClassIDMap ~= nil then
    local classID = targetCreature.data:GetClassID()
    return self.targetfilterClassIDMap[classID] ~= nil
  end
  return false
end

function SkillInfo:TargetInNpcFilter(creature, targetCreature)
  local map = self.targetfilterNpcIDMap
  if map ~= nil and targetCreature:GetCreatureType() == Creature_Type.Npc then
    return map[targetCreature.data:GetStaticID()] ~= nil
  end
  return false
end

function SkillInfo:CheckCamps(creature, targetCreature)
  local camps = self.camps
  local includeFriendNPC = false
  if nil ~= camps then
    local targetCamp = targetCreature.data:GetCamp()
    includeFriendNPC = self:IncludeFriendNPC() and targetCreature.data:IsFriendNpc()
    if includeFriendNPC then
      local npcIDs = self.logicParam.friendnpcID
      local find = false
      if npcIDs then
        for i = 1, #npcIDs do
          if npcIDs[i] == targetCreature.data:GetStaticID() then
            find = true
            break
          end
        end
        if find then
          targetCamp = RoleDefines_Camp.FRIEND or targetCamp
        end
      else
        targetCamp = RoleDefines_Camp.FRIEND
      end
    end
    if creature ~= Game.Myself then
      return true
    end
    for i = 1, #camps do
      local c = camps[i]
      if targetCamp == c then
        return true
      elseif SpecialCamp_Team == c then
        if Game.Myself == creature then
          if targetCreature ~= creature and (targetCreature:IsInMyGroup() or includeFriendNPC) then
            return true
          end
        else
          return true
        end
      end
    end
    return false
  end
  return true
end

local DEAD_STATUS = 1
local INREVIVE_STATUS = 2

function SkillInfo:CheckSelectLife(targetCreature)
  local selectLife = self.logicParam and self.logicParam.select or 0
  if 1 <= selectLife and selectLife & 4 == 0 then
    if not targetCreature:IsDead() then
      return false
    end
    if targetCreature:IsInRevive() and 1 == selectLife then
      return false, 1
    end
  elseif targetCreature:IsDead() then
    return false
  end
  return true
end

function SkillInfo:CheckTarget(creature, targetCreature)
  local targetData = targetCreature.data
  if targetData:NoAttacked() then
    return false
  end
  if targetData:NoAccessable() and not self:TargetIncludeHide() then
    return false
  end
  if self:TargetInFilter(creature, targetCreature) then
    return false
  end
  if not self:CheckCamps(creature, targetCreature) then
    return false
  end
  local lifeCheck, reason = self:CheckSelectLife(targetCreature)
  if not lifeCheck then
    return false, 4, reason
  end
  if self:NoPreCheckTarget() then
    local isPippi = targetData and targetData:IsPippi()
    local IsMyPet = false
    if isPippi then
      IsMyPet = targetData.ownerID == (creature and creature.data and creature.data.id)
    end
    if (not targetData or not targetData:IsPlayer()) and not IsMyPet then
      return false
    end
    if targetData and targetData:IsPlayer() and targetData:IsInRide() then
      return false
    end
  end
  local targetCamp = targetCreature.data:GetCamp()
  if creature ~= targetCreature and (targetCamp == SpecialCamp_Team or targetCamp == RoleDefines_Camp.FRIEND) and (creature.data.excludeTeammate or targetCreature.data.excludeTeammate) then
    return false
  end
  if nil ~= self.logicParam then
    local notAllowedNPCType = self.logicParam.invalid_target_type
    if nil ~= notAllowedNPCType then
      local npcDetailedType = targetData.detailedType
      if npcDetailedType and npcDetailedType == notAllowedNPCType then
        return false
      end
    end
    if self:GetSkillType() == SkillType.Ensemble and self:CheckEnsembleSkill(creature, targetCreature) == false then
      return false
    end
  end
  local ignoreNoEnemyLock = creature.data.ignoreNoEnemyLocked
  if (targetData:CanNotBeSkillTargetByEnemy() or targetData:GetNoEnemyLocked() and not ignoreNoEnemyLock) and targetData:GetCamp() == RoleDefines_Camp.ENEMY then
    return false
  end
  return true
end

function SkillInfo:CheckEnsembleSkill(creature, targetCreature)
  local partnerSkillid = self.logicParam.partner_skillid
  if partnerSkillid ~= nil then
    local _TeamProxy = TeamProxy.Instance
    if not _TeamProxy:IHaveTeam() then
      return false
    end
    local member = _TeamProxy.myTeam:GetMemberByGuid(targetCreature.data.id)
    if member == nil then
      return false
    end
    local ensembleskill = member.ensembleskill
    if ensembleskill == nil or ensembleskill[partnerSkillid] == nil then
      return false
    end
  end
  local data = targetCreature.data
  if data:IsSolo() then
    return false
  end
  if not ISNoviceServerType and data:IsEnsemble() then
    return false
  end
  local weaponType = self.logicParam.weapon_type
  if weaponType ~= nil then
    local equipedWeaponType = data:GetEquipedWeaponType()
    local isEquiped = false
    for i = 1, #weaponType do
      if weaponType[i] == equipedWeaponType then
        isEquiped = true
        break
      end
    end
    if isEquiped == false then
      return false
    end
  end
  local range = self.logicParam.range
  if range ~= nil then
    local targetPos = targetCreature:GetPosition()
    local myPos = creature:GetPosition()
    if LuaVector3.Distance_Square(myPos, targetPos) > range * range then
      return false
    end
  end
  return true
end

function SkillInfo:IsChorus()
  return self.logicParam.isChorus == 1
end

function SkillInfo:IsGuideCast(creature)
  local castParams = self.staticData.Lead_Type
  return nil ~= castParams and SkillCastType.Guide == castParams.type
end

function SkillInfo:InfiniteCast(creature)
  local castParams = self.staticData.Lead_Type
  return nil ~= castParams and SkillCastType.Lead == castParams.type and 1 ~= castParams.no_infinite
end

function SkillInfo:IsIgnoreFreeCast(creature)
  return self.logicParam.ignoreFreeCast == 1
end

function SkillInfo:BokiBreakCast(creature)
  return self.logicParam.boki_break_skill
end

function SkillInfo:BreakDistance(creature)
  return self.logicParam.break_distance
end

function SkillInfo:GetCastInfo(creature)
  local staticData = self.staticData
  local castParams = staticData.Lead_Type
  if castParams ~= nil and castParams.type == SkillCastType.SubSkill and self:HasSubSkill() then
    local skillid = SkillProxy.Instance:GetCastSubSkillID(creature, staticData)
    if skillid ~= nil then
      local data = Table_Skill[skillid]
      if data ~= nil then
        return GetCastTime(creature, data)
      end
    end
  end
  return GetCastTime(creature, staticData)
end

function SkillInfo:GetLogicRealCD(creature)
  return self:GetCD(creature, true)
end

local GetSkillCD = function(creature, calLogicReal, staticData)
  local cd = staticData.CD or 0
  local logicRealCd = staticData.Logic_Param and staticData.Logic_Param.real_cd or nil
  if calLogicReal and logicRealCd then
    cd = logicRealCd
  end
  local props = creature and creature.data.props
  if props and cd then
    local CDChangePer = props:GetPropByName("CDChangePer"):GetValue()
    local CDChange = props:GetPropByName("CDChange"):GetValue()
    local CDChangePerWithBound = props:GetPropByName("CDChangePerWithBound"):GetValue()
    if staticData.FixCD and staticData.FixCD == 1 then
      CDChangePer = 0
      CDChange = 0
      CDChangePerWithBound = 0
    end
    local dynamicSkillInfo, dynamicSkillInfoProp = GetDynamicSkillInfoAndProp(creature, staticData)
    if dynamicSkillInfoProp ~= nil then
      CDChangePer = CDChangePer + dynamicSkillInfoProp:GetPropByName("CDChangePer"):GetValue()
      CDChange = CDChange + dynamicSkillInfoProp:GetPropByName("CDChange"):GetValue()
    end
    local bound = GameConfig.Attr and GameConfig.Attr.CDChangePerBound
    if bound and CDChangePer > bound then
      if CDChangePer < 0 and bound > CDChangePer + CDChangePerWithBound then
        CDChangePer = bound
      else
        CDChangePer = CDChangePer + CDChangePerWithBound
      end
    end
    local extraCD = creature.data:GetSkillExtraCD() / 1000
    cd = cd * (1 + CDChangePer) + CDChange + extraCD
  end
  if cd == 0 and staticData.CD == nil then
    return nil
  end
  return cd
end
SkillInfo.GetSkillCD = GetSkillCD

function SkillInfo:GetCD(creature, calLogicReal)
  return GetSkillCD(creature, calLogicReal, self.staticData)
end

function SkillInfo:GetDelayCD(creature)
  local specialType = self.staticData.Logic_Param and self.staticData.Logic_Param.special_type
  if specialType and specialType == "knight" then
    return 0
  end
  local cd = self.staticData.DelayCD or 0
  local props = creature and creature.data.props
  if nil ~= props and nil ~= cd then
    local CDChangePer = props:GetPropByName("DelayCDChangePer"):GetValue()
    local CDChange = props:GetPropByName("DelayCDChange"):GetValue()
    local dynamicSkillInfo, dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)
    if dynamicSkillInfoProp ~= nil then
      CDChangePer = CDChangePer + dynamicSkillInfoProp:GetPropByName("DelayCDChangePer"):GetValue()
      CDChange = CDChange + dynamicSkillInfoProp:GetPropByName("DelayCDChange"):GetValue()
    end
    cd = cd * (1 + CDChangePer) + CDChange
    if cd < 0 then
      cd = 0
    end
  end
  if cd == 0 and self.staticData.DelayCD == nil then
    return nil
  end
  return cd
end

function SkillInfo:GetSP(creature)
  return GetSPCost(creature, self.staticData)
end

function SkillInfo:GetHP(creature)
  local HpCost = self.staticData.SkillCost.hp or 0
  local props = creature and creature.data.props
  if nil ~= props and nil ~= HpCost and nil ~= props:GetPropByName("HpCost") then
    local HpCostPer = props:GetPropByName("HpCostPer"):GetValue()
    local RHpCost = props:GetPropByName("HpCost"):GetValue()
    local dynamicSkillInfo, dynamicSkillInfoProp = self:_GetDynamicSkillInfoAndProp(creature)
    if dynamicSkillInfoProp ~= nil then
      HpCostPer = HpCostPer + dynamicSkillInfoProp:GetPropByName("HpCostPer"):GetValue()
      RHpCost = RHpCost + dynamicSkillInfoProp:GetPropByName("HpCost"):GetValue()
    end
    HpCost = HpCost * (1 + HpCostPer) + RHpCost
  end
  if HpCost == 0 and self.staticData.SkillCost.hp == nil then
    return nil
  end
  return HpCost
end

function SkillInfo:TeamFirst(creature)
  return 1 == self.logicParam.team_first
end

function SkillInfo:_GetDynamicSkillInfoAndProp(creature)
  return GetDynamicSkillInfoAndProp(creature, self.staticData)
end

function SkillInfo:GetWarnRingSize(creature, inputSize)
  if not self:IsTrap() then
    inputSize.x = 0
    inputSize.y = 0
  else
    local logicName = self.staticData.Logic
    if "SkillForwardRect" == logicName or "SkillPointRect" == logicName then
      inputSize.x = self.logicParam.width or 0
      inputSize.y = self.logicParam.distance or 0
    else
      local range = self:GetTargetRange(creature)
      inputSize.x = range * 2
      inputSize.y = range * 2
    end
  end
  return inputSize
end

function SkillInfo:AllowAttackInterrupted()
  if not GameConfig.SystemForbid.BetterFight then
    return false
  end
  return self.logicParam.allowAttackInterrupted == 1
end

function SkillInfo:IgnoreEffectCulling(creature)
  return self.logicParam.ignoreEffectCulling == 1
end

function SkillInfo:NoLimitFire(creature)
  if self:GetSkillType(creature) == SkillType.LeadSkill then
    return self.logicParam.noLimitFire == 1
  end
  return false
end

function SkillInfo:IsSkillDirectionRect(creature)
  return self.staticData.Logic == "SkillDirectionRect"
end

function SkillInfo:HasSubSkill()
  return self.logicParam.sub_skill_count ~= nil
end

function SkillInfo:CheckHideTargetDamgeNum(targetCreature)
  if self.hideDamgeNumTargets == nil then
    return false
  end
  if not (targetCreature and targetCreature.data) or not targetCreature.data.staticData then
    return false
  end
  local staticID = targetCreature.data.staticData.id
  if staticID then
    return self.hideDamgeNumTargets[staticID]
  end
  return false
end

function SkillInfo:GetDynamicConfig(creature, type)
  if creature == nil then
    return nil
  end
  return Game.SkillDynamicManager:GetDynamicConfig(creature.data.id, self.staticData.id, type)
end

function SkillInfo:NoIdleAttack(creature)
  return self.logicParam.noIdleAttack == 1
end

function SkillInfo:NoAttackSpeed()
  return self.logicParam.noAttackSpeed == 1
end

function SkillInfo:AllowConcurrent(creature)
  return self.logicParam.concurrent == 1 or creature and creature:GetAllowConcurrent(self.staticData.id)
end

function SkillInfo:NoMoveAction(creature)
  return self.logicParam.noMoveAction == 1
end

function SkillInfo:GetIndicatorRange(creature)
  if self.logicParam.multi_range then
    return self.logicParam.multi_range[1]
  end
  if not self.LogicClass or not self.LogicClass.GetIndicatorRange then
    return (self:GetLaunchRange(creature) or 0) * 2
  end
  return self.LogicClass.GetIndicatorRange(self, creature) or 0
end

function SkillInfo:GetShowLength(creature)
  if not self.LogicClass or not self.LogicClass.GetShowLength then
    return (self:GetLaunchRange(creature) or 0) * 2
  end
  return self.LogicClass.GetShowLength(self, creature)
end

function SkillInfo:GetDistance()
  return self.logicParam.distance
end

function SkillInfo:CheckShowIndicator()
  return self.logicParam.ShowIndicator == 1
end

function SkillInfo:CheckInstantAttack()
  return self.logicParam.moveRunChant == 1
end

function SkillInfo:IsRandomSelect()
  return 1 == self.logicParam.randomSelect
end

function SkillInfo:NeedPassiveFire()
  local logicName = self.staticData.Logic
  return self.logicParam.passive_fire == 1 or "MultiLockedTarget" == logicName
end

function SkillInfo:NoChant(creature)
  return self.logicParam.noChant == 1 or not creature:IsDressEnable()
end

function SkillInfo:NoReadingEffect()
  return self.logicParam.noReadingEffect == 1
end

function SkillInfo:ManulDestroy()
  if self.logicParam.manulDestroy == 1 then
    return true
  end
  local logicName = self.staticData.Logic
  return logicName == "SkillMeToPointRect" and self:AttackEffectOnRole()
end

function SkillInfo:IsOneShotTrap()
  return self.logicParam.oneShotTrap == 1
end

function SkillInfo:NoSkillDelay()
  return self.logicParam.no_skill_delay == 1
end

function SkillInfo:ShowWarningEffect()
  return self.logicParam.ShowWarningEffect ~= nil
end

function SkillInfo:GetWarnRingEffectPath(creature)
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  if Game.Myself.data:IsInShadowViel() then
    return nil
  end
  return self:GetEffectPath(creature, EffectMap.Maps.WarnRing)
end

function SkillInfo:CanShiftPoint()
  return self.logicParam.canShiftPoint == 1
end

function SkillInfo:IsHeavyHit()
  return self.logicParam.ignoreHit == 1
end

function SkillInfo:FollowUser()
  return self.logicParam.follow_user == 1
end

function SkillInfo:GetHideDamage()
  return self.logicParam.hideClientDamage == 1
end

function SkillInfo:IsIgnoreTerrain()
  if not self.staticData.AttackEffects then
    return false
  end
  if self.staticData.AttackEffects[1] then
    return self.staticData.AttackEffects[1].ignoreTerrain == 1
  end
end

function SkillInfo:IsLastHitOnly()
  if not self.staticData.HitEffects then
    return false
  end
  if self.staticData.HitEffects[1] then
    return self.staticData.HitEffects[1].only_last_hit == 1
  end
  return false
end

function SkillInfo:GetTargetBehindRect(creature, offset, size)
  size[1] = self.logicParam.width
  size[2] = self.logicParam.behind_distance + (self.logicParam.back_distance or 0)
  offset[1] = 0
  offset[2] = 0
end

function SkillInfo:GetBackDistance()
  return self.logicParam.back_distance
end

function SkillInfo:GetComboConditionSkill()
  return self.logicParam.comboConditionSkill
end

function SkillInfo:GetResetComboID()
  return self.logicParam.ResetComboID
end

function SkillInfo:GetPriorityNpcIDs()
  return self.logicParam.prior_npcids
end

function SkillInfo:CheckCanBeInterrupted()
  if not GameConfig.SystemForbid.BetterFight then
    return true
  end
  return self.logicParam.CanBeInterrupted == 1
end

function SkillInfo:GetRotateOnly()
  return self.rotateOnly
end

function SkillInfo:GetAttackUIEffectPath()
  return self.logicParam.Attack_UIEffect
end

function SkillInfo:IgnoreNoHit()
  return 1 == self.logicParam.ignore_no_hit_back
end

function SkillInfo:OnlyRepelMajor()
  return 1 == self.logicParam.only_repel_major
end

function SkillInfo:NoHitEffect()
  return self.logicParam.no_hit_effect == 1
end

function SkillInfo:IncludeFriendNPC()
  return self.logicParam.include_friendnpc == 1
end

function SkillInfo:GetFashionCastAct(creature)
  if creature and creature.data then
    local userdata = creature.data.userdata
    local sex = userdata:Get(UDEnum.SEX)
    if not sex or sex == 0 then
      return nil
    end
    local class = userdata:Get(UDEnum.PROFESSION)
    if not class or class == 0 then
      return nil
    end
    if not Table_Class[class] then
      return nil
    end
    local bodyID = sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
    local curbodyID = userdata:Get(UDEnum.BODY)
    if bodyID ~= curbodyID then
      return self.staticData.FashionCastAct
    end
  end
  return nil
end

function SkillInfo:GetFashionAttackAct(creature)
  if creature and creature.data then
    local userdata = creature.data.userdata
    local sex = userdata:Get(UDEnum.SEX)
    if not sex or sex == 0 then
      return nil
    end
    local class = userdata:Get(UDEnum.PROFESSION)
    if not class or class == 0 then
      return nil
    end
    if not Table_Class[class] then
      return nil
    end
    local bodyID = sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
    local curbodyID = userdata:Get(UDEnum.BODY)
    if bodyID ~= curbodyID then
      return self.staticData.FashionAttackAct
    end
  end
  return nil
end

function SkillInfo:GetCheckDis()
  return self.logicParam.break_dis
end

function SkillInfo:ShowReplaceEffect()
  return self.logicParam.show_replace_effect
end

function SkillInfo:GetEffectInterval()
  return self.logicParam.attackEffect_interval
end

function SkillInfo:GetIntervalEffect(creature)
  return self:GetAttackEffectPath(creature)
end

function SkillInfo:CheckCamps_Friend()
  local camps = self.camps
  if camps then
    for i = 1, #camps do
      local c = camps[i]
      if c == RoleDefines_Camp.FRIEND then
        return true
      end
    end
    return false
  end
  return true
end

function SkillInfo:HasRandomIntervalEffect()
  return self.logicParam.random_interval_effect and self.logicParam.random_interval_effect ~= _EmptyTable
end

function SkillInfo:GetRandomIntervalEffect(creature)
  if not self:HasRandomIntervalEffect() then
    return nil
  end
  if Game.HandUpManager:IsInHandingUp() then
    return nil
  end
  local random_interval_effect = self.logicParam.random_interval_effect
  local length = #self.logicParam.random_interval_effect
  local randomIndex = math.random(length)
  local effectPath = random_interval_effect[randomIndex]
  effectPath = Table_EffectLodPaths[effectPath]
  return self:GetEffectPath(creature, effectPath)
end

function SkillInfo:GetCastParams(creature)
  return self.logicParam.pre_cast
end

function SkillInfo:GetPreCastEffectPath()
  local pre_cast = self.logicParam.pre_cast
  if pre_cast then
    return pre_cast.cast_end_effect
  end
end

function SkillInfo:GetHideBody()
  return self.logicParam.pre_attack and self.logicParam.pre_attack.hidebody
end

function SkillInfo:GetExtraEffectPath()
  local pre_attack = self.logicParam.pre_attack
  if pre_attack then
    return pre_attack.extraEffect
  end
end

function SkillInfo:GetSwitchEffectPath()
  return self.logicParam.switch_effect
end

function SkillInfo:NoBetterFight()
  return self.logicParam.noBetterFight == 1
end

function SkillInfo:IsSelfStartTrap()
  return self.logicParam.self_start_trap
end

function SkillInfo:OnlyMainTarget()
  local logicName = self.staticData.Logic
  return "SkillTargetBehindRect" == logicName or "SkillTargetRect" == logicName or "MultiLockedTarget" == logicName
end

function SkillInfo:BuffSkillEffect()
  return self.logicParam.buff_skill_effect == 1
end

function SkillInfo:CheckEmitTarget()
  local logicName = self.staticData.Logic
  return "MultiLockedTarget" == logicName
end

function SkillInfo:AffectedByAtkSpd()
  return self.logicParam.AffectedByAtkSpd == 1
end

function SkillInfo:IsFakeNormalAtk()
  return self.logicParam.fake_normalAtk ~= nil
end

local roundOff = function(num, n)
  if 0 < n then
    local scale = math.pow(10, n - 1)
    return math.floor(num / scale + 0.5) * scale
  elseif n < 0 then
    local scale = math.pow(10, n)
    return math.floor(num / scale + 0.5) * scale
  elseif n == 0 then
    return num
  end
end
local fact = 1000

function SkillInfo:_Float1(value, _fact)
  local res = math.abs(value)
  res = roundOff(res, 1) / _fact
  res = math.floor(res * 100) / 100
  if value < 0 then
    return -res
  end
  return res
end

local aroundZero = 1 / math.pow(10, 1)

function SkillInfo:GetLaunchRange_Delta(creature)
  local dynamicRange = self:GetLaunchRange(creature)
  local staticRange = self.staticData.Launch_Range
  if staticRange and dynamicRange then
    if 0 < dynamicRange or 0 < staticRange then
      staticRange = roundOff(staticRange, -3)
      dynamicRange = roundOff(dynamicRange, -3)
      local fixed = roundOff(dynamicRange - staticRange, -3)
      if staticRange == dynamicRange or math.abs(fixed) < aroundZero then
        return 0
      else
        fixed = dynamicRange * fact - staticRange * fact
        return self:_Float1(fixed, fact)
      end
    end
  else
    return
  end
end

function SkillInfo:IsLockTargetSkill(creature)
  local skilltype = self.staticData.Logic
  return skilltype and LockSkillMap[skilltype]
end

function SkillInfo:PlayAttackEffect()
  return 1 == self.logicParam.no_action_need_effect
end

function SkillInfo:IsKnightSkill()
  local specialType = self.logicParam.special_type
  return specialType and specialType == "knight"
end

function SkillInfo:IsMoveBreakSkill()
  return self.logicParam.moveBreakSkill == 1
end

function SkillInfo:UseMarkPoint()
  return self.logicParam.use_mark_point == 1
end

function SkillInfo:NeedMarkPoint()
  return self.logicParam.need_mark_point == 1
end

function SkillInfo:GetAtkEffectHideBody()
  if not self.staticData.AttackEffects then
    return false
  end
  if self.staticData.AttackEffects[1] then
    return self.staticData.AttackEffects[1].hidebody == 1
  end
end

function SkillInfo:FireAttackEffect()
  return self.logicParam.fire_attackEffect == 1
end

function SkillInfo:AutoLaunch()
  return self.logicParam.autoLaunch == 1
end

function SkillInfo:GetAutoLaunchAngle()
  return self.logicParam.autoLaunchAngle
end

function SkillInfo:CheckReplaceMap()
  return self.logicParam.checkReplaceMap == 1
end

function SkillInfo:IsArc()
  return self.logicParam.shape == "arc"
end

function SkillInfo:GetAdjustAttackDuration(creature)
  return self.rotateOnly or "RideShoulder" == self.staticData.SkillType or "SwitchRide" == self.staticData.SkillType
end

function SkillInfo:UseJoystickDir(creature)
  return self.logicParam.Use_Joystick_Dir
end

function SkillInfo:GetProjectileHitSEPath(creature)
  if not self.logicParam.Hit_SE then
    return nil
  end
  if not SkillLogic_Base.AllowSelfEffect(creature) then
    return nil
  end
  return LimitSEPerFrame(creature, self.logicParam.Hit_SE)
end

function SkillInfo:UseTargetPos()
  return self.logicParam.Use_Target_Pos == 1
end

function SkillInfo:GetPointEffect_SideEffect()
  return self.logicParam.pe_sideEffect, self.logicParam.pe_sideEffect_ep
end

function SkillInfo:CheckCamps_FriendorTeam()
  local camps = self.camps
  if camps then
    for i = 1, #camps do
      local c = camps[i]
      if c == RoleDefines_Camp.FRIEND or c == SpecialCamp_Team then
        return true
      end
    end
    return false
  end
  return true
end

function SkillInfo:IsSpecialInterruptSkill()
  return self.logicParam.isSpecialInterruptSkill == 1
end

function SkillInfo:IsAllSuperUse()
  return self.logicParam.allSuperUse == 1
end

local AliniaBodyConfig = GameConfig.Alinia_SkillConfig and GameConfig.Alinia_SkillConfig.bodyid

function SkillInfo:CheckBody(targetCreature)
  if not targetCreature then
    return
  end
  if "RideShoulder" ~= self.staticData.SkillType and "SwitchRide" ~= self.staticData.SkillType then
    return true
  end
  local targetCreatureData = targetCreature.data
  local buffeffect = targetCreatureData:GetBuffEffectByType(BuffType.PartTransform)
  if (not buffeffect or not buffeffect.Body) and not targetCreatureData:IsTransformed() then
    return true
  end
  local taregtUserdata = targetCreatureData.userdata
  local targetBody = taregtUserdata and taregtUserdata:Get(UDEnum.BODY)
  return targetBody and AliniaBodyConfig[targetBody] == 1
end

function SkillInfo:NoPreCheckTarget()
  if "RideShoulder" == self.staticData.SkillType then
    return true
  end
end

function SkillInfo:IsHideInShadowViel()
  return self.logicParam.HideInShadowViel == 1
end

function SkillInfo:GetForceDelay()
  return self.logicParam.force_delay_time
end

function SkillInfo:GetCheckBufftType()
  return self.logicParam.checkBuffType
end

function SkillInfo:NoActionNeedFire()
  return 1 == self.logicParam.no_action_need_fire
end

function SkillInfo:SearchSignAssassinate()
  return self.logicParam.Search_SignAssassinate == 1
end

function SkillInfo:HasCustomWarningEffect()
  return self.logicParam.displayWarningEffect
end

function SkillInfo:GetCustomWarningEffectPath()
  return self.logicParam.displayWarningEffect, self.logicParam.displayRange
end

function SkillInfo:UseLeadUIEffect()
  return self.logicParam.leadUIEffect == 1
end
