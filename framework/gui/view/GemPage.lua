autoImport("GemCell")
autoImport("GemPageSkillCell")
autoImport("GemPageAttributeCell")
autoImport("GemPageSecretLandCell")
GemPage = class("GemPage", CoreView)
GemPageBgTexNames = {
  "rune_bg",
  "Rune_bg_bg1",
  "rune_icon_bg1"
}
local tickManager, activeTickId
local tempArr, tempReusableArrayMap = {}, {}
local bg2Angles = LuaVector3.Zero()

function GemPage:ctor(container, data)
  GemPage.super.ctor(self, self:LoadPreferb("part/GemPage", container))
  if not tickManager then
    tickManager = TimeTickManager.Me()
    activeTickId = 1
  end
  if next(tempReusableArrayMap) then
    LogUtility.Warning("tempReusableArrayMap isn't empty. There must be something wrong when exiting the last GemPage!")
  end
  self.newTempReusableArrId = 0
  self.pageData = data and GemPageData.new(data) or GemProxy.Instance.gemPageData
  self.uiCam = NGUIUtil:GetCameraByLayername("UI")
  self:InitBg()
  self:InitSkillCells()
  self:InitAttrCells()
  self:InitSecretLandCells()
  self:InitPaths()
  self:InitOthers()
end

function GemPage:InitBg()
  self:LoadTextures()
  self:PlayUIEffect(EffectMap.UI.GemView_circle, self:FindGO("BgEffectContainer1"))
  self:PlayUIEffect(EffectMap.UI.Gem_RuneBg, self:FindGO("BgEffectContainer3"))
  self.bgEffectContainer = self:FindGO("BgEffectContainer2")
end

function GemPage:InitSkillCells()
  self.skillCellParent = self:FindGO("SkillGems")
  self.skillCellMap, self.skillCellCount = {}, 0
  local cellGO, cell
  for cellId, _ in pairs(GameConfig.Gem.Page) do
    cellGO = self:FindGO(tostring(cellId), self.skillCellParent)
    if cellGO then
      cell = GemPageSkillCell.new(cellGO, cellId, self.pageData)
      self:AddEventListenersOfCell(cell)
      self.skillCellMap[cellId] = cell
    else
      break
    end
    self.skillCellCount = self.skillCellCount + 1
  end
  self.cellSetCompleteMap = {}
end

function GemPage:InitAttrCells()
  self.attrCellParent = self:FindGO("AttributeGems")
  self.attrCellMap, self.attrCellCount = {}, 0
  local cellGO, cell
  for cellId, _ in pairs(GemProxy.Instance.gemPageAttributeCellNeighborMap) do
    cellGO = self:FindGO(tostring(cellId), self.attrCellParent)
    if cellGO then
      cell = GemPageAttributeCell.new(cellGO, cellId, self.pageData)
      self:AddEventListenersOfCell(cell)
      self.attrCellMap[cellId] = cell
    else
      break
    end
    self.attrCellCount = self.attrCellCount + 1
  end
end

function GemPage:InitSecretLandCells()
  local config_pos = GameConfig.Gem and GameConfig.Gem.SecretLandGemPos
  if not config_pos then
    return
  end
  self.secretLandCellParent = self:FindGO("SecretLandGems")
  self.secretLandCellMap = {}
  local cellGO, cell
  for cellId, _ in pairs(config_pos) do
    cellGO = self:FindGO(tostring(cellId), self.secretLandCellParent)
    if cellGO then
      cell = GemPageSecretLandCell.new(cellGO, cellId, self.pageData)
      self:AddEventListenersOfCell(cell)
      self.secretLandCellMap[cellId] = cell
    else
      break
    end
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Gem.SecretlandGemMenuID) or GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND) then
    self.secretLandCellParent:SetActive(false)
  end
end

function GemPage:InitPaths()
  self.pathParent = self:FindGO("Paths")
  self.pathEffectContainerMap = {}
  self.pathEffectMap = {}
  local pathKey, pathGO, container
  for skillCellId, _ in pairs(self.skillCellMap) do
    for attrCellId, _ in pairs(self.attrCellMap) do
      pathKey = GemPage.GetPathKey(attrCellId, skillCellId)
      pathGO = self:FindGO(pathKey, self.pathParent)
      if pathGO then
        container = self:FindGO("EffectContainer", pathGO)
        self.pathEffectContainerMap[pathKey] = container
      end
    end
  end
end

function GemPage:InitOthers()
  self.othersContainer = self:FindGO("Others")
  self.frontEffectContainer = self:FindGO("FrontEffectContainer")
