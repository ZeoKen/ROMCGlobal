HomeWallPicManager = class("HomeWallPicManager")
autoImport("UnionWallPhotoNew")
autoImport("UnionWallPhotoHelper")

function HomeWallPicManager:Launch()
  if self.running then
    return
  end
  self.running = true
  if self.photoTexData then
    TableUtility.ArrayClear(self.photoTexData)
  end
  self.photoTexData = {}
  if self.toBeDownload then
    TableUtility.ArrayClear(self.toBeDownload)
  end
  self.toBeDownload = {}
  self.maxThumbnailSize = 100
  self.enableLog = false
  self.isDownloading = false
end

function HomeWallPicManager:log(...)
  if self.enableLog then
    helplog(...)
  end
end

function HomeWallPicManager:deleteTextureByPhotoData(photoData)
  for i = 1, #self.photoTexData do
    local single = self.photoTexData[i]
    if self:checkSamePicture(single.photoData, photoData) then
      table.remove(self.photoTexData, i)
      Object.DestroyImmediate(single.texture)
      self:StopDownloadAndClean(photoData)
      break
    end
  end
end

function HomeWallPicManager:StopDownloadAndClean(photoData)
  if FunctionPhotoStorage.IsActive() then
    local uPhotoType = FunctionPhotoStorage.GetUnionWallType(photoData.source, photoData.isBelongAccPic)
    if uPhotoType then
      FunctionPhotoStorage.Me():RemoveUnionWallPhotoData(uPhotoType, photoData.charid, photoData.sourceid)
    end
    return
  end
  if photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
    UnionWallPhotoNew.Ins():Clear_Personal(photoData.charid, photoData.sourceid)
  elseif photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
    if photoData.isBelongAccPic then
      UnionWallPhotoNew.Ins():Clear_ScenicSpot_Account(photoData.charid, photoData.sourceid)
    else
      UnionWallPhotoNew.Ins():Clear_ScenicSpot(photoData.charid, photoData.sourceid)
    end
  end
end

function HomeWallPicManager:removeDownloadTexture(photoData)
  for j = 1, #self.toBeDownload do
    local data = self.toBeDownload[j]
    if self:checkSamePicture(photoData, data) then
      table.remove(self.toBeDownload, j)
      break
    end
  end
end

function HomeWallPicManager:checkSamePicture(existData, serverData)
  if existData and serverData then
    if existData.charid == serverData.charid and existData.sourceid == serverData.sourceid and existData.source == serverData.source and existData.time == serverData.time then
      return true
    end
  else
    self:log("checkSamePicture data is nil!!!!!!!!")
  end
end

