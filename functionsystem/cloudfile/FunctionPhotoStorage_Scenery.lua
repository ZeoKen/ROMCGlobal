function FunctionPhotoStorage.GetSceneryPhotoType(isAcc)
  if isAcc then
    return FunctionPhotoStorage.PhotoType.SceneryRole
  else
    return FunctionPhotoStorage.PhotoType.SceneryShare
  end
end

function FunctionPhotoStorage.GetSceneryPhotoID(photoType, roleID, photoIndex)
  if photoType == FunctionPhotoStorage.PhotoType.SceneryRole then
    return roleID .. "_" .. photoIndex
  elseif photoType == FunctionPhotoStorage.PhotoType.SceneryShare then
    return photoIndex
  end
end

function FunctionPhotoStorage.CheckSceneryPhotoPath(path)
  if not FileHelper.ExistFile(path) then
    return false
  end
  local fileSize = FileHelper.GetFileSize(path)
  if 102400 < fileSize then
    LogUtility.Error("发现老图片，重新下载。路径: " .. path)
    FileHelper.DeleteFile(path)
    return false
  end
  return true
end

function FunctionPhotoStorage:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, extension, isThumb)
  local folderPath = isThumb and self.photoThumbPath[photoType] or self.photoPath[photoType]
  local photoID = FunctionPhotoStorage.GetSceneryPhotoID(photoType, roleID, photoIndex)
  if not timestamp or timestamp <= 0 then
    timestamp = FunctionPlayerPrefs.Me():GetInt(self:GetPhotoKey(photoType, photoIndex, photoType), 0)
  end
  if timestamp and 0 < timestamp then
    return string.format("%s/%s/%s%s%s.%s", ApplicationHelper.persistentDataPath, folderPath, photoID, FunctionPhotoStorage.DivideCharacter, timestamp, extension)
  else
    return string.format("%s/%s/%s.%s", ApplicationHelper.persistentDataPath, folderPath, photoID, extension)
  end
end

function FunctionPhotoStorage:GetSceneryPhotoDownloadUrl(photoType, roleID, photoIndex, timestamp, extension, isThumb)
  local the_account_id = roleID
  if not the_account_id then
    if (photoType == FunctionPhotoStorage.PhotoType.SceneryShare or photoType == FunctionPhotoStorage.PhotoType.SceneryRole) and BranchMgr.IsKorea() and EnvChannel.IsReleaseBranch() and FunctionLogin.Me():getCurServerDataSid() == 82002 then
      the_account_id = GamePhoto.playerSdkUid or 0
    elseif (photoType == FunctionPhotoStorage.PhotoType.SceneryShare or photoType == FunctionPhotoStorage.PhotoType.SceneryRole) and BranchMgr.IsSEA() and EnvChannel.IsReleaseBranch() and FunctionLogin.Me():getCurServerDataSid() == 90002 then
      the_account_id = GamePhoto.playerSdkUid or 0
    else
      the_account_id = FunctionLogin.Me():getLoginData().accid
    end
  end
  local url = string.format("%s/%s%s/%s.%s", XDCDNInfo.GetFileServerURL(), self:GetPhotoUrlPath(photoType, not roleID), the_account_id, photoIndex, extension)
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

function FunctionPhotoStorage:RemoveSceneryPhotoData(photoType, roleID, photoIndex, time)
  self:CancelPhotoUpload(photoType, photoIndex, photoType)
  self:CancelPhotoDownload(photoType, photoIndex, photoType)
  self:DeleteLocalPhoto(photoType, FunctionPhotoStorage.GetSceneryPhotoID(photoType, roleID, photoIndex), photoIndex, photoType)
end

function FunctionPhotoStorage:LoadSceneryPhotoFromLocal(photoType, roleID, photoIndex, timestamp, isThumb, funcOnFinish)
  local path = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local oldPath = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
  if (not isThumb or FunctionPhotoStorage.CheckSceneryPhotoPath(path)) and self:LoadFromLocal(path, funcOnFinish) then
    return true
  end
  return (not isThumb or FunctionPhotoStorage.CheckSceneryPhotoPath(oldPath)) and self:LoadFromLocal(oldPath, funcOnFinish)
end

