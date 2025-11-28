NpcData = reusableClass("NpcData", CreatureDataWithPropUserdata)
NpcData.PoolSize = 100
autoImport("NpcData_Pushable")
autoImport("Table_RoleEquips")
local NpcMonsterUtility = NpcMonsterUtility
local m_Table_Monster
local _Table_Monster = function(id)
  if not m_Table_Monster then
    m_Table_Monster = Table_Monster
  end
  return m_Table_Monster[id]
end
local m_TableNpc
local _Table_Npc = function(id)
  if not m_TableNpc then
    m_TableNpc = Table_Npc
  end
  return m_TableNpc[id]
end
local m_TableBoss
local _Table_Boss = function(id)
  if not m_TableBoss then
    m_TableBoss = Table_Boss
  end
  return m_TableBoss[id]
end
NpcData.NpcType = {
  Npc = 1,
  Monster = 2,
  Pet = 3
}
NpcData.NpcDetailedType = {
  NPC = "NPC",
  GatherNPC = "GatherNPC",
  SealNPC = "SealNPC",
  WeaponPet = "WeaponPet",
  Monster = "Monster",
  MINI = "MINI",
  MVP = "MVP",
  Escort = "Escort",
  SkillNpc = "SkillNpc",
  FoodNpc = "FoodNpc",
  PetNpc = "PetNpc",
  CatchNpc = "CatchNpc",
  BeingNpc = "BeingNpc",
  StageNpc = "StageNpc",
  DeadBoss = "DeadBoss",
  PioneerNpc = "PioneerNpc",
  ShadowNpc = "ShadowNpc",
  GhostNpc = "GhostNpc",
  BFBuilding = "BUILD",
  RareElite = "RareElite",
  WorldBoss = "WorldBoss",
  SiegeCar = "SiegeCar",
  TwelveBase = "TwelveBase",
  DefenseTower = "DefenseTower",
  PushMinion = "PushMinion",
  TwelveBarrack = "TwelveBarrack",
  CopyNpc = "CopyNpc",
  Boki = "Boki",
  SoulNpc = "SoulNpc",
  FollowMaster = "FollowMaster",
  RobotNpc = "RobotNpc",
  FriendNpc = "FriendNpc",
  DogNpc = "DogNpc",
  GiftNpc = "GiftNpc",
  Firework = "Firework",
  PippiNpc = "PippiNpc",
  EBF_Robot = "EBF_Robot",
  TriplePvpRobot = "TriplePvpRobot",
  PerfectPhantom = "PerfectPhantom",
  NormalPhantom = "NormalPhantom",
  WarehouseNpc = "WarehouseNpc"
}
NpcData.ZoneType = {
  ZONE_MIN = 0,
  ZONE_FIELD = 1,
  ZONE_TASK = 2,
  ZONE_ENDLESSTOWER = 3,
  ZONE_LABORATORY = 4,
  ZONE_SEAL = 5,
  ZONE_DOJO = 6,
  ZONE_MAX = 7,
  ZONE_STORM = 22,
  ZONE_EQUIPUP = 24,
  ZONE_MemoryPalace = 25,
  ZONE_MemoryRaid = 26,
  ZONE_MemoryThird = 27,
  ZONE_ABYSSDRAGON = 28
}
NpcData.BossType = {
  Mvp = 1,
  Mini = 2,
  Dead = 3
}
local tempArray = {}
local GetNpcPriority = function(data)
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(data.skillID)
  if skillinfo ~= nil then
    local fromCreature = SceneCreatureProxy.FindCreature(data.skillOwner)
    if fromCreature ~= nil then
      local logicParam = skillinfo.logicParam
      local effectType = (logicParam.isCountTrap == 1 or logicParam.isTimeTrap == 1) and Asset_Effect.EffectTypes.Map or nil
      return SkillInfo.GetEffectPriority(fromCreature, effectType, nil, skillinfo.camps)
    end
  end
  return 2
end
local getTable = ReusableTable.getClientNpcTable

function NpcData.CreateClientData(npcPoint)
  local sNpcData = _Table_Npc(npcPoint.ID) or _Table_Monster(npcPoint.ID)
  if not sNpcData then
    return nil
  end
  local clientData = getTable()
  clientData.__isclient = true
  clientData.id = npcPoint.guid or npcPoint.uniqueID
  clientData.npcID = npcPoint.ID
  clientData.uniqueid = npcPoint.uniqueID
  if npcPoint.dir then
    clientData.dir = npcPoint.dir * 1000
  end
  clientData.idleAction = npcPoint.waitaction
  clientData.pos = getTable()
  clientData.pos.x = npcPoint.position[1] * 1000
  clientData.pos.y = npcPoint.position[2] * 1000
  clientData.pos.z = npcPoint.position[3] * 1000
  clientData.datas = getTable()
  if sNpcData.Body then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.BODY)
    t.value = sNpcData.Body
    table.insert(clientData.datas, t)
  end
  if sNpcData.Hair then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.HAIR)
    t.value = sNpcData.Hair
    table.insert(clientData.datas, t)
  end
  if sNpcData.Head then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.HEAD)
    t.value = sNpcData.Head
    table.insert(clientData.datas, t)
  end
  if sNpcData.Face then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.FACE)
    t.value = sNpcData.Face
    table.insert(clientData.datas, t)
  end
  if sNpcData.Mouth then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.MOUTH)
    t.value = sNpcData.Mouth
    table.insert(clientData.datas, t)
  end
  if sNpcData.Wing then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.BACK)
    t.value = sNpcData.Wing
    table.insert(clientData.datas, t)
  end
  if sNpcData.Tail then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.TAIL)
    t.value = sNpcData.Tail
    table.insert(clientData.datas, t)
  end
  if sNpcData.LeftHand then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.LEFTHAND)
    t.value = sNpcData.LeftHand
    table.insert(clientData.datas, t)
  end
  if sNpcData.RightHand then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.RIGHTHAND)
    t.value = sNpcData.RightHand
    table.insert(clientData.datas, t)
  end
  if sNpcData.BodyDefaultColor then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.CLOTHCOLOR)
    t.value = sNpcData.BodyDefaultColor
    table.insert(clientData.datas, t)
  end
  if sNpcData.HeadDefaultColor then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.HAIRCOLOR)
    t.value = sNpcData.HeadDefaultColor
    table.insert(clientData.datas, t)
  end
  if sNpcData.Mount then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.MOUNT)
    t.value = sNpcData.Mount
    table.insert(clientData.datas, t)
    local m = getTable()
    m.type = UserData.GetKey(UDEnum.MOUNT_FASHION)
    m.data = ""
    table.insert(clientData.datas, m)
  end
  if sNpcData.Scale then
    local t = getTable()
    t.type = UserData.GetKey(UDEnum.BODYSCALE)
    t.value = sNpcData.Scale * 100
    table.insert(clientData.datas, t)
  end
  return clientData
