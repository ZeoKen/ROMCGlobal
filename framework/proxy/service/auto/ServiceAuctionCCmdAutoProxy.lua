ServiceAuctionCCmdAutoProxy = class("ServiceAuctionCCmdAutoProxy", ServiceProxy)
ServiceAuctionCCmdAutoProxy.Instance = nil
ServiceAuctionCCmdAutoProxy.NAME = "ServiceAuctionCCmdAutoProxy"

function ServiceAuctionCCmdAutoProxy:ctor(proxyName)
  if ServiceAuctionCCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAuctionCCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAuctionCCmdAutoProxy.Instance = self
  end
end

function ServiceAuctionCCmdAutoProxy:Init()
end

function ServiceAuctionCCmdAutoProxy:onRegister()
  self:Listen(63, 1, function(data)
    self:RecvNtfAuctionStateCCmd(data)
  end)
  self:Listen(63, 2, function(data)
    self:RecvOpenAuctionPanelCCmd(data)
  end)
  self:Listen(63, 3, function(data)
    self:RecvNtfSignUpInfoCCmd(data)
  end)
  self:Listen(63, 14, function(data)
    self:RecvNtfMySignUpInfoCCmd(data)
  end)
  self:Listen(63, 12, function(data)
    self:RecvSignUpItemCCmd(data)
  end)
  self:Listen(63, 4, function(data)
    self:RecvNtfAuctionInfoCCmd(data)
  end)
  self:Listen(63, 5, function(data)
    self:RecvUpdateAuctionInfoCCmd(data)
  end)
  self:Listen(63, 6, function(data)
    self:RecvReqAuctionFlowingWaterCCmd(data)
  end)
  self:Listen(63, 7, function(data)
    self:RecvUpdateAuctionFlowingWaterCCmd(data)
  end)
  self:Listen(63, 8, function(data)
    self:RecvReqLastAuctionInfoCCmd(data)
  end)
  self:Listen(63, 9, function(data)
    self:RecvOfferPriceCCmd(data)
  end)
  self:Listen(63, 10, function(data)
    self:RecvReqAuctionRecordCCmd(data)
  end)
  self:Listen(63, 11, function(data)
    self:RecvTakeAuctionRecordCCmd(data)
  end)
  self:Listen(63, 13, function(data)
    self:RecvNtfCanTakeCntCCmd(data)
  end)
  self:Listen(63, 15, function(data)
    self:RecvNtfMyOfferPriceCCmd(data)
  end)
  self:Listen(63, 16, function(data)
    self:RecvNtfNextAuctionInfoCCmd(data)
  end)
  self:Listen(63, 17, function(data)
    self:RecvReqAuctionInfoCCmd(data)
  end)
  self:Listen(63, 18, function(data)
    self:RecvNtfCurAuctionInfoCCmd(data)
  end)
  self:Listen(63, 19, function(data)
    self:RecvNtfOverTakePriceCCmd(data)
  end)
  self:Listen(63, 20, function(data)
    self:RecvReqMyTradedPriceCCmd(data)
  end)
  self:Listen(63, 21, function(data)
    self:RecvNtfMaskPriceCCmd(data)
  end)
  self:Listen(63, 22, function(data)
    self:RecvAuctionDialogCCmd(data)
  end)
end

