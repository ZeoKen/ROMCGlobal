ServiceMiniGameCmdAutoProxy = class("ServiceMiniGameCmdAutoProxy", ServiceProxy)
ServiceMiniGameCmdAutoProxy.Instance = nil
ServiceMiniGameCmdAutoProxy.NAME = "ServiceMiniGameCmdAutoProxy"

function ServiceMiniGameCmdAutoProxy:ctor(proxyName)
  if ServiceMiniGameCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMiniGameCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMiniGameCmdAutoProxy.Instance = self
  end
end

function ServiceMiniGameCmdAutoProxy:Init()
end

function ServiceMiniGameCmdAutoProxy:onRegister()
  self:Listen(223, 1, function(data)
    self:RecvMiniGameNtfMonsterShot(data)
  end)
  self:Listen(223, 2, function(data)
    self:RecvMiniGameMonsterShotAction(data)
  end)
  self:Listen(223, 9, function(data)
    self:RecvMiniGameNtfMonsterAnswer(data)
  end)
  self:Listen(223, 10, function(data)
    self:RecvMiniGameSubmitMonsterAnswer(data)
  end)
  self:Listen(223, 13, function(data)
    self:RecvMiniGameAction(data)
  end)
  self:Listen(223, 14, function(data)
    self:RecvMiniGameNextRound(data)
  end)
  self:Listen(223, 11, function(data)
    self:RecvMiniGameUnlockList(data)
  end)
  self:Listen(223, 15, function(data)
    self:RecvMiniGameNtfGameOverCmd(data)
  end)
  self:Listen(223, 16, function(data)
    self:RecvMiniGameReqOver(data)
  end)
  self:Listen(223, 17, function(data)
    self:RecvMiniGameUseAssist(data)
  end)
  self:Listen(223, 18, function(data)
    self:RecvMiniGameNtfRoundOver(data)
  end)
  self:Listen(223, 19, function(data)
    self:RecvMiniGameQueryRank(data)
  end)
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameNtfMonsterShot(countdown, requires, misstimerest, totalrounds, curround, useplus)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameNtfMonsterShot()
    if countdown ~= nil then
      msg.countdown = countdown
    end
    if requires ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.requires == nil then
        msg.requires = {}
      end
      for i = 1, #requires do
        table.insert(msg.requires, requires[i])
      end
    end
    if misstimerest ~= nil then
      msg.misstimerest = misstimerest
    end
    if totalrounds ~= nil then
      msg.totalrounds = totalrounds
    end
    if curround ~= nil then
      msg.curround = curround
    end
    if useplus ~= nil then
      msg.useplus = useplus
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameNtfMonsterShot.id
    local msgParam = {}
    if countdown ~= nil then
      msgParam.countdown = countdown
    end
    if requires ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.requires == nil then
        msgParam.requires = {}
      end
      for i = 1, #requires do
        table.insert(msgParam.requires, requires[i])
      end
    end
    if misstimerest ~= nil then
      msgParam.misstimerest = misstimerest
    end
    if totalrounds ~= nil then
      msgParam.totalrounds = totalrounds
    end
    if curround ~= nil then
      msgParam.curround = curround
    end
    if useplus ~= nil then
      msgParam.useplus = useplus
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameMonsterShotAction(clientjudgesuc, errcode)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameMonsterShotAction()
    if clientjudgesuc ~= nil then
      msg.clientjudgesuc = clientjudgesuc
    end
    if errcode ~= nil then
      msg.errcode = errcode
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameMonsterShotAction.id
    local msgParam = {}
    if clientjudgesuc ~= nil then
      msgParam.clientjudgesuc = clientjudgesuc
    end
    if errcode ~= nil then
      msgParam.errcode = errcode
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameNtfMonsterAnswer(countdown, linksymbol, questparts, lastreplystatus)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameNtfMonsterAnswer()
    if countdown ~= nil then
      msg.countdown = countdown
    end
    if linksymbol ~= nil then
      msg.linksymbol = linksymbol
    end
    if questparts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.questparts == nil then
        msg.questparts = {}
      end
      for i = 1, #questparts do
        table.insert(msg.questparts, questparts[i])
      end
    end
    if lastreplystatus ~= nil then
      msg.lastreplystatus = lastreplystatus
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameNtfMonsterAnswer.id
    local msgParam = {}
    if countdown ~= nil then
      msgParam.countdown = countdown
    end
    if linksymbol ~= nil then
      msgParam.linksymbol = linksymbol
    end
    if questparts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.questparts == nil then
        msgParam.questparts = {}
      end
      for i = 1, #questparts do
        table.insert(msgParam.questparts, questparts[i])
      end
    end
    if lastreplystatus ~= nil then
      msgParam.lastreplystatus = lastreplystatus
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameSubmitMonsterAnswer(answer)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameSubmitMonsterAnswer()
    if answer ~= nil then
      msg.answer = answer
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameSubmitMonsterAnswer.id
    local msgParam = {}
    if answer ~= nil then
      msgParam.answer = answer
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameAction(mode, gametype, difficulty, errcode, endcardpair, addseconds, minusseconds, endtime, cardfailforce, roundendflag)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameAction()
    if mode ~= nil then
      msg.mode = mode
    end
    if gametype ~= nil then
      msg.gametype = gametype
    end
    if difficulty ~= nil then
      msg.difficulty = difficulty
    end
    if errcode ~= nil then
      msg.errcode = errcode
    end
    if endcardpair ~= nil then
      msg.endcardpair = endcardpair
    end
    if addseconds ~= nil then
      msg.addseconds = addseconds
    end
    if minusseconds ~= nil then
      msg.minusseconds = minusseconds
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if cardfailforce ~= nil then
      msg.cardfailforce = cardfailforce
    end
    if roundendflag ~= nil then
      msg.roundendflag = roundendflag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameAction.id
    local msgParam = {}
    if mode ~= nil then
      msgParam.mode = mode
    end
    if gametype ~= nil then
      msgParam.gametype = gametype
    end
    if difficulty ~= nil then
      msgParam.difficulty = difficulty
    end
    if errcode ~= nil then
      msgParam.errcode = errcode
    end
    if endcardpair ~= nil then
      msgParam.endcardpair = endcardpair
    end
    if addseconds ~= nil then
      msgParam.addseconds = addseconds
    end
    if minusseconds ~= nil then
      msgParam.minusseconds = minusseconds
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if cardfailforce ~= nil then
      msgParam.cardfailforce = cardfailforce
    end
    if roundendflag ~= nil then
      msgParam.roundendflag = roundendflag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameNextRound(gametype, assistlist, endtime, carduseflag)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameNextRound()
    if gametype ~= nil then
      msg.gametype = gametype
    end
    if assistlist ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.assistlist == nil then
        msg.assistlist = {}
      end
      for i = 1, #assistlist do
        table.insert(msg.assistlist, assistlist[i])
      end
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if carduseflag ~= nil then
      msg.carduseflag = carduseflag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameNextRound.id
    local msgParam = {}
    if gametype ~= nil then
      msgParam.gametype = gametype
    end
    if assistlist ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.assistlist == nil then
        msgParam.assistlist = {}
      end
      for i = 1, #assistlist do
        table.insert(msgParam.assistlist, assistlist[i])
      end
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if carduseflag ~= nil then
      msgParam.carduseflag = carduseflag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameUnlockList(list)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameUnlockList()
    if list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      for i = 1, #list do
        table.insert(msg.list, list[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameUnlockList.id
    local msgParam = {}
    if list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      for i = 1, #list do
        table.insert(msgParam.list, list[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameNtfGameOverCmd(type, result)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameNtfGameOverCmd()
    if type ~= nil then
      msg.type = type
    end
    if result ~= nil then
      msg.result = result
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameNtfGameOverCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if result ~= nil then
      msgParam.result = result
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameReqOver(type)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameReqOver()
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameReqOver.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameUseAssist(type, assisttype)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameUseAssist()
    if type ~= nil then
      msg.type = type
    end
    if assisttype ~= nil then
      msg.assisttype = assisttype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameUseAssist.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if assisttype ~= nil then
      msgParam.assisttype = assisttype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameNtfRoundOver(type, answer, lastreplystatus)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameNtfRoundOver()
    if type ~= nil then
      msg.type = type
    end
    if answer ~= nil then
      msg.answer = answer
    end
    if lastreplystatus ~= nil then
      msg.lastreplystatus = lastreplystatus
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameNtfRoundOver.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if answer ~= nil then
      msgParam.answer = answer
    end
    if lastreplystatus ~= nil then
      msgParam.lastreplystatus = lastreplystatus
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:CallMiniGameQueryRank(type, ranks)
  if not NetConfig.PBC then
    local msg = MiniGameCmd_pb.MiniGameQueryRank()
    if type ~= nil then
      msg.type = type
    end
    if ranks ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ranks == nil then
        msg.ranks = {}
      end
      for i = 1, #ranks do
        table.insert(msg.ranks, ranks[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MiniGameQueryRank.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if ranks ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ranks == nil then
        msgParam.ranks = {}
      end
      for i = 1, #ranks do
        table.insert(msgParam.ranks, ranks[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameNtfMonsterShot(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfMonsterShot, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameMonsterShotAction(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameMonsterShotAction, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameNtfMonsterAnswer(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfMonsterAnswer, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameSubmitMonsterAnswer(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameSubmitMonsterAnswer, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameAction(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameAction, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameNextRound(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNextRound, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameUnlockList(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameUnlockList, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameNtfGameOverCmd(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfGameOverCmd, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameReqOver(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameReqOver, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameUseAssist(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameUseAssist, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameNtfRoundOver(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfRoundOver, data)
end

function ServiceMiniGameCmdAutoProxy:RecvMiniGameQueryRank(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameQueryRank, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.MiniGameCmdMiniGameNtfMonsterShot = "ServiceEvent_MiniGameCmdMiniGameNtfMonsterShot"
ServiceEvent.MiniGameCmdMiniGameMonsterShotAction = "ServiceEvent_MiniGameCmdMiniGameMonsterShotAction"
ServiceEvent.MiniGameCmdMiniGameNtfMonsterAnswer = "ServiceEvent_MiniGameCmdMiniGameNtfMonsterAnswer"
ServiceEvent.MiniGameCmdMiniGameSubmitMonsterAnswer = "ServiceEvent_MiniGameCmdMiniGameSubmitMonsterAnswer"
ServiceEvent.MiniGameCmdMiniGameAction = "ServiceEvent_MiniGameCmdMiniGameAction"
ServiceEvent.MiniGameCmdMiniGameNextRound = "ServiceEvent_MiniGameCmdMiniGameNextRound"
ServiceEvent.MiniGameCmdMiniGameUnlockList = "ServiceEvent_MiniGameCmdMiniGameUnlockList"
ServiceEvent.MiniGameCmdMiniGameNtfGameOverCmd = "ServiceEvent_MiniGameCmdMiniGameNtfGameOverCmd"
ServiceEvent.MiniGameCmdMiniGameReqOver = "ServiceEvent_MiniGameCmdMiniGameReqOver"
ServiceEvent.MiniGameCmdMiniGameUseAssist = "ServiceEvent_MiniGameCmdMiniGameUseAssist"
ServiceEvent.MiniGameCmdMiniGameNtfRoundOver = "ServiceEvent_MiniGameCmdMiniGameNtfRoundOver"
ServiceEvent.MiniGameCmdMiniGameQueryRank = "ServiceEvent_MiniGameCmdMiniGameQueryRank"
