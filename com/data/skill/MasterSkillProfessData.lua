autoImport("SkillProfessData")
MasterSkillProfessData = class("MasterSkillProfessData", SkillProfessData)

function MasterSkillProfessData:ctor(profession, points, isMaster)
  MasterSkillProfessData.super.ctor(self, profession, points)
  self.isMaster = isMaster
  for i = #Table_JobLevel, 1, -1 do
    local config = Table_JobLevel[i]
    if config.MasterLv and config.MasterLv > 0 then
      self.totalPoints = config.ShowLevel
      break
    end
  end
  self.unlockLimitSkillIndex = {}
  self.skillGroupIndexMap = {}
  self.limitGroupIndexToGroupIndex = {}
end

function MasterSkillProfessData:AddMasterSkill(skillId, learned, groupIndex)
  local familyId = skillId // 1000
  local skill = self:FindSkillByFamilyId(familyId)
  if not skill then
    skill = SkillItemData.new(skillId, 0, 0, self.profession, 0)
    local index = #self.skills + 1
    self.skills[index] = skill
    if groupIndex then
      if not self.skillGroupIndexMap[groupIndex] then
        self.skillGroupIndexMap[groupIndex] = {}
      end
      TableUtility.ArrayPushBack(self.skillGroupIndexMap[groupIndex], familyId)
    end
  else
    skill:Reset(skillId)
  end
  skill:SetLearned(learned or false)
  return skill
end

function MasterSkillProfessData:AddExtraMasterSkill(skillId, learned, limitGroupIndex)
  local groupIndex = self.limitGroupIndexToGroupIndex[limitGroupIndex]
  if not groupIndex then
    groupIndex = #self.skillGroupIndexMap + 1
    self.limitGroupIndexToGroupIndex[limitGroupIndex] = groupIndex
  end
  return self:AddMasterSkill(skillId, learned, groupIndex)
end

function MasterSkillProfessData:RemoveMasterSkill(id, source)
  return self:RemoveSkillByIdAndSource(id, source)
end

function MasterSkillProfessData:LimitGroupIndexToGroupIndex(limitGroupIndex)
  return self.limitGroupIndexToGroupIndex[limitGroupIndex]
end

function MasterSkillProfessData:SetBlockMasterSkill(blockMasterSkillIndex, blockLimitMasterSkillIndex)
  if blockMasterSkillIndex then
    for i = 1, #blockMasterSkillIndex do
      local groupIndex = blockMasterSkillIndex[i]
      local familyIds = self:GetSkillGroupFamilyIdsByGroupIndex(groupIndex)
      if familyIds then
        for i = #self.skills, 1, -1 do
          local skill = self.skills[i]
          if TableUtility.ArrayFindIndex(familyIds, skill.sortID) > 0 then
            table.remove(self.skills, i)
          end
        end
        self.skillGroupIndexMap[groupIndex] = nil
      end
    end
  end
  if blockLimitMasterSkillIndex then
    for i = 1, #blockLimitMasterSkillIndex do
      local limitGroupIndex = blockLimitMasterSkillIndex[i]
      local groupIndex = self:LimitGroupIndexToGroupIndex(limitGroupIndex)
      local familyIds = groupIndex and self:GetSkillGroupFamilyIdsByGroupIndex(groupIndex)
      if familyIds then
        for i = #self.skills, 1, -1 do
          local skill = self.skills[i]
          if TableUtility.ArrayFindIndex(familyIds, skill.sortID) > 0 then
            table.remove(self.skills, i)
          end
        end
        self.skillGroupIndexMap[groupIndex] = nil
        self.limitGroupIndexToGroupIndex[limitGroupIndex] = nil
      end
    end
  end
end

function MasterSkillProfessData:UpdateMasterSkill(serverSkill)
  local skillId = serverSkill.id
  local skill = self:FindSkillById(skillId)
  if skill then
    skill:SetReplaceID(serverSkill.replaceid)
  end
end

function MasterSkillProfessData:GetRemainPoint()
  local totalMasterPoint = MyselfProxy.Instance:GetMasterJobLevel()
  local remainPoint = totalMasterPoint - self.points
  return remainPoint
end

function MasterSkillProfessData:HasRemainPoint()
  return self:GetRemainPoint() > 0
end

function MasterSkillProfessData:UpdateMasterSkillPoints(equipMasterSkillFamilyId)
  local points = 0
  local groupIndex = self:GetEquipMasterSkillGroupIndex(equipMasterSkillFamilyId)
  local ids = self.skillGroupIndexMap[groupIndex]
  if ids then
    for i = 1, #ids do
      local id = ids[i]
      local skill = self:FindSkillByFamilyId(id)
      points = points + (skill.learned and skill.level or 0)
    end
  end
  self:UpdatePoints(points)
end

function MasterSkillProfessData:UpdateSkillActive()
  for i = 1, #self.skills do
    local skill = self.skills[i]
    if skill.requiredSkillID then
      local requiredSortID = math.floor(skill.requiredSkillID / 1000)
      local requiredSkill = self:FindSkillByFamilyId(requiredSortID)
      if requiredSkill and requiredSkill.learned and skill.learned then
        skill:SetActive(true)
      else
        skill:SetActive(false)
      end
    else
      skill:SetActive(true)
    end
  end
end

function MasterSkillProfessData:SetUnlockLimitSkillIndex(unlockSkillIndex)
  if unlockSkillIndex and 0 < #unlockSkillIndex then
    TableUtility.ArrayClear(self.unlockLimitSkillIndex)
    for i = 1, #unlockSkillIndex do
      self.unlockLimitSkillIndex[i] = unlockSkillIndex[i]
    end
  end
end

function MasterSkillProfessData:GetUnlockLimitSkillIndex()
  return self.unlockLimitSkillIndex
end

function MasterSkillProfessData:GetEquipMasterSkillGroupIndex(equipMasterSkillFamilyId)
  equipMasterSkillFamilyId = equipMasterSkillFamilyId or SkillProxy.Instance:GetEquipMasterSkillFamilyId()
  if not equipMasterSkillFamilyId then
    return
  end
  for groupIndex, ids in ipairs(self.skillGroupIndexMap) do
    if ids[1] == equipMasterSkillFamilyId then
      return groupIndex
    end
  end
end

function MasterSkillProfessData:GetSkillGroupFamilyIdsByGroupIndex(groupIndex)
  return self.skillGroupIndexMap[groupIndex]
end

function MasterSkillProfessData:GetEquipMasterSkillGroupIds(equipMasterSkillFamilyId)
  local groupIndex = self:GetEquipMasterSkillGroupIndex(equipMasterSkillFamilyId)
  if groupIndex then
    return self:GetSkillGroupFamilyIdsByGroupIndex(groupIndex)
  end
end

function MasterSkillProfessData:GetSkillGroupNum()
  return #self.skillGroupIndexMap
end

function MasterSkillProfessData:GetSkillGroupIndexByFamilyId(familyId)
  for groupIndex, ids in ipairs(self.skillGroupIndexMap) do
    if TableUtility.ArrayFindIndex(ids, familyId) > 0 then
      return groupIndex
    end
  end
end

function MasterSkillProfessData:FindSkillByFamilyId(familyId)
  for i = 1, #self.skills do
    local skill = self.skills[i]
    if skill.sortID == familyId then
      return skill
    end
  end
end

function MasterSkillProfessData:FindSkillById(id)
  for i = 1, #self.skills do
    local skill = self.skills[i]
    if skill.id == id then
      return skill, i
    end
  end
end
