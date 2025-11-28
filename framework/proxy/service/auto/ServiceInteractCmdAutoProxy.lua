ServiceInteractCmdAutoProxy = class("ServiceInteractCmdAutoProxy", ServiceProxy)
ServiceInteractCmdAutoProxy.Instance = nil
ServiceInteractCmdAutoProxy.NAME = "ServiceInteractCmdAutoProxy"

function ServiceInteractCmdAutoProxy:ctor(proxyName)
  if ServiceInteractCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceInteractCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceInteractCmdAutoProxy.Instance = self
  end
end

function ServiceInteractCmdAutoProxy:Init()
end

function ServiceInteractCmdAutoProxy:onRegister()
  self:Listen(217, 1, function(data)
    self:RecvAddMountInterCmd(data)
  end)
  self:Listen(217, 2, function(data)
    self:RecvDelMountInterCmd(data)
  end)
  self:Listen(217, 3, function(data)
    self:RecvConfirmMountInterCmd(data)
  end)
  self:Listen(217, 4, function(data)
    self:RecvCancelMountInterCmd(data)
  end)
  self:Listen(217, 5, function(data)
    self:RecvAddMoveMountInterCmd(data)
  end)
  self:Listen(217, 6, function(data)
    self:RecvDelMoveMountInterCmd(data)
  end)
  self:Listen(217, 7, function(data)
    self:RecvConfirmMoveMountInterCmd(data)
  end)
  self:Listen(217, 8, function(data)
    self:RecvCancelMoveMountInterCmd(data)
  end)
  self:Listen(217, 10, function(data)
    self:RecvUpdateTrainStateInterCmd(data)
  end)
  self:Listen(217, 9, function(data)
    self:RecvTrainUserSyncInterCmd(data)
  end)
  self:Listen(217, 11, function(data)
    self:RecvPosUpdateInterCmd(data)
  end)
  self:Listen(217, 12, function(data)
    self:RecvInteractNpcActionInterCmd(data)
  end)
end