function HomeWallPicManager:TryGetThumbnail(photo)
  local texture = self:getTextureByPhotoData(photo, true)
  if texture then
    return texture
  else
    local photoData = PhotoData.new(photo)
    local data = {photoData = photoData, texture = nil}
    self.photoTexData[#self.photoTexData + 1] = data
    local exsit = false
    for i = 1, #self.toBeDownload do
      local single = self.toBeDownload[i]
      if self:checkSamePicture(photoData, single) then
        exsit = true
        break
      end
    end
    if not exsit then
      self.toBeDownload[#self.toBeDownload + 1] = photoData
    end
  end
  self:startTryGenThumbnail()
end

function HomeWallPicManager:getServerData(photoData)
  for i = 1, #self.photoTexData do
    local single = self.photoTexData[i]
    if self:checkSamePicture(single.photoData, photoData) then
      return single, i
    end
  end
end

function HomeWallPicManager:getTextureByPhotoData(photoData, rePos)
  for i = 1, #self.photoTexData do
    local single = self.photoTexData[i]
    if single.texture and self:checkSamePicture(single.photoData, photoData) then
      if rePos then
        table.remove(self.photoTexData, i)
        table.insert(self.photoTexData, 1, single)
      end
      return single.texture
    end
  end
end

function HomeWallPicManager:HasInToBeDownload(photoData)
  for i = 1, #self.toBeDownload do
    local single = self.toBeDownload[i]
    if self:checkSamePicture(single, photoData) then
      return true
    end
  end
end

function HomeWallPicManager:addTextureByPhotoData(photoData, texture)
  if not self:getTextureByPhotoData(photoData) then
    if #self.photoTexData > self.maxThumbnailSize then
      local textureData = table.remove(self.photoTexData)
      Object.DestroyImmediate(textureData.texture)
    end
    local data, idx = self:getServerData(photoData)
    if data then
      data.texture = texture
      table.remove(self.photoTexData, idx)
    else
      data = {}
      data.photoData = photoData
      data.texture = texture
    end
    table.insert(self.photoTexData, 1, data)
  else
    self:log("addTextureByPhotoData:exsit ")
  end
end

function HomeWallPicManager:startTryGenThumbnail()
  if #self.toBeDownload > 0 and not self.isDownloading then
    local loadData = self.toBeDownload[1]
    self:tryGenThumbnail(loadData)
  end
end

function HomeWallPicManager:tryGenThumbnail(photoData)
  self:log("tryGenThumbnail", photoData.charid, photoData.sourceid, photoData.time)
  self.isDownloading = true
  if FunctionPhotoStorage.IsActive() then
    local uPhotoType = FunctionPhotoStorage.GetUnionWallType(photoData.source, photoData.isBelongAccPic)
    if uPhotoType then
      FunctionPhotoStorage.Me():GetUnionWallPhoto(uPhotoType, photoData.charid, photoData.sourceid, photoData.time, true, function(progress)
        self:thumbnailProgressCallback(photoData, progress)
      end, function(bytes, errorMessage)
        if bytes then
          self:thumbnailCompleteCallback(photoData, bytes)
        else
          self:thumbnailErrorCallback(photoData, errorMessage)
        end
      end)
    else
      self:log("unknown source")
    end
    return
  end
  if photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
    UnionWallPhotoHelper.Ins():GetThumbnail_Personal(photoData.charid, photoData.sourceid, photoData.time, function(progress)
      self:thumbnailProgressCallback(photoData, progress)
    end, function(bytes)
      self:thumbnailCompleteCallback(photoData, bytes)
    end, function(errorMessage)
      self:thumbnailErrorCallback(photoData, errorMessage)
    end)
  elseif photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
    if photoData.isBelongAccPic then
      UnionWallPhotoHelper.Ins():GetThumbnail_ScenicSpot_Account(photoData.charid, photoData.sourceid, photoData.time, function(progress)
        self:thumbnailProgressCallback(photoData, progress)
      end, function(bytes)
        self:thumbnailCompleteCallback(photoData, bytes)
      end, function(errorMessage)
        self:thumbnailErrorCallback(photoData, errorMessage)
      end)
    else
      UnionWallPhotoHelper.Ins():GetThumbnail_ScenicSpot(photoData.charid, photoData.sourceid, photoData.time, function(progress)
        self:thumbnailProgressCallback(photoData, progress)
      end, function(bytes)
        self:thumbnailCompleteCallback(photoData, bytes)
      end, function(errorMessage)
        self:thumbnailErrorCallback(photoData, errorMessage)
      end)
    end
  else
    self:log("unknown source")
  end
end

function HomeWallPicManager:thumbnailProgressCallback(photoData, progress)
  self:log("thumbnailProgressCallback", charId, sceneryId, progress)
  self:WallPicThumbnailDownloadProgressCallback1(photoData, progress)
end

function HomeWallPicManager:thumbnailErrorCallback(photoData, errorMessage)
  self.isDownloading = false
  self:removeDownloadTexture(photoData)
  self:log("thumbnailErrorCallback", photoData.charid, errorMessage)
  self:WallPicThumbnailDownloadErrorCallback1(photoData, errorMessage)
  self:startTryGenThumbnail()
end

function HomeWallPicManager:thumbnailCompleteCallback(photoData, bytes)
  self.isDownloading = false
  local texture = Texture2D(200, 100, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:addTextureByPhotoData(photoData, texture)
    self:WallPicThumbnailDownloadCompleteCallback1(photoData, texture)
    self:removeDownloadTexture(photoData)
    self:startTryGenThumbnail()
  else
    self:thumbnailErrorCallback(photoData, "load LoadImage error!")
    Object.DestroyImmediate(texture)
  end
end

function HomeWallPicManager:Shutdown()
  GameFacade.Instance:sendNotification(PictureWallDataEvent.MapEnd)
  if not self.running then
    return
  end
  self.running = false
  self:_DestroyDatas()
end

function HomeWallPicManager:_DestroyDatas()
  for i = 1, #self.photoTexData do
    local single = self.photoTexData[i]
    if single and single.texture then
      Object.DestroyImmediate(single.texture)
    end
  end
  TableUtility.ArrayClear(self.photoTexData)
  TableUtility.ArrayClear(self.toBeDownload)
  PhotoDataProxy.Instance:clearToSeeDatas()
  PhotoDataProxy.Instance:clearSelectedData()
  PhotoDataProxy.Instance:clearRemoveData()
  PhotoDataProxy.Instance:clearUpPhotos()
  PhotoDataProxy.Instance:clearCurFrameList()
end

HomeWallPicManager.WallPicThumbnailDownloadProgressCallback = "HomeWallPicManager_WallPicThumbnailDownloadProgressCallback"
HomeWallPicManager.WallPicThumbnailDownloadCompleteCallback = "HomeWallPicManager_WallPicThumbnailDownloadCompleteCallback"
HomeWallPicManager.WallPicThumbnailDownloadErrorCallback = "HomeWallPicManager_WallPicThumbnailDownloadErrorCallback"

function HomeWallPicManager:WallPicThumbnailDownloadProgressCallback1(photoData, progress)
  self:log("WallPicThumbnailDownloadProgressCallback", index, time, progress)
  EventManager.Me():DispatchEvent(HomeWallPicManager.WallPicThumbnailDownloadProgressCallback, {photoData = photoData, progress = progress})
end

function HomeWallPicManager:WallPicThumbnailDownloadCompleteCallback1(photoData, texture)
  self:log("WallPicThumbnailDownloadCompleteCallback", index, time, tostring(texture))
  EventManager.Me():DispatchEvent(HomeWallPicManager.WallPicThumbnailDownloadCompleteCallback, {photoData = photoData, texture = texture})
end

function HomeWallPicManager:WallPicThumbnailDownloadErrorCallback1(photoData, errorMessage)
  self:log("WallPicThumbnailDownloadErrorCallback", index, time, errorMessage)
  EventManager.Me():DispatchEvent(HomeWallPicManager.WallPicThumbnailDownloadErrorCallback, {photoData = photoData, errorMessage = errorMessage})
end
