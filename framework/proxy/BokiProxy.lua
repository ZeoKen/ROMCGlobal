BokiProxy = class("BokiProxy", pm.Proxy)
BokiProxy.Instance = nil
BokiProxy.NAME = "BokiProxy"
local BoKiDataSummary = {}
local TryBoKiDataSummary = function(enum, valueName)
  if enum then
    BoKiDataSummary[enum] = valueName
  else
    redlog("BokiProxy----> BoKiDataSummary enum is nil!", valueName)
  end
end
local GetBokiSkillId = function(family_id, level, includeStage)
  if includeStage then
    return family_id * 1000 + BokiProxy.Instance.stage * 100 + level
  else
    return family_id * 1000 + level
  end
end
local GetEquipID = function(pos, lv)
  return pos * 100 + lv
end
TryBoKiDataSummary(ScenePet_pb.EBOKIDATA_EXP, "exp")
TryBoKiDataSummary(ScenePet_pb.EBOKIDATA_LEVEL, "level")
TryBoKiDataSummary(ScenePet_pb.EBOKIDATA_STAGE, "stage")
TryBoKiDataSummary(ScenePet_pb.EBOKIDATA_RELIVE_TIME, "reliveTime")
BokiProxy.EPhase = {
  EInfancy = 1,
  EGirl = 2,
  ETeenager = 3,
  EAdult = 4
}
BokiProxy.EFollow = {
  EActive = 1,
  EInActive = 2,
  EForbid = 3
}

function BokiProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BokiProxy.NAME
  if BokiProxy.Instance == nil then
    BokiProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self._inited = false
end

function BokiProxy:InitData()
  if self._inited then
    return
  end
  self._inited = true
  self.equipMap = {}
  self.skillMap = {}
  self.equipList = {}
  self.skillList = {}
  self.mapAttrMap = {}
  self.autoSkillPosMap = {}
  self.autoSkillMap = {}
  self.bokiProps = {}
  self:InitStatic()
  ServiceScenePetProxy.Instance:CallBoKiStateQueryPetCmd()
end

local MAX_SKILL_POS
local SIX_BASE_PROPS = {
  "Str",
  "Int",
  "Dex",
  "Luk",
  "Agi",
  "Vit"
}
local _displayProps = {
  "Hp",
  "Atk",
  "Def",
  "MDef",
  "BossDamPer",
  "MonsterResPer",
  "DamSpike"
}
local _Per = "Per"

function BokiProxy:ResetBokiProps()
  TableUtility.ArrayClear(self.bokiProps)
  local myBoki = self:GetSceneBoki()
  if nil ~= myBoki then
    local displayProps = GameConfig.BoKiConfig.displayProps or _displayProps
    local bokiData = myBoki.data
    for i = 1, #displayProps do
      local kprop = RolePropsContainer.config[displayProps[i]]
      local value = bokiData:GetProperty(displayProps[i])
      if not CommonFun.checkIsNoNeedPercent(displayProps[i]) then
        local per = bokiData:GetProperty(displayProps[i] .. _Per)
        value = value * (1 + per)
      end
      self.bokiProps[#self.bokiProps + 1] = {
        displayName = kprop.displayName,
        value = value,
        isPercent = kprop.isPercent
      }
    end
  end
end

function BokiProxy:GetSceneBokiProps()
  return self.bokiProps
end

function BokiProxy:AddBoki(pets)
  for i = 1, #pets do
    if pets[i].data.ownerID == Game.Myself.data.id and pets[i].data.staticData.Type == NpcData.NpcDetailedType.Boki then
      self.myBokiGuid = pets[i].data.id
      GameFacade.Instance:sendNotification(MyselfEvent.AddBoki)
      break
    end
  end
end

function BokiProxy:RemoveBoki(guids)
  if -1 == self:GetBokiGuid() then
    return
  end
  if guids ~= nil and 0 < #guids then
    for i = 1, #guids do
      if guids[i] == self:GetBokiGuid() then
        self.myBokiGuid = nil
        GameFacade.Instance:sendNotification(MyselfEvent.RemoveBoki)
        break
      end
    end
  end
end

function BokiProxy:GetSceneBoki()
  local id = self:GetBokiGuid()
  if -1 ~= id then
    return NScenePetProxy.Instance:Find(id)
  end
  return nil
end

function BokiProxy:GetBokiGuid()
  return self.myBokiGuid or -1
end

local _hideBuff = 174819

