autoImport("BehaviourData")
autoImport("AttrEffect")
CreatureData = class("CreatureData", ReusableObject)
CreatureData.MoveSpeedFactor = 3.5
CreatureData.RotateSpeedFactor = 720
CreatureData.ScaleSpeedFactor = 1
CreatureData.ShapeIndex = {
  [1] = "S",
  [2] = "M",
  [3] = "L"
}
local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
local CullingIDUtility = CullingIDUtility
local ArrayRemove = TableUtility.ArrayRemove
local DestroyArray = ReusableTable.DestroyArray
local MaxStateEffect = 0
for k, v in pairs(CommonFun.StateEffect) do
  if v > MaxStateEffect then
    MaxStateEffect = v
  end
end
local ExtraAttackSkill = {}
for k, v in pairs(GameConfig.NormalSerialSkills.skills) do
  for i = 1, #v do
    ExtraAttackSkill[v[i]] = 1
  end
end
local FakeAttackSkillSequence = {}
for k, v in pairs(GameConfig.AtkSpdSerialSkills.skills) do
  for i = 1, #v do
    FakeAttackSkillSequence[v[i]] = v[i + 1] or v[1]
  end
end

function CreatureData:ctor()
  CreatureData.super.ctor(self)
  self.id = nil
  self:SetCamp(RoleDefines_Camp.NEUTRAL)
  self.bodyScale = nil
  self.KickSkills = 0
  self.ExtraNormalSkills = {}
  for k, v in pairs(GameConfig.ExtraNormalSkills.skills) do
    self.ExtraNormalSkills[v] = true
  end
end

function CreatureData:GetHoldScale()
  return 1
end

function CreatureData:GetHoldDir()
  return 0
end

function CreatureData:GetHoldDirX()
  return 0
end

local defaultOffest = {}

function CreatureData:GetHoldOffset()
  return defaultOffest
end

function CreatureData:GetDefaultGear()
  return nil
end

function CreatureData:GetName()
  return nil
end

function CreatureData:SetCamp(camp)
  self.camp = camp
end

function CreatureData:GetCamp()
  return self.camp
end

function CreatureData:NoAccessable()
  return true
end

function CreatureData:NoPlayIdle()
  return false
end

function CreatureData:NoPlayShow()
  return false
end

function CreatureData:NoAutoAttack()
  return false
end

function CreatureData:GetGuid()
  return self.id
end

function CreatureData:GetFollowEP()
  return 0
end

function CreatureData:GetFollowType()
  return 0
end

function CreatureData:GetInnerRange()
  return 0
end

function CreatureData:GetOutterRange()
  return 0
end

function CreatureData:GetOutterHeight()
  return 0
end

function CreatureData:GetDampDuration()
  return 0
end

function CreatureData:ReturnMoveSpeedWithFactor(moveSpeed)
  return (moveSpeed or 1) * CreatureData.MoveSpeedFactor
end

function CreatureData:ReturnRotateSpeedWithFactor(rotateSpeed)
  return (rotateSpeed or 1) * CreatureData.RotateSpeedFactor
end

function CreatureData:ReturnScaleSpeedWithFactor(scaleSpeed)
  return (scaleSpeed or 1) * CreatureData.ScaleSpeedFactor
end

function CreatureData:GetClickPriority()
  local camp = self:GetCamp()
  if camp == RoleDefines_Camp.ENEMY then
    return 0
  elseif camp == RoleDefines_Camp.NEUTRAL then
    return 1
  elseif camp == RoleDefines_Camp.FRIEND then
    return 2
  end
  return 0
end

function CreatureData:SetDressEnable(v)
  self.dressEnable = v
end

function CreatureData:IsDressEnable()
  return self.dressEnable
end

function CreatureData:SetBaseLv(value)
  self.BaseLv = value
end

