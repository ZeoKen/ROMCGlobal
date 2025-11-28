autoImport("AudioPackageDownloaderHolder")
FunctionCloudFile = class("FunctionCloudFile")
FunctionCloudFile.ErrorCode_UserCancel = "user cancel"
FunctionCloudFile.ErrorCode_Md5Error = "md5 error"
FunctionCloudFile.ErrorCode_TimeOut = "time out"
FunctionCloudFile.ErrorCode_WriteFileError = "write file error"
FunctionCloudFile.ErrorCode_RequestRefused = "request refused"
FunctionCloudFile.MaxLocalLoadCount = 15
local m_minRequestInterval = 3
local m_maxRefuseCount = 5

function FunctionCloudFile.Me()
  if nil == FunctionCloudFile.me then
    FunctionCloudFile.me = FunctionCloudFile.new()
  end
  return FunctionCloudFile.me
end

function FunctionCloudFile.IsActive()
  if FunctionCloudFile.IsForbid == nil then
    FunctionCloudFile.IsForbid = BackwardCompatibilityUtil.CompatibilityMode_V51
  end
  return not FunctionCloudFile.IsForbid
end

function FunctionCloudFile:ctor()
  self:Init()
end

function FunctionCloudFile:Init()
  self.listLocalAssets = {}
  self.downloadMap = {}
  self.uploadMap = {}
  self.requestTimeRecord = {}
  self.requestRefuseRecord = {}
  self.localLoadWaitList = {}
  self.localLoadMap = {}
  self.curLocalLoadQuestNum = 0
  self.waitCancelUrlMap = {}
  self.waitCancelPathMap = {}
  CloudFile.CloudManager.Ins.nMaxDownloadCount = 5
end

function FunctionCloudFile:Download(strUrl, strPath, md5Check, funcOnProgress, funcOnFinish)
  if not FunctionCloudFile.IsActive() then
    return
  end
  local key = self:GetQuestKey(strUrl, strPath)
  if self.requestTimeRecord[key] and ServerTime.CurServerTime() - self.requestTimeRecord[key] < m_minRequestInterval then
    local refuseCount = (self.requestRefuseRecord[key] or 0) + 1
    self.requestRefuseRecord[key] = refuseCount
    if refuseCount < m_maxRefuseCount then
      if funcOnFinish then
        FunctionUtility.Me():DelayCall(function()
          funcOnFinish(nil, FunctionCloudFile.ErrorCode_RequestRefused)
        end)
      end
    else
      LogUtility.Error("Refused download because frequency is too high: " .. key)
    end
    return
  end
  local curDownloadInfo = self.downloadMap[key]
  local isDownloading = curDownloadInfo ~= nil
  if not curDownloadInfo then
    curDownloadInfo = ReusableTable.CreateTable()
    curDownloadInfo.listOnProgress = ReusableTable.CreateArray()
    curDownloadInfo.listOnFinish = ReusableTable.CreateArray()
    self.downloadMap[key] = curDownloadInfo
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
  CloudFile.CloudManager.Ins:Download(strUrl, strPath, md5Check, function(progress)
    if not self.downloadMap[key] then
      return
    end
    local listOnProgress = curDownloadInfo.listOnProgress
    for i = 1, #listOnProgress do
      listOnProgress[i](progress)
    end
  end, function()
    self.waitCancelUrlMap[key] = nil
    self.waitCancelPathMap[key] = nil
    if not self.downloadMap[key] then
      return
    end
    self.downloadMap[key] = nil
    self.requestTimeRecord[key] = ServerTime.CurServerTime()
    self.requestRefuseRecord[key] = 0
    local listOnFinish = curDownloadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback is already removed!")
      return
    end
    for i = 1, #listOnFinish do
      listOnFinish[i](true)
    end
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curDownloadInfo)
  end, function(errorMsg)
    self.waitCancelUrlMap[key] = nil
    self.waitCancelPathMap[key] = nil
    if not self.downloadMap[key] then
      return
    end
    self.downloadMap[key] = nil
    self.requestTimeRecord[key] = ServerTime.CurServerTime()
    self.requestRefuseRecord[key] = 0
    local listOnFinish = curDownloadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback is already removed!")
      return
    end
    for i = 1, #listOnFinish do
      listOnFinish[i](false, errorMsg)
    end
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curDownloadInfo)
  end)
