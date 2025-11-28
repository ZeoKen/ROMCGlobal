autoImport("SkillProfessData")
SkillItemData = class("SkillItemData")
SkillItemData.ForbidUse = {
  GVG = 1,
  TeamPws = 4,
  NotInTeamPws = 8,
  PvpZone = 16,
  Roguelike = 32,
  TwelvePVP = 128,
  Puzzle = 512,
  ComodoRaid = 1024,
  PveMode_Arena = 2048,
  PveMode_Crack = 4096,
  PveMode_BossScene = 8192
}
SkillItemData.FuncType = {
  Normal = 1,
  Rune = 2,
  Option = 3
}
SkillItemData.ConditionSkillCount = 5
SkillItemData.Empty = "SkillItemData_Empty"

function SkillItemData:ctor(id, pos, autopos, profession, sourceId, extendpos, shortcuts, extramaxlv, ignoreCondition, skipLeftCD)
  self.shortcuts = {}
  self:Reset(id, pos, autopos, 0, sourceId, extendpos, shortcuts, extramaxlv, skipLeftCD)
  self.profession = profession
  self.isUnlock = false
  self.classId = 0
  self.leftTimes = 0
  self.maxTimes = 0
  self.cdTime = 0
  self.timeRecoveryStamp = 0
  self.active = false
  self.learned = false
  self.shadow = false
  self.fitPreCondion = true
  self.runeSpecialID = 0
  self.replaceID = 0
  self.enableSpecialEffect = true
  self.extraLevelSkillID = 0
  self.isShare = false
  self.isNotMyselfSkill = false
  self.ignoreCondition = ignoreCondition
end

function SkillItemData:Reset(id, pos, autopos, cd, sourceId, extendpos, shortcuts, extramaxlv, skipLeftCD)
  if pos ~= nil then
    self.shortcuts[ShortCutProxy.ShortCutEnum.ID1] = pos
    self.pos = pos
  end
  if autopos ~= nil then
    self.shortcuts[ShortCutProxy.SkillShortCut.Auto] = autopos
  end
  sourceId = sourceId or 0
  self.sourceId = sourceId
  if self.id ~= id then
    self.requiredSkillID = nil
    self.nextSkillData = nil
    if self.requiredSkills then
      TableUtility.ArrayClear(self.requiredSkills)
    else
      self.requiredSkills = {}
    end
    self.id = id
    local ratio = self.id % 1000 > 99 and 100 or 1000
    self.requiredBaseID = math.floor(self.id / ratio)
    self.sortID = math.floor(self.id / 1000)
    self.staticData = Table_Skill[id]
    if self.staticData ~= nil then
      self.level = self.staticData.Level
      if self.staticData.NextID ~= nil then
        self.nextSkillData = Table_Skill[self.staticData.NextID]
      end
      local config = Table_Skill[self.requiredBaseID * ratio + 1]
      if config and config.Contidion and config.Contidion.skillid then
        self.requiredSkillID = config.Contidion.skillid
      end
      if config and config.Contidion and config.Contidion.skills then
        self.requiredSkills = {}
        TableUtility.ArrayShallowCopy(self.requiredSkills, config.Contidion.skills)
      end
    else
      self.level = 0
    end
    self.guid = self.id .. "_" .. self.sourceId
    self.preConditionMap = nil
  end
  self.extraMaxLevel = extramaxlv or 0
  local maxLevelStaticData
  if self.staticData ~= nil and self.staticData.NextID ~= nil then
    self.maxLevel, maxLevelStaticData = self:_GetMaxlevel("NextID")
  else
    self.maxLevel = self.level
    maxLevelStaticData = self.staticData
  end
  if maxLevelStaticData ~= nil and maxLevelStaticData.NextBreakID then
    self.breakMaxLevel, maxLevelStaticData = self:_GetMaxlevel("NextBreakID", maxLevelStaticData)
  else
    self.breakMaxLevel = 0
  end
  if maxLevelStaticData ~= nil and maxLevelStaticData.NextNewID then
    self.breakNewMaxLevel = self:_GetMaxlevel("NextNewID", maxLevelStaticData)
  else
    self.breakNewMaxLevel = 0
  end
  self:UpdateShortcuts(shortcuts)
  local maxCDTimes = self:GetMaxCDTimes()
  if not skipLeftCD and maxCDTimes and 0 < maxCDTimes then
    SkillProxy.Instance:InitSkillLeftCD(self.sortID, maxCDTimes)
  end