end

function GemPage:AddEventListenersOfCell(cell)
  cell:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  cell:AddEventListener(ItemEvent.GemDragStart, self.OnGemDragStart, self)
  cell:AddEventListener(ItemEvent.GemDragEnd, self.OnGemDragEnd, self)
end

function GemPage:Update(isFirst, isNewPageVersion)
  if isFirst then
    self:_Update()
    self:_ForEachSkillCell(function(_, cell)
      self:TryDelayedPlaySkillValidEffects(cell, 400)
    end)
    self:_ForEachCell(function(_, cell)
      if cell.data then
        cell:PlayEmbedSuccessEffect(self.frontEffectContainer)
      elseif isNewPageVersion then
        cell:PlaySkillValidEffect(self.frontEffectContainer)
      end
    end)
  else
    self:GetChangedCellIdsOfEmbeddedItemDatas()
    self:CreateOnceDelayTick(400, function()
      self:_Update()
      self:_ForEachSkillCell(function(_, cell)
        self:TryDelayedPlaySkillValidEffects(cell, 0)
      end)
      local removedCell, count
      for _, cellId in pairs(self.removedCellIds) do
        removedCell = self.skillCellMap[cellId] or self.attrCellMap[cellId]
        if removedCell then
          self:DestroyValidEffectsOfCell(removedCell)
          if GemProxy.CheckIsGemPageAttributeCellId(cellId) then
            self:_ForEachNeighborOfCell(self.attrCellMap[cellId], self.DestroyValidEffectsOfCell, self)
          end
        end
      end
      for _, cellId in pairs(self.addedOrUpdatedCellIds) do
        if GemProxy.CheckIsGemPageSkillCellId(cellId) then
          self:TryDelayedPlaySkillValidEffects(self.skillCellMap[cellId], nil, true)
        elseif GemProxy.CheckIsGemPageAttributeCellId(cellId) then
          self:_ForEachNeighborOfCell(self.attrCellMap[cellId], self.TryDelayedPlaySkillValidEffects, self)
        end
      end
      self:_ForEachAttributeCell(function(_, cell)
        count = 0
        self:_ForEachNeighborPathKeyOfCell(cell, function(self, pathKey)
          if self.pathEffectMap[pathKey] then
            count = count + 1
          end
        end, self)
        if count == 0 then
          cell:DestroySkillValidEffect()
          if not cell.data then
            cell:DestroyAllEffects()
          end
        end
      end)
    end)
    local newEmbedCell = self.skillCellMap[self.newEmbedCellId] or self.attrCellMap[self.newEmbedCellId]
    if newEmbedCell then
      newEmbedCell:PlayEmbedSuccessEffect(self.frontEffectContainer)
    end
    self.newEmbedCellId = nil
  end
end

function GemPage:GetChangedCellIdsOfEmbeddedItemDatas()
  self.oldCellIdItemGuidMap = self.oldCellIdItemGuidMap or {}
  TableUtility.TableClear(self.oldCellIdItemGuidMap)
  self:_ForEachCell(function(id, cell)
    self.oldCellIdItemGuidMap[id] = cell.data and cell.data.id
  end)
  self.cellIdItemGuidMap = self.cellIdItemGuidMap or {}
  TableUtility.TableClear(self.cellIdItemGuidMap)
  local attrItemData = self:GetPageAttributeItemDatas()
  local cellId
  if attrItemData then
    for i = 1, #attrItemData do
      cellId = attrItemData[i].gemAttrData.pos
      if cellId and 0 < cellId then
        self.cellIdItemGuidMap[cellId] = attrItemData[i].id
      end
    end
  end
  local skillItemData = self:GetPageSkillItemDatas()
  if skillItemData then
    for i = 1, #skillItemData do
      cellId = skillItemData[i].gemSkillData.pos
      if cellId and 0 < cellId then
        self.cellIdItemGuidMap[cellId] = skillItemData[i].id
      end
    end
  end
  self.addedOrUpdatedCellIds = self.addedOrUpdatedCellIds or {}
  TableUtility.TableClear(self.addedOrUpdatedCellIds)
  for newCellId, newItemGuid in pairs(self.cellIdItemGuidMap) do
    if self.oldCellIdItemGuidMap[newCellId] == nil or self.oldCellIdItemGuidMap[newCellId] ~= newItemGuid then
      TableUtility.ArrayPushBack(self.addedOrUpdatedCellIds, newCellId)
    end
  end
  self.removedCellIds = self.removedCellIds or {}
  TableUtility.TableClear(self.removedCellIds)
  for oldCellId, _ in pairs(self.oldCellIdItemGuidMap) do
    if self.cellIdItemGuidMap[oldCellId] == nil then
      TableUtility.ArrayPushBack(self.removedCellIds, oldCellId)
    end
  end
