autoImport("InheritSkillItemData")
InheritSkillProfessData = class("InheritSkillProfessData")

function InheritSkillProfessData:ctor(profession)
  self.profession = profession
  self.skills = {}
end

function InheritSkillProfessData:AddSkill(skillItemData)
  self.skills[#self.skills + 1] = skillItemData
end

function InheritSkillProfessData:RemoveSkill(skillItemData)
  TableUtility.ArrayRemove(self.skills, skillItemData)
end

function InheritSkillProfessData:FindSkill(familyId)
  return TableUtility.ArrayFindByPredicate(self.skills, function(v, args)
    return v.sortID == args
  end, familyId)
end

local sortFunc = function(l, r)
  if l.isInherited == r.isInherited then
    if l.isInherited then
      if l.inheritStaticData.Quality == r.inheritStaticData.Quality then
        return l.id < r.id
      end
      return l.inheritStaticData.Quality > r.inheritStaticData.Quality
    end
    if l.isUnlock == r.isUnlock then
      if not l.isUnlock then
        local lpro = InheritSkillProxy.GetSkillProfess(l.sortID)
        local rpro = InheritSkillProxy.GetSkillProfess(r.sortID)
        if lpro ~= rpro then
          return lpro < rpro
        end
      end
      if l.inheritStaticData.Quality == r.inheritStaticData.Quality then
        return l.id < r.id
      end
      return l.inheritStaticData.Quality > r.inheritStaticData.Quality
    end
    return l.isUnlock
  end
  return l.isInherited
end

function InheritSkillProfessData:GetSkills()
  table.sort(self.skills, sortFunc)
  return self.skills
end

function InheritSkillProfessData:IsEmpty()
  return #self.skills == 0
end
