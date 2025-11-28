autoImport("SkillItemData")
autoImport("SkillPvpTalentData")
autoImport("SkillDynamicInfo")
autoImport("EquipedSkills")
autoImport("TimeDiskInfo")
autoImport("MasterSkillProfessData")
SkillProxy = class("SkillProxy", pm.Proxy)
SkillProxy.Instance = nil
SkillProxy.NAME = "SkillProxy"
SkillProxy.UNLOCKPROSKILLPOINTS = 40
SkillProxy.ManulSkillsIndex = 1
SkillProxy.AutoSkillsIndex = 2
SkillProxy.AutoSkillsWithComboIndex = 3
SkillProxy.AutoSkillsIndex2 = 7
SkillProxy.ForbidShowSkillSources = {
  ESOURCE.ESOURCE_MANUAL_SKILL,
  ESOURCE.ESOURCE_USER_RETURN
}
SkillProxy.ForbidShowSkillSources_CommonList = {
  ESOURCE.ESOURCE_MANUAL_SKILL,
  ESOURCE.ESOURCE_USER_RETURN,
  ESOURCE.ESOURCE_FEATURE_SKILL
}
local TIMEDISKMOVE_RUN = SceneSkill_pb.TIMEDISKMOVE_RUN
local TIMEDISKMOVE_SUSPEND = SceneSkill_pb.TIMEDISKMOVE_SUSPEND
local TIMEDISKMOVE_DEL = SceneSkill_pb.TIMEDISKMOVE_DEL
local _CurServerTime = ServerTime.CurServerTime
local ArrayFind = function(array, data, paramName)
  for i = 1, #array do
    if array[i][paramName] == data[paramName] then
      return array[i]
    end
  end
  return nil
end
local GetSubSkillOriginSP = function(id, param, totalSp)
  local staticData = Table_Skill[id]
  if staticData ~= nil then
    local sp = staticData.SkillCost.sp
    if sp ~= nil then
      totalSp = totalSp + sp
    end
    return totalSp
  end
end
local GetSubSkillSP = function(id, creature, totalSp)
  local staticData = Table_Skill[id]
  if staticData ~= nil then
    local sp = SkillInfo.GetSPCost(creature, staticData)
    if sp ~= nil then
      totalSp = totalSp + sp
    end
    return totalSp
  end
end
local AddSpecialCost = function(list, staticData, paramName)
  if staticData[paramName] then
    local value = ArrayFind(list, staticData, paramName)
    if value == nil then
      local data = ReusableTable.CreateTable()
      data[paramName] = staticData[paramName]
      data.num = staticData.num
      data.specialType = staticData.specialType
      list[#list + 1] = data
    else
      value.num = value.num + staticData.num
    end
  end
end
local GetSubSkillSpecialCost = function(id, param, list)
  local staticData = Table_Skill[id]
  if staticData ~= nil then
    local costs = staticData.SkillCost
    for i = 1, #costs do
      AddSpecialCost(list, costs[i], "itemID")
      AddSpecialCost(list, costs[i], "buffID")
      if costs[i].specialType == 4 then
        AddSpecialCost(list, costs[i], "bullets")
      end
    end
  end
  return list
end

function SkillProxy.IsBeforeFourthProfess(profess)
  return profess and profess % 10 < 5 or false
end

function SkillProxy.GetDesc(id)
  local staticData = Table_Skill[id]
  local desc = ""
  local config
  if staticData then
    for i = 1, #staticData.Desc do
      config = staticData.Desc[i]
      if Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc then
        if config.params then
          desc = desc .. string.format(Table_SkillDesc[config.id].Desc, unpack(config.params)) .. (i ~= #staticData.Desc and "\n" or "")
        else
          desc = desc .. Table_SkillDesc[config.id].Desc .. (i ~= #staticData.Desc and "\n" or "")
        end
      end
    end
  end
  return desc
end

function SkillProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SkillProxy.NAME
  if SkillProxy.Instance == nil then
    SkillProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.professionSkills = {}
  self.pvpTalentSkills = {}
  self.transformProfess = SkillProfessData.new(99999, 0)
  self.equipedSkills = {}
  self.equipedAutoSkills = {}
  self.equipedAutoSkills[SkillProxy.AutoSkillsIndex] = {}
  self.equipedAutoSkills[SkillProxy.AutoSkillsIndex2] = {}
  self.equipedSkillsArrays = {}
  self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex] = {}
  self.equipedSkillsArrays[SkillProxy.AutoSkillsIndex] = {}
  self.equipedSkillsArrays[SkillProxy.AutoSkillsWithComboIndex] = {}
  self.equipedSkillsArrays[SkillProxy.AutoSkillsIndex2] = {}
  self.comboGetPrevious = {}
  self.equipedAutoArrayDirty = false
  self:ResetTransformSkills(0)
  self.learnedSkills = {}
  self.dynamicSkillInfos = {}
  self:initSameProfessionType()
  self:initSameProfessionTypeBranch()
  self:InitCombo()
  FunctionSkillEnableCheck.Me():Launch()
  self.skillLeftCDMap = {}
  self.skillLeftCD_DirtyMap = {}
  self.skillMarkMap = {}
  self.timeDiskInfo = TimeDiskInfo.new()
  self.questSkillMap = {}
  self.balancedModeSkill = {
    0,
    0,
    0
  }
  self.masterSkillShortcuts = {}
  self.blockMasterSkills = {}
  self.fakeDeadSkillID = 0
  self.fakeDeadSkillAutoMode = 0
  self:InitMonsterSkill()
end

function SkillProxy:InitMonsterSkill()
  local config = GameConfig.MonsterSkill and GameConfig.MonsterSkill.UseMasterExecDamMonsterID
  if not config then
    return
  end
  self.monsterSkillMap = {}
  for _, id in pairs(config) do
    self.monsterSkillMap[id] = true
  end
end

function SkillProxy:IsMonsterSkill(monsterId)
  return self.monsterSkillMap and self.monsterSkillMap[monsterId]
end

function SkillProxy:InitCombo()
  if GameConfig.AutoSkillGroup then
    for k, v in pairs(GameConfig.AutoSkillGroup) do
      if 1 < #v then
        for i = #v, 2, -1 do
          self.comboGetPrevious[v[i]] = v[i - 1]
        end
      end
    end
  end
end

function SkillProxy:initSameProfessionType()
  self.sameProfessionType = {}
  for key, singleItem in pairs(Table_Class) do
    if singleItem.Type then
      self.sameProfessionType[singleItem.Type] = self.sameProfessionType[singleItem.Type] or {}
      table.insert(self.sameProfessionType[singleItem.Type], singleItem)
    end
  end
  local list, cur, advanceClasses, singleData = ReusableTable.CreateTable()
  for key, value in pairs(self.sameProfessionType) do
    table.sort(value, function(l, r)
      return l.id < r.id
    end)
    TableUtility.TableClear(list)
    for i = 1, #value do
      cur = value[i]
      advanceClasses = cur.AdvanceClass
      if advanceClasses then
        for j = 1, #advanceClasses do
          list[tostring(advanceClasses[j])] = cur
        end
      end
    end
    for i = 1, #value do
      cur = value[i]
      singleData = list[tostring(cur.id)]
      if not singleData and key ~= 0 then
        singleData = Table_Class[1]
      end
      cur.previousClasses = singleData
    end
  end
  ReusableTable.DestroyAndClearTable(list)
end

function SkillProxy:initSameProfessionTypeBranch()
  self.sameProfessionTypeBranch = {}
  for _, data in pairs(Table_Class) do
    self.sameProfessionTypeBranch[data.TypeBranch] = self.sameProfessionTypeBranch[data.TypeBranch] or {}
    table.insert(self.sameProfessionTypeBranch[data.TypeBranch], data)
  end
end

function SkillProxy:GetEquipedSkillBySort(sortID)
  for k, v in pairs(self.equipedSkills) do
    if v.sortID == sortID and v.sourceId == 0 then
      return true
    end
  end
  return false
end

function SkillProxy:GetEquipedSkillByGuid(skillId, includeAuto)
  local skill = self.equipedSkills[skillId]
  if skill == nil and includeAuto then
    skill = self:GetEquipedAutoSkillByGuid(skillId)
  end
  return skill
end

function SkillProxy:GetEquipedAutoSkillByGuid(skillId)
  return self.equipedAutoSkills[skillId]
end

function SkillProxy:startCdTimeBySkillId(skillId)
  local sortID = math.floor(skillId / 1000)
  local skills = self.learnedSkills[sortID]
  local skillCD, skillDelayCD = 0, 0
  local myself = Game.Myself
  if myself ~= nil then
    if myself.data:GetAttackSkillIDAndLevel() ~= skillId then
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillId)
      skillCD = skillInfo:GetCD(myself)
      skillDelayCD = skillInfo:GetDelayCD(myself)
    end
    if skills then
      local skill
      for i = 1, #skills do
        skill = self:GetEquipedSkillByGuid(skills[i].guid, true)
        if skill == nil then
          skill = self:GetTransformedSkill(skills[i].id)
        end
        if skill == nil then
          skill = skills[i]
        end
        self:_InnerStartCD(skill, skillCD, skillDelayCD)
      end
    else
      local findSkill = self:FindSkill(skillId)
      if findSkill ~= nil then
        self:_InnerStartCD(findSkill, skillCD, skillDelayCD)
      end
    end
    GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
  end
end

function SkillProxy:_InnerStartCD(skillItemData, skillCD, skillDelayCD)
  if skillItemData then
    if skillCD then
      local maxtimes = skillItemData:GetMaxCDTimes(Game.Myself)
      if maxtimes and 0 < maxtimes then
        self:UseLeftCDTimes(skillItemData:GetSortID())
        CDProxy.Instance:Client_AddSkillCD(skillItemData:GetID(), 0, skillCD, skillCD)
      else
        CDProxy.Instance:Client_AddSkillCD(skillItemData:GetID(), ServerTime.CurServerTime() + skillCD * 1000, skillCD, skillCD)
      end
    end
    local staticData = skillItemData:GetStaticData()
    if staticData then
      local buff
      if Game.MapManager:IsPVPMode() then
        buff = staticData.Buff
      else
        buff = staticData.Pvp_buff
      end
      if buff.self ~= nil then
        local buffConfig, cdTime, buffcd
        for i = 1, #buff.self do
          buffConfig = Table_Buffer[buff.self[i]]
          if buffConfig and buffConfig.BuffEffect and buffConfig.BuffEffect.type and buffConfig.BuffEffect.type == "AddSkillCD" then
            buffcd = buffConfig.BuffEffect.cd
            if buffcd then
              for j = 1, #buffcd do
                cdTime = buffcd[j].time
                if 0 < cdTime then
                  CDProxy.Instance:AddSkillCD(buffcd[j].id, 0, cdTime, cdTime)
                end
              end
            end
          end
        end
      end
    end
    if skillDelayCD and 0 < skillDelayCD then
      CDProxy.Instance:Client_AddSkillDelayCD(CDProxy.CommunalSkillCDID, 0, skillDelayCD, skillDelayCD)
    end
  end
end

function SkillProxy:HasEnoughSkillPoint(pro)
  local p = self:FindProfessSkill(pro)
  if p then
    return p.points >= SkillProxy.UNLOCKPROSKILLPOINTS
  end
  return false
end

function SkillProxy:FindProfessSkill(pro, autoCreate)
  if self.multiSaveId ~= nil then
    local skills = SaveInfoProxy.Instance:GetProfessionSkill(self.multiSaveId, self.multiSaveType)
    if skills ~= nil then
      for i = 1, #skills do
        if pro == skills[i].profession then
          return skills[i]
        end
      end
    end
  else
    for i = 1, #self.professionSkills do
      if pro == self.professionSkills[i].profession then
        return self.professionSkills[i]
      end
    end
  end
  if autoCreate then
    local professData = SkillProfessData.new(pro, 0)
    local p = Table_Class[pro]
    for i = 1, #p.Skill do
      professData:AutoFillAdd(p.Skill[i])
    end
    self:AddProfessSkill(professData)
    return professData
  end
  return nil
end

function SkillProxy:FindSkill(skillID, profession)
  local professionSkill
  if profession then
    professionSkill = self:FindProfessSkill(profession)
    if professionSkill then
      return professionSkill:FindSkillById(skillID)
    end
  end
  local skill
  for i = 1, #self.professionSkills do
    skill = self.professionSkills[i]:FindSkillById(skillID)
    if skill then
      return skill
    end
  end
  for i = 1, #self.pvpTalentSkills do
    skill = self.pvpTalentSkills[i]:FindSkillById(skillID)
    if skill then
      return skill
    end
  end
  return self:GetTransformedSkill(skillID)
end

function SkillProxy:GetPvpTalentSkillsData()
  return self.pvpTalentSkills and #self.pvpTalentSkills > 0 and self.pvpTalentSkills[1] or nil
end

function SkillProxy:ServerReInit(serverData)
  Game.Myself:Client_SetAutoFakeDead(0)
  self.fakeDeadSkillID = 0
  self.fakeDeadSkillAutoMode = 0
  Game.Myself:ShutDownAutoReloadCheck()
  self.professionSkills = {}
  self.pvpTalentSkills = {}
  self:ClearEquipedSkill()
  self:ClearEquipedSkill(true, SkillProxy.AutoSkillsIndex)
  self:ClearEquipedSkill(true, SkillProxy.AutoSkillsIndex2)
  self.learnedSkills = {}
  local professSkill
  for i = 1, #serverData.data do
    self:AddProfessSkill(self:CreateProfessSkill(serverData.data[i]))
  end
  for i = 1, #serverData.talentdata do
    self:AddLearnedPvpTalentSkill(serverData.talentdata[i])
  end
  self.usedPointDirty = true
  self.alreadyGetFourthSkillReward = serverData.forth_skill_fulled
  if serverData.auto_shortcut and serverData.auto_shortcut ~= 0 then
    ShortCutProxy.Instance:SetCurrentAuto(serverData.auto_shortcut)
  end
  self.masterSkillShortcuts = {}
  local masterSkillData = serverData.master_skill_data
  if masterSkillData then
    local pro = masterSkillData.pro
    local skillIds = masterSkillData.skill_ids
    local unlockSkillIndex = masterSkillData.unlock_limit_skill_index
    self:CreateMasterSkillProfessData(pro, unlockSkillIndex)
    if self.masterProfessData then
      self:UpdateMasterProfessData(skillIds)
      self:UpdateMasterSkillShortcuts(masterSkillData.equip_skill_family_id, masterSkillData.shortcuts)
    end
    self:SetBlockMasterSkill()
  else
    self:ClearMasterSkillProfessData()
  end
end

function SkillProxy:ClearEquipedSkill(isAutoMode, AutoMode)
  local t
  if isAutoMode then
    t = self.equipedAutoSkills[AutoMode]
  else
    t = self.equipedSkills
  end
  for k, v in pairs(t) do
    FunctionSkillEnableCheck.Me():RemoveCheckSkill(v)
  end
  if isAutoMode then
    self.equipedAutoSkills[AutoMode] = {}
    self.equipedSkillsArrays[AutoMode] = {}
  else
    self.equipedSkills = {}
    self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex] = {}
  end
