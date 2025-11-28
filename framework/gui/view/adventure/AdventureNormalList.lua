autoImport("ItemNormalList")
AdventureNormalList = class("AdventureNormalList", ItemNormalList)
autoImport("WrapListCtrl")
autoImport("BagCombineItemCell")
autoImport("PhotographResultPanel")
AdventureNormalList.UpdateCellRedTip = "AdventureNormalList_UpdateCellRedTip"

function AdventureNormalList:ctor(go, tipHolder, control, isAddMouseClickEvent)
  if go then
    self.gameObject = go
    self.control = control or BagCombineItemCell
    self.tipHolder = tipHolder
    if isAddMouseClickEvent == true or isAddMouseClickEvent == nil then
      self.isAddMouseClickEvent = true
    else
      self.isAddMouseClickEvent = false
    end
    self.ItemTabLst = {}
    self.NewTagLst = {}
    self:Init()
    self.itemDatas = nil
  else
    error("can not find itemListObj")
  end
  self.selectData = nil
end

function AdventureNormalList:ShowItemTip(data)
  self.m_type = data.type
  local chooseState = self:removeTip()
  if not data then
    return
  end
  self:sendNotification(AdventurePanel.NoItemStage, AdventureDataProxy.NoItemTipStageType.CloseAll)
  self:Show(self.normalListSp)
  if data.type == SceneManual_pb.EMANUALTYPE_NPC or data.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
    self.tip = self:ShowNpcScoreTip(self.tipHolder, data)
  elseif data.type == SceneManual_pb.EMANUALTYPE_PET then
    self.tip = self:ShowPetScoreTip(self.tipHolder, data)
  elseif data.type == SceneManual_pb.EMANUALTYPE_MONSTER then
    self.tip = self:ShowMonsterScoreTip(self.tipHolder, data)
  elseif data.type == SceneManual_pb.EMANUALTYPE_COLLECTION then
    if data.tabData.id == AdventureDataProxy.MonthCardTabId then
      self.tip = self:ShowMonthScoreTip(self.tipHolder, data)
    else
      self.tip = self:ShowCollectScoreTip(self.tipHolder, data)
    end
  elseif data:isCollectionGroup() then
    self:Hide(self.normalListSp)
    self.tip = self:ShowCollectGroupScoreTip(self.tipHolder, data)
  elseif data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or data.type == SceneManual_pb.EMANUALTYPE_ITEM then
    xdlog("发型  道具处理")
    self.tip = self:ShowCollectScoreTip(self.tipHolder, data)
  else
    self.tip = self:ShowItemScoreTip(self.tipHolder, data, chooseState)
  end
end

function AdventureNormalList:CheckCanReUseTip(data)
  if not self.tip then
    return
  end
  local tipData = self.tip.data
  if tipData.type == data.type then
    if not data:isCollectionGroup() and data.tabData.id ~= tipData.tabData.id then
      return false
    end
    return true
  end
end

function AdventureNormalList:ShowPetScoreTip(container, itemdata)
  local scoreTip = PetScoreTip.new(container)
  scoreTip:SetData(itemdata)
  return scoreTip
end

function AdventureNormalList:ShowItemScoreTip(container, itemdata, chooseState)
  local scoreTip = ItemScoreTip.new(container)
  scoreTip:SetData(itemdata, chooseState)
  return scoreTip
end

function AdventureNormalList:ShowMonthScoreTip(container, itemdata)
  local scoreTip = MonthScoreTip.new(container)
  scoreTip:SetData(itemdata)
  return scoreTip
end

function AdventureNormalList:ShowCollectGroupScoreTip(container, itemdata)
  local scoreTip = CollectGroupScoreTip.new(container)
  scoreTip:SetData(itemdata)
  return scoreTip
end

function AdventureNormalList:ShowCollectScoreTip(container, itemdata)
  local scoreTip = CollectScoreTip.new(container)
  scoreTip:SetData(itemdata)
  return scoreTip
end

function AdventureNormalList:ShowMonsterScoreTip(container, monsterdata)
  local scoreTip = MonsterScoreTip.new(container)
  scoreTip:SetData(monsterdata)
  return scoreTip
end

function AdventureNormalList:ShowNpcScoreTip(container, npcdata)
  local scoreTip = NpcScoreTip.new(container)
  scoreTip:SetData(npcdata)
  return scoreTip
end

