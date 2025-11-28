ServicePhotoCmdAutoProxy = class("ServicePhotoCmdAutoProxy", ServiceProxy)
ServicePhotoCmdAutoProxy.Instance = nil
ServicePhotoCmdAutoProxy.NAME = "ServicePhotoCmdAutoProxy"

function ServicePhotoCmdAutoProxy:ctor(proxyName)
  if ServicePhotoCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServicePhotoCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePhotoCmdAutoProxy.Instance = self
  end
end

function ServicePhotoCmdAutoProxy:Init()
end

function ServicePhotoCmdAutoProxy:onRegister()
  self:Listen(30, 1, function(data)
    self:RecvPhotoQueryListCmd(data)
  end)
  self:Listen(30, 2, function(data)
    self:RecvPhotoOptCmd(data)
  end)
  self:Listen(30, 3, function(data)
    self:RecvPhotoUpdateNtf(data)
  end)
  self:Listen(30, 4, function(data)
    self:RecvFrameActionPhotoCmd(data)
  end)
  self:Listen(30, 5, function(data)
    self:RecvQueryFramePhotoListPhotoCmd(data)
  end)
  self:Listen(30, 6, function(data)
    self:RecvQueryUserPhotoListPhotoCmd(data)
  end)
  self:Listen(30, 7, function(data)
    self:RecvUpdateFrameShowPhotoCmd(data)
  end)
  self:Listen(30, 8, function(data)
    self:RecvFramePhotoUpdatePhotoCmd(data)
  end)
  self:Listen(30, 9, function(data)
    self:RecvQueryMd5ListPhotoCmd(data)
  end)
  self:Listen(30, 10, function(data)
    self:RecvAddMd5PhotoCmd(data)
  end)
  self:Listen(30, 11, function(data)
    self:RecvRemoveMd5PhotoCmd(data)
  end)
  self:Listen(30, 12, function(data)
    self:RecvQueryUrlPhotoCmd(data)
  end)
  self:Listen(30, 13, function(data)
    self:RecvQueryUploadInfoPhotoCmd(data)
  end)
  self:Listen(30, 14, function(data)
    self:RecvBoardBaseInfoPhotoCmd(data)
  end)
  self:Listen(30, 15, function(data)
    self:RecvBoardTopicPhotoCmd(data)
  end)
  self:Listen(30, 16, function(data)
    self:RecvBoardRotateListPhotoCmd(data)
  end)
  self:Listen(30, 17, function(data)
    self:RecvBoardListPhotoCmd(data)
  end)
  self:Listen(30, 18, function(data)
    self:RecvBoardMyListPhotoCmd(data)
  end)
  self:Listen(30, 19, function(data)
    self:RecvBoardQueryDetailPhotoCmd(data)
  end)
  self:Listen(30, 20, function(data)
    self:RecvBoardQueryDataPhotoCmd(data)
  end)
  self:Listen(30, 21, function(data)
    self:RecvBoardAwardListPhotoCmd(data)
  end)
  self:Listen(30, 22, function(data)
    self:RecvBoardLikePhotoCmd(data)
  end)
  self:Listen(30, 23, function(data)
    self:RecvBoardAwardPhotoCmd(data)
  end)
  self:Listen(30, 24, function(data)
    self:RecvBoardGetAwardPhotoCmd(data)
  end)
  self:Listen(30, 25, function(data)
    self:RecvBoardOpenPhotoCmd(data)
  end)
  self:Listen(30, 26, function(data)
    self:RecvSendPostcardCmd(data)
  end)
  self:Listen(30, 27, function(data)
    self:RecvPostcardListCmd(data)
  end)
  self:Listen(30, 28, function(data)
    self:RecvSavePostcardCmd(data)
  end)
  self:Listen(30, 29, function(data)
    self:RecvUpdatePostcardCmd(data)
  end)
  self:Listen(30, 30, function(data)
    self:RecvDelPostcardCmd(data)
  end)
  self:Listen(30, 31, function(data)
    self:RecvViewPostcardCmd(data)
  end)
  self:Listen(30, 32, function(data)
    self:RecvBoardQueryAwardPhotoCmd(data)
  end)