end

function SkillProxy:CreateProfessSkill(serverSkillData)
  local data, skill
  local professSkill = SkillProfessData.new(serverSkillData.profession, serverSkillData.usedpoint)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
  for j = 1, #serverSkillData.items do
    data = serverSkillData.items[j]
    skill = professSkill:UpdateSkill(data)
    if self:_CheckPosInShortCut(skill) then
      self:AddEquipSkill(skill)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
      self:AddEquipSkill(skill, shortCutAuto)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto2) > 0 then
      self:AddEquipSkill(skill, shortCutAuto2)
    end
    if skill.learned then
      self:LearnedSkill(skill)
    end
  end
  professSkill:SortSkills()
  professSkill:UpdateBasePoints(serverSkillData.primarypoint)
  return professSkill
end

function SkillProxy:AddLearnedPvpTalentSkill(serverTalentData)
  local data, skill
  local talentSkills = SkillPvpTalentData.new(serverTalentData.usedpoint)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
  for i = 1, #serverTalentData.items do
    data = serverTalentData.items[i]
    skill = talentSkills:UpdateSkill(data)
    if self:_CheckPosInShortCut(skill) then
      self:AddEquipSkill(skill)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
      self:AddEquipSkill(skill, true)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto2) > 0 then
      self:AddEquipSkill(skill, shortCutAuto2)
    end
    self:LearnedSkill(skill)
  end
  self.pvpTalentSkills[#self.pvpTalentSkills + 1] = talentSkills
end

function SkillProxy:_CheckPosInShortCut(skill)
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

function SkillProxy:AddProfessSkill(professSkill)
  self.professionSkills[#self.professionSkills + 1] = professSkill
  table.sort(self.professionSkills, function(l, r)
    return l.profession < r.profession
  end)
end

function SkillProxy:AddEquipSkill(skillItemData, AutoMode)
  if TableUtility.ArrayFindIndex(self.ForbidShowSkillSources, skillItemData.source) > 0 then
    return
  end
  local isAutoMode = AutoMode and (AutoMode == ShortCutProxy.SkillShortCut.Auto or AutoMode == ShortCutProxy.SkillShortCut.Auto2)
  local skilltable = isAutoMode and self.equipedAutoSkills and self.equipedAutoSkills[AutoMode] or self.equipedSkills
  local skill = skilltable[skillItemData.guid]
  if skill == nil or skill ~= skillItemData then
    EventManager.Me():PassEvent(SkillEvent.SkillEquip, skillItemData)
    skilltable[skillItemData.guid] = skillItemData
  end
  local skillArray = self:GetEquipedSkillsArray(isAutoMode, AutoMode)
  if skillItemData.shadow == false then
    local shortCutType
    if isAutoMode then
      shortCutType = AutoMode
    else
      shortCutType = ShortCutProxy.ShortCutEnum.ID1
    end
    if TableUtil.IndexOf(skillArray, skillItemData) == 0 then
      local added = false
      for i = 1, #skillArray do
        if skillArray[i]:GetPosInShortCutGroup(shortCutType) > skillItemData:GetPosInShortCutGroup(shortCutType) then
          table.insert(skillArray, i, skillItemData)
          added = true
          break
        elseif skillArray[i]:GetPosInShortCutGroup(shortCutType) == skillItemData:GetPosInShortCutGroup(shortCutType) then
          skillArray[i] = skillItemData
          added = true
          break
        end
      end
      if not added then
        skillArray[#skillArray + 1] = skillItemData
      end
      if isAutoMode then
        self.equipedAutoArrayDirty = true
        if skillItemData.staticData.SkillType == SkillType.FakeDead then
          self:SetFakeDeadSkill(skillItemData:GetID(), AutoMode)
        end
      end
    else
      table.sort(skillArray, function(l, r)
        return l:GetPosInShortCutGroup(shortCutType) < r:GetPosInShortCutGroup(shortCutType)
      end)
    end
  else
    TableUtil.Remove(skillArray, skillItemData)
  end
end

function SkillProxy:SetFakeDeadSkill(skillID, AutoMode)
  self.fakeDeadSkillID = skillID
  self.fakeDeadSkillAutoMode = AutoMode
end

function SkillProxy:GetFakeDeadSkill(AutoMode)
  if AutoMode == self.fakeDeadSkillAutoMode then
    return self.fakeDeadSkillID
  end
  return 0
end

function SkillProxy:RemoveEquipSkill(skillItemData, AutoMode)
  local isAutoMode = AutoMode and (AutoMode == ShortCutProxy.SkillShortCut.Auto or AutoMode == ShortCutProxy.SkillShortCut.Auto2)
  local skilltable = isAutoMode and self.equipedAutoSkills and self.equipedAutoSkills[AutoMode] or self.equipedSkills
  skilltable[skillItemData.guid] = nil
  local skillArray = self:GetEquipedSkillsArray(isAutoMode, AutoMode)
  if TableUtil.Remove(skillArray, skillItemData) > 0 and isAutoMode then
    self.equipedAutoArrayDirty = true
  end
  local flag = true
  if self.equipedSkills[skillItemData.guid] == nil then
    for _, stable in pairs(self.equipedAutoSkills) do
      if stable[skillItemData.guid] ~= nil then
        flag = false
      end
    end
    if flag then
      EventManager.Me():PassEvent(SkillEvent.SkillDisEquip, skillItemData)
    end
  end
  local shortCutAuto = ShortCutProxy.Instance:GetCurrentAuto()
  if AutoMode == shortCutAuto and skilltable[skillItemData.guid] == nil and skillItemData.staticData.SkillType == SkillType.FakeDead then
    Game.Myself:Client_SetAutoFakeDead(0)
    self:SetFakeDeadSkill(0, AutoMode)
  end
end

function SkillProxy:LearnedSkill(skillItemData)
  self.equipedAutoArrayDirty = true
  local skills = self.learnedSkills[skillItemData.sortID]
  if not skills then
    skills = {}
    self.learnedSkills[skillItemData.sortID] = skills
    skills[1] = skillItemData
  elseif TableUtil.IndexOf(skills, skillItemData) == 0 then
    skills[#skills + 1] = skillItemData
  end
  if skillItemData.id == GameConfig.Expression_Blink.needskill then
    FunctionPlayerHead.Me():EnableBlinkEye()
  end
  local beings = self:GetSummonBeings(skillItemData.staticData)
  if beings and 0 < #beings then
    CreatureSkillProxy.Instance:SetEnableBeings(beings, true)
  end
  if skillItemData:GetID() == ReloadSkillID then
    Game.Myself:LaunchAutoReloadCheck(ReloadSkillID)
  end
  CDProxy.Instance:UpdateCDData(skillItemData)
end

function SkillProxy:GetSummonBeings(staticData)
  if staticData and staticData.Logic_Param then
    local Logic_Param = staticData.Logic_Param
    if Logic_Param then
      return Logic_Param.being_ids
    end
  end
end

function SkillProxy:RemoveLearnedSkill(skillItemData)
  local skills = self.learnedSkills[skillItemData.sortID]
  if skills then
    if skillItemData:GetID() == ReloadSkillID then
      Game.Myself:ShutDownAutoReloadCheck()
    end
    TableUtil.Remove(skills, skillItemData)
    if #skills == 0 then
      self.learnedSkills[skillItemData.sortID] = nil
      local beings = self:GetSummonBeings(skillItemData.staticData)
      if beings and 0 < #beings then
        CreatureSkillProxy.Instance:SetEnableBeings(beings, false)
      end
    end
  end
end

function SkillProxy:GetUsedPoints()
  if self.usedPointDirty then
    self.usedPointDirty = false
    self.totalUsedPoint = 0
    for i = 1, #self.professionSkills do
      if self.professionSkills[i].points then
        self.totalUsedPoint = self.totalUsedPoint + self.professionSkills[i].points
      end
    end
  end
  return self.totalUsedPoint
end

function SkillProxy:GetThirdUsedPoints()
  local usedPoint = 0
  for i = 1, #self.professionSkills do
    if SkillProxy.IsBeforeFourthProfess(self.professionSkills[i].profession) and self.professionSkills[i].points then
      usedPoint = usedPoint + self.professionSkills[i].points
    end
  end
  return usedPoint
end

function SkillProxy:Update(data)
  self.alreadyGetFourthSkillReward = data.forth_skill_fulled_change
  local update = data.update
  local del = data.del
  local talentUpdate = data.talent_update
  local talentDel = data.talent_del
  local myself = Game.Myself
  local proId = myself.data.userdata:Get(UDEnum.PROFESSION)
  local profess, professSkill, data, skill, talentData
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
  local dirtyGUIDMap = {}
  for i = 1, #update do
    profess = update[i]
    professSkill = self:FindProfessSkill(profess.profession)
    if professSkill then
      self.usedPointDirty = true
      professSkill:UpdatePoints(profess.usedpoint)
      for j = 1, #profess.items do
        data = profess.items[j]
        skill = professSkill:UpdateSkill(data)
        if data.consume then
          GameFacade.Instance:sendNotification(SkillEvent.SkillWithUseTimesChanged, skill.id)
        end
        self:UpdateEquipSkill(skill)
        if skill.learned then
          self:LearnedSkill(skill)
        else
          self:RemoveLearnedSkill(skill)
        end
        dirtyGUIDMap[skill.guid] = 1
      end
      professSkill:UpdateBasePoints(profess.primarypoint)
      professSkill:SortSkills()
    else
      self:AddProfessSkill(self:CreateProfessSkill(profess))
    end
  end
  for i = 1, #del do
    profess = del[i]
    professSkill = self:FindProfessSkill(profess.profession)
    if professSkill then
      for j = 1, #profess.items do
        data = profess.items[j]
        skill = professSkill:RemoveSkill(data)
        if skill then
          self:RemoveEquipSkill(skill)
          self:RemoveEquipSkill(skill, shortCutAuto)
          self:RemoveEquipSkill(skill, shortCutAuto2)
          self:RemoveLearnedSkill(skill)
          dirtyGUIDMap[skill.guid] = 1
        end
      end
    end
  end
  local talentSkills = self:GetPvpTalentSkillsData()
  for i = 1, #talentUpdate do
    talentData = talentUpdate[i]
    if talentSkills then
      talentSkills:UpdatePoints(talentData.usedpoint)
      for j = 1, #talentData.items do
        data = talentData.items[j]
        skill = talentSkills:UpdateSkill(data)
        if data.consume then
          GameFacade.Instance:sendNotification(SkillEvent.SkillWithUseTimesChanged, skill.id)
        end
        self:UpdateEquipSkill(skill)
        self:LearnedSkill(skill)
        dirtyGUIDMap[skill.guid] = 1
      end
    else
      self:AddLearnedPvpTalentSkill(talentData)
    end
  end
  for i = 1, #talentDel do
    talentData = talentDel[i]
    talentSkills:UpdatePoints(talentData.usedpoint)
    for j = 1, #talentData.items do
      skill = talentSkills:RemoveSkill(talentData.items[j])
      if skill then
        self:RemoveEquipSkill(skill)
        self:RemoveLearnedSkill(skill)
        dirtyGUIDMap[skill.guid] = 1
      end
    end
  end
  return dirtyGUIDMap
end

function SkillProxy:GetEquipedSkillsArray(isAuto, AutoMode)
  if isAuto then
    return self.equipedSkillsArrays[AutoMode]
  else
    return self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex]
  end
end

function SkillProxy:IsEquipedSkillEmpty(shortCutID)
  local pos
  for k, v in pairs(self.equipedSkills) do
    pos = v:GetPosInShortCutGroup(shortCutID)
    if pos ~= nil and pos ~= 0 then
      return false
    end
  end
  return true
end

function SkillProxy:GetCurrentEquipedSkillData(autoFill, shortCutID)
  if shortCutID == nil then
    shortCutID = ShortCutProxy.ShortCutEnum.ID1
  end
  if autoFill then
    local equipedSkillData = {}
    if autoFill then
      for i = 1, ShortCutData.CONFIGSKILLNUM do
        local item = SkillItemData.new(0, i, nil, nil, nil, i)
        item:SetPosInShortCutGroup(shortCutID, i)
        equipedSkillData[i] = item
      end
    end
    local pos, equipedSkills
    if self.multiSaveId ~= nil then
      equipedSkills = SaveInfoProxy.Instance:GetEquipedSkills(self.multiSaveId, self.multiSaveType)
    end
    equipedSkills = equipedSkills or self.equipedSkills
    for k, v in pairs(equipedSkills) do
      if autoFill then
        pos = v:GetPosInShortCutGroup(shortCutID)
        if pos ~= nil and pos ~= 0 then
          equipedSkillData[pos] = v
        end
      elseif not v.shadow then
        table.insert(equipedSkillData, v)
      end
    end
    if not autoFill then
      local ID1 = ShortCutProxy.ShortCutEnum.ID1
      table.sort(equipedSkillData, function(l, r)
        return l:GetPosInShortCutGroup(ID1) < r:GetPosInShortCutGroup(ID1)
      end)
    end
    return equipedSkillData
  end
  return self:GetEquipedSkillsArray(false)
end

function SkillProxy:GetEquipedAutoSkillData(autoFill, AutoMode)
  if autoFill then
    local equipedSkillData = {}
    if autoFill then
      for i = 1, ShortCutData.CONFIGAUTOSKILLNUM do
        local item = SkillItemData.new(0, 0, i)
        item:SetPosInShortCutGroup(AutoMode, i)
        equipedSkillData[i] = item
      end
    end
    local equipedAutoSkills
    if self.multiSaveId ~= nil then
      equipedAutoSkills = SaveInfoProxy.Instance:GetEquipedAutoSkills(self.multiSaveId, self.multiSaveType)
    end
    equipedAutoSkills = equipedAutoSkills or self.equipedAutoSkills[AutoMode]
    local shortCutAuto = AutoMode
    for k, v in pairs(equipedAutoSkills) do
      if autoFill then
        equipedSkillData[v:GetPosInShortCutGroup(shortCutAuto)] = v
      elseif not v.shadow then
        table.insert(equipedSkillData, v)
      end
    end
    local sproxy = ShortCutProxy.Instance
    table.sort(equipedSkillData, function(l, r)
      return l:GetPosInShortCutGroup(shortCutAuto) < r:GetPosInShortCutGroup(shortCutAuto)
    end)
    return equipedSkillData
  end
  return self:GetEquipedSkillsArray(true, AutoMode)
end

function SkillProxy:GetEquipedAutoSkillNum(includeShadow)
  local num = 0
  local shortCutAuto = ShortCutProxy.Instance:GetCurrentAuto()
  for k, v in pairs(self.equipedAutoSkills[shortCutAuto]) do
    if (not v.shadow or v.shadow and includeShadow) and not ShortCutProxy.Instance:AutoSkillIsLocked(v:GetPosInShortCutGroup(shortCutAuto)) then
      num = num + 1
    end
  end
  return num
end

function SkillProxy:HasLearnedSkill(skillID)
  local skill = self:GetLearnedSkillWithSameSort(skillID)
  return skill ~= nil and skillID <= skill.id
end

function SkillProxy:HasLearnedSkillBySort(skillSortID)
  local skill = self:GetLearnedSkillBySortID(skillSortID)
  return skill ~= nil
end

function SkillProxy:GetLearnedSkill(skillID)
  local sortID = math.floor(skillID / 1000)
  local skills = self.learnedSkills[sortID]
  if skills then
    for i = 1, #skills do
      if skills[i].id == skillID then
        return skills[i]
      end
    end
  end
  return nil
end

function SkillProxy:GetLearnedSkillWithSameSort(skillID)
  local sortID = math.floor(skillID / 1000)
  return self:GetLearnedSkillBySortID(sortID)
end

function SkillProxy:GetLearnedSkillBySortID(sortID, allskills)
  local bokiSkill = BokiProxy.Instance:GetSkillIdByFamilyId(sortID)
  if bokiSkill then
    return bokiSkill
  else
    local skills = self.learnedSkills[sortID]
    return not (skills == nil or allskills) and skills[1] or skills or nil
  end
end

function SkillProxy:SetForbitUseWhiteList(skills)
  if skills and 0 < #skills then
    if not self.skillForbitUseWhiteList then
      self.skillForbitUseWhiteList = {}
    end
    TableUtility.ArrayClear(self.skillForbitUseWhiteList)
    for i = 1, #skills do
      self.skillForbitUseWhiteList[skills[i]] = true
    end
  elseif self.skillForbitUseWhiteList then
    self.skillForbitUseWhiteList = nil
  end
end

function SkillProxy:ForbitUse(skillItemData)
  local staticData = skillItemData and skillItemData.staticData
  local myselfData = Game.Myself.data
  if staticData then
    if self.skillForbitUseWhiteList and not self.skillForbitUseWhiteList[staticData.id] then
      return true
    end
    local forbidUse = staticData.ForbidUse
    if forbidUse ~= nil then
      local _MapManager = Game.MapManager
      local config = SkillItemData.ForbidUse
      if _MapManager:IsPVPMode_GVGDetailed() and forbidUse & config.GVG > 0 then
        return true
      end
      if (_MapManager:IsPVPMode_TeamPws() or _MapManager:IsPVPMode_3Teams()) and 0 < forbidUse & config.TeamPws then
        return true
      end
      if not _MapManager:IsPVPMode_TeamPws() and 0 < forbidUse & config.NotInTeamPws then
        return true
      end
      if 0 < forbidUse & config.PvpZone then
        local zoneid = Game.Myself.data.userdata:Get(UDEnum.ZONEID) or 0
        if ChangeZoneProxy.Instance:IsPvpZone(zoneid) then
          return true
        end
      end
      if _MapManager:IsPVEMode_Roguelike() and 0 < forbidUse & config.Roguelike then
        return true
      end
      if _MapManager:IsPvPMode_TeamTwelve() and 0 < forbidUse & config.TwelvePVP then
        return true
      end
      if _MapManager:IsRaidPuzzle() and 0 < forbidUse & config.Puzzle then
        return true
      end
      if (_MapManager:IsPVEMode_ComodoRaid() or _MapManager:IsPVEMode_MultiBossRaid()) and 0 < forbidUse & config.ComodoRaid then
        return true
      end
      if _MapManager:IsPveMode_Arena() and 0 < forbidUse & config.PveMode_Arena then
        return true
      end
      if _MapManager:IsPVEMode_CrackRaid() and 0 < forbidUse & config.PveMode_Crack then
        return true
      end
      if _MapManager:IsPVEMode_BossScene() and 0 < forbidUse & config.PveMode_BossScene then
        return true
      end
    end
    if skillItemData:GetID() == myselfData:GetAttackSkillIDAndLevel() and (not (not myselfData:NoNormalAttack() and self:CanMagicSkillUse(skillItemData) and self:CanPhySkillUse(skillItemData)) or myselfData:NoAttack()) then
      return true
    end
    local limitMap = staticData.Logic_Param.use_limit_map
    if limitMap ~= nil then
      local mapID = Game.MapManager:GetMapID()
      for i = 1, #limitMap do
        if mapID == limitMap[i] then
          return false
        end
      end
      return true
    end
  end
  if myselfData:CheckLastSkillValid() and myselfData:GetLastUseSkillBigID() == skillItemData:GetSortID() then
    return true
  end
  return false
end

function SkillProxy:SkillCanBeUsed(skillItem)
  local myselfData = Game.Myself.data
  if self:CanMagicSkillUse(skillItem) == false then
    return false
  end
  if self:CanPhySkillUse(skillItem) == false then
    return false
  end
  local skillID
  if type(skillItem) == "number" then
    skillID = skillItem
  else
    skillID = skillItem:GetID()
  end
  if myselfData:HasLimitSkill() and myselfData:GetLimitSkillTarget(skillID) == nil then
    return false
  end
  if myselfData:HasLimitNotSkill() and myselfData:GetLimitNotSkill(skillID) ~= nil then
    return false
  end
  if myselfData:GetLimitNotElement(skillID) then
    return false
  end
  if self:ForbitUse(skillItem) then
    return false
  end
  return not (not (not self:IsInCD(skillItem) and self:HasEnoughSp(skillItem) and self:HasEnoughHp(skillItem) and self:IsFitPreCondition(skillItem) and self:IsSubSkillFitPreCondition(skillItem) and self:HasFitSpecialCost(skillItem)) or self:IsExpire(skillItem)) and self:HasUseCount(skillItem) or false
end

function SkillProxy:SkillCanBeUsedByID(skillID, allowNoLearned, isTrigger)
  local myselfData = Game.Myself.data
  if myselfData:HasLimitSkill() and myselfData:GetLimitSkillTarget(skillID) == nil then
    return false
  end
  if myselfData:HasLimitNotSkill() and myselfData:GetLimitNotSkill(skillID) ~= nil then
    return false
  end
  if myselfData:GetLimitNotElement(skillID) then
    return false
  end
  local learnedSkill = self:GetLearnedSkill(skillID)
  if learnedSkill then
    if self:CanMagicSkillUse(learnedSkill) == false then
      return false
    end
    if self:CanPhySkillUse(learnedSkill) == false then
      return false
    end
    local canBeUsed = not (not (not self:IsInCD(learnedSkill, isTrigger) and self:HasEnoughSp(learnedSkill, nil, isTrigger) and self:HasEnoughHp(learnedSkill) and self:IsFitPreCondition(learnedSkill) and self:IsSubSkillFitPreCondition(learnedSkill) and self:HasFitSpecialCost(learnedSkill)) or self:IsExpire(learnedSkill)) and self:HasUseCount(learnedSkill) or false
    if self:ForbitUse(learnedSkill) then
      return false
    end
    return canBeUsed
  else
    learnedSkill = self:FindSkill(skillID)
    if learnedSkill then
      return self:SkillCanBeUsed(learnedSkill)
    end
    return allowNoLearned or false
  end
end

function SkillProxy:IsInCD(skillItem, isTrigger)
  if skillItem then
    if isTrigger then
      return false
    end
    if skillItem:GetID() == Game.Myself.data:GetAttackSkillIDAndLevel() then
      return false
    end
    local maxCDTimes = skillItem:GetMaxCDTimes(Game.Myself)
    if maxCDTimes and 0 < maxCDTimes then
      local leftCDTimes = skillItem:GetLeftCDTimes()
      if leftCDTimes and leftCDTimes <= 0 then
        local cdData = CDProxy.Instance:GetSkillInCD(skillItem:GetSortID())
        if not cdData then
          local cdMax = skillItem:GetCDMax() or 1
          CDProxy.Instance:Client_AddSkillCD(skillItem:GetID(), 0, cdMax, cdMax)
        end
        return true
      end
      return CDProxy.Instance:SkillInCommualCD(skillItem:GetSortID())
    end
    return CDProxy.Instance:SkillIsInCD(skillItem:GetSortID())
  end
  return true
end

function SkillProxy:IsExpire(skillItem)
  if skillItem == nil then
    return true
  end
  local expireTime = skillItem.expireTime
  if expireTime == nil or expireTime == 0 then
    return false
  end
  return expireTime < ServerTime.CurServerTime() / 1000
end

function SkillProxy:HasUseCount(skillItem)
  if skillItem == nil then
    return false
  end
  local allCount = skillItem.allCount
  if allCount == nil or allCount == 0 then
    return true
  end
  return allCount > skillItem.usedCount
end

function SkillProxy:IsFitPreCondition(skillItem)
  local dynamicSkillInfo = Game.Myself.data:GetDynamicSkillInfo(skillItem:GetID())
  if dynamicSkillInfo ~= nil and dynamicSkillInfo:GetIsNoCheck() then
    return true
  end
  return skillItem:GetFitPreCond()
end

function SkillProxy:IsSubSkillFitPreCondition(skillItem)
  if skillItem:HasSubSkill() then
    local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillItem:GetID())
    if subSkillList ~= nil then
      local subSkill
      for i = 1, #subSkillList do
        subSkill = self:GetLearnedSkill(subSkillList[i])
        if subSkill ~= nil and not self:IsFitPreCondition(subSkill) then
          return false
        end
      end
    end
  end
  return true
end

function SkillProxy:HasEnoughSp(skillItem, sp, isTrigger)
  local myself = Game.Myself
  local myselfData = myself.data
  if myselfData:IsTransformed() then
    return true
  end
  if isTrigger then
    return true
  end
  local skillID
  if type(skillItem) == "number" then
    skillID = skillItem
  else
    skillID = skillItem:GetID()
  end
  local dynamicSkillInfo = myselfData:GetDynamicSkillInfo(skillID)
  if dynamicSkillInfo ~= nil and dynamicSkillInfo:GetIsNoCheck() then
    return true
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo then
    local cost = self:GetSP(skillInfo, myself)
    sp = sp or myselfData.props:GetPropByName("Sp"):GetValue()
    if cost and cost > sp then
      return false
    else
      return true
    end
  end
  return false
end

function SkillProxy:HasEnoughHp(skillItem, hp)
  local myself = Game.Myself
  local myselfData = myself.data
  local skillID
  if type(skillItem) == "number" then
    skillID = skillItem
  else
    skillID = skillItem:GetID()
  end
  local dynamicSkillInfo = myselfData:GetDynamicSkillInfo(skillID)
  if dynamicSkillInfo ~= nil and dynamicSkillInfo:GetIsNoCheck() then
    return true
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo then
    local func = skillInfo.GetHP
    if func then
      local cost = func(skillInfo, myself)
      hp = hp or myselfData.props:GetPropByName("Hp"):GetValue()
      if cost and cost > hp then
        return false
      else
        return true
      end
    end
  end
  return false
end

function SkillProxy:HasFitSpecialCost(skillItem)
  local myself = Game.Myself
  if myself.data:IsTransformed() then
    return true
  end
  local skillStaticData
  if type(skillItem) == "number" then
    skillStaticData = Table_Skill[skillItem]
  else
    skillStaticData = skillItem:GetStaticData()
  end
  if skillStaticData then
    local dynamicSkillInfo = myself.data:GetDynamicSkillInfo(skillStaticData.id)
    local dynamicAllSkillInfo = self:GetDynamicAllSkillInfo()
    local isNoBuff
    if dynamicSkillInfo ~= nil then
      if dynamicSkillInfo:GetIsNoCheck() then
        return true
      end
      isNoBuff = dynamicSkillInfo:GetIsNoBuff()
    end
    local isNoItem = dynamicAllSkillInfo ~= nil and dynamicAllSkillInfo:GetIsNoItem()
    local skillCost = self:GetOriginSpecialCost(skillStaticData)
    if 0 < #skillCost then
      local lackCost, specialCost, num
      for i = 1, #skillCost do
        specialCost = skillCost[i]
        if not (not specialCost.itemID or isNoItem) or specialCost.specialType == 4 then
          if dynamicSkillInfo ~= nil then
            local clientIsNoItem = dynamicSkillInfo:GetClientIsNoItem()
            if clientIsNoItem then
              num = 0
            else
              num = dynamicSkillInfo:GetItemNewCost(specialCost.itemID, specialCost.num)
            end
          else
            num = specialCost.num
          end
          if num > self:GetItemNumBySkillCostCfg(specialCost.itemID, specialCost.specialType) then
            lackCost = lackCost or {}
            table.insert(lackCost, {
              specialCost.itemID,
              num
            })
          end
        end
        if specialCost.buffID and not isNoBuff then
          if dynamicSkillInfo then
            num = dynamicSkillInfo:GetItemNewCost(specialCost.buffID, specialCost.num)
          else
            num = specialCost.num
          end
          if num > myself:GetBuffLayer(specialCost.buffID) then
            return false, nil, false
          end
        end
      end
      if lackCost then
        return false, lackCost, true
      end
    elseif dynamicSkillInfo and dynamicSkillInfo.costs and not isNoItem then
      local lackCost
      for k, cost in pairs(dynamicSkillInfo.costs) do
        if cost[1] ~= nil and 0 < cost[2] and self:GetItemNumBySkillCostCfg(cost[1], nil) < cost[2] then
          lackCost = lackCost or {}
          table.insert(lackCost, cost)
        end
      end
      if lackCost then
        return false, lackCost, true
      end
    end
  end
  return true
end

function SkillProxy:GetItemNumBySkillCostCfg(itemID, specialType)
  if not specialType then
    return BagProxy.Instance:GetItemNumByStaticID(itemID)
  elseif specialType == ESPECIALSKILLCOSTTYPE.ESPSCOSTTYPE_HEADWEARACTIVITYSCENE then
    return HeadwearRaidProxy.Instance:GetHeadwearRaidCrystalNum(itemID) or 0
  elseif specialType == ESPECIALSKILLCOSTTYPE.ESPSCOSTTYPE_ROGUEITEM then
    return DungeonProxy.Instance:GetRoguelikeItemNumByStaticId(itemID)
  elseif specialType == ESPECIALSKILLCOSTTYPE.ESPSCOSTTYPE_TWELVEPVP then
    return TwelvePvPProxy.Instance:GetRaidItemNum(itemID)
  elseif specialType == ESPECIALSKILLCOSTTYPE.ESPSCOSTTYPE_BULLET then
    return MyselfProxy.Instance:GetCurBullets()
  else
    return BagProxy.Instance:GetItemNumByStaticID(itemID)
  end
end

function SkillProxy:GetLearnedSkillLevelBySortID(sortID)
  local skills = self.learnedSkills[sortID]
  if skills and 0 < #skills then
    return skills[1].level
  end
  return 0
end

function SkillProxy:GetLearnedSkills()
  return self.learnedSkills
end

function SkillProxy:HasAttackSkill(skills)
  local hasAttackTypeSkill
  for k, skillData in pairs(skills) do
    if skillData and skillData.staticData then
      local config = Table_SkillMould[skillData.sortID * 1000 + 1]
      if config and config.Atktype and config.Atktype == 1 then
        hasAttackTypeSkill = true
        break
      end
    end
  end
  return hasAttackTypeSkill
end

function SkillProxy:GetTransformedSkills()
  if self.dynamicTransformedSkills then
    return self.dynamicTransformedSkills:GetSkills()
  end
  return self.equipedTransformSkills
end

function SkillProxy:UpdateTransformedSkills(update, del, clear)
  local data
  if update and 0 < #update then
    if self.dynamicTransformedSkills == nil then
      self.dynamicTransformedSkills = TransformedEquipSkills.new("pos")
    end
    self.dynamicTransformedSkills:RefreshServerSkills(update)
  elseif self.dynamicTransformedSkills then
    self.dynamicTransformedSkills:RefreshServerSkills({})
  end
  if clear then
    self.dynamicTransformedSkills = nil
  end
end

function SkillProxy:ResetTransformSkills(monsterID)
  if monsterID == 0 then
    if self.equipedTransformSkills then
      for i = 1, #self.equipedTransformSkills do
        self:RemoveLearnedSkill(self.equipedTransformSkills[i])
      end
    end
    self.equipedTransformSkills = nil
    self:UpdateTransformedSkills(nil, nil, true)
  else
    local monster = Table_Monster[monsterID]
    if monster then
      self.equipedTransformSkills = {}
      local skills = monster.Transform_Skill
      for i = 1, #skills do
        local skill = SkillItemData.new(skills[i], i, 0, 0, 0)
        self.equipedTransformSkills[#self.equipedTransformSkills + 1] = skill
        self:LearnedSkill(skill)
      end
    end
  end
end

function SkillProxy:GetAutoBattleSkills()
  if self.equipedTransformSkills ~= nil and #self.equipedTransformSkills > 0 then
    return self.equipedTransformSkills
  end
  return self:GetEquipedAutoSkillData()
end

local _removeDuplicates = {}

function SkillProxy:GetAutoBattleSkillsWithCombo()
  if self.equipedTransformSkills ~= nil and #self.equipedTransformSkills > 0 then
    return self.equipedTransformSkills
  end
  local array = self.equipedSkillsArrays[SkillProxy.AutoSkillsWithComboIndex]
  if self.equipedAutoArrayDirty then
    self.equipedAutoArrayDirty = false
    TableUtility.ArrayClear(array)
    TableUtility.TableClear(_removeDuplicates)
    local shortCutAuto = ShortCutProxy.Instance:GetCurrentAuto()
    local rawAutos = self:GetEquipedAutoSkillData(false, shortCutAuto)
    local skill, sortID, comboPrevious
    if GameConfig.AutoSkillGroup then
      for k, v in pairs(GameConfig.AutoSkillGroup) do
        local duplicateCount = 0
        if 1 < #v then
          for i = #v, 1, -1 do
            skill = self:GetLearnedSkillBySortID(v[i])
            if skill and 0 < skill:GetPosInShortCutGroup(shortCutAuto) then
              duplicateCount = duplicateCount + 1
              if 1 < duplicateCount then
                _removeDuplicates[skill:GetPosInShortCutGroup(shortCutAuto)] = 1
              end
            end
          end
        end
      end
    end
    for i = #rawAutos, 1, -1 do
      skill = rawAutos[i]
      if _removeDuplicates[skill:GetPosInShortCutGroup(shortCutAuto)] == nil then
        self:_RecursiveGetComboPrevious(array, skill)
      end
    end
  end
  return array
end

function SkillProxy:_RecursiveGetComboPrevious(array, skill)
  if skill ~= nil then
    comboPrevious = self.comboGetPrevious[skill.sortID]
    local skillType = skill.staticData.SkillType
    if not GameConfig.SkillType[skillType].isPassive and skillType ~= SkillType.FakeDead and skillType ~= SkillType.Ghost then
      table.insert(array, 1, skill)
    end
    if comboPrevious ~= nil then
      skill = self:GetLearnedSkillBySortID(comboPrevious)
      while skill == nil and comboPrevious ~= nil do
        comboPrevious = self.comboGetPrevious[comboPrevious]
        skill = self:GetLearnedSkillBySortID(comboPrevious)
      end
      self:_RecursiveGetComboPrevious(array, skill)
    end
  end
end

function SkillProxy:GetTransformedSkill(id)
  local skills = self:GetTransformedSkills()
  if skills ~= nil and 0 < #skills then
    for i = 1, #skills do
      if skills[i].id == id then
        return skills[i]
      end
    end
  end
end

function SkillProxy:RefreshSkills()
  if self.learnedSkills then
    for k, skills in pairs(self.learnedSkills) do
      for i = 1, #skills do
        SkillUtils.RefreshPlayerSkillData(skills[i].id)
      end
    end
  end
end

function SkillProxy:LearnedExpressionBlink()
  return self:HasLearnedSkill(GameConfig.Expression_Blink.needskill)
end

function SkillProxy:Server_UpdateDynamicSkillInfos(serverData)
  if serverData.all then
    TableUtility.TableClear(self.dynamicSkillInfos)
  end
  local dynamicServerData, dynamicData
  for i = 1, #serverData.specinfo do
    dynamicServerData = serverData.specinfo[i]
    dynamicData = self.dynamicSkillInfos[dynamicServerData.id]
    if dynamicData == nil then
      dynamicData = SkillDynamicInfo.new()
      self.dynamicSkillInfos[dynamicServerData.id] = dynamicData
    end
    local skill = self:GetLearnedSkillBySortID(dynamicServerData.id)
    dynamicData:SetServerInfo(dynamicServerData)
    local skillMaxCount = skill and skill:GetMaxCDTimes() or 0
    if dynamicServerData.cd_times and 1 < skillMaxCount then
      self:InitSkillLeftCD(dynamicServerData.id, skill:GetMaxCDTimes(Game.Myself))
      GameFacade.Instance:sendNotification(SkillEvent.UpdateCDTimes, dynamicServerData.id)
    end
    if skill and self:_CheckPosInShortCut(skill) then
      EventManager.Me():PassEvent(SkillEvent.SkillFitPreCondtion, skill)
    end
  end
  if self.dynamicAllSkillInfo == nil then
    self.dynamicAllSkillInfo = SkillDynamicInfo.new()
  end
  self.dynamicAllSkillInfo:SetServerInfo(serverData.allskillInfo)
end

function SkillProxy:GetDynamicSkillInfoByID(skillID)
  local sortID = math.floor(skillID / 1000)
  return self.dynamicSkillInfos[sortID]
end

function SkillProxy:GetDynamicAllSkillInfo()
  return self.dynamicAllSkillInfo
end

function SkillProxy:GetSkillCanBreak()
  local _MyselfProxy = MyselfProxy.Instance
  if _MyselfProxy:HasJobBreak() then
    local point = _MyselfProxy:GetMyProfessionSpecial() and GameConfig.Peak.SuperNoviceSkillPointToBreak or GameConfig.Peak.SkillPointToBreak
    return point <= self:GetThirdUsedPoints()
  end
  return false
end

function SkillProxy:GetSkillCanExtra()
  local config = GameConfig.ExtraSkill
  local point = config.point[MyselfProxy.Instance:GetMyProfessionTypeBranch()] or config.defaultPoint
  return point <= self:GetThirdUsedPoints()
end

function SkillProxy:SetMultiSave(multiSaveId, multiSaveType)
  self.multiSaveId = multiSaveId
  self.multiSaveType = multiSaveType
end

function SkillProxy:GetMultiSave()
  return self.multiSaveId, self.multiSaveType
end

function SkillProxy:IsMultiSave()
  return self.multiSaveId ~= nil
end

function SkillProxy:GetMyProfession()
  if self.multiSaveId ~= nil then
    local profession = SaveInfoProxy.Instance:GetProfession(self.multiSaveId, self.multiSaveType)
    if profession ~= nil then
      return profession
    end
  end
  return MyselfProxy.Instance:GetMyProfession()
end

function SkillProxy:GetBeingNpcInfo(beingid)
  if beingid == nil then
    return nil
  end
  if self.multiSaveId == nil then
    return PetProxy.Instance:GetMyBeingNpcInfo(beingid)
  else
    return SaveInfoProxy.Instance:GetBeingInfo(self.multiSaveId, beingid, self.multiSaveType)
  end
end

function SkillProxy:CanMagicSkillUse(skillItem)
  if skillItem == nil then
    return false
  end
  if skillItem:IsAllSuperUse() then
    return true
  end
  if skillItem:IsMagicType() and Game.Myself.data:NoMagicSkill() then
    return false
  end
  return true
end

function SkillProxy:CanPhySkillUse(skillItem)
  if skillItem == nil then
    return false
  end
  if skillItem:IsAllSuperUse() then
    return true
  end
  if skillItem:IsPhyType() and Game.Myself.data:NoPhySkill() then
    return false
  end
  return true
end

function SkillProxy:GetSubSkillParam(staticData, totalParam, getParamFunc, funcParam)
  if staticData == nil or getParamFunc == nil then
    return
  end
  if staticData.Logic_Param.sub_skill_count == nil then
    return
  end
  local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, staticData.id)
  if subSkillList == nil then
    return
  end
  for i = 1, #subSkillList do
    totalParam = getParamFunc(subSkillList[i], funcParam, totalParam)
  end
  return totalParam
end

function SkillProxy:GetOriginSP(staticData)
  local sp = staticData.SkillCost.sp
  local subSkillSp = self:GetSubSkillParam(staticData, 0, GetSubSkillOriginSP)
  if subSkillSp ~= nil and subSkillSp ~= 0 then
    if sp ~= nil then
      sp = sp + subSkillSp
    else
      sp = subSkillSp
    end
  end
  return sp
end

function SkillProxy:GetSP(skillInfo, creature)
  local sp = skillInfo:GetSP(creature)
  local subSkillSp = self:GetSubSkillParam(skillInfo.staticData, 0, GetSubSkillSP, creature)
  if subSkillSp ~= nil and subSkillSp ~= 0 then
    if sp ~= nil then
      sp = sp + subSkillSp
    else
      sp = subSkillSp
    end
  end
  return sp
end

local specialCost = {}

function SkillProxy:GetOriginSpecialCost(staticData)
  if staticData.Logic_Param.sub_skill_count == nil then
    return staticData.SkillCost
  end
  for i = #specialCost, 1, -1 do
    ReusableTable.DestroyAndClearTable(specialCost[i])
    specialCost[i] = nil
  end
  GetSubSkillSpecialCost(staticData.id, nil, specialCost)
  self:GetSubSkillParam(staticData, specialCost, GetSubSkillSpecialCost)
  return specialCost
end

function SkillProxy.GetSkillCostItemId(skillId)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillId)
  if not skillInfo then
    return nil
  end
  local skillCost = SkillProxy.Instance:GetOriginSpecialCost(skillInfo.staticData)
  if not skillCost or not next(skillCost) then
    return nil
  end
  local itemCost
  for i = 1, #skillCost do
    itemCost = skillCost[i]
    if itemCost.itemID then
      return itemCost.itemID
    end
  end
  return nil
end

function SkillProxy:GetCastSubSkillID(creature, staticData)
  if staticData == nil or staticData.Logic_Param.sub_skill_count == nil then
    return
  end
  local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, staticData.id)
  if subSkillList == nil then
    return
  end
  local maxTime = 0
  local maxSkillID, data, time
  local _GetCastTime = SkillInfo.GetCastTime
  for i = 1, #subSkillList do
    data = Table_Skill[subSkillList[i]]
    if data ~= nil then
      time = _GetCastTime(creature, data)
      if maxTime < time then
        maxTime = time
        maxSkillID = subSkillList[i]
      end
    end
  end
  return maxSkillID
