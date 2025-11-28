autoImport("PhotoAdpter")
PhotoStandTestMe = class("PhotoStandTestMe")
local TEST = false

function PhotoStandTestMe.Me()
  if nil == PhotoStandTestMe.me then
    PhotoStandTestMe.me = PhotoStandTestMe.new()
  end
  return PhotoStandTestMe.me
end

function PhotoStandTestMe:ctor()
  self:___GenerateData()
end

local server_delay = 1000
local theme_data = {
  {
    topic = 1,
    names = {
      {language = 1, param = "主题1"}
    }
  },
  {
    topic = 2,
    names = {
      {language = 1, param = "主题2"}
    }
  },
  {
    topic = 3,
    names = {
      {language = 1, param = "主题3"}
    }
  },
  {
    topic = 4,
    names = {
      {language = 1, param = "主题4"}
    }
  },
  {
    topic = 5,
    names = {
      {language = 1, param = "主题5"}
    }
  }
}
local slide_data = {
  page = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {}
  },
  totalcount = 100,
  starttime = 0
}
local full_data = {}

function PhotoStandTestMe:___GenerateData()
  if not TEST then
    return
  end
  full_data = {}
  for i = 1, 100 do
    local d = {
      base = {id = i, accid = 1},
      serverid = 1,
      topic = math.random(1, 5),
      author = "玩家" .. math.random(1, 998),
      title = "biaotibiaoti" .. math.random(1, 998),
      desc = math.random(1, 100) > 50 and "寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语寄语" or "ji",
      expiretime = ServerTime.CurServerTime() + 120000,
      like = math.random(5, 55555),
      lottery = math.random(0, 55555),
      liked = math.random(1, 100) > 50,
      isMine = math.random(1, 100) > 70,
      totalzeny = math.random(0, 999999),
      unawardzeny = math.random(0, 999999),
      lastquerytime = ServerTime.CurServerTime() - math.random(10000, 100000),
      lists = {}
    }
    local sss = math.random(0, 25)
    for i = 1, sss do
      local s = {
        serverid = 1,
        charid = math.random(1111111111, 22222222222),
        name = "老爷" .. math.random(1, 9998),
        zeny = math.random(5, 55555),
        lottery = math.random(5, 55555),
        createtime = ServerTime.CurServerTime() - math.random(100000, 1000000)
      }
      table.insert(d.lists, s)
    end
    table.insert(full_data, d)
  end
end

