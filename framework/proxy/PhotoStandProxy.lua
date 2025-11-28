autoImport("PhotoStandListData")
autoImport("PhotoStandThemeData")
autoImport("PhotoStandPicData")
autoImport("PhotoStandTestMe")
PhotoStandProxy = class("PhotoStandProxy", pm.Proxy)
PhotoStandProxy.ServerPageSize = 30
PhotoStandProxy.SlideShowDuration = 10
PhotoStandProxy.DLWinSize = 30
PhotoStandProxy.TEMP_Server = {
  BoardBaseInfoPhotoCmd = "ServerRecv_BoardBaseInfoPhotoCmd",
  BoardTopicPhotoCmd = "ServerRecv_BoardTopicPhotoCmd",
  BoardRotateListPhotoCmd = "ServerRecv_BoardRotateListPhotoCmd",
  BoardListPhotoCmd = "ServerRecv_BoardListPhotoCmd",
  BoardQueryDetailPhotoCmd = "ServerRecv_BoardQueryDetailPhotoCmd",
  BoardQueryDataPhotoCmd = "ServerRecv_BoardQueryDataPhotoCmd",
  BoardMyListPhotoCmd = "ServerRecv_BoardMyListPhotoCmd",
  BoardAwardListPhotoCmd = "ServerRecv_BoardAwardListPhotoCmd",
  BoardLikePhotoCmd = "BoardLikePhotoCmd",
  BoardAwardPhotoCmd = "BoardAwardPhotoCmd",
  BoardGetAwardPhotoCmd = "BoardGetAwardPhotoCmd",
  Alert_ServerConsoleChangedData = "Alert_ServerConsoleChangedData",
  DL_PhotoDonwloadSucc = "DL_PhotoDonwloadSucc",
  DL_PhotoDonwloadFailed = "DL_PhotoDonwloadFailed",
  DL_PhotoDonwloadTerminated = "DL_PhotoDonwloadTerminated",
  DL_HighRes_PhotoDonwloadSucc = "DL_HighRes_PhotoDonwloadSucc",
  DL_HighRes_PhotoDonwloadFailed = "DL_HighRes_PhotoDonwloadFailed",
  DL_HighRes_PhotoDonwloadTerminated = "DL_HighRes_PhotoDonwloadTerminated"
}

function PhotoStandProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "PhotoStandProxy"
  if PhotoStandProxy.Instance == nil then
    PhotoStandProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function PhotoStandProxy:Init()
  self.picSet = {}
  self.mypostList = PhotoStandListData.new()
  self.mypostList:SetUsageTag("mypost")
  self.mypostList.name = ZhString.PhotoStand_MyPost
  self.slideList = {}
  self.themeList = {}
  self.knownList = {}
end

function PhotoStandProxy:GetThemeByTopic(topic)
  for i = 1, #self.themeList do
    if self.themeList[i].topic == topic then
      return self.themeList[i]
    end
  end
end

