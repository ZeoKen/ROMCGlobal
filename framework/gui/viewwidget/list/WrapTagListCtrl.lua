autoImport("WrapListCtrl")
WrapTagListCtrl = class("WrapTagListCtrl", WrapListCtrl)
WrapTagListCtrl.ClickFoldTag = "WrapTagListCtrl_ClickFoldTag"

function WrapTagListCtrl:OnInit()
  WrapTagListCtrl.super.OnInit(self)
  self:AddEventListener(WrapTagListCtrl.ClickFoldTag, self.HandleClickFoldTag, self)
  self.listTagStatus = {}
  self.listSubTags = {}
  self.listAutoRemoveSubTagsFlag = {}
  self.tagItemsNumCache = {}
  self.realDataList = {}
end

function WrapTagListCtrl:SetTagList(listTags, funcGetTagDatas, ownerFuncGetTagDatas)
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
  TableUtility.TableClear(self.listTagStatus)
  TableUtility.TableClear(self.listAutoRemoveSubTagsFlag)
end

function WrapTagListCtrl:SetColNum(colNum)
  self.colNum = colNum
end

function WrapTagListCtrl:SetSubTagList(parentTagID, listSubTags, autoRemoveSubTags)
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

function WrapTagListCtrl:HandleClickFoldTag(cellData)
  if not cellData.isTag then
    redlog("Cell is not a tag!")
    return
  end
  self:SetTagOpen(cellData.tagID, not cellData.isTagOpen)
end

function WrapTagListCtrl:ResetTagStatus()
  TableUtility.TableClear(self.listTagStatus)
  if self.listTags then
    for i = 1, #self.listTags do
      self.listTags[i].isTagOpen = true
    end
  end
  self:UpdateList(true)
end

function WrapTagListCtrl:IsTagOpen(tagID)
  local isOpen = self.listTagStatus[tagID]
  return isOpen == nil and true or isOpen
end

function WrapTagListCtrl:SetTagOpen(tagID, isOpen, doNotRefresh)
  if self:IsTagOpen(tagID) ~= isOpen then
    self.listTagStatus[tagID] = isOpen
    if not doNotRefresh then
      self:UpdateList(false)
    end
  end
end

function WrapTagListCtrl:GetTagItemsNum(tagData)
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
        totalNum = totalNum + self:GetTagItemsNum(listSubTags[i])
      end
      categoryCache[tagData.tagID] = totalNum
      return totalNum
    end
  end
  local itemsInTag, isTag = self.funcGetTagDatas(self.ownerFuncGetTagDatas, tagData)
  if isTag then
    local totalNum = 0
    for i = 1, #itemsInTag do
      totalNum = totalNum + self:GetTagItemsNum(itemsInTag[i])
    end
    categoryCache[tagData.tagID] = nil
    return totalNum
  else
    local itemNum = itemsInTag and #itemsInTag or 0
    categoryCache[tagData.tagID] = itemNum
    return itemNum
  end
end

function WrapTagListCtrl:ClearTagNumCache(tagID)
  local categoryCache = self.tagItemsNumCache[self.category.staticData.id]
  if categoryCache then
    categoryCache[tagID] = nil
  end
end

function WrapTagListCtrl:ReUnitDataForCell(datas)
  local colNum = self.colNum or 1
  if not colNum or colNum < 2 then
    return datas
  end
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas and 0 < #datas then
    for i = 1, #datas do
      if datas[i].isTag then
        self.unitData[#self.unitData + 1] = datas[i]
      else
        local list = self.unitData[#self.unitData]
        if list.isTag or colNum <= #list then
          list = {}
          self.unitData[#self.unitData + 1] = list
        end
        list[#list + 1] = datas[i]
      end
    end
  end
  return self.unitData
end

function WrapTagListCtrl:UpdateList(isLayOut)
  TableUtility.ArrayClear(self.realDataList)
  for i = 1, #self.listTags do
    self:AddTagItems(self.realDataList, self.listTags[i])
  end
  WrapTagListCtrl.super.ResetDatas(self, self:ReUnitDataForCell(self.realDataList), isLayOut)
end

function WrapTagListCtrl:ResetDatas(datas, isLayOut)
  redlog("Don't call ResetDatas() in WrapTagListCtrl! Use SetTagList() and SetSubTagList() to reset datas.")
end

function WrapTagListCtrl:AddTagItems(targatList, tagData)
  if not self.funcGetTagDatas or not self.ownerFuncGetTagDatas then
    return
  end
  tagData.isTagOpen = self:IsTagOpen(tagData.tagID)
  if self.listAutoRemoveSubTagsFlag[tagData.tagID] then
    self.listSubTags[tagData.tagID] = nil
    self.listAutoRemoveSubTagsFlag[tagData.tagID] = nil
  end
  local listSubTags = self.listSubTags[tagData.tagID]
  if listSubTags then
    if 0 < #listSubTags and 0 < self:GetTagItemsNum(tagData) then
      targatList[#targatList + 1] = tagData
      if tagData.isTagOpen then
        for i = 1, #listSubTags do
          self:AddTagItems(targatList, listSubTags[i])
        end
      end
    end
    return
  end
  local itemsInTag, isSubTag = self.funcGetTagDatas(self.ownerFuncGetTagDatas, tagData)
  if itemsInTag and 0 < #itemsInTag then
    if isSubTag then
      self:SetSubTagList(tagData.tagID, itemsInTag, true)
      if 0 < self:GetTagItemsNum(tagData) then
        targatList[#targatList + 1] = tagData
        if tagData.isTagOpen then
          for i = 1, #itemsInTag do
            self:AddTagItems(targatList, itemsInTag[i])
          end
        end
      end
      return
    end
    targatList[#targatList + 1] = tagData
    if tagData.isTagOpen then
      for i = 1, #itemsInTag do
        targatList[#targatList + 1] = itemsInTag[i]
      end
    end
  end
end
