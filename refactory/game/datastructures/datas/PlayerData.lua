autoImport("CampHandler")
PlayerData = reusableClass("PlayerData", CreatureDataWithPropUserdata)
PlayerData.PoolSize = 80
local UDEnum = UDEnum
local _checkPlayerFashionHide = function(i)
  local equipHide = MyselfProxy.Instance:GetOtherPlayerEquipHide()
  return equipHide >> i & 1 == 0
end
local _MaleGender = ProtoCommon_pb.EGENDER_MALE
local _PartIndex = Asset_Role.PartIndex
local _PartCheckIndex = {
  _PartIndex.Body,
  _PartIndex.Head,
  _PartIndex.Face,
  _PartIndex.Mouth,
  _PartIndex.Wing,
  _PartIndex.Tail
}
local _Conf_EquipHideMapRaid = GameConfig.Setting.EquipExteriorMapRaid
local _DefaultMount = 25139

function PlayerData:ctor()
  PlayerData.super.ctor(self)
  self.shape = CommonFun.Shape.M
  self.race = CommonFun.Race.DemiHuman
  self:SetCamp(RoleDefines_Camp.FRIEND)
  self.campHandler = CampHandler.new()
  self.transformData = TransformData.new()
  self.transformData:CacheOrigin(self)
  self.occupations = {}
  self.secretLandLvMap = {}
  self.currentOcc = nil
  self.excludeTeammate = false
end

function PlayerData:GetName()
  if self:IsAnonymous() then
    local classId = self:GetProfesstion()
    return FunctionAnonymous.Me():GetAnonymousName(classId)
  end
  return self.name
end

function PlayerData:GetTeamID()
  return self.teamID
end

function PlayerData:SetCamp(camp)
  PlayerData.super.SetCamp(self, camp)
  if Game.Myself and self.id == Game.LockTargetEffectManager:GetLockedTargetID() then
    Game.LockTargetEffectManager:RefreshEffect()
  end
end

function PlayerData:GetCamp()
  if self.campHandler.dirty then
    self:SetCamp(self.campHandler:GetCamp())
  end
  return self.camp
end

function PlayerData:GetProfesstion()
  return self.userdata:Get(UDEnum.PROFESSION)
end

function PlayerData:GetGender()
  return self.userdata:Get(UDEnum.SEX) or 0
end

function PlayerData:ClearSecretLand()
  TableUtility.TableClear(self.secretLandLvMap)
end

function PlayerData:UpdateSecretLand(itemid, lv)
  self.secretLandLvMap[itemid] = lv
end

function PlayerData:GetSecretLandGemLv(id)
  return self.secretLandLvMap[id] or 0
end

function PlayerData:IsHuman()
  return PlayerData.CheckRace(self:GetProfesstion(), ECHARRACE.ECHARRACE_HUMAN)
end

function PlayerData:IsDoram()
  return PlayerData.CheckRace(self:GetProfesstion(), ECHARRACE.ECHARRACE_CAT)
end

function PlayerData:GetTwelvePVPCamp()
  return self.userdata:Get(UDEnum.TWELVEPVP_CAMP) or 0
end

function PlayerData.CheckRace(profId, race)
  local profData = profId and Table_Class[profId]
  return profData ~= nil and profData.Race == race
end

function PlayerData:CheckIsMyTypeBranch(branch)
  local prof = self:GetProfesstion()
  local profData = prof and Table_Class[prof]
  return profData ~= nil and profData.TypeBranch == branch
end

