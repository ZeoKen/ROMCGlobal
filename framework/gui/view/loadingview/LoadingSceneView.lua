autoImport("DefaultLoadModeView")
autoImport("IllustrationModeView")
autoImport("NewExploreModeView")
autoImport("QuickWithoutProgressView")
autoImport("LoadingThanatosView")
LoadingSceneView = class("LoadingSceneView", ContainerView)
LoadingSceneView.ViewType = UIViewType.LoadingLayer
LoadingSceneView.ServerReceiveLoaded = "LoadingSceneView.ServerReceiveLoaded"

function LoadingSceneView:Init()
  self.currentView = nil
  self:InitSubs()
  local panel = self.gameObject:GetComponent(UIPanel)
  self.loadingViewDepth = panel.depth
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(PanelConfig.LoadingViewDefault.tab)
  end
  self.timeTick = TimeTickManager.Me():CreateTick(0, 16, self.Update, self, 1)
  self:AddViewListeners()
  self.blackBg = self:FindGO("BlackBg"):GetComponent(UISprite)
  self:AddClickEvent(self.blackBg.gameObject, nil, {hideClickSound = true})
end

function LoadingSceneView:InitSubs()
  self:AddTabChangeEvent(nil, self:FindGO("DefaultMode"), PanelConfig.LoadingViewDefault)
  self:AddTabChangeEvent(nil, self:FindGO("IllustrationMode"), PanelConfig.LoadingViewIllustration)
  self:AddTabChangeEvent(nil, self:FindGO("NewExploreMode"), PanelConfig.LoadingViewNewExplore)
  self:AddTabChangeEvent(nil, self:FindGO("QuickWithoutProgress"), PanelConfig.LoadingViewQuickWithoutProgress)
  self:AddTabChangeEvent(nil, self:FindGO("LoadingViewThanatos"), PanelConfig.LoadingViewThanatos)
end

function LoadingSceneView:TabChangeHandler(key)
  LoadingSceneView.super.TabChangeHandler(self, key)
  if key == PanelConfig.LoadingViewDefault.tab then
    self.currentView = self:AddSubView("DefaultLoadModeView", DefaultLoadModeView)
  elseif key == PanelConfig.LoadingViewIllustration.tab then
    self.currentView = self:AddSubView("IllustrationModeView", IllustrationModeView)
  elseif key == PanelConfig.LoadingViewNewExplore.tab then
    self.currentView = self:AddSubView("NewExploreModeView", NewExploreModeView)
  elseif key == PanelConfig.LoadingViewQuickWithoutProgress.tab then
    self.currentView = self:AddSubView("QuickWithoutProgressView", NewExploreModeView)
  elseif key == PanelConfig.LoadingViewThanatos.tab then
    self.currentView = self:AddSubView("LoadingThanatosView", LoadingThanatosView)
  end
end

function LoadingSceneView:OnEnter()
  LoadingSceneView.super.OnEnter(self)
  Game.PerformanceManager:SetUICameraClearAll(true)
end

function LoadingSceneView:OnExit()
  LoadingSceneView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
  self:ClearSafeDelayClose()
  Game.PerformanceManager:SetUICameraClearAll(false)
end

function LoadingSceneView:AddViewListeners()
  self:AddListenEvt(LoadEvent.SceneFadeOut, self.SceneFadeOut)
  self:AddListenEvt(LoadEvent.StartLoadScene, self.StartLoadScene)
  self:AddListenEvt(ServiceEvent.Error, self.HandlerServiceError)
  self:AddListenEvt(ServiceEvent.ConnNetDown, self.HandlerConnDown)
  self:AddListenEvt(LoadSceneEvent.CloseLoadView, self.CloseSelf)
  self:AddListenEvt(DownloadEvent.Downloading, self.OnDownloadEvent)
  self:AddListenEvt(DownloadEvent.Downloaded, self.OnDownloadEvent)
end

function LoadingSceneView:HandlerServiceError(note)
  self.serverError = true
  self:CheckNetError()
end

function LoadingSceneView:HandlerConnDown(note)
  self.serverError = true
  self:CheckNetError()
end

function LoadingSceneView:SceneFadeOut(note)
  LeanTween.cancel(self.blackBg.gameObject)
  self.currentView:SceneFadeOut()
