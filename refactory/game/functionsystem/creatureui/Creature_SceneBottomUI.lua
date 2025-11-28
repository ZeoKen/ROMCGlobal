Creature_SceneBottomUI = reusableClass("Creature_SceneBottomUI")
Creature_SceneBottomUI.PoolSize = 100
autoImport("SceneBottomHpSpCell")
autoImport("SceneBottomNameFactionCell")
autoImport("SceneBottomHeadwearRaidTowerInfoCell")
autoImport("NSceneBottomHeadwearRaidTowerInfoCell")
local SceneBottomHeadwearRaidTowerInfoCell_Class = SceneUIManager.UseUGUI and NSceneBottomHeadwearRaidTowerInfoCell or SceneBottomHeadwearRaidTowerInfoCell
local AddToEmptyGOPool = GOLuaPoolManager.AddToEmptyGOPool
local GetFromEmptyGOPool = GOLuaPoolManager.GetFromEmptyGOPool
local IS_RUNON_EDITOR = ApplicationInfo.IsRunOnEditor()

function Creature_SceneBottomUI:ctor()
  Creature_SceneBottomUI.super.ctor(self)
end

local FindCreature = function(id)
  local creature = NSceneNpcProxy.Instance:GetClientNpc(id)
  if not creature then
    creature = SceneCreatureProxy.FindCreature(id)
    creature = creature or NSceneNpcProxy.Instance:GetClientNpcByGUID(id)
  end
  return creature
end
local cellData = {}

function Creature_SceneBottomUI:SetCreature(creature)
  local removeName = self:removeNameFaction()
  local removeHpSp = self:removeCreatingHpSp()
  self.id = creature.data.id
  self.isDead = creature:IsDead()
  if removeName then
    self:checkCreateNameFaction(creature)
  end
  if removeHpSp then
    self:checkCreateHpSp(creature)
  end
  self:checkCreateHeadwearRaidTowerInfo(creature)
end

function Creature_SceneBottomUI:DoConstruct(asArray, creature)
  self.followParents = {}
  self.isSelected = false
  self.isBeHit = false
  self.tryUpdateSanity = false
  self.savedValue = nil
  self:SetCreature(creature)
end

function Creature_SceneBottomUI:GetSceneUIBottomFollow(type, creature)
  if not type then
    return
  end
  if not self.followParents[type] then
    local container = SceneUIManager.Instance:GetSceneUIContainer(type)
    if container then
      local follow = GetFromEmptyGOPool(Game.GOLuaPoolManager, "empty", container)
      if IS_RUNON_EDITOR then
        follow.name = orginStringFormat("RoleBottomFollow_%s", creature.data:GetName())
      end
      local followTransform = follow.transform
      followTransform:SetParent(container.transform, false)
      followTransform.localRotation = LuaGeometry.Const_Qua_identity
      followTransform.localScale = LuaGeometry.Const_V3_one
      follow.layer = container.layer
      creature:Client_RegisterFollow(followTransform, LuaGeometry.GetTempVector3(0, -0.15, 0), 0)
      self.followParents[type] = follow
    end
  end
  return self.followParents[type]
end

function Creature_SceneBottomUI:UnregisterSceneUITopFollows()
  for key, follow in pairs(self.followParents) do
    if not LuaGameObject.ObjectIsNull(follow) then
      Game.RoleFollowManager:UnregisterFollow(follow.transform)
      AddToEmptyGOPool(Game.GOLuaPoolManager, "empty", follow)
    end
    self.followParents[key] = nil
  end
end

function Creature_SceneBottomUI:DoDeconstruct(asArray)
  self:DestroyBottomUI()
  self:UnregisterSceneUITopFollows()
end

