autoImport("AdventureCombineNpcCell")
autoImport("AdventureTagItemList")
autoImport("AdventureSmallCategoryCell")
autoImport("AdventurePrestigeCell")
autoImport("AdventureUtil")
AdventureNpcListPage = class("AdventureNpcListPage", SubMediatorView)
AdventureNpcListPage.ClickReward = "AdventureNpcListPage_ClickReward"

function AdventureNpcListPage:Init()
  self.listOganizationNpcDatas = {}
  self.categoryDatas = {}
  self.isInited = false
end

function AdventureNpcListPage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureNpcListPage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:InitTagDatas()
  self:initView()
  self:AddEvents()
  self.isInited = true
  self:OnEnter()
end

function AdventureNpcListPage:InitTagDatas()
  self.listNpcTags = {}
  for mapID, zoneData in pairs(Table_ManualZone) do
    self.listNpcTags[#self.listNpcTags + 1] = {id = mapID, zoneStaticData = zoneData}
  end
  table.sort(self.listNpcTags, function(l, r)
    return l.id < r.id
  end)
  self.listNpcTags[#self.listNpcTags + 1] = {
    id = GameConfig.AdventureDefaultTag.id,
    isDefaultTag = true
  }
  self.listPrestigeTags = {
    {
      id = 1,
      text = ZhString.Adventure_Prestige,
      achievedText = ZhString.Adventure_PrestigeAchieved,
      isMainTag = true
    },
    {
      id = 2,
      text = ZhString.Adventure_PersonalPrestige,
      achievedText = ZhString.Adventure_PersonalPrestigeAchieved,
      isMainTag = true
    }
  }
end

function AdventureNpcListPage:initView()
  self.objNpcList = self:FindGO("normalList")
  self.npcItemList = AdventureTagItemList.new(self.objNpcList, self:FindGO("tipHolder", self.objNpcList), AdventureCombineNpcCell)
  self.npcItemList:InitItemList(self:FindGO("bag_itemContainer", self.objNpcList), AdventureCombineNpcCell, "AdventureNpcCombineItemCell")
  self.npcItemList:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
  self.npcItemList:SetTagList(self.listNpcTags, self.FunGetNpcTagData, self)
  self.objPrestigeList = self:FindGO("prestigeNormalList")
  self.prestigeItemList = AdventureTagItemList.new(self.objPrestigeList, self:FindGO("tipHolder", self.objPrestigeList), AdventurePrestigeCell)
  self.prestigeItemList:InitItemList(self:FindGO("bag_itemContainer", self.objPrestigeList), AdventurePrestigeCell, "AdventurePrestigeCell")
  self.prestigeItemList:SetTagList(self.listPrestigeTags, self.FunGetPrestigeTagData, self)
  self.prestigeItemList:SetFuncGetDefaultSelectItem(self.FunGetPrestigeDefaultSelectItem, self)
  self.prestigeItemList:SetRowNum(1)
  for id, prestigeSData in pairs(Table_Prestige) do
    self.prestigeItemList:SetTagOpen(prestigeSData.id, false, SceneManual_pb.EMANUALTYPE_PRESTIGE, true)
  end
  self.OneItemTabs = self:FindComponent("OneItemTabs", UILabel)
  self.itemTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if self.selectTabData ~= data then
      self.selectTabData = data
      self:tabClick(self.selectTabData)
      self.tagItemList:SetPropData(nil, nil)
    end
  end, self, self:FindComponent("Panel", UIPanel).depth + 2)
  self:TryOpenHelpViewById(721, nil, self:FindGO("btnHelp"))
  self.objCategories = self:FindGO("TypeTabs")
  self.listCategories = UIGridListCtrl.new(self:FindComponent("gridTabs", UIGrid, self.objCategories), AdventureSmallCategoryCell, "AdventureSmallCategoryCell")
  self.listCategories:AddEventListener(MouseEvent.MouseClick, self.HandleClickCategory, self)
end

function AdventureNpcListPage:AddEvents()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
  self:AddListenEvt(ServiceEvent.SceneManualNpcZoneDataManualCmd, self.RefreshZoneTags)
  self:AddListenEvt(ServiceEvent.SceneManualNpcZoneRewardManualCmd, self.RefreshZoneTags)
  self.npcItemList:AddListEventListener(AdventureNpcListPage.ClickReward, self.ClickZoneReward, self)
end

