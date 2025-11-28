ServiceCarrierCmdAutoProxy = class("ServiceCarrierCmdAutoProxy", ServiceProxy)
ServiceCarrierCmdAutoProxy.Instance = nil
ServiceCarrierCmdAutoProxy.NAME = "ServiceCarrierCmdAutoProxy"

function ServiceCarrierCmdAutoProxy:ctor(proxyName)
  if ServiceCarrierCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceCarrierCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceCarrierCmdAutoProxy.Instance = self
  end
end

function ServiceCarrierCmdAutoProxy:Init()
end

function ServiceCarrierCmdAutoProxy:onRegister()
  self:Listen(16, 1, function(data)
    self:RecvCarrierInfoUserCmd(data)
  end)
  self:Listen(16, 6, function(data)
    self:RecvCreateCarrierUserCmd(data)
  end)
  self:Listen(16, 10, function(data)
    self:RecvInviteCarrierUserCmd(data)
  end)
  self:Listen(16, 2, function(data)
    self:RecvJoinCarrierUserCmd(data)
  end)
  self:Listen(16, 3, function(data)
    self:RecvRetJoinCarrierUserCmd(data)
  end)
  self:Listen(16, 4, function(data)
    self:RecvLeaveCarrierUserCmd(data)
  end)
  self:Listen(16, 9, function(data)
    self:RecvReachCarrierUserCmd(data)
  end)
  self:Listen(16, 5, function(data)
    self:RecvCarrierMoveUserCmd(data)
  end)
  self:Listen(16, 7, function(data)
    self:RecvCarrierStartUserCmd(data)
  end)
  self:Listen(16, 8, function(data)
    self:RecvCarrierWaitListUserCmd(data)
  end)
  self:Listen(16, 11, function(data)
    self:RecvChangeCarrierUserCmd(data)
  end)
  self:Listen(16, 12, function(data)
    self:RecvFerrisWheelInviteCarrierCmd(data)
  end)
  self:Listen(16, 13, function(data)
    self:RecvFerrisWheelProcessInviteCarrierCmd(data)
  end)
  self:Listen(16, 14, function(data)
    self:RecvStartFerrisWheelUserCmd(data)
  end)
  self:Listen(16, 15, function(data)
    self:RecvCatchUserJoinCarrierUserCmd(data)
  end)
end

