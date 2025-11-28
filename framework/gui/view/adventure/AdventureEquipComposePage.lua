autoImport("AdventureCombineItemCell")
autoImport("AdventureSmallCategoryCell")
autoImport("AdventureTagItemList")
autoImport("AdventureEquipCombineItemCell")
autoImport("AdventureUtil")
AdventureEquipComposePage = class("AdventureEquipComposePage", SubMediatorView)

function AdventureEquipComposePage:Init()
  self.isInited = false
end

function AdventureEquipComposePage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureEquipComposePage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:InitTagDatas()
  self:InitView()
  self:AddViewEvents()
  self.isInited = true
  self:OnEnter()
end

function AdventureEquipComposePage:InitData()
  local categorys = AdventureDataProxy.Instance:getTabsByCategory(25)
end

function AdventureEquipComposePage:InitTagDatas()
  self.categoryFilter = {
    [1] = {
      name = ZhString.EquipCompose_Title
    },
    [2] = {
      name = "二阶装备"
    },
    [3] = {
      name = "一阶装备"
    },
    [4] = {
      name = "远古装备"
    }
  }
  self.listTagStatus = {}
end

function AdventureEquipComposePage:InitView()
  self:InitCatgory()
  self.composePart = self:FindGO("ComposePart")
  self.FilterCondition = self:FindComponent("FilterCondition", UIToggle)
  self.FilterConditionLabel = self:FindComponent("Label", UILabel, self.FilterCondition.gameObject)
  self.FilterConditionLabel.text = ZhString.AdventurePanel_FilterConditionLabel
  self:AddClickEvent(self.FilterCondition.gameObject, function(obj)
    self.professionSelected = self.FilterCondition.value
    self:SetPropData(self.FilterCondition.value and GameConfig.AdventurePropClassify[9] or nil)
    self:tabClick(self.selectTabData)
  end)
  self.objNpcList = self:FindGO("normalList")
  self.tipHolder = self:FindGO("tipHolder")
  self.itemScrollView = self:FindGO("ItemScrollView"):GetComponent(ROUIScrollView)
  if not self.equipItemList then
    local container = self:FindGO("bag_itemContainer")
    local wrapConfig = {
      wrapObj = container,
      pfbNum = 8,
      cellName = "AdventureEquipCombineItemCell",
      control = AdventureEquipCombineItemCell
    }
    self.equipItemList = WrapCellHelper.new(wrapConfig)
    self.equipItemList:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.equipItemList:AddEventListener(MouseEvent.LongPress, self.HandleShowItemTip, self)
    self.equipItemList:AddEventListener(AdventureTagItemList.ClickFoldTag, self.HandleClickFoldTag, self)
  end
  self.itemTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if self.selectTabData ~= data then
      self.selectTabData = data
      xdlog("切换", data.id)
      self:tabClick(self.selectTabData)
    end
  end, self, self:FindComponent("FrontPanel", UIPanel).depth + 2)
end

function AdventureEquipComposePage:AddViewEvents()
end

function AdventureEquipComposePage:InitCatgory()
end

function AdventureEquipComposePage:SetPropData(propdata)
  self.propData = propdata
end

function AdventureEquipComposePage:tabClick(selectTabData, noResetPos)
  xdlog("切分类", selectTabData.id)
  self.selectTabData = selectTabData
  if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
    local allData = self:GetTotalEquipList(self.propData, self.selectTabData.id)
    self.equipItemList:UpdateInfo(allData, true)
  else
    local allData = self:GetTotalEquipList(self.propData, nil)
    self.equipItemList:UpdateInfo(allData, true)
  end
  if not self.initFirstChoose then
    self.initFirstChoose = true
    local combineCells = self.equipItemList.ctls
    if combineCells and 0 < #combineCells then
      for i = 1, #combineCells do
        local cells = combineCells[i]:GetCells()
        if cells and 0 < #cells then
          for j = 1, #cells do
            if cells[j].data then
              xdlog("id", cells[j].data.staticId)
              self:HandleClickItem(cells[j])
              return
            end
          end
        end
      end
    end
  end
end