end

function SkillProxy:HaveAlreadyGetFourthSkillFullAward()
  return self.alreadyGetFourthSkillReward ~= false
end

function SkillProxy:RandomSkill(msg)
  if self.randomSkillID == nil then
    return false
  end
  if msg ~= nil then
    MsgManager.ShowMsgByID(msg)
  end
  ServiceSkillProxy.Instance:CallMaskSkillRandomOneSkillCmd()
  return true
end

function SkillProxy:SetRandomSkillID(id)
  self.randomSkillID = id ~= 0 and id or nil
  if self.randomSkillID == nil then
    if self.randomSkills ~= nil then
      TableUtility.TableClear(self.randomSkills)
    end
  else
    Game.AutoBattleManager:AutoBattleOff()
  end
end

function SkillProxy:GetRandomSkillID()
  return self.randomSkillID
end

function SkillProxy:GetRandomSkills()
  self.randomSkills = self.randomSkills or {}
  TableUtility.TableClear(self.randomSkills)
  local randomSkillID = self.randomSkillID
  if randomSkillID ~= nil then
    local skillItemData = self:GetLearnedSkill(randomSkillID)
    if skillItemData ~= nil then
      for i = 1, ShortCutData.CONFIGSKILLNUM do
        self.randomSkills[i] = skillItemData
      end
    end
  end
  return self.randomSkills
