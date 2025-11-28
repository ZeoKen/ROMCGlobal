PostcardData = class("PostcardData")

function PostcardData:ctor(style)
  self.style = style or 1
  self:Tex_InitDlInfo()
end

function PostcardData:Dispose()
  self:Tex_TerminateDl(true)
  self:Tex_TerminateDl()
end

local DTYPES = {Server = 1, ConfigTemp = 2}

function PostcardData:Server_SetData(serverData)
  if serverData.quest_postcard_id and serverData.quest_postcard_id ~= 0 then
    local cfg = Table_QuestPostcard[serverData.quest_postcard_id]
    if cfg then
      self:Config_SetData(cfg)
    end
  else
    self.type = serverData.type
    self.url = serverData.url
    self.sender = serverData.from_char
    self.senderName = serverData.from_name
    self.content = serverData.content
    self.style = serverData.paper_style
    self.source = serverData.source
  end
  self.dtype = DTYPES.Server
  self.id = serverData.id
  self.save_time = serverData.save_time
  self.senderData = nil
end

function PostcardData:LocalSave_SetData(localSaveData)
  self:Server_SetData(localSaveData)
  self.temp_receive_id = localSaveData.temp_receive_id
end

local SAVE_KEY = {
  POSTCARD_NEXT_TEMP_ID = "POSTCARD_NEXT_TEMP_ID",
  POSTCARD_SAVED_TEMP_IDS = "POSTCARD_SAVED_TEMP_IDS"
}

function PostcardData:SetAsReceiveTemp()
  self.id = nil
  local new_temp_id = PlayerPrefs.GetInt(SAVE_KEY.POSTCARD_NEXT_TEMP_ID, -1)
  self.temp_receive_id = new_temp_id
  PlayerPrefs.SetInt(SAVE_KEY.POSTCARD_NEXT_TEMP_ID, new_temp_id - 1)
  PlayerPrefs.Save()
end

function PostcardData:ToPostcardItem()
  local msg = PhotoCmd_pb.PostcardItem()
  msg.id = self.id or 0
  msg.url = self.url or ""
  msg.type = self.type or 0
  msg.source = self.source or 0
  msg.from_char = self.sender or 0
  msg.from_name = self.senderName or ""
  msg.paper_style = self.style or 0
  msg.content = self.content or ""
  msg.save_time = self.save_time or 0
  msg.quest_postcard_id = 0
  return msg
end

function PostcardData:Config_SetData(configData)
  self.dtype = DTYPES.ConfigTemp
  self.id = nil
  self.senderData = nil
  self.senderName = configData.Sender
  self.content = configData.Content
  self.style = configData.PaperStyle
  self.reward = configData.Reward
  if EnvChannel.IsReleaseBranch() then
    self.url = configData.Release_ImageUrl
  else
    self.url = configData.TF_ImageUrl
  end
  self.type = EPOSTCARDTYPE.EPOSTCARD_OFFICIAL
  if string.find(self.url, "local_dir") then
    self.source = EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_LOCAL
  elseif string.find(self.url, "%.astc") then
    self.source = EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_PHOTO_BOARD
  else
    self.source = EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_PLAYER_ALBUM
  end
end

function PostcardData.Clone(postcardData)
  local data = PostcardData.new()
  data:Copy(postcardData)
  return data
end

function PostcardData:Copy(postcardData)
  self.type = postcardData.type
  self.url = postcardData.url
  self.sender = postcardData.sender
  self.senderName = postcardData.senderName
  self.content = postcardData.content
  self.style = postcardData.style
  self.source = postcardData.source
  self.dtype = postcardData.dtype
  self.reward = postcardData.reward
  self.id = postcardData.id
  self.save_time = postcardData.save_time
  self.senderData = postcardData.senderData
  self.targetData = postcardData.targetData
  self.temp_receive_id = postcardData.temp_receive_id
end

function PostcardData:Send_SetTargetData(targetData)
  self.targetData = targetData
end

function PostcardData:Send_GetTargetName()
  return self.targetData and self.targetData.name or nil
end

function PostcardData:Receive_SetSenderData(senderData)
  self.senderData = senderData
end

function PostcardData:Receive_GetSenderName()
  return self.senderName or self.senderData and self.senderData.name or nil
end

function PostcardData:Query_IsTempReceive()
  return self.temp_receive_id ~= nil
end

function PostcardData:Query_CheckSaved()
  if not self.temp_receive_id then
    return
  end
  if self.cache_CheckSaved ~= nil then
    return self.cache_CheckSaved
  end
  self.cache_CheckSaved = false
  local saved_ids_raw = PlayerPrefs.GetString(SAVE_KEY.POSTCARD_SAVED_TEMP_IDS, "{}")
  local saved_ids = loadstring("return " .. saved_ids_raw)()
  if saved_ids and TableUtility.ArrayFindIndex(saved_ids, self.temp_receive_id) > 0 then
    self.cache_CheckSaved = true
  end
  return self.cache_CheckSaved
end

