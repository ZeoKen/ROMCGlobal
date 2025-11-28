autoImport("GemPageData")
autoImport("UserGemInfo")
autoImport("GemSecretLandData")
GemProxy = class("GemProxy", pm.Proxy)
GemProxy.MultiComposeRowCount = 10
GemProxy.PageSkillCellCountSaveKey = "GemPageSkillCellCount"
GemProxy.PackageCheck = {
  14,
  15,
  21
}
GemProxy.BannedQualityFuncStateId = 149
GemProxy.SculptNeedGemSpriteNames = {
  "Rune_iconS_attack",
  "Rune_iconS_life",
  "Rune_iconS_special",
  [0] = "Rune_iconS_white"
}
local bagIns, tempTable, tempArr, arrayPushBack, arrayFindIndex, arrayClear, tableClear, tableShallowCopy
local maxInt = 2.147483648E9
local _GemEffectSortFunc = function(l, r)
  return l.id < r.id
end
local _SameNameEmbeddedPredicate = function(key, data, itemData)
  return GemProxy.CheckIsSameName(data, itemData)
end
local _NewGemResultComparer = function(l, r)
  l = GemProxy.GetSkillQualityFromItemData(l) or 0
  r = GemProxy.GetSkillQualityFromItemData(r) or 0
  return l > r
end
local _SkillQualityAndProfessionPredicate = function(item, q, p, favorToggle)
  if not GemProxy.CheckContainsGemSkillData(item) then
    return false
  end
  if not GemProxy.CheckCharIdIsValid(item.gemSkillData) then
    return false
  end
  if favorToggle and favorToggle.value and not GemProxy.CheckIsFavorite(item) then
    return false
  end
  local id = item.staticData and item.staticData.id
  local staticGemData = item.staticData and Table_GemRate[id]
  if not staticGemData then
    return false
  end
  local qType, pType = type(q), type(p)
  local qualityFlag = qType == "nil" or qType == "table" and (not next(q) or arrayFindIndex(q, staticGemData.Quality) > 0) or qType == "number" and (q == 0 or staticGemData.Quality == q)
  local profFlag = pType == "nil" or pType == "table" and (not next(p) or GemProxy.Instance:CheckIfSkillGemHasSameProfessions(id, p)) or pType == "number" and GemProxy.Instance:CheckIfSkillGemIncludesProfession(id, p)
  return qualityFlag and profFlag
end
local _AttributeTypePredicate = function(item, t)
  if not GemProxy.CheckContainsGemAttrData(item) then
    return false
  end
  if not GemProxy.CheckCharIdIsValid(item.gemAttrData) then
    return false
  end
  if not t or t == 0 then
    return true
  end
  return item.gemAttrData:GetStaticDataOfCurLevel().Type == t
end
local _SecretLandTypePredicate = function(item, t, favorToggle)
  if not GemProxy.CheckContainsGemSecretLandData(item) then
    return false
  end
  if not GemProxy.CheckCharIdIsValid(item.secretLandDatas) then
    return false
  end
  if favorToggle and favorToggle.value and not GemProxy.CheckIsFavorite(item) then
    return false
  end
  if GemProxy.Instance:IsEmbedded(item.id) then
    return false
  end
  if "number" == type(t) and 0 < t and t ~= item.secretLandDatas.color then
    return false
  end
  return true
end
GemProxy.SceretLandColor = {
  Red = SceneItem_pb.ESECRETLANDGEMCOLOR_RED,
  Yellow = SceneItem_pb.ESECRETLANDGEMCOLOR_YELLOW
}
GemProxy.GemPackageType = {
  [SceneItem_pb.EPACKTYPE_GEM_ATTR] = 1,
  [SceneItem_pb.EPACKTYPE_GEM_SKILL] = 1,
  [SceneItem_pb.EPACKTYPE_GEM_SECRETLAND] = 1
}
GemProxy.GemType = {
  [SceneItem_pb.EGEMTYPE_ATTR] = 1,
  [SceneItem_pb.EGEMTYPE_SKILL] = 1,
  [SceneItem_pb.EGEMTYPE_SECRETLAND] = 1
}

function GemProxy.IsGemPackage(t)
  return nil ~= GemProxy.GemPackageType[t]
end

function GemProxy.IsGemType(t)
  return nil ~= GemProxy.GemType[t]
end

function GemProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "GemProxy"
  if not GemProxy.Instance then
    GemProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function GemProxy:Init()
  tempTable = {}
  tempArr = {}
  arrayPushBack = TableUtility.ArrayPushBack
  arrayFindIndex = TableUtility.ArrayFindIndex
  arrayClear = TableUtility.ArrayClear
  tableClear = TableUtility.TableClear
  tableShallowCopy = TableUtility.TableShallowCopy
  if not GemSkillQualityMap then
    GemSkillQualityMap = {}
    for i = 1, 4 do
      GemSkillQualityMap[i] = ZhString["Gem_SkillQuality" .. i]
    end
  end
  self:PreprocessNoSmeltProfs()
  self:AddEventListeners()
  self:InitAttributeGemStaticData()
  self:InitSkillGemStaticData()
  self:InitStaticSecretLand()
  self:InitFilters()
  self:InitGemPageAttributeCellNeighborMap()
  self:InitGemPageData()
  self:InitUserGem()
end

function GemProxy:PreprocessNoSmeltProfs()
  self.config_NoSmeltProfMap = {}
  local config = GameConfig.Gem.NoSmeltProfs
  if not config then
    return
  end
  for k, id in pairs(config) do
    self.config_NoSmeltProfMap[id] = 1
  end
end

function GemProxy:InitStaticSecretLand()
  self:InitSecretLandGemLvUp()
  self:InitSecretLandGem()
end

function GemProxy.CheckGemForbidden(t)
  return FunctionUnLockFunc.CheckForbiddenByFuncState("gem_forbidden", t)
end

function GemProxy.CheckAllGemForbidden()
  for _, v in pairs(GemProxy.PackageCheck) do
    if not GemProxy.CheckGemForbidden(v) then
      return false
    end
  end
  return true
end

function GemProxy.QueryPackage(reinit)
  if GemProxy.CheckAllGemForbidden() then
    return
  end
  local _itemProxy = ServiceItemProxy.Instance
  if not GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_ATTR) then
    _itemProxy:CallPackageItem(SceneItem_pb.EPACKTYPE_GEM_ATTR, reinit)
  end
  if not GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SKILL) then
    _itemProxy:CallPackageItem(SceneItem_pb.EPACKTYPE_GEM_SKILL, reinit)
  end
  if not GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND) then
    _itemProxy:CallPackageItem(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND, reinit)
  end
end

function GemProxy:CheckNoviceServerCanOpen()
  if not FunctionUnLockFunc.checkFuncStateValid(203) then
    return true
  end
  return false
end

function GemProxy:InitSecretLandGemLvUp()
  self.lvUpConfig = {}
  self.maxSecretLandLv = 2
  if not Table_SecretLandGemLvUp then
    return
  end
  for k, v in pairs(Table_SecretLandGemLvUp) do
    self.lvUpConfig[v.id] = v
    self.maxSecretLandLv = math.max(self.maxSecretLandLv, v.id)
  end
end

function GemProxy:InitSecretLandGem()
  self.embeddedSecretLandTypeCount = {}
  self.embeddedSecretLandPosColorMap = {}
  self.allSecretLandGemMap = {}
  self.allSecretLandGem = {}
  self.secretLandItemID2ConfigID = {}
  self.allSecretLandGemCount = 0
  if not Table_SecretLandGem then
    redlog("GemProxy:InitSecretLandGem() Table_SecretLandGem is nil")
    return
  end
  for k, v in pairs(Table_SecretLandGem) do
    local data = GemSecretLandData.new(v.id)
    self.allSecretLandGemMap[data.id] = data
    self.secretLandItemID2ConfigID[v.ItemID] = v.id
    self.allSecretLandGemCount = self.allSecretLandGemCount + 1
  end
  self.secretLandGemDirty = true
end

function GemProxy:GetSecretLandID(itemid)
  return self.secretLandItemID2ConfigID[itemid]
end

