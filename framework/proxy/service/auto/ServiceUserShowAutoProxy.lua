ServiceUserShowAutoProxy = class("ServiceUserShowAutoProxy", ServiceProxy)
ServiceUserShowAutoProxy.Instance = nil
ServiceUserShowAutoProxy.NAME = "ServiceUserShowAutoProxy"

function ServiceUserShowAutoProxy:ctor(proxyName)
  if ServiceUserShowAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserShowAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserShowAutoProxy.Instance = self
  end
end

function ServiceUserShowAutoProxy:Init()
end

function ServiceUserShowAutoProxy:onRegister()
  self:Listen(225, 1, function(data)
    self:RecvUnlockPhotoFrame(data)
  end)
  self:Listen(225, 2, function(data)
    self:RecvSyncAllPhotoFrame(data)
  end)
  self:Listen(225, 5, function(data)
    self:RecvSelectPhotoFrame(data)
  end)
  self:Listen(225, 3, function(data)
    self:RecvUnlockBackgroundFrame(data)
  end)
  self:Listen(225, 4, function(data)
    self:RecvSyncAllBackgroundFrame(data)
  end)
  self:Listen(225, 6, function(data)
    self:RecvSelectBackgroundFrame(data)
  end)
  self:Listen(225, 7, function(data)
    self:RecvSyncUnlockChatFrame(data)
  end)
  self:Listen(225, 8, function(data)
    self:RecvSelectChatFrame(data)
  end)
end

function ServiceUserShowAutoProxy:CallUnlockPhotoFrame(id, del)
  if not NetConfig.PBC then
    local msg = UserShow_pb.UnlockPhotoFrame()
    if id ~= nil then
      msg.id = id
    end
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockPhotoFrame.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallSyncAllPhotoFrame(ids)
  if not NetConfig.PBC then
    local msg = UserShow_pb.SyncAllPhotoFrame()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncAllPhotoFrame.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallSelectPhotoFrame(id)
  if not NetConfig.PBC then
    local msg = UserShow_pb.SelectPhotoFrame()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectPhotoFrame.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallUnlockBackgroundFrame(id, del)
  if not NetConfig.PBC then
    local msg = UserShow_pb.UnlockBackgroundFrame()
    if id ~= nil then
      msg.id = id
    end
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockBackgroundFrame.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallSyncAllBackgroundFrame(ids)
  if not NetConfig.PBC then
    local msg = UserShow_pb.SyncAllBackgroundFrame()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncAllBackgroundFrame.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallSelectBackgroundFrame(id)
  if not NetConfig.PBC then
    local msg = UserShow_pb.SelectBackgroundFrame()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectBackgroundFrame.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallSyncUnlockChatFrame(ids)
  if not NetConfig.PBC then
    local msg = UserShow_pb.SyncUnlockChatFrame()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncUnlockChatFrame.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:CallSelectChatFrame(id)
  if not NetConfig.PBC then
    local msg = UserShow_pb.SelectChatFrame()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectChatFrame.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserShowAutoProxy:RecvUnlockPhotoFrame(data)
  self:Notify(ServiceEvent.UserShowUnlockPhotoFrame, data)
end

function ServiceUserShowAutoProxy:RecvSyncAllPhotoFrame(data)
  self:Notify(ServiceEvent.UserShowSyncAllPhotoFrame, data)
end

function ServiceUserShowAutoProxy:RecvSelectPhotoFrame(data)
  self:Notify(ServiceEvent.UserShowSelectPhotoFrame, data)
end

function ServiceUserShowAutoProxy:RecvUnlockBackgroundFrame(data)
  self:Notify(ServiceEvent.UserShowUnlockBackgroundFrame, data)
end

function ServiceUserShowAutoProxy:RecvSyncAllBackgroundFrame(data)
  self:Notify(ServiceEvent.UserShowSyncAllBackgroundFrame, data)
end

function ServiceUserShowAutoProxy:RecvSelectBackgroundFrame(data)
  self:Notify(ServiceEvent.UserShowSelectBackgroundFrame, data)
end

function ServiceUserShowAutoProxy:RecvSyncUnlockChatFrame(data)
  self:Notify(ServiceEvent.UserShowSyncUnlockChatFrame, data)
end

function ServiceUserShowAutoProxy:RecvSelectChatFrame(data)
  self:Notify(ServiceEvent.UserShowSelectChatFrame, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.UserShowUnlockPhotoFrame = "ServiceEvent_UserShowUnlockPhotoFrame"
ServiceEvent.UserShowSyncAllPhotoFrame = "ServiceEvent_UserShowSyncAllPhotoFrame"
ServiceEvent.UserShowSelectPhotoFrame = "ServiceEvent_UserShowSelectPhotoFrame"
ServiceEvent.UserShowUnlockBackgroundFrame = "ServiceEvent_UserShowUnlockBackgroundFrame"
ServiceEvent.UserShowSyncAllBackgroundFrame = "ServiceEvent_UserShowSyncAllBackgroundFrame"
ServiceEvent.UserShowSelectBackgroundFrame = "ServiceEvent_UserShowSelectBackgroundFrame"
ServiceEvent.UserShowSyncUnlockChatFrame = "ServiceEvent_UserShowSyncUnlockChatFrame"
ServiceEvent.UserShowSelectChatFrame = "ServiceEvent_UserShowSelectChatFrame"