end

function LoadingSceneView:DoFadeOut(duration, alpha)
  duration = duration ~= nil and duration or 0.1
  local videoQuest = FunctionQuest.Me():getMediaQuest(SceneProxy.Instance.currentScene.mapID)
  if videoQuest then
    duration = 2
  end
  self.blackBg.alpha = alpha or 0
  local tweenAlpha = TweenAlpha.Begin(self.blackBg.gameObject, duration, 1)
  tweenAlpha:SetOnFinished(function()
    if videoQuest then
      SceneProxy.Instance:EnableLoaderFadeBGM(false)
    end
    self:StartLoad()
  end)
end

function LoadingSceneView:DoFadeIn(duration)
  duration = duration ~= nil and duration or 1.5
  self.blackBg.alpha = 1
  LeanTween.cancel(self.blackBg.gameObject)
  self.lt = LeanTween.alphaNGUI(self.blackBg, 1, 0, duration):setOnComplete(function()
    self:SceneFadeInFinish()
  end)
end

function LoadingSceneView:StepPlayVideo()
  self.needPlayVideo = FunctionQuest.Me():playMediaQuest(SceneProxy.Instance.currentScene.mapID)
  if not self.needPlayVideo then
    self:StartLoad()
  else
    SceneProxy.Instance:EnableLoaderFadeBGM(false)
  end
end

function LoadingSceneView:StartLoad()
  self:SceneFadeOutFinish()
  SceneProxy.Instance:SyncLoad("LoadScene")
  if self.delayTick then
    TimeTickManager.Me():ClearTick(self, 111)
    self.delayTick = nil
  end
  self.delayTick = TimeTickManager.Me():CreateOnceDelayTick(100, function()
    self.delayTick = nil
    ResourceManager.Instance:GC()
  end, self, 111)
end

function LoadingSceneView:FinishPlayVideo()
  if self.needPlayVideo then
    self:StartLoad()
  end
end

function LoadingSceneView:SceneFadeOutFinish()
  self.currentView:SceneFadeOutFinish()
end

function LoadingSceneView:SceneFadeInFinish()
  self.currentView:SceneFadeInFinish()
end

function LoadingSceneView:LoadFinish()
  self.currentView:LoadFinish()
end

function LoadingSceneView:CheckNetError()
  if self.serverError and self.Loaded then
    FunctionMapEnd.Me():Launch()
  end
end

function LoadingSceneView:FireLoadFinishEvent()
  self:CheckNetError()
  self:sendNotification(ServiceEvent.PlayerMapChange, self.sceneInfo, LoadSceneEvent.FinishLoad)
  FunctionQuest.Me():playMediaQuest(SceneProxy.Instance.currentScene.mapID)
  local mapID = SceneProxy.Instance.currentScene and SceneProxy.Instance.currentScene.mapID or 0
  Buglylog("LoadingSceneView FireLoadFinishEvent:" .. mapID)
end

function LoadingSceneView:StartLoadScene(note)
  self.currentView:StartLoadScene(note)
  self.sceneInfo = note.body
  self.Loaded = false
  SceneProxy.Instance:SetLoadFinish(function(info)
    self.Loaded = true
    TimeTickManager.Me():ClearTick(self)
    self:LoadFinish()
  end)
  if self.timeTick then
    self.timeTick:Restart()
  end
  local mapID = SceneProxy.Instance.currentScene and SceneProxy.Instance.currentScene.mapID or 0
  Buglylog("LoadingSceneView StartLoadScene:" .. mapID)
end

function LoadingSceneView:Update(delta)
  self.currentView:Update(delta)
end

function LoadingSceneView:ClearSafeDelayClose()
  local timer = self.safeCloseTimer
  if timer ~= nil then
    timer:ClearTick()
    self.safeCloseTimer = nil
  end
end

function LoadingSceneView:SafeDelayClose(noDelayClose)
  self:ClearSafeDelayClose()
  if not noDelayClose then
    self.safeCloseTimer = TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
      self:CloseSelf()
    end, self)
  end
end

function LoadingSceneView:CloseSelf()
  LoadingSceneView.super.CloseSelf(self)
  FunctionChangeScene.Me():TriggerSceneLoadFinishActionForOnce()
end
