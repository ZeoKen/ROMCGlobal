VideoPanel = class("VideoPanel", ContainerView)
VideoPanel.ViewType = UIViewType.VideoLayer
VideoPanel.VideoPath = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/Videos/"
VideoPanel.UnUseVideo = GameConfig.System.unuseVideo
local IsNull = Slua.IsNull
VideoPanelClickAction = {
  ShowCtrl = 0,
  Nothing = 1,
  CloseSelf = 2
}

function VideoPanel:Init()
  self:FindObjs()
  self:InitPlayer()
  self:AddEvts()
  VideoPanel.Instance = self
  self.callback = nil
end

function VideoPanel:SetFinishCallback(finishCallback)
  self.callback = finishCallback
end

function VideoPanel.PlayVideo(filePath, clickAction, finishCallback, audioOverlay)
  if type(VideoPanel.UnUseVideo) == "table" and 0 ~= TableUtility.ArrayFindIndex(VideoPanel.UnUseVideo, filePath) then
    redlog("播放的视频在GameConfig.System.UnUseVideo 中删除了 ", filePath)
    return
  end
  if VideoPanel.CheckLimit() then
    MsgManager.ShowMsgByIDTable(41491)
    return
  end
  if audioOverlay == nil then
    audioOverlay = true
  end
  local instance = VideoPanel._getInstance()
  instance.filePath = filePath
  instance.clickAction = clickAction
  instance.audioOverlay = audioOverlay
  instance:SetFinishCallback(finishCallback)
  instance:_launchVideo()
end

function VideoPanel.DeleteUnuseVideo()
  if VideoPanel.UnUseVideo then
    for i = 1, #VideoPanel.UnUseVideo do
      ROFileUtils.FileDelete(VideoPanel.VideoPath .. VideoPanel.UnUseVideo[i])
    end
  end
end

function VideoPanel._getInstance()
  if VideoPanel.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.VideoPanel
    })
  end
  return VideoPanel.Instance
end

function VideoPanel:FindObjs()
  self.videoPlayer = self:FindComponent("VideoPlayer", VideoPlayerNGUI)
  self.closeBtn = self:FindGO("CloseButton")
  self.bg = self:FindComponent("Bg", UISprite)
end

function VideoPanel:InitPlayer()
  function self.videoPlayer.onStarted()
    if self.audioOverlay then
      FunctionBGMCmd.Me():Pause()
    end
    self:MuteAudio(not self.audioOverlay)
    self:_setTexture()
  end
  
  function self.videoPlayer.onFinishedPlaying()
    self:CloseSelf()
  end
  
  function self.videoPlayer.onError()
    MsgManager.ShowMsgByIDTable(41491)
    self:CloseSelf()
  end
end

function VideoPanel:OnExit()
  VideoPanel.super.OnExit(self)
  VideoPanel.Instance = nil
end

function VideoPanel:AddEvts()
  self:AddClickEvent(self.videoPlayer.gameObject, function(g)
    if self.clickAction == VideoPanelClickAction.CloseSelf then
      self:CloseSelf()
    elseif not self.clickAction or self.clickAction == VideoPanelClickAction.ShowCtrl then
      self:_showCtlView()
    end
  end)
end

function VideoPanel:_showCtlView()
  local active = self.closeBtn.activeSelf
  self.closeBtn:SetActive(not active)
  if not active then
    self.clickTime = UnityUnscaledTime
    self.timeTick = TimeTickManager.Me():CreateTick(0, 60, self.updateShowCtl, self, 1, true)
  else
    self:ClearTick()
  end
end

function VideoPanel:updateShowCtl(deltaTime)
  if UnityUnscaledTime - self.clickTime > 5 then
    self.closeBtn:SetActive(false)
    self:ClearTick()
  end
end

