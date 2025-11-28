FunctionSkillSimulate = class("FunctionSkillSimulate")
FunctionSkillSimulate.SimulateSkillPointChange = "FunctionSkillSimulate_SimulateSkillPointChange"
FunctionSkillSimulate.HasNoModifiedSkills = "FunctionSkillSimulate_HasNoModifiedSkills"
local ExtraSkillConfig = GameConfig.ExtraSkill

function FunctionSkillSimulate.Me()
  if nil == FunctionSkillSimulate.me then
    FunctionSkillSimulate.me = FunctionSkillSimulate.new()
  end
  return FunctionSkillSimulate.me
end

function FunctionSkillSimulate:ctor()
  self.skillList = {}
  self:Reset()
end

function FunctionSkillSimulate:Reset()
  self.skillCells = {}
  self.professDatas = {}
  self.modifiedSkillBySort = {}
  self.isIsSimulating = false
  self.totalPoints = 0
  self.initTotalPoints = 0
  self.masterSkillTotalPoints = 0
  self.masterSkillTotalCost = 0
  self.isPresetting = false
end

function FunctionSkillSimulate:CancelSimulate()
  self:Reset()
  SimulateSkillProxy.Instance:RollBack()
end

function FunctionSkillSimulate:End()
  self:Reset()
end

function FunctionSkillSimulate:GetModifiedSkills()
  TableUtility.TableClear(self.skillList)
  return TableUtil.HashToArray(self.modifiedSkillBySort, self.skillList)
end

function FunctionSkillSimulate:StartSimulate(skillCells, professDatas, totalPoints, masterSkillTotalPoints)
  if self.isIsSimulating then
    return
  end
  self.isIsSimulating = true
  SimulateSkillProxy.Instance:ReInit()
  local skill
  for i = 1, #skillCells do
    skill = skillCells[i]
    self.skillCells[skill.data.sortID] = skill
  end
  local profess
  if professDatas then
    for i = 1, #professDatas do
      profess = professDatas[i]
      if profess.data.isMaster then
        self.professDatas.master = profess
      else
        self.professDatas[profess.data.profession] = profess
      end
    end
  end
  self:SetNewTotalPoints(totalPoints)
  self.masterSkillTotalPoints = masterSkillTotalPoints or self.masterSkillTotalPoints
  self:ScallAllDatas()
end

function FunctionSkillSimulate:SetNewTotalPoints(totalPoints)
  if not self.isIsSimulating then
    return
  end
  if self.initTotalPoints == 0 then
    self.initTotalPoints = totalPoints
    self.totalPoints = totalPoints
  else
    local delta = totalPoints - self.initTotalPoints
    self.totalPoints = self.totalPoints + delta
    self.initTotalPoints = totalPoints
  end
end

function FunctionSkillSimulate:Upgrade(cell, preset)
  if not cell then
    return
  end
  if self:HasModifiedMasterSkill() then
    MsgManager.ShowMsgByIDTable(43582)
    return false
  end
  local simulateSkillProxy = SimulateSkillProxy.Instance
  local breakEnable = SkillProxy.Instance:GetSkillCanBreak()
  local simuateBreakEnable = simulateSkillProxy:GetSkillCanBreak()
  local canUsePoints = self.totalPoints
  if not self.isPresetting then
    if not breakEnable and simuateBreakEnable and not preset then
      canUsePoints = 0
      MsgManager.ShowMsgByIDTable(3432)
      return false
    end
  elseif canUsePoints == 0 then
    return
  end
  local extraEnable = SkillProxy.Instance:GetSkillCanExtra()
  local simulateExtraEnable = simulateSkillProxy:GetSkillCanExtra()
  local skillExtraPoint = simulateSkillProxy:GetExtraSkillPoint()
  if not extraEnable and simulateExtraEnable and not self.isPresetting then
    MsgManager.ShowMsgByID(31021)
    return false
  end
  local simulate, delta, lastSimulate, lastSimulateSkill
  simulate = simulateSkillProxy:GetSimulateSkill(cell.data.sortID)
  if preset then
    if cell.data.learned then
      delta = preset % 1000 - cell.data:getLevel()
    elseif cell.data.active then
      lastSimulate = self.modifiedSkillBySort[simulate.sortID]
      lastSimulateSkill = Table_Skill[lastSimulate]
      if lastSimulate and lastSimulateSkill then
        delta = preset % 1000 - lastSimulateSkill.Level
      else
        delta = preset % 1000
      end
    else
      delta = preset % 1000
    end
    delta = canUsePoints >= delta and delta or canUsePoints
    if skillExtraPoint < simulateSkillProxy.totalUsedPoint + delta then
      if cell.data.id ~= ExtraSkillConfig.skillid then
        redlog("策划配置技能点溢出", cell.data.id, "已用点数" .. simulateSkillProxy.totalUsedPoint .. "要求加" .. delta, skillExtraPoint)
        delta = skillExtraPoint - simulateSkillProxy.totalUsedPoint
      else
        delta = canUsePoints
      end
    end
  end
  local fitCost = simulate:FitNextSkillPointCost(canUsePoints)
  if fitCost then
    local myJobLevel = MyselfProxy.Instance:JobLevel()
    local fitJobLv, needJobLv = simulate:FitNextJobLevel(myJobLevel)
    if fitJobLv then
      local upgradeSuccess, points = simulateSkillProxy:UpgradeSkillBySortID(cell.data.sortID, delta)
      if upgradeSuccess then
        self.totalPoints = self.totalPoints - points
        cell:ShowDowngrade(true)
        self:UpdateLevel(cell, simulate)
        self.modifiedSkillBySort[simulate.sortID] = simulate.id
      end
      self:CheckCellState(cell, simulate)
      self:UpdateProfess(cell.data.profession)
      self:ScallAllDatas()
      return true
    else
      MsgManager.ShowMsgByIDTable(603, {
        ProfessionProxy.GetProfessionName(simulate.profession, MyselfProxy.Instance:GetMySex()),
        Occupation.GetFixedJobLevel(needJobLv, simulate.profession)
      })
    end
  else
    MsgManager.ShowMsgByIDTable(604)
  end
  return false
