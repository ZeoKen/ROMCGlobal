AudioPackageDownloaderHolder = class("AudioPackageDownloaderHolder")

function AudioPackageDownloaderHolder:ctor()
end

function AudioPackageDownloaderHolder.Ins()
  if AudioPackageDownloaderHolder.ins == nil then
    AudioPackageDownloaderHolder.ins = AudioPackageDownloaderHolder.new()
  end
  return AudioPackageDownloaderHolder.ins
end

function AudioPackageDownloaderHolder:DestroyAll()
  if self.npcVoiceDownload then
    for k, _ in pairs(self.npcVoiceDownload) do
      local downloader = self.npcVoiceDownload[k]
      downloader:pauseHDDownload()
      downloader:Destroy()
    end
    TableUtility.TableClear(self.npcVoiceDownload)
  end
end

function AudioPackageDownloaderHolder:GetNpcVoiceDownloader(branch)
  if not self.npcVoiceDownload then
    self.npcVoiceDownload = {}
  end
  if not self.npcVoiceDownload[branch] then
    local audioDownloader = AudioPackageDownloader.new()
    self.audioDownloader = audioDownloader
    self.avBranch = branch
    redlog(tostring(branch))
    self.npcVoiceDownload[branch] = audioDownloader
    audioDownloader:InitByExternalSEConfig(branch, "setview_npcvoice")
  end
  return self.npcVoiceDownload[branch]
end

function AudioPackageDownloaderHolder:ResetNpcVoiceDownloader(branch)
  if not self.npcVoiceDownload then
    self.npcVoiceDownload = {}
  end
  local downloader = self.npcVoiceDownload[branch]
  if downloader then
    downloader:DeleteAllLocalAV()
    downloader:pauseHDDownload()
    downloader:Destroy()
    self.npcVoiceDownload[branch] = nil
  end
  self:GetNpcVoiceDownloader(branch)
end

AudioPackageDownloader = class("AudioPackageDownloader")
autoImport("BranchMgr")
local is_2019 = true
local xdCDN = XDCDNInfo.GetAudioServerURL()
local platStr = ApplicationInfo.GetRunPlatformStr()

function AudioPackageDownloader:ctor()
  self.status = AudioHD_Status.E_Init
  self.btnStatus = AudioBtn_Status.E_None
  self.finishSize = 0
  self.totalSize = 0
  self.speed = 0
  self.leftSize = 0
  self.errorCount = 0
  self.doneSize = 0
  self.speedTimer = nil
  self.cfg_inited = false
  self.serverAudioInfo = {}
  self.localAudioInfo = {}
  self.hdDownLoaders = {}
end

function AudioPackageDownloader:InitByExternalSEConfig(branch, tag)
  local langBranch = {
    "cn",
    "jp",
    "kr"
  }
  local branchName = langBranch[branch]
  if not branchName then
    return false
  end
  local cfgPlat = platStr
  if Application.isEditor then
    cfgPlat = "Android"
  end
  local serverConfigPart = "Table_ExternalSE_" .. branchName
  if cfgPlat == "iOS" or cfgPlat == "Android" or Application.isEditor then
    autoImport(serverConfigPart .. "_" .. cfgPlat)
  else
    autoImport(serverConfigPart)
  end
  self.serverConfig = _G[serverConfigPart]
  self.prefix = "/" .. platStr .. "/resources/public/audio/se/" .. branchName .. "/"
  self.localConfigName = "LocalExternalSEConfig"
  self.localPath = ApplicationHelper.persistentDataPath .. self.prefix
  self.localConfigPath = self.localPath .. self.localConfigName .. ".txt"
  local cdnPlat = platStr
  if Application.isEditor then
    cdnPlat = "Android"
  end
  if BranchMgr.IsChina() then
    self.cdnServerTopPath = xdCDN .. string.format("/res/audio_test/external_se%s/", is_2019 and "_2019" or "") .. cdnPlat .. "/" .. branchName .. "/"
  else
    self.cdnServerTopPath = xdCDN .. string.format("/audio_test/external_se%s/", is_2019 and "_2019" or "") .. cdnPlat .. "/" .. branchName .. "/"
  end
  if BranchMgr.IsJapan() then
    self.cdnServerTopPath = xdCDN .. string.format("/external_se%s/", is_2019 and "_2019" or "") .. cdnPlat .. "/" .. branchName .. "/"
  end
  self.cfg_inited = true
  self.tag = tag
  self.branch_id = branch
  self:InitInfo()
  return true
