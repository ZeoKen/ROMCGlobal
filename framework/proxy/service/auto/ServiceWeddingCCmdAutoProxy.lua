ServiceWeddingCCmdAutoProxy = class("ServiceWeddingCCmdAutoProxy", ServiceProxy)
ServiceWeddingCCmdAutoProxy.Instance = nil
ServiceWeddingCCmdAutoProxy.NAME = "ServiceWeddingCCmdAutoProxy"

function ServiceWeddingCCmdAutoProxy:ctor(proxyName)
  if ServiceWeddingCCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceWeddingCCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceWeddingCCmdAutoProxy.Instance = self
  end
end

function ServiceWeddingCCmdAutoProxy:Init()
end

function ServiceWeddingCCmdAutoProxy:onRegister()
  self:Listen(65, 1, function(data)
    self:RecvReqWeddingDateListCCmd(data)
  end)
  self:Listen(65, 3, function(data)
    self:RecvReqWeddingOneDayListCCmd(data)
  end)
  self:Listen(65, 4, function(data)
    self:RecvReqWeddingInfoCCmd(data)
  end)
  self:Listen(65, 5, function(data)
    self:RecvReserveWeddingDateCCmd(data)
  end)
  self:Listen(65, 6, function(data)
    self:RecvNtfReserveWeddingDateCCmd(data)
  end)
  self:Listen(65, 7, function(data)
    self:RecvReplyReserveWeddingDateCCmd(data)
  end)
  self:Listen(65, 8, function(data)
    self:RecvGiveUpReserveCCmd(data)
  end)
  self:Listen(65, 9, function(data)
    self:RecvReqDivorceCCmd(data)
  end)
  self:Listen(65, 10, function(data)
    self:RecvUpdateWeddingManualCCmd(data)
  end)
  self:Listen(65, 11, function(data)
    self:RecvBuyWeddingPackageCCmd(data)
  end)
  self:Listen(65, 12, function(data)
    self:RecvBuyWeddingRingCCmd(data)
  end)
  self:Listen(65, 13, function(data)
    self:RecvWeddingInviteCCmd(data)
  end)
  self:Listen(65, 14, function(data)
    self:RecvUploadWeddingPhotoCCmd(data)
  end)
  self:Listen(65, 15, function(data)
    self:RecvCheckCanReserveCCmd(data)
  end)
  self:Listen(65, 16, function(data)
    self:RecvReqPartnerInfoCCmd(data)
  end)
  self:Listen(65, 17, function(data)
    self:RecvNtfWeddingInfoCCmd(data)
  end)
  self:Listen(65, 18, function(data)
    self:RecvInviteBeginWeddingCCmd(data)
  end)
  self:Listen(65, 19, function(data)
    self:RecvReplyBeginWeddingCCmd(data)
  end)
  self:Listen(65, 20, function(data)
    self:RecvGoToWeddingPosCCmd(data)
  end)
  self:Listen(65, 21, function(data)
    self:RecvQuestionWeddingCCmd(data)
  end)
  self:Listen(65, 22, function(data)
    self:RecvAnswerWeddingCCmd(data)
  end)
  self:Listen(65, 23, function(data)
    self:RecvWeddingEventMsgCCmd(data)
  end)
  self:Listen(65, 24, function(data)
    self:RecvWeddingOverCCmd(data)
  end)
  self:Listen(65, 25, function(data)
    self:RecvWeddingSwitchQuestionCCmd(data)
  end)
  self:Listen(65, 26, function(data)
    self:RecvEnterRollerCoasterCCmd(data)
  end)
  self:Listen(65, 27, function(data)
    self:RecvDivorceRollerCoasterInviteCCmd(data)
  end)
  self:Listen(65, 28, function(data)
    self:RecvDivorceRollerCoasterReplyCCmd(data)
  end)
  self:Listen(65, 29, function(data)
    self:RecvEnterWeddingMapCCmd(data)
  end)
  self:Listen(65, 30, function(data)
    self:RecvMissyouInviteWedCCmd(data)
  end)
  self:Listen(65, 31, function(data)
    self:RecvMisccyouReplyWedCCmd(data)
  end)
  self:Listen(65, 32, function(data)
    self:RecvWeddingCarrierCCmd(data)
  end)
end