function PhotoStandProxy:GetThemeListByNpc(npcid)
  local themes, theme = {}
  for i = 1, #self.themeList do
    theme = self.themeList[i]
    if theme.npcids and TableUtility.ArrayFindIndex(theme.npcids, npcid) > 0 then
      themes[#themes + 1] = theme
    end
  end
  table.sort(themes, function(a, b)
    return a.topic < b.topic
  end)
  return themes
end

function PhotoStandProxy:_CreateGetPicData(id, accid)
  local ret = self:_GetPicData(id, accid)
  if not ret then
    local data = PhotoStandPicData.new(id, accid)
    self:_AddPicDataToSet(id, accid, data)
    return data
  end
  return ret
end

function PhotoStandProxy:_GetPicData(id, accid)
  return self.knownList[id .. " " .. accid]
end

function PhotoStandProxy:_GetPicDataById(id)
  if not id then
    return
  end
  for _, v in pairs(self.knownList) do
    if v.id == id then
      return v
    end
  end
end

function PhotoStandProxy:_AddPicDataToSet(id, accid, data)
  local k = id .. " " .. accid
  if TableUtility.ArrayFindIndex(self.knownList, k) == 0 then
    self.knownList[k] = data
  end
end

function PhotoStandProxy:OnAlert_ServerConsoleChangedData()
  FunctionPhotoStand.Me():Shutdown()
  FunctionPhotoStand.Me():Launch()
end

function PhotoStandProxy:OnRecv_InitSlideStart(npcid, starttime, totalcount)
  local slideData = self.slideList[npcid]
  slideData.flag_InitStartTime = false
  local dt = ServerTime.CurServerTime() - starttime
  local server_valid = totalcount ~= nil and 0 < totalcount
  local spot_idx = server_valid and (math.ceil(dt / 1000 / PhotoStandProxy.SlideShowDuration) - 1) % totalcount + 1 or 0
  local page_idx = math.ceil(spot_idx / PhotoStandProxy.ServerPageSize)
  slideData.curSpotPicIndex = spot_idx
  if server_valid then
    slideData:SetActiveOnShow(true)
  end
  FunctionPhotoStand.Me():InitSlide(npcid, dt, spot_idx, totalcount)
  if server_valid then
    self:ServerCall_BoardRotateListPhotoCmd(page_idx, npcid)
  end
end

function PhotoStandProxy:ProxyLaunch()
  self:ServerCall_BoardBaseInfoPhotoCmd()
  self:ServerCall_BoardTopicPhotoCmd()
  self:ServerCall_BoardMyListPhotoCmd(0)
  local slide_info = FunctionPhotoStand.Me().slide_info
  for k, v in pairs(slide_info) do
    local slideData = self.slideList[k]
    if not slideData then
      slideData = PhotoStandListData.new()
      slideData.npc = k
      slideData:SetUsageTag("scene")
      self.slideList[k] = slideData
    end
    slideData.flag_InitStartTime = true
    self:ServerCall_BoardRotateListPhotoCmd(0, k)
  end
end

function PhotoStandProxy:ProxyShutdown()
  for _, v in pairs(self.knownList) do
    v:Dispose()
  end
  self:Init()
end

function PhotoStandProxy:ServerCall_BoardBaseInfoPhotoCmd()
  PhotoStandTestMe.Me():ServerCall_BoardBaseInfoPhotoCmd()
end

function PhotoStandProxy:ServerCall_BoardTopicPhotoCmd()
  PhotoStandTestMe.Me():ServerCall_BoardTopicPhotoCmd()
end

function PhotoStandProxy:ServerCall_BoardRotateListPhotoCmd(page, npcid)
  PhotoStandTestMe.Me():ServerCall_BoardRotateListPhotoCmd(page, npcid)
end

function PhotoStandProxy:ServerCall_BoardListPhotoCmd(theme, page)
  PhotoStandTestMe.Me():ServerCall_BoardListPhotoCmd(theme, page)
end

function PhotoStandProxy:ServerCall_BoardQueryDetailPhotoCmd(id, accid)
  PhotoStandTestMe.Me():ServerCall_BoardQueryDetailPhotoCmd(id, accid)
end

function PhotoStandProxy:ServerCall_BoardQueryDataPhotoCmd(id, accid)
  PhotoStandTestMe.Me():ServerCall_BoardQueryDataPhotoCmd(id, accid)
end

function PhotoStandProxy:ServerCall_BoardMyListPhotoCmd(page)
  PhotoStandTestMe.Me():ServerCall_BoardMyListPhotoCmd(page)
end

function PhotoStandProxy:ServerCall_BoardAwardListPhotoCmd(id, accid)
  PhotoStandTestMe.Me():ServerCall_BoardAwardListPhotoCmd(id, accid)
end

function PhotoStandProxy:ServerCall_BoardLikePhotoCmd(id, accid, like)
  PhotoStandTestMe.Me():ServerCall_BoardLikePhotoCmd(id, accid, like)
end

function PhotoStandProxy:ServerCall_BoardAwardPhotoCmd(id, accid, count)
  PhotoStandTestMe.Me():ServerCall_BoardAwardPhotoCmd(id, accid, count)
end

function PhotoStandProxy:ServerCall_BoardGetAwardPhotoCmd(id, accid)
  PhotoStandTestMe.Me():ServerCall_BoardGetAwardPhotoCmd(id, accid)
end

function PhotoStandProxy:ServerRecv_BoardQueryAwardPhotoCmd(data)
  if data.award then
    self.mypostHasAward = ServerTime.CurServerTime() / 1000 + 60
  else
    self.mypostHasAward = nil
  end
end

function PhotoStandProxy:ServerRecv_BoardBaseInfoPhotoCmd(data)
end

function PhotoStandProxy:ServerRecv_BoardTopicPhotoCmd(data)
  data = data.body or data
  self.themeList = {}
  for i = 1, #data.topics do
    local ttt = PhotoStandThemeData.new(data.topics[i])
    ttt:SetUsageTag("theme")
    self.themeList[#self.themeList + 1] = ttt
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardTopicPhotoCmd, data)
end

function PhotoStandProxy:ServerRecv_BoardRotateListPhotoCmd(data)
  data = data.body or data
  local npcid = data.npcid
  local slideData = self.slideList[npcid]
  if not slideData then
    return
  end
  if slideData.flag_InitStartTime then
    slideData:UpdateListData(data)
    self:OnRecv_InitSlideStart(npcid, data.starttime, data.totalcount)
  else
    for i = 1, #data.lists do
      self:_CreateGetPicData(data.lists[i].id, data.lists[i].accid)
    end
    slideData:UpdateListData(data)
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardRotateListPhotoCmd, data)
end