end

local delTable = ReusableTable.destroyClientNpcTable

function NpcData.DestroyClientData(clientNpcData)
  if clientNpcData then
    delTable(clientNpcData.pos)
    if clientNpcData.datas then
      for i = 1, #clientNpcData.datas do
        delTable(clientNpcData.datas[i])
      end
      delTable(clientNpcData.datas)
    end
    delTable(clientNpcData)
  end
end

function NpcData:ctor()
  NpcData.super.ctor(self)
  self.staticData = nil
  self.uniqueid = nil
  self.behaviourData = BehaviourData.new()
  self.charactors = ReusableTable.CreateArray()
  self.useServerDressData = false
end

function NpcData:GetCamp()
  if self.campHandler and self.campHandler.dirty then
    self:SetCamp(self.campHandler:GetCamp())
  end
  return self.camp
end

function NpcData:GetDefaultGear()
  return self.staticData.DefaultGear
end

function NpcData:NoPlayIdle()
  return 1 == self.staticData.DisableWait
end

function NpcData:NoPlayShow()
  return 1 == self.staticData.DisablePlayshow
end

function NpcData:NoAutoAttack()
  return 1 == self.staticData.NoAutoAttack
end

function NpcData:GetAccessRange()
  return self.staticData.AccessRange or 2
end

function NpcData:IsNpc()
  return self.type == NpcData.NpcType.Npc
end

function NpcData:IsMonster()
  return self.type == NpcData.NpcType.Monster
end

function NpcData:IsSkillOwnerMonster()
  if self.skillOwner and self.skillOwner ~= 0 then
    local ownerCreature = SceneCreatureProxy.FindCreature(self.skillOwner)
    if ownerCreature and ownerCreature.data and ownerCreature.data.IsMonster then
      return ownerCreature.data:IsMonster()
    end
  end
  return false
end

function NpcData:IsPet()
  return self.type == NpcData.NpcType.Pet
end

function NpcData:IsMonster_Detail()
  return self.detailedType == NpcData.NpcDetailedType.Monster
end

function NpcData:IsBoss()
  return self.detailedType == NpcData.NpcDetailedType.MVP
end

function NpcData:IsMini()
  return self.detailedType == NpcData.NpcDetailedType.MINI
end

function NpcData:IsDeadBoss()
  return self.detailedType == NpcData.NpcDetailedType.DeadBoss
end

function NpcData:IsBossType_Mvp()
  if self.bosstype then
    return self.bosstype == NpcData.BossType.Mvp
  else
    return self:IsBoss()
  end
end

function NpcData:IsBossType_Mini()
  if self.bosstype then
    return self.bosstype == NpcData.BossType.Mini
  else
    return self:IsMini()
  end
end

function NpcData:IsBossType_Dead()
  if self.bosstype then
    return self.bosstype == NpcData.BossType.Dead
  else
    return self:IsDeadBoss()
  end
end

function NpcData:IsSkillNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.SkillNpc
end

function NpcData:IsCatchNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.CatchNpc
end

function NpcData:IsBeingNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.BeingNpc
end

function NpcData:IsPioneerNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.PioneerNpc
end

function NpcData:IsShadowNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.ShadowNpc
end

function NpcData:IsGhostNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.GhostNpc
end

function NpcData:IsRareElite_Detail()
  return self.detailedType == NpcData.NpcDetailedType.RareElite
end

function NpcData:IsWorldBoss_Detail()
  return self.detailedType == NpcData.NpcDetailedType.WorldBoss
end

function NpcData:IsCopyNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.CopyNpc
end

function NpcData:IsFollowMaster_Detail()
  return self.detailedType == NpcData.NpcDetailedType.FollowMaster
end

function NpcData:IsBoki_Detail()
  return self.detailedType == NpcData.NpcDetailedType.Boki
end

local MusicNpcConfig = GameConfig.System.musicboxnpc
local type_MusicNpcConfig = type(MusicNpcConfig)

function NpcData:IsMusicBox()
  if self.staticData.id == GameConfig.Joy.music_npc_i then
    return true
  end
  if type_MusicNpcConfig == "table" then
    return MusicNpcConfig[self.staticData.id] ~= nil
  end
  return self.staticData.id == MusicNpcConfig
end

function NpcData:IsSkada()
  return self.isSkada == true
end

function NpcData:IsSoulNpc()
  return self.detailedType == NpcData.NpcDetailedType.SoulNpc
end

function NpcData:IsFireWork()
  return self.detailedType == NpcData.NpcDetailedType.Firework
end

function NpcData:IsPippi()
  return self.detailedType == NpcData.NpcDetailedType.PippiNpc
end

function NpcData:IsEBFRobot()
  return self.detailedType == NpcData.NpcDetailedType.EBF_Robot
end

function NpcData:IsTripleTeamRobot()
  return self.detailedType == NpcData.NpcDetailedType.TriplePvpRobot