end

function FunctionSkillSimulate:MasterSkillUpgrade(cell)
  if not cell then
    return
  end
  if self:HasModifiedProfessSkill() then
    MsgManager.ShowMsgByIDTable(43582)
    return false
  end
  local simulate = SimulateSkillProxy.Instance:GetSimulateSkill(cell.data.sortID)
  local canUsePoints = self.masterSkillTotalPoints
  local fitCost = simulate:FitNextSkillPointCost(canUsePoints)
  if fitCost then
    local upgradeSuccess, points = SimulateSkillProxy.Instance:UpgradeSkillBySortID(cell.data.sortID)
    if upgradeSuccess then
      self.masterSkillTotalPoints = self.masterSkillTotalPoints - points
      local cost = self:GetMasterSkillCost(simulate)
      self.masterSkillTotalCost = self.masterSkillTotalCost + cost
      cell:ShowDowngrade(true)
      self:UpdateLevel(cell, simulate)
      self.modifiedSkillBySort[simulate.sortID] = simulate.id
    end
    self:CheckCellState(cell, simulate)
    self:UpdateMasterSkillProfess()
    self:ScallAllDatas()
    return true
  else
    MsgManager.ShowMsgByIDTable(604)
  end
  return false
end

function FunctionSkillSimulate:CheckCellState(cell, simulate)
  simulate = simulate or SimulateSkillProxy.Instance:GetSimulateSkill(cell.data.sortID)
  cell:EnableGray(not simulate.data.learned)
end

function FunctionSkillSimulate:UpdateProfess(pro)
  local profess = SimulateSkillProxy.Instance:GetSimulateProfess(pro)
  if profess then
    local data = self.professDatas[pro]
    data.points = profess.points
  end
end

function FunctionSkillSimulate:UpdateMasterSkillProfess()
  local profess = SimulateSkillProxy.Instance:GetMasterSimulateProfess()
  local data = self.professDatas.master
  data.points = profess.points
end

function FunctionSkillSimulate:HasModifiedSkill()
  for k, v in pairs(self.modifiedSkillBySort) do
    return true
  end
  return false
end

function FunctionSkillSimulate:HasModifiedProfessSkill()
  local proxy = SimulateSkillProxy.Instance
  for k, v in pairs(self.modifiedSkillBySort) do
    if not proxy:IsMasterSkill(v) then
      return true
    end
  end
  return false
end

function FunctionSkillSimulate:HasModifiedMasterSkill()
  local proxy = SimulateSkillProxy.Instance
  for k, v in pairs(self.modifiedSkillBySort) do
    if proxy:IsMasterSkill(v) then
      return true
    end
  end
  return false
end

function FunctionSkillSimulate:_GetSkillPointsUptoProfess(profess)
  local point = 0
  local proxy = SimulateSkillProxy.Instance
  local count = 0
  while profess and count <= 5 do
    count = count + 1
    point = point + profess.points
    profess = proxy:GetSimulateProfessPrevious(profess.id)
  end
  return point