function AdventureEquipComposePage:GetTotalEquipList(propData, id)
  local data = {}
  local equipComposeValid = not FunctionUnLockFunc.CheckForbiddenByFuncState("equip_compose_forbidden")
  local isOpen = self:IsTagOpen(1)
  if equipComposeValid then
    local composeList = AdventureDataProxy.Instance:GetEquipComposeList(propData, id)
    if composeList and next(composeList) then
      local tagName = ISNoviceServerType and ZhString.EquipComposeTip_EquipComposeEquip_Novice or ZhString.EquipComposeTip_EquipComposeEquip
      data[#data + 1] = {
        index = 1,
        isTag = true,
        name = tagName,
        isOpen = isOpen
      }
      if isOpen then
        for _, v in pairs(composeList) do
          TableUtility.ArrayPushBack(data, v)
        end
      end
    end
  end
  local step2List, step1List, ancientList = AdventureDataProxy.Instance:GetCommonEquip(propData, id)
  isOpen = self:IsTagOpen(2)
  if step2List and next(step2List) then
    data[#data + 1] = {
      index = 2,
      isTag = true,
      name = ZhString.EquipComposeTip_UpgradeEquip,
      isOpen = isOpen
    }
    if isOpen then
      for _, v in pairs(step2List) do
        TableUtility.ArrayPushBack(data, v)
      end
    end
  end
  isOpen = self:IsTagOpen(3)
  if step1List and next(step1List) then
    data[#data + 1] = {
      index = 3,
      isTag = true,
      name = ZhString.EquipComposeTip_BaseEquip,
      isOpen = isOpen
    }
    if isOpen then
      for _, v in pairs(step1List) do
        TableUtility.ArrayPushBack(data, v)
      end
    end
  end
  local ancientEquipValid = not FunctionUnLockFunc.CheckForbiddenByFuncState("ancient_equip_forbidden")
  if ancientEquipValid then
    isOpen = self:IsTagOpen(4)
    if ancientList and next(ancientList) then
      data[#data + 1] = {
        index = 4,
        isTag = true,
        name = ZhString.EquipComposeTip_AncientEquip,
        isOpen = isOpen
      }
      if isOpen then
        for _, v in pairs(ancientList) do
          TableUtility.ArrayPushBack(data, v)
        end
      end
    end
  end
  return data
end

function AdventureEquipComposePage:UpdateList(noResetPos)
  if not self.equipItemList then
    redlog("List Not Inited")
    return
  end
  self.equipItemList:UpdateList(noResetPos)
end

function AdventureEquipComposePage:setCategoryData(data)
  self:InitPage()
  self.data = data
  local list = {}
  if data and data.childs then
    for k, v in pairs(data.childs) do
      xdlog("childs", k)
      local classifys = v.classifys
      for i = 1, #classifys do
        table.insert(list, classifys[i])
      end
    end
    table.sort(list, function(l, r)
      return l.Order < r.Order
    end)
    if #list < 2 then
      self:Hide(self.itemTabs.gameObject)
      self:tabClick()
    else
      self:Show(self.itemTabs.gameObject)
      local tmpData = {
        id = AdventureItemNormalListPage.MaxCategory.id,
        Name = string.format(ZhString.AdventurePanel_AllTab, data.staticData.Name)
      }
      table.insert(list, 1, tmpData)
    end
    self.itemTabs:SetData(list)
  end
end

function AdventureEquipComposePage:FunGetNpcTagData(bag, tabData, tagData)
  if not tabData then
    xdlog("无分类  即全部")
  end
  local bagData = AdventureDataProxy.Instance:getBag(3)
  return bagData:GetItems(tabData)
end

function AdventureEquipComposePage:IsTagOpen(categoryId)
  local tagStatus = self.listTagStatus and self.listTagStatus[categoryId]
  if tagStatus == nil then
    return true
  end
  return tagStatus
end

function AdventureEquipComposePage:SetTagOpen(categoryId, isOpen)
  self.listTagStatus[categoryId] = isOpen
  self:tabClick(self.selectTabData)
end

function AdventureEquipComposePage:HandleClickFoldTag(cellCtrl, isOpen)
  if not cellCtrl.data.isTag then
    return
  end
  local categoryId = cellCtrl.data and cellCtrl.data.index
  self:SetTagOpen(categoryId, not cellCtrl.data.isOpen)