function AdventureNormalList:ShowEquipComposeTip(container, itemData)
  local scoreTip = AdventureEquipComposeTip.new(container)
  scoreTip:SetData(itemData)
  return scoreTip
end

function AdventureNormalList:Init()
  self:InitList(self:FindGO("bag_itemContainer"), self.control)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  
  self.normalListSp = self:FindGO("normalListSp")
end

function AdventureNormalList:InitList(itemContainer, control)
  self.wraplist = WrapListCtrl.new(itemContainer, control, "AdventureBagCombineItemCell", WrapListCtrl_Dir.Vertical)
  if self.isAddMouseClickEvent then
    self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.wraplist:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
  end
end

function AdventureNormalList:updateCellTip(cellCtl)
  self:PassEvent(AdventureNormalList.UpdateCellRedTip, cellCtl)
end

function AdventureNormalList:UpdateList(noResetPos)
  self:SetData(self:GetTabDatas(), noResetPos)
end

function AdventureNormalList:getDefaultSelectedItemData()
  local cells = self:GetItemCells() or {}
  if 0 < #cells then
    if self.chooseItemData then
      for i = 1, #cells do
        local single = cells[i]
        if single.data then
          local tmpList = ReusableTable.CreateArray()
          local bRel = single.data.type == self.chooseItemData.type and single.data.staticId == self.chooseItemData.staticId
          bRel = bRel and single.data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT
          ReusableTable.DestroyAndClearArray(tmpList)
          if bRel then
            return single
          end
        end
      end
    else
      for i = 1, #cells do
        local cell = cells[i]
        if cell.data then
          local tmpList = ReusableTable.CreateArray()
          local awardList = cell.data:getCompleteNoRewardAppend(tmpList)
          if cell.data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT and #awardList < 1 then
            ReusableTable.DestroyAndClearArray(tmpList)
            return cell
          end
          ReusableTable.DestroyAndClearArray(tmpList)
        end
      end
    end
  end
end

function AdventureNormalList:removeTip()
  local chooseState
  if self.tipHolder.transform.childCount > 0 then
    local tip = self.tipHolder.transform:GetChild(0)
    if tip and self.tip then
      chooseState = self.tip:OnExit()
    end
  end
  self.tip = nil
  return chooseState
end

function AdventureNormalList:checkUnlockData()
  if self.toBeUnlock then
    local lockType = self.toBeUnlock.type
    local lockId = self.toBeUnlock.staticId
    local cells = self:GetItemCells()
    if cells then
      for i = 1, #cells do
        local single = cells[i]
        if single.data then
          local singleId = single.data.staticId
          local singleType = single.data.type
          local singleSt = single.data.status
          if lockType == singleType and singleId == lockId then
            single:PlayUnlockEffect()
            self:HandleClickItem(single, true)
            self.toBeUnlock = nil
            return true
          end
        end
      end
    end
  end
end

function AdventureNormalList:resetSelectState(datas, noResetPos)
  if not noResetPos then
    if self.wraplist then
      self.wraplist:ResetPosition()
    end
    if self.chooseItem and self.chooseItemData then
      self.chooseItemData:setIsSelected(false)
      self.chooseItem:setIsSelected(false)
    end
    self:ClearSelectData()
  end
end

function AdventureNormalList:SetPropData(propData, keys, customProps)
  self.propData = propData
  self.keys = keys
  self.customProps = customProps
end

function AdventureNormalList:SetData(datas, noResetPos)
  helplog("AdventureNormalList:SetData")
  self.itemDatas = datas or {}
  for i = #self.itemDatas, 1, -1 do
    local tb = Table_Equip[self.itemDatas[i].staticId]
    if tb ~= nil and tb.ShowInBook ~= nil and tb.ShowInBook == 1 then
      table.remove(self.itemDatas, i)
    end
  end
  self:resetSelectState(self.itemDatas, noResetPos)
  self.unitedDatas = self:ReUnitData(self.itemDatas, 5)
  self.wraplist:ResetDatas(self.unitedDatas)
  local defaultItem = self:getDefaultSelectedItemData()
  self.selectData = nil
  local handleSelect = self:checkUnlockData()
  if not handleSelect then
    self:HandleClickItem(defaultItem, true)
  end
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end

function AdventureNormalList:SelectCell(itemId)
  local rowIndex, data = self:FindItemData(self.unitedDatas, itemId)
  if rowIndex then
    self.wraplist:SetStartPositionByIndex(rowIndex)
    local cell = self:FindCellByItemId(itemId)
    if cell then
      self:HandleClickItem(cell, true)
    end
  end
