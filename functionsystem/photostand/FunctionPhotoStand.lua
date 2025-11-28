local str_split = function(str, character)
  local result = {}
  local index = 1
  for s in string.gmatch(str, "[^" .. character .. "]+") do
    result[index] = s
    index = index + 1
  end
  return result
end
local default_tex_dir = "GUI/pic/Loading/"
FunctionPhotoStand = class("FunctionPhotoStand")
FunctionPhotoStand.ShowViewPhotoStandEmoji = 900001
FunctionPhotoStand.HideViewPhotoStandEmoji = 900002

function FunctionPhotoStand.Me()
  if nil == FunctionPhotoStand.me then
    FunctionPhotoStand.me = FunctionPhotoStand.new()
  end
  return FunctionPhotoStand.me
end

function FunctionPhotoStand:ctor()
  self.texData = {}
  self:AddListener()
end

function FunctionPhotoStand:AddListener()
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadRequestMax, self.OnPhotoDonwloadFailed, self)
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadSucc, self.OnPhotoDonwloadSucc, self)
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadFailed, self.OnPhotoDonwloadFailed, self)
  EventManager.Me():AddEventListener(MyselfEvent.PhotoDonwloadTerminated, self.OnPhotoDonwloadTerminated, self)
end

function FunctionPhotoStand:OnPhotoDonwloadSucc(data)
  local pl = data.data
  local url = pl[1]
  if pl[2] then
    return
  end
  local sp = str_split(url, "/")
  local pic_name = sp[#sp]
  local check_is_thumb = string.find(pic_name, "_thumb")
  pic_name = pic_name:gsub("[_\\.].*", "")
  local id = tonumber(pic_name)
  local picData = PhotoStandProxy.Instance:_GetPicDataById(id)
  if picData then
    local path = PhotoStandTestMe.Me():_GetLocalPath(url)
    if not check_is_thumb then
      picData:SetHighResTexStatusResult(PhotoStandPicData.Status.Done, path)
      GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.DL_HighRes_PhotoDonwloadSucc, {
        id = id,
        accid = picData.accid
      })
      return
    end
    picData:SetStatusResult(PhotoStandPicData.Status.Done, path)
    GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.DL_PhotoDonwloadSucc, {
      id = picData.id,
      accid = picData.accid
    })
    for k, v in pairs(self.slide_info) do
      if v.using_local_tex then
        local curPicData = PhotoStandProxy.Instance.slideList[k]
        curPicData = curPicData and curPicData:TryGetCurSpotPicData()
        if picData and curPicData and picData.id == curPicData.id and picData.accid == curPicData.accid then
          v:PlaySlide()
        end
      end
    end
  else
    redlog("OnPhotoDonwloadSucc", url, "pic data not found")
  end
end

function FunctionPhotoStand:OnPhotoDonwloadFailed(data)
  local pl = data.data
  local url = pl[1]
  if pl[2] then
    return
  end
  local sp = str_split(url, "/")
  local pic_name = sp[#sp]
  local check_is_thumb = string.find(pic_name, "_thumb")
  pic_name = pic_name:gsub("[_\\.].*", "")
  local id = tonumber(pic_name)
  local picData = PhotoStandProxy.Instance:_GetPicDataById(id)
  if picData then
    if not check_is_thumb then
      picData:SetHighResTexStatusResult(PhotoStandPicData.Status.Failed)
      GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.DL_HighRes_PhotoDonwloadFailed, {
        id = id,
        accid = picData.accid
      })
      return
    end
    picData:SetStatusResult(PhotoStandPicData.Status.Failed)
    GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.DL_PhotoDonwloadFailed, {
      id = picData.id,
      accid = picData.accid
    })
  else
    redlog("OnPhotoDonwloadFailed", url, "pic data not found")
  end
end