function GemProxy:GetAllSecretLandGem()
  if self.secretLandGemDirty then
    local bagData = BagProxy.Instance:GetSecretLandBagData()
    local items = bagData:GetItems()
    for i = 1, #items do
      local id = items[i].secretLandDatas.id
      if self.allSecretLandGemMap[id] then
        self.allSecretLandGemMap[id] = items[i].secretLandDatas
      end
    end
    TableUtility.ArrayClear(self.allSecretLandGem)
    for k, v in pairs(self.allSecretLandGemMap) do
      TableUtility.ArrayPushBack(self.allSecretLandGem, v)
    end
    self.secretLandGemDirty = false
  end
  return self.allSecretLandGem
end

function GemProxy:GetSecretLand(id)
  return self.allSecretLandGemMap[id]
end

function GemProxy.GetMaximumSkillCost()
  if not GemProxy.MaximumSkillCost then
    GemProxy.MaximumSkillCost = {}
    GemProxy.MaximumSkillCost[1] = GameConfig.Gem.FullGemSkillCost[1][1]
    GemProxy.MaximumSkillCost[2] = GameConfig.Gem.FullGemSkillCost[1][2]
  end
  return GemProxy.MaximumSkillCost
end

function GemProxy:GetSecretLandGem(t, isSecretLandSortOrderDescending)
  local result = {}
  local allSecretLandGem = self:GetAllSecretLandGem()
  if t then
    for i = 1, #allSecretLandGem do
      if not t or t == 0 or t == allSecretLandGem[i].color then
        result[#result + 1] = allSecretLandGem[i]
      end
    end
  end
  table.sort(result, function(a, b)
    if a.sortId == b.sortId then
      if a.lv == b.lv then
        if a.color == b.color then
          return a.sData.ItemID < b.sData.ItemID
        else
          return a.color < b.color
        end
      elseif isSecretLandSortOrderDescending then
        return a.lv > b.lv
      else
        return a.lv < b.lv
      end
    else
      return a.sortId < b.sortId
    end
  end)
  return result
end

function GemProxy:GetStaticLvUp(lv)
  return self.lvUpConfig[lv]
end

function GemProxy:AddEventListeners()
  EventManager.Me():AddEventListener(ItemEvent.GemUpdate, self.OnGemUpdate, self)
  EventManager.Me():AddEventListener(ItemEvent.SecretLandUpdate, self.OnSecretGemUpdate, self)
end

function GemProxy:InitSkillGemStaticData()
  self:InitSkillGemEffectStaticData()
  self:InitSkillGemParamStaticData()
  self:InitSkillGemProfessionStaticData()
  self:InitSkillGemQualityGroupData()
end

function GemProxy:InitFilters()
  self.newProfessionFilterData = {}
  GemAttributeFilter = {
    ZhString.Gem_FilterAllGem,
    ZhString.Gem_FilterAttributeAtk,
    ZhString.Gem_FilterAttributeDef,
    ZhString.Gem_FilterAttributeSpc
  }
  self:InitSkillQualityFilter()
  GemSecretLandFilter = {
    ZhString.Gem_FilterAllGem,
    ZhString.Gem_FilterSecretLand_Atk,
    ZhString.Gem_FilterSecretLand_Common
  }
  GemSecretLandFilterData = {
    0,
    10001,
    10002
  }
end

function GemProxy:InitViewQualityFilter()
  GemProxy.QualityTogs = {
    AllTab = {
      key = 0,
      value = GemSkillQualityFilter[1]
    },
    StarTab = {
      key = 4,
      value = GemSkillQualityFilter[5]
    },
    STab = {
      key = 3,
      value = GemSkillQualityFilter[4]
    },
    ATab = {
      key = 2,
      value = GemSkillQualityFilter[3]
    },
    BTab = {
      key = 1,
      value = GemSkillQualityFilter[2]
    }
  }
  GemProxy.MaximumSkillQualityTogs = {
    AllTab = {
      key = {3, 4},
      value = GemSkillQualityFilter[1]
    },
    StarTab = {
      key = 4,
      value = GemSkillQualityFilter[5]
    },
    STab = {
      key = 3,
      value = GemSkillQualityFilter[4]
    }
  }
end

function GemProxy:InitSkillQualityFilter()
  GemSkillQualityFilter = {
    ZhString.Gem_FilterAllGem
  }
  GemSkillQualityFilterData = {
    {}
  }
  local newIndex, filterData
  for i = 1, #GemSkillQualityMap do
    newIndex = arrayFindIndex(GemSkillQualityFilter, GemSkillQualityMap[i])
    if newIndex == 0 then
      newIndex = #GemSkillQualityFilter + 1
    end
    GemSkillQualityFilter[newIndex] = GemSkillQualityMap[i]
    filterData = GemSkillQualityFilterData[newIndex] or {}
    arrayPushBack(filterData, i)
    GemSkillQualityFilterData[newIndex] = filterData
  end
  self:InitViewQualityFilter()
end

function GemProxy:CheckProfessionInvalid(class_id)
  local needCheckPro = Game.Config_ProfessionForbidMap[class_id]
  if needCheckPro and not FunctionUnLockFunc.checkFuncStateValid(needCheckPro) then
    return true
  end
  return false
end

function GemProxy:CheckGemRateValid(id)
  local staticData = Table_GemRate[id]
  if staticData and staticData.ClassType then
    for i = 1, #staticData.ClassType do
      if not self:CheckProfessionInvalid(staticData.ClassType[i]) then
        return true
      end
    end
  end
  return false
end

function GemProxy:InitSkillProfessionFilter()
  if self.skillProfessionFiterInited then
    return
  end
  self.skillProfessionFiterInited = true
  GemSkillProfessionFilter = {
    ZhString.Gem_FilterAllProfession
  }
  GemSkillProfessionFilterData = {
    {}
  }
  tableClear(tempTable)
  arrayClear(tempArr)
  local tb, profArr
  for _, data in pairs(self.skillProfessionStaticData) do
    for p, _ in pairs(data) do
      tb = Table_Class[p] and Table_Class[p].TypeBranch
      if tb then
        profArr = tempTable[tb] or {}
        if arrayFindIndex(profArr, p) == 0 then
          arrayPushBack(profArr, p)
        end
        tempTable[tb] = profArr
      end
    end
  end
  for _, data in pairs(tempTable) do
    table.sort(data)
    arrayPushBack(tempArr, data)
  end
  table.sort(tempArr, function(l, r)
    return l[1] < r[1]
  end)
  local classId
  local classIds = {}
  local heroClassIds = {}
  local myGender = MyselfProxy.Instance:GetMySex()
  for i = 1, #tempArr do
    classId = tempArr[i][1]
    if not self:CheckProfessionInvalid(classId) then
      if ProfessionProxy.IsHero(classId) then
        arrayPushBack(heroClassIds, classId)
      else
        arrayPushBack(classIds, classId)
      end
      arrayPushBack(GemSkillProfessionFilter, ProfessionProxy.GetProfessionName(classId, myGender))
      arrayPushBack(GemSkillProfessionFilterData, tempArr[i])
    end
  end
  NewGemSkillProfessionData = {}
  arrayPushBack(NewGemSkillProfessionData, 0)
  arrayPushBack(NewGemSkillProfessionData, ZhString.Gem_ProfessionType)
  local adventureClassID, heroClassID = {}, {}
  for i = 1, #classIds, 3 do
    local singleAdventure = {}
    singleAdventure[1] = classIds[i]
    singleAdventure[2] = classIds[i + 1]
    singleAdventure[3] = classIds[i + 2]
    arrayPushBack(NewGemSkillProfessionData, singleAdventure)
  end
  if 0 < #heroClassIds then
    arrayPushBack(NewGemSkillProfessionData, ZhString.Gem_HeroProfessionType)
  end
  for i = 1, #heroClassIds, 3 do
    local singleHero = {}
    singleHero[1] = heroClassIds[i]
    singleHero[2] = heroClassIds[i + 1]
    singleHero[3] = heroClassIds[i + 2]
    arrayPushBack(NewGemSkillProfessionData, singleHero)
  end
end

function GemProxy:SetCurTargetProfession(classid)
  self.targetProfession = classid
end

function GemProxy:SetCurNewProfessionFilterData(classid)
  self.newProfession = classid
  local mySex = MyselfProxy.Instance:GetMySex()
  self.newProfessionName = classid == 0 and ZhString.Gem_FilterAllProfession or ProfessionProxy.GetProfessionName(classid, mySex)
  self.newProfessionFilterData = self:GetCurSkillProfessionFilterData(classid)
end

function GemProxy:GetCurProfressionName()
  return self.newProfessionName or ZhString.Gem_FilterAllProfession
end

function GemProxy:SetTargetProChooseFlag()
  self.startChooseTargetProfession = true
end

function GemProxy:ClearTargetProChooseFlag()
  self.startChooseTargetProfession = nil
end

function GemProxy:GetCurNewProfession()
  return self.newProfession
end

function GemProxy:GetCurNewProfessionFilterData()
  return self.newProfessionFilterData
end

function GemProxy:GetCurSkillProfessionFilterData(classid)
  self.newProfessionFilterMapData = self.newProfessionFilterMapData or {}
  local data = self.newProfessionFilterMapData[classid]
  if not data then
    local find = false
    for i = 1, #GemSkillProfessionFilterData do
      local profArray = GemSkillProfessionFilterData[i]
      for i = 1, #profArray do
        if profArray[i] == classid then
          self.newProfessionFilterMapData[classid] = profArray
          find = true
          break
        end
      end
      if find then
        break
      end
    end
  end
  return self.newProfessionFilterMapData[classid]
end

function GemProxy:GetMyFirstProfession()
  local myPro = MyselfProxy.Instance:GetMyProfession()
  local array = self:GetCurSkillProfessionFilterData(myPro)
  if array then
    return array[1]
  end
end

function GemProxy:InitAttributeGemStaticData()
  self.attributeStaticData = {}
  local gemId, lv
  for id, data in pairs(Table_GemUpgrade) do
    gemId = math.floor(id / 100)
    lv = id - gemId * 100
    self.attributeStaticData[gemId] = self.attributeStaticData[gemId] or {}
    self.attributeStaticData[gemId][lv] = data
  end
end

function GemProxy:InitSkillGemEffectStaticData()
  self.skillEffectStaticData = {}
  for _, data in pairs(Table_GemEffect) do
    if data.GemID then
      self.skillEffectStaticData[data.GemID] = self.skillEffectStaticData[data.GemID] or {}
      arrayPushBack(self.skillEffectStaticData[data.GemID], data)
    end
  end
  for _, data in pairs(self.skillEffectStaticData) do
    if next(data) then
      table.sort(data, _GemEffectSortFunc)
    end
  end
end

function GemProxy:InitSkillGemParamStaticData()
  self.skillParamStaticData = {}
  local paramStaticData, data
  for i = 1, #Table_GemParam do
    data = Table_GemParam[i]
    self.skillParamStaticData[data.ParamID] = self.skillParamStaticData[data.ParamID] or {}
    paramStaticData = self.skillParamStaticData[data.ParamID]
    if not paramStaticData.min then
      paramStaticData.min = data.Nor_Min
    end
    paramStaticData.max = data.Nor_Max
    if not paramStaticData.isPercent then
      paramStaticData.isPercent = data.IsPercent ~= nil and data.IsPercent > 0 and true or false
    end
    paramStaticData.list = paramStaticData.list or {}
    arrayPushBack(paramStaticData.list, data)
  end
end

function GemProxy:InitSkillGemProfessionStaticData()
  self.skillProfessionStaticData = {}
  local profMap
  for _, data in pairs(Table_GemRate) do
    profMap = {}
    if data.ClassType and next(data.ClassType) then
      for _, ct in pairs(data.ClassType) do
        profMap[ct] = true
      end
    end
    self.skillProfessionStaticData[data.id] = profMap
  end
end

function GemProxy:InitSkillGemQualityGroupData()
  self.skillQualityGroupMap = {}
  self.skillQualityGroupProfGemIdMap = {}
  for group, qualities in pairs(GameConfig.Gem.Group) do
    for _, q in pairs(qualities) do
      self.skillQualityGroupMap[q] = group
      if group ~= 1 then
        self.skillQualityGroupProfGemIdMap[group] = {}
      end
    end
  end
  local profGemIdMap
  for gemId, sData in pairs(Table_GemRate) do
    profGemIdMap = self.skillQualityGroupProfGemIdMap[self.skillQualityGroupMap[sData.Quality]]
    if profGemIdMap then
      for _, prof in pairs(sData.ClassType) do
        profGemIdMap[prof] = profGemIdMap[prof] or {}
        arrayPushBack(profGemIdMap[prof], gemId)
      end
    end
  end
end

function GemProxy:InitGemPageAttributeCellNeighborMap()
  self.gemPageAttributeCellNeighborMap = self.gemPageAttributeCellNeighborMap or {}
  self.pageSkillGemMaxCount, self.pageAttrGemMaxCount = 0, 0
  for skillCellId, skillCellNeighborIds in pairs(GameConfig.Gem.Page) do
    self.pageSkillGemMaxCount = self.pageSkillGemMaxCount + 1
    for _, attrCellId in pairs(skillCellNeighborIds) do
      self.gemPageAttributeCellNeighborMap[attrCellId] = self.gemPageAttributeCellNeighborMap[attrCellId] or {}
      arrayPushBack(self.gemPageAttributeCellNeighborMap[attrCellId], skillCellId)
    end
  end
  for _, _ in pairs(self.gemPageAttributeCellNeighborMap) do
    self.pageAttrGemMaxCount = self.pageAttrGemMaxCount + 1
  end
end

function GemProxy:InitGemPageData()
  self.gemPageData = GemPageData.new()
  self.embeddedGemAvailableMap = {}
end

function GemProxy:InitUserGem()
  self.userGemMap = {}
end

local oldEmbeddedGemAvailableMap = {}

function GemProxy:OnGemUpdate()
  tableClear(oldEmbeddedGemAvailableMap)
  tableShallowCopy(oldEmbeddedGemAvailableMap, self.embeddedGemAvailableMap)
  self:UpdateAvailability()
  self:CompareAvailabilityWithOld()
end

function GemProxy:OnSecretGemUpdate()
  self.secretLandGemDirty = true
end

function GemProxy:UpdateAvailability()
  tableClear(self.embeddedSecretLandPosColorMap)
  tableClear(self.embeddedGemAvailableMap)
  local datas, pos = self.GetSkillItemData()
  for _, data in pairs(datas) do
    pos = data.gemSkillData.available and GemProxy.GetEmbeddedPosition(data)
    if pos and 0 < pos then
      self.embeddedGemAvailableMap[data.id] = pos
    end
  end
  datas = self.GetAttributeItemData()
  for _, data in pairs(datas) do
    pos = GemProxy.GetEmbeddedPosition(data)
    if 0 < pos then
      self.embeddedGemAvailableMap[data.id] = pos
    end
  end
  datas = self.GetSecretLandItemDataByType()
  for _, data in pairs(datas) do
    pos = data.secretLandDatas and data.secretLandDatas and data.secretLandDatas:GetPos()
    if 0 < pos then
      self.embeddedGemAvailableMap[data.id] = pos
      local color = data.secretLandDatas.color
      self.embeddedSecretLandPosColorMap[pos] = color
    end
  end
end

function GemProxy:CheckSecretLandIsEmbedded(pos)
  return nil ~= self.embeddedSecretLandPosColorMap[pos]
end

function GemProxy:SetContainerViewOpen(var)
  self.containerViewIsOpen = var
end

function GemProxy:IsContainerViewOpen()
  return self.containerViewIsOpen == true
end

function GemProxy:CheckSecretLandTypeInvalid(itemData)
  if not GemProxy.CheckContainsGemSecretLandData(itemData) then
    return false
  end
  tableClear(self.embeddedSecretLandTypeCount)
  local colorLimit = GameConfig.Gem.SecretLandGemColorLimit or 2
  local invalidColor
  for k, _ in pairs(GameConfig.Gem.SecretLandGemPos) do
    if k ~= self.choosePageCellID then
      local color = self.embeddedSecretLandPosColorMap[k]
      if color then
        local cnt = self.embeddedSecretLandTypeCount[color]
        if not cnt then
          self.embeddedSecretLandTypeCount[color] = 1
        else
          self.embeddedSecretLandTypeCount[color] = cnt + 1
        end
      end
      if self.embeddedSecretLandTypeCount[color] == colorLimit then
        invalidColor = color
        break
      end
    end
  end
  local color = itemData and itemData.secretLandDatas.color
  if color and invalidColor == color then
    return true
  end
  return false
end

function GemProxy:IsEmbedded(id)
  return nil ~= id and nil ~= self.embeddedGemAvailableMap[id]
end

function GemProxy:CompareAvailabilityWithOld()
  local changed
  for id, _ in pairs(oldEmbeddedGemAvailableMap) do
    if self.embeddedGemAvailableMap[id] ~= oldEmbeddedGemAvailableMap[id] then
      changed = true
      break
    end
  end
  if not changed then
    for id, _ in pairs(self.embeddedGemAvailableMap) do
      if oldEmbeddedGemAvailableMap[id] ~= self.embeddedGemAvailableMap[id] then
        changed = true
        break
      end
    end
  end
  if changed then
    self:UpdateGemPageData()
  end
end

function GemProxy:UpdateGemPageData()
  arrayClear(tempArr)
  for id, _ in pairs(self.embeddedGemAvailableMap) do
    arrayPushBack(tempArr, bagIns:GetItemByGuid(id, self.PackageCheck))
  end
  self.gemPageData:SetData(tempArr)
  EventManager.Me():PassEvent(ItemEvent.GemPageUpdate)
end

function GemProxy:GetStaticDatasOfAttributeGem(id)
  if not self.attributeStaticData then
    LogUtility.Error("Cannot get static data of attribute gem before attributeStaticData is initialized!")
    return
  end
  if not id or not self.attributeStaticData[id] then
    LogUtility.Warning("Cannot get static data of attribute gem with id = {0}!", id)
    return
  end
  return self.attributeStaticData[id]
end

function GemProxy:GetEffectStaticDatasOfSkillGem(id)
  if not self.skillEffectStaticData then
    LogUtility.Error("Cannot get static data of skill gem effect before skillEffectStaticData is initialized!")
    return
  end
  if not id or not self.skillEffectStaticData[id] then
    LogUtility.Warning("Cannot get static data of skill gem effect with id = {0}!", id)
    return
  end
  return self.skillEffectStaticData[id]
end

function GemProxy:GetStaticDataOfSkillGemParam(paramId)
  if not self.skillParamStaticData then
    LogUtility.Error("Cannot get static data of skill gem param before skillParamStaticData is initialized!")
    return
  end
  if not paramId or not self.skillParamStaticData[paramId] then
    LogUtility.Warning("Cannot get static data of skill gem param with id = {0}!", paramId)
    return
  end
  return self.skillParamStaticData[paramId]
end

function GemProxy:GetParamValueFromBuffParamId(paramId)
  if not self.gemPageData then
    return 0
  end
  return self.gemPageData:GetParamValueFromBuffParamId(paramId)
end

function GemProxy:GetSameNameEmbedded(itemData)
  if not itemData or not itemData.staticData then
    return
  end
  return self.gemPageData:GetCellDataByPredicate(_SameNameEmbeddedPredicate, itemData)
end

function GemProxy:GetSkillQualityGroupFromItemData(data)
  local q = GemProxy.GetSkillQualityFromItemData(data)
  return q and self.skillQualityGroupMap[q]
end

function GemProxy:GetSkillQualityGroupByStaticId(id)
  local q = GemProxy.GetSkillQualityByStaticId(id)
  return q and self.skillQualityGroupMap[q]
end

function GemProxy:GetAllGemIdsBySkillQualityGroupAndProfession(group, prof)
  if not self.skillQualityGroupProfGemIdMap[group] then
    return
  end
  return self.skillQualityGroupProfGemIdMap[group][prof]
end

function GemProxy:GetSkillGemExhibitEffectDescArray(staticId)
  local effectStaticDatas = self:GetEffectStaticDatasOfSkillGem(staticId)
  local rsltArr, paramArr = {}, ReusableTable.CreateArray()
  local sData, paramId, paramStaticData, paramDescFormat, paramDesc
  if effectStaticDatas and next(effectStaticDatas) then
    for i = 1, #effectStaticDatas do
      sData = effectStaticDatas[i]
      if next(sData.ParamsID) then
        arrayClear(paramArr)
        for j = 1, #sData.ParamsID do
          paramId = sData.ParamsID[j]
          paramStaticData = self:GetStaticDataOfSkillGemParam(paramId)
          if paramStaticData then
            paramDescFormat = paramStaticData.isPercent and ZhString.Gem_SkillEffectParamWithPercentFormat or ZhString.Gem_SkillEffectParamFormat
            paramDesc = string.format(paramDescFormat, "", paramStaticData.min, paramStaticData.max)
          else
            paramDesc = nil
          end
          if paramDesc then
            paramDesc = string.gsub(paramDesc, "%]%%", "]")
            arrayPushBack(paramArr, paramDesc)
          end
        end
        arrayPushBack(rsltArr, ItemTipDefaultUiIconPrefix .. string.format(sData.Desc, unpack(paramArr)))
      else
        local probText = ""
        if sData.NormalRate < 100 then
          probText = string.format(ZhString.Gem_SkillEffectProbabilityFormat, sData.NormalRate)
        end
        arrayPushBack(rsltArr, ItemTipDefaultUiIconPrefix .. sData.Desc .. probText)
      end
    end
  end
  ReusableTable.DestroyAndClearArray(paramArr)
  return rsltArr
end

function GemProxy:CheckIsSkillEffectValid(gemItemId)
  return self.gemPageData:CheckIsSkillEffectValid(gemItemId)
end

function GemProxy:CheckGemSpeedUpOpen()
  local serverGroup = GameConfig.SpeedUp.gem_exp_speedup.servergroup
  local cur_groupid = ChangeZoneProxy.Instance:GetCurServerGroupId()
  local server_open_day = MyselfProxy.Instance.server_open_day
  local gem_SpeedUpConfig = Table_SpeedUp[2003]
  local server_open_day_Valid = not gem_SpeedUpConfig or not gem_SpeedUpConfig.Param or gem_SpeedUpConfig.Param == _EmptyTable or not gem_SpeedUpConfig.Param.after_open_server or server_open_day and server_open_day >= gem_SpeedUpConfig.Param.after_open_server
  if server_open_day and server_open_day_Valid and (serverGroup and nil == next(serverGroup) or TableUtility.ArrayFindIndex(serverGroup, cur_groupid) > 0) then
    local openDay = server_open_day < #Table_ExpectedLevel and server_open_day or #Table_ExpectedLevel
    local config = Table_ExpectedLevel[openDay]
    if config then
      local weekday_when_server_open = ServerTime.GetServerOpenWeekday()
      local curWeek = math.floor(server_open_day / 7)
      curWeek = 7 < server_open_day % 7 + (weekday_when_server_open - 1) and curWeek + 1 or curWeek
      local week = curWeek < #Table_GemSpeedUp and curWeek or #Table_GemSpeedUp
      return 0 < week, week
    end
  end
  return false
end

function GemProxy:GetSpeedUpConfigExp()
  local _, week = self:CheckGemSpeedUpOpen()
  if _ then
    week = math.min(week, #Table_GemSpeedUp)
    return Table_GemSpeedUp[week].value
  end
end

function GemProxy:GetExtraExp(material_count_4_upgrade)
  local base_speedup_exp = self:GetSpeedUpConfigExp()
  if not base_speedup_exp then
    return nil
  end
  if 0 == base_speedup_exp then
    return nil
  end
  local rate = GameConfig.SpeedUp and GameConfig.SpeedUp.gem_exp_speedup and GameConfig.SpeedUp.gem_exp_speedup.rate
  if not rate then
    return nil
  end
  material_count_4_upgrade = material_count_4_upgrade or 0
  local total_gem_exp = BagProxy.Instance:GetTotalGemExp()
  for i = 1, #rate do
    local ratioMin = rate[i - 1] and rate[i - 1][1] or 0
    local ratioMax = rate[i][1]
    local min = math.floor(ratioMin / 100 * base_speedup_exp + 0.5)
    local max = math.floor(ratioMax / 100 * base_speedup_exp + 0.5)
    if total_gem_exp >= min and total_gem_exp < max then
      return rate[i][2] * material_count_4_upgrade
    end
  end
  return 0
end

function GemProxy:CheckIfCanReplaceSameName(newItemData, cellIdToReplace)
  if not newItemData then
    LogUtility.Warning("There's no valid data of newItemData!")
    return false
  end
  if not cellIdToReplace or cellIdToReplace <= 0 then
    LogUtility.Error("CellIdToReplace invalid!")
    return false
  end
  local sameNameData = GemProxy.Instance:GetSameNameEmbedded(newItemData)
  if not sameNameData then
    return true
  end
  local oldItemData = self.gemPageData:GetCellData(cellIdToReplace)
  if not oldItemData then
    return false
  end
  return GemProxy.CheckIsSameName(oldItemData, newItemData)
end

function GemProxy:CheckIsMyProfessionAvailable()
  if not GemSkillProfessionFilterData then
    return false
  end
  local myPro = MyselfProxy.Instance:GetMyProfession()
  for _, data in pairs(GemSkillProfessionFilterData) do
    if 0 < arrayFindIndex(data, myPro) then
      return true
    end
  end
  return false
end

function GemProxy:CheckIfSkillGemIncludesProfession(gemId, prof)
  if not self.skillProfessionStaticData then
    LogUtility.Error("Cannot get profession data of skill gem before skillProfessionStaticData is initialized!")
    return false
  end
  if not (gemId and prof) or not self.skillProfessionStaticData[gemId] then
    LogUtility.WarningFormat("ArgumentException id = {0}, prof = {1}", gemId, prof)
    return false
  end
  return self.skillProfessionStaticData[gemId][prof] or false
end

function GemProxy:CheckIfSkillGemHasSameProfessions(gemId, professions)
  if not self.skillProfessionStaticData then
    LogUtility.Error("Cannot get profession data of skill gem before skillProfessionStaticData is initialized!")
    return false
  end
  if not (gemId and professions) or not self.skillProfessionStaticData[gemId] then
    LogUtility.WarningFormat("ArgumentException id = {0}, professions = {1}", gemId, professions)
    return false
  end
  local result = false
  for _, p in pairs(professions) do
    result = result or self.skillProfessionStaticData[gemId][p] or false
  end
  return result
end

function GemProxy:ShowNewGemResults(serverData, isShowFuncBtns)
  if type(serverData) ~= "table" then
    return
  end
  if isShowFuncBtns == nil then
    isShowFuncBtns = true
  end
  self.updatedGems = self.updatedGems or {}
  local data
  for i = 1, #serverData do
    data = self.updatedGems[i] or ItemData.new()
    data:ParseFromServerData(serverData[i])
    self.updatedGems[i] = data
  end
  for i = #serverData + 1, #self.updatedGems do
    self.updatedGems[i] = nil
  end
  if next(self.updatedGems) then
    table.sort(self.updatedGems, _NewGemResultComparer)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GemResultView,
      viewdata = {
        data = self.updatedGems,
        isShowFuncBtns = isShowFuncBtns
      }
    })
  else
    LogUtility.Warning("Cannot find updated gems from GemDataUpdateItemCmd! Please report to server developer!")
  end
