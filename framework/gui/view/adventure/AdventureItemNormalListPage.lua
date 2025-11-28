AdventureItemNormalListPage = class("AdventureItemNormalListPage", SubMediatorView)
autoImport("PopupGridList")
autoImport("AdventureNormalList")
autoImport("AdventureCombineItemCell")
autoImport("AdventureSceneList")
autoImport("AdventureUtil")
AdventureItemNormalListPage.MaxCategory = {
  id = 99999999,
  value = {}
}
AdventureItemNormalListPage.SceneryProp = {
  extraType = "locked",
  group = {},
  TypeLimit = 11
}

function AdventureItemNormalListPage:Init()
  self.isInited = false
end

function AdventureItemNormalListPage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureItemNormalListPage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:AddViewEvts()
  self:initView()
  self.cureTab = nil
  self.normalList:OnEnter()
  self.sceneList:OnEnter()
  self.isInited = true
  self:OnEnter()
end

function AdventureItemNormalListPage:initView()
  local listObj = self:FindGO("normalList")
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView, listObj)
  self.OneItemTabs = self:FindGO("OneItemTabs"):GetComponent(UILabel)
  self.PropTypeBtn = self:FindGO("PropTypeBtn")
  local propTypeName = self:FindComponent("Label", UILabel, self.PropTypeBtn)
  propTypeName.text = ZhString.AdventureFoodPage_FilterDesc
  local selectbg = self:FindComponent("PropTypeBtnSelectBg", UISprite, self.PropTypeBtn)
  self:AddClickEvent(self.PropTypeBtn, function()
    local tipData = {
      callback = self.filterPropCallback,
      param = self,
      type = self.data and self.data.staticData.id,
      tabID = self.selectTabData and self.selectTabData.id,
      curPropData = self.itemlist.propData,
      curKeys = self.itemlist.keys
    }
    TipManager.Instance:ShowPropTypeTip(tipData, selectbg, NGUIUtil.AnchorSide.AnchorSide, {-90, -50})
  end)
  local tipHolder = self:FindGO("tipHolder", listObj)
  self.normalList = AdventureNormalList.new(listObj, tipHolder, AdventureCombineItemCell)
  self.normalList:AddEventListener(AdventureNormalList.UpdateCellRedTip, self.updateCellTip, self)
  listObj = self:FindGO("sceneryList")
  self.sceneList = AdventureSceneList.new(listObj)
  self.sceneList:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self)
  self.itemlist = self.normalList
  self.FilterCondition = self:FindComponent("FilterCondition", UIToggle)
  self.FilterConditionLabel = self:FindComponent("Label", UILabel, self.FilterCondition.gameObject)
  self.FilterConditionLabel.text = ZhString.AdventurePanel_FilterOnlyLocked
  self:AddClickEvent(self.FilterCondition.gameObject, function(obj)
    self.professionSelected = self.FilterCondition.value
    self.itemlist:SetPropData(self.professionSelected and AdventureItemNormalListPage.SceneryProp or nil)
    self:tabClick(self.selectTabData)
  end)
end

function AdventureItemNormalListPage:filterPropCallback(propData, keys)
  self.itemlist:SetPropData(propData, keys)
  self:UpdateList()
end

local redTipOffset = {-15, -15}

function AdventureItemNormalListPage:updateCellTip(data)
  local cellCtl = data.ctrl
  local ret = data.ret
  if ret and cellCtl and cellCtl.data and cellCtl.data.staticData.RedTip then
    self:RegisterRedTipCheck(cellCtl.data.staticData.RedTip, cellCtl.bg, nil, redTipOffset)
  else
    self:UnRegisterRedTipChecksByWidget(cellCtl.bg)
  end
end

function AdventureItemNormalListPage:tabClick(selectTabData, noResetPos)
  if self.itemlist then
    self.itemlist:removeTip()
    if self.itemlist.resetSelectState then
      self.itemlist:resetSelectState()
    end
  end
  self.selectTabData = selectTabData
  if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
    self.itemlist:setCategoryAndTab(self.data, selectTabData)
  else
    self.itemlist:setCategoryAndTab(self.data, nil)
  end
  self:UpdateList(noResetPos)
end

function AdventureItemNormalListPage:JumpToFirstClickableItem(force)
  if self.itemlist and self.itemlist.JumpToFirstClickableItem then
    self.itemlist:JumpToFirstClickableItem(force)
  end
end

function AdventureItemNormalListPage:setCurTabNameAndScore(data)
  local bagData = AdventureDataProxy.Instance.bagMap[self.data.id]
  local total, curScore
  if data.id then
    local tab = bagData:GetTab(data.id)
    total = tab.totalCount
    curScore = tab.curUnlockCount
    if data.icon == "" then
    end
  else
    total = bagData.totalCount
    curScore = bagData.curUnlockCount
  end
end