function FunctionPhotoStand:OnPhotoDonwloadTerminated(data)
  local pl = data.data
  local url = pl[1]
  if pl[2] then
    return
  end
  local sp = str_split(url, "/")
  local pic_name = sp[#sp]
  local check_is_thumb = string.find(pic_name, "_thumb")
  pic_name = pic_name:gsub("[_\\.].*", "")
  local id = tonumber(pic_name)
  local picData = PhotoStandProxy.Instance:_GetPicDataById(id)
  if picData then
    if not check_is_thumb then
      picData:SetHighResTexStatusResult(PhotoStandPicData.Status.Null)
      GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.DL_HighRes_PhotoDonwloadTerminated, {
        id = id,
        accid = picData.accid
      })
      return
    end
    picData:SetStatusResult(PhotoStandPicData.Status.Null)
    GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.DL_PhotoDonwloadTerminated, {
      id = picData.id,
      accid = picData.accid
    })
  else
    redlog("OnPhotoDonwloadTerminated", url, "pic data not found")
  end
end

function FunctionPhotoStand:Launch()
  local s = GameConfig.PhotoBoard and GameConfig.PhotoBoard.Maps
  local s_npc = s and s[Game.MapManager:GetMapID()]
  if not s_npc or type(s_npc) ~= "table" then
    redlog("FunctionPhotoStand", "GameConfig.PhotoBoard.Maps 配置不对！")
    return
  end
  self.slide_info = {}
  self.local_texs = {}
  for i = 1, #s_npc do
    self.slide_info[s_npc[i]] = PhotoStandSlideCtrl.new(s_npc[i])
  end
  self.isRunning = true
  PhotoStandPicData.LRU_Init()
  PhotoStandProxy.Instance:ProxyLaunch()
  if Game.GameObjectType.PhotoStand then
    local manager = Game.GameObjectManagers[Game.GameObjectType.PhotoStand]
    if manager then
      manager:Launch()
    end
  end
end

function FunctionPhotoStand:Shutdown()
  if not self.isRunning then
    return
  end
  TimeTickManager.Me():ClearTick(self)
  for k, v in pairs(self.slide_info) do
    v:Dispose()
  end
  self.slide_info = {}
  self.isRunning = false
  PhotoStandProxy.Instance:ProxyShutdown()
  if Game.GameObjectType.PhotoStand then
    local manager = Game.GameObjectManagers[Game.GameObjectType.PhotoStand]
    if manager then
      manager:Shutdown()
    end
  end
  self:DestroyLocalSlideTex()
  PhotoStandPicData.LRU_Dispose()
  Game.GCSystemManager:Collect()
end

function FunctionPhotoStand:RegisterNNpc(nnpc)
  local id = nnpc and nnpc.data and nnpc.data.id
  local npc_id = nnpc and nnpc.data and nnpc and nnpc.data.staticData.id
  if not id or not npc_id then
    return
  end
  local slide = self.slide_info[npc_id]
  if slide then
    local len, ccc, pos = #slide.luago, 0, 1
    local reg_key = npc_id * 100 + 1
    for i = 1, len do
      ccc = slide.luago[i]
      pos = i
      if reg_key < ccc then
        break
      end
      if reg_key == ccc then
        reg_key = reg_key + 1
        pos = i + 1
      end
    end
    table.insert(slide.luago, pos, reg_key)
    return reg_key
  end
end

function FunctionPhotoStand:UnregisterLuaGO(ID)
  local npc_id = math.floor(ID / 100)
  local slide = self.slide_info[npc_id]
  if slide then
    TableUtility.ArrayRemove(slide.luago, ID)
    if #slide.luago == 0 then
      PhotoStandPicData.LRU_NPC_Dispose(npc_id)
    end
  end
end

function FunctionPhotoStand:TrySetPhoto4Frame(frame)
  for _, v in pairs(self.slide_info) do
    if TableUtility.ArrayFindIndex(v.luago, frame.ID) > 0 then
      v:PlaySlide(frame.ID)
    end
  end
end

function FunctionPhotoStand:InitSlide(npc, dt, spot_idx, totalcount)
  local slide = self.slide_info[npc]
  if slide then
    slide:InitSlide(dt, spot_idx, totalcount)
  end
end

