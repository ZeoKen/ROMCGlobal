FunctionVideoStorage = class("FunctionVideoStorage")
autoImport("PreVideoPanel")
local m_divideChar = "!"
FunctionVideoStorage.DivideCharacter = m_divideChar
FunctionVideoStorage.CloudQuestKeyDiviver = "~~~"
FunctionVideoStorage.OnVideoDownloadProgress = "FunctionVideoStorage_OnVideoDownloadProgress"
FunctionVideoStorage.OnVideoDownloadFinish = "FunctionVideoStorage_OnVideoDownloadFinish"
FunctionVideoStorage.OnVideoUploadProgress = "FunctionVideoStorage_OnVideoUploadProgress"
FunctionVideoStorage.OnVideoUploadFinish = "FunctionVideoStorage_OnVideoUploadFinish"
FunctionVideoStorage.VideoPath = "/video/normal1.0/"

function FunctionVideoStorage.GetBranchedVideoName(file_name)
  local voice = FunctionPerformanceSetting.Me():GetLanguangeVoice()
  local primary_voice = GameConfig.SEBranchSetting and GameConfig.SEBranchSetting.Order and GameConfig.SEBranchSetting.Order[1] or voice
  if primary_voice ~= voice then
    local sp = string.split(file_name, ".")
    local name, ext = sp[1], sp[2]
    if voice == LanguageVoice.Jananese then
      file_name = name .. "_jp" .. "." .. ext
    elseif voice == LanguageVoice.Korean then
      file_name = name .. "_kr" .. "." .. ext
    elseif voice == LanguageVoice.Chinese then
      file_name = name .. "_cn" .. "." .. ext
    elseif voice == LanguageVoice.English then
      file_name = name .. "_en" .. "." .. ext
    end
  end
  return file_name
end

function FunctionVideoStorage.GetVideoPath(file_name)
  return FunctionVideoStorage.VideoPath .. file_name
end

FunctionVideoStorage.VideoFeature = {DownloadInSetting = 1}

function FunctionVideoStorage.Me()
  if nil == FunctionVideoStorage.me then
    FunctionVideoStorage.me = FunctionVideoStorage.new()
  end
  return FunctionVideoStorage.me
end

function FunctionVideoStorage.IsActive()
  return FunctionCloudFile.IsActive()
end

function FunctionVideoStorage:ctor()
  self:Init()
end

function FunctionVideoStorage:Init()
  self.folderPath = string.format("%s/%s/", ApplicationHelper.persistentDataPath, IOPathConfig.Paths.PublicVideoRoot)
  if not FileDirectoryHandler.ExistDirectory(self.folderPath) then
    FileDirectoryHandler.CreateDirectory(self.folderPath)
  end
  self.videoPathMap = {}
  self.waitUploadMap = {}
  self.downloadMap = {}
  self.uploadMap = {}
  self.waitDownloadMap = {}
  self.downloadSizeMap = {}
  self.processMessageBody = {}
  self.finishMessageBody = {}
  self.downloadKeyMap = {}
  self.uploadKeyMap = {}
  self.localSaveMap = {}
  self.delayDeleteMap = {}
  self.preloadVideoMap = {}
  self.preloadVideoNGUI = nil
  self.videoDownloadPanelData = {
    view = PanelConfig.VideoDownloadView,
    viewdata = {}
  }
end

function FunctionVideoStorage:GetLocalVideoPath(videoID)
  return string.format("%s%s.mp4", self.folderPath, videoID)
end

function FunctionVideoStorage:CheckoutAndPlayVideo(videoID, clickAction, funcOnFinish)
  local videoData = Table_Video and Table_Video[videoID]
  if not videoData then
    LogUtility.Error(string.format("[%s] CheckoutAndPlayVideo() Error : videoID = %s is not exist in Table_Video!", self.__cname, tostring(videoID)))
    return nil
  end
  local url = videoData.Url
  if not url or url == "" then
    self:PlayVideoByID(videoID, clickAction, funcOnFinish)
    return nil
  end
  local path = self:GetLocalVideoPath(videoID)
  if FileHelper.ExistFile(path) then
    VideoPanel.PlayVideo(path, clickAction, funcOnFinish)
  else
    local size = math.floor(videoData.FileSize / 1024)
    MsgManager.ConfirmMsgByID(41514, function()
      local viewdata = self.videoDownloadPanelData.viewdata
      viewdata.videoID = videoID
      viewdata.clickAction = clickAction
      viewdata.path = path
      viewdata.callback = funcOnFinish
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, self.videoDownloadPanelData)
    end, function()
      if funcOnFinish then
        funcOnFinish()
      end
    end, nil, tostring(size))
  end
