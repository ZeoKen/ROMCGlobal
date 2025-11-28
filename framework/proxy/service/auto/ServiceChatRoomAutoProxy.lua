ServiceChatRoomAutoProxy = class("ServiceChatRoomAutoProxy", ServiceProxy)
ServiceChatRoomAutoProxy.Instance = nil
ServiceChatRoomAutoProxy.NAME = "ServiceChatRoomAutoProxy"

function ServiceChatRoomAutoProxy:ctor(proxyName)
  if ServiceChatRoomAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceChatRoomAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceChatRoomAutoProxy.Instance = self
  end
end

function ServiceChatRoomAutoProxy:Init()
end

function ServiceChatRoomAutoProxy:onRegister()
  self:Listen(19, 1, function(data)
    self:RecvCreateChatRoom(data)
  end)
  self:Listen(19, 2, function(data)
    self:RecvJoinChatRoom(data)
  end)
  self:Listen(19, 3, function(data)
    self:RecvExitChatRoom(data)
  end)
  self:Listen(19, 4, function(data)
    self:RecvKickChatMember(data)
  end)
  self:Listen(19, 5, function(data)
    self:RecvExchangeRoomOwner(data)
  end)
  self:Listen(19, 7, function(data)
    self:RecvRoomMemberUpdate(data)
  end)
  self:Listen(19, 6, function(data)
    self:RecvEnterChatRoom(data)
  end)
  self:Listen(19, 8, function(data)
    self:RecvChatRoomDataSync(data)
  end)
  self:Listen(19, 9, function(data)
    self:RecvChatRoomTip(data)
  end)
end

