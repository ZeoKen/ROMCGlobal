FunctionPhotoStorage = class("FunctionPhotoStorage")
FunctionPhotoStorage.PhotoType = {
  SceneryRole = 1,
  SceneryShare = 2,
  Personal = 3,
  GuildIcon = 4,
  Wedding = 5,
  UnionWall = 6,
  PhotoBoard = 7
}
local m_divideChar = "!"
FunctionPhotoStorage.DivideCharacter = m_divideChar
FunctionPhotoStorage.CloudQuestKeyDiviver = "~~~"
FunctionPhotoStorage.OnPhotoDownloadProgress = "FunctionPhotoStorage_OnPhotoDownloadProgress"
FunctionPhotoStorage.OnPhotoDownloadFinish = "FunctionPhotoStorage_OnPhotoDownloadFinish"
FunctionPhotoStorage.OnPhotoUploadProgress = "FunctionPhotoStorage_OnPhotoUploadProgress"
FunctionPhotoStorage.OnPhotoUploadFinish = "FunctionPhotoStorage_OnPhotoUploadFinish"
FunctionPhotoStorage.MaxThumbCacheCount = 20
autoImport("FunctionPhotoStorage_Personal")
autoImport("FunctionPhotoStorage_Scenery")
autoImport("FunctionPhotoStorage_Wedding")
autoImport("FunctionPhotoStorage_UnionWall")
autoImport("FunctionPhotoStorage_GuildIcon")

function FunctionPhotoStorage.Me()
  if nil == FunctionPhotoStorage.me then
    FunctionPhotoStorage.me = FunctionPhotoStorage.new()
  end
  return FunctionPhotoStorage.me
end

function FunctionPhotoStorage.IsActive()
  return FunctionCloudFile.IsActive()
end

function FunctionPhotoStorage:GetPhotoKey(photoType, photoIndex, customParam, isServerType)
  if not customParam or customParam == "" then
    customParam = 0
  end
  return string.format("Photo_%s%s%s%s%s", isServerType and photoType or self.photoServerType[photoType], m_divideChar, photoIndex, m_divideChar, customParam)
end

function FunctionPhotoStorage:GetPhotoParamByKey(photoKey)
  local key = string.sub(photoKey, string.find(photoKey, "_") + 1, string.len(photoKey))
  local values = key:split(m_divideChar)
  local photoType = tonumber(values[1])
  photoType = self:GPhotoTypeByPhotoIndex(photoType)
  return photoType, tonumber(values[2]), tonumber(values[3])
end

function FunctionPhotoStorage:GPhotoTypeByPhotoIndex(index)
  for i, v in pairs(self.photoServerType) do
    if v == index then
      return i
    end
  end
  LogUtility.Error(string.format("[%s] GetPhotoParamByKey() photoIndex = %s is not exist in self.photoServerType.values!", self.__cname, tostring(index)))
end

function FunctionPhotoStorage:ctor()
  self:Init()
end

