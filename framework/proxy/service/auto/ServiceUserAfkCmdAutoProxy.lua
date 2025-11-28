ServiceUserAfkCmdAutoProxy = class("ServiceUserAfkCmdAutoProxy", ServiceProxy)
ServiceUserAfkCmdAutoProxy.Instance = nil
ServiceUserAfkCmdAutoProxy.NAME = "ServiceUserAfkCmdAutoProxy"

function ServiceUserAfkCmdAutoProxy:ctor(proxyName)
  if ServiceUserAfkCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserAfkCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserAfkCmdAutoProxy.Instance = self
  end
end

function ServiceUserAfkCmdAutoProxy:Init()
end

function ServiceUserAfkCmdAutoProxy:onRegister()
  self:Listen(74, 1, function(data)
    self:RecvReqAfkUserAfkCmd(data)
  end)
  self:Listen(74, 2, function(data)
    self:RecvRetAfkUserAfkCmd(data)
  end)
  self:Listen(74, 3, function(data)
    self:RecvSyncStatInfoAfkCmd(data)
  end)
end

function ServiceUserAfkCmdAutoProxy:CallReqAfkUserAfkCmd(timelen, inplace, protect_team, monsterids)
  if not NetConfig.PBC then
    local msg = UserAfkCmd_pb.ReqAfkUserAfkCmd()
    if timelen ~= nil then
      msg.timelen = timelen
    end
    if inplace ~= nil then
      msg.inplace = inplace
    end
    if protect_team ~= nil then
      msg.protect_team = protect_team
    end
    if monsterids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.monsterids == nil then
        msg.monsterids = {}
      end
      for i = 1, #monsterids do
        table.insert(msg.monsterids, monsterids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqAfkUserAfkCmd.id
    local msgParam = {}
    if timelen ~= nil then
      msgParam.timelen = timelen
    end
    if inplace ~= nil then
      msgParam.inplace = inplace
    end
    if protect_team ~= nil then
      msgParam.protect_team = protect_team
    end
    if monsterids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.monsterids == nil then
        msgParam.monsterids = {}
      end
      for i = 1, #monsterids do
        table.insert(msgParam.monsterids, monsterids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserAfkCmdAutoProxy:CallRetAfkUserAfkCmd(ret)
  if not NetConfig.PBC then
    local msg = UserAfkCmd_pb.RetAfkUserAfkCmd()
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RetAfkUserAfkCmd.id
    local msgParam = {}
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserAfkCmdAutoProxy:CallSyncStatInfoAfkCmd(statdata)
  if not NetConfig.PBC then
    local msg = UserAfkCmd_pb.SyncStatInfoAfkCmd()
    if statdata ~= nil and statdata.baseexp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.baseexp = statdata.baseexp
    end
    if statdata ~= nil and statdata.jobexp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.jobexp = statdata.jobexp
    end
    if statdata ~= nil and statdata.items ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.items == nil then
        msg.statdata.items = {}
      end
      for i = 1, #statdata.items do
        table.insert(msg.statdata.items, statdata.items[i])
      end
    end
    if statdata ~= nil and statdata.moneys ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.moneys == nil then
        msg.statdata.moneys = {}
      end
      for i = 1, #statdata.moneys do
        table.insert(msg.statdata.moneys, statdata.moneys[i])
      end
    end
    if statdata ~= nil and statdata.extra_zeny ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_zeny = statdata.extra_zeny
    end
    if statdata ~= nil and statdata.extra_base ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_base = statdata.extra_base
    end
    if statdata ~= nil and statdata.extra_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_job = statdata.extra_job
    end
    if statdata ~= nil and statdata.extra_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_time = statdata.extra_time
    end
    if statdata ~= nil and statdata.killinfo ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.killinfo == nil then
        msg.statdata.killinfo = {}
      end
      for i = 1, #statdata.killinfo do
        table.insert(msg.statdata.killinfo, statdata.killinfo[i])
      end
    end
    if statdata ~= nil and statdata.be_killinfo ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.be_killinfo == nil then
        msg.statdata.be_killinfo = {}
      end
      for i = 1, #statdata.be_killinfo do
        table.insert(msg.statdata.be_killinfo, statdata.be_killinfo[i])
      end
    end
    if statdata.battle_time ~= nil and statdata.battle_time.totaltime ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.battle_time == nil then
        msg.statdata.battle_time = {}
      end
      msg.statdata.battle_time.totaltime = statdata.battle_time.totaltime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.usedtime ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.battle_time == nil then
        msg.statdata.battle_time = {}
      end
      msg.statdata.battle_time.usedtime = statdata.battle_time.usedtime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.estatus ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.battle_time == nil then
        msg.statdata.battle_time = {}
      end
      msg.statdata.battle_time.estatus = statdata.battle_time.estatus
    end
    if statdata ~= nil and statdata.estatus ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.estatus = statdata.estatus
    end
    if statdata ~= nil and statdata.timelen ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.timelen = statdata.timelen
    end
    if statdata ~= nil and statdata.kill_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.kill_count = statdata.kill_count
    end
    if statdata ~= nil and statdata.left_afk_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.left_afk_count = statdata.left_afk_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncStatInfoAfkCmd.id
    local msgParam = {}
    if statdata ~= nil and statdata.baseexp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.baseexp = statdata.baseexp
    end
    if statdata ~= nil and statdata.jobexp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.jobexp = statdata.jobexp
    end
    if statdata ~= nil and statdata.items ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.items == nil then
        msgParam.statdata.items = {}
      end
      for i = 1, #statdata.items do
        table.insert(msgParam.statdata.items, statdata.items[i])
      end
    end
    if statdata ~= nil and statdata.moneys ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.moneys == nil then
        msgParam.statdata.moneys = {}
      end
      for i = 1, #statdata.moneys do
        table.insert(msgParam.statdata.moneys, statdata.moneys[i])
      end
    end
    if statdata ~= nil and statdata.extra_zeny ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_zeny = statdata.extra_zeny
    end
    if statdata ~= nil and statdata.extra_base ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_base = statdata.extra_base
    end
    if statdata ~= nil and statdata.extra_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_job = statdata.extra_job
    end
    if statdata ~= nil and statdata.extra_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_time = statdata.extra_time
    end
    if statdata ~= nil and statdata.killinfo ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.killinfo == nil then
        msgParam.statdata.killinfo = {}
      end
      for i = 1, #statdata.killinfo do
        table.insert(msgParam.statdata.killinfo, statdata.killinfo[i])
      end
    end
    if statdata ~= nil and statdata.be_killinfo ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.be_killinfo == nil then
        msgParam.statdata.be_killinfo = {}
      end
      for i = 1, #statdata.be_killinfo do
        table.insert(msgParam.statdata.be_killinfo, statdata.be_killinfo[i])
      end
    end
    if statdata.battle_time ~= nil and statdata.battle_time.totaltime ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.battle_time == nil then
        msgParam.statdata.battle_time = {}
      end
      msgParam.statdata.battle_time.totaltime = statdata.battle_time.totaltime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.usedtime ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.battle_time == nil then
        msgParam.statdata.battle_time = {}
      end
      msgParam.statdata.battle_time.usedtime = statdata.battle_time.usedtime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.estatus ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.battle_time == nil then
        msgParam.statdata.battle_time = {}
      end
      msgParam.statdata.battle_time.estatus = statdata.battle_time.estatus
    end
    if statdata ~= nil and statdata.estatus ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.estatus = statdata.estatus
    end
    if statdata ~= nil and statdata.timelen ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.timelen = statdata.timelen
    end
    if statdata ~= nil and statdata.kill_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.kill_count = statdata.kill_count
    end
    if statdata ~= nil and statdata.left_afk_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.left_afk_count = statdata.left_afk_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceUserAfkCmdAutoProxy:RecvReqAfkUserAfkCmd(data)
  self:Notify(ServiceEvent.UserAfkCmdReqAfkUserAfkCmd, data)
end

function ServiceUserAfkCmdAutoProxy:RecvRetAfkUserAfkCmd(data)
  self:Notify(ServiceEvent.UserAfkCmdRetAfkUserAfkCmd, data)
end

function ServiceUserAfkCmdAutoProxy:RecvSyncStatInfoAfkCmd(data)
  self:Notify(ServiceEvent.UserAfkCmdSyncStatInfoAfkCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.UserAfkCmdReqAfkUserAfkCmd = "ServiceEvent_UserAfkCmdReqAfkUserAfkCmd"
ServiceEvent.UserAfkCmdRetAfkUserAfkCmd = "ServiceEvent_UserAfkCmdRetAfkUserAfkCmd"
ServiceEvent.UserAfkCmdSyncStatInfoAfkCmd = "ServiceEvent_UserAfkCmdSyncStatInfoAfkCmd"
