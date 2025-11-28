AudioHD = class("AudioHD")
autoImport("BranchMgr")
AudioHD_Status = {
  E_Init = 1,
  E_PullUpdateList = 2,
  E_CompMd5 = 3,
  E_AddToLocalList = 4,
  E_Download = 5,
  E_Done = 9999
}
AudioBtn_Status = {
  E_None = 0,
  E_NewUpdate = 1,
  E_Pause = 2,
  E_Resume = 4,
  E_Done = 999
}
local xdCDN = XDCDNInfo.GetAudioServerURL()
local platStr = ApplicationInfo.GetRunPlatformStr()
local prefix = "/" .. platStr .. "/resources/public/audio/bgm_hd/"
if Application.isEditor then
  platStr = "Android"
end
if platStr == "iOS" or platStr == "Android" or Application.isEditor then
  autoImport("Table_AudioConfig_" .. platStr)
else
  autoImport("Table_AudioConfig")
end

function AudioHD:ctor()
  self.status = AudioHD_Status.E_Init
  self.btnStatus = AudioBtn_Status.E_None
  self.finishSize = 0
  self.totalSize = 0
  self.speed = 0
  self.leftSize = 0
  self.errorCount = 0
  self.speedTimer = nil
  self.prefix = prefix
  self.localPath = ApplicationHelper.persistentDataPath .. self.prefix
  self.localConfigPath = self.localPath .. "LocalAudioConfig.txt"
  self.serverAudioInfo = {}
  self.localAudioInfo = {}
  self.hdDownLoaders = {}
  self.doneSize = 0
  self.allSize = 0
end

function AudioHD:InitInfo()
  self.localExist = self:LocalConfig()
  self:ServerConfig()
  if self.localExist then
    self:CheckUpdate()
  else
    self.btnStatus = AudioBtn_Status.E_NewUpdate
    self:CopyServerToLocal()
  end
  local delta = self.totalSize - self.finishSize
  local content1 = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(delta))
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel1, content1)
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
    self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
    self:SendNotify(AudioHDEvent.OnReceiveAudioBtn3, content3)
  else
    self.status = AudioHD_Status.E_Done
    local content2 = ZhString.AudioHD_allDone
    self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
    local content3 = ZhString.AudioHD_done
    self:SendNotify(AudioHDEvent.OnReceiveAudioBtn3, content3)
  end
end

function AudioHD:SendNotify(notifyType, content)
  local body = {}
  body.info = content
  body.finishPercent = self:GetPercent()
  GameFacade.Instance:sendNotification(notifyType, body)
end

function AudioHD:SwitchHDDownload()
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
  return self.btnStatus
end

function AudioHD:ServerConfig()
  local totalSize = 0
  for _, audioConfig in pairs(Table_AudioConfig) do
    totalSize = totalSize + audioConfig.fileSize
    local info = {}
    info.name = audioConfig.name
    info.md5 = audioConfig.md5
    info.fileSize = audioConfig.fileSize
    table.insert(self.serverAudioInfo, info)
  end
end

function AudioHD:LocalConfig()
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

function AudioHD:CheckUpdate()
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
end

function AudioHD:CopyServerToLocal()
  local updateList = {}
  for _, serverInfo in pairs(self.serverAudioInfo) do
    local tb = self:CopyTable(serverInfo)
    tb.isDone = false
    table.insert(updateList, tb)
    table.insert(self.localAudioInfo, tb)
  end
  self.updateList = updateList
  self:CalTotalSize()
  self:SaveConfigFile(self.updateList, "LocalAudioConfig")
end

function AudioHD:CopyTable(tb)
  local t = {}
  for k, v in pairs(tb) do
    t[k] = v
  end
  return t
end

function AudioHD:startHDDownload()
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

function AudioHD:SpeedTimer()
  self.lastDownload = 0
  self.speedTimer = TimeTickManager.Me():CreateTick(0, 500, function()
    self.speed = (self.finishSize - self.lastDownload) / 0.5
    self.lastDownload = self.finishSize
    self:SendProgressNotify()
  end, self)
end

function AudioHD:beginHDDownload()
  self:startHDDownload()
end

