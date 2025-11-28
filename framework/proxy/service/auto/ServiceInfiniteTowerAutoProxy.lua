ServiceInfiniteTowerAutoProxy = class("ServiceInfiniteTowerAutoProxy", ServiceProxy)
ServiceInfiniteTowerAutoProxy.Instance = nil
ServiceInfiniteTowerAutoProxy.NAME = "ServiceInfiniteTowerAutoProxy"

function ServiceInfiniteTowerAutoProxy:ctor(proxyName)
  if ServiceInfiniteTowerAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceInfiniteTowerAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceInfiniteTowerAutoProxy.Instance = self
  end
end

function ServiceInfiniteTowerAutoProxy:Init()
end

function ServiceInfiniteTowerAutoProxy:onRegister()
  self:Listen(20, 1, function(data)
    self:RecvTeamTowerInfoCmd(data)
  end)
  self:Listen(20, 2, function(data)
    self:RecvTeamTowerSummaryCmd(data)
  end)
  self:Listen(20, 3, function(data)
    self:RecvTeamTowerInviteCmd(data)
  end)
  self:Listen(20, 4, function(data)
    self:RecvTeamTowerReplyCmd(data)
  end)
  self:Listen(20, 5, function(data)
    self:RecvEnterTower(data)
  end)
  self:Listen(20, 7, function(data)
    self:RecvUserTowerInfoCmd(data)
  end)
  self:Listen(20, 8, function(data)
    self:RecvTowerLayerSyncTowerCmd(data)
  end)
  self:Listen(20, 10, function(data)
    self:RecvTowerInfoCmd(data)
  end)
  self:Listen(20, 9, function(data)
    self:RecvNewEverLayerTowerCmd(data)
  end)
  self:Listen(20, 11, function(data)
    self:RecvTowerLaunchCmd(data)
  end)
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerInfoCmd(teamid)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TeamTowerInfoCmd()
    if teamid ~= nil then
      msg.teamid = teamid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamTowerInfoCmd.id
    local msgParam = {}
    if teamid ~= nil then
      msgParam.teamid = teamid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerSummaryCmd(teamtower, maxlayer, refreshtime)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TeamTowerSummaryCmd()
    if teamtower ~= nil and teamtower.teamid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      msg.teamtower.teamid = teamtower.teamid
    end
    if teamtower ~= nil and teamtower.layer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      msg.teamtower.layer = teamtower.layer
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.oldmaxlayer ~= nil then
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      if msg.teamtower.leadertower == nil then
        msg.teamtower.leadertower = {}
      end
      msg.teamtower.leadertower.oldmaxlayer = teamtower.leadertower.oldmaxlayer
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.curmaxlayer ~= nil then
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      if msg.teamtower.leadertower == nil then
        msg.teamtower.leadertower = {}
      end
      msg.teamtower.leadertower.curmaxlayer = teamtower.leadertower.curmaxlayer
    end
    if teamtower ~= nil and teamtower.leadertower.layers ~= nil then
      if msg.teamtower.leadertower == nil then
        msg.teamtower.leadertower = {}
      end
      if msg.teamtower.leadertower.layers == nil then
        msg.teamtower.leadertower.layers = {}
      end
      for i = 1, #teamtower.leadertower.layers do
        table.insert(msg.teamtower.leadertower.layers, teamtower.leadertower.layers[i])
      end
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.maxlayer ~= nil then
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      if msg.teamtower.leadertower == nil then
        msg.teamtower.leadertower = {}
      end
      msg.teamtower.leadertower.maxlayer = teamtower.leadertower.maxlayer
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.record_layer ~= nil then
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      if msg.teamtower.leadertower == nil then
        msg.teamtower.leadertower = {}
      end
      msg.teamtower.leadertower.record_layer = teamtower.leadertower.record_layer
    end
    if teamtower ~= nil and teamtower.leadertower.everpasslayers ~= nil then
      if msg.teamtower.leadertower == nil then
        msg.teamtower.leadertower = {}
      end
      if msg.teamtower.leadertower.everpasslayers == nil then
        msg.teamtower.leadertower.everpasslayers = {}
      end
      for i = 1, #teamtower.leadertower.everpasslayers do
        table.insert(msg.teamtower.leadertower.everpasslayers, teamtower.leadertower.everpasslayers[i])
      end
    end
    if teamtower ~= nil and teamtower.members ~= nil then
      if msg.teamtower == nil then
        msg.teamtower = {}
      end
      if msg.teamtower.members == nil then
        msg.teamtower.members = {}
      end
      for i = 1, #teamtower.members do
        table.insert(msg.teamtower.members, teamtower.members[i])
      end
    end
    if maxlayer ~= nil then
      msg.maxlayer = maxlayer
    end
    if refreshtime ~= nil then
      msg.refreshtime = refreshtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamTowerSummaryCmd.id
    local msgParam = {}
    if teamtower ~= nil and teamtower.teamid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      msgParam.teamtower.teamid = teamtower.teamid
    end
    if teamtower ~= nil and teamtower.layer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      msgParam.teamtower.layer = teamtower.layer
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.oldmaxlayer ~= nil then
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      if msgParam.teamtower.leadertower == nil then
        msgParam.teamtower.leadertower = {}
      end
      msgParam.teamtower.leadertower.oldmaxlayer = teamtower.leadertower.oldmaxlayer
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.curmaxlayer ~= nil then
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      if msgParam.teamtower.leadertower == nil then
        msgParam.teamtower.leadertower = {}
      end
      msgParam.teamtower.leadertower.curmaxlayer = teamtower.leadertower.curmaxlayer
    end
    if teamtower ~= nil and teamtower.leadertower.layers ~= nil then
      if msgParam.teamtower.leadertower == nil then
        msgParam.teamtower.leadertower = {}
      end
      if msgParam.teamtower.leadertower.layers == nil then
        msgParam.teamtower.leadertower.layers = {}
      end
      for i = 1, #teamtower.leadertower.layers do
        table.insert(msgParam.teamtower.leadertower.layers, teamtower.leadertower.layers[i])
      end
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.maxlayer ~= nil then
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      if msgParam.teamtower.leadertower == nil then
        msgParam.teamtower.leadertower = {}
      end
      msgParam.teamtower.leadertower.maxlayer = teamtower.leadertower.maxlayer
    end
    if teamtower.leadertower ~= nil and teamtower.leadertower.record_layer ~= nil then
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      if msgParam.teamtower.leadertower == nil then
        msgParam.teamtower.leadertower = {}
      end
      msgParam.teamtower.leadertower.record_layer = teamtower.leadertower.record_layer
    end
    if teamtower ~= nil and teamtower.leadertower.everpasslayers ~= nil then
      if msgParam.teamtower.leadertower == nil then
        msgParam.teamtower.leadertower = {}
      end
      if msgParam.teamtower.leadertower.everpasslayers == nil then
        msgParam.teamtower.leadertower.everpasslayers = {}
      end
      for i = 1, #teamtower.leadertower.everpasslayers do
        table.insert(msgParam.teamtower.leadertower.everpasslayers, teamtower.leadertower.everpasslayers[i])
      end
    end
    if teamtower ~= nil and teamtower.members ~= nil then
      if msgParam.teamtower == nil then
        msgParam.teamtower = {}
      end
      if msgParam.teamtower.members == nil then
        msgParam.teamtower.members = {}
      end
      for i = 1, #teamtower.members do
        table.insert(msgParam.teamtower.members, teamtower.members[i])
      end
    end
    if maxlayer ~= nil then
      msgParam.maxlayer = maxlayer
    end
    if refreshtime ~= nil then
      msgParam.refreshtime = refreshtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerInviteCmd(iscancel, layer, entranceid, lefttime)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TeamTowerInviteCmd()
    if iscancel ~= nil then
      msg.iscancel = iscancel
    end
    if layer ~= nil then
      msg.layer = layer
    end
    if entranceid ~= nil then
      msg.entranceid = entranceid
    end
    if lefttime ~= nil then
      msg.lefttime = lefttime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamTowerInviteCmd.id
    local msgParam = {}
    if iscancel ~= nil then
      msgParam.iscancel = iscancel
    end
    if layer ~= nil then
      msgParam.layer = layer
    end
    if entranceid ~= nil then
      msgParam.entranceid = entranceid
    end
    if lefttime ~= nil then
      msgParam.lefttime = lefttime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallTeamTowerReplyCmd(eReply, userid)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TeamTowerReplyCmd()
    if eReply ~= nil then
      msg.eReply = eReply
    end
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamTowerReplyCmd.id
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

