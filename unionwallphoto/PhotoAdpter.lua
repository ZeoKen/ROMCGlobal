PhotoAdpter = class("PhotoAdpter")
local MAX_WAIT_LIST = 5

function PhotoAdpter.Ins()
  if PhotoAdpter.ins == nil then
    PhotoAdpter.ins = PhotoAdpter.new()
  end
  return PhotoAdpter.ins
end

function PhotoAdpter:ctor()
  self.loadingList = {}
  self.waitList = {}
  self.httpReqestList = {}
  self:InitCdnUrl()
end

local cdn4Area = {
  "https://ro.xdcdn.net",
  "http://ro-tw-gcs.gnjoy.com.tw",
  "http://sea-ugc.ro.com",
  "http://jp-cdn.ro.com",
  "http://kr-ugc.ro.com",
  "http://na-ugc.ro.com",
  "http://eu-cdn.ro.com"
}

function PhotoAdpter:InitCdnUrl()
  local rolesInfo = MyselfProxy.Instance:GetUserRolesInfo()
  self.cdnUrl = rolesInfo and rolesInfo.area and cdn4Area[rolesInfo.area]
end

function PhotoAdpter:AddRequest(photoUrl, isAbsUrl, customLocalPath, ex)
  if not isAbsUrl then
    photoUrl = self:GetCDNUrl(photoUrl)
  end
  for i = 1, #self.loadingList do
    if self.loadingList[i][1] == photoUrl and self.loadingList[i][2] == customLocalPath then
      return
    end
  end
  for i = 1, #self.waitList do
    if self.waitList[i][1] == photoUrl and self.waitList[i][2] == customLocalPath then
      return
    end
  end
  local pl = {
    photoUrl,
    customLocalPath,
    ex
  }
  if #self.waitList > MAX_WAIT_LIST then
    EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadRequestMax, pl)
    GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadRequestMax, pl)
    return
  end
  local localPath = customLocalPath or self:GetLocalPath(photoUrl)
  if FileHelper.ExistFile(localPath) and FileHelper.ExistFile(localPath .. ".done") then
    helplog("file exist:" .. localPath)
    EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadSucc, pl)
    GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadSucc, pl)
    return
  end
  self.waitList[#self.waitList + 1] = pl
  self:CheckCanDownload()
end

function PhotoAdpter:CancelRequest(photoUrl, isAbsUrl, customLocalPath)
  if not isAbsUrl then
    photoUrl = self:GetCDNUrl(photoUrl)
  end
  for i = 1, #self.waitList do
    if self.waitList[i][1] == photoUrl and self.waitList[i][2] == customLocalPath then
      table.remove(self.waitList, i)
      break
    end
  end
  for i = 1, #self.loadingList do
    if self.loadingList[i][1] == photoUrl and self.loadingList[i][2] == customLocalPath then
      table.remove(self.loadingList, i)
      self:CancelDownloading(photoUrl)
      break
    end
  end
end

function PhotoAdpter:ClearRequest()
  local wl = table.deepcopy(self.waitList)
  self.waitList = {}
  for i = 1, #wl do
    EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadTerminated, wl[i])
    GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadTerminated, wl[i])
  end
end

function PhotoAdpter:GetCDNUrl(photoUrl)
  local cdnUrl = string.format("%s/%s", self.cdnUrl, photoUrl)
  return cdnUrl
end

function PhotoAdpter:GetLocalPath(photoPath)
  local _, endIndex = string.find(photoPath, self.cdnUrl, 1, true)
  photoPath = endIndex and string.sub(photoPath, endIndex + 1, #photoPath) or ""
  local photoLocalPath = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/album_abc" .. photoPath
  local sps = string.split(photoPath, "/")
  local _photoPath = StringUtil.Replace(photoPath, sps[#sps], "")
  local photoDirectory = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/album_abc" .. _photoPath
  return photoLocalPath, photoDirectory, sps[#sps]
end

function PhotoAdpter:_GetDirectory(path)
  local sps = string.split(path, "/")
  return StringUtil.Replace(path, sps[#sps], "")
end

function PhotoAdpter:CheckCanDownload()
  if #self.waitList > 0 then
    local isCanStart = false
    if #self.loadingList < 1 then
      isCanStart = true
    end
    if isCanStart then
      local pl = self.waitList[1]
      local photoUrl = pl[1]
      self.loadingList[#self.loadingList + 1] = pl
      self:RemoveFromWait(pl)
      local photoLocalPath, photoDirectory
      if pl[2] then
        photoLocalPath = pl[2]
        photoDirectory = self:_GetDirectory(photoLocalPath)
      else
        photoLocalPath, photoDirectory = self:GetLocalPath(photoUrl)
      end
      if FileHelper.ExistFile(photoLocalPath) and FileHelper.ExistFile(photoLocalPath .. ".done") then
        helplog("file exist:" .. photoLocalPath)
      else
        if not FileHelper.ExistDirectory(photoDirectory) then
          FileHelper.CreateDirectory(photoDirectory)
        end
        HTTPRequest.GetTexture(photoUrl, photoLocalPath, pl, function(unityWebRequest, localpath, pl)
          if unityWebRequest.downloadHandler and unityWebRequest.downloadHandler.isDone then
            helplog("下载成功:" .. pl[1])
            local file = io.open(localpath .. ".done", "wb")
            if file ~= nil then
              file:flush()
              file:close()
            end
            EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadSucc, pl)
            GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadSucc, pl)
          else
            helplog("下载失败:" .. pl[1])
            EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadFailed, pl)
            GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadFailed, pl)
            if FileHelper.ExistFile(localpath) then
              FileHelper.DeleteFile(localpath)
            end
          end
          self:RemoveFromLoading(pl)
          self:CheckCanDownload()
        end)
      end
    end
  end
end

function PhotoAdpter:RemoveFromWait(pl)
  for i = 1, #self.waitList do
    if self.waitList[i][1] == pl[1] and self.waitList[i][2] == pl[2] then
      table.remove(self.waitList, i)
      break
    end
  end
end

function PhotoAdpter:RemoveFromLoading(pl)
  for i = 1, #self.loadingList do
    if self.loadingList[i][1] == pl[1] and self.loadingList[i][2] == pl[2] then
      table.remove(self.loadingList, i)
      break
    end
  end
end

function PhotoAdpter:CancelDownloading(url)
  HTTPRequest.CancelTextureDownloading(url)
end

function PhotoAdpter:DeleteAllLocalFile()
  for i = 1, #self.loadingList do
    self:CancelDownloading(self.loadingList[i][1])
  end
  FileHelper.DeleteFileWithExtension(ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/", ".jpg")
  FileHelper.DeleteFileWithExtension(ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/", ".png")
  FileHelper.DeleteFileWithExtension(ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/", ".done")
end

function PhotoAdpter.DeleteDownloadResult(filePath)
  local doneFilePath = filePath .. ".done"
  if FileHelper.ExistFile(filePath) then
    FileHelper.DeleteFile(filePath)
  end
  if FileHelper.ExistFile(doneFilePath) then
    FileHelper.DeleteFile(doneFilePath)
  end
end
