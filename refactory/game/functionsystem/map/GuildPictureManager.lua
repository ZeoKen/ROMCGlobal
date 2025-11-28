GuildPictureManager = class("GuildPictureManager")
autoImport("UnionLogo")

function GuildPictureManager.Instance()
  if nil == GuildPictureManager.me then
    GuildPictureManager.me = GuildPictureManager.new()
  end
  return GuildPictureManager.me
end

function GuildPictureManager:ctor()
  if self.toBeDownload then
    TableUtility.ArrayClear(self.toBeDownload)
  end
  self.toBeDownload = {}
  if self.LRUTextureCache then
    TableUtility.ArrayClear(self.LRUTextureCache)
  end
  self.LRUTextureCache = {}
  self.UploadingMap = {}
  self.maxCache = 30
  self.logEnable = true
  self.isDownloading = false
  self.textureRelativeMap = {}
  self.textureMasterRelativeMap = {}
  self.guildRelativeLevelMap = {}
  self.customTexCount = 0
  self.customMasterTexCount = 0
end

function GuildPictureManager:log(...)
  if self.logEnable then
    helplog(...)
  end
end

function GuildPictureManager:tryGetMyThumbnail(guild, callIndex, index, time, picType)
  self.isDownloading = true
  UnionLogo.Ins():SetUnionID(guild)
  UnionLogo.Ins():GetThumbnail(callIndex, index, time, picType, function(progress)
    self:MyThumbnailProgressCallback(guild, callIndex, index, time, progress)
  end, function(bytes)
    self:MyThumbnailSusCallback(guild, callIndex, index, time, bytes)
  end, function(errorMessage)
    self:MyThumbnailErrorCallback(guild, callIndex, index, time, errorMessage)
  end)
end

function GuildPictureManager:AddMyThumbnailInfos(list)
  if list and 0 < #list then
    for i = 1, #list do
      self:AddSingleMyThumbnail(list[i])
    end
    self:startTryGetMyThumbnail()
  end
end

