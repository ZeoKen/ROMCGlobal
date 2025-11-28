autoImport("AdventureNormalList")
AdventureTagItemList = class("AdventureTagItemList", AdventureNormalList)
AdventureTagItemList.ClickFoldTag = "AdventureTagItemList_ClickFoldTag"

function AdventureTagItemList:Init()
  AdventureTagItemList.super.Init(self)
  self.listTagStatus = {}
  self.listSubTags = {}
  self.listAutoRemoveSubTagsFlag = {}
  self.tagItemsNumCache = {}
end

function AdventureTagItemList:InitList(itemContainer, control)
end

function AdventureTagItemList:InitItemList(itemContainer, control, prefabName)
  self.wraplist = WrapListCtrl.new(itemContainer, control, prefabName, WrapListCtrl_Dir.Vertical)
  if self.isAddMouseClickEvent then
    self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.wraplist:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
    self.wraplist:AddEventListener(AdventureTagItemList.ClickFoldTag, self.HandleClickFoldTag, self)
  end
end

function AdventureTagItemList:SetTagList(listTags, funcGetTagDatas, ownerFuncGetTagDatas)
  self.curMaxIndex = 0
  for i = 1, #listTags do
    self.curMaxIndex = self.curMaxIndex + 1
    listTags[i].tagID = listTags[i].staticId or "TagID_" .. self.curMaxIndex
    listTags[i].isTag = true
  end
  self.listTags = listTags
  self.funcGetTagDatas = funcGetTagDatas
  self.ownerFuncGetTagDatas = ownerFuncGetTagDatas
  TableUtility.TableClear(self.listSubTags)
  TableUtility.TableClear(self.tagItemsNumCache)
end

function AdventureTagItemList:SetSubTagList(parentTagID, listSubTags, autoRemoveSubTags)
  local subTag
  for i = 1, #listSubTags do
    self.curMaxIndex = self.curMaxIndex + 1
    subTag = listSubTags[i]
    subTag.tagID = subTag.staticId or "TagID_" .. self.curMaxIndex
    subTag.parentTagID = parentTagID
    subTag.isTag = true
  end
  self.listSubTags[parentTagID] = listSubTags
  self.listAutoRemoveSubTagsFlag[parentTagID] = autoRemoveSubTags
end

function AdventureTagItemList:SetRowNum(rowNum)
  self.rowNum = rowNum
end

function AdventureTagItemList:HandleClickFoldTag(cell)
  if not cell.isTag then
    redlog("Cell is not a tag!")
    return
  end
  self:SetTagOpen(cell.data.tagID, not cell.data.isOpen)
end

function AdventureTagItemList:AddListEventListener(eventType, handler, handlerOwner)
  self.wraplist:AddEventListener(eventType, handler, handlerOwner)
end

function AdventureTagItemList:Reset()
  self:ClearSelectData()
  if self.listTags then
    for i = 1, #self.listTags do
      self.listTags[i].isOpen = true
    end
  end
end

function AdventureTagItemList:IsTagOpen(tagID, categoryID)
  categoryID = categoryID or self.category and self.category.staticData.id
  if not categoryID then
    return
  end
  local tagStatus = self.listTagStatus[categoryID]
  if not tagStatus then
    return true
  end
  local isOpen = tagStatus[tagID]
  return isOpen == nil and true or isOpen
end

function AdventureTagItemList:SetTagOpen(tagID, isOpen, categoryID, doNotRefresh)
  categoryID = categoryID or self.category and self.category.staticData.id
  if not categoryID then
    return
  end
  if self:IsTagOpen(tagID) ~= isOpen then
    if not self.listTagStatus[categoryID] then
      self.listTagStatus[categoryID] = {}
    end
    self.listTagStatus[categoryID][tagID] = isOpen
    if not doNotRefresh then
      self:UpdateList(true)
    end
  end
end

function AdventureTagItemList:GetTagItemsNum(bag, tagData)
  if not self.funcGetTagDatas or not self.ownerFuncGetTagDatas then
    return 0
  end
  local categoryCache = self.tagItemsNumCache[self.category.staticData.id]
  if not categoryCache then
    categoryCache = {}
    self.tagItemsNumCache[self.category.staticData.id] = categoryCache
  end
  if categoryCache[tagData.tagID] then
    return categoryCache[tagData.tagID]
  end
  if not self.listAutoRemoveSubTagsFlag[tagData.tagID] then
    local listSubTags = self.listSubTags[tagData.tagID]
    if listSubTags then
      local totalNum = 0
      for i = 1, #listSubTags do
        totalNum = totalNum + self:GetTagItemsNum(bag, listSubTags[i])
      end
      categoryCache[tagData.tagID] = totalNum
      return totalNum
    end
  end
  local itemsInBag, isTag = self.funcGetTagDatas(self.ownerFuncGetTagDatas, bag, self.tab, tagData)
  if not itemsInBag then
    return 0
  end
  if isTag then
    local totalNum = 0
    for i = 1, #itemsInBag do
      totalNum = totalNum + self:GetTagItemsNum(bag, itemsInBag[i])
    end
    categoryCache[tagData.tagID] = nil
    return totalNum
  else
    local itemNum = itemsInBag and #itemsInBag or 0
    categoryCache[tagData.tagID] = itemNum
    return itemNum
  end
