HomePictureManager = class("HomePictureManager")

function HomePictureManager.Me()
  if nil == HomePictureManager.me then
    HomePictureManager.me = HomePictureManager.new()
  end
  return HomePictureManager.me
end

function HomePictureManager:ctor()
end

local SetCameraPose = function(camera, pose)
  if not pose then
    return
  end
  local pos = pose.pos or pose.position
  if pos then
    LuaGameObject.SetPositionGO(camera.gameObject, pos[1], pos[2], pos[3])
  end
  local rot = pose.rot or pose.rotation
  if rot then
    camera.transform.localEulerAngles = Vector3(rot[1], rot[2], rot[3])
  end
  local lookAt = pose.lookAt or pose.look_at
  if lookAt then
    camera.transform:LookAt(Vector3(lookAt[1], lookAt[2], lookAt[3]))
  end
  local size = pose.size
  if size then
    camera.orthographicSize = size
  end
end
local LogTempCameraPose = function(camera, tag)
  if not camera then
    return
  end
  local t = camera.transform
  local p = t.position
  local e = t.eulerAngles
  LogUtility.Info(string.format("%s pos=(%.3f,%.3f,%.3f) euler=(%.3f,%.3f,%.3f)", tag or "HomePictureTempCamera", p.x, p.y, p.z, e.x, e.y, e.z))
end
local DeleteLocalHomePhoto = function(photoType, photoId, timestamp)
  local path = FunctionPhotoStorage.Me():GetHomePhotoPath(photoType, photoId, timestamp, PhotoFileInfo.Extension, false)
  if path and FileHelper.ExistFile(path) then
    FileHelper.DeleteFile(path)
  end
end
local RemoveCullingLayer = function(cullingMask, layer)
  return cullingMask & ~(1 << layer)
end
local AttachHiddenTarget = function(camera)
  local rt = RenderTexture.GetTemporary(1, 1, 0)
  camera.targetTexture = rt
  return rt
end
local ReleaseHiddenTarget = function(camera, rt)
  camera.targetTexture = nil
  if rt then
    RenderTexture.ReleaseTemporary(rt)
  end
end
local _cameraOffset = {
  {
    pos = {
      0,
      20,
      0
    },
    rot = {
      90,
      0,
      0
    }
  }
}
local GetSnowRealmBasePos = function(snowHomeIdxOverride)
  local homeIdx = snowHomeIdxOverride
  if not homeIdx or homeIdx <= 0 then
    homeIdx = SnowRealmManager.Me():GetCurHomeIdx()
  end
  if not homeIdx or homeIdx <= 0 then
    return {
      0,
      0,
      0
    }
  end
  local configName = "sc_xhzd_home_" .. tostring(homeIdx)
  pcall(function()
    autoImport(configName)
  end)
  local mapInfo = _G[configName]
  local data = mapInfo and mapInfo[1]
  if data and data.x and data.y and data.z then
    return {
      data.x,
      data.y,
      data.z
    }
  end
  return {
    0,
    0,
    0
  }
end
local BuildPoses = function(basePos, baseRot, cameraOffset)
  basePos = basePos or {
    0,
    0,
    0
  }
  baseRot = baseRot or {
    0,
    0,
    0
  }
  cameraOffset = cameraOffset or _cameraOffset
  local poses = {}
  for i = 1, #cameraOffset do
    local offset = cameraOffset[i]
    local pos = offset.pos or offset.position
    local rot = offset.rot or offset.rotation
    local size = offset.size
    poses[#poses + 1] = {
      pos = {
        (basePos[1] or 0) + (pos and pos[1] or 0),
        (basePos[2] or 0) + (pos and pos[2] or 0),
        (basePos[3] or 0) + (pos and pos[3] or 0)
      },
      rot = {
        (baseRot[1] or 0) + (rot and rot[1] or 0),
        (baseRot[2] or 0) + (rot and rot[2] or 0),
        (baseRot[3] or 0) + (rot and rot[3] or 0)
      },
      size = size
    }
  end
  return poses
end

function HomePictureManager:GetCapturePoses(isReview, snowHomeIdxOverride)
  local mapId = Game.MapManager:GetMapID()
  local cameraOffset = GameConfig.Home.Recommend and GameConfig.Home.Recommend.CameraOffset
  cameraOffset = cameraOffset and cameraOffset[mapId]
  cameraOffset = cameraOffset and cameraOffset[isReview and "Review" or "Normal"]
  if HomeManager.Me():IsSnowRealmMap(mapId) then
    return BuildPoses(GetSnowRealmBasePos(snowHomeIdxOverride), nil, cameraOffset)
  end
  return BuildPoses({
    0,
    0,
    0
  }, nil, cameraOffset)
