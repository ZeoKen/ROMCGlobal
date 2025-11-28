autoImport("PersonalPicturePanel")
HomePersonalPicturePanel = class("HomePersonalPicturePanel", PersonalPicturePanel)
autoImport("HomePersonalListPage")
autoImport("HomeSceneryListPage")
autoImport("HomePersonalPictureWallCell")
HomePersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
HomePersonalPicturePanel.GetPhoto = "HomePersonalPicturePanel_GetPhoto"

function HomePersonalPicturePanel:Init()
  self:initData()
  self:initView()
  self:AddEvents()
  self:refreshCurState()
end

function HomePersonalPicturePanel:AddEvents()
  self:AddListenEvt(PictureWallDataEvent.MapEnd, self.MapEnd)
  self:AddListenEvt(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd, self.UpdateList)
  self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoDownloadProgressCallback, self.photoProgressCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback, self.photoProgressCallback)
  self:AddListenEvt(HomePersonalPicturePanel.GetPhoto, self.getPhoto)
  self:AddListenEvt(ServiceEvent.HomeCmdFurnitureDataUpdateHomeCmd, self.UpdateList)
end

function HomePersonalPicturePanel:MapEnd()
  self:CloseSelf()
end

function HomePersonalPicturePanel:UpdateList()
  self:refreshCurFurniture()
  self.PersonalListPage:UpdateList(true)
  self.SceneryListPage:UpdateList(true)
  self:refreshCurState()
end

function HomePersonalPicturePanel:OnEnter()
  HomePersonalPicturePanel.super.super.OnEnter(self)
  self:getFurniturePhoto()
end

function HomePersonalPicturePanel:OnExit()
  PhotoDataProxy.Instance:clearSelectedData()
  PhotoDataProxy.Instance:clearRemoveData()
  Object.DestroyImmediate(self.photo.mainTexture)
  HomePersonalPicturePanel.super.super.OnExit(self)
end

function HomePersonalPicturePanel:initData()
  ServicePhotoCmdProxy.Instance:CallQueryUserPhotoListPhotoCmd()
  self.totalSize = PhotoDataProxy.Instance:getUploadedPhotoSize()
  if self.viewdata.viewdata then
    self.furniture = self.viewdata.viewdata
  end
end

function HomePersonalPicturePanel:initView()
  self:AddTabChangeEvent(self:FindGO("PersonalTab"), self:FindGO("PersonalListPage"), PersonalPicturePanel.Album.PersonalAlbum)
  self:AddTabChangeEvent(self:FindGO("SceneryTab"), self:FindGO("SceneryListPage"), PersonalPicturePanel.Album.SceneryAlbum)
  self.PersonalListPage = self:AddSubView("PersonalListPage", HomePersonalListPage)
  self.SceneryListPage = self:AddSubView("SceneryListPage", HomeSceneryListPage)
  self.albumState = self:FindComponent("bottomLabel", UILabel)
  self.albumState.text = ZhString.PersonalPicturePanel_AlbumStateFull
  self.progress = self:FindComponent("loadProgress", UILabel)
  self.photo = self:FindComponent("centerzhaopian", UITexture)
  self.PersonalTabLabel = self:FindComponent("PersonalTabLabel", UILabel)
  self.SceneryTabLabel = self:FindComponent("SceneryTabLabel", UILabel)
  self:TabChangeHandler(PersonalPicturePanel.Album.PersonalAlbum)
end

function HomePersonalPicturePanel:RemovePhotoData(cell)
  PhotoDataProxy.Instance:RemovePhotoData(cell)
  self:refreshCurState()
end

function HomePersonalPicturePanel:AddPhotoData(cell)
  PhotoDataProxy.Instance:AddPhotoData(cell)
  self:refreshCurState()
end

function HomePersonalPicturePanel:refreshCurFurniture()
  if self.furniture then
    local nFurnitureData = HomeProxy.Instance:FindFurnitureData(self.furniture.id)
    self.furniture.photo = nFurnitureData.photo
  end
end

function HomePersonalPicturePanel:refreshCurState()
end

function HomePersonalPicturePanel:CheckCurPicIsShow(cellCtl)
  local data = cellCtl.data
  local index = self.furniture and self.furniture.photo and self.furniture.photo.sourceid
  local source = self.furniture and self.furniture.photo and self.furniture.photo.source
  if data.source == source and data.index == index then
    cellCtl:setShowTipDes(true, true)
  else
    cellCtl:setShowTipDes(false)
  end
end