function AdventureNpcListPage:setCategoryData(data)
  self:InitPage()
  self.data = data
  if self.curCategoryCell then
    self.curCategoryCell:Select(false)
    self.curCategoryCell = nil
  end
  local catagories = GameConfig.AdventureTypeCategoryTabs[data.staticData.id]
  local multiCategoties = catagories and 1 < #catagories
  self.OneItemTabs.gameObject:SetActive(multiCategoties ~= true)
  self.objCategories:SetActive(multiCategoties == true)
  if multiCategoties then
    TableUtility.ArrayClear(self.categoryDatas)
    for i = 1, #catagories do
      self.categoryDatas[#self.categoryDatas + 1] = AdventureDataProxy.Instance.categoryDatas[catagories[i]]
    end
    self.listCategories:ResetDatas(self.categoryDatas)
    local cells = self.listCategories:GetCells()
    if cells and 0 < #cells then
      self:HandleClickCategory(cells[1])
    end
  else
    self:SetRealCategoryData(data)
  end
end

function AdventureNpcListPage:HandleClickCategory(cell)
  if self.curCategoryCell == cell then
    return
  end
  if self.curCategoryCell then
    self.curCategoryCell:Select(false)
  end
  self.curCategoryCell = cell
  self.curCategoryCell:Select(true)
  self:SetRealCategoryData(cell.data)
end

local listPopUpItems = {}

function AdventureNpcListPage:SetRealCategoryData(data)
  self.realData = data
  if self.tagItemList then
    self.tagItemList:SetPropData(nil, nil)
    self.tagItemList:Reset()
    self.tagItemList:removeTip()
  end
  if not self.realData or not self.realData.childs then
    return
  end
  local isPrestige = self.realData.staticData.id == SceneManual_pb.EMANUALTYPE_PRESTIGE
  self.objNpcList:SetActive(not isPrestige)
  self.objPrestigeList:SetActive(isPrestige)
  self.tagItemList = isPrestige and self.prestigeItemList or self.npcItemList
  self.OneItemTabs.text = string.format(ZhString.AdventurePanel_Row, self.realData.staticData.Name)
  TableUtility.ArrayClear(listPopUpItems)
  local bag = AdventureDataProxy.Instance.bagMap[self.realData.staticData.id]
  for k, v in pairs(self.realData.childs) do
    if not bag:IsEmpty(v.staticData.id) then
      table.insert(listPopUpItems, v.staticData)
    end
  end
  table.sort(listPopUpItems, function(l, r)
    return l.Order < r.Order
  end)
  if #listPopUpItems < 2 then
    self:Hide(self.itemTabs.gameObject)
    self:tabClick()
  else
    self:Show(self.itemTabs.gameObject)
    local tmpData = {
      id = AdventureItemNormalListPage.MaxCategory.id,
      Name = string.format(ZhString.AdventurePanel_AllTab, self.realData.staticData.Name)
    }
    local allRedTips = ReusableTable.CreateArray()
    local redTips
    for i = 1, #listPopUpItems do
      redTips = listPopUpItems[i].RidTip
      if redTips then
        for j = 1, #redTips do
          allRedTips[#allRedTips + 1] = redTips[j]
        end
      end
    end
    table.insert(listPopUpItems, 1, tmpData)
    self.itemTabs:SetData(listPopUpItems)
    self.itemTabs:RegisterTopRedTips(allRedTips, 35)
    ReusableTable.DestroyAndClearArray(allRedTips)
  end
end

function AdventureNpcListPage:tabClick(selectTabData, noResetPos)
  if self.tagItemList then
    self.tagItemList:removeTip()
  end
  self.selectTabData = selectTabData
  if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
    self.tagItemList:setCategoryAndTab(self.realData, selectTabData)
  else
    self.tagItemList:setCategoryAndTab(self.realData, nil)
  end
  self:UpdateList(noResetPos)
end

function AdventureNpcListPage:UpdateList(noResetPos)
  if not self.tagItemList then
    redlog("List Not Inited")
    return
  end
  self.tagItemList:UpdateList(noResetPos)
end

function AdventureNpcListPage:SelectCell(itemId)
  if self.tagItemList and self.tagItemList.SelectCell then
    self.tagItemList:SelectCell(itemId)
  end
end

function AdventureNpcListPage:JumpToFirstClickableItem(force)
  if self.tagItemList and self.tagItemList.JumpToFirstClickableItem then
    self.tagItemList:JumpToFirstClickableItem(force)
  end
end

function AdventureNpcListPage:FunGetNpcTagData(bag, tabData, tagData)
  return bag:GetItemsBySubID(tabData and tabData.id or nil, tagData.id)
end

function AdventureNpcListPage:FunGetPrestigeTagData(bag, tabData, tagData)
  if tagData.isMainTag then
    local mainTagDatas = bag:GetItemsBySubID(tabData and tabData.id or nil, tagData.id)
    tagData.maxPrestigeNum = #mainTagDatas
    local graduateNum = 0
    for i = 1, #mainTagDatas do
      if PrestigeProxy.Instance:IsPrestigeGraduate(mainTagDatas[i].staticId) then
        graduateNum = graduateNum + 1
      end
    end
    tagData.graduateNum = graduateNum
    return mainTagDatas, tagData.id == PrestigeProxy.PrestigeType.Camp
  end
  if not self.prestigeNpcDatas then
    self.prestigeNpcDatas = {}
  end
  TableUtility.ArrayClear(self.prestigeNpcDatas)
  local oganizationMembers = tagData.staticData.Member
  local memberData
  for i = 1, #oganizationMembers do
    memberData = Table_PrestigeNpc[oganizationMembers[i]]
    if memberData then
      memberData.hideLine = nil
      self.prestigeNpcDatas[#self.prestigeNpcDatas + 1] = memberData
    end
  end
  if 0 < #self.prestigeNpcDatas then
    self.prestigeNpcDatas[#self.prestigeNpcDatas].hideLine = true
  end
  return self.prestigeNpcDatas
end

function AdventureNpcListPage:FunGetPrestigeDefaultSelectItem()
  local cells = self.prestigeItemList.wraplist:GetCells()
  for i = 1, #cells do
    local v = cells[i]
    if v.canClick then
      if self.prestigeItemList.chooseItemData then
        if v.data and v.data.type == self.prestigeItemList.chooseItemData.type and v.data.staticId == self.prestigeItemList.chooseItemData.staticId then
          return v
        end
      else
        return v
      end
    end
  end
end

function AdventureNpcListPage:HandleManualUpdate(note)
  AdventureUtil:DelayCallback(note, function(data)
    self:DelayHandleManualUpdate(data)
  end)
end

function AdventureNpcListPage:DelayHandleManualUpdate(data)
  local result, adventureType = AdventureUtil:CheckManualUpdateData(data, "AdventureNpcListPage")
  if not result then
    return nil
  end
  local data = data
  local type = data.update.type
  if self.realData and self.gameObject.activeSelf and self.realData.staticData.id == type then
    if self.selectTabData and self.selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self.tagItemList:setCategoryAndTab(self.realData, self.selectTabData)
    else
      self.tagItemList:setCategoryAndTab(self.realData, nil)
    end
    self:UpdateList(true)
  end
end

function AdventureNpcListPage:updateCellTip(data)
  local cellCtl = data.ctrl
  local ret = data.ret
  if ret and cellCtl and cellCtl.data and cellCtl.data.staticData.RedTip then
    self:RegisterRedTipCheck(cellCtl.data.staticData.RedTip, cellCtl.bg, nil, {-15, -15})
  end
end

function AdventureNpcListPage:RefreshZoneTags(note)
  if not self.tagItemList then
    return
  end
  self.tagItemList:RefreshTags()
end

function AdventureNpcListPage:ClickZoneReward(cell)
  if not cell.isTag then
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AdventureZoneRewardPopUp,
    viewdata = cell.data
  })
end

function AdventureNpcListPage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureNpcListPage.super.OnEnter(self)
  self.npcItemList:OnEnter()
  self.prestigeItemList:OnEnter()
end

function AdventureNpcListPage:OnExit()
  if self.isInited then
    self.npcItemList:removeTip()
    self.prestigeItemList:removeTip()
  end
  AdventureNpcListPage.super.OnExit(self)
end

function AdventureNpcListPage:Show(obj)
  if not obj and not self.isInited then
    return
  end
  AdventureNpcListPage.super.Show(self, obj)
end

function AdventureNpcListPage:Hide(obj)
  if not obj then
    if not self.isInited then
      return
    end
    self.npcItemList:removeTip()
    self.prestigeItemList:removeTip()
  end
  AdventureNpcListPage.super.Hide(self, obj)
end

function AdventureNpcListPage:OnDestroy()
  if self.isInited then
    self.itemTabs:Destroy()
    self.npcItemList:OnExit()
    self.prestigeItemList:OnExit()
  end
  AdventureNpcListPage.super.OnDestroy(self)
end