function GuildPictureManager:AddSingleMyThumbnail(data)
  local index = data.index
  local time = data.time
  local guild = data.guild
  local callIndex = data.callIndex
  local picType = data.picType
  if nil == index or nil == time or nil == guild or nil == callIndex then
    return
  end
  local texture = self:GetThumbnailTextureById(guild, callIndex, index, time)
  if not texture then
    local hasIn = self:HasInToBeDownload(guild, callIndex, index, time)
    if not hasIn then
      local loadData = {
        callIndex = callIndex,
        index = index,
        time = time,
        guild = guild,
        picType = picType
      }
      self.toBeDownload[#self.toBeDownload + 1] = loadData
    end
  end
end

function GuildPictureManager:HasInToBeDownload(guild, callIndex, index, time)
  for i = 1, #self.toBeDownload do
    local single = self.toBeDownload[i]
    if single.index == index and single.guild == guild and single.time == time and single.callIndex == callIndex then
      return true
    end
  end
end

function GuildPictureManager:MyThumbnailSusCallback(guild, callIndex, index, time, bytes)
  self.isDownloading = false
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:addThumbnailTextureById(guild, callIndex, index, time, texture)
    self:removeOldTimeData(guild, callIndex, index, time)
    self:ThumbnailDownloadCompleteCallback1(guild, callIndex, index, time, bytes)
    self:removeDownloadTexture(guild, callIndex, index, time)
    self:startTryGetMyThumbnail()
  else
    self:MyThumbnailErrorCallback(guild, callIndex, index, time, "load LoadImage error!")
    Object.DestroyImmediate(texture)
  end
end

function GuildPictureManager:removePhotoCache(guild, callIndex, index, time)
  for i = 1, #self.LRUTextureCache do
    local single = self.LRUTextureCache[i]
    if single.index == index and single.guild == guild and single.callIndex == callIndex then
      local data = table.remove(self.LRUTextureCache, i)
      Object.DestroyImmediate(data.texture)
      self:ClearGuildPicRelative(data.guild)
      break
    end
  end
end

function GuildPictureManager:removeOldTimeData(guild, callIndex, index, time)
  for i = 1, #self.toBeDownload do
    local single = self.toBeDownload[i]
    if single.index == index and single.guild == guild and time > single.time and single.callIndex == callIndex then
      table.remove(self.toBeDownload, i)
      break
    end
  end
  for i = 1, #self.LRUTextureCache do
    local single = self.LRUTextureCache[i]
    if single.index == index and single.guild == guild and time > single.time and single.callIndex == callIndex then
      local data = table.remove(self.LRUTextureCache, i)
      Object.DestroyImmediate(data.texture)
      self:ClearGuildPicRelative(data.guild)
      break
    end
  end
end

function GuildPictureManager:MyThumbnailErrorCallback(guild, callIndex, index, time, errorMessage)
  self.isDownloading = false
  self:removeDownloadTexture(guild, callIndex, index, time)
  self:ThumbnailDownloadErrorCallback1(guild, callIndex, index, time, errorMessage)
  self:startTryGetMyThumbnail()
end

function GuildPictureManager:MyThumbnailProgressCallback(guild, callIndex, index, time, progress)
  self:ThumbnailDownloadProgressCallback1(guild, callIndex, index, time, progress)
end

function GuildPictureManager:startTryGetMyThumbnail()
  if FunctionPhotoStorage.IsActive() then
    local singleLoadData
    for i = 1, #self.toBeDownload do
      singleLoadData = self.toBeDownload[i]
      if singleLoadData then
        self:tryGetMyThumbnail(singleLoadData.guild, singleLoadData.callIndex, singleLoadData.index, singleLoadData.time, singleLoadData.picType)
      end
    end
    TableUtility.TableClear(self.toBeDownload)
    return
  end
  if #self.toBeDownload > 0 and not self.isDownloading then
    local loadData = self.toBeDownload[1]
    self:tryGetMyThumbnail(loadData.guild, loadData.callIndex, loadData.index, loadData.time, loadData.picType)
  end
end

function GuildPictureManager:GetThumbnailTexture(guild, callIndex, index, time)
  local texture = self:GetThumbnailTextureById(guild, callIndex, index, time, true)
  if texture then
    return texture
  end
end

function GuildPictureManager:GetThumbnailTextureById(guild, callIndex, index, time, rePos)
  for i = 1, #self.LRUTextureCache do
    local single = self.LRUTextureCache[i]
    if single.index == index and single.guild == guild and single.time == time and callIndex == single.callIndex then
      if rePos then
        table.remove(self.LRUTextureCache, i)
        table.insert(self.LRUTextureCache, 1, single)
      end
      return single.texture
    end
  end
end

function GuildPictureManager:addThumbnailTextureById(guild, callIndex, index, time, texture)
  if not self:GetThumbnailTextureById(guild, callIndex, index, time) then
    if #self.LRUTextureCache > self.maxCache then
      local oldData = table.remove(self.LRUTextureCache)
      Object.DestroyImmediate(oldData.texture)
      self:ClearGuildPicRelative(oldData.guild)
    end
    local data = {}
    data.index = index
    data.guild = guild
    data.texture = texture
    data.time = time
    data.callIndex = callIndex
    table.insert(self.LRUTextureCache, 1, data)
  else
    self:log("addThumbnailTextureById:exsit  index:", index)
    Object.DestroyImmediate(texture)
  end
end

function GuildPictureManager:removeDownloadTexture(guild, callIndex, index, time)
  for j = 1, #self.toBeDownload do
    local data = self.toBeDownload[j]
    if index == data.index and data.guild == guild and time == data.time and callIndex == data.callIndex then
      table.remove(self.toBeDownload, j)
      break
    end
  end
end

function GuildPictureManager:GetGuildCustomRelativeNum()
  return self.customTexCount or 0
end

function GuildPictureManager:CanSetGuildIcon(guild, masterID)
  if self.textureMasterRelativeMap[guild] or self.customMasterTexCount < (GameConfig.Guild and GameConfig.Guild.scenebottomiconlimit or 12) then
    return true
  end
  local relationLevel = self:GetPlayerRelationLevelByID(masterID)
  for guildID, guildRelationLevel in pairs(self.guildRelativeLevelMap) do
    if guildRelationLevel < relationLevel then
      return true
    end
  end
  return false
end

function GuildPictureManager:AddGuildPicRelative(guild, masterID)
  local curCount = self.textureRelativeMap[guild] or 0
  self.textureRelativeMap[guild] = curCount + 1
  if curCount == 0 then
    self.customTexCount = self.customTexCount + 1
  end
  if not masterID then
    return
  end
  local listMasterRelative = self.textureMasterRelativeMap[guild]
  if not listMasterRelative then
    listMasterRelative = ReusableTable.CreateArray()
    self.textureMasterRelativeMap[guild] = listMasterRelative
  end
  listMasterRelative[#listMasterRelative + 1] = masterID
  local relationLevel = self:GetPlayerRelationLevelByID(masterID)
  local curRelationLevel = self.guildRelativeLevelMap[guild]
  if not curRelationLevel or relationLevel > curRelationLevel then
    self.guildRelativeLevelMap[guild] = relationLevel
  end
  if #listMasterRelative == 1 then
    self.customMasterTexCount = self.customMasterTexCount + 1
    self:RefreshGuildPicRelative()
  end
end

function GuildPictureManager:GetPlayerRelationLevelByID(masterID)
  local weddingPartenerData = WeddingProxy.Instance:GetPartnerData()
  if weddingPartenerData and weddingPartenerData.charid == masterID then
    return 5
  end
  if TeamProxy.Instance:IsInMyGroup(masterID) then
    return 4
  end
  local friendProxy = FriendProxy.Instance
  if friendProxy:IsFriend(masterID) then
    return 3
  end
  if friendProxy:IsBlacklist(masterID) then
    return 1
  end
  return 2
end

function GuildPictureManager:RefreshGuildPicRelative()
  local limitNum = GameConfig.Guild and GameConfig.Guild.scenebottomiconlimit or 12
  while limitNum < self.customMasterTexCount do
    local lowestGuildID, lowestLevel
    for guild, relationLevel in pairs(self.guildRelativeLevelMap) do
      if not lowestLevel or relationLevel < lowestLevel then
        lowestGuildID = guild
        lowestLevel = relationLevel
      end
    end
    if lowestGuildID and not self:ClearGuildPicRelative(lowestGuildID) then
      LogUtility.Error(string.format("清理公会图标：%s失败，当前公会图标数量：%s", tostring(lowestGuildID), tostring(self.customMasterTexCount)))
      self.guildRelativeLevelMap[lowestGuildID] = nil
      break
    end
  end
end

function GuildPictureManager:RemoveGuildPicRelative(guild, masterID)
  local curCount = self.textureRelativeMap[guild]
  if not curCount then
    return
  end
  self.textureRelativeMap[guild] = curCount - 1
  if self.textureRelativeMap[guild] < 1 then
    if curCount < 1 then
      LogUtility.Error("公会Icon引用计数出错！看到此条请报给前端，ID：" .. tostring(guild))
    end
    self.textureRelativeMap[guild] = 0
    self.customTexCount = self.customTexCount - 1
    local i, max = 1, #self.LRUTextureCache + 1
    while i < max do
      local single = self.LRUTextureCache[i]
      if single.guild == guild then
        table.remove(self.LRUTextureCache, i)
        self.LRUTextureCache[#self.LRUTextureCache + 1] = single
        max = max - 1
      end
      i = i + 1
    end
  end
  if not masterID then
    return
  end
  local listMasterRelative = self.textureMasterRelativeMap[guild]
  if not listMasterRelative then
    return
  end
  for i = 1, #listMasterRelative do
    if listMasterRelative[i] == masterID then
      table.remove(listMasterRelative, i)
      break
    end
  end
  if #listMasterRelative < 1 then
    ReusableTable.DestroyAndClearArray(listMasterRelative)
    self.textureMasterRelativeMap[guild] = nil
    self.guildRelativeLevelMap[guild] = nil
    self.customMasterTexCount = self.customMasterTexCount - 1
    return
  end
  local relationLevel = self:GetPlayerRelationLevelByID(masterID)
  local curRelationLevel = self.guildRelativeLevelMap[guild] or 0
  if relationLevel < curRelationLevel then
    return
  end
  local highestLevel = 0
  for i = 1, #listMasterRelative do
    relationLevel = self:GetPlayerRelationLevelByID(listMasterRelative[i])
    if highestLevel < relationLevel then
      highestLevel = relationLevel
    end
  end
  self.guildRelativeLevelMap[guild] = highestLevel
end

function GuildPictureManager:ClearGuildPicRelative(guild)
  local curCount = self.textureRelativeMap[guild]
  if not curCount then
    return false
  end
  local listMasterRelative = self.textureMasterRelativeMap[guild]
  if not listMasterRelative then
    if self.textureRelativeMap[guild] > 0 then
      redlog("正在使用中的公会自定义图标被清理。ID: " .. tostring(guild))
    end
    return false
  end
  local creature, sceneUI, nameFactionCell
  local clearCount = 0
  for i = 1, #listMasterRelative do
    creature = NSceneUserProxy.Instance:Find(listMasterRelative[i])
    if creature then
      sceneUI = creature:GetSceneUI()
      nameFactionCell = sceneUI and sceneUI.roleBottomUI.nameFactionCell
      if nameFactionCell and nameFactionCell:HideCustomFaction(true) then
        clearCount = clearCount + 1
      end
    end
  end
  self.textureRelativeMap[guild] = curCount - clearCount
  if curCount > clearCount then
    redlog("正在使用中的公会自定义图标被清理。ID: " .. tostring(guild))
  end
  ReusableTable.DestroyAndClearArray(listMasterRelative)
  self.textureMasterRelativeMap[guild] = nil
  self.guildRelativeLevelMap[guild] = nil
  self.customMasterTexCount = self.customMasterTexCount - 1
  return true
end

GuildPictureManager.ThumbnailDownloadProgressCallback = "GuildPictureManager_ThumbnailDownloadProgressCallback"
GuildPictureManager.ThumbnailDownloadCompleteCallback = "GuildPictureManager_ThumbnailDownloadCompleteCallback"
GuildPictureManager.ThumbnailDownloadErrorCallback = "GuildPictureManager_ThumbnailDownloadErrorCallback"
GuildPictureManager.OriginPhotoDownloadProgressCallback = "GuildPictureManager_OriginPhotoDownloadProgressCallback"
GuildPictureManager.OriginPhotoDownloadCompleteCallback = "GuildPictureManager_OriginPhotoDownloadCompleteCallback"
GuildPictureManager.OriginPhotoDownloadErrorCallback = "GuildPictureManager_OriginPhotoDownloadErrorCallback"
GuildPictureManager.OriginPhotoUploadProgressCallback = "GuildPictureManager_OriginPhotoUploadProgressCallback"
GuildPictureManager.OriginPhotoUploadCompleteCallback = "GuildPictureManager_OriginPhotoUploadCompleteCallback"
GuildPictureManager.OriginPhotoUploadErrorCallback = "GuildPictureManager_OriginPhotoUploadErrorCallback"

function GuildPictureManager:ThumbnailDownloadProgressCallback1(guild, callIndex, index, time, progress)
  GameFacade.Instance:sendNotification(GuildPictureManager.ThumbnailDownloadProgressCallback, {
    callIndex = callIndex,
    guild = guild,
    index = index,
    time = time,
    progress = progress
  })
end

function GuildPictureManager:ThumbnailDownloadCompleteCallback1(guild, callIndex, index, time, bytes)
  local cdata = {
    callIndex = callIndex,
    guild = guild,
    index = index,
    time = time,
    byte = bytes
  }
  GameFacade.Instance:sendNotification(GuildPictureManager.ThumbnailDownloadCompleteCallback, cdata)
  EventManager.Me():PassEvent(GuildPictureManager.ThumbnailDownloadCompleteCallback, cdata)
end

function GuildPictureManager:ThumbnailDownloadErrorCallback1(guild, callIndex, index, time, errorMessage)
  local cdata = {
    callIndex = callIndex,
    guild = guild,
    index = index,
    time = time
  }
  GameFacade.Instance:sendNotification(GuildPictureManager.ThumbnailDownloadErrorCallback, cdata)
  EventManager.Me():PassEvent(GuildPictureManager.ThumbnailDownloadErrorCallback, cdata)
end
