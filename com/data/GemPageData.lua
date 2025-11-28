GemPageData = class("GemPageData")
local maxNeighborCount = 3
local tempTable, tempArr, arrayPushBack, tableClear, arrayShallowCopy, tableFind, arrayFind, pageCfg

function GemPageData:ctor(dataTable)
  if not tempTable then
    tempTable = {}
  end
  if not tempArr then
    tempArr = {}
  end
  if not arrayPushBack then
    arrayPushBack = TableUtility.ArrayPushBack
  end
  if not tableClear then
    tableClear = TableUtility.TableClear
  end
  if not arrayShallowCopy then
    arrayShallowCopy = TableUtility.ArrayShallowCopy
  end
  if not tableFind then
    tableFind = TableUtility.TableFindByPredicate
  end
  if not arrayFind then
    arrayFind = TableUtility.ArrayFindByPredicate
  end
  if not pageCfg then
    pageCfg = GameConfig.Gem.Page
  end
  self.dataMap = {}
  self.skillCellNeighborDataMap = {}
  self.skillCellFitTypeNeighborMap = {}
  self.validSkillEffectGems = {}
  self.validSkillEffectParamMap = {}
  self.embedAttrGemCountMap = {}
  self:SetData(dataTable)
end

function GemPageData:SetData(dataTable)
  tableClear(self.dataMap)
  if dataTable and type(dataTable) == "table" then
    local pos
    for _, data in pairs(dataTable) do
      pos = nil
      if GemProxy.CheckContainsGemAttrData(data) then
        pos = data.gemAttrData.pos
      elseif GemProxy.CheckContainsGemSkillData(data) then
        pos = data.gemSkillData.pos
      elseif GemProxy.CheckContainsGemSecretLandData(data) then
        pos = data.secretLandDatas:GetPos()
      end
      if pos and 0 < pos then
        if self.dataMap[pos] then
          LogUtility.WarningFormat("Found duplicate data with itemId = {0} and new itemId = {1} on cellid = {2} while updating gem page data!", self.dataMap[pos].staticData.id, data.staticData.id, pos)
        end
        self.dataMap[pos] = data
      end
    end
    self:ResetAttrGemCountMap()
  end
  self:UpdateNeighborItemDataOfSkillCells()
  self:UpdateValidSkillEffectGems()
  self:UpdateValidSkillEffectParamMap()
end

function GemPageData:ResetAttrGemCountMap()
  self.activeCountMap = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0
  }
  tableClear(self.embedAttrGemCountMap)
  for cellId, itemData in pairs(self.dataMap) do
    if GemProxy.CheckContainsGemSkillData(itemData) then
      local needAttributeGemTypes = itemData.gemSkillData.needAttributeGemTypes
      local sculptData = itemData.gemSkillData:GetSculptData()
      local sculptPos = sculptData and sculptData[1] and sculptData[1].pos
      for i = 1, #needAttributeGemTypes do
        if not sculptPos or sculptPos ~= i then
          local attrType = needAttributeGemTypes[i]
          if attrType ~= 0 then
            self.activeCountMap[attrType] = self.activeCountMap[attrType] + 1
          end
        end
      end
    elseif GemProxy.CheckContainsGemAttrData(itemData) then
      local attrGemType = itemData.gemAttrData.type
      self.embedAttrGemCountMap[attrGemType] = (self.embedAttrGemCountMap[attrGemType] or 0) + 1
    end
  end
  for i = 1, 3 do
    self.activeCountMap[i] = math.ceil(self.activeCountMap[i] / 3)
  end
end

function GemPageData:GetAttrGemCountMap()
  return self.activeCountMap
end

function GemPageData:CheckAttrGemActive(attrGemType)
  local needCount = self.activeCountMap[attrGemType] or 9999
  local ownCount = self.embedAttrGemCountMap[attrGemType] or 0
  return needCount <= ownCount
end

function GemPageData:GetAttrGemCountByType(attrGemType)
  local needCountMap = self:GetAttrGemCountMap()
  return needCountMap and needCountMap[attrGemType] or 0
end

function GemPageData:GetEmbedAttrGemCountByType(attrGemType)
  return self.embedAttrGemCountMap[attrGemType] or 0
end

