LuaBgmController = class("LuaBgmController")
local IsNull = Slua.IsNull

function LuaBgmController:ctor(ctrl, type)
  self.type = type
  self.sourceCtl = ctrl
  self.name = name
  self.maxVolume = 1
  self.volume = 1
  self.isPaused = nil
  self.mute = nil
  self.playTimes = 1
  self.looptime = 0
end

function LuaBgmController:SetMute(val)
  if self.mute == val then
    return
  end
  self.mute = val
  self.sourceCtl:SetVolume(val and 0 or self.volume, true)
end

function LuaBgmController:SetMaxVolume(v)
  self.maxVolume = v or 1
end

function LuaBgmController:SetVolume(volume)
  if not volume then
    return
  end
  volume = math.min(volume, self.maxVolume)
  if volume == self.volume then
    return
  end
  self.volume = volume
  self.sourceCtl:SetVolume(volume, true)
end

function LuaBgmController:GetVolume()
  return self.volume
end

function LuaBgmController:IsPlaying()
  return self.sourceCtl:IsPlaying()
end

function LuaBgmController:SetClipAndPlay(clip)
  if IsNull(clip) then
    return
  end
  if self.progress and self.progress > 0 then
    if self.progress_percent then
    else
      self.progress = math.clamp01(self.progress / clip.length)
    end
  else
    self.progress = 0
  end
  self.sourceCtl:ChangeBgm(clip, function()
    if self.unloadBgmPath then
      Game.AssetManager:UnloadBgm(self.unloadBgmPath)
      self.unloadBgmPath = nil
    end
    if self.fadeEndCall then
      self.fadeEndCall()
      self.fadeEndCall = nil
    end
    if self.playTimes then
      self.sourceCtl:SetLoopTimes(self.playTimes, self.playEndCall)
      self.playTimes = nil
      self.playEndCall = nil
    end
  end, self.progress)
  helplog("播放背景音乐", self.bgmPath)
end

function LuaBgmController:_TryLoadHD(clipName)
  local filePath = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/resources/public/audio/bgm_hd/"
  filePath = filePath .. clipName .. ".unity3d"
  if not FileHelper.ExistFile(filePath) then
    return false
  end
  local hdBoundle = AssetBundle.LoadFromFile(filePath)
  if hdBoundle == nil then
    return false
  end
  local hdClip = hdBoundle:LoadAsset(clipName, AudioClip)
  if hdClip == nil then
    return false
  end
  self:SetClipAndPlay(hdClip)
  hdBoundle:Unload(false)
  return true
end

function LuaBgmController:LoadClip()
  local clip = Game.AssetManager:LoadBgm(self.bgmPath)
  if clip then
    self:SetClipAndPlay(clip)
  else
    roerr("Failed To Find Audio", self.bgmPath)
  end
end

function LuaBgmController:SetProgress(progress, percent)
  self.sourceCtl:SetProgress(progress)
end

function LuaBgmController:GetProgress()
  return self.sourceCtl:GetProgress()
end

function LuaBgmController:DoPlay(fadeEndCall)
  self.sourceCtl:Play(fadeEndCall)
end

local Path_AudioBGM = ResourcePathHelper.AudioBGM

function LuaBgmController:Play(bgmName, playTimes, playEndCall, fadeEndCall, progress, progress_percent)
  local bgmPath = ResourcePathHelper.AudioBGM(bgmName)
  self.playTimes = playTimes or 0
  self.playEndCall = playEndCall
  self.fadeEndCall = fadeEndCall
  if progress and progress ~= 0 then
    self.progress = progress
    self.progress_percent = progress_percent
  else
    self.progress = nil
    self.progress_percent = nil
  end
  local clip
  if bgmPath == self.bgmPath then
    local nowState = self.sourceCtl:GetNowState()
    if nowState and nowState.source then
      clip = nowState.source.clip
    end
  end
  if clip then
    self:SetClipAndPlay(clip)
  else
    if self.unloadBgmPath ~= nil then
      Game.AssetManager:UnloadBgm(self.unloadBgmPath)
    end
    self.unloadBgmPath = self.bgmPath
    self.bgmPath = bgmPath
    if self:_TryLoadHD(bgmName) then
      return
    end
    local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
    local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(self.bgmPath))
    if assetname ~= nil then
      _AssetLoadEventDispatcher:AddEventListener(assetname, self.LoadClip, self)
    else
      self:LoadClip()
    end
  end
end

function LuaBgmController:IsPaused()
  return self.isPaused
end

function LuaBgmController:Pause(fadeEndCall)
  if self.isPaused then
    return
  end
  self.isPaused = true
  self.sourceCtl:Pause(true, fadeEndCall)
end

function LuaBgmController:UnPause(fadeEndCall)
  if not self.isPaused then
    return
  end
  self.isPaused = false
  self.sourceCtl:Pause(false, fadeEndCall)
end

function LuaBgmController:Stop(fadeEndCall, clearClip)
  if clearClip == nil then
    clearClip = true
  end
  self.sourceCtl:Stop(fadeEndCall, clearClip)
end

function LuaBgmController:Destroy()
  GameObject.DestroyImmediate(self.sourceCtl.gameObject)
end
