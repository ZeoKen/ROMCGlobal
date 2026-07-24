ServiceSnowCmdAutoProxy = class("ServiceSnowCmdAutoProxy", ServiceProxy)
ServiceSnowCmdAutoProxy.Instance = nil
ServiceSnowCmdAutoProxy.NAME = "ServiceSnowCmdAutoProxy"

function ServiceSnowCmdAutoProxy:ctor(proxyName)
  if ServiceSnowCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSnowCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSnowCmdAutoProxy.Instance = self
  end
end

function ServiceSnowCmdAutoProxy:Init()
end

function ServiceSnowCmdAutoProxy:onRegister()
  self:Listen(85, 13, function(data)
    self:RecvSnowRealmPartyStartSnowCmd(data)
  end)
  self:Listen(85, 1, function(data)
    self:RecvSnowHeadQuerySnowCmd(data)
  end)
  self:Listen(85, 2, function(data)
    self:RecvSnowHeadLvupSnowCmd(data)
  end)
  self:Listen(85, 3, function(data)
    self:RecvSnowHeadActiveSnowCmd(data)
  end)
  self:Listen(85, 4, function(data)
    self:RecvSnowHeadModeChangeSnowCmd(data)
  end)
  self:Listen(85, 5, function(data)
    self:RecvSnowHeadFashionSelectSnowCmd(data)
  end)
  self:Listen(85, 6, function(data)
    self:RecvSnowCrownActiveSnowCmd(data)
  end)
  self:Listen(85, 7, function(data)
    self:RecvQuerySnowManualSnowCmd(data)
  end)
  self:Listen(85, 8, function(data)
    self:RecvSnowManualUpdateSnowCmd(data)
  end)
  self:Listen(85, 9, function(data)
    self:RecvSnowManualEquipUpdateSnowCmd(data)
  end)
  self:Listen(85, 10, function(data)
    self:RecvSnowManualStoneUpdateSnowCmd(data)
  end)
  self:Listen(85, 11, function(data)
    self:RecvOperSnowEquipSnowCmd(data)
  end)
  self:Listen(85, 12, function(data)
    self:RecvOperSnowStoneSnowCmd(data)
  end)
end

