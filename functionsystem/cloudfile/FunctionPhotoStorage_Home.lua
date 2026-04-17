local m_divideChar = FunctionPhotoStorage.DivideCharacter
local GetHomeFolderByType = function(photoType, isThumb)
  local storage = FunctionPhotoStorage.Me()
  local pathMap = storage.homePathMap
  local paths = pathMap and pathMap[photoType]
  paths = paths or pathMap and pathMap[FunctionPhotoStorage.PhotoType.HomeRecommend]
  if not paths then
    return nil
  end
  return isThumb and paths.thumb or paths.origin
end
local GetHomeServerPhotoType = function(self, photoType)
  return self.photoServerType[photoType] or photoType
end

function FunctionPhotoStorage:GetHomePhotoPath(photoType, photoId, timestamp, extension, isThumb, index)
  extension = extension or PhotoFileInfo.Extension
  local folderPath = GetHomeFolderByType(photoType, isThumb)
  local fullFolderPath = string.format("%s/%s", ApplicationHelper.persistentDataPath, folderPath)
  if fullFolderPath and not FileHelper.ExistDirectory(fullFolderPath) then
    FileHelper.CreateDirectory(fullFolderPath)
  end
  local baseName = tostring(photoId)
  if index ~= nil then
    baseName = baseName .. "_" .. tostring(index)
  end
  if not timestamp or timestamp <= 0 then
    return string.format("%s/%s/%s.%s", ApplicationHelper.persistentDataPath, folderPath, baseName, extension)
  end
  timestamp = math.floor(timestamp)
  return string.format("%s/%s/%s%s%s.%s", ApplicationHelper.persistentDataPath, folderPath, baseName, m_divideChar, tostring(timestamp), extension)
end

function FunctionPhotoStorage:LoadHomePhotoFromLocal(photoType, photoId, timestamp, isThumb, funcOnFinish, extension, index)
  extension = extension or PhotoFileInfo.Extension
  local path = self:GetHomePhotoPath(photoType, photoId, timestamp, extension, isThumb, index)
  return self:LoadFromLocal(path, funcOnFinish)
end