end

function SkillItemData:_GetMaxlevel(paramName, staticData)
  staticData = staticData or self.staticData
  if staticData and staticData[paramName] then
    local tempData = staticData
    local num = 0
    local tempDataID, nextID, nextData
    while tempData[paramName] ~= nil and num < 99 do
      tempDataID = tempData.id
      nextID = tempData[paramName]
      nextData = Table_Skill[nextID]
      if 98 <= num then
        error("检查技能表，NextID配置错误，导致死循环- -#.." .. staticData.id)
      end
      if nextData == nil then
        LogUtility.ErrorFormat("尝试查找 {0} 的下一个技能 {1},配置表中不存在", tempDataID, nextID)
        break
      end
      if nextData.ExtraMaxLevel and nextData.ExtraMaxLevel > self.extraMaxLevel then
        break
      end
      tempData = nextData
      num = num + 1
    end
    return tempData.Level, tempData
  end
end

function SkillItemData:Clone()
  local cloned = SkillItemData.new(self.id, self.pos, self.autopos, self.profession, self.sourceId, nil, nil, self.extraMaxLevel)
  cloned.learned = self.learned
  for k, v in pairs(self.shortcuts) do
    cloned.shortcuts[k] = v
  end
  return cloned
end

function SkillItemData:GetBreakLevel()
  if self.staticData then
    return self.staticData.PeakLevel or 0
  end
  return 0
end

function SkillItemData:ResetUseTimes(left, max, stamp)
  self.leftTimes = left
  self.maxTimes = max
  self.timeRecoveryStamp = stamp * 1000
end

function SkillItemData:SetFitPreCond(fitPreCondion)
  self.fitPreCondion = fitPreCondion
end

function SkillItemData:GetFitPreCond()
  return self.fitPreCondion
end

function SkillItemData:setId(id)
  self.id = id
end

function SkillItemData:GetID()
  local replaceID = self:GetReplaceID()
  if replaceID ~= nil and replaceID ~= 0 then
    return replaceID
  end
  if self:GetExtraStaticData() ~= nil then
    return self:GetExtraStaticData().id
  end
  return self.id
end

function SkillItemData:GetSortID()
  local replaceID = self:GetReplaceID()
  if replaceID ~= nil and replaceID ~= 0 then
    return math.floor(replaceID / 1000)
  end
  return self.sortID
end

function SkillItemData:GetStaticData()
  local replaceID = self:GetReplaceID()
  if replaceID ~= nil and replaceID ~= 0 then
    return Table_Skill[replaceID]
  end
  if self:GetExtraStaticData() ~= nil then
    return self:GetExtraStaticData()
  end
  return self.staticData
end

function SkillItemData:SetShadow(val)
  self.shadow = val
end

function SkillItemData:GetShadow()
  return self.shadow
end

function SkillItemData:SetActive(active)
  self.active = active
end

function SkillItemData:SetLearned(learned)
  self.learned = learned
end

function SkillItemData:SetSpecialID(runeSpecialID)
  self.runeSpecialID = runeSpecialID
end

function SkillItemData:GetSpecialID()
  return self.runeSpecialID
end

function SkillItemData:SetEnableSpecialEffect(v)
  self.enableSpecialEffect = v
end

function SkillItemData:GetEnableSpecialEffect()
  return self.enableSpecialEffect
end

function SkillItemData:SetReplaceID(replaceID)
  self.replaceID = replaceID