end

function SkillProxy:SetEquipedAutoArrayDirty(b)
  self.equipedAutoArrayDirty = b
end

function SkillProxy:GetCurrentEquipedAutoSkills()
  local shortCutAuto = ShortCutProxy.Instance:GetCurrentAuto()
  return self.equipedAutoSkills[shortCutAuto]
end

function SkillProxy:NoBulletConsumeAdd(buffeffect)
  self:Client_SetNoItem(true, buffeffect.skillids)
  EventManager.Me():PassEvent(MyselfEvent.CurBulletsChange, ncreature)
end

function SkillProxy:Client_SetNoItem(value, skillids)
  local skillid = 0
  local dynamicData
  for i = 1, #skillids do
    skillid = skillids[i]
    dynamicData = self.dynamicSkillInfos[skillid]
    if not dynamicData then
      dynamicData = SkillDynamicInfo.new()
      self.dynamicSkillInfos[skillid] = dynamicData
    end
    dynamicData:Client_SetNoItem(value)
    local skill = self:GetLearnedSkillBySortID(skillid)
    if skill and self:_CheckPosInShortCut(skill) then
      EventManager.Me():PassEvent(SkillEvent.SkillFitPreCondtion, skill)
    end
  end
end

function SkillProxy:NoBulletConsumeRemove(buffeffect)
  self:Client_SetNoItem(false, buffeffect.skillids)
  EventManager.Me():PassEvent(MyselfEvent.CurBulletsChange, ncreature)
