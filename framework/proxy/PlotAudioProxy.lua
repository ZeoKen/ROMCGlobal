autoImport("BgmCtrl")
autoImport("PlotAudioData")
PlotAudioProxy = class("PlotAudioProxy", pm.Proxy)
PlotAudioProxy.Instance = nil
PlotAudioProxy.NAME = "PlotAudioProxy"
local AlmostEqual = NumberUtility.AlmostEqual

function PlotAudioProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PlotAudioProxy.NAME
  if PlotAudioProxy.Instance == nil then
    PlotAudioProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function PlotAudioProxy:Init()
  self.currentPlotAudio = nil
  self.currentStoryAudio = nil
  self.needCenterOn = false
  self.plotVolume = 1
end

function PlotAudioProxy:RecvSoundStoryUserEvent(data)
  local tempAudioData = PlotAudioData.new(data)
  local staticData = tempAudioData.storyStaticData
  if staticData and staticData.StoryType and staticData.StoryType == 1 then
    self.currentStoryAudio = tempAudioData
    self.currentStoryAudio:SetAudioType(PlotAudioData.AudioType.StoryAudio)
    self:PlayPlotAudio(self.currentStoryAudio, function()
      self:ClearCurrentPoemStory()
    end)
    self:SetUIRecord(tempAudioData:GetAudioIndex())
  else
    self.currentPlotAudio = tempAudioData
    self.currentPlotAudio:SetAudioType(PlotAudioData.AudioType.PlotAudio)
    self:PlayPlotAudio(self.currentPlotAudio, function()
      self:ClearCurrentPlotAudio()
    end)
  end
end

function PlotAudioProxy:PlayPoemStory(index, bgmkeep)
  self.currentStoryAudio = PlotAudioData.new()
  self.currentStoryAudio:SetDataByConfig(index)
  self.currentStoryAudio:SetBgmKeep(bgmkeep)
  self.currentStoryAudio:SetAudioType(PlotAudioData.AudioType.StoryAudio)
  self:PlayPlotAudio(self.currentStoryAudio, function()
    self:ClearCurrentPoemStory()
  end)
end

local plotVolumeSetting

function PlotAudioProxy:PlayPlotAudio(audiodata, finishCallback)
  if audiodata then
    if not audiodata:CheckForceStop() then
      local setting = FunctionPerformanceSetting.Me()
      plotVolumeSetting = setting:GetSetting().plotVolume
      if plotVolumeSetting < 0.01 then
        setting:SetBegin()
        setting:SetPlotVolume(1)
        setting:SetEnd()
      end
      if not audiodata:CheckKeepBGM() then
        FunctionBGMCmd.Me():SetMute(true)
      else
        FunctionBGMCmd.Me():SetMute(false)
      end
      self.currentPlayType = audiodata:GetAudioType()
      audiodata:SetPlayStatus(PlotAudioData.AudioStatus.Playing)
      if FunctionMusicBox.Me():IsPlayMusicBoxBg() then
        FunctionMusicBox.Me():DisPlayMusicBoxBg()
      end
      local playResult = FunctionPlotCmd.Me():PlayPlotAudio(audiodata:GetBgmPath(), 0, audiodata:GetPlayTimes(), nil, nil, nil, nil, finishCallback, audiodata:CheckKeepBGM(), self.plotVolume)
      if playResult ~= false then
        GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioStart)
      end
    else
      self:ResetAll()
      GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioEnd)
    end
  end
end

function PlotAudioProxy:StartPlotAudio()
  FunctionBGMCmd.Me():StartPlotAudio()
end

function PlotAudioProxy:StopStoryAudio()
  self.currentPlayType = nil
  FunctionPlotCmd.Me():StopPlotAudio()
  self:ClearCurrentPoemStory()
end

function PlotAudioProxy:PauseCurrentPlotAudio(isLoadingPause)
  local adata = self:GetCurrentAudioData()
  if not adata then
    return
  end
  adata:SetPlayStatus(PlotAudioData.AudioStatus.Paused)
  self.currentAudioProgress = FunctionPlotCmd.Me():PausePlotAudio() or 0
  self:ResumeBGM()
  GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioPause)
end

function PlotAudioProxy:SetLoadingPause(isLoadingPause)
  self.isLoadingPause = isLoadingPause
end

