local m_photoType = FunctionPhotoStorage.PhotoType.Personal

function FunctionPhotoStorage.GetPersonalPhotoID(photoIndex)
  if BranchMgr.IsChina() then
    return Game.Myself.data.id .. "_" .. photoIndex
  end
  return photoIndex
end

function FunctionPhotoStorage:RemovePersonalPhotoFromeAlbum(photoIndex, time)
  ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REMOVE, photoIndex)
end

function FunctionPhotoStorage:RemovePersonalPhotoData(photoIndex, time)
  self:CancelPhotoUpload(m_photoType, photoIndex)
  self:CancelPhotoDownload(m_photoType, photoIndex)
  self:DeleteLocalPhoto(m_photoType, FunctionPhotoStorage.GetPersonalPhotoID(photoIndex), photoIndex)
end

function FunctionPhotoStorage:GetPersonalPhotoPath(photoIndex, timestamp, extension, isThumb)
  local folderPath = isThumb and self.photoThumbPath[m_photoType] or self.photoPath[m_photoType]
  local photoID = FunctionPhotoStorage.GetPersonalPhotoID(photoIndex)
  if not timestamp or timestamp <= 0 then
    timestamp = FunctionPlayerPrefs.Me():GetInt(self:GetPhotoKey(m_photoType, photoIndex), 0)
  end
  return string.format("%s/%s/%s%s%s.%s", ApplicationHelper.persistentDataPath, folderPath, photoID, FunctionPhotoStorage.DivideCharacter, timestamp, extension)
end

function FunctionPhotoStorage:GetPersonalPhotoDownloadUrl(photoIndex, timestamp, extension, isThumb, notMine)
  local url = string.format("%s/%s%s/%s.%s", XDCDNInfo.GetFileServerURL(), self:GetPhotoUrlPath(m_photoType), notMine or Game.Myself.data.id, photoIndex, extension)
  if BranchMgr.IsChina() then
    if isThumb then
      url = url .. "!100"
    end
    return string.format("%s?t=%s", url, timestamp)
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    if isThumb then
      url = url .. "!33"
    end
    return string.format("%s?timestamp=%s", url, timestamp)
  end
  return url
end

function FunctionPhotoStorage:LoadPersonalPhotoFromLocal(photoIndex, timestamp, isThumb, funcOnFinish)
  local path = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local oldPath = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
  return self:LoadFromLocal(path, funcOnFinish) or self:LoadFromLocal(oldPath, funcOnFinish)
end

function FunctionPhotoStorage:GetPersonalPhoto(photoIndex, timestamp, isThumb, funcOnProgress, funcOnFinish)
  local path = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local downloadUrl = self:GetPersonalPhotoDownloadUrl(photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local oldPath = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
  local funcOnLocalLoadFinish = function(bytes)
    if funcOnFinish then
      funcOnFinish(bytes)
    end
    self:SendDownloadFinishMsg(m_photoType, photoIndex, timestamp, isThumb, bytes)
  end
  if self:LoadFromLocal(path, funcOnLocalLoadFinish) or self:LoadFromLocal(oldPath, funcOnLocalLoadFinish) then
    return
  end
  self:DownloadPhoto(m_photoType, photoIndex, timestamp, isThumb, downloadUrl, path, nil, funcOnProgress, function(bytes, errorMsg)
    if bytes then
      if funcOnFinish then
        funcOnFinish(bytes, errorMsg)
      end
    else
      local oldDownloadUrl = self:GetPersonalPhotoDownloadUrl(photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
      self:DownloadPhoto(m_photoType, photoIndex, timestamp, isThumb, oldDownloadUrl, oldPath, nil, funcOnProgress, function(bytes_old, errorMsg_old)
        if bytes_old or not isThumb then
          if funcOnFinish then
            funcOnFinish(bytes_old, errorMsg_old)
          end
          return
        end
        local originPath = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.Extension, false)
        local originOldPath = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.OldExtension, false)
        if not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originPath, 0.1, funcOnFinish) and not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originOldPath, 0.1, funcOnFinish) and funcOnFinish then
          funcOnFinish(bytes_old, errorMsg_old)
        end
      end)
    end
  end)
end

function FunctionPhotoStorage:SavePersonalPhotoToPhotoAlbum(texture, photoIndex, time, funcOnProgress, funcOnFinish)
  local bytes = ImageConversion.EncodeToJPG(texture)
  local pbMd5 = PhotoCmd_pb.PhotoMd5()
  pbMd5.md5 = MyMD5.HashBytes(bytes)
  pbMd5.sourceid = photoIndex
  pbMd5.time = time
  pbMd5.source = ProtoCommon_pb.ESOURCE_PHOTO_SELF
  ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5)
  local photoID = FunctionPhotoStorage.GetPersonalPhotoID(photoIndex)
  self:DeleteLocalPhoto(m_photoType, photoID, photoIndex)
  local photoKey = self:GetPhotoKey(m_photoType, photoIndex)
  self.localSaveMap[photoKey] = true
  FunctionCloudFile.Me():SaveToLocal(self:GetPersonalPhotoPath(photoIndex, time, PhotoFileInfo.Extension, false), bytes, function(success)
    local localSaveKey = self.localSaveMap[photoKey]
    self.localSaveMap[photoKey] = nil
    if self.delayDeleteMap[photoKey] then
      self.delayDeleteMap[photoKey] = nil
      self:DeleteLocalPhoto(m_photoType, photoID, photoIndex)
      return
    end
    if localSaveKey == false then
      return
    end
    if not success then
      self:SendUploadFinishMsg(m_photoType, photoIndex, time, false, "save file error")
      MsgManager.ShowMsgByID(3706)
      return
    end
    self:SaveThumbToLocalFile_Personal(photoIndex, time, bytes)
    self:UploadPersonalPhoto(photoIndex, time, funcOnProgress, function(uploadSuccess, errorMsg)
      if funcOnFinish then
        funcOnFinish(uploadSuccess, errorMsg)
      end
      if uploadSuccess then
        ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5)
      end
    end)
  end)
