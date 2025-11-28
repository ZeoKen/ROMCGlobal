autoImport("LuaBgmController")
FunctionBGMCmd = class("FunctionBGMCmd")
FunctionBGMCmd.BgmSort = {
  Default = 1,
  Region = 2,
  Mission = 3,
  JukeBox = 4,
  Activity = 5,
  UI = 6,
  PlotAudio = 7
}
local BgmSortPriority = {
  [FunctionBGMCmd.BgmSort.Default] = 1,
  [FunctionBGMCmd.BgmSort.Region] = 2,
  [FunctionBGMCmd.BgmSort.Mission] = 3,
  [FunctionBGMCmd.BgmSort.JukeBox] = 4,
  [FunctionBGMCmd.BgmSort.Activity] = 5,
  [FunctionBGMCmd.BgmSort.UI] = 6,
  [FunctionBGMCmd.BgmSort.PlotAudio] = 7
}
local IsNull = Slua.IsNull
FunctionBGMCmd.MaxVolume = 0.5

function FunctionBGMCmd.Me()
  if nil == FunctionBGMCmd.me then
    FunctionBGMCmd.me = FunctionBGMCmd.new()
  end
  return FunctionBGMCmd.me
end

function FunctionBGMCmd:ctor()
  self.currentVolume = FunctionBGMCmd.MaxVolume
  self.mute = false
  self.fadeInStart = 0
  self.fadeinDuration = 1.5
  self.bgmMgrGO = Game.AssetManager_UI:CreateAsset("Public/Audio/BgmManager")
  GameObject.DontDestroyOnLoad(self.bgmMgrGO)
  local dctl = UIUtil.FindComponent("Default", BgmController, self.bgmMgrGO)
  self.defaultCtl = LuaBgmController.new(dctl)
  local octl = UIUtil.FindComponent("Other", BgmController, self.bgmMgrGO)
  self.otherCtl = LuaBgmController.new(octl)
  self:SetMaxVolume(FunctionBGMCmd.MaxVolume)
  self:SetVolume(FunctionBGMCmd.MaxVolume)
  self.extraVolume = nil
end

function FunctionBGMCmd:ResetDefault()
  if not self.defaultCtl:IsPlaying() or self.defaultCtl:IsPaused() then
    self.defaultCtl:UnPause()
  end
  if self.otherCtl:IsPlaying() then
    self.otherCtl:Stop()
  end
  self.playType = FunctionBGMCmd.BgmSort.Default
  self.nowCtl = self.defaultCtl
end

function FunctionBGMCmd:StartSpeakVoice()
  self:SetVolume(0.2 * self.currentVolume)
end

function FunctionBGMCmd:EndSpeakVoice()
  self:SetVolume(self.currentVolume)
end

function FunctionBGMCmd:StartSolo()
  self:SetVolume(0.2 * self.currentVolume)
end

function FunctionBGMCmd:EndSolo()
  self:SetVolume(self.currentVolume)
end

function FunctionBGMCmd:StartPlotAudio()
  self:SetVolume(0.2 * self.currentVolume)
end

function FunctionBGMCmd:EndPlotAudio()
  self:SetVolume(self.currentVolume)
end

function FunctionBGMCmd:GetMaxVolume(v)
  return math.min(v, self.currentVolume)
end

function FunctionBGMCmd:SetMute(val)
  self.mute = val
  self.defaultCtl:SetMute(val)
  self.otherCtl:SetMute(val)
end

function FunctionBGMCmd:IsMute()
  return self.mute
end

function FunctionBGMCmd:GetVolume()
  return self.nowCtl:GetVolume()
end

function FunctionBGMCmd:SettingSetVolume(v)
  if 0 <= v and v <= 1 then
    v = FunctionBGMCmd.MaxVolume * v
  end
  AudioManager.volume = v
  self.currentVolume = v
  self:SetMaxVolume(v)
  self:SetVolume(v)
end

function FunctionBGMCmd:SetVolume(v)
  v = self:GetMaxVolume(v)
  if self.defaultCtl then
    self.defaultCtl:SetVolume(v)
  end
  if self.otherCtl then
    self.otherCtl:SetVolume(v)
  end
end

function FunctionBGMCmd:SetMaxVolume(v)
  v = self:GetMaxVolume(v)
  if self.defaultCtl then
    self.defaultCtl:SetMaxVolume(v)
    self.otherCtl:SetMaxVolume(v)
  end
end

function FunctionBGMCmd:SetExtraVolume(v)
  self.extraVolume = v
  AudioManager.volume = v
  self.defaultCtl:SetMaxVolume(v)
  self.otherCtl:SetMaxVolume(v)
end

function FunctionBGMCmd:GetDefaultBGM()
  return self.defaultCtl
end

function FunctionBGMCmd:PlayJukeBox(bgmPath, progress, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, force)
  self:TryPlayBGMSort(bgmPath, progress, FunctionBGMCmd.BgmSort.JukeBox, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, nil, nil, force)
end

function FunctionBGMCmd:StopJukeBox(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.JukeBox, fallbackDuration, fallbackFadeStartVolumn)
end

