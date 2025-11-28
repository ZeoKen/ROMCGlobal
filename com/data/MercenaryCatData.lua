MercenaryCatData = class("MercenaryCatData")

function MercenaryCatData:ctor(id)
  self:SetData(id)
end

function MercenaryCatData:SetData(id)
  self.id = id
  self.staticData = Table_MercenaryCat[id]
  if self.staticData then
    self:InitMercenarySkill()
    self.monsterStaticData = Table_Monster[self.staticData.MonsterID]
    if self.monsterStaticData then
      self.classtype = self.monsterStaticData.ClassType
    end
    self.name = self.monsterStaticData.NameZh
    self.icon = self.monsterStaticData.Icon
    self.body = self.monsterStaticData.Body
  end
  self.unlockEquips = {}
  self.unlockSkills = {}
  self.curEquips = {}
  self.attrs = {}
end

function MercenaryCatData:SetServerData(data)
  self[8], self[10], self[11] = nil, nil, nil
  TableUtility.ArrayClear(self.curEquips)
  TableUtility.ArrayClear(self.unlockEquips)
  TableUtility.ArrayClear(self.unlockSkills)
  if data.equipids then
    for i = 1, #data.equipids do
      self.unlockEquips[#self.unlockEquips + 1] = data.equipids[i]
    end
  end
  if data.skillids then
    self:SetUnlockSkills(data.skillids)
  end
  if data.curequipids then
    for i = 1, #data.curequipids do
      self.curEquips[#self.curEquips + 1] = data.curequipids[i]
    end
  end
  self:SetDressedEquip()
end

local MATHFLOOR = math.floor

function MercenaryCatData:SetUnlockSkills(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockSkills[#self.unlockSkills + 1] = id
    local sid = MATHFLOOR(id / 1000)
    if nil ~= self.staticSkill[sid] then
      self.staticSkill[sid].lock = false
      self.staticSkill[sid].lv = id % 1000
    end
  end
end

function MercenaryCatData:GetViewSkillTab(mercenaryNew)
  mercenaryNew = mercenaryNew or false
  self.skillTab = {}
  for id, tab in pairs(self.staticSkill) do
    local showid = id * 1000 + tab.lv
    local skilldata = mercenaryNew and {
      id = showid,
      locked = tab.lock,
      sortID = tab.sortID
    } or {
      id = showid,
      sortID = tab.sortID
    }
    self.skillTab[#self.skillTab + 1] = skilldata
  end
  table.sort(self.skillTab, function(l, r)
    return l.sortID < r.sortID
  end)
  return self.skillTab
end

function MercenaryCatData:InitMercenarySkill()
  if self.binit then
    return
  end
  self.binit = true
  local ids = self.staticData.SkillID
  self.staticSkill = {}
  for i = #ids, 1, -1 do
    local id, lv = CommonFun.UnmergeSkillID(ids[i])
    self.staticSkill[id] = {
      lv = lv,
      lock = true,
      sortID = i
    }
  end
end

function MercenaryCatData:SetDressedEquip()
  local map = GameConfig.Mercenary.EquipType[self.id]
  for i = 1, #self.curEquips do
    for k, v in pairs(map) do
      if TableUtil.ArrayIndexOf(v, self.curEquips[i]) ~= 0 then
        self[k] = self.curEquips[i]
      end
    end
  end
end

local AttriPropVO = function(t)
  local pro = RolePropsContainer.config[t]
  if nil == pro then
    errorLog(string.format("NO This Attri %s", tostring(t)))
  end
  return pro
end

function MercenaryCatData:IsCurEquip(id)
  return TableUtil.ArrayIndexOf(self.curEquips, id) ~= 0
end

function MercenaryCatData:IsSkillLocked(id)
  return TableUtil.ArrayIndexOf(self.unlockSkills, id) == 0
end

function MercenaryCatData:IsEquipUnLock(id)
  return TableUtil.ArrayIndexOf(self.unlockEquips, id) ~= 0
end