end

function FunctionCloudFile:FormUpload(strUrl, strPath, formUploadData, funcOnProgress, funcOnFinish)
  if not FunctionCloudFile.IsActive() then
    return
  end
  local key = self:GetQuestKey(strUrl, strPath)
  if self.requestTimeRecord[key] and ServerTime.CurServerTime() - self.requestTimeRecord[key] < m_minRequestInterval then
    local refuseCount = (self.requestRefuseRecord[key] or 0) + 1
    self.requestRefuseRecord[key] = refuseCount
    if refuseCount < m_maxRefuseCount then
      if funcOnFinish then
        FunctionUtility.Me():DelayCall(function()
          funcOnFinish(false, FunctionCloudFile.ErrorCode_RequestRefused)
        end)
      end
    else
      LogUtility.Error("Refused download because frequency is too high: " .. key)
    end
    return
  end
  local curUploadInfo = self.uploadMap[key]
  local isUploading = curUploadInfo ~= nil
  if not curUploadInfo then
    curUploadInfo = ReusableTable.CreateTable()
    curUploadInfo.listOnProgress = ReusableTable.CreateArray()
    curUploadInfo.listOnFinish = ReusableTable.CreateArray()
    self.uploadMap[key] = curUploadInfo
  end
  if funcOnProgress then
    curUploadInfo.listOnProgress[#curUploadInfo.listOnProgress + 1] = funcOnProgress
  end
  if funcOnFinish then
    curUploadInfo.listOnFinish[#curUploadInfo.listOnFinish + 1] = funcOnFinish
  end
  if isUploading then
    return
  end
  CloudFile.CloudManager.Ins:FormUpload(strUrl, formUploadData, function(progress)
    if not self.uploadMap[key] then
      return
    end
    local listOnProgress = curUploadInfo.listOnProgress
    for i = 1, #listOnProgress do
      listOnProgress[i](progress)
    end
  end, function()
    if not self.uploadMap[key] then
      return
    end
    self.uploadMap[key] = nil
    self.requestTimeRecord[key] = ServerTime.CurServerTime()
    self.requestRefuseRecord[key] = 0
    local listOnFinish = curUploadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback is already removed!")
      return
    end
    for i = 1, #listOnFinish do
      listOnFinish[i](true)
    end
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curUploadInfo)
  end, function(errorMsg)
    if not self.uploadMap[key] then
      return
    end
    self.uploadMap[key] = nil
    self.requestTimeRecord[key] = ServerTime.CurServerTime()
    self.requestRefuseRecord[key] = 0
    local listOnFinish = curUploadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback is already removed!")
      return
    end
    for i = 1, #listOnFinish do
      listOnFinish[i](false, errorMsg)
    end
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curUploadInfo)
  end)
end

function FunctionCloudFile:ClearQuestTimeRecord(strUrl, strPath)
  local key = self:GetQuestKey(strUrl, strPath)
  self.requestTimeRecord[key] = nil
  self.requestRefuseRecord[key] = nil
end

function FunctionCloudFile:IsDownloading(questKey)
  return (questKey and self.downloadMap[questKey]) ~= nil
end

function FunctionCloudFile:IsUploading(questKey)
  return (questKey and self.uploadMap[questKey]) ~= nil
end

function FunctionCloudFile:GetQuestKey(strUrl, strPath)
  return strUrl .. strPath
end

