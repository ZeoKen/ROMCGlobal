SkillPvpTalentData = class("SkillPvpTalentData")

function SkillPvpTalentData:ctor(points)
  self.skills = {}
  self:UpdatePoints(points)
end

function SkillPvpTalentData:UpdatePoints(points)
  self.usedPoints = points
end

function SkillPvpTalentData:UpdateSkill(serverSkillItem)
  local skill = self:FindSkillById(serverSkillItem.id)
  if skill then
    skill:Reset(serverSkillItem.id, serverSkillItem.pos, serverSkillItem.autopos, serverSkillItem.cd, serverSkillItem.sourceid, serverSkillItem.extendpos, serverSkillItem.shortcuts, serverSkillItem.extramaxlv)
    self:UpdateSingleSkill(skill, serverSkillItem)
  else
    skill = self:AddSkill(serverSkillItem)
  end
  if not Table_TalentSkill[skill.sortID] then
    LogUtility.Error(string.format("没有在Table_TalentSkill中找到技能%s的对应配置！", skill.id))
  end
  return skill
end

function SkillPvpTalentData:UpdateSingleSkill(skillItemData, serverSkillItem)
  if skillItemData then
    skillItemData:SetActive(serverSkillItem.active)
    skillItemData:SetLearned(serverSkillItem.learn)
    skillItemData:SetSource(serverSkillItem.source)
    skillItemData:SetShadow(serverSkillItem.shadow)
    skillItemData:SetSpecialID(serverSkillItem.runespecid)
    skillItemData:SetReplaceID(serverSkillItem.replaceid)
    skillItemData:SetEnableSpecialEffect(serverSkillItem.selectswitch)
    skillItemData:SetExtraLevel(serverSkillItem.extralv)
    skillItemData:SetOwnerId(serverSkillItem.ownerid)
    local consume = serverSkillItem.consume
    if consume then
      skillItemData:ResetUseTimes(consume.curvalue, consume.maxvalue, consume.nexttime)
    end
  end
end

function SkillPvpTalentData:AddSkill(serverSkillItem)
  local skillItemData = SkillItemData.new(serverSkillItem.id, serverSkillItem.pos, serverSkillItem.autopos, SkillProxy.Instance:GetMyProfession(), serverSkillItem.sourceid, serverSkillItem.extendpos, serverSkillItem.shortcuts, serverSkillItem.extramaxlv)
  self:UpdateSingleSkill(skillItemData, serverSkillItem)
  self.skills[skillItemData.sortID] = skillItemData
  return skillItemData
end

function SkillPvpTalentData:RemoveSkill(serverSkillItem)
  if not serverSkillItem then
    return
  end
  local sortID = math.floor(serverSkillItem.id / 1000)
  local skill = self.skills[sortID]
  if skill and skill.id ~= serverSkillItem.id then
    return
  end
  self.skills[sortID] = nil
  return skill
end

function SkillPvpTalentData:FindSkillById(id)
  return self.skills[math.floor(id / 1000)]
end