function Creature_SceneBottomUI:isHpSpVisible(creature)
  local id = creature.data.id
  local camp = creature.data:GetCamp()
  local neutral = RoleDefines_Camp.NEUTRAL == camp
  local creatureType = creature:GetCreatureType()
  local isMyself = creatureType == Creature_Type.Me
  local isPet = creatureType == Creature_Type.Pet
  local isPlayer = creatureType == Creature_Type.Player
  local isSelected = self.isSelected
  local isDead = self.isDead
  local detailedType = creature.data.detailedType
  local isWeaponPet = detailedType == NpcData.NpcDetailedType.WeaponPet
  local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP
  local isSkada = creature.data.isSkada
  local isInTwelvePVP = Game.MapManager:IsPvPMode_TeamTwelve()
  local isInDesertWolf = Game.MapManager:IsPvpMode_DesertWolf()
  local maskBloodIndex = creature:IsUIMask(MaskPlayerUIType.BloodType) or nil
  local maskBNHFEIndex = creature:IsUIMask(MaskPlayerUIType.BloodNameHonorFactionEmojiType) or nil
  local inEdMap = false
  local mapId = Game.MapManager:GetMapID()
  if mapId then
    local raidData = Table_MapRaid[mapId]
    inEdMap = raidData and raidData.Type == 11 or false
  end
  local mask = maskBloodIndex ~= nil or maskBNHFEIndex ~= nil
  local isSkillNpc = self:IsSkillNpc(detailedType)
  local isFarmingNpc = self:IsFarmingNpc(detailedType)
  local isSanityNPC = creature.data.isSanityNPC
  local IsPippi = creature.data:IsPippi()
  local isPhatom = creature.data:IsPhantom()
  local isInVisible = mask or inEdMap or isPet and not isSkillNpc and not isWeaponPet and not IsPippi and not isPhatom or neutral or isDead or creature.needMaskUI or isSanityNPC
  local isOb = PvpObserveProxy.Instance:IsRunning()
  local mapVisible = GameConfig.MapHpSpVisible and GameConfig.MapHpSpVisible[mapId]
  local isEBFRobot = detailedType == NpcData.NpcDetailedType.EBF_Robot
  local isTripleTeamRobot = detailedType == NpcData.NpcDetailedType.TriplePvpRobot
  local isHideHp = creature:IsHideHp()
  if not (not mapVisible or isOb) and (isFarmingNpc or isPlayer or isEBFRobot or isTripleTeamRobot) or isSanityNPC then
    if mapVisible == 0 then
      return false
    elseif mapVisible == 1 then
      return isSelected
    else
      return true
    end
  elseif isOb and (isFarmingNpc or isPlayer) then
    return true
  elseif isInVisible then
    return false
  elseif isMyself or TeamProxy.Instance:IsInMyTeam(id) or isSkillNpc or isPhatom and camp ~= RoleDefines_Camp.ENEMY then
    return true
  elseif camp ~= RoleDefines_Camp.ENEMY then
    if isSelected then
      return true
    end
  elseif isSelected or isMvpOrMini or self.isBeHit and not isSkada then
    return not isHideHp
  end
  return false
end

function Creature_SceneBottomUI:IsSkillNpc(detailedType)
  local _NpcDetailedType = NpcData.NpcDetailedType
  if detailedType == _NpcDetailedType.SkillNpc then
    return true
  end
  if detailedType == _NpcDetailedType.PioneerNpc then
    return true
  end
  if detailedType == _NpcDetailedType.ShadowNpc then
    return true
  end
  if detailedType == _NpcDetailedType.GhostNpc then
    return true
  end
  if detailedType == _NpcDetailedType.CopyNpc then
    return true
  end
  if detailedType == _NpcDetailedType.SoulNpc then
    return true
  end
  if detailedType == _NpcDetailedType.FollowMaster then
    return true
  end
  return false
end