function CreatureData:AddPetID(petID)
  if self.petIDs == nil then
    self.petIDs = ReusableTable.CreateArray()
  end
  if TableUtility.ArrayFindIndex(self.petIDs, petID) < 1 then
    self.petIDs[#self.petIDs + 1] = petID
  end
end

function CreatureData:RemovePetID(petID)
  if self.petIDs ~= nil then
    TableUtility.ArrayRemove(self.petIDs, petID)
  end
end

function CreatureData:GetPetCount(type)
  if self.petIDs == nil then
    return 0
  end
  local count = 0
  local _NScenePetProxy = NScenePetProxy.Instance
  for i = 1, #self.petIDs do
    local pet = _NScenePetProxy:Find(self.petIDs[i])
    if pet ~= nil and pet.data:GetDetailedType() == type then
      count = count + 1
    end
  end
  return count
end

function CreatureData:GetPet_Pippi()
  local _NScenePetProxy = NScenePetProxy.Instance
  local pippiMap = _NScenePetProxy.pippiMap
  if pippiMap then
    local petID = pippiMap[self.id]
    if petID then
      local pet = _NScenePetProxy:Find(petID)
      return pet
    end
  end
end

function CreatureData:SpawnCullingID()
  self.cullingID = self.id
end

function CreatureData:ClearCullingID()
  self.cullingID = nil
end

function CreatureData:GetDefaultScale()
  return 1
end

function CreatureData:GetClassID()
  return 0
end

function CreatureData:IsOb()
  return false
end

function CreatureData:IsBeingPresent(beingID)
  local being = PetProxy.Instance:GetMyBeingNpcInfo(beingID)
  if being then
    return being:IsSummoned()
  end
  return false
end

function CreatureData:InGuildZone()
  return false
end

function CreatureData:InGvgZone()
  return false
end

function CreatureData:NoAttackMetal()
  return false
end

function CreatureData:GetFeature(bit)
  return false
end

function CreatureData:GetFeature_ChangeLinePunish()
  return false
end

function CreatureData:GetFeature_BeHold()
  return false
end

function CreatureData:OpenStormBossLucky()
  return false
end

function CreatureData:DoConstruct(asArray, parts)
  self.dressEnable = false
end

function CreatureData:DoDeconstruct(asArray)
  if self.petIDs ~= nil then
    ReusableTable.DestroyArray(self.petIDs)
    self.petIDs = nil
  end
  self:ClearCullingID()
end

CreatureDataWithPropUserdata = class("CreatureDataWithPropUserdata", CreatureData)

function CreatureDataWithPropUserdata:ctor()
  CreatureDataWithPropUserdata.super.ctor(self)
  self.props = RolePropsContainer.CreateAsTable()
  self.clientProps = ClientProps.new(self.props.config)
  self.userdata = UserData.CreateAsTable()
  self.attrEffect = AttrEffect.new()
  self.attrEffect2 = AttrEffectB.new()
  self.attrEffect3 = AttrEffectC.new()
  self:Reset()
end

function CreatureDataWithPropUserdata:Reset()
  self.idleAction = nil
  self.moveAction = nil
  self.normalAtkID = nil
  self.noStiff = 0
  self.noAttack = 0
  self.noSkill = 0
  self.noPicked = 0
  self.noAccessable = 0
  self.noMove = 0
  self.noAction = 0
  self.noAttacked = 0
  self.noRelive = 0
  self.noMoveAction = 0
  self.shape = nil
  self.race = nil
  self.bodyScale = nil
  self.buffhp = nil
  self.buffmaxhp = nil
end

function CreatureDataWithPropUserdata:GetProperty(name)
  local prop = self.props:GetPropByName(name)
  if nil == prop then
    return 0
  end
  return prop:GetValue()
end

function CreatureDataWithPropUserdata:GetJobLv()
  if nil ~= self.userdata then
    return self.userdata:Get(UDEnum.JOBLEVEL)
  end
  return 1
end

function CreatureDataWithPropUserdata:GetBaseLv()
  if nil ~= self.userdata then
    local monsterlv = self.userdata:Get(UDEnum.MONSTER_LEVEL)
    if monsterlv and 0 < monsterlv then
      return monsterlv
    end
    return self.userdata:Get(UDEnum.ROLELEVEL)
  end
  return 1
end

function CreatureDataWithPropUserdata:GetLernedSkillLevel(skillID)
  return 0
end

function CreatureDataWithPropUserdata:GetDynamicSkillInfo(skillID)
  return nil
end

function CreatureDataWithPropUserdata:GetSkillExtraCD()
  return 0
end

function CreatureDataWithPropUserdata:GetSkillOptByOption(opt)
  return 0
end

function CreatureDataWithPropUserdata:IsEnemy(creatureData)
  return creatureData:GetCamp() == RoleDefines_Camp.ENEMY
end

function CreatureDataWithPropUserdata:NotFriend(creatureData)
  return creatureData:GetCamp() < RoleDefines_Camp.FRIEND
end

function CreatureDataWithPropUserdata:IsImmuneSkill(skillID)
  return false
end

function CreatureDataWithPropUserdata:IgnoreJinzhanDamage()
  return nil ~= self.attrEffect and self.attrEffect:IgnoreJinzhanDamage()
end

function CreatureDataWithPropUserdata:IsFly()
  return false
end

function CreatureDataWithPropUserdata:SelfBuffChangeSkill(skillIDAndLevel_0)
  if nil == self.skillBuffs then
    return nil
  end
  local buff = self.skillBuffs:GetOwner(BuffConfig.SelfBuff)
  if nil == buff then
    return nil
  end
  return buff:GetParamsByType(BuffConfig.changeskill)[skillIDAndLevel_0]
end

function CreatureDataWithPropUserdata:GetProfressionID()
  return nil ~= self.userdata and self.userdata:Get(UDEnum.PROFESSION) or 0
end

function CreatureDataWithPropUserdata:DefiniteHitAndCritical()
  return nil ~= self.attrEffect and self.attrEffect:DefiniteHitAndCritical()
end

function CreatureDataWithPropUserdata:NextPointTargetSkillLargeLaunchRange()
  return nil ~= self.attrEffect2 and self.attrEffect2:NextPointTargetSkillLargeLaunchRange()
end

function CreatureDataWithPropUserdata:NextSkillNoReady()
  return nil ~= self.attrEffect2 and self.attrEffect2:NextSkillNoReady()
end

function CreatureDataWithPropUserdata:CanNotBeSkillTargetByEnemy()
  return nil ~= self.attrEffect2 and self.attrEffect2:CanNotBeSkillTargetByEnemy()
end

function CreatureDataWithPropUserdata:IsInMagicMachine()
  return nil ~= self.attrEffect2 and self.attrEffect2:IsInMagicMachine()
end

function CreatureDataWithPropUserdata:IsOnWolf()
  return nil ~= self.attrEffect2 and self.attrEffect2:IsOnWolf()
end

function CreatureDataWithPropUserdata:IsHideCancelTransformBtn()
  return self.attrEffect2 ~= nil and self.attrEffect2:IsHideCancelTransformBtn()
end

function CreatureDataWithPropUserdata:IsEatBeing()
  return self.attrEffect2 ~= nil and self.attrEffect2:IsEatBeing()
end

function CreatureDataWithPropUserdata:HideMyself()
  return nil ~= self.attrEffect3 and self.attrEffect3:HideMyself()
end

function CreatureDataWithPropUserdata:GetAttackSkillIDAndLevel()
  return self.normalAtkID or 0
end

function CreatureDataWithPropUserdata:IsAttackSkill(id)
  return self.normalAtkID == id or ExtraAttackSkill[id] == 1 or self:IsTriggerKickSkill(id) == true
end

function CreatureDataWithPropUserdata:IsExtraNormalSkill(skillid)
  return self.ExtraNormalSkills[skillid] == true
end

function CreatureDataWithPropUserdata:DamageAlways1()
  return false
end

function CreatureDataWithPropUserdata:GetRandom()
  return nil
end

function CreatureDataWithPropUserdata:RemoveInvalidHatred()
end

function CreatureDataWithPropUserdata:RefreshHatred(id)
end

function CreatureDataWithPropUserdata:CheckHatred(id, time)
  return false
end

function CreatureDataWithPropUserdata:GetArrowID()
  return 0
end

function CreatureDataWithPropUserdata:GetEquipedRefineLv(site)
  return 0
end

function CreatureDataWithPropUserdata:GetEquipedStrengthLv(site)
  return 0
end

function CreatureDataWithPropUserdata:GetEquipedItemNum(itemid)
  return 0
end

function CreatureDataWithPropUserdata:GetEquipedWeaponType()
  return 0
end

function CreatureDataWithPropUserdata:GetEquipTypeByPos()
  return 0
end

function CreatureDataWithPropUserdata:GetEquipedType(site)
  return 0
end

function CreatureDataWithPropUserdata:GetEquipedID(site)
  return 0
end

function CreatureDataWithPropUserdata:getEquipLv()
  return 0
end

function CreatureDataWithPropUserdata:GetCartNums()
  return 0, 0
end

function CreatureDataWithPropUserdata:GetPackageItemNum(itemid)
  return 0
end

function CreatureDataWithPropUserdata:GetEnchantAttrsBySite(site)
  return nil
end

function CreatureDataWithPropUserdata:GetCombineEffectsBySite(site)
  return nil
end

function CreatureDataWithPropUserdata:GetCurrentSkill()
  return self.currentSkill
end

function CreatureDataWithPropUserdata:SetCurrentSkill(skillLogic)
  self.currentSkill = skillLogic
end

function CreatureDataWithPropUserdata:ClearCurrentSkill(skillLogic)
  if self.currentSkill == skillLogic then
    self.currentSkill = nil
  end
end

function CreatureDataWithPropUserdata:GetAccessRange()
  return 2
end

function CreatureDataWithPropUserdata:SetAttackSpeed(s)
  self.attackSpeed = s
  self.attackSpeedAdjusted = 1 / (1 / s + 0.1) * 1.05
  self.attackSpeedAdjusted_Bell = 0.083 * s * s + 0.68 * s + 0.4
end

function CreatureDataWithPropUserdata:GetAttackSpeed()
  return self.attackSpeed
end

function CreatureDataWithPropUserdata:GetAttackSpeed_Adjusted()
  return self.attackSpeedAdjusted
end

function CreatureDataWithPropUserdata:GetAttackSpeed_Adjusted_Bell()
  return self.attackSpeedAdjusted_Bell
end

function CreatureDataWithPropUserdata:GetAttackInterval()
  local attackSpeed = self:GetAttackSpeed_Adjusted() or 1
  return 1 / attackSpeed
end

function CreatureDataWithPropUserdata:NoStiff()
  return 0 < self.noStiff
end

function CreatureDataWithPropUserdata:NoAttack()
  return 0 < self.noAttack
end

function CreatureDataWithPropUserdata:NoSkill()
  return 0 < self.noSkill
end

function CreatureDataWithPropUserdata:NoMagicSkill()
  return self.props:GetPropByName("NoMagicSkill"):GetValue() > 0
end

function CreatureDataWithPropUserdata:NoHitEffectMove()
  return self.props:GetPropByName("NoEffectMove"):GetValue() & 1 > 0
end

function CreatureDataWithPropUserdata:NoAttackEffectMove()
  return self.props:GetPropByName("NoEffectMove"):GetValue() & 2 > 0
end

function CreatureDataWithPropUserdata:NoPicked()
  return 0 < self.noPicked
end

function CreatureDataWithPropUserdata:NoAccessable()
  if self.forceSelect then
    return false
  end
  return 0 < self.noAccessable or 0 < self.noPicked
end

function CreatureDataWithPropUserdata:NoMove()
  if self:DeepFreeze() then
    return true
  end
  if self:IsAttrCanMove() then
    return false
  end
  return 0 < self.noMove or self:DeepFreeze()
end

function CreatureDataWithPropUserdata:NoAttacked()
  return 0 < self.noAttacked or self:HasNoAttackedBuff()
end

function CreatureDataWithPropUserdata:NoRelive()
  return 0 < self.noRelive
end

function CreatureDataWithPropUserdata:NoAction()
  return 0 < self.noAction
end

function CreatureDataWithPropUserdata:NoMoveAction()
  return self.noMoveAction > 0
end

function CreatureDataWithPropUserdata:NoAct()
  return 0 < self.props:GetPropByName("NoAct"):GetValue() or 0 < self.props:GetPropByName("DeepFreeze"):GetValue()
end

function CreatureDataWithPropUserdata:Freeze()
  if self:WeakFreeze() then
    return true
  end
  return 0 < self.props:GetPropByName("Freeze"):GetValue() or 0 < self.props:GetPropByName("DeepFreeze"):GetValue()
end

function CreatureDataWithPropUserdata:DeepFreeze()
  return 0 < self.props:GetPropByName("DeepFreeze"):GetValue()
end

function CreatureDataWithPropUserdata:WeakFreeze()
  if self.weakFreezeBuffs and self.weakFreezeBuffs.count > 0 then
    return true
  end
  return false
end

function CreatureDataWithPropUserdata:FearRun()
  return 0 < self.props:GetPropByName("FearRun"):GetValue()
end

function CreatureDataWithPropUserdata:FreeCast()
  return self.props:GetPropByName("MoveChant"):GetValue() > 0
end

function CreatureDataWithPropUserdata:PlusClientProp(prop)
  return prop:GetValue() + self.clientProps:GetValueByName(prop.propVO.name)
end

function CreatureDataWithPropUserdata:IsTransformed()
  local prop = self.props:GetPropByName("TransformID"):GetValue()
  return prop ~= 0
end

function CreatureDataWithPropUserdata:IsSolo()
  return self.props:GetPropByName("Solo"):GetValue() > 0
end

function CreatureDataWithPropUserdata:IsEnsemble()
  return self.props:GetPropByName("Ensemble"):GetValue() > 0
end

function CreatureDataWithPropUserdata:NoNormalAttack()
  return self.props:GetPropByName("NoNormalAttack"):GetValue() > 0
end

function CreatureDataWithPropUserdata:GetNpcID()
  return 0
end

function CreatureDataWithPropUserdata:GetClassID()
  if self.userdata then
    return self.userdata:Get(UDEnum.PROFESSION) or 0
  end
  return 0
end

function CreatureDataWithPropUserdata:HasBuffID(buffID)
  if self.buffIDs == nil then
    return false
  end
  return self.buffIDs[buffID] ~= nil
end

function CreatureDataWithPropUserdata:GetBuffTypes(type)
  if self.buffTypes == nil then
    return nil
  end
  return self.buffTypes[type]
end

function CreatureDataWithPropUserdata:GetSecretLandGemLv(itemid)
  return 0
end

function CreatureDataWithPropUserdata:GetEquipCardNum(site, cardID)
  return 0
end

function CreatureDataWithPropUserdata:GetRunePoint(specialEffectID)
  return 0
end

function CreatureDataWithPropUserdata:GetActiveAstrolabePoints()
  return 0
end

function CreatureDataWithPropUserdata:GetAdventureSavedHeadWear(quality)
  return 0
end

function CreatureDataWithPropUserdata:GetAdventureSavedCard(quality)
  return 0
end

function CreatureDataWithPropUserdata:GetAdventureTitle()
  return 0
end

function CreatureDataWithPropUserdata:GetBuffListByType(typeParam)
  if typeParam == nil or self.buffTypes == nil then
    return nil
  end
  local map = self.buffTypes[typeParam]
  if map == nil then
    return nil
  end
  local result
  for k, v in pairs(map) do
    result = result or {}
    result[#result + 1] = k
  end
  return result
end

function CreatureDataWithPropUserdata:GetBuffActiveListByType(typeParam)
  if typeParam == nil or self.buffTypes == nil or self.buffIDActives == nil then
    return nil
  end
  local map = self.buffTypes[typeParam]
  if map == nil then
    return nil
  end
  local result
  for k, v in pairs(map) do
    if self.buffIDActives[k] then
      result = result or {}
      result[#result + 1] = k
    end
  end
  return result
end

function CreatureDataWithPropUserdata:GetBuffEffectByType(typeParam)
  if typeParam == nil or self.buffTypes == nil then
    return nil
  end
  local map = self.buffTypes[typeParam]
  if map == nil then
    return nil
  end
  local id = next(map)
  if id ~= nil then
    local buff = Table_Buffer[id]
    if buff ~= nil then
      return buff.BuffEffect
    end
  end
  return nil
end

function CreatureDataWithPropUserdata:GetBuffEffectActiveByType(typeParam)
  if typeParam == nil or self.buffTypes == nil or self.buffIDActives == nil then
    return nil
  end
  local map = self.buffTypes[typeParam]
  if map == nil then
    return nil
  end
  local id = next(map)
  if id ~= nil and self.buffIDActives[id] then
    local buff = Table_Buffer[id]
    if buff ~= nil then
      return buff.BuffEffect
    end
  end
  return nil
end

function CreatureDataWithPropUserdata:GetBuffFromID(buffID)
  return self:_GetBuffRelate(self.buffIDs, buffID, 0)
end

function CreatureDataWithPropUserdata:GetBuffLayer(buffID)
  return self:_GetBuffRelate(self.buffIDLayers, buffID, 0)
end

function CreatureDataWithPropUserdata:GetBuffLevel(buffID)
  return self:_GetBuffRelate(self.buffIDLevels, buffID, 0)
end

function CreatureDataWithPropUserdata:GetBuffActive(buffID)
  if self.buffIDActives == nil then
    return false
  end
  local active = self.buffIDActives[buffID]
  if active == nil then
    return false
  end
  return active
end

function CreatureDataWithPropUserdata:_GetBuffRelate(t, buffID, defaultValue)
  if t == nil then
    return defaultValue or 0
  end
  return t[buffID] or defaultValue
end

function CreatureDataWithPropUserdata:HasBuffLayer(buffid, layer)
  if self.buffLayers ~= nil then
    local buffLayers = self.buffLayers[buffid]
    if buffLayers ~= nil then
      return buffLayers[layer] ~= nil
    end
  end
  return false
end

function CreatureDataWithPropUserdata:GetDistance(buffFromGuid)
  local proxy = SceneCreatureProxy
  local me = proxy.FindCreature(self.id)
  if me then
    local fromCreature = proxy.FindCreature(buffFromGuid)
    if fromCreature then
      return VectorUtility.DistanceXZ(me:GetPosition(), fromCreature:GetPosition())
    end
  end
  return 999999
end

function CreatureDataWithPropUserdata:GetRangeEnemy(range)
  return 0
end

function CreatureDataWithPropUserdata:GetMapInfo()
  return 0, 0
end

function CreatureDataWithPropUserdata:GetHighHpBeingGUID()
  return 0
end

function CreatureDataWithPropUserdata:IsRide(id)
  if self.userdata ~= nil then
    return self.userdata:Get(UDEnum.MOUNT) == id
  end
  return false
end

function CreatureDataWithPropUserdata:IsPartner(id)
  local me = SceneCreatureProxy.FindCreature(self.id)
  if me ~= nil then
    return me:GetPartnerID() == id
  end
  return false
end

function CreatureDataWithPropUserdata:getCurElementElfID()
  return 0
end

function CreatureDataWithPropUserdata:GetEnsemblePartner()
  return nil
end

function CreatureDataWithPropUserdata:GetGemValue(paramId)
  return 0
end

function CreatureDataWithPropUserdata:GetSpotter(id)
  local dynamicInfo = self:GetDynamicSkillInfo(id)
  if dynamicInfo ~= nil then
    return dynamicInfo:GetSpotter()
  end
  return 0
end

function CreatureDataWithPropUserdata:GetTypeBranchNumInTeam(branchs)
  return 0
end

function CreatureDataWithPropUserdata:GetCatNumInTeam()
  return 0
end

function CreatureDataWithPropUserdata:HasEquipFeature(feature)
  return false
end

function CreatureDataWithPropUserdata:GetMasterUser()
  return nil
end

function CreatureDataWithPropUserdata:GetDamageData()
  return self
end

function CreatureDataWithPropUserdata:GetTempSkillSlaveID()
  return 0
end

function CreatureDataWithPropUserdata:GetStatusNum()
  local stateEffect = self.props:GetPropByName("StateEffect"):GetValue()
  if stateEffect ~= 0 then
    local count = 0
    for i = 0, MaxStateEffect do
      if stateEffect >> i & 1 ~= 0 then
        count = count + 1
      end
    end
    return count
  end
  return 0
end

function CreatureDataWithPropUserdata:GetChantBeDamage()
  return 0
end

function CreatureDataWithPropUserdata:InMoveStatus()
  local me = SceneCreatureProxy.FindCreature(self.id)
  if me ~= nil then
    return me:IsMoving()
  end
  return false
end

function CreatureDataWithPropUserdata:GetSpareBattleTime()
  return 0
end

function CreatureDataWithPropUserdata:IsUserCamp()
  return false
end

function CreatureDataWithPropUserdata:InDamReduceRaid()
  local mapid = Game.MapManager:GetMapID()
  local data = Table_Map[mapid]
  if data ~= nil then
    return data.DamReduce == 1
  end
  return false
end

function CreatureDataWithPropUserdata:getEquip(package_type, site)
  return {
    id = CommonFun.Equip.id
  }
end

function CreatureDataWithPropUserdata:GetRangeVaildEnemy(range)
  return 0
end

function CreatureDataWithPropUserdata:HasLimitSkill()
  return false
end

function CreatureDataWithPropUserdata:HasLimitNotSkill()
  return false
end

function CreatureDataWithPropUserdata:GetLimitSkillTarget(skillID)
  return nil
end

function CreatureDataWithPropUserdata:GetLimitNotSkill(skillID)
  return nil
end

function CreatureDataWithPropUserdata:GetLimitSkillTargetBySortID(sortID)
  return nil
end

function CreatureDataWithPropUserdata:AddBuff(buffID, fromID, layer, level, active, isInit, layers, buffeffect, maxlayer)
  if buffID == nil then
    return
  end
  if self.buffIDs == nil then
    self.buffIDs = ReusableTable.CreateTable()
  end
  if self.buffIDLayers == nil then
    self.buffIDLayers = ReusableTable.CreateTable()
  end
  if level ~= nil and 0 < level then
    if self.buffIDLevels == nil then
      self.buffIDLevels = ReusableTable.CreateTable()
    end
    self.buffIDLevels[buffID] = level
  end
  if active ~= nil then
    if self.buffIDActives == nil then
      self.buffIDActives = ReusableTable.CreateTable()
    end
    self.buffIDActives[buffID] = active
  end
  if self.buffMaxLayer == nil then
    self.buffMaxLayer = ReusableTable.CreateTable()
  end
  self.buffMaxLayer[buffID] = maxlayer
  self.buffIDs[buffID] = fromID
  self.buffIDLayers[buffID] = layer
  if layers ~= nil and 0 < #layers then
    if self.buffLayers == nil then
      self.buffLayers = ReusableTable.CreateTable()
    end
    local buffLayers = self.buffLayers[buffID]
    if buffLayers == nil then
      buffLayers = ReusableTable.CreateTable()
    end
    for i = 1, #layers do
      buffLayers[layers[i].layer] = layers[i].layers
    end
  end
  if self.buffTypes == nil then
    self.buffTypes = ReusableTable.CreateTable()
  end
  local type = buffeffect.type
  if type ~= nil then
    local map = self.buffTypes[type]
    if map == nil then
      map = ReusableTable.CreateTable()
      self.buffTypes[type] = map
    end
    map[buffID] = buffID
  end
end

function CreatureDataWithPropUserdata:_AddBuffRelate(t, buffID, value)
end

function CreatureDataWithPropUserdata:RemoveBuff(buffID, buffeffect)
  if buffID == nil then
    return
  end
  self:_RemoveBuffRelate(self.buffIDs, buffID)
  self:_RemoveBuffRelate(self.buffIDLayers, buffID)
  self:_RemoveBuffRelate(self.buffIDLevels, buffID)
  self:_RemoveBuffRelate(self.buffIDActives, buffID)
  self:_RemoveBuffRelate(self.buffMaxLayer, buffID)
  if self.buffLayers ~= nil then
    local buffLayers = self.buffLayers[buffID]
    if buffLayers ~= nil then
      ReusableTable.DestroyAndClearTable(buffLayers)
      self.buffLayers[buffID] = nil
    end
  end
  if self.buffTypes ~= nil then
    local type = buffeffect.type
    if type ~= nil then
      local map = self.buffTypes[type]
      if map ~= nil then
        map[buffID] = nil
      end
      if next(map) == nil then
        ReusableTable.DestroyAndClearTable(map)
        self.buffTypes[type] = nil
      end
    end
  end
end

function CreatureDataWithPropUserdata:_RemoveBuffRelate(t, buffID)
  if t ~= nil then
    t[buffID] = nil
  end
end

function CreatureDataWithPropUserdata:IsBuffStateValid(buffInfo)
  if buffInfo == nil then
    return false
  end
  local buffEffect = buffInfo.BuffEffect
  if buffEffect and buffEffect.BuffState_Self == 1 then
    return false
  end
  return true
end

function CreatureDataWithPropUserdata:_AddWeakFreezeSkillBuff(buffInfo, skillIDs)
  if self.weakFreezeBuffs == nil then
    self.weakFreezeBuffs = {}
    self.weakFreezeBuffs.count = 0
    self.weakFreezeBuffs.relateBuffs = {}
  end
  local buffID = buffInfo.id
  if self.weakFreezeBuffs.relateBuffs[buffID] == nil then
    self.weakFreezeBuffs.count = self.weakFreezeBuffs.count + 1
    self.weakFreezeBuffs.relateBuffs[buffID] = 1
    local skillBuff
    for i = 1, #skillIDs do
      skillBuff = self.weakFreezeBuffs[skillIDs[i]]
      if skillBuff == nil then
        skillBuff = ReusableTable.CreateArray()
        self.weakFreezeBuffs[skillIDs[i]] = skillBuff
      end
      skillBuff[#skillBuff + 1] = buffID
    end
  end
end

function CreatureDataWithPropUserdata:_RemoveWeakFreezeSkillBuff(buffInfo, skillIDs)
  if self.weakFreezeBuffs then
    local buffID = buffInfo.id
    if self.weakFreezeBuffs.relateBuffs[buffID] then
      self.weakFreezeBuffs.relateBuffs[buffID] = nil
      self.weakFreezeBuffs.count = self.weakFreezeBuffs.count - 1
      local skillBuff
      for i = 1, #skillIDs do
        skillBuff = self.weakFreezeBuffs[skillIDs[i]]
        ArrayRemove(skillBuff, buffID)
        if #skillBuff == 0 then
          self.weakFreezeBuffs[skillIDs[i]] = nil
          DestroyArray(skillBuff)
        end
      end
    end
  end
end

function CreatureDataWithPropUserdata:_DynamicSkillConfigAdd(buffeffect)
  local _SkillDynamicManager = Game.SkillDynamicManager
  for i = 1, #buffeffect.ids do
    _SkillDynamicManager:AddDynamicConfig(self.id, buffeffect.ids[i], buffeffect.configType, buffeffect.value)
  end
end

function CreatureDataWithPropUserdata:_DynamicSkillConfigRemove(buffeffect)
  local _SkillDynamicManager = Game.SkillDynamicManager
  for i = 1, #buffeffect.ids do
    _SkillDynamicManager:RemoveDynamicConfig(self.id, buffeffect.ids[i], buffeffect.configType, buffeffect.value)
  end
end

function CreatureDataWithPropUserdata:_ClearBuffs()
  if self.buffIDs ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDs)
    self.buffIDs = nil
  end
  if self.buffIDLayers ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDLayers)
    self.buffIDLayers = nil
  end
  if self.buffIDLevels ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDLevels)
    self.buffIDLevels = nil
  end
  if self.buffIDActives ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDActives)
    self.buffIDActives = nil
  end
  if self.buffLayers ~= nil then
    for k, v in pairs(self.buffLayers) do
      ReusableTable.DestroyAndClearTable(v)
    end
    ReusableTable.DestroyAndClearTable(self.buffLayers)
    self.buffLayers = nil
  end
  if self.buffTypes ~= nil then
    for k, v in pairs(self.buffTypes) do
      ReusableTable.DestroyAndClearTable(v)
    end
    ReusableTable.DestroyAndClearTable(self.buffTypes)
    self.buffTypes = nil
  end
  if self.buffMaxLayer ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffMaxLayer)
    self.buffMaxLayer = nil
  end
