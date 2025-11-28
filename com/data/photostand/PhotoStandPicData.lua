PhotoStandPicData = class("PhotoStandPicData")

function PhotoStandPicData:ctor(id, accid)
  self.id = id
  self.accid = accid
  self.fs_status = 0
  self.fs_tex_path = nil
  self.fs_tex = nil
  self.high_status = 0
  self.high_tex_path = nil
  self.key = self.id .. " " .. self.accid
end

function PhotoStandPicData:Server_SetDetailData(serverData)
  self.detail_obtained = true
  self.id = serverData.base.id
  self.accid = serverData.base.accid
  self.serverid = serverData.serverid
  self.official = self.serverid == 0
  self.author = serverData.author
  self.topic = serverData.topic
  self.title = serverData.title
  self.desc = serverData.desc
  self.expiretime = serverData.expiretime
  self.charid = serverData.charid
  self.TEST_isMine = serverData.isMine
end

function PhotoStandPicData:Server_SetDynamicData(serverData, newaward)
  self.dynamic_obtained = true
  self.like = serverData.like
  self.liked = serverData.liked
  self.lottery = serverData.lottery
  self.newaward = newaward
end

function PhotoStandPicData:Server_SetMyPicSponsorData(serverData)
  self.mine_obtained = true
  self.totalzeny = serverData.totalzeny
  self.unawardzeny = serverData.unawardzeny
  self.lastquerytime = serverData.lastquerytime
  self.laoyelists = {}
  for i = 1, #serverData.lists do
    table.insert(self.laoyelists, PhotoStandLaoYeData.new(serverData.lists[i], self.lastquerytime))
  end
end

function PhotoStandPicData:Author_CanCheckDetail()
  return MyselfProxy.Instance:GetServerId() == self.serverid and self.charid and self.charid ~= 0
end

function PhotoStandPicData:Author_GetAuthorName()
  if self.author and self.author ~= "" then
    return self.author
  end
  if self.char_author_info then
    return self.char_author_info.name
  end
end

function PhotoStandPicData:Author_SetAuthorInfo(data)
  if not data then
    self.char_author_info = nil
    return
  end
  self.char_author_info = table.deepcopy(data)
  self.char_author_info.expiretime = ServerTime.CurServerTime() / 1000 + 60
end

function PhotoStandPicData:Author_GetAuthorInfo(auto_fetch)
  if self.char_author_info and self.char_author_info.expiretime and self.char_author_info.expiretime < ServerTime.CurServerTime() / 1000 then
    self.char_author_info = nil
  end
  if self.char_author_info then
    return self.char_author_info
  end
  if auto_fetch then
    if self.charid == Game.Myself.data.id then
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.charid)
    else
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.charid)
    end
  end
end

function PhotoStandPicData:Author_GetAuthorInfoRaw()
  return self.char_author_info
end

function PhotoStandPicData:Author_IsHaveIntro()
  return self.title and self.title ~= "" and self.desc and self.desc ~= ""
end

function PhotoStandPicData:IsMine()
  return self.accid == FunctionLogin.Me():getLoginData().accid or self.TEST_isMine == true
end

function PhotoStandPicData:IsDetailObtained()
  return self.detail_obtained
end

function PhotoStandPicData:IsDynamicObtained()
  return self.dynamic_obtained
end

function PhotoStandPicData:IsMineInfoObtained()
  return self.mine_obtained
end

function PhotoStandPicData:ForceClearMineInfoObtained()
  self.mine_obtained = false
end

function PhotoStandPicData:Client_AddLike(like)
  if not self.like then
    self.like = like and 1 or 0
  else
    self.like = math.max(0, self.like + (self.like and 1 or -1))
  end
  self.liked = like
end

function PhotoStandPicData:Client_AddSponsor(count)
  if not self.award then
    self.award = count
  else
    self.award = math.max(0, self.award + count)
  end
end

local isNil = LuaGameObject.ObjectIsNull
PhotoStandPicData.Status = {
  Null = 0,
  Pending = 1,
  Done = 2,
  Failed = 3
}

function PhotoStandPicData:SetStatusResult(status, asset_path)
  self.fs_status = status
  if asset_path then
    self.fs_tex_path = asset_path
  end
end

function PhotoStandPicData:GetTex(slideNpc)
  if not isNil(self.fs_tex) then
    if not slideNpc then
      PhotoStandPicData.LRU_UI_Add(self.fs_tex)
    else
      PhotoStandPicData.LRU_NPC_Add(self.fs_tex, slideNpc)
    end
    return self.fs_tex
  end
  if self.fs_tex_path then
    local currentServerTime = ServerTime.CurServerTime() or -1
    self.fs_tex = DiskFileManager.Instance:LoadTexture2D(self.fs_tex_path, currentServerTime / 1000, 100)
    if self.fs_tex then
      if not slideNpc then
        PhotoStandPicData.LRU_UI_Add(self.fs_tex)
      else
        PhotoStandPicData.LRU_NPC_Add(self.fs_tex, slideNpc)
      end
      return self.fs_tex
    end
  elseif self.fs_status ~= PhotoStandPicData.Status.Failed then
    self:DownloadTex()
  end
end

function PhotoStandPicData:DownloadTex(force)
  if not force and (self.fs_status == PhotoStandPicData.Status.Done or self.fs_status == PhotoStandPicData.Status.Pending) then
    return
  end
  self:SetStatusResult(PhotoStandPicData.Status.Pending)
  PhotoStandTestMe.Me():AddRequest(self:GetPhotoUrl())
