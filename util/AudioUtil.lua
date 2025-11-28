AudioUtil = {}

function AudioUtil.PlayNpcVisitVocal(soundConfig)
  local sSoundConfigs = string.split(soundConfig, ";")
  local length = #sSoundConfigs
  if length == 0 then
    return
  end
  local soundConfigMap = {}
  local defaultConfig
  for i = 1, #sSoundConfigs do
    local sConfigs = string.split(sSoundConfigs[i], ":")
    if #sConfigs == 1 then
      defaultConfig = sConfigs[1]
    elseif #sConfigs == 2 then
      soundConfigMap[sConfigs[1]] = sConfigs[2]
    end
  end
  if soundConfigMap.M and soundConfigMap.F then
    if Game.Myself then
      local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
      if gender == 1 then
        AudioUtil.Play2DRandomSound(soundConfigMap.M)
      elseif gender == 2 then
        AudioUtil.Play2DRandomSound(soundConfigMap.F)
      end
    end
  elseif defaultConfig then
    AudioUtil.Play2DRandomSound(defaultConfig)
  end
end

function AudioUtil.Play2DRandomSound(soundConfig)
  if soundConfig ~= "" then
    local paths = string.split(soundConfig, "-")
    local rdmIndex = math.random(1, #paths)
    if rdmIndex then
      AudioUtil.PlaySound_ByLanguangeSetting(paths[rdmIndex])
    end
  end
end

function AudioUtil.SPlayOn_ByLanguangeSetting(path, audioSourceType)
  local clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  if clip then
    local audioSource = AudioHelper.Play_At(clip, 0, 0, 0, 0, audioSourceType or AudioSourceType.BGM_Music)
    return audioSource
  end
end

function AudioUtil.PlayPlot_ByLanguangeSetting(path, audioSourceType)
  local clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  if clip then
    local audioSource = AudioHelper.PlayPlot_At(clip, 0, 0, 0, 0, audioSourceType or AudioSourceType.NPC_Poemstory)
    return audioSource
  end
end

function AudioUtil.AsyncPlayPlot_ByLanguangeSetting(path, audioSourceType, cb, cbArgs)
  local stCheck = AudioUtil.AsyncGetSound_ByLanguangeSetting(path, function(clip)
    if clip then
      local audioSource = AudioHelper.PlayPlot_At(clip, 0, 0, 0, 0, audioSourceType or AudioSourceType.NPC_Poemstory)
      if cb then
        cb(audioSource, cbArgs)
      end
    end
  end)
  if stCheck == 2 then
    redlog("QUESTSE", "MISS", path)
  end
end

function AudioUtil.PlaySound_ByLanguangeSetting(path, audioSourceType)
  local clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  if clip then
    AudioUtility.PlayOneShot2DSingle_Clip(clip, audioSourceType or AudioSourceType.NPC)
  end
end

local SubFoldersIgnoreCase

function AudioUtil.GetSound_ByLanguangeSetting(path)
  local fullPath, clip
  local voice = FunctionPerformanceSetting.Me():GetLanguangeVoice()
  fullPath = ResourcePathHelper.NewAudioSE(path)
  if voice ~= LanguageVoice.Chinese then
    if not SubFoldersIgnoreCase then
      SubFoldersIgnoreCase = {}
      for i = 1, #GameConfig.SEBranchSetting.SubFolders do
        TableUtility.ArrayPushBack(SubFoldersIgnoreCase, string.upper(GameConfig.SEBranchSetting.SubFolders[i]))
      end
    end
    local pathSp = string.split(path, "/")
    local isSubFolderSE = 1 < #pathSp and TableUtility.ArrayFindIndex(SubFoldersIgnoreCase, string.upper(pathSp[1])) > 0
    if isSubFolderSE then
      if voice == LanguageVoice.Jananese then
        fullPath = ResourcePathHelper.AudioSE_JP(path)
        if not ResourceManager.Instance:ExistAssets(fullPath, "resources/", "") then
          return
        end
      elseif voice == LanguageVoice.Korean then
        fullPath = ResourcePathHelper.AudioSE_KR(path)
      end
    end
  end
  clip = Game.AssetManager:LoadByType(fullPath, AudioClip)
  return clip
end

function AudioUtil.AsyncGetSound_ByLanguangeSetting(path, cb)
  local fullPath, clip
  local voice = FunctionPerformanceSetting.Me():GetLanguangeVoice()
  fullPath = ResourcePathHelper.NewAudioSE(path)
  if voice ~= LanguageVoice.Chinese then
    if not SubFoldersIgnoreCase then
      SubFoldersIgnoreCase = {}
      for i = 1, #GameConfig.SEBranchSetting.SubFolders do
        TableUtility.ArrayPushBack(SubFoldersIgnoreCase, string.upper(GameConfig.SEBranchSetting.SubFolders[i]))
      end
    end
    local pathSp = string.split(path, "/")
    local isSubFolderSE = 1 < #pathSp and TableUtility.ArrayFindIndex(SubFoldersIgnoreCase, string.upper(pathSp[1])) > 0
    if isSubFolderSE then
      if voice == LanguageVoice.Jananese then
        fullPath = ResourcePathHelper.AudioSE_JP(path)
      elseif voice == LanguageVoice.Korean then
        fullPath = ResourcePathHelper.AudioSE_KR(path)
      end
    end
  end
  local success_get_clip_action = function()
    if voice == LanguageVoice.Jananese and not ResourceManager.Instance:ExistAssets(fullPath, "resources/", "") then
      return
    end
    clip = Game.AssetManager:LoadByType(fullPath, AudioClip)
    if cb then
      cb(clip)
    end
  end
  local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
  local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(fullPath))
  if assetname ~= nil then
    _AssetLoadEventDispatcher:AddEventListener(assetname, success_get_clip_action, _AssetLoadEventDispatcher)
    return 2
  else
    success_get_clip_action()
    return 1
  end