end

function SkillProxy:SetLastSkillTime(time)
  self.lastSkillTime = time
end

function SkillProxy:GetLastSkillTime(time)
  return self.lastSkillTime
end

function SkillProxy:GetSkillLeftCD(sortID)
  return self.skillLeftCDMap[sortID]
end

function SkillProxy:ClearSkillLeftCDMap()
  self.skillLeftCDMap = {}
end

function SkillProxy:InitSkillLeftCD(sortID, time)
  if self.skillLeftCDMap[sortID] and CDProxy.Instance:GetSkillInCD(sortID) then
    return
  end
  self.skillLeftCDMap[sortID] = time
  self.skillLeftCD_DirtyMap[sortID] = true
end

function SkillProxy:UpdateSkillLeftCD(sortID, time, force)
  if not self.skillLeftCD_DirtyMap[sortID] and not force then
    return
  end
  self.skillLeftCD_DirtyMap[sortID] = nil
  self.skillLeftCDMap[sortID] = time
  return true
end

function SkillProxy:UseLeftCDTimes(sortID)
  if self.skillLeftCDMap[sortID] then
    self.skillLeftCDMap[sortID] = self.skillLeftCDMap[sortID] - 1
  end
end

function SkillProxy:AddLeftCDTimes(sortID)
  if self.skillLeftCDMap[sortID] then
    self.skillLeftCDMap[sortID] = self.skillLeftCDMap[sortID] + 1
  end