end

function GemProxy.GetSkillItemData()
  return GemProxy.GetSkillItemDataByQualityAndProfession()
end

function GemProxy.GetSkillItemDataByQualityAndProfession(q, p, viewFavorTog)
  if not GemProxy.CheckSkillBagDataExists() then
    return _EmptyTable
  end
  return GemProxy.GetItemDataOfTypeByPredicate(SceneItem_pb.EGEMTYPE_SKILL, _SkillQualityAndProfessionPredicate, q, p, viewFavorTog)
end

function GemProxy.GetSkillItemDataByFilterDatasOfView(view, p)
  local datas = GemProxy.GetSkillItemDataByQualityAndProfession(view.curSkillClassFilterPopData, p or view.curSkillProfessionFilterPopData, view.favorToggle)
  return datas
end

function GemProxy.GetAttributeItemData()
  return GemProxy.GetAttributeItemDataByType()
end

function GemProxy.GetAttributeItemDataByType(t)
  if not GemProxy.CheckAttributeBagDataExists() then
    return _EmptyTable
  end
  return GemProxy.GetItemDataOfTypeByPredicate(SceneItem_pb.EGEMTYPE_ATTR, _AttributeTypePredicate, t)
end

function GemProxy.GetSecretLandItemDataByType(t, viewFavorTog)
  if not GemProxy.CheckSecretLandBagDataExists() then
    return _EmptyTable
  end
  return GemProxy.GetItemDataOfTypeByPredicate(SceneItem_pb.EGEMTYPE_SECRETLAND, _SecretLandTypePredicate, t, viewFavorTog)
