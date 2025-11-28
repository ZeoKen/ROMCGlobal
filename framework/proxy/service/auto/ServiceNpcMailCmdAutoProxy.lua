ServiceNpcMailCmdAutoProxy = class("ServiceNpcMailCmdAutoProxy", ServiceProxy)
ServiceNpcMailCmdAutoProxy.Instance = nil
ServiceNpcMailCmdAutoProxy.NAME = "ServiceNpcMailCmdAutoProxy"

function ServiceNpcMailCmdAutoProxy:ctor(proxyName)
  if ServiceNpcMailCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNpcMailCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNpcMailCmdAutoProxy.Instance = self
  end
end

function ServiceNpcMailCmdAutoProxy:Init()
end

function ServiceNpcMailCmdAutoProxy:onRegister()
  self:Listen(77, 1, function(data)
    self:RecvSyncNpcMailCmd(data)
  end)
  self:Listen(77, 2, function(data)
    self:RecvUpdateNpcMailStepCmd(data)
  end)
  self:Listen(77, 3, function(data)
    self:RecvFinishMailStepCmd(data)
  end)
  self:Listen(77, 5, function(data)
    self:RecvAddNewNpcMailCmd(data)
  end)
  self:Listen(77, 4, function(data)
    self:RecvDeleteNpcMailCmd(data)
  end)
end

function ServiceNpcMailCmdAutoProxy:CallSyncNpcMailCmd(mails)
  if not NetConfig.PBC then
    local msg = NpcMailCmd_pb.SyncNpcMailCmd()
    if mails ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mails == nil then
        msg.mails = {}
      end
      for i = 1, #mails do
        table.insert(msg.mails, mails[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncNpcMailCmd.id
    local msgParam = {}
    if mails ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mails == nil then
        msgParam.mails = {}
      end
      for i = 1, #mails do
        table.insert(msgParam.mails, mails[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNpcMailCmdAutoProxy:CallUpdateNpcMailStepCmd(guid, step, done)
  if not NetConfig.PBC then
    local msg = NpcMailCmd_pb.UpdateNpcMailStepCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if step ~= nil then
      msg.step = step
    end
    if done ~= nil then
      msg.done = done
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateNpcMailStepCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if step ~= nil then
      msgParam.step = step
    end
    if done ~= nil then
      msgParam.done = done
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNpcMailCmdAutoProxy:CallFinishMailStepCmd(guid, step, opt)
  if not NetConfig.PBC then
    local msg = NpcMailCmd_pb.FinishMailStepCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if step ~= nil then
      msg.step = step
    end
    if opt ~= nil then
      msg.opt = opt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FinishMailStepCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if step ~= nil then
      msgParam.step = step
    end
    if opt ~= nil then
      msgParam.opt = opt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNpcMailCmdAutoProxy:CallAddNewNpcMailCmd(mail)
  if not NetConfig.PBC then
    local msg = NpcMailCmd_pb.AddNewNpcMailCmd()
    if mail ~= nil and mail.mailid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.mailid = mail.mailid
    end
    if mail ~= nil and mail.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.time = mail.time
    end
    if mail ~= nil and mail.done ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.done = mail.done
    end
    if mail ~= nil and mail.steps ~= nil then
      if msg.mail == nil then
        msg.mail = {}
      end
      if msg.mail.steps == nil then
        msg.mail.steps = {}
      end
      for i = 1, #mail.steps do
        table.insert(msg.mail.steps, mail.steps[i])
      end
    end
    if mail ~= nil and mail.items ~= nil then
      if msg.mail == nil then
        msg.mail = {}
      end
      if msg.mail.items == nil then
        msg.mail.items = {}
      end
      for i = 1, #mail.items do
        table.insert(msg.mail.items, mail.items[i])
      end
    end
    if mail ~= nil and mail.expiretime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.expiretime = mail.expiretime
    end
    if mail ~= nil and mail.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mail == nil then
        msg.mail = {}
      end
      msg.mail.guid = mail.guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddNewNpcMailCmd.id
    local msgParam = {}
    if mail ~= nil and mail.mailid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.mailid = mail.mailid
    end
    if mail ~= nil and mail.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.time = mail.time
    end
    if mail ~= nil and mail.done ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.done = mail.done
    end
    if mail ~= nil and mail.steps ~= nil then
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      if msgParam.mail.steps == nil then
        msgParam.mail.steps = {}
      end
      for i = 1, #mail.steps do
        table.insert(msgParam.mail.steps, mail.steps[i])
      end
    end
    if mail ~= nil and mail.items ~= nil then
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      if msgParam.mail.items == nil then
        msgParam.mail.items = {}
      end
      for i = 1, #mail.items do
        table.insert(msgParam.mail.items, mail.items[i])
      end
    end
    if mail ~= nil and mail.expiretime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.expiretime = mail.expiretime
    end
    if mail ~= nil and mail.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mail == nil then
        msgParam.mail = {}
      end
      msgParam.mail.guid = mail.guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNpcMailCmdAutoProxy:CallDeleteNpcMailCmd(guids)
  if not NetConfig.PBC then
    local msg = NpcMailCmd_pb.DeleteNpcMailCmd()
    if guids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guids == nil then
        msg.guids = {}
      end
      for i = 1, #guids do
        table.insert(msg.guids, guids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DeleteNpcMailCmd.id
    local msgParam = {}
    if guids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guids == nil then
        msgParam.guids = {}
      end
      for i = 1, #guids do
        table.insert(msgParam.guids, guids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNpcMailCmdAutoProxy:RecvSyncNpcMailCmd(data)
  self:Notify(ServiceEvent.NpcMailCmdSyncNpcMailCmd, data)
end

function ServiceNpcMailCmdAutoProxy:RecvUpdateNpcMailStepCmd(data)
  self:Notify(ServiceEvent.NpcMailCmdUpdateNpcMailStepCmd, data)
end

function ServiceNpcMailCmdAutoProxy:RecvFinishMailStepCmd(data)
  self:Notify(ServiceEvent.NpcMailCmdFinishMailStepCmd, data)
end

function ServiceNpcMailCmdAutoProxy:RecvAddNewNpcMailCmd(data)
  self:Notify(ServiceEvent.NpcMailCmdAddNewNpcMailCmd, data)
end

function ServiceNpcMailCmdAutoProxy:RecvDeleteNpcMailCmd(data)
  self:Notify(ServiceEvent.NpcMailCmdDeleteNpcMailCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.NpcMailCmdSyncNpcMailCmd = "ServiceEvent_NpcMailCmdSyncNpcMailCmd"
ServiceEvent.NpcMailCmdUpdateNpcMailStepCmd = "ServiceEvent_NpcMailCmdUpdateNpcMailStepCmd"
ServiceEvent.NpcMailCmdFinishMailStepCmd = "ServiceEvent_NpcMailCmdFinishMailStepCmd"
ServiceEvent.NpcMailCmdAddNewNpcMailCmd = "ServiceEvent_NpcMailCmdAddNewNpcMailCmd"
ServiceEvent.NpcMailCmdDeleteNpcMailCmd = "ServiceEvent_NpcMailCmdDeleteNpcMailCmd"