function FunctionPhotoStorage:GetSceneryPhoto(photoType, roleID, photoIndex, timestamp, isThumb, funcOnProgress, funcOnFinish)
  local path = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local downloadUrl = self:GetSceneryPhotoDownloadUrl(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local oldPath = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
  local funcOnLocalLoadFinish = function(bytes)
    if funcOnFinish then
      funcOnFinish(bytes)
    end
    self:SendDownloadFinishMsg(photoType, photoIndex, timestamp, isThumb, bytes, photoType)
  end
  if (not isThumb or FunctionPhotoStorage.CheckSceneryPhotoPath(path)) and self:LoadFromLocal(path, funcOnLocalLoadFinish) then
    return
  end
  if (not isThumb or FunctionPhotoStorage.CheckSceneryPhotoPath(oldPath)) and self:LoadFromLocal(oldPath, funcOnLocalLoadFinish) then
    return
  end
  self:DownloadPhoto(photoType, photoIndex, timestamp, isThumb, downloadUrl, path, photoType, funcOnProgress, function(bytes, errorMsg)
    if bytes then
      if funcOnFinish then
        funcOnFinish(bytes, errorMsg)
      end
    else
      local oldDownloadUrl = self:GetSceneryPhotoDownloadUrl(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
      self:DownloadPhoto(photoType, photoIndex, timestamp, isThumb, oldDownloadUrl, oldPath, photoType, funcOnProgress, function(bytes_old, errorMsg_old)
        if bytes_old or not isThumb then
          if funcOnFinish then
            funcOnFinish(bytes_old, errorMsg_old)
          end
          return
        end
        local originPath = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.Extension, false)
        local originOldPath = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.OldExtension, false)
        if not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originPath, 0.1, funcOnFinish) and not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originOldPath, 0.1, funcOnFinish) and funcOnFinish then
          funcOnFinish(bytes_old, errorMsg_old)
        end
      end)
    end
  end)
end

function FunctionPhotoStorage:SaveSceneryPhoto(texture, photoIndex, timestamp, anglez, funcOnProgress, funcOnFinish)
  local bytes = ImageConversion.EncodeToJPG(texture)
  local pbMd5 = PhotoCmd_pb.PhotoMd5()
  pbMd5.md5 = MyMD5.HashBytes(bytes)
  pbMd5.sourceid = photoIndex
  pbMd5.time = timestamp
  pbMd5.source = ProtoCommon_pb.ESOURCE_PHOTO_SCENERY
  ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5)
  local exsitData = AdventureDataProxy.Instance:GetSceneryData(photoIndex)
  local roleID = exsitData and exsitData.oldRoleId
  local photoType = FunctionPhotoStorage.PhotoType.SceneryShare
  local photoID = FunctionPhotoStorage.GetSceneryPhotoID(photoType, roleID, photoIndex)
  self:DeleteLocalPhoto(photoType, photoID, photoIndex, photoType)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, photoType)
  self.localSaveMap[photoKey] = true
  FunctionCloudFile.Me():SaveToLocal(self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.Extension, false), bytes, function(success)
    local localSaveKey = self.localSaveMap[photoKey]
    self.localSaveMap[photoKey] = nil
    if self.delayDeleteMap[photoKey] then
      self.delayDeleteMap[photoKey] = nil
      self:DeleteLocalPhoto(photoType, photoID, photoIndex, photoType)
      return
    end
    if localSaveKey == false then
      return
    end
    if not success then
      self:SendUploadFinishMsg(photoType, photoIndex, timestamp, false, "save file error", photoType)
      MsgManager.ShowMsgByID(3706)
      return
    end
    self:SaveThumbToLocalFile_Scenery(photoIndex, timestamp, bytes)
    self:UploadSceneryPhoto(photoType, roleID, photoIndex, timestamp, anglez, funcOnProgress, function(uploadSuccess, errorMsg)
      if funcOnFinish then
        funcOnFinish(uploadSuccess, errorMsg)
      end
      if uploadSuccess then
        ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5)
      end
    end)
  end)
end

