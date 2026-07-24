autoImport("SkillItemData")
InheritSkillItemData = class("InheritSkillItemData", SkillItemData)

function InheritSkillItemData:ctor(familyId)
  local id = familyId * 1000 + 1
  InheritSkillItemData.super.ctor(self, id)
  self.id = id - 1
  self.level = 0
  self.inheritStaticData = Table_SkillInherit[familyId]
  if self.inheritStaticData then
    local quality = self.inheritStaticData.Quality
    local config = GameConfig.SkillInherit and GameConfig.SkillInherit.Quality
    if config and config[quality] then
      self.costPoint = config[quality].Point
      self.maxLvCostPoint = config[quality].MaxLvPoint
    end
  end
  self.isUnlock = true
  self.isInherited = false
  self.isLoad = false
end

function InheritSkillItemData:UpdateSkill(serverSkill)
  if serverSkill.id % 1000 > 0 then
    self:Reset(serverSkill.id)
    if not self.isInherited then
      self:SetInherit(true)
    end
  else
    local familyId = serverSkill.id // 1000
    self:Reset(familyId * 1000 + 1)
    self.id = serverSkill.id
    self.level = 0
    self:SetInherit(false)
  end
  self:UpdateShortcuts(serverSkill.shortcuts)
  self:SetLoad(serverSkill.load)
  self:SetLearned(serverSkill.load)
  self:SetReplaceID(serverSkill.replaceid)
  if not self.isUnlock then
    self:SetUnlock(true)
  end
end

function InheritSkillItemData:SetUnlock(unlock)
  self.isUnlock = unlock
end

function InheritSkillItemData:SetInherit(inherit)
  self.isInherited = inherit
end

function InheritSkillItemData:SetLoad(isLoad)
  self.isLoad = isLoad
end

function InheritSkillItemData:IsMaxLevel()
  return self.level > 0 and self.level == self.maxLevel
end

function InheritSkillItemData:GetCostPoint()
  local maxLevel = GameConfig.SkillInherit and GameConfig.SkillInherit.MaxLv or self.maxLevel
  return maxLevel <= self.level and self.maxLvCostPoint or self.costPoint
end

function InheritSkillItemData:IsProfessionForbid(pro)
  pro = pro or SkillProxy.Instance:GetMyProfession()
  if self.inheritStaticData then
    local branchForbid = self.inheritStaticData.BranchForbid
    if branchForbid then
      local classConfig = Table_Class[pro]
      local myBranch = classConfig and classConfig.TypeBranch
      return TableUtility.ArrayFindIndex(branchForbid, myBranch) > 0
    end
  end
  return false
end

function InheritSkillItemData:GetUpgradeMaterialConfig()
  local materials = self.inheritStaticData and self.inheritStaticData.Materials
  if not materials then
    return
  end
  local quality = self.inheritStaticData and self.inheritStaticData.Quality
  local matNum = 0
  if GameConfig.SkillInherit and GameConfig.SkillInherit.Quality then
    local qualityConf = GameConfig.SkillInherit.Quality[quality]
    if qualityConf then
      matNum = qualityConf.LvUpCost[self.level + 1] or 0
      local specificLevel = qualityConf.SpecificLevel
      if specificLevel and 0 < TableUtility.ArrayFindIndex(specificLevel, self.level + 1) and qualityConf.SpecificLevelCostMaterials then
        materials = qualityConf.SpecificLevelCostMaterials
      end
    end
  end
  return materials, matNum
end

function InheritSkillItemData:GetUpgradeMaterialState()
  local materials, matNum = self:GetUpgradeMaterialConfig()
  if materials then
    local totalNum = 0
    local checkPackage = GameConfig.PackageMaterialCheck.skill_inherit
    for i = 1, #materials do
      local itemId = materials[i]
      local num = BagProxy.Instance:GetItemNumByStaticID(itemId, checkPackage)
      totalNum = totalNum + num
    end
    return materials, matNum, totalNum, matNum > totalNum
  end
  return nil, 0, 0, false
end

function InheritSkillItemData:GetResetReturnMaterials()
  local datas = {}
  if not self.inheritStaticData or self.level <= 0 then
    return datas
  end
  local quality = self.inheritStaticData.Quality
  local qualityConf = GameConfig.SkillInherit and GameConfig.SkillInherit.Quality and GameConfig.SkillInherit.Quality[quality]
  local lvUpCost = qualityConf and qualityConf.LvUpCost
  if not lvUpCost then
    return datas
  end
  local itemIds = {}
  local itemNums = {}
  local AddReturnItem = function(itemId, num)
    if itemId and num and 0 < num then
      if not itemNums[itemId] then
        itemIds[#itemIds + 1] = itemId
        itemNums[itemId] = num
      else
        itemNums[itemId] = itemNums[itemId] + num
      end
    end
  end
  for level = 1, self.level do
    local itemId = self.inheritStaticData.RefundMaterial
    if qualityConf.SpecificLevel and TableUtility.ArrayFindIndex(qualityConf.SpecificLevel, level) > 0 and qualityConf.SpecificLevelRefundMaterial then
      itemId = qualityConf.SpecificLevelRefundMaterial
    end
    AddReturnItem(itemId, lvUpCost[level])
  end
  for i = 1, #itemIds do
    local itemId = itemIds[i]
    local itemData = ItemData.new("InheritSkillResetReturn", itemId)
    itemData.num = itemNums[itemId]
    datas[#datas + 1] = itemData
  end
  return datas
end

function InheritSkillItemData:IsMaterialLack()
  local _, _, _, isLack = self:GetUpgradeMaterialState()
  return isLack
end
