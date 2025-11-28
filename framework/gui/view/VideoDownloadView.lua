VideoDownloadView = class("VideoDownloadView", BaseView)
VideoDownloadView.ViewType = UIViewType.PopUpLayer

function VideoDownloadView:Init()
  self:FindObjs()
  self:AddEvents()
  self:AddListenEvts()
end

function VideoDownloadView:OnEnter()
  VideoDownloadView.super.OnEnter(self)
  self:InitView()
  self.downloadCanceled = false
end

function VideoDownloadView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:UnLoadPic()
  VideoDownloadView.super.OnExit(self)
end

function VideoDownloadView:OnDestroy()
  VideoDownloadView.super.OnDestroy(self)
end

function VideoDownloadView:FindObjs()
  self.bg = self:FindGO("Bg"):GetComponent(UITexture)
  self.labelBg = self:FindGO("labelBg"):GetComponent(UIWidget)
  self.txtLeftSize = self:FindComponent("txtLeftSize", UILabel)
  self.txtSpeed = self:FindComponent("txtSpeed", UILabel)
  self.effectContainer = self:FindGO("effectContainer")
end

function VideoDownloadView:AddEvents()
  self:AddButtonEvent("btnCancel", function(go)
    self:CancelVideoDownload()
  end)
end

function VideoDownloadView:CancelVideoDownload()
  if self.downloadCanceled then
    return
  end
  self.downloadCanceled = true
  TimeTickManager.Me():CreateOnceDelayTick(3000, function()
    LogUtility.Error("Canceled download video but not recieved OnVideoDownloadFinish! Video ID is: " .. tostring(self.videoID))
    if self.callback then
      self.callback()
    end
    self:CloseSelf()
  end, self, 2)
  FunctionVideoStorage.Me():CancelVideoDownload(self.videoID)
end

function VideoDownloadView:AddListenEvts()
  self:AddListenEvt(FunctionVideoStorage.OnVideoDownloadProgress, self.DownloadProgress)
  self:AddListenEvt(FunctionVideoStorage.OnVideoDownloadFinish, self.DownloadFinish)
end

function VideoDownloadView:InitView()
  self:TryLoadPic("loading_Q")
  self.videoID = self.viewdata.viewdata.videoID
  self.clickAction = self.viewdata.viewdata.clickAction
  self.callback = self.viewdata.viewdata.callback
  self.videoData = Table_Video and Table_Video[self.videoID]
  if not self.videoData then
    redlog("Cannot find video in Table_Video, id: ", tostring(self.videoID))
    if self.callback then
      self.callback()
    end
    self:CloseSelf()
    return
  end
  self.lastCheckTime = UnityRealtimeSinceStartup
  self.videoSize = self.videoData.FileSize / 1024
  self.downLoadSize = 0
  self.downLoadSpeed = 0
  self:PlayUIEffect(EffectMap.UI.Eff_loading2_ui, self.effectContainer)
  TimeTickManager.Me():CreateOnceDelayTick(500, self.StartDownloadVideo, self, 3)
end

function VideoDownloadView:TryLoadPic(bgName)
  self.bgName = bgName or "loading"
  PictureManager.Instance:SetLoading(self.bgName, self.bg)
  self.bg:MakePixelPerfect()
  PictureManager.ReFitManualHeight(self.bg)
  self:ReFitLabelBg()
end

function VideoDownloadView:UnLoadPic()
  if self.bgName then
    PictureManager.Instance:UnLoadLoading(self.bgName, self.bg)
  end
end

function VideoDownloadView:ReFitLabelBg()
  local scale = self.labelBg.width / self.labelBg.height
  self.labelBg.height = self.bg.width
  self.labelBg.width = self.labelBg.height * scale
  local y = self.bg.localCorners[1].y + self.labelBg.width * 0.5
  local pos = self.labelBg.transform.localPosition
  pos.y = y
  self.labelBg.transform.localPosition = pos
end

function VideoDownloadView:StartDownloadVideo()
  FunctionVideoStorage.Me():DownloadVideo(self.videoID, self.videoData.Url, self.viewdata.viewdata.path)
end

function VideoDownloadView:DownloadProgress(note)
  if note and self.videoID == note.body.id then
    self.leftSize = string.format("%.2f", (1 - note.body.progress) * self.videoSize)
    self.txtLeftSize.text = string.format(ZhString.DownloadTip_LeftSize, self.leftSize)
    if 1 <= UnityRealtimeSinceStartup - self.lastCheckTime then
      self.lastCheckTime = UnityRealtimeSinceStartup
      self.downLoadSpeed = string.format("%.2f", self.videoSize * note.body.progress - self.downLoadSize)
      self.downLoadSize = self.videoSize * note.body.progress
      self.txtSpeed.text = string.format(ZhString.DownloadTip_Speed, self.downLoadSpeed)
    end
  end
end

function VideoDownloadView:DownloadFinish(note)
  if not note or self.videoID ~= note.body.id then
    return
  end
  if note.body.error == FunctionCloudFile.ErrorCode_UserCancel then
    if self.callback then
      self.callback()
    end
    self:CloseSelf()
  elseif note.body.path then
    VideoPanel.PlayVideo(note.body.path or self.videoData.Name, self.clickAction, self.callback)
    self:CloseSelf()
  else
    MsgManager.ConfirmMsgByID(Application.internetReachability == NetworkReachability.NotReachable and 41367 or 41368, function()
      FunctionVideoStorage.Me():DownloadVideo(self.videoID, self.videoData.Url, self.viewdata.viewdata.path)
    end, function()
      VideoPanel.PlayVideo(self.videoData.Name, self.clickAction, self.callback)
      self:CloseSelf()
    end)
  end
end