end

function AudioPackageDownloader:InitInfo()
  self.localExist = self:LocalConfig()
  self:ServerConfig()
  if self.localExist then
    self:CheckUpdate()
  else
    self.btnStatus = AudioBtn_Status.E_NewUpdate
    self:CopyServerToLocal()
  end
  if self.totalSize - self.finishSize > 0 then
    local content2, content3
    local bytes = FileHelper.LoadFile(self.localConfigPath)
    local downloaded = false
    if bytes then
      local content = Slua.ToString(bytes)
      content = "return " .. content
      local LocalAudioConfig = loadstring(content)()
      for _, localConfig in pairs(LocalAudioConfig) do
        if localConfig.isDone == true then
          downloaded = true
          xdlog("found")
          printData(localConfig)
          break
        end
      end
    end
    if self.localExist and downloaded then
      content2 = ZhString.AudioHD_newUpdate
      content3 = ZhString.AudioHD_update
    else
      content2 = ZhString.AudioHD_initInfo
      content3 = ZhString.AudioHD_start
    end
    self:NotifyStatusInfo({hint = content2, btn = content3})
  else
    self.status = AudioHD_Status.E_Done
    self:NotifyStatusInfo()
  end
end

function AudioPackageDownloader:SwitchHDDownload()
  if self.btnStatus == AudioBtn_Status.E_NewUpdate then
    self:beginHDDownload()
    self.btnStatus = AudioBtn_Status.E_Pause
  elseif self.btnStatus == AudioBtn_Status.E_Pause then
    self:pauseHDDownload()
    self.btnStatus = AudioBtn_Status.E_Resume
  elseif self.btnStatus == AudioBtn_Status.E_Resume then
    self:resumeHDDownload()
    self.btnStatus = AudioBtn_Status.E_Pause
  end
  self:NotifyStatusInfo()
  return self.btnStatus
end

function AudioPackageDownloader:ServerConfig()
  local totalSize = 0
  for _, audioConfig in pairs(self.serverConfig) do
    totalSize = totalSize + audioConfig.fileSize
    local info = {}
    info.name = audioConfig.name
    info.md5 = audioConfig.md5
    info.fileSize = audioConfig.fileSize
    table.insert(self.serverAudioInfo, info)
  end
end

function AudioPackageDownloader:LocalConfig()
  if not FileHelper.ExistFile(self.localConfigPath) then
    if not FileHelper.ExistDirectory(self.localPath) then
      FileHelper.CreateDirectory(self.localPath)
    end
    FileHelper.CreateFile(self.localConfigPath).Dispose()
    return false
  end
  local bytes = FileHelper.LoadFile(self.localConfigPath)
  if bytes then
    local content = Slua.ToString(bytes)
    content = "return " .. content
    local LocalAudioConfig = loadstring(content)()
    for _, localConfig in pairs(LocalAudioConfig) do
      local info = self:CopyTable(localConfig)
      table.insert(self.localAudioInfo, info)
    end
    return true
  end
end

function AudioPackageDownloader:CheckUpdate()
  self.updateList = {}
  for _s, serverInfo in pairs(self.serverAudioInfo) do
    local exist = false
    for _l, localInfo in pairs(self.localAudioInfo) do
      if serverInfo.name == localInfo.name then
        if serverInfo.md5 ~= localInfo.md5 then
          localInfo.isDone = false
          local info = self:CopyTable(serverInfo)
          info.isDone = false
          table.insert(self.updateList, info)
        elseif localInfo.isDone == false then
          local info = self:CopyTable(localInfo)
          table.insert(self.updateList, info)
        end
        exist = true
        break
      end
    end
    if not exist then
      local info = self:CopyTable(serverInfo)
      info.isDone = false
      table.insert(self.updateList, info)
      table.insert(self.localAudioInfo, info)
    end
  end
  if #self.updateList > 0 then
    self.btnStatus = AudioBtn_Status.E_NewUpdate
  end
  self:CalTotalSize()
  self:MarkConfigFileDirty(true)
end

