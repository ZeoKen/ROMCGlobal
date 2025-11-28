ServiceRaidCmdAutoProxy = class("ServiceRaidCmdAutoProxy", ServiceProxy)
ServiceRaidCmdAutoProxy.Instance = nil
ServiceRaidCmdAutoProxy.NAME = "ServiceRaidCmdAutoProxy"

function ServiceRaidCmdAutoProxy:ctor(proxyName)
  if ServiceRaidCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRaidCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRaidCmdAutoProxy.Instance = self
  end
end

function ServiceRaidCmdAutoProxy:Init()
end

function ServiceRaidCmdAutoProxy:onRegister()
  self:Listen(76, 1, function(data)
    self:RecvQueryRaidPuzzleListRaidCmd(data)
  end)
  self:Listen(76, 2, function(data)
    self:RecvRaidPuzzleActionRaidCmd(data)
  end)
  self:Listen(76, 3, function(data)
    self:RecvRaidPuzzleDataUpdateRaidCmd(data)
  end)
  self:Listen(76, 4, function(data)
    self:RecvRaidPuzzlePushObjRaidCmd(data)
  end)
  self:Listen(76, 5, function(data)
    self:RecvRaidPuzzleRotateObjRaidCmd(data)
  end)
  self:Listen(76, 6, function(data)
    self:RecvRaidPuzzleObjChangeNtfRaidCmd(data)
  end)
  self:Listen(76, 7, function(data)
    self:RecvRaidPuzzleElevatorRaidCmd(data)
  end)
  self:Listen(76, 8, function(data)
    self:RecvRaidPuzzlePosRaidCmd(data)
  end)
  self:Listen(76, 9, function(data)
    self:RecvRaidPuzzleRoomIconRaidCmd(data)
  end)
  self:Listen(76, 10, function(data)
    self:RecvClientSummonCmd(data)
  end)
  self:Listen(76, 10, function(data)
    self:RecvClientNpcDieCmd(data)
  end)
  self:Listen(76, 11, function(data)
    self:RecvClientTreasureBoxCmd(data)
  end)
  self:Listen(76, 12, function(data)
    self:RecvClientSaveCmd(data)
  end)
  self:Listen(76, 13, function(data)
    self:RecvClientSaveResultCmd(data)
  end)
  self:Listen(76, 14, function(data)
    self:RecvClientQueryRaidCmd(data)
  end)
  self:Listen(76, 15, function(data)
    self:RecvPersonalRaidEnterCmd(data)
  end)
  self:Listen(76, 16, function(data)
    self:RecvClientRaidAchRewardCmd(data)
  end)
  self:Listen(76, 17, function(data)
    self:RecvHeadwearActivityNpcUserCmd(data)
  end)
  self:Listen(76, 18, function(data)
    self:RecvHeadwearActivityRoundUserCmd(data)
  end)
  self:Listen(76, 19, function(data)
    self:RecvHeadwearActivityTowerUserCmd(data)
  end)
  self:Listen(76, 24, function(data)
    self:RecvQueryHeadwearActivityRewardRecordCmd(data)
  end)
  self:Listen(76, 20, function(data)
    self:RecvHeadwearActivityEndUserCmd(data)
  end)
  self:Listen(76, 21, function(data)
    self:RecvHeadwearActivityRangeUserCmd(data)
  end)
  self:Listen(76, 22, function(data)
    self:RecvHeadwearActivityOpenUserCmd(data)
  end)
  self:Listen(76, 25, function(data)
    self:RecvRaidOptionalCardCmd(data)
  end)
  self:Listen(76, 26, function(data)
    self:RecvRaidSelectCardResultCmd(data)
  end)
  self:Listen(76, 27, function(data)
    self:RecvRaidSelectCardResultRes(data)
  end)
  self:Listen(76, 28, function(data)
    self:RecvRaidSelectCardHistoryResultCmd(data)
  end)
  self:Listen(76, 29, function(data)
    self:RecvRaidSelectCardResetCmd(data)
  end)
  self:Listen(76, 30, function(data)
    self:RecvRaidNewResetCmd(data)
  end)
  self:Listen(76, 31, function(data)
    self:RecvAbyssDragonInfoNtfRaidCmd(data)
  end)
  self:Listen(76, 32, function(data)
    self:RecvAbyssDragonHpUpdateRaidCmd(data)
  end)
  self:Listen(76, 33, function(data)
    self:RecvAbyssDragonOnOffRaidCmd(data)
  end)
  self:Listen(76, 34, function(data)
    self:RecvAbyssDragonDamageRankRaidCmd(data)
  end)