end

function NpcData:IsWarehouseNpc()
  return self.detailedType == NpcData.NpcDetailedType.WarehouseNpc
end

local ElementNpcMap
local GetElementNpcMap = function()
  local nowRaid = Game.MapManager:GetRaidID()
  if ElementNpcMap then
    return ElementNpcMap[nowRaid]
  end
  ElementNpcMap = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    ElementNpcMap[raidId] = {}
    local elementNpcsID = config.ElementNpcsID
    for i = 1, #elementNpcsID do
      ElementNpcMap[raidId][elementNpcsID[i].npcid] = 1
    end
  end
  return ElementNpcMap[nowRaid]
end

function NpcData:IsElementNpc()
  local map = GetElementNpcMap()
  if map == nil then
    return
  end
  local npcid = self.staticData and self.staticData.id
  return npcid and map[npcid] == 1
end

local ElementNpcMap_Mid
local GetElementNpcMap_Mid = function()
  local nowRaid = Game.MapManager:GetRaidID()
  if ElementNpcMap_Mid then
    return ElementNpcMap_Mid[nowRaid]
  end
  ElementNpcMap_Mid = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    local buffConfig = config.BuffEffect
    ElementNpcMap_Mid[raidId] = {}
    for npcid, _ in pairs(buffConfig) do
      ElementNpcMap_Mid[raidId][npcid] = 1
    end
  end
  return ElementNpcMap_Mid[nowRaid]
end

function NpcData:IsElementNpc_Mid()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    return false
  end
  local map = GetElementNpcMap_Mid()
  if map == nil then
    return false
  end
  local npcid = self.staticData and self.staticData.id
  return npcid and map[npcid] == 1
end

local normal_card_npc = GameConfig.CardRaid.normal_card_npc
local boss_card_npc = GameConfig.CardRaid.boss_card_npc

function NpcData:IsPveCardEffect()
  local sid = self.staticData and self.staticData.id or 0
  return sid == normal_card_npc or sid == boss_card_npc
end

function NpcData:IsSiegeCar()
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return false
  end
  return self.detailedType == NpcData.NpcDetailedType.SiegeCar
end

function NpcData:IsTwelveBase_Detail()
  return self.detailedType == NpcData.NpcDetailedType.TwelveBase
end

function NpcData:IsFriendNpc()
  return self.detailedType == NpcData.NpcDetailedType.FriendNpc
end

function NpcData:GetStaticID()
  return self.staticData.id
end

function NpcData:GetBaseLv()
  local level
  if nil ~= self.userdata then
    local monsterlv = self.userdata:Get(UDEnum.MONSTER_LEVEL)
    if monsterlv and 0 < monsterlv then
      return monsterlv
    end
    level = self.userdata:Get(UDEnum.ROLELEVEL)
  end
  if nil == level then
    if nil ~= self.staticData and nil ~= self.staticData.Level then
      level = self.staticData.Level
    else
      level = 1
    end
  end
  return level
end

function NpcData:NoHitEffectMove()
  if self.behaviourData:GetNonMoveable() == 1 then
    return true
  end
  return NpcData.super.NoHitEffectMove(self)
end

function NpcData:NoAttackEffectMove()
  if self.behaviourData:GetNonMoveable() == 1 then
    return true
  end
  return NpcData.super.NoAttackEffectMove(self)
end

function NpcData:GetShape()
  return self.staticData.Shape
end

function NpcData:GetGroupID()
  return self.staticData.GroupID
end

function NpcData:GetRace()
  return self.staticData.Race_Parsed
end

function NpcData:GetOriginName()
  if self.staticData == nil or self.staticData.NameZh == nil then
    return "none"
  end
  return self.staticData.NameZh
end

function NpcData:GetName(isInScene)
  local name = self.name and self.name or self:GetOriginName()
  return self:WithPrefixName(isInScene) .. OverSea.LangManager.Instance():GetLangByKey(name)
end

function NpcData:GetNpcID()
  return self.staticData.id
end

function NpcData:GetDefaultScale()
  if self.staticData then
    return self.staticData.Scale or 1
  end
  return 1
end

function NpcData:GetClassID()
  return 0
end

function NpcData:GetRelativeFurnitureID()
  return self.furnitureID
end

function NpcData:GetPushableObjID()
  return self.pushableobjID
end

function NpcData:GetFeature(bit)
  if self.staticData and self.staticData.Features then
    return self.staticData.Features & bit > 0
  end
  return false
end

function NpcData:GetFeature_ChangeLinePunish()
  return self:GetFeature(1)
end

function NpcData:GetFeature_BeHold()
  return self:GetFeature(4)
end

function NpcData:GetFeature_FakeMini()
  return self:GetFeature(16)
end

function NpcData:GetFeature_IgnoreNavmesh()
  return self:GetFeature(32)
end

function NpcData:GetFeature_NotifyMove()
  return self:GetFeature(64)
end

function NpcData:GetFeature_StayVisitRot()
  return self:GetFeature(128)
end

function NpcData:GetFeature_IgnoreAutoBattle()
  if self.forceSelect then
    return false
  else
    return self:GetFeature(256)
  end
end

function NpcData:GetFeature_IgnoreEffectCulling()
  return self:GetFeature(512)
end

function NpcData:GetFeature_CanAutoLock()
  if self.noAutoLock then
    return false
  end
  return self:GetFeature(8192)
end

function NpcData:GetFeature_IgnoreExtraNavmesh()
  return self:GetFeature(4096)
end

function NpcData:GetFeature_IgnoreLookAt()
  return self:GetFeature(65536)
end

function NpcData:GetFeature_ForceSelect()
  return self:GetFeature(131072)
end

function NpcData:GetFeature_IgnoreRotation()
  return self:GetFeature(262144)
end

function NpcData:GetFeature_IgnoreDress()
  return self:GetFeature(16777216)