function PlayerData:Camp_SetIsInMyTeam(val)
  self.campHandler:SetIsSameTeam(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

function PlayerData:Camp_SetIsInPVP(val)
  self.campHandler:SetIsInPvpScene(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

function PlayerData:Camp_SetIsInMyGuild(val)
  self.campHandler:SetIsSameGuild(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

function PlayerData:Camp_SetIsInGVG(val)
  self.campHandler:SetIsInGVGScene(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

function PlayerData:Camp_SetIsOtherTransformedAtk(val)
  self.campHandler:SetIsOtherTransformedAtk(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

function PlayerData:Camp_SetIsSelfTransformedAtk(val)
  self.campHandler:SetIsSelfTransformedAtk(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

function PlayerData:Camp_SetInSameCamp(val)
  self.campHandler:SetInSameCamp(val)
  if self.campHandler.dirty then
    self.campChanged = self.campHandler.dirty
  end
end

local tempArray = {}

function PlayerData:getOccupationByType(type)
  TableUtility.ArrayClear(tempArray)
  if self.occupations then
    for i = 1, #self.occupations do
      local single = self.occupations[i]
      if single.professionData.Type == type then
        table.insert(tempArray, single)
      end
    end
  end
  return tempArray
end

function PlayerData:UpdateJobDatas(data)
  local occupation, ocData
  self.occupations = {}
  for i = 1, #data do
    ocData = data[i].datas
    local jobLv = 1
    local profession = 1
    local jobExp = 1
    for i = 1, #ocData do
      if ocData[i].type == ProtoCommon_pb.EUSERDATATYPE_PROFESSION then
        profession = ocData[i].value
      elseif ocData[i].type == ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL then
        jobLv = ocData[i].value
      elseif ocData[i].type == ProtoCommon_pb.EUSERDATATYPE_JOBEXP then
        jobExp = ocData[i].value
      end
    end
    TableUtility.ArrayClear(tempArray)
    tempArray[1] = jobLv
    tempArray[2] = jobExp
    tempArray[3] = profession
    occupation = Occupation.CreateAsTable(tempArray)
    self.occupations[#self.occupations + 1] = occupation
    if occupation.isCurrent then
      self.currentOcc = occupation
    end
  end
end

function PlayerData:UpdateProfession()
  local jobLv = self.userdata:Get(UDEnum.JOBLEVEL)
  local jobExp = self.userdata:Get(UDEnum.JOBEXP)
  local profession = self.userdata:Get(UDEnum.PROFESSION)
  local occupation
  if self.occupations then
    for i = 1, #self.occupations do
      local single = self.occupations[i]
      if single.profession == profession then
        occupation = single
      end
    end
  end
  if not occupation then
    TableUtility.ArrayClear(tempArray)
    tempArray[1] = jobLv
    tempArray[2] = jobExp
    tempArray[3] = profession
    occupation = Occupation.CreateAsTable(tempArray)
    table.insert(self.occupations, occupation)
  end
  self.currentOcc = occupation
end

function PlayerData:GetCurOcc()
  if not self.currentOcc then
    self:UpdateProfession()
  end
  return self.currentOcc
end

function PlayerData:SetBlink(b)
  self.blink = b
end

function PlayerData:CanBlink()
  return self.blink == true
end

function PlayerData:InitChatRoomData(chatRoomInfo)
  if chatRoomInfo ~= nil and chatRoomInfo.roomid > 0 and chatRoomInfo.ownerid == self.id then
    if self.chatRoomData == nil then
      self.chatRoomData = ChatZoneSummaryData.CreateAsTable(chatRoomInfo)
    else
      self.chatRoomData:Update(chatRoomInfo)
    end
  end
end

function PlayerData:UpdateBoothData(boothInfo)
  if boothInfo ~= nil then
    if self.boothData == nil then
      self.boothData = BoothData.CreateAsTable(boothInfo)
    else
      self.boothData:SetData(boothInfo)
    end
  end
end

function PlayerData:ClearBoothData()
  if self.boothData ~= nil then
    self.boothData:Destroy()
    self.boothData = nil
  end
end

function PlayerData:SetTeamID(teamID)
  self.teamID = teamID
end

function PlayerData:SetAchievementtitle(achievetitle)
  self.achievetitle = achievetitle
end

function PlayerData:GetAchievementtitle()
  return self.achievetitle
end

function PlayerData:GetEquipedWeaponType()
  if self.userdata ~= nil then
    local equipedWeaponId = self.userdata:Get(UDEnum.EQUIPED_WEAPON)
    local staticData = Table_Item[equipedWeaponId]
    if staticData ~= nil and staticData.Type ~= nil then
      return staticData.Type
    end
  end
  return PlayerData.super:GetEquipedWeaponType(self)
end

function PlayerData:GetMasterUser()
  return self
end

function PlayerData:RefreshNightmareStatus()
  if not Game.Myself or self.id == Game.Myself.data.id or not Game.Myself:IsAtNightmareMap() then
    return
  end
  local headCfg = GameConfig.Nightmare and GameConfig.Nightmare.PlayerHeadID
  if not headCfg then
    redlog("No Nightmare Config!")
    return
  end
  if math.random(0, 100) <= Game.Myself:GetNightmarePlayerHeadChangePercent() then
    self:SetClientForceDressPart(_PartIndex.Head, headCfg[math.random(#headCfg)])
  elseif self:GetClientForceDressPart(_PartIndex.Head) ~= 0 then
    self:SetClientForceDressPart(_PartIndex.Head, nil)
  end
end

function PlayerData:GetDressParts()
  local parts = PlayerData.super.GetDressParts(self)
  local class = self:GetProfesstion()
  local classStatic = class and Table_Class[class]
  if nil == classStatic then
    return parts
  end
  local defaultBody = _MaleGender == self:GetGender() and classStatic.MaleBody or classStatic.FemaleBody
  parts[Asset_Role.PartIndexEx.DefaultBody] = defaultBody
  parts[Asset_Role.PartIndexEx.DefaultHair] = parts[_PartIndex.Hair]
  parts[Asset_Role.PartIndexEx.DefaultEye] = _MaleGender == self:GetGender() and classStatic.MaleEye or classStatic.FemaleEye
  parts[Asset_Role.PartIndexEx.DefaultMount] = _DefaultMount
  local equipHide = MyselfProxy.Instance:GetOtherPlayerEquipHide()
  if 0 == equipHide then
    return parts
  end
  if not _Conf_EquipHideMapRaid or not Game.MapManager:IsMapRaidTypeForbid(_Conf_EquipHideMapRaid) then
    return parts
  end
  local transformPart = self:GetTransformPart()
  for i = 1, #_PartCheckIndex do
    if not transformPart[_PartCheckIndex[i]] and not _checkPlayerFashionHide(i - 1) then
      if _PartCheckIndex[i] == _PartIndex.Body then
        parts[_PartIndex.Body] = defaultBody
      else
        parts[_PartCheckIndex[i]] = 0
      end
    end
  end
  return parts
end

function PlayerData:IsAnonymous()
  return self.userdata:Get(UDEnum.ANONYMOUS) and self.userdata:Get(UDEnum.ANONYMOUS) ~= 0
end

function PlayerData:DoConstruct(asArray, serverData)
  PlayerData.super.DoConstruct(self, asArray, serverData)
  self.id = serverData.guid
  self.name = serverData.name
  self.shape = CommonFun.Shape.M
  self.race = CommonFun.Race.DemiHuman
  if not serverData.teamid or serverData.teamid == 0 then
    self.teamID = self.id
  else
    self.teamID = serverData.teamid
  end
  self.blink = false
  self.achievetitle = serverData.achievetitle
  TableUtility.ArrayClear(tempArray)
  tempArray[1] = serverData.guildid
  tempArray[2] = serverData.guildname
  tempArray[3] = serverData.guildicon
  tempArray[4] = serverData.guildjob
  self:SetGuildData(tempArray)
  TableUtility.ArrayClear(tempArray)
  local mercenaryGuildData = serverData.mercenary
  if mercenaryGuildData then
    tempArray[1] = mercenaryGuildData.id
    tempArray[2] = mercenaryGuildData.name
    tempArray[3] = mercenaryGuildData.icon
    tempArray[4] = mercenaryGuildData.job
    tempArray[5] = mercenaryGuildData.mercenary_name
  end
  self:SetMercenaryGuildData(tempArray)
  self:SpawnCullingID()
  self.accid = serverData.accid
  self:RefreshNightmareStatus()
end

function PlayerData:DoDeconstruct(asArray)
  self.campHandler:Reset()
  if self.chatRoomData ~= nil then
    self.chatRoomData:Destroy()
    self.chatRoomData = nil
  end
  self:ClearBoothData()
  PlayerData.super.DoDeconstruct(self, asArray)
  self.excludeTeammate = false
end

function PlayerData:GetFeature_IgnoreEffectCulling()
  return false
end

function PlayerData:GetTransformPart()
  local trans_Part = {}
  local buffIDs = self:GetBuffListByType("PartTransform")
  if not buffIDs then
    return trans_Part
  end
  local config = Table_Buffer
  for i = 1, #buffIDs do
    local buffEffect = config[buffIDs[i]] and config[buffIDs[i]].BuffEffect
    if buffEffect then
      if buffEffect.Body then
        trans_Part[_PartIndex.Body] = 1
      elseif buffEffect.Head then
        trans_Part[_PartIndex.Head] = 1
      elseif buffEffect.Mouth then
        trans_Part[_PartIndex.Mouth] = 1
      elseif buffEffect.Face then
        trans_Part[_PartIndex.Face] = 1
      elseif buffEffect.Back then
        trans_Part[_PartIndex.Wing] = 1
      elseif buffEffect.Tail then
        trans_Part[_PartIndex.Tail] = 1
      end
    end
  end
  return trans_Part
end

function PlayerData:GetSkillOptByOption(opt)
  if not self._SkillOptionManager then
    self._SkillOptionManager = Game.SkillOptionManager
  end
  return self._SkillOptionManager:GetSkillOption(opt)
end

function PlayerData:IsPlayer()
  return true
end

function PlayerData:GetNoEnemyLocked()
  return self.noEnemyLocked
end

function PlayerData:isCostBattleCount()
  return false
end

function PlayerData:IsTransformState()
  if nil ~= self:GetBuffListByType("Transform") or nil ~= self:GetBuffListByType("PartTransform") then
    return true
  end
  if self:IsTransformed() then
    return true
  end
  if self:IsInMagicMachine() then
    return true
  end
  if self:IsOnWolf() then
    return true
  end
  return false
end