end

function ServiceRaidCmdAutoProxy:CallQueryRaidPuzzleListRaidCmd(raidid, data)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.QueryRaidPuzzleListRaidCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if data ~= nil and data.raidid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.raidid = data.raidid
    end
    if data ~= nil and data.rewardboxs ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.rewardboxs == nil then
        msg.data.rewardboxs = {}
      end
      for i = 1, #data.rewardboxs do
        table.insert(msg.data.rewardboxs, data.rewardboxs[i])
      end
    end
    if data ~= nil and data.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.status = data.status
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryRaidPuzzleListRaidCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if data ~= nil and data.raidid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.raidid = data.raidid
    end
    if data ~= nil and data.rewardboxs ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.rewardboxs == nil then
        msgParam.data.rewardboxs = {}
      end
      for i = 1, #data.rewardboxs do
        table.insert(msgParam.data.rewardboxs, data.rewardboxs[i])
      end
    end
    if data ~= nil and data.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.status = data.status
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzleActionRaidCmd(action, raidid)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzleActionRaidCmd()
    if action ~= nil then
      msg.action = action
    end
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzleActionRaidCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzleDataUpdateRaidCmd(updates)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzleDataUpdateRaidCmd()
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
    local msgId = ProtoReqInfoList.RaidPuzzleDataUpdateRaidCmd.id
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

