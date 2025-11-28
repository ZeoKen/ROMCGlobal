autoImport("SceneryListPage")
autoImport("HomePersonalPictureCombineItemCell")
autoImport("HomePersonalPictureItemDropCell")
HomeSceneryListPage = class("HomeSceneryListPage", SceneryListPage)

function HomeSceneryListPage:initData()
  self:initCategoryData()
  self:UpdateList()
  local datas = self:getDatas()
  MySceneryPictureManager.Instance():AddMySceneryThumbnailInfos(datas)
end

function HomeSceneryListPage:initView()
  self.gameObject = self:FindGO("SceneryListPage")
  local itemContainer = self:FindGO("bag_itemContainer")
  local pfbNum = 7
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = pfbNum,
    cellName = "PersonalPicturCombineItemCell",
    control = HomePersonalPictureCombineItemCell,
    dir = 2
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.wraplist:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self)
  self.wraplist:AddEventListener(HomePersonalPicturePanel.CheckCurPicIsShow, self.CheckCurPicIsShow, self)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  
  self.emptyCt = self:FindGO("emptyCt")
  local emptyDes = self:FindComponent("emptyDes", UILabel)
  emptyDes.text = ZhString.PersonalPicturePanel_AlbumStateEmpty
  local emptySp = self:FindComponent("emptySp", UISprite)
  emptySp:UpdateAnchors()
  self.leftIndicator = self:FindGO("leftIndicator")
  self.rightIndicator = self:FindGO("rightIndicator")
  self:Hide(self.leftIndicator)
  self:Hide(self.rightIndicator)
  self.itemTabs = self:FindGO("ItemTabs")
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  self.itemTabsLabel = self:FindComponent("Label", UILabel, self.itemTabs)
  self:AddClickEvent(self.itemTabs, function()
    self:ShowItemTabDrop()
  end)
  self.itemDrop = self:FindGO("ItemDrop")
  self.itemDropBgSprite = self.itemDrop:GetComponent(UISprite)
  self.itemDropClose = self:FindComponent("ItemDrop", CloseWhenClickOtherPlace)
  self.itemDropScrollView = self:FindComponent("ScrollView", UIScrollView)
  self.itemDropPanel = self:FindComponent("ScrollView", UIPanel)
  self.itemDropGrid = self:FindComponent("DropListTable", UIGrid)
  self.itemDropList = UIGridListCtrl.new(self.itemDropGrid, HomePersonalPictureItemDropCell, "HomePersonalPictureItemDropCell")
  self.itemDropBar = self:FindComponent("veticalBar", UISprite, self.itemDrop)
  
  function self.itemDropClose.callBack(go)
    self:HideItemTabDrop()
  end
  
  self.itemDropList:AddEventListener(MouseEvent.MouseClick, self.DropItemClick, self)
  self.ItemTabsBgSelect.gameObject:SetActive(false)
end

function HomeSceneryListPage:ShowItemTabDrop()
  self.itemDrop:SetActive(true)
  self.itemDropList:ResetDatas(self.itemDropDataList)
  local heightCount = #self.itemDropDataList > 6 and 6 or #self.itemDropDataList
  local gridHeight = self.itemDropGrid.cellHeight * heightCount
  self.itemDropBgSprite.height = gridHeight + 48
  self.itemDropBar.height = gridHeight + 40
  self.itemDropPanel:SetRect(self.itemDropPanel.baseClipRegion.x, self.itemDropPanel.baseClipRegion.y, self.itemDropPanel.baseClipRegion.z, gridHeight + 8)
  self.itemDrop.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(273, 60 + gridHeight / 2, 0)
  self.itemDropList:Layout()
  self.itemDropScrollView:ResetPosition()
  self.ItemTabsBgSelect.gameObject:SetActive(true)
end

function HomeSceneryListPage:HideItemTabDrop()
  self.itemDrop:SetActive(false)
  self.ItemTabsBgSelect.gameObject:SetActive(false)
end

function HomeSceneryListPage:DropItemClick(cell)
  if self.selectTabData ~= cell.data then
    self.selectTabData = cell.data
    self:UpdateList()
    self.itemTabsLabel.text = self.selectTabData.Name
  end
  self:HideItemTabDrop()
end

function HomeSceneryListPage:initCategoryData()
  self.itemDropDataList = {}
  local data = AdventureDataProxy.Instance:getTabsByCategory(SceneManual_pb.EMANUALTYPE_SCENERY)
  for k, v in pairs(data.childs) do
    table.insert(self.itemDropDataList, v.staticData)
  end
  table.sort(self.itemDropDataList, function(l, r)
    return l.Order < r.Order
  end)
  local tmpData = {}
  tmpData.id = SceneryListPage.MaxCategory.id
  tmpData.Name = string.format(ZhString.AdventurePanel_AllTab, data.staticData.Name)
  table.insert(self.itemDropDataList, 1, tmpData)
  tmpData = {}
  tmpData.id = SceneryListPage.MaxCategory.id - 1
  tmpData.Name = ZhString.PersonalPictureCell_CurrentShow
  table.insert(self.itemDropDataList, tmpData)
end

function HomeSceneryListPage:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    MySceneryPictureManager.Instance():log("HandleClickItem")
    if cellCtl.status == PersonalPictureCell.PhotoStatus.Success then
      local viewdata = {
        PhotoData = cellCtl.data,
        from = self.container.from,
        frameId = self.container.frameId
      }
      GameFacade.Instance:sendNotification(HomePersonalPicturePanel.GetPhoto, viewdata)
    end
  end
end

function HomeSceneryListPage:CellSelectedChange(cellCtl)
  if cellCtl and cellCtl.data then
    local isselect = cellCtl:IsSelected()
    if isselect then
      self.container:RemovePhotoData(cellCtl)
    else
      self.container:AddPhotoData(cellCtl)
    end
  end
end

function HomeSceneryListPage:CheckDirection(anglez, frameDir)
  local dir = 0
  if 45 <= anglez and anglez <= 135 then
    dir = 1
  elseif 225 <= anglez and anglez <= 315 then
    dir = 1
  end
  if self.container.frameId == 0 then
    dir = frameDir
  end
  return dir == frameDir
end

function HomeSceneryListPage:UpdateList(noResetPos)
  local bag = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
  if bag then
    local allDatas = self:getDatas()
    local datas = {}
    local frameData = self.container.frameId and Table_ScenePhotoFrame[self.container.frameId]
    local dir = 0
    if frameData then
      dir = frameData.Dir
    end
    for i = 1, #allDatas do
      local single = allDatas[i]
      local anglez = single.anglez
      if self:CheckDirection(anglez, dir) then
        datas[#datas + 1] = single
      end
    end
    if not datas or #datas == 0 then
      self:Show(self.emptyCt)
    else
      self:Hide(self.emptyCt)
    end
    self:SetData(datas, noResetPos)
  end
end

function HomeSceneryListPage:CheckCurPicIsShow(cellCtl)
  if cellCtl and cellCtl.data then
    self.container:CheckCurPicIsShow(cellCtl)
  end
end

function HomeSceneryListPage:SetData(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 1)
  self.wraplist:UpdateInfo(newdata)
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end

function HomeSceneryListPage:DestroyItemTabs()
  self.itemTabs = nil
end
