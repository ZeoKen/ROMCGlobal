ServiceDojoAutoProxy = class("ServiceDojoAutoProxy", ServiceProxy)
ServiceDojoAutoProxy.Instance = nil
ServiceDojoAutoProxy.NAME = "ServiceDojoAutoProxy"

function ServiceDojoAutoProxy:ctor(proxyName)
  if ServiceDojoAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceDojoAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceDojoAutoProxy.Instance = self
  end
end

function ServiceDojoAutoProxy:Init()
end

function ServiceDojoAutoProxy:onRegister()
  self:Listen(58, 1, function(data)
    self:RecvDojoPrivateInfoCmd(data)
  end)
  self:Listen(58, 2, function(data)
    self:RecvDojoPublicInfoCmd(data)
  end)
  self:Listen(58, 3, function(data)
    self:RecvDojoInviteCmd(data)
  end)
  self:Listen(58, 4, function(data)
    self:RecvDojoReplyCmd(data)
  end)
  self:Listen(58, 5, function(data)
    self:RecvEnterDojo(data)
  end)
  self:Listen(58, 6, function(data)
    self:RecvDojoAddMsg(data)
  end)
  self:Listen(58, 7, function(data)
    self:RecvDojoPanelOper(data)
  end)
  self:Listen(58, 9, function(data)
    self:RecvDojoSponsorCmd(data)
  end)
  self:Listen(58, 10, function(data)
    self:RecvDojoQueryStateCmd(data)
  end)
  self:Listen(58, 11, function(data)
    self:RecvDojoRewardCmd(data)
  end)
end