function AdventureItemNormalListPage:setCategoryData(data)
  xdlog("setCategoryData")
  self:InitPage()
  self.data = data
  local list = {}
  if self.itemlist then
    self.itemlist:SetPropData(nil, nil)
  end
  local itemTabGO = self:FindGO("ItemTabs", self.gameObject)
  itemTabGO:SetActive(false)
  local longItemTabGO = self:FindGO("LongItemTabs", self.gameObject)
  longItemTabGO:SetActive(false)
  if data and data.childs then
    if self.itemlist then
      self.itemlist:removeTip()
    end
    local targetItemTabGO
    if self.data and self.data.staticData.id == SceneManual_pb.EMANUALTYPE_SCENERY then
      self.sceneList:Show()
      self.normalList:Hide()
      self.itemlist = self.sceneList
      targetItemTabGO = longItemTabGO
      self.FilterCondition.gameObject:SetActive(true)
    else
      self.sceneList:Hide()
      self.normalList:Show()
      self.itemlist = self.normalList
      targetItemTabGO = itemTabGO
      self.FilterCondition.gameObject:SetActive(false)
    end
    if self.data and (self.data.staticData.id == SceneManual_pb.EMANUALTYPE_FASHION or self.data.staticData.id == SceneManual_pb.EMANUALTYPE_CARD or self.data.staticData.id == SceneManual_pb.EMANUALTYPE_COLLECTION or self.data.staticData.id == SceneManual_pb.EMANUALTYPE_FURNITURE) then
      self:Show(self.PropTypeBtn)
    else
      self:Hide(self.PropTypeBtn)
    end
    targetItemTabGO:SetActive(true)
    xdlog("SetActive", targetItemTabGO.name)
    self.itemTabs = PopupGridList.new(targetItemTabGO, function(self, data)
      if self.selectTabData ~= data then
        xdlog("PopupGridList:Func", self.selectTabData and self.selectTabData.id, data and data.id)
        self.selectTabData = data
        self:tabClick(self.selectTabData)
      end
    end, self, self.scrollView:GetComponent(UIPanel).depth + 2)
    self:UpdateItemTabs()
  end
end