function ServiceInfiniteTowerAutoProxy:CallEnterTower(layer, userid, zoneid, time, sign, gomaptype)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.EnterTower()
    if layer ~= nil then
      msg.layer = layer
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
    if gomaptype ~= nil then
      msg.gomaptype = gomaptype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterTower.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
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
    if gomaptype ~= nil then
      msgParam.gomaptype = gomaptype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallUserTowerInfoCmd(usertower)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.UserTowerInfoCmd()
    if usertower ~= nil and usertower.oldmaxlayer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.usertower == nil then
        msg.usertower = {}
      end
      msg.usertower.oldmaxlayer = usertower.oldmaxlayer
    end
    if usertower ~= nil and usertower.curmaxlayer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.usertower == nil then
        msg.usertower = {}
      end
      msg.usertower.curmaxlayer = usertower.curmaxlayer
    end
    if usertower ~= nil and usertower.layers ~= nil then
      if msg.usertower == nil then
        msg.usertower = {}
      end
      if msg.usertower.layers == nil then
        msg.usertower.layers = {}
      end
      for i = 1, #usertower.layers do
        table.insert(msg.usertower.layers, usertower.layers[i])
      end
    end
    if usertower ~= nil and usertower.maxlayer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.usertower == nil then
        msg.usertower = {}
      end
      msg.usertower.maxlayer = usertower.maxlayer
    end
    if usertower ~= nil and usertower.record_layer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.usertower == nil then
        msg.usertower = {}
      end
      msg.usertower.record_layer = usertower.record_layer
    end
    if usertower ~= nil and usertower.everpasslayers ~= nil then
      if msg.usertower == nil then
        msg.usertower = {}
      end
      if msg.usertower.everpasslayers == nil then
        msg.usertower.everpasslayers = {}
      end
      for i = 1, #usertower.everpasslayers do
        table.insert(msg.usertower.everpasslayers, usertower.everpasslayers[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserTowerInfoCmd.id
    local msgParam = {}
    if usertower ~= nil and usertower.oldmaxlayer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.usertower == nil then
        msgParam.usertower = {}
      end
      msgParam.usertower.oldmaxlayer = usertower.oldmaxlayer
    end
    if usertower ~= nil and usertower.curmaxlayer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.usertower == nil then
        msgParam.usertower = {}
      end
      msgParam.usertower.curmaxlayer = usertower.curmaxlayer
    end
    if usertower ~= nil and usertower.layers ~= nil then
      if msgParam.usertower == nil then
        msgParam.usertower = {}
      end
      if msgParam.usertower.layers == nil then
        msgParam.usertower.layers = {}
      end
      for i = 1, #usertower.layers do
        table.insert(msgParam.usertower.layers, usertower.layers[i])
      end
    end
    if usertower ~= nil and usertower.maxlayer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.usertower == nil then
        msgParam.usertower = {}
      end
      msgParam.usertower.maxlayer = usertower.maxlayer
    end
    if usertower ~= nil and usertower.record_layer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.usertower == nil then
        msgParam.usertower = {}
      end
      msgParam.usertower.record_layer = usertower.record_layer
    end
    if usertower ~= nil and usertower.everpasslayers ~= nil then
      if msgParam.usertower == nil then
        msgParam.usertower = {}
      end
      if msgParam.usertower.everpasslayers == nil then
        msgParam.usertower.everpasslayers = {}
      end
      for i = 1, #usertower.everpasslayers do
        table.insert(msgParam.usertower.everpasslayers, usertower.everpasslayers[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallTowerLayerSyncTowerCmd(layer)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TowerLayerSyncTowerCmd()
    if layer ~= nil then
      msg.layer = layer
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TowerLayerSyncTowerCmd.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallTowerInfoCmd(maxlayer, refreshtime)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TowerInfoCmd()
    if maxlayer ~= nil then
      msg.maxlayer = maxlayer
    end
    if refreshtime ~= nil then
      msg.refreshtime = refreshtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TowerInfoCmd.id
    local msgParam = {}
    if maxlayer ~= nil then
      msgParam.maxlayer = maxlayer
    end
    if refreshtime ~= nil then
      msgParam.refreshtime = refreshtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallNewEverLayerTowerCmd(layers)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.NewEverLayerTowerCmd()
    if layers ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.layers == nil then
        msg.layers = {}
      end
      for i = 1, #layers do
        table.insert(msg.layers, layers[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewEverLayerTowerCmd.id
    local msgParam = {}
    if layers ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.layers == nil then
        msgParam.layers = {}
      end
      for i = 1, #layers do
        table.insert(msgParam.layers, layers[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:CallTowerLaunchCmd(tolayer, success)
  if not NetConfig.PBC then
    local msg = InfiniteTower_pb.TowerLaunchCmd()
    if tolayer ~= nil then
      msg.tolayer = tolayer
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TowerLaunchCmd.id
    local msgParam = {}
    if tolayer ~= nil then
      msgParam.tolayer = tolayer
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerInfoCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerSummaryCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerSummaryCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerInviteCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerInviteCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTeamTowerReplyCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTeamTowerReplyCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvEnterTower(data)
  self:Notify(ServiceEvent.InfiniteTowerEnterTower, data)
end

function ServiceInfiniteTowerAutoProxy:RecvUserTowerInfoCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerUserTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerLayerSyncTowerCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTowerLayerSyncTowerCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerInfoCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTowerInfoCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvNewEverLayerTowerCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerNewEverLayerTowerCmd, data)
end

function ServiceInfiniteTowerAutoProxy:RecvTowerLaunchCmd(data)
  self:Notify(ServiceEvent.InfiniteTowerTowerLaunchCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.InfiniteTowerTeamTowerInfoCmd = "ServiceEvent_InfiniteTowerTeamTowerInfoCmd"
ServiceEvent.InfiniteTowerTeamTowerSummaryCmd = "ServiceEvent_InfiniteTowerTeamTowerSummaryCmd"
ServiceEvent.InfiniteTowerTeamTowerInviteCmd = "ServiceEvent_InfiniteTowerTeamTowerInviteCmd"
ServiceEvent.InfiniteTowerTeamTowerReplyCmd = "ServiceEvent_InfiniteTowerTeamTowerReplyCmd"
ServiceEvent.InfiniteTowerEnterTower = "ServiceEvent_InfiniteTowerEnterTower"
ServiceEvent.InfiniteTowerUserTowerInfoCmd = "ServiceEvent_InfiniteTowerUserTowerInfoCmd"
ServiceEvent.InfiniteTowerTowerLayerSyncTowerCmd = "ServiceEvent_InfiniteTowerTowerLayerSyncTowerCmd"
ServiceEvent.InfiniteTowerTowerInfoCmd = "ServiceEvent_InfiniteTowerTowerInfoCmd"
ServiceEvent.InfiniteTowerNewEverLayerTowerCmd = "ServiceEvent_InfiniteTowerNewEverLayerTowerCmd"
ServiceEvent.InfiniteTowerTowerLaunchCmd = "ServiceEvent_InfiniteTowerTowerLaunchCmd"