function FunctionPhotoStorage:Init()
  self.photoServerType = {
    [FunctionPhotoStorage.PhotoType.SceneryRole] = PhotoCmd_pb.EPHOTOTYPE_SCENERY or 1,
    [FunctionPhotoStorage.PhotoType.SceneryShare] = PhotoCmd_pb.EPHOTOTYPE_SCENERY or 1,
    [FunctionPhotoStorage.PhotoType.Personal] = PhotoCmd_pb.EPHOTOTYPE_PHOTO or 2,
    [FunctionPhotoStorage.PhotoType.GuildIcon] = PhotoCmd_pb.EPHOTOTYPE_GUILD_ICON or 3,
    [FunctionPhotoStorage.PhotoType.Wedding] = PhotoCmd_pb.EPHOTOTYPE_WEDDING or 4,
    [FunctionPhotoStorage.PhotoType.PhotoBoard] = PhotoCmd_pb.EPHOTOTYPE_BOARD or 5
  }
  self.photoPath = {
    [FunctionPhotoStorage.PhotoType.SceneryRole] = IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesOrigin,
    [FunctionPhotoStorage.PhotoType.SceneryShare] = IOPathConfig.Paths.Extension.ScenicSpotPhotoShareOrigin,
    [FunctionPhotoStorage.PhotoType.Personal] = IOPathConfig.Paths.USER.PersonalPhotoOrigin,
    [FunctionPhotoStorage.PhotoType.Wedding] = IOPathConfig.Paths.USER.MarryPhotoOrigin,
    [FunctionPhotoStorage.PhotoType.UnionWall] = IOPathConfig.Paths.USER.UnionWallPhotoOrigin,
    [FunctionPhotoStorage.PhotoType.GuildIcon] = IOPathConfig.Paths.USER.UnionLogoOrigin
  }
  self.photoThumbPath = {
    [FunctionPhotoStorage.PhotoType.SceneryRole] = IOPathConfig.Paths.Extension.ScenicSpotPhotoRolesThumbnail,
    [FunctionPhotoStorage.PhotoType.SceneryShare] = IOPathConfig.Paths.Extension.ScenicSpotPhotoShareThumbnail,
    [FunctionPhotoStorage.PhotoType.Personal] = IOPathConfig.Paths.USER.PersonalPhotoThumbnail,
    [FunctionPhotoStorage.PhotoType.Wedding] = IOPathConfig.Paths.USER.MarryPhotoThumbnail,
    [FunctionPhotoStorage.PhotoType.UnionWall] = IOPathConfig.Paths.USER.UnionWallPhotoThumbnail,
    [FunctionPhotoStorage.PhotoType.GuildIcon] = IOPathConfig.Paths.USER.UnionLogoThumbnail
  }
  self.photoPathMap = {}
  self.photoTypeMap = {}
  self.urlPathMap = {}
  self.urlAccPathMap = {}
  self.waitUploadMap = {}
  self.downloadMap = {}
  self.thumbDownloadMap = {}
  self.uploadMap = {}
  self.thumbCacheMap = {}
  self.thumbCacheKeyList = {}
  self.processMessageBody = {}
  self.finishMessageBody = {}
  self.downloadKeyMap = {}
  self.thumbDownloadKeyMap = {}
  self.uploadKeyMap = {}
  self.localSaveMap = {}
  self.delayDeleteMap = {}
  self.generateThumbMap = {}
end

function FunctionPhotoStorage:SetPhotoUrlPath(serverPhotoType, urlPath)
  self.urlPathMap[serverPhotoType] = urlPath
end

function FunctionPhotoStorage:SetPhotoAccUrlPath(serverPhotoType, urlPath)
  self.urlAccPathMap[serverPhotoType] = urlPath
end

function FunctionPhotoStorage:GetPhotoUrlPath(photoType, isAcc)
  local targetMap = isAcc and self.urlAccPathMap or self.urlPathMap
  local serverPhotoType = self.photoServerType[photoType]
  if not serverPhotoType then
    redlog("Cannot find photoType: " .. tostring(photoType) .. " from photoServerType!")
  end
  return targetMap[serverPhotoType]
end

