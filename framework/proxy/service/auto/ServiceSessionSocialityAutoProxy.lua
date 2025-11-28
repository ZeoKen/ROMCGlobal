ServiceSessionSocialityAutoProxy = class("ServiceSessionSocialityAutoProxy", ServiceProxy)
ServiceSessionSocialityAutoProxy.Instance = nil
ServiceSessionSocialityAutoProxy.NAME = "ServiceSessionSocialityAutoProxy"

function ServiceSessionSocialityAutoProxy:ctor(proxyName)
  if ServiceSessionSocialityAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionSocialityAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionSocialityAutoProxy.Instance = self
  end
end

function ServiceSessionSocialityAutoProxy:Init()
end

function ServiceSessionSocialityAutoProxy:onRegister()
  self:Listen(56, 1, function(data)
    self:RecvQuerySocialData(data)
  end)
  self:Listen(56, 2, function(data)
    self:RecvFindUser(data)
  end)
  self:Listen(56, 3, function(data)
    self:RecvSocialUpdate(data)
  end)
  self:Listen(56, 4, function(data)
    self:RecvSocialDataUpdate(data)
  end)
  self:Listen(56, 5, function(data)
    self:RecvFrameStatusSocialCmd(data)
  end)
  self:Listen(56, 6, function(data)
    self:RecvUseGiftCodeSocialCmd(data)
  end)
  self:Listen(56, 7, function(data)
    self:RecvOperateQuerySocialCmd(data)
  end)
  self:Listen(56, 8, function(data)
    self:RecvOperateTakeSocialCmd(data)
  end)
  self:Listen(56, 9, function(data)
    self:RecvQueryDataNtfSocialCmd(data)
  end)
  self:Listen(56, 10, function(data)
    self:RecvOperActivityNtfSocialCmd(data)
  end)
  self:Listen(56, 11, function(data)
    self:RecvAddRelation(data)
  end)
  self:Listen(56, 12, function(data)
    self:RecvRemoveRelation(data)
  end)
  self:Listen(56, 13, function(data)
    self:RecvQueryRecallListSocialCmd(data)
  end)
  self:Listen(56, 14, function(data)
    self:RecvRecallFriendSocialCmd(data)
  end)
  self:Listen(56, 15, function(data)
    self:RecvAddRelationResultSocialCmd(data)
  end)
  self:Listen(56, 16, function(data)
    self:RecvQueryChargeVirginCmd(data)
  end)
  self:Listen(56, 17, function(data)
    self:RecvQueryUserInfoCmd(data)
  end)
  self:Listen(56, 18, function(data)
    self:RecvTutorFuncStateNtfSocialCmd(data)
  end)
end

function ServiceSessionSocialityAutoProxy:CallQuerySocialData(datas, over)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.QuerySocialData()
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
    if over ~= nil then
      msg.over = over
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuerySocialData.id
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
    if over ~= nil then
      msgParam.over = over
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallFindUser(keyword, datas)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.FindUser()
    if keyword ~= nil then
      msg.keyword = keyword
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
    local msgId = ProtoReqInfoList.FindUser.id
    local msgParam = {}
    if keyword ~= nil then
      msgParam.keyword = keyword
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

function ServiceSessionSocialityAutoProxy:CallSocialUpdate(updates, dels)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.SocialUpdate()
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
    local msgId = ProtoReqInfoList.SocialUpdate.id
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