function FunctionPhotoStand:GetLocalSlideTex(tex_id, cb)
  if not self.local_texs[tex_id] then
    Game.AssetManager_UI:LoadAsset(tex_id, Texture, function(_, asset)
      if asset then
        self.local_texs[tex_id] = asset
        if cb then
          cb(asset)
        end
      end
    end)
  elseif cb then
    cb(self.local_texs[tex_id])
  end
end

function FunctionPhotoStand:DestroyLocalSlideTex()
  for k, _ in pairs(self.local_texs) do
    Game.AssetManager_UI:UnLoadAsset(k)
  end
  self.local_texs = nil
end

PhotoStandSlideCtrl = class("PhotoStandSlideCtrl")

function PhotoStandSlideCtrl:ctor(npc)
  self.npc = npc
  self.spot_idx = 0
  self.totalcount = 0
  self.local_spot_idx = 0
  self.luago = {}
  self.manager = Game.GameObjectManagers[Game.GameObjectType.PhotoStand]
end

function PhotoStandSlideCtrl:InitSlide(dt, spot_idx, totalcount)
  local cur_left_duration = dt % (PhotoStandProxy.SlideShowDuration * 1000)
  self.spot_idx = spot_idx
  self.totalcount = totalcount
  self:PlaySlide()
  self.ltSlide = TimeTickManager.Me():CreateOnceDelayTick(cur_left_duration, function(owner, deltaTime)
    self.ltSlide = nil
    self:TriggerSlide()
  end, self)
end

function PhotoStandSlideCtrl:TriggerSlide()
  self.spot_idx = self.spot_idx + 1
  self:PlaySlide()
  self.ltSlide = TimeTickManager.Me():CreateOnceDelayTick(PhotoStandProxy.SlideShowDuration * 1000, function(owner, deltaTime)
    self.ltSlide = nil
    self:TriggerSlide()
  end, self)
end

function PhotoStandSlideCtrl:PlaySlide(frameID)
  if not self.manager:HasPhotoFrame(self.luago) then
    return
  end
  if frameID and TableUtility.ArrayFindIndex(self.luago, frameID) <= 0 then
    return
  end
  if self.totalcount == 0 then
    self:PlayTheLocalSlide(frameID)
    return
  end
  local thelist = PhotoStandProxy.Instance.slideList[self.npc]
  if thelist and thelist.activeOnShow and thelist.usageTag == "scene" then
    thelist:SetCurSpotPicIndex(self.spot_idx)
    local thedata = thelist:TryGetCurSpotPicData()
    local thetex = thedata and thedata:GetTex(self.npc)
    if thetex then
      if frameID then
        self:SetPhoto(frameID, thetex)
      else
        for k, v in ipairs(self.luago) do
          self:SetPhoto(v, thetex)
        end
      end
      self.using_local_tex = nil
    else
      self:PlayTheLocalSlide(frameID)
    end
  end
end

function PhotoStandSlideCtrl:PlayTheLocalSlide(frameID)
  if not (GameConfig.PhotoBoard and GameConfig.PhotoBoard.Defaultphotos) or #GameConfig.PhotoBoard.Defaultphotos == 0 then
    return
  end
  local sum = #GameConfig.PhotoBoard.Defaultphotos
  self.local_spot_idx = self.local_spot_idx + 1
  self.local_spot_idx = (self.local_spot_idx - 1) % sum + 1
  local tex_id = default_tex_dir .. GameConfig.PhotoBoard.Defaultphotos[self.local_spot_idx]
  FunctionPhotoStand.Me():GetLocalSlideTex(tex_id, function(asset)
    if asset then
      if frameID then
        self:SetPhoto(frameID, asset)
      else
        for k, v in ipairs(self.luago) do
          self:SetPhoto(v, asset)
        end
      end
    end
  end)
  self.using_local_tex = true
end

function PhotoStandSlideCtrl:SetPhoto(frame, tex)
  self.manager:PlaySlide(frame, tex)
end

function PhotoStandSlideCtrl:Dispose()
  if self.ltSlide then
    self.ltSlide:Destroy()
    self.ltSlide = nil
  end
end