end

function NpcData:WithPrefixName(isInScene)
  if self.affixs ~= nil then
    return NpcData.WithAffixName(self.affixs, isInScene)
  end
  return NpcData.WithCharactorName(self.charactors, isInScene)
end

function NpcData.WithCharactorName(charactors, isInScene)
  local charactorNames = ""
  local charactorConf, charactorConfig
  if isInScene then
    charactorConfig = GameConfig.MonsterCharacterColorInScene or GameConfig.MonsterCharacterColor
  else
    charactorConfig = GameConfig.MonsterCharacterColor
  end
  for i = 1, #charactors do
    charactorConf = Table_Character[charactors[i]]
    if charactorConf then
      charactorConf.Name = OverSea.LangManager.Instance():GetLangByKey(charactorConf.Name)
      local npcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
      charactorNames = charactorNames .. string.format(charactorConfig[charactorConf.NameColor], charactorConf.Name .. (i == #charactors and npcCharactorSplit or ""))
    else
      errorLog(string.format("creature id:%s charactor cannot find config %s", self.id, charactors[i]))
    end
  end
  return charactorNames
end

function NpcData.WithAffixName(affixs, isInScene)
  local affixNames = ""
  local config, colorStr
  if isInScene then
    colorStr = "<color=#FF0000>%s</color>"
  else
    colorStr = "[c][FF0000]%s[-][/c]"
  end
  for i = 1, #affixs do
    config = Table_MonsterAffix[affixs[i]]
    if config ~= nil then
      config.Name = OverSea.LangManager.Instance():GetLangByKey(config.Name)
      local npcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
      affixNames = affixNames .. string.format(colorStr, config.Name .. (i == #affixs and npcCharactorSplit or ""))
    end
  end
  return affixNames
end

function NpcData:SetBehaviourData(num)
  self.behaviourData:Set(num or 0)
  self.noPicked = self.behaviourData:GetSkillNonSelectable()
end

function NpcData.GetZoneTypeByStaticData(staticData)
  if not staticData then
    return
  end
  local str = staticData.Zone
  if str == "Field" then
    return NpcData.ZoneType.ZONE_FIELD
  elseif str == "Task" then
    return NpcData.ZoneType.ZONE_TASK
  elseif str == "EndlessTower" then
    return NpcData.ZoneType.ZONE_ENDLESSTOWER
  elseif str == "Laboratory" then
    return NpcData.ZoneType.ZONE_LABORATORY
  elseif str == "Repair" then
    return NpcData.ZoneType.ZONE_SEAL
  elseif str == "Dojo" then
    return NpcData.ZoneType.ZONE_DOJO
  elseif str == "Storm" then
    return NpcData.ZoneType.ZONE_STORM
  elseif str == "EquipUp" then
    return NpcData.ZoneType.ZONE_EQUIPUP
  elseif str == "MemoryPalace" then
    return NpcData.ZoneType.ZONE_MemoryPalace
  elseif str == "MemoryRaid" then
    return NpcData.ZoneType.ZONE_MemoryRaid
  elseif str == "MemoryThird" then
    return NpcData.ZoneType.ZONE_MemoryThird
  elseif str == "AbyssDragon" then
    return NpcData.ZoneType.ZONE_ABYSSDRAGON
  end
end

function NpcData:GetZoneType()
  return NpcData.GetZoneTypeByStaticData(self.staticData)
end

function NpcData:SetUseServerDressData(v)
  self.useServerDressData = v
end

function NpcData:GetDressParts()
  local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
  if self.useServerDressData then
    local userData = self.userdata
    if userData ~= nil then
      local cloned = NpcData.super.GetDressParts(self)
      for k, v in pairs(cloned) do
        if v == 0 then
          cloned[k] = parts[k]
        end
      end
      self:PreprocessParts(cloned)
      return cloned
    end
  else
    self:SpecialProcessParts(parts)
  end
  self:PreprocessParts(parts)
  return parts
end

function NpcData:PreprocessParts(parts)
  local id = self.staticData.DefaultRolePartID
  if id == nil then
    return
  end
  local config = Table_RoleParts[id]
  if config == nil then
    return
  end
  local PartIndex = Asset_Role.PartIndex
  local PartIndexEx = Asset_Role.PartIndexEx
  parts[PartIndexEx.DefaultBody] = config.Body
  parts[PartIndexEx.DefaultHair] = config.Hair
  parts[PartIndexEx.DefaultEye] = config.Eye
  parts[PartIndexEx.DefaultLeftWeapon] = self:GetDefaultWeapon(parts[PartIndex.LeftWeapon])
  parts[PartIndexEx.DefaultRightWeapon] = self:GetDefaultWeapon(parts[PartIndex.RightWeapon])
  parts[PartIndexEx.DefaultAll] = config.Type == 3
end

function NpcData:GetDefaultWeapon(weapon)
  if weapon == nil or weapon == 0 then
    return nil
  end
  local item = Table_Item[weapon]
  if item == nil then
    return nil
  end
  local type = item.Type
  if type == nil then
    return nil
  end
  local config = Table_RoleEquips[type]
  if config == nil then
    return nil
  end
  return config.Default
end

function NpcData:Camp_SetIsInMyGuild(val)
  if self.campHandler then
    self.campHandler:SetIsSameGuild(val)
    self.campChanged = self.campHandler.dirty
  end
end

function NpcData:Camp_SetIsInPVP(val)
  if self.campHandler then
    self.campHandler:SetIsInPvpScene(val)
    self.campChanged = self.campHandler.dirty
  end
end

function NpcData:Camp_SetIsInMyTeam(val)
  if self.campHandler then
    self.campHandler:SetIsSameTeam(val)
    self.campChanged = self.campHandler.dirty
  end
end

function NpcData:Camp_SetIsInGVG(val)
  if self.campHandler then
    self.campHandler:SetIsInGVGScene(val)
    self.campChanged = self.campHandler.dirty
  end
end

function NpcData:Camp_SetIsInTwelveScene(val)
  if self.campHandler then
    self.campHandler:SetIsInTwelveScene(val)
    self.campChanged = self.campHandler.dirty
  end
end

function NpcData:Camp_SetInSameCamp(val)
  if self.campHandler then
    self.campHandler:SetInSameCamp(val)
    self.campChanged = self.campHandler.dirty
  end
end

function NpcData:GetDetailedType()
  return self.detailedType
end

function NpcData:IsImmuneSkill(skillID)
  local immuneSkills = self.staticData.ImmuneSkill
  if immuneSkills and 0 < #immuneSkills then
    return 0 < TableUtility.ArrayFindIndex(immuneSkills, skillID)
  end
  return false
end

function NpcData:IsFly()
  return nil ~= self.behaviourData and self.behaviourData:IsFly()
end

function NpcData:DamageAlways1()
  return nil ~= self.behaviourData and 0 < self.behaviourData:GetDamageAlways1() or false
end

function NpcData:CanVisit()
  if self.forceSelect then
    return true
  end
  local behaviourData = self.behaviourData
  return behaviourData ~= nil and behaviourData:CanVisit()
end

function NpcData:SetOwnerID(ownerID)
  self.ownerID = ownerID
  self:UpdateDressEnable()
end

function NpcData:RefreshNightmareStatus()
  if not Game.Myself or Game.Myself.data.id == self.id or not Game.Myself:IsAtNightmareMap() then
    return
  end
  local nightmare = self.userdata:Get(UDEnum.NIGHTMARE) or 0
  local myNightmareLv = Game.Myself:GetNightmareLevel()
  if 0 < nightmare and 0 < myNightmareLv and nightmare <= myNightmareLv then
    self.isNightmareStatus = true
  end
end

function NpcData:IsNightmareMonster()
  return 0 < (self.userdata:Get(UDEnum.NIGHTMARE) or 0)
end

function NpcData:IsNightmareStatus()
  return self.isNightmareStatus == true
end

function NpcData:IsGvgStatue()
  return self.staticData.id == GameConfig.GVGConfig.StatueNpcID
end

function NpcData:IsGvgStatuePedestal()
  return self.staticData.id == GameConfig.GVGConfig.StatuePedestalNpcID
end

function NpcData:IsNewGvgStatuePedestal()
  local pedestalNpcID = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatuePedestalNpcID or 851041
  return self.staticData.id == pedestalNpcID
end

function NpcData:IsNewGvgStatue()
  local statueNpcID = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatueNpcID or 851042
  return self.staticData.id == statueNpcID
end

function NpcData:TrySetGvgStatueCityId()
  self.statue_city_id = GvgProxy.GetStatueCity(self.uniqueid)
end

function NpcData:SpecialProcessParts(parts)
  if self:IsNightmareStatus() then
    local bodyConfig = Table_NightmareBody and Table_NightmareBody[parts[Asset_Role.PartIndex.Body] or 0]
    if bodyConfig and bodyConfig.Crazy and bodyConfig.Crazy ~= 0 then
      parts[Asset_Role.PartIndex.Body] = bodyConfig.Crazy
    end
  elseif self:IsGvgStatue() then
    local info = GvgProxy.Instance:GetStatueInfo()
    if info ~= nil then
      local PartIndex = Asset_Role.PartIndex
      if info.body ~= nil then
        parts[PartIndex.Body] = info.body
      end
      parts[PartIndex.Hair] = info.hair
      parts[PartIndex.Head] = info.head
      parts[PartIndex.Face] = info.face
      parts[PartIndex.Eye] = info.eye
      parts[PartIndex.Mouth] = info.mouth
      parts[PartIndex.Wing] = info.back
      parts[PartIndex.Tail] = info.tail
    end
  elseif self:IsNewGvgStatue() then
    local city_id = self.statue_city_id
    local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
    local statue_info = GvgProxy.Instance:GetStatueByCityId(group_id, city_id)
    if statue_info then
      local PartIndex = Asset_Role.PartIndex
      if statue_info.body ~= nil then
        parts[PartIndex.Body] = statue_info.body
      end
      local PartIndexEx = Asset_Role.PartIndexEx
      parts[PartIndex.Hair] = statue_info.hair
      parts[PartIndex.Head] = statue_info.head
      parts[PartIndex.Face] = statue_info.face
      parts[PartIndex.Eye] = statue_info.eye
      parts[PartIndex.Mouth] = statue_info.mouth
      parts[PartIndex.Wing] = statue_info.back
      parts[PartIndex.Tail] = statue_info.tail
    end
  elseif self:IsTripleStatue() or self:IsTeamPwsStatue() or self:IsTwelveStatue() then
    local sType = PvpProxy.Instance:GetStatueType(self.staticData.id)
    local info = PvpProxy.Instance:GetStatueInfo(sType)
    if info and info.statueInfo then
      local statue_info = info.statueInfo
      local PartIndex = Asset_Role.PartIndex
      if statue_info.body ~= nil then
        parts[PartIndex.Body] = statue_info.body
      end
      local PartIndexEx = Asset_Role.PartIndexEx
      parts[PartIndex.Hair] = statue_info.hair
      parts[PartIndex.Head] = statue_info.head
      parts[PartIndex.Face] = statue_info.face
      parts[PartIndex.Eye] = statue_info.eye
      parts[PartIndex.Mouth] = statue_info.mouth
      parts[PartIndex.Wing] = statue_info.back
      parts[PartIndex.Tail] = statue_info.tail
      parts[PartIndexEx.HairColorIndex] = statue_info.haircolor
    end
  elseif self:IsSoulNpc() then
    local camp = self:GetCamp()
    local SoulNpcCamp = GameConfig.SoulNpcBody
    if SoulNpcCamp and camp and SoulNpcCamp[camp] then
      parts[Asset_Role.PartIndex.Body] = SoulNpcCamp[camp].bodyid
    end
  elseif self:IsWarehouseNpc() then
    local camp = self:GetCamp()
    local WarehouseNpcCamp = GameConfig.WarehouseNpcCamp
    if WarehouseNpcCamp and camp and WarehouseNpcCamp[camp] then
      parts[Asset_Role.PartIndex.Body] = WarehouseNpcCamp[camp].bodyid
    end
  end
  NpcData.super.SpecialProcessParts(self, parts)
end

function NpcData:GetTeamID()
  return self.teamid
end

function NpcData:GetGroupTeamID()
  return self.groupid
end

function NpcData:NoPicked()
  if self.forceSelect then
    return false
  end
  return 0 < self.noPicked
end

function NpcData:GetMasterUser()
  if self.ownerID then
    local owner = SceneCreatureProxy.FindCreature(self.ownerID)
    return owner and owner.data
  end
  return nil
end

function NpcData:GetDamageData()
  if self:IsGhostNpc_Detail() or SkillProxy.Instance:IsMonsterSkill(self.staticData.id) then
    local masterdata = self:GetMasterUser()
    if masterdata ~= nil then
      return masterdata
    end
  end
  return self
end

function NpcData:GetPriority()
  return self.priority
end

function NpcData:HasOutline()
  return self.staticData.OutlineColor and self.staticData.OutlineColor.color
end

local globalActNpc = GameConfig.ActivityNpcGear

function NpcData:GetTimeControlGear()
  if not globalActNpc then
    return
  end
  local globalActList = globalActNpc[self.staticData.id]
  if globalActList then
    for k, v in pairs(globalActList) do
      if FunctionActivity.Me():IsActivityRunning(k) then
        local activityData = FunctionActivity.Me():GetActivityData(k)
        local startTimeStamp = activityData and activityData.whole_starttime
        local curTime = ServerTime.CurServerTime() / 1000
        if startTimeStamp > curTime then
          return nil
        end
        local passedTime = math.floor((curTime - startTimeStamp) / 86400)
        local actionState
        for i = 1, #v do
          local single = v[i]
          if passedTime > single.timepass then
            actionState = single.state
          end
        end
        return actionState
      end
    end
  end
end

function NpcData:IsRobotNpc()
  return self.detailedType == NpcData.NpcDetailedType.RobotNpc
end

function NpcData:SetNoPunishBoss()
  self.noPunishBoss = self:IsRareElite_Detail() or self:IsWorldBoss_Detail()
  if self.GetRaidType and self:GetRaidType() == FuBenCmd_pb.ERAIDTYPE_DEADBOSS then
    self.noPunishBoss = true
  end
end

function NpcData:DoConstruct(asArray, serverData)
  NpcData.super.DoConstruct(self, asArray, serverData)
  self.dressEnable = true
  self:Set(serverData)
end

function NpcData:Set(data)
  if data and data.__isclient then
    self:InitByClient(data)
  else
    self:InitByServerData(data)
  end
end

function NpcData:SetClientData(clientData)
  self.clientData = clientData
end

function NpcData:GetClientData()
  return self.clientData
end

function NpcData:ClearClientData()
  if self.clientData then
    NpcData.DestroyClientData(self.clientData)
    self:SetClientData(nil)
  end
end

function NpcData:SetClientDataPos(pos)
  if self.clientData then
    if not self.clientData.pos then
      self.clientData.pos = getTable()
    end
    self.clientData.pos.x = pos[1] * 1000
    self.clientData.pos.y = pos[2] * 1000
    self.clientData.pos.z = pos[3] * 1000
  end
end

function NpcData:SetClientDataDir(dir)
  if self.clientData then
    self.clientData.dir = dir * 1000
  end
end

function NpcData:InitByClient(clientData)
  if not clientData.npcID then
    errorLog(string.format("找不到Npc配置,%s", clientData.npcID))
    return
  end
  self.initedByServer = false
  self.id = clientData.id
  self:SetClientData(clientData)
  self.staticData = _Table_Monster(clientData.npcID) or _Table_Npc(clientData.npcID)
  self.uniqueid = clientData.uniqueid
  self.name = self.staticData.NameZh
  self.idleAction = clientData.idleAction
  self.teamid = nil
  self.groupid = nil
  self.followTargetOffset = nil
  self.affixs = nil
  self.isBossFromBranch = nil
  self.shape = self.staticData.Shape
  self.race = self.staticData.Race_Parsed
  self.detailedType = NpcData.NpcDetailedType[self.staticData.Type]
  self.bosstype = _Table_Boss(clientData.npcID) and _Table_Boss(clientData.npcID).Type
  self.boss = self:IsBoss() or self:IsRareElite_Detail() or self:IsWorldBoss_Detail()
  self.mini = self:IsMini() or self:GetFeature_FakeMini()
  self.camp = RoleDefines_Camp.NEUTRAL
  local npcmonsterUtility = NpcMonsterUtility
  if npcmonsterUtility.IsMonsterByData(self.staticData) then
    self.type = NpcData.NpcType.Monster
    self.camp = RoleDefines_Camp.ENEMY
  elseif npcmonsterUtility.IsPetByData(self.staticData) then
    self.type = NpcData.NpcType.Pet
  else
    self.type = NpcData.NpcType.Npc
    if npcmonsterUtility.IsNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.NEUTRAL
    elseif npcmonsterUtility.IsFriendNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.FRIEND
      if HeadwearRaidProxy.Instance:IsHeadwearRaidTower(self.staticData.id) then
        self.camp = RoleDefines_Camp.NEUTRAL
      end
    end
    if self.staticData.Type == "WeaponPet" or self.staticData.Type == "SkillNpc" or self.staticData.Type == "RobotNpc" then
      self.camp = RoleDefines_Camp.FRIEND
    end
  end
  self.campHandler = nil
  self.isSkada = GameConfig.Home.SkadaNpcIDs and TableUtility.ArrayFindIndex(GameConfig.Home.SkadaNpcIDs, self.staticData.id) > 0
  local comodoconfig = GameConfig.ComodoRaid
  self.isSanityNPC = (comodoconfig and comodoconfig.SanityNpc) == self.staticData.id
  self.zoneType = self:GetZoneType()
  self:SetBehaviourData(self.staticData.Behaviors)
  self.changelinepunish = self:GetFeature_ChangeLinePunish()
  self.noPunishBoss = self:IsRareElite_Detail() or self:IsWorldBoss_Detail()
  self.bodyScale = self:GetDefaultScale()
  self:SpawnCullingID()
  self.search = nil
  self.searchrange = nil
  self:SetOwnerID(nil)
  self.furnitureID = nil
  self.pushableobjID = nil
  self.isRareElite = self:IsRareElite_Detail()
  self.skillID = nil
  self.skillOwner = nil
  self.field = true
  self.star = self.staticData.IsStar == 1
end

function NpcData:IsInitedByServer()
  return self.initedByServer
end

function NpcData:InitByServerData(serverData)
  self.initedByServer = true
  self.id = serverData.id
  self.uniqueid = serverData.uniqueid
  self:TrySetGvgStatueCityId()
  self.name = serverData.name
  if serverData.waitaction == "" then
  end
  self.idleAction = serverData.waitaction
  self.teamid = serverData.teamid
  self.groupid = serverData.groupid
  self.followTargetOffset = serverData.followTargetOffset
  if serverData.character and #serverData.character > 0 then
    TableUtility.ArrayShallowCopy(self.charactors, serverData.character)
  end
  if serverData.affix and 0 < #serverData.affix then
    if self.affixs == nil then
      self.affixs = ReusableTable.CreateArray()
    end
    TableUtility.ArrayShallowCopy(self.affixs, serverData.affix)
  end
  if self.staticData == nil or self.staticData.id ~= serverData.npcID then
    self.staticData = _Table_Monster(serverData.npcID)
    if self.staticData == nil then
      self.staticData = _Table_Npc(serverData.npcID)
    end
    if self.staticData == nil then
      errorLog(string.format("找不到Npc配置,%s", serverData.npcID))
      LogUtility.InfoFormat("<color=red>找不到Npc配置,{0}</color>", serverData.npcID)
      return
    end
    self.shape = self.staticData.Shape
    self.race = self.staticData.Race_Parsed
    self.detailedType = NpcData.NpcDetailedType[self.staticData.Type]
  end
  local isMercenaryCat = false
  self.camp = RoleDefines_Camp.NEUTRAL
  local npcmonsterUtility = NpcMonsterUtility
  if npcmonsterUtility.IsMonsterByData(self.staticData) then
    self.type = NpcData.NpcType.Monster
    self.camp = RoleDefines_Camp.ENEMY
  elseif npcmonsterUtility.IsPetByData(self.staticData) then
    self.type = NpcData.NpcType.Pet
  else
    self.type = NpcData.NpcType.Npc
    if npcmonsterUtility.IsNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.NEUTRAL
    elseif npcmonsterUtility.IsFriendNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.FRIEND
      if HeadwearRaidProxy.Instance:IsHeadwearRaidTower(self.staticData.id) then
        self.camp = RoleDefines_Camp.NEUTRAL
      end
    end
    if self.staticData.Type == "WeaponPet" or self.staticData.Type == "SkillNpc" or self.staticData.Type == "RobotNpc" then
      self.camp = RoleDefines_Camp.FRIEND
      if self.staticData.Type == "WeaponPet" then
        isMercenaryCat = true
      end
    end
  end
  if not isMercenaryCat and not self:IsNpc() then
    if self.teamid and not self.campHandler then
      self.campHandler = CampHandler.new(self.camp)
    end
    if self.groupid and not self.campHandler then
      self.campHandler = CampHandler.new(self.camp)
    end
    if serverData.guildid and serverData.guildid ~= 0 then
      if not self.campHandler then
        self.campHandler = CampHandler.new(self.camp)
      end
      TableUtility.ArrayClear(tempArray)
      tempArray[1] = serverData.guildid
      tempArray[2] = serverData.guildname
      tempArray[3] = serverData.guildicon
      tempArray[4] = serverData.guildjob
      self:SetGuildData(tempArray)
    end
  end
  if self:IsTripleTeamRobot() and not self.campHandler then
    self.campHandler = CampHandler.new()
  end
  self.bosstype = serverData.npcID and _Table_Boss(serverData.npcID) and _Table_Boss(serverData.npcID).Type
  self.boss = self:IsBoss() or self:IsRareElite_Detail() or self:IsWorldBoss_Detail()
  self.mini = self:IsMini() or self:GetFeature_FakeMini()
  self.isSkada = GameConfig.Home.SkadaNpcIDs and 0 < TableUtility.ArrayFindIndex(GameConfig.Home.SkadaNpcIDs, self.staticData.id)
  local comodoconfig = GameConfig.ComodoRaid
  self.isSanityNPC = (comodoconfig and comodoconfig.SanityNpc) == self.staticData.id
  self.zoneType = self:GetZoneType()
  self:SetBehaviourData(serverData.behaviour)
  self.changelinepunish = self:GetFeature_ChangeLinePunish()
  self.isBossFromBranch = serverData.isBossFromBranch
  self:SetNoPunishBoss()
  self:SpawnCullingID()
  self.bodyScale = self:GetDefaultScale()
  self.search = serverData.search
  self.searchrange = serverData.searchrange
  self:SetOwnerID(serverData.owner)
  self.furnitureID = serverData.furnguid
  self.pushableobjID = serverData.boxid
  if self.pushableobjID then
    self:Push_SetDirection(serverData.direction)
  end
  self.isRareElite = self:IsRareElite_Detail()
  self.skillID = serverData.skillid
  self.skillOwner = serverData.skillowner
  if self.skillID ~= 0 then
    self.priority = GetNpcPriority(self)
    self.dressEnable = Game.EffectManager:GetNpcLevel(self.priority)
  end
  self.born_se = serverData.se
  self.born_se_loop = serverData.se_loop
  self.postcard = serverData.postcard
end

function NpcData:SetNoAutoLock(val)
  self.noAutoLock = val
end

function NpcData:GetNoAutoLock(val)
  return self.noAutoLock
end

function NpcData:DoDeconstruct(asArray)
  NpcData.super.DoDeconstruct(self, asArray)
  self.initedByServer = nil
  self.noAutoLock = nil
  self:Push_ClearData()
  self.staticData = nil
  self.bosstype = nil
  self.campHandler = nil
  self.useServerDressData = false
  self.furnitureID = nil
  TableUtility.ArrayClear(self.charactors)
  if self.affixs ~= nil then
    ReusableTable.DestroyAndClearArray(self.affixs)
    self.affixs = nil
  end
  self.isNightmareStatus = nil
  self.teamid = nil
  self.forceSelect = false
  self.skillID = nil
  self.skillOwner = nil
  self.priority = nil
  self.born_se = nil
  self.born_se_loop = nil
  self.postcard = nil
  self.serverBossType = nil
  self:ClearClientData()
end

function NpcData:SetBossType(bossType)
  if self:IsMonster_Detail() then
    self.boss = bossType == 1
    self.mini = bossType == 2
  end
end

function NpcData:GetNature()
  if not HomeManager.Me():IsAtHome() or StringUtil.IsEmpty(self.furnitureID) then
    return 0
  end
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.furnitureID)
  if furnitureData and furnitureData.woodNature then
    for nameEn, id in pairs(CommonFun.Nature) do
      if furnitureData.woodNature == id then
        return nameEn
      end
    end
  end
end

function NpcData:GetNatureLv()
  if not HomeManager.Me():IsAtHome() or StringUtil.IsEmpty(self.furnitureID) then
    return 0
  end
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.furnitureID)
  return furnitureData and furnitureData.woodNatureLv or 0
end

function NpcData:UpdateDressEnable()
  if not self:ShouldUpdateDressEnable() then
    return
  end
  local masterdata = self:GetMasterUser()
  if masterdata == nil then
    return
  end
  self:SetDressEnable(masterdata:IsDressEnable())
end

function NpcData:ShouldUpdateDressEnable()
  local config = GameConfig.TextMesh
  if config[self.staticData.id] ~= nil then
    return true
  end
  return false
end

function NpcData:IsVirtual()
  local body = self.staticData.Body
  if body == nil then
    return false
  end
  return GameConfig.DirtyBuff.VirtualBody[body] ~= nil
end

function NpcData:GetBalanceConfigID()
  return self.staticData.BalanceBar
end

function NpcData:GetAppearanceAnimation()
  return self.userdata:Get(UDEnum.APPEARANCE_ANIMATION)
end

function NpcData:ClearAppearanceAnimation()
  self.userdata:Set(UDEnum.APPEARANCE_ANIMATION, 0)
end

function NpcData:GetFeature_NotCostTime()
  return self:GetFeature(524288)
end

function NpcData:GetFeature_CostCount()
  return self:GetFeature(8388608)
end

function NpcData:isCostBattleCount()
  if self:GetFeature_CostCount() then
    return true
  end
  return self.staticData.Condition and self.staticData.Condition ~= 0 and self.staticData.IsStar ~= 1 and self.detailedType ~= "MINI" and self.detailedType ~= "MVP" and not self:GetFeature_NotCostTime()
end

function NpcData:ForbidClientClient()
  return self.staticData.Params and self.staticData.Params.ForbidClientClick == 1
end

function NpcData:IsTriplePed()
  local statueNpcID = GameConfig.PvpStatue and GameConfig.PvpStatue.TriplePedestalNpcID or 851003
  return self.staticData.id == statueNpcID
end

function NpcData:IsTeamPwsPed()
  local statueNpcID = GameConfig.PvpStatue and GameConfig.PvpStatue.TeampwsPedestalNpcID or 851004
  return self.staticData.id == statueNpcID
end

function NpcData:IsTwelvePed()
  local statueNpcID = GameConfig.PvpStatue and GameConfig.PvpStatue.TwelvePedestalNpcID or 851005
  return self.staticData.id == statueNpcID
end

function NpcData:IsTripleStatue()
  local statueNpcID = GameConfig.PvpStatue and GameConfig.PvpStatue.TripleNpcID or 851006
  return self.staticData.id == statueNpcID
end

function NpcData:IsTeamPwsStatue()
  local statueNpcID = GameConfig.PvpStatue and GameConfig.PvpStatue.TeampwsNpcID or 851007
  return self.staticData.id == statueNpcID
end

function NpcData:IsTwelveStatue()
  local statueNpcID = GameConfig.PvpStatue and GameConfig.PvpStatue.TwelveNpcID or 851008
  return self.staticData.id == statueNpcID
end

function NpcData:GetPvpStatueType()
  if self:IsTripleStatue() then
    return PvpProxy.StatueType.Triple
  end
  if self:IsTeamPwsStatue() then
    return PvpProxy.StatueType.Teampws
  end
  if self:IsTwelveStatue() then
    return PvpProxy.StatueType.Twelve
  end
  return nil
end

function NpcData:IsPhantom()
  return self.detailedType == NpcData.NpcDetailedType.NormalPhantom or self.detailedType == NpcData.NpcDetailedType.PerfectPhantom
end

function NpcData:IsPerfectPhantom()
  return self.detailedType == NpcData.NpcDetailedType.PerfectPhantom
end
