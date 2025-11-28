autoImport("RoguelikeSkillData")
RoguelikeSkillProxy = class("RoguelikeSkillProxy", pm.Proxy)
RoguelikeSkillProxy.Instance = nil
RoguelikeSkillProxy.NAME = "RoguelikeSkillProxy"

function RoguelikeSkillProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RoguelikeSkillProxy.NAME
  self.data = data
  if RoguelikeSkillProxy.Instance == nil then
    RoguelikeSkillProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RoguelikeSkillProxy:Init()
  self.currentSkillList = {}
  self.alternativeSkillList = {}
  self.currentSkillMap = {}
  self.skillCatalog = {}
end

local sortFunc = function(l, r)
  return l.id < r.id
end

function RoguelikeSkillProxy:InitSkillCatalog()
  if not Game.SpaceTimeIllusionSkills then
    return
  end
  for id, v in pairs(Game.SpaceTimeIllusionSkills) do
    local type = v[1] and v[1].Type
    if type then
      if not self.skillCatalog[type] then
        self.skillCatalog[type] = {}
      end
      local skillData = self:CreateSkillData(id)
      local maxLevel = skillData:GetMaxLevel()
      skillData:Reset(id, maxLevel)
      TableUtility.ArrayPushBack(self.skillCatalog[type], skillData)
    end
  end
  for _, list in pairs(self.skillCatalog) do
    table.sort(list, sortFunc)
  end
end

function RoguelikeSkillProxy:GetSkillsByType(type)
  if not next(self.skillCatalog) then
    self:InitSkillCatalog()
  end
  return self.skillCatalog[type]
end

function RoguelikeSkillProxy:UpdateCurrentSkills(data)
  TableUtility.ArrayClear(self.currentSkillList)
  TableUtility.ArrayClear(self.alternativeSkillList)
  self:ClearSkillReseted()
  for i = 1, #data do
    local serverSkillData = data[i]
    local skillData = self.currentSkillMap[serverSkillData.skill_id]
    if not skillData then
      skillData = self:CreateSkillData(serverSkillData.skill_id, serverSkillData.skill_level, serverSkillData.is_recommend, serverSkillData.is_new_skill)
      self.currentSkillMap[skillData.id] = skillData
    else
      skillData:Reset(serverSkillData.skill_id, serverSkillData.skill_level, serverSkillData.is_recommend, serverSkillData.is_new_skill)
    end
    self.currentSkillList[i] = skillData
  end
end

function RoguelikeSkillProxy:GetCurrentSkillList()
  return self.currentSkillList
end

function RoguelikeSkillProxy:ClearCurrentSkills()
  TableUtility.ArrayClear(self.currentSkillList)
  TableUtility.TableClear(self.currentSkillMap)
  TableUtility.ArrayClear(self.alternativeSkillList)
  self:ClearSkillReseted()
end

function RoguelikeSkillProxy:UpdateAlternativeSkillList(options, availableRefreshAllSkillNumber)
  TableUtility.ArrayClear(self.alternativeSkillList)
  for i = 1, #options do
    local serverSkillData = options[i]
    redlog("UpdateAlternativeSkillList", serverSkillData.skill_id, serverSkillData.skill_level, tostring(serverSkillData.is_recommend), tostring(serverSkillData.is_new_skill))
    self.alternativeSkillList[i] = self:CreateSkillData(serverSkillData.skill_id, serverSkillData.skill_level, serverSkillData.is_recommend, serverSkillData.is_new_skill)
  end
  self.availableRefreshAllSkillNumber = availableRefreshAllSkillNumber
end

function RoguelikeSkillProxy:RandomAlternativeSkills(index)
  index = index or 0
  redlog("CallSTIRefreshUpgradeOptionsCmd", index)
  ServiceFuBenCmdProxy.Instance:CallSTIRefreshUpgradeOptionsCmd(index)
end

function RoguelikeSkillProxy:GetAlternativeSkillList()
  return self.alternativeSkillList
end

function RoguelikeSkillProxy:UpdateRandomSkillPoint(point)
  self.randomSkillPoint = point
end

function RoguelikeSkillProxy:GetRandomSkillPoint()
  return self.randomSkillPoint
end

function RoguelikeSkillProxy:CreateSkillData(skillId, skillLevel, isRecommend, isNewSkill)
  local skillData = RoguelikeSkillData.new(skillId, skillLevel, isRecommend, isNewSkill)
  return skillData
end

function RoguelikeSkillProxy:ClearSkillReseted()
  self.availableRefreshAllSkillNumber = nil
end

function RoguelikeSkillProxy:GetAvailableRefreshAllSkillNumber()
  return self.availableRefreshAllSkillNumber
end