function ServiceSnowCmdAutoProxy:CallSnowRealmPartyStartSnowCmd()
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowRealmPartyStartSnowCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowRealmPartyStartSnowCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowHeadQuerySnowCmd(guid, data)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowHeadQuerySnowCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if data ~= nil and data.batch ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.batch = data.batch
    end
    if data ~= nil and data.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.level = data.level
    end
    if data ~= nil and data.open ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.open = data.open
    end
    if data ~= nil and data.usemode ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.usemode = data.usemode
    end
    if data ~= nil and data.modedatas ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.modedatas == nil then
        msg.data.modedatas = {}
      end
      for i = 1, #data.modedatas do
        table.insert(msg.data.modedatas, data.modedatas[i])
      end
    end
    if data ~= nil and data.fashiondatas ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.fashiondatas == nil then
        msg.data.fashiondatas = {}
      end
      for i = 1, #data.fashiondatas do
        table.insert(msg.data.fashiondatas, data.fashiondatas[i])
      end
    end
    if data ~= nil and data.crowndata.ids ~= nil then
      if msg.data.crowndata == nil then
        msg.data.crowndata = {}
      end
      if msg.data.crowndata.ids == nil then
        msg.data.crowndata.ids = {}
      end
      for i = 1, #data.crowndata.ids do
        table.insert(msg.data.crowndata.ids, data.crowndata.ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowHeadQuerySnowCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if data ~= nil and data.batch ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.batch = data.batch
    end
    if data ~= nil and data.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.level = data.level
    end
    if data ~= nil and data.open ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.open = data.open
    end
    if data ~= nil and data.usemode ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.usemode = data.usemode
    end
    if data ~= nil and data.modedatas ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.modedatas == nil then
        msgParam.data.modedatas = {}
      end
      for i = 1, #data.modedatas do
        table.insert(msgParam.data.modedatas, data.modedatas[i])
      end
    end
    if data ~= nil and data.fashiondatas ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.fashiondatas == nil then
        msgParam.data.fashiondatas = {}
      end
      for i = 1, #data.fashiondatas do
        table.insert(msgParam.data.fashiondatas, data.fashiondatas[i])
      end
    end
    if data ~= nil and data.crowndata.ids ~= nil then
      if msgParam.data.crowndata == nil then
        msgParam.data.crowndata = {}
      end
      if msgParam.data.crowndata.ids == nil then
        msgParam.data.crowndata.ids = {}
      end
      for i = 1, #data.crowndata.ids do
        table.insert(msgParam.data.crowndata.ids, data.crowndata.ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowHeadLvupSnowCmd(guid)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowHeadLvupSnowCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowHeadLvupSnowCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowHeadActiveSnowCmd(guid, id)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowHeadActiveSnowCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowHeadActiveSnowCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowHeadModeChangeSnowCmd(guid, mode)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowHeadModeChangeSnowCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if mode ~= nil then
      msg.mode = mode
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowHeadModeChangeSnowCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if mode ~= nil then
      msgParam.mode = mode
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowHeadFashionSelectSnowCmd(guid, pos, index)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowHeadFashionSelectSnowCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowHeadFashionSelectSnowCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowCrownActiveSnowCmd(id, use_deduction)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowCrownActiveSnowCmd()
    if id ~= nil then
      msg.id = id
    end
    if use_deduction ~= nil then
      msg.use_deduction = use_deduction
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowCrownActiveSnowCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if use_deduction ~= nil then
      msgParam.use_deduction = use_deduction
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallQuerySnowManualSnowCmd(pos, stone_book)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.QuerySnowManualSnowCmd()
    if pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      for i = 1, #pos do
        table.insert(msg.pos, pos[i])
      end
    end
    if stone_book ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stone_book == nil then
        msg.stone_book = {}
      end
      for i = 1, #stone_book do
        table.insert(msg.stone_book, stone_book[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuerySnowManualSnowCmd.id
    local msgParam = {}
    if pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      for i = 1, #pos do
        table.insert(msgParam.pos, pos[i])
      end
    end
    if stone_book ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stone_book == nil then
        msgParam.stone_book = {}
      end
      for i = 1, #stone_book do
        table.insert(msgParam.stone_book, stone_book[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowManualUpdateSnowCmd(updates)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowManualUpdateSnowCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowManualUpdateSnowCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowManualEquipUpdateSnowCmd(pos, update)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowManualEquipUpdateSnowCmd()
    if pos ~= nil then
      msg.pos = pos
    end
    if update.base ~= nil and update.base.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.guid = update.base.guid
    end
    if update.base ~= nil and update.base.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.id = update.base.id
    end
    if update.base ~= nil and update.base.count ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.count = update.base.count
    end
    if update.base ~= nil and update.base.index ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.index = update.base.index
    end
    if update.base ~= nil and update.base.createtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.createtime = update.base.createtime
    end
    if update.base ~= nil and update.base.cd ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.cd = update.base.cd
    end
    if update.base ~= nil and update.base.type ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.type = update.base.type
    end
    if update.base ~= nil and update.base.bind ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.bind = update.base.bind
    end
    if update.base ~= nil and update.base.expire ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.expire = update.base.expire
    end
    if update.base ~= nil and update.base.quality ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.quality = update.base.quality
    end
    if update.base ~= nil and update.base.equipType ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.equipType = update.base.equipType
    end
    if update.base ~= nil and update.base.source ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.source = update.base.source
    end
    if update.base ~= nil and update.base.isnew ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.isnew = update.base.isnew
    end
    if update.base ~= nil and update.base.maxcardslot ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.maxcardslot = update.base.maxcardslot
    end
    if update.base ~= nil and update.base.ishint ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.ishint = update.base.ishint
    end
    if update.base ~= nil and update.base.isactive ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.isactive = update.base.isactive
    end
    if update.base ~= nil and update.base.source_npc ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.source_npc = update.base.source_npc
    end
    if update.base ~= nil and update.base.refinelv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.refinelv = update.base.refinelv
    end
    if update.base ~= nil and update.base.chargemoney ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.chargemoney = update.base.chargemoney
    end
    if update.base ~= nil and update.base.overtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.overtime = update.base.overtime
    end
    if update.base ~= nil and update.base.quota ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.quota = update.base.quota
    end
    if update.base ~= nil and update.base.usedtimes ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.usedtimes = update.base.usedtimes
    end
    if update.base ~= nil and update.base.usedtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.usedtime = update.base.usedtime
    end
    if update.base ~= nil and update.base.isfavorite ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.isfavorite = update.base.isfavorite
    end
    if update ~= nil and update.base.mailhint ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.mailhint == nil then
        msg.update.base.mailhint = {}
      end
      for i = 1, #update.base.mailhint do
        table.insert(msg.update.base.mailhint, update.base.mailhint[i])
      end
    end
    if update.base ~= nil and update.base.subsource ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.subsource = update.base.subsource
    end
    if update.base ~= nil and update.base.randkey ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.randkey = update.base.randkey
    end
    if update.base ~= nil and update.base.sceneinfo ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.sceneinfo = update.base.sceneinfo
    end
    if update.base ~= nil and update.base.local_charge ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.local_charge = update.base.local_charge
    end
    if update.base ~= nil and update.base.charge_deposit_id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.charge_deposit_id = update.base.charge_deposit_id
    end
    if update.base ~= nil and update.base.issplit ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.issplit = update.base.issplit
    end
    if update.base.tmp ~= nil and update.base.tmp.none ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.tmp == nil then
        msg.update.base.tmp = {}
      end
      msg.update.base.tmp.none = update.base.tmp.none
    end
    if update.base.tmp ~= nil and update.base.tmp.num_param ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.tmp == nil then
        msg.update.base.tmp = {}
      end
      msg.update.base.tmp.num_param = update.base.tmp.num_param
    end
    if update.base.tmp ~= nil and update.base.tmp.from_reward ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.tmp == nil then
        msg.update.base.tmp = {}
      end
      msg.update.base.tmp.from_reward = update.base.tmp.from_reward
    end
    if update.base ~= nil and update.base.mount_fashion_activated ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.mount_fashion_activated = update.base.mount_fashion_activated
    end
    if update.base ~= nil and update.base.no_trade_reason ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.no_trade_reason = update.base.no_trade_reason
    end
    if update.base.card_info ~= nil and update.base.card_info.lv ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.card_info == nil then
        msg.update.base.card_info = {}
      end
      msg.update.base.card_info.lv = update.base.card_info.lv
    end
    if update ~= nil and update.equiped ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.equiped = update.equiped
    end
    if update ~= nil and update.battlepoint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.battlepoint = update.battlepoint
    end
    if update.equip ~= nil and update.equip.strengthlv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.strengthlv = update.equip.strengthlv
    end
    if update.equip ~= nil and update.equip.refinelv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.refinelv = update.equip.refinelv
    end
    if update.equip ~= nil and update.equip.strengthCost ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.strengthCost = update.equip.strengthCost
    end
    if update ~= nil and update.equip.refineCompose ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.refineCompose == nil then
        msg.update.equip.refineCompose = {}
      end
      for i = 1, #update.equip.refineCompose do
        table.insert(msg.update.equip.refineCompose, update.equip.refineCompose[i])
      end
    end
    if update.equip ~= nil and update.equip.cardslot ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.cardslot = update.equip.cardslot
    end
    if update ~= nil and update.equip.buffid ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.buffid == nil then
        msg.update.equip.buffid = {}
      end
      for i = 1, #update.equip.buffid do
        table.insert(msg.update.equip.buffid, update.equip.buffid[i])
      end
    end
    if update.equip ~= nil and update.equip.damage ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.damage = update.equip.damage
    end
    if update.equip ~= nil and update.equip.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.lv = update.equip.lv
    end
    if update.equip ~= nil and update.equip.color ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.color = update.equip.color
    end
    if update.equip ~= nil and update.equip.breakstarttime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.breakstarttime = update.equip.breakstarttime
    end
    if update.equip ~= nil and update.equip.breakendtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.breakendtime = update.equip.breakendtime
    end
    if update.equip ~= nil and update.equip.strengthlv2 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.strengthlv2 = update.equip.strengthlv2
    end
    if update.equip ~= nil and update.equip.quenchper ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.quenchper = update.equip.quenchper
    end
    if update ~= nil and update.equip.strengthlv2cost ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.strengthlv2cost == nil then
        msg.update.equip.strengthlv2cost = {}
      end
      for i = 1, #update.equip.strengthlv2cost do
        table.insert(msg.update.equip.strengthlv2cost, update.equip.strengthlv2cost[i])
      end
    end
    if update ~= nil and update.equip.attrs ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.attrs == nil then
        msg.update.equip.attrs = {}
      end
      for i = 1, #update.equip.attrs do
        table.insert(msg.update.equip.attrs, update.equip.attrs[i])
      end
    end
    if update.equip ~= nil and update.equip.extra_refine_value ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.extra_refine_value = update.equip.extra_refine_value
    end
    if update ~= nil and update.card ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.card == nil then
        msg.update.card = {}
      end
      for i = 1, #update.card do
        table.insert(msg.update.card, update.card[i])
      end
    end
    if update.enchant ~= nil and update.enchant.type ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      msg.update.enchant.type = update.enchant.type
    end
    if update ~= nil and update.enchant.attrs ~= nil then
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      if msg.update.enchant.attrs == nil then
        msg.update.enchant.attrs = {}
      end
      for i = 1, #update.enchant.attrs do
        table.insert(msg.update.enchant.attrs, update.enchant.attrs[i])
      end
    end
    if update ~= nil and update.enchant.extras ~= nil then
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      if msg.update.enchant.extras == nil then
        msg.update.enchant.extras = {}
      end
      for i = 1, #update.enchant.extras do
        table.insert(msg.update.enchant.extras, update.enchant.extras[i])
      end
    end
    if update ~= nil and update.enchant.patch ~= nil then
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      if msg.update.enchant.patch == nil then
        msg.update.enchant.patch = {}
      end
      for i = 1, #update.enchant.patch do
        table.insert(msg.update.enchant.patch, update.enchant.patch[i])
      end
    end
    if update.enchant ~= nil and update.enchant.israteup ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      msg.update.enchant.israteup = update.enchant.israteup
    end
    if update.prenchant ~= nil and update.prenchant.type ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      msg.update.prenchant.type = update.prenchant.type
    end
    if update ~= nil and update.prenchant.attrs ~= nil then
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      if msg.update.prenchant.attrs == nil then
        msg.update.prenchant.attrs = {}
      end
      for i = 1, #update.prenchant.attrs do
        table.insert(msg.update.prenchant.attrs, update.prenchant.attrs[i])
      end
    end
    if update ~= nil and update.prenchant.extras ~= nil then
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      if msg.update.prenchant.extras == nil then
        msg.update.prenchant.extras = {}
      end
      for i = 1, #update.prenchant.extras do
        table.insert(msg.update.prenchant.extras, update.prenchant.extras[i])
      end
    end
    if update ~= nil and update.prenchant.patch ~= nil then
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      if msg.update.prenchant.patch == nil then
        msg.update.prenchant.patch = {}
      end
      for i = 1, #update.prenchant.patch do
        table.insert(msg.update.prenchant.patch, update.prenchant.patch[i])
      end
    end
    if update.prenchant ~= nil and update.prenchant.israteup ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      msg.update.prenchant.israteup = update.prenchant.israteup
    end
    if update.refine ~= nil and update.refine.lastfail ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.lastfail = update.refine.lastfail
    end
    if update.refine ~= nil and update.refine.repaircount ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.repaircount = update.refine.repaircount
    end
    if update.refine ~= nil and update.refine.lastfailcount ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.lastfailcount = update.refine.lastfailcount
    end
    if update.refine ~= nil and update.refine.history_fix_rate ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.history_fix_rate = update.refine.history_fix_rate
    end
    if update.refine ~= nil and update.refine.cost_count ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.cost_count = update.refine.cost_count
    end
    if update ~= nil and update.refine.cost_counts ~= nil then
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      if msg.update.refine.cost_counts == nil then
        msg.update.refine.cost_counts = {}
      end
      for i = 1, #update.refine.cost_counts do
        table.insert(msg.update.refine.cost_counts, update.refine.cost_counts[i])
      end
    end
    if update.egg ~= nil and update.egg.exp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.exp = update.egg.exp
    end
    if update.egg ~= nil and update.egg.friendexp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.friendexp = update.egg.friendexp
    end
    if update.egg ~= nil and update.egg.rewardexp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.rewardexp = update.egg.rewardexp
    end
    if update.egg ~= nil and update.egg.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.id = update.egg.id
    end
    if update.egg ~= nil and update.egg.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.lv = update.egg.lv
    end
    if update.egg ~= nil and update.egg.friendlv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.friendlv = update.egg.friendlv
    end
    if update.egg ~= nil and update.egg.body ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.body = update.egg.body
    end
    if update.egg ~= nil and update.egg.relivetime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.relivetime = update.egg.relivetime
    end
    if update.egg ~= nil and update.egg.hp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.hp = update.egg.hp
    end
    if update.egg ~= nil and update.egg.restoretime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.restoretime = update.egg.restoretime
    end
    if update.egg ~= nil and update.egg.time_happly ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happly = update.egg.time_happly
    end
    if update.egg ~= nil and update.egg.time_excite ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_excite = update.egg.time_excite
    end
    if update.egg ~= nil and update.egg.time_happiness ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happiness = update.egg.time_happiness
    end
    if update.egg ~= nil and update.egg.time_happly_gift ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happly_gift = update.egg.time_happly_gift
    end
    if update.egg ~= nil and update.egg.time_excite_gift ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_excite_gift = update.egg.time_excite_gift
    end
    if update.egg ~= nil and update.egg.time_happiness_gift ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happiness_gift = update.egg.time_happiness_gift
    end
    if update.egg ~= nil and update.egg.touch_tick ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.touch_tick = update.egg.touch_tick
    end
    if update.egg ~= nil and update.egg.feed_tick ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.feed_tick = update.egg.feed_tick
    end
    if update.egg ~= nil and update.egg.name ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.name = update.egg.name
    end
    if update.egg ~= nil and update.egg.var ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.var = update.egg.var
    end
    if update ~= nil and update.egg.skillids ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.skillids == nil then
        msg.update.egg.skillids = {}
      end
      for i = 1, #update.egg.skillids do
        table.insert(msg.update.egg.skillids, update.egg.skillids[i])
      end
    end
    if update ~= nil and update.egg.equips ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.equips == nil then
        msg.update.egg.equips = {}
      end
      for i = 1, #update.egg.equips do
        table.insert(msg.update.egg.equips, update.egg.equips[i])
      end
    end
    if update.egg ~= nil and update.egg.buff ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.buff = update.egg.buff
    end
    if update ~= nil and update.egg.unlock_equip ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.unlock_equip == nil then
        msg.update.egg.unlock_equip = {}
      end
      for i = 1, #update.egg.unlock_equip do
        table.insert(msg.update.egg.unlock_equip, update.egg.unlock_equip[i])
      end
    end
    if update ~= nil and update.egg.unlock_body ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.unlock_body == nil then
        msg.update.egg.unlock_body = {}
      end
      for i = 1, #update.egg.unlock_body do
        table.insert(msg.update.egg.unlock_body, update.egg.unlock_body[i])
      end
    end
    if update.egg ~= nil and update.egg.version ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.version = update.egg.version
    end
    if update.egg ~= nil and update.egg.skilloff ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.skilloff = update.egg.skilloff
    end
    if update.egg ~= nil and update.egg.exchange_count ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.exchange_count = update.egg.exchange_count
    end
    if update.egg ~= nil and update.egg.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.guid = update.egg.guid
    end
    if update ~= nil and update.egg.defaultwears ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.defaultwears == nil then
        msg.update.egg.defaultwears = {}
      end
      for i = 1, #update.egg.defaultwears do
        table.insert(msg.update.egg.defaultwears, update.egg.defaultwears[i])
      end
    end
    if update ~= nil and update.egg.wears ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.wears == nil then
        msg.update.egg.wears = {}
      end
      for i = 1, #update.egg.wears do
        table.insert(msg.update.egg.wears, update.egg.wears[i])
      end
    end
    if update.egg ~= nil and update.egg.cdtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.cdtime = update.egg.cdtime
    end
    if update.egg ~= nil and update.egg.already_hatched ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.already_hatched = update.egg.already_hatched
    end
    if update.egg ~= nil and update.egg.quick_pack_slot ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.quick_pack_slot = update.egg.quick_pack_slot
    end
    if update.letter ~= nil and update.letter.sendUserName ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.sendUserName = update.letter.sendUserName
    end
    if update.letter ~= nil and update.letter.bg ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.bg = update.letter.bg
    end
    if update.letter ~= nil and update.letter.configID ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.configID = update.letter.configID
    end
    if update.letter ~= nil and update.letter.content ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.content = update.letter.content
    end
    if update.letter ~= nil and update.letter.content2 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.content2 = update.letter.content2
    end
    if update.code ~= nil and update.code.code ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.code == nil then
        msg.update.code = {}
      end
      msg.update.code.code = update.code.code
    end
    if update.code ~= nil and update.code.used ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.code == nil then
        msg.update.code = {}
      end
      msg.update.code.used = update.code.used
    end
    if update.wedding ~= nil and update.wedding.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.id = update.wedding.id
    end
    if update.wedding ~= nil and update.wedding.zoneid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.zoneid = update.wedding.zoneid
    end
    if update.wedding ~= nil and update.wedding.charid1 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.charid1 = update.wedding.charid1
    end
    if update.wedding ~= nil and update.wedding.charid2 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.charid2 = update.wedding.charid2
    end
    if update.wedding ~= nil and update.wedding.weddingtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.weddingtime = update.wedding.weddingtime
    end
    if update.wedding ~= nil and update.wedding.photoidx ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.photoidx = update.wedding.photoidx
    end
    if update.wedding ~= nil and update.wedding.phototime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.phototime = update.wedding.phototime
    end
    if update.wedding ~= nil and update.wedding.myname ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.myname = update.wedding.myname
    end
    if update.wedding ~= nil and update.wedding.partnername ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.partnername = update.wedding.partnername
    end
    if update.wedding ~= nil and update.wedding.starttime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.starttime = update.wedding.starttime
    end
    if update.wedding ~= nil and update.wedding.endtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.endtime = update.wedding.endtime
    end
    if update.wedding ~= nil and update.wedding.notified ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.notified = update.wedding.notified
    end
    if update.sender ~= nil and update.sender.charid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.sender == nil then
        msg.update.sender = {}
      end
      msg.update.sender.charid = update.sender.charid
    end
    if update.sender ~= nil and update.sender.name ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.sender == nil then
        msg.update.sender = {}
      end
      msg.update.sender.name = update.sender.name
    end
    if update.furniture ~= nil and update.furniture.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.id = update.furniture.id
    end
    if update.furniture ~= nil and update.furniture.angle ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.angle = update.furniture.angle
    end
    if update.furniture ~= nil and update.furniture.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.lv = update.furniture.lv
    end
    if update.furniture ~= nil and update.furniture.row ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.row = update.furniture.row
    end
    if update.furniture ~= nil and update.furniture.col ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.col = update.furniture.col
    end
    if update.furniture ~= nil and update.furniture.floor ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.floor = update.furniture.floor
    end
    if update.furniture ~= nil and update.furniture.rewardtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.rewardtime = update.furniture.rewardtime
    end
    if update.furniture ~= nil and update.furniture.state ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.state = update.furniture.state
    end
    if update.furniture ~= nil and update.furniture.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.guid = update.furniture.guid
    end
    if update.furniture ~= nil and update.furniture.old_guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.old_guid = update.furniture.old_guid
    end
    if update.furniture ~= nil and update.furniture.var ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.var = update.furniture.var
    end
    if update ~= nil and update.furniture.seats ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.seats == nil then
        msg.update.furniture.seats = {}
      end
      for i = 1, #update.furniture.seats do
        table.insert(msg.update.furniture.seats, update.furniture.seats[i])
      end
    end
    if update ~= nil and update.furniture.seatskills ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.seatskills == nil then
        msg.update.furniture.seatskills = {}
      end
      for i = 1, #update.furniture.seatskills do
        table.insert(msg.update.furniture.seatskills, update.furniture.seatskills[i])
      end
    end
    if update ~= nil and update.furniture.photos ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.photos == nil then
        msg.update.furniture.photos = {}
      end
      for i = 1, #update.furniture.photos do
        table.insert(msg.update.furniture.photos, update.furniture.photos[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.race ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.race = update.furniture.npc.race
    end
    if update.furniture.npc ~= nil and update.furniture.npc.shape ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.shape = update.furniture.npc.shape
    end
    if update.furniture.npc ~= nil and update.furniture.npc.nature ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.nature = update.furniture.npc.nature
    end
    if update.furniture.npc ~= nil and update.furniture.npc.hpreduce ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.hpreduce = update.furniture.npc.hpreduce
    end
    if update.furniture.npc ~= nil and update.furniture.npc.naturelv ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.naturelv = update.furniture.npc.naturelv
    end
    if update ~= nil and update.furniture.npc.history_max ~= nil then
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      if msg.update.furniture.npc.history_max == nil then
        msg.update.furniture.npc.history_max = {}
      end
      for i = 1, #update.furniture.npc.history_max do
        table.insert(msg.update.furniture.npc.history_max, update.furniture.npc.history_max[i])
      end
    end
    if update ~= nil and update.furniture.npc.day_max ~= nil then
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      if msg.update.furniture.npc.day_max == nil then
        msg.update.furniture.npc.day_max = {}
      end
      for i = 1, #update.furniture.npc.day_max do
        table.insert(msg.update.furniture.npc.day_max, update.furniture.npc.day_max[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.bosstype ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.bosstype = update.furniture.npc.bosstype
    end
    if update.furniture.npc ~= nil and update.furniture.npc.wood_type ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.wood_type = update.furniture.npc.wood_type
    end
    if update.furniture.npc ~= nil and update.furniture.npc.monster_id ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.monster_id = update.furniture.npc.monster_id
    end
    if update.furniture.npc ~= nil and update.furniture.npc.damage_reduce_type ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.damage_reduce_type = update.furniture.npc.damage_reduce_type
    end
    if update.furniture.anim ~= nil and update.furniture.anim.start_time ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.anim == nil then
        msg.update.furniture.anim = {}
      end
      msg.update.furniture.anim.start_time = update.furniture.anim.start_time
    end
    if update.furniture.anim ~= nil and update.furniture.anim.anim_id ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.anim == nil then
        msg.update.furniture.anim = {}
      end
      msg.update.furniture.anim.anim_id = update.furniture.anim.anim_id
    end
    if update.attr ~= nil and update.attr.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.id = update.attr.id
    end
    if update.attr ~= nil and update.attr.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.lv = update.attr.lv
    end
    if update.attr ~= nil and update.attr.exp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.exp = update.attr.exp
    end
    if update.attr ~= nil and update.attr.pos ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.pos = update.attr.pos
    end
    if update.attr ~= nil and update.attr.time ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.time = update.attr.time
    end
    if update.attr ~= nil and update.attr.charid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.charid = update.attr.charid
    end
    if update.skill ~= nil and update.skill.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.id = update.skill.id
    end
    if update.skill ~= nil and update.skill.pos ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.pos = update.skill.pos
    end
    if update.skill ~= nil and update.skill.charid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.charid = update.skill.charid
    end
    if update.skill ~= nil and update.skill.issame ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.issame = update.skill.issame
    end
    if update ~= nil and update.skill.buffs ~= nil then
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      if msg.update.skill.buffs == nil then
        msg.update.skill.buffs = {}
      end
      for i = 1, #update.skill.buffs do
        table.insert(msg.update.skill.buffs, update.skill.buffs[i])
      end
    end
    if update ~= nil and update.skill.carves ~= nil then
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      if msg.update.skill.carves == nil then
        msg.update.skill.carves = {}
      end
      for i = 1, #update.skill.carves do
        table.insert(msg.update.skill.carves, update.skill.carves[i])
      end
    end
    if update.skill ~= nil and update.skill.isforbid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.isforbid = update.skill.isforbid
    end
    if update.skill ~= nil and update.skill.isfull ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.isfull = update.skill.isfull
    end
    if update.home ~= nil and update.home.ownerid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.home == nil then
        msg.update.home = {}
      end
      msg.update.home.ownerid = update.home.ownerid
    end
    if update ~= nil and update.artifact.attrs ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.attrs == nil then
        msg.update.artifact.attrs = {}
      end
      for i = 1, #update.artifact.attrs do
        table.insert(msg.update.artifact.attrs, update.artifact.attrs[i])
      end
    end
    if update ~= nil and update.artifact.preattrs ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.preattrs == nil then
        msg.update.artifact.preattrs = {}
      end
      for i = 1, #update.artifact.preattrs do
        table.insert(msg.update.artifact.preattrs, update.artifact.preattrs[i])
      end
    end
    if update.artifact ~= nil and update.artifact.art_state ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      msg.update.artifact.art_state = update.artifact.art_state
    end
    if update ~= nil and update.artifact.art_fragment ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.art_fragment == nil then
        msg.update.artifact.art_fragment = {}
      end
      for i = 1, #update.artifact.art_fragment do
        table.insert(msg.update.artifact.art_fragment, update.artifact.art_fragment[i])
      end
    end
    if update ~= nil and update.artifact.noattrs ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.noattrs == nil then
        msg.update.artifact.noattrs = {}
      end
      for i = 1, #update.artifact.noattrs do
        table.insert(msg.update.artifact.noattrs, update.artifact.noattrs[i])
      end
    end
    if update.cupinfo ~= nil and update.cupinfo.name ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.cupinfo == nil then
        msg.update.cupinfo = {}
      end
      msg.update.cupinfo.name = update.cupinfo.name
    end
    if update ~= nil and update.previewattr ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.previewattr == nil then
        msg.update.previewattr = {}
      end
      for i = 1, #update.previewattr do
        table.insert(msg.update.previewattr, update.previewattr[i])
      end
    end
    if update ~= nil and update.previewenchant ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.previewenchant == nil then
        msg.update.previewenchant = {}
      end
      for i = 1, #update.previewenchant do
        table.insert(msg.update.previewenchant, update.previewenchant[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.config_id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.config_id = update.red_packet.config_id
    end
    if update.red_packet ~= nil and update.red_packet.min_num ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.min_num = update.red_packet.min_num
    end
    if update.red_packet ~= nil and update.red_packet.max_num ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.max_num = update.red_packet.max_num
    end
    if update.red_packet ~= nil and update.red_packet.min_money ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.min_money = update.red_packet.min_money
    end
    if update.red_packet ~= nil and update.red_packet.max_money ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.max_money = update.red_packet.max_money
    end
    if update ~= nil and update.red_packet.multi_items ~= nil then
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      if msg.update.red_packet.multi_items == nil then
        msg.update.red_packet.multi_items = {}
      end
      for i = 1, #update.red_packet.multi_items do
        table.insert(msg.update.red_packet.multi_items, update.red_packet.multi_items[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.gvg_cityid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.gvg_cityid = update.red_packet.gvg_cityid
    end
    if update ~= nil and update.red_packet.gvg_charids ~= nil then
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      if msg.update.red_packet.gvg_charids == nil then
        msg.update.red_packet.gvg_charids = {}
      end
      for i = 1, #update.red_packet.gvg_charids do
        table.insert(msg.update.red_packet.gvg_charids, update.red_packet.gvg_charids[i])
      end
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.id = update.gem_secret_land.id
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.color ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.color = update.gem_secret_land.color
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.lv = update.gem_secret_land.lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.max_lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.max_lv = update.gem_secret_land.max_lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.exp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.exp = update.gem_secret_land.exp
    end
    if update ~= nil and update.gem_secret_land.buffs ~= nil then
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      if msg.update.gem_secret_land.buffs == nil then
        msg.update.gem_secret_land.buffs = {}
      end
      for i = 1, #update.gem_secret_land.buffs do
        table.insert(msg.update.gem_secret_land.buffs, update.gem_secret_land.buffs[i])
      end
    end
    if update ~= nil and update.gem_secret_land.char_data ~= nil then
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      if msg.update.gem_secret_land.char_data == nil then
        msg.update.gem_secret_land.char_data = {}
      end
      for i = 1, #update.gem_secret_land.char_data do
        table.insert(msg.update.gem_secret_land.char_data, update.gem_secret_land.char_data[i])
      end
    end
    if update.memory ~= nil and update.memory.itemid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      msg.update.memory.itemid = update.memory.itemid
    end
    if update.memory ~= nil and update.memory.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      msg.update.memory.lv = update.memory.lv
    end
    if update.memory ~= nil and update.memory.excess_lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      msg.update.memory.excess_lv = update.memory.excess_lv
    end
    if update.memory ~= nil and update.memory.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      msg.update.memory.guid = update.memory.guid
    end
    if update ~= nil and update.memory.effects ~= nil then
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      if msg.update.memory.effects == nil then
        msg.update.memory.effects = {}
      end
      for i = 1, #update.memory.effects do
        table.insert(msg.update.memory.effects, update.memory.effects[i])
      end
    end
    if update ~= nil and update.deletetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.deletetime = update.deletetime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowManualEquipUpdateSnowCmd.id
    local msgParam = {}
    if pos ~= nil then
      msgParam.pos = pos
    end
    if update.base ~= nil and update.base.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.guid = update.base.guid
    end
    if update.base ~= nil and update.base.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.id = update.base.id
    end
    if update.base ~= nil and update.base.count ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.count = update.base.count
    end
    if update.base ~= nil and update.base.index ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.index = update.base.index
    end
    if update.base ~= nil and update.base.createtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.createtime = update.base.createtime
    end
    if update.base ~= nil and update.base.cd ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.cd = update.base.cd
    end
    if update.base ~= nil and update.base.type ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.type = update.base.type
    end
    if update.base ~= nil and update.base.bind ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.bind = update.base.bind
    end
    if update.base ~= nil and update.base.expire ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.expire = update.base.expire
    end
    if update.base ~= nil and update.base.quality ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.quality = update.base.quality
    end
    if update.base ~= nil and update.base.equipType ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.equipType = update.base.equipType
    end
    if update.base ~= nil and update.base.source ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.source = update.base.source
    end
    if update.base ~= nil and update.base.isnew ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.isnew = update.base.isnew
    end
    if update.base ~= nil and update.base.maxcardslot ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.maxcardslot = update.base.maxcardslot
    end
    if update.base ~= nil and update.base.ishint ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.ishint = update.base.ishint
    end
    if update.base ~= nil and update.base.isactive ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.isactive = update.base.isactive
    end
    if update.base ~= nil and update.base.source_npc ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.source_npc = update.base.source_npc
    end
    if update.base ~= nil and update.base.refinelv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.refinelv = update.base.refinelv
    end
    if update.base ~= nil and update.base.chargemoney ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.chargemoney = update.base.chargemoney
    end
    if update.base ~= nil and update.base.overtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.overtime = update.base.overtime
    end
    if update.base ~= nil and update.base.quota ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.quota = update.base.quota
    end
    if update.base ~= nil and update.base.usedtimes ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.usedtimes = update.base.usedtimes
    end
    if update.base ~= nil and update.base.usedtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.usedtime = update.base.usedtime
    end
    if update.base ~= nil and update.base.isfavorite ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.isfavorite = update.base.isfavorite
    end
    if update ~= nil and update.base.mailhint ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.mailhint == nil then
        msgParam.update.base.mailhint = {}
      end
      for i = 1, #update.base.mailhint do
        table.insert(msgParam.update.base.mailhint, update.base.mailhint[i])
      end
    end
    if update.base ~= nil and update.base.subsource ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.subsource = update.base.subsource
    end
    if update.base ~= nil and update.base.randkey ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.randkey = update.base.randkey
    end
    if update.base ~= nil and update.base.sceneinfo ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.sceneinfo = update.base.sceneinfo
    end
    if update.base ~= nil and update.base.local_charge ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.local_charge = update.base.local_charge
    end
    if update.base ~= nil and update.base.charge_deposit_id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.charge_deposit_id = update.base.charge_deposit_id
    end
    if update.base ~= nil and update.base.issplit ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.issplit = update.base.issplit
    end
    if update.base.tmp ~= nil and update.base.tmp.none ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.tmp == nil then
        msgParam.update.base.tmp = {}
      end
      msgParam.update.base.tmp.none = update.base.tmp.none
    end
    if update.base.tmp ~= nil and update.base.tmp.num_param ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.tmp == nil then
        msgParam.update.base.tmp = {}
      end
      msgParam.update.base.tmp.num_param = update.base.tmp.num_param
    end
    if update.base.tmp ~= nil and update.base.tmp.from_reward ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.tmp == nil then
        msgParam.update.base.tmp = {}
      end
      msgParam.update.base.tmp.from_reward = update.base.tmp.from_reward
    end
    if update.base ~= nil and update.base.mount_fashion_activated ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.mount_fashion_activated = update.base.mount_fashion_activated
    end
    if update.base ~= nil and update.base.no_trade_reason ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.no_trade_reason = update.base.no_trade_reason
    end
    if update.base.card_info ~= nil and update.base.card_info.lv ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.card_info == nil then
        msgParam.update.base.card_info = {}
      end
      msgParam.update.base.card_info.lv = update.base.card_info.lv
    end
    if update ~= nil and update.equiped ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.equiped = update.equiped
    end
    if update ~= nil and update.battlepoint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.battlepoint = update.battlepoint
    end
    if update.equip ~= nil and update.equip.strengthlv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.strengthlv = update.equip.strengthlv
    end
    if update.equip ~= nil and update.equip.refinelv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.refinelv = update.equip.refinelv
    end
    if update.equip ~= nil and update.equip.strengthCost ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.strengthCost = update.equip.strengthCost
    end
    if update ~= nil and update.equip.refineCompose ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.refineCompose == nil then
        msgParam.update.equip.refineCompose = {}
      end
      for i = 1, #update.equip.refineCompose do
        table.insert(msgParam.update.equip.refineCompose, update.equip.refineCompose[i])
      end
    end
    if update.equip ~= nil and update.equip.cardslot ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.cardslot = update.equip.cardslot
    end
    if update ~= nil and update.equip.buffid ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.buffid == nil then
        msgParam.update.equip.buffid = {}
      end
      for i = 1, #update.equip.buffid do
        table.insert(msgParam.update.equip.buffid, update.equip.buffid[i])
      end
    end
    if update.equip ~= nil and update.equip.damage ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.damage = update.equip.damage
    end
    if update.equip ~= nil and update.equip.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.lv = update.equip.lv
    end
    if update.equip ~= nil and update.equip.color ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.color = update.equip.color
    end
    if update.equip ~= nil and update.equip.breakstarttime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.breakstarttime = update.equip.breakstarttime
    end
    if update.equip ~= nil and update.equip.breakendtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.breakendtime = update.equip.breakendtime
    end
    if update.equip ~= nil and update.equip.strengthlv2 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.strengthlv2 = update.equip.strengthlv2
    end
    if update.equip ~= nil and update.equip.quenchper ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.quenchper = update.equip.quenchper
    end
    if update ~= nil and update.equip.strengthlv2cost ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.strengthlv2cost == nil then
        msgParam.update.equip.strengthlv2cost = {}
      end
      for i = 1, #update.equip.strengthlv2cost do
        table.insert(msgParam.update.equip.strengthlv2cost, update.equip.strengthlv2cost[i])
      end
    end
    if update ~= nil and update.equip.attrs ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.attrs == nil then
        msgParam.update.equip.attrs = {}
      end
      for i = 1, #update.equip.attrs do
        table.insert(msgParam.update.equip.attrs, update.equip.attrs[i])
      end
    end
    if update.equip ~= nil and update.equip.extra_refine_value ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.extra_refine_value = update.equip.extra_refine_value
    end
    if update ~= nil and update.card ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.card == nil then
        msgParam.update.card = {}
      end
      for i = 1, #update.card do
        table.insert(msgParam.update.card, update.card[i])
      end
    end
    if update.enchant ~= nil and update.enchant.type ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      msgParam.update.enchant.type = update.enchant.type
    end
    if update ~= nil and update.enchant.attrs ~= nil then
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      if msgParam.update.enchant.attrs == nil then
        msgParam.update.enchant.attrs = {}
      end
      for i = 1, #update.enchant.attrs do
        table.insert(msgParam.update.enchant.attrs, update.enchant.attrs[i])
      end
    end
    if update ~= nil and update.enchant.extras ~= nil then
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      if msgParam.update.enchant.extras == nil then
        msgParam.update.enchant.extras = {}
      end
      for i = 1, #update.enchant.extras do
        table.insert(msgParam.update.enchant.extras, update.enchant.extras[i])
      end
    end
    if update ~= nil and update.enchant.patch ~= nil then
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      if msgParam.update.enchant.patch == nil then
        msgParam.update.enchant.patch = {}
      end
      for i = 1, #update.enchant.patch do
        table.insert(msgParam.update.enchant.patch, update.enchant.patch[i])
      end
    end
    if update.enchant ~= nil and update.enchant.israteup ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      msgParam.update.enchant.israteup = update.enchant.israteup
    end
    if update.prenchant ~= nil and update.prenchant.type ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      msgParam.update.prenchant.type = update.prenchant.type
    end
    if update ~= nil and update.prenchant.attrs ~= nil then
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      if msgParam.update.prenchant.attrs == nil then
        msgParam.update.prenchant.attrs = {}
      end
      for i = 1, #update.prenchant.attrs do
        table.insert(msgParam.update.prenchant.attrs, update.prenchant.attrs[i])
      end
    end
    if update ~= nil and update.prenchant.extras ~= nil then
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      if msgParam.update.prenchant.extras == nil then
        msgParam.update.prenchant.extras = {}
      end
      for i = 1, #update.prenchant.extras do
        table.insert(msgParam.update.prenchant.extras, update.prenchant.extras[i])
      end
    end
    if update ~= nil and update.prenchant.patch ~= nil then
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      if msgParam.update.prenchant.patch == nil then
        msgParam.update.prenchant.patch = {}
      end
      for i = 1, #update.prenchant.patch do
        table.insert(msgParam.update.prenchant.patch, update.prenchant.patch[i])
      end
    end
    if update.prenchant ~= nil and update.prenchant.israteup ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      msgParam.update.prenchant.israteup = update.prenchant.israteup
    end
    if update.refine ~= nil and update.refine.lastfail ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.lastfail = update.refine.lastfail
    end
    if update.refine ~= nil and update.refine.repaircount ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.repaircount = update.refine.repaircount
    end
    if update.refine ~= nil and update.refine.lastfailcount ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.lastfailcount = update.refine.lastfailcount
    end
    if update.refine ~= nil and update.refine.history_fix_rate ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.history_fix_rate = update.refine.history_fix_rate
    end
    if update.refine ~= nil and update.refine.cost_count ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.cost_count = update.refine.cost_count
    end
    if update ~= nil and update.refine.cost_counts ~= nil then
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      if msgParam.update.refine.cost_counts == nil then
        msgParam.update.refine.cost_counts = {}
      end
      for i = 1, #update.refine.cost_counts do
        table.insert(msgParam.update.refine.cost_counts, update.refine.cost_counts[i])
      end
    end
    if update.egg ~= nil and update.egg.exp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.exp = update.egg.exp
    end
    if update.egg ~= nil and update.egg.friendexp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.friendexp = update.egg.friendexp
    end
    if update.egg ~= nil and update.egg.rewardexp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.rewardexp = update.egg.rewardexp
    end
    if update.egg ~= nil and update.egg.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.id = update.egg.id
    end
    if update.egg ~= nil and update.egg.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.lv = update.egg.lv
    end
    if update.egg ~= nil and update.egg.friendlv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.friendlv = update.egg.friendlv
    end
    if update.egg ~= nil and update.egg.body ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.body = update.egg.body
    end
    if update.egg ~= nil and update.egg.relivetime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.relivetime = update.egg.relivetime
    end
    if update.egg ~= nil and update.egg.hp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.hp = update.egg.hp
    end
    if update.egg ~= nil and update.egg.restoretime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.restoretime = update.egg.restoretime
    end
    if update.egg ~= nil and update.egg.time_happly ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happly = update.egg.time_happly
    end
    if update.egg ~= nil and update.egg.time_excite ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_excite = update.egg.time_excite
    end
    if update.egg ~= nil and update.egg.time_happiness ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happiness = update.egg.time_happiness
    end
    if update.egg ~= nil and update.egg.time_happly_gift ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happly_gift = update.egg.time_happly_gift
    end
    if update.egg ~= nil and update.egg.time_excite_gift ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_excite_gift = update.egg.time_excite_gift
    end
    if update.egg ~= nil and update.egg.time_happiness_gift ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happiness_gift = update.egg.time_happiness_gift
    end
    if update.egg ~= nil and update.egg.touch_tick ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.touch_tick = update.egg.touch_tick
    end
    if update.egg ~= nil and update.egg.feed_tick ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.feed_tick = update.egg.feed_tick
    end
    if update.egg ~= nil and update.egg.name ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.name = update.egg.name
    end
    if update.egg ~= nil and update.egg.var ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.var = update.egg.var
    end
    if update ~= nil and update.egg.skillids ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.skillids == nil then
        msgParam.update.egg.skillids = {}
      end
      for i = 1, #update.egg.skillids do
        table.insert(msgParam.update.egg.skillids, update.egg.skillids[i])
      end
    end
    if update ~= nil and update.egg.equips ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.equips == nil then
        msgParam.update.egg.equips = {}
      end
      for i = 1, #update.egg.equips do
        table.insert(msgParam.update.egg.equips, update.egg.equips[i])
      end
    end
    if update.egg ~= nil and update.egg.buff ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.buff = update.egg.buff
    end
    if update ~= nil and update.egg.unlock_equip ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.unlock_equip == nil then
        msgParam.update.egg.unlock_equip = {}
      end
      for i = 1, #update.egg.unlock_equip do
        table.insert(msgParam.update.egg.unlock_equip, update.egg.unlock_equip[i])
      end
    end
    if update ~= nil and update.egg.unlock_body ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.unlock_body == nil then
        msgParam.update.egg.unlock_body = {}
      end
      for i = 1, #update.egg.unlock_body do
        table.insert(msgParam.update.egg.unlock_body, update.egg.unlock_body[i])
      end
    end
    if update.egg ~= nil and update.egg.version ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.version = update.egg.version
    end
    if update.egg ~= nil and update.egg.skilloff ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.skilloff = update.egg.skilloff
    end
    if update.egg ~= nil and update.egg.exchange_count ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.exchange_count = update.egg.exchange_count
    end
    if update.egg ~= nil and update.egg.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.guid = update.egg.guid
    end
    if update ~= nil and update.egg.defaultwears ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.defaultwears == nil then
        msgParam.update.egg.defaultwears = {}
      end
      for i = 1, #update.egg.defaultwears do
        table.insert(msgParam.update.egg.defaultwears, update.egg.defaultwears[i])
      end
    end
    if update ~= nil and update.egg.wears ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.wears == nil then
        msgParam.update.egg.wears = {}
      end
      for i = 1, #update.egg.wears do
        table.insert(msgParam.update.egg.wears, update.egg.wears[i])
      end
    end
    if update.egg ~= nil and update.egg.cdtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.cdtime = update.egg.cdtime
    end
    if update.egg ~= nil and update.egg.already_hatched ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.already_hatched = update.egg.already_hatched
    end
    if update.egg ~= nil and update.egg.quick_pack_slot ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.quick_pack_slot = update.egg.quick_pack_slot
    end
    if update.letter ~= nil and update.letter.sendUserName ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.sendUserName = update.letter.sendUserName
    end
    if update.letter ~= nil and update.letter.bg ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.bg = update.letter.bg
    end
    if update.letter ~= nil and update.letter.configID ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.configID = update.letter.configID
    end
    if update.letter ~= nil and update.letter.content ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.content = update.letter.content
    end
    if update.letter ~= nil and update.letter.content2 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.content2 = update.letter.content2
    end
    if update.code ~= nil and update.code.code ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.code == nil then
        msgParam.update.code = {}
      end
      msgParam.update.code.code = update.code.code
    end
    if update.code ~= nil and update.code.used ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.code == nil then
        msgParam.update.code = {}
      end
      msgParam.update.code.used = update.code.used
    end
    if update.wedding ~= nil and update.wedding.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.id = update.wedding.id
    end
    if update.wedding ~= nil and update.wedding.zoneid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.zoneid = update.wedding.zoneid
    end
    if update.wedding ~= nil and update.wedding.charid1 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.charid1 = update.wedding.charid1
    end
    if update.wedding ~= nil and update.wedding.charid2 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.charid2 = update.wedding.charid2
    end
    if update.wedding ~= nil and update.wedding.weddingtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.weddingtime = update.wedding.weddingtime
    end
    if update.wedding ~= nil and update.wedding.photoidx ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.photoidx = update.wedding.photoidx
    end
    if update.wedding ~= nil and update.wedding.phototime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.phototime = update.wedding.phototime
    end
    if update.wedding ~= nil and update.wedding.myname ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.myname = update.wedding.myname
    end
    if update.wedding ~= nil and update.wedding.partnername ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.partnername = update.wedding.partnername
    end
    if update.wedding ~= nil and update.wedding.starttime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.starttime = update.wedding.starttime
    end
    if update.wedding ~= nil and update.wedding.endtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.endtime = update.wedding.endtime
    end
    if update.wedding ~= nil and update.wedding.notified ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.notified = update.wedding.notified
    end
    if update.sender ~= nil and update.sender.charid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.sender == nil then
        msgParam.update.sender = {}
      end
      msgParam.update.sender.charid = update.sender.charid
    end
    if update.sender ~= nil and update.sender.name ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.sender == nil then
        msgParam.update.sender = {}
      end
      msgParam.update.sender.name = update.sender.name
    end
    if update.furniture ~= nil and update.furniture.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.id = update.furniture.id
    end
    if update.furniture ~= nil and update.furniture.angle ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.angle = update.furniture.angle
    end
    if update.furniture ~= nil and update.furniture.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.lv = update.furniture.lv
    end
    if update.furniture ~= nil and update.furniture.row ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.row = update.furniture.row
    end
    if update.furniture ~= nil and update.furniture.col ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.col = update.furniture.col
    end
    if update.furniture ~= nil and update.furniture.floor ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.floor = update.furniture.floor
    end
    if update.furniture ~= nil and update.furniture.rewardtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.rewardtime = update.furniture.rewardtime
    end
    if update.furniture ~= nil and update.furniture.state ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.state = update.furniture.state
    end
    if update.furniture ~= nil and update.furniture.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.guid = update.furniture.guid
    end
    if update.furniture ~= nil and update.furniture.old_guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.old_guid = update.furniture.old_guid
    end
    if update.furniture ~= nil and update.furniture.var ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.var = update.furniture.var
    end
    if update ~= nil and update.furniture.seats ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.seats == nil then
        msgParam.update.furniture.seats = {}
      end
      for i = 1, #update.furniture.seats do
        table.insert(msgParam.update.furniture.seats, update.furniture.seats[i])
      end
    end
    if update ~= nil and update.furniture.seatskills ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.seatskills == nil then
        msgParam.update.furniture.seatskills = {}
      end
      for i = 1, #update.furniture.seatskills do
        table.insert(msgParam.update.furniture.seatskills, update.furniture.seatskills[i])
      end
    end
    if update ~= nil and update.furniture.photos ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.photos == nil then
        msgParam.update.furniture.photos = {}
      end
      for i = 1, #update.furniture.photos do
        table.insert(msgParam.update.furniture.photos, update.furniture.photos[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.race ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.race = update.furniture.npc.race
    end
    if update.furniture.npc ~= nil and update.furniture.npc.shape ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.shape = update.furniture.npc.shape
    end
    if update.furniture.npc ~= nil and update.furniture.npc.nature ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.nature = update.furniture.npc.nature
    end
    if update.furniture.npc ~= nil and update.furniture.npc.hpreduce ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.hpreduce = update.furniture.npc.hpreduce
    end
    if update.furniture.npc ~= nil and update.furniture.npc.naturelv ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.naturelv = update.furniture.npc.naturelv
    end
    if update ~= nil and update.furniture.npc.history_max ~= nil then
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      if msgParam.update.furniture.npc.history_max == nil then
        msgParam.update.furniture.npc.history_max = {}
      end
      for i = 1, #update.furniture.npc.history_max do
        table.insert(msgParam.update.furniture.npc.history_max, update.furniture.npc.history_max[i])
      end
    end
    if update ~= nil and update.furniture.npc.day_max ~= nil then
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      if msgParam.update.furniture.npc.day_max == nil then
        msgParam.update.furniture.npc.day_max = {}
      end
      for i = 1, #update.furniture.npc.day_max do
        table.insert(msgParam.update.furniture.npc.day_max, update.furniture.npc.day_max[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.bosstype ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.bosstype = update.furniture.npc.bosstype
    end
    if update.furniture.npc ~= nil and update.furniture.npc.wood_type ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.wood_type = update.furniture.npc.wood_type
    end
    if update.furniture.npc ~= nil and update.furniture.npc.monster_id ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.monster_id = update.furniture.npc.monster_id
    end
    if update.furniture.npc ~= nil and update.furniture.npc.damage_reduce_type ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.damage_reduce_type = update.furniture.npc.damage_reduce_type
    end
    if update.furniture.anim ~= nil and update.furniture.anim.start_time ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.anim == nil then
        msgParam.update.furniture.anim = {}
      end
      msgParam.update.furniture.anim.start_time = update.furniture.anim.start_time
    end
    if update.furniture.anim ~= nil and update.furniture.anim.anim_id ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.anim == nil then
        msgParam.update.furniture.anim = {}
      end
      msgParam.update.furniture.anim.anim_id = update.furniture.anim.anim_id
    end
    if update.attr ~= nil and update.attr.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.id = update.attr.id
    end
    if update.attr ~= nil and update.attr.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.lv = update.attr.lv
    end
    if update.attr ~= nil and update.attr.exp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.exp = update.attr.exp
    end
    if update.attr ~= nil and update.attr.pos ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.pos = update.attr.pos
    end
    if update.attr ~= nil and update.attr.time ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.time = update.attr.time
    end
    if update.attr ~= nil and update.attr.charid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.charid = update.attr.charid
    end
    if update.skill ~= nil and update.skill.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.id = update.skill.id
    end
    if update.skill ~= nil and update.skill.pos ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.pos = update.skill.pos
    end
    if update.skill ~= nil and update.skill.charid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.charid = update.skill.charid
    end
    if update.skill ~= nil and update.skill.issame ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.issame = update.skill.issame
    end
    if update ~= nil and update.skill.buffs ~= nil then
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      if msgParam.update.skill.buffs == nil then
        msgParam.update.skill.buffs = {}
      end
      for i = 1, #update.skill.buffs do
        table.insert(msgParam.update.skill.buffs, update.skill.buffs[i])
      end
    end
    if update ~= nil and update.skill.carves ~= nil then
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      if msgParam.update.skill.carves == nil then
        msgParam.update.skill.carves = {}
      end
      for i = 1, #update.skill.carves do
        table.insert(msgParam.update.skill.carves, update.skill.carves[i])
      end
    end
    if update.skill ~= nil and update.skill.isforbid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.isforbid = update.skill.isforbid
    end
    if update.skill ~= nil and update.skill.isfull ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.isfull = update.skill.isfull
    end
    if update.home ~= nil and update.home.ownerid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.home == nil then
        msgParam.update.home = {}
      end
      msgParam.update.home.ownerid = update.home.ownerid
    end
    if update ~= nil and update.artifact.attrs ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.attrs == nil then
        msgParam.update.artifact.attrs = {}
      end
      for i = 1, #update.artifact.attrs do
        table.insert(msgParam.update.artifact.attrs, update.artifact.attrs[i])
      end
    end
    if update ~= nil and update.artifact.preattrs ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.preattrs == nil then
        msgParam.update.artifact.preattrs = {}
      end
      for i = 1, #update.artifact.preattrs do
        table.insert(msgParam.update.artifact.preattrs, update.artifact.preattrs[i])
      end
    end
    if update.artifact ~= nil and update.artifact.art_state ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      msgParam.update.artifact.art_state = update.artifact.art_state
    end
    if update ~= nil and update.artifact.art_fragment ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.art_fragment == nil then
        msgParam.update.artifact.art_fragment = {}
      end
      for i = 1, #update.artifact.art_fragment do
        table.insert(msgParam.update.artifact.art_fragment, update.artifact.art_fragment[i])
      end
    end
    if update ~= nil and update.artifact.noattrs ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.noattrs == nil then
        msgParam.update.artifact.noattrs = {}
      end
      for i = 1, #update.artifact.noattrs do
        table.insert(msgParam.update.artifact.noattrs, update.artifact.noattrs[i])
      end
    end
    if update.cupinfo ~= nil and update.cupinfo.name ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.cupinfo == nil then
        msgParam.update.cupinfo = {}
      end
      msgParam.update.cupinfo.name = update.cupinfo.name
    end
    if update ~= nil and update.previewattr ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.previewattr == nil then
        msgParam.update.previewattr = {}
      end
      for i = 1, #update.previewattr do
        table.insert(msgParam.update.previewattr, update.previewattr[i])
      end
    end
    if update ~= nil and update.previewenchant ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.previewenchant == nil then
        msgParam.update.previewenchant = {}
      end
      for i = 1, #update.previewenchant do
        table.insert(msgParam.update.previewenchant, update.previewenchant[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.config_id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.config_id = update.red_packet.config_id
    end
    if update.red_packet ~= nil and update.red_packet.min_num ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.min_num = update.red_packet.min_num
    end
    if update.red_packet ~= nil and update.red_packet.max_num ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.max_num = update.red_packet.max_num
    end
    if update.red_packet ~= nil and update.red_packet.min_money ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.min_money = update.red_packet.min_money
    end
    if update.red_packet ~= nil and update.red_packet.max_money ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.max_money = update.red_packet.max_money
    end
    if update ~= nil and update.red_packet.multi_items ~= nil then
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      if msgParam.update.red_packet.multi_items == nil then
        msgParam.update.red_packet.multi_items = {}
      end
      for i = 1, #update.red_packet.multi_items do
        table.insert(msgParam.update.red_packet.multi_items, update.red_packet.multi_items[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.gvg_cityid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.gvg_cityid = update.red_packet.gvg_cityid
    end
    if update ~= nil and update.red_packet.gvg_charids ~= nil then
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      if msgParam.update.red_packet.gvg_charids == nil then
        msgParam.update.red_packet.gvg_charids = {}
      end
      for i = 1, #update.red_packet.gvg_charids do
        table.insert(msgParam.update.red_packet.gvg_charids, update.red_packet.gvg_charids[i])
      end
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.id = update.gem_secret_land.id
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.color ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.color = update.gem_secret_land.color
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.lv = update.gem_secret_land.lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.max_lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.max_lv = update.gem_secret_land.max_lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.exp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.exp = update.gem_secret_land.exp
    end
    if update ~= nil and update.gem_secret_land.buffs ~= nil then
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      if msgParam.update.gem_secret_land.buffs == nil then
        msgParam.update.gem_secret_land.buffs = {}
      end
      for i = 1, #update.gem_secret_land.buffs do
        table.insert(msgParam.update.gem_secret_land.buffs, update.gem_secret_land.buffs[i])
      end
    end
    if update ~= nil and update.gem_secret_land.char_data ~= nil then
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      if msgParam.update.gem_secret_land.char_data == nil then
        msgParam.update.gem_secret_land.char_data = {}
      end
      for i = 1, #update.gem_secret_land.char_data do
        table.insert(msgParam.update.gem_secret_land.char_data, update.gem_secret_land.char_data[i])
      end
    end
    if update.memory ~= nil and update.memory.itemid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      msgParam.update.memory.itemid = update.memory.itemid
    end
    if update.memory ~= nil and update.memory.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      msgParam.update.memory.lv = update.memory.lv
    end
    if update.memory ~= nil and update.memory.excess_lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      msgParam.update.memory.excess_lv = update.memory.excess_lv
    end
    if update.memory ~= nil and update.memory.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      msgParam.update.memory.guid = update.memory.guid
    end
    if update ~= nil and update.memory.effects ~= nil then
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      if msgParam.update.memory.effects == nil then
        msgParam.update.memory.effects = {}
      end
      for i = 1, #update.memory.effects do
        table.insert(msgParam.update.memory.effects, update.memory.effects[i])
      end
    end
    if update ~= nil and update.deletetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.deletetime = update.deletetime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallSnowManualStoneUpdateSnowCmd(equip_pos, stone_pos, update)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.SnowManualStoneUpdateSnowCmd()
    if equip_pos ~= nil then
      msg.equip_pos = equip_pos
    end
    if stone_pos ~= nil then
      msg.stone_pos = stone_pos
    end
    if update ~= nil then
      msg.update = update
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnowManualStoneUpdateSnowCmd.id
    local msgParam = {}
    if equip_pos ~= nil then
      msgParam.equip_pos = equip_pos
    end
    if stone_pos ~= nil then
      msgParam.stone_pos = stone_pos
    end
    if update ~= nil then
      msgParam.update = update
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallOperSnowEquipSnowCmd(oper, pos, equip_guid)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.OperSnowEquipSnowCmd()
    if oper ~= nil then
      msg.oper = oper
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if equip_guid ~= nil then
      msg.equip_guid = equip_guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OperSnowEquipSnowCmd.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if equip_guid ~= nil then
      msgParam.equip_guid = equip_guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:CallOperSnowStoneSnowCmd(oper, equip_pos, stone_pos, stone_id)
  if not NetConfig.PBC then
    local msg = SnowCmd_pb.OperSnowStoneSnowCmd()
    if oper ~= nil then
      msg.oper = oper
    end
    if equip_pos ~= nil then
      msg.equip_pos = equip_pos
    end
    if stone_pos ~= nil then
      msg.stone_pos = stone_pos
    end
    if stone_id ~= nil then
      msg.stone_id = stone_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OperSnowStoneSnowCmd.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if equip_pos ~= nil then
      msgParam.equip_pos = equip_pos
    end
    if stone_pos ~= nil then
      msgParam.stone_pos = stone_pos
    end
    if stone_id ~= nil then
      msgParam.stone_id = stone_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSnowCmdAutoProxy:RecvSnowRealmPartyStartSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowRealmPartyStartSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowHeadQuerySnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowHeadLvupSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadLvupSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowHeadActiveSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadActiveSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowHeadModeChangeSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadModeChangeSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowHeadFashionSelectSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowHeadFashionSelectSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowCrownActiveSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowCrownActiveSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvQuerySnowManualSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdQuerySnowManualSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowManualUpdateSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowManualUpdateSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowManualEquipUpdateSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowManualEquipUpdateSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvSnowManualStoneUpdateSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdSnowManualStoneUpdateSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvOperSnowEquipSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdOperSnowEquipSnowCmd, data)
end

function ServiceSnowCmdAutoProxy:RecvOperSnowStoneSnowCmd(data)
  self:Notify(ServiceEvent.SnowCmdOperSnowStoneSnowCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SnowCmdSnowRealmPartyStartSnowCmd = "ServiceEvent_SnowCmdSnowRealmPartyStartSnowCmd"
ServiceEvent.SnowCmdSnowHeadQuerySnowCmd = "ServiceEvent_SnowCmdSnowHeadQuerySnowCmd"
ServiceEvent.SnowCmdSnowHeadLvupSnowCmd = "ServiceEvent_SnowCmdSnowHeadLvupSnowCmd"
ServiceEvent.SnowCmdSnowHeadActiveSnowCmd = "ServiceEvent_SnowCmdSnowHeadActiveSnowCmd"
ServiceEvent.SnowCmdSnowHeadModeChangeSnowCmd = "ServiceEvent_SnowCmdSnowHeadModeChangeSnowCmd"
ServiceEvent.SnowCmdSnowHeadFashionSelectSnowCmd = "ServiceEvent_SnowCmdSnowHeadFashionSelectSnowCmd"
ServiceEvent.SnowCmdSnowCrownActiveSnowCmd = "ServiceEvent_SnowCmdSnowCrownActiveSnowCmd"
ServiceEvent.SnowCmdQuerySnowManualSnowCmd = "ServiceEvent_SnowCmdQuerySnowManualSnowCmd"
ServiceEvent.SnowCmdSnowManualUpdateSnowCmd = "ServiceEvent_SnowCmdSnowManualUpdateSnowCmd"
ServiceEvent.SnowCmdSnowManualEquipUpdateSnowCmd = "ServiceEvent_SnowCmdSnowManualEquipUpdateSnowCmd"
ServiceEvent.SnowCmdSnowManualStoneUpdateSnowCmd = "ServiceEvent_SnowCmdSnowManualStoneUpdateSnowCmd"
ServiceEvent.SnowCmdOperSnowEquipSnowCmd = "ServiceEvent_SnowCmdOperSnowEquipSnowCmd"
ServiceEvent.SnowCmdOperSnowStoneSnowCmd = "ServiceEvent_SnowCmdOperSnowStoneSnowCmd"