function HomePersonalPicturePanel:handleCategorySelect(key)
  if key == PersonalPicturePanel.Album.PersonalAlbum then
    local size = PhotoDataProxy.Instance:getUploadedSizeByAlbum(ProtoCommon_pb.ESOURCE_PHOTO_SELF)
    self.albumState.text = string.format(ZhString.PersonalPictureCell_CurAlbumState, size)
  elseif key == PersonalPicturePanel.Album.SceneryAlbum then
    local size = PhotoDataProxy.Instance:getUploadedSizeByAlbum(ProtoCommon_pb.ESOURCE_PHOTO_SCENERY)
    self.albumState.text = string.format(ZhString.PersonalPictureCell_CurAlbumState, size)
    if self.SceneryListPage then
      self.SceneryListPage:ResetPosition()
    end
  end
end

function HomePersonalPicturePanel:getFurniturePhoto()
  if not self.furniture or not self.furniture.photo then
    return
  end
  local index = self.furniture.photo.sourceid
  local source = self.furniture.photo.source
  if source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
    self.PhotoData = PhotoDataProxy.Instance:getPhotoDataByIndex(index)
  elseif ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
    self.PhotoData = nil
    local bag = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_SCENERY]
    if bag then
      local items = bag:GetItems()
      for i = 1, #items do
        local single = items[i]
        if single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK and single.staticId == index then
          self.PhotoData = PhotoData.new(single, PhotoDataProxy.PhotoType.SceneryPhotoType)
          break
        end
      end
    end
  end
  self:getOriginPhoto()
end

function HomePersonalPicturePanel:getOriginPhoto()
  if not self.PhotoData then
    self:setTexture()
    return
  end
  if self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType then
    local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Share(self.PhotoData.index, self.PhotoData.time)
    if tBytes then
      self:completeCallback(tBytes, true)
    end
    MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(self.PhotoData.roleId, self.PhotoData.index, self.PhotoData.time)
  else
    local tBytes = PersonalPhoto.Ins():TryGetThumbnailFromLocal(self.PhotoData.index, self.PhotoData.time, true)
    if tBytes then
      self:completeCallback(tBytes, true)
    end
    PersonalPictureManager.Instance():tryGetOriginImage(self.PhotoData.index, self.PhotoData.time)
  end
end

function HomePersonalPicturePanel:getPhoto(note)
  if self.PhotoData and self.PhotoData.index == note.body.PhotoData.index and self.PhotoData.source == note.body.PhotoData.source then
    self.PhotoData = nil
  else
    self.PhotoData = note.body.PhotoData
  end
  self:getOriginPhoto()
  local index = self.PhotoData and self.PhotoData.index or 0
  local source = self.PhotoData and self.PhotoData.source or 0
  self:CallSetPhotoAlbum(index, source)
end

function HomePersonalPicturePanel:CallSetPhotoAlbum(index, source)
  if not self.furniture then
    return
  end
  if false then
    self:ClientTestSetPhotoAlbum(index, source)
    return
  else
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Photo, self.furniture.id, index, source)
  end
end

function HomePersonalPicturePanel:ClientTestSetPhotoAlbum(index, source)
  local nFurniture = HomeManager.Me():FindFurniture(self.furniture.id)
  local photoData = {index = index, source = source}
  local data = {photo = photoData}
  local nFurnitureData = HomeProxy.Instance:FindFurnitureData(self.furniture.id)
  nFurnitureData:TryUpdatePhoto(photoData)
  HomeProxy.Instance:_HandlePhotoDataUpdate(data, nFurniture)
  self:UpdateList()
  return
end

function HomePersonalPicturePanel:setTexture(texture)
  Object.DestroyImmediate(self.photo.mainTexture)
  self.photo.gameObject:SetActive(texture ~= nil)
  self.photo.mainTexture = texture
end

function HomePersonalPicturePanel:progressCallback(progress)
  self:Show(self.progress.gameObject)
  progress = 1 <= progress and 1 or progress
  local value = progress * 100
  value = math.floor(value)
  self.progress.text = value .. "%"
end

function HomePersonalPicturePanel:completeCallback(bytes, thumbnail)
  if not thumbnail then
    self:Hide(self.progress.gameObject)
  end
  self.isThumbnail = thumbnail
  if bytes then
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      self.canbeShare = not thumbnail
      self:setTexture(texture)
    else
      Object.DestroyImmediate(texture)
    end
  end
end

function HomePersonalPicturePanel:photoCompleteCallback(note)
  local data = note.body
  if data and self.PhotoData and self.PhotoData.index == data.index then
    self:completeCallback(data.byte)
  end
end

function HomePersonalPicturePanel:photoProgressCallback(note)
  local data = note.body
  if data and self.PhotoData and self.PhotoData.index == data.index then
    self:progressCallback(data.progress)
  end
end