end

function FunctionVideoStorage:GetVideoByID(videoID, customParam, funcOnProgress, funcOnFinish)
  local videoData = Table_Video and Table_Video[videoID]
  if not videoData then
    redlog("Cannot find video in Table_Video, id: ", tostring(videoID))
    return
  end
  local strPath = self:GetLocalVideoPath(videoID)
  if FileHelper.ExistFile(strPath) then
    if funcOnFinish then
      funcOnFinish(strPath)
    end
    self:SendDownloadFinishMsg(videoID, strPath)
    return
  end
  self:DownloadVideo(videoID, videoData.Url, strPath, customParam, funcOnProgress, funcOnFinish)
end

function FunctionVideoStorage:PlayVideoByID(videoID, clickAction, funcOnFinish)
  if VideoPanel.CheckLimit() then
    MsgManager.ShowMsgByIDTable(41491)
    if funcOnFinish then
      funcOnFinish()
    end
    return
  end
  local videoData = Table_Video and Table_Video[videoID]
  if not videoData then
    redlog("Cannot find video in Table_Video, id: ", tostring(videoID))
    if funcOnFinish then
      funcOnFinish()
    end
    return
  else
    if videoData.preTaskID ~= nil and videoData.preTaskID > 0 then
      if self.preloadVideoMap[videoData.Name] ~= nil then
        helplog("播放预加载云视频流:" .. self.preloadVideoMap[videoData.Name])
        PreVideoPanel.StartVideo(self.preloadVideoNGUI, isStartGameCG, funcOnFinish, true)
      else
        local videourl = videoData.Name
        helplog("播放云视频流（会进一步拼接路径）:" .. videourl)
        PreVideoPanel.PlayVideo(videourl, isStartGameCG, funcOnFinish, true)
      end
    else
      helplog("播放本地视频/云视频流:" .. videoData.Name)
      VideoPanel.PlayVideo(videoData.Name, isStartGameCG, funcOnFinish, true)
    end
    self.preloadVideoMap = {}
    return
  end
  local strPath = self:GetLocalVideoPath(videoID)
  if FileHelper.ExistFile(strPath) then
    VideoPanel.PlayVideo(strPath, clickAction, funcOnFinish)
    return
  end
  if StringUtil.IsEmpty(videoData.Url) then
    VideoPanel.PlayVideo(videoData.Name, clickAction, funcOnFinish)
    return
  end
  local doPlay = function()
    if FileHelper.ExistFile(strPath) then
      VideoPanel.PlayVideo(strPath, clickAction, funcOnFinish)
    else
      VideoPanel.PlayVideo(videoData.Name, clickAction, funcOnFinish)
    end
  end
  doPlay()
end

function FunctionVideoStorage:TryGetLocalVideoPathIfExists(videoID)
  local videoData = Table_Video and Table_Video[videoID]
  if not videoData then
    redlog("Cannot find video in Table_Video, id: ", tostring(videoID))
    return
  end
  local strPath = self:GetLocalVideoPath(videoID)
  if FileHelper.ExistFile(strPath) then
    return strPath
  end
end

function FunctionVideoStorage:GetUrlPrefix()
  local prefix = BranchMgr.IsChina() and XDCDNInfo.GetFileServerURL() or RO.Config.BuildBundleEnvInfo.ResCDN
  if not StringUtil.IsEmpty(prefix) and string.sub(prefix, -1, -1) ~= "/" then
    return prefix .. "/"
  end
  return prefix or ""
end

