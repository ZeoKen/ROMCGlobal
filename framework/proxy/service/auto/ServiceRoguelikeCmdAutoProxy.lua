ServiceRoguelikeCmdAutoProxy = class("ServiceRoguelikeCmdAutoProxy", ServiceProxy)
ServiceRoguelikeCmdAutoProxy.Instance = nil
ServiceRoguelikeCmdAutoProxy.NAME = "ServiceRoguelikeCmdAutoProxy"

function ServiceRoguelikeCmdAutoProxy:ctor(proxyName)
  if ServiceRoguelikeCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRoguelikeCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRoguelikeCmdAutoProxy.Instance = self
  end
end

function ServiceRoguelikeCmdAutoProxy:Init()
end

function ServiceRoguelikeCmdAutoProxy:onRegister()
  self:Listen(71, 1, function(data)
    self:RecvRoguelikeInfoCmd(data)
  end)
  self:Listen(71, 2, function(data)
    self:RecvRoguelikeInviteCmd(data)
  end)
  self:Listen(71, 3, function(data)
    self:RecvRoguelikeReplyCmd(data)
  end)
  self:Listen(71, 4, function(data)
    self:RecvRoguelikeCreateCmd(data)
  end)
  self:Listen(71, 5, function(data)
    self:RecvRoguelikeEnterCmd(data)
  end)
  self:Listen(71, 6, function(data)
    self:RecvRoguelikeArchiveCmd(data)
  end)
  self:Listen(71, 7, function(data)
    self:RecvRoguelikeQueryArchiveDataCmd(data)
  end)
  self:Listen(71, 8, function(data)
    self:RecvRoguelikeRaidInfoCmd(data)
  end)
  self:Listen(71, 9, function(data)
    self:RecvRoguelikeRankInfoCmd(data)
  end)
  self:Listen(71, 10, function(data)
    self:RecvRoguelikeQueryBoardCmd(data)
  end)
  self:Listen(71, 11, function(data)
    self:RecvRoguelikeSubSceneCmd(data)
  end)
  self:Listen(71, 12, function(data)
    self:RecvRoguelikeScoreModelCmd(data)
  end)
  self:Listen(71, 13, function(data)
    self:RecvRoguelikeEventNpcCmd(data)
  end)
  self:Listen(71, 14, function(data)
    self:RecvRoguelikeShopCmd(data)
  end)
  self:Listen(71, 15, function(data)
    self:RecvRoguelikeShopDataCmd(data)
  end)
  self:Listen(71, 16, function(data)
    self:RecvRoguelikeUseItemCmd(data)
  end)
  self:Listen(71, 17, function(data)
    self:RecvRoguelikeRobotCmd(data)
  end)
  self:Listen(71, 18, function(data)
    self:RecvRoguelikeFightInfo(data)
  end)
  self:Listen(71, 19, function(data)
    self:RecvRoguelikeWeekReward(data)
  end)
  self:Listen(71, 20, function(data)
    self:RecvRoguelikeSettlement(data)
  end)
  self:Listen(71, 21, function(data)
    self:RecvRoguelikeGoRoomCmd(data)
  end)
  self:Listen(71, 22, function(data)
    self:RecvRogueChargeMagicBottle(data)
  end)
  self:Listen(71, 23, function(data)
    self:RecvRogueTarotOperateCmd(data)
  end)
  self:Listen(71, 24, function(data)
    self:RecvRogueTarotInfoCmd(data)
  end)
  self:Listen(71, 25, function(data)
    self:RecvTeamQueryRogueArchiveSCmd(data)
  end)
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeInfoCmd(layer)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeInfoCmd()
    if layer ~= nil then
      msg.layer = layer
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeInfoCmd.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeInviteCmd(open, layer, index, result, weekmodel, uniq_time, entranceid, lefttime)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeInviteCmd()
    if open ~= nil then
      msg.open = open
    end
    if layer ~= nil then
      msg.layer = layer
    end
    if index ~= nil then
      msg.index = index
    end
    if result ~= nil then
      msg.result = result
    end
    if weekmodel ~= nil then
      msg.weekmodel = weekmodel
    end
    if uniq_time ~= nil then
      msg.uniq_time = uniq_time
    end
    if entranceid ~= nil then
      msg.entranceid = entranceid
    end
    if lefttime ~= nil then
      msg.lefttime = lefttime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeInviteCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    if layer ~= nil then
      msgParam.layer = layer
    end
    if index ~= nil then
      msgParam.index = index
    end
    if result ~= nil then
      msgParam.result = result
    end
    if weekmodel ~= nil then
      msgParam.weekmodel = weekmodel
    end
    if uniq_time ~= nil then
      msgParam.uniq_time = uniq_time
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

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeReplyCmd(reply, charid)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeReplyCmd()
    if reply ~= nil then
      msg.reply = reply
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeReplyCmd.id
    local msgParam = {}
    if reply ~= nil then
      msgParam.reply = reply
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeCreateCmd(layer, userid, index)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeCreateCmd()
    if layer ~= nil then
      msg.layer = layer
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeCreateCmd.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeEnterCmd(layer, userid, zoneid, index, weekmodel, mem_archive)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeEnterCmd()
    if layer ~= nil then
      msg.layer = layer
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if index ~= nil then
      msg.index = index
    end
    if weekmodel ~= nil then
      msg.weekmodel = weekmodel
    end
    if mem_archive ~= nil and mem_archive.layer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.layer = mem_archive.layer
    end
    if mem_archive ~= nil and mem_archive.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.time = mem_archive.time
    end
    if mem_archive ~= nil and mem_archive.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.score = mem_archive.score
    end
    if mem_archive ~= nil and mem_archive.relive ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.relive = mem_archive.relive
    end
    if mem_archive ~= nil and mem_archive.items ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.items == nil then
        msg.mem_archive.items = {}
      end
      for i = 1, #mem_archive.items do
        table.insert(msg.mem_archive.items, mem_archive.items[i])
      end
    end
    if mem_archive ~= nil and mem_archive.users ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.users == nil then
        msg.mem_archive.users = {}
      end
      for i = 1, #mem_archive.users do
        table.insert(msg.mem_archive.users, mem_archive.users[i])
      end
    end
    if mem_archive ~= nil and mem_archive.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.index = mem_archive.index
    end
    if mem_archive ~= nil and mem_archive.fightinfo ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.fightinfo == nil then
        msg.mem_archive.fightinfo = {}
      end
      for i = 1, #mem_archive.fightinfo do
        table.insert(msg.mem_archive.fightinfo, mem_archive.fightinfo[i])
      end
    end
    if mem_archive ~= nil and mem_archive.dienum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.dienum = mem_archive.dienum
    end
    if mem_archive ~= nil and mem_archive.eventnpc ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.eventnpc = mem_archive.eventnpc
    end
    if mem_archive ~= nil and mem_archive.passroom ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.passroom == nil then
        msg.mem_archive.passroom = {}
      end
      for i = 1, #mem_archive.passroom do
        table.insert(msg.mem_archive.passroom, mem_archive.passroom[i])
      end
    end
    if mem_archive ~= nil and mem_archive.origintime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.origintime = mem_archive.origintime
    end
    if mem_archive ~= nil and mem_archive.battletime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.battletime = mem_archive.battletime
    end
    if mem_archive ~= nil and mem_archive.prebattletime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.prebattletime = mem_archive.prebattletime
    end
    if mem_archive ~= nil and mem_archive.buffs ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.buffs == nil then
        msg.mem_archive.buffs = {}
      end
      for i = 1, #mem_archive.buffs do
        table.insert(msg.mem_archive.buffs, mem_archive.buffs[i])
      end
    end
    if mem_archive ~= nil and mem_archive.uniq_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.uniq_time = mem_archive.uniq_time
    end
    if mem_archive ~= nil and mem_archive.modify_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      msg.mem_archive.modify_time = mem_archive.modify_time
    end
    if mem_archive.tarot ~= nil and mem_archive.tarot.progress ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.tarot == nil then
        msg.mem_archive.tarot = {}
      end
      msg.mem_archive.tarot.progress = mem_archive.tarot.progress
    end
    if mem_archive ~= nil and mem_archive.tarot.all_tarots ~= nil then
      if msg.mem_archive.tarot == nil then
        msg.mem_archive.tarot = {}
      end
      if msg.mem_archive.tarot.all_tarots == nil then
        msg.mem_archive.tarot.all_tarots = {}
      end
      for i = 1, #mem_archive.tarot.all_tarots do
        table.insert(msg.mem_archive.tarot.all_tarots, mem_archive.tarot.all_tarots[i])
      end
    end
    if mem_archive ~= nil and mem_archive.tarot.unlock_tarots ~= nil then
      if msg.mem_archive.tarot == nil then
        msg.mem_archive.tarot = {}
      end
      if msg.mem_archive.tarot.unlock_tarots == nil then
        msg.mem_archive.tarot.unlock_tarots = {}
      end
      for i = 1, #mem_archive.tarot.unlock_tarots do
        table.insert(msg.mem_archive.tarot.unlock_tarots, mem_archive.tarot.unlock_tarots[i])
      end
    end
    if mem_archive ~= nil and mem_archive.shopitems ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.shopitems == nil then
        msg.mem_archive.shopitems = {}
      end
      for i = 1, #mem_archive.shopitems do
        table.insert(msg.mem_archive.shopitems, mem_archive.shopitems[i])
      end
    end
    if mem_archive ~= nil and mem_archive.solditems ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.solditems == nil then
        msg.mem_archive.solditems = {}
      end
      for i = 1, #mem_archive.solditems do
        table.insert(msg.mem_archive.solditems, mem_archive.solditems[i])
      end
    end
    if mem_archive ~= nil and mem_archive.robots ~= nil then
      if msg.mem_archive == nil then
        msg.mem_archive = {}
      end
      if msg.mem_archive.robots == nil then
        msg.mem_archive.robots = {}
      end
      for i = 1, #mem_archive.robots do
        table.insert(msg.mem_archive.robots, mem_archive.robots[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeEnterCmd.id
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
    if index ~= nil then
      msgParam.index = index
    end
    if weekmodel ~= nil then
      msgParam.weekmodel = weekmodel
    end
    if mem_archive ~= nil and mem_archive.layer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.layer = mem_archive.layer
    end
    if mem_archive ~= nil and mem_archive.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.time = mem_archive.time
    end
    if mem_archive ~= nil and mem_archive.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.score = mem_archive.score
    end
    if mem_archive ~= nil and mem_archive.relive ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.relive = mem_archive.relive
    end
    if mem_archive ~= nil and mem_archive.items ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.items == nil then
        msgParam.mem_archive.items = {}
      end
      for i = 1, #mem_archive.items do
        table.insert(msgParam.mem_archive.items, mem_archive.items[i])
      end
    end
    if mem_archive ~= nil and mem_archive.users ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.users == nil then
        msgParam.mem_archive.users = {}
      end
      for i = 1, #mem_archive.users do
        table.insert(msgParam.mem_archive.users, mem_archive.users[i])
      end
    end
    if mem_archive ~= nil and mem_archive.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.index = mem_archive.index
    end
    if mem_archive ~= nil and mem_archive.fightinfo ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.fightinfo == nil then
        msgParam.mem_archive.fightinfo = {}
      end
      for i = 1, #mem_archive.fightinfo do
        table.insert(msgParam.mem_archive.fightinfo, mem_archive.fightinfo[i])
      end
    end
    if mem_archive ~= nil and mem_archive.dienum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.dienum = mem_archive.dienum
    end
    if mem_archive ~= nil and mem_archive.eventnpc ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.eventnpc = mem_archive.eventnpc
    end
    if mem_archive ~= nil and mem_archive.passroom ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.passroom == nil then
        msgParam.mem_archive.passroom = {}
      end
      for i = 1, #mem_archive.passroom do
        table.insert(msgParam.mem_archive.passroom, mem_archive.passroom[i])
      end
    end
    if mem_archive ~= nil and mem_archive.origintime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.origintime = mem_archive.origintime
    end
    if mem_archive ~= nil and mem_archive.battletime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.battletime = mem_archive.battletime
    end
    if mem_archive ~= nil and mem_archive.prebattletime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.prebattletime = mem_archive.prebattletime
    end
    if mem_archive ~= nil and mem_archive.buffs ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.buffs == nil then
        msgParam.mem_archive.buffs = {}
      end
      for i = 1, #mem_archive.buffs do
        table.insert(msgParam.mem_archive.buffs, mem_archive.buffs[i])
      end
    end
    if mem_archive ~= nil and mem_archive.uniq_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.uniq_time = mem_archive.uniq_time
    end
    if mem_archive ~= nil and mem_archive.modify_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      msgParam.mem_archive.modify_time = mem_archive.modify_time
    end
    if mem_archive.tarot ~= nil and mem_archive.tarot.progress ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.tarot == nil then
        msgParam.mem_archive.tarot = {}
      end
      msgParam.mem_archive.tarot.progress = mem_archive.tarot.progress
    end
    if mem_archive ~= nil and mem_archive.tarot.all_tarots ~= nil then
      if msgParam.mem_archive.tarot == nil then
        msgParam.mem_archive.tarot = {}
      end
      if msgParam.mem_archive.tarot.all_tarots == nil then
        msgParam.mem_archive.tarot.all_tarots = {}
      end
      for i = 1, #mem_archive.tarot.all_tarots do
        table.insert(msgParam.mem_archive.tarot.all_tarots, mem_archive.tarot.all_tarots[i])
      end
    end
    if mem_archive ~= nil and mem_archive.tarot.unlock_tarots ~= nil then
      if msgParam.mem_archive.tarot == nil then
        msgParam.mem_archive.tarot = {}
      end
      if msgParam.mem_archive.tarot.unlock_tarots == nil then
        msgParam.mem_archive.tarot.unlock_tarots = {}
      end
      for i = 1, #mem_archive.tarot.unlock_tarots do
        table.insert(msgParam.mem_archive.tarot.unlock_tarots, mem_archive.tarot.unlock_tarots[i])
      end
    end
    if mem_archive ~= nil and mem_archive.shopitems ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.shopitems == nil then
        msgParam.mem_archive.shopitems = {}
      end
      for i = 1, #mem_archive.shopitems do
        table.insert(msgParam.mem_archive.shopitems, mem_archive.shopitems[i])
      end
    end
    if mem_archive ~= nil and mem_archive.solditems ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.solditems == nil then
        msgParam.mem_archive.solditems = {}
      end
      for i = 1, #mem_archive.solditems do
        table.insert(msgParam.mem_archive.solditems, mem_archive.solditems[i])
      end
    end
    if mem_archive ~= nil and mem_archive.robots ~= nil then
      if msgParam.mem_archive == nil then
        msgParam.mem_archive = {}
      end
      if msgParam.mem_archive.robots == nil then
        msgParam.mem_archive.robots = {}
      end
      for i = 1, #mem_archive.robots do
        table.insert(msgParam.mem_archive.robots, mem_archive.robots[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeArchiveCmd(opt, single, index, result)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeArchiveCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    if single ~= nil then
      msg.single = single
    end
    if index ~= nil then
      msg.index = index
    end
    if result ~= nil then
      msg.result = result
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeArchiveCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    if single ~= nil then
      msgParam.single = single
    end
    if index ~= nil then
      msgParam.index = index
    end
    if result ~= nil then
      msgParam.result = result
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeQueryArchiveDataCmd(datas)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeQueryArchiveDataCmd()
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
    local msgId = ProtoReqInfoList.RoguelikeQueryArchiveDataCmd.id
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

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeRaidInfoCmd(layer, time, unlockrooms, items, keynum, relive, score, visited_npcs, current_room, finishrooms, exitroom, bottle_charged)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeRaidInfoCmd()
    if layer ~= nil then
      msg.layer = layer
    end
    if time ~= nil then
      msg.time = time
    end
    if unlockrooms ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unlockrooms == nil then
        msg.unlockrooms = {}
      end
      for i = 1, #unlockrooms do
        table.insert(msg.unlockrooms, unlockrooms[i])
      end
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
    if keynum ~= nil then
      msg.keynum = keynum
    end
    if relive ~= nil then
      msg.relive = relive
    end
    if score ~= nil then
      msg.score = score
    end
    if visited_npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.visited_npcs == nil then
        msg.visited_npcs = {}
      end
      for i = 1, #visited_npcs do
        table.insert(msg.visited_npcs, visited_npcs[i])
      end
    end
    if current_room ~= nil then
      msg.current_room = current_room
    end
    if finishrooms ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.finishrooms == nil then
        msg.finishrooms = {}
      end
      for i = 1, #finishrooms do
        table.insert(msg.finishrooms, finishrooms[i])
      end
    end
    if exitroom ~= nil then
      msg.exitroom = exitroom
    end
    if bottle_charged ~= nil then
      msg.bottle_charged = bottle_charged
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeRaidInfoCmd.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    if time ~= nil then
      msgParam.time = time
    end
    if unlockrooms ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unlockrooms == nil then
        msgParam.unlockrooms = {}
      end
      for i = 1, #unlockrooms do
        table.insert(msgParam.unlockrooms, unlockrooms[i])
      end
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
    if keynum ~= nil then
      msgParam.keynum = keynum
    end
    if relive ~= nil then
      msgParam.relive = relive
    end
    if score ~= nil then
      msgParam.score = score
    end
    if visited_npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.visited_npcs == nil then
        msgParam.visited_npcs = {}
      end
      for i = 1, #visited_npcs do
        table.insert(msgParam.visited_npcs, visited_npcs[i])
      end
    end
    if current_room ~= nil then
      msgParam.current_room = current_room
    end
    if finishrooms ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.finishrooms == nil then
        msgParam.finishrooms = {}
      end
      for i = 1, #finishrooms do
        table.insert(msgParam.finishrooms, finishrooms[i])
      end
    end
    if exitroom ~= nil then
      msgParam.exitroom = exitroom
    end
    if bottle_charged ~= nil then
      msgParam.bottle_charged = bottle_charged
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeRankInfoCmd(multi, userdata, datas)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeRankInfoCmd()
    if multi ~= nil then
      msg.multi = multi
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
    if userdata ~= nil and userdata.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.profession = userdata.profession
    end
    if userdata ~= nil and userdata.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.score = userdata.score
    end
    if userdata ~= nil and userdata.layer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.layer = userdata.layer
    end
    if userdata ~= nil and userdata.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.time = userdata.time
    end
    if userdata ~= nil and userdata.rank ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.rank = userdata.rank
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
    if userdata ~= nil and userdata.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userdata == nil then
        msg.userdata = {}
      end
      msg.userdata.level = userdata.level
    end
    if userdata.portrait ~= nil and userdata.portrait.portrait ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.portrait = userdata.portrait.portrait
    end
    if userdata.portrait ~= nil and userdata.portrait.body ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.body = userdata.portrait.body
    end
    if userdata.portrait ~= nil and userdata.portrait.hair ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.hair = userdata.portrait.hair
    end
    if userdata.portrait ~= nil and userdata.portrait.haircolor ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.haircolor = userdata.portrait.haircolor
    end
    if userdata.portrait ~= nil and userdata.portrait.gender ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.gender = userdata.portrait.gender
    end
    if userdata.portrait ~= nil and userdata.portrait.head ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.head = userdata.portrait.head
    end
    if userdata.portrait ~= nil and userdata.portrait.face ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.face = userdata.portrait.face
    end
    if userdata.portrait ~= nil and userdata.portrait.mouth ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.mouth = userdata.portrait.mouth
    end
    if userdata.portrait ~= nil and userdata.portrait.eye ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.eye = userdata.portrait.eye
    end
    if userdata.portrait ~= nil and userdata.portrait.portrait_frame ~= nil then
      if msg.userdata == nil then
        msg.userdata = {}
      end
      if msg.userdata.portrait == nil then
        msg.userdata.portrait = {}
      end
      msg.userdata.portrait.portrait_frame = userdata.portrait.portrait_frame
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
    local msgId = ProtoReqInfoList.RoguelikeRankInfoCmd.id
    local msgParam = {}
    if multi ~= nil then
      msgParam.multi = multi
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
    if userdata ~= nil and userdata.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.profession = userdata.profession
    end
    if userdata ~= nil and userdata.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.score = userdata.score
    end
    if userdata ~= nil and userdata.layer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.layer = userdata.layer
    end
    if userdata ~= nil and userdata.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.time = userdata.time
    end
    if userdata ~= nil and userdata.rank ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.rank = userdata.rank
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
    if userdata ~= nil and userdata.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      msgParam.userdata.level = userdata.level
    end
    if userdata.portrait ~= nil and userdata.portrait.portrait ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.portrait = userdata.portrait.portrait
    end
    if userdata.portrait ~= nil and userdata.portrait.body ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.body = userdata.portrait.body
    end
    if userdata.portrait ~= nil and userdata.portrait.hair ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.hair = userdata.portrait.hair
    end
    if userdata.portrait ~= nil and userdata.portrait.haircolor ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.haircolor = userdata.portrait.haircolor
    end
    if userdata.portrait ~= nil and userdata.portrait.gender ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.gender = userdata.portrait.gender
    end
    if userdata.portrait ~= nil and userdata.portrait.head ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.head = userdata.portrait.head
    end
    if userdata.portrait ~= nil and userdata.portrait.face ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.face = userdata.portrait.face
    end
    if userdata.portrait ~= nil and userdata.portrait.mouth ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.mouth = userdata.portrait.mouth
    end
    if userdata.portrait ~= nil and userdata.portrait.eye ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.eye = userdata.portrait.eye
    end
    if userdata.portrait ~= nil and userdata.portrait.portrait_frame ~= nil then
      if msgParam.userdata == nil then
        msgParam.userdata = {}
      end
      if msgParam.userdata.portrait == nil then
        msgParam.userdata.portrait = {}
      end
      msgParam.userdata.portrait.portrait_frame = userdata.portrait.portrait_frame
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

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeQueryBoardCmd(multi, page)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeQueryBoardCmd()
    if multi ~= nil then
      msg.multi = multi
    end
    if page ~= nil then
      msg.page = page
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeQueryBoardCmd.id
    local msgParam = {}
    if multi ~= nil then
      msgParam.multi = multi
    end
    if page ~= nil then
      msgParam.page = page
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeSubSceneCmd(subScenes)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeSubSceneCmd()
    if subScenes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.subScenes == nil then
        msg.subScenes = {}
      end
      for i = 1, #subScenes do
        table.insert(msg.subScenes, subScenes[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeSubSceneCmd.id
    local msgParam = {}
    if subScenes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.subScenes == nil then
        msgParam.subScenes = {}
      end
      for i = 1, #subScenes do
        table.insert(msgParam.subScenes, subScenes[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeScoreModelCmd(scoremodel)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeScoreModelCmd()
    if scoremodel ~= nil then
      msg.scoremodel = scoremodel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeScoreModelCmd.id
    local msgParam = {}
    if scoremodel ~= nil then
      msgParam.scoremodel = scoremodel
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeEventNpcCmd(npcguid, opt)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeEventNpcCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if opt ~= nil then
      msg.opt = opt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeEventNpcCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if opt ~= nil then
      msgParam.opt = opt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeShopCmd(opt, value)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeShopCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    if value ~= nil then
      msg.value = value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeShopCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    if value ~= nil then
      msgParam.value = value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeShopDataCmd(items, shop_cnt)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeShopDataCmd()
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
    if shop_cnt ~= nil then
      msg.shop_cnt = shop_cnt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeShopDataCmd.id
    local msgParam = {}
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
    if shop_cnt ~= nil then
      msgParam.shop_cnt = shop_cnt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeUseItemCmd(itemid, count)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeUseItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeUseItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeRobotCmd()
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeRobotCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeRobotCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeFightInfo(layer, info)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeFightInfo()
    if layer ~= nil then
      msg.layer = layer
    end
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeFightInfo.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeWeekReward(layer, rewarded)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeWeekReward()
    if layer ~= nil then
      msg.layer = layer
    end
    if rewarded ~= nil then
      msg.rewarded = rewarded
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeWeekReward.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    if rewarded ~= nil then
      msgParam.rewarded = rewarded
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeSettlement(layer, score, costtime, dienum, eventnpc, userids, items, passroom, fight, passall)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeSettlement()
    if layer ~= nil then
      msg.layer = layer
    end
    if score ~= nil then
      msg.score = score
    end
    if costtime ~= nil then
      msg.costtime = costtime
    end
    if dienum ~= nil then
      msg.dienum = dienum
    end
    if eventnpc ~= nil then
      msg.eventnpc = eventnpc
    end
    if userids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userids == nil then
        msg.userids = {}
      end
      for i = 1, #userids do
        table.insert(msg.userids, userids[i])
      end
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
    if passroom ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.passroom == nil then
        msg.passroom = {}
      end
      for i = 1, #passroom do
        table.insert(msg.passroom, passroom[i])
      end
    end
    if fight ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fight == nil then
        msg.fight = {}
      end
      for i = 1, #fight do
        table.insert(msg.fight, fight[i])
      end
    end
    if passall ~= nil then
      msg.passall = passall
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeSettlement.id
    local msgParam = {}
    if layer ~= nil then
      msgParam.layer = layer
    end
    if score ~= nil then
      msgParam.score = score
    end
    if costtime ~= nil then
      msgParam.costtime = costtime
    end
    if dienum ~= nil then
      msgParam.dienum = dienum
    end
    if eventnpc ~= nil then
      msgParam.eventnpc = eventnpc
    end
    if userids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userids == nil then
        msgParam.userids = {}
      end
      for i = 1, #userids do
        table.insert(msgParam.userids, userids[i])
      end
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
    if passroom ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.passroom == nil then
        msgParam.passroom = {}
      end
      for i = 1, #passroom do
        table.insert(msgParam.passroom, passroom[i])
      end
    end
    if fight ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fight == nil then
        msgParam.fight = {}
      end
      for i = 1, #fight do
        table.insert(msgParam.fight, fight[i])
      end
    end
    if passall ~= nil then
      msgParam.passall = passall
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRoguelikeGoRoomCmd(roomindex)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RoguelikeGoRoomCmd()
    if roomindex ~= nil then
      msg.roomindex = roomindex
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RoguelikeGoRoomCmd.id
    local msgParam = {}
    if roomindex ~= nil then
      msgParam.roomindex = roomindex
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRogueChargeMagicBottle(npcguid)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RogueChargeMagicBottle()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RogueChargeMagicBottle.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRogueTarotOperateCmd(operate, index)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RogueTarotOperateCmd()
    if operate ~= nil then
      msg.operate = operate
    end
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RogueTarotOperateCmd.id
    local msgParam = {}
    if operate ~= nil then
      msgParam.operate = operate
    end
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallRogueTarotInfoCmd(progress, all_tarots, unlock_tarots)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.RogueTarotInfoCmd()
    if progress ~= nil then
      msg.progress = progress
    end
    if all_tarots ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.all_tarots == nil then
        msg.all_tarots = {}
      end
      for i = 1, #all_tarots do
        table.insert(msg.all_tarots, all_tarots[i])
      end
    end
    if unlock_tarots ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unlock_tarots == nil then
        msg.unlock_tarots = {}
      end
      for i = 1, #unlock_tarots do
        table.insert(msg.unlock_tarots, unlock_tarots[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RogueTarotInfoCmd.id
    local msgParam = {}
    if progress ~= nil then
      msgParam.progress = progress
    end
    if all_tarots ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.all_tarots == nil then
        msgParam.all_tarots = {}
      end
      for i = 1, #all_tarots do
        table.insert(msgParam.all_tarots, all_tarots[i])
      end
    end
    if unlock_tarots ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unlock_tarots == nil then
        msgParam.unlock_tarots = {}
      end
      for i = 1, #unlock_tarots do
        table.insert(msgParam.unlock_tarots, unlock_tarots[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:CallTeamQueryRogueArchiveSCmd(data)
  if not NetConfig.PBC then
    local msg = RoguelikeCmd_pb.TeamQueryRogueArchiveSCmd()
    if data ~= nil and data.layer ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.layer = data.layer
    end
    if data ~= nil and data.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.time = data.time
    end
    if data ~= nil and data.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.score = data.score
    end
    if data ~= nil and data.relive ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.relive = data.relive
    end
    if data ~= nil and data.items ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.items == nil then
        msg.data.items = {}
      end
      for i = 1, #data.items do
        table.insert(msg.data.items, data.items[i])
      end
    end
    if data ~= nil and data.users ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.users == nil then
        msg.data.users = {}
      end
      for i = 1, #data.users do
        table.insert(msg.data.users, data.users[i])
      end
    end
    if data ~= nil and data.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.index = data.index
    end
    if data ~= nil and data.fightinfo ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.fightinfo == nil then
        msg.data.fightinfo = {}
      end
      for i = 1, #data.fightinfo do
        table.insert(msg.data.fightinfo, data.fightinfo[i])
      end
    end
    if data ~= nil and data.dienum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.dienum = data.dienum
    end
    if data ~= nil and data.eventnpc ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.eventnpc = data.eventnpc
    end
    if data ~= nil and data.passroom ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.passroom == nil then
        msg.data.passroom = {}
      end
      for i = 1, #data.passroom do
        table.insert(msg.data.passroom, data.passroom[i])
      end
    end
    if data ~= nil and data.origintime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.origintime = data.origintime
    end
    if data ~= nil and data.battletime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.battletime = data.battletime
    end
    if data ~= nil and data.prebattletime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.prebattletime = data.prebattletime
    end
    if data ~= nil and data.buffs ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.buffs == nil then
        msg.data.buffs = {}
      end
      for i = 1, #data.buffs do
        table.insert(msg.data.buffs, data.buffs[i])
      end
    end
    if data ~= nil and data.uniq_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.uniq_time = data.uniq_time
    end
    if data ~= nil and data.modify_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.modify_time = data.modify_time
    end
    if data.tarot ~= nil and data.tarot.progress ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.tarot == nil then
        msg.data.tarot = {}
      end
      msg.data.tarot.progress = data.tarot.progress
    end
    if data ~= nil and data.tarot.all_tarots ~= nil then
      if msg.data.tarot == nil then
        msg.data.tarot = {}
      end
      if msg.data.tarot.all_tarots == nil then
        msg.data.tarot.all_tarots = {}
      end
      for i = 1, #data.tarot.all_tarots do
        table.insert(msg.data.tarot.all_tarots, data.tarot.all_tarots[i])
      end
    end
    if data ~= nil and data.tarot.unlock_tarots ~= nil then
      if msg.data.tarot == nil then
        msg.data.tarot = {}
      end
      if msg.data.tarot.unlock_tarots == nil then
        msg.data.tarot.unlock_tarots = {}
      end
      for i = 1, #data.tarot.unlock_tarots do
        table.insert(msg.data.tarot.unlock_tarots, data.tarot.unlock_tarots[i])
      end
    end
    if data ~= nil and data.shopitems ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.shopitems == nil then
        msg.data.shopitems = {}
      end
      for i = 1, #data.shopitems do
        table.insert(msg.data.shopitems, data.shopitems[i])
      end
    end
    if data ~= nil and data.solditems ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.solditems == nil then
        msg.data.solditems = {}
      end
      for i = 1, #data.solditems do
        table.insert(msg.data.solditems, data.solditems[i])
      end
    end
    if data ~= nil and data.robots ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.robots == nil then
        msg.data.robots = {}
      end
      for i = 1, #data.robots do
        table.insert(msg.data.robots, data.robots[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamQueryRogueArchiveSCmd.id
    local msgParam = {}
    if data ~= nil and data.layer ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.layer = data.layer
    end
    if data ~= nil and data.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.time = data.time
    end
    if data ~= nil and data.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.score = data.score
    end
    if data ~= nil and data.relive ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.relive = data.relive
    end
    if data ~= nil and data.items ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.items == nil then
        msgParam.data.items = {}
      end
      for i = 1, #data.items do
        table.insert(msgParam.data.items, data.items[i])
      end
    end
    if data ~= nil and data.users ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.users == nil then
        msgParam.data.users = {}
      end
      for i = 1, #data.users do
        table.insert(msgParam.data.users, data.users[i])
      end
    end
    if data ~= nil and data.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.index = data.index
    end
    if data ~= nil and data.fightinfo ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.fightinfo == nil then
        msgParam.data.fightinfo = {}
      end
      for i = 1, #data.fightinfo do
        table.insert(msgParam.data.fightinfo, data.fightinfo[i])
      end
    end
    if data ~= nil and data.dienum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.dienum = data.dienum
    end
    if data ~= nil and data.eventnpc ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.eventnpc = data.eventnpc
    end
    if data ~= nil and data.passroom ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.passroom == nil then
        msgParam.data.passroom = {}
      end
      for i = 1, #data.passroom do
        table.insert(msgParam.data.passroom, data.passroom[i])
      end
    end
    if data ~= nil and data.origintime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.origintime = data.origintime
    end
    if data ~= nil and data.battletime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.battletime = data.battletime
    end
    if data ~= nil and data.prebattletime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.prebattletime = data.prebattletime
    end
    if data ~= nil and data.buffs ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.buffs == nil then
        msgParam.data.buffs = {}
      end
      for i = 1, #data.buffs do
        table.insert(msgParam.data.buffs, data.buffs[i])
      end
    end
    if data ~= nil and data.uniq_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.uniq_time = data.uniq_time
    end
    if data ~= nil and data.modify_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.modify_time = data.modify_time
    end
    if data.tarot ~= nil and data.tarot.progress ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.tarot == nil then
        msgParam.data.tarot = {}
      end
      msgParam.data.tarot.progress = data.tarot.progress
    end
    if data ~= nil and data.tarot.all_tarots ~= nil then
      if msgParam.data.tarot == nil then
        msgParam.data.tarot = {}
      end
      if msgParam.data.tarot.all_tarots == nil then
        msgParam.data.tarot.all_tarots = {}
      end
      for i = 1, #data.tarot.all_tarots do
        table.insert(msgParam.data.tarot.all_tarots, data.tarot.all_tarots[i])
      end
    end
    if data ~= nil and data.tarot.unlock_tarots ~= nil then
      if msgParam.data.tarot == nil then
        msgParam.data.tarot = {}
      end
      if msgParam.data.tarot.unlock_tarots == nil then
        msgParam.data.tarot.unlock_tarots = {}
      end
      for i = 1, #data.tarot.unlock_tarots do
        table.insert(msgParam.data.tarot.unlock_tarots, data.tarot.unlock_tarots[i])
      end
    end
    if data ~= nil and data.shopitems ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.shopitems == nil then
        msgParam.data.shopitems = {}
      end
      for i = 1, #data.shopitems do
        table.insert(msgParam.data.shopitems, data.shopitems[i])
      end
    end
    if data ~= nil and data.solditems ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.solditems == nil then
        msgParam.data.solditems = {}
      end
      for i = 1, #data.solditems do
        table.insert(msgParam.data.solditems, data.solditems[i])
      end
    end
    if data ~= nil and data.robots ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.robots == nil then
        msgParam.data.robots = {}
      end
      for i = 1, #data.robots do
        table.insert(msgParam.data.robots, data.robots[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeInfoCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeInfoCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeInviteCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeInviteCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeReplyCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeReplyCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeCreateCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeCreateCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeEnterCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeEnterCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeArchiveCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeArchiveCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeQueryArchiveDataCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeQueryArchiveDataCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeRaidInfoCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeRankInfoCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeRankInfoCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeQueryBoardCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeQueryBoardCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeSubSceneCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeSubSceneCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeScoreModelCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeScoreModelCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeEventNpcCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeEventNpcCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeShopCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeShopCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeShopDataCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeShopDataCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeUseItemCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeUseItemCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeRobotCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeRobotCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeFightInfo(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeFightInfo, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeWeekReward(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeWeekReward, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeSettlement(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeSettlement, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRoguelikeGoRoomCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeGoRoomCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRogueChargeMagicBottle(data)
  self:Notify(ServiceEvent.RoguelikeCmdRogueChargeMagicBottle, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRogueTarotOperateCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRogueTarotOperateCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvRogueTarotInfoCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdRogueTarotInfoCmd, data)
end

function ServiceRoguelikeCmdAutoProxy:RecvTeamQueryRogueArchiveSCmd(data)
  self:Notify(ServiceEvent.RoguelikeCmdTeamQueryRogueArchiveSCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.RoguelikeCmdRoguelikeInfoCmd = "ServiceEvent_RoguelikeCmdRoguelikeInfoCmd"
ServiceEvent.RoguelikeCmdRoguelikeInviteCmd = "ServiceEvent_RoguelikeCmdRoguelikeInviteCmd"
ServiceEvent.RoguelikeCmdRoguelikeReplyCmd = "ServiceEvent_RoguelikeCmdRoguelikeReplyCmd"
ServiceEvent.RoguelikeCmdRoguelikeCreateCmd = "ServiceEvent_RoguelikeCmdRoguelikeCreateCmd"
ServiceEvent.RoguelikeCmdRoguelikeEnterCmd = "ServiceEvent_RoguelikeCmdRoguelikeEnterCmd"
ServiceEvent.RoguelikeCmdRoguelikeArchiveCmd = "ServiceEvent_RoguelikeCmdRoguelikeArchiveCmd"
ServiceEvent.RoguelikeCmdRoguelikeQueryArchiveDataCmd = "ServiceEvent_RoguelikeCmdRoguelikeQueryArchiveDataCmd"
ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd = "ServiceEvent_RoguelikeCmdRoguelikeRaidInfoCmd"
ServiceEvent.RoguelikeCmdRoguelikeRankInfoCmd = "ServiceEvent_RoguelikeCmdRoguelikeRankInfoCmd"
ServiceEvent.RoguelikeCmdRoguelikeQueryBoardCmd = "ServiceEvent_RoguelikeCmdRoguelikeQueryBoardCmd"
ServiceEvent.RoguelikeCmdRoguelikeSubSceneCmd = "ServiceEvent_RoguelikeCmdRoguelikeSubSceneCmd"
ServiceEvent.RoguelikeCmdRoguelikeScoreModelCmd = "ServiceEvent_RoguelikeCmdRoguelikeScoreModelCmd"
ServiceEvent.RoguelikeCmdRoguelikeEventNpcCmd = "ServiceEvent_RoguelikeCmdRoguelikeEventNpcCmd"
ServiceEvent.RoguelikeCmdRoguelikeShopCmd = "ServiceEvent_RoguelikeCmdRoguelikeShopCmd"
ServiceEvent.RoguelikeCmdRoguelikeShopDataCmd = "ServiceEvent_RoguelikeCmdRoguelikeShopDataCmd"
ServiceEvent.RoguelikeCmdRoguelikeUseItemCmd = "ServiceEvent_RoguelikeCmdRoguelikeUseItemCmd"
ServiceEvent.RoguelikeCmdRoguelikeRobotCmd = "ServiceEvent_RoguelikeCmdRoguelikeRobotCmd"
ServiceEvent.RoguelikeCmdRoguelikeFightInfo = "ServiceEvent_RoguelikeCmdRoguelikeFightInfo"
ServiceEvent.RoguelikeCmdRoguelikeWeekReward = "ServiceEvent_RoguelikeCmdRoguelikeWeekReward"
ServiceEvent.RoguelikeCmdRoguelikeSettlement = "ServiceEvent_RoguelikeCmdRoguelikeSettlement"
ServiceEvent.RoguelikeCmdRoguelikeGoRoomCmd = "ServiceEvent_RoguelikeCmdRoguelikeGoRoomCmd"
ServiceEvent.RoguelikeCmdRogueChargeMagicBottle = "ServiceEvent_RoguelikeCmdRogueChargeMagicBottle"
ServiceEvent.RoguelikeCmdRogueTarotOperateCmd = "ServiceEvent_RoguelikeCmdRogueTarotOperateCmd"
ServiceEvent.RoguelikeCmdRogueTarotInfoCmd = "ServiceEvent_RoguelikeCmdRogueTarotInfoCmd"
ServiceEvent.RoguelikeCmdTeamQueryRogueArchiveSCmd = "ServiceEvent_RoguelikeCmdTeamQueryRogueArchiveSCmd"