end

function GemProxy.GetSecretLandItemDataByTypeOfView(view)
  local t = view.secretLandFilterType or 0
  local datas = GemProxy.GetSecretLandItemDataByType(t, view.secretLandFavorToggle)
  return datas
end

function GemProxy.GetAttributeItemDataByFilterDatasOfView(view)
  local datas
  if type(view.curAttributeFilterPopData) == "function" then
    datas = GemProxy.GetAttributeItemData()
    GemProxy.RemoveNotRequiredItemData(datas, view.curAttributeFilterPopData)
  else
    datas = GemProxy.GetAttributeItemDataByType(view.curAttributeFilterPopData)
  end
  return datas
end

function GemProxy.GetUnappraisedGemItemData()
  if not GemProxy.TryAssignBagProxyInstance() then
    return _EmptyTable
  end
  return GemProxy.GetItemDataFromBagByPredicate(bagIns:GetMainBag(), GemProxy.CheckIsUnappraised)
end

function GemProxy.GetFoldedUnappraisedGemItemData()
  local allItemData = GemProxy.GetUnappraisedGemItemData()
  local rslt
  arrayClear(tempArr)
  for i = 1, #allItemData do
    rslt = TableUtility.ArrayFindByPredicate(tempArr, function(item)
      return allItemData[i].staticData and item.staticData.id == allItemData[i].staticData.id
    end)
    if rslt then
      rslt:SetItemNum(rslt.num + allItemData[i].num)
    else
      arrayPushBack(tempArr, allItemData[i]:Clone())
    end
  end
  tableClear(tempTable)
  TableUtility.ArrayShallowCopy(tempTable, tempArr)
  table.sort(tempTable, function(l, r)
    return l.staticData.id > r.staticData.id
  end)
  return tempTable