function BokiProxy:BokiHiding(playerid)
  local boki = self:GetSceneBoki()
  if boki then
    local id = GameConfig.BoKiConfig.BokiHideBuffId or _hideBuff
    return boki:HasBuff(id)
  end
  return false
end

function BokiProxy:GetBokiReliveTime()
  return self.reliveTime
end

function BokiProxy:ClearMyBoki()
  if -1 ~= self:GetBokiGuid() then
    self.myBokiGuid = nil
    GameFacade.Instance:sendNotification(MyselfEvent.RemoveBoki)
  end
end

function BokiProxy:InitStatic()
  if nil == Table_BoKiEquip then
    redlog("BokiEquip配置未找到")
    return
  end
  MAX_SKILL_POS = GameConfig.BoKiConfig and GameConfig.BoKiConfig.SkillMaxPos or 6
  self._equipDirty = true
  self.specBuff = {}
  for _, v in pairs(Table_BoKiEquip) do
    if nil == self.specBuff[v.Pos] then
      self.specBuff[v.Pos] = {}
    end
    if #v.SpecBuff > 0 then
      local specBuffTable = {
        desc = Table_Buffer[v.SpecBuff[1]].Dsc,
        lv = v.Level
      }
      table.insert(self.specBuff[v.Pos], specBuffTable)
    end
    if v.Level == 0 then
      self.equipMap[v.Pos] = BokiEquipData.new(v.Pos, v.Level, false)
    end
  end
  for pos, tab in pairs(self.specBuff) do
    table.sort(tab, function(l, r)
      return l.lv < r.lv
    end)
  end
  local bokiMonsterID = GameConfig.BoKiConfig and GameConfig.BoKiConfig.BoKiNpcID or 300105
  self.bokiMonsterStaticData = Table_Monster[bokiMonsterID]
  self.sixBaseProps = {}
  local value
  self.checkPackage = GameConfig.BoKiConfig and GameConfig.BoKiConfig.CheckPackage or {1, 7}
end

function BokiProxy:GetSpecBuffByPos(pos)
  return self.specBuff[pos]
end

function BokiProxy:SetWaitFlag()
  self.needWaitFlag = true
end

function BokiProxy:HandleBokiQuery(data)
  self.serverInited = true
  self.exp = data.exp
  self.level = data.level
  self.nextLevelConfig = Table_BoKiLevel[data.level + 1]
  self.isMaxLevel = not self.nextLevelConfig and true or false
  self.stage = data.stage
  if data.equips then
    self._equipDirty = true
    for i = 1, #data.equips do
      local cell = data.equips[i]
      local e = BokiEquipData.new(cell.pos, cell.level, true)
      self.equipMap[e.pos] = e
    end
  end
  if data.skills then
    self._skillDirty = true
    for i = 1, #data.skills do
      local d = BokiSkillData.new(data.skills[i])
      self.skillMap[d.family_id] = d
    end
  end
  if data.skill_in_use then
    self._autoSkillDirty = true
    for i = 1, #data.skill_in_use do
      local u = BokiSkillInUseData.new(data.skill_in_use[i])
      self.autoSkillMap[u.pos] = u
    end
  end
  if self.needWaitFlag then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.BokiMainView
    })
    self.needWaitFlag = false
  end
end

function BokiProxy:GetAutoSkills()
  if self._autoSkillDirty then
    self._autoSkillDirty = false
    TableUtility.TableClear(self.autoSkillPosMap)
    for i = 1, MAX_SKILL_POS do
      local item = SkillItemData.new(0, i, nil, nil, nil, i)
      self.autoSkillPosMap[i] = item
    end
    for pos, data in pairs(self.autoSkillMap) do
      self.autoSkillPosMap[pos] = data
    end
  end
  return self.autoSkillPosMap
end

function BokiProxy:HandleBokiDataUpdate(datas)
  if nil == datas then
    return
  end
  for i = 1, #datas do
    local BoKiData = datas[i]
    if BoKiData and BoKiData.type then
      local key = BoKiDataSummary[BoKiData.type]
      if key then
        self[key] = BoKiData.value
      end
    end
  end
end

function BokiProxy:HandleEquipUpdate(equips)
  if nil == equips then
    return
  end
  self._equipDirty = true
  for i = 1, #equips do
    local pos = equips[i].pos
    if pos then
      local cell = equips[i]
      local e = BokiEquipData.new(cell.pos, cell.level, true)
      self.equipMap[e.pos] = e
    end
  end
end

function BokiProxy:HandleSkillUpdate(skills)
  if nil == skills then
    return
  end
  self._skillDirty = true
  for i = 1, #skills do
    local d = BokiSkillData.new(skills[i])
    self.skillMap[d.family_id] = d
  end