function ServiceDojoAutoProxy:CallDojoPrivateInfoCmd(groupid, completed_id)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoPrivateInfoCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if completed_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.completed_id == nil then
        msg.completed_id = {}
      end
      for i = 1, #completed_id do
        table.insert(msg.completed_id, completed_id[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoPrivateInfoCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if completed_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.completed_id == nil then
        msgParam.completed_id = {}
      end
      for i = 1, #completed_id do
        table.insert(msgParam.completed_id, completed_id[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoPublicInfoCmd(dojoid, msgblob)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoPublicInfoCmd()
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if msgblob ~= nil and msgblob.msgs ~= nil then
      if msg.msgblob == nil then
        msg.msgblob = {}
      end
      if msg.msgblob.msgs == nil then
        msg.msgblob.msgs = {}
      end
      for i = 1, #msgblob.msgs do
        table.insert(msg.msgblob.msgs, msgblob.msgs[i])
      end
    end
    if msgblob ~= nil and msgblob.dojoid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.msgblob == nil then
        msg.msgblob = {}
      end
      msg.msgblob.dojoid = msgblob.dojoid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoPublicInfoCmd.id
    local msgParam = {}
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if msgblob ~= nil and msgblob.msgs ~= nil then
      if msgParam.msgblob == nil then
        msgParam.msgblob = {}
      end
      if msgParam.msgblob.msgs == nil then
        msgParam.msgblob.msgs = {}
      end
      for i = 1, #msgblob.msgs do
        table.insert(msgParam.msgblob.msgs, msgblob.msgs[i])
      end
    end
    if msgblob ~= nil and msgblob.dojoid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.msgblob == nil then
        msgParam.msgblob = {}
      end
      msgParam.msgblob.dojoid = msgblob.dojoid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoInviteCmd(dojoid, sponsorid, sponsorname)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoInviteCmd()
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if sponsorid ~= nil then
      msg.sponsorid = sponsorid
    end
    if sponsorname ~= nil then
      msg.sponsorname = sponsorname
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoInviteCmd.id
    local msgParam = {}
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if sponsorid ~= nil then
      msgParam.sponsorid = sponsorid
    end
    if sponsorname ~= nil then
      msgParam.sponsorname = sponsorname
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoReplyCmd(eReply, userid)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoReplyCmd()
    if eReply ~= nil then
      msg.eReply = eReply
    end
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoReplyCmd.id
    local msgParam = {}
    if eReply ~= nil then
      msgParam.eReply = eReply
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallEnterDojo(dojoid, userid, zoneid, time, sign)
  if not NetConfig.PBC then
    local msg = Dojo_pb.EnterDojo()
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterDojo.id
    local msgParam = {}
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoAddMsg(dojoid, dojomsg)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoAddMsg()
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if dojomsg ~= nil and dojomsg.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dojomsg == nil then
        msg.dojomsg = {}
      end
      msg.dojomsg.charid = dojomsg.charid
    end
    if dojomsg ~= nil and dojomsg.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dojomsg == nil then
        msg.dojomsg = {}
      end
      msg.dojomsg.name = dojomsg.name
    end
    if dojomsg ~= nil and dojomsg.conent ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dojomsg == nil then
        msg.dojomsg = {}
      end
      msg.dojomsg.conent = dojomsg.conent
    end
    if dojomsg ~= nil and dojomsg.iscompleted ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dojomsg == nil then
        msg.dojomsg = {}
      end
      msg.dojomsg.iscompleted = dojomsg.iscompleted
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoAddMsg.id
    local msgParam = {}
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if dojomsg ~= nil and dojomsg.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dojomsg == nil then
        msgParam.dojomsg = {}
      end
      msgParam.dojomsg.charid = dojomsg.charid
    end
    if dojomsg ~= nil and dojomsg.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dojomsg == nil then
        msgParam.dojomsg = {}
      end
      msgParam.dojomsg.name = dojomsg.name
    end
    if dojomsg ~= nil and dojomsg.conent ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dojomsg == nil then
        msgParam.dojomsg = {}
      end
      msgParam.dojomsg.conent = dojomsg.conent
    end
    if dojomsg ~= nil and dojomsg.iscompleted ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dojomsg == nil then
        msgParam.dojomsg = {}
      end
      msgParam.dojomsg.iscompleted = dojomsg.iscompleted
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoPanelOper()
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoPanelOper()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoPanelOper.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoSponsorCmd(dojoid, is_cancel, sponsorid, sponsorname, ret)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoSponsorCmd()
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if is_cancel ~= nil then
      msg.is_cancel = is_cancel
    end
    if sponsorid ~= nil then
      msg.sponsorid = sponsorid
    end
    if sponsorname ~= nil then
      msg.sponsorname = sponsorname
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoSponsorCmd.id
    local msgParam = {}
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if is_cancel ~= nil then
      msgParam.is_cancel = is_cancel
    end
    if sponsorid ~= nil then
      msgParam.sponsorid = sponsorid
    end
    if sponsorname ~= nil then
      msgParam.sponsorname = sponsorname
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoQueryStateCmd(state, dojoid, sponsorid, sponsorname, ret)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoQueryStateCmd()
    if state ~= nil then
      msg.state = state
    end
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if sponsorid ~= nil then
      msg.sponsorid = sponsorid
    end
    if sponsorname ~= nil then
      msg.sponsorname = sponsorname
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoQueryStateCmd.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if sponsorid ~= nil then
      msgParam.sponsorid = sponsorid
    end
    if sponsorname ~= nil then
      msgParam.sponsorname = sponsorname
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:CallDojoRewardCmd(dojoid, passtype, items)
  if not NetConfig.PBC then
    local msg = Dojo_pb.DojoRewardCmd()
    if dojoid ~= nil then
      msg.dojoid = dojoid
    end
    if passtype ~= nil then
      msg.passtype = passtype
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DojoRewardCmd.id
    local msgParam = {}
    if dojoid ~= nil then
      msgParam.dojoid = dojoid
    end
    if passtype ~= nil then
      msgParam.passtype = passtype
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceDojoAutoProxy:RecvDojoPrivateInfoCmd(data)
  self:Notify(ServiceEvent.DojoDojoPrivateInfoCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoPublicInfoCmd(data)
  self:Notify(ServiceEvent.DojoDojoPublicInfoCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoInviteCmd(data)
  self:Notify(ServiceEvent.DojoDojoInviteCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoReplyCmd(data)
  self:Notify(ServiceEvent.DojoDojoReplyCmd, data)
end

function ServiceDojoAutoProxy:RecvEnterDojo(data)
  self:Notify(ServiceEvent.DojoEnterDojo, data)
end

function ServiceDojoAutoProxy:RecvDojoAddMsg(data)
  self:Notify(ServiceEvent.DojoDojoAddMsg, data)
end

function ServiceDojoAutoProxy:RecvDojoPanelOper(data)
  self:Notify(ServiceEvent.DojoDojoPanelOper, data)
end

function ServiceDojoAutoProxy:RecvDojoSponsorCmd(data)
  self:Notify(ServiceEvent.DojoDojoSponsorCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoQueryStateCmd(data)
  self:Notify(ServiceEvent.DojoDojoQueryStateCmd, data)
end

function ServiceDojoAutoProxy:RecvDojoRewardCmd(data)
  self:Notify(ServiceEvent.DojoDojoRewardCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.DojoDojoPrivateInfoCmd = "ServiceEvent_DojoDojoPrivateInfoCmd"
ServiceEvent.DojoDojoPublicInfoCmd = "ServiceEvent_DojoDojoPublicInfoCmd"
ServiceEvent.DojoDojoInviteCmd = "ServiceEvent_DojoDojoInviteCmd"
ServiceEvent.DojoDojoReplyCmd = "ServiceEvent_DojoDojoReplyCmd"
ServiceEvent.DojoEnterDojo = "ServiceEvent_DojoEnterDojo"
ServiceEvent.DojoDojoAddMsg = "ServiceEvent_DojoDojoAddMsg"
ServiceEvent.DojoDojoPanelOper = "ServiceEvent_DojoDojoPanelOper"
ServiceEvent.DojoDojoSponsorCmd = "ServiceEvent_DojoDojoSponsorCmd"
ServiceEvent.DojoDojoQueryStateCmd = "ServiceEvent_DojoDojoQueryStateCmd"
ServiceEvent.DojoDojoRewardCmd = "ServiceEvent_DojoDojoRewardCmd"
