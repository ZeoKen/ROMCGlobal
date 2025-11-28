ServiceChatCmdAutoProxy = class("ServiceChatCmdAutoProxy", ServiceProxy)
ServiceChatCmdAutoProxy.Instance = nil
ServiceChatCmdAutoProxy.NAME = "ServiceChatCmdAutoProxy"

function ServiceChatCmdAutoProxy:ctor(proxyName)
  if ServiceChatCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceChatCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceChatCmdAutoProxy.Instance = self
  end
end

function ServiceChatCmdAutoProxy:Init()
end

function ServiceChatCmdAutoProxy:onRegister()
  self:Listen(59, 1, function(data)
    self:RecvQueryItemData(data)
  end)
  self:Listen(59, 2, function(data)
    self:RecvPlayExpressionChatCmd(data)
  end)
  self:Listen(59, 3, function(data)
    self:RecvQueryUserInfoChatCmd(data)
  end)
  self:Listen(59, 20, function(data)
    self:RecvQueryUserGemChatCmd(data)
  end)
  self:Listen(59, 4, function(data)
    self:RecvBarrageChatCmd(data)
  end)
  self:Listen(59, 5, function(data)
    self:RecvBarrageMsgChatCmd(data)
  end)
  self:Listen(59, 6, function(data)
    self:RecvChatCmd(data)
  end)
  self:Listen(59, 7, function(data)
    self:RecvChatRetCmd(data)
  end)
  self:Listen(59, 8, function(data)
    self:RecvQueryVoiceUserCmd(data)
  end)
  self:Listen(59, 10, function(data)
    self:RecvGetVoiceIDChatCmd(data)
  end)
  self:Listen(59, 11, function(data)
    self:RecvLoveLetterNtf(data)
  end)
  self:Listen(59, 12, function(data)
    self:RecvChatSelfNtf(data)
  end)
  self:Listen(59, 13, function(data)
    self:RecvNpcChatNtf(data)
  end)
  self:Listen(59, 16, function(data)
    self:RecvQueryUserShowInfoCmd(data)
  end)
  self:Listen(59, 15, function(data)
    self:RecvSystemBarrageChatCmd(data)
  end)
  self:Listen(59, 17, function(data)
    self:RecvQueryFavoriteExpressionChatCmd(data)
  end)
  self:Listen(59, 18, function(data)
    self:RecvUpdateFavoriteExpressionChatCmd(data)
  end)
  self:Listen(59, 19, function(data)
    self:RecvExpressionChatCmd(data)
  end)
  self:Listen(59, 21, function(data)
    self:RecvFaceShowChatCmd(data)
  end)
  self:Listen(59, 22, function(data)
    self:RecvClientLogChatCmd(data)
  end)
  self:Listen(59, 23, function(data)
    self:RecvSendRedPacketCmd(data)
  end)
  self:Listen(59, 24, function(data)
    self:RecvReceiveRedPacketCmd(data)
  end)
  self:Listen(59, 25, function(data)
    self:RecvInitUserRedPacketCmd(data)
  end)
  self:Listen(59, 27, function(data)
    self:RecvReceiveRedPacketRet(data)
  end)
  self:Listen(59, 28, function(data)
    self:RecvShareMsgCmd(data)
  end)
  self:Listen(59, 29, function(data)
    self:RecvShareSuccessNofityCmd(data)
  end)
  self:Listen(59, 30, function(data)
    self:RecvQueryGuildRedPacketChatCmd(data)
  end)
  self:Listen(59, 31, function(data)
    self:RecvCheckRecvRedPacketChatCmd(data)
  end)
end