end

function AdventureNormalList:FindCellByItemId(itemId)
  local cells = self:GetItemCells()
  if cells then
    for _, cell in ipairs(cells) do
      if cell.data and cell.data.staticId == itemId then
        return cell
      end
    end
  end
end

function AdventureNormalList:FindItemData(unitedDatas, itemId)
  return nil
end

function AdventureNormalList:JumpToFirstClickableItem(force)
  local firstClickableIndex = self:FindFirstClickableItemRowIndex(self.unitedDatas)
  if firstClickableIndex or force then
    self.wraplist:SetStartPositionByIndex(firstClickableIndex or 0)
  end
end

function AdventureNormalList:FindFirstClickableItemRowIndex(unitedDatas)
  if not unitedDatas then
    return
  end
  local rowDatas
  for i = 1, #unitedDatas do
    rowDatas = unitedDatas[i]
    for j = 1, #rowDatas do
      if rowDatas[j]:canBeClick() then
        return i
      elseif rowDatas[j]:isCollectionGroup() then
        local collectionDatas = rowDatas[j]:getCollectionData()
        for x = 1, #collectionDatas do
          if collectionDatas[x]:canBeClick() then
            return i
          end
        end
      end
    end
  end
end

function AdventureNormalList:HandleClickItem(cellCtl, noClickSound)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    if not noClickSound then
      if data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
        ServiceSceneManualProxy.Instance:CallUnlock(data.type, data.staticId)
        self:PlayUISound(AudioMap.UI.maoxianshoucedianjijiesuo)
        self.toBeUnlock = data
        return
      elseif data:canBeClick() then
        local tmpList = ReusableTable.CreateArray()
        local appendData = data:getCompleteNoRewardAppend(tmpList)
        appendData = appendData[1]
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.AdventureAppendRewardPanel,
          viewdata = appendData
        })
        ReusableTable.DestroyAndClearArray(tmpList)
        self.toBeUnlock = data
        return
      end
    end
    if self.chooseItem ~= cellCtl or data ~= self.chooseItemData or noClickSound then
      if self.chooseItemData then
        self.chooseItemData:setIsSelected(false)
      end
      if self.chooseItem and self.chooseItem ~= cellCtl then
        self.chooseItem:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      data:setIsSelected(true)
      cellCtl:setIsSelected(true)
      if self:CheckCanReUseTip(data) then
        self.tip:SetData(data)
        if self.tip.scrollView and self.chooseItem ~= cellCtl then
          self.tip.scrollView:ResetPosition()
        end
      else
        self:ShowItemTip(data)
        if self.tip and self.tip.scrollView and self.chooseItem ~= cellCtl then
          self.tip.scrollView:ResetPosition()
        end
      end
      self.chooseItem = cellCtl
      self.chooseItemData = data
    end
  end
  if not cellCtl and self.chooseItemData then
    local exsit = self:checkItemDataValid(self.chooseItemData)
    if exsit then
      if noClickSound and self.tip then
        self.tip:SetData(self.chooseItemData)
      else
        self:ShowItemTip(self.chooseItemData)
      end
    end
  elseif not cellCtl and not self.chooseItemData then
    self:removeTip()
    self:sendNotification(AdventurePanel.NoItemStage, AdventureDataProxy.NoItemTipStageType.ShowLeft)
  end
end

function AdventureNormalList:checkItemDataValid(itemData)
  for i = 1, #self.itemDatas do
    if itemData.staticId == self.itemDatas[i].staticId then
      return true
    end
  end
end

function AdventureNormalList:setCategoryAndTab(category, tab)
  self.category = category
  self.tab = tab
  if self.propData and self.propData.extraType == "myprofession" then
    self:SetPropData(nil, nil, nil)
  end
end

function AdventureNormalList:OnExit()
  self:ClearSelectData()
  self:removeTip()
  self.itemDatas = nil
  if self.wraplist then
    self.wraplist:Destroy()
    self.wraplist = nil
  end
  self.scrollView = nil
  AdventureNormalList.super.OnDestroy(self)
end

function AdventureNormalList:OnEnter()
end

function AdventureNormalList:ClearSelectData()
  if self.chooseItemData then
    self.chooseItemData:setIsSelected(false)
  end
  if self.chooseItem then
    self.chooseItem:setIsSelected(false)
  end
  self.chooseItem = nil
  self.chooseItemData = nil