end

function GemPage:_Update()
  self:UpdateAttributeCells()
  self:UpdateSkillCells()
  self:UpdateSecretLandCells()
  self:SetShowNameTips(self.isShowNameTips)
end

function GemPage:UpdateAttributeCells()
  TableUtility.TableClear(self.cellSetCompleteMap)
  local attrItemData, cellId = self:GetPageAttributeItemDatas()
  if attrItemData and next(attrItemData) then
    for _, data in pairs(attrItemData) do
      cellId = data.gemAttrData.pos
      if self.attrCellMap[cellId] then
        self.attrCellMap[cellId]:SetData(data)
        self.cellSetCompleteMap[cellId] = true
      end
    end
  end
  self:_ForEachAttributeCell(function(cellId1, _)
    if not self.cellSetCompleteMap[cellId1] then
      self.attrCellMap[cellId1]:SetData()
    end
  end)
end

function GemPage:UpdateSecretLandCells()
  TableUtility.TableClear(self.cellSetCompleteMap)
  local itemData, cellId = self:GetPageSecretLandItemDatas()
  if itemData and next(itemData) then
    for _, data in pairs(itemData) do
      cellId = data.secretLandDatas and data.secretLandDatas:GetPos()
      if cellId and self.secretLandCellMap[cellId] then
        self.secretLandCellMap[cellId]:SetData(data)
        self.cellSetCompleteMap[cellId] = true
      end
    end
  end
  self:_ForEachSecretLandCell(function(cellId1, _)
    if not self.cellSetCompleteMap[cellId1] then
      self.secretLandCellMap[cellId1]:SetData()
    end
  end)
end

function GemPage:UpdateSkillCells()
  TableUtility.TableClear(self.cellSetCompleteMap)
  local skillItemData, cellId = self:GetPageSkillItemDatas()
  if skillItemData and next(skillItemData) then
    for _, data in pairs(skillItemData) do
      cellId = data.gemSkillData.pos
      if self.skillCellMap[cellId] then
        self.skillCellMap[cellId]:SetData(data)
        self.cellSetCompleteMap[cellId] = true
      end
    end
  end
  self:_ForEachSkillCell(function(cellId1, _)
    if not self.cellSetCompleteMap[cellId1] then
      self.skillCellMap[cellId1]:SetData()
    end
  end)
end

function GemPage:TryDelayedPlaySkillValidEffects(skillCell, delay, forcePlay)
  if not skillCell then
    return
  end
  delay = delay or 800
  if not skillCell.data or not GemProxy.CheckContainsGemSkillData(skillCell.data) then
    self:DestroyValidEffectsOfCell(skillCell)
    return
  end
  local needTypes = skillCell.data.gemSkillData.needAttributeGemTypes
  if not needTypes then
    self:DestroyValidEffectsOfCell(skillCell)
    return
  end
  local sculptData = skillCell.data.gemSkillData:GetSculptData()
  local sculptPos = sculptData and sculptData[1] and sculptData[1].pos
  local allActive = true
  for i = 1, #needTypes do
    if not sculptPos or sculptPos ~= i then
      local needType = needTypes[i]
      if needType ~= 0 and not self.pageData:CheckAttrGemActive(needType) then
        allActive = false
        break
      end
    end
  end
  if not allActive then
    self:DestroyValidEffectsOfCell(skillCell)
    return
  end
  local pathKeyArrId = self:_GetNewTempReusableArrayId()
  self:CreateOnceDelayTick(delay, function()
    skillCell:PlaySkillValidEffect(self.frontEffectContainer, forcePlay)
    self:_ForEachNeighborOfCell(skillCell, function(self, neighbor)
      if neighbor.data and neighbor.data.gemAttrData then
        neighbor:PlaySkillValidEffect(self.frontEffectContainer)
        TableUtility.ArrayPushBack(tempReusableArrayMap[pathKeyArrId], GemPage.GetPathKey(neighbor.id, skillCell.id))
      end
    end, self)
  end)
  self:CreateOnceDelayTick(3000 + delay, function()
    local container
    for _, pathKey in pairs(tempReusableArrayMap[pathKeyArrId]) do
      if self.pathEffectContainerMap[pathKey] then
        self:TryDestroyPathEffectByPathKey(pathKey)
        container = self.pathEffectContainerMap[pathKey]
        self:PlayUIEffect(EffectMap.UI.GemPageEnergyPath, container, false, function(obj, args, assetEffect)
          self.pathEffectMap[pathKey] = assetEffect
        end)
      end
    end
    ReusableTable.DestroyAndClearArray(tempReusableArrayMap[pathKeyArrId])
    tempReusableArrayMap[pathKeyArrId] = nil
  end)
  self:CreateOnceDelayTick(3000 + delay, function()
    self:PlayBgEffect()
  end)