function ServiceChatRoomAutoProxy:CallCreateChatRoom(roomname, maxnum, pswd)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.CreateChatRoom()
    if roomname ~= nil then
      msg.roomname = roomname
    end
    if maxnum ~= nil then
      msg.maxnum = maxnum
    end
    if pswd ~= nil then
      msg.pswd = pswd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CreateChatRoom.id
    local msgParam = {}
    if roomname ~= nil then
      msgParam.roomname = roomname
    end
    if maxnum ~= nil then
      msgParam.maxnum = maxnum
    end
    if pswd ~= nil then
      msgParam.pswd = pswd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallJoinChatRoom(roomid, pswd)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.JoinChatRoom()
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if pswd ~= nil then
      msg.pswd = pswd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinChatRoom.id
    local msgParam = {}
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if pswd ~= nil then
      msgParam.pswd = pswd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallExitChatRoom(roomid, userid)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.ExitChatRoom()
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitChatRoom.id
    local msgParam = {}
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallKickChatMember(roomid, memberid)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.KickChatMember()
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if memberid ~= nil then
      msg.memberid = memberid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickChatMember.id
    local msgParam = {}
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if memberid ~= nil then
      msgParam.memberid = memberid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallExchangeRoomOwner(userid)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.ExchangeRoomOwner()
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeRoomOwner.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallRoomMemberUpdate(updates, deletes)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.RoomMemberUpdate()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deletes == nil then
        msg.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msg.deletes, deletes[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoomMemberUpdate.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if deletes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deletes == nil then
        msgParam.deletes = {}
      end
      for i = 1, #deletes do
        table.insert(msgParam.deletes, deletes[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallEnterChatRoom(data)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.EnterChatRoom()
    if data ~= nil and data.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomid = data.roomid
    end
    if data ~= nil and data.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.name = data.name
    end
    if data ~= nil and data.pswd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.pswd = data.pswd
    end
    if data ~= nil and data.ownerid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.ownerid = data.ownerid
    end
    if data ~= nil and data.maxnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.maxnum = data.maxnum
    end
    if data ~= nil and data.roomtype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomtype = data.roomtype
    end
    if data ~= nil and data.members ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.members == nil then
        msg.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msg.data.members, data.members[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterChatRoom.id
    local msgParam = {}
    if data ~= nil and data.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomid = data.roomid
    end
    if data ~= nil and data.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.name = data.name
    end
    if data ~= nil and data.pswd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.pswd = data.pswd
    end
    if data ~= nil and data.ownerid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.ownerid = data.ownerid
    end
    if data ~= nil and data.maxnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.maxnum = data.maxnum
    end
    if data ~= nil and data.roomtype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomtype = data.roomtype
    end
    if data ~= nil and data.members ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.members == nil then
        msgParam.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msgParam.data.members, data.members[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallChatRoomDataSync(esync, data)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.ChatRoomDataSync()
    if esync ~= nil then
      msg.esync = esync
    end
    if data ~= nil and data.ownerid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.ownerid = data.ownerid
    end
    if data ~= nil and data.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomid = data.roomid
    end
    if data ~= nil and data.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.name = data.name
    end
    if data ~= nil and data.roomtype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomtype = data.roomtype
    end
    if data ~= nil and data.maxnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.maxnum = data.maxnum
    end
    if data ~= nil and data.curnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.curnum = data.curnum
    end
    if data ~= nil and data.pswd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.pswd = data.pswd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChatRoomDataSync.id
    local msgParam = {}
    if esync ~= nil then
      msgParam.esync = esync
    end
    if data ~= nil and data.ownerid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.ownerid = data.ownerid
    end
    if data ~= nil and data.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomid = data.roomid
    end
    if data ~= nil and data.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.name = data.name
    end
    if data ~= nil and data.roomtype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomtype = data.roomtype
    end
    if data ~= nil and data.maxnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.maxnum = data.maxnum
    end
    if data ~= nil and data.curnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.curnum = data.curnum
    end
    if data ~= nil and data.pswd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.pswd = data.pswd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:CallChatRoomTip(tip, userid, name)
  if not NetConfig.PBC then
    local msg = SceneChatRoom_pb.ChatRoomTip()
    if tip ~= nil then
      msg.tip = tip
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChatRoomTip.id
    local msgParam = {}
    if tip ~= nil then
      msgParam.tip = tip
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatRoomAutoProxy:RecvCreateChatRoom(data)
  self:Notify(ServiceEvent.ChatRoomCreateChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvJoinChatRoom(data)
  self:Notify(ServiceEvent.ChatRoomJoinChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvExitChatRoom(data)
  self:Notify(ServiceEvent.ChatRoomExitChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvKickChatMember(data)
  self:Notify(ServiceEvent.ChatRoomKickChatMember, data)
end

function ServiceChatRoomAutoProxy:RecvExchangeRoomOwner(data)
  self:Notify(ServiceEvent.ChatRoomExchangeRoomOwner, data)
end

function ServiceChatRoomAutoProxy:RecvRoomMemberUpdate(data)
  self:Notify(ServiceEvent.ChatRoomRoomMemberUpdate, data)
end

function ServiceChatRoomAutoProxy:RecvEnterChatRoom(data)
  self:Notify(ServiceEvent.ChatRoomEnterChatRoom, data)
end

function ServiceChatRoomAutoProxy:RecvChatRoomDataSync(data)
  self:Notify(ServiceEvent.ChatRoomChatRoomDataSync, data)
end

function ServiceChatRoomAutoProxy:RecvChatRoomTip(data)
  self:Notify(ServiceEvent.ChatRoomChatRoomTip, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ChatRoomCreateChatRoom = "ServiceEvent_ChatRoomCreateChatRoom"
ServiceEvent.ChatRoomJoinChatRoom = "ServiceEvent_ChatRoomJoinChatRoom"
ServiceEvent.ChatRoomExitChatRoom = "ServiceEvent_ChatRoomExitChatRoom"
ServiceEvent.ChatRoomKickChatMember = "ServiceEvent_ChatRoomKickChatMember"
ServiceEvent.ChatRoomExchangeRoomOwner = "ServiceEvent_ChatRoomExchangeRoomOwner"
ServiceEvent.ChatRoomRoomMemberUpdate = "ServiceEvent_ChatRoomRoomMemberUpdate"
ServiceEvent.ChatRoomEnterChatRoom = "ServiceEvent_ChatRoomEnterChatRoom"
ServiceEvent.ChatRoomChatRoomDataSync = "ServiceEvent_ChatRoomChatRoomDataSync"
ServiceEvent.ChatRoomChatRoomTip = "ServiceEvent_ChatRoomChatRoomTip"
