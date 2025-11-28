FunctionPermission = class("FunctionPermission")
local PermissionEnum = {}
local GrantResult = {}
local PermissionMsgID
if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
  PermissionEnum.Camera = AndroidPermissionUtil.PermissionName.Camera
  PermissionEnum.ReadWriteExternalStorage = AndroidPermissionUtil.PermissionName.ReadWriteExternalStorage
  PermissionEnum.RecordAudio = AndroidPermissionUtil.PermissionName.RecordAudio
  PermissionEnum.FineLocation = AndroidPermissionUtil.PermissionName.FineLocation
  PermissionEnum.CoarseLocation = AndroidPermissionUtil.PermissionName.CoarseLocation
  GrantResult.Granted = AndroidPermissionUtil.PERMISSION_GRANTED
  GrantResult.Denied = AndroidPermissionUtil.PERMISSION_DENIED
  PermissionMsgID = {
    {
      _type = PermissionEnum.Camera,
      msgId = 28082,
      PlayerPrefsKey = "PrefsCamera"
    },
    {
      _type = PermissionEnum.ReadWriteExternalStorage,
      msgId = 28083,
      setingMsgID = 43376,
      PlayerPrefsKey = "PrefsReadWriteExternalStorage"
    },
    {
      _type = PermissionEnum.RecordAudio,
      msgId = 28084,
      setingMsgID = 43375,
      PlayerPrefsKey = "PrefsRecordAudio"
    },
    {
      _type = PermissionEnum.FineLocation,
      msgId = 28085,
      PlayerPrefsKey = "PrefsFineLocation"
    },
    {
      _type = PermissionEnum.CoarseLocation,
      msgId = 28085,
      PlayerPrefsKey = "PrefsCoarseLocation"
    },
    {
      _type = "android.permission.READ_MEDIA_IMAGES",
      msgId = 28083,
      setingMsgID = 43376,
      PlayerPrefsKey = "PrefsREAD_MEDIA_IMAGES"
    }
  }
end
local AllowCode = 0
local PlatformAndroid = ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android
local RequestCallback = function(requestCode, permissions, grantResult)
  FunctionPermission.Me():SetRequestCallbackPPrefs(requestCode, grantResult)
  if grantResult == GrantResult.Granted then
    EventManager.Me():PassEvent(PermissionEvent.RequestSuccess, requestCode)
  elseif grantResult == GrantResult.Denied then
    EventManager.Me():PassEvent(PermissionEvent.RequestFail, requestCode)
  end
end

function FunctionPermission.Me()
  if FunctionPermission.me == nil then
    FunctionPermission.me = FunctionPermission.new()
  end
  return FunctionPermission.me
end

function FunctionPermission:ctor()
end

function FunctionPermission:RequestCameraPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.Camera)
  end
  return AllowCode
end

function FunctionPermission:RequestReadWriteExternalStoragePermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.ReadWriteExternalStorage)
  end
  return AllowCode
end

function FunctionPermission:RequestFineLocationPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.FineLocation)
  end
  return AllowCode
end

function FunctionPermission:RequestCoarseLocationPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.CoarseLocation)
  end
  return AllowCode
end

function FunctionPermission:RequestRecordAudioPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.RecordAudio)
  end
  return AllowCode
end

function FunctionPermission:RequestPermission(permission)
  return self:AndroidRequestPermission(permission)
end

function FunctionPermission:AndroidRequestPermission(permission)
  if not PlatformAndroid then
    return AllowCode
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return AllowCode
  end
  local requestCode = AndroidPermissionUtil.NextRequestCode
  if not BackwardCompatibilityUtil.CompatibilityMode_V56 then
    if self:GetPermissionIsOpen(permission) then
      return AllowCode
    else
      local needShow = self:GetPermissionIsNeedShow(permission)
      local config = self:GetPermissionMsgConfig(permission)
      local first = self:GetPermissionIsFirst(permission)
      if needShow or first then
        MsgManager.AndroidPerissonMsg(config.msgId, function()
          AndroidPermissionUtil.Instance:RequestPermission(permission, requestCode, RequestCallback)
        end)
        self:SetPlayerPrefsPermission(permission)
        config.requestCode = requestCode
      elseif not needShow and not first then
        local setingMsgID = config.msgId
        if config.setingMsgID then
          setingMsgID = config.setingMsgID
        end
        MsgManager.ConfirmMsgByID(setingMsgID, function()
          ExternalInterfaces.OpenNtfSettingView()
        end, nil)
      else
        AndroidPermissionUtil.Instance:RequestPermission(permission, requestCode, RequestCallback)
      end
    end
    return requestCode
  end