end

function GemPage:OnClickCell(cellCtl)
  self:PassEvent(MouseEvent.MouseClick, cellCtl)
end

function GemPage:OnGemDragStart(cellCtl)
  self:PassEvent(ItemEvent.GemDragStart, cellCtl)
end

function GemPage:OnGemDragEnd(cellCtl)
  self:PassEvent(ItemEvent.GemDragEnd, cellCtl)
end

function GemPage:OnExit()
  tickManager:ClearTick(self)
  self:UnloadTextures()
  self:ClearAllPathEffect()
  for _, arr in pairs(tempReusableArrayMap) do
    ReusableTable.DestroyAndClearArray(arr)
  end
  TableUtility.TableClear(tempReusableArrayMap)
end

function GemPage:SetNewEmbedCellId(cellId)
  self.newEmbedCellId = cellId
end

function GemPage:SetCellsDragEnable(isEnable)
  self:_ForEachCell(function(_, cell)
    cell:SetDragEnable(isEnable)
  end)
end

function GemPage:SetShowNameTips(isShow)
  self.isShowNameTips = isShow and true or false
  self:_ForEachCell(function(_, cell)
    cell:SetShowName(self.isShowNameTips)
  end)
end

function GemPage:_ForEachSkillCell(action)
  for id, cell in pairs(self.skillCellMap) do
    action(id, cell)
  end
end

function GemPage:_ForEachAttributeCell(action)
  for id, cell in pairs(self.attrCellMap) do
    action(id, cell)
  end
end

function GemPage:_ForEachSecretLandCell(action)
  for id, cell in pairs(self.secretLandCellMap) do
    action(id, cell)
  end
end

function GemPage:_ForEachCell(action)
  self:_ForEachSkillCell(action)
  self:_ForEachAttributeCell(action)
  self:_ForEachSecretLandCell(action)
end

function GemPage:_ForEachNeighborOfCell(cell, action, args)
  if not (cell and cell.neighborIds) or not next(cell.neighborIds) then
    return
  end
  local neighborId, neighbor
  for i = 1, #cell.neighborIds do
    neighborId = cell.neighborIds[i]
    if GemProxy.CheckIsGemPageSkillCellId(cell.id) then
      neighbor = self.attrCellMap[neighborId]
    elseif GemProxy.CheckIsGemPageAttributeCellId(cell.id) then
      neighbor = self.skillCellMap[neighborId]
    else
      LogUtility.ErrorFormat("You got a neighborId = {0} of cell id = {1} which is an invalid neighborId!", neighborId, cell.id)
      neighbor = nil
    end
    if neighbor then
      action(args, neighbor)
    end
  end
end

function GemPage:_ForEachNeighborPathKeyOfCell(cell, action, args)
  if not cell or not action then
    return
  end
  local neighborIds, pathKey, attrCellId, skillCellId = cell.neighborIds
  if not neighborIds or not next(neighborIds) then
    return
  end
  for i = 1, #neighborIds do
    if GemProxy.CheckIsGemPageSkillCellId(cell.id) then
      attrCellId, skillCellId = neighborIds[i], cell.id
    elseif GemProxy.CheckIsGemPageAttributeCellId(cell.id) then
      attrCellId, skillCellId = cell.id, neighborIds[i]
    end
    pathKey = GemPage.GetPathKey(attrCellId, skillCellId)
    if pathKey then
      action(args, pathKey)
    end
  end
end

function GemPage:PlayBgEffect()
  if self.bgEffect then
    self.bgEffect:Destroy()
  end
  self:PlayUIEffect(EffectMap.UI.GemPageActivation, self.bgEffectContainer, false, function(obj, args, assetEffect)
    self.bgEffect = assetEffect
  end)
end

function GemPage:LoadTextures()
  for i = 1, #GemPageBgTexNames do
    self[GemPage.GetBgTexKey(i)] = self:FindComponent("Bg" .. i, UITexture)
    PictureManager.Instance:SetUI(GemPageBgTexNames[i], self[GemPage.GetBgTexKey(i)])
  end
