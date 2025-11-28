ServiceSceneAuguryAutoProxy = class("ServiceSceneAuguryAutoProxy", ServiceProxy)
ServiceSceneAuguryAutoProxy.Instance = nil
ServiceSceneAuguryAutoProxy.NAME = "ServiceSceneAuguryAutoProxy"

function ServiceSceneAuguryAutoProxy:ctor(proxyName)
  if ServiceSceneAuguryAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneAuguryAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneAuguryAutoProxy.Instance = self
  end
end

function ServiceSceneAuguryAutoProxy:Init()
end

function ServiceSceneAuguryAutoProxy:onRegister()
  self:Listen(27, 1, function(data)
    self:RecvAuguryInvite(data)
  end)
  self:Listen(27, 2, function(data)
    self:RecvAuguryInviteReply(data)
  end)
  self:Listen(27, 3, function(data)
    self:RecvAuguryChat(data)
  end)
  self:Listen(27, 4, function(data)
    self:RecvAuguryTitle(data)
  end)
  self:Listen(27, 5, function(data)
    self:RecvAuguryAnswer(data)
  end)
  self:Listen(27, 6, function(data)
    self:RecvAuguryQuit(data)
  end)
  self:Listen(27, 7, function(data)
    self:RecvAuguryAstrologyDrawCard(data)
  end)
  self:Listen(27, 8, function(data)
    self:RecvAuguryAstrologyInfo(data)
  end)
end

function ServiceSceneAuguryAutoProxy:CallAuguryInvite(inviterid, invitername, npcguid, type, isextra)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryInvite()
    if inviterid ~= nil then
      msg.inviterid = inviterid
    end
    if invitername ~= nil then
      msg.invitername = invitername
    end
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if type ~= nil then
      msg.type = type
    end
    if isextra ~= nil then
      msg.isextra = isextra
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryInvite.id
    local msgParam = {}
    if inviterid ~= nil then
      msgParam.inviterid = inviterid
    end
    if invitername ~= nil then
      msgParam.invitername = invitername
    end
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if isextra ~= nil then
      msgParam.isextra = isextra
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryInviteReply(type, inviterid, npcguid, augurytype, isextra)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryInviteReply()
    if type ~= nil then
      msg.type = type
    end
    if inviterid ~= nil then
      msg.inviterid = inviterid
    end
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if augurytype ~= nil then
      msg.augurytype = augurytype
    end
    if isextra ~= nil then
      msg.isextra = isextra
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryInviteReply.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if inviterid ~= nil then
      msgParam.inviterid = inviterid
    end
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if augurytype ~= nil then
      msgParam.augurytype = augurytype
    end
    if isextra ~= nil then
      msgParam.isextra = isextra
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryChat(content, sender)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryChat()
    if content ~= nil then
      msg.content = content
    end
    if sender ~= nil then
      msg.sender = sender
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryChat.id
    local msgParam = {}
    if content ~= nil then
      msgParam.content = content
    end
    if sender ~= nil then
      msgParam.sender = sender
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryTitle(titleid, type, subtableid)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryTitle()
    if titleid ~= nil then
      msg.titleid = titleid
    end
    if type ~= nil then
      msg.type = type
    end
    if subtableid ~= nil then
      msg.subtableid = subtableid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryTitle.id
    local msgParam = {}
    if titleid ~= nil then
      msgParam.titleid = titleid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if subtableid ~= nil then
      msgParam.subtableid = subtableid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryAnswer(titleid, answer, answerid)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryAnswer()
    if titleid ~= nil then
      msg.titleid = titleid
    end
    if answer ~= nil then
      msg.answer = answer
    end
    if answerid ~= nil then
      msg.answerid = answerid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryAnswer.id
    local msgParam = {}
    if titleid ~= nil then
      msgParam.titleid = titleid
    end
    if answer ~= nil then
      msgParam.answer = answer
    end
    if answerid ~= nil then
      msgParam.answerid = answerid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryQuit()
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryQuit()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryQuit.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryAstrologyDrawCard(type, group)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryAstrologyDrawCard()
    if type ~= nil then
      msg.type = type
    end
    if group ~= nil then
      msg.group = group
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryAstrologyDrawCard.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if group ~= nil then
      msgParam.group = group
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:CallAuguryAstrologyInfo(id, buffid)
  if not NetConfig.PBC then
    local msg = SceneAugury_pb.AuguryAstrologyInfo()
    if id ~= nil then
      msg.id = id
    end
    if buffid ~= nil then
      msg.buffid = buffid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuguryAstrologyInfo.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if buffid ~= nil then
      msgParam.buffid = buffid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneAuguryAutoProxy:RecvAuguryInvite(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryInvite, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryInviteReply(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryInviteReply, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryChat(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryChat, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryTitle(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryTitle, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryAnswer(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryAnswer, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryQuit(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryQuit, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryAstrologyDrawCard(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryAstrologyDrawCard, data)
end

function ServiceSceneAuguryAutoProxy:RecvAuguryAstrologyInfo(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryAstrologyInfo, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneAuguryAuguryInvite = "ServiceEvent_SceneAuguryAuguryInvite"
ServiceEvent.SceneAuguryAuguryInviteReply = "ServiceEvent_SceneAuguryAuguryInviteReply"
ServiceEvent.SceneAuguryAuguryChat = "ServiceEvent_SceneAuguryAuguryChat"
ServiceEvent.SceneAuguryAuguryTitle = "ServiceEvent_SceneAuguryAuguryTitle"
ServiceEvent.SceneAuguryAuguryAnswer = "ServiceEvent_SceneAuguryAuguryAnswer"
ServiceEvent.SceneAuguryAuguryQuit = "ServiceEvent_SceneAuguryAuguryQuit"
ServiceEvent.SceneAuguryAuguryAstrologyDrawCard = "ServiceEvent_SceneAuguryAuguryAstrologyDrawCard"
ServiceEvent.SceneAuguryAuguryAstrologyInfo = "ServiceEvent_SceneAuguryAuguryAstrologyInfo"
