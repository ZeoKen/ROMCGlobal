FashionStarVideo = class("FashionStarVideo", SubView)
local _GetBranchedVideoName = FunctionVideoStorage.GetBranchedVideoName
local _GetVideoPath = FunctionVideoStorage.GetVideoPath
local _SafePlayVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Play()
  videoPlayerNGUI.volume = FunctionPerformanceSetting.Me():GetBGMSetting()
end
local _SafePauseVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Pause()
end
local _SafeOpenVideo = function(videoPlayerNGUI, videoPath, pathAbsolute)
  local video_Branched = _GetBranchedVideoName(videoPath)
  local url_b = XDCDNInfo.GetVideoServerURL() .. _GetVideoPath(video_Branched)
  local url = XDCDNInfo.GetVideoServerURL() .. _GetVideoPath(videoPath)
  HTTPRequest.Head(url_b, function(x)
    if not NetIngPersonalPhoto.Ins().netIngTerminated then
      local unityWebRequest = x
      local responseCode = unityWebRequest.responseCode
      redlog("VideoPanel:Head responseCode:", responseCode)
      if responseCode == 200 then
        videoPlayerNGUI:OpenVideo(url_b, pathAbsolute)
      else
        videoPlayerNGUI:OpenVideo(url, pathAbsolute)
      end
    end
  end)
  videoPlayerNGUI:OpenVideo(videoPath, pathAbsolute)
end
local _SafeCloseVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Close()
end
local _SafeVideo_loop = function(videoPlayerNGUI, b)
  videoPlayerNGUI.loop = b
end
local _PrefabPath = ResourcePathHelper.UIView("FashionStarVideo")

function FashionStarVideo:Init()
  self.videoRoot = self:FindGO("VideoRoot")
  local obj = self:LoadPreferb_ByFullPath(_PrefabPath, self.videoRoot, true)
  obj.name = "FashionStarVideo"
  self:FindObjs()
end

function FashionStarVideo:FindObjs()
  self.videoGO = self:FindGO("VideoTexture")
  self.videoPlayerNGUI = self.videoGO:GetComponent(VideoPlayerNGUI)
  self.playVideoBtn = self:FindGO("PlayVideoBtn", self.videoGO)
  
  function self.videoPlayerNGUI.onStarted()
    self.playVideoBtn:SetActive(false)
  end
  
  function self.videoPlayerNGUI.onError()
    self.playVideoBtn:SetActive(false)
  end
  
  self:AddClickEvent(self.videoGO, function()
    self:PlayVideo(false)
  end)
  self:AddClickEvent(self.playVideoBtn, function()
    local url = XDCDNInfo.GetVideoServerURL() .. _GetVideoPath(self.nowVideoPath)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.VideoPreview,
      viewdata = {
        url = url,
        btnText = ZhString.CommonZhString_Close,
        btnFunc = function(uiLabel)
          GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.Lv4PopUpLayer)
        end
      }
    })
  end)
end

function FashionStarVideo:PlayVideo(b)
  if not self.nowVideoPath then
    return
  end
  if Slua.IsNull(self.videoGO) or not self.videoGO.activeSelf then
    return
  end
  local ret, msg
  if b then
    ret, msg = xpcall(_SafePlayVideo, debug.traceback, self.videoPlayerNGUI)
    if ret then
      self.playVideoBtn:SetActive(false)
    end
  else
    ret, msg = xpcall(_SafePauseVideo, debug.traceback, self.videoPlayerNGUI)
    if ret then
      self.playVideoBtn:SetActive(true)
    end
  end
  if not ret then
    LogUtility.Error(tostring(msg))
  end
end

function FashionStarVideo:OpenVideo(path, autoStart)
  self.videoPath = path
  if self.videoPath ~= self.nowVideoPath then
    if self.nowVideoPath then
      self:CloseVideo()
    end
    self.videoGO:SetActive(true)
    self.nowVideoPath = self.videoPath
    local ret, msg
    ret, msg = xpcall(_SafeOpenVideo, debug.traceback, self.videoPlayerNGUI, self.nowVideoPath, true)
    if not ret then
      LogUtility.Error(tostring(msg))
      self.playVideoBtn:SetActive(false)
    end
    ret, msg = xpcall(_SafeVideo_loop, debug.traceback, self.videoPlayerNGUI, true)
    if not ret then
      LogUtility.Error(tostring(msg))
    end
    self.videoPlayerNGUI.autoStart = autoStart or false
  end
end

local _delayFunc = function(self)
  self:PlayVideo(false)
end

function FashionStarVideo:CloseTick()
  if self.tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.tick = nil
  end
end

function FashionStarVideo:ShowVideo(path)
  self:Show(self.videoRoot)
  self:OpenVideo(path, true)
  self:CloseTick()
  self.tick = TimeTickManager.Me():CreateOnceDelayTick(1000, _delayFunc, self, 1)
end

function FashionStarVideo:HideVideo()
  self:CloseVideo()
  self:Hide(self.videoRoot)
end

function FashionStarVideo:CloseVideo()
  if Slua.IsNull(self.videoGO) then
    return
  end
  if self.nowVideoPath then
    self.nowVideoPath = nil
  end
  if not Slua.IsNull(self.videoGO) and self.videoGO.activeSelf then
    local ret, msg = xpcall(_SafeCloseVideo, debug.traceback, self.videoPlayerNGUI)
    if not ret then
      LogUtility.Error(tostring(msg))
    end
  end
end

function FashionStarVideo:OnExit()
  self:CloseVideo()
  self:CloseTick()
  FashionStarVideo.super.OnExit(self)
end
