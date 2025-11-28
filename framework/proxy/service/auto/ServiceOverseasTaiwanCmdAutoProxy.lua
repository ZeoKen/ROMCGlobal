ServiceOverseasTaiwanCmdAutoProxy = class("ServiceOverseasTaiwanCmdAutoProxy", ServiceProxy)
ServiceOverseasTaiwanCmdAutoProxy.Instance = nil
ServiceOverseasTaiwanCmdAutoProxy.NAME = "ServiceOverseasTaiwanCmdAutoProxy"

function ServiceOverseasTaiwanCmdAutoProxy:ctor(proxyName)
  if ServiceOverseasTaiwanCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceOverseasTaiwanCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceOverseasTaiwanCmdAutoProxy.Instance = self
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:Init()
end

function ServiceOverseasTaiwanCmdAutoProxy:onRegister()
  self:Listen(80, 1, function(data)
    self:RecvTaiwanFbLikeProgressCmd(data)
  end)
  self:Listen(80, 2, function(data)
    self:RecvTaiwanFbLikeUserRedeemCmd(data)
  end)
  self:Listen(81, 1, function(data)
    self:RecvOverseasPhotoUploadCmd(data)
  end)
  self:Listen(81, 2, function(data)
    self:RecvOverseasPhotoPathPrefixCmd(data)
  end)
  self:Listen(80, 10, function(data)
    self:RecvTaiwanFbShareProgressCmd(data)
  end)
  self:Listen(80, 11, function(data)
    self:RecvTaiwanFbShareRedeemCmd(data)
  end)
  self:Listen(80, 99, function(data)
    self:RecvTaiwanMagicLiziCmd(data)
  end)
  self:Listen(80, 21, function(data)
    self:RecvTaiwanRankLisaCmd(data)
  end)
  self:Listen(81, 11, function(data)
    self:RecvOverseasChargeLimitGetChargeCmd(data)
  end)
  self:Listen(81, 21, function(data)
    self:RecvOverseasGoeItemAddCmd(data)
  end)
  self:Listen(81, 22, function(data)
    self:RecvOverseasGoeItemUseCmd(data)
  end)
  self:Listen(81, 23, function(data)
    self:RecvOverseasGoePurchaseCmd(data)
  end)
  self:Listen(81, 24, function(data)
    self:RecvFirebaseNotifyUpdateCmd(data)
  end)
end