function Creature_SceneBottomUI:IsFarmingNpc(detailedType)
  local _NpcDetailedType = NpcData.NpcDetailedType
  if detailedType == _NpcDetailedType.DefenseTower then
    return true
  end
  if detailedType == _NpcDetailedType.PushMinion then
    return true
  end
  if detailedType == _NpcDetailedType.TwelveBase then
    return true
  end
  if detailedType == _NpcDetailedType.TwelveBarrack then
    return true
  end
  return false
end

function Creature_SceneBottomUI:removeCreatingHpSp()
  if self.asyncCreatingHpSp then
    self.asyncCreatingHpSp = false
    Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomHpSpCell.resId)
    return true
  end
  return false
end

function Creature_SceneBottomUI:checkCreateHpSp(creature)
  if self.hpSpCell then
  elseif self:isHpSpVisible(creature) then
    local parent = self:GetBottomObjParent(creature)
    if parent then
      self.asyncCreatingHpSp = true
      Game.CreatureUIManager:AsyncCreateUIAsset(self.id, SceneBottomHpSpCell.resId, parent, self.createHpSpCellFinish, self)
    end
  end
end

function Creature_SceneBottomUI.createHpSpCellFinish(obj, self)
  self.asyncCreatingHpSp = false
  if not obj then
    return
  end
  local creature = FindCreature(self.id)
  TableUtility.ArrayClear(cellData)
  cellData[1] = obj
  cellData[2] = creature
  Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomHpSpCell.resId)
  self.hpSpCell = SceneBottomHpSpCell.CreateAsArray(cellData)
  TableUtility.ArrayClear(cellData)
  local isVisible = self:isHpSpVisible(creature)
  self.hpSpCell:setHpSpVisible(isVisible)
  if self.tryUpdateSanity then
    self.hpSpCell:UpdateSanity(self.savedValue)
    self.savedValue = nil
  end
end

function Creature_SceneBottomUI:GetBottomObjParent(creature)
  local parent
  if creature:GetCreatureType() == Creature_Type.Npc then
    if creature.data:IsMonster() then
      parent = self:GetSceneUIBottomFollow(SceneUIType.MonsterBottomInfo, creature)
    else
      parent = self:GetSceneUIBottomFollow(SceneUIType.NpcBottomInfo, creature)
    end
  elseif self:IsStaticPlayerType(creature) then
    parent = self:GetSceneUIBottomFollow(SceneUIType.StaticPlayerBottomInfo, creature)
  else
    parent = self:GetSceneUIBottomFollow(SceneUIType.PlayerBottomInfo, creature)
  end
  return parent
end

function Creature_SceneBottomUI:IsStaticPlayerType(creature)
  if not creature then
    return
  end
  if creature.IsInBooth and creature:IsInBooth() then
    return true
  end
  return false
end

function Creature_SceneBottomUI:SetHp(ncreature)
  local hp = ncreature.data:GetHP()
  self.isDead = hp <= 0
  if self.hpSpCell then
    local buffhp, buffmaxhp = ncreature.data:GetBuffHpVals()
    if buffhp then
      self.hpSpCell:SetHp(buffhp, buffmaxhp or 1)
    else
      local maxHp = ncreature.data.props:GetPropByName("MaxHp"):GetValue()
      if self.isDead then
        self.hpSpCell.deadSlideAnim = true
      end
      self.hpSpCell:SetHp(hp, maxHp)
    end
    local isHpSpVisible = self:isHpSpVisible(ncreature)
    if isHpSpVisible then
      self.hpSpCell:setHpSpVisible(true)
    end
  end
end

function Creature_SceneBottomUI:SetSp(ncreature)
  if self.hpSpCell then
    local sp = ncreature.data.props:GetPropByName("Sp"):GetValue()
    local maxSp = ncreature.data.props:GetPropByName("MaxSp"):GetValue()
    local spTrans = ncreature.data.spTrans
    self.hpSpCell:SetSp(sp, maxSp, spTrans)
  end
end

function Creature_SceneBottomUI:SetShieldHp(hp, maxhp)
  if self.hpSpCell then
    self.hpSpCell:SetShieldHp(hp, maxhp)
  end
