InheritSkillProxy = class("InheritSkillProxy", pm.Proxy)
InheritSkillProxy.Instance = nil
InheritSkillProxy.NAME = "InheritSkillProxy"
autoImport("InheritSkillProfessData")

function InheritSkillProxy:ctor(proxyName, data)
  self.proxyName = proxyName or InheritSkillProxy.NAME
  if InheritSkillProxy.Instance == nil then
    InheritSkillProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.loadedSkills = {}
  self.skillProfessDatas = {}
  self.extendCostPointBuffEffects = {}
  self.extendCostPointCurBuffEffect = {}
  self.extendCostPointAttrs = {}
end

function InheritSkillProxy:InitInheritSkills()
  for familyId, data in pairs(Table_SkillInherit) do
    local skill = InheritSkillItemData.new(familyId)
    self:AddInheritSkill(0, skill)
  end
end

function InheritSkillProxy:InitCostPointAttr()
  local extendPointCost = GameConfig.SkillInherit and GameConfig.SkillInherit.PointExtendCost
  if extendPointCost then
    local buffEffects = {}
    for i = 1, #extendPointCost do
      self.extendCostPointBuffEffects[i] = {}
      self.extendCostPointCurBuffEffect[i] = {}
      local config = extendPointCost[i]
      if config.Buffs then
        for _, buffId in ipairs(config.Buffs) do
          local buffConf = Table_Buffer[buffId]
          for k, v in pairs(buffConf.BuffEffect) do
            if Game.Config_PropName[k] then
              buffEffects[k] = buffEffects[k] or 0
              buffEffects[k] = buffEffects[k] + v
              self.extendCostPointCurBuffEffect[i][k] = buffEffects[k]
            end
          end
        end
        for k, v in pairs(buffEffects) do
          self.extendCostPointBuffEffects[i][k] = v
        end
      end
    end
  end
end

