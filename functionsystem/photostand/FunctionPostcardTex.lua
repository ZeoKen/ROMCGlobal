autoImport("PhotoStandPicData")
autoImport("FunctionPhotoStorage")
FunctionPostcardTex = class("FunctionPostcardTex")
FunctionPostcardTex.DlEvent = {
  PhotoDonwloadSucc = "FunctionPostcardTex.DlEvent.PhotoDonwloadSucc",
  PhotoDonwloadFailed = "FunctionPostcardTex.DlEvent.PhotoDonwloadFailed",
  PhotoDonwloadTerminated = "FunctionPostcardTex.DlEvent.PhotoDonwloadTerminated"
}
FunctionPostcardTex.DlStatus = {
  None = 0,
  Pending = 1,
  Success = 2,
  Fail = 3
}

function FunctionPostcardTex.Me()
  if nil == FunctionPostcardTex.me then
    FunctionPostcardTex.me = FunctionPostcardTex.new()
  end
  return FunctionPostcardTex.me
end

function FunctionPostcardTex:ctor()
  self:AddListener()
end

function FunctionPostcardTex:Launch()
end

function FunctionPostcardTex:Shutdown()
end

function FunctionPostcardTex:AddListener()
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadRequestMax, self.OnPhotoDonwloadFailed, self)
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadSucc, self.OnPhotoDonwloadSucc, self)
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadFailed, self.OnPhotoDonwloadFailed, self)
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadTerminated, self.OnPhotoDonwloadTerminated, self)
end

function FunctionPostcardTex:OnPhotoDonwloadSucc(data)
  local pl = data.data
  local url = pl[1]
  local localPath = pl[2]
  local ex = pl[3]
  if not localPath or not ex then
    return
  end
  local id = ex[1]
  local is_thumb = ex[2]
  local postcardData = PostcardProxy.Instance:Query_GetPostcardById(id, true)
  if postcardData then
    postcardData:Tex_SetDlState(FunctionPostcardTex.DlStatus.Success, is_thumb, localPath)
    GameFacade.Instance:sendNotification(FunctionPostcardTex.DlEvent.PhotoDonwloadSucc, {id = id, is_thumb = is_thumb})
  else
    redlog("OnPhotoDonwloadSucc", url, "pic data not found")
  end
end

function FunctionPostcardTex:OnPhotoDonwloadFailed(data)
  local pl = data.data
  local url = pl[1]
  local localPath = pl[2]
  local ex = pl[3]
  if not localPath or not ex then
    return
  end
  local id = ex[1]
  local is_thumb = ex[2]
  local postcardData = PostcardProxy.Instance:Query_GetPostcardById(id, true)
  if postcardData then
    postcardData:Tex_SetDlState(FunctionPostcardTex.DlStatus.Fail, is_thumb, nil)
    GameFacade.Instance:sendNotification(FunctionPostcardTex.DlEvent.PhotoDonwloadFailed, {id = id, is_thumb = is_thumb})
  else
    redlog("OnPhotoDonwloadFailed", url, "pic data not found")
  end
end

function FunctionPostcardTex:OnPhotoDonwloadTerminated(data)
  local pl = data.data
  local url = pl[1]
  local localPath = pl[2]
  local ex = pl[3]
  if not localPath or not ex then
    return
  end
  local id = ex[1]
  local is_thumb = ex[2]
  local postcardData = PostcardProxy.Instance:Query_GetPostcardById(id, true)
  if postcardData then
    postcardData:Tex_SetDlState(FunctionPostcardTex.DlStatus.None, is_thumb, nil)
    GameFacade.Instance:sendNotification(FunctionPostcardTex.DlEvent.PhotoDonwloadTerminated, {id = id, is_thumb = is_thumb})
  else
    redlog("OnPhotoDonwloadTerminated", url, "pic data not found")
  end
end

local RECEIVE_TEMP = "RECEIVE_TEMP"

function FunctionPostcardTex.ClearReceiveTempDir()
  FileDirectoryHandler.DeleteDirectory(IOPathConfig.Paths.Extension.Postcard .. "/" .. RECEIVE_TEMP)
end

function FunctionPostcardTex.GetDefaultLocalPath(postcardData, isThumbnail)
  if not postcardData or postcardData:Tex_IsLocalRes() then
    return
  end
  local ext = postcardData.source == EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_PLAYER_ALBUM and ".jpg" or ".astc"
  if isThumbnail then
    ext = "_thumb" .. ext
  end
  if postcardData.temp_receive_id then
    return ApplicationHelper.persistentDataPath .. "/" .. IOPathConfig.Paths.Extension.Postcard .. "/" .. RECEIVE_TEMP .. "/" .. postcardData.temp_receive_id .. ext
  else
    return ApplicationHelper.persistentDataPath .. "/" .. IOPathConfig.Paths.Extension.Postcard .. "/" .. postcardData.id .. ext
  end
end
