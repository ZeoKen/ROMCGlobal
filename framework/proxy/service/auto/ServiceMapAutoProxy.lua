ServiceMapAutoProxy = class("ServiceMapAutoProxy", ServiceProxy)
ServiceMapAutoProxy.Instance = nil
ServiceMapAutoProxy.NAME = "ServiceMapAutoProxy"

function ServiceMapAutoProxy:ctor(proxyName)
  if ServiceMapAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMapAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMapAutoProxy.Instance = self
  end
end

function ServiceMapAutoProxy:Init()
end

function ServiceMapAutoProxy:onRegister()
  self:Listen(12, 1, function(data)
    self:RecvAddMapItem(data)
  end)
  self:Listen(12, 2, function(data)
    self:RecvPickupItem(data)
  end)
  self:Listen(12, 34, function(data)
    self:RecvSyncGemSecretLandNineData(data)
  end)
  self:Listen(12, 3, function(data)
    self:RecvAddMapUser(data)
  end)
  self:Listen(12, 4, function(data)
    self:RecvAddMapNpc(data)
  end)
  self:Listen(12, 5, function(data)
    self:RecvAddMapTrap(data)
  end)
  self:Listen(12, 6, function(data)
    self:RecvAddMapAct(data)
  end)
  self:Listen(12, 7, function(data)
    self:RecvExitPointState(data)
  end)
  self:Listen(12, 8, function(data)
    self:RecvMapCmdEnd(data)
  end)
  self:Listen(12, 9, function(data)
    self:RecvNpcSearchRangeCmd(data)
  end)
  self:Listen(12, 10, function(data)
    self:RecvUserHandsCmd(data)
  end)
  self:Listen(12, 11, function(data)
    self:RecvSpEffectCmd(data)
  end)
  self:Listen(12, 12, function(data)
    self:RecvUserHandNpcCmd(data)
  end)
  self:Listen(12, 13, function(data)
    self:RecvGingerBreadNpcCmd(data)
  end)
  self:Listen(12, 14, function(data)
    self:RecvGoCityGateMapCmd(data)
  end)
  self:Listen(12, 16, function(data)
    self:RecvUserSecretQueryMapCmd(data)
  end)
  self:Listen(12, 17, function(data)
    self:RecvUserSecretGetMapCmd(data)
  end)
  self:Listen(12, 15, function(data)
    self:RecvEditNpcTextMapCmd(data)
  end)
  self:Listen(12, 18, function(data)
    self:RecvObjStateSyncMapCmd(data)
  end)
  self:Listen(12, 19, function(data)
    self:RecvAddMapObjNpc(data)
  end)
  self:Listen(209, 20, function(data)
    self:RecvTeamFollowBanListCmd(data)
  end)
  self:Listen(12, 22, function(data)
    self:RecvFuncBuildNpcSyncCmd(data)
  end)
  self:Listen(12, 22, function(data)
    self:RecvFuncBuildNpcUpdateCmd(data)
  end)
  self:Listen(12, 23, function(data)
    self:RecvQueryCloneMapStatusMapCmd(data)
  end)
  self:Listen(12, 24, function(data)
    self:RecvChangeCloneMapCmd(data)
  end)
  self:Listen(12, 25, function(data)
    self:RecvStormBossAffixQueryCmd(data)
  end)
  self:Listen(12, 26, function(data)
    self:RecvBuffRewardQueryCmd(data)
  end)
  self:Listen(12, 27, function(data)
    self:RecvBuffRewardSelectCmd(data)
  end)
  self:Listen(12, 28, function(data)
    self:RecvMultiObjStateSyncMapCmd(data)
  end)
  self:Listen(12, 29, function(data)
    self:RecvUpdateZoneMapCmd(data)
  end)
  self:Listen(12, 30, function(data)
    self:RecvDropItem(data)
  end)
  self:Listen(12, 32, function(data)
    self:RecvMapNpcShowMapCmd(data)
  end)
  self:Listen(12, 33, function(data)
    self:RecvMapNpcDelMapCmd(data)
  end)
  self:Listen(12, 31, function(data)
    self:RecvNpcPreloadForbidMapCmd(data)
  end)
  self:Listen(12, 35, function(data)
    self:RecvCardRewardQueryCmd(data)
  end)
  self:Listen(12, 36, function(data)
    self:RecvSkillWeatherSyncCmd(data)
  end)
  self:Listen(12, 37, function(data)
    self:RecvAbyssAreaChangeNotifyCmd(data)
  end)
  self:Listen(12, 38, function(data)
    self:RecvAbyssBossUpdateCmd(data)
  end)
  self:Listen(12, 39, function(data)
    self:RecvExtraRewardUpdateMapCmd(data)
  end)