end

function SkillProxy:RecvMarkSunMoonSkillCmd(datas)
  if datas then
    TableUtility.TableClear(self.skillMarkMap)
    local sunmark, epro, npcid
    for i = 1, #datas do
      sunmark = datas[i].sunmark
      epro = datas[i].epro
      npcid = datas[i].npcid
      if sunmark == true then
        if not self.skillMarkMap[1] then
          self.skillMarkMap[1] = {}
        end
        local list = self.skillMarkMap[1] or {}
        local data = {}
        data.sunmark = sunmark
        data.epro = epro
        data.npcid = npcid
        table.insert(list, data)
        self.skillMarkMap[1] = list
      elseif sunmark == false then
        if not self.skillMarkMap[2] then
          self.skillMarkMap[2] = {}
        end
        local list = self.skillMarkMap[2] or {}
        local data = {}
        data.sunmark = sunmark
        data.epro = epro
        data.npcid = npcid
        table.insert(list, data)
        self.skillMarkMap[2] = list
      end
    end
  end
end

function SkillProxy:GetSkillMark(marktype)
  if not marktype then
    return nil
  end
  return self.skillMarkMap[marktype]
end

function SkillProxy:RecvTimeDiskSkillCmd(data)
  local myself = Game.Myself
  self.timeDiskInfo:SetData(data)
  if data.move == TIMEDISKMOVE_DEL then
    myself:ShutDownTimeDisk()
    myself:RemoveTimeDisk()
  else
    myself:LaunchTimeDisk()
    myself:SetTimeDisktInfo(myself)
  end
