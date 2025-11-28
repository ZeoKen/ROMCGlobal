PermissionUtil = {}
local isAndroid = RuntimePlatform.Android == Application.platform

function PermissionUtil.Access_SavePicToMediaStorage(callback)
  if not BranchMgr.IsChina() then
    if callback then
      if isAndroid then
        callback()
      else
        callback()
      end
    end
    return true
  end
  if not PermissionUtil.Access_Camera() then
    return false
  end
  return PermissionUtil.Access_WriteMediaStorage()
end

function PermissionUtil.Access_Camera()
  if isAndroid then
    helplog("Access_Camera")
  end
  return true
end

function PermissionUtil.Access_WriteMediaStorage()
  if isAndroid then
    helplog("Access_WriteMediaStorage")
  end
  return true
end

function PermissionUtil.Access_RecordAudio(callback)
  if not BranchMgr.IsChina() then
    if isAndroid then
      OverSeas_TW.OverSeasManager.GetInstance():AndroidPermissionAudio(function()
        callback()
      end)
    else
      callback()
    end
  end
  if isAndroid then
    helplog("Access_RecordAudio")
  end
  return true
end