function AudioHD:OneByOne()
  if self.listIndex <= 0 then
    self:Done()
    return
  end
  if self.hdDownLoaders == nil then
    self.hdDownLoaders = {}
  end
  local audioInfo = self.updateList[self.listIndex]
  if audioInfo and audioInfo.isDone == false then
    local plat = ApplicationInfo.GetRunPlatformStr()
    if plat == "Windows" then
      plat = "Android/"
    else
      plat = plat .. "/"
    end
    if Application.isEditor then
      plat = "Android/"
    end
    local server_path = xdCDN .. "/audio_test/audio_hd_2019/" .. plat .. audioInfo.name
    if BranchMgr.IsJapan() then
      server_path = xdCDN .. "/audio_hd/" .. plat .. audioInfo.name
    end
    local local_path = self.localPath .. audioInfo.name
    if FileHelper.ExistFile(local_path) then
      FileHelper.DeleteFile(local_path)
    end
    local m_onDownloadProgress = function(progress)
      self.finishSize = (self.listSize - self.listIndex + progress) / self.listSize * self.totalSize
    end
    local m_onDownloadSuccess = function()
      self.errorCount = 0
      self:finishDownload(self.updateList[self.listIndex])
      self.listIndex = self.listIndex - 1
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
        local content2 = ZhString.AudioHD_err
        self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
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

function AudioHD:Done()
  self.status = AudioHD_Status.E_Done
  if self.speedTimer then
    TimeTickManager.Me():ClearTick(self)
    self.speedTimer = nil
  end
  local content1 = string.format(ZhString.AudioHD_inProgress, "0MB")
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel1, content1)
  local content2 = ZhString.AudioHD_allDone
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
  local content3 = ZhString.AudioHD_done
  self:SendNotify(AudioHDEvent.OnReceiveAudioBtn3, content3)
end

function AudioHD:finishDownload(audioInfo)
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
    self:SaveConfigFile(self.localAudioInfo, "LocalAudioConfig")
  end
end

function AudioHD:SendProgressNotify()
  local content1 = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(self.totalSize - self.finishSize))
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel1, content1)
  if self.speed <= 0 then
    self.speed = 0
  end
  local content2 = string.format(ZhString.AudioHD_progressSpeed, StringUtil.ConvertFileSizeString(self.speed)) .. "/s"
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
end

function AudioHD:pauseHDDownload()
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
  self.status = AudioHD_Status.E_Download
  local content2 = ZhString.AudioHD_ingResume
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
  local content3 = ZhString.AudioHD_resume
  self:SendNotify(AudioHDEvent.OnReceiveAudioBtn3, content3)
end

function AudioHD:resumeHDDownload()
  if self.curLoadId then
    CloudFile.CloudFileManager.Ins:RestartTask(self.curLoadId)
  end
  if FunctionCloudFile.IsActive() then
    self:OneByOne()
  end
  self:SpeedTimer()
  local content1 = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(self.totalSize - self.finishSize))
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel1, content1)
  local content2 = string.format(ZhString.AudioHD_progressSpeed, StringUtil.ConvertFileSizeString(self.speed)) .. "/s"
  self:SendNotify(AudioHDEvent.OnReceiveAudioLabel2, content2)
  local content3 = ZhString.AudioHD_pause
  self:SendNotify(AudioHDEvent.OnReceiveAudioBtn3, content3)
end

function AudioHD:SendErrorInfo()
  return self.totalError
end

function AudioHD:GetFinishSize()
  return StringUtil.ConvertFileSize(self.finishSize)
end

function AudioHD:CalTotalSize()
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

function AudioHD:GetTotalSize()
  return StringUtil.ConvertFileSizeString(self.totalSize)
end

function AudioHD:GetPercent()
  if self.allSize == 0 then
    return 0
  end
  return 1.0 * self.doneSize / self.allSize
end

function AudioHD:SaveConfigFile(targetTable, tableName)
  local content = TableUtil.TableToStrEx(targetTable)
  local bytes = Slua.ToBytes(content)
  if not FileHelper.ExistFile(self.localConfigPath) then
    FileHelper.CreateDirectory(self.localPath)
  end
  FileHelper.WriteFile(self.localConfigPath, bytes)
end

function AudioHD:DeleteAllLocalHD()
  for k, audioInfo in pairs(self.localAudioInfo) do
    audioInfo.isDone = false
    local local_path = self.localPath .. audioInfo.name
    if FileHelper.ExistFile(local_path) then
      FileHelper.DeleteFile(local_path)
    end
  end
end

function AudioHD:Destroy()
  if self.localAudioInfo and #self.localAudioInfo > 0 then
    self:SaveConfigFile(self.localAudioInfo, "LocalAudioConfig")
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

return AudioHD