function AudioPackageDownloader:CopyServerToLocal()
  local updateList = {}
  for _, serverInfo in pairs(self.serverAudioInfo) do
    local tb = self:CopyTable(serverInfo)
    tb.isDone = false
    table.insert(updateList, tb)
    table.insert(self.localAudioInfo, tb)
  end
  self.updateList = updateList
  self:CalTotalSize()
  self:MarkConfigFileDirty(true)
  self:SaveConfigFile(self.updateList, self.localConfigName)
end

function AudioPackageDownloader:CopyTable(tb)
  local t = {}
  for k, v in pairs(tb) do
    t[k] = v
  end
  return t
end

function AudioPackageDownloader:startHDDownload()
  self.listIndex = #self.updateList
  self.listSize = self.listIndex
  if self.listIndex > 0 then
    self:OneByOne()
  else
    self:Done()
    return
  end
  self:SpeedTimer()
end

function AudioPackageDownloader:SpeedTimer()
  self.lastDownload = 0
  self.speedTimer = TimeTickManager.Me():CreateTick(0, 500, function()
    self.speed = (self.finishSize - self.lastDownload) / 0.5
    self.lastDownload = self.finishSize
    self:NotifyStatusInfo()
  end, self)
end

function AudioPackageDownloader:beginHDDownload()
  self:startHDDownload()
end

function AudioPackageDownloader:OneByOne()
  if self.listIndex <= 0 then
    self:Done()
    return
  end
  if self.hdDownLoaders == nil then
    self.hdDownLoaders = {}
  end
  local audioInfo = self.updateList[self.listIndex]
  if audioInfo and audioInfo.isDone == false then
    local server_path = self.cdnServerTopPath .. audioInfo.name
    local local_path = self.localPath .. audioInfo.name
    local local_dir = FileHelper.GetParentDirectoryPath(local_path)
    if not FileHelper.ExistDirectory(local_dir) then
      FileHelper.CreateDirectory(local_dir)
    end
    if FileHelper.ExistFile(local_path) then
      FileHelper.DeleteFile(local_path)
    end
    local m_onDownloadProgress = function(progress)
      self.finishSize = (self.listSize - self.listIndex + progress) / self.listSize * self.totalSize
    end
    local m_onDownloadSuccess = function()
      self.errorCount = 0
      self.listIndex = self.listIndex - 1
      self:finishDownload(audioInfo)
      self:OneByOne()
    end
    local m_onDownloadFail = function(err, local_path)
      if FileHelper.ExistFile(local_path) then
        FileHelper.DeleteFile(local_path)
      end
      if err == FunctionCloudFile.ErrorCode_UserCancel then
        return
      end
      self.errorCount = self.errorCount + 1
      if self.errorCount > 50 then
        Debug.LogError("err :" .. err)
        self:pauseHDDownload()
        self:NotifyStatusInfo({
          hint = ZhString.AudioHD_err
        })
      else
        self:OneByOne()
      end
    end
    if FunctionCloudFile.IsActive() then
      self.curLoadUrl = server_path
      self.curloadLocalPath = local_path
      FunctionCloudFile.Me():Download(server_path, local_path, false, m_onDownloadProgress, function(isSuccess, err)
        if isSuccess then
          m_onDownloadSuccess()
        else
          m_onDownloadFail(err, local_path)
        end
      end)
    else
      do
        local loaderId = CloudFile.CloudFileManager.Ins:Download(server_path, local_path, false, m_onDownloadProgress, m_onDownloadSuccess, function(err)
          m_onDownloadFail(err, local_path)
        end, nil)
        self.curLoadId = loaderId
        table.insert(self.hdDownLoaders, loaderId)
      end
    end
  end
end

function AudioPackageDownloader:Done()
  self.status = AudioHD_Status.E_Done
  if self.speedTimer then
    TimeTickManager.Me():ClearTick(self)
    self.speedTimer = nil
  end
  if self.localAudioInfo and #self.localAudioInfo > 0 then
    self:SaveConfigFile(self.localAudioInfo, self.localConfigName)
  end
  self:NotifyStatusInfo()
end

function AudioPackageDownloader:finishDownload(audioInfo)
  Debug.Log("finishDownload :" .. audioInfo.name)
  audioInfo.isDone = true
  if self.localAudioInfo then
    for _, v in pairs(self.localAudioInfo) do
      if v.name == audioInfo.name then
        v.md5 = audioInfo.md5
        v.isDone = true
        self.doneSize = self.doneSize + audioInfo.fileSize
      end
    end
    self:MarkConfigFileDirty(true)
  end