end

function GemProxy.GetItemDataOfTypeByPredicate(gemType, predicate, ...)
  local bagData = GemProxy.GetBagDataOfGemType(gemType)
  if not bagData then
    LogUtility.WarningFormat("Cannot find gem bag data with gem type = {0}", gemType)
    return _EmptyTable
  end
  return GemProxy.GetItemDataFromBagByPredicate(bagData, predicate, ...)
end

function GemProxy.GetItemDataFromBagByPredicate(bagData, predicate, ...)
  if type(bagData) ~= "table" or not bagData.GetItems then
    return _EmptyTable
  end
  tableClear(tempTable)
  local items = bagData:GetItems()
  local item
  for i = 1, #items do
    item = items[i]
    if not predicate or predicate(item, ...) then
      arrayPushBack(tempTable, item)
    end
  end
  return tempTable
end

function GemProxy.GetBagDataOfGemType(gemType)
  if not GemProxy.TryAssignBagProxyInstance() then
    return
  end
  if gemType == SceneItem_pb.EGEMTYPE_ATTR then
    return bagIns.attributeGemBagData
  elseif gemType == SceneItem_pb.EGEMTYPE_SKILL then
    return bagIns.skillGemBagData
  elseif gemType == SceneItem_pb.EGEMTYPE_SECRETLAND then
    return bagIns.secretLandGemBagData
  end
end

function GemProxy.GetEmbeddedPosition(itemData)
  local data
  if GemProxy.CheckContainsGemAttrData(itemData) then
    data = itemData.gemAttrData
  elseif GemProxy.CheckContainsGemSkillData(itemData) then
    data = itemData.gemSkillData
  elseif GemProxy.CheckContainsGemSecretLandData(itemData) then
    data = itemData.secretLandDatas
  else
    return -1
  end
  return GemProxy.CheckCharIdIsValid(data) and data.pos or 0
end

function GemProxy.GetMagnifierCount()
  if not GemProxy.TryAssignBagProxyInstance() then
    return 0
  end
  return bagIns:GetItemNumByStaticID(GameConfig.Gem.CheckUpItemId)
end

function GemProxy.GetSimpleGemName(staticData)
  local str = staticData.NameZh
  local normalCount = 6
  for i = 1, string.len(str) do
    if string.sub(str, i, i) == " " and i <= 6 then
      normalCount = normalCount + 1
    end
  end
  return StringUtil.Sub(str, 1, normalCount)
end