end

function FunctionSkillSimulate:_GetSkillPointsUptoProfessWithoutExtra(profess)
  local point = 0
  local proxy = SimulateSkillProxy.Instance
  local count = 0
  while profess and count <= 5 do
    count = count + 1
    point = point + profess.points
    profess = proxy:GetSimulateProfessPrevious(profess.id)
  end
  return point
end

function FunctionSkillSimulate:Downgrade(cell)
  local proxy = SimulateSkillProxy.Instance
  local simulate = proxy:GetSimulateSkill(cell.data.sortID)
  if simulate.unlockSimulateData and simulate.unlockSimulateData.learned then
    if simulate.id == simulate.unlockSimulateData.sourceSkill.requiredSkillID then
      MsgManager.ShowMsgByIDTable(607, {
        simulate.unlockSimulateData.data.staticData.NameZh
      })
      return false
    end
    local requiredSkills = simulate.unlockSimulateData.sourceSkill.requiredSkills
    if requiredSkills and next(requiredSkills) then
      for i = 1, #requiredSkills do
        if requiredSkills[i] // 1000 == simulate.id // 1000 and requiredSkills[i] >= simulate.id then
          MsgManager.ShowMsgByIDTable(607, {
            simulate.unlockSimulateData.data.staticData.NameZh
          })
          return false
        end
      end
    end
  end
  local simulateSkilldata = Table_Skill[simulate.id]
  local profess = proxy:GetSimulateProfess(cell.data.profession)
  if profess then
    local nextProfess = proxy:GetSimulateProfessNext(cell.data.profession)
    if nextProfess then
      local foundNotFitPointsProfess
      local uptoSkillPoints = self:_GetSkillPointsUptoProfess(profess)
      local unlockPoints = SkillProxy.UNLOCKPROSKILLPOINTS
      local count = 0
      local config = GameConfig.Peak
      local _UnlockExtraSkillPoints = config.UnlockExtraSkillPoints
      local resetPeak = false
      while foundNotFitPointsProfess == nil and nextProfess ~= nil and count <= 5 do
        count = count + 1
        local extraIndex = config.UnlockSpecialClass[cell.data.profession] and nextProfess.index + 1 or nextProfess.index - 1
        local extraPoints = _UnlockExtraSkillPoints[extraIndex] or 0
        local currentIndex = nextProfess.index - 1
        local actualSimulatePoint = currentIndex * unlockPoints + extraPoints
        if extraIndex <= 2 and self.isPresetting and nextProfess.active and 0 < nextProfess.points and actualSimulatePoint >= uptoSkillPoints - self:GetPeakSkillPoint(cell.data.profession) then
          foundNotFitPointsProfess = proxy:GetSimulateProfessPrevious(nextProfess.id)
          if currentIndex == 1 then
            foundNotFitPointsProfess = nil
          end
          if foundNotFitPointsProfess then
            resetPeak = true
          end
        end
        if nextProfess.active and 0 < nextProfess.points and uptoSkillPoints <= actualSimulatePoint then
          foundNotFitPointsProfess = proxy:GetSimulateProfessPrevious(nextProfess.id)
          if foundNotFitPointsProfess then
            resetPeak = true
          end
        else
          uptoSkillPoints = uptoSkillPoints + nextProfess.points
          nextProfess = proxy:GetSimulateProfessNext(nextProfess.id)
        end
      end
      if foundNotFitPointsProfess then
        do
          local professName = "[EBECA7]"
          while nextProfess and 0 < nextProfess.points do
            professName = professName .. ProfessionProxy.GetProfessionName(nextProfess.id, MyselfProxy.Instance:GetMySex())
            nextProfess = proxy:GetSimulateProfessNext(nextProfess.id)
            if nextProfess and 0 < nextProfess.points then
              professName = professName .. ","
            end
          end
          professName = professName .. "[-]"
          MsgManager.ConfirmMsgByID(606, function()
            self:ResetWholeSkillsAfterProfess(foundNotFitPointsProfess.id, resetPeak)
            if not resetPeak then
              self:Downgrade(cell)
            end
            GameFacade.Instance:sendNotification(FunctionSkillSimulate.SimulateSkillPointChange)
          end, nil, nil, professName)
          return false
        end
      end
    end
  end
  local downgradeSuccess, points = proxy:DowngradeSkillBySortID(cell.data.sortID)
  if downgradeSuccess then
    self.totalPoints = self.totalPoints - points
    self.modifiedSkillBySort[simulate.sortID] = simulate.id
  end
  self:UpdateLevel(cell, simulate)
  if not proxy:HasPreviousSimulateSkillData(cell.data.sortID) then
    self.modifiedSkillBySort[simulate.sortID] = nil
    cell:ShowDowngrade(false)
  end
  self:UpdateProfess(cell.data.profession)
  self:CheckCellState(cell, simulate)
  self:ScallAllDatas(true)
  if self:HasModifiedSkill() == false then
    GameFacade.Instance:sendNotification(FunctionSkillSimulate.HasNoModifiedSkills)
  end
  return true