function InheritSkillProxy:ServerReInit(serverData)
  if not self.skillProfessDatas[0] then
    self:InitInheritSkills()
    self:InitCostPointAttr()
  end
  if serverData and serverData.inherit_skill_data then
    TableUtility.ArrayClear(self.loadedSkills)
    local serverSkillItems = serverData.inherit_skill_data.items
    self:UpdateInheritSkills(serverSkillItems)
    redlog("extendedCostPoints", serverData.inherit_skill_data.extendpoints, serverSkillItems and #serverSkillItems)
    self.extendedCostPoints = serverData.inherit_skill_data.extendpoints or 0
  end
end

function InheritSkillProxy:UpdateInheritSkills(serverSkillItems)
  if not serverSkillItems then
    return
  end
  for i = 1, #serverSkillItems do
    local skillItem = serverSkillItems[i]
    local familyId = skillItem.id // 1000
    local pro = InheritSkillProxy.GetSkillProfess(familyId)
    redlog("InheritSkillProxy:UpdateInheritSkills", skillItem.id, tostring(skillItem.load), pro)
    if pro then
      self:UpdateInheritSkill(pro, skillItem)
    end
  end
end

function InheritSkillProxy:UpdateInheritSkill(pro, serverSkillItem)
  local familyId = serverSkillItem.id // 1000
  local oldPro, skill = self:FindSkillByFamilyId(familyId)
  if oldPro ~= pro then
    if oldPro then
      skill = self:RemoveInheritSkill(oldPro, familyId)
    else
      skill = InheritSkillItemData.new(familyId)
    end
    self:AddInheritSkill(pro, skill)
  end
  skill:UpdateSkill(serverSkillItem)
  if skill.isLoad then
    self:AddLoadSkill(skill)
    SkillProxy.Instance:LearnedSkill(skill)
  else
    self:RemoveLoadSkill(skill)
    SkillProxy.Instance:RemoveLearnedSkill(skill)
  end
  SkillProxy.Instance:UpdateEquipSkill(skill)
end

function InheritSkillProxy:AddInheritSkill(pro, skill)
  if not pro then
    return
  end
  local professData = self.skillProfessDatas[pro]
  if not professData then
    professData = InheritSkillProfessData.new(pro)
    self.skillProfessDatas[pro] = professData
  end
  professData:AddSkill(skill)
end

function InheritSkillProxy:RemoveInheritSkill(pro, familyId)
  if self.skillProfessDatas[pro] then
    local skillItemData = self:FindSkillInProfessData(pro, familyId)
    self.skillProfessDatas[pro]:RemoveSkill(skillItemData)
    return skillItemData
  end
end

function InheritSkillProxy:AddLoadSkill(skillItemData)
  if TableUtility.ArrayFindIndex(self.loadedSkills, skillItemData) == 0 then
    self.loadedSkills[#self.loadedSkills + 1] = skillItemData
  end
end

function InheritSkillProxy:RemoveLoadSkill(skillItemData)
  TableUtility.ArrayRemove(self.loadedSkills, skillItemData)
end

function InheritSkillProxy:FindSkillByFamilyId(familyId)
  for pro, professData in pairs(self.skillProfessDatas) do
    local skill = professData:FindSkill(familyId)
    if skill then
      return pro, skill
    end
  end
  return nil
end

function InheritSkillProxy:FindSkillInProfessData(pro, familyId)
  local professData = self.skillProfessDatas[pro]
  if professData then
    return professData:FindSkill(familyId)
  end
end

function InheritSkillProxy.GetSkillProfess(familyId)
  local config = Table_SkillInherit[familyId]
  if config then
    local professes = config.ProfessionDepend
    local sex = MyselfProxy.Instance:GetMySex()
    for i = 1, #professes do
      local pro = professes[i]
      local classConfig = Table_Class[pro]
      if classConfig then
        local continue = false
        local ids = classConfig.OriginId
        if ids and 0 < #ids then
          for j = 1, #ids do
            local id = ids[j]
            local staticData = Table_Class[id]
            if staticData then
              local gender = staticData.gender
              if not gender or gender == 0 then
                classConfig = staticData
                break
              end
              if gender == sex then
                classConfig = staticData
                break
              end
            end
          end
        else
          local gender = classConfig.gender
          if gender and gender ~= 0 and gender ~= sex then
            continue = true
          end
        end
        if not continue then
          local typeBranch = classConfig.TypeBranch
          local proList = ProfessionProxy.GetProfList(typeBranch)
          return proList and proList[1], classConfig.id
        end
      end
    end
  end
end

function InheritSkillProxy:GetSkillProfessDatas()
  local datas = {}
  local sex = MyselfProxy.Instance:GetMySex()
  local newProfessDatas = {}
  for pro, professData in pairs(self.skillProfessDatas) do
    local config = Table_Class[pro]
    if config and config.gender and config.gender ~= 0 and sex ~= config.gender then
      local skills = professData:GetSkills()
      for i = #skills, 1, -1 do
        local skill = skills[i]
        local newPro = InheritSkillProxy.GetSkillProfess(skill.sortID)
        if newPro ~= pro then
          if self.skillProfessDatas[newPro] then
            self:AddInheritSkill(newPro, skill)
          else
            if not newProfessDatas[newPro] then
              newProfessDatas[newPro] = InheritSkillProfessData.new(newPro)
            end
            newProfessDatas[newPro]:AddSkill(skill)
          end
          table.remove(skills, i)
        end
      end
    end
    if not professData:IsEmpty() then
      datas[#datas + 1] = professData
    end
  end
  for pro, professData in pairs(newProfessDatas) do
    self.skillProfessDatas[pro] = professData
    if not professData:IsEmpty() then
      datas[#datas + 1] = professData
    end
  end
  return datas
end

function InheritSkillProxy:GetLoadSkills()
  return self.loadedSkills
end

function InheritSkillProxy:GetLoadSkillCount()
  return #self.loadedSkills
end

function InheritSkillProxy:GetExtendedCostPoints()
  return self.extendedCostPoints
end

function InheritSkillProxy:UpdateExtendedCostPoints(points)
  self.extendedCostPoints = points
end

function InheritSkillProxy:IsLoadedInheritSkill(skillId)
  local familyId = skillId // 1000
  local skill = TableUtility.ArrayFindByPredicate(self.loadedSkills, function(v, args)
    return v.sortID == args
  end, familyId)
  return skill ~= nil
end

function InheritSkillProxy:IsCostPointsEnough(costPoint)
  local initPoint = GameConfig.SkillInherit and GameConfig.SkillInherit.InitPointMax or 0
  local totalCostPoints = self.extendedCostPoints + initPoint
  local usedCostPoint = 0
  for i = 1, #self.loadedSkills do
    local skill = self.loadedSkills[i]
    usedCostPoint = usedCostPoint + skill:GetCostPoint()
  end
  local remainCostPoint = totalCostPoints - usedCostPoint
  return costPoint <= remainCostPoint
end

local sortFunc = function(l, r)
  local configl = Game.Config_PropName[l.name]
  local configr = Game.Config_PropName[r.name]
  return configl.id < configr.id
end

function InheritSkillProxy:GetCurCostPointAttrs()
  return self:GetCostPointAttrs(self.extendedCostPoints)
end

function InheritSkillProxy:GetTotalCostPointAttrs(costPoint)
  if costPoint > #self.extendCostPointBuffEffects then
    return
  end
  local attrs = self.extendCostPointBuffEffects[#self.extendCostPointBuffEffects]
  local curAttrs = self.extendCostPointBuffEffects[costPoint]
  local datas = self.extendCostPointAttrs[costPoint]
  if not datas then
    datas = {}
    self.extendCostPointAttrs[costPoint] = datas
    for k in pairs(attrs) do
      local data = {}
      data.name = k
      data.value = curAttrs and curAttrs[k] and curAttrs[k] or 0
      datas[#datas + 1] = data
    end
    table.sort(datas, sortFunc)
  end
  return datas
end

function InheritSkillProxy:GetCostPointAttrs(costPoint)
  if costPoint > #self.extendCostPointBuffEffects then
    return
  end
  costPoint = math.max(costPoint, 1)
  local curAttrs = self.extendCostPointCurBuffEffect[costPoint]
  local datas = {}
  for k, v in pairs(curAttrs) do
    local data = {}
    data.name = k
    data.value = v
    datas[#datas + 1] = data
  end
  table.sort(datas, sortFunc)
  return datas
end