function GemProxy.GetAttributeItemDataLevelComparer(isDescending)
  return isDescending and GemProxy.AttributeLevelDescendingComparer or GemProxy.AttributeLevelAscendingComparer
end

function GemProxy.GetSecretLandItemDataLvComparer(isDescending)
  return isDescending and GemProxy.SecretLandLevelDescendingComparer or GemProxy.SecretLandLevelAscendingComparer
end

function GemProxy.GetSkillQualityFromItemData(data)
  if not data or not data.staticData then
    return
  end
  return GemProxy.GetSkillQualityByStaticId(data.staticData.id)
end

function GemProxy.GetSkillQualityByStaticId(id)
  if type(id) ~= "number" then
    return
  end
  local rData = Table_GemRate[id]
  return rData and rData.Quality
end

function GemProxy.GetWeightDataFromItemDatas(datas)
  local isSame
  tableClear(tempTable)
  for i = 1, #datas do
    arrayPushBack(tempTable, GemProxy.GetSkillQualityFromItemData(datas[i]))
  end
  table.sort(tempTable, function(l, r)
    return r < l
  end)
  for _, staticData in pairs(Table_GemFuse) do
    if not staticData.Quality or type(staticData.Quality) ~= "table" or #staticData.Quality < 3 then
      return
    end
    isSame = true
    for i = 1, 3 do
      isSame = isSame and staticData.Quality[i] == tempTable[i]
    end
    if isSame then
      return staticData.Weight
    end
  end
end

function GemProxy.GetMaxQualityWeightOf3to1Compose(materials)
  if type(materials) ~= "table" or #materials < 3 then
    return
  end
  local weightData = GemProxy.GetWeightDataFromItemDatas(materials)
  if not weightData then
    return
  end
  local maxQuality, weight
  for i = #GemSkillQualityMap, 1, -1 do
    if weightData[i] and 0 < weightData[i] then
      maxQuality = GemSkillQualityMap[i]
      weight = weightData[i]
      break
    end
  end
  return maxQuality, weight
end

function GemProxy.GetMaxQualityWeightOf5to1Compose(materials)
  if type(materials) ~= "table" or #materials < 5 then
    return
  end
  local quality
  arrayClear(tempArr)
  for i = 1, #GemSkillQualityMap do
    tempArr[i] = 0
  end
  for i = 1, 5 do
    quality = GemProxy.GetSkillQualityFromItemData(materials[i])
    tempArr[quality] = tempArr[quality] + 1
  end
  local weightOfQualityArr, sum, maxQuality, weight = ReusableTable.CreateArray(), 0
  for i = 1, #GemSkillQualityMap do
    weightOfQualityArr[i] = GameConfig.Gem.FiveCompose[i] * tempArr[i]
    sum = sum + weightOfQualityArr[i]
  end
  for i = #GemSkillQualityMap, 1, -1 do
    if 0 < weightOfQualityArr[i] then
      maxQuality = GemSkillQualityMap[i]
      weight = math.ceil(weightOfQualityArr[i] * 100 / sum)
      break
    end
  end
  ReusableTable.DestroyAndClearArray(weightOfQualityArr)
  return maxQuality, weight
end

function GemProxy.GetExpSumFromAttributeItemDatas(datas)
  local sum, data, attrData = 0
  for i = 1, #datas do
    data = datas[i]
    attrData = data.gemAttrData
    if attrData then
      sum = sum + attrData:GetTotalExp() * data.num
    end
  end
  return sum
end

function GemProxy.GetDescNameValueDataFromAttributeItemDatas(datas)
  local propDesc, gemUpgradeDsc, valueSign, valueValue, valueUnit, existed, nameValueData
  arrayClear(tempArr)
  for i = 1, #datas do
    if GemProxy.CheckContainsGemAttrData(datas[i]) then
      for j = 1, #datas[i].gemAttrData.propDescs do
        propDesc = datas[i].gemAttrData.propDescs[j]
        existed = false
        valueSign, valueValue, valueUnit = string.match(datas[i].gemAttrData.valueDescs[j], "(%D+)(%d+%.*%d*)(%D*)")
        for k = 1, #tempArr do
          gemUpgradeDsc = tempArr[k]
          if gemUpgradeDsc[1] == propDesc and gemUpgradeDsc[4] == valueUnit then
            gemUpgradeDsc[3] = gemUpgradeDsc[3] + tonumber(valueValue)
            existed = true
            break
          end
        end
        if not existed then
          gemUpgradeDsc = ReusableTable.CreateArray()
          gemUpgradeDsc[1] = propDesc
          gemUpgradeDsc[2] = valueSign
          gemUpgradeDsc[3] = tonumber(valueValue)
          gemUpgradeDsc[4] = valueUnit
          arrayPushBack(tempArr, gemUpgradeDsc)
        end
      end
    end
  end
  tableClear(tempTable)
  for _, dsc in pairs(tempArr) do
    nameValueData = {}
    nameValueData.name = dsc[1]
    nameValueData.value = table.concat(dsc, nil, 2)
    arrayPushBack(tempTable, nameValueData)
  end
  for _, dsc in pairs(tempArr) do
    ReusableTable.DestroyAndClearArray(dsc)
  end
  return tempTable
end

function GemProxy.GetProfessionDescFromSkillGem(gemId)
  if not gemId or gemId <= 0 then
    return
  end
  if not Table_GemRate[gemId] then
    return
  end
  local equipProfs, bannedProfs, myPro = Table_GemRate[gemId].ClassType, ProfessionProxy.GetBannedProfessions(), MyselfProxy.Instance:GetMyProfession()
  local profUnavailable, sb, mySex = true, LuaStringBuilder.CreateAsTable(), MyselfProxy.Instance:GetMySex()
  if equipProfs and next(equipProfs) then
    for i = 1, #equipProfs do
      if not myPro or myPro == equipProfs[i] then
        profUnavailable = false
      end
      if Table_Class[equipProfs[i]] and nil == bannedProfs[equipProfs[i]] then
        sb:Append(ProfessionProxy.GetProfessionName(equipProfs[i], mySex))
        sb:Append("/")
      end
    end
  else
    profUnavailable = false
    sb:Append(ZhString.ItemTip_AllPro)
  end
  if sb.content[sb:GetCount()] == "/" then
    sb:RemoveLast()
  end
  table.insert(sb.content, 1, ZhString.ItemTip_Profession)
  if profUnavailable then
    table.insert(sb.content, 1, "[c]")
    table.insert(sb.content, 2, CustomStrColor.BanRed)
    sb:Append("[-][/c]")
  end
  local s = sb:ToString()
  sb:Destroy()
  return s
end

function GemProxy.GetSkillAndAttrGemCountDescFromItemDatas(itemDatas)
  local skillCount, attrCount = 0, 0
  if itemDatas then
    for _, item in pairs(itemDatas) do
      if GemProxy.CheckContainsGemSkillData(item) then
        skillCount = skillCount + 1
      elseif GemProxy.CheckContainsGemAttrData(item) then
        attrCount = attrCount + 1
      end
    end
  end
  return skillCount, attrCount
end

function GemProxy.GetRowAndColFromIndexAndColumnCount(index, columnCount)
  local col = (index - 1) % columnCount + 1
  local row = GemProxy.ToInteger((index - col) / columnCount + 1)
  if not row then
    LogUtility.ErrorFormat("Get Row failed while index = {0}, maxMaterialCount = {1} and col = {2}", index, columnCount, col)
    return
  end
  return row, col
end

function GemProxy.GetMaxMultiFunctionCellCount(columnCount)
  return GemProxy.MultiComposeRowCount * columnCount
end

function GemProxy.AttributeLevelAscendingComparer(l, r)
  return GemProxy._AttributeLevelComparer(l, r, false)
end

function GemProxy.AttributeLevelDescendingComparer(l, r)
  return GemProxy._AttributeLevelComparer(l, r, true)
end

function GemProxy._AttributeLevelComparer(l, r, isDescending)
  local lLv, rLv = l.gemAttrData:GetTotalExp(), r.gemAttrData:GetTotalExp()
  if lLv ~= rLv then
    if isDescending then
      return lLv > rLv
    else
      return lLv < rLv
    end
  end
  return GemProxy.BasicComparer(l, r)
end

function GemProxy.SecretLandLevelAscendingComparer(l, r)
  return GemProxy._SecretLandLevelComparer(l, r, false)
end