function FunctionPhotoStorage:UploadSceneryPhoto(photoType, roleID, photoIndex, timestamp, anglez, funcOnProgress, funcOnFinish)
  local path = self:GetSceneryPhotoPath(photoType, roleID, photoIndex, timestamp, PhotoFileInfo.Extension, false)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, photoType)
  FunctionPlayerPrefs.Me():SetInt(photoKey, timestamp)
  self:FormUploadPhoto(photoType, photoIndex, path, photoType, funcOnProgress, function(uploadSuccess, errorMsg)
    if uploadSuccess then
      FunctionPlayerPrefs.Me():DeleteKey(photoKey)
      ServiceNUserProxy.Instance:CallUploadOkSceneryUserCmd(photoIndex, 1, anglez, timestamp)
      if AdventureDataProxy.Instance:IsSceneryUnlock(photoIndex) then
        MsgManager.ShowMsgByID(553)
      else
        local sceneData = Table_Viewspot[photoIndex]
        if sceneData then
          MsgManager.ShowMsgByIDTable(904, sceneData.SpotName)
        end
      end
    end
    if funcOnFinish then
      funcOnFinish(uploadSuccess, errorMsg)
    end
  end)
end

function FunctionPhotoStorage:FindSceneryPhotoPath(photoType, roleID, photoIndex, isThumb)
  return self:FindPhotoPathFromLocal(photoType, FunctionPhotoStorage.GetSceneryPhotoID(photoType, roleID, photoIndex), isThumb)
end

function FunctionPhotoStorage:GetSceneryPhotoDirPath(photoType)
  local thumbPath = ApplicationHelper.persistentDataPath .. "/" .. self.photoThumbPath[photoType]
  local photoPath = ApplicationHelper.persistentDataPath .. "/" .. self.photoPath[photoType]
  return thumbPath, photoPath
end

function FunctionPhotoStorage:RemoveAllSceneryLocalCacheFiles(cacheIndexs)
  local photoType, photoIndex, customParam, photoID
  for key, value in pairs(self.thumbCacheMap) do
    photoType, photoIndex, customParam = self:GetPhotoParamByKey(key)
    photoID = FunctionPhotoStorage.GetSceneryPhotoID(photoType, nil, photoIndex)
    self:DeleteLocalPhoto(photoType, photoID, photoIndex, photoType)
    if cacheIndexs then
      for k, index in pairs(cacheIndexs) do
        if index == photoIndex then
          cacheIndexs[k] = nil
          break
        end
      end
    end
  end
  photoType = FunctionPhotoStorage.PhotoType.SceneryShare
  local thumbPath, photoPath = self:GetSceneryPhotoDirPath(photoType)
  if cacheIndexs then
    local photoID
    for k, index in pairs(cacheIndexs) do
      photoID = FunctionPhotoStorage.GetSceneryPhotoID(photoType, nil, index)
      self:DeleteLocalPhotoEx(photoID, thumbPath, photoPath)
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

function FunctionPhotoStorage:SaveThumbToLocalFile_Scenery(photoIndex, time, bytes)
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    local width, height = math.floor(texture.width * 0.1), math.floor(texture.height * 0.1)
    local thumbTex = ScreenShot.ReSetTextureSize(texture, width, height)
    local photoType = FunctionPhotoStorage.PhotoType.SceneryShare
    local thumbPath = self:GetSceneryPhotoPath(photoType, nil, photoIndex, time, PhotoFileInfo.Extension, true)
    local extPos = thumbPath:find("." .. PhotoFileInfo.Extension)
    if 3 < extPos then
      thumbPath = thumbPath:sub(0, extPos - 1)
      ScreenShot.SaveJPG(thumbTex, thumbPath, 100)
    end
    Object.DestroyImmediate(thumbTex)
    Object.DestroyImmediate(texture)
  else
    LogUtility.Info(string.format("[%s] SaveThumbToLocalFile_Scenery() save local jpg failed! Try again later..", self.__cname))
    if self.timeTicker then
      TimeTickManager.Me():ClearTick(self, self.timeTicker.id)
      self.timeTicker = nil
    end
    self.timeTicker = TimeTickManager.Me():CreateTick(0, 500, function()
      self:SaveThumbToLocalFile_Scenery(photoIndex, time, bytes)
      if self.timeTicker then
        TimeTickManager.Me():ClearTick(self, self.timeTicker.id)
        self.timeTicker = nil
      end
    end, self, nil, false, 1)
  end
end