end

function AudioPackageDownloader:pauseHDDownload()
  if self.curLoadUrl and self.curloadLocalPath then
    FunctionCloudFile.Me():CancelDownload(self.curLoadUrl, self.curloadLocalPath)
  end
  if self.curLoadId then
    CloudFile.CloudFileManager.Ins:StopTask(self.curLoadId)
  end
  if self.speedTimer then
    TimeTickManager.Me():ClearTick(self)
    self.speedTimer = nil
  end
  if self.localAudioInfo and #self.localAudioInfo > 0 then
    self:SaveConfigFile(self.localAudioInfo, self.localConfigName)
  end
end

function AudioPackageDownloader:resumeHDDownload()
  if self.curLoadId then
    CloudFile.CloudFileManager.Ins:RestartTask(self.curLoadId)
  end
  if FunctionCloudFile.IsActive() then
    self:OneByOne()
  end
  self:SpeedTimer()
end

function AudioPackageDownloader:SendErrorInfo()
  return self.totalError
end

function AudioPackageDownloader:GetFinishSize()
  return StringUtil.ConvertFileSize(self.finishSize)
end

function AudioPackageDownloader:CalTotalSize()
  local size = 0
  for _, info in ipairs(self.updateList) do
    size = size + info.fileSize
  end
  local finishSize = 0
  local allSize = 0
  for _, info in pairs(self.localAudioInfo) do
    if info.isDone == true then
      finishSize = finishSize + info.fileSize
    end
    allSize = allSize + info.fileSize
  end
  self.doneSize = finishSize
  self.allSize = allSize
  self.totalSize = size
end

function AudioPackageDownloader:GetTotalSize()
  return StringUtil.ConvertFileSizeString(self.totalSize)
end

function AudioPackageDownloader:NotifyStatusInfo(rawinfo)
  rawinfo = rawinfo or {}
  if self.tag then
    rawinfo.tag = self.tag
  end
  if self.branch_id then
    rawinfo.branch_id = self.branch_id
  end
  rawinfo.finishPercent = self:GetPercent()
  GameFacade.Instance:sendNotification(AudioPackageDownloadEvent.OnInfoUpdate, rawinfo)
end

function AudioPackageDownloader:GetPercent()
  if self.allSize then
    return 1.0 * self.doneSize / self.allSize
  else
    return 0
  end
end

function AudioPackageDownloader:MarkConfigFileDirty(isDirty)
  self.isConfigFileDirty = isDirty
end

function AudioPackageDownloader:SaveConfigFile(targetTable, tableName, force)
  if not self.isConfigFileDirty and not force then
    return
  end
  local content = TableUtil.TableToStrEx(targetTable)
  local bytes = Slua.ToBytes(content)
  if not FileHelper.ExistFile(self.localConfigPath) then
    FileHelper.CreateDirectory(self.localPath)
  end
  FileHelper.WriteFile(self.localConfigPath, bytes)
  Game.GCSystemManager:Collect()
  self.isConfigFileDirty = false
end

function AudioPackageDownloader:DeleteAllLocalAV()
  for k, audioInfo in pairs(self.localAudioInfo) do
    audioInfo.isDone = false
    local local_path = self.localPath .. audioInfo.name
    if FileHelper.ExistFile(local_path) then
      FileHelper.DeleteFile(local_path)
    end
  end
  self:MarkConfigFileDirty(true)
end

function AudioPackageDownloader:Destroy()
  if self.localAudioInfo and #self.localAudioInfo > 0 then
    self:SaveConfigFile(self.localAudioInfo, self.localConfigName)
  end
  self.serverAudioInfo = nil
  self.localAudioInfo = nil
  self.hdDownLoaders = nil
  if self.speedTimer then
    TimeTickManager.Me():ClearTick(self)
    self.speedTimer = nil
  end
  self.status = AudioHD_Status.E_Init
  self.btnStatus = AudioBtn_Status.E_None
  self.finishSize = 0
  self.totalSize = 0
  self.speed = 0
  self.leftSize = 0
  self.errorCount = 0
  self.doneSize = 0
  if self.curLoadId then
    CloudFile.CloudFileManager.Ins:StopTask(self.curLoadId)
  end
end

return AudioPackageDownloader