end

function CreatureDataWithPropUserdata:AddClientProp(propName, value)
  local p = self.clientProps:GetPropByName(propName)
  local old, clientp = self.clientProps:SetValueByName(propName, p.value + value)
  return p, clientp
end

local PartIndex, PartIndexEx

function CreatureDataWithPropUserdata:GetDressParts()
  if PartIndex == nil then
    PartIndex = Asset_Role.PartIndex
  end
  if PartIndexEx == nil then
    PartIndexEx = Asset_Role.PartIndexEx
  end
  local parts = Asset_Role.CreatePartArray()
  if self.userdata then
    local userData = self.userdata
    if self:IsAnonymous() and not self:IsTransformState() then
      local classId = self:GetClassID()
      local gender = userData:Get(UDEnum.SEX)
      FunctionAnonymous.Me():GetAnonymousModelParts(classId, gender, parts)
    else
      parts[PartIndex.Body] = userData:Get(UDEnum.BODY) or default == nil and 0 or default[PartIndex.Body]
      parts[PartIndex.Hair] = userData:Get(UDEnum.HAIR) or default == nil and 0 or default[PartIndex.Hair]
      parts[PartIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or default == nil and 0 or default[PartIndex.LeftWeapon]
      parts[PartIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or default == nil and 0 or default[PartIndex.RightWeapon]
      parts[PartIndex.Head] = userData:Get(UDEnum.HEAD) or default == nil and 0 or default[PartIndex.Head]
      parts[PartIndex.Wing] = userData:Get(UDEnum.BACK) or default == nil and 0 or default[PartIndex.Wing]
      parts[PartIndex.Face] = userData:Get(UDEnum.FACE) or default == nil and 0 or default[PartIndex.Face]
      parts[PartIndex.Tail] = userData:Get(UDEnum.TAIL) or default == nil and 0 or default[PartIndex.Tail]
      parts[PartIndex.Eye] = userData:Get(UDEnum.EYE) or default == nil and 0 or default[PartIndex.Eye]
      parts[PartIndex.Mouth] = userData:Get(UDEnum.MOUTH) or default == nil and 0 or default[PartIndex.Mouth]
      parts[PartIndexEx.Gender] = userData:Get(UDEnum.SEX) or default == nil and 0 or default[PartIndexEx.Gender]
      parts[PartIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or default == nil and 0 or default[PartIndexEx.HairColorIndex]
      parts[PartIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or default == nil and 0 or default[PartIndexEx.EyeColorIndex]
      parts[PartIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or default == nil and 0 or default[PartIndexEx.BodyColorIndex]
    end
    parts[PartIndex.Mount] = userData:Get(UDEnum.MOUNT) or default == nil and 0 or default[PartIndex.Mount]
    self:SetMountFashionParts(parts, userData)
  else
    for i = 1, 12 do
      parts[i] = 0
    end
  end
  self:SpecialProcessParts(parts)
  return parts
end

autoImport("SimpleGuildData")

function CreatureDataWithPropUserdata:SetGuildData(data)
  if data and data[1] and data[1] ~= 0 then
    if not self.guildData then
      self.guildData = SimpleGuildData.CreateAsTable()
    end
    self.guildData:SetData(data)
  else
    self:DestroyGuildData()
  end
end

function CreatureDataWithPropUserdata:DestroyGuildData()
  if self.guildData then
    self.guildData:Destroy()
    self.guildData = nil
  end
end

function CreatureDataWithPropUserdata:GetGuildData()
  return self.guildData
end

function CreatureDataWithPropUserdata:SetMercenaryGuildData(data)
  if data and data[1] and data[1] ~= 0 then
    if not self.mercenaryGuildData then
      self.mercenaryGuildData = SimpleGuildData.CreateAsTable()
    end
    self.mercenaryGuildData:SetData(data)
  else
    self:DestroyMercenaryGuildData()
  end
end

function CreatureDataWithPropUserdata:DestroyMercenaryGuildData()
  if self.mercenaryGuildData then
    self.mercenaryGuildData:Destroy()
    self.mercenaryGuildData = nil
  end
end

function CreatureDataWithPropUserdata:GetMercenaryGuildData()
  return self.mercenaryGuildData
end

function CreatureDataWithPropUserdata:IsMercenary()
  if self.mercenaryGuildData and self.mercenaryGuildData.id > 0 then
    return true
  end
  return false
end

function CreatureDataWithPropUserdata:GetMercenaryGuildName()
  return self.mercenaryGuildData and self.mercenaryGuildData.mercenaryName or nil
end

function CreatureDataWithPropUserdata:GetUserDataStatus()
  return self.userdata:Get(UDEnum.STATUS)
end

function CreatureDataWithPropUserdata:GetRaidType()
  if Game.MapManager:IsRaidMode() then
    local raidData = Table_MapRaid[Game.MapManager:GetRaidID()]
    return raidData and raidData.Type or 0
  end
  return 0
end

function CreatureDataWithPropUserdata:GetMount()
  return self.userdata:Get(UDEnum.MOUNT)
end

function CreatureDataWithPropUserdata:SetClientForceDressPart(partIndex, partID)
  if not self.forceParts then
    self.forceParts = ReusableTable.CreateTable()
  end
  self.forceParts[partIndex] = partID
end

function CreatureDataWithPropUserdata:GetClientForceDressPart(partIndex)
  return self.forceParts and self.forceParts[partIndex] or 0
end

function CreatureDataWithPropUserdata:ClearClientForceDressParts()
  if self.forceParts then
    ReusableTable.DestroyAndClearTable(self.forceParts)
    self.forceParts = nil
  end
end

function CreatureDataWithPropUserdata:SpecialProcessParts(parts)
  if self.forceParts then
    for partIndex, partID in pairs(self.forceParts) do
      if partID ~= 0 then
        parts[partIndex] = partID
      end
    end
  end
  self:SpecialProcessPart_Sheath(parts)
end

function CreatureDataWithPropUserdata:SpecialProcessPart_Sheath(parts)
  local userdata = self.userdata
  if userdata ~= nil then
    local profess = userdata:Get(UDEnum.PROFESSION)
    if profess ~= nil and profess ~= 0 then
      local classData = Table_Class[profess]
      if classData ~= nil then
        parts[Asset_Role.PartIndexEx.SheathDisplay] = classData.Feature and 0 < classData.Feature & FeatureDefines_Class.Sheath
      end
    end
  end
end

function CreatureDataWithPropUserdata:GetFeature_IgnoreAutoBattle()
  return false
end

function CreatureDataWithPropUserdata:GetHP()
  local hp = Game.SkillDynamicManager:GetDynamicProps(self:GetCamp(), SkillDynamicManager.Props.HP)
  if hp ~= nil then
    return hp
  end
  return self.props:GetPropByName("Hp"):GetValue()
end

function CreatureDataWithPropUserdata:GetMP()
  return self.props:GetPropByName("Sp"):GetValue()
end

function CreatureDataWithPropUserdata:NoFCT()
  return self:GetBuffEffectActiveByType(BuffType.NoFCT)
end

function CreatureDataWithPropUserdata:GetCurChantTime()
  return 0
end

function CreatureDataWithPropUserdata:NoPhySkill()
  return self.props:GetPropByName("NoPhySkill"):GetValue() > 0
end

function CreatureDataWithPropUserdata:GetFeature_ForceSelect()
  return false
end

function CreatureDataWithPropUserdata:SetKickSkill(skillid)
  self.KickSkill = skillid
end

function CreatureDataWithPropUserdata:IsTriggerKickSkill(skilid)
  return self.KickSkill and self.KickSkill == skillid
end

function CreatureDataWithPropUserdata:IsPlayer()
  return false
end

function CreatureDataWithPropUserdata:IsNpc()
  return false
end

function CreatureDataWithPropUserdata:IsMonster()
  return false
end

function CreatureDataWithPropUserdata:IsSkillOwnerMonster()
  return false
end

function CreatureDataWithPropUserdata:IsOrOwnedByMonster()
  return self:IsMonster() or self:IsSkillOwnerMonster()
end

function CreatureDataWithPropUserdata:GetMapTeammateNum()
  return 0
end

function CreatureDataWithPropUserdata:GetSunMark()
  return 0
end

function CreatureDataWithPropUserdata:GetMoonMark()
  return 0
end

function CreatureDataWithPropUserdata:GetTimeDiskGrid()
  return 0
end

function CreatureDataWithPropUserdata:GetBuffLayerByIDAndFromID(buffID, guid)
  return self:GetBuffLayer(buffID)
end

function CreatureDataWithPropUserdata:GetBuffByTypeAndFromID(buffType, fromID)
  local buffs = self:GetBuffListByType(buffType)
  if buffs then
    for _, buff in pairs(buffs) do
      if self:GetBuffFromID(buff) == fromID then
        return true
      end
    end
  end
  return false
end

function CreatureDataWithPropUserdata:GetMountForm()
  return self.userdata and self.userdata:Get(UDEnum.RIDE_REFORM) or 1
end

function CreatureDataWithPropUserdata:GetPrevMountForm()
  local curMountForm = self:GetMountForm()
  local prevMountForm = curMountForm - 1
  if prevMountForm < 1 then
    prevMountForm = 2
  end
  return prevMountForm
end

function CreatureDataWithPropUserdata:GetNextMountForm()
  local curMountForm = self:GetMountForm()
  local nextMountForm = curMountForm + 1
  if 2 < nextMountForm then
    nextMountForm = 1
  end
  return nextMountForm
end

function CreatureDataWithPropUserdata:IsDressPartOfFeature(part, feature)
  local key = Asset_Role.PartIndexUserDataMap[part]
  if key and self.userdata then
    local equipId = self.userdata:Get(key)
    if EquipInfo.IsEquipOfFeature(equipId, feature) then
      return true
    end
  end
  return false
end

function CreatureDataWithPropUserdata:IsWildMvpLucky()
  if type(SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY) ~= "number" then
    return false
  end
  local opt = self.userdata and self.userdata:Get(UDEnum.OPTION) or 0
  return 0 < BitUtil.band(opt, SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY)
end

function CreatureDataWithPropUserdata:OpenStormBossLucky()
  return self:IsWildMvpLucky()
end

function CreatureDataWithPropUserdata:UpdateBuffHpVals(buffhp, buffmaxhp)
  self.buffhp = buffhp
  self.buffmaxhp = buffmaxhp
end

function CreatureDataWithPropUserdata:GetBuffHpVals()
  return self.buffhp, self.buffmaxhp
end

function CreatureDataWithPropUserdata:IsFriendNpc()
  return false
end

function CreatureDataWithPropUserdata:GetTargetNumLimit(skillid)
  return 0
end

function CreatureDataWithPropUserdata:GetTarInterferenceValue(targetID)
  return 0
end

function CreatureDataWithPropUserdata:AddElementAttrBuff(buffInfo)
  if not self.elementBuffs then
    self.elementBuffs = {}
  end
  if not self.elementDefBuffs then
    self.elementDefBuffs = {}
  end
  local buffeffect = buffInfo.BuffEffect
  local rollTypes = buffeffect.damageType
  local buffID = buffInfo.id
  local atk_element = buffeffect.atkParam
  local def_element = buffeffect.defParam
  if atk_element and rollTypes then
    for i = 1, #rollTypes do
      local rolltype = rollTypes[i]
      if not self.elementBuffs[rolltype] then
        self.elementBuffs[rolltype] = {}
      end
      if not self.elementBuffs[rolltype][atk_element] then
        self.elementBuffs[rolltype][atk_element] = {}
      end
      local elemtents = self.elementBuffs[rolltype][atk_element]
      elemtents[buffID] = buffeffect.upLevel or 0
    end
  elseif def_element then
    local rolltype = 0
    if not self.elementDefBuffs[rolltype] then
      self.elementDefBuffs[rolltype] = {}
    end
    if not self.elementDefBuffs[rolltype][def_element] then
      self.elementDefBuffs[rolltype][def_element] = {}
    end
    local elemtents = self.elementDefBuffs[rolltype][def_element]
    elemtents[buffID] = buffeffect.upLevel or 0
  end
end

function CreatureDataWithPropUserdata:RemoveElementAttrBuff(buffInfo)
  if not self.elementBuffs then
    self.elementBuffs = {}
  end
  if not self.elementDefBuffs then
    self.elementDefBuffs = {}
  end
  local buffeffect = buffInfo.BuffEffect
  local rollTypes = buffeffect.damageType
  local buffID = buffInfo.id
  local atk_element = buffeffect.atkParam
  local def_element = buffeffect.defParam
  if atk_element and rollTypes then
    for i = 1, #rollTypes do
      local rolltype = rollTypes[i]
      if not self.elementBuffs[rolltype] then
        self.elementBuffs[rolltype] = {}
      end
      if not self.elementBuffs[rolltype][atk_element] then
        self.elementBuffs[rolltype][atk_element] = {}
      end
      local elemtents = self.elementBuffs[rolltype][atk_element]
      elemtents[buffID] = 0
    end
  elseif def_element then
    local rolltype = 0
    if not self.elementDefBuffs[rolltype] then
      self.elementDefBuffs[rolltype] = {}
    end
    if not self.elementDefBuffs[rolltype][def_element] then
      self.elementDefBuffs[rolltype][def_element] = {}
    end
    local elemtents = self.elementDefBuffs[rolltype][def_element]
    elemtents[buffID] = 0
  end
end

function CreatureDataWithPropUserdata:GetElementAtkUpLevel(element, rolltype)
  if not self.elementBuffs then
    return 0
  end
  if not self.elementBuffs[rolltype] then
    return 0
  end
  local buffs = self.elementBuffs[rolltype][element]
  local levels = 0
  if buffs then
    for _, upLevel in pairs(buffs) do
      levels = levels + upLevel
    end
  end
  return levels
end

function CreatureDataWithPropUserdata:GetElementDefUpLevel(element)
  if not self.elementDefBuffs then
    return 0
  end
  local buffs = self.elementDefBuffs[0][element]
  local levels = 0
  if buffs then
    for _, upLevel in pairs(buffs) do
      levels = levels + upLevel
    end
  end
  return levels
end

function CreatureDataWithPropUserdata:GetZenyNum()
  return 0
end

function CreatureDataWithPropUserdata:SetMountFashionParts(parts, userData)
  local mount = userData:Get(UDEnum.MOUNT)
  if not mount or mount == 0 then
    return
  end
  local bytes = userData:GetBytes(UDEnum.MOUNT_FASHION)
  if bytes then
    local rets = string.split(bytes, ";")
    for i = 1, #rets do
      local styleId = tonumber(rets[i])
      local config = Table_MountFashion[styleId]
      if config and config.Mount == mount then
        local partIndex = config.PartIndex
        for j = 1, #partIndex do
          if config.Type == 1 then
            local skin = config.Skin
            if skin and 0 < skin[j] then
              Asset_Role.SetMountPartColor(parts, partIndex[j], skin[j])
            end
          elseif config.Type == 2 and 0 < partIndex[j] then
            Asset_Role.SetMountSubPart(parts, partIndex[j], config.PartID[j])
          end
        end
      end
    end
    local defaults = Game.MountDefaultFashion[mount]
    if defaults then
      for i = 1, #defaults do
        local id = defaults[i]
        local config = Table_MountFashion[id]
        if config then
          local pos = config.Pos
          if not TableUtility.ArrayFindByPredicate(rets, function(ret, arg)
            local staticData = Table_MountFashion[tonumber(ret)]
            return staticData and staticData.Pos == arg
          end, pos) then
            local partIndex = config.PartIndex
            for j = 1, #partIndex do
              if config.Type == 1 then
                Asset_Role.SetMountPartColor(parts, partIndex[j], config.Skin[j])
              elseif config.Type == 2 then
                Asset_Role.SetMountSubPart(parts, partIndex[j], config.PartID[j])
              end
            end
          end
        end
      end
    end
  end
end

function CreatureDataWithPropUserdata:SetMountSubParts(parts, userData)
  local mount = userData:Get(UDEnum.MOUNT)
  if not mount or mount == 0 then
    return
  end
  local bytes = userData:GetBytes(UDEnum.MOUNT_FASHION)
  if bytes then
    local rets = string.split(bytes, ";")
    for i = 1, #rets do
      local styleId = tonumber(rets[i])
      local config = Table_MountFashion[styleId]
      if config and config.Type == 2 then
        for j = 1, #config.PartIndex do
          Asset_Role.SetMountSubPart(parts, config.PartIndex[j], config.PartID[j])
        end
      end
    end
    local defaults = Game.MountDefaultFashion[mount]
    if defaults then
      for i = 1, #defaults do
        local id = defaults[i]
        local config = Table_MountFashion[id]
        if config then
          local pos = config.Pos
          if not TableUtility.ArrayFindByPredicate(rets, function(ret, arg)
            local staticData = Table_MountFashion[tonumber(ret)]
            return staticData and staticData.Pos == arg
          end, pos) and config.Type == 2 then
            for j = 1, #config.PartIndex do
              Asset_Role.SetMountSubPart(parts, config.PartIndex[j], config.PartID[j])
            end
          end
        end
      end
    end
  end
end

function CreatureDataWithPropUserdata:SetMountPartColors(parts, userData)
  local mount = userData:Get(UDEnum.MOUNT)
  if not mount or mount == 0 then
    return
  end
  local bytes = userData:GetBytes(UDEnum.MOUNT_FASHION)
  if bytes then
    local rets = string.split(bytes, ";")
    for i = 1, #rets do
      local styleId = tonumber(rets[i])
      local config = Table_MountFashion[styleId]
      if config and config.Type == 1 then
        local skin = config.Skin
        if skin then
          for j = 1, #skin do
            Asset_Role.SetMountPartColor(parts, config.PartIndex[j], skin[j])
          end
        end
      end
    end
    local defaults = Game.MountDefaultFashion[mount]
    if defaults then
      for i = 1, #defaults do
        local id = defaults[i]
        local config = Table_MountFashion[id]
        if config then
          local pos = config.Pos
          if not TableUtility.ArrayFindByPredicate(rets, function(ret, arg)
            local staticData = Table_MountFashion[tonumber(ret)]
            return staticData and staticData.Pos == arg
          end, pos) and config.Type == 1 then
            for j = 1, #config.PartIndex do
              Asset_Role.SetMountPartColor(parts, config.PartIndex[j], config.Skin[j])
            end
          end
        end
      end
    end
  end
end

function CreatureDataWithPropUserdata:UpdateResistanceValue()
  self.resistance_updatetime = UnityTime
  self.resistance_value = self.userdata:Get(UDEnum.RESISTANCE_VALUE) or 0
  local speed = self.userdata:Get(UDEnum.RESISTANCE_SPEED) or 0
  if speed ~= 0 then
    self.resistance_speed = speed % 10 == 2 and -speed // 10 or speed // 10
  else
    self.resistance_speed = 0
  end
end

function CreatureDataWithPropUserdata:GetResistanceValue()
  if not self.resistance_updatetime then
    return nil, nil
  end
  if self.resistance_speed == 0 then
    return self.resistance_value, 0
  end
  return self.resistance_value + self.resistance_speed * (UnityTime - self.resistance_updatetime), self.resistance_speed
end

function CreatureDataWithPropUserdata:ResetResistanceValue()
  self.resistance_updatetime = nil
  self.resistance_value = nil
  self.resistance_speed = nil
end

function CreatureDataWithPropUserdata:UpdateAttributeValue()
  self.attribute_updatetime = UnityTime
  self.attribute_value = self.userdata:Get(UDEnum.ATTRIBUTE_VALUE) or 0
  local speed = self.userdata:Get(UDEnum.ATTRIBUTE_SPEED) or 0
  if speed ~= 0 then
    self.attribute_speed = speed % 10 == 2 and -speed // 10 or speed // 10
  else
    self.attribute_speed = 0
  end
end

function CreatureDataWithPropUserdata:GetAttributeValue()
  if not self.attribute_updatetime then
    return nil, nil
  end
  if self.attribute_speed == 0 then
    return self.attribute_value, 0
  end
  return self.attribute_value + self.attribute_speed * (UnityTime - self.attribute_updatetime), self.attribute_speed
end

function CreatureDataWithPropUserdata:ResetAttributeValue()
  self.attribute_updatetime = nil
  self.attribute_value = nil
  self.attribute_speed = nil
end

function CreatureDataWithPropUserdata:GetNature()
  return nil
end

function CreatureDataWithPropUserdata:GetNatureLv()
  return 0
end

function CreatureDataWithPropUserdata:GetBuff_SuperpositionCount()
  return 0
end

function CreatureDataWithPropUserdata:HasRelation()
  return self:GetBuffEffectActiveByType(BuffType.CreateRelation)
end

function CreatureDataWithPropUserdata:NextTargetSkillLargeLaunchRange()
  return nil ~= self.attrEffect3 and self.attrEffect3:NextTargetSkillLargeLaunchRange()
end

function CreatureDataWithPropUserdata:GetInitLaunchRangeMoreThenAdd()
  local buffeffect = self:GetBuffEffectActiveByType(BuffType.InitLaunchRangeMoreThenAdd)
  if buffeffect == nil then
    return nil
  end
  local initrange = buffeffect.init_range
  local addrange = buffeffect.add_range
  return CommonFun.calcBuffValue(self, nil, initrange.type), CommonFun.calcBuffValue(self, nil, addrange.type)
end

local DescendingValue = 1000000

function CreatureDataWithPropUserdata:UpdateBalanceValue()
  local BalanceConfig = self:GetBalanceConfig()
  if not BalanceConfig then
    return
  end
  local balanceSpd = BalanceConfig and BalanceConfig.DecSpd
  self.balance_updatetime = UnityTime
  local rawData = self.userdata:Get(UDEnum.BALANCE_VALUE) or 0
  local speed = balanceSpd or 0
  if rawData > DescendingValue then
    self.balanceValue = rawData - DescendingValue
    self.balance_speed = -speed * 1000 or 0
  else
    self.balanceValue = rawData
    self.balance_speed = 0
  end
end

function CreatureDataWithPropUserdata:GetBalanceValue()
  if not self.balance_updatetime then
    return nil, nil
  end
  if self.balance_speed == 0 then
    return self.balanceValue, 0
  end
  return self.balanceValue + self.balance_speed * (UnityTime - self.balance_updatetime), self.balance_speed
end

function CreatureDataWithPropUserdata:ResetBalanceValue()
  self.balance_updatetime = nil
  self.balanceValue = nil
  self.balance_speed = nil
end

function CreatureDataWithPropUserdata:SetInBreak(val)
  self.isInBreak = val
end

function CreatureDataWithPropUserdata:IsInBreak()
  return self.isInBreak
end

function CreatureDataWithPropUserdata:GetPassedBreakTime()
  local BalanceConfig = self:GetBalanceConfig()
  if not BalanceConfig then
    return
  end
  local deltaValue = BalanceConfig.MaxValue * 1000 - (self.balanceValue or 0)
  if not self.balance_speed or self.balance_speed == 0 then
    return 0
  end
  return deltaValue / -self.balance_speed
end

function CreatureDataWithPropUserdata:GetBalanceConfigID()
  return 0
end

function CreatureDataWithPropUserdata:GetBalanceConfig()
  local balanceID = self:GetBalanceConfigID()
  local BalanceBar = GameConfig.MonsterControl.BalanceBar
  return balanceID and BalanceBar and BalanceBar[balanceID]
end

function CreatureDataWithPropUserdata:GetPrestigeLevel()
  local prestigeLevel = self.userdata:Get(UDEnum.PRESTIGE_LEVEL) or 0
  return prestigeLevel
end

function CreatureDataWithPropUserdata:GetBuffMaxLayer(buffID)
  return self:_GetBuffRelate(self.buffMaxLayer, buffID, nil)
end

function CreatureDataWithPropUserdata:GetGender()
  local userData = self.userdata
  return userData:Get(UDEnum.SEX) or 0
end

function CreatureDataWithPropUserdata:GetLastUseSkillBigID()
  return 0
end

function CreatureDataWithPropUserdata:SetNoEnemyLocked(val)
  self.noEnemyLocked = val
end

function CreatureDataWithPropUserdata:GetNoEnemyLocked()
  return false
end

function CreatureDataWithPropUserdata:SetIgnoreNoEnemyLocked(val)
  self.ignoreNoEnemyLocked = val
end

function CreatureDataWithPropUserdata:isCostBattleCount()
  return false
end

function CreatureDataWithPropUserdata:GetRangeTeammate(range)
  local me = SceneCreatureProxy.FindCreature(self.id)
  return TeamProxy.Instance:GetMemberCountInRange(range, filter, filterArgs, me:GetPosition())
end

function CreatureDataWithPropUserdata:GetDownID()
  return self.downID or 0
end

function CreatureDataWithPropUserdata:SetDownID(downID)
  self.downID = downID
end

function CreatureDataWithPropUserdata:GetUpID()
  if self.userdata then
    return self.userdata:Get(UDEnum.UP_CHARID) or 0
  end
  return 0
end

function CreatureDataWithPropUserdata:IsInRide()
  local down = self:GetDownID()
  local up = self:GetUpID()
  return 0 < down or 0 < up
end

function CreatureDataWithPropUserdata:IsPippi()
  return false
end

function CreatureDataWithPropUserdata:IsPippiNoMove()
  return (self.userdata:Get(UDEnum.RIDE_PIPPI_NOMOVE) or 0) ~= 0
end

function CreatureDataWithPropUserdata:SetHasNoAttackedBuff()
  local buffeffect = self:GetBuffEffectActiveByType(BuffType.NoAttackedCanPveBuff)
  self.hasNoattackedBuff = buffeffect ~= nil
  return self.hasNoattackedBuff
end

function CreatureDataWithPropUserdata:HasNoAttackedBuff()
  return self.hasNoattackedBuff == true
end

function CreatureDataWithPropUserdata:GetFeature_IgnoreDress()
  return false
end

function CreatureDataWithPropUserdata:GetNormalPVPCamp()
  if self.userdata then
    return self.userdata:Get(UDEnum.PVP_CAMP) or 0
  end
  return 0
end

function CreatureDataWithPropUserdata:IsAnonymous()
  return false
end

function CreatureDataWithPropUserdata:IsReturnPlayer()
  local recall_time = self.userdata and self.userdata:Get(UDEnum.RECALL_TIME) or 0
  if 0 < recall_time then
    local curServerTime = ServerTime.CurServerTime() / 1000
    return recall_time > curServerTime
  end
  return false
end

function CreatureDataWithPropUserdata:SetShadowViel(val)
end

function CreatureDataWithPropUserdata:ForbidClientClient()
  return false
end

function CreatureDataWithPropUserdata:IsPhantom()
  return false
end

function CreatureDataWithPropUserdata:IsBuffFrom(buffID, fromID)
  if self.buffSources then
    return self.buffSources[buffID] and self.buffSources[buffID][fromID] and true or false
  end
  return self:GetBuffFromID(buffID) == fromID
end

function CreatureDataWithPropUserdata:SyncBuffSource(syncbuffs)
  if syncbuffs then
    local buffID, fromID, opt
    for i = 1, #syncbuffs do
      local data = syncbuffs[i]
      buffID, fromID, opt = data.buffid, data.fromid, data.opt
      if not buffID or not fromID then
        return
      end
      if not self.buffSources then
        self.buffSources = {}
      end
      if opt then
        if not self.buffSources[buffID] then
          self.buffSources[buffID] = {}
        end
        self.buffSources[buffID][fromID] = true
      else
        local sources = self.buffSources[buffID]
        if not sources then
          return
        end
        self.buffSources[buffID][fromID] = nil
      end
    end
  end
end

function CreatureDataWithPropUserdata:IsWarehouseNpc()
  return false
end

function CreatureDataWithPropUserdata:IsForceShowHp()
  return false
end

function CreatureDataWithPropUserdata:getEndlessLayer()
  return self.userdata:Get(UDEnum.RAID_LAYER) or 0
end

function CreatureDataWithPropUserdata:SetAttrCanMove(val)
  self.attrCanMove = val
end

function CreatureDataWithPropUserdata:IsAttrCanMove()
  return not self:ForbidMove() and self.attrCanMove or false
end

function CreatureDataWithPropUserdata:GetManualLevel(val)
  return 0
end

function CreatureDataWithPropUserdata:ForbidMove()
  return self.props:GetPropByName("ForbidMove"):GetValue() > 0
end

function CreatureDataWithPropUserdata:DoConstruct(asArray, parts)
  self:SetAttackSpeed(1)
  self.bodyScale = self:GetDefaultScale()
  CreatureDataWithPropUserdata.super.DoConstruct(self, asArray, parts)
end

function CreatureDataWithPropUserdata:DoDeconstruct(asArray)
  CreatureDataWithPropUserdata.super.DoDeconstruct(self, asArray)
  self:ClearClientForceDressParts()
  self:Reset()
  self.userdata:Reset()
  self.props:Reset()
  self.clientProps:Reset()
  self.attrEffect:Set(0)
  self.attrEffect2:Reset()
  self.attrEffect3:Reset()
  self:_ClearBuffs()
  self:DestroyGuildData()
  self:DestroyMercenaryGuildData()
  self:ResetResistanceValue()
  self:ResetAttributeValue()
  self.noEnemyLocked = false
  self.hasNoattackedBuff = false
  self.ignoreNoEnemyLocked = false
  self.downID = nil
  self.buffSources = nil
  self.stageBuffLayer = nil
  self.attrCanMove = false
end