end

function FunctionSkillSimulate:MasterSkillDowngrade(cell)
  if not cell then
    return
  end
  local simulate = SimulateSkillProxy.Instance:GetSimulateSkill(cell.data.sortID)
  if simulate.unlockSimulateData and simulate.unlockSimulateData.learned and simulate.id == simulate.unlockSimulateData.sourceSkill.requiredSkillID then
    MsgManager.ShowMsgByIDTable(607, {
      simulate.unlockSimulateData.data.staticData.NameZh
    })
    return false
  end
  local downgradeSuccess, points = SimulateSkillProxy.Instance:DowngradeSkillBySortID(cell.data.sortID)
  if downgradeSuccess then
    self.masterSkillTotalPoints = self.masterSkillTotalPoints - points
    local cost = self:GetMasterSkillCost(simulate, true)
    self.masterSkillTotalCost = self.masterSkillTotalCost - cost
    self.modifiedSkillBySort[simulate.sortID] = simulate.id
  end
  self:UpdateLevel(cell, simulate)
  if not SimulateSkillProxy.Instance:HasPreviousSimulateSkillData(cell.data.sortID) then
    self.modifiedSkillBySort[simulate.sortID] = nil
    cell:ShowDowngrade(false)
  end
  self:UpdateMasterSkillProfess()
  self:CheckCellState(cell, simulate)
  self:ScallAllDatas(true)
  if self:HasModifiedSkill() == false then
    GameFacade.Instance:sendNotification(FunctionSkillSimulate.HasNoModifiedSkills)
  end
  return true
end

function FunctionSkillSimulate:ResetWholeSkillsAfterProfess(pro, resetPeak)
  local skillProxy = SkillProxy.Instance
  local simulateSkillProxy = SimulateSkillProxy.Instance
  local nextProfess = simulateSkillProxy:GetSimulateProfessNext(pro)
  local simulate, professSkills, skill, cell, downgradeSuccess, downgradeLevel
  while nextProfess ~= nil and nextProfess.points > 0 and nextProfess.id % 10 < 5 do
    professSkills = skillProxy:FindProfessSkill(nextProfess.id).skills
    for i = 1, #professSkills do
      skill = professSkills[i]
      if self.modifiedSkillBySort[skill.sortID] ~= nil then
        cell = self.skillCells[skill.sortID]
        simulate = simulateSkillProxy:GetSimulateSkill(cell.data.sortID)
        if cell then
          downgradeSuccess, downgradeLevel = SimulateSkillProxy.Instance:DowngradeSkillBySortID(cell.data.sortID, 10000)
          if downgradeSuccess then
            self.totalPoints = self.totalPoints - downgradeLevel
            self.modifiedSkillBySort[simulate.sortID] = nil
            cell:ShowDowngrade(false)
          end
          self:UpdateLevel(cell, simulate)
          self:CheckCellState(cell, simulate)
        end
      end
    end
    self:UpdateProfess(nextProfess.id)
    nextProfess = simulateSkillProxy:GetSimulateProfessNext(nextProfess.id)
  end
  self:ScallAllDatas(resetPeak)
  GameFacade.Instance:sendNotification(FunctionSkillSimulate.SimulateSkillPointChange)
end

function FunctionSkillSimulate:UpdateLevel(cell, simulate, breakEnable)
  if simulate.id ~= simulate.sourceSkill.id or simulate.learned ~= simulate.sourceSkill.learned then
    cell:SetLevel(Table_Skill[simulate.id].Level, "54B30A", breakEnable)
    cell:SetDragEnable(true)
  elseif simulate.learned then
    cell:SetDragEnable(true)
    cell:SetLevel(Table_Skill[simulate.id].Level, nil, breakEnable)
  else
    cell:SetDragEnable(false)
    cell:SetLevel(0, nil, breakEnable)
  end
