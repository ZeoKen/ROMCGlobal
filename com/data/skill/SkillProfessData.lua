SkillProfessData = class("SkillProfessData")

function SkillProfessData:ctor(profession, points)
  self.skills = {}
  self.profession = profession
  self.basePoints = 0
  self:UpdatePoints(points)
end

function SkillProfessData:UpdatePoints(points)
  self.points = points
end

function SkillProfessData:UpdateBasePoints(points)
  self.basePoints = points
end

function SkillProfessData:UpdateSkill(serverSkillItem)
  local skill = self:FindSkillByIdAndSource(serverSkillItem.id, serverSkillItem.sourceid)
  if skill then
    skill:Reset(serverSkillItem.id, serverSkillItem.pos, serverSkillItem.autopos, serverSkillItem.cd, serverSkillItem.sourceid, serverSkillItem.extendpos, serverSkillItem.shortcuts, serverSkillItem.extramaxlv)
    self:UpdateSingleSkill(skill, serverSkillItem)
  else
    skill = self:AddSkill(serverSkillItem)
  end
  return skill
end

function SkillProfessData:UpdateSingleSkill(skillItemData, serverSkillItem)
  if skillItemData then
    AstrolabeProxy.Instance:SkillSetSpecialEnable(skillItemData:GetSpecialID(), nil)
    skillItemData:SetActive(serverSkillItem.active)
    skillItemData:SetLearned(serverSkillItem.learn)
    skillItemData:SetSource(serverSkillItem.source)
    skillItemData:SetShadow(serverSkillItem.shadow)
    skillItemData:SetSpecialID(serverSkillItem.runespecid)
    skillItemData:SetReplaceID(serverSkillItem.replaceid)
    SkillProxy:SetReplaceMap(serverSkillItem.id, serverSkillItem.replaceid)
    skillItemData:SetOriginalReplaceID(serverSkillItem.replaceid)
    skillItemData:SetEnableSpecialEffect(serverSkillItem.selectswitch)
    skillItemData:SetExtraLevel(serverSkillItem.extralv)
    skillItemData:SetOwnerId(serverSkillItem.ownerid)
    skillItemData:SetExpireTime(serverSkillItem.expiretime)
    skillItemData:SetUsedCount(serverSkillItem.usedcount)
    skillItemData:SetAllCount(serverSkillItem.allcount)
    AstrolabeProxy.Instance:SkillSetSpecialEnable(serverSkillItem.runespecid, serverSkillItem.selectswitch)
    local consume = serverSkillItem.consume
    if consume then
      skillItemData:ResetUseTimes(consume.curvalue, consume.maxvalue, consume.nexttime)
    end
  end
end

function SkillProfessData:AutoFillAdd(id, sourceid)
  sourceid = sourceid or 0
  local skill = self:FindSkillByIdAndSource(id, sourceid)
  if skill == nil then
    local skillItemData = SkillItemData.new(id, 0, 0, self.profession, sourceid)
    self.skills[#self.skills + 1] = skillItemData
  end
end

function SkillProfessData:AddSkill(serverSkillItem)
  local skillItemData = SkillItemData.new(serverSkillItem.id, serverSkillItem.pos, serverSkillItem.autopos, self.profession, serverSkillItem.sourceid, serverSkillItem.extendpos, serverSkillItem.shortcuts, serverSkillItem.extramaxlv, nil, serverSkillItem.skipLeftCD)
  self:UpdateSingleSkill(skillItemData, serverSkillItem)
  self.skills[#self.skills + 1] = skillItemData
  return skillItemData
end

function SkillProfessData:RemoveSkill(serverSkillItem)
  return self:RemoveSkillByIdAndSource(serverSkillItem.id, serverSkillItem.sourceid)
end

function SkillProfessData:RemoveSkillByIdAndSource(id, source)
  local skill, index = self:FindSkillByIdAndSource(id, source)
  if skill then
    table.remove(self.skills, index)
  end
  return skill, index
end

function SkillProfessData:FindSkillByIdAndSource(id, source)
  for i = 1, #self.skills do
    if id == self.skills[i].id and (source == nil or self.skills[i].sourceId == source) then
      return self.skills[i], i
    end
  end
end

function SkillProfessData:FindSkillById(id)
  for i = 1, #self.skills do
    if id == self.skills[i]:GetID() then
      return self.skills[i], i
    end
  end
end

function SkillProfessData:FindSkillByFamilyId(familyId)
  for i = 1, #self.skills do
    local skill = self.skills[i]
    if skill:GetSortID() == familyId then
      return skill
    end
  end
end

function SkillProfessData:SortSkills()
  if self.profession ~= ProfessionProxy.CommonClass then
    table.sort(self.skills, function(l, r)
      if l.id == r.id then
        return l.sourceId < r.sourceId
      else
        return l.id < r.id
      end
    end)
  else
    table.sort(self.skills, function(l, r)
      local lstaticData = l.staticData
      local rstaticData = r.staticData
      if lstaticData and rstaticData then
      else
        return false
      end
      if lstaticData.id == 50061001 or rstaticData.id == 50061001 then
        return lstaticData.id == 50061001
      end
      if lstaticData.SkillType ~= rstaticData.SkillType then
        if GameConfig.SkillType[lstaticData.SkillType].isPassive then
          return false
        end
        if GameConfig.SkillType[rstaticData.SkillType].isPassive then
          return true
        end
      end
      if lstaticData.Contidion.riskid ~= rstaticData.Contidion.riskid then
        if lstaticData.Contidion.riskid == nil then
          return true
        end
        if rstaticData.Contidion.riskid == nil then
          return false
        end
      end
      if l.id == r.id then
        return l.sourceId < r.sourceId
      else
        return l.id < r.id
      end
    end)
  end
end