function PostcardData:Operate_Save()
  if not self.temp_receive_id then
    return
  end
  local saved_ids_raw = PlayerPrefs.GetString(SAVE_KEY.POSTCARD_SAVED_TEMP_IDS, "{}")
  local saved_ids = loadstring("return " .. saved_ids_raw)()
  if not saved_ids or type(saved_ids) ~= "table" then
    saved_ids = {}
  end
  if 50 < #saved_ids then
    table.remove(saved_ids, 1)
  end
  table.insert(saved_ids, self.temp_receive_id)
  PlayerPrefs.SetString(SAVE_KEY.POSTCARD_SAVED_TEMP_IDS, TableUtil.ToStringEx(saved_ids))
  PlayerPrefs.Save()
end

function PostcardData:Operate_Del()
  if self:Tex_IsLocalRes() then
    return
  end
  local filePath
  if self.localPath and self.localPath[1] then
    filePath = self.localPath[1]
  else
    filePath = FunctionPostcardTex.GetDefaultLocalPath(self, true)
  end
  PhotoAdpter.DeleteDownloadResult(filePath)
  if self.localPath and self.localPath[2] then
    filePath = self.localPath[2]
  else
    filePath = FunctionPostcardTex.GetDefaultLocalPath(self, false)
  end
  PhotoAdpter.DeleteDownloadResult(filePath)
end

function PostcardData:Tex_IsLocalRes()
  return self.source == EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_LOCAL
end

function PostcardData:Tex_GetLocalResPath()
  return string.gsub(self.url, "local_dir/", "")
end

function PostcardData:Tex_ResetDlInfo()
  self:Tex_TerminateDl()
  self:Tex_TerminateDl(true)
  self:Tex_InitDlInfo()
end

function PostcardData:Tex_InitDlInfo()
  self.dlState = {0, 0}
  self.localPath = {nil, nil}
end

function PostcardData:Tex_SetDlState(state, isThumbnail, localPath)
  local idx = isThumbnail and 1 or 2
  self.dlState[idx] = state
  if localPath then
    self.localPath[idx] = localPath
  end
end

function PostcardData:Tex_GetDlState(isThumbnail)
  return isThumbnail and self.dlState[1] or self.dlState[2]
end

function PostcardData:Tex_GetUrl(isThumbnail)
  if self:Tex_IsLocalRes() then
    return
  end
  if isThumbnail then
    return self.url
  else
    if not self.full_url then
      if self.source == EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_PLAYER_ALBUM then
        self.full_url = FunctionPhotoStorage.Util_ParseUrlFromThumbUrl(self.url)
      elseif self.source == EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_PHOTO_BOARD then
        self.full_url = PhotoStandPicData.Util_ParseUrlFromThumbUrl(self.url)
      end
    end
    return self.full_url
  end
end

function PostcardData:Tex_GetLocalPath(isThumbnail)
  return isThumbnail and self.localPath[1] or self.localPath[2]
end

function PostcardData:Tex_LoadOutTex(isThumbnail)
  local dlState = self:Tex_GetDlState(isThumbnail)
  local localPath = self:Tex_GetLocalPath(isThumbnail)
  local statusOK = dlState == FunctionPostcardTex.DlStatus.Success and localPath
  if statusOK then
    local currentServerTime = ServerTime.CurServerTime() or -1
    return DiskFileManager.Instance:LoadTexture2D(localPath, currentServerTime / 1000, 100), statusOK
  end
end

function PostcardData:Tex_DoDl(isThumbnail)
  if self:Tex_IsLocalRes() then
    return
  end
  local status = self:Tex_GetDlState(isThumbnail)
  if status == FunctionPostcardTex.DlStatus.None then
    local photoUrl = self:Tex_GetUrl(isThumbnail)
    local customLocalPath = FunctionPostcardTex.GetDefaultLocalPath(self, isThumbnail)
    local id = self.temp_receive_id or self.id
    self:Tex_SetDlState(FunctionPostcardTex.DlStatus.Pending, isThumbnail, customLocalPath)
    PhotoAdpter.Ins():AddRequest(photoUrl, true, customLocalPath, {
      id,
      isThumbnail == true
    })
  elseif status == FunctionPostcardTex.DlStatus.Pending then
  elseif status == FunctionPostcardTex.DlStatus.Fail then
  elseif status == FunctionPostcardTex.DlStatus.Success then
  end
end

function PostcardData:Tex_TryLoadOutOrDl(isThumbnail)
  if self:Tex_IsLocalRes() then
    return
  end
  local tex, statusOK = self:Tex_LoadOutTex(isThumbnail)
  if not tex then
    if statusOK then
      redlog("PostcardData load file failed")
    else
      self:Tex_DoDl(isThumbnail)
    end
  end
  return tex
end

function PostcardData:Tex_TerminateDl(isThumbnail)
  local status = self:Tex_GetDlState(isThumbnail)
  if status == FunctionPostcardTex.DlStatus.Pending then
    local photoUrl = self:Tex_GetUrl(isThumbnail)
    local customLocalPath = FunctionPostcardTex.GetDefaultLocalPath(self, isThumbnail)
    PhotoAdpter.Ins():CancelRequest(photoUrl, true, customLocalPath)
  end
end