end

function GemPage:UnloadTextures()
  for i = 1, #GemPageBgTexNames do
    PictureManager.Instance:UnLoadUI(GemPageBgTexNames[i], self[GemPage.GetBgTexKey(i)])
  end
end

function GemPage:DestroyValidEffectsOfCell(cell)
  if not cell or not cell.id then
    return
  end
  if not self.skillCellMap[cell.id] and self.attrCellMap[cell.id] then
    return
  end
  cell:DestroySkillValidEffect()
  self:_ForEachNeighborPathKeyOfCell(cell, self.TryDestroyPathEffectByPathKey, self)
end

function GemPage:DestroyAllEffectsOfUnembeddedCells()
  self:_ForEachCell(function(_, cell)
    if not cell.data then
      cell:DestroyAllEffects()
    end
  end)
end

function GemPage:TryDestroyPathEffectByPathKey(pathKey)
  if not pathKey then
    return
  end
  if self.pathEffectMap[pathKey] then
    self.pathEffectMap[pathKey]:Destroy()
    self.pathEffectMap[pathKey] = nil
  end
end

function GemPage:ClearAllPathEffect()
  for _, effect in pairs(self.pathEffectMap) do
    effect:Destroy()
  end
  TableUtility.TableClear(self.pathEffectMap)
end

local getPageAttributeItemDatasPredicate = function(item)
  return GemProxy.CheckContainsGemAttrData(item) and item.gemAttrData.pos and item.gemAttrData.pos > 0
end

function GemPage:GetPageAttributeItemDatas()
  return self:GetPageItemDatasByPredicate(getPageAttributeItemDatasPredicate)
end

local getPageSkillItemDatasPredicate = function(item)
  return GemProxy.CheckContainsGemSkillData(item) and item.gemSkillData.pos and item.gemSkillData.pos > 0
end

function GemPage:GetPageSkillItemDatas()
  return self:GetPageItemDatasByPredicate(getPageSkillItemDatasPredicate)
end

local getPageSecretLandItemDatasPredicate = function(item)
  return GemProxy.CheckContainsGemSecretLandData(item) and item.secretLandDatas and item.secretLandDatas:GetPos() and item.secretLandDatas:GetPos() > 0
end

function GemPage:GetPageSecretLandItemDatas()
  return self:GetPageItemDatasByPredicate(getPageSecretLandItemDatasPredicate)
end

function GemPage:GetPageItemDatasByPredicate(predicate, args)
  TableUtility.ArrayClear(tempArr)
  for _, item in pairs(self.pageData.dataMap) do
    if predicate(item, args) then
      TableUtility.ArrayPushBack(tempArr, item)
    end
  end
  return tempArr
end

function GemPage:GetHeroFeatureLv()
  return self.pageData:GetHeroFeatureLv()
end

function GemPage:GetCellById(id)
  if type(id) == "string" then
    id = tonumber(id)
  end
  if not id then
    return
  end
  return self.skillCellMap[id] or self.attrCellMap[id] or self.secretLandCellMap[id]
end

function GemPage:_GetNewTempReusableArrayId()
  self.newTempReusableArrId = self.newTempReusableArrId + 1
  tempReusableArrayMap[self.newTempReusableArrId] = ReusableTable.CreateArray()
  return self.newTempReusableArrId
end

function GemPage:CreateOnceDelayTick(delay, action)
  tickManager:CreateOnceDelayTick(delay, action, self, activeTickId)
  activeTickId = activeTickId + 1
end

function GemPage.GetPathKey(attrCellId, skillCellId)
  return string.format(ZhString.Gem_PagePathKeyFormat, attrCellId, skillCellId)
end

function GemPage.GetBgTexKey(i)
  return string.format("bg%sTex", i)
end

function GemPage:__OnViewDestroy()
  if self.skillCellMap then
    for k, cell in pairs(self.skillCellMap) do
      if cell.OnCellDestroy then
        cell:OnCellDestroy()
      end
      self.skillCellMap[k] = nil
    end
  end
  if self.attrCellMap then
    for k, cell in pairs(self.attrCellMap) do
      if cell.OnCellDestroy then
        cell:OnCellDestroy()
      end
      self.attrCellMap[k] = nil
    end
  end
  if self.secretLandCellMap then
    for k, cell in pairs(self.secretLandCellMap) do
      if cell.OnCellDestroy then
        cell:OnCellDestroy()
      end
      self.secretLandCellMap[k] = nil
    end
  end
  self:DestroyUIEffects()
  TableUtility.TableClear(self)
end
