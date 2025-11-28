autoImport("SkillProfessData")
autoImport("SkillBeingData")
autoImport("BeingInfoData")
autoImport("ShortCutData")
autoImport("MasterSkillProfessData")
autoImport("InheritSkillItemData")
SkillSaveData = class("SkillSaveData")

function SkillSaveData:ctor(serverSkillData, pro, jobLv)
  self.professionSkillList = {}
  self.beingSkillList = {}
  self.equipedSkills = {}
  self.equipedAutoSkills = {}
  self.beinginfo = {}
  self.jobLevel = jobLv
  self.left_point = serverSkillData.left_point
  self.skillShortCut = ShortCutData.new()
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  local length = 0
  if serverSkillData.beings then
    length = #serverSkillData.beings
    local data, skillBeingData, skill
    for i = 1, length do
      data = serverSkillData.beings[i]
      local config = Table_Being[data.id]
      skillBeingData = SkillBeingData.new(data.id, config, 0, 0)
      self.beingSkillList[data.id] = skillBeingData
      skillBeingData:UpdatePoints(data.usedpoint)
      skillBeingData:SetLeftPoint(data.leftpoint)
      skillBeingData:Server_UpdateDynamicSkillInfos(data)
      for j = 1, #data.items do
        skill = data.items[j]
        skillBeingData:UpdateSkill(skill)
      end
      skillBeingData:ResetSimulateDatas()
      for i = 1, 50 do
        local t = config["Skill_" .. i]
        if t == nil then
          break
        end
        skillBeingData:SetSkillRequiredLevel(t[1], t[2])
      end
    end
    self:GetBeingsArray()
  end
  if serverSkillData.datas then
    length = #serverSkillData.datas
    for i = 1, length do
      self:AddProfessSkill(self:CreateProfessSkill(serverSkillData.datas[i]))
    end
  end
  if ISNoviceServerType then
    local config = Table_JobLevel[jobLv]
    if config and config.MasterLv and 0 < config.MasterLv then
      local serverMasterSkillData = serverSkillData.master_skill_data
      if serverMasterSkillData then
        self:CreateMasterSkillProfessData(pro, serverMasterSkillData.unlock_limit_skill_index)
        if serverMasterSkillData.skill_ids then
          for i = 1, #serverMasterSkillData.skill_ids do
            local skillId = serverMasterSkillData.skill_ids[i]
            local skill = self.masterSkillProfessData:AddMasterSkill(skillId, true)
            self:LearnedSkill(skill)
          end
        end
        if self.masterSkillProfessData then
          self.masterSkillProfessData:SortSkills()
          self.equipMasterSkillFamilyId = serverMasterSkillData.equip_skill_family_id
          self.masterSkillProfessData:UpdateMasterSkillPoints(self.equipMasterSkillFamilyId)
          local skill = self.masterSkillProfessData:FindSkillByFamilyId(self.equipMasterSkillFamilyId)
          if skill then
            local shortcuts = serverMasterSkillData.shortcuts
            if shortcuts then
              skill:UpdateShortcuts(shortcuts)
            end
            if self:_CheckPosInShortCut(skill) then
              table.insert(self.equipedSkills, skill)
            end
            if 0 < skill:GetPosInShortCutGroup(shortCutAuto) then
              table.insert(self.equipedAutoSkills, skill)
            end
          end
        end
      end
    end
  end
  if serverSkillData.curbeingid then
    self.curBeingID = serverSkillData.curbeingid
  end
  if serverSkillData.beinginfos then
    length = #serverSkillData.beinginfos
    local temp, beingInfo
    for i = 1, length do
      temp = serverSkillData.beinginfos[i]
      beingInfo = BeingInfoData.new()
      self.beinginfo[temp.beingid] = beingInfo
      beingInfo:Server_SetData(temp)
    end
  end
  if serverSkillData.shortcut then
    self.skillShortCut:ResetSkillShortCuts()
    local shortcuts = serverSkillData.shortcut.shortcuts
    for i = 1, #shortcuts do
      local shortcut = shortcuts[i]
      self.skillShortCut:UnLockSkillShortCuts(shortcut)
    end
  end
  if serverSkillData.inherit then
    local serverSkills = serverSkillData.inherit.items
    if serverSkills then
      for i = 1, #serverSkills do
        local familyId = serverSkills[i].id // 1000
        local skill = InheritSkillItemData.new(familyId)
        skill:UpdateSkill(serverSkills[i])
        if skill.isLoad then
          self:LearnedSkill(skill)
        end
        if self:_CheckPosInShortCut(skill) then
          table.insert(self.equipedSkills, skill)
        end
        if 0 < skill:GetPosInShortCutGroup(shortCutAuto) then
          table.insert(self.equipedAutoSkills, skill)
        end
      end
    end
  end