function VideoPanel:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function VideoPanel:_launchVideo()
  if nil == self.videoPlayer then
    return
  end
  self:SetTextureAlpha(1)
  local res
  local filePath_Branched = FunctionVideoStorage.GetBranchedVideoName(self.filePath)
  if FileHelper.ExistFile(filePath_Branched) then
    res = self.videoPlayer:OpenVideo(filePath_Branched, true)
  elseif FileHelper.ExistFile(self.filePath) then
    res = self.videoPlayer:OpenVideo(self.filePath, true)
  elseif FileHelper.ExistFile(VideoPanel.VideoPath .. filePath_Branched) then
    res = self.videoPlayer:OpenVideo(VideoPanel.VideoPath .. filePath_Branched, true)
  elseif FileHelper.ExistFile(VideoPanel.VideoPath .. self.filePath) then
    res = self.videoPlayer:OpenVideo(VideoPanel.VideoPath .. self.filePath, true)
  else
    local url_b = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(filePath_Branched)
    local url = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(self.filePath)
    HTTPRequest.Head(url_b, function(x)
      if not NetIngPersonalPhoto.Ins().netIngTerminated then
        local unityWebRequest = x
        local responseCode = unityWebRequest.responseCode
        redlog("VideoPanel:Head responseCode:", responseCode)
        if responseCode == 200 then
          res = self.videoPlayer:OpenVideo(url_b, true)
        else
          res = self.videoPlayer:OpenVideo(url, true)
        end
        if not res then
          self:CloseSelf()
        end
      else
        self:CloseSelf()
      end
    end)
    return
  end
  if not res then
    self:CloseSelf()
    return
  end
end

function VideoPanel:IsPlaying()
  if not self.videoPlayer or IsNull(self.videoPlayer) then
    return false
  end
  return self.videoPlayer.isPlaying
end

function VideoPanel:GetPlayingVideoDuration()
  if not self:IsPlaying() then
    return 0
  end
  return self.videoPlayer.duration
end

function VideoPanel:GetPlayingVideoCurrentTime()
  if not self:IsPlaying() then
    return 0
  end
  return self.videoPlayer.currentTime
end

function VideoPanel:_setTexture()
  local rootSize, vRatio = UIManagerProxy.Instance:GetUIRootSize(), self.videoPlayer:GetVideoTextureRatio()
  local width, height = rootSize[1], rootSize[2]
  if 720 < height then
    height = width / vRatio
  else
    width = height * vRatio
  end
  self.videoPlayer:SetTextureSize(width, height)
end

local bezierP0, bezierP1, bezierP3 = LuaVector3.Zero(), LuaVector3.Zero(), LuaVector3.New(1, 1, 0)
local specialCubicBezierFunc = function(t, x1)
  LuaVector3.Better_Set(bezierP1, x1, 1 - x1, 0)
  local tempV3 = LuaGeometry.GetTempVector3()
  VectorUtility.Better_CubicBezier(bezierP0, bezierP1, bezierP1, bezierP3, tempV3, t)
  return tempV3[2]
end

function VideoPanel:SetTextureAlpha(alpha)
  alpha = math.clamp(alpha, 0, 1)
  self.isTransparent = alpha < 1
  if self.isTransparent then
    self.closeBtn:SetActive(false)
    self:ClearTick()
  end
  local tex = self.videoPlayer.texture
  if tex then
    self.bg.color = LuaGeometry.GetTempColor(0, 0, 0, specialCubicBezierFunc(alpha, 0.01))
    tex.color = LuaGeometry.GetTempColor(1, 1, 1, alpha)
  end
end

function VideoPanel:MuteAudio(b)
  if b then
    self.videoPlayer:Mute()
  else
    self.videoPlayer:Unmute()
  end
end

function VideoPanel:CloseSelf()
  if self.audioOverlay then
    FunctionBGMCmd.Me():UnPause()
  end
  if self.callback ~= nil then
    self.callback()
  end
  if nil ~= self.videoPlayer then
    self.videoPlayer:Close()
  end
  self.callback = nil
  self:ClearTick()
  VideoPanel.super.CloseSelf(self)
end

function VideoPanel:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    Game.PlotStoryManager:DoSkipForVideoPanel()
    self:CloseSelf()
  end)
end

function VideoPanel.CheckLimit(isFromStartGamePanel)
  return GameConfig.Limitplay[ApplicationInfo.GetDeviceModel()] or Application.platform == RuntimePlatform.IPhonePlayer and ApplicationInfo.IsIOSVersionUnder(10) or isFromStartGamePanel and (BackwardCompatibilityUtil.CompatibilityMode_V57 or GameConfig.System.unuseDynamicLoginBG == 1)
end