end

function HomePictureManager:CaptureAndUploadAtPositions(poses, photoType, photoId, customParam, onSingleFinish, onAllFinish, opts)
  local now = math.floor(ServerTime.CurServerTime() / 1000)
  if self._lastCaptureTs and now - self._lastCaptureTs < 30 then
    if onAllFinish then
      onAllFinish()
    end
    return
  end
  self._lastCaptureTs = now
  if not poses or #poses == 0 then
    if onAllFinish then
      onAllFinish()
    end
    return
  end
  local sourceCamera = Camera.main
  if not sourceCamera then
    if onSingleFinish then
      onSingleFinish(0, false, "no_source_camera", nil, nil)
    end
    if onAllFinish then
      onAllFinish()
    end
    return
  end
  local tempGo = GameObject("HomePictureTempCamera")
  local tempCamera = tempGo:AddComponent(Camera)
  tempCamera:CopyFrom(sourceCamera)
  tempCamera.enabled = false
  tempCamera.cullingMask = RemoveCullingLayer(tempCamera.cullingMask, Game.ELayer.SceneUI)
  local helper = tempGo:AddComponent(ScreenShotHelper)
  if not helper then
    Object.DestroyImmediate(tempGo)
    if onSingleFinish then
      onSingleFinish(0, false, "create_helper_failed", nil, nil)
    end
    if onAllFinish then
      onAllFinish()
    end
    return
  end
  helper:Setting(opts and opts.width or 1920, opts and opts.height or 1080, opts and opts.textureFormat or TextureFormat.RGB24, opts and opts.textureDepth or 24, opts and opts.antiAliasing or ScreenShot.AntiAliasing.None)
  local CleanupTemp = function()
    if tempGo then
      Object.DestroyImmediate(tempGo)
      tempGo = nil
    end
  end
  local CaptureOnce = function(pose, onCaptured)
    SetCameraPose(tempCamera, pose)
    LogTempCameraPose(tempCamera, "HomePictureTempCamera")
    local hiddenRT = AttachHiddenTarget(tempCamera)
    tempCamera.enabled = true
    helper:GetScreenShot(function(texture)
      tempCamera.enabled = false
      ReleaseHiddenTarget(tempCamera, hiddenRT)
      onCaptured(texture)
    end, tempCamera)
  end
  local index = math.random(1, #poses)
  CaptureOnce(poses[index], function(texture)
    if not texture then
      CleanupTemp()
      if onSingleFinish then
        onSingleFinish(index, false, "capture_failed", nil, nil)
      end
      if onAllFinish then
        onAllFinish()
      end
      return
    end
    local targetPhotoId = photoId or HomeCmd_pb.EHOUSETYPE_PRIVATE
    local timestamp = math.floor(ServerTime.CurServerTime() / 1000)
    FunctionPhotoStorage.Me():SaveHomePhoto(photoType, texture, targetPhotoId, timestamp, customParam, opts and opts.onProgress or nil, function(success, errorMsg)
      if onSingleFinish then
        onSingleFinish(index, success, errorMsg, targetPhotoId, timestamp)
      end
      Object.DestroyImmediate(texture)
      DeleteLocalHomePhoto(photoType, targetPhotoId, timestamp)
      CleanupTemp()
      if onAllFinish then
        onAllFinish()
      end
    end)
  end)
end

function HomePictureManager:CaptureHomePhotoTextureAtRandomPose(poses, opts, onCaptured)
  if not poses or #poses == 0 then
    if onCaptured then
      onCaptured(nil, "no_poses")
    end
    return
  end
  local sourceCamera = Camera.main
  if not sourceCamera then
    if onCaptured then
      onCaptured(nil, "no_source_camera")
    end
    return
  end
  local tempGo = GameObject("HomePictureTempCamera")
  local tempCamera = tempGo:AddComponent(Camera)
  tempCamera:CopyFrom(sourceCamera)
  tempCamera.enabled = false
  tempCamera.cullingMask = RemoveCullingLayer(tempCamera.cullingMask, Game.ELayer.SceneUI)
  local helper = tempGo:AddComponent(ScreenShotHelper)
  if not helper then
    Object.DestroyImmediate(tempGo)
    if onCaptured then
      onCaptured(nil, "create_helper_failed")
    end
    return
  end
  helper:Setting(opts and opts.width or 1920, opts and opts.height or 1080, opts and opts.textureFormat or TextureFormat.RGB24, opts and opts.textureDepth or 24, opts and opts.antiAliasing or ScreenShot.AntiAliasing.None)
  local CleanupTemp = function()
    if tempGo then
      Object.DestroyImmediate(tempGo)
      tempGo = nil
    end
  end
  local CaptureOnce = function(pose, onShotDone)
    SetCameraPose(tempCamera, pose)
    LogTempCameraPose(tempCamera, "HomePictureTempCamera")
    local hiddenRT = AttachHiddenTarget(tempCamera)
    tempCamera.enabled = true
    helper:GetScreenShot(function(texture)
      tempCamera.enabled = false
      ReleaseHiddenTarget(tempCamera, hiddenRT)
      onShotDone(texture)
    end, tempCamera)
  end
  local index = math.random(1, #poses)
  CaptureOnce(poses[index], function(texture)
    CleanupTemp()
    if not texture then
      if onCaptured then
        onCaptured(nil, "capture_failed")
      end
      return
    end
    if onCaptured then
      onCaptured(texture, nil)
    end
  end)
end

function HomePictureManager:CaptureAndUploadReviewAtPoses(poses, photoType, photoId, onSingleFinish, onAllFinish, opts, layer)
  if not poses or #poses == 0 then
    if onAllFinish then
      onAllFinish(false)
    end
    return
  end
  local sourceCamera = Camera.main
  if not sourceCamera then
    if onAllFinish then
      onAllFinish(false)
    end
    return
  end
  local tempGo = GameObject("HomePictureReviewTempCamera")
  local tempCamera = tempGo:AddComponent(Camera)
  tempCamera:CopyFrom(sourceCamera)
  tempCamera.orthographic = true
  if layer ~= nil then
    tempCamera.cullingMask = 1 << layer
  else
    tempCamera.cullingMask = RemoveCullingLayer(tempCamera.cullingMask, Game.ELayer.StaticObject)
  end
  tempCamera.enabled = false
  local helper = tempGo:AddComponent(ScreenShotHelper)
  helper:Setting(opts and opts.width or 1920, opts and opts.height or 1080, opts and opts.textureFormat or TextureFormat.RGB24, opts and opts.textureDepth or 24, opts and opts.antiAliasing or ScreenShot.AntiAliasing.None)
  local CleanupTemp = function()
    if tempGo then
      Object.DestroyImmediate(tempGo)
      tempGo = nil
    end
  end
  local CaptureOnce = function(pose, onCaptured)
    SetCameraPose(tempCamera, pose)
    LogTempCameraPose(tempCamera, "HomePictureReviewTempCamera")
    local hiddenRT = AttachHiddenTarget(tempCamera)
    tempCamera.enabled = true
    helper:GetScreenShot(function(texture)
      tempCamera.enabled = false
      ReleaseHiddenTarget(tempCamera, hiddenRT)
      onCaptured(texture)
    end, tempCamera)
  end
  local allSuccess = true
  
  local function CaptureIndex(i)
    if i > #poses then
      CleanupTemp()
      if onAllFinish then
        onAllFinish(allSuccess)
      end
      return
    end
    CaptureOnce(poses[i], function(reviewTexture)
      if not reviewTexture then
        allSuccess = false
        if onSingleFinish then
          onSingleFinish(i, false, "review_capture_failed", "review", nil)
        end
        CaptureIndex(i + 1)
        return
      end
      local reviewPhotoId = i
      local reviewCustomParam
      if photoId ~= nil then
        reviewPhotoId = photoId
        reviewCustomParam = i
      end
      local reviewTimestamp = math.floor(ServerTime.CurServerTime() / 1000)
      FunctionPhotoStorage.Me():SaveHomePhoto(photoType, reviewTexture, reviewPhotoId, reviewTimestamp, reviewCustomParam, opts and opts.onProgress or nil, function(reviewSuccess, reviewError)
        if not reviewSuccess then
          allSuccess = false
        end
        if onSingleFinish then
          onSingleFinish(i, reviewSuccess, reviewError, reviewPhotoId, reviewTimestamp)
        end
        Object.DestroyImmediate(reviewTexture)
        DeleteLocalHomePhoto(photoType, reviewPhotoId, reviewTimestamp)
        CaptureIndex(i + 1)
      end)
    end)
  end
  
  CaptureIndex(1)
end