function PhotoStandTestMe:ServerCall_BoardBaseInfoPhotoCmd()
  if not TEST then
    ServicePhotoCmdProxy.Instance:CallBoardBaseInfoPhotoCmd()
    return
  end
  local data = {
    uploadurl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  }
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardBaseInfoPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardTopicPhotoCmd()
  if not TEST then
    ServicePhotoCmdProxy.Instance:CallBoardTopicPhotoCmd()
    return
  end
  local data = {topics = theme_data}
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardTopicPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardRotateListPhotoCmd(page, npcid)
  if not TEST then
    ServicePhotoCmdProxy.Instance:CallBoardRotateListPhotoCmd(page, npcid)
    return
  end
  local data = {
    lists = {},
    page = page,
    starttime = ServerTime.CurServerTime(),
    totalcount = 0,
    npcid = npcid
  }
  if page == 0 then
    data.totalcount = slide_data.totalcount
  elseif 4 < page then
  else
    local b_idx = (page - 1) * 30
    local max = 3 < page and 10 or 30
    for i = 1, max do
      table.insert(data.lists, {
        id = i + b_idx,
        accid = 1
      })
    end
    data.totalcount = slide_data.totalcount
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardRotateListPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardListPhotoCmd(theme, page)
  if not TEST then
    ServicePhotoCmdProxy.Instance:CallBoardListPhotoCmd(theme, page)
    return
  end
  local data = {
    topic = theme,
    page = page,
    lists = {},
    totalcount = 0
  }
  local full = {}
  for i = 1, 100 do
    if full_data[i].topic == theme then
      table.insert(full, full_data[i].base)
    end
  end
  data.totalcount = #full
  if page <= math.ceil(#full / 30) then
    local s = (page - 1) * 30 + 1
    local e = math.min(page * 30, #full)
    for i = s, e do
      table.insert(data.lists, full[i])
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardListPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardQueryDetailPhotoCmd(id, accid)
  if not TEST then
    local bbb = PbMgr.CreateNewMsgByName("Cmd.PhotoBoardBase")
    bbb.id = id
    bbb.accid = accid
    local aaa = PbMgr.CreateNewMsgByName("Cmd.PhotoBoard")
    aaa.base = bbb
    ServicePhotoCmdProxy.Instance:CallBoardQueryDetailPhotoCmd(aaa)
    return
  end
  local data = {}
  for i = 1, 100 do
    if full_data[i].base.id == id and full_data[i].base.accid == accid then
      data.data = full_data[i]
      break
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardQueryDetailPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardQueryDataPhotoCmd(id, accid)
  if not TEST then
    local bbb = PbMgr.CreateNewMsgByName("Cmd.PhotoBoardBase")
    bbb.id = id
    bbb.accid = accid
    ServicePhotoCmdProxy.Instance:CallBoardQueryDataPhotoCmd(bbb)
    return
  end
  local data = {}
  for i = 1, 100 do
    if full_data[i].base.id == id and full_data[i].base.accid == accid then
      data.data = full_data[i]
      data.board = full_data[i].base
      break
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardQueryDataPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardMyListPhotoCmd(page)
  if not TEST then
    ServicePhotoCmdProxy.Instance:CallBoardMyListPhotoCmd(page)
    return
  end
  local data = {
    page = page,
    lists = {},
    totalcount = 0
  }
  local full = {}
  for i = 1, 100 do
    if full_data[i].isMine then
      table.insert(full, full_data[i].base)
    end
  end
  data.totalcount = #full
  if page <= math.ceil(#full / 30) then
    local s = (page - 1) * 30 + 1
    local e = math.min(page * 30, #full)
    for i = s, e do
      table.insert(data.lists, full[i])
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardMyListPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardAwardListPhotoCmd(id, accid)
  if not TEST then
    local bbb = PbMgr.CreateNewMsgByName("Cmd.PhotoBoardBase")
    bbb.id = id
    bbb.accid = accid
    ServicePhotoCmdProxy.Instance:CallBoardAwardListPhotoCmd(bbb)
    return
  end
  local data = {}
  for i = 1, 100 do
    if full_data[i].base.id == id and full_data[i].base.accid == accid then
      data.board = full_data[i].base
      data.lists = full_data[i].lists
      data.totalzeny = full_data[i].totalzeny
      data.unawardzeny = full_data[i].unawardzeny
      data.lastquerytime = full_data[i].lastquerytime
      full_data[i].lastquerytime = ServerTime.CurServerTime()
      break
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardAwardListPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardLikePhotoCmd(id, accid, like)
  if not TEST then
    local bbb = PbMgr.CreateNewMsgByName("Cmd.PhotoBoardBase")
    bbb.id = id
    bbb.accid = accid
    ServicePhotoCmdProxy.Instance:CallBoardLikePhotoCmd(bbb, like)
    if PhotoStandProxy.BoardGetAwardPhotoCmd_NO_RESP then
      PhotoStandProxy.Instance:ServerRecv_BoardLikePhotoCmd({
        board = {id = id, accid = accid},
        like = like
      })
    end
    return
  end
  local data = {}
  for i = 1, 100 do
    if full_data[i].base.id == id and full_data[i].base.accid == accid then
      full_data[i].liked = like
      local d = like and 1 or -1
      full_data[i].like = full_data[i].like + d
      data.board = full_data[i].base
      data.like = full_data[i].liked
      break
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardLikePhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardAwardPhotoCmd(id, accid, count)
  if not TEST then
    local bbb = PbMgr.CreateNewMsgByName("Cmd.PhotoBoardBase")
    bbb.id = id
    bbb.accid = accid
    ServicePhotoCmdProxy.Instance:CallBoardAwardPhotoCmd(bbb, count)
    if PhotoStandProxy.BoardGetAwardPhotoCmd_NO_RESP then
      PhotoStandProxy.Instance:ServerRecv_BoardAwardPhotoCmd({
        board = {id = id, accid = accid},
        lotterycount = count
      })
    end
    return
  end
  local data = {}
  for i = 1, 100 do
    if full_data[i].base.id == id and full_data[i].base.accid == accid then
      full_data[i].lottery = full_data[i].lottery + count
      data.board = full_data[i].base
      data.lotterycount = count
      break
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardAwardPhotoCmd(data)
  end, self)
end

function PhotoStandTestMe:ServerCall_BoardGetAwardPhotoCmd(id, accid)
  if not TEST then
    local bbb = PbMgr.CreateNewMsgByName("Cmd.PhotoBoardBase")
    bbb.id = id
    bbb.accid = accid
    ServicePhotoCmdProxy.Instance:CallBoardGetAwardPhotoCmd(bbb)
    if PhotoStandProxy.BoardGetAwardPhotoCmd_NO_RESP then
      PhotoStandProxy.Instance:ServerRecv_BoardGetAwardPhotoCmd({
        board = {id = id, accid = accid}
      })
    end
    return
  end
  local data = {}
  for i = 1, 100 do
    if full_data[i].base.id == id and full_data[i].base.accid == accid then
      data.board = full_data[i].base
      full_data[i].lists = {}
      full_data[i].unawardzeny = 0
      break
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
    PhotoStandProxy.Instance:ServerRecv_BoardGetAwardPhotoCmd(data)
  end, self)
end

local dl_delay_min = 800
local dl_delay_max = 2000
local fail_rate = 0
local dl_max = 1
local wl_max = 1000
local wl = {}
local dl_id
local done_flag = {}

function PhotoStandTestMe:___ResetDLSrv()
  if not TEST then
    return
  end
  wl = {}
  done_flag = {}
  TimeTickManager.Me():ClearTick(self)
end

function PhotoStandTestMe:AddRequest(photoUrl)
  if not TEST then
    PhotoAdpter.Ins():AddRequest(photoUrl)
    return
  end
  photoUrl = photoUrl:gsub("[_\\.].*", "")
  if dl_id == photoUrl then
    return
  end
  for i = 1, #wl do
    if wl[i] == photoUrl then
      return
    end
  end
  if #wl > wl_max then
    EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadRequestMax, {photoUrl})
    GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadRequestMax, {photoUrl})
    return
  end
  local localPath = self:_GetLocalPath(photoUrl)
  if FileHelper.ExistFile(localPath) and done_flag[photoUrl] then
    EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadSucc, {photoUrl})
    GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadSucc, {photoUrl})
    return
  end
  table.insert(wl, photoUrl)
  self:_TryDL()
