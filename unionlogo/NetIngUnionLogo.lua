autoImport("PhotoFileInfo")
NetIngUnionLogo = class("NetIngUnionLogo")
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}
local thumbnailVersionName = "Percent25"

function NetIngUnionLogo.Ins()
  if NetIngUnionLogo.ins == null then
    NetIngUnionLogo.ins = NetIngUnionLogo.new()
  end
  return NetIngUnionLogo.ins
end

function NetIngUnionLogo:Initialize()
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.StopOnBackToLogo, self)
  if not BranchMgr.IsTW() and not BranchMgr.IsJapan() then
    EventManager.Me():AddEventListener(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, self.OnReceiveGuildIconUploadGuildCmd, self)
  else
    helplog("NetIngUnionLogo:Initialize")
    EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, self.OnRecvOverseasPhotoUploadCmd, self)
  end
  self.stopFormUploadFlag = {}
end

function NetIngUnionLogo:Download(union_id, pos_index, photo_id, timestamp, extension, progress_callback, success_callback, error_callback, o_or_t)
  if self.netIngTerminated then
    return
  end
  local tempDownloadRootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadRootPathOfLocal()
  if not FileHelper.ExistDirectory(tempDownloadRootPath) then
    FileHelper.CreateDirectory(tempDownloadRootPath)
  end
  local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadPathOfLocal(photo_id, o_or_t, extension)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  if table.ContainsKey(gCachedDownloadTaskRecordID, key) then
    local taskRecordID = gCachedDownloadTaskRecordID[key]
    if self:IsDownloading(photo_id, o_or_t) then
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
    else
      if FileHelper.ExistFile(path) then
        FileHelper.DeleteFile(path)
      end
      local fileServerURL = XDCDNInfo.GetFileServerURL()
      local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
      if not BranchMgr.IsTW() and not BranchMgr.IsJapan() and not BranchMgr.IsNOEN() then
        taskRecord.URL = fileServerURL .. "/" .. self:GetPathOfServer(union_id, pos_index, extension) .. (o_or_t and "" or "!" .. thumbnailVersionName) .. "?t=" .. timestamp
      else
        taskRecord.URL = fileServerURL .. "/" .. self:GetPathOfServer(union_id, pos_index, extension) .. "?t=" .. timestamp
      end
      CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
      CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
    end
  else
    if FileHelper.ExistFile(path) then
      FileHelper.DeleteFile(path)
    end
    local fileServerURL = XDCDNInfo.GetFileServerURL()
    local url
    if not BranchMgr.IsTW() and not BranchMgr.IsJapan() then
      url = fileServerURL .. "/" .. self:GetPathOfServer(union_id, pos_index, extension) .. (o_or_t and "" or "!" .. thumbnailVersionName) .. "?t=" .. timestamp
    else
      url = fileServerURL .. "/" .. self:GetPathOfServer(union_id, pos_index, extension) .. "?t=" .. timestamp
    end
    local taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback, nil)
    if 0 < taskRecordID then
      gCachedDownloadTaskRecordID[key] = taskRecordID
    end
  end
end

function NetIngUnionLogo:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.None or taskRecord.State == CloudFile.E_TaskState.Progress
  end
  return false
end

function NetIngUnionLogo:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end

local operatorName = "roxdcdn"
local formUploadCallbacks = {}

function NetIngUnionLogo:FormUpload(pos_index, photo_id, extension, progress_callback, success_callback, error_callback)
  formUploadCallbacks[pos_index] = {
    photoID = photo_id,
    extension = extension,
    progressCallback = progress_callback,
    successCallback = success_callback,
    errorCallback = error_callback
  }
  if not BranchMgr.IsTW() and not BranchMgr.IsJapan() then
    ServiceGuildCmdProxy.Instance:CallGuildIconUploadGuildCmd(pos_index, nil, nil, extension)
  else
    ServiceOverseasTaiwanCmdProxy.Instance:GetUpLoadSign(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_GUILDICON, pos_index)
  end
  self.stopFormUploadFlag[photo_id] = false
end