function ServiceRaidCmdAutoProxy:CallRaidPuzzlePushObjRaidCmd(objs)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzlePushObjRaidCmd()
    if objs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.objs == nil then
        msg.objs = {}
      end
      for i = 1, #objs do
        table.insert(msg.objs, objs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzlePushObjRaidCmd.id
    local msgParam = {}
    if objs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.objs == nil then
        msgParam.objs = {}
      end
      for i = 1, #objs do
        table.insert(msgParam.objs, objs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzleRotateObjRaidCmd(guid, dir)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzleRotateObjRaidCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if dir ~= nil then
      msg.dir = dir
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzleRotateObjRaidCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if dir ~= nil then
      msgParam.dir = dir
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzleObjChangeNtfRaidCmd(guids)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzleObjChangeNtfRaidCmd()
    if guids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guids == nil then
        msg.guids = {}
      end
      for i = 1, #guids do
        table.insert(msg.guids, guids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzleObjChangeNtfRaidCmd.id
    local msgParam = {}
    if guids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guids == nil then
        msgParam.guids = {}
      end
      for i = 1, #guids do
        table.insert(msgParam.guids, guids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzleElevatorRaidCmd(objid, state, from_index, to_index, posx, posz)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzleElevatorRaidCmd()
    if objid ~= nil then
      msg.objid = objid
    end
    if state ~= nil then
      msg.state = state
    end
    if from_index ~= nil then
      msg.from_index = from_index
    end
    if to_index ~= nil then
      msg.to_index = to_index
    end
    if posx ~= nil then
      msg.posx = posx
    end
    if posz ~= nil then
      msg.posz = posz
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzleElevatorRaidCmd.id
    local msgParam = {}
    if objid ~= nil then
      msgParam.objid = objid
    end
    if state ~= nil then
      msgParam.state = state
    end
    if from_index ~= nil then
      msgParam.from_index = from_index
    end
    if to_index ~= nil then
      msgParam.to_index = to_index
    end
    if posx ~= nil then
      msgParam.posx = posx
    end
    if posz ~= nil then
      msgParam.posz = posz
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzlePosRaidCmd()
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzlePosRaidCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzlePosRaidCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidPuzzleRoomIconRaidCmd(icons)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidPuzzleRoomIconRaidCmd()
    if icons ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.icons == nil then
        msg.icons = {}
      end
      for i = 1, #icons do
        table.insert(msg.icons, icons[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidPuzzleRoomIconRaidCmd.id
    local msgParam = {}
    if icons ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.icons == nil then
        msgParam.icons = {}
      end
      for i = 1, #icons do
        table.insert(msgParam.icons, icons[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientSummonCmd(unique_ids)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientSummonCmd()
    if unique_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unique_ids == nil then
        msg.unique_ids = {}
      end
      for i = 1, #unique_ids do
        table.insert(msg.unique_ids, unique_ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientSummonCmd.id
    local msgParam = {}
    if unique_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unique_ids == nil then
        msgParam.unique_ids = {}
      end
      for i = 1, #unique_ids do
        table.insert(msgParam.unique_ids, unique_ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientNpcDieCmd(unique_id)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientNpcDieCmd()
    if unique_id ~= nil then
      msg.unique_id = unique_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientNpcDieCmd.id
    local msgParam = {}
    if unique_id ~= nil then
      msgParam.unique_id = unique_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientTreasureBoxCmd(raidid, treasure_box_id, result)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientTreasureBoxCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if treasure_box_id ~= nil then
      msg.treasure_box_id = treasure_box_id
    end
    if result ~= nil then
      msg.result = result
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientTreasureBoxCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if treasure_box_id ~= nil then
      msgParam.treasure_box_id = treasure_box_id
    end
    if result ~= nil then
      msgParam.result = result
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientSaveCmd(raidid, record_tag, data, achievement_datas)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientSaveCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if record_tag ~= nil then
      msg.record_tag = record_tag
    end
    if data ~= nil then
      msg.data = data
    end
    if achievement_datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.achievement_datas == nil then
        msg.achievement_datas = {}
      end
      for i = 1, #achievement_datas do
        table.insert(msg.achievement_datas, achievement_datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientSaveCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if record_tag ~= nil then
      msgParam.record_tag = record_tag
    end
    if data ~= nil then
      msgParam.data = data
    end
    if achievement_datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.achievement_datas == nil then
        msgParam.achievement_datas = {}
      end
      for i = 1, #achievement_datas do
        table.insert(msgParam.achievement_datas, achievement_datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientSaveResultCmd(raidid, record_tag, success)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientSaveResultCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if record_tag ~= nil then
      msg.record_tag = record_tag
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientSaveResultCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if record_tag ~= nil then
      msgParam.record_tag = record_tag
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientQueryRaidCmd(raidid, complete_info, achievement_datas, treasure_boxs, rewarded_point, process_data)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientQueryRaidCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if complete_info ~= nil then
      msg.complete_info = complete_info
    end
    if achievement_datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.achievement_datas == nil then
        msg.achievement_datas = {}
      end
      for i = 1, #achievement_datas do
        table.insert(msg.achievement_datas, achievement_datas[i])
      end
    end
    if treasure_boxs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.treasure_boxs == nil then
        msg.treasure_boxs = {}
      end
      for i = 1, #treasure_boxs do
        table.insert(msg.treasure_boxs, treasure_boxs[i])
      end
    end
    if rewarded_point ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewarded_point == nil then
        msg.rewarded_point = {}
      end
      for i = 1, #rewarded_point do
        table.insert(msg.rewarded_point, rewarded_point[i])
      end
    end
    if process_data ~= nil then
      msg.process_data = process_data
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientQueryRaidCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if complete_info ~= nil then
      msgParam.complete_info = complete_info
    end
    if achievement_datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.achievement_datas == nil then
        msgParam.achievement_datas = {}
      end
      for i = 1, #achievement_datas do
        table.insert(msgParam.achievement_datas, achievement_datas[i])
      end
    end
    if treasure_boxs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.treasure_boxs == nil then
        msgParam.treasure_boxs = {}
      end
      for i = 1, #treasure_boxs do
        table.insert(msgParam.treasure_boxs, treasure_boxs[i])
      end
    end
    if rewarded_point ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewarded_point == nil then
        msgParam.rewarded_point = {}
      end
      for i = 1, #rewarded_point do
        table.insert(msgParam.rewarded_point, rewarded_point[i])
      end
    end
    if process_data ~= nil then
      msgParam.process_data = process_data
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallPersonalRaidEnterCmd(raidid)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.PersonalRaidEnterCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalRaidEnterCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallClientRaidAchRewardCmd(raidid, point, success)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.ClientRaidAchRewardCmd()
    if raidid ~= nil then
      msg.raidid = raidid
    end
    if point ~= nil then
      msg.point = point
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientRaidAchRewardCmd.id
    local msgParam = {}
    if raidid ~= nil then
      msgParam.raidid = raidid
    end
    if point ~= nil then
      msgParam.point = point
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallHeadwearActivityNpcUserCmd(npcs)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.HeadwearActivityNpcUserCmd()
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
    local msgId = ProtoReqInfoList.HeadwearActivityNpcUserCmd.id
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

function ServiceRaidCmdAutoProxy:CallHeadwearActivityRoundUserCmd(round, blood, skiptime, furytime, crystals, skills)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.HeadwearActivityRoundUserCmd()
    if round ~= nil then
      msg.round = round
    end
    if blood ~= nil then
      msg.blood = blood
    end
    if skiptime ~= nil then
      msg.skiptime = skiptime
    end
    if furytime ~= nil then
      msg.furytime = furytime
    end
    if crystals ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.crystals == nil then
        msg.crystals = {}
      end
      for i = 1, #crystals do
        table.insert(msg.crystals, crystals[i])
      end
    end
    if skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skills == nil then
        msg.skills = {}
      end
      for i = 1, #skills do
        table.insert(msg.skills, skills[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearActivityRoundUserCmd.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if blood ~= nil then
      msgParam.blood = blood
    end
    if skiptime ~= nil then
      msgParam.skiptime = skiptime
    end
    if furytime ~= nil then
      msgParam.furytime = furytime
    end
    if crystals ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.crystals == nil then
        msgParam.crystals = {}
      end
      for i = 1, #crystals do
        table.insert(msgParam.crystals, crystals[i])
      end
    end
    if skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skills == nil then
        msgParam.skills = {}
      end
      for i = 1, #skills do
        table.insert(msgParam.skills, skills[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallHeadwearActivityTowerUserCmd(npcid, level, crystals)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.HeadwearActivityTowerUserCmd()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if level ~= nil then
      msg.level = level
    end
    if crystals ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.crystals == nil then
        msg.crystals = {}
      end
      for i = 1, #crystals do
        table.insert(msg.crystals, crystals[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearActivityTowerUserCmd.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if level ~= nil then
      msgParam.level = level
    end
    if crystals ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.crystals == nil then
        msgParam.crystals = {}
      end
      for i = 1, #crystals do
        table.insert(msgParam.crystals, crystals[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallQueryHeadwearActivityRewardRecordCmd(charid, records)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.QueryHeadwearActivityRewardRecordCmd()
    if charid ~= nil then
      msg.charid = charid
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
    local msgId = ProtoReqInfoList.QueryHeadwearActivityRewardRecordCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
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

function ServiceRaidCmdAutoProxy:CallHeadwearActivityEndUserCmd(round, coldtime, items, type, win, minRewardRound)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.HeadwearActivityEndUserCmd()
    if round ~= nil then
      msg.round = round
    end
    if coldtime ~= nil then
      msg.coldtime = coldtime
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
    if type ~= nil then
      msg.type = type
    end
    if win ~= nil then
      msg.win = win
    end
    if minRewardRound ~= nil then
      msg.minRewardRound = minRewardRound
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearActivityEndUserCmd.id
    local msgParam = {}
    if round ~= nil then
      msgParam.round = round
    end
    if coldtime ~= nil then
      msgParam.coldtime = coldtime
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
    if type ~= nil then
      msgParam.type = type
    end
    if win ~= nil then
      msgParam.win = win
    end
    if minRewardRound ~= nil then
      msgParam.minRewardRound = minRewardRound
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallHeadwearActivityRangeUserCmd(tower, raidtype)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.HeadwearActivityRangeUserCmd()
    if tower ~= nil then
      msg.tower = tower
    end
    if raidtype ~= nil then
      msg.raidtype = raidtype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearActivityRangeUserCmd.id
    local msgParam = {}
    if tower ~= nil then
      msgParam.tower = tower
    end
    if raidtype ~= nil then
      msgParam.raidtype = raidtype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallHeadwearActivityOpenUserCmd()
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.HeadwearActivityOpenUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeadwearActivityOpenUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidOptionalCardCmd(endtime, recommend_ids, cardids)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidOptionalCardCmd()
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if recommend_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.recommend_ids == nil then
        msg.recommend_ids = {}
      end
      for i = 1, #recommend_ids do
        table.insert(msg.recommend_ids, recommend_ids[i])
      end
    end
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
    local msgId = ProtoReqInfoList.RaidOptionalCardCmd.id
    local msgParam = {}
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if recommend_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.recommend_ids == nil then
        msgParam.recommend_ids = {}
      end
      for i = 1, #recommend_ids do
        table.insert(msgParam.recommend_ids, recommend_ids[i])
      end
    end
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

function ServiceRaidCmdAutoProxy:CallRaidSelectCardResultCmd(charid, resultid)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidSelectCardResultCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if resultid ~= nil then
      msg.resultid = resultid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidSelectCardResultCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if resultid ~= nil then
      msgParam.resultid = resultid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidSelectCardResultRes(resultid)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidSelectCardResultRes()
    if resultid ~= nil then
      msg.resultid = resultid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidSelectCardResultRes.id
    local msgParam = {}
    if resultid ~= nil then
      msgParam.resultid = resultid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidSelectCardHistoryResultCmd(resultids)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidSelectCardHistoryResultCmd()
    if resultids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.resultids == nil then
        msg.resultids = {}
      end
      for i = 1, #resultids do
        table.insert(msg.resultids, resultids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidSelectCardHistoryResultCmd.id
    local msgParam = {}
    if resultids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.resultids == nil then
        msgParam.resultids = {}
      end
      for i = 1, #resultids do
        table.insert(msgParam.resultids, resultids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidSelectCardResetCmd()
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidSelectCardResetCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidSelectCardResetCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallRaidNewResetCmd()
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.RaidNewResetCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RaidNewResetCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallAbyssDragonInfoNtfRaidCmd(dragon_stage, stage_start_time, activity_start_time)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.AbyssDragonInfoNtfRaidCmd()
    if dragon_stage ~= nil then
      msg.dragon_stage = dragon_stage
    end
    if stage_start_time ~= nil then
      msg.stage_start_time = stage_start_time
    end
    if activity_start_time ~= nil then
      msg.activity_start_time = activity_start_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonInfoNtfRaidCmd.id
    local msgParam = {}
    if dragon_stage ~= nil then
      msgParam.dragon_stage = dragon_stage
    end
    if stage_start_time ~= nil then
      msgParam.stage_start_time = stage_start_time
    end
    if activity_start_time ~= nil then
      msgParam.activity_start_time = activity_start_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallAbyssDragonHpUpdateRaidCmd(dragon_hp, dragon_maxhp)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.AbyssDragonHpUpdateRaidCmd()
    if dragon_hp ~= nil then
      msg.dragon_hp = dragon_hp
    end
    if dragon_maxhp ~= nil then
      msg.dragon_maxhp = dragon_maxhp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonHpUpdateRaidCmd.id
    local msgParam = {}
    if dragon_hp ~= nil then
      msgParam.dragon_hp = dragon_hp
    end
    if dragon_maxhp ~= nil then
      msgParam.dragon_maxhp = dragon_maxhp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallAbyssDragonOnOffRaidCmd(onoff)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.AbyssDragonOnOffRaidCmd()
    if onoff ~= nil then
      msg.onoff = onoff
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonOnOffRaidCmd.id
    local msgParam = {}
    if onoff ~= nil then
      msgParam.onoff = onoff
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:CallAbyssDragonDamageRankRaidCmd(rank_data)
  if not NetConfig.PBC then
    local msg = RaidCmd_pb.AbyssDragonDamageRankRaidCmd()
    if rank_data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rank_data == nil then
        msg.rank_data = {}
      end
      for i = 1, #rank_data do
        table.insert(msg.rank_data, rank_data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonDamageRankRaidCmd.id
    local msgParam = {}
    if rank_data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rank_data == nil then
        msgParam.rank_data = {}
      end
      for i = 1, #rank_data do
        table.insert(msgParam.rank_data, rank_data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceRaidCmdAutoProxy:RecvQueryRaidPuzzleListRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdQueryRaidPuzzleListRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzleActionRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleActionRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzleDataUpdateRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleDataUpdateRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzlePushObjRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzlePushObjRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzleRotateObjRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleRotateObjRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzleObjChangeNtfRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleObjChangeNtfRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzleElevatorRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleElevatorRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzlePosRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzlePosRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidPuzzleRoomIconRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidPuzzleRoomIconRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientSummonCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientSummonCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientNpcDieCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientNpcDieCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientTreasureBoxCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientTreasureBoxCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientSaveCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientSaveCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientSaveResultCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientSaveResultCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientQueryRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientQueryRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvPersonalRaidEnterCmd(data)
  self:Notify(ServiceEvent.RaidCmdPersonalRaidEnterCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvClientRaidAchRewardCmd(data)
  self:Notify(ServiceEvent.RaidCmdClientRaidAchRewardCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvHeadwearActivityNpcUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityNpcUserCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvHeadwearActivityRoundUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityRoundUserCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvHeadwearActivityTowerUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityTowerUserCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvQueryHeadwearActivityRewardRecordCmd(data)
  self:Notify(ServiceEvent.RaidCmdQueryHeadwearActivityRewardRecordCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvHeadwearActivityEndUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityEndUserCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvHeadwearActivityRangeUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityRangeUserCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvHeadwearActivityOpenUserCmd(data)
  self:Notify(ServiceEvent.RaidCmdHeadwearActivityOpenUserCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidOptionalCardCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidOptionalCardCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidSelectCardResultCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidSelectCardResultCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidSelectCardResultRes(data)
  self:Notify(ServiceEvent.RaidCmdRaidSelectCardResultRes, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidSelectCardHistoryResultCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidSelectCardHistoryResultCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidSelectCardResetCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidSelectCardResetCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvRaidNewResetCmd(data)
  self:Notify(ServiceEvent.RaidCmdRaidNewResetCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvAbyssDragonInfoNtfRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdAbyssDragonInfoNtfRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvAbyssDragonHpUpdateRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdAbyssDragonHpUpdateRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvAbyssDragonOnOffRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdAbyssDragonOnOffRaidCmd, data)
end

function ServiceRaidCmdAutoProxy:RecvAbyssDragonDamageRankRaidCmd(data)
  self:Notify(ServiceEvent.RaidCmdAbyssDragonDamageRankRaidCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.RaidCmdQueryRaidPuzzleListRaidCmd = "ServiceEvent_RaidCmdQueryRaidPuzzleListRaidCmd"
ServiceEvent.RaidCmdRaidPuzzleActionRaidCmd = "ServiceEvent_RaidCmdRaidPuzzleActionRaidCmd"
ServiceEvent.RaidCmdRaidPuzzleDataUpdateRaidCmd = "ServiceEvent_RaidCmdRaidPuzzleDataUpdateRaidCmd"
ServiceEvent.RaidCmdRaidPuzzlePushObjRaidCmd = "ServiceEvent_RaidCmdRaidPuzzlePushObjRaidCmd"
ServiceEvent.RaidCmdRaidPuzzleRotateObjRaidCmd = "ServiceEvent_RaidCmdRaidPuzzleRotateObjRaidCmd"
ServiceEvent.RaidCmdRaidPuzzleObjChangeNtfRaidCmd = "ServiceEvent_RaidCmdRaidPuzzleObjChangeNtfRaidCmd"
ServiceEvent.RaidCmdRaidPuzzleElevatorRaidCmd = "ServiceEvent_RaidCmdRaidPuzzleElevatorRaidCmd"
ServiceEvent.RaidCmdRaidPuzzlePosRaidCmd = "ServiceEvent_RaidCmdRaidPuzzlePosRaidCmd"
ServiceEvent.RaidCmdRaidPuzzleRoomIconRaidCmd = "ServiceEvent_RaidCmdRaidPuzzleRoomIconRaidCmd"
ServiceEvent.RaidCmdClientSummonCmd = "ServiceEvent_RaidCmdClientSummonCmd"
ServiceEvent.RaidCmdClientNpcDieCmd = "ServiceEvent_RaidCmdClientNpcDieCmd"
ServiceEvent.RaidCmdClientTreasureBoxCmd = "ServiceEvent_RaidCmdClientTreasureBoxCmd"
ServiceEvent.RaidCmdClientSaveCmd = "ServiceEvent_RaidCmdClientSaveCmd"
ServiceEvent.RaidCmdClientSaveResultCmd = "ServiceEvent_RaidCmdClientSaveResultCmd"
ServiceEvent.RaidCmdClientQueryRaidCmd = "ServiceEvent_RaidCmdClientQueryRaidCmd"
ServiceEvent.RaidCmdPersonalRaidEnterCmd = "ServiceEvent_RaidCmdPersonalRaidEnterCmd"
ServiceEvent.RaidCmdClientRaidAchRewardCmd = "ServiceEvent_RaidCmdClientRaidAchRewardCmd"
ServiceEvent.RaidCmdHeadwearActivityNpcUserCmd = "ServiceEvent_RaidCmdHeadwearActivityNpcUserCmd"
ServiceEvent.RaidCmdHeadwearActivityRoundUserCmd = "ServiceEvent_RaidCmdHeadwearActivityRoundUserCmd"
ServiceEvent.RaidCmdHeadwearActivityTowerUserCmd = "ServiceEvent_RaidCmdHeadwearActivityTowerUserCmd"
ServiceEvent.RaidCmdQueryHeadwearActivityRewardRecordCmd = "ServiceEvent_RaidCmdQueryHeadwearActivityRewardRecordCmd"
ServiceEvent.RaidCmdHeadwearActivityEndUserCmd = "ServiceEvent_RaidCmdHeadwearActivityEndUserCmd"
ServiceEvent.RaidCmdHeadwearActivityRangeUserCmd = "ServiceEvent_RaidCmdHeadwearActivityRangeUserCmd"
ServiceEvent.RaidCmdHeadwearActivityOpenUserCmd = "ServiceEvent_RaidCmdHeadwearActivityOpenUserCmd"
ServiceEvent.RaidCmdRaidOptionalCardCmd = "ServiceEvent_RaidCmdRaidOptionalCardCmd"
ServiceEvent.RaidCmdRaidSelectCardResultCmd = "ServiceEvent_RaidCmdRaidSelectCardResultCmd"
ServiceEvent.RaidCmdRaidSelectCardResultRes = "ServiceEvent_RaidCmdRaidSelectCardResultRes"
ServiceEvent.RaidCmdRaidSelectCardHistoryResultCmd = "ServiceEvent_RaidCmdRaidSelectCardHistoryResultCmd"
ServiceEvent.RaidCmdRaidSelectCardResetCmd = "ServiceEvent_RaidCmdRaidSelectCardResetCmd"
ServiceEvent.RaidCmdRaidNewResetCmd = "ServiceEvent_RaidCmdRaidNewResetCmd"
ServiceEvent.RaidCmdAbyssDragonInfoNtfRaidCmd = "ServiceEvent_RaidCmdAbyssDragonInfoNtfRaidCmd"
ServiceEvent.RaidCmdAbyssDragonHpUpdateRaidCmd = "ServiceEvent_RaidCmdAbyssDragonHpUpdateRaidCmd"
ServiceEvent.RaidCmdAbyssDragonOnOffRaidCmd = "ServiceEvent_RaidCmdAbyssDragonOnOffRaidCmd"
ServiceEvent.RaidCmdAbyssDragonDamageRankRaidCmd = "ServiceEvent_RaidCmdAbyssDragonDamageRankRaidCmd"
