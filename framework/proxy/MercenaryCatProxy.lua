autoImport("MercenaryCatData")
MercenaryCatProxy = class("MercenaryCatProxy", pm.Proxy)
MercenaryCatProxy.Instance = nil
MercenaryCatProxy.NAME = "MercenaryCatProxy"
MercenaryCatProxy.CFGEquipData = GameConfig.Mercenary and GameConfig.Mercenary.EquipType

function MercenaryCatProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MercenaryCatProxy.NAME
  if MercenaryCatProxy.Instance == nil then
    MercenaryCatProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function MercenaryCatProxy:Init()
  self.mercenaryCat = {}
  self:InitStaticData()
  self.equipMap = {}
  self.catSkillAutoCastMap = {}
  self:SetEquipItems()
end

function MercenaryCatProxy:GetMercenaryLv()
  return self.mercenaryLv or 0
end

function MercenaryCatProxy:GetNextLvSkills()
  local lv = self:GetMercenaryLv()
  return Table_MercenaryCatLevel[lv + 1] and Table_MercenaryCatLevel[lv + 1].Skills
end

function MercenaryCatProxy:HandleCatEquipInfo(serverdata)
  if not serverdata.update then
    self:InitStaticData()
  end
  self.mercenaryLv = serverdata.lv
  if nil ~= Table_MercenaryCatLevel then
    local infoStatic = Table_MercenaryCatLevel[self.mercenaryLv]
    if infoStatic then
      for k, v in pairs(self.mercenaryCat) do
        v:SetUnlockSkills(infoStatic.Skills[k])
      end
    end
    if self.mercenaryLv < #Table_MercenaryCatLevel then
      self.totalExp = Table_MercenaryCatLevel[self.mercenaryLv + 1].Exp
    end
  end
  if serverdata.infos then
    for i = 1, #serverdata.infos do
      self.mercenaryCat[serverdata.infos[i].id]:SetServerData(serverdata.infos[i])
    end
  end
end

function MercenaryCatProxy:GetExpSliderValue()
  self.mercenaryExp = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.WEAPONPET_EXP) or 0
  if self.mercenaryExp and self.totalExp then
    return self.mercenaryExp / self.totalExp
  else
    return 1
  end
end

function MercenaryCatProxy:SetEquipItems()
  if not MercenaryCatProxy.CFGEquipData then
    return
  end
  for k, v in pairs(MercenaryCatProxy.CFGEquipData) do
    if nil == self.equipMap[k] then
      self.equipMap[k] = {}
    end
    self.equipMap[k] = v
  end
end

function MercenaryCatProxy:SetCurChooseCat(var)
  self.chooseCat = var
end

function MercenaryCatProxy:GetEquips(site)
  return self.equipMap[self.chooseCat.id][site]
end

function MercenaryCatProxy:IsEquipUnLock(id)
  if self.chooseCat then
    return self.chooseCat:IsEquipUnLock(id)
  end
  return false
end

function MercenaryCatProxy:GetMercenaryCat()
  local data = {}
  for k, v in pairs(self.mercenaryCat) do
    data[#data + 1] = v
  end
  return data
end

function MercenaryCatProxy:GetMercenaryCatById(id)
  return self.mercenaryCat[id]
end

function MercenaryCatProxy:InitStaticData()
  TableUtility.TableClear(self.mercenaryCat)
  for k, v in pairs(Table_MercenaryCat) do
    local data = MercenaryCatData.new(v.id)
    self.mercenaryCat[data.id] = data
  end
  table.sort(self.mercenaryCat, function(l, r)
    if l.menuOpen and r.menuOpen then
      return l.id < r.id
    end
    if l.menuOpen or r.menuOpen then
      return l.menuOpen
    end
    if l.menuOpen == false and r.menuOpen == false then
      return l.id < r.id
    end
    return l.id < r.id
  end)
end

function MercenaryCatProxy:HandleCatSkillOptionPetCmd(skillsortids)
  TableUtility.TableClear(self.catSkillAutoCastMap)
  for i = 1, #skillsortids do
    self.catSkillAutoCastMap[skillsortids[i]] = true
  end
end

function MercenaryCatProxy:IsCatSkillAutoCast(skillSortID)
  return self.catSkillAutoCastMap[skillSortID] == true
end

function MercenaryCatProxy:SetCatSkillAutoCast(skillSortID, value)
  ServiceScenePetProxy.Instance:CallCatSkillOptionPetCmd(skillSortID, value)
end