end

function ServiceMapAutoProxy:CallAddMapItem(items)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AddMapItem()
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
    local msgId = ProtoReqInfoList.AddMapItem.id
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

function ServiceMapAutoProxy:CallPickupItem(playerguid, itemguid, success)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.PickupItem()
    if playerguid ~= nil then
      msg.playerguid = playerguid
    end
    if itemguid ~= nil then
      msg.itemguid = itemguid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PickupItem.id
    local msgParam = {}
    if playerguid ~= nil then
      msgParam.playerguid = playerguid
    end
    if itemguid ~= nil then
      msgParam.itemguid = itemguid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallSyncGemSecretLandNineData(charid, secret_land_gem)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.SyncGemSecretLandNineData()
    if charid ~= nil then
      msg.charid = charid
    end
    if secret_land_gem ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.secret_land_gem == nil then
        msg.secret_land_gem = {}
      end
      for i = 1, #secret_land_gem do
        table.insert(msg.secret_land_gem, secret_land_gem[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncGemSecretLandNineData.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if secret_land_gem ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.secret_land_gem == nil then
        msgParam.secret_land_gem = {}
      end
      for i = 1, #secret_land_gem do
        table.insert(msgParam.secret_land_gem, secret_land_gem[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAddMapUser(users)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AddMapUser()
    if users ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.users == nil then
        msg.users = {}
      end
      for i = 1, #users do
        table.insert(msg.users, users[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMapUser.id
    local msgParam = {}
    if users ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.users == nil then
        msgParam.users = {}
      end
      for i = 1, #users do
        table.insert(msgParam.users, users[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAddMapNpc(npcs)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AddMapNpc()
    if npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcs == nil then
        msg.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msg.npcs, npcs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMapNpc.id
    local msgParam = {}
    if npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcs == nil then
        msgParam.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msgParam.npcs, npcs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAddMapTrap(traps)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AddMapTrap()
    if traps ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.traps == nil then
        msg.traps = {}
      end
      for i = 1, #traps do
        table.insert(msg.traps, traps[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMapTrap.id
    local msgParam = {}
    if traps ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.traps == nil then
        msgParam.traps = {}
      end
      for i = 1, #traps do
        table.insert(msgParam.traps, traps[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAddMapAct(acts)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AddMapAct()
    if acts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.acts == nil then
        msg.acts = {}
      end
      for i = 1, #acts do
        table.insert(msg.acts, acts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMapAct.id
    local msgParam = {}
    if acts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.acts == nil then
        msgParam.acts = {}
      end
      for i = 1, #acts do
        table.insert(msgParam.acts, acts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallExitPointState(exitid, visible)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.ExitPointState()
    if exitid ~= nil then
      msg.exitid = exitid
    end
    if visible ~= nil then
      msg.visible = visible
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitPointState.id
    local msgParam = {}
    if exitid ~= nil then
      msgParam.exitid = exitid
    end
    if visible ~= nil then
      msgParam.visible = visible
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallMapCmdEnd(mapID)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.MapCmdEnd()
    if mapID ~= nil then
      msg.mapID = mapID
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapCmdEnd.id
    local msgParam = {}
    if mapID ~= nil then
      msgParam.mapID = mapID
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallNpcSearchRangeCmd(id, range)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.NpcSearchRangeCmd()
    if id ~= nil then
      msg.id = id
    end
    if range ~= nil then
      msg.range = range
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcSearchRangeCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if range ~= nil then
      msgParam.range = range
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallUserHandsCmd(player1, player2, isadd)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.UserHandsCmd()
    if player1 ~= nil then
      msg.player1 = player1
    end
    if player2 ~= nil then
      msg.player2 = player2
    end
    if isadd ~= nil then
      msg.isadd = isadd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserHandsCmd.id
    local msgParam = {}
    if player1 ~= nil then
      msgParam.player1 = player1
    end
    if player2 ~= nil then
      msgParam.player2 = player2
    end
    if isadd ~= nil then
      msgParam.isadd = isadd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallSpEffectCmd(senderid, data, isadd)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.SpEffectCmd()
    if senderid ~= nil then
      msg.senderid = senderid
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
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.entity ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.entity == nil then
        msg.data.entity = {}
      end
      for i = 1, #data.entity do
        table.insert(msg.data.entity, data.entity[i])
      end
    end
    if data ~= nil and data.expiretime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.expiretime = data.expiretime
    end
    if data ~= nil and data.freeobj ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.freeobj == nil then
        msg.data.freeobj = {}
      end
      for i = 1, #data.freeobj do
        table.insert(msg.data.freeobj, data.freeobj[i])
      end
    end
    if isadd ~= nil then
      msg.isadd = isadd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SpEffectCmd.id
    local msgParam = {}
    if senderid ~= nil then
      msgParam.senderid = senderid
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
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.entity ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.entity == nil then
        msgParam.data.entity = {}
      end
      for i = 1, #data.entity do
        table.insert(msgParam.data.entity, data.entity[i])
      end
    end
    if data ~= nil and data.expiretime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.expiretime = data.expiretime
    end
    if data ~= nil and data.freeobj ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.freeobj == nil then
        msgParam.data.freeobj = {}
      end
      for i = 1, #data.freeobj do
        table.insert(msgParam.data.freeobj, data.freeobj[i])
      end
    end
    if isadd ~= nil then
      msgParam.isadd = isadd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallUserHandNpcCmd(data, ishand, userid)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.UserHandNpcCmd()
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
    if data ~= nil and data.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guid = data.guid
    end
    if data ~= nil and data.speffect ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.speffect = data.speffect
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
    if data ~= nil and data.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.eye = data.eye
    end
    if data ~= nil and data.unique ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.unique = data.unique
    end
    if data ~= nil and data.normaldialogs ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.normaldialogs == nil then
        msg.data.normaldialogs = {}
      end
      for i = 1, #data.normaldialogs do
        table.insert(msg.data.normaldialogs, data.normaldialogs[i])
      end
    end
    if data ~= nil and data.disappeareffect ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.disappeareffect = data.disappeareffect
    end
    if data ~= nil and data.effecttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.effecttime = data.effecttime
    end
    if data ~= nil and data.eyecolor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.eyecolor = data.eyecolor
    end
    if data ~= nil and data.righthand ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.righthand = data.righthand
    end
    if data ~= nil and data.lefthand ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.lefthand = data.lefthand
    end
    if data ~= nil and data.wing ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.wing = data.wing
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
    if data ~= nil and data.tail ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.tail = data.tail
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
    if ishand ~= nil then
      msg.ishand = ishand
    end
    if userid ~= nil then
      msg.userid = userid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserHandNpcCmd.id
    local msgParam = {}
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
    if data ~= nil and data.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guid = data.guid
    end
    if data ~= nil and data.speffect ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.speffect = data.speffect
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
    if data ~= nil and data.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.eye = data.eye
    end
    if data ~= nil and data.unique ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.unique = data.unique
    end
    if data ~= nil and data.normaldialogs ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.normaldialogs == nil then
        msgParam.data.normaldialogs = {}
      end
      for i = 1, #data.normaldialogs do
        table.insert(msgParam.data.normaldialogs, data.normaldialogs[i])
      end
    end
    if data ~= nil and data.disappeareffect ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.disappeareffect = data.disappeareffect
    end
    if data ~= nil and data.effecttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.effecttime = data.effecttime
    end
    if data ~= nil and data.eyecolor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.eyecolor = data.eyecolor
    end
    if data ~= nil and data.righthand ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.righthand = data.righthand
    end
    if data ~= nil and data.lefthand ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.lefthand = data.lefthand
    end
    if data ~= nil and data.wing ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.wing = data.wing
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
    if data ~= nil and data.tail ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.tail = data.tail
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
    if ishand ~= nil then
      msgParam.ishand = ishand
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallGingerBreadNpcCmd(data, isadd, userid, bornpos)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.GingerBreadNpcCmd()
    if data ~= nil and data.npcid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.npcid = data.npcid
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
    if data ~= nil and data.giveid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.giveid = data.giveid
    end
    if data ~= nil and data.expiretime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.expiretime = data.expiretime
    end
    if data ~= nil and data.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.type = data.type
    end
    if isadd ~= nil then
      msg.isadd = isadd
    end
    if userid ~= nil then
      msg.userid = userid
    end
    if bornpos ~= nil and bornpos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bornpos == nil then
        msg.bornpos = {}
      end
      msg.bornpos.x = bornpos.x
    end
    if bornpos ~= nil and bornpos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bornpos == nil then
        msg.bornpos = {}
      end
      msg.bornpos.y = bornpos.y
    end
    if bornpos ~= nil and bornpos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bornpos == nil then
        msg.bornpos = {}
      end
      msg.bornpos.z = bornpos.z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GingerBreadNpcCmd.id
    local msgParam = {}
    if data ~= nil and data.npcid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.npcid = data.npcid
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
    if data ~= nil and data.giveid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.giveid = data.giveid
    end
    if data ~= nil and data.expiretime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.expiretime = data.expiretime
    end
    if data ~= nil and data.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.type = data.type
    end
    if isadd ~= nil then
      msgParam.isadd = isadd
    end
    if userid ~= nil then
      msgParam.userid = userid
    end
    if bornpos ~= nil and bornpos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bornpos == nil then
        msgParam.bornpos = {}
      end
      msgParam.bornpos.x = bornpos.x
    end
    if bornpos ~= nil and bornpos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bornpos == nil then
        msgParam.bornpos = {}
      end
      msgParam.bornpos.y = bornpos.y
    end
    if bornpos ~= nil and bornpos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bornpos == nil then
        msgParam.bornpos = {}
      end
      msgParam.bornpos.z = bornpos.z
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallGoCityGateMapCmd(flag)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.GoCityGateMapCmd()
    if flag ~= nil then
      msg.flag = flag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GoCityGateMapCmd.id
    local msgParam = {}
    if flag ~= nil then
      msgParam.flag = flag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallUserSecretQueryMapCmd(ids, day_count)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.UserSecretQueryMapCmd()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    if day_count ~= nil then
      msg.day_count = day_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserSecretQueryMapCmd.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    if day_count ~= nil then
      msgParam.day_count = day_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallUserSecretGetMapCmd(id)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.UserSecretGetMapCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserSecretGetMapCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallEditNpcTextMapCmd(etype, tempid, text)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.EditNpcTextMapCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if tempid ~= nil then
      msg.tempid = tempid
    end
    if text ~= nil then
      msg.text = text
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EditNpcTextMapCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if tempid ~= nil then
      msgParam.tempid = tempid
    end
    if text ~= nil then
      msgParam.text = text
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallObjStateSyncMapCmd(objid, state)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.ObjStateSyncMapCmd()
    if objid ~= nil then
      msg.objid = objid
    end
    if state ~= nil then
      msg.state = state
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ObjStateSyncMapCmd.id
    local msgParam = {}
    if objid ~= nil then
      msgParam.objid = objid
    end
    if state ~= nil then
      msgParam.state = state
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAddMapObjNpc(npcs)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AddMapObjNpc()
    if npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcs == nil then
        msg.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msg.npcs, npcs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMapObjNpc.id
    local msgParam = {}
    if npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcs == nil then
        msgParam.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msgParam.npcs, npcs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallTeamFollowBanListCmd(list, updateflag)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.TeamFollowBanListCmd()
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
    if updateflag ~= nil then
      msg.updateflag = updateflag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TeamFollowBanListCmd.id
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
    if updateflag ~= nil then
      msgParam.updateflag = updateflag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallFuncBuildNpcSyncCmd(data)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.FuncBuildNpcSyncCmd()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FuncBuildNpcSyncCmd.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallFuncBuildNpcUpdateCmd(data, dels)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.FuncBuildNpcUpdateCmd()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
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
    local msgId = ProtoReqInfoList.FuncBuildNpcUpdateCmd.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
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

function ServiceMapAutoProxy:CallQueryCloneMapStatusMapCmd(status)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.QueryCloneMapStatusMapCmd()
    if status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.status == nil then
        msg.status = {}
      end
      for i = 1, #status do
        table.insert(msg.status, status[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryCloneMapStatusMapCmd.id
    local msgParam = {}
    if status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.status == nil then
        msgParam.status = {}
      end
      for i = 1, #status do
        table.insert(msgParam.status, status[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallChangeCloneMapCmd(mapid)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.ChangeCloneMapCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeCloneMapCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallStormBossAffixQueryCmd(affixs, refresh_time)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.StormBossAffixQueryCmd()
    if affixs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.affixs == nil then
        msg.affixs = {}
      end
      for i = 1, #affixs do
        table.insert(msg.affixs, affixs[i])
      end
    end
    if refresh_time ~= nil then
      msg.refresh_time = refresh_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StormBossAffixQueryCmd.id
    local msgParam = {}
    if affixs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.affixs == nil then
        msgParam.affixs = {}
      end
      for i = 1, #affixs do
        table.insert(msgParam.affixs, affixs[i])
      end
    end
    if refresh_time ~= nil then
      msgParam.refresh_time = refresh_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallBuffRewardQueryCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.BuffRewardQueryCmd()
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
    local msgId = ProtoReqInfoList.BuffRewardQueryCmd.id
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

function ServiceMapAutoProxy:CallBuffRewardSelectCmd(buffs, end_time, select, dialog, npc_guid)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.BuffRewardSelectCmd()
    if buffs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.buffs == nil then
        msg.buffs = {}
      end
      for i = 1, #buffs do
        table.insert(msg.buffs, buffs[i])
      end
    end
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if select ~= nil then
      msg.select = select
    end
    if dialog ~= nil then
      msg.dialog = dialog
    end
    if npc_guid ~= nil then
      msg.npc_guid = npc_guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuffRewardSelectCmd.id
    local msgParam = {}
    if buffs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.buffs == nil then
        msgParam.buffs = {}
      end
      for i = 1, #buffs do
        table.insert(msgParam.buffs, buffs[i])
      end
    end
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if select ~= nil then
      msgParam.select = select
    end
    if dialog ~= nil then
      msgParam.dialog = dialog
    end
    if npc_guid ~= nil then
      msgParam.npc_guid = npc_guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallMultiObjStateSyncMapCmd(obj_states)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.MultiObjStateSyncMapCmd()
    if obj_states ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.obj_states == nil then
        msg.obj_states = {}
      end
      for i = 1, #obj_states do
        table.insert(msg.obj_states, obj_states[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MultiObjStateSyncMapCmd.id
    local msgParam = {}
    if obj_states ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.obj_states == nil then
        msgParam.obj_states = {}
      end
      for i = 1, #obj_states do
        table.insert(msgParam.obj_states, obj_states[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallUpdateZoneMapCmd(zones, del_zones)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.UpdateZoneMapCmd()
    if zones ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.zones == nil then
        msg.zones = {}
      end
      for i = 1, #zones do
        table.insert(msg.zones, zones[i])
      end
    end
    if del_zones ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_zones == nil then
        msg.del_zones = {}
      end
      for i = 1, #del_zones do
        table.insert(msg.del_zones, del_zones[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateZoneMapCmd.id
    local msgParam = {}
    if zones ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.zones == nil then
        msgParam.zones = {}
      end
      for i = 1, #zones do
        table.insert(msgParam.zones, zones[i])
      end
    end
    if del_zones ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_zones == nil then
        msgParam.del_zones = {}
      end
      for i = 1, #del_zones do
        table.insert(msgParam.del_zones, del_zones[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallDropItem(npcguid, itemid, droppos)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.DropItem()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if droppos ~= nil and droppos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.droppos == nil then
        msg.droppos = {}
      end
      msg.droppos.x = droppos.x
    end
    if droppos ~= nil and droppos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.droppos == nil then
        msg.droppos = {}
      end
      msg.droppos.y = droppos.y
    end
    if droppos ~= nil and droppos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.droppos == nil then
        msg.droppos = {}
      end
      msg.droppos.z = droppos.z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DropItem.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if droppos ~= nil and droppos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.droppos == nil then
        msgParam.droppos = {}
      end
      msgParam.droppos.x = droppos.x
    end
    if droppos ~= nil and droppos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.droppos == nil then
        msgParam.droppos = {}
      end
      msgParam.droppos.y = droppos.y
    end
    if droppos ~= nil and droppos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.droppos == nil then
        msgParam.droppos = {}
      end
      msgParam.droppos.z = droppos.z
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallMapNpcShowMapCmd(npcs)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.MapNpcShowMapCmd()
    if npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcs == nil then
        msg.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msg.npcs, npcs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapNpcShowMapCmd.id
    local msgParam = {}
    if npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcs == nil then
        msgParam.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msgParam.npcs, npcs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallMapNpcDelMapCmd(npcs, invalid_guid_npcs)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.MapNpcDelMapCmd()
    if npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcs == nil then
        msg.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msg.npcs, npcs[i])
      end
    end
    if invalid_guid_npcs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.invalid_guid_npcs == nil then
        msg.invalid_guid_npcs = {}
      end
      for i = 1, #invalid_guid_npcs do
        table.insert(msg.invalid_guid_npcs, invalid_guid_npcs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapNpcDelMapCmd.id
    local msgParam = {}
    if npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcs == nil then
        msgParam.npcs = {}
      end
      for i = 1, #npcs do
        table.insert(msgParam.npcs, npcs[i])
      end
    end
    if invalid_guid_npcs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.invalid_guid_npcs == nil then
        msgParam.invalid_guid_npcs = {}
      end
      for i = 1, #invalid_guid_npcs do
        table.insert(msgParam.invalid_guid_npcs, invalid_guid_npcs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallNpcPreloadForbidMapCmd(data)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.NpcPreloadForbidMapCmd()
    if data ~= nil and data.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mapid = data.mapid
    end
    if data ~= nil and data.uniqueid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.uniqueid == nil then
        msg.data.uniqueid = {}
      end
      for i = 1, #data.uniqueid do
        table.insert(msg.data.uniqueid, data.uniqueid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcPreloadForbidMapCmd.id
    local msgParam = {}
    if data ~= nil and data.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mapid = data.mapid
    end
    if data ~= nil and data.uniqueid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.uniqueid == nil then
        msgParam.data.uniqueid = {}
      end
      for i = 1, #data.uniqueid do
        table.insert(msgParam.data.uniqueid, data.uniqueid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallCardRewardQueryCmd(data)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.CardRewardQueryCmd()
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
    if data ~= nil and data.refresh_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.refresh_time = data.refresh_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CardRewardQueryCmd.id
    local msgParam = {}
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
    if data ~= nil and data.refresh_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.refresh_time = data.refresh_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallSkillWeatherSyncCmd(weather)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.SkillWeatherSyncCmd()
    if weather ~= nil then
      msg.weather = weather
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillWeatherSyncCmd.id
    local msgParam = {}
    if weather ~= nil then
      msgParam.weather = weather
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAbyssAreaChangeNotifyCmd(area)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AbyssAreaChangeNotifyCmd()
    if area ~= nil then
      msg.area = area
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssAreaChangeNotifyCmd.id
    local msgParam = {}
    if area ~= nil then
      msgParam.area = area
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallAbyssBossUpdateCmd(area, boss_infos)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.AbyssBossUpdateCmd()
    if area ~= nil then
      msg.area = area
    end
    if boss_infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.boss_infos == nil then
        msg.boss_infos = {}
      end
      for i = 1, #boss_infos do
        table.insert(msg.boss_infos, boss_infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssBossUpdateCmd.id
    local msgParam = {}
    if area ~= nil then
      msgParam.area = area
    end
    if boss_infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.boss_infos == nil then
        msgParam.boss_infos = {}
      end
      for i = 1, #boss_infos do
        table.insert(msgParam.boss_infos, boss_infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceMapAutoProxy:CallExtraRewardUpdateMapCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneMap_pb.ExtraRewardUpdateMapCmd()
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
    local msgId = ProtoReqInfoList.ExtraRewardUpdateMapCmd.id
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

function ServiceMapAutoProxy:RecvAddMapItem(data)
  self:Notify(ServiceEvent.MapAddMapItem, data)
end

function ServiceMapAutoProxy:RecvPickupItem(data)
  self:Notify(ServiceEvent.MapPickupItem, data)
end

function ServiceMapAutoProxy:RecvSyncGemSecretLandNineData(data)
  self:Notify(ServiceEvent.MapSyncGemSecretLandNineData, data)
end

function ServiceMapAutoProxy:RecvAddMapUser(data)
  self:Notify(ServiceEvent.MapAddMapUser, data)
end

function ServiceMapAutoProxy:RecvAddMapNpc(data)
  self:Notify(ServiceEvent.MapAddMapNpc, data)
end

function ServiceMapAutoProxy:RecvAddMapTrap(data)
  self:Notify(ServiceEvent.MapAddMapTrap, data)
end

function ServiceMapAutoProxy:RecvAddMapAct(data)
  self:Notify(ServiceEvent.MapAddMapAct, data)
end

function ServiceMapAutoProxy:RecvExitPointState(data)
  self:Notify(ServiceEvent.MapExitPointState, data)
end

function ServiceMapAutoProxy:RecvMapCmdEnd(data)
  self:Notify(ServiceEvent.MapMapCmdEnd, data)
end

function ServiceMapAutoProxy:RecvNpcSearchRangeCmd(data)
  self:Notify(ServiceEvent.MapNpcSearchRangeCmd, data)
end

function ServiceMapAutoProxy:RecvUserHandsCmd(data)
  self:Notify(ServiceEvent.MapUserHandsCmd, data)
end

function ServiceMapAutoProxy:RecvSpEffectCmd(data)
  self:Notify(ServiceEvent.MapSpEffectCmd, data)
end

function ServiceMapAutoProxy:RecvUserHandNpcCmd(data)
  self:Notify(ServiceEvent.MapUserHandNpcCmd, data)
end

function ServiceMapAutoProxy:RecvGingerBreadNpcCmd(data)
  self:Notify(ServiceEvent.MapGingerBreadNpcCmd, data)
end

function ServiceMapAutoProxy:RecvGoCityGateMapCmd(data)
  self:Notify(ServiceEvent.MapGoCityGateMapCmd, data)
end

function ServiceMapAutoProxy:RecvUserSecretQueryMapCmd(data)
  self:Notify(ServiceEvent.MapUserSecretQueryMapCmd, data)
end

function ServiceMapAutoProxy:RecvUserSecretGetMapCmd(data)
  self:Notify(ServiceEvent.MapUserSecretGetMapCmd, data)
end

function ServiceMapAutoProxy:RecvEditNpcTextMapCmd(data)
  self:Notify(ServiceEvent.MapEditNpcTextMapCmd, data)
end

function ServiceMapAutoProxy:RecvObjStateSyncMapCmd(data)
  self:Notify(ServiceEvent.MapObjStateSyncMapCmd, data)
end

function ServiceMapAutoProxy:RecvAddMapObjNpc(data)
  self:Notify(ServiceEvent.MapAddMapObjNpc, data)
end

function ServiceMapAutoProxy:RecvTeamFollowBanListCmd(data)
  self:Notify(ServiceEvent.MapTeamFollowBanListCmd, data)
end

function ServiceMapAutoProxy:RecvFuncBuildNpcSyncCmd(data)
  self:Notify(ServiceEvent.MapFuncBuildNpcSyncCmd, data)
end

function ServiceMapAutoProxy:RecvFuncBuildNpcUpdateCmd(data)
  self:Notify(ServiceEvent.MapFuncBuildNpcUpdateCmd, data)
end

function ServiceMapAutoProxy:RecvQueryCloneMapStatusMapCmd(data)
  self:Notify(ServiceEvent.MapQueryCloneMapStatusMapCmd, data)
end

function ServiceMapAutoProxy:RecvChangeCloneMapCmd(data)
  self:Notify(ServiceEvent.MapChangeCloneMapCmd, data)
end

function ServiceMapAutoProxy:RecvStormBossAffixQueryCmd(data)
  self:Notify(ServiceEvent.MapStormBossAffixQueryCmd, data)
end

function ServiceMapAutoProxy:RecvBuffRewardQueryCmd(data)
  self:Notify(ServiceEvent.MapBuffRewardQueryCmd, data)
end

function ServiceMapAutoProxy:RecvBuffRewardSelectCmd(data)
  self:Notify(ServiceEvent.MapBuffRewardSelectCmd, data)
end

function ServiceMapAutoProxy:RecvMultiObjStateSyncMapCmd(data)
  self:Notify(ServiceEvent.MapMultiObjStateSyncMapCmd, data)
end

function ServiceMapAutoProxy:RecvUpdateZoneMapCmd(data)
  self:Notify(ServiceEvent.MapUpdateZoneMapCmd, data)
end

function ServiceMapAutoProxy:RecvDropItem(data)
  self:Notify(ServiceEvent.MapDropItem, data)
end

function ServiceMapAutoProxy:RecvMapNpcShowMapCmd(data)
  self:Notify(ServiceEvent.MapMapNpcShowMapCmd, data)
end

function ServiceMapAutoProxy:RecvMapNpcDelMapCmd(data)
  self:Notify(ServiceEvent.MapMapNpcDelMapCmd, data)
end

function ServiceMapAutoProxy:RecvNpcPreloadForbidMapCmd(data)
  self:Notify(ServiceEvent.MapNpcPreloadForbidMapCmd, data)
end

function ServiceMapAutoProxy:RecvCardRewardQueryCmd(data)
  self:Notify(ServiceEvent.MapCardRewardQueryCmd, data)
end

function ServiceMapAutoProxy:RecvSkillWeatherSyncCmd(data)
  self:Notify(ServiceEvent.MapSkillWeatherSyncCmd, data)
end

function ServiceMapAutoProxy:RecvAbyssAreaChangeNotifyCmd(data)
  self:Notify(ServiceEvent.MapAbyssAreaChangeNotifyCmd, data)
end

function ServiceMapAutoProxy:RecvAbyssBossUpdateCmd(data)
  self:Notify(ServiceEvent.MapAbyssBossUpdateCmd, data)
end

function ServiceMapAutoProxy:RecvExtraRewardUpdateMapCmd(data)
  self:Notify(ServiceEvent.MapExtraRewardUpdateMapCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.MapAddMapItem = "ServiceEvent_MapAddMapItem"
ServiceEvent.MapPickupItem = "ServiceEvent_MapPickupItem"
ServiceEvent.MapSyncGemSecretLandNineData = "ServiceEvent_MapSyncGemSecretLandNineData"
ServiceEvent.MapAddMapUser = "ServiceEvent_MapAddMapUser"
ServiceEvent.MapAddMapNpc = "ServiceEvent_MapAddMapNpc"
ServiceEvent.MapAddMapTrap = "ServiceEvent_MapAddMapTrap"
ServiceEvent.MapAddMapAct = "ServiceEvent_MapAddMapAct"
ServiceEvent.MapExitPointState = "ServiceEvent_MapExitPointState"
ServiceEvent.MapMapCmdEnd = "ServiceEvent_MapMapCmdEnd"
ServiceEvent.MapNpcSearchRangeCmd = "ServiceEvent_MapNpcSearchRangeCmd"
ServiceEvent.MapUserHandsCmd = "ServiceEvent_MapUserHandsCmd"
ServiceEvent.MapSpEffectCmd = "ServiceEvent_MapSpEffectCmd"
ServiceEvent.MapUserHandNpcCmd = "ServiceEvent_MapUserHandNpcCmd"
ServiceEvent.MapGingerBreadNpcCmd = "ServiceEvent_MapGingerBreadNpcCmd"
ServiceEvent.MapGoCityGateMapCmd = "ServiceEvent_MapGoCityGateMapCmd"
ServiceEvent.MapUserSecretQueryMapCmd = "ServiceEvent_MapUserSecretQueryMapCmd"
ServiceEvent.MapUserSecretGetMapCmd = "ServiceEvent_MapUserSecretGetMapCmd"
ServiceEvent.MapEditNpcTextMapCmd = "ServiceEvent_MapEditNpcTextMapCmd"
ServiceEvent.MapObjStateSyncMapCmd = "ServiceEvent_MapObjStateSyncMapCmd"
ServiceEvent.MapAddMapObjNpc = "ServiceEvent_MapAddMapObjNpc"
ServiceEvent.MapTeamFollowBanListCmd = "ServiceEvent_MapTeamFollowBanListCmd"
ServiceEvent.MapFuncBuildNpcSyncCmd = "ServiceEvent_MapFuncBuildNpcSyncCmd"
ServiceEvent.MapFuncBuildNpcUpdateCmd = "ServiceEvent_MapFuncBuildNpcUpdateCmd"
ServiceEvent.MapQueryCloneMapStatusMapCmd = "ServiceEvent_MapQueryCloneMapStatusMapCmd"
ServiceEvent.MapChangeCloneMapCmd = "ServiceEvent_MapChangeCloneMapCmd"
ServiceEvent.MapStormBossAffixQueryCmd = "ServiceEvent_MapStormBossAffixQueryCmd"
ServiceEvent.MapBuffRewardQueryCmd = "ServiceEvent_MapBuffRewardQueryCmd"
ServiceEvent.MapBuffRewardSelectCmd = "ServiceEvent_MapBuffRewardSelectCmd"
ServiceEvent.MapMultiObjStateSyncMapCmd = "ServiceEvent_MapMultiObjStateSyncMapCmd"
ServiceEvent.MapUpdateZoneMapCmd = "ServiceEvent_MapUpdateZoneMapCmd"
ServiceEvent.MapDropItem = "ServiceEvent_MapDropItem"
ServiceEvent.MapMapNpcShowMapCmd = "ServiceEvent_MapMapNpcShowMapCmd"
ServiceEvent.MapMapNpcDelMapCmd = "ServiceEvent_MapMapNpcDelMapCmd"
ServiceEvent.MapNpcPreloadForbidMapCmd = "ServiceEvent_MapNpcPreloadForbidMapCmd"
ServiceEvent.MapCardRewardQueryCmd = "ServiceEvent_MapCardRewardQueryCmd"
ServiceEvent.MapSkillWeatherSyncCmd = "ServiceEvent_MapSkillWeatherSyncCmd"
ServiceEvent.MapAbyssAreaChangeNotifyCmd = "ServiceEvent_MapAbyssAreaChangeNotifyCmd"
ServiceEvent.MapAbyssBossUpdateCmd = "ServiceEvent_MapAbyssBossUpdateCmd"
ServiceEvent.MapExtraRewardUpdateMapCmd = "ServiceEvent_MapExtraRewardUpdateMapCmd"