end

function PhotoStandPicData:HasHighResTex()
  return self.high_tex_path ~= nil
end

function PhotoStandPicData:SetHighResTexStatusResult(status, asset_path)
  self.high_status = status
  if asset_path then
    self.high_tex_path = asset_path
  end
end

function PhotoStandPicData:GetHighResTex()
  if self.high_tex_path then
    local currentServerTime = ServerTime.CurServerTime() or -1
    local _tex = DiskFileManager.Instance:LoadTexture2D(self.high_tex_path, currentServerTime / 1000, 100)
    return _tex
  else
    self:_DownloadHighResTex()
  end
end

function PhotoStandPicData:_DownloadHighResTex(force)
  if not force and (self.high_status == PhotoStandPicData.Status.Done or self.high_status == PhotoStandPicData.Status.Pending) then
    return
  end
  self:SetHighResTexStatusResult(PhotoStandPicData.Status.Pending)
  PhotoStandTestMe.Me():AddRequest(self:GetPhotoUrl(true))
end

local the_ext = "_thumb.astc"
local full_ext = ".astc"
local the_ext_pc = "_thumb.png"
local full_ext_pc = ".png"

function PhotoStandPicData:GetPhotoUrl(highRes)
  if not PhotoStandPicData.PhotoUrlPath then
    PhotoStandPicData.PhotoUrlPath = FunctionPhotoStorage.Me():GetPhotoUrlPath(FunctionPhotoStorage.PhotoType.PhotoBoard, true)
  end
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.WindowsPlayer then
    return PhotoStandPicData.PhotoUrlPath .. self.id .. (highRes and full_ext_pc or the_ext_pc)
  else
    return PhotoStandPicData.PhotoUrlPath .. self.id .. (highRes and full_ext or the_ext)
  end
end

function PhotoStandPicData:GetLocalResPath(highRes)
  if highRes then
    return self.high_tex_path
  else
    return self.fs_tex_path
  end
end

function PhotoStandPicData.Util_ParseUrlFromThumbUrl(url)
  return string.gsub(url, the_ext, full_ext)
end

function PhotoStandPicData:Dispose()
  if not isNil(self.fs_tex) then
    Object.DestroyImmediate(self.fs_tex)
    self.fs_tex = nil
  end
end

local lru_ui, lru_npc_map, tex_ref_count

function PhotoStandPicData.LRU_Init()
  if not lru_ui then
    lru_ui = SimpleLuaLRU.new(20)
  end
  if not lru_npc_map then
    lru_npc_map = {}
  end
  if not tex_ref_count then
    tex_ref_count = {}
  end
end

function PhotoStandPicData.LRU_UI_Add(tex)
  if not tex then
    return
  end
  if not lru_ui then
    lru_ui = SimpleLuaLRU.new(20)
  end
  PhotoStandPicData._LRU_Add(lru_ui, tex)
end

function PhotoStandPicData.LRU_NPC_Add(tex, npc)
  if not tex or not npc then
    return
  end
  local lru = lru_npc_map[npc]
  if not lru then
    lru = SimpleLuaLRU.new(2)
    lru_npc_map[npc] = lru
  end
  PhotoStandPicData._LRU_Add(lru, tex)
end

function PhotoStandPicData._LRU_Add(lru, tex)
  local rm_tex, new_add = lru:Add(tex)
  if new_add then
    if tex_ref_count[tex] then
      tex_ref_count[tex] = tex_ref_count[tex] + 1
    else
      tex_ref_count[tex] = 1
    end
  end
  PhotoStandPicData._LRU_TryRemove(rm_tex)
end

function PhotoStandPicData._LRU_TryRemove(tex)
  if not tex then
    return
  end
  if tex_ref_count[tex] then
    tex_ref_count[tex] = tex_ref_count[tex] - 1
  end
  if not tex_ref_count[tex] or tex_ref_count[tex] <= 0 then
    tex_ref_count[tex] = nil
    PhotoStandPicData._DestroyTex(tex)
  end
end

function PhotoStandPicData.LRU_UI_Dispose()
  if lru_ui then
    lru_ui:Dispose(function(rm_tex)
      PhotoStandPicData._LRU_TryRemove(rm_tex)
    end)
    lru_ui = nil
  end
end

function PhotoStandPicData.LRU_NPC_Dispose(npc)
  if not npc then
    return
  end
  local lru = lru_npc_map[npc]
  if lru then
    lru:Dispose(function(rm_tex)
      PhotoStandPicData._LRU_TryRemove(rm_tex)
    end)
    lru_npc_map[npc] = nil
  end
end

function PhotoStandPicData.LRU_Dispose()
  lru_ui = nil
  lru_npc_map = nil
  tex_ref_count = nil
end

function PhotoStandPicData._DestroyTex(tex)
  if isNil(tex) then
    return
  end
  local picDataList = PhotoStandProxy.Instance.knownList
  for k, v in pairs(picDataList) do
    if v.fs_tex == tex then
      picDataList[k].fs_tex = nil
    end
  end
  Object.DestroyImmediate(tex)
end

PhotoStandLaoYeData = class("PhotoStandLaoYeData")

function PhotoStandLaoYeData:ctor(serverData, qTime)
  self.serverid = serverData.serverid
  self.charid = serverData.charid
  self.name = serverData.name
  self.zeny = serverData.zeny
  self.lottery = serverData.lottery
  self.isNew = qTime < serverData.createtime
  self.createtime = serverData.createtime
end