end

function SkillSaveData:GetProfessionSkill()
  return self.professionSkillList
end

function SkillSaveData:GetBeingSkill()
  return self.beingSkillList
end

function SkillSaveData:GetBeingInfo(beingid)
  return self.beinginfo[beingid]
end

function SkillSaveData:GetUnusedSkillPoint()
  local masterSkillLeftPoint = 0
  if self.masterSkillProfessData then
    local config = Table_JobLevel[self.jobLevel]
    if config and config.MasterLv and 0 < config.MasterLv then
      masterSkillLeftPoint = config.ShowLevel - self.masterSkillProfessData.points
    end
  end
  return self.left_point + masterSkillLeftPoint
end

function SkillSaveData:GetCurrentBeing()
  return self.curBeingID
end

function SkillSaveData:GetEquipedSkills()
  return self.equipedSkills
end

function SkillSaveData:GetEquipedAutoSkills()
  return self.equipedAutoSkills
end

function SkillSaveData:CreateProfessSkill(serverSkillData)
  local data, skill
  local professSkill = SkillProfessData.new(serverSkillData.profession, serverSkillData.usedpoint)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  for j = 1, #serverSkillData.items do
    data = serverSkillData.items[j]
    data.skipLeftCD = true
    skill = professSkill:UpdateSkill(data)
    if self:_CheckPosInShortCut(skill) then
      table.insert(self.equipedSkills, skill)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
      table.insert(self.equipedAutoSkills, skill)
    end
    if skill.profession == ProfessionProxy.CommonClass and not skill.learned then
      skill.learned = true
    end
    if skill.learned then
      self:LearnedSkill(skill)
    end
  end
  professSkill:SortSkills()
  return professSkill
end

function SkillSaveData:_CheckPosInShortCut(skill)
  if skill ~= nil then
    local _ShortCutEnum = ShortCutProxy.ShortCutEnum
    for k, v in pairs(_ShortCutEnum) do
      if skill:GetPosInShortCutGroup(v) > 0 then
        return true
      end
    end
  end
  return false
end