function FunctionVideoStorage:DownloadVideo(videoID, strUrl, strPath, customParam, funcOnProgress, funcOnFinish)
  if StringUtil.IsEmpty(strUrl) then
    LogUtility.Error("Try download video but url is empty! ID: " .. tostring(videoID))
    if funcOnFinish then
      funcOnFinish()
    end
    self:SendDownloadFinishMsg(videoID)
    return
  end
  strUrl = string.format("%s%s", self:GetUrlPrefix(), strUrl)
  local curDownloadInfo = self.downloadMap[videoID]
  local isDownloading = curDownloadInfo ~= nil
  if not curDownloadInfo then
    curDownloadInfo = ReusableTable.CreateTable()
    curDownloadInfo.listOnProgress = ReusableTable.CreateArray()
    curDownloadInfo.listOnFinish = ReusableTable.CreateArray()
    self.downloadMap[videoID] = curDownloadInfo
    self.downloadKeyMap[videoID] = strUrl .. FunctionVideoStorage.CloudQuestKeyDiviver .. strPath
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
    self.processMessageBody.id = videoID
    self.processMessageBody.progress = progress
    self.processMessageBody.customParam = customParam
    GameFacade.Instance:sendNotification(FunctionVideoStorage.OnVideoDownloadProgress, self.processMessageBody)
    self:RecordDownloadProgress(videoID, progress)
  end, function(isSuccess, errorMsg)
    self:OnDownloadOver(videoID, isSuccess)
    if not self.downloadMap[videoID] then
      return
    end
    self.downloadMap[videoID] = nil
    self.downloadKeyMap[videoID] = nil
    local listOnFinish = curDownloadInfo.listOnFinish
    if not listOnFinish then
      redlog("Callback Is Removed!")
      return
    end
    local resultPath = isSuccess and strPath or nil
    for i = 1, #listOnFinish do
      listOnFinish[i](resultPath, errorMsg)
    end
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curDownloadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curDownloadInfo)
    self:SendDownloadFinishMsg(videoID, resultPath, errorMsg, customParam)
  end)
end

function FunctionVideoStorage:SendDownloadFinishMsg(videoID, strPath, errorMsg, customParam)
  TableUtility.TableClear(self.finishMessageBody)
  self.finishMessageBody.id = videoID
  self.finishMessageBody.path = strPath
  self.finishMessageBody.error = errorMsg
  self.finishMessageBody.customParam = customParam
  GameFacade.Instance:sendNotification(FunctionVideoStorage.OnVideoDownloadFinish, self.finishMessageBody)
end