function PlotAudioProxy:ResumeBGM()
  if not (AudioManager and AudioManager.Instance) or not AudioManager.Instance.bgMusic then
    return
  end
  local userdata = Game.Myself.data.userdata
  local soundid = userdata:Get(UDEnum.MUSIC_CURID)
  local starttime = userdata:Get(UDEnum.MUSIC_START)
  local playTimes = userdata:Get(UDEnum.MUSIC_LOOP) == 1 and 0 or 1
  if FunctionMusicBox.Me():IsPlayMusicBoxBg() then
    FunctionMusicBox.Me():SetMusic(soundid, starttime, playTimes, true)
  else
    AudioManager.Instance.bgMusic.volume = FunctionBGMCmd.Me().currentVolume
  end
end

function PlotAudioProxy:SetCurrentAudioProgress()
  local adata = self:GetCurrentAudioData()
  if not adata then
    return
  end
  self.currentAudioProgress = FunctionPlotCmd.Me():GetCurrentProgress()
end

function PlotAudioProxy:ResumeCurrentPlotAudio()
  if not (AudioManager and AudioManager.Instance) or not AudioManager.Instance.bgMusic then
    return
  end
  local adata = self:GetCurrentAudioData()
  if not adata then
    return
  end
  if not adata:CheckKeepBGM() then
    AudioManager.Instance.bgMusic.volume = 0
  else
    AudioManager.Instance.bgMusic.volume = FunctionBGMCmd.Me().currentVolume
  end
  adata:SetPlayStatus(PlotAudioData.AudioStatus.Playing)
  if self.currentPlayType == PlotAudioData.AudioType.PlotAudio then
    FunctionPlotCmd.Me():PlayPlotAudio(adata:GetBgmPath(), self.currentAudioProgress, adata:GetPlayTimes(), nil, nil, nil, nil, function()
      self:ClearCurrentPlotAudio()
    end, adata:CheckKeepBGM(), self.plotVolume)
  elseif self.currentPlayType == PlotAudioData.AudioType.StoryAudio then
    FunctionPlotCmd.Me():PlayPlotAudio(adata:GetBgmPath(), self.currentAudioProgress, adata:GetPlayTimes(), nil, nil, nil, nil, function()
      self:ClearCurrentPoemStory()
    end, adata:CheckKeepBGM(), self.plotVolume)
  end
  GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioResume)
end

function PlotAudioProxy:GetCurrentPlotAudio()
  return self.currentPlotAudio
end

function PlotAudioProxy:GetCurrentStoryAudio()
  return self.currentStoryAudio
end

function PlotAudioProxy:GetCurrentPlayType()
  return self.currentPlayType
end

function PlotAudioProxy:GetCurrentAudioData()
  if self.currentPlayType == PlotAudioData.AudioType.PlotAudio then
    return self.currentPlotAudio
  elseif self.currentPlayType == PlotAudioData.AudioType.StoryAudio then
    return self.currentStoryAudio
  end
end

function PlotAudioProxy:ClearCurrentPlotAudio()
  self.currentPlotAudio = nil
  self.currentPlayType = nil
  FunctionBGMCmd.Me():EndPlotAudio()
  self:ResumeBGM()
  GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioEnd)
end

function PlotAudioProxy:ClearCurrentPoemStory()
  self.currentStoryAudio = nil
  self.currentPlayType = nil
  FunctionBGMCmd.Me():EndPlotAudio()
  self:ResumeBGM()
  GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioEnd)
end

function PlotAudioProxy:ResetAll()
  local adata = self:GetCurrentAudioData()
  if adata then
    FunctionPlotCmd.Me():StopPlotAudio()
    self.currentPlayType = nil
    self.currentStoryAudio = nil
    self.currentPlayType = nil
    FunctionBGMCmd.Me():EndPlotAudio()
    self:ResumeBGM()
    GameFacade.Instance:sendNotification(StoryAudioEvent.StoryAudioEnd)
  end
end

function PlotAudioProxy:SetUIRecord(audioIndex, mapIndex)
  local versionlist = QuestManualProxy.Instance:GetVersionlist()
  local versionConfig = Table_PomeStory[audioIndex] and Table_PomeStory[audioIndex].version
  if versionConfig and versionlist then
    for i = 1, #versionConfig do
      for j = 1, #versionlist do
        if AlmostEqual(versionConfig[i], versionlist[j].version) then
          self.audioVersion = j
          self.audioTab = 4
          self.audioIndex = audioIndex
          self.needCenterOn = true
          return
        end
      end
    end
  end
end

function PlotAudioProxy:CheckPlayStatus()
  local adata = self:GetCurrentAudioData()
  if adata then
    return adata:GetPlayStatus() == PlotAudioData.AudioStatus.Playing
  end
  return false
end

function PlotAudioProxy:SetPlotVolume(volume)
  self.plotVolume = volume
end

function PlotAudioProxy:GetPlotVolume()
  return self.plotVolume
end