end

function ServicePhotoCmdAutoProxy:CallPhotoQueryListCmd(photos, size)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PhotoQueryListCmd()
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    if size ~= nil then
      msg.size = size
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PhotoQueryListCmd.id
    local msgParam = {}
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    if size ~= nil then
      msgParam.size = size
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallPhotoOptCmd(opttype, index, anglez, mapid)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PhotoOptCmd()
    if opttype ~= nil then
      msg.opttype = opttype
    end
    if index ~= nil then
      msg.index = index
    end
    if anglez ~= nil then
      msg.anglez = anglez
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PhotoOptCmd.id
    local msgParam = {}
    if opttype ~= nil then
      msgParam.opttype = opttype
    end
    if index ~= nil then
      msgParam.index = index
    end
    if anglez ~= nil then
      msgParam.anglez = anglez
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallPhotoUpdateNtf(opttype, photo)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PhotoUpdateNtf()
    if opttype ~= nil then
      msg.opttype = opttype
    end
    if photo ~= nil and photo.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.index = photo.index
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.time = photo.time
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.isupload ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.isupload = photo.isupload
    end
    if photo ~= nil and photo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.charid = photo.charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PhotoUpdateNtf.id
    local msgParam = {}
    if opttype ~= nil then
      msgParam.opttype = opttype
    end
    if photo ~= nil and photo.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.index = photo.index
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.time = photo.time
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.isupload ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.isupload = photo.isupload
    end
    if photo ~= nil and photo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.charid = photo.charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallFrameActionPhotoCmd(frameid, action, photos)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.FrameActionPhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if action ~= nil then
      msg.action = action
    end
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FrameActionPhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if action ~= nil then
      msgParam.action = action
    end
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallQueryFramePhotoListPhotoCmd(frameid, photos)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryFramePhotoListPhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFramePhotoListPhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallQueryUserPhotoListPhotoCmd(frames, maxphoto, maxframe)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryUserPhotoListPhotoCmd()
    if frames ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.frames == nil then
        msg.frames = {}
      end
      for i = 1, #frames do
        table.insert(msg.frames, frames[i])
      end
    end
    if maxphoto ~= nil then
      msg.maxphoto = maxphoto
    end
    if maxframe ~= nil then
      msg.maxframe = maxframe
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserPhotoListPhotoCmd.id
    local msgParam = {}
    if frames ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.frames == nil then
        msgParam.frames = {}
      end
      for i = 1, #frames do
        table.insert(msgParam.frames, frames[i])
      end
    end
    if maxphoto ~= nil then
      msgParam.maxphoto = maxphoto
    end
    if maxframe ~= nil then
      msgParam.maxframe = maxframe
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallUpdateFrameShowPhotoCmd(shows)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.UpdateFrameShowPhotoCmd()
    if shows ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.shows == nil then
        msg.shows = {}
      end
      for i = 1, #shows do
        table.insert(msg.shows, shows[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateFrameShowPhotoCmd.id
    local msgParam = {}
    if shows ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.shows == nil then
        msgParam.shows = {}
      end
      for i = 1, #shows do
        table.insert(msgParam.shows, shows[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallFramePhotoUpdatePhotoCmd(frameid, update, del)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.FramePhotoUpdatePhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if update ~= nil and update.accid_svr ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.accid_svr = update.accid_svr
    end
    if update ~= nil and update.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.accid = update.accid
    end
    if update ~= nil and update.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.charid = update.charid
    end
    if update ~= nil and update.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.anglez = update.anglez
    end
    if update ~= nil and update.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.time = update.time
    end
    if update ~= nil and update.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.mapid = update.mapid
    end
    if update ~= nil and update.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.sourceid = update.sourceid
    end
    if update ~= nil and update.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.source = update.source
    end
    if del ~= nil and del.accid_svr ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.accid_svr = del.accid_svr
    end
    if del ~= nil and del.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.accid = del.accid
    end
    if del ~= nil and del.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.charid = del.charid
    end
    if del ~= nil and del.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.anglez = del.anglez
    end
    if del ~= nil and del.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.time = del.time
    end
    if del ~= nil and del.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.mapid = del.mapid
    end
    if del ~= nil and del.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.sourceid = del.sourceid
    end
    if del ~= nil and del.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.source = del.source
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FramePhotoUpdatePhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if update ~= nil and update.accid_svr ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.accid_svr = update.accid_svr
    end
    if update ~= nil and update.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.accid = update.accid
    end
    if update ~= nil and update.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.charid = update.charid
    end
    if update ~= nil and update.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.anglez = update.anglez
    end
    if update ~= nil and update.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.time = update.time
    end
    if update ~= nil and update.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.mapid = update.mapid
    end
    if update ~= nil and update.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.sourceid = update.sourceid
    end
    if update ~= nil and update.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.source = update.source
    end
    if del ~= nil and del.accid_svr ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.accid_svr = del.accid_svr
    end
    if del ~= nil and del.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.accid = del.accid
    end
    if del ~= nil and del.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.charid = del.charid
    end
    if del ~= nil and del.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.anglez = del.anglez
    end
    if del ~= nil and del.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.time = del.time
    end
    if del ~= nil and del.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.mapid = del.mapid
    end
    if del ~= nil and del.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.sourceid = del.sourceid
    end
    if del ~= nil and del.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.source = del.source
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallQueryMd5ListPhotoCmd(item)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryMd5ListPhotoCmd()
    if item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      for i = 1, #item do
        table.insert(msg.item, item[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMd5ListPhotoCmd.id
    local msgParam = {}
    if item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      for i = 1, #item do
        table.insert(msgParam.item, item[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallAddMd5PhotoCmd(md5)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.AddMd5PhotoCmd()
    if md5 ~= nil and md5.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.md5 = md5.md5
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMd5PhotoCmd.id
    local msgParam = {}
    if md5 ~= nil and md5.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.md5 = md5.md5
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallRemoveMd5PhotoCmd(md5)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.RemoveMd5PhotoCmd()
    if md5 ~= nil and md5.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.md5 = md5.md5
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RemoveMd5PhotoCmd.id
    local msgParam = {}
    if md5 ~= nil and md5.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.md5 = md5.md5
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallQueryUrlPhotoCmd(urls)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryUrlPhotoCmd()
    if urls ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.urls == nil then
        msg.urls = {}
      end
      for i = 1, #urls do
        table.insert(msg.urls, urls[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUrlPhotoCmd.id
    local msgParam = {}
    if urls ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.urls == nil then
        msgParam.urls = {}
      end
      for i = 1, #urls do
        table.insert(msgParam.urls, urls[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallQueryUploadInfoPhotoCmd(type, id, customparam, path, params, useaws)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryUploadInfoPhotoCmd()
    if type ~= nil then
      msg.type = type
    end
    if id ~= nil then
      msg.id = id
    end
    if customparam ~= nil then
      msg.customparam = customparam
    end
    if path ~= nil then
      msg.path = path
    end
    if params ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.params == nil then
        msg.params = {}
      end
      for i = 1, #params do
        table.insert(msg.params, params[i])
      end
    end
    if useaws ~= nil then
      msg.useaws = useaws
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUploadInfoPhotoCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if id ~= nil then
      msgParam.id = id
    end
    if customparam ~= nil then
      msgParam.customparam = customparam
    end
    if path ~= nil then
      msgParam.path = path
    end
    if params ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.params == nil then
        msgParam.params = {}
      end
      for i = 1, #params do
        table.insert(msgParam.params, params[i])
      end
    end
    if useaws ~= nil then
      msgParam.useaws = useaws
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardBaseInfoPhotoCmd(uploadurl)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardBaseInfoPhotoCmd()
    if uploadurl ~= nil then
      msg.uploadurl = uploadurl
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardBaseInfoPhotoCmd.id
    local msgParam = {}
    if uploadurl ~= nil then
      msgParam.uploadurl = uploadurl
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardTopicPhotoCmd(topics)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardTopicPhotoCmd()
    if topics ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.topics == nil then
        msg.topics = {}
      end
      for i = 1, #topics do
        table.insert(msg.topics, topics[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardTopicPhotoCmd.id
    local msgParam = {}
    if topics ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.topics == nil then
        msgParam.topics = {}
      end
      for i = 1, #topics do
        table.insert(msgParam.topics, topics[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardRotateListPhotoCmd(page, npcid, starttime, lists, totalcount)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardRotateListPhotoCmd()
    if page ~= nil then
      msg.page = page
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if lists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lists == nil then
        msg.lists = {}
      end
      for i = 1, #lists do
        table.insert(msg.lists, lists[i])
      end
    end
    if totalcount ~= nil then
      msg.totalcount = totalcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardRotateListPhotoCmd.id
    local msgParam = {}
    if page ~= nil then
      msgParam.page = page
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if lists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lists == nil then
        msgParam.lists = {}
      end
      for i = 1, #lists do
        table.insert(msgParam.lists, lists[i])
      end
    end
    if totalcount ~= nil then
      msgParam.totalcount = totalcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardListPhotoCmd(topic, page, lists, totalcount)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardListPhotoCmd()
    if topic ~= nil then
      msg.topic = topic
    end
    if page ~= nil then
      msg.page = page
    end
    if lists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lists == nil then
        msg.lists = {}
      end
      for i = 1, #lists do
        table.insert(msg.lists, lists[i])
      end
    end
    if totalcount ~= nil then
      msg.totalcount = totalcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardListPhotoCmd.id
    local msgParam = {}
    if topic ~= nil then
      msgParam.topic = topic
    end
    if page ~= nil then
      msgParam.page = page
    end
    if lists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lists == nil then
        msgParam.lists = {}
      end
      for i = 1, #lists do
        table.insert(msgParam.lists, lists[i])
      end
    end
    if totalcount ~= nil then
      msgParam.totalcount = totalcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardMyListPhotoCmd(page, lists, totalcount)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardMyListPhotoCmd()
    if page ~= nil then
      msg.page = page
    end
    if lists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lists == nil then
        msg.lists = {}
      end
      for i = 1, #lists do
        table.insert(msg.lists, lists[i])
      end
    end
    if totalcount ~= nil then
      msg.totalcount = totalcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardMyListPhotoCmd.id
    local msgParam = {}
    if page ~= nil then
      msgParam.page = page
    end
    if lists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lists == nil then
        msgParam.lists = {}
      end
      for i = 1, #lists do
        table.insert(msgParam.lists, lists[i])
      end
    end
    if totalcount ~= nil then
      msgParam.totalcount = totalcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardQueryDetailPhotoCmd(data)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardQueryDetailPhotoCmd()
    if data.base ~= nil and data.base.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.id = data.base.id
    end
    if data.base ~= nil and data.base.accid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.accid = data.base.accid
    end
    if data ~= nil and data.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.serverid = data.serverid
    end
    if data ~= nil and data.topic ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.topic = data.topic
    end
    if data ~= nil and data.author ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.author = data.author
    end
    if data ~= nil and data.title ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.title = data.title
    end
    if data ~= nil and data.desc ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.desc = data.desc
    end
    if data ~= nil and data.expiretime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.expiretime = data.expiretime
    end
    if data ~= nil and data.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.charid = data.charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardQueryDetailPhotoCmd.id
    local msgParam = {}
    if data.base ~= nil and data.base.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.id = data.base.id
    end
    if data.base ~= nil and data.base.accid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.accid = data.base.accid
    end
    if data ~= nil and data.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.serverid = data.serverid
    end
    if data ~= nil and data.topic ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.topic = data.topic
    end
    if data ~= nil and data.author ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.author = data.author
    end
    if data ~= nil and data.title ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.title = data.title
    end
    if data ~= nil and data.desc ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.desc = data.desc
    end
    if data ~= nil and data.expiretime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.expiretime = data.expiretime
    end
    if data ~= nil and data.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.charid = data.charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardQueryDataPhotoCmd(board, data, newaward)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardQueryDataPhotoCmd()
    if board ~= nil and board.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.accid = board.accid
    end
    if data ~= nil and data.like ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.like = data.like
    end
    if data ~= nil and data.liked ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.liked = data.liked
    end
    if data ~= nil and data.lottery ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.lottery = data.lottery
    end
    if newaward ~= nil then
      msg.newaward = newaward
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardQueryDataPhotoCmd.id
    local msgParam = {}
    if board ~= nil and board.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.accid = board.accid
    end
    if data ~= nil and data.like ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.like = data.like
    end
    if data ~= nil and data.liked ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.liked = data.liked
    end
    if data ~= nil and data.lottery ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.lottery = data.lottery
    end
    if newaward ~= nil then
      msgParam.newaward = newaward
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardAwardListPhotoCmd(board, lists, totalzeny, unawardzeny, lastquerytime)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardAwardListPhotoCmd()
    if board ~= nil and board.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.accid = board.accid
    end
    if lists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lists == nil then
        msg.lists = {}
      end
      for i = 1, #lists do
        table.insert(msg.lists, lists[i])
      end
    end
    if totalzeny ~= nil then
      msg.totalzeny = totalzeny
    end
    if unawardzeny ~= nil then
      msg.unawardzeny = unawardzeny
    end
    if lastquerytime ~= nil then
      msg.lastquerytime = lastquerytime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardAwardListPhotoCmd.id
    local msgParam = {}
    if board ~= nil and board.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.accid = board.accid
    end
    if lists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lists == nil then
        msgParam.lists = {}
      end
      for i = 1, #lists do
        table.insert(msgParam.lists, lists[i])
      end
    end
    if totalzeny ~= nil then
      msgParam.totalzeny = totalzeny
    end
    if unawardzeny ~= nil then
      msgParam.unawardzeny = unawardzeny
    end
    if lastquerytime ~= nil then
      msgParam.lastquerytime = lastquerytime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardLikePhotoCmd(board, like)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardLikePhotoCmd()
    if board ~= nil and board.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.accid = board.accid
    end
    if like ~= nil then
      msg.like = like
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardLikePhotoCmd.id
    local msgParam = {}
    if board ~= nil and board.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.accid = board.accid
    end
    if like ~= nil then
      msgParam.like = like
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardAwardPhotoCmd(board, lotterycount)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardAwardPhotoCmd()
    if board ~= nil and board.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.accid = board.accid
    end
    if lotterycount ~= nil then
      msg.lotterycount = lotterycount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardAwardPhotoCmd.id
    local msgParam = {}
    if board ~= nil and board.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.accid = board.accid
    end
    if lotterycount ~= nil then
      msgParam.lotterycount = lotterycount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardGetAwardPhotoCmd(board)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardGetAwardPhotoCmd()
    if board ~= nil and board.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.board == nil then
        msg.board = {}
      end
      msg.board.accid = board.accid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardGetAwardPhotoCmd.id
    local msgParam = {}
    if board ~= nil and board.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.id = board.id
    end
    if board ~= nil and board.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.board == nil then
        msgParam.board = {}
      end
      msgParam.board.accid = board.accid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardOpenPhotoCmd(npcid)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardOpenPhotoCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardOpenPhotoCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallSendPostcardCmd(info, target)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.SendPostcardCmd()
    if info ~= nil and info.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.id = info.id
    end
    if info ~= nil and info.url ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.url = info.url
    end
    if info ~= nil and info.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.type = info.type
    end
    if info ~= nil and info.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.source = info.source
    end
    if info ~= nil and info.from_char ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.from_char = info.from_char
    end
    if info ~= nil and info.from_name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.from_name = info.from_name
    end
    if info ~= nil and info.paper_style ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.paper_style = info.paper_style
    end
    if info ~= nil and info.content ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.content = info.content
    end
    if info ~= nil and info.save_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.save_time = info.save_time
    end
    if info ~= nil and info.quest_postcard_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.quest_postcard_id = info.quest_postcard_id
    end
    if target ~= nil then
      msg.target = target
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SendPostcardCmd.id
    local msgParam = {}
    if info ~= nil and info.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.id = info.id
    end
    if info ~= nil and info.url ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.url = info.url
    end
    if info ~= nil and info.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.type = info.type
    end
    if info ~= nil and info.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.source = info.source
    end
    if info ~= nil and info.from_char ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.from_char = info.from_char
    end
    if info ~= nil and info.from_name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.from_name = info.from_name
    end
    if info ~= nil and info.paper_style ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.paper_style = info.paper_style
    end
    if info ~= nil and info.content ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.content = info.content
    end
    if info ~= nil and info.save_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.save_time = info.save_time
    end
    if info ~= nil and info.quest_postcard_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.quest_postcard_id = info.quest_postcard_id
    end
    if target ~= nil then
      msgParam.target = target
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallPostcardListCmd(postcards)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PostcardListCmd()
    if postcards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcards == nil then
        msg.postcards = {}
      end
      for i = 1, #postcards do
        table.insert(msg.postcards, postcards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PostcardListCmd.id
    local msgParam = {}
    if postcards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcards == nil then
        msgParam.postcards = {}
      end
      for i = 1, #postcards do
        table.insert(msgParam.postcards, postcards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallSavePostcardCmd(postcard)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.SavePostcardCmd()
    if postcard ~= nil and postcard.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.id = postcard.id
    end
    if postcard ~= nil and postcard.url ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.url = postcard.url
    end
    if postcard ~= nil and postcard.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.type = postcard.type
    end
    if postcard ~= nil and postcard.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.source = postcard.source
    end
    if postcard ~= nil and postcard.from_char ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.from_char = postcard.from_char
    end
    if postcard ~= nil and postcard.from_name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.from_name = postcard.from_name
    end
    if postcard ~= nil and postcard.paper_style ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.paper_style = postcard.paper_style
    end
    if postcard ~= nil and postcard.content ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.content = postcard.content
    end
    if postcard ~= nil and postcard.save_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.save_time = postcard.save_time
    end
    if postcard ~= nil and postcard.quest_postcard_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.quest_postcard_id = postcard.quest_postcard_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SavePostcardCmd.id
    local msgParam = {}
    if postcard ~= nil and postcard.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.id = postcard.id
    end
    if postcard ~= nil and postcard.url ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.url = postcard.url
    end
    if postcard ~= nil and postcard.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.type = postcard.type
    end
    if postcard ~= nil and postcard.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.source = postcard.source
    end
    if postcard ~= nil and postcard.from_char ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.from_char = postcard.from_char
    end
    if postcard ~= nil and postcard.from_name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.from_name = postcard.from_name
    end
    if postcard ~= nil and postcard.paper_style ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.paper_style = postcard.paper_style
    end
    if postcard ~= nil and postcard.content ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.content = postcard.content
    end
    if postcard ~= nil and postcard.save_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.save_time = postcard.save_time
    end
    if postcard ~= nil and postcard.quest_postcard_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.quest_postcard_id = postcard.quest_postcard_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallUpdatePostcardCmd(add, del, change)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.UpdatePostcardCmd()
    if add ~= nil and add.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.id = add.id
    end
    if add ~= nil and add.url ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.url = add.url
    end
    if add ~= nil and add.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.type = add.type
    end
    if add ~= nil and add.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.source = add.source
    end
    if add ~= nil and add.from_char ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.from_char = add.from_char
    end
    if add ~= nil and add.from_name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.from_name = add.from_name
    end
    if add ~= nil and add.paper_style ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.paper_style = add.paper_style
    end
    if add ~= nil and add.content ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.content = add.content
    end
    if add ~= nil and add.save_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.save_time = add.save_time
    end
    if add ~= nil and add.quest_postcard_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add == nil then
        msg.add = {}
      end
      msg.add.quest_postcard_id = add.quest_postcard_id
    end
    if del ~= nil then
      msg.del = del
    end
    if change ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.change == nil then
        msg.change = {}
      end
      for i = 1, #change do
        table.insert(msg.change, change[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdatePostcardCmd.id
    local msgParam = {}
    if add ~= nil and add.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.id = add.id
    end
    if add ~= nil and add.url ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.url = add.url
    end
    if add ~= nil and add.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.type = add.type
    end
    if add ~= nil and add.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.source = add.source
    end
    if add ~= nil and add.from_char ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.from_char = add.from_char
    end
    if add ~= nil and add.from_name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.from_name = add.from_name
    end
    if add ~= nil and add.paper_style ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.paper_style = add.paper_style
    end
    if add ~= nil and add.content ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.content = add.content
    end
    if add ~= nil and add.save_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.save_time = add.save_time
    end
    if add ~= nil and add.quest_postcard_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add == nil then
        msgParam.add = {}
      end
      msgParam.add.quest_postcard_id = add.quest_postcard_id
    end
    if del ~= nil then
      msgParam.del = del
    end
    if change ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.change == nil then
        msgParam.change = {}
      end
      for i = 1, #change do
        table.insert(msgParam.change, change[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallDelPostcardCmd(del)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.DelPostcardCmd()
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DelPostcardCmd.id
    local msgParam = {}
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallViewPostcardCmd()
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.ViewPostcardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ViewPostcardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:CallBoardQueryAwardPhotoCmd(award)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.BoardQueryAwardPhotoCmd()
    if award ~= nil then
      msg.award = award
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardQueryAwardPhotoCmd.id
    local msgParam = {}
    if award ~= nil then
      msgParam.award = award
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePhotoCmdAutoProxy:RecvPhotoQueryListCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoQueryListCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvPhotoOptCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoOptCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvPhotoUpdateNtf(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoUpdateNtf, data)
end

function ServicePhotoCmdAutoProxy:RecvFrameActionPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdFrameActionPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryFramePhotoListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryUserPhotoListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvUpdateFrameShowPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvFramePhotoUpdatePhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdFramePhotoUpdatePhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryMd5ListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvAddMd5PhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdAddMd5PhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvRemoveMd5PhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdRemoveMd5PhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryUrlPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUrlPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvQueryUploadInfoPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUploadInfoPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardBaseInfoPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardBaseInfoPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardTopicPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardTopicPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardRotateListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardRotateListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardMyListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardMyListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardQueryDetailPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardQueryDetailPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardQueryDataPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardQueryDataPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardAwardListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardAwardListPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardLikePhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardLikePhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardAwardPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardAwardPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardGetAwardPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardGetAwardPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardOpenPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardOpenPhotoCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvSendPostcardCmd(data)
  self:Notify(ServiceEvent.PhotoCmdSendPostcardCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvPostcardListCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPostcardListCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvSavePostcardCmd(data)
  self:Notify(ServiceEvent.PhotoCmdSavePostcardCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvUpdatePostcardCmd(data)
  self:Notify(ServiceEvent.PhotoCmdUpdatePostcardCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvDelPostcardCmd(data)
  self:Notify(ServiceEvent.PhotoCmdDelPostcardCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvViewPostcardCmd(data)
  self:Notify(ServiceEvent.PhotoCmdViewPostcardCmd, data)
end

function ServicePhotoCmdAutoProxy:RecvBoardQueryAwardPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdBoardQueryAwardPhotoCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.PhotoCmdPhotoQueryListCmd = "ServiceEvent_PhotoCmdPhotoQueryListCmd"
ServiceEvent.PhotoCmdPhotoOptCmd = "ServiceEvent_PhotoCmdPhotoOptCmd"
ServiceEvent.PhotoCmdPhotoUpdateNtf = "ServiceEvent_PhotoCmdPhotoUpdateNtf"
ServiceEvent.PhotoCmdFrameActionPhotoCmd = "ServiceEvent_PhotoCmdFrameActionPhotoCmd"
ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd = "ServiceEvent_PhotoCmdQueryFramePhotoListPhotoCmd"
ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd = "ServiceEvent_PhotoCmdQueryUserPhotoListPhotoCmd"
ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd = "ServiceEvent_PhotoCmdUpdateFrameShowPhotoCmd"
ServiceEvent.PhotoCmdFramePhotoUpdatePhotoCmd = "ServiceEvent_PhotoCmdFramePhotoUpdatePhotoCmd"
ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd = "ServiceEvent_PhotoCmdQueryMd5ListPhotoCmd"
ServiceEvent.PhotoCmdAddMd5PhotoCmd = "ServiceEvent_PhotoCmdAddMd5PhotoCmd"
ServiceEvent.PhotoCmdRemoveMd5PhotoCmd = "ServiceEvent_PhotoCmdRemoveMd5PhotoCmd"
ServiceEvent.PhotoCmdQueryUrlPhotoCmd = "ServiceEvent_PhotoCmdQueryUrlPhotoCmd"
ServiceEvent.PhotoCmdQueryUploadInfoPhotoCmd = "ServiceEvent_PhotoCmdQueryUploadInfoPhotoCmd"
ServiceEvent.PhotoCmdBoardBaseInfoPhotoCmd = "ServiceEvent_PhotoCmdBoardBaseInfoPhotoCmd"
ServiceEvent.PhotoCmdBoardTopicPhotoCmd = "ServiceEvent_PhotoCmdBoardTopicPhotoCmd"
ServiceEvent.PhotoCmdBoardRotateListPhotoCmd = "ServiceEvent_PhotoCmdBoardRotateListPhotoCmd"
ServiceEvent.PhotoCmdBoardListPhotoCmd = "ServiceEvent_PhotoCmdBoardListPhotoCmd"
ServiceEvent.PhotoCmdBoardMyListPhotoCmd = "ServiceEvent_PhotoCmdBoardMyListPhotoCmd"
ServiceEvent.PhotoCmdBoardQueryDetailPhotoCmd = "ServiceEvent_PhotoCmdBoardQueryDetailPhotoCmd"
ServiceEvent.PhotoCmdBoardQueryDataPhotoCmd = "ServiceEvent_PhotoCmdBoardQueryDataPhotoCmd"
ServiceEvent.PhotoCmdBoardAwardListPhotoCmd = "ServiceEvent_PhotoCmdBoardAwardListPhotoCmd"
ServiceEvent.PhotoCmdBoardLikePhotoCmd = "ServiceEvent_PhotoCmdBoardLikePhotoCmd"
ServiceEvent.PhotoCmdBoardAwardPhotoCmd = "ServiceEvent_PhotoCmdBoardAwardPhotoCmd"
ServiceEvent.PhotoCmdBoardGetAwardPhotoCmd = "ServiceEvent_PhotoCmdBoardGetAwardPhotoCmd"
ServiceEvent.PhotoCmdBoardOpenPhotoCmd = "ServiceEvent_PhotoCmdBoardOpenPhotoCmd"
ServiceEvent.PhotoCmdSendPostcardCmd = "ServiceEvent_PhotoCmdSendPostcardCmd"
ServiceEvent.PhotoCmdPostcardListCmd = "ServiceEvent_PhotoCmdPostcardListCmd"
ServiceEvent.PhotoCmdSavePostcardCmd = "ServiceEvent_PhotoCmdSavePostcardCmd"
ServiceEvent.PhotoCmdUpdatePostcardCmd = "ServiceEvent_PhotoCmdUpdatePostcardCmd"
ServiceEvent.PhotoCmdDelPostcardCmd = "ServiceEvent_PhotoCmdDelPostcardCmd"
ServiceEvent.PhotoCmdViewPostcardCmd = "ServiceEvent_PhotoCmdViewPostcardCmd"
ServiceEvent.PhotoCmdBoardQueryAwardPhotoCmd = "ServiceEvent_PhotoCmdBoardQueryAwardPhotoCmd"
