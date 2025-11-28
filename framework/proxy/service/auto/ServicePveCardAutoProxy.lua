ServicePveCardAutoProxy = class("ServicePveCardAutoProxy", ServiceProxy)
ServicePveCardAutoProxy.Instance = nil
ServicePveCardAutoProxy.NAME = "ServicePveCardAutoProxy"

function ServicePveCardAutoProxy:ctor(proxyName)
  if ServicePveCardAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServicePveCardAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePveCardAutoProxy.Instance = self
  end
end

function ServicePveCardAutoProxy:Init()
end

function ServicePveCardAutoProxy:onRegister()
  self:Listen(66, 1, function(data)
    self:RecvInvitePveCardCmd(data)
  end)
  self:Listen(66, 2, function(data)
    self:RecvReplyPveCardCmd(data)
  end)
  self:Listen(66, 3, function(data)
    self:RecvEnterPveCardCmd(data)
  end)
  self:Listen(66, 4, function(data)
    self:RecvQueryCardInfoCmd(data)
  end)
  self:Listen(66, 5, function(data)
    self:RecvSelectPveCardCmd(data)
  end)
  self:Listen(66, 6, function(data)
    self:RecvSyncProcessPveCardCmd(data)
  end)
  self:Listen(66, 7, function(data)
    self:RecvUpdateProcessPveCardCmd(data)
  end)
  self:Listen(66, 8, function(data)
    self:RecvBeginFirePveCardCmd(data)
  end)
  self:Listen(66, 9, function(data)
    self:RecvFinishPlayCardCmd(data)
  end)
  self:Listen(66, 10, function(data)
    self:RecvPlayPveCardCmd(data)
  end)
  self:Listen(66, 11, function(data)
    self:RecvGetPveCardRewardCmd(data)
  end)
end

function ServicePveCardAutoProxy:CallInvitePveCardCmd(configid, iscancel, entranceid, lefttime)
  if not NetConfig.PBC then
    local msg = PveCard_pb.InvitePveCardCmd()
    if configid ~= nil then
      msg.configid = configid
    end
    if iscancel ~= nil then
      msg.iscancel = iscancel
    end
    if entranceid ~= nil then
      msg.entranceid = entranceid
    end
    if lefttime ~= nil then
      msg.lefttime = lefttime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InvitePveCardCmd.id
    local msgParam = {}
    if configid ~= nil then
      msgParam.configid = configid
    end
    if iscancel ~= nil then
      msgParam.iscancel = iscancel
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