function GemProxy.SecretLandLevelDescendingComparer(l, r)
  return GemProxy._SecretLandLevelComparer(l, r, true)
end

function GemProxy._SecretLandLevelComparer(l, r, isDescending)
  local lLv, rLv = l.lv or l.secretLandDatas.lv, r.lv or r.secretLandDatas.lv
  if lLv ~= rLv then
    if isDescending then
      return lLv > rLv
    else
      return lLv < rLv
    end
  end
end

function GemProxy.BasicComparer(l, r)
  if l.staticData.id ~= r.staticData.id then
    return l.staticData.id > r.staticData.id
  end
  return l.id < r.id
end

function GemProxy.SecretLandComparer(l, r)
  if l.secretLandDatas.lv == r.secretLandDatas.lv then
    return l.staticData.id < r.staticData.id
  else
    return l.secretLandDatas.lv > r.secretLandDatas.lv
  end
end

function GemProxy.SkillQualityDescendingComparer(l, r)
  l = GemProxy.GetSkillQualityFromItemData(l) or 0
  r = GemProxy.GetSkillQualityFromItemData(r) or 0
  return l > r
end

function GemProxy.SkillQualityAscendingComparer(l, r)
  l = GemProxy.GetSkillQualityFromItemData(l) or maxInt
  r = GemProxy.GetSkillQualityFromItemData(r) or maxInt
  return l < r
end

function GemProxy.PredicateComparer(l, r, predicate)
  local lPredicate = predicate(l) and 1 or 0
  local rPredicate = predicate(r) and 1 or 0
  if lPredicate ~= rPredicate then
    return lPredicate > rPredicate
  end
end

function GemProxy.CheckContainsGemAttrData(itemData)
  if type(itemData) ~= "table" then
    return false
  end
  return GemProxy.CheckIsGemAttrData(itemData.gemAttrData)
end

function GemProxy.CheckContainsGemSkillData(itemData)
  if type(itemData) ~= "table" then
    return false
  end
  return GemProxy.CheckIsGemSkillData(itemData.gemSkillData)
end

function GemProxy.CheckContainsGemSecretLandData(itemData)
  if type(itemData) ~= "table" then
    return false
  end
  return GemProxy.CheckIsSecretLandData(itemData.secretLandDatas)
end

function GemProxy.CheckIsGemAttrData(data)
  return data ~= nil and type(data) == "table" and data.itemGuid ~= nil and data.itemGuid ~= "" and data.GetStaticDataOfCurLevel ~= nil and data:GetStaticDataOfCurLevel() ~= nil
end

function GemProxy.CheckIsGemSkillData(data)
  return data ~= nil and type(data) == "table" and data.itemGuid ~= nil and data.itemGuid ~= "" and data.id ~= nil and data.buffs ~= nil
end

function GemProxy.CheckIsSecretLandData(data)
  return data ~= nil and type(data) == "table" and nil ~= data.sData
end

function GemProxy.CheckIsEmbedded(itemData)
  local pos = GemProxy.GetEmbeddedPosition(itemData)
  return pos ~= nil and 0 < pos
end

function GemProxy.CheckIsSameName(a, b)
  if not (type(a) == "table" and type(b) == "table" and a.staticData) or not b.staticData then
    return false
  end
  return a.staticData.id and b.staticData.id and a.staticData.id == b.staticData.id and a.id ~= b.id
end

function GemProxy.CheckIsFavorite(itemData)
  if type(itemData) ~= "table" then
    return false
  end
  if not GemProxy.TryAssignBagProxyInstance() then
    return false
  end
  return bagIns:CheckIsFavorite(itemData, GemProxy.PackageCheck)
end

function GemProxy.CheckIsUnappraised(itemData)
  if type(itemData) ~= "table" then
    return false
  end
  return GameConfig.Gem.Unidentified[itemData.staticData.id] ~= nil
end

function GemProxy.CheckAttributeBagDataExists()
  return GemProxy.CheckGemBagDataOfTypeExists(SceneItem_pb.EGEMTYPE_ATTR)
end

function GemProxy.CheckSkillBagDataExists()
  return GemProxy.CheckGemBagDataOfTypeExists(SceneItem_pb.EGEMTYPE_SKILL)
end

function GemProxy.CheckSecretLandBagDataExists()
  return GemProxy.CheckGemBagDataOfTypeExists(SceneItem_pb.EGEMTYPE_SECRETLAND)
end

function GemProxy.CheckGemBagDataOfTypeExists(gemType)
  local bagData = GemProxy.GetBagDataOfGemType(gemType)
  if not bagData then
    LogUtility.WarningFormat("Cannot find gem bag data with gem type = {0}", gemType)
    return false
  end
  return true
end

function GemProxy.CheckIsGemPageAttributeCellId(cellId)
  return cellId and type(cellId) == "number" and 0 < cellId and cellId < 1000
end

function GemProxy.CheckIsGemPageSkillCellId(cellId)
  return cellId and type(cellId) == "number" and 1000 < cellId
end

function GemProxy.CheckGemIsUnlocked(withTip)
  if withTip == nil then
    withTip = true
  end
  return FunctionUnLockFunc.Me():CheckCanOpen(6200, withTip)
end

function GemProxy.CheckIsGemStaticData(staticData)
  if type(staticData) ~= "table" then
    return false
  end
  local t = staticData.Type
  if not t then
    return false
  end
  return t == 53 or t == 54 or t == 98
end

function GemProxy.CheckComposeDataGroupIsSameName(group)
  if type(group) ~= "table" or #group < 3 then
    return false
  end
  local sId = type(group[1]) == "table" and group[1].staticData and group[1].staticData.id
  if not sId then
    return false
  end
  for i = 2, #group do
    if group[i] == BagItemEmptyType.Empty or type(group[i]) == "table" and group[i].staticData and group[i].staticData.id ~= sId then
      return false
    end
  end
  return true
end

function GemProxy.CheckComposeDataGroup(group)
  if type(group) ~= "table" or #group < 3 then
    return false
  end
  for i = 1, #group do
    if group[i] == BagItemEmptyType.Empty then
      return false
    end
  end
  return true
end

function GemProxy.CheckGemIsSculpted(gemItemData)
  if not GemProxy.CheckContainsGemSkillData(gemItemData) then
    return false
  end
  return GemProxy.CheckSkillDataIsSculpted(gemItemData.gemSkillData)
end

function GemProxy.CheckSkillDataIsSculpted(gemSkillData)
  if not gemSkillData or not next(gemSkillData) then
    return false
  end
  local sculpt = gemSkillData.sculptures
  return sculpt ~= nil and next(sculpt) ~= nil
end

function GemProxy.CheckIsGemDataDifferentFrom(saveData)
  if not GemProxy.TryAssignBagProxyInstance() then
    return false
  end
  if saveData and type(saveData) == "table" then
    local sameName, itemExp, sameNameExp, foundSameNameWithMoreExp
    for _, item in pairs(saveData) do
      if GemProxy.CheckContainsGemSkillData(item) then
        if not bagIns:GetItemByGuid(item.id, SceneItem_pb.EPACKTYPE_GEM_SKILL) then
          return true
        end
      elseif GemProxy.CheckContainsGemSecretLandData(item) then
        if not bagIns:GetItemByGuid(item.id, SceneItem_pb.EPACKTYPE_GEM_SECRETLAND) then
          return true
        end
      elseif GemProxy.CheckContainsGemAttrData(item) then
        itemExp = item.gemAttrData:GetTotalExp()
        sameName = bagIns:GetItemsByStaticID(item.staticData.id, SceneItem_pb.EPACKTYPE_GEM_ATTR)
        foundSameNameWithMoreExp = false
        if sameName then
          for _, sameNameItem in pairs(sameName) do
            sameNameExp = sameNameItem.gemAttrData:GetTotalExp()
            if GemProxy.CheckCharIdIsValid(sameNameItem.gemAttrData) and itemExp <= sameNameExp then
              foundSameNameWithMoreExp = true
            end
          end
        end
        if not foundSameNameWithMoreExp then
          return true
        end
      end
    end
  end
  return false
end

function GemProxy.CheckCharIdIsValid(gem_data)
  if type(gem_data) ~= "table" then
    LogUtility.Warning("Argument invalid exception while checking charId")
    return false
  end
  if gem_data.__cname == "GemSecretLandData" then
    return gem_data:CheckCharIdIsValid()
  end
  local charId = gem_data.charid or gem_data.charId
  return not charId or charId == 0 or charId == Game.Myself.data.id
