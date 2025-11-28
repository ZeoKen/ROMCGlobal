ServiceBossCmdAutoProxy = class("ServiceBossCmdAutoProxy", ServiceProxy)
ServiceBossCmdAutoProxy.Instance = nil
ServiceBossCmdAutoProxy.NAME = "ServiceBossCmdAutoProxy"

function ServiceBossCmdAutoProxy:ctor(proxyName)
  if ServiceBossCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBossCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBossCmdAutoProxy.Instance = self
  end
end

function ServiceBossCmdAutoProxy:Init()
end

function ServiceBossCmdAutoProxy:onRegister()
  self:Listen(15, 1, function(data)
    self:RecvBossListUserCmd(data)
  end)
  self:Listen(15, 2, function(data)
    self:RecvBossPosUserCmd(data)
  end)
  self:Listen(15, 3, function(data)
    self:RecvKillBossUserCmd(data)
  end)
  self:Listen(15, 4, function(data)
    self:RecvQueryKillerInfoBossCmd(data)
  end)
  self:Listen(15, 5, function(data)
    self:RecvWorldBossNtf(data)
  end)
  self:Listen(15, 6, function(data)
    self:RecvStepSyncBossCmd(data)
  end)
  self:Listen(15, 7, function(data)
    self:RecvQueryFavaouiteBossCmd(data)
  end)
  self:Listen(15, 8, function(data)
    self:RecvModifyFavouriteBossCmd(data)
  end)
  self:Listen(15, 9, function(data)
    self:RecvQueryRareEliteCmd(data)
  end)
  self:Listen(15, 10, function(data)
    self:RecvQuerySpecMapRareEliteCmd(data)
  end)
  self:Listen(15, 11, function(data)
    self:RecvUpdateCurMapBossCmd(data)
  end)
end