function ServiceInteractCmdAutoProxy:CallAddMountInterCmd(npcguid, mountid, charid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.AddMountInterCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if mountid ~= nil then
      msg.mountid = mountid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMountInterCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if mountid ~= nil then
      msgParam.mountid = mountid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallDelMountInterCmd(npcguid, charid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.DelMountInterCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DelMountInterCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallConfirmMountInterCmd(npcguid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.ConfirmMountInterCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ConfirmMountInterCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallCancelMountInterCmd(npcguid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.CancelMountInterCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CancelMountInterCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallAddMoveMountInterCmd(npcid, user)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.AddMoveMountInterCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if user.user ~= nil and user.user.charid ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.charid = user.user.charid
    end
    if user.user ~= nil and user.user.guildid ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.guildid = user.user.guildid
    end
    if user.user ~= nil and user.user.accid ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.accid = user.user.accid
    end
    if user.user ~= nil and user.user.name ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.name = user.user.name
    end
    if user.user ~= nil and user.user.guildname ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.guildname = user.user.guildname
    end
    if user.user ~= nil and user.user.guildportrait ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.guildportrait = user.user.guildportrait
    end
    if user.user ~= nil and user.user.guildjob ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.guildjob = user.user.guildjob
    end
    if user ~= nil and user.user.datas ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.datas == nil then
        msg.user.user.datas = {}
      end
      for i = 1, #user.user.datas do
        table.insert(msg.user.user.datas, user.user.datas[i])
      end
    end
    if user ~= nil and user.user.attrs ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.attrs == nil then
        msg.user.user.attrs = {}
      end
      for i = 1, #user.user.attrs do
        table.insert(msg.user.user.attrs, user.user.attrs[i])
      end
    end
    if user ~= nil and user.user.equip ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.equip == nil then
        msg.user.user.equip = {}
      end
      for i = 1, #user.user.equip do
        table.insert(msg.user.user.equip, user.user.equip[i])
      end
    end
    if user ~= nil and user.user.fashion ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.fashion == nil then
        msg.user.user.fashion = {}
      end
      for i = 1, #user.user.fashion do
        table.insert(msg.user.user.fashion, user.user.fashion[i])
      end
    end
    if user ~= nil and user.user.shadow ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.shadow == nil then
        msg.user.user.shadow = {}
      end
      for i = 1, #user.user.shadow do
        table.insert(msg.user.user.shadow, user.user.shadow[i])
      end
    end
    if user ~= nil and user.user.extraction ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.extraction == nil then
        msg.user.user.extraction = {}
      end
      for i = 1, #user.user.extraction do
        table.insert(msg.user.user.extraction, user.user.extraction[i])
      end
    end
    if user ~= nil and user.user.highrefine ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.highrefine == nil then
        msg.user.user.highrefine = {}
      end
      for i = 1, #user.user.highrefine do
        table.insert(msg.user.user.highrefine, user.user.highrefine[i])
      end
    end
    if user.user ~= nil and user.user.partner ~= nil then
      if msg.user == nil then
        msg.user = {}
      end
      if msg.user.user == nil then
        msg.user.user = {}
      end
      msg.user.user.partner = user.user.partner
    end
    if user.user.mercenary ~= nil and user.user.mercenary.id ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.mercenary == nil then
        msg.user.user.mercenary = {}
      end
      msg.user.user.mercenary.id = user.user.mercenary.id
    end
    if user.user.mercenary ~= nil and user.user.mercenary.name ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.mercenary == nil then
        msg.user.user.mercenary = {}
      end
      msg.user.user.mercenary.name = user.user.mercenary.name
    end
    if user.user.mercenary ~= nil and user.user.mercenary.icon ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.mercenary == nil then
        msg.user.user.mercenary = {}
      end
      msg.user.user.mercenary.icon = user.user.mercenary.icon
    end
    if user.user.mercenary ~= nil and user.user.mercenary.job ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.mercenary == nil then
        msg.user.user.mercenary = {}
      end
      msg.user.user.mercenary.job = user.user.mercenary.job
    end
    if user.user.mercenary ~= nil and user.user.mercenary.mercenary_name ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.mercenary == nil then
        msg.user.user.mercenary = {}
      end
      msg.user.user.mercenary.mercenary_name = user.user.mercenary.mercenary_name
    end
    if user ~= nil and user.user.memory_pos ~= nil then
      if msg.user.user == nil then
        msg.user.user = {}
      end
      if msg.user.user.memory_pos == nil then
        msg.user.user.memory_pos = {}
      end
      for i = 1, #user.user.memory_pos do
        table.insert(msg.user.user.memory_pos, user.user.memory_pos[i])
      end
    end
    if user ~= nil and user.mountid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.user == nil then
        msg.user = {}
      end
      msg.user.mountid = user.mountid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMoveMountInterCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if user.user ~= nil and user.user.charid ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.charid = user.user.charid
    end
    if user.user ~= nil and user.user.guildid ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.guildid = user.user.guildid
    end
    if user.user ~= nil and user.user.accid ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.accid = user.user.accid
    end
    if user.user ~= nil and user.user.name ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.name = user.user.name
    end
    if user.user ~= nil and user.user.guildname ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.guildname = user.user.guildname
    end
    if user.user ~= nil and user.user.guildportrait ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.guildportrait = user.user.guildportrait
    end
    if user.user ~= nil and user.user.guildjob ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.guildjob = user.user.guildjob
    end
    if user ~= nil and user.user.datas ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.datas == nil then
        msgParam.user.user.datas = {}
      end
      for i = 1, #user.user.datas do
        table.insert(msgParam.user.user.datas, user.user.datas[i])
      end
    end
    if user ~= nil and user.user.attrs ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.attrs == nil then
        msgParam.user.user.attrs = {}
      end
      for i = 1, #user.user.attrs do
        table.insert(msgParam.user.user.attrs, user.user.attrs[i])
      end
    end
    if user ~= nil and user.user.equip ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.equip == nil then
        msgParam.user.user.equip = {}
      end
      for i = 1, #user.user.equip do
        table.insert(msgParam.user.user.equip, user.user.equip[i])
      end
    end
    if user ~= nil and user.user.fashion ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.fashion == nil then
        msgParam.user.user.fashion = {}
      end
      for i = 1, #user.user.fashion do
        table.insert(msgParam.user.user.fashion, user.user.fashion[i])
      end
    end
    if user ~= nil and user.user.shadow ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.shadow == nil then
        msgParam.user.user.shadow = {}
      end
      for i = 1, #user.user.shadow do
        table.insert(msgParam.user.user.shadow, user.user.shadow[i])
      end
    end
    if user ~= nil and user.user.extraction ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.extraction == nil then
        msgParam.user.user.extraction = {}
      end
      for i = 1, #user.user.extraction do
        table.insert(msgParam.user.user.extraction, user.user.extraction[i])
      end
    end
    if user ~= nil and user.user.highrefine ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.highrefine == nil then
        msgParam.user.user.highrefine = {}
      end
      for i = 1, #user.user.highrefine do
        table.insert(msgParam.user.user.highrefine, user.user.highrefine[i])
      end
    end
    if user.user ~= nil and user.user.partner ~= nil then
      if msgParam.user == nil then
        msgParam.user = {}
      end
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      msgParam.user.user.partner = user.user.partner
    end
    if user.user.mercenary ~= nil and user.user.mercenary.id ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.mercenary == nil then
        msgParam.user.user.mercenary = {}
      end
      msgParam.user.user.mercenary.id = user.user.mercenary.id
    end
    if user.user.mercenary ~= nil and user.user.mercenary.name ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.mercenary == nil then
        msgParam.user.user.mercenary = {}
      end
      msgParam.user.user.mercenary.name = user.user.mercenary.name
    end
    if user.user.mercenary ~= nil and user.user.mercenary.icon ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.mercenary == nil then
        msgParam.user.user.mercenary = {}
      end
      msgParam.user.user.mercenary.icon = user.user.mercenary.icon
    end
    if user.user.mercenary ~= nil and user.user.mercenary.job ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.mercenary == nil then
        msgParam.user.user.mercenary = {}
      end
      msgParam.user.user.mercenary.job = user.user.mercenary.job
    end
    if user.user.mercenary ~= nil and user.user.mercenary.mercenary_name ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.mercenary == nil then
        msgParam.user.user.mercenary = {}
      end
      msgParam.user.user.mercenary.mercenary_name = user.user.mercenary.mercenary_name
    end
    if user ~= nil and user.user.memory_pos ~= nil then
      if msgParam.user.user == nil then
        msgParam.user.user = {}
      end
      if msgParam.user.user.memory_pos == nil then
        msgParam.user.user.memory_pos = {}
      end
      for i = 1, #user.user.memory_pos do
        table.insert(msgParam.user.user.memory_pos, user.user.memory_pos[i])
      end
    end
    if user ~= nil and user.mountid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.user == nil then
        msgParam.user = {}
      end
      msgParam.user.mountid = user.mountid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallDelMoveMountInterCmd(npcid, charids)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.DelMoveMountInterCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if charids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.charids == nil then
        msg.charids = {}
      end
      for i = 1, #charids do
        table.insert(msg.charids, charids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DelMoveMountInterCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if charids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.charids == nil then
        msgParam.charids = {}
      end
      for i = 1, #charids do
        table.insert(msgParam.charids, charids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallConfirmMoveMountInterCmd(npcid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.ConfirmMoveMountInterCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ConfirmMoveMountInterCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallCancelMoveMountInterCmd(npcid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.CancelMoveMountInterCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CancelMoveMountInterCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallUpdateTrainStateInterCmd(npcid, state)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.UpdateTrainStateInterCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if state ~= nil then
      msg.state = state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateTrainStateInterCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if state ~= nil then
      msgParam.state = state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallTrainUserSyncInterCmd(state, arrivetime, users, npcid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.TrainUserSyncInterCmd()
    if state ~= nil then
      msg.state = state
    end
    if arrivetime ~= nil then
      msg.arrivetime = arrivetime
    end
    if users ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.users == nil then
        msg.users = {}
      end
      for i = 1, #users do
        table.insert(msg.users, users[i])
      end
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TrainUserSyncInterCmd.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    if arrivetime ~= nil then
      msgParam.arrivetime = arrivetime
    end
    if users ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.users == nil then
        msgParam.users = {}
      end
      for i = 1, #users do
        table.insert(msgParam.users, users[i])
      end
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallPosUpdateInterCmd(pos)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.PosUpdateInterCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PosUpdateInterCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:CallInteractNpcActionInterCmd(actionid, internpc, charid)
  if not NetConfig.PBC then
    local msg = InteractCmd_pb.InteractNpcActionInterCmd()
    if actionid ~= nil then
      msg.actionid = actionid
    end
    if internpc ~= nil then
      msg.internpc = internpc
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InteractNpcActionInterCmd.id
    local msgParam = {}
    if actionid ~= nil then
      msgParam.actionid = actionid
    end
    if internpc ~= nil then
      msgParam.internpc = internpc
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInteractCmdAutoProxy:RecvAddMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdAddMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvDelMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdDelMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvConfirmMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdConfirmMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvCancelMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdCancelMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvAddMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdAddMoveMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvDelMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdDelMoveMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvConfirmMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdConfirmMoveMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvCancelMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdCancelMoveMountInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvUpdateTrainStateInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdUpdateTrainStateInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvTrainUserSyncInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdTrainUserSyncInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvPosUpdateInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdPosUpdateInterCmd, data)
end

function ServiceInteractCmdAutoProxy:RecvInteractNpcActionInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdInteractNpcActionInterCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.InteractCmdAddMountInterCmd = "ServiceEvent_InteractCmdAddMountInterCmd"
ServiceEvent.InteractCmdDelMountInterCmd = "ServiceEvent_InteractCmdDelMountInterCmd"
ServiceEvent.InteractCmdConfirmMountInterCmd = "ServiceEvent_InteractCmdConfirmMountInterCmd"
ServiceEvent.InteractCmdCancelMountInterCmd = "ServiceEvent_InteractCmdCancelMountInterCmd"
ServiceEvent.InteractCmdAddMoveMountInterCmd = "ServiceEvent_InteractCmdAddMoveMountInterCmd"
ServiceEvent.InteractCmdDelMoveMountInterCmd = "ServiceEvent_InteractCmdDelMoveMountInterCmd"
ServiceEvent.InteractCmdConfirmMoveMountInterCmd = "ServiceEvent_InteractCmdConfirmMoveMountInterCmd"
ServiceEvent.InteractCmdCancelMoveMountInterCmd = "ServiceEvent_InteractCmdCancelMoveMountInterCmd"
ServiceEvent.InteractCmdUpdateTrainStateInterCmd = "ServiceEvent_InteractCmdUpdateTrainStateInterCmd"
ServiceEvent.InteractCmdTrainUserSyncInterCmd = "ServiceEvent_InteractCmdTrainUserSyncInterCmd"
ServiceEvent.InteractCmdPosUpdateInterCmd = "ServiceEvent_InteractCmdPosUpdateInterCmd"
ServiceEvent.InteractCmdInteractNpcActionInterCmd = "ServiceEvent_InteractCmdInteractNpcActionInterCmd"