function FunctionCloudFile:CancelDownload(strUrl, strPath)
  if not FunctionCloudFile.IsActive() then
    return
  end
  local questKey = self:GetQuestKey(strUrl, strPath)
  if not self.downloadMap[questKey] then
    return
  end
  CloudFile.CloudManager.Ins:CancelDownload(strUrl, strPath)
  self.waitCancelUrlMap[questKey] = strUrl
  self.waitCancelPathMap[questKey] = strPath
  local questInfo = self.downloadMap[questKey]
  if questInfo then
    local listOnFinish = questInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](false, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(questInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(questInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(questInfo)
  end
  self.downloadMap[questKey] = nil
  TimeTickManager.Me():CreateTick(500, 500, self.UpdateCancelDownload, self, 2, nil, 20)
end

function FunctionCloudFile:CancelUpload(strUrl, strPath)
  if not FunctionCloudFile.IsActive() then
    return
  end
  if not self.uploadMap[self:GetQuestKey(strUrl, strPath)] then
    return
  end
  CloudFile.CloudManager.Ins:CancelUpload(strUrl, strPath)
end

function FunctionCloudFile:LoadFromLocal(strPath, funcOnFinish)
  local waitData = self.localLoadMap[strPath]
  if waitData then
    waitData.onFinish[#waitData.onFinish + 1] = funcOnFinish
    return true
  end
  if not FileHelper.ExistFile(strPath) then
    return false
  end
  waitData = ReusableTable.CreateTable()
  waitData.path = strPath
  waitData.onFinish = ReusableTable.CreateArray()
  waitData.onFinish[#waitData.onFinish + 1] = funcOnFinish
  self.localLoadWaitList[#self.localLoadWaitList + 1] = waitData
  self.localLoadMap[strPath] = waitData
  self:StartLoadFromLocal()
  return true
end

function FunctionCloudFile:StartLoadFromLocal()
  if self.curLocalLoadQuestNum >= FunctionCloudFile.MaxLocalLoadCount or #self.localLoadWaitList < 1 then
    return
  end
  local waitData = table.remove(self.localLoadWaitList, 1)
  self.curLocalLoadQuestNum = self.curLocalLoadQuestNum + 1
  DiskFileManager.Instance:LoadFileAsync(waitData.path, ServerTime.CurServerTime() / 1000, function(bytes)
    self.localLoadMap[waitData.path] = nil
    for i = 1, #waitData.onFinish do
      waitData.onFinish[i](bytes)
    end
    ReusableTable.DestroyAndClearArray(waitData.onFinish)
    ReusableTable.DestroyAndClearTable(waitData)
    self.curLocalLoadQuestNum = self.curLocalLoadQuestNum - 1
    self:StartLoadFromLocal()
  end)
end

function FunctionCloudFile:UpdateCancelDownload()
  local haveValue = false
  for questKey, strUrl in pairs(self.waitCancelUrlMap) do
    haveValue = true
    local strPath = self.waitCancelPathMap[questKey]
    if strPath then
      CloudFile.CloudManager.Ins:CancelDownload(strUrl, strPath)
    else
      self.waitCancelUrlMap[questKey] = nil
    end
  end
  if not haveValue then
    TimeTickManager.Me():ClearTick(self, 2)
  end
end

function FunctionCloudFile:SaveToLocal(strPath, bytes, funcOnFinish)
  DiskFileManager.Instance:SaveFile(strPath, bytes, ServerTime.CurServerTime() / 1000, funcOnFinish)
end

function FunctionCloudFile:Clear()
  if not FunctionCloudFile.IsActive() then
    return
  end
  TimeTickManager.Me():ClearTick(self)
  CloudFile.CloudManager.Ins:Clear()
  local listOnFinish
  for questKey, questInfo in pairs(self.downloadMap) do
    listOnFinish = questInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](false, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(questInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(questInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(questInfo)
  end
  TableUtility.TableClear(self.downloadMap)
  for questKey, questInfo in pairs(self.uploadMap) do
    listOnFinish = questInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](false, FunctionCloudFile.ErrorCode_UserCancel)
    end
    ReusableTable.DestroyAndClearArray(questInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(questInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(questInfo)
  end
  TableUtility.TableClear(self.uploadMap)
  TableUtility.TableClear(self.requestTimeRecord)
  TableUtility.TableClear(self.requestRefuseRecord)
  TableUtility.TableClear(self.waitCancelUrlMap)
  TableUtility.TableClear(self.waitCancelPathMap)
  FunctionPhotoStorage.Me():ClearCloundQuest()
  FunctionVideoStorage.Me():ClearCloundQuest()
  AudioPackageDownloaderHolder.Ins():DestroyAll()
end

function FunctionCloudFile:log(...)
  if FunctionCloudFile.isEnableLog then
    helplog(...)
  end
end