function ServiceBossCmdAutoProxy:CallBossListUserCmd(bosslist, minilist, deadlist)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.BossListUserCmd()
    if bosslist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bosslist == nil then
        msg.bosslist = {}
      end
      for i = 1, #bosslist do
        table.insert(msg.bosslist, bosslist[i])
      end
    end
    if minilist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.minilist == nil then
        msg.minilist = {}
      end
      for i = 1, #minilist do
        table.insert(msg.minilist, minilist[i])
      end
    end
    if deadlist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.deadlist == nil then
        msg.deadlist = {}
      end
      for i = 1, #deadlist do
        table.insert(msg.deadlist, deadlist[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BossListUserCmd.id
    local msgParam = {}
    if bosslist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bosslist == nil then
        msgParam.bosslist = {}
      end
      for i = 1, #bosslist do
        table.insert(msgParam.bosslist, bosslist[i])
      end
    end
    if minilist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.minilist == nil then
        msgParam.minilist = {}
      end
      for i = 1, #minilist do
        table.insert(msgParam.minilist, minilist[i])
      end
    end
    if deadlist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.deadlist == nil then
        msgParam.deadlist = {}
      end
      for i = 1, #deadlist do
        table.insert(msgParam.deadlist, deadlist[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallBossPosUserCmd(pos)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.BossPosUserCmd()
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
    local msgId = ProtoReqInfoList.BossPosUserCmd.id
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

function ServiceBossCmdAutoProxy:CallKillBossUserCmd(userid)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.KillBossUserCmd()
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KillBossUserCmd.id
    local msgParam = {}
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallQueryKillerInfoBossCmd(charid, userdata)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.QueryKillerInfoBossCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if userdata ~= nil and userdata.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.charid = userdata.charid
    end
    if userdata ~= nil and userdata.portrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.portrait = userdata.portrait
    end
    if userdata ~= nil and userdata.frame ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.frame = userdata.frame
    end
    if userdata ~= nil and userdata.baselevel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.baselevel = userdata.baselevel
    end
    if userdata ~= nil and userdata.hair ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.hair = userdata.hair
    end
    if userdata ~= nil and userdata.haircolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.haircolor = userdata.haircolor
    end
    if userdata ~= nil and userdata.body ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.body = userdata.body
    end
    if userdata ~= nil and userdata.head ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.head = userdata.head
    end
    if userdata ~= nil and userdata.face ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.face = userdata.face
    end
    if userdata ~= nil and userdata.mouth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.mouth = userdata.mouth
    end
    if userdata ~= nil and userdata.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.eye = userdata.eye
    end
    if userdata ~= nil and userdata.blink ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.blink = userdata.blink
    end
    if userdata ~= nil and userdata.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.profession = userdata.profession
    end
    if userdata ~= nil and userdata.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.gender = userdata.gender
    end
    if userdata ~= nil and userdata.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.name = userdata.name
    end
    if userdata ~= nil and userdata.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.guildname = userdata.guildname
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryKillerInfoBossCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if userdata ~= nil and userdata.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.charid = userdata.charid
    end
    if userdata ~= nil and userdata.portrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.portrait = userdata.portrait
    end
    if userdata ~= nil and userdata.frame ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.frame = userdata.frame
    end
    if userdata ~= nil and userdata.baselevel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.baselevel = userdata.baselevel
    end
    if userdata ~= nil and userdata.hair ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.hair = userdata.hair
    end
    if userdata ~= nil and userdata.haircolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.haircolor = userdata.haircolor
    end
    if userdata ~= nil and userdata.body ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.body = userdata.body
    end
    if userdata ~= nil and userdata.head ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.head = userdata.head
    end
    if userdata ~= nil and userdata.face ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.face = userdata.face
    end
    if userdata ~= nil and userdata.mouth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.mouth = userdata.mouth
    end
    if userdata ~= nil and userdata.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.eye = userdata.eye
    end
    if userdata ~= nil and userdata.blink ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.blink = userdata.blink
    end
    if userdata ~= nil and userdata.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.profession = userdata.profession
    end
    if userdata ~= nil and userdata.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.gender = userdata.gender
    end
    if userdata ~= nil and userdata.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.name = userdata.name
    end
    if userdata ~= nil and userdata.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.guildname = userdata.guildname
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallWorldBossNtf(npcid, mapid, time, open)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.WorldBossNtf()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if time ~= nil then
      msg.time = time
    end
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WorldBossNtf.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallStepSyncBossCmd(actid, step, params)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.StepSyncBossCmd()
    if actid ~= nil then
      msg.actid = actid
    end
    if step ~= nil then
      msg.step = step
    end
    if params ~= nil and params.params ~= nil then
      if msg.params == nil then
        msg.params = {}
      end
      if msg.params.params == nil then
        msg.params.params = {}
      end
      for i = 1, #params.params do
        table.insert(msg.params.params, params.params[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StepSyncBossCmd.id
    local msgParam = {}
    if actid ~= nil then
      msgParam.actid = actid
    end
    if step ~= nil then
      msgParam.step = step
    end
    if params ~= nil and params.params ~= nil then
      if msgParam.params == nil then
        msgParam.params = {}
      end
      if msgParam.params.params == nil then
        msgParam.params.params = {}
      end
      for i = 1, #params.params do
        table.insert(msgParam.params.params, params.params[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallQueryFavaouiteBossCmd(bossids)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.QueryFavaouiteBossCmd()
    if bossids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bossids == nil then
        msg.bossids = {}
      end
      for i = 1, #bossids do
        table.insert(msg.bossids, bossids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFavaouiteBossCmd.id
    local msgParam = {}
    if bossids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bossids == nil then
        msgParam.bossids = {}
      end
      for i = 1, #bossids do
        table.insert(msgParam.bossids, bossids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallModifyFavouriteBossCmd(bossids)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.ModifyFavouriteBossCmd()
    if bossids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bossids == nil then
        msg.bossids = {}
      end
      for i = 1, #bossids do
        table.insert(msg.bossids, bossids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ModifyFavouriteBossCmd.id
    local msgParam = {}
    if bossids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bossids == nil then
        msgParam.bossids = {}
      end
      for i = 1, #bossids do
        table.insert(msgParam.bossids, bossids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallQueryRareEliteCmd(query_type, datas)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.QueryRareEliteCmd()
    if query_type ~= nil then
      msg.query_type = query_type
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryRareEliteCmd.id
    local msgParam = {}
    if query_type ~= nil then
      msgParam.query_type = query_type
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallQuerySpecMapRareEliteCmd(maps, query_type, datas)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.QuerySpecMapRareEliteCmd()
    if maps ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.maps == nil then
        msg.maps = {}
      end
      for i = 1, #maps do
        table.insert(msg.maps, maps[i])
      end
    end
    if query_type ~= nil then
      msg.query_type = query_type
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuerySpecMapRareEliteCmd.id
    local msgParam = {}
    if maps ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.maps == nil then
        msgParam.maps = {}
      end
      for i = 1, #maps do
        table.insert(msgParam.maps, maps[i])
      end
    end
    if query_type ~= nil then
      msgParam.query_type = query_type
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:CallUpdateCurMapBossCmd(datas)
  if not NetConfig.PBC then
    local msg = BossCmd_pb.UpdateCurMapBossCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateCurMapBossCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceBossCmdAutoProxy:RecvBossListUserCmd(data)
  self:Notify(ServiceEvent.BossCmdBossListUserCmd, data)
end

function ServiceBossCmdAutoProxy:RecvBossPosUserCmd(data)
  self:Notify(ServiceEvent.BossCmdBossPosUserCmd, data)
end

function ServiceBossCmdAutoProxy:RecvKillBossUserCmd(data)
  self:Notify(ServiceEvent.BossCmdKillBossUserCmd, data)
end

function ServiceBossCmdAutoProxy:RecvQueryKillerInfoBossCmd(data)
  self:Notify(ServiceEvent.BossCmdQueryKillerInfoBossCmd, data)
end

function ServiceBossCmdAutoProxy:RecvWorldBossNtf(data)
  self:Notify(ServiceEvent.BossCmdWorldBossNtf, data)
end

function ServiceBossCmdAutoProxy:RecvStepSyncBossCmd(data)
  self:Notify(ServiceEvent.BossCmdStepSyncBossCmd, data)
end

function ServiceBossCmdAutoProxy:RecvQueryFavaouiteBossCmd(data)
  self:Notify(ServiceEvent.BossCmdQueryFavaouiteBossCmd, data)
end

function ServiceBossCmdAutoProxy:RecvModifyFavouriteBossCmd(data)
  self:Notify(ServiceEvent.BossCmdModifyFavouriteBossCmd, data)
end

function ServiceBossCmdAutoProxy:RecvQueryRareEliteCmd(data)
  self:Notify(ServiceEvent.BossCmdQueryRareEliteCmd, data)
end

function ServiceBossCmdAutoProxy:RecvQuerySpecMapRareEliteCmd(data)
  self:Notify(ServiceEvent.BossCmdQuerySpecMapRareEliteCmd, data)
end

function ServiceBossCmdAutoProxy:RecvUpdateCurMapBossCmd(data)
  self:Notify(ServiceEvent.BossCmdUpdateCurMapBossCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.BossCmdBossListUserCmd = "ServiceEvent_BossCmdBossListUserCmd"
ServiceEvent.BossCmdBossPosUserCmd = "ServiceEvent_BossCmdBossPosUserCmd"
ServiceEvent.BossCmdKillBossUserCmd = "ServiceEvent_BossCmdKillBossUserCmd"
ServiceEvent.BossCmdQueryKillerInfoBossCmd = "ServiceEvent_BossCmdQueryKillerInfoBossCmd"
ServiceEvent.BossCmdWorldBossNtf = "ServiceEvent_BossCmdWorldBossNtf"
ServiceEvent.BossCmdStepSyncBossCmd = "ServiceEvent_BossCmdStepSyncBossCmd"
ServiceEvent.BossCmdQueryFavaouiteBossCmd = "ServiceEvent_BossCmdQueryFavaouiteBossCmd"
ServiceEvent.BossCmdModifyFavouriteBossCmd = "ServiceEvent_BossCmdModifyFavouriteBossCmd"
ServiceEvent.BossCmdQueryRareEliteCmd = "ServiceEvent_BossCmdQueryRareEliteCmd"
ServiceEvent.BossCmdQuerySpecMapRareEliteCmd = "ServiceEvent_BossCmdQuerySpecMapRareEliteCmd"
ServiceEvent.BossCmdUpdateCurMapBossCmd = "ServiceEvent_BossCmdUpdateCurMapBossCmd"