function FunctionBGMCmd:PlayMissionBgm(bgmPath, playTimes)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Mission, false, playTimes)
end

function FunctionBGMCmd:StopMissionBgm(defaultBgmFromStart)
  if defaultBgmFromStart then
    self.defaultCtl:SetProgress(0)
  end
  self:StopBgm(FunctionBGMCmd.BgmSort.Mission)
end

function FunctionBGMCmd:PlayActivityBgm(bgmPath, playTimes)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Activity, false, playTimes)
end

function FunctionBGMCmd:StopActivityBgm()
  self:StopBgm(FunctionBGMCmd.BgmSort.Activity)
end

function FunctionBGMCmd:PlayUIBgm(bgmPath, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.UI, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback)
end

function FunctionBGMCmd:StopUIBgm(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.UI, fallbackDuration, fallbackFadeStartVolumn)
end

function FunctionBGMCmd:PlayRegionBgm(bgmPath, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Region, false, playTimes or 0, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback)
end

function FunctionBGMCmd:StopRegionBgm(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.Region, fallbackDuration, fallbackFadeStartVolumn)
end

function FunctionBGMCmd:PlayPlotAudio(bgmPath, progress, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM, extraVolume)
  self.extraVolume = extraVolume
  self:TryPlayBGMSort(bgmPath, progress, FunctionBGMCmd.BgmSort.PlotAudio, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
end

function FunctionBGMCmd:StopPlotAudio(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.PlotAudio, fallbackDuration, fallbackFadeStartVolumn)
end

function FunctionBGMCmd:PausePlotAudio(fade)
  self.otherCtl:Pause()
  return self.otherCtl:GetProgress()
end

function FunctionBGMCmd:GetCurrentProgress()
  if self.nowCtl then
    return self.nowCtl:GetProgress()
  end
end

function FunctionBGMCmd:ResumePlotAudio(progress)
  if self.nowCtl then
    if progress then
      self.nowCtl:SetProgress(progress)
    end
    self.nowCtl:Play()
  end
end

function FunctionBGMCmd:ReplaceCurrentBgm(bgmPath)
  self:PlayDefaultBgm(bgmPath)
end

function FunctionBGMCmd:PlayDefaultBgm(bgmPath)
  self:ResetDefault()
  self:TryPlayBGMSort(bgmPath, nil, FunctionBGMCmd.BgmSort.Default, nil, 0)
end

function FunctionBGMCmd:TryPlayBGMSort(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM, force)
  if percent and 1 <= progress then
    redlog("播放音乐超过其总长度,无视此次播放")
    return
  end
  if not force and self.playType and BgmSortPriority[self.playType] > BgmSortPriority[playType] then
    redlog("优先级过低", self.playType, playType)
    return
  end
  self:ChangeBGM(bgmPath, progress, playType, percent, playTimes, finishCallback, keepBGM)
end

function FunctionBGMCmd:StopBgm(playType, fallbackDuration, fallbackFadeStartVolumn)
  if self.playType ~= playType then
    return
  end
  if self.nowCtl then
    self.nowCtl:Stop()
  end
  if playType ~= FunctionBGMCmd.BgmSort.Default then
    self:ResetDefault()
  end
end

function FunctionBGMCmd:Pause(fade)
  if self.nowCtl then
    self.nowCtl:Pause()
  end
end

function FunctionBGMCmd:UnPause(fade)
  if self.nowCtl then
    self.nowCtl:UnPause()
  end
end

function FunctionBGMCmd:GetNowBgm()
  return self.bgmPath, self.playType
end

local nowBgmPath

function FunctionBGMCmd:ChangeBGM(bgmPath, progress, playType, percent, playTimes, finishCallback, keepBGM)
  self.playType = playType
  self.bgmPath = bgmPath
  local nowCtl
  if playType == FunctionBGMCmd.BgmSort.Default or playType == FunctionBGMCmd.BgmSort.Region then
    nowCtl = self.defaultCtl
  else
    nowCtl = self.otherCtl
  end
  if nowCtl ~= self.nowCtl then
    if self.nowCtl == self.defaultCtl then
      if not keepBGM then
        self.nowCtl:Pause()
      end
    else
      self.nowCtl:Stop()
    end
  end
  self.nowCtl = nowCtl
  nowCtl:SetMute(self.mute)
  nowCtl:SetMaxVolume(self.extraVolume ~= nil and self.extraVolume or self.currentVolume)
  if playTimes == 0 then
    nowCtl:Play(bgmPath, nil, nil, nil, progress, percent)
  else
    nowCtl:Play(bgmPath, playTimes, function()
      if finishCallback then
        finishCallback()
      end
      self:ResetDefault()
    end, nil, progress, percent)
  end
end

function FunctionBGMCmd:IsDefaultBGM()
  return self.playType == FunctionBGMCmd.BgmSort.Default
end

function FunctionBGMCmd:Destroy()
  if not IsNull(self.bgmMgrGO) then
    GameObject.DestroyImmediate(self.bgmMgrGO)
  end
end