end

function GemProxy.TryAddFavoriteFilterToFilterPop(filterPop)
  if not filterPop then
    return
  end
  filterPop:AddItem(ZhString.Gem_FilterFavorite, GemProxy.CheckIsFavorite)
end

function GemProxy.TryRemoveBannedProfessionsFromFilter(filterPop)
  if not filterPop then
    return
  end
  local bannedProfs = ProfessionProxy.GetBannedProfessions()
  for p, _ in pairs(bannedProfs) do
    if Table_Class[p] then
      filterPop:RemoveItem(ProfessionProxy.GetProfessionName(p, MyselfProxy.Instance:GetMySex()))
    end
  end
end

function GemProxy.TrySetFakeGemDataToGemCell(itemData, gemCell)
  if not (GemProxy.CheckIsGemStaticData(itemData.staticData) and gemCell) or not gemCell.SetData then
    return
  end
  local fakeData = ReusableTable.CreateTable()
  fakeData.id = itemData.staticData.id
  if itemData.staticData.Type == 53 then
    fakeData.lv = 1
    fakeData.exp = 0
    itemData.gemAttrData = GemAttrData.new("shop", fakeData)
  elseif itemData.staticData.Type == 54 then
    fakeData.buffs = _EmptyTable
    itemData.gemSkillData = GemSkillData.new("shop", fakeData)
  elseif itemData.staticData.Type == 98 then
    local secretLand_id = GemProxy.Instance:GetSecretLandID(itemData.staticData.id)
    itemData.secretLandDatas = GemSecretLandData.new(secretLand_id)
  end
  ReusableTable.DestroyAndClearTable(fakeData)
  gemCell:SetData(itemData)
end

function GemProxy.TryAssignBagProxyInstance()
  if not bagIns then
    bagIns = BagProxy.Instance
  end
  if not bagIns then
    LogUtility.Error("BagProxy.Instance not available!")
    return false
  end
  return true
end

function GemProxy.TryParseGemAttrDataFromServerItemData(localItemData, serverItemData)
  localItemData.gemAttrData = nil
  if serverItemData.attr and serverItemData.attr.id and serverItemData.attr.id ~= 0 then
    localItemData.gemAttrData = GemAttrData.new(serverItemData.base.guid, serverItemData.attr)
  end
end

function GemProxy.TryParseGemSkillDataFromServerItemData(localItemData, serverItemData)
  localItemData.gemSkillData = nil
  if serverItemData.skill and serverItemData.skill.id and serverItemData.skill.id ~= 0 then
    localItemData.gemSkillData = GemSkillData.new(serverItemData.base.guid, serverItemData.skill)
  end
end

function GemProxy.RemoveEmbedded(datas)
  return GemProxy.RemoveItemDataByPredicate(datas, GemProxy.CheckIsEmbedded)
end

function GemProxy.RemoveFavorite(datas)
  return GemProxy.RemoveItemDataByPredicate(datas, GemProxy.CheckIsFavorite)
end

function GemProxy.RemoveNotRequiredItemData(datas, requiredPredicate, arg)
  if type(requiredPredicate) ~= "function" then
    return
  end
  return GemProxy.RemoveItemDataByPredicate(datas, function(data, arg2)
    return not requiredPredicate(data, arg2)
  end, arg)
end

function GemProxy.RemoveItemDataByPredicate(datas, predicate, arg)
  if type(datas) ~= "table" then
    return
  end
  for i = #datas, 1, -1 do
    if predicate(datas[i], arg) then
      table.remove(datas, i)
    end
  end
end

function GemProxy.ToInteger(num)
  if type(num) ~= "number" then
    LogUtility.Error("You're trying to convert a non-number variable to integer!")
    return
  end
  local round = math.floor(num + 0.5)
  local delta = math.abs(num - round)
  if delta < 0.005 then
    return round
  else
    return nil
  end
end

function GemProxy.CreateGemComposeGroups(datas, countOfEveryGroup, groupCheck)
  tableClear(tempTable)
  local group, data
  for i = 1, GemProxy.MultiComposeRowCount do
    arrayClear(tempArr)
    for j = 1, countOfEveryGroup do
      data = datas[countOfEveryGroup * (i - 1) + j]
      if data and type(data) == "table" and data.id then
        TableUtility.ArrayPushBack(tempArr, data)
      else
        break
      end
      if j == countOfEveryGroup and (not groupCheck or groupCheck(tempArr)) then
        group = NetConfig.PBC and {} or SceneItem_pb.GemComposeGroup()
        if not group.guids then
          group.guids = {}
        end
        for k = 1, countOfEveryGroup do
          group.guids[k] = tempArr[k].id
        end
        arrayPushBack(tempTable, group)
      end
    end
  end
end

function GemProxy.CallAppraisal(staticId, count)
  if not staticId then
    return
  end
  count = count or 1
  ServiceItemProxy.Instance:CallGemSkillAppraisalItemCmd(staticId, count)
end

function GemProxy.CallSkillSameNameCompose(datas)
  if not datas or not next(datas) then
    return
  end
  GemProxy.CreateGemComposeGroups(datas, 3, GemProxy.CheckComposeDataGroupIsSameName)
  ServiceItemProxy.Instance:CallGemSkillComposeSameItemCmd(tempTable)
end

function GemProxy.CallSkill3to1Compose(datas)
  if not datas or not next(datas) then
    return
  end
  GemProxy.CreateGemComposeGroups(datas, 3)
  ServiceItemProxy.Instance:CallGemSkillComposeQualityItemCmd(SceneItem_pb.EGEMCOMPOSETYPE_THREE, tempTable)
end

function GemProxy.CallSkill5to1Compose(datas, profession)
  if not datas or not next(datas) then
    return
  end
  GemProxy.CreateGemComposeGroups(datas, 5)
  ServiceItemProxy.Instance:CallGemSkillComposeQualityItemCmd(SceneItem_pb.EGEMCOMPOSETYPE_FIVE, tempTable, profession)
end

function GemProxy.CallAttributeUpgrade(targetGuid, materials)
  tableClear(tempTable)
  local sItem
  for _, material in pairs(materials) do
    sItem = TableUtility.ArrayFindByPredicate(tempTable, function(item)
      return item.guid == material.id
    end)
    if sItem then
      sItem.count = sItem.count + material.num
    else
      sItem = NetConfig.PBC and {} or SceneItem_pb.SItem()
      sItem.guid, sItem.count = material.id, material.num or 0
      table.insert(tempTable, sItem)
    end
  end
  ServiceItemProxy.Instance:CallGemAttrUpgradeItemCmd(targetGuid, tempTable)
end

function GemProxy.CallEmbed(gemType, id, pos)
  if not (gemType and id) or not pos then
    LogUtility.Error("Invalid argument while calling CallEmbed!")
    return
  end
  if not GemProxy.IsGemType(gemType) then
    redlog("----------------------CallGemMountItemCmd 符文镶嵌 error gem_type ： ", gemType)
    return
  end
  helplog("GemProxy:CallGemMountItemCmd gemType|id|pos: ", gemType, id, pos)
  ServiceItemProxy.Instance:CallGemMountItemCmd(gemType, id, pos)
end

function GemProxy.CallRemove(gemType, id)
  if not gemType or not id then
    LogUtility.Error("Invalid argument while calling CallEmbed!")
    return
  end
  if not GemProxy.IsGemType(gemType) then
    redlog("----------------------CallGemUnmountItemCmd 符文卸载 error gem_type ： ", gemType)
    return
  end
  helplog("GemProxy:CallGemUnmountItemCmd gemType|id: ", gemType, id)
  ServiceItemProxy.Instance:CallGemUnmountItemCmd(gemType, id)
end

function GemProxy.CallSculpt(guid, type, pos, isReset)
  isReset = isReset and true or false
  ServiceItemProxy.Instance:CallGemCarveItemCmd(guid, type, pos, isReset)
end

function GemProxy.CallSmelt(targetStaticId, datas, countOfEveryGroup)
  if not datas or not next(datas) then
    return
  end
  countOfEveryGroup = countOfEveryGroup or 3
  GemProxy.CreateGemComposeGroups(datas, countOfEveryGroup)
  ServiceItemProxy.Instance:CallGemSmeltItemCmd(targetStaticId, tempTable)
end