end

function Creature_SceneBottomUI:SetResistance(creature)
  if self.hpSpCell then
    self.hpSpCell:SetResistance(creature)
  end
end

function Creature_SceneBottomUI:isNameFactionVisible(creature)
  local id = creature.data.id
  local camp = creature.data:GetCamp()
  local creatureType = creature:GetCreatureType()
  local isMyself = creatureType == Creature_Type.Me
  local isPet = creatureType == Creature_Type.Pet
  local isPlayer = creatureType == Creature_Type.Player
  local isMyPet = isPet and creature:IsMyPet() or false
  local isNpc = creatureType == Creature_Type.Npc
  local isMonster = creature.data:IsMonster()
  local isSelected = self.isSelected
  local detailedType = creature.data.detailedType
  local maskBloodIndex = creature:IsUIMask(MaskPlayerUIType.NameType) or nil
  local maskBNHFIndex = creature:IsUIMask(MaskPlayerUIType.NameHonorFactionType) or nil
  local maskBNHFEIndex = creature:IsUIMask(MaskPlayerUIType.BloodNameHonorFactionEmojiType) or nil
  local perfSetting = FunctionPerformanceSetting.Me()
  local showName = true
  if isMyself then
    showName = perfSetting:ShouldShowMyselfName()
  elseif isMyPet then
    showName = isSelected or perfSetting:ShouldShowMyFollowerName()
  elseif isPlayer or isPet then
    showName = isSelected or perfSetting:IsShowOtherName()
  elseif isNpc and not isMonster then
    showName = isSelected or perfSetting:ShouldShowNpcName()
  end
  local mask = not showName or maskBloodIndex ~= nil or maskBNHFIndex ~= nil or maskBNHFEIndex ~= nil
  isPlayer = isPlayer or creatureType == Creature_Type.Me
  local isCatchPet = isPet and creature.data.IsPet and creature.data:IsPet()
  local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP
  local isInMyTeam = TeamProxy.Instance:IsInMyTeam(id)
  local isTripleTeamRobot = detailedType == NpcData.NpcDetailedType.TriplePvpRobot
  local allShowName = false
  local allInVisible = false
  local selectShow = false
  local creatureShowName = creature:GetShowName()
  if creatureShowName then
    allShowName = creatureShowName == 2
    allInVisible = creatureShowName == 1
    selectShow = creatureShowName == 0
    selectShow = selectShow and isSelected or false
  end
  local visible = isPlayer or selectShow or isCatchPet or isMyPet or isMvpOrMini or isInMyTeam or isSelected or allShowName or creature.needMaskUI or isTripleTeamRobot
  visible = visible and not allInVisible
  if mask then
    return false
  else
    return visible
  end
end

function Creature_SceneBottomUI:checkCreateNameFaction(creature)
  local isVisible = self:isNameFactionVisible(creature)
  if isVisible then
    self:createNameFaction(creature)
  end
end

function Creature_SceneBottomUI:removeNameFaction()
  return DynamicSceneBottomUIPool.Me():removeWaiting(self.id)
end

function Creature_SceneBottomUI:createNameFaction(creature)
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  DynamicSceneBottomUIPool.Me():create(self.id, parent, creature)
end

