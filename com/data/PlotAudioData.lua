PlotAudioData = class("PlotAudioData")
PlotAudioData.AudioType = {StoryAudio = 1, PlotAudio = 2}
PlotAudioData.AudioStatus = {
  Default = 0,
  Playing = 1,
  Paused = 2
}

function PlotAudioData:ctor(data)
  if data then
    self.index = data.id
    if data.replacecontext ~= "" then
      self.replaceContext = data.replacecontext
    else
      self.replaceContext = Table_StoryVoice[self.index] and Table_StoryVoice[self.index].VoiceTxt
    end
    self.playtimes = data.times
    self.replace = data.replace
    self.forcestop = data.forcestop
    self.bgmkeep = data.bgmkeep
    if self.index then
      self.bgmPath = Table_StoryVoice[self.index] and Table_StoryVoice[self.index].StoryVoiceID or ""
      self.storyStaticData = Table_StoryVoice[self.index]
    end
  end
end

function PlotAudioData:SetDataByConfig(index)
  if index then
    self.index = index
    self.storyStaticData = Table_StoryVoice[self.index]
    self.replaceContext = self.storyStaticData.VoiceTxt
    self.playtimes = 1
    self.bgmPath = self.storyStaticData and self.storyStaticData.StoryVoiceID or ""
    self.bgmkeep = false
  end
end

function PlotAudioData:SetAudioType(atype)
  self.audioType = atype
end

function PlotAudioData:SetPlayStatus(status)
  self.playStatus = status
end

function PlotAudioData:GetPlayStatus()
  return self.playStatus
end

function PlotAudioData:GetAudioType()
  return self.audioType
end

function PlotAudioData:GetAudioIndex()
  return self.index
end

function PlotAudioData:GetAudioText()
  return self.replaceContext
end

function PlotAudioData:GetBgmPath()
  return self.bgmPath
end

function PlotAudioData:GetPlayTimes()
  return self.playtimes
end

function PlotAudioData:SetBGMCtrl()
end

function PlotAudioData:CheckForceStop()
  return self.forcestop
end

function PlotAudioData:CheckKeepBGM()
  return self.bgmkeep
end

function PlotAudioData:CheckHideText()
  return self.replace == 2
end

function PlotAudioData:CheckDisplay()
  return self.firstDisplay
end

function PlotAudioData:SetDisplay(b)
  self.firstDisplay = b
end

function PlotAudioData:SetBgmKeep(b)
  self.bgmkeep = b
end
