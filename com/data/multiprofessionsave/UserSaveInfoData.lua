autoImport("AstrolabeSaveData")
autoImport("EquipsSaveData")
autoImport("RoleAttrSaveData")
autoImport("SkillSaveData")
autoImport("Occupation")
autoImport("ExtractSaveData")
autoImport("EquipMemoryData")
UserSaveInfoData = class("UserSaveInfoData")
local StringData = {
  [SceneSkill_pb.ESKILLOPTION_SELECT_MOUNT] = 1
}

function UserSaveInfoData:ctor(data)
  self.id = data.id
  self.profession = data.profession
  self.jobLv = data.joblv
  self.jobexp = data.jobexp
  self.recordname = data.recordname
  self.recordtime = data.recordtime
  self.roleid = data.charid
  self.rolename = data.charname
  self.attrs = RoleAttrSaveData.new(data.attr_data)
  self.equips_map = {}
  if data.equip_data then
    local n = #data.equip_data
    for i = 1, n do
      local single = EquipsSaveData.new(data.equip_data[i], self.id)
      self.equips_map[single.pacakgeType] = single
    end
  end
  self.astrolabes = AstrolabeSaveData.new(data.astrolabe_data)
  self.skills = SkillSaveData.new(data.skill_data, data.profession, data.joblv)
  self.gemDatas = {}
  local serverGems = data.gem_data
  local serverGem, itemData
  for i = 1, #serverGems do
    serverGem = serverGems[i]
    itemData = ItemData.new()
    itemData:ParseFromServerData(serverGem)
    self.gemDatas[#self.gemDatas + 1] = itemData
  end
  self.heroFeatureLv = self:SetHeroFeatureLv()
  local multiskillopts = data.multiskillopts
  if multiskillopts then
    for i = 1, #multiskillopts do
      self:UpdateMultiSkillOption(multiskillopts[i])
    end
  end
  self.extracts = ExtractSaveData.new(data.extraction_data)
  self.memoryDatas = {}
  local serverMemorys = data.memory_pos or {}
  if serverMemorys and 0 < #serverMemorys then
    xdlog("有装备记忆数据", #serverMemorys)
  end
  for i = 1, #serverMemorys do
    local singleMemory = serverMemorys[i]
    local _equipPos = singleMemory.pos
    local itemid = singleMemory.memory.itemid
    if itemid and itemid ~= 0 then
      local memoryData = EquipMemoryData.new(_equipPos)
      memoryData:SetMyServerData(singleMemory.memory)
      self.memoryDatas[_equipPos] = memoryData
    end
  end
end

function UserSaveInfoData:UpdateRecordTime(newTime)
  self.recordtime = newTime
end

function UserSaveInfoData:UpdateName(newName)
  self.recordname = newName
end

function UserSaveInfoData:GetUserData()
  return self.attrs:GetUserData()
end

function UserSaveInfoData:GetProfession()
  return self.profession
end

function UserSaveInfoData:GetJobLevel()
  return self.jobLv
end

function UserSaveInfoData:SetHeroFeatureLv()
  local heroFeatureLv = 1
  for i = 1, #self.gemDatas do
    if self.gemDatas[i].gemSkillData then
      heroFeatureLv = heroFeatureLv + self.gemDatas[i].gemSkillData:GetAddedHeroLvBuff()
    end
  end
  return heroFeatureLv
end

function UserSaveInfoData:GetHeroFeatureLv()
  return self.heroFeatureLv
end

function UserSaveInfoData:GetFixedJobLevel()
  return Occupation.GetFixedJobLevel(self.jobLv, self.profession)
end

function UserSaveInfoData:GetUnusedSkillPoint()
  return self.skills:GetUnusedSkillPoint()
end

function UserSaveInfoData:GetProfessionSkill()
  return self.skills:GetProfessionSkill()
end

function UserSaveInfoData:GetBeingSkill()
  return self.skills:GetBeingSkill()
end

function UserSaveInfoData:GetEquipedSkills()
  return self.skills:GetEquipedSkills()
end

function UserSaveInfoData:GetEquipedAutoSkills()
  return self.skills:GetEquipedAutoSkills()
end

function UserSaveInfoData:GetSkillData()
  return self.skills
end

function UserSaveInfoData:GetBeingInfo(beingid)
  return self.skills:GetBeingInfo(beingid)
end

function UserSaveInfoData:GetBeingsArray()
  return self.skills:GetBeingsArray()
end

function UserSaveInfoData:GetUsedPoints()
  return self.skills:GetUsedPoints()
end

function UserSaveInfoData:GetLearnItemCost()
  return self.skills:GetLearnItemCost()
end

function UserSaveInfoData:GetAstroble()
  return self.astrolabes
end

function UserSaveInfoData:GetActiveStars(id)
  return self.astrolabes:GetActiveStars()
end

function UserSaveInfoData:GetRoleEquipsSaveDatas(bagtype)
  local roleEquip = self.equips_map[bagtype]
  if roleEquip == nil then
    return
  end
  return roleEquip:GetEquipInfos()
end

function UserSaveInfoData:GetPersonalArtifactId()
  local result, id
  local equipSaveData = self.equips_map[BagProxy.BagType.RoleEquip]
  if equipSaveData then
    result, id = equipSaveData:TryGetPersonalArtifact()
  end
  if nil == result then
    equipSaveData = self.equips_map[BagProxy.BagType.PersonalArtifact]
    if equipSaveData then
      result, id = equipSaveData:TryGetPersonalArtifact()
    end
  end
  return result, id
end

function UserSaveInfoData:GetEquipMemorySaveDatas()
  return self.memoryDatas
end

function UserSaveInfoData:GetRoleName()
  return self.rolename or ""
end

function UserSaveInfoData:GetProps()
  return self.attrs:GetUserAttr()
end

function UserSaveInfoData:GetContribute()
  return self:GetAstrolabeStorageCostByItemId(AstrolabeProxy.ContributeItemId)
end

function UserSaveInfoData:GetGoldMedal()
  return self:GetAstrolabeStorageCostByItemId(AstrolabeProxy.GoldMedalItemId)
end

function UserSaveInfoData:GetAstrolabeStorageCostByItemId(itemId)
  local cost = AstrolabeProxy.Instance:GetStorageActivePointsCost(self.id)
  return cost[itemId]
end

function UserSaveInfoData:GetGemData()
  return self.gemDatas
end

function UserSaveInfoData:GetSkillOpts(opts, subSkillid)
  return self.multiskillopts and self.multiskillopts[opts] and self.multiskillopts[opts][subSkillid]
end

function UserSaveInfoData:UpdateMultiSkillOption(skillOption)
  if not self.multiskillopts then
    self.multiskillopts = {}
  else
    TableUtility.TableClear(self.multiskillopts)
  end
  if not self._invalidSkills then
    self._invalidSkills = {}
  else
    TableUtility.TableClear(self._invalidSkills)
  end
  local skillMap = self.multiskillopts[skillOption.opt]
  if skillMap == nil then
    skillMap = {}
    self.multiskillopts[skillOption.opt] = skillMap
  end
  local subSkillList = skillMap[skillOption.value]
  if subSkillList == nil then
    subSkillList = {}
    skillMap[skillOption.value] = subSkillList
  else
    for i = #subSkillList, 1, -1 do
      subSkillList[i] = nil
    end
  end
  local value
  for i = 1, #skillOption.values do
    value = skillOption.values[i]
    subSkillList[#subSkillList + 1] = value
  end
  if StringData[skillOption.opt] and skillOption.guid ~= "" then
    TableUtility.ArrayClear(subSkillList)
    subSkillList[#subSkillList + 1] = skillOption.guid
  end
  local invalidMap = self._invalidSkills[skillOption.opt]
  if not invalidMap then
    invalidMap = {}
    self._invalidSkills[skillOption.opt] = invalidMap
  end
  local subSkillInvalidList = invalidMap[skillOption.value]
  if subSkillInvalidList == nil then
    subSkillInvalidList = {}
    invalidMap[skillOption.value] = subSkillInvalidList
  else
    for i = #subSkillInvalidList, 1, -1 do
      subSkillInvalidList[i] = nil
    end
  end
  for i = 1, #skillOption.subvalues do
    value = skillOption.subvalues[i]
    subSkillInvalidList[#subSkillInvalidList + 1] = value
  end
end

function UserSaveInfoData:GetMultiSkillOption(optionType, skillid)
  local skillMap = self.multiskillopts[optionType]
  if skillMap == nil then
    return nil
  end
  return skillMap[skillid]
end

function UserSaveInfoData:IsInSkillOption(optionType, skillid, subSkillid)
  local skillList = self:GetMultiSkillOption(optionType, skillid)
  if skillList ~= nil then
    for i = 1, #skillList do
      if skillList[i] == subSkillid then
        return true
      end
    end
  end
  return false
end

function UserSaveInfoData:GetSkillOpts(opts, subSkillid)
  return self.multiskillopts and self.multiskillopts[opts] and self.multiskillopts[opts][subSkillid]
end

function UserSaveInfoData:GetMultiSkillInvalidOption(optionType, skillid)
  return self._invalidSkills and self._invalidSkills[optionType] and self._invalidSkills[optionType][skillid]
end

function UserSaveInfoData:GetExtractData()
  return self.extracts
end

function UserSaveInfoData:GetMasterSkillProfessData()
  return self.skills:GetMasterSkillProfessData()
end

function UserSaveInfoData:GetEquipMasterSkillFamilyId()
  return self.skills:GetEquipMasterSkillFamilyId()
end