function FunctionPhotoStorage:DownloadPhoto(photoType, photoIndex, timestamp, isThumb, strUrl, strPath, customParam, funcOnProgress, funcOnFinish)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  local localData = isThumb and self.thumbCacheMap[photoKey]
  if localData then
    for i = #self.thumbCacheKeyList, 1, -1 do
      if self.thumbCacheKeyList[i] == photoKey then
        table.remove(self.thumbCacheKeyList, i)
      end
    end
    self.thumbCacheKeyList[#self.thumbCacheKeyList + 1] = photoKey
    FunctionUtility.Me():DelayCall(function()
      if funcOnFinish then
        funcOnFinish(localData)
      end
      self:SendDownloadFinishMsg(photoType, photoIndex, timestamp, isThumb, localData, errorMsg)
    end)
    return
  end
  local targetMap = isThumb and self.thumbDownloadMap or self.downloadMap
  local curDownloadInfo = targetMap[photoKey]
  local isDownloading = curDownloadInfo ~= nil
  if not curDownloadInfo then
    curDownloadInfo = ReusableTable.CreateTable()
    curDownloadInfo.listOnProgress = ReusableTable.CreateArray()
    curDownloadInfo.listOnFinish = ReusableTable.CreateArray()
    targetMap[photoKey] = curDownloadInfo
    local targetKeyMap = isThumb and self.thumbDownloadKeyMap or self.downloadKeyMap
    targetKeyMap[photoKey] = strUrl .. FunctionPhotoStorage.CloudQuestKeyDiviver .. strPath
  end
  if funcOnProgress then
    curDownloadInfo.listOnProgress[#curDownloadInfo.listOnProgress + 1] = funcOnProgress
  end
  if funcOnFinish then
    curDownloadInfo.listOnFinish[#curDownloadInfo.listOnFinish + 1] = funcOnFinish
  end
  if isDownloading then
    return
  end
  FunctionCloudFile.Me():Download(strUrl, strPath, false, function(progress)
    local listOnProgress = curDownloadInfo.listOnProgress
    for i = 1, #listOnProgress do
      listOnProgress[i](progress)
    end
    self.processMessageBody.type = photoType
    self.processMessageBody.index = photoIndex
    self.processMessageBody.time = timestamp
    self.processMessageBody.isThumb = isThumb
    self.processMessageBody.progress = progress
    self.processMessageBody.customParam = customParam
    GameFacade.Instance:sendNotification(FunctionPhotoStorage.OnPhotoDownloadProgress, self.processMessageBody)
  end, function(isSuccess, errorMsg)
    if not targetMap[photoKey] then
      return
    end
    local bytes = isSuccess and FileHelper.LoadFile(strPath) or nil
    if isThumb then
      for i = #self.thumbCacheKeyList, 1, -1 do
        if self.thumbCacheKeyList[i] == photoKey then
          table.remove(self.thumbCacheKeyList, i)
        end
      end
      self.thumbCacheKeyList[#self.thumbCacheKeyList + 1] = photoKey
      if #self.thumbCacheKeyList > FunctionPhotoStorage.MaxThumbCacheCount then
        self.thumbCacheMap[self.thumbCacheKeyList[1]] = nil
        table.remove(self.thumbCacheKeyList, 1)
      end
      self.thumbCacheMap[photoKey] = bytes
    end
    targetMap[photoKey] = nil
    local targetKeyMap = isThumb and self.thumbDownloadKeyMap or self.downloadKeyMap
    targetKeyMap[photoKey] = nil
    local listOnFinish = curDownloadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback Is Removed!")
      return
    end
    for i = 1, #listOnFinish do
      listOnFinish[i](bytes, errorMsg)
    end
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curDownloadInfo)
    self:SendDownloadFinishMsg(photoType, photoIndex, timestamp, isThumb, bytes, errorMsg, customParam)
  end)
end

function FunctionPhotoStorage:SendDownloadFinishMsg(photoType, photoIndex, timestamp, isThumb, bytes, errorMsg, customParam)
  TableUtility.TableClear(self.finishMessageBody)
  self.finishMessageBody.type = photoType
  self.finishMessageBody.index = photoIndex
  self.finishMessageBody.time = timestamp
  self.finishMessageBody.isThumb = isThumb
  self.finishMessageBody.byte = bytes
  self.finishMessageBody.error = errorMsg
  self.finishMessageBody.customParam = customParam
  GameFacade.Instance:sendNotification(FunctionPhotoStorage.OnPhotoDownloadFinish, self.finishMessageBody)
end

function FunctionPhotoStorage:FormUploadPhoto(photoType, photoIndex, strPath, customParam, funcOnProgress, funcOnFinish)
  if not FileHelper.ExistFile(strPath) then
    LogUtility.Error("Cannot Find Photo File: " .. tostring(strPath))
    return
  end
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
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
    ServicePhotoCmdProxy.Instance:CallQueryUploadInfoPhotoCmd(self.photoServerType[photoType], photoIndex, customParam)
  end
end

function FunctionPhotoStorage:OnRecvQueryUploadInfoPhotoCmd(data)
  if not data then
    LogUtility.Error("OnRecvUploadSceneryPhotoUserCmd No Data!")
    return
  end
  local serverPhotoType = data.type
  local photoIndex = data.id
  local customParam = data.customparam
  local photoKey = self:GetPhotoKey(serverPhotoType, photoIndex, customParam, true)
  local photoInfoList = self.waitUploadMap[photoKey]
  if not photoInfoList then
    return
  end
  local curUploadInfo = self.uploadMap[photoKey]
  local isUploading = curUploadInfo ~= nil
  if not curUploadInfo then
    curUploadInfo = ReusableTable.CreateTable()
    curUploadInfo.listOnProgress = ReusableTable.CreateArray()
    curUploadInfo.listOnFinish = ReusableTable.CreateArray()
    self.uploadMap[photoKey] = curUploadInfo
  end
  local singlePhotoInfo
  for i = 1, #photoInfoList do
    singlePhotoInfo = photoInfoList[i]
    if singlePhotoInfo.onProgress then
      curUploadInfo.listOnProgress[#curUploadInfo.listOnProgress + 1] = singlePhotoInfo.onProgress
    end
    if singlePhotoInfo.onFinish then
      curUploadInfo.listOnFinish[#curUploadInfo.listOnFinish + 1] = singlePhotoInfo.onFinish
    end
    ReusableTable.DestroyAndClearTable(singlePhotoInfo)
  end
  ReusableTable.DestroyAndClearArray(photoInfoList)
  self.waitUploadMap[photoKey] = nil
  local photoType = self.photoTypeMap[photoKey]
  local strPath = self.photoPathMap[photoKey]
  self.photoTypeMap[photoKey] = nil
  self.photoPathMap[photoKey] = nil
  if isUploading then
    return
  end
  if not FileHelper.ExistFile(strPath) then
    LogUtility.Error("Cannot Find Photo File: " .. tostring(strPath))
    return
  end
  local strFileName = FileHelper.GetFileNameFromPath(strPath)
  local fileTimestamp = tonumber(StringUtility.Split(strFileName, FunctionPhotoStorage.DivideCharacter)[2])
  local url, formUploadData = self:GetUrlAndUploadData(strPath, data)
  self.uploadKeyMap[photoKey] = url .. FunctionPhotoStorage.CloudQuestKeyDiviver .. strPath
  FunctionCloudFile.Me():FormUpload(url, strPath, formUploadData, function(progress)
    local listOnProgress = curUploadInfo.listOnProgress
    for i = 1, #listOnProgress do
      listOnProgress[i](progress)
    end
    self.processMessageBody.type = photoType
    self.processMessageBody.index = photoIndex
    self.processMessageBody.time = fileTimestamp
    self.processMessageBody.progress = progress
    self.processMessageBody.customParam = customParam
    GameFacade.Instance:sendNotification(FunctionPhotoStorage.OnPhotoUploadProgress, self.processMessageBody)
  end, function(success, errorMsg)
    if not self.uploadMap[photoKey] then
      return
    end
    self.uploadMap[photoKey] = nil
    self.uploadKeyMap[photoKey] = nil
    local listOnFinish = curUploadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback Is Removed!")
      return
    end
    for i = 1, #listOnFinish do
      listOnFinish[i](success, errorMsg)
    end
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curUploadInfo)
    self:SendUploadFinishMsg(photoType, photoIndex, fileTimestamp, success, errorMsg, customParam)
  end)
end

local AwsUploadFieldIndex = {
  acl = 0,
  ["Content-Type"] = 1,
  key = 2,
  success_action_status = 3,
  ["x-amz-algorithm"] = 4,
  ["x-amz-credential"] = 5,
  ["x-amz-date"] = 6,
  policy = 7,
  signature = 8
}
local GoogleUploadFieldIndex = {
  ["content-type"] = 0,
  bucket = 1,
  acl = 2,
  key = 3,
  GoogleAccessId = 4,
  policy = 5,
  signature = 6,
  success_action_status = 7
}

function FunctionPhotoStorage:GetUrlAndUploadData(strPath, data)
  local uploadFields = ReusableTable.CreateArray()
  local params = data.params
  local url, formUploadData
  if BranchMgr.IsChina() then
    formUploadData = CloudFile.UpyunUploadData()
    for i = 1, #params do
      uploadFields[#uploadFields + 1] = params[i].key
      uploadFields[#uploadFields + 1] = params[i].value
    end
    url = UpyunInfo.GetFormUploadURL()
  else
    formUploadData = CloudFile.FormUploadData()
    if data.useaws then
      local index, bucket
      for i = 1, #params do
        index = AwsUploadFieldIndex[params[i].key]
        if index then
          uploadFields[index * 2 + 1] = params[i].key
          uploadFields[index * 2 + 2] = params[i].value
        elseif params[i].key == "bucket" then
          bucket = params[i].value
        end
      end
      index = AwsUploadFieldIndex.signature
      uploadFields[index * 2 + 1] = "x-amz-signature"
      url = string.format("http://%s.s3.ap-northeast-1.amazonaws.com/", bucket)
    else
      local index
      for i = 1, #params do
        index = GoogleUploadFieldIndex[params[i].key]
        if index then
          uploadFields[index * 2 + 1] = params[i].key
          uploadFields[index * 2 + 2] = params[i].value
        end
      end
      url = GoogleStorageConfig.googleStorageUpLoad
    end
  end
  formUploadData:InitDatas(strPath, uploadFields)
  ReusableTable.DestroyAndClearArray(uploadFields)
  return url, formUploadData
end

function FunctionPhotoStorage:SendUploadFinishMsg(photoType, photoIndex, timestamp, success, errorMsg, customParam)
  TableUtility.TableClear(self.finishMessageBody)
  self.finishMessageBody.type = photoType
  self.finishMessageBody.index = photoIndex
  self.finishMessageBody.time = timestamp
  self.finishMessageBody.success = success
  self.finishMessageBody.error = errorMsg
  self.finishMessageBody.customParam = customParam
  GameFacade.Instance:sendNotification(FunctionPhotoStorage.OnPhotoUploadFinish, self.finishMessageBody)
end

function FunctionPhotoStorage:CancelPhotoDownload(photoType, photoIndex, customParam)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  local questKey = self.downloadKeyMap[photoKey]
  if questKey then
    local keys = string.split(questKey, FunctionPhotoStorage.CloudQuestKeyDiviver)
    FunctionCloudFile.Me():CancelDownload(keys[1], keys[2])
  end
  questKey = self.thumbDownloadKeyMap[photoKey]
  if questKey then
    local keys = string.split(questKey, FunctionPhotoStorage.CloudQuestKeyDiviver)
    FunctionCloudFile.Me():CancelDownload(keys[1], keys[2])
  end
  local listOnFinish = self.generateThumbMap[photoKey]
  if listOnFinish then
    for i = 1, #listOnFinish do
      listOnFinish[i](nil, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(listOnFinish)
  end
  self.generateThumbMap[photoKey] = nil
end

function FunctionPhotoStorage:CancelPhotoUpload(photoType, photoIndex, customParam)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  local questKey = self.uploadKeyMap[photoKey]
  self.localSaveMap[photoKey] = false
  if questKey then
    local keys = string.split(questKey, FunctionPhotoStorage.CloudQuestKeyDiviver)
    FunctionCloudFile.Me():CancelUpload(keys[1], keys[2])
  end
end

function FunctionPhotoStorage:LoadFromLocal(strPath, funcOnFinish)
  return FunctionCloudFile.Me():LoadFromLocal(strPath, funcOnFinish)
end

function FunctionPhotoStorage:FindPhotoPathFromLocal(photoType, photo_id, isThumb, serverTimestamp)
  local strFolderPath = string.format("%s/%s/", ApplicationHelper.persistentDataPath, isThumb and self.photoThumbPath[photoType] or self.photoPath[photoType])
  if not strFolderPath then
    return
  end
  local fileNames = FileHelper.GetChildrenName(strFolderPath)
  local keyWord = photo_id .. FunctionPhotoStorage.DivideCharacter
  for i = 1, #fileNames do
    if string.find(fileNames[i], keyWord) == 1 then
      local nameExceptExtension = StringUtility.Split(fileNames[i], ".")[1]
      local fileTimestamp = tonumber(StringUtility.Split(nameExceptExtension, FunctionPhotoStorage.DivideCharacter)[2])
      if not serverTimestamp then
        return strFolderPath .. fileNames[i], fileTimestamp
      end
      if serverTimestamp <= fileTimestamp then
        return strFolderPath .. fileNames[i], fileTimestamp
      end
    end
  end
end

function FunctionPhotoStorage:DeleteLocalPhoto(photoType, photo_id, photoIndex, customParam)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  if self.localSaveMap[photoKey] == true then
    self.delayDeleteMap[photoKey] = true
    return
  end
  self:RemoveThumbCache(photoType, photoIndex, customParam)
  local keyWord = photo_id .. FunctionPhotoStorage.DivideCharacter
  local folderPath = string.format("%s/%s/", ApplicationHelper.persistentDataPath, self.photoPath[photoType])
  local fileNames = FileHelper.GetChildrenName(folderPath)
  if fileNames then
    for i = 1, #fileNames do
      if string.find(fileNames[i], keyWord) == 1 then
        FileHelper.DeleteFile(folderPath .. fileNames[i])
      end
    end
  end
  folderPath = string.format("%s/%s/", ApplicationHelper.persistentDataPath, self.photoThumbPath[photoType])
  fileNames = FileHelper.GetChildrenName(folderPath)
  if fileNames then
    for i = 1, #fileNames do
      if string.find(fileNames[i], keyWord) == 1 then
        FileHelper.DeleteFile(folderPath .. fileNames[i])
      end
    end
  end
end

function FunctionPhotoStorage:RemoveThumbCache(photoType, photoIndex, customParam)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  if self.thumbCacheMap[photoKey] then
    for i = #self.thumbCacheKeyList, 1, -1 do
      if self.thumbCacheKeyList[i] == photoKey then
        table.remove(self.thumbCacheKeyList, i)
      end
    end
    self.thumbCacheMap[photoKey] = nil
  end
end

function FunctionPhotoStorage:GenerateThumbByPath(photoType, photoIndex, timestamp, customParam, strPath, coefficient, funcOnFinish)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  local listOnFinish = self.generateThumbMap[photoKey]
  if listOnFinish then
    listOnFinish[#listOnFinish + 1] = funcOnFinish
    return true
  end
  listOnFinish = ReusableTable.CreateArray()
  listOnFinish[#listOnFinish + 1] = funcOnFinish
  self.generateThumbMap[photoKey] = listOnFinish
  local isExist = self:LoadFromLocal(strPath, function(bytes)
    if not self.generateThumbMap[photoKey] then
      return
    end
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    ImageConversion.LoadImage(texture, bytes)
    FunctionTextureScale.ins:Scale(texture, coefficient or 0.1, function(scaledTexture)
      Object.DestroyImmediate(texture)
      local thumbBytes = ImageConversion.EncodeToJPG(scaledTexture)
      Object.DestroyImmediate(scaledTexture)
      local listCallback = self.generateThumbMap[photoKey]
      if not listCallback then
        return
      end
      for i = 1, #listCallback do
        listCallback[i](thumbBytes)
      end
      ReusableTable.DestroyAndClearArray(listCallback)
      self.generateThumbMap[photoKey] = nil
      self:SendDownloadFinishMsg(photoType, photoIndex, timestamp, true, thumbBytes, customParam)
    end)
  end)
  if not isExist then
    ReusableTable.DestroyAndClearArray(listOnFinish)
    self.generateThumbMap[photoKey] = nil
  end
  return isExist
end

function FunctionPhotoStorage:IsUploadFail(photoType, photoIndex)
  local photoData = PhotoDataProxy.Instance:getPhotoDataByIndex(photoIndex)
  if photoData and not photoData.isupload then
    return true
  end
end

function FunctionPhotoStorage:IsCanReUpLoading(photoType, photoID, timestamp)
  return self:FindPhotoPathFromLocal(photoType, photoID, false) ~= nil
end

function FunctionPhotoStorage:IsPhotoUploading(photoType, photoIndex, customParam)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  local photoInfoList = self.waitUploadMap[photoKey]
  if photoInfoList and 0 < #photoInfoList then
    return true
  end
  return self.uploadMap[photoKey] ~= nil or self.localSaveMap[photoKey] ~= nil
end

function FunctionPhotoStorage:IsPhotoDownloading(photoType, photoIndex, isThumb, customParam)
  local photoKey = self:GetPhotoKey(photoType, photoIndex, customParam)
  local targetMap = isThumb and self.thumbDownloadMap or self.downloadMap
  return targetMap[photoKey] ~= nil
end

function FunctionPhotoStorage:ClearCloundQuest()
  local listOnFinish
  for photoKey, questInfo in pairs(self.downloadMap) do
    listOnFinish = questInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](nil, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(questInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(questInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(questInfo)
  end
  TableUtility.TableClear(self.downloadMap)
  for photoKey, questInfo in pairs(self.thumbDownloadMap) do
    listOnFinish = questInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](nil, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(questInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(questInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(questInfo)
  end
  TableUtility.TableClear(self.thumbDownloadMap)
  for photoKey, questInfo in pairs(self.uploadMap) do
    listOnFinish = questInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](false, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(questInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(questInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(questInfo)
  end
  TableUtility.TableClear(self.uploadMap)
  for photoKey, listOnFinish in pairs(self.generateThumbMap) do
    for i = 1, #listOnFinish do
      listOnFinish[i](nil, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(listOnFinish)
  end
  TableUtility.TableClear(self.generateThumbMap)
end

function FunctionPhotoStorage.Util_ParseUrlFromThumbUrl(url)
  if BranchMgr.IsChina() then
    if string.find(url, "!100%?t=") then
      return string.gsub(url, "!100%?t=", "?t=")
    elseif string.find(url, "!100") then
      return string.gsub(url, "!100", "")
    end
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    if string.find(url, "!33%?timestamp=") then
      return string.gsub(url, "!33%?timestamp=", "?timestamp=")
    elseif string.find(url, "!33") then
      return string.gsub(url, "!33", "")
    end
  end
end