end

function SkillItemData:GetReplaceID()
  return self.replaceID
end

function SkillItemData:SetOriginalReplaceID(replaceID)
  self.originalReplaceID = replaceID
end

function SkillItemData:GetOriginalReplaceID()
  if not self.originalReplaceID or self.originalReplaceID == 0 then
    return self.id
  end
  return self.originalReplaceID
end

function SkillItemData:SetSource(source)
  self.source = source
end

function SkillItemData:setIsUnlock(isUnlock)
  self.isUnlock = isUnlock
end

function SkillItemData:getIsUnlock()
  return self.isUnlock
end

function SkillItemData:setLevel(level)
  self.level = level or 0
end

function SkillItemData:getLevel()
  return self.level
end

function SkillItemData:GetLevelWithExtra()
  return self.level + self:GetExtraLevel()
end

function SkillItemData:GetMaxLevelWithExtra()
  return self.maxLevel + self:GetExtraLevel()
end

function SkillItemData:setClassId(id)
  self.classId = id or 0
end

function SkillItemData:getClassId()
  return self.classId
end

function SkillItemData:getCdTime()
  return self.cdTime
end

function SkillItemData:GetCDMax()
  return self.cdMax
end

function SkillItemData:IsMagicType()
  return self.staticData.RollType == 2
end

function SkillItemData:IsPhyType()
  return self.staticData.RollType == 1
end

function SkillItemData:IsAutoShortCutLocked()
  local _ShortCutProxy = ShortCutProxy
  local currentAuto = _ShortCutProxy.Instance:GetCurrentAuto()
  return _ShortCutProxy.Instance:AutoSkillIsLocked(self:GetPosInShortCutGroup(currentAuto))
end

function SkillItemData:SetPosInShortCutGroup(grpID, pos)
  if grpID ~= nil and pos ~= nil then
    self.shortcuts[grpID] = pos
  end
end

function SkillItemData:GetPosInShortCutGroup(grpID)
  if grpID == ShortCutProxy.SkillShortCut.BeingAuto then
    return self.pos
  else
    return self.shortcuts[grpID] or 0
  end
end

function SkillItemData:HasRuneSpecials()
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.sortID)
  return specials ~= nil
end

function SkillItemData:HasRuneSelectSpecials()
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.sortID)
  if specials then
    for k, v in pairs(specials) do
      config = Table_RuneSpecial[k]
      if config and config.Type == 2 then
        return true
      end
    end
  end
  return false
end