function ServiceAuctionCCmdAutoProxy:CallNtfAuctionStateCCmd(state, batchid, auctiontime, delay)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfAuctionStateCCmd()
    if state ~= nil then
      msg.state = state
    end
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if auctiontime ~= nil then
      msg.auctiontime = auctiontime
    end
    if delay ~= nil then
      msg.delay = delay
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfAuctionStateCCmd.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if auctiontime ~= nil then
      msgParam.auctiontime = auctiontime
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallOpenAuctionPanelCCmd(open)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.OpenAuctionPanelCCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenAuctionPanelCCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfSignUpInfoCCmd(iteminfos)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfSignUpInfoCCmd()
    if iteminfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfos == nil then
        msg.iteminfos = {}
      end
      for i = 1, #iteminfos do
        table.insert(msg.iteminfos, iteminfos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfSignUpInfoCCmd.id
    local msgParam = {}
    if iteminfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfos == nil then
        msgParam.iteminfos = {}
      end
      for i = 1, #iteminfos do
        table.insert(msgParam.iteminfos, iteminfos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfMySignUpInfoCCmd(signuped)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfMySignUpInfoCCmd()
    if signuped ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.signuped == nil then
        msg.signuped = {}
      end
      for i = 1, #signuped do
        table.insert(msg.signuped, signuped[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfMySignUpInfoCCmd.id
    local msgParam = {}
    if signuped ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.signuped == nil then
        msgParam.signuped = {}
      end
      for i = 1, #signuped do
        table.insert(msgParam.signuped, signuped[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallSignUpItemCCmd(iteminfo, ret, guid)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.SignUpItemCCmd()
    if iteminfo ~= nil and iteminfo.itemid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.itemid = iteminfo.itemid
    end
    if iteminfo ~= nil and iteminfo.price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.price = iteminfo.price
    end
    if iteminfo ~= nil and iteminfo.auction ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.auction = iteminfo.auction
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SignUpItemCCmd.id
    local msgParam = {}
    if iteminfo ~= nil and iteminfo.itemid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.itemid = iteminfo.itemid
    end
    if iteminfo ~= nil and iteminfo.price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.price = iteminfo.price
    end
    if iteminfo ~= nil and iteminfo.auction ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.auction = iteminfo.auction
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfAuctionInfoCCmd(iteminfos, batchid, serverid)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfAuctionInfoCCmd()
    if iteminfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfos == nil then
        msg.iteminfos = {}
      end
      for i = 1, #iteminfos do
        table.insert(msg.iteminfos, iteminfos[i])
      end
    end
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfAuctionInfoCCmd.id
    local msgParam = {}
    if iteminfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfos == nil then
        msgParam.iteminfos = {}
      end
      for i = 1, #iteminfos do
        table.insert(msgParam.iteminfos, iteminfos[i])
      end
    end
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallUpdateAuctionInfoCCmd(iteminfo, batchid)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.UpdateAuctionInfoCCmd()
    if iteminfo ~= nil and iteminfo.itemid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.itemid = iteminfo.itemid
    end
    if iteminfo ~= nil and iteminfo.price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.price = iteminfo.price
    end
    if iteminfo ~= nil and iteminfo.seller ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.seller = iteminfo.seller
    end
    if iteminfo ~= nil and iteminfo.sellerid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.sellerid = iteminfo.sellerid
    end
    if iteminfo ~= nil and iteminfo.result ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.result = iteminfo.result
    end
    if iteminfo ~= nil and iteminfo.people_cnt ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.people_cnt = iteminfo.people_cnt
    end
    if iteminfo ~= nil and iteminfo.trade_price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.trade_price = iteminfo.trade_price
    end
    if iteminfo ~= nil and iteminfo.auction_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.auction_time = iteminfo.auction_time
    end
    if iteminfo ~= nil and iteminfo.my_price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.my_price = iteminfo.my_price
    end
    if iteminfo ~= nil and iteminfo.cur_price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.cur_price = iteminfo.cur_price
    end
    if iteminfo ~= nil and iteminfo.mask_price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.mask_price = iteminfo.mask_price
    end
    if iteminfo ~= nil and iteminfo.signup_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      msg.iteminfo.signup_id = iteminfo.signup_id
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.guid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.guid = iteminfo.itemdata.base.guid
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.id = iteminfo.itemdata.base.id
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.count ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.count = iteminfo.itemdata.base.count
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.index ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.index = iteminfo.itemdata.base.index
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.createtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.createtime = iteminfo.itemdata.base.createtime
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.cd ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.cd = iteminfo.itemdata.base.cd
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.type ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.type = iteminfo.itemdata.base.type
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.bind ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.bind = iteminfo.itemdata.base.bind
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.expire ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.expire = iteminfo.itemdata.base.expire
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.quality ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.quality = iteminfo.itemdata.base.quality
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.equipType ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.equipType = iteminfo.itemdata.base.equipType
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.source ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.source = iteminfo.itemdata.base.source
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isnew ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.isnew = iteminfo.itemdata.base.isnew
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.maxcardslot ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.maxcardslot = iteminfo.itemdata.base.maxcardslot
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.ishint ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.ishint = iteminfo.itemdata.base.ishint
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isactive ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.isactive = iteminfo.itemdata.base.isactive
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.source_npc ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.source_npc = iteminfo.itemdata.base.source_npc
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.refinelv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.refinelv = iteminfo.itemdata.base.refinelv
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.chargemoney ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.chargemoney = iteminfo.itemdata.base.chargemoney
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.overtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.overtime = iteminfo.itemdata.base.overtime
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.quota ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.quota = iteminfo.itemdata.base.quota
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.usedtimes ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.usedtimes = iteminfo.itemdata.base.usedtimes
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.usedtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.usedtime = iteminfo.itemdata.base.usedtime
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isfavorite ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.isfavorite = iteminfo.itemdata.base.isfavorite
    end
    if iteminfo ~= nil and iteminfo.itemdata.base.mailhint ~= nil then
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      if msg.iteminfo.itemdata.base.mailhint == nil then
        msg.iteminfo.itemdata.base.mailhint = {}
      end
      for i = 1, #iteminfo.itemdata.base.mailhint do
        table.insert(msg.iteminfo.itemdata.base.mailhint, iteminfo.itemdata.base.mailhint[i])
      end
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.subsource ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.subsource = iteminfo.itemdata.base.subsource
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.randkey ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.randkey = iteminfo.itemdata.base.randkey
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.sceneinfo ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.sceneinfo = iteminfo.itemdata.base.sceneinfo
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.local_charge ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.local_charge = iteminfo.itemdata.base.local_charge
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.charge_deposit_id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.charge_deposit_id = iteminfo.itemdata.base.charge_deposit_id
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.issplit ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.issplit = iteminfo.itemdata.base.issplit
    end
    if iteminfo.itemdata.base.tmp ~= nil and iteminfo.itemdata.base.tmp.none ~= nil then
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      if msg.iteminfo.itemdata.base.tmp == nil then
        msg.iteminfo.itemdata.base.tmp = {}
      end
      msg.iteminfo.itemdata.base.tmp.none = iteminfo.itemdata.base.tmp.none
    end
    if iteminfo.itemdata.base.tmp ~= nil and iteminfo.itemdata.base.tmp.num_param ~= nil then
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      if msg.iteminfo.itemdata.base.tmp == nil then
        msg.iteminfo.itemdata.base.tmp = {}
      end
      msg.iteminfo.itemdata.base.tmp.num_param = iteminfo.itemdata.base.tmp.num_param
    end
    if iteminfo.itemdata.base.tmp ~= nil and iteminfo.itemdata.base.tmp.from_reward ~= nil then
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      if msg.iteminfo.itemdata.base.tmp == nil then
        msg.iteminfo.itemdata.base.tmp = {}
      end
      msg.iteminfo.itemdata.base.tmp.from_reward = iteminfo.itemdata.base.tmp.from_reward
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.mount_fashion_activated ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.mount_fashion_activated = iteminfo.itemdata.base.mount_fashion_activated
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.no_trade_reason ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      msg.iteminfo.itemdata.base.no_trade_reason = iteminfo.itemdata.base.no_trade_reason
    end
    if iteminfo.itemdata.base.card_info ~= nil and iteminfo.itemdata.base.card_info.lv ~= nil then
      if msg.iteminfo.itemdata.base == nil then
        msg.iteminfo.itemdata.base = {}
      end
      if msg.iteminfo.itemdata.base.card_info == nil then
        msg.iteminfo.itemdata.base.card_info = {}
      end
      msg.iteminfo.itemdata.base.card_info.lv = iteminfo.itemdata.base.card_info.lv
    end
    if iteminfo.itemdata ~= nil and iteminfo.itemdata.equiped ~= nil then
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      msg.iteminfo.itemdata.equiped = iteminfo.itemdata.equiped
    end
    if iteminfo.itemdata ~= nil and iteminfo.itemdata.battlepoint ~= nil then
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      msg.iteminfo.itemdata.battlepoint = iteminfo.itemdata.battlepoint
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthlv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.strengthlv = iteminfo.itemdata.equip.strengthlv
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.refinelv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.refinelv = iteminfo.itemdata.equip.refinelv
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthCost ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.strengthCost = iteminfo.itemdata.equip.strengthCost
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.refineCompose ~= nil then
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      if msg.iteminfo.itemdata.equip.refineCompose == nil then
        msg.iteminfo.itemdata.equip.refineCompose = {}
      end
      for i = 1, #iteminfo.itemdata.equip.refineCompose do
        table.insert(msg.iteminfo.itemdata.equip.refineCompose, iteminfo.itemdata.equip.refineCompose[i])
      end
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.cardslot ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.cardslot = iteminfo.itemdata.equip.cardslot
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.buffid ~= nil then
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      if msg.iteminfo.itemdata.equip.buffid == nil then
        msg.iteminfo.itemdata.equip.buffid = {}
      end
      for i = 1, #iteminfo.itemdata.equip.buffid do
        table.insert(msg.iteminfo.itemdata.equip.buffid, iteminfo.itemdata.equip.buffid[i])
      end
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.damage ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.damage = iteminfo.itemdata.equip.damage
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.lv = iteminfo.itemdata.equip.lv
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.color ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.color = iteminfo.itemdata.equip.color
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.breakstarttime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.breakstarttime = iteminfo.itemdata.equip.breakstarttime
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.breakendtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.breakendtime = iteminfo.itemdata.equip.breakendtime
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthlv2 ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.strengthlv2 = iteminfo.itemdata.equip.strengthlv2
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.quenchper ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.quenchper = iteminfo.itemdata.equip.quenchper
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.strengthlv2cost ~= nil then
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      if msg.iteminfo.itemdata.equip.strengthlv2cost == nil then
        msg.iteminfo.itemdata.equip.strengthlv2cost = {}
      end
      for i = 1, #iteminfo.itemdata.equip.strengthlv2cost do
        table.insert(msg.iteminfo.itemdata.equip.strengthlv2cost, iteminfo.itemdata.equip.strengthlv2cost[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.attrs ~= nil then
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      if msg.iteminfo.itemdata.equip.attrs == nil then
        msg.iteminfo.itemdata.equip.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.equip.attrs do
        table.insert(msg.iteminfo.itemdata.equip.attrs, iteminfo.itemdata.equip.attrs[i])
      end
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.extra_refine_value ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.equip == nil then
        msg.iteminfo.itemdata.equip = {}
      end
      msg.iteminfo.itemdata.equip.extra_refine_value = iteminfo.itemdata.equip.extra_refine_value
    end
    if iteminfo ~= nil and iteminfo.itemdata.card ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.card == nil then
        msg.iteminfo.itemdata.card = {}
      end
      for i = 1, #iteminfo.itemdata.card do
        table.insert(msg.iteminfo.itemdata.card, iteminfo.itemdata.card[i])
      end
    end
    if iteminfo.itemdata.enchant ~= nil and iteminfo.itemdata.enchant.type ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.enchant == nil then
        msg.iteminfo.itemdata.enchant = {}
      end
      msg.iteminfo.itemdata.enchant.type = iteminfo.itemdata.enchant.type
    end
    if iteminfo ~= nil and iteminfo.itemdata.enchant.attrs ~= nil then
      if msg.iteminfo.itemdata.enchant == nil then
        msg.iteminfo.itemdata.enchant = {}
      end
      if msg.iteminfo.itemdata.enchant.attrs == nil then
        msg.iteminfo.itemdata.enchant.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.enchant.attrs do
        table.insert(msg.iteminfo.itemdata.enchant.attrs, iteminfo.itemdata.enchant.attrs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.enchant.extras ~= nil then
      if msg.iteminfo.itemdata.enchant == nil then
        msg.iteminfo.itemdata.enchant = {}
      end
      if msg.iteminfo.itemdata.enchant.extras == nil then
        msg.iteminfo.itemdata.enchant.extras = {}
      end
      for i = 1, #iteminfo.itemdata.enchant.extras do
        table.insert(msg.iteminfo.itemdata.enchant.extras, iteminfo.itemdata.enchant.extras[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.enchant.patch ~= nil then
      if msg.iteminfo.itemdata.enchant == nil then
        msg.iteminfo.itemdata.enchant = {}
      end
      if msg.iteminfo.itemdata.enchant.patch == nil then
        msg.iteminfo.itemdata.enchant.patch = {}
      end
      for i = 1, #iteminfo.itemdata.enchant.patch do
        table.insert(msg.iteminfo.itemdata.enchant.patch, iteminfo.itemdata.enchant.patch[i])
      end
    end
    if iteminfo.itemdata.enchant ~= nil and iteminfo.itemdata.enchant.israteup ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.enchant == nil then
        msg.iteminfo.itemdata.enchant = {}
      end
      msg.iteminfo.itemdata.enchant.israteup = iteminfo.itemdata.enchant.israteup
    end
    if iteminfo.itemdata.prenchant ~= nil and iteminfo.itemdata.prenchant.type ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.prenchant == nil then
        msg.iteminfo.itemdata.prenchant = {}
      end
      msg.iteminfo.itemdata.prenchant.type = iteminfo.itemdata.prenchant.type
    end
    if iteminfo ~= nil and iteminfo.itemdata.prenchant.attrs ~= nil then
      if msg.iteminfo.itemdata.prenchant == nil then
        msg.iteminfo.itemdata.prenchant = {}
      end
      if msg.iteminfo.itemdata.prenchant.attrs == nil then
        msg.iteminfo.itemdata.prenchant.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.prenchant.attrs do
        table.insert(msg.iteminfo.itemdata.prenchant.attrs, iteminfo.itemdata.prenchant.attrs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.prenchant.extras ~= nil then
      if msg.iteminfo.itemdata.prenchant == nil then
        msg.iteminfo.itemdata.prenchant = {}
      end
      if msg.iteminfo.itemdata.prenchant.extras == nil then
        msg.iteminfo.itemdata.prenchant.extras = {}
      end
      for i = 1, #iteminfo.itemdata.prenchant.extras do
        table.insert(msg.iteminfo.itemdata.prenchant.extras, iteminfo.itemdata.prenchant.extras[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.prenchant.patch ~= nil then
      if msg.iteminfo.itemdata.prenchant == nil then
        msg.iteminfo.itemdata.prenchant = {}
      end
      if msg.iteminfo.itemdata.prenchant.patch == nil then
        msg.iteminfo.itemdata.prenchant.patch = {}
      end
      for i = 1, #iteminfo.itemdata.prenchant.patch do
        table.insert(msg.iteminfo.itemdata.prenchant.patch, iteminfo.itemdata.prenchant.patch[i])
      end
    end
    if iteminfo.itemdata.prenchant ~= nil and iteminfo.itemdata.prenchant.israteup ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.prenchant == nil then
        msg.iteminfo.itemdata.prenchant = {}
      end
      msg.iteminfo.itemdata.prenchant.israteup = iteminfo.itemdata.prenchant.israteup
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.lastfail ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.refine == nil then
        msg.iteminfo.itemdata.refine = {}
      end
      msg.iteminfo.itemdata.refine.lastfail = iteminfo.itemdata.refine.lastfail
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.repaircount ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.refine == nil then
        msg.iteminfo.itemdata.refine = {}
      end
      msg.iteminfo.itemdata.refine.repaircount = iteminfo.itemdata.refine.repaircount
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.lastfailcount ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.refine == nil then
        msg.iteminfo.itemdata.refine = {}
      end
      msg.iteminfo.itemdata.refine.lastfailcount = iteminfo.itemdata.refine.lastfailcount
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.history_fix_rate ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.refine == nil then
        msg.iteminfo.itemdata.refine = {}
      end
      msg.iteminfo.itemdata.refine.history_fix_rate = iteminfo.itemdata.refine.history_fix_rate
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.cost_count ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.refine == nil then
        msg.iteminfo.itemdata.refine = {}
      end
      msg.iteminfo.itemdata.refine.cost_count = iteminfo.itemdata.refine.cost_count
    end
    if iteminfo ~= nil and iteminfo.itemdata.refine.cost_counts ~= nil then
      if msg.iteminfo.itemdata.refine == nil then
        msg.iteminfo.itemdata.refine = {}
      end
      if msg.iteminfo.itemdata.refine.cost_counts == nil then
        msg.iteminfo.itemdata.refine.cost_counts = {}
      end
      for i = 1, #iteminfo.itemdata.refine.cost_counts do
        table.insert(msg.iteminfo.itemdata.refine.cost_counts, iteminfo.itemdata.refine.cost_counts[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.exp ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.exp = iteminfo.itemdata.egg.exp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.friendexp ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.friendexp = iteminfo.itemdata.egg.friendexp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.rewardexp ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.rewardexp = iteminfo.itemdata.egg.rewardexp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.id = iteminfo.itemdata.egg.id
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.lv = iteminfo.itemdata.egg.lv
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.friendlv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.friendlv = iteminfo.itemdata.egg.friendlv
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.body ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.body = iteminfo.itemdata.egg.body
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.relivetime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.relivetime = iteminfo.itemdata.egg.relivetime
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.hp ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.hp = iteminfo.itemdata.egg.hp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.restoretime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.restoretime = iteminfo.itemdata.egg.restoretime
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happly ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.time_happly = iteminfo.itemdata.egg.time_happly
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_excite ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.time_excite = iteminfo.itemdata.egg.time_excite
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happiness ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.time_happiness = iteminfo.itemdata.egg.time_happiness
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happly_gift ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.time_happly_gift = iteminfo.itemdata.egg.time_happly_gift
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_excite_gift ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.time_excite_gift = iteminfo.itemdata.egg.time_excite_gift
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happiness_gift ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.time_happiness_gift = iteminfo.itemdata.egg.time_happiness_gift
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.touch_tick ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.touch_tick = iteminfo.itemdata.egg.touch_tick
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.feed_tick ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.feed_tick = iteminfo.itemdata.egg.feed_tick
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.name ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.name = iteminfo.itemdata.egg.name
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.var ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.var = iteminfo.itemdata.egg.var
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.skillids ~= nil then
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      if msg.iteminfo.itemdata.egg.skillids == nil then
        msg.iteminfo.itemdata.egg.skillids = {}
      end
      for i = 1, #iteminfo.itemdata.egg.skillids do
        table.insert(msg.iteminfo.itemdata.egg.skillids, iteminfo.itemdata.egg.skillids[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.equips ~= nil then
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      if msg.iteminfo.itemdata.egg.equips == nil then
        msg.iteminfo.itemdata.egg.equips = {}
      end
      for i = 1, #iteminfo.itemdata.egg.equips do
        table.insert(msg.iteminfo.itemdata.egg.equips, iteminfo.itemdata.egg.equips[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.buff ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.buff = iteminfo.itemdata.egg.buff
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.unlock_equip ~= nil then
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      if msg.iteminfo.itemdata.egg.unlock_equip == nil then
        msg.iteminfo.itemdata.egg.unlock_equip = {}
      end
      for i = 1, #iteminfo.itemdata.egg.unlock_equip do
        table.insert(msg.iteminfo.itemdata.egg.unlock_equip, iteminfo.itemdata.egg.unlock_equip[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.unlock_body ~= nil then
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      if msg.iteminfo.itemdata.egg.unlock_body == nil then
        msg.iteminfo.itemdata.egg.unlock_body = {}
      end
      for i = 1, #iteminfo.itemdata.egg.unlock_body do
        table.insert(msg.iteminfo.itemdata.egg.unlock_body, iteminfo.itemdata.egg.unlock_body[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.version ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.version = iteminfo.itemdata.egg.version
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.skilloff ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.skilloff = iteminfo.itemdata.egg.skilloff
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.exchange_count ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.exchange_count = iteminfo.itemdata.egg.exchange_count
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.guid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.guid = iteminfo.itemdata.egg.guid
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.defaultwears ~= nil then
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      if msg.iteminfo.itemdata.egg.defaultwears == nil then
        msg.iteminfo.itemdata.egg.defaultwears = {}
      end
      for i = 1, #iteminfo.itemdata.egg.defaultwears do
        table.insert(msg.iteminfo.itemdata.egg.defaultwears, iteminfo.itemdata.egg.defaultwears[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.wears ~= nil then
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      if msg.iteminfo.itemdata.egg.wears == nil then
        msg.iteminfo.itemdata.egg.wears = {}
      end
      for i = 1, #iteminfo.itemdata.egg.wears do
        table.insert(msg.iteminfo.itemdata.egg.wears, iteminfo.itemdata.egg.wears[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.cdtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.egg == nil then
        msg.iteminfo.itemdata.egg = {}
      end
      msg.iteminfo.itemdata.egg.cdtime = iteminfo.itemdata.egg.cdtime
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.sendUserName ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.letter == nil then
        msg.iteminfo.itemdata.letter = {}
      end
      msg.iteminfo.itemdata.letter.sendUserName = iteminfo.itemdata.letter.sendUserName
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.bg ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.letter == nil then
        msg.iteminfo.itemdata.letter = {}
      end
      msg.iteminfo.itemdata.letter.bg = iteminfo.itemdata.letter.bg
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.configID ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.letter == nil then
        msg.iteminfo.itemdata.letter = {}
      end
      msg.iteminfo.itemdata.letter.configID = iteminfo.itemdata.letter.configID
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.content ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.letter == nil then
        msg.iteminfo.itemdata.letter = {}
      end
      msg.iteminfo.itemdata.letter.content = iteminfo.itemdata.letter.content
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.content2 ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.letter == nil then
        msg.iteminfo.itemdata.letter = {}
      end
      msg.iteminfo.itemdata.letter.content2 = iteminfo.itemdata.letter.content2
    end
    if iteminfo.itemdata.code ~= nil and iteminfo.itemdata.code.code ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.code == nil then
        msg.iteminfo.itemdata.code = {}
      end
      msg.iteminfo.itemdata.code.code = iteminfo.itemdata.code.code
    end
    if iteminfo.itemdata.code ~= nil and iteminfo.itemdata.code.used ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.code == nil then
        msg.iteminfo.itemdata.code = {}
      end
      msg.iteminfo.itemdata.code.used = iteminfo.itemdata.code.used
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.id = iteminfo.itemdata.wedding.id
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.zoneid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.zoneid = iteminfo.itemdata.wedding.zoneid
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.charid1 ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.charid1 = iteminfo.itemdata.wedding.charid1
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.charid2 ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.charid2 = iteminfo.itemdata.wedding.charid2
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.weddingtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.weddingtime = iteminfo.itemdata.wedding.weddingtime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.photoidx ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.photoidx = iteminfo.itemdata.wedding.photoidx
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.phototime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.phototime = iteminfo.itemdata.wedding.phototime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.myname ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.myname = iteminfo.itemdata.wedding.myname
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.partnername ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.partnername = iteminfo.itemdata.wedding.partnername
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.starttime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.starttime = iteminfo.itemdata.wedding.starttime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.endtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.endtime = iteminfo.itemdata.wedding.endtime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.notified ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.wedding == nil then
        msg.iteminfo.itemdata.wedding = {}
      end
      msg.iteminfo.itemdata.wedding.notified = iteminfo.itemdata.wedding.notified
    end
    if iteminfo.itemdata.sender ~= nil and iteminfo.itemdata.sender.charid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.sender == nil then
        msg.iteminfo.itemdata.sender = {}
      end
      msg.iteminfo.itemdata.sender.charid = iteminfo.itemdata.sender.charid
    end
    if iteminfo.itemdata.sender ~= nil and iteminfo.itemdata.sender.name ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.sender == nil then
        msg.iteminfo.itemdata.sender = {}
      end
      msg.iteminfo.itemdata.sender.name = iteminfo.itemdata.sender.name
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.id = iteminfo.itemdata.furniture.id
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.angle ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.angle = iteminfo.itemdata.furniture.angle
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.lv = iteminfo.itemdata.furniture.lv
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.row ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.row = iteminfo.itemdata.furniture.row
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.col ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.col = iteminfo.itemdata.furniture.col
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.floor ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.floor = iteminfo.itemdata.furniture.floor
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.rewardtime ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.rewardtime = iteminfo.itemdata.furniture.rewardtime
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.state ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.state = iteminfo.itemdata.furniture.state
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.guid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.guid = iteminfo.itemdata.furniture.guid
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.old_guid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.old_guid = iteminfo.itemdata.furniture.old_guid
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.var ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      msg.iteminfo.itemdata.furniture.var = iteminfo.itemdata.furniture.var
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.seats ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.seats == nil then
        msg.iteminfo.itemdata.furniture.seats = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.seats do
        table.insert(msg.iteminfo.itemdata.furniture.seats, iteminfo.itemdata.furniture.seats[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.seatskills ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.seatskills == nil then
        msg.iteminfo.itemdata.furniture.seatskills = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.seatskills do
        table.insert(msg.iteminfo.itemdata.furniture.seatskills, iteminfo.itemdata.furniture.seatskills[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.photos ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.photos == nil then
        msg.iteminfo.itemdata.furniture.photos = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.photos do
        table.insert(msg.iteminfo.itemdata.furniture.photos, iteminfo.itemdata.furniture.photos[i])
      end
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.race ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.race = iteminfo.itemdata.furniture.npc.race
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.shape ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.shape = iteminfo.itemdata.furniture.npc.shape
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.nature ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.nature = iteminfo.itemdata.furniture.npc.nature
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.hpreduce ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.hpreduce = iteminfo.itemdata.furniture.npc.hpreduce
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.naturelv ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.naturelv = iteminfo.itemdata.furniture.npc.naturelv
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.npc.history_max ~= nil then
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      if msg.iteminfo.itemdata.furniture.npc.history_max == nil then
        msg.iteminfo.itemdata.furniture.npc.history_max = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.npc.history_max do
        table.insert(msg.iteminfo.itemdata.furniture.npc.history_max, iteminfo.itemdata.furniture.npc.history_max[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.npc.day_max ~= nil then
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      if msg.iteminfo.itemdata.furniture.npc.day_max == nil then
        msg.iteminfo.itemdata.furniture.npc.day_max = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.npc.day_max do
        table.insert(msg.iteminfo.itemdata.furniture.npc.day_max, iteminfo.itemdata.furniture.npc.day_max[i])
      end
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.bosstype ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.bosstype = iteminfo.itemdata.furniture.npc.bosstype
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.wood_type ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.wood_type = iteminfo.itemdata.furniture.npc.wood_type
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.monster_id ~= nil then
      if msg.iteminfo.itemdata.furniture == nil then
        msg.iteminfo.itemdata.furniture = {}
      end
      if msg.iteminfo.itemdata.furniture.npc == nil then
        msg.iteminfo.itemdata.furniture.npc = {}
      end
      msg.iteminfo.itemdata.furniture.npc.monster_id = iteminfo.itemdata.furniture.npc.monster_id
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.attr == nil then
        msg.iteminfo.itemdata.attr = {}
      end
      msg.iteminfo.itemdata.attr.id = iteminfo.itemdata.attr.id
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.attr == nil then
        msg.iteminfo.itemdata.attr = {}
      end
      msg.iteminfo.itemdata.attr.lv = iteminfo.itemdata.attr.lv
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.exp ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.attr == nil then
        msg.iteminfo.itemdata.attr = {}
      end
      msg.iteminfo.itemdata.attr.exp = iteminfo.itemdata.attr.exp
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.pos ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.attr == nil then
        msg.iteminfo.itemdata.attr = {}
      end
      msg.iteminfo.itemdata.attr.pos = iteminfo.itemdata.attr.pos
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.time ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.attr == nil then
        msg.iteminfo.itemdata.attr = {}
      end
      msg.iteminfo.itemdata.attr.time = iteminfo.itemdata.attr.time
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.charid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.attr == nil then
        msg.iteminfo.itemdata.attr = {}
      end
      msg.iteminfo.itemdata.attr.charid = iteminfo.itemdata.attr.charid
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      msg.iteminfo.itemdata.skill.id = iteminfo.itemdata.skill.id
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.pos ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      msg.iteminfo.itemdata.skill.pos = iteminfo.itemdata.skill.pos
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.charid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      msg.iteminfo.itemdata.skill.charid = iteminfo.itemdata.skill.charid
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.issame ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      msg.iteminfo.itemdata.skill.issame = iteminfo.itemdata.skill.issame
    end
    if iteminfo ~= nil and iteminfo.itemdata.skill.buffs ~= nil then
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      if msg.iteminfo.itemdata.skill.buffs == nil then
        msg.iteminfo.itemdata.skill.buffs = {}
      end
      for i = 1, #iteminfo.itemdata.skill.buffs do
        table.insert(msg.iteminfo.itemdata.skill.buffs, iteminfo.itemdata.skill.buffs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.skill.carves ~= nil then
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      if msg.iteminfo.itemdata.skill.carves == nil then
        msg.iteminfo.itemdata.skill.carves = {}
      end
      for i = 1, #iteminfo.itemdata.skill.carves do
        table.insert(msg.iteminfo.itemdata.skill.carves, iteminfo.itemdata.skill.carves[i])
      end
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.isforbid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      msg.iteminfo.itemdata.skill.isforbid = iteminfo.itemdata.skill.isforbid
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.isfull ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.skill == nil then
        msg.iteminfo.itemdata.skill = {}
      end
      msg.iteminfo.itemdata.skill.isfull = iteminfo.itemdata.skill.isfull
    end
    if iteminfo.itemdata.home ~= nil and iteminfo.itemdata.home.ownerid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.home == nil then
        msg.iteminfo.itemdata.home = {}
      end
      msg.iteminfo.itemdata.home.ownerid = iteminfo.itemdata.home.ownerid
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.attrs ~= nil then
      if msg.iteminfo.itemdata.artifact == nil then
        msg.iteminfo.itemdata.artifact = {}
      end
      if msg.iteminfo.itemdata.artifact.attrs == nil then
        msg.iteminfo.itemdata.artifact.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.attrs do
        table.insert(msg.iteminfo.itemdata.artifact.attrs, iteminfo.itemdata.artifact.attrs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.preattrs ~= nil then
      if msg.iteminfo.itemdata.artifact == nil then
        msg.iteminfo.itemdata.artifact = {}
      end
      if msg.iteminfo.itemdata.artifact.preattrs == nil then
        msg.iteminfo.itemdata.artifact.preattrs = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.preattrs do
        table.insert(msg.iteminfo.itemdata.artifact.preattrs, iteminfo.itemdata.artifact.preattrs[i])
      end
    end
    if iteminfo.itemdata.artifact ~= nil and iteminfo.itemdata.artifact.art_state ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.artifact == nil then
        msg.iteminfo.itemdata.artifact = {}
      end
      msg.iteminfo.itemdata.artifact.art_state = iteminfo.itemdata.artifact.art_state
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.art_fragment ~= nil then
      if msg.iteminfo.itemdata.artifact == nil then
        msg.iteminfo.itemdata.artifact = {}
      end
      if msg.iteminfo.itemdata.artifact.art_fragment == nil then
        msg.iteminfo.itemdata.artifact.art_fragment = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.art_fragment do
        table.insert(msg.iteminfo.itemdata.artifact.art_fragment, iteminfo.itemdata.artifact.art_fragment[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.noattrs ~= nil then
      if msg.iteminfo.itemdata.artifact == nil then
        msg.iteminfo.itemdata.artifact = {}
      end
      if msg.iteminfo.itemdata.artifact.noattrs == nil then
        msg.iteminfo.itemdata.artifact.noattrs = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.noattrs do
        table.insert(msg.iteminfo.itemdata.artifact.noattrs, iteminfo.itemdata.artifact.noattrs[i])
      end
    end
    if iteminfo.itemdata.cupinfo ~= nil and iteminfo.itemdata.cupinfo.name ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.cupinfo == nil then
        msg.iteminfo.itemdata.cupinfo = {}
      end
      msg.iteminfo.itemdata.cupinfo.name = iteminfo.itemdata.cupinfo.name
    end
    if iteminfo ~= nil and iteminfo.itemdata.previewattr ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.previewattr == nil then
        msg.iteminfo.itemdata.previewattr = {}
      end
      for i = 1, #iteminfo.itemdata.previewattr do
        table.insert(msg.iteminfo.itemdata.previewattr, iteminfo.itemdata.previewattr[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.previewenchant ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.previewenchant == nil then
        msg.iteminfo.itemdata.previewenchant = {}
      end
      for i = 1, #iteminfo.itemdata.previewenchant do
        table.insert(msg.iteminfo.itemdata.previewenchant, iteminfo.itemdata.previewenchant[i])
      end
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.config_id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      msg.iteminfo.itemdata.red_packet.config_id = iteminfo.itemdata.red_packet.config_id
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.min_num ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      msg.iteminfo.itemdata.red_packet.min_num = iteminfo.itemdata.red_packet.min_num
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.max_num ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      msg.iteminfo.itemdata.red_packet.max_num = iteminfo.itemdata.red_packet.max_num
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.min_money ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      msg.iteminfo.itemdata.red_packet.min_money = iteminfo.itemdata.red_packet.min_money
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.max_money ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      msg.iteminfo.itemdata.red_packet.max_money = iteminfo.itemdata.red_packet.max_money
    end
    if iteminfo ~= nil and iteminfo.itemdata.red_packet.multi_items ~= nil then
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      if msg.iteminfo.itemdata.red_packet.multi_items == nil then
        msg.iteminfo.itemdata.red_packet.multi_items = {}
      end
      for i = 1, #iteminfo.itemdata.red_packet.multi_items do
        table.insert(msg.iteminfo.itemdata.red_packet.multi_items, iteminfo.itemdata.red_packet.multi_items[i])
      end
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.gvg_cityid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      msg.iteminfo.itemdata.red_packet.gvg_cityid = iteminfo.itemdata.red_packet.gvg_cityid
    end
    if iteminfo ~= nil and iteminfo.itemdata.red_packet.gvg_charids ~= nil then
      if msg.iteminfo.itemdata.red_packet == nil then
        msg.iteminfo.itemdata.red_packet = {}
      end
      if msg.iteminfo.itemdata.red_packet.gvg_charids == nil then
        msg.iteminfo.itemdata.red_packet.gvg_charids = {}
      end
      for i = 1, #iteminfo.itemdata.red_packet.gvg_charids do
        table.insert(msg.iteminfo.itemdata.red_packet.gvg_charids, iteminfo.itemdata.red_packet.gvg_charids[i])
      end
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.id ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      msg.iteminfo.itemdata.gem_secret_land.id = iteminfo.itemdata.gem_secret_land.id
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.color ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      msg.iteminfo.itemdata.gem_secret_land.color = iteminfo.itemdata.gem_secret_land.color
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      msg.iteminfo.itemdata.gem_secret_land.lv = iteminfo.itemdata.gem_secret_land.lv
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.max_lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      msg.iteminfo.itemdata.gem_secret_land.max_lv = iteminfo.itemdata.gem_secret_land.max_lv
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.exp ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      msg.iteminfo.itemdata.gem_secret_land.exp = iteminfo.itemdata.gem_secret_land.exp
    end
    if iteminfo ~= nil and iteminfo.itemdata.gem_secret_land.buffs ~= nil then
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land.buffs == nil then
        msg.iteminfo.itemdata.gem_secret_land.buffs = {}
      end
      for i = 1, #iteminfo.itemdata.gem_secret_land.buffs do
        table.insert(msg.iteminfo.itemdata.gem_secret_land.buffs, iteminfo.itemdata.gem_secret_land.buffs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.gem_secret_land.char_data ~= nil then
      if msg.iteminfo.itemdata.gem_secret_land == nil then
        msg.iteminfo.itemdata.gem_secret_land = {}
      end
      if msg.iteminfo.itemdata.gem_secret_land.char_data == nil then
        msg.iteminfo.itemdata.gem_secret_land.char_data = {}
      end
      for i = 1, #iteminfo.itemdata.gem_secret_land.char_data do
        table.insert(msg.iteminfo.itemdata.gem_secret_land.char_data, iteminfo.itemdata.gem_secret_land.char_data[i])
      end
    end
    if iteminfo.itemdata.memory ~= nil and iteminfo.itemdata.memory.itemid ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.memory == nil then
        msg.iteminfo.itemdata.memory = {}
      end
      msg.iteminfo.itemdata.memory.itemid = iteminfo.itemdata.memory.itemid
    end
    if iteminfo.itemdata.memory ~= nil and iteminfo.itemdata.memory.lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.memory == nil then
        msg.iteminfo.itemdata.memory = {}
      end
      msg.iteminfo.itemdata.memory.lv = iteminfo.itemdata.memory.lv
    end
    if iteminfo.itemdata.memory ~= nil and iteminfo.itemdata.memory.excess_lv ~= nil then
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      if msg.iteminfo.itemdata.memory == nil then
        msg.iteminfo.itemdata.memory = {}
      end
      msg.iteminfo.itemdata.memory.excess_lv = iteminfo.itemdata.memory.excess_lv
    end
    if iteminfo ~= nil and iteminfo.itemdata.memory.effects ~= nil then
      if msg.iteminfo.itemdata.memory == nil then
        msg.iteminfo.itemdata.memory = {}
      end
      if msg.iteminfo.itemdata.memory.effects == nil then
        msg.iteminfo.itemdata.memory.effects = {}
      end
      for i = 1, #iteminfo.itemdata.memory.effects do
        table.insert(msg.iteminfo.itemdata.memory.effects, iteminfo.itemdata.memory.effects[i])
      end
    end
    if iteminfo.itemdata ~= nil and iteminfo.itemdata.deletetime ~= nil then
      if msg.iteminfo == nil then
        msg.iteminfo = {}
      end
      if msg.iteminfo.itemdata == nil then
        msg.iteminfo.itemdata = {}
      end
      msg.iteminfo.itemdata.deletetime = iteminfo.itemdata.deletetime
    end
    if batchid ~= nil then
      msg.batchid = batchid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateAuctionInfoCCmd.id
    local msgParam = {}
    if iteminfo ~= nil and iteminfo.itemid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.itemid = iteminfo.itemid
    end
    if iteminfo ~= nil and iteminfo.price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.price = iteminfo.price
    end
    if iteminfo ~= nil and iteminfo.seller ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.seller = iteminfo.seller
    end
    if iteminfo ~= nil and iteminfo.sellerid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.sellerid = iteminfo.sellerid
    end
    if iteminfo ~= nil and iteminfo.result ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.result = iteminfo.result
    end
    if iteminfo ~= nil and iteminfo.people_cnt ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.people_cnt = iteminfo.people_cnt
    end
    if iteminfo ~= nil and iteminfo.trade_price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.trade_price = iteminfo.trade_price
    end
    if iteminfo ~= nil and iteminfo.auction_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.auction_time = iteminfo.auction_time
    end
    if iteminfo ~= nil and iteminfo.my_price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.my_price = iteminfo.my_price
    end
    if iteminfo ~= nil and iteminfo.cur_price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.cur_price = iteminfo.cur_price
    end
    if iteminfo ~= nil and iteminfo.mask_price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.mask_price = iteminfo.mask_price
    end
    if iteminfo ~= nil and iteminfo.signup_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      msgParam.iteminfo.signup_id = iteminfo.signup_id
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.guid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.guid = iteminfo.itemdata.base.guid
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.id = iteminfo.itemdata.base.id
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.count ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.count = iteminfo.itemdata.base.count
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.index ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.index = iteminfo.itemdata.base.index
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.createtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.createtime = iteminfo.itemdata.base.createtime
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.cd ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.cd = iteminfo.itemdata.base.cd
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.type ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.type = iteminfo.itemdata.base.type
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.bind ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.bind = iteminfo.itemdata.base.bind
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.expire ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.expire = iteminfo.itemdata.base.expire
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.quality ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.quality = iteminfo.itemdata.base.quality
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.equipType ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.equipType = iteminfo.itemdata.base.equipType
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.source ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.source = iteminfo.itemdata.base.source
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isnew ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.isnew = iteminfo.itemdata.base.isnew
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.maxcardslot ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.maxcardslot = iteminfo.itemdata.base.maxcardslot
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.ishint ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.ishint = iteminfo.itemdata.base.ishint
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isactive ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.isactive = iteminfo.itemdata.base.isactive
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.source_npc ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.source_npc = iteminfo.itemdata.base.source_npc
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.refinelv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.refinelv = iteminfo.itemdata.base.refinelv
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.chargemoney ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.chargemoney = iteminfo.itemdata.base.chargemoney
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.overtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.overtime = iteminfo.itemdata.base.overtime
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.quota ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.quota = iteminfo.itemdata.base.quota
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.usedtimes ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.usedtimes = iteminfo.itemdata.base.usedtimes
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.usedtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.usedtime = iteminfo.itemdata.base.usedtime
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.isfavorite ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.isfavorite = iteminfo.itemdata.base.isfavorite
    end
    if iteminfo ~= nil and iteminfo.itemdata.base.mailhint ~= nil then
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      if msgParam.iteminfo.itemdata.base.mailhint == nil then
        msgParam.iteminfo.itemdata.base.mailhint = {}
      end
      for i = 1, #iteminfo.itemdata.base.mailhint do
        table.insert(msgParam.iteminfo.itemdata.base.mailhint, iteminfo.itemdata.base.mailhint[i])
      end
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.subsource ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.subsource = iteminfo.itemdata.base.subsource
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.randkey ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.randkey = iteminfo.itemdata.base.randkey
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.sceneinfo ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.sceneinfo = iteminfo.itemdata.base.sceneinfo
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.local_charge ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.local_charge = iteminfo.itemdata.base.local_charge
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.charge_deposit_id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.charge_deposit_id = iteminfo.itemdata.base.charge_deposit_id
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.issplit ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.issplit = iteminfo.itemdata.base.issplit
    end
    if iteminfo.itemdata.base.tmp ~= nil and iteminfo.itemdata.base.tmp.none ~= nil then
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      if msgParam.iteminfo.itemdata.base.tmp == nil then
        msgParam.iteminfo.itemdata.base.tmp = {}
      end
      msgParam.iteminfo.itemdata.base.tmp.none = iteminfo.itemdata.base.tmp.none
    end
    if iteminfo.itemdata.base.tmp ~= nil and iteminfo.itemdata.base.tmp.num_param ~= nil then
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      if msgParam.iteminfo.itemdata.base.tmp == nil then
        msgParam.iteminfo.itemdata.base.tmp = {}
      end
      msgParam.iteminfo.itemdata.base.tmp.num_param = iteminfo.itemdata.base.tmp.num_param
    end
    if iteminfo.itemdata.base.tmp ~= nil and iteminfo.itemdata.base.tmp.from_reward ~= nil then
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      if msgParam.iteminfo.itemdata.base.tmp == nil then
        msgParam.iteminfo.itemdata.base.tmp = {}
      end
      msgParam.iteminfo.itemdata.base.tmp.from_reward = iteminfo.itemdata.base.tmp.from_reward
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.mount_fashion_activated ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.mount_fashion_activated = iteminfo.itemdata.base.mount_fashion_activated
    end
    if iteminfo.itemdata.base ~= nil and iteminfo.itemdata.base.no_trade_reason ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      msgParam.iteminfo.itemdata.base.no_trade_reason = iteminfo.itemdata.base.no_trade_reason
    end
    if iteminfo.itemdata.base.card_info ~= nil and iteminfo.itemdata.base.card_info.lv ~= nil then
      if msgParam.iteminfo.itemdata.base == nil then
        msgParam.iteminfo.itemdata.base = {}
      end
      if msgParam.iteminfo.itemdata.base.card_info == nil then
        msgParam.iteminfo.itemdata.base.card_info = {}
      end
      msgParam.iteminfo.itemdata.base.card_info.lv = iteminfo.itemdata.base.card_info.lv
    end
    if iteminfo.itemdata ~= nil and iteminfo.itemdata.equiped ~= nil then
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      msgParam.iteminfo.itemdata.equiped = iteminfo.itemdata.equiped
    end
    if iteminfo.itemdata ~= nil and iteminfo.itemdata.battlepoint ~= nil then
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      msgParam.iteminfo.itemdata.battlepoint = iteminfo.itemdata.battlepoint
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthlv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.strengthlv = iteminfo.itemdata.equip.strengthlv
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.refinelv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.refinelv = iteminfo.itemdata.equip.refinelv
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthCost ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.strengthCost = iteminfo.itemdata.equip.strengthCost
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.refineCompose ~= nil then
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      if msgParam.iteminfo.itemdata.equip.refineCompose == nil then
        msgParam.iteminfo.itemdata.equip.refineCompose = {}
      end
      for i = 1, #iteminfo.itemdata.equip.refineCompose do
        table.insert(msgParam.iteminfo.itemdata.equip.refineCompose, iteminfo.itemdata.equip.refineCompose[i])
      end
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.cardslot ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.cardslot = iteminfo.itemdata.equip.cardslot
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.buffid ~= nil then
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      if msgParam.iteminfo.itemdata.equip.buffid == nil then
        msgParam.iteminfo.itemdata.equip.buffid = {}
      end
      for i = 1, #iteminfo.itemdata.equip.buffid do
        table.insert(msgParam.iteminfo.itemdata.equip.buffid, iteminfo.itemdata.equip.buffid[i])
      end
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.damage ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.damage = iteminfo.itemdata.equip.damage
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.lv = iteminfo.itemdata.equip.lv
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.color ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.color = iteminfo.itemdata.equip.color
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.breakstarttime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.breakstarttime = iteminfo.itemdata.equip.breakstarttime
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.breakendtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.breakendtime = iteminfo.itemdata.equip.breakendtime
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.strengthlv2 ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.strengthlv2 = iteminfo.itemdata.equip.strengthlv2
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.quenchper ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.quenchper = iteminfo.itemdata.equip.quenchper
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.strengthlv2cost ~= nil then
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      if msgParam.iteminfo.itemdata.equip.strengthlv2cost == nil then
        msgParam.iteminfo.itemdata.equip.strengthlv2cost = {}
      end
      for i = 1, #iteminfo.itemdata.equip.strengthlv2cost do
        table.insert(msgParam.iteminfo.itemdata.equip.strengthlv2cost, iteminfo.itemdata.equip.strengthlv2cost[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.equip.attrs ~= nil then
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      if msgParam.iteminfo.itemdata.equip.attrs == nil then
        msgParam.iteminfo.itemdata.equip.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.equip.attrs do
        table.insert(msgParam.iteminfo.itemdata.equip.attrs, iteminfo.itemdata.equip.attrs[i])
      end
    end
    if iteminfo.itemdata.equip ~= nil and iteminfo.itemdata.equip.extra_refine_value ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.equip == nil then
        msgParam.iteminfo.itemdata.equip = {}
      end
      msgParam.iteminfo.itemdata.equip.extra_refine_value = iteminfo.itemdata.equip.extra_refine_value
    end
    if iteminfo ~= nil and iteminfo.itemdata.card ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.card == nil then
        msgParam.iteminfo.itemdata.card = {}
      end
      for i = 1, #iteminfo.itemdata.card do
        table.insert(msgParam.iteminfo.itemdata.card, iteminfo.itemdata.card[i])
      end
    end
    if iteminfo.itemdata.enchant ~= nil and iteminfo.itemdata.enchant.type ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.enchant == nil then
        msgParam.iteminfo.itemdata.enchant = {}
      end
      msgParam.iteminfo.itemdata.enchant.type = iteminfo.itemdata.enchant.type
    end
    if iteminfo ~= nil and iteminfo.itemdata.enchant.attrs ~= nil then
      if msgParam.iteminfo.itemdata.enchant == nil then
        msgParam.iteminfo.itemdata.enchant = {}
      end
      if msgParam.iteminfo.itemdata.enchant.attrs == nil then
        msgParam.iteminfo.itemdata.enchant.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.enchant.attrs do
        table.insert(msgParam.iteminfo.itemdata.enchant.attrs, iteminfo.itemdata.enchant.attrs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.enchant.extras ~= nil then
      if msgParam.iteminfo.itemdata.enchant == nil then
        msgParam.iteminfo.itemdata.enchant = {}
      end
      if msgParam.iteminfo.itemdata.enchant.extras == nil then
        msgParam.iteminfo.itemdata.enchant.extras = {}
      end
      for i = 1, #iteminfo.itemdata.enchant.extras do
        table.insert(msgParam.iteminfo.itemdata.enchant.extras, iteminfo.itemdata.enchant.extras[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.enchant.patch ~= nil then
      if msgParam.iteminfo.itemdata.enchant == nil then
        msgParam.iteminfo.itemdata.enchant = {}
      end
      if msgParam.iteminfo.itemdata.enchant.patch == nil then
        msgParam.iteminfo.itemdata.enchant.patch = {}
      end
      for i = 1, #iteminfo.itemdata.enchant.patch do
        table.insert(msgParam.iteminfo.itemdata.enchant.patch, iteminfo.itemdata.enchant.patch[i])
      end
    end
    if iteminfo.itemdata.enchant ~= nil and iteminfo.itemdata.enchant.israteup ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.enchant == nil then
        msgParam.iteminfo.itemdata.enchant = {}
      end
      msgParam.iteminfo.itemdata.enchant.israteup = iteminfo.itemdata.enchant.israteup
    end
    if iteminfo.itemdata.prenchant ~= nil and iteminfo.itemdata.prenchant.type ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.prenchant == nil then
        msgParam.iteminfo.itemdata.prenchant = {}
      end
      msgParam.iteminfo.itemdata.prenchant.type = iteminfo.itemdata.prenchant.type
    end
    if iteminfo ~= nil and iteminfo.itemdata.prenchant.attrs ~= nil then
      if msgParam.iteminfo.itemdata.prenchant == nil then
        msgParam.iteminfo.itemdata.prenchant = {}
      end
      if msgParam.iteminfo.itemdata.prenchant.attrs == nil then
        msgParam.iteminfo.itemdata.prenchant.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.prenchant.attrs do
        table.insert(msgParam.iteminfo.itemdata.prenchant.attrs, iteminfo.itemdata.prenchant.attrs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.prenchant.extras ~= nil then
      if msgParam.iteminfo.itemdata.prenchant == nil then
        msgParam.iteminfo.itemdata.prenchant = {}
      end
      if msgParam.iteminfo.itemdata.prenchant.extras == nil then
        msgParam.iteminfo.itemdata.prenchant.extras = {}
      end
      for i = 1, #iteminfo.itemdata.prenchant.extras do
        table.insert(msgParam.iteminfo.itemdata.prenchant.extras, iteminfo.itemdata.prenchant.extras[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.prenchant.patch ~= nil then
      if msgParam.iteminfo.itemdata.prenchant == nil then
        msgParam.iteminfo.itemdata.prenchant = {}
      end
      if msgParam.iteminfo.itemdata.prenchant.patch == nil then
        msgParam.iteminfo.itemdata.prenchant.patch = {}
      end
      for i = 1, #iteminfo.itemdata.prenchant.patch do
        table.insert(msgParam.iteminfo.itemdata.prenchant.patch, iteminfo.itemdata.prenchant.patch[i])
      end
    end
    if iteminfo.itemdata.prenchant ~= nil and iteminfo.itemdata.prenchant.israteup ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.prenchant == nil then
        msgParam.iteminfo.itemdata.prenchant = {}
      end
      msgParam.iteminfo.itemdata.prenchant.israteup = iteminfo.itemdata.prenchant.israteup
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.lastfail ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.refine == nil then
        msgParam.iteminfo.itemdata.refine = {}
      end
      msgParam.iteminfo.itemdata.refine.lastfail = iteminfo.itemdata.refine.lastfail
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.repaircount ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.refine == nil then
        msgParam.iteminfo.itemdata.refine = {}
      end
      msgParam.iteminfo.itemdata.refine.repaircount = iteminfo.itemdata.refine.repaircount
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.lastfailcount ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.refine == nil then
        msgParam.iteminfo.itemdata.refine = {}
      end
      msgParam.iteminfo.itemdata.refine.lastfailcount = iteminfo.itemdata.refine.lastfailcount
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.history_fix_rate ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.refine == nil then
        msgParam.iteminfo.itemdata.refine = {}
      end
      msgParam.iteminfo.itemdata.refine.history_fix_rate = iteminfo.itemdata.refine.history_fix_rate
    end
    if iteminfo.itemdata.refine ~= nil and iteminfo.itemdata.refine.cost_count ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.refine == nil then
        msgParam.iteminfo.itemdata.refine = {}
      end
      msgParam.iteminfo.itemdata.refine.cost_count = iteminfo.itemdata.refine.cost_count
    end
    if iteminfo ~= nil and iteminfo.itemdata.refine.cost_counts ~= nil then
      if msgParam.iteminfo.itemdata.refine == nil then
        msgParam.iteminfo.itemdata.refine = {}
      end
      if msgParam.iteminfo.itemdata.refine.cost_counts == nil then
        msgParam.iteminfo.itemdata.refine.cost_counts = {}
      end
      for i = 1, #iteminfo.itemdata.refine.cost_counts do
        table.insert(msgParam.iteminfo.itemdata.refine.cost_counts, iteminfo.itemdata.refine.cost_counts[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.exp ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.exp = iteminfo.itemdata.egg.exp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.friendexp ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.friendexp = iteminfo.itemdata.egg.friendexp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.rewardexp ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.rewardexp = iteminfo.itemdata.egg.rewardexp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.id = iteminfo.itemdata.egg.id
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.lv = iteminfo.itemdata.egg.lv
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.friendlv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.friendlv = iteminfo.itemdata.egg.friendlv
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.body ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.body = iteminfo.itemdata.egg.body
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.relivetime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.relivetime = iteminfo.itemdata.egg.relivetime
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.hp ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.hp = iteminfo.itemdata.egg.hp
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.restoretime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.restoretime = iteminfo.itemdata.egg.restoretime
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happly ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.time_happly = iteminfo.itemdata.egg.time_happly
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_excite ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.time_excite = iteminfo.itemdata.egg.time_excite
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happiness ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.time_happiness = iteminfo.itemdata.egg.time_happiness
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happly_gift ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.time_happly_gift = iteminfo.itemdata.egg.time_happly_gift
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_excite_gift ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.time_excite_gift = iteminfo.itemdata.egg.time_excite_gift
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.time_happiness_gift ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.time_happiness_gift = iteminfo.itemdata.egg.time_happiness_gift
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.touch_tick ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.touch_tick = iteminfo.itemdata.egg.touch_tick
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.feed_tick ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.feed_tick = iteminfo.itemdata.egg.feed_tick
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.name ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.name = iteminfo.itemdata.egg.name
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.var ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.var = iteminfo.itemdata.egg.var
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.skillids ~= nil then
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      if msgParam.iteminfo.itemdata.egg.skillids == nil then
        msgParam.iteminfo.itemdata.egg.skillids = {}
      end
      for i = 1, #iteminfo.itemdata.egg.skillids do
        table.insert(msgParam.iteminfo.itemdata.egg.skillids, iteminfo.itemdata.egg.skillids[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.equips ~= nil then
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      if msgParam.iteminfo.itemdata.egg.equips == nil then
        msgParam.iteminfo.itemdata.egg.equips = {}
      end
      for i = 1, #iteminfo.itemdata.egg.equips do
        table.insert(msgParam.iteminfo.itemdata.egg.equips, iteminfo.itemdata.egg.equips[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.buff ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.buff = iteminfo.itemdata.egg.buff
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.unlock_equip ~= nil then
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      if msgParam.iteminfo.itemdata.egg.unlock_equip == nil then
        msgParam.iteminfo.itemdata.egg.unlock_equip = {}
      end
      for i = 1, #iteminfo.itemdata.egg.unlock_equip do
        table.insert(msgParam.iteminfo.itemdata.egg.unlock_equip, iteminfo.itemdata.egg.unlock_equip[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.unlock_body ~= nil then
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      if msgParam.iteminfo.itemdata.egg.unlock_body == nil then
        msgParam.iteminfo.itemdata.egg.unlock_body = {}
      end
      for i = 1, #iteminfo.itemdata.egg.unlock_body do
        table.insert(msgParam.iteminfo.itemdata.egg.unlock_body, iteminfo.itemdata.egg.unlock_body[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.version ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.version = iteminfo.itemdata.egg.version
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.skilloff ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.skilloff = iteminfo.itemdata.egg.skilloff
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.exchange_count ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.exchange_count = iteminfo.itemdata.egg.exchange_count
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.guid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.guid = iteminfo.itemdata.egg.guid
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.defaultwears ~= nil then
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      if msgParam.iteminfo.itemdata.egg.defaultwears == nil then
        msgParam.iteminfo.itemdata.egg.defaultwears = {}
      end
      for i = 1, #iteminfo.itemdata.egg.defaultwears do
        table.insert(msgParam.iteminfo.itemdata.egg.defaultwears, iteminfo.itemdata.egg.defaultwears[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.egg.wears ~= nil then
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      if msgParam.iteminfo.itemdata.egg.wears == nil then
        msgParam.iteminfo.itemdata.egg.wears = {}
      end
      for i = 1, #iteminfo.itemdata.egg.wears do
        table.insert(msgParam.iteminfo.itemdata.egg.wears, iteminfo.itemdata.egg.wears[i])
      end
    end
    if iteminfo.itemdata.egg ~= nil and iteminfo.itemdata.egg.cdtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.egg == nil then
        msgParam.iteminfo.itemdata.egg = {}
      end
      msgParam.iteminfo.itemdata.egg.cdtime = iteminfo.itemdata.egg.cdtime
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.sendUserName ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.letter == nil then
        msgParam.iteminfo.itemdata.letter = {}
      end
      msgParam.iteminfo.itemdata.letter.sendUserName = iteminfo.itemdata.letter.sendUserName
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.bg ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.letter == nil then
        msgParam.iteminfo.itemdata.letter = {}
      end
      msgParam.iteminfo.itemdata.letter.bg = iteminfo.itemdata.letter.bg
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.configID ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.letter == nil then
        msgParam.iteminfo.itemdata.letter = {}
      end
      msgParam.iteminfo.itemdata.letter.configID = iteminfo.itemdata.letter.configID
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.content ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.letter == nil then
        msgParam.iteminfo.itemdata.letter = {}
      end
      msgParam.iteminfo.itemdata.letter.content = iteminfo.itemdata.letter.content
    end
    if iteminfo.itemdata.letter ~= nil and iteminfo.itemdata.letter.content2 ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.letter == nil then
        msgParam.iteminfo.itemdata.letter = {}
      end
      msgParam.iteminfo.itemdata.letter.content2 = iteminfo.itemdata.letter.content2
    end
    if iteminfo.itemdata.code ~= nil and iteminfo.itemdata.code.code ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.code == nil then
        msgParam.iteminfo.itemdata.code = {}
      end
      msgParam.iteminfo.itemdata.code.code = iteminfo.itemdata.code.code
    end
    if iteminfo.itemdata.code ~= nil and iteminfo.itemdata.code.used ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.code == nil then
        msgParam.iteminfo.itemdata.code = {}
      end
      msgParam.iteminfo.itemdata.code.used = iteminfo.itemdata.code.used
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.id = iteminfo.itemdata.wedding.id
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.zoneid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.zoneid = iteminfo.itemdata.wedding.zoneid
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.charid1 ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.charid1 = iteminfo.itemdata.wedding.charid1
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.charid2 ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.charid2 = iteminfo.itemdata.wedding.charid2
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.weddingtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.weddingtime = iteminfo.itemdata.wedding.weddingtime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.photoidx ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.photoidx = iteminfo.itemdata.wedding.photoidx
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.phototime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.phototime = iteminfo.itemdata.wedding.phototime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.myname ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.myname = iteminfo.itemdata.wedding.myname
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.partnername ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.partnername = iteminfo.itemdata.wedding.partnername
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.starttime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.starttime = iteminfo.itemdata.wedding.starttime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.endtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.endtime = iteminfo.itemdata.wedding.endtime
    end
    if iteminfo.itemdata.wedding ~= nil and iteminfo.itemdata.wedding.notified ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.wedding == nil then
        msgParam.iteminfo.itemdata.wedding = {}
      end
      msgParam.iteminfo.itemdata.wedding.notified = iteminfo.itemdata.wedding.notified
    end
    if iteminfo.itemdata.sender ~= nil and iteminfo.itemdata.sender.charid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.sender == nil then
        msgParam.iteminfo.itemdata.sender = {}
      end
      msgParam.iteminfo.itemdata.sender.charid = iteminfo.itemdata.sender.charid
    end
    if iteminfo.itemdata.sender ~= nil and iteminfo.itemdata.sender.name ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.sender == nil then
        msgParam.iteminfo.itemdata.sender = {}
      end
      msgParam.iteminfo.itemdata.sender.name = iteminfo.itemdata.sender.name
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.id = iteminfo.itemdata.furniture.id
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.angle ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.angle = iteminfo.itemdata.furniture.angle
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.lv = iteminfo.itemdata.furniture.lv
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.row ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.row = iteminfo.itemdata.furniture.row
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.col ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.col = iteminfo.itemdata.furniture.col
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.floor ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.floor = iteminfo.itemdata.furniture.floor
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.rewardtime ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.rewardtime = iteminfo.itemdata.furniture.rewardtime
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.state ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.state = iteminfo.itemdata.furniture.state
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.guid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.guid = iteminfo.itemdata.furniture.guid
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.old_guid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.old_guid = iteminfo.itemdata.furniture.old_guid
    end
    if iteminfo.itemdata.furniture ~= nil and iteminfo.itemdata.furniture.var ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      msgParam.iteminfo.itemdata.furniture.var = iteminfo.itemdata.furniture.var
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.seats ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.seats == nil then
        msgParam.iteminfo.itemdata.furniture.seats = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.seats do
        table.insert(msgParam.iteminfo.itemdata.furniture.seats, iteminfo.itemdata.furniture.seats[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.seatskills ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.seatskills == nil then
        msgParam.iteminfo.itemdata.furniture.seatskills = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.seatskills do
        table.insert(msgParam.iteminfo.itemdata.furniture.seatskills, iteminfo.itemdata.furniture.seatskills[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.photos ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.photos == nil then
        msgParam.iteminfo.itemdata.furniture.photos = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.photos do
        table.insert(msgParam.iteminfo.itemdata.furniture.photos, iteminfo.itemdata.furniture.photos[i])
      end
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.race ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.race = iteminfo.itemdata.furniture.npc.race
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.shape ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.shape = iteminfo.itemdata.furniture.npc.shape
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.nature ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.nature = iteminfo.itemdata.furniture.npc.nature
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.hpreduce ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.hpreduce = iteminfo.itemdata.furniture.npc.hpreduce
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.naturelv ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.naturelv = iteminfo.itemdata.furniture.npc.naturelv
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.npc.history_max ~= nil then
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc.history_max == nil then
        msgParam.iteminfo.itemdata.furniture.npc.history_max = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.npc.history_max do
        table.insert(msgParam.iteminfo.itemdata.furniture.npc.history_max, iteminfo.itemdata.furniture.npc.history_max[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.furniture.npc.day_max ~= nil then
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc.day_max == nil then
        msgParam.iteminfo.itemdata.furniture.npc.day_max = {}
      end
      for i = 1, #iteminfo.itemdata.furniture.npc.day_max do
        table.insert(msgParam.iteminfo.itemdata.furniture.npc.day_max, iteminfo.itemdata.furniture.npc.day_max[i])
      end
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.bosstype ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.bosstype = iteminfo.itemdata.furniture.npc.bosstype
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.wood_type ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.wood_type = iteminfo.itemdata.furniture.npc.wood_type
    end
    if iteminfo.itemdata.furniture.npc ~= nil and iteminfo.itemdata.furniture.npc.monster_id ~= nil then
      if msgParam.iteminfo.itemdata.furniture == nil then
        msgParam.iteminfo.itemdata.furniture = {}
      end
      if msgParam.iteminfo.itemdata.furniture.npc == nil then
        msgParam.iteminfo.itemdata.furniture.npc = {}
      end
      msgParam.iteminfo.itemdata.furniture.npc.monster_id = iteminfo.itemdata.furniture.npc.monster_id
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.attr == nil then
        msgParam.iteminfo.itemdata.attr = {}
      end
      msgParam.iteminfo.itemdata.attr.id = iteminfo.itemdata.attr.id
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.attr == nil then
        msgParam.iteminfo.itemdata.attr = {}
      end
      msgParam.iteminfo.itemdata.attr.lv = iteminfo.itemdata.attr.lv
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.exp ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.attr == nil then
        msgParam.iteminfo.itemdata.attr = {}
      end
      msgParam.iteminfo.itemdata.attr.exp = iteminfo.itemdata.attr.exp
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.pos ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.attr == nil then
        msgParam.iteminfo.itemdata.attr = {}
      end
      msgParam.iteminfo.itemdata.attr.pos = iteminfo.itemdata.attr.pos
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.time ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.attr == nil then
        msgParam.iteminfo.itemdata.attr = {}
      end
      msgParam.iteminfo.itemdata.attr.time = iteminfo.itemdata.attr.time
    end
    if iteminfo.itemdata.attr ~= nil and iteminfo.itemdata.attr.charid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.attr == nil then
        msgParam.iteminfo.itemdata.attr = {}
      end
      msgParam.iteminfo.itemdata.attr.charid = iteminfo.itemdata.attr.charid
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      msgParam.iteminfo.itemdata.skill.id = iteminfo.itemdata.skill.id
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.pos ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      msgParam.iteminfo.itemdata.skill.pos = iteminfo.itemdata.skill.pos
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.charid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      msgParam.iteminfo.itemdata.skill.charid = iteminfo.itemdata.skill.charid
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.issame ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      msgParam.iteminfo.itemdata.skill.issame = iteminfo.itemdata.skill.issame
    end
    if iteminfo ~= nil and iteminfo.itemdata.skill.buffs ~= nil then
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      if msgParam.iteminfo.itemdata.skill.buffs == nil then
        msgParam.iteminfo.itemdata.skill.buffs = {}
      end
      for i = 1, #iteminfo.itemdata.skill.buffs do
        table.insert(msgParam.iteminfo.itemdata.skill.buffs, iteminfo.itemdata.skill.buffs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.skill.carves ~= nil then
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      if msgParam.iteminfo.itemdata.skill.carves == nil then
        msgParam.iteminfo.itemdata.skill.carves = {}
      end
      for i = 1, #iteminfo.itemdata.skill.carves do
        table.insert(msgParam.iteminfo.itemdata.skill.carves, iteminfo.itemdata.skill.carves[i])
      end
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.isforbid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      msgParam.iteminfo.itemdata.skill.isforbid = iteminfo.itemdata.skill.isforbid
    end
    if iteminfo.itemdata.skill ~= nil and iteminfo.itemdata.skill.isfull ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.skill == nil then
        msgParam.iteminfo.itemdata.skill = {}
      end
      msgParam.iteminfo.itemdata.skill.isfull = iteminfo.itemdata.skill.isfull
    end
    if iteminfo.itemdata.home ~= nil and iteminfo.itemdata.home.ownerid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.home == nil then
        msgParam.iteminfo.itemdata.home = {}
      end
      msgParam.iteminfo.itemdata.home.ownerid = iteminfo.itemdata.home.ownerid
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.attrs ~= nil then
      if msgParam.iteminfo.itemdata.artifact == nil then
        msgParam.iteminfo.itemdata.artifact = {}
      end
      if msgParam.iteminfo.itemdata.artifact.attrs == nil then
        msgParam.iteminfo.itemdata.artifact.attrs = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.attrs do
        table.insert(msgParam.iteminfo.itemdata.artifact.attrs, iteminfo.itemdata.artifact.attrs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.preattrs ~= nil then
      if msgParam.iteminfo.itemdata.artifact == nil then
        msgParam.iteminfo.itemdata.artifact = {}
      end
      if msgParam.iteminfo.itemdata.artifact.preattrs == nil then
        msgParam.iteminfo.itemdata.artifact.preattrs = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.preattrs do
        table.insert(msgParam.iteminfo.itemdata.artifact.preattrs, iteminfo.itemdata.artifact.preattrs[i])
      end
    end
    if iteminfo.itemdata.artifact ~= nil and iteminfo.itemdata.artifact.art_state ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.artifact == nil then
        msgParam.iteminfo.itemdata.artifact = {}
      end
      msgParam.iteminfo.itemdata.artifact.art_state = iteminfo.itemdata.artifact.art_state
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.art_fragment ~= nil then
      if msgParam.iteminfo.itemdata.artifact == nil then
        msgParam.iteminfo.itemdata.artifact = {}
      end
      if msgParam.iteminfo.itemdata.artifact.art_fragment == nil then
        msgParam.iteminfo.itemdata.artifact.art_fragment = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.art_fragment do
        table.insert(msgParam.iteminfo.itemdata.artifact.art_fragment, iteminfo.itemdata.artifact.art_fragment[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.artifact.noattrs ~= nil then
      if msgParam.iteminfo.itemdata.artifact == nil then
        msgParam.iteminfo.itemdata.artifact = {}
      end
      if msgParam.iteminfo.itemdata.artifact.noattrs == nil then
        msgParam.iteminfo.itemdata.artifact.noattrs = {}
      end
      for i = 1, #iteminfo.itemdata.artifact.noattrs do
        table.insert(msgParam.iteminfo.itemdata.artifact.noattrs, iteminfo.itemdata.artifact.noattrs[i])
      end
    end
    if iteminfo.itemdata.cupinfo ~= nil and iteminfo.itemdata.cupinfo.name ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.cupinfo == nil then
        msgParam.iteminfo.itemdata.cupinfo = {}
      end
      msgParam.iteminfo.itemdata.cupinfo.name = iteminfo.itemdata.cupinfo.name
    end
    if iteminfo ~= nil and iteminfo.itemdata.previewattr ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.previewattr == nil then
        msgParam.iteminfo.itemdata.previewattr = {}
      end
      for i = 1, #iteminfo.itemdata.previewattr do
        table.insert(msgParam.iteminfo.itemdata.previewattr, iteminfo.itemdata.previewattr[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.previewenchant ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.previewenchant == nil then
        msgParam.iteminfo.itemdata.previewenchant = {}
      end
      for i = 1, #iteminfo.itemdata.previewenchant do
        table.insert(msgParam.iteminfo.itemdata.previewenchant, iteminfo.itemdata.previewenchant[i])
      end
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.config_id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      msgParam.iteminfo.itemdata.red_packet.config_id = iteminfo.itemdata.red_packet.config_id
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.min_num ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      msgParam.iteminfo.itemdata.red_packet.min_num = iteminfo.itemdata.red_packet.min_num
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.max_num ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      msgParam.iteminfo.itemdata.red_packet.max_num = iteminfo.itemdata.red_packet.max_num
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.min_money ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      msgParam.iteminfo.itemdata.red_packet.min_money = iteminfo.itemdata.red_packet.min_money
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.max_money ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      msgParam.iteminfo.itemdata.red_packet.max_money = iteminfo.itemdata.red_packet.max_money
    end
    if iteminfo ~= nil and iteminfo.itemdata.red_packet.multi_items ~= nil then
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      if msgParam.iteminfo.itemdata.red_packet.multi_items == nil then
        msgParam.iteminfo.itemdata.red_packet.multi_items = {}
      end
      for i = 1, #iteminfo.itemdata.red_packet.multi_items do
        table.insert(msgParam.iteminfo.itemdata.red_packet.multi_items, iteminfo.itemdata.red_packet.multi_items[i])
      end
    end
    if iteminfo.itemdata.red_packet ~= nil and iteminfo.itemdata.red_packet.gvg_cityid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      msgParam.iteminfo.itemdata.red_packet.gvg_cityid = iteminfo.itemdata.red_packet.gvg_cityid
    end
    if iteminfo ~= nil and iteminfo.itemdata.red_packet.gvg_charids ~= nil then
      if msgParam.iteminfo.itemdata.red_packet == nil then
        msgParam.iteminfo.itemdata.red_packet = {}
      end
      if msgParam.iteminfo.itemdata.red_packet.gvg_charids == nil then
        msgParam.iteminfo.itemdata.red_packet.gvg_charids = {}
      end
      for i = 1, #iteminfo.itemdata.red_packet.gvg_charids do
        table.insert(msgParam.iteminfo.itemdata.red_packet.gvg_charids, iteminfo.itemdata.red_packet.gvg_charids[i])
      end
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.id ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      msgParam.iteminfo.itemdata.gem_secret_land.id = iteminfo.itemdata.gem_secret_land.id
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.color ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      msgParam.iteminfo.itemdata.gem_secret_land.color = iteminfo.itemdata.gem_secret_land.color
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      msgParam.iteminfo.itemdata.gem_secret_land.lv = iteminfo.itemdata.gem_secret_land.lv
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.max_lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      msgParam.iteminfo.itemdata.gem_secret_land.max_lv = iteminfo.itemdata.gem_secret_land.max_lv
    end
    if iteminfo.itemdata.gem_secret_land ~= nil and iteminfo.itemdata.gem_secret_land.exp ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      msgParam.iteminfo.itemdata.gem_secret_land.exp = iteminfo.itemdata.gem_secret_land.exp
    end
    if iteminfo ~= nil and iteminfo.itemdata.gem_secret_land.buffs ~= nil then
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land.buffs == nil then
        msgParam.iteminfo.itemdata.gem_secret_land.buffs = {}
      end
      for i = 1, #iteminfo.itemdata.gem_secret_land.buffs do
        table.insert(msgParam.iteminfo.itemdata.gem_secret_land.buffs, iteminfo.itemdata.gem_secret_land.buffs[i])
      end
    end
    if iteminfo ~= nil and iteminfo.itemdata.gem_secret_land.char_data ~= nil then
      if msgParam.iteminfo.itemdata.gem_secret_land == nil then
        msgParam.iteminfo.itemdata.gem_secret_land = {}
      end
      if msgParam.iteminfo.itemdata.gem_secret_land.char_data == nil then
        msgParam.iteminfo.itemdata.gem_secret_land.char_data = {}
      end
      for i = 1, #iteminfo.itemdata.gem_secret_land.char_data do
        table.insert(msgParam.iteminfo.itemdata.gem_secret_land.char_data, iteminfo.itemdata.gem_secret_land.char_data[i])
      end
    end
    if iteminfo.itemdata.memory ~= nil and iteminfo.itemdata.memory.itemid ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.memory == nil then
        msgParam.iteminfo.itemdata.memory = {}
      end
      msgParam.iteminfo.itemdata.memory.itemid = iteminfo.itemdata.memory.itemid
    end
    if iteminfo.itemdata.memory ~= nil and iteminfo.itemdata.memory.lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.memory == nil then
        msgParam.iteminfo.itemdata.memory = {}
      end
      msgParam.iteminfo.itemdata.memory.lv = iteminfo.itemdata.memory.lv
    end
    if iteminfo.itemdata.memory ~= nil and iteminfo.itemdata.memory.excess_lv ~= nil then
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      if msgParam.iteminfo.itemdata.memory == nil then
        msgParam.iteminfo.itemdata.memory = {}
      end
      msgParam.iteminfo.itemdata.memory.excess_lv = iteminfo.itemdata.memory.excess_lv
    end
    if iteminfo ~= nil and iteminfo.itemdata.memory.effects ~= nil then
      if msgParam.iteminfo.itemdata.memory == nil then
        msgParam.iteminfo.itemdata.memory = {}
      end
      if msgParam.iteminfo.itemdata.memory.effects == nil then
        msgParam.iteminfo.itemdata.memory.effects = {}
      end
      for i = 1, #iteminfo.itemdata.memory.effects do
        table.insert(msgParam.iteminfo.itemdata.memory.effects, iteminfo.itemdata.memory.effects[i])
      end
    end
    if iteminfo.itemdata ~= nil and iteminfo.itemdata.deletetime ~= nil then
      if msgParam.iteminfo == nil then
        msgParam.iteminfo = {}
      end
      if msgParam.iteminfo.itemdata == nil then
        msgParam.iteminfo.itemdata = {}
      end
      msgParam.iteminfo.itemdata.deletetime = iteminfo.itemdata.deletetime
    end
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallReqAuctionFlowingWaterCCmd(batchid, itemid, page_index, flowingwater, signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.ReqAuctionFlowingWaterCCmd()
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if page_index ~= nil then
      msg.page_index = page_index
    end
    if flowingwater ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      for i = 1, #flowingwater do
        table.insert(msg.flowingwater, flowingwater[i])
      end
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqAuctionFlowingWaterCCmd.id
    local msgParam = {}
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if page_index ~= nil then
      msgParam.page_index = page_index
    end
    if flowingwater ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      for i = 1, #flowingwater do
        table.insert(msgParam.flowingwater, flowingwater[i])
      end
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallUpdateAuctionFlowingWaterCCmd(batchid, itemid, flowingwater, signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.UpdateAuctionFlowingWaterCCmd()
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if flowingwater ~= nil and flowingwater.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.time = flowingwater.time
    end
    if flowingwater ~= nil and flowingwater.event ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.event = flowingwater.event
    end
    if flowingwater ~= nil and flowingwater.price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.price = flowingwater.price
    end
    if flowingwater ~= nil and flowingwater.player_name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.player_name = flowingwater.player_name
    end
    if flowingwater ~= nil and flowingwater.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.zoneid = flowingwater.zoneid
    end
    if flowingwater ~= nil and flowingwater.max_price ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.max_price = flowingwater.max_price
    end
    if flowingwater ~= nil and flowingwater.player_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.flowingwater == nil then
        msg.flowingwater = {}
      end
      msg.flowingwater.player_id = flowingwater.player_id
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateAuctionFlowingWaterCCmd.id
    local msgParam = {}
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if flowingwater ~= nil and flowingwater.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.time = flowingwater.time
    end
    if flowingwater ~= nil and flowingwater.event ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.event = flowingwater.event
    end
    if flowingwater ~= nil and flowingwater.price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.price = flowingwater.price
    end
    if flowingwater ~= nil and flowingwater.player_name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.player_name = flowingwater.player_name
    end
    if flowingwater ~= nil and flowingwater.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.zoneid = flowingwater.zoneid
    end
    if flowingwater ~= nil and flowingwater.max_price ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.max_price = flowingwater.max_price
    end
    if flowingwater ~= nil and flowingwater.player_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.flowingwater == nil then
        msgParam.flowingwater = {}
      end
      msgParam.flowingwater.player_id = flowingwater.player_id
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallReqLastAuctionInfoCCmd()
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.ReqLastAuctionInfoCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqLastAuctionInfoCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallOfferPriceCCmd(itemid, max_price, add_price, level, signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.OfferPriceCCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if max_price ~= nil then
      msg.max_price = max_price
    end
    if add_price ~= nil then
      msg.add_price = add_price
    end
    if level ~= nil then
      msg.level = level
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OfferPriceCCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if max_price ~= nil then
      msgParam.max_price = max_price
    end
    if add_price ~= nil then
      msgParam.add_price = add_price
    end
    if level ~= nil then
      msgParam.level = level
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallReqAuctionRecordCCmd(index, total_page_cnt, records)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.ReqAuctionRecordCCmd()
    if index ~= nil then
      msg.index = index
    end
    if total_page_cnt ~= nil then
      msg.total_page_cnt = total_page_cnt
    end
    if records ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.records == nil then
        msg.records = {}
      end
      for i = 1, #records do
        table.insert(msg.records, records[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqAuctionRecordCCmd.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    if total_page_cnt ~= nil then
      msgParam.total_page_cnt = total_page_cnt
    end
    if records ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.records == nil then
        msgParam.records = {}
      end
      for i = 1, #records do
        table.insert(msgParam.records, records[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallTakeAuctionRecordCCmd(id, type, ret)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.TakeAuctionRecordCCmd()
    if id ~= nil then
      msg.id = id
    end
    if type ~= nil then
      msg.type = type
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TakeAuctionRecordCCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if type ~= nil then
      msgParam.type = type
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfCanTakeCntCCmd(count)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfCanTakeCntCCmd()
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfCanTakeCntCCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfMyOfferPriceCCmd(batchid, itemid, my_price, signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfMyOfferPriceCCmd()
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if my_price ~= nil then
      msg.my_price = my_price
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfMyOfferPriceCCmd.id
    local msgParam = {}
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if my_price ~= nil then
      msgParam.my_price = my_price
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfNextAuctionInfoCCmd(batchid, itemid, last_itemid, base_price, start_time, signup_id, last_signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfNextAuctionInfoCCmd()
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if last_itemid ~= nil then
      msg.last_itemid = last_itemid
    end
    if base_price ~= nil then
      msg.base_price = base_price
    end
    if start_time ~= nil then
      msg.start_time = start_time
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    if last_signup_id ~= nil then
      msg.last_signup_id = last_signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfNextAuctionInfoCCmd.id
    local msgParam = {}
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if last_itemid ~= nil then
      msgParam.last_itemid = last_itemid
    end
    if base_price ~= nil then
      msgParam.base_price = base_price
    end
    if start_time ~= nil then
      msgParam.start_time = start_time
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    if last_signup_id ~= nil then
      msgParam.last_signup_id = last_signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallReqAuctionInfoCCmd()
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.ReqAuctionInfoCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqAuctionInfoCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfCurAuctionInfoCCmd(itemid)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfCurAuctionInfoCCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfCurAuctionInfoCCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfOverTakePriceCCmd()
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfOverTakePriceCCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfOverTakePriceCCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallReqMyTradedPriceCCmd(batchid, itemid, my_price, signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.ReqMyTradedPriceCCmd()
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if my_price ~= nil then
      msg.my_price = my_price
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqMyTradedPriceCCmd.id
    local msgParam = {}
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if my_price ~= nil then
      msgParam.my_price = my_price
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallNtfMaskPriceCCmd(batchid, itemid, mask_price, signup_id)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.NtfMaskPriceCCmd()
    if batchid ~= nil then
      msg.batchid = batchid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if mask_price ~= nil then
      msg.mask_price = mask_price
    end
    if signup_id ~= nil then
      msg.signup_id = signup_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfMaskPriceCCmd.id
    local msgParam = {}
    if batchid ~= nil then
      msgParam.batchid = batchid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if mask_price ~= nil then
      msgParam.mask_price = mask_price
    end
    if signup_id ~= nil then
      msgParam.signup_id = signup_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:CallAuctionDialogCCmd(type, msg_id, params, serverid)
  if not NetConfig.PBC then
    local msg = AuctionCCmd_pb.AuctionDialogCCmd()
    if type ~= nil then
      msg.type = type
    end
    if msg_id ~= nil then
      msg.msg_id = msg_id
    end
    if params ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.params == nil then
        msg.params = {}
      end
      for i = 1, #params do
        table.insert(msg.params, params[i])
      end
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AuctionDialogCCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if msg_id ~= nil then
      msgParam.msg_id = msg_id
    end
    if params ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.params == nil then
        msgParam.params = {}
      end
      for i = 1, #params do
        table.insert(msgParam.params, params[i])
      end
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceAuctionCCmdAutoProxy:RecvNtfAuctionStateCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfAuctionStateCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvOpenAuctionPanelCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdOpenAuctionPanelCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfSignUpInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfSignUpInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfMySignUpInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfMySignUpInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvSignUpItemCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdSignUpItemCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfAuctionInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvUpdateAuctionInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdUpdateAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqAuctionFlowingWaterCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdReqAuctionFlowingWaterCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvUpdateAuctionFlowingWaterCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdUpdateAuctionFlowingWaterCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqLastAuctionInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdReqLastAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvOfferPriceCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdOfferPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqAuctionRecordCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdReqAuctionRecordCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvTakeAuctionRecordCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdTakeAuctionRecordCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfCanTakeCntCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfCanTakeCntCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfMyOfferPriceCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfMyOfferPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfNextAuctionInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfNextAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqAuctionInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdReqAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfCurAuctionInfoCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfCurAuctionInfoCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfOverTakePriceCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfOverTakePriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvReqMyTradedPriceCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdReqMyTradedPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvNtfMaskPriceCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdNtfMaskPriceCCmd, data)
end

function ServiceAuctionCCmdAutoProxy:RecvAuctionDialogCCmd(data)
  self:Notify(ServiceEvent.AuctionCCmdAuctionDialogCCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.AuctionCCmdNtfAuctionStateCCmd = "ServiceEvent_AuctionCCmdNtfAuctionStateCCmd"
ServiceEvent.AuctionCCmdOpenAuctionPanelCCmd = "ServiceEvent_AuctionCCmdOpenAuctionPanelCCmd"
ServiceEvent.AuctionCCmdNtfSignUpInfoCCmd = "ServiceEvent_AuctionCCmdNtfSignUpInfoCCmd"
ServiceEvent.AuctionCCmdNtfMySignUpInfoCCmd = "ServiceEvent_AuctionCCmdNtfMySignUpInfoCCmd"
ServiceEvent.AuctionCCmdSignUpItemCCmd = "ServiceEvent_AuctionCCmdSignUpItemCCmd"
ServiceEvent.AuctionCCmdNtfAuctionInfoCCmd = "ServiceEvent_AuctionCCmdNtfAuctionInfoCCmd"
ServiceEvent.AuctionCCmdUpdateAuctionInfoCCmd = "ServiceEvent_AuctionCCmdUpdateAuctionInfoCCmd"
ServiceEvent.AuctionCCmdReqAuctionFlowingWaterCCmd = "ServiceEvent_AuctionCCmdReqAuctionFlowingWaterCCmd"
ServiceEvent.AuctionCCmdUpdateAuctionFlowingWaterCCmd = "ServiceEvent_AuctionCCmdUpdateAuctionFlowingWaterCCmd"
ServiceEvent.AuctionCCmdReqLastAuctionInfoCCmd = "ServiceEvent_AuctionCCmdReqLastAuctionInfoCCmd"
ServiceEvent.AuctionCCmdOfferPriceCCmd = "ServiceEvent_AuctionCCmdOfferPriceCCmd"
ServiceEvent.AuctionCCmdReqAuctionRecordCCmd = "ServiceEvent_AuctionCCmdReqAuctionRecordCCmd"
ServiceEvent.AuctionCCmdTakeAuctionRecordCCmd = "ServiceEvent_AuctionCCmdTakeAuctionRecordCCmd"
ServiceEvent.AuctionCCmdNtfCanTakeCntCCmd = "ServiceEvent_AuctionCCmdNtfCanTakeCntCCmd"
ServiceEvent.AuctionCCmdNtfMyOfferPriceCCmd = "ServiceEvent_AuctionCCmdNtfMyOfferPriceCCmd"
ServiceEvent.AuctionCCmdNtfNextAuctionInfoCCmd = "ServiceEvent_AuctionCCmdNtfNextAuctionInfoCCmd"
ServiceEvent.AuctionCCmdReqAuctionInfoCCmd = "ServiceEvent_AuctionCCmdReqAuctionInfoCCmd"
ServiceEvent.AuctionCCmdNtfCurAuctionInfoCCmd = "ServiceEvent_AuctionCCmdNtfCurAuctionInfoCCmd"
ServiceEvent.AuctionCCmdNtfOverTakePriceCCmd = "ServiceEvent_AuctionCCmdNtfOverTakePriceCCmd"
ServiceEvent.AuctionCCmdReqMyTradedPriceCCmd = "ServiceEvent_AuctionCCmdReqMyTradedPriceCCmd"
ServiceEvent.AuctionCCmdNtfMaskPriceCCmd = "ServiceEvent_AuctionCCmdNtfMaskPriceCCmd"
ServiceEvent.AuctionCCmdAuctionDialogCCmd = "ServiceEvent_AuctionCCmdAuctionDialogCCmd"