end

local lang_branches = {
  "cn",
  "jp",
  "kr"
}

function AudioUtil.TryLoadNPCAudioFromDownload(oriPath, voice)
  local pathSp = string.split(oriPath, "/")
  local clipName = pathSp[#pathSp]
  local branch = lang_branches[voice]
  oriPath = string.lower(oriPath)
  redlog("converted oripath", oriPath)
  local filePath = ApplicationHelper.persistentDataPath .. string.format("/%s/resources/public/audio/se/%s/%s.unity3d", ApplicationInfo.GetRunPlatformStr(), branch, oriPath)
  redlog("TryLoadNPCAudioFromDownload", "filePath ", filePath)
  if not FileHelper.ExistFile(filePath) then
    redlog("TryLoadNPCAudioFromDownload", "file not exist!")
    return
  end
  local bundle = AssetBundle.LoadFromFile(filePath)
  if bundle == nil then
    return
  end
  local clip = bundle:LoadAsset(clipName, AudioClip)
  bundle:Unload(false)
  return clip
end

function AudioUtil.ParseNPCAudioCfgPath(soundConfig)
  local sSoundConfigs = string.split(soundConfig, ";")
  local length = #sSoundConfigs
  if length == 0 then
    return
  end
  local soundConfigMap = {}
  local defaultConfig
  for i = 1, #sSoundConfigs do
    local sConfigs = string.split(sSoundConfigs[i], ":")
    if #sConfigs == 1 then
      defaultConfig = sConfigs[1]
    elseif #sConfigs == 2 then
      soundConfigMap[sConfigs[1]] = sConfigs[2]
    end
  end
  if soundConfigMap.M and soundConfigMap.F then
    if Game.Myself then
      local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
      if gender == 1 then
        return AudioUtil.PreParsePath(soundConfigMap.M)
      elseif gender == 2 then
        return AudioUtil.PreParsePath(soundConfigMap.F)
      end
    end
  elseif defaultConfig then
    return AudioUtil.PreParsePath(defaultConfig)
  end
end

function AudioUtil.PreParsePath(soundConfig)
  if soundConfig ~= "" then
    local paths = string.split(soundConfig, "-")
    local rdmIndex = math.random(1, #paths)
    if rdmIndex then
      return paths[rdmIndex]
    end
  end
end
