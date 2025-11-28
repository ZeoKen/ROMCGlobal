autoImport("SkillSimulateData")
SimulateSkillProxy = class("SimulateSkillProxy", pm.Proxy)
SimulateSkillProxy.Instance = nil
SimulateSkillProxy.NAME = "SimulateSkillProxy"

function SimulateSkillProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SimulateSkillProxy.NAME
  if SimulateSkillProxy.Instance == nil then
    SimulateSkillProxy.Instance = self
  end
  self:Reset()
end

function SimulateSkillProxy:Reset()
  self.simulateSkillID = {}
  self.simulateProfessSkillTab = {}
  self.masterProfessData = nil
end

function SimulateSkillProxy:RollBack()
  for k, sskill in pairs(self.simulateSkillID) do
    sskill:Reset()
  end
  for k, p in pairs(self.simulateProfessSkillTab) do
    p.points = p.sourcePoint
  end
end

function SimulateSkillProxy:ReInit()
  local myProfess = MyselfProxy.Instance:GetMyProfession()
  local needReset = false
  if self.professionID ~= myProfess then
    self:Reset()
    self.professionID = myProfess
    needReset = true
    local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
    if professTree ~= nil then
      local p = professTree.transferRoot
      local typeBranch = Table_Class[myProfess].TypeBranch
      while p ~= nil do
        SkillProxy.Instance:FindProfessSkill(p.id, true)
        p = p:GetNextByBranch(typeBranch)
      end
    end
  end
  self.totalUsedPoint = 0
  self.totalUsedBasePoint = 0
  local professes = SkillProxy.Instance.professionSkills
  local masterProfessData = SkillProxy.Instance:GetMasterSkillProfessData()
  local rootClass = ProfessionProxy.RootClass
  local commonClass = ProfessionProxy.CommonClass
  local p, skill, data, cacheSkill, previousProfess, basePoints
  for i = 1, #professes do
    p = professes[i]
    if SkillProxy.IsBeforeFourthProfess(p.profession) then
      self.totalUsedPoint = self.totalUsedPoint + p.points
      basePoints = p.basePoints or p.points
      self.totalUsedBasePoint = self.totalUsedBasePoint + basePoints
      data = {
        id = p.profession,
        points = p.points,
        sourcePoint = p.points,
        nextProfession = SkillProxy.IsBeforeFourthProfess(professes[i + 1] and professes[i + 1].profession) and professes[i + 1] or nil,
        active = p.points >= SkillProxy.UNLOCKPROSKILLPOINTS
      }
      local skills = {}
      self.simulateProfessSkillTab[p.profession] = data
      if p.profession ~= commonClass then
        for j = 1, #p.skills do
          skill = p.skills[j]
          cacheSkill = self.simulateSkillID[skill.sortID]
          if cacheSkill == nil then
            cacheSkill = SkillSimulateData.new(skill)
            self.simulateSkillID[skill.sortID] = cacheSkill
          else
            cacheSkill:ResetSource(skill)
          end
          skills[#skills + 1] = cacheSkill
        end
        data.skills = skills
      else
        data.active = true
      end
    end
  end
  self.masterProfessData = nil
  if masterProfessData then
    needReset = true
    data = {
      id = "master",
      points = masterProfessData.points
    }
    self.masterProfessData = data
    local skills = {}
    for i = 1, #masterProfessData.skills do
      skill = masterProfessData.skills[i]
      cacheSkill = self.simulateSkillID[skill.sortID]
      if cacheSkill == nil then
        cacheSkill = SkillSimulateData.new(skill, true)
        self.simulateSkillID[skill.sortID] = cacheSkill
      else
        cacheSkill:ResetSource(skill)
      end
      skills[#skills + 1] = cacheSkill
    end
    data.skills = skills
  end
  for k, v in pairs(rootClass) do
    local professRoot = self:GetSimulateProfessNext(k)
    if professRoot then
      local index = 1
      professRoot.active = true
      professRoot.index = index
      while professRoot.nextProfession ~= nil do
        self:RefreshProfessPoints(professRoot.id, 0)
        local nextP = self:GetSimulateProfessNext(professRoot.id)
        nextP.previousProfessID = professRoot.id
        professRoot = nextP
        index = index + 1
        professRoot.index = index
      end
    end
  end
  if needReset then
    self:ResetSkillLinks()
  end
end

function SimulateSkillProxy:ResetSkillLinks()
  local sortID, requiredSkill, requiredSkillID
  for k, skill in pairs(self.simulateSkillID) do
    if skill.sourceSkill.requiredSkillID then
      sortID = math.floor(skill.sourceSkill.requiredSkillID / 1000)
      requiredSkill = self.simulateSkillID[sortID]
      if requiredSkill then
        requiredSkill:SetUnlockSimulate(skill, skill.sourceSkill.requiredSkillID)
        skill:SetRequiredSimulate(requiredSkill)
      end
    end
    if skill.sourceSkill.requiredSkills then
      local requiredSkills = skill.sourceSkill.requiredSkills
      for i = 1, #requiredSkills do
        requiredSkillID = requiredSkills[i]
        sortID = math.floor(requiredSkillID / 1000)
        requiredSkill = self.simulateSkillID[sortID]
        if requiredSkill then
          requiredSkill:SetUnlockSimulate(skill, skill.sourceSkill.requiredSkillID)
          skill:AddMultiRequirements(requiredSkill)
        end
      end
    end
  end
end

function SimulateSkillProxy:GetSimulateProfess(pro)
  return self.simulateProfessSkillTab[pro]
end

function SimulateSkillProxy:GetSimulateProfessPrevious(pro)
  local p = self.simulateProfessSkillTab[pro]
  local previous
  if p and p.previousProfessID then
    previous = self.simulateProfessSkillTab[p.previousProfessID]
  end
  return previous
end

function SimulateSkillProxy:GetSimulateProfessNext(pro)
  local p = self.simulateProfessSkillTab[pro]
  local nextP
  if p and p.nextProfession then
    nextP = self.simulateProfessSkillTab[p.nextProfession.profession]
  end
  return nextP
end

function SimulateSkillProxy:RefreshProfessPoints(pro, delta, recursive, baseDelta)
  local p = self.simulateProfessSkillTab[pro]
  if p then
    baseDelta = baseDelta or 0
    p.points = p.points + delta
    self.totalUsedPoint = self.totalUsedPoint + delta
    self.totalUsedBasePoint = self.totalUsedBasePoint + baseDelta
    if p.nextProfession then
      local nextP = self.simulateProfessSkillTab[p.nextProfession.profession]
      if nextP then
        local config = GameConfig.Peak
        local extraIndex = config.UnlockSpecialClass[pro] and p.index + 2 or p.index
        local extraPoints = config.UnlockExtraSkillPoints[extraIndex] or 0
        nextP.active = self.totalUsedPoint >= p.index * SkillProxy.UNLOCKPROSKILLPOINTS + extraPoints
        if recursive then
          self:RefreshProfessPoints(nextP.id, 0, recursive)
        end
      end
    end
  end
end

function SimulateSkillProxy:RefreshMasterProfessPoints(delta)
  if self.masterProfessData then
    self.masterProfessData.points = self.masterProfessData.points + delta
  end
end

function SimulateSkillProxy:UpgradeSkillBySortID(sortID, delta)
  local simulateData = self.simulateSkillID[sortID]
  local changed, delta, baseDelta = simulateData:Upgrade(delta)
  if changed then
    if simulateData.isMaster then
      self:RefreshMasterProfessPoints(delta)
    else
      self:RefreshProfessPoints(simulateData.profession, delta, true, baseDelta)
    end
  end
  return changed, delta
end

function SimulateSkillProxy:DowngradeSkillBySortID(sortID, level)
  local simulateData = self.simulateSkillID[sortID]
  local changed, delta, baseDelta = simulateData:Downgrade(level)
  if changed then
    self:RefreshProfessPoints(simulateData.profession, delta, true, baseDelta)
  end
  return changed, delta
end

function SimulateSkillProxy:HasNextSimulateSkillData(sortID)
  local skill = self.simulateSkillID[sortID]
  if skill then
    return skill:HasNextLevel()
  end
  return false
end

function SimulateSkillProxy:HasPreviousSimulateSkillData(sortID)
  local skill = self.simulateSkillID[sortID]
  if skill then
    return skill:HasPreviousLevel()
  end
  return false
end

function SimulateSkillProxy:GetSimulateSkill(sortID)
  return self.simulateSkillID[sortID]
end

function SimulateSkillProxy:GetSimulateSkillItemData(sortID, autoCreate)
  if autoCreate == nil then
    autoCreate = true
  end
  local simulateData = self.simulateSkillID[sortID]
  if simulateData then
    local data = simulateData.data
    if data == nil and autoCreate then
      simulateData.data = SkillItemData.new(simulateData.id, 0, 0, simulateData.profession, 0)
      data = simulateData.data
      data.learned = simulateData.sourceSkill.learned
    elseif data.id ~= simulateData.id then
      data:Reset(simulateData.id, 0, 0, simulateData.profession, 0)
    end
    return data
  end
  return nil
end

function SimulateSkillProxy:GetSkillCanBreak()
  local _MyselfProxy = MyselfProxy.Instance
  if _MyselfProxy:HasJobBreak() and FunctionSkillSimulate.Me().isIsSimulating then
    local point = _MyselfProxy:GetMyProfessionSpecial() and GameConfig.Peak.SuperNoviceSkillPointToBreak or GameConfig.Peak.SkillPointToBreak
    return point <= self.totalUsedBasePoint
  end
  return false
end

function SimulateSkillProxy:GetSkillCanExtra()
  if FunctionSkillSimulate.Me().isIsSimulating then
    local config = GameConfig.ExtraSkill
    local point = config.point[MyselfProxy.Instance:GetMyProfessionTypeBranch()] or config.defaultPoint
    return point <= self.totalUsedPoint
  end
  return false
end

function SimulateSkillProxy:GetExtraSkillPoint()
  local config = GameConfig.ExtraSkill
  return config.point[MyselfProxy.Instance:GetMyProfessionTypeBranch()] or config.defaultPoint
end

function SimulateSkillProxy:GetExtraSkillUsedPoints()
  local config = GameConfig.ExtraSkill.skillid
  local skill = self.simulateSkillID[config // 1000]
  if skill and skill.learned then
    return skill:GetSimulateLevel()
  end
  return 0
end

function SimulateSkillProxy:GetSkillCanExtraWithoutExtraskill()
  if FunctionSkillSimulate.Me().isIsSimulating then
    local config = GameConfig.ExtraSkill
    local point = config.point[MyselfProxy.Instance:GetMyProfessionTypeBranch()] or config.defaultPoint
    return point <= self.totalUsedPoint - self:GetExtraSkillUsedPoints()
  end
  return false
end

function SimulateSkillProxy:GetMasterSimulateProfess()
  return self.masterProfessData
end

function SimulateSkillProxy:IsMasterSkill(skillId)
  local sortID = skillId // 1000
  local skill = self.simulateSkillID[sortID]
  local config = skill and Table_Class[skill.profession]
  if config then
    if config.MasterSkills and config.MasterSkills ~= _EmptyTable then
      for i = 1, #config.MasterSkills do
        local skillIds = config.MasterSkills[i]
        for j = 1, #skillIds do
          if skillIds[j] // 1000 == sortID then
            return true
          end
        end
      end
    end
    local masterProfessData = SkillProxy.Instance:GetMasterSkillProfessData()
    local unlockSkillIndex = masterProfessData and masterProfessData:GetUnlockLimitSkillIndex()
    if unlockSkillIndex and config.LimitMasterSkills and config.LimitMasterSkills ~= _EmptyTable then
      for i = 1, #unlockSkillIndex do
        local skillIds = config.LimitMasterSkills[unlockSkillIndex[i]]
        if skillIds then
          for j = 1, #skillIds do
            if skillIds[j] // 1000 == sortID then
              return true
            end
          end
        end
      end
    end
  end
  return false
end