end

function SkillProxy:GetTimeDiskInfo()
  return self.timeDiskInfo
end

function SkillProxy:GetTimeDiskGrid(isSkipZone)
  return self.timeDiskInfo:GetCurGrid(isSkipZone)
end

function SkillProxy:SetSkillInForgetTime(skillID, duration)
  if not Game.Myself.data.startForgetting then
    return
  end
  if not self.forgetMap then
    self.forgetMap = {}
  end
  self.forgetMap[skillID] = _CurServerTime() // 1000 + (duration or 0)
end

function SkillProxy:SkillInForgetTime(skillID)
  if Game.Myself.data.forceForgetSkill then
    return 99
  end
  if not self.forgetMap then
    return -1
  end
  local time = self.forgetMap[skillID] or 0
  return time - _CurServerTime() // 1000
end

function SkillProxy:ClearForgetMap()
  if not self.forgetMap then
    return
  end
  TableUtility.TableClear(self.forgetMap)
end

function SkillProxy:AddQuestSkill(skillId)
  local data = SkillItemData.new(skillId, 0, 0, 0, 0)
  data.learned = true
  if not self:HasLearnedSkill(skillId) then
    self:LearnedSkill(data)
  end
  table.insert(self.questSkillMap, data)
end

function SkillProxy:RemoveQuestSkill(skillId)
  local sData = self:GetLearnedSkill(skillId)
  if sData then
    self:RemoveLearnedSkill(sData)
  end
  for i = 1, #self.questSkillMap do
    local single = self.questSkillMap[i]
    if single.id == skillId then
      table.remove(self.questSkillMap, i)
      break
    end
  end
end

function SkillProxy:GetQuestSkills()
  return self.questSkillMap
end

function SkillProxy:ClearQuestSkills()
  for _, data in pairs(self.questSkillMap) do
    sData = self:GetLearnedSkill(data.id)
    if sData then
      self:RemoveLearnedSkill(sData)
    end
  end
  TableUtility.TableClear(self.questSkillMap)
end

