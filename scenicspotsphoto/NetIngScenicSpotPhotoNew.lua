autoImport("PhotoFileInfo")
autoImport("GamePhoto")
NetIngScenicSpotPhotoNew = class("NetIngScenicSpotPhotoNew", NetIngScenicSpotPhoto)
local gCachedDownloadTaskRecordID = {}
local gCachedUploadTaskRecordID = {}

function NetIngScenicSpotPhotoNew.Ins()
  if NetIngScenicSpotPhotoNew.ins == null then
    NetIngScenicSpotPhotoNew.ins = NetIngScenicSpotPhotoNew.new()
  end
  return NetIngScenicSpotPhotoNew.ins
end

function NetIngScenicSpotPhotoNew:Initialize()
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.StopOnBackToLogo, self)
  if BranchMgr.IsChina() or BranchMgr.IsTW() then
    EventManager.Me():AddEventListener(ServiceEvent.NUserUploadSceneryPhotoUserCmd, self.OnReceiveUploadSceneryPhotoUserCmd, self)
  else
    EventManager.Me():AddEventListener(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, self.OnRecvOverseasPhotoUploadCmd, self)
  end
  self.stopFormUploadFlag = {}
  self.tabIsExist = {}
end

function NetIngScenicSpotPhotoNew:Download(role_id, scenic_spot_id, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t, extension)
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
      if BranchMgr.IsChina() then
        taskRecord.URL = fileServerURL .. "/" .. self:GetPathOfServer(scenic_spot_id, extension) .. (o_or_t and "" or "!100") .. (0 < timestamp and "?t=" .. timestamp or "")
      else
        taskRecord.URL = fileServerURL .. "/" .. self:GetPathOfServer(scenic_spot_id, extension)
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
    if BranchMgr.IsChina() then
      url = fileServerURL .. "/" .. self:GetPathOfServerWithRoleID(role_id, scenic_spot_id, extension) .. (o_or_t and "" or "!100") .. (0 < timestamp and "?t=" .. timestamp or "")
    else
      url = fileServerURL .. "/" .. self:GetPathOfServerWithRoleID(role_id, scenic_spot_id, extension)
    end
    local taskRecordID
    taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback, nil)
    if 0 < taskRecordID then
      gCachedDownloadTaskRecordID[key] = taskRecordID
    end
  end
end

function NetIngScenicSpotPhotoNew:DownloadNew(scenic_spot_id, photo_id, timestamp, progress_callback, success_callback, error_callback, o_or_t)
  if self.netIngTerminated then
    return
  end
  local tempDownloadRootPath = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadRootPathOfLocal()
  if not FileHelper.ExistDirectory(tempDownloadRootPath) then
    FileHelper.CreateDirectory(tempDownloadRootPath)
  end
  local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempDownloadPathOfLocal(photo_id, o_or_t)
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
      local newURL
      if BranchMgr.IsChina() then
        newURL = fileServerURL .. "/" .. self:GetPathOfServerNew(scenic_spot_id) .. (o_or_t and "" or "!100") .. (0 < timestamp and "?t=" .. timestamp or "")
      else
        newURL = fileServerURL .. "/" .. self:GetPathOfServerNew(scenic_spot_id)
        if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
          newURL = o_or_t and newURL or newURL .. "!33"
          newURL = newURL .. "?timestamp=" .. timestamp
        end
      end
      helplog("DownloadNew newURL" .. newURL)
      local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
      taskRecord.URL = newURL
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
    if BranchMgr.IsChina() then
      url = fileServerURL .. "/" .. self:GetPathOfServerNew(scenic_spot_id) .. (o_or_t and "" or "!100") .. (0 < timestamp and "?t=" .. timestamp or "")
    else
      url = fileServerURL .. "/" .. self:GetPathOfServerNew(scenic_spot_id)
      if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
        url = o_or_t and url or url .. "!33"
        url = url .. "?timestamp=" .. timestamp
      end
    end
    helplog("DownloadNew url" .. url)
    local taskRecordID
    taskRecordID = CloudFile.CloudFileManager.Ins:Download(url, path, false, progress_callback, success_callback, error_callback, nil)
    if 0 < taskRecordID then
      gCachedDownloadTaskRecordID[key] = taskRecordID
    end
  end