function FunctionPhotoStorage:GetHomePhoto(photoType, photoId, timestamp, isThumb, urlPath, index, funcOnProgress, funcOnFinish, customParam)
  local downloadUrl = self:GetHomePhotoDownloadUrl(photoType, photoId, timestamp, PhotoFileInfo.Extension, isThumb, urlPath)
  if not downloadUrl or downloadUrl == "" then
    LogUtility.Error(string.format("[FunctionPhotoStorage_Home] GetHomePhotoDownloadUrl failed, type=%s, id=%s", tostring(photoType), tostring(photoId)))
    return
  end
  if not timestamp or timestamp <= 0 then
    timestamp = math.floor(ServerTime.CurServerTime() / 1000)
  end
  local path = self:GetHomePhotoPath(photoType, photoId, timestamp, PhotoFileInfo.Extension, isThumb, index)
  local DeleteOlderSameBase = function()
    if not isThumb then
      return
    end
    if not timestamp or timestamp <= 0 then
      return
    end
    local folderPath = GetHomeFolderByType(photoType, isThumb)
    if not folderPath then
      return
    end
    local fullFolderPath = string.format("%s/%s", ApplicationHelper.persistentDataPath, folderPath)
    local files = FileHelper.GetChildrenName(fullFolderPath)
    if not files then
      return
    end
    local baseName = tostring(photoId)
    if index ~= nil then
      baseName = baseName .. "_" .. tostring(index)
    end
    for i = 1, #files do
      local fn = files[i]
      if fn then
        local nameExceptExt = StringUtility.Split(fn, ".")[1]
        local parts = StringUtility.Split(nameExceptExt, m_divideChar)
        local fileBase = parts and parts[1]
        local ts = tonumber(parts and parts[2]) or 0
        if fileBase == baseName and 0 < ts and ts < timestamp then
          FileHelper.DeleteFile(string.format("%s/%s", fullFolderPath, fn))
        end
      end
    end
  end
  local CleanupOldOriginFiles = function()
    local folderPath = GetHomeFolderByType(photoType, false)
    if not folderPath then
      return
    end
    local fullFolderPath = string.format("%s/%s", ApplicationHelper.persistentDataPath, folderPath)
    local files = FileHelper.GetChildrenName(fullFolderPath)
    if not files then
      return
    end
    for i = 1, #files do
      local fn = files[i]
      if fn then
        FileHelper.DeleteFile(string.format("%s/%s", fullFolderPath, fn))
      end
    end
  end
  local funcOnLocalLoadFinish = function(bytes)
    if funcOnFinish then
      funcOnFinish(bytes)
    end
    self:SendDownloadFinishMsg(photoType, photoId, timestamp, isThumb, bytes, nil, customParam)
  end
  if self:LoadFromLocal(path, funcOnLocalLoadFinish) then
    return
  end
  if not isThumb and not FileHelper.ExistFile(path) then
    CleanupOldOriginFiles()
  elseif isThumb then
    self:RemoveThumbCache(photoType, photoId, customParam)
  end
  redlog("GetHomePhoto downloadUrl = " .. tostring(downloadUrl), "path = " .. tostring(path))
  self:DownloadPhoto(photoType, photoId, timestamp, isThumb, downloadUrl, path, customParam, funcOnProgress, function(bytes, errorMsg)
    redlog("[FunctionPhotoStorage_Home] download finish", "path=" .. tostring(path), "bytes=" .. tostring(bytes and #bytes or 0), "error=" .. tostring(errorMsg))
    if path then
      redlog("[FunctionPhotoStorage_Home] file exists after download: " .. tostring(FileHelper.ExistFile(path)))
    end
    if bytes and isThumb then
      DeleteOlderSameBase()
    end
    if funcOnFinish then
      funcOnFinish(bytes, errorMsg)
    end
  end)
end

function FunctionPhotoStorage:GetHomePhotoDownloadUrl(photoType, photoId, timestamp, extension, isThumb, urlPath)
  extension = extension or PhotoFileInfo.Extension
  timestamp = math.floor(timestamp or 0)
  if not urlPath then
    LogUtility.Error(string.format("[FunctionPhotoStorage_Home] urlPath is nil, photoType=%s", tostring(photoType)))
    return nil
  end
  local url = string.format("%s/%s/%s.%s", XDCDNInfo.GetFileServerURL(), urlPath, tostring(photoId), extension)
  if BranchMgr.IsChina() then
    if isThumb then
      url = url .. "!100"
    end
    return url
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    if isThumb then
      url = url .. "!33"
    end
    return url
  end
  return url
end

function FunctionPhotoStorage:FormUploadHomePhoto(photoType, photoId, strPath, customParam, funcOnProgress, funcOnFinish)
  if not FileHelper.ExistFile(strPath) then
    LogUtility.Error(string.format("[FunctionPhotoStorage_Home] Cannot Find Home Photo File: %s", tostring(strPath)))
    return
  end
  local serverPhotoType = GetHomeServerPhotoType(self, photoType)
  if not serverPhotoType then
    LogUtility.Error("[FunctionPhotoStorage_Home] serverPhotoType is nil")
    return
  end
  local photoKey = self:GetPhotoKey(serverPhotoType, photoId, customParam, true)
  local curUploadInfo = self.uploadMap[photoKey]
  if curUploadInfo then
    if funcOnProgress then
      curUploadInfo.listOnProgress[#curUploadInfo.listOnProgress + 1] = funcOnProgress
    end
    if funcOnFinish then
      curUploadInfo.listOnFinish[#curUploadInfo.listOnFinish + 1] = funcOnFinish
    end
    return
  end
  self.photoPathMap[photoKey] = strPath
  self.photoTypeMap[photoKey] = photoType
  local photoInfoList = self.waitUploadMap[photoKey]
  if not photoInfoList then
    photoInfoList = ReusableTable.CreateArray()
    self.waitUploadMap[photoKey] = photoInfoList
  end
  local uploadInfo = ReusableTable.CreateTable()
  uploadInfo.onProgress = funcOnProgress
  uploadInfo.onFinish = funcOnFinish
  photoInfoList[#photoInfoList + 1] = uploadInfo
  if #photoInfoList < 2 then
    ServicePhotoCmdProxy.Instance:CallQueryUploadInfoPhotoCmd(serverPhotoType, photoId, customParam)
  end
end

function FunctionPhotoStorage:SaveHomePhoto(photoType, texture, photoId, timestamp, customParam, funcOnProgress, funcOnFinish)
  if texture == nil then
    LogUtility.Error("[FunctionPhotoStorage_Home] SaveHomePhoto texture is nil")
    if funcOnFinish then
      funcOnFinish(false, "texture is nil")
    end
    return
  end
  local bytes = ImageConversion.EncodeToJPG(texture)
  local path = self:GetHomePhotoPath(photoType, photoId, timestamp, PhotoFileInfo.Extension, false)
  FunctionCloudFile.Me():SaveToLocal(path, bytes, function(success)
    if not success then
      if funcOnFinish then
        funcOnFinish(false, "save file error")
      end
      return
    end
    self:FormUploadHomePhoto(photoType, photoId, path, customParam, funcOnProgress, funcOnFinish)
  end)
end