end

function BokiProxy:GetBokiSkillLv(familyid)
  local skillData = self.skillMap[familyid]
  if nil ~= skillData then
    return skillData.serverLevel
  end
  return 0
end

function BokiProxy:GetSkills()
  if self._skillDirty then
    self._skillDirty = false
    TableUtility.ArrayClear(self.skillList)
    TableUtility.TableClear(self.mapAttrMap)
    for _, v in pairs(self.skillMap) do
      self.skillList[#self.skillList + 1] = v
      if v.mapAttrStaticData then
        local category = v.mapAttrStaticData.category
        if nil == self.mapAttrMap[category] then
          self.mapAttrMap[category] = {}
        end
        table.insert(self.mapAttrMap[category], v.mapAttrStaticData)
      end
    end
  end
  return self.skillList
end

function BokiProxy:GetMapAttrSkills()
  local result = {}
  if nil ~= self.mapAttrMap then
    for category, value in pairs(self.mapAttrMap) do
      result[#result + 1] = value
    end
  end
  return result
end

function BokiProxy:HandleSkillInUseUpdate(skills)
  self._autoSkillDirty = true
  for i = 1, #skills do
    local u = BokiSkillInUseData.new(skills[i])
    self.autoSkillMap[u.pos] = u
  end
end

function BokiProxy:HandleSetBoKiStateUserCmd(state)
  self.bokiFollowState = state
end

function BokiProxy:GetFollowState()
  return self.bokiFollowState
end

function BokiProxy:DoEquipLvup(pos)
  helplog("BokiProxy:CallBoKiEquipLevelUpPetCmd pos : ", pos)
  ServiceScenePetProxy.Instance:CallBoKiEquipLevelUpPetCmd(pos)
end

function BokiProxy:DoSetSkillInuse(skills)
  ServiceScenePetProxy.Instance:CallBoKiSkillInUseSetPetCmd(skills)
end

function BokiProxy:OpenBokiView(igoreBokiCreature)
  if igoreBokiCreature or nil ~= self:GetSceneBoki() then
    if self.serverInited then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BokiMainView
      })
    else
      redlog("跨服切线时服务器可能不发初始化数据，待后端统一修复")
      self.needWaitFlag = true
      ServiceScenePetProxy.Instance:CallBoKiStateQueryPetCmd()
    end
  end
end

function BokiProxy:HasBoki()
  return nil ~= self.stage
end

function BokiProxy:HasLearnSkill(id)
  if not id then
    return false
  end
  if nil ~= self.skillMap and nil ~= self.skillMap[id] and self.skillMap[id].learned then
    return true
  end
  return false
end

function BokiProxy:GetSkillIdByFamilyId(id)
  if self.skillMap and self.skillMap[id] and self.skillMap[id].learned then
    return self.skillMap[id]
  end
end