function PhotoStandProxy:ServerRecv_BoardListPhotoCmd(data)
  data = data.body or data
  local theme = data.topic and self:GetThemeByTopic(data.topic)
  if not theme then
    redlog("error", "PhotoStandProxy:ServerRecv_BoardListPhotoCmd", data.topic)
    return
  end
  for i = 1, #data.lists do
    self:_CreateGetPicData(data.lists[i].id, data.lists[i].accid)
  end
  theme:UpdateListData(data)
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardListPhotoCmd, data)
end

function PhotoStandProxy:ServerRecv_BoardQueryDetailPhotoCmd(data)
  data = data.body or data
  if data.data then
    local ki = self:_GetPicData(data.data.base.id, data.data.base.accid)
    if not ki then
      redlog("ki is nil")
      ki = self:_CreateGetPicData(data.data.base.id, data.data.base.accid)
    end
    ki:Server_SetDetailData(data.data)
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardQueryDetailPhotoCmd, data)
end

function PhotoStandProxy:ServerRecv_BoardQueryDataPhotoCmd(data)
  data = data.body or data
  if data.data and data.board then
    local ki = self:_GetPicData(data.board.id, data.board.accid)
    if not ki then
      redlog("ki is nil")
      ki = self:_CreateGetPicData(data.board.id, data.board.accid)
    end
    ki:Server_SetDynamicData(data.data, data.newaward)
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardQueryDataPhotoCmd, data)
end

function PhotoStandProxy:ServerRecv_BoardMyListPhotoCmd(data)
  data = data.body or data
  for i = 1, #data.lists do
    self:_CreateGetPicData(data.lists[i].id, data.lists[i].accid)
  end
  self.mypostList:UpdateListData(data)
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardMyListPhotoCmd, data)
end

function PhotoStandProxy:ServerRecv_BoardAwardListPhotoCmd(data)
  data = data.body or data
  if data.board then
    local ki = self:_GetPicData(data.board.id, data.board.accid)
    if not ki then
      redlog("ki is nil")
      ki = self:_CreateGetPicData(data.board.id, data.board.accid)
    end
    ki:Server_SetMyPicSponsorData(data)
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardAwardListPhotoCmd, data)
end

PhotoStandProxy.BoardLikePhotoCmd_NO_RESP = true

function PhotoStandProxy:ServerRecv_BoardLikePhotoCmd(data)
  data = data.body or data
  if data.board then
    local ki = self:_GetPicData(data.board.id, data.board.accid)
    if not ki then
      redlog("ki is nil")
      ki = self:_CreateGetPicData(data.board.id, data.board.accid)
    end
    ki.liked = data.like
    ki.like = data.like and ki.like + 1 or ki.like - 1
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardLikePhotoCmd, data)
end

PhotoStandProxy.BoardAwardPhotoCmd_NO_RESP = true

function PhotoStandProxy:ServerRecv_BoardAwardPhotoCmd(data)
  data = data.body or data
  if data.board then
    local ki = self:_GetPicData(data.board.id, data.board.accid)
    if not ki then
      redlog("ki is nil")
      ki = self:_CreateGetPicData(data.board.id, data.board.accid)
    end
    ki.lottery = ki.lottery + data.lotterycount
  end
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardAwardPhotoCmd, data)
end

PhotoStandProxy.BoardGetAwardPhotoCmd_NO_RESP = true

function PhotoStandProxy:ServerRecv_BoardGetAwardPhotoCmd(data)
  data = data.body or data
  GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.BoardGetAwardPhotoCmd, data)
  PhotoStandProxy.Instance:ServerCall_BoardAwardListPhotoCmd(data.board.id, data.board.accid)
end

function PhotoStandProxy:Local_ClearAllAward()
  for _, v in pairs(self.knownList) do
    if v:IsMine() and v:IsMineInfoObtained() then
      v.unawardzeny = 0
    end
  end
end

function PhotoStandProxy:FetchPhotoAsset()
end

function PhotoStandProxy.Fix_230322_DeleteAllAstcDownloadResult()
  if not PlayerPrefs.HasKey("Fix_230322_DeleteAllAstcDownloadResult") then
    local delSubFolders, delSubFolder = {
      "game/board/10001/acc/",
      "cn/board/10001/acc/"
    }
    for i = 1, #delSubFolders do
      delSubFolder = delSubFolders[i]
      FileHelper.DeleteFileWithExtension(ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/album_abc/" .. delSubFolder, ".astc")
      FileHelper.DeleteFileWithExtension(ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/album_abc/" .. delSubFolder, ".done")
    end
    PlayerPrefs.SetInt("Fix_230322_DeleteAllAstcDownloadResult", 1)
    PlayerPrefs.Save()
  end
end

function PhotoStandProxy.IsForbidSponsor()
  return GameConfig.PhotoBoard and GameConfig.PhotoBoard.ForbidAward == true
end
