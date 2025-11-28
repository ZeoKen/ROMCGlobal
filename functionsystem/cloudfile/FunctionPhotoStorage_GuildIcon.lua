local m_photoType = FunctionPhotoStorage.PhotoType.GuildIcon

function FunctionPhotoStorage.GetGuildIconID(guildID, photoIndex)
  return guildID .. "_" .. photoIndex
end

function FunctionPhotoStorage:RemoveGuildIconData(guildID, photoIndex, time)
  self:CancelPhotoUpload(m_photoType, photoIndex)
  self:CancelPhotoDownload(m_photoType, photoIndex)
  self:DeleteLocalPhoto(m_photoType, FunctionPhotoStorage.GetGuildIconID(guildID, photoIndex), photoIndex)
end

function FunctionPhotoStorage:GetGuildIconPath(guildID, photoIndex, timestamp, extension, isThumb)
  if BranchMgr.IsTW() then
    extension = PhotoFileInfo.PictureFormat.PNG
  else
    extension = extension or PhotoFileInfo.PictureFormat.JPG
  end
  local folderPath = isThumb and self.photoThumbPath[m_photoType] or self.photoPath[m_photoType]
  local photoID = FunctionPhotoStorage.GetGuildIconID(guildID, photoIndex)
  if not timestamp or timestamp <= 0 then
    timestamp = FunctionPlayerPrefs.Me():GetInt(self:GetPhotoKey(m_photoType, photoIndex), 0)
  end
  return orginStringFormat("%s/%s/%s%s%s.%s", ApplicationHelper.persistentDataPath, folderPath, photoID, FunctionPhotoStorage.DivideCharacter, timestamp, extension)
end

function FunctionPhotoStorage:GetGuildIconDownloadUrl(guildID, photoIndex, timestamp, extension, isThumb)
  if BranchMgr.IsTW() then
    extension = PhotoFileInfo.PictureFormat.PNG
  else
    extension = extension or PhotoFileInfo.PictureFormat.JPG
  end
  local url = orginStringFormat("%s/%s%s/%s.%s", XDCDNInfo.GetFileServerURL(), self:GetPhotoUrlPath(m_photoType), guildID, photoIndex, extension)
  if not BranchMgr.IsTW() and not BranchMgr.IsJapan() and not BranchMgr.IsNOEN() and not BranchMgr.IsSEA() and not BranchMgr.IsNA() and not BranchMgr.IsEU() and not BranchMgr.IsNO() and not BranchMgr.IsNOTW() and isThumb then
    url = url .. "!Percent25"
  end
  return orginStringFormat("%s?t=%s", url, timestamp)
end

function FunctionPhotoStorage:LoadGuildIconFromLocal(guildID, photoIndex, timestamp, extension, isThumb, funcOnFinish)
  local path = self:GetGuildIconPath(guildID, photoIndex, timestamp, extension, isThumb)
  return self:LoadFromLocal(path, funcOnFinish)
end

function FunctionPhotoStorage:GetGuildIcon(guildID, photoIndex, timestamp, extension, isThumb, funcOnProgress, funcOnFinish)
  local path = self:GetGuildIconPath(guildID, photoIndex, timestamp, extension, isThumb)
  local downloadUrl = self:GetGuildIconDownloadUrl(guildID, photoIndex, timestamp, extension, isThumb)
  local isExist = self:LoadFromLocal(path, function(bytes)
    if funcOnFinish then
      funcOnFinish(bytes)
    end
    self:SendDownloadFinishMsg(m_photoType, photoIndex, timestamp, isThumb, bytes)
  end)
  if isExist then
    return
  end
  self:DownloadPhoto(m_photoType, photoIndex, timestamp, isThumb, downloadUrl, path, guildID, funcOnProgress, function(bytes, errorMsg)
    if bytes or not isThumb then
      if funcOnFinish then
        funcOnFinish(bytes, errorMsg)
      end
      return
    end
    if not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, guildID, self:GetGuildIconPath(guildID, photoIndex, timestamp, extension, false), 0.25, funcOnFinish) and funcOnFinish then
      funcOnFinish(bytes, errorMsg)
    end
  end)
end

function FunctionPhotoStorage:SaveGuildIcon(bytes, guildID, photoIndex, time, extension, funcOnProgress, funcOnFinish)
  local pbMd5 = PhotoCmd_pb.PhotoMd5()
  pbMd5.md5 = MyMD5.HashBytes(bytes)
  pbMd5.sourceid = photoIndex
  pbMd5.time = time
  pbMd5.source = ProtoCommon_pb.ESOURCE_PHOTO_GUILD
  ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5)
  local photoID = FunctionPhotoStorage.GetGuildIconID(guildID, photoIndex)
  self:DeleteLocalPhoto(m_photoType, photoID, photoIndex)
  local photoKey = self:GetPhotoKey(m_photoType, photoIndex)
  self.localSaveMap[photoKey] = true
  FunctionCloudFile.Me():SaveToLocal(self:GetGuildIconPath(guildID, photoIndex, time, extension, false), bytes, function(success)
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
    self:UploadGuildIcon(guildID, photoIndex, time, extension, funcOnProgress, function(uploadSuccess, errorMsg)
      if funcOnFinish then
        funcOnFinish(uploadSuccess, errorMsg)
      end
      if uploadSuccess then
        ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5)
      else
        MsgManager.ShowMsgByIDTable(995)
      end
    end)
  end)
end

function FunctionPhotoStorage:UploadGuildIcon(guildID, photoIndex, timestamp, extension, funcOnProgress, funcOnFinish)
  local path = self:GetGuildIconPath(guildID, photoIndex, timestamp, extension, false)
  local photoKey = self:GetPhotoKey(m_photoType, photoIndex)
  FunctionPlayerPrefs.Me():SetInt(photoKey, timestamp)
  self:FormUploadPhoto(m_photoType, photoIndex, path, nil, funcOnProgress, function(uploadSuccess, errorMsg)
    if uploadSuccess then
      FunctionPlayerPrefs.Me():DeleteKey(photoKey)
      ServiceGuildCmdProxy.Instance:CallGuildIconAddGuildCmd(photoIndex, nil, timestamp, false, extension)
    end
    if funcOnFinish then
      funcOnFinish(uploadSuccess, errorMsg)
    end
  end)
end

function FunctionPhotoStorage:FindGuildIconPath(guildID, photoIndex, isThumb)
  return self:FindPhotoPathFromLocal(m_photoType, FunctionPhotoStorage.GetGuildIconID(guildID, photoIndex), isThumb)
end