end

function FunctionSkillSimulate:ScallAllDatas(isDownGrade)
  local myJobLevel = MyselfProxy.Instance:JobLevel()
  local professes = SkillProxy.Instance.professionSkills
  local _simulateSkillProxy = SimulateSkillProxy.Instance
  local simulateProfesses = _simulateSkillProxy.simulateProfessSkillTab
  local simulateSkills = _simulateSkillProxy.simulateSkillID
  local cell, p, fitJob, fitRequiredSkill, hasPoint, pActive, fitExtraSkill, fitRequiredSkills
  local realSimulate = self.totalPoints ~= self.initTotalPoints
  local canUsePoints = self.totalPoints
  local breakEnable = SkillProxy.Instance:GetSkillCanBreak()
  local newBreakEnable = MyselfProxy.Instance:HasJobNewBreak()
  local simuateBreakEnable = _simulateSkillProxy:GetSkillCanBreak()
  local extraEnable = SkillProxy.Instance:GetSkillCanExtra()
  local simulateExtraEnable = _simulateSkillProxy:GetSkillCanExtra()
  local rollbackLevel = 0
  if not self.isPresetting and (not breakEnable and simuateBreakEnable or not extraEnable and simulateExtraEnable) then
    canUsePoints = 0
  end
  local masterSkillSimulateData = _simulateSkillProxy:GetMasterSimulateProfess()
  self:ClearPeakSkillPoint()
  for i = 1, #professes do
    if SkillProxy.IsBeforeFourthProfess(professes[i].profession) then
      p = simulateProfesses[professes[i].profession]
      if p.skills then
        pActive = p.active
        for k, skill in pairs(p.skills) do
          cell = self.skillCells[skill.data.sortID]
          if cell then
            local deltaD = skill:GetBreakLevel() or 0
            if 0 < deltaD then
              self:AddPeakSkillPoint(cell.data.profession, deltaD)
            end
            fitJob = skill:FitNextJobLevel(myJobLevel)
            fitRequiredSkill = skill:FitRequiredSkill()
            hasPoint = skill:FitNextSkillPointCost(canUsePoints)
            fitExtraSkill = not extraEnable
            fitRequiredSkills = skill:FitMultiRequiredSkills()
            local canUpgradeExtra = simulateExtraEnable and skill:HasNextLevel()
            if self.isPresetting then
              fitExtraSkill = not canUpgradeExtra
            end
            if 0 < cell.data.breakMaxLevel then
              if isDownGrade and self.isPresetting and not breakEnable and not simuateBreakEnable then
                local downgradeSuccess, downgradeLevel = _simulateSkillProxy:DowngradeSkillBySortID(cell.data.sortID, deltaD)
                if downgradeSuccess then
                  self.totalPoints = self.totalPoints - downgradeLevel
                  self.modifiedSkillBySort[skill.sortID] = skill.id
                end
              end
              self:UpdateLevel(cell, skill, breakEnable or simuateBreakEnable)
            end
            if 0 < cell.data.breakNewMaxLevel then
              self:UpdateLevel(cell, skill, newBreakEnable or self.isIsSimulating)
            end
            if skill.learned then
              cell:EnableGray(false)
              if not breakEnable and simuateBreakEnable and skill.data.staticData.NextBreakID then
                if not self.isPresetting then
                  cell:ShowPreview(true)
                else
                  cell:ShowPreview(false)
                  cell:ShowUpgrade(fitExtraSkill and skill:HasNextLevel())
                end
              else
                cell:ShowPreview(false)
                cell:ShowUpgrade(fitExtraSkill and skill:HasNextLevel())
              end
              if not (hasPoint and fitJob) or not skill:HasNextLevel() then
                if realSimulate then
                  cell:SetUpgradeEnable(false, breakEnable)
                else
                  cell:SetNameBgEnable(false)
                  cell:ShowUpgrade(false)
                end
              else
                cell:SetUpgradeEnable(true, breakEnable)
                cell:SetNameBgEnable(true)
              end
            elseif fitJob and fitRequiredSkill and hasPoint and pActive and fitExtraSkill and fitRequiredSkills then
              cell:ShowUpgrade(true)
              cell:SetUpgradeEnable(true, breakEnable)
              cell:EnableGray(false)
            else
              cell:ShowUpgrade(false)
              cell:EnableGray(true)
            end
            if cell.requiredCell then
              cell.requiredCell:LinkUnlock(cell.data.sortID, fitRequiredSkill)
            end
            if cell.requiredCells then
              for i = 1, #cell.requiredCells do
                cell.requiredCells[i]:MultiLinkUnlock(cell.data.sortID, fitRequiredSkills)
              end
            end
          end
        end
      end
    end
  end
  if masterSkillSimulateData and masterSkillSimulateData.skills then
    canUsePoints = self.masterSkillTotalPoints
    for _, skill in pairs(masterSkillSimulateData.skills) do
      cell = self.skillCells[skill.data.sortID]
      local isEquiped = SkillProxy.Instance:IsMasterSkillEquiped(skill.data.id)
      fitRequiredSkill = skill:FitRequiredSkill()
      hasPoint = skill:FitNextSkillPointCost(canUsePoints)
      if skill.learned then
        cell:EnableGray(false)
        cell:ShowUpgrade(isEquiped and hasPoint and skill:HasNextLevel())
      elseif fitRequiredSkill and hasPoint then
        cell:ShowUpgrade(isEquiped)
        cell:SetUpgradeEnable(true)
        cell:EnableGray(false)
      else
        cell:ShowUpgrade(false)
        cell:EnableGray(true)
      end
      if cell.requiredCell then
        cell.requiredCell:LinkUnlock(cell.data.sortID, fitRequiredSkill)
      end
    end
  end
