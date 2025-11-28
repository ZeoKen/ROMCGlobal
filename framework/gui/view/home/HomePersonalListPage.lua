autoImport("PersonalListPage")
autoImport("HomePersonalPictureCombineItemCell")
HomePersonalListPage = class("HomePersonalListPage", PersonalListPage)

function HomePersonalListPage:initData()
  self.SortLabel = {
    {
      id = 1,
      Name = ZhString.PersonalPictureCell_AscentSort
    },
    {
      id = 2,
      Name = ZhString.PersonalPictureCell_DescentSort
    },
    {
      id = 3,
      Name = ZhString.PersonalPictureCell_CurrentShow
    }
  }
  self:initCategoryData()
  local datas = PhotoDataProxy.Instance:getAllPhotoes()
  PersonalPictureManager.Instance():AddMyThumbnailInfos(datas)
  self:UpdateList()
end

function HomePersonalListPage:initView()
  self.gameObject = self:FindGO("PersonalListPage")
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
  self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  EventDelegate.Add(self.itemTabs.onChange, function()
    if self.selectTabData ~= self.itemTabs.data then
      self.selectTabData = self.itemTabs.data
      self:tabClick()
    end
  end)
end

function HomePersonalListPage:CheckCurPicIsShow(cellCtl)
  if cellCtl and cellCtl.data then
    self.container:CheckCurPicIsShow(cellCtl)
  end
end

function HomePersonalListPage:CellSelectedChange(cellCtl)
  if cellCtl and cellCtl.data then
    local isselect = cellCtl:IsSelected()
    if isselect then
      self.container:RemovePhotoData(cellCtl)
    else
      self.container:AddPhotoData(cellCtl)
    end
  end
end

function HomePersonalListPage:RefreshUIByMode()
end

function HomePersonalListPage:HandleClickItem(cellCtl)
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

function HomePersonalListPage:CheckDirection(anglez, frameDir)
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

function HomePersonalListPage:UpdateList(noResetPos)
  local allDatas = PhotoDataProxy.Instance:getAllPhotoes()
  local datas = {}
  local frameData = self.container.frameId and Table_ScenePhotoFrame[self.container.frameId]
  local dir = 0
  if frameData then
    dir = frameData.Dir
  end
  for i = 1, #allDatas do
    local single = allDatas[i]
    local anglez = single.anglez
    if self:CheckDirection(anglez, dir) and single.isupload then
      datas[#datas + 1] = single
    end
  end
  local sortMode = 1
  if self.selectTabData then
    sortMode = self.selectTabData.id
  end
  if sortMode == 3 then
    local list = {}
    for i = 1, #datas do
      local single = datas[i]
      if PhotoDataProxy.Instance:checkPhotoFrame(single) then
        list[#list + 1] = single
      end
    end
    datas = list
  end
  if not datas or #datas == 0 then
    self:Show(self.emptyCt)
  else
    self:Hide(self.emptyCt)
  end
  table.sort(datas, function(l, r)
    if sortMode == 2 then
      return l.time < r.time
    else
      return l.time > r.time
    end
  end)
  self:SetData(datas, noResetPos)
  self:RefreshUIByMode()
end

function HomePersonalListPage:SetData(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 1)
  self.wraplist:UpdateInfo(newdata)
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end

function HomePersonalListPage:initCategoryData()
  local list = {}
  for i = 1, #self.SortLabel do
    local single = self.SortLabel[i]
    table.insert(list, single)
  end
  self:Show(self.itemTabs.gameObject)
  self.itemTabs:Clear()
  for i = 1, #list do
    local single = list[i]
    if single.id then
      self.itemTabs:AddItem(single.Name, single)
    end
  end
  if 1 < #list then
    self.itemTabs.value = list[1].Name
  end
end

function HomePersonalListPage:checkSelect()
  if self.itemTabs.isOpen then
    self:Show(self.ItemTabsBgSelect)
  else
    self:Hide(self.ItemTabsBgSelect)
  end
end

function HomePersonalListPage:OnEnter()
  HomePersonalListPage.super.OnEnter(self)
  TimeTickManager.Me():CreateTick(0, 100, self.checkSelect, self, PersonalListPage.ClickId.CheckSelect)
end

function HomePersonalListPage:DestroyItemTabs()
  self.itemTabs = nil
end

function HomePersonalListPage:OnExit()
  HomePersonalListPage.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