function ServiceChatCmdAutoProxy:CallQueryItemData(guid, data)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryItemData()
    if guid ~= nil then
      msg.guid = guid
    end
    if data.base ~= nil and data.base.guid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.guid = data.base.guid
    end
    if data.base ~= nil and data.base.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.id = data.base.id
    end
    if data.base ~= nil and data.base.count ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.count = data.base.count
    end
    if data.base ~= nil and data.base.index ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.index = data.base.index
    end
    if data.base ~= nil and data.base.createtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.createtime = data.base.createtime
    end
    if data.base ~= nil and data.base.cd ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.cd = data.base.cd
    end
    if data.base ~= nil and data.base.type ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.type = data.base.type
    end
    if data.base ~= nil and data.base.bind ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.bind = data.base.bind
    end
    if data.base ~= nil and data.base.expire ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.expire = data.base.expire
    end
    if data.base ~= nil and data.base.quality ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.quality = data.base.quality
    end
    if data.base ~= nil and data.base.equipType ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.equipType = data.base.equipType
    end
    if data.base ~= nil and data.base.source ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.source = data.base.source
    end
    if data.base ~= nil and data.base.isnew ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.isnew = data.base.isnew
    end
    if data.base ~= nil and data.base.maxcardslot ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.maxcardslot = data.base.maxcardslot
    end
    if data.base ~= nil and data.base.ishint ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.ishint = data.base.ishint
    end
    if data.base ~= nil and data.base.isactive ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.isactive = data.base.isactive
    end
    if data.base ~= nil and data.base.source_npc ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.source_npc = data.base.source_npc
    end
    if data.base ~= nil and data.base.refinelv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.refinelv = data.base.refinelv
    end
    if data.base ~= nil and data.base.chargemoney ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.chargemoney = data.base.chargemoney
    end
    if data.base ~= nil and data.base.overtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.overtime = data.base.overtime
    end
    if data.base ~= nil and data.base.quota ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.quota = data.base.quota
    end
    if data.base ~= nil and data.base.usedtimes ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.usedtimes = data.base.usedtimes
    end
    if data.base ~= nil and data.base.usedtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.usedtime = data.base.usedtime
    end
    if data.base ~= nil and data.base.isfavorite ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.isfavorite = data.base.isfavorite
    end
    if data ~= nil and data.base.mailhint ~= nil then
      if msg.data.base == nil then
        msg.data.base = {}
      end
      if msg.data.base.mailhint == nil then
        msg.data.base.mailhint = {}
      end
      for i = 1, #data.base.mailhint do
        table.insert(msg.data.base.mailhint, data.base.mailhint[i])
      end
    end
    if data.base ~= nil and data.base.subsource ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.subsource = data.base.subsource
    end
    if data.base ~= nil and data.base.randkey ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.randkey = data.base.randkey
    end
    if data.base ~= nil and data.base.sceneinfo ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.sceneinfo = data.base.sceneinfo
    end
    if data.base ~= nil and data.base.local_charge ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.local_charge = data.base.local_charge
    end
    if data.base ~= nil and data.base.charge_deposit_id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.charge_deposit_id = data.base.charge_deposit_id
    end
    if data.base ~= nil and data.base.issplit ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.issplit = data.base.issplit
    end
    if data.base.tmp ~= nil and data.base.tmp.none ~= nil then
      if msg.data.base == nil then
        msg.data.base = {}
      end
      if msg.data.base.tmp == nil then
        msg.data.base.tmp = {}
      end
      msg.data.base.tmp.none = data.base.tmp.none
    end
    if data.base.tmp ~= nil and data.base.tmp.num_param ~= nil then
      if msg.data.base == nil then
        msg.data.base = {}
      end
      if msg.data.base.tmp == nil then
        msg.data.base.tmp = {}
      end
      msg.data.base.tmp.num_param = data.base.tmp.num_param
    end
    if data.base.tmp ~= nil and data.base.tmp.from_reward ~= nil then
      if msg.data.base == nil then
        msg.data.base = {}
      end
      if msg.data.base.tmp == nil then
        msg.data.base.tmp = {}
      end
      msg.data.base.tmp.from_reward = data.base.tmp.from_reward
    end
    if data.base ~= nil and data.base.mount_fashion_activated ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.mount_fashion_activated = data.base.mount_fashion_activated
    end
    if data.base ~= nil and data.base.no_trade_reason ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.base == nil then
        msg.data.base = {}
      end
      msg.data.base.no_trade_reason = data.base.no_trade_reason
    end
    if data.base.card_info ~= nil and data.base.card_info.lv ~= nil then
      if msg.data.base == nil then
        msg.data.base = {}
      end
      if msg.data.base.card_info == nil then
        msg.data.base.card_info = {}
      end
      msg.data.base.card_info.lv = data.base.card_info.lv
    end
    if data ~= nil and data.equiped ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.equiped = data.equiped
    end
    if data ~= nil and data.battlepoint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.battlepoint = data.battlepoint
    end
    if data.equip ~= nil and data.equip.strengthlv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.strengthlv = data.equip.strengthlv
    end
    if data.equip ~= nil and data.equip.refinelv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.refinelv = data.equip.refinelv
    end
    if data.equip ~= nil and data.equip.strengthCost ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.strengthCost = data.equip.strengthCost
    end
    if data ~= nil and data.equip.refineCompose ~= nil then
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      if msg.data.equip.refineCompose == nil then
        msg.data.equip.refineCompose = {}
      end
      for i = 1, #data.equip.refineCompose do
        table.insert(msg.data.equip.refineCompose, data.equip.refineCompose[i])
      end
    end
    if data.equip ~= nil and data.equip.cardslot ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.cardslot = data.equip.cardslot
    end
    if data ~= nil and data.equip.buffid ~= nil then
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      if msg.data.equip.buffid == nil then
        msg.data.equip.buffid = {}
      end
      for i = 1, #data.equip.buffid do
        table.insert(msg.data.equip.buffid, data.equip.buffid[i])
      end
    end
    if data.equip ~= nil and data.equip.damage ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.damage = data.equip.damage
    end
    if data.equip ~= nil and data.equip.lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.lv = data.equip.lv
    end
    if data.equip ~= nil and data.equip.color ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.color = data.equip.color
    end
    if data.equip ~= nil and data.equip.breakstarttime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.breakstarttime = data.equip.breakstarttime
    end
    if data.equip ~= nil and data.equip.breakendtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.breakendtime = data.equip.breakendtime
    end
    if data.equip ~= nil and data.equip.strengthlv2 ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.strengthlv2 = data.equip.strengthlv2
    end
    if data.equip ~= nil and data.equip.quenchper ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.quenchper = data.equip.quenchper
    end
    if data ~= nil and data.equip.strengthlv2cost ~= nil then
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      if msg.data.equip.strengthlv2cost == nil then
        msg.data.equip.strengthlv2cost = {}
      end
      for i = 1, #data.equip.strengthlv2cost do
        table.insert(msg.data.equip.strengthlv2cost, data.equip.strengthlv2cost[i])
      end
    end
    if data ~= nil and data.equip.attrs ~= nil then
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      if msg.data.equip.attrs == nil then
        msg.data.equip.attrs = {}
      end
      for i = 1, #data.equip.attrs do
        table.insert(msg.data.equip.attrs, data.equip.attrs[i])
      end
    end
    if data.equip ~= nil and data.equip.extra_refine_value ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.equip == nil then
        msg.data.equip = {}
      end
      msg.data.equip.extra_refine_value = data.equip.extra_refine_value
    end
    if data ~= nil and data.card ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.card == nil then
        msg.data.card = {}
      end
      for i = 1, #data.card do
        table.insert(msg.data.card, data.card[i])
      end
    end
    if data.enchant ~= nil and data.enchant.type ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.enchant == nil then
        msg.data.enchant = {}
      end
      msg.data.enchant.type = data.enchant.type
    end
    if data ~= nil and data.enchant.attrs ~= nil then
      if msg.data.enchant == nil then
        msg.data.enchant = {}
      end
      if msg.data.enchant.attrs == nil then
        msg.data.enchant.attrs = {}
      end
      for i = 1, #data.enchant.attrs do
        table.insert(msg.data.enchant.attrs, data.enchant.attrs[i])
      end
    end
    if data ~= nil and data.enchant.extras ~= nil then
      if msg.data.enchant == nil then
        msg.data.enchant = {}
      end
      if msg.data.enchant.extras == nil then
        msg.data.enchant.extras = {}
      end
      for i = 1, #data.enchant.extras do
        table.insert(msg.data.enchant.extras, data.enchant.extras[i])
      end
    end
    if data ~= nil and data.enchant.patch ~= nil then
      if msg.data.enchant == nil then
        msg.data.enchant = {}
      end
      if msg.data.enchant.patch == nil then
        msg.data.enchant.patch = {}
      end
      for i = 1, #data.enchant.patch do
        table.insert(msg.data.enchant.patch, data.enchant.patch[i])
      end
    end
    if data.enchant ~= nil and data.enchant.israteup ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.enchant == nil then
        msg.data.enchant = {}
      end
      msg.data.enchant.israteup = data.enchant.israteup
    end
    if data.prenchant ~= nil and data.prenchant.type ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.prenchant == nil then
        msg.data.prenchant = {}
      end
      msg.data.prenchant.type = data.prenchant.type
    end
    if data ~= nil and data.prenchant.attrs ~= nil then
      if msg.data.prenchant == nil then
        msg.data.prenchant = {}
      end
      if msg.data.prenchant.attrs == nil then
        msg.data.prenchant.attrs = {}
      end
      for i = 1, #data.prenchant.attrs do
        table.insert(msg.data.prenchant.attrs, data.prenchant.attrs[i])
      end
    end
    if data ~= nil and data.prenchant.extras ~= nil then
      if msg.data.prenchant == nil then
        msg.data.prenchant = {}
      end
      if msg.data.prenchant.extras == nil then
        msg.data.prenchant.extras = {}
      end
      for i = 1, #data.prenchant.extras do
        table.insert(msg.data.prenchant.extras, data.prenchant.extras[i])
      end
    end
    if data ~= nil and data.prenchant.patch ~= nil then
      if msg.data.prenchant == nil then
        msg.data.prenchant = {}
      end
      if msg.data.prenchant.patch == nil then
        msg.data.prenchant.patch = {}
      end
      for i = 1, #data.prenchant.patch do
        table.insert(msg.data.prenchant.patch, data.prenchant.patch[i])
      end
    end
    if data.prenchant ~= nil and data.prenchant.israteup ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.prenchant == nil then
        msg.data.prenchant = {}
      end
      msg.data.prenchant.israteup = data.prenchant.israteup
    end
    if data.refine ~= nil and data.refine.lastfail ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.refine == nil then
        msg.data.refine = {}
      end
      msg.data.refine.lastfail = data.refine.lastfail
    end
    if data.refine ~= nil and data.refine.repaircount ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.refine == nil then
        msg.data.refine = {}
      end
      msg.data.refine.repaircount = data.refine.repaircount
    end
    if data.refine ~= nil and data.refine.lastfailcount ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.refine == nil then
        msg.data.refine = {}
      end
      msg.data.refine.lastfailcount = data.refine.lastfailcount
    end
    if data.refine ~= nil and data.refine.history_fix_rate ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.refine == nil then
        msg.data.refine = {}
      end
      msg.data.refine.history_fix_rate = data.refine.history_fix_rate
    end
    if data.refine ~= nil and data.refine.cost_count ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.refine == nil then
        msg.data.refine = {}
      end
      msg.data.refine.cost_count = data.refine.cost_count
    end
    if data ~= nil and data.refine.cost_counts ~= nil then
      if msg.data.refine == nil then
        msg.data.refine = {}
      end
      if msg.data.refine.cost_counts == nil then
        msg.data.refine.cost_counts = {}
      end
      for i = 1, #data.refine.cost_counts do
        table.insert(msg.data.refine.cost_counts, data.refine.cost_counts[i])
      end
    end
    if data.egg ~= nil and data.egg.exp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.exp = data.egg.exp
    end
    if data.egg ~= nil and data.egg.friendexp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.friendexp = data.egg.friendexp
    end
    if data.egg ~= nil and data.egg.rewardexp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.rewardexp = data.egg.rewardexp
    end
    if data.egg ~= nil and data.egg.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.id = data.egg.id
    end
    if data.egg ~= nil and data.egg.lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.lv = data.egg.lv
    end
    if data.egg ~= nil and data.egg.friendlv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.friendlv = data.egg.friendlv
    end
    if data.egg ~= nil and data.egg.body ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.body = data.egg.body
    end
    if data.egg ~= nil and data.egg.relivetime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.relivetime = data.egg.relivetime
    end
    if data.egg ~= nil and data.egg.hp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.hp = data.egg.hp
    end
    if data.egg ~= nil and data.egg.restoretime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.restoretime = data.egg.restoretime
    end
    if data.egg ~= nil and data.egg.time_happly ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.time_happly = data.egg.time_happly
    end
    if data.egg ~= nil and data.egg.time_excite ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.time_excite = data.egg.time_excite
    end
    if data.egg ~= nil and data.egg.time_happiness ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.time_happiness = data.egg.time_happiness
    end
    if data.egg ~= nil and data.egg.time_happly_gift ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.time_happly_gift = data.egg.time_happly_gift
    end
    if data.egg ~= nil and data.egg.time_excite_gift ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.time_excite_gift = data.egg.time_excite_gift
    end
    if data.egg ~= nil and data.egg.time_happiness_gift ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.time_happiness_gift = data.egg.time_happiness_gift
    end
    if data.egg ~= nil and data.egg.touch_tick ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.touch_tick = data.egg.touch_tick
    end
    if data.egg ~= nil and data.egg.feed_tick ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.feed_tick = data.egg.feed_tick
    end
    if data.egg ~= nil and data.egg.name ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.name = data.egg.name
    end
    if data.egg ~= nil and data.egg.var ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.var = data.egg.var
    end
    if data ~= nil and data.egg.skillids ~= nil then
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      if msg.data.egg.skillids == nil then
        msg.data.egg.skillids = {}
      end
      for i = 1, #data.egg.skillids do
        table.insert(msg.data.egg.skillids, data.egg.skillids[i])
      end
    end
    if data ~= nil and data.egg.equips ~= nil then
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      if msg.data.egg.equips == nil then
        msg.data.egg.equips = {}
      end
      for i = 1, #data.egg.equips do
        table.insert(msg.data.egg.equips, data.egg.equips[i])
      end
    end
    if data.egg ~= nil and data.egg.buff ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.buff = data.egg.buff
    end
    if data ~= nil and data.egg.unlock_equip ~= nil then
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      if msg.data.egg.unlock_equip == nil then
        msg.data.egg.unlock_equip = {}
      end
      for i = 1, #data.egg.unlock_equip do
        table.insert(msg.data.egg.unlock_equip, data.egg.unlock_equip[i])
      end
    end
    if data ~= nil and data.egg.unlock_body ~= nil then
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      if msg.data.egg.unlock_body == nil then
        msg.data.egg.unlock_body = {}
      end
      for i = 1, #data.egg.unlock_body do
        table.insert(msg.data.egg.unlock_body, data.egg.unlock_body[i])
      end
    end
    if data.egg ~= nil and data.egg.version ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.version = data.egg.version
    end
    if data.egg ~= nil and data.egg.skilloff ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.skilloff = data.egg.skilloff
    end
    if data.egg ~= nil and data.egg.exchange_count ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.exchange_count = data.egg.exchange_count
    end
    if data.egg ~= nil and data.egg.guid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.guid = data.egg.guid
    end
    if data ~= nil and data.egg.defaultwears ~= nil then
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      if msg.data.egg.defaultwears == nil then
        msg.data.egg.defaultwears = {}
      end
      for i = 1, #data.egg.defaultwears do
        table.insert(msg.data.egg.defaultwears, data.egg.defaultwears[i])
      end
    end
    if data ~= nil and data.egg.wears ~= nil then
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      if msg.data.egg.wears == nil then
        msg.data.egg.wears = {}
      end
      for i = 1, #data.egg.wears do
        table.insert(msg.data.egg.wears, data.egg.wears[i])
      end
    end
    if data.egg ~= nil and data.egg.cdtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.egg == nil then
        msg.data.egg = {}
      end
      msg.data.egg.cdtime = data.egg.cdtime
    end
    if data.letter ~= nil and data.letter.sendUserName ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.letter == nil then
        msg.data.letter = {}
      end
      msg.data.letter.sendUserName = data.letter.sendUserName
    end
    if data.letter ~= nil and data.letter.bg ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.letter == nil then
        msg.data.letter = {}
      end
      msg.data.letter.bg = data.letter.bg
    end
    if data.letter ~= nil and data.letter.configID ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.letter == nil then
        msg.data.letter = {}
      end
      msg.data.letter.configID = data.letter.configID
    end
    if data.letter ~= nil and data.letter.content ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.letter == nil then
        msg.data.letter = {}
      end
      msg.data.letter.content = data.letter.content
    end
    if data.letter ~= nil and data.letter.content2 ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.letter == nil then
        msg.data.letter = {}
      end
      msg.data.letter.content2 = data.letter.content2
    end
    if data.code ~= nil and data.code.code ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.code == nil then
        msg.data.code = {}
      end
      msg.data.code.code = data.code.code
    end
    if data.code ~= nil and data.code.used ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.code == nil then
        msg.data.code = {}
      end
      msg.data.code.used = data.code.used
    end
    if data.wedding ~= nil and data.wedding.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.id = data.wedding.id
    end
    if data.wedding ~= nil and data.wedding.zoneid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.zoneid = data.wedding.zoneid
    end
    if data.wedding ~= nil and data.wedding.charid1 ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.charid1 = data.wedding.charid1
    end
    if data.wedding ~= nil and data.wedding.charid2 ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.charid2 = data.wedding.charid2
    end
    if data.wedding ~= nil and data.wedding.weddingtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.weddingtime = data.wedding.weddingtime
    end
    if data.wedding ~= nil and data.wedding.photoidx ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.photoidx = data.wedding.photoidx
    end
    if data.wedding ~= nil and data.wedding.phototime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.phototime = data.wedding.phototime
    end
    if data.wedding ~= nil and data.wedding.myname ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.myname = data.wedding.myname
    end
    if data.wedding ~= nil and data.wedding.partnername ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.partnername = data.wedding.partnername
    end
    if data.wedding ~= nil and data.wedding.starttime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.starttime = data.wedding.starttime
    end
    if data.wedding ~= nil and data.wedding.endtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.endtime = data.wedding.endtime
    end
    if data.wedding ~= nil and data.wedding.notified ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.wedding == nil then
        msg.data.wedding = {}
      end
      msg.data.wedding.notified = data.wedding.notified
    end
    if data.sender ~= nil and data.sender.charid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.sender == nil then
        msg.data.sender = {}
      end
      msg.data.sender.charid = data.sender.charid
    end
    if data.sender ~= nil and data.sender.name ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.sender == nil then
        msg.data.sender = {}
      end
      msg.data.sender.name = data.sender.name
    end
    if data.furniture ~= nil and data.furniture.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.id = data.furniture.id
    end
    if data.furniture ~= nil and data.furniture.angle ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.angle = data.furniture.angle
    end
    if data.furniture ~= nil and data.furniture.lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.lv = data.furniture.lv
    end
    if data.furniture ~= nil and data.furniture.row ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.row = data.furniture.row
    end
    if data.furniture ~= nil and data.furniture.col ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.col = data.furniture.col
    end
    if data.furniture ~= nil and data.furniture.floor ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.floor = data.furniture.floor
    end
    if data.furniture ~= nil and data.furniture.rewardtime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.rewardtime = data.furniture.rewardtime
    end
    if data.furniture ~= nil and data.furniture.state ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.state = data.furniture.state
    end
    if data.furniture ~= nil and data.furniture.guid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.guid = data.furniture.guid
    end
    if data.furniture ~= nil and data.furniture.old_guid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.old_guid = data.furniture.old_guid
    end
    if data.furniture ~= nil and data.furniture.var ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      msg.data.furniture.var = data.furniture.var
    end
    if data ~= nil and data.furniture.seats ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.seats == nil then
        msg.data.furniture.seats = {}
      end
      for i = 1, #data.furniture.seats do
        table.insert(msg.data.furniture.seats, data.furniture.seats[i])
      end
    end
    if data ~= nil and data.furniture.seatskills ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.seatskills == nil then
        msg.data.furniture.seatskills = {}
      end
      for i = 1, #data.furniture.seatskills do
        table.insert(msg.data.furniture.seatskills, data.furniture.seatskills[i])
      end
    end
    if data ~= nil and data.furniture.photos ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.photos == nil then
        msg.data.furniture.photos = {}
      end
      for i = 1, #data.furniture.photos do
        table.insert(msg.data.furniture.photos, data.furniture.photos[i])
      end
    end
    if data.furniture.npc ~= nil and data.furniture.npc.race ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.race = data.furniture.npc.race
    end
    if data.furniture.npc ~= nil and data.furniture.npc.shape ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.shape = data.furniture.npc.shape
    end
    if data.furniture.npc ~= nil and data.furniture.npc.nature ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.nature = data.furniture.npc.nature
    end
    if data.furniture.npc ~= nil and data.furniture.npc.hpreduce ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.hpreduce = data.furniture.npc.hpreduce
    end
    if data.furniture.npc ~= nil and data.furniture.npc.naturelv ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.naturelv = data.furniture.npc.naturelv
    end
    if data ~= nil and data.furniture.npc.history_max ~= nil then
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      if msg.data.furniture.npc.history_max == nil then
        msg.data.furniture.npc.history_max = {}
      end
      for i = 1, #data.furniture.npc.history_max do
        table.insert(msg.data.furniture.npc.history_max, data.furniture.npc.history_max[i])
      end
    end
    if data ~= nil and data.furniture.npc.day_max ~= nil then
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      if msg.data.furniture.npc.day_max == nil then
        msg.data.furniture.npc.day_max = {}
      end
      for i = 1, #data.furniture.npc.day_max do
        table.insert(msg.data.furniture.npc.day_max, data.furniture.npc.day_max[i])
      end
    end
    if data.furniture.npc ~= nil and data.furniture.npc.bosstype ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.bosstype = data.furniture.npc.bosstype
    end
    if data.furniture.npc ~= nil and data.furniture.npc.wood_type ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.wood_type = data.furniture.npc.wood_type
    end
    if data.furniture.npc ~= nil and data.furniture.npc.monster_id ~= nil then
      if msg.data.furniture == nil then
        msg.data.furniture = {}
      end
      if msg.data.furniture.npc == nil then
        msg.data.furniture.npc = {}
      end
      msg.data.furniture.npc.monster_id = data.furniture.npc.monster_id
    end
    if data.attr ~= nil and data.attr.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attr == nil then
        msg.data.attr = {}
      end
      msg.data.attr.id = data.attr.id
    end
    if data.attr ~= nil and data.attr.lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attr == nil then
        msg.data.attr = {}
      end
      msg.data.attr.lv = data.attr.lv
    end
    if data.attr ~= nil and data.attr.exp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attr == nil then
        msg.data.attr = {}
      end
      msg.data.attr.exp = data.attr.exp
    end
    if data.attr ~= nil and data.attr.pos ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attr == nil then
        msg.data.attr = {}
      end
      msg.data.attr.pos = data.attr.pos
    end
    if data.attr ~= nil and data.attr.time ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attr == nil then
        msg.data.attr = {}
      end
      msg.data.attr.time = data.attr.time
    end
    if data.attr ~= nil and data.attr.charid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attr == nil then
        msg.data.attr = {}
      end
      msg.data.attr.charid = data.attr.charid
    end
    if data.skill ~= nil and data.skill.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      msg.data.skill.id = data.skill.id
    end
    if data.skill ~= nil and data.skill.pos ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      msg.data.skill.pos = data.skill.pos
    end
    if data.skill ~= nil and data.skill.charid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      msg.data.skill.charid = data.skill.charid
    end
    if data.skill ~= nil and data.skill.issame ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      msg.data.skill.issame = data.skill.issame
    end
    if data ~= nil and data.skill.buffs ~= nil then
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      if msg.data.skill.buffs == nil then
        msg.data.skill.buffs = {}
      end
      for i = 1, #data.skill.buffs do
        table.insert(msg.data.skill.buffs, data.skill.buffs[i])
      end
    end
    if data ~= nil and data.skill.carves ~= nil then
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      if msg.data.skill.carves == nil then
        msg.data.skill.carves = {}
      end
      for i = 1, #data.skill.carves do
        table.insert(msg.data.skill.carves, data.skill.carves[i])
      end
    end
    if data.skill ~= nil and data.skill.isforbid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      msg.data.skill.isforbid = data.skill.isforbid
    end
    if data.skill ~= nil and data.skill.isfull ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.skill == nil then
        msg.data.skill = {}
      end
      msg.data.skill.isfull = data.skill.isfull
    end
    if data.home ~= nil and data.home.ownerid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.home == nil then
        msg.data.home = {}
      end
      msg.data.home.ownerid = data.home.ownerid
    end
    if data ~= nil and data.artifact.attrs ~= nil then
      if msg.data.artifact == nil then
        msg.data.artifact = {}
      end
      if msg.data.artifact.attrs == nil then
        msg.data.artifact.attrs = {}
      end
      for i = 1, #data.artifact.attrs do
        table.insert(msg.data.artifact.attrs, data.artifact.attrs[i])
      end
    end
    if data ~= nil and data.artifact.preattrs ~= nil then
      if msg.data.artifact == nil then
        msg.data.artifact = {}
      end
      if msg.data.artifact.preattrs == nil then
        msg.data.artifact.preattrs = {}
      end
      for i = 1, #data.artifact.preattrs do
        table.insert(msg.data.artifact.preattrs, data.artifact.preattrs[i])
      end
    end
    if data.artifact ~= nil and data.artifact.art_state ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.artifact == nil then
        msg.data.artifact = {}
      end
      msg.data.artifact.art_state = data.artifact.art_state
    end
    if data ~= nil and data.artifact.art_fragment ~= nil then
      if msg.data.artifact == nil then
        msg.data.artifact = {}
      end
      if msg.data.artifact.art_fragment == nil then
        msg.data.artifact.art_fragment = {}
      end
      for i = 1, #data.artifact.art_fragment do
        table.insert(msg.data.artifact.art_fragment, data.artifact.art_fragment[i])
      end
    end
    if data ~= nil and data.artifact.noattrs ~= nil then
      if msg.data.artifact == nil then
        msg.data.artifact = {}
      end
      if msg.data.artifact.noattrs == nil then
        msg.data.artifact.noattrs = {}
      end
      for i = 1, #data.artifact.noattrs do
        table.insert(msg.data.artifact.noattrs, data.artifact.noattrs[i])
      end
    end
    if data.cupinfo ~= nil and data.cupinfo.name ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.cupinfo == nil then
        msg.data.cupinfo = {}
      end
      msg.data.cupinfo.name = data.cupinfo.name
    end
    if data ~= nil and data.previewattr ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.previewattr == nil then
        msg.data.previewattr = {}
      end
      for i = 1, #data.previewattr do
        table.insert(msg.data.previewattr, data.previewattr[i])
      end
    end
    if data ~= nil and data.previewenchant ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.previewenchant == nil then
        msg.data.previewenchant = {}
      end
      for i = 1, #data.previewenchant do
        table.insert(msg.data.previewenchant, data.previewenchant[i])
      end
    end
    if data.red_packet ~= nil and data.red_packet.config_id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      msg.data.red_packet.config_id = data.red_packet.config_id
    end
    if data.red_packet ~= nil and data.red_packet.min_num ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      msg.data.red_packet.min_num = data.red_packet.min_num
    end
    if data.red_packet ~= nil and data.red_packet.max_num ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      msg.data.red_packet.max_num = data.red_packet.max_num
    end
    if data.red_packet ~= nil and data.red_packet.min_money ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      msg.data.red_packet.min_money = data.red_packet.min_money
    end
    if data.red_packet ~= nil and data.red_packet.max_money ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      msg.data.red_packet.max_money = data.red_packet.max_money
    end
    if data ~= nil and data.red_packet.multi_items ~= nil then
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      if msg.data.red_packet.multi_items == nil then
        msg.data.red_packet.multi_items = {}
      end
      for i = 1, #data.red_packet.multi_items do
        table.insert(msg.data.red_packet.multi_items, data.red_packet.multi_items[i])
      end
    end
    if data.red_packet ~= nil and data.red_packet.gvg_cityid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      msg.data.red_packet.gvg_cityid = data.red_packet.gvg_cityid
    end
    if data ~= nil and data.red_packet.gvg_charids ~= nil then
      if msg.data.red_packet == nil then
        msg.data.red_packet = {}
      end
      if msg.data.red_packet.gvg_charids == nil then
        msg.data.red_packet.gvg_charids = {}
      end
      for i = 1, #data.red_packet.gvg_charids do
        table.insert(msg.data.red_packet.gvg_charids, data.red_packet.gvg_charids[i])
      end
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.id ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      msg.data.gem_secret_land.id = data.gem_secret_land.id
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.color ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      msg.data.gem_secret_land.color = data.gem_secret_land.color
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      msg.data.gem_secret_land.lv = data.gem_secret_land.lv
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.max_lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      msg.data.gem_secret_land.max_lv = data.gem_secret_land.max_lv
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.exp ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      msg.data.gem_secret_land.exp = data.gem_secret_land.exp
    end
    if data ~= nil and data.gem_secret_land.buffs ~= nil then
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      if msg.data.gem_secret_land.buffs == nil then
        msg.data.gem_secret_land.buffs = {}
      end
      for i = 1, #data.gem_secret_land.buffs do
        table.insert(msg.data.gem_secret_land.buffs, data.gem_secret_land.buffs[i])
      end
    end
    if data ~= nil and data.gem_secret_land.char_data ~= nil then
      if msg.data.gem_secret_land == nil then
        msg.data.gem_secret_land = {}
      end
      if msg.data.gem_secret_land.char_data == nil then
        msg.data.gem_secret_land.char_data = {}
      end
      for i = 1, #data.gem_secret_land.char_data do
        table.insert(msg.data.gem_secret_land.char_data, data.gem_secret_land.char_data[i])
      end
    end
    if data.memory ~= nil and data.memory.itemid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.memory == nil then
        msg.data.memory = {}
      end
      msg.data.memory.itemid = data.memory.itemid
    end
    if data.memory ~= nil and data.memory.lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.memory == nil then
        msg.data.memory = {}
      end
      msg.data.memory.lv = data.memory.lv
    end
    if data.memory ~= nil and data.memory.excess_lv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.memory == nil then
        msg.data.memory = {}
      end
      msg.data.memory.excess_lv = data.memory.excess_lv
    end
    if data ~= nil and data.memory.effects ~= nil then
      if msg.data.memory == nil then
        msg.data.memory = {}
      end
      if msg.data.memory.effects == nil then
        msg.data.memory.effects = {}
      end
      for i = 1, #data.memory.effects do
        table.insert(msg.data.memory.effects, data.memory.effects[i])
      end
    end
    if data ~= nil and data.deletetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.deletetime = data.deletetime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryItemData.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if data.base ~= nil and data.base.guid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.guid = data.base.guid
    end
    if data.base ~= nil and data.base.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.id = data.base.id
    end
    if data.base ~= nil and data.base.count ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.count = data.base.count
    end
    if data.base ~= nil and data.base.index ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.index = data.base.index
    end
    if data.base ~= nil and data.base.createtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.createtime = data.base.createtime
    end
    if data.base ~= nil and data.base.cd ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.cd = data.base.cd
    end
    if data.base ~= nil and data.base.type ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.type = data.base.type
    end
    if data.base ~= nil and data.base.bind ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.bind = data.base.bind
    end
    if data.base ~= nil and data.base.expire ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.expire = data.base.expire
    end
    if data.base ~= nil and data.base.quality ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.quality = data.base.quality
    end
    if data.base ~= nil and data.base.equipType ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.equipType = data.base.equipType
    end
    if data.base ~= nil and data.base.source ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.source = data.base.source
    end
    if data.base ~= nil and data.base.isnew ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.isnew = data.base.isnew
    end
    if data.base ~= nil and data.base.maxcardslot ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.maxcardslot = data.base.maxcardslot
    end
    if data.base ~= nil and data.base.ishint ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.ishint = data.base.ishint
    end
    if data.base ~= nil and data.base.isactive ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.isactive = data.base.isactive
    end
    if data.base ~= nil and data.base.source_npc ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.source_npc = data.base.source_npc
    end
    if data.base ~= nil and data.base.refinelv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.refinelv = data.base.refinelv
    end
    if data.base ~= nil and data.base.chargemoney ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.chargemoney = data.base.chargemoney
    end
    if data.base ~= nil and data.base.overtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.overtime = data.base.overtime
    end
    if data.base ~= nil and data.base.quota ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.quota = data.base.quota
    end
    if data.base ~= nil and data.base.usedtimes ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.usedtimes = data.base.usedtimes
    end
    if data.base ~= nil and data.base.usedtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.usedtime = data.base.usedtime
    end
    if data.base ~= nil and data.base.isfavorite ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.isfavorite = data.base.isfavorite
    end
    if data ~= nil and data.base.mailhint ~= nil then
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      if msgParam.data.base.mailhint == nil then
        msgParam.data.base.mailhint = {}
      end
      for i = 1, #data.base.mailhint do
        table.insert(msgParam.data.base.mailhint, data.base.mailhint[i])
      end
    end
    if data.base ~= nil and data.base.subsource ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.subsource = data.base.subsource
    end
    if data.base ~= nil and data.base.randkey ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.randkey = data.base.randkey
    end
    if data.base ~= nil and data.base.sceneinfo ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.sceneinfo = data.base.sceneinfo
    end
    if data.base ~= nil and data.base.local_charge ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.local_charge = data.base.local_charge
    end
    if data.base ~= nil and data.base.charge_deposit_id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.charge_deposit_id = data.base.charge_deposit_id
    end
    if data.base ~= nil and data.base.issplit ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.issplit = data.base.issplit
    end
    if data.base.tmp ~= nil and data.base.tmp.none ~= nil then
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      if msgParam.data.base.tmp == nil then
        msgParam.data.base.tmp = {}
      end
      msgParam.data.base.tmp.none = data.base.tmp.none
    end
    if data.base.tmp ~= nil and data.base.tmp.num_param ~= nil then
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      if msgParam.data.base.tmp == nil then
        msgParam.data.base.tmp = {}
      end
      msgParam.data.base.tmp.num_param = data.base.tmp.num_param
    end
    if data.base.tmp ~= nil and data.base.tmp.from_reward ~= nil then
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      if msgParam.data.base.tmp == nil then
        msgParam.data.base.tmp = {}
      end
      msgParam.data.base.tmp.from_reward = data.base.tmp.from_reward
    end
    if data.base ~= nil and data.base.mount_fashion_activated ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.mount_fashion_activated = data.base.mount_fashion_activated
    end
    if data.base ~= nil and data.base.no_trade_reason ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      msgParam.data.base.no_trade_reason = data.base.no_trade_reason
    end
    if data.base.card_info ~= nil and data.base.card_info.lv ~= nil then
      if msgParam.data.base == nil then
        msgParam.data.base = {}
      end
      if msgParam.data.base.card_info == nil then
        msgParam.data.base.card_info = {}
      end
      msgParam.data.base.card_info.lv = data.base.card_info.lv
    end
    if data ~= nil and data.equiped ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.equiped = data.equiped
    end
    if data ~= nil and data.battlepoint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.battlepoint = data.battlepoint
    end
    if data.equip ~= nil and data.equip.strengthlv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.strengthlv = data.equip.strengthlv
    end
    if data.equip ~= nil and data.equip.refinelv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.refinelv = data.equip.refinelv
    end
    if data.equip ~= nil and data.equip.strengthCost ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.strengthCost = data.equip.strengthCost
    end
    if data ~= nil and data.equip.refineCompose ~= nil then
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      if msgParam.data.equip.refineCompose == nil then
        msgParam.data.equip.refineCompose = {}
      end
      for i = 1, #data.equip.refineCompose do
        table.insert(msgParam.data.equip.refineCompose, data.equip.refineCompose[i])
      end
    end
    if data.equip ~= nil and data.equip.cardslot ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.cardslot = data.equip.cardslot
    end
    if data ~= nil and data.equip.buffid ~= nil then
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      if msgParam.data.equip.buffid == nil then
        msgParam.data.equip.buffid = {}
      end
      for i = 1, #data.equip.buffid do
        table.insert(msgParam.data.equip.buffid, data.equip.buffid[i])
      end
    end
    if data.equip ~= nil and data.equip.damage ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.damage = data.equip.damage
    end
    if data.equip ~= nil and data.equip.lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.lv = data.equip.lv
    end
    if data.equip ~= nil and data.equip.color ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.color = data.equip.color
    end
    if data.equip ~= nil and data.equip.breakstarttime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.breakstarttime = data.equip.breakstarttime
    end
    if data.equip ~= nil and data.equip.breakendtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.breakendtime = data.equip.breakendtime
    end
    if data.equip ~= nil and data.equip.strengthlv2 ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.strengthlv2 = data.equip.strengthlv2
    end
    if data.equip ~= nil and data.equip.quenchper ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.quenchper = data.equip.quenchper
    end
    if data ~= nil and data.equip.strengthlv2cost ~= nil then
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      if msgParam.data.equip.strengthlv2cost == nil then
        msgParam.data.equip.strengthlv2cost = {}
      end
      for i = 1, #data.equip.strengthlv2cost do
        table.insert(msgParam.data.equip.strengthlv2cost, data.equip.strengthlv2cost[i])
      end
    end
    if data ~= nil and data.equip.attrs ~= nil then
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      if msgParam.data.equip.attrs == nil then
        msgParam.data.equip.attrs = {}
      end
      for i = 1, #data.equip.attrs do
        table.insert(msgParam.data.equip.attrs, data.equip.attrs[i])
      end
    end
    if data.equip ~= nil and data.equip.extra_refine_value ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.equip == nil then
        msgParam.data.equip = {}
      end
      msgParam.data.equip.extra_refine_value = data.equip.extra_refine_value
    end
    if data ~= nil and data.card ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.card == nil then
        msgParam.data.card = {}
      end
      for i = 1, #data.card do
        table.insert(msgParam.data.card, data.card[i])
      end
    end
    if data.enchant ~= nil and data.enchant.type ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.enchant == nil then
        msgParam.data.enchant = {}
      end
      msgParam.data.enchant.type = data.enchant.type
    end
    if data ~= nil and data.enchant.attrs ~= nil then
      if msgParam.data.enchant == nil then
        msgParam.data.enchant = {}
      end
      if msgParam.data.enchant.attrs == nil then
        msgParam.data.enchant.attrs = {}
      end
      for i = 1, #data.enchant.attrs do
        table.insert(msgParam.data.enchant.attrs, data.enchant.attrs[i])
      end
    end
    if data ~= nil and data.enchant.extras ~= nil then
      if msgParam.data.enchant == nil then
        msgParam.data.enchant = {}
      end
      if msgParam.data.enchant.extras == nil then
        msgParam.data.enchant.extras = {}
      end
      for i = 1, #data.enchant.extras do
        table.insert(msgParam.data.enchant.extras, data.enchant.extras[i])
      end
    end
    if data ~= nil and data.enchant.patch ~= nil then
      if msgParam.data.enchant == nil then
        msgParam.data.enchant = {}
      end
      if msgParam.data.enchant.patch == nil then
        msgParam.data.enchant.patch = {}
      end
      for i = 1, #data.enchant.patch do
        table.insert(msgParam.data.enchant.patch, data.enchant.patch[i])
      end
    end
    if data.enchant ~= nil and data.enchant.israteup ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.enchant == nil then
        msgParam.data.enchant = {}
      end
      msgParam.data.enchant.israteup = data.enchant.israteup
    end
    if data.prenchant ~= nil and data.prenchant.type ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.prenchant == nil then
        msgParam.data.prenchant = {}
      end
      msgParam.data.prenchant.type = data.prenchant.type
    end
    if data ~= nil and data.prenchant.attrs ~= nil then
      if msgParam.data.prenchant == nil then
        msgParam.data.prenchant = {}
      end
      if msgParam.data.prenchant.attrs == nil then
        msgParam.data.prenchant.attrs = {}
      end
      for i = 1, #data.prenchant.attrs do
        table.insert(msgParam.data.prenchant.attrs, data.prenchant.attrs[i])
      end
    end
    if data ~= nil and data.prenchant.extras ~= nil then
      if msgParam.data.prenchant == nil then
        msgParam.data.prenchant = {}
      end
      if msgParam.data.prenchant.extras == nil then
        msgParam.data.prenchant.extras = {}
      end
      for i = 1, #data.prenchant.extras do
        table.insert(msgParam.data.prenchant.extras, data.prenchant.extras[i])
      end
    end
    if data ~= nil and data.prenchant.patch ~= nil then
      if msgParam.data.prenchant == nil then
        msgParam.data.prenchant = {}
      end
      if msgParam.data.prenchant.patch == nil then
        msgParam.data.prenchant.patch = {}
      end
      for i = 1, #data.prenchant.patch do
        table.insert(msgParam.data.prenchant.patch, data.prenchant.patch[i])
      end
    end
    if data.prenchant ~= nil and data.prenchant.israteup ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.prenchant == nil then
        msgParam.data.prenchant = {}
      end
      msgParam.data.prenchant.israteup = data.prenchant.israteup
    end
    if data.refine ~= nil and data.refine.lastfail ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.refine == nil then
        msgParam.data.refine = {}
      end
      msgParam.data.refine.lastfail = data.refine.lastfail
    end
    if data.refine ~= nil and data.refine.repaircount ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.refine == nil then
        msgParam.data.refine = {}
      end
      msgParam.data.refine.repaircount = data.refine.repaircount
    end
    if data.refine ~= nil and data.refine.lastfailcount ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.refine == nil then
        msgParam.data.refine = {}
      end
      msgParam.data.refine.lastfailcount = data.refine.lastfailcount
    end
    if data.refine ~= nil and data.refine.history_fix_rate ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.refine == nil then
        msgParam.data.refine = {}
      end
      msgParam.data.refine.history_fix_rate = data.refine.history_fix_rate
    end
    if data.refine ~= nil and data.refine.cost_count ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.refine == nil then
        msgParam.data.refine = {}
      end
      msgParam.data.refine.cost_count = data.refine.cost_count
    end
    if data ~= nil and data.refine.cost_counts ~= nil then
      if msgParam.data.refine == nil then
        msgParam.data.refine = {}
      end
      if msgParam.data.refine.cost_counts == nil then
        msgParam.data.refine.cost_counts = {}
      end
      for i = 1, #data.refine.cost_counts do
        table.insert(msgParam.data.refine.cost_counts, data.refine.cost_counts[i])
      end
    end
    if data.egg ~= nil and data.egg.exp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.exp = data.egg.exp
    end
    if data.egg ~= nil and data.egg.friendexp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.friendexp = data.egg.friendexp
    end
    if data.egg ~= nil and data.egg.rewardexp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.rewardexp = data.egg.rewardexp
    end
    if data.egg ~= nil and data.egg.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.id = data.egg.id
    end
    if data.egg ~= nil and data.egg.lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.lv = data.egg.lv
    end
    if data.egg ~= nil and data.egg.friendlv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.friendlv = data.egg.friendlv
    end
    if data.egg ~= nil and data.egg.body ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.body = data.egg.body
    end
    if data.egg ~= nil and data.egg.relivetime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.relivetime = data.egg.relivetime
    end
    if data.egg ~= nil and data.egg.hp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.hp = data.egg.hp
    end
    if data.egg ~= nil and data.egg.restoretime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.restoretime = data.egg.restoretime
    end
    if data.egg ~= nil and data.egg.time_happly ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.time_happly = data.egg.time_happly
    end
    if data.egg ~= nil and data.egg.time_excite ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.time_excite = data.egg.time_excite
    end
    if data.egg ~= nil and data.egg.time_happiness ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.time_happiness = data.egg.time_happiness
    end
    if data.egg ~= nil and data.egg.time_happly_gift ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.time_happly_gift = data.egg.time_happly_gift
    end
    if data.egg ~= nil and data.egg.time_excite_gift ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.time_excite_gift = data.egg.time_excite_gift
    end
    if data.egg ~= nil and data.egg.time_happiness_gift ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.time_happiness_gift = data.egg.time_happiness_gift
    end
    if data.egg ~= nil and data.egg.touch_tick ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.touch_tick = data.egg.touch_tick
    end
    if data.egg ~= nil and data.egg.feed_tick ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.feed_tick = data.egg.feed_tick
    end
    if data.egg ~= nil and data.egg.name ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.name = data.egg.name
    end
    if data.egg ~= nil and data.egg.var ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.var = data.egg.var
    end
    if data ~= nil and data.egg.skillids ~= nil then
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      if msgParam.data.egg.skillids == nil then
        msgParam.data.egg.skillids = {}
      end
      for i = 1, #data.egg.skillids do
        table.insert(msgParam.data.egg.skillids, data.egg.skillids[i])
      end
    end
    if data ~= nil and data.egg.equips ~= nil then
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      if msgParam.data.egg.equips == nil then
        msgParam.data.egg.equips = {}
      end
      for i = 1, #data.egg.equips do
        table.insert(msgParam.data.egg.equips, data.egg.equips[i])
      end
    end
    if data.egg ~= nil and data.egg.buff ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.buff = data.egg.buff
    end
    if data ~= nil and data.egg.unlock_equip ~= nil then
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      if msgParam.data.egg.unlock_equip == nil then
        msgParam.data.egg.unlock_equip = {}
      end
      for i = 1, #data.egg.unlock_equip do
        table.insert(msgParam.data.egg.unlock_equip, data.egg.unlock_equip[i])
      end
    end
    if data ~= nil and data.egg.unlock_body ~= nil then
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      if msgParam.data.egg.unlock_body == nil then
        msgParam.data.egg.unlock_body = {}
      end
      for i = 1, #data.egg.unlock_body do
        table.insert(msgParam.data.egg.unlock_body, data.egg.unlock_body[i])
      end
    end
    if data.egg ~= nil and data.egg.version ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.version = data.egg.version
    end
    if data.egg ~= nil and data.egg.skilloff ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.skilloff = data.egg.skilloff
    end
    if data.egg ~= nil and data.egg.exchange_count ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.exchange_count = data.egg.exchange_count
    end
    if data.egg ~= nil and data.egg.guid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.guid = data.egg.guid
    end
    if data ~= nil and data.egg.defaultwears ~= nil then
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      if msgParam.data.egg.defaultwears == nil then
        msgParam.data.egg.defaultwears = {}
      end
      for i = 1, #data.egg.defaultwears do
        table.insert(msgParam.data.egg.defaultwears, data.egg.defaultwears[i])
      end
    end
    if data ~= nil and data.egg.wears ~= nil then
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      if msgParam.data.egg.wears == nil then
        msgParam.data.egg.wears = {}
      end
      for i = 1, #data.egg.wears do
        table.insert(msgParam.data.egg.wears, data.egg.wears[i])
      end
    end
    if data.egg ~= nil and data.egg.cdtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.egg == nil then
        msgParam.data.egg = {}
      end
      msgParam.data.egg.cdtime = data.egg.cdtime
    end
    if data.letter ~= nil and data.letter.sendUserName ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.letter == nil then
        msgParam.data.letter = {}
      end
      msgParam.data.letter.sendUserName = data.letter.sendUserName
    end
    if data.letter ~= nil and data.letter.bg ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.letter == nil then
        msgParam.data.letter = {}
      end
      msgParam.data.letter.bg = data.letter.bg
    end
    if data.letter ~= nil and data.letter.configID ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.letter == nil then
        msgParam.data.letter = {}
      end
      msgParam.data.letter.configID = data.letter.configID
    end
    if data.letter ~= nil and data.letter.content ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.letter == nil then
        msgParam.data.letter = {}
      end
      msgParam.data.letter.content = data.letter.content
    end
    if data.letter ~= nil and data.letter.content2 ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.letter == nil then
        msgParam.data.letter = {}
      end
      msgParam.data.letter.content2 = data.letter.content2
    end
    if data.code ~= nil and data.code.code ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.code == nil then
        msgParam.data.code = {}
      end
      msgParam.data.code.code = data.code.code
    end
    if data.code ~= nil and data.code.used ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.code == nil then
        msgParam.data.code = {}
      end
      msgParam.data.code.used = data.code.used
    end
    if data.wedding ~= nil and data.wedding.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.id = data.wedding.id
    end
    if data.wedding ~= nil and data.wedding.zoneid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.zoneid = data.wedding.zoneid
    end
    if data.wedding ~= nil and data.wedding.charid1 ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.charid1 = data.wedding.charid1
    end
    if data.wedding ~= nil and data.wedding.charid2 ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.charid2 = data.wedding.charid2
    end
    if data.wedding ~= nil and data.wedding.weddingtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.weddingtime = data.wedding.weddingtime
    end
    if data.wedding ~= nil and data.wedding.photoidx ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.photoidx = data.wedding.photoidx
    end
    if data.wedding ~= nil and data.wedding.phototime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.phototime = data.wedding.phototime
    end
    if data.wedding ~= nil and data.wedding.myname ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.myname = data.wedding.myname
    end
    if data.wedding ~= nil and data.wedding.partnername ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.partnername = data.wedding.partnername
    end
    if data.wedding ~= nil and data.wedding.starttime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.starttime = data.wedding.starttime
    end
    if data.wedding ~= nil and data.wedding.endtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.endtime = data.wedding.endtime
    end
    if data.wedding ~= nil and data.wedding.notified ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.wedding == nil then
        msgParam.data.wedding = {}
      end
      msgParam.data.wedding.notified = data.wedding.notified
    end
    if data.sender ~= nil and data.sender.charid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.sender == nil then
        msgParam.data.sender = {}
      end
      msgParam.data.sender.charid = data.sender.charid
    end
    if data.sender ~= nil and data.sender.name ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.sender == nil then
        msgParam.data.sender = {}
      end
      msgParam.data.sender.name = data.sender.name
    end
    if data.furniture ~= nil and data.furniture.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.id = data.furniture.id
    end
    if data.furniture ~= nil and data.furniture.angle ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.angle = data.furniture.angle
    end
    if data.furniture ~= nil and data.furniture.lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.lv = data.furniture.lv
    end
    if data.furniture ~= nil and data.furniture.row ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.row = data.furniture.row
    end
    if data.furniture ~= nil and data.furniture.col ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.col = data.furniture.col
    end
    if data.furniture ~= nil and data.furniture.floor ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.floor = data.furniture.floor
    end
    if data.furniture ~= nil and data.furniture.rewardtime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.rewardtime = data.furniture.rewardtime
    end
    if data.furniture ~= nil and data.furniture.state ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.state = data.furniture.state
    end
    if data.furniture ~= nil and data.furniture.guid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.guid = data.furniture.guid
    end
    if data.furniture ~= nil and data.furniture.old_guid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.old_guid = data.furniture.old_guid
    end
    if data.furniture ~= nil and data.furniture.var ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      msgParam.data.furniture.var = data.furniture.var
    end
    if data ~= nil and data.furniture.seats ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.seats == nil then
        msgParam.data.furniture.seats = {}
      end
      for i = 1, #data.furniture.seats do
        table.insert(msgParam.data.furniture.seats, data.furniture.seats[i])
      end
    end
    if data ~= nil and data.furniture.seatskills ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.seatskills == nil then
        msgParam.data.furniture.seatskills = {}
      end
      for i = 1, #data.furniture.seatskills do
        table.insert(msgParam.data.furniture.seatskills, data.furniture.seatskills[i])
      end
    end
    if data ~= nil and data.furniture.photos ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.photos == nil then
        msgParam.data.furniture.photos = {}
      end
      for i = 1, #data.furniture.photos do
        table.insert(msgParam.data.furniture.photos, data.furniture.photos[i])
      end
    end
    if data.furniture.npc ~= nil and data.furniture.npc.race ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.race = data.furniture.npc.race
    end
    if data.furniture.npc ~= nil and data.furniture.npc.shape ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.shape = data.furniture.npc.shape
    end
    if data.furniture.npc ~= nil and data.furniture.npc.nature ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.nature = data.furniture.npc.nature
    end
    if data.furniture.npc ~= nil and data.furniture.npc.hpreduce ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.hpreduce = data.furniture.npc.hpreduce
    end
    if data.furniture.npc ~= nil and data.furniture.npc.naturelv ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.naturelv = data.furniture.npc.naturelv
    end
    if data ~= nil and data.furniture.npc.history_max ~= nil then
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      if msgParam.data.furniture.npc.history_max == nil then
        msgParam.data.furniture.npc.history_max = {}
      end
      for i = 1, #data.furniture.npc.history_max do
        table.insert(msgParam.data.furniture.npc.history_max, data.furniture.npc.history_max[i])
      end
    end
    if data ~= nil and data.furniture.npc.day_max ~= nil then
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      if msgParam.data.furniture.npc.day_max == nil then
        msgParam.data.furniture.npc.day_max = {}
      end
      for i = 1, #data.furniture.npc.day_max do
        table.insert(msgParam.data.furniture.npc.day_max, data.furniture.npc.day_max[i])
      end
    end
    if data.furniture.npc ~= nil and data.furniture.npc.bosstype ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.bosstype = data.furniture.npc.bosstype
    end
    if data.furniture.npc ~= nil and data.furniture.npc.wood_type ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.wood_type = data.furniture.npc.wood_type
    end
    if data.furniture.npc ~= nil and data.furniture.npc.monster_id ~= nil then
      if msgParam.data.furniture == nil then
        msgParam.data.furniture = {}
      end
      if msgParam.data.furniture.npc == nil then
        msgParam.data.furniture.npc = {}
      end
      msgParam.data.furniture.npc.monster_id = data.furniture.npc.monster_id
    end
    if data.attr ~= nil and data.attr.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attr == nil then
        msgParam.data.attr = {}
      end
      msgParam.data.attr.id = data.attr.id
    end
    if data.attr ~= nil and data.attr.lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attr == nil then
        msgParam.data.attr = {}
      end
      msgParam.data.attr.lv = data.attr.lv
    end
    if data.attr ~= nil and data.attr.exp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attr == nil then
        msgParam.data.attr = {}
      end
      msgParam.data.attr.exp = data.attr.exp
    end
    if data.attr ~= nil and data.attr.pos ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attr == nil then
        msgParam.data.attr = {}
      end
      msgParam.data.attr.pos = data.attr.pos
    end
    if data.attr ~= nil and data.attr.time ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attr == nil then
        msgParam.data.attr = {}
      end
      msgParam.data.attr.time = data.attr.time
    end
    if data.attr ~= nil and data.attr.charid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attr == nil then
        msgParam.data.attr = {}
      end
      msgParam.data.attr.charid = data.attr.charid
    end
    if data.skill ~= nil and data.skill.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      msgParam.data.skill.id = data.skill.id
    end
    if data.skill ~= nil and data.skill.pos ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      msgParam.data.skill.pos = data.skill.pos
    end
    if data.skill ~= nil and data.skill.charid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      msgParam.data.skill.charid = data.skill.charid
    end
    if data.skill ~= nil and data.skill.issame ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      msgParam.data.skill.issame = data.skill.issame
    end
    if data ~= nil and data.skill.buffs ~= nil then
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      if msgParam.data.skill.buffs == nil then
        msgParam.data.skill.buffs = {}
      end
      for i = 1, #data.skill.buffs do
        table.insert(msgParam.data.skill.buffs, data.skill.buffs[i])
      end
    end
    if data ~= nil and data.skill.carves ~= nil then
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      if msgParam.data.skill.carves == nil then
        msgParam.data.skill.carves = {}
      end
      for i = 1, #data.skill.carves do
        table.insert(msgParam.data.skill.carves, data.skill.carves[i])
      end
    end
    if data.skill ~= nil and data.skill.isforbid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      msgParam.data.skill.isforbid = data.skill.isforbid
    end
    if data.skill ~= nil and data.skill.isfull ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.skill == nil then
        msgParam.data.skill = {}
      end
      msgParam.data.skill.isfull = data.skill.isfull
    end
    if data.home ~= nil and data.home.ownerid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.home == nil then
        msgParam.data.home = {}
      end
      msgParam.data.home.ownerid = data.home.ownerid
    end
    if data ~= nil and data.artifact.attrs ~= nil then
      if msgParam.data.artifact == nil then
        msgParam.data.artifact = {}
      end
      if msgParam.data.artifact.attrs == nil then
        msgParam.data.artifact.attrs = {}
      end
      for i = 1, #data.artifact.attrs do
        table.insert(msgParam.data.artifact.attrs, data.artifact.attrs[i])
      end
    end
    if data ~= nil and data.artifact.preattrs ~= nil then
      if msgParam.data.artifact == nil then
        msgParam.data.artifact = {}
      end
      if msgParam.data.artifact.preattrs == nil then
        msgParam.data.artifact.preattrs = {}
      end
      for i = 1, #data.artifact.preattrs do
        table.insert(msgParam.data.artifact.preattrs, data.artifact.preattrs[i])
      end
    end
    if data.artifact ~= nil and data.artifact.art_state ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.artifact == nil then
        msgParam.data.artifact = {}
      end
      msgParam.data.artifact.art_state = data.artifact.art_state
    end
    if data ~= nil and data.artifact.art_fragment ~= nil then
      if msgParam.data.artifact == nil then
        msgParam.data.artifact = {}
      end
      if msgParam.data.artifact.art_fragment == nil then
        msgParam.data.artifact.art_fragment = {}
      end
      for i = 1, #data.artifact.art_fragment do
        table.insert(msgParam.data.artifact.art_fragment, data.artifact.art_fragment[i])
      end
    end
    if data ~= nil and data.artifact.noattrs ~= nil then
      if msgParam.data.artifact == nil then
        msgParam.data.artifact = {}
      end
      if msgParam.data.artifact.noattrs == nil then
        msgParam.data.artifact.noattrs = {}
      end
      for i = 1, #data.artifact.noattrs do
        table.insert(msgParam.data.artifact.noattrs, data.artifact.noattrs[i])
      end
    end
    if data.cupinfo ~= nil and data.cupinfo.name ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.cupinfo == nil then
        msgParam.data.cupinfo = {}
      end
      msgParam.data.cupinfo.name = data.cupinfo.name
    end
    if data ~= nil and data.previewattr ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.previewattr == nil then
        msgParam.data.previewattr = {}
      end
      for i = 1, #data.previewattr do
        table.insert(msgParam.data.previewattr, data.previewattr[i])
      end
    end
    if data ~= nil and data.previewenchant ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.previewenchant == nil then
        msgParam.data.previewenchant = {}
      end
      for i = 1, #data.previewenchant do
        table.insert(msgParam.data.previewenchant, data.previewenchant[i])
      end
    end
    if data.red_packet ~= nil and data.red_packet.config_id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      msgParam.data.red_packet.config_id = data.red_packet.config_id
    end
    if data.red_packet ~= nil and data.red_packet.min_num ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      msgParam.data.red_packet.min_num = data.red_packet.min_num
    end
    if data.red_packet ~= nil and data.red_packet.max_num ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      msgParam.data.red_packet.max_num = data.red_packet.max_num
    end
    if data.red_packet ~= nil and data.red_packet.min_money ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      msgParam.data.red_packet.min_money = data.red_packet.min_money
    end
    if data.red_packet ~= nil and data.red_packet.max_money ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      msgParam.data.red_packet.max_money = data.red_packet.max_money
    end
    if data ~= nil and data.red_packet.multi_items ~= nil then
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      if msgParam.data.red_packet.multi_items == nil then
        msgParam.data.red_packet.multi_items = {}
      end
      for i = 1, #data.red_packet.multi_items do
        table.insert(msgParam.data.red_packet.multi_items, data.red_packet.multi_items[i])
      end
    end
    if data.red_packet ~= nil and data.red_packet.gvg_cityid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      msgParam.data.red_packet.gvg_cityid = data.red_packet.gvg_cityid
    end
    if data ~= nil and data.red_packet.gvg_charids ~= nil then
      if msgParam.data.red_packet == nil then
        msgParam.data.red_packet = {}
      end
      if msgParam.data.red_packet.gvg_charids == nil then
        msgParam.data.red_packet.gvg_charids = {}
      end
      for i = 1, #data.red_packet.gvg_charids do
        table.insert(msgParam.data.red_packet.gvg_charids, data.red_packet.gvg_charids[i])
      end
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.id ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      msgParam.data.gem_secret_land.id = data.gem_secret_land.id
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.color ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      msgParam.data.gem_secret_land.color = data.gem_secret_land.color
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      msgParam.data.gem_secret_land.lv = data.gem_secret_land.lv
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.max_lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      msgParam.data.gem_secret_land.max_lv = data.gem_secret_land.max_lv
    end
    if data.gem_secret_land ~= nil and data.gem_secret_land.exp ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      msgParam.data.gem_secret_land.exp = data.gem_secret_land.exp
    end
    if data ~= nil and data.gem_secret_land.buffs ~= nil then
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      if msgParam.data.gem_secret_land.buffs == nil then
        msgParam.data.gem_secret_land.buffs = {}
      end
      for i = 1, #data.gem_secret_land.buffs do
        table.insert(msgParam.data.gem_secret_land.buffs, data.gem_secret_land.buffs[i])
      end
    end
    if data ~= nil and data.gem_secret_land.char_data ~= nil then
      if msgParam.data.gem_secret_land == nil then
        msgParam.data.gem_secret_land = {}
      end
      if msgParam.data.gem_secret_land.char_data == nil then
        msgParam.data.gem_secret_land.char_data = {}
      end
      for i = 1, #data.gem_secret_land.char_data do
        table.insert(msgParam.data.gem_secret_land.char_data, data.gem_secret_land.char_data[i])
      end
    end
    if data.memory ~= nil and data.memory.itemid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.memory == nil then
        msgParam.data.memory = {}
      end
      msgParam.data.memory.itemid = data.memory.itemid
    end
    if data.memory ~= nil and data.memory.lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.memory == nil then
        msgParam.data.memory = {}
      end
      msgParam.data.memory.lv = data.memory.lv
    end
    if data.memory ~= nil and data.memory.excess_lv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.memory == nil then
        msgParam.data.memory = {}
      end
      msgParam.data.memory.excess_lv = data.memory.excess_lv
    end
    if data ~= nil and data.memory.effects ~= nil then
      if msgParam.data.memory == nil then
        msgParam.data.memory = {}
      end
      if msgParam.data.memory.effects == nil then
        msgParam.data.memory.effects = {}
      end
      for i = 1, #data.memory.effects do
        table.insert(msgParam.data.memory.effects, data.memory.effects[i])
      end
    end
    if data ~= nil and data.deletetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.deletetime = data.deletetime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallPlayExpressionChatCmd(charid, expressionid)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.PlayExpressionChatCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if expressionid ~= nil then
      msg.expressionid = expressionid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlayExpressionChatCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if expressionid ~= nil then
      msgParam.expressionid = expressionid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallQueryUserInfoChatCmd(charid, msgid, type, data)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryUserInfoChatCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    if type ~= nil then
      msg.type = type
    end
    if data ~= nil and data.data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.data = data.data
    end
    if data ~= nil and data.first ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.first = data.first
    end
    if data ~= nil and data.over ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.over = data.over
    end
    if data ~= nil and data.zoneid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.zoneid = data.zoneid
    end
    if data ~= nil and data.processid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.processid = data.processid
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserInfoChatCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if data ~= nil and data.data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.data = data.data
    end
    if data ~= nil and data.first ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.first = data.first
    end
    if data ~= nil and data.over ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.over = data.over
    end
    if data ~= nil and data.zoneid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.zoneid = data.zoneid
    end
    if data ~= nil and data.processid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.processid = data.processid
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallQueryUserGemChatCmd(accid, charid, info)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryUserGemChatCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if info ~= nil and info.attrgems ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.attrgems == nil then
        msg.info.attrgems = {}
      end
      for i = 1, #info.attrgems do
        table.insert(msg.info.attrgems, info.attrgems[i])
      end
    end
    if info ~= nil and info.skillgems ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.skillgems == nil then
        msg.info.skillgems = {}
      end
      for i = 1, #info.skillgems do
        table.insert(msg.info.skillgems, info.skillgems[i])
      end
    end
    if info ~= nil and info.extra_feature_level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.extra_feature_level = info.extra_feature_level
    end
    if info ~= nil and info.secretlandgems ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.secretlandgems == nil then
        msg.info.secretlandgems = {}
      end
      for i = 1, #info.secretlandgems do
        table.insert(msg.info.secretlandgems, info.secretlandgems[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserGemChatCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if info ~= nil and info.attrgems ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.attrgems == nil then
        msgParam.info.attrgems = {}
      end
      for i = 1, #info.attrgems do
        table.insert(msgParam.info.attrgems, info.attrgems[i])
      end
    end
    if info ~= nil and info.skillgems ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.skillgems == nil then
        msgParam.info.skillgems = {}
      end
      for i = 1, #info.skillgems do
        table.insert(msgParam.info.skillgems, info.skillgems[i])
      end
    end
    if info ~= nil and info.extra_feature_level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.extra_feature_level = info.extra_feature_level
    end
    if info ~= nil and info.secretlandgems ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.secretlandgems == nil then
        msgParam.info.secretlandgems = {}
      end
      for i = 1, #info.secretlandgems do
        table.insert(msgParam.info.secretlandgems, info.secretlandgems[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallBarrageChatCmd(opt)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.BarrageChatCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BarrageChatCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallBarrageMsgChatCmd(str, msgpos, clr, speed, userid, frame, bshieldword)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.BarrageMsgChatCmd()
    if str ~= nil then
      msg.str = str
    end
    if msgpos ~= nil and msgpos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.msgpos == nil then
        msg.msgpos = {}
      end
      msg.msgpos.x = msgpos.x
    end
    if msgpos ~= nil and msgpos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.msgpos == nil then
        msg.msgpos = {}
      end
      msg.msgpos.y = msgpos.y
    end
    if msgpos ~= nil and msgpos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.msgpos == nil then
        msg.msgpos = {}
      end
      msg.msgpos.z = msgpos.z
    end
    if clr ~= nil and clr.r ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.clr == nil then
        msg.clr = {}
      end
      msg.clr.r = clr.r
    end
    if clr ~= nil and clr.g ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.clr == nil then
        msg.clr = {}
      end
      msg.clr.g = clr.g
    end
    if clr ~= nil and clr.b ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.clr == nil then
        msg.clr = {}
      end
      msg.clr.b = clr.b
    end
    if speed ~= nil then
      msg.speed = speed
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if frame ~= nil then
      msg.frame = frame
    end
    if bshieldword ~= nil then
      msg.bshieldword = bshieldword
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BarrageMsgChatCmd.id
    local msgParam = {}
    if str ~= nil then
      msgParam.str = str
    end
    if msgpos ~= nil and msgpos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.msgpos == nil then
        msgParam.msgpos = {}
      end
      msgParam.msgpos.x = msgpos.x
    end
    if msgpos ~= nil and msgpos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.msgpos == nil then
        msgParam.msgpos = {}
      end
      msgParam.msgpos.y = msgpos.y
    end
    if msgpos ~= nil and msgpos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.msgpos == nil then
        msgParam.msgpos = {}
      end
      msgParam.msgpos.z = msgpos.z
    end
    if clr ~= nil and clr.r ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.clr == nil then
        msgParam.clr = {}
      end
      msgParam.clr.r = clr.r
    end
    if clr ~= nil and clr.g ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.clr == nil then
        msgParam.clr = {}
      end
      msgParam.clr.g = clr.g
    end
    if clr ~= nil and clr.b ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.clr == nil then
        msgParam.clr = {}
      end
      msgParam.clr.b = clr.b
    end
    if speed ~= nil then
      msgParam.speed = speed
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    if frame ~= nil then
      msgParam.frame = frame
    end
    if bshieldword ~= nil then
      msgParam.bshieldword = bshieldword
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallChatCmd(channel, str, desID, voice, voicetime, msgid, msgover, photo, expression, bshieldword, items, love_confession)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ChatCmd()
    if channel ~= nil then
      msg.channel = channel
    end
    if msg == nil then
      msg = {}
    end
    msg.str = str
    if desID ~= nil then
      msg.desID = desID
    end
    if voice ~= nil then
      msg.voice = voice
    end
    if voicetime ~= nil then
      msg.voicetime = voicetime
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    if msgover ~= nil then
      msg.msgover = msgover
    end
    if photo ~= nil and photo.accid_svr ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.accid_svr = photo.accid_svr
    end
    if photo ~= nil and photo.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.accid = photo.accid
    end
    if photo ~= nil and photo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.charid = photo.charid
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.time = photo.time
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.sourceid = photo.sourceid
    end
    if photo ~= nil and photo.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.source = photo.source
    end
    if expression ~= nil and expression.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      msg.expression.type = expression.type
    end
    if expression ~= nil and expression.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      msg.expression.id = expression.id
    end
    if expression ~= nil and expression.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      msg.expression.pos = expression.pos
    end
    if bshieldword ~= nil then
      msg.bshieldword = bshieldword
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
    if love_confession ~= nil then
      msg.love_confession = love_confession
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChatCmd.id
    local msgParam = {}
    if channel ~= nil then
      msgParam.channel = channel
    end
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.str = str
    if desID ~= nil then
      msgParam.desID = desID
    end
    if voice ~= nil then
      msgParam.voice = voice
    end
    if voicetime ~= nil then
      msgParam.voicetime = voicetime
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    if msgover ~= nil then
      msgParam.msgover = msgover
    end
    if photo ~= nil and photo.accid_svr ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.accid_svr = photo.accid_svr
    end
    if photo ~= nil and photo.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.accid = photo.accid
    end
    if photo ~= nil and photo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.charid = photo.charid
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.time = photo.time
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.sourceid = photo.sourceid
    end
    if photo ~= nil and photo.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.source = photo.source
    end
    if expression ~= nil and expression.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      msgParam.expression.type = expression.type
    end
    if expression ~= nil and expression.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      msgParam.expression.id = expression.id
    end
    if expression ~= nil and expression.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      msgParam.expression.pos = expression.pos
    end
    if bshieldword ~= nil then
      msgParam.bshieldword = bshieldword
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
    if love_confession ~= nil then
      msgParam.love_confession = love_confession
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallChatRetCmd(accid, id, targetid, portrait, frame, baselevel, voiceid, voicetime, hair, haircolor, body, appellation, msgid, head, face, mouth, eye, roomid, portrait_frame, serverid, channel, rolejob, gender, blink, str, name, guildname, sysmsgid, photo, expression, redpacketret, isreturnuser, chat_frame, items, share_data, love_confession, postcard, timestamp, recall_time)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ChatRetCmd()
    if msg == nil then
      msg = {}
    end
    msg.accid = accid
    if msg == nil then
      msg = {}
    end
    msg.id = id
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if msg == nil then
      msg = {}
    end
    msg.portrait = portrait
    if msg == nil then
      msg = {}
    end
    msg.frame = frame
    if baselevel ~= nil then
      msg.baselevel = baselevel
    end
    if voiceid ~= nil then
      msg.voiceid = voiceid
    end
    if voicetime ~= nil then
      msg.voicetime = voicetime
    end
    if hair ~= nil then
      msg.hair = hair
    end
    if haircolor ~= nil then
      msg.haircolor = haircolor
    end
    if body ~= nil then
      msg.body = body
    end
    if appellation ~= nil then
      msg.appellation = appellation
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    if head ~= nil then
      msg.head = head
    end
    if face ~= nil then
      msg.face = face
    end
    if mouth ~= nil then
      msg.mouth = mouth
    end
    if eye ~= nil then
      msg.eye = eye
    end
    if roomid ~= nil then
      msg.roomid = roomid
    end
    if portrait_frame ~= nil then
      msg.portrait_frame = portrait_frame
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if channel ~= nil then
      msg.channel = channel
    end
    if rolejob ~= nil then
      msg.rolejob = rolejob
    end
    if gender ~= nil then
      msg.gender = gender
    end
    if blink ~= nil then
      msg.blink = blink
    end
    if msg == nil then
      msg = {}
    end
    msg.str = str
    if msg == nil then
      msg = {}
    end
    msg.name = name
    if guildname ~= nil then
      msg.guildname = guildname
    end
    if sysmsgid ~= nil then
      msg.sysmsgid = sysmsgid
    end
    if photo ~= nil and photo.accid_svr ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.accid_svr = photo.accid_svr
    end
    if photo ~= nil and photo.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.accid = photo.accid
    end
    if photo ~= nil and photo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.charid = photo.charid
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.time = photo.time
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.sourceid = photo.sourceid
    end
    if photo ~= nil and photo.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.source = photo.source
    end
    if expression ~= nil and expression.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      msg.expression.type = expression.type
    end
    if expression ~= nil and expression.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      msg.expression.id = expression.id
    end
    if expression ~= nil and expression.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      msg.expression.pos = expression.pos
    end
    if redpacketret ~= nil and redpacketret.strRedPacketID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      msg.redpacketret.strRedPacketID = redpacketret.strRedPacketID
    end
    if redpacketret ~= nil and redpacketret.itemID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      msg.redpacketret.itemID = redpacketret.itemID
    end
    if redpacketret ~= nil and redpacketret.str ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      msg.redpacketret.str = redpacketret.str
    end
    if redpacketret ~= nil and redpacketret.guild_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      msg.redpacketret.guild_job = redpacketret.guild_job
    end
    if redpacketret ~= nil and redpacketret.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      msg.redpacketret.guildid = redpacketret.guildid
    end
    if redpacketret ~= nil and redpacketret.targetid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      msg.redpacketret.targetid = redpacketret.targetid
    end
    if redpacketret ~= nil and redpacketret.gvg_charids ~= nil then
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      if msg.redpacketret.gvg_charids == nil then
        msg.redpacketret.gvg_charids = {}
      end
      for i = 1, #redpacketret.gvg_charids do
        table.insert(msg.redpacketret.gvg_charids, redpacketret.gvg_charids[i])
      end
    end
    if redpacketret ~= nil and redpacketret.praise_charids ~= nil then
      if msg.redpacketret == nil then
        msg.redpacketret = {}
      end
      if msg.redpacketret.praise_charids == nil then
        msg.redpacketret.praise_charids = {}
      end
      for i = 1, #redpacketret.praise_charids do
        table.insert(msg.redpacketret.praise_charids, redpacketret.praise_charids[i])
      end
    end
    if isreturnuser ~= nil then
      msg.isreturnuser = isreturnuser
    end
    if chat_frame ~= nil then
      msg.chat_frame = chat_frame
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
    if share_data ~= nil and share_data.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.share_data == nil then
        msg.share_data = {}
      end
      msg.share_data.type = share_data.type
    end
    if share_data ~= nil and share_data.share_items ~= nil then
      if msg.share_data == nil then
        msg.share_data = {}
      end
      if msg.share_data.share_items == nil then
        msg.share_data.share_items = {}
      end
      for i = 1, #share_data.share_items do
        table.insert(msg.share_data.share_items, share_data.share_items[i])
      end
    end
    if share_data ~= nil and share_data.items ~= nil then
      if msg.share_data == nil then
        msg.share_data = {}
      end
      if msg.share_data.items == nil then
        msg.share_data.items = {}
      end
      for i = 1, #share_data.items do
        table.insert(msg.share_data.items, share_data.items[i])
      end
    end
    if love_confession ~= nil then
      msg.love_confession = love_confession
    end
    if postcard ~= nil and postcard.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.id = postcard.id
    end
    if postcard ~= nil and postcard.url ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.url = postcard.url
    end
    if postcard ~= nil and postcard.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.type = postcard.type
    end
    if postcard ~= nil and postcard.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.source = postcard.source
    end
    if postcard ~= nil and postcard.from_char ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.from_char = postcard.from_char
    end
    if postcard ~= nil and postcard.from_name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.from_name = postcard.from_name
    end
    if postcard ~= nil and postcard.paper_style ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.paper_style = postcard.paper_style
    end
    if postcard ~= nil and postcard.content ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.content = postcard.content
    end
    if postcard ~= nil and postcard.save_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.save_time = postcard.save_time
    end
    if postcard ~= nil and postcard.quest_postcard_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.postcard == nil then
        msg.postcard = {}
      end
      msg.postcard.quest_postcard_id = postcard.quest_postcard_id
    end
    if timestamp ~= nil then
      msg.timestamp = timestamp
    end
    if recall_time ~= nil then
      msg.recall_time = recall_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChatRetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.accid = accid
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.id = id
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.portrait = portrait
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.frame = frame
    if baselevel ~= nil then
      msgParam.baselevel = baselevel
    end
    if voiceid ~= nil then
      msgParam.voiceid = voiceid
    end
    if voicetime ~= nil then
      msgParam.voicetime = voicetime
    end
    if hair ~= nil then
      msgParam.hair = hair
    end
    if haircolor ~= nil then
      msgParam.haircolor = haircolor
    end
    if body ~= nil then
      msgParam.body = body
    end
    if appellation ~= nil then
      msgParam.appellation = appellation
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    if head ~= nil then
      msgParam.head = head
    end
    if face ~= nil then
      msgParam.face = face
    end
    if mouth ~= nil then
      msgParam.mouth = mouth
    end
    if eye ~= nil then
      msgParam.eye = eye
    end
    if roomid ~= nil then
      msgParam.roomid = roomid
    end
    if portrait_frame ~= nil then
      msgParam.portrait_frame = portrait_frame
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if channel ~= nil then
      msgParam.channel = channel
    end
    if rolejob ~= nil then
      msgParam.rolejob = rolejob
    end
    if gender ~= nil then
      msgParam.gender = gender
    end
    if blink ~= nil then
      msgParam.blink = blink
    end
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.str = str
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.name = name
    if guildname ~= nil then
      msgParam.guildname = guildname
    end
    if sysmsgid ~= nil then
      msgParam.sysmsgid = sysmsgid
    end
    if photo ~= nil and photo.accid_svr ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.accid_svr = photo.accid_svr
    end
    if photo ~= nil and photo.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.accid = photo.accid
    end
    if photo ~= nil and photo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.charid = photo.charid
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.time = photo.time
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.sourceid = photo.sourceid
    end
    if photo ~= nil and photo.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.source = photo.source
    end
    if expression ~= nil and expression.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      msgParam.expression.type = expression.type
    end
    if expression ~= nil and expression.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      msgParam.expression.id = expression.id
    end
    if expression ~= nil and expression.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      msgParam.expression.pos = expression.pos
    end
    if redpacketret ~= nil and redpacketret.strRedPacketID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      msgParam.redpacketret.strRedPacketID = redpacketret.strRedPacketID
    end
    if redpacketret ~= nil and redpacketret.itemID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      msgParam.redpacketret.itemID = redpacketret.itemID
    end
    if redpacketret ~= nil and redpacketret.str ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      msgParam.redpacketret.str = redpacketret.str
    end
    if redpacketret ~= nil and redpacketret.guild_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      msgParam.redpacketret.guild_job = redpacketret.guild_job
    end
    if redpacketret ~= nil and redpacketret.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      msgParam.redpacketret.guildid = redpacketret.guildid
    end
    if redpacketret ~= nil and redpacketret.targetid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      msgParam.redpacketret.targetid = redpacketret.targetid
    end
    if redpacketret ~= nil and redpacketret.gvg_charids ~= nil then
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      if msgParam.redpacketret.gvg_charids == nil then
        msgParam.redpacketret.gvg_charids = {}
      end
      for i = 1, #redpacketret.gvg_charids do
        table.insert(msgParam.redpacketret.gvg_charids, redpacketret.gvg_charids[i])
      end
    end
    if redpacketret ~= nil and redpacketret.praise_charids ~= nil then
      if msgParam.redpacketret == nil then
        msgParam.redpacketret = {}
      end
      if msgParam.redpacketret.praise_charids == nil then
        msgParam.redpacketret.praise_charids = {}
      end
      for i = 1, #redpacketret.praise_charids do
        table.insert(msgParam.redpacketret.praise_charids, redpacketret.praise_charids[i])
      end
    end
    if isreturnuser ~= nil then
      msgParam.isreturnuser = isreturnuser
    end
    if chat_frame ~= nil then
      msgParam.chat_frame = chat_frame
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
    if share_data ~= nil and share_data.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.share_data == nil then
        msgParam.share_data = {}
      end
      msgParam.share_data.type = share_data.type
    end
    if share_data ~= nil and share_data.share_items ~= nil then
      if msgParam.share_data == nil then
        msgParam.share_data = {}
      end
      if msgParam.share_data.share_items == nil then
        msgParam.share_data.share_items = {}
      end
      for i = 1, #share_data.share_items do
        table.insert(msgParam.share_data.share_items, share_data.share_items[i])
      end
    end
    if share_data ~= nil and share_data.items ~= nil then
      if msgParam.share_data == nil then
        msgParam.share_data = {}
      end
      if msgParam.share_data.items == nil then
        msgParam.share_data.items = {}
      end
      for i = 1, #share_data.items do
        table.insert(msgParam.share_data.items, share_data.items[i])
      end
    end
    if love_confession ~= nil then
      msgParam.love_confession = love_confession
    end
    if postcard ~= nil and postcard.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.id = postcard.id
    end
    if postcard ~= nil and postcard.url ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.url = postcard.url
    end
    if postcard ~= nil and postcard.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.type = postcard.type
    end
    if postcard ~= nil and postcard.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.source = postcard.source
    end
    if postcard ~= nil and postcard.from_char ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.from_char = postcard.from_char
    end
    if postcard ~= nil and postcard.from_name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.from_name = postcard.from_name
    end
    if postcard ~= nil and postcard.paper_style ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.paper_style = postcard.paper_style
    end
    if postcard ~= nil and postcard.content ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.content = postcard.content
    end
    if postcard ~= nil and postcard.save_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.save_time = postcard.save_time
    end
    if postcard ~= nil and postcard.quest_postcard_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.postcard == nil then
        msgParam.postcard = {}
      end
      msgParam.postcard.quest_postcard_id = postcard.quest_postcard_id
    end
    if timestamp ~= nil then
      msgParam.timestamp = timestamp
    end
    if recall_time ~= nil then
      msgParam.recall_time = recall_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallQueryVoiceUserCmd(voiceid, voice, msgid, msgover)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryVoiceUserCmd()
    if voiceid ~= nil then
      msg.voiceid = voiceid
    end
    if voice ~= nil then
      msg.voice = voice
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    if msgover ~= nil then
      msg.msgover = msgover
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryVoiceUserCmd.id
    local msgParam = {}
    if voiceid ~= nil then
      msgParam.voiceid = voiceid
    end
    if voice ~= nil then
      msgParam.voice = voice
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    if msgover ~= nil then
      msgParam.msgover = msgover
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallGetVoiceIDChatCmd(id)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.GetVoiceIDChatCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetVoiceIDChatCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallLoveLetterNtf(name, content, type, bg, letterID, configID, content2)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.LoveLetterNtf()
    if name ~= nil then
      msg.name = name
    end
    if content ~= nil then
      msg.content = content
    end
    if type ~= nil then
      msg.type = type
    end
    if bg ~= nil then
      msg.bg = bg
    end
    if letterID ~= nil then
      msg.letterID = letterID
    end
    if configID ~= nil then
      msg.configID = configID
    end
    if content2 ~= nil then
      msg.content2 = content2
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LoveLetterNtf.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if content ~= nil then
      msgParam.content = content
    end
    if type ~= nil then
      msgParam.type = type
    end
    if bg ~= nil then
      msgParam.bg = bg
    end
    if letterID ~= nil then
      msgParam.letterID = letterID
    end
    if configID ~= nil then
      msgParam.configID = configID
    end
    if content2 ~= nil then
      msgParam.content2 = content2
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallChatSelfNtf(chat)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ChatSelfNtf()
    if chat ~= nil and chat.cmd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.cmd = chat.cmd
    end
    if chat ~= nil and chat.param ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.param = chat.param
    end
    if chat ~= nil and chat.channel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.channel = chat.channel
    end
    if msg.chat == nil then
      msg.chat = {}
    end
    msg.chat.str = chat.str
    if chat ~= nil and chat.desID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.desID = chat.desID
    end
    if chat ~= nil and chat.voice ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.voice = chat.voice
    end
    if chat ~= nil and chat.voicetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.voicetime = chat.voicetime
    end
    if chat ~= nil and chat.msgid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.msgid = chat.msgid
    end
    if chat ~= nil and chat.msgover ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.msgover = chat.msgover
    end
    if chat.photo ~= nil and chat.photo.accid_svr ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.accid_svr = chat.photo.accid_svr
    end
    if chat.photo ~= nil and chat.photo.accid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.accid = chat.photo.accid
    end
    if chat.photo ~= nil and chat.photo.charid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.charid = chat.photo.charid
    end
    if chat.photo ~= nil and chat.photo.anglez ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.anglez = chat.photo.anglez
    end
    if chat.photo ~= nil and chat.photo.time ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.time = chat.photo.time
    end
    if chat.photo ~= nil and chat.photo.mapid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.mapid = chat.photo.mapid
    end
    if chat.photo ~= nil and chat.photo.sourceid ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.sourceid = chat.photo.sourceid
    end
    if chat.photo ~= nil and chat.photo.source ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.photo == nil then
        msg.chat.photo = {}
      end
      msg.chat.photo.source = chat.photo.source
    end
    if chat.expression ~= nil and chat.expression.type ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.expression == nil then
        msg.chat.expression = {}
      end
      msg.chat.expression.type = chat.expression.type
    end
    if chat.expression ~= nil and chat.expression.id ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.expression == nil then
        msg.chat.expression = {}
      end
      msg.chat.expression.id = chat.expression.id
    end
    if chat.expression ~= nil and chat.expression.pos ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.expression == nil then
        msg.chat.expression = {}
      end
      msg.chat.expression.pos = chat.expression.pos
    end
    if chat ~= nil and chat.bshieldword ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.bshieldword = chat.bshieldword
    end
    if chat ~= nil and chat.items ~= nil then
      if msg.chat == nil then
        msg.chat = {}
      end
      if msg.chat.items == nil then
        msg.chat.items = {}
      end
      for i = 1, #chat.items do
        table.insert(msg.chat.items, chat.items[i])
      end
    end
    if chat ~= nil and chat.love_confession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chat == nil then
        msg.chat = {}
      end
      msg.chat.love_confession = chat.love_confession
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChatSelfNtf.id
    local msgParam = {}
    if chat ~= nil and chat.cmd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.cmd = chat.cmd
    end
    if chat ~= nil and chat.param ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.param = chat.param
    end
    if chat ~= nil and chat.channel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.channel = chat.channel
    end
    if msgParam.chat == nil then
      msgParam.chat = {}
    end
    msgParam.chat.str = chat.str
    if chat ~= nil and chat.desID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.desID = chat.desID
    end
    if chat ~= nil and chat.voice ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.voice = chat.voice
    end
    if chat ~= nil and chat.voicetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.voicetime = chat.voicetime
    end
    if chat ~= nil and chat.msgid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.msgid = chat.msgid
    end
    if chat ~= nil and chat.msgover ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.msgover = chat.msgover
    end
    if chat.photo ~= nil and chat.photo.accid_svr ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.accid_svr = chat.photo.accid_svr
    end
    if chat.photo ~= nil and chat.photo.accid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.accid = chat.photo.accid
    end
    if chat.photo ~= nil and chat.photo.charid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.charid = chat.photo.charid
    end
    if chat.photo ~= nil and chat.photo.anglez ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.anglez = chat.photo.anglez
    end
    if chat.photo ~= nil and chat.photo.time ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.time = chat.photo.time
    end
    if chat.photo ~= nil and chat.photo.mapid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.mapid = chat.photo.mapid
    end
    if chat.photo ~= nil and chat.photo.sourceid ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.sourceid = chat.photo.sourceid
    end
    if chat.photo ~= nil and chat.photo.source ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.photo == nil then
        msgParam.chat.photo = {}
      end
      msgParam.chat.photo.source = chat.photo.source
    end
    if chat.expression ~= nil and chat.expression.type ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.expression == nil then
        msgParam.chat.expression = {}
      end
      msgParam.chat.expression.type = chat.expression.type
    end
    if chat.expression ~= nil and chat.expression.id ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.expression == nil then
        msgParam.chat.expression = {}
      end
      msgParam.chat.expression.id = chat.expression.id
    end
    if chat.expression ~= nil and chat.expression.pos ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.expression == nil then
        msgParam.chat.expression = {}
      end
      msgParam.chat.expression.pos = chat.expression.pos
    end
    if chat ~= nil and chat.bshieldword ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.bshieldword = chat.bshieldword
    end
    if chat ~= nil and chat.items ~= nil then
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      if msgParam.chat.items == nil then
        msgParam.chat.items = {}
      end
      for i = 1, #chat.items do
        table.insert(msgParam.chat.items, chat.items[i])
      end
    end
    if chat ~= nil and chat.love_confession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chat == nil then
        msgParam.chat = {}
      end
      msgParam.chat.love_confession = chat.love_confession
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallNpcChatNtf(channel, npcid, msgid, params, msg, npcguid)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.NpcChatNtf()
    if channel ~= nil then
      msg.channel = channel
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if msgid ~= nil then
      msg.msgid = msgid
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
    if msg ~= nil then
      msg.msg = msg
    end
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcChatNtf.id
    local msgParam = {}
    if channel ~= nil then
      msgParam.channel = channel
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
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
    if msg ~= nil then
      msgParam.msg = msg
    end
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallQueryUserShowInfoCmd(targetid, info)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryUserShowInfoCmd()
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if info ~= nil and info.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.charid = info.charid
    end
    if info ~= nil and info.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.guildid = info.guildid
    end
    if info ~= nil and info.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.accid = info.accid
    end
    if info ~= nil and info.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.name = info.name
    end
    if info ~= nil and info.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.guildname = info.guildname
    end
    if info ~= nil and info.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.guildportrait = info.guildportrait
    end
    if info ~= nil and info.guildjob ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.guildjob = info.guildjob
    end
    if info ~= nil and info.datas ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.datas == nil then
        msg.info.datas = {}
      end
      for i = 1, #info.datas do
        table.insert(msg.info.datas, info.datas[i])
      end
    end
    if info ~= nil and info.attrs ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.attrs == nil then
        msg.info.attrs = {}
      end
      for i = 1, #info.attrs do
        table.insert(msg.info.attrs, info.attrs[i])
      end
    end
    if info ~= nil and info.equip ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.equip == nil then
        msg.info.equip = {}
      end
      for i = 1, #info.equip do
        table.insert(msg.info.equip, info.equip[i])
      end
    end
    if info ~= nil and info.fashion ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.fashion == nil then
        msg.info.fashion = {}
      end
      for i = 1, #info.fashion do
        table.insert(msg.info.fashion, info.fashion[i])
      end
    end
    if info ~= nil and info.shadow ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.shadow == nil then
        msg.info.shadow = {}
      end
      for i = 1, #info.shadow do
        table.insert(msg.info.shadow, info.shadow[i])
      end
    end
    if info ~= nil and info.extraction ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.extraction == nil then
        msg.info.extraction = {}
      end
      for i = 1, #info.extraction do
        table.insert(msg.info.extraction, info.extraction[i])
      end
    end
    if info ~= nil and info.highrefine ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.highrefine == nil then
        msg.info.highrefine = {}
      end
      for i = 1, #info.highrefine do
        table.insert(msg.info.highrefine, info.highrefine[i])
      end
    end
    if info ~= nil and info.partner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.partner = info.partner
    end
    if info.mercenary ~= nil and info.mercenary.id ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.mercenary == nil then
        msg.info.mercenary = {}
      end
      msg.info.mercenary.id = info.mercenary.id
    end
    if info.mercenary ~= nil and info.mercenary.name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.mercenary == nil then
        msg.info.mercenary = {}
      end
      msg.info.mercenary.name = info.mercenary.name
    end
    if info.mercenary ~= nil and info.mercenary.icon ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.mercenary == nil then
        msg.info.mercenary = {}
      end
      msg.info.mercenary.icon = info.mercenary.icon
    end
    if info.mercenary ~= nil and info.mercenary.job ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.mercenary == nil then
        msg.info.mercenary = {}
      end
      msg.info.mercenary.job = info.mercenary.job
    end
    if info.mercenary ~= nil and info.mercenary.mercenary_name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.mercenary == nil then
        msg.info.mercenary = {}
      end
      msg.info.mercenary.mercenary_name = info.mercenary.mercenary_name
    end
    if info ~= nil and info.memory_pos ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.memory_pos == nil then
        msg.info.memory_pos = {}
      end
      for i = 1, #info.memory_pos do
        table.insert(msg.info.memory_pos, info.memory_pos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserShowInfoCmd.id
    local msgParam = {}
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if info ~= nil and info.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.charid = info.charid
    end
    if info ~= nil and info.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.guildid = info.guildid
    end
    if info ~= nil and info.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.accid = info.accid
    end
    if info ~= nil and info.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.name = info.name
    end
    if info ~= nil and info.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.guildname = info.guildname
    end
    if info ~= nil and info.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.guildportrait = info.guildportrait
    end
    if info ~= nil and info.guildjob ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.guildjob = info.guildjob
    end
    if info ~= nil and info.datas ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.datas == nil then
        msgParam.info.datas = {}
      end
      for i = 1, #info.datas do
        table.insert(msgParam.info.datas, info.datas[i])
      end
    end
    if info ~= nil and info.attrs ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.attrs == nil then
        msgParam.info.attrs = {}
      end
      for i = 1, #info.attrs do
        table.insert(msgParam.info.attrs, info.attrs[i])
      end
    end
    if info ~= nil and info.equip ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.equip == nil then
        msgParam.info.equip = {}
      end
      for i = 1, #info.equip do
        table.insert(msgParam.info.equip, info.equip[i])
      end
    end
    if info ~= nil and info.fashion ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.fashion == nil then
        msgParam.info.fashion = {}
      end
      for i = 1, #info.fashion do
        table.insert(msgParam.info.fashion, info.fashion[i])
      end
    end
    if info ~= nil and info.shadow ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.shadow == nil then
        msgParam.info.shadow = {}
      end
      for i = 1, #info.shadow do
        table.insert(msgParam.info.shadow, info.shadow[i])
      end
    end
    if info ~= nil and info.extraction ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.extraction == nil then
        msgParam.info.extraction = {}
      end
      for i = 1, #info.extraction do
        table.insert(msgParam.info.extraction, info.extraction[i])
      end
    end
    if info ~= nil and info.highrefine ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.highrefine == nil then
        msgParam.info.highrefine = {}
      end
      for i = 1, #info.highrefine do
        table.insert(msgParam.info.highrefine, info.highrefine[i])
      end
    end
    if info ~= nil and info.partner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.partner = info.partner
    end
    if info.mercenary ~= nil and info.mercenary.id ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.mercenary == nil then
        msgParam.info.mercenary = {}
      end
      msgParam.info.mercenary.id = info.mercenary.id
    end
    if info.mercenary ~= nil and info.mercenary.name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.mercenary == nil then
        msgParam.info.mercenary = {}
      end
      msgParam.info.mercenary.name = info.mercenary.name
    end
    if info.mercenary ~= nil and info.mercenary.icon ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.mercenary == nil then
        msgParam.info.mercenary = {}
      end
      msgParam.info.mercenary.icon = info.mercenary.icon
    end
    if info.mercenary ~= nil and info.mercenary.job ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.mercenary == nil then
        msgParam.info.mercenary = {}
      end
      msgParam.info.mercenary.job = info.mercenary.job
    end
    if info.mercenary ~= nil and info.mercenary.mercenary_name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.mercenary == nil then
        msgParam.info.mercenary = {}
      end
      msgParam.info.mercenary.mercenary_name = info.mercenary.mercenary_name
    end
    if info ~= nil and info.memory_pos ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.memory_pos == nil then
        msgParam.info.memory_pos = {}
      end
      for i = 1, #info.memory_pos do
        table.insert(msgParam.info.memory_pos, info.memory_pos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallSystemBarrageChatCmd(type, msgid)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.SystemBarrageChatCmd()
    if type ~= nil then
      msg.type = type
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SystemBarrageChatCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallQueryFavoriteExpressionChatCmd(expression)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryFavoriteExpressionChatCmd()
    if expression ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.expression == nil then
        msg.expression = {}
      end
      for i = 1, #expression do
        table.insert(msg.expression, expression[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFavoriteExpressionChatCmd.id
    local msgParam = {}
    if expression ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.expression == nil then
        msgParam.expression = {}
      end
      for i = 1, #expression do
        table.insert(msgParam.expression, expression[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallUpdateFavoriteExpressionChatCmd(updates, dels)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.UpdateFavoriteExpressionChatCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateFavoriteExpressionChatCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallExpressionChatCmd(channel, id, targetid, msgid, sendername, targetname)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ExpressionChatCmd()
    if channel ~= nil then
      msg.channel = channel
    end
    if id ~= nil then
      msg.id = id
    end
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    if sendername ~= nil then
      msg.sendername = sendername
    end
    if targetname ~= nil then
      msg.targetname = targetname
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExpressionChatCmd.id
    local msgParam = {}
    if channel ~= nil then
      msgParam.channel = channel
    end
    if id ~= nil then
      msgParam.id = id
    end
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    if sendername ~= nil then
      msgParam.sendername = sendername
    end
    if targetname ~= nil then
      msgParam.targetname = targetname
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallFaceShowChatCmd(channel, id, targetid, msgid, sendername, targetname, charid)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.FaceShowChatCmd()
    if channel ~= nil then
      msg.channel = channel
    end
    if id ~= nil then
      msg.id = id
    end
    if targetid ~= nil then
      msg.targetid = targetid
    end
    if msgid ~= nil then
      msg.msgid = msgid
    end
    if sendername ~= nil then
      msg.sendername = sendername
    end
    if targetname ~= nil then
      msg.targetname = targetname
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FaceShowChatCmd.id
    local msgParam = {}
    if channel ~= nil then
      msgParam.channel = channel
    end
    if id ~= nil then
      msgParam.id = id
    end
    if targetid ~= nil then
      msgParam.targetid = targetid
    end
    if msgid ~= nil then
      msgParam.msgid = msgid
    end
    if sendername ~= nil then
      msgParam.sendername = sendername
    end
    if targetname ~= nil then
      msgParam.targetname = targetname
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallClientLogChatCmd(func, oper, msg)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ClientLogChatCmd()
    if func ~= nil then
      msg.func = func
    end
    if oper ~= nil then
      msg.oper = oper
    end
    if msg ~= nil then
      msg.msg = msg
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientLogChatCmd.id
    local msgParam = {}
    if func ~= nil then
      msgParam.func = func
    end
    if oper ~= nil then
      msgParam.oper = oper
    end
    if msg ~= nil then
      msgParam.msg = msg
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallSendRedPacketCmd(content, guid, userIDInfo, chatinfos, be_blacked, sceneServerName)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.SendRedPacketCmd()
    if content ~= nil and content.str ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.str = content.str
    end
    if content ~= nil and content.totalMoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.totalMoney = content.totalMoney
    end
    if content ~= nil and content.totalNum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.totalNum = content.totalNum
    end
    if content ~= nil and content.channel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.channel = content.channel
    end
    if content ~= nil and content.target_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.target_id = content.target_id
    end
    if content ~= nil and content.guild_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.guild_job = content.guild_job
    end
    if content ~= nil and content.redPacketCFGID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.redPacketCFGID = content.redPacketCFGID
    end
    if content ~= nil and content.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.type = content.type
    end
    if content ~= nil and content.MoneyID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.MoneyID = content.MoneyID
    end
    if content ~= nil and content.restMoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.restMoney = content.restMoney
    end
    if content ~= nil and content.restNum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.restNum = content.restNum
    end
    if content ~= nil and content.rest_multi_items ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.rest_multi_items == nil then
        msg.content.rest_multi_items = {}
      end
      for i = 1, #content.rest_multi_items do
        table.insert(msg.content.rest_multi_items, content.rest_multi_items[i])
      end
    end
    if content ~= nil and content.total_multi_items ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.total_multi_items == nil then
        msg.content.total_multi_items = {}
      end
      for i = 1, #content.total_multi_items do
        table.insert(msg.content.total_multi_items, content.total_multi_items[i])
      end
    end
    if content ~= nil and content.overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.overtime = content.overtime
    end
    if content ~= nil and content.data_overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.data_overtime = content.data_overtime
    end
    if content ~= nil and content.bShieldWord ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.bShieldWord = content.bShieldWord
    end
    if content ~= nil and content.guildID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.guildID = content.guildID
    end
    if content ~= nil and content.charID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.charID = content.charID
    end
    if content ~= nil and content.accID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.accID = content.accID
    end
    if content ~= nil and content.receivedInfos ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.receivedInfos == nil then
        msg.content.receivedInfos = {}
      end
      for i = 1, #content.receivedInfos do
        table.insert(msg.content.receivedInfos, content.receivedInfos[i])
      end
    end
    if content ~= nil and content.strRedPacketID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.strRedPacketID = content.strRedPacketID
    end
    if content ~= nil and content.gvg_charids ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.gvg_charids == nil then
        msg.content.gvg_charids = {}
      end
      for i = 1, #content.gvg_charids do
        table.insert(msg.content.gvg_charids, content.gvg_charids[i])
      end
    end
    if content ~= nil and content.praise_charids ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.praise_charids == nil then
        msg.content.praise_charids = {}
      end
      for i = 1, #content.praise_charids do
        table.insert(msg.content.praise_charids, content.praise_charids[i])
      end
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if userIDInfo ~= nil and userIDInfo.accID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.accID = userIDInfo.accID
    end
    if userIDInfo ~= nil and userIDInfo.charID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.charID = userIDInfo.charID
    end
    if userIDInfo ~= nil and userIDInfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.name = userIDInfo.name
    end
    if userIDInfo ~= nil and userIDInfo.guildID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.guildID = userIDInfo.guildID
    end
    if userIDInfo ~= nil and userIDInfo.sceneServerName ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.sceneServerName = userIDInfo.sceneServerName
    end
    if userIDInfo ~= nil and userIDInfo.platformID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.platformID = userIDInfo.platformID
    end
    if userIDInfo ~= nil and userIDInfo.guild_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.guild_job = userIDInfo.guild_job
    end
    if chatinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chatinfos == nil then
        msg.chatinfos = {}
      end
      for i = 1, #chatinfos do
        table.insert(msg.chatinfos, chatinfos[i])
      end
    end
    if be_blacked ~= nil then
      msg.be_blacked = be_blacked
    end
    if sceneServerName ~= nil then
      msg.sceneServerName = sceneServerName
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SendRedPacketCmd.id
    local msgParam = {}
    if content ~= nil and content.str ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.str = content.str
    end
    if content ~= nil and content.totalMoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.totalMoney = content.totalMoney
    end
    if content ~= nil and content.totalNum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.totalNum = content.totalNum
    end
    if content ~= nil and content.channel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.channel = content.channel
    end
    if content ~= nil and content.target_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.target_id = content.target_id
    end
    if content ~= nil and content.guild_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.guild_job = content.guild_job
    end
    if content ~= nil and content.redPacketCFGID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.redPacketCFGID = content.redPacketCFGID
    end
    if content ~= nil and content.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.type = content.type
    end
    if content ~= nil and content.MoneyID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.MoneyID = content.MoneyID
    end
    if content ~= nil and content.restMoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.restMoney = content.restMoney
    end
    if content ~= nil and content.restNum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.restNum = content.restNum
    end
    if content ~= nil and content.rest_multi_items ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.rest_multi_items == nil then
        msgParam.content.rest_multi_items = {}
      end
      for i = 1, #content.rest_multi_items do
        table.insert(msgParam.content.rest_multi_items, content.rest_multi_items[i])
      end
    end
    if content ~= nil and content.total_multi_items ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.total_multi_items == nil then
        msgParam.content.total_multi_items = {}
      end
      for i = 1, #content.total_multi_items do
        table.insert(msgParam.content.total_multi_items, content.total_multi_items[i])
      end
    end
    if content ~= nil and content.overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.overtime = content.overtime
    end
    if content ~= nil and content.data_overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.data_overtime = content.data_overtime
    end
    if content ~= nil and content.bShieldWord ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.bShieldWord = content.bShieldWord
    end
    if content ~= nil and content.guildID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.guildID = content.guildID
    end
    if content ~= nil and content.charID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.charID = content.charID
    end
    if content ~= nil and content.accID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.accID = content.accID
    end
    if content ~= nil and content.receivedInfos ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.receivedInfos == nil then
        msgParam.content.receivedInfos = {}
      end
      for i = 1, #content.receivedInfos do
        table.insert(msgParam.content.receivedInfos, content.receivedInfos[i])
      end
    end
    if content ~= nil and content.strRedPacketID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.strRedPacketID = content.strRedPacketID
    end
    if content ~= nil and content.gvg_charids ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.gvg_charids == nil then
        msgParam.content.gvg_charids = {}
      end
      for i = 1, #content.gvg_charids do
        table.insert(msgParam.content.gvg_charids, content.gvg_charids[i])
      end
    end
    if content ~= nil and content.praise_charids ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.praise_charids == nil then
        msgParam.content.praise_charids = {}
      end
      for i = 1, #content.praise_charids do
        table.insert(msgParam.content.praise_charids, content.praise_charids[i])
      end
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if userIDInfo ~= nil and userIDInfo.accID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.accID = userIDInfo.accID
    end
    if userIDInfo ~= nil and userIDInfo.charID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.charID = userIDInfo.charID
    end
    if userIDInfo ~= nil and userIDInfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.name = userIDInfo.name
    end
    if userIDInfo ~= nil and userIDInfo.guildID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.guildID = userIDInfo.guildID
    end
    if userIDInfo ~= nil and userIDInfo.sceneServerName ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.sceneServerName = userIDInfo.sceneServerName
    end
    if userIDInfo ~= nil and userIDInfo.platformID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.platformID = userIDInfo.platformID
    end
    if userIDInfo ~= nil and userIDInfo.guild_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.guild_job = userIDInfo.guild_job
    end
    if chatinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chatinfos == nil then
        msgParam.chatinfos = {}
      end
      for i = 1, #chatinfos do
        table.insert(msgParam.chatinfos, chatinfos[i])
      end
    end
    if be_blacked ~= nil then
      msgParam.be_blacked = be_blacked
    end
    if sceneServerName ~= nil then
      msgParam.sceneServerName = sceneServerName
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallReceiveRedPacketCmd(strRedPacketID, senderID, channel, userIDInfo, isBeyondReceiveLinit, mercenary_guild)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ReceiveRedPacketCmd()
    if strRedPacketID ~= nil then
      msg.strRedPacketID = strRedPacketID
    end
    if senderID ~= nil then
      msg.senderID = senderID
    end
    if channel ~= nil then
      msg.channel = channel
    end
    if userIDInfo ~= nil and userIDInfo.accID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.accID = userIDInfo.accID
    end
    if userIDInfo ~= nil and userIDInfo.charID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.charID = userIDInfo.charID
    end
    if userIDInfo ~= nil and userIDInfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.name = userIDInfo.name
    end
    if userIDInfo ~= nil and userIDInfo.guildID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.guildID = userIDInfo.guildID
    end
    if userIDInfo ~= nil and userIDInfo.sceneServerName ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.sceneServerName = userIDInfo.sceneServerName
    end
    if userIDInfo ~= nil and userIDInfo.platformID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.platformID = userIDInfo.platformID
    end
    if userIDInfo ~= nil and userIDInfo.guild_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.guild_job = userIDInfo.guild_job
    end
    if isBeyondReceiveLinit ~= nil then
      msg.isBeyondReceiveLinit = isBeyondReceiveLinit
    end
    if mercenary_guild ~= nil then
      msg.mercenary_guild = mercenary_guild
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReceiveRedPacketCmd.id
    local msgParam = {}
    if strRedPacketID ~= nil then
      msgParam.strRedPacketID = strRedPacketID
    end
    if senderID ~= nil then
      msgParam.senderID = senderID
    end
    if channel ~= nil then
      msgParam.channel = channel
    end
    if userIDInfo ~= nil and userIDInfo.accID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.accID = userIDInfo.accID
    end
    if userIDInfo ~= nil and userIDInfo.charID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.charID = userIDInfo.charID
    end
    if userIDInfo ~= nil and userIDInfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.name = userIDInfo.name
    end
    if userIDInfo ~= nil and userIDInfo.guildID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.guildID = userIDInfo.guildID
    end
    if userIDInfo ~= nil and userIDInfo.sceneServerName ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.sceneServerName = userIDInfo.sceneServerName
    end
    if userIDInfo ~= nil and userIDInfo.platformID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.platformID = userIDInfo.platformID
    end
    if userIDInfo ~= nil and userIDInfo.guild_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.guild_job = userIDInfo.guild_job
    end
    if isBeyondReceiveLinit ~= nil then
      msgParam.isBeyondReceiveLinit = isBeyondReceiveLinit
    end
    if mercenary_guild ~= nil then
      msgParam.mercenary_guild = mercenary_guild
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallInitUserRedPacketCmd(charID)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.InitUserRedPacketCmd()
    if charID ~= nil then
      msg.charID = charID
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InitUserRedPacketCmd.id
    local msgParam = {}
    if charID ~= nil then
      msgParam.charID = charID
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallReceiveRedPacketRet(strRedPacketID, bRedPacketExist, bRedPacketUsable, content, thisReceiveMoney, userIDInfo, receive_multi_items)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ReceiveRedPacketRet()
    if strRedPacketID ~= nil then
      msg.strRedPacketID = strRedPacketID
    end
    if bRedPacketExist ~= nil then
      msg.bRedPacketExist = bRedPacketExist
    end
    if bRedPacketUsable ~= nil then
      msg.bRedPacketUsable = bRedPacketUsable
    end
    if content ~= nil and content.str ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.str = content.str
    end
    if content ~= nil and content.totalMoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.totalMoney = content.totalMoney
    end
    if content ~= nil and content.totalNum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.totalNum = content.totalNum
    end
    if content ~= nil and content.channel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.channel = content.channel
    end
    if content ~= nil and content.target_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.target_id = content.target_id
    end
    if content ~= nil and content.guild_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.guild_job = content.guild_job
    end
    if content ~= nil and content.redPacketCFGID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.redPacketCFGID = content.redPacketCFGID
    end
    if content ~= nil and content.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.type = content.type
    end
    if content ~= nil and content.MoneyID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.MoneyID = content.MoneyID
    end
    if content ~= nil and content.restMoney ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.restMoney = content.restMoney
    end
    if content ~= nil and content.restNum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.restNum = content.restNum
    end
    if content ~= nil and content.rest_multi_items ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.rest_multi_items == nil then
        msg.content.rest_multi_items = {}
      end
      for i = 1, #content.rest_multi_items do
        table.insert(msg.content.rest_multi_items, content.rest_multi_items[i])
      end
    end
    if content ~= nil and content.total_multi_items ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.total_multi_items == nil then
        msg.content.total_multi_items = {}
      end
      for i = 1, #content.total_multi_items do
        table.insert(msg.content.total_multi_items, content.total_multi_items[i])
      end
    end
    if content ~= nil and content.overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.overtime = content.overtime
    end
    if content ~= nil and content.data_overtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.data_overtime = content.data_overtime
    end
    if content ~= nil and content.bShieldWord ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.bShieldWord = content.bShieldWord
    end
    if content ~= nil and content.guildID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.guildID = content.guildID
    end
    if content ~= nil and content.charID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.charID = content.charID
    end
    if content ~= nil and content.accID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.accID = content.accID
    end
    if content ~= nil and content.receivedInfos ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.receivedInfos == nil then
        msg.content.receivedInfos = {}
      end
      for i = 1, #content.receivedInfos do
        table.insert(msg.content.receivedInfos, content.receivedInfos[i])
      end
    end
    if content ~= nil and content.strRedPacketID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.content == nil then
        msg.content = {}
      end
      msg.content.strRedPacketID = content.strRedPacketID
    end
    if content ~= nil and content.gvg_charids ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.gvg_charids == nil then
        msg.content.gvg_charids = {}
      end
      for i = 1, #content.gvg_charids do
        table.insert(msg.content.gvg_charids, content.gvg_charids[i])
      end
    end
    if content ~= nil and content.praise_charids ~= nil then
      if msg.content == nil then
        msg.content = {}
      end
      if msg.content.praise_charids == nil then
        msg.content.praise_charids = {}
      end
      for i = 1, #content.praise_charids do
        table.insert(msg.content.praise_charids, content.praise_charids[i])
      end
    end
    if thisReceiveMoney ~= nil then
      msg.thisReceiveMoney = thisReceiveMoney
    end
    if userIDInfo ~= nil and userIDInfo.accID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.accID = userIDInfo.accID
    end
    if userIDInfo ~= nil and userIDInfo.charID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.charID = userIDInfo.charID
    end
    if userIDInfo ~= nil and userIDInfo.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.name = userIDInfo.name
    end
    if userIDInfo ~= nil and userIDInfo.guildID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.guildID = userIDInfo.guildID
    end
    if userIDInfo ~= nil and userIDInfo.sceneServerName ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.sceneServerName = userIDInfo.sceneServerName
    end
    if userIDInfo ~= nil and userIDInfo.platformID ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.platformID = userIDInfo.platformID
    end
    if userIDInfo ~= nil and userIDInfo.guild_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.userIDInfo == nil then
        msg.userIDInfo = {}
      end
      msg.userIDInfo.guild_job = userIDInfo.guild_job
    end
    if receive_multi_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.receive_multi_items == nil then
        msg.receive_multi_items = {}
      end
      for i = 1, #receive_multi_items do
        table.insert(msg.receive_multi_items, receive_multi_items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReceiveRedPacketRet.id
    local msgParam = {}
    if strRedPacketID ~= nil then
      msgParam.strRedPacketID = strRedPacketID
    end
    if bRedPacketExist ~= nil then
      msgParam.bRedPacketExist = bRedPacketExist
    end
    if bRedPacketUsable ~= nil then
      msgParam.bRedPacketUsable = bRedPacketUsable
    end
    if content ~= nil and content.str ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.str = content.str
    end
    if content ~= nil and content.totalMoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.totalMoney = content.totalMoney
    end
    if content ~= nil and content.totalNum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.totalNum = content.totalNum
    end
    if content ~= nil and content.channel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.channel = content.channel
    end
    if content ~= nil and content.target_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.target_id = content.target_id
    end
    if content ~= nil and content.guild_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.guild_job = content.guild_job
    end
    if content ~= nil and content.redPacketCFGID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.redPacketCFGID = content.redPacketCFGID
    end
    if content ~= nil and content.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.type = content.type
    end
    if content ~= nil and content.MoneyID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.MoneyID = content.MoneyID
    end
    if content ~= nil and content.restMoney ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.restMoney = content.restMoney
    end
    if content ~= nil and content.restNum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.restNum = content.restNum
    end
    if content ~= nil and content.rest_multi_items ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.rest_multi_items == nil then
        msgParam.content.rest_multi_items = {}
      end
      for i = 1, #content.rest_multi_items do
        table.insert(msgParam.content.rest_multi_items, content.rest_multi_items[i])
      end
    end
    if content ~= nil and content.total_multi_items ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.total_multi_items == nil then
        msgParam.content.total_multi_items = {}
      end
      for i = 1, #content.total_multi_items do
        table.insert(msgParam.content.total_multi_items, content.total_multi_items[i])
      end
    end
    if content ~= nil and content.overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.overtime = content.overtime
    end
    if content ~= nil and content.data_overtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.data_overtime = content.data_overtime
    end
    if content ~= nil and content.bShieldWord ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.bShieldWord = content.bShieldWord
    end
    if content ~= nil and content.guildID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.guildID = content.guildID
    end
    if content ~= nil and content.charID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.charID = content.charID
    end
    if content ~= nil and content.accID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.accID = content.accID
    end
    if content ~= nil and content.receivedInfos ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.receivedInfos == nil then
        msgParam.content.receivedInfos = {}
      end
      for i = 1, #content.receivedInfos do
        table.insert(msgParam.content.receivedInfos, content.receivedInfos[i])
      end
    end
    if content ~= nil and content.strRedPacketID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.content == nil then
        msgParam.content = {}
      end
      msgParam.content.strRedPacketID = content.strRedPacketID
    end
    if content ~= nil and content.gvg_charids ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.gvg_charids == nil then
        msgParam.content.gvg_charids = {}
      end
      for i = 1, #content.gvg_charids do
        table.insert(msgParam.content.gvg_charids, content.gvg_charids[i])
      end
    end
    if content ~= nil and content.praise_charids ~= nil then
      if msgParam.content == nil then
        msgParam.content = {}
      end
      if msgParam.content.praise_charids == nil then
        msgParam.content.praise_charids = {}
      end
      for i = 1, #content.praise_charids do
        table.insert(msgParam.content.praise_charids, content.praise_charids[i])
      end
    end
    if thisReceiveMoney ~= nil then
      msgParam.thisReceiveMoney = thisReceiveMoney
    end
    if userIDInfo ~= nil and userIDInfo.accID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.accID = userIDInfo.accID
    end
    if userIDInfo ~= nil and userIDInfo.charID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.charID = userIDInfo.charID
    end
    if userIDInfo ~= nil and userIDInfo.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.name = userIDInfo.name
    end
    if userIDInfo ~= nil and userIDInfo.guildID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.guildID = userIDInfo.guildID
    end
    if userIDInfo ~= nil and userIDInfo.sceneServerName ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.sceneServerName = userIDInfo.sceneServerName
    end
    if userIDInfo ~= nil and userIDInfo.platformID ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.platformID = userIDInfo.platformID
    end
    if userIDInfo ~= nil and userIDInfo.guild_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.userIDInfo == nil then
        msgParam.userIDInfo = {}
      end
      msgParam.userIDInfo.guild_job = userIDInfo.guild_job
    end
    if receive_multi_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.receive_multi_items == nil then
        msgParam.receive_multi_items = {}
      end
      for i = 1, #receive_multi_items do
        table.insert(msgParam.receive_multi_items, receive_multi_items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallShareMsgCmd(share_data)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ShareMsgCmd()
    if share_data ~= nil and share_data.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.share_data == nil then
        msg.share_data = {}
      end
      msg.share_data.type = share_data.type
    end
    if share_data ~= nil and share_data.share_items ~= nil then
      if msg.share_data == nil then
        msg.share_data = {}
      end
      if msg.share_data.share_items == nil then
        msg.share_data.share_items = {}
      end
      for i = 1, #share_data.share_items do
        table.insert(msg.share_data.share_items, share_data.share_items[i])
      end
    end
    if share_data ~= nil and share_data.items ~= nil then
      if msg.share_data == nil then
        msg.share_data = {}
      end
      if msg.share_data.items == nil then
        msg.share_data.items = {}
      end
      for i = 1, #share_data.items do
        table.insert(msg.share_data.items, share_data.items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShareMsgCmd.id
    local msgParam = {}
    if share_data ~= nil and share_data.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.share_data == nil then
        msgParam.share_data = {}
      end
      msgParam.share_data.type = share_data.type
    end
    if share_data ~= nil and share_data.share_items ~= nil then
      if msgParam.share_data == nil then
        msgParam.share_data = {}
      end
      if msgParam.share_data.share_items == nil then
        msgParam.share_data.share_items = {}
      end
      for i = 1, #share_data.share_items do
        table.insert(msgParam.share_data.share_items, share_data.share_items[i])
      end
    end
    if share_data ~= nil and share_data.items ~= nil then
      if msgParam.share_data == nil then
        msgParam.share_data = {}
      end
      if msgParam.share_data.items == nil then
        msgParam.share_data.items = {}
      end
      for i = 1, #share_data.items do
        table.insert(msgParam.share_data.items, share_data.items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallShareSuccessNofityCmd()
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.ShareSuccessNofityCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ShareSuccessNofityCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallQueryGuildRedPacketChatCmd(msgs, guildid, mercenary_guildid, gvg, charid, guild_job, accid)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.QueryGuildRedPacketChatCmd()
    if msgs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.msgs == nil then
        msg.msgs = {}
      end
      for i = 1, #msgs do
        table.insert(msg.msgs, msgs[i])
      end
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if mercenary_guildid ~= nil then
      msg.mercenary_guildid = mercenary_guildid
    end
    if gvg ~= nil then
      msg.gvg = gvg
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if guild_job ~= nil then
      msg.guild_job = guild_job
    end
    if accid ~= nil then
      msg.accid = accid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGuildRedPacketChatCmd.id
    local msgParam = {}
    if msgs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.msgs == nil then
        msgParam.msgs = {}
      end
      for i = 1, #msgs do
        table.insert(msgParam.msgs, msgs[i])
      end
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if mercenary_guildid ~= nil then
      msgParam.mercenary_guildid = mercenary_guildid
    end
    if gvg ~= nil then
      msgParam.gvg = gvg
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if guild_job ~= nil then
      msgParam.guild_job = guild_job
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:CallCheckRecvRedPacketChatCmd(channel, red_packs, charid, guildid, mercenary_guild, guild_job, accid)
  if not NetConfig.PBC then
    local msg = ChatCmd_pb.CheckRecvRedPacketChatCmd()
    if channel ~= nil then
      msg.channel = channel
    end
    if red_packs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.red_packs == nil then
        msg.red_packs = {}
      end
      for i = 1, #red_packs do
        table.insert(msg.red_packs, red_packs[i])
      end
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if mercenary_guild ~= nil then
      msg.mercenary_guild = mercenary_guild
    end
    if guild_job ~= nil then
      msg.guild_job = guild_job
    end
    if accid ~= nil then
      msg.accid = accid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CheckRecvRedPacketChatCmd.id
    local msgParam = {}
    if channel ~= nil then
      msgParam.channel = channel
    end
    if red_packs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.red_packs == nil then
        msgParam.red_packs = {}
      end
      for i = 1, #red_packs do
        table.insert(msgParam.red_packs, red_packs[i])
      end
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if mercenary_guild ~= nil then
      msgParam.mercenary_guild = mercenary_guild
    end
    if guild_job ~= nil then
      msgParam.guild_job = guild_job
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceChatCmdAutoProxy:RecvQueryItemData(data)
  self:Notify(ServiceEvent.ChatCmdQueryItemData, data)
end

function ServiceChatCmdAutoProxy:RecvPlayExpressionChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdPlayExpressionChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvQueryUserInfoChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryUserInfoChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvQueryUserGemChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryUserGemChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvBarrageChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdBarrageChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvBarrageMsgChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdBarrageMsgChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvChatRetCmd(data)
  self:Notify(ServiceEvent.ChatCmdChatRetCmd, data)
end

function ServiceChatCmdAutoProxy:RecvQueryVoiceUserCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryVoiceUserCmd, data)
end

function ServiceChatCmdAutoProxy:RecvGetVoiceIDChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdGetVoiceIDChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvLoveLetterNtf(data)
  self:Notify(ServiceEvent.ChatCmdLoveLetterNtf, data)
end

function ServiceChatCmdAutoProxy:RecvChatSelfNtf(data)
  self:Notify(ServiceEvent.ChatCmdChatSelfNtf, data)
end

function ServiceChatCmdAutoProxy:RecvNpcChatNtf(data)
  self:Notify(ServiceEvent.ChatCmdNpcChatNtf, data)
end

function ServiceChatCmdAutoProxy:RecvQueryUserShowInfoCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryUserShowInfoCmd, data)
end

function ServiceChatCmdAutoProxy:RecvSystemBarrageChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdSystemBarrageChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvQueryFavoriteExpressionChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryFavoriteExpressionChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvUpdateFavoriteExpressionChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdUpdateFavoriteExpressionChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvExpressionChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdExpressionChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvFaceShowChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdFaceShowChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvClientLogChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdClientLogChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvSendRedPacketCmd(data)
  self:Notify(ServiceEvent.ChatCmdSendRedPacketCmd, data)
end

function ServiceChatCmdAutoProxy:RecvReceiveRedPacketCmd(data)
  self:Notify(ServiceEvent.ChatCmdReceiveRedPacketCmd, data)
end

function ServiceChatCmdAutoProxy:RecvInitUserRedPacketCmd(data)
  self:Notify(ServiceEvent.ChatCmdInitUserRedPacketCmd, data)
end

function ServiceChatCmdAutoProxy:RecvReceiveRedPacketRet(data)
  self:Notify(ServiceEvent.ChatCmdReceiveRedPacketRet, data)
end

function ServiceChatCmdAutoProxy:RecvShareMsgCmd(data)
  self:Notify(ServiceEvent.ChatCmdShareMsgCmd, data)
end

function ServiceChatCmdAutoProxy:RecvShareSuccessNofityCmd(data)
  self:Notify(ServiceEvent.ChatCmdShareSuccessNofityCmd, data)
end

function ServiceChatCmdAutoProxy:RecvQueryGuildRedPacketChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryGuildRedPacketChatCmd, data)
end

function ServiceChatCmdAutoProxy:RecvCheckRecvRedPacketChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdCheckRecvRedPacketChatCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ChatCmdQueryItemData = "ServiceEvent_ChatCmdQueryItemData"
ServiceEvent.ChatCmdPlayExpressionChatCmd = "ServiceEvent_ChatCmdPlayExpressionChatCmd"
ServiceEvent.ChatCmdQueryUserInfoChatCmd = "ServiceEvent_ChatCmdQueryUserInfoChatCmd"
ServiceEvent.ChatCmdQueryUserGemChatCmd = "ServiceEvent_ChatCmdQueryUserGemChatCmd"
ServiceEvent.ChatCmdBarrageChatCmd = "ServiceEvent_ChatCmdBarrageChatCmd"
ServiceEvent.ChatCmdBarrageMsgChatCmd = "ServiceEvent_ChatCmdBarrageMsgChatCmd"
ServiceEvent.ChatCmdChatCmd = "ServiceEvent_ChatCmdChatCmd"
ServiceEvent.ChatCmdChatRetCmd = "ServiceEvent_ChatCmdChatRetCmd"
ServiceEvent.ChatCmdQueryVoiceUserCmd = "ServiceEvent_ChatCmdQueryVoiceUserCmd"
ServiceEvent.ChatCmdGetVoiceIDChatCmd = "ServiceEvent_ChatCmdGetVoiceIDChatCmd"
ServiceEvent.ChatCmdLoveLetterNtf = "ServiceEvent_ChatCmdLoveLetterNtf"
ServiceEvent.ChatCmdChatSelfNtf = "ServiceEvent_ChatCmdChatSelfNtf"
ServiceEvent.ChatCmdNpcChatNtf = "ServiceEvent_ChatCmdNpcChatNtf"
ServiceEvent.ChatCmdQueryUserShowInfoCmd = "ServiceEvent_ChatCmdQueryUserShowInfoCmd"
ServiceEvent.ChatCmdSystemBarrageChatCmd = "ServiceEvent_ChatCmdSystemBarrageChatCmd"
ServiceEvent.ChatCmdQueryFavoriteExpressionChatCmd = "ServiceEvent_ChatCmdQueryFavoriteExpressionChatCmd"
ServiceEvent.ChatCmdUpdateFavoriteExpressionChatCmd = "ServiceEvent_ChatCmdUpdateFavoriteExpressionChatCmd"
ServiceEvent.ChatCmdExpressionChatCmd = "ServiceEvent_ChatCmdExpressionChatCmd"
ServiceEvent.ChatCmdFaceShowChatCmd = "ServiceEvent_ChatCmdFaceShowChatCmd"
ServiceEvent.ChatCmdClientLogChatCmd = "ServiceEvent_ChatCmdClientLogChatCmd"
ServiceEvent.ChatCmdSendRedPacketCmd = "ServiceEvent_ChatCmdSendRedPacketCmd"
ServiceEvent.ChatCmdReceiveRedPacketCmd = "ServiceEvent_ChatCmdReceiveRedPacketCmd"
ServiceEvent.ChatCmdInitUserRedPacketCmd = "ServiceEvent_ChatCmdInitUserRedPacketCmd"
ServiceEvent.ChatCmdReceiveRedPacketRet = "ServiceEvent_ChatCmdReceiveRedPacketRet"
ServiceEvent.ChatCmdShareMsgCmd = "ServiceEvent_ChatCmdShareMsgCmd"
ServiceEvent.ChatCmdShareSuccessNofityCmd = "ServiceEvent_ChatCmdShareSuccessNofityCmd"
ServiceEvent.ChatCmdQueryGuildRedPacketChatCmd = "ServiceEvent_ChatCmdQueryGuildRedPacketChatCmd"
ServiceEvent.ChatCmdCheckRecvRedPacketChatCmd = "ServiceEvent_ChatCmdCheckRecvRedPacketChatCmd"