end

function FunctionPermission:SetRequestCallbackPPrefs(requestCode, grantResult)
  if not BackwardCompatibilityUtil.CompatibilityMode_V56 then
    local msgId = self:GetPermissionMsgIdByRequestCode(requestCode)
    if grantResult == GrantResult.Granted then
    elseif grantResult == GrantResult.Denied then
    end
  end
end

function FunctionPermission:GetPermissionMsgConfig(permission)
  if PermissionMsgID == nil then
    return nil
  end
  for _, v in pairs(PermissionMsgID) do
    if v._type == permission then
      return v
    end
  end
  return nil
end

function FunctionPermission:GetPermissionMsgIdByRequestCode(_requestCode)
  if PermissionMsgID == nil then
    return nil
  end
  for _, v in pairs(PermissionMsgID) do
    if v.requestCode and v.requestCode == _requestCode then
      return v.msgId
    end
  end
  return nil
end

function FunctionPermission:GetPermissionIsOpen(permission)
  return AndroidPermissionUtil.Instance:GetPermissionState(permission) == GrantResult.Granted
end

function FunctionPermission:GetPermissionIsNeedShow(permission)
  return AndroidPermissionUtil.Instance:GetPermissionIsNeedPrompt(permission)
end

function FunctionPermission:GetPermissionIsFirst(permission)
  if PermissionMsgID == nil then
    return false
  end
  for _, v in pairs(PermissionMsgID) do
    if v._type == permission then
      return PlayerPrefs.GetInt(v.PlayerPrefsKey, 0) ~= 1
    end
  end
end

function FunctionPermission:SetPlayerPrefsPermission(permission)
  if PermissionMsgID == nil then
    return nil
  end
  for _, v in pairs(PermissionMsgID) do
    if v._type == permission then
      PlayerPrefs.SetInt(v.PlayerPrefsKey, 1)
    end
  end
end

function FunctionPermission:RequestRWPermissionForA13()
  if not PlatformAndroid then
    return AllowCode
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return AllowCode
  end
  local requestCode = AndroidPermissionUtil.NextRequestCode
  local s = SystemInfo.operatingSystem
  local p = string.match(s, "API%-(%d+)")
  p = tonumber(p)
  if p < 33 then
    return self:RequestReadWriteExternalStoragePermission()
  end
  local permission = "android.permission.READ_MEDIA_IMAGES"
  if self:GetRawPermissionIsOpen(permission) then
    return AllowCode
  else
    local needShow = self:GetRawPermissionIsNeedShow(permission)
    local config = self:GetPermissionMsgConfig(permission)
    local first = self:GetPermissionIsFirst(permission)
    if needShow or first then
      MsgManager.AndroidPerissonMsg(config.msgId, function()
        AndroidPermissionUtil.Instance:RequestPermissions({permission}, requestCode, RequestCallback)
      end)
      self:SetPlayerPrefsPermission(permission)
      config.requestCode = requestCode
    elseif not needShow and not first then
      local setingMsgID = config.msgId
      if config.setingMsgID then
        setingMsgID = config.setingMsgID
      end
      MsgManager.ConfirmMsgByID(setingMsgID, function()
        ExternalInterfaces.OpenNtfSettingView()
      end, nil)
    else
      AndroidPermissionUtil.Instance:RequestPermissions({permission}, requestCode, RequestCallback)
    end
  end
  return requestCode
end

function FunctionPermission:GetRawPermissionIsNeedShow(permission)
  return AndroidPermissionUtil.Instance:ShouldShowRequestPermissionUI(permission)
end

function FunctionPermission:GetRawPermissionIsOpen(permission)
  return AndroidPermissionUtil.Instance:GetSinglePermissionState(permission) == GrantResult.Granted
end