end

local listItems = {}

function AdventureNormalList:GetTabDatas()
  if self.category then
    local type = self.category.staticData.id
    local tab = self.tab and self.tab.id or nil
    local weaponConfig = GameConfig.AdventureWeaponConfig
    TableUtility.ArrayClear(listItems)
    for id, config in pairs(weaponConfig) do
      if type == config.type and tab == config.tab then
        local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, self.isMyProfession, config.weapontab)
        for i = 1, #weapons do
          if weapons[i]:CheckEquipCanShowInFashion() then
            listItems[#listItems + 1] = weapons[i]
          end
        end
        listItems = AdventureDataProxy.Instance:getItemsByFilterData(type, listItems, self.propData, self.keys, self.customProps)
        return listItems
      end
    end
    local hairStyleConfig = GameConfig.AdventureHairStyleConfig
    for id, config in pairs(hairStyleConfig) do
      if type == config.type and tab == config.tab then
        local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, self.isMyProfession, config.adventureLogID)
        if weapons and 0 < #weapons then
          for i = 1, #weapons do
            listItems[#listItems + 1] = weapons[i]
          end
        end
        listItems = AdventureDataProxy.Instance:getItemsByFilterData(type, listItems, self.propData, self.keys, self.customProps)
        return listItems
      end
    end
    local bag = AdventureDataProxy.Instance.bagMap[type]
    if bag then
      local items
      if tab == 50003 then
        items = bag:GetItems(nil)
        local fashionItems = bag:GetItems(1045)
        local n = #fashionItems
        for i = 1, n do
          items[#items + 1] = fashionItems[i]
        end
        local weaponConfig = GameConfig.AdventureWeaponConfig
        for id, config in pairs(weaponConfig) do
          if type == config.type and 1046 == config.tab then
            local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, self.isMyProfession, config.weapontab)
            for i = 1, #weapons do
              if weapons[i]:CheckEquipCanShowInFashion() then
                items[#items + 1] = weapons[i]
              end
            end
          end
        end
        for id, config in pairs(weaponConfig) do
          if type == config.type and 1047 == config.tab then
            local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, self.isMyProfession, config.weapontab)
            for i = 1, #weapons do
              if weapons[i]:CheckEquipCanShowInFashion() then
                items[#items + 1] = weapons[i]
              end
            end
          end
        end
      else
        items = bag:GetItems(tab)
      end
      local single
      if type == SceneManual_pb.EMANUALTYPE_COLLECTION then
        for i = 1, #items do
          single = items[i]
          if not single:getCollectionGroupId() then
            listItems[#listItems + 1] = single
          end
        end
        if tab ~= 1052 then
          if self.propData then
            TableUtility.ArrayClear(listItems)
          end
          local groups = AdventureDataProxy.Instance:GetAllUnlockCollectionGroups()
          for i = 1, #groups do
            local single = groups[i]
            if single.staticId == 50 then
              if single:isTotalComplete() then
                listItems[#listItems + 1] = single
              end
            else
              listItems[#listItems + 1] = single
            end
          end
          local sortFunc = function(l, r)
            if l.staticData.SortNum and r.staticData.SortNum then
              return l.staticData.SortNum < r.staticData.SortNum
            elseif not l.staticData.SortNum and not r.staticData.SortNum then
              return l.staticId < r.staticId
            elseif not l.staticData.SortNum then
              return true
            else
              return false
            end
          end
          table.sort(listItems, sortFunc)
          listItems = AdventureDataProxy.Instance:getItemsByFilterData(type, listItems, self.propData, self.keys, self.customProps)
        elseif self.propData then
          TableUtility.ArrayClear(listItems)
        end
        return listItems
      elseif type == SceneManual_pb.EMANUALTYPE_MOUNT and not AdventureDataProxy.IsShowMech() then
        local mechCfg = GameConfig.Mount2Body
        for i = 1, #items do
          single = items[i]
          if not mechCfg[single.staticData.id] then
            listItems[#listItems + 1] = single
          end
        end
        return listItems
      end
      for id, config in pairs(weaponConfig) do
        if type == config.type and not tab then
          local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, false, config.weapontab)
          for i = 1, #weapons do
            if weapons[i]:CheckEquipCanShowInFashion() then
              items[#items + 1] = weapons[i]
            end
          end
        end
      end
      for id, config in pairs(hairStyleConfig) do
        if type == config.type and not tab then
          local specialItems = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, false, config.adventureLogID)
          for i = 1, #specialItems do
            items[#items + 1] = specialItems[i]
          end
        end
      end
      items = AdventureDataProxy.Instance:getItemsByFilterData(type, items, self.propData, self.keys, self.customProps)
      if (self.tab and self.tab.id) == 50003 then
        items = AdventureDataProxy.Instance:getItemsByFilterData(type, items, {extraType = "locked"}, self.keys, self.customProps)
      else
        items = AdventureDataProxy.Instance:getItemsByFilterData(type, items, self.propData, self.keys, self.customProps)
      end
      return items
    end
  else
    printRed("category is nil")
  end
end

function AdventureNormalList.GetTabDatas4CommonShow(type, tab, propData, keys, isMyProfession)
  local itemDatas = AdventureNormalList.GetTabDatas4CommonUsage(type, tab, propData, keys, isMyProfession)
  for i = #itemDatas, 1, -1 do
    local tb = Table_Equip[itemDatas[i].staticId]
    if tb ~= nil and tb.ShowInBook ~= nil and tb.ShowInBook == 1 then
      table.remove(itemDatas, i)
    end
  end
  return itemDatas
end

function AdventureNormalList.GetTabDatas4CommonUsage(type, tab, propData, keys, isMyProfession)
  local weaponConfig = GameConfig.AdventureWeaponConfig
  TableUtility.ArrayClear(listItems)
  for id, config in pairs(weaponConfig) do
    if type == config.type and tab == config.tab then
      local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, isMyProfession, config.weapontab)
      for i = 1, #weapons do
        if weapons[i]:CheckEquipCanShowInFashion() then
          listItems[#listItems + 1] = weapons[i]
        end
      end
      listItems = AdventureDataProxy.Instance:getItemsByFilterData(type, listItems, propData, keys)
      return listItems
    end
  end
  local bag = AdventureDataProxy.Instance.bagMap[type]
  if bag then
    local items, single = bag:GetItems(tab)
    if type == SceneManual_pb.EMANUALTYPE_COLLECTION then
      for i = 1, #items do
        single = items[i]
        if not single:getCollectionGroupId() then
          listItems[#listItems + 1] = single
        end
      end
      if tab ~= 1052 then
        if propData then
          TableUtility.ArrayClear(listItems)
        end
        local groups = AdventureDataProxy.Instance:GetAllUnlockCollectionGroups()
        for i = 1, #groups do
          local single = groups[i]
          if single.staticId == 50 then
            if single:isTotalComplete() then
              listItems[#listItems + 1] = single
            end
          else
            listItems[#listItems + 1] = single
          end
        end
        local sortFunc = function(l, r)
          if l.staticData.SortNum and r.staticData.SortNum then
            return l.staticData.SortNum < r.staticData.SortNum
          elseif not l.staticData.SortNum and not r.staticData.SortNum then
            return l.staticId < r.staticId
          elseif not l.staticData.SortNum then
            return true
          else
            return false
          end
        end
        table.sort(listItems, sortFunc)
        listItems = AdventureDataProxy.Instance:getItemsByFilterData(type, listItems, propData, keys)
      elseif propData then
        TableUtility.ArrayClear(listItems)
      end
      return listItems
    elseif type == SceneManual_pb.EMANUALTYPE_MOUNT and not AdventureDataProxy.IsShowMech() then
      local mechCfg = GameConfig.Mount2Body
      for i = 1, #items do
        single = items[i]
        if not mechCfg[single.staticData.id] then
          listItems[#listItems + 1] = single
        end
      end
      return listItems
    end
    for id, config in pairs(weaponConfig) do
      if type == config.type and not tab then
        local weapons = AdventureDataProxy.Instance:getItemsByCategoryAndClassify(config.equipclassify, false, config.weapontab)
        for i = 1, #weapons do
          if weapons[i]:CheckEquipCanShowInFashion() then
            items[#items + 1] = weapons[i]
          end
        end
      end
    end
    items = AdventureDataProxy.Instance:getItemsByFilterData(type, items, propData, keys)
    return items
  end
end

function AdventureNormalList:ItemUpdate()
  local tip = self.tip
  if tip == nil or tip.ItemUpdate == nil then
    return
  end
  tip:ItemUpdate()
end