function ServicePveCardAutoProxy:CallReplyPveCardCmd(agree, charid)
  if not NetConfig.PBC then
    local msg = PveCard_pb.ReplyPveCardCmd()
    if agree ~= nil then
      msg.agree = agree
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyPveCardCmd.id
    local msgParam = {}
    if agree ~= nil then
      msgParam.agree = agree
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallEnterPveCardCmd(configid, zoneid)
  if not NetConfig.PBC then
    local msg = PveCard_pb.EnterPveCardCmd()
    if configid ~= nil then
      msg.configid = configid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterPveCardCmd.id
    local msgParam = {}
    if configid ~= nil then
      msgParam.configid = configid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallQueryCardInfoCmd(cards)
  if not NetConfig.PBC then
    local msg = PveCard_pb.QueryCardInfoCmd()
    if cards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cards == nil then
        msg.cards = {}
      end
      for i = 1, #cards do
        table.insert(msg.cards, cards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryCardInfoCmd.id
    local msgParam = {}
    if cards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cards == nil then
        msgParam.cards = {}
      end
      for i = 1, #cards do
        table.insert(msgParam.cards, cards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallSelectPveCardCmd(index)
  if not NetConfig.PBC then
    local msg = PveCard_pb.SelectPveCardCmd()
    if msg == nil then
      msg = {}
    end
    msg.index = index
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectPveCardCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.index = index
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallSyncProcessPveCardCmd(card, process, totalprocess)
  if not NetConfig.PBC then
    local msg = PveCard_pb.SyncProcessPveCardCmd()
    if card ~= nil and card.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.card == nil then
        msg.card = {}
      end
      msg.card.index = card.index
    end
    if card ~= nil and card.cardids ~= nil then
      if msg.card == nil then
        msg.card = {}
      end
      if msg.card.cardids == nil then
        msg.card.cardids = {}
      end
      for i = 1, #card.cardids do
        table.insert(msg.card.cardids, card.cardids[i])
      end
    end
    if process ~= nil then
      msg.process = process
    end
    if totalprocess ~= nil then
      msg.totalprocess = totalprocess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncProcessPveCardCmd.id
    local msgParam = {}
    if card ~= nil and card.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.card == nil then
        msgParam.card = {}
      end
      msgParam.card.index = card.index
    end
    if card ~= nil and card.cardids ~= nil then
      if msgParam.card == nil then
        msgParam.card = {}
      end
      if msgParam.card.cardids == nil then
        msgParam.card.cardids = {}
      end
      for i = 1, #card.cardids do
        table.insert(msgParam.card.cardids, card.cardids[i])
      end
    end
    if process ~= nil then
      msgParam.process = process
    end
    if totalprocess ~= nil then
      msgParam.totalprocess = totalprocess
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallUpdateProcessPveCardCmd(process, totalprocess)
  if not NetConfig.PBC then
    local msg = PveCard_pb.UpdateProcessPveCardCmd()
    if process ~= nil then
      msg.process = process
    end
    if totalprocess ~= nil then
      msg.totalprocess = totalprocess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateProcessPveCardCmd.id
    local msgParam = {}
    if process ~= nil then
      msgParam.process = process
    end
    if totalprocess ~= nil then
      msgParam.totalprocess = totalprocess
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallBeginFirePveCardCmd()
  if not NetConfig.PBC then
    local msg = PveCard_pb.BeginFirePveCardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeginFirePveCardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallFinishPlayCardCmd()
  if not NetConfig.PBC then
    local msg = PveCard_pb.FinishPlayCardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FinishPlayCardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallPlayPveCardCmd(npcguid, cardids)
  if not NetConfig.PBC then
    local msg = PveCard_pb.PlayPveCardCmd()
    if msg == nil then
      msg = {}
    end
    msg.npcguid = npcguid
    if cardids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cardids == nil then
        msg.cardids = {}
      end
      for i = 1, #cardids do
        table.insert(msg.cardids, cardids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlayPveCardCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcguid = npcguid
    if cardids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cardids == nil then
        msgParam.cardids = {}
      end
      for i = 1, #cardids do
        table.insert(msgParam.cardids, cardids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:CallGetPveCardRewardCmd()
  if not NetConfig.PBC then
    local msg = PveCard_pb.GetPveCardRewardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetPveCardRewardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePveCardAutoProxy:RecvInvitePveCardCmd(data)
  self:Notify(ServiceEvent.PveCardInvitePveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvReplyPveCardCmd(data)
  self:Notify(ServiceEvent.PveCardReplyPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvEnterPveCardCmd(data)
  self:Notify(ServiceEvent.PveCardEnterPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvQueryCardInfoCmd(data)
  self:Notify(ServiceEvent.PveCardQueryCardInfoCmd, data)
end

function ServicePveCardAutoProxy:RecvSelectPveCardCmd(data)
  self:Notify(ServiceEvent.PveCardSelectPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvSyncProcessPveCardCmd(data)
  self:Notify(ServiceEvent.PveCardSyncProcessPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvUpdateProcessPveCardCmd(data)
  self:Notify(ServiceEvent.PveCardUpdateProcessPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvBeginFirePveCardCmd(data)
  self:Notify(ServiceEvent.PveCardBeginFirePveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvFinishPlayCardCmd(data)
  self:Notify(ServiceEvent.PveCardFinishPlayCardCmd, data)
end

function ServicePveCardAutoProxy:RecvPlayPveCardCmd(data)
  self:Notify(ServiceEvent.PveCardPlayPveCardCmd, data)
end

function ServicePveCardAutoProxy:RecvGetPveCardRewardCmd(data)
  self:Notify(ServiceEvent.PveCardGetPveCardRewardCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.PveCardInvitePveCardCmd = "ServiceEvent_PveCardInvitePveCardCmd"
ServiceEvent.PveCardReplyPveCardCmd = "ServiceEvent_PveCardReplyPveCardCmd"
ServiceEvent.PveCardEnterPveCardCmd = "ServiceEvent_PveCardEnterPveCardCmd"
ServiceEvent.PveCardQueryCardInfoCmd = "ServiceEvent_PveCardQueryCardInfoCmd"
ServiceEvent.PveCardSelectPveCardCmd = "ServiceEvent_PveCardSelectPveCardCmd"
ServiceEvent.PveCardSyncProcessPveCardCmd = "ServiceEvent_PveCardSyncProcessPveCardCmd"
ServiceEvent.PveCardUpdateProcessPveCardCmd = "ServiceEvent_PveCardUpdateProcessPveCardCmd"
ServiceEvent.PveCardBeginFirePveCardCmd = "ServiceEvent_PveCardBeginFirePveCardCmd"
ServiceEvent.PveCardFinishPlayCardCmd = "ServiceEvent_PveCardFinishPlayCardCmd"
ServiceEvent.PveCardPlayPveCardCmd = "ServiceEvent_PveCardPlayPveCardCmd"
ServiceEvent.PveCardGetPveCardRewardCmd = "ServiceEvent_PveCardGetPveCardRewardCmd"