end

local tempSortID = 0
local tempSkillCell

function FunctionSkillSimulate:StartPreset(skillCells, presetDatas, totalPoints)
  local skillp = Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT) or 0
  if skillp <= 0 then
    return
  end
  self.isPresetting = true
  self:SetNewTotalPoints(totalPoints)
  if not presetDatas or #presetDatas == 0 then
    return
  end
  for i = 1, #presetDatas do
    tempSortID = presetDatas[i] // 1000
    tempSkillCell = self.skillCells[tempSortID]
    self:Upgrade(tempSkillCell, presetDatas[i])
  end
end

function FunctionSkillSimulate:ClosePreset()
  self.isPresetting = false
end

function FunctionSkillSimulate:IsPresetting()
  return self.isPresetting
end

function FunctionSkillSimulate:ClearPeakSkillPoint()
  if self.simulatePeakSkillPoint then
    TableUtility.TableClear(self.simulatePeakSkillPoint)
  end
end

function FunctionSkillSimulate:AddPeakSkillPoint(profess, delta)
  if not self.simulatePeakSkillPoint then
    self.simulatePeakSkillPoint = {}
  end
  local p = self.simulatePeakSkillPoint[profess]
  p = p or 0
  p = p + delta
  self.simulatePeakSkillPoint[profess] = p
end

function FunctionSkillSimulate:GetPeakSkillPoint(profess)
  if not self.simulatePeakSkillPoint then
    return 0
  end
  return self.simulatePeakSkillPoint[profess] or 0
end

function FunctionSkillSimulate:GetMasterSkillCost(simulate, isDownGrade)
  local skillId = isDownGrade and simulate.learned and simulate.id + 1 or simulate.id
  local sortID = skillId // 1000
  local level = simulate:GetSimulateLevel()
  level = isDownGrade and simulate.learned and level + 1 or level
  local pro = simulate.profession
  local config = Table_Class[pro]
  if config then
    local index = 0
    if config.MasterSkills and config.MasterSkills ~= _EmptyTable then
      for i = 1, #config.MasterSkills do
        local skillIds = config.MasterSkills[i]
        _, index = TableUtility.ArrayFindByPredicate(skillIds, function(v, args)
          return v // 1000 == args
        end, sortID)
        if 0 < index then
          break
        end
      end
    end
    if index == 0 then
      local masterSkillProfessData = SkillProxy.Instance:GetMasterSkillProfessData()
      local unlockSkillIndex = masterSkillProfessData and masterSkillProfessData:GetUnlockLimitSkillIndex()
      if unlockSkillIndex and config.LimitMasterSkills and config.LimitMasterSkills ~= _EmptyTable then
        for i = 1, #unlockSkillIndex do
          local skillIds = config.LimitMasterSkills[unlockSkillIndex[i]]
          _, index = TableUtility.ArrayFindByPredicate(skillIds, function(v, args)
            return v // 1000 == args
          end, sortID)
          if 0 < index then
            break
          end
        end
      end
    end
    if 0 < index then
      local costConfig = TableUtility.TableFindByPredicate(Table_MasterSkillCost, function(k, v, args)
        return v.pos == args[1] and v.level == args[2]
      end, {index, level})
      if costConfig then
        return costConfig.zeny
      end
    end
  end
end