end

function NetIngScenicSpotPhotoNew:IsDownloading(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    return taskRecord.State == CloudFile.E_TaskState.Progress or taskRecord.State == CloudFile.E_TaskState.None
  end
  return false
end

function NetIngScenicSpotPhotoNew:StopDownload(photo_id, o_or_t)
  local key = photo_id .. "_" .. (o_or_t and "o" or "t")
  local taskRecordID = gCachedDownloadTaskRecordID[key]
  if taskRecordID ~= nil then
    CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
  end
end

function NetIngScenicSpotPhotoNew:Upload(scenic_spot_id, progress_callback, success_callback, error_callback)
  if self.netIngTerminated then
    return
  end
  if table.ContainsKey(gCachedUploadTaskRecordID, scenic_spot_id) then
    local taskRecordID = gCachedUploadTaskRecordID[scenic_spot_id]
    local taskRecord = CloudFile.CloudFileManager.Ins._TaskRecordCenter:GetTaskRecord(taskRecordID)
    if taskRecord.State == CloudFile.E_TaskState.Progress then
      CloudFile.CloudFileManager.Ins:StopTask(taskRecordID)
    end
    CloudFile.CloudFileManager.Ins:RestartTask(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:UnregisterCallback(taskRecordID)
    CloudFile.CloudFileManager.Ins._CloudFileCallbacks:RegisterCallback(taskRecordID, progress_callback, success_callback, error_callback)
  else
    local path = ApplicationHelper.persistentDataPath .. "/" .. self:GetTempUploadPathOfLocal(scenic_spot_id)
    if BranchMgr.IsChina() then
      local url = UpyunInfo.GetNormalUploadURL() .. "/" .. self:GetPathOfServerNew(scenic_spot_id)
      local taskRecordID
      taskRecordID = CloudFile.CloudFileManager.Ins:NormalUpload(path, url, progress_callback, success_callback, error_callback, nil)
      if 0 < taskRecordID then
        gCachedUploadTaskRecordID[scenic_spot_id] = taskRecordID
      end
    elseif BranchMgr.IsTW() then
      ServiceOverseasTaiwanCmdProxy.Instance:GetUpLoadSign(OverseasTaiwanCmd_pb.ENUM_GALLERY_TYPE_SCENERY, scenic_spot_id, function(data)
        local result = OverseaHostHelper:GenUpLoadSignObj(data.fields)
        local taskRecordID = CloudFile.CloudFileManager.Ins:NormalUploadGoogleStorage(path, result.uploadUrl, result.signObj, progress_callback, success_callback, error_callback)
        if 0 < taskRecordID then
          gCachedUploadTaskRecordID[scenic_spot_id] = taskRecordID
        end
      end)
    else
      self:FormUpload(scenic_spot_id, progress_callback, success_callback, error_callback)
    end
  end
end

function NetIngScenicSpotPhotoNew:SetUserPathOfServerNew(user_path)
  self.userPathOfServerNew = user_path
end

function NetIngScenicSpotPhotoNew:GetPathOfServerNew(scenic_spot_id)
  local the_account_id = GamePhoto.playerAccount
  if BranchMgr.IsKorea() and EnvChannel.IsReleaseBranch() and FunctionLogin.Me():getCurServerDataSid() == 82002 then
    the_account_id = GamePhoto.playerSdkUid or 0
  end
  return self.userPathOfServerNew .. "/" .. the_account_id .. "/" .. scenic_spot_id .. "." .. PhotoFileInfo.Extension
end

function NetIngScenicSpotPhotoNew:GetTempDownloadPathOfLocal(photo_id, o_or_t, pExtension)
  local extension = PhotoFileInfo.Extension
  if pExtension ~= nil then
    extension = pExtension
  end
  return self:GetTempDownloadRootPathOfLocal() .. "/" .. photo_id .. "_" .. (o_or_t and "o" or "t") .. "." .. extension
end

function NetIngScenicSpotPhotoNew:StopOnBackToLogo()
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