function ServiceWeddingCCmdAutoProxy:CallReqWeddingDateListCCmd(date_list, use_ticket)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReqWeddingDateListCCmd()
    if date_list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.date_list == nil then
        msg.date_list = {}
      end
      for i = 1, #date_list do
        table.insert(msg.date_list, date_list[i])
      end
    end
    if use_ticket ~= nil then
      msg.use_ticket = use_ticket
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqWeddingDateListCCmd.id
    local msgParam = {}
    if date_list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.date_list == nil then
        msgParam.date_list = {}
      end
      for i = 1, #date_list do
        table.insert(msgParam.date_list, date_list[i])
      end
    end
    if use_ticket ~= nil then
      msgParam.use_ticket = use_ticket
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallReqWeddingOneDayListCCmd(date, info)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReqWeddingOneDayListCCmd()
    if date ~= nil then
      msg.date = date
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
    local msgId = ProtoReqInfoList.ReqWeddingOneDayListCCmd.id
    local msgParam = {}
    if date ~= nil then
      msgParam.date = date
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

function ServiceWeddingCCmdAutoProxy:CallReqWeddingInfoCCmd(id, info)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReqWeddingInfoCCmd()
    if id ~= nil then
      msg.id = id
    end
    if info ~= nil and info.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.id = info.id
    end
    if info ~= nil and info.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.status = info.status
    end
    if info.char1 ~= nil and info.char1.charid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.charid = info.char1.charid
    end
    if info.char1 ~= nil and info.char1.name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.name = info.char1.name
    end
    if info.char1 ~= nil and info.char1.profession ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.profession = info.char1.profession
    end
    if info.char1 ~= nil and info.char1.gender ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.gender = info.char1.gender
    end
    if info.char1 ~= nil and info.char1.portrait ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.portrait = info.char1.portrait
    end
    if info.char1 ~= nil and info.char1.hair ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.hair = info.char1.hair
    end
    if info.char1 ~= nil and info.char1.haircolor ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.haircolor = info.char1.haircolor
    end
    if info.char1 ~= nil and info.char1.body ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.body = info.char1.body
    end
    if info.char1 ~= nil and info.char1.head ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.head = info.char1.head
    end
    if info.char1 ~= nil and info.char1.face ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.face = info.char1.face
    end
    if info.char1 ~= nil and info.char1.mouth ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.mouth = info.char1.mouth
    end
    if info.char1 ~= nil and info.char1.eye ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.eye = info.char1.eye
    end
    if info.char1 ~= nil and info.char1.level ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.level = info.char1.level
    end
    if info.char1 ~= nil and info.char1.guildname ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.guildname = info.char1.guildname
    end
    if info.char2 ~= nil and info.char2.charid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.charid = info.char2.charid
    end
    if info.char2 ~= nil and info.char2.name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.name = info.char2.name
    end
    if info.char2 ~= nil and info.char2.profession ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.profession = info.char2.profession
    end
    if info.char2 ~= nil and info.char2.gender ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.gender = info.char2.gender
    end
    if info.char2 ~= nil and info.char2.portrait ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.portrait = info.char2.portrait
    end
    if info.char2 ~= nil and info.char2.hair ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.hair = info.char2.hair
    end
    if info.char2 ~= nil and info.char2.haircolor ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.haircolor = info.char2.haircolor
    end
    if info.char2 ~= nil and info.char2.body ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.body = info.char2.body
    end
    if info.char2 ~= nil and info.char2.head ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.head = info.char2.head
    end
    if info.char2 ~= nil and info.char2.face ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.face = info.char2.face
    end
    if info.char2 ~= nil and info.char2.mouth ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.mouth = info.char2.mouth
    end
    if info.char2 ~= nil and info.char2.eye ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.eye = info.char2.eye
    end
    if info.char2 ~= nil and info.char2.level ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.level = info.char2.level
    end
    if info.char2 ~= nil and info.char2.guildname ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.guildname = info.char2.guildname
    end
    if info ~= nil and info.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.zoneid = info.zoneid
    end
    if info ~= nil and info.starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.starttime = info.starttime
    end
    if info ~= nil and info.endtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.endtime = info.endtime
    end
    if info ~= nil and info.can_single_divorce ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.can_single_divorce = info.can_single_divorce
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqWeddingInfoCCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if info ~= nil and info.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.id = info.id
    end
    if info ~= nil and info.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.status = info.status
    end
    if info.char1 ~= nil and info.char1.charid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.charid = info.char1.charid
    end
    if info.char1 ~= nil and info.char1.name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.name = info.char1.name
    end
    if info.char1 ~= nil and info.char1.profession ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.profession = info.char1.profession
    end
    if info.char1 ~= nil and info.char1.gender ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.gender = info.char1.gender
    end
    if info.char1 ~= nil and info.char1.portrait ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.portrait = info.char1.portrait
    end
    if info.char1 ~= nil and info.char1.hair ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.hair = info.char1.hair
    end
    if info.char1 ~= nil and info.char1.haircolor ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.haircolor = info.char1.haircolor
    end
    if info.char1 ~= nil and info.char1.body ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.body = info.char1.body
    end
    if info.char1 ~= nil and info.char1.head ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.head = info.char1.head
    end
    if info.char1 ~= nil and info.char1.face ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.face = info.char1.face
    end
    if info.char1 ~= nil and info.char1.mouth ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.mouth = info.char1.mouth
    end
    if info.char1 ~= nil and info.char1.eye ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.eye = info.char1.eye
    end
    if info.char1 ~= nil and info.char1.level ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.level = info.char1.level
    end
    if info.char1 ~= nil and info.char1.guildname ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.guildname = info.char1.guildname
    end
    if info.char2 ~= nil and info.char2.charid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.charid = info.char2.charid
    end
    if info.char2 ~= nil and info.char2.name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.name = info.char2.name
    end
    if info.char2 ~= nil and info.char2.profession ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.profession = info.char2.profession
    end
    if info.char2 ~= nil and info.char2.gender ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.gender = info.char2.gender
    end
    if info.char2 ~= nil and info.char2.portrait ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.portrait = info.char2.portrait
    end
    if info.char2 ~= nil and info.char2.hair ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.hair = info.char2.hair
    end
    if info.char2 ~= nil and info.char2.haircolor ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.haircolor = info.char2.haircolor
    end
    if info.char2 ~= nil and info.char2.body ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.body = info.char2.body
    end
    if info.char2 ~= nil and info.char2.head ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.head = info.char2.head
    end
    if info.char2 ~= nil and info.char2.face ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.face = info.char2.face
    end
    if info.char2 ~= nil and info.char2.mouth ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.mouth = info.char2.mouth
    end
    if info.char2 ~= nil and info.char2.eye ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.eye = info.char2.eye
    end
    if info.char2 ~= nil and info.char2.level ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.level = info.char2.level
    end
    if info.char2 ~= nil and info.char2.guildname ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.guildname = info.char2.guildname
    end
    if info ~= nil and info.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.zoneid = info.zoneid
    end
    if info ~= nil and info.starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.starttime = info.starttime
    end
    if info ~= nil and info.endtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.endtime = info.endtime
    end
    if info ~= nil and info.can_single_divorce ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.can_single_divorce = info.can_single_divorce
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallReserveWeddingDateCCmd(date, configid, charid2, use_ticket)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReserveWeddingDateCCmd()
    if date ~= nil then
      msg.date = date
    end
    if configid ~= nil then
      msg.configid = configid
    end
    if charid2 ~= nil then
      msg.charid2 = charid2
    end
    if use_ticket ~= nil then
      msg.use_ticket = use_ticket
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReserveWeddingDateCCmd.id
    local msgParam = {}
    if date ~= nil then
      msgParam.date = date
    end
    if configid ~= nil then
      msgParam.configid = configid
    end
    if charid2 ~= nil then
      msgParam.charid2 = charid2
    end
    if use_ticket ~= nil then
      msgParam.use_ticket = use_ticket
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallNtfReserveWeddingDateCCmd(date, configid, charid1, name, starttime, endtime, time, use_ticket, zoneid, sign)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.NtfReserveWeddingDateCCmd()
    if date ~= nil then
      msg.date = date
    end
    if configid ~= nil then
      msg.configid = configid
    end
    if charid1 ~= nil then
      msg.charid1 = charid1
    end
    if name ~= nil then
      msg.name = name
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if time ~= nil then
      msg.time = time
    end
    if use_ticket ~= nil then
      msg.use_ticket = use_ticket
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfReserveWeddingDateCCmd.id
    local msgParam = {}
    if date ~= nil then
      msgParam.date = date
    end
    if configid ~= nil then
      msgParam.configid = configid
    end
    if charid1 ~= nil then
      msgParam.charid1 = charid1
    end
    if name ~= nil then
      msgParam.name = name
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if time ~= nil then
      msgParam.time = time
    end
    if use_ticket ~= nil then
      msgParam.use_ticket = use_ticket
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallReplyReserveWeddingDateCCmd(date, configid, charid1, reply, time, use_ticket, zoneid, sign)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReplyReserveWeddingDateCCmd()
    if date ~= nil then
      msg.date = date
    end
    if configid ~= nil then
      msg.configid = configid
    end
    if charid1 ~= nil then
      msg.charid1 = charid1
    end
    if reply ~= nil then
      msg.reply = reply
    end
    if time ~= nil then
      msg.time = time
    end
    if use_ticket ~= nil then
      msg.use_ticket = use_ticket
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if sign ~= nil then
      msg.sign = sign
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyReserveWeddingDateCCmd.id
    local msgParam = {}
    if date ~= nil then
      msgParam.date = date
    end
    if configid ~= nil then
      msgParam.configid = configid
    end
    if charid1 ~= nil then
      msgParam.charid1 = charid1
    end
    if reply ~= nil then
      msgParam.reply = reply
    end
    if time ~= nil then
      msgParam.time = time
    end
    if use_ticket ~= nil then
      msgParam.use_ticket = use_ticket
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallGiveUpReserveCCmd(id)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.GiveUpReserveCCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiveUpReserveCCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallReqDivorceCCmd(id, type)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReqDivorceCCmd()
    if id ~= nil then
      msg.id = id
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqDivorceCCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallUpdateWeddingManualCCmd(manual, invitees)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.UpdateWeddingManualCCmd()
    if manual ~= nil and manual.packageids ~= nil then
      if msg.manual == nil then
        msg.manual = {}
      end
      if msg.manual.packageids == nil then
        msg.manual.packageids = {}
      end
      for i = 1, #manual.packageids do
        table.insert(msg.manual.packageids, manual.packageids[i])
      end
    end
    if manual ~= nil and manual.ringid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.manual == nil then
        msg.manual = {}
      end
      msg.manual.ringid = manual.ringid
    end
    if manual ~= nil and manual.photoindex ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.manual == nil then
        msg.manual = {}
      end
      msg.manual.photoindex = manual.photoindex
    end
    if manual ~= nil and manual.phototime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.manual == nil then
        msg.manual = {}
      end
      msg.manual.phototime = manual.phototime
    end
    if invitees ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.invitees == nil then
        msg.invitees = {}
      end
      for i = 1, #invitees do
        table.insert(msg.invitees, invitees[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateWeddingManualCCmd.id
    local msgParam = {}
    if manual ~= nil and manual.packageids ~= nil then
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      if msgParam.manual.packageids == nil then
        msgParam.manual.packageids = {}
      end
      for i = 1, #manual.packageids do
        table.insert(msgParam.manual.packageids, manual.packageids[i])
      end
    end
    if manual ~= nil and manual.ringid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      msgParam.manual.ringid = manual.ringid
    end
    if manual ~= nil and manual.photoindex ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      msgParam.manual.photoindex = manual.photoindex
    end
    if manual ~= nil and manual.phototime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      msgParam.manual.phototime = manual.phototime
    end
    if invitees ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.invitees == nil then
        msgParam.invitees = {}
      end
      for i = 1, #invitees do
        table.insert(msgParam.invitees, invitees[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallBuyWeddingPackageCCmd(id, priceitem)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.BuyWeddingPackageCCmd()
    if id ~= nil then
      msg.id = id
    end
    if priceitem ~= nil then
      msg.priceitem = priceitem
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyWeddingPackageCCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if priceitem ~= nil then
      msgParam.priceitem = priceitem
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallBuyWeddingRingCCmd(id, priceitem)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.BuyWeddingRingCCmd()
    if id ~= nil then
      msg.id = id
    end
    if priceitem ~= nil then
      msg.priceitem = priceitem
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyWeddingRingCCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if priceitem ~= nil then
      msgParam.priceitem = priceitem
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallWeddingInviteCCmd(charids)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.WeddingInviteCCmd()
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
    local msgId = ProtoReqInfoList.WeddingInviteCCmd.id
    local msgParam = {}
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

function ServiceWeddingCCmdAutoProxy:CallUploadWeddingPhotoCCmd(index, time)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.UploadWeddingPhotoCCmd()
    if index ~= nil then
      msg.index = index
    end
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UploadWeddingPhotoCCmd.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallCheckCanReserveCCmd(charid2, success)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.CheckCanReserveCCmd()
    if charid2 ~= nil then
      msg.charid2 = charid2
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CheckCanReserveCCmd.id
    local msgParam = {}
    if charid2 ~= nil then
      msgParam.charid2 = charid2
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallReqPartnerInfoCCmd(chardata)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReqPartnerInfoCCmd()
    if chardata ~= nil and chardata.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.charid = chardata.charid
    end
    if chardata ~= nil and chardata.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.name = chardata.name
    end
    if chardata ~= nil and chardata.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.profession = chardata.profession
    end
    if chardata ~= nil and chardata.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.gender = chardata.gender
    end
    if chardata ~= nil and chardata.portrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.portrait = chardata.portrait
    end
    if chardata ~= nil and chardata.hair ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.hair = chardata.hair
    end
    if chardata ~= nil and chardata.haircolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.haircolor = chardata.haircolor
    end
    if chardata ~= nil and chardata.body ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.body = chardata.body
    end
    if chardata ~= nil and chardata.head ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.head = chardata.head
    end
    if chardata ~= nil and chardata.face ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.face = chardata.face
    end
    if chardata ~= nil and chardata.mouth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.mouth = chardata.mouth
    end
    if chardata ~= nil and chardata.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.eye = chardata.eye
    end
    if chardata ~= nil and chardata.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.level = chardata.level
    end
    if chardata ~= nil and chardata.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chardata == nil then
        msg.chardata = {}
      end
      msg.chardata.guildname = chardata.guildname
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqPartnerInfoCCmd.id
    local msgParam = {}
    if chardata ~= nil and chardata.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.charid = chardata.charid
    end
    if chardata ~= nil and chardata.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.name = chardata.name
    end
    if chardata ~= nil and chardata.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.profession = chardata.profession
    end
    if chardata ~= nil and chardata.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.gender = chardata.gender
    end
    if chardata ~= nil and chardata.portrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.portrait = chardata.portrait
    end
    if chardata ~= nil and chardata.hair ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.hair = chardata.hair
    end
    if chardata ~= nil and chardata.haircolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.haircolor = chardata.haircolor
    end
    if chardata ~= nil and chardata.body ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.body = chardata.body
    end
    if chardata ~= nil and chardata.head ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.head = chardata.head
    end
    if chardata ~= nil and chardata.face ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.face = chardata.face
    end
    if chardata ~= nil and chardata.mouth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.mouth = chardata.mouth
    end
    if chardata ~= nil and chardata.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.eye = chardata.eye
    end
    if chardata ~= nil and chardata.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.level = chardata.level
    end
    if chardata ~= nil and chardata.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chardata == nil then
        msgParam.chardata = {}
      end
      msgParam.chardata.guildname = chardata.guildname
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallNtfWeddingInfoCCmd(info)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.NtfWeddingInfoCCmd()
    if info ~= nil and info.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.id = info.id
    end
    if info ~= nil and info.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.status = info.status
    end
    if info.char1 ~= nil and info.char1.charid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.charid = info.char1.charid
    end
    if info.char1 ~= nil and info.char1.name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.name = info.char1.name
    end
    if info.char1 ~= nil and info.char1.profession ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.profession = info.char1.profession
    end
    if info.char1 ~= nil and info.char1.gender ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.gender = info.char1.gender
    end
    if info.char1 ~= nil and info.char1.portrait ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.portrait = info.char1.portrait
    end
    if info.char1 ~= nil and info.char1.hair ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.hair = info.char1.hair
    end
    if info.char1 ~= nil and info.char1.haircolor ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.haircolor = info.char1.haircolor
    end
    if info.char1 ~= nil and info.char1.body ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.body = info.char1.body
    end
    if info.char1 ~= nil and info.char1.head ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.head = info.char1.head
    end
    if info.char1 ~= nil and info.char1.face ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.face = info.char1.face
    end
    if info.char1 ~= nil and info.char1.mouth ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.mouth = info.char1.mouth
    end
    if info.char1 ~= nil and info.char1.eye ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.eye = info.char1.eye
    end
    if info.char1 ~= nil and info.char1.level ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.level = info.char1.level
    end
    if info.char1 ~= nil and info.char1.guildname ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char1 == nil then
        msg.info.char1 = {}
      end
      msg.info.char1.guildname = info.char1.guildname
    end
    if info.char2 ~= nil and info.char2.charid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.charid = info.char2.charid
    end
    if info.char2 ~= nil and info.char2.name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.name = info.char2.name
    end
    if info.char2 ~= nil and info.char2.profession ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.profession = info.char2.profession
    end
    if info.char2 ~= nil and info.char2.gender ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.gender = info.char2.gender
    end
    if info.char2 ~= nil and info.char2.portrait ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.portrait = info.char2.portrait
    end
    if info.char2 ~= nil and info.char2.hair ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.hair = info.char2.hair
    end
    if info.char2 ~= nil and info.char2.haircolor ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.haircolor = info.char2.haircolor
    end
    if info.char2 ~= nil and info.char2.body ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.body = info.char2.body
    end
    if info.char2 ~= nil and info.char2.head ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.head = info.char2.head
    end
    if info.char2 ~= nil and info.char2.face ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.face = info.char2.face
    end
    if info.char2 ~= nil and info.char2.mouth ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.mouth = info.char2.mouth
    end
    if info.char2 ~= nil and info.char2.eye ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.eye = info.char2.eye
    end
    if info.char2 ~= nil and info.char2.level ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.level = info.char2.level
    end
    if info.char2 ~= nil and info.char2.guildname ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.char2 == nil then
        msg.info.char2 = {}
      end
      msg.info.char2.guildname = info.char2.guildname
    end
    if info ~= nil and info.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.zoneid = info.zoneid
    end
    if info ~= nil and info.starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.starttime = info.starttime
    end
    if info ~= nil and info.endtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.endtime = info.endtime
    end
    if info ~= nil and info.can_single_divorce ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.can_single_divorce = info.can_single_divorce
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfWeddingInfoCCmd.id
    local msgParam = {}
    if info ~= nil and info.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.id = info.id
    end
    if info ~= nil and info.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.status = info.status
    end
    if info.char1 ~= nil and info.char1.charid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.charid = info.char1.charid
    end
    if info.char1 ~= nil and info.char1.name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.name = info.char1.name
    end
    if info.char1 ~= nil and info.char1.profession ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.profession = info.char1.profession
    end
    if info.char1 ~= nil and info.char1.gender ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.gender = info.char1.gender
    end
    if info.char1 ~= nil and info.char1.portrait ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.portrait = info.char1.portrait
    end
    if info.char1 ~= nil and info.char1.hair ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.hair = info.char1.hair
    end
    if info.char1 ~= nil and info.char1.haircolor ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.haircolor = info.char1.haircolor
    end
    if info.char1 ~= nil and info.char1.body ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.body = info.char1.body
    end
    if info.char1 ~= nil and info.char1.head ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.head = info.char1.head
    end
    if info.char1 ~= nil and info.char1.face ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.face = info.char1.face
    end
    if info.char1 ~= nil and info.char1.mouth ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.mouth = info.char1.mouth
    end
    if info.char1 ~= nil and info.char1.eye ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.eye = info.char1.eye
    end
    if info.char1 ~= nil and info.char1.level ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.level = info.char1.level
    end
    if info.char1 ~= nil and info.char1.guildname ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char1 == nil then
        msgParam.info.char1 = {}
      end
      msgParam.info.char1.guildname = info.char1.guildname
    end
    if info.char2 ~= nil and info.char2.charid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.charid = info.char2.charid
    end
    if info.char2 ~= nil and info.char2.name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.name = info.char2.name
    end
    if info.char2 ~= nil and info.char2.profession ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.profession = info.char2.profession
    end
    if info.char2 ~= nil and info.char2.gender ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.gender = info.char2.gender
    end
    if info.char2 ~= nil and info.char2.portrait ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.portrait = info.char2.portrait
    end
    if info.char2 ~= nil and info.char2.hair ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.hair = info.char2.hair
    end
    if info.char2 ~= nil and info.char2.haircolor ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.haircolor = info.char2.haircolor
    end
    if info.char2 ~= nil and info.char2.body ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.body = info.char2.body
    end
    if info.char2 ~= nil and info.char2.head ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.head = info.char2.head
    end
    if info.char2 ~= nil and info.char2.face ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.face = info.char2.face
    end
    if info.char2 ~= nil and info.char2.mouth ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.mouth = info.char2.mouth
    end
    if info.char2 ~= nil and info.char2.eye ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.eye = info.char2.eye
    end
    if info.char2 ~= nil and info.char2.level ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.level = info.char2.level
    end
    if info.char2 ~= nil and info.char2.guildname ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.char2 == nil then
        msgParam.info.char2 = {}
      end
      msgParam.info.char2.guildname = info.char2.guildname
    end
    if info ~= nil and info.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.zoneid = info.zoneid
    end
    if info ~= nil and info.starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.starttime = info.starttime
    end
    if info ~= nil and info.endtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.endtime = info.endtime
    end
    if info ~= nil and info.can_single_divorce ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.can_single_divorce = info.can_single_divorce
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallInviteBeginWeddingCCmd(masterid, name, tocharid)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.InviteBeginWeddingCCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    if name ~= nil then
      msg.name = name
    end
    if tocharid ~= nil then
      msg.tocharid = tocharid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteBeginWeddingCCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    if name ~= nil then
      msgParam.name = name
    end
    if tocharid ~= nil then
      msgParam.tocharid = tocharid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallReplyBeginWeddingCCmd(masterid)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.ReplyBeginWeddingCCmd()
    if masterid ~= nil then
      msg.masterid = masterid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyBeginWeddingCCmd.id
    local msgParam = {}
    if masterid ~= nil then
      msgParam.masterid = masterid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallGoToWeddingPosCCmd()
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.GoToWeddingPosCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoToWeddingPosCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallQuestionWeddingCCmd(questionid, charids, npcguid)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.QuestionWeddingCCmd()
    if questionid ~= nil then
      msg.questionid = questionid
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
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestionWeddingCCmd.id
    local msgParam = {}
    if questionid ~= nil then
      msgParam.questionid = questionid
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
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallAnswerWeddingCCmd(questionid, answer)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.AnswerWeddingCCmd()
    if questionid ~= nil then
      msg.questionid = questionid
    end
    if answer ~= nil then
      msg.answer = answer
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AnswerWeddingCCmd.id
    local msgParam = {}
    if questionid ~= nil then
      msgParam.questionid = questionid
    end
    if answer ~= nil then
      msgParam.answer = answer
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallWeddingEventMsgCCmd(charid, event, id, charid1, charid2, msg, opt_charid)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.WeddingEventMsgCCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if event ~= nil then
      msg.event = event
    end
    if id ~= nil then
      msg.id = id
    end
    if charid1 ~= nil then
      msg.charid1 = charid1
    end
    if charid2 ~= nil then
      msg.charid2 = charid2
    end
    if msg ~= nil then
      msg.msg = msg
    end
    if opt_charid ~= nil then
      msg.opt_charid = opt_charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeddingEventMsgCCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if event ~= nil then
      msgParam.event = event
    end
    if id ~= nil then
      msgParam.id = id
    end
    if charid1 ~= nil then
      msgParam.charid1 = charid1
    end
    if charid2 ~= nil then
      msgParam.charid2 = charid2
    end
    if msg ~= nil then
      msgParam.msg = msg
    end
    if opt_charid ~= nil then
      msgParam.opt_charid = opt_charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallWeddingOverCCmd(success)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.WeddingOverCCmd()
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeddingOverCCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallWeddingSwitchQuestionCCmd(onoff, npcguid)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.WeddingSwitchQuestionCCmd()
    if onoff ~= nil then
      msg.onoff = onoff
    end
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeddingSwitchQuestionCCmd.id
    local msgParam = {}
    if onoff ~= nil then
      msgParam.onoff = onoff
    end
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallEnterRollerCoasterCCmd()
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.EnterRollerCoasterCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterRollerCoasterCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallDivorceRollerCoasterInviteCCmd(inviter, invitee, inviter_name)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.DivorceRollerCoasterInviteCCmd()
    if inviter ~= nil then
      msg.inviter = inviter
    end
    if invitee ~= nil then
      msg.invitee = invitee
    end
    if inviter_name ~= nil then
      msg.inviter_name = inviter_name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DivorceRollerCoasterInviteCCmd.id
    local msgParam = {}
    if inviter ~= nil then
      msgParam.inviter = inviter
    end
    if invitee ~= nil then
      msgParam.invitee = invitee
    end
    if inviter_name ~= nil then
      msgParam.inviter_name = inviter_name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallDivorceRollerCoasterReplyCCmd(inviter, reply)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.DivorceRollerCoasterReplyCCmd()
    if inviter ~= nil then
      msg.inviter = inviter
    end
    if reply ~= nil then
      msg.reply = reply
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DivorceRollerCoasterReplyCCmd.id
    local msgParam = {}
    if inviter ~= nil then
      msgParam.inviter = inviter
    end
    if reply ~= nil then
      msgParam.reply = reply
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallEnterWeddingMapCCmd()
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.EnterWeddingMapCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterWeddingMapCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallMissyouInviteWedCCmd()
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.MissyouInviteWedCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MissyouInviteWedCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallMisccyouReplyWedCCmd(agree)
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.MisccyouReplyWedCCmd()
    if agree ~= nil then
      msg.agree = agree
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MisccyouReplyWedCCmd.id
    local msgParam = {}
    if agree ~= nil then
      msgParam.agree = agree
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:CallWeddingCarrierCCmd()
  if not NetConfig.PBC then
    local msg = WeddingCCmd_pb.WeddingCarrierCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeddingCarrierCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeddingCCmdAutoProxy:RecvReqWeddingDateListCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReqWeddingDateListCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqWeddingOneDayListCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReqWeddingOneDayListCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqWeddingInfoCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReqWeddingInfoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReserveWeddingDateCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReserveWeddingDateCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvNtfReserveWeddingDateCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReplyReserveWeddingDateCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReplyReserveWeddingDateCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvGiveUpReserveCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdGiveUpReserveCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqDivorceCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReqDivorceCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvUpdateWeddingManualCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvBuyWeddingPackageCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdBuyWeddingPackageCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvBuyWeddingRingCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdBuyWeddingRingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingInviteCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdWeddingInviteCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvUploadWeddingPhotoCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdUploadWeddingPhotoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvCheckCanReserveCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdCheckCanReserveCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReqPartnerInfoCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReqPartnerInfoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvNtfWeddingInfoCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvInviteBeginWeddingCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvReplyBeginWeddingCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdReplyBeginWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvGoToWeddingPosCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdGoToWeddingPosCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvQuestionWeddingCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdQuestionWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvAnswerWeddingCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdAnswerWeddingCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingEventMsgCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdWeddingEventMsgCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingOverCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdWeddingOverCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingSwitchQuestionCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdWeddingSwitchQuestionCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvEnterRollerCoasterCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdEnterRollerCoasterCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvDivorceRollerCoasterInviteCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvDivorceRollerCoasterReplyCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdDivorceRollerCoasterReplyCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvEnterWeddingMapCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdEnterWeddingMapCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvMissyouInviteWedCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdMissyouInviteWedCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvMisccyouReplyWedCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdMisccyouReplyWedCCmd, data)
end

function ServiceWeddingCCmdAutoProxy:RecvWeddingCarrierCCmd(data)
  self:Notify(ServiceEvent.WeddingCCmdWeddingCarrierCCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.WeddingCCmdReqWeddingDateListCCmd = "ServiceEvent_WeddingCCmdReqWeddingDateListCCmd"
ServiceEvent.WeddingCCmdReqWeddingOneDayListCCmd = "ServiceEvent_WeddingCCmdReqWeddingOneDayListCCmd"
ServiceEvent.WeddingCCmdReqWeddingInfoCCmd = "ServiceEvent_WeddingCCmdReqWeddingInfoCCmd"
ServiceEvent.WeddingCCmdReserveWeddingDateCCmd = "ServiceEvent_WeddingCCmdReserveWeddingDateCCmd"
ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd = "ServiceEvent_WeddingCCmdNtfReserveWeddingDateCCmd"
ServiceEvent.WeddingCCmdReplyReserveWeddingDateCCmd = "ServiceEvent_WeddingCCmdReplyReserveWeddingDateCCmd"
ServiceEvent.WeddingCCmdGiveUpReserveCCmd = "ServiceEvent_WeddingCCmdGiveUpReserveCCmd"
ServiceEvent.WeddingCCmdReqDivorceCCmd = "ServiceEvent_WeddingCCmdReqDivorceCCmd"
ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd = "ServiceEvent_WeddingCCmdUpdateWeddingManualCCmd"
ServiceEvent.WeddingCCmdBuyWeddingPackageCCmd = "ServiceEvent_WeddingCCmdBuyWeddingPackageCCmd"
ServiceEvent.WeddingCCmdBuyWeddingRingCCmd = "ServiceEvent_WeddingCCmdBuyWeddingRingCCmd"
ServiceEvent.WeddingCCmdWeddingInviteCCmd = "ServiceEvent_WeddingCCmdWeddingInviteCCmd"
ServiceEvent.WeddingCCmdUploadWeddingPhotoCCmd = "ServiceEvent_WeddingCCmdUploadWeddingPhotoCCmd"
ServiceEvent.WeddingCCmdCheckCanReserveCCmd = "ServiceEvent_WeddingCCmdCheckCanReserveCCmd"
ServiceEvent.WeddingCCmdReqPartnerInfoCCmd = "ServiceEvent_WeddingCCmdReqPartnerInfoCCmd"
ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd = "ServiceEvent_WeddingCCmdNtfWeddingInfoCCmd"
ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd = "ServiceEvent_WeddingCCmdInviteBeginWeddingCCmd"
ServiceEvent.WeddingCCmdReplyBeginWeddingCCmd = "ServiceEvent_WeddingCCmdReplyBeginWeddingCCmd"
ServiceEvent.WeddingCCmdGoToWeddingPosCCmd = "ServiceEvent_WeddingCCmdGoToWeddingPosCCmd"
ServiceEvent.WeddingCCmdQuestionWeddingCCmd = "ServiceEvent_WeddingCCmdQuestionWeddingCCmd"
ServiceEvent.WeddingCCmdAnswerWeddingCCmd = "ServiceEvent_WeddingCCmdAnswerWeddingCCmd"
ServiceEvent.WeddingCCmdWeddingEventMsgCCmd = "ServiceEvent_WeddingCCmdWeddingEventMsgCCmd"
ServiceEvent.WeddingCCmdWeddingOverCCmd = "ServiceEvent_WeddingCCmdWeddingOverCCmd"
ServiceEvent.WeddingCCmdWeddingSwitchQuestionCCmd = "ServiceEvent_WeddingCCmdWeddingSwitchQuestionCCmd"
ServiceEvent.WeddingCCmdEnterRollerCoasterCCmd = "ServiceEvent_WeddingCCmdEnterRollerCoasterCCmd"
ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd = "ServiceEvent_WeddingCCmdDivorceRollerCoasterInviteCCmd"
ServiceEvent.WeddingCCmdDivorceRollerCoasterReplyCCmd = "ServiceEvent_WeddingCCmdDivorceRollerCoasterReplyCCmd"
ServiceEvent.WeddingCCmdEnterWeddingMapCCmd = "ServiceEvent_WeddingCCmdEnterWeddingMapCCmd"
ServiceEvent.WeddingCCmdMissyouInviteWedCCmd = "ServiceEvent_WeddingCCmdMissyouInviteWedCCmd"
ServiceEvent.WeddingCCmdMisccyouReplyWedCCmd = "ServiceEvent_WeddingCCmdMisccyouReplyWedCCmd"
ServiceEvent.WeddingCCmdWeddingCarrierCCmd = "ServiceEvent_WeddingCCmdWeddingCarrierCCmd"