function ServiceCarrierCmdAutoProxy:CallCarrierInfoUserCmd(carrierid, masterid, members, needanimation)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.CarrierInfoUserCmd()
    if carrierid ~= nil then
      msg.carrierid = carrierid
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if members ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.members == nil then
        msg.members = {}
      end
      for i = 1, #members do
        table.insert(msg.members, members[i])
      end
    end
    if needanimation ~= nil then
      msg.needanimation = needanimation
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CarrierInfoUserCmd.id
    local msgParam = {}
    if carrierid ~= nil then
      msgParam.carrierid = carrierid
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if members ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.members == nil then
        msgParam.members = {}
      end
      for i = 1, #members do
        table.insert(msgParam.members, members[i])
      end
    end
    if needanimation ~= nil then
      msgParam.needanimation = needanimation
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallCreateCarrierUserCmd(carrierid, line)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.CreateCarrierUserCmd()
    if carrierid ~= nil then
      msg.carrierid = carrierid
    end
    if line ~= nil then
      msg.line = line
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CreateCarrierUserCmd.id
    local msgParam = {}
    if carrierid ~= nil then
      msgParam.carrierid = carrierid
    end
    if line ~= nil then
      msgParam.line = line
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallInviteCarrierUserCmd(masterid, mastername, carrierid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.InviteCarrierUserCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if mastername ~= nil then
      msg.mastername = mastername
    end
    if carrierid ~= nil then
      msg.carrierid = carrierid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteCarrierUserCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if mastername ~= nil then
      msgParam.mastername = mastername
    end
    if carrierid ~= nil then
      msgParam.carrierid = carrierid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallJoinCarrierUserCmd(masterid, mastername, carrierid, agree)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.JoinCarrierUserCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if mastername ~= nil then
      msg.mastername = mastername
    end
    if carrierid ~= nil then
      msg.carrierid = carrierid
    end
    if agree ~= nil then
      msg.agree = agree
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JoinCarrierUserCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if mastername ~= nil then
      msgParam.mastername = mastername
    end
    if carrierid ~= nil then
      msgParam.carrierid = carrierid
    end
    if agree ~= nil then
      msgParam.agree = agree
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallRetJoinCarrierUserCmd(membername, agree, memberid, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.RetJoinCarrierUserCmd()
    if membername ~= nil then
      msg.membername = membername
    end
    if agree ~= nil then
      msg.agree = agree
    end
    if memberid ~= nil then
      msg.memberid = memberid
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RetJoinCarrierUserCmd.id
    local msgParam = {}
    if membername ~= nil then
      msgParam.membername = membername
    end
    if agree ~= nil then
      msgParam.agree = agree
    end
    if memberid ~= nil then
      msgParam.memberid = memberid
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallLeaveCarrierUserCmd(charid, pos, masterid, newmasterid, all)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.LeaveCarrierUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if newmasterid ~= nil then
      msg.newmasterid = newmasterid
    end
    if all ~= nil then
      msg.all = all
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LeaveCarrierUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if newmasterid ~= nil then
      msgParam.newmasterid = newmasterid
    end
    if all ~= nil then
      msgParam.all = all
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallReachCarrierUserCmd(pos, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.ReachCarrierUserCmd()
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReachCarrierUserCmd.id
    local msgParam = {}
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallCarrierMoveUserCmd(pos, progress, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.CarrierMoveUserCmd()
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    if progress ~= nil then
      msg.progress = progress
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CarrierMoveUserCmd.id
    local msgParam = {}
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    if progress ~= nil then
      msgParam.progress = progress
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallCarrierStartUserCmd(line, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.CarrierStartUserCmd()
    if line ~= nil then
      msg.line = line
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CarrierStartUserCmd.id
    local msgParam = {}
    if line ~= nil then
      msgParam.line = line
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallCarrierWaitListUserCmd(members, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.CarrierWaitListUserCmd()
    if members ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.members == nil then
        msg.members = {}
      end
      for i = 1, #members do
        table.insert(msg.members, members[i])
      end
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CarrierWaitListUserCmd.id
    local msgParam = {}
    if members ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.members == nil then
        msgParam.members = {}
      end
      for i = 1, #members do
        table.insert(msgParam.members, members[i])
      end
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallChangeCarrierUserCmd(carrierid, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.ChangeCarrierUserCmd()
    if carrierid ~= nil then
      msg.carrierid = carrierid
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeCarrierUserCmd.id
    local msgParam = {}
    if carrierid ~= nil then
      msgParam.carrierid = carrierid
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallFerrisWheelInviteCarrierCmd(targetid, targetname, id)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.FerrisWheelInviteCarrierCmd()
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if targetname ~= nil then
      msg.targetname = targetname
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FerrisWheelInviteCarrierCmd.id
    local msgParam = {}
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if targetname ~= nil then
      msgParam.targetname = targetname
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallFerrisWheelProcessInviteCarrierCmd(targetid, action, id)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.FerrisWheelProcessInviteCarrierCmd()
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if action ~= nil then
      msg.action = action
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FerrisWheelProcessInviteCarrierCmd.id
    local msgParam = {}
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if action ~= nil then
      msgParam.action = action
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallStartFerrisWheelUserCmd(charid, masterid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.StartFerrisWheelUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartFerrisWheelUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:CallCatchUserJoinCarrierUserCmd(charid, masterid, mapid)
  if not NetConfig.PBC then
    local msg = CarrierCmd_pb.CatchUserJoinCarrierUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatchUserJoinCarrierUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceCarrierCmdAutoProxy:RecvCarrierInfoUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdCarrierInfoUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvCreateCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdCreateCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvInviteCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdInviteCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvJoinCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdJoinCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvRetJoinCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdRetJoinCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvLeaveCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdLeaveCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvReachCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdReachCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvCarrierMoveUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdCarrierMoveUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvCarrierStartUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdCarrierStartUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvCarrierWaitListUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdCarrierWaitListUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvChangeCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdChangeCarrierUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvFerrisWheelInviteCarrierCmd(data)
  self:Notify(ServiceEvent.CarrierCmdFerrisWheelInviteCarrierCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvFerrisWheelProcessInviteCarrierCmd(data)
  self:Notify(ServiceEvent.CarrierCmdFerrisWheelProcessInviteCarrierCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvStartFerrisWheelUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdStartFerrisWheelUserCmd, data)
end

function ServiceCarrierCmdAutoProxy:RecvCatchUserJoinCarrierUserCmd(data)
  self:Notify(ServiceEvent.CarrierCmdCatchUserJoinCarrierUserCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.CarrierCmdCarrierInfoUserCmd = "ServiceEvent_CarrierCmdCarrierInfoUserCmd"
ServiceEvent.CarrierCmdCreateCarrierUserCmd = "ServiceEvent_CarrierCmdCreateCarrierUserCmd"
ServiceEvent.CarrierCmdInviteCarrierUserCmd = "ServiceEvent_CarrierCmdInviteCarrierUserCmd"
ServiceEvent.CarrierCmdJoinCarrierUserCmd = "ServiceEvent_CarrierCmdJoinCarrierUserCmd"
ServiceEvent.CarrierCmdRetJoinCarrierUserCmd = "ServiceEvent_CarrierCmdRetJoinCarrierUserCmd"
ServiceEvent.CarrierCmdLeaveCarrierUserCmd = "ServiceEvent_CarrierCmdLeaveCarrierUserCmd"
ServiceEvent.CarrierCmdReachCarrierUserCmd = "ServiceEvent_CarrierCmdReachCarrierUserCmd"
ServiceEvent.CarrierCmdCarrierMoveUserCmd = "ServiceEvent_CarrierCmdCarrierMoveUserCmd"
ServiceEvent.CarrierCmdCarrierStartUserCmd = "ServiceEvent_CarrierCmdCarrierStartUserCmd"
ServiceEvent.CarrierCmdCarrierWaitListUserCmd = "ServiceEvent_CarrierCmdCarrierWaitListUserCmd"
ServiceEvent.CarrierCmdChangeCarrierUserCmd = "ServiceEvent_CarrierCmdChangeCarrierUserCmd"
ServiceEvent.CarrierCmdFerrisWheelInviteCarrierCmd = "ServiceEvent_CarrierCmdFerrisWheelInviteCarrierCmd"
ServiceEvent.CarrierCmdFerrisWheelProcessInviteCarrierCmd = "ServiceEvent_CarrierCmdFerrisWheelProcessInviteCarrierCmd"
ServiceEvent.CarrierCmdStartFerrisWheelUserCmd = "ServiceEvent_CarrierCmdStartFerrisWheelUserCmd"
ServiceEvent.CarrierCmdCatchUserJoinCarrierUserCmd = "ServiceEvent_CarrierCmdCatchUserJoinCarrierUserCmd"
