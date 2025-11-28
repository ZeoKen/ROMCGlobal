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
    local professes = self.inheritStaticData.ProfessionDepend
    if professes then
      if 1 < #professes then
        self.unlockProfess = professes[1]
      else
        local sex = MyselfProxy.Instance:GetMySex()
        self.unlockProfess = TableUtility.ArrayFindByPredicate(professes, function(v, args)
          local classConfig = Table_Class[v]
          if classConfig then
            local gender = classConfig.gender
            return not gender or gender == 0 or gender == sex
          end
          return false
        end, sex)
      end
    end
  end
  self.isUnlock = false
  self.isInherited = false
  self.isLoad = false
end

function InheritSkillItemData:UpdateSkill(serverSkill)
  if serverSkill.id % 1000 > 0 then
    self:Reset(serverSkill.id)
    if not self.isInherited then
      self:SetInherit(true)
    end
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
