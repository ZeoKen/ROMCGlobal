ApplicationInfo = {}
local screenSize = NGUITools.screenSize
local systemMemorySize = SystemInfo.systemMemorySize
local targetFrameRate = Application.targetFrameRate

function ApplicationInfo.GetRunPlatform()
  return Application.platform
end

function ApplicationInfo.IsRunOnEditor()
  if ApplicationInfo.isEditor ~= nil then
    return ApplicationInfo.isEditor
  end
  local platform = ApplicationInfo.GetRunPlatform()
  ApplicationInfo.isEditor = platform == RuntimePlatform.OSXEditor or platform == RuntimePlatform.WindowsEditor
  return ApplicationInfo.isEditor
end

function ApplicationInfo.IsWindows()
  return ApplicationInfo.IsRunOnWindowns()
end

function ApplicationInfo.IsMobile()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.IPhonePlayer then
    return true
  end
  return false
end

function ApplicationInfo.IsRunOnMSWindows()
  return Application.platform == RuntimePlatform.WindowsPlayer
end

function ApplicationInfo.IsPcWebPay()
  if ApplicationInfo.IsRunOnWindowns() and (BranchMgr.IsTW() or BranchMgr.IsJapan() or BranchMgr.IsKorea()) then
    return true
  else
    return false
  end
end

function ApplicationInfo.IsRunOnWindowns()
  local platform = ApplicationInfo.GetRunPlatform()
  if ApplicationInfo.TEST_WINDOWS_ON_EDITOR == nil then
    ApplicationInfo.TEST_WINDOWS_ON_EDITOR = PlayerPrefs.GetInt("ApplicationInfo.TEST_WINDOWS_ON_EDITOR", 0) == 1
  end
  if ApplicationInfo.TEST_WINDOWS_ON_EDITOR then
    return platform == RuntimePlatform.WindowsPlayer or ApplicationInfo.IsRunOnEditor()
  end
  return platform == RuntimePlatform.WindowsPlayer
end

function ApplicationInfo.EnableTestWindowsOnEditor(enable)
  if not ApplicationInfo.IsRunOnEditor() then
    return
  end
  if enable then
    ApplicationInfo.TEST_WINDOWS_ON_EDITOR = true
    PlayerPrefs.SetInt("ApplicationInfo.TEST_WINDOWS_ON_EDITOR", 1)
    PlayerPrefs.Save()
    if ApplicationInfo.IsRunOnWindowns() then
      LocalSaveProxy.Instance:ClearSetting()
      Game.InputKey = InputKey and InputKey.Instance
      Game.WindowSetting = WindowSetting and WindowSetting.Instance
      Game.HotKeyManager:Init()
      Game.HotKeyManager:Launch()
      UIManagerProxy.Instance:NeedEnableAndroidKey(false)
    end
  else
    ApplicationInfo.TEST_WINDOWS_ON_EDITOR = nil
    PlayerPrefs.SetInt("ApplicationInfo.TEST_WINDOWS_ON_EDITOR", 0)
    PlayerPrefs.Save()
    LocalSaveProxy.Instance:ClearSetting()
    Game.HotKeyManager:Shutdown()
    UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  end
end

function ApplicationInfo.OpenPCRechargeUrl()
  if not ApplicationInfo.IsRunOnWindowns() then
    return
  end
  local url = GameConfig.NewRecharge.PCRechargeUrl
  if url then
    ApplicationInfo.OpenUrl(url)
  end
end

local isRunOnEmulator

function ApplicationInfo.IsEmulator()
  if isRunOnEmulator == nil then
    isRunOnEmulator = ExternalInterfaces.IsEmulator()
    redlog("is emulator :" .. tostring(isRunOnEmulator))
  end
  return isRunOnEmulator
end

function ApplicationInfo.GetVersion()
  return Application.version
end

function ApplicationInfo.GetScreenSize()
  return screenSize
end

local isAndroidNotchScreen

function ApplicationInfo.TrySetSafeAreaSides(l, t, r, b, ignoreAndroidNotchScreenCheck)
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    return
  end
  if isAndroidNotchScreen == nil and ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    isAndroidNotchScreen = ExternalInterfaces.IsNotchScreen()
  end
  if not ignoreAndroidNotchScreenCheck and isAndroidNotchScreen == false then
    SafeArea.on = false
    LogUtility.Warning("Not NotchScreen. SafeArea.on is set to false.")
    return
  end
  SafeArea.on = true
  local ins = SafeArea.Instance
  ins.l = l
  ins.t = t
  ins.r = r
  ins.b = b