end

function AdventureTagItemList:ClearTagNumCache(tagID)
  local categoryCache = self.tagItemsNumCache[self.category.staticData.id]
  if categoryCache then
    categoryCache[tagID] = nil
  end
end

function AdventureTagItemList:RefreshTags()
  local cells = self.wraplist:GetCells()
  for i = 1, #cells do
    if cells[i].isTag and cells[i].ReloadTagData ~= nil then
      cells[i]:ReloadTagData()
    end
  end
end

local tempUp = LuaVector3.Up()

function AdventureTagItemList:SetData(datas, noResetPos)
  AdventureTagItemList.super.SetData(self, datas, noResetPos)
  if not noResetPos then
    self.scrollView:MoveRelative(-tempUp)
  end
end

function AdventureTagItemList:ReUnitData(datas, rowNum)
  rowNum = self.rowNum and self.rowNum or rowNum
  if rowNum < 2 then
    return datas
  end
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      if datas[i].isTag then
        self.unitData[#self.unitData + 1] = datas[i]
      else
        local list = self.unitData[#self.unitData]
        if list.isTag or rowNum <= #list then
          list = {}
          self.unitData[#self.unitData + 1] = list
        end
        list[#list + 1] = datas[i]
      end
    end
  end
  return self.unitData
end

function AdventureTagItemList:FindItemData(unitedDatas, itemId)
  if not unitedDatas then
    return
  end
  for i, rowDatas in ipairs(unitedDatas) do
    if not rowDatas.isTag then
      for _, data in ipairs(rowDatas) do
        if data.staticId == itemId then
          return i, data
        end
      end
    end
  end
end

function AdventureTagItemList:FindFirstClickableItemRowIndex(unitedDatas)
  if not unitedDatas then
    return
  end
  local rowDatas
  for i = 1, #unitedDatas do
    rowDatas = unitedDatas[i]
    if not rowDatas.isTag then
      for j = 1, #rowDatas do
        if rowDatas[j]:canBeClick() then
          return i
        end
      end
    end
  end
end

local itemList = {}

function AdventureTagItemList:GetTabDatas()
  if not self.category then
    redlog("category is nil")
    return
  end
  local type = self.category.staticData.id
  local bag = AdventureDataProxy.Instance.bagMap[type]
  if not bag then
    return
  end
  TableUtility.ArrayClear(itemList)
  for i = 1, #self.listTags do
    self:AddTagItems(itemList, type, bag, self.listTags[i])
  end
  return itemList
end

function AdventureTagItemList:AddTagItems(targatList, type, bag, tagData)
  if not self.funcGetTagDatas or not self.ownerFuncGetTagDatas then
    return
  end
  tagData.type = type
  tagData.isOpen = self:IsTagOpen(tagData.tagID)
  if self.listAutoRemoveSubTagsFlag[tagData.tagID] then
    self.listSubTags[tagData.tagID] = nil
    self.listAutoRemoveSubTagsFlag[tagData.tagID] = nil
  end
  local listSubTags = self.listSubTags[tagData.tagID]
  if listSubTags then
    if 0 < #listSubTags and 0 < self:GetTagItemsNum(bag, tagData) then
      targatList[#targatList + 1] = tagData
      if tagData.isOpen then
        for i = 1, #listSubTags do
          self:AddTagItems(targatList, type, bag, listSubTags[i])
        end
      end
    end
    return
  end
  local itemsInBag, isSubTag = self.funcGetTagDatas(self.ownerFuncGetTagDatas, bag, self.tab, tagData)
  if itemsInBag and 0 < #itemsInBag then
    if isSubTag then
      self:SetSubTagList(tagData.tagID, itemsInBag, true)
      if 0 < self:GetTagItemsNum(bag, tagData) then
        targatList[#targatList + 1] = tagData
        if tagData.isOpen then
          for i = 1, #itemsInBag do
            self:AddTagItems(targatList, type, bag, itemsInBag[i])
          end
        end
      end
      return
    end
    targatList[#targatList + 1] = tagData
    if tagData.isOpen then
      for i = 1, #itemsInBag do
        targatList[#targatList + 1] = itemsInBag[i]
      end
    end
  end
end

function AdventureTagItemList:SetFuncGetDefaultSelectItem(funcGetDefaultSelectItem, ownerFuncGetDefaultSelectItem)
  self.funcGetDefaultSelectItem = funcGetDefaultSelectItem
  self.ownerFuncGetDefaultSelectItem = ownerFuncGetDefaultSelectItem
end

function AdventureTagItemList:getDefaultSelectedItemData()
  if self.funcGetDefaultSelectItem then
    return self.funcGetDefaultSelectItem(self.ownerFuncGetDefaultSelectItem)
  end
  return AdventureTagItemList.super.getDefaultSelectedItemData(self)
end

local cellResult = {}

function AdventureTagItemList:GetItemCells()
  local combineCells = self.wraplist:GetCells()
  TableUtility.ArrayClear(cellResult)
  for i = 1, #combineCells do
    local v = combineCells[i]
    if not v.isTag and v.isActive then
      local childs = v:GetCells()
      for i = 1, #childs do
        table.insert(cellResult, childs[i])
      end
    end
  end
  return cellResult
end