function SkillSaveData:AddProfessSkill(professSkill)
  self.professionSkillList[#self.professionSkillList + 1] = professSkill
  table.sort(self.professionSkillList, function(l, r)
    return l.profession < r.profession
  end)
end

function SkillSaveData:GetBeingsArray()
  local arrays = {}
  local hasSelect = false
  for k, v in pairs(self.beingSkillList) do
    arrays[#arrays + 1] = v
    if v.isSelect then
      hasSelect = true
    end
  end
  table.sort(arrays, function(l, r)
    return l.profession < r.profession
  end)
  if hasSelect == false and 0 < #arrays then
    arrays[1]:SetSelect(true)
  end
  return arrays
end

function SkillSaveData:LearnedSkill(skillItemData)
  local beings = self:GetSummonBeings(skillItemData.staticData)
  if beings and 0 < #beings then
    self:SetEnableBeings(beings, true)
  end
end

function SkillSaveData:GetSummonBeings(staticData)
  if not staticData then
    return
  end
  local Logic_Param = staticData.Logic_Param
  if Logic_Param then
    return Logic_Param.being_ids
  end
end

function SkillSaveData:SetEnableBeings(beingIDs, val)
  if beingIDs then
    for i = 1, #beingIDs do
      local being = self:GetSkillBeingData(beingIDs[i])
      if being then
        being.isEnabled = val
      end
    end
  end
end

function SkillSaveData:GetSkillBeingData(creatureID)
  if creatureID then
    return self.beingSkillList[creatureID]
  end
end

function SkillSaveData:GetUsedPoints()
  self.totalUsedPoint = 0
  for i = 1, #self.professionSkillList do
    if self.professionSkillList[i].points then
      self.totalUsedPoint = self.totalUsedPoint + self.professionSkillList[i].points
    end
  end
  if self.masterSkillProfessData then
    self.totalUsedPoint = self.totalUsedPoint + self.masterSkillProfessData.points
  end
  return self.totalUsedPoint
end

function SkillSaveData:GetCurrentEquipedSkillData(autoFill, shortCutID)
  if shortCutID == nil then
    shortCutID = ShortCutProxy.ShortCutEnum.ID1
  end
  if autoFill then
    local equipedSkillData = {}
    for i = 1, ShortCutData.CONFIGSKILLNUM do
      local item = SkillItemData.new(0, i, nil, nil, nil, i)
      equipedSkillData[i] = item
    end
    local pos
    for k, v in pairs(self.equipedSkills) do
      if autoFill then
        pos = v:GetPosInShortCutGroup(shortCutID)
        if pos ~= nil and pos ~= 0 then
          equipedSkillData[pos] = v
        end
      elseif not v.shadow then
        table.insert(equipedSkillData, v)
      end
    end
    return equipedSkillData
  end
end

function SkillSaveData:ShortCutListIsEnable(id)
  return self.skillShortCut:ShortCutListIsEnable(id)
end

function SkillSaveData:SkillIsLocked(index, id)
  return self.skillShortCut:SkillIsLocked(index, id)
end

function SkillSaveData:AutoSkillIsLocked(index)
  return self.skillShortCut:AutoSkillIsLocked(index)
end

function SkillSaveData:GetLearnItemCost()
  local itemCost, skills, cost, icost = {}
  for i = 1, #self.professionSkillList do
    skills = self.professionSkillList[i].skills
    for j = i, #skills do
      if skills[j].learned then
        cost = Table_Skill[skills[j].id].ItemCost
        for i = 1, #cost do
          icost = cost[i]
          if icost.id and icost.count then
            itemCost[icost.id] = itemCost[icost.id] and itemCost[icost.id] + icost.count or icost.count
          end
        end
      end
    end
  end
  return itemCost
end

function SkillSaveData:CreateMasterSkillProfessData(profession, unlockSkillIndex)
  local config = Table_Class[profession]
  if config then
    if config.MasterSkills and config.MasterSkills ~= _EmptyTable then
      self.masterSkillProfessData = MasterSkillProfessData.new(profession, 0, true)
      for i = 1, #config.MasterSkills do
        local skillIds = config.MasterSkills[i]
        for j = 1, #skillIds do
          self.masterSkillProfessData:AddMasterSkill(skillIds[j], nil, i)
        end
      end
    end
    if unlockSkillIndex and config.LimitMasterSkills and config.LimitMasterSkills ~= _EmptyTable then
      if not self.masterSkillProfessData then
        self.masterSkillProfessData = MasterSkillProfessData.new(myProfess, 0, true)
      end
      self.masterSkillProfessData:SetUnlockLimitSkillIndex(unlockSkillIndex)
      for i = 1, #unlockSkillIndex do
        local skillIds = config.LimitMasterSkills[unlockSkillIndex[i]]
        if skillIds then
          for j = 1, #skillIds do
            self.masterSkillProfessData:AddExtraMasterSkill(skillIds[j], nil, unlockSkillIndex[i])
          end
        end
      end
    end
  end
end

function SkillSaveData:GetMasterSkillProfessData()
  return self.masterSkillProfessData
end

function SkillSaveData:GetEquipMasterSkillFamilyId()
  return self.equipMasterSkillFamilyId
end
