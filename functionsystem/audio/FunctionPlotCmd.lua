autoImport("BgmCtrl")
FunctionPlotCmd = class("FunctionPlotCmd")
FunctionPlotCmd.AudioSort = {
  Default = {priority = 0},
  PlotAudio = {priority = 1},
  NpcVisitVocal = {priority = 1}
}
local IsNull = Slua.IsNull
FunctionPlotCmd.MaxVolume = 1

function FunctionPlotCmd.Me()
  if nil == FunctionPlotCmd.me then
    FunctionPlotCmd.me = FunctionPlotCmd.new()
  end
  return FunctionPlotCmd.me
end

function FunctionPlotCmd:ctor()
  self.currentPlotAudio = nil
  self.currentVolume = FunctionPlotCmd.MaxVolume
  self.mute = false
  self.fadeInStart = 0.5
  self:SetMaxVolume(FunctionPlotCmd.MaxVolume)
end

function FunctionPlotCmd:GetMaxVolume(v)
  return math.min(v, self.currentVolume)
end

function FunctionPlotCmd:SetMute(val)
  self.mute = val
  if self.currentPlotAudio then
    self.currentPlotAudio:SetMute(val)
  end
end

function FunctionPlotCmd:SettingSetVolume(v)
  if 0 <= v and v <= 1 then
    v = FunctionPlotCmd.MaxVolume * v
  end
  self.currentVolume = v
  self:SetMaxVolume(v)
  self:SetVolume(v)
end

function FunctionPlotCmd:SetVolume(v)
  v = self:GetMaxVolume(v)
  if self.currentPlotAudio then
    self.currentPlotAudio:SetVolume(v)
  end
end

function FunctionPlotCmd:SetMaxVolume(v)
  v = self:GetMaxVolume(v)
  if self.currentPlotAudio then
    self.currentPlotAudio:SetMaxVolume(v)
  end
end

function FunctionPlotCmd:SetExtraVolume(v)
  self.plotVolume = v
  if self.currentPlotAudio and self.plotVolume then
    self.currentPlotAudio:SetVolume(v)
  end
end

function FunctionPlotCmd:SetNpcVolumeToggle(on)
  self.plotVolumeToggle = on
  if self.currentPlotAudio and self.plotVolume and self.currentPlotAudio.bgmType == FunctionPlotCmd.AudioSort.NpcVisitVocal then
    self:SetMute(not on)
  end
end

function FunctionPlotCmd:SetCurrentPlotAudio(plotAudio, fade, outDuration, inDuration, fadeInStart, keepBGM)
  self.currentPlotAudio = plotAudio
end

function FunctionPlotCmd:PlayPlotAudio(bgmPath, progress, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
  local seRelativePath = ResourcePathHelper.RelativeAudioPoemStory(bgmPath)
  return self:TryPlaySort(seRelativePath, progress, FunctionPlotCmd.AudioSort.PlotAudio, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
end

function FunctionPlotCmd:PausePlotAudio(fade)
  if self.currentPlotAudio then
    self.currentPlotAudio:Pause(fade)
    return self.currentPlotAudio:GetProgress()
  end
end

function FunctionPlotCmd:GetCurrentProgress()
  if self.currentPlotAudio then
    return self.currentPlotAudio:GetProgress()
  end
end

function FunctionPlotCmd:ResumePlotAudio(progress)
  if self.currentPlotAudio then
    self.currentPlotAudio:SetProgress(progress)
    self.currentPlotAudio:Play()
  end
end

function FunctionPlotCmd:PlayNpcVisitVocal(soundConfig)
  local seRelativePath = AudioUtil.ParseNPCAudioCfgPath(soundConfig)
  return self:TryPlaySort(seRelativePath, progress, FunctionPlotCmd.AudioSort.NpcVisitVocal, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
end

function FunctionPlotCmd:TryPlaySort(seRelativePath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM, force)
  if percent and 1 <= progress then
    redlog("播放音乐超过其总长度,无视此次播放")
    return false
  end
  if self.currentPlotAudio and self.currentPlotAudio.bgmType.priority > playType.priority then
    return false
  end
  local changePlotAudioResult = self:ChangePlotAudio(seRelativePath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, function()
    if finishCallback then
      finishCallback()
    end
    if FunctionPlotCmd.AudioSort.NpcVisitVocal ~= playType then
      FunctionBGMCmd.Me():EndPlotAudio()
    end
  end, keepBGM)
  if changePlotAudioResult == false then
    return false
  end
  if FunctionPlotCmd.AudioSort.NpcVisitVocal ~= playType then
    FunctionBGMCmd.Me():StartPlotAudio()
  end
end

function FunctionPlotCmd:StopPlotAudio(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionPlotCmd.AudioSort.PlotAudio, fallbackDuration, fallbackFadeStartVolumn)
end

function FunctionPlotCmd:StopBgm(playType, fallbackDuration, fallbackFadeStartVolumn)
  if self.currentPlotAudio and self.currentPlotAudio.bgmType == playType then
    self:Clear(fallbackDuration, fallbackFadeStartVolumn)
  end
end

function FunctionPlotCmd:Pause(fade)
  if self.currentPlotAudio then
    self.currentPlotAudio:Pause(fade)
  end
end

function FunctionPlotCmd:UnPause(fade)
  if self.currentPlotAudio then
    self.currentPlotAudio:UnPause(fade)
  end
end

function FunctionPlotCmd:ChangePlotAudio(seRelativePath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
  if AudioManager.Instance ~= nil then
    progress = progress or 0
    local audioSourceType = AudioSourceType.NPC_Poemstory
    if playType and playType == FunctionPlotCmd.AudioSort.NpcVisitVocal then
      audioSourceType = AudioSourceType.NPC_Dialogue
    end
    local async_cb = function(audioSource)
      if not audioSource then
        redlog("audioSource nil seRelativePath: ", seRelativePath)
        return false
      end
      if self.currentPlotAudio ~= nil then
        self.currentPlotAudio:Stop()
      end
      local bgmCtrl = BgmCtrl.new(audioSource, playType, playTimes, 100, nil)
      bgmCtrl:SetFinishCallback(function()
        self:Clear(fallbackDuration, fallbackFadeStartVolumn)
        if finishCallback then
          finishCallback()
        end
      end)
      bgmCtrl:SetMute(self.mute)
      bgmCtrl:SetMaxVolume(self.plotVolume ~= nil and self.plotVolume or self.currentVolume)
      bgmCtrl:SetVolume(self.plotVolume ~= nil and self.plotVolume or self.fadeInStart)
      if percent then
        progress = math.clamp(progress, 0, 0.99)
        progress = progress * audioSource.clip.length
      else
        progress = math.clamp(progress, 0, audioSource.clip.length - 1)
      end
      bgmCtrl:SetProgress(progress)
      bgmCtrl:Play()
      self:SetCurrentPlotAudio(bgmCtrl, true, outDuration, inDuration, nil, keepBGM)
    end
    AudioUtil.AsyncPlayPlot_ByLanguangeSetting(seRelativePath, audioSourceType, async_cb, nil)
  end
end

function FunctionPlotCmd:Clear(fallbackDuration, fallbackFadeStartVolumn)
  if self.currentPlotAudio then
    self.currentPlotAudio:Stop(fallbackDuration)
    self.currentPlotAudio = nil
  end
end

function FunctionPlotCmd:GetCurrentPlayType()
  if self.currentPlotAudio then
    return self.currentPlotAudio.bgmType
  end
end

function FunctionPlotCmd:IsPlayTypeEqualTo(playtype)
  return self:GetCurrentPlayType() == playtype
end