end

function PhotoStandTestMe:ClearRequest()
  if not TEST then
    PhotoAdpter.Ins():ClearRequest()
    return
  end
  local _wl = table.deepcopy(wl)
  wl = {}
  for i = 1, #_wl do
    local photoUrl = _wl[i]
    EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadTerminated, {photoUrl})
    GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadTerminated, {photoUrl})
  end
end

function PhotoStandTestMe:_TryDL()
  if 0 < #wl and dl_id == nil then
    local photoUrl = wl[1]
    dl_id = photoUrl
    self:_RemoveFromWait(photoUrl)
    TimeTickManager.Me():CreateOnceDelayTick(math.random(dl_delay_min, dl_delay_max), function()
      if math.random(1, 100) > fail_rate then
        done_flag[photoUrl] = true
        EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadSucc, {photoUrl})
        GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadSucc, {photoUrl})
      else
        EventManager.Me():DispatchEvent(MyselfEvent.PhotoDonwloadFailed, {photoUrl})
        GameFacade.Instance:sendNotification(MyselfEvent.PhotoDonwloadFailed, {photoUrl})
      end
      dl_id = nil
      self:_TryDL()
    end, self)
  end
end

function PhotoStandTestMe:_GetLocalPath(photoUrl)
  if not TEST then
    return PhotoAdpter.Ins():GetLocalPath(photoUrl)
  end
  local photoLocalPath = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/PhotoAdpter/album_abc/" .. photoUrl .. ".png"
  return photoLocalPath
end

function PhotoStandTestMe:_RemoveFromWait(url)
  for i = 1, #wl do
    if wl[i] == url then
      table.remove(wl, i)
      break
    end
  end
end

function PhotoStandTestMe:p_getST()
  redlog("wl", TableUtil.ToStringEx(wl))
  redlog("dl_id", dl_id)
  redlog("done_flag", TableUtil.ToStringEx(done_flag))
end