function GemPageData:UpdateNeighborItemDataOfSkillCells()
  if not next(self.skillCellNeighborDataMap) then
    for id, _ in pairs(pageCfg) do
      self.skillCellNeighborDataMap[id] = {}
    end
  end
  for _, t in pairs(self.skillCellNeighborDataMap) do
    tableClear(t)
  end
  local neighborDatas, neighborIds, attrItemData
  for cellId, _ in pairs(self.dataMap) do
    neighborDatas = self.skillCellNeighborDataMap[cellId]
    neighborIds = pageCfg[cellId]
    if neighborDatas and neighborIds then
      for i = 1, #neighborIds do
        attrItemData = self.dataMap[neighborIds[i]]
        if GemProxy.CheckContainsGemAttrData(attrItemData) then
          arrayPushBack(neighborDatas, attrItemData)
        end
      end
    end
  end
end

function GemPageData:UpdateValidSkillEffectGems()
  tableClear(self.validSkillEffectGems)
  GemProxy.allSkilGemActive = true
  for cellId, itemData in pairs(self.dataMap) do
    if GemProxy.CheckContainsGemSkillData(itemData) and itemData.gemSkillData.available then
      local skillData = itemData.gemSkillData
      local needTypes = skillData.needAttributeGemTypes
      local allTypesActive = true
      local sculptData = skillData:GetSculptData()
      local sculptPos = sculptData and sculptData[1] and sculptData[1].pos
      for i = 1, #needTypes do
        if not sculptPos or sculptPos ~= i then
          local needType = needTypes[i]
          if needType == 0 then
          elseif not self:CheckAttrGemActive(needType) then
            allTypesActive = false
            GemProxy.allSkilGemActive = false
            break
          end
        end
      end
      if allTypesActive then
        arrayPushBack(self.validSkillEffectGems, itemData)
      end
    end
  end
  self:UpdateValidSkillEffectParamMap()
end

function GemPageData:ForEachFitTypeNeighborOfGemPageSkillCell(skillCellId, action, args)
  if not (skillCellId and action and self.dataMap and self.skillCellNeighborDataMap) or not self.skillCellFitTypeNeighborMap then
    return
  end
  local skillItemData = self.dataMap[skillCellId]
  if not skillItemData or not GemProxy.CheckIsGemSkillData(skillItemData.gemSkillData) then
    return
  end
  local neighborDatas, fitTypeNeighborDatas = self.skillCellNeighborDataMap[skillCellId], self.skillCellFitTypeNeighborMap[skillCellId]
  if not (neighborDatas and next(neighborDatas) and fitTypeNeighborDatas) or not next(fitTypeNeighborDatas) then
    return
  end
  for needTypeIndex = 1, maxNeighborCount do
    if fitTypeNeighborDatas[needTypeIndex] then
      action(args, needTypeIndex, fitTypeNeighborDatas[needTypeIndex])
    end
  end
end

function GemPageData:UpdateValidSkillEffectParamMap()
  tableClear(self.validSkillEffectParamMap)
  local skillData
  for _, itemData in pairs(self.validSkillEffectGems) do
    skillData = itemData.gemSkillData
    if skillData then
      for paramId, paramValue in pairs(skillData.buffParamMap) do
        self.validSkillEffectParamMap[paramId] = paramValue + (self.validSkillEffectParamMap[paramId] or 0)
      end
    end
  end
end

function GemPageData:GetHeroFeatureLv()
  local addHeroLv = 1
  for _, item in pairs(self.validSkillEffectGems) do
    if item.gemSkillData and item.gemSkillData.available then
      addHeroLv = addHeroLv + item.gemSkillData:GetAddedHeroLvBuff()
    end
  end
  return addHeroLv
end

function GemPageData:GetParamValueFromBuffParamId(paramId)
  return self.validSkillEffectParamMap and self.validSkillEffectParamMap[paramId] or 0
end

function GemPageData:GetCellData(cellId)
  return self.dataMap[cellId]
end

function GemPageData:GetCellDataByPredicate(predicate, args)
  return tableFind(self.dataMap, predicate, args)
end

local gemIdPredicate = function(itemData, gemItemId)
  return itemData.id == gemItemId
end

function GemPageData:CheckIsSkillEffectValid(gemItemId)
  if not gemItemId then
    return false
  end
  return arrayFind(self.validSkillEffectGems, gemIdPredicate, gemItemId) ~= nil
end

function GemPageData:Clone()
  return GemPageData.new(self.dataMap)
end