function SkillProxy:GetProfessDatasByDepth(classID, depth)
  local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(classID)
  local professes = {}
  if professTree then
    local p = professTree.transferRoot
    local typeBranch = Table_Class[classID].TypeBranch
    while p ~= nil do
      local ps = self:FindProfessSkill(p.id, true)
      professes[#professes + 1] = ps
      if depth <= p.depth then
        break
      end
      p = p:GetNextByBranch(typeBranch)
    end
  else
    professes[#professes + 1] = self:FindProfessSkill(classID, true)
  end
  return professes
end

function SkillProxy:SetMarkPoint(sortID, x, y, z)
  if not self.markPoint then
    self.markPoint = LuaVector3.New(0, 0, 0)
  end
  LuaVector3.Better_Set(self.markPoint, x or 0, y or 0, z or 0)
end

function SkillProxy:GetMarkPoint(sortID)
  return self.markPoint
end

function SkillProxy:SetReplaceMap(skillID, replaceID)
  if not self.replaceMap then
    self.replaceMap = {}
  end
  self.replaceMap[replaceID] = skillID
end

function SkillProxy:CheckReplaceMap(replacedID)
  if not self.replaceMap then
    return true
  end
  local skillID = self.replaceMap[replacedID]
  if not skillID or skillID == 0 then
    return true
  end
  local learnedSkill = self:GetLearnedSkill(skillID)
  return learnedSkill and learnedSkill:GetReplaceID() // 1000 == replacedID // 1000
end

function SkillProxy:RecvUseSkillSuccessSync(data)
  self.lastUseSkillBigID = (data.skillid or 0) // 1000
end

function SkillProxy:GetLastUseSkillBigID()
  return self.lastUseSkillBigID
end

function SkillProxy:SetBalanceModeChooseMess(data)
  local atk_id = data and data.extraction_atk_id or 0
  local def_id = data and data.extraction_def_id or 0
  local artifact_id = data and data.personal_artifact_id or 0
  self.balancedModeSkill = {
    atk_id,
    def_id,
    artifact_id
  }
end

function SkillProxy:GetBalanceModeChooseMess()
  return self.balancedModeSkill
end

function SkillProxy:CallBalanceModeChooseMess(atk_id, def_id, artifact_id)
  xdlog(string.format("火力全开选择  攻击萃取：%s  防御萃取：%s 遗物：%s", atk_id or self.balancedModeSkill[1], def_id or self.balancedModeSkill[2], artifact_id or self.balancedModeSkill[3]))
  ServiceMessCCmdProxy.Instance:CallBalanceModeChooseMessCCmd(atk_id or self.balancedModeSkill[1], def_id or self.balancedModeSkill[2], artifact_id or self.balancedModeSkill[3])
end

function SkillProxy:UpdateMasterSkill(data)
  if self.masterProfessData then
    local pro = self:GetMyProfession()
    self:AddExtraMasterSkills(pro, data.unlock_skill_index)
    self:UpdateMasterProfessData(data.add_ids, data.del_ids, data.updates)
  end
end

function SkillProxy:UpdateMasterProfessData(add_ids, del_ids, updates)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
  if del_ids then
    for i = 1, #del_ids do
      local del = del_ids[i]
      if self.masterProfessData then
        local skill = self.masterProfessData:RemoveMasterSkill(del)
        if skill then
          self:RemoveEquipSkill(skill)
          self:RemoveEquipSkill(skill, shortCutAuto)
          self:RemoveEquipSkill(skill, shortCutAuto2)
          self:RemoveLearnedSkill(skill)
        end
      end
    end
  end
  if add_ids then
    local familyIds = self.masterProfessData:GetEquipMasterSkillGroupIds(self.equipMasterSkillFamilyId)
    for i = 1, #add_ids do
      local add = add_ids[i]
      if self.masterProfessData then
        local skill = self.masterProfessData:AddMasterSkill(add, true)
        if skill.sortID == self.equipMasterSkillFamilyId then
          skill:UpdateShortcuts(self.masterSkillShortcuts)
          self:UpdateEquipSkill(skill)
          self:LearnedSkill(skill)
        elseif familyIds and TableUtility.ArrayFindIndex(familyIds, skill.sortID) > 0 then
          self:LearnedSkill(skill)
        end
      end
    end
  end
  if updates then
    for i = 1, #updates do
      if self.masterProfessData then
        self.masterProfessData:UpdateMasterSkill(updates[i])
      end
    end
  end
  if self.masterProfessData then
    self.masterProfessData:SortSkills()
    self.masterProfessData:UpdateMasterSkillPoints()
    self.masterProfessData:UpdateSkillActive()
  end
end

function SkillProxy:UpdateMasterSkillShortcuts(equip_skill_family_id, shortcuts)
  local familyId = equip_skill_family_id
  if self.masterProfessData then
    if familyId ~= self.equipMasterSkillFamilyId then
      local oldSkill = self.masterProfessData:FindSkillByFamilyId(self.equipMasterSkillFamilyId)
      if oldSkill then
        oldSkill:UpdateShortcuts({})
        self:UpdateEquipSkill(oldSkill)
        self:RemoveLearnedSkill(oldSkill)
        local familyIds = self.masterProfessData:GetEquipMasterSkillGroupIds(self.equipMasterSkillFamilyId)
        if familyIds then
          for i = 1, #familyIds do
            local s = self.masterProfessData:FindSkillByFamilyId(familyIds[i])
            self:RemoveLearnedSkill(s)
          end
        end
      end
      self.equipMasterSkillFamilyId = familyId
    end
    local skill = self.masterProfessData:FindSkillByFamilyId(familyId)
    if skill then
      if shortcuts then
        TableUtility.ArrayClear(self.masterSkillShortcuts)
        for i = 1, #shortcuts do
          local shortcut = shortcuts[i]
          local data = {}
          data.type = shortcut.type
          data.pos = shortcut.pos
          self.masterSkillShortcuts[i] = data
        end
      end
      skill:UpdateShortcuts(shortcuts)
      self:UpdateEquipSkill(skill)
      local familyIds = self.masterProfessData:GetEquipMasterSkillGroupIds(familyId)
      if familyIds then
        for i = 1, #familyIds do
          local s = self.masterProfessData:FindSkillByFamilyId(familyIds[i])
          if s.learned then
            self:LearnedSkill(s)
          end
        end
      end
    end
    self.masterProfessData:UpdateMasterSkillPoints()
  end
end

function SkillProxy:UpdateEquipSkill(skillItemData)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
  if self:_CheckPosInShortCut(skillItemData) then
    self:AddEquipSkill(skillItemData)
  else
    self:RemoveEquipSkill(skillItemData)
  end
  if skillItemData:GetPosInShortCutGroup(shortCutAuto) > 0 then
    self:AddEquipSkill(skillItemData, shortCutAuto)
  else
    self:RemoveEquipSkill(skillItemData, shortCutAuto)
  end
  if skillItemData:GetPosInShortCutGroup(shortCutAuto2) > 0 then
    self:AddEquipSkill(skillItemData, shortCutAuto2)
  else
    self:RemoveEquipSkill(skillItemData, shortCutAuto2)
  end
end

function SkillProxy:GetMasterSkillProfessData()
  local pro = self:GetMyProfession()
  if self.multiSaveId then
    return SaveInfoProxy.Instance:GetMasterSkillProfessData(self.multiSaveId, self.multiSaveType)
  else
    if not self.masterProfessData or self.masterProfessData.profession ~= pro then
      self:CreateMasterSkillProfessData(pro)
    end
    return self.masterProfessData
  end
end

function SkillProxy:CreateMasterSkillProfessData(myProfess, unlockSkillIndex)
  self:ClearMasterSkillProfessData()
  local config = Table_Class[myProfess]
  if config then
    if config.MasterSkills and config.MasterSkills ~= _EmptyTable then
      self.masterProfessData = MasterSkillProfessData.new(myProfess, 0, true)
      for i = 1, #config.MasterSkills do
        local skillIds = config.MasterSkills[i]
        for j = 1, #skillIds do
          self.masterProfessData:AddMasterSkill(skillIds[j], nil, i)
        end
      end
    end
    self:AddExtraMasterSkills(myProfess, unlockSkillIndex)
    if self.masterProfessData then
      self.masterProfessData:SortSkills()
    end
  end
end

function SkillProxy:ClearMasterSkillProfessData()
  self.masterProfessData = nil
  self.equipMasterSkillFamilyId = nil
end

function SkillProxy:AddExtraMasterSkills(pro, unlockSkillIndex)
  local config = Table_Class[pro]
  if config and unlockSkillIndex and config.LimitMasterSkills and config.LimitMasterSkills ~= _EmptyTable then
    if not self.masterProfessData then
      self.masterProfessData = MasterSkillProfessData.new(pro, 0, true)
    end
    self.masterProfessData:SetUnlockLimitSkillIndex(unlockSkillIndex)
    for i = 1, #unlockSkillIndex do
      redlog("AddExtraMasterSkills unlockSkillIndex", unlockSkillIndex[i])
      local skillIds = config.LimitMasterSkills[unlockSkillIndex[i]]
      if skillIds then
        for j = 1, #skillIds do
          self.masterProfessData:AddExtraMasterSkill(skillIds[j], nil, unlockSkillIndex[i])
        end
      end
    end
  end
end

function SkillProxy:GetEquipMasterSkillFamilyId()
  return self.multiSaveId and SaveInfoProxy.Instance:GetEquipMasterSkillFamilyId(self.multiSaveId, self.multiSaveType) or self.equipMasterSkillFamilyId
end

function SkillProxy:RecvSkillWeatherSyncCmd(skillweather)
  self.weather = skillweather
end

function SkillProxy:GetSkillWeather()
  return self.weather
end

function SkillProxy:IsMasterSkillEquiped(skillId)
  local familyId = skillId // 1000
  local masterProfessData = self:GetMasterSkillProfessData()
  local equipMasterSkillFamilyId = self:GetEquipMasterSkillFamilyId()
  local ids = masterProfessData and masterProfessData:GetEquipMasterSkillGroupIds(equipMasterSkillFamilyId)
  if ids then
    return TableUtility.ArrayFindIndex(ids, familyId) > 0
  end
  return false
end

function SkillProxy:GetMasterSkillGroupIndexByFamilyId(familyId)
  local masterSkillProfessData = self:GetMasterSkillProfessData()
  return masterSkillProfessData and masterSkillProfessData:GetSkillGroupIndexByFamilyId(familyId) or 0
end

function SkillProxy:SyncBlockMasterSkill(block_skills)
  TableUtility.TableClear(self.blockMasterSkills)
  for i = 1, #block_skills do
    local info = block_skills[i]
    local pro = info.profession
    self.blockMasterSkills[pro] = {
      masterSkillIndex = {},
      limitMasterSkillIndex = {}
    }
    for j = 1, #info.master_skill_index do
      TableUtility.ArrayPushBack(self.blockMasterSkills[pro].masterSkillIndex, info.master_skill_index[j])
    end
    for j = 1, #info.limit_master_skill_index do
      TableUtility.ArrayPushBack(self.blockMasterSkills[pro].limitMasterSkillIndex, info.limit_master_skill_index[j])
    end
  end
  self:SetBlockMasterSkill()
end

function SkillProxy:SetBlockMasterSkill()
  if self.masterProfessData then
    self.masterProfessData:SetBlockMasterSkill(self:GetBlockMasterSkillIndex(self.masterProfessData.profession))
  end
end

function SkillProxy:GetBlockMasterSkillIndex(pro)
  local info = self.blockMasterSkills[pro]
  if info then
    return info.masterSkillIndex, info.limitMasterSkillIndex
  end
end
