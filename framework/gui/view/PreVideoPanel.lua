PreVideoPanel = class("PreVideoPanel", ContainerView)
PreVideoPanel.ViewType = UIViewType.VideoLayer
PreVideoPanel.UnUseVideo = GameConfig.System.unuseVideo
VideoPanelClickAction = {
  ShowCtrl = 0,
  Nothing = 1,
  CloseSelf = 2
}

function PreVideoPanel:Init()
  PreVideoPanel.Instance = self
  self.callback = nil
end

function PreVideoPanel:SetFinishCallback(finishCallback)
  self.callback = finishCallback
end

function PreVideoPanel.PlayVideo(url, clickAction, finishCallback, audioOverlay)
  local instance = PreVideoPanel._getInstance()
  if audioOverlay == nil then
    audioOverlay = true
  end
  instance.clickAction = clickAction
  instance.audioOverlay = audioOverlay
  GameObject.DestroyImmediate(instance:FindGO("VideoPlayer"))
  local preVideoNGUI = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1("view/VideoPlayer"), nil)
  preVideoNGUI.transform.parent = instance.gameObject.transform
  preVideoNGUI.transform.localPosition = LuaGeometry.Const_V3_zero
  instance.videoPlayer = preVideoNGUI:GetComponent(VideoPlayerNGUI)
  instance:SetFinishCallback(finishCallback)
  instance:FindObjs()
  instance:InitPlayer()
  instance:AddEvts()
  instance:_playVideo(url)
end

function PreVideoPanel.StartVideo(preVideoNGUI, clickAction, finishCallback, audioOverlay)
  local instance = PreVideoPanel._getInstance()
  instance.clickAction = clickAction
  instance.audioOverlay = audioOverlay
  GameObject.DestroyImmediate(instance:FindGO("VideoPlayer"))
  preVideoNGUI.transform.parent = instance.gameObject.transform
  preVideoNGUI.transform.localPosition = LuaGeometry.Const_V3_zero
  instance.videoPlayer = preVideoNGUI:GetComponent(VideoPlayerNGUI)
  instance:SetFinishCallback(finishCallback)
  instance:FindObjs()
  instance:InitPlayer()
  instance:AddEvts()
  instance:_startVideo()
end

function PreVideoPanel._getInstance()
  if PreVideoPanel.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PreVideoPanel
    })
  end
  return PreVideoPanel.Instance
end

function PreVideoPanel:FindObjs()
  self.videoPlayer = self:FindComponent("VideoPlayer", VideoPlayerNGUI)
  self.closeBtn = self:FindGO("CloseButton")
  self.bg = self:FindComponent("Bg", UISprite)
end

function PreVideoPanel:InitPlayer()
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

function PreVideoPanel:OnExit()
  PreVideoPanel.super.OnExit(self)
  PreVideoPanel.Instance = nil
end

function PreVideoPanel:AddEvts()
  self:AddClickEvent(self.videoPlayer.gameObject, function(g)
    if self.clickAction == VideoPanelClickAction.CloseSelf then
      self:CloseSelf()
    elseif not self.clickAction or self.clickAction == VideoPanelClickAction.ShowCtrl then
      self:_showCtlView()
    end
  end)
end

function PreVideoPanel:_showCtlView()
  local active = self.closeBtn.activeSelf
  self.closeBtn:SetActive(not active)
  if not active then
    self.clickTime = UnityUnscaledTime
    self.timeTick = TimeTickManager.Me():CreateTick(0, 60, self.updateShowCtl, self, 1, true)
  else
    self:ClearTick()
  end
end

function PreVideoPanel:updateShowCtl(deltaTime)
  if UnityUnscaledTime - self.clickTime > 5 then
    self.closeBtn:SetActive(false)
    self:ClearTick()
  end
end

function PreVideoPanel:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function PreVideoPanel:_preloadVideo(url)
  if nil == self.videoPlayer then
    return
  end
  self:SetTextureAlpha(0)
  self.videoPlayer.autoStart = false
  local res = self.videoPlayer:OpenVideo(url, true)
  if not res then
    self:CloseSelf()
    return
  end
end

function PreVideoPanel:_startVideo()
  if nil == self.videoPlayer then
    return
  end
  self:SetTextureAlpha(1)
  self.videoPlayer:Play()
  self.videoPlayer:Unmute()
end

function PreVideoPanel:_playVideo(url)
  if nil == self.videoPlayer then
    return
  end
  self:SetTextureAlpha(1)
  local url1 = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(FunctionVideoStorage.GetBranchedVideoName(url))
  local url2 = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(url)
  HTTPRequest.Head(url1, function(x)
    if not NetIngPersonalPhoto.Ins().netIngTerminated then
      local unityWebRequest = x
      local responseCode = unityWebRequest.responseCode
      local res
      redlog("VideoPanel:Head responseCode:", responseCode)
      if responseCode == 200 then
        res = self.videoPlayer:OpenVideo(url1, true)
      else
        res = self.videoPlayer:OpenVideo(url2, true)
      end
      if not res then
        self:CloseSelf()
      end
    else
      self:CloseSelf()
    end
  end)
end

function PreVideoPanel:IsPlaying()
  if not self.videoPlayer then
    return false
  end
  return self.videoPlayer.isPlaying
end

function PreVideoPanel:GetPlayingVideoDuration()
  if not self:IsPlaying() then
    return 0
  end
  return self.videoPlayer.duration
end

function PreVideoPanel:GetPlayingVideoCurrentTime()
  if not self:IsPlaying() then
    return 0
  end
  return self.videoPlayer.currentTime
end

function PreVideoPanel:_setTexture()
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

function PreVideoPanel:SetTextureAlpha(alpha)
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

function PreVideoPanel:MuteAudio(b)
  if b then
    self.videoPlayer:Mute()
  else
    self.videoPlayer:Unmute()
  end
end

function PreVideoPanel:CloseSelf()
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
  FunctionVideoStorage.Me():ClearPreLoadVideo()
  PreVideoPanel.super.CloseSelf(self)
end

function PreVideoPanel:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    Game.PlotStoryManager:DoSkipForVideoPanel()
    self:CloseSelf()
  end)
end

function PreVideoPanel.CheckLimit(isFromStartGamePanel)
  return GameConfig.Limitplay[ApplicationInfo.GetDeviceModel()] or Application.platform == RuntimePlatform.IPhonePlayer and ApplicationInfo.IsIOSVersionUnder(10) or isFromStartGamePanel and (BackwardCompatibilityUtil.CompatibilityMode_V57 or GameConfig.System.unuseDynamicLoginBG == 1)
end