end

function AdventureEquipComposePage:HandleClickItem(cellCtrl, noClickSound)
  local data = cellCtrl and cellCtrl.data
  if data then
    if self.chooseItem ~= cellCtrl or data ~= self.chooseItemData then
      if self.chooseItemData then
        self.chooseItemData:setIsSelected(false)
      end
      if self.chooseItem then
        self.chooseItem:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      data:setIsSelected(true)
      cellCtrl:setIsSelected(true)
      self:ShowItemTip(data)
      self.chooseItem = cellCtrl
      self.chooseItemData = data
    end
    if not self.tip then
      self.tip = AdventureEquipComposeTip.new(self.tipHolder)
    end
    self.tip:SetData(data)
  end
end

function AdventureEquipComposePage:HandleShowItemTip(cellCtrl)
  if not self.tipOffset then
    self.tipOffset = {200, 0}
  end
  local data = cellCtrl.data
  if not data then
    return
  end
  local itemId = data.staticData.id
  self.itemTipData = self.itemTipData or {
    itemdata = ItemData.new()
  }
  self.itemTipData.itemdata:ResetData(itemId, itemId)
  local equipInfo = self.itemTipData.itemdata.equipInfo
  if equipInfo and equipInfo:IsNextGen() then
    equipInfo.isRandomPreview = true
  end
  TipManager.Instance:ShowItemFloatTip(self.itemTipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, self.tipOffset)
end

function AdventureEquipComposePage:ClearSelectData()
  if self.chooseItemData then
    self.chooseItemData:setIsSelected(false)
  end
  if self.chooseItem then
    self.chooseItem:setIsSelected(false)
  end
  self.chooseItem = nil
  self.chooseItemData = nil
end

function AdventureEquipComposePage:ShowComposeTip(data)
  self.equipItemList.m_type = data.type
  self.equipItemList:removeTip()
  self.equipItemList.tip = self:ShowEquipComposeTip(self.equipItemList.tipHolder, data)
end

function AdventureEquipComposePage:removeTip()
  if self.tipHolder.transform.childCount > 0 then
    local tip = self.tipHolder.transform:GetChild(0)
    if tip and self.tip then
      self.tip:OnExit()
    end
  end
  self.tip = nil
end

function AdventureEquipComposePage:SelectCell(itemId)
  local itemId = itemId % 100000
  local datas = self.equipItemList:GetDatas()
  for i = 1, #datas do
    local data = datas[i]
    local isTag = data.isTag
    if not isTag then
      for j = 1, #data do
        if data[j].staticId == itemId then
          self.equipItemList:SetStartPositionByIndex(i)
          break
        end
      end
    end
  end
  local combineCells = self.equipItemList:GetCellCtls()
  if combineCells and 0 < #combineCells then
    for i = 1, #combineCells do
      local cells = combineCells[i]:GetCells()
      if cells and 0 < #cells then
        for j = 1, #cells do
          if cells[j].data and cells[j].data.staticId == itemId then
            self:HandleClickItem(cells[j])
            return
          end
        end
      end
    end
  end
end

function AdventureEquipComposePage:FindItemData(unitedDatas, itemId)
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

function AdventureEquipComposePage:ShowSelf()
  self:InitPage()
  self:Show()
end

function AdventureEquipComposePage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureEquipComposePage.super.OnEnter(self)
end

function AdventureEquipComposePage:OnExit()
  if self.isInited then
    self:removeTip()
  end
  AdventureEquipComposePage.super.OnExit(self)
end

function AdventureEquipComposePage:Show(obj)
  if not obj and not self.isInited then
    return
  end
  AdventureEquipComposePage.super.Show(self, obj)
end

function AdventureEquipComposePage:Hide(obj)
  if not obj then
    if not self.isInited then
      return
    end
    self:removeTip()
  end
  self.initFirstChoose = false
  TableUtility.TableClear(self.listTagStatus)
  AdventureEquipComposePage.super.Hide(self, obj)
end

function AdventureEquipComposePage:OnDestroy()
  if self.isInited then
    self.itemTabs:Destroy()
    if self.equipItemList then
      self.equipItemList:Destroy()
    end
  end
  AdventureResearchPage.super.OnDestroy(self)
end