end

function FunctionPhotoStorage:UploadPersonalPhoto(photoIndex, timestamp, funcOnProgress, funcOnFinish)
  local path = self:GetPersonalPhotoPath(photoIndex, timestamp, PhotoFileInfo.Extension, false)
  local photoKey = self:GetPhotoKey(m_photoType, photoIndex)
  FunctionPlayerPrefs.Me():SetInt(photoKey, timestamp)
  self:FormUploadPhoto(m_photoType, photoIndex, path, nil, funcOnProgress, function(uploadSuccess, errorMsg)
    if uploadSuccess then
      FunctionPlayerPrefs.Me():DeleteKey(photoKey)
      ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_UPLOAD, photoIndex)
    end
    if funcOnFinish then
      funcOnFinish(uploadSuccess, errorMsg)
    end
  end)
end

function FunctionPhotoStorage:FindPersonalPhotoPath(photoIndex, isThumb)
  return self:FindPhotoPathFromLocal(m_photoType, FunctionPhotoStorage.GetPersonalPhotoID(photoIndex), isThumb)
end

function FunctionPhotoStorage:GetPersonalPhotoDirPath()
  local thumbPath = ApplicationHelper.persistentDataPath .. "/" .. self.photoThumbPath[m_photoType]
  local photoPath = ApplicationHelper.persistentDataPath .. "/" .. self.photoPath[m_photoType]
  return thumbPath, photoPath
end

function FunctionPhotoStorage:RemoveAllPersonalLocalCacheFiles(cacheIndexs)
  local photoType, photoIndex, customParam, photoID
  for key, value in pairs(self.thumbCacheMap) do
    photoType, photoIndex, customParam = self:GetPhotoParamByKey(key)
    photoID = FunctionPhotoStorage.GetPersonalPhotoID(photoIndex)
    self:DeleteLocalPhoto(photoType, photoID, photoIndex, customParam)
    if cacheIndexs then
      for k, index in pairs(cacheIndexs) do
        if index == photoIndex then
          cacheIndexs[k] = nil
          break
        end
      end
    end
  end
  local thumbPath, photoPath = self:GetPersonalPhotoDirPath()
  if cacheIndexs then
    local photoID
    for k, index in pairs(cacheIndexs) do
      if PhotoDataProxy.Instance:CheckoutPhotoIsUploaded(index) then
        photoID = FunctionPhotoStorage.GetPersonalPhotoID(index)
        self:DeleteLocalPhotoEx(photoID, thumbPath, photoPath)
      end
    end
  end
end

function FunctionPhotoStorage:DeleteLocalPhotoEx(photoID, thumbPath, photoPath)
  local keyWord = photoID .. FunctionPhotoStorage.DivideCharacter
  local folderPath = thumbPath
  local fileNames = FileHelper.GetChildrenName(folderPath)
  local path
  if fileNames then
    for i = 1, #fileNames do
      if string.find(fileNames[i], keyWord) == 1 then
        path = folderPath .. "/" .. fileNames[i]
        FileHelper.DeleteFile(path)
        break
      end
    end
  end
  folderPath = photoPath
  fileNames = FileHelper.GetChildrenName(folderPath)
  if fileNames then
    for i = 1, #fileNames do
      if string.find(fileNames[i], keyWord) == 1 then
        path = folderPath .. "/" .. fileNames[i]
        FileHelper.DeleteFile(path)
        break
      end
    end
  end
end

function FunctionPhotoStorage:SaveThumbToLocalFile_Personal(photoIndex, time, bytes)
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    local width, height = math.floor(texture.width * 0.1), math.floor(texture.height * 0.1)
    local thumbTex = ScreenShot.ReSetTextureSize(texture, width, height)
    local thumbPath = self:GetPersonalPhotoPath(photoIndex, time, PhotoFileInfo.Extension, true)
    local extPos = thumbPath:find("." .. PhotoFileInfo.Extension)
    if 3 < extPos then
      thumbPath = thumbPath:sub(0, extPos - 1)
      ScreenShot.SaveJPG(thumbTex, thumbPath, 100)
    end
    Object.DestroyImmediate(thumbTex)
    Object.DestroyImmediate(texture)
  else
    LogUtility.Info(string.format("[%s] SaveThumbToLocalFile_Personal() save local jpg failed! Try again later..", self.__cname))
    if self.timeTicker then
      TimeTickManager.Me():ClearTick(self, self.timeTicker.id)
      self.timeTicker = nil
    end
    self.timeTicker = TimeTickManager.Me():CreateTick(0, 500, function()
      self:SaveThumbToLocalFile_Personal(photoIndex, time, bytes)
      if self.timeTicker then
        TimeTickManager.Me():ClearTick(self, self.timeTicker.id)
        self.timeTicker = nil
      end
    end, self, nil, false, 1)
  end
end