function NetIngUnionLogo:OnRecvOverseasPhotoUploadCmd(message)
  helplog("NetIngUnionLogo:OnRecvOverseasPhotoUploadCmd")
  local path = message.path
  local eType = string.split(path, "/")[2]
  if eType == "icon" then
    local photoId = message.photoId
    local result = OverseaHostHelper:GenUpLoadSignObj(message.fields)
    if not self.stopFormUploadFlag[photoId] then
      self:OverseaDoFormUpload(photoId, result.signObj, result.uploadUrl, formUploadCallbacks[photoId].progressCallback, formUploadCallbacks[photoId].successCallback, formUploadCallbacks[photoId].errorCallback)
    end
    formUploadCallbacks[photoId] = nil
  end
end

function NetIngUnionLogo:OverseaDoFormUpload(photo_id, signObj, url, progress_callback, success_callback, error_callback)
  if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
    local taskRecordID = gCachedUploadTaskRecordID[photo_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(UnionLogo.Ins():GetUnionID() .. "_" .. photo_id, formUploadCallbacks[photo_id].extension)
    local taskRecordID = CloudFile.CloudFileManager.Ins:NormalUploadGoogleStorage(path, url, signObj, progress_callback, success_callback, error_callback)
    if 0 < taskRecordID then
      gCachedUploadTaskRecordID[photo_id] = taskRecordID
    end
  end
end

function NetIngUnionLogo:OnReceiveGuildIconUploadGuildCmd(message)
  local eType = message.type
  local posIndex = message.index
  local photoID = formUploadCallbacks[posIndex].photoID
  local extension = formUploadCallbacks[posIndex].extension
  if not self.stopFormUploadFlag[photoID] then
    local policy = message.policy
    local signature = message.signature
    local authorization = "UPYUN " .. operatorName .. ":" .. signature
    self:DoFormUpload(photoID, extension, policy, authorization, formUploadCallbacks[posIndex].progressCallback, formUploadCallbacks[posIndex].successCallback, formUploadCallbacks[posIndex].errorCallback)
  end
  formUploadCallbacks[posIndex] = nil
end

function NetIngUnionLogo:DoFormUpload(photo_id, extension, policy, authorization, progress_callback, success_callback, error_callback)
  if self.netIngTerminated then
    return
  end
  if table.ContainsKey(gCachedUploadTaskRecordID, photo_id) then
    local taskRecordID = gCachedUploadTaskRecordID[photo_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(photo_id, extension)
    local url = UpyunInfo.GetFormUploadURL()
    local taskRecordID = CloudFile.CloudFileManager.Ins:FormUpload(path, url, policy, authorization, progress_callback, success_callback, error_callback, nil)
    if 0 < taskRecordID then
      gCachedUploadTaskRecordID[photo_id] = taskRecordID
    end
  end
end

function NetIngUnionLogo:StopFormUpload(photo_id)
  self.stopFormUploadFlag[photo_id] = true
  local taskRecordID = gCachedUploadTaskRecordID[photo_id]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end

function NetIngUnionLogo:SetUnionPathOfServer(union_path)
  self.unionPathOfServer = union_path
end

function NetIngUnionLogo:GetPathOfServer(union_id, pos_index, extension)
  if not BranchMgr.IsTW() and not BranchMgr.IsJapan() then
    return self.unionPathOfServer .. "/" .. union_id .. "/" .. pos_index .. "." .. extension
  end
  return self.unionPathOfServer .. union_id .. "/" .. pos_index .. "." .. extension
end

function NetIngUnionLogo:GetTempDownloadRootPathOfLocal()
  return "TempUsedToDownloadUnionLogo"
end

function NetIngUnionLogo:GetTempDownloadPathOfLocal(photo_id, o_or_t, extension)
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. extension
end

function NetIngUnionLogo:GetTempUploadRootPathOfLocal()
  return "TempUsedToUploadUnionLogo"
end

function NetIngUnionLogo:GetTempUploadPathOfLocal(photo_id, extension)
  return self:GetTempUploadRootPathOfLocal() .. "/" .. photo_id .. "." .. extension
end

function NetIngUnionLogo:StopOnBackToLogo()
  self.netIngTerminated = 1
  for _k, v in pairs(gCachedDownloadTaskRecordID) do
    CloudFile.CloudFileManager.Ins:StopTask(v)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(v)
  end
  for _k, v in pairs(gCachedUploadTaskRecordID) do
    CloudFile.CloudFileManager.Ins:StopTask(v)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(v)
  end
end