function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbLikeProgressCmd(totalLikes, prizeList)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.TaiwanFbLikeProgressCmd()
    if totalLikes ~= nil then
      msg.totalLikes = totalLikes
    end
    if prizeList ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.prizeList == nil then
        msg.prizeList = {}
      end
      for i = 1, #prizeList do
        table.insert(msg.prizeList, prizeList[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TaiwanFbLikeProgressCmd.id
    local msgParam = {}
    if totalLikes ~= nil then
      msgParam.totalLikes = totalLikes
    end
    if prizeList ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.prizeList == nil then
        msgParam.prizeList = {}
      end
      for i = 1, #prizeList do
        table.insert(msgParam.prizeList, prizeList[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbLikeUserRedeemCmd(prizeId, err)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.TaiwanFbLikeUserRedeemCmd()
    if msg == nil then
      msg = {}
    end
    msg.prizeId = prizeId
    if err ~= nil then
      msg.err = err
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TaiwanFbLikeUserRedeemCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.prizeId = prizeId
    if err ~= nil then
      msgParam.err = err
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasPhotoUploadCmd(type, photoId, fields, path)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.OverseasPhotoUploadCmd()
    if msg == nil then
      msg = {}
    end
    msg.type = type
    if msg == nil then
      msg = {}
    end
    msg.photoId = photoId
    if fields ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fields == nil then
        msg.fields = {}
      end
      for i = 1, #fields do
        table.insert(msg.fields, fields[i])
      end
    end
    if path ~= nil then
      msg.path = path
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OverseasPhotoUploadCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.type = type
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.photoId = photoId
    if fields ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fields == nil then
        msgParam.fields = {}
      end
      for i = 1, #fields do
        table.insert(msgParam.fields, fields[i])
      end
    end
    if path ~= nil then
      msgParam.path = path
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasPhotoPathPrefixCmd(type, path)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.OverseasPhotoPathPrefixCmd()
    if msg == nil then
      msg = {}
    end
    msg.type = type
    if path ~= nil then
      msg.path = path
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OverseasPhotoPathPrefixCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.type = type
    if path ~= nil then
      msgParam.path = path
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbShareProgressCmd(canShare)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.TaiwanFbShareProgressCmd()
    if canShare ~= nil then
      msg.canShare = canShare
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TaiwanFbShareProgressCmd.id
    local msgParam = {}
    if canShare ~= nil then
      msgParam.canShare = canShare
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbShareRedeemCmd(err)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.TaiwanFbShareRedeemCmd()
    if err ~= nil then
      msg.err = err
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TaiwanFbShareRedeemCmd.id
    local msgParam = {}
    if err ~= nil then
      msgParam.err = err
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanMagicLiziCmd(data)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.TaiwanMagicLiziCmd()
    if data ~= nil then
      msg.data = data
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TaiwanMagicLiziCmd.id
    local msgParam = {}
    if data ~= nil then
      msgParam.data = data
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanRankLisaCmd(pageindex, pagecount, myranking, mycount, list)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.TaiwanRankLisaCmd()
    if pageindex ~= nil then
      msg.pageindex = pageindex
    end
    if pagecount ~= nil then
      msg.pagecount = pagecount
    end
    if myranking ~= nil then
      msg.myranking = myranking
    end
    if mycount ~= nil then
      msg.mycount = mycount
    end
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
    local msgId = ProtoReqInfoList.TaiwanRankLisaCmd.id
    local msgParam = {}
    if pageindex ~= nil then
      msgParam.pageindex = pageindex
    end
    if pagecount ~= nil then
      msgParam.pagecount = pagecount
    end
    if myranking ~= nil then
      msgParam.myranking = myranking
    end
    if mycount ~= nil then
      msgParam.mycount = mycount
    end
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

function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasChargeLimitGetChargeCmd(charge)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.OverseasChargeLimitGetChargeCmd()
    if charge ~= nil then
      msg.charge = charge
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OverseasChargeLimitGetChargeCmd.id
    local msgParam = {}
    if charge ~= nil then
      msgParam.charge = charge
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasGoeItemAddCmd(uid, content, platform, pid, num, amt, ptype, note, date)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.OverseasGoeItemAddCmd()
    if uid ~= nil then
      msg.uid = uid
    end
    if content ~= nil then
      msg.content = content
    end
    if platform ~= nil then
      msg.platform = platform
    end
    if pid ~= nil then
      msg.pid = pid
    end
    if num ~= nil then
      msg.num = num
    end
    if amt ~= nil then
      msg.amt = amt
    end
    if ptype ~= nil then
      msg.ptype = ptype
    end
    if note ~= nil then
      msg.note = note
    end
    if date ~= nil then
      msg.date = date
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OverseasGoeItemAddCmd.id
    local msgParam = {}
    if uid ~= nil then
      msgParam.uid = uid
    end
    if content ~= nil then
      msgParam.content = content
    end
    if platform ~= nil then
      msgParam.platform = platform
    end
    if pid ~= nil then
      msgParam.pid = pid
    end
    if num ~= nil then
      msgParam.num = num
    end
    if amt ~= nil then
      msgParam.amt = amt
    end
    if ptype ~= nil then
      msgParam.ptype = ptype
    end
    if note ~= nil then
      msgParam.note = note
    end
    if date ~= nil then
      msgParam.date = date
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasGoeItemUseCmd(uid, content, platform, pid, num, numf, utype, acquiree, note, date)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.OverseasGoeItemUseCmd()
    if uid ~= nil then
      msg.uid = uid
    end
    if content ~= nil then
      msg.content = content
    end
    if platform ~= nil then
      msg.platform = platform
    end
    if pid ~= nil then
      msg.pid = pid
    end
    if num ~= nil then
      msg.num = num
    end
    if numf ~= nil then
      msg.numf = numf
    end
    if utype ~= nil then
      msg.utype = utype
    end
    if acquiree ~= nil then
      msg.acquiree = acquiree
    end
    if note ~= nil then
      msg.note = note
    end
    if date ~= nil then
      msg.date = date
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OverseasGoeItemUseCmd.id
    local msgParam = {}
    if uid ~= nil then
      msgParam.uid = uid
    end
    if content ~= nil then
      msgParam.content = content
    end
    if platform ~= nil then
      msgParam.platform = platform
    end
    if pid ~= nil then
      msgParam.pid = pid
    end
    if num ~= nil then
      msgParam.num = num
    end
    if numf ~= nil then
      msgParam.numf = numf
    end
    if utype ~= nil then
      msgParam.utype = utype
    end
    if acquiree ~= nil then
      msgParam.acquiree = acquiree
    end
    if note ~= nil then
      msgParam.note = note
    end
    if date ~= nil then
      msgParam.date = date
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasGoePurchaseCmd(uid, content, platform, pid, num, amt, receipt, date)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.OverseasGoePurchaseCmd()
    if uid ~= nil then
      msg.uid = uid
    end
    if content ~= nil then
      msg.content = content
    end
    if platform ~= nil then
      msg.platform = platform
    end
    if pid ~= nil then
      msg.pid = pid
    end
    if num ~= nil then
      msg.num = num
    end
    if amt ~= nil then
      msg.amt = amt
    end
    if receipt ~= nil then
      msg.receipt = receipt
    end
    if date ~= nil then
      msg.date = date
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OverseasGoePurchaseCmd.id
    local msgParam = {}
    if uid ~= nil then
      msgParam.uid = uid
    end
    if content ~= nil then
      msgParam.content = content
    end
    if platform ~= nil then
      msgParam.platform = platform
    end
    if pid ~= nil then
      msgParam.pid = pid
    end
    if num ~= nil then
      msgParam.num = num
    end
    if amt ~= nil then
      msgParam.amt = amt
    end
    if receipt ~= nil then
      msgParam.receipt = receipt
    end
    if date ~= nil then
      msgParam.date = date
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:CallFirebaseNotifyUpdateCmd(open)
  if not NetConfig.PBC then
    local msg = OverseasTaiwanCmd_pb.FirebaseNotifyUpdateCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FirebaseNotifyUpdateCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbLikeProgressCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeProgressCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbLikeUserRedeemCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasPhotoUploadCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasPhotoPathPrefixCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasPhotoPathPrefixCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbShareProgressCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbShareProgressCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbShareRedeemCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbShareRedeemCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanMagicLiziCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanMagicLiziCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanRankLisaCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanRankLisaCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasChargeLimitGetChargeCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasGoeItemAddCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasGoeItemAddCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasGoeItemUseCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasGoeItemUseCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasGoePurchaseCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasGoePurchaseCmd, data)
end

function ServiceOverseasTaiwanCmdAutoProxy:RecvFirebaseNotifyUpdateCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdFirebaseNotifyUpdateCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeProgressCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbLikeProgressCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd"
ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd = "ServiceEvent_OverseasTaiwanCmdOverseasPhotoUploadCmd"
ServiceEvent.OverseasTaiwanCmdOverseasPhotoPathPrefixCmd = "ServiceEvent_OverseasTaiwanCmdOverseasPhotoPathPrefixCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanFbShareProgressCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbShareProgressCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanFbShareRedeemCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbShareRedeemCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanMagicLiziCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanMagicLiziCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanRankLisaCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanRankLisaCmd"
ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd = "ServiceEvent_OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd"
ServiceEvent.OverseasTaiwanCmdOverseasGoeItemAddCmd = "ServiceEvent_OverseasTaiwanCmdOverseasGoeItemAddCmd"
ServiceEvent.OverseasTaiwanCmdOverseasGoeItemUseCmd = "ServiceEvent_OverseasTaiwanCmdOverseasGoeItemUseCmd"
ServiceEvent.OverseasTaiwanCmdOverseasGoePurchaseCmd = "ServiceEvent_OverseasTaiwanCmdOverseasGoePurchaseCmd"
ServiceEvent.OverseasTaiwanCmdFirebaseNotifyUpdateCmd = "ServiceEvent_OverseasTaiwanCmdFirebaseNotifyUpdateCmd"