function AdventureItemNormalListPage:UpdateItemTabs(doNotCallback, doNotClick)
  local list = {}
  local bag = AdventureDataProxy.Instance.bagMap[self.data.staticData.id]
  for k, v in pairs(self.data.childs) do
    local inValid = false
    if self.data.staticData.id == SceneManual_pb.EMANUALTYPE_SCENERY then
      inValid = not bag or bag:IsEmpty(v.staticData.id)
    end
    if not inValid then
      local items = bag:GetItems(v.staticData.id)
      local count = 0
      for i = 1, #items do
        if items[i].status == SceneManual_pb.EMANUALSTATUS_UNLOCK then
          count = count + 1
        end
      end
      local data = {}
      TableUtil.deepcopy(data, v.staticData)
      if self.data.staticData.id == SceneManual_pb.EMANUALTYPE_SCENERY then
        data.subText = string.format("(%s/%s)", count, #items)
      end
      table.insert(list, data)
    end
  end
  table.sort(list, function(l, r)
    return l.Order < r.Order
  end)
  local allRedTips = ReusableTable.CreateArray()
  if #list < 2 then
    list = {}
    self:Hide(self.itemTabs.gameObject)
    self.OneItemTabs.text = string.format(ZhString.AdventurePanel_Row, self.data.staticData.Name)
    self:Show(self.OneItemTabs.gameObject)
    self:tabClick()
  else
    self:Hide(self.OneItemTabs)
    self:Show(self.itemTabs.gameObject)
    local tmpData = {
      id = AdventureItemNormalListPage.MaxCategory.id,
      Name = string.format(ZhString.AdventurePanel_AllTab, self.data.staticData.Name)
    }
    if self.data.staticData.id == SceneManual_pb.EMANUALTYPE_SCENERY then
      tmpData.subText = string.format("(%s/%s)", bag:GetUnlockNum(), bag:GetValidItemNum())
    end
    local redTips
    for i = 1, #list do
      redTips = list[i].RidTip
      if redTips then
        for j = 1, #redTips do
          allRedTips[#allRedTips + 1] = redTips[j]
        end
      end
    end
    table.insert(list, 1, tmpData)
  end
  xdlog("重新刷新ItemTabs", doNotCallback)
  self.itemTabs:SetData(list, doNotCallback, doNotClick)
  self.itemTabs:RegisterTopRedTips(allRedTips, 35)
  ReusableTable.DestroyAndClearArray(allRedTips)
end

function AdventureItemNormalListPage:UpdateList(noResetPos)
  self.itemlist:UpdateList(noResetPos)
end

function AdventureItemNormalListPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.HandleManualUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadProgressCallback, self.SceneryThumbnailPhDlPgCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadCompleteCallback, self.SceneryThumbnailPhDlCpCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryThumbnailDownloadErrorCallback, self.SceneryThumbnailPhDlErCallback)
  self:AddListenEvt(ServiceEvent.SceneManualCollectionRewardManualCmd, self.HandleCollectManualUpdate)
end

function AdventureItemNormalListPage:SceneryThumbnailPhDlPgCallback(note)
  local data = note.body
  local cell = self:getCellBySceneryId(data.index)
  MySceneryPictureManager.Instance():log("SceneryThumbnailPhDlPgCallback:", data.index, data.progress)
  if cell and cell.data.roleId == data.roleId then
    cell:setDownloadProgress(data.progress)
  end
end

function AdventureItemNormalListPage:SceneryThumbnailPhDlCpCallback(note)
  local data = note.body
  local cell = self:getCellBySceneryId(data.index)
  if cell and cell.data.roleId == data.roleId then
    self:GetPersonPicThumbnail(cell)
  end
end

function AdventureItemNormalListPage:GetPersonPicThumbnail(cellCtl)
  MySceneryPictureManager.Instance():log("GetPersonPicThumbnail")
  if cellCtl and cellCtl.data then
    MySceneryPictureManager.Instance():GetAdventureSceneryPicThumbnail(cellCtl)
  end
end

function AdventureItemNormalListPage:SceneryThumbnailPhDlErCallback(note)
  local data = note.body
  local cell = self:getCellBySceneryId(data.index)
  if cell and cell.data.roleId == data.roleId then
    cell:setDownloadFailure()
  end
end

function AdventureItemNormalListPage:getCellBySceneryId(sceneryId)
  local cells = self.sceneList:GetItemCells()
  for i = 1, #cells do
    local single = cells[i]
    if single.data and single.data.staticId == sceneryId then
      return single
    end
  end
end

function AdventureItemNormalListPage:HandleItemUpdate(note)
  if self.data and self.gameObject.activeSelf then
    self.dirtyItemUpdate = true
    if self.isAddMonoUpdateFunction == nil then
      Game.GUISystemManager:AddMonoUpdateFunction(self.Update, self)
      self.isAddMonoUpdateFunction = true
    end
  end
end

function AdventureItemNormalListPage:HandleManualUpdate(note)
  AdventureUtil:DelayCallback(note, function(data)
    self:DelayHandleManualUpdate(data)
  end)
end

function AdventureItemNormalListPage:DelayHandleManualUpdate(data)
  local result, adventureType = AdventureUtil:CheckManualUpdateData(data, "AdventureItemNormalListPage")
  if not result then
    return nil
  end
  local selectTabData = self.selectTabData
  local data = data
  local type = data.update.type
  if self.data and self.gameObject.activeSelf then
    local weaponConfig = GameConfig.AdventureWeaponConfig
    for id, config in pairs(weaponConfig) do
      if self.data.staticData.id == type or self.data.staticData.id == config.type and config.equiptype == type then
        if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
          self.itemlist:setCategoryAndTab(self.data, selectTabData)
        else
          self.itemlist:setCategoryAndTab(self.data, nil)
        end
        self:UpdateList(true)
      end
    end
    local hairStyleConfig = GameConfig.AdventureHairStyleConfig
    for id, config in pairs(hairStyleConfig) do
      if self.data.staticData.id == type or self.data.staticData.id == config.type and config.equiptype == type then
        if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
          self.itemlist:setCategoryAndTab(self.data, selectTabData)
        else
          self.itemlist:setCategoryAndTab(self.data, nil)
        end
        self:UpdateList(true)
      end
    end
    if self.data.staticData.id == SceneManual_pb.EMANUALTYPE_SCENERY then
      self:UpdateItemTabs(true, true)
    end
  end
end

function AdventureItemNormalListPage:HandleCollectManualUpdate()
  self:UpdateList(true)
end

function AdventureItemNormalListPage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureItemNormalListPage.super.OnEnter(self)
end

function AdventureItemNormalListPage:ShowSelf()
  self:InitPage()
  self:Show()
end

function AdventureItemNormalListPage:OnExit()
  if self.isInited then
    self.normalList:removeTip()
    self.FilterCondition.value = false
  end
  if self.isAddMonoUpdateFunction then
    Game.GUISystemManager:ClearMonoUpdateFunction(self)
    self.isAddMonoUpdateFunction = nil
  end
  AdventureItemNormalListPage.super.OnExit(self)
end

function AdventureItemNormalListPage:OnDestroy()
  if self.isInited then
    self.sceneList:OnExit()
    self.normalList:OnExit()
    self.itemTabs:Destroy()
    self.itemTabs = nil
  end
  AdventureItemNormalListPage.super.OnDestroy(self)
end

function AdventureItemNormalListPage:Show(target)
  if not target then
    if not self.isInited then
      return
    end
    if self.itemTabs then
      self.itemTabs:Destroy()
      self.itemTabs = nil
    end
  end
  AdventureItemNormalListPage.super.Show(self, target)
end

function AdventureItemNormalListPage:Hide(target)
  if not target then
    if not self.isInited then
      return
    end
    if self.data then
      self.normalList:resetSelectState()
    end
    self.normalList:removeTip()
    self.FilterCondition.value = false
  end
  AdventureItemNormalListPage.super.Hide(self, target)
end

function AdventureItemNormalListPage:Update()
  if self.dirtyItemUpdate then
    self.itemlist:ItemUpdate()
    self.dirtyItemUpdate = nil
  end
end