end

function ApplicationInfo.OpenUrl(url)
  if type(url) == "string" and url:sub(0, 7) == "sysurl:" then
    Application.OpenURL(url:sub(8))
    return
  end
  if ApplicationInfo.IsWindows() or ApplicationInfo.IsRunOnEditor() then
    Application.OpenURL(url)
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WebViewPanel,
      viewdata = {directurl = url}
    })
  end
end

function ApplicationInfo.GetSystemLanguage()
  return OverSea.LangManager.Instance():CurLangInt()
end

function ApplicationInfo.Quit()
  if not BackwardCompatibilityUtil.CompatibilityMode_V69 then
    ApplicationHelper.Quit()
  else
    Application.Quit()
  end
end

function ApplicationInfo.CopyToSystemClipboard(contents)
  return ClipboardManager.CopyToClipBoard(contents) == 0
end

function ApplicationInfo.GetCopyBuffer()
  return ClipboardManager.GetCopyBuffer()
end

function ApplicationInfo.GetRunPlatformStr()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  local phoneplat = "editor"
  if runtimePlatform == RuntimePlatform.Android then
    phoneplat = "Android"
  elseif runtimePlatform == RuntimePlatform.IPhonePlayer then
    phoneplat = "iOS"
  elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
    phoneplat = "Windows"
  elseif runtimePlatform == RuntimePlatform.WindowsEditor then
    phoneplat = "Windows"
  elseif runtimePlatform == RuntimePlatform.OSXEditor then
    phoneplat = "OSX"
  end
  return phoneplat
end

function ApplicationInfo.NeedOpenVoiceRealtime()
  return false
end

function ApplicationInfo.NeedOpenVoiceSend()
  if ApplicationInfo.IsWindows() then
    if GameConfig.SystemForbid.OpenVoiceSendForWindows then
      return false
    else
      return true
    end
  elseif GameConfig.SystemForbid.OpenVoiceSend then
    return false
  else
    return true
  end
end

function ApplicationInfo.IsIOSVersionUnder(v)
  if type(v) ~= "number" then
    return false
  end
  if Application.platform ~= RuntimePlatform.IPhonePlayer then
    return false
  end
  local version = ExternalInterfaces.GetIOSVersion()
  if version == nil then
    return false
  end
  local version_s = string.split(version, ".")
  version = version_s[1] and tonumber(version_s[1]) or nil
  if version and v >= version then
    return true
  end
  return false
end

function ApplicationInfo.IsDebugModeForWindows()
  return true
end

function ApplicationInfo.GetSystemMemorySize()
  return systemMemorySize
end

function ApplicationInfo.SetTargetFrameRate(frameRate)
  if frameRate ~= 30 and frameRate ~= 60 and frameRate ~= 45 then
    return
  end
  targetFrameRate = frameRate
  RenderingManager.Instance:SetCustomFrameCount(frameRate)
end

function ApplicationInfo.GetTargetFrameRate()
  return targetFrameRate
end

function ApplicationInfo.GetDeviceModel()
  if not ApplicationInfo.deviceModel then
    ApplicationInfo.deviceModel = SystemInfo.deviceModel
  end
  return ApplicationInfo.deviceModel
end

function ApplicationInfo.GetAppleDeviceVersion(deviceName)
  local deviceModel = ApplicationInfo.GetDeviceModel()
  local startPos = string.find(deviceModel, deviceName)
  local endPos = string.find(deviceModel, ",")
  return startPos and tonumber(string.sub(deviceModel, startPos + string.len(deviceName), endPos and endPos - 1 or string.len(deviceModel))) or -1
end

function ApplicationInfo.GetAppleDeviceSubVersion()
  if not ApplicationInfo.appleDeviceSubVersion then
    local deviceModel = ApplicationInfo.GetDeviceModel()
    local startPos = string.find(deviceModel, ",")
    ApplicationInfo.appleDeviceSubVersion = startPos and tonumber(string.sub(deviceModel, startPos + 1, string.len(deviceModel))) or -1
  end
  return ApplicationInfo.appleDeviceSubVersion
end