function ServiceSessionSocialityAutoProxy:CallSocialDataUpdate(guid, items)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.SocialDataUpdate()
    if guid ~= nil then
      msg.guid = guid
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SocialDataUpdate.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallFrameStatusSocialCmd(open)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.FrameStatusSocialCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FrameStatusSocialCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallUseGiftCodeSocialCmd(code, ret)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.UseGiftCodeSocialCmd()
    if code ~= nil then
      msg.code = code
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseGiftCodeSocialCmd.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallOperateQuerySocialCmd(type, state, param1, param2, param3, param4)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.OperateQuerySocialCmd()
    if type ~= nil then
      msg.type = type
    end
    if state ~= nil then
      msg.state = state
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    if param2 ~= nil then
      msg.param2 = param2
    end
    if param3 ~= nil then
      msg.param3 = param3
    end
    if param4 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.param4 == nil then
        msg.param4 = {}
      end
      for i = 1, #param4 do
        table.insert(msg.param4, param4[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OperateQuerySocialCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if state ~= nil then
      msgParam.state = state
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    if param2 ~= nil then
      msgParam.param2 = param2
    end
    if param3 ~= nil then
      msgParam.param3 = param3
    end
    if param4 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.param4 == nil then
        msgParam.param4 = {}
      end
      for i = 1, #param4 do
        table.insert(msgParam.param4, param4[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallOperateTakeSocialCmd(type, state, subkey)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.OperateTakeSocialCmd()
    if type ~= nil then
      msg.type = type
    end
    if state ~= nil then
      msg.state = state
    end
    if subkey ~= nil then
      msg.subkey = subkey
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OperateTakeSocialCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if state ~= nil then
      msgParam.state = state
    end
    if subkey ~= nil then
      msgParam.subkey = subkey
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallQueryDataNtfSocialCmd(relations)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.QueryDataNtfSocialCmd()
    if relations ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.relations == nil then
        msg.relations = {}
      end
      for i = 1, #relations do
        table.insert(msg.relations, relations[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryDataNtfSocialCmd.id
    local msgParam = {}
    if relations ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.relations == nil then
        msgParam.relations = {}
      end
      for i = 1, #relations do
        table.insert(msgParam.relations, relations[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallOperActivityNtfSocialCmd(activity)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.OperActivityNtfSocialCmd()
    if activity ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.activity == nil then
        msg.activity = {}
      end
      for i = 1, #activity do
        table.insert(msg.activity, activity[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OperActivityNtfSocialCmd.id
    local msgParam = {}
    if activity ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.activity == nil then
        msgParam.activity = {}
      end
      for i = 1, #activity do
        table.insert(msgParam.activity, activity[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallAddRelation(charid, relation)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.AddRelation()
    if charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.charid == nil then
        msg.charid = {}
      end
      for i = 1, #charid do
        table.insert(msg.charid, charid[i])
      end
    end
    if relation ~= nil then
      msg.relation = relation
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddRelation.id
    local msgParam = {}
    if charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.charid == nil then
        msgParam.charid = {}
      end
      for i = 1, #charid do
        table.insert(msgParam.charid, charid[i])
      end
    end
    if relation ~= nil then
      msgParam.relation = relation
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallRemoveRelation(charid, relation)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.RemoveRelation()
    if charid ~= nil then
      msg.charid = charid
    end
    if relation ~= nil then
      msg.relation = relation
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RemoveRelation.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if relation ~= nil then
      msgParam.relation = relation
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallQueryRecallListSocialCmd(items)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.QueryRecallListSocialCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryRecallListSocialCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallRecallFriendSocialCmd(charid)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.RecallFriendSocialCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RecallFriendSocialCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallAddRelationResultSocialCmd(charid, relation, success)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.AddRelationResultSocialCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if relation ~= nil then
      msg.relation = relation
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddRelationResultSocialCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if relation ~= nil then
      msgParam.relation = relation
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallQueryChargeVirginCmd(datas, del)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.QueryChargeVirginCmd()
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
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryChargeVirginCmd.id
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
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallQueryUserInfoCmd(charid, data, profiledata)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.QueryUserInfoCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if data ~= nil and data.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guid = data.guid
    end
    if data ~= nil and data.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.accid = data.accid
    end
    if data ~= nil and data.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guildid = data.guildid
    end
    if data ~= nil and data.mercenary_guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mercenary_guildid = data.mercenary_guildid
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
    if data ~= nil and data.offlinetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.offlinetime = data.offlinetime
    end
    if data ~= nil and data.relation ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.relation = data.relation
    end
    if data ~= nil and data.portrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.portrait = data.portrait
    end
    if data ~= nil and data.frame ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.frame = data.frame
    end
    if data ~= nil and data.hair ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.hair = data.hair
    end
    if data ~= nil and data.haircolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.haircolor = data.haircolor
    end
    if data ~= nil and data.body ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.body = data.body
    end
    if data ~= nil and data.head ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.head = data.head
    end
    if data ~= nil and data.face ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.face = data.face
    end
    if data ~= nil and data.mouth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mouth = data.mouth
    end
    if data ~= nil and data.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.eye = data.eye
    end
    if data ~= nil and data.profic ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.profic = data.profic
    end
    if data ~= nil and data.adventurelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.adventurelv = data.adventurelv
    end
    if data ~= nil and data.adventureexp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.adventureexp = data.adventureexp
    end
    if data ~= nil and data.appellation ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.appellation = data.appellation
    end
    if data ~= nil and data.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mapid = data.mapid
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
    if data ~= nil and data.roomid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.roomid = data.roomid
    end
    if data ~= nil and data.portrait_frame ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.portrait_frame = data.portrait_frame
    end
    if data ~= nil and data.battlepass_lv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.battlepass_lv = data.battlepass_lv
    end
    if data ~= nil and data.battlepass_exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.battlepass_exp = data.battlepass_exp
    end
    if data ~= nil and data.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.serverid = data.serverid
    end
    if data ~= nil and data.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.profession = data.profession
    end
    if data ~= nil and data.gender ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.gender = data.gender
    end
    if data ~= nil and data.blink ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.blink = data.blink
    end
    if data ~= nil and data.recall ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.recall = data.recall
    end
    if data ~= nil and data.canrecall ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.canrecall = data.canrecall
    end
    if data ~= nil and data.waitsign ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.waitsign = data.waitsign
    end
    if data ~= nil and data.afk ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.afk = data.afk
    end
    if data ~= nil and data.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.name = data.name
    end
    if data ~= nil and data.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guildname = data.guildname
    end
    if data ~= nil and data.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guildportrait = data.guildportrait
    end
    if data ~= nil and data.mercenary_guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mercenary_guildname = data.mercenary_guildname
    end
    if data ~= nil and data.mercenary_guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mercenary_guildportrait = data.mercenary_guildportrait
    end
    if data ~= nil and data.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.createtime = data.createtime
    end
    if data ~= nil and data.teamname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.teamname = data.teamname
    end
    if data ~= nil and data.gvglevel ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.gvglevel = data.gvglevel
    end
    if data ~= nil and data.same_zone ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.same_zone = data.same_zone
    end
    if data ~= nil and data.cheat_mark ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.cheat_mark = data.cheat_mark
    end
    if profiledata ~= nil and profiledata.birthmonth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      msg.profiledata.birthmonth = profiledata.birthmonth
    end
    if profiledata ~= nil and profiledata.birthday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      msg.profiledata.birthday = profiledata.birthday
    end
    if profiledata ~= nil and profiledata.needpartner ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      msg.profiledata.needpartner = profiledata.needpartner
    end
    if profiledata ~= nil and profiledata.signtext ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      msg.profiledata.signtext = profiledata.signtext
    end
    if profiledata ~= nil and profiledata.label ~= nil then
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      if msg.profiledata.label == nil then
        msg.profiledata.label = {}
      end
      for i = 1, #profiledata.label do
        table.insert(msg.profiledata.label, profiledata.label[i])
      end
    end
    if profiledata ~= nil and profiledata.unlocklabels ~= nil then
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      if msg.profiledata.unlocklabels == nil then
        msg.profiledata.unlocklabels = {}
      end
      for i = 1, #profiledata.unlocklabels do
        table.insert(msg.profiledata.unlocklabels, profiledata.unlocklabels[i])
      end
    end
    if profiledata ~= nil and profiledata.birthupdatetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      msg.profiledata.birthupdatetime = profiledata.birthupdatetime
    end
    if profiledata ~= nil and profiledata.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.profiledata == nil then
        msg.profiledata = {}
      end
      msg.profiledata.version = profiledata.version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserInfoCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if data ~= nil and data.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guid = data.guid
    end
    if data ~= nil and data.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.accid = data.accid
    end
    if data ~= nil and data.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guildid = data.guildid
    end
    if data ~= nil and data.mercenary_guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mercenary_guildid = data.mercenary_guildid
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
    if data ~= nil and data.offlinetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.offlinetime = data.offlinetime
    end
    if data ~= nil and data.relation ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.relation = data.relation
    end
    if data ~= nil and data.portrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.portrait = data.portrait
    end
    if data ~= nil and data.frame ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.frame = data.frame
    end
    if data ~= nil and data.hair ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.hair = data.hair
    end
    if data ~= nil and data.haircolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.haircolor = data.haircolor
    end
    if data ~= nil and data.body ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.body = data.body
    end
    if data ~= nil and data.head ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.head = data.head
    end
    if data ~= nil and data.face ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.face = data.face
    end
    if data ~= nil and data.mouth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mouth = data.mouth
    end
    if data ~= nil and data.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.eye = data.eye
    end
    if data ~= nil and data.profic ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.profic = data.profic
    end
    if data ~= nil and data.adventurelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.adventurelv = data.adventurelv
    end
    if data ~= nil and data.adventureexp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.adventureexp = data.adventureexp
    end
    if data ~= nil and data.appellation ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.appellation = data.appellation
    end
    if data ~= nil and data.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mapid = data.mapid
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
    if data ~= nil and data.roomid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.roomid = data.roomid
    end
    if data ~= nil and data.portrait_frame ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.portrait_frame = data.portrait_frame
    end
    if data ~= nil and data.battlepass_lv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.battlepass_lv = data.battlepass_lv
    end
    if data ~= nil and data.battlepass_exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.battlepass_exp = data.battlepass_exp
    end
    if data ~= nil and data.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.serverid = data.serverid
    end
    if data ~= nil and data.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.profession = data.profession
    end
    if data ~= nil and data.gender ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.gender = data.gender
    end
    if data ~= nil and data.blink ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.blink = data.blink
    end
    if data ~= nil and data.recall ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.recall = data.recall
    end
    if data ~= nil and data.canrecall ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.canrecall = data.canrecall
    end
    if data ~= nil and data.waitsign ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.waitsign = data.waitsign
    end
    if data ~= nil and data.afk ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.afk = data.afk
    end
    if data ~= nil and data.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.name = data.name
    end
    if data ~= nil and data.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guildname = data.guildname
    end
    if data ~= nil and data.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guildportrait = data.guildportrait
    end
    if data ~= nil and data.mercenary_guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mercenary_guildname = data.mercenary_guildname
    end
    if data ~= nil and data.mercenary_guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mercenary_guildportrait = data.mercenary_guildportrait
    end
    if data ~= nil and data.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.createtime = data.createtime
    end
    if data ~= nil and data.teamname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.teamname = data.teamname
    end
    if data ~= nil and data.gvglevel ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.gvglevel = data.gvglevel
    end
    if data ~= nil and data.same_zone ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.same_zone = data.same_zone
    end
    if data ~= nil and data.cheat_mark ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.cheat_mark = data.cheat_mark
    end
    if profiledata ~= nil and profiledata.birthmonth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      msgParam.profiledata.birthmonth = profiledata.birthmonth
    end
    if profiledata ~= nil and profiledata.birthday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      msgParam.profiledata.birthday = profiledata.birthday
    end
    if profiledata ~= nil and profiledata.needpartner ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      msgParam.profiledata.needpartner = profiledata.needpartner
    end
    if profiledata ~= nil and profiledata.signtext ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      msgParam.profiledata.signtext = profiledata.signtext
    end
    if profiledata ~= nil and profiledata.label ~= nil then
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      if msgParam.profiledata.label == nil then
        msgParam.profiledata.label = {}
      end
      for i = 1, #profiledata.label do
        table.insert(msgParam.profiledata.label, profiledata.label[i])
      end
    end
    if profiledata ~= nil and profiledata.unlocklabels ~= nil then
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      if msgParam.profiledata.unlocklabels == nil then
        msgParam.profiledata.unlocklabels = {}
      end
      for i = 1, #profiledata.unlocklabels do
        table.insert(msgParam.profiledata.unlocklabels, profiledata.unlocklabels[i])
      end
    end
    if profiledata ~= nil and profiledata.birthupdatetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      msgParam.profiledata.birthupdatetime = profiledata.birthupdatetime
    end
    if profiledata ~= nil and profiledata.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.profiledata == nil then
        msgParam.profiledata = {}
      end
      msgParam.profiledata.version = profiledata.version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:CallTutorFuncStateNtfSocialCmd(open)
  if not NetConfig.PBC then
    local msg = SessionSociality_pb.TutorFuncStateNtfSocialCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TutorFuncStateNtfSocialCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSessionSocialityAutoProxy:RecvQuerySocialData(data)
  self:Notify(ServiceEvent.SessionSocialityQuerySocialData, data)
end

function ServiceSessionSocialityAutoProxy:RecvFindUser(data)
  self:Notify(ServiceEvent.SessionSocialityFindUser, data)
end

function ServiceSessionSocialityAutoProxy:RecvSocialUpdate(data)
  self:Notify(ServiceEvent.SessionSocialitySocialUpdate, data)
end

function ServiceSessionSocialityAutoProxy:RecvSocialDataUpdate(data)
  self:Notify(ServiceEvent.SessionSocialitySocialDataUpdate, data)
end

function ServiceSessionSocialityAutoProxy:RecvFrameStatusSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityFrameStatusSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvUseGiftCodeSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityUseGiftCodeSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvOperateQuerySocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityOperateQuerySocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvOperateTakeSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityOperateTakeSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryDataNtfSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityQueryDataNtfSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvOperActivityNtfSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityOperActivityNtfSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvAddRelation(data)
  self:Notify(ServiceEvent.SessionSocialityAddRelation, data)
end

function ServiceSessionSocialityAutoProxy:RecvRemoveRelation(data)
  self:Notify(ServiceEvent.SessionSocialityRemoveRelation, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryRecallListSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityQueryRecallListSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvRecallFriendSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityRecallFriendSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvAddRelationResultSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityAddRelationResultSocialCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryChargeVirginCmd(data)
  self:Notify(ServiceEvent.SessionSocialityQueryChargeVirginCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvQueryUserInfoCmd(data)
  self:Notify(ServiceEvent.SessionSocialityQueryUserInfoCmd, data)
end

function ServiceSessionSocialityAutoProxy:RecvTutorFuncStateNtfSocialCmd(data)
  self:Notify(ServiceEvent.SessionSocialityTutorFuncStateNtfSocialCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SessionSocialityQuerySocialData = "ServiceEvent_SessionSocialityQuerySocialData"
ServiceEvent.SessionSocialityFindUser = "ServiceEvent_SessionSocialityFindUser"
ServiceEvent.SessionSocialitySocialUpdate = "ServiceEvent_SessionSocialitySocialUpdate"
ServiceEvent.SessionSocialitySocialDataUpdate = "ServiceEvent_SessionSocialitySocialDataUpdate"
ServiceEvent.SessionSocialityFrameStatusSocialCmd = "ServiceEvent_SessionSocialityFrameStatusSocialCmd"
ServiceEvent.SessionSocialityUseGiftCodeSocialCmd = "ServiceEvent_SessionSocialityUseGiftCodeSocialCmd"
ServiceEvent.SessionSocialityOperateQuerySocialCmd = "ServiceEvent_SessionSocialityOperateQuerySocialCmd"
ServiceEvent.SessionSocialityOperateTakeSocialCmd = "ServiceEvent_SessionSocialityOperateTakeSocialCmd"
ServiceEvent.SessionSocialityQueryDataNtfSocialCmd = "ServiceEvent_SessionSocialityQueryDataNtfSocialCmd"
ServiceEvent.SessionSocialityOperActivityNtfSocialCmd = "ServiceEvent_SessionSocialityOperActivityNtfSocialCmd"
ServiceEvent.SessionSocialityAddRelation = "ServiceEvent_SessionSocialityAddRelation"
ServiceEvent.SessionSocialityRemoveRelation = "ServiceEvent_SessionSocialityRemoveRelation"
ServiceEvent.SessionSocialityQueryRecallListSocialCmd = "ServiceEvent_SessionSocialityQueryRecallListSocialCmd"
ServiceEvent.SessionSocialityRecallFriendSocialCmd = "ServiceEvent_SessionSocialityRecallFriendSocialCmd"
ServiceEvent.SessionSocialityAddRelationResultSocialCmd = "ServiceEvent_SessionSocialityAddRelationResultSocialCmd"
ServiceEvent.SessionSocialityQueryChargeVirginCmd = "ServiceEvent_SessionSocialityQueryChargeVirginCmd"
ServiceEvent.SessionSocialityQueryUserInfoCmd = "ServiceEvent_SessionSocialityQueryUserInfoCmd"
ServiceEvent.SessionSocialityTutorFuncStateNtfSocialCmd = "ServiceEvent_SessionSocialityTutorFuncStateNtfSocialCmd"