function BokiProxy:GetEquipList()
  if self._equipDirty then
    self._equipDirty = false
    TableUtility.ArrayClear(self.equipList)
    for _, v in pairs(self.equipMap) do
      self.equipList[#self.equipList + 1] = v
    end
  end
  return self.equipList
end

function BokiProxy:GetSkillId(family_id, level, includeStage)
  if includeStage then
    return family_id * 1000 + self.stage * 100 + level
  else
    return family_id * 1000 + level
  end
end

function BokiProxy:CheckSkillAllMax()
  if self.isSkillAllMax then
    return true
  end
  if not self.skillMap then
    return false
  end
  for _, v in pairs(self.skillMap) do
    if v.level < v.maxLevel then
      return false
    end
  end
  self.isSkillAllMax = true
  return true
end

local MAX = math.max
BokiEquipData = class("BokiEquipData")

function BokiEquipData:ctor(pos, lv, unlock)
  self.pos = pos
  self.level = lv
  self.unlock = unlock
  self.totalAttrMap = {}
  self.BoKiEquipId = GetEquipID(pos, lv)
  self.staticData = Table_BoKiEquip[self.BoKiEquipId]
  if nil == self.staticData then
    redlog("BokiEquip配置未找到 pos | level |   ", pos, lv)
    return
  end
  self:InitCost()
  local nextLvID = GetEquipID(pos, lv + 1)
  self.nextLvStaticData = Table_BoKiEquip[nextLvID]
  local specBuff = self:GetNewSpecBuff()
  self.newSpecDesc = specBuff and Table_Buffer[specBuff].Dsc
  self.itemId = self.staticData.ItemID
  if nil == self.itemId or nil == Table_Item[self.itemId] then
    redlog("Table_BoKiEquip ItemID 配置错误 ，id: ", self.BoKiEquipId)
  end
  self.lvupCost = self.staticData.LevelUpCost
  self.maxLv = 0
  for k, v in pairs(Table_BoKiEquip) do
    if v.Pos == self.pos then
      self.maxLv = MAX(self.maxLv, v.Level)
    end
  end
  self.isMaxLv = self.maxLv == self.level
  self:SetCurTotalAttr()
  if nil ~= self.nextLvStaticData then
    self.nextAttrMap = {}
    local buffIDs = Table_BoKiEquip[nextLvID].AttrBuff
    for i = 1, #buffIDs do
      local config = Table_Buffer[buffIDs[i]]
      if config.BuffEffect and config.BuffEffect.type == "AttrChange" then
        for key, value in pairs(config.BuffEffect) do
          local kprop = RolePropsContainer.config[key]
          if kprop and kprop.displayName and 0 < value then
            local oldValue = self.totalAttrMap[kprop.displayName] and self.totalAttrMap[kprop.displayName].value
            if nil ~= oldValue then
              self.nextAttrMap[kprop.displayName] = {
                original = oldValue,
                new = value + oldValue,
                isPercent = kprop.isPercent
              }
            end
          end
        end
      end
    end
  end
end

function BokiEquipData:SetCurTotalAttr()
  for lv = 0, self.level do
    local equipId = GetEquipID(self.pos, lv)
    local buffIDs = Table_BoKiEquip[equipId].AttrBuff
    for i = 1, #buffIDs do
      local config = Table_Buffer[buffIDs[i]]
      if config.BuffEffect and config.BuffEffect.type == "AttrChange" then
        for key, value in pairs(config.BuffEffect) do
          local kprop = RolePropsContainer.config[key]
          if kprop and kprop.displayName and 0 < value then
            if nil == self.totalAttrMap[kprop.displayName] then
              self.totalAttrMap[kprop.displayName] = {
                value = value,
                isPercent = kprop.isPercent
              }
            else
              self.totalAttrMap[kprop.displayName] = {
                value = value + self.totalAttrMap[kprop.displayName].value,
                isPercent = kprop.isPercent
              }
            end
          end
        end
      end
    end
  end
end

function BokiEquipData:InitCost()
  local costs = self.staticData and self.staticData.LevelUpCost
  if not costs then
    return
  end
  self.costData = {}
  for i = 1, #costs do
    local itemdata = ItemData.new("bokiEquipCost", costs[i].item)
    itemdata:SetItemNum(costs[i].count)
    self.costData[#self.costData + 1] = itemdata
  end
end

function BokiEquipData:GetCostData()
  return self.costData or {}
end

function BokiEquipData:GetLvupCost()
  if not self.isMaxLv then
    return self.lvupCost
  end
end

function BokiEquipData:GetNewSpecBuff()
  if nil ~= self.nextLvStaticData and self.nextLvStaticData.SpecBuff and #self.nextLvStaticData.SpecBuff > 0 then
    return self.nextLvStaticData.SpecBuff[1]
  end
end

function BokiEquipData:GetNextAttr()
  if nil ~= self.nextLvStaticData then
    return self.nextLvStaticData.AttrBuff
  end
end

autoImport("SkillItemData")
BokiSkillInUseData = class("BokiSkillInUseData", SkillItemData)

function BokiSkillInUseData:ctor(data)
  self.pos = data.pos
  BokiSkillData.super.ctor(self, data.id)
end

BokiSkillData = class("BokiSkillData", SkillItemData)

function BokiSkillData:ctor(data)
  self.family_id = data.family_id
  self.serverLevel = data.level
  local lv = data.level == 0 and data.level + 1 or data.level
  local includeStage = 0 == TableUtility.ArrayFindIndex(GameConfig.BoKiConfig.StageNoDiffSkill, data.family_id)
  local id = GetBokiSkillId(data.family_id, lv, includeStage)
  BokiSkillData.super.ctor(self, id)
  self.light = data.light
  if 0 == data.level then
    self:SetLearned(false)
  else
    self:SetLearned(data.light)
  end
  if nil == Table_Skill[id] then
    redlog("波姬技能ID未找到 family_id ｜ lv  |  ", data.family_id, lv)
  end
  self.mapAttrStaticData = Table_MapAttrDisplay[data.family_id * 1000 + data.level]
end