function SkillItemData:GetRuneSelectSpecials()
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.sortID)
  local res
  if specials then
    for k, v in pairs(specials) do
      config = Table_RuneSpecial[k]
      if config and config.Type == 2 then
        if res == nil then
          res = {}
        end
        res[#res + 1] = config
      end
    end
  end
  return res
end

function SkillItemData:SetExtraLevel(lv)
  if lv ~= nil and lv ~= 0 then
    if self.staticData == nil then
      return
    end
    self.extraLevelSkillID = self.staticData.id + lv
    self.extraLevelSkillStaticData = Table_Skill[self.extraLevelSkillID]
  else
    self.extraLevelSkillID = 0
    self.extraLevelSkillStaticData = nil
  end
end

function SkillItemData:GetExtraLevel()
  return self.extraLevelSkillStaticData and self.extraLevelSkillStaticData.Level - self.level or 0
end

function SkillItemData:GetExtraStaticData()
  return self.extraLevelSkillStaticData
end

function SkillItemData:SuperUse_NoSkill()
  local staticData = self:GetStaticData()
  if staticData and staticData.SuperUse then
    return staticData.SuperUse & SkillSuperUse.NoSkill > 0
  end
  return false
end

function SkillItemData:GetSuperUse()
  local staticData = self:GetStaticData()
  if staticData and staticData.SuperUse then
    return staticData.SuperUse
  end
  return nil
end

function SkillItemData:HasNextID(breakTop, staticData, newBreakTop)
  return self:GetNextID(breakTop, nil, newBreakTop) ~= nil
end

function SkillItemData:GetNextID(breakTop, staticData, newBreakTop, skipCheck)
  staticData = staticData or self.staticData
  local nextID = staticData.NextID
  if breakTop and staticData.NextBreakID then
    nextID = staticData.NextBreakID
  end
  if newBreakTop and staticData.NextNewID then
    nextID = staticData.NextNewID
  end
  staticData = Table_Skill[nextID]
  if staticData and staticData.ExtraMaxLevel and staticData.ExtraMaxLevel > (self.extraMaxLevel or 0) and not skipCheck then
    nextID = nil
  end
  return nextID
end

function SkillItemData:SetOwnerId(ownerid)
  local staticData = self:GetStaticData()
  if staticData and staticData.Share == 1 then
    self.isShare = ownerid ~= Game.Myself.data.id
  end
end

function SkillItemData:GetIsShare()
  return self.isShare
end

function SkillItemData:CheckFuncOpen(funcType)
  if funcType == nil then
    return false
  end
  if funcType == self.FuncType.Normal then
    if self:GetID() == Game.Myself.data:GetAttackSkillIDAndLevel() and not self:IgnoreNormalTip() then
      return true
    end
    if self.id == GameConfig.SkillAutoQueueID[1] then
      return true
    end
    if SkillProxy.Instance:HasLearnedSkill(self.id) and self.id == GameConfig.SkillQuickRideID[1] then
      return true
    end
    local catSkillCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.CatSkillAutoCastID
    if self.learned and catSkillCfg and TableUtility.ArrayFindIndex(catSkillCfg, self.sortID) > 0 then
      return true
    end
    local funcCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.AutoLockBossID
    if SkillProxy.Instance:HasLearnedSkill(self.id) and funcCfg and self.id == funcCfg[1] then
      return true
    end
    local funcCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.AutoReload
    if SkillProxy.Instance:HasLearnedSkill(self.id) and funcCfg and self.id == funcCfg[1] then
      return true
    end
    local contractCfg = GameConfig.ChasmContract
    if contractCfg and SkillProxy.Instance:HasLearnedSkill(self.id) and self.sortID == math.floor(contractCfg[1] / 1000) then
      return true
    end
    local logicParam = self.staticData.Logic_Param
    if logicParam and self:_CheckOptionOpen(logicParam.select_buff_ids) and 1 < logicParam.select_num then
      return true
    end
    if logicParam.switchBuffs then
      return true
    end
    if logicParam.fake_normalAtk then
      return true
    end
    return false
  elseif funcType == self.FuncType.Rune then
    return self:GetRuneSelectSpecials() ~= nil
  elseif funcType == self.FuncType.Option then
    local logicParam = self.staticData.Logic_Param
    if logicParam then
      if self:_CheckOptionOpen(logicParam.being_ids) then
        return true
      end
      if self:_CheckOptionOpen(logicParam.skill_opt_ids) then
        return true
      end
      if self:_CheckOptionOpen(logicParam.element_ids) then
        return true
      end
      if self:_CheckOptionOpen(logicParam.select_buff_ids) and logicParam.select_num == 1 and self:_CheckOptionCondition(logicParam) then
        return true
      end
      if self.id == GameConfig.SkillFakeDead.ID then
        return true
      end
      if self:_CheckOptionOpen(logicParam.companion_skill_ids) then
        return true
      end
    end
    return false
  end
end

function SkillItemData:_CheckOptionOpen(param)
  if param ~= nil and 0 < #param then
    return SkillProxy.Instance:HasLearnedSkill(self.id)
  end
end

function SkillItemData:_CheckOptionCondition(logicParam)
  if logicParam ~= nil then
    local learnedSkill = logicParam.select_learned_skill
    if learnedSkill ~= nil then
      local _SkillProxy = SkillProxy.Instance
      for i = 1, #learnedSkill do
        if not _SkillProxy:HasLearnedSkillBySort(learnedSkill[i]) then
          return false
        end
      end
    end
  end
  return true
end

function SkillItemData:HasSubSkill()
  return self.staticData.Logic_Param.sub_skill_count ~= nil
end

function SkillItemData:GetSubSkillCount()
  return self.staticData.Logic_Param.sub_skill_count
end

function SkillItemData:CanSelectMount()
  return self.staticData.Logic_Param.select_mount ~= nil
end

function SkillItemData:GetPioneerSkill()
  return self.staticData.Logic_Param.select_pioneer_skill
end

function SkillItemData:GetNextFourthBreakData()
  local maxLevel, maxLevelStaticData = self:_GetMaxlevel("NextID")
  return maxLevelStaticData and maxLevelStaticData.NextID and Table_Skill[maxLevelStaticData.NextID]
end

function SkillItemData:GetReplaceSkill()
  return self.staticData.Logic_Param.select_replace_skill
end

function SkillItemData:GetUnlearnedPioneerSkill()
  return self.staticData.Logic_Param.select_pioneer_nolearnskill
end

function SkillItemData:GetPioneerSkillCount()
  return self.staticData.Logic_Param.PioneerSkillCount or 4
end

function SkillItemData:IsHideSkill()
  local logicParam = self.staticData.Logic_Param
  if logicParam then
    return logicParam.manual_hide == 1
  end
  return false
end

function SkillItemData:SetExpireTime(expiretime)
  self.expireTime = expiretime
end

function SkillItemData:SetUsedCount(usedcount)
  self.usedCount = usedcount
end

function SkillItemData:SetAllCount(allcount)
  self.allCount = allcount
end

function SkillItemData:SetNotMyselfSkill(notMySelfSkill)
  self.isNotMyselfSkill = notMySelfSkill
end

function SkillItemData:IsNotMyselfSkill()
  return self.isNotMyselfSkill == true
end

function SkillItemData:GetMaxCDTimes(creature)
  local extraTimes = 0
  if self.staticData then
    local dynamicSkillInfo = creature and creature.data:GetDynamicSkillInfo(self.staticData.id)
    if dynamicSkillInfo and dynamicSkillInfo.cd_times and 0 < dynamicSkillInfo.cd_times then
      extraTimes = dynamicSkillInfo.cd_times
    end
  end
  return (self.staticData and self.staticData.Logic_Param.CdTimes or 0) + extraTimes
end

function SkillItemData:GetLeftCDTimes()
  return SkillProxy.Instance:GetSkillLeftCD(self.sortID)
end

function SkillItemData:GetPreCondition()
  local activeSData = self:GetStaticData()
  return activeSData and activeSData.PreCondition
end

function SkillItemData:GetPrecondtionsByType(t)
  local activeSData = self:GetStaticData()
  if activeSData ~= self.staticData then
    if not self.tempPreConditions then
      self.tempPreConditions = {}
    else
      TableUtility.TableClear(self.tempPreConditions)
    end
    local aPreCondition = activeSData.PreCondition
    if aPreCondition then
      for i = 1, #aPreCondition do
        if t == aPreCondition[i].type then
          self.tempPreConditions[#self.tempPreConditions + 1] = aPreCondition[i]
        end
      end
    end
    return self.tempPreConditions
  end
  if self.preConditionMap then
    return self.preConditionMap[t]
  end
  self.preConditionMap = {}
  local preCondition = self.staticData.PreCondition
  if preCondition then
    local p, cachePs
    for i = 1, #preCondition do
      p = preCondition[i]
      cachePs = self.preConditionMap[p.type]
      if not cachePs then
        cachePs = {}
        self.preConditionMap[p.type] = cachePs
      end
      cachePs[#cachePs + 1] = p
    end
  end
  return self.preConditionMap[t]
end

function SkillItemData:CheckVertigoCount()
  return self.staticData.Logic_Param.heartlock_SKILLTYPE == 6
end

function SkillItemData:CheckAttach()
  return self.staticData.Logic_Param.heartlock_SKILLTYPE == 5
end

function SkillItemData:CheckDog()
  return self.staticData.Logic_Param.heartlock_SKILLTYPE == 7
end

function SkillItemData:IsHeroFeatureSkill()
  local skillFamilyId = math.floor(self.id / 1000)
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local professConfig = Table_Class[myProfess]
  local featureSkillId = professConfig and professConfig.FeatureSkill
  return skillFamilyId == featureSkillId
end

function SkillItemData:GetWaitComboTime()
  return self.staticData.Logic_Param.waitComboTime or 5
end

function SkillItemData:GetNextComboID()
  return self.staticData.Logic_Param.nextComboID
end

function SkillItemData:GetRollbackComboID()
  return self.staticData.Logic_Param.rollbackComboID
end

function SkillItemData:GetFinishComboID()
  return self.staticData.Logic_Param.finishComboID
end

function SkillItemData:GetComboConditionSkill()
  return self.staticData.Logic_Param.comboConditionSkill
end

function SkillItemData:GetRootID()
  if not self.staticData or not self.staticData.Logic_Param then
    return nil
  end
  return self.staticData.Logic_Param.rollbackComboID or self.staticData.Logic_Param.finishComboID or self.staticData.Logic_Param.finishReplaceComboID
end

function SkillItemData:GetAltIcon(creature)
  if not creature then
    return
  end
  if not self.staticData then
    return
  end
  local altIconConf = self.staticData.AltIcon
  if not altIconConf then
    return
  end
  local func = altIconConf.func
  local icons = altIconConf.icons
  if not icons or not func then
    return
  end
  if func == "mountform" then
    local mountForm = creature.data and creature.data:GetMountForm()
    if mountForm and 1 < mountForm then
      return icons[mountForm - 1]
    end
  end
end

function SkillItemData:SetForgetTime(time)
  self.forgetTime = time
end

function SkillItemData:GetSuperPositionSkill()
  return self.staticData.Logic_Param.select_superposition_skill
end

function SkillItemData:GetSuperPositionSkillCount()
  local staticCount = self.staticData.Logic_Param.superposition_skill_count + Game.Myself.data:GetBuff_SuperpositionCount()
  local skilllist = Game.SkillOptionManager:GetSuperPositionSkillList()
  local skillCount = skilllist and #skilllist or 0
  return staticCount > skillCount and staticCount or skillCount
end

function SkillItemData:NeedSwitchToggle()
  return self.staticData.Logic_Param.switchBuffs ~= nil
end

function SkillItemData:ReplaceSkillDesc()
  return self.staticData.Logic_Param.replace_skill_desc == 1
end

function SkillItemData:IsFakeNormalAtk()
  return self.staticData.Logic_Param.fake_normalAtk ~= nil
end

function SkillItemData:UseSelfCD()
  return self.staticData.Logic_Param.useSelfCD == 1
end

function SkillItemData:GetDelMultiTrapData()
  return Game.Myself.data:GetDelMultiTrapSkill(self.sortID)
end

function SkillItemData:GetDelMultiTrapDataCount()
  return Game.Myself.data:GetDelMultiTrapSkillCount(self.sortID)
end

function SkillItemData:IgnoreNormalTip()
  return self.staticData.Logic_Param.ignore_normalTip == 1
end

function SkillItemData:UpdateShortcuts(shortcuts)
  if shortcuts ~= nil then
    TableUtility.TableClear(self.shortcuts)
    for i = 1, #shortcuts do
      local shortcut = shortcuts[i]
      self.shortcuts[shortcut.type] = shortcut.pos
    end
  end
end

function SkillItemData:IsAllSuperUse()
  return self.staticData.Logic_Param.allSuperUse == 1
end

function SkillItemData:HasExtraOption()
  return self.staticData.Logic_Param.switchTeammate == 1
end