function ApplicationInfo.GetIphoneDeviceVersion()
  if not ApplicationInfo.iphoneDeivceVersion then
    ApplicationInfo.iphoneDeivceVersion = ApplicationInfo.GetAppleDeviceVersion("iPhone")
  end
  return ApplicationInfo.iphoneDeivceVersion
end

function ApplicationInfo.GetIpadDeviceVersion()
  if not ApplicationInfo.ipadDeivceVersion then
    ApplicationInfo.ipadDeivceVersion = ApplicationInfo.GetAppleDeviceVersion("iPad")
  end
  return ApplicationInfo.ipadDeivceVersion
end

function ApplicationInfo.IsIphone7P_or_Worse()
  local diviceVersion = ApplicationInfo.GetIphoneDeviceVersion()
  return 0 <= diviceVersion and diviceVersion < 10
end

function ApplicationInfo.IsIpad6_or_Worse()
  local diviceVersion = ApplicationInfo.GetIpadDeviceVersion()
  local subVersion = ApplicationInfo.GetAppleDeviceSubVersion()
  if diviceVersion < 0 or subVersion < 0 then
    return false
  end
  return diviceVersion < 7 or diviceVersion == 7 and subVersion < 7
end

function ApplicationInfo.GetDeviceStats()
  local stats = {
    {
      name = "deviceid",
      value = SystemInfo.deviceUniqueIdentifier
    },
    {
      name = "branch",
      value = BranchMgr.GetBranchName()
    },
    {
      name = "isSimulator",
      value = ApplicationInfo.IsEmulator() and "y" or "n"
    },
    {
      name = "model",
      value = SystemInfo.deviceModel
    },
    {
      name = "gpuname",
      value = SystemInfo.graphicsDeviceName
    },
    {
      name = "gputype",
      value = SystemInfo.graphicsDeviceType
    },
    {
      name = "gpuvendor",
      value = SystemInfo.graphicsDeviceVendor
    },
    {
      name = "gpushaderlevel",
      value = SystemInfo.graphicsShaderLevel
    },
    {
      name = "maxtexsize",
      value = SystemInfo.maxTextureSize
    },
    {
      name = "npot",
      value = SystemInfo.npotSupport
    },
    {
      name = "proctype",
      value = SystemInfo.processorType
    },
    {
      name = "rtcount",
      value = SystemInfo.supportedRenderTargetCount
    },
    {
      name = "spttexarray",
      value = SystemInfo.supports2DArrayTextures and "y" or "n"
    },
    {
      name = "spt3drt",
      value = SystemInfo.supports3DRenderTextures and "y" or "n"
    },
    {
      name = "spt3dtex",
      value = SystemInfo.supports3DTextures and "y" or "n"
    },
    {
      name = "sptgeoshader",
      value = SystemInfo.supportsGeometryShaders and "y" or "n"
    },
    {
      name = "sptinstancing",
      value = SystemInfo.supportsInstancing and "y" or "n"
    },
    {
      name = "spttesselshader",
      value = SystemInfo.supportsTessellationShaders and "y" or "n"
    },
    {
      name = "sptcomputeshader",
      value = SystemInfo.supportsComputeShaders and "y" or "n"
    },
    {
      name = "sptstreamingmipmap",
      value = SystemInfo.supportsMipStreaming and "y" or "n"
    },
    {
      name = "sptastc44",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.ASTC_4x4) and "y" or "n"
    },
    {
      name = "sptastc55",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.ASTC_5x5) and "y" or "n"
    },
    {
      name = "sptrgbahalf",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.RGBAHalf) and "y" or "n"
    },
    {
      name = "sptrgbafloat",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.RGBAFloat) and "y" or "n"
    },
    {
      name = "sptetc2rgb",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.ETC2_RGB) and "y" or "n"
    },
    {
      name = "sptetc2rgba8",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.ETC2_RGBA8) and "y" or "n"
    },
    {
      name = "sptrfloat",
      value = SystemInfo.SupportsTextureFormat(TextureFormat.RFloat) and "y" or "n"
    },
    {
      name = "sptrtargbfloat",
      value = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBFloat) and "y" or "n"
    },
    {
      name = "sptrtargbhalf",
      value = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf) and "y" or "n"
    },
    {
      name = "sprtrtargb64",
      value = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGB64) and "y" or "n"
    },
    {
      name = "sprtrtrfloat",
      value = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.RFloat) and "y" or "n"
    }
  }
  return stats
end