function Creature_SceneBottomUI:HandleSettingMask(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
  else
    self:checkCreateNameFaction(creature)
  end
end

function Creature_SceneBottomUI:HandlerPlayerFactionChange(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetFaction(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end

function Creature_SceneBottomUI:HandleChangeTitle(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetName(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end

function Creature_SceneBottomUI:HandleOB(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetName(creature)
    self.nameFactionCell:SetFaction(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end

function Creature_SceneBottomUI:HandlerMemberDataChange(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
end

function Creature_SceneBottomUI:HandleCampChange(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
    self.hpSpCell:setCamp(creature.data:GetCamp())
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
    self.nameFactionCell:SetName(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end

function Creature_SceneBottomUI:SetIsSelected(isSelected, creature)
  self.isSelected = isSelected
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible, isVisible)
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
  else
    self:checkCreateNameFaction(creature)
  end
end

function Creature_SceneBottomUI:SetIsBeHit(isBeHit, creature)
  self.isBeHit = isBeHit
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
end

function Creature_SceneBottomUI:ActiveSpHpCell(active, creature)
  creature = creature or FindCreature(self.id)
  if not creature then
    redlog("没找到: ", self.id)
    return
  end
  if active then
    if self.hpSpCell and self:isHpSpVisible(creature) then
      if LuaGameObject.ObjectIsNull(self.hpSpCell.gameObject) then
        redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data:GetName())
      else
        self.hpSpCell:setHpSpVisible(active)
      end
    else
      self:checkCreateHpSp(creature)
    end
  elseif self.hpSpCell then
    if LuaGameObject.ObjectIsNull(self.hpSpCell.gameObject) then
      redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data and creature.data:GetName() or "creature data is nil")
    else
      self.hpSpCell:setHpSpVisible(active)
    end
  end
end

function Creature_SceneBottomUI:ActiveNameFactionCell(active, creature)
  creature = creature or FindCreature(self.id)
  if not creature then
    return
  end
  if active then
    if self.nameFactionCell and self:isNameFactionVisible(creature) then
      if LuaGameObject.ObjectIsNull(self.nameFactionCell.gameObject) then
        redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data:GetName())
      else
        self.nameFactionCell:SetActive(active)
      end
    else
      self:checkCreateNameFaction(creature)
    end
  elseif self.nameFactionCell then
    if LuaGameObject.ObjectIsNull(self.nameFactionCell.gameObject) then
      redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data and creature.data:GetName() or "creature data is nil")
    else
      self.nameFactionCell:SetActive(active)
    end
  end
end

function Creature_SceneBottomUI:ActiveSceneUI(maskPlayerUIType, active, creature)
  if maskPlayerUIType == MaskPlayerUIType.BloodType then
    self:ActiveSpHpCell(active, creature)
  elseif maskPlayerUIType == MaskPlayerUIType.BloodNameHonorFactionEmojiType then
    self:ActiveSpHpCell(active, creature)
    self:ActiveNameFactionCell(active, creature)
  elseif maskPlayerUIType == MaskPlayerUIType.NameType then
    self:ActiveNameFactionCell(active, creature)
  elseif maskPlayerUIType == MaskPlayerUIType.NameHonorFactionType then
    self:ActiveNameFactionCell(active, creature)
  end
end

function Creature_SceneBottomUI:DestroyBottomUI()
  if self.nameFactionCell then
    DynamicSceneBottomUIPool.Me():cache(self.nameFactionCell)
  end
  if self.hpSpCell then
    ReusableObject.Destroy(self.hpSpCell)
  end
  self:removeNameFaction()
  self:removeCreatingHpSp()
  self.hpSpCell = nil
  self.nameFactionCell = nil
end

function Creature_SceneBottomUI:SetQuestPrefixVisible(creature, isShow)
  if self.nameFactionCell then
    self.nameFactionCell:SetQuestPrefixName(creature, isShow)
  end
end

function Creature_SceneBottomUI:BoothStateChange(creature)
  if not self.nameFactionCell and not self.hpSpCell then
    return
  end
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  if self.nameFactionCell then
    SetParent(self.nameFactionCell.gameObject, parent)
    self.nameFactionCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, creature:GetCreatureType() == Creature_Type.Me and -19 or -10)
    self.nameFactionCell.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.nameFactionCell.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  end
  if self.hpSpCell then
    SetParent(self.hpSpCell.gameObject, parent)
    self.hpSpCell.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
    self.hpSpCell.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.hpSpCell.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  end
end

function Creature_SceneBottomUI:checkCreateHeadwearRaidTowerInfo(creature)
  if not self:isHeadwearRaidTowerInfoVisible(creature) or self.towerInfoCell then
  else
    self:createHeadwearRaidTowerInfoCell(creature)
  end
end

function Creature_SceneBottomUI:isHeadwearRaidTowerInfoVisible(creature)
  return Game.MapManager:IsPVEMode_HeadwearRaid() and creature.data and creature.data.staticData and HeadwearRaidProxy.Instance:IsHeadwearRaidTower(creature.data.staticData.id)
end

function Creature_SceneBottomUI:removeHeadwearRaidTowerCreating()
  if self.asyncCreatingHeadwear then
    Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomHeadwearRaidTowerInfoCell_Class.ResID)
    self.asyncCreatingHeadwear = false
    return true
  end
  return false
end

function Creature_SceneBottomUI:createHeadwearRaidTowerInfoCell(creature)
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  self.asyncCreatingHeadwear = true
  local tempArgs = {}
  tempArgs[1] = self
  tempArgs[2] = creature
  Game.CreatureUIManager:AsyncCreateUIAsset(self.id, SceneBottomHeadwearRaidTowerInfoCell_Class.ResID, parent, self.createHeadwearRaidTowerInfoCellFinish, tempArgs)
end

function Creature_SceneBottomUI.createHeadwearRaidTowerInfoCellFinish(obj, args)
  local self, creature = args[1], args[2]
  self.asyncCreatingHeadwear = false
  if obj then
    cellData[1] = obj
    cellData[2] = creature
    local sceneUI = creature and creature:GetSceneUI() or nil
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      Game.CreatureUIManager:RemoveCreatureWaitUI(bottomUI.id, SceneBottomHeadwearRaidTowerInfoCell_Class.ResID)
      bottomUI.towerInfoCell = SceneBottomHeadwearRaidTowerInfoCell_Class.CreateAsArray(cellData)
    end
    TableUtility.ArrayClear(cellData)
  end
end

function Creature_SceneBottomUI:UpdateHeadwearRaidTowerInfo(creature)
  if creature and self:isHeadwearRaidTowerInfoVisible(creature) and self.towerInfoCell then
    self.towerInfoCell:UpdateInfo()
  end
end

function Creature_SceneBottomUI:ShowHeadwearRaidTowerInfo(isShow)
  if isShow then
    self.towerInfoCell:Show()
  else
    self.towerInfoCell:Hide()
  end
end

function Creature_SceneBottomUI:UpdateSanity(ncreature, value)
  if self.hpSpCell then
    self.hpSpCell:UpdateSanity(value)
  else
    self:checkCreateHpSp(ncreature)
    self.savedValue = value
    self.tryUpdateSanity = true
  end
end

function Creature_SceneBottomUI:UpdateBullets(value)
  if self.hpSpCell then
    self.hpSpCell:UpdateBulletsNum(value)
  end
end

function Creature_SceneBottomUI:ShowBullets(value)
  if self.hpSpCell then
    self.hpSpCell:ShowBullets(value)
  end
end

function Creature_SceneBottomUI:ClearSanity()
  if self.hpSpCell then
    self.hpSpCell:ClearSanity()
  end
end

function Creature_SceneBottomUI:UpdateFrenzyLayer(layer, maxLayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateFrenzyLayer(layer, maxLayer)
  end
end

function Creature_SceneBottomUI:ShowFrenzy(value)
  if self.hpSpCell then
    self.hpSpCell:ShowFrenzy(value)
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(value)
    end
  end
end

function Creature_SceneBottomUI:InitTimeDiskInfo()
  if self.hpSpCell then
    self.hpSpCell:InitTimeDiskInfo()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true, -34)
    end
  end
end

function Creature_SceneBottomUI:UpdateRotation(isSun, now, curGrid)
  if self.hpSpCell then
    self.hpSpCell:UpdateRotation(isSun, now, curGrid)
  end
end

function Creature_SceneBottomUI:RemoveTimeDisk()
  if self.hpSpCell then
    self.hpSpCell:RemoveTimeDisk()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:InitStarMap()
  if self.hpSpCell then
    self.hpSpCell:InitStarMap()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:UpdateStar(bufflayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateStar(bufflayer)
  end
end

function Creature_SceneBottomUI:RemoveStarMap()
  if self.hpSpCell then
    self.hpSpCell:RemoveStarMap()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:UpdateExecutePart(ncreature)
  if self.hpSpCell then
    self.hpSpCell:UpdateExecutePart()
  end
end

function Creature_SceneBottomUI:InitFeatherGrid()
  if self.hpSpCell then
    self.hpSpCell:InitFeatherGrid()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:UpdateFeatherBuff(bufflayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateFeatherBuff(bufflayer)
  end
end

function Creature_SceneBottomUI:RemoveFeatherGrid()
  if self.hpSpCell then
    self.hpSpCell:RemoveFeatherGrid()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:ShowFeather(value)
  if self.hpSpCell then
    self.hpSpCell:ShowFeather(value)
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(value)
    end
  end
end

function Creature_SceneBottomUI:InitEnergyGrid()
  if self.hpSpCell then
    self.hpSpCell:InitEnergyGrid()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:UpdateEnergyBuff(bufflayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateEnergyBuff(bufflayer)
  end
end

function Creature_SceneBottomUI:RemoveEnergyGrid()
  if self.hpSpCell then
    self.hpSpCell:RemoveEnergyGrid()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:ShowEnergy(value)
  if self.hpSpCell then
    self.hpSpCell:ShowEnergy(value)
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(value)
    end
  end
end

function Creature_SceneBottomUI:SetBalance(creature)
  if self.hpSpCell then
    self.hpSpCell:SetBalance(creature)
  end
end

function Creature_SceneBottomUI:RemoveBalance()
  if self.hpSpCell then
    self.hpSpCell:RemoveBalance()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:SetNormalShield(hp, maxhp)
  if self.hpSpCell then
    self.hpSpCell:SetNormalShield(hp, maxhp)
  end
end

function Creature_SceneBottomUI:ResetRidePos(reset)
  if self.hpSpCell then
    self.hpSpCell:ResetRidePos(reset)
  end
  if self.nameFactionCell then
    self.nameFactionCell:ResetRidePos(reset)
  end
end

function Creature_SceneBottomUI:SetPvpCamp()
  if self.hpSpCell then
    self.hpSpCell:SetPvpCamp()
  end
end

function Creature_SceneBottomUI:InitSolarEnergy()
  if self.hpSpCell then
    self.hpSpCell:InitSolarEnergy()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:UpdateSolarEnergy(bufflayer, maxLayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateSolarEnergy(bufflayer, maxLayer)
  end
end

function Creature_SceneBottomUI:RemoveSolarEnergy()
  if self.hpSpCell then
    self.hpSpCell:RemoveSolarEnergy()
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(true)
    end
  end
end

function Creature_SceneBottomUI:ShowSolarEnergy(value)
  if self.hpSpCell then
    self.hpSpCell:ShowSolarEnergy(value)
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(value)
    end
  end
end

function Creature_SceneBottomUI:SetHideHp(val, creature)
  if self.hpSpCell then
    self:ActiveSpHpCell(not val, creature)
  end
end

function Creature_SceneBottomUI:UpdateBlackMuck(ncreature)
  if self.hpSpCell then
    local userdata = ncreature.data.userdata
    local MaxHp = ncreature.data.props:GetPropByName("MaxHp"):GetValue()
    local blackMuck = userdata:Get(UDEnum.BLACK_MUCK)
    self.hpSpCell:UpdateBlackMuck(blackMuck, MaxHp)
  end
end
