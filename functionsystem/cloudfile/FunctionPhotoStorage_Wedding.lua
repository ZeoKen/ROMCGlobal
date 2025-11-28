local m_photoType = FunctionPhotoStorage.PhotoType.Wedding
local m_defaultPhotoIndex = 0

function FunctionPhotoStorage.GetWeddingPhotoID(photoIndex)
  local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
  return weddingInfo.id .. "_" .. photoIndex
end

function FunctionPhotoStorage:GetWeddingPhotoPath(photoIndex, timestamp, isThumb)
  local folderPath = isThumb and self.photoThumbPath[m_photoType] or self.photoPath[m_photoType]
  local photoID = FunctionPhotoStorage.GetWeddingPhotoID(photoIndex)
  if not timestamp or timestamp <= 0 then
    timestamp = FunctionPlayerPrefs.Me():GetInt(self:GetPhotoKey(m_photoType, photoIndex), 0)
  end
  return string.format("%s/%s/%s%s%s.%s", ApplicationHelper.persistentDataPath, folderPath, photoID, FunctionPhotoStorage.DivideCharacter, timestamp, PhotoFileInfo.Extension)
end

function FunctionPhotoStorage:GetWeddingPhotoDownloadUrl(photoIndex, timestamp, isThumb)
  local urlStart = string.format("%s/%s", XDCDNInfo.GetFileServerURL(), self:GetPhotoUrlPath(m_photoType))
  local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
  if BranchMgr.IsChina() then
    local url = string.format("%s%s/%s/%s.%s", urlStart, Game.Myself.data.id, weddingInfo.id, photoIndex, PhotoFileInfo.Extension)
    if isThumb then
      url = url .. "!100"
    end
    return string.format("%s?t=%s", url, timestamp)
  end
  local overseaUrl = string.format("%s%s/%s.%s", urlStart, weddingInfo.id, photoIndex, PhotoFileInfo.Extension)
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    if isThumb then
      overseaUrl = overseaUrl .. "!33"
    end
    return string.format("%s?timestamp=%s", overseaUrl, timestamp)
  end
  return overseaUrl
end

function FunctionPhotoStorage:LoadWeddingPhotoFromLocal(photoIndex, timestamp, isThumb, funcOnFinish)
  local path = self:GetWeddingPhotoPath(m_defaultPhotoIndex, timestamp, isThumb)
  return self:LoadFromLocal(path, funcOnFinish)
end

function FunctionPhotoStorage:GetWeddingPhoto(photoIndex, timestamp, isThumb, funcOnProgress, funcOnFinish)
  local path = self:GetWeddingPhotoPath(m_defaultPhotoIndex, timestamp, isThumb)
  local downloadUrl = self:GetWeddingPhotoDownloadUrl(m_defaultPhotoIndex, timestamp, isThumb)
  local funcOnLocalLoadFinish = function(bytes)
    if funcOnFinish then
      funcOnFinish(bytes)
    end
    self:SendDownloadFinishMsg(m_photoType, m_defaultPhotoIndex, timestamp, isThumb, bytes)
  end
  if self:LoadFromLocal(path, funcOnLocalLoadFinish) then
    return
  end
  self:DownloadPhoto(m_photoType, m_defaultPhotoIndex, timestamp, isThumb, downloadUrl, path, nil, funcOnProgress, function(bytes, errorMsg)
    if funcOnFinish then
      funcOnFinish(bytes, errorMsg)
    end
    if photoIndex ~= m_defaultPhotoIndex then
      self:SendDownloadFinishMsg(m_photoType, photoIndex, timestamp, isThumb, bytes, errorMsg)
    end
  end)
end

function FunctionPhotoStorage:SaveWeddingPhoto(texture, photoIndex, time, from, funcOnProgress, funcOnFinish)
  local bytes = ImageConversion.EncodeToJPG(texture)
  local pbMd5 = PhotoCmd_pb.PhotoMd5()
  pbMd5.md5 = MyMD5.HashBytes(bytes)
  pbMd5.sourceid = photoIndex
  pbMd5.time = time
  pbMd5.source = ProtoCommon_pb.ESOURCE_WEDDING_PHOTO
  ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(pbMd5)
  local photoID = FunctionPhotoStorage.GetWeddingPhotoID(m_defaultPhotoIndex)
  self:DeleteLocalPhoto(m_photoType, photoID, m_defaultPhotoIndex)
  local photoKey = self:GetPhotoKey(m_photoType, photoIndex)
  self.localSaveMap[photoKey] = true
  FunctionCloudFile.Me():SaveToLocal(self:GetWeddingPhotoPath(m_defaultPhotoIndex, time, false), bytes, function(success)
    local localSaveKey = self.localSaveMap[photoKey]
    self.localSaveMap[photoKey] = nil
    if self.delayDeleteMap[photoKey] then
      self.delayDeleteMap[photoKey] = nil
      self:DeleteLocalPhoto(m_photoType, photoID, m_defaultPhotoIndex)
      return
    end
    if localSaveKey == false then
      return
    end
    if not success then
      self:SendUploadFinishMsg(m_photoType, m_defaultPhotoIndex, time, false, "save file error")
      MsgManager.ShowMsgByID(3706)
      return
    end
    FunctionPlayerPrefs.Me():SetInt(photoKey, time)
    self:UploadWeddingPhoto(m_defaultPhotoIndex, time, funcOnProgress, function(uploadSuccess, errorMsg)
      if funcOnFinish then
        funcOnFinish(uploadSuccess, errorMsg)
      end
      if not uploadSuccess then
        if photoIndex ~= m_defaultPhotoIndex then
          self:SendUploadFinishMsg(m_photoType, photoIndex, time, false, errorMsg)
        end
        return
      end
      FunctionPlayerPrefs.Me():DeleteKey(photoKey)
      if from == PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificate then
        local ctData = PhotoDataProxy.Instance:getCurCertificateData()
        ServiceNUserProxy.Instance:CallUploadWeddingPhotoUserCmd(ctData.id, photoIndex, time)
      else
        ServiceWeddingCCmdProxy.Instance:CallUploadWeddingPhotoCCmd(photoIndex, time)
      end
      ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(pbMd5)
      if photoIndex ~= m_defaultPhotoIndex then
        self:SendUploadFinishMsg(m_photoType, photoIndex, time, true)
      end
    end)
  end)
end

function FunctionPhotoStorage:UploadWeddingPhoto(photoIndex, timestamp, funcOnProgress, funcOnFinish)
  local path = self:GetWeddingPhotoPath(m_defaultPhotoIndex, timestamp, false)
  self:FormUploadPhoto(m_photoType, m_defaultPhotoIndex, path, nil, funcOnProgress, funcOnFinish)
end