function FunctionVideoStorage:FormUploadVideo(videoID, strPath, customParam, funcOnProgress, funcOnFinish)
  if not FileHelper.ExistFile(strPath) then
    LogUtility.Error("Cannot Find Photo File: " .. tostring(strPath))
    return
  end
  local curUploadInfo = self.uploadMap[videoID]
  if curUploadInfo then
    if funcOnProgress then
      curUploadInfo.listOnProgress[#curUploadInfo.listOnProgress + 1] = funcOnProgress
    end
    if funcOnFinish then
      curUploadInfo.listOnFinish[#curUploadInfo.listOnFinish + 1] = funcOnFinish
    end
    return
  end
  self.videoPathMap[videoID] = strPath
  local photoInfoList = self.waitUploadMap[videoID]
  if not photoInfoList then
    photoInfoList = ReusableTable.CreateArray()
    self.waitUploadMap[videoID] = photoInfoList
  end
  local uploadInfo = ReusableTable.CreateTable()
  uploadInfo.onProgress = funcOnProgress
  uploadInfo.onFinish = funcOnFinish
  photoInfoList[#photoInfoList + 1] = uploadInfo
  if #photoInfoList < 2 then
  end
end

function FunctionVideoStorage:OnRecvQueryUploadInfoPhotoCmd(data)
  if not data then
    LogUtility.Error("OnRecvUploadSceneryPhotoUserCmd No Data!")
    return
  end
  local videoID = data.id
  local customParam = data.customparam
  local videoInfoList = self.waitUploadMap[videoID]
  if not videoInfoList then
    return
  end
  local curUploadInfo = self.uploadMap[videoID]
  local isUploading = curUploadInfo ~= nil
  if not curUploadInfo then
    curUploadInfo = ReusableTable.CreateTable()
    curUploadInfo.listOnProgress = ReusableTable.CreateArray()
    curUploadInfo.listOnFinish = ReusableTable.CreateArray()
    self.uploadMap[videoID] = curUploadInfo
  end
  local singleVideoInfo
  for i = 1, #videoInfoList do
    singleVideoInfo = videoInfoList[i]
    if singleVideoInfo.onProgress then
      curUploadInfo.listOnProgress[#curUploadInfo.listOnProgress + 1] = singleVideoInfo.onProgress
    end
    if singleVideoInfo.onFinish then
      curUploadInfo.listOnFinish[#curUploadInfo.listOnFinish + 1] = singleVideoInfo.onFinish
    end
    ReusableTable.DestroyAndClearTable(singleVideoInfo)
  end
  ReusableTable.DestroyAndClearArray(videoInfoList)
  self.waitUploadMap[videoID] = nil
  local strPath = self.videoPathMap[videoID]
  self.videoPathMap[videoID] = nil
  if isUploading then
    return
  end
  if not FileHelper.ExistFile(strPath) then
    LogUtility.Error("Cannot Find Photo File: " .. tostring(strPath))
    return
  end
  local strFileName = FileHelper.GetFileNameFromPath(strPath)
  local fileTimestamp = tonumber(StringUtility.Split(strFileName, FunctionVideoStorage.DivideCharacter)[2])
  local bucket
  local uploadFields = ReusableTable.CreateArray()
  local singleField
  for i = 1, #data.params do
    singleField = data.params[i]
    uploadFields[#uploadFields + 1] = singleField.key
    uploadFields[#uploadFields + 1] = singleField.value
    if singleField.key == "bucket" then
      bucket = singleField.value
    end
  end
  local url, formUploadData
  if BranchMgr.IsChina() then
    formUploadData = CloudFile.UpyunUploadData()
    url = UpyunInfo.GetFormUploadURL()
  else
    formUploadData = CloudFile.FormUploadData()
    if BranchMgr.IsJapan() then
      url = data.useaws and string.format("http://%s.s3.ap-northeast-1.amazonaws.com/", bucket) or GoogleStorageConfig.googleStorageUpLoad
    else
      url = GoogleStorageConfig.googleStorageUpLoad
    end
  end
  formUploadData:InitDatas(strPath, uploadFields)
  ReusableTable.DestroyAndClearArray(uploadFields)
  self.uploadKeyMap[videoID] = url .. FunctionVideoStorage.CloudQuestKeyDiviver .. strPath
  FunctionCloudFile.Me():FormUpload(url, strPath, formUploadData, function(progress)
    local listOnProgress = curUploadInfo.listOnProgress
    for i = 1, #listOnProgress do
      listOnProgress[i](progress)
    end
    self.processMessageBody.id = videoID
    self.processMessageBody.progress = progress
    self.processMessageBody.customParam = customParam
    GameFacade.Instance:sendNotification(FunctionVideoStorage.OnVideoUploadProgress, self.processMessageBody)
  end, function(success, errorMsg)
    self.uploadMap[videoID] = nil
    self.uploadKeyMap[videoID] = nil
    local listOnFinish = curUploadInfo.listOnFinish
    for i = 1, #listOnFinish do
      listOnFinish[i](success, errorMsg)
    end
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnProgress)
    ReusableTable.DestroyAndClearArray(curUploadInfo.listOnFinish)
    ReusableTable.DestroyAndClearTable(curUploadInfo)
    self:SendUploadFinishMsg(videoID, success, errorMsg, customParam)
  end)
end

function FunctionVideoStorage:SendUploadFinishMsg(videoID, success, errorMsg, customParam)
  TableUtility.TableClear(self.finishMessageBody)
  self.finishMessageBody.id = videoID
  self.finishMessageBody.success = success
  self.finishMessageBody.error = errorMsg
  self.finishMessageBody.customParam = customParam
  GameFacade.Instance:sendNotification(FunctionVideoStorage.OnVideoUploadFinish, self.finishMessageBody)
end

function FunctionVideoStorage:CancelVideoDownload(videoID, customParam)
  local questKey = self.downloadKeyMap[videoID]
  if questKey then
    local keys = string.split(questKey, FunctionVideoStorage.CloudQuestKeyDiviver)
    FunctionCloudFile.Me():CancelDownload(keys[1], keys[2])
  end
end

function FunctionVideoStorage:CancelVideoUpload(videoID, customParam)
  local questKey = self.uploadKeyMap[videoID]
  self.localSaveMap[videoID] = false
  if questKey then
    local keys = string.split(questKey, FunctionVideoStorage.CloudQuestKeyDiviver)
    FunctionCloudFile.Me():CancelUpload(keys[1], keys[2])
  end
end

function FunctionVideoStorage:DeleteLocalVideo(videoID, customParam)
  if self.localSaveMap[videoID] == true then
    self.delayDeleteMap[videoID] = true
    return
  end
  local path = self:GetLocalVideoPath(videoID)
  if FileHelper.ExistFile(path) then
    FileHelper.DeleteFile(path)
  end
end

function FunctionVideoStorage:IsVideoUploading(videoID, customParam)
  local videoInfoList = self.waitUploadMap[videoID]
  if videoInfoList and 0 < #videoInfoList then
    return true
  end
  return self.uploadMap[videoID] ~= nil or self.localSaveMap[videoID] ~= nil
end

function FunctionVideoStorage:IsVideoDownloading(videoID, customParam)
  return self.downloadMap[videoID] ~= nil
end

function FunctionVideoStorage:ClearCloundQuest()
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
end

function FunctionVideoStorage:ClearDownloadRecord(videoID)
  local videoData = Table_Video and Table_Video[videoID]
  if not videoData or not videoData.Url then
    return
  end
  local strPath = self:GetLocalVideoPath(videoID)
  if not strPath then
    return
  end
  FunctionCloudFile.Me():ClearQuestTimeRecord(videoData.Url, strPath)
end

function FunctionVideoStorage:IsDownloadingAllVideo()
  return self.isDownloadingAllVideo
end

function FunctionVideoStorage:RefreshWaitDownloadInfo()
  if self:IsDownloadingAllVideo() then
    local newAlreadyDownloadSize = 0
    for videoID, downloadSize in pairs(self.downloadSizeMap) do
      newAlreadyDownloadSize = newAlreadyDownloadSize + downloadSize
    end
    local curTime = ServerTime.CurServerTime()
    local deltaSize = math.max(newAlreadyDownloadSize - self.alreadyDownloadSize, 0)
    local deltaTime = (curTime - self.lastRefreshTime) / 1000
    self.downloadSpeedPerSec = 0 < deltaTime and deltaSize / deltaTime or 0
    self.alreadyDownloadSize = newAlreadyDownloadSize
    self.lastRefreshTime = curTime
  else
    TableUtility.TableClear(self.waitDownloadMap)
    TableUtility.TableClear(self.downloadSizeMap)
    self.totalCloudVideoSize = 0
    self.alreadyDownloadSize = 0
    self.downloadSpeedPerSec = 0
    self.lastRefreshTime = ServerTime.CurServerTime()
    if not Table_Video then
      return
    end
    for videoID, videoData in pairs(Table_Video) do
      if not StringUtil.IsEmpty(videoData.Url) and videoData.Features and 0 < videoData.Features & FunctionVideoStorage.VideoFeature.DownloadInSetting then
        self.totalCloudVideoSize = self.totalCloudVideoSize + videoData.FileSize
        if FileHelper.ExistFile(self:GetLocalVideoPath(videoID)) then
          self.downloadSizeMap[videoID] = videoData.FileSize
          self.alreadyDownloadSize = self.alreadyDownloadSize + videoData.FileSize
        else
          self.waitDownloadMap[videoID] = videoData
        end
      end
    end
  end
end

function FunctionVideoStorage:DownloadAllVideo()
  do return end
  if self:IsDownloadingAllVideo() then
    return
  end
  self.lastRefreshTime = ServerTime.CurServerTime()
  self:RefreshWaitDownloadInfo()
  local haveVideoToDownload = false
  for videoID, videoData in pairs(self.waitDownloadMap) do
    self:ClearDownloadRecord(videoID)
    self:GetVideoByID(videoID)
    haveVideoToDownload = true
  end
  self.isDownloadingAllVideo = haveVideoToDownload
end

function FunctionVideoStorage:CancelDownloadAllVideo()
  if not self:IsDownloadingAllVideo() then
    return
  end
  FunctionUtility.Me():CancelDelayCallByMark(self)
  for videoID, videoData in pairs(self.waitDownloadMap) do
    self:ClearDownloadRecord(videoID)
    self:CancelVideoDownload(videoID)
  end
  self.isDownloadingAllVideo = false
  TableUtility.TableClear(self.waitDownloadMap)
end

function FunctionVideoStorage:DeleteAllLocalVideo()
  for videoID, videoData in pairs(Table_Video) do
    self:DeleteLocalVideo(videoID)
  end
end

function FunctionVideoStorage:RecordDownloadProgress(id, progress)
  if not self:IsDownloadingAllVideo() then
    return
  end
  local videoData = self.waitDownloadMap[id]
  if not videoData then
    return
  end
  self.downloadSizeMap[id] = videoData.FileSize * progress
end

function FunctionVideoStorage:OnDownloadOver(id, success)
  if not self:IsDownloadingAllVideo() then
    return
  end
  local videoData = self.waitDownloadMap[id]
  if not videoData then
    return
  end
  if not success then
    self.downloadSizeMap[id] = 0
    self:ClearDownloadRecord(id)
    FunctionUtility.Me():DelayCall(self.GetVideoByID, 1000, self, self, id)
    return
  end
  self.waitDownloadMap[id] = nil
  self.downloadSizeMap[id] = videoData.FileSize
  if not next(self.waitDownloadMap) then
    self.isDownloadingAllVideo = false
  end
end

function FunctionVideoStorage:GetDownloadInfo()
  self:RefreshWaitDownloadInfo()
  return self.alreadyDownloadSize, self.totalCloudVideoSize, self:IsDownloadingAllVideo() and self.downloadSpeedPerSec or nil
end

function FunctionVideoStorage:HandleTask(delTasks)
  if delTasks ~= nil then
    local preloadVideo
    for i = 1, #delTasks do
      local taskID = delTasks[i].id
      for _, videoData in pairs(Table_Video) do
        if videoData.preTaskID == taskID then
          preloadVideo = videoData.Name
          break
        end
      end
      if preloadVideo ~= nil then
        break
      end
    end
    if preloadVideo ~= nil then
      helplog("preloadVideo:" .. preloadVideo)
      if self.preloadVideoMap[preloadVideo] then
        helplog("重复预加载")
      elseif #self.preloadVideoMap > 0 then
        helplog("已存在预加载视频,尚未播放")
      else
        self.preloadVideoMap[preloadVideo] = preloadVideo
        if self.preloadVideoNGUI ~= nil then
          local videoPlayer = self.preloadVideoNGUI:GetComponent(VideoPlayerNGUI)
          if videoPlayer then
            videoPlayer:Close()
            self.preloadVideoNGUI = nil
          end
        end
        self.preloadVideoNGUI = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1("view/VideoPlayer"), nil)
        if self.preloadVideoNGUI then
          GameObject.DontDestroyOnLoad(self.preloadVideoNGUI)
          local videoPlayer = self.preloadVideoNGUI:GetComponent(VideoPlayerNGUI)
          if videoPlayer then
            self.preloadVideoNGUI.transform.localPosition = UILayer.HidePos
            videoPlayer.autoStart = false
            do
              local url_b = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(FunctionVideoStorage.GetBranchedVideoName(preloadVideo))
              local url = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(preloadVideo)
              HTTPRequest.Head(url_b, function(x)
                if not NetIngPersonalPhoto.Ins().netIngTerminated then
                  local unityWebRequest = x
                  local responseCode = unityWebRequest.responseCode
                  redlog("VideoPanel:Head responseCode:", responseCode)
                  if responseCode == 200 then
                    videoPlayer:OpenVideo(url_b, true)
                  else
                    videoPlayer:OpenVideo(url, true)
                  end
                end
              end)
            end
          end
        end
      end
    end
  end
end

function FunctionVideoStorage:ClearPreLoadVideo()
  if self.preloadVideoNGUI ~= nil then
    local videoPlayer = self.preloadVideoNGUI:GetComponent(VideoPlayerNGUI)
    if videoPlayer then
      videoPlayer:Close()
      self.preloadVideoNGUI = nil
    end
  end
end
